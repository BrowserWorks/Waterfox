/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* JavaScript iterators. */

#include "jsiter.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/Maybe.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PodOperations.h"
#include "mozilla/Unused.h"

#include "jsarray.h"
#include "jsatom.h"
#include "jscntxt.h"
#include "jsgc.h"
#include "jsobj.h"
#include "jsopcode.h"
#include "jsscript.h"
#include "jstypes.h"
#include "jsutil.h"

#include "ds/Sort.h"
#include "gc/Marking.h"
#include "js/Proxy.h"
#include "vm/GeneratorObject.h"
#include "vm/GlobalObject.h"
#include "vm/Interpreter.h"
#include "vm/Shape.h"
#include "vm/StopIterationObject.h"
#include "vm/TypedArrayObject.h"

#include "jsscriptinlines.h"

#include "vm/NativeObject-inl.h"
#include "vm/ReceiverGuard-inl.h"
#include "vm/Stack-inl.h"
#include "vm/String-inl.h"

using namespace js;
using namespace js::gc;
using JS::ForOfIterator;

using mozilla::ArrayLength;
using mozilla::Maybe;
using mozilla::PodCopy;
using mozilla::PodEqual;
using mozilla::PodZero;

typedef Rooted<PropertyIteratorObject*> RootedPropertyIteratorObject;

static const gc::AllocKind ITERATOR_FINALIZE_KIND = gc::AllocKind::OBJECT2_BACKGROUND;

void
NativeIterator::trace(JSTracer* trc)
{
    for (GCPtrFlatString* str = begin(); str < end(); str++)
        TraceNullableEdge(trc, str, "prop");
    TraceNullableEdge(trc, &obj, "obj");

    for (size_t i = 0; i < guard_length; i++)
        guard_array[i].trace(trc);

    // The SuppressDeletedPropertyHelper loop can GC, so make sure that if the
    // GC removes any elements from the list, it won't remove this one.
    if (iterObj_)
        TraceManuallyBarrieredEdge(trc, &iterObj_, "iterObj");
}

typedef HashSet<jsid, DefaultHasher<jsid>> IdSet;

static inline bool
NewKeyValuePair(JSContext* cx, jsid id, const Value& val, MutableHandleValue rval)
{
    return NewValuePair(cx, IdToValue(id), val, rval);
}

template <bool CheckForDuplicates>
static inline bool
Enumerate(JSContext* cx, HandleObject pobj, jsid id,
          bool enumerable, unsigned flags, Maybe<IdSet>& ht, AutoIdVector* props)
{
    if (CheckForDuplicates) {
        if (!ht) {
            ht.emplace(cx);
            // Most of the time there are only a handful of entries.
            if (!ht->init(5))
                return false;
        }

        // If we've already seen this, we definitely won't add it.
        IdSet::AddPtr p = ht->lookupForAdd(id);
        if (MOZ_UNLIKELY(!!p))
            return true;

        // It's not necessary to add properties to the hash table at the end of
        // the prototype chain, but custom enumeration behaviors might return
        // duplicated properties, so always add in such cases.
        if (pobj->is<ProxyObject>() ||
            pobj->staticPrototype() ||
            pobj->getClass()->getNewEnumerate())
        {
            if (!ht->add(p, id))
                return false;
        }
    }

    if (!enumerable && !(flags & JSITER_HIDDEN))
        return true;

    // Symbol-keyed properties and nonenumerable properties are skipped unless
    // the caller specifically asks for them. A caller can also filter out
    // non-symbols by asking for JSITER_SYMBOLSONLY.
    if (JSID_IS_SYMBOL(id) ? !(flags & JSITER_SYMBOLS) : (flags & JSITER_SYMBOLSONLY))
        return true;

    return props->append(id);
}

template <bool CheckForDuplicates>
static bool
EnumerateExtraProperties(JSContext* cx, HandleObject obj, unsigned flags, Maybe<IdSet>& ht,
                         AutoIdVector* props)
{
    MOZ_ASSERT(obj->getClass()->getNewEnumerate());

    AutoIdVector properties(cx);
    bool enumerableOnly = !(flags & JSITER_HIDDEN);
    if (!obj->getClass()->getNewEnumerate()(cx, obj, properties, enumerableOnly))
        return false;

    RootedId id(cx);
    for (size_t n = 0; n < properties.length(); n++) {
        id = properties[n];

        // The enumerate hook does not indicate whether the properties
        // it returns are enumerable or not. Since we already passed
        // `enumerableOnly` to the hook to filter out non-enumerable
        // properties, it doesn't really matter what we pass here.
        bool enumerable = true;
        if (!Enumerate<CheckForDuplicates>(cx, obj, id, enumerable, flags, ht, props))
            return false;
    }

    return true;
}

static bool
SortComparatorIntegerIds(jsid a, jsid b, bool* lessOrEqualp)
{
    uint32_t indexA, indexB;
    MOZ_ALWAYS_TRUE(IdIsIndex(a, &indexA));
    MOZ_ALWAYS_TRUE(IdIsIndex(b, &indexB));
    *lessOrEqualp = (indexA <= indexB);
    return true;
}

