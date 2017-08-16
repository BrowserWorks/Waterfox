/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "vm/AsyncIteration.h"

#include "jsarray.h"
#include "jscompartment.h"

#include "builtin/Promise.h"
#include "vm/GeneratorObject.h"
#include "vm/GlobalObject.h"
#include "vm/Interpreter.h"
#include "vm/SelfHosting.h"

#include "jscntxtinlines.h"
#include "jsobjinlines.h"

#include "vm/NativeObject-inl.h"

using namespace js;
using namespace js::gc;

#define UNWRAPPED_ASYNC_WRAPPED_SLOT 1
#define WRAPPED_ASYNC_UNWRAPPED_SLOT 0

// Async Iteration proposal 2.3.10 Runtime Semantics: EvaluateBody.
static bool
WrappedAsyncGenerator(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    RootedFunction wrapped(cx, &args.callee().as<JSFunction>());
    RootedValue unwrappedVal(cx, wrapped->getExtendedSlot(WRAPPED_ASYNC_UNWRAPPED_SLOT));
    RootedFunction unwrapped(cx, &unwrappedVal.toObject().as<JSFunction>());
    RootedValue thisValue(cx, args.thisv());

    // Step 1.
    RootedValue generatorVal(cx);
    InvokeArgs args2(cx);
    if (!args2.init(cx, argc))
        return false;
    for (size_t i = 0, len = argc; i < len; i++)
        args2[i].set(args[i]);
    if (!Call(cx, unwrappedVal, thisValue, args2, &generatorVal))
        return false;

    // Step 2.
    Rooted<AsyncGeneratorObject*> asyncGenObj(
        cx, AsyncGeneratorObject::create(cx, wrapped, generatorVal));
    if (!asyncGenObj)
        return false;

    // Step 3 (skipped).
    // Done in AsyncGeneratorObject::create and generator.

    // Step 4.
    args.rval().setObject(*asyncGenObj);
    return true;
}

JSObject*
js::WrapAsyncGeneratorWithProto(JSContext* cx, HandleFunction unwrapped, HandleObject proto)
{
    MOZ_ASSERT(unwrapped->isAsync());
    MOZ_ASSERT(proto, "We need an explicit prototype to avoid the default"
                      "%FunctionPrototype% fallback in NewFunctionWithProto().");

    // Create a new function with AsyncGeneratorPrototype, reusing the name and
    // the length of `unwrapped`.

    RootedAtom funName(cx, unwrapped->explicitName());
    uint16_t length;
    if (!JSFunction::getLength(cx, unwrapped, &length))
        return nullptr;

    RootedFunction wrapped(cx, NewFunctionWithProto(cx, WrappedAsyncGenerator, length,
                                                    JSFunction::NATIVE_FUN, nullptr,
                                                    funName, proto,
                                                    AllocKind::FUNCTION_EXTENDED,
                                                    TenuredObject));
    if (!wrapped)
        return nullptr;

    if (unwrapped->hasCompileTimeName())
        wrapped->setCompileTimeName(unwrapped->compileTimeName());

    // Link them to each other to make GetWrappedAsyncGenerator and
    // GetUnwrappedAsyncGenerator work.
    unwrapped->setExtendedSlot(UNWRAPPED_ASYNC_WRAPPED_SLOT, ObjectValue(*wrapped));
    wrapped->setExtendedSlot(WRAPPED_ASYNC_UNWRAPPED_SLOT, ObjectValue(*unwrapped));

    return wrapped;
}

JSObject*
js::WrapAsyncGenerator(JSContext* cx, HandleFunction unwrapped)
{
    RootedObject proto(cx, GlobalObject::getOrCreateAsyncGenerator(cx, cx->global()));
    if (!proto)
        return nullptr;

    return WrapAsyncGeneratorWithProto(cx, unwrapped, proto);
}

bool
js::IsWrappedAsyncGenerator(JSFunction* fun)
{
    return fun->maybeNative() == WrappedAsyncGenerator;
}

