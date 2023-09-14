// RUN: not %clang -c -emit-llvm %s -o - 2>&1 -target aarch64-none-elf -mabi=purecap-benchmark | FileCheck %s
//
// CHECK: ABI 'purecap-benchmark' is not supported without feature 'morello'
