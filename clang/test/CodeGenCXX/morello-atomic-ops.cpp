// RUN: %clang %s -target aarch64-none-elf -march=morello+c64 -mabi=purecap -std=c++0x -S -o - -emit-llvm | FileCheck %s

// Check that we can at least produce valid IR for these.
// We can at least make sure that no i128 values were produced (from conversions to integers).

#include <stdatomic.h>
#include <stdbool.h>

struct S { char c[3]; };

char i8;
short i16;
int i32;
int __attribute__((vector_size(8))) i64;

// CHECK-LABEL: fun1
// CHECK-NOT: i128
void fun1(_Atomic(int) *i, const _Atomic(int) *ci,
       _Atomic(int*) *p, _Atomic(float) *d,
       int *I, const int *CI,
       int **P, float *D, struct S *s1, struct S *s2) {
  __c11_atomic_store(i, 0, memory_order_relaxed);
  __c11_atomic_load(i, memory_order_seq_cst);
  __c11_atomic_load(p, memory_order_seq_cst);
  __c11_atomic_load(d, memory_order_seq_cst);

int load_n_1 = __atomic_load_n(I, memory_order_relaxed);
int *load_n_2 = __atomic_load_n(P, memory_order_relaxed);
  load_n_1 = __atomic_load_n(CI, memory_order_relaxed);

  __atomic_load(CI, I, memory_order_relaxed);

  __atomic_load(I, *P, memory_order_relaxed);
  __atomic_load(s1, s2, memory_order_acquire);
  __atomic_load(CI, I, memory_order_relaxed);

  __c11_atomic_store(i, 1, memory_order_seq_cst);

  __atomic_store_n(I, 4, memory_order_release);
  __atomic_store_n(I, 4.0, memory_order_release);

  __atomic_store(I, *P, memory_order_release);
 __atomic_store(s1, s2, memory_order_release);

  int exchange_1 = __c11_atomic_exchange(i, 1, memory_order_seq_cst);
  int exchange_4 = __atomic_exchange_n(I, 1, memory_order_seq_cst);

__atomic_exchange(s1, s2, s2, memory_order_seq_cst);
__atomic_exchange(I, I, I, memory_order_seq_cst);

__c11_atomic_fetch_add(i, 1, memory_order_seq_cst);
__c11_atomic_fetch_add(p, 1, memory_order_seq_cst);

__atomic_fetch_sub(I, 3, memory_order_seq_cst);
__atomic_fetch_sub(P, 3, memory_order_seq_cst);

__c11_atomic_fetch_and(i, 1, memory_order_seq_cst);

__atomic_fetch_or(I, 3, memory_order_seq_cst);


  bool cmpexch_1 = __c11_atomic_compare_exchange_strong(i, I, 1, memory_order_seq_cst, memory_order_seq_cst);
  bool cmpexch_2 = __c11_atomic_compare_exchange_strong(p, P, (int*)1, memory_order_seq_cst, memory_order_seq_cst);

  bool cmpexchw_1 = __c11_atomic_compare_exchange_weak(i, I, 1, memory_order_seq_cst, memory_order_seq_cst);
  bool cmpexchw_2 = __c11_atomic_compare_exchange_weak(p, P, (int*)1, memory_order_seq_cst, memory_order_seq_cst);

  bool cmpexch_4 = __atomic_compare_exchange_n(I, I, 5, 1, memory_order_seq_cst, memory_order_seq_cst);


  bool cmpexch_9 = __atomic_compare_exchange(I, I, I, 0, memory_order_seq_cst, memory_order_seq_cst);

  bool cmpexch_10 = __c11_atomic_compare_exchange_strong((_Atomic int *)0x308, (int *)0x309, 1, memory_order_seq_cst, memory_order_seq_cst);

const volatile int flag_k = 0;
volatile int flag = 0;
(void)(int)__atomic_test_and_set(&flag, memory_order_seq_cst);
__atomic_clear(&flag, memory_order_seq_cst);

atomic_int n = ATOMIC_VAR_INIT(123);
atomic_init(&n, 456);

atomic_wchar_t awt;
atomic_init(&awt, L'x');

int x = kill_dependency(12);

atomic_thread_fence(memory_order_seq_cst);
atomic_signal_fence(memory_order_seq_cst);
void (*pfn)(memory_order) = &atomic_thread_fence;
pfn = &atomic_signal_fence;

int k = atomic_load_explicit(&n, memory_order_relaxed);
atomic_store_explicit(&n, k, memory_order_relaxed);
atomic_store(&n, atomic_load(&n));

k = atomic_exchange(&n, 72);
k = atomic_exchange_explicit(&n, k, memory_order_release);

atomic_compare_exchange_weak(&n, &k, k);
atomic_compare_exchange_weak_explicit(&n, &k, k, memory_order_seq_cst, memory_order_acquire);

k = atomic_fetch_add(&n, k);
k = atomic_fetch_sub(&n, k);
k = atomic_fetch_and(&n, k);
k = atomic_fetch_or(&n, k);
k = atomic_fetch_xor(&n, k);
k = atomic_fetch_add_explicit(&n, k, memory_order_acquire);
k = atomic_fetch_sub_explicit(&n, k, memory_order_release);
k = atomic_fetch_and_explicit(&n, k, memory_order_acq_rel);
k = atomic_fetch_or_explicit(&n, k, memory_order_consume);
k = atomic_fetch_xor_explicit(&n, k, memory_order_relaxed);
}

