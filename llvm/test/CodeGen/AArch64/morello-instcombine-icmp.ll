; RUN: opt -march=arm64 -mattr=+c64 -target-abi purecap -S -instcombine -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-unknown-elf"

; CHECK-LABEL: foo
; CHECK: call i64 @llvm.cheri.cap.address.get.i64
; CHECK: call i64 @llvm.cheri.cap.address.get.i64
define hidden void @foo(i32 %length, i8 addrspace(200)* addrspace(200)* nocapture readonly %target, i8 addrspace(200)* readnone %targetLimit) local_unnamed_addr addrspace(200) #0 {
entry:
  %targetLimit8 = ptrtoint i8 addrspace(200)* %targetLimit to i64
  %0 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %target, align 16
  %cmp23 = icmp sgt i32 %length, 0
  %cmp34 = icmp ult i8 addrspace(200)* %0, %targetLimit
  %or.cond5 = and i1 %cmp23, %cmp34
  br i1 %or.cond5, label %while.body.preheader, label %do.body.preheader

while.body.preheader:                             ; preds = %entry
  %1 = sub i64 0, %targetLimit8
  %scevgep = getelementptr i8, i8 addrspace(200)* %0, i64 %1
  %2 = add i32 %length, -1
  %3 = zext i32 %2 to i64
  %4 = sub i64 -1, %3
  %5 = inttoptr i64 %4 to i8 addrspace(200)*
  %6 = icmp ugt i8 addrspace(200)* %scevgep, %5
  %umax = select i1 %6, i8 addrspace(200)* %scevgep, i8 addrspace(200)* %5
  %umax9 = ptrtoint i8 addrspace(200)* %umax to i64
  %7 = sub i64 0, %umax9
  call void @llvm.memset.p200i8.i64(i8 addrspace(200)* align 1 %0, i8 0, i64 %7, i1 false)
  br label %do.body.preheader

do.body.preheader:                                ; preds = %while.body.preheader, %entry
  br label %do.body

do.body:                                          ; preds = %do.body.preheader, %do.body
  br label %do.body
}

declare void @llvm.memset.p200i8.i64(i8 addrspace(200)* nocapture writeonly, i8, i64, i1 immarg) addrspace(200) #1

attributes #0 = { "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
