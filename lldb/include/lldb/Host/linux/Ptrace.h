//===-- Ptrace.h ------------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// This file defines ptrace functions & structures

#ifndef liblldb_Host_linux_Ptrace_h_
#define liblldb_Host_linux_Ptrace_h_

#include <sys/ptrace.h>

#ifndef __GLIBC__
typedef int __ptrace_request;
#endif

#define DEBUG_PTRACE_MAXBYTES 20

// Support ptrace extensions even when compiled without required kernel support
#ifndef PTRACE_GETREGS
#define PTRACE_GETREGS 12
#endif
#ifndef PTRACE_SETREGS
#define PTRACE_SETREGS 13
#endif
#ifndef PTRACE_GETFPREGS
#define PTRACE_GETFPREGS 14
#endif
#ifndef PTRACE_SETFPREGS
#define PTRACE_SETFPREGS 15
#endif
#ifndef PTRACE_GETREGSET
#define PTRACE_GETREGSET 0x4204
#endif
#ifndef PTRACE_SETREGSET
#define PTRACE_SETREGSET 0x4205
#endif
#ifndef PTRACE_GET_THREAD_AREA
#define PTRACE_GET_THREAD_AREA 25
#endif
#ifndef PTRACE_ARCH_PRCTL
#define PTRACE_ARCH_PRCTL 30
#endif
#ifndef ARCH_GET_FS
#define ARCH_SET_GS 0x1001
#define ARCH_SET_FS 0x1002
#define ARCH_GET_FS 0x1003
#define ARCH_GET_GS 0x1004
#endif

#define LLDB_PTRACE_NT_ARM_TLS 0x401 // ARM TLS register

#if defined(__arm64__) || defined(__aarch64__)

#include <sys/types.h>

// Kernel definitions for capability views.

#ifndef NT_ARM_MORELLO
#define NT_ARM_MORELLO 0x410

#define MORELLO_PT_TAG_MAP_REG_BIT(reg)                                        \
  (offsetof(struct user_morello_state, reg) / sizeof(__uint128_t))
#define MORELLO_PT_TAG_MAP_REG_MASK(reg) _BITUL(MORELLO_PT_TAG_MAP_REG_BIT(reg))

struct user_morello_state {
  /* Capability GPRs and PCC */
  __uint128_t cregs[31];
  __uint128_t pcc;
  /* Executive capability registers */
  __uint128_t csp;
  __uint128_t ddc;
  __uint128_t ctpidr;
  /* Restricted capability registers */
  __uint128_t rcsp;
  __uint128_t rddc;
  __uint128_t rctpidr;
  /* Compartment ID register */
  __uint128_t cid;
  /*
   * Bitmap storing the tags of all the capability registers.
   * The tag for register <reg> is stored at bit index
   * MORELLO_PT_TAG_MAP_REG_BIT(<reg>) in tag_map.
   */
  __u64 tag_map;
  /* Capability control register */
  __u64 cctlr;
};

#endif // NT_ARM_MORELLO

#ifndef PTRACE_PEEKCAP
#define PTRACE_PEEKCAP 12

struct user_cap {
  __uint128_t val;
  __u8 tag; // 0 or 1
  __u8 __reserved[15];
};

#endif // PTRACE_PEEKCAP

#endif // defined(__arm64__) || defined(__aarch64__)

#endif // liblldb_Host_linux_Ptrace_h_
