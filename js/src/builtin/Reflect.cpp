/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "builtin/Reflect.h"

#include "jsarray.h"
#include "jscntxt.h"

#include "vm/ArgumentsObject.h"
#include "vm/Stack.h"

#include "vm/Interpreter-inl.h"

using namespace js;


/*** Reflect methods *****************************************************************************/

/* ES6 26.1.3 Reflect.defineProperty(target, propertyKey, attributes) */
static bool
Reflect_defineProperty(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject obj(cx, NonNullObject(cx, args.get(0)));
    if (!obj)
        return false;

    // Steps 2-3.
    RootedValue propertyKey(cx, args.get(1));
    RootedId key(cx);
    if (!ToPropertyKey(cx, propertyKey, &key))
        return false;

    // Steps 4-5.
    Rooted<PropertyDescriptor> desc(cx);
    if (!ToPropertyDescriptor(cx, args.get(2), true, &desc))
        return false;

    // Step 6.
    ObjectOpResult result;
    if (!DefineProperty(cx, obj, key, desc, result))
        return false;
    args.rval().setBoolean(bool(result));
    return true;
}

/* ES6 26.1.4 Reflect.deleteProperty (target, propertyKey) */
static bool
Reflect_deleteProperty(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args.get(0)));
    if (!target)
        return false;

    // Steps 2-3.
    RootedValue propertyKey(cx, args.get(1));
    RootedId key(cx);
    if (!ToPropertyKey(cx, propertyKey, &key))
        return false;

    // Step 4.
    ObjectOpResult result;
    if (!DeleteProperty(cx, target, key, result))
        return false;
    args.rval().setBoolean(bool(result));
    return true;
}

/* ES6 26.1.6 Reflect.get(target, propertyKey [, receiver]) */
static bool
Reflect_get(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject obj(cx, NonNullObject(cx, args.get(0)));
    if (!obj)
        return false;

    // Steps 2-3.
    RootedValue propertyKey(cx, args.get(1));
    RootedId key(cx);
    if (!ToPropertyKey(cx, propertyKey, &key))
        return false;

    // Step 4.
    RootedValue receiver(cx, args.length() > 2 ? args[2] : args.get(0));

    // Step 5.
    return GetProperty(cx, obj, receiver, key, args.rval());
}

/* ES6 26.1.7 Reflect.getOwnPropertyDescriptor(target, propertyKey) */
static bool
Reflect_getOwnPropertyDescriptor(JSContext* cx, unsigned argc, Value* vp)
{
    // Step 1.
    CallArgs args = CallArgsFromVp(argc, vp);
    if (!NonNullObject(cx, args.get(0)))
        return false;

    // The other steps are identical to ES6 draft rev 32 (2015 Feb 2) 19.1.2.6
    // Object.getOwnPropertyDescriptor.
    return js::obj_getOwnPropertyDescriptor(cx, argc, vp);
}

/* ES6 26.1.8 Reflect.getPrototypeOf(target) */
bool
js::Reflect_getPrototypeOf(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args.get(0)));
    if (!target)
        return false;

    // Step 2.
    RootedObject proto(cx);
    if (!GetPrototype(cx, target, &proto))
        return false;
    args.rval().setObjectOrNull(proto);
    return true;
}

/* ES6 draft 26.1.10 Reflect.isExtensible(target) */
bool
js::Reflect_isExtensible(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args.get(0)));
    if (!target)
        return false;

    // Step 2.
    bool extensible;
    if (!IsExtensible(cx, target, &extensible))
        return false;
    args.rval().setBoolean(extensible);
    return true;
}

/* ES6 26.1.11 Reflect.ownKeys(target) */
static bool
Reflect_ownKeys(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    if (!NonNullObject(cx, args.get(0)))
        return false;

    // Steps 2-4.
    return GetOwnPropertyKeys(cx, args, JSITER_OWNONLY | JSITER_HIDDEN | JSITER_SYMBOLS);
}

