/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * JavaScript API.
 */

#include "jsapi.h"

#include "mozilla/FloatingPoint.h"
#include "mozilla/PodOperations.h"
#include "mozilla/Sprintf.h"

#include <ctype.h>
#include <stdarg.h>
#include <string.h>
#include <sys/stat.h>

#include "jsarray.h"
#include "jsatom.h"
#include "jsbool.h"
#include "jscntxt.h"
#include "jsdate.h"
#include "jsexn.h"
#include "jsfriendapi.h"
#include "jsfun.h"
#include "jsgc.h"
#include "jsiter.h"
#include "jsmath.h"
#include "jsnum.h"
#include "jsobj.h"
#include "json.h"
#include "jsprf.h"
#include "jsscript.h"
#include "jsstr.h"
#include "jstypes.h"
#include "jsutil.h"
#include "jswatchpoint.h"
#include "jsweakmap.h"
#include "jswrapper.h"

#include "builtin/AtomicsObject.h"
#include "builtin/Eval.h"
#include "builtin/Intl.h"
#include "builtin/MapObject.h"
#include "builtin/Promise.h"
#include "builtin/RegExp.h"
#include "builtin/SymbolObject.h"
#ifdef ENABLE_SIMD
# include "builtin/SIMD.h"
#endif
#ifdef ENABLE_BINARYDATA
# include "builtin/TypedObject.h"
#endif
#include "frontend/BytecodeCompiler.h"
#include "frontend/FullParseHandler.h"  // for JS_BufferIsCompileableUnit
#include "frontend/Parser.h" // for JS_BufferIsCompileableUnit
#include "gc/Marking.h"
#include "gc/Policy.h"
#include "jit/JitCommon.h"
#include "js/CharacterEncoding.h"
#include "js/Conversions.h"
#include "js/Date.h"
#include "js/Initialization.h"
#include "js/Proxy.h"
#include "js/SliceBudget.h"
#include "js/StructuredClone.h"
#include "js/UniquePtr.h"
#include "js/Utility.h"
#include "vm/AsyncFunction.h"
#include "vm/DateObject.h"
#include "vm/Debugger.h"
#include "vm/EnvironmentObject.h"
#include "vm/ErrorObject.h"
#include "vm/HelperThreads.h"
#include "vm/Interpreter.h"
#include "vm/RegExpStatics.h"
#include "vm/Runtime.h"
#include "vm/SavedStacks.h"
#include "vm/SelfHosting.h"
#include "vm/Shape.h"
#include "vm/StopIterationObject.h"
#include "vm/String.h"
#include "vm/StringBuffer.h"
#include "vm/Symbol.h"
#include "vm/TypedArrayCommon.h"
#include "vm/WrapperObject.h"
#include "vm/Xdr.h"
#include "wasm/AsmJS.h"
#include "wasm/WasmModule.h"

#include "jsatominlines.h"
#include "jsfuninlines.h"
#include "jsscriptinlines.h"

#include "vm/Interpreter-inl.h"
#include "vm/NativeObject-inl.h"
#include "vm/SavedStacks-inl.h"
#include "vm/String-inl.h"

using namespace js;
using namespace js::gc;

using mozilla::Maybe;
using mozilla::PodCopy;
using mozilla::PodZero;

using JS::AutoGCRooter;
using JS::ToInt32;
using JS::ToInteger;
using JS::ToUint32;

#ifdef HAVE_VA_LIST_AS_ARRAY
#define JS_ADDRESSOF_VA_LIST(ap) ((va_list*)(ap))
#else
#define JS_ADDRESSOF_VA_LIST(ap) (&(ap))
#endif

bool
JS::CallArgs::requireAtLeast(JSContext* cx, const char* fnname, unsigned required) const
{
    if (length() < required) {
        char numArgsStr[40];
        SprintfLiteral(numArgsStr, "%u", required - 1);
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_MORE_ARGS_NEEDED,
                                  fnname, numArgsStr, required == 2 ? "" : "s");
        return false;
    }

    return true;
}

static bool
ErrorTakesArguments(unsigned msg)
{
    MOZ_ASSERT(msg < JSErr_Limit);
    unsigned argCount = js_ErrorFormatString[msg].argCount;
    MOZ_ASSERT(argCount <= 2);
    return argCount == 1 || argCount == 2;
}

static bool
ErrorTakesObjectArgument(unsigned msg)
{
    MOZ_ASSERT(msg < JSErr_Limit);
    unsigned argCount = js_ErrorFormatString[msg].argCount;
    MOZ_ASSERT(argCount <= 2);
    return argCount == 2;
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::reportStrictErrorOrWarning(JSContext* cx, HandleObject obj, HandleId id,
                                               bool strict)
{
    static_assert(unsigned(OkCode) == unsigned(JSMSG_NOT_AN_ERROR),
                  "unsigned value of OkCode must not be an error code");
    MOZ_ASSERT(code_ != Uninitialized);
    MOZ_ASSERT(!ok());

    unsigned flags = strict ? JSREPORT_ERROR : (JSREPORT_WARNING | JSREPORT_STRICT);
    if (code_ == JSMSG_OBJECT_NOT_EXTENSIBLE || code_ == JSMSG_SET_NON_OBJECT_RECEIVER) {
        RootedValue val(cx, ObjectValue(*obj));
        return ReportValueErrorFlags(cx, flags, code_, JSDVG_IGNORE_STACK, val,
                                     nullptr, nullptr, nullptr);
    }
    if (ErrorTakesArguments(code_)) {
        RootedValue idv(cx, IdToValue(id));
        RootedString str(cx, ValueToSource(cx, idv));
        if (!str)
            return false;

        JSAutoByteString propName;
        if (!propName.encodeUtf8(cx, str))
            return false;

        if (ErrorTakesObjectArgument(code_)) {
            return JS_ReportErrorFlagsAndNumberUTF8(cx, flags, GetErrorMessage, nullptr, code_,
                                                    obj->getClass()->name, propName.ptr());
        }

        return JS_ReportErrorFlagsAndNumberUTF8(cx, flags, GetErrorMessage, nullptr, code_,
                                                propName.ptr());
    }
    return JS_ReportErrorFlagsAndNumberASCII(cx, flags, GetErrorMessage, nullptr, code_);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::reportStrictErrorOrWarning(JSContext* cx, HandleObject obj, bool strict)
{
    MOZ_ASSERT(code_ != Uninitialized);
    MOZ_ASSERT(!ok());
    MOZ_ASSERT(!ErrorTakesArguments(code_));

    unsigned flags = strict ? JSREPORT_ERROR : (JSREPORT_WARNING | JSREPORT_STRICT);
    return JS_ReportErrorFlagsAndNumberASCII(cx, flags, GetErrorMessage, nullptr, code_);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantRedefineProp()
{
    return fail(JSMSG_CANT_REDEFINE_PROP);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failReadOnly()
{
    return fail(JSMSG_READ_ONLY);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failGetterOnly()
{
    return fail(JSMSG_GETTER_ONLY);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantDelete()
{
    return fail(JSMSG_CANT_DELETE);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantSetInterposed()
{
    return fail(JSMSG_CANT_SET_INTERPOSED);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantDefineWindowElement()
{
    return fail(JSMSG_CANT_DEFINE_WINDOW_ELEMENT);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantDeleteWindowElement()
{
    return fail(JSMSG_CANT_DELETE_WINDOW_ELEMENT);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantDeleteWindowNamedProperty()
{
    return fail(JSMSG_CANT_DELETE_WINDOW_NAMED_PROPERTY);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantPreventExtensions()
{
    return fail(JSMSG_CANT_PREVENT_EXTENSIONS);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failCantSetProto()
{
    return fail(JSMSG_CANT_SET_PROTO);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failNoNamedSetter()
{
    return fail(JSMSG_NO_NAMED_SETTER);
}

JS_PUBLIC_API(bool)
JS::ObjectOpResult::failNoIndexedSetter()
{
    return fail(JSMSG_NO_INDEXED_SETTER);
}

JS_PUBLIC_API(int64_t)
JS_Now()
{
    return PRMJ_Now();
}

JS_PUBLIC_API(Value)
JS_GetNaNValue(JSContext* cx)
{
    return cx->runtime()->NaNValue;
}

JS_PUBLIC_API(Value)
JS_GetNegativeInfinityValue(JSContext* cx)
{
    return cx->runtime()->negativeInfinityValue;
}

JS_PUBLIC_API(Value)
JS_GetPositiveInfinityValue(JSContext* cx)
{
    return cx->runtime()->positiveInfinityValue;
}

JS_PUBLIC_API(Value)
JS_GetEmptyStringValue(JSContext* cx)
{
    return StringValue(cx->runtime()->emptyString);
}

JS_PUBLIC_API(JSString*)
JS_GetEmptyString(JSContext* cx)
{
    MOZ_ASSERT(cx->emptyString());
    return cx->emptyString();
}

namespace js {

void
AssertHeapIsIdle(JSRuntime* rt)
{
    MOZ_ASSERT(!rt->isHeapBusy());
}

} // namespace js

static void
AssertHeapIsIdleOrIterating(JSRuntime* rt)
{
    MOZ_ASSERT(!rt->isHeapCollecting());
}

static void
AssertHeapIsIdleOrStringIsFlat(JSContext* cx, JSString* str)
{
    /*
     * We allow some functions to be called during a GC as long as the argument
     * is a flat string, since that will not cause allocation.
     */
    MOZ_ASSERT_IF(cx->runtime()->isHeapBusy(), str->isFlat());
}

JS_PUBLIC_API(bool)
JS_ValueToObject(JSContext* cx, HandleValue value, MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    if (value.isNullOrUndefined()) {
        objp.set(nullptr);
        return true;
    }
    JSObject* obj = ToObject(cx, value);
    if (!obj)
        return false;
    objp.set(obj);
    return true;
}

JS_PUBLIC_API(JSFunction*)
JS_ValueToFunction(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    return ReportIfNotFunction(cx, value);
}

JS_PUBLIC_API(JSFunction*)
JS_ValueToConstructor(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    return ReportIfNotFunction(cx, value);
}

JS_PUBLIC_API(JSString*)
JS_ValueToSource(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    return ValueToSource(cx, value);
}

JS_PUBLIC_API(bool)
JS_DoubleIsInt32(double d, int32_t* ip)
{
    return mozilla::NumberIsInt32(d, ip);
}

JS_PUBLIC_API(JSType)
JS_TypeOfValue(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    return TypeOfValue(value);
}

JS_PUBLIC_API(bool)
JS_StrictlyEqual(JSContext* cx, HandleValue value1, HandleValue value2, bool* equal)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value1, value2);
    MOZ_ASSERT(equal);
    return StrictlyEqual(cx, value1, value2, equal);
}

JS_PUBLIC_API(bool)
JS_LooselyEqual(JSContext* cx, HandleValue value1, HandleValue value2, bool* equal)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value1, value2);
    MOZ_ASSERT(equal);
    return LooselyEqual(cx, value1, value2, equal);
}

JS_PUBLIC_API(bool)
JS_SameValue(JSContext* cx, HandleValue value1, HandleValue value2, bool* same)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value1, value2);
    MOZ_ASSERT(same);
    return SameValue(cx, value1, value2, same);
}

JS_PUBLIC_API(bool)
JS_IsBuiltinEvalFunction(JSFunction* fun)
{
    return IsAnyBuiltinEval(fun);
}

JS_PUBLIC_API(bool)
JS_IsBuiltinFunctionConstructor(JSFunction* fun)
{
    return fun->isBuiltinFunctionConstructor();
}

JS_PUBLIC_API(bool)
JS_IsFunctionBound(JSFunction* fun)
{
    return fun->isBoundFunction();
}

JS_PUBLIC_API(JSObject*)
JS_GetBoundFunctionTarget(JSFunction* fun)
{
    return fun->isBoundFunction() ?
               fun->getBoundFunctionTarget() : nullptr;
}

/************************************************************************/

#ifdef DEBUG
JS_FRIEND_API(bool)
JS::isGCEnabled()
{
    return !TlsPerThreadData.get()->suppressGC;
}
#else
JS_FRIEND_API(bool) JS::isGCEnabled() { return true; }
#endif

JS_PUBLIC_API(JSContext*)
JS_NewContext(uint32_t maxbytes, uint32_t maxNurseryBytes, JSContext* parentContext)
{
    MOZ_ASSERT(JS::detail::libraryInitState == JS::detail::InitState::Running,
               "must call JS_Init prior to creating any JSContexts");

    // Make sure that all parent runtimes are the topmost parent.
    JSRuntime* parentRuntime = nullptr;
    if (parentContext) {
        parentRuntime = parentContext->runtime();
        while (parentRuntime && parentRuntime->parentRuntime)
            parentRuntime = parentRuntime->parentRuntime;
    }

    return NewContext(maxbytes, maxNurseryBytes, parentRuntime);
}

JS_PUBLIC_API(void)
JS_DestroyContext(JSContext* cx)
{
    DestroyContext(cx);
}

static JS_CurrentEmbedderTimeFunction currentEmbedderTimeFunction;

JS_PUBLIC_API(void)
JS_SetCurrentEmbedderTimeFunction(JS_CurrentEmbedderTimeFunction timeFn)
{
    currentEmbedderTimeFunction = timeFn;
}

JS_PUBLIC_API(double)
JS_GetCurrentEmbedderTime()
{
    if (currentEmbedderTimeFunction)
        return currentEmbedderTimeFunction();
    return PRMJ_Now() / static_cast<double>(PRMJ_USEC_PER_MSEC);
}

JS_PUBLIC_API(void*)
JS_GetContextPrivate(JSContext* cx)
{
    return cx->data;
}

JS_PUBLIC_API(void)
JS_SetContextPrivate(JSContext* cx, void* data)
{
    cx->data = data;
}

JS_PUBLIC_API(void)
JS_SetFutexCanWait(JSContext* cx)
{
    cx->fx.setCanWait(true);
}

static void
StartRequest(JSContext* cx)
{
    JSRuntime* rt = cx->runtime();
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(rt));

    if (rt->requestDepth) {
        rt->requestDepth++;
    } else {
        /* Indicate that a request is running. */
        rt->requestDepth = 1;
        rt->triggerActivityCallback(true);
    }
}

static void
StopRequest(JSContext* cx)
{
    JSRuntime* rt = cx->runtime();
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(rt));

    MOZ_ASSERT(rt->requestDepth != 0);
    if (rt->requestDepth != 1) {
        rt->requestDepth--;
    } else {
        rt->requestDepth = 0;
        rt->triggerActivityCallback(false);
    }
}

JS_PUBLIC_API(void)
JS_BeginRequest(JSContext* cx)
{
    cx->outstandingRequests++;
    StartRequest(cx);
}

JS_PUBLIC_API(void)
JS_EndRequest(JSContext* cx)
{
    MOZ_ASSERT(cx->outstandingRequests != 0);
    cx->outstandingRequests--;
    StopRequest(cx);
}

JS_PUBLIC_API(JSContext*)
JS_GetParentContext(JSContext* cx)
{
    return cx->parentRuntime ? cx->parentRuntime->unsafeContextFromAnyThread() : cx;
}

JS_PUBLIC_API(JSVersion)
JS_GetVersion(JSContext* cx)
{
    return VersionNumber(cx->findVersion());
}

JS_PUBLIC_API(void)
JS_SetVersionForCompartment(JSCompartment* compartment, JSVersion version)
{
    compartment->behaviors().setVersion(version);
}

static const struct v2smap {
    JSVersion   version;
    const char* string;
} v2smap[] = {
    {JSVERSION_ECMA_3,  "ECMAv3"},
    {JSVERSION_1_6,     "1.6"},
    {JSVERSION_1_7,     "1.7"},
    {JSVERSION_1_8,     "1.8"},
    {JSVERSION_ECMA_5,  "ECMAv5"},
    {JSVERSION_DEFAULT, js_default_str},
    {JSVERSION_DEFAULT, "1.0"},
    {JSVERSION_DEFAULT, "1.1"},
    {JSVERSION_DEFAULT, "1.2"},
    {JSVERSION_DEFAULT, "1.3"},
    {JSVERSION_DEFAULT, "1.4"},
    {JSVERSION_DEFAULT, "1.5"},
    {JSVERSION_UNKNOWN, nullptr},          /* must be last, nullptr is sentinel */
};

JS_PUBLIC_API(const char*)
JS_VersionToString(JSVersion version)
{
    int i;

    for (i = 0; v2smap[i].string; i++)
        if (v2smap[i].version == version)
            return v2smap[i].string;
    return "unknown";
}

JS_PUBLIC_API(JSVersion)
JS_StringToVersion(const char* string)
{
    int i;

    for (i = 0; v2smap[i].string; i++)
        if (strcmp(v2smap[i].string, string) == 0)
            return v2smap[i].version;
    return JSVERSION_UNKNOWN;
}

JS_PUBLIC_API(JS::ContextOptions&)
JS::ContextOptionsRef(JSContext* cx)
{
    return cx->options();
}

JS_PUBLIC_API(bool)
JS::InitSelfHostedCode(JSContext* cx)
{
    MOZ_RELEASE_ASSERT(!cx->runtime()->hasInitializedSelfHosting(),
                       "JS::InitSelfHostedCode() called more than once");

    JSRuntime* rt = cx->runtime();

    JSAutoRequest ar(cx);
    if (!rt->initializeAtoms(cx))
        return false;

    if (!cx->cycleDetectorSet.init())
        return false;

    if (!rt->initSelfHosting(cx))
        return false;

    if (!rt->parentRuntime && !rt->transformToPermanentAtoms(cx))
        return false;

    return true;
}

JS_PUBLIC_API(const char*)
JS_GetImplementationVersion(void)
{
    return "JavaScript-C" MOZILLA_VERSION;
}

JS_PUBLIC_API(void)
JS_SetDestroyCompartmentCallback(JSContext* cx, JSDestroyCompartmentCallback callback)
{
    cx->destroyCompartmentCallback = callback;
}

JS_PUBLIC_API(void)
JS_SetSizeOfIncludingThisCompartmentCallback(JSContext* cx,
                                             JSSizeOfIncludingThisCompartmentCallback callback)
{
    cx->sizeOfIncludingThisCompartmentCallback = callback;
}

JS_PUBLIC_API(void)
JS_SetDestroyZoneCallback(JSContext* cx, JSZoneCallback callback)
{
    cx->destroyZoneCallback = callback;
}

JS_PUBLIC_API(void)
JS_SetSweepZoneCallback(JSContext* cx, JSZoneCallback callback)
{
    cx->sweepZoneCallback = callback;
}

JS_PUBLIC_API(void)
JS_SetCompartmentNameCallback(JSContext* cx, JSCompartmentNameCallback callback)
{
    cx->compartmentNameCallback = callback;
}

JS_PUBLIC_API(void)
JS_SetWrapObjectCallbacks(JSContext* cx, const JSWrapObjectCallbacks* callbacks)
{
    cx->wrapObjectCallbacks = callbacks;
}

JS_PUBLIC_API(JSCompartment*)
JS_EnterCompartment(JSContext* cx, JSObject* target)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT(!JS::ObjectIsMarkedGray(target));

    JSCompartment* oldCompartment = cx->compartment();
    cx->enterCompartment(target->compartment());
    return oldCompartment;
}

JS_PUBLIC_API(void)
JS_LeaveCompartment(JSContext* cx, JSCompartment* oldCompartment)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    cx->leaveCompartment(oldCompartment);
}

JSAutoCompartment::JSAutoCompartment(JSContext* cx, JSObject* target
                                     MOZ_GUARD_OBJECT_NOTIFIER_PARAM_IN_IMPL)
  : cx_(cx),
    oldCompartment_(cx->compartment())
{
    AssertHeapIsIdleOrIterating(cx_);
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    MOZ_ASSERT(!JS::ObjectIsMarkedGray(target));
    cx_->enterCompartment(target->compartment());
}

JSAutoCompartment::JSAutoCompartment(JSContext* cx, JSScript* target
                                     MOZ_GUARD_OBJECT_NOTIFIER_PARAM_IN_IMPL)
  : cx_(cx),
    oldCompartment_(cx->compartment())
{
    AssertHeapIsIdleOrIterating(cx_);
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    MOZ_ASSERT(!JS::ScriptIsMarkedGray(target));
    cx_->enterCompartment(target->compartment());
}

JSAutoCompartment::~JSAutoCompartment()
{
    cx_->leaveCompartment(oldCompartment_);
}

JSAutoNullableCompartment::JSAutoNullableCompartment(JSContext* cx,
                                                     JSObject* targetOrNull
                                                     MOZ_GUARD_OBJECT_NOTIFIER_PARAM_IN_IMPL)
  : cx_(cx),
    oldCompartment_(cx->compartment())
{
    AssertHeapIsIdleOrIterating(cx_);
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    if (targetOrNull) {
        MOZ_ASSERT(!JS::ObjectIsMarkedGray(targetOrNull));
        cx_->enterCompartment(targetOrNull->compartment());
    } else {
        cx_->enterNullCompartment();
    }
}

JSAutoNullableCompartment::~JSAutoNullableCompartment()
{
    cx_->leaveCompartment(oldCompartment_);
}

JS_PUBLIC_API(void)
JS_SetCompartmentPrivate(JSCompartment* compartment, void* data)
{
    compartment->data = data;
}

JS_PUBLIC_API(void*)
JS_GetCompartmentPrivate(JSCompartment* compartment)
{
    return compartment->data;
}

JS_PUBLIC_API(JSAddonId*)
JS::NewAddonId(JSContext* cx, HandleString str)
{
    return static_cast<JSAddonId*>(JS_AtomizeAndPinJSString(cx, str));
}

JS_PUBLIC_API(JSString*)
JS::StringOfAddonId(JSAddonId* id)
{
    return id;
}

JS_PUBLIC_API(JSAddonId*)
JS::AddonIdOfObject(JSObject* obj)
{
    return obj->compartment()->creationOptions().addonIdOrNull();
}

JS_PUBLIC_API(void)
JS_SetZoneUserData(JS::Zone* zone, void* data)
{
    zone->data = data;
}

JS_PUBLIC_API(void*)
JS_GetZoneUserData(JS::Zone* zone)
{
    return zone->data;
}

JS_PUBLIC_API(bool)
JS_WrapObject(JSContext* cx, MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (objp)
        JS::ExposeObjectToActiveJS(objp);
    return cx->compartment()->wrap(cx, objp);
}

JS_PUBLIC_API(bool)
JS_WrapValue(JSContext* cx, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JS::ExposeValueToActiveJS(vp);
    return cx->compartment()->wrap(cx, vp);
}

/*
 * Identity remapping. Not for casual consumers.
 *
 * Normally, an object's contents and its identity are inextricably linked.
 * Identity is determined by the address of the JSObject* in the heap, and
 * the contents are what is located at that address. Transplanting allows these
 * concepts to be separated through a combination of swapping (exchanging the
 * contents of two same-compartment objects) and remapping cross-compartment
 * identities by altering wrappers.
 *
 * The |origobj| argument should be the object whose identity needs to be
 * remapped, usually to another compartment. The contents of |origobj| are
 * destroyed.
 *
 * The |target| argument serves two purposes:
 *
 * First, |target| serves as a hint for the new identity of the object. The new
 * identity object will always be in the same compartment as |target|, but
 * if that compartment already had an object representing |origobj| (either a
 * cross-compartment wrapper for it, or |origobj| itself if the two arguments
 * are same-compartment), the existing object is used. Otherwise, |target|
 * itself is used. To avoid ambiguity, JS_TransplantObject always returns the
 * new identity.
 *
 * Second, the new identity object's contents will be those of |target|. A swap()
 * is used to make this happen if an object other than |target| is used.
 *
 * We don't have a good way to recover from failure in this function, so
 * we intentionally crash instead.
 */

JS_PUBLIC_API(JSObject*)
JS_TransplantObject(JSContext* cx, HandleObject origobj, HandleObject target)
{
    AssertHeapIsIdle(cx);
    MOZ_ASSERT(origobj != target);
    MOZ_ASSERT(!origobj->is<CrossCompartmentWrapperObject>());
    MOZ_ASSERT(!target->is<CrossCompartmentWrapperObject>());

    RootedValue origv(cx, ObjectValue(*origobj));
    RootedObject newIdentity(cx);

    // Don't allow a compacting GC to observe any intermediate state.
    AutoDisableCompactingGC nocgc(cx);

    AutoDisableProxyCheck adpc(cx->runtime());

    JSCompartment* destination = target->compartment();

    if (origobj->compartment() == destination) {
        // If the original object is in the same compartment as the
        // destination, then we know that we won't find a wrapper in the
        // destination's cross compartment map and that the same
        // object will continue to work.
        if (!JSObject::swap(cx, origobj, target))
            MOZ_CRASH();
        newIdentity = origobj;
    } else if (WrapperMap::Ptr p = destination->lookupWrapper(origv)) {
        // There might already be a wrapper for the original object in
        // the new compartment. If there is, we use its identity and swap
        // in the contents of |target|.
        newIdentity = &p->value().get().toObject();

        // When we remove origv from the wrapper map, its wrapper, newIdentity,
        // must immediately cease to be a cross-compartment wrapper. Nuke it.
        destination->removeWrapper(p);
        NukeCrossCompartmentWrapper(cx, newIdentity);

        if (!JSObject::swap(cx, newIdentity, target))
            MOZ_CRASH();
    } else {
        // Otherwise, we use |target| for the new identity object.
        newIdentity = target;
    }

    // Now, iterate through other scopes looking for references to the
    // old object, and update the relevant cross-compartment wrappers.
    if (!RemapAllWrappersForObject(cx, origobj, newIdentity))
        MOZ_CRASH();

    // Lastly, update the original object to point to the new one.
    if (origobj->compartment() != destination) {
        RootedObject newIdentityWrapper(cx, newIdentity);
        AutoCompartment ac(cx, origobj);
        if (!JS_WrapObject(cx, &newIdentityWrapper))
            MOZ_CRASH();
        MOZ_ASSERT(Wrapper::wrappedObject(newIdentityWrapper) == newIdentity);
        if (!JSObject::swap(cx, origobj, newIdentityWrapper))
            MOZ_CRASH();
        if (!origobj->compartment()->putWrapper(cx, CrossCompartmentKey(newIdentity), origv))
            MOZ_CRASH();
    }

    // The new identity object might be one of several things. Return it to avoid
    // ambiguity.
    return newIdentity;
}

/*
 * Recompute all cross-compartment wrappers for an object, resetting state.
 * Gecko uses this to clear Xray wrappers when doing a navigation that reuses
 * the inner window and global object.
 */
JS_PUBLIC_API(bool)
JS_RefreshCrossCompartmentWrappers(JSContext* cx, HandleObject obj)
{
    return RemapAllWrappersForObject(cx, obj, obj);
}

JS_PUBLIC_API(bool)
JS_InitStandardClasses(JSContext* cx, HandleObject obj)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    assertSameCompartment(cx, obj);

    Rooted<GlobalObject*> global(cx, &obj->global());
    return GlobalObject::initStandardClasses(cx, global);
}

#define EAGER_ATOM(name)            NAME_OFFSET(name)

typedef struct JSStdName {
    size_t      atomOffset;     /* offset of atom pointer in JSAtomState */
    JSProtoKey  key;
    bool isDummy() const { return key == JSProto_Null; }
    bool isSentinel() const { return key == JSProto_LIMIT; }
} JSStdName;

static const JSStdName*
LookupStdName(const JSAtomState& names, JSAtom* name, const JSStdName* table)
{
    for (unsigned i = 0; !table[i].isSentinel(); i++) {
        if (table[i].isDummy())
            continue;
        JSAtom* atom = AtomStateOffsetToName(names, table[i].atomOffset);
        MOZ_ASSERT(atom);
        if (name == atom)
            return &table[i];
    }

    return nullptr;
}

/*
 * Table of standard classes, indexed by JSProtoKey. For entries where the
 * JSProtoKey does not correspond to a class with a meaningful constructor, we
 * insert a null entry into the table.
 */
#define STD_NAME_ENTRY(name, code, init, clasp) { EAGER_ATOM(name), static_cast<JSProtoKey>(code) },
#define STD_DUMMY_ENTRY(name, code, init, dummy) { 0, JSProto_Null },
static const JSStdName standard_class_names[] = {
  JS_FOR_PROTOTYPES(STD_NAME_ENTRY, STD_DUMMY_ENTRY)
  { 0, JSProto_LIMIT }
};

/*
 * Table of top-level function and constant names and the JSProtoKey of the
 * standard class that initializes them.
 */
static const JSStdName builtin_property_names[] = {
    { EAGER_ATOM(eval), JSProto_Object },

    /* Global properties and functions defined by the Number class. */
    { EAGER_ATOM(NaN), JSProto_Number },
    { EAGER_ATOM(Infinity), JSProto_Number },
    { EAGER_ATOM(isNaN), JSProto_Number },
    { EAGER_ATOM(isFinite), JSProto_Number },
    { EAGER_ATOM(parseFloat), JSProto_Number },
    { EAGER_ATOM(parseInt), JSProto_Number },

    /* String global functions. */
    { EAGER_ATOM(escape), JSProto_String },
    { EAGER_ATOM(unescape), JSProto_String },
    { EAGER_ATOM(decodeURI), JSProto_String },
    { EAGER_ATOM(encodeURI), JSProto_String },
    { EAGER_ATOM(decodeURIComponent), JSProto_String },
    { EAGER_ATOM(encodeURIComponent), JSProto_String },
#if JS_HAS_UNEVAL
    { EAGER_ATOM(uneval), JSProto_String },
#endif

    { 0, JSProto_LIMIT }
};

#undef EAGER_ATOM

JS_PUBLIC_API(bool)
JS_ResolveStandardClass(JSContext* cx, HandleObject obj, HandleId id, bool* resolved)
{
    const JSStdName* stdnm;

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id);

    Rooted<GlobalObject*> global(cx, &obj->as<GlobalObject>());
    *resolved = false;

    if (!JSID_IS_ATOM(id))
        return true;

    /* Check whether we're resolving 'undefined', and define it if so. */
    JSAtom* idAtom = JSID_TO_ATOM(id);
    JSAtom* undefinedAtom = cx->names().undefined;
    if (idAtom == undefinedAtom) {
        *resolved = true;
        return DefineProperty(cx, global, id, UndefinedHandleValue, nullptr, nullptr,
                              JSPROP_PERMANENT | JSPROP_READONLY | JSPROP_RESOLVING);
    }

    /* Try for class constructors/prototypes named by well-known atoms. */
    stdnm = LookupStdName(cx->names(), idAtom, standard_class_names);

    /* Try less frequently used top-level functions and constants. */
    if (!stdnm)
        stdnm = LookupStdName(cx->names(), idAtom, builtin_property_names);

    if (stdnm && GlobalObject::skipDeselectedConstructor(cx, stdnm->key))
        stdnm = nullptr;

    // If this class is anonymous, then it doesn't exist as a global
    // property, so we won't resolve anything.
    JSProtoKey key = stdnm ? stdnm->key : JSProto_Null;
    if (key != JSProto_Null) {
        const Class* clasp = ProtoKeyToClass(key);
        if (!clasp || !(clasp->flags & JSCLASS_IS_ANONYMOUS)) {
            if (!GlobalObject::ensureConstructor(cx, global, key))
                return false;

            *resolved = true;
            return true;
        }
    }

    // There is no such property to resolve. An ordinary resolve hook would
    // just return true at this point. But the global object is special in one
    // more way: its prototype chain is lazily initialized. That is,
    // global->getProto() might be null right now because we haven't created
    // Object.prototype yet. Force it now.
    if (!global->getOrCreateObjectPrototype(cx))
        return false;

    return true;
}

JS_PUBLIC_API(bool)
JS_MayResolveStandardClass(const JSAtomState& names, jsid id, JSObject* maybeObj)
{
    MOZ_ASSERT_IF(maybeObj, maybeObj->is<GlobalObject>());

    // The global object's resolve hook is special: JS_ResolveStandardClass
    // initializes the prototype chain lazily. Only attempt to optimize here
    // if we know the prototype chain has been initialized.
    if (!maybeObj || !maybeObj->staticPrototype())
        return true;

    if (!JSID_IS_ATOM(id))
        return false;

    JSAtom* atom = JSID_TO_ATOM(id);

    // This will return true even for deselected constructors.  (To do
    // better, we need a JSContext here; it's fine as it is.)

    return atom == names.undefined ||
           LookupStdName(names, atom, standard_class_names) ||
           LookupStdName(names, atom, builtin_property_names);
}

JS_PUBLIC_API(bool)
JS_EnumerateStandardClasses(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    MOZ_ASSERT(obj->is<GlobalObject>());
    Rooted<GlobalObject*> global(cx, &obj->as<GlobalObject>());
    return GlobalObject::initStandardClasses(cx, global);
}

JS_PUBLIC_API(bool)
JS_GetClassObject(JSContext* cx, JSProtoKey key, MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return GetBuiltinConstructor(cx, key, objp);
}

JS_PUBLIC_API(bool)
JS_GetClassPrototype(JSContext* cx, JSProtoKey key, MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return GetBuiltinPrototype(cx, key, objp);
}

namespace JS {

JS_PUBLIC_API(void)
ProtoKeyToId(JSContext* cx, JSProtoKey key, MutableHandleId idp)
{
    idp.set(NameToId(ClassName(key, cx)));
}

} /* namespace JS */

JS_PUBLIC_API(JSProtoKey)
JS_IdToProtoKey(JSContext* cx, HandleId id)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    if (!JSID_IS_ATOM(id))
        return JSProto_Null;

    JSAtom* atom = JSID_TO_ATOM(id);
    const JSStdName* stdnm = LookupStdName(cx->names(), atom, standard_class_names);
    if (!stdnm)
        return JSProto_Null;

    if (GlobalObject::skipDeselectedConstructor(cx, stdnm->key))
        return JSProto_Null;

    MOZ_ASSERT(MOZ_ARRAY_LENGTH(standard_class_names) == JSProto_LIMIT + 1);
    return static_cast<JSProtoKey>(stdnm - standard_class_names);
}

