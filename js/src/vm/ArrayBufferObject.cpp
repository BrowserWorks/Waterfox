/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "vm/ArrayBufferObject-inl.h"
#include "vm/ArrayBufferObject.h"

#include "mozilla/Alignment.h"
#include "mozilla/CheckedInt.h"
#include "mozilla/FloatingPoint.h"
#include "mozilla/Maybe.h"
#include "mozilla/PodOperations.h"
#include "mozilla/TaggedAnonymousMemory.h"

#include <string.h>
#ifndef XP_WIN
# include <sys/mman.h>
#endif

#ifdef MOZ_VALGRIND
# include <valgrind/memcheck.h>
#endif

#include "jsapi.h"
#include "jsarray.h"
#include "jscntxt.h"
#include "jscpucfg.h"
#include "jsfriendapi.h"
#include "jsnum.h"
#include "jsobj.h"
#include "jstypes.h"
#include "jsutil.h"
#ifdef XP_WIN
# include "jswin.h"
#endif
#include "jswrapper.h"

#include "gc/Barrier.h"
#include "gc/Marking.h"
#include "gc/Memory.h"
#include "js/Conversions.h"
#include "js/MemoryMetrics.h"
#include "vm/GlobalObject.h"
#include "vm/Interpreter.h"
#include "vm/SelfHosting.h"
#include "vm/SharedArrayObject.h"
#include "vm/WrapperObject.h"
#include "wasm/WasmSignalHandlers.h"
#include "wasm/WasmTypes.h"

#include "jsatominlines.h"

#include "vm/NativeObject-inl.h"
#include "vm/Shape-inl.h"

using JS::ToInt32;

using mozilla::DebugOnly;
using mozilla::CheckedInt;
using mozilla::Some;
using mozilla::Maybe;
using mozilla::Nothing;

using namespace js;
using namespace js::gc;

/*
 * Convert |v| to an array index for an array of length |length| per
 * the Typed Array Specification section 7.0, |subarray|. If successful,
 * the output value is in the range [0, length].
 */
bool
js::ToClampedIndex(JSContext* cx, HandleValue v, uint32_t length, uint32_t* out)
{
    int32_t result;
    if (!ToInt32(cx, v, &result))
        return false;
    if (result < 0) {
        result += length;
        if (result < 0)
            result = 0;
    } else if (uint32_t(result) > length) {
        result = length;
    }
    *out = uint32_t(result);
    return true;
}

static bool
arraybuffer_static_slice(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    if (args.length() < 1) {
        ReportMissingArg(cx, args.calleev(), 1);
        return false;
    }

    if (!GlobalObject::warnOnceAboutArrayBufferSlice(cx, cx->global()))
        return false;

    FixedInvokeArgs<2> args2(cx);
    args2[0].set(args.get(1));
    args2[1].set(args.get(2));
    return CallSelfHostedFunction(cx, "ArrayBufferSlice", args[0], args2, args.rval());
}

/*
 * ArrayBufferObject
 *
 * This class holds the underlying raw buffer that the TypedArrayObject classes
 * access.  It can be created explicitly and passed to a TypedArrayObject, or
 * can be created implicitly by constructing a TypedArrayObject with a size.
 */

/*
 * ArrayBufferObject (base)
 */

static const ClassSpec ArrayBufferObjectProtoClassSpec = {
    DELEGATED_CLASSSPEC(ArrayBufferObject::class_.spec),
    nullptr,
    nullptr,
    nullptr,
    nullptr,
    nullptr,
    nullptr,
    ClassSpec::IsDelegated
};

static const Class ArrayBufferObjectProtoClass = {
    "ArrayBufferPrototype",
    JSCLASS_HAS_CACHED_PROTO(JSProto_ArrayBuffer),
    JS_NULL_CLASS_OPS,
    &ArrayBufferObjectProtoClassSpec
};

static JSObject*
CreateArrayBufferPrototype(JSContext* cx, JSProtoKey key)
{
    return cx->global()->createBlankPrototype(cx, &ArrayBufferObjectProtoClass);
}

static const ClassOps ArrayBufferObjectClassOps = {
    nullptr,        /* addProperty */
    nullptr,        /* delProperty */
    nullptr,        /* getProperty */
    nullptr,        /* setProperty */
    nullptr,        /* enumerate */
    nullptr,        /* resolve */
    nullptr,        /* mayResolve */
    ArrayBufferObject::finalize,
    nullptr,        /* call        */
    nullptr,        /* hasInstance */
    nullptr,        /* construct   */
    ArrayBufferObject::trace,
};

static const JSFunctionSpec static_functions[] = {
    JS_FN("isView", ArrayBufferObject::fun_isView, 1, 0),
    JS_FN("slice", arraybuffer_static_slice, 3, 0),
    JS_FS_END
};

static const JSPropertySpec static_properties[] = {
    JS_SELF_HOSTED_SYM_GET(species, "ArrayBufferSpecies", 0),
    JS_PS_END
};


static const JSFunctionSpec prototype_functions[] = {
    JS_SELF_HOSTED_FN("slice", "ArrayBufferSlice", 2, 0),
    JS_FS_END
};

static const JSPropertySpec prototype_properties[] = {
    JS_PSG("byteLength", ArrayBufferObject::byteLengthGetter, 0),
    JS_STRING_SYM_PS(toStringTag, "ArrayBuffer", JSPROP_READONLY),
    JS_PS_END
};

static const ClassSpec ArrayBufferObjectClassSpec = {
    GenericCreateConstructor<ArrayBufferObject::class_constructor, 1, gc::AllocKind::FUNCTION>,
    CreateArrayBufferPrototype,
    static_functions,
    static_properties,
    prototype_functions,
    prototype_properties
};

static const ClassExtension ArrayBufferObjectClassExtension = {
    nullptr,    /* weakmapKeyDelegateOp */
    ArrayBufferObject::objectMoved
};

const Class ArrayBufferObject::class_ = {
    "ArrayBuffer",
    JSCLASS_DELAY_METADATA_BUILDER |
    JSCLASS_HAS_RESERVED_SLOTS(RESERVED_SLOTS) |
    JSCLASS_HAS_CACHED_PROTO(JSProto_ArrayBuffer) |
    JSCLASS_BACKGROUND_FINALIZE,
    &ArrayBufferObjectClassOps,
    &ArrayBufferObjectClassSpec,
    &ArrayBufferObjectClassExtension
};

bool
js::IsArrayBuffer(HandleValue v)
{
    return v.isObject() && v.toObject().is<ArrayBufferObject>();
}

bool
js::IsArrayBuffer(HandleObject obj)
{
    return obj->is<ArrayBufferObject>();
}

bool
js::IsArrayBuffer(JSObject* obj)
{
    return obj->is<ArrayBufferObject>();
}

ArrayBufferObject&
js::AsArrayBuffer(HandleObject obj)
{
    MOZ_ASSERT(IsArrayBuffer(obj));
    return obj->as<ArrayBufferObject>();
}

ArrayBufferObject&
js::AsArrayBuffer(JSObject* obj)
{
    MOZ_ASSERT(IsArrayBuffer(obj));
    return obj->as<ArrayBufferObject>();
}

MOZ_ALWAYS_INLINE bool
ArrayBufferObject::byteLengthGetterImpl(JSContext* cx, const CallArgs& args)
{
    MOZ_ASSERT(IsArrayBuffer(args.thisv()));
    args.rval().setInt32(args.thisv().toObject().as<ArrayBufferObject>().byteLength());
    return true;
}

bool
ArrayBufferObject::byteLengthGetter(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return CallNonGenericMethod<IsArrayBuffer, byteLengthGetterImpl>(cx, args);
}

/*
 * ArrayBuffer.isView(obj); ES6 (Dec 2013 draft) 24.1.3.1
 */
bool
ArrayBufferObject::fun_isView(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setBoolean(args.get(0).isObject() &&
                           JS_IsArrayBufferViewObject(&args.get(0).toObject()));
    return true;
}

/*
 * new ArrayBuffer(byteLength)
 */
bool
ArrayBufferObject::class_constructor(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    if (!ThrowIfNotConstructing(cx, args, "ArrayBuffer"))
        return false;

    int32_t nbytes = 0;
    if (argc > 0 && !ToInt32(cx, args[0], &nbytes))
        return false;

    if (nbytes < 0) {
        /*
         * We're just not going to support arrays that are bigger than what will fit
         * as an integer value; if someone actually ever complains (validly), then we
         * can fix.
         */
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_ARRAY_LENGTH);
        return false;
    }

    RootedObject proto(cx);
    RootedObject newTarget(cx, &args.newTarget().toObject());
    if (!GetPrototypeFromConstructor(cx, newTarget, &proto))
        return false;

    JSObject* bufobj = create(cx, uint32_t(nbytes), proto);
    if (!bufobj)
        return false;
    args.rval().setObject(*bufobj);
    return true;
}

