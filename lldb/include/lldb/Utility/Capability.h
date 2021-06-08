//===-- Capability.h --------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_Capability_h_
#define liblldb_Capability_h_

// C Includes
// C++ Includes
#include <cstdint>

// Other libraries and framework includes
#include "llvm/ADT/APInt.h"
#include "llvm/Support/FormatProviders.h"

// Project includes
#include "lldb/Utility/Status.h"
#include "lldb/Utility/Stream.h"
#include "lldb/lldb-private.h"

namespace lldb_private {

//----------------------------------------------------------------------
/// @class Capability Capability.h "lldb/Utility/Capability.h"
/// @brief A capability class.
///
/// Capability is a non-forgeable permission to perform some action.
/// This class provides functionality to represent and work with
/// capabilities for target architectures that support them.
//----------------------------------------------------------------------
class Capability {
public:
  //------------------------------------------------------------------
  /// Obtain a base (untagged) byte size of a capability type.
  ///
  /// @param[in] type
  ///     The type of the capability.
  ///
  /// @return
  ///     The base byte size of \a type.
  //------------------------------------------------------------------
  static uint32_t GetBaseByteSize(lldb::CapabilityType type);

  //------------------------------------------------------------------
  /// Default constructor.
  ///
  /// Initialize as an invalid capability with zero value.
  //------------------------------------------------------------------
  Capability() : m_type(lldb::eCapabilityInvalid), m_value() {}

  //------------------------------------------------------------------
  /// Construct with a type and value.
  ///
  /// Initialize the capability with the supplied \a type and
  /// \a value.
  ///
  /// @param[in] type
  ///     The type of the capability.
  ///
  /// @param[in] value
  ///     The value of the capability.
  //------------------------------------------------------------------
  Capability(lldb::CapabilityType type, const llvm::APInt &value);

  //------------------------------------------------------------------
  /// Obtain the complete capability value.
  ///
  /// @return
  ///     The value of the capability.
  //------------------------------------------------------------------
  const llvm::APInt &GetValue() const { return m_value; }

  //------------------------------------------------------------------
  /// Obtain the address from the capability.
  ///
  /// @param[in] fail_value
  ///     A value returned in case of a failure.
  ///
  /// @param[out] success_ptr
  ///     If not nullptr then set to \b true on success and to
  ///     \b false otherwise.
  ///
  /// @return
  ///     The address recorded in the capability, or \a fail_value if
  ///     the capability does have an address.
  //------------------------------------------------------------------
  lldb::addr_t GetAddress(lldb::addr_t fail_value = LLDB_INVALID_ADDRESS,
                          bool *success_ptr = nullptr) const;

  //------------------------------------------------------------------
  /// Obtain a register value from the capability adjusted by a given
  /// offset.
  ///
  /// @param[in] reg_info
  ///     The information describing the register.
  ///
  /// @param[in] offset
  ///     The offset to add to the capability value.
  ///
  /// @param[out] reg_value
  ///     The resulting register value.
  ///
  /// @param[out] error
  ///     An error descriptor if the method failed to set the register
  ///     value.
  ///
  /// @return
  ///     \b true on success, \b false otherwise.
  //------------------------------------------------------------------
  bool GetCFARegisterValue(const RegisterInfo &reg_info, int64_t offset,
                           RegisterValue &reg_value, Status &error) const;

  //------------------------------------------------------------------
  /// Obtain a capability that has the address adjusted by a given
  /// offset.
  ///
  /// @param[in] offset
  ///     The offset to add.
  ///
  /// @return
  ///     The adjusted capability.
  //------------------------------------------------------------------
  Capability operator+(int64_t offset) const;

  //------------------------------------------------------------------
  /// Dump a description of this capability to a Stream.
  ///
  /// Dump a description of the capability to the supplied stream
  /// \a s.
  ///
  /// @param[in] s
  ///     The stream to which to dump the capability description.
  //------------------------------------------------------------------
  void Dump(Stream &s) const;

  //------------------------------------------------------------------
  /// Clear the object's state.
  //------------------------------------------------------------------
  void Clear() {
    m_type = lldb::eCapabilityInvalid;
    m_value = llvm::APInt();
  }

  //------------------------------------------------------------------
  /// Equal to operator.
  //------------------------------------------------------------------
  bool operator==(const Capability &other) const;

protected:
  lldb::CapabilityType m_type; ///< Capability type.
  llvm::APInt m_value;         ///< Capability value.
};

} // namespace lldb_private

namespace llvm {
template <> struct format_provider<lldb_private::Capability> {
  static void format(const lldb_private::Capability &capability,
                     raw_ostream &Stream, StringRef Style);
};
} // namespace llvm

#endif // liblldb_Capability_h_
