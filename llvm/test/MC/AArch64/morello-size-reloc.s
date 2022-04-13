// RUN: llvm-mc -triple=aarch64-none-linux-gnu -filetype=obj %s -o - | \
// RUN:   llvm-readobj -r - | FileCheck -check-prefix=OBJ %s

        movz x0, #:size_g0:some_label
        movk x0, #:size_g0_nc:some_label

        movz x3, #:size_g1:some_label
        movk x5, #:size_g1_nc:some_label

        movz x3, #:size_g2:some_label
        movk x5, #:size_g2_nc:some_label

        movz x7, #:size_g3:some_label
        movk x11, #:size_g3:some_label

// OBJ:      Relocations [
// OBJ-NEXT:   Section {{.*}} .rela.text {
// OBJ-NEXT:     0x0  R_MORELLO_MOVW_SIZE_G0    some_label 0x0
// OBJ-NEXT:     0x4  R_MORELLO_MOVW_SIZE_G0_NC some_label 0x0
// OBJ-NEXT:     0x8  R_MORELLO_MOVW_SIZE_G1    some_label 0x0
// OBJ-NEXT:     0xC  R_MORELLO_MOVW_SIZE_G1_NC some_label 0x0
// OBJ-NEXT:     0x10 R_MORELLO_MOVW_SIZE_G2    some_label 0x0
// OBJ-NEXT:     0x14 R_MORELLO_MOVW_SIZE_G2_NC some_label 0x0
// OBJ-NEXT:     0x18 R_MORELLO_MOVW_SIZE_G3    some_label 0x0
// OBJ-NEXT:     0x1C R_MORELLO_MOVW_SIZE_G3    some_label 0x0
// OBJ-NEXT:   }
// OBJ-NEXT: ]
