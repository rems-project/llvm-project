//===- ExpandCapIntrinsics.cpp --------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

namespace llvm {
class PassRegistry;

// Define a weak function that creates a CHERIExpandCapIntrinsics pass.
// This is required in order to build without the Mips backend.
void __attribute__((weak)) initializeCHERIExpandCapIntrinsicsPass(PassRegistry&) {}
};
