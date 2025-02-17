//===-- AArch64FixupKinds.h - AArch64 Specific Fixup Entries ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_MCTARGETDESC_AARCH64FIXUPKINDS_H
#define LLVM_LIB_TARGET_AARCH64_MCTARGETDESC_AARCH64FIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace AArch64 {

enum Fixups {
  // A 21-bit pc-relative immediate inserted into an ADR instruction.
  fixup_aarch64_pcrel_adr_imm21 = FirstTargetFixupKind,

  // A 21-bit pc-relative immediate inserted into an ADRP instruction.
  fixup_aarch64_pcrel_adrp_imm21,

  // A 20-bit pc-relative immediate inserted into an ADRP instruction (C64).
  fixup_aarch64_pcrel_adrp_imm20,

  // 12-bit fixup for add/sub instructions. No alignment adjustment. All value
  // bits are encoded.
  fixup_aarch64_add_imm12,

  // unsigned 12-bit fixups for load and store instructions.
  fixup_aarch64_ldst_imm12_scale1,
  fixup_aarch64_ldst_imm12_scale2,
  fixup_aarch64_ldst_imm12_scale4,
  fixup_aarch64_ldst_imm12_scale8,
  fixup_aarch64_ldst_imm12_scale16,

  // The high 19 bits of a 21-bit pc-relative immediate. Same encoding as
  // fixup_aarch64_pcrel_adrhi, except this is used by pc-relative loads and
  // generates relocations directly when necessary.
  fixup_aarch64_ldr_pcrel_imm19,

  // The high 17 bits of a 21-bit pc-relative immediate.
  fixup_aarch64_ldr_pcrel_imm17_scale16,

  // FIXME: comment
  fixup_aarch64_movw,

  // The high 14 bits of a 21-bit pc-relative immediate.
  fixup_aarch64_pcrel_branch14,

  // The high 19 bits of a 21-bit pc-relative immediate. Same encoding as
  // fixup_aarch64_pcrel_adrhi, except this is use by b.cc and generates
  // relocations directly when necessary.
  fixup_aarch64_pcrel_branch19,

  // The high 26 bits of a 28-bit pc-relative immediate.
  fixup_aarch64_pcrel_branch26,

  // The high 26 bits of a 28-bit pc-relative immediate. Distinguished from
  // branch26 only on ELF.
  fixup_aarch64_pcrel_call26,

  fixup_morello_pcrel_branch26,
  fixup_morello_pcrel_call26,

  // zero-space placeholder for the ELF R_MORELLO_TLSDESC_CALL relocation.
  fixup_morello_tlsdesc_call,

  // Same as fixup_aarch64_pcrel_branch14. Identifies the branch source as C64.
  fixup_morello_pcrel_branch14,

  // Same as fixup_aarch64_pcrel_branch19. Identifies the branch source as C64.
  fixup_morello_pcrel_branch19,

  // Marker
  LastTargetFixupKind,
  NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
};

} // end namespace AArch64
} // end namespace llvm

#endif
