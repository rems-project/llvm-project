// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -std=c++1z -emit-llvm -o - -mllvm -cheri-cap-table-abi=pcrel %s | FileCheck %s

void g();

// Don't emit initializers for references as constant expressions, when
// the references are capabilities since it won't work with expressions
// containing capabilities to functions.

// CHECK-LABEL: _Z3funv
void fun() {
// CHECK: call void @_Z1gv()
  using FooType = void (void);
  FooType& fn = g;
  fn();
}
