# Script to unzip the datasets used in the project to save storage

find ../data -iname "*.zip" -mindepth 1 -maxdepth 1 -execdir unzip '{}' \;
find ../data -iname "*.zip" -mindepth 1 -maxdepth 1 -exec rm -r "{}" \;
