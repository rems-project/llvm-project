// RUN: %clang_cc1 -triple aarch64-none--elf --std=c++11 -emit-llvm -debug-info-kind=limited -target-feature +morello -o - %s \
// RUN:   | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-HYBRID
// RUN: %clang_cc1 -triple aarch64-none--elf --std=c++11 -emit-llvm -debug-info-kind=limited -target-feature +c64 -target-abi purecap -o - %s \
// RUN:   | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-PUREABI
// RUN: %clang_cc1 -triple aarch64-none--elf --std=c++11 -emit-llvm -debug-info-kind=limited -target-feature +morello -target-feature +c64 -target-abi purecap -o - %s \
// RUN:   | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-PUREABI
// RUN: %clang_cc1 -triple aarch64-none--elf --std=c++11 -emit-llvm -debug-info-kind=limited -target-feature +morello \
// RUN:            -mllvm -cheri-cap-table-abi=pcrel  -target-feature +c64 -target-abi purecap -o - %s \
// RUN:   | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-PUREABI

// Check the following properties connected to the use of CHERI capability types
// on AArch64:
// * Pointers and references are produced with the right dwarfAddressSpace
//   values. The value should be omitted if the type is a normal
//   pointer/reference and equal to 1 for capabilities.
// * Variables with a type that has dwarfAddressSpace do not use extended
//   dereferencing mechanism (DW_OP_xderef).
// * Types intcap_t and uintcap_t use the DW_ATE_CHERI_signed_intcap and
//   DW_ATE_CHERI_unsigned_intcap encodings, respectively.

char *pointer;
char &reference = *pointer;
char &&rvalue_reference = 0;
char *__capability always_capability_pointer;
char &__capability always_capability_reference = *always_capability_pointer;
char &&__capability always_capability_rvalue_reference = 0;

// CHECK-HYBRID-DAG: [[DWARF_SIMPLE_POINTER:![0-9]+]] = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !{{[0-9]+}}, size: 64)
// CHECK-HYBRID-DAG: [[DWARF_SIMPLE_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !{{[0-9]+}}, size: 64)
// CHECK-HYBRID-DAG: [[DWARF_SIMPLE_RVALUE_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !{{[0-9]+}}, size: 64)
// CHECK-HYBRID-DAG: [[DWARF_CAPABILITY_POINTER:![0-9]+]] = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
// CHECK-HYBRID-DAG: [[DWARF_CAPABILITY_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
// CHECK-HYBRID-DAG: [[DWARF_CAPABILITY_RVALUE_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
//
// CHECK-HYBRID-DAG: [[POINTER_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "pointer", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_SIMPLE_POINTER]], isLocal: false, isDefinition: true)
// CHECK-HYBRID-DAG: [[REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_SIMPLE_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-HYBRID-DAG: [[RVALUE_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "rvalue_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_SIMPLE_RVALUE_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-HYBRID-DAG: [[ALWAYS_CAPABILITY_POINTER_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_pointer", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_POINTER]], isLocal: false, isDefinition: true)
// CHECK-HYBRID-DAG: [[ALWAYS_CAPABILITY_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-HYBRID-DAG: [[ALWAYS_CAPABILITY_RVALUE_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_rvalue_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_RVALUE_REFERENCE]], isLocal: false, isDefinition: true)
//
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[POINTER_VAR]], expr: !DIExpression())
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[REFERENCE_VAR]], expr: !DIExpression())
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[RVALUE_REFERENCE_VAR]], expr: !DIExpression())
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_POINTER_VAR]], expr: !DIExpression())
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_REFERENCE_VAR]], expr: !DIExpression())
// CHECK-HYBRID-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_RVALUE_REFERENCE_VAR]], expr: !DIExpression())

// CHECK-PUREABI-DAG: [[DWARF_CAPABILITY_POINTER:![0-9]+]] = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
// CHECK-PUREABI-DAG: [[DWARF_CAPABILITY_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
// CHECK-PUREABI-DAG: [[DWARF_CAPABILITY_RVALUE_REFERENCE:![0-9]+]] = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !{{[0-9]+}}, size: 128, dwarfAddressSpace: 1)
//
// CHECK-PUREABI-DAG: [[POINTER_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "pointer", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_POINTER]], isLocal: false, isDefinition: true)
// CHECK-PUREABI-DAG: [[REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-PUREABI-DAG: [[RVALUE_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "rvalue_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_RVALUE_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-PUREABI-DAG: [[ALWAYS_CAPABILITY_POINTER_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_pointer", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_POINTER]], isLocal: false, isDefinition: true)
// CHECK-PUREABI-DAG: [[ALWAYS_CAPABILITY_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_REFERENCE]], isLocal: false, isDefinition: true)
// CHECK-PUREABI-DAG: [[ALWAYS_CAPABILITY_RVALUE_REFERENCE_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "always_capability_rvalue_reference", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[DWARF_CAPABILITY_RVALUE_REFERENCE]], isLocal: false, isDefinition: true)
//
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[POINTER_VAR]], expr: !DIExpression())
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[REFERENCE_VAR]], expr: !DIExpression())
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[RVALUE_REFERENCE_VAR]], expr: !DIExpression())
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_POINTER_VAR]], expr: !DIExpression())
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_REFERENCE_VAR]], expr: !DIExpression())
// CHECK-PUREABI-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[ALWAYS_CAPABILITY_RVALUE_REFERENCE_VAR]], expr: !DIExpression())

__intcap_t intcap;
__uintcap_t uintcap;

// CHECK-DAG: [[INTCAP_BASETYPE:![0-9]+]] = !DIBasicType(name: "__intcap", size: 128, encoding: DW_ATE_CHERI_signed_intcap)
// CHECK-DAG: [[UINTCAP_BASETYPE:![0-9]+]] = !DIBasicType(name: "unsigned __intcap", size: 128, encoding: DW_ATE_CHERI_unsigned_intcap)
//
// CHECK-DAG: [[INTCAP_TYPEDEF:![0-9]+]] = !DIDerivedType(tag: DW_TAG_typedef, name: "__intcap_t", file: !{{[0-9]+}}, line: {{[0-9]+}}, baseType: [[INTCAP_BASETYPE]])
// CHECK-DAG: [[UINTCAP_TYPEDEF:![0-9]+]] = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintcap_t", file: !{{[0-9]+}}, line: {{[0-9]+}}, baseType: [[UINTCAP_BASETYPE]])
//
// CHECK-DAG: [[INTCAP_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "intcap", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[INTCAP_TYPEDEF]], isLocal: false, isDefinition: true)
// CHECK-DAG: [[UINTCAP_VAR:![0-9]+]] = distinct !DIGlobalVariable(name: "uintcap", scope: !{{[0-9]+}}, file: !{{[0-9]+}}, line: {{[0-9]+}}, type: [[UINTCAP_TYPEDEF]], isLocal: false, isDefinition: true)
//
// CHECK-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[INTCAP_VAR]], expr: !DIExpression())
// CHECK-DAG: !{{[0-9]+}} = !DIGlobalVariableExpression(var: [[UINTCAP_VAR]], expr: !DIExpression())
