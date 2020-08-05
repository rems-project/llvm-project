//===-- Capability.cpp ------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "lldb/Core/Capability.h"

// C Includes
// C++ Includes
#include <string>

// Other libraries and framework includes
#include "llvm/ADT/ArrayRef.h"
// Project includes
#include "lldb/Utility/Log.h"
#include "lldb/Utility/Logging.h"
#include "lldb/Utility/RegisterValue.h"

using namespace lldb;
using namespace lldb_private;

namespace AArch64_128 {
struct PermNamePair {
  uint64_t perm;
  const char *name;
};

// Return whether the capability is valid, i.e. whether the tag bit is set.
bool IsCapabilityValid(const llvm::APInt &value) {
  if (value.getBitWidth() == 128)
    // Untagged capability
    return false;

  assert(value.getBitWidth() == 129 && "Invalid size for capability");
  return value[128];
}

// Return virtual address recorded in the capability.
uint64_t GetAddress(const llvm::APInt &value) {
  return value.extractBits(64, 0).getZExtValue();
}

llvm::APInt Add(const llvm::APInt &value, int64_t offset) {
  // Simplified version that assumes adding the offset does not invalidate the
  // capability.
  return value + offset;
}

bool GetCFARegisterValue(const llvm::APInt &value, bool has_tag,
                         const RegisterInfo &reg_info, int64_t offset,
                         RegisterValue &reg_value, Status &error) {
  // Be strict and allow to obtain CFA only from a properly tagged capability.
  if (!has_tag) {
    error.SetErrorString(
        "a CFA register value cannot be obtained from an untagged capability");
    return false;
  }

  // Calculate a capability value adjusted by the offset and set the resulting
  // register value. Only two register types are sensible for a capability CFA:
  // * 64-bit Xn/SP -- stores the lowest 64-bit part of the CFA,
  // * Tagged 128-bit Cn/CSP -- holds the complete capability CFA value.
  llvm::APInt adjusted_value = Add(value, offset);
  if (reg_info.encoding == eEncodingUint && reg_info.byte_size == 8)
    reg_value.SetUInt64((adjusted_value & 0xffffffffffffffff).getZExtValue());
  else if (reg_info.encoding == eEncodingCapability && reg_info.byte_size == 17)
    reg_value.SetCapability128(adjusted_value);
  else {
    error.SetErrorStringWithFormat(
        "register value for %s cannot be constructed from a capability CFA",
        reg_info.name);
    return false;
  }
  return true;
}

template <typename CapabilityEncoding>
void Dump(Stream &s, const llvm::APInt &value, bool has_tag) {
  // Get a string representing the sealed flag and permissions.
  std::string bits;
  bool is_sealed = CapabilityEncoding::IsCapabilitySealed(value);
  if (is_sealed)
    bits += "Sealed";

  llvm::ArrayRef<PermNamePair> perm_names =
      CapabilityEncoding::GetPermissionNames(value);
  uint64_t perms = CapabilityEncoding::DecodePermissions(value);

  for (const PermNamePair &p : perm_names)
    if (perms & p.perm) {
      if (!bits.empty())
        bits += " ";
      bits += p.name;
    }

  // Output the capability.
  s.PutCString("{");
  if (has_tag)
    s.Printf("tag = %d, ", IsCapabilityValid(value));
  s.Printf("address = 0x%016" PRIx64 ", ", GetAddress(value));
  s.Printf("attributes = {[%s]", bits.c_str());

  if (is_sealed) {
    uint64_t otype = CapabilityEncoding::DecodeCapabilityOType(value);
    s.Printf(", otype = 0x%" PRIx64, otype);
  }

  llvm::APInt base, top;
  CapabilityEncoding::DecodeCapabilityAddressRange(value, base, top);
  llvm::SmallString<32> base_str;
  llvm::SmallString<32> top_str;
  base.toString(base_str, 16, /*Signed=*/false, /*formatAsCLiteral=*/true);
  top.toString(top_str, 16, /*Signed=*/false, /*formatAsCLiteral=*/true);
  s.Printf(", range = [%s-%s)}}", llvm::StringRef(base_str).lower().c_str(),
           llvm::StringRef(top_str).lower().c_str());
}

} // namespace AArch64_128

uint32_t Capability::GetBaseByteSize(lldb::CapabilityType type) {
  switch (type) {
  case eCapabilityInvalid:
    break;
  case eCapabilityMorello_128:
  case eCapabilityMorello_128_untagged:
    return 16;
  }
  return 0;
}

Capability::Capability(CapabilityType type, const llvm::APInt &value)
    : m_type(type), m_value(value) {
  // Check that the value is sensible.
  switch (m_type) {
  case eCapabilityInvalid:
    break;
  case eCapabilityMorello_128:
    assert(m_value.getBitWidth() == 129);
    break;
  case eCapabilityMorello_128_untagged:
    assert(m_value.getBitWidth() == 128);
    break;
  }
}

addr_t Capability::GetAddress(addr_t fail_value, bool *success_ptr) const {
  switch (m_type) {
  case eCapabilityInvalid:
    break;
  case eCapabilityMorello_128:
  case eCapabilityMorello_128_untagged:
    if (success_ptr != nullptr)
      *success_ptr = true;
    return AArch64_128::GetAddress(m_value);
  }
  if (success_ptr != nullptr)
    *success_ptr = false;
  return fail_value;
}

bool Capability::GetCFARegisterValue(const RegisterInfo &reg_info,
                                     int64_t offset, RegisterValue &reg_value,
                                     Status &error) const {
  switch (m_type) {
  case eCapabilityInvalid:
    break;
  case eCapabilityMorello_128:
  case eCapabilityMorello_128_untagged:
    return AArch64_128::GetCFARegisterValue(m_value, /*has_tag=*/m_type ==
                                                         eCapabilityMorello_128,
                                            reg_info, offset, reg_value, error);
  }
  error.SetErrorString("invalid CFA capability");
  return false;
}

Capability Capability::operator+(int64_t offset) const {
  Capability result = *this;
  switch (m_type) {
  case eCapabilityInvalid:
    // Input is invalid, return the same invalid capability on the output.
    break;
  case eCapabilityMorello_128:
  case eCapabilityMorello_128_untagged:
    result.m_value = AArch64_128::Add(m_value, offset);
    break;
  }
  return result;
}

void Capability::Dump(Stream &s) const {
  switch (m_type) {
  case eCapabilityInvalid:
    s.PutCString("invalid capability");
    break;
  case eCapabilityMorello_128:
  case eCapabilityMorello_128_untagged: {
    // TODO: Interpret capability fields.
    llvm::SmallString<33> str_value; // 32 hex digits + room for tag, if needed
    m_value.toStringUnsigned(str_value, 16);
    s << "0x" << str_value;
    break;
  }
  }
}

bool Capability::operator==(const Capability &other) const {
  return m_type == other.m_type && m_value == other.m_value;
}

void llvm::format_provider<Capability>::format(const Capability &capability,
                                               raw_ostream &Stream,
                                               StringRef Style) {
  SmallString<64> str_value;
  capability.GetValue().toString(str_value, 16, /*Signed=*/false,
                                 /*formatAsCLiteral=*/true);
  Stream << "capability(" << StringRef(str_value).lower() << ")";
}
