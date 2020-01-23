//===-- LinuxSigInfo.h ------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_LinuxSigInfo_h_
#define liblldb_LinuxSigInfo_h_

// C Includes
// C++ Includes
// Other libraries and framework includes
#include "llvm/ADT/StringRef.h"

// Project includes
#include "lldb/Symbol/CompilerType.h"
#include "lldb/lldb-private.h"

//--------------------------------------------------------------------
/// Synthetize a compiler type for the siginfo structure that is
/// present on Linux.
///
/// @param[in] ast_ctx
///     An AST context to use for defining the structure.
///
/// @param[in] type_name
///     A name of the resulting type.
///
/// @return
///     The siginfo compiler type.
//--------------------------------------------------------------------
lldb_private::CompilerType
GetLinuxSigInfoCompilerType(lldb_private::TypeSystemClang &ast_ctx,
                            llvm::StringRef type_name);

#endif // liblldb_LinuxSigInfo_h_
