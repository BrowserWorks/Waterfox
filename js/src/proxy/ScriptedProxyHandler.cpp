/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "proxy/ScriptedProxyHandler.h"

#include "jsapi.h"

#include "vm/Interpreter.h" // For InstanceOfOperator

#include "jsobjinlines.h"
#include "vm/NativeObject-inl.h"

using namespace js;

using JS::IsArrayAnswer;
using mozilla::ArrayLength;

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93
// 9.1.6.2 IsCompatiblePropertyDescriptor.  BUT that method just calls
// 9.1.6.3 ValidateAndApplyPropertyDescriptor with two additional constant
// arguments.  Therefore step numbering is from the latter method, and
// resulting dead code has been removed.
static bool
IsCompatiblePropertyDescriptor(JSContext* cx, bool extensible, Handle<PropertyDescriptor> desc,
                               Handle<PropertyDescriptor> current, bool* bp)
{
    // Step 2.
    if (!current.object()) {
        // Step 2a-b,e.  As |O| is always undefined, steps 2c-d fall away.
        *bp = extensible;
        return true;
    }

    // Step 3.
    if (!desc.hasValue() && !desc.hasWritable() &&
        !desc.hasGetterObject() && !desc.hasSetterObject() &&
        !desc.hasEnumerable() && !desc.hasConfigurable())
    {
        *bp = true;
        return true;
    }

    // Step 4.
    if ((!desc.hasWritable() ||
         (current.hasWritable() && desc.writable() == current.writable())) &&
        (!desc.hasGetterObject() || desc.getter() == current.getter()) &&
        (!desc.hasSetterObject() || desc.setter() == current.setter()) &&
        (!desc.hasEnumerable() || desc.enumerable() == current.enumerable()) &&
        (!desc.hasConfigurable() || desc.configurable() == current.configurable()))
    {
        if (!desc.hasValue()) {
            *bp = true;
            return true;
        }
        bool same = false;
        if (!SameValue(cx, desc.value(), current.value(), &same))
            return false;
        if (same) {
            *bp = true;
            return true;
        }
    }

    // Step 5.
    if (!current.configurable()) {
        // Step 5a.
        if (desc.hasConfigurable() && desc.configurable()) {
            *bp = false;
            return true;
        }

        // Step 5b.
        if (desc.hasEnumerable() && desc.enumerable() != current.enumerable()) {
            *bp = false;
            return true;
        }
    }

    // Step 6.
    if (desc.isGenericDescriptor()) {
        *bp = true;
        return true;
    }

    // Step 7.
    if (current.isDataDescriptor() != desc.isDataDescriptor()) {
        // Steps 7a, 11.  As |O| is always undefined, steps 2b-c fall away.
        *bp = current.configurable();
        return true;
    }

    // Step 8.
    if (current.isDataDescriptor()) {
        MOZ_ASSERT(desc.isDataDescriptor()); // by step 7
        if (!current.configurable() && !current.writable()) {
            if (desc.hasWritable() && desc.writable()) {
                *bp = false;
                return true;
            }

            if (desc.hasValue()) {
                bool same;
                if (!SameValue(cx, desc.value(), current.value(), &same))
                    return false;
                if (!same) {
                    *bp = false;
                    return true;
                }
            }
        }

        *bp = true;
        return true;
    }

    // Step 9.
    MOZ_ASSERT(current.isAccessorDescriptor()); // by step 8
    MOZ_ASSERT(desc.isAccessorDescriptor()); // by step 7
    *bp = (current.configurable() ||
           ((!desc.hasSetterObject() || desc.setter() == current.setter()) &&
            (!desc.hasGetterObject() || desc.getter() == current.getter())));
    return true;
}

