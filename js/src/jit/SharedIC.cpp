/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/SharedIC.h"

#include "mozilla/Casting.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/SizePrintfMacros.h"
#include "mozilla/Sprintf.h"

#include "jslibmath.h"
#include "jstypes.h"

#include "gc/Policy.h"
#include "jit/BaselineCacheIR.h"
#include "jit/BaselineDebugModeOSR.h"
#include "jit/BaselineIC.h"
#include "jit/JitSpewer.h"
#include "jit/Linker.h"
#include "jit/SharedICHelpers.h"
#ifdef JS_ION_PERF
# include "jit/PerfSpewer.h"
#endif
#include "jit/VMFunctions.h"
#include "vm/Interpreter.h"

#include "jit/MacroAssembler-inl.h"
#include "vm/Interpreter-inl.h"

using mozilla::BitwiseCast;
using mozilla::DebugOnly;

namespace js {
namespace jit {

#ifdef JS_JITSPEW
void
FallbackICSpew(JSContext* cx, ICFallbackStub* stub, const char* fmt, ...)
{
    if (JitSpewEnabled(JitSpew_BaselineICFallback)) {
        RootedScript script(cx, GetTopJitJSScript(cx));
        jsbytecode* pc = stub->icEntry()->pc(script);

        char fmtbuf[100];
        va_list args;
        va_start(args, fmt);
        (void) VsprintfLiteral(fmtbuf, fmt, args);
        va_end(args);

        JitSpew(JitSpew_BaselineICFallback,
                "Fallback hit for (%s:%" PRIuSIZE ") (pc=%" PRIuSIZE ",line=%d,uses=%d,stubs=%" PRIuSIZE "): %s",
                script->filename(),
                script->lineno(),
                script->pcToOffset(pc),
                PCToLineNumber(script, pc),
                script->getWarmUpCount(),
                stub->numOptimizedStubs(),
                fmtbuf);
    }
}

void
TypeFallbackICSpew(JSContext* cx, ICTypeMonitor_Fallback* stub, const char* fmt, ...)
{
    if (JitSpewEnabled(JitSpew_BaselineICFallback)) {
        RootedScript script(cx, GetTopJitJSScript(cx));
        jsbytecode* pc = stub->icEntry()->pc(script);

        char fmtbuf[100];
        va_list args;
        va_start(args, fmt);
        (void) VsprintfLiteral(fmtbuf, fmt, args);
        va_end(args);

        JitSpew(JitSpew_BaselineICFallback,
                "Type monitor fallback hit for (%s:%" PRIuSIZE ") (pc=%" PRIuSIZE ",line=%d,uses=%d,stubs=%d): %s",
                script->filename(),
                script->lineno(),
                script->pcToOffset(pc),
                PCToLineNumber(script, pc),
                script->getWarmUpCount(),
                (int) stub->numOptimizedMonitorStubs(),
                fmtbuf);
    }
}
#endif // JS_JITSPEW

ICFallbackStub*
ICEntry::fallbackStub() const
{
    return firstStub()->getChainFallback();
}

void
IonICEntry::trace(JSTracer* trc)
{
    TraceManuallyBarrieredEdge(trc, &script_, "IonICEntry::script_");
    traceEntry(trc);
}

void
BaselineICEntry::trace(JSTracer* trc)
{
    traceEntry(trc);
}

void
ICEntry::traceEntry(JSTracer* trc)
{
    if (!hasStub())
        return;
    for (ICStub* stub = firstStub(); stub; stub = stub->next())
        stub->trace(trc);
}

ICStubConstIterator&
ICStubConstIterator::operator++()
{
    MOZ_ASSERT(currentStub_ != nullptr);
    currentStub_ = currentStub_->next();
    return *this;
}


ICStubIterator::ICStubIterator(ICFallbackStub* fallbackStub, bool end)
  : icEntry_(fallbackStub->icEntry()),
    fallbackStub_(fallbackStub),
    previousStub_(nullptr),
    currentStub_(end ? fallbackStub : icEntry_->firstStub()),
    unlinked_(false)
{ }

ICStubIterator&
ICStubIterator::operator++()
{
    MOZ_ASSERT(currentStub_->next() != nullptr);
    if (!unlinked_)
        previousStub_ = currentStub_;
    currentStub_ = currentStub_->next();
    unlinked_ = false;
    return *this;
}

void
ICStubIterator::unlink(JSContext* cx)
{
    MOZ_ASSERT(currentStub_->next() != nullptr);
    MOZ_ASSERT(currentStub_ != fallbackStub_);
    MOZ_ASSERT(!unlinked_);

    fallbackStub_->unlinkStub(cx->zone(), previousStub_, currentStub_);

    // Mark the current iterator position as unlinked, so operator++ works properly.
    unlinked_ = true;
}


void
ICStub::markCode(JSTracer* trc, const char* name)
{
    JitCode* stubJitCode = jitCode();
    TraceManuallyBarrieredEdge(trc, &stubJitCode, name);
}

void
ICStub::updateCode(JitCode* code)
{
    // Write barrier on the old code.
    JitCode::writeBarrierPre(jitCode());
    stubCode_ = code->raw();
}

/* static */ void
ICStub::trace(JSTracer* trc)
{
    markCode(trc, "shared-stub-jitcode");

    // If the stub is a monitored fallback stub, then mark the monitor ICs hanging
    // off of that stub.  We don't need to worry about the regular monitored stubs,
    // because the regular monitored stubs will always have a monitored fallback stub
    // that references the same stub chain.
    if (isMonitoredFallback()) {
        ICTypeMonitor_Fallback* lastMonStub = toMonitoredFallbackStub()->fallbackMonitorStub();
        for (ICStubConstIterator iter(lastMonStub->firstMonitorStub()); !iter.atEnd(); iter++) {
            MOZ_ASSERT_IF(iter->next() == nullptr, *iter == lastMonStub);
            iter->trace(trc);
        }
    }

    if (isUpdated()) {
        for (ICStubConstIterator iter(toUpdatedStub()->firstUpdateStub()); !iter.atEnd(); iter++) {
            MOZ_ASSERT_IF(iter->next() == nullptr, iter->isTypeUpdate_Fallback());
            iter->trace(trc);
        }
    }

    switch (kind()) {
      case ICStub::Call_Scripted: {
        ICCall_Scripted* callStub = toCall_Scripted();
        TraceEdge(trc, &callStub->callee(), "baseline-callscripted-callee");
        TraceNullableEdge(trc, &callStub->templateObject(), "baseline-callscripted-template");
        break;
      }
      case ICStub::Call_Native: {
        ICCall_Native* callStub = toCall_Native();
        TraceEdge(trc, &callStub->callee(), "baseline-callnative-callee");
        TraceNullableEdge(trc, &callStub->templateObject(), "baseline-callnative-template");
        break;
      }
      case ICStub::Call_ClassHook: {
        ICCall_ClassHook* callStub = toCall_ClassHook();
        TraceNullableEdge(trc, &callStub->templateObject(), "baseline-callclasshook-template");
        break;
      }
      case ICStub::Call_StringSplit: {
        ICCall_StringSplit* callStub = toCall_StringSplit();
        TraceEdge(trc, &callStub->templateObject(), "baseline-callstringsplit-template");
        TraceEdge(trc, &callStub->expectedSep(), "baseline-callstringsplit-sep");
        TraceEdge(trc, &callStub->expectedStr(), "baseline-callstringsplit-str");
        break;
      }
      case ICStub::GetElem_NativeSlotName:
      case ICStub::GetElem_NativeSlotSymbol:
      case ICStub::GetElem_UnboxedPropertyName: {
        ICGetElemNativeStub* getElemStub = static_cast<ICGetElemNativeStub*>(this);
        getElemStub->receiverGuard().trace(trc);
        if (getElemStub->isSymbol()) {
            ICGetElem_NativeSlot<JS::Symbol*>* typedGetElemStub = toGetElem_NativeSlotSymbol();
            TraceEdge(trc, &typedGetElemStub->key(), "baseline-getelem-native-key");
        } else {
            ICGetElemNativeSlotStub<PropertyName*>* typedGetElemStub =
                reinterpret_cast<ICGetElemNativeSlotStub<PropertyName*>*>(this);
            TraceEdge(trc, &typedGetElemStub->key(), "baseline-getelem-native-key");
        }
        break;
      }
      case ICStub::GetElem_NativePrototypeSlotName:
      case ICStub::GetElem_NativePrototypeSlotSymbol: {
        ICGetElemNativeStub* getElemStub = static_cast<ICGetElemNativeStub*>(this);
        getElemStub->receiverGuard().trace(trc);
        if (getElemStub->isSymbol()) {
            ICGetElem_NativePrototypeSlot<JS::Symbol*>* typedGetElemStub
                = toGetElem_NativePrototypeSlotSymbol();
            TraceEdge(trc, &typedGetElemStub->key(), "baseline-getelem-nativeproto-key");
            TraceEdge(trc, &typedGetElemStub->holder(), "baseline-getelem-nativeproto-holder");
            TraceEdge(trc, &typedGetElemStub->holderShape(), "baseline-getelem-nativeproto-holdershape");
        } else {
            ICGetElem_NativePrototypeSlot<PropertyName*>* typedGetElemStub
                = toGetElem_NativePrototypeSlotName();
            TraceEdge(trc, &typedGetElemStub->key(), "baseline-getelem-nativeproto-key");
            TraceEdge(trc, &typedGetElemStub->holder(), "baseline-getelem-nativeproto-holder");
            TraceEdge(trc, &typedGetElemStub->holderShape(), "baseline-getelem-nativeproto-holdershape");
        }
        break;
      }
      case ICStub::GetElem_NativePrototypeCallNativeName:
      case ICStub::GetElem_NativePrototypeCallNativeSymbol:
      case ICStub::GetElem_NativePrototypeCallScriptedName:
      case ICStub::GetElem_NativePrototypeCallScriptedSymbol: {
        ICGetElemNativeStub* getElemStub = static_cast<ICGetElemNativeStub*>(this);
        getElemStub->receiverGuard().trace(trc);
        if (getElemStub->isSymbol()) {
            ICGetElemNativePrototypeCallStub<JS::Symbol*>* callStub =
                reinterpret_cast<ICGetElemNativePrototypeCallStub<JS::Symbol*>*>(this);
            TraceEdge(trc, &callStub->key(), "baseline-getelem-nativeprotocall-key");
            TraceEdge(trc, &callStub->getter(), "baseline-getelem-nativeprotocall-getter");
            TraceEdge(trc, &callStub->holder(), "baseline-getelem-nativeprotocall-holder");
            TraceEdge(trc, &callStub->holderShape(), "baseline-getelem-nativeprotocall-holdershape");
        } else {
            ICGetElemNativePrototypeCallStub<PropertyName*>* callStub =
                reinterpret_cast<ICGetElemNativePrototypeCallStub<PropertyName*>*>(this);
            TraceEdge(trc, &callStub->key(), "baseline-getelem-nativeprotocall-key");
            TraceEdge(trc, &callStub->getter(), "baseline-getelem-nativeprotocall-getter");
            TraceEdge(trc, &callStub->holder(), "baseline-getelem-nativeprotocall-holder");
            TraceEdge(trc, &callStub->holderShape(), "baseline-getelem-nativeprotocall-holdershape");
        }
        break;
      }
      case ICStub::GetElem_Dense: {
        ICGetElem_Dense* getElemStub = toGetElem_Dense();
        TraceEdge(trc, &getElemStub->shape(), "baseline-getelem-dense-shape");
        break;
      }
      case ICStub::GetElem_UnboxedArray: {
        ICGetElem_UnboxedArray* getElemStub = toGetElem_UnboxedArray();
        TraceEdge(trc, &getElemStub->group(), "baseline-getelem-unboxed-array-group");
        break;
      }
      case ICStub::GetElem_TypedArray: {
        ICGetElem_TypedArray* getElemStub = toGetElem_TypedArray();
        TraceEdge(trc, &getElemStub->shape(), "baseline-getelem-typedarray-shape");
        break;
      }
      case ICStub::SetElem_DenseOrUnboxedArray: {
        ICSetElem_DenseOrUnboxedArray* setElemStub = toSetElem_DenseOrUnboxedArray();
        TraceNullableEdge(trc, &setElemStub->shape(), "baseline-getelem-dense-shape");
        TraceEdge(trc, &setElemStub->group(), "baseline-setelem-dense-group");
        break;
      }
      case ICStub::SetElem_DenseOrUnboxedArrayAdd: {
        ICSetElem_DenseOrUnboxedArrayAdd* setElemStub = toSetElem_DenseOrUnboxedArrayAdd();
        TraceEdge(trc, &setElemStub->group(), "baseline-setelem-denseadd-group");

        JS_STATIC_ASSERT(ICSetElem_DenseOrUnboxedArrayAdd::MAX_PROTO_CHAIN_DEPTH == 4);

        switch (setElemStub->protoChainDepth()) {
          case 0: setElemStub->toImpl<0>()->traceShapes(trc); break;
          case 1: setElemStub->toImpl<1>()->traceShapes(trc); break;
          case 2: setElemStub->toImpl<2>()->traceShapes(trc); break;
          case 3: setElemStub->toImpl<3>()->traceShapes(trc); break;
          case 4: setElemStub->toImpl<4>()->traceShapes(trc); break;
          default: MOZ_CRASH("Invalid proto stub.");
        }
        break;
      }
      case ICStub::SetElem_TypedArray: {
        ICSetElem_TypedArray* setElemStub = toSetElem_TypedArray();
        TraceEdge(trc, &setElemStub->shape(), "baseline-setelem-typedarray-shape");
        break;
      }
      case ICStub::TypeMonitor_SingleObject: {
        ICTypeMonitor_SingleObject* monitorStub = toTypeMonitor_SingleObject();
        TraceEdge(trc, &monitorStub->object(), "baseline-monitor-singleton");
        break;
      }
      case ICStub::TypeMonitor_ObjectGroup: {
        ICTypeMonitor_ObjectGroup* monitorStub = toTypeMonitor_ObjectGroup();
        TraceEdge(trc, &monitorStub->group(), "baseline-monitor-group");
        break;
      }
      case ICStub::TypeUpdate_SingleObject: {
        ICTypeUpdate_SingleObject* updateStub = toTypeUpdate_SingleObject();
        TraceEdge(trc, &updateStub->object(), "baseline-update-singleton");
        break;
      }
      case ICStub::TypeUpdate_ObjectGroup: {
        ICTypeUpdate_ObjectGroup* updateStub = toTypeUpdate_ObjectGroup();
        TraceEdge(trc, &updateStub->group(), "baseline-update-group");
        break;
      }
      case ICStub::In_Native: {
        ICIn_Native* inStub = toIn_Native();
        TraceEdge(trc, &inStub->shape(), "baseline-innative-stub-shape");
        TraceEdge(trc, &inStub->name(), "baseline-innative-stub-name");
        break;
      }
      case ICStub::In_NativePrototype: {
        ICIn_NativePrototype* inStub = toIn_NativePrototype();
        TraceEdge(trc, &inStub->shape(), "baseline-innativeproto-stub-shape");
        TraceEdge(trc, &inStub->name(), "baseline-innativeproto-stub-name");
        TraceEdge(trc, &inStub->holder(), "baseline-innativeproto-stub-holder");
        TraceEdge(trc, &inStub->holderShape(), "baseline-innativeproto-stub-holdershape");
        break;
      }
      case ICStub::In_NativeDoesNotExist: {
        ICIn_NativeDoesNotExist* inStub = toIn_NativeDoesNotExist();
        TraceEdge(trc, &inStub->name(), "baseline-innativedoesnotexist-stub-name");
        JS_STATIC_ASSERT(ICIn_NativeDoesNotExist::MAX_PROTO_CHAIN_DEPTH == 8);
        switch (inStub->protoChainDepth()) {
          case 0: inStub->toImpl<0>()->traceShapes(trc); break;
          case 1: inStub->toImpl<1>()->traceShapes(trc); break;
          case 2: inStub->toImpl<2>()->traceShapes(trc); break;
          case 3: inStub->toImpl<3>()->traceShapes(trc); break;
          case 4: inStub->toImpl<4>()->traceShapes(trc); break;
          case 5: inStub->toImpl<5>()->traceShapes(trc); break;
          case 6: inStub->toImpl<6>()->traceShapes(trc); break;
          case 7: inStub->toImpl<7>()->traceShapes(trc); break;
          case 8: inStub->toImpl<8>()->traceShapes(trc); break;
          default: MOZ_CRASH("Invalid proto stub.");
        }
        break;
      }
      case ICStub::In_Dense: {
        ICIn_Dense* inStub = toIn_Dense();
        TraceEdge(trc, &inStub->shape(), "baseline-in-dense-shape");
        break;
      }
      case ICStub::GetName_Global: {
        ICGetName_Global* globalStub = toGetName_Global();
        globalStub->receiverGuard().trace(trc);
        TraceEdge(trc, &globalStub->holder(), "baseline-global-stub-holder");
        TraceEdge(trc, &globalStub->holderShape(), "baseline-global-stub-holdershape");
        TraceEdge(trc, &globalStub->globalShape(), "baseline-global-stub-globalshape");
        break;
      }
      case ICStub::GetName_Env0:
        static_cast<ICGetName_Env<0>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env1:
        static_cast<ICGetName_Env<1>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env2:
        static_cast<ICGetName_Env<2>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env3:
        static_cast<ICGetName_Env<3>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env4:
        static_cast<ICGetName_Env<4>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env5:
        static_cast<ICGetName_Env<5>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetName_Env6:
        static_cast<ICGetName_Env<6>*>(this)->traceEnvironments(trc);
        break;
      case ICStub::GetIntrinsic_Constant: {
        ICGetIntrinsic_Constant* constantStub = toGetIntrinsic_Constant();
        TraceEdge(trc, &constantStub->value(), "baseline-getintrinsic-constant-value");
        break;
      }
      case ICStub::GetProp_CallDOMProxyNative:
      case ICStub::GetProp_CallDOMProxyWithGenerationNative: {
        ICGetPropCallDOMProxyNativeStub* propStub;
        if (kind() == ICStub::GetProp_CallDOMProxyNative)
            propStub = toGetProp_CallDOMProxyNative();
        else
            propStub = toGetProp_CallDOMProxyWithGenerationNative();
        propStub->receiverGuard().trace(trc);
        TraceNullableEdge(trc, &propStub->expandoShape(),
                          "baseline-getproplistbasenative-stub-expandoshape");
        TraceEdge(trc, &propStub->holder(), "baseline-getproplistbasenative-stub-holder");
        TraceEdge(trc, &propStub->holderShape(), "baseline-getproplistbasenative-stub-holdershape");
        TraceEdge(trc, &propStub->getter(), "baseline-getproplistbasenative-stub-getter");
        break;
      }
      case ICStub::GetProp_DOMProxyShadowed: {
        ICGetProp_DOMProxyShadowed* propStub = toGetProp_DOMProxyShadowed();
        TraceEdge(trc, &propStub->shape(), "baseline-getproplistbaseshadowed-stub-shape");
        TraceEdge(trc, &propStub->name(), "baseline-getproplistbaseshadowed-stub-name");
        break;
      }
      case ICStub::GetProp_CallScripted: {
        ICGetProp_CallScripted* callStub = toGetProp_CallScripted();
        callStub->receiverGuard().trace(trc);
        TraceEdge(trc, &callStub->holder(), "baseline-getpropcallscripted-stub-holder");
        TraceEdge(trc, &callStub->holderShape(), "baseline-getpropcallscripted-stub-holdershape");
        TraceEdge(trc, &callStub->getter(), "baseline-getpropcallscripted-stub-getter");
        break;
      }
      case ICStub::GetProp_CallNative: {
        ICGetProp_CallNative* callStub = toGetProp_CallNative();
        callStub->receiverGuard().trace(trc);
        TraceEdge(trc, &callStub->holder(), "baseline-getpropcallnative-stub-holder");
        TraceEdge(trc, &callStub->holderShape(), "baseline-getpropcallnative-stub-holdershape");
        TraceEdge(trc, &callStub->getter(), "baseline-getpropcallnative-stub-getter");
        break;
      }
      case ICStub::GetProp_CallNativeGlobal: {
        ICGetProp_CallNativeGlobal* callStub = toGetProp_CallNativeGlobal();
        callStub->receiverGuard().trace(trc);
        TraceEdge(trc, &callStub->holder(), "baseline-getpropcallnativeglobal-stub-holder");
        TraceEdge(trc, &callStub->holderShape(), "baseline-getpropcallnativeglobal-stub-holdershape");
        TraceEdge(trc, &callStub->globalShape(), "baseline-getpropcallnativeglobal-stub-globalshape");
        TraceEdge(trc, &callStub->getter(), "baseline-getpropcallnativeglobal-stub-getter");
        break;
      }
      case ICStub::SetProp_Native: {
        ICSetProp_Native* propStub = toSetProp_Native();
        TraceEdge(trc, &propStub->shape(), "baseline-setpropnative-stub-shape");
        TraceEdge(trc, &propStub->group(), "baseline-setpropnative-stub-group");
        break;
      }
      case ICStub::SetProp_NativeAdd: {
        ICSetProp_NativeAdd* propStub = toSetProp_NativeAdd();
        TraceEdge(trc, &propStub->group(), "baseline-setpropnativeadd-stub-group");
        TraceEdge(trc, &propStub->newShape(), "baseline-setpropnativeadd-stub-newshape");
        TraceNullableEdge(trc, &propStub->newGroup(), "baseline-setpropnativeadd-stub-new-group");
        JS_STATIC_ASSERT(ICSetProp_NativeAdd::MAX_PROTO_CHAIN_DEPTH == 4);
        switch (propStub->protoChainDepth()) {
          case 0: propStub->toImpl<0>()->traceShapes(trc); break;
          case 1: propStub->toImpl<1>()->traceShapes(trc); break;
          case 2: propStub->toImpl<2>()->traceShapes(trc); break;
          case 3: propStub->toImpl<3>()->traceShapes(trc); break;
          case 4: propStub->toImpl<4>()->traceShapes(trc); break;
          default: MOZ_CRASH("Invalid proto stub.");
        }
        break;
      }
      case ICStub::SetProp_Unboxed: {
        ICSetProp_Unboxed* propStub = toSetProp_Unboxed();
        TraceEdge(trc, &propStub->group(), "baseline-setprop-unboxed-stub-group");
        break;
      }
      case ICStub::SetProp_TypedObject: {
        ICSetProp_TypedObject* propStub = toSetProp_TypedObject();
        TraceEdge(trc, &propStub->shape(), "baseline-setprop-typedobject-stub-shape");
        TraceEdge(trc, &propStub->group(), "baseline-setprop-typedobject-stub-group");
        break;
      }
      case ICStub::SetProp_CallScripted: {
        ICSetProp_CallScripted* callStub = toSetProp_CallScripted();
        callStub->receiverGuard().trace(trc);
        TraceEdge(trc, &callStub->holder(), "baseline-setpropcallscripted-stub-holder");
        TraceEdge(trc, &callStub->holderShape(), "baseline-setpropcallscripted-stub-holdershape");
        TraceEdge(trc, &callStub->setter(), "baseline-setpropcallscripted-stub-setter");
        break;
      }
      case ICStub::SetProp_CallNative: {
        ICSetProp_CallNative* callStub = toSetProp_CallNative();
        callStub->receiverGuard().trace(trc);
        TraceEdge(trc, &callStub->holder(), "baseline-setpropcallnative-stub-holder");
        TraceEdge(trc, &callStub->holderShape(), "baseline-setpropcallnative-stub-holdershape");
        TraceEdge(trc, &callStub->setter(), "baseline-setpropcallnative-stub-setter");
        break;
      }
      case ICStub::InstanceOf_Function: {
        ICInstanceOf_Function* instanceofStub = toInstanceOf_Function();
        TraceEdge(trc, &instanceofStub->shape(), "baseline-instanceof-fun-shape");
        TraceEdge(trc, &instanceofStub->prototypeObject(), "baseline-instanceof-fun-prototype");
        break;
      }
      case ICStub::NewArray_Fallback: {
        ICNewArray_Fallback* stub = toNewArray_Fallback();
        TraceNullableEdge(trc, &stub->templateObject(), "baseline-newarray-template");
        TraceEdge(trc, &stub->templateGroup(), "baseline-newarray-template-group");
        break;
      }
      case ICStub::NewObject_Fallback: {
        ICNewObject_Fallback* stub = toNewObject_Fallback();
        TraceNullableEdge(trc, &stub->templateObject(), "baseline-newobject-template");
        break;
      }
      case ICStub::Rest_Fallback: {
        ICRest_Fallback* stub = toRest_Fallback();
        TraceEdge(trc, &stub->templateObject(), "baseline-rest-template");
        break;
      }
      case ICStub::CacheIR_Monitored:
        TraceBaselineCacheIRStub(trc, this, toCacheIR_Monitored()->stubInfo());
        break;
      default:
        break;
    }
}

void
ICFallbackStub::unlinkStub(Zone* zone, ICStub* prev, ICStub* stub)
{
    MOZ_ASSERT(stub->next());

    // If stub is the last optimized stub, update lastStubPtrAddr.
    if (stub->next() == this) {
        MOZ_ASSERT(lastStubPtrAddr_ == stub->addressOfNext());
        if (prev)
            lastStubPtrAddr_ = prev->addressOfNext();
        else
            lastStubPtrAddr_ = icEntry()->addressOfFirstStub();
        *lastStubPtrAddr_ = this;
    } else {
        if (prev) {
            MOZ_ASSERT(prev->next() == stub);
            prev->setNext(stub->next());
        } else {
            MOZ_ASSERT(icEntry()->firstStub() == stub);
            icEntry()->setFirstStub(stub->next());
        }
    }

    MOZ_ASSERT(numOptimizedStubs_ > 0);
    numOptimizedStubs_--;

    if (zone->needsIncrementalBarrier()) {
        // We are removing edges from ICStub to gcthings. Perform one final trace
        // of the stub for incremental GC, as it must know about those edges.
        stub->trace(zone->barrierTracer());
    }

    if (ICStub::CanMakeCalls(stub->kind()) && stub->isMonitored()) {
        // This stub can make calls so we can return to it if it's on the stack.
        // We just have to reset its firstMonitorStub_ field to avoid a stale
        // pointer when purgeOptimizedStubs destroys all optimized monitor
        // stubs (unlinked stubs won't be updated).
        ICTypeMonitor_Fallback* monitorFallback = toMonitoredFallbackStub()->fallbackMonitorStub();
        stub->toMonitoredStub()->resetFirstMonitorStub(monitorFallback);
    }

#ifdef DEBUG
    // Poison stub code to ensure we don't call this stub again. However, if this
    // stub can make calls, a pointer to it may be stored in a stub frame on the
    // stack, so we can't touch the stubCode_ or GC will crash when marking this
    // pointer.
    if (!ICStub::CanMakeCalls(stub->kind()))
        stub->stubCode_ = (uint8_t*)0xbad;
#endif
}

void
ICFallbackStub::unlinkStubsWithKind(JSContext* cx, ICStub::Kind kind)
{
    for (ICStubIterator iter = beginChain(); !iter.atEnd(); iter++) {
        if (iter->kind() == kind)
            iter.unlink(cx);
    }
}

void
ICTypeMonitor_Fallback::resetMonitorStubChain(Zone* zone)
{
    if (zone->needsIncrementalBarrier()) {
        // We are removing edges from monitored stubs to gcthings (JitCode).
        // Perform one final trace of all monitor stubs for incremental GC,
        // as it must know about those edges.
        for (ICStub* s = firstMonitorStub_; !s->isTypeMonitor_Fallback(); s = s->next())
            s->trace(zone->barrierTracer());
    }

    firstMonitorStub_ = this;
    numOptimizedMonitorStubs_ = 0;

    if (hasFallbackStub_) {
        lastMonitorStubPtrAddr_ = nullptr;

        // Reset firstMonitorStub_ field of all monitored stubs.
        for (ICStubConstIterator iter = mainFallbackStub_->beginChainConst();
             !iter.atEnd(); iter++)
        {
            if (!iter->isMonitored())
                continue;
            iter->toMonitoredStub()->resetFirstMonitorStub(this);
        }
    } else {
        icEntry_->setFirstStub(this);
        lastMonitorStubPtrAddr_ = icEntry_->addressOfFirstStub();
    }
}

ICMonitoredStub::ICMonitoredStub(Kind kind, JitCode* stubCode, ICStub* firstMonitorStub)
  : ICStub(kind, ICStub::Monitored, stubCode),
    firstMonitorStub_(firstMonitorStub)
{
    // In order to silence Coverity - null pointer dereference checker
    MOZ_ASSERT(firstMonitorStub_);
    // If the first monitored stub is a ICTypeMonitor_Fallback stub, then
    // double check that _its_ firstMonitorStub is the same as this one.
    MOZ_ASSERT_IF(firstMonitorStub_->isTypeMonitor_Fallback(),
                  firstMonitorStub_->toTypeMonitor_Fallback()->firstMonitorStub() ==
                     firstMonitorStub_);
}

bool
ICMonitoredFallbackStub::initMonitoringChain(JSContext* cx, ICStubSpace* space,
                                             ICStubCompiler::Engine engine)
{
    MOZ_ASSERT(fallbackMonitorStub_ == nullptr);

    ICTypeMonitor_Fallback::Compiler compiler(cx, engine, this);
    ICTypeMonitor_Fallback* stub = compiler.getStub(space);
    if (!stub)
        return false;
    fallbackMonitorStub_ = stub;
    return true;
}

bool
ICMonitoredFallbackStub::addMonitorStubForValue(JSContext* cx, SharedStubInfo* stub,
                                                HandleValue val)
{
    return fallbackMonitorStub_->addMonitorStubForValue(cx, stub, val);
}

bool
ICUpdatedStub::initUpdatingChain(JSContext* cx, ICStubSpace* space)
{
    MOZ_ASSERT(firstUpdateStub_ == nullptr);

    ICTypeUpdate_Fallback::Compiler compiler(cx);
    ICTypeUpdate_Fallback* stub = compiler.getStub(space);
    if (!stub)
        return false;

    firstUpdateStub_ = stub;
    return true;
}

JitCode*
ICStubCompiler::getStubCode()
{
    JitCompartment* comp = cx->compartment()->jitCompartment();

    // Check for existing cached stubcode.
    uint32_t stubKey = getKey();
    JitCode* stubCode = comp->getStubCode(stubKey);
    if (stubCode)
        return stubCode;

    // Compile new stubcode.
    JitContext jctx(cx, nullptr);
    MacroAssembler masm;
#ifndef JS_USE_LINK_REGISTER
    // The first value contains the return addres,
    // which we pull into ICTailCallReg for tail calls.
    masm.adjustFrame(sizeof(intptr_t));
#endif
#ifdef JS_CODEGEN_ARM
    masm.setSecondScratchReg(BaselineSecondScratchReg);
#endif

    if (!generateStubCode(masm))
        return nullptr;
    Linker linker(masm);
    AutoFlushICache afc("getStubCode");
    Rooted<JitCode*> newStubCode(cx, linker.newCode<CanGC>(cx, BASELINE_CODE));
    if (!newStubCode)
        return nullptr;

    // All barriers are emitted off-by-default, enable them if needed.
    if (cx->zone()->needsIncrementalBarrier())
        newStubCode->togglePreBarriers(true, DontReprotect);

    // Cache newly compiled stubcode.
    if (!comp->putStubCode(cx, stubKey, newStubCode))
        return nullptr;

    // After generating code, run postGenerateStubCode().  We must not fail
    // after this point.
    postGenerateStubCode(masm, newStubCode);

    MOZ_ASSERT(entersStubFrame_ == ICStub::CanMakeCalls(kind));
    MOZ_ASSERT(!inStubFrame_);

#ifdef JS_ION_PERF
    writePerfSpewerJitCodeProfile(newStubCode, "BaselineIC");
#endif

    return newStubCode;
}

bool
ICStubCompiler::tailCallVM(const VMFunction& fun, MacroAssembler& masm)
{
    JitCode* code = cx->runtime()->jitRuntime()->getVMWrapper(fun);
    if (!code)
        return false;

    MOZ_ASSERT(fun.expectTailCall == TailCall);
    uint32_t argSize = fun.explicitStackSlots() * sizeof(void*);
    if (engine_ == Engine::Baseline) {
        EmitBaselineTailCallVM(code, masm, argSize);
    } else {
        uint32_t stackSize = argSize + fun.extraValuesToPop * sizeof(Value);
        EmitIonTailCallVM(code, masm, stackSize);
    }
    return true;
}

bool
ICStubCompiler::callVM(const VMFunction& fun, MacroAssembler& masm)
{
    MOZ_ASSERT(inStubFrame_);

    JitCode* code = cx->runtime()->jitRuntime()->getVMWrapper(fun);
    if (!code)
        return false;

    MOZ_ASSERT(fun.expectTailCall == NonTailCall);
    if (engine_ == Engine::Baseline)
        EmitBaselineCallVM(code, masm);
    else
        EmitIonCallVM(code, fun.explicitStackSlots(), masm);
    return true;
}

bool
ICStubCompiler::callTypeUpdateIC(MacroAssembler& masm, uint32_t objectOffset)
{
    JitCode* code = cx->runtime()->jitRuntime()->getVMWrapper(DoTypeUpdateFallbackInfo);
    if (!code)
        return false;

    EmitCallTypeUpdateIC(masm, code, objectOffset);
    return true;
}

void
ICStubCompiler::enterStubFrame(MacroAssembler& masm, Register scratch)
{
    if (engine_ == Engine::Baseline) {
        EmitBaselineEnterStubFrame(masm, scratch);
#ifdef DEBUG
        framePushedAtEnterStubFrame_ = masm.framePushed();
#endif
    } else {
        EmitIonEnterStubFrame(masm, scratch);
    }

    MOZ_ASSERT(!inStubFrame_);
    inStubFrame_ = true;

#ifdef DEBUG
    entersStubFrame_ = true;
#endif
}

void
ICStubCompiler::leaveStubFrame(MacroAssembler& masm, bool calledIntoIon)
{
    MOZ_ASSERT(entersStubFrame_ && inStubFrame_);
    inStubFrame_ = false;

    if (engine_ == Engine::Baseline) {
#ifdef DEBUG
        masm.setFramePushed(framePushedAtEnterStubFrame_);
        if (calledIntoIon)
            masm.adjustFrame(sizeof(intptr_t)); // Calls into ion have this extra.
#endif

        EmitBaselineLeaveStubFrame(masm, calledIntoIon);
    } else {
        EmitIonLeaveStubFrame(masm);
    }
}

void
ICStubCompiler::pushStubPayload(MacroAssembler& masm, Register scratch)
{
    if (engine_ == Engine::IonMonkey) {
        masm.push(Imm32(0));
        return;
    }

    if (inStubFrame_) {
        masm.loadPtr(Address(BaselineFrameReg, 0), scratch);
        masm.pushBaselineFramePtr(scratch, scratch);
    } else {
        masm.pushBaselineFramePtr(BaselineFrameReg, scratch);
    }
}

void
ICStubCompiler::PushStubPayload(MacroAssembler& masm, Register scratch)
{
    pushStubPayload(masm, scratch);
    masm.adjustFrame(sizeof(intptr_t));
}

void
ICStubCompiler::emitPostWriteBarrierSlot(MacroAssembler& masm, Register obj, ValueOperand val,
                                         Register scratch, LiveGeneralRegisterSet saveRegs)
{
    Label skipBarrier;
    masm.branchPtrInNurseryChunk(Assembler::Equal, obj, scratch, &skipBarrier);
    masm.branchValueIsNurseryObject(Assembler::NotEqual, val, scratch, &skipBarrier);

    // void PostWriteBarrier(JSRuntime* rt, JSObject* obj);
#if defined(JS_CODEGEN_ARM) || defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_MIPS64)
    saveRegs.add(ICTailCallReg);
#endif
    saveRegs.set() = GeneralRegisterSet::Intersect(saveRegs.set(), GeneralRegisterSet::Volatile());
    masm.PushRegsInMask(saveRegs);
    masm.setupUnalignedABICall(scratch);
    masm.movePtr(ImmPtr(cx->runtime()), scratch);
    masm.passABIArg(scratch);
    masm.passABIArg(obj);
    masm.callWithABI(JS_FUNC_TO_DATA_PTR(void*, PostWriteBarrier));
    masm.PopRegsInMask(saveRegs);

    masm.bind(&skipBarrier);
}

SharedStubInfo::SharedStubInfo(JSContext* cx, void* payload, ICEntry* icEntry)
  : maybeFrame_(nullptr),
    outerScript_(cx),
    innerScript_(cx),
    icEntry_(icEntry)
{
    if (payload) {
        maybeFrame_ = (BaselineFrame*) payload;
        outerScript_ = maybeFrame_->script();
        innerScript_ = maybeFrame_->script();
    } else {
        IonICEntry* entry = (IonICEntry*) icEntry;
        innerScript_ = entry->script();
        // outerScript_ is initialized lazily.
    }
}

HandleScript
SharedStubInfo::outerScript(JSContext* cx)
{
    if (!outerScript_) {
        js::jit::JitActivationIterator iter(cx->runtime());
        JitFrameIterator it(iter);
        MOZ_ASSERT(it.isExitFrame());
        ++it;
        MOZ_ASSERT(it.isIonJS());
        outerScript_ = it.script();
        MOZ_ASSERT(!it.ionScript()->invalidated());
    }
    return outerScript_;
}

//
// BinaryArith_Fallback
//

static bool
DoBinaryArithFallback(JSContext* cx, void* payload, ICBinaryArith_Fallback* stub_,
                      HandleValue lhs, HandleValue rhs, MutableHandleValue ret)
{
    SharedStubInfo info(cx, payload, stub_->icEntry());
    ICStubCompiler::Engine engine = info.engine();

    // This fallback stub may trigger debug mode toggling.
    DebugModeOSRVolatileStub<ICBinaryArith_Fallback*> stub(engine, info.maybeFrame(), stub_);

    jsbytecode* pc = info.pc();
    JSOp op = JSOp(*pc);
    FallbackICSpew(cx, stub, "BinaryArith(%s,%d,%d)", CodeName[op],
            int(lhs.isDouble() ? JSVAL_TYPE_DOUBLE : lhs.extractNonDoubleType()),
            int(rhs.isDouble() ? JSVAL_TYPE_DOUBLE : rhs.extractNonDoubleType()));

    // Don't pass lhs/rhs directly, we need the original values when
    // generating stubs.
    RootedValue lhsCopy(cx, lhs);
    RootedValue rhsCopy(cx, rhs);

    // Perform the compare operation.
    switch(op) {
      case JSOP_ADD:
        // Do an add.
        if (!AddValues(cx, &lhsCopy, &rhsCopy, ret))
            return false;
        break;
      case JSOP_SUB:
        if (!SubValues(cx, &lhsCopy, &rhsCopy, ret))
            return false;
        break;
      case JSOP_MUL:
        if (!MulValues(cx, &lhsCopy, &rhsCopy, ret))
            return false;
        break;
      case JSOP_DIV:
        if (!DivValues(cx, &lhsCopy, &rhsCopy, ret))
            return false;
        break;
      case JSOP_MOD:
        if (!ModValues(cx, &lhsCopy, &rhsCopy, ret))
            return false;
        break;
      case JSOP_POW:
        if (!math_pow_handle(cx, lhsCopy, rhsCopy, ret))
            return false;
        break;
      case JSOP_BITOR: {
        int32_t result;
        if (!BitOr(cx, lhs, rhs, &result))
            return false;
        ret.setInt32(result);
        break;
      }
      case JSOP_BITXOR: {
        int32_t result;
        if (!BitXor(cx, lhs, rhs, &result))
            return false;
        ret.setInt32(result);
        break;
      }
      case JSOP_BITAND: {
        int32_t result;
        if (!BitAnd(cx, lhs, rhs, &result))
            return false;
        ret.setInt32(result);
        break;
      }
      case JSOP_LSH: {
        int32_t result;
        if (!BitLsh(cx, lhs, rhs, &result))
            return false;
        ret.setInt32(result);
        break;
      }
      case JSOP_RSH: {
        int32_t result;
        if (!BitRsh(cx, lhs, rhs, &result))
            return false;
        ret.setInt32(result);
        break;
      }
      case JSOP_URSH: {
        if (!UrshOperation(cx, lhs, rhs, ret))
            return false;
        break;
      }
      default:
        MOZ_CRASH("Unhandled baseline arith op");
    }

    // Check if debug mode toggling made the stub invalid.
    if (stub.invalid())
        return true;

    if (ret.isDouble())
        stub->setSawDoubleResult();

    // Check to see if a new stub should be generated.
    if (stub->numOptimizedStubs() >= ICBinaryArith_Fallback::MAX_OPTIMIZED_STUBS) {
        stub->noteUnoptimizableOperands();
        return true;
    }

    // Handle string concat.
    if (op == JSOP_ADD) {
        if (lhs.isString() && rhs.isString()) {
            JitSpew(JitSpew_BaselineIC, "  Generating %s(String, String) stub", CodeName[op]);
            MOZ_ASSERT(ret.isString());
            ICBinaryArith_StringConcat::Compiler compiler(cx, engine);
            ICStub* strcatStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!strcatStub)
                return false;
            stub->addNewStub(strcatStub);
            return true;
        }

        if ((lhs.isString() && rhs.isObject()) || (lhs.isObject() && rhs.isString())) {
            JitSpew(JitSpew_BaselineIC, "  Generating %s(%s, %s) stub", CodeName[op],
                    lhs.isString() ? "String" : "Object",
                    lhs.isString() ? "Object" : "String");
            MOZ_ASSERT(ret.isString());
            ICBinaryArith_StringObjectConcat::Compiler compiler(cx, engine, lhs.isString());
            ICStub* strcatStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!strcatStub)
                return false;
            stub->addNewStub(strcatStub);
            return true;
        }
    }

