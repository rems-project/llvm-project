; RUN: llc -mtriple=arm64-linux-gnu -mattr=+morello -o - %s | FileCheck %s
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+morello -filetype=obj -o - %s | llvm-objdump --triple=arm64-linux-gnu --mattr=+morello - -r | FileCheck %s --check-prefix=A64-OBJ
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+c64,+morello -o - %s -target-abi purecap | FileCheck %s
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+c64,+morello -filetype=obj -o - %s -target-abi purecap | llvm-objdump --triple=arm64-linux-gnu --mattr=+morello - -r | FileCheck %s --check-prefix=C64-OBJ
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+c64,+morello -filetype=obj -o - %s -target-abi purecap | llvm-objdump --triple=arm64-linux-gnu - -r | FileCheck %s --check-prefix=C64-OBJ
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+morello -filetype=obj -o - %s | llvm-readelf -h - | FileCheck %s --check-prefix=A64-EFLAGS
; RUN: llc -mtriple=arm64-linux-gnu -mattr=+c64,+morello -filetype=obj -o - %s -target-abi purecap | llvm-readelf -h - | FileCheck %s --check-prefix=C64-EFLAGS

; A64-EFLAGS: Flags: 0x0
; C64-EFLAGS: Flags: 0x10000

declare void @callee()

define void @caller() {
  call void @callee()
  ret void
; CHECK-LABEL: caller:
; CHECK:     bl callee
; A64-OBJ: R_AARCH64_CALL26 callee
; C64-OBJ: R_MORELLO_CALL26 callee
}

define void @tail_caller() {
  tail call void @callee()
  ret void
; CHECK-LABEL: tail_caller:
; CHECK:     b callee
; A64-OBJ: R_AARCH64_JUMP26 callee
; C64-OBJ: R_MORELLO_JUMP26 callee
}
