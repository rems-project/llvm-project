; RUN: llc -mtriple=aarch64-none-none-eabi -mattr=+morello,c64 -target-abi purecap -o - %s | FileCheck %s --check-prefix=c64

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"

@llvm.global_ctors = appending addrspace(200) global [1 x { i32, void () addrspace(200)*, i8 addrspace(200)* }] [{ i32, void () addrspace(200)*, i8 addrspace(200)* } { i32 65535, void () addrspace(200)* @_ZN3Foo3fooEv, i8 addrspace(200)* null }]

define linkonce_odr void @_ZN3Foo3fooEv() addrspace(200) {
  ret void
}

; a64:    .section	.init_array,"aw",@init_array
; a64:    .p2align 4
; a64:    .chericap _ZN3Foo3fooEv

; c64:    .section	.init_array,"aw",@init_array
; c64:    .p2align 4
; c64:    .chericap _ZN3Foo3fooEv
