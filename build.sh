#!/usr/bin/env bash
set -e

REPO=tophfr/akamai
targets=$(grep -E "^FROM .* AS " build/Dockerfile | sed -E 's/^FROM .* AS //' | grep -v _)

for target in $targets; do
    set -x
    docker build -t "$REPO:$target" --target "$target" build
    { set +x; } 2>/dev/null
done

aliases="
pm:snippets
property-manager:snippets
pl:pipeline
fw:firewall
ss:site-shield
mp:mpulse
a2:adaptive-acceleration
vp:visitor-prioritization
im:image-manager
latest:all
"

for line in $aliases; do
    alias=${line%:*}
    target=${line#*:}
    set -x
    docker tag "$REPO:$target" "$REPO:$alias"
    { set +x; } 2>/dev/null
done

[ "$1" != '--push' ] && exit

for target in $targets; do
    set -x
    docker push "$REPO:$target"
    { set +x; } 2>/dev/null
done
for line in $aliases; do
    alias=${line%:*}
    set -x
    docker push "$REPO:$alias"
    { set +x; } 2>/dev/null
done
