#!/bin/bash
set -e
set -o pipefail
export HUSKY=0
run_all() {
  local start_path;
  start_path="$(pwd)"
  local tmp_root;
  tmp_root="$(mktemp -d)"
  echo 'Copy patch files to checkout...'
  cp ./*.patch lit/
  echo "Move repo to $tmp_root/lit"
  cd "$tmp_root" || exit
  mv "$start_path/lit" .
  cd lit || exit
  echo 'Initialize a git repo...'
  git init
  echo 'Applying patches...'
  git apply -v ./*.patch
  echo "$start_path/../../../../mach npm ci..."
  "$start_path"/../../../../mach npm ci
  echo "$start_path/../../../../mach npm run build..."
  "$start_path"/../../../../mach npm run build
  echo "Copying back to $start_path"
  cd "$start_path" || exit
  cp "$tmp_root/lit/packages/lit/lit-all.min.js" ../../widgets/vendor/lit.all.mjs
  mkdir lit
  cp "$tmp_root/lit/LICENSE" lit/
  local lit_version;
  lit_version="$(grep -o '"version": ".*",' "$tmp_root/lit/packages/lit/package.json" | cut -d\" -f4)"
  cd ../../../../
  ./mach npm install "lit@$lit_version" --save-dev --save-exact
  rm -rf "$tmp_root"
}
run_all