static ArrayBufferObject::BufferContents
AllocateArrayBufferContents(JSContext* cx, uint32_t nbytes)
{
    uint8_t* p = cx->runtime()->pod_callocCanGC<uint8_t>(nbytes);
    if (!p)
        ReportOutOfMemory(cx);

    return ArrayBufferObject::BufferContents::create<ArrayBufferObject::PLAIN>(p);
}

static void
NoteViewBufferWasDetached(ArrayBufferViewObject* view,
                          ArrayBufferObject::BufferContents newContents,
                          JSContext* cx)
{
    view->notifyBufferDetached(cx, newContents.data());

    // Notify compiled jit code that the base pointer has moved.
    MarkObjectStateChange(cx, view);
}

/* static */ void
ArrayBufferObject::detach(JSContext* cx, Handle<ArrayBufferObject*> buffer,
                          BufferContents newContents)
{
    assertSameCompartment(cx, buffer);
    MOZ_ASSERT(!buffer->isPreparedForAsmJS());

    // When detaching buffers where we don't know all views, the new data must
    // match the old data. All missing views are typed objects, which do not
    // expect their data to ever change.
    MOZ_ASSERT_IF(buffer->forInlineTypedObject(),
                  newContents.data() == buffer->dataPointer());

    // When detaching a buffer with typed object views, any jitcode accessing
    // such views must be deoptimized so that detachment checks are performed.
    // This is done by setting a compartment-wide flag indicating that buffers
    // with typed object views have been detached.
    if (buffer->hasTypedObjectViews()) {
        // Make sure the global object's group has been instantiated, so the
        // flag change will be observed.
        AutoEnterOOMUnsafeRegion oomUnsafe;
        if (!cx->global()->getGroup(cx))
            oomUnsafe.crash("ArrayBufferObject::detach");
        MarkObjectGroupFlags(cx, cx->global(), OBJECT_FLAG_TYPED_OBJECT_HAS_DETACHED_BUFFER);
        cx->compartment()->detachedTypedObjects = 1;
    }

    // Update all views of the buffer to account for the buffer having been
    // detached, and clear the buffer's data and list of views.

    auto& innerViews = cx->compartment()->innerViews;
    if (InnerViewTable::ViewVector* views = innerViews.maybeViewsUnbarriered(buffer)) {
        for (size_t i = 0; i < views->length(); i++)
            NoteViewBufferWasDetached((*views)[i], newContents, cx);
        innerViews.removeViews(buffer);
    }
    if (buffer->firstView()) {
        if (buffer->forInlineTypedObject()) {
            // The buffer points to inline data in its first view, so to keep
            // this pointer alive we don't clear out the first view.
            MOZ_ASSERT(buffer->firstView()->is<InlineTransparentTypedObject>());
        } else {
            NoteViewBufferWasDetached(buffer->firstView(), newContents, cx);
            buffer->setFirstView(nullptr);
        }
    }

    if (newContents.data() != buffer->dataPointer())
        buffer->setNewData(cx->runtime()->defaultFreeOp(), newContents, OwnsData);

    buffer->setByteLength(0);
    buffer->setIsDetached();
}

void
ArrayBufferObject::setNewData(FreeOp* fop, BufferContents newContents, OwnsState ownsState)
{
    if (ownsData()) {
        MOZ_ASSERT(newContents.data() != dataPointer());
        releaseData(fop);
    }

    setDataPointer(newContents, ownsState);
}

// This is called *only* from changeContents(), below.
// By construction, every view parameter will be mapping unshared memory (an ArrayBuffer).
// Hence no reason to worry about shared memory here.

void
ArrayBufferObject::changeViewContents(JSContext* cx, ArrayBufferViewObject* view,
                                      uint8_t* oldDataPointer, BufferContents newContents)
{
    MOZ_ASSERT(!view->isSharedMemory());

    // Watch out for NULL data pointers in views. This means that the view
    // is not fully initialized (in which case it'll be initialized later
    // with the correct pointer).
    JS::AutoCheckCannotGC nogc(cx);
    uint8_t* viewDataPointer = view->dataPointerUnshared(nogc);
    if (viewDataPointer) {
        MOZ_ASSERT(newContents);
        ptrdiff_t offset = viewDataPointer - oldDataPointer;
        viewDataPointer = static_cast<uint8_t*>(newContents.data()) + offset;
        view->setDataPointerUnshared(viewDataPointer);
    }

    // Notify compiled jit code that the base pointer has moved.
    MarkObjectStateChange(cx, view);
}

// BufferContents is specific to ArrayBuffer, hence it will not represent shared memory.

void
ArrayBufferObject::changeContents(JSContext* cx, BufferContents newContents,
                                  OwnsState ownsState)
{
    MOZ_RELEASE_ASSERT(!isWasm());
    MOZ_ASSERT(!forInlineTypedObject());

    // Change buffer contents.
    uint8_t* oldDataPointer = dataPointer();
    setNewData(cx->runtime()->defaultFreeOp(), newContents, ownsState);

    // Update all views.
    auto& innerViews = cx->compartment()->innerViews;
    if (InnerViewTable::ViewVector* views = innerViews.maybeViewsUnbarriered(this)) {
        for (size_t i = 0; i < views->length(); i++)
            changeViewContents(cx, (*views)[i], oldDataPointer, newContents);
    }
    if (firstView())
        changeViewContents(cx, firstView(), oldDataPointer, newContents);
}

/*
 * Wasm Raw Buf Linear Memory Structure
 *
 * The linear heap in Wasm is an mmaped array buffer. Several
 * constants manage its lifetime:
 *
 *  - length - the wasm-visible current length of the buffer. Acesses in the
 *    range [0, length] succeed. May only increase
 *
 *  - boundsCheckLimit - when !WASM_HUGE_MEMORY, the size against which we
 *    perform bounds checks. It is always a constant offset smaller than
 *    mappedSize. Currently that constant offset is 0.
 *
 *  - max - the optional declared limit on how much length can grow.
 *
 *  - mappedSize - the actual mmaped size. Access in the range
 *    [0, mappedSize] will either succeed, or be handled by the wasm signal
 *    handlers.
 *
 * The below diagram shows the layout of the wams heap. The wasm-visible
 * portion of the heap starts at 0. There is one extra page prior to the
 * start of the wasm heap which contains the WasmArrayRawBuffer struct at
 * its end. (i.e. right before the start of the WASM heap).
 *
 *  WasmArrayRawBuffer
 *      \    ArrayBufferObject::dataPointer()
 *       \  /
 *        \ |
 *  ______|_|____________________________________________________________
 * |______|_|______________|___________________|____________|____________|
 *          0          length              maxSize  boundsCheckLimit  mappedSize
 *
 * \_______________________/
 *          COMMITED
 *                          \____________________________________________/
 *                                           SLOP
 * \_____________________________________________________________________/
 *                         MAPPED
 *
 * Invariants:
 *  - length only increases
 *  - 0 <= length <= maxSize (if present) <= boundsCheckLimit <= mappedSize
 *  - on ARM boundsCheckLimit must be a valid ARM immediate.
 *  - if maxSize is not specified, boundsCheckLimit/mappedSize may grow. They are
 *    otherwise constant.
 *
 * NOTE: For asm.js on non-x64 we guarantee that
 *
 * length == maxSize == boundsCheckLimit == mappedSize
 *
 * That is, signal handlers will not be invoked, since they cannot emulate
 * asm.js accesses on non-x64 architectures.
 *
 * The region between length and mappedSize is the SLOP - an area where we use
 * signal handlers to catch things that slip by bounds checks. Logically it has
 * two parts:
 *
 *  - from length to boundsCheckLimit - this part of the SLOP serves to catch
 *  accesses to memory we have reserved but not yet grown into. This allows us
 *  to grow memory up to max (when present) without having to patch/update the
 *  bounds checks.
 *
 *  - from boundsCheckLimit to mappedSize - (Note: In current patch 0) - this
 *  part of the SLOP allows us to bounds check against base pointers and fold
 *  some constant offsets inside loads. This enables better Bounds
 *  Check Elimination.
 *
 */

class js::WasmArrayRawBuffer
{
    Maybe<uint32_t> maxSize_;
    size_t mappedSize_;

  protected:
    WasmArrayRawBuffer(uint8_t* buffer, uint32_t length, Maybe<uint32_t> maxSize, size_t mappedSize)
      : maxSize_(maxSize), mappedSize_(mappedSize)
    {
        MOZ_ASSERT(buffer == dataPointer());
    }

