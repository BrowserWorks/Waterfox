/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef frontend_ParseContext_h
#define frontend_ParseContext_h

#include "ds/Nestable.h"
#include "frontend/BytecodeCompiler.h"
#include "frontend/CompilationInfo.h"
#include "frontend/ErrorReporter.h"
#include "frontend/NameCollections.h"
#include "frontend/SharedContext.h"
#include "frontend/UsedNameTracker.h"
#include "vm/GeneratorAndAsyncKind.h"  // js::GeneratorKind, js::FunctionAsyncKind

namespace js {

namespace frontend {

class ParserBase;

const char* DeclarationKindString(DeclarationKind kind);

// Returns true if the declaration is `var` or equivalent.
bool DeclarationKindIsVar(DeclarationKind kind);

bool DeclarationKindIsParameter(DeclarationKind kind);

/*
 * The struct ParseContext stores information about the current parsing context,
 * which is part of the parser state (see the field Parser::pc). The current
 * parsing context is either the global context, or the function currently being
 * parsed. When the parser encounters a function definition, it creates a new
 * ParseContext, makes it the new current context.
 */
class ParseContext : public Nestable<ParseContext> {
 public:
  // The intra-function statement stack.
  //
  // Used for early error checking that depend on the nesting structure of
  // statements, such as continue/break targets, labels, and unbraced
  // lexical declarations.
  class Statement : public Nestable<Statement> {
    StatementKind kind_;

   public:
    using Nestable<Statement>::enclosing;
    using Nestable<Statement>::findNearest;

    Statement(ParseContext* pc, StatementKind kind)
        : Nestable<Statement>(&pc->innermostStatement_), kind_(kind) {}

    template <typename T>
    inline bool is() const;
    template <typename T>
    inline T& as();

    StatementKind kind() const { return kind_; }

    void refineForKind(StatementKind newForKind) {
      MOZ_ASSERT(kind_ == StatementKind::ForLoop);
      MOZ_ASSERT(newForKind == StatementKind::ForInLoop ||
                 newForKind == StatementKind::ForOfLoop);
      kind_ = newForKind;
    }
  };

  class LabelStatement : public Statement {
    RootedAtom label_;

   public:
    LabelStatement(ParseContext* pc, JSAtom* label)
        : Statement(pc, StatementKind::Label), label_(pc->sc_->cx_, label) {}

    HandleAtom label() const { return label_; }
  };

  struct ClassStatement : public Statement {
    FunctionBox* constructorBox;

    explicit ClassStatement(ParseContext* pc)
        : Statement(pc, StatementKind::Class), constructorBox(nullptr) {}
  };

  // The intra-function scope stack.
  //
  // Tracks declared and used names within a scope.
  class Scope : public Nestable<Scope> {
    // Names declared in this scope. Corresponds to the union of
    // VarDeclaredNames and LexicallyDeclaredNames in the ES spec.
    //
    // A 'var' declared name is a member of the declared name set of every
    // scope in its scope contour.
    //
    // A lexically declared name is a member only of the declared name set of
    // the scope in which it is declared.
    PooledMapPtr<DeclaredNameMap> declared_;

    // FunctionBoxes in this scope that need to be considered for Annex
    // B.3.3 semantics. This is checked on Scope exit, as by then we have
    // all the declared names and would know if Annex B.3.3 is applicable.
    using FunctionBoxVector = Vector<FunctionBox*, 24, SystemAllocPolicy>;
    PooledVectorPtr<FunctionBoxVector> possibleAnnexBFunctionBoxes_;

    // Monotonically increasing id.
    uint32_t id_;

    bool maybeReportOOM(ParseContext* pc, bool result) {
      if (!result) {
        ReportOutOfMemory(pc->sc()->cx_);
      }
      return result;
    }

   public:
    using DeclaredNamePtr = DeclaredNameMap::Ptr;
    using AddDeclaredNamePtr = DeclaredNameMap::AddPtr;

    using Nestable<Scope>::enclosing;

    explicit inline Scope(ParserBase* parser);
    explicit inline Scope(JSContext* cx, ParseContext* pc,
                          UsedNameTracker& usedNames);

    void dump(ParseContext* pc);

    uint32_t id() const { return id_; }

    MOZ_MUST_USE bool init(ParseContext* pc) {
      if (id_ == UINT32_MAX) {
        pc->errorReporter_.errorNoOffset(JSMSG_NEED_DIET, js_script_str);
        return false;
      }

      return declared_.acquire(pc->sc()->cx_);
    }

