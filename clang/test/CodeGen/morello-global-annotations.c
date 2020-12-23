// RUN: %clang_cc1 -triple aarch64-none--elf  -emit-llvm -target-feature +morello -target-feature +c64 -target-abi purecap %s -o - | FileCheck %s

__attribute((annotate("sfoo_0"))) __attribute((annotate("sfoo_1"))) char sfoo;

// CHECK: @sfoo = addrspace(200) global i8 0, align 1
// CHECK-NEXT: @.str = private unnamed_addr addrspace(200) constant [7 x i8] c"sfoo_0\00", section "llvm.metadata"
// CHECK-NEXT: @.str.1 = private unnamed_addr addrspace(200) constant
// CHECK-NEXT: @.str.2 = private unnamed_addr addrspace(200) constant [7 x i8] c"sfoo_1\00", section "llvm.metadata"
// CHECK-NEXT: @llvm.global.annotations = appending addrspace(200) global [2 x { i8*, i8 addrspace(200)*, i8 addrspace(200)*, i32 }] [{ i8*, i8 addrspace(200)*, i8 addrspace(200)*, i32 } { i8* addrspacecast (i8 addrspace(200)* @sfoo to i8*), i8 addrspace(200)* getelementptr inbounds ([7 x i8], [7 x i8] addrspace(200)* @.str, i32 0, i32 0), i8 addrspace(200)* getelementptr inbounds ([{{.*}} x i8], [{{.*}} x i8] addrspace(200)* @.str.1, i32 0, i32 0), i32 3 }, { i8*, i8 addrspace(200)*, i8 addrspace(200)*, i32 } { i8* addrspacecast (i8 addrspace(200)* @sfoo to i8*), i8 addrspace(200)* getelementptr inbounds ([7 x i8], [7 x i8] addrspace(200)* @.str.2, i32 0, i32 0), i8 addrspace(200)* getelementptr inbounds ([{{.*}} x i8], [{{.*}} x i8] addrspace(200)* @.str.1, i32 0, i32 0), i32 3 }], section "llvm.metadata"