template <bool CheckForDuplicates>
static bool
EnumerateNativeProperties(JSContext* cx, HandleNativeObject pobj, unsigned flags, Maybe<IdSet>& ht,
                          AutoIdVector* props, Handle<UnboxedPlainObject*> unboxed = nullptr)
{
    bool enumerateSymbols;
    if (flags & JSITER_SYMBOLSONLY) {
        enumerateSymbols = true;
    } else {
        /* Collect any dense elements from this object. */
        size_t firstElemIndex = props->length();
        size_t initlen = pobj->getDenseInitializedLength();
        const Value* vp = pobj->getDenseElements();
        bool hasHoles = false;
        for (size_t i = 0; i < initlen; ++i, ++vp) {
            if (vp->isMagic(JS_ELEMENTS_HOLE)) {
                hasHoles = true;
            } else {
                /* Dense arrays never get so large that i would not fit into an integer id. */
                if (!Enumerate<CheckForDuplicates>(cx, pobj, INT_TO_JSID(i),
                                                   /* enumerable = */ true, flags, ht, props))
                {
                    return false;
                }
            }
        }

        /* Collect any typed array or shared typed array elements from this object. */
        if (pobj->is<TypedArrayObject>()) {
            size_t len = pobj->as<TypedArrayObject>().length();
            for (size_t i = 0; i < len; i++) {
                if (!Enumerate<CheckForDuplicates>(cx, pobj, INT_TO_JSID(i),
                                                   /* enumerable = */ true, flags, ht, props))
                {
                    return false;
                }
            }
        }

        // Collect any sparse elements from this object.
        bool isIndexed = pobj->isIndexed();
        if (isIndexed) {
            // If the dense elements didn't have holes, we don't need to include
            // them in the sort.
            if (!hasHoles)
                firstElemIndex = props->length();

            for (Shape::Range<NoGC> r(pobj->lastProperty()); !r.empty(); r.popFront()) {
                Shape& shape = r.front();
                jsid id = shape.propid();
                uint32_t dummy;
                if (IdIsIndex(id, &dummy)) {
                    if (!Enumerate<CheckForDuplicates>(cx, pobj, id, shape.enumerable(), flags, ht,
                                                       props))
                    {
                        return false;
                    }
                }
            }

            MOZ_ASSERT(firstElemIndex <= props->length());

            jsid* ids = props->begin() + firstElemIndex;
            size_t n = props->length() - firstElemIndex;

            AutoIdVector tmp(cx);
            if (!tmp.resize(n))
                return false;
            PodCopy(tmp.begin(), ids, n);

            if (!MergeSort(ids, n, tmp.begin(), SortComparatorIntegerIds))
                return false;
        }

        if (unboxed) {
            // If |unboxed| is set then |pobj| is the expando for an unboxed
            // plain object we are enumerating. Add the unboxed properties
            // themselves here since they are all property names that were
            // given to the object before any of the expando's properties.
            MOZ_ASSERT(pobj->is<UnboxedExpandoObject>());
            if (!EnumerateExtraProperties<CheckForDuplicates>(cx, unboxed, flags, ht, props))
                return false;
        }

        size_t initialLength = props->length();

        /* Collect all unique property names from this object's shape. */
        bool symbolsFound = false;
        Shape::Range<NoGC> r(pobj->lastProperty());
        for (; !r.empty(); r.popFront()) {
            Shape& shape = r.front();
            jsid id = shape.propid();

            if (JSID_IS_SYMBOL(id)) {
                symbolsFound = true;
                continue;
            }

            uint32_t dummy;
            if (isIndexed && IdIsIndex(id, &dummy))
                continue;

            if (!Enumerate<CheckForDuplicates>(cx, pobj, id, shape.enumerable(), flags, ht, props))
                return false;
        }
        ::Reverse(props->begin() + initialLength, props->end());

        enumerateSymbols = symbolsFound && (flags & JSITER_SYMBOLS);
    }

    if (enumerateSymbols) {
        // Do a second pass to collect symbols. ES6 draft rev 25 (2014 May 22)
        // 9.1.12 requires that all symbols appear after all strings in the
        // result.
        size_t initialLength = props->length();
        for (Shape::Range<NoGC> r(pobj->lastProperty()); !r.empty(); r.popFront()) {
            Shape& shape = r.front();
            jsid id = shape.propid();
            if (JSID_IS_SYMBOL(id)) {
                if (!Enumerate<CheckForDuplicates>(cx, pobj, id, shape.enumerable(), flags, ht,
                                                   props))
                {
                    return false;
                }
            }
        }
        ::Reverse(props->begin() + initialLength, props->end());
    }

    return true;
}

static bool
EnumerateNativeProperties(JSContext* cx, HandleNativeObject pobj, unsigned flags, Maybe<IdSet>& ht,
                          AutoIdVector* props, bool checkForDuplicates,
                          Handle<UnboxedPlainObject*> unboxed = nullptr)
{
    if (checkForDuplicates)
        return EnumerateNativeProperties<true>(cx, pobj, flags, ht, props, unboxed);
    return EnumerateNativeProperties<false>(cx, pobj, flags, ht, props, unboxed);
}

template <bool CheckForDuplicates>
static bool
EnumerateProxyProperties(JSContext* cx, HandleObject pobj, unsigned flags, Maybe<IdSet>& ht,
                         AutoIdVector* props)
{
    MOZ_ASSERT(pobj->is<ProxyObject>());

    AutoIdVector proxyProps(cx);

    if (flags & JSITER_HIDDEN || flags & JSITER_SYMBOLS) {
        // This gets all property keys, both strings and symbols. The call to
        // Enumerate in the loop below will filter out unwanted keys, per the
        // flags.
        if (!Proxy::ownPropertyKeys(cx, pobj, proxyProps))
            return false;

        Rooted<PropertyDescriptor> desc(cx);
        for (size_t n = 0, len = proxyProps.length(); n < len; n++) {
            bool enumerable = false;

            // We need to filter, if the caller just wants enumerable symbols.
            if (!(flags & JSITER_HIDDEN)) {
                if (!Proxy::getOwnPropertyDescriptor(cx, pobj, proxyProps[n], &desc))
                    return false;
                enumerable = desc.enumerable();
            }

            if (!Enumerate<CheckForDuplicates>(cx, pobj, proxyProps[n], enumerable, flags, ht,
                                               props))
            {
                return false;
            }
        }

        return true;
    }

    // Returns enumerable property names (no symbols).
    if (!Proxy::getOwnEnumerablePropertyKeys(cx, pobj, proxyProps))
        return false;

    for (size_t n = 0, len = proxyProps.length(); n < len; n++) {
        if (!Enumerate<CheckForDuplicates>(cx, pobj, proxyProps[n], true, flags, ht, props))
            return false;
    }

    return true;
}

#ifdef JS_MORE_DETERMINISTIC

struct SortComparatorIds
{
    JSContext*  const cx;

    SortComparatorIds(JSContext* cx)
      : cx(cx) {}

    bool operator()(jsid a, jsid b, bool* lessOrEqualp)
    {
        // Pick an arbitrary order on jsids that is as stable as possible
        // across executions.
        if (a == b) {
            *lessOrEqualp = true;
            return true;
        }

        size_t ta = JSID_BITS(a) & JSID_TYPE_MASK;
        size_t tb = JSID_BITS(b) & JSID_TYPE_MASK;
        if (ta != tb) {
            *lessOrEqualp = (ta <= tb);
            return true;
        }

        if (JSID_IS_INT(a)) {
            *lessOrEqualp = (JSID_TO_INT(a) <= JSID_TO_INT(b));
            return true;
        }

        RootedString astr(cx), bstr(cx);
        if (JSID_IS_SYMBOL(a)) {
            MOZ_ASSERT(JSID_IS_SYMBOL(b));
            JS::SymbolCode ca = JSID_TO_SYMBOL(a)->code();
            JS::SymbolCode cb = JSID_TO_SYMBOL(b)->code();
            if (ca != cb) {
                *lessOrEqualp = uint32_t(ca) <= uint32_t(cb);
                return true;
            }
            MOZ_ASSERT(ca == JS::SymbolCode::InSymbolRegistry || ca == JS::SymbolCode::UniqueSymbol);
            astr = JSID_TO_SYMBOL(a)->description();
            bstr = JSID_TO_SYMBOL(b)->description();
            if (!astr || !bstr) {
                *lessOrEqualp = !astr;
                return true;
            }

            // Fall through to string comparison on the descriptions. The sort
            // order is nondeterministic if two different unique symbols have
            // the same description.
        } else {
            astr = IdToString(cx, a);
            if (!astr)
                return false;
            bstr = IdToString(cx, b);
            if (!bstr)
                return false;
        }

        int32_t result;
        if (!CompareStrings(cx, astr, bstr, &result))
            return false;

        *lessOrEqualp = (result <= 0);
        return true;
    }
};

#endif /* JS_MORE_DETERMINISTIC */