JS_PUBLIC_API(JSObject*)
JS_GetObjectPrototype(JSContext* cx, HandleObject forObj)
{
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, forObj);
    return forObj->global().getOrCreateObjectPrototype(cx);
}

JS_PUBLIC_API(JSObject*)
JS_GetFunctionPrototype(JSContext* cx, HandleObject forObj)
{
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, forObj);
    return forObj->global().getOrCreateFunctionPrototype(cx);
}

JS_PUBLIC_API(JSObject*)
JS_GetArrayPrototype(JSContext* cx, HandleObject forObj)
{
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, forObj);
    Rooted<GlobalObject*> global(cx, &forObj->global());
    return GlobalObject::getOrCreateArrayPrototype(cx, global);
}

JS_PUBLIC_API(JSObject*)
JS_GetErrorPrototype(JSContext* cx)
{
    CHECK_REQUEST(cx);
    Rooted<GlobalObject*> global(cx, cx->global());
    return GlobalObject::getOrCreateCustomErrorPrototype(cx, global, JSEXN_ERR);
}

JS_PUBLIC_API(JSObject*)
JS_GetIteratorPrototype(JSContext* cx)
{
    CHECK_REQUEST(cx);
    Rooted<GlobalObject*> global(cx, cx->global());
    return GlobalObject::getOrCreateIteratorPrototype(cx, global);
}

JS_PUBLIC_API(JSObject*)
JS_GetGlobalForObject(JSContext* cx, JSObject* obj)
{
    AssertHeapIsIdle(cx);
    assertSameCompartment(cx, obj);
    return &obj->global();
}

extern JS_PUBLIC_API(bool)
JS_IsGlobalObject(JSObject* obj)
{
    return obj->is<GlobalObject>();
}

extern JS_PUBLIC_API(JSObject*)
JS_GlobalLexicalEnvironment(JSObject* obj)
{
    return &obj->as<GlobalObject>().lexicalEnvironment();
}

extern JS_PUBLIC_API(bool)
JS_HasExtensibleLexicalEnvironment(JSObject* obj)
{
    return obj->is<GlobalObject>() || obj->compartment()->getNonSyntacticLexicalEnvironment(obj);
}

extern JS_PUBLIC_API(JSObject*)
JS_ExtensibleLexicalEnvironment(JSObject* obj)
{
    JSObject* lexical = nullptr;
    if (obj->is<GlobalObject>())
        lexical = JS_GlobalLexicalEnvironment(obj);
    else
        lexical = obj->compartment()->getNonSyntacticLexicalEnvironment(obj);
    MOZ_ASSERT(lexical);
    return lexical;
}

JS_PUBLIC_API(JSObject*)
JS_GetGlobalForCompartmentOrNull(JSContext* cx, JSCompartment* c)
{
    AssertHeapIsIdleOrIterating(cx);
    assertSameCompartment(cx, c);
    return c->maybeGlobal();
}

JS_PUBLIC_API(JSObject*)
JS::CurrentGlobalOrNull(JSContext* cx)
{
    AssertHeapIsIdleOrIterating(cx);
    CHECK_REQUEST(cx);
    if (!cx->compartment())
        return nullptr;
    return cx->global();
}

JS_PUBLIC_API(Value)
JS::detail::ComputeThis(JSContext* cx, Value* vp)
{
    AssertHeapIsIdle(cx);
    assertSameCompartment(cx, JSValueArray(vp, 2));

    MutableHandleValue thisv = MutableHandleValue::fromMarkedLocation(&vp[1]);
    if (!BoxNonStrictThis(cx, thisv, thisv))
        return NullValue();

    return thisv;
}

JS_PUBLIC_API(void*)
JS_malloc(JSContext* cx, size_t nbytes)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return static_cast<void*>(cx->runtime()->pod_malloc<uint8_t>(nbytes));
}

JS_PUBLIC_API(void*)
JS_realloc(JSContext* cx, void* p, size_t oldBytes, size_t newBytes)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return static_cast<void*>(cx->zone()->pod_realloc<uint8_t>(static_cast<uint8_t*>(p), oldBytes,
                                                                newBytes));
}

JS_PUBLIC_API(void)
JS_free(JSContext* cx, void* p)
{
    return js_free(p);
}

JS_PUBLIC_API(void)
JS_freeop(JSFreeOp* fop, void* p)
{
    return FreeOp::get(fop)->free_(p);
}

JS_PUBLIC_API(void)
JS_updateMallocCounter(JSContext* cx, size_t nbytes)
{
    return cx->updateMallocCounter(nbytes);
}

JS_PUBLIC_API(char*)
JS_strdup(JSContext* cx, const char* s)
{
    AssertHeapIsIdle(cx);
    return DuplicateString(cx, s).release();
}

#undef JS_AddRoot

JS_PUBLIC_API(bool)
JS_AddExtraGCRootsTracer(JSContext* cx, JSTraceDataOp traceOp, void* data)
{
    return cx->gc.addBlackRootsTracer(traceOp, data);
}

JS_PUBLIC_API(void)
JS_RemoveExtraGCRootsTracer(JSContext* cx, JSTraceDataOp traceOp, void* data)
{
    return cx->gc.removeBlackRootsTracer(traceOp, data);
}

JS_PUBLIC_API(void)
JS_GC(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    JS::PrepareForFullGC(cx);
    cx->gc.gc(GC_NORMAL, JS::gcreason::API);
}

JS_PUBLIC_API(void)
JS_MaybeGC(JSContext* cx)
{
    GCRuntime& gc = cx->runtime()->gc;
    gc.maybeGC(cx->zone());
}

JS_PUBLIC_API(void)
JS_SetGCCallback(JSContext* cx, JSGCCallback cb, void* data)
{
    AssertHeapIsIdle(cx);
    cx->gc.setGCCallback(cb, data);
}

JS_PUBLIC_API(void)
JS_SetObjectsTenuredCallback(JSContext* cx, JSObjectsTenuredCallback cb,
                             void* data)
{
    AssertHeapIsIdle(cx);
    cx->gc.setObjectsTenuredCallback(cb, data);
}

JS_PUBLIC_API(bool)
JS_AddFinalizeCallback(JSContext* cx, JSFinalizeCallback cb, void* data)
{
    AssertHeapIsIdle(cx);
    return cx->gc.addFinalizeCallback(cb, data);
}

JS_PUBLIC_API(void)
JS_RemoveFinalizeCallback(JSContext* cx, JSFinalizeCallback cb)
{
    cx->gc.removeFinalizeCallback(cb);
}

JS_PUBLIC_API(bool)
JS_AddWeakPointerZoneGroupCallback(JSContext* cx, JSWeakPointerZoneGroupCallback cb, void* data)
{
    AssertHeapIsIdle(cx);
    return cx->gc.addWeakPointerZoneGroupCallback(cb, data);
}

JS_PUBLIC_API(void)
JS_RemoveWeakPointerZoneGroupCallback(JSContext* cx, JSWeakPointerZoneGroupCallback cb)
{
    cx->gc.removeWeakPointerZoneGroupCallback(cb);
}

JS_PUBLIC_API(bool)
JS_AddWeakPointerCompartmentCallback(JSContext* cx, JSWeakPointerCompartmentCallback cb,
                                     void* data)
{
    AssertHeapIsIdle(cx);
    return cx->gc.addWeakPointerCompartmentCallback(cb, data);
}

JS_PUBLIC_API(void)
JS_RemoveWeakPointerCompartmentCallback(JSContext* cx, JSWeakPointerCompartmentCallback cb)
{
    cx->gc.removeWeakPointerCompartmentCallback(cb);
}


JS_PUBLIC_API(void)
JS_UpdateWeakPointerAfterGC(JS::Heap<JSObject*>* objp)
{
    JS_UpdateWeakPointerAfterGCUnbarriered(objp->unsafeGet());
}

JS_PUBLIC_API(void)
JS_UpdateWeakPointerAfterGCUnbarriered(JSObject** objp)
{
    if (IsAboutToBeFinalizedUnbarriered(objp))
        *objp = nullptr;
}

JS_PUBLIC_API(void)
JS_SetGCParameter(JSContext* cx, JSGCParamKey key, uint32_t value)
{
    cx->gc.waitBackgroundSweepEnd();
    AutoLockGC lock(cx);
    MOZ_ALWAYS_TRUE(cx->gc.setParameter(key, value, lock));
}

JS_PUBLIC_API(uint32_t)
JS_GetGCParameter(JSContext* cx, JSGCParamKey key)
{
    AutoLockGC lock(cx);
    return cx->gc.getParameter(key, lock);
}

static const size_t NumGCConfigs = 14;
struct JSGCConfig {
    JSGCParamKey key;
    uint32_t value;
};

JS_PUBLIC_API(void)
JS_SetGCParametersBasedOnAvailableMemory(JSContext* cx, uint32_t availMem)
{
    static const JSGCConfig minimal[NumGCConfigs] = {
        {JSGC_MAX_MALLOC_BYTES, 6 * 1024 * 1024},
        {JSGC_SLICE_TIME_BUDGET, 30},
        {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
        {JSGC_HIGH_FREQUENCY_HIGH_LIMIT, 40},
        {JSGC_HIGH_FREQUENCY_LOW_LIMIT, 0},
        {JSGC_HIGH_FREQUENCY_HEAP_GROWTH_MAX, 300},
        {JSGC_HIGH_FREQUENCY_HEAP_GROWTH_MIN, 120},
        {JSGC_LOW_FREQUENCY_HEAP_GROWTH, 120},
        {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
        {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
        {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
        {JSGC_ALLOCATION_THRESHOLD, 1},
        {JSGC_MODE, JSGC_MODE_INCREMENTAL}
    };

    const JSGCConfig* config = minimal;
    if (availMem > 512) {
        static const JSGCConfig nominal[NumGCConfigs] = {
            {JSGC_MAX_MALLOC_BYTES, 6 * 1024 * 1024},
            {JSGC_SLICE_TIME_BUDGET, 30},
            {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1000},
            {JSGC_HIGH_FREQUENCY_HIGH_LIMIT, 500},
            {JSGC_HIGH_FREQUENCY_LOW_LIMIT, 100},
            {JSGC_HIGH_FREQUENCY_HEAP_GROWTH_MAX, 300},
            {JSGC_HIGH_FREQUENCY_HEAP_GROWTH_MIN, 150},
            {JSGC_LOW_FREQUENCY_HEAP_GROWTH, 150},
            {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
            {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
            {JSGC_HIGH_FREQUENCY_TIME_LIMIT, 1500},
            {JSGC_ALLOCATION_THRESHOLD, 30},
            {JSGC_MODE, JSGC_MODE_ZONE}
        };

        config = nominal;
    }

    for (size_t i = 0; i < NumGCConfigs; i++)
        JS_SetGCParameter(cx, config[i].key, config[i].value);
}


JS_PUBLIC_API(JSString*)
JS_NewExternalString(JSContext* cx, const char16_t* chars, size_t length,
                     const JSStringFinalizer* fin)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JSString* s = JSExternalString::new_(cx, chars, length, fin);
    return s;
}

extern JS_PUBLIC_API(bool)
JS_IsExternalString(JSString* str)
{
    return str->isExternal();
}

extern JS_PUBLIC_API(const JSStringFinalizer*)
JS_GetExternalStringFinalizer(JSString* str)
{
    return str->asExternal().externalFinalizer();
}

static void
SetNativeStackQuotaAndLimit(JSContext* cx, StackKind kind, size_t stackSize)
{
    cx->nativeStackQuota[kind] = stackSize;

#if JS_STACK_GROWTH_DIRECTION > 0
    if (stackSize == 0) {
        cx->nativeStackLimit[kind] = UINTPTR_MAX;
    } else {
        MOZ_ASSERT(cx->nativeStackBase <= size_t(-1) - stackSize);
        cx->nativeStackLimit[kind] = cx->nativeStackBase + stackSize - 1;
    }
#else
    if (stackSize == 0) {
        cx->nativeStackLimit[kind] = 0;
    } else {
        MOZ_ASSERT(cx->nativeStackBase >= stackSize);
        cx->nativeStackLimit[kind] = cx->nativeStackBase - (stackSize - 1);
    }
#endif
}

JS_PUBLIC_API(void)
JS_SetNativeStackQuota(JSContext* cx, size_t systemCodeStackSize, size_t trustedScriptStackSize,
                       size_t untrustedScriptStackSize)
{
    MOZ_ASSERT(cx->requestDepth == 0);

    if (!trustedScriptStackSize)
        trustedScriptStackSize = systemCodeStackSize;
    else
        MOZ_ASSERT(trustedScriptStackSize < systemCodeStackSize);

    if (!untrustedScriptStackSize)
        untrustedScriptStackSize = trustedScriptStackSize;
    else
        MOZ_ASSERT(untrustedScriptStackSize < trustedScriptStackSize);

    SetNativeStackQuotaAndLimit(cx, StackForSystemCode, systemCodeStackSize);
    SetNativeStackQuotaAndLimit(cx, StackForTrustedScript, trustedScriptStackSize);
    SetNativeStackQuotaAndLimit(cx, StackForUntrustedScript, untrustedScriptStackSize);

    cx->initJitStackLimit();
}

/************************************************************************/

JS_PUBLIC_API(bool)
JS_ValueToId(JSContext* cx, HandleValue value, MutableHandleId idp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    return ValueToId<CanGC>(cx, value, idp);
}

JS_PUBLIC_API(bool)
JS_StringToId(JSContext* cx, HandleString string, MutableHandleId idp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, string);
    RootedValue value(cx, StringValue(string));
    return ValueToId<CanGC>(cx, value, idp);
}

JS_PUBLIC_API(bool)
JS_IdToValue(JSContext* cx, jsid id, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    vp.set(IdToValue(id));
    assertSameCompartment(cx, vp);
    return true;
}

JS_PUBLIC_API(bool)
JS::ToPrimitive(JSContext* cx, HandleObject obj, JSType hint, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT(obj != nullptr);
    MOZ_ASSERT(hint == JSTYPE_VOID || hint == JSTYPE_STRING || hint == JSTYPE_NUMBER);
    vp.setObject(*obj);
    return ToPrimitiveSlow(cx, hint, vp);
}

JS_PUBLIC_API(bool)
JS::GetFirstArgumentAsTypeHint(JSContext* cx, CallArgs args, JSType *result)
{
    if (!args.get(0).isString()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_NOT_EXPECTED_TYPE,
                                  "Symbol.toPrimitive",
                                  "\"string\", \"number\", or \"default\"",
                                  InformalValueTypeName(args.get(0)));
        return false;
    }

    RootedString str(cx, args.get(0).toString());
    bool match;

    if (!EqualStrings(cx, str, cx->names().default_, &match))
        return false;
    if (match) {
        *result = JSTYPE_VOID;
        return true;
    }

    if (!EqualStrings(cx, str, cx->names().string, &match))
        return false;
    if (match) {
        *result = JSTYPE_STRING;
        return true;
    }

    if (!EqualStrings(cx, str, cx->names().number, &match))
        return false;
    if (match) {
        *result = JSTYPE_NUMBER;
        return true;
    }

    JSAutoByteString bytes;
    const char* source = ValueToSourceForError(cx, args.get(0), bytes);
    if (!source) {
        ReportOutOfMemory(cx);
        return false;
    }

    JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_NOT_EXPECTED_TYPE,
                               "Symbol.toPrimitive",
                               "\"string\", \"number\", or \"default\"", source);
    return false;
}

JS_PUBLIC_API(bool)
JS_PropertyStub(JSContext* cx, HandleObject obj, HandleId id, MutableHandleValue vp)
{
    return true;
}

JS_PUBLIC_API(bool)
JS_StrictPropertyStub(JSContext* cx, HandleObject obj, HandleId id, MutableHandleValue vp,
                      ObjectOpResult& result)
{
    return result.succeed();
}

JS_PUBLIC_API(JSObject*)
JS_InitClass(JSContext* cx, HandleObject obj, HandleObject parent_proto,
             const JSClass* clasp, JSNative constructor, unsigned nargs,
             const JSPropertySpec* ps, const JSFunctionSpec* fs,
             const JSPropertySpec* static_ps, const JSFunctionSpec* static_fs)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, parent_proto);
    return InitClass(cx, obj, parent_proto, Valueify(clasp), constructor,
                     nargs, ps, fs, static_ps, static_fs);
}

