// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap %s -o - | llvm-readelf --notes - | FileCheck %s --check-prefixes=CHECK,PCREL
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=pcrel %s -o -| llvm-readelf --notes - | FileCheck %s --check-prefixes=CHECK,PCREL
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=fn-desc %s -o -| llvm-readelf --notes - | FileCheck %s --check-prefixes=CHECK,FDESC
// RUN: llvm-mc -filetype=obj -triple aarch64 -target-abi purecap -cheri-cap-table-abi=plt %s -o -| llvm-readelf --notes - | FileCheck %s --check-prefixes=CHECK,PLT


foo:

// CHECK: Displaying notes found in: .note.cheri
// CHECK-NEXT:  Owner                Data size 	Description
// CHECK-NEXT:  CHERI                0x00000004	NT_CHERI_GLOBALS_ABI (CHERI globals ABI)
// PCREL-NEXT:    Globals ABI: CHERI_GLOBALS_ABI_PCREL (PC-relative)
// PLT-NEXT:      Globals ABI: CHERI_GLOBALS_ABI_PLT_FPTR (PLT-based)
// FDESC-NEXT:    Globals ABI: CHERI_GLOBALS_ABI_FDESC (function descriptor-based)

// RUN: llvm-mc -filetype=obj -triple aarch64 %s -o - | llvm-readelf --notes - | FileCheck %s --allow-empty --check-prefixes=NONOTES
// NONOTES-NOT: Displaying notes found in: .note.cheri
