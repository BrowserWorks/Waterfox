/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * JS object implementation.
 */

#include "jsobjinlines.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/SizePrintfMacros.h"
#include "mozilla/TemplateLib.h"

#include <string.h>

#include "jsapi.h"
#include "jsarray.h"
#include "jsatom.h"
#include "jscntxt.h"
#include "jsfriendapi.h"
#include "jsfun.h"
#include "jsgc.h"
#include "jsiter.h"
#include "jsnum.h"
#include "jsopcode.h"
#include "jsprf.h"
#include "jsscript.h"
#include "jsstr.h"
#include "jstypes.h"
#include "jsutil.h"
#include "jswatchpoint.h"
#include "jswin.h"
#include "jswrapper.h"

#include "builtin/Eval.h"
#include "builtin/Object.h"
#include "builtin/SymbolObject.h"
#include "frontend/BytecodeCompiler.h"
#include "gc/Marking.h"
#include "gc/Policy.h"
#include "jit/BaselineJIT.h"
#include "js/MemoryMetrics.h"
#include "js/Proxy.h"
#include "js/UbiNode.h"
#include "js/UniquePtr.h"
#include "vm/ArgumentsObject.h"
#include "vm/Interpreter.h"
#include "vm/ProxyObject.h"
#include "vm/RegExpStaticsObject.h"
#include "vm/Shape.h"
#include "vm/TypedArrayCommon.h"

#include "jsatominlines.h"
#include "jsboolinlines.h"
#include "jscntxtinlines.h"
#include "jscompartmentinlines.h"

#include "vm/ArrayObject-inl.h"
#include "vm/BooleanObject-inl.h"
#include "vm/Caches-inl.h"
#include "vm/Interpreter-inl.h"
#include "vm/NativeObject-inl.h"
#include "vm/NumberObject-inl.h"
#include "vm/Shape-inl.h"
#include "vm/StringObject-inl.h"

using namespace js;
using namespace js::gc;

using mozilla::DebugOnly;
using mozilla::Maybe;

void
js::ReportNotObject(JSContext* cx, const Value& v)
{
    MOZ_ASSERT(!v.isObject());

    RootedValue value(cx, v);
    UniqueChars bytes = DecompileValueGenerator(cx, JSDVG_SEARCH_STACK, value, nullptr);
    if (bytes)
        JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_NOT_NONNULL_OBJECT,
                                   bytes.get());
}

JS_PUBLIC_API(const char*)
JS::InformalValueTypeName(const Value& v)
{
    if (v.isObject())
        return v.toObject().getClass()->name;
    if (v.isString())
        return "string";
    if (v.isSymbol())
        return "symbol";
    if (v.isNumber())
        return "number";
    if (v.isBoolean())
        return "boolean";
    if (v.isNull())
        return "null";
    if (v.isUndefined())
        return "undefined";
    return "value";
}

// ES6 draft rev37 6.2.4.4 FromPropertyDescriptor
JS_PUBLIC_API(bool)
JS::FromPropertyDescriptor(JSContext* cx, Handle<PropertyDescriptor> desc, MutableHandleValue vp)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, desc);

    // Step 1.
    if (!desc.object()) {
        vp.setUndefined();
        return true;
    }

    return FromPropertyDescriptorToObject(cx, desc, vp);
}

bool
js::FromPropertyDescriptorToObject(JSContext* cx, Handle<PropertyDescriptor> desc,
                                   MutableHandleValue vp)
{
    // Step 2-3.
    RootedObject obj(cx, NewBuiltinClassInstance<PlainObject>(cx));
    if (!obj)
        return false;

    const JSAtomState& names = cx->names();

    // Step 4.
    if (desc.hasValue()) {
        if (!DefineProperty(cx, obj, names.value, desc.value()))
            return false;
    }

    // Step 5.
    RootedValue v(cx);
    if (desc.hasWritable()) {
        v.setBoolean(desc.writable());
        if (!DefineProperty(cx, obj, names.writable, v))
            return false;
    }

    // Step 6.
    if (desc.hasGetterObject()) {
        if (JSObject* get = desc.getterObject())
            v.setObject(*get);
        else
            v.setUndefined();
        if (!DefineProperty(cx, obj, names.get, v))
            return false;
    }

    // Step 7.
    if (desc.hasSetterObject()) {
        if (JSObject* set = desc.setterObject())
            v.setObject(*set);
        else
            v.setUndefined();
        if (!DefineProperty(cx, obj, names.set, v))
            return false;
    }

    // Step 8.
    if (desc.hasEnumerable()) {
        v.setBoolean(desc.enumerable());
        if (!DefineProperty(cx, obj, names.enumerable, v))
            return false;
    }

    // Step 9.
    if (desc.hasConfigurable()) {
        v.setBoolean(desc.configurable());
        if (!DefineProperty(cx, obj, names.configurable, v))
            return false;
    }

    vp.setObject(*obj);
    return true;
}

bool
js::GetFirstArgumentAsObject(JSContext* cx, const CallArgs& args, const char* method,
                             MutableHandleObject objp)
{
    if (args.length() == 0) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_MORE_ARGS_NEEDED,
                                  method, "0", "s");
        return false;
    }

    HandleValue v = args[0];
    if (!v.isObject()) {
        UniqueChars bytes = DecompileValueGenerator(cx, JSDVG_SEARCH_STACK, v, nullptr);
        if (!bytes)
            return false;
        JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_UNEXPECTED_TYPE,
                                   bytes.get(), "not an object");
        return false;
    }

    objp.set(&v.toObject());
    return true;
}

static bool
GetPropertyIfPresent(JSContext* cx, HandleObject obj, HandleId id, MutableHandleValue vp,
                     bool* foundp)
{
    if (!HasProperty(cx, obj, id, foundp))
        return false;
    if (!*foundp) {
        vp.setUndefined();
        return true;
    }

    return GetProperty(cx, obj, obj, id, vp);
}

bool
js::Throw(JSContext* cx, jsid id, unsigned errorNumber)
{
    MOZ_ASSERT(js_ErrorFormatString[errorNumber].argCount == 1);

    RootedValue idVal(cx, IdToValue(id));
    JSString* idstr = ValueToSource(cx, idVal);
    if (!idstr)
       return false;
    JSAutoByteString bytes(cx, idstr);
    if (!bytes)
        return false;
    JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, errorNumber, bytes.ptr());
    return false;
}

bool
js::Throw(JSContext* cx, JSObject* obj, unsigned errorNumber)
{
    if (js_ErrorFormatString[errorNumber].argCount == 1) {
        RootedValue val(cx, ObjectValue(*obj));
        ReportValueErrorFlags(cx, JSREPORT_ERROR, errorNumber,
                              JSDVG_IGNORE_STACK, val, nullptr,
                              nullptr, nullptr);
    } else {
        MOZ_ASSERT(js_ErrorFormatString[errorNumber].argCount == 0);
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, errorNumber);
    }
    return false;
}


/*** PropertyDescriptor operations and DefineProperties ******************************************/

bool
CheckCallable(JSContext* cx, JSObject* obj, const char* fieldName)
{
    if (obj && !obj->isCallable()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_GET_SET_FIELD,
                                  fieldName);
        return false;
    }
    return true;
}

bool
js::ToPropertyDescriptor(JSContext* cx, HandleValue descval, bool checkAccessors,
                         MutableHandle<PropertyDescriptor> desc)
{
    // step 2
    RootedObject obj(cx, NonNullObject(cx, descval));
    if (!obj)
        return false;

    // step 3
    desc.clear();

    bool found = false;
    RootedId id(cx);
    RootedValue v(cx);
    unsigned attrs = 0;

    // step 4
    id = NameToId(cx->names().enumerable);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    if (found) {
        if (ToBoolean(v))
            attrs |= JSPROP_ENUMERATE;
    } else {
        attrs |= JSPROP_IGNORE_ENUMERATE;
    }

    // step 5
    id = NameToId(cx->names().configurable);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    if (found) {
        if (!ToBoolean(v))
            attrs |= JSPROP_PERMANENT;
    } else {
        attrs |= JSPROP_IGNORE_PERMANENT;
    }

    // step 6
    id = NameToId(cx->names().value);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    if (found)
        desc.value().set(v);
    else
        attrs |= JSPROP_IGNORE_VALUE;

    // step 7
    id = NameToId(cx->names().writable);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    if (found) {
        if (!ToBoolean(v))
            attrs |= JSPROP_READONLY;
    } else {
        attrs |= JSPROP_IGNORE_READONLY;
    }

    // step 8
    bool hasGetOrSet;
    id = NameToId(cx->names().get);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    hasGetOrSet = found;
    if (found) {
        if (v.isObject()) {
            if (checkAccessors && !CheckCallable(cx, &v.toObject(), js_getter_str))
                return false;
            desc.setGetterObject(&v.toObject());
        } else if (!v.isUndefined()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_GET_SET_FIELD,
                                      js_getter_str);
            return false;
        }
        attrs |= JSPROP_GETTER | JSPROP_SHARED;
    }

    // step 9
    id = NameToId(cx->names().set);
    if (!GetPropertyIfPresent(cx, obj, id, &v, &found))
        return false;
    hasGetOrSet |= found;
    if (found) {
        if (v.isObject()) {
            if (checkAccessors && !CheckCallable(cx, &v.toObject(), js_setter_str))
                return false;
            desc.setSetterObject(&v.toObject());
        } else if (!v.isUndefined()) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_GET_SET_FIELD,
                                      js_setter_str);
            return false;
        }
        attrs |= JSPROP_SETTER | JSPROP_SHARED;
    }

    // step 10
    if (hasGetOrSet) {
        if (!(attrs & JSPROP_IGNORE_READONLY) || !(attrs & JSPROP_IGNORE_VALUE)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INVALID_DESCRIPTOR);
            return false;
        }

        // By convention, these bits are not used on accessor descriptors.
        attrs &= ~(JSPROP_IGNORE_READONLY | JSPROP_IGNORE_VALUE);
    }

    desc.setAttributes(attrs);
    MOZ_ASSERT_IF(attrs & JSPROP_READONLY, !(attrs & (JSPROP_GETTER | JSPROP_SETTER)));
    MOZ_ASSERT_IF(attrs & (JSPROP_GETTER | JSPROP_SETTER), attrs & JSPROP_SHARED);
    return true;
}

bool
js::CheckPropertyDescriptorAccessors(JSContext* cx, Handle<PropertyDescriptor> desc)
{
    if (desc.hasGetterObject()) {
        if (!CheckCallable(cx, desc.getterObject(), js_getter_str))
            return false;
    }
    if (desc.hasSetterObject()) {
        if (!CheckCallable(cx, desc.setterObject(), js_setter_str))
            return false;
    }
    return true;
}

void
js::CompletePropertyDescriptor(MutableHandle<PropertyDescriptor> desc)
{
    desc.assertValid();

    if (desc.isGenericDescriptor() || desc.isDataDescriptor()) {
        if (!desc.hasWritable())
            desc.attributesRef() |= JSPROP_READONLY;
        desc.attributesRef() &= ~(JSPROP_IGNORE_READONLY | JSPROP_IGNORE_VALUE);
    } else {
        if (!desc.hasGetterObject())
            desc.setGetterObject(nullptr);
        if (!desc.hasSetterObject())
            desc.setSetterObject(nullptr);
        desc.attributesRef() |= JSPROP_GETTER | JSPROP_SETTER | JSPROP_SHARED;
    }
    if (!desc.hasConfigurable())
        desc.attributesRef() |= JSPROP_PERMANENT;
    desc.attributesRef() &= ~(JSPROP_IGNORE_PERMANENT | JSPROP_IGNORE_ENUMERATE);

    desc.assertComplete();
}

bool
js::ReadPropertyDescriptors(JSContext* cx, HandleObject props, bool checkAccessors,
                            AutoIdVector* ids, MutableHandle<PropertyDescriptorVector> descs)
{
    if (!GetPropertyKeys(cx, props, JSITER_OWNONLY | JSITER_SYMBOLS, ids))
        return false;

    RootedId id(cx);
    for (size_t i = 0, len = ids->length(); i < len; i++) {
        id = (*ids)[i];
        Rooted<PropertyDescriptor> desc(cx);
        RootedValue v(cx);
        if (!GetProperty(cx, props, props, id, &v) ||
            !ToPropertyDescriptor(cx, v, checkAccessors, &desc) ||
            !descs.append(desc))
        {
            return false;
        }
    }
    return true;
}

/*** Seal and freeze *****************************************************************************/

static unsigned
GetSealedOrFrozenAttributes(unsigned attrs, IntegrityLevel level)
{
    /* Make all attributes permanent; if freezing, make data attributes read-only. */
    if (level == IntegrityLevel::Frozen && !(attrs & (JSPROP_GETTER | JSPROP_SETTER)))
        return JSPROP_PERMANENT | JSPROP_READONLY;
    return JSPROP_PERMANENT;
}

/* ES6 draft rev 29 (6 Dec 2014) 7.3.13. */
bool
js::SetIntegrityLevel(JSContext* cx, HandleObject obj, IntegrityLevel level)
{
    assertSameCompartment(cx, obj);

    // Steps 3-5. (Steps 1-2 are redundant assertions.)
    if (!PreventExtensions(cx, obj, level))
        return false;

    // Steps 6-7.
    AutoIdVector keys(cx);
    if (!GetPropertyKeys(cx, obj, JSITER_HIDDEN | JSITER_OWNONLY | JSITER_SYMBOLS, &keys))
        return false;

    // Steps 8-9, loosely interpreted.
    if (obj->isNative() && !obj->as<NativeObject>().inDictionaryMode() &&
        !obj->is<TypedArrayObject>())
    {
        HandleNativeObject nobj = obj.as<NativeObject>();

        // Seal/freeze non-dictionary objects by constructing a new shape
        // hierarchy mirroring the original one, which can be shared if many
        // objects with the same structure are sealed/frozen. If we use the
        // generic path below then any non-empty object will be converted to
        // dictionary mode.
        RootedShape last(cx, EmptyShape::getInitialShape(cx, nobj->getClass(),
                                                         nobj->taggedProto(),
                                                         nobj->numFixedSlots(),
                                                         nobj->lastProperty()->getObjectFlags()));
        if (!last)
            return false;

        // Get an in-order list of the shapes in this object.
        Rooted<ShapeVector> shapes(cx, ShapeVector(cx));
        for (Shape::Range<NoGC> r(nobj->lastProperty()); !r.empty(); r.popFront()) {
            if (!shapes.append(&r.front()))
                return false;
        }
        Reverse(shapes.begin(), shapes.end());

        for (Shape* shape : shapes) {
            Rooted<StackShape> child(cx, StackShape(shape));
            child.setAttrs(child.attrs() | GetSealedOrFrozenAttributes(child.attrs(), level));

            if (!JSID_IS_EMPTY(child.get().propid) && level == IntegrityLevel::Frozen)
                MarkTypePropertyNonWritable(cx, nobj, child.get().propid);

            last = cx->zone()->propertyTree.getChild(cx, last, child);
            if (!last)
                return false;
        }

        MOZ_ASSERT(nobj->lastProperty()->slotSpan() == last->slotSpan());
        JS_ALWAYS_TRUE(nobj->setLastProperty(cx, last));

        // Ordinarily ArraySetLength handles this, but we're going behind its back
        // right now, so we must do this manually.
        //
        // ArraySetLength also implements the capacity <= length invariant for
        // arrays with non-writable length.  We don't need to do anything special
        // for that, because capacity was zeroed out by preventExtensions.  (See
        // the assertion about getDenseCapacity above.)
        if (level == IntegrityLevel::Frozen && obj->is<ArrayObject>()) {
            if (!obj->as<ArrayObject>().maybeCopyElementsForWrite(cx))
                return false;
            obj->as<ArrayObject>().getElementsHeader()->setNonwritableArrayLength();
        }
    } else {
        RootedId id(cx);
        Rooted<PropertyDescriptor> desc(cx);

        const unsigned AllowConfigure = JSPROP_IGNORE_ENUMERATE | JSPROP_IGNORE_READONLY |
                                        JSPROP_IGNORE_VALUE;
        const unsigned AllowConfigureAndWritable = AllowConfigure & ~JSPROP_IGNORE_READONLY;

        // 8.a/9.a. The two different loops are merged here.
        for (size_t i = 0; i < keys.length(); i++) {
            id = keys[i];

            if (level == IntegrityLevel::Sealed) {
                // 8.a.i.
                desc.setAttributes(AllowConfigure | JSPROP_PERMANENT);
            } else {
                // 9.a.i-ii.
                Rooted<PropertyDescriptor> currentDesc(cx);
                if (!GetOwnPropertyDescriptor(cx, obj, id, &currentDesc))
                    return false;

                // 9.a.iii.
                if (!currentDesc.object())
                    continue;

                // 9.a.iii.1-2
                if (currentDesc.isAccessorDescriptor())
                    desc.setAttributes(AllowConfigure | JSPROP_PERMANENT);
                else
                    desc.setAttributes(AllowConfigureAndWritable | JSPROP_PERMANENT | JSPROP_READONLY);
            }

            // 8.a.i-ii. / 9.a.iii.3-4
            if (!DefineProperty(cx, obj, id, desc))
                return false;
        }
    }

    return true;
}

