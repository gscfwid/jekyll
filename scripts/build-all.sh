#!/usr/bin/env bash

set -eo pipefail

function buildJekyll () {
  pushd jekyll
  make build
  mv _site/sitemap.xml _site/sitemap-jekyll.xml
  popd
}

function buildManifest () {
  FILE=$1
  VERSION=$(npx pkg-jq -r .version)
  cat <<_POD_ > "$FILE"
{"version":"$VERSION"}
_POD_
}

target=$1

if [ -z "$target" ]; then
  >&2 echo "You need to provide a folder name to store the build artifact fles."
  exit 1
elif [ ! -d "$target" ]; then
  >&2 echo "$target directory not exist!"
  exit 1
fi

buildJekyll

cp -Rav jekyll/_site/* "$target"
rm -f "$target"/README.md
touch "$target"/.nojekyll
buildManifest "$target"/manifest.json