JSFunction*
js::GetWrappedAsyncGenerator(JSFunction* unwrapped)
{
    MOZ_ASSERT(unwrapped->isAsync());
    return &unwrapped->getExtendedSlot(UNWRAPPED_ASYNC_WRAPPED_SLOT).toObject().as<JSFunction>();
}

JSFunction*
js::GetUnwrappedAsyncGenerator(JSFunction* wrapped)
{
    MOZ_ASSERT(IsWrappedAsyncGenerator(wrapped));
    JSFunction* unwrapped = &wrapped->getExtendedSlot(WRAPPED_ASYNC_UNWRAPPED_SLOT)
                            .toObject().as<JSFunction>();
    MOZ_ASSERT(unwrapped->isAsync());
    return unwrapped;
}

static MOZ_MUST_USE bool
AsyncGeneratorResume(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                     CompletionKind completionKind, HandleValue argument);

// Async Iteration proposal 5.1.1 Await Fulfilled Functions.
MOZ_MUST_USE bool
js::AsyncGeneratorAwaitedFulfilled(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                                   HandleValue value)
{
    return AsyncGeneratorResume(cx, asyncGenObj, CompletionKind::Normal, value);
}

// Async Iteration proposal 5.1.2 Await Rejected Functions.
MOZ_MUST_USE bool
js::AsyncGeneratorAwaitedRejected(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                                  HandleValue reason)
{
    return AsyncGeneratorResume(cx, asyncGenObj, CompletionKind::Throw, reason);
}

const Class AsyncFromSyncIteratorObject::class_ = {
    "AsyncFromSyncIteratorObject",
    JSCLASS_HAS_RESERVED_SLOTS(AsyncFromSyncIteratorObject::Slots)
};

// Async Iteration proposal 6.1.3.1.
JSObject*
js::CreateAsyncFromSyncIterator(JSContext* cx, HandleObject iter)
{
    // Step 1 (implicit).
    // Done in bytecode emitted by emitAsyncIterator.

    // Steps 2-4.
    return AsyncFromSyncIteratorObject::create(cx, iter);
}

// Async Iteration proposal 6.1.3.1 steps 2-4.
/* static */ JSObject*
AsyncFromSyncIteratorObject::create(JSContext* cx, HandleObject iter)
{
    // Step 2.
    RootedObject proto(cx, GlobalObject::getOrCreateAsyncFromSyncIteratorPrototype(cx,
                                                                                   cx->global()));
    if (!proto)
        return nullptr;

    RootedObject obj(cx, NewNativeObjectWithGivenProto(cx, &class_, proto));
    if (!obj)
        return nullptr;

    Handle<AsyncFromSyncIteratorObject*> asyncIter = obj.as<AsyncFromSyncIteratorObject>();

    // Step 3.
    asyncIter->setIterator(iter);

    // Step 4.
    return asyncIter;
}

// Async Iteration proposal 6.1.3.2.1 %AsyncFromSyncIteratorPrototype%.next.
static bool
AsyncFromSyncIteratorNext(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return AsyncFromSyncIteratorMethod(cx, args, CompletionKind::Normal);
}

// Async Iteration proposal 6.1.3.2.2 %AsyncFromSyncIteratorPrototype%.return.
static bool
AsyncFromSyncIteratorReturn(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return AsyncFromSyncIteratorMethod(cx, args, CompletionKind::Return);
}

// Async Iteration proposal 6.1.3.2.3 %AsyncFromSyncIteratorPrototype%.throw.
static bool
AsyncFromSyncIteratorThrow(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return AsyncFromSyncIteratorMethod(cx, args, CompletionKind::Throw);
}

// Async Iteration proposal 6.4.1.2 AsyncGenerator.prototype.next.
static bool
AsyncGeneratorNext(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Steps 1-3.
    return AsyncGeneratorEnqueue(cx, args.thisv(), CompletionKind::Normal, args.get(0),
                                 args.rval());
}