static bool
Snapshot(JSContext* cx, HandleObject pobj_, unsigned flags, AutoIdVector* props)
{
    // We initialize |ht| lazily (in Enumerate()) because it ends up unused
    // anywhere from 67--99.9% of the time.
    Maybe<IdSet> ht;
    RootedObject pobj(cx, pobj_);

    // Don't check for duplicates if we're only interested in own properties.
    // This does the right thing for most objects: native objects don't have
    // duplicate property ids and we allow the [[OwnPropertyKeys]] proxy trap to
    // return duplicates.
    //
    // The only special case is when the object has a newEnumerate hook: it
    // can return duplicate properties and we have to filter them. This is
    // handled below.
    bool checkForDuplicates = !(flags & JSITER_OWNONLY);

    do {
        if (pobj->getClass()->getNewEnumerate()) {
            if (pobj->is<UnboxedPlainObject>() && pobj->as<UnboxedPlainObject>().maybeExpando()) {
                // Special case unboxed objects with an expando object.
                RootedNativeObject expando(cx, pobj->as<UnboxedPlainObject>().maybeExpando());
                if (!EnumerateNativeProperties(cx, expando, flags, ht, props, checkForDuplicates,
                                               pobj.as<UnboxedPlainObject>()))
                {
                    return false;
                }
            } else {
                // The newEnumerate hook may return duplicates. Whitelist the
                // unboxed object hooks because we know they are well-behaved.
                if (!pobj->is<UnboxedPlainObject>() && !pobj->is<UnboxedArrayObject>())
                    checkForDuplicates = true;

                if (checkForDuplicates) {
                    if (!EnumerateExtraProperties<true>(cx, pobj, flags, ht, props))
                        return false;
                } else {
                    if (!EnumerateExtraProperties<false>(cx, pobj, flags, ht, props))
                        return false;
                }

                if (pobj->isNative()) {
                    if (!EnumerateNativeProperties(cx, pobj.as<NativeObject>(), flags, ht, props,
                                                   checkForDuplicates))
                    {
                        return false;
                    }
                }
            }
        } else if (pobj->isNative()) {
            // Give the object a chance to resolve all lazy properties
            if (JSEnumerateOp enumerate = pobj->getClass()->getEnumerate()) {
                if (!enumerate(cx, pobj.as<NativeObject>()))
                    return false;
            }
            if (!EnumerateNativeProperties(cx, pobj.as<NativeObject>(), flags, ht, props,
                                           checkForDuplicates))
            {
                return false;
            }
        } else if (pobj->is<ProxyObject>()) {
            if (checkForDuplicates) {
                if (!EnumerateProxyProperties<true>(cx, pobj, flags, ht, props))
                    return false;
            } else {
                if (!EnumerateProxyProperties<false>(cx, pobj, flags, ht, props))
                    return false;
            }
        } else {
            MOZ_CRASH("non-native objects must have an enumerate op");
        }

        if (flags & JSITER_OWNONLY)
            break;

        if (!GetPrototype(cx, pobj, &pobj))
            return false;

    } while (pobj != nullptr);

#ifdef JS_MORE_DETERMINISTIC

    /*
     * In some cases the enumeration order for an object depends on the
     * execution mode (interpreter vs. JIT), especially for native objects
     * with a class enumerate hook (where resolving a property changes the
     * resulting enumeration order). These aren't really bugs, but the
     * differences can change the generated output and confuse correctness
     * fuzzers, so we sort the ids if such a fuzzer is running.
     *
     * We don't do this in the general case because (a) doing so is slow,
     * and (b) it also breaks the web, which expects enumeration order to
     * follow the order in which properties are added, in certain cases.
     * Since ECMA does not specify an enumeration order for objects, both
     * behaviors are technically correct to do.
     */

    jsid* ids = props->begin();
    size_t n = props->length();

    AutoIdVector tmp(cx);
    if (!tmp.resize(n))
        return false;
    PodCopy(tmp.begin(), ids, n);

    if (!MergeSort(ids, n, tmp.begin(), SortComparatorIds(cx)))
        return false;

#endif /* JS_MORE_DETERMINISTIC */

    return true;
}

JS_FRIEND_API(bool)
js::GetPropertyKeys(JSContext* cx, HandleObject obj, unsigned flags, AutoIdVector* props)
{
    return Snapshot(cx, obj,
                    flags & (JSITER_OWNONLY | JSITER_HIDDEN | JSITER_SYMBOLS | JSITER_SYMBOLSONLY),
                    props);
}

size_t sCustomIteratorCount = 0;

static inline bool
GetCustomIterator(JSContext* cx, HandleObject obj, unsigned flags, MutableHandleObject objp)
{
    if (MOZ_UNLIKELY(!CheckRecursionLimit(cx)))
        return false;

    RootedValue rval(cx);
    /* Check whether we have a valid __iterator__ method. */
    HandlePropertyName name = cx->names().iteratorIntrinsic;
    if (!GetProperty(cx, obj, obj, name, &rval))
        return false;

    /* If there is no custom __iterator__ method, we are done here. */
    if (MOZ_LIKELY(!rval.isObject())) {
        objp.set(nullptr);
        return true;
    }

    if (!cx->runningWithTrustedPrincipals())
        ++sCustomIteratorCount;

    /* Otherwise call it and return that object. */
    {
        FixedInvokeArgs<1> args(cx);

        args[0].setBoolean((flags & JSITER_FOREACH) == 0);

        RootedValue thisv(cx, ObjectValue(*obj));
        if (!js::Call(cx, rval, thisv, args, &rval))
            return false;
    }

    if (rval.isPrimitive()) {
        // Ignore the stack when throwing. We can't tell whether we were
        // supposed to skip over a new.target or not.
        JSAutoByteString bytes;
        if (!AtomToPrintableString(cx, name, &bytes))
            return false;
        RootedValue val(cx, ObjectValue(*obj));
        ReportValueError2(cx, JSMSG_BAD_TRAP_RETURN_VALUE,
                          JSDVG_IGNORE_STACK, val, nullptr, bytes.ptr());
        return false;
    }
    objp.set(&rval.toObject());
    return true;
}

static bool legacy_iterator_next(JSContext* cx, unsigned argc, Value* vp);

static inline PropertyIteratorObject*
NewPropertyIteratorObject(JSContext* cx, unsigned flags)
{
    if (flags & JSITER_ENUMERATE) {
        RootedObjectGroup group(cx, ObjectGroup::defaultNewGroup(cx, &PropertyIteratorObject::class_,
                                                                 TaggedProto(nullptr)));
        if (!group)
            return nullptr;

        const Class* clasp = &PropertyIteratorObject::class_;
        RootedShape shape(cx, EmptyShape::getInitialShape(cx, clasp, TaggedProto(nullptr),
                                                          ITERATOR_FINALIZE_KIND));
        if (!shape)
            return nullptr;

        JSObject* obj;
        JS_TRY_VAR_OR_RETURN_NULL(cx, obj, NativeObject::create(cx, ITERATOR_FINALIZE_KIND,
                                                                GetInitialHeap(GenericObject, clasp),
                                                                shape, group));

        PropertyIteratorObject* res = &obj->as<PropertyIteratorObject>();

        // CodeGenerator::visitIteratorStartO assumes the iterator object is not
        // inside the nursery when deciding whether a barrier is necessary.
        MOZ_ASSERT(!js::gc::IsInsideNursery(res));

        MOZ_ASSERT(res->numFixedSlots() == JSObject::ITER_CLASS_NFIXED_SLOTS);
        return res;
    }

    Rooted<PropertyIteratorObject*> res(cx, NewBuiltinClassInstance<PropertyIteratorObject>(cx));
    if (!res)
        return nullptr;

    if (flags == 0) {
        // Redefine next as an own property. This ensure that deleting the
        // next method on the prototype doesn't break cross-global for .. in.
        // We don't have to do this for JSITER_ENUMERATE because that object always
        // takes an optimized path.
        RootedFunction next(cx, NewNativeFunction(cx, legacy_iterator_next, 0,
                                                  HandlePropertyName(cx->names().next)));
        if (!next)
            return nullptr;

        RootedValue value(cx, ObjectValue(*next));
        if (!DefineProperty(cx, res, cx->names().next, value))
            return nullptr;
    }

    return res;
}

