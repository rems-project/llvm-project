/// This test should be updated when Global-Dynamic (GD) to Initial-Exec (IE)
/// relaxations are implemented. For now no relaxation is done.

// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-linux %s -o %tmain.o -mattr=+c64,+morello
// RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-linux %p/Inputs/aarch64-c64-tls-gdie.s -o %t2.o -mattr=+c64,+morello
// RUN: ld.lld --morello-c64-plt %t2.o -o %t2.so -shared -soname=t2.so
// RUN: ld.lld --morello-c64-plt --hash-style=sysv %tmain.o %t2.so -o %tout
// RUN: llvm-objdump -d -mattr=+morello --no-show-raw-insn %tout | FileCheck %s
// RUN: llvm-readobj -rS %tout | FileCheck --check-prefix=SEC --check-prefix=REL %s

  .globl  _start
_start:
  nop
  adrp    c0, :tlsdesc:foo
  ldr     c1, [c0, :tlsdesc_lo12:foo]
  add     c0, c0, :tlsdesc_lo12:foo
  .tlsdesccall foo
  blr     c1

// SEC:      Name: .got
// SEC-NEXT: Type: SHT_PROGBITS
// SEC-NEXT: Flags [
// SEC-NEXT:   SHF_ALLOC
// SEC-NEXT:   SHF_WRITE
// SEC-NEXT: ]
// SEC-NEXT: Address: 0x220340

// REL:      Relocations [
// REL-NEXT:   .rela.dyn {
// REL-NEXT:     0x220340 R_MORELLO_TLSDESC foo 0x0
// REL-NEXT:   }
// REL-NEXT: ]

/// page(0x220340) - page(0x210274) = 65536
/// 0x340 = 832

// CHECK:      _start:
// CHECK-NEXT: 210270: nop
// CHECK-NEXT: 210274: adrp    c0, #65536
// CHECK-NEXT: 210278: ldr     c1, [c0, #832]
// CHECK-NEXT: 21027c: add     c0, c0, #832
// CHECK-NEXT: 210280: blr     c1
