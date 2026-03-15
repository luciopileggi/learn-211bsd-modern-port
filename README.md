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

## Repository Scope

This repository contains:

- the modern port patch;
- fetch scripts for the historical sources and lesson tree;
- bootstrap/build scripts;
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

## Historical sources

- `usr.bin/learn`: `https://www.retro11.de/ouxr/211bsd/usr/src/usr.bin/learn/`
- lesson tree: `https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/`

## License

- [LICENSE](/Users/lucio/Documents/Projects/Hacking/thegame/legacy/learn-211bsd/LICENSE) applies only to the patch, scripts, and documentation present in this repository.
- Historical files downloaded during bootstrap are not covered by the repository MIT license.
- Before redistributing fetched material, review the original notices included in those files or in the corresponding historical archives.

## Notes

- The `C` course includes support files (`getline.c`, `getnum.c`) that collide with modern standard-library symbols; the bootstrap script compiles them with a local rename only to generate the objects required by the lessons.
- Generated patched sources live in `work/src/`; generated runnable binaries live in `work/bin/`.
- Not every interactive course has been validated end-to-end on modern Unix-like systems.