NativeIterator*
NativeIterator::allocateIterator(JSContext* cx, uint32_t numGuards, uint32_t plength)
{
    JS_STATIC_ASSERT(sizeof(ReceiverGuard) == 2 * sizeof(void*));

    size_t extraLength = plength + numGuards * 2;
    NativeIterator* ni = cx->zone()->pod_malloc_with_extra<NativeIterator, void*>(extraLength);
    if (!ni) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    void** extra = reinterpret_cast<void**>(ni + 1);
    PodZero(ni);
    PodZero(extra, extraLength);
    ni->props_array = ni->props_cursor = reinterpret_cast<GCPtrFlatString*>(extra);
    ni->props_end = ni->props_array + plength;
    return ni;
}

NativeIterator*
NativeIterator::allocateSentinel(JSContext* maybecx)
{
    NativeIterator* ni = js_pod_malloc<NativeIterator>();
    if (!ni) {
        if (maybecx)
            ReportOutOfMemory(maybecx);
        return nullptr;
    }

    PodZero(ni);

    ni->next_ = ni;
    ni->prev_ = ni;
    return ni;
}

inline void
NativeIterator::init(JSObject* obj, JSObject* iterObj, unsigned flags, uint32_t numGuards, uint32_t key)
{
    this->obj.init(obj);
    this->iterObj_ = iterObj;
    this->flags = flags;
    this->guard_array = (HeapReceiverGuard*) this->props_end;
    this->guard_length = numGuards;
    this->guard_key = key;
}

bool
NativeIterator::initProperties(JSContext* cx, Handle<PropertyIteratorObject*> obj,
                               const AutoIdVector& props)
{
    // The obj parameter is just so that we can ensure that this object will get
    // traced if we GC.
    MOZ_ASSERT(this == obj->getNativeIterator());

    size_t plength = props.length();
    MOZ_ASSERT(plength == size_t(end() - begin()));

    for (size_t i = 0; i < plength; i++) {
        JSFlatString* str = IdToString(cx, props[i]);
        if (!str)
            return false;
        props_array[i].init(str);
    }

    return true;
}

static inline void
RegisterEnumerator(JSContext* cx, PropertyIteratorObject* iterobj, NativeIterator* ni)
{
    /* Register non-escaping native enumerators (for-in) with the current context. */
    if (ni->flags & JSITER_ENUMERATE) {
        ni->link(cx->compartment()->enumerators);

        MOZ_ASSERT(!(ni->flags & JSITER_ACTIVE));
        ni->flags |= JSITER_ACTIVE;
    }
}

static inline PropertyIteratorObject*
VectorToKeyIterator(JSContext* cx, HandleObject obj, unsigned flags, AutoIdVector& keys,
                    uint32_t numGuards)
{
    MOZ_ASSERT(!(flags & JSITER_FOREACH));

    if (obj->isSingleton() && !JSObject::setIteratedSingleton(cx, obj))
        return nullptr;
    MarkObjectGroupFlags(cx, obj, OBJECT_FLAG_ITERATED);

    Rooted<PropertyIteratorObject*> iterobj(cx, NewPropertyIteratorObject(cx, flags));
    if (!iterobj)
        return nullptr;

    NativeIterator* ni = NativeIterator::allocateIterator(cx, numGuards, keys.length());
    if (!ni)
        return nullptr;

    iterobj->setNativeIterator(ni);
    ni->init(obj, iterobj, flags, numGuards, 0);
    if (!ni->initProperties(cx, iterobj, keys))
        return nullptr;

    if (numGuards) {
        // Fill in the guard array from scratch. Also recompute the guard key
        // as we might have reshaped the object (see for instance the
        // setIteratedSingleton call above) or GC might have moved shapes and
        // groups in memory.
        JSObject* pobj = obj;
        size_t ind = 0;
        uint32_t key = 0;
        do {
            ReceiverGuard guard(pobj);
            ni->guard_array[ind++].init(guard);
            key = mozilla::AddToHash(key, guard.hash());

            // The one caller of this method that passes |numGuards > 0|, does
            // so only if the entire chain consists of cacheable objects (that
            // necessarily have static prototypes).
            pobj = pobj->staticPrototype();
        } while (pobj);
        ni->guard_key = key;
        MOZ_ASSERT(ind == numGuards);
    }

    RegisterEnumerator(cx, iterobj, ni);
    return iterobj;
}

static PropertyIteratorObject*
VectorToValueIterator(JSContext* cx, HandleObject obj, unsigned flags, AutoIdVector& keys)
{
    MOZ_ASSERT(flags & JSITER_FOREACH);

    if (obj->isSingleton() && !JSObject::setIteratedSingleton(cx, obj))
        return nullptr;
    MarkObjectGroupFlags(cx, obj, OBJECT_FLAG_ITERATED);

    Rooted<PropertyIteratorObject*> iterobj(cx, NewPropertyIteratorObject(cx, flags));
    if (!iterobj)
        return nullptr;

    NativeIterator* ni = NativeIterator::allocateIterator(cx, 0, keys.length());
    if (!ni)
        return nullptr;

    iterobj->setNativeIterator(ni);
    ni->init(obj, iterobj, flags, 0, 0);
    if (!ni->initProperties(cx, iterobj, keys))
        return nullptr;

    RegisterEnumerator(cx, iterobj, ni);
    return iterobj;
}

JSObject*
js::EnumeratedIdVectorToIterator(JSContext* cx, HandleObject obj, unsigned flags,
                                 AutoIdVector& props)
{
    if (!(flags & JSITER_FOREACH))
        return VectorToKeyIterator(cx, obj, flags, props, 0);

    return VectorToValueIterator(cx, obj, flags, props);
}

// Mainly used for .. in over null/undefined
JSObject*
js::NewEmptyPropertyIterator(JSContext* cx, unsigned flags)
{
    Rooted<PropertyIteratorObject*> iterobj(cx, NewPropertyIteratorObject(cx, flags));
    if (!iterobj)
        return nullptr;

    AutoIdVector keys(cx); // Empty
    NativeIterator* ni = NativeIterator::allocateIterator(cx, 0, keys.length());
    if (!ni)
        return nullptr;

    iterobj->setNativeIterator(ni);
    ni->init(nullptr, iterobj, flags, 0, 0);
    if (!ni->initProperties(cx, iterobj, keys))
        return nullptr;

    RegisterEnumerator(cx, iterobj, ni);
    return iterobj;
}

/* static */ bool
IteratorHashPolicy::match(PropertyIteratorObject* obj, const Lookup& lookup)
{
    NativeIterator* ni = obj->getNativeIterator();
    if (ni->guard_key != lookup.key || ni->guard_length != lookup.numGuards)
        return false;

    return PodEqual(reinterpret_cast<ReceiverGuard*>(ni->guard_array), lookup.guards,
                    ni->guard_length);
}