// ES6 draft rev33 (12 Feb 2015) 7.3.15
bool
js::TestIntegrityLevel(JSContext* cx, HandleObject obj, IntegrityLevel level, bool* result)
{
    // Steps 3-6. (Steps 1-2 are redundant assertions.)
    bool status;
    if (!IsExtensible(cx, obj, &status))
        return false;
    if (status) {
        *result = false;
        return true;
    }

    // Steps 7-8.
    AutoIdVector props(cx);
    if (!GetPropertyKeys(cx, obj, JSITER_HIDDEN | JSITER_OWNONLY | JSITER_SYMBOLS, &props))
        return false;

    // Step 9.
    RootedId id(cx);
    Rooted<PropertyDescriptor> desc(cx);
    for (size_t i = 0, len = props.length(); i < len; i++) {
        id = props[i];

        // Steps 9.a-b.
        if (!GetOwnPropertyDescriptor(cx, obj, id, &desc))
            return false;

        // Step 9.c.
        if (!desc.object())
            continue;

        // Steps 9.c.i-ii.
        if (desc.configurable() ||
            (level == IntegrityLevel::Frozen && desc.isDataDescriptor() && desc.writable()))
        {
            *result = false;
            return true;
        }
    }

    // Step 10.
    *result = true;
    return true;
}


/* * */

/*
 * Get the GC kind to use for scripted 'new' on the given class.
 * FIXME bug 547327: estimate the size from the allocation site.
 */
static inline gc::AllocKind
NewObjectGCKind(const js::Class* clasp)
{
    if (clasp == &ArrayObject::class_)
        return gc::AllocKind::OBJECT8;
    if (clasp == &JSFunction::class_)
        return gc::AllocKind::OBJECT2;
    return gc::AllocKind::OBJECT4;
}

static inline JSObject*
NewObject(ExclusiveContext* cx, HandleObjectGroup group, gc::AllocKind kind,
          NewObjectKind newKind, uint32_t initialShapeFlags = 0)
{
    const Class* clasp = group->clasp();

    MOZ_ASSERT(clasp != &ArrayObject::class_);
    MOZ_ASSERT_IF(clasp == &JSFunction::class_,
                  kind == AllocKind::FUNCTION || kind == AllocKind::FUNCTION_EXTENDED);

    // For objects which can have fixed data following the object, only use
    // enough fixed slots to cover the number of reserved slots in the object,
    // regardless of the allocation kind specified.
    size_t nfixed = ClassCanHaveFixedData(clasp)
                    ? GetGCKindSlots(gc::GetGCObjectKind(clasp), clasp)
                    : GetGCKindSlots(kind, clasp);

    RootedShape shape(cx, EmptyShape::getInitialShape(cx, clasp, group->proto(), nfixed,
                                                      initialShapeFlags));
    if (!shape)
        return nullptr;

    gc::InitialHeap heap = GetInitialHeap(newKind, clasp);
    JSObject* obj = JSObject::create(cx, kind, heap, shape, group);
    if (!obj)
        return nullptr;

    if (newKind == SingletonObject) {
        RootedObject nobj(cx, obj);
        if (!JSObject::setSingleton(cx, nobj))
            return nullptr;
        obj = nobj;
    }

    probes::CreateObject(cx, obj);
    return obj;
}

void
NewObjectCache::fillProto(EntryIndex entry, const Class* clasp, js::TaggedProto proto,
                          gc::AllocKind kind, NativeObject* obj)
{
    MOZ_ASSERT_IF(proto.isObject(), !proto.toObject()->is<GlobalObject>());
    MOZ_ASSERT(obj->taggedProto() == proto);
    return fill(entry, clasp, proto.raw(), kind, obj);
}

bool
js::NewObjectWithTaggedProtoIsCachable(ExclusiveContext* cxArg, Handle<TaggedProto> proto,
                                       NewObjectKind newKind, const Class* clasp)
{
    return cxArg->isJSContext() &&
           proto.isObject() &&
           newKind == GenericObject &&
           clasp->isNative() &&
           !proto.toObject()->is<GlobalObject>();
}

JSObject*
js::NewObjectWithGivenTaggedProto(ExclusiveContext* cxArg, const Class* clasp,
                                  Handle<TaggedProto> proto,
                                  gc::AllocKind allocKind, NewObjectKind newKind,
                                  uint32_t initialShapeFlags)
{
    if (CanBeFinalizedInBackground(allocKind, clasp))
        allocKind = GetBackgroundAllocKind(allocKind);

    bool isCachable = NewObjectWithTaggedProtoIsCachable(cxArg, proto, newKind, clasp);
    if (isCachable) {
        JSContext* cx = cxArg->asJSContext();
        NewObjectCache& cache = cx->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        if (cache.lookupProto(clasp, proto.toObject(), allocKind, &entry)) {
            JSObject* obj = cache.newObjectFromHit(cx, entry, GetInitialHeap(newKind, clasp));
            if (obj)
                return obj;
        }
    }

    RootedObjectGroup group(cxArg, ObjectGroup::defaultNewGroup(cxArg, clasp, proto, nullptr));
    if (!group)
        return nullptr;

    RootedObject obj(cxArg, NewObject(cxArg, group, allocKind, newKind, initialShapeFlags));
    if (!obj)
        return nullptr;

    if (isCachable && !obj->as<NativeObject>().hasDynamicSlots()) {
        NewObjectCache& cache = cxArg->asJSContext()->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        cache.lookupProto(clasp, proto.toObject(), allocKind, &entry);
        cache.fillProto(entry, clasp, proto, allocKind, &obj->as<NativeObject>());
    }

    return obj;
}

static bool
NewObjectIsCachable(ExclusiveContext* cxArg, NewObjectKind newKind, const Class* clasp)
{
    return cxArg->isJSContext() &&
           newKind == GenericObject &&
           clasp->isNative();
}

JSObject*
js::NewObjectWithClassProtoCommon(ExclusiveContext* cx, const Class* clasp, HandleObject protoArg,
                                  gc::AllocKind allocKind, NewObjectKind newKind)
{
    if (protoArg)
        return NewObjectWithGivenTaggedProto(cx, clasp, AsTaggedProto(protoArg), allocKind, newKind);

    if (CanBeFinalizedInBackground(allocKind, clasp))
        allocKind = GetBackgroundAllocKind(allocKind);

    Handle<GlobalObject*> global = cx->global();

    bool isCachable = NewObjectIsCachable(cx, newKind, clasp);
    if (isCachable) {
        NewObjectCache& cache = cx->asJSContext()->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        if (cache.lookupGlobal(clasp, global, allocKind, &entry)) {
            gc::InitialHeap heap = GetInitialHeap(newKind, clasp);
            JSObject* obj = cache.newObjectFromHit(cx->asJSContext(), entry, heap);
            if (obj)
                return obj;
        }
    }

    // Find the appropriate proto for clasp. Built-in classes have a cached
    // proto on cx->global(); all others get %ObjectPrototype%.
    JSProtoKey protoKey = JSCLASS_CACHED_PROTO_KEY(clasp);
    if (protoKey == JSProto_Null)
        protoKey = JSProto_Object;

    RootedObject proto(cx);
    if (!GetBuiltinPrototype(cx, protoKey, &proto))
        return nullptr;

    RootedObjectGroup group(cx, ObjectGroup::defaultNewGroup(cx, clasp, AsTaggedProto(proto)));
    if (!group)
        return nullptr;

    JSObject* obj = NewObject(cx, group, allocKind, newKind);
    if (!obj)
        return nullptr;

    if (isCachable && !obj->as<NativeObject>().hasDynamicSlots()) {
        NewObjectCache& cache = cx->asJSContext()->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        cache.lookupGlobal(clasp, global, allocKind, &entry);
        cache.fillGlobal(entry, clasp, global, allocKind,
                         &obj->as<NativeObject>());
    }

    return obj;
}

static bool
NewObjectWithGroupIsCachable(ExclusiveContext* cx, HandleObjectGroup group,
                             NewObjectKind newKind)
{
    return group->proto().isObject() &&
           newKind == GenericObject &&
           group->clasp()->isNative() &&
           (!group->newScript() || group->newScript()->analyzed()) &&
           cx->isJSContext();
}

/*
 * Create a plain object with the specified group. This bypasses getNewGroup to
 * avoid losing creation site information for objects made by scripted 'new'.
 */
JSObject*
js::NewObjectWithGroupCommon(ExclusiveContext* cx, HandleObjectGroup group,
                             gc::AllocKind allocKind, NewObjectKind newKind)
{
    MOZ_ASSERT(gc::IsObjectAllocKind(allocKind));
    if (CanBeFinalizedInBackground(allocKind, group->clasp()))
        allocKind = GetBackgroundAllocKind(allocKind);

    bool isCachable = NewObjectWithGroupIsCachable(cx, group, newKind);
    if (isCachable) {
        NewObjectCache& cache = cx->asJSContext()->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        if (cache.lookupGroup(group, allocKind, &entry)) {
            JSObject* obj = cache.newObjectFromHit(cx->asJSContext(), entry,
                                                   GetInitialHeap(newKind, group->clasp()));
            if (obj)
                return obj;
        }
    }

    JSObject* obj = NewObject(cx, group, allocKind, newKind);
    if (!obj)
        return nullptr;

    if (isCachable && !obj->as<NativeObject>().hasDynamicSlots()) {
        NewObjectCache& cache = cx->asJSContext()->caches.newObjectCache;
        NewObjectCache::EntryIndex entry = -1;
        cache.lookupGroup(group, allocKind, &entry);
        cache.fillGroup(entry, group, allocKind, &obj->as<NativeObject>());
    }

    return obj;
}

bool
js::NewObjectScriptedCall(JSContext* cx, MutableHandleObject pobj)
{
    jsbytecode* pc;
    RootedScript script(cx, cx->currentScript(&pc));
    gc::AllocKind allocKind = NewObjectGCKind(&PlainObject::class_);
    NewObjectKind newKind = GenericObject;
    if (script && ObjectGroup::useSingletonForAllocationSite(script, pc, &PlainObject::class_))
        newKind = SingletonObject;
    RootedObject obj(cx, NewBuiltinClassInstance<PlainObject>(cx, allocKind, newKind));
    if (!obj)
        return false;

    if (script) {
        /* Try to specialize the group of the object to the scripted call site. */
        if (!ObjectGroup::setAllocationSiteObjectGroup(cx, script, pc, obj, newKind == SingletonObject))
            return false;
    }

    pobj.set(obj);
    return true;
}

JSObject*
js::CreateThis(JSContext* cx, const Class* newclasp, HandleObject callee)
{
    RootedObject proto(cx);
    if (!GetPrototypeFromConstructor(cx, callee, &proto))
        return nullptr;
    gc::AllocKind kind = NewObjectGCKind(newclasp);
    return NewObjectWithClassProto(cx, newclasp, proto, kind);
}

static inline JSObject*
CreateThisForFunctionWithGroup(JSContext* cx, HandleObjectGroup group,
                               NewObjectKind newKind)
{
    if (group->maybeUnboxedLayout() && newKind != SingletonObject)
        return UnboxedPlainObject::create(cx, group, newKind);

    if (TypeNewScript* newScript = group->newScript()) {
        if (newScript->analyzed()) {
            // The definite properties analysis has been performed for this
            // group, so get the shape and alloc kind to use from the
            // TypeNewScript's template.
            RootedPlainObject templateObject(cx, newScript->templateObject());
            MOZ_ASSERT(templateObject->group() == group);

            RootedPlainObject res(cx, CopyInitializerObject(cx, templateObject, newKind));
            if (!res)
                return nullptr;

            if (newKind == SingletonObject) {
                Rooted<TaggedProto> proto(cx, TaggedProto(templateObject->staticPrototype()));
                if (!res->splicePrototype(cx, &PlainObject::class_, proto))
                    return nullptr;
            } else {
                res->setGroup(group);
            }
            return res;
        }

        // The initial objects registered with a TypeNewScript can't be in the
        // nursery.
        if (newKind == GenericObject)
            newKind = TenuredObject;

        // Not enough objects with this group have been created yet, so make a
        // plain object and register it with the group. Use the maximum number
        // of fixed slots, as is also required by the TypeNewScript.
        gc::AllocKind allocKind = GuessObjectGCKind(NativeObject::MAX_FIXED_SLOTS);
        PlainObject* res = NewObjectWithGroup<PlainObject>(cx, group, allocKind, newKind);
        if (!res)
            return nullptr;

        // Make sure group->newScript is still there.
        if (newKind != SingletonObject && group->newScript())
            group->newScript()->registerNewObject(res);

        return res;
    }

    gc::AllocKind allocKind = NewObjectGCKind(&PlainObject::class_);

    if (newKind == SingletonObject) {
        Rooted<TaggedProto> protoRoot(cx, group->proto());
        return NewObjectWithGivenTaggedProto(cx, &PlainObject::class_, protoRoot, allocKind, newKind);
    }
    return NewObjectWithGroup<PlainObject>(cx, group, allocKind, newKind);
}

JSObject*
js::CreateThisForFunctionWithProto(JSContext* cx, HandleObject callee, HandleObject newTarget,
                                   HandleObject proto, NewObjectKind newKind /* = GenericObject */)
{
    RootedObject res(cx);

    if (proto) {
        RootedObjectGroup group(cx, ObjectGroup::defaultNewGroup(cx, nullptr, TaggedProto(proto),
                                                                 newTarget));
        if (!group)
            return nullptr;

        if (group->newScript() && !group->newScript()->analyzed()) {
            bool regenerate;
            if (!group->newScript()->maybeAnalyze(cx, group, &regenerate))
                return nullptr;
            if (regenerate) {
                // The script was analyzed successfully and may have changed
                // the new type table, so refetch the group.
                group = ObjectGroup::defaultNewGroup(cx, nullptr, TaggedProto(proto),
                                                     newTarget);
                MOZ_ASSERT(group && group->newScript());
            }
        }

        res = CreateThisForFunctionWithGroup(cx, group, newKind);
    } else {
        res = NewBuiltinClassInstance<PlainObject>(cx, newKind);
    }

    if (res) {
        JSScript* script = callee->as<JSFunction>().getOrCreateScript(cx);
        if (!script)
            return nullptr;
        TypeScript::SetThis(cx, script, TypeSet::ObjectType(res));
    }

    return res;
}

bool
js::GetPrototypeFromConstructor(JSContext* cx, HandleObject newTarget, MutableHandleObject proto)
{
    RootedValue protov(cx);
    if (!GetProperty(cx, newTarget, newTarget, cx->names().prototype, &protov))
        return false;
    proto.set(protov.isObject() ? &protov.toObject() : nullptr);
    return true;
}

bool
js::GetPrototypeFromCallableConstructor(JSContext* cx, const CallArgs& args, MutableHandleObject proto)
{
    RootedObject newTarget(cx);
    if (args.isConstructing())
        newTarget = &args.newTarget().toObject();
    else
        newTarget = &args.callee();
    return GetPrototypeFromConstructor(cx, newTarget, proto);
}

JSObject*
js::CreateThisForFunction(JSContext* cx, HandleObject callee, HandleObject newTarget,
                          NewObjectKind newKind)
{
    RootedObject proto(cx);
    if (!GetPrototypeFromConstructor(cx, newTarget, &proto))
        return nullptr;

    JSObject* obj = CreateThisForFunctionWithProto(cx, callee, newTarget, proto, newKind);

    if (obj && newKind == SingletonObject) {
        RootedPlainObject nobj(cx, &obj->as<PlainObject>());

        /* Reshape the singleton before passing it as the 'this' value. */
        NativeObject::clear(cx, nobj);

        JSScript* calleeScript = callee->as<JSFunction>().nonLazyScript();
        TypeScript::SetThis(cx, calleeScript, TypeSet::ObjectType(nobj));

        return nobj;
    }

    return obj;
}

/* static */ bool
JSObject::nonNativeSetProperty(JSContext* cx, HandleObject obj, HandleId id, HandleValue v,
                               HandleValue receiver, ObjectOpResult& result)
{
    RootedValue value(cx, v);
    if (MOZ_UNLIKELY(obj->watched())) {
        WatchpointMap* wpmap = cx->compartment()->watchpointMap;
        if (wpmap && !wpmap->triggerWatchpoint(cx, obj, id, &value))
            return false;
    }
    return obj->getOpsSetProperty()(cx, obj, id, value, receiver, result);
}

/* static */ bool
JSObject::nonNativeSetElement(JSContext* cx, HandleObject obj, uint32_t index, HandleValue v,
                              HandleValue receiver, ObjectOpResult& result)
{
    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return nonNativeSetProperty(cx, obj, id, v, receiver, result);
}