JS_PUBLIC_API(bool)
JS_LinkConstructorAndPrototype(JSContext* cx, HandleObject ctor, HandleObject proto)
{
    return LinkConstructorAndPrototype(cx, ctor, proto);
}

JS_PUBLIC_API(const JSClass*)
JS_GetClass(JSObject* obj)
{
    return obj->getJSClass();
}

JS_PUBLIC_API(bool)
JS_InstanceOf(JSContext* cx, HandleObject obj, const JSClass* clasp, CallArgs* args)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
#ifdef DEBUG
    if (args) {
        assertSameCompartment(cx, obj);
        assertSameCompartment(cx, args->thisv(), args->calleev());
    }
#endif
    if (!obj || obj->getJSClass() != clasp) {
        if (args)
            ReportIncompatibleMethod(cx, *args, Valueify(clasp));
        return false;
    }
    return true;
}

JS_PUBLIC_API(bool)
JS_HasInstance(JSContext* cx, HandleObject obj, HandleValue value, bool* bp)
{
    AssertHeapIsIdle(cx);
    assertSameCompartment(cx, obj, value);
    return HasInstance(cx, obj, value, bp);
}

JS_PUBLIC_API(void*)
JS_GetPrivate(JSObject* obj)
{
    /* This function can be called by a finalizer. */
    return obj->as<NativeObject>().getPrivate();
}

JS_PUBLIC_API(void)
JS_SetPrivate(JSObject* obj, void* data)
{
    /* This function can be called by a finalizer. */
    obj->as<NativeObject>().setPrivate(data);
}

JS_PUBLIC_API(void*)
JS_GetInstancePrivate(JSContext* cx, HandleObject obj, const JSClass* clasp, CallArgs* args)
{
    if (!JS_InstanceOf(cx, obj, clasp, args))
        return nullptr;
    return obj->as<NativeObject>().getPrivate();
}

JS_PUBLIC_API(JSObject*)
JS_GetConstructor(JSContext* cx, HandleObject proto)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, proto);

    RootedValue cval(cx);
    if (!GetProperty(cx, proto, proto, cx->names().constructor, &cval))
        return nullptr;
    if (!IsFunctionObject(cval)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_NO_CONSTRUCTOR,
                                  proto->getClass()->name);
        return nullptr;
    }
    return &cval.toObject();
}

bool
JS::CompartmentBehaviors::extraWarnings(JSContext* cx) const
{
    return extraWarningsOverride_.get(cx->options().extraWarnings());
}

JS::CompartmentCreationOptions&
JS::CompartmentCreationOptions::setZone(ZoneSpecifier spec)
{
    zone_.spec = spec;
    return *this;
}

JS::CompartmentCreationOptions&
JS::CompartmentCreationOptions::setSameZoneAs(JSObject* obj)
{
    zone_.pointer = static_cast<void*>(obj->zone());
    return *this;
}

const JS::CompartmentCreationOptions&
JS::CompartmentCreationOptionsRef(JSCompartment* compartment)
{
    return compartment->creationOptions();
}

const JS::CompartmentCreationOptions&
JS::CompartmentCreationOptionsRef(JSObject* obj)
{
    return obj->compartment()->creationOptions();
}

const JS::CompartmentCreationOptions&
JS::CompartmentCreationOptionsRef(JSContext* cx)
{
    return cx->compartment()->creationOptions();
}

bool
JS::CompartmentCreationOptions::getSharedMemoryAndAtomicsEnabled() const
{
#if defined(ENABLE_SHARED_ARRAY_BUFFER)
    return sharedMemoryAndAtomics_;
#else
    return false;
#endif
}

JS::CompartmentCreationOptions&
JS::CompartmentCreationOptions::setSharedMemoryAndAtomicsEnabled(bool flag)
{
#if defined(ENABLE_SHARED_ARRAY_BUFFER)
    sharedMemoryAndAtomics_ = flag;
#endif
    return *this;
}

JS::CompartmentBehaviors&
JS::CompartmentBehaviorsRef(JSCompartment* compartment)
{
    return compartment->behaviors();
}

JS::CompartmentBehaviors&
JS::CompartmentBehaviorsRef(JSObject* obj)
{
    return obj->compartment()->behaviors();
}

JS::CompartmentBehaviors&
JS::CompartmentBehaviorsRef(JSContext* cx)
{
    return cx->compartment()->behaviors();
}

JS_PUBLIC_API(JSObject*)
JS_NewGlobalObject(JSContext* cx, const JSClass* clasp, JSPrincipals* principals,
                   JS::OnNewGlobalHookOption hookOption,
                   const JS::CompartmentOptions& options)
{
    MOZ_RELEASE_ASSERT(cx->runtime()->hasInitializedSelfHosting(),
                       "Must call JS::InitSelfHostedCode() before creating a global");

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return GlobalObject::new_(cx, Valueify(clasp), principals, hookOption, options);
}

JS_PUBLIC_API(void)
JS_GlobalObjectTraceHook(JSTracer* trc, JSObject* global)
{
    MOZ_ASSERT(global->is<GlobalObject>());

    // Off thread parsing and compilation tasks create a dummy global which is
    // then merged back into the host compartment. Since it used to be a
    // global, it will still have this trace hook, but it does not have a
    // meaning relative to its new compartment. We can safely skip it.
    //
    // Similarly, if we GC when creating the global, we may not have set that
    // global's compartment's global pointer yet. In this case, the compartment
    // will not yet contain anything that needs to be traced.
    if (!global->isOwnGlobal(trc))
        return;

    // Trace the compartment for any GC things that should only stick around if
    // we know the compartment is live.
    global->compartment()->trace(trc);

    if (JSTraceOp trace = global->compartment()->creationOptions().getTrace())
        trace(trc, global);
}

JS_PUBLIC_API(void)
JS_FireOnNewGlobalObject(JSContext* cx, JS::HandleObject global)
{
    // This hook is infallible, because we don't really want arbitrary script
    // to be able to throw errors during delicate global creation routines.
    // This infallibility will eat OOM and slow script, but if that happens
    // we'll likely run up into them again soon in a fallible context.
    Rooted<js::GlobalObject*> globalObject(cx, &global->as<GlobalObject>());
    Debugger::onNewGlobalObject(cx, globalObject);
}

JS_PUBLIC_API(JSObject*)
JS_NewObject(JSContext* cx, const JSClass* jsclasp)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    const Class* clasp = Valueify(jsclasp);
    if (!clasp)
        clasp = &PlainObject::class_;    /* default class is Object */

    MOZ_ASSERT(clasp != &JSFunction::class_);
    MOZ_ASSERT(!(clasp->flags & JSCLASS_IS_GLOBAL));

    return NewObjectWithClassProto(cx, clasp, nullptr);
}

JS_PUBLIC_API(JSObject*)
JS_NewObjectWithGivenProto(JSContext* cx, const JSClass* jsclasp, HandleObject proto)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, proto);

    const Class* clasp = Valueify(jsclasp);
    if (!clasp)
        clasp = &PlainObject::class_;    /* default class is Object */

    MOZ_ASSERT(clasp != &JSFunction::class_);
    MOZ_ASSERT(!(clasp->flags & JSCLASS_IS_GLOBAL));

    return NewObjectWithGivenProto(cx, clasp, proto);
}

JS_PUBLIC_API(JSObject*)
JS_NewPlainObject(JSContext* cx)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return NewBuiltinClassInstance<PlainObject>(cx);
}

JS_PUBLIC_API(JSObject*)
JS_NewObjectForConstructor(JSContext* cx, const JSClass* clasp, const CallArgs& args)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    Value callee = args.calleev();
    assertSameCompartment(cx, callee);
    RootedObject obj(cx, &callee.toObject());
    return CreateThis(cx, Valueify(clasp), obj);
}

JS_PUBLIC_API(bool)
JS_IsNative(JSObject* obj)
{
    return obj->isNative();
}

JS_PUBLIC_API(void)
JS::AssertObjectBelongsToCurrentThread(JSObject* obj)
{
    JSRuntime* rt = obj->compartment()->runtimeFromAnyThread();
    MOZ_RELEASE_ASSERT(CurrentThreadCanAccessRuntime(rt));
}


/*** Standard internal methods *******************************************************************/

JS_PUBLIC_API(bool)
JS_GetPrototype(JSContext* cx, HandleObject obj, MutableHandleObject result)
{
    return GetPrototype(cx, obj, result);
}

JS_PUBLIC_API(bool)
JS_SetPrototype(JSContext* cx, HandleObject obj, HandleObject proto)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, proto);

    return SetPrototype(cx, obj, proto);
}

JS_PUBLIC_API(bool)
JS_GetPrototypeIfOrdinary(JSContext* cx, HandleObject obj, bool* isOrdinary,
                          MutableHandleObject result)
{
    return GetPrototypeIfOrdinary(cx, obj, isOrdinary, result);
}

JS_PUBLIC_API(bool)
JS_IsExtensible(JSContext* cx, HandleObject obj, bool* extensible)
{
    return IsExtensible(cx, obj, extensible);
}

JS_PUBLIC_API(bool)
JS_PreventExtensions(JSContext* cx, JS::HandleObject obj, ObjectOpResult& result)
{
    return PreventExtensions(cx, obj, result);
}

JS_PUBLIC_API(bool)
JS_SetImmutablePrototype(JSContext *cx, JS::HandleObject obj, bool *succeeded)
{
    return SetImmutablePrototype(cx, obj, succeeded);
}

JS_PUBLIC_API(bool)
JS_GetOwnPropertyDescriptorById(JSContext* cx, HandleObject obj, HandleId id,
                                MutableHandle<PropertyDescriptor> desc)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return GetOwnPropertyDescriptor(cx, obj, id, desc);
}

JS_PUBLIC_API(bool)
JS_GetOwnPropertyDescriptor(JSContext* cx, HandleObject obj, const char* name,
                            MutableHandle<PropertyDescriptor> desc)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_GetOwnPropertyDescriptorById(cx, obj, id, desc);
}

JS_PUBLIC_API(bool)
JS_GetOwnUCPropertyDescriptor(JSContext* cx, HandleObject obj, const char16_t* name,
                              MutableHandle<PropertyDescriptor> desc)
{
    JSAtom* atom = AtomizeChars(cx, name, js_strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_GetOwnPropertyDescriptorById(cx, obj, id, desc);
}

JS_PUBLIC_API(bool)
JS_GetPropertyDescriptorById(JSContext* cx, HandleObject obj, HandleId id,
                             MutableHandle<PropertyDescriptor> desc)
{
    return GetPropertyDescriptor(cx, obj, id, desc);
}

JS_PUBLIC_API(bool)
JS_GetPropertyDescriptor(JSContext* cx, HandleObject obj, const char* name,
                         MutableHandle<PropertyDescriptor> desc)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return atom && JS_GetPropertyDescriptorById(cx, obj, id, desc);
}

static bool
DefinePropertyByDescriptor(JSContext* cx, HandleObject obj, HandleId id,
                           Handle<PropertyDescriptor> desc, ObjectOpResult& result)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id, desc);
    return DefineProperty(cx, obj, id, desc.value(), desc.getter(), desc.setter(),
                          desc.attributes(), result);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id,
                      Handle<PropertyDescriptor> desc, ObjectOpResult& result)
{
    return DefinePropertyByDescriptor(cx, obj, id, desc, result);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id,
                      Handle<PropertyDescriptor> desc)
{
    ObjectOpResult result;
    return DefinePropertyByDescriptor(cx, obj, id, desc, result) &&
           result.checkStrict(cx, obj, id);
}

static bool
DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, HandleValue value,
                   const JSNativeWrapper& get, const JSNativeWrapper& set,
                   unsigned attrs, unsigned flags)
{
    JSGetterOp getter = JS_CAST_NATIVE_TO(get.op, JSGetterOp);
    JSSetterOp setter = JS_CAST_NATIVE_TO(set.op, JSSetterOp);

    // JSPROP_READONLY has no meaning when accessors are involved. Ideally we'd
    // throw if this happens, but we've accepted it for long enough that it's
    // not worth trying to make callers change their ways. Just flip it off on
    // its way through the API layer so that we can enforce this internally.
    if (attrs & (JSPROP_GETTER | JSPROP_SETTER))
        attrs &= ~JSPROP_READONLY;

    // When we use DefineProperty, we need full scriptable Function objects rather
    // than JSNatives. However, we might be pulling this property descriptor off
    // of something with JSNative property descriptors. If we are, wrap them in
    // JS Function objects.
    //
    // But skip doing this if our accessors are the well-known stub
    // accessors, since those are known to be JSGetterOps.  Assert
    // some sanity about it, though.
    MOZ_ASSERT_IF(getter == JS_PropertyStub,
                  setter == JS_StrictPropertyStub || (attrs & JSPROP_PROPOP_ACCESSORS));
    MOZ_ASSERT_IF(setter == JS_StrictPropertyStub,
                  getter == JS_PropertyStub || (attrs & JSPROP_PROPOP_ACCESSORS));

    // If !(attrs & JSPROP_PROPOP_ACCESSORS), then either getter/setter are both
    // possibly-null JSNatives (or possibly-null JSFunction* if JSPROP_GETTER or
    // JSPROP_SETTER is appropriately set), or both are the well-known property
    // stubs.  The subsequent block must handle only the first of these cases,
    // so carefully exclude the latter case.
    if (!(attrs & JSPROP_PROPOP_ACCESSORS) &&
        getter != JS_PropertyStub && setter != JS_StrictPropertyStub)
    {
        if (getter && !(attrs & JSPROP_GETTER)) {
            RootedAtom atom(cx, IdToFunctionName(cx, id, "get"));
            if (!atom)
                return false;
            JSFunction* getobj = NewNativeFunction(cx, (Native) getter, 0, atom);
            if (!getobj)
                return false;

            if (get.info)
                getobj->setJitInfo(get.info);

            getter = JS_DATA_TO_FUNC_PTR(GetterOp, getobj);
            attrs |= JSPROP_GETTER;
        }
        if (setter && !(attrs & JSPROP_SETTER)) {
            // Root just the getter, since the setter is not yet a JSObject.
            AutoRooterGetterSetter getRoot(cx, JSPROP_GETTER, &getter, nullptr);
            RootedAtom atom(cx, IdToFunctionName(cx, id, "set"));
            if (!atom)
                return false;
            JSFunction* setobj = NewNativeFunction(cx, (Native) setter, 1, atom);
            if (!setobj)
                return false;

            if (set.info)
                setobj->setJitInfo(set.info);

            setter = JS_DATA_TO_FUNC_PTR(SetterOp, setobj);
            attrs |= JSPROP_SETTER;
        }
    } else {
        attrs &= ~JSPROP_PROPOP_ACCESSORS;
    }

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id, value,
                          (attrs & JSPROP_GETTER)
                          ? JS_FUNC_TO_DATA_PTR(JSObject*, getter)
                          : nullptr,
                          (attrs & JSPROP_SETTER)
                          ? JS_FUNC_TO_DATA_PTR(JSObject*, setter)
                          : nullptr);

    // In most places throughout the engine, a property with null getter and
    // not JSPROP_GETTER/SETTER/SHARED has no getter, and the same for setters:
    // it's just a plain old data property. However the JS_Define* APIs use
    // null getter and setter to mean "default to the Class getProperty and
    // setProperty ops".
    if (!(attrs & (JSPROP_GETTER | JSPROP_SETTER))) {
        if (!getter)
            getter = obj->getClass()->getGetProperty();
        if (!setter)
            setter = obj->getClass()->getSetProperty();
    }
    if (getter == JS_PropertyStub)
        getter = nullptr;
    if (setter == JS_StrictPropertyStub)
        setter = nullptr;
    return DefineProperty(cx, obj, id, value, getter, setter, attrs);
}

/*
 * Wrapper functions to create wrappers with no corresponding JSJitInfo from API
 * function arguments.
 */
static JSNativeWrapper
NativeOpWrapper(Native native)
{
    JSNativeWrapper ret;
    ret.op = native;
    ret.info = nullptr;
    return ret;
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, HandleValue value,
                      unsigned attrs, Native getter, Native setter)
{
    return DefinePropertyById(cx, obj, id, value,
                              NativeOpWrapper(getter), NativeOpWrapper(setter),
                              attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, HandleObject valueArg,
                      unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, ObjectValue(*valueArg));
    return DefinePropertyById(cx, obj, id, value,
                              NativeOpWrapper(getter), NativeOpWrapper(setter),
                              attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, HandleString valueArg,
                      unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, StringValue(valueArg));
    return DefinePropertyById(cx, obj, id, value,
                              NativeOpWrapper(getter), NativeOpWrapper(setter),
                              attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, int32_t valueArg,
                      unsigned attrs, Native getter, Native setter)
{
    Value value = Int32Value(valueArg);
    return DefinePropertyById(cx, obj, id, HandleValue::fromMarkedLocation(&value),
                              NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, uint32_t valueArg,
                      unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefinePropertyById(cx, obj, id, HandleValue::fromMarkedLocation(&value),
                              NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefinePropertyById(JSContext* cx, HandleObject obj, HandleId id, double valueArg,
                      unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefinePropertyById(cx, obj, id, HandleValue::fromMarkedLocation(&value),
                              NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

static bool
DefineProperty(JSContext* cx, HandleObject obj, const char* name, HandleValue value,
               const JSNativeWrapper& getter, const JSNativeWrapper& setter,
               unsigned attrs, unsigned flags)
{
    AutoRooterGetterSetter gsRoot(cx, attrs, const_cast<JSNative*>(&getter.op),
                                  const_cast<JSNative*>(&setter.op));

    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));

    return DefinePropertyById(cx, obj, id, value, getter, setter, attrs, flags);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, HandleValue value,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    return DefineProperty(cx, obj, name, value, NativeOpWrapper(getter), NativeOpWrapper(setter),
                          attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, HandleObject valueArg,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    RootedValue value(cx, ObjectValue(*valueArg));
    return DefineProperty(cx, obj, name, value, NativeOpWrapper(getter), NativeOpWrapper(setter),
                          attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, HandleString valueArg,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    RootedValue value(cx, StringValue(valueArg));
    return DefineProperty(cx, obj, name, value, NativeOpWrapper(getter), NativeOpWrapper(setter),
                          attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, int32_t valueArg,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    Value value = Int32Value(valueArg);
    return DefineProperty(cx, obj, name, HandleValue::fromMarkedLocation(&value),
                          NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, uint32_t valueArg,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    Value value = NumberValue(valueArg);
    return DefineProperty(cx, obj, name, HandleValue::fromMarkedLocation(&value),
                          NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineProperty(JSContext* cx, HandleObject obj, const char* name, double valueArg,
                  unsigned attrs,
                  Native getter /* = nullptr */, Native setter /* = nullptr */)
{
    Value value = NumberValue(valueArg);
    return DefineProperty(cx, obj, name, HandleValue::fromMarkedLocation(&value),
                          NativeOpWrapper(getter), NativeOpWrapper(setter), attrs, 0);
}

#define AUTO_NAMELEN(s,n)   (((n) == (size_t)-1) ? js_strlen(s) : (n))

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    Handle<PropertyDescriptor> desc,
                    ObjectOpResult& result)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return DefinePropertyByDescriptor(cx, obj, id, desc, result);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    Handle<PropertyDescriptor> desc)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    ObjectOpResult result;
    return DefinePropertyByDescriptor(cx, obj, id, desc, result) &&
           result.checkStrict(cx, obj, id);
}

static bool
DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                 const Value& value_, Native getter, Native setter, unsigned attrs,
                 unsigned flags)
{
    RootedValue value(cx, value_);
    AutoRooterGetterSetter gsRoot(cx, attrs, &getter, &setter);
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return DefinePropertyById(cx, obj, id, value, NativeOpWrapper(getter), NativeOpWrapper(setter),
                              attrs, flags);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    HandleValue value, unsigned attrs, Native getter, Native setter)
{
    return DefineUCProperty(cx, obj, name, namelen, value, getter, setter, attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    HandleObject valueArg, unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, ObjectValue(*valueArg));
    return DefineUCProperty(cx, obj, name, namelen, value, getter, setter, attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    HandleString valueArg, unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, StringValue(valueArg));
    return DefineUCProperty(cx, obj, name, namelen, value, getter, setter, attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    int32_t valueArg, unsigned attrs, Native getter, Native setter)
{
    Value value = Int32Value(valueArg);
    return DefineUCProperty(cx, obj, name, namelen, HandleValue::fromMarkedLocation(&value),
                            getter, setter, attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    uint32_t valueArg, unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefineUCProperty(cx, obj, name, namelen, HandleValue::fromMarkedLocation(&value),
                            getter, setter, attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    double valueArg, unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefineUCProperty(cx, obj, name, namelen, HandleValue::fromMarkedLocation(&value),
                            getter, setter, attrs, 0);
}

static bool
DefineElement(JSContext* cx, HandleObject obj, uint32_t index, HandleValue value,
              unsigned attrs, Native getter, Native setter)
{
    AutoRooterGetterSetter gsRoot(cx, attrs, &getter, &setter);
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return DefinePropertyById(cx, obj, id, value,
                              NativeOpWrapper(getter), NativeOpWrapper(setter),
                              attrs, 0);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, HandleValue value,
                 unsigned attrs, Native getter, Native setter)
{
    return DefineElement(cx, obj, index, value, attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, HandleObject valueArg,
                 unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, ObjectValue(*valueArg));
    return DefineElement(cx, obj, index, value, attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, HandleString valueArg,
                 unsigned attrs, Native getter, Native setter)
{
    RootedValue value(cx, StringValue(valueArg));
    return DefineElement(cx, obj, index, value, attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, int32_t valueArg,
                 unsigned attrs, Native getter, Native setter)
{
    Value value = Int32Value(valueArg);
    return DefineElement(cx, obj, index, HandleValue::fromMarkedLocation(&value),
                         attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, uint32_t valueArg,
                 unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefineElement(cx, obj, index, HandleValue::fromMarkedLocation(&value),
                         attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_DefineElement(JSContext* cx, HandleObject obj, uint32_t index, double valueArg,
                 unsigned attrs, Native getter, Native setter)
{
    Value value = NumberValue(valueArg);
    return DefineElement(cx, obj, index, HandleValue::fromMarkedLocation(&value),
                         attrs, getter, setter);
}

JS_PUBLIC_API(bool)
JS_HasPropertyById(JSContext* cx, HandleObject obj, HandleId id, bool* foundp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return HasProperty(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_HasProperty(JSContext* cx, HandleObject obj, const char* name, bool* foundp)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_HasPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_HasUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen, bool* foundp)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_HasPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_HasElement(JSContext* cx, HandleObject obj, uint32_t index, bool* foundp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return JS_HasPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_HasOwnPropertyById(JSContext* cx, HandleObject obj, HandleId id, bool* foundp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id);

    return HasOwnProperty(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_HasOwnProperty(JSContext* cx, HandleObject obj, const char* name, bool* foundp)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_HasOwnPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_ForwardGetPropertyTo(JSContext* cx, HandleObject obj, HandleId id, HandleValue receiver,
                        MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id, receiver);

    return GetProperty(cx, obj, receiver, id, vp);
}

JS_PUBLIC_API(bool)
JS_ForwardGetElementTo(JSContext* cx, HandleObject obj, uint32_t index, HandleObject receiver,
                       MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    return GetElement(cx, obj, receiver, index, vp);
}

JS_PUBLIC_API(bool)
JS_GetPropertyById(JSContext* cx, HandleObject obj, HandleId id, MutableHandleValue vp)
{
    RootedValue receiver(cx, ObjectValue(*obj));
    return JS_ForwardGetPropertyTo(cx, obj, id, receiver, vp);
}

JS_PUBLIC_API(bool)
JS_GetProperty(JSContext* cx, HandleObject obj, const char* name, MutableHandleValue vp)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_GetPropertyById(cx, obj, id, vp);
}

JS_PUBLIC_API(bool)
JS_GetUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                 MutableHandleValue vp)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_GetPropertyById(cx, obj, id, vp);
}

JS_PUBLIC_API(bool)
JS_GetElement(JSContext* cx, HandleObject objArg, uint32_t index, MutableHandleValue vp)
{
    return JS_ForwardGetElementTo(cx, objArg, index, objArg, vp);
}

JS_PUBLIC_API(bool)
JS_ForwardSetPropertyTo(JSContext* cx, HandleObject obj, HandleId id, HandleValue v,
                        HandleValue receiver, ObjectOpResult& result)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id, receiver);

    return SetProperty(cx, obj, id, v, receiver, result);
}

JS_PUBLIC_API(bool)
JS_SetPropertyById(JSContext* cx, HandleObject obj, HandleId id, HandleValue v)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id);

    RootedValue receiver(cx, ObjectValue(*obj));
    ObjectOpResult ignored;
    return SetProperty(cx, obj, id, v, receiver, ignored);
}

JS_PUBLIC_API(bool)
JS_SetProperty(JSContext* cx, HandleObject obj, const char* name, HandleValue v)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_SetPropertyById(cx, obj, id, v);
}

JS_PUBLIC_API(bool)
JS_SetUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                 HandleValue v)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_SetPropertyById(cx, obj, id, v);
}

static bool
SetElement(JSContext* cx, HandleObject obj, uint32_t index, HandleValue v)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, v);

    RootedValue receiver(cx, ObjectValue(*obj));
    ObjectOpResult ignored;
    return SetElement(cx, obj, index, v, receiver, ignored);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, HandleValue v)
{
    return SetElement(cx, obj, index, v);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, HandleObject v)
{
    RootedValue value(cx, ObjectOrNullValue(v));
    return SetElement(cx, obj, index, value);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, HandleString v)
{
    RootedValue value(cx, StringValue(v));
    return SetElement(cx, obj, index, value);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, int32_t v)
{
    RootedValue value(cx, NumberValue(v));
    return SetElement(cx, obj, index, value);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, uint32_t v)
{
    RootedValue value(cx, NumberValue(v));
    return SetElement(cx, obj, index, value);
}

JS_PUBLIC_API(bool)
JS_SetElement(JSContext* cx, HandleObject obj, uint32_t index, double v)
{
    RootedValue value(cx, NumberValue(v));
    return SetElement(cx, obj, index, value);
}

JS_PUBLIC_API(bool)
JS_DeletePropertyById(JSContext* cx, HandleObject obj, HandleId id, ObjectOpResult& result)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id);

    return DeleteProperty(cx, obj, id, result);
}

JS_PUBLIC_API(bool)
JS_DeleteProperty(JSContext* cx, HandleObject obj, const char* name, ObjectOpResult& result)
{
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return DeleteProperty(cx, obj, id, result);
}

JS_PUBLIC_API(bool)
JS_DeleteUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                    ObjectOpResult& result)
{
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return DeleteProperty(cx, obj, id, result);
}

JS_PUBLIC_API(bool)
JS_DeleteElement(JSContext* cx, HandleObject obj, uint32_t index, ObjectOpResult& result)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    return DeleteElement(cx, obj, index, result);
}