// Async Iteration proposal 6.4.1.3 AsyncGenerator.prototype.return.
static bool
AsyncGeneratorReturn(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Steps 1-3.
    return AsyncGeneratorEnqueue(cx, args.thisv(), CompletionKind::Return, args.get(0),
                                 args.rval());
}

// Async Iteration proposal 6.4.1.4 AsyncGenerator.prototype.throw.
static bool
AsyncGeneratorThrow(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Steps 1-3.
    return AsyncGeneratorEnqueue(cx, args.thisv(), CompletionKind::Throw, args.get(0),
                                 args.rval());
}

const Class AsyncGeneratorObject::class_ = {
    "AsyncGenerator",
    JSCLASS_HAS_RESERVED_SLOTS(AsyncGeneratorObject::Slots)
};

// ES 2017 draft 9.1.13.
template <typename ProtoGetter>
static JSObject*
OrdinaryCreateFromConstructor(JSContext* cx, HandleFunction fun,
                              ProtoGetter protoGetter, const Class* clasp)
{
    // Step 1 (skipped).

    // Step 2.
    RootedValue protoVal(cx);
    if (!GetProperty(cx, fun, fun, cx->names().prototype, &protoVal))
        return nullptr;

    RootedObject proto(cx, protoVal.isObject() ? &protoVal.toObject() : nullptr);
    if (!proto) {
        proto = protoGetter(cx, cx->global());
        if (!proto)
            return nullptr;
    }

    // Step 3.
    return NewNativeObjectWithGivenProto(cx, clasp, proto);
}

/* static */ AsyncGeneratorObject*
AsyncGeneratorObject::create(JSContext* cx, HandleFunction asyncGen, HandleValue generatorVal)
{
    MOZ_ASSERT(generatorVal.isObject());
    MOZ_ASSERT(generatorVal.toObject().is<GeneratorObject>());

    RootedObject obj(
        cx, OrdinaryCreateFromConstructor(cx, asyncGen,
                                          GlobalObject::getOrCreateAsyncGeneratorPrototype,
                                          &class_));
    if (!obj)
        return nullptr;

    Handle<AsyncGeneratorObject*> asyncGenObj = obj.as<AsyncGeneratorObject>();

    // Async Iteration proposal 6.4.3.2 AsyncGeneratorStart.
    // Step 6.
    asyncGenObj->setGenerator(generatorVal);

    // Step 7.
    asyncGenObj->setSuspendedStart();

    // Step 8.
    asyncGenObj->clearSingleQueueRequest();

    return asyncGenObj;
}

/* static */ MOZ_MUST_USE bool
AsyncGeneratorObject::enqueueRequest(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                                     Handle<AsyncGeneratorRequest*> request)
{
    if (asyncGenObj->isSingleQueue()) {
        if (asyncGenObj->isSingleQueueEmpty()) {
            asyncGenObj->setSingleQueueRequest(request);
            return true;
        }

        RootedArrayObject queue(cx, NewDenseEmptyArray(cx));
        if (!queue)
            return false;

        if (!NewbornArrayPush(cx, queue, ObjectValue(*asyncGenObj->singleQueueRequest())))
            return false;
        if (!NewbornArrayPush(cx, queue, ObjectValue(*request)))
            return false;

        asyncGenObj->setQueue(queue);
        return true;
    }

    RootedArrayObject queue(cx, asyncGenObj->queue());

    FixedInvokeArgs<1> args(cx);
    args[0].setObject(*request);
    args.setThis(ObjectValue(*queue));
    return CallJSNative(cx, array_push, args);
}

