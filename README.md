# CHERI CSA

This is the fork of [The CHERI LLVM Compiler Infrastructure](https://git.morello-project.org/morello/llvm-project) for CHERI-related Clang Static Analyzer development.

CSA performs inter-procedural path-sensitive analysis in the boundary of one translation unit (via inlining).

See Wiki for:
- [List of detected issues](https://github.com/rems-project/llvm-project/wiki/List-of-detected-issues)
- [Description of new CHERI-related checkers](https://github.com/rems-project/llvm-project/wiki/CHERI-CSA-Checkers)

# Usage

## Using with CheriBSD package

### Install package

```
$ pkg64 install llvm-morello-csa-13.0.d20231102.pkg
```

### Run analyzer

#### Analysing with ``scan-build``

Assuming `llvm-base` is installed:

```bash
$ scan-build-morello-csa --use-cc=cc --use-c++=c++ <OTHER_SCAN_BUILD_OPTIONS> BUILD_COMMAND
```

**Example:**
```bash
$ scan-build-morello-csa --use-cc=cc --use-c++=c++ --keep-cc make configure
$ scan-build-morello-csa --use-cc=cc --use-c++=c++ --keep-cc make build
```

See [below](#notes-on-using-scan-build) for notes on using `scan-build`.

#### Single compilation

1. Compile with `clang-morello-csa`
2. Add ``--analyze`` to clang options.


## Using with ``cheribuild``

### Build

Use fork of [cheribuild](https://github.ckm/rems-project/cheribuild/commits/use-csa) to build from the source code:

```
$ cheribuild.py morello-csa
```

### Usage

#### Single compilation

1. Compile with clang from `morello-csa` build
2. Add ``--analyze`` to clang options.

#### Using scan-build directly

```
$ ~/cheri/output/morello-csa/bin/scan-build --keep-cc \
    --use-cc ~/cheri/output/sdk/bin/clang \
    --use-c++ ~/cheri/output/sdk/bin/clang++ \
    BUILD_COMMAND
$ ~/cheri/output/morello-csa/bin/scan-view /tmp/scan-build-<timestamp>
```
See [below](#notes-on-using-scan-build) for notes on using `scan-build`.
    
#### Analysing with ``cheribuild``

``use-csa`` flag was added to the fork of cheribuild [here](https://github.ckm/rems-project/cheribuild/commits/use-csa) to support analysing projects that can be built with cheribuild.

```
$ cheribuild.py <project>-morello-purecap --<project>/use-csa --skip-install --clean
$ ~/cheri/output/morello-csa/bin/scan-view /tmp/scan-build-<timestamp>
```

##### To add ``use-csa`` option to the project:

1. Audit all usages of `self.CC` within the project file, and consider replacing them with `self.cc_wrapper` (see [below](#notes-on-using-scan-build)).
2. Override the ``can_build_with_csa`` classmethod of the project class to return `True`.

## Notes on using scan-build

Make sure to run `configure` script as well as `make` under `scan-build` when analysing Makefile projects.

The idea is to trick the build system into calling the `ccc-analyzer` wrapper instead of the original compiler. `ccc-analyzer`, in turn, invokes the original compiler (provided by ``--use-cc``) and its own clang for static analysis, passing all the compiler options provided by the build system to both.

Therefore `BUILD_COMMAND` should either
* use `CC` and `CXX` variables for obtaining the compiler path (`scan-build` will set `CC` and `CXX` to `ccc-analyzer` and `cxx-analyzer`, respectively),
* or directly invoke `ccc/cxx-analyzer` instead of Morello clang.

See [^2] for more info on `scan-build`.

[^2]:https://clang-analyzer.llvm.org/scan-build.html
