/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * JS script operations.
 */

#include "jsscriptinlines.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PodOperations.h"
#include "mozilla/ScopeExit.h"
#include "mozilla/Sprintf.h"
#include "mozilla/Unused.h"
#include "mozilla/Vector.h"

#include <algorithm>
#include <string.h>

#include "jsapi.h"
#include "jsatom.h"
#include "jscntxt.h"
#include "jsfun.h"
#include "jsgc.h"
#include "jsobj.h"
#include "jsopcode.h"
#include "jsprf.h"
#include "jstypes.h"
#include "jsutil.h"
#include "jswrapper.h"

#include "frontend/BytecodeCompiler.h"
#include "frontend/BytecodeEmitter.h"
#include "frontend/SharedContext.h"
#include "gc/Marking.h"
#include "jit/BaselineJIT.h"
#include "jit/Ion.h"
#include "jit/IonCode.h"
#include "js/MemoryMetrics.h"
#include "js/Utility.h"
#include "vm/ArgumentsObject.h"
#include "vm/Compression.h"
#include "vm/Debugger.h"
#include "vm/Opcodes.h"
#include "vm/SelfHosting.h"
#include "vm/Shape.h"
#include "vm/SharedImmutableStringsCache.h"
#include "vm/Xdr.h"

#include "jsfuninlines.h"
#include "jsobjinlines.h"

#include "vm/EnvironmentObject-inl.h"
#include "vm/NativeObject-inl.h"
#include "vm/SharedImmutableStringsCache-inl.h"
#include "vm/Stack-inl.h"

using namespace js;
using namespace js::gc;
using namespace js::frontend;

using mozilla::AsVariant;
using mozilla::PodCopy;
using mozilla::PodZero;
using mozilla::RotateLeft;

template<XDRMode mode>
bool
js::XDRScriptConst(XDRState<mode>* xdr, MutableHandleValue vp)
{
    JSContext* cx = xdr->cx();

    /*
     * A script constant can be an arbitrary primitive value as they are used
     * to implement JSOP_LOOKUPSWITCH. But they cannot be objects, see
     * bug 407186.
     */
    enum ConstTag {
        SCRIPT_INT     = 0,
        SCRIPT_DOUBLE  = 1,
        SCRIPT_ATOM    = 2,
        SCRIPT_TRUE    = 3,
        SCRIPT_FALSE   = 4,
        SCRIPT_NULL    = 5,
        SCRIPT_OBJECT  = 6,
        SCRIPT_VOID    = 7,
        SCRIPT_HOLE    = 8
    };

    uint32_t tag;
    if (mode == XDR_ENCODE) {
        if (vp.isInt32()) {
            tag = SCRIPT_INT;
        } else if (vp.isDouble()) {
            tag = SCRIPT_DOUBLE;
        } else if (vp.isString()) {
            tag = SCRIPT_ATOM;
        } else if (vp.isTrue()) {
            tag = SCRIPT_TRUE;
        } else if (vp.isFalse()) {
            tag = SCRIPT_FALSE;
        } else if (vp.isNull()) {
            tag = SCRIPT_NULL;
        } else if (vp.isObject()) {
            tag = SCRIPT_OBJECT;
        } else if (vp.isMagic(JS_ELEMENTS_HOLE)) {
            tag = SCRIPT_HOLE;
        } else {
            MOZ_ASSERT(vp.isUndefined());
            tag = SCRIPT_VOID;
        }
    }

    if (!xdr->codeUint32(&tag))
        return false;

    switch (tag) {
      case SCRIPT_INT: {
        uint32_t i;
        if (mode == XDR_ENCODE)
            i = uint32_t(vp.toInt32());
        if (!xdr->codeUint32(&i))
            return false;
        if (mode == XDR_DECODE)
            vp.set(Int32Value(int32_t(i)));
        break;
      }
      case SCRIPT_DOUBLE: {
        double d;
        if (mode == XDR_ENCODE)
            d = vp.toDouble();
        if (!xdr->codeDouble(&d))
            return false;
        if (mode == XDR_DECODE)
            vp.set(DoubleValue(d));
        break;
      }
      case SCRIPT_ATOM: {
        RootedAtom atom(cx);
        if (mode == XDR_ENCODE)
            atom = &vp.toString()->asAtom();
        if (!XDRAtom(xdr, &atom))
            return false;
        if (mode == XDR_DECODE)
            vp.set(StringValue(atom));
        break;
      }
      case SCRIPT_TRUE:
        if (mode == XDR_DECODE)
            vp.set(BooleanValue(true));
        break;
      case SCRIPT_FALSE:
        if (mode == XDR_DECODE)
            vp.set(BooleanValue(false));
        break;
      case SCRIPT_NULL:
        if (mode == XDR_DECODE)
            vp.set(NullValue());
        break;
      case SCRIPT_OBJECT: {
        RootedObject obj(cx);
        if (mode == XDR_ENCODE)
            obj = &vp.toObject();

        if (!XDRObjectLiteral(xdr, &obj))
            return false;

        if (mode == XDR_DECODE)
            vp.setObject(*obj);
        break;
      }
      case SCRIPT_VOID:
        if (mode == XDR_DECODE)
            vp.set(UndefinedValue());
        break;
      case SCRIPT_HOLE:
        if (mode == XDR_DECODE)
            vp.setMagic(JS_ELEMENTS_HOLE);
        break;
    }
    return true;
}

template bool
js::XDRScriptConst(XDRState<XDR_ENCODE>*, MutableHandleValue);

template bool
js::XDRScriptConst(XDRState<XDR_DECODE>*, MutableHandleValue);

// Code LazyScript's closed over bindings.
template<XDRMode mode>
static bool
XDRLazyClosedOverBindings(XDRState<mode>* xdr, MutableHandle<LazyScript*> lazy)
{
    JSContext* cx = xdr->cx();
    RootedAtom atom(cx);
    for (size_t i = 0; i < lazy->numClosedOverBindings(); i++) {
        uint8_t endOfScopeSentinel;
        if (mode == XDR_ENCODE) {
            atom = lazy->closedOverBindings()[i];
            endOfScopeSentinel = !atom;
        }

        if (!xdr->codeUint8(&endOfScopeSentinel))
            return false;

        if (endOfScopeSentinel)
            atom = nullptr;
        else if (!XDRAtom(xdr, &atom))
            return false;

        if (mode == XDR_DECODE)
            lazy->closedOverBindings()[i] = atom;
    }

    return true;
}

// Code the missing part needed to re-create a LazyScript from a JSScript.
template<XDRMode mode>
static bool
XDRRelazificationInfo(XDRState<mode>* xdr, HandleFunction fun, HandleScript script,
                      HandleScope enclosingScope, MutableHandle<LazyScript*> lazy)
{
    MOZ_ASSERT_IF(mode == XDR_ENCODE, script->isRelazifiable() && script->maybeLazyScript());
    MOZ_ASSERT_IF(mode == XDR_ENCODE, !lazy->numInnerFunctions());

    JSContext* cx = xdr->cx();

    uint64_t packedFields;
    {
        uint32_t begin = script->sourceStart();
        uint32_t end = script->sourceEnd();
        uint32_t lineno = script->lineno();
        uint32_t column = script->column();

        if (mode == XDR_ENCODE) {
            packedFields = lazy->packedFields();
            MOZ_ASSERT(begin == lazy->begin());
            MOZ_ASSERT(end == lazy->end());
            MOZ_ASSERT(lineno == lazy->lineno());
            MOZ_ASSERT(column == lazy->column());
            // We can assert we have no inner functions because we don't
            // relazify scripts with inner functions.  See
            // JSFunction::createScriptForLazilyInterpretedFunction.
            MOZ_ASSERT(lazy->numInnerFunctions() == 0);
        }

        if (!xdr->codeUint64(&packedFields))
            return false;

        if (mode == XDR_DECODE) {
            lazy.set(LazyScript::Create(cx, fun, script, enclosingScope, script,
                                        packedFields, begin, end, lineno, column));

            // As opposed to XDRLazyScript, we need to restore the runtime bits
            // of the script, as we are trying to match the fact this function
            // has already been parsed and that it would need to be re-lazified.
            lazy->initRuntimeFields(packedFields);
        }
    }

    // Code binding names.
    if (!XDRLazyClosedOverBindings(xdr, lazy))
        return false;

    // No need to do anything with inner functions, since we asserted we don't
    // have any.

    return true;
}

static inline uint32_t
FindScopeIndex(JSScript* script, Scope& scope)
{
    ScopeArray* scopes = script->scopes();
    GCPtrScope* vector = scopes->vector;
    unsigned length = scopes->length;
    for (uint32_t i = 0; i < length; ++i) {
        if (vector[i] == &scope)
            return i;
    }

    MOZ_CRASH("Scope not found");
}

enum XDRClassKind {
    CK_RegexpObject,
    CK_JSFunction,
    CK_JSObject
};