    if (((lhs.isBoolean() && (rhs.isBoolean() || rhs.isInt32())) ||
         (rhs.isBoolean() && (lhs.isBoolean() || lhs.isInt32()))) &&
        (op == JSOP_ADD || op == JSOP_SUB || op == JSOP_BITOR || op == JSOP_BITAND ||
         op == JSOP_BITXOR))
    {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(%s, %s) stub", CodeName[op],
                lhs.isBoolean() ? "Boolean" : "Int32", rhs.isBoolean() ? "Boolean" : "Int32");
        ICBinaryArith_BooleanWithInt32::Compiler compiler(cx, op, engine,
                                                          lhs.isBoolean(), rhs.isBoolean());
        ICStub* arithStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!arithStub)
            return false;
        stub->addNewStub(arithStub);
        return true;
    }

    // Handle only int32 or double.
    if (!lhs.isNumber() || !rhs.isNumber()) {
        stub->noteUnoptimizableOperands();
        return true;
    }

    MOZ_ASSERT(ret.isNumber());

    if (lhs.isDouble() || rhs.isDouble() || ret.isDouble()) {
        if (!cx->runtime()->jitSupportsFloatingPoint)
            return true;

        switch (op) {
          case JSOP_ADD:
          case JSOP_SUB:
          case JSOP_MUL:
          case JSOP_DIV:
          case JSOP_MOD: {
            // Unlink int32 stubs, it's faster to always use the double stub.
            stub->unlinkStubsWithKind(cx, ICStub::BinaryArith_Int32);
            JitSpew(JitSpew_BaselineIC, "  Generating %s(Double, Double) stub", CodeName[op]);

            ICBinaryArith_Double::Compiler compiler(cx, op, engine);
            ICStub* doubleStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!doubleStub)
                return false;
            stub->addNewStub(doubleStub);
            return true;
          }
          default:
            break;
        }
    }

    if (lhs.isInt32() && rhs.isInt32() && op != JSOP_POW) {
        bool allowDouble = ret.isDouble();
        if (allowDouble)
            stub->unlinkStubsWithKind(cx, ICStub::BinaryArith_Int32);
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Int32, Int32%s) stub", CodeName[op],
                allowDouble ? " => Double" : "");
        ICBinaryArith_Int32::Compiler compilerInt32(cx, op, engine, allowDouble);
        ICStub* int32Stub = compilerInt32.getStub(compilerInt32.getStubSpace(info.outerScript(cx)));
        if (!int32Stub)
            return false;
        stub->addNewStub(int32Stub);
        return true;
    }

    // Handle Double <BITOP> Int32 or Int32 <BITOP> Double case.
    if (((lhs.isDouble() && rhs.isInt32()) || (lhs.isInt32() && rhs.isDouble())) &&
        ret.isInt32())
    {
        switch(op) {
          case JSOP_BITOR:
          case JSOP_BITXOR:
          case JSOP_BITAND: {
            JitSpew(JitSpew_BaselineIC, "  Generating %s(%s, %s) stub", CodeName[op],
                        lhs.isDouble() ? "Double" : "Int32",
                        lhs.isDouble() ? "Int32" : "Double");
            ICBinaryArith_DoubleWithInt32::Compiler compiler(cx, op, engine, lhs.isDouble());
            ICStub* optStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!optStub)
                return false;
            stub->addNewStub(optStub);
            return true;
          }
          default:
            break;
        }
    }

    stub->noteUnoptimizableOperands();
    return true;
}

