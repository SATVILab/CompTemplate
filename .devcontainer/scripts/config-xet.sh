
echo " "
echo "==================="
echo "run config-xet.sh"
echo "-------------------"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 

# install xet
"$project_root/.devcontainer/scripts/install-xet.sh"

# authenticate to xet
"$project_root/.devcontainer/scripts/authenticate-xethub.sh"
