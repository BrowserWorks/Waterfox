/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * JS bytecode generation.
 */

#include "frontend/BytecodeEmitter.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/FloatingPoint.h"
#include "mozilla/Maybe.h"
#include "mozilla/PodOperations.h"

#include <string.h>

#include "jsapi.h"
#include "jsatom.h"
#include "jscntxt.h"
#include "jsfun.h"
#include "jsnum.h"
#include "jsopcode.h"
#include "jsscript.h"
#include "jstypes.h"
#include "jsutil.h"

#include "frontend/Parser.h"
#include "frontend/TokenStream.h"
#include "vm/Debugger.h"
#include "vm/GeneratorObject.h"
#include "vm/Stack.h"
#include "wasm/AsmJS.h"

#include "jsatominlines.h"
#include "jsobjinlines.h"
#include "jsscriptinlines.h"

#include "frontend/ParseNode-inl.h"
#include "vm/EnvironmentObject-inl.h"
#include "vm/NativeObject-inl.h"

using namespace js;
using namespace js::gc;
using namespace js::frontend;

using mozilla::AssertedCast;
using mozilla::DebugOnly;
using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::NumberIsInt32;
using mozilla::PodCopy;
using mozilla::Some;

class BreakableControl;
class LabelControl;
class LoopControl;
class TryFinallyControl;

static bool
ParseNodeRequiresSpecialLineNumberNotes(ParseNode* pn)
{
    return pn->getKind() == PNK_WHILE || pn->getKind() == PNK_FOR;
}

// A cache that tracks superfluous TDZ checks.
//
// Each basic block should have a TDZCheckCache in scope. Some NestableControl
// subclasses contain a TDZCheckCache.
class BytecodeEmitter::TDZCheckCache : public Nestable<BytecodeEmitter::TDZCheckCache>
{
    PooledMapPtr<CheckTDZMap> cache_;

    MOZ_MUST_USE bool ensureCache(BytecodeEmitter* bce) {
        return cache_ || cache_.acquire(bce->cx);
    }

  public:
    explicit TDZCheckCache(BytecodeEmitter* bce)
      : Nestable<TDZCheckCache>(&bce->innermostTDZCheckCache),
        cache_(bce->cx->frontendCollectionPool())
    { }

    Maybe<MaybeCheckTDZ> needsTDZCheck(BytecodeEmitter* bce, JSAtom* name);
    MOZ_MUST_USE bool noteTDZCheck(BytecodeEmitter* bce, JSAtom* name, MaybeCheckTDZ check);
};

class BytecodeEmitter::NestableControl : public Nestable<BytecodeEmitter::NestableControl>
{
    StatementKind kind_;

    // The innermost scope when this was pushed.
    EmitterScope* emitterScope_;

  protected:
    NestableControl(BytecodeEmitter* bce, StatementKind kind)
      : Nestable<NestableControl>(&bce->innermostNestableControl),
        kind_(kind),
        emitterScope_(bce->innermostEmitterScope)
    { }

  public:
    using Nestable<NestableControl>::enclosing;
    using Nestable<NestableControl>::findNearest;

    StatementKind kind() const {
        return kind_;
    }

    EmitterScope* emitterScope() const {
        return emitterScope_;
    }

    template <typename T>
    bool is() const;

    template <typename T>
    T& as() {
        MOZ_ASSERT(this->is<T>());
        return static_cast<T&>(*this);
    }
};

// Template specializations are disallowed in different namespaces; specialize
// all the NestableControl subtypes up front.
namespace js {
namespace frontend {

template <>
bool
BytecodeEmitter::NestableControl::is<BreakableControl>() const
{
    return StatementKindIsUnlabeledBreakTarget(kind_) || kind_ == StatementKind::Label;
}

template <>
bool
BytecodeEmitter::NestableControl::is<LabelControl>() const
{
    return kind_ == StatementKind::Label;
}

template <>
bool
BytecodeEmitter::NestableControl::is<LoopControl>() const
{
    return StatementKindIsLoop(kind_);
}

template <>
bool
BytecodeEmitter::NestableControl::is<TryFinallyControl>() const
{
    return kind_ == StatementKind::Try || kind_ == StatementKind::Finally;
}

} // namespace frontend
} // namespace js

class BreakableControl : public BytecodeEmitter::NestableControl
{
  public:
    // Offset of the last break.
    JumpList breaks;

    BreakableControl(BytecodeEmitter* bce, StatementKind kind)
      : NestableControl(bce, kind)
    {
        MOZ_ASSERT(is<BreakableControl>());
    }

    MOZ_MUST_USE bool patchBreaks(BytecodeEmitter* bce) {
        return bce->emitJumpTargetAndPatch(breaks);
    }
};

class LabelControl : public BreakableControl
{
    RootedAtom label_;

    // The code offset when this was pushed. Used for effectfulness checking.
    ptrdiff_t startOffset_;

  public:
    LabelControl(BytecodeEmitter* bce, JSAtom* label, ptrdiff_t startOffset)
      : BreakableControl(bce, StatementKind::Label),
        label_(bce->cx, label),
        startOffset_(startOffset)
    { }

    HandleAtom label() const {
        return label_;
    }

    ptrdiff_t startOffset() const {
        return startOffset_;
    }
};

class LoopControl : public BreakableControl
{
    // Loops' children are emitted in dominance order, so they can always
    // have a TDZCheckCache.
    BytecodeEmitter::TDZCheckCache tdzCache_;

    // Stack depth when this loop was pushed on the control stack.
    int32_t stackDepth_;

    // The loop nesting depth. Used as a hint to Ion.
    uint32_t loopDepth_;

    // Can we OSR into Ion from here? True unless there is non-loop state on the stack.
    bool canIonOsr_;

  public:
    // The target of continue statement jumps, e.g., the update portion of a
    // for(;;) loop.
    JumpTarget continueTarget;

    // Offset of the last continue in the loop.
    JumpList continues;

    LoopControl(BytecodeEmitter* bce, StatementKind loopKind)
      : BreakableControl(bce, loopKind),
        tdzCache_(bce),
        continueTarget({ -1 })
    {
        MOZ_ASSERT(is<LoopControl>());

        LoopControl* enclosingLoop = findNearest<LoopControl>(enclosing());

        stackDepth_ = bce->stackDepth;
        loopDepth_ = enclosingLoop ? enclosingLoop->loopDepth_ + 1 : 1;

        int loopSlots;
        if (loopKind == StatementKind::Spread)
            loopSlots = 3;
        else if (loopKind == StatementKind::ForInLoop || loopKind == StatementKind::ForOfLoop)
            loopSlots = 2;
        else
            loopSlots = 0;

        MOZ_ASSERT(loopSlots <= stackDepth_);

        if (enclosingLoop) {
            canIonOsr_ = (enclosingLoop->canIonOsr_ &&
                          stackDepth_ == enclosingLoop->stackDepth_ + loopSlots);
        } else {
            canIonOsr_ = stackDepth_ == loopSlots;
        }
    }

    uint32_t loopDepth() const {
        return loopDepth_;
    }

    bool canIonOsr() const {
        return canIonOsr_;
    }

    MOZ_MUST_USE bool patchBreaksAndContinues(BytecodeEmitter* bce) {
        MOZ_ASSERT(continueTarget.offset != -1);
        if (!patchBreaks(bce))
            return false;
        bce->patchJumpsToTarget(continues, continueTarget);
        return true;
    }
};

class TryFinallyControl : public BytecodeEmitter::NestableControl
{
    bool emittingSubroutine_;

  public:
    // The subroutine when emitting a finally block.
    JumpList gosubs;

    // Offset of the last catch guard, if any.
    JumpList guardJump;

    TryFinallyControl(BytecodeEmitter* bce, StatementKind kind)
      : NestableControl(bce, kind),
        emittingSubroutine_(false)
    {
        MOZ_ASSERT(is<TryFinallyControl>());
    }

    void setEmittingSubroutine() {
        emittingSubroutine_ = true;
    }

    bool emittingSubroutine() const {
        return emittingSubroutine_;
    }
};

static bool
ScopeKindIsInBody(ScopeKind kind)
{
    return kind == ScopeKind::Lexical ||
           kind == ScopeKind::SimpleCatch ||
           kind == ScopeKind::Catch ||
           kind == ScopeKind::With ||
           kind == ScopeKind::FunctionBodyVar ||
           kind == ScopeKind::ParameterExpressionVar;
}

static inline void
MarkAllBindingsClosedOver(LexicalScope::Data& data)
{
    BindingName* names = data.names;
    for (uint32_t i = 0; i < data.length; i++)
        names[i] = BindingName(names[i].name(), true);
}

// A scope that introduces bindings.
class BytecodeEmitter::EmitterScope : public Nestable<BytecodeEmitter::EmitterScope>
{
    // The cache of bound names that may be looked up in the
    // scope. Initially populated as the set of names this scope binds. As
    // names are looked up in enclosing scopes, they are cached on the
    // current scope.
    PooledMapPtr<NameLocationMap> nameCache_;

    // If this scope's cache does not include free names, such as the
    // global scope, the NameLocation to return.
    Maybe<NameLocation> fallbackFreeNameLocation_;

    // True if there is a corresponding EnvironmentObject on the environment
    // chain, false if all bindings are stored in frame slots on the stack.
    bool hasEnvironment_;

    // The number of enclosing environments. Used for error checking.
    uint8_t environmentChainLength_;

    // The next usable slot on the frame for not-closed over bindings.
    //
    // The initial frame slot when assigning slots to bindings is the
    // enclosing scope's nextFrameSlot. For the first scope in a frame,
    // the initial frame slot is 0.
    uint32_t nextFrameSlot_;

    // The index in the BytecodeEmitter's interned scope vector, otherwise
    // ScopeNote::NoScopeIndex.
    uint32_t scopeIndex_;

    // If kind is Lexical, Catch, or With, the index in the BytecodeEmitter's
    // block scope note list. Otherwise ScopeNote::NoScopeNote.
    uint32_t noteIndex_;

    MOZ_MUST_USE bool ensureCache(BytecodeEmitter* bce) {
        return nameCache_.acquire(bce->cx);
    }

    template <typename BindingIter>
    MOZ_MUST_USE bool checkSlotLimits(BytecodeEmitter* bce, const BindingIter& bi) {
        if (bi.nextFrameSlot() >= LOCALNO_LIMIT ||
            bi.nextEnvironmentSlot() >= ENVCOORD_SLOT_LIMIT)
        {
            return bce->reportError(nullptr, JSMSG_TOO_MANY_LOCALS);
        }
        return true;
    }

    MOZ_MUST_USE bool checkEnvironmentChainLength(BytecodeEmitter* bce) {
        uint32_t hops;
        if (EmitterScope* emitterScope = enclosing(&bce))
            hops = emitterScope->environmentChainLength_;
        else
            hops = bce->sc->compilationEnclosingScope()->environmentChainLength();
        if (hops >= ENVCOORD_HOPS_LIMIT - 1)
            return bce->reportError(nullptr, JSMSG_TOO_DEEP, js_function_str);
        environmentChainLength_ = mozilla::AssertedCast<uint8_t>(hops + 1);
        return true;
    }

    void updateFrameFixedSlots(BytecodeEmitter* bce, const BindingIter& bi) {
        nextFrameSlot_ = bi.nextFrameSlot();
        if (nextFrameSlot_ > bce->maxFixedSlots)
            bce->maxFixedSlots = nextFrameSlot_;
        MOZ_ASSERT_IF(bce->sc->isFunctionBox() && bce->sc->asFunctionBox()->isGenerator(),
                      bce->maxFixedSlots == 0);
    }

    MOZ_MUST_USE bool putNameInCache(BytecodeEmitter* bce, JSAtom* name, NameLocation loc) {
        NameLocationMap& cache = *nameCache_;
        NameLocationMap::AddPtr p = cache.lookupForAdd(name);
        MOZ_ASSERT(!p);
        if (!cache.add(p, name, loc)) {
            ReportOutOfMemory(bce->cx);
            return false;
        }
        return true;
    }

    Maybe<NameLocation> lookupInCache(BytecodeEmitter* bce, JSAtom* name) {
        if (NameLocationMap::Ptr p = nameCache_->lookup(name))
            return Some(p->value().wrapped);
        if (fallbackFreeNameLocation_ && nameCanBeFree(bce, name))
            return fallbackFreeNameLocation_;
        return Nothing();
    }

    friend bool BytecodeEmitter::needsImplicitThis();

    EmitterScope* enclosing(BytecodeEmitter** bce) const {
        // There is an enclosing scope with access to the same frame.
        if (EmitterScope* inFrame = enclosingInFrame())
            return inFrame;

        // We are currently compiling the enclosing script, look in the
        // enclosing BCE.
        if ((*bce)->parent) {
            *bce = (*bce)->parent;
            return (*bce)->innermostEmitterScope;
        }

        return nullptr;
    }

    Scope* enclosingScope(BytecodeEmitter* bce) const {
        if (EmitterScope* es = enclosing(&bce))
            return es->scope(bce);

        // The enclosing script is already compiled or the current script is the
        // global script.
        return bce->sc->compilationEnclosingScope();
    }

    static bool nameCanBeFree(BytecodeEmitter* bce, JSAtom* name) {
        // '.generator' cannot be accessed by name.
        return name != bce->cx->names().dotGenerator;
    }

    static NameLocation searchInEnclosingScope(JSAtom* name, Scope* scope, uint8_t hops);
    NameLocation searchAndCache(BytecodeEmitter* bce, JSAtom* name);

    template <typename ScopeCreator>
    MOZ_MUST_USE bool internScope(BytecodeEmitter* bce, ScopeCreator createScope);
    template <typename ScopeCreator>
    MOZ_MUST_USE bool internBodyScope(BytecodeEmitter* bce, ScopeCreator createScope);
    MOZ_MUST_USE bool appendScopeNote(BytecodeEmitter* bce);

    MOZ_MUST_USE bool deadZoneFrameSlotRange(BytecodeEmitter* bce, uint32_t slotStart,
                                             uint32_t slotEnd);

  public:
    explicit EmitterScope(BytecodeEmitter* bce)
      : Nestable<EmitterScope>(&bce->innermostEmitterScope),
        nameCache_(bce->cx->frontendCollectionPool()),
        hasEnvironment_(false),
        environmentChainLength_(0),
        nextFrameSlot_(0),
        scopeIndex_(ScopeNote::NoScopeIndex),
        noteIndex_(ScopeNote::NoScopeNoteIndex)
    { }

    void dump(BytecodeEmitter* bce);

    MOZ_MUST_USE bool enterLexical(BytecodeEmitter* bce, ScopeKind kind,
                                   Handle<LexicalScope::Data*> bindings);
    MOZ_MUST_USE bool enterNamedLambda(BytecodeEmitter* bce, FunctionBox* funbox);
    MOZ_MUST_USE bool enterComprehensionFor(BytecodeEmitter* bce,
                                            Handle<LexicalScope::Data*> bindings);
    MOZ_MUST_USE bool enterFunction(BytecodeEmitter* bce, FunctionBox* funbox);
    MOZ_MUST_USE bool enterFunctionExtraBodyVar(BytecodeEmitter* bce, FunctionBox* funbox);
    MOZ_MUST_USE bool enterParameterExpressionVar(BytecodeEmitter* bce);
    MOZ_MUST_USE bool enterGlobal(BytecodeEmitter* bce, GlobalSharedContext* globalsc);
    MOZ_MUST_USE bool enterEval(BytecodeEmitter* bce, EvalSharedContext* evalsc);
    MOZ_MUST_USE bool enterModule(BytecodeEmitter* module, ModuleSharedContext* modulesc);
    MOZ_MUST_USE bool enterWith(BytecodeEmitter* bce);
    MOZ_MUST_USE bool deadZoneFrameSlots(BytecodeEmitter* bce);

    MOZ_MUST_USE bool leave(BytecodeEmitter* bce, bool nonLocal = false);

    uint32_t index() const {
        MOZ_ASSERT(scopeIndex_ != ScopeNote::NoScopeIndex, "Did you forget to intern a Scope?");
        return scopeIndex_;
    }

    uint32_t noteIndex() const {
        return noteIndex_;
    }

    Scope* scope(const BytecodeEmitter* bce) const {
        return bce->scopeList.vector[index()];
    }

    bool hasEnvironment() const {
        return hasEnvironment_;
    }

    // The first frame slot used.
    uint32_t frameSlotStart() const {
        if (EmitterScope* inFrame = enclosingInFrame())
            return inFrame->nextFrameSlot_;
        return 0;
    }

    // The last frame slot used + 1.
    uint32_t frameSlotEnd() const {
        return nextFrameSlot_;
    }

    uint32_t numFrameSlots() const {
        return frameSlotEnd() - frameSlotStart();
    }

    EmitterScope* enclosingInFrame() const {
        return Nestable<EmitterScope>::enclosing();
    }

    NameLocation lookup(BytecodeEmitter* bce, JSAtom* name) {
        if (Maybe<NameLocation> loc = lookupInCache(bce, name))
            return *loc;
        return searchAndCache(bce, name);
    }

    Maybe<NameLocation> locationBoundInScope(BytecodeEmitter* bce, JSAtom* name,
                                             EmitterScope* target);
};

void
BytecodeEmitter::EmitterScope::dump(BytecodeEmitter* bce)
{
    fprintf(stdout, "EmitterScope [%s] %p\n", ScopeKindString(scope(bce)->kind()), this);

    for (NameLocationMap::Range r = nameCache_->all(); !r.empty(); r.popFront()) {
        const NameLocation& l = r.front().value();

        JSAutoByteString bytes;
        if (!AtomToPrintableString(bce->cx, r.front().key(), &bytes))
            return;
        if (l.kind() != NameLocation::Kind::Dynamic)
            fprintf(stdout, "  %s %s ", BindingKindString(l.bindingKind()), bytes.ptr());
        else
            fprintf(stdout, "  %s ", bytes.ptr());

        switch (l.kind()) {
          case NameLocation::Kind::Dynamic:
            fprintf(stdout, "dynamic\n");
            break;
          case NameLocation::Kind::Global:
            fprintf(stdout, "global\n");
            break;
          case NameLocation::Kind::Intrinsic:
            fprintf(stdout, "intrinsic\n");
            break;
          case NameLocation::Kind::NamedLambdaCallee:
            fprintf(stdout, "named lambda callee\n");
            break;
          case NameLocation::Kind::Import:
            fprintf(stdout, "import\n");
            break;
          case NameLocation::Kind::ArgumentSlot:
            fprintf(stdout, "arg slot=%u\n", l.argumentSlot());
            break;
          case NameLocation::Kind::FrameSlot:
            fprintf(stdout, "frame slot=%u\n", l.frameSlot());
            break;
          case NameLocation::Kind::EnvironmentCoordinate:
            fprintf(stdout, "environment hops=%u slot=%u\n",
                    l.environmentCoordinate().hops(), l.environmentCoordinate().slot());
            break;
          case NameLocation::Kind::DynamicAnnexBVar:
            fprintf(stdout, "dynamic annex b var\n");
            break;
        }
    }

    fprintf(stdout, "\n");
}

template <typename ScopeCreator>
bool
BytecodeEmitter::EmitterScope::internScope(BytecodeEmitter* bce, ScopeCreator createScope)
{
    RootedScope enclosing(bce->cx, enclosingScope(bce));
    Scope* scope = createScope(bce->cx, enclosing);
    if (!scope)
        return false;
    hasEnvironment_ = scope->hasEnvironment();
    scopeIndex_ = bce->scopeList.length();
    return bce->scopeList.append(scope);
}

template <typename ScopeCreator>
bool
BytecodeEmitter::EmitterScope::internBodyScope(BytecodeEmitter* bce, ScopeCreator createScope)
{
    MOZ_ASSERT(bce->bodyScopeIndex == UINT32_MAX, "There can be only one body scope");
    bce->bodyScopeIndex = bce->scopeList.length();
    return internScope(bce, createScope);
}

bool
BytecodeEmitter::EmitterScope::appendScopeNote(BytecodeEmitter* bce)
{
    MOZ_ASSERT(ScopeKindIsInBody(scope(bce)->kind()) && enclosingInFrame(),
               "Scope notes are not needed for body-level scopes.");
    noteIndex_ = bce->scopeNoteList.length();
    return bce->scopeNoteList.append(index(), bce->offset(), bce->inPrologue(),
                                     enclosingInFrame() ? enclosingInFrame()->noteIndex()
                                                        : ScopeNote::NoScopeNoteIndex);
}

#ifdef DEBUG
static bool
NameIsOnEnvironment(Scope* scope, JSAtom* name)
{
    for (BindingIter bi(scope); bi; bi++) {
        // If found, the name must already be on the environment or an import,
        // or else there is a bug in the closed-over name analysis in the
        // Parser.
        if (bi.name() == name) {
            BindingLocation::Kind kind = bi.location().kind();

            if (bi.hasArgumentSlot()) {
                JSScript* script = scope->as<FunctionScope>().script();
                if (!script->strict() && !script->functionHasParameterExprs()) {
                    // Check for duplicate positional formal parameters.
                    for (BindingIter bi2(bi); bi2 && bi2.hasArgumentSlot(); bi2++) {
                        if (bi2.name() == name)
                            kind = bi2.location().kind();
                    }
                }
            }

            return kind == BindingLocation::Kind::Global ||
                   kind == BindingLocation::Kind::Environment ||
                   kind == BindingLocation::Kind::Import;
        }
    }

    // If not found, assume it's on the global or dynamically accessed.
    return true;
}
#endif

/* static */ NameLocation
BytecodeEmitter::EmitterScope::searchInEnclosingScope(JSAtom* name, Scope* scope, uint8_t hops)
{
    for (ScopeIter si(scope); si; si++) {
        MOZ_ASSERT(NameIsOnEnvironment(si.scope(), name));

        bool hasEnv = si.hasSyntacticEnvironment();

        switch (si.kind()) {
          case ScopeKind::Function:
            if (hasEnv) {
                JSScript* script = si.scope()->as<FunctionScope>().script();
                if (script->funHasExtensibleScope())
                    return NameLocation::Dynamic();

                for (BindingIter bi(si.scope()); bi; bi++) {
                    if (bi.name() != name)
                        continue;

                    BindingLocation bindLoc = bi.location();
                    if (bi.hasArgumentSlot() &&
                        !script->strict() &&
                        !script->functionHasParameterExprs())
                    {
                        // Check for duplicate positional formal parameters.
                        for (BindingIter bi2(bi); bi2 && bi2.hasArgumentSlot(); bi2++) {
                            if (bi2.name() == name)
                                bindLoc = bi2.location();
                        }
                    }

                    MOZ_ASSERT(bindLoc.kind() == BindingLocation::Kind::Environment);
                    return NameLocation::EnvironmentCoordinate(bi.kind(), hops, bindLoc.slot());
                }
            }
            break;

          case ScopeKind::FunctionBodyVar:
          case ScopeKind::ParameterExpressionVar:
          case ScopeKind::Lexical:
          case ScopeKind::NamedLambda:
          case ScopeKind::StrictNamedLambda:
          case ScopeKind::SimpleCatch:
          case ScopeKind::Catch:
            if (hasEnv) {
                for (BindingIter bi(si.scope()); bi; bi++) {
                    if (bi.name() != name)
                        continue;

                    // The name must already have been marked as closed
                    // over. If this assertion is hit, there is a bug in the
                    // name analysis.
                    BindingLocation bindLoc = bi.location();
                    MOZ_ASSERT(bindLoc.kind() == BindingLocation::Kind::Environment);
                    return NameLocation::EnvironmentCoordinate(bi.kind(), hops, bindLoc.slot());
                }
            }
            break;

          case ScopeKind::Module:
            if (hasEnv) {
                for (BindingIter bi(si.scope()); bi; bi++) {
                    if (bi.name() != name)
                        continue;

                    BindingLocation bindLoc = bi.location();

                    // Imports are on the environment but are indirect
                    // bindings and must be accessed dynamically instead of
                    // using an EnvironmentCoordinate.
                    if (bindLoc.kind() == BindingLocation::Kind::Import) {
                        MOZ_ASSERT(si.kind() == ScopeKind::Module);
                        return NameLocation::Import();
                    }

                    MOZ_ASSERT(bindLoc.kind() == BindingLocation::Kind::Environment);
                    return NameLocation::EnvironmentCoordinate(bi.kind(), hops, bindLoc.slot());
                }
            }
            break;

          case ScopeKind::Eval:
          case ScopeKind::StrictEval:
            // As an optimization, if the eval doesn't have its own var
            // environment and its immediate enclosing scope is a global
            // scope, all accesses are global.
            if (!hasEnv && si.scope()->enclosing()->is<GlobalScope>())
                return NameLocation::Global(BindingKind::Var);
            return NameLocation::Dynamic();

          case ScopeKind::Global:
            return NameLocation::Global(BindingKind::Var);

          case ScopeKind::With:
          case ScopeKind::NonSyntactic:
            return NameLocation::Dynamic();
        }

        if (hasEnv) {
            MOZ_ASSERT(hops < ENVCOORD_HOPS_LIMIT - 1);
            hops++;
        }
    }

    MOZ_CRASH("Malformed scope chain");
}

NameLocation
BytecodeEmitter::EmitterScope::searchAndCache(BytecodeEmitter* bce, JSAtom* name)
{
    Maybe<NameLocation> loc;
    uint8_t hops = hasEnvironment() ? 1 : 0;
    DebugOnly<bool> inCurrentScript = enclosingInFrame();

    // Start searching in the current compilation.
    for (EmitterScope* es = enclosing(&bce); es; es = es->enclosing(&bce)) {
        loc = es->lookupInCache(bce, name);
        if (loc) {
            if (loc->kind() == NameLocation::Kind::EnvironmentCoordinate)
                *loc = loc->addHops(hops);
            break;
        }

        if (es->hasEnvironment())
            hops++;

#ifdef DEBUG
        if (!es->enclosingInFrame())
            inCurrentScript = false;
#endif
    }

    // If the name is not found in the current compilation, walk the Scope
    // chain encompassing the compilation.
    if (!loc) {
        inCurrentScript = false;
        loc = Some(searchInEnclosingScope(name, bce->sc->compilationEnclosingScope(), hops));
    }

    // Each script has its own frame. A free name that is accessed
    // from an inner script must not be a frame slot access. If this
    // assertion is hit, it is a bug in the free name analysis in the
    // parser.
    MOZ_ASSERT_IF(!inCurrentScript, loc->kind() != NameLocation::Kind::FrameSlot);

    // It is always correct to not cache the location. Ignore OOMs to make
    // lookups infallible.
    if (!putNameInCache(bce, name, *loc))
        bce->cx->recoverFromOutOfMemory();

    return *loc;
}

Maybe<NameLocation>
BytecodeEmitter::EmitterScope::locationBoundInScope(BytecodeEmitter* bce, JSAtom* name,
                                                    EmitterScope* target)
{
    // The target scope must be an intra-frame enclosing scope of this
    // one. Count the number of extra hops to reach it.
    uint8_t extraHops = 0;
    for (EmitterScope* es = this; es != target; es = es->enclosingInFrame()) {
        if (es->hasEnvironment())
            extraHops++;
    }

    // Caches are prepopulated with bound names. So if the name is bound in a
    // particular scope, it must already be in the cache. Furthermore, don't
    // consult the fallback location as we only care about binding names.
    Maybe<NameLocation> loc;
    if (NameLocationMap::Ptr p = target->nameCache_->lookup(name)) {
        NameLocation l = p->value().wrapped;
        if (l.kind() == NameLocation::Kind::EnvironmentCoordinate)
            loc = Some(l.addHops(extraHops));
        else
            loc = Some(l);
    }
    return loc;
}

bool
BytecodeEmitter::EmitterScope::deadZoneFrameSlotRange(BytecodeEmitter* bce, uint32_t slotStart,
                                                      uint32_t slotEnd)
{
    // Lexical bindings throw ReferenceErrors if they are used before
    // initialization. See ES6 8.1.1.1.6.
    //
    // For completeness, lexical bindings are initialized in ES6 by calling
    // InitializeBinding, after which touching the binding will no longer
    // throw reference errors. See 13.1.11, 9.2.13, 13.6.3.4, 13.6.4.6,
    // 13.6.4.8, 13.14.5, 15.1.8, and 15.2.0.15.
    if (slotStart != slotEnd) {
        if (!bce->emit1(JSOP_UNINITIALIZED))
            return false;
        for (uint32_t slot = slotStart; slot < slotEnd; slot++) {
            if (!bce->emitLocalOp(JSOP_INITLEXICAL, slot))
                return false;
        }
        if (!bce->emit1(JSOP_POP))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::EmitterScope::deadZoneFrameSlots(BytecodeEmitter* bce)
{
    return deadZoneFrameSlotRange(bce, frameSlotStart(), frameSlotEnd());
}

bool
BytecodeEmitter::EmitterScope::enterLexical(BytecodeEmitter* bce, ScopeKind kind,
                                            Handle<LexicalScope::Data*> bindings)
{
    MOZ_ASSERT(kind != ScopeKind::NamedLambda && kind != ScopeKind::StrictNamedLambda);
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    if (!ensureCache(bce))
        return false;

    // Marks all names as closed over if the the context requires it. This
    // cannot be done in the Parser as we may not know if the context requires
    // all bindings to be closed over until after parsing is finished. For
    // example, legacy generators require all bindings to be closed over but
    // it is unknown if a function is a legacy generator until the first
    // 'yield' expression is parsed.
    //
    // This is not a problem with other scopes, as all other scopes with
    // bindings are body-level. At the time of their creation, whether or not
    // the context requires all bindings to be closed over is already known.
    if (bce->sc->allBindingsClosedOver())
        MarkAllBindingsClosedOver(*bindings);

    // Resolve bindings.
    TDZCheckCache* tdzCache = bce->innermostTDZCheckCache;
    uint32_t firstFrameSlot = frameSlotStart();
    BindingIter bi(*bindings, firstFrameSlot, /* isNamedLambda = */ false);
    for (; bi; bi++) {
        if (!checkSlotLimits(bce, bi))
            return false;

        NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
        if (!putNameInCache(bce, bi.name(), loc))
            return false;

        if (!tdzCache->noteTDZCheck(bce, bi.name(), CheckTDZ))
            return false;
    }

    updateFrameFixedSlots(bce, bi);

    // Create and intern the VM scope.
    auto createScope = [kind, bindings, firstFrameSlot](ExclusiveContext* cx,
                                                        HandleScope enclosing)
    {
        return LexicalScope::create(cx, kind, bindings, firstFrameSlot, enclosing);
    };
    if (!internScope(bce, createScope))
        return false;

    if (ScopeKindIsInBody(kind) && hasEnvironment()) {
        // After interning the VM scope we can get the scope index.
        if (!bce->emitInternedScopeOp(index(), JSOP_PUSHLEXICALENV))
            return false;
    }

    // Lexical scopes need notes to be mapped from a pc.
    if (!appendScopeNote(bce))
        return false;

    // Put frame slots in TDZ. Environment slots are poisoned during
    // environment creation.
    //
    // This must be done after appendScopeNote to be considered in the extent
    // of the scope.
    if (!deadZoneFrameSlotRange(bce, firstFrameSlot, frameSlotEnd()))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::enterNamedLambda(BytecodeEmitter* bce, FunctionBox* funbox)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);
    MOZ_ASSERT(funbox->namedLambdaBindings());

    if (!ensureCache(bce))
        return false;

    // See comment in enterLexical about allBindingsClosedOver.
    if (funbox->allBindingsClosedOver())
        MarkAllBindingsClosedOver(*funbox->namedLambdaBindings());

    BindingIter bi(*funbox->namedLambdaBindings(), LOCALNO_LIMIT, /* isNamedLambda = */ true);
    MOZ_ASSERT(bi.kind() == BindingKind::NamedLambdaCallee);

    // The lambda name, if not closed over, is accessed via JSOP_CALLEE and
    // not a frame slot. Do not update frame slot information.
    NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
    if (!putNameInCache(bce, bi.name(), loc))
        return false;

    bi++;
    MOZ_ASSERT(!bi, "There should be exactly one binding in a NamedLambda scope");

    auto createScope = [funbox](ExclusiveContext* cx, HandleScope enclosing) {
        ScopeKind scopeKind =
            funbox->strict() ? ScopeKind::StrictNamedLambda : ScopeKind::NamedLambda;
        return LexicalScope::create(cx, scopeKind, funbox->namedLambdaBindings(),
                                    LOCALNO_LIMIT, enclosing);
    };
    if (!internScope(bce, createScope))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::enterComprehensionFor(BytecodeEmitter* bce,
                                                     Handle<LexicalScope::Data*> bindings)
{
    if (!enterLexical(bce, ScopeKind::Lexical, bindings))
        return false;

    // For comprehensions, initialize all lexical names up front to undefined
    // because they're now a dead feature and don't interact properly with
    // TDZ.
    auto nop = [](BytecodeEmitter*, const NameLocation&, bool) {
        return true;
    };

    if (!bce->emit1(JSOP_UNDEFINED))
        return false;

    RootedAtom name(bce->cx);
    for (BindingIter bi(*bindings, frameSlotStart(), /* isNamedLambda = */ false); bi; bi++) {
        name = bi.name();
        if (!bce->emitInitializeName(name, nop))
            return false;
    }

    if (!bce->emit1(JSOP_POP))
        return false;

    return true;
}

bool
BytecodeEmitter::EmitterScope::enterParameterExpressionVar(BytecodeEmitter* bce)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    if (!ensureCache(bce))
        return false;

    // Parameter expressions var scopes have no pre-set bindings and are
    // always extensible, as they are needed for eval.
    fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    // Create and intern the VM scope.
    uint32_t firstFrameSlot = frameSlotStart();
    auto createScope = [firstFrameSlot](ExclusiveContext* cx, HandleScope enclosing) {
        return VarScope::create(cx, ScopeKind::ParameterExpressionVar,
                                /* data = */ nullptr, firstFrameSlot,
                                /* needsEnvironment = */ true, enclosing);
    };
    if (!internScope(bce, createScope))
        return false;

    MOZ_ASSERT(hasEnvironment());
    if (!bce->emitInternedScopeOp(index(), JSOP_PUSHVARENV))
        return false;

    // The extra var scope needs a note to be mapped from a pc.
    if (!appendScopeNote(bce))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::enterFunction(BytecodeEmitter* bce, FunctionBox* funbox)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    // If there are parameter expressions, there is an extra var scope.
    if (!funbox->hasExtraBodyVarScope())
        bce->setVarEmitterScope(this);

    if (!ensureCache(bce))
        return false;

    // Resolve body-level bindings, if there are any.
    auto bindings = funbox->functionScopeBindings();
    Maybe<uint32_t> lastLexicalSlot;
    if (bindings) {
        NameLocationMap& cache = *nameCache_;

        BindingIter bi(*bindings, funbox->hasParameterExprs);
        for (; bi; bi++) {
            if (!checkSlotLimits(bce, bi))
                return false;

            NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
            NameLocationMap::AddPtr p = cache.lookupForAdd(bi.name());

            // The only duplicate bindings that occur are simple formal
            // parameters, in which case the last position counts, so update the
            // location.
            if (p) {
                MOZ_ASSERT(bi.kind() == BindingKind::FormalParameter);
                MOZ_ASSERT(!funbox->hasDestructuringArgs);
                MOZ_ASSERT(!funbox->function()->hasRest());
                p->value() = loc;
                continue;
            }

            if (!cache.add(p, bi.name(), loc)) {
                ReportOutOfMemory(bce->cx);
                return false;
            }
        }

        updateFrameFixedSlots(bce, bi);
    } else {
        nextFrameSlot_ = 0;
    }

    // If the function's scope may be extended at runtime due to sloppy direct
    // eval and there is no extra var scope, any names beyond the function
    // scope must be accessed dynamically as we don't know if the name will
    // become a 'var' binding due to direct eval.
    if (!funbox->hasParameterExprs && funbox->hasExtensibleScope())
        fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    // In case of parameter expressions, the parameters are lexical
    // bindings and have TDZ.
    if (funbox->hasParameterExprs && nextFrameSlot_) {
        uint32_t paramFrameSlotEnd = 0;
        for (BindingIter bi(*bindings, true); bi; bi++) {
            if (!BindingKindIsLexical(bi.kind()))
                break;

            NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
            if (loc.kind() == NameLocation::Kind::FrameSlot) {
                MOZ_ASSERT(paramFrameSlotEnd <= loc.frameSlot());
                paramFrameSlotEnd = loc.frameSlot() + 1;
            }
        }

        if (!deadZoneFrameSlotRange(bce, 0, paramFrameSlotEnd))
            return false;
    }

    // Create and intern the VM scope.
    auto createScope = [funbox](ExclusiveContext* cx, HandleScope enclosing) {
        RootedFunction fun(cx, funbox->function());
        return FunctionScope::create(cx, funbox->functionScopeBindings(),
                                     funbox->hasParameterExprs,
                                     funbox->needsCallObjectRegardlessOfBindings(),
                                     fun, enclosing);
    };
    if (!internBodyScope(bce, createScope))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::enterFunctionExtraBodyVar(BytecodeEmitter* bce, FunctionBox* funbox)
{
    MOZ_ASSERT(funbox->hasParameterExprs);
    MOZ_ASSERT(funbox->extraVarScopeBindings() ||
               funbox->needsExtraBodyVarEnvironmentRegardlessOfBindings());
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    // The extra var scope is never popped once it's entered. It replaces the
    // function scope as the var emitter scope.
    bce->setVarEmitterScope(this);

    if (!ensureCache(bce))
        return false;

    // Resolve body-level bindings, if there are any.
    uint32_t firstFrameSlot = frameSlotStart();
    if (auto bindings = funbox->extraVarScopeBindings()) {
        BindingIter bi(*bindings, firstFrameSlot);
        for (; bi; bi++) {
            if (!checkSlotLimits(bce, bi))
                return false;

            NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
            if (!putNameInCache(bce, bi.name(), loc))
                return false;
        }

        updateFrameFixedSlots(bce, bi);
    } else {
        nextFrameSlot_ = firstFrameSlot;
    }

    // If the extra var scope may be extended at runtime due to sloppy
    // direct eval, any names beyond the var scope must be accessed
    // dynamically as we don't know if the name will become a 'var' binding
    // due to direct eval.
    if (funbox->hasExtensibleScope())
        fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    // Create and intern the VM scope.
    auto createScope = [funbox, firstFrameSlot](ExclusiveContext* cx, HandleScope enclosing) {
        return VarScope::create(cx, ScopeKind::FunctionBodyVar,
                                funbox->extraVarScopeBindings(), firstFrameSlot,
                                funbox->needsExtraBodyVarEnvironmentRegardlessOfBindings(),
                                enclosing);
    };
    if (!internScope(bce, createScope))
        return false;

    if (hasEnvironment()) {
        if (!bce->emitInternedScopeOp(index(), JSOP_PUSHVARENV))
            return false;
    }

    // The extra var scope needs a note to be mapped from a pc.
    if (!appendScopeNote(bce))
        return false;

    return checkEnvironmentChainLength(bce);
}

class DynamicBindingIter : public BindingIter
{
  public:
    explicit DynamicBindingIter(GlobalSharedContext* sc)
      : BindingIter(*sc->bindings)
    { }

    explicit DynamicBindingIter(EvalSharedContext* sc)
      : BindingIter(*sc->bindings, /* strict = */ false)
    {
        MOZ_ASSERT(!sc->strict());
    }

    JSOp bindingOp() const {
        switch (kind()) {
          case BindingKind::Var:
            return JSOP_DEFVAR;
          case BindingKind::Let:
            return JSOP_DEFLET;
          case BindingKind::Const:
            return JSOP_DEFCONST;
          default:
            MOZ_CRASH("Bad BindingKind");
        }
    }
};

bool
BytecodeEmitter::EmitterScope::enterGlobal(BytecodeEmitter* bce, GlobalSharedContext* globalsc)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    bce->setVarEmitterScope(this);

    if (!ensureCache(bce))
        return false;

    if (bce->emitterMode == BytecodeEmitter::SelfHosting) {
        // In self-hosting, it is incorrect to consult the global scope because
        // self-hosted scripts are cloned into their target compartments before
        // they are run. Instead of Global, Intrinsic is used for all names.
        //
        // Intrinsic lookups are redirected to the special intrinsics holder
        // in the global object, into which any missing values are cloned
        // lazily upon first access.
        fallbackFreeNameLocation_ = Some(NameLocation::Intrinsic());

        auto createScope = [](ExclusiveContext* cx, HandleScope enclosing) {
            MOZ_ASSERT(!enclosing);
            return &cx->global()->emptyGlobalScope();
        };
        return internBodyScope(bce, createScope);
    }

    // Resolve binding names and emit DEF{VAR,LET,CONST} prologue ops.
    if (globalsc->bindings) {
        for (DynamicBindingIter bi(globalsc); bi; bi++) {
            NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
            JSAtom* name = bi.name();
            if (!putNameInCache(bce, name, loc))
                return false;

            // Define the name in the prologue. Do not emit DEFVAR for
            // functions that we'll emit DEFFUN for.
            if (bi.isTopLevelFunction())
                continue;

            if (!bce->emitAtomOp(name, bi.bindingOp()))
                return false;
        }
    }

    // Note that to save space, we don't add free names to the cache for
    // global scopes. They are assumed to be global vars in the syntactic
    // global scope, dynamic accesses under non-syntactic global scope.
    if (globalsc->scopeKind() == ScopeKind::Global)
        fallbackFreeNameLocation_ = Some(NameLocation::Global(BindingKind::Var));
    else
        fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    auto createScope = [globalsc](ExclusiveContext* cx, HandleScope enclosing) {
        MOZ_ASSERT(!enclosing);
        return GlobalScope::create(cx, globalsc->scopeKind(), globalsc->bindings);
    };
    return internBodyScope(bce, createScope);
}

bool
BytecodeEmitter::EmitterScope::enterEval(BytecodeEmitter* bce, EvalSharedContext* evalsc)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    bce->setVarEmitterScope(this);

    if (!ensureCache(bce))
        return false;

    // For simplicity, treat all free name lookups in eval scripts as dynamic.
    fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    // Create the `var` scope. Note that there is also a lexical scope, created
    // separately in emitScript().
    auto createScope = [evalsc](ExclusiveContext* cx, HandleScope enclosing) {
        ScopeKind scopeKind = evalsc->strict() ? ScopeKind::StrictEval : ScopeKind::Eval;
        return EvalScope::create(cx, scopeKind, evalsc->bindings, enclosing);
    };
    if (!internBodyScope(bce, createScope))
        return false;

    if (hasEnvironment()) {
        if (!bce->emitInternedScopeOp(index(), JSOP_PUSHVARENV))
            return false;
    } else {
        // Resolve binding names and emit DEFVAR prologue ops if we don't have
        // an environment (i.e., a sloppy eval not in a parameter expression).
        // Eval scripts always have their own lexical scope, but non-strict
        // scopes may introduce 'var' bindings to the nearest var scope.
        //
        // TODO: We may optimize strict eval bindings in the future to be on
        // the frame. For now, handle everything dynamically.
        if (!hasEnvironment() && evalsc->bindings) {
            for (DynamicBindingIter bi(evalsc); bi; bi++) {
                MOZ_ASSERT(bi.bindingOp() == JSOP_DEFVAR);

                if (bi.isTopLevelFunction())
                    continue;

                if (!bce->emitAtomOp(bi.name(), JSOP_DEFVAR))
                    return false;
            }
        }

        // As an optimization, if the eval does not have its own var
        // environment and is directly enclosed in a global scope, then all
        // free name lookups are global.
        if (scope(bce)->enclosing()->is<GlobalScope>())
            fallbackFreeNameLocation_ = Some(NameLocation::Global(BindingKind::Var));
    }

    return true;
}

bool
BytecodeEmitter::EmitterScope::enterModule(BytecodeEmitter* bce, ModuleSharedContext* modulesc)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    bce->setVarEmitterScope(this);

    if (!ensureCache(bce))
        return false;

    // Resolve body-level bindings, if there are any.
    TDZCheckCache* tdzCache = bce->innermostTDZCheckCache;
    Maybe<uint32_t> firstLexicalFrameSlot;
    if (ModuleScope::Data* bindings = modulesc->bindings) {
        BindingIter bi(*bindings);
        for (; bi; bi++) {
            if (!checkSlotLimits(bce, bi))
                return false;

            NameLocation loc = NameLocation::fromBinding(bi.kind(), bi.location());
            if (!putNameInCache(bce, bi.name(), loc))
                return false;

            if (BindingKindIsLexical(bi.kind())) {
                if (loc.kind() == NameLocation::Kind::FrameSlot && !firstLexicalFrameSlot)
                    firstLexicalFrameSlot = Some(loc.frameSlot());

                if (!tdzCache->noteTDZCheck(bce, bi.name(), CheckTDZ))
                    return false;
            }
        }

        updateFrameFixedSlots(bce, bi);
    } else {
        nextFrameSlot_ = 0;
    }

    // Modules are toplevel, so any free names are global.
    fallbackFreeNameLocation_ = Some(NameLocation::Global(BindingKind::Var));

    // Put lexical frame slots in TDZ. Environment slots are poisoned during
    // environment creation.
    if (firstLexicalFrameSlot) {
        if (!deadZoneFrameSlotRange(bce, *firstLexicalFrameSlot, frameSlotEnd()))
            return false;
    }

    // Create and intern the VM scope.
    auto createScope = [modulesc](ExclusiveContext* cx, HandleScope enclosing) {
        return ModuleScope::create(cx, modulesc->bindings, modulesc->module(), enclosing);
    };
    if (!internBodyScope(bce, createScope))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::enterWith(BytecodeEmitter* bce)
{
    MOZ_ASSERT(this == bce->innermostEmitterScope);

    if (!ensureCache(bce))
        return false;

    // 'with' make all accesses dynamic and unanalyzable.
    fallbackFreeNameLocation_ = Some(NameLocation::Dynamic());

    auto createScope = [](ExclusiveContext* cx, HandleScope enclosing) {
        return WithScope::create(cx, enclosing);
    };
    if (!internScope(bce, createScope))
        return false;

    if (!bce->emitInternedScopeOp(index(), JSOP_ENTERWITH))
        return false;

    if (!appendScopeNote(bce))
        return false;

    return checkEnvironmentChainLength(bce);
}

bool
BytecodeEmitter::EmitterScope::leave(BytecodeEmitter* bce, bool nonLocal)
{
    // If we aren't leaving the scope due to a non-local jump (e.g., break),
    // we must be the innermost scope.
    MOZ_ASSERT_IF(!nonLocal, this == bce->innermostEmitterScope);

    ScopeKind kind = scope(bce)->kind();
    switch (kind) {
      case ScopeKind::Lexical:
      case ScopeKind::SimpleCatch:
      case ScopeKind::Catch:
        if (!bce->emit1(hasEnvironment() ? JSOP_POPLEXICALENV : JSOP_DEBUGLEAVELEXICALENV))
            return false;
        break;

      case ScopeKind::With:
        if (!bce->emit1(JSOP_LEAVEWITH))
            return false;
        break;

      case ScopeKind::ParameterExpressionVar:
        MOZ_ASSERT(hasEnvironment());
        if (!bce->emit1(JSOP_POPVARENV))
            return false;
        break;

      case ScopeKind::Function:
      case ScopeKind::FunctionBodyVar:
      case ScopeKind::NamedLambda:
      case ScopeKind::StrictNamedLambda:
      case ScopeKind::Eval:
      case ScopeKind::StrictEval:
      case ScopeKind::Global:
      case ScopeKind::NonSyntactic:
      case ScopeKind::Module:
        break;
    }

    // Finish up the scope if we are leaving it in LIFO fashion.
    if (!nonLocal) {
        // Popping scopes due to non-local jumps generate additional scope
        // notes. See NonLocalExitControl::prepareForNonLocalJump.
        if (ScopeKindIsInBody(kind)) {
            // The extra function var scope is never popped once it's pushed,
            // so its scope note extends until the end of any possible code.
            uint32_t offset = kind == ScopeKind::FunctionBodyVar ? UINT32_MAX : bce->offset();
            bce->scopeNoteList.recordEnd(noteIndex_, offset, bce->inPrologue());
        }
    }

    return true;
}

Maybe<MaybeCheckTDZ>
BytecodeEmitter::TDZCheckCache::needsTDZCheck(BytecodeEmitter* bce, JSAtom* name)
{
    if (!ensureCache(bce))
        return Nothing();

    CheckTDZMap::AddPtr p = cache_->lookupForAdd(name);
    if (p)
        return Some(p->value().wrapped);

    MaybeCheckTDZ rv = CheckTDZ;
    for (TDZCheckCache* it = enclosing(); it; it = it->enclosing()) {
        if (it->cache_) {
            if (CheckTDZMap::Ptr p2 = it->cache_->lookup(name)) {
                rv = p2->value();
                break;
            }
        }
    }

    if (!cache_->add(p, name, rv)) {
        ReportOutOfMemory(bce->cx);
        return Nothing();
    }

    return Some(rv);
}

bool
BytecodeEmitter::TDZCheckCache::noteTDZCheck(BytecodeEmitter* bce, JSAtom* name,
                                             MaybeCheckTDZ check)
{
    if (!ensureCache(bce))
        return false;

    CheckTDZMap::AddPtr p = cache_->lookupForAdd(name);
    if (p) {
        MOZ_ASSERT(!check, "TDZ only needs to be checked once per binding per basic block.");
        p->value() = check;
    } else {
        if (!cache_->add(p, name, check))
            return false;
    }

    return true;
}

BytecodeEmitter::BytecodeEmitter(BytecodeEmitter* parent,
                                 Parser<FullParseHandler>* parser, SharedContext* sc,
                                 HandleScript script, Handle<LazyScript*> lazyScript,
                                 uint32_t lineNum, EmitterMode emitterMode)
  : sc(sc),
    cx(sc->context),
    parent(parent),
    script(cx, script),
    lazyScript(cx, lazyScript),
    prologue(cx, lineNum),
    main(cx, lineNum),
    current(&main),
    parser(parser),
    atomIndices(cx->frontendCollectionPool()),
    firstLine(lineNum),
    maxFixedSlots(0),
    maxStackDepth(0),
    stackDepth(0),
    arrayCompDepth(0),
    emitLevel(0),
    bodyScopeIndex(UINT32_MAX),
    varEmitterScope(nullptr),
    innermostNestableControl(nullptr),
    innermostEmitterScope(nullptr),
    innermostTDZCheckCache(nullptr),
    constList(cx),
    scopeList(cx),
    tryNoteList(cx),
    scopeNoteList(cx),
    yieldOffsetList(cx),
    typesetCount(0),
    hasSingletons(false),
    hasTryFinally(false),
    emittingRunOnceLambda(false),
    emitterMode(emitterMode),
    functionBodyEndPosSet(false)
{
    MOZ_ASSERT_IF(emitterMode == LazyFunction, lazyScript);
}

BytecodeEmitter::BytecodeEmitter(BytecodeEmitter* parent,
                                 Parser<FullParseHandler>* parser, SharedContext* sc,
                                 HandleScript script, Handle<LazyScript*> lazyScript,
                                 TokenPos bodyPosition, EmitterMode emitterMode)
    : BytecodeEmitter(parent, parser, sc, script, lazyScript,
                      parser->tokenStream.srcCoords.lineNum(bodyPosition.begin),
                      emitterMode)
{
    setFunctionBodyEndPos(bodyPosition);
}

bool
BytecodeEmitter::init()
{
    return atomIndices.acquire(cx);
}

template <typename Predicate /* (NestableControl*) -> bool */>
BytecodeEmitter::NestableControl*
BytecodeEmitter::findInnermostNestableControl(Predicate predicate) const
{
    return NestableControl::findNearest(innermostNestableControl, predicate);
}

template <typename T>
T*
BytecodeEmitter::findInnermostNestableControl() const
{
    return NestableControl::findNearest<T>(innermostNestableControl);
}

template <typename T, typename Predicate /* (T*) -> bool */>
T*
BytecodeEmitter::findInnermostNestableControl(Predicate predicate) const
{
    return NestableControl::findNearest<T>(innermostNestableControl, predicate);
}

NameLocation
BytecodeEmitter::lookupName(JSAtom* name)
{
    return innermostEmitterScope->lookup(this, name);
}

Maybe<NameLocation>
BytecodeEmitter::locationOfNameBoundInScope(JSAtom* name, EmitterScope* target)
{
    return innermostEmitterScope->locationBoundInScope(this, name, target);
}

Maybe<NameLocation>
BytecodeEmitter::locationOfNameBoundInFunctionScope(JSAtom* name, EmitterScope* source)
{
    EmitterScope* funScope = source;
    while (!funScope->scope(this)->is<FunctionScope>())
        funScope = funScope->enclosingInFrame();
    return source->locationBoundInScope(this, name, funScope);
}

bool
BytecodeEmitter::emitCheck(ptrdiff_t delta, ptrdiff_t* offset)
{
    *offset = code().length();

    // Start it off moderately large to avoid repeated resizings early on.
    // ~98% of cases fit within 1024 bytes.
    if (code().capacity() == 0 && !code().reserve(1024))
        return false;

    if (!code().growBy(delta)) {
        ReportOutOfMemory(cx);
        return false;
    }
    return true;
}

void
BytecodeEmitter::updateDepth(ptrdiff_t target)
{
    jsbytecode* pc = code(target);

    int nuses = StackUses(nullptr, pc);
    int ndefs = StackDefs(nullptr, pc);

    stackDepth -= nuses;
    MOZ_ASSERT(stackDepth >= 0);
    stackDepth += ndefs;

    if ((uint32_t)stackDepth > maxStackDepth)
        maxStackDepth = stackDepth;
}

#ifdef DEBUG
bool
BytecodeEmitter::checkStrictOrSloppy(JSOp op)
{
    if (IsCheckStrictOp(op) && !sc->strict())
        return false;
    if (IsCheckSloppyOp(op) && sc->strict())
        return false;
    return true;
}
#endif

bool
BytecodeEmitter::emit1(JSOp op)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));

    ptrdiff_t offset;
    if (!emitCheck(1, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emit2(JSOp op, uint8_t op1)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));

    ptrdiff_t offset;
    if (!emitCheck(2, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    code[1] = jsbytecode(op1);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emit3(JSOp op, jsbytecode op1, jsbytecode op2)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));

    /* These should filter through emitVarOp. */
    MOZ_ASSERT(!IsArgOp(op));
    MOZ_ASSERT(!IsLocalOp(op));

    ptrdiff_t offset;
    if (!emitCheck(3, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    code[1] = op1;
    code[2] = op2;
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emitN(JSOp op, size_t extra, ptrdiff_t* offset)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));
    ptrdiff_t length = 1 + ptrdiff_t(extra);

    ptrdiff_t off;
    if (!emitCheck(length, &off))
        return false;

    jsbytecode* code = this->code(off);
    code[0] = jsbytecode(op);
    /* The remaining |extra| bytes are set by the caller */

    /*
     * Don't updateDepth if op's use-count comes from the immediate
     * operand yet to be stored in the extra bytes after op.
     */
    if (CodeSpec[op].nuses >= 0)
        updateDepth(off);

    if (offset)
        *offset = off;
    return true;
}

bool
BytecodeEmitter::emitJumpTarget(JumpTarget* target)
{
    ptrdiff_t off = offset();

    // Alias consecutive jump targets.
    if (off == current->lastTarget.offset + ptrdiff_t(JSOP_JUMPTARGET_LENGTH)) {
        target->offset = current->lastTarget.offset;
        return true;
    }

    target->offset = off;
    current->lastTarget.offset = off;
    if (!emit1(JSOP_JUMPTARGET))
        return false;
    return true;
}

void
JumpList::push(jsbytecode* code, ptrdiff_t jumpOffset)
{
    SET_JUMP_OFFSET(&code[jumpOffset], offset - jumpOffset);
    offset = jumpOffset;
}

void
JumpList::patchAll(jsbytecode* code, JumpTarget target)
{
    ptrdiff_t delta;
    for (ptrdiff_t jumpOffset = offset; jumpOffset != -1; jumpOffset += delta) {
        jsbytecode* pc = &code[jumpOffset];
        MOZ_ASSERT(IsJumpOpcode(JSOp(*pc)) || JSOp(*pc) == JSOP_LABEL);
        delta = GET_JUMP_OFFSET(pc);
        MOZ_ASSERT(delta < 0);
        ptrdiff_t span = target.offset - jumpOffset;
        SET_JUMP_OFFSET(pc, span);
    }
}

bool
BytecodeEmitter::emitJumpNoFallthrough(JSOp op, JumpList* jump)
{
    ptrdiff_t offset;
    if (!emitCheck(5, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    MOZ_ASSERT(-1 <= jump->offset && jump->offset < offset);
    jump->push(this->code(0), offset);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emitJump(JSOp op, JumpList* jump)
{
    if (!emitJumpNoFallthrough(op, jump))
        return false;
    if (BytecodeFallsThrough(op)) {
        JumpTarget fallthrough;
        if (!emitJumpTarget(&fallthrough))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitBackwardJump(JSOp op, JumpTarget target, JumpList* jump, JumpTarget* fallthrough)
{
    if (!emitJumpNoFallthrough(op, jump))
        return false;
    patchJumpsToTarget(*jump, target);

    // Unconditionally create a fallthrough for closing iterators, and as a
    // target for break statements.
    if (!emitJumpTarget(fallthrough))
        return false;
    return true;
}

void
BytecodeEmitter::patchJumpsToTarget(JumpList jump, JumpTarget target)
{
    MOZ_ASSERT(-1 <= jump.offset && jump.offset <= offset());
    MOZ_ASSERT(0 <= target.offset && target.offset <= offset());
    MOZ_ASSERT_IF(jump.offset != -1 && target.offset + 4 <= offset(),
                  BytecodeIsJumpTarget(JSOp(*code(target.offset))));
    jump.patchAll(code(0), target);
}

bool
BytecodeEmitter::emitJumpTargetAndPatch(JumpList jump)
{
    if (jump.offset == -1)
        return true;
    JumpTarget target;
    if (!emitJumpTarget(&target))
        return false;
    patchJumpsToTarget(jump, target);
    return true;
}

bool
BytecodeEmitter::emitCall(JSOp op, uint16_t argc, ParseNode* pn)
{
    if (pn && !updateSourceCoordNotes(pn->pn_pos.begin))
        return false;
    return emit3(op, ARGC_HI(argc), ARGC_LO(argc));
}

bool
BytecodeEmitter::emitDupAt(unsigned slotFromTop)
{
    MOZ_ASSERT(slotFromTop < unsigned(stackDepth));

    if (slotFromTop >= JS_BIT(24)) {
        reportError(nullptr, JSMSG_TOO_MANY_LOCALS);
        return false;
    }

    ptrdiff_t off;
    if (!emitN(JSOP_DUPAT, 3, &off))
        return false;

    jsbytecode* pc = code(off);
    SET_UINT24(pc, slotFromTop);
    return true;
}

bool
BytecodeEmitter::emitCheckIsObj(CheckIsObjectKind kind)
{
    return emit2(JSOP_CHECKISOBJ, uint8_t(kind));
}

static inline unsigned
LengthOfSetLine(unsigned line)
{
    return 1 /* SN_SETLINE */ + (line > SN_4BYTE_OFFSET_MASK ? 4 : 1);
}

/* Updates line number notes, not column notes. */
bool
BytecodeEmitter::updateLineNumberNotes(uint32_t offset)
{
    TokenStream* ts = &parser->tokenStream;
    bool onThisLine;
    if (!ts->srcCoords.isOnThisLine(offset, currentLine(), &onThisLine))
        return ts->reportError(JSMSG_OUT_OF_MEMORY);
    if (!onThisLine) {
        unsigned line = ts->srcCoords.lineNum(offset);
        unsigned delta = line - currentLine();

        /*
         * Encode any change in the current source line number by using
         * either several SRC_NEWLINE notes or just one SRC_SETLINE note,
         * whichever consumes less space.
         *
         * NB: We handle backward line number deltas (possible with for
         * loops where the update part is emitted after the body, but its
         * line number is <= any line number in the body) here by letting
         * unsigned delta_ wrap to a very large number, which triggers a
         * SRC_SETLINE.
         */
        current->currentLine = line;
        current->lastColumn  = 0;
        if (delta >= LengthOfSetLine(line)) {
            if (!newSrcNote2(SRC_SETLINE, ptrdiff_t(line)))
                return false;
        } else {
            do {
                if (!newSrcNote(SRC_NEWLINE))
                    return false;
            } while (--delta != 0);
        }
    }
    return true;
}

/* Updates the line number and column number information in the source notes. */
bool
BytecodeEmitter::updateSourceCoordNotes(uint32_t offset)
{
    if (!updateLineNumberNotes(offset))
        return false;

    uint32_t columnIndex = parser->tokenStream.srcCoords.columnIndex(offset);
    ptrdiff_t colspan = ptrdiff_t(columnIndex) - ptrdiff_t(current->lastColumn);
    if (colspan != 0) {
        // If the column span is so large that we can't store it, then just
        // discard this information. This can happen with minimized or otherwise
        // machine-generated code. Even gigantic column numbers are still
        // valuable if you have a source map to relate them to something real;
        // but it's better to fail soft here.
        if (!SN_REPRESENTABLE_COLSPAN(colspan))
            return true;
        if (!newSrcNote2(SRC_COLSPAN, SN_COLSPAN_TO_OFFSET(colspan)))
            return false;
        current->lastColumn = columnIndex;
    }
    return true;
}

bool
BytecodeEmitter::emitLoopHead(ParseNode* nextpn, JumpTarget* top)
{
    if (nextpn) {
        /*
         * Try to give the JSOP_LOOPHEAD the same line number as the next
         * instruction. nextpn is often a block, in which case the next
         * instruction typically comes from the first statement inside.
         */
        if (nextpn->isKind(PNK_LEXICALSCOPE))
            nextpn = nextpn->scopeBody();
        MOZ_ASSERT_IF(nextpn->isKind(PNK_STATEMENTLIST), nextpn->isArity(PN_LIST));
        if (nextpn->isKind(PNK_STATEMENTLIST) && nextpn->pn_head)
            nextpn = nextpn->pn_head;
        if (!updateSourceCoordNotes(nextpn->pn_pos.begin))
            return false;
    }

    *top = { offset() };
    return emit1(JSOP_LOOPHEAD);
}

bool
BytecodeEmitter::emitLoopEntry(ParseNode* nextpn, JumpList entryJump)
{
    if (nextpn) {
        /* Update the line number, as for LOOPHEAD. */
        if (nextpn->isKind(PNK_LEXICALSCOPE))
            nextpn = nextpn->scopeBody();
        MOZ_ASSERT_IF(nextpn->isKind(PNK_STATEMENTLIST), nextpn->isArity(PN_LIST));
        if (nextpn->isKind(PNK_STATEMENTLIST) && nextpn->pn_head)
            nextpn = nextpn->pn_head;
        if (!updateSourceCoordNotes(nextpn->pn_pos.begin))
            return false;
    }

    JumpTarget entry{ offset() };
    patchJumpsToTarget(entryJump, entry);

    LoopControl& loopInfo = innermostNestableControl->as<LoopControl>();
    MOZ_ASSERT(loopInfo.loopDepth() > 0);

    uint8_t loopDepthAndFlags = PackLoopEntryDepthHintAndFlags(loopInfo.loopDepth(),
                                                               loopInfo.canIonOsr());
    return emit2(JSOP_LOOPENTRY, loopDepthAndFlags);
}

void
BytecodeEmitter::checkTypeSet(JSOp op)
{
    if (CodeSpec[op].format & JOF_TYPESET) {
        if (typesetCount < UINT16_MAX)
            typesetCount++;
    }
}

bool
BytecodeEmitter::emitUint16Operand(JSOp op, uint32_t operand)
{
    MOZ_ASSERT(operand <= UINT16_MAX);
    if (!emit3(op, UINT16_HI(operand), UINT16_LO(operand)))
        return false;
    checkTypeSet(op);
    return true;
}

bool
BytecodeEmitter::emitUint32Operand(JSOp op, uint32_t operand)
{
    ptrdiff_t off;
    if (!emitN(op, 4, &off))
        return false;
    SET_UINT32(code(off), operand);
    checkTypeSet(op);
    return true;
}

bool
BytecodeEmitter::flushPops(int* npops)
{
    MOZ_ASSERT(*npops != 0);
    if (!emitUint16Operand(JSOP_POPN, *npops))
        return false;

    *npops = 0;
    return true;
}

namespace {

class NonLocalExitControl {
    BytecodeEmitter* bce_;
    const uint32_t savedScopeNoteIndex_;
    const int savedDepth_;
    uint32_t openScopeNoteIndex_;

    NonLocalExitControl(const NonLocalExitControl&) = delete;

    MOZ_MUST_USE bool leaveScope(BytecodeEmitter::EmitterScope* scope);

  public:
    explicit NonLocalExitControl(BytecodeEmitter* bce)
      : bce_(bce),
        savedScopeNoteIndex_(bce->scopeNoteList.length()),
        savedDepth_(bce->stackDepth),
        openScopeNoteIndex_(bce->innermostEmitterScope->noteIndex())
    { }

    ~NonLocalExitControl() {
        for (uint32_t n = savedScopeNoteIndex_; n < bce_->scopeNoteList.length(); n++)
            bce_->scopeNoteList.recordEnd(n, bce_->offset(), bce_->inPrologue());
        bce_->stackDepth = savedDepth_;
    }

    MOZ_MUST_USE bool prepareForNonLocalJump(BytecodeEmitter::NestableControl* target);

    MOZ_MUST_USE bool prepareForNonLocalJumpToOutermost() {
        return prepareForNonLocalJump(nullptr);
    }
};

bool
NonLocalExitControl::leaveScope(BytecodeEmitter::EmitterScope* es)
{
    if (!es->leave(bce_, /* nonLocal = */ true))
        return false;

    // As we pop each scope due to the non-local jump, emit notes that
    // record the extent of the enclosing scope. These notes will have
    // their ends recorded in ~NonLocalExitControl().
    uint32_t enclosingScopeIndex = ScopeNote::NoScopeIndex;
    if (es->enclosingInFrame())
        enclosingScopeIndex = es->enclosingInFrame()->index();
    if (!bce_->scopeNoteList.append(enclosingScopeIndex, bce_->offset(), bce_->inPrologue(),
                                    openScopeNoteIndex_))
        return false;
    openScopeNoteIndex_ = bce_->scopeNoteList.length() - 1;

    return true;
}

/*
 * Emit additional bytecode(s) for non-local jumps.
 */
bool
NonLocalExitControl::prepareForNonLocalJump(BytecodeEmitter::NestableControl* target)
{
    using NestableControl = BytecodeEmitter::NestableControl;
    using EmitterScope = BytecodeEmitter::EmitterScope;

    EmitterScope* es = bce_->innermostEmitterScope;
    int npops = 0;

    auto flushPops = [&npops](BytecodeEmitter* bce) {
        if (npops && !bce->flushPops(&npops))
            return false;
        return true;
    };

    // Walk the nestable control stack and patch jumps.
    for (NestableControl* control = bce_->innermostNestableControl;
         control != target;
         control = control->enclosing())
    {
        // Walk the scope stack and leave the scopes we entered. Leaving a scope
        // may emit administrative ops like JSOP_POPLEXICALENV but never anything
        // that manipulates the stack.
        for (; es != control->emitterScope(); es = es->enclosingInFrame()) {
            if (!leaveScope(es))
                return false;
        }

        switch (control->kind()) {
          case StatementKind::Finally: {
            TryFinallyControl& finallyControl = control->as<TryFinallyControl>();
            if (finallyControl.emittingSubroutine()) {
                /*
                 * There's a [exception or hole, retsub pc-index] pair and the
                 * possible return value on the stack that we need to pop.
                 */
                npops += 3;
            } else {
                if (!flushPops(bce_))
                    return false;
                if (!bce_->emitJump(JSOP_GOSUB, &finallyControl.gosubs))
                    return false;
            }
            break;
          }

          case StatementKind::ForOfLoop:
            npops += 2;
            break;

          case StatementKind::ForInLoop:
            /* The iterator and the current value are on the stack. */
            npops += 1;
            if (!flushPops(bce_))
                return false;
            if (!bce_->emit1(JSOP_ENDITER))
                return false;
            break;

          default:
            break;
        }
    }

    EmitterScope* targetEmitterScope = target ? target->emitterScope() : bce_->varEmitterScope;
    for (; es != targetEmitterScope; es = es->enclosingInFrame()) {
        if (!leaveScope(es))
            return false;
    }

    return flushPops(bce_);
}

}  // anonymous namespace

bool
BytecodeEmitter::emitGoto(NestableControl* target, JumpList* jumplist, SrcNoteType noteType)
{
    NonLocalExitControl nle(this);

    if (!nle.prepareForNonLocalJump(target))
        return false;

    if (noteType != SRC_NULL) {
        if (!newSrcNote(noteType))
            return false;
    }

    return emitJump(JSOP_GOTO, jumplist);
}

Scope*
BytecodeEmitter::innermostScope() const
{
    return innermostEmitterScope->scope(this);
}

bool
BytecodeEmitter::emitIndex32(JSOp op, uint32_t index)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));

    const size_t len = 1 + UINT32_INDEX_LEN;
    MOZ_ASSERT(len == size_t(CodeSpec[op].length));

    ptrdiff_t offset;
    if (!emitCheck(len, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    SET_UINT32_INDEX(code, index);
    checkTypeSet(op);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emitIndexOp(JSOp op, uint32_t index)
{
    MOZ_ASSERT(checkStrictOrSloppy(op));

    const size_t len = CodeSpec[op].length;
    MOZ_ASSERT(len >= 1 + UINT32_INDEX_LEN);

    ptrdiff_t offset;
    if (!emitCheck(len, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = jsbytecode(op);
    SET_UINT32_INDEX(code, index);
    checkTypeSet(op);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::emitAtomOp(JSAtom* atom, JSOp op)
{
    MOZ_ASSERT(atom);
    MOZ_ASSERT(JOF_OPTYPE(op) == JOF_ATOM);

    // .generator lookups should be emitted as JSOP_GETALIASEDVAR instead of
    // JSOP_GETNAME etc, to bypass |with| objects on the scope chain.
    // It's safe to emit .this lookups though because |with| objects skip
    // those.
    MOZ_ASSERT_IF(op == JSOP_GETNAME || op == JSOP_GETGNAME,
                  atom != cx->names().dotGenerator);

    if (op == JSOP_GETPROP && atom == cx->names().length) {
        /* Specialize length accesses for the interpreter. */
        op = JSOP_LENGTH;
    }

    uint32_t index;
    if (!makeAtomIndex(atom, &index))
        return false;

    return emitIndexOp(op, index);
}

bool
BytecodeEmitter::emitAtomOp(ParseNode* pn, JSOp op)
{
    MOZ_ASSERT(pn->pn_atom != nullptr);
    return emitAtomOp(pn->pn_atom, op);
}

bool
BytecodeEmitter::emitInternedScopeOp(uint32_t index, JSOp op)
{
    MOZ_ASSERT(JOF_OPTYPE(op) == JOF_SCOPE);
    MOZ_ASSERT(index < scopeList.length());
    return emitIndex32(op, index);
}

bool
BytecodeEmitter::emitInternedObjectOp(uint32_t index, JSOp op)
{
    MOZ_ASSERT(JOF_OPTYPE(op) == JOF_OBJECT);
    MOZ_ASSERT(index < objectList.length);
    return emitIndex32(op, index);
}

bool
BytecodeEmitter::emitObjectOp(ObjectBox* objbox, JSOp op)
{
    return emitInternedObjectOp(objectList.add(objbox), op);
}

bool
BytecodeEmitter::emitObjectPairOp(ObjectBox* objbox1, ObjectBox* objbox2, JSOp op)
{
    uint32_t index = objectList.add(objbox1);
    objectList.add(objbox2);
    return emitInternedObjectOp(index, op);
}

bool
BytecodeEmitter::emitRegExp(uint32_t index)
{
    return emitIndex32(JSOP_REGEXP, index);
}

bool
BytecodeEmitter::emitLocalOp(JSOp op, uint32_t slot)
{
    MOZ_ASSERT(JOF_OPTYPE(op) != JOF_ENVCOORD);
    MOZ_ASSERT(IsLocalOp(op));

    ptrdiff_t off;
    if (!emitN(op, LOCALNO_LEN, &off))
        return false;

    SET_LOCALNO(code(off), slot);
    return true;
}

bool
BytecodeEmitter::emitArgOp(JSOp op, uint16_t slot)
{
    MOZ_ASSERT(IsArgOp(op));
    ptrdiff_t off;
    if (!emitN(op, ARGNO_LEN, &off))
        return false;

    SET_ARGNO(code(off), slot);
    return true;
}

bool
BytecodeEmitter::emitEnvCoordOp(JSOp op, EnvironmentCoordinate ec)
{
    MOZ_ASSERT(JOF_OPTYPE(op) == JOF_ENVCOORD);

    unsigned n = ENVCOORD_HOPS_LEN + ENVCOORD_SLOT_LEN;
    MOZ_ASSERT(int(n) + 1 /* op */ == CodeSpec[op].length);

    ptrdiff_t off;
    if (!emitN(op, n, &off))
        return false;

    jsbytecode* pc = code(off);
    SET_ENVCOORD_HOPS(pc, ec.hops());
    pc += ENVCOORD_HOPS_LEN;
    SET_ENVCOORD_SLOT(pc, ec.slot());
    pc += ENVCOORD_SLOT_LEN;
    checkTypeSet(op);
    return true;
}

static JSOp
GetIncDecInfo(ParseNodeKind kind, bool* post)
{
    MOZ_ASSERT(kind == PNK_POSTINCREMENT || kind == PNK_PREINCREMENT ||
               kind == PNK_POSTDECREMENT || kind == PNK_PREDECREMENT);
    *post = kind == PNK_POSTINCREMENT || kind == PNK_POSTDECREMENT;
    return (kind == PNK_POSTINCREMENT || kind == PNK_PREINCREMENT) ? JSOP_ADD : JSOP_SUB;
}

JSOp
BytecodeEmitter::strictifySetNameOp(JSOp op)
{
    switch (op) {
      case JSOP_SETNAME:
        if (sc->strict())
            op = JSOP_STRICTSETNAME;
        break;
      case JSOP_SETGNAME:
        if (sc->strict())
            op = JSOP_STRICTSETGNAME;
        break;
        default:;
    }
    return op;
}

bool
BytecodeEmitter::checkSideEffects(ParseNode* pn, bool* answer)
{
    JS_CHECK_RECURSION(cx, return false);

 restart:

    switch (pn->getKind()) {
      // Trivial cases with no side effects.
      case PNK_NOP:
      case PNK_STRING:
      case PNK_TEMPLATE_STRING:
      case PNK_REGEXP:
      case PNK_TRUE:
      case PNK_FALSE:
      case PNK_NULL:
      case PNK_ELISION:
      case PNK_GENERATOR:
      case PNK_NUMBER:
      case PNK_OBJECT_PROPERTY_NAME:
        MOZ_ASSERT(pn->isArity(PN_NULLARY));
        *answer = false;
        return true;

      // |this| can throw in derived class constructors, including nested arrow
      // functions or eval.
      case PNK_THIS:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = sc->needsThisTDZChecks();
        return true;

      // Trivial binary nodes with more token pos holders.
      case PNK_NEWTARGET:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        MOZ_ASSERT(pn->pn_left->isKind(PNK_POSHOLDER));
        MOZ_ASSERT(pn->pn_right->isKind(PNK_POSHOLDER));
        *answer = false;
        return true;

      case PNK_BREAK:
      case PNK_CONTINUE:
      case PNK_DEBUGGER:
        MOZ_ASSERT(pn->isArity(PN_NULLARY));
        *answer = true;
        return true;

      // Watch out for getters!
      case PNK_DOT:
        MOZ_ASSERT(pn->isArity(PN_NAME));
        *answer = true;
        return true;

      // Unary cases with side effects only if the child has them.
      case PNK_TYPEOFEXPR:
      case PNK_VOID:
      case PNK_NOT:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        return checkSideEffects(pn->pn_kid, answer);

      // Even if the name expression is effect-free, performing ToPropertyKey on
      // it might not be effect-free:
      //
      //   RegExp.prototype.toString = () => { throw 42; };
      //   ({ [/regex/]: 0 }); // ToPropertyKey(/regex/) throws 42
      //
      //   function Q() {
      //     ({ [new.target]: 0 });
      //   }
      //   Q.toString = () => { throw 17; };
      //   new Q; // new.target will be Q, ToPropertyKey(Q) throws 17
      case PNK_COMPUTED_NAME:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // Looking up or evaluating the associated name could throw.
      case PNK_TYPEOFNAME:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // These unary cases have side effects on the enclosing object/array,
      // sure.  But that's not the question this function answers: it's
      // whether the operation may have a side effect on something *other* than
      // the result of the overall operation in which it's embedded.  The
      // answer to that is no, for an object literal having a mutated prototype
      // and an array comprehension containing no other effectful operations
      // only produce a value, without affecting anything else.
      case PNK_MUTATEPROTO:
      case PNK_ARRAYPUSH:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        return checkSideEffects(pn->pn_kid, answer);

      // Unary cases with obvious side effects.
      case PNK_PREINCREMENT:
      case PNK_POSTINCREMENT:
      case PNK_PREDECREMENT:
      case PNK_POSTDECREMENT:
      case PNK_THROW:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // These might invoke valueOf/toString, even with a subexpression without
      // side effects!  Consider |+{ valueOf: null, toString: null }|.
      case PNK_BITNOT:
      case PNK_POS:
      case PNK_NEG:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // This invokes the (user-controllable) iterator protocol.
      case PNK_SPREAD:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      case PNK_YIELD_STAR:
      case PNK_YIELD:
      case PNK_AWAIT:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      // Deletion generally has side effects, even if isolated cases have none.
      case PNK_DELETENAME:
      case PNK_DELETEPROP:
      case PNK_DELETEELEM:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // Deletion of a non-Reference expression has side effects only through
      // evaluating the expression.
      case PNK_DELETEEXPR: {
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        ParseNode* expr = pn->pn_kid;
        return checkSideEffects(expr, answer);
      }

      case PNK_SEMI:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        if (ParseNode* expr = pn->pn_kid)
            return checkSideEffects(expr, answer);
        *answer = false;
        return true;

      // Binary cases with obvious side effects.
      case PNK_ASSIGN:
      case PNK_ADDASSIGN:
      case PNK_SUBASSIGN:
      case PNK_BITORASSIGN:
      case PNK_BITXORASSIGN:
      case PNK_BITANDASSIGN:
      case PNK_LSHASSIGN:
      case PNK_RSHASSIGN:
      case PNK_URSHASSIGN:
      case PNK_MULASSIGN:
      case PNK_DIVASSIGN:
      case PNK_MODASSIGN:
      case PNK_POWASSIGN:
      case PNK_SETTHIS:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      case PNK_STATEMENTLIST:
      case PNK_CATCHLIST:
      // Strict equality operations and logical operators are well-behaved and
      // perform no conversions.
      case PNK_OR:
      case PNK_AND:
      case PNK_STRICTEQ:
      case PNK_STRICTNE:
      // Any subexpression of a comma expression could be effectful.
      case PNK_COMMA:
        MOZ_ASSERT(pn->pn_count > 0);
        MOZ_FALLTHROUGH;
      // Subcomponents of a literal may be effectful.
      case PNK_ARRAY:
      case PNK_OBJECT:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        for (ParseNode* item = pn->pn_head; item; item = item->pn_next) {
            if (!checkSideEffects(item, answer))
                return false;
            if (*answer)
                return true;
        }
        return true;

      // Most other binary operations (parsed as lists in SpiderMonkey) may
      // perform conversions triggering side effects.  Math operations perform
      // ToNumber and may fail invoking invalid user-defined toString/valueOf:
      // |5 < { toString: null }|.  |instanceof| throws if provided a
      // non-object constructor: |null instanceof null|.  |in| throws if given
      // a non-object RHS: |5 in null|.
      case PNK_BITOR:
      case PNK_BITXOR:
      case PNK_BITAND:
      case PNK_EQ:
      case PNK_NE:
      case PNK_LT:
      case PNK_LE:
      case PNK_GT:
      case PNK_GE:
      case PNK_INSTANCEOF:
      case PNK_IN:
      case PNK_LSH:
      case PNK_RSH:
      case PNK_URSH:
      case PNK_ADD:
      case PNK_SUB:
      case PNK_STAR:
      case PNK_DIV:
      case PNK_MOD:
      case PNK_POW:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        MOZ_ASSERT(pn->pn_count >= 2);
        *answer = true;
        return true;

      case PNK_COLON:
      case PNK_CASE:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        if (!checkSideEffects(pn->pn_left, answer))
            return false;
        if (*answer)
            return true;
        return checkSideEffects(pn->pn_right, answer);

      // More getters.
      case PNK_ELEM:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      // These affect visible names in this code, or in other code.
      case PNK_IMPORT:
      case PNK_EXPORT_FROM:
      case PNK_EXPORT_DEFAULT:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      // Likewise.
      case PNK_EXPORT:
        MOZ_ASSERT(pn->isArity(PN_UNARY));
        *answer = true;
        return true;

      // Every part of a loop might be effect-free, but looping infinitely *is*
      // an effect.  (Language lawyer trivia: C++ says threads can be assumed
      // to exit or have side effects, C++14 [intro.multithread]p27, so a C++
      // implementation's equivalent of the below could set |*answer = false;|
      // if all loop sub-nodes set |*answer = false|!)
      case PNK_DOWHILE:
      case PNK_WHILE:
      case PNK_FOR:
      case PNK_COMPREHENSIONFOR:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      // Declarations affect the name set of the relevant scope.
      case PNK_VAR:
      case PNK_CONST:
      case PNK_LET:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        *answer = true;
        return true;

      case PNK_IF:
      case PNK_CONDITIONAL:
        MOZ_ASSERT(pn->isArity(PN_TERNARY));
        if (!checkSideEffects(pn->pn_kid1, answer))
            return false;
        if (*answer)
            return true;
        if (!checkSideEffects(pn->pn_kid2, answer))
            return false;
        if (*answer)
            return true;
        if ((pn = pn->pn_kid3))
            goto restart;
        return true;

      // Function calls can invoke non-local code.
      case PNK_NEW:
      case PNK_CALL:
      case PNK_TAGGED_TEMPLATE:
      case PNK_SUPERCALL:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        *answer = true;
        return true;

      // Classes typically introduce names.  Even if no name is introduced,
      // the heritage and/or class body (through computed property names)
      // usually have effects.
      case PNK_CLASS:
        MOZ_ASSERT(pn->isArity(PN_TERNARY));
        *answer = true;
        return true;

      // |with| calls |ToObject| on its expression and so throws if that value
      // is null/undefined.
      case PNK_WITH:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      case PNK_RETURN:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      case PNK_NAME:
        MOZ_ASSERT(pn->isArity(PN_NAME));
        *answer = true;
        return true;

      // Shorthands could trigger getters: the |x| in the object literal in
      // |with ({ get x() { throw 42; } }) ({ x });|, for example, triggers
      // one.  (Of course, it isn't necessary to use |with| for a shorthand to
      // trigger a getter.)
      case PNK_SHORTHAND:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        *answer = true;
        return true;

      case PNK_FUNCTION:
        MOZ_ASSERT(pn->isArity(PN_CODE));
        /*
         * A named function, contrary to ES3, is no longer effectful, because
         * we bind its name lexically (using JSOP_CALLEE) instead of creating
         * an Object instance and binding a readonly, permanent property in it
         * (the object and binding can be detected and hijacked or captured).
         * This is a bug fix to ES3; it is fixed in ES3.1 drafts.
         */
        *answer = false;
        return true;

      case PNK_MODULE:
        *answer = false;
        return true;

      // Generator expressions have no side effects on their own.
      case PNK_GENEXP:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        *answer = false;
        return true;

      case PNK_TRY:
        MOZ_ASSERT(pn->isArity(PN_TERNARY));
        if (!checkSideEffects(pn->pn_kid1, answer))
            return false;
        if (*answer)
            return true;
        if (ParseNode* catchList = pn->pn_kid2) {
            MOZ_ASSERT(catchList->isKind(PNK_CATCHLIST));
            if (!checkSideEffects(catchList, answer))
                return false;
            if (*answer)
                return true;
        }
        if (ParseNode* finallyBlock = pn->pn_kid3) {
            if (!checkSideEffects(finallyBlock, answer))
                return false;
        }
        return true;

      case PNK_CATCH:
        MOZ_ASSERT(pn->isArity(PN_TERNARY));
        if (!checkSideEffects(pn->pn_kid1, answer))
            return false;
        if (*answer)
            return true;
        if (ParseNode* cond = pn->pn_kid2) {
            if (!checkSideEffects(cond, answer))
                return false;
            if (*answer)
                return true;
        }
        return checkSideEffects(pn->pn_kid3, answer);

      case PNK_SWITCH:
        MOZ_ASSERT(pn->isArity(PN_BINARY));
        if (!checkSideEffects(pn->pn_left, answer))
            return false;
        return *answer || checkSideEffects(pn->pn_right, answer);

      case PNK_LABEL:
        MOZ_ASSERT(pn->isArity(PN_NAME));
        return checkSideEffects(pn->expr(), answer);

      case PNK_LEXICALSCOPE:
        MOZ_ASSERT(pn->isArity(PN_SCOPE));
        return checkSideEffects(pn->scopeBody(), answer);

      // We could methodically check every interpolated expression, but it's
      // probably not worth the trouble.  Treat template strings as effect-free
      // only if they don't contain any substitutions.
      case PNK_TEMPLATE_STRING_LIST:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        MOZ_ASSERT(pn->pn_count > 0);
        MOZ_ASSERT((pn->pn_count % 2) == 1,
                   "template strings must alternate template and substitution "
                   "parts");
        *answer = pn->pn_count > 1;
        return true;

      case PNK_ARRAYCOMP:
        MOZ_ASSERT(pn->isArity(PN_LIST));
        MOZ_ASSERT(pn->pn_count == 1);
        return checkSideEffects(pn->pn_head, answer);

      // This should be unreachable but is left as-is for now.
      case PNK_PARAMSBODY:
        *answer = true;
        return true;

      case PNK_FORIN:           // by PNK_FOR/PNK_COMPREHENSIONFOR
      case PNK_FOROF:           // by PNK_FOR/PNK_COMPREHENSIONFOR
      case PNK_FORHEAD:         // by PNK_FOR/PNK_COMPREHENSIONFOR
      case PNK_CLASSMETHOD:     // by PNK_CLASS
      case PNK_CLASSNAMES:      // by PNK_CLASS
      case PNK_CLASSMETHODLIST: // by PNK_CLASS
      case PNK_IMPORT_SPEC_LIST: // by PNK_IMPORT
      case PNK_IMPORT_SPEC:      // by PNK_IMPORT
      case PNK_EXPORT_BATCH_SPEC:// by PNK_EXPORT
      case PNK_EXPORT_SPEC_LIST: // by PNK_EXPORT
      case PNK_EXPORT_SPEC:      // by PNK_EXPORT
      case PNK_CALLSITEOBJ:      // by PNK_TAGGED_TEMPLATE
      case PNK_POSHOLDER:        // by PNK_NEWTARGET
      case PNK_SUPERBASE:        // by PNK_ELEM and others
        MOZ_CRASH("handled by parent nodes");

      case PNK_LIMIT: // invalid sentinel value
        MOZ_CRASH("invalid node kind");
    }

    MOZ_CRASH("invalid, unenumerated ParseNodeKind value encountered in "
              "BytecodeEmitter::checkSideEffects");
}

bool
BytecodeEmitter::isInLoop()
{
    return findInnermostNestableControl<LoopControl>();
}

bool
BytecodeEmitter::checkSingletonContext()
{
    if (!script->treatAsRunOnce() || sc->isFunctionBox() || isInLoop())
        return false;
    hasSingletons = true;
    return true;
}

bool
BytecodeEmitter::checkRunOnceContext()
{
    return checkSingletonContext() || (!isInLoop() && isRunOnceLambda());
}

bool
BytecodeEmitter::needsImplicitThis()
{
    // Short-circuit if there is an enclosing 'with' scope.
    if (sc->inWith())
        return true;

    // Otherwise see if the current point is under a 'with'.
    for (EmitterScope* es = innermostEmitterScope; es; es = es->enclosingInFrame()) {
        if (es->scope(this)->kind() == ScopeKind::With)
            return true;
    }

    return false;
}

bool
BytecodeEmitter::maybeSetDisplayURL()
{
    if (tokenStream()->hasDisplayURL()) {
        if (!parser->ss->setDisplayURL(cx, tokenStream()->displayURL()))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::maybeSetSourceMap()
{
    if (tokenStream()->hasSourceMapURL()) {
        MOZ_ASSERT(!parser->ss->hasSourceMapURL());
        if (!parser->ss->setSourceMapURL(cx, tokenStream()->sourceMapURL()))
            return false;
    }

    /*
     * Source map URLs passed as a compile option (usually via a HTTP source map
     * header) override any source map urls passed as comment pragmas.
     */
    if (parser->options().sourceMapURL()) {
        // Warn about the replacement, but use the new one.
        if (parser->ss->hasSourceMapURL()) {
            if(!parser->report(ParseWarning, false, nullptr, JSMSG_ALREADY_HAS_PRAGMA,
                               parser->ss->filename(), "//# sourceMappingURL"))
                return false;
        }

        if (!parser->ss->setSourceMapURL(cx, parser->options().sourceMapURL()))
            return false;
    }

    return true;
}

void
BytecodeEmitter::tellDebuggerAboutCompiledScript(ExclusiveContext* cx)
{
    // Note: when parsing off thread the resulting scripts need to be handed to
    // the debugger after rejoining to the main thread.
    if (!cx->isJSContext())
        return;

    // Lazy scripts are never top level (despite always being invoked with a
    // nullptr parent), and so the hook should never be fired.
    if (emitterMode != LazyFunction && !parent) {
        Debugger::onNewScript(cx->asJSContext(), script);
    }
}

inline TokenStream*
BytecodeEmitter::tokenStream()
{
    return &parser->tokenStream;
}

bool
BytecodeEmitter::reportError(ParseNode* pn, unsigned errorNumber, ...)
{
    TokenPos pos = pn ? pn->pn_pos : tokenStream()->currentToken().pos;

    va_list args;
    va_start(args, errorNumber);
    bool result = tokenStream()->reportCompileErrorNumberVA(pos.begin, JSREPORT_ERROR,
                                                            errorNumber, args);
    va_end(args);
    return result;
}

bool
BytecodeEmitter::reportStrictWarning(ParseNode* pn, unsigned errorNumber, ...)
{
    TokenPos pos = pn ? pn->pn_pos : tokenStream()->currentToken().pos;

    va_list args;
    va_start(args, errorNumber);
    bool result = tokenStream()->reportStrictWarningErrorNumberVA(pos.begin, errorNumber, args);
    va_end(args);
    return result;
}

bool
BytecodeEmitter::reportStrictModeError(ParseNode* pn, unsigned errorNumber, ...)
{
    TokenPos pos = pn ? pn->pn_pos : tokenStream()->currentToken().pos;

    va_list args;
    va_start(args, errorNumber);
    bool result = tokenStream()->reportStrictModeErrorNumberVA(pos.begin, sc->strict(),
                                                               errorNumber, args);
    va_end(args);
    return result;
}

bool
BytecodeEmitter::emitNewInit(JSProtoKey key)
{
    const size_t len = 1 + UINT32_INDEX_LEN;
    ptrdiff_t offset;
    if (!emitCheck(len, &offset))
        return false;

    jsbytecode* code = this->code(offset);
    code[0] = JSOP_NEWINIT;
    code[1] = jsbytecode(key);
    code[2] = 0;
    code[3] = 0;
    code[4] = 0;
    checkTypeSet(JSOP_NEWINIT);
    updateDepth(offset);
    return true;
}

bool
BytecodeEmitter::iteratorResultShape(unsigned* shape)
{
    // No need to do any guessing for the object kind, since we know exactly how
    // many properties we plan to have.
    gc::AllocKind kind = gc::GetGCObjectKind(2);
    RootedPlainObject obj(cx, NewBuiltinClassInstance<PlainObject>(cx, kind, TenuredObject));
    if (!obj)
        return false;

    Rooted<jsid> value_id(cx, AtomToId(cx->names().value));
    Rooted<jsid> done_id(cx, AtomToId(cx->names().done));
    if (!NativeDefineProperty(cx, obj, value_id, UndefinedHandleValue, nullptr, nullptr,
                              JSPROP_ENUMERATE))
    {
        return false;
    }
    if (!NativeDefineProperty(cx, obj, done_id, UndefinedHandleValue, nullptr, nullptr,
                              JSPROP_ENUMERATE))
    {
        return false;
    }

    ObjectBox* objbox = parser->newObjectBox(obj);
    if (!objbox)
        return false;

    *shape = objectList.add(objbox);

    return true;
}

bool
BytecodeEmitter::emitPrepareIteratorResult()
{
    unsigned shape;
    if (!iteratorResultShape(&shape))
        return false;
    return emitIndex32(JSOP_NEWOBJECT, shape);
}

bool
BytecodeEmitter::emitFinishIteratorResult(bool done)
{
    uint32_t value_id;
    if (!makeAtomIndex(cx->names().value, &value_id))
        return false;
    uint32_t done_id;
    if (!makeAtomIndex(cx->names().done, &done_id))
        return false;

    if (!emitIndex32(JSOP_INITPROP, value_id))
        return false;
    if (!emit1(done ? JSOP_TRUE : JSOP_FALSE))
        return false;
    if (!emitIndex32(JSOP_INITPROP, done_id))
        return false;
    return true;
}

bool
BytecodeEmitter::emitGetNameAtLocation(JSAtom* name, const NameLocation& loc, bool callContext)
{
    switch (loc.kind()) {
      case NameLocation::Kind::Dynamic:
        if (!emitAtomOp(name, JSOP_GETNAME))
            return false;
        break;

      case NameLocation::Kind::Global:
        if (!emitAtomOp(name, JSOP_GETGNAME))
            return false;
        break;

      case NameLocation::Kind::Intrinsic:
        if (!emitAtomOp(name, JSOP_GETINTRINSIC))
            return false;
        break;

      case NameLocation::Kind::NamedLambdaCallee:
        if (!emit1(JSOP_CALLEE))
            return false;
        break;

      case NameLocation::Kind::Import:
        if (!emitAtomOp(name, JSOP_GETIMPORT))
            return false;
        break;

      case NameLocation::Kind::ArgumentSlot:
        if (!emitArgOp(JSOP_GETARG, loc.argumentSlot()))
            return false;
        break;

      case NameLocation::Kind::FrameSlot:
        if (loc.isLexical()) {
            if (!emitTDZCheckIfNeeded(name, loc))
                return false;
        }
        if (!emitLocalOp(JSOP_GETLOCAL, loc.frameSlot()))
            return false;
        break;

      case NameLocation::Kind::EnvironmentCoordinate:
        if (loc.isLexical()) {
            if (!emitTDZCheckIfNeeded(name, loc))
                return false;
        }
        if (!emitEnvCoordOp(JSOP_GETALIASEDVAR, loc.environmentCoordinate()))
            return false;
        break;

      case NameLocation::Kind::DynamicAnnexBVar:
        MOZ_CRASH("Synthesized vars for Annex B.3.3 should only be used in initialization");
    }

    // Need to provide |this| value for call.
    if (callContext) {
        switch (loc.kind()) {
          case NameLocation::Kind::Dynamic: {
            JSOp thisOp = needsImplicitThis() ? JSOP_IMPLICITTHIS : JSOP_GIMPLICITTHIS;
            if (!emitAtomOp(name, thisOp))
                return false;
            break;
          }

          case NameLocation::Kind::Global:
            if (!emitAtomOp(name, JSOP_GIMPLICITTHIS))
                return false;
            break;

          case NameLocation::Kind::Intrinsic:
          case NameLocation::Kind::NamedLambdaCallee:
          case NameLocation::Kind::Import:
          case NameLocation::Kind::ArgumentSlot:
          case NameLocation::Kind::FrameSlot:
          case NameLocation::Kind::EnvironmentCoordinate:
            if (!emit1(JSOP_UNDEFINED))
                return false;
            break;

          case NameLocation::Kind::DynamicAnnexBVar:
            MOZ_CRASH("Synthesized vars for Annex B.3.3 should only be used in initialization");
        }
    }

    return true;
}

bool
BytecodeEmitter::emitGetName(ParseNode* pn, bool callContext)
{
    return emitGetName(pn->name(), callContext);
}

template <typename RHSEmitter>
bool
BytecodeEmitter::emitSetOrInitializeNameAtLocation(HandleAtom name, const NameLocation& loc,
                                                   RHSEmitter emitRhs, bool initialize)
{
    bool emittedBindOp = false;

    switch (loc.kind()) {
      case NameLocation::Kind::Dynamic:
      case NameLocation::Kind::Import:
      case NameLocation::Kind::DynamicAnnexBVar: {
        uint32_t atomIndex;
        if (!makeAtomIndex(name, &atomIndex))
            return false;
        if (loc.kind() == NameLocation::Kind::DynamicAnnexBVar) {
            // Annex B vars always go on the nearest variable environment,
            // even if lexical environments in between contain same-named
            // bindings.
            if (!emit1(JSOP_BINDVAR))
                return false;
        } else {
            if (!emitIndexOp(JSOP_BINDNAME, atomIndex))
                return false;
        }
        emittedBindOp = true;
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (!emitIndexOp(strictifySetNameOp(JSOP_SETNAME), atomIndex))
            return false;
        break;
      }

      case NameLocation::Kind::Global: {
        JSOp op;
        uint32_t atomIndex;
        if (!makeAtomIndex(name, &atomIndex))
            return false;
        if (loc.isLexical() && initialize) {
            // INITGLEXICAL always gets the global lexical scope. It doesn't
            // need a BINDGNAME.
            MOZ_ASSERT(innermostScope()->is<GlobalScope>());
            op = JSOP_INITGLEXICAL;
        } else {
            if (!emitIndexOp(JSOP_BINDGNAME, atomIndex))
                return false;
            emittedBindOp = true;
            op = strictifySetNameOp(JSOP_SETGNAME);
        }
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (!emitIndexOp(op, atomIndex))
            return false;
        break;
      }

      case NameLocation::Kind::Intrinsic:
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (!emitAtomOp(name, JSOP_SETINTRINSIC))
            return false;
        break;

      case NameLocation::Kind::NamedLambdaCallee:
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        // Assigning to the named lambda is a no-op in sloppy mode but
        // throws in strict mode.
        if (sc->strict() && !emit1(JSOP_THROWSETCALLEE))
            return false;
        break;

      case NameLocation::Kind::ArgumentSlot: {
        // If we assign to a positional formal parameter and the arguments
        // object is unmapped (strict mode or function with
        // default/rest/destructing args), parameters do not alias
        // arguments[i], and to make the arguments object reflect initial
        // parameter values prior to any mutation we create it eagerly
        // whenever parameters are (or might, in the case of calls to eval)
        // assigned.
        FunctionBox* funbox = sc->asFunctionBox();
        if (funbox->argumentsHasLocalBinding() && !funbox->hasMappedArgsObj())
            funbox->setDefinitelyNeedsArgsObj();

        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (!emitArgOp(JSOP_SETARG, loc.argumentSlot()))
            return false;
        break;
      }

      case NameLocation::Kind::FrameSlot: {
        JSOp op = JSOP_SETLOCAL;
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (loc.isLexical()) {
            if (initialize) {
                op = JSOP_INITLEXICAL;
            } else {
                if (loc.isConst())
                    op = JSOP_THROWSETCONST;

                if (!emitTDZCheckIfNeeded(name, loc))
                    return false;
            }
        }
        if (!emitLocalOp(op, loc.frameSlot()))
            return false;
        if (op == JSOP_INITLEXICAL) {
            if (!innermostTDZCheckCache->noteTDZCheck(this, name, DontCheckTDZ))
                return false;
        }
        break;
      }

      case NameLocation::Kind::EnvironmentCoordinate: {
        JSOp op = JSOP_SETALIASEDVAR;
        if (!emitRhs(this, loc, emittedBindOp))
            return false;
        if (loc.isLexical()) {
            if (initialize) {
                op = JSOP_INITALIASEDLEXICAL;
            } else {
                if (loc.isConst())
                    op = JSOP_THROWSETALIASEDCONST;

                if (!emitTDZCheckIfNeeded(name, loc))
                    return false;
            }
        }
        if (loc.bindingKind() == BindingKind::NamedLambdaCallee) {
            // Assigning to the named lambda is a no-op in sloppy mode and throws
            // in strict mode.
            op = JSOP_THROWSETALIASEDCONST;
            if (sc->strict() && !emitEnvCoordOp(op, loc.environmentCoordinate()))
                return false;
        } else {
            if (!emitEnvCoordOp(op, loc.environmentCoordinate()))
                return false;
        }
        if (op == JSOP_INITALIASEDLEXICAL) {
            if (!innermostTDZCheckCache->noteTDZCheck(this, name, DontCheckTDZ))
                return false;
        }
        break;
      }
    }

    return true;
}

bool
BytecodeEmitter::emitTDZCheckIfNeeded(JSAtom* name, const NameLocation& loc)
{
    // Dynamic accesses have TDZ checks built into their VM code and should
    // never emit explicit TDZ checks.
    MOZ_ASSERT(loc.hasKnownSlot());
    MOZ_ASSERT(loc.isLexical());

    Maybe<MaybeCheckTDZ> check = innermostTDZCheckCache->needsTDZCheck(this, name);
    if (!check)
        return false;

    // We've already emitted a check in this basic block.
    if (*check == DontCheckTDZ)
        return true;

    if (loc.kind() == NameLocation::Kind::FrameSlot) {
        if (!emitLocalOp(JSOP_CHECKLEXICAL, loc.frameSlot()))
            return false;
    } else {
        if (!emitEnvCoordOp(JSOP_CHECKALIASEDLEXICAL, loc.environmentCoordinate()))
            return false;
    }

    return innermostTDZCheckCache->noteTDZCheck(this, name, DontCheckTDZ);
}

bool
BytecodeEmitter::emitPropLHS(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_DOT));
    MOZ_ASSERT(!pn->as<PropertyAccess>().isSuper());

    ParseNode* pn2 = pn->pn_expr;

    /*
     * If the object operand is also a dotted property reference, reverse the
     * list linked via pn_expr temporarily so we can iterate over it from the
     * bottom up (reversing again as we go), to avoid excessive recursion.
     */
    if (pn2->isKind(PNK_DOT) && !pn2->as<PropertyAccess>().isSuper()) {
        ParseNode* pndot = pn2;
        ParseNode* pnup = nullptr;
        ParseNode* pndown;
        for (;;) {
            /* Reverse pndot->pn_expr to point up, not down. */
            pndown = pndot->pn_expr;
            pndot->pn_expr = pnup;
            if (!pndown->isKind(PNK_DOT) || pndown->as<PropertyAccess>().isSuper())
                break;
            pnup = pndot;
            pndot = pndown;
        }

        /* pndown is a primary expression, not a dotted property reference. */
        if (!emitTree(pndown))
            return false;

        do {
            /* Walk back up the list, emitting annotated name ops. */
            if (!emitAtomOp(pndot, JSOP_GETPROP))
                return false;

            /* Reverse the pn_expr link again. */
            pnup = pndot->pn_expr;
            pndot->pn_expr = pndown;
            pndown = pndot;
        } while ((pndot = pnup) != nullptr);
        return true;
    }

    // The non-optimized case.
    return emitTree(pn2);
}

bool
BytecodeEmitter::emitSuperPropLHS(ParseNode* superBase, bool isCall)
{
    if (!emitGetThisForSuperBase(superBase))
        return false;
    if (isCall && !emit1(JSOP_DUP))
        return false;
    if (!emit1(JSOP_SUPERBASE))
        return false;
    return true;
}

bool
BytecodeEmitter::emitPropOp(ParseNode* pn, JSOp op)
{
    MOZ_ASSERT(pn->isArity(PN_NAME));

    if (!emitPropLHS(pn))
        return false;

    if (op == JSOP_CALLPROP && !emit1(JSOP_DUP))
        return false;

    if (!emitAtomOp(pn, op))
        return false;

    if (op == JSOP_CALLPROP && !emit1(JSOP_SWAP))
        return false;

    return true;
}

bool
BytecodeEmitter::emitSuperPropOp(ParseNode* pn, JSOp op, bool isCall)
{
    ParseNode* base = &pn->as<PropertyAccess>().expression();
    if (!emitSuperPropLHS(base, isCall))
        return false;

    if (!emitAtomOp(pn, op))
        return false;

    if (isCall && !emit1(JSOP_SWAP))
        return false;

    return true;
}

bool
BytecodeEmitter::emitPropIncDec(ParseNode* pn)
{
    MOZ_ASSERT(pn->pn_kid->isKind(PNK_DOT));

    bool post;
    bool isSuper = pn->pn_kid->as<PropertyAccess>().isSuper();
    JSOp binop = GetIncDecInfo(pn->getKind(), &post);

    if (isSuper) {
        ParseNode* base = &pn->pn_kid->as<PropertyAccess>().expression();
        if (!emitSuperPropLHS(base))                // THIS OBJ
            return false;
        if (!emit1(JSOP_DUP2))                      // THIS OBJ THIS OBJ
            return false;
    } else {
        if (!emitPropLHS(pn->pn_kid))               // OBJ
            return false;
        if (!emit1(JSOP_DUP))                       // OBJ OBJ
            return false;
    }
    if (!emitAtomOp(pn->pn_kid, isSuper? JSOP_GETPROP_SUPER : JSOP_GETPROP)) // OBJ V
        return false;
    if (!emit1(JSOP_POS))                           // OBJ N
        return false;
    if (post && !emit1(JSOP_DUP))                   // OBJ N? N
        return false;
    if (!emit1(JSOP_ONE))                           // OBJ N? N 1
        return false;
    if (!emit1(binop))                              // OBJ N? N+1
        return false;

    if (post) {
        if (!emit2(JSOP_PICK, 2 + isSuper))        // N? N+1 OBJ
            return false;
        if (!emit1(JSOP_SWAP))                     // N? OBJ N+1
            return false;
        if (isSuper) {
            if (!emit2(JSOP_PICK, 3))              // N THIS N+1 OBJ
                return false;
            if (!emit1(JSOP_SWAP))                 // N THIS OBJ N+1
                return false;
        }
    }

    JSOp setOp = isSuper ? sc->strict() ? JSOP_STRICTSETPROP_SUPER : JSOP_SETPROP_SUPER
                         : sc->strict() ? JSOP_STRICTSETPROP : JSOP_SETPROP;
    if (!emitAtomOp(pn->pn_kid, setOp))             // N? N+1
        return false;
    if (post && !emit1(JSOP_POP))                   // RESULT
        return false;

    return true;
}

bool
BytecodeEmitter::emitNameIncDec(ParseNode* pn)
{
    MOZ_ASSERT(pn->pn_kid->isKind(PNK_NAME));

    bool post;
    JSOp binop = GetIncDecInfo(pn->getKind(), &post);

    auto emitRhs = [pn, post, binop](BytecodeEmitter* bce, const NameLocation& loc,
                                     bool emittedBindOp)
    {
        JSAtom* name = pn->pn_kid->name();
        if (!bce->emitGetNameAtLocation(name, loc, false)) // SCOPE? V
            return false;
        if (!bce->emit1(JSOP_POS))                         // SCOPE? N
            return false;
        if (post && !bce->emit1(JSOP_DUP))                 // SCOPE? N? N
            return false;
        if (!bce->emit1(JSOP_ONE))                         // SCOPE? N? N 1
            return false;
        if (!bce->emit1(binop))                            // SCOPE? N? N+1
            return false;

        if (post && emittedBindOp) {
            if (!bce->emit2(JSOP_PICK, 2))                 // N? N+1 SCOPE?
                return false;
            if (!bce->emit1(JSOP_SWAP))                    // N? SCOPE? N+1
                return false;
        }

        return true;
    };

    if (!emitSetName(pn->pn_kid, emitRhs))
        return false;

    if (post && !emit1(JSOP_POP))
        return false;

    return true;
}

bool
BytecodeEmitter::emitElemOperands(ParseNode* pn, EmitElemOption opts)
{
    MOZ_ASSERT(pn->isArity(PN_BINARY));

    if (!emitTree(pn->pn_left))
        return false;

    if (opts == EmitElemOption::IncDec) {
        if (!emit1(JSOP_CHECKOBJCOERCIBLE))
            return false;
    } else if (opts == EmitElemOption::Call) {
        if (!emit1(JSOP_DUP))
            return false;
    }

    if (!emitTree(pn->pn_right))
        return false;

    if (opts == EmitElemOption::Set) {
        if (!emit2(JSOP_PICK, 2))
            return false;
    } else if (opts == EmitElemOption::IncDec || opts == EmitElemOption::CompoundAssign) {
        if (!emit1(JSOP_TOID))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitSuperElemOperands(ParseNode* pn, EmitElemOption opts)
{
    MOZ_ASSERT(pn->isKind(PNK_ELEM) && pn->as<PropertyByValue>().isSuper());

    // The ordering here is somewhat screwy. We need to evaluate the propval
    // first, by spec. Do a little dance to not emit more than one JSOP_THIS.
    // Since JSOP_THIS might throw in derived class constructors, we cannot
    // just push it earlier as the receiver. We have to swap it down instead.

    if (!emitTree(pn->pn_right))
        return false;

    // We need to convert the key to an object id first, so that we do not do
    // it inside both the GETELEM and the SETELEM.
    if (opts == EmitElemOption::IncDec || opts == EmitElemOption::CompoundAssign) {
        if (!emit1(JSOP_TOID))
            return false;
    }

    if (!emitGetThisForSuperBase(pn->pn_left))
        return false;

    if (opts == EmitElemOption::Call) {
        if (!emit1(JSOP_SWAP))
            return false;

        // We need another |this| on top, also
        if (!emitDupAt(1))
            return false;
    }

    if (!emit1(JSOP_SUPERBASE))
        return false;

    if (opts == EmitElemOption::Set && !emit2(JSOP_PICK, 3))
        return false;

    return true;
}

bool
BytecodeEmitter::emitElemOpBase(JSOp op)
{
    if (!emit1(op))
        return false;

    checkTypeSet(op);
    return true;
}

bool
BytecodeEmitter::emitElemOp(ParseNode* pn, JSOp op)
{
    EmitElemOption opts = EmitElemOption::Get;
    if (op == JSOP_CALLELEM)
        opts = EmitElemOption::Call;
    else if (op == JSOP_SETELEM || op == JSOP_STRICTSETELEM)
        opts = EmitElemOption::Set;

    return emitElemOperands(pn, opts) && emitElemOpBase(op);
}

bool
BytecodeEmitter::emitSuperElemOp(ParseNode* pn, JSOp op, bool isCall)
{
    EmitElemOption opts = EmitElemOption::Get;
    if (isCall)
        opts = EmitElemOption::Call;
    else if (op == JSOP_SETELEM_SUPER || op == JSOP_STRICTSETELEM_SUPER)
        opts = EmitElemOption::Set;

    if (!emitSuperElemOperands(pn, opts))
        return false;
    if (!emitElemOpBase(op))
        return false;

    if (isCall && !emit1(JSOP_SWAP))
        return false;

    return true;
}

bool
BytecodeEmitter::emitElemIncDec(ParseNode* pn)
{
    MOZ_ASSERT(pn->pn_kid->isKind(PNK_ELEM));

    bool isSuper = pn->pn_kid->as<PropertyByValue>().isSuper();

    // We need to convert the key to an object id first, so that we do not do
    // it inside both the GETELEM and the SETELEM. This is done by
    // emit(Super)ElemOperands.
    if (isSuper) {
        if (!emitSuperElemOperands(pn->pn_kid, EmitElemOption::IncDec))
            return false;
    } else {
        if (!emitElemOperands(pn->pn_kid, EmitElemOption::IncDec))
            return false;
    }

    bool post;
    JSOp binop = GetIncDecInfo(pn->getKind(), &post);

    JSOp getOp;
    if (isSuper) {
        // There's no such thing as JSOP_DUP3, so we have to be creative.
        // Note that pushing things again is no fewer JSOps.
        if (!emitDupAt(2))                              // KEY THIS OBJ KEY
            return false;
        if (!emitDupAt(2))                              // KEY THIS OBJ KEY THIS
            return false;
        if (!emitDupAt(2))                              // KEY THIS OBJ KEY THIS OBJ
            return false;
        getOp = JSOP_GETELEM_SUPER;
    } else {
                                                        // OBJ KEY
        if (!emit1(JSOP_DUP2))                          // OBJ KEY OBJ KEY
            return false;
        getOp = JSOP_GETELEM;
    }
    if (!emitElemOpBase(getOp))                         // OBJ KEY V
        return false;
    if (!emit1(JSOP_POS))                               // OBJ KEY N
        return false;
    if (post && !emit1(JSOP_DUP))                       // OBJ KEY N? N
        return false;
    if (!emit1(JSOP_ONE))                               // OBJ KEY N? N 1
        return false;
    if (!emit1(binop))                                  // OBJ KEY N? N+1
        return false;

    if (post) {
        if (isSuper) {
            // We have one more value to rotate around, because of |this|
            // on the stack
            if (!emit2(JSOP_PICK, 4))
                return false;
        }
        if (!emit2(JSOP_PICK, 3 + isSuper))             // KEY N N+1 OBJ
            return false;
        if (!emit2(JSOP_PICK, 3 + isSuper))             // N N+1 OBJ KEY
            return false;
        if (!emit2(JSOP_PICK, 2 + isSuper))             // N OBJ KEY N+1
            return false;
    }

    JSOp setOp = isSuper ? (sc->strict() ? JSOP_STRICTSETELEM_SUPER : JSOP_SETELEM_SUPER)
                         : (sc->strict() ? JSOP_STRICTSETELEM : JSOP_SETELEM);
    if (!emitElemOpBase(setOp))                         // N? N+1
        return false;
    if (post && !emit1(JSOP_POP))                       // RESULT
        return false;

    return true;
}

bool
BytecodeEmitter::emitCallIncDec(ParseNode* incDec)
{
    MOZ_ASSERT(incDec->isKind(PNK_PREINCREMENT) ||
               incDec->isKind(PNK_POSTINCREMENT) ||
               incDec->isKind(PNK_PREDECREMENT) ||
               incDec->isKind(PNK_POSTDECREMENT));

    MOZ_ASSERT(incDec->pn_kid->isKind(PNK_CALL));

    ParseNode* call = incDec->pn_kid;
    if (!emitTree(call))                                // CALLRESULT
        return false;
    if (!emit1(JSOP_POS))                               // N
        return false;

    // The increment/decrement has no side effects, so proceed to throw for
    // invalid assignment target.
    return emitUint16Operand(JSOP_THROWMSG, JSMSG_BAD_LEFTSIDE_OF_ASS);
}

bool
BytecodeEmitter::emitNumberOp(double dval)
{
    int32_t ival;
    if (NumberIsInt32(dval, &ival)) {
        if (ival == 0)
            return emit1(JSOP_ZERO);
        if (ival == 1)
            return emit1(JSOP_ONE);
        if ((int)(int8_t)ival == ival)
            return emit2(JSOP_INT8, uint8_t(int8_t(ival)));

        uint32_t u = uint32_t(ival);
        if (u < JS_BIT(16)) {
            if (!emitUint16Operand(JSOP_UINT16, u))
                return false;
        } else if (u < JS_BIT(24)) {
            ptrdiff_t off;
            if (!emitN(JSOP_UINT24, 3, &off))
                return false;
            SET_UINT24(code(off), u);
        } else {
            ptrdiff_t off;
            if (!emitN(JSOP_INT32, 4, &off))
                return false;
            SET_INT32(code(off), ival);
        }
        return true;
    }

    if (!constList.append(DoubleValue(dval)))
        return false;

    return emitIndex32(JSOP_DOUBLE, constList.length() - 1);
}

/*
 * Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047.
 * LLVM is deciding to inline this function which uses a lot of stack space
 * into emitTree which is recursive and uses relatively little stack space.
 */
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitSwitch(ParseNode* pn)
{
    ParseNode* cases = pn->pn_right;
    MOZ_ASSERT(cases->isKind(PNK_LEXICALSCOPE) || cases->isKind(PNK_STATEMENTLIST));

    // Emit code for the discriminant.
    if (!emitTree(pn->pn_left))
        return false;

    // Enter the scope before pushing the switch BreakableControl since all
    // breaks are under this scope.
    Maybe<TDZCheckCache> tdzCache;
    Maybe<EmitterScope> emitterScope;
    if (cases->isKind(PNK_LEXICALSCOPE)) {
        if (!cases->isEmptyScope()) {
            tdzCache.emplace(this);
            emitterScope.emplace(this);
            if (!emitterScope->enterLexical(this, ScopeKind::Lexical, cases->scopeBindings()))
                return false;
        }

        // Advance |cases| to refer to the switch case list.
        cases = cases->scopeBody();

        // A switch statement may contain hoisted functions inside its
        // cases. The PNX_FUNCDEFS flag is propagated from the STATEMENTLIST
        // bodies of the cases to the case list.
        if (cases->pn_xflags & PNX_FUNCDEFS) {
            MOZ_ASSERT(emitterScope);
            for (ParseNode* caseNode = cases->pn_head; caseNode; caseNode = caseNode->pn_next) {
                if (caseNode->pn_right->pn_xflags & PNX_FUNCDEFS) {
                    if (!emitHoistedFunctionsInList(caseNode->pn_right))
                        return false;
                }
            }
        }
    }

    // After entering the scope, push the switch control.
    BreakableControl controlInfo(this, StatementKind::Switch);

    ptrdiff_t top = offset();

    // Switch bytecodes run from here till end of final case.
    uint32_t caseCount = cases->pn_count;
    if (caseCount > JS_BIT(16)) {
        parser->tokenStream.reportError(JSMSG_TOO_MANY_CASES);
        return false;
    }

    // Try for most optimal, fall back if not dense ints.
    JSOp switchOp = JSOP_TABLESWITCH;
    uint32_t tableLength = 0;
    int32_t low, high;
    bool hasDefault = false;
    CaseClause* firstCase = cases->pn_head ? &cases->pn_head->as<CaseClause>() : nullptr;
    if (caseCount == 0 ||
        (caseCount == 1 && (hasDefault = firstCase->isDefault())))
    {
        caseCount = 0;
        low = 0;
        high = -1;
    } else {
        Vector<jsbitmap, 128, SystemAllocPolicy> intmap;
        int32_t intmapBitLength = 0;

        low  = JSVAL_INT_MAX;
        high = JSVAL_INT_MIN;

        for (CaseClause* caseNode = firstCase; caseNode; caseNode = caseNode->next()) {
            if (caseNode->isDefault()) {
                hasDefault = true;
                caseCount--;  // one of the "cases" was the default
                continue;
            }

            if (switchOp == JSOP_CONDSWITCH)
                continue;

            MOZ_ASSERT(switchOp == JSOP_TABLESWITCH);

            ParseNode* caseValue = caseNode->caseExpression();

            if (caseValue->getKind() != PNK_NUMBER) {
                switchOp = JSOP_CONDSWITCH;
                continue;
            }

            int32_t i;
            if (!NumberIsInt32(caseValue->pn_dval, &i)) {
                switchOp = JSOP_CONDSWITCH;
                continue;
            }

            if (unsigned(i + int(JS_BIT(15))) >= unsigned(JS_BIT(16))) {
                switchOp = JSOP_CONDSWITCH;
                continue;
            }
            if (i < low)
                low = i;
            if (i > high)
                high = i;

            // Check for duplicates, which require a JSOP_CONDSWITCH.
            // We bias i by 65536 if it's negative, and hope that's a rare
            // case (because it requires a malloc'd bitmap).
            if (i < 0)
                i += JS_BIT(16);
            if (i >= intmapBitLength) {
                size_t newLength = (i / JS_BITMAP_NBITS) + 1;
                if (!intmap.resize(newLength))
                    return false;
                intmapBitLength = newLength * JS_BITMAP_NBITS;
            }
            if (JS_TEST_BIT(intmap, i)) {
                switchOp = JSOP_CONDSWITCH;
                continue;
            }
            JS_SET_BIT(intmap, i);
        }

        // Compute table length and select condswitch instead if overlarge or
        // more than half-sparse.
        if (switchOp == JSOP_TABLESWITCH) {
            tableLength = uint32_t(high - low + 1);
            if (tableLength >= JS_BIT(16) || tableLength > 2 * caseCount)
                switchOp = JSOP_CONDSWITCH;
        }
    }

    // The note has one or two offsets: first tells total switch code length;
    // second (if condswitch) tells offset to first JSOP_CASE.
    unsigned noteIndex;
    size_t switchSize;
    if (switchOp == JSOP_CONDSWITCH) {
        // 0 bytes of immediate for unoptimized switch.
        switchSize = 0;
        if (!newSrcNote3(SRC_CONDSWITCH, 0, 0, &noteIndex))
            return false;
    } else {
        MOZ_ASSERT(switchOp == JSOP_TABLESWITCH);

        // 3 offsets (len, low, high) before the table, 1 per entry.
        switchSize = size_t(JUMP_OFFSET_LEN * (3 + tableLength));
        if (!newSrcNote2(SRC_TABLESWITCH, 0, &noteIndex))
            return false;
    }

    // Emit switchOp followed by switchSize bytes of jump or lookup table.
    MOZ_ASSERT(top == offset());
    if (!emitN(switchOp, switchSize))
        return false;

    Vector<CaseClause*, 32, SystemAllocPolicy> table;

    JumpList condSwitchDefaultOff;
    if (switchOp == JSOP_CONDSWITCH) {
        unsigned caseNoteIndex;
        bool beforeCases = true;
        ptrdiff_t lastCaseOffset = -1;

        // The case conditions need their own TDZ cache since they might not
        // all execute.
        TDZCheckCache tdzCache(this);

        // Emit code for evaluating cases and jumping to case statements.
        for (CaseClause* caseNode = firstCase; caseNode; caseNode = caseNode->next()) {
            ParseNode* caseValue = caseNode->caseExpression();

            // If the expression is a literal, suppress line number emission so
            // that debugging works more naturally.
            if (caseValue) {
                if (!emitTree(caseValue,
                              caseValue->isLiteral() ? SUPPRESS_LINENOTE : EMIT_LINENOTE))
                {
                    return false;
                }
            }

            if (!beforeCases) {
                // prevCase is the previous JSOP_CASE's bytecode offset.
                if (!setSrcNoteOffset(caseNoteIndex, 0, offset() - lastCaseOffset))
                    return false;
            }
            if (!caseValue) {
                // This is the default clause.
                continue;
            }

            if (!newSrcNote2(SRC_NEXTCASE, 0, &caseNoteIndex))
                return false;

            // The case clauses are produced before any of the case body. The
            // JumpList is saved on the parsed tree, then later restored and
            // patched when generating the cases body.
            JumpList caseJump;
            if (!emitJump(JSOP_CASE, &caseJump))
                return false;
            caseNode->setOffset(caseJump.offset);
            lastCaseOffset = caseJump.offset;

            if (beforeCases) {
                // Switch note's second offset is to first JSOP_CASE.
                unsigned noteCount = notes().length();
                if (!setSrcNoteOffset(noteIndex, 1, lastCaseOffset - top))
                    return false;
                unsigned noteCountDelta = notes().length() - noteCount;
                if (noteCountDelta != 0)
                    caseNoteIndex += noteCountDelta;
                beforeCases = false;
            }
        }

        // If we didn't have an explicit default (which could fall in between
        // cases, preventing us from fusing this setSrcNoteOffset with the call
        // in the loop above), link the last case to the implicit default for
        // the benefit of IonBuilder.
        if (!hasDefault &&
            !beforeCases &&
            !setSrcNoteOffset(caseNoteIndex, 0, offset() - lastCaseOffset))
        {
            return false;
        }

        // Emit default even if no explicit default statement.
        if (!emitJump(JSOP_DEFAULT, &condSwitchDefaultOff))
            return false;
    } else {
        MOZ_ASSERT(switchOp == JSOP_TABLESWITCH);

        // skip default offset.
        jsbytecode* pc = code(top + JUMP_OFFSET_LEN);

        // Fill in switch bounds, which we know fit in 16-bit offsets.
        SET_JUMP_OFFSET(pc, low);
        pc += JUMP_OFFSET_LEN;
        SET_JUMP_OFFSET(pc, high);
        pc += JUMP_OFFSET_LEN;

        if (tableLength != 0) {
            if (!table.growBy(tableLength))
                return false;

            for (CaseClause* caseNode = firstCase; caseNode; caseNode = caseNode->next()) {
                if (ParseNode* caseValue = caseNode->caseExpression()) {
                    MOZ_ASSERT(caseValue->isKind(PNK_NUMBER));

                    int32_t i = int32_t(caseValue->pn_dval);
                    MOZ_ASSERT(double(i) == caseValue->pn_dval);

                    i -= low;
                    MOZ_ASSERT(uint32_t(i) < tableLength);
                    MOZ_ASSERT(!table[i]);
                    table[i] = caseNode;
                }
            }
        }
    }

    JumpTarget defaultOffset{ -1 };

    // Emit code for each case's statements.
    for (CaseClause* caseNode = firstCase; caseNode; caseNode = caseNode->next()) {
        if (switchOp == JSOP_CONDSWITCH && !caseNode->isDefault()) {
            // The case offset got saved in the caseNode structure after
            // emitting the JSOP_CASE jump instruction above.
            JumpList caseCond;
            caseCond.offset = caseNode->offset();
            if (!emitJumpTargetAndPatch(caseCond))
                return false;
        }

        JumpTarget here;
        if (!emitJumpTarget(&here))
            return false;
        if (caseNode->isDefault())
            defaultOffset = here;

        // If this is emitted as a TABLESWITCH, we'll need to know this case's
        // offset later when emitting the table. Store it in the node's
        // pn_offset (giving the field a different meaning vs. how we used it
        // on the immediately preceding line of code).
        caseNode->setOffset(here.offset);

        TDZCheckCache tdzCache(this);

        if (!emitTree(caseNode->statementList()))
            return false;
    }

    if (!hasDefault) {
        // If no default case, offset for default is to end of switch.
        if (!emitJumpTarget(&defaultOffset))
            return false;
    }
    MOZ_ASSERT(defaultOffset.offset != -1);

    // Set the default offset (to end of switch if no default).
    jsbytecode* pc;
    if (switchOp == JSOP_CONDSWITCH) {
        pc = nullptr;
        patchJumpsToTarget(condSwitchDefaultOff, defaultOffset);
    } else {
        MOZ_ASSERT(switchOp == JSOP_TABLESWITCH);
        pc = code(top);
        SET_JUMP_OFFSET(pc, defaultOffset.offset - top);
        pc += JUMP_OFFSET_LEN;
    }

    // Set the SRC_SWITCH note's offset operand to tell end of switch.
    if (!setSrcNoteOffset(noteIndex, 0, lastNonJumpTargetOffset() - top))
        return false;

    if (switchOp == JSOP_TABLESWITCH) {
        // Skip over the already-initialized switch bounds.
        pc += 2 * JUMP_OFFSET_LEN;

        // Fill in the jump table, if there is one.
        for (uint32_t i = 0; i < tableLength; i++) {
            CaseClause* caseNode = table[i];
            ptrdiff_t off = caseNode ? caseNode->offset() - top : 0;
            SET_JUMP_OFFSET(pc, off);
            pc += JUMP_OFFSET_LEN;
        }
    }

    // Patch breaks before leaving the scope, as all breaks are under the
    // lexical scope if it exists.
    if (!controlInfo.patchBreaks(this))
        return false;

    if (emitterScope && !emitterScope->leave(this))
        return false;

    return true;
}

bool
BytecodeEmitter::isRunOnceLambda()
{
    // The run once lambda flags set by the parser are approximate, and we look
    // at properties of the function itself before deciding to emit a function
    // as a run once lambda.

    if (!(parent && parent->emittingRunOnceLambda) &&
        (emitterMode != LazyFunction || !lazyScript->treatAsRunOnce()))
    {
        return false;
    }

    FunctionBox* funbox = sc->asFunctionBox();
    return !funbox->argumentsHasLocalBinding() &&
           !funbox->isGenerator() &&
           !funbox->function()->name();
}

bool
BytecodeEmitter::emitYieldOp(JSOp op)
{
    if (op == JSOP_FINALYIELDRVAL)
        return emit1(JSOP_FINALYIELDRVAL);

    MOZ_ASSERT(op == JSOP_INITIALYIELD || op == JSOP_YIELD);

    ptrdiff_t off;
    if (!emitN(op, 3, &off))
        return false;

    uint32_t yieldIndex = yieldOffsetList.length();
    if (yieldIndex >= JS_BIT(24)) {
        reportError(nullptr, JSMSG_TOO_MANY_YIELDS);
        return false;
    }

    SET_UINT24(code(off), yieldIndex);

    if (!yieldOffsetList.append(offset()))
        return false;

    return emit1(JSOP_DEBUGAFTERYIELD);
}

bool
BytecodeEmitter::emitSetThis(ParseNode* pn)
{
    // PNK_SETTHIS is used to update |this| after a super() call in a derived
    // class constructor.

    MOZ_ASSERT(pn->isKind(PNK_SETTHIS));
    MOZ_ASSERT(pn->pn_left->isKind(PNK_NAME));

    RootedAtom name(cx, pn->pn_left->name());
    auto emitRhs = [&name, pn](BytecodeEmitter* bce, const NameLocation&, bool) {
        // Emit the new |this| value.
        if (!bce->emitTree(pn->pn_right))
            return false;
        // Get the original |this| and throw if we already initialized
        // it. Do *not* use the NameLocation argument, as that's the special
        // lexical location below to deal with super() semantics.
        if (!bce->emitGetName(name))
            return false;
        if (!bce->emit1(JSOP_CHECKTHISREINIT))
            return false;
        if (!bce->emit1(JSOP_POP))
            return false;
        return true;
    };

    // The 'this' binding is not lexical, but due to super() semantics this
    // initialization needs to be treated as a lexical one.
    NameLocation loc = lookupName(name);
    NameLocation lexicalLoc;
    if (loc.kind() == NameLocation::Kind::FrameSlot) {
        lexicalLoc = NameLocation::FrameSlot(BindingKind::Let, loc.frameSlot());
    } else if (loc.kind() == NameLocation::Kind::EnvironmentCoordinate) {
        EnvironmentCoordinate coord = loc.environmentCoordinate();
        uint8_t hops = AssertedCast<uint8_t>(coord.hops());
        lexicalLoc = NameLocation::EnvironmentCoordinate(BindingKind::Let, hops, coord.slot());
    } else {
        MOZ_ASSERT(loc.kind() == NameLocation::Kind::Dynamic);
        lexicalLoc = loc;
    }

    return emitSetOrInitializeNameAtLocation(name, lexicalLoc, emitRhs, true);
}

bool
BytecodeEmitter::emitScript(ParseNode* body)
{
    TDZCheckCache tdzCache(this);
    EmitterScope emitterScope(this);
    if (sc->isGlobalContext()) {
        switchToPrologue();
        if (!emitterScope.enterGlobal(this, sc->asGlobalContext()))
            return false;
        switchToMain();
    } else if (sc->isEvalContext()) {
        switchToPrologue();
        if (!emitterScope.enterEval(this, sc->asEvalContext()))
            return false;
        switchToMain();
    } else {
        MOZ_ASSERT(sc->isModuleContext());
        if (!emitterScope.enterModule(this, sc->asModuleContext()))
            return false;
    }

    setFunctionBodyEndPos(body->pn_pos);

    if (sc->isEvalContext() && !sc->strict() &&
        body->isKind(PNK_LEXICALSCOPE) && !body->isEmptyScope())
    {
        // Sloppy eval scripts may need to emit DEFFUNs in the prologue. If there is
        // an immediately enclosed lexical scope, we need to enter the lexical
        // scope in the prologue for the DEFFUNs to pick up the right
        // environment chain.
        EmitterScope lexicalEmitterScope(this);

        switchToPrologue();
        if (!lexicalEmitterScope.enterLexical(this, ScopeKind::Lexical, body->scopeBindings()))
            return false;
        switchToMain();

        if (!emitLexicalScopeBody(body->scopeBody()))
            return false;

        if (!lexicalEmitterScope.leave(this))
            return false;
    } else {
        if (!emitTree(body))
            return false;
    }

    if (!emit1(JSOP_RETRVAL))
        return false;

    if (!emitterScope.leave(this))
        return false;

    if (!JSScript::fullyInitFromEmitter(cx, script, this))
        return false;

    // URL and source map information must be set before firing
    // Debugger::onNewScript.
    if (!maybeSetDisplayURL() || !maybeSetSourceMap())
        return false;

    tellDebuggerAboutCompiledScript(cx);

    return true;
}

bool
BytecodeEmitter::emitFunctionScript(ParseNode* body)
{
    FunctionBox* funbox = sc->asFunctionBox();

    // The ordering of these EmitterScopes is important. The named lambda
    // scope needs to enclose the function scope needs to enclose the extra
    // var scope.

    Maybe<EmitterScope> namedLambdaEmitterScope;
    if (funbox->namedLambdaBindings()) {
        namedLambdaEmitterScope.emplace(this);
        if (!namedLambdaEmitterScope->enterNamedLambda(this, funbox))
            return false;
    }

    /*
     * Emit a prologue for run-once scripts which will deoptimize JIT code
     * if the script ends up running multiple times via foo.caller related
     * shenanigans.
     *
     * Also mark the script so that initializers created within it may be
     * given more precise types.
     */
    if (isRunOnceLambda()) {
        script->setTreatAsRunOnce();
        MOZ_ASSERT(!script->hasRunOnce());

        switchToPrologue();
        if (!emit1(JSOP_RUNONCE))
            return false;
        switchToMain();
    }

    setFunctionBodyEndPos(body->pn_pos);
    if (!emitTree(body))
        return false;

    if (!updateSourceCoordNotes(body->pn_pos.end))
        return false;

    // Always end the script with a JSOP_RETRVAL. Some other parts of the
    // codebase depend on this opcode,
    // e.g. InterpreterRegs::setToEndOfScript.
    if (!emit1(JSOP_RETRVAL))
        return false;

    if (namedLambdaEmitterScope) {
        if (!namedLambdaEmitterScope->leave(this))
            return false;
        namedLambdaEmitterScope.reset();
    }

    if (!JSScript::fullyInitFromEmitter(cx, script, this))
        return false;

    // URL and source map information must be set before firing
    // Debugger::onNewScript. Only top-level functions need this, as compiling
    // the outer scripts of nested functions already processed the source.
    if (emitterMode != LazyFunction && !parent) {
        if (!maybeSetDisplayURL() || !maybeSetSourceMap())
            return false;

        tellDebuggerAboutCompiledScript(cx);
    }

    return true;
}

template <typename NameEmitter>
bool
BytecodeEmitter::emitDestructuringDeclsWithEmitter(ParseNode* pattern, NameEmitter emitName)
{
    if (pattern->isKind(PNK_ARRAY)) {
        for (ParseNode* element = pattern->pn_head; element; element = element->pn_next) {
            if (element->isKind(PNK_ELISION))
                continue;
            ParseNode* target = element;
            if (element->isKind(PNK_SPREAD)) {
                target = element->pn_kid;
            }
            if (target->isKind(PNK_ASSIGN))
                target = target->pn_left;
            if (target->isKind(PNK_NAME)) {
                if (!emitName(this, target))
                    return false;
            } else {
                if (!emitDestructuringDeclsWithEmitter(target, emitName))
                    return false;
            }
        }
        return true;
    }

    MOZ_ASSERT(pattern->isKind(PNK_OBJECT));
    for (ParseNode* member = pattern->pn_head; member; member = member->pn_next) {
        MOZ_ASSERT(member->isKind(PNK_MUTATEPROTO) ||
                   member->isKind(PNK_COLON) ||
                   member->isKind(PNK_SHORTHAND));

        ParseNode* target = member->isKind(PNK_MUTATEPROTO) ? member->pn_kid : member->pn_right;

        if (target->isKind(PNK_ASSIGN))
            target = target->pn_left;
        if (target->isKind(PNK_NAME)) {
            if (!emitName(this, target))
                return false;
        } else {
            if (!emitDestructuringDeclsWithEmitter(target, emitName))
                return false;
        }
    }
    return true;
}

bool
BytecodeEmitter::emitDestructuringLHS(ParseNode* target, DestructuringFlavor flav)
{
    // Now emit the lvalue opcode sequence. If the lvalue is a nested
    // destructuring initialiser-form, call ourselves to handle it, then pop
    // the matched value. Otherwise emit an lvalue bytecode sequence followed
    // by an assignment op.
    if (target->isKind(PNK_SPREAD))
        target = target->pn_kid;
    else if (target->isKind(PNK_ASSIGN))
        target = target->pn_left;
    if (target->isKind(PNK_ARRAY) || target->isKind(PNK_OBJECT)) {
        if (!emitDestructuringOps(target, flav))
            return false;
        // Per its post-condition, emitDestructuringOps has left the
        // to-be-destructured value on top of the stack.
        if (!emit1(JSOP_POP))
            return false;
    } else {
        switch (target->getKind()) {
          case PNK_NAME: {
            auto emitSwapScopeAndRhs = [](BytecodeEmitter* bce, const NameLocation&,
                                          bool emittedBindOp)
            {
                if (emittedBindOp) {
                    // This is like ordinary assignment, but with one
                    // difference.
                    //
                    // In `a = b`, we first determine a binding for `a` (using
                    // JSOP_BINDNAME or JSOP_BINDGNAME), then we evaluate `b`,
                    // then a JSOP_SETNAME instruction.
                    //
                    // In `[a] = [b]`, per spec, `b` is evaluated first, then
                    // we determine a binding for `a`. Then we need to do
                    // assignment-- but the operands are on the stack in the
                    // wrong order for JSOP_SETPROP, so we have to add a
                    // JSOP_SWAP.
                    //
                    // In the cases where we are emitting a name op, emit a
                    // swap because of this.
                    return bce->emit1(JSOP_SWAP);
                }

                // In cases of emitting a frame slot or environment slot,
                // nothing needs be done.
                return true;
            };

            RootedAtom name(cx, target->name());
            switch (flav) {
              case DestructuringDeclaration:
                if (!emitInitializeName(name, emitSwapScopeAndRhs))
                    return false;
                break;

              case DestructuringFormalParameterInVarScope: {
                // If there's an parameter expression var scope, the
                // destructuring declaration needs to initialize the name in
                // the function scope. The innermost scope is the var scope,
                // and its enclosing scope is the function scope.
                EmitterScope* funScope = innermostEmitterScope->enclosingInFrame();
                NameLocation paramLoc = *locationOfNameBoundInScope(name, funScope);
                if (!emitSetOrInitializeNameAtLocation(name, paramLoc, emitSwapScopeAndRhs, true))
                    return false;
                break;
              }

              case DestructuringAssignment:
                if (!emitSetName(name, emitSwapScopeAndRhs))
                    return false;
                break;
            }

            break;
          }

          case PNK_DOT: {
            // See the (PNK_NAME, JSOP_SETNAME) case above.
            //
            // In `a.x = b`, `a` is evaluated first, then `b`, then a
            // JSOP_SETPROP instruction.
            //
            // In `[a.x] = [b]`, per spec, `b` is evaluated before `a`. Then we
            // need a property set -- but the operands are on the stack in the
            // wrong order for JSOP_SETPROP, so we have to add a JSOP_SWAP.
            JSOp setOp;
            if (target->as<PropertyAccess>().isSuper()) {
                if (!emitSuperPropLHS(&target->as<PropertyAccess>().expression()))
                    return false;
                if (!emit2(JSOP_PICK, 2))
                    return false;
                setOp = sc->strict() ? JSOP_STRICTSETPROP_SUPER : JSOP_SETPROP_SUPER;
            } else {
                if (!emitTree(target->pn_expr))
                    return false;
                if (!emit1(JSOP_SWAP))
                    return false;
                setOp = sc->strict() ? JSOP_STRICTSETPROP : JSOP_SETPROP;
            }
            if (!emitAtomOp(target, setOp))
                return false;
            break;
          }

          case PNK_ELEM: {
            // See the comment at `case PNK_DOT:` above. This case,
            // `[a[x]] = [b]`, is handled much the same way. The JSOP_SWAP
            // is emitted by emitElemOperands.
            if (target->as<PropertyByValue>().isSuper()) {
                JSOp setOp = sc->strict() ? JSOP_STRICTSETELEM_SUPER : JSOP_SETELEM_SUPER;
                if (!emitSuperElemOp(target, setOp))
                    return false;
            } else {
                JSOp setOp = sc->strict() ? JSOP_STRICTSETELEM : JSOP_SETELEM;
                if (!emitElemOp(target, setOp))
                    return false;
            }
            break;
          }

          case PNK_CALL:
            MOZ_ASSERT_UNREACHABLE("Parser::reportIfNotValidSimpleAssignmentTarget "
                                   "rejects function calls as assignment "
                                   "targets in destructuring assignments");
            break;

          default:
            MOZ_CRASH("emitDestructuringLHS: bad lhs kind");
        }

        // Pop the assigned value.
        if (!emit1(JSOP_POP))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitConditionallyExecutedDestructuringLHS(ParseNode* target, DestructuringFlavor flav)
{
    TDZCheckCache tdzCache(this);
    return emitDestructuringLHS(target, flav);
}

bool
BytecodeEmitter::emitIteratorNext(ParseNode* pn, bool allowSelfHosted)
{
    MOZ_ASSERT(allowSelfHosted || emitterMode != BytecodeEmitter::SelfHosting,
               ".next() iteration is prohibited in self-hosted code because it "
               "can run user-modifiable iteration code");

    if (!emit1(JSOP_DUP))                                 // ... ITER ITER
        return false;
    if (!emitAtomOp(cx->names().next, JSOP_CALLPROP))     // ... ITER NEXT
        return false;
    if (!emit1(JSOP_SWAP))                                // ... NEXT ITER
        return false;
    if (!emitCall(JSOP_CALL, 0, pn))                      // ... RESULT
        return false;
    if (!emitCheckIsObj(CheckIsObjectKind::IteratorNext)) // ... RESULT
        return false;
    checkTypeSet(JSOP_CALL);
    return true;
}

bool
BytecodeEmitter::emitDefault(ParseNode* defaultExpr)
{
    if (!emit1(JSOP_DUP))                                 // VALUE VALUE
        return false;
    if (!emit1(JSOP_UNDEFINED))                           // VALUE VALUE UNDEFINED
        return false;
    if (!emit1(JSOP_STRICTEQ))                            // VALUE EQL?
        return false;
    // Emit source note to enable ion compilation.
    if (!newSrcNote(SRC_IF))
        return false;
    JumpList jump;
    if (!emitJump(JSOP_IFEQ, &jump))                      // VALUE
        return false;
    if (!emit1(JSOP_POP))                                 // .
        return false;
    if (!emitConditionallyExecutedTree(defaultExpr))      // DEFAULTVALUE
        return false;
    if (!emitJumpTargetAndPatch(jump))
        return false;
    return true;
}

class MOZ_STACK_CLASS IfThenElseEmitter
{
    BytecodeEmitter* bce_;
    JumpList jumpAroundThen_;
    JumpList jumpsAroundElse_;
    unsigned noteIndex_;
    int32_t thenDepth_;
#ifdef DEBUG
    int32_t pushed_;
    bool calculatedPushed_;
#endif
    enum State {
        Start,
        If,
        Cond,
        IfElse,
        Else,
        End
    };
    State state_;

  public:
    explicit IfThenElseEmitter(BytecodeEmitter* bce)
      : bce_(bce),
        noteIndex_(-1),
        thenDepth_(0),
#ifdef DEBUG
        pushed_(0),
        calculatedPushed_(false),
#endif
        state_(Start)
    {}

    ~IfThenElseEmitter()
    {}

  private:
    bool emitIf(State nextState) {
        MOZ_ASSERT(state_ == Start || state_ == Else);
        MOZ_ASSERT(nextState == If || nextState == IfElse || nextState == Cond);

        // Clear jumpAroundThen_ offset that points previous JSOP_IFEQ.
        if (state_ == Else)
            jumpAroundThen_ = JumpList();

        // Emit an annotated branch-if-false around the then part.
        SrcNoteType type = nextState == If ? SRC_IF : nextState == IfElse ? SRC_IF_ELSE : SRC_COND;
        if (!bce_->newSrcNote(type, &noteIndex_))
            return false;
        if (!bce_->emitJump(JSOP_IFEQ, &jumpAroundThen_))
            return false;

        // To restore stack depth in else part, save depth of the then part.
#ifdef DEBUG
        // If DEBUG, this is also necessary to calculate |pushed_|.
        thenDepth_ = bce_->stackDepth;
#else
        if (nextState == IfElse || nextState == Cond)
            thenDepth_ = bce_->stackDepth;
#endif
        state_ = nextState;
        return true;
    }

  public:
    bool emitIf() {
        return emitIf(If);
    }

    bool emitCond() {
        return emitIf(Cond);
    }

    bool emitIfElse() {
        return emitIf(IfElse);
    }

    bool emitElse() {
        MOZ_ASSERT(state_ == IfElse || state_ == Cond);

        calculateOrCheckPushed();

        // Emit a jump from the end of our then part around the else part. The
        // patchJumpsToTarget call at the bottom of this function will fix up
        // the offset with jumpsAroundElse value.
        if (!bce_->emitJump(JSOP_GOTO, &jumpsAroundElse_))
            return false;

        // Ensure the branch-if-false comes here, then emit the else.
        if (!bce_->emitJumpTargetAndPatch(jumpAroundThen_))
            return false;

        // Annotate SRC_IF_ELSE or SRC_COND with the offset from branch to
        // jump, for IonMonkey's benefit.  We can't just "back up" from the pc
        // of the else clause, because we don't know whether an extended
        // jump was required to leap from the end of the then clause over
        // the else clause.
        if (!bce_->setSrcNoteOffset(noteIndex_, 0,
                                    jumpsAroundElse_.offset - jumpAroundThen_.offset))
        {
            return false;
        }

        // Restore stack depth of the then part.
        bce_->stackDepth = thenDepth_;
        state_ = Else;
        return true;
    }

    bool emitEnd() {
        MOZ_ASSERT(state_ == If || state_ == Else);

        calculateOrCheckPushed();

        if (state_ == If) {
            // No else part, fixup the branch-if-false to come here.
            if (!bce_->emitJumpTargetAndPatch(jumpAroundThen_))
                return false;
        }

        // Patch all the jumps around else parts.
        if (!bce_->emitJumpTargetAndPatch(jumpsAroundElse_))
            return false;

        state_ = End;
        return true;
    }

    void calculateOrCheckPushed() {
#ifdef DEBUG
        if (!calculatedPushed_) {
            pushed_ = bce_->stackDepth - thenDepth_;
            calculatedPushed_ = true;
        } else {
            MOZ_ASSERT(pushed_ == bce_->stackDepth - thenDepth_);
        }
#endif
    }

#ifdef DEBUG
    int32_t pushed() const {
        return pushed_;
    }

    int32_t popped() const {
        return -pushed_;
    }
#endif
};

bool
BytecodeEmitter::emitDestructuringOpsArray(ParseNode* pattern, DestructuringFlavor flav)
{
    MOZ_ASSERT(pattern->isKind(PNK_ARRAY));
    MOZ_ASSERT(pattern->isArity(PN_LIST));
    MOZ_ASSERT(this->stackDepth != 0);

    // Here's pseudo code for |let [a, b, , c=y, ...d] = x;|
    //
    //   let x, y;
    //   let a, b, c, d;
    //   let tmp, done, iter, result; // stack values
    //
    //   iter = x[Symbol.iterator]();
    //
    //   // ==== emitted by loop for a ====
    //   result = iter.next();
    //   done = result.done;
    //
    //   if (done) {
    //     a = undefined;
    //
    //     result = undefined;
    //     done = true;
    //   } else {
    //     a = result.value;
    //
    //     // Do next element's .next() and .done access here
    //     result = iter.next();
    //     done = result.done;
    //   }
    //
    //   // ==== emitted by loop for b ====
    //   if (done) {
    //     b = undefined;
    //
    //     result = undefined;
    //     done = true;
    //   } else {
    //     b = result.value;
    //
    //     result = iter.next();
    //     done = result.done;
    //   }
    //
    //   // ==== emitted by loop for elision ====
    //   if (done) {
    //     result = undefined
    //     done = true
    //   } else {
    //     result.value;
    //
    //     result = iter.next();
    //     done = result.done;
    //   }
    //
    //   // ==== emitted by loop for c ====
    //   if (done) {
    //     c = y;
    //   } else {
    //     tmp = result.value;
    //     if (tmp === undefined)
    //       tmp = y;
    //     c = tmp;
    //
    //     // Don't do next element's .next() and .done access if
    //     // this is the last non-spread element.
    //   }
    //
    //   // ==== emitted by loop for d ====
    //   if (done) {
    //     // Assing empty array when completed
    //     d = [];
    //   } else {
    //     d = [...iter];
    //   }

    /*
     * Use an iterator to destructure the RHS, instead of index lookup. We
     * must leave the *original* value on the stack.
     */
    if (!emit1(JSOP_DUP))                                         // ... OBJ OBJ
        return false;
    if (!emitIterator())                                          // ... OBJ? ITER
        return false;
    bool needToPopIterator = true;

    for (ParseNode* member = pattern->pn_head; member; member = member->pn_next) {
        bool isHead = member == pattern->pn_head;
        if (member->isKind(PNK_SPREAD)) {
            IfThenElseEmitter ifThenElse(this);
            if (!isHead) {
                // If spread is not the first element of the pattern,
                // iterator can already be completed.
                if (!ifThenElse.emitIfElse())                     // ... OBJ? ITER
                    return false;

                if (!emit1(JSOP_POP))                             // ... OBJ?
                    return false;
                if (!emitUint32Operand(JSOP_NEWARRAY, 0))         // ... OBJ? ARRAY
                    return false;
                if (!emitConditionallyExecutedDestructuringLHS(member, flav)) // ... OBJ?
                    return false;

                if (!ifThenElse.emitElse())                       // ... OBJ? ITER
                    return false;
            }

            // If iterator is not completed, create a new array with the rest
            // of the iterator.
            if (!emitUint32Operand(JSOP_NEWARRAY, 0))             // ... OBJ? ITER ARRAY
                return false;
            if (!emitNumberOp(0))                                 // ... OBJ? ITER ARRAY INDEX
                return false;
            if (!emitSpread())                                    // ... OBJ? ARRAY INDEX
                return false;
            if (!emit1(JSOP_POP))                                 // ... OBJ? ARRAY
                return false;
            if (!emitConditionallyExecutedDestructuringLHS(member, flav)) // ... OBJ?
                return false;

            if (!isHead) {
                if (!ifThenElse.emitEnd())
                    return false;
                MOZ_ASSERT(ifThenElse.popped() == 1);
            }
            needToPopIterator = false;
            MOZ_ASSERT(!member->pn_next);
            break;
        }

        ParseNode* pndefault = nullptr;
        ParseNode* subpattern = member;
        if (subpattern->isKind(PNK_ASSIGN)) {
            pndefault = subpattern->pn_right;
            subpattern = subpattern->pn_left;
        }

        bool isElision = subpattern->isKind(PNK_ELISION);
        bool hasNextNonSpread = member->pn_next && !member->pn_next->isKind(PNK_SPREAD);
        bool hasNextSpread = member->pn_next && member->pn_next->isKind(PNK_SPREAD);

        MOZ_ASSERT(!subpattern->isKind(PNK_SPREAD));

        auto emitNext = [pattern](ExclusiveContext* cx, BytecodeEmitter* bce) {
            if (!bce->emit1(JSOP_DUP))                            // ... OBJ? ITER ITER
                return false;
            if (!bce->emitIteratorNext(pattern))                  // ... OBJ? ITER RESULT
                return false;
            if (!bce->emit1(JSOP_DUP))                            // ... OBJ? ITER RESULT RESULT
                return false;
            if (!bce->emitAtomOp(cx->names().done, JSOP_GETPROP)) // ... OBJ? ITER RESULT DONE?
                return false;
            return true;
        };

        if (isHead) {
            if (!emitNext(cx, this))                              // ... OBJ? ITER RESULT DONE?
                return false;
        }

        IfThenElseEmitter ifThenElse(this);
        if (!ifThenElse.emitIfElse())                             // ... OBJ? ITER RESULT
            return false;

        if (!emit1(JSOP_POP))                                     // ... OBJ? ITER
            return false;
        if (pndefault) {
            // Emit only pndefault tree here, as undefined check in emitDefault
            // should always be true.
            if (!emitConditionallyExecutedTree(pndefault))        // ... OBJ? ITER VALUE
                return false;
        } else {
            if (!isElision) {
                if (!emit1(JSOP_UNDEFINED))                       // ... OBJ? ITER UNDEFINED
                    return false;
                if (!emit1(JSOP_NOP_DESTRUCTURING))
                    return false;
            }
        }
        if (!isElision) {
            if (!emitConditionallyExecutedDestructuringLHS(subpattern, flav)) // ... OBJ? ITER
                return false;
        } else if (pndefault) {
            if (!emit1(JSOP_POP))                                 // ... OBJ? ITER
                return false;
        }

        // Setup next element's result when the iterator is done.
        if (hasNextNonSpread) {
            if (!emit1(JSOP_UNDEFINED))                           // ... OBJ? ITER RESULT
                return false;
            if (!emit1(JSOP_NOP_DESTRUCTURING))
                return false;
            if (!emit1(JSOP_TRUE))                                // ... OBJ? ITER RESULT DONE?
                return false;
        } else if (hasNextSpread) {
            if (!emit1(JSOP_TRUE))                                // ... OBJ? ITER DONE?
                return false;
        }

        if (!ifThenElse.emitElse())                               // ... OBJ? ITER RESULT
            return false;

        if (!emitAtomOp(cx->names().value, JSOP_GETPROP))         // ... OBJ? ITER VALUE
            return false;

        if (pndefault) {
            if (!emitDefault(pndefault))                          // ... OBJ? ITER VALUE
                return false;
        }

        if (!isElision) {
            if (!emitConditionallyExecutedDestructuringLHS(subpattern, flav)) // ... OBJ? ITER
                return false;
        } else {
            if (!emit1(JSOP_POP))                                 // ... OBJ? ITER
                return false;
        }

        // Setup next element's result when the iterator is not done.
        if (hasNextNonSpread) {
            if (!emitNext(cx, this))                              // ... OBJ? ITER RESULT DONE?
                return false;
        } else if (hasNextSpread) {
            if (!emit1(JSOP_FALSE))                               // ... OBJ? ITER DONE?
                return false;
        }

        if (!ifThenElse.emitEnd())
            return false;
        if (hasNextNonSpread)
            MOZ_ASSERT(ifThenElse.pushed() == 1);
        else if (hasNextSpread)
            MOZ_ASSERT(ifThenElse.pushed() == 0);
        else
            MOZ_ASSERT(ifThenElse.popped() == 1);
    }

    if (needToPopIterator) {
        if (!emit1(JSOP_POP))                                     // ... OBJ?
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitComputedPropertyName(ParseNode* computedPropName)
{
    MOZ_ASSERT(computedPropName->isKind(PNK_COMPUTED_NAME));
    return emitTree(computedPropName->pn_kid) && emit1(JSOP_TOID);
}

bool
BytecodeEmitter::emitDestructuringOpsObject(ParseNode* pattern, DestructuringFlavor flav)
{
    MOZ_ASSERT(pattern->isKind(PNK_OBJECT));
    MOZ_ASSERT(pattern->isArity(PN_LIST));

    MOZ_ASSERT(this->stackDepth > 0);                             // ... RHS

    if (!emitRequireObjectCoercible())                            // ... RHS
        return false;

    for (ParseNode* member = pattern->pn_head; member; member = member->pn_next) {
        // Duplicate the value being destructured to use as a reference base.
        if (!emit1(JSOP_DUP))                                     // ... RHS RHS
            return false;

        // Now push the property name currently being matched, which is the
        // current property name "label" on the left of a colon in the object
        // initialiser.
        bool needsGetElem = true;

        ParseNode* subpattern;
        if (member->isKind(PNK_MUTATEPROTO)) {
            if (!emitAtomOp(cx->names().proto, JSOP_GETPROP))     // ... RHS PROP
                return false;
            needsGetElem = false;
            subpattern = member->pn_kid;
        } else {
            MOZ_ASSERT(member->isKind(PNK_COLON) || member->isKind(PNK_SHORTHAND));

            ParseNode* key = member->pn_left;
            if (key->isKind(PNK_NUMBER)) {
                if (!emitNumberOp(key->pn_dval))                  // ... RHS RHS KEY
                    return false;
            } else if (key->isKind(PNK_OBJECT_PROPERTY_NAME) || key->isKind(PNK_STRING)) {
                PropertyName* name = key->pn_atom->asPropertyName();

                // The parser already checked for atoms representing indexes and
                // used PNK_NUMBER instead, but also watch for ids which TI treats
                // as indexes for simplification of downstream analysis.
                jsid id = NameToId(name);
                if (id != IdToTypeId(id)) {
                    if (!emitTree(key))                           // ... RHS RHS KEY
                        return false;
                } else {
                    if (!emitAtomOp(name, JSOP_GETPROP))          // ...RHS PROP
                        return false;
                    needsGetElem = false;
                }
            } else {
                if (!emitComputedPropertyName(key))               // ... RHS RHS KEY
                    return false;
            }

            subpattern = member->pn_right;
        }

        // Get the property value if not done already.
        if (needsGetElem && !emitElemOpBase(JSOP_GETELEM))        // ... RHS PROP
            return false;

        if (subpattern->isKind(PNK_ASSIGN)) {
            if (!emitDefault(subpattern->pn_right))
                return false;
            subpattern = subpattern->pn_left;
        }

        // Destructure PROP per this member's subpattern.
        if (!emitDestructuringLHS(subpattern, flav))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitDestructuringOps(ParseNode* pattern, DestructuringFlavor flav)
{
    if (pattern->isKind(PNK_ARRAY))
        return emitDestructuringOpsArray(pattern, flav);
    return emitDestructuringOpsObject(pattern, flav);
}

bool
BytecodeEmitter::emitTemplateString(ParseNode* pn)
{
    MOZ_ASSERT(pn->isArity(PN_LIST));

    bool pushedString = false;

    for (ParseNode* pn2 = pn->pn_head; pn2 != NULL; pn2 = pn2->pn_next) {
        bool isString = (pn2->getKind() == PNK_STRING || pn2->getKind() == PNK_TEMPLATE_STRING);

        // Skip empty strings. These are very common: a template string like
        // `${a}${b}` has three empty strings and without this optimization
        // we'd emit four JSOP_ADD operations instead of just one.
        if (isString && pn2->pn_atom->empty())
            continue;

        if (!isString) {
            // We update source notes before emitting the expression
            if (!updateSourceCoordNotes(pn2->pn_pos.begin))
                return false;
        }

        if (!emitTree(pn2))
            return false;

        if (!isString) {
            // We need to convert the expression to a string
            if (!emit1(JSOP_TOSTRING))
                return false;
        }

        if (pushedString) {
            // We've pushed two strings onto the stack. Add them together, leaving just one.
            if (!emit1(JSOP_ADD))
                return false;
        } else {
            pushedString = true;
        }
    }

    if (!pushedString) {
        // All strings were empty, this can happen for something like `${""}`.
        // Just push an empty string.
        if (!emitAtomOp(cx->names().empty, JSOP_STRING))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitDeclarationList(ParseNode* declList)
{
    MOZ_ASSERT(declList->isArity(PN_LIST));

    ParseNode* next;
    for (ParseNode* decl = declList->pn_head; decl; decl = next) {
        if (!updateSourceCoordNotes(decl->pn_pos.begin))
            return false;
        next = decl->pn_next;

        if (decl->isKind(PNK_ASSIGN)) {
            MOZ_ASSERT(decl->isOp(JSOP_NOP));

            ParseNode* pattern = decl->pn_left;
            MOZ_ASSERT(pattern->isKind(PNK_ARRAY) || pattern->isKind(PNK_OBJECT));

            if (!emitTree(decl->pn_right))
                return false;

            if (!emitDestructuringOps(pattern, DestructuringDeclaration))
                return false;

            if (!emit1(JSOP_POP))
                return false;
        } else {
            if (!emitSingleDeclaration(declList, decl, decl->expr()))
                return false;
        }
    }
    return true;
}

bool
BytecodeEmitter::emitSingleDeclaration(ParseNode* declList, ParseNode* decl,
                                       ParseNode* initializer)
{
    MOZ_ASSERT(decl->isKind(PNK_NAME));

    // Nothing to do for initializer-less 'var' declarations, as there's no TDZ.
    if (!initializer && declList->isKind(PNK_VAR))
        return true;

    auto emitRhs = [initializer, declList](BytecodeEmitter* bce, const NameLocation&, bool) {
        if (!initializer) {
            // Lexical declarations are initialized to undefined without an
            // initializer.
            MOZ_ASSERT(declList->isKind(PNK_LET),
                       "var declarations without initializers handled above, "
                       "and const declarations must have initializers");
            return bce->emit1(JSOP_UNDEFINED);
        }

        MOZ_ASSERT(initializer);
        return bce->emitTree(initializer);
    };

    if (!emitInitializeName(decl, emitRhs))
        return false;

    // Pop the RHS.
    return emit1(JSOP_POP);
}

static bool
EmitAssignmentRhs(BytecodeEmitter* bce, ParseNode* rhs, uint8_t offset)
{
    // If there is a RHS tree, emit the tree.
    if (rhs)
        return bce->emitTree(rhs);

    // Otherwise the RHS value to assign is already on the stack, i.e., the
    // next enumeration value in a for-in or for-of loop. Depending on how
    // many other values have been pushed on the stack, we need to get the
    // already-pushed RHS value.
    if (offset != 1 && !bce->emit2(JSOP_PICK, offset - 1))
        return false;

    return true;
}

bool
BytecodeEmitter::emitAssignment(ParseNode* lhs, JSOp op, ParseNode* rhs)
{
    // Name assignments are handled separately because choosing ops and when
    // to emit BINDNAME is involved and should avoid duplication.
    if (lhs->isKind(PNK_NAME)) {
        auto emitRhs = [op, lhs, rhs](BytecodeEmitter* bce, const NameLocation& lhsLoc,
                                      bool emittedBindOp)
        {
            // For compound assignments, first get the LHS value, then emit
            // the RHS and the op.
            if (op != JSOP_NOP) {
                if (lhsLoc.kind() == NameLocation::Kind::Dynamic) {
                    // For dynamic accesses we can do better than a GETNAME
                    // since the assignment already emitted a BINDNAME on the
                    // top of the stack. As an optimization, use that to get
                    // the name.
                    if (!bce->emit1(JSOP_DUP))
                        return false;
                    if (!bce->emitAtomOp(lhs, JSOP_GETXPROP))
                        return false;
                } else {
                    if (!bce->emitGetNameAtLocation(lhs->name(), lhsLoc))
                        return false;
                }
            }

            // Emit the RHS. If we emitted a BIND[G]NAME, then the scope is on
            // the top of the stack and we need to pick the right RHS value.
            if (!EmitAssignmentRhs(bce, rhs, emittedBindOp ? 2 : 1))
                return false;

            // Emit the compound assignment op if there is one.
            if (op != JSOP_NOP && !bce->emit1(op))
                return false;

            return true;
        };

        return emitSetName(lhs, emitRhs);
    }

    // Deal with non-name assignments.
    uint32_t atomIndex = (uint32_t) -1;
    uint8_t offset = 1;

    switch (lhs->getKind()) {
      case PNK_DOT:
        if (lhs->as<PropertyAccess>().isSuper()) {
            if (!emitSuperPropLHS(&lhs->as<PropertyAccess>().expression()))
                return false;
            offset += 2;
        } else {
            if (!emitTree(lhs->expr()))
                return false;
            offset += 1;
        }
        if (!makeAtomIndex(lhs->pn_atom, &atomIndex))
            return false;
        break;
      case PNK_ELEM: {
        MOZ_ASSERT(lhs->isArity(PN_BINARY));
        EmitElemOption opt = op == JSOP_NOP ? EmitElemOption::Get : EmitElemOption::CompoundAssign;
        if (lhs->as<PropertyByValue>().isSuper()) {
            if (!emitSuperElemOperands(lhs, opt))
                return false;
            offset += 3;
        } else {
            if (!emitElemOperands(lhs, opt))
                return false;
            offset += 2;
        }
        break;
      }
      case PNK_ARRAY:
      case PNK_OBJECT:
        break;
      case PNK_CALL:
        if (!emitTree(lhs))
            return false;

        // Assignment to function calls is forbidden, but we have to make the
        // call first.  Now we can throw.
        if (!emitUint16Operand(JSOP_THROWMSG, JSMSG_BAD_LEFTSIDE_OF_ASS))
            return false;

        // Rebalance the stack to placate stack-depth assertions.
        if (!emit1(JSOP_POP))
            return false;
        break;
      default:
        MOZ_ASSERT(0);
    }

    if (op != JSOP_NOP) {
        MOZ_ASSERT(rhs);
        switch (lhs->getKind()) {
          case PNK_DOT: {
            JSOp getOp;
            if (lhs->as<PropertyAccess>().isSuper()) {
                if (!emit1(JSOP_DUP2))
                    return false;
                getOp = JSOP_GETPROP_SUPER;
            } else {
                if (!emit1(JSOP_DUP))
                    return false;
                bool isLength = (lhs->pn_atom == cx->names().length);
                getOp = isLength ? JSOP_LENGTH : JSOP_GETPROP;
            }
            if (!emitIndex32(getOp, atomIndex))
                return false;
            break;
          }
          case PNK_ELEM: {
            JSOp elemOp;
            if (lhs->as<PropertyByValue>().isSuper()) {
                if (!emitDupAt(2))
                    return false;
                if (!emitDupAt(2))
                    return false;
                if (!emitDupAt(2))
                    return false;
                elemOp = JSOP_GETELEM_SUPER;
            } else {
                if (!emit1(JSOP_DUP2))
                    return false;
                elemOp = JSOP_GETELEM;
            }
            if (!emitElemOpBase(elemOp))
                return false;
            break;
          }
          case PNK_CALL:
            // We just emitted a JSOP_THROWMSG and popped the call's return
            // value.  Push a random value to make sure the stack depth is
            // correct.
            if (!emit1(JSOP_NULL))
                return false;
            break;
          default:;
        }
    }

    if (!EmitAssignmentRhs(this, rhs, offset))
        return false;

    /* If += etc., emit the binary operator with a source note. */
    if (op != JSOP_NOP) {
        if (!newSrcNote(SRC_ASSIGNOP))
            return false;
        if (!emit1(op))
            return false;
    }

    /* Finally, emit the specialized assignment bytecode. */
    switch (lhs->getKind()) {
      case PNK_DOT: {
        JSOp setOp = lhs->as<PropertyAccess>().isSuper() ?
                       (sc->strict() ? JSOP_STRICTSETPROP_SUPER : JSOP_SETPROP_SUPER) :
                       (sc->strict() ? JSOP_STRICTSETPROP : JSOP_SETPROP);
        if (!emitIndexOp(setOp, atomIndex))
            return false;
        break;
      }
      case PNK_CALL:
        // We threw above, so nothing to do here.
        break;
      case PNK_ELEM: {
        JSOp setOp = lhs->as<PropertyByValue>().isSuper() ?
                       sc->strict() ? JSOP_STRICTSETELEM_SUPER : JSOP_SETELEM_SUPER :
                       sc->strict() ? JSOP_STRICTSETELEM : JSOP_SETELEM;
        if (!emit1(setOp))
            return false;
        break;
      }
      case PNK_ARRAY:
      case PNK_OBJECT:
        if (!emitDestructuringOps(lhs, DestructuringAssignment))
            return false;
        break;
      default:
        MOZ_ASSERT(0);
    }
    return true;
}

bool
ParseNode::getConstantValue(ExclusiveContext* cx, AllowConstantObjects allowObjects,
                            MutableHandleValue vp, Value* compare, size_t ncompare,
                            NewObjectKind newKind)
{
    MOZ_ASSERT(newKind == TenuredObject || newKind == SingletonObject);

    switch (getKind()) {
      case PNK_NUMBER:
        vp.setNumber(pn_dval);
        return true;
      case PNK_TEMPLATE_STRING:
      case PNK_STRING:
        vp.setString(pn_atom);
        return true;
      case PNK_TRUE:
        vp.setBoolean(true);
        return true;
      case PNK_FALSE:
        vp.setBoolean(false);
        return true;
      case PNK_NULL:
        vp.setNull();
        return true;
      case PNK_CALLSITEOBJ:
      case PNK_ARRAY: {
        unsigned count;
        ParseNode* pn;

        if (allowObjects == DontAllowObjects) {
            vp.setMagic(JS_GENERIC_MAGIC);
            return true;
        }

        ObjectGroup::NewArrayKind arrayKind = ObjectGroup::NewArrayKind::Normal;
        if (allowObjects == ForCopyOnWriteArray) {
            arrayKind = ObjectGroup::NewArrayKind::CopyOnWrite;
            allowObjects = DontAllowObjects;
        }

        if (getKind() == PNK_CALLSITEOBJ) {
            count = pn_count - 1;
            pn = pn_head->pn_next;
        } else {
            MOZ_ASSERT(isOp(JSOP_NEWINIT) && !(pn_xflags & PNX_NONCONST));
            count = pn_count;
            pn = pn_head;
        }

        AutoValueVector values(cx);
        if (!values.appendN(MagicValue(JS_ELEMENTS_HOLE), count))
            return false;
        size_t idx;
        for (idx = 0; pn; idx++, pn = pn->pn_next) {
            if (!pn->getConstantValue(cx, allowObjects, values[idx], values.begin(), idx))
                return false;
            if (values[idx].isMagic(JS_GENERIC_MAGIC)) {
                vp.setMagic(JS_GENERIC_MAGIC);
                return true;
            }
        }
        MOZ_ASSERT(idx == count);

        JSObject* obj = ObjectGroup::newArrayObject(cx, values.begin(), values.length(),
                                                    newKind, arrayKind);
        if (!obj)
            return false;

        if (!CombineArrayElementTypes(cx, obj, compare, ncompare))
            return false;

        vp.setObject(*obj);
        return true;
      }
      case PNK_OBJECT: {
        MOZ_ASSERT(isOp(JSOP_NEWINIT));
        MOZ_ASSERT(!(pn_xflags & PNX_NONCONST));

        if (allowObjects == DontAllowObjects) {
            vp.setMagic(JS_GENERIC_MAGIC);
            return true;
        }
        MOZ_ASSERT(allowObjects == AllowObjects);

        Rooted<IdValueVector> properties(cx, IdValueVector(cx));

        RootedValue value(cx), idvalue(cx);
        for (ParseNode* pn = pn_head; pn; pn = pn->pn_next) {
            if (!pn->pn_right->getConstantValue(cx, allowObjects, &value))
                return false;
            if (value.isMagic(JS_GENERIC_MAGIC)) {
                vp.setMagic(JS_GENERIC_MAGIC);
                return true;
            }

            ParseNode* pnid = pn->pn_left;
            if (pnid->isKind(PNK_NUMBER)) {
                idvalue = NumberValue(pnid->pn_dval);
            } else {
                MOZ_ASSERT(pnid->isKind(PNK_OBJECT_PROPERTY_NAME) || pnid->isKind(PNK_STRING));
                MOZ_ASSERT(pnid->pn_atom != cx->names().proto);
                idvalue = StringValue(pnid->pn_atom);
            }

            RootedId id(cx);
            if (!ValueToId<CanGC>(cx, idvalue, &id))
                return false;

            if (!properties.append(IdValuePair(id, value)))
                return false;
        }

        JSObject* obj = ObjectGroup::newPlainObject(cx, properties.begin(), properties.length(),
                                                    newKind);
        if (!obj)
            return false;

        if (!CombinePlainObjectPropertyTypes(cx, obj, compare, ncompare))
            return false;

        vp.setObject(*obj);
        return true;
      }
      default:
        MOZ_CRASH("Unexpected node");
    }
    return false;
}

bool
BytecodeEmitter::emitSingletonInitialiser(ParseNode* pn)
{
    NewObjectKind newKind = (pn->getKind() == PNK_OBJECT) ? SingletonObject : TenuredObject;

    RootedValue value(cx);
    if (!pn->getConstantValue(cx, ParseNode::AllowObjects, &value, nullptr, 0, newKind))
        return false;

    MOZ_ASSERT_IF(newKind == SingletonObject, value.toObject().isSingleton());

    ObjectBox* objbox = parser->newObjectBox(&value.toObject());
    if (!objbox)
        return false;

    return emitObjectOp(objbox, JSOP_OBJECT);
}

bool
BytecodeEmitter::emitCallSiteObject(ParseNode* pn)
{
    RootedValue value(cx);
    if (!pn->getConstantValue(cx, ParseNode::AllowObjects, &value))
        return false;

    MOZ_ASSERT(value.isObject());

    ObjectBox* objbox1 = parser->newObjectBox(&value.toObject());
    if (!objbox1)
        return false;

    if (!pn->as<CallSiteNode>().getRawArrayValue(cx, &value))
        return false;

    MOZ_ASSERT(value.isObject());

    ObjectBox* objbox2 = parser->newObjectBox(&value.toObject());
    if (!objbox2)
        return false;

    return emitObjectPairOp(objbox1, objbox2, JSOP_CALLSITEOBJ);
}

/* See the SRC_FOR source note offsetBias comments later in this file. */
JS_STATIC_ASSERT(JSOP_NOP_LENGTH == 1);
JS_STATIC_ASSERT(JSOP_POP_LENGTH == 1);

namespace {

class EmitLevelManager
{
    BytecodeEmitter* bce;
  public:
    explicit EmitLevelManager(BytecodeEmitter* bce) : bce(bce) { bce->emitLevel++; }
    ~EmitLevelManager() { bce->emitLevel--; }
};

} /* anonymous namespace */

bool
BytecodeEmitter::emitCatch(ParseNode* pn)
{
    // We must be nested under a try-finally statement.
    TryFinallyControl& controlInfo = innermostNestableControl->as<TryFinallyControl>();

    /* Pick up the pending exception and bind it to the catch variable. */
    if (!emit1(JSOP_EXCEPTION))
        return false;

    /*
     * Dup the exception object if there is a guard for rethrowing to use
     * it later when rethrowing or in other catches.
     */
    if (pn->pn_kid2 && !emit1(JSOP_DUP))
        return false;

    ParseNode* pn2 = pn->pn_kid1;
    switch (pn2->getKind()) {
      case PNK_ARRAY:
      case PNK_OBJECT:
        if (!emitDestructuringOps(pn2, DestructuringDeclaration))
            return false;
        if (!emit1(JSOP_POP))
            return false;
        break;

      case PNK_NAME:
        if (!emitLexicalInitialization(pn2))
            return false;
        if (!emit1(JSOP_POP))
            return false;
        break;

      default:
        MOZ_ASSERT(0);
    }

    // If there is a guard expression, emit it and arrange to jump to the next
    // catch block if the guard expression is false.
    if (pn->pn_kid2) {
        if (!emitTree(pn->pn_kid2))
            return false;

        // If the guard expression is false, fall through, pop the block scope,
        // and jump to the next catch block.  Otherwise jump over that code and
        // pop the dupped exception.
        JumpList guardCheck;
        if (!emitJump(JSOP_IFNE, &guardCheck))
            return false;

        {
            NonLocalExitControl nle(this);

            // Move exception back to cx->exception to prepare for
            // the next catch.
            if (!emit1(JSOP_THROWING))
                return false;

            // Leave the scope for this catch block.
            if (!nle.prepareForNonLocalJump(&controlInfo))
                return false;

            // Jump to the next handler added by emitTry.
            if (!emitJump(JSOP_GOTO, &controlInfo.guardJump))
                return false;
        }

        // Back to normal control flow.
        if (!emitJumpTargetAndPatch(guardCheck))
            return false;

        // Pop duplicated exception object as we no longer need it.
        if (!emit1(JSOP_POP))
            return false;
    }

    /* Emit the catch body. */
    return emitTree(pn->pn_kid3);
}

// Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047. See the
// comment on EmitSwitch.
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitTry(ParseNode* pn)
{
    // Track jumps-over-catches and gosubs-to-finally for later fixup.
    //
    // When a finally block is active, non-local jumps (including
    // jumps-over-catches) result in a GOSUB being written into the bytecode
    // stream and fixed-up later.
    //
    TryFinallyControl controlInfo(this, pn->pn_kid3 ? StatementKind::Finally : StatementKind::Try);

    // Since an exception can be thrown at any place inside the try block,
    // we need to restore the stack and the scope chain before we transfer
    // the control to the exception handler.
    //
    // For that we store in a try note associated with the catch or
    // finally block the stack depth upon the try entry. The interpreter
    // uses this depth to properly unwind the stack and the scope chain.
    //
    int depth = stackDepth;

    // Record the try location, then emit the try block.
    unsigned noteIndex;
    if (!newSrcNote(SRC_TRY, &noteIndex))
        return false;
    if (!emit1(JSOP_TRY))
        return false;

    ptrdiff_t tryStart = offset();
    if (!emitTree(pn->pn_kid1))
        return false;
    MOZ_ASSERT(depth == stackDepth);

    // GOSUB to finally, if present.
    if (pn->pn_kid3) {
        if (!emitJump(JSOP_GOSUB, &controlInfo.gosubs))
            return false;
    }

    // Source note points to the jump at the end of the try block.
    if (!setSrcNoteOffset(noteIndex, 0, offset() - tryStart + JSOP_TRY_LENGTH))
        return false;

    // Emit jump over catch and/or finally.
    JumpList catchJump;
    if (!emitJump(JSOP_GOTO, &catchJump))
        return false;

    JumpTarget tryEnd;
    if (!emitJumpTarget(&tryEnd))
        return false;

    // If this try has a catch block, emit it.
    ParseNode* catchList = pn->pn_kid2;
    if (catchList) {
        MOZ_ASSERT(catchList->isKind(PNK_CATCHLIST));

        // The emitted code for a catch block looks like:
        //
        // [pushlexicalenv]             only if any local aliased
        // exception
        // if there is a catchguard:
        //   dup
        // setlocal 0; pop              assign or possibly destructure exception
        // if there is a catchguard:
        //   < catchguard code >
        //   ifne POST
        //   debugleaveblock
        //   [poplexicalenv]            only if any local aliased
        //   throwing                   pop exception to cx->exception
        //   goto <next catch block>
        //   POST: pop
        // < catch block contents >
        // debugleaveblock
        // [poplexicalenv]              only if any local aliased
        // goto <end of catch blocks>   non-local; finally applies
        //
        // If there's no catch block without a catchguard, the last <next catch
        // block> points to rethrow code.  This code will [gosub] to the finally
        // code if appropriate, and is also used for the catch-all trynote for
        // capturing exceptions thrown from catch{} blocks.
        //
        for (ParseNode* pn3 = catchList->pn_head; pn3; pn3 = pn3->pn_next) {
            MOZ_ASSERT(this->stackDepth == depth);

            // Clear the frame's return value that might have been set by the
            // try block:
            //
            //   eval("try { 1; throw 2 } catch(e) {}"); // undefined, not 1
            if (!emit1(JSOP_UNDEFINED))
                return false;
            if (!emit1(JSOP_SETRVAL))
                return false;

            // Emit the lexical scope and catch body.
            MOZ_ASSERT(pn3->isKind(PNK_LEXICALSCOPE));
            if (!emitTree(pn3))
                return false;

            // gosub <finally>, if required.
            if (pn->pn_kid3) {
                if (!emitJump(JSOP_GOSUB, &controlInfo.gosubs))
                    return false;
                MOZ_ASSERT(this->stackDepth == depth);
            }

            // Jump over the remaining catch blocks.  This will get fixed
            // up to jump to after catch/finally.
            if (!emitJump(JSOP_GOTO, &catchJump))
                return false;

            // If this catch block had a guard clause, patch the guard jump to
            // come here.
            if (controlInfo.guardJump.offset != -1) {
                if (!emitJumpTargetAndPatch(controlInfo.guardJump))
                    return false;
                controlInfo.guardJump.offset = -1;

                // If this catch block is the last one, rethrow, delegating
                // execution of any finally block to the exception handler.
                if (!pn3->pn_next) {
                    if (!emit1(JSOP_EXCEPTION))
                        return false;
                    if (!emit1(JSOP_THROW))
                        return false;
                }
            }
        }
    }

    MOZ_ASSERT(this->stackDepth == depth);

    // Emit the finally handler, if there is one.
    JumpTarget finallyStart{ 0 };
    if (pn->pn_kid3) {
        if (!emitJumpTarget(&finallyStart))
            return false;

        // Fix up the gosubs that might have been emitted before non-local
        // jumps to the finally code.
        patchJumpsToTarget(controlInfo.gosubs, finallyStart);

        // Indicate that we're emitting a subroutine body.
        controlInfo.setEmittingSubroutine();
        if (!updateSourceCoordNotes(pn->pn_kid3->pn_pos.begin))
            return false;
        if (!emit1(JSOP_FINALLY))
            return false;
        if (!emit1(JSOP_GETRVAL))
            return false;

        // Clear the frame's return value to make break/continue return
        // correct value even if there's no other statement before them:
        //
        //   eval("x: try { 1 } finally { break x; }");  // undefined, not 1
        if (!emit1(JSOP_UNDEFINED))
            return false;
        if (!emit1(JSOP_SETRVAL))
            return false;

        if (!emitTree(pn->pn_kid3))
            return false;
        if (!emit1(JSOP_SETRVAL))
            return false;
        if (!emit1(JSOP_RETSUB))
            return false;
        hasTryFinally = true;
        MOZ_ASSERT(this->stackDepth == depth);
    }

    // ReconstructPCStack needs a NOP here to mark the end of the last catch block.
    if (!emit1(JSOP_NOP))
        return false;

    // Fix up the end-of-try/catch jumps to come here.
    if (!emitJumpTargetAndPatch(catchJump))
        return false;

    // Add the try note last, to let post-order give us the right ordering
    // (first to last for a given nesting level, inner to outer by level).
    if (catchList && !tryNoteList.append(JSTRY_CATCH, depth, tryStart, tryEnd.offset))
        return false;

    // If we've got a finally, mark try+catch region with additional
    // trynote to catch exceptions (re)thrown from a catch block or
    // for the try{}finally{} case.
    if (pn->pn_kid3 && !tryNoteList.append(JSTRY_FINALLY, depth, tryStart, finallyStart.offset))
        return false;

    return true;
}

bool
BytecodeEmitter::emitIf(ParseNode* pn)
{
    IfThenElseEmitter ifThenElse(this);

  if_again:
    /* Emit code for the condition before pushing stmtInfo. */
    if (!emitConditionallyExecutedTree(pn->pn_kid1))
        return false;

    ParseNode* elseNode = pn->pn_kid3;
    if (elseNode) {
        if (!ifThenElse.emitIfElse())
            return false;
    } else {
        if (!ifThenElse.emitIf())
            return false;
    }

    /* Emit code for the then part. */
    if (!emitConditionallyExecutedTree(pn->pn_kid2))
        return false;

    if (elseNode) {
        if (!ifThenElse.emitElse())
            return false;

        if (elseNode->isKind(PNK_IF)) {
            pn = elseNode;
            goto if_again;
        }

        /* Emit code for the else part. */
        if (!emitConditionallyExecutedTree(elseNode))
            return false;
    }

    if (!ifThenElse.emitEnd())
        return false;

    return true;
}

bool
BytecodeEmitter::emitHoistedFunctionsInList(ParseNode* list)
{
    MOZ_ASSERT(list->pn_xflags & PNX_FUNCDEFS);

    for (ParseNode* pn = list->pn_head; pn; pn = pn->pn_next) {
        ParseNode* maybeFun = pn;

        if (!sc->strict()) {
            while (maybeFun->isKind(PNK_LABEL))
                maybeFun = maybeFun->as<LabeledStatement>().statement();
        }

        if (maybeFun->isKind(PNK_FUNCTION) && maybeFun->functionIsHoisted()) {
            if (!emitTree(maybeFun))
                return false;
        }
    }

    return true;
}

bool
BytecodeEmitter::emitLexicalScopeBody(ParseNode* body, EmitLineNumberNote emitLineNote)
{
    if (body->isKind(PNK_STATEMENTLIST) && body->pn_xflags & PNX_FUNCDEFS) {
        // This block contains function statements whose definitions are
        // hoisted to the top of the block. Emit these as a separate pass
        // before the rest of the block.
        if (!emitHoistedFunctionsInList(body))
            return false;
    }

    // Line notes were updated by emitLexicalScope.
    return emitTree(body, emitLineNote);
}

// Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047. See
// the comment on emitSwitch.
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitLexicalScope(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_LEXICALSCOPE));

    TDZCheckCache tdzCache(this);

    ParseNode* body = pn->scopeBody();
    if (pn->isEmptyScope())
        return emitLexicalScopeBody(body);

    // Update line number notes before emitting TDZ poison in
    // EmitterScope::enterLexical to avoid spurious pausing on seemingly
    // non-effectful lines in Debugger.
    //
    // For example, consider the following code.
    //
    // L1: {
    // L2:   let x = 42;
    // L3: }
    //
    // If line number notes were not updated before the TDZ poison, the TDZ
    // poison bytecode sequence of 'uninitialized; initlexical' will have line
    // number L1, and the Debugger will pause there.
    if (!ParseNodeRequiresSpecialLineNumberNotes(body)) {
        ParseNode* pnForPos = body;
        if (body->isKind(PNK_STATEMENTLIST) && body->pn_head)
            pnForPos = body->pn_head;
        if (!updateLineNumberNotes(pnForPos->pn_pos.begin))
            return false;
    }

    EmitterScope emitterScope(this);
    ScopeKind kind;
    if (body->isKind(PNK_CATCH))
        kind = body->pn_kid1->isKind(PNK_NAME) ? ScopeKind::SimpleCatch : ScopeKind::Catch;
    else
        kind = ScopeKind::Lexical;

    if (!emitterScope.enterLexical(this, kind, pn->scopeBindings()))
        return false;

    if (body->isKind(PNK_FOR)) {
        // for loops need to emit {FRESHEN,RECREATE}LEXICALENV if there are
        // lexical declarations in the head. Signal this by passing a
        // non-nullptr lexical scope.
        if (!emitFor(body, &emitterScope))
            return false;
    } else {
        if (!emitLexicalScopeBody(body, SUPPRESS_LINENOTE))
            return false;
    }

    return emitterScope.leave(this);
}

bool
BytecodeEmitter::emitWith(ParseNode* pn)
{
    if (!emitTree(pn->pn_left))
        return false;

    EmitterScope emitterScope(this);
    if (!emitterScope.enterWith(this))
        return false;

    if (!emitTree(pn->pn_right))
        return false;

    return emitterScope.leave(this);
}

bool
BytecodeEmitter::emitRequireObjectCoercible()
{
    // For simplicity, handle this in self-hosted code, at cost of 13 bytes of
    // bytecode versus 1 byte for a dedicated opcode.  As more places need this
    // behavior, we may want to reconsider this tradeoff.

#ifdef DEBUG
    auto depth = this->stackDepth;
#endif
    MOZ_ASSERT(depth > 0);                 // VAL
    if (!emit1(JSOP_DUP))                  // VAL VAL
        return false;

    // Note that "intrinsic" is a misnomer: we're calling a *self-hosted*
    // function that's not an intrinsic!  But it nonetheless works as desired.
    if (!emitAtomOp(cx->names().RequireObjectCoercible,
                    JSOP_GETINTRINSIC))    // VAL VAL REQUIREOBJECTCOERCIBLE
    {
        return false;
    }
    if (!emit1(JSOP_UNDEFINED))            // VAL VAL REQUIREOBJECTCOERCIBLE UNDEFINED
        return false;
    if (!emit2(JSOP_PICK, 2))              // VAL REQUIREOBJECTCOERCIBLE UNDEFINED VAL
        return false;
    if (!emitCall(JSOP_CALL, 1))           // VAL IGNORED
        return false;
    checkTypeSet(JSOP_CALL);

    if (!emit1(JSOP_POP))                  // VAL
        return false;

    MOZ_ASSERT(depth == this->stackDepth);
    return true;
}

bool
BytecodeEmitter::emitIterator()
{
    // Convert iterable to iterator.
    if (!emit1(JSOP_DUP))                                         // OBJ OBJ
        return false;
    if (!emit2(JSOP_SYMBOL, uint8_t(JS::SymbolCode::iterator)))   // OBJ OBJ @@ITERATOR
        return false;
    if (!emitElemOpBase(JSOP_CALLELEM))                           // OBJ ITERFN
        return false;
    if (!emit1(JSOP_SWAP))                                        // ITERFN OBJ
        return false;
    if (!emitCall(JSOP_CALLITER, 0))                              // ITER
        return false;
    checkTypeSet(JSOP_CALLITER);
    if (!emitCheckIsObj(CheckIsObjectKind::GetIterator))          // ITER
        return false;
    return true;
}

bool
BytecodeEmitter::emitSpread(bool allowSelfHosted)
{
    LoopControl loopInfo(this, StatementKind::Spread);

    // Jump down to the loop condition to minimize overhead assuming at least
    // one iteration, as the other loop forms do.  Annotate so IonMonkey can
    // find the loop-closing jump.
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR_OF, &noteIndex))
        return false;

    // Jump down to the loop condition to minimize overhead, assuming at least
    // one iteration.  (This is also what we do for loops; whether this
    // assumption holds for spreads is an unanswered question.)
    JumpList initialJump;
    if (!emitJump(JSOP_GOTO, &initialJump))               // ITER ARR I (during the goto)
        return false;

    JumpTarget top{ -1 };
    if (!emitLoopHead(nullptr, &top))                     // ITER ARR I
        return false;

    // When we enter the goto above, we have ITER ARR I on the stack.  But when
    // we reach this point on the loop backedge (if spreading produces at least
    // one value), we've additionally pushed a RESULT iteration value.
    // Increment manually to reflect this.
    this->stackDepth++;

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    {
#ifdef DEBUG
        auto loopDepth = this->stackDepth;
#endif

        // Emit code to assign result.value to the iteration variable.
        if (!emitAtomOp(cx->names().value, JSOP_GETPROP)) // ITER ARR I VALUE
            return false;
        if (!emit1(JSOP_INITELEM_INC))                    // ITER ARR (I+1)
            return false;

        MOZ_ASSERT(this->stackDepth == loopDepth - 1);

        // Spread operations can't contain |continue|, so don't bother setting loop
        // and enclosing "update" offsets, as we do with for-loops.

        // COME FROM the beginning of the loop to here.
        if (!emitLoopEntry(nullptr, initialJump))         // ITER ARR I
            return false;

        if (!emitDupAt(2))                                // ITER ARR I ITER
            return false;
        if (!emitIteratorNext(nullptr, allowSelfHosted))  // ITER ARR I RESULT
            return false;
        if (!emit1(JSOP_DUP))                             // ITER ARR I RESULT RESULT
            return false;
        if (!emitAtomOp(cx->names().done, JSOP_GETPROP))  // ITER ARR I RESULT DONE?
            return false;

        if (!emitBackwardJump(JSOP_IFEQ, top, &beq, &breakTarget)) // ITER ARR I RESULT
            return false;

        MOZ_ASSERT(this->stackDepth == loopDepth);
    }

    // Let Ion know where the closing jump of this loop is.
    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - initialJump.offset))
        return false;

    // No breaks or continues should occur in spreads.
    MOZ_ASSERT(loopInfo.breaks.offset == -1);
    MOZ_ASSERT(loopInfo.continues.offset == -1);

    if (!tryNoteList.append(JSTRY_FOR_OF, stackDepth, top.offset, breakTarget.offset))
        return false;

    if (!emit2(JSOP_PICK, 3))                             // ARR FINAL_INDEX RESULT ITER
        return false;

    return emitUint16Operand(JSOP_POPN, 2);               // ARR FINAL_INDEX
}

bool
BytecodeEmitter::emitInitializeForInOrOfTarget(ParseNode* forHead)
{
    MOZ_ASSERT(forHead->isKind(PNK_FORIN) || forHead->isKind(PNK_FOROF));
    MOZ_ASSERT(forHead->isArity(PN_TERNARY));

    MOZ_ASSERT(this->stackDepth >= 1,
               "must have a per-iteration value for initializing");

    ParseNode* target = forHead->pn_kid1;
    MOZ_ASSERT(!forHead->pn_kid2);

    // If the for-in/of loop didn't have a variable declaration, per-loop
    // initialization is just assigning the iteration value to a target
    // expression.
    if (!parser->handler.isDeclarationList(target))
        return emitAssignment(target, JSOP_NOP, nullptr); // ... ITERVAL

    // Otherwise, per-loop initialization is (possibly) declaration
    // initialization.  If the declaration is a lexical declaration, it must be
    // initialized.  If the declaration is a variable declaration, an
    // assignment to that name (which does *not* necessarily assign to the
    // variable!) must be generated.

    if (!updateSourceCoordNotes(target->pn_pos.begin))
        return false;

    MOZ_ASSERT(target->isForLoopDeclaration());
    target = parser->handler.singleBindingFromDeclaration(target);

    if (target->isKind(PNK_NAME)) {
        auto emitSwapScopeAndRhs = [](BytecodeEmitter* bce, const NameLocation&,
                                      bool emittedBindOp)
        {
            if (emittedBindOp) {
                // Per-iteration initialization in for-in/of loops computes the
                // iteration value *before* initializing.  Thus the
                // initializing value may be buried under a bind-specific value
                // on the stack.  Swap it to the top of the stack.
                MOZ_ASSERT(bce->stackDepth >= 2);
                return bce->emit1(JSOP_SWAP);
            }

            // In cases of emitting a frame slot or environment slot,
            // nothing needs be done.
            MOZ_ASSERT(bce->stackDepth >= 1);
            return true;
        };

        // The caller handles removing the iteration value from the stack.
        return emitInitializeName(target, emitSwapScopeAndRhs);
    }

    MOZ_ASSERT(!target->isKind(PNK_ASSIGN),
               "for-in/of loop destructuring declarations can't have initializers");

    MOZ_ASSERT(target->isKind(PNK_ARRAY) || target->isKind(PNK_OBJECT));
    return emitDestructuringOps(target, DestructuringDeclaration);
}

bool
BytecodeEmitter::emitForOf(ParseNode* forOfLoop, EmitterScope* headLexicalEmitterScope)
{
    MOZ_ASSERT(forOfLoop->isKind(PNK_FOR));
    MOZ_ASSERT(forOfLoop->isArity(PN_BINARY));

    ParseNode* forOfHead = forOfLoop->pn_left;
    MOZ_ASSERT(forOfHead->isKind(PNK_FOROF));
    MOZ_ASSERT(forOfHead->isArity(PN_TERNARY));

    // Evaluate the expression being iterated.
    ParseNode* forHeadExpr = forOfHead->pn_kid3;
    if (!emitTree(forHeadExpr))                           // ITERABLE
        return false;
    if (!emitIterator())                                  // ITER
        return false;

    // For-of loops have both the iterator and the value on the stack. Push
    // undefined to balance the stack.
    if (!emit1(JSOP_UNDEFINED))                           // ITER RESULT
        return false;

    LoopControl loopInfo(this, StatementKind::ForOfLoop);

    // Annotate so IonMonkey can find the loop-closing jump.
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR_OF, &noteIndex))
        return false;

    JumpList initialJump;
    if (!emitJump(JSOP_GOTO, &initialJump))               // ITER RESULT
        return false;

    JumpTarget top{ -1 };
    if (!emitLoopHead(nullptr, &top))                     // ITER RESULT
        return false;

    // If the loop had an escaping lexical declaration, replace the current
    // environment with an dead zoned one to implement TDZ semantics.
    if (headLexicalEmitterScope) {
        // The environment chain only includes an environment for the for-of
        // loop head *if* a scope binding is captured, thereby requiring
        // recreation each iteration. If a lexical scope exists for the head,
        // it must be the innermost one. If that scope has closed-over
        // bindings inducing an environment, recreate the current environment.
        DebugOnly<ParseNode*> forOfTarget = forOfHead->pn_kid1;
        MOZ_ASSERT(forOfTarget->isKind(PNK_LET) || forOfTarget->isKind(PNK_CONST));
        MOZ_ASSERT(headLexicalEmitterScope == innermostEmitterScope);
        MOZ_ASSERT(headLexicalEmitterScope->scope(this)->kind() == ScopeKind::Lexical);

        if (headLexicalEmitterScope->hasEnvironment()) {
            if (!emit1(JSOP_RECREATELEXICALENV))          // ITER RESULT
                return false;
        }

        // For uncaptured bindings, put them back in TDZ.
        if (!headLexicalEmitterScope->deadZoneFrameSlots(this))
            return false;
    }

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    {
#ifdef DEBUG
        auto loopDepth = this->stackDepth;
#endif

        // Emit code to assign result.value to the iteration variable.
        if (!emit1(JSOP_DUP))                             // ITER RESULT RESULT
            return false;
        if (!emitAtomOp(cx->names().value, JSOP_GETPROP)) // ITER RESULT VALUE
            return false;

        if (!emitInitializeForInOrOfTarget(forOfHead))    // ITER RESULT VALUE
            return false;

        if (!emit1(JSOP_POP))                             // ITER RESULT
            return false;

        MOZ_ASSERT(this->stackDepth == loopDepth,
                   "the stack must be balanced around the initializing "
                   "operation");

        // Perform the loop body.
        ParseNode* forBody = forOfLoop->pn_right;
        if (!emitTree(forBody))                           // ITER RESULT
            return false;

        // Set offset for continues.
        loopInfo.continueTarget = { offset() };

        if (!emitLoopEntry(forHeadExpr, initialJump))     // ITER RESULT
            return false;

        if (!emit1(JSOP_POP))                             // ITER
            return false;
        if (!emit1(JSOP_DUP))                             // ITER ITER
            return false;

        if (!emitIteratorNext(forOfHead))                 // ITER RESULT
            return false;
        if (!emit1(JSOP_DUP))                             // ITER RESULT RESULT
            return false;
        if (!emitAtomOp(cx->names().done, JSOP_GETPROP))  // ITER RESULT DONE?
            return false;

        if (!emitBackwardJump(JSOP_IFEQ, top, &beq, &breakTarget))
            return false;                                 // ITER RESULT

        MOZ_ASSERT(this->stackDepth == loopDepth);
    }

    // Let Ion know where the closing jump of this loop is.
    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - initialJump.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    if (!tryNoteList.append(JSTRY_FOR_OF, stackDepth, top.offset, breakTarget.offset))
        return false;

    return emitUint16Operand(JSOP_POPN, 2);               //
}

bool
BytecodeEmitter::emitForIn(ParseNode* forInLoop, EmitterScope* headLexicalEmitterScope)
{
    MOZ_ASSERT(forInLoop->isKind(PNK_FOR));
    MOZ_ASSERT(forInLoop->isArity(PN_BINARY));
    MOZ_ASSERT(forInLoop->isOp(JSOP_ITER));

    ParseNode* forInHead = forInLoop->pn_left;
    MOZ_ASSERT(forInHead->isKind(PNK_FORIN));
    MOZ_ASSERT(forInHead->isArity(PN_TERNARY));

    // Annex B: Evaluate the var-initializer expression if present.
    // |for (var i = initializer in expr) { ... }|
    ParseNode* forInTarget = forInHead->pn_kid1;
    if (parser->handler.isDeclarationList(forInTarget)) {
        ParseNode* decl = parser->handler.singleBindingFromDeclaration(forInTarget);
        if (decl->isKind(PNK_NAME)) {
            if (ParseNode* initializer = decl->expr()) {
                MOZ_ASSERT(forInTarget->isKind(PNK_VAR),
                           "for-in initializers are only permitted for |var| declarations");

                if (!updateSourceCoordNotes(decl->pn_pos.begin))
                    return false;

                auto emitRhs = [initializer](BytecodeEmitter* bce, const NameLocation&, bool) {
                    return bce->emitTree(initializer);
                };

                if (!emitInitializeName(decl, emitRhs))
                    return false;

                // Pop the initializer.
                if (!emit1(JSOP_POP))
                    return false;
            }
        }
    }

    // Evaluate the expression being iterated.
    ParseNode* expr = forInHead->pn_kid3;
    if (!emitTree(expr))                                  // EXPR
        return false;

    // Convert the value to the appropriate sort of iterator object for the
    // loop variant (for-in, for-each-in, or destructuring for-in).
    unsigned iflags = forInLoop->pn_iflags;
    MOZ_ASSERT(0 == (iflags & ~(JSITER_FOREACH | JSITER_ENUMERATE)));
    if (!emit2(JSOP_ITER, AssertedCast<uint8_t>(iflags))) // ITER
        return false;

    // For-in loops have both the iterator and the value on the stack. Push
    // undefined to balance the stack.
    if (!emit1(JSOP_UNDEFINED))                           // ITER ITERVAL
        return false;

    LoopControl loopInfo(this, StatementKind::ForInLoop);

    /* Annotate so IonMonkey can find the loop-closing jump. */
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR_IN, &noteIndex))
        return false;

    // Jump down to the loop condition to minimize overhead (assuming at least
    // one iteration, just like the other loop forms).
    JumpList initialJump;
    if (!emitJump(JSOP_GOTO, &initialJump))               // ITER ITERVAL
        return false;

    JumpTarget top{ -1 };
    if (!emitLoopHead(nullptr, &top))                     // ITER ITERVAL
        return false;

    // If the loop had an escaping lexical declaration, replace the current
    // environment with an dead zoned one to implement TDZ semantics.
    if (headLexicalEmitterScope) {
        // The environment chain only includes an environment for the for-in
        // loop head *if* a scope binding is captured, thereby requiring
        // recreation each iteration. If a lexical scope exists for the head,
        // it must be the innermost one. If that scope has closed-over
        // bindings inducing an environment, recreate the current environment.
        MOZ_ASSERT(forInTarget->isKind(PNK_LET) || forInTarget->isKind(PNK_CONST));
        MOZ_ASSERT(headLexicalEmitterScope == innermostEmitterScope);
        MOZ_ASSERT(headLexicalEmitterScope->scope(this)->kind() == ScopeKind::Lexical);

        if (headLexicalEmitterScope->hasEnvironment()) {
            if (!emit1(JSOP_RECREATELEXICALENV))          // ITER ITERVAL
                return false;
        }

        // For uncaptured bindings, put them back in TDZ.
        if (!headLexicalEmitterScope->deadZoneFrameSlots(this))
            return false;
    }

    {
#ifdef DEBUG
        auto loopDepth = this->stackDepth;
#endif
        MOZ_ASSERT(loopDepth >= 2);

        if (!emitInitializeForInOrOfTarget(forInHead))    // ITER ITERVAL
            return false;

        MOZ_ASSERT(this->stackDepth == loopDepth,
                   "iterator and iterval must be left on the stack");
    }

    // Perform the loop body.
    ParseNode* forBody = forInLoop->pn_right;
    if (!emitTree(forBody))                               // ITER ITERVAL
        return false;

    // Set offset for continues.
    loopInfo.continueTarget = { offset() };

    if (!emitLoopEntry(nullptr, initialJump))             // ITER ITERVAL
        return false;
    if (!emit1(JSOP_POP))                                 // ITER
        return false;
    if (!emit1(JSOP_MOREITER))                            // ITER NEXTITERVAL?
        return false;
    if (!emit1(JSOP_ISNOITER))                            // ITER NEXTITERVAL? ISNOITER
        return false;

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFEQ, top, &beq, &breakTarget))
        return false;                                     // ITER NEXTITERVAL

    // Set the srcnote offset so we can find the closing jump.
    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - initialJump.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    // Pop the enumeration value.
    if (!emit1(JSOP_POP))                                 // ITER
        return false;

    if (!tryNoteList.append(JSTRY_FOR_IN, this->stackDepth, top.offset, offset()))
        return false;

    return emit1(JSOP_ENDITER);                           //
}

/* C-style `for (init; cond; update) ...` loop. */
bool
BytecodeEmitter::emitCStyleFor(ParseNode* pn, EmitterScope* headLexicalEmitterScope)
{
    LoopControl loopInfo(this, StatementKind::ForLoop);

    ParseNode* forHead = pn->pn_left;
    ParseNode* forBody = pn->pn_right;

    // If the head of this for-loop declared any lexical variables, the parser
    // wrapped this PNK_FOR node in a PNK_LEXICALSCOPE representing the
    // implicit scope of those variables. By the time we get here, we have
    // already entered that scope. So far, so good.
    //
    // ### Scope freshening
    //
    // Each iteration of a `for (let V...)` loop creates a fresh loop variable
    // binding for V, even if the loop is a C-style `for(;;)` loop:
    //
    //     var funcs = [];
    //     for (let i = 0; i < 2; i++)
    //         funcs.push(function() { return i; });
    //     assertEq(funcs[0](), 0);  // the two closures capture...
    //     assertEq(funcs[1](), 1);  // ...two different `i` bindings
    //
    // This is implemented by "freshening" the implicit block -- changing the
    // scope chain to a fresh clone of the instantaneous block object -- each
    // iteration, just before evaluating the "update" in for(;;) loops.
    //
    // No freshening occurs in `for (const ...;;)` as there's no point: you
    // can't reassign consts. This is observable through the Debugger API. (The
    // ES6 spec also skips cloning the environment in this case.)
    bool forLoopRequiresFreshening = false;
    if (ParseNode* init = forHead->pn_kid1) {
        // Emit the `init` clause, whether it's an expression or a variable
        // declaration. (The loop variables were hoisted into an enclosing
        // scope, but we still need to emit code for the initializers.)
        if (!updateSourceCoordNotes(init->pn_pos.begin))
            return false;
        if (!emitTree(init))
            return false;

        if (!init->isForLoopDeclaration()) {
            // 'init' is an expression, not a declaration. emitTree left its
            // value on the stack.
            if (!emit1(JSOP_POP))
                return false;
        }

        // ES 13.7.4.8 step 2. The initial freshening.
        //
        // If an initializer let-declaration may be captured during loop iteration,
        // the current scope has an environment.  If so, freshen the current
        // environment to expose distinct bindings for each loop iteration.
        forLoopRequiresFreshening = init->isKind(PNK_LET) && headLexicalEmitterScope;
        if (forLoopRequiresFreshening) {
            // The environment chain only includes an environment for the for(;;)
            // loop head's let-declaration *if* a scope binding is captured, thus
            // requiring a fresh environment each iteration. If a lexical scope
            // exists for the head, it must be the innermost one. If that scope
            // has closed-over bindings inducing an environment, recreate the
            // current environment.
            MOZ_ASSERT(headLexicalEmitterScope == innermostEmitterScope);
            MOZ_ASSERT(headLexicalEmitterScope->scope(this)->kind() == ScopeKind::Lexical);

            if (headLexicalEmitterScope->hasEnvironment()) {
                if (!emit1(JSOP_FRESHENLEXICALENV))
                    return false;
            }
        }
    }

    /*
     * NB: the SRC_FOR note has offsetBias 1 (JSOP_NOP_LENGTH).
     * Use tmp to hold the biased srcnote "top" offset, which differs
     * from the top local variable by the length of the JSOP_GOTO
     * emitted in between tmp and top if this loop has a condition.
     */
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR, &noteIndex))
        return false;
    if (!emit1(JSOP_NOP))
        return false;
    ptrdiff_t tmp = offset();

    JumpList jmp;
    if (forHead->pn_kid2) {
        /* Goto the loop condition, which branches back to iterate. */
        if (!emitJump(JSOP_GOTO, &jmp))
            return false;
    }

    /* Emit code for the loop body. */
    JumpTarget top{ -1 };
    if (!emitLoopHead(forBody, &top))
        return false;
    if (jmp.offset == -1 && !emitLoopEntry(forBody, jmp))
        return false;

    if (!emitConditionallyExecutedTree(forBody))
        return false;

    // Set loop and enclosing "update" offsets, for continue.  Note that we
    // continue to immediately *before* the block-freshening: continuing must
    // refresh the block.
    if (!emitJumpTarget(&loopInfo.continueTarget))
        return false;

    // ES 13.7.4.8 step 3.e. The per-iteration freshening.
    if (forLoopRequiresFreshening) {
        MOZ_ASSERT(headLexicalEmitterScope == innermostEmitterScope);
        MOZ_ASSERT(headLexicalEmitterScope->scope(this)->kind() == ScopeKind::Lexical);

        if (headLexicalEmitterScope->hasEnvironment()) {
            if (!emit1(JSOP_FRESHENLEXICALENV))
                return false;
        }
    }

    // Check for update code to do before the condition (if any).
    // The update code may not be executed at all; it needs its own TDZ cache.
    if (ParseNode* update = forHead->pn_kid3) {
        TDZCheckCache tdzCache(this);

        if (!updateSourceCoordNotes(update->pn_pos.begin))
            return false;
        if (!emitTree(update))
            return false;
        if (!emit1(JSOP_POP))
            return false;

        /* Restore the absolute line number for source note readers. */
        uint32_t lineNum = parser->tokenStream.srcCoords.lineNum(pn->pn_pos.end);
        if (currentLine() != lineNum) {
            if (!newSrcNote2(SRC_SETLINE, ptrdiff_t(lineNum)))
                return false;
            current->currentLine = lineNum;
            current->lastColumn = 0;
        }
    }

    ptrdiff_t tmp3 = offset();

    if (forHead->pn_kid2) {
        /* Fix up the goto from top to target the loop condition. */
        MOZ_ASSERT(jmp.offset >= 0);
        if (!emitLoopEntry(forHead->pn_kid2, jmp))
            return false;

        if (!emitTree(forHead->pn_kid2))
            return false;
    } else if (!forHead->pn_kid3) {
        // If there is no condition clause and no update clause, mark
        // the loop-ending "goto" with the location of the "for".
        // This ensures that the debugger will stop on each loop
        // iteration.
        if (!updateSourceCoordNotes(pn->pn_pos.begin))
            return false;
    }

    /* Set the first note offset so we can find the loop condition. */
    if (!setSrcNoteOffset(noteIndex, 0, tmp3 - tmp))
        return false;
    if (!setSrcNoteOffset(noteIndex, 1, loopInfo.continueTarget.offset - tmp))
        return false;

    /* If no loop condition, just emit a loop-closing jump. */
    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(forHead->pn_kid2 ? JSOP_IFNE : JSOP_GOTO, top, &beq, &breakTarget))
        return false;

    /* The third note offset helps us find the loop-closing jump. */
    if (!setSrcNoteOffset(noteIndex, 2, beq.offset - tmp))
        return false;

    if (!tryNoteList.append(JSTRY_LOOP, stackDepth, top.offset, breakTarget.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    return true;
}

bool
BytecodeEmitter::emitFor(ParseNode* pn, EmitterScope* headLexicalEmitterScope)
{
    MOZ_ASSERT(pn->isKind(PNK_FOR));

    if (pn->pn_left->isKind(PNK_FORHEAD))
        return emitCStyleFor(pn, headLexicalEmitterScope);

    if (!updateLineNumberNotes(pn->pn_pos.begin))
        return false;

    if (pn->pn_left->isKind(PNK_FORIN))
        return emitForIn(pn, headLexicalEmitterScope);

    MOZ_ASSERT(pn->pn_left->isKind(PNK_FOROF));
    return emitForOf(pn, headLexicalEmitterScope);
}

bool
BytecodeEmitter::emitComprehensionForInOrOfVariables(ParseNode* pn, bool* lexicalScope)
{
    // ES6 specifies that lexical for-loop variables get a fresh binding each
    // iteration, and that evaluation of the expression looped over occurs with
    // these variables dead zoned.  But these rules only apply to *standard*
    // for-in/of loops, and we haven't extended these requirements to
    // comprehension syntax.

    *lexicalScope = pn->isKind(PNK_LEXICALSCOPE);
    if (*lexicalScope) {
        // This is initially-ES7-tracked syntax, now with considerably murkier
        // outlook. The scope work is done by the caller by instantiating an
        // EmitterScope. There's nothing to do here.
    } else {
        // This is legacy comprehension syntax.  We'll have PNK_LET here, using
        // a lexical scope provided by/for the entire comprehension.  Name
        // analysis assumes declarations initialize lets, but as we're handling
        // this declaration manually, we must also initialize manually to avoid
        // triggering dead zone checks.
        MOZ_ASSERT(pn->isKind(PNK_LET));
        MOZ_ASSERT(pn->pn_count == 1);

        if (!emitDeclarationList(pn))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitComprehensionForOf(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_COMPREHENSIONFOR));

    ParseNode* forHead = pn->pn_left;
    MOZ_ASSERT(forHead->isKind(PNK_FOROF));

    ParseNode* forHeadExpr = forHead->pn_kid3;
    ParseNode* forBody = pn->pn_right;

    ParseNode* loopDecl = forHead->pn_kid1;
    bool lexicalScope = false;
    if (!emitComprehensionForInOrOfVariables(loopDecl, &lexicalScope))
        return false;

    // For-of loops run with two values on the stack: the iterator and the
    // current result object.

    // Evaluate the expression to the right of 'of'.
    if (!emitTree(forHeadExpr))                // EXPR
        return false;
    if (!emitIterator())                       // ITER
        return false;

    // Push a dummy result so that we properly enter iteration midstream.
    if (!emit1(JSOP_UNDEFINED))                // ITER RESULT
        return false;

    // Enter the block before the loop body, after evaluating the obj.
    // Initialize let bindings with undefined when entering, as the name
    // assigned to is a plain assignment.
    TDZCheckCache tdzCache(this);
    Maybe<EmitterScope> emitterScope;
    ParseNode* loopVariableName;
    if (lexicalScope) {
        loopVariableName = parser->handler.singleBindingFromDeclaration(loopDecl->pn_expr);
        emitterScope.emplace(this);
        if (!emitterScope->enterComprehensionFor(this, loopDecl->scopeBindings()))
            return false;
    } else {
        loopVariableName = parser->handler.singleBindingFromDeclaration(loopDecl);
    }

    LoopControl loopInfo(this, StatementKind::ForOfLoop);

    // Jump down to the loop condition to minimize overhead assuming at least
    // one iteration, as the other loop forms do.  Annotate so IonMonkey can
    // find the loop-closing jump.
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR_OF, &noteIndex))
        return false;
    JumpList jmp;
    if (!emitJump(JSOP_GOTO, &jmp))
        return false;

    JumpTarget top{ -1 };
    if (!emitLoopHead(nullptr, &top))
        return false;

#ifdef DEBUG
    int loopDepth = this->stackDepth;
#endif

    // Emit code to assign result.value to the iteration variable.
    if (!emit1(JSOP_DUP))                                 // ITER RESULT RESULT
        return false;
    if (!emitAtomOp(cx->names().value, JSOP_GETPROP))     // ITER RESULT VALUE
        return false;
    if (!emitAssignment(loopVariableName, JSOP_NOP, nullptr)) // ITER RESULT VALUE
        return false;
    if (!emit1(JSOP_POP))                                 // ITER RESULT
        return false;

    // The stack should be balanced around the assignment opcode sequence.
    MOZ_ASSERT(this->stackDepth == loopDepth);

    // Emit code for the loop body.
    if (!emitTree(forBody))
        return false;

    // Set offset for continues.
    loopInfo.continueTarget = { offset() };

    if (!emitLoopEntry(forHeadExpr, jmp))
        return false;

    if (!emit1(JSOP_POP))                                 // ITER
        return false;
    if (!emit1(JSOP_DUP))                                 // ITER ITER
        return false;
    if (!emitIteratorNext(forHead))                       // ITER RESULT
        return false;
    if (!emit1(JSOP_DUP))                                 // ITER RESULT RESULT
        return false;
    if (!emitAtomOp(cx->names().done, JSOP_GETPROP))      // ITER RESULT DONE?
        return false;

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFEQ, top, &beq, &breakTarget)) // ITER RESULT
        return false;

    MOZ_ASSERT(this->stackDepth == loopDepth);

    // Let Ion know where the closing jump of this loop is.
    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - jmp.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    if (!tryNoteList.append(JSTRY_FOR_OF, stackDepth, top.offset, breakTarget.offset))
        return false;

    if (emitterScope) {
        if (!emitterScope->leave(this))
            return false;
        emitterScope.reset();
    }

    // Pop the result and the iter.
    return emitUint16Operand(JSOP_POPN, 2);               //
}

bool
BytecodeEmitter::emitComprehensionForIn(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_COMPREHENSIONFOR));

    ParseNode* forHead = pn->pn_left;
    MOZ_ASSERT(forHead->isKind(PNK_FORIN));

    ParseNode* forBody = pn->pn_right;

    ParseNode* loopDecl = forHead->pn_kid1;
    bool lexicalScope = false;
    if (loopDecl && !emitComprehensionForInOrOfVariables(loopDecl, &lexicalScope))
        return false;

    // Evaluate the expression to the right of 'in'.
    if (!emitTree(forHead->pn_kid3))
        return false;

    /*
     * Emit a bytecode to convert top of stack value to the iterator
     * object depending on the loop variant (for-in, for-each-in, or
     * destructuring for-in).
     */
    MOZ_ASSERT(pn->isOp(JSOP_ITER));
    if (!emit2(JSOP_ITER, (uint8_t) pn->pn_iflags))
        return false;

    // For-in loops have both the iterator and the value on the stack. Push
    // undefined to balance the stack.
    if (!emit1(JSOP_UNDEFINED))
        return false;

    // Enter the block before the loop body, after evaluating the obj.
    // Initialize let bindings with undefined when entering, as the name
    // assigned to is a plain assignment.
    TDZCheckCache tdzCache(this);
    Maybe<EmitterScope> emitterScope;
    if (lexicalScope) {
        emitterScope.emplace(this);
        if (!emitterScope->enterComprehensionFor(this, loopDecl->scopeBindings()))
            return false;
    }

    LoopControl loopInfo(this, StatementKind::ForInLoop);

    /* Annotate so IonMonkey can find the loop-closing jump. */
    unsigned noteIndex;
    if (!newSrcNote(SRC_FOR_IN, &noteIndex))
        return false;

    /*
     * Jump down to the loop condition to minimize overhead assuming at
     * least one iteration, as the other loop forms do.
     */
    JumpList jmp;
    if (!emitJump(JSOP_GOTO, &jmp))
        return false;

    JumpTarget top{ -1 };
    if (!emitLoopHead(nullptr, &top))
        return false;

#ifdef DEBUG
    int loopDepth = this->stackDepth;
#endif

    // Emit code to assign the enumeration value to the left hand side, but
    // also leave it on the stack.
    if (!emitAssignment(forHead->pn_kid2, JSOP_NOP, nullptr))
        return false;

    /* The stack should be balanced around the assignment opcode sequence. */
    MOZ_ASSERT(this->stackDepth == loopDepth);

    /* Emit code for the loop body. */
    if (!emitTree(forBody))
        return false;

    // Set offset for continues.
    loopInfo.continueTarget = { offset() };

    if (!emitLoopEntry(nullptr, jmp))
        return false;
    if (!emit1(JSOP_POP))
        return false;
    if (!emit1(JSOP_MOREITER))
        return false;
    if (!emit1(JSOP_ISNOITER))
        return false;
    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFEQ, top, &beq, &breakTarget))
        return false;

    /* Set the srcnote offset so we can find the closing jump. */
    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - jmp.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    // Pop the enumeration value.
    if (!emit1(JSOP_POP))
        return false;

    JumpTarget endIter{ offset() };
    if (!tryNoteList.append(JSTRY_FOR_IN, this->stackDepth, top.offset, endIter.offset))
        return false;
    if (!emit1(JSOP_ENDITER))
        return false;

    if (emitterScope) {
        if (!emitterScope->leave(this))
            return false;
        emitterScope.reset();
    }

    return true;
}

bool
BytecodeEmitter::emitComprehensionFor(ParseNode* compFor)
{
    MOZ_ASSERT(compFor->pn_left->isKind(PNK_FORIN) ||
               compFor->pn_left->isKind(PNK_FOROF));

    if (!updateLineNumberNotes(compFor->pn_pos.begin))
        return false;

    return compFor->pn_left->isKind(PNK_FORIN)
           ? emitComprehensionForIn(compFor)
           : emitComprehensionForOf(compFor);
}

MOZ_NEVER_INLINE bool
BytecodeEmitter::emitFunction(ParseNode* pn, bool needsProto)
{
    FunctionBox* funbox = pn->pn_funbox;
    RootedFunction fun(cx, funbox->function());
    RootedAtom name(cx, fun->name());
    MOZ_ASSERT_IF(fun->isInterpretedLazy(), fun->lazyScript());
    MOZ_ASSERT_IF(pn->isOp(JSOP_FUNWITHPROTO), needsProto);

    /*
     * Set the |wasEmitted| flag in the funbox once the function has been
     * emitted. Function definitions that need hoisting to the top of the
     * function will be seen by emitFunction in two places.
     */
    if (funbox->wasEmitted && pn->functionIsHoisted()) {
        // Annex B block-scoped functions are hoisted like any other
        // block-scoped function to the top of their scope. When their
        // definitions are seen for the second time, we need to emit the
        // assignment that assigns the function to the outer 'var' binding.
        if (funbox->isAnnexB) {
            auto emitRhs = [&name](BytecodeEmitter* bce, const NameLocation&, bool) {
                // The RHS is the value of the lexically bound name in the
                // innermost scope.
                return bce->emitGetName(name);
            };

            // Get the location of the 'var' binding in the body scope. The
            // name must be found, else there is a bug in the Annex B handling
            // in Parser.
            //
            // In sloppy eval contexts, this location is dynamic.
            Maybe<NameLocation> lhsLoc = locationOfNameBoundInScope(name, varEmitterScope);

            // If there are parameter expressions, the var name could be a
            // parameter.
            if (!lhsLoc && sc->isFunctionBox() && sc->asFunctionBox()->hasExtraBodyVarScope())
                lhsLoc = locationOfNameBoundInScope(name, varEmitterScope->enclosingInFrame());

            if (!lhsLoc) {
                lhsLoc = Some(NameLocation::DynamicAnnexBVar());
            } else {
                MOZ_ASSERT(lhsLoc->bindingKind() == BindingKind::Var ||
                           lhsLoc->bindingKind() == BindingKind::FormalParameter ||
                           (lhsLoc->bindingKind() == BindingKind::Let &&
                            sc->asFunctionBox()->hasParameterExprs));
            }

            if (!emitSetOrInitializeNameAtLocation(name, *lhsLoc, emitRhs, false))
                return false;
            if (!emit1(JSOP_POP))
                return false;
        }

        MOZ_ASSERT_IF(fun->hasScript(), fun->nonLazyScript());
        MOZ_ASSERT(pn->functionIsHoisted());
        return true;
    }

    funbox->wasEmitted = true;

    /*
     * Mark as singletons any function which will only be executed once, or
     * which is inner to a lambda we only expect to run once. In the latter
     * case, if the lambda runs multiple times then CloneFunctionObject will
     * make a deep clone of its contents.
     */
    if (fun->isInterpreted()) {
        bool singleton = checkRunOnceContext();
        if (!JSFunction::setTypeForScriptedFunction(cx, fun, singleton))
            return false;

        SharedContext* outersc = sc;
        if (fun->isInterpretedLazy()) {
            // We need to update the static scope chain regardless of whether
            // the LazyScript has already been initialized, due to the case
            // where we previously successfully compiled an inner function's
            // lazy script but failed to compile the outer script after the
            // fact. If we attempt to compile the outer script again, the
            // static scope chain will be newly allocated and will mismatch
            // the previously compiled LazyScript's.
            ScriptSourceObject* source = &script->sourceObject()->as<ScriptSourceObject>();
            fun->lazyScript()->setEnclosingScopeAndSource(innermostScope(), source);
            if (emittingRunOnceLambda)
                fun->lazyScript()->setTreatAsRunOnce();
        } else {
            MOZ_ASSERT_IF(outersc->strict(), funbox->strictScript);

            // Inherit most things (principals, version, etc) from the
            // parent.  Use default values for the rest.
            Rooted<JSScript*> parent(cx, script);
            MOZ_ASSERT(parent->getVersion() == parser->options().version);
            MOZ_ASSERT(parent->mutedErrors() == parser->options().mutedErrors());
            const TransitiveCompileOptions& transitiveOptions = parser->options();
            CompileOptions options(cx, transitiveOptions);

            Rooted<JSObject*> sourceObject(cx, script->sourceObject());
            Rooted<JSScript*> script(cx, JSScript::Create(cx, options, sourceObject,
                                                          funbox->bufStart, funbox->bufEnd));
            if (!script)
                return false;

            BytecodeEmitter bce2(this, parser, funbox, script, /* lazyScript = */ nullptr,
                                 pn->pn_pos, emitterMode);
            if (!bce2.init())
                return false;

            /* We measured the max scope depth when we parsed the function. */
            if (!bce2.emitFunctionScript(pn->pn_body))
                return false;

            if (funbox->isLikelyConstructorWrapper())
                script->setLikelyConstructorWrapper();
        }

        if (outersc->isFunctionBox())
            outersc->asFunctionBox()->setHasInnerFunctions();
    } else {
        MOZ_ASSERT(IsAsmJSModule(fun));
    }

    /* Make the function object a literal in the outer script's pool. */
    unsigned index = objectList.add(pn->pn_funbox);

    /* Non-hoisted functions simply emit their respective op. */
    if (!pn->functionIsHoisted()) {
        /* JSOP_LAMBDA_ARROW is always preceded by a new.target */
        MOZ_ASSERT(fun->isArrow() == (pn->getOp() == JSOP_LAMBDA_ARROW));
        if (funbox->isAsync()) {
            MOZ_ASSERT(!needsProto);
            return emitAsyncWrapper(index, funbox->needsHomeObject(), fun->isArrow());
        }

        if (fun->isArrow()) {
            if (sc->allowNewTarget()) {
                if (!emit1(JSOP_NEWTARGET))
                    return false;
            } else {
                if (!emit1(JSOP_NULL))
                    return false;
            }
        }

        if (needsProto) {
            MOZ_ASSERT(pn->getOp() == JSOP_FUNWITHPROTO || pn->getOp() == JSOP_LAMBDA);
            pn->setOp(JSOP_FUNWITHPROTO);
        }

        if (pn->getOp() == JSOP_DEFFUN) {
            if (!emitIndex32(JSOP_LAMBDA, index))
                return false;
            return emit1(JSOP_DEFFUN);
        }

        return emitIndex32(pn->getOp(), index);
    }

    MOZ_ASSERT(!needsProto);

    bool topLevelFunction;
    if (sc->isFunctionBox() || (sc->isEvalContext() && sc->strict())) {
        // No nested functions inside other functions are top-level.
        topLevelFunction = false;
    } else {
        // In sloppy eval scripts, top-level functions in are accessed
        // dynamically. In global and module scripts, top-level functions are
        // those bound in the var scope.
        NameLocation loc = lookupName(name);
        topLevelFunction = loc.kind() == NameLocation::Kind::Dynamic ||
                           loc.bindingKind() == BindingKind::Var;
    }

    if (topLevelFunction) {
        if (sc->isModuleContext()) {
            // For modules, we record the function and instantiate the binding
            // during ModuleDeclarationInstantiation(), before the script is run.

            RootedModuleObject module(cx, sc->asModuleContext()->module());
            if (!module->noteFunctionDeclaration(cx, name, fun))
                return false;
        } else {
            MOZ_ASSERT(sc->isGlobalContext() || sc->isEvalContext());
            MOZ_ASSERT(pn->getOp() == JSOP_NOP);
            switchToPrologue();
            if (funbox->isAsync()) {
                if (!emitAsyncWrapper(index, fun->isMethod(), fun->isArrow()))
                    return false;
            } else {
                if (!emitIndex32(JSOP_LAMBDA, index))
                    return false;
            }
            if (!emit1(JSOP_DEFFUN))
                return false;
            if (!updateSourceCoordNotes(pn->pn_pos.begin))
                return false;
            switchToMain();
        }
    } else {
        // For functions nested within functions and blocks, make a lambda and
        // initialize the binding name of the function in the current scope.

        bool isAsync = funbox->isAsync();
        auto emitLambda = [index, isAsync](BytecodeEmitter* bce, const NameLocation&, bool) {
            if (isAsync) {
                return bce->emitAsyncWrapper(index, /* needsHomeObject = */ false,
                                             /* isArrow = */ false);
            }
            return bce->emitIndexOp(JSOP_LAMBDA, index);
        };

        if (!emitInitializeName(name, emitLambda))
            return false;
        if (!emit1(JSOP_POP))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitAsyncWrapperLambda(unsigned index, bool isArrow) {
    if (isArrow) {
        if (sc->allowNewTarget()) {
            if (!emit1(JSOP_NEWTARGET))
                return false;
        } else {
            if (!emit1(JSOP_NULL))
                return false;
        }
        if (!emitIndex32(JSOP_LAMBDA_ARROW, index))
            return false;
    } else {
        if (!emitIndex32(JSOP_LAMBDA, index))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitAsyncWrapper(unsigned index, bool needsHomeObject, bool isArrow)
{
    // needsHomeObject can be true for propertyList for extended class.
    // In that case push both unwrapped and wrapped function, in order to
    // initialize home object of unwrapped function, and set wrapped function
    // as a property.
    //
    //   lambda       // unwrapped
    //   dup          // unwrapped unwrapped
    //   toasync      // unwrapped wrapped
    //
    // Emitted code is surrounded by the following code.
    //
    //                    // classObj classCtor classProto
    //   (emitted code)   // classObj classCtor classProto unwrapped wrapped
    //   swap             // classObj classCtor classProto wrapped unwrapped
    //   inithomeobject 1 // classObj classCtor classProto wrapped unwrapped
    //                    //   initialize the home object of unwrapped
    //                    //   with classProto here
    //   pop              // classObj classCtor classProto wrapped
    //   inithiddenprop   // classObj classCtor classProto wrapped
    //                    //   initialize the property of the classProto
    //                    //   with wrapped function here
    //   pop              // classObj classCtor classProto
    //
    // needsHomeObject is false for other cases, push wrapped function only.
    if (!emitAsyncWrapperLambda(index, isArrow))
        return false;
    if (needsHomeObject) {
        if (!emit1(JSOP_DUP))
            return false;
    }
    if (!emit1(JSOP_TOASYNC))
        return false;
    return true;
}

bool
BytecodeEmitter::emitDo(ParseNode* pn)
{
    /* Emit an annotated nop so IonBuilder can recognize the 'do' loop. */
    unsigned noteIndex;
    if (!newSrcNote(SRC_WHILE, &noteIndex))
        return false;
    if (!emit1(JSOP_NOP))
        return false;

    unsigned noteIndex2;
    if (!newSrcNote(SRC_WHILE, &noteIndex2))
        return false;

    /* Compile the loop body. */
    JumpTarget top;
    if (!emitLoopHead(pn->pn_left, &top))
        return false;

    LoopControl loopInfo(this, StatementKind::DoLoop);

    JumpList empty;
    if (!emitLoopEntry(nullptr, empty))
        return false;

    if (!emitTree(pn->pn_left))
        return false;

    // Set the offset for continues.
    if (!emitJumpTarget(&loopInfo.continueTarget))
        return false;

    /* Compile the loop condition, now that continues know where to go. */
    if (!emitTree(pn->pn_right))
        return false;

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFNE, top, &beq, &breakTarget))
        return false;

    if (!tryNoteList.append(JSTRY_LOOP, stackDepth, top.offset, breakTarget.offset))
        return false;

    /*
     * Update the annotations with the update and back edge positions, for
     * IonBuilder.
     *
     * Be careful: We must set noteIndex2 before noteIndex in case the noteIndex
     * note gets bigger.
     */
    if (!setSrcNoteOffset(noteIndex2, 0, beq.offset - top.offset))
        return false;
    if (!setSrcNoteOffset(noteIndex, 0, 1 + (loopInfo.continueTarget.offset - top.offset)))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    return true;
}

bool
BytecodeEmitter::emitWhile(ParseNode* pn)
{
    /*
     * Minimize bytecodes issued for one or more iterations by jumping to
     * the condition below the body and closing the loop if the condition
     * is true with a backward branch. For iteration count i:
     *
     *  i    test at the top                 test at the bottom
     *  =    ===============                 ==================
     *  0    ifeq-pass                       goto; ifne-fail
     *  1    ifeq-fail; goto; ifne-pass      goto; ifne-pass; ifne-fail
     *  2    2*(ifeq-fail; goto); ifeq-pass  goto; 2*ifne-pass; ifne-fail
     *  . . .
     *  N    N*(ifeq-fail; goto); ifeq-pass  goto; N*ifne-pass; ifne-fail
     */

    // If we have a single-line while, like "while (x) ;", we want to
    // emit the line note before the initial goto, so that the
    // debugger sees a single entry point.  This way, if there is a
    // breakpoint on the line, it will only fire once; and "next"ing
    // will skip the whole loop.  However, for the multi-line case we
    // want to emit the line note after the initial goto, so that
    // "cont" stops on each iteration -- but without a stop before the
    // first iteration.
    if (parser->tokenStream.srcCoords.lineNum(pn->pn_pos.begin) ==
        parser->tokenStream.srcCoords.lineNum(pn->pn_pos.end) &&
        !updateSourceCoordNotes(pn->pn_pos.begin))
        return false;

    JumpTarget top{ -1 };
    if (!emitJumpTarget(&top))
        return false;

    LoopControl loopInfo(this, StatementKind::WhileLoop);
    loopInfo.continueTarget = top;

    unsigned noteIndex;
    if (!newSrcNote(SRC_WHILE, &noteIndex))
        return false;

    JumpList jmp;
    if (!emitJump(JSOP_GOTO, &jmp))
        return false;

    if (!emitLoopHead(pn->pn_right, &top))
        return false;

    if (!emitConditionallyExecutedTree(pn->pn_right))
        return false;

    if (!emitLoopEntry(pn->pn_left, jmp))
        return false;
    if (!emitTree(pn->pn_left))
        return false;

    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFNE, top, &beq, &breakTarget))
        return false;

    if (!tryNoteList.append(JSTRY_LOOP, stackDepth, top.offset, breakTarget.offset))
        return false;

    if (!setSrcNoteOffset(noteIndex, 0, beq.offset - jmp.offset))
        return false;

    if (!loopInfo.patchBreaksAndContinues(this))
        return false;

    return true;
}

bool
BytecodeEmitter::emitBreak(PropertyName* label)
{
    BreakableControl* target;
    SrcNoteType noteType;
    if (label) {
        // Any statement with the matching label may be the break target.
        auto hasSameLabel = [label](LabelControl* labelControl) {
            return labelControl->label() == label;
        };
        target = findInnermostNestableControl<LabelControl>(hasSameLabel);
        noteType = SRC_BREAK2LABEL;
    } else {
        auto isNotLabel = [](BreakableControl* control) {
            return !control->is<LabelControl>();
        };
        target = findInnermostNestableControl<BreakableControl>(isNotLabel);
        noteType = (target->kind() == StatementKind::Switch) ? SRC_SWITCHBREAK : SRC_BREAK;
    }

    return emitGoto(target, &target->breaks, noteType);
}

bool
BytecodeEmitter::emitContinue(PropertyName* label)
{
    LoopControl* target = nullptr;
    if (label) {
        // Find the loop statement enclosed by the matching label.
        NestableControl* control = innermostNestableControl;
        while (!control->is<LabelControl>() || control->as<LabelControl>().label() != label) {
            if (control->is<LoopControl>())
                target = &control->as<LoopControl>();
            control = control->enclosing();
        }
    } else {
        target = findInnermostNestableControl<LoopControl>();
    }
    return emitGoto(target, &target->continues, SRC_CONTINUE);
}

bool
BytecodeEmitter::emitGetFunctionThis(ParseNode* pn)
{
    MOZ_ASSERT(sc->thisBinding() == ThisBinding::Function);
    MOZ_ASSERT(pn->isKind(PNK_NAME));
    MOZ_ASSERT(pn->name() == cx->names().dotThis);

    if (!emitTree(pn))
        return false;
    if (sc->needsThisTDZChecks() && !emit1(JSOP_CHECKTHIS))
        return false;

    return true;
}

bool
BytecodeEmitter::emitGetThisForSuperBase(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_SUPERBASE));
    return emitGetFunctionThis(pn->pn_kid);
}

bool
BytecodeEmitter::emitThisLiteral(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_THIS));

    if (ParseNode* thisName = pn->pn_kid)
        return emitGetFunctionThis(thisName);

    if (sc->thisBinding() == ThisBinding::Module)
        return emit1(JSOP_UNDEFINED);

    MOZ_ASSERT(sc->thisBinding() == ThisBinding::Global);
    return emit1(JSOP_GLOBALTHIS);
}

bool
BytecodeEmitter::emitCheckDerivedClassConstructorReturn()
{
    MOZ_ASSERT(lookupName(cx->names().dotThis).hasKnownSlot());
    if (!emitGetName(cx->names().dotThis))
        return false;
    if (!emit1(JSOP_CHECKRETURN))
        return false;
    return true;
}

bool
BytecodeEmitter::emitReturn(ParseNode* pn)
{
    if (!updateSourceCoordNotes(pn->pn_pos.begin))
        return false;

    if (sc->isFunctionBox() && sc->asFunctionBox()->isStarGenerator()) {
        if (!emitPrepareIteratorResult())
            return false;
    }

    /* Push a return value */
    if (ParseNode* pn2 = pn->pn_kid) {
        if (!emitTree(pn2))
            return false;
    } else {
        /* No explicit return value provided */
        if (!emit1(JSOP_UNDEFINED))
            return false;
    }

    if (sc->isFunctionBox() && sc->asFunctionBox()->isStarGenerator()) {
        if (!emitFinishIteratorResult(true))
            return false;
    }

    // We know functionBodyEndPos is set because "return" is only
    // valid in a function, and so we've passed through
    // emitFunctionScript.
    MOZ_ASSERT(functionBodyEndPosSet);
    if (!updateSourceCoordNotes(functionBodyEndPos))
        return false;

    /*
     * EmitNonLocalJumpFixup may add fixup bytecode to close open try
     * blocks having finally clauses and to exit intermingled let blocks.
     * We can't simply transfer control flow to our caller in that case,
     * because we must gosub to those finally clauses from inner to outer,
     * with the correct stack pointer (i.e., after popping any with,
     * for/in, etc., slots nested inside the finally's try).
     *
     * In this case we mutate JSOP_RETURN into JSOP_SETRVAL and add an
     * extra JSOP_RETRVAL after the fixups.
     */
    ptrdiff_t top = offset();

    bool isGenerator = sc->isFunctionBox() && sc->asFunctionBox()->isGenerator();
    bool isDerivedClassConstructor =
        sc->isFunctionBox() && sc->asFunctionBox()->isDerivedClassConstructor();

    if (!emit1((isGenerator || isDerivedClassConstructor) ? JSOP_SETRVAL : JSOP_RETURN))
        return false;

    // Make sure that we emit this before popping the blocks in prepareForNonLocalJump,
    // to ensure that the error is thrown while the scope-chain is still intact.
    if (isDerivedClassConstructor) {
        if (!emitCheckDerivedClassConstructorReturn())
            return false;
    }

    NonLocalExitControl nle(this);

    if (!nle.prepareForNonLocalJumpToOutermost())
        return false;

    if (isGenerator) {
        // We know that .generator is on the function scope, as we just exited
        // all nested scopes.
        NameLocation loc =
            *locationOfNameBoundInFunctionScope(cx->names().dotGenerator, varEmitterScope);
        if (!emitGetNameAtLocation(cx->names().dotGenerator, loc))
            return false;
        if (!emitYieldOp(JSOP_FINALYIELDRVAL))
            return false;
    } else if (isDerivedClassConstructor) {
        MOZ_ASSERT(code()[top] == JSOP_SETRVAL);
        if (!emit1(JSOP_RETRVAL))
            return false;
    } else if (top + static_cast<ptrdiff_t>(JSOP_RETURN_LENGTH) != offset()) {
        code()[top] = JSOP_SETRVAL;
        if (!emit1(JSOP_RETRVAL))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitYield(ParseNode* pn)
{
    MOZ_ASSERT(sc->isFunctionBox());

    if (pn->getOp() == JSOP_YIELD) {
        if (sc->asFunctionBox()->isStarGenerator()) {
            if (!emitPrepareIteratorResult())
                return false;
        }
        if (pn->pn_left) {
            if (!emitTree(pn->pn_left))
                return false;
        } else {
            if (!emit1(JSOP_UNDEFINED))
                return false;
        }
        if (sc->asFunctionBox()->isStarGenerator()) {
            if (!emitFinishIteratorResult(false))
                return false;
        }
    } else {
        MOZ_ASSERT(pn->getOp() == JSOP_INITIALYIELD);
    }

    if (!emitTree(pn->pn_right))
        return false;

    if (!emitYieldOp(pn->getOp()))
        return false;

    if (pn->getOp() == JSOP_INITIALYIELD && !emit1(JSOP_POP))
        return false;

    return true;
}

bool
BytecodeEmitter::emitYieldStar(ParseNode* iter, ParseNode* gen)
{
    MOZ_ASSERT(sc->isFunctionBox());
    MOZ_ASSERT(sc->asFunctionBox()->isStarGenerator());

    if (!emitTree(iter))                                         // ITERABLE
        return false;
    if (!emitIterator())                                         // ITER
        return false;

    // Initial send value is undefined.
    if (!emit1(JSOP_UNDEFINED))                                  // ITER RECEIVED
        return false;

    int depth = stackDepth;
    MOZ_ASSERT(depth >= 2);

    JumpList send;
    if (!emitJump(JSOP_GOTO, &send))                             // goto send
        return false;

    // Try prologue.                                             // ITER RESULT
    unsigned noteIndex;
    if (!newSrcNote(SRC_TRY, &noteIndex))
        return false;
    JumpTarget tryStart{ offset() };
    if (!emit1(JSOP_TRY))                                        // tryStart:
        return false;
    MOZ_ASSERT(this->stackDepth == depth);

    // Load the generator object.
    if (!emitTree(gen))                                          // ITER RESULT GENOBJ
        return false;

    // Yield RESULT as-is, without re-boxing.
    if (!emitYieldOp(JSOP_YIELD))                                // ITER RECEIVED
        return false;

    // Try epilogue.
    if (!setSrcNoteOffset(noteIndex, 0, offset() - tryStart.offset))
        return false;
    if (!emitJump(JSOP_GOTO, &send))                             // goto send
        return false;

    JumpTarget tryEnd;
    if (!emitJumpTarget(&tryEnd))                                // tryEnd:
        return false;

    // Catch location.
    stackDepth = uint32_t(depth);                                // ITER RESULT
    if (!emit1(JSOP_POP))                                        // ITER
        return false;
    // THROW? = 'throw' in ITER
    if (!emit1(JSOP_EXCEPTION))                                  // ITER EXCEPTION
        return false;
    if (!emit1(JSOP_SWAP))                                       // EXCEPTION ITER
        return false;
    if (!emit1(JSOP_DUP))                                        // EXCEPTION ITER ITER
        return false;
    if (!emitAtomOp(cx->names().throw_, JSOP_STRING))            // EXCEPTION ITER ITER "throw"
        return false;
    if (!emit1(JSOP_SWAP))                                       // EXCEPTION ITER "throw" ITER
        return false;
    if (!emit1(JSOP_IN))                                         // EXCEPTION ITER THROW?
        return false;
    // if (THROW?) goto delegate
    JumpList checkThrow;
    if (!emitJump(JSOP_IFNE, &checkThrow))                       // EXCEPTION ITER
        return false;
    if (!emit1(JSOP_POP))                                        // EXCEPTION
        return false;
    if (!emit1(JSOP_THROW))                                      // throw EXCEPTION
        return false;

    if (!emitJumpTargetAndPatch(checkThrow))                     // delegate:
        return false;
    // RESULT = ITER.throw(EXCEPTION)                            // EXCEPTION ITER
    stackDepth = uint32_t(depth);
    if (!emit1(JSOP_DUP))                                        // EXCEPTION ITER ITER
        return false;
    if (!emit1(JSOP_DUP))                                        // EXCEPTION ITER ITER ITER
        return false;
    if (!emitAtomOp(cx->names().throw_, JSOP_CALLPROP))          // EXCEPTION ITER ITER THROW
        return false;
    if (!emit1(JSOP_SWAP))                                       // EXCEPTION ITER THROW ITER
        return false;
    if (!emit2(JSOP_PICK, 3))                                    // ITER THROW ITER EXCEPTION
        return false;
    if (!emitCall(JSOP_CALL, 1, iter))                           // ITER RESULT
        return false;
    checkTypeSet(JSOP_CALL);
    MOZ_ASSERT(this->stackDepth == depth);
    JumpList checkResult;
    if (!emitJump(JSOP_GOTO, &checkResult))                      // goto checkResult
        return false;

    // Catch epilogue.

    // This is a peace offering to ReconstructPCStack.  See the note in EmitTry.
    if (!emit1(JSOP_NOP))
        return false;
    if (!tryNoteList.append(JSTRY_CATCH, depth, tryStart.offset + JSOP_TRY_LENGTH, tryEnd.offset))
        return false;

    // After the try/catch block: send the received value to the iterator.
    if (!emitJumpTargetAndPatch(send))                           // send:
        return false;

    // Send location.
    // result = iter.next(received)                              // ITER RECEIVED
    if (!emit1(JSOP_SWAP))                                       // RECEIVED ITER
        return false;
    if (!emit1(JSOP_DUP))                                        // RECEIVED ITER ITER
        return false;
    if (!emit1(JSOP_DUP))                                        // RECEIVED ITER ITER ITER
        return false;
    if (!emitAtomOp(cx->names().next, JSOP_CALLPROP))            // RECEIVED ITER ITER NEXT
        return false;
    if (!emit1(JSOP_SWAP))                                       // RECEIVED ITER NEXT ITER
        return false;
    if (!emit2(JSOP_PICK, 3))                                    // ITER NEXT ITER RECEIVED
        return false;
    if (!emitCall(JSOP_CALL, 1, iter))                           // ITER RESULT
        return false;
    if (!emitCheckIsObj(CheckIsObjectKind::IteratorNext))        // ITER RESULT
        return false;
    checkTypeSet(JSOP_CALL);
    MOZ_ASSERT(this->stackDepth == depth);

    if (!emitJumpTargetAndPatch(checkResult))                    // checkResult:
        return false;

    // if (!result.done) goto tryStart;                          // ITER RESULT
    if (!emit1(JSOP_DUP))                                        // ITER RESULT RESULT
        return false;
    if (!emitAtomOp(cx->names().done, JSOP_GETPROP))             // ITER RESULT DONE
        return false;
    // if (!DONE) goto tryStart;
    JumpList beq;
    JumpTarget breakTarget{ -1 };
    if (!emitBackwardJump(JSOP_IFEQ, tryStart, &beq, &breakTarget)) // ITER RESULT
        return false;

    // result.value
    if (!emit1(JSOP_SWAP))                                       // RESULT ITER
        return false;
    if (!emit1(JSOP_POP))                                        // RESULT
        return false;
    if (!emitAtomOp(cx->names().value, JSOP_GETPROP))            // VALUE
        return false;

    MOZ_ASSERT(this->stackDepth == depth - 1);

    return true;
}

bool
BytecodeEmitter::emitStatementList(ParseNode* pn)
{
    MOZ_ASSERT(pn->isArity(PN_LIST));
    for (ParseNode* pn2 = pn->pn_head; pn2; pn2 = pn2->pn_next) {
        if (!emitTree(pn2))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitStatement(ParseNode* pn)
{
    MOZ_ASSERT(pn->isKind(PNK_SEMI));

    ParseNode* pn2 = pn->pn_kid;
    if (!pn2)
        return true;

    if (!updateSourceCoordNotes(pn->pn_pos.begin))
        return false;

    /*
     * Top-level or called-from-a-native JS_Execute/EvaluateScript,
     * debugger, and eval frames may need the value of the ultimate
     * expression statement as the script's result, despite the fact
     * that it appears useless to the compiler.
     *
     * API users may also set the JSOPTION_NO_SCRIPT_RVAL option when
     * calling JS_Compile* to suppress JSOP_SETRVAL.
     */
    bool wantval = false;
    bool useful = false;
    if (sc->isFunctionBox())
        MOZ_ASSERT(!script->noScriptRval());
    else
        useful = wantval = !script->noScriptRval();

    /* Don't eliminate expressions with side effects. */
    if (!useful) {
        if (!checkSideEffects(pn2, &useful))
            return false;

        /*
         * Don't eliminate apparently useless expressions if they are labeled
         * expression statements. The startOffset() test catches the case
         * where we are nesting in emitTree for a labeled compound statement.
         */
        if (innermostNestableControl &&
            innermostNestableControl->is<LabelControl>() &&
            innermostNestableControl->as<LabelControl>().startOffset() >= offset())
        {
            useful = true;
        }
    }

    if (useful) {
        JSOp op = wantval ? JSOP_SETRVAL : JSOP_POP;
        MOZ_ASSERT_IF(pn2->isKind(PNK_ASSIGN), pn2->isOp(JSOP_NOP));
        if (!emitTree(pn2))
            return false;
        if (!emit1(op))
            return false;
    } else if (pn->isDirectivePrologueMember()) {
        // Don't complain about directive prologue members; just don't emit
        // their code.
    } else {
        if (JSAtom* atom = pn->isStringExprStatement()) {
            // Warn if encountering a non-directive prologue member string
            // expression statement, that is inconsistent with the current
            // directive prologue.  That is, a script *not* starting with
            // "use strict" should warn for any "use strict" statements seen
            // later in the script, because such statements are misleading.
            const char* directive = nullptr;
            if (atom == cx->names().useStrict) {
                if (!sc->strictScript)
                    directive = js_useStrict_str;
            } else if (atom == cx->names().useAsm) {
                if (sc->isFunctionBox()) {
                    if (IsAsmJSModule(sc->asFunctionBox()->function()))
                        directive = js_useAsm_str;
                }
            }

            if (directive) {
                if (!reportStrictWarning(pn2, JSMSG_CONTRARY_NONDIRECTIVE, directive))
                    return false;
            }
        } else {
            current->currentLine = parser->tokenStream.srcCoords.lineNum(pn2->pn_pos.begin);
            current->lastColumn = 0;
            if (!reportStrictWarning(pn2, JSMSG_USELESS_EXPR))
                return false;
        }
    }

    return true;
}

bool
BytecodeEmitter::emitDeleteName(ParseNode* node)
{
    MOZ_ASSERT(node->isKind(PNK_DELETENAME));
    MOZ_ASSERT(node->isArity(PN_UNARY));

    ParseNode* nameExpr = node->pn_kid;
    MOZ_ASSERT(nameExpr->isKind(PNK_NAME));

    return emitAtomOp(nameExpr, JSOP_DELNAME);
}

bool
BytecodeEmitter::emitDeleteProperty(ParseNode* node)
{
    MOZ_ASSERT(node->isKind(PNK_DELETEPROP));
    MOZ_ASSERT(node->isArity(PN_UNARY));

    ParseNode* propExpr = node->pn_kid;
    MOZ_ASSERT(propExpr->isKind(PNK_DOT));

    if (propExpr->as<PropertyAccess>().isSuper()) {
        // Still have to calculate the base, even though we are are going
        // to throw unconditionally, as calculating the base could also
        // throw.
        if (!emit1(JSOP_SUPERBASE))
            return false;

        return emitUint16Operand(JSOP_THROWMSG, JSMSG_CANT_DELETE_SUPER);
    }

    JSOp delOp = sc->strict() ? JSOP_STRICTDELPROP : JSOP_DELPROP;
    return emitPropOp(propExpr, delOp);
}

bool
BytecodeEmitter::emitDeleteElement(ParseNode* node)
{
    MOZ_ASSERT(node->isKind(PNK_DELETEELEM));
    MOZ_ASSERT(node->isArity(PN_UNARY));

    ParseNode* elemExpr = node->pn_kid;
    MOZ_ASSERT(elemExpr->isKind(PNK_ELEM));

    if (elemExpr->as<PropertyByValue>().isSuper()) {
        // Still have to calculate everything, even though we're gonna throw
        // since it may have side effects
        if (!emitTree(elemExpr->pn_right))
            return false;

        if (!emit1(JSOP_SUPERBASE))
            return false;
        if (!emitUint16Operand(JSOP_THROWMSG, JSMSG_CANT_DELETE_SUPER))
            return false;

        // Another wrinkle: Balance the stack from the emitter's point of view.
        // Execution will not reach here, as the last bytecode threw.
        return emit1(JSOP_POP);
    }

    JSOp delOp = sc->strict() ? JSOP_STRICTDELELEM : JSOP_DELELEM;
    return emitElemOp(elemExpr, delOp);
}

bool
BytecodeEmitter::emitDeleteExpression(ParseNode* node)
{
    MOZ_ASSERT(node->isKind(PNK_DELETEEXPR));
    MOZ_ASSERT(node->isArity(PN_UNARY));

    ParseNode* expression = node->pn_kid;

    // If useless, just emit JSOP_TRUE; otherwise convert |delete <expr>| to
    // effectively |<expr>, true|.
    bool useful = false;
    if (!checkSideEffects(expression, &useful))
        return false;

    if (useful) {
        if (!emitTree(expression))
            return false;
        if (!emit1(JSOP_POP))
            return false;
    }

    return emit1(JSOP_TRUE);
}

static const char *
SelfHostedCallFunctionName(JSAtom* name, ExclusiveContext* cx)
{
    if (name == cx->names().callFunction)
        return "callFunction";
    if (name == cx->names().callContentFunction)
        return "callContentFunction";
    if (name == cx->names().constructContentFunction)
        return "constructContentFunction";

    MOZ_CRASH("Unknown self-hosted call function name");
}

bool
BytecodeEmitter::emitSelfHostedCallFunction(ParseNode* pn)
{
    // Special-casing of callFunction to emit bytecode that directly
    // invokes the callee with the correct |this| object and arguments.
    // callFunction(fun, thisArg, arg0, arg1) thus becomes:
    // - emit lookup for fun
    // - emit lookup for thisArg
    // - emit lookups for arg0, arg1
    //
    // argc is set to the amount of actually emitted args and the
    // emitting of args below is disabled by setting emitArgs to false.
    ParseNode* pn2 = pn->pn_head;
    const char* errorName = SelfHostedCallFunctionName(pn2->name(), cx);

    if (pn->pn_count < 3) {
        reportError(pn, JSMSG_MORE_ARGS_NEEDED, errorName, "2", "s");
        return false;
    }

    JSOp callOp = pn->getOp();
    if (callOp != JSOP_CALL) {
        reportError(pn, JSMSG_NOT_CONSTRUCTOR, errorName);
        return false;
    }

    bool constructing = pn2->name() == cx->names().constructContentFunction;
    ParseNode* funNode = pn2->pn_next;
    if (constructing)
        callOp = JSOP_NEW;
    else if (funNode->getKind() == PNK_NAME && funNode->name() == cx->names().std_Function_apply)
        callOp = JSOP_FUNAPPLY;

    if (!emitTree(funNode))
        return false;

#ifdef DEBUG
    if (emitterMode == BytecodeEmitter::SelfHosting &&
        pn2->name() == cx->names().callFunction)
    {
        if (!emit1(JSOP_DEBUGCHECKSELFHOSTED))
            return false;
    }
#endif

    ParseNode* thisOrNewTarget = funNode->pn_next;
    if (constructing) {
        // Save off the new.target value, but here emit a proper |this| for a
        // constructing call.
        if (!emit1(JSOP_IS_CONSTRUCTING))
            return false;
    } else {
        // It's |this|, emit it.
        if (!emitTree(thisOrNewTarget))
            return false;
    }

    for (ParseNode* argpn = thisOrNewTarget->pn_next; argpn; argpn = argpn->pn_next) {
        if (!emitTree(argpn))
            return false;
    }

    if (constructing) {
        if (!emitTree(thisOrNewTarget))
            return false;
    }

    uint32_t argc = pn->pn_count - 3;
    if (!emitCall(callOp, argc))
        return false;

    checkTypeSet(callOp);
    return true;
}

bool
BytecodeEmitter::emitSelfHostedResumeGenerator(ParseNode* pn)
{
    // Syntax: resumeGenerator(gen, value, 'next'|'throw'|'close')
    if (pn->pn_count != 4) {
        reportError(pn, JSMSG_MORE_ARGS_NEEDED, "resumeGenerator", "1", "s");
        return false;
    }

    ParseNode* funNode = pn->pn_head;  // The resumeGenerator node.

    ParseNode* genNode = funNode->pn_next;
    if (!emitTree(genNode))
        return false;

    ParseNode* valNode = genNode->pn_next;
    if (!emitTree(valNode))
        return false;

    ParseNode* kindNode = valNode->pn_next;
    MOZ_ASSERT(kindNode->isKind(PNK_STRING));
    uint16_t operand = GeneratorObject::getResumeKind(cx, kindNode->pn_atom);
    MOZ_ASSERT(!kindNode->pn_next);

    if (!emitCall(JSOP_RESUME, operand))
        return false;

    return true;
}

bool
BytecodeEmitter::emitSelfHostedForceInterpreter(ParseNode* pn)
{
    if (!emit1(JSOP_FORCEINTERPRETER))
        return false;
    if (!emit1(JSOP_UNDEFINED))
        return false;
    return true;
}

bool
BytecodeEmitter::emitSelfHostedAllowContentSpread(ParseNode* pn)
{
    if (pn->pn_count != 2) {
        reportError(pn, JSMSG_MORE_ARGS_NEEDED, "allowContentSpread", "1", "");
        return false;
    }

    // We're just here as a sentinel. Pass the value through directly.
    return emitTree(pn->pn_head->pn_next);
}

bool
BytecodeEmitter::isRestParameter(ParseNode* pn, bool* result)
{
    if (!sc->isFunctionBox()) {
        *result = false;
        return true;
    }

    FunctionBox* funbox = sc->asFunctionBox();
    RootedFunction fun(cx, funbox->function());
    if (!fun->hasRest()) {
        *result = false;
        return true;
    }

    if (!pn->isKind(PNK_NAME)) {
        if (emitterMode == BytecodeEmitter::SelfHosting && pn->isKind(PNK_CALL)) {
            ParseNode* pn2 = pn->pn_head;
            if (pn2->getKind() == PNK_NAME && pn2->name() == cx->names().allowContentSpread)
                return isRestParameter(pn2->pn_next, result);
        }
        *result = false;
        return true;
    }

    JSAtom* name = pn->name();
    Maybe<NameLocation> paramLoc = locationOfNameBoundInFunctionScope(name);
    if (paramLoc && lookupName(name) == *paramLoc) {
        FunctionScope::Data* bindings = funbox->functionScopeBindings();
        if (bindings->nonPositionalFormalStart > 0) {
            // |paramName| can be nullptr when the rest destructuring syntax is
            // used: `function f(...[]) {}`.
            JSAtom* paramName = bindings->names[bindings->nonPositionalFormalStart - 1].name();
            *result = paramName && name == paramName;
            return true;
        }
    }

    return true;
}

bool
BytecodeEmitter::emitOptimizeSpread(ParseNode* arg0, JumpList* jmp, bool* emitted)
{
    // Emit a pereparation code to optimize the spread call with a rest
    // parameter:
    //
    //   function f(...args) {
    //     g(...args);
    //   }
    //
    // If the spread operand is a rest parameter and it's optimizable array,
    // skip spread operation and pass it directly to spread call operation.
    // See the comment in OptimizeSpreadCall in Interpreter.cpp for the
    // optimizable conditons.
    bool result = false;
    if (!isRestParameter(arg0, &result))
        return false;

    if (!result) {
        *emitted = false;
        return true;
    }

    if (!emitTree(arg0))
        return false;

    if (!emit1(JSOP_OPTIMIZE_SPREADCALL))
        return false;

    if (!emitJump(JSOP_IFNE, jmp))
        return false;

    if (!emit1(JSOP_POP))
        return false;

    *emitted = true;
    return true;
}

bool
BytecodeEmitter::emitCallOrNew(ParseNode* pn)
{
    bool callop = pn->isKind(PNK_CALL) || pn->isKind(PNK_TAGGED_TEMPLATE);
    /*
     * Emit callable invocation or operator new (constructor call) code.
     * First, emit code for the left operand to evaluate the callable or
     * constructable object expression.
     *
     * For operator new, we emit JSOP_GETPROP instead of JSOP_CALLPROP, etc.
     * This is necessary to interpose the lambda-initialized method read
     * barrier -- see the code in jsinterp.cpp for JSOP_LAMBDA followed by
     * JSOP_{SET,INIT}PROP.
     *
     * Then (or in a call case that has no explicit reference-base
     * object) we emit JSOP_UNDEFINED to produce the undefined |this|
     * value required for calls (which non-strict mode functions
     * will box into the global object).
     */
    uint32_t argc = pn->pn_count - 1;

    if (argc >= ARGC_LIMIT) {
        parser->tokenStream.reportError(callop
                                        ? JSMSG_TOO_MANY_FUN_ARGS
                                        : JSMSG_TOO_MANY_CON_ARGS);
        return false;
    }

    ParseNode* pn2 = pn->pn_head;
    bool spread = JOF_OPTYPE(pn->getOp()) == JOF_BYTE;
    switch (pn2->getKind()) {
      case PNK_NAME:
        if (emitterMode == BytecodeEmitter::SelfHosting && !spread) {
            // Calls to "forceInterpreter", "callFunction",
            // "callContentFunction", or "resumeGenerator" in self-hosted
            // code generate inline bytecode.
            if (pn2->name() == cx->names().callFunction ||
                pn2->name() == cx->names().callContentFunction ||
                pn2->name() == cx->names().constructContentFunction)
            {
                return emitSelfHostedCallFunction(pn);
            }
            if (pn2->name() == cx->names().resumeGenerator)
                return emitSelfHostedResumeGenerator(pn);
            if (pn2->name() == cx->names().forceInterpreter)
                return emitSelfHostedForceInterpreter(pn);
            if (pn2->name() == cx->names().allowContentSpread)
                return emitSelfHostedAllowContentSpread(pn);
            // Fall through.
        }
        if (!emitGetName(pn2, callop))
            return false;
        break;
      case PNK_DOT:
        MOZ_ASSERT(emitterMode != BytecodeEmitter::SelfHosting);
        if (pn2->as<PropertyAccess>().isSuper()) {
            if (!emitSuperPropOp(pn2, JSOP_GETPROP_SUPER, /* isCall = */ callop))
                return false;
        } else {
            if (!emitPropOp(pn2, callop ? JSOP_CALLPROP : JSOP_GETPROP))
                return false;
        }

        break;
      case PNK_ELEM:
        MOZ_ASSERT(emitterMode != BytecodeEmitter::SelfHosting);
        if (pn2->as<PropertyByValue>().isSuper()) {
            if (!emitSuperElemOp(pn2, JSOP_GETELEM_SUPER, /* isCall = */ callop))
                return false;
        } else {
            if (!emitElemOp(pn2, callop ? JSOP_CALLELEM : JSOP_GETELEM))
                return false;
            if (callop) {
                if (!emit1(JSOP_SWAP))
                    return false;
            }
        }

        break;
      case PNK_FUNCTION:
        /*
         * Top level lambdas which are immediately invoked should be
         * treated as only running once. Every time they execute we will
         * create new types and scripts for their contents, to increase
         * the quality of type information within them and enable more
         * backend optimizations. Note that this does not depend on the
         * lambda being invoked at most once (it may be named or be
         * accessed via foo.caller indirection), as multiple executions
         * will just cause the inner scripts to be repeatedly cloned.
         */
        MOZ_ASSERT(!emittingRunOnceLambda);
        if (checkRunOnceContext()) {
            emittingRunOnceLambda = true;
            if (!emitTree(pn2))
                return false;
            emittingRunOnceLambda = false;
        } else {
            if (!emitTree(pn2))
                return false;
        }
        callop = false;
        break;
      case PNK_SUPERBASE:
        MOZ_ASSERT(pn->isKind(PNK_SUPERCALL));
        MOZ_ASSERT(parser->handler.isSuperBase(pn2));
        if (!emit1(JSOP_SUPERFUN))
            return false;
        break;
      default:
        if (!emitTree(pn2))
            return false;
        callop = false;             /* trigger JSOP_UNDEFINED after */
        break;
    }

    bool isNewOp = pn->getOp() == JSOP_NEW || pn->getOp() == JSOP_SPREADNEW ||
                   pn->getOp() == JSOP_SUPERCALL || pn->getOp() == JSOP_SPREADSUPERCALL;


    // Emit room for |this|.
    if (!callop) {
        if (isNewOp) {
            if (!emit1(JSOP_IS_CONSTRUCTING))
                return false;
        } else {
            if (!emit1(JSOP_UNDEFINED))
                return false;
        }
    }

    /*
     * Emit code for each argument in order, then emit the JSOP_*CALL or
     * JSOP_NEW bytecode with a two-byte immediate telling how many args
     * were pushed on the operand stack.
     */
    if (!spread) {
        for (ParseNode* pn3 = pn2->pn_next; pn3; pn3 = pn3->pn_next) {
            if (!emitTree(pn3))
                return false;
        }

        if (isNewOp) {
            if (pn->isKind(PNK_SUPERCALL)) {
                if (!emit1(JSOP_NEWTARGET))
                    return false;
            } else {
                // Repush the callee as new.target
                if (!emitDupAt(argc + 1))
                    return false;
            }
        }
    } else {
        ParseNode* args = pn2->pn_next;
        JumpList jmp;
        bool optCodeEmitted = false;
        if (argc == 1) {
            if (!emitOptimizeSpread(args->pn_kid, &jmp, &optCodeEmitted))
                return false;
        }

        if (!emitArray(args, argc, JSOP_SPREADCALLARRAY))
            return false;

        if (optCodeEmitted) {
            if (!emitJumpTargetAndPatch(jmp))
                return false;
        }

        if (isNewOp) {
            if (pn->isKind(PNK_SUPERCALL)) {
                if (!emit1(JSOP_NEWTARGET))
                    return false;
            } else {
                if (!emitDupAt(2))
                    return false;
            }
        }
    }

    if (!spread) {
        if (!emitCall(pn->getOp(), argc, pn))
            return false;
    } else {
        if (!emit1(pn->getOp()))
            return false;
    }
    checkTypeSet(pn->getOp());
    if (pn->isOp(JSOP_EVAL) ||
        pn->isOp(JSOP_STRICTEVAL) ||
        pn->isOp(JSOP_SPREADEVAL) ||
        pn->isOp(JSOP_STRICTSPREADEVAL))
    {
        uint32_t lineNum = parser->tokenStream.srcCoords.lineNum(pn->pn_pos.begin);
        if (!emitUint32Operand(JSOP_LINENO, lineNum))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitRightAssociative(ParseNode* pn)
{
    // ** is the only right-associative operator.
    MOZ_ASSERT(pn->isKind(PNK_POW));
    MOZ_ASSERT(pn->isArity(PN_LIST));

    // Right-associative operator chain.
    for (ParseNode* subexpr = pn->pn_head; subexpr; subexpr = subexpr->pn_next) {
        if (!emitTree(subexpr))
            return false;
    }
    for (uint32_t i = 0; i < pn->pn_count - 1; i++) {
        if (!emit1(JSOP_POW))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitLeftAssociative(ParseNode* pn)
{
    MOZ_ASSERT(pn->isArity(PN_LIST));

    // Left-associative operator chain.
    if (!emitTree(pn->pn_head))
        return false;
    JSOp op = pn->getOp();
    ParseNode* nextExpr = pn->pn_head->pn_next;
    do {
        if (!emitTree(nextExpr))
            return false;
        if (!emit1(op))
            return false;
    } while ((nextExpr = nextExpr->pn_next));
    return true;
}

bool
BytecodeEmitter::emitLogical(ParseNode* pn)
{
    MOZ_ASSERT(pn->isArity(PN_LIST));

    /*
     * JSOP_OR converts the operand on the stack to boolean, leaves the original
     * value on the stack and jumps if true; otherwise it falls into the next
     * bytecode, which pops the left operand and then evaluates the right operand.
     * The jump goes around the right operand evaluation.
     *
     * JSOP_AND converts the operand on the stack to boolean and jumps if false;
     * otherwise it falls into the right operand's bytecode.
     */

    TDZCheckCache tdzCache(this);

    /* Left-associative operator chain: avoid too much recursion. */
    ParseNode* pn2 = pn->pn_head;
    if (!emitTree(pn2))
        return false;
    JSOp op = pn->getOp();
    JumpList jump;
    if (!emitJump(op, &jump))
        return false;
    if (!emit1(JSOP_POP))
        return false;

    /* Emit nodes between the head and the tail. */
    while ((pn2 = pn2->pn_next)->pn_next) {
        if (!emitTree(pn2))
            return false;
        if (!emitJump(op, &jump))
            return false;
        if (!emit1(JSOP_POP))
            return false;
    }
    if (!emitTree(pn2))
        return false;

    if (!emitJumpTargetAndPatch(jump))
        return false;
    return true;
}

bool
BytecodeEmitter::emitSequenceExpr(ParseNode* pn)
{
    for (ParseNode* child = pn->pn_head; ; child = child->pn_next) {
        if (!updateSourceCoordNotes(child->pn_pos.begin))
            return false;
        if (!emitTree(child))
            return false;
        if (!child->pn_next)
            break;
        if (!emit1(JSOP_POP))
            return false;
    }
    return true;
}

// Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047. See
// the comment on emitSwitch.
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitIncOrDec(ParseNode* pn)
{
    switch (pn->pn_kid->getKind()) {
      case PNK_DOT:
        return emitPropIncDec(pn);
      case PNK_ELEM:
        return emitElemIncDec(pn);
      case PNK_CALL:
        return emitCallIncDec(pn);
      default:
        return emitNameIncDec(pn);
    }

    return true;
}

// Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047. See
// the comment on emitSwitch.
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitLabeledStatement(const LabeledStatement* pn)
{
    /*
     * Emit a JSOP_LABEL instruction. The argument is the offset to the statement
     * following the labeled statement.
     */
    uint32_t index;
    if (!makeAtomIndex(pn->label(), &index))
        return false;

    JumpList top;
    if (!emitJump(JSOP_LABEL, &top))
        return false;

    /* Emit code for the labeled statement. */
    LabelControl controlInfo(this, pn->label(), offset());

    if (!emitTree(pn->statement()))
        return false;

    /* Patch the JSOP_LABEL offset. */
    JumpTarget brk{ lastNonJumpTargetOffset() };
    patchJumpsToTarget(top, brk);

    if (!controlInfo.patchBreaks(this))
        return false;

    return true;
}

bool
BytecodeEmitter::emitConditionalExpression(ConditionalExpression& conditional)
{
    /* Emit the condition, then branch if false to the else part. */
    if (!emitTree(&conditional.condition()))
        return false;

    IfThenElseEmitter ifThenElse(this);
    if (!ifThenElse.emitCond())
        return false;

    if (!emitConditionallyExecutedTree(&conditional.thenExpression()))
        return false;

    if (!ifThenElse.emitElse())
        return false;

    if (!emitConditionallyExecutedTree(&conditional.elseExpression()))
        return false;

    if (!ifThenElse.emitEnd())
        return false;
    MOZ_ASSERT(ifThenElse.pushed() == 1);

    return true;
}

bool
BytecodeEmitter::emitPropertyList(ParseNode* pn, MutableHandlePlainObject objp, PropListType type)
{
    for (ParseNode* propdef = pn->pn_head; propdef; propdef = propdef->pn_next) {
        if (!updateSourceCoordNotes(propdef->pn_pos.begin))
            return false;

        // Handle __proto__: v specially because *only* this form, and no other
        // involving "__proto__", performs [[Prototype]] mutation.
        if (propdef->isKind(PNK_MUTATEPROTO)) {
            MOZ_ASSERT(type == ObjectLiteral);
            if (!emitTree(propdef->pn_kid))
                return false;
            objp.set(nullptr);
            if (!emit1(JSOP_MUTATEPROTO))
                return false;
            continue;
        }

        bool extraPop = false;
        if (type == ClassBody && propdef->as<ClassMethod>().isStatic()) {
            extraPop = true;
            if (!emit1(JSOP_DUP2))
                return false;
            if (!emit1(JSOP_POP))
                return false;
        }

        /* Emit an index for t[2] for later consumption by JSOP_INITELEM. */
        ParseNode* key = propdef->pn_left;
        bool isIndex = false;
        if (key->isKind(PNK_NUMBER)) {
            if (!emitNumberOp(key->pn_dval))
                return false;
            isIndex = true;
        } else if (key->isKind(PNK_OBJECT_PROPERTY_NAME) || key->isKind(PNK_STRING)) {
            // EmitClass took care of constructor already.
            if (type == ClassBody && key->pn_atom == cx->names().constructor &&
                !propdef->as<ClassMethod>().isStatic())
            {
                continue;
            }

            // The parser already checked for atoms representing indexes and
            // used PNK_NUMBER instead, but also watch for ids which TI treats
            // as indexes for simpliciation of downstream analysis.
            jsid id = NameToId(key->pn_atom->asPropertyName());
            if (id != IdToTypeId(id)) {
                if (!emitTree(key))
                    return false;
                isIndex = true;
            }
        } else {
            if (!emitComputedPropertyName(key))
                return false;
            isIndex = true;
        }

        /* Emit code for the property initializer. */
        if (!emitTree(propdef->pn_right))
            return false;

        JSOp op = propdef->getOp();
        MOZ_ASSERT(op == JSOP_INITPROP ||
                   op == JSOP_INITPROP_GETTER ||
                   op == JSOP_INITPROP_SETTER);

        if (op == JSOP_INITPROP_GETTER || op == JSOP_INITPROP_SETTER)
            objp.set(nullptr);

        if (propdef->pn_right->isKind(PNK_FUNCTION) &&
            propdef->pn_right->pn_funbox->needsHomeObject())
        {
            MOZ_ASSERT(propdef->pn_right->pn_funbox->function()->allowSuperProperty());
            bool isAsync = propdef->pn_right->pn_funbox->isAsync();
            if (isAsync) {
                if (!emit1(JSOP_SWAP))
                    return false;
            }
            if (!emit2(JSOP_INITHOMEOBJECT, isIndex + isAsync))
                return false;
            if (isAsync) {
                if (!emit1(JSOP_POP))
                    return false;
            }
        }

        // Class methods are not enumerable.
        if (type == ClassBody) {
            switch (op) {
              case JSOP_INITPROP:        op = JSOP_INITHIDDENPROP;          break;
              case JSOP_INITPROP_GETTER: op = JSOP_INITHIDDENPROP_GETTER;   break;
              case JSOP_INITPROP_SETTER: op = JSOP_INITHIDDENPROP_SETTER;   break;
              default: MOZ_CRASH("Invalid op");
            }
        }

        if (isIndex) {
            objp.set(nullptr);
            switch (op) {
              case JSOP_INITPROP:               op = JSOP_INITELEM;              break;
              case JSOP_INITHIDDENPROP:         op = JSOP_INITHIDDENELEM;        break;
              case JSOP_INITPROP_GETTER:        op = JSOP_INITELEM_GETTER;       break;
              case JSOP_INITHIDDENPROP_GETTER:  op = JSOP_INITHIDDENELEM_GETTER; break;
              case JSOP_INITPROP_SETTER:        op = JSOP_INITELEM_SETTER;       break;
              case JSOP_INITHIDDENPROP_SETTER:  op = JSOP_INITHIDDENELEM_SETTER; break;
              default: MOZ_CRASH("Invalid op");
            }
            if (!emit1(op))
                return false;
        } else {
            MOZ_ASSERT(key->isKind(PNK_OBJECT_PROPERTY_NAME) || key->isKind(PNK_STRING));

            uint32_t index;
            if (!makeAtomIndex(key->pn_atom, &index))
                return false;

            if (objp) {
                MOZ_ASSERT(type == ObjectLiteral);
                MOZ_ASSERT(!IsHiddenInitOp(op));
                MOZ_ASSERT(!objp->inDictionaryMode());
                Rooted<jsid> id(cx, AtomToId(key->pn_atom));
                RootedValue undefinedValue(cx, UndefinedValue());
                if (!NativeDefineProperty(cx, objp, id, undefinedValue, nullptr, nullptr,
                                          JSPROP_ENUMERATE))
                {
                    return false;
                }
                if (objp->inDictionaryMode())
                    objp.set(nullptr);
            }

            if (!emitIndex32(op, index))
                return false;
        }

        if (extraPop) {
            if (!emit1(JSOP_POP))
                return false;
        }
    }
    return true;
}

// Using MOZ_NEVER_INLINE in here is a workaround for llvm.org/pr14047. See
// the comment on emitSwitch.
MOZ_NEVER_INLINE bool
BytecodeEmitter::emitObject(ParseNode* pn)
{
    if (!(pn->pn_xflags & PNX_NONCONST) && pn->pn_head && checkSingletonContext())
        return emitSingletonInitialiser(pn);

    /*
     * Emit code for {p:a, '%q':b, 2:c} that is equivalent to constructing
     * a new object and defining (in source order) each property on the object
     * (or mutating the object's [[Prototype]], in the case of __proto__).
     */
    ptrdiff_t offset = this->offset();
    if (!emitNewInit(JSProto_Object))
        return false;

    /*
     * Try to construct the shape of the object as we go, so we can emit a
     * JSOP_NEWOBJECT with the final shape instead.
     */
    RootedPlainObject obj(cx);
    // No need to do any guessing for the object kind, since we know exactly
    // how many properties we plan to have.
    gc::AllocKind kind = gc::GetGCObjectKind(pn->pn_count);
    obj = NewBuiltinClassInstance<PlainObject>(cx, kind, TenuredObject);
    if (!obj)
        return false;

    if (!emitPropertyList(pn, &obj, ObjectLiteral))
        return false;

    if (obj) {
        /*
         * The object survived and has a predictable shape: update the original
         * bytecode.
         */
        ObjectBox* objbox = parser->newObjectBox(obj);
        if (!objbox)
            return false;

        static_assert(JSOP_NEWINIT_LENGTH == JSOP_NEWOBJECT_LENGTH,
                      "newinit and newobject must have equal length to edit in-place");

        uint32_t index = objectList.add(objbox);
        jsbytecode* code = this->code(offset);
        code[0] = JSOP_NEWOBJECT;
        code[1] = jsbytecode(index >> 24);
        code[2] = jsbytecode(index >> 16);
        code[3] = jsbytecode(index >> 8);
        code[4] = jsbytecode(index);
    }

    return true;
}

bool
BytecodeEmitter::emitArrayComp(ParseNode* pn)
{
    if (!emitNewInit(JSProto_Array))
        return false;

    /*
     * Pass the new array's stack index to the PNK_ARRAYPUSH case via
     * arrayCompDepth, then simply traverse the PNK_FOR node and
     * its kids under pn2 to generate this comprehension.
     */
    MOZ_ASSERT(stackDepth > 0);
    uint32_t saveDepth = arrayCompDepth;
    arrayCompDepth = (uint32_t) (stackDepth - 1);
    if (!emitTree(pn->pn_head))
        return false;
    arrayCompDepth = saveDepth;

    return true;
}

bool
BytecodeEmitter::emitArrayLiteral(ParseNode* pn)
{
    if (!(pn->pn_xflags & PNX_NONCONST) && pn->pn_head) {
        if (checkSingletonContext()) {
            // Bake in the object entirely if it will only be created once.
            return emitSingletonInitialiser(pn);
        }

        // If the array consists entirely of primitive values, make a
        // template object with copy on write elements that can be reused
        // every time the initializer executes.
        if (emitterMode != BytecodeEmitter::SelfHosting && pn->pn_count != 0) {
            RootedValue value(cx);
            if (!pn->getConstantValue(cx, ParseNode::ForCopyOnWriteArray, &value))
                return false;
            if (!value.isMagic(JS_GENERIC_MAGIC)) {
                // Note: the group of the template object might not yet reflect
                // that the object has copy on write elements. When the
                // interpreter or JIT compiler fetches the template, it should
                // use ObjectGroup::getOrFixupCopyOnWriteObject to make sure the
                // group for the template is accurate. We don't do this here as we
                // want to use ObjectGroup::allocationSiteGroup, which requires a
                // finished script.
                JSObject* obj = &value.toObject();
                MOZ_ASSERT(obj->is<ArrayObject>() &&
                           obj->as<ArrayObject>().denseElementsAreCopyOnWrite());

                ObjectBox* objbox = parser->newObjectBox(obj);
                if (!objbox)
                    return false;

                return emitObjectOp(objbox, JSOP_NEWARRAY_COPYONWRITE);
            }
        }
    }

    return emitArray(pn->pn_head, pn->pn_count, JSOP_NEWARRAY);
}

bool
BytecodeEmitter::emitArray(ParseNode* pn, uint32_t count, JSOp op)
{

    /*
     * Emit code for [a, b, c] that is equivalent to constructing a new
     * array and in source order evaluating each element value and adding
     * it to the array, without invoking latent setters.  We use the
     * JSOP_NEWINIT and JSOP_INITELEM_ARRAY bytecodes to ignore setters and
     * to avoid dup'ing and popping the array as each element is added, as
     * JSOP_SETELEM/JSOP_SETPROP would do.
     */
    MOZ_ASSERT(op == JSOP_NEWARRAY || op == JSOP_SPREADCALLARRAY);

    uint32_t nspread = 0;
    for (ParseNode* elt = pn; elt; elt = elt->pn_next) {
        if (elt->isKind(PNK_SPREAD))
            nspread++;
    }

    // Array literal's length is limited to NELEMENTS_LIMIT in parser.
    static_assert(NativeObject::MAX_DENSE_ELEMENTS_COUNT <= INT32_MAX,
                  "array literals' maximum length must not exceed limits "
                  "required by BaselineCompiler::emit_JSOP_NEWARRAY, "
                  "BaselineCompiler::emit_JSOP_INITELEM_ARRAY, "
                  "and DoSetElemFallback's handling of JSOP_INITELEM_ARRAY");
    MOZ_ASSERT(count >= nspread);
    MOZ_ASSERT(count <= NativeObject::MAX_DENSE_ELEMENTS_COUNT,
               "the parser must throw an error if the array exceeds maximum "
               "length");

    // For arrays with spread, this is a very pessimistic allocation, the
    // minimum possible final size.
    if (!emitUint32Operand(op, count - nspread))                    // ARRAY
        return false;

    ParseNode* pn2 = pn;
    uint32_t index;
    bool afterSpread = false;
    for (index = 0; pn2; index++, pn2 = pn2->pn_next) {
        if (!afterSpread && pn2->isKind(PNK_SPREAD)) {
            afterSpread = true;
            if (!emitNumberOp(index))                               // ARRAY INDEX
                return false;
        }
        if (!updateSourceCoordNotes(pn2->pn_pos.begin))
            return false;

        bool allowSelfHostedSpread = false;
        if (pn2->isKind(PNK_ELISION)) {
            if (!emit1(JSOP_HOLE))
                return false;
        } else {
            ParseNode* expr;
            if (pn2->isKind(PNK_SPREAD)) {
                expr = pn2->pn_kid;

                if (emitterMode == BytecodeEmitter::SelfHosting &&
                    expr->isKind(PNK_CALL) &&
                    expr->pn_head->name() == cx->names().allowContentSpread)
                {
                    allowSelfHostedSpread = true;
                }
            } else {
                expr = pn2;
            }
            if (!emitTree(expr))                                         // ARRAY INDEX? VALUE
                return false;
        }
        if (pn2->isKind(PNK_SPREAD)) {
            if (!emitIterator())                                         // ARRAY INDEX ITER
                return false;
            if (!emit2(JSOP_PICK, 2))                                    // INDEX ITER ARRAY
                return false;
            if (!emit2(JSOP_PICK, 2))                                    // ITER ARRAY INDEX
                return false;
            if (!emitSpread(allowSelfHostedSpread))                      // ARRAY INDEX
                return false;
        } else if (afterSpread) {
            if (!emit1(JSOP_INITELEM_INC))
                return false;
        } else {
            if (!emitUint32Operand(JSOP_INITELEM_ARRAY, index))
                return false;
        }
    }
    MOZ_ASSERT(index == count);
    if (afterSpread) {
        if (!emit1(JSOP_POP))                                            // ARRAY
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitUnary(ParseNode* pn)
{
    if (!updateSourceCoordNotes(pn->pn_pos.begin))
        return false;

    /* Unary op, including unary +/-. */
    JSOp op = pn->getOp();
    ParseNode* pn2 = pn->pn_kid;

    if (!emitTree(pn2))
        return false;

    return emit1(op);
}

bool
BytecodeEmitter::emitTypeof(ParseNode* node, JSOp op)
{
    MOZ_ASSERT(op == JSOP_TYPEOF || op == JSOP_TYPEOFEXPR);

    if (!updateSourceCoordNotes(node->pn_pos.begin))
        return false;

    if (!emitTree(node->pn_kid))
        return false;

    return emit1(op);
}

bool
BytecodeEmitter::emitFunctionFormalParametersAndBody(ParseNode *pn)
{
    MOZ_ASSERT(pn->isKind(PNK_PARAMSBODY));

    ParseNode* funBody = pn->last();
    FunctionBox* funbox = sc->asFunctionBox();

    TDZCheckCache tdzCache(this);

    if (funbox->hasParameterExprs) {
        EmitterScope funEmitterScope(this);
        if (!funEmitterScope.enterFunction(this, funbox))
            return false;

        if (!emitInitializeFunctionSpecialNames())
            return false;

        if (!emitFunctionFormalParameters(pn))
            return false;

        {
            Maybe<EmitterScope> extraVarEmitterScope;

            if (funbox->hasExtraBodyVarScope()) {
                extraVarEmitterScope.emplace(this);
                if (!extraVarEmitterScope->enterFunctionExtraBodyVar(this, funbox))
                    return false;

                // After emitting expressions for all parameters, copy over any
                // formal parameters which have been redeclared as vars. For
                // example, in the following, the var y in the body scope is 42:
                //
                //   function f(x, y = 42) { var y; }
                //
                RootedAtom name(cx);
                if (funbox->extraVarScopeBindings() && funbox->functionScopeBindings()) {
                    for (BindingIter bi(*funbox->functionScopeBindings(), true); bi; bi++) {
                        name = bi.name();

                        // There may not be a var binding of the same name.
                        if (!locationOfNameBoundInScope(name, extraVarEmitterScope.ptr()))
                            continue;

                        // The '.this' and '.generator' function special
                        // bindings should never appear in the extra var
                        // scope. 'arguments', however, may.
                        MOZ_ASSERT(name != cx->names().dotThis &&
                                   name != cx->names().dotGenerator);

                        NameLocation paramLoc = *locationOfNameBoundInScope(name, &funEmitterScope);
                        auto emitRhs = [&name, &paramLoc](BytecodeEmitter* bce,
                                                          const NameLocation&, bool)
                        {
                            return bce->emitGetNameAtLocation(name, paramLoc);
                        };

                        if (!emitInitializeName(name, emitRhs))
                            return false;
                        if (!emit1(JSOP_POP))
                            return false;
                    }
                }
            }

            if (!emitFunctionBody(funBody))
                return false;

            if (extraVarEmitterScope && !extraVarEmitterScope->leave(this))
                return false;
        }

        return funEmitterScope.leave(this);
    }

    // No parameter expressions. Enter the function body scope and emit
    // everything.
    //
    // One caveat is that Debugger considers ops in the prologue to be
    // unreachable (i.e. cannot set a breakpoint on it). If there are no
    // parameter exprs, any unobservable environment ops (like pushing the
    // call object, setting '.this', etc) need to go in the prologue, else it
    // messes up breakpoint tests.
    EmitterScope emitterScope(this);

    switchToPrologue();
    if (!emitterScope.enterFunction(this, funbox))
        return false;

    if (!emitInitializeFunctionSpecialNames())
        return false;
    switchToMain();

    if (!emitFunctionFormalParameters(pn))
        return false;

    if (!emitFunctionBody(funBody))
        return false;

    return emitterScope.leave(this);
}

bool
BytecodeEmitter::emitFunctionFormalParameters(ParseNode* pn)
{
    ParseNode* funBody = pn->last();
    FunctionBox* funbox = sc->asFunctionBox();
    EmitterScope* funScope = innermostEmitterScope;

    bool hasParameterExprs = funbox->hasParameterExprs;
    bool hasRest = funbox->function()->hasRest();

    uint16_t argSlot = 0;
    for (ParseNode* arg = pn->pn_head; arg != funBody; arg = arg->pn_next, argSlot++) {
        ParseNode* bindingElement = arg;
        ParseNode* initializer = nullptr;
        if (arg->isKind(PNK_ASSIGN)) {
            bindingElement = arg->pn_left;
            initializer = arg->pn_right;
        }

        // Left-hand sides are either simple names or destructuring patterns.
        MOZ_ASSERT(bindingElement->isKind(PNK_NAME) ||
                   bindingElement->isKind(PNK_ARRAY) ||
                   bindingElement->isKind(PNK_ARRAYCOMP) ||
                   bindingElement->isKind(PNK_OBJECT));

        // The rest parameter doesn't have an initializer.
        bool isRest = hasRest && arg->pn_next == funBody;
        MOZ_ASSERT_IF(isRest, !initializer);

        bool isDestructuring = !bindingElement->isKind(PNK_NAME);

        // ES 14.1.19 says if BindingElement contains an expression in the
        // production FormalParameter : BindingElement, it is evaluated in a
        // new var environment. This is needed to prevent vars from escaping
        // direct eval in parameter expressions.
        Maybe<EmitterScope> paramExprVarScope;
        if (funbox->hasDirectEvalInParameterExpr && (isDestructuring || initializer)) {
            paramExprVarScope.emplace(this);
            if (!paramExprVarScope->enterParameterExpressionVar(this))
                return false;
        }

        // First push the RHS if there is a default expression or if it is
        // rest.

        if (initializer) {
            // If we have an initializer, emit the initializer and assign it
            // to the argument slot. TDZ is taken care of afterwards.
            MOZ_ASSERT(hasParameterExprs);
            if (!emitArgOp(JSOP_GETARG, argSlot))
                return false;
            if (!emit1(JSOP_DUP))
                return false;
            if (!emit1(JSOP_UNDEFINED))
                return false;
            if (!emit1(JSOP_STRICTEQ))
                return false;
            // Emit source note to enable Ion compilation.
            if (!newSrcNote(SRC_IF))
                return false;
            JumpList jump;
            if (!emitJump(JSOP_IFEQ, &jump))
                return false;
            if (!emit1(JSOP_POP))
                return false;
            if (!emitConditionallyExecutedTree(initializer))
                return false;
            if (!emitJumpTargetAndPatch(jump))
                return false;
        } else if (isRest) {
            if (!emit1(JSOP_REST))
                return false;
            checkTypeSet(JSOP_REST);
        }

        // Initialize the parameter name.

        if (isDestructuring) {
            // If we had an initializer or the rest parameter, the value is
            // already on the stack.
            if (!initializer && !isRest && !emitArgOp(JSOP_GETARG, argSlot))
                return false;

            // If there's an parameter expression var scope, the destructuring
            // declaration needs to initialize the name in the function scope,
            // which is not the innermost scope.
            if (!emitDestructuringOps(bindingElement,
                                      paramExprVarScope
                                      ? DestructuringFormalParameterInVarScope
                                      : DestructuringDeclaration))
            {
                return false;
            }

            if (!emit1(JSOP_POP))
                return false;
        } else {
            RootedAtom paramName(cx, bindingElement->name());
            NameLocation paramLoc = *locationOfNameBoundInScope(paramName, funScope);

            if (hasParameterExprs) {
                auto emitRhs = [argSlot, initializer, isRest](BytecodeEmitter* bce,
                                                              const NameLocation&, bool)
                {
                    // If we had an initializer or a rest parameter, the value is
                    // already on the stack.
                    if (!initializer && !isRest)
                        return bce->emitArgOp(JSOP_GETARG, argSlot);
                    return true;
                };

                if (!emitSetOrInitializeNameAtLocation(paramName, paramLoc, emitRhs, true))
                    return false;
                if (!emit1(JSOP_POP))
                    return false;
            } else if (isRest) {
                // The rest value is already on top of the stack.
                auto nop = [](BytecodeEmitter*, const NameLocation&, bool) {
                    return true;
                };

                if (!emitSetOrInitializeNameAtLocation(paramName, paramLoc, nop, true))
                    return false;
                if (!emit1(JSOP_POP))
                    return false;
            }
        }

        if (paramExprVarScope) {
            if (!paramExprVarScope->leave(this))
                return false;
        }
    }

    return true;
}

bool
BytecodeEmitter::emitInitializeFunctionSpecialNames()
{
    FunctionBox* funbox = sc->asFunctionBox();

    auto emitInitializeFunctionSpecialName = [](BytecodeEmitter* bce, HandlePropertyName name,
                                                JSOp op)
    {
        // A special name must be slotful, either on the frame or on the
        // call environment.
        MOZ_ASSERT(bce->lookupName(name).hasKnownSlot());

        auto emitInitial = [op](BytecodeEmitter* bce, const NameLocation&, bool) {
            return bce->emit1(op);
        };

        if (!bce->emitInitializeName(name, emitInitial))
            return false;
        if (!bce->emit1(JSOP_POP))
            return false;

        return true;
    };

    // Do nothing if the function doesn't have an arguments binding.
    if (funbox->argumentsHasLocalBinding()) {
        if (!emitInitializeFunctionSpecialName(this, cx->names().arguments, JSOP_ARGUMENTS))
            return false;
    }

    // Do nothing if the function doesn't have a this-binding (this
    // happens for instance if it doesn't use this/eval or if it's an
    // arrow function).
    if (funbox->hasThisBinding()) {
        if (!emitInitializeFunctionSpecialName(this, cx->names().dotThis, JSOP_FUNCTIONTHIS))
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitFunctionBody(ParseNode* funBody)
{
    FunctionBox* funbox = sc->asFunctionBox();

    if (!emitTree(funBody))
        return false;

    if (funbox->isGenerator()) {
        // If we fall off the end of a generator, do a final yield.
        if (funbox->isStarGenerator() && !emitPrepareIteratorResult())
            return false;

        if (!emit1(JSOP_UNDEFINED))
            return false;

        if (sc->asFunctionBox()->isStarGenerator() && !emitFinishIteratorResult(true))
            return false;

        if (!emit1(JSOP_SETRVAL))
            return false;

        NameLocation loc = *locationOfNameBoundInFunctionScope(cx->names().dotGenerator);
        if (!emitGetNameAtLocation(cx->names().dotGenerator, loc))
            return false;

        // No need to check for finally blocks, etc as in EmitReturn.
        if (!emitYieldOp(JSOP_FINALYIELDRVAL))
            return false;
    } else {
        // Non-generator functions just return |undefined|. The
        // JSOP_RETRVAL emitted below will do that, except if the
        // script has a finally block: there can be a non-undefined
        // value in the return value slot. Make sure the return value
        // is |undefined|.
        if (hasTryFinally) {
            if (!emit1(JSOP_UNDEFINED))
                return false;
            if (!emit1(JSOP_SETRVAL))
                return false;
        }
    }

    if (funbox->isDerivedClassConstructor()) {
        if (!emitCheckDerivedClassConstructorReturn())
            return false;
    }

    return true;
}

bool
BytecodeEmitter::emitLexicalInitialization(ParseNode* pn)
{
    // The caller has pushed the RHS to the top of the stack. Assert that the
    // name is lexical and no BIND[G]NAME ops were emitted.
    auto assertLexical = [](BytecodeEmitter*, const NameLocation& loc, bool emittedBindOp) {
        MOZ_ASSERT(loc.isLexical());
        MOZ_ASSERT(!emittedBindOp);
        return true;
    };
    return emitInitializeName(pn, assertLexical);
}

// This follows ES6 14.5.14 (ClassDefinitionEvaluation) and ES6 14.5.15
// (BindingClassDeclarationEvaluation).
bool
BytecodeEmitter::emitClass(ParseNode* pn)
{
    ClassNode& classNode = pn->as<ClassNode>();

    ClassNames* names = classNode.names();

    ParseNode* heritageExpression = classNode.heritage();

    ParseNode* classMethods = classNode.methodList();
    ParseNode* constructor = nullptr;
    for (ParseNode* mn = classMethods->pn_head; mn; mn = mn->pn_next) {
        ClassMethod& method = mn->as<ClassMethod>();
        ParseNode& methodName = method.name();
        if (!method.isStatic() &&
            (methodName.isKind(PNK_OBJECT_PROPERTY_NAME) || methodName.isKind(PNK_STRING)) &&
            methodName.pn_atom == cx->names().constructor)
        {
            constructor = &method.method();
            break;
        }
    }

    bool savedStrictness = sc->setLocalStrictMode(true);

    Maybe<TDZCheckCache> tdzCache;
    Maybe<EmitterScope> emitterScope;
    if (names) {
        tdzCache.emplace(this);
        emitterScope.emplace(this);
        if (!emitterScope->enterLexical(this, ScopeKind::Lexical, classNode.scopeBindings()))
            return false;
    }

    // This is kind of silly. In order to the get the home object defined on
    // the constructor, we have to make it second, but we want the prototype
    // on top for EmitPropertyList, because we expect static properties to be
    // rarer. The result is a few more swaps than we would like. Such is life.
    if (heritageExpression) {
        if (!emitTree(heritageExpression))
            return false;
        if (!emit1(JSOP_CLASSHERITAGE))
            return false;
        if (!emit1(JSOP_OBJWITHPROTO))
            return false;

        // JSOP_CLASSHERITAGE leaves both protos on the stack. After
        // creating the prototype, swap it to the bottom to make the
        // constructor.
        if (!emit1(JSOP_SWAP))
            return false;
    } else {
        if (!emitNewInit(JSProto_Object))
            return false;
    }

    if (constructor) {
        if (!emitFunction(constructor, !!heritageExpression))
            return false;
        if (constructor->pn_funbox->needsHomeObject()) {
            if (!emit2(JSOP_INITHOMEOBJECT, 0))
                return false;
        }
    } else {
        JSAtom *name = names ? names->innerBinding()->pn_atom : cx->names().empty;
        if (heritageExpression) {
            if (!emitAtomOp(name, JSOP_DERIVEDCONSTRUCTOR))
                return false;
        } else {
            if (!emitAtomOp(name, JSOP_CLASSCONSTRUCTOR))
                return false;
        }
    }

    if (!emit1(JSOP_SWAP))
        return false;

    if (!emit1(JSOP_DUP2))
        return false;
    if (!emitAtomOp(cx->names().prototype, JSOP_INITLOCKEDPROP))
        return false;
    if (!emitAtomOp(cx->names().constructor, JSOP_INITHIDDENPROP))
        return false;

    RootedPlainObject obj(cx);
    if (!emitPropertyList(classMethods, &obj, ClassBody))
        return false;

    if (!emit1(JSOP_POP))
        return false;

    if (names) {
        ParseNode* innerName = names->innerBinding();
        if (!emitLexicalInitialization(innerName))
            return false;

        // Pop the inner scope.
        if (!emitterScope->leave(this))
            return false;
        emitterScope.reset();

        ParseNode* outerName = names->outerBinding();
        if (outerName) {
            if (!emitLexicalInitialization(outerName))
                return false;
            // Only class statements make outer bindings, and they do not leave
            // themselves on the stack.
            if (!emit1(JSOP_POP))
                return false;
        }
    }

    MOZ_ALWAYS_TRUE(sc->setLocalStrictMode(savedStrictness));

    return true;
}

bool
BytecodeEmitter::emitTree(ParseNode* pn, EmitLineNumberNote emitLineNote)
{
    JS_CHECK_RECURSION(cx, return false);

    EmitLevelManager elm(this);

    /* Emit notes to tell the current bytecode's source line number.
       However, a couple trees require special treatment; see the
       relevant emitter functions for details. */
    if (emitLineNote == EMIT_LINENOTE && !ParseNodeRequiresSpecialLineNumberNotes(pn)) {
        if (!updateLineNumberNotes(pn->pn_pos.begin))
            return false;
    }

    switch (pn->getKind()) {
      case PNK_FUNCTION:
        if (!emitFunction(pn))
            return false;
        break;

      case PNK_PARAMSBODY:
        if (!emitFunctionFormalParametersAndBody(pn))
            return false;
        break;

      case PNK_IF:
        if (!emitIf(pn))
            return false;
        break;

      case PNK_SWITCH:
        if (!emitSwitch(pn))
            return false;
        break;

      case PNK_WHILE:
        if (!emitWhile(pn))
            return false;
        break;

      case PNK_DOWHILE:
        if (!emitDo(pn))
            return false;
        break;

      case PNK_FOR:
        if (!emitFor(pn))
            return false;
        break;

      case PNK_COMPREHENSIONFOR:
        if (!emitComprehensionFor(pn))
            return false;
        break;

      case PNK_BREAK:
        if (!emitBreak(pn->as<BreakStatement>().label()))
            return false;
        break;

      case PNK_CONTINUE:
        if (!emitContinue(pn->as<ContinueStatement>().label()))
            return false;
        break;

      case PNK_WITH:
        if (!emitWith(pn))
            return false;
        break;

      case PNK_TRY:
        if (!emitTry(pn))
            return false;
        break;

      case PNK_CATCH:
        if (!emitCatch(pn))
            return false;
        break;

      case PNK_VAR:
        if (!emitDeclarationList(pn))
            return false;
        break;

      case PNK_RETURN:
        if (!emitReturn(pn))
            return false;
        break;

      case PNK_YIELD_STAR:
        if (!emitYieldStar(pn->pn_left, pn->pn_right))
            return false;
        break;

      case PNK_GENERATOR:
        if (!emit1(JSOP_GENERATOR))
            return false;
        break;

      case PNK_YIELD:
      case PNK_AWAIT:
        if (!emitYield(pn))
            return false;
        break;

      case PNK_STATEMENTLIST:
        if (!emitStatementList(pn))
            return false;
        break;

      case PNK_SEMI:
        if (!emitStatement(pn))
            return false;
        break;

      case PNK_LABEL:
        if (!emitLabeledStatement(&pn->as<LabeledStatement>()))
            return false;
        break;

      case PNK_COMMA:
        if (!emitSequenceExpr(pn))
            return false;
        break;

      case PNK_ASSIGN:
      case PNK_ADDASSIGN:
      case PNK_SUBASSIGN:
      case PNK_BITORASSIGN:
      case PNK_BITXORASSIGN:
      case PNK_BITANDASSIGN:
      case PNK_LSHASSIGN:
      case PNK_RSHASSIGN:
      case PNK_URSHASSIGN:
      case PNK_MULASSIGN:
      case PNK_DIVASSIGN:
      case PNK_MODASSIGN:
      case PNK_POWASSIGN:
        if (!emitAssignment(pn->pn_left, pn->getOp(), pn->pn_right))
            return false;
        break;

      case PNK_CONDITIONAL:
        if (!emitConditionalExpression(pn->as<ConditionalExpression>()))
            return false;
        break;

      case PNK_OR:
      case PNK_AND:
        if (!emitLogical(pn))
            return false;
        break;

      case PNK_ADD:
      case PNK_SUB:
      case PNK_BITOR:
      case PNK_BITXOR:
      case PNK_BITAND:
      case PNK_STRICTEQ:
      case PNK_EQ:
      case PNK_STRICTNE:
      case PNK_NE:
      case PNK_LT:
      case PNK_LE:
      case PNK_GT:
      case PNK_GE:
      case PNK_IN:
      case PNK_INSTANCEOF:
      case PNK_LSH:
      case PNK_RSH:
      case PNK_URSH:
      case PNK_STAR:
      case PNK_DIV:
      case PNK_MOD:
        if (!emitLeftAssociative(pn))
            return false;
        break;

      case PNK_POW:
        if (!emitRightAssociative(pn))
            return false;
        break;

      case PNK_TYPEOFNAME:
        if (!emitTypeof(pn, JSOP_TYPEOF))
            return false;
        break;

      case PNK_TYPEOFEXPR:
        if (!emitTypeof(pn, JSOP_TYPEOFEXPR))
            return false;
        break;

      case PNK_THROW:
      case PNK_VOID:
      case PNK_NOT:
      case PNK_BITNOT:
      case PNK_POS:
      case PNK_NEG:
        if (!emitUnary(pn))
            return false;
        break;

      case PNK_PREINCREMENT:
      case PNK_PREDECREMENT:
      case PNK_POSTINCREMENT:
      case PNK_POSTDECREMENT:
        if (!emitIncOrDec(pn))
            return false;
        break;

      case PNK_DELETENAME:
        if (!emitDeleteName(pn))
            return false;
        break;

      case PNK_DELETEPROP:
        if (!emitDeleteProperty(pn))
            return false;
        break;

      case PNK_DELETEELEM:
        if (!emitDeleteElement(pn))
            return false;
        break;

      case PNK_DELETEEXPR:
        if (!emitDeleteExpression(pn))
            return false;
        break;

      case PNK_DOT:
        if (pn->as<PropertyAccess>().isSuper()) {
            if (!emitSuperPropOp(pn, JSOP_GETPROP_SUPER))
                return false;
        } else {
            if (!emitPropOp(pn, JSOP_GETPROP))
                return false;
        }
        break;

      case PNK_ELEM:
        if (pn->as<PropertyByValue>().isSuper()) {
            if (!emitSuperElemOp(pn, JSOP_GETELEM_SUPER))
                return false;
        } else {
            if (!emitElemOp(pn, JSOP_GETELEM))
                return false;
        }
        break;

      case PNK_NEW:
      case PNK_TAGGED_TEMPLATE:
      case PNK_CALL:
      case PNK_GENEXP:
      case PNK_SUPERCALL:
        if (!emitCallOrNew(pn))
            return false;
        break;

      case PNK_LEXICALSCOPE:
        if (!emitLexicalScope(pn))
            return false;
        break;

      case PNK_CONST:
      case PNK_LET:
        if (!emitDeclarationList(pn))
            return false;
        break;

      case PNK_IMPORT:
        MOZ_ASSERT(sc->isModuleContext());
        break;

      case PNK_EXPORT:
        MOZ_ASSERT(sc->isModuleContext());
        if (pn->pn_kid->getKind() != PNK_EXPORT_SPEC_LIST) {
            if (!emitTree(pn->pn_kid))
                return false;
        }
        break;

      case PNK_EXPORT_DEFAULT:
        MOZ_ASSERT(sc->isModuleContext());
        if (!emitTree(pn->pn_kid))
            return false;
        if (pn->pn_right) {
            if (!emitLexicalInitialization(pn->pn_right))
                return false;
            if (!emit1(JSOP_POP))
                return false;
        }
        break;

      case PNK_EXPORT_FROM:
        MOZ_ASSERT(sc->isModuleContext());
        break;

      case PNK_ARRAYPUSH:
        /*
         * The array object's stack index is in arrayCompDepth. See below
         * under the array initialiser code generator for array comprehension
         * special casing.
         */
        if (!emitTree(pn->pn_kid))
            return false;
        if (!emitDupAt(this->stackDepth - 1 - arrayCompDepth))
            return false;
        if (!emit1(JSOP_ARRAYPUSH))
            return false;
        break;

      case PNK_CALLSITEOBJ:
        if (!emitCallSiteObject(pn))
            return false;
        break;

      case PNK_ARRAY:
        if (!emitArrayLiteral(pn))
            return false;
        break;

      case PNK_ARRAYCOMP:
        if (!emitArrayComp(pn))
            return false;
        break;

      case PNK_OBJECT:
        if (!emitObject(pn))
            return false;
        break;

      case PNK_NAME:
        if (!emitGetName(pn))
            return false;
        break;

      case PNK_TEMPLATE_STRING_LIST:
        if (!emitTemplateString(pn))
            return false;
        break;

      case PNK_TEMPLATE_STRING:
      case PNK_STRING:
        if (!emitAtomOp(pn, JSOP_STRING))
            return false;
        break;

      case PNK_NUMBER:
        if (!emitNumberOp(pn->pn_dval))
            return false;
        break;

      case PNK_REGEXP:
        if (!emitRegExp(objectList.add(pn->as<RegExpLiteral>().objbox())))
            return false;
        break;

      case PNK_TRUE:
      case PNK_FALSE:
      case PNK_NULL:
        if (!emit1(pn->getOp()))
            return false;
        break;

      case PNK_THIS:
        if (!emitThisLiteral(pn))
            return false;
        break;

      case PNK_DEBUGGER:
        if (!updateSourceCoordNotes(pn->pn_pos.begin))
            return false;
        if (!emit1(JSOP_DEBUGGER))
            return false;
        break;

      case PNK_NOP:
        MOZ_ASSERT(pn->getArity() == PN_NULLARY);
        break;

      case PNK_CLASS:
        if (!emitClass(pn))
            return false;
        break;

      case PNK_NEWTARGET:
        if (!emit1(JSOP_NEWTARGET))
            return false;
        break;

      case PNK_SETTHIS:
        if (!emitSetThis(pn))
            return false;
        break;

      case PNK_POSHOLDER:
        MOZ_FALLTHROUGH_ASSERT("Should never try to emit PNK_POSHOLDER");

      default:
        MOZ_ASSERT(0);
    }

    /* bce->emitLevel == 1 means we're last on the stack, so finish up. */
    if (emitLevel == 1) {
        if (!updateSourceCoordNotes(pn->pn_pos.end))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::emitConditionallyExecutedTree(ParseNode* pn)
{
    // Code that may be conditionally executed always need their own TDZ
    // cache.
    TDZCheckCache tdzCache(this);
    return emitTree(pn);
}

static bool
AllocSrcNote(ExclusiveContext* cx, SrcNotesVector& notes, unsigned* index)
{
    // Start it off moderately large to avoid repeated resizings early on.
    // ~99% of cases fit within 256 bytes.
    if (notes.capacity() == 0 && !notes.reserve(256))
        return false;

    if (!notes.growBy(1)) {
        ReportOutOfMemory(cx);
        return false;
    }

    *index = notes.length() - 1;
    return true;
}

bool
BytecodeEmitter::newSrcNote(SrcNoteType type, unsigned* indexp)
{
    SrcNotesVector& notes = this->notes();
    unsigned index;
    if (!AllocSrcNote(cx, notes, &index))
        return false;

    /*
     * Compute delta from the last annotated bytecode's offset.  If it's too
     * big to fit in sn, allocate one or more xdelta notes and reset sn.
     */
    ptrdiff_t offset = this->offset();
    ptrdiff_t delta = offset - lastNoteOffset();
    current->lastNoteOffset = offset;
    if (delta >= SN_DELTA_LIMIT) {
        do {
            ptrdiff_t xdelta = Min(delta, SN_XDELTA_MASK);
            SN_MAKE_XDELTA(&notes[index], xdelta);
            delta -= xdelta;
            if (!AllocSrcNote(cx, notes, &index))
                return false;
        } while (delta >= SN_DELTA_LIMIT);
    }

    /*
     * Initialize type and delta, then allocate the minimum number of notes
     * needed for type's arity.  Usually, we won't need more, but if an offset
     * does take two bytes, setSrcNoteOffset will grow notes.
     */
    SN_MAKE_NOTE(&notes[index], type, delta);
    for (int n = (int)js_SrcNoteSpec[type].arity; n > 0; n--) {
        if (!newSrcNote(SRC_NULL))
            return false;
    }

    if (indexp)
        *indexp = index;
    return true;
}

bool
BytecodeEmitter::newSrcNote2(SrcNoteType type, ptrdiff_t offset, unsigned* indexp)
{
    unsigned index;
    if (!newSrcNote(type, &index))
        return false;
    if (!setSrcNoteOffset(index, 0, offset))
        return false;
    if (indexp)
        *indexp = index;
    return true;
}

bool
BytecodeEmitter::newSrcNote3(SrcNoteType type, ptrdiff_t offset1, ptrdiff_t offset2,
                             unsigned* indexp)
{
    unsigned index;
    if (!newSrcNote(type, &index))
        return false;
    if (!setSrcNoteOffset(index, 0, offset1))
        return false;
    if (!setSrcNoteOffset(index, 1, offset2))
        return false;
    if (indexp)
        *indexp = index;
    return true;
}

bool
BytecodeEmitter::addToSrcNoteDelta(jssrcnote* sn, ptrdiff_t delta)
{
    /*
     * Called only from finishTakingSrcNotes to add to main script note
     * deltas, and only by a small positive amount.
     */
    MOZ_ASSERT(current == &main);
    MOZ_ASSERT((unsigned) delta < (unsigned) SN_XDELTA_LIMIT);

    ptrdiff_t base = SN_DELTA(sn);
    ptrdiff_t limit = SN_IS_XDELTA(sn) ? SN_XDELTA_LIMIT : SN_DELTA_LIMIT;
    ptrdiff_t newdelta = base + delta;
    if (newdelta < limit) {
        SN_SET_DELTA(sn, newdelta);
    } else {
        jssrcnote xdelta;
        SN_MAKE_XDELTA(&xdelta, delta);
        if (!main.notes.insert(sn, xdelta))
            return false;
    }
    return true;
}

bool
BytecodeEmitter::setSrcNoteOffset(unsigned index, unsigned which, ptrdiff_t offset)
{
    if (!SN_REPRESENTABLE_OFFSET(offset)) {
        parser->tokenStream.reportError(JSMSG_NEED_DIET, js_script_str);
        return false;
    }

    SrcNotesVector& notes = this->notes();

    /* Find the offset numbered which (i.e., skip exactly which offsets). */
    jssrcnote* sn = &notes[index];
    MOZ_ASSERT(SN_TYPE(sn) != SRC_XDELTA);
    MOZ_ASSERT((int) which < js_SrcNoteSpec[SN_TYPE(sn)].arity);
    for (sn++; which; sn++, which--) {
        if (*sn & SN_4BYTE_OFFSET_FLAG)
            sn += 3;
    }

    /*
     * See if the new offset requires four bytes either by being too big or if
     * the offset has already been inflated (in which case, we need to stay big
     * to not break the srcnote encoding if this isn't the last srcnote).
     */
    if (offset > (ptrdiff_t)SN_4BYTE_OFFSET_MASK || (*sn & SN_4BYTE_OFFSET_FLAG)) {
        /* Maybe this offset was already set to a four-byte value. */
        if (!(*sn & SN_4BYTE_OFFSET_FLAG)) {
            /* Insert three dummy bytes that will be overwritten shortly. */
            jssrcnote dummy = 0;
            if (!(sn = notes.insert(sn, dummy)) ||
                !(sn = notes.insert(sn, dummy)) ||
                !(sn = notes.insert(sn, dummy)))
            {
                ReportOutOfMemory(cx);
                return false;
            }
        }
        *sn++ = (jssrcnote)(SN_4BYTE_OFFSET_FLAG | (offset >> 24));
        *sn++ = (jssrcnote)(offset >> 16);
        *sn++ = (jssrcnote)(offset >> 8);
    }
    *sn = (jssrcnote)offset;
    return true;
}

bool
BytecodeEmitter::finishTakingSrcNotes(uint32_t* out)
{
    MOZ_ASSERT(current == &main);

    unsigned prologueCount = prologue.notes.length();
    if (prologueCount && prologue.currentLine != firstLine) {
        switchToPrologue();
        if (!newSrcNote2(SRC_SETLINE, ptrdiff_t(firstLine)))
            return false;
        switchToMain();
    } else {
        /*
         * Either no prologue srcnotes, or no line number change over prologue.
         * We don't need a SRC_SETLINE, but we may need to adjust the offset
         * of the first main note, by adding to its delta and possibly even
         * prepending SRC_XDELTA notes to it to account for prologue bytecodes
         * that came at and after the last annotated bytecode.
         */
        ptrdiff_t offset = prologueOffset() - prologue.lastNoteOffset;
        MOZ_ASSERT(offset >= 0);
        if (offset > 0 && main.notes.length() != 0) {
            /* NB: Use as much of the first main note's delta as we can. */
            jssrcnote* sn = main.notes.begin();
            ptrdiff_t delta = SN_IS_XDELTA(sn)
                            ? SN_XDELTA_MASK - (*sn & SN_XDELTA_MASK)
                            : SN_DELTA_MASK - (*sn & SN_DELTA_MASK);
            if (offset < delta)
                delta = offset;
            for (;;) {
                if (!addToSrcNoteDelta(sn, delta))
                    return false;
                offset -= delta;
                if (offset == 0)
                    break;
                delta = Min(offset, SN_XDELTA_MASK);
                sn = main.notes.begin();
            }
        }
    }

    // The prologue count might have changed, so we can't reuse prologueCount.
    // The + 1 is to account for the final SN_MAKE_TERMINATOR that is appended
    // when the notes are copied to their final destination by CopySrcNotes.
    *out = prologue.notes.length() + main.notes.length() + 1;
    return true;
}

void
BytecodeEmitter::copySrcNotes(jssrcnote* destination, uint32_t nsrcnotes)
{
    unsigned prologueCount = prologue.notes.length();
    unsigned mainCount = main.notes.length();
    unsigned totalCount = prologueCount + mainCount;
    MOZ_ASSERT(totalCount == nsrcnotes - 1);
    if (prologueCount)
        PodCopy(destination, prologue.notes.begin(), prologueCount);
    PodCopy(destination + prologueCount, main.notes.begin(), mainCount);
    SN_MAKE_TERMINATOR(&destination[totalCount]);
}

void
CGConstList::finish(ConstArray* array)
{
    MOZ_ASSERT(length() == array->length);

    for (unsigned i = 0; i < length(); i++)
        array->vector[i] = list[i];
}

bool
CGObjectList::isAdded(ObjectBox* objbox)
{
    // An objbox added to CGObjectList as non-first element has non-null
    // emitLink member.  The first element has null emitLink.
    // Check for firstbox to cover the first element.
    return objbox->emitLink || objbox == firstbox;
}

/*
 * Find the index of the given object for code generator.
 *
 * Since the emitter refers to each parsed object only once, for the index we
 * use the number of already indexed objects. We also add the object to a list
 * to convert the list to a fixed-size array when we complete code generation,
 * see js::CGObjectList::finish below.
 */
unsigned
CGObjectList::add(ObjectBox* objbox)
{
    if (isAdded(objbox))
        return indexOf(objbox->object);

    objbox->emitLink = lastbox;
    lastbox = objbox;

    // See the comment in CGObjectList::isAdded.
    if (!firstbox)
        firstbox = objbox;
    return length++;
}

unsigned
CGObjectList::indexOf(JSObject* obj)
{
    MOZ_ASSERT(length > 0);
    unsigned index = length - 1;
    for (ObjectBox* box = lastbox; box->object != obj; box = box->emitLink)
        index--;
    return index;
}

void
CGObjectList::finish(ObjectArray* array)
{
    MOZ_ASSERT(length <= INDEX_LIMIT);
    MOZ_ASSERT(length == array->length);

    js::GCPtrObject* cursor = array->vector + array->length;
    ObjectBox* objbox = lastbox;
    do {
        --cursor;
        MOZ_ASSERT(!*cursor);
        MOZ_ASSERT(objbox->object->isTenured());
        *cursor = objbox->object;

        ObjectBox* tmp = objbox->emitLink;
        // Clear emitLink for CGObjectList::isAdded.
        objbox->emitLink = nullptr;
        objbox = tmp;
    } while (objbox != nullptr);
    MOZ_ASSERT(cursor == array->vector);
}

ObjectBox*
CGObjectList::find(uint32_t index)
{
    MOZ_ASSERT(index < length);
    ObjectBox* box = lastbox;
    for (unsigned n = length - 1; n > index; n--)
        box = box->emitLink;
    return box;
}

void
CGScopeList::finish(ScopeArray* array)
{
    MOZ_ASSERT(length() <= INDEX_LIMIT);
    MOZ_ASSERT(length() == array->length);
    for (uint32_t i = 0; i < length(); i++)
        array->vector[i].init(vector[i]);
}

bool
CGTryNoteList::append(JSTryNoteKind kind, uint32_t stackDepth, size_t start, size_t end)
{
    MOZ_ASSERT(start <= end);
    MOZ_ASSERT(size_t(uint32_t(start)) == start);
    MOZ_ASSERT(size_t(uint32_t(end)) == end);

    JSTryNote note;
    note.kind = kind;
    note.stackDepth = stackDepth;
    note.start = uint32_t(start);
    note.length = uint32_t(end - start);

    return list.append(note);
}

void
CGTryNoteList::finish(TryNoteArray* array)
{
    MOZ_ASSERT(length() == array->length);

    for (unsigned i = 0; i < length(); i++)
        array->vector[i] = list[i];
}

bool
CGScopeNoteList::append(uint32_t scopeIndex, uint32_t offset, bool inPrologue,
                        uint32_t parent)
{
    CGScopeNote note;
    mozilla::PodZero(&note);

    note.index = scopeIndex;
    note.start = offset;
    note.parent = parent;
    note.startInPrologue = inPrologue;

    return list.append(note);
}

void
CGScopeNoteList::recordEnd(uint32_t index, uint32_t offset, bool inPrologue)
{
    MOZ_ASSERT(index < length());
    MOZ_ASSERT(list[index].length == 0);
    list[index].end = offset;
    list[index].endInPrologue = inPrologue;
}

void
CGScopeNoteList::finish(ScopeNoteArray* array, uint32_t prologueLength)
{
    MOZ_ASSERT(length() == array->length);

    for (unsigned i = 0; i < length(); i++) {
        if (!list[i].startInPrologue)
            list[i].start += prologueLength;
        if (!list[i].endInPrologue && list[i].end != UINT32_MAX)
            list[i].end += prologueLength;
        MOZ_ASSERT(list[i].end >= list[i].start);
        list[i].length = list[i].end - list[i].start;
        array->vector[i] = list[i];
    }
}

void
CGYieldOffsetList::finish(YieldOffsetArray& array, uint32_t prologueLength)
{
    MOZ_ASSERT(length() == array.length());

    for (unsigned i = 0; i < length(); i++)
        array[i] = prologueLength + list[i];
}

/*
 * We should try to get rid of offsetBias (always 0 or 1, where 1 is
 * JSOP_{NOP,POP}_LENGTH), which is used only by SRC_FOR.
 */
const JSSrcNoteSpec js_SrcNoteSpec[] = {
#define DEFINE_SRC_NOTE_SPEC(sym, name, arity) { name, arity },
    FOR_EACH_SRC_NOTE_TYPE(DEFINE_SRC_NOTE_SPEC)
#undef DEFINE_SRC_NOTE_SPEC
};

static int
SrcNoteArity(jssrcnote* sn)
{
    MOZ_ASSERT(SN_TYPE(sn) < SRC_LAST);
    return js_SrcNoteSpec[SN_TYPE(sn)].arity;
}

JS_FRIEND_API(unsigned)
js::SrcNoteLength(jssrcnote* sn)
{
    unsigned arity;
    jssrcnote* base;

    arity = SrcNoteArity(sn);
    for (base = sn++; arity; sn++, arity--) {
        if (*sn & SN_4BYTE_OFFSET_FLAG)
            sn += 3;
    }
    return sn - base;
}

JS_FRIEND_API(ptrdiff_t)
js::GetSrcNoteOffset(jssrcnote* sn, unsigned which)
{
    /* Find the offset numbered which (i.e., skip exactly which offsets). */
    MOZ_ASSERT(SN_TYPE(sn) != SRC_XDELTA);
    MOZ_ASSERT((int) which < SrcNoteArity(sn));
    for (sn++; which; sn++, which--) {
        if (*sn & SN_4BYTE_OFFSET_FLAG)
            sn += 3;
    }
    if (*sn & SN_4BYTE_OFFSET_FLAG) {
        return (ptrdiff_t)(((uint32_t)(sn[0] & SN_4BYTE_OFFSET_MASK) << 24)
                           | (sn[1] << 16)
                           | (sn[2] << 8)
                           | sn[3]);
    }
    return (ptrdiff_t)*sn;
}