JS_FRIEND_API(bool)
JS_CopyPropertyFrom(JSContext* cx, HandleId id, HandleObject target,
                    HandleObject obj, PropertyCopyBehavior copyBehavior)
{
    // |obj| and |cx| are generally not same-compartment with |target| here.
    assertSameCompartment(cx, obj, id);
    Rooted<PropertyDescriptor> desc(cx);

    if (!GetOwnPropertyDescriptor(cx, obj, id, &desc))
        return false;
    MOZ_ASSERT(desc.object());

    // Silently skip JSGetterOp/JSSetterOp-implemented accessors.
    if (desc.getter() && !desc.hasGetterObject())
        return true;
    if (desc.setter() && !desc.hasSetterObject())
        return true;

    if (copyBehavior == MakeNonConfigurableIntoConfigurable) {
        // Mask off the JSPROP_PERMANENT bit.
        desc.attributesRef() &= ~JSPROP_PERMANENT;
    }

    JSAutoCompartment ac(cx, target);
    RootedId wrappedId(cx, id);
    if (!cx->compartment()->wrap(cx, &desc))
        return false;

    return DefineProperty(cx, target, wrappedId, desc);
}

JS_FRIEND_API(bool)
JS_CopyPropertiesFrom(JSContext* cx, HandleObject target, HandleObject obj)
{
    JSAutoCompartment ac(cx, obj);

    AutoIdVector props(cx);
    if (!GetPropertyKeys(cx, obj, JSITER_OWNONLY | JSITER_HIDDEN | JSITER_SYMBOLS, &props))
        return false;

    for (size_t i = 0; i < props.length(); ++i) {
        if (!JS_CopyPropertyFrom(cx, props[i], target, obj))
            return false;
    }

    return true;
}

static bool
CopyProxyObject(JSContext* cx, Handle<ProxyObject*> from, Handle<ProxyObject*> to)
{
    MOZ_ASSERT(from->getClass() == to->getClass());

    if (from->is<WrapperObject>() &&
        (Wrapper::wrapperHandler(from)->flags() &
         Wrapper::CROSS_COMPARTMENT))
    {
        to->setCrossCompartmentPrivate(GetProxyPrivate(from));
    } else {
        RootedValue v(cx, GetProxyPrivate(from));
        if (!cx->compartment()->wrap(cx, &v))
            return false;
        to->setSameCompartmentPrivate(v);
    }

    RootedValue v(cx);
    for (size_t n = 0; n < js::detail::PROXY_EXTRA_SLOTS; n++) {
        v = GetProxyExtra(from, n);
        if (!cx->compartment()->wrap(cx, &v))
            return false;
        SetProxyExtra(to, n, v);
    }

    return true;
}

JSObject*
js::CloneObject(JSContext* cx, HandleObject obj, Handle<js::TaggedProto> proto)
{
    if (!obj->isNative() && !obj->is<ProxyObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CLONE_OBJECT);
        return nullptr;
    }

    RootedObject clone(cx);
    if (obj->isNative()) {
        clone = NewObjectWithGivenTaggedProto(cx, obj->getClass(), proto);
        if (!clone)
            return nullptr;

        if (clone->is<JSFunction>() && (obj->compartment() != clone->compartment())) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CLONE_OBJECT);
            return nullptr;
        }

        if (obj->as<NativeObject>().hasPrivate())
            clone->as<NativeObject>().setPrivate(obj->as<NativeObject>().getPrivate());
    } else {
        ProxyOptions options;
        options.setClass(obj->getClass());

        clone = ProxyObject::New(cx, GetProxyHandler(obj), JS::NullHandleValue, proto, options);
        if (!clone)
            return nullptr;

        if (!CopyProxyObject(cx, obj.as<ProxyObject>(), clone.as<ProxyObject>()))
            return nullptr;
    }

    return clone;
}

static bool
GetScriptArrayObjectElements(JSContext* cx, HandleObject obj, MutableHandle<GCVector<Value>> values)
{
    MOZ_ASSERT(!obj->isSingleton());
    MOZ_ASSERT(obj->is<ArrayObject>() || obj->is<UnboxedArrayObject>());
    MOZ_ASSERT(!obj->isIndexed());

    size_t length = GetAnyBoxedOrUnboxedArrayLength(obj);
    if (!values.appendN(MagicValue(JS_ELEMENTS_HOLE), length))
        return false;

    size_t initlen = GetAnyBoxedOrUnboxedInitializedLength(obj);
    for (size_t i = 0; i < initlen; i++)
        values[i].set(GetAnyBoxedOrUnboxedDenseElement(obj, i));

    return true;
}

static bool
GetScriptPlainObjectProperties(JSContext* cx, HandleObject obj,
                               MutableHandle<IdValueVector> properties)
{
    if (obj->is<PlainObject>()) {
        PlainObject* nobj = &obj->as<PlainObject>();

        if (!properties.appendN(IdValuePair(), nobj->slotSpan()))
            return false;

        for (Shape::Range<NoGC> r(nobj->lastProperty()); !r.empty(); r.popFront()) {
            Shape& shape = r.front();
            MOZ_ASSERT(shape.isDataDescriptor());
            uint32_t slot = shape.slot();
            properties[slot].get().id = shape.propid();
            properties[slot].get().value = nobj->getSlot(slot);
        }

        for (size_t i = 0; i < nobj->getDenseInitializedLength(); i++) {
            Value v = nobj->getDenseElement(i);
            if (!v.isMagic(JS_ELEMENTS_HOLE) && !properties.append(IdValuePair(INT_TO_JSID(i), v)))
                return false;
        }

        return true;
    }

    if (obj->is<UnboxedPlainObject>()) {
        UnboxedPlainObject* nobj = &obj->as<UnboxedPlainObject>();

        const UnboxedLayout& layout = nobj->layout();
        if (!properties.appendN(IdValuePair(), layout.properties().length()))
            return false;

        for (size_t i = 0; i < layout.properties().length(); i++) {
            const UnboxedLayout::Property& property = layout.properties()[i];
            properties[i].get().id = NameToId(property.name);
            properties[i].get().value = nobj->getValue(property);
        }

        return true;
    }

    MOZ_CRASH("Bad object kind");
}

static bool
DeepCloneValue(JSContext* cx, Value* vp, NewObjectKind newKind)
{
    if (vp->isObject()) {
        RootedObject obj(cx, &vp->toObject());
        obj = DeepCloneObjectLiteral(cx, obj, newKind);
        if (!obj)
            return false;
        vp->setObject(*obj);
    }
    return true;
}

JSObject*
js::DeepCloneObjectLiteral(JSContext* cx, HandleObject obj, NewObjectKind newKind)
{
    /* NB: Keep this in sync with XDRObjectLiteral. */
    MOZ_ASSERT_IF(obj->isSingleton(),
                  cx->compartment()->behaviors().getSingletonsAsTemplates());
    MOZ_ASSERT(obj->is<PlainObject>() || obj->is<UnboxedPlainObject>() ||
               obj->is<ArrayObject>() || obj->is<UnboxedArrayObject>());
    MOZ_ASSERT(newKind != SingletonObject);

    if (obj->is<ArrayObject>() || obj->is<UnboxedArrayObject>()) {
        Rooted<GCVector<Value>> values(cx, GCVector<Value>(cx));
        if (!GetScriptArrayObjectElements(cx, obj, &values))
            return nullptr;

        // Deep clone any elements.
        for (uint32_t i = 0; i < values.length(); ++i) {
            if (!DeepCloneValue(cx, values[i].address(), newKind))
                return nullptr;
        }

        ObjectGroup::NewArrayKind arrayKind = ObjectGroup::NewArrayKind::Normal;
        if (obj->is<ArrayObject>() && obj->as<ArrayObject>().denseElementsAreCopyOnWrite())
            arrayKind = ObjectGroup::NewArrayKind::CopyOnWrite;

        return ObjectGroup::newArrayObject(cx, values.begin(), values.length(), newKind,
                                           arrayKind);
    }

    Rooted<IdValueVector> properties(cx, IdValueVector(cx));
    if (!GetScriptPlainObjectProperties(cx, obj, &properties))
        return nullptr;

    for (size_t i = 0; i < properties.length(); i++) {
        if (!DeepCloneValue(cx, &properties[i].get().value, newKind))
            return nullptr;
    }

    if (obj->isSingleton())
        newKind = SingletonObject;

    return ObjectGroup::newPlainObject(cx, properties.begin(), properties.length(), newKind);
}

static bool
InitializePropertiesFromCompatibleNativeObject(JSContext* cx,
                                               HandleNativeObject dst,
                                               HandleNativeObject src)
{
    assertSameCompartment(cx, src, dst);
    MOZ_ASSERT(src->getClass() == dst->getClass());
    MOZ_ASSERT(dst->lastProperty()->getObjectFlags() == 0);
    MOZ_ASSERT(!src->isSingleton());
    MOZ_ASSERT(src->numFixedSlots() == dst->numFixedSlots());

    if (!dst->ensureElements(cx, src->getDenseInitializedLength()))
        return false;

    uint32_t initialized = src->getDenseInitializedLength();
    for (uint32_t i = 0; i < initialized; ++i) {
        dst->setDenseInitializedLength(i + 1);
        dst->initDenseElement(i, src->getDenseElement(i));
    }

    MOZ_ASSERT(!src->hasPrivate());
    RootedShape shape(cx);
    if (src->staticPrototype() == dst->staticPrototype()) {
        shape = src->lastProperty();
    } else {
        // We need to generate a new shape for dst that has dst's proto but all
        // the property information from src.  Note that we asserted above that
        // dst's object flags are 0.
        shape = EmptyShape::getInitialShape(cx, dst->getClass(), dst->taggedProto(),
                                            dst->numFixedSlots(), 0);
        if (!shape)
            return false;

        // Get an in-order list of the shapes in the src object.
        Rooted<ShapeVector> shapes(cx, ShapeVector(cx));
        for (Shape::Range<NoGC> r(src->lastProperty()); !r.empty(); r.popFront()) {
            if (!shapes.append(&r.front()))
                return false;
        }
        Reverse(shapes.begin(), shapes.end());

        for (Shape* shape : shapes) {
            Rooted<StackShape> child(cx, StackShape(shape));
            shape = cx->zone()->propertyTree.getChild(cx, shape, child);
            if (!shape)
                return false;
        }
    }
    size_t span = shape->slotSpan();
    if (!dst->setLastProperty(cx, shape))
        return false;
    for (size_t i = JSCLASS_RESERVED_SLOTS(src->getClass()); i < span; i++)
        dst->setSlot(i, src->getSlot(i));

    return true;
}

JS_FRIEND_API(bool)
JS_InitializePropertiesFromCompatibleNativeObject(JSContext* cx,
                                                  HandleObject dst,
                                                  HandleObject src)
{
    return InitializePropertiesFromCompatibleNativeObject(cx,
                                                          dst.as<NativeObject>(),
                                                          src.as<NativeObject>());
}

template<XDRMode mode>
bool
js::XDRObjectLiteral(XDRState<mode>* xdr, MutableHandleObject obj)
{
    /* NB: Keep this in sync with DeepCloneObjectLiteral. */

    JSContext* cx = xdr->cx();
    MOZ_ASSERT_IF(mode == XDR_ENCODE && obj->isSingleton(),
                  cx->compartment()->behaviors().getSingletonsAsTemplates());

    // Distinguish between objects and array classes.
    uint32_t isArray = 0;
    {
        if (mode == XDR_ENCODE) {
            MOZ_ASSERT(obj->is<PlainObject>() ||
                       obj->is<UnboxedPlainObject>() ||
                       obj->is<ArrayObject>() ||
                       obj->is<UnboxedArrayObject>());
            isArray = (obj->is<ArrayObject>() || obj->is<UnboxedArrayObject>()) ? 1 : 0;
        }

        if (!xdr->codeUint32(&isArray))
            return false;
    }

    RootedValue tmpValue(cx), tmpIdValue(cx);
    RootedId tmpId(cx);

    if (isArray) {
        Rooted<GCVector<Value>> values(cx, GCVector<Value>(cx));
        if (mode == XDR_ENCODE && !GetScriptArrayObjectElements(cx, obj, &values))
            return false;

        uint32_t initialized;
        if (mode == XDR_ENCODE)
            initialized = values.length();
        if (!xdr->codeUint32(&initialized))
            return false;
        if (mode == XDR_DECODE && !values.appendN(MagicValue(JS_ELEMENTS_HOLE), initialized))
            return false;

        // Recursively copy dense elements.
        for (unsigned i = 0; i < initialized; i++) {
            if (!xdr->codeConstValue(values[i]))
                return false;
        }

        uint32_t copyOnWrite;
        if (mode == XDR_ENCODE)
            copyOnWrite = obj->is<ArrayObject>() &&
                          obj->as<ArrayObject>().denseElementsAreCopyOnWrite();
        if (!xdr->codeUint32(&copyOnWrite))
            return false;

        if (mode == XDR_DECODE) {
            ObjectGroup::NewArrayKind arrayKind = copyOnWrite
                                                  ? ObjectGroup::NewArrayKind::CopyOnWrite
                                                  : ObjectGroup::NewArrayKind::Normal;
            obj.set(ObjectGroup::newArrayObject(cx, values.begin(), values.length(),
                                                TenuredObject, arrayKind));
            if (!obj)
                return false;
        }

        return true;
    }

    // Code the properties in the object.
    Rooted<IdValueVector> properties(cx, IdValueVector(cx));
    if (mode == XDR_ENCODE && !GetScriptPlainObjectProperties(cx, obj, &properties))
        return false;

    uint32_t nproperties = properties.length();
    if (!xdr->codeUint32(&nproperties))
        return false;

    if (mode == XDR_DECODE && !properties.appendN(IdValuePair(), nproperties))
        return false;

    for (size_t i = 0; i < nproperties; i++) {
        if (mode == XDR_ENCODE) {
            tmpIdValue = IdToValue(properties[i].get().id);
            tmpValue = properties[i].get().value;
        }

        if (!xdr->codeConstValue(&tmpIdValue) || !xdr->codeConstValue(&tmpValue))
            return false;

        if (mode == XDR_DECODE) {
            if (!ValueToId<CanGC>(cx, tmpIdValue, &tmpId))
                return false;
            properties[i].get().id = tmpId;
            properties[i].get().value = tmpValue;
        }
    }

    // Code whether the object is a singleton.
    uint32_t isSingleton;
    if (mode == XDR_ENCODE)
        isSingleton = obj->isSingleton() ? 1 : 0;
    if (!xdr->codeUint32(&isSingleton))
        return false;

    if (mode == XDR_DECODE) {
        NewObjectKind newKind = isSingleton ? SingletonObject : TenuredObject;
        obj.set(ObjectGroup::newPlainObject(cx, properties.begin(), properties.length(), newKind));
        if (!obj)
            return false;
    }

    return true;
}

template bool
js::XDRObjectLiteral(XDRState<XDR_ENCODE>* xdr, MutableHandleObject obj);

template bool
js::XDRObjectLiteral(XDRState<XDR_DECODE>* xdr, MutableHandleObject obj);

bool
NativeObject::fillInAfterSwap(JSContext* cx, const Vector<Value>& values, void* priv)
{
    // This object has just been swapped with some other object, and its shape
    // no longer reflects its allocated size. Correct this information and
    // fill the slots in with the specified values.
    MOZ_ASSERT(slotSpan() == values.length());

    // Make sure the shape's numFixedSlots() is correct.
    size_t nfixed = gc::GetGCKindSlots(asTenured().getAllocKind(), getClass());
    if (nfixed != shape_->numFixedSlots()) {
        if (!generateOwnShape(cx))
            return false;
        shape_->setNumFixedSlots(nfixed);
    }

    if (hasPrivate())
        setPrivate(priv);
    else
        MOZ_ASSERT(!priv);

    if (slots_) {
        js_free(slots_);
        slots_ = nullptr;
    }

    if (size_t ndynamic = dynamicSlotsCount(nfixed, values.length(), getClass())) {
        slots_ = cx->zone()->pod_malloc<HeapSlot>(ndynamic);
        if (!slots_)
            return false;
        Debug_SetSlotRangeToCrashOnTouch(slots_, ndynamic);
    }

    initSlotRange(0, values.begin(), values.length());
    return true;
}

void
JSObject::fixDictionaryShapeAfterSwap()
{
    // Dictionary shapes can point back to their containing objects, so after
    // swapping the guts of those objects fix the pointers up.
    if (isNative() && as<NativeObject>().inDictionaryMode())
        as<NativeObject>().shape_->listp = &as<NativeObject>().shape_;
}

