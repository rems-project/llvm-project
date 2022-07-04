@IF-MORELLO@; !DO NOT AUTOGEN! Fails with Morello right now:
@IF-MORELLO@; Reported as https://git.morello-project.org/morello/llvm-project/-/issues/34
@IF-MORELLO@; UNSUPPORTED: true
@IF-MORELLO@; LLVM ERROR: Cannot select: t5: f32,ch = AtomicLoadFAdd<(load store seq_cst 4 on %ir.ptr, addrspace 200)> t0, t2, t4
@IF-MORELLO@;   t2: iFATPTR128,ch = CopyFromReg t0, Register:iFATPTR128 %0
@IF-MORELLO@;     t1: iFATPTR128 = Register %0
@IF-MORELLO@;   t4: f32,ch = CopyFromReg t0, Register:f32 %1
@IF-MORELLO@;     t3: f32 = Register %1
@IF-MORELLO@; In function: atomic_cap_ptr_fadd

; Check that we can generate sensible code for atomic operations using capability pointers
; https://github.com/CTSRD-CHERI/llvm-project/issues/470
@IF-RISCV@; RUN: llc @PURECAP_HARDFLOAT_ARGS@ -mattr=+a < %s | FileCheck %s --check-prefixes=PURECAP,PURECAP-ATOMICS --allow-unused-prefixes
@IF-RISCV@; RUN: llc @PURECAP_HARDFLOAT_ARGS@ -mattr=-a < %s | FileCheck %s --check-prefixes=PURECAP,PURECAP-LIBCALLS --allow-unused-prefixes
@IFNOT-RISCV@; RUN: llc @PURECAP_HARDFLOAT_ARGS@ %s -o - | FileCheck %s --check-prefix=PURECAP
@IF-RISCV@; RUN: llc @HYBRID_HARDFLOAT_ARGS@ -mattr=+a < %s | FileCheck %s --check-prefixes=HYBRID,HYBRID-ATOMICS --allow-unused-prefixes
@IF-RISCV@; RUN: llc @HYBRID_HARDFLOAT_ARGS@ -mattr=-a < %s | FileCheck %s --check-prefixes=HYBRID,HYBRID-LIBCALLS --allow-unused-prefixes
@IFNOT-RISCV@; RUN: llc @HYBRID_HARDFLOAT_ARGS@ %s -o - | FileCheck %s --check-prefix=HYBRID

define iCAPRANGE @atomic_cap_ptr_xchg(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw xchg iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_add(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw add iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_sub(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw sub iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_and(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw and iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_nand(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw nand iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_or(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw or iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_xor(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw xor iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_max(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw max iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_min(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw min iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_umax(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw umax iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define iCAPRANGE @atomic_cap_ptr_umin(iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val) nounwind {
  %tmp = atomicrmw umin iCAPRANGE addrspace(200)* %ptr, iCAPRANGE %val seq_cst
  ret iCAPRANGE %tmp
}

define float @atomic_cap_ptr_fadd(float addrspace(200)* %ptr, float %val) nounwind {
  %tmp = atomicrmw fadd float addrspace(200)* %ptr, float %val seq_cst
  ret float %tmp
}

define float @atomic_cap_ptr_fsub(float addrspace(200)* %ptr, float %val) nounwind {
  %tmp = atomicrmw fsub float addrspace(200)* %ptr, float %val seq_cst
  ret float %tmp
}
