// RUN: %clang %s -target cheri-unknown-freebsd --std=c++11 -o - -emit-llvm -S
// RUN: %clang %s -target aarch64-none-elf -march=morello --std=c++11 -o - -emit-llvm -S

// Use of #pragma opaque is tied to typedef types. Check that the added
// functionality does not cause problems (crashes) when aliases are used because
// they are internally represented similarly to typedefs.
using T = void *;
T foo() { return nullptr; }