  public:
    static WasmArrayRawBuffer* Allocate(uint32_t numBytes, Maybe<uint32_t> maxSize);
    static void Release(void* mem);

    uint8_t* dataPointer() {
        uint8_t* ptr = reinterpret_cast<uint8_t*>(this);
        return ptr + sizeof(WasmArrayRawBuffer);
    }

    uint8_t* basePointer() {
        return dataPointer() - gc::SystemPageSize();
    }

    size_t mappedSize() const {
        return mappedSize_;
    }

    Maybe<uint32_t> maxSize() const {
        return maxSize_;
    }

    size_t allocatedBytes() const {
        return mappedSize_ + gc::SystemPageSize();
    }

#ifndef WASM_HUGE_MEMORY
    uint32_t boundsCheckLimit() const {
        MOZ_ASSERT(mappedSize_ <= UINT32_MAX);
        MOZ_ASSERT(mappedSize_ >= wasm::GuardSize);
        MOZ_ASSERT(wasm::IsValidBoundsCheckImmediate(mappedSize_ - wasm::GuardSize));
        return mappedSize_ - wasm::GuardSize;
    }
#endif

    MOZ_MUST_USE bool growToSizeInPlace(uint32_t oldSize, uint32_t newSize) {
        MOZ_ASSERT(newSize >= oldSize);
        MOZ_ASSERT_IF(maxSize(), newSize <= maxSize().value());
        MOZ_ASSERT(newSize <= mappedSize());

        uint32_t delta = newSize - oldSize;
        MOZ_ASSERT(delta % wasm::PageSize == 0);

        uint8_t* dataEnd = dataPointer() + oldSize;
        MOZ_ASSERT(uintptr_t(dataEnd) % gc::SystemPageSize() == 0);
# ifdef XP_WIN
        if (delta && !VirtualAlloc(dataEnd, delta, MEM_COMMIT, PAGE_READWRITE))
            return false;
# else  // XP_WIN
        if (delta && mprotect(dataEnd, delta, PROT_READ | PROT_WRITE))
            return false;
# endif  // !XP_WIN

#  if defined(MOZ_VALGRIND) && defined(VALGRIND_DISABLE_ADDR_ERROR_REPORTING_IN_RANGE)
        VALGRIND_ENABLE_ADDR_ERROR_REPORTING_IN_RANGE((unsigned char*)dataEnd, delta);
#  endif

        MemProfiler::SampleNative(dataEnd, delta);
        return true;
    }

#ifndef WASM_HUGE_MEMORY
    bool extendMappedSize(uint32_t maxSize) {
        size_t newMappedSize = wasm::ComputeMappedSize(maxSize);
        MOZ_ASSERT(mappedSize_ <= newMappedSize);
        if (mappedSize_ == newMappedSize)
            return true;

# ifdef XP_WIN
        uint8_t* mappedEnd = dataPointer() + mappedSize_;
        uint32_t delta = newMappedSize - mappedSize_;
        if (!VirtualAlloc(mappedEnd, delta, MEM_RESERVE, PAGE_NOACCESS))
            return false;
# elif defined(XP_LINUX)
        // Note this will not move memory (no MREMAP_MAYMOVE specified)
        if (MAP_FAILED == mremap(dataPointer(), mappedSize_, newMappedSize, 0))
            return false;
# else
        // No mechanism for remapping on MacOS and other Unices. Luckily
        // shouldn't need it here as most of these are 64-bit.
        return false;
# endif

        mappedSize_ = newMappedSize;
        return true;
    }

    // Try and grow the mapped region of memory. Does not changes current size.
    // Does not move memory if no space to grow.
    void tryGrowMaxSizeInPlace(uint32_t deltaMaxSize) {
        CheckedInt<uint32_t> newMaxSize = maxSize_.value();
        newMaxSize += deltaMaxSize;
        MOZ_ASSERT(newMaxSize.isValid());
        MOZ_ASSERT(newMaxSize.value() % wasm::PageSize == 0);

        if (!extendMappedSize(newMaxSize.value()))
            return;

        maxSize_ = Some(newMaxSize.value());
    }
#endif // WASM_HUGE_MEMORY
};

/* static */ WasmArrayRawBuffer*
WasmArrayRawBuffer::Allocate(uint32_t numBytes, Maybe<uint32_t> maxSize)
{
    size_t mappedSize;
#ifdef WASM_HUGE_MEMORY
    mappedSize = wasm::HugeMappedSize;
#else
    mappedSize = wasm::ComputeMappedSize(maxSize.valueOr(numBytes));
#endif

    MOZ_RELEASE_ASSERT(mappedSize <= SIZE_MAX - gc::SystemPageSize());
    MOZ_RELEASE_ASSERT(numBytes <= maxSize.valueOr(UINT32_MAX));
    MOZ_ASSERT(numBytes % gc::SystemPageSize() == 0);
    MOZ_ASSERT(mappedSize % gc::SystemPageSize() == 0);

    uint64_t mappedSizeWithHeader = mappedSize + gc::SystemPageSize();
    uint64_t numBytesWithHeader = numBytes + gc::SystemPageSize();

# ifdef XP_WIN
    void* data = VirtualAlloc(nullptr, (size_t) mappedSizeWithHeader, MEM_RESERVE, PAGE_NOACCESS);
    if (!data)
        return nullptr;

    if (!VirtualAlloc(data, numBytesWithHeader, MEM_COMMIT, PAGE_READWRITE)) {
        VirtualFree(data, 0, MEM_RELEASE);
        return nullptr;
    }
# else  // XP_WIN
    void* data = MozTaggedAnonymousMmap(nullptr, (size_t) mappedSizeWithHeader, PROT_NONE,
                                        MAP_PRIVATE | MAP_ANON, -1, 0, "wasm-reserved");
    if (data == MAP_FAILED)
        return nullptr;

    // Note we will waste a page on zero-sized memories here
    if (mprotect(data, numBytesWithHeader, PROT_READ | PROT_WRITE)) {
        munmap(data, mappedSizeWithHeader);
        return nullptr;
    }
# endif  // !XP_WIN
    MemProfiler::SampleNative(data, numBytesWithHeader);

#  if defined(MOZ_VALGRIND) && defined(VALGRIND_DISABLE_ADDR_ERROR_REPORTING_IN_RANGE)
    VALGRIND_DISABLE_ADDR_ERROR_REPORTING_IN_RANGE((unsigned char*)data + numBytesWithHeader,
                                                   mappedSizeWithHeader - numBytesWithHeader);
#  endif

    uint8_t* base = reinterpret_cast<uint8_t*>(data) + gc::SystemPageSize();
    uint8_t* header = base - sizeof(WasmArrayRawBuffer);

    auto rawBuf = new (header) WasmArrayRawBuffer(base, numBytes, maxSize, mappedSize);
    return rawBuf;
}

/* static */ void
WasmArrayRawBuffer::Release(void* mem)
{
    WasmArrayRawBuffer* header = (WasmArrayRawBuffer*)((uint8_t*)mem - sizeof(WasmArrayRawBuffer));
    uint8_t* base = header->basePointer();
    MOZ_RELEASE_ASSERT(header->mappedSize() <= SIZE_MAX - gc::SystemPageSize());
    size_t mappedSizeWithHeader = header->mappedSize() + gc::SystemPageSize();

    MemProfiler::RemoveNative(base);
# ifdef XP_WIN
    VirtualFree(base, 0, MEM_RELEASE);
# else  // XP_WIN
    munmap(base, mappedSizeWithHeader);
# endif  // !XP_WIN

#  if defined(MOZ_VALGRIND) && defined(VALGRIND_ENABLE_ADDR_ERROR_REPORTING_IN_RANGE)
    VALGRIND_ENABLE_ADDR_ERROR_REPORTING_IN_RANGE(base, mappedSizeWithHeader);
#  endif
}

WasmArrayRawBuffer*
ArrayBufferObject::BufferContents::wasmBuffer() const
{
    MOZ_RELEASE_ASSERT(kind_ == WASM);
    return (WasmArrayRawBuffer*)(data_ - sizeof(WasmArrayRawBuffer));
}

#define ROUND_UP(v, a) ((v) % (a) == 0 ? (v) : v + a - ((v) % (a)))

