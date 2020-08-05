// RUN: %clang_cc1 -ffreestanding -triple aarch64-eabi -target-cpu cortex-a57 -target-feature +neon -target-feature +crc -target-feature +crypto -target-feature +c64 -target-abi purecap -O -S -emit-llvm -o - %s | FileCheck %s

#include <arm_acle.h>

/* 8 SYNCHRONIZATION, BARRIER AND HINT INTRINSICS */
/* 8.3 Memory Barriers */
// CHECK-LABEL: test_dmb
// CHECK: call void @llvm.aarch64.dmb(i32 1)
void test_dmb(void) {
  __dmb(1);
}

// CHECK-LABEL: test_dsb
// CHECK: call void @llvm.aarch64.dsb(i32 2)
void test_dsb(void) {
  __dsb(2);
}

// CHECK-LABEL: test_isb
// CHECK: call void @llvm.aarch64.isb(i32 3)
void test_isb(void) {
  __isb(3);
}

/* 8.4 Hints */
// CHECK-LABEL: test_yield
// CHECK: call void @llvm.aarch64.hint(i32 1)
void test_yield(void) {
  __yield();
}

// CHECK-LABEL: test_wfe
// CHECK: call void @llvm.aarch64.hint(i32 2)
void test_wfe(void) {
  __wfe();
}

// CHECK-LABEL: test_wfi
// CHECK: call void @llvm.aarch64.hint(i32 3)
void test_wfi(void) {
  __wfi();
}

// CHECK-LABEL: test_sev
// CHECK: call void @llvm.aarch64.hint(i32 4)
void test_sev(void) {
  __sev();
}

// CHECK-LABEL: test_sevl
// CHECK: call void @llvm.aarch64.hint(i32 5)
void test_sevl(void) {
  __sevl();
}

/* 8.5 Swap */
// CHECK-LABEL: test_swp
// CHECK: call i64 @llvm.aarch64.ldxr
// CHECK: call i32 @llvm.aarch64.stxr
void test_swp(uint32_t x, volatile void *p) {
  __swp(x, p);
}

/* 8.6 Memory prefetch intrinsics */
/* 8.6.1 Data prefetch */
// CHECK-LABEL: test_pld
// CHECK: call void @llvm.prefetch.p200i8(i8 addrspace(200)* null, i32 0, i32 3, i32 1)
void test_pld() {
  __pld(0);
}

// CHECK-LABEL: test_pldx
// CHECK: call void @llvm.prefetch.p200i8(i8 addrspace(200)* null, i32 1, i32 1, i32 1)
void test_pldx() {
  __pldx(1, 2, 0, 0);
}

/* 8.6.2 Instruction prefetch */
// CHECK-LABEL: test_pli
// CHECK: call void @llvm.prefetch.p200i8(i8 addrspace(200)* null, i32 0, i32 3, i32 0)
void test_pli() {
  __pli(0);
}

// CHECK-LABEL: test_plix
// CHECK: call void @llvm.prefetch.p200i8(i8 addrspace(200)* null, i32 0, i32 1, i32 0)
void test_plix() {
  __plix(2, 0, 0);
}

/* 8.7 NOP */
// CHECK-LABEL: test_nop
// CHECK: call void @llvm.aarch64.hint(i32 0)
void test_nop(void) {
  __nop();
}

/* 9 DATA-PROCESSING INTRINSICS */

/* 9.2 Miscellaneous data-processing intrinsics */
// CHECK-LABEL: test_ror
// CHECK: call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 %y)
uint32_t test_ror(uint32_t x, uint32_t y) {
  return __ror(x, y);
}

// CHECK-LABEL: test_rorl
// CHECK: lshr
// CHECK: sub
// CHECK: shl
// CHECK: or
unsigned long test_rorl(unsigned long x, uint32_t y) {
  return __rorl(x, y);
}

// CHECK-LABEL: test_rorll
// CHECK: lshr
// CHECK: sub
// CHECK: shl
// CHECK: or
uint64_t test_rorll(uint64_t x, uint32_t y) {
  return __rorll(x, y);
}

