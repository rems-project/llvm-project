// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +morello -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s


void bar(__builtin_va_list *);
void baz(__builtin_va_list);

// CHECK-LABEL: foo
// CHECK: call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %{{.*}}, i8* align 8 %{{.*}}, i64 32, i1 false) #[[ATTR:[0-9]+]]

// CHECK: attributes #[[ATTR]] = { no_preserve_cheri_tags }
void foo() {
  __builtin_va_list arg;
  bar(&arg);
  baz(arg);
}

