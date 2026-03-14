#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/runtime"

mkdir -p "$OUT"

wget \
	-r \
	-np \
	-nH \
	--cut-dirs=4 \
	-R 'index.html*' \
	-P "$OUT" \
	https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/

mkdir -p "$ROOT/runtime/share/learn/bin" "$ROOT/runtime/log"
