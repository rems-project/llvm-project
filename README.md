# CHERI CSA

This is the fork of [The CHERI LLVM Compiler Infrastructure](https://git.morello-project.org/morello/llvm-project) for CHERI-related Clang Static Analyzer development.

CSA performs inter-procedural path-sensitive analysis in the boundary of one translation unit (via inlining). Cross Translation Unit analysis exists, but I'm unsure about its status[^1].

[^1]:https://clang.llvm.org/docs/analyzer/user-docs/CrossTranslationUnit.html


## CHERI-related checkers

### ProvenanceSource

* Tracks integers and pointers stored as `(u)intptr_t` type
* Fires a warning for `(u)intptr_t` binary operations with ambiguous provenance source (same as clang) and tells which side carries (or not) the provenance along the path
* Fires a warning when the `(u)intptr_t` value obtained from the ambiguous-provenance-operation is cast to pointer type
* Fires a warning when `NULL`-derived `(u)intptr_t` capability is cast to pointer type

See _CHERI C/C++ Programming Guide_ §4.2.3.

### CapabilityCopy

Detects tag-stripping loads and stores that may be used to copy or swap capabilities

```c
void memcpy_impl(void* src0, void *dst0, size_t len) {
  char *src = src0;
  char *dst = dst0;

  while (len--)
    *dst++ = *src++; // Tag-stripping store of a capability
}
```

See _CHERI C/C++ Programming Guide_ §4.2.

### PointerAlignment
Reports pointer casts of underaligned values to types with strict alignment requirements.

Special case for CHERI: casts to pointer to capability. Storing capabilities at not capability-aligned addressed will result in stored capability losing its tag.

```c
double a[2048];
void** foo(void) {
  char *p0 = (char*)a;
  // Pointer p0 is aligned to a 8 byte boundary;
  // type 'void **' requires capability alignment (16 bytes)
  return (void**)p0; 
}
```

See _CHERI C/C++ Programming Guide_ §4.2.2.

## Using with CheriBSD package

### Install

```
$ pkg64 install llvm-csa-0.0.0.pkg
```

### Usage

#### Single compilation

1. Compile with `clang-csa`
2. Add ``--analyze`` to clang options.

#### Analysing with ``scan-build``

Assuming `llvm-base` is installed:

```
$ scan-build-csa --use-cc=cc --use-c++=c++ --keep-cc BUILD_COMMAND
```

See [below](#notes-on-using-scan-build) for notes on using `scan-build`.

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
