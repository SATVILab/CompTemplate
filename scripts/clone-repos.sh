#!/usr/bin/env bash
# clone-repos.sh — Simple, portable multi-repo cloner (Linux, macOS, WSL, Git Bash)
# Compatible with Bash ≥3.2 (default on macOS)

set -e

# --- Prerequisite checks -----------------------------------------------------
check_prerequisites() {
    for cmd in git; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Error: '$cmd' is required but not found in PATH." >&2
            exit 1
        fi
    done
}

# --- Usage -------------------------------------------------------------------
usage() {
    cat <<'EOF'
Usage: clone-multirepos.sh [--file <repo-list>]

Clone all repositories listed in <repo-list> (default: repos.list).
Each non-empty, non-comment line describes ONE clone.

Line format (order-agnostic after repo_spec):
  repo_spec [target_directory] [-a|--all-branches]

Where:
  repo_spec         owner/repo[@ref]  OR  https://host/owner/repo[@ref]
                    (@ref may be a branch or tag; if omitted, the remote default branch is used)
  target_directory  (optional) directory to clone into (relative to the parent of the CWD).
                    Tokens beginning with '-' are treated as options, not directories.
                    If you really need a directory starting with '-', write it as './-name'.
  -a|--all-branches (optional) fetch all branches (opt out of single-branch default)

Default behaviour:
  • Single-branch clone: only the specified ref (or the remote default branch).
  • Add '-a' (anywhere after repo_spec) on a line to fetch all branches for that repo.

Examples:
  user1/repo1
  user2/repo2@dev ./src
  https://gitlab.com/u/r@main ./gitlab
  SATVILab/projr -a
  SATVILab/stimgate ./stimgate -a
  SATVILab/utils -a ./utils-full
  SATVILab/weird ./-target-name

Notes:
  • Lines that are blank or whose first non-space character is '#' are ignored.
  • Single-branch clones can still fetch/switch to other branches later with 'git fetch'.
EOF
}

# --- Argument parsing --------------------------------------------------------
parse_args() {
    if [ ! -f "repos.list" ] && [ -f "repos-to-clone.list" ]; then
        REPOS_FILE="repos-to-clone.list"
    else
        REPOS_FILE="repos.list"
    fi

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -f|--file)
                shift
                [ "$#" -gt 0 ] && REPOS_FILE="$1" || { usage; exit 1; }
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown argument: $1" >&2
                usage
                exit 1
                ;;
        esac
    done

    if [ ! -f "$REPOS_FILE" ]; then
        echo "File '$REPOS_FILE' not found." >&2
        exit 1
    fi
}

# --- Helpers -----------------------------------------------------------------
parse_repo_line() {
    # Echoes: repo_spec target_dir all_branches
    # Rules:
    #   - First token is repo_spec.
    #   - After that, any token starting with '-' is treated as an option.
    #   - Recognised options: -a | --all-branches
    #   - The first non-option token is target_dir (must not start with '-').
    #   - Unknown options are warned and ignored.
    set -f                     # disable globbing
    local line="$1"
    local repo_spec target_dir="" all_branches=0

    set -- $line
    [ "$#" -eq 0 ] && { printf '%s\x1f%s\x1f%s\n' "" "" "0"; set +f; return 0; }

    repo_spec="$1"; shift
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -a|--all-branches) all_branches=1 ;;
            -*) echo "Warning: ignoring unknown option '$1' on line: $line" >&2 ;;
            *)  if [ -z "$target_dir" ]; then target_dir="$1"
                else echo "Error: multiple target directories on one line: $line" >&2; set +f; return 1
                fi ;;
        esac
        shift
    done
    printf '%s\x1f%s\x1f%s\n' "$repo_spec" "$target_dir" "$all_branches"
    set +f                     # re-enable globbing
}

clone_one_repo() {
    # Args: repo_spec target_dir base_dir all_branches
    local repo_spec="$1" target_dir="$2" base_dir="$3" all_branches="$4"

    # Split out @ref (branch/tag) if present
    local repo_url_no_ref ref
    case "$repo_spec" in
        *@*) repo_url_no_ref="${repo_spec%@*}"; ref="${repo_spec##*@}" ;;
        *)   repo_url_no_ref="$repo_spec"; ref="" ;;
    esac

    # Determine remote URL and default local folder name
    local repo_url repo_dir
    case "$repo_url_no_ref" in
        https://*)
            repo_url="$repo_url_no_ref"
            repo_dir=$(basename "${repo_url_no_ref%.git}")
            ;;
        *)
            repo_url="https://github.com/$repo_url_no_ref"
            repo_dir="${repo_url_no_ref#*/}"
            ;;
    esac

    # Compute final destination
    local dest
    if [ -n "$target_dir" ]; then
        dest="$base_dir/$target_dir"
    else
        dest="$base_dir/$repo_dir"
    fi

    # Skip if already there
    if [ -d "$dest/.git" ]; then
        echo "Already exists: $dest"
        return 0
    fi

    # Ensure parent exists; allow cloning into an empty existing dir
    mkdir -p "$dest"
    if [ -n "$(ls -A "$dest" 2>/dev/null)" ]; then
        echo "Error: destination '$dest' exists and is not empty." >&2
        return 1
    fi

    # Build clone options (arrays are fine in Bash 3.2)
    local clone_opts=()
    if [ "${all_branches:-0}" -eq 0 ]; then
        clone_opts=(--single-branch)
    fi
    [ -n "$ref" ] && clone_opts=("${clone_opts[@]}" --branch "$ref")

    git clone "${clone_opts[@]}" "$repo_url" "$dest"
}

# --- Main --------------------------------------------------------------------
main() {
    check_prerequisites
    parse_args "$@"

    local start_dir parent_dir
    start_dir="$(pwd)"
    parent_dir="$(dirname "$start_dir")"

    while IFS= read -r line || [ -n "$line" ]; do
        # lstrip
        local trimmed="${line#"${line%%[![:space:]]*}"}"
        # strip inline comments and rstrip
        trimmed="${trimmed%%#*}"
        trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
        trimmed=${trimmed%$'\r'}  # handle CRLF

        # Skip blanks
        [ -z "$trimmed" ] && continue

        # Parse
        local parsed
        if ! parsed="$(parse_repo_line "$trimmed")"; then
            echo "Failed to parse line: $line" >&2
            exit 1
        fi

        # Unpack (preserves empties)
        IFS=$'\x1f' read -r repo_spec target_dir all_branches <<<"$parsed"
        [ -z "$repo_spec" ] && continue

        clone_one_repo "$repo_spec" "$target_dir" "$parent_dir" "$all_branches"
    done <"$REPOS_FILE"
}


main "$@"
