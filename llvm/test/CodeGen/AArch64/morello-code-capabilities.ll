; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi=purecap | FileCheck %s -implicit-check-not=.capinit
; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi=purecap -filetype=obj -o - \
; RUN:  | llvm-readobj -r - | FileCheck %s --check-prefix=RELOCS

target datalayout = "e-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

; CHECK-LABEL: fun1:
define i8 addrspace(200)* @fun1() addrspace(200) {
entry:
; CHECK: adrp {{x|c}}0, :got:fun1
; CHECK-NEXT: ldr c0, [c0, :got_lo12:fun1]
  ret i8 addrspace(200) * bitcast (i8 addrspace(200)* () addrspace(200)* @fun1 to i8 addrspace(200)*)
}

; CHECK-LABEL: .LCPI1_0:
; CHECK-NEXT: .capinit fun2+((.Ltmp0+1)-fun2)
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

define i64 @blockaddress_in_global() addrspace(200) nounwind {
entry:
  %0 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* @addrof_label_in_global, align 16
  br label %indirectgoto

label1:                                           ; preds = %indirectgoto
  ret i64 2

label2:                                           ; preds = %indirectgoto
  ret i64 3

indirectgoto:                                     ; preds = %entry
  %indirect.goto.dest = phi i8 addrspace(200)* [ %0, %entry ]
  indirectbr i8 addrspace(200)* %indirect.goto.dest, [label %label1, label %label2]
}

@addrof_label_in_global = addrspace(200) global i8 addrspace(200)* blockaddress(@blockaddress_in_global, %label1), align 16
; CHECK-LABEL: addrof_label_in_global:
; CHECK-NEXT:  .capinit blockaddress_in_global+((.Ltmp1+1)-blockaddress_in_global)
; CHECK-NEXT:  .xword 0
; CHECK-NEXT:  .xword 0
; CHECK-NEXT:  .size addrof_label_in_global, 16
@addrof_label_in_global_2 = addrspace(200) global i8 addrspace(200)* blockaddress(@blockaddress_in_global, %label2), align 16
; CHECK-LABEL: addrof_label_in_global_2:
; CHECK-NEXT:  .capinit blockaddress_in_global+((.Ltmp2+1)-blockaddress_in_global)
; CHECK-NEXT:  .xword 0
; CHECK-NEXT:  .xword 0
; CHECK-NEXT:  .size addrof_label_in_global_2, 16


; All relocations should have an odd addend since they are C64 symbols:
; RELOCS-LABEL: Section ({{.+}}) .rela.data.rel.ro {
; RELOCS-NEXT:    0x0 R_MORELLO_CAPINIT fun2 0x1
; RELOCS-NEXT:  }
; RELOCS-LABEL: Section ({{.+}}) .rela.data {
; RELOCS-NEXT:    0x0 R_MORELLO_CAPINIT blockaddress_in_global 0x11
; RELOCS-NEXT:    0x10 R_MORELLO_CAPINIT blockaddress_in_global 0x19
; RELOCS-NEXT:  }