template<XDRMode mode>
bool
js::XDRScript(XDRState<mode>* xdr, HandleScope scriptEnclosingScope, HandleScript enclosingScript,
              HandleFunction fun, MutableHandleScript scriptp)
{
    /* NB: Keep this in sync with CopyScript. */

    enum ScriptBits {
        NoScriptRval,
        Strict,
        ContainsDynamicNameAccess,
        FunHasExtensibleScope,
        FunHasAnyAliasedFormal,
        ArgumentsHasVarBinding,
        NeedsArgsObj,
        HasMappedArgsObj,
        FunctionHasThisBinding,
        FunctionHasExtraBodyVarScope,
        IsGeneratorExp,
        IsLegacyGenerator,
        IsStarGenerator,
        IsAsync,
        OwnSource,
        ExplicitUseStrict,
        SelfHosted,
        HasSingleton,
        TreatAsRunOnce,
        HasLazyScript,
        HasNonSyntacticScope,
        HasInnerFunctions,
        NeedsHomeObject,
        IsDerivedClassConstructor,
        IsDefaultClassConstructor,
    };

    uint32_t length, lineno, column, nfixed, nslots;
    uint32_t natoms, nsrcnotes, i;
    uint32_t nconsts, nobjects, nscopes, nregexps, ntrynotes, nscopenotes, nyieldoffsets;
    uint32_t prologueLength, version;
    uint32_t funLength = 0;
    uint32_t nTypeSets = 0;
    uint32_t scriptBits = 0;
    uint32_t bodyScopeIndex = 0;

    JSContext* cx = xdr->cx();
    RootedScript script(cx);
    natoms = nsrcnotes = 0;
    nconsts = nobjects = nscopes = nregexps = ntrynotes = nscopenotes = nyieldoffsets = 0;

    if (mode == XDR_ENCODE) {
        script = scriptp.get();
        MOZ_ASSERT_IF(enclosingScript, enclosingScript->compartment() == script->compartment());
        MOZ_ASSERT(script->functionNonDelazifying() == fun);

        if (!fun && script->treatAsRunOnce()) {
            // This is a toplevel or eval script that's runOnce.  We want to
            // make sure that we're not XDR-saving an object we emitted for
            // JSOP_OBJECT that then got modified.  So throw if we're not
            // cloning in JSOP_OBJECT or if we ever didn't clone in it in the
            // past.
            JSCompartment* comp = cx->compartment();
            if (!comp->creationOptions().cloneSingletons() ||
                !comp->behaviors().getSingletonsAsTemplates())
            {
                return xdr->fail(JS::TranscodeResult_Failure_RunOnceNotSupported);
            }
        }
    }

    if (mode == XDR_ENCODE)
        length = script->length();
    if (!xdr->codeUint32(&length))
        return false;

    if (mode == XDR_ENCODE) {
        prologueLength = script->mainOffset();
        MOZ_ASSERT(script->getVersion() != JSVERSION_UNKNOWN);
        version = script->getVersion();
        lineno = script->lineno();
        column = script->column();
        nfixed = script->nfixed();
        nslots = script->nslots();

        bodyScopeIndex = script->bodyScopeIndex();
        natoms = script->natoms();

        nsrcnotes = script->numNotes();

        if (script->hasConsts())
            nconsts = script->consts()->length;
        if (script->hasObjects())
            nobjects = script->objects()->length;
        nscopes = script->scopes()->length;
        if (script->hasTrynotes())
            ntrynotes = script->trynotes()->length;
        if (script->hasScopeNotes())
            nscopenotes = script->scopeNotes()->length;
        if (script->hasYieldOffsets())
            nyieldoffsets = script->yieldOffsets().length();

        nTypeSets = script->nTypeSets();
        funLength = script->funLength();

        if (script->noScriptRval())
            scriptBits |= (1 << NoScriptRval);
        if (script->strict())
            scriptBits |= (1 << Strict);
        if (script->explicitUseStrict())
            scriptBits |= (1 << ExplicitUseStrict);
        if (script->selfHosted())
            scriptBits |= (1 << SelfHosted);
        if (script->bindingsAccessedDynamically())
            scriptBits |= (1 << ContainsDynamicNameAccess);
        if (script->funHasExtensibleScope())
            scriptBits |= (1 << FunHasExtensibleScope);
        if (script->funHasAnyAliasedFormal())
            scriptBits |= (1 << FunHasAnyAliasedFormal);
        if (script->argumentsHasVarBinding())
            scriptBits |= (1 << ArgumentsHasVarBinding);
        if (script->analyzedArgsUsage() && script->needsArgsObj())
            scriptBits |= (1 << NeedsArgsObj);
        if (script->hasMappedArgsObj())
            scriptBits |= (1 << HasMappedArgsObj);
        if (script->functionHasThisBinding())
            scriptBits |= (1 << FunctionHasThisBinding);
        if (script->functionHasExtraBodyVarScope())
            scriptBits |= (1 << FunctionHasExtraBodyVarScope);
        if (!enclosingScript || enclosingScript->scriptSource() != script->scriptSource())
            scriptBits |= (1 << OwnSource);
        if (script->isGeneratorExp())
            scriptBits |= (1 << IsGeneratorExp);
        if (script->isLegacyGenerator())
            scriptBits |= (1 << IsLegacyGenerator);
        if (script->isStarGenerator())
            scriptBits |= (1 << IsStarGenerator);
        if (script->asyncKind() == AsyncFunction)
            scriptBits |= (1 << IsAsync);
        if (script->hasSingletons())
            scriptBits |= (1 << HasSingleton);
        if (script->treatAsRunOnce())
            scriptBits |= (1 << TreatAsRunOnce);
        if (script->isRelazifiable())
            scriptBits |= (1 << HasLazyScript);
        if (script->hasNonSyntacticScope())
            scriptBits |= (1 << HasNonSyntacticScope);
        if (script->hasInnerFunctions())
            scriptBits |= (1 << HasInnerFunctions);
        if (script->needsHomeObject())
            scriptBits |= (1 << NeedsHomeObject);
        if (script->isDerivedClassConstructor())
            scriptBits |= (1 << IsDerivedClassConstructor);
        if (script->isDefaultClassConstructor())
            scriptBits |= (1 << IsDefaultClassConstructor);
    }

    if (!xdr->codeUint32(&prologueLength))
        return false;
    if (!xdr->codeUint32(&version))
        return false;

    // To fuse allocations, we need lengths of all embedded arrays early.
    if (!xdr->codeUint32(&natoms))
        return false;
    if (!xdr->codeUint32(&nsrcnotes))
        return false;
    if (!xdr->codeUint32(&nconsts))
        return false;
    if (!xdr->codeUint32(&nobjects))
        return false;
    if (!xdr->codeUint32(&nscopes))
        return false;
    if (!xdr->codeUint32(&ntrynotes))
        return false;
    if (!xdr->codeUint32(&nscopenotes))
        return false;
    if (!xdr->codeUint32(&nyieldoffsets))
        return false;
    if (!xdr->codeUint32(&nTypeSets))
        return false;
    if (!xdr->codeUint32(&funLength))
        return false;
    if (!xdr->codeUint32(&scriptBits))
        return false;

    if (mode == XDR_DECODE) {
        JSVersion version_ = JSVersion(version);
        MOZ_ASSERT((version_ & VersionFlags::MASK) == unsigned(version_));

        CompileOptions options(cx);
        options.setVersion(version_)
               .setNoScriptRval(!!(scriptBits & (1 << NoScriptRval)))
               .setSelfHostingMode(!!(scriptBits & (1 << SelfHosted)));
        RootedScriptSource sourceObject(cx);
        if (scriptBits & (1 << OwnSource)) {
            ScriptSource* ss = cx->new_<ScriptSource>();
            if (!ss)
                return false;
            ScriptSourceHolder ssHolder(ss);

            /*
             * We use this CompileOptions only to initialize the
             * ScriptSourceObject. Most CompileOptions fields aren't used by
             * ScriptSourceObject, and those that are (element; elementAttributeName)
             * aren't preserved by XDR. So this can be simple.
             */
            CompileOptions options(cx);
            ss->initFromOptions(cx, options);
            sourceObject = ScriptSourceObject::create(cx, ss);
            if (!sourceObject ||
                !ScriptSourceObject::initFromOptions(cx, sourceObject, options))
                return false;
        } else {
            MOZ_ASSERT(enclosingScript);
            // When decoding, all the scripts and the script source object
            // are in the same compartment, so the script's source object
            // should never be a cross-compartment wrapper.
            MOZ_ASSERT(enclosingScript->sourceObject()->is<ScriptSourceObject>());
            sourceObject = &enclosingScript->sourceObject()->as<ScriptSourceObject>();
        }

        script = JSScript::Create(cx, options, sourceObject, 0, 0);
        if (!script)
            return false;

        // Set the script in its function now so that inner scripts to be
        // decoded may iterate the static scope chain.
        if (fun)
            fun->initScript(script);
    }

    if (mode == XDR_DECODE) {
        if (!JSScript::partiallyInit(cx, script, nscopes, nconsts, nobjects, ntrynotes,
                                     nscopenotes, nyieldoffsets, nTypeSets))
        {
            return false;
        }

        MOZ_ASSERT(!script->mainOffset());
        script->mainOffset_ = prologueLength;
        script->funLength_ = funLength;

        scriptp.set(script);

        if (scriptBits & (1 << Strict))
            script->strict_ = true;
        if (scriptBits & (1 << ExplicitUseStrict))
            script->explicitUseStrict_ = true;
        if (scriptBits & (1 << ContainsDynamicNameAccess))
            script->bindingsAccessedDynamically_ = true;
        if (scriptBits & (1 << FunHasExtensibleScope))
            script->funHasExtensibleScope_ = true;
        if (scriptBits & (1 << FunHasAnyAliasedFormal))
            script->funHasAnyAliasedFormal_ = true;
        if (scriptBits & (1 << ArgumentsHasVarBinding))
            script->setArgumentsHasVarBinding();
        if (scriptBits & (1 << NeedsArgsObj))
            script->setNeedsArgsObj(true);
        if (scriptBits & (1 << HasMappedArgsObj))
            script->hasMappedArgsObj_ = true;
        if (scriptBits & (1 << FunctionHasThisBinding))
            script->functionHasThisBinding_ = true;
        if (scriptBits & (1 << FunctionHasExtraBodyVarScope))
            script->functionHasExtraBodyVarScope_ = true;
        if (scriptBits & (1 << IsGeneratorExp))
            script->isGeneratorExp_ = true;
        if (scriptBits & (1 << HasSingleton))
            script->hasSingletons_ = true;
        if (scriptBits & (1 << TreatAsRunOnce))
            script->treatAsRunOnce_ = true;
        if (scriptBits & (1 << HasNonSyntacticScope))
            script->hasNonSyntacticScope_ = true;
        if (scriptBits & (1 << HasInnerFunctions))
            script->hasInnerFunctions_ = true;
        if (scriptBits & (1 << NeedsHomeObject))
            script->needsHomeObject_ = true;
        if (scriptBits & (1 << IsDerivedClassConstructor))
            script->isDerivedClassConstructor_ = true;
        if (scriptBits & (1 << IsDefaultClassConstructor))
            script->isDefaultClassConstructor_ = true;

        if (scriptBits & (1 << IsLegacyGenerator)) {
            MOZ_ASSERT(!(scriptBits & (1 << IsStarGenerator)));
            script->setGeneratorKind(LegacyGenerator);
        } else if (scriptBits & (1 << IsStarGenerator))
            script->setGeneratorKind(StarGenerator);

        if (scriptBits & (1 << IsAsync))
            script->setAsyncKind(AsyncFunction);
    }

    JS_STATIC_ASSERT(sizeof(jsbytecode) == 1);
    JS_STATIC_ASSERT(sizeof(jssrcnote) == 1);

    if (scriptBits & (1 << OwnSource)) {
        if (!script->scriptSource()->performXDR<mode>(xdr))
            return false;
    }
    if (!xdr->codeUint32(&script->sourceStart_))
        return false;
    if (!xdr->codeUint32(&script->sourceEnd_))
        return false;

    if (!xdr->codeUint32(&lineno) ||
        !xdr->codeUint32(&column) ||
        !xdr->codeUint32(&nfixed) ||
        !xdr->codeUint32(&nslots))
    {
        return false;
    }

    if (!xdr->codeUint32(&bodyScopeIndex))
        return false;

    if (mode == XDR_DECODE) {
        script->lineno_ = lineno;
        script->column_ = column;
        script->nfixed_ = nfixed;
        script->nslots_ = nslots;
        script->bodyScopeIndex_ = bodyScopeIndex;
    }

    auto scriptDataGuard = mozilla::MakeScopeExit([&] {
        if (mode == XDR_DECODE)
            script->freeScriptData();
    });

    if (mode == XDR_DECODE) {
        if (!script->createScriptData(cx, length, nsrcnotes, natoms))
            return false;
    }

    jsbytecode* code = script->code();
    if (!xdr->codeBytes(code, length) || !xdr->codeBytes(code + length, nsrcnotes)) {
        return false;
    }

    for (i = 0; i != natoms; ++i) {
        if (mode == XDR_DECODE) {
            RootedAtom tmp(cx);
            if (!XDRAtom(xdr, &tmp))
                return false;
            script->atoms()[i].init(tmp);
        } else {
            RootedAtom tmp(cx, script->atoms()[i]);
            if (!XDRAtom(xdr, &tmp))
                return false;
        }
    }

    scriptDataGuard.release();
    if (mode == XDR_DECODE) {
        if (!script->shareScriptData(cx))
            return false;
    }

    if (nconsts) {
        GCPtrValue* vector = script->consts()->vector;
        RootedValue val(cx);
        for (i = 0; i != nconsts; ++i) {
            if (mode == XDR_ENCODE)
                val = vector[i];
            if (!XDRScriptConst(xdr, &val))
                return false;
            if (mode == XDR_DECODE)
                vector[i].init(val);
        }
    }

    {
        MOZ_ASSERT(nscopes != 0);
        GCPtrScope* vector = script->scopes()->vector;
        RootedScope scope(cx);
        RootedScope enclosing(cx);
        ScopeKind scopeKind;
        uint32_t enclosingScopeIndex = 0;
        for (i = 0; i != nscopes; ++i) {
            if (mode == XDR_ENCODE) {
                scope = vector[i];
                scopeKind = scope->kind();
            } else {
                scope = nullptr;
            }

            if (!xdr->codeEnum32(&scopeKind))
                return false;

            if (mode == XDR_ENCODE) {
                if (i == 0) {
                    enclosingScopeIndex = UINT32_MAX;
                } else {
                    MOZ_ASSERT(scope->enclosing());
                    enclosingScopeIndex = FindScopeIndex(script, *scope->enclosing());
                }
            }

            if (!xdr->codeUint32(&enclosingScopeIndex))
                return false;

            if (mode == XDR_DECODE) {
                if (i == 0) {
                    MOZ_ASSERT(enclosingScopeIndex == UINT32_MAX);
                    enclosing = scriptEnclosingScope;
                } else {
                    MOZ_ASSERT(enclosingScopeIndex < i);
                    enclosing = vector[enclosingScopeIndex];
                }
            }

            switch (scopeKind) {
              case ScopeKind::Function:
                MOZ_ASSERT(i == script->bodyScopeIndex());
                if (!FunctionScope::XDR(xdr, fun, enclosing, &scope))
                    return false;
                break;
              case ScopeKind::FunctionBodyVar:
              case ScopeKind::ParameterExpressionVar:
                if (!VarScope::XDR(xdr, scopeKind, enclosing, &scope))
                    return false;
                break;
              case ScopeKind::Lexical:
              case ScopeKind::SimpleCatch:
              case ScopeKind::Catch:
              case ScopeKind::NamedLambda:
              case ScopeKind::StrictNamedLambda:
                if (!LexicalScope::XDR(xdr, scopeKind, enclosing, &scope))
                    return false;
                break;
              case ScopeKind::With:
                if (mode == XDR_DECODE) {
                    scope = WithScope::create(cx, enclosing);
                    if (!scope)
                        return false;
                }
                break;
              case ScopeKind::Eval:
              case ScopeKind::StrictEval:
                if (!EvalScope::XDR(xdr, scopeKind, enclosing, &scope))
                    return false;
                break;
              case ScopeKind::Global:
              case ScopeKind::NonSyntactic:
                if (!GlobalScope::XDR(xdr, scopeKind, &scope))
                    return false;
                break;
              case ScopeKind::Module:
                MOZ_CRASH("NYI");
                break;
            }

            if (mode == XDR_DECODE)
                vector[i].init(scope);
        }
    }

    /*
     * Here looping from 0-to-length to xdr objects is essential to ensure that
     * all references to enclosing blocks (via FindScopeIndex below) happen
     * after the enclosing block has been XDR'd.
     */
    for (i = 0; i != nobjects; ++i) {
        GCPtrObject* objp = &script->objects()->vector[i];
        XDRClassKind classk;

        if (mode == XDR_ENCODE) {
            JSObject* obj = *objp;
            if (obj->is<RegExpObject>())
                classk = CK_RegexpObject;
            else if (obj->is<JSFunction>())
                classk = CK_JSFunction;
            else if (obj->is<PlainObject>() || obj->is<ArrayObject>())
                classk = CK_JSObject;
            else
                MOZ_CRASH("Cannot encode this class of object.");
        }

        if (!xdr->codeEnum32(&classk))
            return false;

        switch (classk) {
          case CK_RegexpObject: {
            Rooted<RegExpObject*> regexp(cx);
            if (mode == XDR_ENCODE)
                regexp = &(*objp)->as<RegExpObject>();
            if (!XDRScriptRegExpObject(xdr, &regexp))
                return false;
            if (mode == XDR_DECODE)
                *objp = regexp;
            break;
          }

          case CK_JSFunction: {
            /* Code the nested function's enclosing scope. */
            uint32_t funEnclosingScopeIndex = 0;
            RootedScope funEnclosingScope(cx);
            if (mode == XDR_ENCODE) {
                RootedFunction function(cx, &(*objp)->as<JSFunction>());

                if (function->isInterpretedLazy()) {
                    funEnclosingScope = function->lazyScript()->enclosingScope();
                } else if (function->isInterpreted()) {
                    funEnclosingScope = function->nonLazyScript()->enclosingScope();
                } else {
                    MOZ_ASSERT(function->isAsmJSNative());
                    return xdr->fail(JS::TranscodeResult_Failure_AsmJSNotSupported);
                }

                funEnclosingScopeIndex = FindScopeIndex(script, *funEnclosingScope);
            }

            if (!xdr->codeUint32(&funEnclosingScopeIndex))
                return false;

            if (mode == XDR_DECODE) {
                MOZ_ASSERT(funEnclosingScopeIndex < script->scopes()->length);
                funEnclosingScope = script->scopes()->vector[funEnclosingScopeIndex];
            }

            // Code nested function and script.
            RootedFunction tmp(cx);
            if (mode == XDR_ENCODE)
                tmp = &(*objp)->as<JSFunction>();
            if (!XDRInterpretedFunction(xdr, funEnclosingScope, script, &tmp))
                return false;
            *objp = tmp;
            break;
          }

          case CK_JSObject: {
            /* Code object literal. */
            RootedObject tmp(cx, *objp);
            if (!XDRObjectLiteral(xdr, &tmp))
                return false;
            *objp = tmp;
            break;
          }

          default: {
            MOZ_ASSERT(false, "Unknown class kind.");
            return xdr->fail(JS::TranscodeResult_Failure_UnknownClassKind);
          }
        }
    }

    if (ntrynotes != 0) {
        JSTryNote* tnfirst = script->trynotes()->vector;
        MOZ_ASSERT(script->trynotes()->length == ntrynotes);
        JSTryNote* tn = tnfirst + ntrynotes;
        do {
            --tn;
            if (!xdr->codeUint8(&tn->kind) ||
                !xdr->codeUint32(&tn->stackDepth) ||
                !xdr->codeUint32(&tn->start) ||
                !xdr->codeUint32(&tn->length)) {
                return false;
            }
        } while (tn != tnfirst);
    }

    for (i = 0; i < nscopenotes; ++i) {
        ScopeNote* note = &script->scopeNotes()->vector[i];
        if (!xdr->codeUint32(&note->index) ||
            !xdr->codeUint32(&note->start) ||
            !xdr->codeUint32(&note->length) ||
            !xdr->codeUint32(&note->parent))
        {
            return false;
        }
    }

    for (i = 0; i < nyieldoffsets; ++i) {
        uint32_t* offset = &script->yieldOffsets()[i];
        if (!xdr->codeUint32(offset))
            return false;
    }

    if (scriptBits & (1 << HasLazyScript)) {
        Rooted<LazyScript*> lazy(cx);
        if (mode == XDR_ENCODE)
            lazy = script->maybeLazyScript();

        if (!XDRRelazificationInfo(xdr, fun, script, scriptEnclosingScope, &lazy))
            return false;

        if (mode == XDR_DECODE)
            script->setLazyScript(lazy);
    }

    if (mode == XDR_DECODE) {
        scriptp.set(script);

        /* see BytecodeEmitter::tellDebuggerAboutCompiledScript */
        if (!fun)
            Debugger::onNewScript(cx, script);
    }

    return true;
}

template bool
js::XDRScript(XDRState<XDR_ENCODE>*, HandleScope, HandleScript, HandleFunction,
              MutableHandleScript);

template bool
js::XDRScript(XDRState<XDR_DECODE>*, HandleScope, HandleScript, HandleFunction,
              MutableHandleScript);

template<XDRMode mode>
bool
js::XDRLazyScript(XDRState<mode>* xdr, HandleScope enclosingScope, HandleScript enclosingScript,
                  HandleFunction fun, MutableHandle<LazyScript*> lazy)
{
    JSContext* cx = xdr->cx();

    {
        uint32_t begin;
        uint32_t end;
        uint32_t lineno;
        uint32_t column;
        uint64_t packedFields;

        if (mode == XDR_ENCODE) {
            // Note: it's possible the LazyScript has a non-null script_ pointer
            // to a JSScript. We don't encode it: we can just delazify the
            // lazy script.

            MOZ_ASSERT(fun == lazy->functionNonDelazifying());

            begin = lazy->begin();
            end = lazy->end();
            lineno = lazy->lineno();
            column = lazy->column();
            packedFields = lazy->packedFields();
        }

        if (!xdr->codeUint32(&begin) || !xdr->codeUint32(&end) ||
            !xdr->codeUint32(&lineno) || !xdr->codeUint32(&column) ||
            !xdr->codeUint64(&packedFields))
        {
            return false;
        }

        if (mode == XDR_DECODE) {
            lazy.set(LazyScript::Create(cx, fun, nullptr, enclosingScope, enclosingScript,
                                        packedFields, begin, end, lineno, column));
            if (!lazy)
                return false;
            fun->initLazyScript(lazy);
        }
    }

    // Code closed-over bindings.
    if (!XDRLazyClosedOverBindings(xdr, lazy))
        return false;

    // Code inner functions.
    {
        RootedFunction func(cx);
        GCPtrFunction* innerFunctions = lazy->innerFunctions();
        size_t numInnerFunctions = lazy->numInnerFunctions();
        for (size_t i = 0; i < numInnerFunctions; i++) {
            if (mode == XDR_ENCODE)
                func = innerFunctions[i];

            if (!XDRInterpretedFunction(xdr, nullptr, nullptr, &func))
                return false;

            if (mode == XDR_DECODE)
                innerFunctions[i] = func;
        }
    }

    return true;
}

template bool
js::XDRLazyScript(XDRState<XDR_ENCODE>*, HandleScope, HandleScript,
                  HandleFunction, MutableHandle<LazyScript*>);

template bool
js::XDRLazyScript(XDRState<XDR_DECODE>*, HandleScope, HandleScript,
                  HandleFunction, MutableHandle<LazyScript*>);

void
JSScript::setSourceObject(JSObject* object)
{
    MOZ_ASSERT(compartment() == object->compartment());
    sourceObject_ = object;
}

js::ScriptSourceObject&
JSScript::scriptSourceUnwrap() const {
    return UncheckedUnwrap(sourceObject())->as<ScriptSourceObject>();
}

js::ScriptSource*
JSScript::scriptSource() const {
    return scriptSourceUnwrap().source();
}

js::ScriptSource*
JSScript::maybeForwardedScriptSource() const {
    return UncheckedUnwrap(MaybeForwarded(sourceObject()))->as<ScriptSourceObject>().source();
}

bool
JSScript::initScriptCounts(JSContext* cx)
{
    MOZ_ASSERT(!hasScriptCounts());

    // Record all pc which are the first instruction of a basic block.
    mozilla::Vector<jsbytecode*, 16, SystemAllocPolicy> jumpTargets;
    jsbytecode* mainPc = main();
    jsbytecode* end = codeEnd();
    for (jsbytecode* pc = code(); pc != end; pc = GetNextPc(pc)) {
        if (BytecodeIsJumpTarget(JSOp(*pc)) || pc == mainPc) {
            if (!jumpTargets.append(pc)) {
                ReportOutOfMemory(cx);
                return false;
            }
        }
    }

    // Initialize all PCCounts counters to 0.
    ScriptCounts::PCCountsVector base;
    if (!base.reserve(jumpTargets.length())) {
        ReportOutOfMemory(cx);
        return false;
    }

    for (size_t i = 0; i < jumpTargets.length(); i++)
        base.infallibleEmplaceBack(pcToOffset(jumpTargets[i]));

    // Create compartment's scriptCountsMap if necessary.
    ScriptCountsMap* map = compartment()->scriptCountsMap;
    if (!map) {
        map = cx->new_<ScriptCountsMap>();
        if (!map) {
            ReportOutOfMemory(cx);
            return false;
        }

        if (!map->init()) {
            js_delete(map);
            ReportOutOfMemory(cx);
            return false;
        }

        compartment()->scriptCountsMap = map;
    }

    // Allocate the ScriptCounts.
    ScriptCounts* sc = cx->new_<ScriptCounts>(Move(base));
    if (!sc) {
        ReportOutOfMemory(cx);
        return false;
    }
    auto guardScriptCounts = mozilla::MakeScopeExit([&] () {
        js_delete(sc);
    });

    // Register the current ScriptCounts in the compartment's map.
    if (!map->putNew(this, sc)) {
        ReportOutOfMemory(cx);
        return false;
    }

    // safe to set this;  we can't fail after this point.
    hasScriptCounts_ = true;
    guardScriptCounts.release();

    // Enable interrupts in any interpreter frames running on this script. This
    // is used to let the interpreter increment the PCCounts, if present.
    for (ActivationIterator iter(cx->runtime()); !iter.done(); ++iter) {
        if (iter->isInterpreter())
            iter->asInterpreter()->enableInterruptsIfRunning(this);
    }

    return true;
}

static inline ScriptCountsMap::Ptr GetScriptCountsMapEntry(JSScript* script)
{
    MOZ_ASSERT(script->hasScriptCounts());
    ScriptCountsMap* map = script->compartment()->scriptCountsMap;
    ScriptCountsMap::Ptr p = map->lookup(script);
    MOZ_ASSERT(p);
    return p;
}

ScriptCounts&
JSScript::getScriptCounts()
{
    ScriptCountsMap::Ptr p = GetScriptCountsMapEntry(this);
    return *p->value();
}

js::PCCounts*
ScriptCounts::maybeGetPCCounts(size_t offset) {
    PCCounts searched = PCCounts(offset);
    PCCounts* elem = std::lower_bound(pcCounts_.begin(), pcCounts_.end(), searched);
    if (elem == pcCounts_.end() || elem->pcOffset() != offset)
        return nullptr;
    return elem;
}

const js::PCCounts*
ScriptCounts::maybeGetPCCounts(size_t offset) const {
    PCCounts searched = PCCounts(offset);
    const PCCounts* elem = std::lower_bound(pcCounts_.begin(), pcCounts_.end(), searched);
    if (elem == pcCounts_.end() || elem->pcOffset() != offset)
        return nullptr;
    return elem;
}

js::PCCounts*
ScriptCounts::getImmediatePrecedingPCCounts(size_t offset)
{
    PCCounts searched = PCCounts(offset);
    PCCounts* elem = std::lower_bound(pcCounts_.begin(), pcCounts_.end(), searched);
    if (elem == pcCounts_.end())
        return &pcCounts_.back();
    if (elem->pcOffset() == offset)
        return elem;
    if (elem != pcCounts_.begin())
        return elem - 1;
    return nullptr;
}