JS_PUBLIC_API(bool)
JS_DeletePropertyById(JSContext* cx, HandleObject obj, HandleId id)
{
    ObjectOpResult ignored;
    return JS_DeletePropertyById(cx, obj, id, ignored);
}

JS_PUBLIC_API(bool)
JS_DeleteProperty(JSContext* cx, HandleObject obj, const char* name)
{
    ObjectOpResult ignored;
    return JS_DeleteProperty(cx, obj, name, ignored);
}

JS_PUBLIC_API(bool)
JS_DeleteElement(JSContext* cx, HandleObject obj, uint32_t index)
{
    ObjectOpResult ignored;
    return JS_DeleteElement(cx, obj, index, ignored);
}

JS_PUBLIC_API(bool)
JS_Enumerate(JSContext* cx, HandleObject obj, JS::MutableHandle<IdVector> props)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    MOZ_ASSERT(props.empty());

    AutoIdVector ids(cx);
    if (!GetPropertyKeys(cx, obj, JSITER_OWNONLY, &ids))
        return false;

    return props.append(ids.begin(), ids.end());
}

JS_PUBLIC_API(bool)
JS::IsCallable(JSObject* obj)
{
    return obj->isCallable();
}

JS_PUBLIC_API(bool)
JS::IsConstructor(JSObject* obj)
{
    return obj->isConstructor();
}

JS_PUBLIC_API(bool)
JS_CallFunctionValue(JSContext* cx, HandleObject obj, HandleValue fval, const HandleValueArray& args,
                     MutableHandleValue rval)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, fval, args);

    InvokeArgs iargs(cx);
    if (!FillArgumentsFromArraylike(cx, iargs, args))
        return false;

    RootedValue thisv(cx, ObjectOrNullValue(obj));
    return Call(cx, fval, thisv, iargs, rval);
}

JS_PUBLIC_API(bool)
JS_CallFunction(JSContext* cx, HandleObject obj, HandleFunction fun, const HandleValueArray& args,
                MutableHandleValue rval)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, fun, args);

    InvokeArgs iargs(cx);
    if (!FillArgumentsFromArraylike(cx, iargs, args))
        return false;

    RootedValue fval(cx, ObjectValue(*fun));
    RootedValue thisv(cx, ObjectOrNullValue(obj));
    return Call(cx, fval, thisv, iargs, rval);
}

JS_PUBLIC_API(bool)
JS_CallFunctionName(JSContext* cx, HandleObject obj, const char* name, const HandleValueArray& args,
                    MutableHandleValue rval)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, args);

    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;

    RootedValue fval(cx);
    RootedId id(cx, AtomToId(atom));
    if (!GetProperty(cx, obj, obj, id, &fval))
        return false;

    InvokeArgs iargs(cx);
    if (!FillArgumentsFromArraylike(cx, iargs, args))
        return false;

    RootedValue thisv(cx, ObjectOrNullValue(obj));
    return Call(cx, fval, thisv, iargs, rval);
}

JS_PUBLIC_API(bool)
JS::Call(JSContext* cx, HandleValue thisv, HandleValue fval, const JS::HandleValueArray& args,
         MutableHandleValue rval)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, thisv, fval, args);

    InvokeArgs iargs(cx);
    if (!FillArgumentsFromArraylike(cx, iargs, args))
        return false;

    return Call(cx, fval, thisv, iargs, rval);
}

JS_PUBLIC_API(bool)
JS::Construct(JSContext* cx, HandleValue fval, HandleObject newTarget, const JS::HandleValueArray& args,
              MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, fval, newTarget, args);

    if (!IsConstructor(fval)) {
        ReportValueError(cx, JSMSG_NOT_CONSTRUCTOR, JSDVG_IGNORE_STACK, fval, nullptr);
        return false;
    }

    RootedValue newTargetVal(cx, ObjectValue(*newTarget));
    if (!IsConstructor(newTargetVal)) {
        ReportValueError(cx, JSMSG_NOT_CONSTRUCTOR, JSDVG_IGNORE_STACK, newTargetVal, nullptr);
        return false;
    }

    ConstructArgs cargs(cx);
    if (!FillArgumentsFromArraylike(cx, cargs, args))
        return false;

    return js::Construct(cx, fval, cargs, newTargetVal, objp);
}

JS_PUBLIC_API(bool)
JS::Construct(JSContext* cx, HandleValue fval, const JS::HandleValueArray& args,
              MutableHandleObject objp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, fval, args);

    if (!IsConstructor(fval)) {
        ReportValueError(cx, JSMSG_NOT_CONSTRUCTOR, JSDVG_IGNORE_STACK, fval, nullptr);
        return false;
    }

    ConstructArgs cargs(cx);
    if (!FillArgumentsFromArraylike(cx, cargs, args))
        return false;

    return js::Construct(cx, fval, cargs, fval, objp);
}


/* * */

JS_PUBLIC_API(bool)
JS_AlreadyHasOwnPropertyById(JSContext* cx, HandleObject obj, HandleId id, bool* foundp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj, id);

    if (!obj->isNative())
        return js::HasOwnProperty(cx, obj, id, foundp);

    RootedNativeObject nativeObj(cx, &obj->as<NativeObject>());
    RootedShape prop(cx);
    NativeLookupOwnPropertyNoResolve(cx, nativeObj, id, &prop);
    *foundp = !!prop;
    return true;
}

JS_PUBLIC_API(bool)
JS_AlreadyHasOwnProperty(JSContext* cx, HandleObject obj, const char* name, bool* foundp)
{
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_AlreadyHasOwnPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_AlreadyHasOwnUCProperty(JSContext* cx, HandleObject obj, const char16_t* name, size_t namelen,
                           bool* foundp)
{
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return false;
    RootedId id(cx, AtomToId(atom));
    return JS_AlreadyHasOwnPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_AlreadyHasOwnElement(JSContext* cx, HandleObject obj, uint32_t index, bool* foundp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return JS_AlreadyHasOwnPropertyById(cx, obj, id, foundp);
}

JS_PUBLIC_API(bool)
JS_FreezeObject(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    return FreezeObject(cx, obj);
}

static bool
DeepFreezeSlot(JSContext* cx, const Value& v)
{
    if (v.isPrimitive())
        return true;
    RootedObject obj(cx, &v.toObject());
    return JS_DeepFreezeObject(cx, obj);
}

JS_PUBLIC_API(bool)
JS_DeepFreezeObject(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    /* Assume that non-extensible objects are already deep-frozen, to avoid divergence. */
    bool extensible;
    if (!IsExtensible(cx, obj, &extensible))
        return false;
    if (!extensible)
        return true;

    if (!FreezeObject(cx, obj))
        return false;

    /* Walk slots in obj and if any value is a non-null object, seal it. */
    if (obj->isNative()) {
        RootedNativeObject nobj(cx, &obj->as<NativeObject>());
        for (uint32_t i = 0, n = nobj->slotSpan(); i < n; ++i) {
            if (!DeepFreezeSlot(cx, nobj->getSlot(i)))
                return false;
        }
        for (uint32_t i = 0, n = nobj->getDenseInitializedLength(); i < n; ++i) {
            if (!DeepFreezeSlot(cx, nobj->getDenseElement(i)))
                return false;
        }
    }

    return true;
}

static bool
DefineSelfHostedProperty(JSContext* cx, HandleObject obj, HandleId id,
                         const char* getterName, const char* setterName,
                         unsigned attrs, unsigned flags)
{
    JSAtom* getterNameAtom = Atomize(cx, getterName, strlen(getterName));
    if (!getterNameAtom)
        return false;
    RootedPropertyName getterNameName(cx, getterNameAtom->asPropertyName());

    RootedAtom name(cx, IdToFunctionName(cx, id));
    if (!name)
        return false;

    RootedValue getterValue(cx);
    if (!GlobalObject::getSelfHostedFunction(cx, cx->global(), getterNameName, name, 0,
                                             &getterValue))
    {
        return false;
    }
    MOZ_ASSERT(getterValue.isObject() && getterValue.toObject().is<JSFunction>());
    RootedFunction getterFunc(cx, &getterValue.toObject().as<JSFunction>());
    JSNative getterOp = JS_DATA_TO_FUNC_PTR(JSNative, getterFunc.get());

    RootedFunction setterFunc(cx);
    if (setterName) {
        JSAtom* setterNameAtom = Atomize(cx, setterName, strlen(setterName));
        if (!setterNameAtom)
            return false;
        RootedPropertyName setterNameName(cx, setterNameAtom->asPropertyName());

        RootedValue setterValue(cx);
        if (!GlobalObject::getSelfHostedFunction(cx, cx->global(), setterNameName, name, 0,
                                                 &setterValue))
        {
            return false;
        }
        MOZ_ASSERT(setterValue.isObject() && setterValue.toObject().is<JSFunction>());
        setterFunc = &setterValue.toObject().as<JSFunction>();
    }
    JSNative setterOp = JS_DATA_TO_FUNC_PTR(JSNative, setterFunc.get());

    return DefinePropertyById(cx, obj, id, JS::UndefinedHandleValue,
                              NativeOpWrapper(getterOp), NativeOpWrapper(setterOp),
                              attrs, flags);
}

JS_PUBLIC_API(JSObject*)
JS_DefineObject(JSContext* cx, HandleObject obj, const char* name, const JSClass* jsclasp,
                unsigned attrs)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    const Class* clasp = Valueify(jsclasp);
    if (!clasp)
        clasp = &PlainObject::class_;    /* default class is Object */

    RootedObject nobj(cx, NewObjectWithClassProto(cx, clasp, nullptr));
    if (!nobj)
        return nullptr;

    RootedValue nobjValue(cx, ObjectValue(*nobj));
    if (!DefineProperty(cx, obj, name, nobjValue, NativeOpWrapper(nullptr), NativeOpWrapper(nullptr),
                        attrs, 0)) {
        return nullptr;
    }

    return nobj;
}

static inline Value
ValueFromScalar(double x)
{
    return DoubleValue(x);
}
static inline Value
ValueFromScalar(int32_t x)
{
    return Int32Value(x);
}

template<typename T>
static bool
DefineConstScalar(JSContext* cx, HandleObject obj, const JSConstScalarSpec<T>* cds)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JSNativeWrapper noget = NativeOpWrapper(nullptr);
    JSNativeWrapper noset = NativeOpWrapper(nullptr);
    unsigned attrs = JSPROP_READONLY | JSPROP_PERMANENT;
    for (; cds->name; cds++) {
        RootedValue value(cx, ValueFromScalar(cds->val));
        if (!DefineProperty(cx, obj, cds->name, value, noget, noset, attrs, 0))
            return false;
    }
    return true;
}

JS_PUBLIC_API(bool)
JS_DefineConstDoubles(JSContext* cx, HandleObject obj, const JSConstDoubleSpec* cds)
{
    return DefineConstScalar(cx, obj, cds);
}
JS_PUBLIC_API(bool)
JS_DefineConstIntegers(JSContext* cx, HandleObject obj, const JSConstIntegerSpec* cis)
{
    return DefineConstScalar(cx, obj, cis);
}

bool
JSPropertySpec::getValue(JSContext* cx, MutableHandleValue vp) const
{
    MOZ_ASSERT(!isAccessor());

    if (value.type == JSVAL_TYPE_STRING) {
        RootedAtom atom(cx, Atomize(cx, value.string, strlen(value.string)));
        if (!atom)
            return false;
        vp.setString(atom);
    } else {
        MOZ_ASSERT(value.type == JSVAL_TYPE_INT32);
        vp.setInt32(value.int32);
    }

    return true;
}

static JS::SymbolCode
PropertySpecNameToSymbolCode(const char* name)
{
    MOZ_ASSERT(JS::PropertySpecNameIsSymbol(name));
    uintptr_t u = reinterpret_cast<uintptr_t>(name);
    return JS::SymbolCode(u - 1);
}

bool
PropertySpecNameToId(JSContext* cx, const char* name, MutableHandleId id,
                     js::PinningBehavior pin = js::DoNotPinAtom)
{
    if (JS::PropertySpecNameIsSymbol(name)) {
        JS::SymbolCode which = PropertySpecNameToSymbolCode(name);
        id.set(SYMBOL_TO_JSID(cx->wellKnownSymbols().get(which)));
    } else {
        JSAtom* atom = Atomize(cx, name, strlen(name), pin);
        if (!atom)
            return false;
        id.set(AtomToId(atom));
    }
    return true;
}

JS_PUBLIC_API(bool)
JS::PropertySpecNameToPermanentId(JSContext* cx, const char* name, jsid* idp)
{
    // We are calling fromMarkedLocation(idp) even though idp points to a
    // location that will never be marked. This is OK because the whole point
    // of this API is to populate *idp with a jsid that does not need to be
    // marked.
    return PropertySpecNameToId(cx, name, MutableHandleId::fromMarkedLocation(idp),
                                js::PinAtom);
}

JS_PUBLIC_API(bool)
JS_DefineProperties(JSContext* cx, HandleObject obj, const JSPropertySpec* ps)
{
    RootedId id(cx);

    for (; ps->name; ps++) {
        if (!PropertySpecNameToId(cx, ps->name, &id))
            return false;

        if (ps->isAccessor()) {
            if (ps->isSelfHosted()) {
                if (!DefineSelfHostedProperty(cx, obj, id,
                                              ps->accessors.getter.selfHosted.funname,
                                              ps->accessors.setter.selfHosted.funname,
                                              ps->flags, 0))
                {
                    return false;
                }
            } else {
                if (!DefinePropertyById(cx, obj, id, JS::UndefinedHandleValue,
                                        ps->accessors.getter.native, ps->accessors.setter.native,
                                        ps->flags, 0))
                {
                    return false;
                }
            }
        } else {
            RootedValue v(cx);
            if (!ps->getValue(cx, &v))
                return false;

            if (!DefinePropertyById(cx, obj, id, v, NativeOpWrapper(nullptr),
                                    NativeOpWrapper(nullptr), ps->flags & ~JSPROP_INTERNAL_USE_BIT, 0))
            {
                return false;
            }
        }
    }
    return true;
}

JS_PUBLIC_API(bool)
JS::ObjectToCompletePropertyDescriptor(JSContext* cx,
                                       HandleObject obj,
                                       HandleValue descObj,
                                       MutableHandle<PropertyDescriptor> desc)
{
    if (!ToPropertyDescriptor(cx, descObj, true, desc))
        return false;
    CompletePropertyDescriptor(desc);
    desc.object().set(obj);
    return true;
}

JS_PUBLIC_API(void)
JS_SetAllNonReservedSlotsToUndefined(JSContext* cx, JSObject* objArg)
{
    RootedObject obj(cx, objArg);
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    if (!obj->isNative())
        return;

    const Class* clasp = obj->getClass();
    unsigned numReserved = JSCLASS_RESERVED_SLOTS(clasp);
    unsigned numSlots = obj->as<NativeObject>().slotSpan();
    for (unsigned i = numReserved; i < numSlots; i++)
        obj->as<NativeObject>().setSlot(i, UndefinedValue());
}

JS_PUBLIC_API(Value)
JS_GetReservedSlot(JSObject* obj, uint32_t index)
{
    return obj->as<NativeObject>().getReservedSlot(index);
}

JS_PUBLIC_API(void)
JS_SetReservedSlot(JSObject* obj, uint32_t index, const Value& value)
{
    obj->as<NativeObject>().setReservedSlot(index, value);
}

JS_PUBLIC_API(JSObject*)
JS_NewArrayObject(JSContext* cx, const JS::HandleValueArray& contents)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    assertSameCompartment(cx, contents);
    return NewDenseCopiedArray(cx, contents.length(), contents.begin());
}

JS_PUBLIC_API(JSObject*)
JS_NewArrayObject(JSContext* cx, size_t length)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return NewDenseFullyAllocatedArray(cx, length);
}

inline bool
IsGivenTypeObject(JSContext* cx, JS::HandleObject obj, const ESClass& typeClass, bool* isType)
{
    assertSameCompartment(cx, obj);

    ESClass cls;
    if (!GetBuiltinClass(cx, obj, &cls))
        return false;

    *isType = cls == typeClass;
    return true;
}

JS_PUBLIC_API(bool)
JS_IsArrayObject(JSContext* cx, JS::HandleObject obj, bool* isArray)
{
    return IsGivenTypeObject(cx, obj, ESClass::Array, isArray);
}

JS_PUBLIC_API(bool)
JS_IsArrayObject(JSContext* cx, JS::HandleValue value, bool* isArray)
{
    if (!value.isObject()) {
        *isArray = false;
        return true;
    }

    RootedObject obj(cx, &value.toObject());
    return JS_IsArrayObject(cx, obj, isArray);
}

JS_PUBLIC_API(bool)
JS_GetArrayLength(JSContext* cx, HandleObject obj, uint32_t* lengthp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    return GetLengthProperty(cx, obj, lengthp);
}

JS_PUBLIC_API(bool)
JS_SetArrayLength(JSContext* cx, HandleObject obj, uint32_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    return SetLengthProperty(cx, obj, length);
}

JS_PUBLIC_API(bool)
JS::IsMapObject(JSContext* cx, JS::HandleObject obj, bool* isMap)
{
    return IsGivenTypeObject(cx, obj, ESClass::Map, isMap);
}

JS_PUBLIC_API(bool)
JS::IsSetObject(JSContext* cx, JS::HandleObject obj, bool* isSet)
{
    return IsGivenTypeObject(cx, obj, ESClass::Set, isSet);
}

JS_PUBLIC_API(void)
JS_HoldPrincipals(JSPrincipals* principals)
{
    ++principals->refcount;
}

JS_PUBLIC_API(void)
JS_DropPrincipals(JSContext* cx, JSPrincipals* principals)
{
    int rc = --principals->refcount;
    if (rc == 0)
        cx->destroyPrincipals(principals);
}

JS_PUBLIC_API(void)
JS_SetSecurityCallbacks(JSContext* cx, const JSSecurityCallbacks* scb)
{
    MOZ_ASSERT(scb != &NullSecurityCallbacks);
    cx->securityCallbacks = scb ? scb : &NullSecurityCallbacks;
}

JS_PUBLIC_API(const JSSecurityCallbacks*)
JS_GetSecurityCallbacks(JSContext* cx)
{
    return (cx->securityCallbacks != &NullSecurityCallbacks) ? cx->securityCallbacks : nullptr;
}

JS_PUBLIC_API(void)
JS_SetTrustedPrincipals(JSContext* cx, JSPrincipals* prin)
{
    cx->setTrustedPrincipals(prin);
}

extern JS_PUBLIC_API(void)
JS_InitDestroyPrincipalsCallback(JSContext* cx, JSDestroyPrincipalsOp destroyPrincipals)
{
    MOZ_ASSERT(destroyPrincipals);
    MOZ_ASSERT(!cx->destroyPrincipals);
    cx->destroyPrincipals = destroyPrincipals;
}

extern JS_PUBLIC_API(void)
JS_InitReadPrincipalsCallback(JSContext* cx, JSReadPrincipalsOp read)
{
    MOZ_ASSERT(read);
    MOZ_ASSERT(!cx->readPrincipals);
    cx->readPrincipals = read;
}

JS_PUBLIC_API(JSFunction*)
JS_NewFunction(JSContext* cx, JSNative native, unsigned nargs, unsigned flags,
               const char* name)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RootedAtom atom(cx);
    if (name) {
        atom = Atomize(cx, name, strlen(name));
        if (!atom)
            return nullptr;
    }

    return (flags & JSFUN_CONSTRUCTOR)
           ? NewNativeConstructor(cx, native, nargs, atom)
           : NewNativeFunction(cx, native, nargs, atom);
}

JS_PUBLIC_API(JSFunction*)
JS::GetSelfHostedFunction(JSContext* cx, const char* selfHostedName, HandleId id, unsigned nargs)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RootedAtom name(cx, IdToFunctionName(cx, id));
    if (!name)
        return nullptr;

    JSAtom* shAtom = Atomize(cx, selfHostedName, strlen(selfHostedName));
    if (!shAtom)
        return nullptr;
    RootedPropertyName shName(cx, shAtom->asPropertyName());
    RootedValue funVal(cx);
    if (!GlobalObject::getSelfHostedFunction(cx, cx->global(), shName, name, nargs, &funVal))
        return nullptr;
    return &funVal.toObject().as<JSFunction>();
}

JS_PUBLIC_API(JSFunction*)
JS::NewFunctionFromSpec(JSContext* cx, const JSFunctionSpec* fs, HandleId id)
{
    // Delay cloning self-hosted functions until they are called. This is
    // achieved by passing DefineFunction a nullptr JSNative which produces an
    // interpreted JSFunction where !hasScript. Interpreted call paths then
    // call InitializeLazyFunctionScript if !hasScript.
    if (fs->selfHostedName) {
        MOZ_ASSERT(!fs->call.op);
        MOZ_ASSERT(!fs->call.info);

        JSAtom* shAtom = Atomize(cx, fs->selfHostedName, strlen(fs->selfHostedName));
        if (!shAtom)
            return nullptr;
        RootedPropertyName shName(cx, shAtom->asPropertyName());
        RootedAtom name(cx, IdToFunctionName(cx, id));
        if (!name)
            return nullptr;
        RootedValue funVal(cx);
        if (!GlobalObject::getSelfHostedFunction(cx, cx->global(), shName, name, fs->nargs,
                                                 &funVal))
        {
            return nullptr;
        }
        JSFunction* fun = &funVal.toObject().as<JSFunction>();
        if (fs->flags & JSFUN_HAS_REST)
            fun->setHasRest();
        return fun;
    }

    RootedAtom atom(cx, IdToFunctionName(cx, id));
    if (!atom)
        return nullptr;

    JSFunction* fun;
    if (!fs->call.op)
        fun = NewScriptedFunction(cx, fs->nargs, JSFunction::INTERPRETED_LAZY, atom);
    else if (fs->flags & JSFUN_CONSTRUCTOR)
        fun = NewNativeConstructor(cx, fs->call.op, fs->nargs, atom);
    else
        fun = NewNativeFunction(cx, fs->call.op, fs->nargs, atom);
    if (!fun)
        return nullptr;

    if (fs->call.info)
        fun->setJitInfo(fs->call.info);
    return fun;
}

static bool
CreateNonSyntacticEnvironmentChain(JSContext* cx, AutoObjectVector& envChain,
                                   MutableHandleObject env, MutableHandleScope scope)
{
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    if (!js::CreateObjectsForEnvironmentChain(cx, envChain, globalLexical, env))
        return false;

    if (!envChain.empty()) {
        scope.set(GlobalScope::createEmpty(cx, ScopeKind::NonSyntactic));
        if (!scope)
            return false;

        // The XPConnect subscript loader, which may pass in its own
        // environments to load scripts in, expects the environment chain to
        // be the holder of "var" declarations. In SpiderMonkey, such objects
        // are called "qualified varobjs", the "qualified" part meaning the
        // declaration was qualified by "var". There is only sadness.
        //
        // See JSObject::isQualifiedVarObj.
        if (!env->setQualifiedVarObj(cx))
            return false;

        // Also get a non-syntactic lexical environment to capture 'let' and
        // 'const' bindings. To persist lexical bindings, we have a 1-1
        // mapping with the final unwrapped environment object (the
        // environment that stores the 'var' bindings) and the lexical
        // environment.
        //
        // TODOshu: disallow the subscript loader from using non-distinguished
        // objects as dynamic scopes.
        env.set(cx->compartment()->getOrCreateNonSyntacticLexicalEnvironment(cx, env));
        if (!env)
            return false;
    } else {
        scope.set(&cx->global()->emptyGlobalScope());
    }

    return true;
}

