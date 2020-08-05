; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap  -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; CHECK-LABEL: foo
define dso_local void @foo() local_unnamed_addr addrspace(200) #0 {
entry:
  %vecins.i.i.i.i = insertelement <4 x i32> undef, i32 8, i64 undef
  br i1 undef, label %cond.end, label %cond.false

cond.false:                                       ; preds = %entry
  tail call void @bar() #1
  unreachable

cond.end:                                         ; preds = %entry
  %vecext.i.i.1.i = extractelement <4 x i32> %vecins.i.i.i.i, i64 1
  ret void
}

declare dso_local void @bar() local_unnamed_addr addrspace(200) #0

attributes #0 = { "use-soft-float"="false" }
attributes #1 = { noreturn nounwind }
