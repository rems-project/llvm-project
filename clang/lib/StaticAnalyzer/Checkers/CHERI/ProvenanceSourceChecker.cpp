//===-- ProvenanceSourceChecker.cpp - Provenance Source Checker -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines checker that detects binary arithmetic expressions with
// capability type operands where provenance source is ambiguous.
//
//===----------------------------------------------------------------------===//

#include "CHERIUtils.h"
#include <clang/Basic/DiagnosticSema.h>
#include "clang/StaticAnalyzer/Checkers/BuiltinCheckerRegistration.h"
#include <clang/StaticAnalyzer/Core/BugReporter/BugReporter.h>
#include "clang/StaticAnalyzer/Core/Checker.h"
#include "clang/StaticAnalyzer/Core/CheckerManager.h"
#include "clang/StaticAnalyzer/Core/PathSensitive/CheckerContext.h"


using namespace clang;
using namespace ento;
using namespace cheri;

namespace {
class ProvenanceSourceChecker : public Checker<check::PostStmt<CastExpr>,
                                               check::PreStmt<CastExpr>,
                                               check::PostStmt<BinaryOperator>,
                                               check::PostStmt<UnaryOperator>,
                                               check::DeadSymbols> {
  BugType AmbigProvBinOpBugType{this,
                  "Binary operation with ambiguous provenance",
                  "CHERI portability"};
  BugType AmbigProvAddrArithBugType{this,
                  "CHERI-incompatible pointer arithmetic",
                  "CHERI portability"};
  BugType AmbigProvWrongOrderBugType{this,
                  "Capability derived from wrong argument",
                  "CHERI portability"};

  BugType AmbigProvAsPtrBugType{this,
                  "Capability with ambiguous provenance used as pointer",
                  "CHERI portability"};
  BugType InvalidCapPtrBugType{this,
                  "NULL-derived capability used as pointer",
                  "CHERI portability"};
  BugType ProvenanceLossBugType{this,
                   "NULL-derived capability: loss of provenance",
                   "CHERI portability"};
  
private:
  class InvalidCapBugVisitor : public BugReporterVisitor {
  public:
    InvalidCapBugVisitor(SymbolRef SR) : Sym(SR) {}

    void Profile(llvm::FoldingSetNodeID &ID) const override {
      static int X = 0;
      ID.AddPointer(&X);
      ID.AddPointer(Sym);
    }

    PathDiagnosticPieceRef VisitNode(const ExplodedNode *N,
                                     BugReporterContext &BRC,
                                     PathSensitiveBugReport &BR) override;
  private:
    SymbolRef Sym;
  };

  class Ptr2IntBugVisitor : public BugReporterVisitor {
  public:
    Ptr2IntBugVisitor(const MemRegion *R) : Reg(R) {}

    void Profile(llvm::FoldingSetNodeID &ID) const override {
      static int X = 0;
      ID.AddPointer(&X);
      ID.AddPointer(Reg);
    }

    PathDiagnosticPieceRef VisitNode(const ExplodedNode *N,
                                     BugReporterContext &BRC,
                                     PathSensitiveBugReport &BR) override;
  private:
    const MemRegion *Reg;
  };

public:
  void checkPostStmt(const CastExpr *CE, CheckerContext &C) const;
  void checkPreStmt(const CastExpr *CE, CheckerContext &C) const;
  void checkPostStmt(const BinaryOperator *BO, CheckerContext &C) const;
  void checkPostStmt(const UnaryOperator *BO, CheckerContext &C) const;
  void checkDeadSymbols(SymbolReaper &SymReaper, CheckerContext &C) const;

  bool ShowFixIts = false;
  bool ReportForAmbiguousProvenance = true;

private:
  // Utility
  const BugType &explainWarning(const BinaryOperator *BO, CheckerContext &C,
                                bool LHSIsAddr, bool LHSIsNullDerived,
                                bool RHSIsAddr, bool RHSIsNullDerived,
                                raw_ostream &OS) const;

  ExplodedNode *emitAmbiguousProvenanceWarn(const BinaryOperator *BO,
                                            CheckerContext &C, bool LHSIsAddr,
                                            bool LHSIsNullDerived,
                                            bool RHSIsAddr,
                                            bool RHSIsNullDerived) const;

  static void propagateProvenanceInfo(ExplodedNode *N,
                                              const Expr *E,
                                              CheckerContext &C,
                                              bool IsInvalidCap,
                                              const NoteTag* Tag);
};
} // namespace