static bool
IsFunctionCloneable(HandleFunction fun)
{
    if (!fun->isInterpreted())
        return true;

    // If a function was compiled with non-global syntactic environments on
    // the environment chain, we could have baked in EnvironmentCoordinates
    // into the script. We cannot clone it without breaking the compiler's
    // assumptions.
    for (ScopeIter si(fun->nonLazyScript()->enclosingScope()); si; si++) {
        if (si.scope()->is<GlobalScope>())
            return true;
        if (si.hasSyntacticEnvironment())
            return false;
    }

    return true;
}

static JSObject*
CloneFunctionObject(JSContext* cx, HandleObject funobj, HandleObject env, HandleScope scope)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, env);
    MOZ_ASSERT(env);
    // Note that funobj can be in a different compartment.

    if (!funobj->is<JSFunction>()) {
        AutoCompartment ac(cx, funobj);
        RootedValue v(cx, ObjectValue(*funobj));
        ReportIsNotFunction(cx, v);
        return nullptr;
    }

    RootedFunction fun(cx, &funobj->as<JSFunction>());
    if (fun->isInterpretedLazy()) {
        AutoCompartment ac(cx, funobj);
        if (!fun->getOrCreateScript(cx))
            return nullptr;
    }

    if (!IsFunctionCloneable(fun)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_CLONE_FUNOBJ_SCOPE);
        return nullptr;
    }

    if (fun->isBoundFunction()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CLONE_OBJECT);
        return nullptr;
    }

    if (IsAsmJSModule(fun)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CLONE_OBJECT);
        return nullptr;
    }

    if (IsWrappedAsyncFunction(fun)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CLONE_OBJECT);
        return nullptr;
    }

    if (CanReuseScriptForClone(cx->compartment(), fun, env)) {
        // If the script is to be reused, either the script can already handle
        // non-syntactic scopes, or there is only the standard global lexical
        // scope.
#ifdef DEBUG
        // Fail here if we OOM during debug asserting.
        // CloneFunctionReuseScript will delazify the script anyways, so we
        // are not creating an extra failure condition for DEBUG builds.
        if (!fun->getOrCreateScript(cx))
            return nullptr;
        MOZ_ASSERT(scope->as<GlobalScope>().isSyntactic() ||
                   fun->nonLazyScript()->hasNonSyntacticScope());
#endif
        return CloneFunctionReuseScript(cx, fun, env, fun->getAllocKind());
    }

    JSFunction* clone = CloneFunctionAndScript(cx, fun, env, scope, fun->getAllocKind());

#ifdef DEBUG
    // The cloned function should itself be cloneable.
    RootedFunction cloneRoot(cx, clone);
    MOZ_ASSERT_IF(cloneRoot, IsFunctionCloneable(cloneRoot));
#endif

    return clone;
}

JS_PUBLIC_API(JSObject*)
JS::CloneFunctionObject(JSContext* cx, HandleObject funobj)
{
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    RootedScope emptyGlobalScope(cx, &cx->global()->emptyGlobalScope());
    return CloneFunctionObject(cx, funobj, globalLexical, emptyGlobalScope);
}

extern JS_PUBLIC_API(JSObject*)
JS::CloneFunctionObject(JSContext* cx, HandleObject funobj, AutoObjectVector& envChain)
{
    RootedObject env(cx);
    RootedScope scope(cx);
    if (!CreateNonSyntacticEnvironmentChain(cx, envChain, &env, &scope))
        return nullptr;
    return CloneFunctionObject(cx, funobj, env, scope);
}

JS_PUBLIC_API(JSObject*)
JS_GetFunctionObject(JSFunction* fun)
{
    return fun;
}

JS_PUBLIC_API(JSString*)
JS_GetFunctionId(JSFunction* fun)
{
    return fun->name();
}

JS_PUBLIC_API(JSString*)
JS_GetFunctionDisplayId(JSFunction* fun)
{
    return fun->displayAtom();
}

JS_PUBLIC_API(uint16_t)
JS_GetFunctionArity(JSFunction* fun)
{
    return fun->nargs();
}

JS_PUBLIC_API(bool)
JS_ObjectIsFunction(JSContext* cx, JSObject* obj)
{
    return obj->is<JSFunction>();
}

JS_PUBLIC_API(bool)
JS_IsNativeFunction(JSObject* funobj, JSNative call)
{
    if (!funobj->is<JSFunction>())
        return false;
    JSFunction* fun = &funobj->as<JSFunction>();
    return fun->isNative() && fun->native() == call;
}

extern JS_PUBLIC_API(bool)
JS_IsConstructor(JSFunction* fun)
{
    return fun->isConstructor();
}

JS_PUBLIC_API(bool)
JS_DefineFunctions(JSContext* cx, HandleObject obj, const JSFunctionSpec* fs)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    return DefineFunctions(cx, obj, fs, NotIntrinsic);
}

JS_PUBLIC_API(JSFunction*)
JS_DefineFunction(JSContext* cx, HandleObject obj, const char* name, JSNative call,
                  unsigned nargs, unsigned attrs)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    JSAtom* atom = Atomize(cx, name, strlen(name));
    if (!atom)
        return nullptr;
    Rooted<jsid> id(cx, AtomToId(atom));
    return DefineFunction(cx, obj, id, call, nargs, attrs);
}

JS_PUBLIC_API(JSFunction*)
JS_DefineUCFunction(JSContext* cx, HandleObject obj,
                    const char16_t* name, size_t namelen, JSNative call,
                    unsigned nargs, unsigned attrs)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    JSAtom* atom = AtomizeChars(cx, name, AUTO_NAMELEN(name, namelen));
    if (!atom)
        return nullptr;
    Rooted<jsid> id(cx, AtomToId(atom));
    return DefineFunction(cx, obj, id, call, nargs, attrs);
}

extern JS_PUBLIC_API(JSFunction*)
JS_DefineFunctionById(JSContext* cx, HandleObject obj, HandleId id, JSNative call,
                      unsigned nargs, unsigned attrs)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    return DefineFunction(cx, obj, id, call, nargs, attrs);
}

/* Use the fastest available getc. */
#if defined(HAVE_GETC_UNLOCKED)
# define fast_getc getc_unlocked
#elif defined(HAVE__GETC_NOLOCK)
# define fast_getc _getc_nolock
#else
# define fast_getc getc
#endif

typedef Vector<char, 8, TempAllocPolicy> FileContents;

static bool
ReadCompleteFile(JSContext* cx, FILE* fp, FileContents& buffer)
{
    /* Get the complete length of the file, if possible. */
    struct stat st;
    int ok = fstat(fileno(fp), &st);
    if (ok != 0)
        return false;
    if (st.st_size > 0) {
        if (!buffer.reserve(st.st_size))
            return false;
    }

    // Read in the whole file. Note that we can't assume the data's length
    // is actually st.st_size, because 1) some files lie about their size
    // (/dev/zero and /dev/random), and 2) reading files in text mode on
    // Windows collapses "\r\n" pairs to single \n characters.
    for (;;) {
        int c = fast_getc(fp);
        if (c == EOF)
            break;
        if (!buffer.append(c))
            return false;
    }

    return true;
}

namespace {

class AutoFile
{
    FILE* fp_;
  public:
    AutoFile()
      : fp_(nullptr)
    {}
    ~AutoFile()
    {
        if (fp_ && fp_ != stdin)
            fclose(fp_);
    }
    FILE* fp() const { return fp_; }
    bool open(JSContext* cx, const char* filename);
    bool readAll(JSContext* cx, FileContents& buffer)
    {
        MOZ_ASSERT(fp_);
        return ReadCompleteFile(cx, fp_, buffer);
    }
};

} /* anonymous namespace */

/*
 * Open a source file for reading. Supports "-" and nullptr to mean stdin. The
 * return value must be fclosed unless it is stdin.
 */
bool
AutoFile::open(JSContext* cx, const char* filename)
{
    if (!filename || strcmp(filename, "-") == 0) {
        fp_ = stdin;
    } else {
        fp_ = fopen(filename, "r");
        if (!fp_) {
            /*
             * Use Latin1 variant here because the encoding of filename is
             * platform dependent.
             */
            JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_CANT_OPEN,
                                       filename, "No such file or directory");
            return false;
        }
    }
    return true;
}

void
JS::TransitiveCompileOptions::copyPODTransitiveOptions(const TransitiveCompileOptions& rhs)
{
    mutedErrors_ = rhs.mutedErrors_;
    version = rhs.version;
    versionSet = rhs.versionSet;
    utf8 = rhs.utf8;
    selfHostingMode = rhs.selfHostingMode;
    canLazilyParse = rhs.canLazilyParse;
    strictOption = rhs.strictOption;
    extraWarningsOption = rhs.extraWarningsOption;
    werrorOption = rhs.werrorOption;
    asmJSOption = rhs.asmJSOption;
    throwOnAsmJSValidationFailureOption = rhs.throwOnAsmJSValidationFailureOption;
    forceAsync = rhs.forceAsync;
    installedFile = rhs.installedFile;
    sourceIsLazy = rhs.sourceIsLazy;
    introductionType = rhs.introductionType;
    introductionLineno = rhs.introductionLineno;
    introductionOffset = rhs.introductionOffset;
    hasIntroductionInfo = rhs.hasIntroductionInfo;
};

void
JS::ReadOnlyCompileOptions::copyPODOptions(const ReadOnlyCompileOptions& rhs)
{
    copyPODTransitiveOptions(rhs);
    lineno = rhs.lineno;
    column = rhs.column;
    isRunOnce = rhs.isRunOnce;
    noScriptRval = rhs.noScriptRval;
}

JS::OwningCompileOptions::OwningCompileOptions(JSContext* cx)
    : ReadOnlyCompileOptions(),
      elementRoot(cx),
      elementAttributeNameRoot(cx),
      introductionScriptRoot(cx)
{
}

JS::OwningCompileOptions::~OwningCompileOptions()
{
    // OwningCompileOptions always owns these, so these casts are okay.
    js_free(const_cast<char*>(filename_));
    js_free(const_cast<char16_t*>(sourceMapURL_));
    js_free(const_cast<char*>(introducerFilename_));
}

bool
JS::OwningCompileOptions::copy(JSContext* cx, const ReadOnlyCompileOptions& rhs)
{
    copyPODOptions(rhs);

    setElement(rhs.element());
    setElementAttributeName(rhs.elementAttributeName());
    setIntroductionScript(rhs.introductionScript());

    return setFileAndLine(cx, rhs.filename(), rhs.lineno) &&
           setSourceMapURL(cx, rhs.sourceMapURL()) &&
           setIntroducerFilename(cx, rhs.introducerFilename());
}

bool
JS::OwningCompileOptions::setFile(JSContext* cx, const char* f)
{
    char* copy = nullptr;
    if (f) {
        copy = JS_strdup(cx, f);
        if (!copy)
            return false;
    }

    // OwningCompileOptions always owns filename_, so this cast is okay.
    js_free(const_cast<char*>(filename_));

    filename_ = copy;
    return true;
}

bool
JS::OwningCompileOptions::setFileAndLine(JSContext* cx, const char* f, unsigned l)
{
    if (!setFile(cx, f))
        return false;

    lineno = l;
    return true;
}

bool
JS::OwningCompileOptions::setSourceMapURL(JSContext* cx, const char16_t* s)
{
    UniqueTwoByteChars copy;
    if (s) {
        copy = DuplicateString(cx, s);
        if (!copy)
            return false;
    }

    // OwningCompileOptions always owns sourceMapURL_, so this cast is okay.
    js_free(const_cast<char16_t*>(sourceMapURL_));

    sourceMapURL_ = copy.release();
    return true;
}

bool
JS::OwningCompileOptions::setIntroducerFilename(JSContext* cx, const char* s)
{
    char* copy = nullptr;
    if (s) {
        copy = JS_strdup(cx, s);
        if (!copy)
            return false;
    }

    // OwningCompileOptions always owns introducerFilename_, so this cast is okay.
    js_free(const_cast<char*>(introducerFilename_));

    introducerFilename_ = copy;
    return true;
}

JS::CompileOptions::CompileOptions(JSContext* cx, JSVersion version)
    : ReadOnlyCompileOptions(), elementRoot(cx), elementAttributeNameRoot(cx),
      introductionScriptRoot(cx)
{
    this->version = (version != JSVERSION_UNKNOWN) ? version : cx->findVersion();

    strictOption = cx->options().strictMode();
    extraWarningsOption = cx->compartment()->behaviors().extraWarnings(cx);
    werrorOption = cx->options().werror();
    if (!cx->options().asmJS())
        asmJSOption = AsmJSOption::Disabled;
    else if (cx->compartment()->debuggerObservesAsmJS())
        asmJSOption = AsmJSOption::DisabledByDebugger;
    else
        asmJSOption = AsmJSOption::Enabled;
    throwOnAsmJSValidationFailureOption = cx->options().throwOnAsmJSValidationFailure();
}

static bool
Compile(JSContext* cx, const ReadOnlyCompileOptions& options, ScopeKind scopeKind,
        SourceBufferHolder& srcBuf, MutableHandleScript script)
{
    MOZ_ASSERT(scopeKind == ScopeKind::Global || scopeKind == ScopeKind::NonSyntactic);
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    script.set(frontend::CompileGlobalScript(cx, cx->tempLifoAlloc(), scopeKind, options, srcBuf));
    return !!script;
}

static bool
Compile(JSContext* cx, const ReadOnlyCompileOptions& options, ScopeKind scopeKind,
        const char16_t* chars, size_t length, MutableHandleScript script)
{
    SourceBufferHolder srcBuf(chars, length, SourceBufferHolder::NoOwnership);
    return ::Compile(cx, options, scopeKind, srcBuf, script);
}

static bool
Compile(JSContext* cx, const ReadOnlyCompileOptions& options, ScopeKind scopeKind,
        const char* bytes, size_t length, MutableHandleScript script)
{
    UniqueTwoByteChars chars;
    if (options.utf8)
        chars.reset(UTF8CharsToNewTwoByteCharsZ(cx, UTF8Chars(bytes, length), &length).get());
    else
        chars.reset(InflateString(cx, bytes, &length));
    if (!chars)
        return false;

    return ::Compile(cx, options, scopeKind, chars.get(), length, script);
}

static bool
Compile(JSContext* cx, const ReadOnlyCompileOptions& options, ScopeKind scopeKind,
        FILE* fp, MutableHandleScript script)
{
    FileContents buffer(cx);
    if (!ReadCompleteFile(cx, fp, buffer))
        return false;

    return ::Compile(cx, options, scopeKind, buffer.begin(), buffer.length(), script);
}

static bool
Compile(JSContext* cx, const ReadOnlyCompileOptions& optionsArg, ScopeKind scopeKind,
        const char* filename, MutableHandleScript script)
{
    AutoFile file;
    if (!file.open(cx, filename))
        return false;
    CompileOptions options(cx, optionsArg);
    options.setFileAndLine(filename, 1);
    return ::Compile(cx, options, scopeKind, file.fp(), script);
}

bool
JS::Compile(JSContext* cx, const ReadOnlyCompileOptions& options,
            SourceBufferHolder& srcBuf, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::Global, srcBuf, script);
}

bool
JS::Compile(JSContext* cx, const ReadOnlyCompileOptions& options,
            const char* bytes, size_t length, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::Global, bytes, length, script);
}

bool
JS::Compile(JSContext* cx, const ReadOnlyCompileOptions& options,
            const char16_t* chars, size_t length, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::Global, chars, length, script);
}

bool
JS::Compile(JSContext* cx, const ReadOnlyCompileOptions& options,
            FILE* file, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::Global, file, script);
}

bool
JS::Compile(JSContext* cx, const ReadOnlyCompileOptions& options,
            const char* filename, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::Global, filename, script);
}

bool
JS::CompileForNonSyntacticScope(JSContext* cx, const ReadOnlyCompileOptions& options,
                                SourceBufferHolder& srcBuf, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::NonSyntactic, srcBuf, script);
}

bool
JS::CompileForNonSyntacticScope(JSContext* cx, const ReadOnlyCompileOptions& options,
                                const char* bytes, size_t length, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::NonSyntactic, bytes, length, script);
}

bool
JS::CompileForNonSyntacticScope(JSContext* cx, const ReadOnlyCompileOptions& options,
                                const char16_t* chars, size_t length,
                                JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::NonSyntactic, chars, length, script);
}

bool
JS::CompileForNonSyntacticScope(JSContext* cx, const ReadOnlyCompileOptions& options,
                                FILE* file, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::NonSyntactic, file, script);
}

bool
JS::CompileForNonSyntacticScope(JSContext* cx, const ReadOnlyCompileOptions& options,
                                const char* filename, JS::MutableHandleScript script)
{
    return ::Compile(cx, options, ScopeKind::NonSyntactic, filename, script);
}

JS_PUBLIC_API(bool)
JS::CanCompileOffThread(JSContext* cx, const ReadOnlyCompileOptions& options, size_t length)
{
    static const size_t TINY_LENGTH = 5 * 1000;
    static const size_t HUGE_LENGTH = 100 * 1000;

    // These are heuristics which the caller may choose to ignore (e.g., for
    // testing purposes).
    if (!options.forceAsync) {
        // Compiling off the main thread inolves creating a new Zone and other
        // significant overheads.  Don't bother if the script is tiny.
        if (length < TINY_LENGTH)
            return false;

        // If the parsing task would have to wait for GC to complete, it'll probably
        // be faster to just start it synchronously on the main thread unless the
        // script is huge.
        if (OffThreadParsingMustWaitForGC(cx->runtime()) && length < HUGE_LENGTH)
            return false;
    }

    return cx->runtime()->canUseParallelParsing() && CanUseExtraThreads();
}

JS_PUBLIC_API(bool)
JS::CompileOffThread(JSContext* cx, const ReadOnlyCompileOptions& options,
                     const char16_t* chars, size_t length,
                     OffThreadCompileCallback callback, void* callbackData)
{
    MOZ_ASSERT(CanCompileOffThread(cx, options, length));
    return StartOffThreadParseScript(cx, options, chars, length, callback, callbackData);
}

JS_PUBLIC_API(JSScript*)
JS::FinishOffThreadScript(JSContext* cx, void* token)
{
    MOZ_ASSERT(cx);
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(cx));
    return HelperThreadState().finishScriptParseTask(cx, token);
}

JS_PUBLIC_API(void)
JS::CancelOffThreadScript(JSContext* cx, void* token)
{
    MOZ_ASSERT(cx);
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(cx));
    HelperThreadState().cancelParseTask(cx, ParseTaskKind::Script, token);
}

JS_PUBLIC_API(bool)
JS::CompileOffThreadModule(JSContext* cx, const ReadOnlyCompileOptions& options,
                           const char16_t* chars, size_t length,
                           OffThreadCompileCallback callback, void* callbackData)
{
    MOZ_ASSERT(CanCompileOffThread(cx, options, length));
    return StartOffThreadParseModule(cx, options, chars, length, callback, callbackData);
}

JS_PUBLIC_API(JSObject*)
JS::FinishOffThreadModule(JSContext* cx, void* token)
{
    MOZ_ASSERT(cx);
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(cx));
    return HelperThreadState().finishModuleParseTask(cx, token);
}

JS_PUBLIC_API(void)
JS::CancelOffThreadModule(JSContext* cx, void* token)
{
    MOZ_ASSERT(cx);
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(cx));
    HelperThreadState().cancelParseTask(cx, ParseTaskKind::Module, token);
}

JS_PUBLIC_API(bool)
JS_CompileScript(JSContext* cx, const char* ascii, size_t length,
                 const JS::CompileOptions& options, MutableHandleScript script)
{
    return Compile(cx, options, ascii, length, script);
}

JS_PUBLIC_API(bool)
JS_CompileUCScript(JSContext* cx, const char16_t* chars, size_t length,
                   const JS::CompileOptions& options, MutableHandleScript script)
{
    return Compile(cx, options, chars, length, script);
}

JS_PUBLIC_API(bool)
JS_BufferIsCompilableUnit(JSContext* cx, HandleObject obj, const char* utf8, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    cx->clearPendingException();

    char16_t* chars = JS::UTF8CharsToNewTwoByteCharsZ(cx, JS::UTF8Chars(utf8, length), &length).get();
    if (!chars)
        return true;

    // Return true on any out-of-memory error or non-EOF-related syntax error, so our
    // caller doesn't try to collect more buffered source.
    bool result = true;

    CompileOptions options(cx);
    frontend::UsedNameTracker usedNames(cx);
    if (!usedNames.init())
        return false;
    frontend::Parser<frontend::FullParseHandler> parser(cx, cx->tempLifoAlloc(),
                                                        options, chars, length,
                                                        /* foldConstants = */ true,
                                                        usedNames, nullptr, nullptr);
    JS::WarningReporter older = JS::SetWarningReporter(cx, nullptr);
    if (!parser.checkOptions() || !parser.parse()) {
        // We ran into an error. If it was because we ran out of source, we
        // return false so our caller knows to try to collect more buffered
        // source.
        if (parser.isUnexpectedEOF())
            result = false;

        cx->clearPendingException();
    }
    JS::SetWarningReporter(cx, older);

    js_free(chars);
    return result;
}

JS_PUBLIC_API(JSObject*)
JS_GetGlobalFromScript(JSScript* script)
{
    MOZ_ASSERT(!script->isCachedEval());
    return &script->global();
}

JS_PUBLIC_API(const char*)
JS_GetScriptFilename(JSScript* script)
{
    // This is called from ThreadStackHelper which can be called from another
    // thread or inside a signal hander, so we need to be careful in case a
    // copmacting GC is currently moving things around.
    return script->maybeForwardedFilename();
}

JS_PUBLIC_API(unsigned)
JS_GetScriptBaseLineNumber(JSContext* cx, JSScript* script)
{
    return script->lineno();
}

JS_PUBLIC_API(JSScript*)
JS_GetFunctionScript(JSContext* cx, HandleFunction fun)
{
    if (fun->isNative())
        return nullptr;
    if (fun->isInterpretedLazy()) {
        AutoCompartment funCompartment(cx, fun);
        JSScript* script = fun->getOrCreateScript(cx);
        if (!script)
            MOZ_CRASH();
        return script;
    }
    return fun->nonLazyScript();
}

/*
 * enclosingScope is a static enclosing scope, if any (e.g. a WithScope).  If
 * the enclosing scope is the global scope, this must be null.
 *
 * enclosingDynamicScope is a dynamic scope to use, if it's not the global.
 */
static bool
CompileFunction(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
                const char* name, unsigned nargs, const char* const* argnames,
                SourceBufferHolder& srcBuf,
                HandleObject enclosingEnv, HandleScope enclosingScope,
                MutableHandleFunction fun)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, enclosingEnv);
    RootedAtom funAtom(cx);

    if (name) {
        funAtom = Atomize(cx, name, strlen(name));
        if (!funAtom)
            return false;
    }

    Rooted<PropertyNameVector> formals(cx, PropertyNameVector(cx));
    for (unsigned i = 0; i < nargs; i++) {
        RootedAtom argAtom(cx, Atomize(cx, argnames[i], strlen(argnames[i])));
        if (!argAtom || !formals.append(argAtom->asPropertyName()))
            return false;
    }

    fun.set(NewScriptedFunction(cx, 0, JSFunction::INTERPRETED_NORMAL, funAtom,
                                /* proto = */ nullptr,
                                gc::AllocKind::FUNCTION, TenuredObject,
                                enclosingEnv));
    if (!fun)
        return false;

    // Make sure the static scope chain matches up when we have a
    // non-syntactic scope.
    MOZ_ASSERT_IF(!IsGlobalLexicalEnvironment(enclosingEnv),
                  enclosingScope->hasOnChain(ScopeKind::NonSyntactic));

    if (!frontend::CompileFunctionBody(cx, fun, optionsArg, formals, srcBuf, enclosingScope))
        return false;

    return true;
}

JS_PUBLIC_API(bool)
JS::CompileFunction(JSContext* cx, AutoObjectVector& envChain,
                    const ReadOnlyCompileOptions& options,
                    const char* name, unsigned nargs, const char* const* argnames,
                    SourceBufferHolder& srcBuf, MutableHandleFunction fun)
{
    RootedObject env(cx);
    RootedScope scope(cx);
    if (!CreateNonSyntacticEnvironmentChain(cx, envChain, &env, &scope))
        return false;
    return CompileFunction(cx, options, name, nargs, argnames, srcBuf, env, scope, fun);
}

JS_PUBLIC_API(bool)
JS::CompileFunction(JSContext* cx, AutoObjectVector& envChain,
                    const ReadOnlyCompileOptions& options,
                    const char* name, unsigned nargs, const char* const* argnames,
                    const char16_t* chars, size_t length, MutableHandleFunction fun)
{
    SourceBufferHolder srcBuf(chars, length, SourceBufferHolder::NoOwnership);
    return CompileFunction(cx, envChain, options, name, nargs, argnames,
                           srcBuf, fun);
}