// CHECK-LABEL: memory_checks
// CHECK-NOT: i128
void memory_checks(_Atomic(int) *Ap, int *p, int val) {
  (void)__c11_atomic_load(Ap, memory_order_relaxed);
  (void)__c11_atomic_load(Ap, memory_order_acquire);
  (void)__c11_atomic_load(Ap, memory_order_consume);
  (void)__c11_atomic_load(Ap, memory_order_seq_cst);
  (void)__c11_atomic_load(Ap, val);

  (void)__c11_atomic_store(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_store(Ap, val, memory_order_release);
  (void)__c11_atomic_store(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_relaxed);
  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_acquire);
  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_consume);
  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_release);
  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_acq_rel);
  (void)__c11_atomic_fetch_add(Ap, 1, memory_order_seq_cst);


  (void)__c11_atomic_init(Ap, val);
  (void)__c11_atomic_init(Ap, val);
  (void)__c11_atomic_init(Ap, val);
  (void)__c11_atomic_init(Ap, val);
  (void)__c11_atomic_init(Ap, val);
  (void)__c11_atomic_init(Ap, val);

  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_acquire);
  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_consume);
  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_release);
  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_acq_rel);
  (void)__c11_atomic_fetch_sub(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_fetch_and(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_fetch_and(Ap, val, memory_order_acquire);
  (void)__c11_atomic_fetch_and(Ap, val, memory_order_consume);
  (void)__c11_atomic_fetch_and(Ap, val, memory_order_release);
  (void)__c11_atomic_fetch_and(Ap, val, memory_order_acq_rel);
  (void)__c11_atomic_fetch_and(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_fetch_or(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_fetch_or(Ap, val, memory_order_acquire);
  (void)__c11_atomic_fetch_or(Ap, val, memory_order_consume);
  (void)__c11_atomic_fetch_or(Ap, val, memory_order_release);
  (void)__c11_atomic_fetch_or(Ap, val, memory_order_acq_rel);
  (void)__c11_atomic_fetch_or(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_acquire);
  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_consume);
  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_release);
  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_acq_rel);
  (void)__c11_atomic_fetch_xor(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_exchange(Ap, val, memory_order_relaxed);
  (void)__c11_atomic_exchange(Ap, val, memory_order_acquire);
  (void)__c11_atomic_exchange(Ap, val, memory_order_consume);
  (void)__c11_atomic_exchange(Ap, val, memory_order_release);
  (void)__c11_atomic_exchange(Ap, val, memory_order_acq_rel);
  (void)__c11_atomic_exchange(Ap, val, memory_order_seq_cst);

  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_relaxed, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_acquire, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_consume, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_release, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_acq_rel, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_strong(Ap, p, val, memory_order_seq_cst, memory_order_relaxed);

  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_relaxed, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_acquire, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_consume, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_release, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_acq_rel, memory_order_relaxed);
  (void)__c11_atomic_compare_exchange_weak(Ap, p, val, memory_order_seq_cst, memory_order_relaxed);

  (void)__atomic_load_n(p, memory_order_relaxed);
  (void)__atomic_load_n(p, memory_order_acquire);
  (void)__atomic_load_n(p, memory_order_consume);
  (void)__atomic_load_n(p, memory_order_seq_cst);

  (void)__atomic_load(p, p, memory_order_relaxed);
  (void)__atomic_load(p, p, memory_order_acquire);
  (void)__atomic_load(p, p, memory_order_consume);
  (void)__atomic_load(p, p, memory_order_seq_cst);

  (void)__atomic_store(p, p, memory_order_relaxed);
  (void)__atomic_store(p, p, memory_order_release);
  (void)__atomic_store(p, p, memory_order_seq_cst);

  (void)__atomic_store_n(p, val, memory_order_relaxed);
  (void)__atomic_store_n(p, val, memory_order_release);
  (void)__atomic_store_n(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_add(p, val, memory_order_relaxed);
  (void)__atomic_fetch_add(p, val, memory_order_acquire);
  (void)__atomic_fetch_add(p, val, memory_order_consume);
  (void)__atomic_fetch_add(p, val, memory_order_release);
  (void)__atomic_fetch_add(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_add(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_sub(p, val, memory_order_relaxed);
  (void)__atomic_fetch_sub(p, val, memory_order_acquire);
  (void)__atomic_fetch_sub(p, val, memory_order_consume);
  (void)__atomic_fetch_sub(p, val, memory_order_release);
  (void)__atomic_fetch_sub(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_sub(p, val, memory_order_seq_cst);

  (void)__atomic_add_fetch(p, val, memory_order_relaxed);
  (void)__atomic_add_fetch(p, val, memory_order_acquire);
  (void)__atomic_add_fetch(p, val, memory_order_consume);
  (void)__atomic_add_fetch(p, val, memory_order_release);
  (void)__atomic_add_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_add_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_sub_fetch(p, val, memory_order_relaxed);
  (void)__atomic_sub_fetch(p, val, memory_order_acquire);
  (void)__atomic_sub_fetch(p, val, memory_order_consume);
  (void)__atomic_sub_fetch(p, val, memory_order_release);
  (void)__atomic_sub_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_sub_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_and(p, val, memory_order_relaxed);
  (void)__atomic_fetch_and(p, val, memory_order_acquire);
  (void)__atomic_fetch_and(p, val, memory_order_consume);
  (void)__atomic_fetch_and(p, val, memory_order_release);
  (void)__atomic_fetch_and(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_and(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_or(p, val, memory_order_relaxed);
  (void)__atomic_fetch_or(p, val, memory_order_acquire);
  (void)__atomic_fetch_or(p, val, memory_order_consume);
  (void)__atomic_fetch_or(p, val, memory_order_release);
  (void)__atomic_fetch_or(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_or(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_xor(p, val, memory_order_relaxed);
  (void)__atomic_fetch_xor(p, val, memory_order_acquire);
  (void)__atomic_fetch_xor(p, val, memory_order_consume);
  (void)__atomic_fetch_xor(p, val, memory_order_release);
  (void)__atomic_fetch_xor(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_xor(p, val, memory_order_seq_cst);

  (void)__atomic_fetch_nand(p, val, memory_order_relaxed);
  (void)__atomic_fetch_nand(p, val, memory_order_acquire);
  (void)__atomic_fetch_nand(p, val, memory_order_consume);
  (void)__atomic_fetch_nand(p, val, memory_order_release);
  (void)__atomic_fetch_nand(p, val, memory_order_acq_rel);
  (void)__atomic_fetch_nand(p, val, memory_order_seq_cst);

  (void)__atomic_and_fetch(p, val, memory_order_relaxed);
  (void)__atomic_and_fetch(p, val, memory_order_acquire);
  (void)__atomic_and_fetch(p, val, memory_order_consume);
  (void)__atomic_and_fetch(p, val, memory_order_release);
  (void)__atomic_and_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_and_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_or_fetch(p, val, memory_order_relaxed);
  (void)__atomic_or_fetch(p, val, memory_order_acquire);
  (void)__atomic_or_fetch(p, val, memory_order_consume);
  (void)__atomic_or_fetch(p, val, memory_order_release);
  (void)__atomic_or_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_or_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_xor_fetch(p, val, memory_order_relaxed);
  (void)__atomic_xor_fetch(p, val, memory_order_acquire);
  (void)__atomic_xor_fetch(p, val, memory_order_consume);
  (void)__atomic_xor_fetch(p, val, memory_order_release);
  (void)__atomic_xor_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_xor_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_nand_fetch(p, val, memory_order_relaxed);
  (void)__atomic_nand_fetch(p, val, memory_order_acquire);
  (void)__atomic_nand_fetch(p, val, memory_order_consume);
  (void)__atomic_nand_fetch(p, val, memory_order_release);
  (void)__atomic_nand_fetch(p, val, memory_order_acq_rel);
  (void)__atomic_nand_fetch(p, val, memory_order_seq_cst);

  (void)__atomic_exchange_n(p, val, memory_order_relaxed);
  (void)__atomic_exchange_n(p, val, memory_order_acquire);
  (void)__atomic_exchange_n(p, val, memory_order_consume);
  (void)__atomic_exchange_n(p, val, memory_order_release);
  (void)__atomic_exchange_n(p, val, memory_order_acq_rel);
  (void)__atomic_exchange_n(p, val, memory_order_seq_cst);

  (void)__atomic_exchange(p, p, p, memory_order_relaxed);
  (void)__atomic_exchange(p, p, p, memory_order_acquire);
  (void)__atomic_exchange(p, p, p, memory_order_consume);
  (void)__atomic_exchange(p, p, p, memory_order_release);
  (void)__atomic_exchange(p, p, p, memory_order_acq_rel);
  (void)__atomic_exchange(p, p, p, memory_order_seq_cst);

  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_relaxed, memory_order_relaxed);
  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_acquire, memory_order_relaxed);
  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_consume, memory_order_relaxed);
  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_release, memory_order_relaxed);
  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_acq_rel, memory_order_relaxed);
  (void)__atomic_compare_exchange(p, p, p, 0, memory_order_seq_cst, memory_order_relaxed);

  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_relaxed, memory_order_relaxed);
  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_acquire, memory_order_relaxed);
  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_consume, memory_order_relaxed);
  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_release, memory_order_relaxed);
  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_acq_rel, memory_order_relaxed);
  (void)__atomic_compare_exchange_n(p, p, val, 0, memory_order_seq_cst, memory_order_relaxed);
}

_Atomic(int) var=42;
_Atomic(int) var2=55;
_Atomic(int*) p2;
_Atomic(int*) p;

// CHECK-LABEL: atomictest
// CHECK-NOT: i128
void atomictest(void){
    p2 = p;
   p = p2;
   __c11_atomic_store(&p,p2,__ATOMIC_SEQ_CST);
}
