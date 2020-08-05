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

#ifndef NT_ARM_CAPS
#define NT_ARM_CAPS 0x406

#define USER_C0_TAG 0
#define USER_C1_TAG 1
#define USER_C2_TAG 2
#define USER_C3_TAG 3
#define USER_C4_TAG 4
#define USER_C5_TAG 5
#define USER_C6_TAG 6
#define USER_C7_TAG 7
#define USER_C8_TAG 8
#define USER_C9_TAG 9
#define USER_C10_TAG 10
#define USER_C11_TAG 11
#define USER_C12_TAG 12
#define USER_C13_TAG 13
#define USER_C14_TAG 14
#define USER_C15_TAG 15
#define USER_C16_TAG 16
#define USER_C17_TAG 17
#define USER_C18_TAG 18
#define USER_C19_TAG 19
#define USER_C20_TAG 20
#define USER_C21_TAG 21
#define USER_C22_TAG 22
#define USER_C23_TAG 23
#define USER_C24_TAG 24
#define USER_C25_TAG 25
#define USER_C26_TAG 26
#define USER_C27_TAG 27
#define USER_C28_TAG 28
#define USER_C29_TAG 29
#define USER_C30_TAG 30
#define USER_CSP_EL0_TAG 31
#define USER_RCSP_EL0_TAG 32
#define USER_PCC_TAG 33
#define USER_DDC_EL0_TAG 34
#define USER_RDDC_EL0_TAG 35
#define USER_CTPIDR_EL0_TAG 36
#define USER_RCTPIDR_EL0_TAG 37

struct user_cap_regs {
  __uint128_t c0;          // tag_map bit 0
  __uint128_t c1;          // tag_map bit 1
  __uint128_t c2;          // tag_map bit 2
  __uint128_t c3;          // tag_map bit 3
  __uint128_t c4;          // tag_map bit 4
  __uint128_t c5;          // tag_map bit 5
  __uint128_t c6;          // tag_map bit 6
  __uint128_t c7;          // tag_map bit 7
  __uint128_t c8;          // tag_map bit 8
  __uint128_t c9;          // tag_map bit 9
  __uint128_t c10;         // tag_map bit 10
  __uint128_t c11;         // tag_map bit 11
  __uint128_t c12;         // tag_map bit 12
  __uint128_t c13;         // tag_map bit 13
  __uint128_t c14;         // tag_map bit 14
  __uint128_t c15;         // tag_map bit 15
  __uint128_t c16;         // tag_map bit 16
  __uint128_t c17;         // tag_map bit 17
  __uint128_t c18;         // tag_map bit 18
  __uint128_t c19;         // tag_map bit 19
  __uint128_t c20;         // tag_map bit 20
  __uint128_t c21;         // tag_map bit 21
  __uint128_t c22;         // tag_map bit 22
  __uint128_t c23;         // tag_map bit 23
  __uint128_t c24;         // tag_map bit 24
  __uint128_t c25;         // tag_map bit 25
  __uint128_t c26;         // tag_map bit 26
  __uint128_t c27;         // tag_map bit 27
  __uint128_t c28;         // tag_map bit 28
  __uint128_t c29;         // tag_map bit 29
  __uint128_t c30;         // tag_map bit 30
  __uint128_t csp_el0;     // tag_map bit 31
  __uint128_t rcsp_el0;    // tag_map bit 32
  __uint128_t pcc;         // tag_map bit 33
  __uint128_t ddc_el0;     // tag_map bit 34
  __uint128_t rddc_el0;    // tag_map bit 35
  __uint128_t ctpidr_el0;  // tag_map bit 36
  __uint128_t rctpidr_el0; // tag_map bit 37
  __u64 tag_map;           // tag bits 0..37
  __u64 __reserved;
};

#endif // NT_ARM_CAPS

#ifndef PTRACE_PEEKCAPDATA
#define PTRACE_PEEKCAPDATA 12

struct user_cap {
  __uint128_t val;
  __u8 tag; // 0 or 1
  __u8 __reserved[7];
};

#endif // PTRACE_PEEKCAPDATA

#endif // defined(__arm64__) || defined(__aarch64__)

#endif // liblldb_Host_linux_Ptrace_h_