/* Use this method with extreme caution. It trades the guts of two objects. */
bool
JSObject::swap(JSContext* cx, HandleObject a, HandleObject b)
{
    // Ensure swap doesn't cause a finalizer to not be run.
    MOZ_ASSERT(IsBackgroundFinalized(a->asTenured().getAllocKind()) ==
               IsBackgroundFinalized(b->asTenured().getAllocKind()));
    MOZ_ASSERT(a->compartment() == b->compartment());

    AutoEnterOOMUnsafeRegion oomUnsafe;

    AutoCompartment ac(cx, a);

    if (!a->getGroup(cx))
        oomUnsafe.crash("JSObject::swap");
    if (!b->getGroup(cx))
        oomUnsafe.crash("JSObject::swap");

    /*
     * Neither object may be in the nursery, but ensure we update any embedded
     * nursery pointers in either object.
     */
    MOZ_ASSERT(!IsInsideNursery(a) && !IsInsideNursery(b));
    cx->runtime()->gc.storeBuffer.putWholeCell(a);
    cx->runtime()->gc.storeBuffer.putWholeCell(b);

    unsigned r = NotifyGCPreSwap(a, b);

    // Do the fundamental swapping of the contents of two objects.
    MOZ_ASSERT(a->compartment() == b->compartment());
    MOZ_ASSERT(a->is<JSFunction>() == b->is<JSFunction>());

    // Don't try to swap functions with different sizes.
    MOZ_ASSERT_IF(a->is<JSFunction>(), a->tenuredSizeOfThis() == b->tenuredSizeOfThis());

    // Watch for oddball objects that have special organizational issues and
    // can't be swapped.
    MOZ_ASSERT(!a->is<RegExpObject>() && !b->is<RegExpObject>());
    MOZ_ASSERT(!a->is<ArrayObject>() && !b->is<ArrayObject>());
    MOZ_ASSERT(!a->is<ArrayBufferObject>() && !b->is<ArrayBufferObject>());
    MOZ_ASSERT(!a->is<TypedArrayObject>() && !b->is<TypedArrayObject>());
    MOZ_ASSERT(!a->is<TypedObject>() && !b->is<TypedObject>());

    if (a->tenuredSizeOfThis() == b->tenuredSizeOfThis()) {
        // When both objects are the same size, just do a plain swap of their
        // contents.
        size_t size = a->tenuredSizeOfThis();

        char tmp[mozilla::tl::Max<sizeof(JSFunction), sizeof(JSObject_Slots16)>::value];
        MOZ_ASSERT(size <= sizeof(tmp));

        js_memcpy(tmp, a, size);
        js_memcpy(a, b, size);
        js_memcpy(b, tmp, size);

        a->fixDictionaryShapeAfterSwap();
        b->fixDictionaryShapeAfterSwap();
    } else {
        // Avoid GC in here to avoid confusing the tracing code with our
        // intermediate state.
        AutoSuppressGC suppress(cx);

        // When the objects have different sizes, they will have different
        // numbers of fixed slots before and after the swap, so the slots for
        // native objects will need to be rearranged.
        NativeObject* na = a->isNative() ? &a->as<NativeObject>() : nullptr;
        NativeObject* nb = b->isNative() ? &b->as<NativeObject>() : nullptr;

        // Remember the original values from the objects.
        Vector<Value> avals(cx);
        void* apriv = nullptr;
        if (na) {
            apriv = na->hasPrivate() ? na->getPrivate() : nullptr;
            for (size_t i = 0; i < na->slotSpan(); i++) {
                if (!avals.append(na->getSlot(i)))
                    oomUnsafe.crash("JSObject::swap");
            }
        }
        Vector<Value> bvals(cx);
        void* bpriv = nullptr;
        if (nb) {
            bpriv = nb->hasPrivate() ? nb->getPrivate() : nullptr;
            for (size_t i = 0; i < nb->slotSpan(); i++) {
                if (!bvals.append(nb->getSlot(i)))
                    oomUnsafe.crash("JSObject::swap");
            }
        }

        // Swap the main fields of the objects, whether they are native objects or proxies.
        char tmp[sizeof(JSObject_Slots0)];
        js_memcpy(&tmp, a, sizeof tmp);
        js_memcpy(a, b, sizeof tmp);
        js_memcpy(b, &tmp, sizeof tmp);

        a->fixDictionaryShapeAfterSwap();
        b->fixDictionaryShapeAfterSwap();

        if (na && !b->as<NativeObject>().fillInAfterSwap(cx, avals, apriv))
            oomUnsafe.crash("fillInAfterSwap");
        if (nb && !a->as<NativeObject>().fillInAfterSwap(cx, bvals, bpriv))
            oomUnsafe.crash("fillInAfterSwap");
    }

    // Swapping the contents of two objects invalidates type sets which contain
    // either of the objects, so mark all such sets as unknown.
    MarkObjectGroupUnknownProperties(cx, a->group());
    MarkObjectGroupUnknownProperties(cx, b->group());

    /*
     * We need a write barrier here. If |a| was marked and |b| was not, then
     * after the swap, |b|'s guts would never be marked. The write barrier
     * solves this.
     *
     * Normally write barriers happen before the write. However, that's not
     * necessary here because nothing is being destroyed. We're just swapping.
     */
    JS::Zone* zone = a->zone();
    if (zone->needsIncrementalBarrier()) {
        a->traceChildren(zone->barrierTracer());
        b->traceChildren(zone->barrierTracer());
    }

    NotifyGCPostSwap(a, b, r);
    return true;
}

static bool
DefineStandardSlot(JSContext* cx, HandleObject obj, JSProtoKey key, JSAtom* atom,
                   HandleValue v, uint32_t attrs, bool& named)
{
    RootedId id(cx, AtomToId(atom));
    named = DefineProperty(cx, obj, id, v, nullptr, nullptr, attrs);
    return named;
}

static void
SetClassObject(JSObject* obj, JSProtoKey key, JSObject* cobj, JSObject* proto)
{
    if (!obj->is<GlobalObject>())
        return;

    obj->as<GlobalObject>().setConstructor(key, ObjectOrNullValue(cobj));
    obj->as<GlobalObject>().setPrototype(key, ObjectOrNullValue(proto));
}

static void
ClearClassObject(JSObject* obj, JSProtoKey key)
{
    if (!obj->is<GlobalObject>())
        return;

    obj->as<GlobalObject>().setConstructor(key, UndefinedValue());
    obj->as<GlobalObject>().setPrototype(key, UndefinedValue());
}

static NativeObject*
DefineConstructorAndPrototype(JSContext* cx, HandleObject obj, JSProtoKey key, HandleAtom atom,
                              HandleObject protoProto, const Class* clasp,
                              Native constructor, unsigned nargs,
                              const JSPropertySpec* ps, const JSFunctionSpec* fs,
                              const JSPropertySpec* static_ps, const JSFunctionSpec* static_fs,
                              NativeObject** ctorp, AllocKind ctorKind)
{
    /*
     * Create a prototype object for this class.
     *
     * FIXME: lazy standard (built-in) class initialization and even older
     * eager boostrapping code rely on all of these properties:
     *
     * 1. NewObject attempting to compute a default prototype object when
     *    passed null for proto; and
     *
     * 2. NewObject tolerating no default prototype (null proto slot value)
     *    due to this js::InitClass call coming from js::InitFunctionClass on an
     *    otherwise-uninitialized global.
     *
     * 3. NewObject allocating a JSFunction-sized GC-thing when clasp is
     *    &JSFunction::class_, not a JSObject-sized (smaller) GC-thing.
     *
     * The JS_NewObjectForGivenProto and JS_NewObject APIs also allow clasp to
     * be &JSFunction::class_ (we could break compatibility easily). But
     * fixing (3) is not enough without addressing the bootstrapping dependency
     * on (1) and (2).
     */

    /*
     * Create the prototype object.  (GlobalObject::createBlankPrototype isn't
     * used because it won't let us use protoProto as the proto.
     */
    RootedNativeObject proto(cx, NewNativeObjectWithClassProto(cx, clasp, protoProto, SingletonObject));
    if (!proto)
        return nullptr;

    /* After this point, control must exit via label bad or out. */
    RootedNativeObject ctor(cx);
    bool named = false;
    bool cached = false;
    if (!constructor) {
        /*
         * Lacking a constructor, name the prototype (e.g., Math) unless this
         * class (a) is anonymous, i.e. for internal use only; (b) the class
         * of obj (the global object) is has a reserved slot indexed by key;
         * and (c) key is not the null key.
         */
        if (!(clasp->flags & JSCLASS_IS_ANONYMOUS) || !obj->is<GlobalObject>() ||
            key == JSProto_Null)
        {
            uint32_t attrs = (clasp->flags & JSCLASS_IS_ANONYMOUS)
                           ? JSPROP_READONLY | JSPROP_PERMANENT
                           : 0;
            RootedValue value(cx, ObjectValue(*proto));
            if (!DefineStandardSlot(cx, obj, key, atom, value, attrs, named))
                goto bad;
        }

        ctor = proto;
    } else {
        RootedFunction fun(cx, NewNativeConstructor(cx, constructor, nargs, atom, ctorKind));
        if (!fun)
            goto bad;

        /*
         * Set the class object early for standard class constructors. Type
         * inference may need to access these, and js::GetBuiltinPrototype will
         * fail if it tries to do a reentrant reconstruction of the class.
         */
        if (key != JSProto_Null) {
            SetClassObject(obj, key, fun, proto);
            cached = true;
        }

        RootedValue value(cx, ObjectValue(*fun));
        if (!DefineStandardSlot(cx, obj, key, atom, value, 0, named))
            goto bad;

        /*
         * Optionally construct the prototype object, before the class has
         * been fully initialized.  Allow the ctor to replace proto with a
         * different object, as is done for operator new.
         */
        ctor = fun;
        if (!LinkConstructorAndPrototype(cx, ctor, proto))
            goto bad;

        /* Bootstrap Function.prototype (see also JS_InitStandardClasses). */
        Rooted<TaggedProto> tagged(cx, TaggedProto(proto));
        if (ctor->getClass() == clasp && !ctor->splicePrototype(cx, clasp, tagged))
            goto bad;
    }

    if (!DefinePropertiesAndFunctions(cx, proto, ps, fs) ||
        (ctor != proto && !DefinePropertiesAndFunctions(cx, ctor, static_ps, static_fs)))
    {
        goto bad;
    }

    /* If this is a standard class, cache its prototype. */
    if (!cached && key != JSProto_Null)
        SetClassObject(obj, key, ctor, proto);

    if (ctorp)
        *ctorp = ctor;
    return proto;

bad:
    if (named) {
        ObjectOpResult ignored;
        RootedId id(cx, AtomToId(atom));

        // XXX FIXME - absurd to call this here; instead define the property last.
        DeleteProperty(cx, obj, id, ignored);
    }
    if (cached)
        ClearClassObject(obj, key);
    return nullptr;
}

NativeObject*
js::InitClass(JSContext* cx, HandleObject obj, HandleObject protoProto_,
              const Class* clasp, Native constructor, unsigned nargs,
              const JSPropertySpec* ps, const JSFunctionSpec* fs,
              const JSPropertySpec* static_ps, const JSFunctionSpec* static_fs,
              NativeObject** ctorp, AllocKind ctorKind)
{
    RootedObject protoProto(cx, protoProto_);

    /* Check function pointer members. */
    MOZ_ASSERT(clasp->getGetProperty() != JS_PropertyStub);
    MOZ_ASSERT(clasp->getSetProperty() != JS_StrictPropertyStub);

    RootedAtom atom(cx, Atomize(cx, clasp->name, strlen(clasp->name)));
    if (!atom)
        return nullptr;

    /*
     * All instances of the class will inherit properties from the prototype
     * object we are about to create (in DefineConstructorAndPrototype), which
     * in turn will inherit from protoProto.
     *
     * When initializing a standard class (other than Object), if protoProto is
     * null, default to Object.prototype. The engine's internal uses of
     * js::InitClass depend on this nicety.
     */
    JSProtoKey key = JSCLASS_CACHED_PROTO_KEY(clasp);
    if (key != JSProto_Null &&
        !protoProto &&
        !GetBuiltinPrototype(cx, JSProto_Object, &protoProto))
    {
        return nullptr;
    }

    return DefineConstructorAndPrototype(cx, obj, key, atom, protoProto, clasp, constructor, nargs,
                                         ps, fs, static_ps, static_fs, ctorp, ctorKind);
}

void
JSObject::fixupAfterMovingGC()
{
    // For copy-on-write objects that don't own their elements, fix up the
    // elements pointer if it points to inline elements in the owning object.
    if (is<NativeObject>()) {
        NativeObject& obj = as<NativeObject>();
        if (obj.denseElementsAreCopyOnWrite()) {
            NativeObject* owner = obj.getElementsHeader()->ownerObject();
            // Get the new owner pointer but don't call MaybeForwarded as we
            // don't need to access the object's shape.
            if (IsForwarded(owner))
                owner = Forwarded(owner);
            if (owner != &obj && owner->hasFixedElements())
                obj.elements_ = owner->getElementsHeader()->elements();
            MOZ_ASSERT(!IsForwarded(obj.getElementsHeader()->ownerObject().get()));
        }
    }
}

bool
js::SetClassAndProto(JSContext* cx, HandleObject obj,
                     const Class* clasp, Handle<js::TaggedProto> proto)
{
    // Regenerate the object's shape. If the object is a proto (isDelegate()),
    // we also need to regenerate shapes for all of the objects along the old
    // prototype chain, in case any entries were filled by looking up through
    // obj. Stop when a non-native object is found, prototype lookups will not
    // be cached across these.
    //
    // How this shape change is done is very delicate; the change can be made
    // either by marking the object's prototype as uncacheable (such that the
    // JIT'ed ICs cannot assume the shape determines the prototype) or by just
    // generating a new shape for the object. Choosing the former is bad if the
    // object is on the prototype chain of other objects, as the uncacheable
    // prototype can inhibit iterator caches on those objects and slow down
    // prototype accesses. Choosing the latter is bad if there are many similar
    // objects to this one which will have their prototype mutated, as the
    // generateOwnShape forces the object into dictionary mode and similar
    // property lineages will be repeatedly cloned.
    //
    // :XXX: bug 707717 make this code less brittle.
    RootedObject oldproto(cx, obj);
    while (oldproto && oldproto->isNative()) {
        if (oldproto->isSingleton()) {
            // We always generate a new shape if the object is a singleton,
            // regardless of the uncacheable-proto flag. ICs may rely on
            // this.
            if (!oldproto->as<NativeObject>().generateOwnShape(cx))
                return false;
        } else {
            if (!oldproto->setUncacheableProto(cx))
                return false;
        }
        if (!obj->isDelegate()) {
            // If |obj| is not a proto of another object, we don't need to
            // reshape the whole proto chain.
            MOZ_ASSERT(obj == oldproto);
            break;
        }
        oldproto = oldproto->staticPrototype();
    }

    if (proto.isObject() && !proto.toObject()->setDelegate(cx))
        return false;

    if (obj->isSingleton()) {
        /*
         * Just splice the prototype, but mark the properties as unknown for
         * consistent behavior.
         */
        if (!obj->splicePrototype(cx, clasp, proto))
            return false;
        MarkObjectGroupUnknownProperties(cx, obj->group());
        return true;
    }

    if (proto.isObject()) {
        RootedObject protoObj(cx, proto.toObject());
        if (!JSObject::setNewGroupUnknown(cx, clasp, protoObj))
            return false;
    }

    ObjectGroup* group = ObjectGroup::defaultNewGroup(cx, clasp, proto);
    if (!group)
        return false;

    /*
     * Setting __proto__ on an object that has escaped and may be referenced by
     * other heap objects can only be done if the properties of both objects
     * are unknown. Type sets containing this object will contain the original
     * type but not the new type of the object, so we need to treat all such
     * type sets as unknown.
     */
    MarkObjectGroupUnknownProperties(cx, obj->group());
    MarkObjectGroupUnknownProperties(cx, group);

    obj->setGroup(group);

    return true;
}

/* static */ bool
JSObject::changeToSingleton(JSContext* cx, HandleObject obj)
{
    MOZ_ASSERT(!obj->isSingleton());

    MarkObjectGroupUnknownProperties(cx, obj->group());

    ObjectGroup* group = ObjectGroup::lazySingletonGroup(cx, obj->getClass(),
                                                         obj->taggedProto());
    if (!group)
        return false;

    obj->group_ = group;
    return true;
}

static bool
MaybeResolveConstructor(ExclusiveContext* cxArg, Handle<GlobalObject*> global, JSProtoKey key)
{
    if (global->isStandardClassResolved(key))
        return true;
    if (!cxArg->shouldBeJSContext())
        return false;

    JSContext* cx = cxArg->asJSContext();
    return GlobalObject::resolveConstructor(cx, global, key);
}

bool
js::GetBuiltinConstructor(ExclusiveContext* cx, JSProtoKey key, MutableHandleObject objp)
{
    MOZ_ASSERT(key != JSProto_Null);
    Rooted<GlobalObject*> global(cx, cx->global());
    if (!MaybeResolveConstructor(cx, global, key))
        return false;

    objp.set(&global->getConstructor(key).toObject());
    return true;
}

bool
js::GetBuiltinPrototype(ExclusiveContext* cx, JSProtoKey key, MutableHandleObject protop)
{
    MOZ_ASSERT(key != JSProto_Null);
    Rooted<GlobalObject*> global(cx, cx->global());
    if (!MaybeResolveConstructor(cx, global, key))
        return false;

    protop.set(&global->getPrototype(key).toObject());
    return true;
}

