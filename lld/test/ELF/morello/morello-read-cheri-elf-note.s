// RUN: rm -rf %t && split-file %s %t && cd %t

// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap lib.s -o lib.o
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap app.s -o app.o
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=pcrel lib.s -o lib1.o
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=pcrel app.s -o app1.o
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=fn-desc lib.s -o lib2.o
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=fn-desc app.s -o app2.o

// RUN: ld.lld app.o lib.o -o app 2>&1 | FileCheck %s --check-prefix=NOERROR --allow-empty
// RUN: llvm-readobj -h --notes app | FileCheck %s --check-prefix=NT-PCREL
// RUN: ld.lld app1.o lib1.o -o app1 2>&1 | FileCheck %s --check-prefix=NOERROR --allow-empty
// RUN: llvm-readobj -h --notes app1 | FileCheck %s --check-prefix=NT-PCREL
// RUN: ld.lld app2.o lib2.o -o app2 2>&1 | FileCheck %s --check-prefix=NOERROR --allow-empty
// RUN: llvm-readobj -h --notes app2 | FileCheck %s --check-prefix=NT-FDESC
// RUN: ld.lld app.o lib1.o -o app3 2>&1 | FileCheck %s --check-prefix=NOERROR --allow-empty
// RUN: llvm-readobj -h --notes app3 | FileCheck %s --check-prefix=NT-PCREL
// RUN: not ld.lld app.o lib2.o -o app4 2>&1 | FileCheck %s --check-prefix=ERROR
// RUN: not ld.lld app1.o lib2.o -o app5 2>&1 | FileCheck %s --check-prefix=ERROR
// ERROR: error: {{.*}} NT_CHERI_GLOBALS_ABI variant mismatch: CHERI_GLOBALS_ABI_FDESC vs CHERI_GLOBALS_ABI_PCREL
// NOERROR-NOT: error:
// NT-PCREL: NoteSection {
// NT-PCREL-NEXT:   Name: .note.cheri
// NT-PCREL-NEXT:   Offset:
// NT-PCREL-NEXT:   Size: 0x18
// NT-PCREL-NEXT:   Note {
// NT-PCREL-NEXT:     Owner: CHERI
// NT-PCREL-NEXT:     Data size: 0x4
// NT-PCREL-NEXT:     Type: NT_CHERI_GLOBALS_ABI (CHERI globals ABI)
// NT-PCREL-NEXT:     Globals ABI: CHERI_GLOBALS_ABI_PCREL (PC-relative)
// NT-PCREL-NEXT:   }
// NT-PCREL-NEXT: }
// NT-FDESC: NoteSection {
// NT-FDESC-NEXT:   Name: .note.cheri
// NT-FDESC-NEXT:   Offset:
// NT-FDESC-NEXT:   Size: 0x18
// NT-FDESC-NEXT:   Note {
// NT-FDESC-NEXT:     Owner: CHERI
// NT-FDESC-NEXT:     Data size: 0x4
// NT-FDESC-NEXT:     Type: NT_CHERI_GLOBALS_ABI (CHERI globals ABI)
// NT-FDESC-NEXT:     Globals ABI: CHERI_GLOBALS_ABI_FDESC (function descriptor-based)
// NT-FDESC-NEXT:   }
// NT-FDESC-NEXT: }

//--- app.s
.globl _start
_start:
  ret

//--- lib.s
.globl lib
lib:
  ret
