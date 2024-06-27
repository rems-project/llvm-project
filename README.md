# :cherries: CHERI CSA

This is the fork of [The CHERI LLVM Compiler Infrastructure](https://git.morello-project.org/morello/llvm-project) for CHERI-related Clang Static Analyzer development.

**CHERI CSA provides custom static analyses that detect portability issues and support transitioning C/C++ code to CHERI hardware.**

:bookmark: Irina Dudina and Ian Stark. 2024. _Static Analysis for Transitioning to CHERI C/C++._ In Proceedings of the 13th ACM SIGPLAN International Workshop on the State Of the Art in Program Analysis (SOAP 2024). Association for Computing Machinery, New York, NY, USA, 52–59. https://doi.org/10.1145/3652588.3663323

#### :pencil: See Wiki for:
- List of detected issues [:link:](https://github.com/rems-project/llvm-project/wiki/List-of-detected-issues)
- Description of CHERI-related checkers [:link:](https://github.com/rems-project/llvm-project/wiki/CHERI-CSA-Checkers)

# :mag_right: Analyzing C/C++ code with CHERI CSA

You can 
- Install and run the analyser on Morello using CheriBSD package
- Run the analysis while building your project with `cheribuild` (supported architectures: `riscv64-purecap`, `mips64-purecap`, `morello-purecap`)

## :cherries: Using CheriBSD package on Morello

### :floppy_disk: Install the package
`llvm-morello-csa` package is now added to the [CheriBSD ports tree](https://github.com/CTSRD-CHERI/cheribsd-ports/tree/main/devel/llvm-morello-csa).

#### :small_blue_diamond: Install from the package repository (not yet available at the time of writing)

```
$ pkg64 install llvm-morello-csa
```

#### :small_blue_diamond: Download & Install the package from GitHub
1. Download the latest [release](https://github.com/rems-project/llvm-project/releases)
2. Install the package with:
```
$ pkg64 install llvm-morello-csa-14.0.d20240614_2.pkg 
```

### :mag_right: Run the analyser

#### :small_orange_diamond: Analysing with ``scan-build``

Assuming `llvm-base` is installed:

```bash
$ scan-build-morello-csa <OTHER_SCAN_BUILD_OPTIONS> BUILD_COMMAND
```

**Example:**
```bash
$ scan-build-morello-csa --keep-cc make configure
$ scan-build-morello-csa --keep-cc make build
```

See [below](#notes-on-using-scan-build) for notes on using `scan-build`.

#### :small_orange_diamond: Analysing single compilation

1. Compile with `clang-morello-csa`
2. Add ``--analyze`` to clang options.


## :cherries: Using with ``cheribuild``

### :wrench: Build

Use fork of [cheribuild](https://github.ckm/rems-project/cheribuild/commits/use-csa) to build CHERI CSA from the source code:

#### :small_blue_diamond: Morello:

```
$ cheribuild.py morello-csa
```

#### :small_blue_diamond: RISC-V, MIPS:

```
$ cheribuild.py cheri-csa
```


### :mag_right: Run analysis

#### :small_orange_diamond: Analysing with ``cheribuild``

``use-csa`` flag was added to the fork of cheribuild [here](https://github.ckm/rems-project/cheribuild/commits/use-csa) to support analysing projects that can be built with cheribuild.

```
$ cheribuild.py <project>-morello-purecap --<project>/use-csa --skip-install --clean
$ ~/cheri/output/morello-csa/bin/scan-view /tmp/scan-build-<timestamp>
```

##### To add ``use-csa`` option to the project:

1. Audit all usages of `self.CC` within the project file, and consider replacing them with `self.cc_wrapper` (see [below](#notes-on-using-scan-build)).
2. Override the ``can_build_with_csa`` classmethod of the project class to return `True`.

#### :small_orange_diamond: Using scan-build directly

```
$ ~/cheri/output/morello-csa/bin/scan-build --keep-cc \
    --use-cc ~/cheri/output/sdk/bin/clang \
    --use-c++ ~/cheri/output/sdk/bin/clang++ \
    BUILD_COMMAND
$ ~/cheri/output/morello-csa/bin/scan-view /tmp/scan-build-<timestamp>
```
See below for the notes on using `scan-build`.


#### :small_orange_diamond: Analysing single compilation

1. Compile with clang from `morello-csa` (`cheri-csa`) build
2. Add ``--analyze`` to clang options.

    
## :pencil: Notes on using scan-build

Make sure to run `configure` script as well as `make` under `scan-build` when analysing Makefile projects.

The idea is to trick the build system into calling the `ccc-analyzer` wrapper instead of the original compiler. `ccc-analyzer`, in turn, invokes the original compiler (provided by ``--use-cc``) and its own clang for static analysis, passing all the compiler options provided by the build system to both.

Therefore `BUILD_COMMAND` should either
* use `CC` and `CXX` variables for obtaining the compiler path (`scan-build` will set `CC` and `CXX` to `ccc-analyzer` and `cxx-analyzer`, respectively),
* or directly invoke `ccc/cxx-analyzer` instead of Morello clang.

See [^2] or `scan-build --help` for more info on `scan-build`.

[^2]:https://clang-analyzer.llvm.org/scan-build.html