bool
js::IsStandardPrototype(JSObject* obj, JSProtoKey key)
{
    GlobalObject& global = obj->global();
    Value v = global.getPrototype(key);
    return v.isObject() && obj == &v.toObject();
}


/**
 * Returns the original Object.prototype from the embedding-provided incumbent
 * global.
 *
 * Really, we want the incumbent global itself so we can pass it to other
 * embedding hooks which need it. Specifically, the enqueue promise hook
 * takes an incumbent global so it can set that on the PromiseCallbackJob
 * it creates.
 *
 * The reason for not just returning the global itself is that we'd need to
 * wrap it into the current compartment, and later unwrap it. Unwrapping
 * globals is tricky, though: we might accidentally unwrap through an inner
 * to its outer window and end up with the wrong global. Plain objects don't
 * have this problem, so we use the global's Object.prototype. The code using
 * it - e.g. EnqueuePromiseReactionJob - can then unwrap the object and get
 * its global without fear of unwrapping too far.
 */
bool
js::GetObjectFromIncumbentGlobal(JSContext* cx, MutableHandleObject obj)
{
    RootedObject globalObj(cx, cx->runtime()->getIncumbentGlobal(cx));
    if (!globalObj) {
        obj.set(nullptr);
        return true;
    }

    {
        AutoCompartment ac(cx, globalObj);
        obj.set(globalObj->as<GlobalObject>().getOrCreateObjectPrototype(cx));
        if (!obj)
            return false;
    }

    // The object might be from a different compartment, so wrap it.
    if (obj && !cx->compartment()->wrap(cx, obj))
        return false;

    return true;
}

JSProtoKey
JS::IdentifyStandardInstance(JSObject* obj)
{
    // Note: The prototype shares its JSClass with instances.
    MOZ_ASSERT(!obj->is<CrossCompartmentWrapperObject>());
    JSProtoKey key = StandardProtoKeyOrNull(obj);
    if (key != JSProto_Null && !IsStandardPrototype(obj, key))
        return key;
    return JSProto_Null;
}

JSProtoKey
JS::IdentifyStandardPrototype(JSObject* obj)
{
    // Note: The prototype shares its JSClass with instances.
    MOZ_ASSERT(!obj->is<CrossCompartmentWrapperObject>());
    JSProtoKey key = StandardProtoKeyOrNull(obj);
    if (key != JSProto_Null && IsStandardPrototype(obj, key))
        return key;
    return JSProto_Null;
}

JSProtoKey
JS::IdentifyStandardInstanceOrPrototype(JSObject* obj)
{
    return StandardProtoKeyOrNull(obj);
}

JSProtoKey
JS::IdentifyStandardConstructor(JSObject* obj)
{
    // Note that NATIVE_CTOR does not imply that we are a standard constructor,
    // but the converse is true (at least until we start having self-hosted
    // constructors for standard classes). This lets us avoid a costly loop for
    // many functions (which, depending on the call site, may be the common case).
    if (!obj->is<JSFunction>() || !(obj->as<JSFunction>().flags() & JSFunction::NATIVE_CTOR))
        return JSProto_Null;

    GlobalObject& global = obj->global();
    for (size_t k = 0; k < JSProto_LIMIT; ++k) {
        JSProtoKey key = static_cast<JSProtoKey>(k);
        if (global.getConstructor(key) == ObjectValue(*obj))
            return key;
    }

    return JSProto_Null;
}

bool
JSObject::isCallable() const
{
    if (is<JSFunction>())
        return true;
    return callHook() != nullptr;
}

bool
JSObject::isConstructor() const
{
    if (is<JSFunction>()) {
        const JSFunction& fun = as<JSFunction>();
        return fun.isConstructor();
    }
    return constructHook() != nullptr;
}

JSNative
JSObject::callHook() const
{
    const js::Class* clasp = getClass();

    if (JSNative call = clasp->getCall())
        return call;

    if (is<js::ProxyObject>()) {
        const js::ProxyObject& p = as<js::ProxyObject>();
        if (p.handler()->isCallable(const_cast<JSObject*>(this)))
            return js::proxy_Call;
    }
    return nullptr;
}

JSNative
JSObject::constructHook() const
{
    const js::Class* clasp = getClass();

    if (JSNative construct = clasp->getConstruct())
        return construct;

    if (is<js::ProxyObject>()) {
        const js::ProxyObject& p = as<js::ProxyObject>();
        if (p.handler()->isConstructor(const_cast<JSObject*>(this)))
            return js::proxy_Construct;
    }
    return nullptr;
}

bool
js::LookupProperty(JSContext* cx, HandleObject obj, js::HandleId id,
                   MutableHandleObject objp, MutableHandleShape propp)
{
    /* NB: The logic of lookupProperty is implicitly reflected in
     *     BaselineIC.cpp's |EffectlesslyLookupProperty| logic.
     *     If this changes, please remember to update the logic there as well.
     */
    if (LookupPropertyOp op = obj->getOpsLookupProperty())
        return op(cx, obj, id, objp, propp);
    return LookupPropertyInline<CanGC>(cx, obj.as<NativeObject>(), id, objp, propp);
}

bool
js::LookupName(JSContext* cx, HandlePropertyName name, HandleObject envChain,
               MutableHandleObject objp, MutableHandleObject pobjp, MutableHandleShape propp)
{
    RootedId id(cx, NameToId(name));

    for (RootedObject env(cx, envChain); env; env = env->enclosingEnvironment()) {
        if (!LookupProperty(cx, env, id, pobjp, propp))
            return false;
        if (propp) {
            objp.set(env);
            return true;
        }
    }

    objp.set(nullptr);
    pobjp.set(nullptr);
    propp.set(nullptr);
    return true;
}

bool
js::LookupNameNoGC(JSContext* cx, PropertyName* name, JSObject* envChain,
                   JSObject** objp, JSObject** pobjp, Shape** propp)
{
    AutoAssertNoException nogc(cx);

    MOZ_ASSERT(!*objp && !*pobjp && !*propp);

    for (JSObject* env = envChain; env; env = env->enclosingEnvironment()) {
        if (env->getOpsLookupProperty())
            return false;
        if (!LookupPropertyInline<NoGC>(cx, &env->as<NativeObject>(), NameToId(name), pobjp, propp))
            return false;
        if (*propp) {
            *objp = env;
            return true;
        }
    }

    return true;
}

bool
js::LookupNameWithGlobalDefault(JSContext* cx, HandlePropertyName name, HandleObject envChain,
                                MutableHandleObject objp)
{
    RootedId id(cx, NameToId(name));

    RootedObject pobj(cx);
    RootedShape shape(cx);

    RootedObject env(cx, envChain);
    for (; !env->is<GlobalObject>(); env = env->enclosingEnvironment()) {
        if (!LookupProperty(cx, env, id, &pobj, &shape))
            return false;
        if (shape)
            break;
    }

    objp.set(env);
    return true;
}

bool
js::LookupNameUnqualified(JSContext* cx, HandlePropertyName name, HandleObject envChain,
                          MutableHandleObject objp)
{
    RootedId id(cx, NameToId(name));

    RootedObject pobj(cx);
    RootedShape shape(cx);

    RootedObject env(cx, envChain);
    for (; !env->isUnqualifiedVarObj(); env = env->enclosingEnvironment()) {
        if (!LookupProperty(cx, env, id, &pobj, &shape))
            return false;
        if (shape)
            break;
    }

    // See note above RuntimeLexicalErrorObject.
    if (pobj == env) {
        bool isTDZ = false;
        if (shape && name != cx->names().dotThis) {
            // Treat Debugger environments specially for TDZ checks, as they
            // look like non-native environments but in fact wrap native
            // environments.
            if (env->is<DebugEnvironmentProxy>()) {
                RootedValue v(cx);
                if (!env->as<DebugEnvironmentProxy>().getMaybeSentinelValue(cx, id, &v))
                    return false;
                isTDZ = IsUninitializedLexical(v);
            } else {
                isTDZ = IsUninitializedLexicalSlot(env, shape);
            }
        }

        if (isTDZ) {
            env = RuntimeLexicalErrorObject::create(cx, env, JSMSG_UNINITIALIZED_LEXICAL);
            if (!env)
                return false;
        } else if (env->is<LexicalEnvironmentObject>() && !shape->writable()) {
            // Assigning to a named lambda callee name is a no-op in sloppy mode.
            Rooted<LexicalEnvironmentObject*> lexicalEnv(cx, &env->as<LexicalEnvironmentObject>());
            if (lexicalEnv->isExtensible() ||
                lexicalEnv->scope().kind() != ScopeKind::NamedLambda)
            {
                MOZ_ASSERT(name != cx->names().dotThis);
                env = RuntimeLexicalErrorObject::create(cx, env, JSMSG_BAD_CONST_ASSIGN);
                if (!env)
                    return false;
            }
        }
    }

    objp.set(env);
    return true;
}

bool
js::HasOwnProperty(JSContext* cx, HandleObject obj, HandleId id, bool* result)
{
    if (obj->is<ProxyObject>())
        return Proxy::hasOwn(cx, obj, id, result);

    if (GetOwnPropertyOp op = obj->getOpsGetOwnPropertyDescriptor()) {
        Rooted<PropertyDescriptor> desc(cx);
        if (!op(cx, obj, id, &desc))
            return false;
        *result = !!desc.object();
        return true;
    }

    RootedShape shape(cx);
    if (!NativeLookupOwnProperty<CanGC>(cx, obj.as<NativeObject>(), id, &shape))
        return false;
    *result = (shape != nullptr);
    return true;
}

bool
js::LookupPropertyPure(ExclusiveContext* cx, JSObject* obj, jsid id, JSObject** objp,
                       Shape** propp)
{
    bool isTypedArrayOutOfRange = false;
    do {
        if (!LookupOwnPropertyPure(cx, obj, id, propp, &isTypedArrayOutOfRange))
            return false;

        if (*propp) {
            *objp = obj;
            return true;
        }

        if (isTypedArrayOutOfRange) {
            *objp = nullptr;
            return true;
        }

        obj = obj->staticPrototype();
    } while (obj);

    *objp = nullptr;
    *propp = nullptr;
    return true;
}

bool
js::LookupOwnPropertyPure(ExclusiveContext* cx, JSObject* obj, jsid id, Shape** propp,
                          bool* isTypedArrayOutOfRange /* = nullptr */)
{
    JS::AutoCheckCannotGC nogc;
    if (isTypedArrayOutOfRange)
        *isTypedArrayOutOfRange = false;

    if (obj->isNative()) {
        // Search for a native dense element, typed array element, or property.

        if (JSID_IS_INT(id) && obj->as<NativeObject>().containsDenseElement(JSID_TO_INT(id))) {
            MarkDenseOrTypedArrayElementFound<NoGC>(propp);
            return true;
        }

        if (obj->is<TypedArrayObject>()) {
            uint64_t index;
            if (IsTypedArrayIndex(id, &index)) {
                if (index < obj->as<TypedArrayObject>().length()) {
                    MarkDenseOrTypedArrayElementFound<NoGC>(propp);
                } else {
                    *propp = nullptr;
                    if (isTypedArrayOutOfRange)
                        *isTypedArrayOutOfRange = true;
                }
                return true;
            }
        }

        if (Shape* shape = obj->as<NativeObject>().lookupPure(id)) {
            *propp = shape;
            return true;
        }

        // Fail if there's a resolve hook, unless the mayResolve hook tells
        // us the resolve hook won't define a property with this id.
        if (ClassMayResolveId(cx->names(), obj->getClass(), id, obj))
            return false;
    } else if (obj->is<UnboxedPlainObject>()) {
        if (obj->as<UnboxedPlainObject>().containsUnboxedOrExpandoProperty(cx, id)) {
            MarkNonNativePropertyFound<NoGC>(propp);
            return true;
        }
    } else if (obj->is<UnboxedArrayObject>()) {
        if (obj->as<UnboxedArrayObject>().containsProperty(cx, id)) {
            MarkNonNativePropertyFound<NoGC>(propp);
            return true;
        }
    } else if (obj->is<TypedObject>()) {
        if (obj->as<TypedObject>().typeDescr().hasProperty(cx->names(), id)) {
            MarkNonNativePropertyFound<NoGC>(propp);
            return true;
        }
    } else {
        return false;
    }

    *propp = nullptr;
    return true;
}

static inline bool
NativeGetPureInline(NativeObject* pobj, Shape* shape, Value* vp)
{
    /* Fail if we have a custom getter. */
    if (!shape->hasDefaultGetter())
        return false;

    if (shape->hasSlot()) {
        *vp = pobj->getSlot(shape->slot());
        MOZ_ASSERT(!vp->isMagic());
    } else {
        vp->setUndefined();
    }

    return true;
}

bool
js::GetPropertyPure(ExclusiveContext* cx, JSObject* obj, jsid id, Value* vp)
{
    JSObject* pobj;
    Shape* shape;
    if (!LookupPropertyPure(cx, obj, id, &pobj, &shape))
        return false;

    if (!shape) {
        vp->setUndefined();
        return true;
    }

    return pobj->isNative() && NativeGetPureInline(&pobj->as<NativeObject>(), shape, vp);
}

static inline bool
NativeGetGetterPureInline(Shape* shape, JSFunction** fp)
{
    if (shape->hasGetterObject()) {
        if (shape->getterObject()->is<JSFunction>()) {
            *fp = &shape->getterObject()->as<JSFunction>();
            return true;
        }
    }

    *fp = nullptr;
    return true;
}

bool
js::GetGetterPure(ExclusiveContext* cx, JSObject* obj, jsid id, JSFunction** fp)
{
    /* Just like GetPropertyPure, but get getter function, without invoking
     * it. */
    JSObject* pobj;
    Shape* shape;
    if (!LookupPropertyPure(cx, obj, id, &pobj, &shape))
        return false;

    if (!shape) {
        *fp = nullptr;
        return true;
    }

    return pobj->isNative() && NativeGetGetterPureInline(shape, fp);
}

bool
js::GetOwnGetterPure(ExclusiveContext* cx, JSObject* obj, jsid id, JSFunction** fp)
{
    JS::AutoCheckCannotGC nogc;
    Shape* shape;
    if (!LookupOwnPropertyPure(cx, obj, id, &shape))
        return false;

    if (!shape) {
        *fp = nullptr;
        return true;
    }

    return NativeGetGetterPureInline(shape, fp);
}

bool
js::GetOwnNativeGetterPure(JSContext* cx, JSObject* obj, jsid id, JSNative* native)
{
    JS::AutoCheckCannotGC nogc;
    *native = nullptr;
    Shape* shape;
    if (!LookupOwnPropertyPure(cx, obj, id, &shape))
        return false;

    if (!shape || IsImplicitDenseOrTypedArrayElement(shape) || !shape->hasGetterObject())
        return true;

    JSObject* getterObj = shape->getterObject();
    if (!getterObj->is<JSFunction>())
        return true;

    JSFunction* getter = &getterObj->as<JSFunction>();
    if (!getter->isNative())
        return true;

    *native = getter->native();
    return true;
}

bool
js::HasOwnDataPropertyPure(JSContext* cx, JSObject* obj, jsid id, bool* result)
{
    Shape* shape = nullptr;
    if (!LookupOwnPropertyPure(cx, obj, id, &shape))
        return false;

    *result = shape && !IsImplicitDenseOrTypedArrayElement(shape) && shape->hasDefaultGetter() &&
              shape->hasSlot();
    return true;
}

bool
JSObject::reportReadOnly(JSContext* cx, jsid id, unsigned report)
{
    RootedValue val(cx, IdToValue(id));
    return ReportValueErrorFlags(cx, report, JSMSG_READ_ONLY,
                                 JSDVG_IGNORE_STACK, val, nullptr,
                                 nullptr, nullptr);
}

bool
JSObject::reportNotConfigurable(JSContext* cx, jsid id, unsigned report)
{
    RootedValue val(cx, IdToValue(id));
    return ReportValueErrorFlags(cx, report, JSMSG_CANT_DELETE,
                                 JSDVG_IGNORE_STACK, val, nullptr,
                                 nullptr, nullptr);
}

bool
JSObject::reportNotExtensible(JSContext* cx, unsigned report)
{
    RootedValue val(cx, ObjectValue(*this));
    return ReportValueErrorFlags(cx, report, JSMSG_OBJECT_NOT_EXTENSIBLE,
                                 JSDVG_IGNORE_STACK, val, nullptr,
                                 nullptr, nullptr);
}

bool
js::GetPrototypeIfOrdinary(JSContext* cx, HandleObject obj, bool* isOrdinary,
                           MutableHandleObject protop)
{
    if (obj->is<js::ProxyObject>())
        return js::Proxy::getPrototypeIfOrdinary(cx, obj, isOrdinary, protop);

    *isOrdinary = true;
    protop.set(obj->staticPrototype());
    return true;
}

/*** ES6 standard internal methods ***************************************************************/