// CHECK-LABEL: test_clz
// CHECK: call i32 @llvm.ctlz.i32(i32 %t, i1 false)
uint32_t test_clz(uint32_t t) {
  return __clz(t);
}

// CHECK-LABEL: test_clzl
// AArch32: call i32 @llvm.ctlz.i32(i32 %t, i1 false)
// CHECK: call i64 @llvm.ctlz.i64(i64 %t, i1 false)
long test_clzl(long t) {
  return __clzl(t);
}

// CHECK-LABEL: test_clzll
// CHECK: call i64 @llvm.ctlz.i64(i64 %t, i1 false)
uint64_t test_clzll(uint64_t t) {
  return __clzll(t);
}

// CHECK-LABEL: test_rev
// CHECK: call i32 @llvm.bswap.i32(i32 %t)
uint32_t test_rev(uint32_t t) {
  return __rev(t);
}

// CHECK-LABEL: test_revl
// AArch32: call i32 @llvm.bswap.i32(i32 %t)
// CHECK: call i64 @llvm.bswap.i64(i64 %t)
long test_revl(long t) {
  return __revl(t);
}

// CHECK-LABEL: test_revll
// CHECK: call i64 @llvm.bswap.i64(i64 %t)
uint64_t test_revll(uint64_t t) {
  return __revll(t);
}

// CHECK-LABEL: test_rev16
// CHECK: llvm.bswap
// CHECK: call i32 @llvm.fshl.i32(i32 %0, i32 %0, i32 16)
uint32_t test_rev16(uint32_t t) {
  return __rev16(t);
}

// CHECK-LABEL: test_rev16l
// CHECK: [[T1:%.*]] = lshr i64 [[IN:%.*]], 32
// CHECK: [[T2:%.*]] = trunc i64 [[T1]] to i32
// CHECK: [[T3:%.*]] = tail call i32 @llvm.bswap.i32(i32 [[T2]])
// CHECK: [[T6:%.*]] = tail call i32 @llvm.fshl.i32(i32 [[T3]], i32 [[T3]], i32 16)
// CHECK: [[T7:%.*]] = zext i32 [[T6]] to i64
// CHECK: [[T8:%.*]] = shl nuw i64 [[T7]], 32
// CHECK: [[T9:%.*]] = trunc i64 [[IN]] to i32
// CHECK: [[T10:%.*]] = tail call i32 @llvm.bswap.i32(i32 [[T9]])
// CHECK: [[T13:%.*]] = tail call i32 @llvm.fshl.i32(i32 [[T10]], i32 [[T10]], i32 16)
// CHECK: [[T14:%.*]] = zext i32 [[T13]] to i64
// CHECK: [[T15:%.*]] = or i64 [[T8]], [[T14]]
long test_rev16l(long t) {
  return __rev16l(t);
}

// CHECK-LABEL: test_rev16ll
// CHECK: [[T1:%.*]] = lshr i64 [[IN:%.*]], 32
// CHECK: [[T2:%.*]] = trunc i64 [[T1]] to i32
// CHECK: [[T3:%.*]] = tail call i32 @llvm.bswap.i32(i32 [[T2]])
// CHECK: [[T6:%.*]] = tail call i32 @llvm.fshl.i32(i32 [[T3]], i32 [[T3]], i32 16)
// CHECK: [[T7:%.*]] = zext i32 [[T6]] to i64
// CHECK: [[T8:%.*]] = shl nuw i64 [[T7]], 32
// CHECK: [[T9:%.*]] = trunc i64 [[IN]] to i32
// CHECK: [[T10:%.*]] = tail call i32 @llvm.bswap.i32(i32 [[T9]])
// CHECK: [[T13:%.*]] = tail call i32 @llvm.fshl.i32(i32 [[T10]], i32 [[T10]], i32 16)
// CHECK: [[T14:%.*]] = zext i32 [[T13]] to i64
// CHECK: [[T15:%.*]] = or i64 [[T8]], [[T14]]
uint64_t test_rev16ll(uint64_t t) {
  return __rev16ll(t);
}

// CHECK-LABEL: test_revsh
// CHECK: call i16 @llvm.bswap.i16(i16 %t)
int16_t test_revsh(int16_t t) {
  return __revsh(t);
}

