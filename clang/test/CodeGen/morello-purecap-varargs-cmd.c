// RUN: %clang_cc1 -triple arm64-linux-gnu -target-feature +morello \
// RUN:    -target-feature +c64 -target-abi purecap -morello-vararg=new \
// RUN:    -emit-llvm -o - %s | FileCheck  %s --check-prefix=NEW

// RUN: %clang_cc1 -triple arm64-linux-gnu -target-feature +morello \
// RUN:    -target-feature +c64 -target-abi purecap -morello-vararg=legacy \
// RUN:    -emit-llvm -o - %s | FileCheck  %s --check-prefix=LEGACY

// RUN: %clang_cc1 -triple arm64-linux-gnu -target-feature +morello \
// RUN:    -target-feature +c64 -target-abi purecap \
// RUN:    -emit-llvm -o - %s | FileCheck  %s --check-prefix=NEW

// NEW-NOT: %struct.__va_list
// LEGACY: %struct.__va_list = type { i8 addrspace(200)*, i8 addrspace(200)*, i8 addrspace(200)*, i32, i32 }

#include <stdarg.h>

int call(int count, ...) {
  va_list args;
  va_start(args, count);
  int ret = va_arg(args, int);
  va_end(args);
  return ret;
}
