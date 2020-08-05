//===-- LinuxSigInfo.cpp ----------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "LinuxSigInfo.h"

// C Includes
// C++ Includes
// Other libraries and framework includes
// Project includes
#include "lldb/Symbol/ClangASTContext.h"

using namespace lldb;
using namespace lldb_private;

CompilerType GetLinuxSigInfoCompilerType(ClangASTContext &ast_ctx,
                                         llvm::StringRef type_name) {
  // Basic types and typedefs.
  CompilerType void_type = ast_ctx.GetBasicType(eBasicTypeVoid);
  CompilerType short_type = ast_ctx.GetBasicType(eBasicTypeShort);
  CompilerType int_type = ast_ctx.GetBasicType(eBasicTypeInt);
  CompilerType long_type = ast_ctx.GetBasicType(eBasicTypeLong);
  CompilerType uint_type = ast_ctx.GetBasicType(eBasicTypeUnsignedInt);

  CompilerType s32_type =
      ast_ctx.GetBuiltinTypeForEncodingAndBitSize(eEncodingSint, 32);
  CompilerType u32_type =
      ast_ctx.GetBuiltinTypeForEncodingAndBitSize(eEncodingUint, 32);

  CompilerType void_ptr_type = void_type.GetPointerType();

  CompilerType pid_t_type =
      ast_ctx.CreateTypedefType(s32_type, "__pid_t", CompilerDeclContext());
  CompilerType uid_t_type =
      ast_ctx.CreateTypedefType(u32_type, "__uid_t", CompilerDeclContext());
  CompilerType clock_t_type =
      ast_ctx.CreateTypedefType(long_type, "__clock_t", CompilerDeclContext());

  // Anonymous kill struct.
  CompilerType kill_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(kill_type);
  ClangASTContext::AddFieldToRecordType(kill_type, "pid", pid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(kill_type, "uid", uid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(kill_type);

  // Sigval union and sigval_t typedef.
  CompilerType sigval_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, "sigval", clang::TTK_Union, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigval_type);
  ClangASTContext::AddFieldToRecordType(sigval_type, "sival_int", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigval_type, "sival_ptr", void_ptr_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigval_type);

  CompilerType sigval_t_type =
      ast_ctx.CreateTypedefType(sigval_type, "sigval_t", CompilerDeclContext());

  // Anonymous timer struct.
  CompilerType timer_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(timer_type);
  ClangASTContext::AddFieldToRecordType(timer_type, "tid", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(timer_type, "overrun", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(timer_type, "sigval", sigval_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(timer_type);

  // Anonymous rt struct.
  CompilerType rt_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(rt_type);
  ClangASTContext::AddFieldToRecordType(rt_type, "pid", pid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(rt_type, "uid", uid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(rt_type, "sigval", sigval_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(rt_type);

  // Anonymous sigchld struct.
  CompilerType sigchld_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigchld_type);
  ClangASTContext::AddFieldToRecordType(sigchld_type, "pid", pid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigchld_type, "uid", uid_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigchld_type, "status", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigchld_type, "utime", clock_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigchld_type, "stime", clock_t_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigchld_type);

  // Anonymous addr_bnd struct.
  CompilerType addr_bnd_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(addr_bnd_type);
  ClangASTContext::AddFieldToRecordType(addr_bnd_type, "lower", void_ptr_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(addr_bnd_type, "upper", void_ptr_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(addr_bnd_type);

  // Anonymous sigfault_extra union.
  CompilerType sigfault_extra_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Union, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigfault_extra_type);
  ClangASTContext::AddFieldToRecordType(sigfault_extra_type, "addr_bnd",
                                        addr_bnd_type, eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigfault_extra_type, "pkey", u32_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigfault_extra_type);

  // Anonymous sigfault struct.
  CompilerType sigfault_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigfault_type);
  ClangASTContext::AddFieldToRecordType(sigfault_type, "addr", void_ptr_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigfault_type, "addr_lsb", short_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigfault_type, "extra",
                                        sigfault_extra_type, eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigfault_type);

  // Anonymous sigpoll struct.
  CompilerType sigpoll_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigpoll_type);
  ClangASTContext::AddFieldToRecordType(sigpoll_type, "band", long_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigpoll_type, "fd", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigpoll_type);

  // Anonymous sigsys struct.
  CompilerType sigsys_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sigsys_type);
  ClangASTContext::AddFieldToRecordType(sigsys_type, "call_addr",
                                        void_ptr_type, eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigsys_type, "syscall", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sigsys_type, "arch", uint_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sigsys_type);

  // Anonymous sifields union.
  CompilerType sifields_type = ast_ctx.CreateRecordType(
      nullptr, eAccessPublic, llvm::StringRef(), clang::TTK_Union, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(sifields_type);
  ClangASTContext::AddFieldToRecordType(sifields_type, "kill", kill_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "timer", timer_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "rt", rt_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "sigchld", sigchld_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "sigfault",
                                        sigfault_type, eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "sigpoll", sigpoll_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(sifields_type, "sigsys", sigsys_type,
                                        eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(sifields_type);

  // Siginfo struct.
  CompilerType siginfo_type =
      ast_ctx.CreateRecordType(nullptr, eAccessPublic, type_name.str().c_str(),
                               clang::TTK_Struct, eLanguageTypeC);
  ClangASTContext::StartTagDeclarationDefinition(siginfo_type);
  ClangASTContext::AddFieldToRecordType(siginfo_type, "si_signo", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(siginfo_type, "si_errno", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(siginfo_type, "si_code", int_type,
                                        eAccessPublic, 0);
  ClangASTContext::AddFieldToRecordType(siginfo_type, "si_fields",
                                        sifields_type, eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(siginfo_type);

  return siginfo_type;
}
