// REQUIRES: aarch64

// RUN: llvm-mc --triple=aarch64-none-elf -target-abi purecap -cheri-cap-table-abi=fn-desc -mattr=+c64 -filetype=obj %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-readelf --notes %t | FileCheck %s --check-prefix=NT-MERGED-NOTES

// NT-MERGED-NOTES:      Displaying notes found in: .note.cheri
// NT-MERGED-NOTES-NEXT:   Owner                Data size 	Description
// NT-MERGED-NOTES-NEXT:   CHERI                0x00000004	NT_CHERI_GLOBALS_ABI (CHERI globals ABI)
// NT-MERGED-NOTES-NEXT:     Globals ABI: CHERI_GLOBALS_ABI_FDESC (function descriptor-based)
// NT-MERGED-NOTES-NEXT:   CHERI                0x00000004	NT_CHERI_TLS_ABI (CHERI thread-local storage ABI)
// NT-MERGED-NOTES-NEXT:     TLS ABI: CHERI_TLS_ABI_TRAD (traditional)
// NT-MERGED-NOTES-NEXT:   CHERI                0x00000004	NT_CHERI_MORELLO_PURECAP_BENCHMARK_ABI (Morello purecap benchmark ABI)
// NT-MERGED-NOTES-NEXT:     Purecap benchmark ABI enabled: 0 (no)

.section .note.cheri, "a", @note

/// The Globals ABI Note
.long 6
.long 4
/// NT_CHERI_GLOBALS_ABI = 0
.long 0
.asciz "CHERI"
.align 2
/// NT_CHERI_GLOBALS_ABI variant = 2
.long 2


/// The TLS ABI Note
.long 6
.long 4
/// NT_CHERI_TLS_ABI = 1
.long 1
.asciz "CHERI"
.align 2
/// NT_CHERI_TLS_ABI variant = 0
.long 0


/// The Morello purecap benchmark ABI Note
.long 6
.long 4
/// NT_CHERI_MORELLO_PURECAP_BENCHMARK_ABI = 0x80000000
.long 0x80000000
.asciz "CHERI"
.align 2
/// no = 0
.long 0
