// RUN: %clang %s -target aarch64-none-elf -march=morello+c64 -mabi=purecap -Xclang -morello-vararg=legacy -o - -S -emit-llvm \
// RUN:   | FileCheck %s

// Tests for handling of variable argument lists in the sandbox mode.

#include <stdarg.h>

// Check that calls to the llvm.va_start, llvm.va_copy and llvm.va_end
// intrinsics are made with pointers to address space 200.
int testVaAddressSpace(int a, ...) {
// CHECK-LABEL: testVaAddressSpace
  va_list vl, vl2;
// CHECK: [[VL:%.*]] = alloca %struct.__va_list, align 16
// CHECK-NEXT: [[VL2:%.*]] = alloca %struct.__va_list, align 16
  int res;

  va_start(vl, a);
// CHECK: [[TMP:%.*]] = bitcast %struct.__va_list addrspace(200)* [[VL]] to i8 addrspace(200)*
// CHECK-NEXT: call void @llvm.va_start.p200i8(i8 addrspace(200)* [[TMP]])

  res = va_arg(vl, int);

  va_copy(vl2, vl);
// CHECK: [[TMP2:%.*]] = bitcast %struct.__va_list addrspace(200)* [[VL2]] to i8 addrspace(200)*
// CHECK-NEXT: [[TMP3:%.*]] = bitcast %struct.__va_list addrspace(200)* [[VL]] to i8 addrspace(200)*
// CHECK-NEXT: call void @llvm.va_copy.p200i8.p200i8(i8 addrspace(200)* [[TMP2]], i8 addrspace(200)* [[TMP3]])

  va_end(vl2);
// CHECK: [[TMP4:%.*]] = bitcast %struct.__va_list addrspace(200)* [[VL2]] to i8 addrspace(200)*
// CHECK-NEXT: call void @llvm.va_end.p200i8(i8 addrspace(200)* [[TMP4]])

  va_end(vl);
// CHECK: [[TMP5:%.*]] = bitcast %struct.__va_list addrspace(200)* [[VL]] to i8 addrspace(200)*
// CHECK-NEXT: call void @llvm.va_end.p200i8(i8 addrspace(200)* [[TMP5]])

  return res;
}

// Check that when emitting AAPCS code for va_arg(), the size of one element in
// the general register argument save area is the same in sandbox mode.
void testIntVaArg(int *gInt, int b, ...) {
// CHECK-LABEL: testIntVaArg
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK:      [[STACK_P:%.*]]  = getelementptr inbounds %struct.__va_list, %struct.__va_list addrspace(200)* %{{.*}}, i32 0, i32 0
// CHECK-NEXT: [[STACK:%.*]] = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* [[STACK_P]], align 16
// CHECK-NEXT: [[NEW_STACK:%.*]] = getelementptr inbounds i8, i8 addrspace(200)* [[STACK]], i64 8
// CHECK-NEXT: store i8 addrspace(200)* [[NEW_STACK]], i8 addrspace(200)* addrspace(200)* [[STACK_P]], align 16
  va_list vl;
  va_start(vl, b);
  *gInt += va_arg(vl, int);
  va_end(vl);
}

// Check that when emitting AAPCS code for va_arg(), the size of one element in
// the FP/SIMD register argument save area is 8 bytes in the sandbox mode.
void testDoubleVaArg(double *gDouble, int b, ...) {
// CHECK-LABEL: testDoubleVaArg
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK: [[STACK_P:%.*]]  = getelementptr inbounds %struct.__va_list, %struct.__va_list addrspace(200)* %{{.*}}, i32 0, i32 0
// CHECK-NEXT: [[STACK:%.*]]  = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* [[STACK_P]], align 16
// CHECK-NEXT: [[NEW_STACK:%.*]]  = getelementptr inbounds i8, i8 addrspace(200)* [[STACK]], i64 8
// CHECK-NEXT: store i8 addrspace(200)* [[NEW_STACK]], i8 addrspace(200)* addrspace(200)* [[STACK_P]], align 16
  va_list vl;
  va_start(vl, b);
  *gDouble += va_arg(vl, double);
  va_end(vl);
}

void *testCapVaArg(int b, ...) {
// CHECK-LABEL: testCapVaArg
// CHECK: {{.*}}:
// CHECK:  [[REGS_OFF:%.*]] = sub i32 -8, %{{.*}}
// CHECK:  [[REGS_SOFF:%.*]]  = mul i32 [[REGS_OFF]], 2
// CHECK:  [[TMP:%.*]] = getelementptr inbounds i8, i8 addrspace(200)* %{{.*}}, i32 [[REGS_SOFF]]
// CHECK:  bitcast i8 addrspace(200)* [[TMP]] to i8 addrspace(200)* addrspace(200)*
  va_list vl;
  void *ret;
  va_start(vl, b);
  ret = va_arg(vl, void *);
  va_end(vl);
  return ret;
}

struct capstruct {
  int *a;
  int *b;
};

void call_capstruct(struct capstruct);

// Capability structs are reversed in memory, so the we need to adjust the computation to
// get the base of reversed struct.

// CHECK-LABEL: checkStructCapVa
// CHECK: [[REGS_OFF:%.*]]  = sub i32 -16, %{{.*}}
// CHECK: [[REGS_SOFF:%.*]]  = mul i32 [[REGS_OFF]], 2
// CHECK: getelementptr inbounds i8, i8 addrspace(200)* %{{.*}}, i32 [[REGS_SOFF]]
void checkStructCapVa (int z, ...)
{
  struct capstruct arg;
  va_list ap;
  va_start(ap, z);
  arg = va_arg (ap, struct capstruct);
  call_capstruct(arg);
  va_end (ap);
}

// Capability loads from the register spill area are done with alignment 16.
// CHECK-LABEL: foo
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK: {{.*}}:
// CHECK: llvm.cheri.cap.address.get.i64
// CHECK: llvm.cheri.cap.address.set.i64
// CHECK: {{.*}}:
// CHECK: load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %{{.*}}, align 16
void foo(__builtin_va_list bar) {
  char *baz = __builtin_va_arg(bar, char *);
}
