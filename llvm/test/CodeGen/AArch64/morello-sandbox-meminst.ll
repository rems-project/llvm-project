; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap -o - %s | FileCheck %s
target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128-pf200:128:128-A200-P200-G200"
target triple = "aarch64-none--elf"

%struct.x = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@blob = common addrspace(200) global %struct.x zeroinitializer, align 4
@blob2 = common addrspace(200) global %struct.x zeroinitializer, align 4

declare void @llvm.memset.p200i8.i64(i8 addrspace(200)* nocapture, i8, i64, i32, i1) addrspace(200)
declare void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* nocapture, i8 addrspace(200)* nocapture readonly, i64, i32, i1) addrspace(200)
declare void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* nocapture, i8 addrspace(200)* nocapture readonly, i64, i32, i1) addrspace(200)

; CHECK-LABEL: checkMemInst
define void @checkMemInst() {
entry:
  call void @llvm.memset.p200i8.i64(i8 addrspace(200)* bitcast (%struct.x addrspace(200)* @blob to i8 addrspace(200)*), i8 0, i64 40, i32 4, i1 false)
  call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* bitcast (%struct.x addrspace(200)* @blob2 to i8 addrspace(200)*), i8 addrspace(200)* bitcast (%struct.x addrspace(200)* @blob to i8 addrspace(200)*), i64 40, i32 4, i1 false)

  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* bitcast (%struct.x addrspace(200)* @blob2 to i8 addrspace(200)*), i8 addrspace(200)* bitcast (%struct.x addrspace(200)* @blob to i8 addrspace(200)*), i64 40, i32 4, i1 false)
  ret void
; CHECK-NOT: bl	memset
; CHECK-NOT: bl	memcpy
; CHECK-NOT: bl	memmove
}

declare i8 addrspace(200)* @memset(i8 addrspace(200)*, i32, i64) addrspace(200)
declare i8 addrspace(200)* @memcpy(i8 addrspace(200)*, i8 addrspace(200)*, i64) addrspace(200)
declare i8 addrspace(200)* @mempcpy(i8 addrspace(200)*, i8 addrspace(200)*, i64) addrspace(200)
declare i8 addrspace(200)* @memmove(i8 addrspace(200)*, i8 addrspace(200)*, i64) addrspace(200)

; CHECK-LABEL: testMemset
define i8 addrspace(200)* @testMemset(i8 addrspace(200)* %p, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memset(i8 addrspace(200)* %p, i32 0, i64 %n)
  ret i8 addrspace(200)* %call
; CHECK: b	memset_c
}

; CHECK-LABEL: testMemset2
define void @testMemset2(i8 addrspace(200)* %p, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memset(i8 addrspace(200)* %p, i32 0, i64 %n)
  ret void
; CHECK: b	memset_c
}

; CHECK-LABEL: testMemcpy
define i8 addrspace(200)* @testMemcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret i8 addrspace(200)* %call
; CHECK: b	memcpy_c
}

; CHECK-LABEL: testMemcpy2
define void @testMemcpy2(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret void
; CHECK: b	memcpy_c
}

; CHECK-LABEL: testMempcpy
define i8 addrspace(200)* @testMempcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @mempcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret i8 addrspace(200)* %call
; CHECK: b	mempcpy_c
}

; CHECK-LABEL: testMempcpy2
define void @testMempcpy2(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @mempcpy(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret void
; CHECK: b	mempcpy_c
}

; CHECK-LABEL: testMemmove
define i8 addrspace(200)* @testMemmove(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memmove(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret i8 addrspace(200)* %call
; CHECK: b	memmove_c
}

; CHECK-LABEL: testMemmove2
define void @testMemmove2(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n) {
entry:
  %call = tail call i8 addrspace(200)* @memmove(i8 addrspace(200)* %d, i8 addrspace(200)* %s, i64 %n)
  ret void
; CHECK: b	memmove_c
}

; CHECK-LABEL: checkMemSetIntrinsic
define void @checkMemSetIntrinsic(i8 addrspace(200) *%in) {
entry:
; CHECK: movi v0.2d, #0000000000000000
; CHECK-DAG: str xzr, [c0, #32]
; CHECK-DAG: stp q0, q0, [c0]
  call void @llvm.memset.p200i8.i64(i8 addrspace(200)* %in, i8 0, i64 40, i32 16, i1 false)
  ret void
}

; CHECK-LABEL: checkMemCpyIntrinsic
define void @checkMemCpyIntrinsic(i8 addrspace(200) *%in, i8 addrspace(200) *%out) {
; CHECK-DAG:	ldr	x[[REG:[0-9]+]], [c0, #32]
; CHECK-DAG:	str	x[[REG]], [c1, #32]
; CHECK-DAG:	ldp	c[[REG1:[0-9]+]], c[[REG2:[0-9]+]], [c0, #0]
; CHECK-DAG:	stp	c[[REG1]], c[[REG2]], [c1, #0]
  call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* %out, i8 addrspace(200)* %in, i64 40, i32 16, i1 false)
  ret void
}

; CHECK-LABEL: checkMemMoveIntrinsic
define void @checkMemMoveIntrinsic(i8 addrspace(200) *%in, i8 addrspace(200) *%out) {
; CHECK-DAG:    ldr	x[[REG3:[0-9]+]], [c0, #32]
; CHECK-DAG:	ldp	c[[REG1:[0-9]+]], c[[REG2:[0-9]+]], [c0, #0]
; CHECK-DAG:	str	x[[REG3]], [c1, #32]
; CHECK-DAG:	stp	c[[REG1:[0-9]+]], c[[REG2:[0-9]+]], [c1, #0]
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* %out, i8 addrspace(200)* %in, i64 40, i32 16, i1 false)
  ret void
}

; CHECK-LABEL: checkMemMoveIntrinsic_inline
define void @checkMemMoveIntrinsic_inline(i8 addrspace(200) *%in, i8 addrspace(200) *%out) {
; CHECK-DAG:	ldp q[[REG1:[0-9]+]], q[[REG2:[0-9]+]], [c0]
; CHECK-DAG:	stp q[[REG1]], q[[REG2]], [c1]
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* %out, i8 addrspace(200)* %in, i64 32, i32 8, i1 false)
  ret void
}

; CHECK-LABEL: checkMemMoveIntrinsic_inline_cap
define void @checkMemMoveIntrinsic_inline_cap(i8 addrspace(200) *%in, i8 addrspace(200) *%out) {
; CHECK: b memmove_c
  tail call void @llvm.memmove.p200i8.p200i8.i64(i8 addrspace(200)* %out, i8 addrspace(200)* %in, i64 40, i32 8, i1 false) #0
  ret void
}

attributes #0 = { "must-preserve-cheri-tags" }
