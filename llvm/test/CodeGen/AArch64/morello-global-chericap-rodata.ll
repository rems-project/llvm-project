; RUN: llc -mtriple=aarch64 --relocation-model=static -target-abi aapcs -mattr=+morello %s -o - | FileCheck %s --check-prefix=ASM

; This should be a cheri-generic test however we need the static relocation model.

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

%struct.mstruct = type { i8 addrspace(200)*, i32 (i8*)* }

@__const.bar.args0 = constant %struct.mstruct { i8 addrspace(200)* null, i32 (i8*)* @dummy }, align 16
; ASM:      .type __const.bar.args0,@object
; ASM-NEXT: .section .rodata
; ASM-NEXT: .globl __const.bar.args0
; ASM-NEXT: .p2align	4
; ASM-NEXT: __const.bar.args0:
; ASM-NEXT: .chericap 0

@__const.bar.args1 = constant %struct.mstruct { i8 addrspace(200)* addrspacecast (i8* bitcast (i32 (i8*)* @dummy to i8*) to i8 addrspace(200)*), i32 (i8*)* @dummy }, align 16
; ASM:      .type __const.bar.args1,@object
; ASM-NEXT: .section .data.rel.ro
; ASM-NEXT: .globl __const.bar.args1
; ASM-NEXT: .p2align	4
; ASM-NEXT: __const.bar.args1:
; ASM-NEXT: .chericap	dummy

@__const.bar.args2 = constant %struct.mstruct { i8 addrspace(200)* inttoptr (i64 23 to i8 addrspace(200)*), i32 (i8*)* @dummy }, align 16
; ASM:      .type __const.bar.args2,@object
; ASM-NEXT: .section .rodata
; ASM-NEXT: .globl __const.bar.args2
; ASM-NEXT: .p2align	4
; ASM-NEXT: __const.bar.args2:
; ASM-NEXT: .chericap	23

@__const.bar.args3 = constant %struct.mstruct { i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 23), i32 (i8*)* @dummy }, align 16
; ASM:      .type __const.bar.args3,@object
; ASM-NOT:  .section
; ASM-NEXT: .globl __const.bar.args3
; ASM-NEXT: .p2align	4
; ASM-NEXT: __const.bar.args3:
; ASM-NEXT: .chericap	23

declare i32 @dummy(i8*)