/* static */ AsyncGeneratorRequest*
AsyncGeneratorObject::dequeueRequest(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj)
{
    if (asyncGenObj->isSingleQueue()) {
        AsyncGeneratorRequest* request = asyncGenObj->singleQueueRequest();
        asyncGenObj->clearSingleQueueRequest();
        return request;
    }

    RootedArrayObject queue(cx, asyncGenObj->queue());

    FixedInvokeArgs<0> args(cx);
    args.setThis(ObjectValue(*queue));
    if (!CallJSNative(cx, array_shift, args))
        return nullptr;

    return &args.rval().toObject().as<AsyncGeneratorRequest>();
}

/* static */ AsyncGeneratorRequest*
AsyncGeneratorObject::peekRequest(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj)
{
    if (asyncGenObj->isSingleQueue())
        return asyncGenObj->singleQueueRequest();

    RootedArrayObject queue(cx, asyncGenObj->queue());

    RootedValue requestVal(cx);
    if (!GetElement(cx, queue, queue, 0, &requestVal))
        return nullptr;

    return &requestVal.toObject().as<AsyncGeneratorRequest>();
}

const Class AsyncGeneratorRequest::class_ = {
    "AsyncGeneratorRequest",
    JSCLASS_HAS_RESERVED_SLOTS(AsyncGeneratorRequest::Slots)
};

// Async Iteration proposal 6.4.3.1.
/* static */ AsyncGeneratorRequest*
AsyncGeneratorRequest::create(JSContext* cx, CompletionKind completionKind_,
                              HandleValue completionValue_, HandleObject promise_)
{
    RootedObject obj(cx, NewNativeObjectWithGivenProto(cx, &class_, nullptr));
    if (!obj)
        return nullptr;

    Handle<AsyncGeneratorRequest*> request = obj.as<AsyncGeneratorRequest>();
    request->setCompletionKind(completionKind_);
    request->setCompletionValue(completionValue_);
    request->setPromise(promise_);
    return request;
}

// Async Iteration proposal 6.4.3.2 steps 5.d-g.
static MOZ_MUST_USE bool
AsyncGeneratorReturned(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                       HandleValue value)
{
    // Step 5.d.
    asyncGenObj->setCompleted();

    // Step 5.e (done in bytecode).
    // Step 5.f.i (implicit).

    // Step 5.g.
    return AsyncGeneratorResolve(cx, asyncGenObj, value, true);
}

// Async Iteration proposal 6.4.3.2 steps 5.d, f.
static MOZ_MUST_USE bool
AsyncGeneratorThrown(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj)
{
    // Step 5.d.
    asyncGenObj->setCompleted();

    // Not much we can do about uncatchable exceptions, so just bail.
    if (!cx->isExceptionPending())
        return false;

    // Step 5.f.i.
    RootedValue value(cx);
    if (!GetAndClearException(cx, &value))
        return false;

    // Step 5.f.ii.
    return AsyncGeneratorReject(cx, asyncGenObj, value);
}

// Async Iteration proposal 6.4.3.5.
MOZ_MUST_USE bool
js::AsyncGeneratorResumeNext(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj)
{
    // Step 1 (implicit).

    // Steps 2-3.
    MOZ_ASSERT(!asyncGenObj->isExecuting());

    // Steps 4-5.
    if (asyncGenObj->isQueueEmpty())
        return true;

    // Steps 6-7.
    Rooted<AsyncGeneratorRequest*> request(
        cx, AsyncGeneratorObject::peekRequest(cx, asyncGenObj));
    if (!request)
        return false;

    // Step 8.
    CompletionKind completionKind = request->completionKind();

    // Step 9.
    if (completionKind != CompletionKind::Normal) {
        // Step 9.a.
        if (asyncGenObj->isSuspendedStart())
            asyncGenObj->setCompleted();

        // Step 9.b.
        if (asyncGenObj->isCompleted()) {
            // Step 9.b.i.
            RootedValue value(cx, request->completionValue());
            if (completionKind == CompletionKind::Return)
                return AsyncGeneratorResolve(cx, asyncGenObj, value, true);
            // Step 9.b.ii.
            return AsyncGeneratorReject(cx, asyncGenObj, value);
        }
    } else if (asyncGenObj->isCompleted()) {
        // Step 10.
        return AsyncGeneratorResolve(cx, asyncGenObj, UndefinedHandleValue, true);
    }

    // Step 11.
    MOZ_ASSERT(asyncGenObj->isSuspendedStart() || asyncGenObj->isSuspendedYield());

    // Step 15 (reordered).
    asyncGenObj->setExecuting();

    RootedValue argument(cx, request->completionValue());

    // Steps 12-14, 16-20.
    return AsyncGeneratorResume(cx, asyncGenObj, completionKind, argument);
}

