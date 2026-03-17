#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/runtime"
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

rm -rf "$OUT/share/learn"
mkdir -p "$OUT"

case "$SOURCE" in
	retro11)
		wget \
			-r \
			-np \
			-nH \
			--cut-dirs=4 \
			-R 'index.html*' \
			-P "$OUT" \
			https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/
		;;
	tuhs)
		TMPDIR="$(mktemp -d "$ROOT/work/fetch-lessons-tuhs.XXXXXX")"
		trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM
		for archive in file6.tar.gz file7.tar.gz file8.tar.gz
		do
			curl -fsSL \
				"https://www.tuhs.org/Archive/Distributions/UCB/$TUHS_RELEASE/$archive" \
				-o "$TMPDIR/$archive"
			tar -xzf "$TMPDIR/$archive" -C "$TMPDIR" share/learn 2>/dev/null || true
		done
		if [ ! -d "$TMPDIR/share/learn" ]; then
			printf '%s\n' "failed to extract share/learn from TUHS 2.11BSD archives" >&2
			exit 1
		fi
		mkdir -p "$OUT/share"
		cp -R "$TMPDIR/share/learn" "$OUT/share/learn"
		rm -rf "$TMPDIR"
		trap - EXIT HUP INT TERM
		;;
	*)
		printf '%s\n' "unknown source: $SOURCE" >&2
		exit 2
		;;
esac

mkdir -p "$ROOT/runtime/share/learn/bin" "$ROOT/runtime/log"
