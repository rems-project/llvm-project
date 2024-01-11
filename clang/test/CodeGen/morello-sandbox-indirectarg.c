// RUN: %clang %s -O2 -target aarch64-none-elf -march=morello+c64 -mabi=purecap -o - -S -emit-llvm | FileCheck %s

struct S {
  int r[5];
};

struct S a;

extern void fn2(struct S);

// CHECK-LABEL: @fn1
void fn1() {
  fn2(a);
// CHECK: %[[ALLOCA:.*]] = alloca %struct.S, align 4
// CHECK-NEXT: %[[BC:.*]] = bitcast %struct.S addrspace(200)* %[[ALLOCA]] to i8 addrspace(200)*
// CHECK: call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noundef nonnull align 4 dereferenceable(20) %[[BC]], i8 addrspace(200)* noundef nonnull align 4 dereferenceable(20) bitcast (%struct.S addrspace(200)* @a to i8 addrspace(200)*), i64 20, i1 false)
// CHECK-NEXT: call void @fn2(%struct.S addrspace(200)* noundef nonnull %[[ALLOCA]])
// CHECK: ret void
}
