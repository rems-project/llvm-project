// RUN: %cheri_cc1 -cheri-conversion-error=ignore -std=c++11 -x c++ -emit-llvm -o - %s | %cheri_FileCheck %s

// Don't complain about the conversion.
int &foo(int * __capability x) {
  // CHECK: llvm.cheri.cap.to.pointer
  return *x;
}