static inline void
UpdateNativeIterator(NativeIterator* ni, JSObject* obj)
{
    // Update the object for which the native iterator is associated, so
    // SuppressDeletedPropertyHelper will recognize the iterator as a match.
    ni->obj = obj;
}

static inline bool
CanCompareIterableObjectToCache(JSObject* obj)
{
    if (obj->isNative())
        return obj->as<NativeObject>().hasEmptyElements();
    if (obj->is<UnboxedPlainObject>()) {
        if (UnboxedExpandoObject* expando = obj->as<UnboxedPlainObject>().maybeExpando())
            return expando->hasEmptyElements();
        return true;
    }
    return false;
}

using ReceiverGuardVector = Vector<ReceiverGuard, 8>;

static MOZ_ALWAYS_INLINE PropertyIteratorObject*
LookupInIteratorCache(JSContext* cx, JSObject* obj, uint32_t* numGuards)
{
    MOZ_ASSERT(*numGuards == 0);

    // The iterator object for JSITER_ENUMERATE never escapes, so we don't
    // care that the "proper" prototype is set.  This also lets us reuse an
    // old, inactive iterator object.

    ReceiverGuardVector guards(cx);
    uint32_t key = 0;
    JSObject* pobj = obj;
    do {
        if (!CanCompareIterableObjectToCache(pobj))
            return nullptr;

        ReceiverGuard guard(pobj);
        key = mozilla::AddToHash(key, guard.hash());

        if (MOZ_UNLIKELY(!guards.append(guard))) {
            cx->recoverFromOutOfMemory();
            return nullptr;
        }

        pobj = pobj->staticPrototype();
    } while (pobj);

    MOZ_ASSERT(!guards.empty());
    *numGuards = guards.length();

    IteratorHashPolicy::Lookup lookup(guards.begin(), guards.length(), key);
    auto p = cx->compartment()->iteratorCache.lookup(lookup);
    if (!p)
        return nullptr;

    PropertyIteratorObject* iterobj = *p;
    MOZ_ASSERT(iterobj->compartment() == cx->compartment());

    NativeIterator* ni = iterobj->getNativeIterator();
    if (ni->flags & (JSITER_ACTIVE|JSITER_UNREUSABLE))
        return nullptr;

    return iterobj;
}

static bool
CanStoreInIteratorCache(JSContext* cx, JSObject* obj)
{
    do {
        if (obj->isNative()) {
            MOZ_ASSERT(obj->as<NativeObject>().hasEmptyElements());

            // Typed arrays have indexed properties not captured by the Shape guard.
            // Enumerate hooks may add extra properties.
            const Class* clasp = obj->getClass();
            if (MOZ_UNLIKELY(IsTypedArrayClass(clasp)))
                return false;
            if (MOZ_UNLIKELY(clasp->getNewEnumerate() || clasp->getEnumerate()))
                return false;

            if (MOZ_UNLIKELY(obj->as<NativeObject>().containsPure(cx->names().iteratorIntrinsic)))
                return false;
        } else {
            MOZ_ASSERT(obj->is<UnboxedPlainObject>());
        }

        obj = obj->staticPrototype();
    } while (obj);

    return true;
}

static MOZ_MUST_USE bool
StoreInIteratorCache(JSContext* cx, JSObject* obj, PropertyIteratorObject* iterobj)
{
    MOZ_ASSERT(CanStoreInIteratorCache(cx, obj));

    NativeIterator* ni = iterobj->getNativeIterator();
    MOZ_ASSERT(ni->guard_length > 0);

    IteratorHashPolicy::Lookup lookup(reinterpret_cast<ReceiverGuard*>(ni->guard_array),
                                      ni->guard_length, ni->guard_key);

    JSCompartment::IteratorCache& cache = cx->compartment()->iteratorCache;
    bool ok;
    auto p = cache.lookupForAdd(lookup);
    if (MOZ_LIKELY(!p)) {
        ok = cache.add(p, iterobj);
    } else {
        // If we weren't able to use an existing cached iterator, just
        // replace it.
        cache.remove(p);
        ok = cache.relookupOrAdd(p, lookup, iterobj);
    }
    if (!ok) {
        ReportOutOfMemory(cx);
        return false;
    }

    return true;
}

JSObject*
js::GetIterator(JSContext* cx, HandleObject obj, unsigned flags)
{
    uint32_t numGuards = 0;
    if (flags == JSITER_ENUMERATE) {
        if (PropertyIteratorObject* iterobj = LookupInIteratorCache(cx, obj, &numGuards)) {
            NativeIterator* ni = iterobj->getNativeIterator();
            UpdateNativeIterator(ni, obj);
            RegisterEnumerator(cx, iterobj, ni);
            return iterobj;
        }

        if (numGuards > 0 && !CanStoreInIteratorCache(cx, obj))
            numGuards = 0;
    }

    if (MOZ_UNLIKELY(obj->is<PropertyIteratorObject>() || obj->is<LegacyGeneratorObject>()))
        return obj;

    // We should only call the enumerate trap for "for-in".
    // Or when we call GetIterator from the Proxy [[Enumerate]] hook.
    // JSITER_ENUMERATE is just an optimization and the same
    // as flags == 0 otherwise.
    if (flags == 0 || flags == JSITER_ENUMERATE) {
        if (MOZ_UNLIKELY(obj->is<ProxyObject>()))
            return Proxy::enumerate(cx, obj);
    }

    RootedObject res(cx);
    if (!GetCustomIterator(cx, obj, flags, &res))
        return nullptr;
    if (res) {
        assertSameCompartment(cx, res);
        return res;
    }

    AutoIdVector keys(cx);
    if (!Snapshot(cx, obj, flags, &keys))
        return nullptr;

    if (flags & JSITER_FOREACH) {
        MOZ_ASSERT(numGuards == 0);
        res = VectorToValueIterator(cx, obj, flags, keys);
        if (!res)
            return nullptr;
    } else {
        res = VectorToKeyIterator(cx, obj, flags, keys, numGuards);
        if (!res)
            return nullptr;
    }

    PropertyIteratorObject* iterobj = &res->as<PropertyIteratorObject>();
    assertSameCompartment(cx, iterobj);

    // Cache the iterator object.
    if (numGuards > 0) {
        if (!StoreInIteratorCache(cx, obj, iterobj))
            return nullptr;
    }

    return iterobj;
}

PropertyIteratorObject*
js::LookupInIteratorCache(JSContext* cx, HandleObject obj)
{
    uint32_t numGuards = 0;
    return LookupInIteratorCache(cx, obj, &numGuards);
}

// ES 2017 draft 7.4.7.
JSObject*
js::CreateIterResultObject(JSContext* cx, HandleValue value, bool done)
{
    // Step 1 (implicit).

    // Step 2.
    RootedObject resultObj(cx, NewBuiltinClassInstance<PlainObject>(cx));
    if (!resultObj)
        return nullptr;

    // Step 3.
    if (!DefineProperty(cx, resultObj, cx->names().value, value))
        return nullptr;

    // Step 4.
    if (!DefineProperty(cx, resultObj, cx->names().done,
                        done ? TrueHandleValue : FalseHandleValue))
    {
        return nullptr;
    }

    // Step 5.
    return resultObj;
}

