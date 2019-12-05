#!/usr/bin/env bash

REPO=tophfr/akamai
targets=$(grep -E "^FROM .* AS " build/Dockerfile | sed -E 's/^FROM .* AS //')

for target in $targets; do
    echo -n "$target: "
    docker run --rm -i "$REPO:$target" >/dev/null 2>/dev/null && echo ok || echo ko
done