/* static */ ArrayBufferObject*
ArrayBufferObject::createForWasm(JSContext* cx, uint32_t initialSize, Maybe<uint32_t> maxSize)
{
    MOZ_ASSERT(initialSize % wasm::PageSize == 0);
    MOZ_RELEASE_ASSERT(wasm::HaveSignalHandlers());

    // Prevent applications specifying a large max (like UINT32_MAX) from
    // unintentially OOMing the browser on 32-bit: they just want "a lot of
    // memory". Maintain the invariant that initialSize <= maxSize.
    if (sizeof(void*) == 4 && maxSize) {
        static const uint32_t OneGiB = 1 << 30;
        uint32_t clamp = Max(OneGiB, initialSize);
        maxSize = Some(Min(clamp, maxSize.value()));
    }

    RootedArrayBufferObject buffer(cx, ArrayBufferObject::createEmpty(cx));
    if (!buffer)
        return nullptr;

    // Try to reserve the maximum requested memory
    WasmArrayRawBuffer* wasmBuf = WasmArrayRawBuffer::Allocate(initialSize, maxSize);
    if (!wasmBuf) {
#ifdef  WASM_HUGE_MEMORY
        ReportOutOfMemory(cx);
        return nullptr;
#else
        // If we fail, and have a maxSize, try to reserve the biggest chunk in
        // the range [initialSize, maxSize) using log backoff.
        if (!maxSize) {
            ReportOutOfMemory(cx);
            return nullptr;
        }

        uint32_t cur = maxSize.value() / 2;

        for (; cur > initialSize; cur /= 2) {
            wasmBuf = WasmArrayRawBuffer::Allocate(initialSize, Some(ROUND_UP(cur, wasm::PageSize)));
            if (wasmBuf)
                break;
        }

        if (!wasmBuf) {
            ReportOutOfMemory(cx);
            return nullptr;
        }

        // Try to grow our chunk as much as possible.
        for (size_t d = cur / 2; d >= wasm::PageSize; d /= 2)
            wasmBuf->tryGrowMaxSizeInPlace(ROUND_UP(d, wasm::PageSize));
#endif
    }

    auto contents = BufferContents::create<WASM>(wasmBuf->dataPointer());
    buffer->initialize(initialSize, contents, OwnsData);
    cx->zone()->updateMallocCounter(wasmBuf->mappedSize());
    return buffer;
}

// Note this function can return false with or without an exception pending. The
// asm.js caller checks cx->isExceptionPending before propagating failure.
// Returning false without throwing means that asm.js linking will fail which
// will recompile as non-asm.js.
/* static */ bool
ArrayBufferObject::prepareForAsmJS(JSContext* cx, Handle<ArrayBufferObject*> buffer, bool needGuard)
{
#ifdef WASM_HUGE_MEMORY
    MOZ_ASSERT(needGuard);
#endif
    MOZ_ASSERT(buffer->byteLength() % wasm::PageSize == 0);
    MOZ_RELEASE_ASSERT(wasm::HaveSignalHandlers());

    if (buffer->forInlineTypedObject())
        return false;

    if (needGuard) {
        if (buffer->isWasm() && buffer->isPreparedForAsmJS())
            return true;

        // Non-prepared-for-asm.js wasm buffers can be detached at any time.
        // This error can only be triggered for SIMD.js (which isn't shipping)
        // on !WASM_HUGE_MEMORY so this error is only visible in testing.
        if (buffer->isWasm() || buffer->isPreparedForAsmJS())
            return false;

        uint32_t length = buffer->byteLength();
        WasmArrayRawBuffer* wasmBuf = WasmArrayRawBuffer::Allocate(length, Some(length));
        if (!wasmBuf) {
            ReportOutOfMemory(cx);
            return false;
        }

        void* data = wasmBuf->dataPointer();
        memcpy(data, buffer->dataPointer(), length);

        // Swap the new elements into the ArrayBufferObject. Mark the
        // ArrayBufferObject so we don't do this again.
        buffer->changeContents(cx, BufferContents::create<WASM>(data), OwnsData);
        buffer->setIsPreparedForAsmJS();
        MOZ_ASSERT(data == buffer->dataPointer());
        cx->zone()->updateMallocCounter(wasmBuf->mappedSize());
        return true;
    }

    if (!buffer->isWasm() && buffer->isPreparedForAsmJS())
        return true;

    // Non-prepared-for-asm.js wasm buffers can be detached at any time.
    if (buffer->isWasm())
        return false;

    if (!buffer->ownsData()) {
        BufferContents contents = AllocateArrayBufferContents(cx, buffer->byteLength());
        if (!contents)
            return false;
        memcpy(contents.data(), buffer->dataPointer(), buffer->byteLength());
        buffer->changeContents(cx, contents, OwnsData);
    }

    buffer->setIsPreparedForAsmJS();
    return true;
}

ArrayBufferObject::BufferContents
ArrayBufferObject::createMappedContents(int fd, size_t offset, size_t length)
{
    void* data = AllocateMappedContent(fd, offset, length, ARRAY_BUFFER_ALIGNMENT);
    MemProfiler::SampleNative(data, length);
    return BufferContents::create<MAPPED>(data);
}

uint8_t*
ArrayBufferObject::inlineDataPointer() const
{
    return static_cast<uint8_t*>(fixedData(JSCLASS_RESERVED_SLOTS(&class_)));
}

uint8_t*
ArrayBufferObject::dataPointer() const
{
    return static_cast<uint8_t*>(getSlot(DATA_SLOT).toPrivate());
}

SharedMem<uint8_t*>
ArrayBufferObject::dataPointerShared() const
{
    return SharedMem<uint8_t*>::unshared(getSlot(DATA_SLOT).toPrivate());
}

void
ArrayBufferObject::releaseData(FreeOp* fop)
{
    MOZ_ASSERT(ownsData());

    switch (bufferKind()) {
      case PLAIN:
        fop->free_(dataPointer());
        break;
      case MAPPED:
        MemProfiler::RemoveNative(dataPointer());
        DeallocateMappedContent(dataPointer(), byteLength());
        break;
      case WASM:
        WasmArrayRawBuffer::Release(dataPointer());
        break;
      case KIND_MASK:
        MOZ_CRASH("bad bufferKind()");
    }
}

void
ArrayBufferObject::setDataPointer(BufferContents contents, OwnsState ownsData)
{
    setSlot(DATA_SLOT, PrivateValue(contents.data()));
    setOwnsData(ownsData);
    setFlags((flags() & ~KIND_MASK) | contents.kind());
}

uint32_t
ArrayBufferObject::byteLength() const
{
    return getSlot(BYTE_LENGTH_SLOT).toInt32();
}

void
ArrayBufferObject::setByteLength(uint32_t length)
{
    MOZ_ASSERT(length <= INT32_MAX);
    setSlot(BYTE_LENGTH_SLOT, Int32Value(length));
}

size_t
ArrayBufferObject::wasmMappedSize() const
{
    if (isWasm())
        return contents().wasmBuffer()->mappedSize();
    return byteLength();
}

size_t
js::WasmArrayBufferMappedSize(const ArrayBufferObjectMaybeShared* buf)
{
    if (buf->is<ArrayBufferObject>())
        return buf->as<ArrayBufferObject>().wasmMappedSize();
#ifdef WASM_HUGE_MEMORY
    return wasm::HugeMappedSize;
#else
    return buf->as<SharedArrayBufferObject>().byteLength();
#endif
}

Maybe<uint32_t>
ArrayBufferObject::wasmMaxSize() const
{
    if (isWasm())
        return contents().wasmBuffer()->maxSize();
    else
        return Some<uint32_t>(byteLength());
}

Maybe<uint32_t>
js::WasmArrayBufferMaxSize(const ArrayBufferObjectMaybeShared* buf)
{
    if (buf->is<ArrayBufferObject>())
        return buf->as<ArrayBufferObject>().wasmMaxSize();

    return Some(buf->as<SharedArrayBufferObject>().byteLength());
}

/* static */ bool
ArrayBufferObject::wasmGrowToSizeInPlace(uint32_t newSize,
                                         HandleArrayBufferObject oldBuf,
                                         MutableHandleArrayBufferObject newBuf,
                                         JSContext* cx)
{
    // On failure, do not throw and ensure that the original buffer is
    // unmodified and valid. After WasmArrayRawBuffer::growToSizeInPlace(), the
    // wasm-visible length of the buffer has been increased so it must be the
    // last fallible operation.

    // byteLength can be at most INT32_MAX.
    if (newSize > INT32_MAX)
        return false;

    newBuf.set(ArrayBufferObject::createEmpty(cx));
    if (!newBuf) {
        cx->clearPendingException();
        return false;
    }

    if (!oldBuf->contents().wasmBuffer()->growToSizeInPlace(oldBuf->byteLength(), newSize))
        return false;

    bool hasStealableContents = true;
    BufferContents contents = ArrayBufferObject::stealContents(cx, oldBuf, hasStealableContents);
    MOZ_ASSERT(contents);
    newBuf->initialize(newSize, contents, OwnsData);
    return true;
}

