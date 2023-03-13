; RUN: llc -mattr=+morello -filetype=obj < %s > %t
; RUN: llvm-dwarfdump -v --debug-info %t | FileCheck %s

; Check that the compiler produces correct DWARF register numbers for
; capability registers. The test contains parameter bar that is alive in
; function foo() in register c0. The location information in DWARF should be
; therefore recorded as DW_OP_regx 128 (bytes 90 80 01).
;
; Generated from the following source compiled to LLVM IR:
;
; char *__capability foo(char *__capability bar) {
;   return bar;
; }

; CHECK: 0x{{[0-9a-f]+}}:     DW_TAG_formal_parameter
; CHECK-NEXT: DW_AT_location [DW_FORM_exprloc]      (DW_OP_regx C0)
; CHECK-NEXT: DW_AT_name [DW_FORM_strp]     ( .debug_str[0x{{[0-9a-f]+}}] = "bar")
; CHECK-NOT: DW_TAG_formal_parameter

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-none--elf"

define i8 addrspace(200)* @foo(i8 addrspace(200)* readnone returned %bar) local_unnamed_addr !dbg !6 {
entry:
  tail call void @llvm.dbg.value(metadata i8 addrspace(200)* %bar, i64 0, metadata !12, metadata !13), !dbg !14
  ret i8 addrspace(200)* %bar, !dbg !15
}

declare void @llvm.dbg.value(metadata, i64, metadata, metadata)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}
!llvm.ident = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 5.0.0", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "dwarf-test.c", directory: "/tmp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 5.0.0"}
!6 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !7, isLocal: false, isDefinition: true, scopeLine: 1, flags: DIFlagPrototyped, isOptimized: true, unit: !0)
!7 = !DISubroutineType(types: !8)
!8 = !{!9, !9}
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 128, dwarfAddressSpace: 1)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!11 = !{!12}
!12 = !DILocalVariable(name: "bar", arg: 1, scope: !6, file: !1, line: 1, type: !9)
!13 = !DIExpression()
!14 = !DILocation(line: 1, column: 43, scope: !6)
!15 = !DILocation(line: 2, column: 3, scope: !6)
