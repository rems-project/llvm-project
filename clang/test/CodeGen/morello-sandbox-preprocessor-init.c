// RUN: %clang_cc1 -E -dM -ffreestanding -triple=aarch64-none-elf -target-feature +morello %s | FileCheck -check-prefix MORELLO %s

// MORELLO:#define __INTPTR_TYPE__ long int
// MORELLO:#define __INTPTR_WIDTH__ 64

// RUN: %clang_cc1 -E -dM -ffreestanding -triple=aarch64-none-elf -target-feature +c64 -target-abi purecap %s -mllvm -cheri-cap-table-abi=pcrel | FileCheck -check-prefix SANDBOX %s

// SANDBOX:#define __INTPTR_TYPE__ __intcap
// SANDBOX:#define __INTPTR_WIDTH__ 128

