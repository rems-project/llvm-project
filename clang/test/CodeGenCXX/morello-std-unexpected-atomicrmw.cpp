// REQUIRES: aarch64-registered-target
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -emit-llvm \
// RUN:            -std=c++11 -mllvm -cheri-cap-table-abi=pcrel -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -target-feature +c64 \
// RUN:            -mllvm -cheri-cap-table-abi=pcrel -ast-dump -std=c++11 %s | FileCheck -check-prefix=AST %s

// Copied from the corresponding cheri file.

typedef void (*handler)();
__attribute__((__require_constant_initialization__)) static handler __handler;

handler set_handler_sync(handler func) noexcept {
  return __sync_lock_test_and_set(&__handler, func);
  // CHECK: atomicrmw xchg void () addrspace(200)* addrspace(200)* @_ZL9__handler, void () addrspace(200)* %0 seq_cst
  // AST: DeclRefExpr {{.*}} '__sync_lock_test_and_set_16' '__int128 (volatile __int128 *, __int128, ...) noexcept'
}

handler get_handler_sync() noexcept {
  // CHECK: atomicrmw add void () addrspace(200)* addrspace(200)* @_ZL9__handler, void () addrspace(200)* null seq_cst
  return __sync_fetch_and_add(&__handler, (handler)0);
  // AST: DeclRefExpr {{.*}} '__sync_fetch_and_add_16' '__int128 (volatile __int128 *, __int128, ...) noexcept'
}

handler set_handler_atomic(handler func) noexcept {
  // CHECK-NOT: bitcast void () addrspace(200)* addrspace(200)* %.atomictmp to i128 addrspace(200)*
  // CHECK-NOT: bitcast void () addrspace(200)* addrspace(200)* %atomic-temp to i128 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %1 to i8 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %2 to i8 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %2 to void () addrspace(200)* addrspace(200)*
  // CHECK: atomicrmw xchg void () addrspace(200)* addrspace(200)* @_ZL9__handler, void () addrspace(200)* %1 seq_cst
  return __atomic_exchange_n(&__handler, func, __ATOMIC_SEQ_CST);
}

handler get_handler_atomic() noexcept {
  // CHECK-NOT: bitcast void () addrspace(200)* addrspace(200)* %atomic-temp to i128 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %0 to i8 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %0 to void () addrspace(200)* addrspace(200)*
  // CHECK: load atomic void () addrspace(200)*, void () addrspace(200)* addrspace(200)* @_ZL9__handler seq_cst, align 16
  return __atomic_load_n(&__handler, __ATOMIC_SEQ_CST);
}

__attribute__((__require_constant_initialization__)) static _Atomic(handler) __atomic_handler;

handler set_handler_c11_atomic(handler func) noexcept {
  // CHECK-NOT: bitcast void () addrspace(200)* addrspace(200)* %.atomictmp to i128 addrspace(200)*
  // CHECK-NOT: bitcast void () addrspace(200)* addrspace(200)* %atomic-temp to i128 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %1 to i8 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %2 to i8 addrspace(200)*
  // CHECK-NOT: bitcast i128 addrspace(200)* %2 to void () addrspace(200)* addrspace(200)*
  // CHECK: atomicrmw xchg void () addrspace(200)* addrspace(200)* @_ZL16__atomic_handler, void () addrspace(200)* %1 seq_cst
  return __c11_atomic_exchange(&__atomic_handler, func, __ATOMIC_SEQ_CST);
}