typedef bool (*DoBinaryArithFallbackFn)(JSContext*, void*, ICBinaryArith_Fallback*,
                                        HandleValue, HandleValue, MutableHandleValue);
static const VMFunction DoBinaryArithFallbackInfo =
    FunctionInfo<DoBinaryArithFallbackFn>(DoBinaryArithFallback, "DoBinaryArithFallback",
                                          TailCall, PopValues(2));

bool
ICBinaryArith_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(R0 == JSReturnOperand);

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    // Ensure stack is fully synced for the expression decompiler.
    masm.pushValue(R0);
    masm.pushValue(R1);

    // Push arguments.
    masm.pushValue(R1);
    masm.pushValue(R0);
    masm.push(ICStubReg);
    pushStubPayload(masm, R0.scratchReg());

    return tailCallVM(DoBinaryArithFallbackInfo, masm);
}

static bool
DoConcatStrings(JSContext* cx, HandleString lhs, HandleString rhs, MutableHandleValue res)
{
    JSString* result = ConcatStrings<CanGC>(cx, lhs, rhs);
    if (!result)
        return false;

    res.setString(result);
    return true;
}

typedef bool (*DoConcatStringsFn)(JSContext*, HandleString, HandleString, MutableHandleValue);
static const VMFunction DoConcatStringsInfo =
    FunctionInfo<DoConcatStringsFn>(DoConcatStrings, "DoConcatStrings", TailCall);

bool
ICBinaryArith_StringConcat::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestString(Assembler::NotEqual, R0, &failure);
    masm.branchTestString(Assembler::NotEqual, R1, &failure);

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    masm.unboxString(R0, R0.scratchReg());
    masm.unboxString(R1, R1.scratchReg());

    masm.push(R1.scratchReg());
    masm.push(R0.scratchReg());
    if (!tailCallVM(DoConcatStringsInfo, masm))
        return false;

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

static JSString*
ConvertObjectToStringForConcat(JSContext* cx, HandleValue obj)
{
    MOZ_ASSERT(obj.isObject());
    RootedValue rootedObj(cx, obj);
    if (!ToPrimitive(cx, &rootedObj))
        return nullptr;
    return ToString<CanGC>(cx, rootedObj);
}

static bool
DoConcatStringObject(JSContext* cx, bool lhsIsString, HandleValue lhs, HandleValue rhs,
                     MutableHandleValue res)
{
    JSString* lstr = nullptr;
    JSString* rstr = nullptr;
    if (lhsIsString) {
        // Convert rhs first.
        MOZ_ASSERT(lhs.isString() && rhs.isObject());
        rstr = ConvertObjectToStringForConcat(cx, rhs);
        if (!rstr)
            return false;

        // lhs is already string.
        lstr = lhs.toString();
    } else {
        MOZ_ASSERT(rhs.isString() && lhs.isObject());
        // Convert lhs first.
        lstr = ConvertObjectToStringForConcat(cx, lhs);
        if (!lstr)
            return false;

        // rhs is already string.
        rstr = rhs.toString();
    }

    JSString* str = ConcatStrings<NoGC>(cx, lstr, rstr);
    if (!str) {
        RootedString nlstr(cx, lstr), nrstr(cx, rstr);
        str = ConcatStrings<CanGC>(cx, nlstr, nrstr);
        if (!str)
            return false;
    }

    // Technically, we need to call TypeScript::MonitorString for this PC, however
    // it was called when this stub was attached so it's OK.

    res.setString(str);
    return true;
}

typedef bool (*DoConcatStringObjectFn)(JSContext*, bool lhsIsString, HandleValue, HandleValue,
                                       MutableHandleValue);
static const VMFunction DoConcatStringObjectInfo =
    FunctionInfo<DoConcatStringObjectFn>(DoConcatStringObject, "DoConcatStringObject", TailCall,
                                         PopValues(2));

bool
ICBinaryArith_StringObjectConcat::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    if (lhsIsString_) {
        masm.branchTestString(Assembler::NotEqual, R0, &failure);
        masm.branchTestObject(Assembler::NotEqual, R1, &failure);
    } else {
        masm.branchTestObject(Assembler::NotEqual, R0, &failure);
        masm.branchTestString(Assembler::NotEqual, R1, &failure);
    }

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    // Sync for the decompiler.
    masm.pushValue(R0);
    masm.pushValue(R1);

    // Push arguments.
    masm.pushValue(R1);
    masm.pushValue(R0);
    masm.push(Imm32(lhsIsString_));
    if (!tailCallVM(DoConcatStringObjectInfo, masm))
        return false;

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICBinaryArith_Double::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.ensureDouble(R0, FloatReg0, &failure);
    masm.ensureDouble(R1, FloatReg1, &failure);

    switch (op) {
      case JSOP_ADD:
        masm.addDouble(FloatReg1, FloatReg0);
        break;
      case JSOP_SUB:
        masm.subDouble(FloatReg1, FloatReg0);
        break;
      case JSOP_MUL:
        masm.mulDouble(FloatReg1, FloatReg0);
        break;
      case JSOP_DIV:
        masm.divDouble(FloatReg1, FloatReg0);
        break;
      case JSOP_MOD:
        masm.setupUnalignedABICall(R0.scratchReg());
        masm.passABIArg(FloatReg0, MoveOp::DOUBLE);
        masm.passABIArg(FloatReg1, MoveOp::DOUBLE);
        masm.callWithABI(JS_FUNC_TO_DATA_PTR(void*, NumberMod), MoveOp::DOUBLE);
        MOZ_ASSERT(ReturnDoubleReg == FloatReg0);
        break;
      default:
        MOZ_CRASH("Unexpected op");
    }

    masm.boxDouble(FloatReg0, R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICBinaryArith_BooleanWithInt32::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    if (lhsIsBool_)
        masm.branchTestBoolean(Assembler::NotEqual, R0, &failure);
    else
        masm.branchTestInt32(Assembler::NotEqual, R0, &failure);

    if (rhsIsBool_)
        masm.branchTestBoolean(Assembler::NotEqual, R1, &failure);
    else
        masm.branchTestInt32(Assembler::NotEqual, R1, &failure);

    Register lhsReg = lhsIsBool_ ? masm.extractBoolean(R0, ExtractTemp0)
                                 : masm.extractInt32(R0, ExtractTemp0);
    Register rhsReg = rhsIsBool_ ? masm.extractBoolean(R1, ExtractTemp1)
                                 : masm.extractInt32(R1, ExtractTemp1);

    MOZ_ASSERT(op_ == JSOP_ADD || op_ == JSOP_SUB ||
               op_ == JSOP_BITOR || op_ == JSOP_BITXOR || op_ == JSOP_BITAND);

    switch(op_) {
      case JSOP_ADD: {
        Label fixOverflow;

        masm.branchAdd32(Assembler::Overflow, rhsReg, lhsReg, &fixOverflow);
        masm.tagValue(JSVAL_TYPE_INT32, lhsReg, R0);
        EmitReturnFromIC(masm);

        masm.bind(&fixOverflow);
        masm.sub32(rhsReg, lhsReg);
        // Proceed to failure below.
        break;
      }
      case JSOP_SUB: {
        Label fixOverflow;

        masm.branchSub32(Assembler::Overflow, rhsReg, lhsReg, &fixOverflow);
        masm.tagValue(JSVAL_TYPE_INT32, lhsReg, R0);
        EmitReturnFromIC(masm);

        masm.bind(&fixOverflow);
        masm.add32(rhsReg, lhsReg);
        // Proceed to failure below.
        break;
      }
      case JSOP_BITOR: {
        masm.orPtr(rhsReg, lhsReg);
        masm.tagValue(JSVAL_TYPE_INT32, lhsReg, R0);
        EmitReturnFromIC(masm);
        break;
      }
      case JSOP_BITXOR: {
        masm.xorPtr(rhsReg, lhsReg);
        masm.tagValue(JSVAL_TYPE_INT32, lhsReg, R0);
        EmitReturnFromIC(masm);
        break;
      }
      case JSOP_BITAND: {
        masm.andPtr(rhsReg, lhsReg);
        masm.tagValue(JSVAL_TYPE_INT32, lhsReg, R0);
        EmitReturnFromIC(masm);
        break;
      }
      default:
       MOZ_CRASH("Unhandled op for BinaryArith_BooleanWithInt32.");
    }

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICBinaryArith_DoubleWithInt32::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(op == JSOP_BITOR || op == JSOP_BITAND || op == JSOP_BITXOR);

    Label failure;
    Register intReg;
    Register scratchReg;
    if (lhsIsDouble_) {
        masm.branchTestDouble(Assembler::NotEqual, R0, &failure);
        masm.branchTestInt32(Assembler::NotEqual, R1, &failure);
        intReg = masm.extractInt32(R1, ExtractTemp0);
        masm.unboxDouble(R0, FloatReg0);
        scratchReg = R0.scratchReg();
    } else {
        masm.branchTestInt32(Assembler::NotEqual, R0, &failure);
        masm.branchTestDouble(Assembler::NotEqual, R1, &failure);
        intReg = masm.extractInt32(R0, ExtractTemp0);
        masm.unboxDouble(R1, FloatReg0);
        scratchReg = R1.scratchReg();
    }

    // Truncate the double to an int32.
    {
        Label doneTruncate;
        Label truncateABICall;
        masm.branchTruncateDoubleMaybeModUint32(FloatReg0, scratchReg, &truncateABICall);
        masm.jump(&doneTruncate);

        masm.bind(&truncateABICall);
        masm.push(intReg);
        masm.setupUnalignedABICall(scratchReg);
        masm.passABIArg(FloatReg0, MoveOp::DOUBLE);
        masm.callWithABI(mozilla::BitwiseCast<void*, int32_t(*)(double)>(JS::ToInt32));
        masm.storeCallWordResult(scratchReg);
        masm.pop(intReg);

        masm.bind(&doneTruncate);
    }

    Register intReg2 = scratchReg;
    // All handled ops commute, so no need to worry about ordering.
    switch(op) {
      case JSOP_BITOR:
        masm.orPtr(intReg, intReg2);
        break;
      case JSOP_BITXOR:
        masm.xorPtr(intReg, intReg2);
        break;
      case JSOP_BITAND:
        masm.andPtr(intReg, intReg2);
        break;
      default:
       MOZ_CRASH("Unhandled op for BinaryArith_DoubleWithInt32.");
    }
    masm.tagValue(JSVAL_TYPE_INT32, intReg2, R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// UnaryArith_Fallback
//

static bool
DoUnaryArithFallback(JSContext* cx, void* payload, ICUnaryArith_Fallback* stub_,
                     HandleValue val, MutableHandleValue res)
{
    SharedStubInfo info(cx, payload, stub_->icEntry());
    ICStubCompiler::Engine engine = info.engine();
    HandleScript script = info.innerScript();

    // This fallback stub may trigger debug mode toggling.
    DebugModeOSRVolatileStub<ICUnaryArith_Fallback*> stub(engine, info.maybeFrame(), stub_);

    jsbytecode* pc = info.pc();
    JSOp op = JSOp(*pc);
    FallbackICSpew(cx, stub, "UnaryArith(%s)", CodeName[op]);

    switch (op) {
      case JSOP_BITNOT: {
        int32_t result;
        if (!BitNot(cx, val, &result))
            return false;
        res.setInt32(result);
        break;
      }
      case JSOP_NEG:
        if (!NegOperation(cx, script, pc, val, res))
            return false;
        break;
      default:
        MOZ_CRASH("Unexpected op");
    }

    // Check if debug mode toggling made the stub invalid.
    if (stub.invalid())
        return true;

    if (res.isDouble())
        stub->setSawDoubleResult();

    if (stub->numOptimizedStubs() >= ICUnaryArith_Fallback::MAX_OPTIMIZED_STUBS) {
        // TODO: Discard/replace stubs.
        return true;
    }

    if (val.isInt32() && res.isInt32()) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Int32 => Int32) stub", CodeName[op]);
        ICUnaryArith_Int32::Compiler compiler(cx, op, engine);
        ICStub* int32Stub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!int32Stub)
            return false;
        stub->addNewStub(int32Stub);
        return true;
    }

    if (val.isNumber() && res.isNumber() && cx->runtime()->jitSupportsFloatingPoint) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Number => Number) stub", CodeName[op]);

        // Unlink int32 stubs, the double stub handles both cases and TI specializes for both.
        stub->unlinkStubsWithKind(cx, ICStub::UnaryArith_Int32);

        ICUnaryArith_Double::Compiler compiler(cx, op, engine);
        ICStub* doubleStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!doubleStub)
            return false;
        stub->addNewStub(doubleStub);
        return true;
    }

    return true;
}

typedef bool (*DoUnaryArithFallbackFn)(JSContext*, void*, ICUnaryArith_Fallback*,
                                       HandleValue, MutableHandleValue);
static const VMFunction DoUnaryArithFallbackInfo =
    FunctionInfo<DoUnaryArithFallbackFn>(DoUnaryArithFallback, "DoUnaryArithFallback", TailCall,
                                         PopValues(1));

