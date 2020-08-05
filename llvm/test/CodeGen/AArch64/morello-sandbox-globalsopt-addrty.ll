; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap  -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

$_Z3fooIiET_S0_ = comdat any

@test = addrspace(200) global i32 0, align 4
@llvm.global_ctors = appending addrspace(200) global [1 x { i32, void () addrspace(200)*, i8 addrspace(200)* }] [{ i32, void () addrspace(200)*, i8 addrspace(200)* } { i32 65535, void () addrspace(200)* @_GLOBAL__sub_I_unnamed.cpp, i8 addrspace(200)* null }]

define internal void @__cxx_global_var_init() addrspace(200) {
entry:
; CHECK: adrp c0, __cap__Z3fooIiET_S0_
; CHECK-NEXT: ldr c0, [c0, :lo12:__cap__Z3fooIiET_S0_]
; CHECK-NEXT: bl _Z3barQPFiiE
  %call = call i32 @_Z3barQPFiiE(i32 (i32) addrspace(200)* @_Z3fooIiET_S0_)
  store volatile i32 %call, i32 addrspace(200)* @test, align 4
  ret void
}

declare i32 @_Z3barQPFiiE(i32 (i32) addrspace(200)*) addrspace(200)

define internal i32 @_Z3fooIiET_S0_(i32 %val) addrspace(200) comdat {
entry:
  %val.addr = alloca i32, align 4, addrspace(200)
  store i32 %val, i32 addrspace(200)* %val.addr, align 4
  %0 = load i32, i32 addrspace(200)* %val.addr, align 4
  ret i32 %0
}

define internal void @_GLOBAL__sub_I_unnamed.cpp() addrspace(200) {
entry:
  call void @__cxx_global_var_init()
  ret void
}

; CHECK:	.hidden	__cap__Z3fooIiET_S0_    // @__cap__Z3fooIiET_S0_
; CHECK-NEXT:	.type	__cap__Z3fooIiET_S0_,@object
; CHECK-NEXT:	.section	.data.rel.ro.__cap__Z3fooIiET_S0_,"aGw",@progbits,__cap__Z3fooIiET_S0_,comdat
; CHECK-NEXT:	.weak	__cap__Z3fooIiET_S0_
; CHECK-NEXT:	.p2align	4
; CHECK-NEXT:   __cap__Z3fooIiET_S0_:
; CHECK-NEXT:	.capinit _Z3fooIiET_S0_
; CHECK-NEXT:	.xword	0
; CHECK-NEXT:	.xword	0
; CHECK-NEXT:	.size	__cap__Z3fooIiET_S0_, 16