// Async Iteration proposal 6.2.1.3 (partially).
// Most steps are done in generator.
static MOZ_MUST_USE bool
AsyncGeneratorYield(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                    HandleValue value)
{
    // Step 5.
    asyncGenObj->setSuspendedYield();

    // Step 8.
    return AsyncGeneratorResolve(cx, asyncGenObj, value, false);
}

// Async Iteration proposal 6.4.3.5 steps 12-14, 16-20.
// Async Iteration proposal 6.2.1.2 step 10.
// Async Iteration proposal 6.4.3.2 step 5.f-g.
// Async Iteration proposal 5.1 steps 2-9.
// Execution context switching is handled in generator.
static MOZ_MUST_USE bool
AsyncGeneratorResume(JSContext* cx, Handle<AsyncGeneratorObject*> asyncGenObj,
                     CompletionKind completionKind, HandleValue argument)
{
    RootedValue generatorVal(cx, asyncGenObj->generatorVal());

    // 6.4.3.5 steps 12-14, 16-20.
    HandlePropertyName funName = completionKind == CompletionKind::Normal
                                 ? cx->names().StarGeneratorNext
                                 : completionKind == CompletionKind::Throw
                                 ? cx->names().StarGeneratorThrow
                                 : cx->names().StarGeneratorReturn;
    FixedInvokeArgs<1> args(cx);
    args[0].set(argument);
    RootedValue result(cx);
    if (!CallSelfHostedFunction(cx, funName, generatorVal, args, &result)) {
        // 6.4.3.2 step 5.d, f.
        return AsyncGeneratorThrown(cx, asyncGenObj);
    }

    if (asyncGenObj->generatorObj()->isAfterAwait())
        return AsyncGeneratorAwait(cx, asyncGenObj, result);

    // The following code corresponds to the following 3 cases:
    //   * yield
    //   * yield*
    //   * return
    // For yield and return, property access is done on an internal result
    // object and it's not observable.
    // For yield*, it's done on a possibly user-provided result object, and
    // it's observable.

    // 2.2.1 yield* steps 6.a.vii, 6.b.ii.7, 6.c.ix.
    RootedObject resultObj(cx, &result.toObject());
    RootedValue value(cx);
    if (!GetProperty(cx, resultObj, resultObj, cx->names().value, &value))
        return false;

    if (asyncGenObj->generatorObj()->isAfterYield())
        return AsyncGeneratorYield(cx, asyncGenObj, value);

    // 6.4.3.2 step 5.d-g.
    return AsyncGeneratorReturned(cx, asyncGenObj, value);
}

static const JSFunctionSpec async_iterator_proto_methods[] = {
    JS_SELF_HOSTED_SYM_FN(asyncIterator, "AsyncIteratorIdentity", 0, 0),
    JS_FS_END
};

static const JSFunctionSpec async_from_sync_iter_methods[] = {
    JS_FN("next", AsyncFromSyncIteratorNext, 1, 0),
    JS_FN("throw", AsyncFromSyncIteratorThrow, 1, 0),
    JS_FN("return", AsyncFromSyncIteratorReturn, 1, 0),
    JS_FS_END
};

static const JSFunctionSpec async_generator_methods[] = {
    JS_FN("next", AsyncGeneratorNext, 1, 0),
    JS_FN("throw", AsyncGeneratorThrow, 1, 0),
    JS_FN("return", AsyncGeneratorReturn, 1, 0),
    JS_FS_END
};