bool
ICUnaryArith_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(R0 == JSReturnOperand);

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    // Ensure stack is fully synced for the expression decompiler.
    masm.pushValue(R0);

    // Push arguments.
    masm.pushValue(R0);
    masm.push(ICStubReg);
    pushStubPayload(masm, R0.scratchReg());

    return tailCallVM(DoUnaryArithFallbackInfo, masm);
}

bool
ICUnaryArith_Double::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.ensureDouble(R0, FloatReg0, &failure);

    MOZ_ASSERT(op == JSOP_NEG || op == JSOP_BITNOT);

    if (op == JSOP_NEG) {
        masm.negateDouble(FloatReg0);
        masm.boxDouble(FloatReg0, R0);
    } else {
        // Truncate the double to an int32.
        Register scratchReg = R1.scratchReg();

        Label doneTruncate;
        Label truncateABICall;
        masm.branchTruncateDoubleMaybeModUint32(FloatReg0, scratchReg, &truncateABICall);
        masm.jump(&doneTruncate);

        masm.bind(&truncateABICall);
        masm.setupUnalignedABICall(scratchReg);
        masm.passABIArg(FloatReg0, MoveOp::DOUBLE);
        masm.callWithABI(BitwiseCast<void*, int32_t(*)(double)>(JS::ToInt32));
        masm.storeCallWordResult(scratchReg);

        masm.bind(&doneTruncate);
        masm.not32(scratchReg);
        masm.tagValue(JSVAL_TYPE_INT32, scratchReg, R0);
    }

    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_Fallback
//

static bool
DoCompareFallback(JSContext* cx, void* payload, ICCompare_Fallback* stub_, HandleValue lhs,
                  HandleValue rhs, MutableHandleValue ret)
{
    SharedStubInfo info(cx, payload, stub_->icEntry());
    ICStubCompiler::Engine engine = info.engine();

    // This fallback stub may trigger debug mode toggling.
    DebugModeOSRVolatileStub<ICCompare_Fallback*> stub(engine, info.maybeFrame(), stub_);

    jsbytecode* pc = info.pc();
    JSOp op = JSOp(*pc);

    FallbackICSpew(cx, stub, "Compare(%s)", CodeName[op]);

    // Case operations in a CONDSWITCH are performing strict equality.
    if (op == JSOP_CASE)
        op = JSOP_STRICTEQ;

    // Don't pass lhs/rhs directly, we need the original values when
    // generating stubs.
    RootedValue lhsCopy(cx, lhs);
    RootedValue rhsCopy(cx, rhs);

    // Perform the compare operation.
    bool out;
    switch(op) {
      case JSOP_LT:
        if (!LessThan(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_LE:
        if (!LessThanOrEqual(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_GT:
        if (!GreaterThan(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_GE:
        if (!GreaterThanOrEqual(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_EQ:
        if (!LooselyEqual<true>(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_NE:
        if (!LooselyEqual<false>(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_STRICTEQ:
        if (!StrictlyEqual<true>(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      case JSOP_STRICTNE:
        if (!StrictlyEqual<false>(cx, &lhsCopy, &rhsCopy, &out))
            return false;
        break;
      default:
        MOZ_ASSERT_UNREACHABLE("Unhandled baseline compare op");
        return false;
    }

    ret.setBoolean(out);

    // Check if debug mode toggling made the stub invalid.
    if (stub.invalid())
        return true;

    // Check to see if a new stub should be generated.
    if (stub->numOptimizedStubs() >= ICCompare_Fallback::MAX_OPTIMIZED_STUBS) {
        // TODO: Discard all stubs in this IC and replace with inert megamorphic stub.
        // But for now we just bail.
        return true;
    }

    // Try to generate new stubs.
    if (lhs.isInt32() && rhs.isInt32()) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Int32, Int32) stub", CodeName[op]);
        ICCompare_Int32::Compiler compiler(cx, op, engine);
        ICStub* int32Stub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!int32Stub)
            return false;

        stub->addNewStub(int32Stub);
        return true;
    }

    if (!cx->runtime()->jitSupportsFloatingPoint && (lhs.isNumber() || rhs.isNumber()))
        return true;

    if (lhs.isNumber() && rhs.isNumber()) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Number, Number) stub", CodeName[op]);

        // Unlink int32 stubs, it's faster to always use the double stub.
        stub->unlinkStubsWithKind(cx, ICStub::Compare_Int32);

        ICCompare_Double::Compiler compiler(cx, op, engine);
        ICStub* doubleStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!doubleStub)
            return false;

        stub->addNewStub(doubleStub);
        return true;
    }

    if ((lhs.isNumber() && rhs.isUndefined()) ||
        (lhs.isUndefined() && rhs.isNumber()))
    {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(%s, %s) stub", CodeName[op],
                    rhs.isUndefined() ? "Number" : "Undefined",
                    rhs.isUndefined() ? "Undefined" : "Number");
        ICCompare_NumberWithUndefined::Compiler compiler(cx, op, engine, lhs.isUndefined());
        ICStub* doubleStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!doubleStub)
            return false;

        stub->addNewStub(doubleStub);
        return true;
    }

    if (lhs.isBoolean() && rhs.isBoolean()) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(Boolean, Boolean) stub", CodeName[op]);
        ICCompare_Boolean::Compiler compiler(cx, op, engine);
        ICStub* booleanStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!booleanStub)
            return false;

        stub->addNewStub(booleanStub);
        return true;
    }

    if ((lhs.isBoolean() && rhs.isInt32()) || (lhs.isInt32() && rhs.isBoolean())) {
        JitSpew(JitSpew_BaselineIC, "  Generating %s(%s, %s) stub", CodeName[op],
                    rhs.isInt32() ? "Boolean" : "Int32",
                    rhs.isInt32() ? "Int32" : "Boolean");
        ICCompare_Int32WithBoolean::Compiler compiler(cx, op, engine, lhs.isInt32());
        ICStub* optStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!optStub)
            return false;

        stub->addNewStub(optStub);
        return true;
    }

    if (IsEqualityOp(op)) {
        if (lhs.isString() && rhs.isString() && !stub->hasStub(ICStub::Compare_String)) {
            JitSpew(JitSpew_BaselineIC, "  Generating %s(String, String) stub", CodeName[op]);
            ICCompare_String::Compiler compiler(cx, op, engine);
            ICStub* stringStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!stringStub)
                return false;

            stub->addNewStub(stringStub);
            return true;
        }

        if (lhs.isObject() && rhs.isObject()) {
            MOZ_ASSERT(!stub->hasStub(ICStub::Compare_Object));
            JitSpew(JitSpew_BaselineIC, "  Generating %s(Object, Object) stub", CodeName[op]);
            ICCompare_Object::Compiler compiler(cx, op, engine);
            ICStub* objectStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!objectStub)
                return false;

            stub->addNewStub(objectStub);
            return true;
        }

        if ((lhs.isObject() || lhs.isNull() || lhs.isUndefined()) &&
            (rhs.isObject() || rhs.isNull() || rhs.isUndefined()) &&
            !stub->hasStub(ICStub::Compare_ObjectWithUndefined))
        {
            JitSpew(JitSpew_BaselineIC, "  Generating %s(Obj/Null/Undef, Obj/Null/Undef) stub",
                    CodeName[op]);
            bool lhsIsUndefined = lhs.isNull() || lhs.isUndefined();
            bool compareWithNull = lhs.isNull() || rhs.isNull();
            ICCompare_ObjectWithUndefined::Compiler compiler(cx, op, engine,
                                                             lhsIsUndefined, compareWithNull);
            ICStub* objectStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
            if (!objectStub)
                return false;

            stub->addNewStub(objectStub);
            return true;
        }
    }

    stub->noteUnoptimizableAccess();

    return true;
}

typedef bool (*DoCompareFallbackFn)(JSContext*, void*, ICCompare_Fallback*,
                                    HandleValue, HandleValue, MutableHandleValue);
static const VMFunction DoCompareFallbackInfo =
    FunctionInfo<DoCompareFallbackFn>(DoCompareFallback, "DoCompareFallback", TailCall,
                                      PopValues(2));

bool
ICCompare_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(R0 == JSReturnOperand);

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    // Ensure stack is fully synced for the expression decompiler.
    masm.pushValue(R0);
    masm.pushValue(R1);

    // Push arguments.
    masm.pushValue(R1);
    masm.pushValue(R0);
    masm.push(ICStubReg);
    pushStubPayload(masm, R0.scratchReg());
    return tailCallVM(DoCompareFallbackInfo, masm);
}

//
// Compare_String
//

bool
ICCompare_String::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestString(Assembler::NotEqual, R0, &failure);
    masm.branchTestString(Assembler::NotEqual, R1, &failure);

    MOZ_ASSERT(IsEqualityOp(op));

    Register left = masm.extractString(R0, ExtractTemp0);
    Register right = masm.extractString(R1, ExtractTemp1);

    AllocatableGeneralRegisterSet regs(availableGeneralRegs(2));
    Register scratchReg = regs.takeAny();

    masm.compareStrings(op, left, right, scratchReg, &failure);
    masm.tagValue(JSVAL_TYPE_BOOLEAN, scratchReg, R0);
    EmitReturnFromIC(masm);

    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_Boolean
//

bool
ICCompare_Boolean::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestBoolean(Assembler::NotEqual, R0, &failure);
    masm.branchTestBoolean(Assembler::NotEqual, R1, &failure);

    Register left = masm.extractInt32(R0, ExtractTemp0);
    Register right = masm.extractInt32(R1, ExtractTemp1);

    // Compare payload regs of R0 and R1.
    Assembler::Condition cond = JSOpToCondition(op, /* signed = */true);
    masm.cmp32Set(cond, left, right, left);

    // Box the result and return
    masm.tagValue(JSVAL_TYPE_BOOLEAN, left, R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_NumberWithUndefined
//

bool
ICCompare_NumberWithUndefined::Compiler::generateStubCode(MacroAssembler& masm)
{
    ValueOperand numberOperand, undefinedOperand;
    if (lhsIsUndefined) {
        numberOperand = R1;
        undefinedOperand = R0;
    } else {
        numberOperand = R0;
        undefinedOperand = R1;
    }

    Label failure;
    masm.branchTestNumber(Assembler::NotEqual, numberOperand, &failure);
    masm.branchTestUndefined(Assembler::NotEqual, undefinedOperand, &failure);

    // Comparing a number with undefined will always be true for NE/STRICTNE,
    // and always be false for other compare ops.
    masm.moveValue(BooleanValue(op == JSOP_NE || op == JSOP_STRICTNE), R0);

    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_Object
//

bool
ICCompare_Object::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);
    masm.branchTestObject(Assembler::NotEqual, R1, &failure);

    MOZ_ASSERT(IsEqualityOp(op));

    Register left = masm.extractObject(R0, ExtractTemp0);
    Register right = masm.extractObject(R1, ExtractTemp1);

    Label ifTrue;
    masm.branchPtr(JSOpToCondition(op, /* signed = */true), left, right, &ifTrue);

    masm.moveValue(BooleanValue(false), R0);
    EmitReturnFromIC(masm);

    masm.bind(&ifTrue);
    masm.moveValue(BooleanValue(true), R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_ObjectWithUndefined
//

bool
ICCompare_ObjectWithUndefined::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(IsEqualityOp(op));

    ValueOperand objectOperand, undefinedOperand;
    if (lhsIsUndefined) {
        objectOperand = R1;
        undefinedOperand = R0;
    } else {
        objectOperand = R0;
        undefinedOperand = R1;
    }

    Label failure;
    if (compareWithNull)
        masm.branchTestNull(Assembler::NotEqual, undefinedOperand, &failure);
    else
        masm.branchTestUndefined(Assembler::NotEqual, undefinedOperand, &failure);

    Label notObject;
    masm.branchTestObject(Assembler::NotEqual, objectOperand, &notObject);

    if (op == JSOP_STRICTEQ || op == JSOP_STRICTNE) {
        // obj !== undefined for all objects.
        masm.moveValue(BooleanValue(op == JSOP_STRICTNE), R0);
        EmitReturnFromIC(masm);
    } else {
        // obj != undefined only where !obj->getClass()->emulatesUndefined()
        Label emulatesUndefined;
        Register obj = masm.extractObject(objectOperand, ExtractTemp0);
        masm.loadPtr(Address(obj, JSObject::offsetOfGroup()), obj);
        masm.loadPtr(Address(obj, ObjectGroup::offsetOfClasp()), obj);
        masm.branchTest32(Assembler::NonZero,
                          Address(obj, Class::offsetOfFlags()),
                          Imm32(JSCLASS_EMULATES_UNDEFINED),
                          &emulatesUndefined);
        masm.moveValue(BooleanValue(op == JSOP_NE), R0);
        EmitReturnFromIC(masm);
        masm.bind(&emulatesUndefined);
        masm.moveValue(BooleanValue(op == JSOP_EQ), R0);
        EmitReturnFromIC(masm);
    }

    masm.bind(&notObject);

    // Also support null == null or undefined == undefined comparisons.
    if (compareWithNull)
        masm.branchTestNull(Assembler::NotEqual, objectOperand, &failure);
    else
        masm.branchTestUndefined(Assembler::NotEqual, objectOperand, &failure);

    masm.moveValue(BooleanValue(op == JSOP_STRICTEQ || op == JSOP_EQ), R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// Compare_Int32WithBoolean
//

bool
ICCompare_Int32WithBoolean::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    ValueOperand int32Val;
    ValueOperand boolVal;
    if (lhsIsInt32_) {
        int32Val = R0;
        boolVal = R1;
    } else {
        boolVal = R0;
        int32Val = R1;
    }
    masm.branchTestBoolean(Assembler::NotEqual, boolVal, &failure);
    masm.branchTestInt32(Assembler::NotEqual, int32Val, &failure);

    if (op_ == JSOP_STRICTEQ || op_ == JSOP_STRICTNE) {
        // Ints and booleans are never strictly equal, always strictly not equal.
        masm.moveValue(BooleanValue(op_ == JSOP_STRICTNE), R0);
        EmitReturnFromIC(masm);
    } else {
        Register boolReg = masm.extractBoolean(boolVal, ExtractTemp0);
        Register int32Reg = masm.extractInt32(int32Val, ExtractTemp1);

        // Compare payload regs of R0 and R1.
        Assembler::Condition cond = JSOpToCondition(op_, /* signed = */true);
        masm.cmp32Set(cond, (lhsIsInt32_ ? int32Reg : boolReg),
                      (lhsIsInt32_ ? boolReg : int32Reg), R0.scratchReg());

        // Box the result and return
        masm.tagValue(JSVAL_TYPE_BOOLEAN, R0.scratchReg(), R0);
        EmitReturnFromIC(masm);
    }

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// GetProp_Fallback
//

static bool
TryAttachMagicArgumentsGetPropStub(JSContext* cx, SharedStubInfo* info,
                                   ICGetProp_Fallback* stub, HandlePropertyName name,
                                   HandleValue val, HandleValue res, bool* attached)
{
    MOZ_ASSERT(!*attached);

    if (!val.isMagic(JS_OPTIMIZED_ARGUMENTS))
        return true;

    // Try handling arguments.callee on optimized arguments.
    if (name == cx->names().callee) {
        MOZ_ASSERT(info->script()->hasMappedArgsObj());

        JitSpew(JitSpew_BaselineIC, "  Generating GetProp(MagicArgs.callee) stub");

        // Unlike ICGetProp_ArgumentsLength, only magic argument stubs are
        // supported at the moment.
        ICStub* monitorStub = stub->fallbackMonitorStub()->firstMonitorStub();
        ICGetProp_ArgumentsCallee::Compiler compiler(cx, info->engine(), monitorStub);
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!newStub)
            return false;
        stub->addNewStub(newStub);

        *attached = true;
        return true;
    }

    return true;
}

static bool
TryAttachLengthStub(JSContext* cx, SharedStubInfo* info,
                    ICGetProp_Fallback* stub, HandleValue val,
                    HandleValue res, bool* attached)
{
    MOZ_ASSERT(!*attached);

    if (val.isString()) {
        MOZ_ASSERT(res.isInt32());
        JitSpew(JitSpew_BaselineIC, "  Generating GetProp(String.length) stub");
        ICGetProp_StringLength::Compiler compiler(cx, info->engine());
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!newStub)
            return false;

        *attached = true;
        stub->addNewStub(newStub);
        return true;
    }

    if (val.isMagic(JS_OPTIMIZED_ARGUMENTS) && res.isInt32()) {
        JitSpew(JitSpew_BaselineIC, "  Generating GetProp(MagicArgs.length) stub");
        ICGetProp_ArgumentsLength::Compiler compiler(cx, info->engine(), ICGetProp_ArgumentsLength::Magic);
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!newStub)
            return false;

        *attached = true;
        stub->addNewStub(newStub);
        return true;
    }

    return true;
}

static bool
UpdateExistingGenerationalDOMProxyStub(ICGetProp_Fallback* stub,
                                       HandleObject obj)
{
    Value expandoSlot = GetProxyExtra(obj, GetDOMProxyExpandoSlot());
    MOZ_ASSERT(!expandoSlot.isObject() && !expandoSlot.isUndefined());
    ExpandoAndGeneration* expandoAndGeneration = (ExpandoAndGeneration*)expandoSlot.toPrivate();
    for (ICStubConstIterator iter = stub->beginChainConst(); !iter.atEnd(); iter++) {
        if (iter->isGetProp_CallDOMProxyWithGenerationNative()) {
            ICGetProp_CallDOMProxyWithGenerationNative* updateStub =
                iter->toGetProp_CallDOMProxyWithGenerationNative();
            if (updateStub->expandoAndGeneration() == expandoAndGeneration) {
                // Update generation
                uint64_t generation = expandoAndGeneration->generation;
                JitSpew(JitSpew_BaselineIC,
                        "  Updating existing stub with generation, old value: %" PRIu64 ", "
                        "new value: %" PRIu64 "", updateStub->generation(),
                        generation);
                updateStub->setGeneration(generation);
                return true;
            }
        }
    }
    return false;
}

// Return whether obj is in some PreliminaryObjectArray and has a structure
// that might change in the future.
bool
IsPreliminaryObject(JSObject* obj)
{
    if (obj->isSingleton())
        return false;

    TypeNewScript* newScript = obj->group()->newScript();
    if (newScript && !newScript->analyzed())
        return true;

    if (obj->group()->maybePreliminaryObjects())
        return true;

    return false;
}

void
StripPreliminaryObjectStubs(JSContext* cx, ICFallbackStub* stub)
{
    // Before the new script properties analysis has been performed on a type,
    // all instances of that type have the maximum number of fixed slots.
    // Afterwards, the objects (even the preliminary ones) might be changed
    // to reduce the number of fixed slots they have. If we generate stubs for
    // both the old and new number of fixed slots, the stub will look
    // polymorphic to IonBuilder when it is actually monomorphic. To avoid
    // this, strip out any stubs for preliminary objects before attaching a new
    // stub which isn't on a preliminary object.

    for (ICStubIterator iter = stub->beginChain(); !iter.atEnd(); iter++) {
        if (iter->isCacheIR_Monitored() && iter->toCacheIR_Monitored()->hasPreliminaryObject())
            iter.unlink(cx);
        else if (iter->isSetProp_Native() && iter->toSetProp_Native()->hasPreliminaryObject())
            iter.unlink(cx);
    }
}

JSObject*
GetDOMProxyProto(JSObject* obj)
{
    MOZ_ASSERT(IsCacheableDOMProxy(obj));
    return obj->staticPrototype();
}

