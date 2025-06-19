#!/usr/bin/env bash
# clone-multirepos.sh — Simple, portable multi-repo cloner (Linux, Mac, WSL, Git Bash)

set -e

# --- Prerequisite checks ---
if ! command -v git >/dev/null 2>&1; then
  echo "Error: 'git' is not installed or not in PATH." >&2
  exit 1
fi

if ! command -v awk >/dev/null 2>&1; then
  echo "Error: 'awk' is required but not found in PATH." >&2
  exit 1
fi

usage() {
  cat <<EOF
Usage: $0 [--file <repo-list>]

Clone all repositories listed in <repo-list> (default: repos-to-clone.list).
Format per line: [repo_spec] [target_directory]
- repo_spec: owner/repo[@branch] OR https://host/owner/repo[@branch]
- target_directory: (optional) folder to clone into (relative to CWD).

Examples:
  user1/repo1
  user2/repo2@dev ./src
  https://github.com/user3/repo3@main ./github
EOF
}

# Default file
repos_file="repos-to-clone.list"

# Arg parsing (POSIX)
while [ "$#" -gt 0 ]; do
  case "$1" in
    -f|--file)
      shift
      [ "$#" -gt 0 ] && repos_file="$1" || { usage; exit 1; }
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1"
      usage
      exit 1
      ;;
  esac
done

[ -f "$repos_file" ] || { echo "File '$repos_file' not found."; exit 1; }

start_dir="$(pwd)"

# read the repo list
while IFS= read -r line || [ -n "$line" ]; do
  # Skip comments/empty lines
  case "$line" in \#*|"") continue ;; esac

  # Parse repo_spec and target_dir (POSIX)
  repo_spec=$(echo "$line" | awk '{print $1}')
  target_dir=$(echo "$line" | awk '{print $2}')

  [ -z "$repo_spec" ] && continue

  # Parse @branch if present
  case "$repo_spec" in
    *@*) repo_url_no_branch="${repo_spec%@*}"; branch="${repo_spec##*@}" ;;
    *) repo_url_no_branch="$repo_spec"; branch="" ;;
  esac

  # Compute remote and default folder
  case "$repo_url_no_branch" in
    https://*) repo_url="$repo_url_no_branch"
               repo_dir=$(basename "$repo_url_no_branch" .git)
               ;;
    *)
      # Assume GitHub by default, datasets/ prefix for Hugging Face
      case "$repo_url_no_branch" in
        datasets/*)
          host="https://huggingface.co"
          repo_url="$host/$repo_url_no_branch"
          repo_dir="${repo_url_no_branch#datasets/}"
          ;;
        *)
          host="https://github.com"
          repo_url="$host/$repo_url_no_branch"
          repo_dir="${repo_url_no_branch#*/}"
          ;;
      esac
      ;;
  esac

  # Use provided or default target dir
  if [ -n "$target_dir" ]; then
    dest="$start_dir/$target_dir"
  else
    dest="$start_dir"
  fi

  mkdir -p "$dest"
  cd "$dest"

  # Clone or update
  if [ ! -d "$repo_dir" ]; then
    if [ -n "$branch" ]; then
      git clone -b "$branch" "$repo_url"
    else
      git clone "$repo_url"
    fi
  else
    echo "Already exists: $dest/$repo_dir"
    # Optionally: git pull/update here if you want
  fi

  cd "$start_dir"
done < "$repos_file"
