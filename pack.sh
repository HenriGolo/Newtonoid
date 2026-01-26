set -euo pipefail

cd "$(dirname "$0")"

new_name="Duman_Crosnier_Rousseau_Fontaine"
tarname="$new_name.tar"

cd source
dune clean
cd ..
cp -r source "$new_name"
tar -cvzf "$tarname" "$new_name"/*
rm -fr "$new_name"
