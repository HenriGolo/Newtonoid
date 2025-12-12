set -euo pipefail

cd "$(dirname "$0")"

tarname="rendu.tar"

cd source
dune clean
cd ..
tar -cvzf "${tarname}" source/*