// Get the [[ProxyHandler]] of a scripted proxy.
/* static */ JSObject*
ScriptedProxyHandler::handlerObject(const JSObject* proxy)
{
    MOZ_ASSERT(proxy->as<ProxyObject>().handler() == &ScriptedProxyHandler::singleton);
    return proxy->as<ProxyObject>().extra(ScriptedProxyHandler::HANDLER_EXTRA).toObjectOrNull();
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 7.3.9 GetMethod,
// reimplemented for proxy handler trap-getting to produce better error
// messages.
static bool
GetProxyTrap(JSContext* cx, HandleObject handler, HandlePropertyName name, MutableHandleValue func)
{
    // Steps 2, 5.
    if (!GetProperty(cx, handler, handler, name, func))
        return false;

    // Step 3.
    if (func.isUndefined())
        return true;

    if (func.isNull()) {
        func.setUndefined();
        return true;
    }

    // Step 4.
    if (!IsCallable(func)) {
        JSAutoByteString bytes(cx, name);
        if (!bytes)
            return false;

        JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_BAD_TRAP, bytes.ptr());
        return false;
    }

    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.1 Proxy.[[GetPrototypeOf]].
bool
ScriptedProxyHandler::getPrototype(JSContext* cx, HandleObject proxy,
                                   MutableHandleObject protop) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().getPrototypeOf, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined())
        return GetPrototype(cx, target, protop);

    // Step 7.
    RootedValue handlerProto(cx);
    {
        FixedInvokeArgs<1> args(cx);

        args[0].setObject(*target);

        handlerProto.setObject(*handler);

        if (!js::Call(cx, trap, handlerProto, args, &handlerProto))
            return false;
    }

    // Step 8.
    if (!handlerProto.isObjectOrNull()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                                  JSMSG_BAD_GETPROTOTYPEOF_TRAP_RETURN);
        return false;
    }

    // Step 9.
    bool extensibleTarget;
    if (!IsExtensible(cx, target, &extensibleTarget))
        return false;

    // Step 10.
    if (extensibleTarget) {
        protop.set(handlerProto.toObjectOrNull());
        return true;
    }

    // Step 11.
    RootedObject targetProto(cx);
    if (!GetPrototype(cx, target, &targetProto))
        return false;

    // Step 12.
    if (handlerProto.toObjectOrNull() != targetProto) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                                  JSMSG_INCONSISTENT_GETPROTOTYPEOF_TRAP);
        return false;
    }

    // Step 13.
    protop.set(handlerProto.toObjectOrNull());
    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.2 Proxy.[[SetPrototypeOf]].
bool
ScriptedProxyHandler::setPrototype(JSContext* cx, HandleObject proxy, HandleObject proto,
                                   ObjectOpResult& result) const
{
    // Steps 1-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().setPrototypeOf, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return SetPrototype(cx, target, proto, result);

    // Step 8.
    bool booleanTrapResult;
    {
        FixedInvokeArgs<2> args(cx);

        args[0].setObject(*target);
        args[1].setObjectOrNull(proto);

        RootedValue hval(cx, ObjectValue(*handler));
        if (!js::Call(cx, trap, hval, args, &hval))
            return false;

        booleanTrapResult = ToBoolean(hval);
    }

    // Step 9.
    if (!booleanTrapResult)
        return result.fail(JSMSG_PROXY_SETPROTOTYPEOF_RETURNED_FALSE);

    // Step 10.
    bool extensibleTarget;
    if (!IsExtensible(cx, target, &extensibleTarget))
        return false;

    // Step 11.
    if (extensibleTarget)
        return result.succeed();

    // Step 12.
    RootedObject targetProto(cx);
    if (!GetPrototype(cx, target, &targetProto))
        return false;

    // Step 13.
    if (proto != targetProto) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                                  JSMSG_INCONSISTENT_SETPROTOTYPEOF_TRAP);
        return false;
    }

    // Step 14.
    return result.succeed();
}

bool
ScriptedProxyHandler::getPrototypeIfOrdinary(JSContext* cx, HandleObject proxy, bool* isOrdinary,
                                             MutableHandleObject protop) const
{
    *isOrdinary = false;
    return true;
}

