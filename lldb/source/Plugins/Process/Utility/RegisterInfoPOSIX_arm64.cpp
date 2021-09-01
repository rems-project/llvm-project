//===-- RegisterInfoPOSIX_arm64.cpp ---------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===---------------------------------------------------------------------===//

#include <cassert>
#include <stddef.h>
#include <vector>

#include "lldb/lldb-defines.h"
#include "llvm/Support/Compiler.h"

#include "RegisterInfoPOSIX_arm64.h"

// Based on RegisterContextDarwin_arm64.cpp
#define GPR_OFFSET(idx) ((idx)*8)
#define GPR_OFFSET_NAME(reg)                                                   \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::GPR, reg))

#define FPU_OFFSET(idx) ((idx)*16 + sizeof(RegisterInfoPOSIX_arm64::GPR))
#define FPU_OFFSET_NAME(reg)                                                   \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::FPU, reg) +                \
   sizeof(RegisterInfoPOSIX_arm64::GPR))

#define CAP_OFFSET(idx)                                                        \
  ((idx)*17 + sizeof(RegisterInfoPOSIX_arm64::GPR) +                           \
   sizeof(RegisterInfoPOSIX_arm64::FPU))

#define STATE_OFFSET_NAME(reg)                                                 \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::STATE, reg) +              \
   sizeof(RegisterInfoPOSIX_arm64::GPR) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::FPU) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::CAP))

#define THREAD_OFFSET_NAME(reg)                                                \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::THREAD, reg) +             \
   sizeof(RegisterInfoPOSIX_arm64::GPR) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::FPU) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::CAP) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::STATE))

#define EXC_OFFSET_NAME(reg)                                                   \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::EXC, reg) +                \
   sizeof(RegisterInfoPOSIX_arm64::GPR) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::FPU) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::CAP) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::STATE) +                                    \
   sizeof(RegisterInfoPOSIX_arm64::THREAD))

#define DBG_OFFSET_NAME(reg)                                                   \
  (LLVM_EXTENSION offsetof(RegisterInfoPOSIX_arm64::DBG, reg) +                \
   sizeof(RegisterInfoPOSIX_arm64::GPR) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::FPU) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::CAP) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::STATE) +                                    \
   sizeof(RegisterInfoPOSIX_arm64::THREAD) +                                   \
   sizeof(RegisterInfoPOSIX_arm64::EXC))

#define DEFINE_DBG(reg, i)                                                     \
  #reg, NULL,                                                                  \
      sizeof(((RegisterInfoPOSIX_arm64::DBG *) NULL)->reg[i]),                 \
              DBG_OFFSET_NAME(reg[i]), lldb::eEncodingUint, lldb::eFormatHex,  \
                              {LLDB_INVALID_REGNUM, LLDB_INVALID_REGNUM,       \
                               LLDB_INVALID_REGNUM, LLDB_INVALID_REGNUM,       \
                               dbg_##reg##i },                                 \
                               NULL, NULL, NULL, 0

#define REG_CONTEXT_SIZE                                                       \
  (sizeof(RegisterInfoPOSIX_arm64::GPR) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::FPU) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::CAP) +                                      \
   sizeof(RegisterInfoPOSIX_arm64::STATE) +                                    \
   sizeof(RegisterInfoPOSIX_arm64::THREAD) +                                   \
   sizeof(RegisterInfoPOSIX_arm64::EXC))

// Include RegisterInfos_arm64 to declare our g_register_infos_arm64 structure.
#define DECLARE_REGISTER_INFOS_ARM64_STRUCT
#define DECLARE_CAPABILITY_REGISTER_INFOS
#include "RegisterInfos_arm64.h"
#undef DECLARE_REGISTER_INFOS_ARM64_STRUCT
#undef DECLARE_CAPABILITY_REGISTER_INFOS

static const lldb_private::RegisterInfo *
GetRegisterInfoPtr(const lldb_private::ArchSpec &target_arch) {
  switch (target_arch.GetMachine()) {
  case llvm::Triple::aarch64:
  case llvm::Triple::aarch64_32:
    return g_register_infos_arm64_le;
  default:
    assert(false && "Unhandled target architecture.");
    return nullptr;
  }
}

// Number of register sets provided by this context.
enum {
  k_num_gpr_registers = gpr_w28 - gpr_x0 + 1,
  k_num_fpr_registers = fpu_fpcr - fpu_v0 + 1,
  k_num_cap_registers = cap_ddc - cap_c0 + 1,
  k_num_state_registers = state_rddc_el0 - state_sp_el0 + 1,
  k_num_thread_registers = thread_ctpidr_el0 - thread_tpidr_el0 + 1,
  k_num_register_sets = 5
};

