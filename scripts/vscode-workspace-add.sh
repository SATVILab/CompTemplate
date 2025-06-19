#!/usr/bin/env bash

set -e

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  -f, --file <file>       Specify the repository list file (default: 'repos-to-clone.list').
  -h, --help              Display this help message.

Each line in the repository list file can be in the following formats:
  repo_spec [target_directory]

Where repo_spec is one of:
  owner/repo[@branch]
  datasets/owner/repo[@branch]
  https://<host>/owner/repo[@branch]

Examples:
  user1/project1
  user2/project2@develop ./Projects/Repo2
  datasets/user3/dataset1@main ../Datasets
  https://gitlab.com/user4/project4@feature-branch ./GitLabRepos
EOF
}

# Default values
repos_list_file="repos-to-clone.list"

# POSIX-style arg parsing
while [ "$#" -gt 0 ]; do
  case "$1" in
    -f|--file)
      shift
      if [ "$#" -gt 0 ]; then
        repos_list_file="$1"
        shift
      else
        usage
        exit 1
      fi
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [ ! -f "$repos_list_file" ]; then
  echo "Repository list file '$repos_list_file' not found."
  exit 1
fi

current_dir="$(pwd)"
workspace_file="$current_dir/entire-project.code-workspace"

# If the workspace file doesn’t exist, create a pretty-printed JSON stub
if [ ! -f "$workspace_file" ]; then
  # only if there’s at least one non-blank, non-comment line
  if grep -qv '^[[:space:]]*$' "$repos_list_file" && grep -qv '^[[:space:]]*#' "$repos_list_file"; then
    cat > "$workspace_file" <<EOF
{
  "folders": [
    { "path": "." }
  ]
}
EOF
    echo "Created new workspace file: $workspace_file"
  fi
fi

add_to_workspace() {
  local repos_file="$1"
  local line repo_spec target_dir repo_url_no_branch dir repo_path relative_repo_path

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ''|\#*) continue ;; esac
    line="$(printf '%s\n' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    [ -z "$line" ] && continue

    repo_spec="$(printf '%s\n' "$line" | awk '{print $1}')"
    target_dir="$(printf '%s\n' "$line" | awk '{print $2}')"
    case "$repo_spec" in *@*) repo_url_no_branch="${repo_spec%@*}" ;; *) repo_url_no_branch="$repo_spec" ;; esac
    dir="$(basename "$repo_url_no_branch" .git)"

    if [ -n "$target_dir" ]; then
      repo_path="$current_dir/$target_dir/$dir"
    else
      repo_path="$current_dir/$dir"
    fi

    if command -v realpath >/dev/null 2>&1 && realpath --help 2>&1 | grep -q -- --relative-to; then
      relative_repo_path="$(realpath --relative-to="$current_dir" "$repo_path" 2>/dev/null || printf '%s\n' "$repo_path")"
    else
      case "$repo_path" in
        "$current_dir"/*) relative_repo_path="${repo_path#$current_dir/}" ;;
        *)                relative_repo_path="$repo_path" ;;
      esac
    fi

    if grep -q "\"path\"[[:space:]]*:[[:space:]]*\"$relative_repo_path\"" "$workspace_file"; then
      continue
    fi

    sed -i.bak '/^[[:space:]]*]/i\
    { "path": "'"$relative_repo_path"'" },' "$workspace_file" \
     && rm -f "${workspace_file}.bak"

    echo "Added '$relative_repo_path' to $workspace_file"
  done < "$repos_file"
}


add_to_workspace "$repos_list_file"
