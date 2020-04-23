// RUN: %cheri_purecap_cc1 -fsyntax-only -ast-dump %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -fsyntax-only -ast-dump %s | FileCheck %s

class A { };

void f() {
  // CHECK: CXXNewExpr {{.*}} {{.*}} 'A *' Function
  A *a = new A;
}