// ARM64 general purpose registers.
static const uint32_t g_gpr_regnums_arm64[] = {
    gpr_x0,  gpr_x1,   gpr_x2,  gpr_x3,
    gpr_x4,  gpr_x5,   gpr_x6,  gpr_x7,
    gpr_x8,  gpr_x9,   gpr_x10, gpr_x11,
    gpr_x12, gpr_x13,  gpr_x14, gpr_x15,
    gpr_x16, gpr_x17,  gpr_x18, gpr_x19,
    gpr_x20, gpr_x21,  gpr_x22, gpr_x23,
    gpr_x24, gpr_x25,  gpr_x26, gpr_x27,
    gpr_x28, gpr_x29,  gpr_lr,  gpr_sp,
    gpr_pc,  gpr_cpsr, gpr_w0,  gpr_w1,
    gpr_w2,  gpr_w3,   gpr_w4,  gpr_w5,
    gpr_w6,  gpr_w7,   gpr_w8,  gpr_w9,
    gpr_w10, gpr_w11,  gpr_w12, gpr_w13,
    gpr_w14, gpr_w15,  gpr_w16, gpr_w17,
    gpr_w18, gpr_w19,  gpr_w20, gpr_w21,
    gpr_w22, gpr_w23,  gpr_w24, gpr_w25,
    gpr_w26, gpr_w27,  gpr_w28, LLDB_INVALID_REGNUM};

static_assert(((sizeof g_gpr_regnums_arm64 / sizeof g_gpr_regnums_arm64[0]) -
               1) == k_num_gpr_registers,
              "g_gpr_regnums_arm64 has wrong number of register infos");

// ARM64 floating point registers.
static const uint32_t g_fpu_regnums_arm64[] = {
    fpu_v0,   fpu_v1,   fpu_v2,
    fpu_v3,   fpu_v4,   fpu_v5,
    fpu_v6,   fpu_v7,   fpu_v8,
    fpu_v9,   fpu_v10,  fpu_v11,
    fpu_v12,  fpu_v13,  fpu_v14,
    fpu_v15,  fpu_v16,  fpu_v17,
    fpu_v18,  fpu_v19,  fpu_v20,
    fpu_v21,  fpu_v22,  fpu_v23,
    fpu_v24,  fpu_v25,  fpu_v26,
    fpu_v27,  fpu_v28,  fpu_v29,
    fpu_v30,  fpu_v31,  fpu_s0,
    fpu_s1,   fpu_s2,   fpu_s3,
    fpu_s4,   fpu_s5,   fpu_s6,
    fpu_s7,   fpu_s8,   fpu_s9,
    fpu_s10,  fpu_s11,  fpu_s12,
    fpu_s13,  fpu_s14,  fpu_s15,
    fpu_s16,  fpu_s17,  fpu_s18,
    fpu_s19,  fpu_s20,  fpu_s21,
    fpu_s22,  fpu_s23,  fpu_s24,
    fpu_s25,  fpu_s26,  fpu_s27,
    fpu_s28,  fpu_s29,  fpu_s30,
    fpu_s31,  fpu_d0,   fpu_d1,
    fpu_d2,   fpu_d3,   fpu_d4,
    fpu_d5,   fpu_d6,   fpu_d7,
    fpu_d8,   fpu_d9,   fpu_d10,
    fpu_d11,  fpu_d12,  fpu_d13,
    fpu_d14,  fpu_d15,  fpu_d16,
    fpu_d17,  fpu_d18,  fpu_d19,
    fpu_d20,  fpu_d21,  fpu_d22,
    fpu_d23,  fpu_d24,  fpu_d25,
    fpu_d26,  fpu_d27,  fpu_d28,
    fpu_d29,  fpu_d30,  fpu_d31,
    fpu_fpsr, fpu_fpcr, LLDB_INVALID_REGNUM};
static_assert(((sizeof g_fpu_regnums_arm64 / sizeof g_fpu_regnums_arm64[0]) -
               1) == k_num_fpr_registers,
              "g_fpu_regnums_arm64 has wrong number of register infos");

// ARM64 capability registers.
static const uint32_t g_cap_regnums_arm64[] = {
    cap_c0,  cap_c1,  cap_c2,  cap_c3,  cap_c4,  cap_c5,  cap_c6,
    cap_c7,  cap_c8,  cap_c9,  cap_c10, cap_c11, cap_c12, cap_c13,
    cap_c14, cap_c15, cap_c16, cap_c17, cap_c18, cap_c19, cap_c20,
    cap_c21, cap_c22, cap_c23, cap_c24, cap_c25, cap_c26, cap_c27,
    cap_c28, cap_c29, cap_clr, cap_csp, cap_pcc, cap_ddc, LLDB_INVALID_REGNUM};
static_assert(((sizeof g_cap_regnums_arm64 / sizeof g_cap_regnums_arm64[0]) -
               1) == k_num_cap_registers,
              "g_cap_regnums_arm64 has wrong number of register infos");

