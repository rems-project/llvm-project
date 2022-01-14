// RUN: %clang -no-canonical-prefixes %s -### -o %t.o 2>&1 \
// RUN:     --target=aarch64-unknown-linux-gnu_purecap \
// RUN:     --gcc-toolchain="" \
// RUN:     --sysroot=%S/Inputs/basic_linux_tree \
// RUN:   | FileCheck --check-prefix=CHECK-AARCH64 %s
// CHECK-AARCH64: "-target-abi" "purecap"
// CHECK-AARCH64: "{{.*}}ld{{(.exe)?}}" "--sysroot=[[SYSROOT:[^"]+]]"
// CHECK-AARCH64-NOT: "--be8"
// CHECK-AARCH64: "-EL"
// CHECK-AARCH64: "-m" "aarch64linux"

// RUN: %clang %s -### -o %t.o 2>&1 \
// RUN:     --target=aarch64-unknown-linux-musl_purecap \
// RUN:   | FileCheck --check-prefix=CHECK-MUSL-AARCH64 %s
// CHECK-MUSL-AARCH64: "-target-abi" "purecap"
// CHECK-MUSL-AARCH64:    "-dynamic-linker" "/lib/ld-musl-aarch64_purecap.so.1"

// RUN: %clang -no-canonical-prefixes %s -### -o %t.o 2>&1 \
// RUN:     --target=aarch64-linux-gnu_purecap -rtlib=platform \
// RUN:     --gcc-toolchain="" \
// RUN:     --sysroot=%S/Inputs/debian_multiarch_tree \
// RUN:   | FileCheck --check-prefix=CHECK-DEBIAN-AARCH64 %s
// CHECK-DEBIAN-AARCH64: "-target-abi" "purecap"
// CHECK-DEBIAN-AARCH64: "{{.*}}ld{{(.exe)?}}" "--sysroot=[[SYSROOT:[^"]+]]"
// CHECK-DEBIAN-AARCH64: "-dynamic-linker" "/lib/ld-linux-aarch64_purecap.so.1"
// CHECK-DEBIAN-AARCH64: "{{.*}}/usr/lib/gcc/aarch64-linux-gnu_purecap/4.5{{/|\\\\}}crtbegin.o"
// CHECK-DEBIAN-AARCH64: "-L[[SYSROOT]]/usr/lib/gcc/aarch64-linux-gnu_purecap/4.5"
// CHECK-DEBIAN-AARCH64: "-L[[SYSROOT]]/lib/aarch64-linux-gnu_purecap"
// CHECK-DEBIAN-AARCH64: "-L[[SYSROOT]]/usr/lib/aarch64-linux-gnu_purecap"
// CHECK-DEBIAN-AARCH64: "-L[[SYSROOT]]/lib"
// CHECK-DEBIAN-AARCH64: "-L[[SYSROOT]]/usr/lib"
