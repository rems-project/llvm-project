// RUN: %clang -### -target aarch64-none-elf -march=morello+c64 -mabi=purecap %s 2>&1 | FileCheck -check-prefix=C64-TARGETABI %s
// RUN: %clang -### -target aarch64-none-elf -march=morello -mabi=purecap %s 2>&1 | FileCheck -check-prefix=C64-TARGETABI %s
// RUN: %clang -### -target aarch64-unknown-freebsd12.0  -mabi=purecap %s 2>&1 | FileCheck -check-prefix=C64-TARGETABI %s
// C64-TARGETABI: "-target-abi" "purecap"
