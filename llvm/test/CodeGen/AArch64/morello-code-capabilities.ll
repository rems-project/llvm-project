; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi=purecap | FileCheck %s

target datalayout = "e-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

; CHECK-LABEL: fun1:
define i8 addrspace(200)* @fun1() addrspace(200) {
entry:
; CHECK-C64: adrp {{x|c}}0, :got:fun1
; CHECK-C64-NEXT: ldr c0, [c0, :got_lo12:fun1]
  ret i8 addrspace(200) * bitcast (i8 addrspace(200)* () addrspace(200)* @fun1 to i8 addrspace(200)*)
}

; CHECK-LABEL: .LCPI1_0:
; CHECK-NEXT: .capinit .Ltmp0+1
; CHECK-NEXT:	.xword	0
; CHECK-NEXT:	.xword	0
; CHECK-LABEL: fun2:
; CHECK-LABEL: .Ltmp0
define i8 addrspace(200)* @fun2() addrspace(200) {
entry:
  br label %newb
newb:
  ret i8 addrspace(200)* blockaddress(@fun2, %newb)
; CHECK: ret
}

; CHECK-NOT: .capinit fun1