// Not yet part of ES6, but hopefully to be standards-tracked -- and needed to
// handle revoked proxies in any event.
bool
ScriptedProxyHandler::setImmutablePrototype(JSContext* cx, HandleObject proxy,
                                            bool* succeeded) const
{
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    if (!target) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    return SetImmutablePrototype(cx, target, succeeded);
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.4 Proxy.[[PreventExtensions]]()
bool
ScriptedProxyHandler::preventExtensions(JSContext* cx, HandleObject proxy,
                                        ObjectOpResult& result) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().preventExtensions, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined())
        return PreventExtensions(cx, target, result);

    // Step 7.
    bool booleanTrapResult;
    {
        RootedValue arg(cx, ObjectValue(*target));
        RootedValue trapResult(cx);
        if (!Call(cx, trap, handler, arg, &trapResult))
            return false;

        booleanTrapResult = ToBoolean(trapResult);
    }

    // Step 8.
    if (booleanTrapResult) {
        // Step 8a.
        bool targetIsExtensible;
        if (!IsExtensible(cx, target, &targetIsExtensible))
            return false;

        if (targetIsExtensible) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                                      JSMSG_CANT_REPORT_AS_NON_EXTENSIBLE);
            return false;
        }

        // Step 9.
        return result.succeed();
    }

    // Also step 9.
    return result.fail(JSMSG_PROXY_PREVENTEXTENSIONS_RETURNED_FALSE);
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.3 Proxy.[[IsExtensible]]()
bool
ScriptedProxyHandler::isExtensible(JSContext* cx, HandleObject proxy, bool* extensible) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().isExtensible, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined())
        return IsExtensible(cx, target, extensible);

    // Step 7.
    bool booleanTrapResult;
    {
        RootedValue arg(cx, ObjectValue(*target));
        RootedValue trapResult(cx);
        if (!Call(cx, trap, handler, arg, &trapResult))
            return false;

        booleanTrapResult = ToBoolean(trapResult);
    }

    // Steps 8.
    bool targetResult;
    if (!IsExtensible(cx, target, &targetResult))
        return false;

    // Step 9.
    if (targetResult != booleanTrapResult) {
       JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_EXTENSIBILITY);
       return false;
    }

    // Step 10.
    *extensible = booleanTrapResult;
    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.5 Proxy.[[GetOwnProperty]](P)
bool
ScriptedProxyHandler::getOwnPropertyDescriptor(JSContext* cx, HandleObject proxy, HandleId id,
                                               MutableHandle<PropertyDescriptor> desc) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().getOwnPropertyDescriptor, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return GetOwnPropertyDescriptor(cx, target, id, desc);

    // Step 8.
    RootedValue propKey(cx);
    if (!IdToStringOrSymbol(cx, id, &propKey))
        return false;

    RootedValue trapResult(cx);
    RootedValue targetVal(cx, ObjectValue(*target));
    if (!Call(cx, trap, handler, targetVal, propKey, &trapResult))
        return false;

    // Step 9.
    if (!trapResult.isUndefined() && !trapResult.isObject()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_GETOWN_OBJORUNDEF);
        return false;
    }

    // Step 10.
    Rooted<PropertyDescriptor> targetDesc(cx);
    if (!GetOwnPropertyDescriptor(cx, target, id, &targetDesc))
        return false;

    // Step 11.
    if (trapResult.isUndefined()) {
        // Step 11a.
        if (!targetDesc.object()) {
            desc.object().set(nullptr);
            return true;
        }

        // Step 11b.
        if (!targetDesc.configurable()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_NC_AS_NE);
            return false;
        }

        // Steps 11c-d.
        bool extensibleTarget;
        if (!IsExtensible(cx, target, &extensibleTarget))
            return false;

        // Step 11e.
        if (!extensibleTarget) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_E_AS_NE);
            return false;
        }

        // Step 11f.
        desc.object().set(nullptr);
        return true;
    }

    // Step 12.
    bool extensibleTarget;
    if (!IsExtensible(cx, target, &extensibleTarget))
        return false;

    // Step 13.
    Rooted<PropertyDescriptor> resultDesc(cx);
    if (!ToPropertyDescriptor(cx, trapResult, true, &resultDesc))
        return false;

    // Step 14.
    CompletePropertyDescriptor(&resultDesc);

    // Step 15.
    bool valid;
    if (!IsCompatiblePropertyDescriptor(cx, extensibleTarget, resultDesc, targetDesc, &valid))
        return false;

    // Step 16.
    if (!valid) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_INVALID);
        return false;
    }

    // Step 17.
    if (!resultDesc.configurable()) {
        if (!targetDesc.object()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_NE_AS_NC);
            return false;
        }

        if (targetDesc.configurable()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_C_AS_NC);
            return false;
        }
    }

    // Step 18.
    desc.set(resultDesc);
    desc.object().set(proxy);
    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.6 Proxy.[[DefineOwnProperty]](P, Desc)
