// RUN: %clang %s -fno-rtti -std=c++11 -target aarch64-none-elf -march=morello -O1 -S -emit-llvm -o - | FileCheck %s

#include <cheri.h>

// Derive a capability from an explicit one.
int * __capability explicitDDC1(void * __capability DDC, int *p) {
// CHECK-LABEL: @_Z12explicitDDC1U3capPvPi(
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* %DDC, i64 [[PTR]])
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP]], i64 4)
  return capability_cast<int>(DDC, p);
}

const int * __capability explicitDDC1_const(void * __capability DDC, int *p) {
// CHECK-LABEL: @_Z18explicitDDC1_constU3capPvPi(
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* %DDC, i64 [[PTR]])
// CHECK: [[TMP2:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)* [[TMP1]], i64 -65537)
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP2]], i64 4)
  return capability_cast<const int>(DDC, p);
}

int * __capability explicitDDC1_bnds(void * __capability DDC, int *p) {
// CHECK-LABEL: @_Z17explicitDDC1_bndsU3capPvPi(
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* %DDC, i64 [[PTR]])
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP]], i64 8)
  return capability_cast<int>(DDC, p, 2 * sizeof(*p));
}

const int * __capability explicitDDC1_const_bnds(void * __capability DDC, int *p) {
// CHECK-LABEL: @_Z23explicitDDC1_const_bndsU3capPvPi(
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* %DDC, i64 [[PTR]])
// CHECK: [[TMP2:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)* [[TMP1]], i64 -65537)
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP2]], i64 8)
  return capability_cast<const int>(DDC, p, 2 * sizeof(*p));
}

// Derive a capability from an implicit DDC.
int * __capability implicitDDC1(int *p) {
// CHECK-LABEL: @_Z12implicitDDC1Pi(
// CHECK: [[DDC:%.*]] = call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* [[DDC]], i64 [[PTR]])
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP1]], i64 4)
  return capability_cast<int>(p);
}

const int * __capability implicitDDC1_const(int *p) {
// CHECK-LABEL: @_Z18implicitDDC1_constPi(
// CHECK: [[DDC:%.*]] = call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* [[DDC]], i64 [[PTR]])
// CHECK: [[TMP2:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)* [[TMP1]], i64 -65537)
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP2]], i64 4)
  return capability_cast<const int>(p);
}

int * __capability implicitDDC1_bnds(int *p) {
// CHECK-LABEL: @_Z17implicitDDC1_bndsPi(
// CHECK: [[DDC:%.*]] = call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* [[DDC]], i64 [[PTR]])
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP1]], i64 8)
  return capability_cast<int>(p, 2 * sizeof(*p));
}

const int * __capability implicitDDC1_const_bnds(int *p) {
// CHECK-LABEL: @_Z23implicitDDC1_const_bndsPi(
// CHECK: [[DDC:%.*]] = call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CHECK: [[PTR:%.*]] = ptrtoint i32* %p to i64
// CHECK: [[TMP1:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.i64(i8 addrspace(200)* [[DDC]], i64 [[PTR]])
// CHECK: [[TMP2:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)* [[TMP1]], i64 -65537)
// CHECK: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[TMP2]], i64 8)
  return capability_cast<const int>(p, 2 * sizeof(*p));
}

// Convert a capability back to a pointer.
int * toPointer(int *__capability c) {
// CHECK-LABEL: @_Z9toPointerU3capPi(
// CHECK: [[CAP:%.*]] = bitcast i32 addrspace(200)* %c to i8 addrspace(200)*
// CHECK: call i64 @llvm.cheri.cap.to.pointer.i64(i8 addrspace(200)* null, i8 addrspace(200)* [[CAP]])
  return capability_cast<int>(c);
}
