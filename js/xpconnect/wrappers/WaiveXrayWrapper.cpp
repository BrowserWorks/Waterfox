/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=4 et sw=4 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WaiveXrayWrapper.h"
#include "WrapperFactory.h"
#include "jsapi.h"

using namespace JS;

namespace xpc {

static bool
WaiveAccessors(JSContext* cx, MutableHandle<PropertyDescriptor> desc)
{
    if (desc.hasGetterObject() && desc.getterObject()) {
        RootedValue v(cx, JS::ObjectValue(*desc.getterObject()));
        if (!WrapperFactory::WaiveXrayAndWrap(cx, &v))
            return false;
        desc.setGetterObject(&v.toObject());
    }

    if (desc.hasSetterObject() && desc.setterObject()) {
        RootedValue v(cx, JS::ObjectValue(*desc.setterObject()));
        if (!WrapperFactory::WaiveXrayAndWrap(cx, &v))
            return false;
        desc.setSetterObject(&v.toObject());
    }
    return true;
}

bool
WaiveXrayWrapper::getPropertyDescriptor(JSContext* cx, HandleObject wrapper, HandleId id,
                                        MutableHandle<PropertyDescriptor> desc) const
{
    return CrossCompartmentWrapper::getPropertyDescriptor(cx, wrapper, id, desc) &&
           WrapperFactory::WaiveXrayAndWrap(cx, desc.value()) && WaiveAccessors(cx, desc);
}

bool
WaiveXrayWrapper::getOwnPropertyDescriptor(JSContext* cx, HandleObject wrapper, HandleId id,
                                           MutableHandle<PropertyDescriptor> desc) const
{
    return CrossCompartmentWrapper::getOwnPropertyDescriptor(cx, wrapper, id, desc) &&
           WrapperFactory::WaiveXrayAndWrap(cx, desc.value()) && WaiveAccessors(cx, desc);
}

bool
WaiveXrayWrapper::get(JSContext* cx, HandleObject wrapper, HandleValue receiver, HandleId id,
                      MutableHandleValue vp) const
{
    return CrossCompartmentWrapper::get(cx, wrapper, receiver, id, vp) &&
           WrapperFactory::WaiveXrayAndWrap(cx, vp);
}

JSObject*
WaiveXrayWrapper::enumerate(JSContext* cx, HandleObject proxy) const
{
    RootedObject obj(cx, CrossCompartmentWrapper::enumerate(cx, proxy));
    if (!obj)
        return nullptr;
    if (!WrapperFactory::WaiveXrayAndWrap(cx, &obj))
        return nullptr;
    return obj;
}

bool
WaiveXrayWrapper::call(JSContext* cx, HandleObject wrapper, const JS::CallArgs& args) const
{
    return CrossCompartmentWrapper::call(cx, wrapper, args) &&
           WrapperFactory::WaiveXrayAndWrap(cx, args.rval());
}

bool
WaiveXrayWrapper::construct(JSContext* cx, HandleObject wrapper, const JS::CallArgs& args) const
{
    return CrossCompartmentWrapper::construct(cx, wrapper, args) &&
           WrapperFactory::WaiveXrayAndWrap(cx, args.rval());
}

// NB: This is important as the other side of a handshake with FieldGetter. See
// nsXBLProtoImplField.cpp.
bool
WaiveXrayWrapper::nativeCall(JSContext* cx, JS::IsAcceptableThis test,
                             JS::NativeImpl impl, const JS::CallArgs& args) const
{
    return CrossCompartmentWrapper::nativeCall(cx, test, impl, args) &&
           WrapperFactory::WaiveXrayAndWrap(cx, args.rval());
}

bool
WaiveXrayWrapper::getPrototype(JSContext* cx, HandleObject wrapper, MutableHandleObject protop) const
{
    return CrossCompartmentWrapper::getPrototype(cx, wrapper, protop) &&
           (!protop || WrapperFactory::WaiveXrayAndWrap(cx, protop));
}

bool
WaiveXrayWrapper::getPrototypeIfOrdinary(JSContext* cx, HandleObject wrapper, bool* isOrdinary,
                                         MutableHandleObject protop) const
{
    return CrossCompartmentWrapper::getPrototypeIfOrdinary(cx, wrapper, isOrdinary, protop) &&
           (!protop || WrapperFactory::WaiveXrayAndWrap(cx, protop));
}

} // namespace xpc
