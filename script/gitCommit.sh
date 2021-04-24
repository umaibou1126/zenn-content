#!/usr/bin/env bash

set -euo pipefail

function main() {
    git add -A
    git commit -m "fix newArticle"
    git push origin master
}

main