const js::PCCounts*
ScriptCounts::maybeGetThrowCounts(size_t offset) const {
    PCCounts searched = PCCounts(offset);
    const PCCounts* elem = std::lower_bound(throwCounts_.begin(), throwCounts_.end(), searched);
    if (elem == throwCounts_.end() || elem->pcOffset() != offset)
        return nullptr;
    return elem;
}

const js::PCCounts*
ScriptCounts::getImmediatePrecedingThrowCounts(size_t offset) const
{
    PCCounts searched = PCCounts(offset);
    const PCCounts* elem = std::lower_bound(throwCounts_.begin(), throwCounts_.end(), searched);
    if (elem == throwCounts_.end()) {
        if (throwCounts_.begin() == throwCounts_.end())
            return nullptr;
        return &throwCounts_.back();
    }
    if (elem->pcOffset() == offset)
        return elem;
    if (elem != throwCounts_.begin())
        return elem - 1;
    return nullptr;
}

js::PCCounts*
ScriptCounts::getThrowCounts(size_t offset) {
    PCCounts searched = PCCounts(offset);
    PCCounts* elem = std::lower_bound(throwCounts_.begin(), throwCounts_.end(), searched);
    if (elem == throwCounts_.end() || elem->pcOffset() != offset)
        elem = throwCounts_.insert(elem, searched);
    return elem;
}

void
JSScript::setIonScript(JSRuntime* maybeRuntime, js::jit::IonScript* ionScript)
{
    MOZ_ASSERT_IF(ionScript != ION_DISABLED_SCRIPT, !baselineScript()->hasPendingIonBuilder());
    if (hasIonScript())
        js::jit::IonScript::writeBarrierPre(zone(), ion);
    ion = ionScript;
    MOZ_ASSERT_IF(hasIonScript(), hasBaselineScript());
    updateBaselineOrIonRaw(maybeRuntime);
}

js::PCCounts*
JSScript::maybeGetPCCounts(jsbytecode* pc) {
    MOZ_ASSERT(containsPC(pc));
    return getScriptCounts().maybeGetPCCounts(pcToOffset(pc));
}

const js::PCCounts*
JSScript::maybeGetThrowCounts(jsbytecode* pc) {
    MOZ_ASSERT(containsPC(pc));
    return getScriptCounts().maybeGetThrowCounts(pcToOffset(pc));
}

js::PCCounts*
JSScript::getThrowCounts(jsbytecode* pc) {
    MOZ_ASSERT(containsPC(pc));
    return getScriptCounts().getThrowCounts(pcToOffset(pc));
}

uint64_t
JSScript::getHitCount(jsbytecode* pc)
{
    MOZ_ASSERT(containsPC(pc));
    if (pc < main())
        pc = main();

    ScriptCounts& sc = getScriptCounts();
    size_t targetOffset = pcToOffset(pc);
    const js::PCCounts* baseCount = sc.getImmediatePrecedingPCCounts(targetOffset);
    if (!baseCount)
        return 0;
    if (baseCount->pcOffset() == targetOffset)
        return baseCount->numExec();
    MOZ_ASSERT(baseCount->pcOffset() < targetOffset);
    uint64_t count = baseCount->numExec();
    do {
        const js::PCCounts* throwCount = sc.getImmediatePrecedingThrowCounts(targetOffset);
        if (!throwCount)
            return count;
        if (throwCount->pcOffset() <= baseCount->pcOffset())
            return count;
        count -= throwCount->numExec();
        targetOffset = throwCount->pcOffset() - 1;
    } while (true);
}

void
JSScript::incHitCount(jsbytecode* pc)
{
    MOZ_ASSERT(containsPC(pc));
    if (pc < main())
        pc = main();

    ScriptCounts& sc = getScriptCounts();
    js::PCCounts* baseCount = sc.getImmediatePrecedingPCCounts(pcToOffset(pc));
    if (!baseCount)
        return;
    baseCount->numExec()++;
}

void
JSScript::addIonCounts(jit::IonScriptCounts* ionCounts)
{
    ScriptCounts& sc = getScriptCounts();
    if (sc.ionCounts_)
        ionCounts->setPrevious(sc.ionCounts_);
    sc.ionCounts_ = ionCounts;
}

jit::IonScriptCounts*
JSScript::getIonCounts()
{
    return getScriptCounts().ionCounts_;
}

void
JSScript::takeOverScriptCountsMapEntry(ScriptCounts* entryValue)
{
#ifdef DEBUG
    ScriptCountsMap::Ptr p = GetScriptCountsMapEntry(this);
    MOZ_ASSERT(entryValue == p->value());
#endif
    hasScriptCounts_ = false;
}

void
JSScript::releaseScriptCounts(ScriptCounts* counts)
{
    ScriptCountsMap::Ptr p = GetScriptCountsMapEntry(this);
    *counts = Move(*p->value());
    js_delete(p->value());
    compartment()->scriptCountsMap->remove(p);
    hasScriptCounts_ = false;
}

void
JSScript::destroyScriptCounts(FreeOp* fop)
{
    if (hasScriptCounts()) {
        ScriptCounts scriptCounts;
        releaseScriptCounts(&scriptCounts);
    }
}

void
ScriptSourceObject::trace(JSTracer* trc, JSObject* obj)
{
    ScriptSourceObject* sso = static_cast<ScriptSourceObject*>(obj);

    // Don't trip over the poison 'not yet initialized' values.
    if (!sso->getReservedSlot(INTRODUCTION_SCRIPT_SLOT).isMagic(JS_GENERIC_MAGIC)) {
        JSScript* script = sso->introductionScript();
        if (script) {
            TraceManuallyBarrieredEdge(trc, &script, "ScriptSourceObject introductionScript");
            sso->setReservedSlot(INTRODUCTION_SCRIPT_SLOT, PrivateValue(script));
        }
    }
}

void
ScriptSourceObject::finalize(FreeOp* fop, JSObject* obj)
{
    MOZ_ASSERT(fop->onMainThread());
    ScriptSourceObject* sso = &obj->as<ScriptSourceObject>();

    // If code coverage is enabled, record the filename associated with this
    // source object.
    if (fop->runtime()->lcovOutput.isEnabled())
        sso->compartment()->lcovOutput.collectSourceFile(sso->compartment(), sso);

    sso->source()->decref();
    sso->setReservedSlot(SOURCE_SLOT, PrivateValue(nullptr));
}

static const ClassOps ScriptSourceObjectClassOps = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    ScriptSourceObject::finalize,
    nullptr, /* call */
    nullptr, /* hasInstance */
    nullptr, /* construct */
    ScriptSourceObject::trace
};

const Class ScriptSourceObject::class_ = {
    "ScriptSource",
    JSCLASS_HAS_RESERVED_SLOTS(RESERVED_SLOTS) |
    JSCLASS_IS_ANONYMOUS |
    JSCLASS_FOREGROUND_FINALIZE,
    &ScriptSourceObjectClassOps
};

ScriptSourceObject*
ScriptSourceObject::create(ExclusiveContext* cx, ScriptSource* source)
{
    RootedObject object(cx, NewObjectWithGivenProto(cx, &class_, nullptr));
    if (!object)
        return nullptr;
    RootedScriptSource sourceObject(cx, &object->as<ScriptSourceObject>());

    source->incref();    // The matching decref is in ScriptSourceObject::finalize.
    sourceObject->initReservedSlot(SOURCE_SLOT, PrivateValue(source));

    // The remaining slots should eventually be populated by a call to
    // initFromOptions. Poison them until that point.
    sourceObject->initReservedSlot(ELEMENT_SLOT, MagicValue(JS_GENERIC_MAGIC));
    sourceObject->initReservedSlot(ELEMENT_PROPERTY_SLOT, MagicValue(JS_GENERIC_MAGIC));
    sourceObject->initReservedSlot(INTRODUCTION_SCRIPT_SLOT, MagicValue(JS_GENERIC_MAGIC));

    return sourceObject;
}

/* static */ bool
ScriptSourceObject::initFromOptions(JSContext* cx, HandleScriptSource source,
                                    const ReadOnlyCompileOptions& options)
{
    releaseAssertSameCompartment(cx, source);
    MOZ_ASSERT(source->getReservedSlot(ELEMENT_SLOT).isMagic(JS_GENERIC_MAGIC));
    MOZ_ASSERT(source->getReservedSlot(ELEMENT_PROPERTY_SLOT).isMagic(JS_GENERIC_MAGIC));
    MOZ_ASSERT(source->getReservedSlot(INTRODUCTION_SCRIPT_SLOT).isMagic(JS_GENERIC_MAGIC));

    RootedValue element(cx, ObjectOrNullValue(options.element()));
    if (!cx->compartment()->wrap(cx, &element))
        return false;
    source->setReservedSlot(ELEMENT_SLOT, element);

    RootedValue elementAttributeName(cx);
    if (options.elementAttributeName())
        elementAttributeName = StringValue(options.elementAttributeName());
    else
        elementAttributeName = UndefinedValue();
    if (!cx->compartment()->wrap(cx, &elementAttributeName))
        return false;
    source->setReservedSlot(ELEMENT_PROPERTY_SLOT, elementAttributeName);

    // There is no equivalent of cross-compartment wrappers for scripts. If the
    // introduction script and ScriptSourceObject are in different compartments,
    // we would be creating a cross-compartment script reference, which is
    // forbidden. In that case, simply don't bother to retain the introduction
    // script.
    if (options.introductionScript() &&
        options.introductionScript()->compartment() == cx->compartment())
    {
        source->setReservedSlot(INTRODUCTION_SCRIPT_SLOT, PrivateValue(options.introductionScript()));
    } else {
        source->setReservedSlot(INTRODUCTION_SCRIPT_SLOT, UndefinedValue());
    }

    return true;
}

/* static */ bool
JSScript::loadSource(JSContext* cx, ScriptSource* ss, bool* worked)
{
    MOZ_ASSERT(!ss->hasSourceData());
    *worked = false;
    if (!cx->runtime()->sourceHook || !ss->sourceRetrievable())
        return true;
    char16_t* src = nullptr;
    size_t length;
    if (!cx->runtime()->sourceHook->load(cx, ss->filename(), &src, &length))
        return false;
    if (!src)
        return true;
    if (!ss->setSource(cx, mozilla::UniquePtr<char16_t[], JS::FreePolicy>(src), length))
        return false;

    *worked = true;
    return true;
}

JSFlatString*
JSScript::sourceData(JSContext* cx)
{
    MOZ_ASSERT(scriptSource()->hasSourceData());
    return scriptSource()->substring(cx, sourceStart(), sourceEnd());
}

UncompressedSourceCache::AutoHoldEntry::AutoHoldEntry()
  : cache_(nullptr), sourceChunk_()
{
}

void
UncompressedSourceCache::AutoHoldEntry::holdEntry(UncompressedSourceCache* cache,
                                                  const ScriptSourceChunk& sourceChunk)
{
    // Initialise the holder for a specific cache and script source. This will
    // hold on to the cached source chars in the event that the cache is purged.
    MOZ_ASSERT(!cache_ && !sourceChunk_.valid() && !charsToFree_);
    cache_ = cache;
    sourceChunk_ = sourceChunk;
}

void
UncompressedSourceCache::AutoHoldEntry::holdChars(UniqueTwoByteChars chars)
{
    MOZ_ASSERT(!cache_ && !sourceChunk_.valid() && !charsToFree_);
    charsToFree_ = Move(chars);
}

void
UncompressedSourceCache::AutoHoldEntry::deferDelete(UniqueTwoByteChars chars)
{
    // Take ownership of source chars now the cache is being purged. Remove our
    // reference to the ScriptSource which might soon be destroyed.
    MOZ_ASSERT(cache_ && sourceChunk_.valid() && !charsToFree_);
    cache_ = nullptr;
    sourceChunk_ = ScriptSourceChunk();
    charsToFree_ = Move(chars);
}

UncompressedSourceCache::AutoHoldEntry::~AutoHoldEntry()
{
    if (cache_) {
        MOZ_ASSERT(sourceChunk_.valid());
        cache_->releaseEntry(*this);
    }
}

void
UncompressedSourceCache::holdEntry(AutoHoldEntry& holder, const ScriptSourceChunk& ssc)
{
    MOZ_ASSERT(!holder_);
    holder.holdEntry(this, ssc);
    holder_ = &holder;
}

void
UncompressedSourceCache::releaseEntry(AutoHoldEntry& holder)
{
    MOZ_ASSERT(holder_ == &holder);
    holder_ = nullptr;
}

const char16_t*
UncompressedSourceCache::lookup(const ScriptSourceChunk& ssc, AutoHoldEntry& holder)
{
    MOZ_ASSERT(!holder_);
    if (!map_)
        return nullptr;
    if (Map::Ptr p = map_->lookup(ssc)) {
        holdEntry(holder, ssc);
        return p->value().get();
    }
    return nullptr;
}

bool
UncompressedSourceCache::put(const ScriptSourceChunk& ssc, UniqueTwoByteChars str,
                             AutoHoldEntry& holder)
{
    MOZ_ASSERT(!holder_);

    if (!map_) {
        UniquePtr<Map> map = MakeUnique<Map>();
        if (!map || !map->init())
            return false;

        map_ = Move(map);
    }

    if (!map_->put(ssc, Move(str)))
        return false;

    holdEntry(holder, ssc);
    return true;
}

void
UncompressedSourceCache::purge()
{
    if (!map_)
        return;

    for (Map::Range r = map_->all(); !r.empty(); r.popFront()) {
        if (holder_ && r.front().key() == holder_->sourceChunk()) {
            holder_->deferDelete(Move(r.front().value()));
            holder_ = nullptr;
        }
    }

    map_.reset();
}

size_t
UncompressedSourceCache::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf)
{
    size_t n = 0;
    if (map_ && !map_->empty()) {
        n += map_->sizeOfIncludingThis(mallocSizeOf);
        for (Map::Range r = map_->all(); !r.empty(); r.popFront())
            n += mallocSizeOf(r.front().value().get());
    }
    return n;
}

const char16_t*
ScriptSource::chunkChars(JSContext* cx, UncompressedSourceCache::AutoHoldEntry& holder,
                         size_t chunk)
{
    const Compressed& c = data.as<Compressed>();

    ScriptSourceChunk ssc(this, chunk);
    if (const char16_t* decompressed = cx->caches.uncompressedSourceCache.lookup(ssc, holder))
        return decompressed;

    size_t totalLengthInBytes = length() * sizeof(char16_t);
    size_t chunkBytes = Compressor::chunkSize(totalLengthInBytes, chunk);

    MOZ_ASSERT((chunkBytes % sizeof(char16_t)) == 0);
    const size_t lengthWithNull = (chunkBytes / sizeof(char16_t)) + 1;
    UniqueTwoByteChars decompressed(js_pod_malloc<char16_t>(lengthWithNull));
    if (!decompressed) {
        JS_ReportOutOfMemory(cx);
        return nullptr;
    }

    if (!DecompressStringChunk((const unsigned char*) c.raw.chars(),
                               chunk,
                               reinterpret_cast<unsigned char*>(decompressed.get()),
                               chunkBytes))
    {
        JS_ReportOutOfMemory(cx);
        return nullptr;
    }

    decompressed[lengthWithNull - 1] = '\0';

    const char16_t* ret = decompressed.get();
    if (!cx->caches.uncompressedSourceCache.put(ssc, Move(decompressed), holder)) {
        JS_ReportOutOfMemory(cx);
        return nullptr;
    }
    return ret;
}

const char16_t*
ScriptSource::chars(JSContext* cx, UncompressedSourceCache::AutoHoldEntry& holder,
                    size_t begin, size_t len)
{
    MOZ_ASSERT(begin + len <= length());

    if (data.is<Uncompressed>()) {
        const char16_t* chars = data.as<Uncompressed>().string.chars();
        if (!chars)
            return nullptr;
        return chars + begin;
    }

    if (data.is<Missing>())
        MOZ_CRASH("ScriptSource::chars() on ScriptSource with SourceType = Missing");

    MOZ_ASSERT(data.is<Compressed>());

    // Determine which chunk(s) we are interested in, and the offsets within
    // these chunks.
    size_t firstChunk, lastChunk;
    size_t firstChunkOffset, lastChunkOffset;
    MOZ_ASSERT(len > 0);
    Compressor::toChunkOffset(begin * sizeof(char16_t), &firstChunk, &firstChunkOffset);
    Compressor::toChunkOffset((begin + len - 1) * sizeof(char16_t), &lastChunk, &lastChunkOffset);

    MOZ_ASSERT(firstChunkOffset % sizeof(char16_t) == 0);
    size_t firstChar = firstChunkOffset / sizeof(char16_t);

    if (firstChunk == lastChunk) {
        const char16_t* chars = chunkChars(cx, holder, firstChunk);
        if (!chars)
            return nullptr;
        return chars + firstChar;
    }

    // We need multiple chunks. Allocate a (null-terminated) buffer to hold
    // |len| chars and copy uncompressed chars from the chunks into it. We use
    // chunkChars() so we benefit from chunk caching by UncompressedSourceCache.

    MOZ_ASSERT(firstChunk < lastChunk);

    size_t lengthWithNull = len + 1;
    UniqueTwoByteChars decompressed(js_pod_malloc<char16_t>(lengthWithNull));
    if (!decompressed) {
        JS_ReportOutOfMemory(cx);
        return nullptr;
    }

    size_t totalLengthInBytes = length() * sizeof(char16_t);
    char16_t* cursor = decompressed.get();

    for (size_t i = firstChunk; i <= lastChunk; i++) {
        UncompressedSourceCache::AutoHoldEntry chunkHolder;
        const char16_t* chars = chunkChars(cx, chunkHolder, i);
        if (!chars)
            return nullptr;

        size_t numChars = Compressor::chunkSize(totalLengthInBytes, i) / sizeof(char16_t);
        if (i == firstChunk) {
            MOZ_ASSERT(firstChar < numChars);
            chars += firstChar;
            numChars -= firstChar;
        } else if (i == lastChunk) {
            size_t numCharsNew = lastChunkOffset / sizeof(char16_t) + 1;
            MOZ_ASSERT(numCharsNew <= numChars);
            numChars = numCharsNew;
        }
        mozilla::PodCopy(cursor, chars, numChars);
        cursor += numChars;
    }

    *cursor++ = '\0';
    MOZ_ASSERT(size_t(cursor - decompressed.get()) == lengthWithNull);

    // Transfer ownership to |holder|.
    const char16_t* ret = decompressed.get();
    holder.holdChars(Move(decompressed));
    return ret;
}

