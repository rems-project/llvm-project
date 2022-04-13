/// Check relaxation from Global Dynamic to Local Executable

// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-linux %s -o %tmain.o -target-abi purecap -mattr=+c64,+morello
// RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-linux %p/Inputs/aarch64-c64-tls-gdle.s -o %ttlsle.o -target-abi purecap -mattr=+c64,+morello
// RUN: ld.lld %tmain.o %ttlsle.o -o %tout
// RUN: llvm-objdump -d --mattr=+morello --print-imm-hex --no-show-raw-insn %tout | FileCheck %s
// RUN: llvm-readobj -rS %tout | FileCheck --check-prefix=REL --check-prefix=SEC %s
// RUN: llvm-readobj -x .rodata %tout | FileCheck %s --check-prefix=DATA

  .globl _start
_start:
  adrp    c0, :tlsdesc:foo
  ldr     c1, [c0, :tlsdesc_lo12:foo]
  add     c0, c0, :tlsdesc_lo12:foo
  nop
  .tlsdesccall foo
  blr     c1

  adrp    c0, :tlsdesc:bar
  ldr     c1, [c0, :tlsdesc_lo12:bar]
  add     c0, c0, :tlsdesc_lo12:bar
  nop
  .tlsdesccall bar
  blr     c1

  adrp    c0, :tlsdesc:foo
  ldr     c1, [c0, :tlsdesc_lo12:foo]
  add     c0, c0, :tlsdesc_lo12:foo
  nop
  .tlsdesccall foo
  blr     c1

// SEC:    Name: .rodata
// SEC-NEXT:    Type: SHT_PROGBITS
// SEC-NEXT:    Flags [
// SEC-NEXT:      SHF_ALLOC
// SEC-NEXT:    ]
// SEC-NEXT:    Address: 0x2001E0
// SEC-NEXT:    Offset:
// SEC-NEXT:    Size: 32

/// foo is in the same module. So no dynamic relocations needed.
// REL:      Relocations [
// REL-NEXT: ]

// The offset and size of foo and bar are encoded in .rodata.
// DATA: Hex dump of section '.rodata':
// DATA-NEXT: 0x002001e0 20edfe00 00000000 00efbe00 00000000
// DATA-NEXT: 0x002001f0 20000000 00000000 00edfe00 00000000

/// page(0x2001E0) - page(0x210200) = -0x10000

// CHECK:      <_start>:
// CHECK-NEXT:  210200:      	adrp	c0, 0x200000
// CHECK-NEXT:  210204:      	add	c0, c0, #0x1e0
// CHECK-NEXT:  210208:      	ldp	x0, x1, [c0]
// CHECK-NEXT:  21020c:      	add	c0, c2, x0, uxtx
// CHECK-NEXT:  210210:      	scbnds	c0, c0, x1
// CHECK-NEXT:  210214:      	adrp	c0, 0x200000
// CHECK-NEXT:  210218:      	add	c0, c0, #0x1f0
// CHECK-NEXT:  21021c:      	ldp	x0, x1, [c0]
// CHECK-NEXT:  210220:      	add	c0, c2, x0, uxtx
// CHECK-NEXT:  210224:      	scbnds	c0, c0, x1
// CHECK-NEXT:  210228:      	adrp	c0, 0x200000
// CHECK-NEXT:  21022c:      	add	c0, c0, #0x1e0
// CHECK-NEXT:  210230:      	ldp	x0, x1, [c0]
// CHECK-NEXT:  210234:      	add	c0, c2, x0, uxtx
// CHECK-NEXT:  210238:      	scbnds	c0, c0, x1