bool
ScriptedProxyHandler::defineProperty(JSContext* cx, HandleObject proxy, HandleId id,
                                     Handle<PropertyDescriptor> desc, ObjectOpResult& result) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().defineProperty, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return DefineProperty(cx, target, id, desc, result);

    // Step 8.
    RootedValue descObj(cx);
    if (!FromPropertyDescriptorToObject(cx, desc, &descObj))
        return false;

    // Step 9.
    RootedValue propKey(cx);
    if (!IdToStringOrSymbol(cx, id, &propKey))
        return false;

    RootedValue trapResult(cx);
    {
        FixedInvokeArgs<3> args(cx);

        args[0].setObject(*target);
        args[1].set(propKey);
        args[2].set(descObj);

        RootedValue thisv(cx, ObjectValue(*handler));
        if (!Call(cx, trap, thisv, args, &trapResult))
            return false;
    }

    // Step 10.
    if (!ToBoolean(trapResult))
        return result.fail(JSMSG_PROXY_DEFINE_RETURNED_FALSE);

    // Step 11.
    Rooted<PropertyDescriptor> targetDesc(cx);
    if (!GetOwnPropertyDescriptor(cx, target, id, &targetDesc))
        return false;

    // Step 12.
    bool extensibleTarget;
    if (!IsExtensible(cx, target, &extensibleTarget))
        return false;

    // Steps 13-14.
    bool settingConfigFalse = desc.hasConfigurable() && !desc.configurable();

    // Steps 15-16.
    if (!targetDesc.object()) {
        // Step 15a.
        if (!extensibleTarget) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_DEFINE_NEW);
            return false;
        }

        // Step 15b.
        if (settingConfigFalse) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_DEFINE_NE_AS_NC);
            return false;
        }
    } else {
        // Steps 16a-b.
        bool valid;
        if (!IsCompatiblePropertyDescriptor(cx, extensibleTarget, desc, targetDesc, &valid))
            return false;

        if (!valid || (settingConfigFalse && targetDesc.configurable())) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_DEFINE_INVALID);
            return false;
        }
    }

    // Step 17.
    return result.succeed();
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93
// 7.3.17 CreateListFromArrayLike with elementTypes fixed to symbol/string.
static bool
CreateFilteredListFromArrayLike(JSContext* cx, HandleValue v, AutoIdVector& props)
{
    // Step 2.
    RootedObject obj(cx, NonNullObject(cx, v));
    if (!obj)
        return false;

    // Step 3.
    uint32_t len;
    if (!GetLengthProperty(cx, obj, &len))
        return false;

    // Steps 4-6.
    RootedValue next(cx);
    RootedId id(cx);
    uint32_t index = 0;
    while (index < len) {
        // Steps 6a-b.
        if (!GetElement(cx, obj, obj, index, &next))
            return false;

        // Step 6c.
        if (!next.isString() && !next.isSymbol()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_ONWKEYS_STR_SYM);
            return false;
        }

        if (!ValueToId<CanGC>(cx, next, &id))
            return false;

        // Step 6d.
        if (!props.append(id))
            return false;

        // Step 6e.
        index++;
    }

    // Step 7.
    return true;
}


// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.11 Proxy.[[OwnPropertyKeys]]()
bool
ScriptedProxyHandler::ownPropertyKeys(JSContext* cx, HandleObject proxy, AutoIdVector& props) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().ownKeys, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined())
        return GetPropertyKeys(cx, target, JSITER_OWNONLY | JSITER_HIDDEN | JSITER_SYMBOLS, &props);

    // Step 7.
    RootedValue trapResultArray(cx);
    RootedValue targetVal(cx, ObjectValue(*target));
    if (!Call(cx, trap, handler, targetVal, &trapResultArray))
        return false;

    // Step 8.
    AutoIdVector trapResult(cx);
    if (!CreateFilteredListFromArrayLike(cx, trapResultArray, trapResult))
        return false;

    // Step 9.
    bool extensibleTarget;
    if (!IsExtensible(cx, target, &extensibleTarget))
        return false;

    // Steps 10-11.
    AutoIdVector targetKeys(cx);
    if (!GetPropertyKeys(cx, target, JSITER_OWNONLY | JSITER_HIDDEN | JSITER_SYMBOLS, &targetKeys))
        return false;

    // Steps 12-13.
    AutoIdVector targetConfigurableKeys(cx);
    AutoIdVector targetNonconfigurableKeys(cx);

    // Step 14.
    Rooted<PropertyDescriptor> desc(cx);
    for (size_t i = 0; i < targetKeys.length(); ++i) {
        // Step 14a.
        if (!GetOwnPropertyDescriptor(cx, target, targetKeys[i], &desc))
            return false;

        // Steps 14b-c.
        if (desc.object() && !desc.configurable()) {
            if (!targetNonconfigurableKeys.append(targetKeys[i]))
                return false;
        } else {
            if (!targetConfigurableKeys.append(targetKeys[i]))
                return false;
        }
    }

    // Step 15.
    if (extensibleTarget && targetNonconfigurableKeys.empty())
        return props.appendAll(trapResult);

    // Step 16.
    // The algorithm below always removes all occurences of the same key
    // at once, so we can use a set here.
    Rooted<GCHashSet<jsid>> uncheckedResultKeys(cx, GCHashSet<jsid>(cx));
    if (!uncheckedResultKeys.init(trapResult.length()))
        return false;

    for (size_t i = 0, len = trapResult.length(); i < len; i++) {
        MOZ_ASSERT(!JSID_IS_VOID(trapResult[i]));

        if (!uncheckedResultKeys.put(trapResult[i]))
            return false;
    }

    // Step 17.
    for (size_t i = 0; i < targetNonconfigurableKeys.length(); ++i) {
        MOZ_ASSERT(!JSID_IS_VOID(targetNonconfigurableKeys[i]));

        auto ptr = uncheckedResultKeys.lookup(targetNonconfigurableKeys[i]);

        // Step 17a.
        if (!ptr) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_SKIP_NC);
            return false;
        }

        // Step 17b.
        uncheckedResultKeys.remove(ptr);
    }

    // Step 18.
    if (extensibleTarget)
        return props.appendAll(trapResult);

    // Step 19.
    for (size_t i = 0; i < targetConfigurableKeys.length(); ++i) {
        MOZ_ASSERT(!JSID_IS_VOID(targetConfigurableKeys[i]));

        auto ptr = uncheckedResultKeys.lookup(targetConfigurableKeys[i]);

        // Step 19a.
        if (!ptr) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_E_AS_NE);
            return false;
        }

        // Step 19b.
        uncheckedResultKeys.remove(ptr);
    }

    // Step 20.
    if (!uncheckedResultKeys.empty()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_NEW);
        return false;
    }

    // Step 21.
    return props.appendAll(trapResult);
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.10 Proxy.[[Delete]](P)
bool
ScriptedProxyHandler::delete_(JSContext* cx, HandleObject proxy, HandleId id,
                              ObjectOpResult& result) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().deleteProperty, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return DeleteProperty(cx, target, id, result);

    // Step 8.
    bool booleanTrapResult;
    {
        RootedValue value(cx);
        if (!IdToStringOrSymbol(cx, id, &value))
            return false;

        RootedValue targetVal(cx, ObjectValue(*target));
        RootedValue trapResult(cx);
        if (!Call(cx, trap, handler, targetVal, value, &trapResult))
            return false;

        booleanTrapResult = ToBoolean(trapResult);
    }

    // Step 9.
    if (!booleanTrapResult)
        return result.fail(JSMSG_PROXY_DELETE_RETURNED_FALSE);

    // Step 10.
    Rooted<PropertyDescriptor> desc(cx);
    if (!GetOwnPropertyDescriptor(cx, target, id, &desc))
        return false;

    // Step 12.
    if (desc.object() && !desc.configurable()) {
        RootedValue v(cx, IdToValue(id));
        ReportValueError(cx, JSMSG_CANT_DELETE, JSDVG_IGNORE_STACK, v, nullptr);
        return false;
    }

    // Steps 11,13.
    return result.succeed();
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.7 Proxy.[[HasProperty]](P)
bool
ScriptedProxyHandler::has(JSContext* cx, HandleObject proxy, HandleId id, bool* bp) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().has, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return HasProperty(cx, target, id, bp);

    // Step 8.
    RootedValue value(cx);
    if (!IdToStringOrSymbol(cx, id, &value))
        return false;

    RootedValue trapResult(cx);
    RootedValue targetVal(cx, ObjectValue(*target));
    if (!Call(cx, trap, handler, targetVal, value, &trapResult))
        return false;

    bool booleanTrapResult = ToBoolean(trapResult);

    // Step 9.
    if (!booleanTrapResult) {
        // Step 9a.
        Rooted<PropertyDescriptor> desc(cx);
        if (!GetOwnPropertyDescriptor(cx, target, id, &desc))
            return false;

        // Step 9b.
        if (desc.object()) {
            // Step 9b(i).
            if (!desc.configurable()) {
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_NC_AS_NE);
                return false;
            }

            // Step 9b(ii).
            bool extensible;
            if (!IsExtensible(cx, target, &extensible))
                return false;

            // Step 9b(iii).
            if (!extensible) {
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_REPORT_E_AS_NE);
                return false;
            }
        }
    }

    // Step 10.
    *bp = booleanTrapResult;
    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.8 Proxy.[[GetP]](P, Receiver)