bool
js::ThrowStopIteration(JSContext* cx)
{
    MOZ_ASSERT(!JS_IsExceptionPending(cx));

    // StopIteration isn't a constructor, but it's stored in GlobalObject
    // as one, out of laziness. Hence the GetBuiltinConstructor call here.
    RootedObject ctor(cx);
    if (GetBuiltinConstructor(cx, JSProto_StopIteration, &ctor))
        cx->setPendingException(ObjectValue(*ctor));
    return false;
}

/*** Iterator objects ****************************************************************************/

bool
js::IteratorConstructor(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    if (args.length() == 0) {
        ReportMissingArg(cx, args.calleev(), 0);
        return false;
    }

    bool keyonly = false;
    if (args.length() >= 2)
        keyonly = ToBoolean(args[1]);
    unsigned flags = JSITER_OWNONLY | (keyonly ? 0 : (JSITER_FOREACH | JSITER_KEYVALUE));

    RootedObject iterobj(cx, ValueToIterator(cx, flags, args[0]));
    if (!iterobj)
        return false;
    args.rval().setObject(*iterobj);
    return true;
}

MOZ_ALWAYS_INLINE bool
NativeIteratorNext(JSContext* cx, NativeIterator* ni, MutableHandleValue rval, bool* done)
{
    *done = false;

    if (ni->props_cursor >= ni->props_end) {
        *done = true;
        return true;
    }

    if (MOZ_LIKELY(ni->isKeyIter())) {
        rval.setString(*ni->current());
        ni->incCursor();
        return true;
    }

    // Non-standard Iterator for "for each"
    RootedId id(cx);
    RootedValue current(cx, StringValue(*ni->current()));
    if (!ValueToId<CanGC>(cx, current, &id))
        return false;
    ni->incCursor();
    RootedObject obj(cx, ni->obj);
    if (!GetProperty(cx, obj, obj, id, rval))
        return false;

    // JS 1.7 only: for each (let [k, v] in obj)
    if (ni->flags & JSITER_KEYVALUE)
        return NewKeyValuePair(cx, id, rval, rval);
    return true;
}

MOZ_ALWAYS_INLINE bool
IsIterator(HandleValue v)
{
    return v.isObject() && v.toObject().hasClass(&PropertyIteratorObject::class_);
}

MOZ_ALWAYS_INLINE bool
legacy_iterator_next_impl(JSContext* cx, const CallArgs& args)
{
    MOZ_ASSERT(IsIterator(args.thisv()));

    RootedObject thisObj(cx, &args.thisv().toObject());

    NativeIterator* ni = thisObj.as<PropertyIteratorObject>()->getNativeIterator();
    RootedValue value(cx);
    bool done;
    if (!NativeIteratorNext(cx, ni, &value, &done))
         return false;

    // Use old iterator protocol for compatibility reasons.
    if (done) {
        ThrowStopIteration(cx);
        return false;
    }

    args.rval().set(value);
    return true;
}

static bool
legacy_iterator_next(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return CallNonGenericMethod<IsIterator, legacy_iterator_next_impl>(cx, args);
}

static const JSFunctionSpec legacy_iterator_methods[] = {
    JS_SELF_HOSTED_SYM_FN(iterator, "LegacyIteratorShim", 0, 0),
    JS_FN("next",      legacy_iterator_next,       0, 0),
    JS_FS_END
};

size_t
PropertyIteratorObject::sizeOfMisc(mozilla::MallocSizeOf mallocSizeOf) const
{
    return mallocSizeOf(getPrivate());
}

void
PropertyIteratorObject::trace(JSTracer* trc, JSObject* obj)
{
    if (NativeIterator* ni = obj->as<PropertyIteratorObject>().getNativeIterator())
        ni->trace(trc);
}

void
PropertyIteratorObject::finalize(FreeOp* fop, JSObject* obj)
{
    if (NativeIterator* ni = obj->as<PropertyIteratorObject>().getNativeIterator())
        fop->free_(ni);
}

const ClassOps PropertyIteratorObject::classOps_ = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* newEnumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    finalize,
    nullptr, /* call        */
    nullptr, /* hasInstance */
    nullptr, /* construct   */
    trace
};

const Class PropertyIteratorObject::class_ = {
    "Iterator",
    JSCLASS_HAS_CACHED_PROTO(JSProto_Iterator) |
    JSCLASS_HAS_PRIVATE |
    JSCLASS_BACKGROUND_FINALIZE,
    &PropertyIteratorObject::classOps_
};

static const Class ArrayIteratorPrototypeClass = {
    "Array Iterator",
    0
};

enum {
    ArrayIteratorSlotIteratedObject,
    ArrayIteratorSlotNextIndex,
    ArrayIteratorSlotItemKind,
    ArrayIteratorSlotCount
};

const Class ArrayIteratorObject::class_ = {
    "Array Iterator",
    JSCLASS_HAS_RESERVED_SLOTS(ArrayIteratorSlotCount)
};


ArrayIteratorObject*
js::NewArrayIteratorObject(JSContext* cx, NewObjectKind newKind)
{
    RootedObject proto(cx, GlobalObject::getOrCreateArrayIteratorPrototype(cx, cx->global()));
    if (!proto)
        return nullptr;

    return NewObjectWithGivenProto<ArrayIteratorObject>(cx, proto, newKind);
}

static const JSFunctionSpec array_iterator_methods[] = {
    JS_SELF_HOSTED_FN("next", "ArrayIteratorNext", 0, 0),
    JS_FS_END
};

static const Class StringIteratorPrototypeClass = {
    "String Iterator",
    0
};

enum {
    StringIteratorSlotIteratedObject,
    StringIteratorSlotNextIndex,
    StringIteratorSlotCount
};

const Class StringIteratorObject::class_ = {
    "String Iterator",
    JSCLASS_HAS_RESERVED_SLOTS(StringIteratorSlotCount)
};

static const JSFunctionSpec string_iterator_methods[] = {
    JS_SELF_HOSTED_FN("next", "StringIteratorNext", 0, 0),
    JS_FS_END
};

StringIteratorObject*
js::NewStringIteratorObject(JSContext* cx, NewObjectKind newKind)
{
    RootedObject proto(cx, GlobalObject::getOrCreateStringIteratorPrototype(cx, cx->global()));
    if (!proto)
        return nullptr;

    return NewObjectWithGivenProto<StringIteratorObject>(cx, proto, newKind);
}

JSObject*
js::ValueToIterator(JSContext* cx, unsigned flags, HandleValue vp)
{
    /* JSITER_KEYVALUE must always come with JSITER_FOREACH */
    MOZ_ASSERT_IF(flags & JSITER_KEYVALUE, flags & JSITER_FOREACH);

    RootedObject obj(cx);
    if (vp.isObject()) {
        /* Common case. */
        obj = &vp.toObject();
    } else if ((flags & JSITER_ENUMERATE) && vp.isNullOrUndefined()) {
        /*
         * Enumerating over null and undefined gives an empty enumerator, so
         * that |for (var p in <null or undefined>) <loop>;| never executes
         * <loop>, per ES5 12.6.4.
         */
        return NewEmptyPropertyIterator(cx, flags);
    } else {
        obj = ToObject(cx, vp);
        if (!obj)
            return nullptr;
    }

    return GetIterator(cx, obj, flags);
}

