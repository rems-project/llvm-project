; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/atomic-rmw-cap-ptr.ll
; Reported as https://git.morello-project.org/morello/llvm-project/-/issues/34
; UNSUPPORTED: true
; LLVM ERROR: Cannot select: t5: f32,ch = AtomicLoadFAdd<(load store seq_cst 4 on %ir.ptr, addrspace 200)> t0, t2, t4
;   t2: iFATPTR128,ch = CopyFromReg t0, Register:iFATPTR128 %0
;     t1: iFATPTR128 = Register %0
;   t4: f32,ch = CopyFromReg t0, Register:f32 %1
;     t3: f32 = Register %1
; In function: atomic_cap_ptr_fadd

; Check that we can generate sensible code for atomic operations using capability pointers
; https://github.com/CTSRD-CHERI/llvm-project/issues/470
; RUN: llc -mtriple=aarch64 --relocation-model=pic -target-abi purecap -mattr=+morello,+c64 %s -o - | FileCheck %s --check-prefix=PURECAP
; RUN: llc -mtriple=aarch64 --relocation-model=pic -target-abi aapcs -mattr=+morello,-c64 %s -o - | FileCheck %s --check-prefix=HYBRID

define i64 @atomic_cap_ptr_xchg(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw xchg i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_add(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw add i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_sub(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw sub i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_and(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw and i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_nand(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw nand i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_or(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw or i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_xor(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw xor i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_max(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw max i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_min(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw min i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_umax(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw umax i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define i64 @atomic_cap_ptr_umin(i64 addrspace(200)* %ptr, i64 %val) nounwind {
  %tmp = atomicrmw umin i64 addrspace(200)* %ptr, i64 %val seq_cst
  ret i64 %tmp
}

define float @atomic_cap_ptr_fadd(float addrspace(200)* %ptr, float %val) nounwind {
  %tmp = atomicrmw fadd float addrspace(200)* %ptr, float %val seq_cst
  ret float %tmp
}

define float @atomic_cap_ptr_fsub(float addrspace(200)* %ptr, float %val) nounwind {
  %tmp = atomicrmw fsub float addrspace(200)* %ptr, float %val seq_cst
  ret float %tmp
}
