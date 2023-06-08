// RUN: %clang %s -target aarch64-none-elf -march=morello+c64 -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=warn
// RUN: %clang %s -target aarch64-linux-gnu -march=morello+c64 -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=warn
// RUN: %clang %s -target aarch64-unknown-freebsd -march=morello+c64 -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=warn

// RUN: %clang %s -target aarch64-none-elf -march=morello -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=nowarn
// RUN: %clang %s -target aarch64-linux-gnu -march=morello -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=nowarn
// RUN: %clang %s -target aarch64-unknown-freebsd -march=morello -mabi=purecap -### 2>&1 | \
// RUN:     FileCheck %s --check-prefix=nowarn

// warn: warning: Using c64 in the arch string is deprecated. The CPU mode should be inferred from the ABI. [-Wdeprecated]
// nowarn-NOT: warning