bool
ScriptedProxyHandler::get(JSContext* cx, HandleObject proxy, HandleValue receiver, HandleId id,
                          MutableHandleValue vp) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Steps 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().get, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return GetProperty(cx, target, receiver, id, vp);

    // Step 8.
    RootedValue value(cx);
    if (!IdToStringOrSymbol(cx, id, &value))
        return false;

    RootedValue trapResult(cx);
    {
        FixedInvokeArgs<3> args(cx);

        args[0].setObject(*target);
        args[1].set(value);
        args[2].set(receiver);

        RootedValue thisv(cx, ObjectValue(*handler));
        if (!Call(cx, trap, thisv, args, &trapResult))
            return false;
    }

    // Step 9.
    Rooted<PropertyDescriptor> desc(cx);
    if (!GetOwnPropertyDescriptor(cx, target, id, &desc))
        return false;

    // Step 10.
    if (desc.object()) {
        // Step 10a.
        if (desc.isDataDescriptor() && !desc.configurable() && !desc.writable()) {
            bool same;
            if (!SameValue(cx, trapResult, desc.value(), &same))
                return false;
            if (!same) {
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_MUST_REPORT_SAME_VALUE);
                return false;
            }
        }

        // Step 10b.
        if (desc.isAccessorDescriptor() && !desc.configurable() && desc.getterObject() == nullptr) {
            if (!trapResult.isUndefined()) {
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_MUST_REPORT_UNDEFINED);
                return false;
            }
        }
    }

    // Step 11.
    vp.set(trapResult);
    return true;
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.9 Proxy.[[Set]](P, V, Receiver)
bool
ScriptedProxyHandler::set(JSContext* cx, HandleObject proxy, HandleId id, HandleValue v,
                          HandleValue receiver, ObjectOpResult& result) const
{
    // Steps 2-4.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 5.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);

    // Step 6.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().set, &trap))
        return false;

    // Step 7.
    if (trap.isUndefined())
        return SetProperty(cx, target, id, v, receiver, result);

    // Step 8.
    RootedValue value(cx);
    if (!IdToStringOrSymbol(cx, id, &value))
        return false;

    RootedValue trapResult(cx);
    {
        FixedInvokeArgs<4> args(cx);

        args[0].setObject(*target);
        args[1].set(value);
        args[2].set(v);
        args[3].set(receiver);

        RootedValue thisv(cx, ObjectValue(*handler));
        if (!Call(cx, trap, thisv, args, &trapResult))
            return false;
    }

    // Step 9.
    if (!ToBoolean(trapResult))
        return result.fail(JSMSG_PROXY_SET_RETURNED_FALSE);

    // Step 10.
    Rooted<PropertyDescriptor> desc(cx);
    if (!GetOwnPropertyDescriptor(cx, target, id, &desc))
        return false;

    // Step 11.
    if (desc.object()) {
        // Step 11a.
        if (desc.isDataDescriptor() && !desc.configurable() && !desc.writable()) {
            bool same;
            if (!SameValue(cx, v, desc.value(), &same))
                return false;
            if (!same) {
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_SET_NW_NC);
                return false;
            }
        }

        // Step 11b.
        if (desc.isAccessorDescriptor() && !desc.configurable() && desc.setterObject() == nullptr) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_SET_WO_SETTER);
            return false;
        }
    }

    // Step 12.
    return result.succeed();
}

// ES7 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.13 Proxy.[[Call]]
bool
ScriptedProxyHandler::call(JSContext* cx, HandleObject proxy, const CallArgs& args) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);
    MOZ_ASSERT(target->isCallable());

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().apply, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined()) {
        InvokeArgs iargs(cx);
        if (!FillArgumentsFromArraylike(cx, iargs, args))
            return false;

        RootedValue fval(cx, ObjectValue(*target));
        return js::Call(cx, fval, args.thisv(), iargs, args.rval());
    }

    // Step 7.
    RootedObject argArray(cx, NewDenseCopiedArray(cx, args.length(), args.array()));
    if (!argArray)
        return false;

    // Step 8.
    FixedInvokeArgs<3> iargs(cx);

    iargs[0].setObject(*target);
    iargs[1].set(args.thisv());
    iargs[2].setObject(*argArray);

    RootedValue thisv(cx, ObjectValue(*handler));
    return js::Call(cx, trap, thisv, iargs, args.rval());
}

