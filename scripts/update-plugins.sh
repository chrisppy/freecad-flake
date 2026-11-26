#!/usr/bin/env bash
# Bump plugins that track a moving upstream tag (marked "# upstream-tag: <tag>")
# to the commit the tag points to now. Prints a markdown summary of changes.
set -euo pipefail

field() { sed -n "s/^  $1 = \"\(.*\)\";/\1/p" "$2"; }

for f in plugins/*.nix; do
  tag=$(sed -n 's/^  # upstream-tag: //p' "$f")
  [ -n "$tag" ] || continue
  owner=$(field owner "$f")
  repo=$(field repo "$f")
  rev=$(field rev "$f")

  # Prefer the peeled commit for annotated tags
  refs=$(git ls-remote "https://github.com/$owner/$repo" "refs/tags/$tag" "refs/tags/$tag^{}")
  new=$(awk '/\^\{\}$/ { print $1; found = 1 } END { if (!found) exit 1 }' <<<"$refs" \
    || awk 'NR == 1 { print $1 }' <<<"$refs")
  [ -n "$new" ] || { echo "warning: $owner/$repo has no tag $tag" >&2; continue; }
  [ "$new" = "$rev" ] && continue

  hash=$(nix flake prefetch --json "github:$owner/$repo/$new" | jq -r .hash)
  sed -i -e "s|^  rev = \"$rev\";|  rev = \"$new\";|" \
         -e "s|^  hash = \".*\";|  hash = \"$hash\";|" "$f"
  echo "- **$repo** ($tag): [\`${rev:0:7}\` → \`${new:0:7}\`](https://github.com/$owner/$repo/compare/$rev...$new)"
done
