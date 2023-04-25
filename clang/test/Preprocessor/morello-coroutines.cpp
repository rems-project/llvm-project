// RUN: %clang++ -target aarch64-none-elf -march=morello+c64 -mabi=purecap -E -dM -xc++ /dev/null -fcoroutines-ts -std=c++20 \
// RUN: | FileCheck %s

// CHECK-NOT: __cpp_coroutines
// CHECK-NOT: __cpp_impl_coroutine