    bool isEmpty() const { return declared_->all().empty(); }

    DeclaredNamePtr lookupDeclaredName(JSAtom* name) {
      return declared_->lookup(name);
    }

    AddDeclaredNamePtr lookupDeclaredNameForAdd(JSAtom* name) {
      return declared_->lookupForAdd(name);
    }

    MOZ_MUST_USE bool addDeclaredName(ParseContext* pc, AddDeclaredNamePtr& p,
                                      JSAtom* name, DeclarationKind kind,
                                      uint32_t pos) {
      return maybeReportOOM(
          pc, declared_->add(p, name, DeclaredNameInfo(kind, pos)));
    }

    // Add a FunctionBox as a possible candidate for Annex B.3.3 semantics.
    MOZ_MUST_USE bool addPossibleAnnexBFunctionBox(ParseContext* pc,
                                                   FunctionBox* funbox);

    // Check if the candidate function boxes for Annex B.3.3 should in
    // fact get Annex B semantics. Checked on Scope exit.
    MOZ_MUST_USE bool propagateAndMarkAnnexBFunctionBoxes(ParseContext* pc);

    // Add and remove catch parameter names. Used to implement the odd
    // semantics of catch bodies.
    bool addCatchParameters(ParseContext* pc, Scope& catchParamScope);
    void removeCatchParameters(ParseContext* pc, Scope& catchParamScope);

    void useAsVarScope(ParseContext* pc) {
      MOZ_ASSERT(!pc->varScope_);
      pc->varScope_ = this;
    }

    // An iterator for the set of names a scope binds: the set of all
    // declared names for 'var' scopes, and the set of lexically declared
    // names for non-'var' scopes.
    class BindingIter {
      friend class Scope;

      DeclaredNameMap::Range declaredRange_;
      mozilla::DebugOnly<uint32_t> count_;
      bool isVarScope_;

      BindingIter(Scope& scope, bool isVarScope)
          : declaredRange_(scope.declared_->all()),
            count_(0),
            isVarScope_(isVarScope) {
        settle();
      }

      void settle() {
        // Both var and lexically declared names are binding in a var
        // scope.
        if (isVarScope_) {
          return;
        }

        // Otherwise, pop only lexically declared names are
        // binding. Pop the range until we find such a name.
        while (!declaredRange_.empty()) {
          if (BindingKindIsLexical(kind())) {
            break;
          }
          declaredRange_.popFront();
        }
      }

     public:
      bool done() const { return declaredRange_.empty(); }

      explicit operator bool() const { return !done(); }

      JSAtom* name() {
        MOZ_ASSERT(!done());
        return declaredRange_.front().key();
      }

      DeclarationKind declarationKind() {
        MOZ_ASSERT(!done());
        return declaredRange_.front().value()->kind();
      }

      BindingKind kind() {
        return DeclarationKindToBindingKind(declarationKind());
      }

      bool closedOver() {
        MOZ_ASSERT(!done());
        return declaredRange_.front().value()->closedOver();
      }

      void setClosedOver() {
        MOZ_ASSERT(!done());
        return declaredRange_.front().value()->setClosedOver();
      }

      void operator++(int) {
        MOZ_ASSERT(!done());
        MOZ_ASSERT(count_ != UINT32_MAX);
        declaredRange_.popFront();
        settle();
      }
    };

    inline BindingIter bindings(ParseContext* pc);
  };

  class VarScope : public Scope {
   public:
    explicit inline VarScope(ParserBase* parser);
    explicit inline VarScope(JSContext* cx, ParseContext* pc,
                             UsedNameTracker& usedNames);
  };

 private:
  // Trace logging of parsing time.
  AutoFrontendTraceLog traceLog_;

  // Context shared between parsing and bytecode generation.
  SharedContext* sc_;

  // A mechanism used for error reporting.
  ErrorReporter& errorReporter_;

  // The innermost statement, i.e., top of the statement stack.
  Statement* innermostStatement_;

  // The innermost scope, i.e., top of the scope stack.
  //
  // The outermost scope in the stack is usually varScope_. In the case of
  // functions, the outermost scope is functionScope_, which may be
  // varScope_. See comment above functionScope_.
  Scope* innermostScope_;

  // If isFunctionBox() and the function is a named lambda, the DeclEnv
  // scope for named lambdas.
  mozilla::Maybe<Scope> namedLambdaScope_;