// ARM64 state/backing registers.
static const uint32_t g_state_regnums_arm64[] = {
    state_sp_el0,  state_rsp_el0,  state_csp_el0,      state_rcsp_el0,
    state_ddc_el0, state_rddc_el0, LLDB_INVALID_REGNUM};
static_assert(((sizeof g_state_regnums_arm64 /
                sizeof g_state_regnums_arm64[0]) -
               1) == k_num_state_registers,
              "g_state_regnums_arm64 has wrong number of register infos");

// ARM64 thread pointer registers.
static const uint32_t g_thread_regnums_arm64[] = {
    thread_tpidr_el0, thread_ctpidr_el0, LLDB_INVALID_REGNUM};
static_assert(((sizeof g_thread_regnums_arm64 /
                sizeof g_thread_regnums_arm64[0]) -
               1) == k_num_thread_registers,
              "g_thread_regnums_arm64 has wrong number of register infos");

// clang-format on
// Register sets for ARM64.
static const lldb_private::RegisterSet g_reg_sets_arm64[k_num_register_sets] = {
    {"General Purpose Registers", "gpr", k_num_gpr_registers,
     g_gpr_regnums_arm64},
    {"Floating Point Registers", "fpu", k_num_fpr_registers,
     g_fpu_regnums_arm64},
    {"Capability Registers", "cap", k_num_cap_registers, g_cap_regnums_arm64},
    {"State Registers", "state", k_num_state_registers, g_state_regnums_arm64},
    {"Thread Pointer Registers", "thread", k_num_thread_registers,
     g_thread_regnums_arm64}};

static uint32_t
GetRegisterInfoCount(const lldb_private::ArchSpec &target_arch) {
  switch (target_arch.GetMachine()) {
  case llvm::Triple::aarch64:
  case llvm::Triple::aarch64_32:
    return static_cast<uint32_t>(sizeof(g_register_infos_arm64_le) /
                                 sizeof(g_register_infos_arm64_le[0]));
  default:
    assert(false && "Unhandled target architecture.");
    return 0;
  }
}

RegisterInfoPOSIX_arm64::RegisterInfoPOSIX_arm64(
    const lldb_private::ArchSpec &target_arch)
    : lldb_private::RegisterInfoAndSetInterface(target_arch),
      m_register_info_p(GetRegisterInfoPtr(target_arch)),
      m_register_info_count(GetRegisterInfoCount(target_arch)) {
  SetupFP(target_arch.IsAArch64MorelloDescriptorABI());
  switch (target_arch.GetMachine()) {
  case llvm::Triple::aarch64:
  case llvm::Triple::aarch64_32:
    num_registers = k_num_gpr_registers + k_num_fpr_registers +
                    k_num_cap_registers + k_num_state_registers +
                    k_num_thread_registers;
    num_gpr_registers = k_num_gpr_registers;
    num_fpr_registers = k_num_fpr_registers;
    last_gpr = gpr_w28;
    first_fpr = fpu_v0;
    last_fpr = fpu_fpcr;
    last_cap = cap_ddc;
    last_state = state_rddc_el0;
    last_thread = thread_ctpidr_el0;
    break;
  default:
    assert(false && "Unhandled target architecture.");
    break;
  }
}

uint32_t RegisterInfoPOSIX_arm64::GetRegisterCount() const {
  return num_registers;
}

size_t RegisterInfoPOSIX_arm64::GetGPRSize() const {
  return sizeof(struct RegisterInfoPOSIX_arm64::GPR);
}

size_t RegisterInfoPOSIX_arm64::GetFPRSize() const {
  return sizeof(struct RegisterInfoPOSIX_arm64::FPU);
}

const lldb_private::RegisterInfo *
RegisterInfoPOSIX_arm64::GetRegisterInfo() const {
  return m_register_info_p;
}

size_t RegisterInfoPOSIX_arm64::GetRegisterSetCount() const {
  return k_num_register_sets;
}

size_t RegisterInfoPOSIX_arm64::GetRegisterSetFromRegisterIndex(
    uint32_t reg_index) const {
  if (reg_index <= last_gpr)
    return GPRegSet;
  else if (reg_index <= last_fpr)
    return FPRegSet;
  if (reg_index <= last_cap)
    return CapRegSet;
  if (reg_index <= last_state)
    return StateRegSet;
  if (reg_index <= last_thread)
    return ThreadRegSet;
  return LLDB_INVALID_REGNUM;
}

const lldb_private::RegisterSet *
RegisterInfoPOSIX_arm64::GetRegisterSet(size_t set_index) const {
  if (set_index < k_num_register_sets)
    return &g_reg_sets_arm64[set_index];

  return nullptr;
}
