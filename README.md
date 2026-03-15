# learn 2.11BSD Modern Port Bundle

Patch, bootstrap scripts, and documentation for building a modern local copy of
the historical 2.11BSD `learn` program, without shipping the original source
tree or lesson files in this repository.

## Status

- Bootstrap verified on a modern Unix-like system with a current Clang toolchain.
- Historical sources and lessons are fetched from public archives.
- This repository is intended to publish only original porting work.

## Prerequisites

- POSIX shell utilities: `sh`, `cp`, `rm`, `mkdir`, `find`, `sed`
- build tools: `cc`, `make`, `patch`
- download tool: `curl`
- a `vi`-compatible editor available on `PATH` as `vi` for the `vi` course
- enough local space for the fetched sources, lesson tree, and generated build output

## Quick Start

```sh
cd learn-211bsd-modern-port
./scripts/bootstrap.sh

# start learn
./work/bin/learn

# or start a specific course
./work/bin/learn C
./work/bin/learn files
./work/bin/learn editor
./work/bin/learn vi
```

To force a full rebuild of generated sources, binaries, and the fetched lesson
tree, run:

```sh
./scripts/bootstrap.sh --clean
```

## Install

To install `learn` and its lesson tree under `/usr/local`:

```sh
./scripts/install.sh
```

This installs:

- `learn` to `/usr/local/bin/learn`
- the lesson tree and helper binaries to `/usr/local/share/learn`

If `/usr/local` is not writable for your user, run it with elevated privileges.

To install under a different prefix:

```sh
./scripts/install.sh --prefix /opt/learn
```

For staged installs:

```sh
./scripts/install.sh --prefix /usr/local --destdir /tmp/package-root
```

## Repository Scope

This repository contains:

- the modern port patch;
- fetch scripts for the historical sources and lesson tree;
- bootstrap/build scripts;
- install script;
- documentation and attribution notes.

This repository does not contain:

- the original 2.11BSD `learn` sources;
- the original lesson files;
- compiled binaries;
- local mirrors of the historical files.

## Bootstrap Steps

1. Downloads the original 2.11BSD `learn` sources into `work/orig/`.
2. Applies the porting patch and creates a patched source tree in `work/src/`.
3. Builds `learn`, `lrntee`, and `lcount`, then copies them to `work/bin/`.
4. Downloads the historical lesson tree into `runtime/share/learn/`.
5. Installs the binaries into `runtime/share/learn/bin/`.

Passing `--clean` removes existing generated `work/` and `runtime/` content
before running the bootstrap steps above.

## Historical sources

- [usr.bin/learn](https://www.retro11.de/ouxr/211bsd/usr/src/usr.bin/learn/)
- [lesson tree](https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/)
- [historical manual page](https://man.freebsd.org/cgi/man.cgi?query=learn&manpath=2.9.1+BSD)
- [alternative Docker-based project](https://github.com/goblimey/learn-unix)

## License

- [LICENSE](LICENSE) applies only to the patch, scripts, and documentation present in this repository.
- Historical files downloaded during bootstrap are not covered by the repository BSD-2-Clause license.
- Before redistributing fetched material, review the original notices included in those files or in the corresponding historical archives.

## Notes

- The `C` course includes support files (`getline.c`, `getnum.c`) that collide with modern standard-library symbols; the bootstrap script compiles them with a local rename only to generate the objects required by the lessons.
- Generated patched sources live in `work/src/`; generated runnable binaries live in `work/bin/`.
- Not every interactive course has been validated end-to-end on modern Unix-like systems.
