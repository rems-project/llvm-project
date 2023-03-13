; RUN: llc -mattr=+morello,+c64 -target-abi=purecap -filetype=obj < %s > %t
; RUN: llvm-dwarfdump -v --debug-info %t | FileCheck %s

; Check that types with the DW_ATE_CHERI_signed_intcap and
; DW_ATE_CHERI_unsigned_intcap encodings appear as such in the debug info.
;
; Generated from the following source compiled to LLVM IR with clang -g -ma64c:
;
; __intcap_t intcap;
; __uintcap_t uintcap;

; CHECK: 0x{{[0-9a-f]+}}:   DW_TAG_base_type
; CHECK-NEXT: DW_AT_name [DW_FORM_strp]       ( .debug_str[0x{{[0-9a-f]+}}] = "__intcap_t")
; CHECK-NEXT: DW_AT_encoding [DW_FORM_data1]  (DW_ATE_CHERI_signed_intcap)
; CHECK-NEXT: DW_AT_byte_size [DW_FORM_data1] (0x10)
;
; CHECK: 0x{{[0-9a-f]+}}:   DW_TAG_base_type
; CHECK-NEXT: DW_AT_name [DW_FORM_strp]       ( .debug_str[0x{{[0-9a-f]+}}] = "__uintcap_t")
; CHECK-NEXT: DW_AT_encoding [DW_FORM_data1]  (DW_ATE_CHERI_unsigned_intcap)
; CHECK-NEXT: DW_AT_byte_size [DW_FORM_data1] (0x10)
;
; CHECK-NOT: DW_TAG_base_type

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-none--elf"

@intcap = common global i8 addrspace(200)* null, align 16, !dbg !0
@uintcap = common global i8 addrspace(200)* null, align 16, !dbg !6

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "intcap", scope: !2, file: !3, line: 1, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 5.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5)
!3 = !DIFile(filename: "dwarf-test.c", directory: "/tmp")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "uintcap", scope: !2, file: !3, line: 2, type: !8, isLocal: false, isDefinition: true)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintcap_t", file: !3, line: 2, baseType: !9)
!9 = !DIBasicType(name: "__uintcap_t", size: 128, encoding: DW_ATE_CHERI_unsigned_intcap)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intcap_t", file: !3, line: 1, baseType: !11)
!11 = !DIBasicType(name: "__intcap_t", size: 128, encoding: DW_ATE_CHERI_signed_intcap)
!12 = !{i32 2, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{!"clang version 5.0.0"}
