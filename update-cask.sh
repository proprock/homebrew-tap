#!/bin/sh
# Usage: update-cask.sh aherald vX.Y.Z — sets version and sha256 from the release's .dmg.sha256.
set -eu
cask=$1
tag=$2
case "$tag" in v[0-9]*) ;; *) echo "Not a release tag: $tag" >&2; exit 1 ;; esac
case "$tag" in *-*) echo "Pre-release $tag is not published to the cask." >&2; exit 2 ;; esac
version=${tag#v}
asset="aherald-$tag-macos-arm64.dmg.sha256"
sum=$(curl -fsSL "https://github.com/proprock/aHerald/releases/download/$tag/$asset" | awk '{print $1; exit}')
printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$' || { echo "Bad checksum for $asset" >&2; exit 1; }
file="$(dirname "$0")/Casks/$cask.rb"
sed -i.bak -e "s/^  version \".*\"/  version \"$version\"/" -e "s/^  sha256 \".*\"/  sha256 \"$sum\"/" "$file"
rm -f "$file.bak"
grep -q "version \"$version\"" "$file" && grep -q "sha256 \"$sum\"" "$file"