// ES7 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.14 Proxy.[[Construct]]
bool
ScriptedProxyHandler::construct(JSContext* cx, HandleObject proxy, const CallArgs& args) const
{
    // Steps 1-3.
    RootedObject handler(cx, ScriptedProxyHandler::handlerObject(proxy));
    if (!handler) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_REVOKED);
        return false;
    }

    // Step 4.
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    MOZ_ASSERT(target);
    MOZ_ASSERT(target->isConstructor());

    // Step 5.
    RootedValue trap(cx);
    if (!GetProxyTrap(cx, handler, cx->names().construct, &trap))
        return false;

    // Step 6.
    if (trap.isUndefined()) {
        ConstructArgs cargs(cx);
        if (!FillArgumentsFromArraylike(cx, cargs, args))
            return false;

        RootedValue targetv(cx, ObjectValue(*target));
        RootedObject obj(cx);
        if (!Construct(cx, targetv, cargs, args.newTarget(), &obj))
            return false;

        args.rval().setObject(*obj);
        return true;
    }

    // Step 7.
    RootedObject argArray(cx, NewDenseCopiedArray(cx, args.length(), args.array()));
    if (!argArray)
        return false;

    // Steps 8, 10.
    {
        FixedInvokeArgs<3> iargs(cx);

        iargs[0].setObject(*target);
        iargs[1].setObject(*argArray);
        iargs[2].set(args.newTarget());

        RootedValue thisv(cx, ObjectValue(*handler));
        if (!Call(cx, trap, thisv, iargs, args.rval()))
            return false;
    }

    // Step 9.
    if (!args.rval().isObject()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_CONSTRUCT_OBJECT);
        return false;
    }

    return true;
}

bool
ScriptedProxyHandler::nativeCall(JSContext* cx, IsAcceptableThis test, NativeImpl impl,
                                 const CallArgs& args) const
{
    ReportIncompatible(cx, args);
    return false;
}

bool
ScriptedProxyHandler::hasInstance(JSContext* cx, HandleObject proxy, MutableHandleValue v,
                                  bool* bp) const
{
    return InstanceOfOperator(cx, proxy, v, bp);
}

bool
ScriptedProxyHandler::getBuiltinClass(JSContext* cx, HandleObject proxy,
                                      ESClass* cls) const
{
    *cls = ESClass::Other;
    return true;
}

bool
ScriptedProxyHandler::isArray(JSContext* cx, HandleObject proxy, IsArrayAnswer* answer) const
{
    RootedObject target(cx, proxy->as<ProxyObject>().target());
    if (target)
        return JS::IsArray(cx, target, answer);

    *answer = IsArrayAnswer::RevokedProxy;
    return true;
}

const char*
ScriptedProxyHandler::className(JSContext* cx, HandleObject proxy) const
{
    // Right now the caller is not prepared to handle failures.
    return BaseProxyHandler::className(cx, proxy);
}

JSString*
ScriptedProxyHandler::fun_toString(JSContext* cx, HandleObject proxy, unsigned indent) const
{
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INCOMPATIBLE_PROTO,
                              js_Function_str, js_toString_str, "object");
    return nullptr;
}

bool
ScriptedProxyHandler::regexp_toShared(JSContext* cx, HandleObject proxy, RegExpGuard* g) const
{
    MOZ_CRASH("Should not end up in ScriptedProxyHandler::regexp_toShared");
    return false;
}

bool
ScriptedProxyHandler::boxedValue_unbox(JSContext* cx, HandleObject proxy,
                                       MutableHandleValue vp) const
{
    MOZ_CRASH("Should not end up in ScriptedProxyHandler::boxedValue_unbox");
    return false;
}

bool
ScriptedProxyHandler::isCallable(JSObject* obj) const
{
    MOZ_ASSERT(obj->as<ProxyObject>().handler() == &ScriptedProxyHandler::singleton);
    uint32_t callConstruct = obj->as<ProxyObject>().extra(IS_CALLCONSTRUCT_EXTRA).toPrivateUint32();
    return !!(callConstruct & IS_CALLABLE);
}

