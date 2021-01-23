/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef frontend_CompilationInfo_h
#define frontend_CompilationInfo_h

#include "mozilla/Attributes.h"
#include "mozilla/Variant.h"

#include "ds/LifoAlloc.h"
#include "frontend/SharedContext.h"
#include "frontend/Stencil.h"
#include "frontend/UsedNameTracker.h"
#include "js/GCVariant.h"
#include "js/GCVector.h"
#include "js/RealmOptions.h"
#include "js/SourceText.h"
#include "js/Vector.h"
#include "vm/JSContext.h"
#include "vm/Realm.h"

namespace js {
namespace frontend {

// ScopeContext hold information derivied from the scope and environment chains
// to try to avoid the parser needing to traverse VM structures directly.
struct ScopeContext {
  // Whether the enclosing scope allows certain syntax. Eval and arrow scripts
  // inherit this from their enclosing scipt so we track it here.
  bool allowNewTarget = false;
  bool allowSuperProperty = false;
  bool allowSuperCall = false;
  bool allowArguments = true;

  // The type of binding required for `this` of the top level context, as
  // indicated by the enclosing scopes of this parse.
  ThisBinding thisBinding = ThisBinding::Global;

  // Somewhere on the scope chain this parse is embedded within is a 'With'
  // scope.
  bool inWith = false;

  // Class field initializer info if we are nested within a class constructor.
  // We may be an combination of arrow and eval context within the constructor.
  mozilla::Maybe<FieldInitializers> fieldInitializers = {};

  explicit ScopeContext(Scope* scope, JSObject* enclosingEnv = nullptr) {
    computeAllowSyntax(scope);
    computeThisBinding(scope, enclosingEnv);
    computeInWith(scope);
    computeExternalInitializers(scope);
  }

 private:
  void computeAllowSyntax(Scope* scope);
  void computeThisBinding(Scope* scope, JSObject* environment = nullptr);
  void computeInWith(Scope* scope);
  void computeExternalInitializers(Scope* scope);
};

// CompilationInfo owns a number of pieces of information about script
// compilation as well as controls the lifetime of parse nodes and other data by
// controling the mark and reset of the LifoAlloc.
struct MOZ_RAII CompilationInfo : public JS::CustomAutoRooter {
  JSContext* cx;
  const JS::ReadOnlyCompileOptions& options;

  // Until we have dealt with Atoms in the front end, we need to hold
  // onto them.
  AutoKeepAtoms keepAtoms;

  Directives directives;

  ScopeContext scopeContext;

  // List of function contexts for GC tracing. These are allocated in the
  // LifoAlloc and still require tracing.
  FunctionBox* traceListHead = nullptr;

  // The resulting outermost script for the compilation powered
  // by this CompilationInfo.
  JS::Rooted<JSScript*> script;
  JS::Rooted<BaseScript*> lazy;

  UsedNameTracker usedNames;
  LifoAllocScope& allocScope;

  // Hold onto the RegExpCreationData and BigIntCreationData that are allocated
  // during parse to ensure correct destruction.
  Vector<RegExpCreationData> regExpData;
  Vector<BigIntCreationData> bigIntData;

  // A Rooted vector to handle tracing of JSFunction*
  // and Atoms within.
  JS::RootedVector<JSFunction*> functions;
  JS::RootedVector<ScriptStencil> funcData;

  // Stencil for top-level script. This includes standalone functions and
  // functions being delazified.
  JS::Rooted<ScriptStencil> topLevel;
  SourceExtent topLevelExtent = {};

  // A rooted list of scopes created during this parse.
  //
  // To ensure that ScopeCreationData's destructors fire, and thus our HeapPtr
  // barriers, we store the scopeCreationData at this level so that they
  // can be safely destroyed, rather than LifoAllocing them with the rest of
  // the parser data structures.
  //
  // References to scopes are controlled via AbstractScopePtr, which holds onto
  // an index (and CompilationInfo reference).
  JS::RootedVector<ScopeCreationData> scopeCreationData;

  JS::Rooted<ScriptSourceObject*> sourceObject;

  // Track the state of key allocations and roll them back as parts of parsing
  // get retried. This ensures iteration during stencil instantiation does not
  // encounter discarded frontend state.
  struct RewindToken {
    FunctionBox* funbox = nullptr;
  };

  RewindToken getRewindToken();
  void rewind(const RewindToken& pos);

  // Construct a CompilationInfo
  CompilationInfo(JSContext* cx, LifoAllocScope& alloc,
                  const JS::ReadOnlyCompileOptions& options,
                  Scope* enclosingScope = nullptr,
                  JSObject* enclosingEnv = nullptr)
      : JS::CustomAutoRooter(cx),
        cx(cx),
        options(options),
        keepAtoms(cx),
        directives(options.forceStrictMode()),
        scopeContext(enclosingScope, enclosingEnv),
        script(cx),
        lazy(cx),
        usedNames(cx),
        allocScope(alloc),
        regExpData(cx),
        bigIntData(cx),
        functions(cx),
        funcData(cx),
        topLevel(cx),
        scopeCreationData(cx),
        sourceObject(cx) {}

  bool init(JSContext* cx);

  void initFromLazy(BaseScript* lazy) {
    this->lazy = lazy;
    this->sourceObject = lazy->sourceObject();
  }

  template <typename Unit>
  MOZ_MUST_USE bool assignSource(JS::SourceText<Unit>& sourceBuffer) {
    return sourceObject->source()->assignSource(cx, options, sourceBuffer);
  }

  MOZ_MUST_USE bool instantiateStencils();

  void trace(JSTracer* trc) final;

  // To avoid any misuses, make sure this is neither copyable,
  // movable or assignable.
  CompilationInfo(const CompilationInfo&) = delete;
  CompilationInfo(CompilationInfo&&) = delete;
  CompilationInfo& operator=(const CompilationInfo&) = delete;
  CompilationInfo& operator=(CompilationInfo&&) = delete;
};

}  // namespace frontend
}  // namespace js
#endif
