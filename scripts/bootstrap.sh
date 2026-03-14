#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

"$ROOT/scripts/fetch-sources.sh"
rm -rf "$ROOT/work/port"
cp -R "$ROOT/work/orig" "$ROOT/work/port"
sed \
	-e 's@^diff -ruN orig/@diff -ruN a/@' \
	-e 's@^--- orig/@--- a/@' \
	-e 's@^+++ port/@+++ b/@' \
	"$ROOT/patches/learn-211bsd-modern.patch" | patch -d "$ROOT/work/port" -p1

make -C "$ROOT/work/port" clean all

"$ROOT/scripts/fetch-lessons.sh"

find "$ROOT/runtime/share/learn" -name Init -type f -exec chmod 555 {} \;

mkdir -p "$ROOT/runtime/share/learn/bin"
cp \
	"$ROOT/work/port/learn" \
	"$ROOT/work/port/lrntee" \
	"$ROOT/work/port/lcount" \
	"$ROOT/runtime/share/learn/bin/"

cc -std=gnu89 -Dgetline=learn_getline -c \
	"$ROOT/runtime/share/learn/C/getline.c" \
	-o "$ROOT/runtime/share/learn/C/getline.o" 2>/dev/null || {
	sed 's/^getline(/learn_getline(/' \
		"$ROOT/runtime/share/learn/C/getline.c" > "$ROOT/runtime/share/learn/C/.getline-modern.c"
	cc -std=gnu89 -c \
		"$ROOT/runtime/share/learn/C/.getline-modern.c" \
		-o "$ROOT/runtime/share/learn/C/getline.o"
	rm -f "$ROOT/runtime/share/learn/C/.getline-modern.c"
}
cc -std=gnu89 -c \
	"$ROOT/runtime/share/learn/C/getnum.c" \
	-o "$ROOT/runtime/share/learn/C/getnum.o"

printf '%s\n' "Bootstrap completo. Avvio: $ROOT/work/port/run.sh C"
