// RUN: %cheri_purecap_cc1 -emit-llvm -o - -no-cheri-linker %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +c64 -target-abi purecap -emit-llvm -o - %s -no-cheri-linker | FileCheck %s --check-prefix=AARCH64
// RXUN: %cheri_purecap_cc1 -S -o - -no-cheri-linker %s | FileCheck %s -check-prefix ASM

// CHECK: @llvm.global_ctors = appending addrspace(200) global [1 x { i32, void () addrspace(200)*, i8 addrspace(200)* }] [
// CHECK-SAME: { i32, void () addrspace(200)*, i8 addrspace(200)* }
// CHECK-SAME: { i32 65535, void () addrspace(200)* @_GLOBAL__sub_I_cheri_struct_init.c, i8 addrspace(200)* null }]
// CHECK: __cxx_global_var_init

// AARCH64: @llvm.global_ctors = appending addrspace(200) global [1 x { i32, void () addrspace(200)*, i8 addrspace(200)* }] [
// AARCH64-SAME: { i32, void () addrspace(200)*, i8 addrspace(200)* }
// AARCH64-SAME: { i32 65535, void () addrspace(200)* @_GLOBAL__sub_I_cheri_struct_init.c, i8 addrspace(200)* null }]
// AARCH64: __cxx_global_var_init


// Check that this generates an initialiser
#define NULL (void*)0
const struct {
	const char magic[8];
	__SIZE_TYPE__ maglen;
	const char *argv[3];
	int silent;
} compr[] = {
	{ "\037\235", 2, { "gzip", "-cdq", NULL }, 1 },		/* compressed */
};

// Check that we emit the correct init_array loayout (a single .8byte value)
// ASM:     .section	.init_array,"aw",@init_array
// ASM-NEXT: .p2align	4
// ASM-NEXT: .chericap	_GLOBAL__sub_I_cheri_struct_init.c