JS_PUBLIC_API(bool)
JS::CompileFunction(JSContext* cx, AutoObjectVector& envChain,
                    const ReadOnlyCompileOptions& options,
                    const char* name, unsigned nargs, const char* const* argnames,
                    const char* bytes, size_t length, MutableHandleFunction fun)
{
    UniqueTwoByteChars chars;
    if (options.utf8)
        chars.reset(UTF8CharsToNewTwoByteCharsZ(cx, UTF8Chars(bytes, length), &length).get());
    else
        chars.reset(InflateString(cx, bytes, &length));
    if (!chars)
        return false;

    return CompileFunction(cx, envChain, options, name, nargs, argnames,
                           chars.get(), length, fun);
}

JS_PUBLIC_API(JSString*)
JS_DecompileScript(JSContext* cx, HandleScript script, const char* name, unsigned indent)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    script->ensureNonLazyCanonicalFunction(cx);
    RootedFunction fun(cx, script->functionNonDelazifying());
    if (fun)
        return JS_DecompileFunction(cx, fun, indent);
    bool haveSource = script->scriptSource()->hasSourceData();
    if (!haveSource && !JSScript::loadSource(cx, script->scriptSource(), &haveSource))
        return nullptr;
    return haveSource ? script->sourceData(cx) : NewStringCopyZ<CanGC>(cx, "[no source]");
}

JS_PUBLIC_API(JSString*)
JS_DecompileFunction(JSContext* cx, HandleFunction fun, unsigned indent)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, fun);
    return FunctionToString(cx, fun, !(indent & JS_DONT_PRETTY_PRINT));
}

MOZ_NEVER_INLINE static bool
ExecuteScript(JSContext* cx, HandleObject scope, HandleScript script, Value* rval)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, scope, script);
    MOZ_ASSERT_IF(!IsGlobalLexicalEnvironment(scope), script->hasNonSyntacticScope());
    return Execute(cx, script, *scope, rval);
}

static bool
ExecuteScript(JSContext* cx, AutoObjectVector& envChain, HandleScript scriptArg, Value* rval)
{
    RootedObject env(cx);
    RootedScope dummy(cx);
    if (!CreateNonSyntacticEnvironmentChain(cx, envChain, &env, &dummy))
        return false;

    RootedScript script(cx, scriptArg);
    if (!script->hasNonSyntacticScope() && !IsGlobalLexicalEnvironment(env)) {
        script = CloneGlobalScript(cx, ScopeKind::NonSyntactic, script);
        if (!script)
            return false;
        js::Debugger::onNewScript(cx, script);
    }

    return ExecuteScript(cx, env, script, rval);
}

MOZ_NEVER_INLINE JS_PUBLIC_API(bool)
JS_ExecuteScript(JSContext* cx, HandleScript scriptArg, MutableHandleValue rval)
{
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    return ExecuteScript(cx, globalLexical, scriptArg, rval.address());
}

MOZ_NEVER_INLINE JS_PUBLIC_API(bool)
JS_ExecuteScript(JSContext* cx, HandleScript scriptArg)
{
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    return ExecuteScript(cx, globalLexical, scriptArg, nullptr);
}

MOZ_NEVER_INLINE JS_PUBLIC_API(bool)
JS_ExecuteScript(JSContext* cx, AutoObjectVector& envChain,
                 HandleScript scriptArg, MutableHandleValue rval)
{
    return ExecuteScript(cx, envChain, scriptArg, rval.address());
}

MOZ_NEVER_INLINE JS_PUBLIC_API(bool)
JS_ExecuteScript(JSContext* cx, AutoObjectVector& envChain, HandleScript scriptArg)
{
    return ExecuteScript(cx, envChain, scriptArg, nullptr);
}

JS_PUBLIC_API(bool)
JS::CloneAndExecuteScript(JSContext* cx, HandleScript scriptArg,
                          JS::MutableHandleValue rval)
{
    CHECK_REQUEST(cx);
    RootedScript script(cx, scriptArg);
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    if (script->compartment() != cx->compartment()) {
        script = CloneGlobalScript(cx, ScopeKind::Global, script);
        if (!script)
            return false;

        js::Debugger::onNewScript(cx, script);
    }
    return ExecuteScript(cx, globalLexical, script, rval.address());
}

static const unsigned LARGE_SCRIPT_LENGTH = 500*1024;

static bool
Evaluate(JSContext* cx, ScopeKind scopeKind, HandleObject env,
         const ReadOnlyCompileOptions& optionsArg,
         SourceBufferHolder& srcBuf, MutableHandleValue rval)
{
    CompileOptions options(cx, optionsArg);
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, env);
    MOZ_ASSERT_IF(!IsGlobalLexicalEnvironment(env), scopeKind == ScopeKind::NonSyntactic);

    options.setIsRunOnce(true);
    SourceCompressionTask sct(cx);
    RootedScript script(cx, frontend::CompileGlobalScript(cx, cx->tempLifoAlloc(),
                                                          scopeKind, options, srcBuf, &sct));
    if (!script)
        return false;

    MOZ_ASSERT(script->getVersion() == options.version);

    bool result = Execute(cx, script, *env,
                          options.noScriptRval ? nullptr : rval.address());
    if (!sct.complete())
        result = false;

    // After evaluation, the compiled script will not be run again.
    // script->ensureRanAnalysis allocated 1 analyze::Bytecode for every opcode
    // which for large scripts means significant memory. Perform a GC eagerly
    // to clear out this analysis data before anything happens to inhibit the
    // flushing of this memory (such as setting requestAnimationFrame).
    if (script->length() > LARGE_SCRIPT_LENGTH) {
        script = nullptr;
        PrepareZoneForGC(cx->zone());
        cx->runtime()->gc.gc(GC_NORMAL, JS::gcreason::FINISH_LARGE_EVALUATE);
    }

    return result;
}

static bool
Evaluate(JSContext* cx, AutoObjectVector& envChain, const ReadOnlyCompileOptions& optionsArg,
         SourceBufferHolder& srcBuf, MutableHandleValue rval)
{
    RootedObject env(cx);
    RootedScope scope(cx);
    if (!CreateNonSyntacticEnvironmentChain(cx, envChain, &env, &scope))
        return false;
    return ::Evaluate(cx, scope->kind(), env, optionsArg, srcBuf, rval);
}

static bool
Evaluate(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
         const char16_t* chars, size_t length, MutableHandleValue rval)
{
  SourceBufferHolder srcBuf(chars, length, SourceBufferHolder::NoOwnership);
  RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
  return ::Evaluate(cx, ScopeKind::Global, globalLexical, optionsArg, srcBuf, rval);
}

extern JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, const ReadOnlyCompileOptions& options,
             const char* bytes, size_t length, MutableHandleValue rval)
{
    char16_t* chars;
    if (options.utf8)
        chars = UTF8CharsToNewTwoByteCharsZ(cx, JS::UTF8Chars(bytes, length), &length).get();
    else
        chars = InflateString(cx, bytes, &length);
    if (!chars)
        return false;

    SourceBufferHolder srcBuf(chars, length, SourceBufferHolder::GiveOwnership);
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    bool ok = ::Evaluate(cx, ScopeKind::Global, globalLexical, options, srcBuf, rval);
    return ok;
}

static bool
Evaluate(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
         const char* filename, MutableHandleValue rval)
{
    FileContents buffer(cx);
    {
        AutoFile file;
        if (!file.open(cx, filename) || !file.readAll(cx, buffer))
            return false;
    }

    CompileOptions options(cx, optionsArg);
    options.setFileAndLine(filename, 1);
    return Evaluate(cx, options, buffer.begin(), buffer.length(), rval);
}

JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
             SourceBufferHolder& srcBuf, MutableHandleValue rval)
{
    RootedObject globalLexical(cx, &cx->global()->lexicalEnvironment());
    return ::Evaluate(cx, ScopeKind::Global, globalLexical, optionsArg, srcBuf, rval);
}

JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, AutoObjectVector& envChain, const ReadOnlyCompileOptions& optionsArg,
             SourceBufferHolder& srcBuf, MutableHandleValue rval)
{
    return ::Evaluate(cx, envChain, optionsArg, srcBuf, rval);
}

JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
             const char16_t* chars, size_t length, MutableHandleValue rval)
{
    return ::Evaluate(cx, optionsArg, chars, length, rval);
}

JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, AutoObjectVector& envChain, const ReadOnlyCompileOptions& optionsArg,
             const char16_t* chars, size_t length, MutableHandleValue rval)
{
    SourceBufferHolder srcBuf(chars, length, SourceBufferHolder::NoOwnership);
    return ::Evaluate(cx, envChain, optionsArg, srcBuf, rval);
}

JS_PUBLIC_API(bool)
JS::Evaluate(JSContext* cx, const ReadOnlyCompileOptions& optionsArg,
             const char* filename, MutableHandleValue rval)
{
    return ::Evaluate(cx, optionsArg, filename, rval);
}

JS_PUBLIC_API(JSFunction*)
JS::GetModuleResolveHook(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return cx->global()->moduleResolveHook();
}

JS_PUBLIC_API(void)
JS::SetModuleResolveHook(JSContext* cx, HandleFunction func)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, func);
    cx->global()->setModuleResolveHook(func);
}

JS_PUBLIC_API(bool)
JS::CompileModule(JSContext* cx, const ReadOnlyCompileOptions& options,
                  SourceBufferHolder& srcBuf, JS::MutableHandleObject module)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    module.set(frontend::CompileModule(cx, options, srcBuf));
    return !!module;
}

JS_PUBLIC_API(void)
JS::SetModuleHostDefinedField(JSObject* module, const JS::Value& value)
{
    module->as<ModuleObject>().setHostDefinedField(value);
}

JS_PUBLIC_API(JS::Value)
JS::GetModuleHostDefinedField(JSObject* module)
{
    return module->as<ModuleObject>().hostDefinedField();
}

JS_PUBLIC_API(bool)
JS::ModuleDeclarationInstantiation(JSContext* cx, JS::HandleObject moduleArg)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, moduleArg);
    return ModuleObject::DeclarationInstantiation(cx, moduleArg.as<ModuleObject>());
}

JS_PUBLIC_API(bool)
JS::ModuleEvaluation(JSContext* cx, JS::HandleObject moduleArg)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, moduleArg);
    return ModuleObject::Evaluation(cx, moduleArg.as<ModuleObject>());
}

JS_PUBLIC_API(JSObject*)
JS::GetRequestedModules(JSContext* cx, JS::HandleObject moduleArg)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, moduleArg);
    return &moduleArg->as<ModuleObject>().requestedModules();
}

JS_PUBLIC_API(JSScript*)
JS::GetModuleScript(JSContext* cx, JS::HandleObject moduleArg)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, moduleArg);
    return moduleArg->as<ModuleObject>().script();
}

JS_PUBLIC_API(JSObject*)
JS_New(JSContext* cx, HandleObject ctor, const JS::HandleValueArray& inputArgs)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, ctor, inputArgs);

    RootedValue ctorVal(cx, ObjectValue(*ctor));
    if (!IsConstructor(ctorVal)) {
        ReportValueError(cx, JSMSG_NOT_CONSTRUCTOR, JSDVG_IGNORE_STACK, ctorVal, nullptr);
        return nullptr;
    }

    ConstructArgs args(cx);
    if (!FillArgumentsFromArraylike(cx, args, inputArgs))
        return nullptr;

    RootedObject obj(cx);
    if (!js::Construct(cx, ctorVal, args, ctorVal, &obj))
        return nullptr;

    return obj;
}

JS_PUBLIC_API(bool)
JS_CheckForInterrupt(JSContext* cx)
{
    return js::CheckForInterrupt(cx);
}

JS_PUBLIC_API(bool)
JS_AddInterruptCallback(JSContext* cx, JSInterruptCallback callback)
{
    return cx->interruptCallbacks.append(callback);
}

JS_PUBLIC_API(bool)
JS_DisableInterruptCallback(JSContext* cx)
{
    bool result = cx->interruptCallbackDisabled;
    cx->interruptCallbackDisabled = true;
    return result;
}

JS_PUBLIC_API(void)
JS_ResetInterruptCallback(JSContext* cx, bool enable)
{
    cx->interruptCallbackDisabled = enable;
}

/************************************************************************/

/*
 * Promises.
 */
JS_PUBLIC_API(void)
JS::SetGetIncumbentGlobalCallback(JSContext* cx, JSGetIncumbentGlobalCallback callback)
{
    cx->getIncumbentGlobalCallback = callback;
}

JS_PUBLIC_API(void)
JS::SetEnqueuePromiseJobCallback(JSContext* cx, JSEnqueuePromiseJobCallback callback,
                                 void* data /* = nullptr */)
{
    cx->enqueuePromiseJobCallback = callback;
    cx->enqueuePromiseJobCallbackData = data;
}

extern JS_PUBLIC_API(void)
JS::SetPromiseRejectionTrackerCallback(JSContext* cx, JSPromiseRejectionTrackerCallback callback,
                                       void* data /* = nullptr */)
{
    cx->promiseRejectionTrackerCallback = callback;
    cx->promiseRejectionTrackerCallbackData = data;
}

JS_PUBLIC_API(JSObject*)
JS::NewPromiseObject(JSContext* cx, HandleObject executor, HandleObject proto /* = nullptr */)
{
    MOZ_ASSERT(!cx->runtime()->isAtomsCompartment(cx->compartment()));
    MOZ_ASSERT(IsCallable(executor));
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, executor, proto);

    return PromiseObject::create(cx, executor, proto);
}

JS_PUBLIC_API(bool)
JS::IsPromiseObject(JS::HandleObject obj)
{
    return obj->is<PromiseObject>();
}

JS_PUBLIC_API(JSObject*)
JS::GetPromiseConstructor(JSContext* cx)
{
    CHECK_REQUEST(cx);
    Rooted<GlobalObject*> global(cx, cx->global());
    return GlobalObject::getOrCreatePromiseConstructor(cx, global);
}

JS_PUBLIC_API(JSObject*)
JS::GetPromisePrototype(JSContext* cx)
{
    CHECK_REQUEST(cx);
    Rooted<GlobalObject*> global(cx, cx->global());
    return GlobalObject::getOrCreatePromisePrototype(cx, global);
}

JS_PUBLIC_API(JS::PromiseState)
JS::GetPromiseState(JS::HandleObject promise)
{
    return promise->as<PromiseObject>().state();
}

JS_PUBLIC_API(uint64_t)
JS::GetPromiseID(JS::HandleObject promise)
{
    return promise->as<PromiseObject>().getID();
}

JS_PUBLIC_API(JS::Value)
JS::GetPromiseResult(JS::HandleObject promiseObj)
{
    PromiseObject* promise = &promiseObj->as<PromiseObject>();
    MOZ_ASSERT(promise->state() != JS::PromiseState::Pending);
    return promise->state() == JS::PromiseState::Fulfilled ? promise->value() : promise->reason();
}

JS_PUBLIC_API(JSObject*)
JS::GetPromiseAllocationSite(JS::HandleObject promise)
{
    return promise->as<PromiseObject>().allocationSite();
}

JS_PUBLIC_API(JSObject*)
JS::GetPromiseResolutionSite(JS::HandleObject promise)
{
    return promise->as<PromiseObject>().resolutionSite();
}

#ifdef DEBUG
JS_PUBLIC_API(void)
JS::DumpPromiseAllocationSite(JSContext* cx, JS::HandleObject promise)
{
    RootedObject stack(cx, promise->as<PromiseObject>().allocationSite());
    UniqueChars stackStr(reinterpret_cast<char*>(BuildUTF8StackString(cx, stack).get()));
    if (stackStr.get())
        fputs(stackStr.get(), stderr);
}

JS_PUBLIC_API(void)
JS::DumpPromiseResolutionSite(JSContext* cx, JS::HandleObject promise)
{
    RootedObject stack(cx, promise->as<PromiseObject>().resolutionSite());
    UniqueChars stackStr(reinterpret_cast<char*>(BuildUTF8StackString(cx, stack).get()));
    if (stackStr.get())
        fputs(stackStr.get(), stderr);
}
#endif

JS_PUBLIC_API(JSObject*)
JS::CallOriginalPromiseResolve(JSContext* cx, JS::HandleValue resolutionValue)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, resolutionValue);

    RootedObject promise(cx, PromiseObject::unforgeableResolve(cx, resolutionValue));
    MOZ_ASSERT_IF(promise, promise->is<PromiseObject>());
    return promise;
}

JS_PUBLIC_API(JSObject*)
JS::CallOriginalPromiseReject(JSContext* cx, JS::HandleValue rejectionValue)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, rejectionValue);

    RootedObject promise(cx, PromiseObject::unforgeableReject(cx, rejectionValue));
    MOZ_ASSERT_IF(promise, promise->is<PromiseObject>());
    return promise;
}

JS_PUBLIC_API(bool)
JS::ResolvePromise(JSContext* cx, JS::HandleObject promise, JS::HandleValue resolutionValue)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, promise, resolutionValue);

    MOZ_ASSERT(promise->is<PromiseObject>());
    return promise->as<PromiseObject>().resolve(cx, resolutionValue);
}

JS_PUBLIC_API(bool)
JS::RejectPromise(JSContext* cx, JS::HandleObject promise, JS::HandleValue rejectionValue)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, promise, rejectionValue);

    MOZ_ASSERT(promise->is<PromiseObject>());
    return promise->as<PromiseObject>().reject(cx, rejectionValue);
}

JS_PUBLIC_API(JSObject*)
JS::CallOriginalPromiseThen(JSContext* cx, JS::HandleObject promiseObj,
                            JS::HandleObject onResolveObj, JS::HandleObject onRejectObj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, promiseObj, onResolveObj, onRejectObj);

    MOZ_ASSERT_IF(onResolveObj, IsCallable(onResolveObj));
    MOZ_ASSERT_IF(onRejectObj, IsCallable(onRejectObj));

    Rooted<PromiseObject*> promise(cx, &promiseObj->as<PromiseObject>());
    RootedValue onFulfilled(cx, ObjectOrNullValue(onResolveObj));
    RootedValue onRejected(cx, ObjectOrNullValue(onRejectObj));
    return OriginalPromiseThen(cx, promise, onFulfilled, onRejected);
}

JS_PUBLIC_API(bool)
JS::AddPromiseReactions(JSContext* cx, JS::HandleObject promiseObj,
                        JS::HandleObject onResolvedObj, JS::HandleObject onRejectedObj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, promiseObj, onResolvedObj, onRejectedObj);

    MOZ_ASSERT(IsCallable(onResolvedObj));
    MOZ_ASSERT(IsCallable(onRejectedObj));

    Rooted<PromiseObject*> promise(cx, &promiseObj->as<PromiseObject>());
    RootedValue onResolved(cx, ObjectValue(*onResolvedObj));
    RootedValue onRejected(cx, ObjectValue(*onRejectedObj));
    return EnqueuePromiseReactions(cx, promise, nullptr, onResolved, onRejected);
}

/**
 * Unforgeable version of Promise.all for internal use.
 *
 * Takes a dense array of Promise objects and returns a promise that's
 * resolved with an array of resolution values when all those promises ahve
 * been resolved, or rejected with the rejection value of the first rejected
 * promise.
 *
 * Asserts that the array is dense and all entries are Promise objects.
 */
JS_PUBLIC_API(JSObject*)
JS::GetWaitForAllPromise(JSContext* cx, const JS::AutoObjectVector& promises)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return js::GetWaitForAllPromise(cx, promises);
}

JS_PUBLIC_API(void)
JS::SetAsyncTaskCallbacks(JSContext* cx, JS::StartAsyncTaskCallback start,
                          JS::FinishAsyncTaskCallback finish)
{
    cx->startAsyncTaskCallback = start;
    cx->finishAsyncTaskCallback = finish;
}

JS_PUBLIC_API(void)
JS_RequestInterruptCallback(JSContext* cx)
{
    cx->requestInterrupt(JSRuntime::RequestInterruptUrgent);
}

JS_PUBLIC_API(bool)
JS_IsRunning(JSContext* cx)
{
    return cx->currentlyRunning();
}

JS::AutoSetAsyncStackForNewCalls::AutoSetAsyncStackForNewCalls(
  JSContext* cx, HandleObject stack, const char* asyncCause,
  JS::AutoSetAsyncStackForNewCalls::AsyncCallKind kind)
  : cx(cx),
    oldAsyncStack(cx, cx->asyncStackForNewActivations),
    oldAsyncCause(cx->asyncCauseForNewActivations),
    oldAsyncCallIsExplicit(cx->asyncCallIsExplicit)
{
    CHECK_REQUEST(cx);

    // The option determines whether we actually use the new values at this
    // point. It will not affect restoring the previous values when the object
    // is destroyed, so if the option changes it won't cause consistency issues.
    if (!cx->options().asyncStack())
        return;

    SavedFrame* asyncStack = &stack->as<SavedFrame>();

    cx->asyncStackForNewActivations = asyncStack;
    cx->asyncCauseForNewActivations = asyncCause;
    cx->asyncCallIsExplicit = kind == AsyncCallKind::EXPLICIT;
}

JS::AutoSetAsyncStackForNewCalls::~AutoSetAsyncStackForNewCalls()
{
    cx->asyncCauseForNewActivations = oldAsyncCause;
    cx->asyncStackForNewActivations =
      oldAsyncStack ? &oldAsyncStack->as<SavedFrame>() : nullptr;
    cx->asyncCallIsExplicit = oldAsyncCallIsExplicit;
}

/************************************************************************/
JS_PUBLIC_API(JSString*)
JS_NewStringCopyN(JSContext* cx, const char* s, size_t n)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewStringCopyN<CanGC>(cx, s, n);
}

JS_PUBLIC_API(JSString*)
JS_NewStringCopyZ(JSContext* cx, const char* s)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (!s)
        return cx->runtime()->emptyString;
    return NewStringCopyZ<CanGC>(cx, s);
}

JS_PUBLIC_API(JSString*)
JS_NewStringCopyUTF8Z(JSContext* cx, const JS::ConstUTF8CharsZ s)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewStringCopyUTF8Z<CanGC>(cx, s);
}

JS_PUBLIC_API(JSString*)
JS_NewStringCopyUTF8N(JSContext* cx, const JS::UTF8Chars s)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewStringCopyUTF8N<CanGC>(cx, s);
}

JS_PUBLIC_API(bool)
JS_StringHasBeenPinned(JSContext* cx, JSString* str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    if (!str->isAtom())
        return false;

    return AtomIsPinned(cx, &str->asAtom());
}

JS_PUBLIC_API(jsid)
INTERNED_STRING_TO_JSID(JSContext* cx, JSString* str)
{
    MOZ_ASSERT(str);
    MOZ_ASSERT(((size_t)str & JSID_TYPE_MASK) == 0);
    MOZ_ASSERT_IF(cx, JS_StringHasBeenPinned(cx, str));
    return AtomToId(&str->asAtom());
}

JS_PUBLIC_API(JSString*)
JS_AtomizeAndPinJSString(JSContext* cx, HandleString str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JSAtom* atom = AtomizeString(cx, str, PinAtom);
    MOZ_ASSERT_IF(atom, JS_StringHasBeenPinned(cx, atom));
    return atom;
}

JS_PUBLIC_API(JSString*)
JS_AtomizeString(JSContext* cx, const char* s)
{
    return JS_AtomizeStringN(cx, s, strlen(s));
}

JS_PUBLIC_API(JSString*)
JS_AtomizeStringN(JSContext* cx, const char* s, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return Atomize(cx, s, length, DoNotPinAtom);
}

JS_PUBLIC_API(JSString*)
JS_AtomizeAndPinString(JSContext* cx, const char* s)
{
    return JS_AtomizeAndPinStringN(cx, s, strlen(s));
}

JS_PUBLIC_API(JSString*)
JS_AtomizeAndPinStringN(JSContext* cx, const char* s, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JSAtom* atom = Atomize(cx, s, length, PinAtom);
    MOZ_ASSERT_IF(atom, JS_StringHasBeenPinned(cx, atom));
    return atom;
}

JS_PUBLIC_API(JSString*)
JS_NewUCString(JSContext* cx, char16_t* chars, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewString<CanGC>(cx, chars, length);
}

JS_PUBLIC_API(JSString*)
JS_NewUCStringCopyN(JSContext* cx, const char16_t* s, size_t n)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (!n)
        return cx->names().empty;
    return NewStringCopyN<CanGC>(cx, s, n);
}

JS_PUBLIC_API(JSString*)
JS_NewUCStringCopyZ(JSContext* cx, const char16_t* s)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (!s)
        return cx->runtime()->emptyString;
    return NewStringCopyZ<CanGC>(cx, s);
}

JS_PUBLIC_API(JSString*)
JS_AtomizeUCString(JSContext* cx, const char16_t* s)
{
    return JS_AtomizeUCStringN(cx, s, js_strlen(s));
}

JS_PUBLIC_API(JSString*)
JS_AtomizeUCStringN(JSContext* cx, const char16_t* s, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return AtomizeChars(cx, s, length, DoNotPinAtom);
}

