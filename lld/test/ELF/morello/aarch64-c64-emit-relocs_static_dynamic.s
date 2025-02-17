// REQUIRES: aarch64
// RUN: llvm-mc -target-abi purecap --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %s -o %t.o
// RUN: ld.lld --local-caprelocs=elf %t.o --emit-relocs -o %t
// RUN: llvm-readobj --relocs --sections --symbols -x .got -x .data.rel.ro %t | FileCheck %s
// RUN: ld.lld %t.o --shared --emit-relocs -o %t.so
// RUN: llvm-readobj --relocs --sections --symbols -x .got -x .data.rel.ro %t.so | FileCheck %s --check-prefix=SHARED

// Check that the --emit-relocs output is reasonably sane.
 .text
 .global _start
 .type _start, %function
 .size _start, 8
_start:
 bl target
 b target
 adrp c0, :got: foo
 ldr c0, [c0, :got_lo12: foo]

 .section .text.1, "ax", %progbits
 .global target
 .type target, %function
 .size target, 4
target:
 ret

 .data.rel.ro
 .capinit foo
 .xword 0
 .xword 0

 .data
 .global foo
 .type foo, %object
 .size foo, 4
foo:
 .word 0

// CHECK:     Name: .text
// CHECK-NEXT:     Type: SHT_PROGBITS
// CHECK-NEXT:     Flags [ (0x6)
// CHECK-NEXT:       SHF_ALLOC
// CHECK-NEXT:       SHF_EXECINSTR (0x4)
// CHECK-NEXT:     ]
// CHECK-NEXT:     Address: 0x210260

// CHECK:    Name: .data.rel.ro
// CHECK-NEXT:     Type: SHT_PROGBITS
// CHECK-NEXT:     Flags [ (0x3)
// CHECK-NEXT:       SHF_ALLOC
// CHECK-NEXT:       SHF_WRITE
// CHECK-NEXT:     ]
// CHECK-NEXT:     Address: 0x220274

// CHECK:    Name: .got
// CHECK-NEXT:    Type: SHT_PROGBITS
// CHECK-NEXT:    Flags [ (0x3)
// CHECK-NEXT:      SHF_ALLOC
// CHECK-NEXT:      SHF_WRITE
// CHECK-NEXT:    ]
// CHECK-NEXT:    Address: 0x220290

// CHECK: Relocations [
// CHECK-NEXT:   .rela.dyn {
// CHECK-NEXT:     0x220274 R_MORELLO_RELATIVE - 0x0
// CHECK-NEXT:     0x220290 R_MORELLO_RELATIVE - 0x0
// CHECK-NEXT:   }
// CHECK-NEXT:   .rela.text {
// CHECK-NEXT:     0x210260 R_MORELLO_CALL26 target 0x0
// CHECK-NEXT:     0x210264 R_MORELLO_JUMP26 target 0x0
// CHECK-NEXT:     0x210268 R_MORELLO_ADR_GOT_PAGE foo 0x0
// CHECK-NEXT:     0x21026C R_MORELLO_LD128_GOT_LO12_NC foo 0x0
// CHECK-NEXT:   }
// CHECK-NEXT:   .rela.data.rel.ro {
// CHECK-NEXT:     0x220274 R_MORELLO_CAPINIT foo 0x0

// CHECK:         Name: foo
// CHECK-NEXT:    Value: 0x2302C0
// CHECK-NEXT:    Size: 4
// CHECK-NEXT:    Binding: Global
// CHECK-NEXT:    Type: Object
// CHECK-NEXT:    Other: 0
// CHECK-NEXT:    Section: .data

// CHECK:      Hex dump of section '.data.rel.ro':
/// foo: address: 0x2302C0, size = 4, perms = RW(0x2)
// CHECK-NEXT: 0x00220274 c0022300 00000000 04000000 00000002

// CHECK:      Hex dump of section '.got':
/// foo: address: 0x2302C0, size = 4, perms = RW(0x2)
// CHECK-NEXT: 0x00220290 c0022300 00000000 04000000 00000002


// SHARED:     Name: .text
// SHARED-NEXT:     Type: SHT_PROGBITS
// SHARED-NEXT:     Flags [
// SHARED-NEXT:       SHF_ALLOC
// SHARED-NEXT:       SHF_EXECINSTR
// SHARED-NEXT:     ]
// SHARED-NEXT:     Address: 0x10380

// SHARED:     Name: .data.rel.ro
// SHARED-NEXT:     Type: SHT_PROGBITS
// SHARED-NEXT:     Flags [
// SHARED-NEXT:       SHF_ALLOC
// SHARED-NEXT:       SHF_WRITE
// SHARED-NEXT:     ]
// SHARED-NEXT:     Address: 0x203D0

// SHARED:     Name: .got
// SHARED-NEXT:     Type: SHT_PROGBITS
// SHARED-NEXT:     Flags [
// SHARED-NEXT:       SHF_ALLOC
// SHARED-NEXT:       SHF_WRITE
// SHARED-NEXT:     ]
// SHARED-NEXT:     Address: 0x204C0

// SHARED:     Name: .got.plt
// SHARED-NEXT:     Type: SHT_PROGBITS
// SHARED-NEXT:     Flags [
// SHARED-NEXT:       SHF_ALLOC
// SHARED-NEXT:       SHF_WRITE
// SHARED-NEXT:     ]
// SHARED-NEXT:     Address: 0x304E0

// SHARED: Relocations [
// SHARED-NEXT:   .rela.dyn {
// SHARED-NEXT:     0x203D0 R_MORELLO_CAPINIT foo 0x0
// SHARED-NEXT:     0x204C0 R_MORELLO_GLOB_DAT foo 0x0
// SHARED-NEXT:   }
// SHARED-NEXT:   .rela.plt {
// SHARED-NEXT:     0x30510 R_MORELLO_JUMP_SLOT target 0x0
// SHARED-NEXT:   }
// SHARED-NEXT:   .rela.text {
// SHARED-NEXT:     0x10380 R_MORELLO_CALL26 target 0x0
// SHARED-NEXT:     0x10384 R_MORELLO_JUMP26 target 0x0
// SHARED-NEXT:     0x10388 R_MORELLO_ADR_GOT_PAGE foo 0x0
// SHARED-NEXT:     0x1038C R_MORELLO_LD128_GOT_LO12_NC foo 0x0
// SHARED-NEXT:   }
// SHARED-NEXT:   .rela.data.rel.ro {
// SHARED-NEXT:     0x203D0 R_MORELLO_CAPINIT foo 0x0

// SHARED:         Name: foo
// SHARED-NEXT:    Value: 0x304D0
// SHARED-NEXT:    Size: 4
// SHARED-NEXT:    Binding: Global
// SHARED-NEXT:    Type: Object
// SHARED-NEXT:    Other: 0
// SHARED-NEXT:    Section: .data

// SHARED:      Hex dump of section '.data.rel.ro':
/// foo: address: 0x304D0, size = 4, perms = RW(0x2)
// SHARED-NEXT: 0x000203d0 d0040300 00000000 04000000 00000002

// SHARED:      Hex dump of section '.got':
/// foo: address: 0x304D0, size = 4, perms = RW(0x2)
// SHARED-NEXT: 0x000204c0 d0040300 00000000 04000000 00000002
