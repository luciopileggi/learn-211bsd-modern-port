#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/orig"
BASE="https://www.retro11.de/ouxr/211bsd/usr/src/usr.bin/learn"

rm -rf "$OUT"
mkdir -p "$OUT"
cd "$OUT"

for f in \
	Makefile \
	README \
	copy.c \
	dounit.c \
	getlesson.c \
	lcount.c \
	learn.c \
	list.c \
	lrnref.h \
	lrntee.c \
	makpipe.c \
	maktee.c \
	mem.c \
	mysys.c \
	selsub.c \
	selunit.c \
	start.c \
	tee.c \
	whatnow.c \
	wrapup.c
do
	curl -fsSLO "$BASE/$f"
done
