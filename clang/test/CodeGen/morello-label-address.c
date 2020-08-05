// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -emit-llvm -o - -mllvm -cheri-cap-table-abi=pcrel %s | FileCheck %s

void bar();
void baz();

// CHECK-LABEL: foo
void foo (int a)
{
// CHECK: call void bitcast (void (...) addrspace(200)* @bar to void () addrspace(200)*)()
// CHECK: call void bitcast (void (...) addrspace(200)* @baz to void () addrspace(200)*)()

  void *label = a ? &&l : &&m;
  goto *label;
l:
  bar();
  return;
m:
  baz();
}
