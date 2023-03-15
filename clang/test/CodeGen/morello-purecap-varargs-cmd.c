// RUN: %clang_cc1 -triple arm64-linux-gnu -target-feature +morello \
// RUN:    -target-feature +c64 -target-abi purecap -morello-vararg=new \
// RUN:    -emit-llvm -o - %s | FileCheck %s

// RUN: %clang_cc1 -triple arm64-linux-gnu -target-feature +morello \
// RUN:    -target-feature +c64 -target-abi purecap \
// RUN:    -emit-llvm -o - %s | FileCheck %s

// CHECK-NOT: %struct.__va_list

#include <stdarg.h>

int call(int count, ...) {
  va_list args;
  va_start(args, count);
  int ret = va_arg(args, int);
  va_end(args);
  return ret;
}