// Look up a property's shape on an object, being careful never to do any effectful
// operations.  This procedure not yielding a shape should not be taken as a lack of
// existence of the property on the object.
bool
EffectlesslyLookupProperty(JSContext* cx, HandleObject obj, HandleId id,
                           MutableHandleObject holder, MutableHandleShape shape,
                           bool* checkDOMProxy,
                           DOMProxyShadowsResult* shadowsResult,
                           bool* domProxyHasGeneration)
{
    shape.set(nullptr);
    holder.set(nullptr);

    if (checkDOMProxy) {
        *checkDOMProxy = false;
        *shadowsResult = ShadowCheckFailed;
    }

    // Check for list base if asked to.
    RootedObject checkObj(cx, obj);
    if (checkDOMProxy && IsCacheableDOMProxy(obj)) {
        MOZ_ASSERT(domProxyHasGeneration);
        MOZ_ASSERT(shadowsResult);

        *checkDOMProxy = true;
        if (obj->hasUncacheableProto())
            return true;

        *shadowsResult = GetDOMProxyShadowsCheck()(cx, obj, id);
        if (*shadowsResult == ShadowCheckFailed)
            return false;

        if (DOMProxyIsShadowing(*shadowsResult)) {
            holder.set(obj);
            return true;
        }

        *domProxyHasGeneration = (*shadowsResult == DoesntShadowUnique);

        checkObj = GetDOMProxyProto(obj);
        if (!checkObj)
            return true;
    }

    if (LookupPropertyPure(cx, checkObj, id, holder.address(), shape.address()))
        return true;

    holder.set(nullptr);
    shape.set(nullptr);
    return true;
}

bool
IsCacheableProtoChain(JSObject* obj, JSObject* holder, bool isDOMProxy)
{
    MOZ_ASSERT_IF(isDOMProxy, IsCacheableDOMProxy(obj));

    if (!isDOMProxy && !obj->isNative()) {
        if (obj == holder)
            return false;
        if (!obj->is<UnboxedPlainObject>() &&
            !obj->is<UnboxedArrayObject>() &&
            !obj->is<TypedObject>())
        {
            return false;
        }
    }

    JSObject* cur = obj;
    while (cur != holder) {
        // We cannot assume that we find the holder object on the prototype
        // chain and must check for null proto. The prototype chain can be
        // altered during the lookupProperty call.
        MOZ_ASSERT(!cur->hasDynamicPrototype());

        // Don't handle objects which require a prototype guard. This should
        // be uncommon so handling it is likely not worth the complexity.
        if (cur->hasUncacheableProto())
            return false;

        JSObject* proto = cur->staticPrototype();
        if (!proto || !proto->isNative())
            return false;

        cur = proto;
    }

    return true;
}

bool
IsCacheableGetPropReadSlot(JSObject* obj, JSObject* holder, Shape* shape, bool isDOMProxy)
{
    if (!shape || !IsCacheableProtoChain(obj, holder, isDOMProxy))
        return false;

    if (!shape->hasSlot() || !shape->hasDefaultGetter())
        return false;

    return true;
}

void
GetFixedOrDynamicSlotOffset(Shape* shape, bool* isFixed, uint32_t* offset)
{
    MOZ_ASSERT(isFixed);
    MOZ_ASSERT(offset);
    *isFixed = shape->slot() < shape->numFixedSlots();
    *offset = *isFixed ? NativeObject::getFixedSlotOffset(shape->slot())
                       : (shape->slot() - shape->numFixedSlots()) * sizeof(Value);
}

bool
IsCacheableGetPropCall(JSContext* cx, JSObject* obj, JSObject* holder, Shape* shape,
                       bool* isScripted, bool* isTemporarilyUnoptimizable, bool isDOMProxy)
{
    MOZ_ASSERT(isScripted);

    if (!shape || !IsCacheableProtoChain(obj, holder, isDOMProxy))
        return false;

    if (shape->hasSlot() || shape->hasDefaultGetter())
        return false;

    if (!shape->hasGetterValue())
        return false;

    if (!shape->getterValue().isObject() || !shape->getterObject()->is<JSFunction>())
        return false;

    JSFunction* func = &shape->getterObject()->as<JSFunction>();
    if (IsWindow(obj)) {
        if (!func->isNative())
            return false;

        if (!func->jitInfo() || func->jitInfo()->needsOuterizedThisObject())
            return false;
    }

    if (func->isNative()) {
        *isScripted = false;
        return true;
    }

    if (!func->hasJITCode()) {
        *isTemporarilyUnoptimizable = true;
        return false;
    }

    *isScripted = true;
    return true;
}

// Try to update all existing GetProp/GetName getter call stubs that match the
// given holder in place with a new shape and getter.  fallbackStub can be
// either an ICGetProp_Fallback or an ICGetName_Fallback.
//
// If 'getter' is an own property, holder == receiver must be true.
bool
UpdateExistingGetPropCallStubs(ICFallbackStub* fallbackStub,
                               ICStub::Kind kind,
                               HandleNativeObject holder,
                               HandleObject receiver,
                               HandleFunction getter)
{
    MOZ_ASSERT(kind == ICStub::GetProp_CallScripted ||
               kind == ICStub::GetProp_CallNative ||
               kind == ICStub::GetProp_CallNativeGlobal);
    MOZ_ASSERT(fallbackStub->isGetName_Fallback() ||
               fallbackStub->isGetProp_Fallback());
    MOZ_ASSERT(holder);
    MOZ_ASSERT(receiver);

    bool isOwnGetter = (holder == receiver);
    bool foundMatchingStub = false;
    ReceiverGuard receiverGuard(receiver);
    for (ICStubConstIterator iter = fallbackStub->beginChainConst(); !iter.atEnd(); iter++) {
        if (iter->kind() == kind) {
            ICGetPropCallGetter* getPropStub = static_cast<ICGetPropCallGetter*>(*iter);
            if (getPropStub->holder() == holder && getPropStub->isOwnGetter() == isOwnGetter) {
                // If this is an own getter, update the receiver guard as well,
                // since that's the shape we'll be guarding on. Furthermore,
                // isOwnGetter() relies on holderShape_ and receiverGuard_ being
                // the same shape.
                if (isOwnGetter)
                    getPropStub->receiverGuard().update(receiverGuard);

                MOZ_ASSERT(getPropStub->holderShape() != holder->lastProperty() ||
                           !getPropStub->receiverGuard().matches(receiverGuard) ||
                           getPropStub->toGetProp_CallNativeGlobal()->globalShape() !=
                           receiver->as<LexicalEnvironmentObject>().global().lastProperty(),
                           "Why didn't we end up using this stub?");

                // We want to update the holder shape to match the new one no
                // matter what, even if the receiver shape is different.
                getPropStub->holderShape() = holder->lastProperty();

                // Make sure to update the getter, since a shape change might
                // have changed which getter we want to use.
                getPropStub->getter() = getter;

                if (getPropStub->isGetProp_CallNativeGlobal()) {
                    ICGetProp_CallNativeGlobal* globalStub =
                        getPropStub->toGetProp_CallNativeGlobal();
                    globalStub->globalShape() =
                        receiver->as<LexicalEnvironmentObject>().global().lastProperty();
                }

                if (getPropStub->receiverGuard().matches(receiverGuard))
                    foundMatchingStub = true;
            }
        }
    }

    return foundMatchingStub;
}

static bool
TryAttachNativeGetAccessorPropStub(JSContext* cx, SharedStubInfo* info,
                                   ICGetProp_Fallback* stub, HandlePropertyName name,
                                   HandleValue val, HandleValue res, bool* attached,
                                   bool* isTemporarilyUnoptimizable)
{
    MOZ_ASSERT(!*attached);
    MOZ_ASSERT(!*isTemporarilyUnoptimizable);

    if (!val.isObject())
        return true;

    RootedObject obj(cx, &val.toObject());

    bool isDOMProxy;
    bool domProxyHasGeneration;
    DOMProxyShadowsResult domProxyShadowsResult;
    RootedShape shape(cx);
    RootedObject holder(cx);
    RootedId id(cx, NameToId(name));
    if (!EffectlesslyLookupProperty(cx, obj, id, &holder, &shape, &isDOMProxy,
                                    &domProxyShadowsResult, &domProxyHasGeneration))
    {
        return false;
    }

    ICStub* monitorStub = stub->fallbackMonitorStub()->firstMonitorStub();

    bool isScripted = false;
    bool cacheableCall = IsCacheableGetPropCall(cx, obj, holder, shape, &isScripted,
                                                isTemporarilyUnoptimizable,
                                                isDOMProxy);

    // Try handling scripted getters.
    if (cacheableCall && isScripted && !isDOMProxy &&
        info->engine() == ICStubCompiler::Engine::Baseline)
    {
        RootedFunction callee(cx, &shape->getterObject()->as<JSFunction>());
        MOZ_ASSERT(callee->hasScript());

        if (UpdateExistingGetPropCallStubs(stub, ICStub::GetProp_CallScripted,
                                           holder.as<NativeObject>(), obj, callee)) {
            *attached = true;
            return true;
        }

        JitSpew(JitSpew_BaselineIC, "  Generating GetProp(NativeObj/ScriptedGetter %s:%" PRIuSIZE ") stub",
                callee->nonLazyScript()->filename(), callee->nonLazyScript()->lineno());

        ICGetProp_CallScripted::Compiler compiler(cx, monitorStub, obj, holder, callee,
                                                  info->pcOffset());
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!newStub)
            return false;

        stub->addNewStub(newStub);
        *attached = true;
        return true;
    }

    // If it's a shadowed listbase proxy property, attach stub to call Proxy::get instead.
    if (isDOMProxy && DOMProxyIsShadowing(domProxyShadowsResult)) {
        MOZ_ASSERT(obj == holder);

        JitSpew(JitSpew_BaselineIC, "  Generating GetProp(DOMProxyProxy) stub");
        Rooted<ProxyObject*> proxy(cx, &obj->as<ProxyObject>());
        ICGetProp_DOMProxyShadowed::Compiler compiler(cx, info->engine(), monitorStub, proxy, name,
                                                      info->pcOffset());
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!newStub)
            return false;
        stub->addNewStub(newStub);
        *attached = true;
        return true;
    }

    const Class* outerClass = nullptr;
    if (!isDOMProxy && !obj->isNative()) {
        outerClass = obj->getClass();
        if (!IsWindowProxy(obj))
            return true;

        // This must be a WindowProxy for the current Window/global. Else it'd
        // be a cross-compartment wrapper and IsWindowProxy returns false for
        // those.
        MOZ_ASSERT(ToWindowIfWindowProxy(obj) == cx->global());
        obj = cx->global();

        if (!EffectlesslyLookupProperty(cx, obj, id, &holder, &shape, &isDOMProxy,
                                        &domProxyShadowsResult, &domProxyHasGeneration))
        {
            return false;
        }
        cacheableCall = IsCacheableGetPropCall(cx, obj, holder, shape, &isScripted,
                                               isTemporarilyUnoptimizable, isDOMProxy);
    }

    // Try handling JSNative getters.
    if (!cacheableCall || isScripted)
        return true;

    if (!shape || !shape->hasGetterValue() || !shape->getterValue().isObject() ||
        !shape->getterObject()->is<JSFunction>())
    {
        return true;
    }

    RootedFunction callee(cx, &shape->getterObject()->as<JSFunction>());
    MOZ_ASSERT(callee->isNative());

    if (outerClass && (!callee->jitInfo() || callee->jitInfo()->needsOuterizedThisObject()))
        return true;

    JitSpew(JitSpew_BaselineIC, "  Generating GetProp(%s%s/NativeGetter %p) stub",
            isDOMProxy ? "DOMProxyObj" : "NativeObj",
            isDOMProxy && domProxyHasGeneration ? "WithGeneration" : "",
            callee->native());

    ICStub* newStub = nullptr;
    if (isDOMProxy) {
        MOZ_ASSERT(obj != holder);
        ICStub::Kind kind;
        if (domProxyHasGeneration) {
            if (UpdateExistingGenerationalDOMProxyStub(stub, obj)) {
                *attached = true;
                return true;
            }
            kind = ICStub::GetProp_CallDOMProxyWithGenerationNative;
        } else {
            kind = ICStub::GetProp_CallDOMProxyNative;
        }
        Rooted<ProxyObject*> proxy(cx, &obj->as<ProxyObject>());
        ICGetPropCallDOMProxyNativeCompiler compiler(cx, kind, info->engine(), monitorStub, proxy, holder,
                                                     callee, info->pcOffset());
        newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
    } else {
        if (UpdateExistingGetPropCallStubs(stub, ICStub::GetProp_CallNative,
                                           holder.as<NativeObject>(), obj, callee))
        {
            *attached = true;
            return true;
        }

        ICGetPropCallNativeCompiler compiler(cx, ICStub::GetProp_CallNative, info->engine(),
                                             monitorStub, obj, holder, callee,
                                             info->pcOffset(), outerClass);
        newStub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
    }
    if (!newStub)
        return false;
    stub->addNewStub(newStub);
    *attached = true;
    return true;
}

bool
CheckHasNoSuchProperty(JSContext* cx, JSObject* obj, PropertyName* name,
                       JSObject** lastProto, size_t* protoChainDepthOut)
{
    size_t depth = 0;
    JSObject* curObj = obj;
    while (curObj) {
        if (curObj->isNative()) {
            // Don't handle proto chains with resolve hooks.
            if (ClassMayResolveId(cx->names(), curObj->getClass(), NameToId(name), curObj))
                return false;
            if (curObj->as<NativeObject>().contains(cx, NameToId(name)))
                return false;
            if (curObj->getClass()->getGetProperty())
                return false;
        } else if (curObj != obj) {
            // Non-native objects are only handled as the original receiver.
            return false;
        } else if (curObj->is<UnboxedPlainObject>()) {
            if (curObj->as<UnboxedPlainObject>().containsUnboxedOrExpandoProperty(cx, NameToId(name)))
                return false;
        } else if (curObj->is<UnboxedArrayObject>()) {
            if (name == cx->names().length)
                return false;
        } else if (curObj->is<TypedObject>()) {
            if (curObj->as<TypedObject>().typeDescr().hasProperty(cx->names(), NameToId(name)))
                return false;
        } else {
            return false;
        }

        JSObject* proto = curObj->staticPrototype();
        if (!proto)
            break;

        curObj = proto;
        depth++;
    }

    if (lastProto)
        *lastProto = curObj;
    if (protoChainDepthOut)
        *protoChainDepthOut = depth;
    return true;
}

static bool
ComputeGetPropResult(JSContext* cx, BaselineFrame* frame, JSOp op, HandlePropertyName name,
                     MutableHandleValue val, MutableHandleValue res)
{
    // Handle arguments.length and arguments.callee on optimized arguments, as
    // it is not an object.
    if (frame && val.isMagic(JS_OPTIMIZED_ARGUMENTS) && IsOptimizedArguments(frame, val)) {
        if (op == JSOP_LENGTH) {
            res.setInt32(frame->numActualArgs());
        } else {
            MOZ_ASSERT(name == cx->names().callee);
            MOZ_ASSERT(frame->script()->hasMappedArgsObj());
            res.setObject(*frame->callee());
        }
    } else {
        if (op == JSOP_GETXPROP) {
            RootedObject obj(cx, &val.toObject());
            RootedId id(cx, NameToId(name));
            if (!GetPropertyForNameLookup(cx, obj, id, res))
                return false;
        } else {
            MOZ_ASSERT(op == JSOP_GETPROP || op == JSOP_CALLPROP || op == JSOP_LENGTH);
            if (!GetProperty(cx, val, name, res))
                return false;
        }
    }

    return true;
}

static bool
DoGetPropFallback(JSContext* cx, void* payload, ICGetProp_Fallback* stub_,
                  MutableHandleValue val, MutableHandleValue res)
{
    SharedStubInfo info(cx, payload, stub_->icEntry());
    ICStubCompiler::Engine engine = info.engine();
    HandleScript script = info.innerScript();

    // This fallback stub may trigger debug mode toggling.
    DebugModeOSRVolatileStub<ICGetProp_Fallback*> stub(engine, info.maybeFrame(), stub_);

    jsbytecode* pc = info.pc();
    JSOp op = JSOp(*pc);
    FallbackICSpew(cx, stub, "GetProp(%s)", CodeName[op]);

    MOZ_ASSERT(op == JSOP_GETPROP || op == JSOP_CALLPROP || op == JSOP_LENGTH || op == JSOP_GETXPROP);

    // Grab our old shape before it goes away.
    RootedShape oldShape(cx);
    if (val.isObject())
        oldShape = val.toObject().maybeShape();

    bool attached = false;
    // There are some reasons we can fail to attach a stub that are temporary.
    // We want to avoid calling noteUnoptimizableAccess() if the reason we
    // failed to attach a stub is one of those temporary reasons, since we might
    // end up attaching a stub for the exact same access later.
    bool isTemporarilyUnoptimizable = false;

    RootedPropertyName name(cx, script->getName(pc));

    // After the Genericstub was added, we should never reach the Fallbackstub again.
    MOZ_ASSERT(!stub->hasStub(ICStub::GetProp_Generic));

    if (stub->numOptimizedStubs() >= ICGetProp_Fallback::MAX_OPTIMIZED_STUBS && !stub.invalid()) {
        // Discard all stubs in this IC and replace with generic getprop stub.
        for (ICStubIterator iter = stub->beginChain(); !iter.atEnd(); iter++)
            iter.unlink(cx);
        ICGetProp_Generic::Compiler compiler(cx, engine,
                                             stub->fallbackMonitorStub()->firstMonitorStub());
        ICStub* newStub = compiler.getStub(compiler.getStubSpace(info.outerScript(cx)));
        if (!newStub)
            return false;
        stub->addNewStub(newStub);
        attached = true;
    }

    if (!attached && !JitOptions.disableCacheIR) {
        mozilla::Maybe<CacheIRWriter> writer;
        GetPropIRGenerator gen(cx, pc, val, name, res);
        if (!gen.tryAttachStub(writer))
            return false;
        if (gen.emitted()) {
            ICStub* newStub = AttachBaselineCacheIRStub(cx, writer.ref(), CacheKind::GetProp, stub);
            if (newStub) {
                JitSpew(JitSpew_BaselineIC, "  Attached CacheIR stub");
                attached = true;
                if (gen.shouldNotePreliminaryObjectStub())
                    newStub->toCacheIR_Monitored()->notePreliminaryObject();
                else if (gen.shouldUnlinkPreliminaryObjectStubs())
                    StripPreliminaryObjectStubs(cx, stub);
            }
        }
    }

    if (!attached && !stub.invalid() &&
        !TryAttachNativeGetAccessorPropStub(cx, &info, stub, name, val, res, &attached,
                                            &isTemporarilyUnoptimizable))
    {
        return false;
    }

    if (!ComputeGetPropResult(cx, info.maybeFrame(), op, name, val, res))
        return false;

    TypeScript::Monitor(cx, script, pc, res);

    // Check if debug mode toggling made the stub invalid.
    if (stub.invalid())
        return true;

    // Add a type monitor stub for the resulting value.
    if (!stub->addMonitorStubForValue(cx, &info, res))
        return false;

    if (attached)
        return true;

    if (op == JSOP_LENGTH) {
        if (!TryAttachLengthStub(cx, &info, stub, val, res, &attached))
            return false;
        if (attached)
            return true;
    }

    if (!TryAttachMagicArgumentsGetPropStub(cx, &info, stub, name, val,
                                            res, &attached))
        return false;
    if (attached)
        return true;


    MOZ_ASSERT(!attached);
    if (!isTemporarilyUnoptimizable)
        stub->noteUnoptimizableAccess();

    return true;
}

