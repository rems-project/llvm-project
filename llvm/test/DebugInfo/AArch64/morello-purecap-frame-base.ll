; RUN: llc -mattr=+morello,+c64 -target-abi=purecap -filetype=obj < %s > %t
; RUN: llvm-dwarfdump -v --debug-info %t | FileCheck %s

; Check that the DW_AT_frame_base attribute uses a capability register Cn/CSP
; instead of Xn/SP in the pure capability ABI. The test contains function foo()
; that consists only from a return instruction and does not use stack at all.
; The DW_AT_frame_base information in DWARF should be therefore recorded as
; DW_OP_regx 157 (bytes 90 9f 01).

; CHECK: 0x{{[0-9a-f]+}}:   DW_TAG_subprogram
; CHECK-NEXT: DW_AT_low_pc [DW_FORM_addr]     (0x0000000000000000 ".text")
; CHECK-NEXT: DW_AT_high_pc [DW_FORM_data4]   (0x00000004)
; CHECK-NEXT: DW_AT_frame_base [DW_FORM_exprloc] (DW_OP_regx CSP)
; CHECK-NOT: DW_TAG_subprogram

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200"
target triple = "aarch64-none--elf"

define void @foo() !dbg !6 {
entry:
  ret void, !dbg !9
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}
!llvm.ident = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 5.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "dwarf-test.c", directory: "/tmp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 5.0.0"}
!6 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !7, isLocal: false, isDefinition: true, scopeLine: 1, flags: DIFlagPrototyped, isOptimized: false, unit: !0)
!7 = !DISubroutineType(types: !8)
!8 = !{null}
!9 = !DILocation(line: 1, column: 17, scope: !6)