bool
js::SetPrototype(JSContext* cx, HandleObject obj, HandleObject proto, JS::ObjectOpResult& result)
{
    // The proxy trap subsystem fully handles prototype-setting for proxies
    // with dynamic [[Prototype]]s.
    if (obj->hasDynamicPrototype()) {
        MOZ_ASSERT(obj->is<ProxyObject>());
        return Proxy::setPrototype(cx, obj, proto, result);
    }

    /*
     * ES6 9.1.2 step 3-4 if |obj.[[Prototype]]| has SameValue as |proto| return true.
     * Since the values in question are objects, we can just compare pointers.
     */
    if (proto == obj->staticPrototype())
        return result.succeed();

    /* Disallow mutation of immutable [[Prototype]]s. */
    if (obj->staticPrototypeIsImmutable())
        return result.fail(JSMSG_CANT_SET_PROTO);

    /*
     * Disallow mutating the [[Prototype]] on ArrayBuffer objects, which
     * due to their complicated delegate-object shenanigans can't easily
     * have a mutable [[Prototype]].
     */
    if (obj->is<ArrayBufferObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_SET_PROTO_OF,
                                  "incompatible ArrayBuffer");
        return false;
    }

    /*
     * Disallow mutating the [[Prototype]] on Typed Objects, per the spec.
     */
    if (obj->is<TypedObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_SET_PROTO_OF,
                                  "incompatible TypedObject");
        return false;
    }

    /* ES6 9.1.2 step 5 forbids changing [[Prototype]] if not [[Extensible]]. */
    bool extensible;
    if (!IsExtensible(cx, obj, &extensible))
        return false;
    if (!extensible)
        return result.fail(JSMSG_CANT_SET_PROTO);

    // If this is a global object, resolve the Object class so that its
    // [[Prototype]] chain is always properly immutable, even in the presence
    // of lazy standard classes.
    if (obj->is<GlobalObject>()) {
        Rooted<GlobalObject*> global(cx, &obj->as<GlobalObject>());
        if (!GlobalObject::ensureConstructor(cx, global, JSProto_Object))
            return false;
    }

    /*
     * ES6 9.1.2 step 6 forbids generating cyclical prototype chains. But we
     * have to do this comparison on the observable WindowProxy, not on the
     * possibly-Window object we're setting the proto on.
     */
    RootedObject objMaybeWindowProxy(cx, ToWindowProxyIfWindow(obj));
    RootedObject obj2(cx, proto);
    while (obj2) {
        MOZ_ASSERT(!IsWindow(obj2));
        if (obj2 == objMaybeWindowProxy)
            return result.fail(JSMSG_CANT_SET_PROTO_CYCLE);

        bool isOrdinary;
        if (!GetPrototypeIfOrdinary(cx, obj2, &isOrdinary, &obj2))
            return false;
        if (!isOrdinary)
            break;
    }

    // Convert unboxed objects to their native representations before changing
    // their prototype/group, as they depend on the group for their layout.
    if (!MaybeConvertUnboxedObjectToNative(cx, obj))
        return false;

    Rooted<TaggedProto> taggedProto(cx, TaggedProto(proto));
    if (!SetClassAndProto(cx, obj, obj->getClass(), taggedProto))
        return false;

    return result.succeed();
}

bool
js::SetPrototype(JSContext* cx, HandleObject obj, HandleObject proto)
{
    ObjectOpResult result;
    return SetPrototype(cx, obj, proto, result) && result.checkStrict(cx, obj);
}

bool
js::PreventExtensions(JSContext* cx, HandleObject obj, ObjectOpResult& result, IntegrityLevel level)
{
    if (obj->is<ProxyObject>())
        return js::Proxy::preventExtensions(cx, obj, result);

    if (!obj->nonProxyIsExtensible())
        return result.succeed();

    if (!MaybeConvertUnboxedObjectToNative(cx, obj))
        return false;

    // Force lazy properties to be resolved.
    AutoIdVector props(cx);
    if (!js::GetPropertyKeys(cx, obj, JSITER_HIDDEN | JSITER_OWNONLY, &props))
        return false;

    // Actually prevent extension. If the object is being frozen, do it by
    // setting the frozen flag on both the object and the object group.
    // Otherwise, fallback to sparsifying the object, which makes sure no
    // element can be added without a call to isExtensible, at the cost of
    // performance.
    if (obj->isNative()) {
        if (level == IntegrityLevel::Frozen) {
            MarkObjectGroupFlags(cx, obj, OBJECT_FLAG_FROZEN);
            if (!ObjectElements::FreezeElements(cx, obj.as<NativeObject>()))
                return false;
        } else if (!NativeObject::sparsifyDenseElements(cx, obj.as<NativeObject>())) {
            return false;
        }
    }

    if (!obj->setFlags(cx, BaseShape::NOT_EXTENSIBLE, JSObject::GENERATE_SHAPE)) {
        // We failed to mark the object non-extensible, so reset the frozen
        // flag on the elements.
        MOZ_ASSERT(obj->nonProxyIsExtensible());
        if (obj->isNative() && obj->as<NativeObject>().getElementsHeader()->isFrozen())
            obj->as<NativeObject>().getElementsHeader()->markNotFrozen();
        return false;
    }

    return result.succeed();
}

bool
js::PreventExtensions(JSContext* cx, HandleObject obj, IntegrityLevel level)
{
    ObjectOpResult result;
    return PreventExtensions(cx, obj, result, level) && result.checkStrict(cx, obj);
}

bool
js::GetOwnPropertyDescriptor(JSContext* cx, HandleObject obj, HandleId id,
                             MutableHandle<PropertyDescriptor> desc)
{
    if (GetOwnPropertyOp op = obj->getOpsGetOwnPropertyDescriptor()) {
        bool ok = op(cx, obj, id, desc);
        if (ok)
            desc.assertCompleteIfFound();
        return ok;
    }

    return NativeGetOwnPropertyDescriptor(cx, obj.as<NativeObject>(), id, desc);
}

bool
js::DefineProperty(JSContext* cx, HandleObject obj, HandleId id, Handle<PropertyDescriptor> desc)
{
    ObjectOpResult result;
    return DefineProperty(cx, obj, id, desc, result) &&
           result.checkStrict(cx, obj, id);
}

bool
js::DefineProperty(JSContext* cx, HandleObject obj, HandleId id, Handle<PropertyDescriptor> desc,
                   ObjectOpResult& result)
{
    desc.assertValid();
    if (DefinePropertyOp op = obj->getOpsDefineProperty())
        return op(cx, obj, id, desc, result);
    return NativeDefineProperty(cx, obj.as<NativeObject>(), id, desc, result);
}

bool
js::DefineProperty(ExclusiveContext* cx, HandleObject obj, HandleId id, HandleValue value,
                   JSGetterOp getter, JSSetterOp setter, unsigned attrs,
                   ObjectOpResult& result)
{
    MOZ_ASSERT(!(attrs & JSPROP_PROPOP_ACCESSORS));

    Rooted<PropertyDescriptor> desc(cx);
    desc.initFields(nullptr, value, attrs, getter, setter);
    if (DefinePropertyOp op = obj->getOpsDefineProperty()) {
        if (!cx->shouldBeJSContext())
            return false;
        return op(cx->asJSContext(), obj, id, desc, result);
    }
    return NativeDefineProperty(cx, obj.as<NativeObject>(), id, desc, result);
}

bool
js::DefineProperty(ExclusiveContext* cx, HandleObject obj, PropertyName* name, HandleValue value,
                   JSGetterOp getter, JSSetterOp setter, unsigned attrs,
                   ObjectOpResult& result)
{
    RootedId id(cx, NameToId(name));
    return DefineProperty(cx, obj, id, value, getter, setter, attrs, result);
}

bool
js::DefineElement(ExclusiveContext* cx, HandleObject obj, uint32_t index, HandleValue value,
                  JSGetterOp getter, JSSetterOp setter, unsigned attrs,
                  ObjectOpResult& result)
{
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);

    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return DefineProperty(cx, obj, id, value, getter, setter, attrs, result);
}

bool
js::DefineProperty(ExclusiveContext* cx, HandleObject obj, HandleId id, HandleValue value,
                   JSGetterOp getter, JSSetterOp setter, unsigned attrs)
{
    ObjectOpResult result;
    if (!DefineProperty(cx, obj, id, value, getter, setter, attrs, result))
        return false;
    if (!result) {
        if (!cx->shouldBeJSContext())
            return false;
        result.reportError(cx->asJSContext(), obj, id);
        return false;
    }
    return true;
}

bool
js::DefineProperty(ExclusiveContext* cx, HandleObject obj, PropertyName* name, HandleValue value,
                   JSGetterOp getter, JSSetterOp setter, unsigned attrs)
{
    RootedId id(cx, NameToId(name));
    return DefineProperty(cx, obj, id, value, getter, setter, attrs);
}

bool
js::DefineElement(ExclusiveContext* cx, HandleObject obj, uint32_t index, HandleValue value,
                  JSGetterOp getter, JSSetterOp setter, unsigned attrs)
{
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);

    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;
    return DefineProperty(cx, obj, id, value, getter, setter, attrs);
}


/*** SpiderMonkey nonstandard internal methods ***************************************************/

bool
js::SetImmutablePrototype(ExclusiveContext* cx, HandleObject obj, bool* succeeded)
{
    if (obj->hasDynamicPrototype()) {
        if (!cx->shouldBeJSContext())
            return false;
        return Proxy::setImmutablePrototype(cx->asJSContext(), obj, succeeded);
    }

    if (!obj->setFlags(cx, BaseShape::IMMUTABLE_PROTOTYPE))
        return false;
    *succeeded = true;
    return true;
}

bool
js::GetPropertyDescriptor(JSContext* cx, HandleObject obj, HandleId id,
                          MutableHandle<PropertyDescriptor> desc)
{
    RootedObject pobj(cx);

    for (pobj = obj; pobj;) {
        if (pobj->is<ProxyObject>()) {
            bool ok = Proxy::getPropertyDescriptor(cx, pobj, id, desc);
            if (ok)
                desc.assertCompleteIfFound();
            return ok;
        }

        if (!GetOwnPropertyDescriptor(cx, pobj, id, desc))
            return false;

        if (desc.object())
            return true;

        if (!GetPrototype(cx, pobj, &pobj))
            return false;
    }

    MOZ_ASSERT(!desc.object());
    return true;
}

bool
js::WatchGuts(JSContext* cx, JS::HandleObject origObj, JS::HandleId id, JS::HandleObject callable)
{
    RootedObject obj(cx, ToWindowIfWindowProxy(origObj));
    if (obj->isNative()) {
        // Use sparse indexes for watched objects, as dense elements can be
        // written to without checking the watchpoint map.
        if (!NativeObject::sparsifyDenseElements(cx, obj.as<NativeObject>()))
            return false;

        MarkTypePropertyNonData(cx, obj, id);
    }

    WatchpointMap* wpmap = cx->compartment()->watchpointMap;
    if (!wpmap) {
        wpmap = cx->runtime()->new_<WatchpointMap>();
        if (!wpmap || !wpmap->init()) {
            ReportOutOfMemory(cx);
            js_delete(wpmap);
            return false;
        }
        cx->compartment()->watchpointMap = wpmap;
    }

    return wpmap->watch(cx, obj, id, js::WatchHandler, callable);
}

bool
js::UnwatchGuts(JSContext* cx, JS::HandleObject origObj, JS::HandleId id)
{
    // Looking in the map for an unsupported object will never hit, so we don't
    // need to check for nativeness or watchable-ness here.
    RootedObject obj(cx, ToWindowIfWindowProxy(origObj));
    if (WatchpointMap* wpmap = cx->compartment()->watchpointMap)
        wpmap->unwatch(obj, id, nullptr, nullptr);
    return true;
}

bool
js::WatchProperty(JSContext* cx, HandleObject obj, HandleId id, HandleObject callable)
{
    if (WatchOp op = obj->getOpsWatch())
        return op(cx, obj, id, callable);

    if (!obj->isNative() || obj->is<TypedArrayObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_WATCH,
                                  obj->getClass()->name);
        return false;
    }

    return WatchGuts(cx, obj, id, callable);
}

bool
js::UnwatchProperty(JSContext* cx, HandleObject obj, HandleId id)
{
    if (UnwatchOp op = obj->getOpsUnwatch())
        return op(cx, obj, id);

    return UnwatchGuts(cx, obj, id);
}

const char*
js::GetObjectClassName(JSContext* cx, HandleObject obj)
{
    assertSameCompartment(cx, obj);

    if (obj->is<ProxyObject>())
        return Proxy::className(cx, obj);

    return obj->getClass()->name;
}


/* * */

bool
js::HasDataProperty(JSContext* cx, NativeObject* obj, jsid id, Value* vp)
{
    if (JSID_IS_INT(id) && obj->containsDenseElement(JSID_TO_INT(id))) {
        *vp = obj->getDenseElement(JSID_TO_INT(id));
        return true;
    }

    if (Shape* shape = obj->lookup(cx, id)) {
        if (shape->hasDefaultGetter() && shape->hasSlot()) {
            *vp = obj->getSlot(shape->slot());
            return true;
        }
    }

    return false;
}

extern bool
PropertySpecNameToId(JSContext* cx, const char* name, MutableHandleId id,
                     js::PinningBehavior pin = js::DoNotPinAtom);

static bool
DefineFunctionFromSpec(JSContext* cx, HandleObject obj, const JSFunctionSpec* fs, unsigned flags,
                       DefineAsIntrinsic intrinsic)
{
    GetterOp gop;
    SetterOp sop;
    if (flags & JSFUN_STUB_GSOPS) {
        // JSFUN_STUB_GSOPS is a request flag only, not stored in fun->flags or
        // the defined property's attributes.
        flags &= ~JSFUN_STUB_GSOPS;
        gop = nullptr;
        sop = nullptr;
    } else {
        gop = obj->getClass()->getGetProperty();
        sop = obj->getClass()->getSetProperty();
        MOZ_ASSERT(gop != JS_PropertyStub);
        MOZ_ASSERT(sop != JS_StrictPropertyStub);
    }

    RootedId id(cx);
    if (!PropertySpecNameToId(cx, fs->name, &id))
        return false;

    JSFunction* fun = NewFunctionFromSpec(cx, fs, id);
    if (!fun)
        return false;

    if (intrinsic == AsIntrinsic)
        fun->setIsIntrinsic();

    RootedValue funVal(cx, ObjectValue(*fun));
    return DefineProperty(cx, obj, id, funVal, gop, sop, flags & ~JSFUN_FLAGS_MASK);
}

bool
js::DefineFunctions(JSContext* cx, HandleObject obj, const JSFunctionSpec* fs,
                    DefineAsIntrinsic intrinsic)
{
    for (; fs->name; fs++) {
        if (!DefineFunctionFromSpec(cx, obj, fs, fs->flags, intrinsic))
            return false;
    }
    return true;
}


/*** ToPrimitive *************************************************************/

/*
 * Gets |obj[id]|.  If that value's not callable, returns true and stores an
 * object value in *vp.  If it's callable, calls it with no arguments and |obj|
 * as |this|, returning the result in *vp.
 *
 * This is a mini-abstraction for ES6 draft rev 36 (2015 Mar 17),
 * 7.1.1, second algorithm (OrdinaryToPrimitive), steps 5.a-c.
 */
static bool
MaybeCallMethod(JSContext* cx, HandleObject obj, HandleId id, MutableHandleValue vp)
{
    if (!GetProperty(cx, obj, obj, id, vp))
        return false;
    if (!IsCallable(vp)) {
        vp.setObject(*obj);
        return true;
    }

    return js::Call(cx, vp, obj, vp);
}

static bool
ReportCantConvert(JSContext* cx, unsigned errorNumber, HandleObject obj, JSType hint)
{
    const Class* clasp = obj->getClass();

    // Avoid recursive death when decompiling in ReportValueError.
    RootedString str(cx);
    if (hint == JSTYPE_STRING) {
        str = JS_AtomizeAndPinString(cx, clasp->name);
        if (!str)
            return false;
    } else {
        str = nullptr;
    }

    RootedValue val(cx, ObjectValue(*obj));
    ReportValueError2(cx, errorNumber, JSDVG_SEARCH_STACK, val, str,
                      hint == JSTYPE_VOID
                      ? "primitive type"
                      : hint == JSTYPE_STRING ? "string" : "number");
    return false;
}