typedef bool (*DoGetPropFallbackFn)(JSContext*, void*, ICGetProp_Fallback*,
                                    MutableHandleValue, MutableHandleValue);
static const VMFunction DoGetPropFallbackInfo =
    FunctionInfo<DoGetPropFallbackFn>(DoGetPropFallback, "DoGetPropFallback", TailCall,
                                      PopValues(1));

bool
ICGetProp_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(R0 == JSReturnOperand);

    EmitRestoreTailCallReg(masm);

    // Ensure stack is fully synced for the expression decompiler.
    masm.pushValue(R0);

    // Push arguments.
    masm.pushValue(R0);
    masm.push(ICStubReg);
    pushStubPayload(masm, R0.scratchReg());

    if (!tailCallVM(DoGetPropFallbackInfo, masm))
        return false;

    // Even though the fallback frame doesn't enter a stub frame, the CallScripted
    // frame that we are emulating does. Again, we lie.
#ifdef DEBUG
    EmitRepushTailCallReg(masm);
    enterStubFrame(masm, R0.scratchReg());
#else
    inStubFrame_ = true;
#endif

    // What follows is bailout for inlined scripted getters.
    // The return address pointed to by the baseline stack points here.
    returnOffset_ = masm.currentOffset();

    leaveStubFrame(masm, true);

    // When we get here, ICStubReg contains the ICGetProp_Fallback stub,
    // which we can't use to enter the TypeMonitor IC, because it's a MonitoredFallbackStub
    // instead of a MonitoredStub. So, we cheat.
    masm.loadPtr(Address(ICStubReg, ICMonitoredFallbackStub::offsetOfFallbackMonitorStub()),
                 ICStubReg);
    EmitEnterTypeMonitorIC(masm, ICTypeMonitor_Fallback::offsetOfFirstMonitorStub());

    return true;
}

void
ICGetProp_Fallback::Compiler::postGenerateStubCode(MacroAssembler& masm, Handle<JitCode*> code)
{
    if (engine_ == Engine::Baseline) {
        void* address = code->raw() + returnOffset_;
        cx->compartment()->jitCompartment()->initBaselineGetPropReturnAddr(address);
    }
}

bool
ICGetProp_StringLength::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestString(Assembler::NotEqual, R0, &failure);

    // Unbox string and load its length.
    Register string = masm.extractString(R0, ExtractTemp0);
    masm.loadStringLength(string, string);

    masm.tagValue(JSVAL_TYPE_INT32, string, R0);
    EmitReturnFromIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

ICGetPropNativeStub*
ICGetPropNativeCompiler::getStub(ICStubSpace* space)
{
    ReceiverGuard guard(obj_);

    switch (kind) {
      case ICStub::GetName_Global: {
        MOZ_ASSERT(obj_ != holder_);
        Shape* holderShape = holder_->as<NativeObject>().lastProperty();
        Shape* globalShape = obj_->as<LexicalEnvironmentObject>().global().lastProperty();
        return newStub<ICGetName_Global>(space, getStubCode(), firstMonitorStub_, guard,
                                         offset_, holder_, holderShape, globalShape);
      }

      default:
        MOZ_CRASH("Bad stub kind");
    }
}

void
GuardReceiverObject(MacroAssembler& masm, ReceiverGuard guard,
                    Register object, Register scratch,
                    size_t receiverGuardOffset, Label* failure)
{
    Address groupAddress(ICStubReg, receiverGuardOffset + HeapReceiverGuard::offsetOfGroup());
    Address shapeAddress(ICStubReg, receiverGuardOffset + HeapReceiverGuard::offsetOfShape());
    Address expandoAddress(object, UnboxedPlainObject::offsetOfExpando());

    if (guard.group) {
        masm.loadPtr(groupAddress, scratch);
        masm.branchTestObjGroup(Assembler::NotEqual, object, scratch, failure);

        if (guard.group->clasp() == &UnboxedPlainObject::class_ && !guard.shape) {
            // Guard the unboxed object has no expando object.
            masm.branchPtr(Assembler::NotEqual, expandoAddress, ImmWord(0), failure);
        }
    }

    if (guard.shape) {
        masm.loadPtr(shapeAddress, scratch);
        if (guard.group && guard.group->clasp() == &UnboxedPlainObject::class_) {
            // Guard the unboxed object has a matching expando object.
            masm.branchPtr(Assembler::Equal, expandoAddress, ImmWord(0), failure);
            Label done;
            masm.push(object);
            masm.loadPtr(expandoAddress, object);
            masm.branchTestObjShape(Assembler::Equal, object, scratch, &done);
            masm.pop(object);
            masm.jump(failure);
            masm.bind(&done);
            masm.pop(object);
        } else {
            masm.branchTestObjShape(Assembler::NotEqual, object, scratch, failure);
        }
    }
}

static void
GuardGlobalObject(MacroAssembler& masm, HandleObject holder, Register globalLexicalReg,
                  Register holderReg, Register scratch, size_t globalShapeOffset, Label* failure)
{
    if (holder->is<GlobalObject>())
        return;
    masm.extractObject(Address(globalLexicalReg, EnvironmentObject::offsetOfEnclosingEnvironment()),
                       holderReg);
    masm.loadPtr(Address(ICStubReg, globalShapeOffset), scratch);
    masm.branchTestObjShape(Assembler::NotEqual, holderReg, scratch, failure);
}

bool
ICGetPropNativeCompiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    AllocatableGeneralRegisterSet regs(availableGeneralRegs(0));
    Register objReg = InvalidReg;

    if (inputDefinitelyObject_) {
        objReg = R0.scratchReg();
    } else {
        regs.take(R0);
        // Guard input is an object and unbox.
        masm.branchTestObject(Assembler::NotEqual, R0, &failure);
        objReg = masm.extractObject(R0, ExtractTemp0);
    }
    regs.takeUnchecked(objReg);

    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Shape/group guard.
    GuardReceiverObject(masm, ReceiverGuard(obj_), objReg, scratch,
                        ICGetPropNativeStub::offsetOfReceiverGuard(), &failure);

    MOZ_ASSERT(obj_ != holder_);
    MOZ_ASSERT(kind == ICStub::GetName_Global);

    Register holderReg = regs.takeAny();

    // If we are generating a non-lexical GETGNAME stub, we must also
    // guard on the shape of the GlobalObject.
    MOZ_ASSERT(obj_->is<LexicalEnvironmentObject>() &&
               obj_->as<LexicalEnvironmentObject>().isGlobal());
    GuardGlobalObject(masm, holder_, objReg, holderReg, scratch,
                      ICGetName_Global::offsetOfGlobalShape(), &failure);

    // Shape guard holder.
    masm.loadPtr(Address(ICStubReg, ICGetName_Global::offsetOfHolder()),
                 holderReg);
    masm.loadPtr(Address(ICStubReg, ICGetName_Global::offsetOfHolderShape()),
                 scratch);
    masm.branchTestObjShape(Assembler::NotEqual, holderReg, scratch, &failure);

    if (!isFixedSlot_) {
        // Don't overwrite actual holderReg if we need to load a dynamic slots object.
        // May need to preserve object for noSuchMethod check later.
        Register nextHolder = regs.takeAny();
        masm.loadPtr(Address(holderReg, NativeObject::offsetOfSlots()), nextHolder);
        holderReg = nextHolder;
    }

    masm.load32(Address(ICStubReg, ICGetPropNativeStub::offsetOfOffset()), scratch);
    BaseIndex result(holderReg, scratch, TimesOne);

    masm.loadValue(result, R0);

    // Enter type monitor IC to type-check result.
    EmitEnterTypeMonitorIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
GetProtoShapes(JSObject* obj, size_t protoChainDepth, MutableHandle<ShapeVector> shapes)
{
    JSObject* curProto = obj->staticPrototype();
    for (size_t i = 0; i < protoChainDepth; i++) {
        if (!shapes.append(curProto->as<NativeObject>().lastProperty()))
            return false;
        curProto = curProto->staticPrototype();
    }

    MOZ_ASSERT(!curProto,
               "longer prototype chain encountered than this stub permits!");
    return true;
}

bool
ICGetProp_CallScripted::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(engine_ == Engine::Baseline);

    Label failure;
    Label failureLeaveStubFrame;
    AllocatableGeneralRegisterSet regs(availableGeneralRegs(1));
    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Guard input is an object.
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);

    // Unbox and shape guard.
    Register objReg = masm.extractObject(R0, ExtractTemp0);
    GuardReceiverObject(masm, ReceiverGuard(receiver_), objReg, scratch,
                        ICGetProp_CallScripted::offsetOfReceiverGuard(), &failure);

    if (receiver_ != holder_) {
        Register holderReg = regs.takeAny();
        masm.loadPtr(Address(ICStubReg, ICGetProp_CallScripted::offsetOfHolder()), holderReg);
        masm.loadPtr(Address(ICStubReg, ICGetProp_CallScripted::offsetOfHolderShape()), scratch);
        masm.branchTestObjShape(Assembler::NotEqual, holderReg, scratch, &failure);
        regs.add(holderReg);
    }

    // Push a stub frame so that we can perform a non-tail call.
    enterStubFrame(masm, scratch);

    // Load callee function and code.  To ensure that |code| doesn't end up being
    // ArgumentsRectifierReg, if it's available we assign it to |callee| instead.
    Register callee;
    if (regs.has(ArgumentsRectifierReg)) {
        callee = ArgumentsRectifierReg;
        regs.take(callee);
    } else {
        callee = regs.takeAny();
    }
    Register code = regs.takeAny();
    masm.loadPtr(Address(ICStubReg, ICGetProp_CallScripted::offsetOfGetter()), callee);
    masm.branchIfFunctionHasNoScript(callee, &failureLeaveStubFrame);
    masm.loadPtr(Address(callee, JSFunction::offsetOfNativeOrScript()), code);
    masm.loadBaselineOrIonRaw(code, code, &failureLeaveStubFrame);

    // Align the stack such that the JitFrameLayout is aligned on
    // JitStackAlignment.
    masm.alignJitStackBasedOnNArgs(0);

    // Getter is called with 0 arguments, just |obj| as thisv.
    // Note that we use Push, not push, so that callJit will align the stack
    // properly on ARM.
    masm.Push(R0);
    EmitBaselineCreateStubFrameDescriptor(masm, scratch, JitFrameLayout::Size());
    masm.Push(Imm32(0));  // ActualArgc is 0
    masm.Push(callee);
    masm.Push(scratch);

    // Handle arguments underflow.
    Label noUnderflow;
    masm.load16ZeroExtend(Address(callee, JSFunction::offsetOfNargs()), scratch);
    masm.branch32(Assembler::Equal, scratch, Imm32(0), &noUnderflow);
    {
        // Call the arguments rectifier.
        MOZ_ASSERT(ArgumentsRectifierReg != code);

        JitCode* argumentsRectifier =
            cx->runtime()->jitRuntime()->getArgumentsRectifier();

        masm.movePtr(ImmGCPtr(argumentsRectifier), code);
        masm.loadPtr(Address(code, JitCode::offsetOfCode()), code);
        masm.movePtr(ImmWord(0), ArgumentsRectifierReg);
    }

    masm.bind(&noUnderflow);
    masm.callJit(code);

    leaveStubFrame(masm, true);

    // Enter type monitor IC to type-check result.
    EmitEnterTypeMonitorIC(masm);

    // Leave stub frame and go to next stub.
    masm.bind(&failureLeaveStubFrame);
    inStubFrame_ = true;
    leaveStubFrame(masm, false);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

//
// VM function to help call native getters.
//

bool
DoCallNativeGetter(JSContext* cx, HandleFunction callee, HandleObject obj,
                   MutableHandleValue result)
{
    MOZ_ASSERT(callee->isNative());
    JSNative natfun = callee->native();

    JS::AutoValueArray<2> vp(cx);
    vp[0].setObject(*callee.get());
    vp[1].setObject(*obj.get());

    if (!natfun(cx, 0, vp.begin()))
        return false;

    result.set(vp[0]);
    return true;
}

typedef bool (*DoCallNativeGetterFn)(JSContext*, HandleFunction, HandleObject, MutableHandleValue);
static const VMFunction DoCallNativeGetterInfo =
    FunctionInfo<DoCallNativeGetterFn>(DoCallNativeGetter, "DoCallNativeGetter");

bool
ICGetPropCallNativeCompiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;

    AllocatableGeneralRegisterSet regs(availableGeneralRegs(1));
    Register objReg = InvalidReg;

    MOZ_ASSERT(!(inputDefinitelyObject_ && outerClass_));
    if (inputDefinitelyObject_) {
        objReg = R0.scratchReg();
    } else {
        // Guard input is an object and unbox.
        masm.branchTestObject(Assembler::NotEqual, R0, &failure);
        objReg = masm.extractObject(R0, ExtractTemp0);
        if (outerClass_) {
            Register tmp = regs.takeAny();
            masm.branchTestObjClass(Assembler::NotEqual, objReg, tmp, outerClass_, &failure);
            masm.movePtr(ImmGCPtr(cx->global()), objReg);
            regs.add(tmp);
        }
    }

    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Shape guard.
    GuardReceiverObject(masm, ReceiverGuard(receiver_), objReg, scratch,
                        ICGetPropCallGetter::offsetOfReceiverGuard(), &failure);

    if (receiver_ != holder_) {
        Register holderReg = regs.takeAny();

        // If we are generating a non-lexical GETGNAME stub, we must also
        // guard on the shape of the GlobalObject.
        if (kind == ICStub::GetProp_CallNativeGlobal) {
            MOZ_ASSERT(receiver_->is<LexicalEnvironmentObject>() &&
                       receiver_->as<LexicalEnvironmentObject>().isGlobal());
            GuardGlobalObject(masm, holder_, objReg, holderReg, scratch,
                              ICGetProp_CallNativeGlobal::offsetOfGlobalShape(), &failure);
        }

        masm.loadPtr(Address(ICStubReg, ICGetPropCallGetter::offsetOfHolder()), holderReg);
        masm.loadPtr(Address(ICStubReg, ICGetPropCallGetter::offsetOfHolderShape()), scratch);
        masm.branchTestObjShape(Assembler::NotEqual, holderReg, scratch, &failure);
        regs.add(holderReg);
    }

    // Box and push obj onto baseline frame stack for decompiler
    if (engine_ == Engine::Baseline) {
        if (inputDefinitelyObject_)
            masm.tagValue(JSVAL_TYPE_OBJECT, objReg, R0);
        EmitStowICValues(masm, 1);
        if (inputDefinitelyObject_)
            objReg = masm.extractObject(R0, ExtractTemp0);
    }

    // Push a stub frame so that we can perform a non-tail call.
    enterStubFrame(masm, scratch);

    // Load callee function.
    Register callee = regs.takeAny();
    masm.loadPtr(Address(ICStubReg, ICGetPropCallGetter::offsetOfGetter()), callee);

    // If we're calling a getter on the global, inline the logic for the
    // 'this' hook on the global lexical scope and manually push the global.
    if (kind == ICStub::GetProp_CallNativeGlobal)
        masm.extractObject(Address(objReg, EnvironmentObject::offsetOfEnclosingEnvironment()),
                           objReg);

    // Push args for vm call.
    masm.Push(objReg);
    masm.Push(callee);

    regs.add(R0);

    if (!callVM(DoCallNativeGetterInfo, masm))
        return false;
    leaveStubFrame(masm);

    if (engine_ == Engine::Baseline)
        EmitUnstowICValues(masm, 1, /* discard = */true);

    // Enter type monitor IC to type-check result.
    EmitEnterTypeMonitorIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

ICStub*
ICGetPropCallNativeCompiler::getStub(ICStubSpace* space)
{
    ReceiverGuard guard(receiver_);
    Shape* holderShape = holder_->as<NativeObject>().lastProperty();

    switch (kind) {
      case ICStub::GetProp_CallNative:
        return newStub<ICGetProp_CallNative>(space, getStubCode(), firstMonitorStub_,
                                             guard, holder_, holderShape,
                                             getter_, pcOffset_);

      case ICStub::GetProp_CallNativeGlobal: {
        Shape* globalShape = receiver_->as<LexicalEnvironmentObject>().global().lastProperty();
        return newStub<ICGetProp_CallNativeGlobal>(space, getStubCode(), firstMonitorStub_,
                                                   guard, holder_, holderShape, globalShape,
                                                   getter_, pcOffset_);
      }

      default:
        MOZ_CRASH("Bad stub kind");
    }
}

// Callers are expected to have already guarded on the shape of the
// object, which guarantees the object is a DOM proxy.
void
CheckDOMProxyExpandoDoesNotShadow(JSContext* cx, MacroAssembler& masm, Register object,
                                  const Address& checkExpandoShapeAddr,
                                  Address* expandoAndGenerationAddr,
                                  Address* generationAddr,
                                  Register scratch,
                                  AllocatableGeneralRegisterSet& domProxyRegSet,
                                  Label* checkFailed)
{
    // Guard that the object does not have expando properties, or has an expando
    // which is known to not have the desired property.

    // For the remaining code, we need to reserve some registers to load a value.
    // This is ugly, but unavoidable.
    ValueOperand tempVal = domProxyRegSet.takeAnyValue();
    masm.pushValue(tempVal);

    Label failDOMProxyCheck;
    Label domProxyOk;

    masm.loadPtr(Address(object, ProxyObject::offsetOfValues()), scratch);
    Address expandoAddr(scratch, ProxyObject::offsetOfExtraSlotInValues(GetDOMProxyExpandoSlot()));

    if (expandoAndGenerationAddr) {
        MOZ_ASSERT(generationAddr);

        masm.loadPtr(*expandoAndGenerationAddr, tempVal.scratchReg());
        masm.branchPrivatePtr(Assembler::NotEqual, expandoAddr, tempVal.scratchReg(),
                              &failDOMProxyCheck);

        masm.branch64(Assembler::NotEqual,
                      Address(tempVal.scratchReg(), ExpandoAndGeneration::offsetOfGeneration()),
                      *generationAddr,
                      scratch, &failDOMProxyCheck);

        masm.loadValue(Address(tempVal.scratchReg(), 0), tempVal);
    } else {
        masm.loadValue(expandoAddr, tempVal);
    }

    // If the incoming object does not have an expando object then we're sure we're not
    // shadowing.
    masm.branchTestUndefined(Assembler::Equal, tempVal, &domProxyOk);

    // The reference object used to generate this check may not have had an
    // expando object at all, in which case the presence of a non-undefined
    // expando value in the incoming object is automatically a failure.
    masm.loadPtr(checkExpandoShapeAddr, scratch);
    masm.branchPtr(Assembler::Equal, scratch, ImmPtr(nullptr), &failDOMProxyCheck);

    // Otherwise, ensure that the incoming object has an object for its expando value and that
    // the shape matches.
    masm.branchTestObject(Assembler::NotEqual, tempVal, &failDOMProxyCheck);
    Register objReg = masm.extractObject(tempVal, tempVal.scratchReg());
    masm.branchTestObjShape(Assembler::Equal, objReg, scratch, &domProxyOk);

    // Failure case: restore the tempVal registers and jump to failures.
    masm.bind(&failDOMProxyCheck);
    masm.popValue(tempVal);
    masm.jump(checkFailed);

    // Success case: restore the tempval and proceed.
    masm.bind(&domProxyOk);
    masm.popValue(tempVal);
}