JS_PUBLIC_API(JSString*)
JS_AtomizeAndPinUCStringN(JSContext* cx, const char16_t* s, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    JSAtom* atom = AtomizeChars(cx, s, length, PinAtom);
    MOZ_ASSERT_IF(atom, JS_StringHasBeenPinned(cx, atom));
    return atom;
}

JS_PUBLIC_API(JSString*)
JS_AtomizeAndPinUCString(JSContext* cx, const char16_t* s)
{
    return JS_AtomizeAndPinUCStringN(cx, s, js_strlen(s));
}

JS_PUBLIC_API(size_t)
JS_GetStringLength(JSString* str)
{
    return str->length();
}

JS_PUBLIC_API(bool)
JS_StringIsFlat(JSString* str)
{
    return str->isFlat();
}

JS_PUBLIC_API(bool)
JS_StringHasLatin1Chars(JSString* str)
{
    return str->hasLatin1Chars();
}

JS_PUBLIC_API(const JS::Latin1Char*)
JS_GetLatin1StringCharsAndLength(JSContext* cx, const JS::AutoCheckCannotGC& nogc, JSString* str,
                                 size_t* plength)
{
    MOZ_ASSERT(plength);
    AssertHeapIsIdleOrStringIsFlat(cx, str);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);
    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
        return nullptr;
    *plength = linear->length();
    return linear->latin1Chars(nogc);
}

JS_PUBLIC_API(const char16_t*)
JS_GetTwoByteStringCharsAndLength(JSContext* cx, const JS::AutoCheckCannotGC& nogc, JSString* str,
                                  size_t* plength)
{
    MOZ_ASSERT(plength);
    AssertHeapIsIdleOrStringIsFlat(cx, str);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);
    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
        return nullptr;
    *plength = linear->length();
    return linear->twoByteChars(nogc);
}

JS_PUBLIC_API(const char16_t*)
JS_GetTwoByteExternalStringChars(JSString* str)
{
    return str->asExternal().twoByteChars();
}

JS_PUBLIC_API(bool)
JS_GetStringCharAt(JSContext* cx, JSString* str, size_t index, char16_t* res)
{
    AssertHeapIsIdleOrStringIsFlat(cx, str);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);

    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
        return false;

    *res = linear->latin1OrTwoByteChar(index);
    return true;
}

JS_PUBLIC_API(char16_t)
JS_GetFlatStringCharAt(JSFlatString* str, size_t index)
{
    return str->latin1OrTwoByteChar(index);
}

JS_PUBLIC_API(bool)
JS_CopyStringChars(JSContext* cx, mozilla::Range<char16_t> dest, JSString* str)
{
    AssertHeapIsIdleOrStringIsFlat(cx, str);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);

    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
        return false;

    MOZ_ASSERT(linear->length() <= dest.length());
    CopyChars(dest.begin().get(), *linear);
    return true;
}

JS_PUBLIC_API(const Latin1Char*)
JS_GetLatin1InternedStringChars(const JS::AutoCheckCannotGC& nogc, JSString* str)
{
    MOZ_ASSERT(str->isAtom());
    JSFlatString* flat = str->ensureFlat(nullptr);
    if (!flat)
        return nullptr;
    return flat->latin1Chars(nogc);
}

JS_PUBLIC_API(const char16_t*)
JS_GetTwoByteInternedStringChars(const JS::AutoCheckCannotGC& nogc, JSString* str)
{
    MOZ_ASSERT(str->isAtom());
    JSFlatString* flat = str->ensureFlat(nullptr);
    if (!flat)
        return nullptr;
    return flat->twoByteChars(nogc);
}

extern JS_PUBLIC_API(JSFlatString*)
JS_FlattenString(JSContext* cx, JSString* str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);
    JSFlatString* flat = str->ensureFlat(cx);
    if (!flat)
        return nullptr;
    return flat;
}

extern JS_PUBLIC_API(const Latin1Char*)
JS_GetLatin1FlatStringChars(const JS::AutoCheckCannotGC& nogc, JSFlatString* str)
{
    return str->latin1Chars(nogc);
}

extern JS_PUBLIC_API(const char16_t*)
JS_GetTwoByteFlatStringChars(const JS::AutoCheckCannotGC& nogc, JSFlatString* str)
{
    return str->twoByteChars(nogc);
}

JS_PUBLIC_API(bool)
JS_CompareStrings(JSContext* cx, JSString* str1, JSString* str2, int32_t* result)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return CompareStrings(cx, str1, str2, result);
}

JS_PUBLIC_API(bool)
JS_StringEqualsAscii(JSContext* cx, JSString* str, const char* asciiBytes, bool* match)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    JSLinearString* linearStr = str->ensureLinear(cx);
    if (!linearStr)
        return false;
    *match = StringEqualsAscii(linearStr, asciiBytes);
    return true;
}

JS_PUBLIC_API(bool)
JS_FlatStringEqualsAscii(JSFlatString* str, const char* asciiBytes)
{
    return StringEqualsAscii(str, asciiBytes);
}

JS_PUBLIC_API(size_t)
JS_PutEscapedFlatString(char* buffer, size_t size, JSFlatString* str, char quote)
{
    return PutEscapedString(buffer, size, str, quote);
}

JS_PUBLIC_API(size_t)
JS_PutEscapedString(JSContext* cx, char* buffer, size_t size, JSString* str, char quote)
{
    AssertHeapIsIdle(cx);
    JSLinearString* linearStr = str->ensureLinear(cx);
    if (!linearStr)
        return size_t(-1);
    return PutEscapedString(buffer, size, linearStr, quote);
}

JS_PUBLIC_API(bool)
JS_FileEscapedString(FILE* fp, JSString* str, char quote)
{
    JSLinearString* linearStr = str->ensureLinear(nullptr);
    return linearStr && FileEscapedString(fp, linearStr, quote);
}

JS_PUBLIC_API(JSString*)
JS_NewDependentString(JSContext* cx, HandleString str, size_t start, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewDependentString(cx, str, start, length);
}

JS_PUBLIC_API(JSString*)
JS_ConcatStrings(JSContext* cx, HandleString left, HandleString right)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return ConcatStrings<CanGC>(cx, left, right);
}

JS_PUBLIC_API(bool)
JS_DecodeBytes(JSContext* cx, const char* src, size_t srclen, char16_t* dst, size_t* dstlenp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    if (!dst) {
        *dstlenp = srclen;
        return true;
    }

    size_t dstlen = *dstlenp;

    if (srclen > dstlen) {
        CopyAndInflateChars(dst, src, dstlen);

        AutoSuppressGC suppress(cx);
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BUFFER_TOO_SMALL);
        return false;
    }

    CopyAndInflateChars(dst, src, srclen);
    *dstlenp = srclen;
    return true;
}

static char*
EncodeLatin1(ExclusiveContext* cx, JSString* str)
{
    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
        return nullptr;

    JS::AutoCheckCannotGC nogc;
    if (linear->hasTwoByteChars())
        return JS::LossyTwoByteCharsToNewLatin1CharsZ(cx, linear->twoByteRange(nogc)).c_str();

    size_t len = str->length();
    Latin1Char* buf = cx->pod_malloc<Latin1Char>(len + 1);
    if (!buf) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    mozilla::PodCopy(buf, linear->latin1Chars(nogc), len);
    buf[len] = '\0';
    return reinterpret_cast<char*>(buf);
}

JS_PUBLIC_API(char*)
JS_EncodeString(JSContext* cx, JSString* str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return EncodeLatin1(cx, str);
}

JS_PUBLIC_API(char*)
JS_EncodeStringToUTF8(JSContext* cx, HandleString str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    return StringToNewUTF8CharsZ(cx, *str).release();
}

JS_PUBLIC_API(size_t)
JS_GetStringEncodingLength(JSContext* cx, JSString* str)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    if (!str->ensureLinear(cx))
        return size_t(-1);
    return str->length();
}

JS_PUBLIC_API(size_t)
JS_EncodeStringToBuffer(JSContext* cx, JSString* str, char* buffer, size_t length)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    /*
     * FIXME bug 612141 - fix DeflateStringToBuffer interface so the result
     * would allow to distinguish between insufficient buffer and encoding
     * error.
     */
    size_t writtenLength = length;
    JSLinearString* linear = str->ensureLinear(cx);
    if (!linear)
         return size_t(-1);

    bool res;
    if (linear->hasLatin1Chars()) {
        JS::AutoCheckCannotGC nogc;
        res = DeflateStringToBuffer(nullptr, linear->latin1Chars(nogc), linear->length(), buffer,
                                    &writtenLength);
    } else {
        JS::AutoCheckCannotGC nogc;
        res = DeflateStringToBuffer(nullptr, linear->twoByteChars(nogc), linear->length(), buffer,
                                    &writtenLength);
    }
    if (res) {
        MOZ_ASSERT(writtenLength <= length);
        return writtenLength;
    }
    MOZ_ASSERT(writtenLength <= length);
    size_t necessaryLength = str->length();
    if (necessaryLength == size_t(-1))
        return size_t(-1);
    MOZ_ASSERT(writtenLength == length); // C strings are NOT encoded.
    return necessaryLength;
}

JS_PUBLIC_API(JS::Symbol*)
JS::NewSymbol(JSContext* cx, HandleString description)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (description)
        assertSameCompartment(cx, description);

    return Symbol::new_(cx, SymbolCode::UniqueSymbol, description);
}

JS_PUBLIC_API(JS::Symbol*)
JS::GetSymbolFor(JSContext* cx, HandleString key)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, key);

    return Symbol::for_(cx, key);
}

JS_PUBLIC_API(JSString*)
JS::GetSymbolDescription(HandleSymbol symbol)
{
    return symbol->description();
}

JS_PUBLIC_API(JS::SymbolCode)
JS::GetSymbolCode(Handle<Symbol*> symbol)
{
    return symbol->code();
}

JS_PUBLIC_API(JS::Symbol*)
JS::GetWellKnownSymbol(JSContext* cx, JS::SymbolCode which)
{
    return cx->wellKnownSymbols().get(uint32_t(which));
}

#ifdef DEBUG
static bool
PropertySpecNameIsDigits(const char* s) {
    if (JS::PropertySpecNameIsSymbol(s))
        return false;
    if (!*s)
        return false;
    for (; *s; s++) {
        if (*s < '0' || *s > '9')
            return false;
    }
    return true;
}
#endif // DEBUG

JS_PUBLIC_API(bool)
JS::PropertySpecNameEqualsId(const char* name, HandleId id)
{
    if (JS::PropertySpecNameIsSymbol(name)) {
        if (!JSID_IS_SYMBOL(id))
            return false;
        Symbol* sym = JSID_TO_SYMBOL(id);
        return sym->isWellKnownSymbol() && sym->code() == PropertySpecNameToSymbolCode(name);
    }

    MOZ_ASSERT(!PropertySpecNameIsDigits(name));
    return JSID_IS_ATOM(id) && JS_FlatStringEqualsAscii(JSID_TO_ATOM(id), name);
}

JS_PUBLIC_API(bool)
JS_Stringify(JSContext* cx, MutableHandleValue vp, HandleObject replacer,
             HandleValue space, JSONWriteCallback callback, void* data)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, replacer, space);
    StringBuffer sb(cx);
    if (!sb.ensureTwoByteChars())
        return false;
    if (!Stringify(cx, vp, replacer, space, sb, StringifyBehavior::Normal))
        return false;
    if (sb.empty() && !sb.append(cx->names().null))
        return false;
    return callback(sb.rawTwoByteBegin(), sb.length(), data);
}

JS_PUBLIC_API(bool)
JS::ToJSONMaybeSafely(JSContext* cx, JS::HandleObject input,
                      JSONWriteCallback callback, void* data)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, input);

    StringBuffer sb(cx);
    if (!sb.ensureTwoByteChars())
        return false;

    RootedValue inputValue(cx, ObjectValue(*input));
    if (!Stringify(cx, &inputValue, nullptr, NullHandleValue, sb,
                   StringifyBehavior::RestrictedSafe))
        return false;

    if (sb.empty() && !sb.append(cx->names().null))
        return false;

    return callback(sb.rawTwoByteBegin(), sb.length(), data);
}

JS_PUBLIC_API(bool)
JS_ParseJSON(JSContext* cx, const char16_t* chars, uint32_t len, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return ParseJSONWithReviver(cx, mozilla::Range<const char16_t>(chars, len), NullHandleValue, vp);
}

JS_PUBLIC_API(bool)
JS_ParseJSON(JSContext* cx, HandleString str, MutableHandleValue vp)
{
    return JS_ParseJSONWithReviver(cx, str, NullHandleValue, vp);
}

JS_PUBLIC_API(bool)
JS_ParseJSONWithReviver(JSContext* cx, const char16_t* chars, uint32_t len, HandleValue reviver, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return ParseJSONWithReviver(cx, mozilla::Range<const char16_t>(chars, len), reviver, vp);
}

JS_PUBLIC_API(bool)
JS_ParseJSONWithReviver(JSContext* cx, HandleString str, HandleValue reviver, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, str);

    AutoStableStringChars stableChars(cx);
    if (!stableChars.init(cx, str))
        return false;

    return stableChars.isLatin1()
           ? ParseJSONWithReviver(cx, stableChars.latin1Range(), reviver, vp)
           : ParseJSONWithReviver(cx, stableChars.twoByteRange(), reviver, vp);
}

/************************************************************************/

