// RUN: %clangxx -### -target aarch64-none-elf %s 2>&1 | FileCheck -check-prefix=CHECK-LIBCXX %s
// CHECK-LIBCXX: "-lc++" "-lc++abi" "-lunwind"