#ifndef WASM_HUGE_MEMORY
/* static */ bool
ArrayBufferObject::wasmMovingGrowToSize(uint32_t newSize,
                                        HandleArrayBufferObject oldBuf,
                                        MutableHandleArrayBufferObject newBuf,
                                        JSContext* cx)
{
    // On failure, do not throw and ensure that the original buffer is
    // unmodified and valid.

    // byteLength can be at most INT32_MAX.
    if (newSize > INT32_MAX)
        return false;

    if (newSize <= oldBuf->wasmBoundsCheckLimit() ||
        oldBuf->contents().wasmBuffer()->extendMappedSize(newSize))
    {
        return wasmGrowToSizeInPlace(newSize, oldBuf, newBuf, cx);
    }

    newBuf.set(ArrayBufferObject::createEmpty(cx));
    if (!newBuf) {
        cx->clearPendingException();
        return false;
    }

    WasmArrayRawBuffer* newRawBuf = WasmArrayRawBuffer::Allocate(newSize, Nothing());
    if (!newRawBuf)
        return false;
    BufferContents contents = BufferContents::create<WASM>(newRawBuf->dataPointer());
    newBuf->initialize(newSize, contents, OwnsData);

    memcpy(newBuf->dataPointer(), oldBuf->dataPointer(), oldBuf->byteLength());
    ArrayBufferObject::detach(cx, oldBuf, BufferContents::createPlain(nullptr));
    return true;
}

uint32_t
ArrayBufferObject::wasmBoundsCheckLimit() const
{
    if (isWasm())
        return contents().wasmBuffer()->boundsCheckLimit();
    else
        return byteLength();
}

uint32_t
ArrayBufferObjectMaybeShared::wasmBoundsCheckLimit() const
{
    if (is<ArrayBufferObject>())
        return as<ArrayBufferObject>().wasmBoundsCheckLimit();

    return as<SharedArrayBufferObject>().byteLength();
}
#endif

uint32_t
ArrayBufferObject::flags() const
{
    return uint32_t(getSlot(FLAGS_SLOT).toInt32());
}

void
ArrayBufferObject::setFlags(uint32_t flags)
{
    setSlot(FLAGS_SLOT, Int32Value(flags));
}

ArrayBufferObject*
ArrayBufferObject::create(JSContext* cx, uint32_t nbytes, BufferContents contents,
                          OwnsState ownsState /* = OwnsData */,
                          HandleObject proto /* = nullptr */,
                          NewObjectKind newKind /* = GenericObject */)
{
    MOZ_ASSERT_IF(contents.kind() == MAPPED, contents);

    // 24.1.1.1, step 3 (Inlined 6.2.6.1 CreateByteDataBlock, step 2).
    // Refuse to allocate too large buffers, currently limited to ~2 GiB.
    if (nbytes > INT32_MAX) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_BAD_ARRAY_LENGTH);
        return nullptr;
    }

    // If we need to allocate data, try to use a larger object size class so
    // that the array buffer's data can be allocated inline with the object.
    // The extra space will be left unused by the object's fixed slots and
    // available for the buffer's data, see NewObject().
    size_t reservedSlots = JSCLASS_RESERVED_SLOTS(&class_);

    size_t nslots = reservedSlots;
    bool allocated = false;
    if (contents) {
        if (ownsState == OwnsData) {
            // The ABO is taking ownership, so account the bytes against the zone.
            size_t nAllocated = nbytes;
            if (contents.kind() == MAPPED)
                nAllocated = JS_ROUNDUP(nbytes, js::gc::SystemPageSize());
            else if (contents.kind() == WASM)
                nAllocated = contents.wasmBuffer()->allocatedBytes();
            cx->zone()->updateMallocCounter(nAllocated);
        }
    } else {
        MOZ_ASSERT(ownsState == OwnsData);
        size_t usableSlots = NativeObject::MAX_FIXED_SLOTS - reservedSlots;
        if (nbytes <= usableSlots * sizeof(Value)) {
            int newSlots = (nbytes - 1) / sizeof(Value) + 1;
            MOZ_ASSERT(int(nbytes) <= newSlots * int(sizeof(Value)));
            nslots = reservedSlots + newSlots;
            contents = BufferContents::createPlain(nullptr);
        } else {
            contents = AllocateArrayBufferContents(cx, nbytes);
            if (!contents)
                return nullptr;
            allocated = true;
        }
    }

    MOZ_ASSERT(!(class_.flags & JSCLASS_HAS_PRIVATE));
    gc::AllocKind allocKind = GetGCObjectKind(nslots);

    AutoSetNewObjectMetadata metadata(cx);
    Rooted<ArrayBufferObject*> obj(cx,
        NewObjectWithClassProto<ArrayBufferObject>(cx, proto, allocKind, newKind));
    if (!obj) {
        if (allocated)
            js_free(contents.data());
        return nullptr;
    }

    MOZ_ASSERT(obj->getClass() == &class_);
    MOZ_ASSERT(!gc::IsInsideNursery(obj));

    if (!contents) {
        void* data = obj->inlineDataPointer();
        memset(data, 0, nbytes);
        obj->initialize(nbytes, BufferContents::createPlain(data), DoesntOwnData);
    } else {
        obj->initialize(nbytes, contents, ownsState);
    }

    return obj;
}

ArrayBufferObject*
ArrayBufferObject::create(JSContext* cx, uint32_t nbytes,
                          HandleObject proto /* = nullptr */,
                          NewObjectKind newKind /* = GenericObject */)
{
    return create(cx, nbytes, BufferContents::createPlain(nullptr),
                  OwnsState::OwnsData, proto);
}

ArrayBufferObject*
ArrayBufferObject::createEmpty(JSContext* cx)
{
    AutoSetNewObjectMetadata metadata(cx);
    ArrayBufferObject* obj = NewObjectWithClassProto<ArrayBufferObject>(cx, nullptr);
    if (!obj)
        return nullptr;

    obj->initEmpty();
    return obj;
}

bool
ArrayBufferObject::createDataViewForThisImpl(JSContext* cx, const CallArgs& args)
{
    MOZ_ASSERT(IsArrayBuffer(args.thisv()));

    /*
     * This method is only called for |DataView(alienBuf, ...)| which calls
     * this as |createDataViewForThis.call(alienBuf, byteOffset, byteLength,
     *                                     DataView.prototype)|,
     * ergo there must be exactly 3 arguments.
     */
    MOZ_ASSERT(args.length() == 3);

    uint32_t byteOffset = args[0].toPrivateUint32();
    uint32_t byteLength = args[1].toPrivateUint32();
    Rooted<ArrayBufferObject*> buffer(cx, &args.thisv().toObject().as<ArrayBufferObject>());

    /*
     * Pop off the passed-along prototype and delegate to normal DataViewObject
     * construction.
     */
    JSObject* obj = DataViewObject::create(cx, byteOffset, byteLength, buffer, &args[2].toObject());
    if (!obj)
        return false;
    args.rval().setObject(*obj);
    return true;
}

bool
ArrayBufferObject::createDataViewForThis(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return CallNonGenericMethod<IsArrayBuffer, createDataViewForThisImpl>(cx, args);
}

/* static */ ArrayBufferObject::BufferContents
ArrayBufferObject::externalizeContents(JSContext* cx, Handle<ArrayBufferObject*> buffer,
                                       bool hasStealableContents)
{
    MOZ_ASSERT(buffer->isPlain(), "Only support doing this on plain ABOs");
    MOZ_ASSERT(!buffer->isDetached(), "must have contents to externalize");
    MOZ_ASSERT_IF(hasStealableContents, buffer->hasStealableContents());

    BufferContents contents(buffer->dataPointer(), buffer->bufferKind());

    if (hasStealableContents) {
        buffer->setOwnsData(DoesntOwnData);
        return contents;
    }

    // Create a new chunk of memory to return since we cannot steal the
    // existing contents away from the buffer.
    BufferContents newContents = AllocateArrayBufferContents(cx, buffer->byteLength());
    if (!newContents)
        return BufferContents::createPlain(nullptr);
    memcpy(newContents.data(), contents.data(), buffer->byteLength());
    buffer->changeContents(cx, newContents, DoesntOwnData);

    return newContents;
}

/* static */ ArrayBufferObject::BufferContents
ArrayBufferObject::stealContents(JSContext* cx, Handle<ArrayBufferObject*> buffer,
                                 bool hasStealableContents)
{
    // While wasm buffers cannot generally be transferred by content, the
    // stealContents() is used internally by the impl of memory growth.
    MOZ_ASSERT_IF(hasStealableContents, buffer->hasStealableContents() ||
                                        (buffer->isWasm() && !buffer->isPreparedForAsmJS()));
    assertSameCompartment(cx, buffer);

    BufferContents oldContents(buffer->dataPointer(), buffer->bufferKind());

    if (hasStealableContents) {
        // Return the old contents and reset the detached buffer's data
        // pointer. This pointer should never be accessed.
        auto newContents = BufferContents::createPlain(nullptr);
        buffer->setOwnsData(DoesntOwnData); // Do not free the stolen data.
        ArrayBufferObject::detach(cx, buffer, newContents);
        buffer->setOwnsData(DoesntOwnData); // Do not free the nullptr.
        return oldContents;
    }

    // Create a new chunk of memory to return since we cannot steal the
    // existing contents away from the buffer.
    BufferContents contentsCopy = AllocateArrayBufferContents(cx, buffer->byteLength());
    if (!contentsCopy)
        return BufferContents::createPlain(nullptr);

    if (buffer->byteLength() > 0)
        memcpy(contentsCopy.data(), oldContents.data(), buffer->byteLength());
    ArrayBufferObject::detach(cx, buffer, oldContents);
    return contentsCopy;
}

/* static */ void
ArrayBufferObject::addSizeOfExcludingThis(JSObject* obj, mozilla::MallocSizeOf mallocSizeOf,
                                          JS::ClassInfo* info)
{
    ArrayBufferObject& buffer = AsArrayBuffer(obj);

    if (!buffer.ownsData())
        return;

    switch (buffer.bufferKind()) {
      case PLAIN:
        if (buffer.isPreparedForAsmJS())
            info->objectsMallocHeapElementsAsmJS += mallocSizeOf(buffer.dataPointer());
        else
            info->objectsMallocHeapElementsNormal += mallocSizeOf(buffer.dataPointer());
        break;
      case MAPPED:
        info->objectsNonHeapElementsNormal += buffer.byteLength();
        break;
      case WASM:
        info->objectsNonHeapElementsWasm += buffer.byteLength();
        MOZ_ASSERT(buffer.wasmMappedSize() >= buffer.byteLength());
        info->wasmGuardPages += buffer.wasmMappedSize() - buffer.byteLength();
        break;
      case KIND_MASK:
        MOZ_CRASH("bad bufferKind()");
    }
}

/* static */ void
ArrayBufferObject::finalize(FreeOp* fop, JSObject* obj)
{
    ArrayBufferObject& buffer = obj->as<ArrayBufferObject>();

    if (buffer.ownsData())
        buffer.releaseData(fop);
}

/* static */ void
ArrayBufferObject::copyData(Handle<ArrayBufferObject*> toBuffer,
                            Handle<ArrayBufferObject*> fromBuffer,
                            uint32_t fromIndex, uint32_t count)
{
    MOZ_ASSERT(toBuffer->byteLength() >= count);
    MOZ_ASSERT(fromBuffer->byteLength() >= fromIndex);
    MOZ_ASSERT(fromBuffer->byteLength() >= fromIndex + count);

    memcpy(toBuffer->dataPointer(), fromBuffer->dataPointer() + fromIndex, count);
}

/* static */ void
ArrayBufferObject::trace(JSTracer* trc, JSObject* obj)
{
    // If this buffer is associated with an inline typed object,
    // fix up the data pointer if the typed object was moved.
    ArrayBufferObject& buf = obj->as<ArrayBufferObject>();

    if (!buf.forInlineTypedObject())
        return;

    JSObject* view = MaybeForwarded(buf.firstView());
    MOZ_ASSERT(view && view->is<InlineTransparentTypedObject>());

    TraceManuallyBarrieredEdge(trc, &view, "array buffer inline typed object owner");
    buf.setSlot(DATA_SLOT, PrivateValue(view->as<InlineTransparentTypedObject>().inlineTypedMem()));
}

/* static */ void
ArrayBufferObject::objectMoved(JSObject* obj, const JSObject* old)
{
    ArrayBufferObject& dst = obj->as<ArrayBufferObject>();
    const ArrayBufferObject& src = old->as<ArrayBufferObject>();

    // Fix up possible inline data pointer.
    if (src.hasInlineData())
        dst.setSlot(DATA_SLOT, PrivateValue(dst.inlineDataPointer()));
}

ArrayBufferViewObject*
ArrayBufferObject::firstView()
{
    return getSlot(FIRST_VIEW_SLOT).isObject()
        ? static_cast<ArrayBufferViewObject*>(&getSlot(FIRST_VIEW_SLOT).toObject())
        : nullptr;
}

void
ArrayBufferObject::setFirstView(ArrayBufferViewObject* view)
{
    setSlot(FIRST_VIEW_SLOT, ObjectOrNullValue(view));
}

bool
ArrayBufferObject::addView(JSContext* cx, JSObject* viewArg)
{
    // Note: we don't pass in an ArrayBufferViewObject as the argument due to
    // tricky inheritance in the various view classes. View classes do not
    // inherit from ArrayBufferViewObject so won't be upcast automatically.
    MOZ_ASSERT(viewArg->is<ArrayBufferViewObject>() || viewArg->is<TypedObject>());
    ArrayBufferViewObject* view = static_cast<ArrayBufferViewObject*>(viewArg);

    if (!firstView()) {
        setFirstView(view);
        return true;
    }
    return cx->compartment()->innerViews.get().addView(cx, this, view);
}

/*
 * InnerViewTable
 */

static size_t VIEW_LIST_MAX_LENGTH = 500;

bool
InnerViewTable::addView(JSContext* cx, ArrayBufferObject* buffer, ArrayBufferViewObject* view)
{
    // ArrayBufferObject entries are only added when there are multiple views.
    MOZ_ASSERT(buffer->firstView());

    if (!map.initialized() && !map.init()) {
        ReportOutOfMemory(cx);
        return false;
    }

    Map::AddPtr p = map.lookupForAdd(buffer);

    MOZ_ASSERT(!gc::IsInsideNursery(buffer));
    bool addToNursery = nurseryKeysValid && gc::IsInsideNursery(view);

    if (p) {
        ViewVector& views = p->value();
        MOZ_ASSERT(!views.empty());

        if (addToNursery) {
            // Only add the entry to |nurseryKeys| if it isn't already there.
            if (views.length() >= VIEW_LIST_MAX_LENGTH) {
                // To avoid quadratic blowup, skip the loop below if we end up
                // adding enormous numbers of views for the same object.
                nurseryKeysValid = false;
            } else {
                for (size_t i = 0; i < views.length(); i++) {
                    if (gc::IsInsideNursery(views[i])) {
                        addToNursery = false;
                        break;
                    }
                }
            }
        }

        if (!views.append(view)) {
            ReportOutOfMemory(cx);
            return false;
        }
    } else {
        if (!map.add(p, buffer, ViewVector())) {
            ReportOutOfMemory(cx);
            return false;
        }
        // ViewVector has one inline element, so the first insertion is
        // guaranteed to succeed.
        MOZ_ALWAYS_TRUE(p->value().append(view));
    }

    if (addToNursery && !nurseryKeys.append(buffer))
        nurseryKeysValid = false;

    return true;
}

InnerViewTable::ViewVector*
InnerViewTable::maybeViewsUnbarriered(ArrayBufferObject* buffer)
{
    if (!map.initialized())
        return nullptr;

    Map::Ptr p = map.lookup(buffer);
    if (p)
        return &p->value();
    return nullptr;
}

void
InnerViewTable::removeViews(ArrayBufferObject* buffer)
{
    Map::Ptr p = map.lookup(buffer);
    MOZ_ASSERT(p);

    map.remove(p);
}

/* static */ bool
InnerViewTable::sweepEntry(JSObject** pkey, ViewVector& views)
{
    if (IsAboutToBeFinalizedUnbarriered(pkey))
        return true;

    MOZ_ASSERT(!views.empty());
    for (size_t i = 0; i < views.length(); i++) {
        if (IsAboutToBeFinalizedUnbarriered(&views[i])) {
            views[i--] = views.back();
            views.popBack();
        }
    }

    return views.empty();
}

void
InnerViewTable::sweep()
{
    MOZ_ASSERT(nurseryKeys.empty());
    map.sweep();
}

void
InnerViewTable::sweepAfterMinorGC()
{
    MOZ_ASSERT(needsSweepAfterMinorGC());

    if (nurseryKeysValid) {
        for (size_t i = 0; i < nurseryKeys.length(); i++) {
            JSObject* buffer = MaybeForwarded(nurseryKeys[i]);
            Map::Ptr p = map.lookup(buffer);
            if (!p)
                continue;

            if (sweepEntry(&p->mutableKey(), p->value()))
                map.remove(buffer);
        }
        nurseryKeys.clear();
    } else {
        // Do the required sweeping by looking at every map entry.
        nurseryKeys.clear();
        sweep();

        nurseryKeysValid = true;
    }
}

size_t
InnerViewTable::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf)
{
    if (!map.initialized())
        return 0;

    size_t vectorSize = 0;
    for (Map::Enum e(map); !e.empty(); e.popFront())
        vectorSize += e.front().value().sizeOfExcludingThis(mallocSizeOf);

    return vectorSize
         + map.sizeOfExcludingThis(mallocSizeOf)
         + nurseryKeys.sizeOfExcludingThis(mallocSizeOf);
}

/*
 * ArrayBufferViewObject
 */

/*
 * This method is used to trace TypedArrayObjects and DataViewObjects. We need
 * a custom tracer to move the object's data pointer if its owner was moved and
 * stores its data inline.
 */
/* static */ void
ArrayBufferViewObject::trace(JSTracer* trc, JSObject* objArg)
{
    NativeObject* obj = &objArg->as<NativeObject>();
    HeapSlot& bufSlot = obj->getFixedSlotRef(TypedArrayObject::BUFFER_SLOT);
    TraceEdge(trc, &bufSlot, "typedarray.buffer");

    // Update obj's data pointer if it moved.
    if (bufSlot.isObject()) {
        if (IsArrayBuffer(&bufSlot.toObject())) {
            ArrayBufferObject& buf = AsArrayBuffer(MaybeForwarded(&bufSlot.toObject()));
            uint32_t offset = uint32_t(obj->getFixedSlot(TypedArrayObject::BYTEOFFSET_SLOT).toInt32());
            MOZ_ASSERT(offset <= INT32_MAX);

            if (buf.forInlineTypedObject()) {
                MOZ_ASSERT(buf.dataPointer() != nullptr);

                // The data is inline with an InlineTypedObject associated with the
                // buffer. Get a new address for the typed object if it moved.
                JSObject* view = buf.firstView();

                // Mark the object to move it into the tenured space.
                TraceManuallyBarrieredEdge(trc, &view, "typed array nursery owner");
                MOZ_ASSERT(view->is<InlineTypedObject>());
                MOZ_ASSERT(view != obj);

                void* srcData = obj->getPrivate();
                void* dstData = view->as<InlineTypedObject>().inlineTypedMemForGC() + offset;
                obj->setPrivateUnbarriered(dstData);

                // We can't use a direct forwarding pointer here, as there might
                // not be enough bytes available, and other views might have data
                // pointers whose forwarding pointers would overlap this one.
                trc->runtime()->gc.nursery.maybeSetForwardingPointer(trc, srcData, dstData,
                                                                     /* direct = */ false);
            } else {
                MOZ_ASSERT_IF(buf.dataPointer() == nullptr, offset == 0);

                // The data may or may not be inline with the buffer. The buffer
                // can only move during a compacting GC, in which case its
                // objectMoved hook has already updated the buffer's data pointer.
                obj->initPrivate(buf.dataPointer() + offset);
            }
        }
    }
}

template <>
bool
JSObject::is<js::ArrayBufferViewObject>() const
{
    return is<DataViewObject>() || is<TypedArrayObject>();
}

template <>
bool
JSObject::is<js::ArrayBufferObjectMaybeShared>() const
{
    return is<ArrayBufferObject>() || is<SharedArrayBufferObject>();
}

void
ArrayBufferViewObject::notifyBufferDetached(JSContext* cx, void* newData)
{
    if (is<DataViewObject>()) {
        as<DataViewObject>().notifyBufferDetached(newData);
    } else if (is<TypedArrayObject>()) {
        if (as<TypedArrayObject>().isSharedMemory())
            return;
        as<TypedArrayObject>().notifyBufferDetached(cx, newData);
    } else {
        as<OutlineTypedObject>().notifyBufferDetached(newData);
    }
}

uint8_t*
ArrayBufferViewObject::dataPointerUnshared(const JS::AutoRequireNoGC& nogc)
{
    if (is<DataViewObject>())
        return static_cast<uint8_t*>(as<DataViewObject>().dataPointer());
    if (is<TypedArrayObject>()) {
        MOZ_ASSERT(!as<TypedArrayObject>().isSharedMemory());
        return static_cast<uint8_t*>(as<TypedArrayObject>().viewDataUnshared());
    }
    return as<TypedObject>().typedMem(nogc);
}

#ifdef DEBUG
bool
ArrayBufferViewObject::isSharedMemory()
{
    if (is<TypedArrayObject>())
        return as<TypedArrayObject>().isSharedMemory();
    return false;
}
#endif

void
ArrayBufferViewObject::setDataPointerUnshared(uint8_t* data)
{
    if (is<DataViewObject>()) {
        as<DataViewObject>().setPrivate(data);
    } else if (is<TypedArrayObject>()) {
        MOZ_ASSERT(!as<TypedArrayObject>().isSharedMemory());
        as<TypedArrayObject>().setPrivate(data);
    } else if (is<OutlineTypedObject>()) {
        as<OutlineTypedObject>().setData(data);
    } else {
        MOZ_CRASH();
    }
}

/* static */ ArrayBufferObjectMaybeShared*
ArrayBufferViewObject::bufferObject(JSContext* cx, Handle<ArrayBufferViewObject*> thisObject)
{
    if (thisObject->is<TypedArrayObject>()) {
        Rooted<TypedArrayObject*> typedArray(cx, &thisObject->as<TypedArrayObject>());
        if (!TypedArrayObject::ensureHasBuffer(cx, typedArray))
            return nullptr;
        return thisObject->as<TypedArrayObject>().bufferEither();
    }
    MOZ_ASSERT(thisObject->is<DataViewObject>());
    return &thisObject->as<DataViewObject>().arrayBuffer();
}

/* JS Friend API */

JS_FRIEND_API(bool)
JS_IsArrayBufferViewObject(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    return obj && obj->is<ArrayBufferViewObject>();
}

JS_FRIEND_API(JSObject*)
js::UnwrapArrayBufferView(JSObject* obj)
{
    if (JSObject* unwrapped = CheckedUnwrap(obj))
        return unwrapped->is<ArrayBufferViewObject>() ? unwrapped : nullptr;
    return nullptr;
}

JS_FRIEND_API(uint32_t)
JS_GetArrayBufferByteLength(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    return obj ? AsArrayBuffer(obj).byteLength() : 0;
}

JS_FRIEND_API(uint8_t*)
JS_GetArrayBufferData(JSObject* obj, bool* isSharedMemory, const JS::AutoCheckCannotGC&)
{
    obj = CheckedUnwrap(obj);
    if (!obj)
        return nullptr;
    if (!IsArrayBuffer(obj))
        return nullptr;
    *isSharedMemory = false;
    return AsArrayBuffer(obj).dataPointer();
}

JS_FRIEND_API(bool)
JS_DetachArrayBuffer(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    if (!obj->is<ArrayBufferObject>()) {
        JS_ReportErrorASCII(cx, "ArrayBuffer object required");
        return false;
    }

    Rooted<ArrayBufferObject*> buffer(cx, &obj->as<ArrayBufferObject>());

    if (buffer->isWasm() || buffer->isPreparedForAsmJS()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_WASM_NO_TRANSFER);
        return false;
    }

    ArrayBufferObject::BufferContents newContents =
        buffer->hasStealableContents() ? ArrayBufferObject::BufferContents::createPlain(nullptr)
                                       : buffer->contents();

    ArrayBufferObject::detach(cx, buffer, newContents);

    return true;
}

JS_FRIEND_API(bool)
JS_IsDetachedArrayBufferObject(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    if (!obj)
        return false;

    return obj->is<ArrayBufferObject>() && obj->as<ArrayBufferObject>().isDetached();
}

JS_FRIEND_API(JSObject*)
JS_NewArrayBuffer(JSContext* cx, uint32_t nbytes)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT(nbytes <= INT32_MAX);
    return ArrayBufferObject::create(cx, nbytes);
}

JS_PUBLIC_API(JSObject*)
JS_NewArrayBufferWithContents(JSContext* cx, size_t nbytes, void* data)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT_IF(!data, nbytes == 0);
    ArrayBufferObject::BufferContents contents =
        ArrayBufferObject::BufferContents::create<ArrayBufferObject::PLAIN>(data);
    return ArrayBufferObject::create(cx, nbytes, contents, ArrayBufferObject::OwnsData,
                                     /* proto = */ nullptr, TenuredObject);
}

JS_PUBLIC_API(JSObject*)
JS_NewArrayBufferWithExternalContents(JSContext* cx, size_t nbytes, void* data)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    MOZ_ASSERT_IF(!data, nbytes == 0);
    ArrayBufferObject::BufferContents contents =
        ArrayBufferObject::BufferContents::create<ArrayBufferObject::PLAIN>(data);
    return ArrayBufferObject::create(cx, nbytes, contents, ArrayBufferObject::DoesntOwnData,
                                     /* proto = */ nullptr, TenuredObject);
}

JS_FRIEND_API(bool)
JS_IsArrayBufferObject(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    return obj && obj->is<ArrayBufferObject>();
}

JS_FRIEND_API(bool)
JS_ArrayBufferHasData(JSObject* obj)
{
    return CheckedUnwrap(obj)->as<ArrayBufferObject>().hasData();
}

JS_FRIEND_API(JSObject*)
js::UnwrapArrayBuffer(JSObject* obj)
{
    if (JSObject* unwrapped = CheckedUnwrap(obj))
        return unwrapped->is<ArrayBufferObject>() ? unwrapped : nullptr;
    return nullptr;
}

JS_FRIEND_API(JSObject*)
js::UnwrapSharedArrayBuffer(JSObject* obj)
{
    if (JSObject* unwrapped = CheckedUnwrap(obj))
        return unwrapped->is<SharedArrayBufferObject>() ? unwrapped : nullptr;
    return nullptr;
}

JS_PUBLIC_API(void*)
JS_ExternalizeArrayBufferContents(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, obj);

    if (!obj->is<ArrayBufferObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_TYPED_ARRAY_BAD_ARGS);
        return nullptr;
    }

    Handle<ArrayBufferObject*> buffer = obj.as<ArrayBufferObject>();
    if (!buffer->isPlain()) {
        // This operation isn't supported on mapped or wsm ArrayBufferObjects.
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_TYPED_ARRAY_BAD_ARGS);
        return nullptr;
    }
    if (buffer->isDetached()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_TYPED_ARRAY_DETACHED);
        return nullptr;
    }

    // The caller assumes that a plain malloc'd buffer is returned.
    // hasStealableContents is true for mapped buffers, so we must additionally
    // require that the buffer is plain. In the future, we could consider
    // returning something that handles releasing the memory.
    bool hasStealableContents = buffer->hasStealableContents();

    return ArrayBufferObject::externalizeContents(cx, buffer, hasStealableContents).data();
}

JS_PUBLIC_API(void*)
JS_StealArrayBufferContents(JSContext* cx, HandleObject objArg)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, objArg);

    JSObject* obj = CheckedUnwrap(objArg);
    if (!obj)
        return nullptr;

    if (!obj->is<ArrayBufferObject>()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_TYPED_ARRAY_BAD_ARGS);
        return nullptr;
    }

    Rooted<ArrayBufferObject*> buffer(cx, &obj->as<ArrayBufferObject>());
    if (buffer->isDetached()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_TYPED_ARRAY_DETACHED);
        return nullptr;
    }

    if (buffer->isWasm() || buffer->isPreparedForAsmJS()) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_WASM_NO_TRANSFER);
        return nullptr;
    }

    // The caller assumes that a plain malloc'd buffer is returned.
    // hasStealableContents is true for mapped buffers, so we must additionally
    // require that the buffer is plain. In the future, we could consider
    // returning something that handles releasing the memory.
    bool hasStealableContents = buffer->hasStealableContents() && buffer->isPlain();

    AutoCompartment ac(cx, buffer);
    return ArrayBufferObject::stealContents(cx, buffer, hasStealableContents).data();
}

JS_PUBLIC_API(JSObject*)
JS_NewMappedArrayBufferWithContents(JSContext* cx, size_t nbytes, void* data)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);

    MOZ_ASSERT(data);
    ArrayBufferObject::BufferContents contents =
        ArrayBufferObject::BufferContents::create<ArrayBufferObject::MAPPED>(data);
    return ArrayBufferObject::create(cx, nbytes, contents, ArrayBufferObject::OwnsData,
                                     /* proto = */ nullptr, TenuredObject);
}

JS_PUBLIC_API(void*)
JS_CreateMappedArrayBufferContents(int fd, size_t offset, size_t length)
{
    return ArrayBufferObject::createMappedContents(fd, offset, length).data();
}

JS_PUBLIC_API(void)
JS_ReleaseMappedArrayBufferContents(void* contents, size_t length)
{
    MemProfiler::RemoveNative(contents);
    DeallocateMappedContent(contents, length);
}

JS_FRIEND_API(bool)
JS_IsMappedArrayBufferObject(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    if (!obj)
        return false;

    return obj->is<ArrayBufferObject>() && obj->as<ArrayBufferObject>().isMapped();
}

JS_FRIEND_API(void*)
JS_GetArrayBufferViewData(JSObject* obj, bool* isSharedMemory, const JS::AutoCheckCannotGC&)
{
    obj = CheckedUnwrap(obj);
    if (!obj)
        return nullptr;
    if (obj->is<DataViewObject>()) {
        *isSharedMemory = false;
        return obj->as<DataViewObject>().dataPointer();
    }
    TypedArrayObject& ta = obj->as<TypedArrayObject>();
    *isSharedMemory = ta.isSharedMemory();
    return ta.viewDataEither().unwrap(/*safe - caller sees isShared flag*/);
}

JS_FRIEND_API(JSObject*)
JS_GetArrayBufferViewBuffer(JSContext* cx, HandleObject objArg, bool* isSharedMemory)
{
    AssertHeapIsIdle(cx);
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, objArg);

    JSObject* obj = CheckedUnwrap(objArg);
    if (!obj)
        return nullptr;
    MOZ_ASSERT(obj->is<ArrayBufferViewObject>());

    Rooted<ArrayBufferViewObject*> viewObject(cx, static_cast<ArrayBufferViewObject*>(obj));
    ArrayBufferObjectMaybeShared* buffer = ArrayBufferViewObject::bufferObject(cx, viewObject);
    *isSharedMemory = buffer->is<SharedArrayBufferObject>();
    return buffer;
}

JS_FRIEND_API(uint32_t)
JS_GetArrayBufferViewByteLength(JSObject* obj)
{
    obj = CheckedUnwrap(obj);
    if (!obj)
        return 0;
    return obj->is<DataViewObject>()
           ? obj->as<DataViewObject>().byteLength()
           : obj->as<TypedArrayObject>().byteLength();
}

JS_FRIEND_API(JSObject*)
JS_GetObjectAsArrayBufferView(JSObject* obj, uint32_t* length, bool* isSharedMemory, uint8_t** data)
{
    if (!(obj = CheckedUnwrap(obj)))
        return nullptr;
    if (!(obj->is<ArrayBufferViewObject>()))
        return nullptr;

    js::GetArrayBufferViewLengthAndData(obj, length, isSharedMemory, data);
    return obj;
}

JS_FRIEND_API(void)
js::GetArrayBufferViewLengthAndData(JSObject* obj, uint32_t* length, bool* isSharedMemory, uint8_t** data)
{
    MOZ_ASSERT(obj->is<ArrayBufferViewObject>());

    *length = obj->is<DataViewObject>()
              ? obj->as<DataViewObject>().byteLength()
              : obj->as<TypedArrayObject>().byteLength();

    if (obj->is<DataViewObject>()) {
        *isSharedMemory = false;
        *data = static_cast<uint8_t*>(obj->as<DataViewObject>().dataPointer());
    }
    else {
        TypedArrayObject& ta = obj->as<TypedArrayObject>();
        *isSharedMemory = ta.isSharedMemory();
        *data = static_cast<uint8_t*>(ta.viewDataEither().unwrap(/*safe - caller sees isShared flag*/));
    }
}

JS_FRIEND_API(JSObject*)
JS_GetObjectAsArrayBuffer(JSObject* obj, uint32_t* length, uint8_t** data)
{
    if (!(obj = CheckedUnwrap(obj)))
        return nullptr;
    if (!IsArrayBuffer(obj))
        return nullptr;

    *length = AsArrayBuffer(obj).byteLength();
    *data = AsArrayBuffer(obj).dataPointer();

    return obj;
}

JS_FRIEND_API(void)
js::GetArrayBufferLengthAndData(JSObject* obj, uint32_t* length, bool* isSharedMemory, uint8_t** data)
{
    MOZ_ASSERT(IsArrayBuffer(obj));
    *length = AsArrayBuffer(obj).byteLength();
    *data = AsArrayBuffer(obj).dataPointer();
    *isSharedMemory = false;
}
