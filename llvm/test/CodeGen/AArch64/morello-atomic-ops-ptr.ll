; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+morello -verify-machineinstrs | FileCheck %s

; CHECK-LABEL: test_atomic_load_add_ptr
define i8 addrspace(200)* @test_atomic_load_add_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK-NOT: dmb
; CHECK: gcvalue x[[TMPADDR1:[0-9]+]], c0
; CHECK: ldaxr c[[OLD:[0-9]+]], [x1]
; CHECK: gcvalue x[[TMPADDR2:[0-9]+]], c[[OLD]]
; CHECK: add x[[RES:[0-9]+]], x[[TMPADDR2]], x[[TMPADDR1]]
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw add i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_sub_ptr
define i8 addrspace(200)* @test_atomic_load_sub_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: gcvalue x[[TMPADDR1:[0-9]+]], c0
; CHECK: ldaxr c[[OLD:[0-9]+]], [x1]
; CHECK: gcvalue x[[TMPADDR2:[0-9]+]], c[[OLD]]
; CHECK: sub x[[RES:[0-9]+]], x[[TMPADDR2]], x[[TMPADDR1]]
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stxr   w[[TOK:[0-9]+]], c[[NEW]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw sub i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_and_ptr
define i8 addrspace(200)* @test_atomic_load_and_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: gcvalue x[[TMPADDR1:[0-9]+]], c0
; CHECK: ldxr c[[OLD:[0-9]+]], [x1]
; CHECK: gcvalue x[[TMPADDR2:[0-9]+]], c[[OLD]]
; CHECK: and x[[RES:[0-9]+]], x[[TMPADDR2]], x[[TMPADDR1]]
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [x1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw and i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_or_ptr
define i8 addrspace(200)* @test_atomic_load_or_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: gcvalue x[[TMPADDR1:[0-9]+]], c0
; CHECK: ldxr c[[OLD:[0-9]+]], [x1]
; CHECK: gcvalue x[[TMPADDR2:[0-9]+]], c[[OLD]]
; CHECK: orr x[[RES:[0-9]+]], x[[TMPADDR2]], x[[TMPADDR1]]
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stxr   w[[TOK:[0-9]+]], c[[NEW]], [x1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw or i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xor_ptr
define i8 addrspace(200)* @test_atomic_load_xor_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: gcvalue x[[TMPADDR1:[0-9]+]], c0
; CHECK: ldaxr c[[OLD:[0-9]+]], [x1]
; CHECK: gcvalue x[[TMPADDR2:[0-9]+]], c[[OLD]]
; CHECK: eor x[[RES:[0-9]+]], x[[TMPADDR2]], x[[TMPADDR1]]
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [x1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw xor i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_monotonic
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_monotonic(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: swp c0, c0, [x1]
   %old = atomicrmw xchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_acquire
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_acquire(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: swpa c0, c0, [x1]
   %old = atomicrmw xchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_release
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_release(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: swpl c0, c0, [x1]
   %old = atomicrmw xchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_acq_rel
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_acq_rel(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: swpal c0, c0, [x1]
   %old = atomicrmw xchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset acq_rel
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_seq_cst
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_seq_cst(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: swpal c0, c0, [x1]
   %old = atomicrmw xchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_min_ptr
define i8 addrspace(200)* @test_atomic_load_min_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [x1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], le
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw min i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_max_ptr
define i8 addrspace(200)* @test_atomic_load_max_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [x1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], gt
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[RES]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw max i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_umin_ptr
define i8 addrspace(200)* @test_atomic_load_umin_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [x1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], ls
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw umin i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_umax_ptr
define i8 addrspace(200)* @test_atomic_load_umax_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) ** %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [x1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], hi
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [x1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw umax i8 addrspace(200)** %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_acquire
define i8 addrspace(200)* @test_cmpxchg_ptr_acquire(i8 addrspace(200)* %offset,
         i8 addrspace(200) ** %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new acquire acquire
; CHECK: mov c0, c2
; CHECK: casa c0, c3, [x1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_monotonic
define i8 addrspace(200)* @test_cmpxchg_ptr_monotonic(i8 addrspace(200)* %offset,
         i8 addrspace(200) ** %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new monotonic monotonic
; CHECK: mov c0, c2
; CHECK: cas c0, c3, [x1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_release
define i8 addrspace(200)* @test_cmpxchg_ptr_release(i8 addrspace(200)* %offset,
         i8 addrspace(200) ** %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new release monotonic
; CHECK: mov c0, c2
; CHECK: casl c0, c3, [x1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_acq_rel
define i8 addrspace(200)* @test_cmpxchg_ptr_acq_rel(i8 addrspace(200)* %offset,
         i8 addrspace(200) ** %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new acq_rel monotonic

; CHECK: mov c0, c2
; CHECK: casal c0, c3, [x1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_seq_cst
define i8 addrspace(200)* @test_cmpxchg_ptr_seq_cst(i8 addrspace(200)* %offset,
         i8 addrspace(200) ** %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)** %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new seq_cst monotonic
; CHECK: mov c0, c2
; CHECK: casal c0, c3, [x1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_monotonic_ptr
define i8 addrspace(200) * @test_atomic_load_monotonic_ptr(i8 addrspace(200) ** %ptr) nounwind {
; CHECK:  ldr    c0, [x0, #0]
  %val = load atomic i8 addrspace(200)*, i8 addrspace(200)** %ptr monotonic, align 16

  ret i8 addrspace(200) * %val
}

define void @CapabilityStoreSeqCst(i8 addrspace(200)* %v, i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityStoreSeqCst:
; CHECK: stlr c0, [x1]
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)** %addr seq_cst, align 16
  ret void
}

define void @CapabilityStoreMonotonic(i8 addrspace(200)* %v, i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityStoreMonotonic:
; CHECK: str c0, [x1, #0]
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)** %addr monotonic, align 16
  ret void
}

define void @CapabilityStoreRelease(i8 addrspace(200)* %v, i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityStoreRelease:
; CHECK: stlr c0, [x1]
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)** %addr release, align 16
  ret void
}

define i8 addrspace(200)* @CapabilityLoadSeqCst(i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityLoadSeqCst:
; CHECK: ldar c0, [x0]
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)** %addr seq_cst, align 16
  ret i8 addrspace(200)* %val
}

define i8 addrspace(200)* @CapabilityLoadAcq(i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityLoadAcq:
; CHECK: ldar c0, [x0]
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)** %addr acquire, align 16
  ret i8 addrspace(200)* %val
}
define i8 addrspace(200)* @CapabilityLoadMonotonic(i8 addrspace(200) ** %addr) nounwind {
; CHECK-LABEL: CapabilityLoadMonotonic:
; CHECK: ldr c0, [x0, #0]
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)** %addr monotonic, align 16
  ret i8 addrspace(200)* %val
}

; CHECK-LABEL: atomic_load_i8_acq_alt:
; CHECK: ldarb
define i8 @atomic_load_i8_acq_alt(i8 addrspace(200)* %p) #0 {
   %r = load atomic i8, i8 addrspace(200)* %p seq_cst, align 1
   ret i8 %r
}

; CHECK-LABEL: atomic_load_i8_alt:
; CHECK: ldurb
define i8 @atomic_load_i8_alt(i8 addrspace(200)* %p) #0 {
   %r = load atomic i8, i8 addrspace(200)* %p monotonic, align 1
   ret i8 %r
}

; CHECK-LABEL: atomc_store_i8_rel_alt:
; CHECK: stlrb
define void @atomc_store_i8_rel_alt(i8 addrspace(200)* %p) #0 {
   store atomic i8 4, i8 addrspace(200)* %p seq_cst, align 1
   ret void
}

; CHECK-LABEL: atomc_store_i8_alt:
; CHECK: sturb
define void @atomc_store_i8_alt(i8 addrspace(200)* %p) #0 {
   store atomic i8 4, i8 addrspace(200)* %p monotonic, align 1
   ret void
}

; CHECK-LABEL: atomic_load_i16_alt:
; CHECK: ldurh
define i16 @atomic_load_i16_alt(i16 addrspace(200)* %p) #0 {
   %r = load atomic i16, i16 addrspace(200)* %p monotonic, align 2
   ret i16 %r
}

; CHECK-LABEL: atomic_load_i16_seq_alt:
; CHECK: ldurh
define i16 @atomic_load_i16_seq_alt(i16 addrspace(200)* %p) #0 {
   %r = load atomic i16, i16 addrspace(200)* %p seq_cst, align 2
   ret i16 %r
}

; CHECK-LABEL: atomic_load_i16_acq_alt:
; CHECK: ldurh
define i16 @atomic_load_i16_acq_alt(i16 addrspace(200)* %p) #0 {
   %r = load atomic i16, i16 addrspace(200)* %p acquire, align 2
   ret i16 %r
}

; CHECK-LABEL: atomc_store_i16_seq_alt:
; CHECK: dmb     ish
; CHECK: sturh
; CHECK: dmb     ish
define void @atomc_store_i16_seq_alt(i16 addrspace(200)* %p) #0 {
   store atomic i16 4, i16 addrspace(200)* %p seq_cst, align 2
   ret void
}

; CHECK-LABEL: atomc_store_i16_rel_alt:
; CHECK: dmb     ish
; CHECK: sturh
; CHECK-NOT: dmb
define void @atomc_store_i16_rel_alt(i16 addrspace(200)* %p) #0 {
   store atomic i16 4, i16 addrspace(200)* %p release, align 2
   ret void
}

; CHECK-LABEL: atomc_store_i16_alt:
; CHECK: sturh
define void @atomc_store_i16_alt(i16 addrspace(200)* %p) #0 {
   store atomic i16 4, i16 addrspace(200)* %p monotonic, align 2
   ret void
}

; CHECK-LABEL: atomic_load_i32_acq_alt:
; CHECK: ldar w
define i32 @atomic_load_i32_acq_alt(i32 addrspace(200)* %p) #0 {
   %r = load atomic i32, i32 addrspace(200)* %p seq_cst, align 4
   ret i32 %r
}

; CHECK-LABEL: atomic_load_i32_alt:
; CHECK: ldur w
define i32 @atomic_load_i32_alt(i32 addrspace(200)* %p) #0 {
   %r = load atomic i32, i32 addrspace(200)* %p monotonic, align 4
   ret i32 %r
}

; CHECK-LABEL: atomc_store_i32_rel_alt:
; CHECK: stlr w
define void @atomc_store_i32_rel_alt(i32 addrspace(200)* %p) #0 {
   store atomic i32 4, i32 addrspace(200)* %p seq_cst, align 4
   ret void
}

; CHECK-LABEL: atomc_store_i32_alt:
; CHECK: stur w
define void @atomc_store_i32_alt(i32 addrspace(200)* %p) #0 {
   store atomic i32 4, i32 addrspace(200)* %p monotonic, align 4
   ret void
}

; CHECK-LABEL: atomic_load_i64_alt:
; CHECK: ldur
define i64 @atomic_load_i64_alt(i64 addrspace(200)* %p) #0 {
   %r = load atomic i64, i64 addrspace(200)* %p monotonic, align 8
   ret i64 %r
}