bool
ICGetPropCallDOMProxyNativeCompiler::generateStubCode(MacroAssembler& masm,
                                                      Address* expandoAndGenerationAddr,
                                                      Address* generationAddr)
{
    Label failure;
    AllocatableGeneralRegisterSet regs(availableGeneralRegs(1));
    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Guard input is an object.
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);

    // Unbox.
    Register objReg = masm.extractObject(R0, ExtractTemp0);

    // Shape guard.
    static const size_t receiverShapeOffset =
        ICGetProp_CallDOMProxyNative::offsetOfReceiverGuard() +
        HeapReceiverGuard::offsetOfShape();
    masm.loadPtr(Address(ICStubReg, receiverShapeOffset), scratch);
    masm.branchTestObjShape(Assembler::NotEqual, objReg, scratch, &failure);

    // Guard that our expando object hasn't started shadowing this property.
    {
        AllocatableGeneralRegisterSet domProxyRegSet(GeneralRegisterSet::All());
        domProxyRegSet.take(ICStubReg);
        domProxyRegSet.take(objReg);
        domProxyRegSet.take(scratch);
        Address expandoShapeAddr(ICStubReg, ICGetProp_CallDOMProxyNative::offsetOfExpandoShape());
        CheckDOMProxyExpandoDoesNotShadow(
                cx, masm, objReg,
                expandoShapeAddr, expandoAndGenerationAddr, generationAddr,
                scratch,
                domProxyRegSet,
                &failure);
    }

    Register holderReg = regs.takeAny();
    masm.loadPtr(Address(ICStubReg, ICGetProp_CallDOMProxyNative::offsetOfHolder()),
                 holderReg);
    masm.loadPtr(Address(ICStubReg, ICGetProp_CallDOMProxyNative::offsetOfHolderShape()),
                 scratch);
    masm.branchTestObjShape(Assembler::NotEqual, holderReg, scratch, &failure);
    regs.add(holderReg);

    // Push a stub frame so that we can perform a non-tail call.
    enterStubFrame(masm, scratch);

    // Load callee function.
    Register callee = regs.takeAny();
    masm.loadPtr(Address(ICStubReg, ICGetProp_CallDOMProxyNative::offsetOfGetter()), callee);

    // Push args for vm call.
    masm.Push(objReg);
    masm.Push(callee);

    // Don't have to preserve R0 anymore.
    regs.add(R0);

    if (!callVM(DoCallNativeGetterInfo, masm))
        return false;
    leaveStubFrame(masm);

    // Enter type monitor IC to type-check result.
    EmitEnterTypeMonitorIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICGetPropCallDOMProxyNativeCompiler::generateStubCode(MacroAssembler& masm)
{
    if (kind == ICStub::GetProp_CallDOMProxyNative)
        return generateStubCode(masm, nullptr, nullptr);

    Address internalStructAddress(ICStubReg,
        ICGetProp_CallDOMProxyWithGenerationNative::offsetOfInternalStruct());
    Address generationAddress(ICStubReg,
        ICGetProp_CallDOMProxyWithGenerationNative::offsetOfGeneration());
    return generateStubCode(masm, &internalStructAddress, &generationAddress);
}

ICStub*
ICGetPropCallDOMProxyNativeCompiler::getStub(ICStubSpace* space)
{
    RootedShape shape(cx, proxy_->maybeShape());
    RootedShape holderShape(cx, holder_->as<NativeObject>().lastProperty());

    Value expandoSlot = GetProxyExtra(proxy_, GetDOMProxyExpandoSlot());
    RootedShape expandoShape(cx, nullptr);
    ExpandoAndGeneration* expandoAndGeneration;
    uint64_t generation;
    Value expandoVal;
    if (kind == ICStub::GetProp_CallDOMProxyNative) {
        expandoVal = expandoSlot;
        expandoAndGeneration = nullptr;  // initialize to silence GCC warning
        generation = 0;  // initialize to silence GCC warning
    } else {
        MOZ_ASSERT(kind == ICStub::GetProp_CallDOMProxyWithGenerationNative);
        MOZ_ASSERT(!expandoSlot.isObject() && !expandoSlot.isUndefined());
        expandoAndGeneration = (ExpandoAndGeneration*)expandoSlot.toPrivate();
        expandoVal = expandoAndGeneration->expando;
        generation = expandoAndGeneration->generation;
    }

    if (expandoVal.isObject())
        expandoShape = expandoVal.toObject().as<NativeObject>().lastProperty();

    if (kind == ICStub::GetProp_CallDOMProxyNative) {
        return newStub<ICGetProp_CallDOMProxyNative>(
            space, getStubCode(), firstMonitorStub_, shape,
            expandoShape, holder_, holderShape, getter_, pcOffset_);
    }

    return newStub<ICGetProp_CallDOMProxyWithGenerationNative>(
        space, getStubCode(), firstMonitorStub_, shape,
        expandoAndGeneration, generation, expandoShape, holder_, holderShape, getter_,
        pcOffset_);
}

ICStub*
ICGetProp_DOMProxyShadowed::Compiler::getStub(ICStubSpace* space)
{
    RootedShape shape(cx, proxy_->maybeShape());
    return New<ICGetProp_DOMProxyShadowed>(cx, space, getStubCode(), firstMonitorStub_, shape,
                                           proxy_->handler(), name_, pcOffset_);
}

static bool
ProxyGet(JSContext* cx, HandleObject proxy, HandlePropertyName name, MutableHandleValue vp)
{
    RootedValue receiver(cx, ObjectValue(*proxy));
    RootedId id(cx, NameToId(name));
    return Proxy::get(cx, proxy, receiver, id, vp);
}

typedef bool (*ProxyGetFn)(JSContext* cx, HandleObject proxy, HandlePropertyName name,
                           MutableHandleValue vp);
static const VMFunction ProxyGetInfo = FunctionInfo<ProxyGetFn>(ProxyGet, "ProxyGet");

bool
ICGetProp_DOMProxyShadowed::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;

    AllocatableGeneralRegisterSet regs(availableGeneralRegs(1));
    // Need to reserve a scratch register, but the scratch register should not be
    // ICTailCallReg, because it's used for |enterStubFrame| which needs a
    // non-ICTailCallReg scratch reg.
    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Guard input is an object.
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);

    // Unbox.
    Register objReg = masm.extractObject(R0, ExtractTemp0);

    // Shape guard.
    masm.loadPtr(Address(ICStubReg, ICGetProp_DOMProxyShadowed::offsetOfShape()), scratch);
    masm.branchTestObjShape(Assembler::NotEqual, objReg, scratch, &failure);

    // No need to do any more guards; it's safe to call ProxyGet even
    // if we've since stopped shadowing.

    // Call ProxyGet(JSContext* cx, HandleObject proxy, HandlePropertyName name, MutableHandleValue vp);

    // Push a stub frame so that we can perform a non-tail call.
    enterStubFrame(masm, scratch);

    // Push property name and proxy object.
    masm.loadPtr(Address(ICStubReg, ICGetProp_DOMProxyShadowed::offsetOfName()), scratch);
    masm.Push(scratch);
    masm.Push(objReg);

    // Don't have to preserve R0 anymore.
    regs.add(R0);

    if (!callVM(ProxyGetInfo, masm))
        return false;
    leaveStubFrame(masm);

    // Enter type monitor IC to type-check result.
    EmitEnterTypeMonitorIC(masm);

    // Failure case - jump to next stub
    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICGetProp_ArgumentsLength::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(which_ == ICGetProp_ArgumentsLength::Magic);

    Label failure;

    // Ensure that this is lazy arguments.
    masm.branchTestMagicValue(Assembler::NotEqual, R0, JS_OPTIMIZED_ARGUMENTS, &failure);

    // Ensure that frame has not loaded different arguments object since.
    masm.branchTest32(Assembler::NonZero,
                      Address(BaselineFrameReg, BaselineFrame::reverseOffsetOfFlags()),
                      Imm32(BaselineFrame::HAS_ARGS_OBJ),
                      &failure);

    Address actualArgs(BaselineFrameReg, BaselineFrame::offsetOfNumActualArgs());
    masm.loadPtr(actualArgs, R0.scratchReg());
    masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
    EmitReturnFromIC(masm);

    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

ICGetProp_ArgumentsCallee::ICGetProp_ArgumentsCallee(JitCode* stubCode, ICStub* firstMonitorStub)
  : ICMonitoredStub(GetProp_ArgumentsCallee, stubCode, firstMonitorStub)
{ }

bool
ICGetProp_ArgumentsCallee::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;

    // Ensure that this is lazy arguments.
    masm.branchTestMagicValue(Assembler::NotEqual, R0, JS_OPTIMIZED_ARGUMENTS, &failure);

    // Ensure that frame has not loaded different arguments object since.
    masm.branchTest32(Assembler::NonZero,
                      Address(BaselineFrameReg, BaselineFrame::reverseOffsetOfFlags()),
                      Imm32(BaselineFrame::HAS_ARGS_OBJ),
                      &failure);

    Address callee(BaselineFrameReg, BaselineFrame::offsetOfCalleeToken());
    masm.loadFunctionFromCalleeToken(callee, R0.scratchReg());
    masm.tagValue(JSVAL_TYPE_OBJECT, R0.scratchReg(), R0);

    EmitEnterTypeMonitorIC(masm);

    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

/* static */ ICGetProp_Generic*
ICGetProp_Generic::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                         ICGetProp_Generic& other)
{
    return New<ICGetProp_Generic>(cx, space, other.jitCode(), firstMonitorStub);
}

static bool
DoGetPropGeneric(JSContext* cx, void* payload, ICGetProp_Generic* stub,
                 MutableHandleValue val, MutableHandleValue res)
{
    ICFallbackStub* fallback = stub->getChainFallback();
    SharedStubInfo info(cx, payload, fallback->icEntry());
    HandleScript script = info.innerScript();
    jsbytecode* pc = info.pc();
    JSOp op = JSOp(*pc);
    RootedPropertyName name(cx, script->getName(pc));
    return ComputeGetPropResult(cx, info.maybeFrame(), op, name, val, res);
}

typedef bool (*DoGetPropGenericFn)(JSContext*, void*, ICGetProp_Generic*, MutableHandleValue, MutableHandleValue);
static const VMFunction DoGetPropGenericInfo =
    FunctionInfo<DoGetPropGenericFn>(DoGetPropGeneric, "DoGetPropGeneric");

bool
ICGetProp_Generic::Compiler::generateStubCode(MacroAssembler& masm)
{
    AllocatableGeneralRegisterSet regs(availableGeneralRegs(1));

    Register scratch = regs.takeAnyExcluding(ICTailCallReg);

    // Sync for the decompiler.
    if (engine_ == Engine::Baseline)
        EmitStowICValues(masm, 1);

    enterStubFrame(masm, scratch);

    // Push arguments.
    masm.Push(R0);
    masm.Push(ICStubReg);
    PushStubPayload(masm, R0.scratchReg());

    if (!callVM(DoGetPropGenericInfo, masm))
        return false;

    leaveStubFrame(masm);

    if (engine_ == Engine::Baseline)
        EmitUnstowICValues(masm, 1, /* discard = */ true);

    EmitEnterTypeMonitorIC(masm);
    return true;
}

void
CheckForTypedObjectWithDetachedStorage(JSContext* cx, MacroAssembler& masm, Label* failure)
{
    // All stubs manipulating typed objects must check the compartment-wide
    // flag indicating whether their underlying storage might be detached, to
    // bail out if needed.
    int32_t* address = &cx->compartment()->detachedTypedObjects;
    masm.branch32(Assembler::NotEqual, AbsoluteAddress(address), Imm32(0), failure);
}

void
LoadTypedThingData(MacroAssembler& masm, TypedThingLayout layout, Register obj, Register result)
{
    switch (layout) {
      case Layout_TypedArray:
        masm.loadPtr(Address(obj, TypedArrayObject::dataOffset()), result);
        break;
      case Layout_OutlineTypedObject:
        masm.loadPtr(Address(obj, OutlineTypedObject::offsetOfData()), result);
        break;
      case Layout_InlineTypedObject:
        masm.computeEffectiveAddress(Address(obj, InlineTypedObject::offsetOfDataStart()), result);
        break;
      default:
        MOZ_CRASH();
    }
}

void
BaselineScript::noteAccessedGetter(uint32_t pcOffset)
{
    ICEntry& entry = icEntryFromPCOffset(pcOffset);
    ICFallbackStub* stub = entry.fallbackStub();

    if (stub->isGetProp_Fallback())
        stub->toGetProp_Fallback()->noteAccessedGetter();
}

ICGetPropNativeStub::ICGetPropNativeStub(ICStub::Kind kind, JitCode* stubCode,
                                         ICStub* firstMonitorStub,
                                         ReceiverGuard guard, uint32_t offset)
  : ICMonitoredStub(kind, stubCode, firstMonitorStub),
    receiverGuard_(guard),
    offset_(offset)
{ }

ICGetPropNativePrototypeStub::ICGetPropNativePrototypeStub(ICStub::Kind kind, JitCode* stubCode,
                                                           ICStub* firstMonitorStub,
                                                           ReceiverGuard guard, uint32_t offset,
                                                           JSObject* holder, Shape* holderShape)
  : ICGetPropNativeStub(kind, stubCode, firstMonitorStub, guard, offset),
    holder_(holder),
    holderShape_(holderShape)
{ }

ICGetPropCallGetter::ICGetPropCallGetter(Kind kind, JitCode* stubCode, ICStub* firstMonitorStub,
                                         ReceiverGuard receiverGuard, JSObject* holder,
                                         Shape* holderShape, JSFunction* getter,
                                         uint32_t pcOffset)
  : ICMonitoredStub(kind, stubCode, firstMonitorStub),
    receiverGuard_(receiverGuard),
    holder_(holder),
    holderShape_(holderShape),
    getter_(getter),
    pcOffset_(pcOffset)
{
    MOZ_ASSERT(kind == ICStub::GetProp_CallScripted  ||
               kind == ICStub::GetProp_CallNative    ||
               kind == ICStub::GetProp_CallNativeGlobal ||
               kind == ICStub::GetProp_CallDOMProxyNative ||
               kind == ICStub::GetProp_CallDOMProxyWithGenerationNative);
}

/* static */ ICGetProp_CallScripted*
ICGetProp_CallScripted::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                              ICGetProp_CallScripted& other)
{
    return New<ICGetProp_CallScripted>(cx, space, other.jitCode(), firstMonitorStub,
                                       other.receiverGuard(),
                                       other.holder_, other.holderShape_,
                                       other.getter_, other.pcOffset_);
}

/* static */ ICGetProp_CallNative*
ICGetProp_CallNative::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                            ICGetProp_CallNative& other)
{
    return New<ICGetProp_CallNative>(cx, space, other.jitCode(), firstMonitorStub,
                                     other.receiverGuard(), other.holder_,
                                     other.holderShape_, other.getter_, other.pcOffset_);
}

/* static */ ICGetProp_CallNativeGlobal*
ICGetProp_CallNativeGlobal::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                            ICGetProp_CallNativeGlobal& other)
{
    return New<ICGetProp_CallNativeGlobal>(cx, space, other.jitCode(), firstMonitorStub,
                                           other.receiverGuard(), other.holder_,
                                           other.holderShape_, other.globalShape_,
                                           other.getter_, other.pcOffset_);
}

ICGetPropCallDOMProxyNativeStub::ICGetPropCallDOMProxyNativeStub(Kind kind, JitCode* stubCode,
                                                                 ICStub* firstMonitorStub,
                                                                 Shape* shape,
                                                                 Shape* expandoShape,
                                                                 JSObject* holder,
                                                                 Shape* holderShape,
                                                                 JSFunction* getter,
                                                                 uint32_t pcOffset)
  : ICGetPropCallGetter(kind, stubCode, firstMonitorStub, ReceiverGuard(nullptr, shape),
                        holder, holderShape, getter, pcOffset),
    expandoShape_(expandoShape)
{ }

ICGetPropCallDOMProxyNativeCompiler::ICGetPropCallDOMProxyNativeCompiler(JSContext* cx,
                                                                         ICStub::Kind kind,
                                                                         ICStubCompiler::Engine engine,
                                                                         ICStub* firstMonitorStub,
                                                                         Handle<ProxyObject*> proxy,
                                                                         HandleObject holder,
                                                                         HandleFunction getter,
                                                                         uint32_t pcOffset)
  : ICStubCompiler(cx, kind, engine),
    firstMonitorStub_(firstMonitorStub),
    proxy_(cx, proxy),
    holder_(cx, holder),
    getter_(cx, getter),
    pcOffset_(pcOffset)
{
    MOZ_ASSERT(kind == ICStub::GetProp_CallDOMProxyNative ||
               kind == ICStub::GetProp_CallDOMProxyWithGenerationNative);
    MOZ_ASSERT(proxy_->handler()->family() == GetDOMProxyHandlerFamily());
}

/* static */ ICGetProp_CallDOMProxyNative*
ICGetProp_CallDOMProxyNative::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                                    ICGetProp_CallDOMProxyNative& other)
{
    return New<ICGetProp_CallDOMProxyNative>(cx, space, other.jitCode(), firstMonitorStub,
                                             other.receiverGuard_.shape(), other.expandoShape_,
                                             other.holder_, other.holderShape_, other.getter_,
                                             other.pcOffset_);
}

/* static */ ICGetProp_CallDOMProxyWithGenerationNative*
ICGetProp_CallDOMProxyWithGenerationNative::Clone(JSContext* cx,
                                                  ICStubSpace* space,
                                                  ICStub* firstMonitorStub,
                                                  ICGetProp_CallDOMProxyWithGenerationNative& other)
{
    return New<ICGetProp_CallDOMProxyWithGenerationNative>(cx, space, other.jitCode(),
                                                           firstMonitorStub,
                                                           other.receiverGuard_.shape(),
                                                           other.expandoAndGeneration_,
                                                           other.generation_,
                                                           other.expandoShape_, other.holder_,
                                                           other.holderShape_, other.getter_,
                                                           other.pcOffset_);
}

ICGetProp_DOMProxyShadowed::ICGetProp_DOMProxyShadowed(JitCode* stubCode,
                                                       ICStub* firstMonitorStub,
                                                       Shape* shape,
                                                       const BaseProxyHandler* proxyHandler,
                                                       PropertyName* name,
                                                       uint32_t pcOffset)
  : ICMonitoredStub(ICStub::GetProp_DOMProxyShadowed, stubCode, firstMonitorStub),
    shape_(shape),
    proxyHandler_(proxyHandler),
    name_(name),
    pcOffset_(pcOffset)
{ }

/* static */ ICGetProp_DOMProxyShadowed*
ICGetProp_DOMProxyShadowed::Clone(JSContext* cx, ICStubSpace* space, ICStub* firstMonitorStub,
                                  ICGetProp_DOMProxyShadowed& other)
{
    return New<ICGetProp_DOMProxyShadowed>(cx, space, other.jitCode(), firstMonitorStub,
                                           other.shape_, other.proxyHandler_, other.name_,
                                           other.pcOffset_);
}

//
// TypeMonitor_Fallback
//