  // If isFunctionBox(), the scope for the function. If there are no
  // parameter expressions, this is scope for the entire function. If there
  // are parameter expressions, this holds the special function names
  // ('.this', 'arguments') and the formal parameters.
  mozilla::Maybe<Scope> functionScope_;

  // The body-level scope. This always exists, but not necessarily at the
  // beginning of parsing the script in the case of functions with parameter
  // expressions.
  Scope* varScope_;

  // Simple formal parameter names, in order of appearance. Only used when
  // isFunctionBox().
  PooledVectorPtr<AtomVector> positionalFormalParameterNames_;

  // Closed over binding names, in order of appearance. Null-delimited
  // between scopes. Only used when syntax parsing.
  PooledVectorPtr<AtomVector> closedOverBindingsForLazy_;

 public:
  // All inner functions in this context. Only used when syntax parsing.
  // The Functions (or FunctionCreateionDatas) are traced as part of the
  // CompilationInfo function vector.
  Vector<FunctionIndex> innerFunctionIndexesForLazy;

  // In a function context, points to a Directive struct that can be updated
  // to reflect new directives encountered in the Directive Prologue that
  // require reparsing the function. In global/module/generator-tail contexts,
  // we don't need to reparse when encountering a DirectivePrologue so this
  // pointer may be nullptr.
  Directives* newDirectives;

  // lastYieldOffset stores the offset of the last yield that was parsed.
  // NoYieldOffset is its initial value.
  static const uint32_t NoYieldOffset = UINT32_MAX;
  uint32_t lastYieldOffset;

  // lastAwaitOffset stores the offset of the last await that was parsed.
  // NoAwaitOffset is its initial value.
  static const uint32_t NoAwaitOffset = UINT32_MAX;
  uint32_t lastAwaitOffset;

 private:
  // Monotonically increasing id.
  uint32_t scriptId_;

  // Set when encountering a super.property inside a method. We need to mark
  // the nearest super scope as needing a home object.
  bool superScopeNeedsHomeObject_;

 public:
  ParseContext(JSContext* cx, ParseContext*& parent, SharedContext* sc,
               ErrorReporter& errorReporter, CompilationInfo& compilationInfo,
               Directives* newDirectives, bool isFull);

  MOZ_MUST_USE bool init();

  SharedContext* sc() { return sc_; }

  // `true` if we are in the body of a function definition.
  bool isFunctionBox() const { return sc_->isFunctionBox(); }

  FunctionBox* functionBox() { return sc_->asFunctionBox(); }

  Statement* innermostStatement() { return innermostStatement_; }

  Scope* innermostScope() {
    // There is always at least one scope: the 'var' scope.
    MOZ_ASSERT(innermostScope_);
    return innermostScope_;
  }

  Scope& namedLambdaScope() {
    MOZ_ASSERT(functionBox()->isNamedLambda());
    return *namedLambdaScope_;
  }

  Scope& functionScope() {
    MOZ_ASSERT(isFunctionBox());
    return *functionScope_;
  }

  Scope& varScope() {
    MOZ_ASSERT(varScope_);
    return *varScope_;
  }

  bool isFunctionExtraBodyVarScopeInnermost() {
    return isFunctionBox() && functionBox()->hasParameterExprs &&
           innermostScope() == varScope_;
  }

  template <typename Predicate /* (Statement*) -> bool */>
  Statement* findInnermostStatement(Predicate predicate) {
    return Statement::findNearest(innermostStatement_, predicate);
  }

  template <typename T, typename Predicate /* (Statement*) -> bool */>
  T* findInnermostStatement(Predicate predicate) {
    return Statement::findNearest<T>(innermostStatement_, predicate);
  }

  template <typename T>
  T* findInnermostStatement() {
    return Statement::findNearest<T>(innermostStatement_);
  }

  AtomVector& positionalFormalParameterNames() {
    return *positionalFormalParameterNames_;
  }

  AtomVector& closedOverBindingsForLazy() {
    return *closedOverBindingsForLazy_;
  }

  enum class BreakStatementError {
    // Unlabeled break must be inside loop or switch.
    ToughBreak,
    LabelNotFound,
  };

  // Return Err(true) if we have encountered at least one loop,
  // Err(false) otherwise.
  MOZ_MUST_USE inline JS::Result<Ok, BreakStatementError> checkBreakStatement(
      PropertyName* label);