; CHECK-LABEL: atomic_load_i64_seq_alt:
; CHECK: ldur
; CHECK: dmb ish
define i64 @atomic_load_i64_seq_alt(i64 addrspace(200)* %p) #0 {
   %r = load atomic i64, i64 addrspace(200)* %p seq_cst, align 8
   ret i64 %r
}

; CHECK-LABEL: atomic_load_i64_acq_alt:
; CHECK: ldur
; CHECK: dmb ishld
define i64 @atomic_load_i64_acq_alt(i64 addrspace(200)* %p) #0 {
   %r = load atomic i64, i64 addrspace(200)* %p acquire, align 8
   ret i64 %r
}

; CHECK-LABEL: atomc_store_i64_alt:
; CHECK: stur
define void @atomc_store_i64_alt(i64 addrspace(200)* %p) #0 {
   store atomic i64 4, i64 addrspace(200)* %p monotonic, align 8
   ret void
}

; CHECK-LABEL: atomc_store_i64_rel_alt:
; CHECK: dmb     ish
; CHECK: stur
; CHECK-NOT: dmb     ish
define void @atomc_store_i64_rel_alt(i64 addrspace(200)* %p) #0 {
   store atomic i64 4, i64 addrspace(200)* %p release, align 8
   ret void
}

; CHECK-LABEL: atomc_store_i64_seq_alt:
; CHECL: dmb     ish
; CHECK: stur
; CHECK: dmb     ish
define void @atomc_store_i64_seq_alt(i64 addrspace(200)* %p) #0 {
   store atomic i64 4, i64 addrspace(200)* %p seq_cst, align 8
   ret void
}