JSFlatString*
ScriptSource::substring(JSContext* cx, size_t start, size_t stop)
{
    MOZ_ASSERT(start <= stop);
    size_t len = stop - start;
    UncompressedSourceCache::AutoHoldEntry holder;
    const char16_t* chars = this->chars(cx, holder, start, len);
    if (!chars)
        return nullptr;
    return NewStringCopyN<CanGC>(cx, chars, len);
}

JSFlatString*
ScriptSource::substringDontDeflate(JSContext* cx, size_t start, size_t stop)
{
    MOZ_ASSERT(start <= stop);
    size_t len = stop - start;
    UncompressedSourceCache::AutoHoldEntry holder;
    const char16_t* chars = this->chars(cx, holder, start, len);
    if (!chars)
        return nullptr;
    return NewStringCopyNDontDeflate<CanGC>(cx, chars, len);
}

MOZ_MUST_USE bool
ScriptSource::setSource(ExclusiveContext* cx,
                        mozilla::UniquePtr<char16_t[], JS::FreePolicy>&& source,
                        size_t length)
{
    auto& cache = cx->zone()->runtimeFromAnyThread()->sharedImmutableStrings();
    auto deduped = cache.getOrCreate(mozilla::Move(source), length);
    if (!deduped) {
        ReportOutOfMemory(cx);
        return false;
    }
    setSource(mozilla::Move(*deduped));
    return true;
}

void
ScriptSource::setSource(SharedImmutableTwoByteString&& string)
{
    MOZ_ASSERT(data.is<Missing>());
    data = SourceType(Uncompressed(mozilla::Move(string)));
}

MOZ_MUST_USE bool
ScriptSource::setCompressedSource(ExclusiveContext* cx,
                                  mozilla::UniquePtr<char[], JS::FreePolicy>&& raw,
                                  size_t rawLength,
                                  size_t sourceLength)
{
    MOZ_ASSERT(raw);
    auto& cache = cx->zone()->runtimeFromAnyThread()->sharedImmutableStrings();
    auto deduped = cache.getOrCreate(mozilla::Move(raw), rawLength);
    if (!deduped) {
        ReportOutOfMemory(cx);
        return false;
    }
    setCompressedSource(mozilla::Move(*deduped), sourceLength);
    return true;
}

void
ScriptSource::setCompressedSource(SharedImmutableString&& raw, size_t uncompressedLength)
{
    MOZ_ASSERT(data.is<Missing>() || data.is<Uncompressed>());
    MOZ_ASSERT_IF(data.is<Uncompressed>(),
                  data.as<Uncompressed>().string.length() == uncompressedLength);

    data = SourceType(Compressed(mozilla::Move(raw), uncompressedLength));
}

bool
ScriptSource::setSourceCopy(ExclusiveContext* cx, SourceBufferHolder& srcBuf,
                            bool argumentsNotIncluded, SourceCompressionTask* task)
{
    MOZ_ASSERT(!hasSourceData());
    argumentsNotIncluded_ = argumentsNotIncluded;

    auto& cache = cx->zone()->runtimeFromAnyThread()->sharedImmutableStrings();
    auto deduped = cache.getOrCreate(srcBuf.get(), srcBuf.length(), [&]() {
        return srcBuf.ownsChars()
            ? mozilla::UniquePtr<char16_t[], JS::FreePolicy>(srcBuf.take())
            : DuplicateString(srcBuf.get(), srcBuf.length());
    });
    if (!deduped) {
        ReportOutOfMemory(cx);
        return false;
    }
    setSource(mozilla::Move(*deduped));

    // There are several cases where source compression is not a good idea:
    //  - If the script is tiny, then compression will save little or no space.
    //  - If there is only one core, then compression will contend with JS
    //    execution (which hurts benchmarketing).
    //  - If the source contains a giant string, then parsing will finish much
    //    faster than compression which increases latency (this case is handled
    //    in Parser::stringLiteral).
    //
    // Lastly, since the parsing thread will eventually perform a blocking wait
    // on the compression task's thread, require that there are at least 2
    // helper threads:
    //  - If we are on a helper thread, there must be another helper thread to
    //    execute our compression task.
    //  - If we are on the main thread, there must be at least two helper
    //    threads since at most one helper thread can be blocking on the main
    //    thread (see HelperThreadState::canStartParseTask) which would cause a
    //    deadlock if there wasn't a second helper thread that could make
    //    progress on our compression task.
    bool canCompressOffThread =
        HelperThreadState().cpuCount > 1 &&
        HelperThreadState().threadCount >= 2 &&
        CanUseExtraThreads();
    const size_t TINY_SCRIPT = 256;
    if (TINY_SCRIPT <= srcBuf.length() && canCompressOffThread) {
        task->ss = this;
        if (!StartOffThreadCompression(cx, task))
            return false;
    }

    return true;
}

static MOZ_MUST_USE bool
reallocUniquePtr(UniquePtr<char[], JS::FreePolicy>& unique, size_t size)
{
    auto newPtr = static_cast<char*>(js_realloc(unique.get(), size));
    if (!newPtr)
        return false;

    // Since the realloc succeeded, unique is now holding a freed pointer.
    mozilla::Unused << unique.release();
    unique.reset(newPtr);
    return true;
}

SourceCompressionTask::ResultType
SourceCompressionTask::work()
{
    MOZ_ASSERT(ss->data.is<ScriptSource::Uncompressed>());

    // Try to keep the maximum memory usage down by only allocating half the
    // size of the string, first.
    size_t inputBytes = ss->length() * sizeof(char16_t);
    size_t firstSize = inputBytes / 2;
    mozilla::UniquePtr<char[], JS::FreePolicy> compressed(js_pod_malloc<char>(firstSize));
    if (!compressed)
        return OOM;

    const char16_t* chars = ss->data.as<ScriptSource::Uncompressed>().string.chars();
    Compressor comp(reinterpret_cast<const unsigned char*>(chars),
                    inputBytes);
    if (!comp.init())
        return OOM;

    comp.setOutput(reinterpret_cast<unsigned char*>(compressed.get()), firstSize);
    bool cont = true;
    bool reallocated = false;
    while (cont) {
        if (abort_)
            return Aborted;

        switch (comp.compressMore()) {
          case Compressor::CONTINUE:
            break;
          case Compressor::MOREOUTPUT: {
            if (reallocated) {
                // The compressed string is longer than the original string.
                return Aborted;
            }

            // The compressed output is greater than half the size of the
            // original string. Reallocate to the full size.
            if (!reallocUniquePtr(compressed, inputBytes))
                return OOM;

            comp.setOutput(reinterpret_cast<unsigned char*>(compressed.get()), inputBytes);
            reallocated = true;
            break;
          }
          case Compressor::DONE:
            cont = false;
            break;
          case Compressor::OOM:
            return OOM;
        }
    }

    size_t totalBytes = comp.totalBytesNeeded();

    // Shrink the buffer to the size of the compressed data.
    if (!reallocUniquePtr(compressed, totalBytes))
        return OOM;

    comp.finish(compressed.get(), totalBytes);

    auto& strings = cx->sharedImmutableStrings();
    resultString = strings.getOrCreate(mozilla::Move(compressed), totalBytes);
    if (!resultString)
        return OOM;

    return Success;
}

void
ScriptSource::addSizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf,
                                     JS::ScriptSourceInfo* info) const
{
    info->misc += mallocSizeOf(this) +
                  mallocSizeOf(filename_.get()) +
                  mallocSizeOf(introducerFilename_.get());
    info->numScripts++;
}

template<XDRMode mode>
bool
ScriptSource::performXDR(XDRState<mode>* xdr)
{
    struct CompressedLengthMatcher
    {
        size_t match(Uncompressed&) {
            return 0;
        }

        size_t match(Compressed& c) {
            return c.raw.length();
        }

        size_t match(Missing&) {
            MOZ_CRASH("Missing source data in ScriptSource::performXDR");
            return 0;
        }
    };

    struct RawDataMatcher
    {
        void* match(Uncompressed& u) {
            return (void*) u.string.chars();
        }

        void* match(Compressed& c) {
            return (void*) c.raw.chars();
        }

        void* match(Missing&) {
            MOZ_CRASH("Missing source data in ScriptSource::performXDR");
            return nullptr;
        }
    };

    uint8_t hasSource = hasSourceData();
    if (!xdr->codeUint8(&hasSource))
        return false;

    uint8_t retrievable = sourceRetrievable_;
    if (!xdr->codeUint8(&retrievable))
        return false;
    sourceRetrievable_ = retrievable;

    if (hasSource && !sourceRetrievable_) {
        uint32_t len = 0;
        if (mode == XDR_ENCODE)
            len = length();
        if (!xdr->codeUint32(&len))
            return false;

        uint32_t compressedLength;
        if (mode == XDR_ENCODE) {
            CompressedLengthMatcher m;
            compressedLength = data.match(m);
        }
        if (!xdr->codeUint32(&compressedLength))
            return false;

        {
            uint8_t argumentsNotIncluded;
            if (mode == XDR_ENCODE)
                argumentsNotIncluded = argumentsNotIncluded_;
            if (!xdr->codeUint8(&argumentsNotIncluded))
                return false;
            if (mode == XDR_DECODE)
                argumentsNotIncluded_ = argumentsNotIncluded;
        }

        size_t byteLen = compressedLength ? compressedLength : (len * sizeof(char16_t));
        if (mode == XDR_DECODE) {
            uint8_t* p = xdr->cx()->template pod_malloc<uint8_t>(Max<size_t>(byteLen, 1));
            if (!p || !xdr->codeBytes(p, byteLen)) {
                js_free(p);
                return false;
            }

            if (compressedLength) {
                mozilla::UniquePtr<char[], JS::FreePolicy> compressedSource(
                    reinterpret_cast<char*>(p));
                if (!setCompressedSource(xdr->cx(), mozilla::Move(compressedSource), byteLen, len))
                    return false;
            } else {
                mozilla::UniquePtr<char16_t[], JS::FreePolicy> source(
                    reinterpret_cast<char16_t*>(p));
                if (!setSource(xdr->cx(), mozilla::Move(source), len))
                    return false;
            }
        } else {
            RawDataMatcher rdm;
            void* p = data.match(rdm);
            if (!xdr->codeBytes(p, byteLen))
                return false;
        }
    }

    uint8_t haveSourceMap = hasSourceMapURL();
    if (!xdr->codeUint8(&haveSourceMap))
        return false;

    if (haveSourceMap) {
        uint32_t sourceMapURLLen = (mode == XDR_DECODE) ? 0 : js_strlen(sourceMapURL_.get());
        if (!xdr->codeUint32(&sourceMapURLLen))
            return false;

        if (mode == XDR_DECODE) {
            sourceMapURL_ = xdr->cx()->template make_pod_array<char16_t>(sourceMapURLLen + 1);
            if (!sourceMapURL_)
                return false;
        }
        if (!xdr->codeChars(sourceMapURL_.get(), sourceMapURLLen)) {
            if (mode == XDR_DECODE)
                sourceMapURL_ = nullptr;
            return false;
        }
        sourceMapURL_[sourceMapURLLen] = '\0';
    }

    uint8_t haveDisplayURL = hasDisplayURL();
    if (!xdr->codeUint8(&haveDisplayURL))
        return false;

    if (haveDisplayURL) {
        uint32_t displayURLLen = (mode == XDR_DECODE) ? 0 : js_strlen(displayURL_.get());
        if (!xdr->codeUint32(&displayURLLen))
            return false;

        if (mode == XDR_DECODE) {
            displayURL_ = xdr->cx()->template make_pod_array<char16_t>(displayURLLen + 1);
            if (!displayURL_)
                return false;
        }
        if (!xdr->codeChars(displayURL_.get(), displayURLLen)) {
            if (mode == XDR_DECODE)
                displayURL_ = nullptr;
            return false;
        }
        displayURL_[displayURLLen] = '\0';
    }

    uint8_t haveFilename = !!filename_;
    if (!xdr->codeUint8(&haveFilename))
        return false;

    if (haveFilename) {
        const char* fn = filename();
        if (!xdr->codeCString(&fn))
            return false;
        if (mode == XDR_DECODE && !setFilename(xdr->cx(), fn))
            return false;
    }

    return true;
}

// Format and return a cx->zone()->pod_malloc'ed URL for a generated script like:
//   {filename} line {lineno} > {introducer}
// For example:
//   foo.js line 7 > eval
// indicating code compiled by the call to 'eval' on line 7 of foo.js.
static char*
FormatIntroducedFilename(ExclusiveContext* cx, const char* filename, unsigned lineno,
                         const char* introducer)
{
    // Compute the length of the string in advance, so we can allocate a
    // buffer of the right size on the first shot.
    //
    // (JS_smprintf would be perfect, as that allocates the result
    // dynamically as it formats the string, but it won't allocate from cx,
    // and wants us to use a special free function.)
    char linenoBuf[15];
    size_t filenameLen = strlen(filename);
    size_t linenoLen = SprintfLiteral(linenoBuf, "%u", lineno);
    size_t introducerLen = strlen(introducer);
    size_t len = filenameLen                    +
                 6 /* == strlen(" line ") */    +
                 linenoLen                      +
                 3 /* == strlen(" > ") */       +
                 introducerLen                  +
                 1 /* \0 */;
    char* formatted = cx->zone()->pod_malloc<char>(len);
    if (!formatted) {
        ReportOutOfMemory(cx);
        return nullptr;
    }
    mozilla::DebugOnly<size_t> checkLen = snprintf(formatted, len, "%s line %s > %s",
                                                   filename, linenoBuf, introducer);
    MOZ_ASSERT(checkLen == len - 1);

    return formatted;
}

bool
ScriptSource::initFromOptions(ExclusiveContext* cx, const ReadOnlyCompileOptions& options)
{
    MOZ_ASSERT(!filename_);
    MOZ_ASSERT(!introducerFilename_);

    mutedErrors_ = options.mutedErrors();

    introductionType_ = options.introductionType;
    setIntroductionOffset(options.introductionOffset);

    if (options.hasIntroductionInfo) {
        MOZ_ASSERT(options.introductionType != nullptr);
        const char* filename = options.filename() ? options.filename() : "<unknown>";
        char* formatted = FormatIntroducedFilename(cx, filename, options.introductionLineno,
                                                   options.introductionType);
        if (!formatted)
            return false;
        filename_.reset(formatted);
    } else if (options.filename()) {
        if (!setFilename(cx, options.filename()))
            return false;
    }

    if (options.introducerFilename()) {
        introducerFilename_ = DuplicateString(cx, options.introducerFilename());
        if (!introducerFilename_)
            return false;
    }

    return true;
}

bool
ScriptSource::setFilename(ExclusiveContext* cx, const char* filename)
{
    MOZ_ASSERT(!filename_);
    filename_ = DuplicateString(cx, filename);
    return filename_ != nullptr;
}

bool
ScriptSource::setDisplayURL(ExclusiveContext* cx, const char16_t* displayURL)
{
    MOZ_ASSERT(displayURL);
    if (hasDisplayURL()) {
        // FIXME: filename_.get() should be UTF-8 (bug 987069).
        if (cx->isJSContext() &&
            !JS_ReportErrorFlagsAndNumberLatin1(cx->asJSContext(), JSREPORT_WARNING,
                                                GetErrorMessage, nullptr,
                                                JSMSG_ALREADY_HAS_PRAGMA, filename_.get(),
                                                "//# sourceURL"))
        {
            return false;
        }
    }
    size_t len = js_strlen(displayURL) + 1;
    if (len == 1)
        return true;

    displayURL_ = DuplicateString(cx, displayURL);
    return displayURL_ != nullptr;
}

bool
ScriptSource::setSourceMapURL(ExclusiveContext* cx, const char16_t* sourceMapURL)
{
    MOZ_ASSERT(sourceMapURL);

    size_t len = js_strlen(sourceMapURL) + 1;
    if (len == 1)
        return true;

    sourceMapURL_ = DuplicateString(cx, sourceMapURL);
    return sourceMapURL_ != nullptr;
}

/*
 * Shared script data management.
 */

SharedScriptData*
js::SharedScriptData::new_(ExclusiveContext* cx, uint32_t codeLength,
                           uint32_t srcnotesLength, uint32_t natoms)
{
    uint32_t dataLength = natoms * sizeof(GCPtrAtom) + codeLength + srcnotesLength;
    uint32_t allocLength = offsetof(SharedScriptData, data_) + dataLength;
    auto entry = reinterpret_cast<SharedScriptData*>(cx->zone()->pod_malloc<uint8_t>(allocLength));
    if (!entry) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    entry->refCount_ = 0;
    entry->dataLength_ = dataLength;
    entry->natoms_ = natoms;
    entry->codeLength_ = codeLength;

    /*
     * Call constructors to initialize the storage that will be accessed as a
     * GCPtrAtom array via atoms().
     */
    GCPtrAtom* atoms = entry->atoms();
    MOZ_ASSERT(reinterpret_cast<uintptr_t>(atoms) % sizeof(GCPtrAtom*) == 0);
    for (unsigned i = 0; i < natoms; ++i)
        new (&atoms[i]) GCPtrAtom();

    return entry;
}

bool
JSScript::createScriptData(ExclusiveContext* cx, uint32_t codeLength, uint32_t srcnotesLength,
                           uint32_t natoms)
{
    MOZ_ASSERT(!scriptData());
    SharedScriptData* ssd = SharedScriptData::new_(cx, codeLength, srcnotesLength, natoms);
    if (!ssd)
        return false;

    setScriptData(ssd);
    return true;
}

void
JSScript::freeScriptData()
{
    MOZ_ASSERT(scriptData_->refCount() == 1);
    scriptData_->decRefCount();
    scriptData_ = nullptr;
}

void
JSScript::setScriptData(js::SharedScriptData* data)
{
    MOZ_ASSERT(!scriptData_);
    scriptData_ = data;
    scriptData_->incRefCount();
}

/*
 * Takes ownership of its *ssd parameter and either adds it into the runtime's
 * ScriptDataTable or frees it if a matching entry already exists.
 *
 * Sets the |code| and |atoms| fields on the given JSScript.
 */
