; RUN: llc %s -march=aarch64 -mattr=+morello,+c64 -target-abi purecap -o - 2>&1 | FileCheck %s --check-prefix=WARN
; RUN: llc %s -march=aarch64 -mattr=+morello,+c64 -target-abi purecap -warn-cheri-inefficient=true -o - 2>&1 | FileCheck %s --check-prefix=WARN
; RUN: llc %s -march=aarch64 -mattr=+morello,+c64 -target-abi purecap -warn-cheri-inefficient=false -o - 2>&1 | FileCheck %s --check-prefix=NOWARN

; WARN: in function f i8 addrspace(200)* (i8 addrspace(200)*): found underaligned load of capability type (aligned to 1 bytes instead of 16). Will use memcpy() instead of capability load to preserve tags if it is aligned correctly at runtime
; NOWARN-NOT: in function f i8 addrspace(200)* (i8 addrspace(200)*): found underaligned load of capability type (aligned to 1 bytes instead of 16). Will use memcpy() instead of capability load to preserve tags if it is aligned correctly at runtime


target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

define i8 addrspace(200)* @f(i8 addrspace(200)* nocapture readonly %c) local_unnamed_addr addrspace(200) {
entry:
  %0 = bitcast i8 addrspace(200)* %c to i8 addrspace(200)* addrspace(200)*
  %1 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %0, align 1
  ret i8 addrspace(200)* %1
}