/* ES6 26.1.12 Reflect.preventExtensions(target) */
static bool
Reflect_preventExtensions(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args.get(0)));
    if (!target)
        return false;

    // Step 2.
    ObjectOpResult result;
    if (!PreventExtensions(cx, target, result))
        return false;
    args.rval().setBoolean(bool(result));
    return true;
}

/* ES6 26.1.13 Reflect.set(target, propertyKey, V [, receiver]) */
static bool
Reflect_set(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject target(cx, NonNullObject(cx, args.get(0)));
    if (!target)
        return false;

    // Steps 2-3.
    RootedValue propertyKey(cx, args.get(1));
    RootedId key(cx);
    if (!ToPropertyKey(cx, propertyKey, &key))
        return false;

    // Step 4.
    RootedValue receiver(cx, args.length() > 3 ? args[3] : args.get(0));

    // Step 5.
    ObjectOpResult result;
    RootedValue value(cx, args.get(2));
    if (!SetProperty(cx, target, key, value, receiver, result))
        return false;
    args.rval().setBoolean(bool(result));
    return true;
}

/*
 * ES6 26.1.3 Reflect.setPrototypeOf(target, proto)
 *
 * The specification is not quite similar enough to Object.setPrototypeOf to
 * share code.
 */
static bool
Reflect_setPrototypeOf(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    RootedObject obj(cx, NonNullObject(cx, args.get(0)));
    if (!obj)
        return false;

    // Step 2.
    if (!args.get(1).isObjectOrNull()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_NOT_EXPECTED_TYPE,
                                  "Reflect.setPrototypeOf", "an object or null",
                                  InformalValueTypeName(args.get(1)));
        return false;
    }
    RootedObject proto(cx, args.get(1).toObjectOrNull());

    // Step 4.
    ObjectOpResult result;
    if (!SetPrototype(cx, obj, proto, result))
        return false;
    args.rval().setBoolean(bool(result));
    return true;
}

static const JSFunctionSpec methods[] = {
    JS_SELF_HOSTED_FN("apply", "Reflect_apply", 3, 0),
    JS_SELF_HOSTED_FN("construct", "Reflect_construct", 2, 0),
    JS_FN("defineProperty", Reflect_defineProperty, 3, 0),
    JS_FN("deleteProperty", Reflect_deleteProperty, 2, 0),
    JS_FN("get", Reflect_get, 2, 0),
    JS_FN("getOwnPropertyDescriptor", Reflect_getOwnPropertyDescriptor, 2, 0),
    JS_FN("getPrototypeOf", Reflect_getPrototypeOf, 1, 0),
    JS_SELF_HOSTED_FN("has", "Reflect_has", 2, 0),
    JS_FN("isExtensible", Reflect_isExtensible, 1, 0),
    JS_FN("ownKeys", Reflect_ownKeys, 1, 0),
    JS_FN("preventExtensions", Reflect_preventExtensions, 1, 0),
    JS_FN("set", Reflect_set, 3, 0),
    JS_FN("setPrototypeOf", Reflect_setPrototypeOf, 2, 0),
    JS_FS_END
};


/*** Setup **************************************************************************************/

JSObject*
js::InitReflect(JSContext* cx, HandleObject obj)
{
    RootedObject proto(cx, obj->as<GlobalObject>().getOrCreateObjectPrototype(cx));
    if (!proto)
        return nullptr;

    RootedObject reflect(cx, NewObjectWithGivenProto<PlainObject>(cx, proto, SingletonObject));
    if (!reflect)
        return nullptr;
    if (!JS_DefineFunctions(cx, reflect, methods))
        return nullptr;

    RootedValue value(cx, ObjectValue(*reflect));
    if (!DefineProperty(cx, obj, cx->names().Reflect, value, nullptr, nullptr, JSPROP_RESOLVING))
        return nullptr;

    obj->as<GlobalObject>().setConstructor(JSProto_Reflect, value);

    return reflect;
}