bool
ScriptedProxyHandler::isConstructor(JSObject* obj) const
{
    MOZ_ASSERT(obj->as<ProxyObject>().handler() == &ScriptedProxyHandler::singleton);
    uint32_t callConstruct = obj->as<ProxyObject>().extra(IS_CALLCONSTRUCT_EXTRA).toPrivateUint32();
    return !!(callConstruct & IS_CONSTRUCTOR);
}

const char ScriptedProxyHandler::family = 0;
const ScriptedProxyHandler ScriptedProxyHandler::singleton;

bool
IsRevokedScriptedProxy(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    return obj && IsScriptedProxy(obj) && !obj->as<ProxyObject>().target();
}

// ES8 rev 0c1bd3004329336774cbc90de727cd0cf5f11e93 9.5.14 ProxyCreate.
static bool
ProxyCreate(JSContext* cx, CallArgs& args, const char* callerName)
{
    if (args.length() < 2) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_MORE_ARGS_NEEDED,
                                  callerName, "1", "s");
        return false;
    }

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args[0]));
    if (!target)
        return false;

    // Step 2.
    if (IsRevokedScriptedProxy(target)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_ARG_REVOKED, "1");
        return false;
    }

    // Step 3.
    RootedObject handler(cx, NonNullObject(cx, args[1]));
    if (!handler)
        return false;

    // Step 4.
    if (IsRevokedScriptedProxy(handler)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_PROXY_ARG_REVOKED, "2");
        return false;
    }

    // Steps 5-6, 8.
    RootedValue priv(cx, ObjectValue(*target));
    JSObject* proxy_ =
        NewProxyObject(cx, &ScriptedProxyHandler::singleton, priv, TaggedProto::LazyProto);
    if (!proxy_)
        return false;

    // Step 9 (reordered).
    Rooted<ProxyObject*> proxy(cx, &proxy_->as<ProxyObject>());
    proxy->setExtra(ScriptedProxyHandler::HANDLER_EXTRA, ObjectValue(*handler));

    // Step 7.
    uint32_t callable = target->isCallable() ? ScriptedProxyHandler::IS_CALLABLE : 0;
    uint32_t constructor = target->isConstructor() ? ScriptedProxyHandler::IS_CONSTRUCTOR : 0;
    proxy->setExtra(ScriptedProxyHandler::IS_CALLCONSTRUCT_EXTRA,
                    PrivateUint32Value(callable | constructor));

    // Step 10.
    args.rval().setObject(*proxy);
    return true;
}

bool
js::proxy(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    if (!ThrowIfNotConstructing(cx, args, "Proxy"))
        return false;

    return ProxyCreate(cx, args, "Proxy");
}

static bool
RevokeProxy(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    RootedFunction func(cx, &args.callee().as<JSFunction>());
    RootedObject p(cx, func->getExtendedSlot(ScriptedProxyHandler::REVOKE_SLOT).toObjectOrNull());

    if (p) {
        func->setExtendedSlot(ScriptedProxyHandler::REVOKE_SLOT, NullValue());

        MOZ_ASSERT(p->is<ProxyObject>());

        p->as<ProxyObject>().setSameCompartmentPrivate(NullValue());
        p->as<ProxyObject>().setExtra(ScriptedProxyHandler::HANDLER_EXTRA, NullValue());
    }

    args.rval().setUndefined();
    return true;
}

bool
js::proxy_revocable(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    if (!ProxyCreate(cx, args, "Proxy.revocable"))
        return false;

    RootedValue proxyVal(cx, args.rval());
    MOZ_ASSERT(proxyVal.toObject().is<ProxyObject>());

    RootedObject revoker(cx, NewFunctionByIdWithReserved(cx, RevokeProxy, 0, 0,
                         AtomToId(cx->names().revoke)));
    if (!revoker)
        return false;

    revoker->as<JSFunction>().initExtendedSlot(ScriptedProxyHandler::REVOKE_SLOT, proxyVal);

    RootedPlainObject result(cx, NewBuiltinClassInstance<PlainObject>(cx));
    if (!result)
        return false;

    RootedValue revokeVal(cx, ObjectValue(*revoker));
    if (!DefineProperty(cx, result, cx->names().proxy, proxyVal) ||
        !DefineProperty(cx, result, cx->names().revoke, revokeVal))
    {
        return false;
    }

    args.rval().setObject(*result);
    return true;
}
