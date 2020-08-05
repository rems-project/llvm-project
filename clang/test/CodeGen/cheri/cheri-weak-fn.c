// RUN: %cheri_cc1 %s "-target-abi" "purecap" -emit-llvm  -o -
// RUN: %clang_cc1 %s -triple aarch64-none-elf -target-feature +c64 "-target-abi" "purecap" -emit-llvm  -o - -mllvm -cheri-cap-table-abi=pcrel
__attribute__((weak))
void fn();

void *v()
{
  // CHECK: @llvm.mips.pcc.get()
  // CHECK: @llvm.mips.cap.from.pointer
  return fn;
}