REGISTER_SET_WITH_PROGRAMSTATE(InvalidCap, SymbolRef)
REGISTER_SET_WITH_PROGRAMSTATE(AmbiguousProvenanceSym, SymbolRef)
REGISTER_SET_WITH_PROGRAMSTATE(AmbiguousProvenanceReg, const MemRegion *)
REGISTER_TRAIT_WITH_PROGRAMSTATE(Ptr2IntCapId, unsigned)

namespace {
bool isIntegerToIntCapCast(const CastExpr *CE) {
  if (CE->getCastKind() != CK_IntegralCast)
    return false;
  if (!CE->getType()->isIntCapType() ||
      CE->getSubExpr()->getType()->isIntCapType())
    return false;
  return true;
}

bool isPointerToIntegerCast(const CastExpr *CE) {
  if (CE->getCastKind() != CK_PointerToIntegral)
    return false;
  if (CE->getType()->isIntCapType())
    return false;
  return true;
}

bool isPointerToIntCapCast(const CastExpr *CE) {
  if (CE->getCastKind() != clang::CK_PointerToIntegral)
    return false;
  if (!CE->getType()->isIntCapType())
    return false;
  return true;
}

} // namespace

void ProvenanceSourceChecker::checkPostStmt(const CastExpr *CE,
                                            CheckerContext &C) const {
  if (!isPureCapMode(C.getASTContext()))
    return;

  if (isIntegerToIntCapCast(CE)) {
    SymbolRef IntCapSym = C.getSVal(CE).getAsSymbol();
    if (!IntCapSym)
      return;

    if (C.getSVal(CE).getAsLocSymbol())
      return; // skip locAsInteger

    ProgramStateRef State = C.getState();
    State = State->add<InvalidCap>(IntCapSym);
    C.addTransition(State);
  } else if (isPointerToIntCapCast(CE)) {
    // Prev node may be reclaimed as "uninteresting", in this case we will not
    // be able to create path diagnostic for it; therefore we modify the state,
    // i.e. create the node that definitely will not be deleted
    ProgramStateRef const State = C.getState();
    C.addTransition(State->set<Ptr2IntCapId>(State->get<Ptr2IntCapId>() + 1));
  }
}

namespace {

bool hasAmbiguousProvenance(ProgramStateRef State, const SVal &Val) {
  if (SymbolRef Sym = Val.getAsSymbol())
    return State->contains<AmbiguousProvenanceSym>(Sym);

  if (const MemRegion *Reg = Val.getAsRegion())
    return State->contains<AmbiguousProvenanceReg>(Reg);

  return false;
}

bool hasNoProvenance(ProgramStateRef State, const SVal &Val) {
  if (Val.isConstant())
    return true;

  if (const auto &LocAsInt = Val.getAs<nonloc::LocAsInteger>())
    return !LocAsInt->hasProvenance();

  SymbolRef Sym = Val.getAsSymbol();
  if (Sym && State->contains<InvalidCap>(Sym))
    return true;
  return false;
}

bool isAddress(const SVal &Val) {
  if (!Val.getAsLocSymbol(true))
    return false;

  if (const auto &LocAsInt = Val.getAs<nonloc::LocAsInteger>())
    return LocAsInt->hasProvenance();

  return true;
}

bool isNoProvToPtrCast(const CastExpr *CE) {
  if (!CE->getType()->isPointerType())
    return false;

  const Expr *Src = CE->getSubExpr();
  return Src->getType()->hasAttr(attr::CHERINoProvenance);
}

} // namespace

