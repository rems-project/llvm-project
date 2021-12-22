// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64 -mattr=+c64,+morello -target-abi purecap %s -filetype=obj -o %t.o
// RUN: ld.lld --morello-c64-plt -r %t.o -o %t2.o
// RUN: llvm-readobj --sections %t2.o | FileCheck %s

/// Test that we do not pad/align sections for representability when doing a
/// relocatable link, which would result in .text having an alignment of 8 and
/// .rodata having a size greater than 16384 (specifically, 7 more, given it's
/// misaligned to an offset of 1 by .text's size).

/// Force .rodata's VA to be misaligned for representability, and .text's
/// alignment to be too little for representability of the PCC segment.
.section .text, "ax", %progbits
.balign 4
.byte 0

/// Length < 16384 can use an internal exponent, anything greater must be 8
/// byte aligned and thus would trigger the alignment code.
.section .rodata, "a", %progbits
.space 16384

// CHECK-LABEL: Sections [
// CHECK-NEXT:    Section {
// CHECK-NEXT:      Index: 0
// CHECK-NEXT:      Name:
// CHECK-NEXT:      Type: SHT_NULL
// CHECK-NEXT:      Flags [
// CHECK-NEXT:      ]
// CHECK-NEXT:      Address: 0x0
// CHECK-NEXT:      Offset: 0x0
// CHECK-NEXT:      Size: 0
// CHECK-NEXT:      Link: 0
// CHECK-NEXT:      Info: 0
// CHECK-NEXT:      AddressAlignment: 0
// CHECK-NEXT:      EntrySize: 0
// CHECK-NEXT:    }
// CHECK-NEXT:    Section {
// CHECK-NEXT:      Index: 1
// CHECK-NEXT:      Name: .text
// CHECK-NEXT:      Type: SHT_PROGBITS
// CHECK-NEXT:      Flags [
// CHECK-NEXT:        SHF_ALLOC
// CHECK-NEXT:        SHF_EXECINSTR
// CHECK-NEXT:      ]
// CHECK-NEXT:      Address: 0x0
// CHECK-NEXT:      Offset: 0x40
// CHECK-NEXT:      Size: 1
// CHECK-NEXT:      Link: 0
// CHECK-NEXT:      Info: 0
// CHECK-NEXT:      AddressAlignment: 4
// CHECK-NEXT:      EntrySize: 0
// CHECK-NEXT:    }
// CHECK-NEXT:    Section {
// CHECK-NEXT:      Index: 2
// CHECK-NEXT:      Name: .rodata
// CHECK-NEXT:      Type: SHT_PROGBITS
// CHECK-NEXT:      Flags [
// CHECK-NEXT:        SHF_ALLOC
// CHECK-NEXT:      ]
// CHECK-NEXT:      Address: 0x0
// CHECK-NEXT:      Offset: 0x41
// CHECK-NEXT:      Size: 16384
// CHECK-NEXT:      Link: 0
// CHECK-NEXT:      Info: 0
// CHECK-NEXT:      AddressAlignment: 1
// CHECK-NEXT:      EntrySize: 0
// CHECK-NEXT:    }
