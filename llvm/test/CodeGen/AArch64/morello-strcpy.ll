; RUN: opt -instcombine -march=arm64 -mattr=+c64 -target-abi purecap -S -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

@.str = private unnamed_addr addrspace(200) constant [5 x i8] c"dsad\00", align 1

; CHECK-LABEL: fun
define void @fun(i8 addrspace(200)* %tt) addrspace(200) {
entry:
; CHECK: llvm.memcpy.p200i8.p200i8.i64
  %call = call i8 addrspace(200)* @strcpy(i8 addrspace(200)* %tt, i8 addrspace(200)* getelementptr inbounds ([5 x i8], [5 x i8] addrspace(200)* @.str, i32 0, i32 0))
  ret void
}

declare i8 addrspace(200)* @strcpy(i8 addrspace(200)*, i8 addrspace(200)*) addrspace(200)