/* static */ MOZ_MUST_USE bool
GlobalObject::initAsyncGenerators(JSContext* cx, Handle<GlobalObject*> global)
{
    if (global->getReservedSlot(ASYNC_ITERATOR_PROTO).isObject())
        return true;

    // Async Iteration proposal 6.1.2 %AsyncIteratorPrototype%.
    RootedObject asyncIterProto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!asyncIterProto)
        return false;
    if (!DefinePropertiesAndFunctions(cx, asyncIterProto, nullptr, async_iterator_proto_methods))
        return false;

    // Async Iteration proposal 6.1.3.2 %AsyncFromSyncIteratorPrototype%.
    RootedObject asyncFromSyncIterProto(
        cx, GlobalObject::createBlankPrototypeInheriting(cx, global, &PlainObject::class_,
                                                         asyncIterProto));
    if (!asyncFromSyncIterProto)
        return false;
    if (!DefinePropertiesAndFunctions(cx, asyncFromSyncIterProto, nullptr,
                                      async_from_sync_iter_methods) ||
        !DefineToStringTag(cx, asyncFromSyncIterProto, cx->names().AsyncFromSyncIterator))
    {
        return false;
    }

    // Async Iteration proposal 6.4.1 %AsyncGeneratorPrototype%.
    RootedObject asyncGenProto(
        cx, GlobalObject::createBlankPrototypeInheriting(cx, global, &PlainObject::class_,
                                                         asyncIterProto));
    if (!asyncGenProto)
        return false;
    if (!DefinePropertiesAndFunctions(cx, asyncGenProto, nullptr, async_generator_methods) ||
        !DefineToStringTag(cx, asyncGenProto, cx->names().AsyncGenerator))
    {
        return false;
    }

    // Async Iteration proposal 6.3.3 %AsyncGenerator%.
    RootedObject asyncGenerator(cx, NewSingletonObjectWithFunctionPrototype(cx, global));
    if (!asyncGenerator)
        return false;
    if (!JSObject::setDelegate(cx, asyncGenerator))
        return false;
    if (!LinkConstructorAndPrototype(cx, asyncGenerator, asyncGenProto, JSPROP_READONLY,
                                     JSPROP_READONLY) ||
        !DefineToStringTag(cx, asyncGenerator, cx->names().AsyncGeneratorFunction))
    {
        return false;
    }

    RootedValue function(cx, global->getConstructor(JSProto_Function));
    if (!function.toObjectOrNull())
        return false;
    RootedObject proto(cx, &function.toObject());
    RootedAtom name(cx, cx->names().AsyncGeneratorFunction);

    // Async Iteration proposal 6.3.2 %AsyncGeneratorFunction%.
    RootedObject asyncGenFunction(
        cx, NewFunctionWithProto(cx, AsyncGeneratorConstructor, 1, JSFunction::NATIVE_CTOR,
                                 nullptr, name, proto, gc::AllocKind::FUNCTION, SingletonObject));
    if (!asyncGenFunction)
        return false;
    if (!LinkConstructorAndPrototype(cx, asyncGenFunction, asyncGenerator,
                                     JSPROP_PERMANENT | JSPROP_READONLY, JSPROP_READONLY))
    {
        return false;
    }

    global->setReservedSlot(ASYNC_ITERATOR_PROTO, ObjectValue(*asyncIterProto));
    global->setReservedSlot(ASYNC_FROM_SYNC_ITERATOR_PROTO, ObjectValue(*asyncFromSyncIterProto));
    global->setReservedSlot(ASYNC_GENERATOR, ObjectValue(*asyncGenerator));
    global->setReservedSlot(ASYNC_GENERATOR_FUNCTION, ObjectValue(*asyncGenFunction));
    global->setReservedSlot(ASYNC_GENERATOR_PROTO, ObjectValue(*asyncGenProto));
    return true;
}
