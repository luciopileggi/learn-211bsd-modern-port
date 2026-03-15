#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
PREFIX="/usr/local"
DESTDIR=""

while [ "$#" -gt 0 ]; do
	case "$1" in
		--prefix)
			if [ "$#" -lt 2 ]; then
				printf '%s\n' "missing value for --prefix" >&2
				exit 2
			fi
			PREFIX="$2"
			shift 2
			;;
		--destdir)
			if [ "$#" -lt 2 ]; then
				printf '%s\n' "missing value for --destdir" >&2
				exit 2
			fi
			DESTDIR="$2"
			shift 2
			;;
		*)
			printf '%s\n' "usage: $0 [--prefix PREFIX] [--destdir DESTDIR]" >&2
			exit 2
			;;
	esac
done

if [ ! -x "$ROOT/work/bin/learn" ] || [ ! -d "$ROOT/runtime/share/learn" ]; then
	printf '%s\n' "bootstrap output not found; run ./scripts/bootstrap.sh first" >&2
	exit 1
fi

bindir="$DESTDIR$PREFIX/bin"
sharedir="$DESTDIR$PREFIX/share/learn"
runprefix="$PREFIX/share/learn"

mkdir -p "$bindir" "$sharedir/bin"

cp "$ROOT/work/bin/learn" "$sharedir/bin/learn"
chmod 755 "$sharedir/bin/learn"

cp "$ROOT/work/bin/lrntee" "$sharedir/bin/lrntee"
cp "$ROOT/work/bin/lcount" "$sharedir/bin/lcount"
chmod 755 "$sharedir/bin/lrntee" "$sharedir/bin/lcount"

find "$ROOT/runtime/share/learn" -mindepth 1 -maxdepth 1 ! -name bin -exec cp -R {} "$sharedir/" \;
find "$sharedir" -name Init -type f -exec chmod 555 {} \;

cat > "$bindir/learn" <<EOF
#!/bin/sh
exec "$runprefix/bin/learn" "-$runprefix" "\$@"
EOF
chmod 755 "$bindir/learn"

printf '%s\n' "Installed learn to $bindir/learn"
printf '%s\n' "Installed lessons to $sharedir"
