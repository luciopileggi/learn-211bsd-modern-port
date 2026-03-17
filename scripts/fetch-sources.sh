#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/orig"
SOURCE="retro11"
TUHS_RELEASE="2.11BSD"

while [ "$#" -gt 0 ]; do
	case "$1" in
		--source)
			if [ "$#" -lt 2 ]; then
				printf '%s\n' "missing value for --source" >&2
				exit 2
			fi
			SOURCE="$2"
			shift 2
			;;
		--tuhs-release)
			if [ "$#" -lt 2 ]; then
				printf '%s\n' "missing value for --tuhs-release" >&2
				exit 2
			fi
			TUHS_RELEASE="$2"
			shift 2
			;;
		*)
			printf '%s\n' "usage: $0 [--source retro11|tuhs] [--tuhs-release release-dir]" >&2
			exit 2
			;;
	esac
done

rm -rf "$OUT"
mkdir -p "$OUT"

case "$SOURCE" in
	retro11)
		BASE="https://www.retro11.de/ouxr/211bsd/usr/src/usr.bin/learn"
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
		;;
	tuhs)
		TMPDIR="$(mktemp -d "$ROOT/work/fetch-sources-tuhs.XXXXXX")"
		trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM
		curl -fsSL \
			"https://www.tuhs.org/Archive/Distributions/UCB/$TUHS_RELEASE/file8.tar.gz" \
			-o "$TMPDIR/file8.tar.gz"
		tar -xzf "$TMPDIR/file8.tar.gz" -C "$TMPDIR" usr.bin/learn
		cp -R "$TMPDIR/usr.bin/learn/." "$OUT/"
		rm -rf "$TMPDIR"
		trap - EXIT HUP INT TERM
		;;
	*)
		printf '%s\n' "unknown source: $SOURCE" >&2
		exit 2
		;;
esac
