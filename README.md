# learn 2.11BSD Modern Port Bundle

Patch, bootstrap scripts, and documentation for building a modern local copy of
the historical 2.11BSD `learn` program, without shipping the original source
tree or lesson files in this repository.

`learn` is an old Unix teaching tool: an interactive,
lesson-driven program for practicing basic shell, editor, and C programming
tasks directly at the terminal. This repository packages a modernized way to
fetch, patch, build, and run that historical software on current Unix-like
systems without redistributing the 2.11BSD sources and lesson files.

The original `learn` system is generally attributed to Michael E. Lesk and
Brian W. Kernighan at Bell Labs.

This porting bundle was produced mostly through AI-assisted
"vibe coding", with iterative manual testing, review, and correction around the
generated changes.

## Status

- Bootstrap verified on a modern Unix-like system with a current Clang toolchain.
- Historical sources and lessons are fetched from public archives.
- This repository is intended to publish only original porting work.

## Prerequisites

- POSIX shell utilities: `sh`, `cp`, `rm`, `mkdir`, `find`, `sed`
- build tools: `cc`, `make`, `patch`
- download tool: `curl`
- a `vi`-compatible editor available on `PATH` as `vi` for the `vi` course

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

To fetch the historical 2.11BSD material from `TUHS.org` instead of `retro11.de`:

```sh
./scripts/bootstrap.sh --clean --source tuhs
```

To force a specific TUHS 2.11BSD release directory, pass `--tuhs-release`.
The default is the base `2.11BSD/` archive, which matches the source layout
used by this port bundle:

```sh
./scripts/bootstrap.sh --clean --source tuhs --tuhs-release 2.11BSD
```

For example, TUHS also exposes other 2.11BSD directories such as
`2.11BSD-patch481/`, and the scripts can target those if they provide the same
`file6.tar.gz` / `file7.tar.gz` / `file8.tar.gz` distribution layout:

```sh
./scripts/bootstrap.sh --clean --source tuhs --tuhs-release 2.11BSD-patch481
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
  URL: `https://www.retro11.de/ouxr/211bsd/usr/src/usr.bin/learn/`
- [lesson tree](https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/)
  URL: `https://www.retro11.de/ouxr/211bsd/usr/src/share/learn/`
- [TUHS UCB distribution archive](https://www.tuhs.org/Archive/Distributions/UCB/)
  URL: `https://www.tuhs.org/Archive/Distributions/UCB/`
- [TUHS base 2.11BSD release directory](https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/)
  URL: `https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/`
- [TUHS tarball table of contents](https://www.tuhs.org/Archive/tarball_tocs.txt.gz)
  URL: `https://www.tuhs.org/Archive/tarball_tocs.txt.gz`
- [original paper: "LEARN - Computer-Aided Instruction on UNIX (Second Edition)"](https://www.bitsavers.org/pdf/usenix/Usenix_BSD_Manuals/4.3_1st_printing_198611/USD_Unix_Users_Supplementary_Documents_4.3BSD_198604.pdf)
  URL: `https://www.bitsavers.org/pdf/usenix/Usenix_BSD_Manuals/4.3_1st_printing_198611/USD_Unix_Users_Supplementary_Documents_4.3BSD_198604.pdf`
- [7th Edition UNIX manual index entry for learn](https://wolfram.schneider.org/bsd/7thEdManVol2/index/index.html)
  URL: `https://wolfram.schneider.org/bsd/7thEdManVol2/index/index.html`
- [historical manual page](https://man.freebsd.org/cgi/man.cgi?query=learn&manpath=2.9.1+BSD)
  URL: `https://man.freebsd.org/cgi/man.cgi?query=learn&manpath=2.9.1+BSD`
- [alternative Docker-based project](https://github.com/goblimey/learn-unix)
  URL: `https://github.com/goblimey/learn-unix`

## License

- [LICENSE](LICENSE) applies only to the patch, scripts, and documentation present in this repository.
- Historical files downloaded during bootstrap are not covered by the repository BSD-2-Clause license.
- Before redistributing fetched material, review the original notices included in those files or in the corresponding historical archives.

## Notes

- The `C` course includes support files (`getline.c`, `getnum.c`) that collide with modern standard-library symbols; the bootstrap script compiles them with a local rename only to generate the objects required by the lessons.
- Generated patched sources live in `work/src/`; generated runnable binaries live in `work/bin/`.
- Not every interactive course has been validated end-to-end on modern Unix-like systems.