// Report intcap with ambiguous or NULL-derived provenance cast to pointer
void ProvenanceSourceChecker::checkPreStmt(const CastExpr *CE,
                                           CheckerContext &C) const {
  if (!isPureCapMode(C.getASTContext()))
    return;

  if (CE->getCastKind() != clang::CK_IntegralToPointer)
    return;

  ProgramStateRef const State = C.getState();
  const SVal &SrcVal = C.getSVal(CE->getSubExpr());

  std::unique_ptr<PathSensitiveBugReport> R;
  if (hasAmbiguousProvenance(State, SrcVal)) {
    ExplodedNode *ErrNode = C.generateNonFatalErrorNode();
    if (!ErrNode)
      return;
    R = std::make_unique<PathSensitiveBugReport>(
        AmbigProvAsPtrBugType,
        "Capability with ambiguous provenance is used as pointer", ErrNode);
  } else if (hasNoProvenance(State, SrcVal) && !SrcVal.isConstant()) {
    if (isNoProvToPtrCast(CE))
      return; // intentional
    ExplodedNode *ErrNode = C.generateNonFatalErrorNode();
    if (!ErrNode)
      return;
    if (SrcVal.getAs<nonloc::LocAsInteger>())
      R = std::make_unique<PathSensitiveBugReport>(
          ProvenanceLossBugType, "NULL-derived capability: loss of provenance",
          ErrNode);
    else
      R = std::make_unique<PathSensitiveBugReport>(
          InvalidCapPtrBugType, "NULL-derived capability used as pointer",
          ErrNode);
    if (SymbolRef S = SrcVal.getAsSymbol())
      R->addVisitor(std::make_unique<InvalidCapBugVisitor>(S));
  } else
    return;

  R->markInteresting(SrcVal);
  R->addRange(CE->getSourceRange());
  C.emitReport(std::move(R));
}

namespace {

bool justConverted2IntCap(Expr *E, const ASTContext &Ctx) {
  assert(E->getType()->isCHERICapabilityType(Ctx, true));
  if (auto *CE = dyn_cast<CastExpr>(E)) {
    const QualType OrigType = CE->getSubExpr()->getType();
    if (!OrigType->isCHERICapabilityType(Ctx, true))
      return true;
  }
  return false;
}

FixItHint addFixIt(const Expr *NDOp, CheckerContext &C, bool IsUnsigned) {
  const SourceRange &SrcRange = NDOp->getSourceRange();
  bool InValidStr = true;
  const StringRef &OpStr =
      Lexer::getSourceText(CharSourceRange::getTokenRange(SrcRange),
                           C.getSourceManager(), C.getLangOpts(), &InValidStr);
  if (!InValidStr) {
    return FixItHint::CreateReplacement(SrcRange,
        (IsUnsigned ? "(size_t)(" : "(ptrdiff_t)(") + OpStr.str() + ")");
  }
  return {};
}

bool isArith(BinaryOperatorKind OpCode) {
  if (BinaryOperator::isCompoundAssignmentOp(OpCode))
    return isArith(BinaryOperator::getOpForCompoundAssignment(OpCode));
  return BinaryOperator::isAdditiveOp(OpCode) ||
         BinaryOperator::isMultiplicativeOp(OpCode) ||
         BinaryOperator::isBitwiseOp(OpCode);
}

} // namespace

const BugType &ProvenanceSourceChecker::explainWarning(
    const BinaryOperator *BO, CheckerContext &C, bool LHSIsAddr,
    bool LHSIsNullDerived, bool RHSIsAddr, bool RHSIsNullDerived,
    raw_ostream &OS) const {
  OS << "Result of '"<< BO->getOpcodeStr() << "' on capability type '";
  BO->getType().print(OS, PrintingPolicy(C.getASTContext().getLangOpts()));
  OS << "'; it is unclear which side should be used as the source of "
        "provenance";

  if (RHSIsAddr) {
    OS << ". Note: along this path, ";
    if (LHSIsAddr) {
      OS << "LHS and RHS were derived from pointers."
            " Result capability will be derived from LHS by default."
            " This code may need to be rewritten for CHERI.";
      return AmbigProvAddrArithBugType;
    }

    if (LHSIsNullDerived) {
      OS << "LHS was derived from NULL, RHS was derived from pointer."
            " Currently, provenance is inherited from LHS,"
            " therefore result capability will be invalid.";
    } else { // unknown LHS provenance
      OS << "RHS was derived from pointer."
            " Currently, provenance is inherited from LHS."
            " Consider indicating the provenance-carrying argument "
            " explicitly by casting the other argument to '"
         << (BO->getType()->isUnsignedIntegerType() ? "size_t" : "ptrdiff_t")
         << "'. ";
    }
    return AmbigProvWrongOrderBugType;
  }

  OS << "; consider indicating the provenance-carrying argument "
        "explicitly by casting the other argument to '"
     << (BO->getType()->isUnsignedIntegerType() ? "size_t" : "ptrdiff_t")
     << "'. Note: along this path, ";

  if (LHSIsNullDerived && RHSIsNullDerived) {
    OS << "LHS and RHS were derived from NULL";
  } else {
    if (LHSIsAddr)
      OS << "LHS was derived from pointer";
    if (LHSIsNullDerived)
      OS << "LHS was derived from NULL";
    if (RHSIsNullDerived) {
      if (LHSIsAddr || LHSIsNullDerived)
        OS << ", ";
      OS << "RHS was derived from NULL";
    }
  }

  return AmbigProvBinOpBugType;
}