bool
JSScript::shareScriptData(ExclusiveContext* cx)
{
    SharedScriptData* ssd = scriptData();
    MOZ_ASSERT(ssd);
    MOZ_ASSERT(ssd->refCount() == 1);

    AutoLockForExclusiveAccess lock(cx);

    ScriptBytecodeHasher::Lookup l(ssd);

    ScriptDataTable::AddPtr p = cx->scriptDataTable(lock).lookupForAdd(l);
    if (p) {
        MOZ_ASSERT(ssd != *p);
        freeScriptData();
        setScriptData(*p);
    } else {
        if (!cx->scriptDataTable(lock).add(p, ssd)) {
            freeScriptData();
            ReportOutOfMemory(cx);
            return false;
        }

        // Being in the table counts as a reference on the script data.
        scriptData()->incRefCount();
    }

    MOZ_ASSERT(scriptData()->refCount() >= 2);
    return true;
}

void
js::SweepScriptData(JSRuntime* rt, AutoLockForExclusiveAccess& lock)
{
    // Entries are removed from the table when their reference count is one,
    // i.e. when the only reference to them is from the table entry.

    ScriptDataTable& table = rt->scriptDataTable(lock);

    for (ScriptDataTable::Enum e(table); !e.empty(); e.popFront()) {
        SharedScriptData* scriptData = e.front();
        if (scriptData->refCount() == 1) {
            scriptData->decRefCount();
            e.removeFront();
        }
    }
}

void
js::FreeScriptData(JSRuntime* rt, AutoLockForExclusiveAccess& lock)
{
    ScriptDataTable& table = rt->scriptDataTable(lock);
    if (!table.initialized())
        return;

    // The table should be empty unless the embedding leaked GC things.
    MOZ_ASSERT_IF(rt->gc.shutdownCollectedEverything(), table.empty());

    for (ScriptDataTable::Enum e(table); !e.empty(); e.popFront()) {
#ifdef DEBUG
        SharedScriptData* scriptData = e.front();
        fprintf(stderr, "ERROR: GC found live SharedScriptData %p with ref count %d at shutdown\n",
                scriptData, scriptData->refCount());
#endif
        js_free(e.front());
    }

    table.clear();
}

/*
 * JSScript::data and SharedScriptData::data have complex,
 * manually-controlled, memory layouts.
 *
 * JSScript::data begins with some optional array headers. They are optional
 * because they often aren't needed, i.e. the corresponding arrays often have
 * zero elements. Each header has a bit in JSScript::hasArrayBits that
 * indicates if it's present within |data|; from this the offset of each
 * present array header can be computed. Each header has an accessor function
 * in JSScript that encapsulates this offset computation.
 *
 * Array type      Array elements  Accessor
 * ----------      --------------  --------
 * ConstArray      Consts          consts()
 * ObjectArray     Objects         objects()
 * ObjectArray     Regexps         regexps()
 * TryNoteArray    Try notes       trynotes()
 * ScopeNoteArray  Scope notes     scopeNotes()
 *
 * Then are the elements of several arrays.
 * - Most of these arrays have headers listed above (if present). For each of
 *   these, the array pointer and the array length is stored in the header.
 * - The remaining arrays have pointers and lengths that are stored directly in
 *   JSScript. This is because, unlike the others, they are nearly always
 *   non-zero length and so the optional-header space optimization isn't
 *   worthwhile.
 *
 * Array elements   Pointed to by         Length
 * --------------   -------------         ------
 * Consts           consts()->vector      consts()->length
 * Objects          objects()->vector     objects()->length
 * Regexps          regexps()->vector     regexps()->length
 * Try notes        trynotes()->vector    trynotes()->length
 * Scope notes      scopeNotes()->vector  scopeNotes()->length
 *
 * IMPORTANT: This layout has two key properties.
 * - It ensures that everything has sufficient alignment; in particular, the
 *   consts() elements need Value alignment.
 * - It ensures there are no gaps between elements, which saves space and makes
 *   manual layout easy. In particular, in the second part, arrays with larger
 *   elements precede arrays with smaller elements.
 *
 * SharedScriptData::data contains data that can be shared within a
 * runtime. These items' layout is manually controlled to make it easier to
 * manage both during (temporary) allocation and during matching against
 * existing entries in the runtime. As the jsbytecode has to come first to
 * enable lookup by bytecode identity, SharedScriptData::data, the atoms part
 * has to manually be aligned sufficiently by adding padding after the notes
 * part.
 *
 * Array elements   Pointed to by         Length
 * --------------   -------------         ------
 * jsbytecode       code                  length
 * jsscrnote        notes()               numNotes()
 * Atoms            atoms                 natoms
 *
 * The following static assertions check JSScript::data's alignment properties.
 */

template<class T>
constexpr bool
KeepsValueAlignment() {
    return alignof(JS::Value) % alignof(T) == 0 &&
           sizeof(T) % sizeof(JS::Value) == 0;
}

template<class T>
constexpr bool
HasValueAlignment() {
    return alignof(JS::Value) == alignof(T) &&
           sizeof(T) == sizeof(JS::Value);
}

template<class T1, class T2>
constexpr bool
NoPaddingBetweenEntries() {
    return alignof(T1) % alignof(T2) == 0;
}

/*
 * These assertions ensure that there is no padding between the array headers,
 * and also that the consts() elements (which follow immediately afterward) are
 * Value-aligned.  (There is an assumption that |data| itself is Value-aligned;
 * we check this below).
 */
JS_STATIC_ASSERT(KeepsValueAlignment<ConstArray>());
JS_STATIC_ASSERT(KeepsValueAlignment<ObjectArray>());       /* there are two of these */
JS_STATIC_ASSERT(KeepsValueAlignment<TryNoteArray>());
JS_STATIC_ASSERT(KeepsValueAlignment<ScopeNoteArray>());

/* These assertions ensure there is no padding required between array elements. */
JS_STATIC_ASSERT(HasValueAlignment<GCPtrValue>());
JS_STATIC_ASSERT((NoPaddingBetweenEntries<GCPtrValue, GCPtrObject>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<GCPtrObject, GCPtrObject>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<GCPtrObject, JSTryNote>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<JSTryNote, uint32_t>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<uint32_t, uint32_t>()));

JS_STATIC_ASSERT((NoPaddingBetweenEntries<GCPtrValue, ScopeNote>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<ScopeNote, ScopeNote>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<JSTryNote, ScopeNote>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<GCPtrObject, ScopeNote>()));
JS_STATIC_ASSERT((NoPaddingBetweenEntries<ScopeNote, uint32_t>()));

static inline size_t
ScriptDataSize(uint32_t nscopes, uint32_t nconsts, uint32_t nobjects,
               uint32_t ntrynotes, uint32_t nscopenotes, uint32_t nyieldoffsets)
{
    size_t size = 0;

    MOZ_ASSERT(nscopes != 0);
    size += sizeof(ScopeArray) + nscopes * sizeof(Scope*);
    if (nconsts != 0)
        size += sizeof(ConstArray) + nconsts * sizeof(Value);
    if (nobjects != 0)
        size += sizeof(ObjectArray) + nobjects * sizeof(NativeObject*);
    if (ntrynotes != 0)
        size += sizeof(TryNoteArray) + ntrynotes * sizeof(JSTryNote);
    if (nscopenotes != 0)
        size += sizeof(ScopeNoteArray) + nscopenotes * sizeof(ScopeNote);
    if (nyieldoffsets != 0)
        size += sizeof(YieldOffsetArray) + nyieldoffsets * sizeof(uint32_t);

     return size;
}

void
JSScript::initCompartment(ExclusiveContext* cx)
{
    compartment_ = cx->compartment_;
}

/* static */ JSScript*
JSScript::Create(ExclusiveContext* cx, const ReadOnlyCompileOptions& options,
                 HandleObject sourceObject, uint32_t bufStart, uint32_t bufEnd)
{
    MOZ_ASSERT(bufStart <= bufEnd);

    RootedScript script(cx, Allocate<JSScript>(cx));
    if (!script)
        return nullptr;

    PodZero(script.get());

    script->initCompartment(cx);

    script->selfHosted_ = options.selfHostingMode;
    script->noScriptRval_ = options.noScriptRval;
    script->treatAsRunOnce_ = options.isRunOnce;

    script->version = options.version;
    MOZ_ASSERT(script->getVersion() == options.version);     // assert that no overflow occurred

    script->setSourceObject(sourceObject);
    script->sourceStart_ = bufStart;
    script->sourceEnd_ = bufEnd;

    return script;
}

static inline uint8_t*
AllocScriptData(JS::Zone* zone, size_t size)
{
    if (!size)
        return nullptr;

    uint8_t* data = zone->pod_calloc<uint8_t>(JS_ROUNDUP(size, sizeof(Value)));
    if (!data)
        return nullptr;
    MOZ_ASSERT(size_t(data) % sizeof(Value) == 0);
    return data;
}

/* static */ bool
JSScript::partiallyInit(ExclusiveContext* cx, HandleScript script, uint32_t nscopes,
                        uint32_t nconsts, uint32_t nobjects, uint32_t ntrynotes,
                        uint32_t nscopenotes, uint32_t nyieldoffsets, uint32_t nTypeSets)
{
    size_t size = ScriptDataSize(nscopes, nconsts, nobjects, ntrynotes,
                                 nscopenotes, nyieldoffsets);
    script->data = AllocScriptData(script->zone(), size);
    if (size && !script->data) {
        ReportOutOfMemory(cx);
        return false;
    }
    script->dataSize_ = size;

    MOZ_ASSERT(nTypeSets <= UINT16_MAX);
    script->nTypeSets_ = uint16_t(nTypeSets);

    uint8_t* cursor = script->data;

    // There must always be at least 1 scope, the body scope.
    MOZ_ASSERT(nscopes != 0);
    cursor += sizeof(ScopeArray);

    if (nconsts != 0) {
        script->setHasArray(CONSTS);
        cursor += sizeof(ConstArray);
    }
    if (nobjects != 0) {
        script->setHasArray(OBJECTS);
        cursor += sizeof(ObjectArray);
    }

    if (ntrynotes != 0) {
        script->setHasArray(TRYNOTES);
        cursor += sizeof(TryNoteArray);
    }
    if (nscopenotes != 0) {
        script->setHasArray(SCOPENOTES);
        cursor += sizeof(ScopeNoteArray);
    }

    YieldOffsetArray* yieldOffsets = nullptr;
    if (nyieldoffsets != 0) {
        yieldOffsets = reinterpret_cast<YieldOffsetArray*>(cursor);
        cursor += sizeof(YieldOffsetArray);
    }

    if (nconsts != 0) {
        MOZ_ASSERT(reinterpret_cast<uintptr_t>(cursor) % sizeof(JS::Value) == 0);
        script->consts()->length = nconsts;
        script->consts()->vector = (GCPtrValue*)cursor;
        cursor += nconsts * sizeof(script->consts()->vector[0]);
    }

    script->scopes()->length = nscopes;
    script->scopes()->vector = (GCPtrScope*)cursor;
    cursor += nscopes * sizeof(script->scopes()->vector[0]);

    if (nobjects != 0) {
        script->objects()->length = nobjects;
        script->objects()->vector = (GCPtrObject*)cursor;
        cursor += nobjects * sizeof(script->objects()->vector[0]);
    }

    if (ntrynotes != 0) {
        script->trynotes()->length = ntrynotes;
        script->trynotes()->vector = reinterpret_cast<JSTryNote*>(cursor);
        size_t vectorSize = ntrynotes * sizeof(script->trynotes()->vector[0]);
#ifdef DEBUG
        memset(cursor, 0, vectorSize);
#endif
        cursor += vectorSize;
    }

    if (nscopenotes != 0) {
        script->scopeNotes()->length = nscopenotes;
        script->scopeNotes()->vector = reinterpret_cast<ScopeNote*>(cursor);
        size_t vectorSize = nscopenotes * sizeof(script->scopeNotes()->vector[0]);
#ifdef DEBUG
        memset(cursor, 0, vectorSize);
#endif
        cursor += vectorSize;
    }

    if (nyieldoffsets != 0) {
        yieldOffsets->init(reinterpret_cast<uint32_t*>(cursor), nyieldoffsets);
        size_t vectorSize = nyieldoffsets * sizeof(script->yieldOffsets()[0]);
#ifdef DEBUG
        memset(cursor, 0, vectorSize);
#endif
        cursor += vectorSize;
    }

    MOZ_ASSERT(cursor == script->data + size);
    return true;
}

/* static */ bool
JSScript::initFunctionPrototype(ExclusiveContext* cx, Handle<JSScript*> script,
                                HandleFunction functionProto)
{
    uint32_t numScopes = 1;
    uint32_t numConsts = 0;
    uint32_t numObjects = 0;
    uint32_t numTryNotes = 0;
    uint32_t numScopeNotes = 0;
    uint32_t numYieldOffsets = 0;
    uint32_t numTypeSets = 0;
    if (!partiallyInit(cx, script, numScopes, numConsts, numObjects, numTryNotes,
                       numScopeNotes, numYieldOffsets, numTypeSets))
    {
        return false;
    }

    RootedScope enclosing(cx, &cx->global()->emptyGlobalScope());
    Scope* functionProtoScope = FunctionScope::create(cx, nullptr, false, false, functionProto,
                                                      enclosing);
    if (!functionProtoScope)
        return false;
    script->scopes()->vector[0].init(functionProtoScope);

    uint32_t codeLength = 1;
    uint32_t srcNotesLength = 1;
    uint32_t numAtoms = 0;
    if (!script->createScriptData(cx, codeLength, srcNotesLength, numAtoms))
        return false;

    jsbytecode* code = script->code();
    code[0] = JSOP_RETRVAL;
    code[1] = SRC_NULL;
    return script->shareScriptData(cx);
}

static void
InitAtomMap(frontend::AtomIndexMap& indices, GCPtrAtom* atoms)
{
    for (AtomIndexMap::Range r = indices.all(); !r.empty(); r.popFront()) {
        JSAtom* atom = r.front().key();
        uint32_t index = r.front().value();
        MOZ_ASSERT(index < indices.count());
        atoms[index].init(atom);
    }
}

/* static */ void
JSScript::initFromFunctionBox(ExclusiveContext* cx, HandleScript script,
                              frontend::FunctionBox* funbox)
{
    JSFunction* fun = funbox->function();
    if (fun->isInterpretedLazy())
        fun->setUnlazifiedScript(script);
    else
        fun->setScript(script);

    script->funHasExtensibleScope_ = funbox->hasExtensibleScope();
    script->needsHomeObject_       = funbox->needsHomeObject();
    script->isDerivedClassConstructor_ = funbox->isDerivedClassConstructor();

    if (funbox->argumentsHasLocalBinding()) {
        script->setArgumentsHasVarBinding();
        if (funbox->definitelyNeedsArgsObj())
            script->setNeedsArgsObj(true);
    } else {
        MOZ_ASSERT(!funbox->definitelyNeedsArgsObj());
    }
    script->hasMappedArgsObj_ = funbox->hasMappedArgsObj();

    script->functionHasThisBinding_ = funbox->hasThisBinding();
    script->functionHasExtraBodyVarScope_ = funbox->hasExtraBodyVarScope();

    script->funLength_ = funbox->length;

    script->isGeneratorExp_ = funbox->isGenexpLambda;
    script->setGeneratorKind(funbox->generatorKind());
    script->setAsyncKind(funbox->asyncKind());

    PositionalFormalParameterIter fi(script);
    while (fi && !fi.closedOver())
        fi++;
    script->funHasAnyAliasedFormal_ = !!fi;

    script->setHasInnerFunctions(funbox->hasInnerFunctions());
}

/* static */ void
JSScript::initFromModuleContext(ExclusiveContext* cx, HandleScript script,
                                frontend::ModuleSharedContext* modulesc)
{
    script->funHasExtensibleScope_ = false;
    script->needsHomeObject_ = false;
    script->isDerivedClassConstructor_ = false;
    script->funLength_ = 0;

    script->isGeneratorExp_ = false;
    script->setGeneratorKind(NotGenerator);

    // Since modules are only run once, mark the script so that initializers
    // created within it may be given more precise types.
    script->setTreatAsRunOnce();
    MOZ_ASSERT(!script->hasRunOnce());
}

/* static */ bool
JSScript::fullyInitFromEmitter(ExclusiveContext* cx, HandleScript script, BytecodeEmitter* bce)
{
    /* The counts of indexed things must be checked during code generation. */
    MOZ_ASSERT(bce->atomIndices->count() <= INDEX_LIMIT);
    MOZ_ASSERT(bce->objectList.length <= INDEX_LIMIT);

    uint32_t mainLength = bce->offset();
    uint32_t prologueLength = bce->prologueOffset();
    uint32_t nsrcnotes;
    if (!bce->finishTakingSrcNotes(&nsrcnotes))
        return false;
    uint32_t natoms = bce->atomIndices->count();
    if (!partiallyInit(cx, script,
                       bce->scopeList.length(), bce->constList.length(), bce->objectList.length,
                       bce->tryNoteList.length(), bce->scopeNoteList.length(),
                       bce->yieldOffsetList.length(), bce->typesetCount))
    {
        return false;
    }

    MOZ_ASSERT(script->mainOffset() == 0);
    script->mainOffset_ = prologueLength;

    script->lineno_ = bce->firstLine;

    if (!script->createScriptData(cx, prologueLength + mainLength, nsrcnotes, natoms))
        return false;

    jsbytecode* code = script->code();
    PodCopy<jsbytecode>(code, bce->prologue.code.begin(), prologueLength);
    PodCopy<jsbytecode>(code + prologueLength, bce->main.code.begin(), mainLength);
    bce->copySrcNotes((jssrcnote*)(code + script->length()), nsrcnotes);
    InitAtomMap(*bce->atomIndices, script->atoms());

    if (!script->shareScriptData(cx))
        return false;

    if (bce->constList.length() != 0)
        bce->constList.finish(script->consts());
    if (bce->objectList.length != 0)
        bce->objectList.finish(script->objects());
    if (bce->scopeList.length() != 0)
        bce->scopeList.finish(script->scopes());
    if (bce->tryNoteList.length() != 0)
        bce->tryNoteList.finish(script->trynotes());
    if (bce->scopeNoteList.length() != 0)
        bce->scopeNoteList.finish(script->scopeNotes(), prologueLength);
    script->strict_ = bce->sc->strict();
    script->explicitUseStrict_ = bce->sc->hasExplicitUseStrict();
    script->bindingsAccessedDynamically_ = bce->sc->bindingsAccessedDynamically();
    script->hasSingletons_ = bce->hasSingletons;

    uint64_t nslots = bce->maxFixedSlots + static_cast<uint64_t>(bce->maxStackDepth);
    if (nslots > UINT32_MAX) {
        bce->reportError(nullptr, JSMSG_NEED_DIET, js_script_str);
        return false;
    }

    script->nfixed_ = bce->maxFixedSlots;
    script->nslots_ = nslots;
    script->bodyScopeIndex_ = bce->bodyScopeIndex;
    script->hasNonSyntacticScope_ = bce->outermostScope()->hasOnChain(ScopeKind::NonSyntactic);

    if (bce->sc->isFunctionBox())
        initFromFunctionBox(cx, script, bce->sc->asFunctionBox());
    else if (bce->sc->isModuleContext())
        initFromModuleContext(cx, script, bce->sc->asModuleContext());

    // Copy yield offsets last, as the generator kind is set in
    // initFromFunctionBox.
    if (bce->yieldOffsetList.length() != 0)
        bce->yieldOffsetList.finish(script->yieldOffsets(), prologueLength);

#ifdef DEBUG
    script->assertValidJumpTargets();
#endif

    return true;
}

