//===-- ArchitectureArm64.h -------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_PLUGIN_ARCHITECTURE_ARM64_H
#define LLDB_PLUGIN_ARCHITECTURE_ARM64_H

#include "lldb/Core/Architecture.h"

namespace lldb_private {

class ArchitectureArm64 : public Architecture {
public:
  static llvm::StringRef GetPluginNameStatic() { return "arm64"; }
  static void Initialize();
  static void Terminate();

  llvm::StringRef GetPluginName() override;

  void OverrideStopInfo(Thread &thread) const override {}

  lldb::addr_t GetCallableLoadAddress(lldb::addr_t load_addr,
                                      AddressClass addr_class) const override;

  lldb::addr_t GetOpcodeLoadAddress(lldb::addr_t load_addr,
                                    AddressClass addr_class) const override;

private:
  static std::unique_ptr<Architecture> Create(const ArchSpec &arch);
  ArchitectureArm64() = default;
};

} // namespace lldb_private

#endif // LLDB_PLUGIN_ARCHITECTURE_ARM64_H
