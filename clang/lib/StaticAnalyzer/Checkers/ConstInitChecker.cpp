// ==-- ConstInitChecker.cpp -------------------------*- C++ -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// TODO: desc
//
//===----------------------------------------------------------------------===//

#include "clang/StaticAnalyzer/Checkers/BuiltinCheckerRegistration.h"
#include "clang/AST/StmtVisitor.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/StaticAnalyzer/Core/BugReporter/BugReporter.h"
#include "clang/StaticAnalyzer/Core/Checker.h"
#include "clang/StaticAnalyzer/Core/CheckerManager.h"
#include "clang/StaticAnalyzer/Core/PathSensitive/AnalysisManager.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/Support/raw_ostream.h"

using namespace clang;
using namespace ento;
using namespace ast_matchers;

namespace {

class ConstInitChecker : public Checker<check::ASTCodeBody> {
public:
  void checkASTCodeBody(const Decl *D, AnalysisManager &mgr,
                        BugReporter &BR) const;
};

auto matchSelfAddrInInit() -> decltype(decl()) {
  auto DeclRefM = declRefExpr(to(varDecl().bind("x")));
  auto AddrXM = unaryOperator(
                    hasOperatorName("&"),
                    hasUnaryOperand(DeclRefM)).bind("addr");
  auto DeclXAddrM = varDecl(
      hasType(qualType(isConstQualified())),
      hasDescendant(AddrXM),
      equalsBoundNode("x"));
  auto DeclCheck = traverse(
      TK_AsIs,
      stmt(declStmt(has(DeclXAddrM))));

  return decl(forEachDescendant(DeclCheck));
}

auto matchCallInInit() -> decltype(decl()) {
  auto DeclRefM = declRefExpr(to(varDecl().bind("x")));
  auto AddrXM = unaryOperator(
                    hasOperatorName("&"),
                    hasUnaryOperand(DeclRefM)).bind("addr");

  auto FunCall = callExpr(hasDescendant(AddrXM)).bind("callexpr");
  auto DeclXAddrM = varDecl(
      hasType(qualType(isConstQualified())),
      hasDescendant(FunCall),
      equalsBoundNode("x"));

  auto DeclCheck = traverse(
      TK_AsIs,
      stmt(declStmt(has(DeclXAddrM))));

  return decl(forEachDescendant(DeclCheck));
}

auto matchDiscardConstInInit() -> decltype(decl()) {
  auto DeclRefM = declRefExpr(to(varDecl().bind("x")));
  auto AddrXM = unaryOperator(
                    hasOperatorName("&"),
                    hasUnaryOperand(DeclRefM)).bind("addr");

  auto DiscardConst = castExpr(
                    hasType(pointerType(unless(pointee(isConstQualified())))),
                    hasSourceExpression(AddrXM)).bind("discard-const");

  auto DeclXAddrM = varDecl(
      hasType(qualType(isConstQualified())),
      hasDescendant(DiscardConst),
      equalsBoundNode("x"));

  auto DeclCheck = traverse(
      TK_AsIs,
      stmt(declStmt(has(DeclXAddrM))));

  return decl(forEachDescendant(DeclCheck));
}

void emitDiagnostics(const UnaryOperator *AddrOp, const Decl *D,
                            bool funCall, BugReporter &BR, AnalysisManager &AM,
                            const ConstInitChecker *Checker) {
  auto *ADC = AM.getAnalysisDeclContext(D);

  auto Range = AddrOp->getSourceRange();
  auto Location =
      PathDiagnosticLocation::createBegin(AddrOp, BR.getSourceManager(), ADC);

  std::string Diagnostics;
  llvm::raw_string_ostream OS(Diagnostics);
  if (funCall)
    OS << "Address taken in function call";
  else
    OS << "Address taken";

  BR.EmitBasicReport(
      ADC->getDecl(), Checker,
      funCall ? "Variable referenced in the function call during initialization"
              : "Variable referenced in the initialization",
      "Initialization of constants", OS.str(), Location, Range);
}

void emitCastDiagnostics(const CastExpr *CE, const Decl *D,
                            BugReporter &BR, AnalysisManager &AM,
                            const ConstInitChecker *Checker) {
  auto *ADC = AM.getAnalysisDeclContext(D);

  auto Range = CE->getSourceRange();
  auto Location =
      PathDiagnosticLocation::createBegin(CE, BR.getSourceManager(), ADC);

  std::string Diagnostics;
  llvm::raw_string_ostream OS(Diagnostics);
  OS << "Const qualifier discarded";

  BR.EmitBasicReport(
      ADC->getDecl(), Checker,
      "Const qualifier discarded for variable referenced in the initialization",
      "Initialization of constants", OS.str(), Location, Range);
}

void ConstInitChecker::checkASTCodeBody(const Decl *D, AnalysisManager &AM,
                                        BugReporter &BR) const {
  ASTContext &ASTCtx = AM.getASTContext();

  auto CallMatcherM = matchCallInInit();
  auto MatchesFunCall = match(CallMatcherM, *D, ASTCtx);
  for (const auto &Match : MatchesFunCall) {
    if (const UnaryOperator *UO = Match.getNodeAs<UnaryOperator>("addr")) {
      emitDiagnostics(UO, D, true, BR, AM, this);
    }
  }

  auto CastMatcherM = matchDiscardConstInInit();
  auto MatchesDiscardConst = match(CastMatcherM, *D, ASTCtx);
  for (const auto &Match : MatchesDiscardConst) {
    if (const CastExpr *CE = Match.getNodeAs<CastExpr>("discard-const")) {
      emitCastDiagnostics(CE, D, BR, AM, this);
    }
  }

  auto AddrMatcherM = matchSelfAddrInInit();
  auto MatchesAddr = match(AddrMatcherM, *D, ASTCtx);
  for (const auto &Match : MatchesAddr) {
    if (const UnaryOperator *UO = Match.getNodeAs<UnaryOperator>("addr")) {
      emitDiagnostics(UO, D, false, BR, AM, this);
    }
  }
}

} // namespace

void ento::registerConstInitChecker(CheckerManager &mgr) {
  mgr.registerChecker<ConstInitChecker>();
}

bool ento::shouldRegisterConstInitChecker(
    const CheckerManager &mgr) {
  return true;
}