; RUN: llc -march=arm64 -mattr=+morello,+c64 -target-abi purecap %s -o - | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; Make sure tail calls are not using any of the callee saved registers.

; CHECK-LABEL: foo
define void @foo() addrspace(200) {
entry:
; CHECK-NOT: br c19
; CHECK-NOT: br c20
; CHECK-NOT: br c21
; CHECK-NOT: br c22
; CHECK-NOT: br c22
; CHECK-NOT: br c23
; CHECK-NOT: br c24
; CHECK-NOT: br c25
; CHECK-NOT: br c26
; CHECK-NOT: br c27
; CHECK-NOT: br c28
; CHECK-NOT: br c29
; CHECK-NOT: br c30
; CHECK-NOT: br cfp
; CHECK-NOT: br clr
; CHECK: br c{{.*}}
  %call = tail call i8 addrspace(200)* bitcast (i8 addrspace(200)* (...) addrspace(200)* @bar to i8 addrspace(200)* () addrspace(200)*)()
  tail call void bitcast (void (...) addrspace(200)* @baz to void () addrspace(200)*)()
  %0 = bitcast i8 addrspace(200)* %call to void () addrspace(200)*
  tail call void %0()
  ret void
}

declare i8 addrspace(200)* @bar(...) local_unnamed_addr addrspace(200)
declare void @baz(...) local_unnamed_addr addrspace(200)