bool
JS::OrdinaryToPrimitive(JSContext* cx, HandleObject obj, JSType hint, MutableHandleValue vp)
{
    MOZ_ASSERT(hint == JSTYPE_NUMBER || hint == JSTYPE_STRING || hint == JSTYPE_VOID);

    Rooted<jsid> id(cx);

    const Class* clasp = obj->getClass();
    if (hint == JSTYPE_STRING) {
        id = NameToId(cx->names().toString);

        /* Optimize (new String(...)).toString(). */
        if (clasp == &StringObject::class_) {
            StringObject* nobj = &obj->as<StringObject>();
            if (ClassMethodIsNative(cx, nobj, &StringObject::class_, id, str_toString)) {
                vp.setString(nobj->unbox());
                return true;
            }
        }

        if (!MaybeCallMethod(cx, obj, id, vp))
            return false;
        if (vp.isPrimitive())
            return true;

        id = NameToId(cx->names().valueOf);
        if (!MaybeCallMethod(cx, obj, id, vp))
            return false;
        if (vp.isPrimitive())
            return true;
    } else {
        id = NameToId(cx->names().valueOf);

        /* Optimize new String(...).valueOf(). */
        if (clasp == &StringObject::class_) {
            StringObject* nobj = &obj->as<StringObject>();
            if (ClassMethodIsNative(cx, nobj, &StringObject::class_, id, str_toString)) {
                vp.setString(nobj->unbox());
                return true;
            }
        }

        /* Optimize new Number(...).valueOf(). */
        if (clasp == &NumberObject::class_) {
            NumberObject* nobj = &obj->as<NumberObject>();
            if (ClassMethodIsNative(cx, nobj, &NumberObject::class_, id, num_valueOf)) {
                vp.setNumber(nobj->unbox());
                return true;
            }
        }

        if (!MaybeCallMethod(cx, obj, id, vp))
            return false;
        if (vp.isPrimitive())
            return true;

        id = NameToId(cx->names().toString);
        if (!MaybeCallMethod(cx, obj, id, vp))
            return false;
        if (vp.isPrimitive())
            return true;
    }

    return ReportCantConvert(cx, JSMSG_CANT_CONVERT_TO, obj, hint);
}

bool
js::ToPrimitiveSlow(JSContext* cx, JSType preferredType, MutableHandleValue vp)
{
    // Step numbers refer to the first algorithm listed in ES6 draft rev 36
    // (2015 Mar 17) 7.1.1 ToPrimitive.
    MOZ_ASSERT(preferredType == JSTYPE_VOID ||
               preferredType == JSTYPE_STRING ||
               preferredType == JSTYPE_NUMBER);
    RootedObject obj(cx, &vp.toObject());

    // Steps 4-5.
    RootedId id(cx, SYMBOL_TO_JSID(cx->wellKnownSymbols().toPrimitive));
    RootedValue method(cx);
    if (!GetProperty(cx, obj, obj, id, &method))
        return false;

    // Step 6.
    if (!method.isUndefined()) {
        // Step 6 of GetMethod. js::Call() below would do this check and throw a
        // TypeError anyway, but this produces a better error message.
        if (!IsCallable(method))
            return ReportCantConvert(cx, JSMSG_TOPRIMITIVE_NOT_CALLABLE, obj, preferredType);

        // Steps 1-3, 6.a-b.
        RootedValue arg0(cx, StringValue(preferredType == JSTYPE_STRING
                                         ? cx->names().string
                                         : preferredType == JSTYPE_NUMBER
                                         ? cx->names().number
                                         : cx->names().default_));

        if (!js::Call(cx, method, vp, arg0, vp))
            return false;

        // Steps 6.c-d.
        if (vp.isObject())
            return ReportCantConvert(cx, JSMSG_TOPRIMITIVE_RETURNED_OBJECT, obj, preferredType);
        return true;
    }

    return OrdinaryToPrimitive(cx, obj, preferredType, vp);
}


/* * */

bool
js::IsDelegate(JSContext* cx, HandleObject obj, const js::Value& v, bool* result)
{
    if (v.isPrimitive()) {
        *result = false;
        return true;
    }
    return IsDelegateOfObject(cx, obj, &v.toObject(), result);
}

bool
js::IsDelegateOfObject(JSContext* cx, HandleObject protoObj, JSObject* obj, bool* result)
{
    RootedObject obj2(cx, obj);
    for (;;) {
        if (!GetPrototype(cx, obj2, &obj2))
            return false;
        if (!obj2) {
            *result = false;
            return true;
        }
        if (obj2 == protoObj) {
            *result = true;
            return true;
        }
    }
}

JSObject*
js::GetBuiltinPrototypePure(GlobalObject* global, JSProtoKey protoKey)
{
    MOZ_ASSERT(JSProto_Null <= protoKey);
    MOZ_ASSERT(protoKey < JSProto_LIMIT);

    if (protoKey != JSProto_Null) {
        const Value& v = global->getPrototype(protoKey);
        if (v.isObject())
            return &v.toObject();
    }

    return nullptr;
}

JSObject*
js::PrimitiveToObject(JSContext* cx, const Value& v)
{
    if (v.isString()) {
        Rooted<JSString*> str(cx, v.toString());
        return StringObject::create(cx, str);
    }
    if (v.isNumber())
        return NumberObject::create(cx, v.toNumber());
    if (v.isBoolean())
        return BooleanObject::create(cx, v.toBoolean());
    MOZ_ASSERT(v.isSymbol());
    RootedSymbol symbol(cx, v.toSymbol());
    return SymbolObject::create(cx, symbol);
}

/*
 * Invokes the ES5 ToObject algorithm on vp, returning the result. If vp might
 * already be an object, use ToObject. reportCantConvert controls how null and
 * undefined errors are reported.
 *
 * Callers must handle the already-object case.
 */
JSObject*
js::ToObjectSlow(JSContext* cx, JS::HandleValue val, bool reportScanStack)
{
    MOZ_ASSERT(!val.isMagic());
    MOZ_ASSERT(!val.isObject());

    if (val.isNullOrUndefined()) {
        if (reportScanStack) {
            ReportIsNullOrUndefined(cx, JSDVG_SEARCH_STACK, val, nullptr);
        } else {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_CANT_CONVERT_TO,
                                      val.isNull() ? "null" : "undefined", "object");
        }
        return nullptr;
    }

    return PrimitiveToObject(cx, val);
}

Value
js::GetThisValue(JSObject* obj)
{
    if (obj->is<GlobalObject>())
        return ObjectValue(*ToWindowProxyIfWindow(obj));

    if (obj->is<LexicalEnvironmentObject>()) {
        if (!obj->as<LexicalEnvironmentObject>().isExtensible())
            return UndefinedValue();
        return obj->as<LexicalEnvironmentObject>().thisValue();
    }

    if (obj->is<ModuleEnvironmentObject>())
        return UndefinedValue();

    if (obj->is<WithEnvironmentObject>())
        return ObjectValue(*obj->as<WithEnvironmentObject>().withThis());

    if (obj->is<NonSyntacticVariablesObject>())
        return GetThisValue(obj->enclosingEnvironment());

    return ObjectValue(*obj);
}

class GetObjectSlotNameFunctor : public JS::CallbackTracer::ContextFunctor
{
    JSObject* obj;

  public:
    explicit GetObjectSlotNameFunctor(JSObject* ctx) : obj(ctx) {}
    virtual void operator()(JS::CallbackTracer* trc, char* buf, size_t bufsize) override;
};