  enum class ContinueStatementError {
    NotInALoop,
    LabelNotFound,
  };
  MOZ_MUST_USE inline JS::Result<Ok, ContinueStatementError>
  checkContinueStatement(PropertyName* label);

  // True if we are at the topmost level of a entire script or function body.
  // For example, while parsing this code we would encounter f1 and f2 at
  // body level, but we would not encounter f3 or f4 at body level:
  //
  //   function f1() { function f2() { } }
  //   if (cond) { function f3() { if (cond) { function f4() { } } } }
  //
  bool atBodyLevel() { return !innermostStatement_; }

  bool atGlobalLevel() { return atBodyLevel() && sc_->isGlobalContext(); }

  // True if we are at the topmost level of a module only.
  bool atModuleLevel() { return atBodyLevel() && sc_->isModuleContext(); }

  // True if we are at the topmost level of an entire script or module.  For
  // example, in the comment on |atBodyLevel()| above, we would encounter |f1|
  // and the outermost |if (cond)| at top level, and everything else would not
  // be at top level.
  bool atTopLevel() { return atBodyLevel() && sc_->isTopLevelContext(); }

  void setSuperScopeNeedsHomeObject() {
    MOZ_ASSERT(sc_->allowSuperProperty());
    superScopeNeedsHomeObject_ = true;
  }

  bool superScopeNeedsHomeObject() const { return superScopeNeedsHomeObject_; }

  bool useAsmOrInsideUseAsm() const {
    return sc_->isFunctionBox() && sc_->asFunctionBox()->useAsmOrInsideUseAsm();
  }

  // A generator is marked as a generator before its body is parsed.
  GeneratorKind generatorKind() const {
    return sc_->isFunctionBox() ? sc_->asFunctionBox()->generatorKind()
                                : GeneratorKind::NotGenerator;
  }

  bool isGenerator() const {
    return generatorKind() == GeneratorKind::Generator;
  }

  bool isAsync() const {
    return sc_->isFunctionBox() && sc_->asFunctionBox()->isAsync();
  }

  bool needsDotGeneratorName() const { return isGenerator() || isAsync(); }

  FunctionAsyncKind asyncKind() const {
    return isAsync() ? FunctionAsyncKind::AsyncFunction
                     : FunctionAsyncKind::SyncFunction;
  }

  bool isArrowFunction() const {
    return sc_->isFunctionBox() && sc_->asFunctionBox()->isArrow();
  }

  bool isMethod() const {
    return sc_->isFunctionBox() && sc_->asFunctionBox()->isMethod();
  }

  bool isGetterOrSetter() const {
    return sc_->isFunctionBox() && (sc_->asFunctionBox()->isGetter() ||
                                    sc_->asFunctionBox()->isSetter());
  }

  uint32_t scriptId() const { return scriptId_; }

  bool annexBAppliesToLexicalFunctionInInnermostScope(FunctionBox* funbox);

  bool tryDeclareVar(HandlePropertyName name, DeclarationKind kind,
                     uint32_t beginPos,
                     mozilla::Maybe<DeclarationKind>* redeclaredKind,
                     uint32_t* prevPos);

  bool hasUsedName(const UsedNameTracker& usedNames, HandlePropertyName name);
  bool hasUsedFunctionSpecialName(const UsedNameTracker& usedNames,
                                  HandlePropertyName name);

  bool declareFunctionThis(const UsedNameTracker& usedNames,
                           bool canSkipLazyClosedOverBindings);
  bool declareFunctionArgumentsObject(const UsedNameTracker& usedNames,
                                      bool canSkipLazyClosedOverBindings);
  bool declareDotGeneratorName();

 private:
  mozilla::Maybe<DeclarationKind> isVarRedeclaredInInnermostScope(
      HandlePropertyName name, DeclarationKind kind);
  mozilla::Maybe<DeclarationKind> isVarRedeclaredInEval(HandlePropertyName name,
                                                        DeclarationKind kind);

  enum DryRunOption { NotDryRun, DryRunInnermostScopeOnly };
  template <DryRunOption dryRunOption>
  bool tryDeclareVarHelper(HandlePropertyName name, DeclarationKind kind,
                           uint32_t beginPos,
                           mozilla::Maybe<DeclarationKind>* redeclaredKind,
                           uint32_t* prevPos);
};

}  // namespace frontend

}  // namespace js

#endif  // frontend_ParseContext_h
