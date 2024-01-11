; RUN: opt -S -inline < %s | FileCheck %s
target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200"
target triple = "aarch64-none--elf"

$_Z8test_impIQPFiiiES0_Evv = comdat any
$_Z8test_impIM8MemFun03FizEFiQRS0_EEvv = comdat any
$_ZNSt3__18functionIFiiiEEC2IQPS1_vEET_ = comdat any
$_ZNSt3__18functionIFiiiEE6targetIQPS1_EEQPT_v = comdat any
$_ZN7CreatorIQPFiiiEE6createEv = comdat any

declare i32 @_Z3fooii(i32, i32)

define void @_Z9test_funcv() local_unnamed_addr {
entry:
  tail call void @_Z8test_impIQPFiiiES0_Evv()
  ret void
}

declare i8 addrspace(200)* @llvm.cheri.cap.from.pcc(i64) 

define void @_Z8test_impIQPFiiiES0_Evv() local_unnamed_addr comdat {
; CHECK-LABEL: @_Z8test_impIQPFiiiES0_Evv
; CHECK:       %[[A:[0-9]+]] = call i8 addrspace(200)* @llvm.cheri.cap.from.pcc(i64 ptrtoint (i32 (i32, i32)* @_Z3fooii to i64))
; CHECK-NEXT:  %[[B:[0-9]+]] = bitcast i8 addrspace(200)* %[[A]] to i32 (i32, i32) addrspace(200)*
; CHECK-NEXT:  icmp eq i32 (i32, i32) addrspace(200)* %[[B]], null
entry:
  %call2 = call i32 (i32, i32) addrspace(200)* @_ZN7CreatorIQPFiiiEE6createEv()
  call void @_ZNSt3__18functionIFiiiEEC2IQPS1_vEET_(i32 (i32, i32) addrspace(200)* nonnull %call2)
  unreachable
}

define void @_Z8test_impIM8MemFun03FizEFiQRS0_EEvv() local_unnamed_addr comdat {
entry:
  unreachable
}

declare void @llvm.trap() 

define void @_ZNSt3__18functionIFiiiEEC2IQPS1_vEET_(i32 (i32, i32) addrspace(200)* %__f) unnamed_addr comdat align 2 {
entry:
  %tobool.i = icmp eq i32 (i32, i32) addrspace(200)* %__f, null
  br i1 %tobool.i, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @llvm.trap()
  unreachable

if.end:                                           ; preds = %entry
  ret void
}

define void @_ZNSt3__18functionIFiiiEE6targetIQPS1_EEQPT_v() local_unnamed_addr comdat align 2 {
entry:
  ret void
}

define i32 (i32, i32) addrspace(200)* @_ZN7CreatorIQPFiiiEE6createEv() local_unnamed_addr comdat align 2 {
entry:
  %0 = tail call i8 addrspace(200)* @llvm.cheri.cap.from.pcc(i64 ptrtoint (i32 (i32, i32)* @_Z3fooii to i64))
  %1 = bitcast i8 addrspace(200)* %0 to i32 (i32, i32) addrspace(200)*
  ret i32 (i32, i32) addrspace(200)* %1
}
