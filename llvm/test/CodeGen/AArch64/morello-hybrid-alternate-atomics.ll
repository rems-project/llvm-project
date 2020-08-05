; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+morello -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+morello,+lse -verify-machineinstrs | FileCheck %s

; ATOMIC_LOAD_ADD
define i128 @test_atomic_load_add_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_i128_alt:
; CHECK: bl __sync_fetch_and_add_16_c
   %old = atomicrmw add i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_add_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_fatptr_alt:
; CHECK: bl __sync_fetch_and_add_cap_c
   %old = atomicrmw add i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_add_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_i64_alt:
; CHECK: bl __sync_fetch_and_add_8_c
   %old = atomicrmw add i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_add_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_i32_alt:
; CHECK: bl __sync_fetch_and_add_4_c
   %old = atomicrmw add i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_add_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_i16_alt:
; CHECK: bl __sync_fetch_and_add_2_c
   %old = atomicrmw add i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_add_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_add_i8_alt:
; CHECK: bl __sync_fetch_and_add_1_c
   %old = atomicrmw add i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_SUB
define i128 @test_atomic_load_sub_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_i128_alt:
; CHECK: bl __sync_fetch_and_sub_16_c
   %old = atomicrmw sub i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_sub_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_fatptr_alt:
; CHECK: bl __sync_fetch_and_sub_cap_c
   %old = atomicrmw sub i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_sub_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_i64_alt:
; CHECK: bl __sync_fetch_and_sub_8_c
   %old = atomicrmw sub i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_sub_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_i32_alt:
; CHECK: bl __sync_fetch_and_sub_4_c
   %old = atomicrmw sub i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_sub_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_i16_alt:
; CHECK: bl __sync_fetch_and_sub_2_c
   %old = atomicrmw sub i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_sub_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_sub_i8_alt:
; CHECK: bl __sync_fetch_and_sub_1_c
   %old = atomicrmw sub i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_OR
define i128 @test_atomic_load_or_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_i128_alt:
; CHECK: bl __sync_fetch_and_or_16_c
   %old = atomicrmw or i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_or_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_fatptr_alt:
; CHECK: bl __sync_fetch_and_or_cap_c
   %old = atomicrmw or i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_or_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_i64_alt:
; CHECK: bl __sync_fetch_and_or_8_c
   %old = atomicrmw or i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_or_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_i32_alt:
; CHECK: bl __sync_fetch_and_or_4_c
   %old = atomicrmw or i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_or_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_i16_alt:
; CHECK: bl __sync_fetch_and_or_2_c
   %old = atomicrmw or i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_or_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_or_i8_alt:
; CHECK: bl __sync_fetch_and_or_1_c
   %old = atomicrmw or i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_XOR

define i128 @test_atomic_load_xor_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_i128_alt:
; CHECK: bl __sync_fetch_and_xor_16_c
   %old = atomicrmw xor i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_xor_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_fatptr_alt:
; CHECK: bl __sync_fetch_and_xor_cap_c
   %old = atomicrmw xor i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_xor_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_i64_alt:
; CHECK: bl __sync_fetch_and_xor_8_c
   %old = atomicrmw xor i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_xor_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_i32_alt:
; CHECK: bl __sync_fetch_and_xor_4_c
   %old = atomicrmw xor i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_xor_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_i16_alt:
; CHECK: bl __sync_fetch_and_xor_2_c
   %old = atomicrmw xor i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_xor_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xor_i8_alt:
; CHECK: bl __sync_fetch_and_xor_1_c
   %old = atomicrmw xor i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_AND

define i128 @test_atomic_load_and_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_i128_alt:
; CHECK: bl __sync_fetch_and_and_16_c
   %old = atomicrmw and i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_and_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_fatptr_alt:
; CHECK: bl __sync_fetch_and_and_cap_c
   %old = atomicrmw and i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_and_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_i64_alt:
; CHECK: bl __sync_fetch_and_and_8_c
   %old = atomicrmw and i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_and_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_i32_alt:
; CHECK: bl __sync_fetch_and_and_4_c
   %old = atomicrmw and i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_and_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_i16_alt:
; CHECK: bl __sync_fetch_and_and_2_c
   %old = atomicrmw and i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_and_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_and_i8_alt:
; CHECK: bl __sync_fetch_and_and_1_c
   %old = atomicrmw and i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_NAND

define i128 @test_atomic_load_nand_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_i128_alt:
; CHECK: bl __sync_fetch_and_nand_16_c
   %old = atomicrmw nand i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_nand_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_fatptr_alt:
; CHECK: bl __sync_fetch_and_nand_cap_c
   %old = atomicrmw nand i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_nand_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_i64_alt:
; CHECK: bl __sync_fetch_and_nand_8_c
   %old = atomicrmw nand i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_nand_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_i32_alt:
; CHECK: bl __sync_fetch_and_nand_4_c
   %old = atomicrmw nand i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_nand_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_i16_alt:
; CHECK: bl __sync_fetch_and_nand_2_c
   %old = atomicrmw nand i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_nand_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_nand_i8_alt:
; CHECK: bl __sync_fetch_and_nand_1_c
   %old = atomicrmw nand i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_MIN

define i128 @test_atomic_load_min_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_i128_alt:
; CHECK: bl __sync_fetch_and_min_16_c
   %old = atomicrmw min i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_min_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_fatptr_alt:
; CHECK: bl __sync_fetch_and_min_cap_c
   %old = atomicrmw min i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_min_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_i64_alt:
; CHECK: bl __sync_fetch_and_min_8_c
   %old = atomicrmw min i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_min_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_i32_alt:
; CHECK: bl __sync_fetch_and_min_4_c
   %old = atomicrmw min i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_min_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_i16_alt:
; CHECK: bl __sync_fetch_and_min_2_c
   %old = atomicrmw min i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_min_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_min_i8_alt:
; CHECK: bl __sync_fetch_and_min_1_c
   %old = atomicrmw min i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_UMIN

define i128 @test_atomic_load_umin_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_i128_alt:
; CHECK: bl __sync_fetch_and_umin_16_c
   %old = atomicrmw umin i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_umin_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_fatptr_alt:
; CHECK: bl __sync_fetch_and_umin_cap_c
   %old = atomicrmw umin i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_umin_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_i64_alt:
; CHECK: bl __sync_fetch_and_umin_8_c
   %old = atomicrmw umin i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_umin_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_i32_alt:
; CHECK: bl __sync_fetch_and_umin_4_c
   %old = atomicrmw umin i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_umin_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_i16_alt:
; CHECK: bl __sync_fetch_and_umin_2_c
   %old = atomicrmw umin i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_umin_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umin_i8_alt:
; CHECK: bl __sync_fetch_and_umin_1_c
   %old = atomicrmw umin i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_UMAX

define i128 @test_atomic_load_umax_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_i128_alt:
; CHECK: bl __sync_fetch_and_umax_16_c
   %old = atomicrmw umax i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_umax_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_fatptr_alt:
; CHECK: bl __sync_fetch_and_umax_cap_c
   %old = atomicrmw umax i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_umax_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_i64_alt:
; CHECK: bl __sync_fetch_and_umax_8_c
   %old = atomicrmw umax i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_umax_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_i32_alt:
; CHECK: bl __sync_fetch_and_umax_4_c
   %old = atomicrmw umax i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_umax_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_i16_alt:
; CHECK: bl __sync_fetch_and_umax_2_c
   %old = atomicrmw umax i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_umax_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_umax_i8_alt:
; CHECK: bl __sync_fetch_and_umax_1_c
   %old = atomicrmw umax i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_LOAD_MAX

define i128 @test_atomic_load_max_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_i128_alt:
; CHECK: bl __sync_fetch_and_max_16_c
   %old = atomicrmw max i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_max_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_fatptr_alt:
; CHECK: bl __sync_fetch_and_max_cap_c
   %old = atomicrmw max i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_max_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_i64_alt:
; CHECK: bl __sync_fetch_and_max_8_c
   %old = atomicrmw max i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_max_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_i32_alt:
; CHECK: bl __sync_fetch_and_max_4_c
   %old = atomicrmw max i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_max_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_i16_alt:
; CHECK: bl __sync_fetch_and_max_2_c
   %old = atomicrmw max i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_max_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_max_i8_alt:
; CHECK: bl __sync_fetch_and_max_1_c
   %old = atomicrmw max i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_SWAP

define i128 @test_atomic_load_xchg_i128_alt(i128 %offset, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_i128_alt:
; CHECK: bl __sync_lock_test_and_set_16_c
   %old = atomicrmw xchg i128 addrspace(200)* %ptr, i128 %offset seq_cst
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_load_xchg_fatptr_alt(i8 addrspace(200)* %offset, i8 addrspace(200)* addrspace(200)*  %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_fatptr_alt:
; CHECK: bl __sync_lock_test_and_set_cap_c
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %offset seq_cst
   ret i8 addrspace(200)* %old
}

define i64 @test_atomic_load_xchg_i64_alt(i64 %offset, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_i64_alt:
; CHECK: bl __sync_lock_test_and_set_8_c
   %old = atomicrmw xchg i64 addrspace(200)* %ptr, i64 %offset seq_cst
   ret i64 %old
}

define i32 @test_atomic_load_xchg_i32_alt(i32 %offset, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_i32_alt:
; CHECK: bl __sync_lock_test_and_set_4_c
   %old = atomicrmw xchg i32 addrspace(200)* %ptr, i32 %offset seq_cst
   ret i32 %old
}

define i16 @test_atomic_load_xchg_i16_alt(i16 %offset, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_i16_alt:
; CHECK: bl __sync_lock_test_and_set_2_c
   %old = atomicrmw xchg i16 addrspace(200)* %ptr, i16 %offset seq_cst
   ret i16 %old
}

define i8 @test_atomic_load_xchg_i8_alt(i8 %offset, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_load_xchg_i8_alt:
; CHECK: bl __sync_lock_test_and_set_1_c
   %old = atomicrmw xchg i8 addrspace(200)* %ptr, i8 %offset seq_cst
   ret i8 %old
}

; ATOMIC_CMP_SWAP

define i8 @test_atomic_cmpxchg_i8(i8 %wanted, i8 %new, i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_i8:
; CHECK: bl __sync_val_compare_and_swap_1_c
   %pair = cmpxchg i8 addrspace(200)* %ptr, i8 %wanted, i8 %new acquire acquire
   %old = extractvalue { i8, i1 } %pair, 0
   ret i8 %old
}

define i16 @test_atomic_cmpxchg_i16(i16 %wanted, i16 %new, i16 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_i16:
; CHECK: bl __sync_val_compare_and_swap_2_c
   %pair = cmpxchg i16 addrspace(200)* %ptr, i16 %wanted, i16 %new acquire acquire
   %old = extractvalue { i16, i1 } %pair, 0
   ret i16 %old
}

define i32 @test_atomic_cmpxchg_i32(i32 %wanted, i32 %new, i32 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_i32:
; CHECK: bl __sync_val_compare_and_swap_4_c
   %pair = cmpxchg i32 addrspace(200)* %ptr, i32 %wanted, i32 %new acquire acquire
   %old = extractvalue { i32, i1 } %pair, 0
   ret i32 %old
}

define i64 @test_atomic_cmpxchg_i64(i64 %wanted, i64 %new, i64 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_i64:
; CHECK: bl __sync_val_compare_and_swap_8_c
   %pair = cmpxchg i64 addrspace(200)* %ptr, i64 %wanted, i64 %new acquire acquire
   %old = extractvalue { i64, i1 } %pair, 0
   ret i64 %old
}

define i128 @test_atomic_cmpxchg_i128(i128 %wanted, i128 %new, i128 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_i128:
; CHECK: bl __sync_val_compare_and_swap_16_c
   %pair = cmpxchg i128 addrspace(200)* %ptr, i128 %wanted, i128 %new acquire acquire
   %old = extractvalue { i128, i1 } %pair, 0
   ret i128 %old
}

define i8 addrspace(200)* @test_atomic_cmpxchg_fatptr(i8 addrspace(200)* %wanted, i8 addrspace(200)* %new, i8 addrspace(200)* addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test_atomic_cmpxchg_fatptr:
; CHECK: bl __sync_val_compare_and_swap_cap_c
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200)* %wanted, i8 addrspace(200)* %new acquire acquire
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

