; RUN: llc -mtriple=arm64 -mattr=+morello,+c64 -target-abi purecap -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; CHECK-LABEL: copy
; CHECK: bl memcpy
define i8 addrspace(200)* @copy(i8 addrspace(200)* returned %dst, i8 addrspace(200)* %a) local_unnamed_addr addrspace(200) {
entry:
  %a.addr.0..sroa_cast = bitcast i8 addrspace(200)* %dst to i8 addrspace(200)* addrspace(200)*
  store i8 addrspace(200)* %a, i8 addrspace(200)* addrspace(200)* %a.addr.0..sroa_cast, align 1
  ret i8 addrspace(200)* %dst
}
