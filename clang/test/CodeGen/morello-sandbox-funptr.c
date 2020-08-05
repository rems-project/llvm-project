// RUN: %clang %s -O0 -target aarch64-none-elf -march=morello+c64 -mabi=purecap -o - -S -emit-llvm | FileCheck %s
typedef void(*fn)();

extern void foo();

// CHECK-LABEL: @getFunctionPointer
fn getFunctionPointer() {
  return foo;

// CHECK: ret void (...) addrspace(200)* @foo
}
