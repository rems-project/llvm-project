// RUN: %clang -### -target aarch64-none-elf %s 2>&1 | FileCheck -check-prefix=VARIANT-A64 %s

// RUN: %clang -### -target aarch64-none-elf -march=morello %s 2>&1 | FileCheck -check-prefix=VARIANT-A64C %s
// RUN: %clang -### -target aarch64-none-elf -march=morello -mabi=purecap %s 2>&1 | FileCheck -check-prefix=VARIANT-A64C-PURECAP %s

// RUN: %clang -### -target aarch64-none-elf -march=morello+c64 -mabi=purecap %s 2>&1 | FileCheck -check-prefix=VARIANT-C64-PURECAP %s
// RUN: %clang -### -target aarch64-none-elf -march=morello+c64 %s 2>&1 | FileCheck -check-prefix=VARIANT-C64 %s
// RUN: %clang -### -target aarch64-none-elf -march=morello+c64 -mabi=aapcs %s 2>&1 | FileCheck -check-prefix=VARIANT-C64 %s

// RUN: %clang -### -target aarch64-none-elf -march=morello %s 2>&1 | FileCheck -check-prefix=VARIANT-MORELLO %s
// RUN: %clang -### -target aarch64-none-elf -march=morello+c64 -mabi=purecap  %s 2>&1 | FileCheck -check-prefix=VARIANT-C64-MORELLO %s

// VARIANT-A64: "{{.*}}/aarch64-none-elf/lib/{{.*}}"

// VARIANT-A64C: "{{.*}}/aarch64-none-elf+morello+a64c/lib/{{.*}}"
// VARIANT-A64C-PURECAP: "{{.*}}/aarch64-none-elf+morello+a64c+purecap/lib/{{.*}}"

// VARIANT-C64: "{{.*}}/aarch64-none-elf+morello+c64/lib/{{.*}}"
// VARIANT-C64-PURECAP: "{{.*}}/aarch64-none-elf+morello+c64+purecap/lib/{{.*}}"

// VARIANT-MORELLO: "{{.*}}/aarch64-none-elf+morello+a64c/lib/{{.*}}"
// VARIANT-C64-MORELLO: "{{.*}}/aarch64-none-elf+morello+c64+purecap/lib/{{.*}}"
