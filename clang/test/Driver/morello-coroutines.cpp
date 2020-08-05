// RUN: %clang++ -target aarch64-none-elf -march=morello+c64 -mabi=purecap -S %s -fcoroutines-ts -o /dev/null 2>&1 | FileCheck  %s

// CHECK: warning: coroutines not supported in the purecap ABI. Ignoring the -fcoroutines-ts option