bool
ICTypeMonitor_Fallback::addMonitorStubForValue(JSContext* cx, SharedStubInfo* info, HandleValue val)
{
    bool wasDetachedMonitorChain = lastMonitorStubPtrAddr_ == nullptr;
    MOZ_ASSERT_IF(wasDetachedMonitorChain, numOptimizedMonitorStubs_ == 0);

    if (numOptimizedMonitorStubs_ >= MAX_OPTIMIZED_STUBS) {
        // TODO: if the TypeSet becomes unknown or has the AnyObject type,
        // replace stubs with a single stub to handle these.
        return true;
    }

    if (val.isPrimitive()) {
        if (val.isMagic(JS_UNINITIALIZED_LEXICAL))
            return true;
        MOZ_ASSERT(!val.isMagic());
        JSValueType type = val.isDouble() ? JSVAL_TYPE_DOUBLE : val.extractNonDoubleType();

        // Check for existing TypeMonitor stub.
        ICTypeMonitor_PrimitiveSet* existingStub = nullptr;
        for (ICStubConstIterator iter(firstMonitorStub()); !iter.atEnd(); iter++) {
            if (iter->isTypeMonitor_PrimitiveSet()) {
                existingStub = iter->toTypeMonitor_PrimitiveSet();
                if (existingStub->containsType(type))
                    return true;
            }
        }

        ICTypeMonitor_PrimitiveSet::Compiler compiler(cx, info->engine(), existingStub, type);
        ICStub* stub = existingStub ? compiler.updateStub()
                                    : compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!stub) {
            ReportOutOfMemory(cx);
            return false;
        }

        JitSpew(JitSpew_BaselineIC, "  %s TypeMonitor stub %p for primitive type %d",
                existingStub ? "Modified existing" : "Created new", stub, type);

        if (!existingStub) {
            MOZ_ASSERT(!hasStub(TypeMonitor_PrimitiveSet));
            addOptimizedMonitorStub(stub);
        }

    } else if (val.toObject().isSingleton()) {
        RootedObject obj(cx, &val.toObject());

        // Check for existing TypeMonitor stub.
        for (ICStubConstIterator iter(firstMonitorStub()); !iter.atEnd(); iter++) {
            if (iter->isTypeMonitor_SingleObject() &&
                iter->toTypeMonitor_SingleObject()->object() == obj)
            {
                return true;
            }
        }

        ICTypeMonitor_SingleObject::Compiler compiler(cx, obj);
        ICStub* stub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!stub) {
            ReportOutOfMemory(cx);
            return false;
        }

        JitSpew(JitSpew_BaselineIC, "  Added TypeMonitor stub %p for singleton %p",
                stub, obj.get());

        addOptimizedMonitorStub(stub);

    } else {
        RootedObjectGroup group(cx, val.toObject().group());

        // Check for existing TypeMonitor stub.
        for (ICStubConstIterator iter(firstMonitorStub()); !iter.atEnd(); iter++) {
            if (iter->isTypeMonitor_ObjectGroup() &&
                iter->toTypeMonitor_ObjectGroup()->group() == group)
            {
                return true;
            }
        }

        ICTypeMonitor_ObjectGroup::Compiler compiler(cx, group);
        ICStub* stub = compiler.getStub(compiler.getStubSpace(info->outerScript(cx)));
        if (!stub) {
            ReportOutOfMemory(cx);
            return false;
        }

        JitSpew(JitSpew_BaselineIC, "  Added TypeMonitor stub %p for ObjectGroup %p",
                stub, group.get());

        addOptimizedMonitorStub(stub);
    }

    bool firstMonitorStubAdded = wasDetachedMonitorChain && (numOptimizedMonitorStubs_ > 0);

    if (firstMonitorStubAdded) {
        // Was an empty monitor chain before, but a new stub was added.  This is the
        // only time that any main stubs' firstMonitorStub fields need to be updated to
        // refer to the newly added monitor stub.
        ICStub* firstStub = mainFallbackStub_->icEntry()->firstStub();
        for (ICStubConstIterator iter(firstStub); !iter.atEnd(); iter++) {
            // Non-monitored stubs are used if the result has always the same type,
            // e.g. a StringLength stub will always return int32.
            if (!iter->isMonitored())
                continue;

            // Since we just added the first optimized monitoring stub, any
            // existing main stub's |firstMonitorStub| MUST be pointing to the fallback
            // monitor stub (i.e. this stub).
            MOZ_ASSERT(iter->toMonitoredStub()->firstMonitorStub() == this);
            iter->toMonitoredStub()->updateFirstMonitorStub(firstMonitorStub_);
        }
    }

    return true;
}

static bool
DoTypeMonitorFallback(JSContext* cx, void* payload, ICTypeMonitor_Fallback* stub,
                      HandleValue value, MutableHandleValue res)
{
    SharedStubInfo info(cx, payload, stub->icEntry());
    HandleScript script = info.innerScript();
    jsbytecode* pc = stub->icEntry()->pc(script);
    TypeFallbackICSpew(cx, stub, "TypeMonitor");

    if (value.isMagic()) {
        // It's possible that we arrived here from bailing out of Ion, and that
        // Ion proved that the value is dead and optimized out. In such cases,
        // do nothing. However, it's also possible that we have an uninitialized
        // this, in which case we should not look for other magic values.

        if (value.whyMagic() == JS_OPTIMIZED_OUT) {
            MOZ_ASSERT(!stub->monitorsThis());
            res.set(value);
            return true;
        }

        // In derived class constructors (including nested arrows/eval), the
        // |this| argument or GETALIASEDVAR can return the magic TDZ value.
        MOZ_ASSERT(value.isMagic(JS_UNINITIALIZED_LEXICAL));
        MOZ_ASSERT(info.frame()->isFunctionFrame() || info.frame()->isEvalFrame());
        MOZ_ASSERT(stub->monitorsThis() ||
                   *GetNextPc(pc) == JSOP_CHECKTHIS ||
                   *GetNextPc(pc) == JSOP_CHECKRETURN);
    }

    uint32_t argument;
    if (stub->monitorsThis()) {
        MOZ_ASSERT(pc == script->code());
        if (value.isMagic(JS_UNINITIALIZED_LEXICAL))
            TypeScript::SetThis(cx, script, TypeSet::UnknownType());
        else
            TypeScript::SetThis(cx, script, value);
    } else if (stub->monitorsArgument(&argument)) {
        MOZ_ASSERT(pc == script->code());
        MOZ_ASSERT(!value.isMagic(JS_UNINITIALIZED_LEXICAL));
        TypeScript::SetArgument(cx, script, argument, value);
    } else {
        if (value.isMagic(JS_UNINITIALIZED_LEXICAL))
            TypeScript::Monitor(cx, script, pc, TypeSet::UnknownType());
        else
            TypeScript::Monitor(cx, script, pc, value);
    }

    if (!stub->invalid() && !stub->addMonitorStubForValue(cx, &info, value))
        return false;

    // Copy input value to res.
    res.set(value);
    return true;
}

typedef bool (*DoTypeMonitorFallbackFn)(JSContext*, void*, ICTypeMonitor_Fallback*,
                                        HandleValue, MutableHandleValue);
static const VMFunction DoTypeMonitorFallbackInfo =
    FunctionInfo<DoTypeMonitorFallbackFn>(DoTypeMonitorFallback, "DoTypeMonitorFallback",
                                          TailCall);

bool
ICTypeMonitor_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    MOZ_ASSERT(R0 == JSReturnOperand);

    // Restore the tail call register.
    EmitRestoreTailCallReg(masm);

    masm.pushValue(R0);
    masm.push(ICStubReg);
    pushStubPayload(masm, R0.scratchReg());

    return tailCallVM(DoTypeMonitorFallbackInfo, masm);
}

bool
ICTypeMonitor_PrimitiveSet::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label success;
    if ((flags_ & TypeToFlag(JSVAL_TYPE_INT32)) && !(flags_ & TypeToFlag(JSVAL_TYPE_DOUBLE)))
        masm.branchTestInt32(Assembler::Equal, R0, &success);

    if (flags_ & TypeToFlag(JSVAL_TYPE_DOUBLE))
        masm.branchTestNumber(Assembler::Equal, R0, &success);

    if (flags_ & TypeToFlag(JSVAL_TYPE_UNDEFINED))
        masm.branchTestUndefined(Assembler::Equal, R0, &success);

    if (flags_ & TypeToFlag(JSVAL_TYPE_BOOLEAN))
        masm.branchTestBoolean(Assembler::Equal, R0, &success);

    if (flags_ & TypeToFlag(JSVAL_TYPE_STRING))
        masm.branchTestString(Assembler::Equal, R0, &success);

    if (flags_ & TypeToFlag(JSVAL_TYPE_SYMBOL))
        masm.branchTestSymbol(Assembler::Equal, R0, &success);

    // Currently, we will never generate primitive stub checks for object.  However,
    // when we do get to the point where we want to collapse our monitor chains of
    // objects and singletons down (when they get too long) to a generic "any object"
    // in coordination with the typeset doing the same thing, this will need to
    // be re-enabled.
    /*
    if (flags_ & TypeToFlag(JSVAL_TYPE_OBJECT))
        masm.branchTestObject(Assembler::Equal, R0, &success);
    */
    MOZ_ASSERT(!(flags_ & TypeToFlag(JSVAL_TYPE_OBJECT)));

    if (flags_ & TypeToFlag(JSVAL_TYPE_NULL))
        masm.branchTestNull(Assembler::Equal, R0, &success);

    EmitStubGuardFailure(masm);

    masm.bind(&success);
    EmitReturnFromIC(masm);
    return true;
}

static void
MaybeWorkAroundAmdBug(MacroAssembler& masm)
{
    // Attempt to work around an AMD bug (see bug 1034706 and bug 1281759), by
    // inserting 32-bytes of NOPs.
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
    if (CPUInfo::NeedAmdBugWorkaround()) {
        masm.nop(9);
        masm.nop(9);
        masm.nop(9);
        masm.nop(5);
    }
#endif
}

bool
ICTypeMonitor_SingleObject::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);
    MaybeWorkAroundAmdBug(masm);

    // Guard on the object's identity.
    Register obj = masm.extractObject(R0, ExtractTemp0);
    Address expectedObject(ICStubReg, ICTypeMonitor_SingleObject::offsetOfObject());
    masm.branchPtr(Assembler::NotEqual, expectedObject, obj, &failure);
    MaybeWorkAroundAmdBug(masm);

    EmitReturnFromIC(masm);
    MaybeWorkAroundAmdBug(masm);

    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICTypeMonitor_ObjectGroup::Compiler::generateStubCode(MacroAssembler& masm)
{
    Label failure;
    masm.branchTestObject(Assembler::NotEqual, R0, &failure);
    MaybeWorkAroundAmdBug(masm);

    // Guard on the object's ObjectGroup.
    Register obj = masm.extractObject(R0, ExtractTemp0);
    masm.loadPtr(Address(obj, JSObject::offsetOfGroup()), R1.scratchReg());

    Address expectedGroup(ICStubReg, ICTypeMonitor_ObjectGroup::offsetOfGroup());
    masm.branchPtr(Assembler::NotEqual, expectedGroup, R1.scratchReg(), &failure);
    MaybeWorkAroundAmdBug(masm);

    EmitReturnFromIC(masm);
    MaybeWorkAroundAmdBug(masm);

    masm.bind(&failure);
    EmitStubGuardFailure(masm);
    return true;
}

bool
ICUpdatedStub::addUpdateStubForValue(JSContext* cx, HandleScript outerScript, HandleObject obj,
                                     HandleId id, HandleValue val)
{
    if (numOptimizedStubs_ >= MAX_OPTIMIZED_STUBS) {
        // TODO: if the TypeSet becomes unknown or has the AnyObject type,
        // replace stubs with a single stub to handle these.
        return true;
    }

    EnsureTrackPropertyTypes(cx, obj, id);

    // Make sure that undefined values are explicitly included in the property
    // types for an object if generating a stub to write an undefined value.
    if (val.isUndefined() && CanHaveEmptyPropertyTypesForOwnProperty(obj))
        AddTypePropertyId(cx, obj, id, val);

    if (val.isPrimitive()) {
        JSValueType type = val.isDouble() ? JSVAL_TYPE_DOUBLE : val.extractNonDoubleType();

        // Check for existing TypeUpdate stub.
        ICTypeUpdate_PrimitiveSet* existingStub = nullptr;
        for (ICStubConstIterator iter(firstUpdateStub_); !iter.atEnd(); iter++) {
            if (iter->isTypeUpdate_PrimitiveSet()) {
                existingStub = iter->toTypeUpdate_PrimitiveSet();
                if (existingStub->containsType(type))
                    return true;
            }
        }

        ICTypeUpdate_PrimitiveSet::Compiler compiler(cx, existingStub, type);
        ICStub* stub = existingStub ? compiler.updateStub()
                                    : compiler.getStub(compiler.getStubSpace(outerScript));
        if (!stub)
            return false;
        if (!existingStub) {
            MOZ_ASSERT(!hasTypeUpdateStub(TypeUpdate_PrimitiveSet));
            addOptimizedUpdateStub(stub);
        }

        JitSpew(JitSpew_BaselineIC, "  %s TypeUpdate stub %p for primitive type %d",
                existingStub ? "Modified existing" : "Created new", stub, type);

    } else if (val.toObject().isSingleton()) {
        RootedObject obj(cx, &val.toObject());

        // Check for existing TypeUpdate stub.
        for (ICStubConstIterator iter(firstUpdateStub_); !iter.atEnd(); iter++) {
            if (iter->isTypeUpdate_SingleObject() &&
                iter->toTypeUpdate_SingleObject()->object() == obj)
            {
                return true;
            }
        }

        ICTypeUpdate_SingleObject::Compiler compiler(cx, obj);
        ICStub* stub = compiler.getStub(compiler.getStubSpace(outerScript));
        if (!stub)
            return false;

        JitSpew(JitSpew_BaselineIC, "  Added TypeUpdate stub %p for singleton %p", stub, obj.get());

        addOptimizedUpdateStub(stub);

    } else {
        RootedObjectGroup group(cx, val.toObject().group());

        // Check for existing TypeUpdate stub.
        for (ICStubConstIterator iter(firstUpdateStub_); !iter.atEnd(); iter++) {
            if (iter->isTypeUpdate_ObjectGroup() &&
                iter->toTypeUpdate_ObjectGroup()->group() == group)
            {
                return true;
            }
        }

        ICTypeUpdate_ObjectGroup::Compiler compiler(cx, group);
        ICStub* stub = compiler.getStub(compiler.getStubSpace(outerScript));
        if (!stub)
            return false;

        JitSpew(JitSpew_BaselineIC, "  Added TypeUpdate stub %p for ObjectGroup %p",
                stub, group.get());

        addOptimizedUpdateStub(stub);
    }

    return true;
}

//
// NewArray_Fallback
//

static bool
DoNewArray(JSContext* cx, void* payload, ICNewArray_Fallback* stub, uint32_t length,
           MutableHandleValue res)
{
    SharedStubInfo info(cx, payload, stub->icEntry());

    FallbackICSpew(cx, stub, "NewArray");

    RootedObject obj(cx);
    if (stub->templateObject()) {
        RootedObject templateObject(cx, stub->templateObject());
        obj = NewArrayOperationWithTemplate(cx, templateObject);
        if (!obj)
            return false;
    } else {
        HandleScript script = info.script();
        jsbytecode* pc = info.pc();
        obj = NewArrayOperation(cx, script, pc, length);
        if (!obj)
            return false;

        if (obj && !obj->isSingleton() && !obj->group()->maybePreliminaryObjects()) {
            JSObject* templateObject = NewArrayOperation(cx, script, pc, length, TenuredObject);
            if (!templateObject)
                return false;
            stub->setTemplateObject(templateObject);
        }
    }

    res.setObject(*obj);
    return true;
}

typedef bool(*DoNewArrayFn)(JSContext*, void*, ICNewArray_Fallback*, uint32_t,
                            MutableHandleValue);
static const VMFunction DoNewArrayInfo =
    FunctionInfo<DoNewArrayFn>(DoNewArray, "DoNewArray", TailCall);

bool
ICNewArray_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    EmitRestoreTailCallReg(masm);

    masm.push(R0.scratchReg()); // length
    masm.push(ICStubReg); // stub.
    pushStubPayload(masm, R0.scratchReg());

    return tailCallVM(DoNewArrayInfo, masm);
}

//
// NewObject_Fallback
//

// Unlike typical baseline IC stubs, the code for NewObject_WithTemplate is
// specialized for the template object being allocated.
static JitCode*
GenerateNewObjectWithTemplateCode(JSContext* cx, JSObject* templateObject)
{
    JitContext jctx(cx, nullptr);
    MacroAssembler masm;
#ifdef JS_CODEGEN_ARM
    masm.setSecondScratchReg(BaselineSecondScratchReg);
#endif

    Label failure;
    Register objReg = R0.scratchReg();
    Register tempReg = R1.scratchReg();
    masm.movePtr(ImmGCPtr(templateObject->group()), tempReg);
    masm.branchTest32(Assembler::NonZero, Address(tempReg, ObjectGroup::offsetOfFlags()),
                      Imm32(OBJECT_FLAG_PRE_TENURE), &failure);
    masm.branchPtr(Assembler::NotEqual, AbsoluteAddress(cx->compartment()->addressOfMetadataBuilder()),
                   ImmWord(0), &failure);
    masm.createGCObject(objReg, tempReg, templateObject, gc::DefaultHeap, &failure);
    masm.tagValue(JSVAL_TYPE_OBJECT, objReg, R0);

    EmitReturnFromIC(masm);
    masm.bind(&failure);
    EmitStubGuardFailure(masm);

    Linker linker(masm);
    AutoFlushICache afc("GenerateNewObjectWithTemplateCode");
    return linker.newCode<CanGC>(cx, BASELINE_CODE);
}

static bool
DoNewObject(JSContext* cx, void* payload, ICNewObject_Fallback* stub, MutableHandleValue res)
{
    SharedStubInfo info(cx, payload, stub->icEntry());

    FallbackICSpew(cx, stub, "NewObject");

    RootedObject obj(cx);

    RootedObject templateObject(cx, stub->templateObject());
    if (templateObject) {
        MOZ_ASSERT(!templateObject->group()->maybePreliminaryObjects());
        obj = NewObjectOperationWithTemplate(cx, templateObject);
    } else {
        HandleScript script = info.script();
        jsbytecode* pc = info.pc();
        obj = NewObjectOperation(cx, script, pc);

        if (obj && !obj->isSingleton() && !obj->group()->maybePreliminaryObjects()) {
            JSObject* templateObject = NewObjectOperation(cx, script, pc, TenuredObject);
            if (!templateObject)
                return false;

            if (!stub->invalid() &&
                (templateObject->is<UnboxedPlainObject>() ||
                 !templateObject->as<PlainObject>().hasDynamicSlots()))
            {
                JitCode* code = GenerateNewObjectWithTemplateCode(cx, templateObject);
                if (!code)
                    return false;

                ICStubSpace* space =
                    ICStubCompiler::StubSpaceForKind(ICStub::NewObject_WithTemplate, script,
                                                     ICStubCompiler::Engine::Baseline);
                ICStub* templateStub = ICStub::New<ICNewObject_WithTemplate>(cx, space, code);
                if (!templateStub)
                    return false;

                stub->addNewStub(templateStub);
            }

            stub->setTemplateObject(templateObject);
        }
    }

    if (!obj)
        return false;

    res.setObject(*obj);
    return true;
}

typedef bool(*DoNewObjectFn)(JSContext*, void*, ICNewObject_Fallback*, MutableHandleValue);
static const VMFunction DoNewObjectInfo =
    FunctionInfo<DoNewObjectFn>(DoNewObject, "DoNewObject", TailCall);

bool
ICNewObject_Fallback::Compiler::generateStubCode(MacroAssembler& masm)
{
    EmitRestoreTailCallReg(masm);

    masm.push(ICStubReg); // stub.
    pushStubPayload(masm, R0.scratchReg());

    return tailCallVM(DoNewObjectInfo, masm);
}

} // namespace jit
} // namespace js