#ifdef DEBUG
void
JSScript::assertValidJumpTargets() const
{
    jsbytecode* end = codeEnd();
    jsbytecode* mainEntry = main();
    for (jsbytecode* pc = code(); pc != end; pc = GetNextPc(pc)) {
        // Check jump instructions' target.
        if (IsJumpOpcode(JSOp(*pc))) {
            jsbytecode* target = pc + GET_JUMP_OFFSET(pc);
            MOZ_ASSERT(mainEntry <= target && target < end);
            MOZ_ASSERT(BytecodeIsJumpTarget(JSOp(*target)));

            // Check fallthrough of conditional jump instructions.
            if (BytecodeFallsThrough(JSOp(*pc))) {
                jsbytecode* fallthrough = GetNextPc(pc);
                MOZ_ASSERT(mainEntry <= fallthrough && fallthrough < end);
                MOZ_ASSERT(BytecodeIsJumpTarget(JSOp(*fallthrough)));
            }
        }

        // Check table switch case labels.
        if (JSOp(*pc) == JSOP_TABLESWITCH) {
            jsbytecode* pc2 = pc;
            int32_t len = GET_JUMP_OFFSET(pc2);

            // Default target.
            MOZ_ASSERT(mainEntry <= pc + len && pc + len < end);
            MOZ_ASSERT(BytecodeIsJumpTarget(JSOp(*(pc + len))));

            pc2 += JUMP_OFFSET_LEN;
            int32_t low = GET_JUMP_OFFSET(pc2);
            pc2 += JUMP_OFFSET_LEN;
            int32_t high = GET_JUMP_OFFSET(pc2);

            for (int i = 0; i < high - low + 1; i++) {
                pc2 += JUMP_OFFSET_LEN;
                int32_t off = (int32_t) GET_JUMP_OFFSET(pc2);
                // Case (i + low)
                MOZ_ASSERT_IF(off, mainEntry <= pc + off && pc + off < end);
                MOZ_ASSERT_IF(off, BytecodeIsJumpTarget(JSOp(*(pc + off))));
            }
        }
    }

    // Check catch/finally blocks as jump targets.
    if (hasTrynotes()) {
        JSTryNote* tn = trynotes()->vector;
        JSTryNote* tnlimit = tn + trynotes()->length;
        for (; tn < tnlimit; tn++) {
            jsbytecode* tryStart = mainEntry + tn->start;
            jsbytecode* tryPc = tryStart - 1;
            if (JSOp(*tryPc) != JSOP_TRY)
                continue;

            jsbytecode* tryTarget = tryStart + tn->length;
            MOZ_ASSERT(mainEntry <= tryTarget && tryTarget < end);
            MOZ_ASSERT(BytecodeIsJumpTarget(JSOp(*tryTarget)));
        }
    }
}
#endif

size_t
JSScript::computedSizeOfData() const
{
    return dataSize();
}

size_t
JSScript::sizeOfData(mozilla::MallocSizeOf mallocSizeOf) const
{
    return mallocSizeOf(data);
}

size_t
JSScript::sizeOfTypeScript(mozilla::MallocSizeOf mallocSizeOf) const
{
    return types_->sizeOfIncludingThis(mallocSizeOf);
}

/*
 * Nb: srcnotes are variable-length.  This function computes the number of
 * srcnote *slots*, which may be greater than the number of srcnotes.
 */
uint32_t
JSScript::numNotes()
{
    jssrcnote* sn;
    jssrcnote* notes_ = notes();
    for (sn = notes_; !SN_IS_TERMINATOR(sn); sn = SN_NEXT(sn))
        continue;
    return sn - notes_ + 1;    /* +1 for the terminator */
}

js::GlobalObject&
JSScript::uninlinedGlobal() const
{
    return global();
}

void
JSScript::finalize(FreeOp* fop)
{
    // NOTE: this JSScript may be partially initialized at this point.  E.g. we
    // may have created it and partially initialized it with
    // JSScript::Create(), but not yet finished initializing it with
    // fullyInitFromEmitter() or fullyInitTrivial().

    // Collect code coverage information for this script and all its inner
    // scripts, and store the aggregated information on the compartment.
    if (fop->runtime()->lcovOutput.isEnabled())
        compartment()->lcovOutput.collectCodeCoverageInfo(compartment(), sourceObject(), this);

    fop->runtime()->spsProfiler.onScriptFinalized(this);

    if (types_)
        types_->destroy();

    jit::DestroyJitScripts(fop, this);

    destroyScriptCounts(fop);
    destroyDebugScript(fop);

    if (data) {
        JS_POISON(data, 0xdb, computedSizeOfData());
        fop->free_(data);
    }

    if (scriptData_)
        scriptData_->decRefCount();

    fop->runtime()->contextFromMainThread()->caches.lazyScriptCache.remove(this);

    // In most cases, our LazyScript's script pointer will reference this
    // script, and thus be nulled out by normal weakref processing. However, if
    // we unlazified the LazyScript during incremental sweeping, it will have a
    // completely different JSScript.
    MOZ_ASSERT_IF(lazyScript && !IsAboutToBeFinalizedUnbarriered(&lazyScript),
                  !lazyScript->hasScript() || lazyScript->maybeScriptUnbarriered() != this);
}

static const uint32_t GSN_CACHE_THRESHOLD = 100;

void
GSNCache::purge()
{
    code = nullptr;
    if (map.initialized())
        map.finish();
}

jssrcnote*
js::GetSrcNote(GSNCache& cache, JSScript* script, jsbytecode* pc)
{
    size_t target = pc - script->code();
    if (target >= script->length())
        return nullptr;

    if (cache.code == script->code()) {
        MOZ_ASSERT(cache.map.initialized());
        GSNCache::Map::Ptr p = cache.map.lookup(pc);
        return p ? p->value() : nullptr;
    }

    size_t offset = 0;
    jssrcnote* result;
    for (jssrcnote* sn = script->notes(); ; sn = SN_NEXT(sn)) {
        if (SN_IS_TERMINATOR(sn)) {
            result = nullptr;
            break;
        }
        offset += SN_DELTA(sn);
        if (offset == target && SN_IS_GETTABLE(sn)) {
            result = sn;
            break;
        }
    }

    if (cache.code != script->code() && script->length() >= GSN_CACHE_THRESHOLD) {
        unsigned nsrcnotes = 0;
        for (jssrcnote* sn = script->notes(); !SN_IS_TERMINATOR(sn);
             sn = SN_NEXT(sn))
        {
            if (SN_IS_GETTABLE(sn))
                ++nsrcnotes;
        }
        if (cache.code) {
            MOZ_ASSERT(cache.map.initialized());
            cache.map.finish();
            cache.code = nullptr;
        }
        if (cache.map.init(nsrcnotes)) {
            pc = script->code();
            for (jssrcnote* sn = script->notes(); !SN_IS_TERMINATOR(sn);
                 sn = SN_NEXT(sn))
            {
                pc += SN_DELTA(sn);
                if (SN_IS_GETTABLE(sn))
                    cache.map.putNewInfallible(pc, sn);
            }
            cache.code = script->code();
        }
    }

    return result;
}

jssrcnote*
js::GetSrcNote(JSContext* cx, JSScript* script, jsbytecode* pc)
{
    return GetSrcNote(cx->caches.gsnCache, script, pc);
}

unsigned
js::PCToLineNumber(unsigned startLine, jssrcnote* notes, jsbytecode* code, jsbytecode* pc,
                   unsigned* columnp)
{
    unsigned lineno = startLine;
    unsigned column = 0;

    /*
     * Walk through source notes accumulating their deltas, keeping track of
     * line-number notes, until we pass the note for pc's offset within
     * script->code.
     */
    ptrdiff_t offset = 0;
    ptrdiff_t target = pc - code;
    for (jssrcnote* sn = notes; !SN_IS_TERMINATOR(sn); sn = SN_NEXT(sn)) {
        offset += SN_DELTA(sn);
        if (offset > target)
            break;

        SrcNoteType type = (SrcNoteType) SN_TYPE(sn);
        if (type == SRC_SETLINE) {
            lineno = unsigned(GetSrcNoteOffset(sn, 0));
            column = 0;
        } else if (type == SRC_NEWLINE) {
            lineno++;
            column = 0;
        } else if (type == SRC_COLSPAN) {
            ptrdiff_t colspan = SN_OFFSET_TO_COLSPAN(GetSrcNoteOffset(sn, 0));
            MOZ_ASSERT(ptrdiff_t(column) + colspan >= 0);
            column += colspan;
        }
    }

    if (columnp)
        *columnp = column;

    return lineno;
}

unsigned
js::PCToLineNumber(JSScript* script, jsbytecode* pc, unsigned* columnp)
{
    /* Cope with InterpreterFrame.pc value prior to entering Interpret. */
    if (!pc)
        return 0;

    return PCToLineNumber(script->lineno(), script->notes(), script->code(), pc, columnp);
}

jsbytecode*
js::LineNumberToPC(JSScript* script, unsigned target)
{
    ptrdiff_t offset = 0;
    ptrdiff_t best = -1;
    unsigned lineno = script->lineno();
    unsigned bestdiff = SN_MAX_OFFSET;
    for (jssrcnote* sn = script->notes(); !SN_IS_TERMINATOR(sn); sn = SN_NEXT(sn)) {
        /*
         * Exact-match only if offset is not in the prologue; otherwise use
         * nearest greater-or-equal line number match.
         */
        if (lineno == target && offset >= ptrdiff_t(script->mainOffset()))
            goto out;
        if (lineno >= target) {
            unsigned diff = lineno - target;
            if (diff < bestdiff) {
                bestdiff = diff;
                best = offset;
            }
        }
        offset += SN_DELTA(sn);
        SrcNoteType type = (SrcNoteType) SN_TYPE(sn);
        if (type == SRC_SETLINE) {
            lineno = unsigned(GetSrcNoteOffset(sn, 0));
        } else if (type == SRC_NEWLINE) {
            lineno++;
        }
    }
    if (best >= 0)
        offset = best;
out:
    return script->offsetToPC(offset);
}

JS_FRIEND_API(unsigned)
js::GetScriptLineExtent(JSScript* script)
{
    unsigned lineno = script->lineno();
    unsigned maxLineNo = lineno;
    for (jssrcnote* sn = script->notes(); !SN_IS_TERMINATOR(sn); sn = SN_NEXT(sn)) {
        SrcNoteType type = (SrcNoteType) SN_TYPE(sn);
        if (type == SRC_SETLINE)
            lineno = unsigned(GetSrcNoteOffset(sn, 0));
        else if (type == SRC_NEWLINE)
            lineno++;

        if (maxLineNo < lineno)
            maxLineNo = lineno;
    }

    return 1 + maxLineNo - script->lineno();
}

void
js::DescribeScriptedCallerForCompilation(JSContext* cx, MutableHandleScript maybeScript,
                                         const char** file, unsigned* linenop,
                                         uint32_t* pcOffset, bool* mutedErrors,
                                         LineOption opt)
{
    if (opt == CALLED_FROM_JSOP_EVAL) {
        jsbytecode* pc = nullptr;
        maybeScript.set(cx->currentScript(&pc));
        static_assert(JSOP_SPREADEVAL_LENGTH == JSOP_STRICTSPREADEVAL_LENGTH,
                    "next op after a spread must be at consistent offset");
        static_assert(JSOP_EVAL_LENGTH == JSOP_STRICTEVAL_LENGTH,
                    "next op after a direct eval must be at consistent offset");
        MOZ_ASSERT(JSOp(*pc) == JSOP_EVAL || JSOp(*pc) == JSOP_STRICTEVAL ||
                   JSOp(*pc) == JSOP_SPREADEVAL || JSOp(*pc) == JSOP_STRICTSPREADEVAL);

        bool isSpread = JSOp(*pc) == JSOP_SPREADEVAL || JSOp(*pc) == JSOP_STRICTSPREADEVAL;
        jsbytecode* nextpc = pc + (isSpread ? JSOP_SPREADEVAL_LENGTH : JSOP_EVAL_LENGTH);
        MOZ_ASSERT(*nextpc == JSOP_LINENO);

        *file = maybeScript->filename();
        *linenop = GET_UINT32(nextpc);
        *pcOffset = pc - maybeScript->code();
        *mutedErrors = maybeScript->mutedErrors();
        return;
    }

    NonBuiltinFrameIter iter(cx, cx->compartment()->principals());

    if (iter.done()) {
        maybeScript.set(nullptr);
        *file = nullptr;
        *linenop = 0;
        *pcOffset = 0;
        *mutedErrors = false;
        return;
    }

    *file = iter.filename();
    *linenop = iter.computeLine();
    *mutedErrors = iter.mutedErrors();

    // These values are only used for introducer fields which are debugging
    // information and can be safely left null for wasm frames.
    if (iter.hasScript()) {
        maybeScript.set(iter.script());
        *pcOffset = iter.pc() - maybeScript->code();
    } else {
        maybeScript.set(nullptr);
        *pcOffset = 0;
    }
}

template <class T>
static inline T*
Rebase(JSScript* dst, JSScript* src, T* srcp)
{
    size_t off = reinterpret_cast<uint8_t*>(srcp) - src->data;
    return reinterpret_cast<T*>(dst->data + off);
}

static JSObject*
CloneInnerInterpretedFunction(JSContext* cx, HandleScope enclosingScope, HandleFunction srcFun)
{
    /* NB: Keep this in sync with XDRInterpretedFunction. */
    RootedObject cloneProto(cx);
    if (srcFun->isStarGenerator()) {
        cloneProto = GlobalObject::getOrCreateStarGeneratorFunctionPrototype(cx, cx->global());
        if (!cloneProto)
            return nullptr;
    }

    gc::AllocKind allocKind = srcFun->getAllocKind();
    uint16_t flags = srcFun->flags();
    if (srcFun->isSelfHostedBuiltin()) {
        // Functions in the self-hosting compartment are only extended in
        // debug mode. For top-level functions, FUNCTION_EXTENDED gets used by
        // the cloning algorithm. Do the same for inner functions here.
        allocKind = gc::AllocKind::FUNCTION_EXTENDED;
        flags |= JSFunction::Flags::EXTENDED;
    }
    RootedAtom atom(cx, srcFun->displayAtom());
    RootedFunction clone(cx, NewFunctionWithProto(cx, nullptr, srcFun->nargs(),
                                                  JSFunction::Flags(flags), nullptr, atom,
                                                  cloneProto, allocKind, TenuredObject));
    if (!clone)
        return nullptr;

    JSScript::AutoDelazify srcScript(cx, srcFun);
    if (!srcScript)
        return nullptr;
    JSScript* cloneScript = CloneScriptIntoFunction(cx, enclosingScope, clone, srcScript);
    if (!cloneScript)
        return nullptr;

    if (!JSFunction::setTypeForScriptedFunction(cx, clone))
        return nullptr;

    return clone;
}

