//===- Cheri.cpp - Utility functions for handling capabilities-------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Cheri.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ManagedStatic.h"

using namespace llvm;

#include "DebugOptions.h"

namespace {
struct CreateNoCapLibFuncs {
   static void *call() {
    return new llvm::cl::opt<bool>(
              "cheri-no-cap-libfunc", llvm::cl::init(false), llvm::cl::Hidden);
  }
};

static llvm::ManagedStatic<llvm::cl::opt<bool>, CreateNoCapLibFuncs>
    NoCapLibFuncs;

struct CreateNoPureCapLibFuncs {
   static void *call() {
    return new llvm::cl::opt<bool>(
               "cheri-no-pure-cap-libfunc", llvm::cl::init(true),
               llvm::cl::Hidden);
  }
};

static llvm::ManagedStatic<llvm::cl::opt<bool>, CreateNoPureCapLibFuncs>
    NoPureCapLibFuncs;
} // namespace

void llvm::initCheriLibFuncOptions() {
  *NoCapLibFuncs;
  *NoPureCapLibFuncs;
}

namespace llvm {

bool useCHERICapLibFunc(bool PureCapABI) {
  if (*NoCapLibFuncs)
    return false;
  if (PureCapABI && *NoPureCapLibFuncs)
    return false;
  return true;
}

} // namespace llvm
