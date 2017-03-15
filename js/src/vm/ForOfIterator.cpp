/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jsapi.h"
#include "jscntxt.h"
#include "jscompartment.h"
#include "jsobj.h"

#include "vm/Interpreter.h"
#include "vm/PIC.h"

#include "jsobjinlines.h"

using namespace js;
using JS::ForOfIterator;

bool
ForOfIterator::init(HandleValue iterable, NonIterableBehavior nonIterableBehavior)
{
    JSContext* cx = cx_;
    RootedObject iterableObj(cx, ToObject(cx, iterable));
    if (!iterableObj)
        return false;

    MOZ_ASSERT(index == NOT_ARRAY);

    // Check the PIC first for a match.
    if (iterableObj->is<ArrayObject>()) {
        ForOfPIC::Chain* stubChain = ForOfPIC::getOrCreate(cx);
        if (!stubChain)
            return false;

        bool optimized;
        if (!stubChain->tryOptimizeArray(cx, iterableObj.as<ArrayObject>(), &optimized))
            return false;

        if (optimized) {
            // Got optimized stub.  Array is optimizable.
            index = 0;
            iterator = iterableObj;
            return true;
        }
    }

    MOZ_ASSERT(index == NOT_ARRAY);

    RootedValue callee(cx);
    RootedId iteratorId(cx, SYMBOL_TO_JSID(cx->wellKnownSymbols().iterator));
    if (!GetProperty(cx, iterableObj, iterableObj, iteratorId, &callee))
        return false;

    // If obj[@@iterator] is undefined and we were asked to allow non-iterables,
    // bail out now without setting iterator.  This will make valueIsIterable(),
    // which our caller should check, return false.
    if (nonIterableBehavior == AllowNonIterable && callee.isUndefined())
        return true;

    // Throw if obj[@@iterator] isn't callable.
    // js::Invoke is about to check for this kind of error anyway, but it would
    // throw an inscrutable error message about |method| rather than this nice
    // one about |obj|.
    if (!callee.isObject() || !callee.toObject().isCallable()) {
        UniqueChars bytes = DecompileValueGenerator(cx, JSDVG_SEARCH_STACK, iterable, nullptr);
        if (!bytes)
            return false;
        JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_NOT_ITERABLE, bytes.get());
        return false;
    }

    RootedValue res(cx);
    if (!js::Call(cx, callee, iterable, &res))
        return false;

    if (!res.isObject())
        return ThrowCheckIsObject(cx, CheckIsObjectKind::GetIterator);

    iterator = &res.toObject();
    return true;
}

inline bool
ForOfIterator::nextFromOptimizedArray(MutableHandleValue vp, bool* done)
{
    MOZ_ASSERT(index != NOT_ARRAY);

    if (!CheckForInterrupt(cx_))
        return false;

    ArrayObject* arr = &iterator->as<ArrayObject>();

    if (index >= arr->length()) {
        vp.setUndefined();
        *done = true;
        return true;
    }
    *done = false;

    // Try to get array element via direct access.
    if (index < arr->getDenseInitializedLength()) {
        vp.set(arr->getDenseElement(index));
        if (!vp.isMagic(JS_ELEMENTS_HOLE)) {
            ++index;
            return true;
        }
    }

    return GetElement(cx_, iterator, iterator, index++, vp);
}

bool
ForOfIterator::next(MutableHandleValue vp, bool* done)
{
    MOZ_ASSERT(iterator);
    if (index != NOT_ARRAY) {
        ForOfPIC::Chain* stubChain = ForOfPIC::getOrCreate(cx_);
        if (!stubChain)
            return false;

        if (stubChain->isArrayNextStillSane())
            return nextFromOptimizedArray(vp, done);

        // ArrayIterator.prototype.next changed, materialize a proper
        // ArrayIterator instance and fall through to slowpath case.
        if (!materializeArrayIterator())
            return false;
    }

    RootedValue v(cx_);
    if (!GetProperty(cx_, iterator, iterator, cx_->names().next, &v))
        return false;

    if (!js::Call(cx_, v, iterator, &v))
        return false;

    if (!v.isObject())
        return ThrowCheckIsObject(cx_, CheckIsObjectKind::IteratorNext);

    RootedObject resultObj(cx_, &v.toObject());
    if (!GetProperty(cx_, resultObj, resultObj, cx_->names().done, &v))
        return false;

    *done = ToBoolean(v);
    if (*done) {
        vp.setUndefined();
        return true;
    }

    return GetProperty(cx_, resultObj, resultObj, cx_->names().value, vp);
}

bool
ForOfIterator::materializeArrayIterator()
{
    MOZ_ASSERT(index != NOT_ARRAY);

    HandlePropertyName name = cx_->names().ArrayValuesAt;
    RootedValue val(cx_);
    if (!GlobalObject::getSelfHostedFunction(cx_, cx_->global(), name, name, 1, &val))
        return false;

    RootedValue indexOrRval(cx_, Int32Value(index));
    if (!js::Call(cx_, val, iterator, indexOrRval, &indexOrRval))
        return false;

    index = NOT_ARRAY;
    // Result of call to ArrayValuesAt must be an object.
    iterator = &indexOrRval.toObject();
    return true;
}
