; RUN: llc -march=arm64 -mattr=+c64 -target-abi purecap -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

@_ZZ4mainE2ia_0 = external addrspace(200) constant [1 x i32], align 4
@_ZZ4mainE2ib_0 = external addrspace(200) constant [1 x i32], align 4

; CHECK-LABEL: fun
define void @fun() addrspace(200) {
cond.end25:
  br i1 or (i1 icmp eq (i64 lshr (i64 ptrtoint (i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* bitcast (i32 addrspace(200)* getelementptr inbounds ([1 x i32], [1 x i32] addrspace(200)* @_ZZ4mainE2ia_0, i64 1, i64 0) to i8 addrspace(200)*), i64 sub (i64 -4, i64 ptrtoint ([1 x i32] addrspace(200)* @_ZZ4mainE2ia_0 to i64))) to i64), i64 2), i64 0), i1 icmp eq (i32 addrspace(200)* getelementptr inbounds ([1 x i32], [1 x i32] addrspace(200)* @_ZZ4mainE2ib_0, i64 0, i64 0), i32 addrspace(200)* getelementptr (i32, i32 addrspace(200)* getelementptr inbounds ([1 x i32], [1 x i32] addrspace(200)* @_ZZ4mainE2ib_0, i64 0, i64 0), i64 add (i64 lshr (i64 ptrtoint (i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* bitcast (i32 addrspace(200)* getelementptr inbounds ([1 x i32], [1 x i32] addrspace(200)* @_ZZ4mainE2ia_0, i64 1, i64 0) to i8 addrspace(200)*), i64 sub (i64 -4, i64 ptrtoint ([1 x i32] addrspace(200)* @_ZZ4mainE2ia_0 to i64))) to i64), i64 2), i64 1)))), label %cond.end83, label %for.body44.i2572.preheader

for.body44.i2572.preheader:
  unreachable

cond.end83:
  unreachable
}
