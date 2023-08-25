// RUN: %clang -c -### %s 2>&1 -target aarch64-none-elf -march=morello -mabi=purecap | FileCheck %s --check-prefix=NOIND
// RUN: %clang -c -### %s 2>&1 -target aarch64-linux-gnu -march=morello -mabi=purecap | FileCheck %s --check-prefix=IND
// RUN: %clang -c -### %s 2>&1 -target aarch64-linux-gnu_purecap -march=morello | FileCheck %s --check-prefix=IND
// RUN: %clang -c -### %s 2>&1 -target aarch64-linux-musl_purecap -march=morello | FileCheck %s --check-prefix=NOIND
// RUN: %clang -c -### %s 2>&1 -target aarch64-unknown-freebsd -march=morello -mabi=purecap | FileCheck %s --check-prefix=NOIND

// IND: -cheri-landing-pad-encoding=indirect
// NOIND-NOT: -cheri-landing-pad-encoding