JS_PUBLIC_API(void)
JS_ReportErrorASCII(JSContext* cx, const char* format, ...)
{
    va_list ap;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ReportErrorVA(cx, JSREPORT_ERROR, format, ArgumentsAreASCII, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorLatin1(JSContext* cx, const char* format, ...)
{
    va_list ap;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ReportErrorVA(cx, JSREPORT_ERROR, format, ArgumentsAreLatin1, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorUTF8(JSContext* cx, const char* format, ...)
{
    va_list ap;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ReportErrorVA(cx, JSREPORT_ERROR, format, ArgumentsAreUTF8, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberASCII(JSContext* cx, JSErrorCallback errorCallback,
                          void* userRef, const unsigned errorNumber, ...)
{
    va_list ap;
    va_start(ap, errorNumber);
    JS_ReportErrorNumberASCIIVA(cx, errorCallback, userRef, errorNumber, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberASCIIVA(JSContext* cx, JSErrorCallback errorCallback,
                            void* userRef, const unsigned errorNumber,
                            va_list ap)
{
    AssertHeapIsIdle(cx);
    ReportErrorNumberVA(cx, JSREPORT_ERROR, errorCallback, userRef,
                        errorNumber, ArgumentsAreASCII, ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberLatin1(JSContext* cx, JSErrorCallback errorCallback,
                           void* userRef, const unsigned errorNumber, ...)
{
    va_list ap;
    va_start(ap, errorNumber);
    JS_ReportErrorNumberLatin1VA(cx, errorCallback, userRef, errorNumber, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberLatin1VA(JSContext* cx, JSErrorCallback errorCallback,
                             void* userRef, const unsigned errorNumber,
                             va_list ap)
{
    AssertHeapIsIdle(cx);
    ReportErrorNumberVA(cx, JSREPORT_ERROR, errorCallback, userRef,
                        errorNumber, ArgumentsAreLatin1, ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberUTF8(JSContext* cx, JSErrorCallback errorCallback,
                           void* userRef, const unsigned errorNumber, ...)
{
    va_list ap;
    va_start(ap, errorNumber);
    JS_ReportErrorNumberUTF8VA(cx, errorCallback, userRef, errorNumber, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberUTF8VA(JSContext* cx, JSErrorCallback errorCallback,
                           void* userRef, const unsigned errorNumber,
                           va_list ap)
{
    AssertHeapIsIdle(cx);
    ReportErrorNumberVA(cx, JSREPORT_ERROR, errorCallback, userRef,
                        errorNumber, ArgumentsAreUTF8, ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberUC(JSContext* cx, JSErrorCallback errorCallback,
                       void* userRef, const unsigned errorNumber, ...)
{
    va_list ap;

    AssertHeapIsIdle(cx);
    va_start(ap, errorNumber);
    ReportErrorNumberVA(cx, JSREPORT_ERROR, errorCallback, userRef,
                        errorNumber, ArgumentsAreUnicode, ap);
    va_end(ap);
}

JS_PUBLIC_API(void)
JS_ReportErrorNumberUCArray(JSContext* cx, JSErrorCallback errorCallback,
                            void* userRef, const unsigned errorNumber,
                            const char16_t** args)
{
    AssertHeapIsIdle(cx);
    ReportErrorNumberUCArray(cx, JSREPORT_ERROR, errorCallback, userRef,
                             errorNumber, args);
}

JS_PUBLIC_API(bool)
JS_ReportWarningASCII(JSContext* cx, const char* format, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ok = ReportErrorVA(cx, JSREPORT_WARNING, format, ArgumentsAreASCII, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportWarningLatin1(JSContext* cx, const char* format, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ok = ReportErrorVA(cx, JSREPORT_WARNING, format, ArgumentsAreLatin1, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportWarningUTF8(JSContext* cx, const char* format, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, format);
    ok = ReportErrorVA(cx, JSREPORT_WARNING, format, ArgumentsAreUTF8, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportErrorFlagsAndNumberASCII(JSContext* cx, unsigned flags,
                                  JSErrorCallback errorCallback, void* userRef,
                                  const unsigned errorNumber, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, errorNumber);
    ok = ReportErrorNumberVA(cx, flags, errorCallback, userRef,
                             errorNumber, ArgumentsAreASCII, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportErrorFlagsAndNumberLatin1(JSContext* cx, unsigned flags,
                                   JSErrorCallback errorCallback, void* userRef,
                                   const unsigned errorNumber, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, errorNumber);
    ok = ReportErrorNumberVA(cx, flags, errorCallback, userRef,
                             errorNumber, ArgumentsAreLatin1, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportErrorFlagsAndNumberUTF8(JSContext* cx, unsigned flags,
                                 JSErrorCallback errorCallback, void* userRef,
                                 const unsigned errorNumber, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, errorNumber);
    ok = ReportErrorNumberVA(cx, flags, errorCallback, userRef,
                             errorNumber, ArgumentsAreUTF8, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(bool)
JS_ReportErrorFlagsAndNumberUC(JSContext* cx, unsigned flags,
                               JSErrorCallback errorCallback, void* userRef,
                               const unsigned errorNumber, ...)
{
    va_list ap;
    bool ok;

    AssertHeapIsIdle(cx);
    va_start(ap, errorNumber);
    ok = ReportErrorNumberVA(cx, flags, errorCallback, userRef,
                             errorNumber, ArgumentsAreUnicode, ap);
    va_end(ap);
    return ok;
}

JS_PUBLIC_API(void)
JS_ReportOutOfMemory(JSContext* cx)
{
    ReportOutOfMemory(cx);
}

JS_PUBLIC_API(void)
JS_ReportAllocationOverflow(JSContext* cx)
{
    ReportAllocationOverflow(cx);
}

JS_PUBLIC_API(JS::WarningReporter)
JS::GetWarningReporter(JSContext* cx)
{
    return cx->warningReporter;
}

JS_PUBLIC_API(JS::WarningReporter)
JS::SetWarningReporter(JSContext* cx, JS::WarningReporter reporter)
{
    WarningReporter older = cx->warningReporter;
    cx->warningReporter = reporter;
    return older;
}

/************************************************************************/

/*
 * Dates.
 */
JS_PUBLIC_API(JSObject*)
JS_NewDateObject(JSContext* cx, int year, int mon, int mday, int hour, int min, int sec)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewDateObject(cx, year, mon, mday, hour, min, sec);
}

JS_PUBLIC_API(JSObject*)
JS::NewDateObject(JSContext* cx, JS::ClippedTime time)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return NewDateObjectMsec(cx, time);
}

JS_PUBLIC_API(bool)
JS_ObjectIsDate(JSContext* cx, HandleObject obj, bool* isDate)
{
    assertSameCompartment(cx, obj);

    ESClass cls;
    if (!GetBuiltinClass(cx, obj, &cls))
        return false;

    *isDate = cls == ESClass::Date;
    return true;
}

/************************************************************************/

/*
 * Regular Expressions.
 */
JS_PUBLIC_API(JSObject*)
JS_NewRegExpObject(JSContext* cx, const char* bytes, size_t length, unsigned flags)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    ScopedJSFreePtr<char16_t> chars(InflateString(cx, bytes, &length));
    if (!chars)
        return nullptr;

    RegExpObject* reobj = RegExpObject::create(cx, chars, length,
                                               RegExpFlag(flags), nullptr, cx->tempLifoAlloc());
    return reobj;
}

JS_PUBLIC_API(JSObject*)
JS_NewUCRegExpObject(JSContext* cx, const char16_t* chars, size_t length, unsigned flags)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    return RegExpObject::create(cx, chars, length,
                                RegExpFlag(flags), nullptr, cx->tempLifoAlloc());
}

JS_PUBLIC_API(bool)
JS_SetRegExpInput(JSContext* cx, HandleObject obj, HandleString input)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, input);

    RegExpStatics* res = obj->as<GlobalObject>().getRegExpStatics(cx);
    if (!res)
        return false;

    res->reset(cx, input);
    return true;
}

JS_PUBLIC_API(bool)
JS_ClearRegExpStatics(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT(obj);

    RegExpStatics* res = obj->as<GlobalObject>().getRegExpStatics(cx);
    if (!res)
        return false;

    res->clear();
    return true;
}

JS_PUBLIC_API(bool)
JS_ExecuteRegExp(JSContext* cx, HandleObject obj, HandleObject reobj, char16_t* chars,
                 size_t length, size_t* indexp, bool test, MutableHandleValue rval)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RegExpStatics* res = obj->as<GlobalObject>().getRegExpStatics(cx);
    if (!res)
        return false;

    RootedLinearString input(cx, NewStringCopyN<CanGC>(cx, chars, length));
    if (!input)
        return false;

    return ExecuteRegExpLegacy(cx, res, reobj->as<RegExpObject>(), input, indexp, test, rval);
}

JS_PUBLIC_API(bool)
JS_ExecuteRegExpNoStatics(JSContext* cx, HandleObject obj, char16_t* chars, size_t length,
                          size_t* indexp, bool test, MutableHandleValue rval)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RootedLinearString input(cx, NewStringCopyN<CanGC>(cx, chars, length));
    if (!input)
        return false;

    return ExecuteRegExpLegacy(cx, nullptr, obj->as<RegExpObject>(), input, indexp, test,
                               rval);
}

JS_PUBLIC_API(bool)
JS_ObjectIsRegExp(JSContext* cx, HandleObject obj, bool* isRegExp)
{
    assertSameCompartment(cx, obj);

    ESClass cls;
    if (!GetBuiltinClass(cx, obj, &cls))
        return false;

    *isRegExp = cls == ESClass::RegExp;
    return true;
}

JS_PUBLIC_API(unsigned)
JS_GetRegExpFlags(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RegExpGuard shared(cx);
    if (!RegExpToShared(cx, obj, &shared))
        return false;
    return shared.re()->getFlags();
}

JS_PUBLIC_API(JSString*)
JS_GetRegExpSource(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    RegExpGuard shared(cx);
    if (!RegExpToShared(cx, obj, &shared))
        return nullptr;
    return shared.re()->getSource();
}

/************************************************************************/

JS_PUBLIC_API(bool)
JS_SetDefaultLocale(JSContext* cx, const char* locale)
{
    AssertHeapIsIdle(cx);
    return cx->setDefaultLocale(locale);
}

JS_PUBLIC_API(UniqueChars)
JS_GetDefaultLocale(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    if (const char* locale = cx->getDefaultLocale())
        return UniqueChars(JS_strdup(cx, locale));

    return nullptr;
}

JS_PUBLIC_API(void)
JS_ResetDefaultLocale(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    cx->resetDefaultLocale();
}

JS_PUBLIC_API(void)
JS_SetLocaleCallbacks(JSContext* cx, const JSLocaleCallbacks* callbacks)
{
    AssertHeapIsIdle(cx);
    cx->localeCallbacks = callbacks;
}

JS_PUBLIC_API(const JSLocaleCallbacks*)
JS_GetLocaleCallbacks(JSContext* cx)
{
    /* This function can be called by a finalizer. */
    return cx->localeCallbacks;
}

/************************************************************************/

JS_PUBLIC_API(bool)
JS_IsExceptionPending(JSContext* cx)
{
    /* This function can be called by a finalizer. */
    return (bool) cx->isExceptionPending();
}

JS_PUBLIC_API(bool)
JS_GetPendingException(JSContext* cx, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (!cx->isExceptionPending())
        return false;
    return cx->getPendingException(vp);
}

JS_PUBLIC_API(void)
JS_SetPendingException(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
    cx->setPendingException(value);
}

JS_PUBLIC_API(void)
JS_ClearPendingException(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    cx->clearPendingException();
}

JS::AutoSaveExceptionState::AutoSaveExceptionState(JSContext* cx)
  : context(cx),
    wasPropagatingForcedReturn(cx->propagatingForcedReturn_),
    wasOverRecursed(cx->overRecursed_),
    wasThrowing(cx->throwing),
    exceptionValue(cx)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (wasPropagatingForcedReturn)
        cx->clearPropagatingForcedReturn();
    if (wasOverRecursed)
        cx->overRecursed_ = false;
    if (wasThrowing) {
        exceptionValue = cx->unwrappedException_;
        cx->clearPendingException();
    }
}

void
JS::AutoSaveExceptionState::restore()
{
    context->propagatingForcedReturn_ = wasPropagatingForcedReturn;
    context->overRecursed_ = wasOverRecursed;
    context->throwing = wasThrowing;
    context->unwrappedException_ = exceptionValue;
    drop();
}

JS::AutoSaveExceptionState::~AutoSaveExceptionState()
{
    if (!context->isExceptionPending()) {
        if (wasPropagatingForcedReturn)
            context->setPropagatingForcedReturn();
        if (wasThrowing) {
            context->overRecursed_ = wasOverRecursed;
            context->throwing = true;
            context->unwrappedException_ = exceptionValue;
        }
    }
}

struct JSExceptionState {
    explicit JSExceptionState(JSContext* cx) : exception(cx) {}
    bool throwing;
    PersistentRootedValue exception;
};

JS_PUBLIC_API(JSExceptionState*)
JS_SaveExceptionState(JSContext* cx)
{
    JSExceptionState* state;

    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    state = cx->new_<JSExceptionState>(cx);
    if (state)
        state->throwing = JS_GetPendingException(cx, &state->exception);
    return state;
}

JS_PUBLIC_API(void)
JS_RestoreExceptionState(JSContext* cx, JSExceptionState* state)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    if (state) {
        if (state->throwing)
            JS_SetPendingException(cx, state->exception);
        else
            JS_ClearPendingException(cx);
        JS_DropExceptionState(cx, state);
    }
}

JS_PUBLIC_API(void)
JS_DropExceptionState(JSContext* cx, JSExceptionState* state)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    js_delete(state);
}

JS_PUBLIC_API(JSErrorReport*)
JS_ErrorFromException(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);
    return ErrorFromException(cx, obj);
}

void
JSErrorReport::initBorrowedLinebuf(const char16_t* linebufArg, size_t linebufLengthArg,
                                   size_t tokenOffsetArg)
{
    MOZ_ASSERT(linebufArg);
    MOZ_ASSERT(tokenOffsetArg <= linebufLengthArg);
    MOZ_ASSERT(linebufArg[linebufLengthArg] == '\0');

    linebuf_ = linebufArg;
    linebufLength_ = linebufLengthArg;
    tokenOffset_ = tokenOffsetArg;
}

void
JSErrorReport::freeLinebuf()
{
    if (ownsLinebuf_ && linebuf_) {
        js_free((void*)linebuf_);
        ownsLinebuf_ = false;
    }
    linebuf_ = nullptr;
}

JSString*
JSErrorReport::newMessageString(JSContext* cx)
{
    if (!message_)
        return cx->runtime()->emptyString;

    return JS_NewStringCopyUTF8Z(cx, message_);
}

void
JSErrorReport::freeMessage()
{
    if (ownsMessage_) {
        js_free((void*)message_.get());
        ownsMessage_ = false;
    }
    message_ = JS::ConstUTF8CharsZ();
}

JS_PUBLIC_API(bool)
JS_ThrowStopIteration(JSContext* cx)
{
    AssertHeapIsIdle(cx);
    return ThrowStopIteration(cx);
}

JS_PUBLIC_API(bool)
JS_IsStopIteration(const Value& v)
{
    return v.isObject() && v.toObject().is<StopIterationObject>();
}

extern MOZ_NEVER_INLINE JS_PUBLIC_API(void)
JS_AbortIfWrongThread(JSContext* cx)
{
    if (!CurrentThreadCanAccessRuntime(cx))
        MOZ_CRASH();
    if (!js::TlsPerThreadData.get()->associatedWith(cx))
        MOZ_CRASH();
}

#ifdef JS_GC_ZEAL
JS_PUBLIC_API(void)
JS_GetGCZealBits(JSContext* cx, uint32_t* zealBits, uint32_t* frequency, uint32_t* nextScheduled)
{
    cx->runtime()->gc.getZealBits(zealBits, frequency, nextScheduled);
}

JS_PUBLIC_API(void)
JS_SetGCZeal(JSContext* cx, uint8_t zeal, uint32_t frequency)
{
    cx->gc.setZeal(zeal, frequency);
}

JS_PUBLIC_API(void)
JS_ScheduleGC(JSContext* cx, uint32_t count)
{
    cx->runtime()->gc.setNextScheduled(count);
}
#endif

JS_PUBLIC_API(void)
JS_SetParallelParsingEnabled(JSContext* cx, bool enabled)
{
    cx->setParallelParsingEnabled(enabled);
}

JS_PUBLIC_API(void)
JS_SetOffthreadIonCompilationEnabled(JSContext* cx, bool enabled)
{
    cx->setOffthreadIonCompilationEnabled(enabled);
}

JS_PUBLIC_API(void)
JS_SetGlobalJitCompilerOption(JSContext* cx, JSJitCompilerOption opt, uint32_t value)
{
    JSRuntime* rt = cx->runtime();
    switch (opt) {
      case JSJITCOMPILER_BASELINE_WARMUP_TRIGGER:
        if (value == uint32_t(-1)) {
            jit::DefaultJitOptions defaultValues;
            value = defaultValues.baselineWarmUpThreshold;
        }
        jit::JitOptions.baselineWarmUpThreshold = value;
        break;
      case JSJITCOMPILER_ION_WARMUP_TRIGGER:
        if (value == uint32_t(-1)) {
            jit::JitOptions.resetCompilerWarmUpThreshold();
            break;
        }
        jit::JitOptions.setCompilerWarmUpThreshold(value);
        if (value == 0)
            jit::JitOptions.setEagerCompilation();
        break;
      case JSJITCOMPILER_ION_GVN_ENABLE:
        if (value == 0) {
            jit::JitOptions.enableGvn(false);
            JitSpew(js::jit::JitSpew_IonScripts, "Disable ion's GVN");
        } else {
            jit::JitOptions.enableGvn(true);
            JitSpew(js::jit::JitSpew_IonScripts, "Enable ion's GVN");
        }
        break;
      case JSJITCOMPILER_ION_FORCE_IC:
        if (value == 0) {
            jit::JitOptions.forceInlineCaches = false;
            JitSpew(js::jit::JitSpew_IonScripts, "IonBuilder: Enable non-IC optimizations.");
        } else {
            jit::JitOptions.forceInlineCaches = true;
            JitSpew(js::jit::JitSpew_IonScripts, "IonBuilder: Disable non-IC optimizations.");
        }
        break;
      case JSJITCOMPILER_ION_CHECK_RANGE_ANALYSIS:
        if (value == 0) {
            jit::JitOptions.checkRangeAnalysis = false;
            JitSpew(js::jit::JitSpew_IonScripts, "IonBuilder: Enable range analysis checks.");
        } else {
            jit::JitOptions.checkRangeAnalysis = true;
            JitSpew(js::jit::JitSpew_IonScripts, "IonBuilder: Disable range analysis checks.");
        }
        break;
      case JSJITCOMPILER_ION_ENABLE:
        if (value == 1) {
            JS::ContextOptionsRef(cx).setIon(true);
            JitSpew(js::jit::JitSpew_IonScripts, "Enable ion");
        } else if (value == 0) {
            JS::ContextOptionsRef(cx).setIon(false);
            JitSpew(js::jit::JitSpew_IonScripts, "Disable ion");
        }
        break;
      case JSJITCOMPILER_BASELINE_ENABLE:
        if (value == 1) {
            JS::ContextOptionsRef(cx).setBaseline(true);
            ReleaseAllJITCode(rt->defaultFreeOp());
            JitSpew(js::jit::JitSpew_BaselineScripts, "Enable baseline");
        } else if (value == 0) {
            JS::ContextOptionsRef(cx).setBaseline(false);
            ReleaseAllJITCode(rt->defaultFreeOp());
            JitSpew(js::jit::JitSpew_BaselineScripts, "Disable baseline");
        }
        break;
      case JSJITCOMPILER_OFFTHREAD_COMPILATION_ENABLE:
        if (value == 1) {
            rt->setOffthreadIonCompilationEnabled(true);
            JitSpew(js::jit::JitSpew_IonScripts, "Enable offthread compilation");
        } else if (value == 0) {
            rt->setOffthreadIonCompilationEnabled(false);
            JitSpew(js::jit::JitSpew_IonScripts, "Disable offthread compilation");
        }
        break;
      case JSJITCOMPILER_JUMP_THRESHOLD:
        if (value == uint32_t(-1)) {
            jit::DefaultJitOptions defaultValues;
            value = defaultValues.jumpThreshold;
        }
        jit::JitOptions.jumpThreshold = value;
        break;
      case JSJITCOMPILER_ASMJS_ATOMICS_ENABLE:
        jit::JitOptions.asmJSAtomicsEnable = !!value;
        break;
      case JSJITCOMPILER_WASM_TEST_MODE:
        jit::JitOptions.wasmTestMode = !!value;
        break;
      case JSJITCOMPILER_WASM_FOLD_OFFSETS:
        jit::JitOptions.wasmFoldOffsets = !!value;
        break;
      case JSJITCOMPILER_ION_INTERRUPT_WITHOUT_SIGNAL:
        jit::JitOptions.ionInterruptWithoutSignals = !!value;
        break;
      default:
        break;
    }
}

JS_PUBLIC_API(bool)
JS_GetGlobalJitCompilerOption(JSContext* cx, JSJitCompilerOption opt, uint32_t* valueOut)
{
    MOZ_ASSERT(valueOut);
#ifndef JS_CODEGEN_NONE
    JSRuntime* rt = cx->runtime();
    switch (opt) {
      case JSJITCOMPILER_BASELINE_WARMUP_TRIGGER:
        *valueOut = jit::JitOptions.baselineWarmUpThreshold;
        break;
      case JSJITCOMPILER_ION_WARMUP_TRIGGER:
        *valueOut = jit::JitOptions.forcedDefaultIonWarmUpThreshold.isSome()
                  ? jit::JitOptions.forcedDefaultIonWarmUpThreshold.ref()
                  : jit::OptimizationInfo::CompilerWarmupThreshold;
        break;
      case JSJITCOMPILER_ION_FORCE_IC:
        *valueOut = jit::JitOptions.forceInlineCaches;
        break;
      case JSJITCOMPILER_ION_CHECK_RANGE_ANALYSIS:
        *valueOut = jit::JitOptions.checkRangeAnalysis;
        break;
      case JSJITCOMPILER_ION_ENABLE:
        *valueOut = JS::ContextOptionsRef(cx).ion();
        break;
      case JSJITCOMPILER_BASELINE_ENABLE:
        *valueOut = JS::ContextOptionsRef(cx).baseline();
        break;
      case JSJITCOMPILER_OFFTHREAD_COMPILATION_ENABLE:
        *valueOut = rt->canUseOffthreadIonCompilation();
        break;
      case JSJITCOMPILER_ASMJS_ATOMICS_ENABLE:
        *valueOut = jit::JitOptions.asmJSAtomicsEnable ? 1 : 0;
        break;
      case JSJITCOMPILER_WASM_TEST_MODE:
        *valueOut = jit::JitOptions.wasmTestMode ? 1 : 0;
        break;
      case JSJITCOMPILER_WASM_FOLD_OFFSETS:
        *valueOut = jit::JitOptions.wasmFoldOffsets ? 1 : 0;
        break;
      case JSJITCOMPILER_ION_INTERRUPT_WITHOUT_SIGNAL:
        *valueOut = jit::JitOptions.ionInterruptWithoutSignals ? 1 : 0;
        break;
      default:
        return false;
    }
#else
    *valueOut = 0;
#endif
    return true;
}

/************************************************************************/

#if !defined(STATIC_EXPORTABLE_JS_API) && !defined(STATIC_JS_API) && defined(XP_WIN)

#include "jswin.h"

/*
 * Initialization routine for the JS DLL.
 */
BOOL WINAPI DllMain (HINSTANCE hDLL, DWORD dwReason, LPVOID lpReserved)
{
    return TRUE;
}

#endif

JS_PUBLIC_API(bool)
JS_IndexToId(JSContext* cx, uint32_t index, MutableHandleId id)
{
    return IndexToId(cx, index, id);
}

JS_PUBLIC_API(bool)
JS_CharsToId(JSContext* cx, JS::TwoByteChars chars, MutableHandleId idp)
{
    RootedAtom atom(cx, AtomizeChars(cx, chars.begin().get(), chars.length()));
    if (!atom)
        return false;
#ifdef DEBUG
    uint32_t dummy;
    MOZ_ASSERT(!atom->isIndex(&dummy), "API misuse: |chars| must not encode an index");
#endif
    idp.set(AtomToId(atom));
    return true;
}

JS_PUBLIC_API(bool)
JS_IsIdentifier(JSContext* cx, HandleString str, bool* isIdentifier)
{
    assertSameCompartment(cx, str);

    JSLinearString* linearStr = str->ensureLinear(cx);
    if (!linearStr)
        return false;

    *isIdentifier = js::frontend::IsIdentifier(linearStr);
    return true;
}

JS_PUBLIC_API(bool)
JS_IsIdentifier(const char16_t* chars, size_t length)
{
    return js::frontend::IsIdentifier(chars, length);
}

namespace JS {

void AutoFilename::reset()
{
    if (ss_) {
        ss_->decref();
        ss_ = nullptr;
    }
    if (filename_.is<const char*>())
        filename_.as<const char*>() = nullptr;
    else
        filename_.as<UniqueChars>().reset();
}

void AutoFilename::setScriptSource(js::ScriptSource* p)
{
    MOZ_ASSERT(!ss_);
    MOZ_ASSERT(!get());
    ss_ = p;
    if (p) {
        p->incref();
        setUnowned(p->filename());
    }
}

void AutoFilename::setUnowned(const char* filename)
{
    MOZ_ASSERT(!get());
    filename_.as<const char*>() = filename ? filename : "";
}

void AutoFilename::setOwned(UniqueChars&& filename)
{
    MOZ_ASSERT(!get());
    filename_ = AsVariant(Move(filename));
}

const char* AutoFilename::get() const
{
    if (filename_.is<const char*>())
        return filename_.as<const char*>();
    return filename_.as<UniqueChars>().get();
}

JS_PUBLIC_API(bool)
DescribeScriptedCaller(JSContext* cx, AutoFilename* filename, unsigned* lineno,
                       unsigned* column)
{
    if (filename)
        filename->reset();
    if (lineno)
        *lineno = 0;
    if (column)
        *column = 0;

    if (!cx->compartment())
        return false;

    NonBuiltinFrameIter i(cx, cx->compartment()->principals());
    if (i.done())
        return false;

    // If the caller is hidden, the embedding wants us to return false here so
    // that it can check its own stack (see HideScriptedCaller).
    if (i.activation()->scriptedCallerIsHidden())
        return false;

    if (filename) {
        if (i.isWasm()) {
            // For Wasm, copy out the filename, there is no script source.
            UniqueChars copy = DuplicateString(i.filename() ? i.filename() : "");
            if (!copy)
                filename->setUnowned("out of memory");
            else
                filename->setOwned(Move(copy));
        } else {
            // All other frames have a script source to read the filename from.
            filename->setScriptSource(i.scriptSource());
        }
    }

    if (lineno)
        *lineno = i.computeLine(column);
    else if (column)
        i.computeLine(column);

    return true;
}

// Fast path to get the activation to use for GetScriptedCallerGlobal. If this
// returns false, the fast path didn't work out and the caller has to use the
// (much slower) NonBuiltinFrameIter path.
//
// The optimization here is that we skip Ion-inlined frames and only look at
// 'outer' frames. That's fine: each activation is tied to a single compartment,
// so if an activation contains at least one non-self-hosted frame, we can use
// the activation's global for GetScriptedCallerGlobal. If, however, all 'outer'
// frames are self-hosted, it's possible Ion inlined a non-self-hosted script,
// so we must return false and use the slower path.
static bool
GetScriptedCallerActivationFast(JSContext* cx, Activation** activation)
{
    ActivationIterator activationIter(cx->runtime());

    if (activationIter.done()) {
        *activation = nullptr;
        return true;
    }

    *activation = activationIter.activation();

    if (activationIter->isJit()) {
        for (jit::JitFrameIterator iter(activationIter); !iter.done(); ++iter) {
            if (iter.isScripted() && !iter.script()->selfHosted())
                return true;
        }
    } else if (activationIter->isInterpreter()) {
        for (InterpreterFrameIterator iter((*activation)->asInterpreter()); !iter.done(); ++iter) {
            if (!iter.frame()->script()->selfHosted())
                return true;
        }
    }

    return false;
}

JS_PUBLIC_API(JSObject*)
GetScriptedCallerGlobal(JSContext* cx)
{
    Activation* activation;

    if (GetScriptedCallerActivationFast(cx, &activation)) {
        if (!activation)
            return nullptr;
    } else {
        NonBuiltinFrameIter i(cx);
        if (i.done())
            return nullptr;
        activation = i.activation();
    }

    // If the caller is hidden, the embedding wants us to return null here so
    // that it can check its own stack (see HideScriptedCaller).
    if (activation->scriptedCallerIsHidden())
        return nullptr;

    GlobalObject* global = activation->compartment()->maybeGlobal();

    // Noone should be running code in the atoms compartment or running code in
    // a compartment without any live objects, so there should definitely be a
    // live global.
    MOZ_ASSERT(global);

    return global;
}

JS_PUBLIC_API(void)
HideScriptedCaller(JSContext* cx)
{
    MOZ_ASSERT(cx);

    // If there's no accessible activation on the stack, we'll return null from
    // DescribeScriptedCaller anyway, so there's no need to annotate anything.
    Activation* act = cx->runtime()->activation();
    if (!act)
        return;
    act->hideScriptedCaller();
}

JS_PUBLIC_API(void)
UnhideScriptedCaller(JSContext* cx)
{
    Activation* act = cx->runtime()->activation();
    if (!act)
        return;
    act->unhideScriptedCaller();
}

} /* namespace JS */

AutoGCRooter::AutoGCRooter(JSContext* cx, ptrdiff_t tag)
  : AutoGCRooter(JS::RootingContext::get(cx), tag)
{}

AutoGCRooter::AutoGCRooter(JS::RootingContext* cx, ptrdiff_t tag)
  : down(cx->roots.autoGCRooters_),
    tag_(tag),
    stackTop(&cx->roots.autoGCRooters_)
{
    MOZ_ASSERT(this != *stackTop);
    *stackTop = this;
}

#ifdef JS_DEBUG
JS_PUBLIC_API(void)
JS::detail::AssertArgumentsAreSane(JSContext* cx, HandleValue value)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, value);
}
#endif /* JS_DEBUG */

JS_PUBLIC_API(JS::TranscodeResult)
JS::EncodeScript(JSContext* cx, TranscodeBuffer& buffer, HandleScript scriptArg)
{
    XDREncoder encoder(cx, buffer, buffer.length());
    RootedScript script(cx, scriptArg);
    if (!encoder.codeScript(&script))
        buffer.clearAndFree();
    MOZ_ASSERT(!buffer.empty() == (encoder.resultCode() == TranscodeResult_Ok));
    return encoder.resultCode();
}

JS_PUBLIC_API(JS::TranscodeResult)
JS::EncodeInterpretedFunction(JSContext* cx, TranscodeBuffer& buffer, HandleObject funobjArg)
{
    XDREncoder encoder(cx, buffer, buffer.length());
    RootedFunction funobj(cx, &funobjArg->as<JSFunction>());
    if (!encoder.codeFunction(&funobj))
        buffer.clearAndFree();
    MOZ_ASSERT(!buffer.empty() == (encoder.resultCode() == TranscodeResult_Ok));
    return encoder.resultCode();
}

JS_PUBLIC_API(JS::TranscodeResult)
JS::DecodeScript(JSContext* cx, TranscodeBuffer& buffer, JS::MutableHandleScript scriptp,
                 size_t cursorIndex)
{
    XDRDecoder decoder(cx, buffer, cursorIndex);
    decoder.codeScript(scriptp);
    MOZ_ASSERT(bool(scriptp) == (decoder.resultCode() == TranscodeResult_Ok));
    return decoder.resultCode();
}

JS_PUBLIC_API(JS::TranscodeResult)
JS::DecodeInterpretedFunction(JSContext* cx, TranscodeBuffer& buffer,
                              JS::MutableHandleFunction funp,
                              size_t cursorIndex)
{
    XDRDecoder decoder(cx, buffer, cursorIndex);
    decoder.codeFunction(funp);
    MOZ_ASSERT(bool(funp) == (decoder.resultCode() == TranscodeResult_Ok));
    return decoder.resultCode();
}

JS_PUBLIC_API(void)
JS::SetBuildIdOp(JSContext* cx, JS::BuildIdOp buildIdOp)
{
    cx->runtime()->buildIdOp = buildIdOp;
}

JS_PUBLIC_API(void)
JS::SetAsmJSCacheOps(JSContext* cx, const JS::AsmJSCacheOps* ops)
{
    cx->runtime()->asmJSCacheOps = *ops;
}

bool
JS::IsWasmModuleObject(HandleObject obj)
{
    JSObject* unwrapped = CheckedUnwrap(obj);
    if (!unwrapped)
        return false;
    return unwrapped->is<WasmModuleObject>();
}

JS_PUBLIC_API(RefPtr<JS::WasmModule>)
JS::GetWasmModule(HandleObject obj)
{
    MOZ_ASSERT(JS::IsWasmModuleObject(obj));
    return &CheckedUnwrap(obj)->as<WasmModuleObject>().module();
}

JS_PUBLIC_API(bool)
JS::CompiledWasmModuleAssumptionsMatch(PRFileDesc* compiled, JS::BuildIdCharVector&& buildId)
{
    return wasm::CompiledModuleAssumptionsMatch(compiled, Move(buildId));
}

JS_PUBLIC_API(RefPtr<JS::WasmModule>)
JS::DeserializeWasmModule(PRFileDesc* bytecode, PRFileDesc* maybeCompiled,
                          JS::BuildIdCharVector&& buildId, UniqueChars file,
                          unsigned line, unsigned column)
{
    return wasm::DeserializeModule(bytecode, maybeCompiled, Move(buildId), Move(file), line, column);
}

char*
JSAutoByteString::encodeLatin1(ExclusiveContext* cx, JSString* str)
{
    mBytes = EncodeLatin1(cx, str);
    return mBytes;
}

JS_PUBLIC_API(void)
JS::SetLargeAllocationFailureCallback(JSContext* cx, JS::LargeAllocationFailureCallback lafc,
                                      void* data)
{
    cx->largeAllocationFailureCallback = lafc;
    cx->largeAllocationFailureCallbackData = data;
}

JS_PUBLIC_API(void)
JS::SetOutOfMemoryCallback(JSContext* cx, OutOfMemoryCallback cb, void* data)
{
    cx->oomCallback = cb;
    cx->oomCallbackData = data;
}

JS::FirstSubsumedFrame::FirstSubsumedFrame(JSContext* cx,
                                           bool ignoreSelfHostedFrames /* = true */)
  : JS::FirstSubsumedFrame(cx, cx->compartment()->principals(), ignoreSelfHostedFrames)
{ }

JS_PUBLIC_API(bool)
JS::CaptureCurrentStack(JSContext* cx, JS::MutableHandleObject stackp,
                        JS::StackCapture&& capture /* = JS::StackCapture(JS::AllFrames()) */)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_RELEASE_ASSERT(cx->compartment());

    JSCompartment* compartment = cx->compartment();
    Rooted<SavedFrame*> frame(cx);
    if (!compartment->savedStacks().saveCurrentStack(cx, &frame, mozilla::Move(capture)))
        return false;
    stackp.set(frame.get());
    return true;
}

JS_PUBLIC_API(bool)
JS::CopyAsyncStack(JSContext* cx, JS::HandleObject asyncStack,
                   JS::HandleString asyncCause, JS::MutableHandleObject stackp,
                   unsigned maxFrameCount)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_RELEASE_ASSERT(cx->compartment());

    js::AssertObjectIsSavedFrameOrWrapper(cx, asyncStack);
    JSCompartment* compartment = cx->compartment();
    Rooted<SavedFrame*> frame(cx);
    if (!compartment->savedStacks().copyAsyncStack(cx, asyncStack, asyncCause,
                                                   &frame, maxFrameCount))
        return false;
    stackp.set(frame.get());
    return true;
}

JS_PUBLIC_API(Zone*)
JS::GetObjectZone(JSObject* obj)
{
    return obj->zone();
}

JS_PUBLIC_API(JS::TraceKind)
JS::GCThingTraceKind(void* thing)
{
    MOZ_ASSERT(thing);
    return static_cast<js::gc::Cell*>(thing)->getTraceKind();
}

JS_PUBLIC_API(void)
js::SetStackFormat(JSContext* cx, js::StackFormat format)
{
    cx->setStackFormat(format);
}

JS_PUBLIC_API(js::StackFormat)
js::GetStackFormat(JSContext* cx)
{
    return cx->stackFormat();
}
