// RUN: %clang_cc1 -Wall -Werror -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -disable-O0-optnone -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

// CHECK-LABEL: test_tp_char
// CHECK: llvm.thread.pointer.p200i8
void *test_tp_char() {
  return __builtin_thread_pointer();
}

// CHECK-LABEL: test_tp_int
// CHECK: llvm.thread.pointer.p200i8
int *test_tp_int() {
  return __builtin_thread_pointer();
}
