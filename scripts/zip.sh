# Script to compress the datasets used in the project to save storage

find ../data -mindepth 1 -maxdepth 1 -execdir zip -r '{}'.zip '{}' \;
find ../data ! -iname "*.zip" -mindepth 1 -maxdepth 1 -exec rm -r "{}" \;
