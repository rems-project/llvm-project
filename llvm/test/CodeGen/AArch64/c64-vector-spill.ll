; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap -verify-machineinstrs -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; This will spill the shuffled vector becauseof the call to bar.

; CHECK-LABEL: foo
; CHECK: st1
; CHECK: ld1

define dso_local void @foo() local_unnamed_addr addrspace(200) #0 {
entry:
  br label %for.body

for.cond.loopexit:
  br label %for.body

for.body:
  call void @bar()
  br i1 undef, label %for.cond.loopexit, label %vector.ph

vector.ph:
  %interleaved.vec28 = shufflevector <32 x i8> zeroinitializer, <32 x i8> zeroinitializer, <64 x i32> <i32 0, i32 16, i32 32, i32 48, i32 1, i32 17, i32 33, i32 49, i32 2, i32 18, i32 34, i32 50, i32 3, i32 19, i32 35, i32 51, i32 4, i32 20, i32 36, i32 52, i32 5, i32 21, i32 37, i32 53, i32 6, i32 22, i32 38, i32 54, i32 7, i32 23, i32 39, i32 55, i32 8, i32 24, i32 40, i32 56, i32 9, i32 25, i32 41, i32 57, i32 10, i32 26, i32 42, i32 58, i32 11, i32 27, i32 43, i32 59, i32 12, i32 28, i32 44, i32 60, i32 13, i32 29, i32 45, i32 61, i32 14, i32 30, i32 46, i32 62, i32 15, i32 31, i32 47, i32 63>
  %0 = bitcast i8 addrspace(200)* undef to <64 x i8> addrspace(200)*
  store <64 x i8> %interleaved.vec28, <64 x i8> addrspace(200)* %0, align 1, !tbaa !1
  br label %for.cond.loopexit
}

declare dso_local void @bar() local_unnamed_addr addrspace(200) #0

attributes #0 = { "use-soft-float"="false" }

!1 = !{!2, !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C++ TBAA"}