ExplodedNode *ProvenanceSourceChecker::emitAmbiguousProvenanceWarn(
    const BinaryOperator *BO, CheckerContext &C,
    bool LHSIsAddr, bool LHSIsNullDerived,
    bool RHSIsAddr, bool RHSIsNullDerived) const {

  bool const IsUnsigned = BO->getType()->isUnsignedIntegerType();
  SmallString<350> ErrorMessage;
  llvm::raw_svector_ostream OS(ErrorMessage);

  const BugType &BT = explainWarning(BO, C, LHSIsAddr, LHSIsNullDerived,
                                     RHSIsAddr, RHSIsNullDerived, OS);

  // Generate the report.
  ExplodedNode *ErrNode = C.generateNonFatalErrorNode();
  if (!ErrNode)
    return nullptr;
  auto R = std::make_unique<PathSensitiveBugReport>(BT, ErrorMessage, ErrNode);
  R->addRange(BO->getSourceRange());

  if (ShowFixIts) {
    if ((LHSIsAddr && RHSIsNullDerived) || (LHSIsNullDerived && RHSIsAddr)) {
        const Expr *NDOp = LHSIsNullDerived ? BO->getLHS() : BO->getRHS();
        const FixItHint &Fixit = addFixIt(NDOp, C, IsUnsigned);
        if (!Fixit.isNull())
          R->addFixItHint(Fixit);
      }
  }

  const SVal &LHSVal = C.getSVal(BO->getLHS());
  R->markInteresting(LHSVal);
  if (SymbolRef LS = LHSVal.getAsSymbol())
    R->addVisitor(std::make_unique<InvalidCapBugVisitor>(LS));
  if (const MemRegion *Reg = LHSVal.getAsRegion())
    R->addVisitor(std::make_unique<Ptr2IntBugVisitor>(Reg));

  const SVal &RHSVal = C.getSVal(BO->getRHS());
  R->markInteresting(RHSVal);
  if (SymbolRef RS = RHSVal.getAsSymbol())
    R->addVisitor(std::make_unique<InvalidCapBugVisitor>(RS));
  if (const MemRegion *Reg = RHSVal.getAsRegion())
    R->addVisitor(std::make_unique<Ptr2IntBugVisitor>(Reg));

  C.emitReport(std::move(R));
  return ErrNode;
}

void ProvenanceSourceChecker::propagateProvenanceInfo(
    ExplodedNode *N, const Expr *E, CheckerContext &C,
    bool IsInvalidCap, const NoteTag* Tag) {

  ProgramStateRef State = N->getState();
  SVal ResVal = C.getSVal(E);
  if (ResVal.isUnknown()) {
    const LocationContext *LCtx = C.getLocationContext();
    ResVal = C.getSValBuilder().conjureSymbolVal(
        nullptr, E, LCtx, E->getType(), C.blockCount());
    State = State->BindExpr(E, LCtx, ResVal);
  }

  if (SymbolRef ResSym = ResVal.getAsSymbol())
    State = IsInvalidCap ? State->add<InvalidCap>(ResSym)
                         : State->add<AmbiguousProvenanceSym>(ResSym);
  else if (const MemRegion *Reg = ResVal.getAsRegion())
    State = State->add<AmbiguousProvenanceReg>(Reg);
  else
    return; // no result to propagate to

  C.addTransition(State, N, Tag);
}

