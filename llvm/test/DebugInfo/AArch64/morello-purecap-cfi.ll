; RUN: llc -mattr=+morello,+c64 -target-abi=purecap -frame-pointer=all -filetype=asm %s -o - \
; RUN:   | FileCheck %s

; Check the following expectations for functions compiled in the pure capability
; ABI:
; * RA is defined as CLR and initial CFA is defined as CSP+0. This is checked by
;   looking for .cfi_startproc with the purecap argument.
; * Subsequent CFA redefinitions with .cfi_def_cfa use a capability register
;   Cn/CSP instead of Xn/SP.
;
; The test contains function foo() that sets up a frame pointer and function
; bar() which is a leaf function that does use stack at all.
;
; Generated from the following source compiled to LLVM IR:
;
; void baz(int *);
; int foo(void) {
;   int a;
;   baz(&a);
;   return a;
; }
; int bar(void) { return 0; }

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200"
target triple = "aarch64-none--elf"

define i32 @foo() #0 !dbg !6 {
entry:
  %a = alloca i32, align 4, addrspace(200)
  %0 = call i8 addrspace(200)* @llvm.cheri.pcc.get()
  %1 = call i64 @llvm.cheri.cap.base.get(i8 addrspace(200)* %0)
  %ptroffset = sub i64 ptrtoint (void (i32 addrspace(200)*) addrspace(200)* @baz to i64), %1
  %2 = call i8 addrspace(200)* @llvm.cheri.cap.offset.set(i8 addrspace(200)* %0, i64 %ptroffset)
  %3 = bitcast i8 addrspace(200)* %2 to void (i32 addrspace(200)*) addrspace(200)*
  call void %3(i32 addrspace(200)* %a)
  %4 = load i32, i32 addrspace(200)* %a, align 4
  ret i32 %4

; CHECK-LABEL: foo:
; CHECK: .cfi_startproc purecap
; CHECK: .cfi_def_cfa c29, {{[0-9]+}}
}

define i32 @bar() #0 !dbg !10 {
entry:
  ret i32 0

; CHECK-LABEL: bar:
; CHECK: .cfi_startproc purecap
; CHECK: .cfi_def_cfa c29
}

declare void @baz(i32 addrspace(200)*)

declare i8 addrspace(200)* @llvm.cheri.pcc.get()

declare i64 @llvm.cheri.cap.base.get(i8 addrspace(200)*)

declare i8 addrspace(200)* @llvm.cheri.cap.offset.set(i8 addrspace(200)*, i64)

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}
!llvm.ident = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 5.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "dwarf-test.c", directory: "/tmp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 5.0.0"}
!6 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 2, type: !7, isLocal: false, isDefinition: true, scopeLine: 2, flags: DIFlagPrototyped, isOptimized: false, unit: !0)
!7 = !DISubroutineType(types: !8)
!8 = !{!9}
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 7, type: !7, isLocal: false, isDefinition: true, scopeLine: 7, flags: DIFlagPrototyped, isOptimized: false, unit: !0)
