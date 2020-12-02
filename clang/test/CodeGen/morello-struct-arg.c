// RUN: %clang %s -O1 -target aarch64-none-elf -march=morello -o - -S -emit-llvm | FileCheck %s

struct S {
  void * __capability cap;
};

void foo(struct S v, struct S v1);

// CHECK-LABEL: bar
void bar(struct S v) {
// CHECK: call void @foo(i8 addrspace(200)* %{{.*}}, i8 addrspace(200)* %{{.*}})
  foo(v, v);
}
