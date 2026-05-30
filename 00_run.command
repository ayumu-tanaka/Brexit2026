#!/bin/bash

# このファイルは macOS でダブルクリック起動するための薄いラッパーです
# 実際の処理は 00_run.sh が行います

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
exec ./00_run.sh "$@"
