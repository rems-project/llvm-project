; REQUIRES: object-emission

; RUN: %llc_dwarf -O0 -filetype=obj < %s > %t
; RUN: llvm-dwarfdump -v --debug-info %t | FileCheck %s

; Check that pointers and references can be emitted with DW_AT_address_class.

; Generated from the following source compiled to bitcode with clang -g and then
; manually adding dwarfAddressSpace to FuncVarX types:
;
; struct Struct;
; void func() {
;   int *FuncVar0;
;   int &FuncVar1 = *FuncVar0;
;   int &&FuncVar2 = 0;
; }

; CHECK:      DW_AT_name {{.*}}"FuncVar0"
; CHECK-NEXT: DW_AT_decl_file
; CHECK-NEXT: DW_AT_decl_line
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4] (cu + 0x{{[a-f0-9]+}} => {0x[[SPACE0:[a-f0-9]+]]} "int *")

; CHECK:      DW_AT_name {{.*}}"FuncVar1"
; CHECK-NEXT: DW_AT_decl_file
; CHECK-NEXT: DW_AT_decl_line
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4] (cu + 0x{{[a-f0-9]+}} => {0x[[SPACE1:[a-f0-9]+]]} "int &")

; CHECK:      DW_AT_name {{.*}}"FuncVar2"
; CHECK-NEXT: DW_AT_decl_file
; CHECK-NEXT: DW_AT_decl_line
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4] (cu + 0x{{[a-f0-9]+}} => {0x[[SPACE2:[a-f0-9]+]]} "int &&")

; CHECK:      0x[[SPACE0]]: DW_TAG_pointer_type
; CHECK-NEXT:                 DW_AT_type
; CHECK-NEXT:                 DW_AT_address_class [DW_FORM_data4] (0x00000000)

; CHECK:      0x[[SPACE1]]: DW_TAG_reference_type
; CHECK-NEXT:                 DW_AT_type
; CHECK-NEXT:                 DW_AT_address_class [DW_FORM_data4] (0x00000001)

; CHECK:      0x[[SPACE2]]: DW_TAG_rvalue_reference_type
; CHECK-NEXT:                 DW_AT_type
; CHECK-NEXT:                 DW_AT_address_class [DW_FORM_data4] (0x00000002)

define void @_Z4funcv() !dbg !6 {
entry:
  %FuncVar0 = alloca i32*, align 8
  %FuncVar1 = alloca i32*, align 8
  %FuncVar2 = alloca i32*, align 8
  %ref.tmp = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32** %FuncVar0, metadata !9, metadata !12), !dbg !13
  call void @llvm.dbg.declare(metadata i32** %FuncVar1, metadata !14, metadata !12), !dbg !16
  %0 = load i32*, i32** %FuncVar0, align 8, !dbg !17
  store i32* %0, i32** %FuncVar1, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i32** %FuncVar2, metadata !18, metadata !12), !dbg !20
  store i32 0, i32* %ref.tmp, align 4, !dbg !21
  store i32* %ref.tmp, i32** %FuncVar2, align 8, !dbg !20
  ret void, !dbg !22
}

declare void @llvm.dbg.declare(metadata, metadata, metadata)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}
!llvm.ident = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 5.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "dwarf-test.cpp", directory: "/tmp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 5.0.0"}
!6 = distinct !DISubprogram(name: "func", linkageName: "_Z4funcv", scope: !1, file: !1, line: 2, type: !7, isLocal: false, isDefinition: true, scopeLine: 2, flags: DIFlagPrototyped, isOptimized: false, unit: !0)
!7 = !DISubroutineType(types: !8)
!8 = !{null}
!9 = !DILocalVariable(name: "FuncVar0", scope: !6, file: !1, line: 3, type: !10)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64, dwarfAddressSpace: 0)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIExpression()
!13 = !DILocation(line: 3, column: 8, scope: !6)
!14 = !DILocalVariable(name: "FuncVar1", scope: !6, file: !1, line: 4, type: !15)
!15 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !11, size: 64, dwarfAddressSpace: 1)
!16 = !DILocation(line: 4, column: 8, scope: !6)
!17 = !DILocation(line: 4, column: 20, scope: !6)
!18 = !DILocalVariable(name: "FuncVar2", scope: !6, file: !1, line: 5, type: !19)
!19 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !11, size: 64, dwarfAddressSpace: 2)
!20 = !DILocation(line: 5, column: 9, scope: !6)
!21 = !DILocation(line: 5, column: 20, scope: !6)
!22 = !DILocation(line: 6, column: 1, scope: !6)
