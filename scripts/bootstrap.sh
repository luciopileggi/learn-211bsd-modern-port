#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

"$ROOT/scripts/fetch-sources.sh"
rm -rf "$ROOT/work/src" "$ROOT/work/bin"
mkdir -p "$ROOT/work/src" "$ROOT/work/bin"
sed \
	-e 's@^diff -ruN orig/@diff -ruN a/@' \
	-e 's@^--- orig/@--- a/@' \
	-e 's@^+++ port/@+++ b/@' \
	"$ROOT/patches/learn-211bsd-modern.patch" | patch -d "$ROOT/work/src" -p1

make -C "$ROOT/work/src" clean all

cp \
	"$ROOT/work/src/learn" \
	"$ROOT/work/src/lrntee" \
	"$ROOT/work/src/lcount" \
	"$ROOT/work/bin/"

"$ROOT/scripts/fetch-lessons.sh"

cat > "$ROOT/runtime/share/learn/vi/Init" <<'EOF'
#!/bin/sh
if [ -n "${TERM:-}" ]; then
	exit 0
fi
cat <<'MSG'
To do the lessons on 'vi', I need to know your terminal type, and your terminal
must have an "addressable cursor".  You can still use 'vi' (in something
called "open mode") on other kinds of terminals, but not with these lessons.

I will put you out of learn.  Find out the terminal type for the
terminal you are using (this may mean asking someone), then type

setenv TERM xxx
tset

where you replace xxx with your terminal type.

Some common types are:	TERMINAL MODEL		TERMINAL TYPE
			Televideo 912/920C	tvi920c
			Televideo 925		tvi925
			LSI adm3a		adm3a
			Zenith/Heathkit H19	h19
			Datamedia 1520		dm1520

When you are done type "learn vi" again.
MSG
exit 1
EOF

cat > "$ROOT/runtime/share/learn/eqn/Init" <<'EOF'
#!/bin/sh
if [ -n "${term:-}" ]; then
	exit 0
fi
cat <<'MSG'
To do the lessons on eqn you need to login at a
hardcopy terminal capable of half-line motions.
Then I need to know what kind of terminal you are using.
I will put you out of learn. Type the command

setenv term xxx			(that's term, not TERM)

where xxx is one of the following:

   300       382       450-12-8   a1        ipsi      xerox
   300-12    382-12    832        aj832     ipsi-12   xerox12
   300s      382cw     832-12     dtc       ipsi12
   300s-12   450       833        dtc-12    odtc-12
   tn300     450-12    833-12     ep40      x1700

Then type "learn eqn" again.
MSG
exit 1
EOF

find "$ROOT/runtime/share/learn/vi" -type f -name 'L*' -exec \
	sed -i.bak 's#/usr/share/learn/vi#%s#g' {} \;
find "$ROOT/runtime/share/learn/vi" -type f -name '*.bak' -delete

find "$ROOT/runtime/share/learn" -name Init -type f -exec chmod 555 {} \;

mkdir -p "$ROOT/runtime/share/learn/bin"
cp \
	"$ROOT/work/bin/learn" \
	"$ROOT/work/bin/lrntee" \
	"$ROOT/work/bin/lcount" \
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

printf '%s\n' "Bootstrap complete. Start with: $ROOT/work/bin/learn"
