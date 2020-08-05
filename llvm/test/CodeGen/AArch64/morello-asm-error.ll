; RUN: not llc -march=arm64 -mattr=+morello -o - %s |& FileCheck %s

; CHECK: couldn't allocate input reg for constraint 'C'
define void @foo(i64 %in) {
  call void asm sideeffect "", "C,~{memory}"(i64 %in)
  ret void
}
