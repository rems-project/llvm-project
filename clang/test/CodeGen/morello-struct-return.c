// RUN: %clang %s -O1 -target aarch64-none-elf -march=morello -o - -S -emit-llvm | FileCheck %s

struct S {
  __capability void *cap;
};

// The struct S should be returned directly, as we have capability registers.
// No need to mess it up with tsome ptrtoint conversion.
// CHECK: @foo
struct S foo(struct S v) {
  return v;
// CHECK-NOT: ptrtoint
}
