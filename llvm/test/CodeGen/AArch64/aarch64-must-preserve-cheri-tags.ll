; RUN: llc < %s -march=arm64 | FileCheck %s

; Make sure that we can ignore the must-preserve-cheri-tags attribute and inline the memcpy.

; CHECK-LABEL: foo
; CHECK-NOT: memcpy
; CHECK: ldr
; CHECK: str
define dso_local void @foo(i8* nocapture %src, i8* nocapture readonly %dst) local_unnamed_addr #0 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %src, i8* align 1 %dst, i64 16, i1 false) #4
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

attributes #4 = { "must-preserve-cheri-tags" }