; CHECK-LABEL: atomic_load_fatptr_acq_alt:
; CHECK: ldar c
define i8 addrspace(200)* @atomic_load_fatptr_acq_alt(i8 addrspace(200)* addrspace(200)* %p) #0 {
   %r = load atomic i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %p seq_cst, align 16
   ret i8 addrspace(200)* %r
}

; CHECK-LABEL: atomic_load_fatptr_alt:
; CHECK: ldur c
define i8 addrspace(200)* @atomic_load_fatptr_alt(i8 addrspace(200)* addrspace(200)* %p) #0 {
   %r = load atomic i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %p monotonic, align 16
   ret i8 addrspace(200)* %r
}

; CHECK-LABEL: atomc_store_fatptr_rel_alt:
; CHECK: stlr c
define void @atomc_store_fatptr_rel_alt(i8 addrspace(200)* addrspace(200)* %p) #0 {
   store atomic i8 addrspace(200)* null, i8 addrspace(200)* addrspace(200)* %p seq_cst, align 16
   ret void
}

; CHECK-LABEL: atomc_store_fatptr_alt:
; CHECK: stur c
define void @atomc_store_fatptr_alt(i8 addrspace(200)* addrspace(200)* %p) #0 {
   store atomic i8 addrspace(200)* null, i8 addrspace(200)* addrspace(200)* %p monotonic, align 16
   ret void
}