bool
js::detail::CopyScript(JSContext* cx, HandleScript src, HandleScript dst,
                       MutableHandle<GCVector<Scope*>> scopes)
{
    if (src->treatAsRunOnce() && !src->functionNonDelazifying()) {
        JS_ReportErrorASCII(cx, "No cloning toplevel run-once scripts");
        return false;
    }

    /* NB: Keep this in sync with XDRScript. */

    /* Some embeddings are not careful to use ExposeObjectToActiveJS as needed. */
    MOZ_ASSERT(!src->sourceObject()->asTenured().isMarked(gc::GRAY));

    uint32_t nconsts   = src->hasConsts()   ? src->consts()->length   : 0;
    uint32_t nobjects  = src->hasObjects()  ? src->objects()->length  : 0;
    uint32_t nscopes   = src->scopes()->length;
    uint32_t ntrynotes = src->hasTrynotes() ? src->trynotes()->length : 0;
    uint32_t nscopenotes = src->hasScopeNotes() ? src->scopeNotes()->length : 0;
    uint32_t nyieldoffsets = src->hasYieldOffsets() ? src->yieldOffsets().length() : 0;

    /* Script data */

    size_t size = src->dataSize();
    ScopedJSFreePtr<uint8_t> data(AllocScriptData(cx->zone(), size));
    if (size && !data) {
        ReportOutOfMemory(cx);
        return false;
    }

    /* Scopes */

    // The passed in scopes vector contains body scopes that needed to be
    // cloned especially, depending on whether the script is a function or
    // global scope. Starting at scopes.length() means we only deal with
    // intra-body scopes.
    {
        MOZ_ASSERT(nscopes != 0);
        MOZ_ASSERT(src->bodyScopeIndex() + 1 == scopes.length());
        GCPtrScope* vector = src->scopes()->vector;
        RootedScope original(cx);
        RootedScope clone(cx);
        for (uint32_t i = scopes.length(); i < nscopes; i++) {
            original = vector[i];
            clone = Scope::clone(cx, original, scopes[FindScopeIndex(src, *original->enclosing())]);
            if (!clone || !scopes.append(clone))
                return false;
        }
    }

    /* Objects */

    AutoObjectVector objects(cx);
    if (nobjects != 0) {
        GCPtrObject* vector = src->objects()->vector;
        RootedObject obj(cx);
        RootedObject clone(cx);
        for (unsigned i = 0; i < nobjects; i++) {
            obj = vector[i];
            clone = nullptr;
            if (obj->is<RegExpObject>()) {
                clone = CloneScriptRegExpObject(cx, obj->as<RegExpObject>());
            } else if (obj->is<JSFunction>()) {
                RootedFunction innerFun(cx, &obj->as<JSFunction>());
                if (innerFun->isNative()) {
                    if (cx->compartment() != innerFun->compartment()) {
                        MOZ_ASSERT(innerFun->isAsmJSNative());
                        JS_ReportErrorASCII(cx, "AsmJS modules do not yet support cloning.");
                        return false;
                    }
                    clone = innerFun;
                } else {
                    if (innerFun->isInterpretedLazy()) {
                        AutoCompartment ac(cx, innerFun);
                        if (!innerFun->getOrCreateScript(cx))
                            return false;
                    }

                    Scope* enclosing = innerFun->nonLazyScript()->enclosingScope();
                    RootedScope enclosingClone(cx, scopes[FindScopeIndex(src, *enclosing)]);
                    clone = CloneInnerInterpretedFunction(cx, enclosingClone, innerFun);
                }
            } else {
                clone = DeepCloneObjectLiteral(cx, obj, TenuredObject);
            }

            if (!clone || !objects.append(clone))
                return false;
        }
    }

    /* This assignment must occur before all the Rebase calls. */
    dst->data = data.forget();
    dst->dataSize_ = size;
    MOZ_ASSERT(bool(dst->data) == bool(src->data));
    if (dst->data)
        memcpy(dst->data, src->data, size);

    /* Script filenames, bytecodes and atoms are runtime-wide. */
    dst->setScriptData(src->scriptData());

    dst->lineno_ = src->lineno();
    dst->mainOffset_ = src->mainOffset();
    dst->nfixed_ = src->nfixed();
    dst->nslots_ = src->nslots();
    dst->bodyScopeIndex_ = src->bodyScopeIndex_;
    dst->funLength_ = src->funLength();
    dst->nTypeSets_ = src->nTypeSets();
    if (src->argumentsHasVarBinding()) {
        dst->setArgumentsHasVarBinding();
        if (src->analyzedArgsUsage())
            dst->setNeedsArgsObj(src->needsArgsObj());
    }
    dst->hasMappedArgsObj_ = src->hasMappedArgsObj();
    dst->functionHasThisBinding_ = src->functionHasThisBinding();
    dst->functionHasExtraBodyVarScope_ = src->functionHasExtraBodyVarScope();
    dst->cloneHasArray(src);
    dst->strict_ = src->strict();
    dst->explicitUseStrict_ = src->explicitUseStrict();
    dst->hasNonSyntacticScope_ = scopes[0]->hasOnChain(ScopeKind::NonSyntactic);
    dst->bindingsAccessedDynamically_ = src->bindingsAccessedDynamically();
    dst->funHasExtensibleScope_ = src->funHasExtensibleScope();
    dst->funHasAnyAliasedFormal_ = src->funHasAnyAliasedFormal();
    dst->hasSingletons_ = src->hasSingletons();
    dst->treatAsRunOnce_ = src->treatAsRunOnce();
    dst->hasInnerFunctions_ = src->hasInnerFunctions();
    dst->isGeneratorExp_ = src->isGeneratorExp();
    dst->setGeneratorKind(src->generatorKind());
    dst->isDerivedClassConstructor_ = src->isDerivedClassConstructor();
    dst->needsHomeObject_ = src->needsHomeObject();
    dst->isDefaultClassConstructor_ = src->isDefaultClassConstructor();
    dst->isAsync_ = src->asyncKind() == AsyncFunction;

    if (nconsts != 0) {
        GCPtrValue* vector = Rebase<GCPtrValue>(dst, src, src->consts()->vector);
        dst->consts()->vector = vector;
        for (unsigned i = 0; i < nconsts; ++i)
            MOZ_ASSERT_IF(vector[i].isMarkable(), vector[i].toString()->isAtom());
    }
    if (nobjects != 0) {
        GCPtrObject* vector = Rebase<GCPtrObject>(dst, src, src->objects()->vector);
        dst->objects()->vector = vector;
        for (unsigned i = 0; i < nobjects; ++i)
            vector[i].init(&objects[i]->as<NativeObject>());
    }
    {
        GCPtrScope* vector = Rebase<GCPtrScope>(dst, src, src->scopes()->vector);
        dst->scopes()->vector = vector;
        for (uint32_t i = 0; i < nscopes; ++i)
            vector[i].init(scopes[i]);
    }
    if (ntrynotes != 0)
        dst->trynotes()->vector = Rebase<JSTryNote>(dst, src, src->trynotes()->vector);
    if (nscopenotes != 0)
        dst->scopeNotes()->vector = Rebase<ScopeNote>(dst, src, src->scopeNotes()->vector);
    if (nyieldoffsets != 0)
        dst->yieldOffsets().vector_ = Rebase<uint32_t>(dst, src, src->yieldOffsets().vector_);

    /*
     * Function delazification assumes that their script does not have a
     * non-syntactic global scope.  We ensure that as follows:
     *
     * 1) Initial parsing only creates lazy functions if
     *    !hasNonSyntacticScope.
     * 2) Cloning a lazy function into a non-global scope will always require
     *    that its script be cloned.  See comments in
     *    CloneFunctionObjectUseSameScript.
     * 3) Cloning a script never sets a lazyScript on the clone, so the function
     *    cannot be relazified.
     *
     * If you decide that lazy functions should be supported with a
     * non-syntactic global scope, make sure delazification can deal.
     */
    MOZ_ASSERT_IF(dst->hasNonSyntacticScope(), !dst->maybeLazyScript());
    MOZ_ASSERT_IF(dst->hasNonSyntacticScope(), !dst->isRelazifiable());
    return true;
}

static JSScript*
CreateEmptyScriptForClone(JSContext* cx, HandleScript src)
{
    /*
     * Wrap the script source object as needed. Self-hosted scripts may be
     * in another runtime, so lazily create a new script source object to
     * use for them.
     */
    RootedObject sourceObject(cx);
    if (cx->runtime()->isSelfHostingCompartment(src->compartment())) {
        if (!cx->compartment()->selfHostingScriptSource) {
            CompileOptions options(cx);
            FillSelfHostingCompileOptions(options);

            ScriptSourceObject* obj = frontend::CreateScriptSourceObject(cx, options);
            if (!obj)
                return nullptr;
            cx->compartment()->selfHostingScriptSource.set(obj);
        }
        sourceObject = cx->compartment()->selfHostingScriptSource;
    } else {
        sourceObject = src->sourceObject();
        if (!cx->compartment()->wrap(cx, &sourceObject))
            return nullptr;
    }

    CompileOptions options(cx);
    options.setMutedErrors(src->mutedErrors())
           .setSelfHostingMode(src->selfHosted())
           .setNoScriptRval(src->noScriptRval())
           .setVersion(src->getVersion());

    return JSScript::Create(cx, options, sourceObject, src->sourceStart(), src->sourceEnd());
}

JSScript*
js::CloneGlobalScript(JSContext* cx, ScopeKind scopeKind, HandleScript src)
{
    MOZ_ASSERT(scopeKind == ScopeKind::Global || scopeKind == ScopeKind::NonSyntactic);

    RootedScript dst(cx, CreateEmptyScriptForClone(cx, src));
    if (!dst)
        return nullptr;

    MOZ_ASSERT(src->bodyScopeIndex() == 0);
    Rooted<GCVector<Scope*>> scopes(cx, GCVector<Scope*>(cx));
    Rooted<GlobalScope*> original(cx, &src->bodyScope()->as<GlobalScope>());
    GlobalScope* clone = GlobalScope::clone(cx, original, scopeKind);
    if (!clone || !scopes.append(clone))
        return nullptr;

    if (!detail::CopyScript(cx, src, dst, &scopes))
        return nullptr;

    return dst;
}

JSScript*
js::CloneScriptIntoFunction(JSContext* cx, HandleScope enclosingScope, HandleFunction fun,
                            HandleScript src)
{
    MOZ_ASSERT(fun->isInterpreted());
    MOZ_ASSERT(!fun->hasScript() || fun->hasUncompiledScript());

    RootedScript dst(cx, CreateEmptyScriptForClone(cx, src));
    if (!dst)
        return nullptr;

    // Clone the non-intra-body scopes.
    Rooted<GCVector<Scope*>> scopes(cx, GCVector<Scope*>(cx));
    RootedScope original(cx);
    RootedScope enclosingClone(cx);
    for (uint32_t i = 0; i <= src->bodyScopeIndex(); i++) {
        original = src->getScope(i);

        if (i == 0) {
            enclosingClone = enclosingScope;
        } else {
            MOZ_ASSERT(src->getScope(i - 1) == original->enclosing());
            enclosingClone = scopes[i - 1];
        }

        Scope* clone;
        if (original->is<FunctionScope>())
            clone = FunctionScope::clone(cx, original.as<FunctionScope>(), fun, enclosingClone);
        else
            clone = Scope::clone(cx, original, enclosingClone);

        if (!clone || !scopes.append(clone))
            return nullptr;
    }

    // Save flags in case we need to undo the early mutations.
    const int preservedFlags = fun->flags();
    if (!detail::CopyScript(cx, src, dst, &scopes)) {
        fun->setFlags(preservedFlags);
        return nullptr;
    }

    // Finally set the script after all the fallible operations.
    if (fun->isInterpretedLazy())
        fun->setUnlazifiedScript(dst);
    else
        fun->initScript(dst);

    return dst;
}

DebugScript*
JSScript::debugScript()
{
    MOZ_ASSERT(hasDebugScript_);
    DebugScriptMap* map = compartment()->debugScriptMap;
    MOZ_ASSERT(map);
    DebugScriptMap::Ptr p = map->lookup(this);
    MOZ_ASSERT(p);
    return p->value();
}

DebugScript*
JSScript::releaseDebugScript()
{
    MOZ_ASSERT(hasDebugScript_);
    DebugScriptMap* map = compartment()->debugScriptMap;
    MOZ_ASSERT(map);
    DebugScriptMap::Ptr p = map->lookup(this);
    MOZ_ASSERT(p);
    DebugScript* debug = p->value();
    map->remove(p);
    hasDebugScript_ = false;
    return debug;
}

void
JSScript::destroyDebugScript(FreeOp* fop)
{
    if (hasDebugScript_) {
#ifdef DEBUG
        for (jsbytecode* pc = code(); pc < codeEnd(); pc++) {
            if (BreakpointSite* site = getBreakpointSite(pc)) {
                /* Breakpoints are swept before finalization. */
                MOZ_ASSERT(site->firstBreakpoint() == nullptr);
                MOZ_ASSERT(getBreakpointSite(pc) == nullptr);
            }
        }
#endif
        fop->free_(releaseDebugScript());
    }
}

bool
JSScript::ensureHasDebugScript(JSContext* cx)
{
    if (hasDebugScript_)
        return true;

    size_t nbytes = offsetof(DebugScript, breakpoints) + length() * sizeof(BreakpointSite*);
    DebugScript* debug = (DebugScript*) zone()->pod_calloc<uint8_t>(nbytes);
    if (!debug)
        return false;

    /* Create compartment's debugScriptMap if necessary. */
    DebugScriptMap* map = compartment()->debugScriptMap;
    if (!map) {
        map = cx->new_<DebugScriptMap>();
        if (!map || !map->init()) {
            js_free(debug);
            js_delete(map);
            return false;
        }
        compartment()->debugScriptMap = map;
    }

    if (!map->putNew(this, debug)) {
        js_free(debug);
        return false;
    }
    hasDebugScript_ = true; // safe to set this;  we can't fail after this point

    /*
     * Ensure that any Interpret() instances running on this script have
     * interrupts enabled. The interrupts must stay enabled until the
     * debug state is destroyed.
     */
    for (ActivationIterator iter(cx->runtime()); !iter.done(); ++iter) {
        if (iter->isInterpreter())
            iter->asInterpreter()->enableInterruptsIfRunning(this);
    }

    return true;
}

void
JSScript::setNewStepMode(FreeOp* fop, uint32_t newValue)
{
    DebugScript* debug = debugScript();
    uint32_t prior = debug->stepMode;
    debug->stepMode = newValue;

    if (!prior != !newValue) {
        if (hasBaselineScript())
            baseline->toggleDebugTraps(this, nullptr);

        if (!stepModeEnabled() && !debug->numSites)
            fop->free_(releaseDebugScript());
    }
}

bool
JSScript::incrementStepModeCount(JSContext* cx)
{
    assertSameCompartment(cx, this);
    MOZ_ASSERT(cx->compartment()->isDebuggee());

    if (!ensureHasDebugScript(cx))
        return false;

    DebugScript* debug = debugScript();
    uint32_t count = debug->stepMode;
    setNewStepMode(cx->runtime()->defaultFreeOp(), count + 1);
    return true;
}

void
JSScript::decrementStepModeCount(FreeOp* fop)
{
    DebugScript* debug = debugScript();
    uint32_t count = debug->stepMode;
    MOZ_ASSERT(count > 0);
    setNewStepMode(fop, count - 1);
}

BreakpointSite*
JSScript::getOrCreateBreakpointSite(JSContext* cx, jsbytecode* pc)
{
    if (!ensureHasDebugScript(cx))
        return nullptr;

    DebugScript* debug = debugScript();
    BreakpointSite*& site = debug->breakpoints[pcToOffset(pc)];

    if (!site) {
        site = cx->runtime()->new_<BreakpointSite>(this, pc);
        if (!site) {
            ReportOutOfMemory(cx);
            return nullptr;
        }
        debug->numSites++;
    }

    return site;
}

void
JSScript::destroyBreakpointSite(FreeOp* fop, jsbytecode* pc)
{
    DebugScript* debug = debugScript();
    BreakpointSite*& site = debug->breakpoints[pcToOffset(pc)];
    MOZ_ASSERT(site);

    fop->delete_(site);
    site = nullptr;

    if (--debug->numSites == 0 && !stepModeEnabled())
        fop->free_(releaseDebugScript());
}

void
JSScript::clearBreakpointsIn(FreeOp* fop, js::Debugger* dbg, JSObject* handler)
{
    if (!hasAnyBreakpointsOrStepMode())
        return;

    for (jsbytecode* pc = code(); pc < codeEnd(); pc++) {
        BreakpointSite* site = getBreakpointSite(pc);
        if (site) {
            Breakpoint* nextbp;
            for (Breakpoint* bp = site->firstBreakpoint(); bp; bp = nextbp) {
                nextbp = bp->nextInSite();
                if ((!dbg || bp->debugger == dbg) && (!handler || bp->getHandler() == handler))
                    bp->destroy(fop);
            }
        }
    }
}

bool
JSScript::hasBreakpointsAt(jsbytecode* pc)
{
    BreakpointSite* site = getBreakpointSite(pc);
    if (!site)
        return false;

    return site->enabledCount > 0;
}

void
SharedScriptData::traceChildren(JSTracer* trc)
{
    MOZ_ASSERT(refCount() != 0);
    for (uint32_t i = 0; i < natoms(); ++i)
        TraceNullableEdge(trc, &atoms()[i], "atom");
}

void
JSScript::traceChildren(JSTracer* trc)
{
    // NOTE: this JSScript may be partially initialized at this point.  E.g. we
    // may have created it and partially initialized it with
    // JSScript::Create(), but not yet finished initializing it with
    // fullyInitFromEmitter() or fullyInitTrivial().

    MOZ_ASSERT_IF(trc->isMarkingTracer() &&
                  static_cast<GCMarker*>(trc)->shouldCheckCompartments(),
                  zone()->isCollecting());

    if (scriptData())
        scriptData()->traceChildren(trc);

    if (ScopeArray* scopearray = scopes())
        TraceRange(trc, scopearray->length, scopearray->vector, "scopes");

    if (hasConsts()) {
        ConstArray* constarray = consts();
        TraceRange(trc, constarray->length, constarray->vector, "consts");
    }

    if (hasObjects()) {
        ObjectArray* objarray = objects();
        TraceRange(trc, objarray->length, objarray->vector, "objects");
    }

    MOZ_ASSERT_IF(sourceObject(), MaybeForwarded(sourceObject())->compartment() == compartment());
    TraceNullableEdge(trc, &sourceObject_, "sourceObject");

    if (maybeLazyScript())
        TraceManuallyBarrieredEdge(trc, &lazyScript, "lazyScript");

    if (trc->isMarkingTracer())
        compartment()->mark();

    jit::TraceJitScripts(trc, this);
}

void
LazyScript::finalize(FreeOp* fop)
{
    fop->free_(table_);
}

size_t
JSScript::calculateLiveFixed(jsbytecode* pc)
{
    size_t nlivefixed = numAlwaysLiveFixedSlots();

    if (nfixed() != nlivefixed) {
        Scope* scope = lookupScope(pc);
        if (scope)
            scope = MaybeForwarded(scope);

        // Find the nearest LexicalScope in the same script.
        while (scope && scope->is<WithScope>()) {
            scope = scope->enclosing();
            if (scope)
                scope = MaybeForwarded(scope);
        }

        if (scope) {
            if (scope->is<LexicalScope>())
                nlivefixed = scope->as<LexicalScope>().nextFrameSlot();
            else if (scope->is<VarScope>())
                nlivefixed = scope->as<VarScope>().nextFrameSlot();
        }
    }

    MOZ_ASSERT(nlivefixed <= nfixed());
    MOZ_ASSERT(nlivefixed >= numAlwaysLiveFixedSlots());

    return nlivefixed;
}

Scope*
JSScript::lookupScope(jsbytecode* pc)
{
    MOZ_ASSERT(containsPC(pc));

    if (!hasScopeNotes())
        return nullptr;

    size_t offset = pc - code();

    ScopeNoteArray* notes = scopeNotes();
    Scope* scope = nullptr;

    // Find the innermost block chain using a binary search.
    size_t bottom = 0;
    size_t top = notes->length;

    while (bottom < top) {
        size_t mid = bottom + (top - bottom) / 2;
        const ScopeNote* note = &notes->vector[mid];
        if (note->start <= offset) {
            // Block scopes are ordered in the list by their starting offset, and since
            // blocks form a tree ones earlier in the list may cover the pc even if
            // later blocks end before the pc. This only happens when the earlier block
            // is a parent of the later block, so we need to check parents of |mid| in
            // the searched range for coverage.
            size_t check = mid;
            while (check >= bottom) {
                const ScopeNote* checkNote = &notes->vector[check];
                MOZ_ASSERT(checkNote->start <= offset);
                if (offset < checkNote->start + checkNote->length) {
                    // We found a matching block chain but there may be inner ones
                    // at a higher block chain index than mid. Continue the binary search.
                    if (checkNote->index == ScopeNote::NoScopeIndex)
                        scope = nullptr;
                    else
                        scope = getScope(checkNote->index);
                    break;
                }
                if (checkNote->parent == UINT32_MAX)
                    break;
                check = checkNote->parent;
            }
            bottom = mid + 1;
        } else {
            top = mid;
        }
    }

    return scope;
}

Scope*
JSScript::innermostScope(jsbytecode* pc)
{
    if (Scope* scope = lookupScope(pc))
        return scope;
    return bodyScope();
}

