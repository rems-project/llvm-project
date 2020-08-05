// RUN: llvm-mc -filetype=obj -triple aarch64-linux-gnu %s -o - \
// RUN:   | llvm-objdump -dwarf=frames - | FileCheck %s

// Check that directive '.cfi_startproc purecap' has the following effects:
// * Augmentation string includes character 'C'.
// * Return address column is set to CLR (158).
// * Initial CFA is defined as CSP+0 (reg159+0).

	.cfi_sections .eh_frame, .debug_frame

	.cfi_startproc purecap
purecap_func:
	ret
	.cfi_endproc

// CHECK-LABEL: .debug_frame contents:
//
// CHECK: 00000000 00000014 ffffffff CIE
// CHECK-NEXT:   Version:               4
// CHECK-NEXT:   Augmentation:          "C"
// CHECK-NEXT:   Address size:          8
// CHECK-NEXT:   Segment desc size:     0
// CHECK-NEXT:   Code alignment factor: 1
// CHECK-NEXT:   Data alignment factor: -4
// CHECK-NEXT:   Return address column: 158
//
// CHECK:   DW_CFA_def_cfa: reg159 +0
// CHECK-NEXT:   DW_CFA_nop:
//
// CHECK-LABEL: .eh_frame contents:
//
// CHECK: 00000000 00000014 ffffffff CIE
// CHECK-NEXT:   Version:               1
// CHECK-NEXT:   Augmentation:          "zRC"
// CHECK-NEXT:   Code alignment factor: 1
// CHECK-NEXT:   Data alignment factor: -4
// CHECK-NEXT:   Return address column: 158
// CHECK-NEXT:   Augmentation data:     1B
//
// CHECK:   DW_CFA_def_cfa: reg159 +0
// CHECK-NEXT:   DW_CFA_nop:
