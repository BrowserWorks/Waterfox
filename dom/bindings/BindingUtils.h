/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_BindingUtils_h__
#define mozilla_dom_BindingUtils_h__

#include "jsfriendapi.h"
#include "jswrapper.h"
#include "js/Conversions.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/Alignment.h"
#include "mozilla/Array.h"
#include "mozilla/Assertions.h"
#include "mozilla/CycleCollectedJSContext.h"
#include "mozilla/DeferredFinalize.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/CallbackObject.h"
#include "mozilla/dom/DOMJSClass.h"
#include "mozilla/dom/DOMJSProxyHandler.h"
#include "mozilla/dom/Exceptions.h"
#include "mozilla/dom/NonRefcountedDOMObject.h"
#include "mozilla/dom/Nullable.h"
#include "mozilla/dom/RootedDictionary.h"
#include "mozilla/SegmentedVector.h"
#include "mozilla/dom/workers/Workers.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/Likely.h"
#include "mozilla/MemoryReporting.h"
#include "nsAutoPtr.h"
#include "nsIDocument.h"
#include "nsIGlobalObject.h"
#include "nsIXPConnect.h"
#include "nsJSUtils.h"
#include "nsISupportsImpl.h"
#include "qsObjectHelper.h"
#include "xpcpublic.h"
#include "nsIVariant.h"
#include "mozilla/dom/FakeString.h"

#include "nsWrapperCacheInlines.h"

class nsIJSID;

namespace mozilla {

enum UseCounter : int16_t;

namespace dom {
template<typename DataType> class MozMap;

nsresult
UnwrapArgImpl(JS::Handle<JSObject*> src, const nsIID& iid, void** ppArg);

nsresult
UnwrapWindowProxyImpl(JS::Handle<JSObject*> src, nsPIDOMWindowOuter** ppArg);

/** Convert a jsval to an XPCOM pointer. */
template <class Interface>
inline nsresult
UnwrapArg(JS::Handle<JSObject*> src, Interface** ppArg)
{
  return UnwrapArgImpl(src, NS_GET_TEMPLATE_IID(Interface),
                       reinterpret_cast<void**>(ppArg));
}

template <>
inline nsresult
UnwrapArg<nsPIDOMWindowOuter>(JS::Handle<JSObject*> src, nsPIDOMWindowOuter** ppArg)
{
  return UnwrapWindowProxyImpl(src, ppArg);
}

bool
ThrowInvalidThis(JSContext* aCx, const JS::CallArgs& aArgs,
                 bool aSecurityError, const char* aInterfaceName);

bool
ThrowInvalidThis(JSContext* aCx, const JS::CallArgs& aArgs,
                 bool aSecurityError, prototypes::ID aProtoId);

// Returns true if the JSClass is used for DOM objects.
inline bool
IsDOMClass(const JSClass* clasp)
{
  return clasp->flags & JSCLASS_IS_DOMJSCLASS;
}

inline bool
IsDOMClass(const js::Class* clasp)
{
  return IsDOMClass(Jsvalify(clasp));
}

// Return true if the JSClass is used for non-proxy DOM objects.
inline bool
IsNonProxyDOMClass(const js::Class* clasp)
{
  return IsDOMClass(clasp) && !clasp->isProxy();
}

inline bool
IsNonProxyDOMClass(const JSClass* clasp)
{
  return IsNonProxyDOMClass(js::Valueify(clasp));
}

// Returns true if the JSClass is used for DOM interface and interface
// prototype objects.
inline bool
IsDOMIfaceAndProtoClass(const JSClass* clasp)
{
  return clasp->flags & JSCLASS_IS_DOMIFACEANDPROTOJSCLASS;
}

inline bool
IsDOMIfaceAndProtoClass(const js::Class* clasp)
{
  return IsDOMIfaceAndProtoClass(Jsvalify(clasp));
}

static_assert(DOM_OBJECT_SLOT == 0,
              "DOM_OBJECT_SLOT doesn't match the proxy private slot.  "
              "Expect bad things");
template <class T>
inline T*
UnwrapDOMObject(JSObject* obj)
{
  MOZ_ASSERT(IsDOMClass(js::GetObjectClass(obj)),
             "Don't pass non-DOM objects to this function");

  JS::Value val = js::GetReservedOrProxyPrivateSlot(obj, DOM_OBJECT_SLOT);
  return static_cast<T*>(val.toPrivate());
}

template <class T>
inline T*
UnwrapPossiblyNotInitializedDOMObject(JSObject* obj)
{
  // This is used by the OjectMoved JSClass hook which can be called before
  // JS_NewObject has returned and so before we have a chance to set
  // DOM_OBJECT_SLOT to anything useful.

  MOZ_ASSERT(IsDOMClass(js::GetObjectClass(obj)),
             "Don't pass non-DOM objects to this function");

  JS::Value val = js::GetReservedOrProxyPrivateSlot(obj, DOM_OBJECT_SLOT);
  if (val.isUndefined()) {
    return nullptr;
  }
  return static_cast<T*>(val.toPrivate());
}

inline const DOMJSClass*
GetDOMClass(const js::Class* clasp)
{
  return IsDOMClass(clasp) ? DOMJSClass::FromJSClass(clasp) : nullptr;
}

inline const DOMJSClass*
GetDOMClass(JSObject* obj)
{
  return GetDOMClass(js::GetObjectClass(obj));
}

inline nsISupports*
UnwrapDOMObjectToISupports(JSObject* aObject)
{
  const DOMJSClass* clasp = GetDOMClass(aObject);
  if (!clasp || !clasp->mDOMObjectIsISupports) {
    return nullptr;
  }

  return UnwrapPossiblyNotInitializedDOMObject<nsISupports>(aObject);
}

inline bool
IsDOMObject(JSObject* obj)
{
  return IsDOMClass(js::GetObjectClass(obj));
}

#define UNWRAP_OBJECT(Interface, obj, value)                                 \
  mozilla::dom::UnwrapObject<mozilla::dom::prototypes::id::Interface,        \
    mozilla::dom::Interface##Binding::NativeType>(obj, value)

// Some callers don't want to set an exception when unwrapping fails
// (for example, overload resolution uses unwrapping to tell what sort
// of thing it's looking at).
// U must be something that a T* can be assigned to (e.g. T* or an RefPtr<T>).
template <class T, typename U>
MOZ_ALWAYS_INLINE nsresult
UnwrapObject(JSObject* obj, U& value, prototypes::ID protoID,
             uint32_t protoDepth)
{
  /* First check to see whether we have a DOM object */
  const DOMJSClass* domClass = GetDOMClass(obj);
  if (!domClass) {
    /* Maybe we have a security wrapper or outer window? */
    if (!js::IsWrapper(obj)) {
      /* Not a DOM object, not a wrapper, just bail */
      return NS_ERROR_XPC_BAD_CONVERT_JS;
    }

    obj = js::CheckedUnwrap(obj, /* stopAtWindowProxy = */ false);
    if (!obj) {
      return NS_ERROR_XPC_SECURITY_MANAGER_VETO;
    }
    MOZ_ASSERT(!js::IsWrapper(obj));
    domClass = GetDOMClass(obj);
    if (!domClass) {
      /* We don't have a DOM object */
      return NS_ERROR_XPC_BAD_CONVERT_JS;
    }
  }

  /* This object is a DOM object.  Double-check that it is safely
     castable to T by checking whether it claims to inherit from the
     class identified by protoID. */
  if (domClass->mInterfaceChain[protoDepth] == protoID) {
    value = UnwrapDOMObject<T>(obj);
    return NS_OK;
  }

  /* It's the wrong sort of DOM object */
  return NS_ERROR_XPC_BAD_CONVERT_JS;
}

template <prototypes::ID PrototypeID, class T, typename U>
MOZ_ALWAYS_INLINE nsresult
UnwrapObject(JSObject* obj, U& value)
{
  return UnwrapObject<T>(obj, value, PrototypeID,
                         PrototypeTraits<PrototypeID>::Depth);
}

inline bool
IsNotDateOrRegExp(JSContext* cx, JS::Handle<JSObject*> obj,
                  bool* notDateOrRegExp)
{
  MOZ_ASSERT(obj);

  js::ESClass cls;
  if (!js::GetBuiltinClass(cx, obj, &cls)) {
    return false;
  }

  *notDateOrRegExp = cls != js::ESClass::Date && cls != js::ESClass::RegExp;
  return true;
}

MOZ_ALWAYS_INLINE bool
IsObjectValueConvertibleToDictionary(JSContext* cx,
                                     JS::Handle<JS::Value> objVal,
                                     bool* convertible)
{
  JS::Rooted<JSObject*> obj(cx, &objVal.toObject());
  return IsNotDateOrRegExp(cx, obj, convertible);
}

MOZ_ALWAYS_INLINE bool
IsConvertibleToDictionary(JSContext* cx, JS::Handle<JS::Value> val,
                          bool* convertible)
{
  if (val.isNullOrUndefined()) {
    *convertible = true;
    return true;
  }
  if (!val.isObject()) {
    *convertible = false;
    return true;
  }
  return IsObjectValueConvertibleToDictionary(cx, val, convertible);
}

MOZ_ALWAYS_INLINE bool
IsConvertibleToCallbackInterface(JSContext* cx, JS::Handle<JSObject*> obj,
                                 bool* convertible)
{
  return IsNotDateOrRegExp(cx, obj, convertible);
}

// The items in the protoAndIfaceCache are indexed by the prototypes::id::ID,
// constructors::id::ID and namedpropertiesobjects::id::ID enums, in that order.
// The end of the prototype objects should be the start of the interface
// objects, and the end of the interface objects should be the start of the
// named properties objects.
static_assert((size_t)constructors::id::_ID_Start ==
              (size_t)prototypes::id::_ID_Count &&
              (size_t)namedpropertiesobjects::id::_ID_Start ==
              (size_t)constructors::id::_ID_Count,
              "Overlapping or discontiguous indexes.");
const size_t kProtoAndIfaceCacheCount = namedpropertiesobjects::id::_ID_Count;

class ProtoAndIfaceCache
{
  // The caching strategy we use depends on what sort of global we're dealing
  // with.  For a window-like global, we want everything to be as fast as
  // possible, so we use a flat array, indexed by prototype/constructor ID.
  // For everything else (e.g. globals for JSMs), space is more important than
  // speed, so we use a two-level lookup table.

  class ArrayCache : public Array<JS::Heap<JSObject*>, kProtoAndIfaceCacheCount>
  {
  public:
    JSObject* EntrySlotIfExists(size_t i) {
      return (*this)[i];
    }

    JS::Heap<JSObject*>& EntrySlotOrCreate(size_t i) {
      return (*this)[i];
    }

    JS::Heap<JSObject*>& EntrySlotMustExist(size_t i) {
      return (*this)[i];
    }

    void Trace(JSTracer* aTracer) {
      for (size_t i = 0; i < ArrayLength(*this); ++i) {
        JS::TraceEdge(aTracer, &(*this)[i], "protoAndIfaceCache[i]");
      }
    }

    size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) {
      return aMallocSizeOf(this);
    }
  };

  class PageTableCache
  {
  public:
    PageTableCache() {
      memset(&mPages, 0, sizeof(mPages));
    }

    ~PageTableCache() {
      for (size_t i = 0; i < ArrayLength(mPages); ++i) {
        delete mPages[i];
      }
    }

    JSObject* EntrySlotIfExists(size_t i) {
      MOZ_ASSERT(i < kProtoAndIfaceCacheCount);
      size_t pageIndex = i / kPageSize;
      size_t leafIndex = i % kPageSize;
      Page* p = mPages[pageIndex];
      if (!p) {
        return nullptr;
      }
      return (*p)[leafIndex];
    }

    JS::Heap<JSObject*>& EntrySlotOrCreate(size_t i) {
      MOZ_ASSERT(i < kProtoAndIfaceCacheCount);
      size_t pageIndex = i / kPageSize;
      size_t leafIndex = i % kPageSize;
      Page* p = mPages[pageIndex];
      if (!p) {
        p = new Page;
        mPages[pageIndex] = p;
      }
      return (*p)[leafIndex];
    }

    JS::Heap<JSObject*>& EntrySlotMustExist(size_t i) {
      MOZ_ASSERT(i < kProtoAndIfaceCacheCount);
      size_t pageIndex = i / kPageSize;
      size_t leafIndex = i % kPageSize;
      Page* p = mPages[pageIndex];
      MOZ_ASSERT(p);
      return (*p)[leafIndex];
    }

    void Trace(JSTracer* trc) {
      for (size_t i = 0; i < ArrayLength(mPages); ++i) {
        Page* p = mPages[i];
        if (p) {
          for (size_t j = 0; j < ArrayLength(*p); ++j) {
            JS::TraceEdge(trc, &(*p)[j], "protoAndIfaceCache[i]");
          }
        }
      }
    }

    size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) {
      size_t n = aMallocSizeOf(this);
      for (size_t i = 0; i < ArrayLength(mPages); ++i) {
        n += aMallocSizeOf(mPages[i]);
      }
      return n;
    }

  private:
    static const size_t kPageSize = 16;
    typedef Array<JS::Heap<JSObject*>, kPageSize> Page;
    static const size_t kNPages = kProtoAndIfaceCacheCount / kPageSize +
      size_t(bool(kProtoAndIfaceCacheCount % kPageSize));
    Array<Page*, kNPages> mPages;
  };

public:
  enum Kind {
    WindowLike,
    NonWindowLike
  };

  explicit ProtoAndIfaceCache(Kind aKind) : mKind(aKind) {
    MOZ_COUNT_CTOR(ProtoAndIfaceCache);
    if (aKind == WindowLike) {
      mArrayCache = new ArrayCache();
    } else {
      mPageTableCache = new PageTableCache();
    }
  }

  ~ProtoAndIfaceCache() {
    if (mKind == WindowLike) {
      delete mArrayCache;
    } else {
      delete mPageTableCache;
    }
    MOZ_COUNT_DTOR(ProtoAndIfaceCache);
  }

#define FORWARD_OPERATION(opName, args)              \
  do {                                               \
    if (mKind == WindowLike) {                       \
      return mArrayCache->opName args;               \
    } else {                                         \
      return mPageTableCache->opName args;           \
    }                                                \
  } while(0)

  // Return the JSObject stored in slot i, if that slot exists.  If
  // the slot does not exist, return null.
  JSObject* EntrySlotIfExists(size_t i) {
    FORWARD_OPERATION(EntrySlotIfExists, (i));
  }

  // Return a reference to slot i, creating it if necessary.  There
  // may not be an object in the returned slot.
  JS::Heap<JSObject*>& EntrySlotOrCreate(size_t i) {
    FORWARD_OPERATION(EntrySlotOrCreate, (i));
  }

  // Return a reference to slot i, which is guaranteed to already
  // exist.  There may not be an object in the slot, if prototype and
  // constructor initialization for one of our bindings failed.
  JS::Heap<JSObject*>& EntrySlotMustExist(size_t i) {
    FORWARD_OPERATION(EntrySlotMustExist, (i));
  }

  void Trace(JSTracer *aTracer) {
    FORWARD_OPERATION(Trace, (aTracer));
  }

  size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) {
    size_t n = aMallocSizeOf(this);
    n += (mKind == WindowLike
          ? mArrayCache->SizeOfIncludingThis(aMallocSizeOf)
          : mPageTableCache->SizeOfIncludingThis(aMallocSizeOf));
    return n;
  }
#undef FORWARD_OPERATION

private:
  union {
    ArrayCache *mArrayCache;
    PageTableCache *mPageTableCache;
  };
  Kind mKind;
};

inline void
AllocateProtoAndIfaceCache(JSObject* obj, ProtoAndIfaceCache::Kind aKind)
{
  MOZ_ASSERT(js::GetObjectClass(obj)->flags & JSCLASS_DOM_GLOBAL);
  MOZ_ASSERT(js::GetReservedSlot(obj, DOM_PROTOTYPE_SLOT).isUndefined());

  ProtoAndIfaceCache* protoAndIfaceCache = new ProtoAndIfaceCache(aKind);

  js::SetReservedSlot(obj, DOM_PROTOTYPE_SLOT,
                      JS::PrivateValue(protoAndIfaceCache));
}

#ifdef DEBUG
struct VerifyTraceProtoAndIfaceCacheCalledTracer : public JS::CallbackTracer
{
  bool ok;

  explicit VerifyTraceProtoAndIfaceCacheCalledTracer(JSContext* cx)
    : JS::CallbackTracer(cx), ok(false)
  {}

  void onChild(const JS::GCCellPtr&) override {
    // We don't do anything here, we only want to verify that
    // TraceProtoAndIfaceCache was called.
  }

  TracerKind getTracerKind() const override { return TracerKind::VerifyTraceProtoAndIface; }
};
#endif

inline void
TraceProtoAndIfaceCache(JSTracer* trc, JSObject* obj)
{
  MOZ_ASSERT(js::GetObjectClass(obj)->flags & JSCLASS_DOM_GLOBAL);

#ifdef DEBUG
  if (trc->isCallbackTracer() &&
      (trc->asCallbackTracer()->getTracerKind() ==
       JS::CallbackTracer::TracerKind::VerifyTraceProtoAndIface)) {
    // We don't do anything here, we only want to verify that
    // TraceProtoAndIfaceCache was called.
    static_cast<VerifyTraceProtoAndIfaceCacheCalledTracer*>(trc)->ok = true;
    return;
  }
#endif

  if (!DOMGlobalHasProtoAndIFaceCache(obj))
    return;
  ProtoAndIfaceCache* protoAndIfaceCache = GetProtoAndIfaceCache(obj);
  protoAndIfaceCache->Trace(trc);
}

inline void
DestroyProtoAndIfaceCache(JSObject* obj)
{
  MOZ_ASSERT(js::GetObjectClass(obj)->flags & JSCLASS_DOM_GLOBAL);

  if (!DOMGlobalHasProtoAndIFaceCache(obj)) {
    return;
  }

  ProtoAndIfaceCache* protoAndIfaceCache = GetProtoAndIfaceCache(obj);

  delete protoAndIfaceCache;
}

/**
 * Add constants to an object.
 */
bool
DefineConstants(JSContext* cx, JS::Handle<JSObject*> obj,
                const ConstantSpec* cs);

struct JSNativeHolder
{
  JSNative mNative;
  const NativePropertyHooks* mPropertyHooks;
};

struct NamedConstructor
{
  const char* mName;
  const JSNativeHolder mHolder;
  unsigned mNargs;
};

/*
 * Create a DOM interface object (if constructorClass is non-null) and/or a
 * DOM interface prototype object (if protoClass is non-null).
 *
 * global is used as the parent of the interface object and the interface
 *        prototype object
 * protoProto is the prototype to use for the interface prototype object.
 * interfaceProto is the prototype to use for the interface object.  This can be
 *                null if both constructorClass and constructor are null (as in,
 *                if we're not creating an interface object at all).
 * protoClass is the JSClass to use for the interface prototype object.
 *            This is null if we should not create an interface prototype
 *            object.
 * protoCache a pointer to a JSObject pointer where we should cache the
 *            interface prototype object. This must be null if protoClass is and
 *            vice versa.
 * constructorClass is the JSClass to use for the interface object.
 *                  This is null if we should not create an interface object or
 *                  if it should be a function object.
 * constructor holds the JSNative to back the interface object which should be a
 *             Function, unless constructorClass is non-null in which case it is
 *             ignored. If this is null and constructorClass is also null then
 *             we should not create an interface object at all.
 * ctorNargs is the length of the constructor function; 0 if no constructor
 * constructorCache a pointer to a JSObject pointer where we should cache the
 *                  interface object. This must be null if both constructorClass
 *                  and constructor are null, and non-null otherwise.
 * properties contains the methods, attributes and constants to be defined on
 *            objects in any compartment.
 * chromeProperties contains the methods, attributes and constants to be defined
 *                  on objects in chrome compartments. This must be null if the
 *                  interface doesn't have any ChromeOnly properties or if the
 *                  object is being created in non-chrome compartment.
 * defineOnGlobal controls whether properties should be defined on the given
 *                global for the interface object (if any) and named
 *                constructors (if any) for this interface.  This can be
 *                false in situations where we want the properties to only
 *                appear on privileged Xrays but not on the unprivileged
 *                underlying global.
 * unscopableNames if not null it points to a null-terminated list of const
 *                 char* names of the unscopable properties for this interface.
 * isGlobal if true, we're creating interface objects for a [Global] or
 *        [PrimaryGlobal] interface, and hence shouldn't define properties on
 *        the prototype object.
 *
 * At least one of protoClass, constructorClass or constructor should be
 * non-null. If constructorClass or constructor are non-null, the resulting
 * interface object will be defined on the given global with property name
 * |name|, which must also be non-null.
 */
void
CreateInterfaceObjects(JSContext* cx, JS::Handle<JSObject*> global,
                       JS::Handle<JSObject*> protoProto,
                       const js::Class* protoClass, JS::Heap<JSObject*>* protoCache,
                       JS::Handle<JSObject*> interfaceProto,
                       const js::Class* constructorClass,
                       unsigned ctorNargs, const NamedConstructor* namedConstructors,
                       JS::Heap<JSObject*>* constructorCache,
                       const NativeProperties* regularProperties,
                       const NativeProperties* chromeOnlyProperties,
                       const char* name, bool defineOnGlobal,
                       const char* const* unscopableNames,
                       bool isGlobal);

/**
 * Define the properties (regular and chrome-only) on obj.
 *
 * obj the object to instal the properties on. This should be the interface
 *     prototype object for regular interfaces and the instance object for
 *     interfaces marked with Global.
 * properties contains the methods, attributes and constants to be defined on
 *            objects in any compartment.
 * chromeProperties contains the methods, attributes and constants to be defined
 *                  on objects in chrome compartments. This must be null if the
 *                  interface doesn't have any ChromeOnly properties or if the
 *                  object is being created in non-chrome compartment.
 */
bool
DefineProperties(JSContext* cx, JS::Handle<JSObject*> obj,
                 const NativeProperties* properties,
                 const NativeProperties* chromeOnlyProperties);

/*
 * Define the unforgeable methods on an object.
 */
bool
DefineUnforgeableMethods(JSContext* cx, JS::Handle<JSObject*> obj,
                         const Prefable<const JSFunctionSpec>* props);

/*
 * Define the unforgeable attributes on an object.
 */
bool
DefineUnforgeableAttributes(JSContext* cx, JS::Handle<JSObject*> obj,
                            const Prefable<const JSPropertySpec>* props);

#define HAS_MEMBER_TYPEDEFS                                               \
private:                                                                  \
  typedef char yes[1];                                                    \
  typedef char no[2]

#ifdef _MSC_VER
#define HAS_MEMBER_CHECK(_name)                                           \
  template<typename V> static yes& Check##_name(char (*)[(&V::_name == 0) + 1])
#else
#define HAS_MEMBER_CHECK(_name)                                           \
  template<typename V> static yes& Check##_name(char (*)[sizeof(&V::_name) + 1])
#endif

#define HAS_MEMBER(_memberName, _valueName)                               \
private:                                                                  \
  HAS_MEMBER_CHECK(_memberName);                                          \
  template<typename V> static no& Check##_memberName(...);                \
                                                                          \
public:                                                                   \
  static bool const _valueName =                                          \
    sizeof(Check##_memberName<T>(nullptr)) == sizeof(yes)

template<class T>
struct NativeHasMember
{
  HAS_MEMBER_TYPEDEFS;

  HAS_MEMBER(GetParentObject, GetParentObject);
  HAS_MEMBER(WrapObject, WrapObject);
};

template<class T>
struct IsSmartPtr
{
  HAS_MEMBER_TYPEDEFS;

  HAS_MEMBER(get, value);
};

template<class T>
struct IsRefcounted
{
  HAS_MEMBER_TYPEDEFS;

  HAS_MEMBER(AddRef, HasAddref);
  HAS_MEMBER(Release, HasRelease);

public:
  static bool const value = HasAddref && HasRelease;

private:
  // This struct only works if T is fully declared (not just forward declared).
  // The IsBaseOf check will ensure that, we don't really need it for any other
  // reason (the static assert will of course always be true).
  static_assert(!IsBaseOf<nsISupports, T>::value || IsRefcounted::value,
                "Classes derived from nsISupports are refcounted!");

};

#undef HAS_MEMBER
#undef HAS_MEMBER_CHECK
#undef HAS_MEMBER_TYPEDEFS

#ifdef DEBUG
template <class T, bool isISupports=IsBaseOf<nsISupports, T>::value>
struct
CheckWrapperCacheCast
{
  static bool Check()
  {
    return reinterpret_cast<uintptr_t>(
      static_cast<nsWrapperCache*>(
        reinterpret_cast<T*>(1))) == 1;
  }
};
template <class T>
struct
CheckWrapperCacheCast<T, true>
{
  static bool Check()
  {
    return true;
  }
};
#endif

MOZ_ALWAYS_INLINE bool
CouldBeDOMBinding(void*)
{
  return true;
}

MOZ_ALWAYS_INLINE bool
CouldBeDOMBinding(nsWrapperCache* aCache)
{
  return aCache->IsDOMBinding();
}

inline bool
TryToOuterize(JS::MutableHandle<JS::Value> rval)
{
  if (js::IsWindow(&rval.toObject())) {
    JSObject* obj = js::ToWindowProxyIfWindow(&rval.toObject());
    MOZ_ASSERT(obj);
    rval.set(JS::ObjectValue(*obj));
  }

  return true;
}

// Make sure to wrap the given string value into the right compartment, as
// needed.
MOZ_ALWAYS_INLINE
bool
MaybeWrapStringValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(rval.isString());
  JSString* str = rval.toString();
  if (JS::GetStringZone(str) != js::GetContextZone(cx)) {
    return JS_WrapValue(cx, rval);
  }
  return true;
}

// Make sure to wrap the given object value into the right compartment as
// needed.  This will work correctly, but possibly slowly, on all objects.
MOZ_ALWAYS_INLINE
bool
MaybeWrapObjectValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(rval.isObject());

  // Cross-compartment always requires wrapping.
  JSObject* obj = &rval.toObject();
  if (js::GetObjectCompartment(obj) != js::GetContextCompartment(cx)) {
    return JS_WrapValue(cx, rval);
  }

  // We're same-compartment, but even then we might need to wrap
  // objects specially.  Check for that.
  if (IsDOMObject(obj)) {
    return TryToOuterize(rval);
  }

  // It's not a WebIDL object, so it's OK to just leave it as-is: only WebIDL
  // objects (specifically only windows) require outerization.
  return true;
}

// Like MaybeWrapObjectValue, but also allows null
MOZ_ALWAYS_INLINE
bool
MaybeWrapObjectOrNullValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(rval.isObjectOrNull());
  if (rval.isNull()) {
    return true;
  }
  return MaybeWrapObjectValue(cx, rval);
}

// Wrapping for objects that are known to not be DOM or XPConnect objects
MOZ_ALWAYS_INLINE
bool
MaybeWrapNonDOMObjectValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(rval.isObject());
  MOZ_ASSERT(!GetDOMClass(&rval.toObject()));
  MOZ_ASSERT(!(js::GetObjectClass(&rval.toObject())->flags &
               JSCLASS_PRIVATE_IS_NSISUPPORTS));

  JSObject* obj = &rval.toObject();
  if (js::GetObjectCompartment(obj) == js::GetContextCompartment(cx)) {
    return true;
  }
  return JS_WrapValue(cx, rval);
}

// Like MaybeWrapNonDOMObjectValue but allows null
MOZ_ALWAYS_INLINE
bool
MaybeWrapNonDOMObjectOrNullValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(rval.isObjectOrNull());
  if (rval.isNull()) {
    return true;
  }
  return MaybeWrapNonDOMObjectValue(cx, rval);
}

// If rval is a gcthing and is not in the compartment of cx, wrap rval
// into the compartment of cx (typically by replacing it with an Xray or
// cross-compartment wrapper around the original object).
MOZ_ALWAYS_INLINE bool
MaybeWrapValue(JSContext* cx, JS::MutableHandle<JS::Value> rval)
{
  if (rval.isString()) {
    return MaybeWrapStringValue(cx, rval);
  }

  if (!rval.isObject()) {
    return true;
  }

  return MaybeWrapObjectValue(cx, rval);
}

namespace binding_detail {
enum GetOrCreateReflectorWrapBehavior {
  eWrapIntoContextCompartment,
  eDontWrapIntoContextCompartment
};

template <class T>
struct TypeNeedsOuterization
{
  // We only need to outerize Window objects, so anything inheriting from
  // nsGlobalWindow (which inherits from EventTarget itself).
  static const bool value =
    IsBaseOf<nsGlobalWindow, T>::value || IsSame<EventTarget, T>::value;
};

#ifdef DEBUG
template<typename T, bool isISupports=IsBaseOf<nsISupports, T>::value>
struct CheckWrapperCacheTracing
{
  static inline void Check(T* aObject)
  {
  }
};

template<typename T>
struct CheckWrapperCacheTracing<T, true>
{
  static void Check(T* aObject)
  {
    // Rooting analysis thinks QueryInterface may GC, but we're dealing with
    // a subset of QueryInterface, C++ only types here.
    JS::AutoSuppressGCAnalysis nogc;

    nsWrapperCache* wrapperCacheFromQI = nullptr;
    aObject->QueryInterface(NS_GET_IID(nsWrapperCache),
                            reinterpret_cast<void**>(&wrapperCacheFromQI));

    MOZ_ASSERT(wrapperCacheFromQI,
               "Missing nsWrapperCache from QueryInterface implementation?");

    if (!wrapperCacheFromQI->GetWrapperPreserveColor()) {
      // Can't assert that we trace the wrapper, since we don't have any
      // wrapper to trace.
      return;
    }

    nsISupports* ccISupports = nullptr;
    aObject->QueryInterface(NS_GET_IID(nsCycleCollectionISupports),
                            reinterpret_cast<void**>(&ccISupports));
    MOZ_ASSERT(ccISupports,
               "nsWrapperCache object which isn't cycle collectable?");

    nsXPCOMCycleCollectionParticipant* participant = nullptr;
    CallQueryInterface(ccISupports, &participant);
    MOZ_ASSERT(participant, "Can't QI to CycleCollectionParticipant?");

    bool wasPreservingWrapper = wrapperCacheFromQI->PreservingWrapper();
    wrapperCacheFromQI->SetPreservingWrapper(true);
    wrapperCacheFromQI->CheckCCWrapperTraversal(ccISupports, participant);
    wrapperCacheFromQI->SetPreservingWrapper(wasPreservingWrapper);
  }
};

void
AssertReflectorHasGivenProto(JSContext* aCx, JSObject* aReflector,
                             JS::Handle<JSObject*> aGivenProto);
#endif // DEBUG

template <class T, GetOrCreateReflectorWrapBehavior wrapBehavior>
MOZ_ALWAYS_INLINE bool
DoGetOrCreateDOMReflector(JSContext* cx, T* value,
                          JS::Handle<JSObject*> givenProto,
                          JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(value);
  // We can get rid of this when we remove support for hasXPConnectImpls.
  bool couldBeDOMBinding = CouldBeDOMBinding(value);
  JSObject* obj = value->GetWrapper();
  if (obj) {
#ifdef DEBUG
    AssertReflectorHasGivenProto(cx, obj, givenProto);
    // Have to reget obj because AssertReflectorHasGivenProto can
    // trigger gc so the pointer may now be invalid.
    obj = value->GetWrapper();
#endif
  } else {
    // Inline this here while we have non-dom objects in wrapper caches.
    if (!couldBeDOMBinding) {
      return false;
    }

    obj = value->WrapObject(cx, givenProto);
    if (!obj) {
      // At this point, obj is null, so just return false.
      // Callers seem to be testing JS_IsExceptionPending(cx) to
      // figure out whether WrapObject() threw.
      return false;
    }

#ifdef DEBUG
    if (IsBaseOf<nsWrapperCache, T>::value) {
      CheckWrapperCacheTracing<T>::Check(value);
    }
#endif
  }

#ifdef DEBUG
  const DOMJSClass* clasp = GetDOMClass(obj);
  // clasp can be null if the cache contained a non-DOM object.
  if (clasp) {
    // Some sanity asserts about our object.  Specifically:
    // 1)  If our class claims we're nsISupports, we better be nsISupports
    //     XXXbz ideally, we could assert that reinterpret_cast to nsISupports
    //     does the right thing, but I don't see a way to do it.  :(
    // 2)  If our class doesn't claim we're nsISupports we better be
    //     reinterpret_castable to nsWrapperCache.
    MOZ_ASSERT(clasp, "What happened here?");
    MOZ_ASSERT_IF(clasp->mDOMObjectIsISupports, (IsBaseOf<nsISupports, T>::value));
    MOZ_ASSERT(CheckWrapperCacheCast<T>::Check());
  }
#endif

  rval.set(JS::ObjectValue(*obj));

  bool sameCompartment =
    js::GetObjectCompartment(obj) == js::GetContextCompartment(cx);
  if (sameCompartment && couldBeDOMBinding) {
    return TypeNeedsOuterization<T>::value ? TryToOuterize(rval) : true;
  }

  if (wrapBehavior == eDontWrapIntoContextCompartment) {
    if (TypeNeedsOuterization<T>::value) {
      JSAutoCompartment ac(cx, obj);
      return TryToOuterize(rval);
    }

    return true;
  }

  return JS_WrapValue(cx, rval);
}

} // namespace binding_detail

// Create a JSObject wrapping "value", if there isn't one already, and store it
// in rval.  "value" must be a concrete class that implements a
// GetWrapperPreserveColor() which can return its existing wrapper, if any, and
// a WrapObject() which will try to create a wrapper. Typically, this is done by
// having "value" inherit from nsWrapperCache.
//
// The value stored in rval will be ready to be exposed to whatever JS
// is running on cx right now.  In particular, it will be in the
// compartment of cx, and outerized as needed.
template <class T>
MOZ_ALWAYS_INLINE bool
GetOrCreateDOMReflector(JSContext* cx, T* value,
                        JS::MutableHandle<JS::Value> rval,
                        JS::Handle<JSObject*> givenProto = nullptr)
{
  using namespace binding_detail;
  return DoGetOrCreateDOMReflector<T, eWrapIntoContextCompartment>(cx, value,
                                                                   givenProto,
                                                                   rval);
}

// Like GetOrCreateDOMReflector but doesn't wrap into the context compartment,
// and hence does not actually require cx to be in a compartment.
template <class T>
MOZ_ALWAYS_INLINE bool
GetOrCreateDOMReflectorNoWrap(JSContext* cx, T* value,
                              JS::MutableHandle<JS::Value> rval)
{
  using namespace binding_detail;
  return DoGetOrCreateDOMReflector<T, eDontWrapIntoContextCompartment>(cx,
                                                                       value,
                                                                       nullptr,
                                                                       rval);
}

// Create a JSObject wrapping "value", for cases when "value" is a
// non-wrapper-cached object using WebIDL bindings.  "value" must implement a
// WrapObject() method taking a JSContext and a scope.
template <class T>
inline bool
WrapNewBindingNonWrapperCachedObject(JSContext* cx,
                                     JS::Handle<JSObject*> scopeArg,
                                     T* value,
                                     JS::MutableHandle<JS::Value> rval,
                                     JS::Handle<JSObject*> givenProto = nullptr)
{
  static_assert(IsRefcounted<T>::value, "Don't pass owned classes in here.");
  MOZ_ASSERT(value);
  // We try to wrap in the compartment of the underlying object of "scope"
  JS::Rooted<JSObject*> obj(cx);
  {
    // scope for the JSAutoCompartment so that we restore the compartment
    // before we call JS_WrapValue.
    Maybe<JSAutoCompartment> ac;
    // Maybe<Handle> doesn't so much work, and in any case, adding
    // more Maybe (one for a Rooted and one for a Handle) adds more
    // code (and branches!) than just adding a single rooted.
    JS::Rooted<JSObject*> scope(cx, scopeArg);
    JS::Rooted<JSObject*> proto(cx, givenProto);
    if (js::IsWrapper(scope)) {
      scope = js::CheckedUnwrap(scope, /* stopAtWindowProxy = */ false);
      if (!scope)
        return false;
      ac.emplace(cx, scope);
      if (!JS_WrapObject(cx, &proto)) {
        return false;
      }
    }

    MOZ_ASSERT(js::IsObjectInContextCompartment(scope, cx));
    if (!value->WrapObject(cx, proto, &obj)) {
      return false;
    }
  }

  // We can end up here in all sorts of compartments, per above.  Make
  // sure to JS_WrapValue!
  rval.set(JS::ObjectValue(*obj));
  return MaybeWrapObjectValue(cx, rval);
}

// Create a JSObject wrapping "value", for cases when "value" is a
// non-wrapper-cached owned object using WebIDL bindings.  "value" must implement a
// WrapObject() method taking a JSContext, a scope, and a boolean outparam that
// is true if the JSObject took ownership
template <class T>
inline bool
WrapNewBindingNonWrapperCachedObject(JSContext* cx,
                                     JS::Handle<JSObject*> scopeArg,
                                     nsAutoPtr<T>& value,
                                     JS::MutableHandle<JS::Value> rval,
                                     JS::Handle<JSObject*> givenProto = nullptr)
{
  static_assert(!IsRefcounted<T>::value, "Only pass owned classes in here.");
  // We do a runtime check on value, because otherwise we might in
  // fact end up wrapping a null and invoking methods on it later.
  if (!value) {
    NS_RUNTIMEABORT("Don't try to wrap null objects");
  }
  // We try to wrap in the compartment of the underlying object of "scope"
  JS::Rooted<JSObject*> obj(cx);
  {
    // scope for the JSAutoCompartment so that we restore the compartment
    // before we call JS_WrapValue.
    Maybe<JSAutoCompartment> ac;
    // Maybe<Handle> doesn't so much work, and in any case, adding
    // more Maybe (one for a Rooted and one for a Handle) adds more
    // code (and branches!) than just adding a single rooted.
    JS::Rooted<JSObject*> scope(cx, scopeArg);
    JS::Rooted<JSObject*> proto(cx, givenProto);
    if (js::IsWrapper(scope)) {
      scope = js::CheckedUnwrap(scope, /* stopAtWindowProxy = */ false);
      if (!scope)
        return false;
      ac.emplace(cx, scope);
      if (!JS_WrapObject(cx, &proto)) {
        return false;
      }
    }

    MOZ_ASSERT(js::IsObjectInContextCompartment(scope, cx));
    if (!value->WrapObject(cx, proto, &obj)) {
      return false;
    }

    value.forget();
  }

  // We can end up here in all sorts of compartments, per above.  Make
  // sure to JS_WrapValue!
  rval.set(JS::ObjectValue(*obj));
  return MaybeWrapObjectValue(cx, rval);
}

// Helper for smart pointers (nsRefPtr/nsCOMPtr).
template <template <typename> class SmartPtr, typename T,
          typename U=typename EnableIf<IsRefcounted<T>::value, T>::Type,
          typename V=typename EnableIf<IsSmartPtr<SmartPtr<T>>::value, T>::Type>
inline bool
WrapNewBindingNonWrapperCachedObject(JSContext* cx, JS::Handle<JSObject*> scope,
                                     const SmartPtr<T>& value,
                                     JS::MutableHandle<JS::Value> rval,
                                     JS::Handle<JSObject*> givenProto = nullptr)
{
  return WrapNewBindingNonWrapperCachedObject(cx, scope, value.get(), rval,
                                              givenProto);
}

// Helper for object references (as opposed to pointers).
template <typename T,
          typename U=typename EnableIf<!IsSmartPtr<T>::value, T>::Type>
inline bool
WrapNewBindingNonWrapperCachedObject(JSContext* cx, JS::Handle<JSObject*> scope,
                                     T& value,
                                     JS::MutableHandle<JS::Value> rval,
                                     JS::Handle<JSObject*> givenProto = nullptr)
{
  return WrapNewBindingNonWrapperCachedObject(cx, scope, &value, rval,
                                              givenProto);
}

// Only set allowNativeWrapper to false if you really know you need it, if in
// doubt use true. Setting it to false disables security wrappers.
bool
NativeInterface2JSObjectAndThrowIfFailed(JSContext* aCx,
                                         JS::Handle<JSObject*> aScope,
                                         JS::MutableHandle<JS::Value> aRetval,
                                         xpcObjectHelper& aHelper,
                                         const nsIID* aIID,
                                         bool aAllowNativeWrapper);

/**
 * A method to handle new-binding wrap failure, by possibly falling back to
 * wrapping as a non-new-binding object.
 */
template <class T>
MOZ_ALWAYS_INLINE bool
HandleNewBindingWrappingFailure(JSContext* cx, JS::Handle<JSObject*> scope,
                                T* value, JS::MutableHandle<JS::Value> rval)
{
  if (JS_IsExceptionPending(cx)) {
    return false;
  }

  qsObjectHelper helper(value, GetWrapperCache(value));
  return NativeInterface2JSObjectAndThrowIfFailed(cx, scope, rval,
                                                  helper, nullptr, true);
}

// Helper for calling HandleNewBindingWrappingFailure with smart pointers
// (nsAutoPtr/nsRefPtr/nsCOMPtr) or references.

template <class T, bool isSmartPtr=IsSmartPtr<T>::value>
struct HandleNewBindingWrappingFailureHelper
{
  static inline bool Wrap(JSContext* cx, JS::Handle<JSObject*> scope,
                          const T& value, JS::MutableHandle<JS::Value> rval)
  {
    return HandleNewBindingWrappingFailure(cx, scope, value.get(), rval);
  }
};

template <class T>
struct HandleNewBindingWrappingFailureHelper<T, false>
{
  static inline bool Wrap(JSContext* cx, JS::Handle<JSObject*> scope, T& value,
                          JS::MutableHandle<JS::Value> rval)
  {
    return HandleNewBindingWrappingFailure(cx, scope, &value, rval);
  }
};

template<class T>
inline bool
HandleNewBindingWrappingFailure(JSContext* cx, JS::Handle<JSObject*> scope,
                                T& value, JS::MutableHandle<JS::Value> rval)
{
  return HandleNewBindingWrappingFailureHelper<T>::Wrap(cx, scope, value, rval);
}

template<bool Fatal>
inline bool
EnumValueNotFound(JSContext* cx, JS::HandleString str, const char* type,
                  const char* sourceDescription);

template<>
inline bool
EnumValueNotFound<false>(JSContext* cx, JS::HandleString str, const char* type,
                         const char* sourceDescription)
{
  // TODO: Log a warning to the console.
  return true;
}

template<>
inline bool
EnumValueNotFound<true>(JSContext* cx, JS::HandleString str, const char* type,
                        const char* sourceDescription)
{
  JSAutoByteString deflated;
  if (!deflated.encodeUtf8(cx, str)) {
    return false;
  }
  return ThrowErrorMessage(cx, MSG_INVALID_ENUM_VALUE, sourceDescription,
                           deflated.ptr(), type);
}

template<typename CharT>
inline int
FindEnumStringIndexImpl(const CharT* chars, size_t length, const EnumEntry* values)
{
  int i = 0;
  for (const EnumEntry* value = values; value->value; ++value, ++i) {
    if (length != value->length) {
      continue;
    }

    bool equal = true;
    const char* val = value->value;
    for (size_t j = 0; j != length; ++j) {
      if (unsigned(val[j]) != unsigned(chars[j])) {
        equal = false;
        break;
      }
    }

    if (equal) {
      return i;
    }
  }

  return -1;
}

template<bool InvalidValueFatal>
inline bool
FindEnumStringIndex(JSContext* cx, JS::Handle<JS::Value> v, const EnumEntry* values,
                    const char* type, const char* sourceDescription, int* index)
{
  // JS_StringEqualsAscii is slow as molasses, so don't use it here.
  JS::RootedString str(cx, JS::ToString(cx, v));
  if (!str) {
    return false;
  }

  {
    size_t length;
    JS::AutoCheckCannotGC nogc;
    if (js::StringHasLatin1Chars(str)) {
      const JS::Latin1Char* chars = JS_GetLatin1StringCharsAndLength(cx, nogc, str,
                                                                     &length);
      if (!chars) {
        return false;
      }
      *index = FindEnumStringIndexImpl(chars, length, values);
    } else {
      const char16_t* chars = JS_GetTwoByteStringCharsAndLength(cx, nogc, str,
                                                                &length);
      if (!chars) {
        return false;
      }
      *index = FindEnumStringIndexImpl(chars, length, values);
    }
    if (*index >= 0) {
      return true;
    }
  }

  return EnumValueNotFound<InvalidValueFatal>(cx, str, type, sourceDescription);
}

inline nsWrapperCache*
GetWrapperCache(const ParentObject& aParentObject)
{
  return aParentObject.mWrapperCache;
}

template<class T>
inline T*
GetParentPointer(T* aObject)
{
  return aObject;
}

inline nsISupports*
GetParentPointer(const ParentObject& aObject)
{
  return aObject.mObject;
}

template <typename T>
inline bool
GetUseXBLScope(T* aParentObject)
{
  return false;
}

inline bool
GetUseXBLScope(const ParentObject& aParentObject)
{
  return aParentObject.mUseXBLScope;
}

template<class T>
inline void
ClearWrapper(T* p, nsWrapperCache* cache)
{
  cache->ClearWrapper();
}

template<class T>
inline void
ClearWrapper(T* p, void*)
{
  nsWrapperCache* cache;
  CallQueryInterface(p, &cache);
  ClearWrapper(p, cache);
}

template<class T>
inline void
UpdateWrapper(T* p, nsWrapperCache* cache, JSObject* obj, const JSObject* old)
{
  JS::AutoAssertGCCallback inCallback(obj);
  cache->UpdateWrapper(obj, old);
}

template<class T>
inline void
UpdateWrapper(T* p, void*, JSObject* obj, const JSObject* old)
{
  JS::AutoAssertGCCallback inCallback(obj);
  nsWrapperCache* cache;
  CallQueryInterface(p, &cache);
  UpdateWrapper(p, cache, obj, old);
}

// Attempt to preserve the wrapper, if any, for a Paris DOM bindings object.
// Return true if we successfully preserved the wrapper, or there is no wrapper
// to preserve. In the latter case we don't need to preserve the wrapper, because
// the object can only be obtained by JS once, or they cannot be meaningfully
// owned from the native side.
//
// This operation will return false only for non-nsISupports cycle-collected
// objects, because we cannot determine if they are wrappercached or not.
bool
TryPreserveWrapper(JSObject* obj);

// Can only be called with a DOM JSClass.
bool
InstanceClassHasProtoAtDepth(const js::Class* clasp,
                             uint32_t protoID, uint32_t depth);

// Only set allowNativeWrapper to false if you really know you need it, if in
// doubt use true. Setting it to false disables security wrappers.
bool
XPCOMObjectToJsval(JSContext* cx, JS::Handle<JSObject*> scope,
                   xpcObjectHelper& helper, const nsIID* iid,
                   bool allowNativeWrapper, JS::MutableHandle<JS::Value> rval);

// Special-cased wrapping for variants
bool
VariantToJsval(JSContext* aCx, nsIVariant* aVariant,
               JS::MutableHandle<JS::Value> aRetval);

// Wrap an object "p" which is not using WebIDL bindings yet.  This _will_
// actually work on WebIDL binding objects that are wrappercached, but will be
// much slower than GetOrCreateDOMReflector.  "cache" must either be null or be
// the nsWrapperCache for "p".
template<class T>
inline bool
WrapObject(JSContext* cx, T* p, nsWrapperCache* cache, const nsIID* iid,
           JS::MutableHandle<JS::Value> rval)
{
  if (xpc_FastGetCachedWrapper(cx, cache, rval))
    return true;
  qsObjectHelper helper(p, cache);
  JS::Rooted<JSObject*> scope(cx, JS::CurrentGlobalOrNull(cx));
  return XPCOMObjectToJsval(cx, scope, helper, iid, true, rval);
}

// A specialization of the above for nsIVariant, because that needs to
// do something different.
template<>
inline bool
WrapObject<nsIVariant>(JSContext* cx, nsIVariant* p,
                       nsWrapperCache* cache, const nsIID* iid,
                       JS::MutableHandle<JS::Value> rval)
{
  MOZ_ASSERT(iid);
  MOZ_ASSERT(iid->Equals(NS_GET_IID(nsIVariant)));
  return VariantToJsval(cx, p, rval);
}

// Wrap an object "p" which is not using WebIDL bindings yet.  Just like the
// variant that takes an nsWrapperCache above, but will try to auto-derive the
// nsWrapperCache* from "p".
template<class T>
inline bool
WrapObject(JSContext* cx, T* p, const nsIID* iid,
           JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p, GetWrapperCache(p), iid, rval);
}

// Just like the WrapObject above, but without requiring you to pick which
// interface you're wrapping as.  This should only be used for objects that have
// classinfo, for which it doesn't matter what IID is used to wrap.
template<class T>
inline bool
WrapObject(JSContext* cx, T* p, JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p, nullptr, rval);
}

// Helper to make it possible to wrap directly out of an nsCOMPtr
template<class T>
inline bool
WrapObject(JSContext* cx, const nsCOMPtr<T>& p,
           const nsIID* iid, JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p.get(), iid, rval);
}

// Helper to make it possible to wrap directly out of an nsCOMPtr
template<class T>
inline bool
WrapObject(JSContext* cx, const nsCOMPtr<T>& p,
           JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p, nullptr, rval);
}

// Helper to make it possible to wrap directly out of an nsRefPtr
template<class T>
inline bool
WrapObject(JSContext* cx, const RefPtr<T>& p,
           const nsIID* iid, JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p.get(), iid, rval);
}

// Helper to make it possible to wrap directly out of an nsRefPtr
template<class T>
inline bool
WrapObject(JSContext* cx, const RefPtr<T>& p,
           JS::MutableHandle<JS::Value> rval)
{
  return WrapObject(cx, p, nullptr, rval);
}

// Specialization to make it easy to use WrapObject in codegen.
template<>
inline bool
WrapObject<JSObject>(JSContext* cx, JSObject* p,
                     JS::MutableHandle<JS::Value> rval)
{
  rval.set(JS::ObjectOrNullValue(p));
  return true;
}

inline bool
WrapObject(JSContext* cx, JSObject& p, JS::MutableHandle<JS::Value> rval)
{
  rval.set(JS::ObjectValue(p));
  return true;
}

// Given an object "p" that inherits from nsISupports, wrap it and return the
// result.  Null is returned on wrapping failure.  This is somewhat similar to
// WrapObject() above, but does NOT allow Xrays around the result, since we
// don't want those for our parent object.
template<typename T>
static inline JSObject*
WrapNativeISupports(JSContext* cx, T* p, nsWrapperCache* cache)
{
  qsObjectHelper helper(ToSupports(p), cache);
  JS::Rooted<JSObject*> scope(cx, JS::CurrentGlobalOrNull(cx));
  JS::Rooted<JS::Value> v(cx);
  return XPCOMObjectToJsval(cx, scope, helper, nullptr, false, &v) ?
         v.toObjectOrNull() :
         nullptr;
}


// Fallback for when our parent is not a WebIDL binding object.
template<typename T, bool isISupports=IsBaseOf<nsISupports, T>::value>
struct WrapNativeFallback
{
  static inline JSObject* Wrap(JSContext* cx, T* parent, nsWrapperCache* cache)
  {
    return nullptr;
  }
};

// Fallback for when our parent is not a WebIDL binding object but _is_ an
// nsISupports object.
template<typename T >
struct WrapNativeFallback<T, true >
{
  static inline JSObject* Wrap(JSContext* cx, T* parent, nsWrapperCache* cache)
  {
    return WrapNativeISupports(cx, parent, cache);
  }
};

// Wrapping of our native parent, for cases when it's a WebIDL object (though
// possibly preffed off).
template<typename T, bool hasWrapObject=NativeHasMember<T>::WrapObject>
struct WrapNativeHelper
{
  static inline JSObject* Wrap(JSContext* cx, T* parent, nsWrapperCache* cache)
  {
    MOZ_ASSERT(cache);

    JSObject* obj;
    if ((obj = cache->GetWrapper())) {
      // GetWrapper always unmarks gray.
      MOZ_ASSERT(!JS::ObjectIsMarkedGray(obj));
      return obj;
    }

    // Inline this here while we have non-dom objects in wrapper caches.
    if (!CouldBeDOMBinding(parent)) {
      // WrapNativeFallback never returns a gray thing.
      obj = WrapNativeFallback<T>::Wrap(cx, parent, cache);
      MOZ_ASSERT_IF(obj, !JS::ObjectIsMarkedGray(obj));
    } else {
      // WrapObject never returns a gray thing.
      obj = parent->WrapObject(cx, nullptr);
      MOZ_ASSERT_IF(obj, !JS::ObjectIsMarkedGray(obj));
    }

    return obj;
  }
};

// Wrapping of our native parent, for cases when it's not a WebIDL object.  In
// this case it must be nsISupports.
template<typename T>
struct WrapNativeHelper<T, false>
{
  static inline JSObject* Wrap(JSContext* cx, T* parent, nsWrapperCache* cache)
  {
    JSObject* obj;
    if (cache && (obj = cache->GetWrapper())) {
#ifdef DEBUG
      JS::Rooted<JSObject*> rootedObj(cx, obj);
      NS_ASSERTION(WrapNativeISupports(cx, parent, cache) == rootedObj,
                   "Unexpected object in nsWrapperCache");
      obj = rootedObj;
#endif
      MOZ_ASSERT(!JS::ObjectIsMarkedGray(obj));
      return obj;
    }

    obj = WrapNativeISupports(cx, parent, cache);
    MOZ_ASSERT_IF(obj, !JS::ObjectIsMarkedGray(obj));
    return obj;
  }
};

// Finding the associated global for an object.
template<typename T>
static inline JSObject*
FindAssociatedGlobal(JSContext* cx, T* p, nsWrapperCache* cache,
                     bool useXBLScope = false)
{
  if (!p) {
    return JS::CurrentGlobalOrNull(cx);
  }

  JSObject* obj = WrapNativeHelper<T>::Wrap(cx, p, cache);
  if (!obj) {
    return nullptr;
  }
  MOZ_ASSERT(!JS::ObjectIsMarkedGray(obj));

  obj = js::GetGlobalForObjectCrossCompartment(obj);

  if (!useXBLScope) {
    return obj;
  }

  // If useXBLScope is true, it means that the canonical reflector for this
  // native object should live in the content XBL scope. Note that we never put
  // anonymous content inside an add-on scope.
  if (xpc::IsInContentXBLScope(obj)) {
    return obj;
  }
  JS::Rooted<JSObject*> rootedObj(cx, obj);
  JSObject* xblScope = xpc::GetXBLScope(cx, rootedObj);
  MOZ_ASSERT_IF(xblScope, JS_IsGlobalObject(xblScope));
  MOZ_ASSERT_IF(xblScope, !JS::ObjectIsMarkedGray(xblScope));
  return xblScope;
}

// Finding of the associated global for an object, when we don't want to
// explicitly pass in things like the nsWrapperCache for it.
template<typename T>
static inline JSObject*
FindAssociatedGlobal(JSContext* cx, const T& p)
{
  return FindAssociatedGlobal(cx, GetParentPointer(p), GetWrapperCache(p), GetUseXBLScope(p));
}

// Specialization for the case of nsIGlobalObject, since in that case
// we can just get the JSObject* directly.
template<>
inline JSObject*
FindAssociatedGlobal(JSContext* cx, nsIGlobalObject* const& p)
{
  if (!p) {
    return JS::CurrentGlobalOrNull(cx);
  }

  JSObject* global = p->GetGlobalJSObject();
  if (!global) {
    return nullptr;
  }

  MOZ_ASSERT(JS_IsGlobalObject(global));
  // This object could be gray if the nsIGlobalObject is the only thing keeping
  // it alive.
  JS::ExposeObjectToActiveJS(global);
  return global;
}

template<typename T,
         bool hasAssociatedGlobal=NativeHasMember<T>::GetParentObject>
struct FindAssociatedGlobalForNative
{
  static JSObject* Get(JSContext* cx, JS::Handle<JSObject*> obj)
  {
    MOZ_ASSERT(js::IsObjectInContextCompartment(obj, cx));
    T* native = UnwrapDOMObject<T>(obj);
    return FindAssociatedGlobal(cx, native->GetParentObject());
  }
};

template<typename T>
struct FindAssociatedGlobalForNative<T, false>
{
  static JSObject* Get(JSContext* cx, JS::Handle<JSObject*> obj)
  {
    MOZ_CRASH();
    return nullptr;
  }
};

// Helper for calling GetOrCreateDOMReflector with smart pointers
// (nsAutoPtr/nsRefPtr/nsCOMPtr) or references.
template <class T, bool isSmartPtr=IsSmartPtr<T>::value>
struct GetOrCreateDOMReflectorHelper
{
  static inline bool GetOrCreate(JSContext* cx, const T& value,
                                 JS::Handle<JSObject*> givenProto,
                                 JS::MutableHandle<JS::Value> rval)
  {
    return GetOrCreateDOMReflector(cx, value.get(), rval, givenProto);
  }
};

template <class T>
struct GetOrCreateDOMReflectorHelper<T, false>
{
  static inline bool GetOrCreate(JSContext* cx, T& value,
                                 JS::Handle<JSObject*> givenProto,
                                 JS::MutableHandle<JS::Value> rval)
  {
    static_assert(IsRefcounted<T>::value, "Don't pass owned classes in here.");
    return GetOrCreateDOMReflector(cx, &value, rval, givenProto);
  }
};

template<class T>
inline bool
GetOrCreateDOMReflector(JSContext* cx, T& value,
                        JS::MutableHandle<JS::Value> rval,
                        JS::Handle<JSObject*> givenProto = nullptr)
{
  return GetOrCreateDOMReflectorHelper<T>::GetOrCreate(cx, value, givenProto,
                                                       rval);
}

// Helper for calling GetOrCreateDOMReflectorNoWrap with smart pointers
// (nsAutoPtr/nsRefPtr/nsCOMPtr) or references.
template <class T, bool isSmartPtr=IsSmartPtr<T>::value>
struct GetOrCreateDOMReflectorNoWrapHelper
{
  static inline bool GetOrCreate(JSContext* cx, const T& value,
                                 JS::MutableHandle<JS::Value> rval)
  {
    return GetOrCreateDOMReflectorNoWrap(cx, value.get(), rval);
  }
};

template <class T>
struct GetOrCreateDOMReflectorNoWrapHelper<T, false>
{
  static inline bool GetOrCreate(JSContext* cx, T& value,
                                 JS::MutableHandle<JS::Value> rval)
  {
    return GetOrCreateDOMReflectorNoWrap(cx, &value, rval);
  }
};

template<class T>
inline bool
GetOrCreateDOMReflectorNoWrap(JSContext* cx, T& value,
                              JS::MutableHandle<JS::Value> rval)
{
  return
    GetOrCreateDOMReflectorNoWrapHelper<T>::GetOrCreate(cx, value, rval);
}

template <class T>
inline JSObject*
GetCallbackFromCallbackObject(T* aObj)
{
  return aObj->Callback();
}

// Helper for getting the callback JSObject* of a smart ptr around a
// CallbackObject or a reference to a CallbackObject or something like
// that.
template <class T, bool isSmartPtr=IsSmartPtr<T>::value>
struct GetCallbackFromCallbackObjectHelper
{
  static inline JSObject* Get(const T& aObj)
  {
    return GetCallbackFromCallbackObject(aObj.get());
  }
};

template <class T>
struct GetCallbackFromCallbackObjectHelper<T, false>
{
  static inline JSObject* Get(T& aObj)
  {
    return GetCallbackFromCallbackObject(&aObj);
  }
};

template<class T>
inline JSObject*
GetCallbackFromCallbackObject(T& aObj)
{
  return GetCallbackFromCallbackObjectHelper<T>::Get(aObj);
}

static inline bool
AtomizeAndPinJSString(JSContext* cx, jsid& id, const char* chars)
{
  if (JSString *str = ::JS_AtomizeAndPinString(cx, chars)) {
    id = INTERNED_STRING_TO_JSID(cx, str);
    return true;
  }
  return false;
}

// Spec needs a name property
template <typename Spec>
static bool
InitIds(JSContext* cx, const Prefable<Spec>* prefableSpecs, jsid* ids)
{
  MOZ_ASSERT(prefableSpecs);
  MOZ_ASSERT(prefableSpecs->specs);
  do {
    // We ignore whether the set of ids is enabled and just intern all the IDs,
    // because this is only done once per application runtime.
    Spec* spec = prefableSpecs->specs;
    do {
      if (!JS::PropertySpecNameToPermanentId(cx, spec->name, ids)) {
        return false;
      }
    } while (++ids, (++spec)->name);

    // We ran out of ids for that pref.  Put a JSID_VOID in on the id
    // corresponding to the list terminator for the pref.
    *ids = JSID_VOID;
    ++ids;
  } while ((++prefableSpecs)->specs);

  return true;
}

bool
QueryInterface(JSContext* cx, unsigned argc, JS::Value* vp);

template <class T>
struct
WantsQueryInterface
{
  static_assert(IsBaseOf<nsISupports, T>::value,
                "QueryInterface can't work without an nsISupports.");
  static bool Enabled(JSContext* aCx, JSObject* aGlobal)
  {
    return NS_IsMainThread() && IsChromeOrXBL(aCx, aGlobal);
  }
};

void
GetInterfaceImpl(JSContext* aCx, nsIInterfaceRequestor* aRequestor,
                 nsWrapperCache* aCache, nsIJSID* aIID,
                 JS::MutableHandle<JS::Value> aRetval, ErrorResult& aError);

template<class T>
void
GetInterface(JSContext* aCx, T* aThis, nsIJSID* aIID,
             JS::MutableHandle<JS::Value> aRetval, ErrorResult& aError)
{
  GetInterfaceImpl(aCx, aThis, aThis, aIID, aRetval, aError);
}

bool
UnforgeableValueOf(JSContext* cx, unsigned argc, JS::Value* vp);

bool
ThrowingConstructor(JSContext* cx, unsigned argc, JS::Value* vp);

bool
ThrowConstructorWithoutNew(JSContext* cx, const char* name);

bool
GetPropertyOnPrototype(JSContext* cx, JS::Handle<JSObject*> proxy,
                       JS::Handle<JS::Value> receiver, JS::Handle<jsid> id,
                       bool* found, JS::MutableHandle<JS::Value> vp);

//
bool
HasPropertyOnPrototype(JSContext* cx, JS::Handle<JSObject*> proxy,
                       JS::Handle<jsid> id, bool* has);


// Append the property names in "names" to "props". If
// shadowPrototypeProperties is false then skip properties that are also
// present on the proto chain of proxy.  If shadowPrototypeProperties is true,
// then the "proxy" argument is ignored.
bool
AppendNamedPropertyIds(JSContext* cx, JS::Handle<JSObject*> proxy,
                       nsTArray<nsString>& names,
                       bool shadowPrototypeProperties, JS::AutoIdVector& props);

namespace binding_detail {

class FastErrorResult :
    public mozilla::binding_danger::TErrorResult<
      mozilla::binding_danger::JustAssertCleanupPolicy>
{
};

} // namespace binding_detail

enum StringificationBehavior {
  eStringify,
  eEmpty,
  eNull
};

template<typename T>
static inline bool
ConvertJSValueToString(JSContext* cx, JS::Handle<JS::Value> v,
                       StringificationBehavior nullBehavior,
                       StringificationBehavior undefinedBehavior,
                       T& result)
{
  JSString *s;
  if (v.isString()) {
    s = v.toString();
  } else {
    StringificationBehavior behavior;
    if (v.isNull()) {
      behavior = nullBehavior;
    } else if (v.isUndefined()) {
      behavior = undefinedBehavior;
    } else {
      behavior = eStringify;
    }

    if (behavior != eStringify) {
      if (behavior == eEmpty) {
        result.Truncate();
      } else {
        result.SetIsVoid(true);
      }
      return true;
    }

    s = JS::ToString(cx, v);
    if (!s) {
      return false;
    }
  }

  return AssignJSString(cx, result, s);
}

void
NormalizeUSVString(JSContext* aCx, nsAString& aString);

void
NormalizeUSVString(JSContext* aCx, binding_detail::FakeString& aString);

template<typename T>
inline bool
ConvertIdToString(JSContext* cx, JS::HandleId id, T& result, bool& isSymbol)
{
  if (MOZ_LIKELY(JSID_IS_STRING(id))) {
    if (!AssignJSString(cx, result, JSID_TO_STRING(id))) {
      return false;
    }
  } else if (JSID_IS_SYMBOL(id)) {
    isSymbol = true;
    return true;
  } else {
    JS::RootedValue nameVal(cx, js::IdToValue(id));
    if (!ConvertJSValueToString(cx, nameVal, eStringify, eStringify, result)) {
      return false;
    }
  }
  isSymbol = false;
  return true;
}

bool
ConvertJSValueToByteString(JSContext* cx, JS::Handle<JS::Value> v,
                           bool nullable, nsACString& result);

template<typename T>
void DoTraceSequence(JSTracer* trc, FallibleTArray<T>& seq);
template<typename T>
void DoTraceSequence(JSTracer* trc, InfallibleTArray<T>& seq);

// Class used to trace sequences, with specializations for various
// sequence types.
template<typename T,
         bool isDictionary=IsBaseOf<DictionaryBase, T>::value,
         bool isTypedArray=IsBaseOf<AllTypedArraysBase, T>::value,
         bool isOwningUnion=IsBaseOf<AllOwningUnionBase, T>::value>
class SequenceTracer
{
  explicit SequenceTracer() = delete; // Should never be instantiated
};

// sequence<object> or sequence<object?>
template<>
class SequenceTracer<JSObject*, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, JSObject** objp, JSObject** end) {
    for (; objp != end; ++objp) {
      JS::UnsafeTraceRoot(trc, objp, "sequence<object>");
    }
  }
};

// sequence<any>
template<>
class SequenceTracer<JS::Value, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, JS::Value* valp, JS::Value* end) {
    for (; valp != end; ++valp) {
      JS::UnsafeTraceRoot(trc, valp, "sequence<any>");
    }
  }
};

// sequence<sequence<T>>
template<typename T>
class SequenceTracer<Sequence<T>, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, Sequence<T>* seqp, Sequence<T>* end) {
    for (; seqp != end; ++seqp) {
      DoTraceSequence(trc, *seqp);
    }
  }
};

// sequence<sequence<T>> as return value
template<typename T>
class SequenceTracer<nsTArray<T>, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, nsTArray<T>* seqp, nsTArray<T>* end) {
    for (; seqp != end; ++seqp) {
      DoTraceSequence(trc, *seqp);
    }
  }
};

// sequence<someDictionary>
template<typename T>
class SequenceTracer<T, true, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, T* dictp, T* end) {
    for (; dictp != end; ++dictp) {
      dictp->TraceDictionary(trc);
    }
  }
};

// sequence<SomeTypedArray>
template<typename T>
class SequenceTracer<T, false, true, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, T* arrayp, T* end) {
    for (; arrayp != end; ++arrayp) {
      arrayp->TraceSelf(trc);
    }
  }
};

// sequence<SomeOwningUnion>
template<typename T>
class SequenceTracer<T, false, false, true>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, T* arrayp, T* end) {
    for (; arrayp != end; ++arrayp) {
      arrayp->TraceUnion(trc);
    }
  }
};

// sequence<T?> with T? being a Nullable<T>
template<typename T>
class SequenceTracer<Nullable<T>, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, Nullable<T>* seqp,
                            Nullable<T>* end) {
    for (; seqp != end; ++seqp) {
      if (!seqp->IsNull()) {
        // Pretend like we actually have a length-one sequence here so
        // we can do template instantiation correctly for T.
        T& val = seqp->Value();
        T* ptr = &val;
        SequenceTracer<T>::TraceSequence(trc, ptr, ptr+1);
      }
    }
  }
};

template<typename T>
static void
TraceMozMapValue(T* aValue, void* aClosure)
{
  JSTracer* trc = static_cast<JSTracer*>(aClosure);
  // Act like it's a one-element sequence to leverage all that infrastructure.
  SequenceTracer<T>::TraceSequence(trc, aValue, aValue + 1);
}

template<typename T>
void TraceMozMap(JSTracer* trc, MozMap<T>& map)
{
  map.EnumerateValues(TraceMozMapValue<T>, trc);
}

// sequence<MozMap>
template<typename T>
class SequenceTracer<MozMap<T>, false, false, false>
{
  explicit SequenceTracer() = delete; // Should never be instantiated

public:
  static void TraceSequence(JSTracer* trc, MozMap<T>* seqp, MozMap<T>* end) {
    for (; seqp != end; ++seqp) {
      seqp->EnumerateValues(TraceMozMapValue<T>, trc);
    }
  }
};

template<typename T>
void DoTraceSequence(JSTracer* trc, FallibleTArray<T>& seq)
{
  SequenceTracer<T>::TraceSequence(trc, seq.Elements(),
                                   seq.Elements() + seq.Length());
}

template<typename T>
void DoTraceSequence(JSTracer* trc, InfallibleTArray<T>& seq)
{
  SequenceTracer<T>::TraceSequence(trc, seq.Elements(),
                                   seq.Elements() + seq.Length());
}

// Rooter class for sequences; this is what we mostly use in the codegen
template<typename T>
class MOZ_RAII SequenceRooter final : private JS::CustomAutoRooter
{
public:
  SequenceRooter(JSContext *aCx, FallibleTArray<T>* aSequence
                 MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : JS::CustomAutoRooter(aCx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT),
      mFallibleArray(aSequence),
      mSequenceType(eFallibleArray)
  {
  }

  SequenceRooter(JSContext *aCx, InfallibleTArray<T>* aSequence
                 MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : JS::CustomAutoRooter(aCx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT),
      mInfallibleArray(aSequence),
      mSequenceType(eInfallibleArray)
  {
  }

  SequenceRooter(JSContext *aCx, Nullable<nsTArray<T> >* aSequence
                 MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : JS::CustomAutoRooter(aCx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT),
      mNullableArray(aSequence),
      mSequenceType(eNullableArray)
  {
  }

 private:
  enum SequenceType {
    eInfallibleArray,
    eFallibleArray,
    eNullableArray
  };

  virtual void trace(JSTracer *trc) override
  {
    if (mSequenceType == eFallibleArray) {
      DoTraceSequence(trc, *mFallibleArray);
    } else if (mSequenceType == eInfallibleArray) {
      DoTraceSequence(trc, *mInfallibleArray);
    } else {
      MOZ_ASSERT(mSequenceType == eNullableArray);
      if (!mNullableArray->IsNull()) {
        DoTraceSequence(trc, mNullableArray->Value());
      }
    }
  }

  union {
    InfallibleTArray<T>* mInfallibleArray;
    FallibleTArray<T>* mFallibleArray;
    Nullable<nsTArray<T> >* mNullableArray;
  };

  SequenceType mSequenceType;
};

// Rooter class for MozMap; this is what we mostly use in the codegen.
template<typename T>
class MOZ_RAII MozMapRooter final : private JS::CustomAutoRooter
{
public:
  MozMapRooter(JSContext *aCx, MozMap<T>* aMozMap
               MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : JS::CustomAutoRooter(aCx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT),
      mMozMap(aMozMap),
      mMozMapType(eMozMap)
  {
  }

  MozMapRooter(JSContext *aCx, Nullable<MozMap<T>>* aMozMap
                 MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : JS::CustomAutoRooter(aCx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT),
      mNullableMozMap(aMozMap),
      mMozMapType(eNullableMozMap)
  {
  }

private:
  enum MozMapType {
    eMozMap,
    eNullableMozMap
  };

  virtual void trace(JSTracer *trc) override
  {
    if (mMozMapType == eMozMap) {
      TraceMozMap(trc, *mMozMap);
    } else {
      MOZ_ASSERT(mMozMapType == eNullableMozMap);
      if (!mNullableMozMap->IsNull()) {
        TraceMozMap(trc, mNullableMozMap->Value());
      }
    }
  }

  union {
    MozMap<T>* mMozMap;
    Nullable<MozMap<T>>* mNullableMozMap;
  };

  MozMapType mMozMapType;
};

template<typename T>
class MOZ_RAII RootedUnion : public T,
                             private JS::CustomAutoRooter
{
public:
  explicit RootedUnion(JSContext* cx MOZ_GUARD_OBJECT_NOTIFIER_PARAM) :
    T(),
    JS::CustomAutoRooter(cx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT)
  {
  }

  virtual void trace(JSTracer *trc) override
  {
    this->TraceUnion(trc);
  }
};

template<typename T>
class MOZ_STACK_CLASS NullableRootedUnion : public Nullable<T>,
                                            private JS::CustomAutoRooter
{
public:
  explicit NullableRootedUnion(JSContext* cx MOZ_GUARD_OBJECT_NOTIFIER_PARAM) :
    Nullable<T>(),
    JS::CustomAutoRooter(cx MOZ_GUARD_OBJECT_NOTIFIER_PARAM_TO_PARENT)
  {
  }

  virtual void trace(JSTracer *trc) override
  {
    if (!this->IsNull()) {
      this->Value().TraceUnion(trc);
    }
  }
};

inline bool
IdEquals(jsid id, const char* string)
{
  return JSID_IS_STRING(id) &&
         JS_FlatStringEqualsAscii(JSID_TO_FLAT_STRING(id), string);
}

inline bool
AddStringToIDVector(JSContext* cx, JS::AutoIdVector& vector, const char* name)
{
  return vector.growBy(1) &&
         AtomizeAndPinJSString(cx, *(vector[vector.length() - 1]).address(), name);
}

// We use one constructor JSNative to represent all DOM interface objects (so
// we can easily detect when we need to wrap them in an Xray wrapper). We store
// the real JSNative in the mNative member of a JSNativeHolder in the
// CONSTRUCTOR_NATIVE_HOLDER_RESERVED_SLOT slot of the JSFunction object for a
// specific interface object. We also store the NativeProperties in the
// JSNativeHolder.
// Note that some interface objects are not yet a JSFunction but a normal
// JSObject with a DOMJSClass, those do not use these slots.

enum {
  CONSTRUCTOR_NATIVE_HOLDER_RESERVED_SLOT = 0
};

bool
Constructor(JSContext* cx, unsigned argc, JS::Value* vp);

// Implementation of the bits that XrayWrapper needs

/**
 * This resolves operations, attributes and constants of the interfaces for obj.
 *
 * wrapper is the Xray JS object.
 * obj is the target object of the Xray, a binding's instance object or a
 *     interface or interface prototype object.
 */
bool
XrayResolveOwnProperty(JSContext* cx, JS::Handle<JSObject*> wrapper,
                       JS::Handle<JSObject*> obj,
                       JS::Handle<jsid> id,
                       JS::MutableHandle<JS::PropertyDescriptor> desc,
                       bool& cacheOnHolder);

/**
 * Define a property on obj through an Xray wrapper.
 *
 * wrapper is the Xray JS object.
 * obj is the target object of the Xray, a binding's instance object or a
 *     interface or interface prototype object.
 * id and desc are the parameters for the property to be defined.
 * result is the out-parameter indicating success (read it only if
 *     this returns true and also sets *defined to true).
 * defined will be set to true if a property was set as a result of this call.
 */
bool
XrayDefineProperty(JSContext* cx, JS::Handle<JSObject*> wrapper,
                   JS::Handle<JSObject*> obj, JS::Handle<jsid> id,
                   JS::Handle<JS::PropertyDescriptor> desc,
                   JS::ObjectOpResult &result,
                   bool *defined);

/**
 * Add to props the property keys of all indexed or named properties of obj and
 * operations, attributes and constants of the interfaces for obj.
 *
 * wrapper is the Xray JS object.
 * obj is the target object of the Xray, a binding's instance object or a
 *     interface or interface prototype object.
 * flags are JSITER_* flags.
 */
bool
XrayOwnPropertyKeys(JSContext* cx, JS::Handle<JSObject*> wrapper,
                    JS::Handle<JSObject*> obj,
                    unsigned flags, JS::AutoIdVector& props);

/**
 * Returns the prototype to use for an Xray for a DOM object, wrapped in cx's
 * compartment. This always returns the prototype that would be used for a DOM
 * object if we ignore any changes that might have been done to the prototype
 * chain by JS, the XBL code or plugins.
 *
 * cx should be in the Xray's compartment.
 * obj is the target object of the Xray, a binding's instance object or an
 *     interface or interface prototype object.
 */
inline bool
XrayGetNativeProto(JSContext* cx, JS::Handle<JSObject*> obj,
                   JS::MutableHandle<JSObject*> protop)
{
  JS::Rooted<JSObject*> global(cx, js::GetGlobalForObjectCrossCompartment(obj));
  {
    JSAutoCompartment ac(cx, global);
    const DOMJSClass* domClass = GetDOMClass(obj);
    if (domClass) {
      ProtoHandleGetter protoGetter = domClass->mGetProto;
      if (protoGetter) {
        protop.set(protoGetter(cx));
      } else {
        protop.set(JS::GetRealmObjectPrototype(cx));
      }
    } else if (JS_ObjectIsFunction(cx, obj)) {
      MOZ_ASSERT(JS_IsNativeFunction(obj, Constructor));
      protop.set(JS::GetRealmFunctionPrototype(cx));
    } else {
      const js::Class* clasp = js::GetObjectClass(obj);
      MOZ_ASSERT(IsDOMIfaceAndProtoClass(clasp));
      ProtoGetter protoGetter =
        DOMIfaceAndProtoJSClass::FromJSClass(clasp)->mGetParentProto;
      protop.set(protoGetter(cx));
    }
  }

  return JS_WrapObject(cx, protop);
}

/**
 * Get the Xray expando class to use for the given DOM object.
 */
const JSClass*
XrayGetExpandoClass(JSContext* cx, JS::Handle<JSObject*> obj);

/**
 * Delete a named property, if any.  Return value is false if exception thrown,
 * true otherwise.  The caller should not do any more work after calling this
 * function, because it has no way whether a deletion was performed and hence
 * opresult already has state set on it.  If callers ever need to change that,
 * add a "bool* found" argument and change the generated DeleteNamedProperty to
 * use it instead of a local variable.
 */
bool
XrayDeleteNamedProperty(JSContext* cx, JS::Handle<JSObject*> wrapper,
                        JS::Handle<JSObject*> obj, JS::Handle<jsid> id,
                        JS::ObjectOpResult& opresult);

/**
 * Get the object which should be used to cache the return value of a property
 * getter in the case of a [Cached] or [StoreInSlot] property.  `obj` is the
 * `this` value for our property getter that we're working with.
 *
 * This function can return null on failure to allocate the object, throwing on
 * the JSContext in the process.
 *
 * The isXray outparam will be set to true if obj is an Xray and false
 * otherwise.
 *
 * Note that the Slow version should only be called from
 * GetCachedSlotStorageObject.
 */
JSObject*
GetCachedSlotStorageObjectSlow(JSContext* cx, JS::Handle<JSObject*> obj,
                               bool* isXray);

inline JSObject*
GetCachedSlotStorageObject(JSContext* cx, JS::Handle<JSObject*> obj,
                           bool* isXray) {
  if (IsDOMObject(obj)) {
    *isXray = false;
    return obj;
  }

  return GetCachedSlotStorageObjectSlow(cx, obj, isXray);
}

extern NativePropertyHooks sEmptyNativePropertyHooks;

extern const js::ClassOps sBoringInterfaceObjectClassClassOps;

extern const js::ObjectOps sInterfaceObjectClassObjectOps;

inline bool
UseDOMXray(JSObject* obj)
{
  const js::Class* clasp = js::GetObjectClass(obj);
  return IsDOMClass(clasp) ||
         JS_IsNativeFunction(obj, Constructor) ||
         IsDOMIfaceAndProtoClass(clasp);
}

#ifdef DEBUG
inline bool
HasConstructor(JSObject* obj)
{
  return JS_IsNativeFunction(obj, Constructor) ||
         js::GetObjectClass(obj)->getConstruct();
}
#endif

// Helpers for creating a const version of a type.
template<typename T>
const T& Constify(T& arg)
{
  return arg;
}

// Helper for turning (Owning)NonNull<T> into T&
template<typename T>
T& NonNullHelper(T& aArg)
{
  return aArg;
}

template<typename T>
T& NonNullHelper(NonNull<T>& aArg)
{
  return aArg;
}

template<typename T>
const T& NonNullHelper(const NonNull<T>& aArg)
{
  return aArg;
}

template<typename T>
T& NonNullHelper(OwningNonNull<T>& aArg)
{
  return aArg;
}

template<typename T>
const T& NonNullHelper(const OwningNonNull<T>& aArg)
{
  return aArg;
}

inline
void NonNullHelper(NonNull<binding_detail::FakeString>& aArg)
{
  // This overload is here to make sure that we never end up applying
  // NonNullHelper to a NonNull<binding_detail::FakeString>. If we
  // try to, it should fail to compile, since presumably the caller will try to
  // use our nonexistent return value.
}

inline
void NonNullHelper(const NonNull<binding_detail::FakeString>& aArg)
{
  // This overload is here to make sure that we never end up applying
  // NonNullHelper to a NonNull<binding_detail::FakeString>. If we
  // try to, it should fail to compile, since presumably the caller will try to
  // use our nonexistent return value.
}

inline
void NonNullHelper(binding_detail::FakeString& aArg)
{
  // This overload is here to make sure that we never end up applying
  // NonNullHelper to a FakeString before we've constified it.  If we
  // try to, it should fail to compile, since presumably the caller will try to
  // use our nonexistent return value.
}

MOZ_ALWAYS_INLINE
const nsAString& NonNullHelper(const binding_detail::FakeString& aArg)
{
  return aArg;
}

// Reparent the wrapper of aObj to whatever its native now thinks its
// parent should be.
nsresult
ReparentWrapper(JSContext* aCx, JS::Handle<JSObject*> aObj);

/**
 * Used to implement the Symbol.hasInstance property of an interface object.
 */
bool
InterfaceHasInstance(JSContext* cx, unsigned argc, JS::Value* vp);

bool
InterfaceHasInstance(JSContext* cx, int prototypeID, int depth,
                     JS::Handle<JSObject*> instance,
                     bool* bp);

// Helper for lenient getters/setters to report to console.  If this
// returns false, we couldn't even get a global.
bool
ReportLenientThisUnwrappingFailure(JSContext* cx, JSObject* obj);

// Given a JSObject* that represents the chrome side of a JS-implemented WebIDL
// interface, get the nsIGlobalObject corresponding to the content side, if any.
// A false return means an exception was thrown.
bool
GetContentGlobalForJSImplementedObject(JSContext* cx, JS::Handle<JSObject*> obj,
                                       nsIGlobalObject** global);

void
ConstructJSImplementation(const char* aContractId,
                          nsIGlobalObject* aGlobal,
                          JS::MutableHandle<JSObject*> aObject,
                          ErrorResult& aRv);

already_AddRefed<nsIGlobalObject>
ConstructJSImplementation(const char* aContractId,
                          const GlobalObject& aGlobal,
                          JS::MutableHandle<JSObject*> aObject,
                          ErrorResult& aRv);

/**
 * Convert an nsCString to jsval, returning true on success.
 * These functions are intended for ByteString implementations.
 * As such, the string is not UTF-8 encoded.  Any UTF8 strings passed to these
 * methods will be mangled.
 */
bool NonVoidByteStringToJsval(JSContext *cx, const nsACString &str,
                              JS::MutableHandle<JS::Value> rval);
inline bool ByteStringToJsval(JSContext *cx, const nsACString &str,
                              JS::MutableHandle<JS::Value> rval)
{
    if (str.IsVoid()) {
        rval.setNull();
        return true;
    }
    return NonVoidByteStringToJsval(cx, str, rval);
}

template<class T, bool isISupports=IsBaseOf<nsISupports, T>::value>
struct PreserveWrapperHelper
{
  static void PreserveWrapper(T* aObject)
  {
    aObject->PreserveWrapper(aObject, NS_CYCLE_COLLECTION_PARTICIPANT(T));
  }
};

template<class T>
struct PreserveWrapperHelper<T, true>
{
  static void PreserveWrapper(T* aObject)
  {
    aObject->PreserveWrapper(reinterpret_cast<nsISupports*>(aObject));
  }
};

template<class T>
void PreserveWrapper(T* aObject)
{
  PreserveWrapperHelper<T>::PreserveWrapper(aObject);
}

template<class T, bool isISupports=IsBaseOf<nsISupports, T>::value>
struct CastingAssertions
{
  static bool ToSupportsIsCorrect(T*)
  {
    return true;
  }
  static bool ToSupportsIsOnPrimaryInheritanceChain(T*, nsWrapperCache*)
  {
    return true;
  }
};

template<class T>
struct CastingAssertions<T, true>
{
  static bool ToSupportsIsCorrect(T* aObject)
  {
    return ToSupports(aObject) ==  reinterpret_cast<nsISupports*>(aObject);
  }
  static bool ToSupportsIsOnPrimaryInheritanceChain(T* aObject,
                                                    nsWrapperCache* aCache)
  {
    return reinterpret_cast<void*>(aObject) != aCache;
  }
};

template<class T>
bool
ToSupportsIsCorrect(T* aObject)
{
  return CastingAssertions<T>::ToSupportsIsCorrect(aObject);
}

template<class T>
bool
ToSupportsIsOnPrimaryInheritanceChain(T* aObject, nsWrapperCache* aCache)
{
  return CastingAssertions<T>::ToSupportsIsOnPrimaryInheritanceChain(aObject,
                                                                     aCache);
}

// The BindingJSObjectCreator class is supposed to be used by a caller that
// wants to create and initialise a binding JSObject. After initialisation has
// been successfully completed it should call ForgetObject().
// The BindingJSObjectCreator object will root the JSObject until ForgetObject()
// is called on it. If the native object for the binding is refcounted it will
// also hold a strong reference to it, that reference is transferred to the
// JSObject (which holds the native in a slot) when ForgetObject() is called. If
// the BindingJSObjectCreator object is destroyed and ForgetObject() was never
// called on it then the JSObject's slot holding the native will be set to
// undefined, and for a refcounted native the strong reference will be released.
template<class T>
class MOZ_STACK_CLASS BindingJSObjectCreator
{
public:
  explicit BindingJSObjectCreator(JSContext* aCx)
    : mReflector(aCx)
  {
  }

  ~BindingJSObjectCreator()
  {
    if (mReflector) {
      js::SetReservedOrProxyPrivateSlot(mReflector, DOM_OBJECT_SLOT,
                                        JS::UndefinedValue());
    }
  }

  void
  CreateProxyObject(JSContext* aCx, const js::Class* aClass,
                    const DOMProxyHandler* aHandler,
                    JS::Handle<JSObject*> aProto, T* aNative,
                    JS::MutableHandle<JSObject*> aReflector)
  {
    js::ProxyOptions options;
    options.setClass(aClass);
    JS::Rooted<JS::Value> proxyPrivateVal(aCx, JS::PrivateValue(aNative));
    aReflector.set(js::NewProxyObject(aCx, aHandler, proxyPrivateVal, aProto,
                                      options));
    if (aReflector) {
      mNative = aNative;
      mReflector = aReflector;
    }
  }

  void
  CreateObject(JSContext* aCx, const JSClass* aClass,
               JS::Handle<JSObject*> aProto,
               T* aNative, JS::MutableHandle<JSObject*> aReflector)
  {
    aReflector.set(JS_NewObjectWithGivenProto(aCx, aClass, aProto));
    if (aReflector) {
      js::SetReservedSlot(aReflector, DOM_OBJECT_SLOT, JS::PrivateValue(aNative));
      mNative = aNative;
      mReflector = aReflector;
    }
  }

  void
  InitializationSucceeded()
  {
    void* dummy;
    mNative.forget(&dummy);
    mReflector = nullptr;
  }

private:
  struct OwnedNative
  {
    // Make sure the native objects inherit from NonRefcountedDOMObject so
    // that we log their ctor and dtor.
    static_assert(IsBaseOf<NonRefcountedDOMObject, T>::value,
                  "Non-refcounted objects with DOM bindings should inherit "
                  "from NonRefcountedDOMObject.");

    OwnedNative&
    operator=(T* aNative)
    {
      return *this;
    }

    // This signature sucks, but it's the only one that will make a nsRefPtr
    // just forget about its pointer without warning.
    void
    forget(void**)
    {
    }
  };

  JS::Rooted<JSObject*> mReflector;
  typename Conditional<IsRefcounted<T>::value, RefPtr<T>, OwnedNative>::Type mNative;
};

template<class T>
struct DeferredFinalizerImpl
{
  typedef typename Conditional<IsSame<T, nsISupports>::value,
                               nsCOMPtr<T>,
                               typename Conditional<IsRefcounted<T>::value,
                                                    RefPtr<T>,
                                                    nsAutoPtr<T>>::Type>::Type SmartPtr;
  typedef SegmentedVector<SmartPtr> SmartPtrArray;

  static_assert(IsSame<T, nsISupports>::value || !IsBaseOf<nsISupports, T>::value,
                "nsISupports classes should all use the nsISupports instantiation");

  static inline void
  AppendAndTake(SegmentedVector<nsCOMPtr<nsISupports>>& smartPtrArray, nsISupports* ptr)
  {
    smartPtrArray.InfallibleAppend(dont_AddRef(ptr));
  }
  template<class U>
  static inline void
  AppendAndTake(SegmentedVector<RefPtr<U>>& smartPtrArray, U* ptr)
  {
    smartPtrArray.InfallibleAppend(dont_AddRef(ptr));
  }
  template<class U>
  static inline void
  AppendAndTake(SegmentedVector<nsAutoPtr<U>>& smartPtrArray, U* ptr)
  {
    smartPtrArray.InfallibleAppend(ptr);
  }

  static void*
  AppendDeferredFinalizePointer(void* aData, void* aObject)
  {
    SmartPtrArray* pointers = static_cast<SmartPtrArray*>(aData);
    if (!pointers) {
      pointers = new SmartPtrArray();
    }
    AppendAndTake(*pointers, static_cast<T*>(aObject));
    return pointers;
  }
  static bool
  DeferredFinalize(uint32_t aSlice, void* aData)
  {
    MOZ_ASSERT(aSlice > 0, "nonsensical/useless call with aSlice == 0");
    SmartPtrArray* pointers = static_cast<SmartPtrArray*>(aData);
    uint32_t oldLen = pointers->Length();
    if (oldLen < aSlice) {
      aSlice = oldLen;
    }
    uint32_t newLen = oldLen - aSlice;
    pointers->PopLastN(aSlice);
    if (newLen == 0) {
      delete pointers;
      return true;
    }
    return false;
  }
};

template<class T,
         bool isISupports=IsBaseOf<nsISupports, T>::value>
struct DeferredFinalizer
{
  static void
  AddForDeferredFinalization(T* aObject)
  {
    typedef DeferredFinalizerImpl<T> Impl;
    DeferredFinalize(Impl::AppendDeferredFinalizePointer,
                     Impl::DeferredFinalize, aObject);
  }
};

template<class T>
struct DeferredFinalizer<T, true>
{
  static void
  AddForDeferredFinalization(T* aObject)
  {
    DeferredFinalize(reinterpret_cast<nsISupports*>(aObject));
  }
};

template<class T>
static void
AddForDeferredFinalization(T* aObject)
{
  DeferredFinalizer<T>::AddForDeferredFinalization(aObject);
}

// This returns T's CC participant if it participates in CC or null if it
// doesn't. This also returns null for classes that don't inherit from
// nsISupports (QI should be used to get the participant for those).
template<class T, bool isISupports=IsBaseOf<nsISupports, T>::value>
class GetCCParticipant
{
  // Helper for GetCCParticipant for classes that participate in CC.
  template<class U>
  static constexpr nsCycleCollectionParticipant*
  GetHelper(int, typename U::NS_CYCLE_COLLECTION_INNERCLASS* dummy=nullptr)
  {
    return T::NS_CYCLE_COLLECTION_INNERCLASS::GetParticipant();
  }
  // Helper for GetCCParticipant for classes that don't participate in CC.
  template<class U>
  static constexpr nsCycleCollectionParticipant*
  GetHelper(double)
  {
    return nullptr;
  }

public:
  static constexpr nsCycleCollectionParticipant*
  Get()
  {
    // Passing int() here will try to call the GetHelper that takes an int as
    // its firt argument. If T doesn't participate in CC then substitution for
    // the second argument (with a default value) will fail and because of
    // SFINAE the next best match (the variant taking a double) will be called.
    return GetHelper<T>(int());
  }
};

template<class T>
class GetCCParticipant<T, true>
{
public:
  static constexpr nsCycleCollectionParticipant*
  Get()
  {
    return nullptr;
  }
};

void
FinalizeGlobal(JSFreeOp* aFop, JSObject* aObj);

bool
ResolveGlobal(JSContext* aCx, JS::Handle<JSObject*> aObj,
              JS::Handle<jsid> aId, bool* aResolvedp);

bool
MayResolveGlobal(const JSAtomState& aNames, jsid aId, JSObject* aMaybeObj);

bool
EnumerateGlobal(JSContext* aCx, JS::Handle<JSObject*> aObj);

template <class T>
struct CreateGlobalOptions
{
  static constexpr ProtoAndIfaceCache::Kind ProtoAndIfaceCacheKind =
    ProtoAndIfaceCache::NonWindowLike;
  static void TraceGlobal(JSTracer* aTrc, JSObject* aObj)
  {
    mozilla::dom::TraceProtoAndIfaceCache(aTrc, aObj);
  }
  static bool PostCreateGlobal(JSContext* aCx, JS::Handle<JSObject*> aGlobal)
  {
    MOZ_ALWAYS_TRUE(TryPreserveWrapper(aGlobal));

    return true;
  }
};

template <>
struct CreateGlobalOptions<nsGlobalWindow>
{
  static constexpr ProtoAndIfaceCache::Kind ProtoAndIfaceCacheKind =
    ProtoAndIfaceCache::WindowLike;
  static void TraceGlobal(JSTracer* aTrc, JSObject* aObj);
  static bool PostCreateGlobal(JSContext* aCx, JS::Handle<JSObject*> aGlobal);
};

nsresult
RegisterDOMNames();

// The return value is true if we created and successfully performed our part of
// the setup for the global, false otherwise.
//
// Typically this method's caller will want to ensure that
// xpc::InitGlobalObjectOptions is called before, and xpc::InitGlobalObject is
// called after, this method, to ensure that this global object and its
// compartment are consistent with other global objects.
template <class T, ProtoHandleGetter GetProto>
bool
CreateGlobal(JSContext* aCx, T* aNative, nsWrapperCache* aCache,
             const JSClass* aClass, JS::CompartmentOptions& aOptions,
             JSPrincipals* aPrincipal, bool aInitStandardClasses,
             JS::MutableHandle<JSObject*> aGlobal)
{
  aOptions.creationOptions().setTrace(CreateGlobalOptions<T>::TraceGlobal);
  if (xpc::SharedMemoryEnabled()) {
    aOptions.creationOptions().setSharedMemoryAndAtomicsEnabled(true);
  }

  aGlobal.set(JS_NewGlobalObject(aCx, aClass, aPrincipal,
                                 JS::DontFireOnNewGlobalHook, aOptions));
  if (!aGlobal) {
    NS_WARNING("Failed to create global");
    return false;
  }

  JSAutoCompartment ac(aCx, aGlobal);

  {
    js::SetReservedSlot(aGlobal, DOM_OBJECT_SLOT, JS::PrivateValue(aNative));
    NS_ADDREF(aNative);

    aCache->SetWrapper(aGlobal);

    dom::AllocateProtoAndIfaceCache(aGlobal,
                                    CreateGlobalOptions<T>::ProtoAndIfaceCacheKind);

    if (!CreateGlobalOptions<T>::PostCreateGlobal(aCx, aGlobal)) {
      return false;
    }
  }

  if (aInitStandardClasses &&
      !JS_InitStandardClasses(aCx, aGlobal)) {
    NS_WARNING("Failed to init standard classes");
    return false;
  }

  JS::Handle<JSObject*> proto = GetProto(aCx);
  if (!proto || !JS_SplicePrototype(aCx, aGlobal, proto)) {
    NS_WARNING("Failed to set proto");
    return false;
  }

  bool succeeded;
  if (!JS_SetImmutablePrototype(aCx, aGlobal, &succeeded)) {
    return false;
  }
  MOZ_ASSERT(succeeded,
             "making a fresh global object's [[Prototype]] immutable can "
             "internally fail, but it should never be unsuccessful");

  return true;
}

/*
 * Holds a jsid that is initialized to a pinned string, with automatic
 * conversion to Handle<jsid>, as it is held live forever by pinning.
 */
class PinnedStringId
{
  jsid id;

 public:
  PinnedStringId() : id(JSID_VOID) {}

  bool init(JSContext *cx, const char *string) {
    JSString* str = JS_AtomizeAndPinString(cx, string);
    if (!str)
      return false;
    id = INTERNED_STRING_TO_JSID(cx, str);
    return true;
  }

  operator const jsid& () {
    return id;
  }

  operator JS::Handle<jsid> () {
    /* This is safe because we have pinned the string. */
    return JS::Handle<jsid>::fromMarkedLocation(&id);
  }
};

bool
GenericBindingGetter(JSContext* cx, unsigned argc, JS::Value* vp);

bool
GenericBindingSetter(JSContext* cx, unsigned argc, JS::Value* vp);

bool
GenericBindingMethod(JSContext* cx, unsigned argc, JS::Value* vp);

bool
GenericPromiseReturningBindingMethod(JSContext* cx, unsigned argc, JS::Value* vp);

bool
StaticMethodPromiseWrapper(JSContext* cx, unsigned argc, JS::Value* vp);

// ConvertExceptionToPromise should only be called when we have an error
// condition (e.g. returned false from a JSAPI method).  Note that there may be
// no exception on cx, in which case this is an uncatchable failure that will
// simply be propagated.  Otherwise this method will attempt to convert the
// exception to a Promise rejected with the exception that it will store in
// rval.
//
// promiseScope should be the scope in which the Promise should be created.
bool
ConvertExceptionToPromise(JSContext* cx,
                          JSObject* promiseScope,
                          JS::MutableHandle<JS::Value> rval);

#ifdef DEBUG
void
AssertReturnTypeMatchesJitinfo(const JSJitInfo* aJitinfo,
                               JS::Handle<JS::Value> aValue);
#endif

// This function is called by the bindings layer for methods/getters/setters
// that are not safe to be called in prerendering mode.  It checks to make sure
// that the |this| object is not running in a global that is in prerendering
// mode.  Otherwise, it aborts execution of timers and event handlers, and
// returns false which gets converted to an uncatchable exception by the
// bindings layer.
bool
EnforceNotInPrerendering(JSContext* aCx, JSObject* aObj);

// Handles the violation of a blacklisted action in prerendering mode by
// aborting the scripts, and preventing timers and event handlers from running
// in the window in the future.
void
HandlePrerenderingViolation(nsPIDOMWindowInner* aWindow);

bool
CallerSubsumes(JSObject* aObject);

MOZ_ALWAYS_INLINE bool
CallerSubsumes(JS::Handle<JS::Value> aValue)
{
  if (!aValue.isObject()) {
    return true;
  }
  return CallerSubsumes(&aValue.toObject());
}

template<class T>
inline bool
WrappedJSToDictionary(JSContext* aCx, nsISupports* aObject, T& aDictionary)
{
  nsCOMPtr<nsIXPConnectWrappedJS> wrappedObj = do_QueryInterface(aObject);
  if (!wrappedObj) {
    return false;
  }

  JS::Rooted<JSObject*> obj(aCx, wrappedObj->GetJSObject());
  if (!obj) {
    return false;
  }

  JSAutoCompartment ac(aCx, obj);
  JS::Rooted<JS::Value> v(aCx, JS::ObjectValue(*obj));
  return aDictionary.Init(aCx, v);
}

template<class T>
inline bool
WrappedJSToDictionary(nsISupports* aObject, T& aDictionary)
{
  nsCOMPtr<nsIXPConnectWrappedJS> wrappedObj = do_QueryInterface(aObject);
  NS_ENSURE_TRUE(wrappedObj, false);
  JS::Rooted<JSObject*> obj(RootingCx(), wrappedObj->GetJSObject());
  NS_ENSURE_TRUE(obj, false);

  nsIGlobalObject* global = xpc::NativeGlobal(obj);
  NS_ENSURE_TRUE(global, false);

  // we need this AutoEntryScript here because the spec requires us to execute
  // getters when parsing a dictionary
  AutoEntryScript aes(global, "WebIDL dictionary creation");

  JS::Rooted<JS::Value> v(aes.cx(), JS::ObjectValue(*obj));
  return aDictionary.Init(aes.cx(), v);
}


template<class T, class S>
inline RefPtr<T>
StrongOrRawPtr(already_AddRefed<S>&& aPtr)
{
  return aPtr.template downcast<T>();
}

template<class T,
         class ReturnType=typename Conditional<IsRefcounted<T>::value, T*,
                                               nsAutoPtr<T>>::Type>
inline ReturnType
StrongOrRawPtr(T* aPtr)
{
  return ReturnType(aPtr);
}

template<class T, template<typename> class SmartPtr, class S>
inline void
StrongOrRawPtr(SmartPtr<S>&& aPtr) = delete;

template<class T>
struct StrongPtrForMember
{
  typedef typename Conditional<IsRefcounted<T>::value,
                               RefPtr<T>, nsAutoPtr<T>>::Type Type;
};

namespace binding_detail {
inline
JSObject*
GetHackedNamespaceProtoObject(JSContext* aCx)
{
  return JS_NewPlainObject(aCx);
}
} // namespace binding_detail

// Resolve an id on the given global object that wants to be included in
// Exposed=System webidl annotations.  False return value means exception
// thrown.
bool SystemGlobalResolve(JSContext* cx, JS::Handle<JSObject*> obj,
                         JS::Handle<jsid> id, bool* resolvedp);

// Enumerate all ids on the given global object that wants to be included in
// Exposed=System webidl annotations.  False return value means exception
// thrown.
bool SystemGlobalEnumerate(JSContext* cx, JS::Handle<JSObject*> obj);

// Slot indexes for maplike/setlike forEach functions
#define FOREACH_CALLBACK_SLOT 0
#define FOREACH_MAPLIKEORSETLIKEOBJ_SLOT 1

// Backing function for running .forEach() on maplike/setlike interfaces.
// Unpacks callback and maplike/setlike object from reserved slots, then runs
// callback for each key (and value, for maplikes)
bool ForEachHandler(JSContext* aCx, unsigned aArgc, JS::Value* aVp);

// Unpacks backing object (ES6 map/set) from the reserved slot of a reflector
// for a maplike/setlike interface. If backing object does not exist, creates
// backing object in the compartment of the reflector involved, making this safe
// to use across compartments/via xrays. Return values of these methods will
// always be in the context compartment.
bool GetMaplikeBackingObject(JSContext* aCx, JS::Handle<JSObject*> aObj,
                             size_t aSlotIndex,
                             JS::MutableHandle<JSObject*> aBackingObj,
                             bool* aBackingObjCreated);
bool GetSetlikeBackingObject(JSContext* aCx, JS::Handle<JSObject*> aObj,
                             size_t aSlotIndex,
                             JS::MutableHandle<JSObject*> aBackingObj,
                             bool* aBackingObjCreated);

// Get the desired prototype object for an object construction from the given
// CallArgs.  Null is returned if the default prototype should be used.
bool
GetDesiredProto(JSContext* aCx, const JS::CallArgs& aCallArgs,
                JS::MutableHandle<JSObject*> aDesiredProto);

void
SetDocumentAndPageUseCounter(JSContext* aCx, JSObject* aObject,
                             UseCounter aUseCounter);

// Warnings
void
DeprecationWarning(JSContext* aCx, JSObject* aObject,
                   nsIDocument::DeprecatedOperations aOperation);

// A callback to perform funToString on an interface object
JSString*
InterfaceObjectToString(JSContext* aCx, JS::Handle<JSObject*> aObject,
                        unsigned /* indent */);

namespace binding_detail {
// Get a JS global object that can be used for some temporary allocations.  The
// idea is that this should be used for situations when you need to operate in
// _some_ compartment but don't care which one.  A typical example is when you
// have non-JS input, non-JS output, but have to go through some sort of JS
// representation in the middle, so need a compartment to allocate things in.
//
// It's VERY important that any consumers of this function only do things that
// are guaranteed to be side-effect-free, even in the face of a script
// environment controlled by a hostile adversary.  This is because in the worker
// case the global is in fact the worker global, so it and its standard objects
// are controlled by the worker script.  This is why this function is in the
// binding_detail namespace.  Any use of this function MUST be very carefully
// reviewed by someone who is sufficiently devious and has a very good
// understanding of all the code that will run while we're using the return
// value, including the SpiderMonkey parts.
JSObject* UnprivilegedJunkScopeOrWorkerGlobal();
} // namespace binding_detail

} // namespace dom
} // namespace mozilla

#endif /* mozilla_dom_BindingUtils_h__ */
