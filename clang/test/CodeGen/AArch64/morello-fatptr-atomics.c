// RUN: %clang_cc1 %s -emit-llvm -o - -triple=aarch64-none-elf  -target-feature +c64 -target-abi purecap | FileCheck %s
// RUN: %clang_cc1 %s -emit-llvm -o - -triple=aarch64-none-elf  -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel | FileCheck %s


// CHECK: @atomic_fun
int *atomic_fun(
  int **val,
  char **valc,
  _Bool **valb ,
  unsigned int **uval ,
  int **cmp,
  int** ptrval) {

  int *old = 0;
  old = __sync_fetch_and_add(val, (int *)1);
  // CHECK: atomicrmw add i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst
  old = (int *)__sync_fetch_and_sub(valc, (char *)2);
  // CHECK: atomicrmw sub i8 addrspace(200)* addrspace(200)* %{{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  old = __sync_lock_test_and_set(val, (int *)7);
  // CHECK: atomicrmw xchg i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_swap(val, (int *)8);
  // CHECK: atomicrmw xchg i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_val_compare_and_swap(val, (int *)4, (int *)1976);
  // CHECK: [[PAIR:%[a-z0-9_.]+]] = cmpxchg i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}}, i32 addrspace(200)* {{.*}} seq_cst
  // CHECK: extractvalue { i32 addrspace(200)*, i1 } [[PAIR]], 0

  __sync_bool_compare_and_swap(val, (int *)4, (int *)1976);
  // CHECK: [[PAIR:%[a-z0-9_.]+]] = cmpxchg i32 addrspace(200)* addrspace(200)* %{{.*}},  i32 addrspace(200)* {{.*}}, i32 addrspace(200)* {{.*}} seq_cst
  // CHECK: extractvalue { i32 addrspace(200)*, i1 } [[PAIR]], 1

  old = (int *)__sync_fetch_and_and(val, (int *)0x9);
  // CHECK: atomicrmw and i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_fetch_and_or(val, (int *)0xa);
  // CHECK: atomicrmw or i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_fetch_and_xor(val, (int *)0xb);
  // CHECK: atomicrmw xor i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_fetch_and_nand(val, (int *)1);
  // CHECK: atomicrmw nand i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_add_and_fetch(val, (int *)1);
  // CHECK: atomicrmw add i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_sub_and_fetch(val, (int *)2);
  // CHECK: atomicrmw sub i32 addrspace(200)* addrspace(200)* %{{.*}}, i32 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_and_and_fetch(valc, (void *)3);
  // CHECK: atomicrmw and i8 addrspace(200)* addrspace(200)* %{{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_or_and_fetch(valc, (void *)4);
  // CHECK: atomicrmw or i8 addrspace(200)* addrspace(200)* %{{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_xor_and_fetch(valc, (void*)5);
  // CHECK: atomicrmw xor i8 addrspace(200)* addrspace(200)* %{{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  old = (int *)__sync_nand_and_fetch(valc, (void*)6);
  // CHECK: atomicrmw nand i8 addrspace(200)* addrspace(200)* %{{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  __sync_val_compare_and_swap((void **)0, (void *)0, (void *)0);
  // CHECK: [[PAIR:%[a-z0-9_.]+]] = cmpxchg i8 addrspace(200)* addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}} seq_cst
  // CHECK: extractvalue { i8 addrspace(200)*, i1 } [[PAIR]], 0

  if ( __sync_val_compare_and_swap(valb, (_Bool *)0, (_Bool*)1)) {
    // CHECK: [[PAIR:%[a-z0-9_.]+]] = cmpxchg i8 addrspace(200)* addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}} seq_cst
    // CHECK: [[VAL:%[a-z0-9_.]+]] = extractvalue { i8 addrspace(200)*, i1 } [[PAIR]], 0
    old = (int *)42;
  }

  __sync_bool_compare_and_swap((void **)0, (void *)0, (void *)0);
  // CHECK: cmpxchg i8 addrspace(200)* addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}}, i8 addrspace(200)* {{.*}} seq_cst

  __sync_lock_release(val);
  // CHECK: store atomic i32 addrspace(200)* null, i32 addrspace(200)* addrspace(200)* {{.*}} release, align 16

  __sync_lock_release(ptrval);
  // CHECK: store atomic i32 addrspace(200)* null, i32 addrspace(200)* addrspace(200)* {{.*}} release, align 16

  __sync_synchronize ();
  // CHECK: fence seq_cst
  return old;
}

// CHECK: @release_return
void release_return(int **lock) {
  // Ensure this is actually returning void all the way through.
  return __sync_lock_release(lock);
  // CHECK: store atomic i32 addrspace(200)* null, i32 addrspace(200)* addrspace(200)* {{.*}} release, align 16
}
