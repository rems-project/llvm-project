// RUN: llvm-mc -triple=aarch64-none-linux-gnu -mattr=+morello -filetype=obj %s -o - | \
// RUN:   llvm-readobj -r | FileCheck -check-prefix=OBJ %s

// RUN: llvm-mc -mattr=+c64 -triple=aarch64-none-linux-gnu \
// RUN:   -filetype=obj %s -o - | \
// RUN:   llvm-readobj -r | FileCheck -check-prefix=OBJ-C64 %s
// RUN: llvm-mc -mattr=+c64,+morello -triple=aarch64-none-linux-gnu \
// RUN:   -filetype=obj %s -o - | \
// RUN:   llvm-readobj -r | FileCheck -check-prefix=OBJ-C64 %s


        b somewhere
        bl somewhere

// OBJ:      Relocations [
// OBJ-NEXT:   Section {{.*}} .rela.text {
// OBJ-NEXT:     0x0 R_AARCH64_JUMP26 somewhere 0x0
// OBJ-NEXT:     0x4 R_AARCH64_CALL26 somewhere 0x0
// OBJ-NEXT:   }
// OBJ-NEXT: ]

// OBJ-C64:      Relocations [
// OBJ-C64-NEXT:   Section {{.*}} .rela.text {
// OBJ-C64-NEXT:     0x0 R_MORELLO_JUMP26 somewhere 0x0
// OBJ-C64-NEXT:     0x4 R_MORELLO_CALL26 somewhere 0x0
// OBJ-C64-NEXT:   }
// OBJ-C64-NEXT: ]
