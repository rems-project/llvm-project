// RUN: %cheri_cc1 -o - %s -emit-llvm | %cheri_FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +morello -o - %s -S -emit-llvm | %cheri_FileCheck %s
static int foo;

int * __capability bar1 = (int* __capability)&foo;
// CHECK: @bar1 = global i32 addrspace(200)* addrspacecast (i32* @foo to i32 addrspace(200)*), align [[#CAP_SIZE]]