// Report intcap binary expressions with ambiguous provenance,
// store them to report again if used as pointer
void ProvenanceSourceChecker::checkPostStmt(const BinaryOperator *BO,
                                            CheckerContext &C) const {
  if (!isPureCapMode(C.getASTContext()))
    return;

  BinaryOperatorKind const OpCode = BO->getOpcode();
  if (!isArith(OpCode))
    return;
  bool const IsSub = OpCode == clang::BO_Sub || OpCode == clang::BO_SubAssign;

  Expr *LHS = BO->getLHS();
  Expr *RHS = BO->getRHS();
  if (!LHS->getType()->isIntCapType() || !RHS->getType()->isIntCapType())
    return;

  ProgramStateRef const State = C.getState();

  const SVal &LHSVal = C.getSVal(LHS);
  const SVal &RHSVal = C.getSVal(RHS);

  bool const LHSIsAddr = isAddress(LHSVal);
  bool const LHSIsNullDerived = !LHSIsAddr && hasNoProvenance(State, LHSVal);
  bool const RHSIsAddr = isAddress(RHSVal);
  bool const RHSIsNullDerived = !RHSIsAddr && hasNoProvenance(State, RHSVal);
  if (!LHSIsAddr && !LHSIsNullDerived && !RHSIsAddr && !RHSIsNullDerived)
    return;

  // Operands that were converted to intcap for this binaryOp are not used to
  // derive the provenance of the result
  // FIXME: explicit attr::CHERINoProvenance
  bool const LHSActiveProv = !justConverted2IntCap(LHS, C.getASTContext());
  bool const RHSActiveProv = !justConverted2IntCap(RHS, C.getASTContext());

  ExplodedNode *N;
  bool InvalidCap;
  if (LHSActiveProv && RHSActiveProv && !IsSub) {
    if (!RHSIsAddr && !this->ReportForAmbiguousProvenance) {
        // No strong evidence of a real bug here. This code will probably
        // be fine with the default choice of LHS for capability derivation.
        // Don't report if [-Wcheri-provenance] compiler warning is disabled
        // and don't propagate ambiguous provenance flag further
        return;
    }

    N = emitAmbiguousProvenanceWarn(BO, C, LHSIsAddr, LHSIsNullDerived,
                                      RHSIsAddr, RHSIsNullDerived);
    if (!N)
      N = C.getPredecessor();
    InvalidCap = false;
  } else if (IsSub && LHSIsAddr && RHSIsAddr) {
    N = C.getPredecessor();
    InvalidCap = true;
  } else if (LHSIsNullDerived && (RHSIsNullDerived || IsSub)) {
    N = C.getPredecessor();
    InvalidCap = true;
  } else
    return;

  // Propagate info for result
  const NoteTag *BinOpTag =
      InvalidCap ? nullptr // note will be added in BugVisitor
                   : C.getNoteTag("Binary operator has ambiguous provenance");
  propagateProvenanceInfo(N, BO, C, InvalidCap, BinOpTag);
}

void ProvenanceSourceChecker::checkPostStmt(const UnaryOperator *UO,
                                            CheckerContext &C) const {
  if (!isPureCapMode(C.getASTContext()))
    return;

  if (!UO->isArithmeticOp() && !UO->isIncrementDecrementOp())
    return;

  Expr *Op = UO->getSubExpr();
  if (!Op->getType()->isIntCapType())
    return;

  ProgramStateRef State = C.getState();
  const SVal &Val = C.getSVal(UO);
  const SVal &SrcVal = C.getSVal(Op);
  if (hasNoProvenance(State, SrcVal) && !hasNoProvenance(State, Val))
    propagateProvenanceInfo(C.getPredecessor(), UO, C, true, nullptr);
}

void ProvenanceSourceChecker::checkDeadSymbols(SymbolReaper &SymReaper,
                                               CheckerContext &C) const {
  if (!isPureCapMode(C.getASTContext()))
    return;

  ProgramStateRef State = C.getState();
  bool Removed = false;
  State = cleanDead<InvalidCap>(State, SymReaper, Removed);
  State = cleanDead<AmbiguousProvenanceSym>(State, SymReaper, Removed);
  State = cleanDead<AmbiguousProvenanceReg>(State, SymReaper, Removed);

  if (Removed)
    C.addTransition(State);
}