// CHECK-LABEL: test_rbit
// CHECK: call i32 @llvm.bitreverse.i32
uint32_t test_rbit(uint32_t t) {
  return __rbit(t);
}

// CHECK-LABEL: test_rbitl
// CHECK: call i64 @llvm.bitreverse.i64
long test_rbitl(long t) {
  return __rbitl(t);
}

// CHECK-LABEL: test_rbitll
// CHECK: call i64 @llvm.bitreverse.i64
uint64_t test_rbitll(uint64_t t) {
  return __rbitll(t);
}

/* 9.7 CRC32 intrinsics */
// CHECK-LABEL: test_crc32b
// CHECK: call i32 @llvm.aarch64.crc32b
uint32_t test_crc32b(uint32_t a, uint8_t b) {
  return __crc32b(a, b);
}

// CHECK-LABEL: test_crc32h
// CHECK: call i32 @llvm.aarch64.crc32h
uint32_t test_crc32h(uint32_t a, uint16_t b) {
  return __crc32h(a, b);
}

// CHECK-LABEL: test_crc32w
// CHECK: call i32 @llvm.aarch64.crc32w
uint32_t test_crc32w(uint32_t a, uint32_t b) {
  return __crc32w(a, b);
}

// CHECK-LABEL: test_crc32d
// CHECK: call i32 @llvm.aarch64.crc32x
uint32_t test_crc32d(uint32_t a, uint64_t b) {
  return __crc32d(a, b);
}

// CHECK-LABEL: test_crc32cb
// CHECK: call i32 @llvm.aarch64.crc32cb
uint32_t test_crc32cb(uint32_t a, uint8_t b) {
  return __crc32cb(a, b);
}

// CHECK-LABEL: test_crc32ch
// CHECK: call i32 @llvm.aarch64.crc32ch
uint32_t test_crc32ch(uint32_t a, uint16_t b) {
  return __crc32ch(a, b);
}

// CHECK-LABEL: test_crc32cw
// CHECK: call i32 @llvm.aarch64.crc32cw
uint32_t test_crc32cw(uint32_t a, uint32_t b) {
  return __crc32cw(a, b);
}

// CHECK-LABEL: test_crc32cd
// CHECK: call i32 @llvm.aarch64.crc32cx
uint32_t test_crc32cd(uint32_t a, uint64_t b) {
  return __crc32cd(a, b);
}

/* 10.1 Special register intrinsics */
// CHECK-LABEL: test_rsr
// CHECK: call i64 @llvm.read_register.i64(metadata ![[M0:[0-9]]])
uint32_t test_rsr() {
  return __arm_rsr("1:2:3:4:5");
}

// CHECK-LABEL: test_rsr64
// CHECK: call i64 @llvm.read_register.i64(metadata ![[M0:[0-9]]])
uint64_t test_rsr64() {
  return __arm_rsr64("1:2:3:4:5");
}

// CHECK-LABEL: test_rsrp
// CHECK: call i64 @llvm.read_register.i64(metadata ![[M1:[0-9]]])
void *test_rsrp() {
  return __arm_rsrp("sysreg");
}

// CHECK-LABEL: test_wsr
// CHECK: call void @llvm.write_register.i64(metadata ![[M0:[0-9]]], i64 %{{.*}})
void test_wsr(uint32_t v) {
  __arm_wsr("1:2:3:4:5", v);
}

// CHECK-LABEL: test_wsr64
// CHECK: call void @llvm.write_register.i64(metadata ![[M0:[0-9]]], i64 %{{.*}})
void test_wsr64(uint64_t v) {
  __arm_wsr64("1:2:3:4:5", v);
}

// CHECK-LABEL: test_wsrp
// CHECK: call void @llvm.write_register.i64(metadata ![[M1:[0-9]]], i64 %{{.*}})
void test_wsrp(void *v) {
  __arm_wsrp("sysreg", v);
}

// CHECK: ![[M0]] = !{!"1:2:3:4:5"}
// CHECK: ![[M1]] = !{!"sysreg"}
