// RUN: %clang++ -target aarch64-none-elf -march=morello+c64 -mabi=purecap -E -dM -xc /dev/null -fcoroutines-ts \
// RUN: | FileCheck %s

// RUN: %clang++ -target aarch64-none-elf -march=morello -E -dM -xc /dev/null -fcoroutines-ts \
// RUN: | FileCheck %s

// CHECK-NOT: __cpp_coroutines
