# REQUIRES: aarch64-registered-target
# RUN: %clang -target aarch64-none-elf -march=morello -mabi=purecap-desc %s -c -o - | llvm-readelf --notes - | FileCheck %s

# CHECK: Displaying notes found in: .note.cheri
# CHECK-NEXT:  Owner                Data size 	Description
# CHECK-NEXT:  CHERI                0x00000004	NT_CHERI_GLOBALS_ABI (CHERI globals ABI)
# CHECK-NEXT:    Globals ABI: CHERI_GLOBALS_ABI_FDESC (function descriptor-based)