void
GetObjectSlotNameFunctor::operator()(JS::CallbackTracer* trc, char* buf, size_t bufsize)
{
    MOZ_ASSERT(trc->contextIndex() != JS::CallbackTracer::InvalidIndex);

    uint32_t slot = uint32_t(trc->contextIndex());

    Shape* shape;
    if (obj->isNative()) {
        shape = obj->as<NativeObject>().lastProperty();
        while (shape && (!shape->hasSlot() || shape->slot() != slot))
            shape = shape->previous();
    } else {
        shape = nullptr;
    }

    if (!shape) {
        do {
            const char* slotname = nullptr;
            const char* pattern = nullptr;
            if (obj->is<GlobalObject>()) {
                pattern = "CLASS_OBJECT(%s)";
                if (false)
                    ;
#define TEST_SLOT_MATCHES_PROTOTYPE(name,code,init,clasp) \
                else if ((code) == slot) { slotname = js_##name##_str; }
                JS_FOR_EACH_PROTOTYPE(TEST_SLOT_MATCHES_PROTOTYPE)
#undef TEST_SLOT_MATCHES_PROTOTYPE
            } else {
                pattern = "%s";
                if (obj->is<EnvironmentObject>()) {
                    if (slot == EnvironmentObject::enclosingEnvironmentSlot()) {
                        slotname = "enclosing_environment";
                    } else if (obj->is<CallObject>()) {
                        if (slot == CallObject::calleeSlot())
                            slotname = "callee_slot";
                    } else if (obj->is<WithEnvironmentObject>()) {
                        if (slot == WithEnvironmentObject::objectSlot())
                            slotname = "with_object";
                        else if (slot == WithEnvironmentObject::thisSlot())
                            slotname = "with_this";
                    }
                }
            }

            if (slotname)
                snprintf(buf, bufsize, pattern, slotname);
            else
                snprintf(buf, bufsize, "**UNKNOWN SLOT %" PRIu32 "**", slot);
        } while (false);
    } else {
        jsid propid = shape->propid();
        if (JSID_IS_INT(propid)) {
            snprintf(buf, bufsize, "%" PRId32, JSID_TO_INT(propid));
        } else if (JSID_IS_ATOM(propid)) {
            PutEscapedString(buf, bufsize, JSID_TO_ATOM(propid), 0);
        } else if (JSID_IS_SYMBOL(propid)) {
            snprintf(buf, bufsize, "**SYMBOL KEY**");
        } else {
            snprintf(buf, bufsize, "**FINALIZED ATOM KEY**");
        }
    }
}

bool
js::ReportGetterOnlyAssignment(JSContext* cx, bool strict)
{
    return JS_ReportErrorFlagsAndNumberASCII(cx,
                                             strict
                                             ? JSREPORT_ERROR
                                             : JSREPORT_WARNING | JSREPORT_STRICT,
                                             GetErrorMessage, nullptr,
                                             JSMSG_GETTER_ONLY);
}


/*** Debugging routines **************************************************************************/

#ifdef DEBUG

/*
 * Routines to print out values during debugging.  These are FRIEND_API to help
 * the debugger find them and to support temporarily hacking js::Dump* calls
 * into other code.
 */

static void
dumpValue(const Value& v, FILE* fp)
{
    if (v.isNull())
        fprintf(fp, "null");
    else if (v.isUndefined())
        fprintf(fp, "undefined");
    else if (v.isInt32())
        fprintf(fp, "%d", v.toInt32());
    else if (v.isDouble())
        fprintf(fp, "%g", v.toDouble());
    else if (v.isString())
        v.toString()->dump(fp);
    else if (v.isSymbol())
        v.toSymbol()->dump(fp);
    else if (v.isObject() && v.toObject().is<JSFunction>()) {
        JSFunction* fun = &v.toObject().as<JSFunction>();
        if (fun->displayAtom()) {
            fputs("<function ", fp);
            FileEscapedString(fp, fun->displayAtom(), 0);
        } else {
            fputs("<unnamed function", fp);
        }
        if (fun->hasScript()) {
            JSScript* script = fun->nonLazyScript();
            fprintf(fp, " (%s:%" PRIuSIZE ")",
                    script->filename() ? script->filename() : "", script->lineno());
        }
        fprintf(fp, " at %p>", (void*) fun);
    } else if (v.isObject()) {
        JSObject* obj = &v.toObject();
        const Class* clasp = obj->getClass();
        fprintf(fp, "<%s%s at %p>",
                clasp->name,
                (clasp == &PlainObject::class_) ? "" : " object",
                (void*) obj);
    } else if (v.isBoolean()) {
        if (v.toBoolean())
            fprintf(fp, "true");
        else
            fprintf(fp, "false");
    } else if (v.isMagic()) {
        fprintf(fp, "<invalid");
#ifdef DEBUG
        switch (v.whyMagic()) {
          case JS_ELEMENTS_HOLE:     fprintf(fp, " elements hole");      break;
          case JS_NO_ITER_VALUE:     fprintf(fp, " no iter value");      break;
          case JS_GENERATOR_CLOSING: fprintf(fp, " generator closing");  break;
          case JS_OPTIMIZED_OUT:     fprintf(fp, " optimized out");      break;
          default:                   fprintf(fp, " ?!");                 break;
        }
#endif
        fprintf(fp, ">");
    } else {
        fprintf(fp, "unexpected value");
    }
}

JS_FRIEND_API(void)
js::DumpValue(const Value& val, FILE* fp)
{
    dumpValue(val, fp);
    fputc('\n', fp);
}

JS_FRIEND_API(void)
js::DumpId(jsid id, FILE* fp)
{
    fprintf(fp, "jsid %p = ", (void*) JSID_BITS(id));
    dumpValue(IdToValue(id), fp);
    fputc('\n', fp);
}

static void
DumpProperty(const NativeObject* obj, Shape& shape, FILE* fp)
{
    jsid id = shape.propid();
    uint8_t attrs = shape.attributes();

    fprintf(fp, "    ((js::Shape*) %p) ", (void*) &shape);
    if (attrs & JSPROP_ENUMERATE) fprintf(fp, "enumerate ");
    if (attrs & JSPROP_READONLY) fprintf(fp, "readonly ");
    if (attrs & JSPROP_PERMANENT) fprintf(fp, "permanent ");
    if (attrs & JSPROP_SHARED) fprintf(fp, "shared ");

    if (shape.hasGetterValue())
        fprintf(fp, "getterValue=%p ", (void*) shape.getterObject());
    else if (!shape.hasDefaultGetter())
        fprintf(fp, "getterOp=%p ", JS_FUNC_TO_DATA_PTR(void*, shape.getterOp()));

    if (shape.hasSetterValue())
        fprintf(fp, "setterValue=%p ", (void*) shape.setterObject());
    else if (!shape.hasDefaultSetter())
        fprintf(fp, "setterOp=%p ", JS_FUNC_TO_DATA_PTR(void*, shape.setterOp()));

    if (JSID_IS_ATOM(id) || JSID_IS_INT(id) || JSID_IS_SYMBOL(id))
        dumpValue(js::IdToValue(id), fp);
    else
        fprintf(fp, "unknown jsid %p", (void*) JSID_BITS(id));

    uint32_t slot = shape.hasSlot() ? shape.maybeSlot() : SHAPE_INVALID_SLOT;
    fprintf(fp, ": slot %d", slot);
    if (shape.hasSlot()) {
        fprintf(fp, " = ");
        dumpValue(obj->getSlot(slot), fp);
    } else if (slot != SHAPE_INVALID_SLOT) {
        fprintf(fp, " (INVALID!)");
    }
    fprintf(fp, "\n");
}

bool
JSObject::uninlinedIsProxy() const
{
    return is<ProxyObject>();
}

void
JSObject::dump(FILE* fp) const
{
    const JSObject* obj = this;
    JSObject* globalObj = &global();
    fprintf(fp, "object %p from global %p [%s]\n", (void*) obj,
            (void*) globalObj, globalObj->getClass()->name);
    const Class* clasp = obj->getClass();
    fprintf(fp, "class %p %s\n", (const void*)clasp, clasp->name);

    if (obj->hasLazyGroup()) {
        fprintf(fp, "lazy group\n");
    } else {
        const ObjectGroup* group = obj->group();
        fprintf(fp, "group %p\n", (const void*)group);
    }

    fprintf(fp, "flags:");
    if (obj->isDelegate()) fprintf(fp, " delegate");
    if (!obj->is<ProxyObject>() && !obj->nonProxyIsExtensible()) fprintf(fp, " not_extensible");
    if (obj->isIndexed()) fprintf(fp, " indexed");
    if (obj->isBoundFunction()) fprintf(fp, " bound_function");
    if (obj->isQualifiedVarObj()) fprintf(fp, " varobj");
    if (obj->isUnqualifiedVarObj()) fprintf(fp, " unqualified_varobj");
    if (obj->watched()) fprintf(fp, " watched");
    if (obj->isIteratedSingleton()) fprintf(fp, " iterated_singleton");
    if (obj->isNewGroupUnknown()) fprintf(fp, " new_type_unknown");
    if (obj->hasUncacheableProto()) fprintf(fp, " has_uncacheable_proto");
    if (obj->hadElementsAccess()) fprintf(fp, " had_elements_access");
    if (obj->wasNewScriptCleared()) fprintf(fp, " new_script_cleared");
    if (obj->hasStaticPrototype() && obj->staticPrototypeIsImmutable())
        fprintf(fp, " immutable_prototype");

    if (obj->isNative()) {
        const NativeObject* nobj = &obj->as<NativeObject>();
        if (nobj->inDictionaryMode())
            fprintf(fp, " inDictionaryMode");
        if (nobj->hasShapeTable())
            fprintf(fp, " hasShapeTable");
    }
    fprintf(fp, "\n");

    if (obj->isNative()) {
        const NativeObject* nobj = &obj->as<NativeObject>();
        uint32_t slots = nobj->getDenseInitializedLength();
        if (slots) {
            fprintf(fp, "elements\n");
            for (uint32_t i = 0; i < slots; i++) {
                fprintf(fp, " %3d: ", i);
                dumpValue(nobj->getDenseElement(i), fp);
                fprintf(fp, "\n");
                fflush(fp);
            }
        }
    }

    fprintf(fp, "proto ");
    TaggedProto proto = obj->taggedProto();
    if (proto.isDynamic())
        fprintf(fp, "<dynamic>");
    else
        dumpValue(ObjectOrNullValue(proto.toObjectOrNull()), fp);
    fputc('\n', fp);

    if (clasp->flags & JSCLASS_HAS_PRIVATE)
        fprintf(fp, "private %p\n", obj->as<NativeObject>().getPrivate());

    if (!obj->isNative())
        fprintf(fp, "not native\n");

    uint32_t reservedEnd = JSCLASS_RESERVED_SLOTS(clasp);
    uint32_t slots = obj->isNative() ? obj->as<NativeObject>().slotSpan() : 0;
    uint32_t stop = obj->isNative() ? reservedEnd : slots;
    if (stop > 0)
        fprintf(fp, obj->isNative() ? "reserved slots:\n" : "slots:\n");
    for (uint32_t i = 0; i < stop; i++) {
        fprintf(fp, " %3d ", i);
        if (i < reservedEnd)
            fprintf(fp, "(reserved) ");
        fprintf(fp, "= ");
        dumpValue(obj->as<NativeObject>().getSlot(i), fp);
        fputc('\n', fp);
    }

    if (obj->isNative()) {
        fprintf(fp, "properties:\n");
        Vector<Shape*, 8, SystemAllocPolicy> props;
        for (Shape::Range<NoGC> r(obj->as<NativeObject>().lastProperty()); !r.empty(); r.popFront()) {
            if (!props.append(&r.front())) {
                fprintf(fp, "(OOM while appending properties)\n");
                break;
            }
        }
        for (size_t i = props.length(); i-- != 0;)
            DumpProperty(&obj->as<NativeObject>(), *props[i], fp);
    }
    fputc('\n', fp);
}

// For debuggers.
void
JSObject::dump() const
{
    dump(stderr);
}

static void
MaybeDumpScope(Scope* scope, FILE* fp)
{
    if (scope) {
        fprintf(fp, "  scope: %s\n", ScopeKindString(scope->kind()));
        for (BindingIter bi(scope); bi; bi++) {
            fprintf(fp, "    ");
            dumpValue(StringValue(bi.name()), fp);
            fputc('\n', fp);
        }
    }
}

static void
MaybeDumpValue(const char* name, const Value& v, FILE* fp)
{
    if (!v.isNull()) {
        fprintf(fp, "  %s: ", name);
        dumpValue(v, fp);
        fputc('\n', fp);
    }
}

JS_FRIEND_API(void)
js::DumpInterpreterFrame(JSContext* cx, FILE* fp, InterpreterFrame* start)
{
    /* This should only called during live debugging. */
    ScriptFrameIter i(cx);
    if (!start) {
        if (i.done()) {
            fprintf(fp, "no stack for cx = %p\n", (void*) cx);
            return;
        }
    } else {
        while (!i.done() && !i.isJit() && i.interpFrame() != start)
            ++i;

        if (i.done()) {
            fprintf(fp, "fp = %p not found in cx = %p\n",
                    (void*)start, (void*)cx);
            return;
        }
    }

    for (; !i.done(); ++i) {
        if (i.isJit())
            fprintf(fp, "JIT frame\n");
        else
            fprintf(fp, "InterpreterFrame at %p\n", (void*) i.interpFrame());

        if (i.isFunctionFrame()) {
            fprintf(fp, "callee fun: ");
            RootedValue v(cx);
            JSObject* fun = i.callee(cx);
            v.setObject(*fun);
            dumpValue(v, fp);
        } else {
            fprintf(fp, "global or eval frame, no callee");
        }
        fputc('\n', fp);

        fprintf(fp, "file %s line %" PRIuSIZE "\n",
                i.script()->filename(), i.script()->lineno());

        if (jsbytecode* pc = i.pc()) {
            fprintf(fp, "  pc = %p\n", pc);
            fprintf(fp, "  current op: %s\n", CodeName[*pc]);
            MaybeDumpScope(i.script()->lookupScope(pc), fp);
        }
        if (i.isFunctionFrame())
            MaybeDumpValue("this", i.thisArgument(cx), fp);
        if (!i.isJit()) {
            fprintf(fp, "  rval: ");
            dumpValue(i.interpFrame()->returnValue(), fp);
            fputc('\n', fp);
        }

        fprintf(fp, "  flags:");
        if (i.isConstructing())
            fprintf(fp, " constructing");
        if (!i.isJit() && i.interpFrame()->isDebuggerEvalFrame())
            fprintf(fp, " debugger eval");
        if (i.isEvalFrame())
            fprintf(fp, " eval");
        fputc('\n', fp);

        fprintf(fp, "  envChain: (JSObject*) %p\n", (void*) i.environmentChain(cx));

        fputc('\n', fp);
    }
}

#endif /* DEBUG */

JS_FRIEND_API(void)
js::DumpBacktrace(JSContext* cx, FILE* fp)
{
    Sprinter sprinter(cx, false);
    if (!sprinter.init()) {
        fprintf(fp, "js::DumpBacktrace: OOM\n");
        return;
    }
    size_t depth = 0;
    for (AllFramesIter i(cx); !i.done(); ++i, ++depth) {
        const char* filename;
        unsigned line;
        if (i.hasScript()) {
            filename = JS_GetScriptFilename(i.script());
            line = PCToLineNumber(i.script(), i.pc());
        } else {
            filename = i.filename();
            line = i.computeLine();
        }
        char frameType =
            i.isInterp() ? 'i' :
            i.isBaseline() ? 'b' :
            i.isIon() ? 'I' :
            i.isWasm() ? 'W' :
            '?';

        sprinter.printf("#%" PRIuSIZE " %14p %c   %s:%d",
                        depth, i.rawFramePtr(), frameType, filename, line);

        if (i.hasScript()) {
            sprinter.printf(" (%p @ %" PRIuSIZE ")\n",
                            i.script(), i.script()->pcToOffset(i.pc()));
        } else {
            sprinter.printf(" (%p)\n", i.pc());
        }
    }
    fprintf(fp, "%s", sprinter.string());
#ifdef XP_WIN32
    if (IsDebuggerPresent())
        OutputDebugStringA(sprinter.string());
#endif
}

JS_FRIEND_API(void)
js::DumpBacktrace(JSContext* cx)
{
    DumpBacktrace(cx, stdout);
}

/* * */

js::gc::AllocKind
JSObject::allocKindForTenure(const js::Nursery& nursery) const
{
    if (is<ArrayObject>()) {
        const ArrayObject& aobj = as<ArrayObject>();
        MOZ_ASSERT(aobj.numFixedSlots() == 0);

        /* Use minimal size object if we are just going to copy the pointer. */
        if (!nursery.isInside(aobj.getElementsHeader()))
            return AllocKind::OBJECT0_BACKGROUND;

        size_t nelements = aobj.getDenseCapacity();
        return GetBackgroundAllocKind(GetGCArrayKind(nelements));
    }

    if (is<JSFunction>())
        return as<JSFunction>().getAllocKind();

    /*
     * Typed arrays in the nursery may have a lazily allocated buffer, make
     * sure there is room for the array's fixed data when moving the array.
     */
    if (is<TypedArrayObject>() && !as<TypedArrayObject>().hasBuffer()) {
        size_t nbytes = as<TypedArrayObject>().byteLength();
        if (as<TypedArrayObject>().hasInlineElements())
            return GetBackgroundAllocKind(TypedArrayObject::AllocKindForLazyBuffer(nbytes));
        return GetGCObjectKind(getClass());
    }

    // Proxies that are CrossCompartmentWrappers may be nursery allocated.
    if (IsProxy(this))
        return as<ProxyObject>().allocKindForTenure();

    // Unboxed plain objects are sized according to the data they store.
    if (is<UnboxedPlainObject>()) {
        size_t nbytes = as<UnboxedPlainObject>().layoutDontCheckGeneration().size();
        return GetGCObjectKindForBytes(UnboxedPlainObject::offsetOfData() + nbytes);
    }

    // Unboxed arrays use inline data if their size is small enough.
    if (is<UnboxedArrayObject>()) {
        const UnboxedArrayObject* nobj = &as<UnboxedArrayObject>();
        size_t nbytes = UnboxedArrayObject::offsetOfInlineElements() +
                        nobj->capacity() * nobj->elementSize();
        if (nbytes <= JSObject::MAX_BYTE_SIZE)
            return GetGCObjectKindForBytes(nbytes);
        return AllocKind::OBJECT0;
    }

    // Inlined typed objects are followed by their data, so make sure we copy
    // it all over to the new object.
    if (is<InlineTypedObject>()) {
        // Figure out the size of this object, from the prototype's TypeDescr.
        // The objects we are traversing here are all tenured, so we don't need
        // to check forwarding pointers.
        TypeDescr& descr = as<InlineTypedObject>().typeDescr();
        MOZ_ASSERT(!IsInsideNursery(&descr));
        return InlineTypedObject::allocKindForTypeDescriptor(&descr);
    }

    // Outline typed objects use the minimum allocation kind.
    if (is<OutlineTypedObject>())
        return AllocKind::OBJECT0;

    // All nursery allocatable non-native objects are handled above.
    MOZ_ASSERT(isNative());

    AllocKind kind = GetGCObjectFixedSlotsKind(as<NativeObject>().numFixedSlots());
    MOZ_ASSERT(!IsBackgroundFinalized(kind));
    if (!CanBeFinalizedInBackground(kind, getClass()))
        return kind;
    return GetBackgroundAllocKind(kind);
}

void
JSObject::addSizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf, JS::ClassInfo* info)
{
    if (is<NativeObject>() && as<NativeObject>().hasDynamicSlots())
        info->objectsMallocHeapSlots += mallocSizeOf(as<NativeObject>().slots_);

    if (is<NativeObject>() && as<NativeObject>().hasDynamicElements()) {
        js::ObjectElements* elements = as<NativeObject>().getElementsHeader();
        if (!elements->isCopyOnWrite() || elements->ownerObject() == this)
            info->objectsMallocHeapElementsNormal += mallocSizeOf(elements);
    }

    // Other things may be measured in the future if DMD indicates it is worthwhile.
    if (is<JSFunction>() ||
        is<PlainObject>() ||
        is<ArrayObject>() ||
        is<CallObject>() ||
        is<RegExpObject>() ||
        is<ProxyObject>())
    {
        // Do nothing.  But this function is hot, and we win by getting the
        // common cases out of the way early.  Some stats on the most common
        // classes, as measured during a vanilla browser session:
        // - (53.7%, 53.7%): Function
        // - (18.0%, 71.7%): Object
        // - (16.9%, 88.6%): Array
        // - ( 3.9%, 92.5%): Call
        // - ( 2.8%, 95.3%): RegExp
        // - ( 1.0%, 96.4%): Proxy

        // Note that any JSClass that is special cased below likely needs to
        // specify the JSCLASS_DELAY_METADATA_CALLBACK flag, or else we will
        // probably crash if the object metadata callback attempts to get the
        // size of the new object (which Debugger code does) before private
        // slots are initialized.
    } else if (is<ArgumentsObject>()) {
        info->objectsMallocHeapMisc += as<ArgumentsObject>().sizeOfMisc(mallocSizeOf);
    } else if (is<RegExpStaticsObject>()) {
        info->objectsMallocHeapMisc += as<RegExpStaticsObject>().sizeOfData(mallocSizeOf);
    } else if (is<PropertyIteratorObject>()) {
        info->objectsMallocHeapMisc += as<PropertyIteratorObject>().sizeOfMisc(mallocSizeOf);
    } else if (is<ArrayBufferObject>()) {
        ArrayBufferObject::addSizeOfExcludingThis(this, mallocSizeOf, info);
    } else if (is<SharedArrayBufferObject>()) {
        SharedArrayBufferObject::addSizeOfExcludingThis(this, mallocSizeOf, info);
#ifdef JS_HAS_CTYPES
    } else {
        // This must be the last case.
        info->objectsMallocHeapMisc +=
            js::SizeOfDataIfCDataObject(mallocSizeOf, const_cast<JSObject*>(this));
#endif
    }
}

size_t
JSObject::sizeOfIncludingThisInNursery() const
{
    // This function doesn't concern itself yet with typed objects (bug 1133593)
    // nor unboxed objects (bug 1133592).

    MOZ_ASSERT(!isTenured());

    const Nursery& nursery = compartment()->runtimeFromAnyThread()->gc.nursery;
    size_t size = Arena::thingSize(allocKindForTenure(nursery));

    if (is<NativeObject>()) {
        const NativeObject& native = as<NativeObject>();

        size += native.numFixedSlots() * sizeof(Value);
        size += native.numDynamicSlots() * sizeof(Value);

        if (native.hasDynamicElements()) {
            js::ObjectElements& elements = *native.getElementsHeader();
            if (!elements.isCopyOnWrite() || elements.ownerObject() == this)
                size += elements.capacity * sizeof(HeapSlot);
        }

        if (is<ArgumentsObject>())
            size += as<ArgumentsObject>().sizeOfData();
    }

    return size;
}

JS::ubi::Node::Size
JS::ubi::Concrete<JSObject>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    JSObject& obj = get();

    if (!obj.isTenured())
        return obj.sizeOfIncludingThisInNursery();

    JS::ClassInfo info;
    obj.addSizeOfExcludingThis(mallocSizeOf, &info);
    return obj.tenuredSizeOfThis() + info.sizeOfAllThings();
}

const char16_t JS::ubi::Concrete<JSObject>::concreteTypeName[] = u"JSObject";

void
JSObject::traceChildren(JSTracer* trc)
{
    TraceEdge(trc, &group_, "group");

    const Class* clasp = group_->clasp();
    if (clasp->isNative()) {
        NativeObject* nobj = &as<NativeObject>();

        TraceEdge(trc, &nobj->shape_, "shape");

        {
            GetObjectSlotNameFunctor func(nobj);
            JS::AutoTracingDetails ctx(trc, func);
            JS::AutoTracingIndex index(trc);
            // Tracing can mutate the target but cannot change the slot count,
            // but the compiler has no way of knowing this.
            const uint32_t nslots = nobj->slotSpan();
            for (uint32_t i = 0; i < nslots; ++i) {
                TraceManuallyBarrieredEdge(trc, nobj->getSlotRef(i).unsafeUnbarrieredForTracing(),
                                           "object slot");
                ++index;
            }
            MOZ_ASSERT(nslots == nobj->slotSpan());
        }

        do {
            if (nobj->denseElementsAreCopyOnWrite()) {
                GCPtrNativeObject& owner = nobj->getElementsHeader()->ownerObject();
                if (owner != nobj) {
                    TraceEdge(trc, &owner, "objectElementsOwner");
                    break;
                }
            }

            TraceRange(trc,
                       nobj->getDenseInitializedLength(),
                       static_cast<HeapSlot*>(nobj->getDenseElementsAllowCopyOnWrite()),
                       "objectElements");
        } while (false);
    }

    // Call the trace hook at the end so that during a moving GC the trace hook
    // will see updated fields and slots.
    if (clasp->hasTrace())
        clasp->doTrace(trc, this);
}

static JSAtom*
displayAtomFromObjectGroup(ObjectGroup& group)
{
    TypeNewScript* script = group.newScript();
    if (!script)
        return nullptr;

    return script->function()->displayAtom();
}

bool
JSObject::constructorDisplayAtom(JSContext* cx, js::MutableHandleAtom name)
{
    ObjectGroup *g = getGroup(cx);
    if (!g)
        return false;

    name.set(displayAtomFromObjectGroup(*g));
    return true;
}

JSAtom*
JSObject::maybeConstructorDisplayAtom() const
{
    if (hasLazyGroup())
        return nullptr;
    return displayAtomFromObjectGroup(*group());
}

bool
js::SpeciesConstructor(JSContext* cx, HandleObject obj, HandleValue defaultCtor, MutableHandleValue pctor)
{
    HandlePropertyName shName = cx->names().SpeciesConstructor;
    RootedValue func(cx);
    if (!GlobalObject::getSelfHostedFunction(cx, cx->global(), shName, shName, 2, &func))
        return false;

    FixedInvokeArgs<2> args(cx);

    args[0].setObject(*obj);
    args[1].set(defaultCtor);

    if (!Call(cx, func, UndefinedHandleValue, args, pctor))
        return false;

    pctor.set(args.rval());
    return true;
}

bool
js::SpeciesConstructor(JSContext* cx, HandleObject obj, JSProtoKey ctorKey,
                       MutableHandleValue pctor)
{
    if (!GlobalObject::ensureConstructor(cx, cx->global(), ctorKey))
        return false;
    RootedValue defaultCtor(cx, cx->global()->getConstructor(ctorKey));
    return SpeciesConstructor(cx, obj, defaultCtor, pctor);
}

bool
js::Unbox(JSContext* cx, HandleObject obj, MutableHandleValue vp)
{
    if (MOZ_UNLIKELY(obj->is<ProxyObject>()))
        return Proxy::boxedValue_unbox(cx, obj, vp);

    if (obj->is<BooleanObject>())
        vp.setBoolean(obj->as<BooleanObject>().unbox());
    else if (obj->is<NumberObject>())
        vp.setNumber(obj->as<NumberObject>().unbox());
    else if (obj->is<StringObject>())
        vp.setString(obj->as<StringObject>().unbox());
    else if (obj->is<DateObject>())
        vp.set(obj->as<DateObject>().UTCTime());
    else
        vp.setUndefined();

    return true;
}
