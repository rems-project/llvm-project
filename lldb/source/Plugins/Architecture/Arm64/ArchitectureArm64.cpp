//===-- ArchitectureArm64.cpp -----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Plugins/Architecture/Arm64/ArchitectureArm64.h"
#include "Plugins/Process/Utility/ARMDefines.h"
#include "Plugins/Process/Utility/InstructionUtils.h"
#include "lldb/Core/PluginManager.h"
#include "lldb/Target/RegisterContext.h"
#include "lldb/Target/Thread.h"
#include "lldb/Utility/ArchSpec.h"

using namespace lldb_private;
using namespace lldb;

LLDB_PLUGIN_DEFINE(ArchitectureArm64)

void ArchitectureArm64::Initialize() {
  PluginManager::RegisterPlugin(GetPluginNameStatic(),
                                "Arm64-specific algorithms",
                                &ArchitectureArm64::Create);
}

void ArchitectureArm64::Terminate() {
  PluginManager::UnregisterPlugin(&ArchitectureArm64::Create);
}

std::unique_ptr<Architecture> ArchitectureArm64::Create(const ArchSpec &arch) {
  if (arch.GetMachine() != llvm::Triple::aarch64)
    return nullptr;
  return std::unique_ptr<Architecture>(new ArchitectureArm64());
}

llvm::StringRef ArchitectureArm64::GetPluginName() {
  return GetPluginNameStatic();
}

addr_t
ArchitectureArm64::GetCallableLoadAddress(addr_t code_addr,
                                          AddressClass addr_class) const {
  switch (addr_class) {
  case AddressClass::eData:
  case AddressClass::eDebug:
    return LLDB_INVALID_ADDRESS;
  case AddressClass::eCodeAlternateISA:
    // When we're in C64 mode, we need to set the discriminating bit.
    return code_addr | addr_t(0x1);
  default:
    break;
  }

  return code_addr;
}

addr_t ArchitectureArm64::GetOpcodeLoadAddress(addr_t opcode_addr,
                                               AddressClass addr_class) const {
  switch (addr_class) {
  case AddressClass::eData:
  case AddressClass::eDebug:
    return LLDB_INVALID_ADDRESS;
  default:
    break;
  }

  // Make sure we clear the discriminating bit for C64 addresses. This has no
  // effect for A64 addresses. Ideally we should only be doing it for
  // AddressClass::eCodeAlternateISA, but we're not very consistent about
  // passing the correct value of addr_class.
  return opcode_addr & ~addr_t(0x1);
}
