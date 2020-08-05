; RUN: llc -march=arm64 -mattr=+morello,+c64 -target-abi purecap -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"

; CHECK-LABEL: bar
; CHECK: bl memcpy_c
define void @bar(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i32 %size) addrspace(200) {
entry:
  %conv.i = zext i32 %size to i64
  %0 = tail call i64 @llvm.objectsize.i64.p200i8(i8 addrspace(200)* %dst, i1 false)
  %call.i = tail call i8 addrspace(200)* @__memcpy_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 %conv.i, i64 %0)
  ret void
}

; CHECK-LABEL: baz
define void @baz(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) addrspace(200) {
entry:
; CHECK: bl memcpy_c
  %call.i = tail call i8 addrspace(200)* @__memcpy_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 32, i64 32) #0
  ret void
}

; CHECK-LABEL: foo
; CHECK: bl memcpy_c
define void @foo(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i32 %size) addrspace(200) {
entry:
  %call.i = tail call i8 addrspace(200)* @__memcpy_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 32, i64 32)
  ret void
}

; CHECK-LABEL: barmove
; CHECK: bl memmove_c
define void @barmove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i32 %size) addrspace(200) {
entry:
  %conv.i = zext i32 %size to i64
  %0 = tail call i64 @llvm.objectsize.i64.p200i8(i8 addrspace(200)* %dst, i1 false)
  %call.i = tail call i8 addrspace(200)* @__memmove_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 %conv.i, i64 %0)
  ret void
}

; CHECK-LABEL: bazmove
define void @bazmove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src) addrspace(200) {
entry:
; CHECK: bl memmove_c
  %call.i = tail call i8 addrspace(200)* @__memmove_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 32, i64 32) #0
  ret void
}

; CHECK-LABEL: foomove
; CHECK: bl memmove_c
define void @foomove(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i32 %size) addrspace(200) {
entry:
  %call.i = tail call i8 addrspace(200)* @__memmove_chk(i8 addrspace(200)* %dst, i8 addrspace(200)* %src, i64 32, i64 32)
  ret void
}

declare i8 addrspace(200)* @__memcpy_chk(i8 addrspace(200)*, i8 addrspace(200)*, i64, i64) addrspace(200)
declare i8 addrspace(200)* @__memmove_chk(i8 addrspace(200)*, i8 addrspace(200)*, i64, i64) addrspace(200)
declare i64 @llvm.objectsize.i64.p200i8(i8 addrspace(200)*, i1) addrspace(200)

attributes #0 = { "must-preserve-cheri-tags" }
