//===- Cheri.h - Utility functions for handling capabilities------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements various utilies for handling capabilities.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_CHERI_H
#define LLVM_SUPPORT_CHERI_H

#include "llvm/Support/MathExtras.h"

namespace llvm {

uint64_t concentrateReqdAlignment(uint64_t length);

bool useCHERICapLibFunc(bool PureCapABI);

};
#endif