void
JSScript::setArgumentsHasVarBinding()
{
    argsHasVarBinding_ = true;
    needsArgsAnalysis_ = true;
}

void
JSScript::setNeedsArgsObj(bool needsArgsObj)
{
    MOZ_ASSERT_IF(needsArgsObj, argumentsHasVarBinding());
    needsArgsAnalysis_ = false;
    needsArgsObj_ = needsArgsObj;
}

void
js::SetFrameArgumentsObject(JSContext* cx, AbstractFramePtr frame,
                            HandleScript script, JSObject* argsobj)
{
    /*
     * Replace any optimized arguments in the frame with an explicit arguments
     * object. Note that 'arguments' may have already been overwritten.
     */

    Rooted<BindingIter> bi(cx, BindingIter(script));
    while (bi && bi.name() != cx->names().arguments)
        bi++;
    if (!bi)
        return;

    if (bi.location().kind() == BindingLocation::Kind::Environment) {
        /*
         * Scan the script to find the slot in the call object that 'arguments'
         * is assigned to.
         */
        jsbytecode* pc = script->code();
        while (*pc != JSOP_ARGUMENTS)
            pc += GetBytecodeLength(pc);
        pc += JSOP_ARGUMENTS_LENGTH;
        MOZ_ASSERT(*pc == JSOP_SETALIASEDVAR);

        // Note that here and below, it is insufficient to only check for
        // JS_OPTIMIZED_ARGUMENTS, as Ion could have optimized out the
        // arguments slot.
        EnvironmentObject& env = frame.callObj().as<EnvironmentObject>();
        if (IsOptimizedPlaceholderMagicValue(env.aliasedBinding(bi)))
            env.setAliasedBinding(cx, bi, ObjectValue(*argsobj));
    } else {
        MOZ_ASSERT(bi.location().kind() == BindingLocation::Kind::Frame);
        uint32_t frameSlot = bi.location().slot();
        if (IsOptimizedPlaceholderMagicValue(frame.unaliasedLocal(frameSlot)))
            frame.unaliasedLocal(frameSlot) = ObjectValue(*argsobj);
    }
}

/* static */ bool
JSScript::argumentsOptimizationFailed(JSContext* cx, HandleScript script)
{
    MOZ_ASSERT(script->functionNonDelazifying());
    MOZ_ASSERT(script->analyzedArgsUsage());
    MOZ_ASSERT(script->argumentsHasVarBinding());

    /*
     * It is possible that the arguments optimization has already failed,
     * everything has been fixed up, but there was an outstanding magic value
     * on the stack that has just now flowed into an apply. In this case, there
     * is nothing to do; GuardFunApplySpeculation will patch in the real
     * argsobj.
     */
    if (script->needsArgsObj())
        return true;

    MOZ_ASSERT(!script->isGenerator());

    script->needsArgsObj_ = true;

    /*
     * Since we can't invalidate baseline scripts, set a flag that's checked from
     * JIT code to indicate the arguments optimization failed and JSOP_ARGUMENTS
     * should create an arguments object next time.
     */
    if (script->hasBaselineScript())
        script->baselineScript()->setNeedsArgsObj();

    /*
     * By design, the arguments optimization is only made when there are no
     * outstanding cases of MagicValue(JS_OPTIMIZED_ARGUMENTS) at any points
     * where the optimization could fail, other than an active invocation of
     * 'f.apply(x, arguments)'. Thus, there are no outstanding values of
     * MagicValue(JS_OPTIMIZED_ARGUMENTS) on the stack. However, there are
     * three things that need fixup:
     *  - there may be any number of activations of this script that don't have
     *    an argsObj that now need one.
     *  - jit code compiled (and possible active on the stack) with the static
     *    assumption of !script->needsArgsObj();
     *  - type inference data for the script assuming script->needsArgsObj
     */
    for (AllScriptFramesIter i(cx); !i.done(); ++i) {
        /*
         * We cannot reliably create an arguments object for Ion activations of
         * this script.  To maintain the invariant that "script->needsArgsObj
         * implies fp->hasArgsObj", the Ion bail mechanism will create an
         * arguments object right after restoring the BaselineFrame and before
         * entering Baseline code (in jit::FinishBailoutToBaseline).
         */
        if (i.isIon())
            continue;
        AbstractFramePtr frame = i.abstractFramePtr();
        if (frame.isFunctionFrame() && frame.script() == script) {
            /* We crash on OOM since cleaning up here would be complicated. */
            AutoEnterOOMUnsafeRegion oomUnsafe;
            ArgumentsObject* argsobj = ArgumentsObject::createExpected(cx, frame);
            if (!argsobj)
                oomUnsafe.crash("JSScript::argumentsOptimizationFailed");
            SetFrameArgumentsObject(cx, frame, script, argsobj);
        }
    }

    return true;
}

bool
JSScript::formalIsAliased(unsigned argSlot)
{
    if (functionHasParameterExprs())
        return false;

    for (PositionalFormalParameterIter fi(this); fi; fi++) {
        if (fi.argumentSlot() == argSlot)
            return fi.closedOver();
    }
    MOZ_CRASH("Argument slot not found");
}

bool
JSScript::formalLivesInArgumentsObject(unsigned argSlot)
{
    return argsObjAliasesFormals() && !formalIsAliased(argSlot);
}

LazyScript::LazyScript(JSFunction* fun, void* table, uint64_t packedFields,
                       uint32_t begin, uint32_t end, uint32_t lineno, uint32_t column)
  : script_(nullptr),
    function_(fun),
    enclosingScope_(nullptr),
    sourceObject_(nullptr),
    table_(table),
    packedFields_(packedFields),
    begin_(begin),
    end_(end),
    lineno_(lineno),
    column_(column)
{
    MOZ_ASSERT(begin <= end);
}

void
LazyScript::initScript(JSScript* script)
{
    MOZ_ASSERT(script);
    MOZ_ASSERT(!script_.unbarrieredGet());
    script_.set(script);
}

void
LazyScript::resetScript()
{
    MOZ_ASSERT(script_.unbarrieredGet());
    script_.set(nullptr);
}

void
LazyScript::setEnclosingScopeAndSource(Scope* enclosingScope, ScriptSourceObject* sourceObject)
{
    MOZ_ASSERT(function_->compartment() == sourceObject->compartment());
    // This method may be called to update the enclosing scope. See comment
    // above the callsite in BytecodeEmitter::emitFunction.
    MOZ_ASSERT_IF(sourceObject_, sourceObject_ == sourceObject && enclosingScope_);
    MOZ_ASSERT_IF(!sourceObject_, !enclosingScope_);

    enclosingScope_ = enclosingScope;
    sourceObject_ = sourceObject;
}

ScriptSourceObject*
LazyScript::sourceObject() const
{
    return sourceObject_ ? &sourceObject_->as<ScriptSourceObject>() : nullptr;
}

ScriptSource*
LazyScript::maybeForwardedScriptSource() const
{
    return UncheckedUnwrap(MaybeForwarded(sourceObject()))->as<ScriptSourceObject>().source();
}

/* static */ LazyScript*
LazyScript::CreateRaw(ExclusiveContext* cx, HandleFunction fun,
                      uint64_t packedFields, uint32_t begin, uint32_t end,
                      uint32_t lineno, uint32_t column)
{
    union {
        PackedView p;
        uint64_t packed;
    };

    packed = packedFields;

    // Reset runtime flags to obtain a fresh LazyScript.
    p.hasBeenCloned = false;
    p.treatAsRunOnce = false;

    size_t bytes = (p.numClosedOverBindings * sizeof(JSAtom*))
                 + (p.numInnerFunctions * sizeof(GCPtrFunction));

    ScopedJSFreePtr<uint8_t> table(bytes ? fun->zone()->pod_malloc<uint8_t>(bytes) : nullptr);
    if (bytes && !table) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    LazyScript* res = Allocate<LazyScript>(cx);
    if (!res)
        return nullptr;

    cx->compartment()->scheduleDelazificationForDebugger();

    return new (res) LazyScript(fun, table.forget(), packed, begin, end, lineno, column);
}

/* static */ LazyScript*
LazyScript::Create(ExclusiveContext* cx, HandleFunction fun,
                   const frontend::AtomVector& closedOverBindings,
                   Handle<GCVector<JSFunction*, 8>> innerFunctions,
                   JSVersion version,
                   uint32_t begin, uint32_t end, uint32_t lineno, uint32_t column)
{
    union {
        PackedView p;
        uint64_t packedFields;
    };

    p.version = version;
    p.shouldDeclareArguments = false;
    p.hasThisBinding = false;
    p.isAsync = false;
    p.numClosedOverBindings = closedOverBindings.length();
    p.numInnerFunctions = innerFunctions.length();
    p.generatorKindBits = GeneratorKindAsBits(NotGenerator);
    p.strict = false;
    p.bindingsAccessedDynamically = false;
    p.hasDebuggerStatement = false;
    p.hasDirectEval = false;
    p.isLikelyConstructorWrapper = false;
    p.isDerivedClassConstructor = false;
    p.needsHomeObject = false;

    LazyScript* res = LazyScript::CreateRaw(cx, fun, packedFields, begin, end, lineno, column);
    if (!res)
        return nullptr;

    JSAtom** resClosedOverBindings = res->closedOverBindings();
    for (size_t i = 0; i < res->numClosedOverBindings(); i++)
        resClosedOverBindings[i] = closedOverBindings[i];

    GCPtrFunction* resInnerFunctions = res->innerFunctions();
    for (size_t i = 0; i < res->numInnerFunctions(); i++)
        resInnerFunctions[i].init(innerFunctions[i]);

    MOZ_ASSERT_IF(res, res->version() == version);
    return res;
}

/* static */ LazyScript*
LazyScript::Create(ExclusiveContext* cx, HandleFunction fun,
                   HandleScript script, HandleScope enclosingScope,
                   HandleScript enclosingScript,
                   uint64_t packedFields, uint32_t begin, uint32_t end,
                   uint32_t lineno, uint32_t column)
{
    // Dummy atom which is not a valid property name.
    RootedAtom dummyAtom(cx, cx->names().comma);

    // Dummy function which is not a valid function as this is the one which is
    // holding this lazy script.
    HandleFunction dummyFun = fun;

    LazyScript* res = LazyScript::CreateRaw(cx, fun, packedFields, begin, end, lineno, column);
    if (!res)
        return nullptr;

    // Fill with dummies, to be GC-safe after the initialization of the free
    // variables and inner functions.
    size_t i, num;
    JSAtom** closedOverBindings = res->closedOverBindings();
    for (i = 0, num = res->numClosedOverBindings(); i < num; i++)
        closedOverBindings[i] = dummyAtom;

    GCPtrFunction* functions = res->innerFunctions();
    for (i = 0, num = res->numInnerFunctions(); i < num; i++)
        functions[i].init(dummyFun);

    // Set the enclosing scope and source object of the lazy function. These
    // values should only be non-null if we have a non-lazy enclosing script.
    // AddLazyFunctionsForCompartment relies on the source object being null
    // if we're nested inside another lazy function.
    MOZ_ASSERT(!!enclosingScript == !!enclosingScope);
    MOZ_ASSERT(!res->sourceObject());
    MOZ_ASSERT(!res->enclosingScope());
    if (enclosingScript)
        res->setEnclosingScopeAndSource(enclosingScope, &enclosingScript->scriptSourceUnwrap());

    MOZ_ASSERT(!res->hasScript());
    if (script)
        res->initScript(script);

    return res;
}

void
LazyScript::initRuntimeFields(uint64_t packedFields)
{
    union {
        PackedView p;
        uint64_t packed;
    };

    packed = packedFields;
    p_.hasBeenCloned = p.hasBeenCloned;
    p_.treatAsRunOnce = p.treatAsRunOnce;
}

bool
LazyScript::hasUncompiledEnclosingScript() const
{
    // It can happen that we created lazy scripts while compiling an enclosing
    // script, but we errored out while compiling that script. When we iterate
    // over lazy script in a compartment, we might see lazy scripts that never
    // escaped to script and should be ignored.
    //
    // If the enclosing scope is a function with a null script or has a script
    // without code, it was not successfully compiled.

    if (!enclosingScope() || !enclosingScope()->is<FunctionScope>())
        return false;

    JSFunction* fun = enclosingScope()->as<FunctionScope>().canonicalFunction();
    return !fun->hasScript() || fun->hasUncompiledScript() || !fun->nonLazyScript()->code();
}

void
JSScript::updateBaselineOrIonRaw(JSRuntime* maybeRuntime)
{
    if (hasBaselineScript() && baseline->hasPendingIonBuilder()) {
        MOZ_ASSERT(maybeRuntime);
        MOZ_ASSERT(!isIonCompilingOffThread());
        baselineOrIonRaw = maybeRuntime->jitRuntime()->lazyLinkStub()->raw();
        baselineOrIonSkipArgCheck = maybeRuntime->jitRuntime()->lazyLinkStub()->raw();
    } else if (hasIonScript()) {
        baselineOrIonRaw = ion->method()->raw();
        baselineOrIonSkipArgCheck = ion->method()->raw() + ion->getSkipArgCheckEntryOffset();
    } else if (hasBaselineScript()) {
        baselineOrIonRaw = baseline->method()->raw();
        baselineOrIonSkipArgCheck = baseline->method()->raw();
    } else {
        baselineOrIonRaw = nullptr;
        baselineOrIonSkipArgCheck = nullptr;
    }
}

bool
JSScript::hasLoops()
{
    if (!hasTrynotes())
        return false;
    JSTryNote* tn = trynotes()->vector;
    JSTryNote* tnlimit = tn + trynotes()->length;
    for (; tn < tnlimit; tn++) {
        if (tn->kind == JSTRY_FOR_IN || tn->kind == JSTRY_LOOP)
            return true;
    }
    return false;
}

bool
JSScript::mayReadFrameArgsDirectly()
{
    return argumentsHasVarBinding() || (function() && function()->hasRest());
}

static inline void
LazyScriptHash(uint32_t lineno, uint32_t column, uint32_t begin, uint32_t end,
               HashNumber hashes[3])
{
    HashNumber hash = lineno;
    hash = RotateLeft(hash, 4) ^ column;
    hash = RotateLeft(hash, 4) ^ begin;
    hash = RotateLeft(hash, 4) ^ end;

    hashes[0] = hash;
    hashes[1] = RotateLeft(hashes[0], 4) ^ begin;
    hashes[2] = RotateLeft(hashes[1], 4) ^ end;
}

void
LazyScriptHashPolicy::hash(const Lookup& lookup, HashNumber hashes[3])
{
    LazyScript* lazy = lookup.lazy;
    LazyScriptHash(lazy->lineno(), lazy->column(), lazy->begin(), lazy->end(), hashes);
}

void
LazyScriptHashPolicy::hash(JSScript* script, HashNumber hashes[3])
{
    LazyScriptHash(script->lineno(), script->column(), script->sourceStart(), script->sourceEnd(), hashes);
}

bool
LazyScriptHashPolicy::match(JSScript* script, const Lookup& lookup)
{
    JSContext* cx = lookup.cx;
    LazyScript* lazy = lookup.lazy;

    // To be a match, the script and lazy script need to have the same line
    // and column and to be at the same position within their respective
    // source blobs, and to have the same source contents and version.
    //
    // While the surrounding code in the source may differ, this is
    // sufficient to ensure that compiling the lazy script will yield an
    // identical result to compiling the original script.
    //
    // Note that the filenames and origin principals of the lazy script and
    // original script can differ. If there is a match, these will be fixed
    // up in the resulting clone by the caller.

    if (script->lineno() != lazy->lineno() ||
        script->column() != lazy->column() ||
        script->getVersion() != lazy->version() ||
        script->sourceStart() != lazy->begin() ||
        script->sourceEnd() != lazy->end())
    {
        return false;
    }

    UncompressedSourceCache::AutoHoldEntry holder;

    size_t scriptBegin = script->sourceStart();
    size_t length = script->sourceEnd() - scriptBegin;
    const char16_t* scriptChars = script->scriptSource()->chars(cx, holder, scriptBegin, length);
    if (!scriptChars)
        return false;

    MOZ_ASSERT(scriptBegin == lazy->begin());
    const char16_t* lazyChars = lazy->scriptSource()->chars(cx, holder, scriptBegin, length);
    if (!lazyChars)
        return false;

    return !memcmp(scriptChars, lazyChars, length);
}

void
JSScript::AutoDelazify::holdScript(JS::HandleFunction fun)
{
    if (fun) {
        if (fun->compartment()->isSelfHosting) {
            // The self-hosting compartment is shared across runtimes, so we
            // can't use JSAutoCompartment: it could cause races. Functions in
            // the self-hosting compartment will never be lazy, so we can safely
            // assume we don't have to delazify.
            script_ = fun->nonLazyScript();
        } else {
            JSAutoCompartment ac(cx_, fun);
            script_ = fun->getOrCreateScript(cx_);
            if (script_) {
                oldDoNotRelazify_ = script_->doNotRelazify_;
                script_->setDoNotRelazify(true);
            }
        }
    }
}

void
JSScript::AutoDelazify::dropScript()
{
    // Don't touch script_ if it's in the self-hosting compartment, see the
    // comment in holdScript.
    if (script_ && !script_->compartment()->isSelfHosting)
        script_->setDoNotRelazify(oldDoNotRelazify_);
    script_ = nullptr;
}

JS::ubi::Node::Size
JS::ubi::Concrete<JSScript>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    Size size = Arena::thingSize(get().asTenured().getAllocKind());

    size += get().sizeOfData(mallocSizeOf);
    size += get().sizeOfTypeScript(mallocSizeOf);

    size_t baselineSize = 0;
    size_t baselineStubsSize = 0;
    jit::AddSizeOfBaselineData(&get(), mallocSizeOf, &baselineSize, &baselineStubsSize);
    size += baselineSize;
    size += baselineStubsSize;

    size += jit::SizeOfIonData(&get(), mallocSizeOf);

    MOZ_ASSERT(size > 0);
    return size;
}

const char*
JS::ubi::Concrete<JSScript>::scriptFilename() const
{
    return get().filename();
}

JS::ubi::Node::Size
JS::ubi::Concrete<js::LazyScript>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    Size size = js::gc::Arena::thingSize(get().asTenured().getAllocKind());
    size += get().sizeOfExcludingThis(mallocSizeOf);
    return size;
}

const char*
JS::ubi::Concrete<js::LazyScript>::scriptFilename() const
{
    auto sourceObject = get().sourceObject();
    if (!sourceObject)
        return nullptr;

    auto source = sourceObject->source();
    if (!source)
        return nullptr;

    return source->filename();
}