PathDiagnosticPieceRef
ProvenanceSourceChecker::InvalidCapBugVisitor::VisitNode(
    const ExplodedNode *N, BugReporterContext &BRC,
    PathSensitiveBugReport &BR) {

  const Stmt *S = N->getStmtForDiagnostics();
  if (!S)
    return nullptr;

  SmallString<256> Buf;
  llvm::raw_svector_ostream OS(Buf);

  if (const CastExpr *CE = dyn_cast<CastExpr>(S)) {
    if (Sym != N->getSVal(CE).getAsSymbol())
      return nullptr;
    if (isIntegerToIntCapCast(CE)) {
      if (!N->getState()->contains<InvalidCap>(Sym))
        return nullptr;
      OS << "NULL-derived capability: ";
    } else if (isPointerToIntegerCast(CE)) {
      OS << "Loss of provenance: ";
    } else
      return nullptr;
    describeCast(OS, CE, BRC.getASTContext().getLangOpts());
  } else if (const BinaryOperator *BO = dyn_cast<BinaryOperator>(S)) {
    BinaryOperatorKind const OpCode = BO->getOpcode();
    if (!(BinaryOperator::isAdditiveOp(OpCode)
          || BinaryOperator::isMultiplicativeOp(OpCode)
          || BinaryOperator::isBitwiseOp(OpCode)))
      return nullptr;
    bool const IsSub = OpCode == clang::BO_Sub || OpCode == clang::BO_SubAssign;

    if (!BO->getType()->isIntCapType() || Sym != N->getSVal(BO).getAsSymbol())
      return nullptr;

    if (!N->getState()->contains<InvalidCap>(Sym))
      return nullptr;

    OS << "Result of '" << BO->getOpcodeStr() << "'";
    if (hasNoProvenance(N->getState(), N->getSVal(BO->getLHS())) &&
        (hasNoProvenance(N->getState(), N->getSVal(BO->getRHS())) || IsSub))
      OS << " is a NULL-derived capability";
    else
      OS << " is an invalid capability";
  } else
    return nullptr;

  // Generate the extra diagnostic.
  PathDiagnosticLocation const Pos(S, BRC.getSourceManager(),
                                   N->getLocationContext());
  return std::make_shared<PathDiagnosticEventPiece>(Pos, OS.str(), true);
}

PathDiagnosticPieceRef
ProvenanceSourceChecker::Ptr2IntBugVisitor::VisitNode(
    const ExplodedNode *N, BugReporterContext &BRC,
    PathSensitiveBugReport &BR) {

  const Stmt *S = N->getStmtForDiagnostics();
  if (!S)
    return nullptr;

  const CastExpr *CE = dyn_cast<CastExpr>(S);
  if (!CE || !isPointerToIntCapCast(CE))
    return nullptr;

  if (Reg != N->getSVal(CE).getAsRegion())
    return nullptr;

  SmallString<256> Buf;
  llvm::raw_svector_ostream OS(Buf);
  OS << "Capability derived from pointer: ";
  describeCast(OS, CE, BRC.getASTContext().getLangOpts());

  // Generate the extra diagnostic.
  PathDiagnosticLocation const Pos(S, BRC.getSourceManager(),
                                   N->getLocationContext());
  return std::make_shared<PathDiagnosticEventPiece>(Pos, OS.str(), true);
}

void ento::registerProvenanceSourceChecker(CheckerManager &mgr) {
  auto *Checker = mgr.registerChecker<ProvenanceSourceChecker>();
  Checker->ShowFixIts = mgr.getAnalyzerOptions().getCheckerBooleanOption(
      Checker, "ShowFixIts");
  Checker->ReportForAmbiguousProvenance =
      mgr.getAnalyzerOptions().getCheckerBooleanOption(
          Checker, "ReportForAmbiguousProvenance");
}

bool ento::shouldRegisterProvenanceSourceChecker(const CheckerManager &Mgr) {
  return true;
}