bool
js::CloseIterator(JSContext* cx, HandleObject obj)
{
    if (obj->is<PropertyIteratorObject>()) {
        /* Remove enumerators from the active list, which is a stack. */
        NativeIterator* ni = obj->as<PropertyIteratorObject>().getNativeIterator();

        if (ni->flags & JSITER_ENUMERATE) {
            ni->unlink();

            MOZ_ASSERT(ni->flags & JSITER_ACTIVE);
            ni->flags &= ~JSITER_ACTIVE;

            /*
             * Reset the enumerator; it may still be in the cached iterators
             * for this thread, and can be reused.
             */
            ni->props_cursor = ni->props_array;
        }
    } else if (obj->is<LegacyGeneratorObject>()) {
        Rooted<LegacyGeneratorObject*> genObj(cx, &obj->as<LegacyGeneratorObject>());
        if (genObj->isClosed())
            return true;
        if (genObj->isRunning() || genObj->isClosing()) {
            // Nothing sensible to do.
            return true;
        }
        return LegacyGeneratorObject::close(cx, obj);
    }

    return true;
}

bool
js::UnwindIteratorForException(JSContext* cx, HandleObject obj)
{
    RootedValue v(cx);
    bool getOk = cx->getPendingException(&v);
    cx->clearPendingException();
    if (!CloseIterator(cx, obj))
        return false;
    if (!getOk)
        return false;
    cx->setPendingException(v);
    return true;
}

bool
js::IteratorCloseForException(JSContext* cx, HandleObject obj)
{
    MOZ_ASSERT(cx->isExceptionPending());

    bool isClosingGenerator = cx->isClosingGenerator();
    JS::AutoSaveExceptionState savedExc(cx);

    // Implements IteratorClose (ES 7.4.6) for exception unwinding. See
    // also the bytecode generated by BytecodeEmitter::emitIteratorClose.

    // Step 3.
    //
    // Get the "return" method.
    RootedValue returnMethod(cx);
    if (!GetProperty(cx, obj, obj, cx->names().return_, &returnMethod))
        return false;

    // Step 4.
    //
    // Do nothing if "return" is null or undefined. Throw a TypeError if the
    // method is not IsCallable.
    if (returnMethod.isNullOrUndefined())
        return true;
    if (!IsCallable(returnMethod))
        return ReportIsNotFunction(cx, returnMethod);

    // Step 5, 6, 8.
    //
    // Call "return" if it is not null or undefined.
    RootedValue rval(cx);
    bool ok = Call(cx, returnMethod, obj, &rval);
    if (isClosingGenerator) {
        // Closing an iterator is implemented as an exception, but in spec
        // terms it is a Completion value with [[Type]] return. In this case
        // we *do* care if the call threw and if it returned an object.
        if (!ok)
            return false;
        if (!rval.isObject())
            return ThrowCheckIsObject(cx, CheckIsObjectKind::IteratorReturn);
    } else {
        // We don't care if the call threw or that it returned an Object, as
        // Step 6 says if IteratorClose is being called during a throw, the
        // original throw has primacy.
        savedExc.restore();
    }

    return true;
}

void
js::UnwindIteratorForUncatchableException(JSContext* cx, JSObject* obj)
{
    if (obj->is<PropertyIteratorObject>()) {
        NativeIterator* ni = obj->as<PropertyIteratorObject>().getNativeIterator();
        if (ni->flags & JSITER_ENUMERATE)
            ni->unlink();
    }
}

/*
 * Suppress enumeration of deleted properties. This function must be called
 * when a property is deleted and there might be active enumerators.
 *
 * We maintain a list of active non-escaping for-in enumerators. To suppress
 * a property, we check whether each active enumerator contains the (obj, id)
 * pair and has not yet enumerated |id|. If so, and |id| is the next property,
 * we simply advance the cursor. Otherwise, we delete |id| from the list.
 *
 * We do not suppress enumeration of a property deleted along an object's
 * prototype chain. Only direct deletions on the object are handled.
 *
 * This function can suppress multiple properties at once. The |predicate|
 * argument is an object which can be called on an id and returns true or
 * false. It also must have a method |matchesAtMostOne| which allows us to
 * stop searching after the first deletion if true.
 */
template<typename StringPredicate>
static bool
SuppressDeletedPropertyHelper(JSContext* cx, HandleObject obj, StringPredicate predicate)
{
    NativeIterator* enumeratorList = cx->compartment()->enumerators;
    NativeIterator* ni = enumeratorList->next();

    while (ni != enumeratorList) {
      again:
        /* This only works for identified suppressed keys, not values. */
        if (ni->isKeyIter() && ni->obj == obj && ni->props_cursor < ni->props_end) {
            /* Check whether id is still to come. */
            GCPtrFlatString* props_cursor = ni->current();
            GCPtrFlatString* props_end = ni->end();
            for (GCPtrFlatString* idp = props_cursor; idp < props_end; ++idp) {
                if (predicate(*idp)) {
                    /*
                     * Check whether another property along the prototype chain
                     * became visible as a result of this deletion.
                     */
                    RootedObject proto(cx);
                    if (!GetPrototype(cx, obj, &proto))
                        return false;
                    if (proto) {
                        RootedId id(cx);
                        RootedValue idv(cx, StringValue(*idp));
                        if (!ValueToId<CanGC>(cx, idv, &id))
                            return false;

                        Rooted<PropertyDescriptor> desc(cx);
                        if (!GetPropertyDescriptor(cx, proto, id, &desc))
                            return false;

                        if (desc.object()) {
                            if (desc.enumerable())
                                continue;
                        }
                    }

                    /*
                     * If GetPropertyDescriptorById above removed a property from
                     * ni, start over.
                     */
                    if (props_end != ni->props_end || props_cursor != ni->props_cursor)
                        goto again;

                    /*
                     * No property along the prototype chain stepped in to take the
                     * property's place, so go ahead and delete id from the list.
                     * If it is the next property to be enumerated, just skip it.
                     */
                    if (idp == props_cursor) {
                        ni->incCursor();
                    } else {
                        for (GCPtrFlatString* p = idp; p + 1 != props_end; p++)
                            *p = *(p + 1);
                        ni->props_end = ni->end() - 1;

                        /*
                         * This invokes the pre barrier on this element, since
                         * it's no longer going to be marked, and ensures that
                         * any existing remembered set entry will be dropped.
                         */
                        *ni->props_end = nullptr;
                    }

                    /* Don't reuse modified native iterators. */
                    ni->flags |= JSITER_UNREUSABLE;

                    if (predicate.matchesAtMostOne())
                        break;
                }
            }
        }
        ni = ni->next();
    }
    return true;
}

namespace {

class SingleStringPredicate {
    Handle<JSFlatString*> str;
public:
    explicit SingleStringPredicate(Handle<JSFlatString*> str) : str(str) {}

    bool operator()(JSFlatString* str) { return EqualStrings(str, this->str); }
    bool matchesAtMostOne() { return true; }
};

} /* anonymous namespace */

bool
js::SuppressDeletedProperty(JSContext* cx, HandleObject obj, jsid id)
{
    if (MOZ_LIKELY(!cx->compartment()->objectMaybeInIteration(obj)))
        return true;

    if (JSID_IS_SYMBOL(id))
        return true;

    Rooted<JSFlatString*> str(cx, IdToString(cx, id));
    if (!str)
        return false;
    return SuppressDeletedPropertyHelper(cx, obj, SingleStringPredicate(str));
}

