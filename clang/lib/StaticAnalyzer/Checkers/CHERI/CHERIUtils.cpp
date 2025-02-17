//===-- CHERIUtils.h  -------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "CHERIUtils.h"
#include <clang/StaticAnalyzer/Core/PathSensitive/ProgramState.h>

#include "clang/StaticAnalyzer/Core/PathSensitive/ProgramStateTrait.h"


namespace clang {
namespace ento {
namespace cheri {

bool isPureCapMode(const ASTContext &C) {
  return C.getTargetInfo().areAllPointersCapabilities();
}

bool isPointerToCapTy(const QualType Type, ASTContext &Ctx) {
  if (!Type->isPointerType())
    return false;
  return Type->getPointeeType()->isCHERICapabilityType(Ctx, true);
}

CharUnits getCapabilityTypeSize(ASTContext &ASTCtx) {
  return ASTCtx.getTypeSizeInChars(ASTCtx.VoidPtrTy);
}

CharUnits getCapabilityTypeAlign(ASTContext &ASTCtx) {
  return ASTCtx.getTypeAlignInChars(ASTCtx.VoidPtrTy);
}

bool isGenericPointerType(const QualType T, bool AcceptCharPtr) {
  return T->isVoidPointerType() || (AcceptCharPtr && T->isPointerType() &&
                                    T->getPointeeType()->isCharType());
}

bool hasCapability(const QualType OrigTy, ASTContext &Ctx) {
  QualType Ty = OrigTy.getCanonicalType();
  if (Ty->isCHERICapabilityType(Ctx, true))
    return true;
  if (const auto *Record = dyn_cast<RecordType>(Ty)) {
    for (const auto *Field : Record->getDecl()->fields()) {
      if (hasCapability(Field->getType(), Ctx))
        return true;
    }
    return false;
  }
  if (const auto *Array = dyn_cast<ArrayType>(Ty)) {
    return hasCapability(Array->getElementType(), Ctx);
  }
  return false;
}

namespace {

void printType(raw_ostream &OS, const QualType &Ty, const PrintingPolicy &PP) {
  std::string TyStr = Ty.getAsString(PP);
  OS << "'" << TyStr << "'";
  std::string CanTyStr = Ty.getCanonicalType().getAsString(PP);
  if (CanTyStr != TyStr) {
    OS << " (aka '" << CanTyStr << "')";
  }
}

} // namespace

void describeCast(raw_ostream &OS, const CastExpr *CE,
                  const LangOptions &LangOpts) {
  const PrintingPolicy &PP = PrintingPolicy(LangOpts);
  OS << (dyn_cast<ImplicitCastExpr>(CE) ? "implicit" : "explicit");
  OS << " cast from ";
  printType(OS, CE->getSubExpr()->getType(), PP);
  OS << " to ";
  printType(OS, CE->getType(), PP);
}

const DeclRegion *getAllocationDecl(const MemRegion *MR) {
  if (const DeclRegion *DR = MR->getAs<DeclRegion>())
    return DR;
  if (const ElementRegion *ER = MR->getAs<ElementRegion>())
    return getAllocationDecl(ER->getSuperRegion());
  return nullptr;
}

} // namespace cheri
} // namespace ento
} // namespace clang