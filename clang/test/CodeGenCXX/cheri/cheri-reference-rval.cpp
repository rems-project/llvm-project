// RUN: %cheri_cc1 -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +morello -emit-llvm -o - %s | FileCheck %s

__intcap_t g();

void f() {
  __intcap_t&& a2 = g();
  // CHECK: {{.+}} = load i8 addrspace(200)**, i8 addrspace(200)*** %a2
  if (a2 == 0) { }
}