bool
js::SuppressDeletedElement(JSContext* cx, HandleObject obj, uint32_t index)
{
    if (MOZ_LIKELY(!cx->compartment()->objectMaybeInIteration(obj)))
        return true;

    RootedId id(cx);
    if (!IndexToId(cx, index, &id))
        return false;

    Rooted<JSFlatString*> str(cx, IdToString(cx, id));
    if (!str)
        return false;
    return SuppressDeletedPropertyHelper(cx, obj, SingleStringPredicate(str));
}

bool
js::IteratorMore(JSContext* cx, HandleObject iterobj, MutableHandleValue rval)
{
    // Fast path for native iterators.
    if (iterobj->is<PropertyIteratorObject>()) {
        NativeIterator* ni = iterobj->as<PropertyIteratorObject>().getNativeIterator();
        bool done;
        if (!NativeIteratorNext(cx, ni, rval, &done))
            return false;

        if (done)
            rval.setMagic(JS_NO_ITER_VALUE);
        return true;
    }

    // We're reentering below and can call anything.
    if (!CheckRecursionLimit(cx))
        return false;

    // Call the iterator object's .next method.
    if (!GetProperty(cx, iterobj, iterobj, cx->names().next, rval))
        return false;

    // Call the .next method.  Fall through to the error-handling cases in the
    // unlikely event that either one of the fallible operations performed
    // during the call process fails.
    FixedInvokeArgs<0> args(cx);
    RootedValue iterval(cx, ObjectValue(*iterobj));
    if (!js::Call(cx, rval, iterval, args, rval)) {
        // Check for StopIteration.
        if (!cx->isExceptionPending())
            return false;
        RootedValue exception(cx);
        if (!cx->getPendingException(&exception))
            return false;
        if (!JS_IsStopIteration(exception))
            return false;

        cx->clearPendingException();
        rval.setMagic(JS_NO_ITER_VALUE);
    }

    return true;
}

static bool
stopiter_hasInstance(JSContext* cx, HandleObject obj, MutableHandleValue v, bool* bp)
{
    *bp = JS_IsStopIteration(v);
    return true;
}

static const ClassOps StopIterationObjectClassOps = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    nullptr, /* finalize */
    nullptr, /* call */
    stopiter_hasInstance
};

const Class StopIterationObject::class_ = {
    "StopIteration",
    JSCLASS_HAS_CACHED_PROTO(JSProto_StopIteration),
    &StopIterationObjectClassOps
};

static const JSFunctionSpec iterator_proto_methods[] = {
    JS_SELF_HOSTED_SYM_FN(iterator, "IteratorIdentity", 0, 0),
    JS_FS_END
};

/* static */ bool
GlobalObject::initIteratorProto(JSContext* cx, Handle<GlobalObject*> global)
{
    if (global->getReservedSlot(ITERATOR_PROTO).isObject())
        return true;

    RootedObject proto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!proto || !DefinePropertiesAndFunctions(cx, proto, nullptr, iterator_proto_methods))
        return false;

    global->setReservedSlot(ITERATOR_PROTO, ObjectValue(*proto));
    return true;
}

/* static */ bool
GlobalObject::initArrayIteratorProto(JSContext* cx, Handle<GlobalObject*> global)
{
    if (global->getReservedSlot(ARRAY_ITERATOR_PROTO).isObject())
        return true;

    RootedObject iteratorProto(cx, GlobalObject::getOrCreateIteratorPrototype(cx, global));
    if (!iteratorProto)
        return false;

    const Class* cls = &ArrayIteratorPrototypeClass;
    RootedObject proto(cx, GlobalObject::createBlankPrototypeInheriting(cx, global, cls,
                                                                        iteratorProto));
    if (!proto ||
        !DefinePropertiesAndFunctions(cx, proto, nullptr, array_iterator_methods) ||
        !DefineToStringTag(cx, proto, cx->names().ArrayIterator))
    {
        return false;
    }

    global->setReservedSlot(ARRAY_ITERATOR_PROTO, ObjectValue(*proto));
    return true;
}

/* static */ bool
GlobalObject::initStringIteratorProto(JSContext* cx, Handle<GlobalObject*> global)
{
    if (global->getReservedSlot(STRING_ITERATOR_PROTO).isObject())
        return true;

    RootedObject iteratorProto(cx, GlobalObject::getOrCreateIteratorPrototype(cx, global));
    if (!iteratorProto)
        return false;

    const Class* cls = &StringIteratorPrototypeClass;
    RootedObject proto(cx, GlobalObject::createBlankPrototypeInheriting(cx, global, cls,
                                                                        iteratorProto));
    if (!proto ||
        !DefinePropertiesAndFunctions(cx, proto, nullptr, string_iterator_methods) ||
        !DefineToStringTag(cx, proto, cx->names().StringIterator))
    {
        return false;
    }

    global->setReservedSlot(STRING_ITERATOR_PROTO, ObjectValue(*proto));
    return true;
}

JSObject*
js::InitLegacyIteratorClass(JSContext* cx, HandleObject obj)
{
    Handle<GlobalObject*> global = obj.as<GlobalObject>();

    if (global->getPrototype(JSProto_Iterator).isObject())
        return &global->getPrototype(JSProto_Iterator).toObject();

    RootedObject iteratorProto(cx);
    iteratorProto = GlobalObject::createBlankPrototype(cx, global,
                                                       &PropertyIteratorObject::class_);
    if (!iteratorProto)
        return nullptr;

    NativeIterator* ni = NativeIterator::allocateIterator(cx, 0, 0);
    if (!ni)
        return nullptr;

    iteratorProto->as<PropertyIteratorObject>().setNativeIterator(ni);
    ni->init(nullptr, nullptr, 0 /* flags */, 0, 0);

    Rooted<JSFunction*> ctor(cx);
    ctor = GlobalObject::createConstructor(cx, IteratorConstructor, cx->names().Iterator, 2);
    if (!ctor)
        return nullptr;
    if (!LinkConstructorAndPrototype(cx, ctor, iteratorProto))
        return nullptr;
    if (!DefinePropertiesAndFunctions(cx, iteratorProto, nullptr, legacy_iterator_methods))
        return nullptr;
    if (!GlobalObject::initBuiltinConstructor(cx, global, JSProto_Iterator,
                                              ctor, iteratorProto))
    {
        return nullptr;
    }

    return &global->getPrototype(JSProto_Iterator).toObject();
}

JSObject*
js::InitStopIterationClass(JSContext* cx, HandleObject obj)
{
    Handle<GlobalObject*> global = obj.as<GlobalObject>();
    if (!global->getPrototype(JSProto_StopIteration).isObject()) {
        RootedObject proto(cx, GlobalObject::createBlankPrototype(cx, global,
                                                                  &StopIterationObject::class_));
        if (!proto || !FreezeObject(cx, proto))
            return nullptr;

        // This should use a non-JSProtoKey'd slot, but this is easier for now.
        if (!GlobalObject::initBuiltinConstructor(cx, global, JSProto_StopIteration, proto, proto))
            return nullptr;

        global->setConstructor(JSProto_StopIteration, ObjectValue(*proto));
    }

    return &global->getPrototype(JSProto_StopIteration).toObject();
}
