// RUN: %clang -O0 -target aarch64-none-linux-gnu -march=morello+c64 -mabi=purecap -S -emit-llvm -o - %s | FileCheck %s
// RUN: %clang -O0 -target aarch64-none-linux-gnu -march=morello+c64 -mabi=purecap -S -o - %s

// CHECK-LABEL: testStackSaveRestore
void testStackSaveRestore(unsigned long n) {
  int tab[n];
// CHECK:  %[[Slot:.*]] = alloca i8 addrspace(200)*, align 16
// CHECK:  %[[SP:.*]] = call i8 addrspace(200)* @llvm.stacksave.p200i8()
// CHECK:  store i8 addrspace(200)* %[[SP]], i8 addrspace(200)* addrspace(200)* %[[Slot]], align 16
// CHECK:  %[[SPs:.*]] = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %[[Slot]], align 16
// CHECK:  call void @llvm.stackrestore.p200i8(i8 addrspace(200)* %[[SPs]])
}
