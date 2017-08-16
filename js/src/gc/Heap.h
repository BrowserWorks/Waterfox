/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef gc_Heap_h
#define gc_Heap_h

#include "mozilla/ArrayUtils.h"
#include "mozilla/Atomics.h"
#include "mozilla/Attributes.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/EnumeratedArray.h"
#include "mozilla/EnumeratedRange.h"
#include "mozilla/PodOperations.h"

#include <stddef.h>
#include <stdint.h>

#include "jsfriendapi.h"
#include "jspubtd.h"
#include "jstypes.h"
#include "jsutil.h"

#include "ds/BitArray.h"
#include "gc/Memory.h"
#include "js/GCAPI.h"
#include "js/HeapAPI.h"
#include "js/RootingAPI.h"
#include "js/TracingAPI.h"

struct JSRuntime;

namespace js {

class AutoLockGC;
class FreeOp;

extern bool
RuntimeFromActiveCooperatingThreadIsHeapMajorCollecting(JS::shadow::Zone* shadowZone);

#ifdef DEBUG

// Barriers can't be triggered during backend Ion compilation, which may run on
// a helper thread.
extern bool
CurrentThreadIsIonCompiling();
#endif

// The return value indicates if anything was unmarked.
extern bool
UnmarkGrayCellRecursively(gc::Cell* cell, JS::TraceKind kind);

extern void
TraceManuallyBarrieredGenericPointerEdge(JSTracer* trc, gc::Cell** thingp, const char* name);

namespace gc {

class Arena;
class ArenaCellSet;
class ArenaList;
class SortedArenaList;
struct Chunk;

/*
 * This flag allows an allocation site to request a specific heap based upon the
 * estimated lifetime or lifetime requirements of objects allocated from that
 * site.
 */
enum InitialHeap {
    DefaultHeap,
    TenuredHeap
};

/* The GC allocation kinds. */
// FIXME: uint8_t would make more sense for the underlying type, but causes
// miscompilations in GCC (fixed in 4.8.5 and 4.9.3). See also bug 1143966.
enum class AllocKind {
    FIRST,
    OBJECT_FIRST = FIRST,
    FUNCTION = FIRST,
    FUNCTION_EXTENDED,
    OBJECT0,
    OBJECT0_BACKGROUND,
    OBJECT2,
    OBJECT2_BACKGROUND,
    OBJECT4,
    OBJECT4_BACKGROUND,
    OBJECT8,
    OBJECT8_BACKGROUND,
    OBJECT12,
    OBJECT12_BACKGROUND,
    OBJECT16,
    OBJECT16_BACKGROUND,
    OBJECT_LIMIT,
    OBJECT_LAST = OBJECT_LIMIT - 1,
    SCRIPT,
    LAZY_SCRIPT,
    SHAPE,
    ACCESSOR_SHAPE,
    BASE_SHAPE,
    OBJECT_GROUP,
    FAT_INLINE_STRING,
    STRING,
    EXTERNAL_STRING,
    FAT_INLINE_ATOM,
    ATOM,
    SYMBOL,
    JITCODE,
    SCOPE,
    REGEXP_SHARED,
    LIMIT,
    LAST = LIMIT - 1
};

// Macro to enumerate the different allocation kinds supplying information about
// the trace kind, C++ type and allocation size.
#define FOR_EACH_OBJECT_ALLOCKIND(D) \
 /* AllocKind              TraceKind      TypeName           SizedType */ \
    D(FUNCTION,            Object,        JSObject,          JSFunction) \
    D(FUNCTION_EXTENDED,   Object,        JSObject,          FunctionExtended) \
    D(OBJECT0,             Object,        JSObject,          JSObject_Slots0) \
    D(OBJECT0_BACKGROUND,  Object,        JSObject,          JSObject_Slots0) \
    D(OBJECT2,             Object,        JSObject,          JSObject_Slots2) \
    D(OBJECT2_BACKGROUND,  Object,        JSObject,          JSObject_Slots2) \
    D(OBJECT4,             Object,        JSObject,          JSObject_Slots4) \
    D(OBJECT4_BACKGROUND,  Object,        JSObject,          JSObject_Slots4) \
    D(OBJECT8,             Object,        JSObject,          JSObject_Slots8) \
    D(OBJECT8_BACKGROUND,  Object,        JSObject,          JSObject_Slots8) \
    D(OBJECT12,            Object,        JSObject,          JSObject_Slots12) \
    D(OBJECT12_BACKGROUND, Object,        JSObject,          JSObject_Slots12) \
    D(OBJECT16,            Object,        JSObject,          JSObject_Slots16) \
    D(OBJECT16_BACKGROUND, Object,        JSObject,          JSObject_Slots16)

#define FOR_EACH_NONOBJECT_ALLOCKIND(D) \
 /* AllocKind              TraceKind      TypeName           SizedType */ \
    D(SCRIPT,              Script,        JSScript,          JSScript) \
    D(LAZY_SCRIPT,         LazyScript,    js::LazyScript,    js::LazyScript) \
    D(SHAPE,               Shape,         js::Shape,         js::Shape) \
    D(ACCESSOR_SHAPE,      Shape,         js::AccessorShape, js::AccessorShape) \
    D(BASE_SHAPE,          BaseShape,     js::BaseShape,     js::BaseShape) \
    D(OBJECT_GROUP,        ObjectGroup,   js::ObjectGroup,   js::ObjectGroup) \
    D(FAT_INLINE_STRING,   String,        JSFatInlineString, JSFatInlineString) \
    D(STRING,              String,        JSString,          JSString) \
    D(EXTERNAL_STRING,     String,        JSExternalString,  JSExternalString) \
    D(FAT_INLINE_ATOM,     String,        js::FatInlineAtom, js::FatInlineAtom) \
    D(ATOM,                String,        js::NormalAtom,    js::NormalAtom) \
    D(SYMBOL,              Symbol,        JS::Symbol,        JS::Symbol) \
    D(JITCODE,             JitCode,       js::jit::JitCode,  js::jit::JitCode) \
    D(SCOPE,               Scope,         js::Scope,         js::Scope) \
    D(REGEXP_SHARED,       RegExpShared,  js::RegExpShared,  js::RegExpShared)

#define FOR_EACH_ALLOCKIND(D) \
    FOR_EACH_OBJECT_ALLOCKIND(D) \
    FOR_EACH_NONOBJECT_ALLOCKIND(D)

static_assert(int(AllocKind::FIRST) == 0, "Various places depend on AllocKind starting at 0, "
                                          "please audit them carefully!");
static_assert(int(AllocKind::OBJECT_FIRST) == 0, "Various places depend on AllocKind::OBJECT_FIRST "
                                                 "being 0, please audit them carefully!");

inline bool
IsAllocKind(AllocKind kind)
{
    return kind >= AllocKind::FIRST && kind <= AllocKind::LIMIT;
}

inline bool
IsValidAllocKind(AllocKind kind)
{
    return kind >= AllocKind::FIRST && kind <= AllocKind::LAST;
}

inline bool
IsObjectAllocKind(AllocKind kind)
{
    return kind >= AllocKind::OBJECT_FIRST && kind <= AllocKind::OBJECT_LAST;
}

inline bool
IsShapeAllocKind(AllocKind kind)
{
    return kind == AllocKind::SHAPE || kind == AllocKind::ACCESSOR_SHAPE;
}

// Returns a sequence for use in a range-based for loop,
// to iterate over all alloc kinds.
inline decltype(mozilla::MakeEnumeratedRange(AllocKind::FIRST, AllocKind::LIMIT))
AllAllocKinds()
{
    return mozilla::MakeEnumeratedRange(AllocKind::FIRST, AllocKind::LIMIT);
}

// Returns a sequence for use in a range-based for loop,
// to iterate over all object alloc kinds.
inline decltype(mozilla::MakeEnumeratedRange(AllocKind::OBJECT_FIRST, AllocKind::OBJECT_LIMIT))
ObjectAllocKinds()
{
    return mozilla::MakeEnumeratedRange(AllocKind::OBJECT_FIRST, AllocKind::OBJECT_LIMIT);
}

// Returns a sequence for use in a range-based for loop,
// to iterate over alloc kinds from |first| to |limit|, exclusive.
inline decltype(mozilla::MakeEnumeratedRange(AllocKind::FIRST, AllocKind::LIMIT))
SomeAllocKinds(AllocKind first = AllocKind::FIRST, AllocKind limit = AllocKind::LIMIT)
{
    MOZ_ASSERT(IsAllocKind(first), "|first| is not a valid AllocKind!");
    MOZ_ASSERT(IsAllocKind(limit), "|limit| is not a valid AllocKind!");
    return mozilla::MakeEnumeratedRange(first, limit);
}

// AllAllocKindArray<ValueType> gives an enumerated array of ValueTypes,
// with each index corresponding to a particular alloc kind.
template<typename ValueType> using AllAllocKindArray =
    mozilla::EnumeratedArray<AllocKind, AllocKind::LIMIT, ValueType>;

// ObjectAllocKindArray<ValueType> gives an enumerated array of ValueTypes,
// with each index corresponding to a particular object alloc kind.
template<typename ValueType> using ObjectAllocKindArray =
    mozilla::EnumeratedArray<AllocKind, AllocKind::OBJECT_LIMIT, ValueType>;

static inline JS::TraceKind
MapAllocToTraceKind(AllocKind kind)
{
    static const JS::TraceKind map[] = {
#define EXPAND_ELEMENT(allocKind, traceKind, type, sizedType) \
        JS::TraceKind::traceKind,
FOR_EACH_ALLOCKIND(EXPAND_ELEMENT)
#undef EXPAND_ELEMENT
    };

    static_assert(MOZ_ARRAY_LENGTH(map) == size_t(AllocKind::LIMIT),
                  "AllocKind-to-TraceKind mapping must be in sync");
    return map[size_t(kind)];
}

/*
 * This must be an upper bound, but we do not need the least upper bound, so
 * we just exclude non-background objects.
 */
static const size_t MAX_BACKGROUND_FINALIZE_KINDS =
    size_t(AllocKind::LIMIT) - size_t(AllocKind::OBJECT_LIMIT) / 2;

class TenuredCell;

// A GC cell is the base class for all GC things.
struct Cell
{
  public:
    MOZ_ALWAYS_INLINE bool isTenured() const { return !IsInsideNursery(this); }
    MOZ_ALWAYS_INLINE const TenuredCell& asTenured() const;
    MOZ_ALWAYS_INLINE TenuredCell& asTenured();

    MOZ_ALWAYS_INLINE bool isMarked(uint32_t color = BLACK) const;

    inline JSRuntime* runtimeFromActiveCooperatingThread() const;

    // Note: Unrestricted access to the runtime of a GC thing from an arbitrary
    // thread can easily lead to races. Use this method very carefully.
    inline JSRuntime* runtimeFromAnyThread() const;

    // May be overridden by GC thing kinds that have a compartment pointer.
    inline JSCompartment* maybeCompartment() const { return nullptr; }

    // The StoreBuffer used to record incoming pointers from the tenured heap.
    // This will return nullptr for a tenured cell.
    inline StoreBuffer* storeBuffer() const;

    inline JS::TraceKind getTraceKind() const;

    static MOZ_ALWAYS_INLINE bool needWriteBarrierPre(JS::Zone* zone);

#ifdef DEBUG
    inline bool isAligned() const;
    void dump(FILE* fp) const;
    void dump() const;
#endif

  protected:
    inline uintptr_t address() const;
    inline Chunk* chunk() const;
} JS_HAZ_GC_THING;

// A GC TenuredCell gets behaviors that are valid for things in the Tenured
// heap, such as access to the arena and mark bits.
class TenuredCell : public Cell
{
  public:
    // Construct a TenuredCell from a void*, making various sanity assertions.
    static MOZ_ALWAYS_INLINE TenuredCell* fromPointer(void* ptr);
    static MOZ_ALWAYS_INLINE const TenuredCell* fromPointer(const void* ptr);

    // Mark bit management.
    MOZ_ALWAYS_INLINE bool isMarked(uint32_t color = BLACK) const;
    // The return value indicates if the cell went from unmarked to marked.
    MOZ_ALWAYS_INLINE bool markIfUnmarked(uint32_t color = BLACK) const;
    MOZ_ALWAYS_INLINE void markBlack() const;
    MOZ_ALWAYS_INLINE void copyMarkBitsFrom(const TenuredCell* src);

    // Access to the arena.
    inline Arena* arena() const;
    inline AllocKind getAllocKind() const;
    inline JS::TraceKind getTraceKind() const;
    inline JS::Zone* zone() const;
    inline JS::Zone* zoneFromAnyThread() const;
    inline bool isInsideZone(JS::Zone* zone) const;

    MOZ_ALWAYS_INLINE JS::shadow::Zone* shadowZone() const {
        return JS::shadow::Zone::asShadowZone(zone());
    }
    MOZ_ALWAYS_INLINE JS::shadow::Zone* shadowZoneFromAnyThread() const {
        return JS::shadow::Zone::asShadowZone(zoneFromAnyThread());
    }

    static MOZ_ALWAYS_INLINE void readBarrier(TenuredCell* thing);
    static MOZ_ALWAYS_INLINE void writeBarrierPre(TenuredCell* thing);

    static MOZ_ALWAYS_INLINE void writeBarrierPost(void* cellp, TenuredCell* prior,
                                                   TenuredCell* next);

    // Default implementation for kinds that don't require fixup.
    void fixupAfterMovingGC() {}

#ifdef DEBUG
    inline bool isAligned() const;
#endif
};

/* Cells are aligned to CellAlignShift, so the largest tagged null pointer is: */
const uintptr_t LargestTaggedNullCellPointer = (1 << CellAlignShift) - 1;

/*
 * The minimum cell size ends up as twice the cell alignment because the mark
 * bitmap contains one bit per CellBytesPerMarkBit bytes (which is equal to
 * CellAlignBytes) and we need two mark bits per cell.
 */
const size_t MarkBitsPerCell = 2;
const size_t MinCellSize = CellBytesPerMarkBit * MarkBitsPerCell;

constexpr size_t
DivideAndRoundUp(size_t numerator, size_t divisor) {
    return (numerator + divisor - 1) / divisor;
}

static_assert(ArenaSize % CellAlignBytes == 0,
              "Arena size must be a multiple of cell alignment");

/*
 * We sometimes use an index to refer to a cell in an arena. The index for a
 * cell is found by dividing by the cell alignment so not all indicies refer to
 * valid cells.
 */
const size_t ArenaCellIndexBytes = CellAlignBytes;
const size_t MaxArenaCellIndex = ArenaSize / CellAlignBytes;

/*
 * The mark bitmap has one bit per each possible cell start position. This
 * wastes some space for larger GC things but allows us to avoid division by the
 * cell's size when accessing the bitmap.
 */
const size_t ArenaBitmapBits = ArenaSize / CellBytesPerMarkBit;
const size_t ArenaBitmapBytes = DivideAndRoundUp(ArenaBitmapBits, 8);
const size_t ArenaBitmapWords = DivideAndRoundUp(ArenaBitmapBits, JS_BITS_PER_WORD);

/*
 * A FreeSpan represents a contiguous sequence of free cells in an Arena. It
 * can take two forms.
 *
 * - In an empty span, |first| and |last| are both zero.
 *
 * - In a non-empty span, |first| is the address of the first free thing in the
 *   span, and |last| is the address of the last free thing in the span.
 *   Furthermore, the memory pointed to by |last| holds a FreeSpan structure
 *   that points to the next span (which may be empty); this works because
 *   sizeof(FreeSpan) is less than the smallest thingSize.
 */
class FreeSpan
{
    friend class Arena;
    friend class ArenaCellIterImpl;

    uint16_t first;
    uint16_t last;

  public:
    // This inits just |first| and |last|; if the span is non-empty it doesn't
    // do anything with the next span stored at |last|.
    void initBounds(uintptr_t firstArg, uintptr_t lastArg, const Arena* arena) {
        checkRange(firstArg, lastArg, arena);
        first = firstArg;
        last = lastArg;
    }

    void initAsEmpty() {
        first = 0;
        last = 0;
    }

    // This sets |first| and |last|, and also sets the next span stored at
    // |last| as empty. (As a result, |firstArg| and |lastArg| cannot represent
    // an empty span.)
    void initFinal(uintptr_t firstArg, uintptr_t lastArg, const Arena* arena) {
        initBounds(firstArg, lastArg, arena);
        FreeSpan* last = nextSpanUnchecked(arena);
        last->initAsEmpty();
        checkSpan(arena);
    }

    bool isEmpty() const {
        return !first;
    }

    Arena* getArenaUnchecked() { return reinterpret_cast<Arena*>(this); }
    inline Arena* getArena();

    static size_t offsetOfFirst() {
        return offsetof(FreeSpan, first);
    }

    static size_t offsetOfLast() {
        return offsetof(FreeSpan, last);
    }

    // Like nextSpan(), but no checking of the following span is done.
    FreeSpan* nextSpanUnchecked(const Arena* arena) const {
        MOZ_ASSERT(arena && !isEmpty());
        return reinterpret_cast<FreeSpan*>(uintptr_t(arena) + last);
    }

    const FreeSpan* nextSpan(const Arena* arena) const {
        checkSpan(arena);
        return nextSpanUnchecked(arena);
    }

    MOZ_ALWAYS_INLINE TenuredCell* allocate(size_t thingSize) {
        // Eschew the usual checks, because this might be the placeholder span.
        // If this is somehow an invalid, non-empty span, checkSpan() will catch it.
        Arena* arena = getArenaUnchecked();
        checkSpan(arena);
        uintptr_t thing = uintptr_t(arena) + first;
        if (first < last) {
            // We have space for at least two more things, so do a simple bump-allocate.
            first += thingSize;
        } else if (MOZ_LIKELY(first)) {
            // The last space points to the next free span (which may be empty).
            const FreeSpan* next = nextSpan(arena);
            first = next->first;
            last = next->last;
        } else {
            return nullptr; // The span is empty.
        }
        checkSpan(arena);
        JS_EXTRA_POISON(reinterpret_cast<void*>(thing), JS_ALLOCATED_TENURED_PATTERN, thingSize);
        MemProfiler::SampleTenured(reinterpret_cast<void*>(thing), thingSize);
        return reinterpret_cast<TenuredCell*>(thing);
    }

    inline void checkSpan(const Arena* arena) const;
    inline void checkRange(uintptr_t first, uintptr_t last, const Arena* arena) const;
};

/*
 * Arenas are the allocation units of the tenured heap in the GC. An arena
 * is 4kiB in size and 4kiB-aligned. It starts with several header fields
 * followed by some bytes of padding. The remainder of the arena is filled
 * with GC things of a particular AllocKind. The padding ensures that the
 * GC thing array ends exactly at the end of the arena:
 *
 * <----------------------------------------------> = ArenaSize bytes
 * +---------------+---------+----+----+-----+----+
 * | header fields | padding | T0 | T1 | ... | Tn |
 * +---------------+---------+----+----+-----+----+
 * <-------------------------> = first thing offset
 */
class Arena
{
    static JS_FRIEND_DATA(const uint32_t) ThingSizes[];
    static JS_FRIEND_DATA(const uint32_t) FirstThingOffsets[];
    static JS_FRIEND_DATA(const uint32_t) ThingsPerArena[];

    /*
     * The first span of free things in the arena. Most of these spans are
     * stored as offsets in free regions of the data array, and most operations
     * on FreeSpans take an Arena pointer for safety. However, the FreeSpans
     * used for allocation are stored here, at the start of an Arena, and use
     * their own address to grab the next span within the same Arena.
     */
    FreeSpan firstFreeSpan;

  public:
    /*
     * The zone that this Arena is contained within, when allocated. The offset
     * of this field must match the ArenaZoneOffset stored in js/HeapAPI.h,
     * as is statically asserted below.
     */
    JS::Zone* zone;

    /*
     * Arena::next has two purposes: when unallocated, it points to the next
     * available Arena. When allocated, it points to the next Arena in the same
     * zone and with the same alloc kind.
     */
    Arena* next;

  private:
    /*
     * One of the AllocKind constants or AllocKind::LIMIT when the arena does
     * not contain any GC things and is on the list of empty arenas in the GC
     * chunk.
     *
     * We use 8 bits for the alloc kind so the compiler can use byte-level
     * memory instructions to access it.
     */
    size_t allocKind : 8;

  public:
    /*
     * When collecting we sometimes need to keep an auxillary list of arenas,
     * for which we use the following fields. This happens for several reasons:
     *
     * When recursive marking uses too much stack, the marking is delayed and
     * the corresponding arenas are put into a stack. To distinguish the bottom
     * of the stack from the arenas not present in the stack we use the
     * markOverflow flag to tag arenas on the stack.
     *
     * Delayed marking is also used for arenas that we allocate into during an
     * incremental GC. In this case, we intend to mark all the objects in the
     * arena, and it's faster to do this marking in bulk.
     *
     * When sweeping we keep track of which arenas have been allocated since
     * the end of the mark phase. This allows us to tell whether a pointer to
     * an unmarked object is yet to be finalized or has already been
     * reallocated. We set the allocatedDuringIncremental flag for this and
     * clear it at the end of the sweep phase.
     *
     * To minimize the size of the header fields we record the next linkage as
     * address() >> ArenaShift and pack it with the allocKind and the flags.
     */
    size_t hasDelayedMarking : 1;
    size_t allocatedDuringIncremental : 1;
    size_t markOverflow : 1;
    size_t auxNextLink : JS_BITS_PER_WORD - 8 - 1 - 1 - 1;
    static_assert(ArenaShift >= 8 + 1 + 1 + 1,
                  "Arena::auxNextLink packing assumes that ArenaShift has "
                  "enough bits to cover allocKind and hasDelayedMarking.");

  private:
    union {
        /*
         * For arenas in zones other than the atoms zone, if non-null, points
         * to an ArenaCellSet that represents the set of cells in this arena
         * that are in the nursery's store buffer.
         */
        ArenaCellSet* bufferedCells_;

        /*
         * For arenas in the atoms zone, the starting index into zone atom
         * marking bitmaps (see AtomMarking.h) of the things in this zone.
         * Atoms never refer to nursery things, so no store buffer index is
         * needed.
         */
        size_t atomBitmapStart_;
    };
  public:

    /*
     * The size of data should be |ArenaSize - offsetof(data)|, but the offset
     * is not yet known to the compiler, so we do it by hand. |firstFreeSpan|
     * takes up 8 bytes on 64-bit due to alignment requirements; the rest are
     * obvious. This constant is stored in js/HeapAPI.h.
     */
    uint8_t data[ArenaSize - ArenaHeaderSize];

    void init(JS::Zone* zoneArg, AllocKind kind);

    // Sets |firstFreeSpan| to the Arena's entire valid range, and
    // also sets the next span stored at |firstFreeSpan.last| as empty.
    void setAsFullyUnused() {
        AllocKind kind = getAllocKind();
        firstFreeSpan.first = firstThingOffset(kind);
        firstFreeSpan.last = lastThingOffset(kind);
        FreeSpan* last = firstFreeSpan.nextSpanUnchecked(this);
        last->initAsEmpty();
    }

    // Initialize an arena to its unallocated state. For arenas that were
    // previously allocated for some zone, use release() instead.
    void setAsNotAllocated() {
        firstFreeSpan.initAsEmpty();
        zone = nullptr;
        allocKind = size_t(AllocKind::LIMIT);
        hasDelayedMarking = 0;
        allocatedDuringIncremental = 0;
        markOverflow = 0;
        auxNextLink = 0;
        bufferedCells_ = nullptr;
    }

    // Return an allocated arena to its unallocated state.
    inline void release();

    uintptr_t address() const {
        checkAddress();
        return uintptr_t(this);
    }

    inline void checkAddress() const;

    inline Chunk* chunk() const;

    bool allocated() const {
        MOZ_ASSERT(IsAllocKind(AllocKind(allocKind)));
        return IsValidAllocKind(AllocKind(allocKind));
    }

    AllocKind getAllocKind() const {
        MOZ_ASSERT(allocated());
        return AllocKind(allocKind);
    }

    FreeSpan* getFirstFreeSpan() { return &firstFreeSpan; }

    static size_t thingSize(AllocKind kind) { return ThingSizes[size_t(kind)]; }
    static size_t thingsPerArena(AllocKind kind) { return ThingsPerArena[size_t(kind)]; }
    static size_t thingsSpan(AllocKind kind) { return thingsPerArena(kind) * thingSize(kind); }

    static size_t firstThingOffset(AllocKind kind) { return FirstThingOffsets[size_t(kind)]; }
    static size_t lastThingOffset(AllocKind kind) { return ArenaSize - thingSize(kind); }

    size_t getThingSize() const { return thingSize(getAllocKind()); }
    size_t getThingsPerArena() const { return thingsPerArena(getAllocKind()); }
    size_t getThingsSpan() const { return getThingsPerArena() * getThingSize(); }
    size_t getFirstThingOffset() const { return firstThingOffset(getAllocKind()); }

    uintptr_t thingsStart() const { return address() + getFirstThingOffset(); }
    uintptr_t thingsEnd() const { return address() + ArenaSize; }

    bool isEmpty() const {
        // Arena is empty if its first span covers the whole arena.
        firstFreeSpan.checkSpan(this);
        AllocKind kind = getAllocKind();
        return firstFreeSpan.first == firstThingOffset(kind) &&
               firstFreeSpan.last == lastThingOffset(kind);
    }

    bool hasFreeThings() const { return !firstFreeSpan.isEmpty(); }

    size_t numFreeThings(size_t thingSize) const {
        firstFreeSpan.checkSpan(this);
        size_t numFree = 0;
        const FreeSpan* span = &firstFreeSpan;
        for (; !span->isEmpty(); span = span->nextSpan(this))
            numFree += (span->last - span->first) / thingSize + 1;
        return numFree;
    }

    size_t countFreeCells() { return numFreeThings(getThingSize()); }
    size_t countUsedCells() { return getThingsPerArena() - countFreeCells(); }

    bool inFreeList(uintptr_t thing) {
        uintptr_t base = address();
        const FreeSpan* span = &firstFreeSpan;
        for (; !span->isEmpty(); span = span->nextSpan(this)) {
            /* If the thing comes before the current span, it's not free. */
            if (thing < base + span->first)
                return false;

            /* If we find it before the end of the span, it's free. */
            if (thing <= base + span->last)
                return true;
        }
        return false;
    }

    static bool isAligned(uintptr_t thing, size_t thingSize) {
        /* Things ends at the arena end. */
        uintptr_t tailOffset = ArenaSize - (thing & ArenaMask);
        return tailOffset % thingSize == 0;
    }

    Arena* getNextDelayedMarking() const {
        MOZ_ASSERT(hasDelayedMarking);
        return reinterpret_cast<Arena*>(auxNextLink << ArenaShift);
    }

    void setNextDelayedMarking(Arena* arena) {
        MOZ_ASSERT(!(uintptr_t(arena) & ArenaMask));
        MOZ_ASSERT(!auxNextLink && !hasDelayedMarking);
        hasDelayedMarking = 1;
        if (arena)
            auxNextLink = arena->address() >> ArenaShift;
    }

    void unsetDelayedMarking() {
        MOZ_ASSERT(hasDelayedMarking);
        hasDelayedMarking = 0;
        auxNextLink = 0;
    }

    Arena* getNextAllocDuringSweep() const {
        MOZ_ASSERT(allocatedDuringIncremental);
        return reinterpret_cast<Arena*>(auxNextLink << ArenaShift);
    }

    void setNextAllocDuringSweep(Arena* arena) {
        MOZ_ASSERT(!(uintptr_t(arena) & ArenaMask));
        MOZ_ASSERT(!auxNextLink && !allocatedDuringIncremental);
        allocatedDuringIncremental = 1;
        if (arena)
            auxNextLink = arena->address() >> ArenaShift;
    }

    void unsetAllocDuringSweep() {
        MOZ_ASSERT(allocatedDuringIncremental);
        allocatedDuringIncremental = 0;
        auxNextLink = 0;
    }

    inline ArenaCellSet*& bufferedCells();
    inline size_t& atomBitmapStart();

    template <typename T>
    size_t finalize(FreeOp* fop, AllocKind thingKind, size_t thingSize);

    static void staticAsserts();

    void unmarkAll();
};

static_assert(ArenaZoneOffset == offsetof(Arena, zone),
              "The hardcoded API zone offset must match the actual offset.");

static_assert(sizeof(Arena) == ArenaSize,
              "ArenaSize must match the actual size of the Arena structure.");

static_assert(offsetof(Arena, data) == ArenaHeaderSize,
              "ArenaHeaderSize must match the actual size of the header fields.");

inline Arena*
FreeSpan::getArena()
{
    Arena* arena = getArenaUnchecked();
    arena->checkAddress();
    return arena;
}

inline void
FreeSpan::checkSpan(const Arena* arena) const
{
#ifdef DEBUG
    if (!first) {
        MOZ_ASSERT(!first && !last);
        return;
    }

    arena->checkAddress();
    checkRange(first, last, arena);

    // If there's a following span, it must have a higher address,
    // and the gap must be at least 2 * thingSize.
    const FreeSpan* next = nextSpanUnchecked(arena);
    if (next->first) {
        checkRange(next->first, next->last, arena);
        size_t thingSize = arena->getThingSize();
        MOZ_ASSERT(last + 2 * thingSize <= next->first);
    }
#endif
}

inline void
FreeSpan::checkRange(uintptr_t first, uintptr_t last, const Arena* arena) const
{
#ifdef DEBUG
    MOZ_ASSERT(arena);
    MOZ_ASSERT(first <= last);
    AllocKind thingKind = arena->getAllocKind();
    MOZ_ASSERT(first >= Arena::firstThingOffset(thingKind));
    MOZ_ASSERT(last <= Arena::lastThingOffset(thingKind));
    MOZ_ASSERT((last - first) % Arena::thingSize(thingKind) == 0);
#endif
}

/*
 * The tail of the chunk info is shared between all chunks in the system, both
 * nursery and tenured. This structure is locatable from any GC pointer by
 * aligning to 1MiB.
 */
struct ChunkTrailer
{
    // Construct a Nursery ChunkTrailer.
    ChunkTrailer(JSRuntime* rt, StoreBuffer* sb)
      : location(ChunkLocation::Nursery), storeBuffer(sb), runtime(rt)
    {}

    // Construct a Tenured heap ChunkTrailer.
    explicit ChunkTrailer(JSRuntime* rt)
      : location(ChunkLocation::TenuredHeap), storeBuffer(nullptr), runtime(rt)
    {}

  public:
    // The index of the chunk in the nursery, or LocationTenuredHeap.
    ChunkLocation   location;
    uint32_t        padding;

    // The store buffer for pointers from tenured things to things in this
    // chunk. Will be non-null only for nursery chunks.
    StoreBuffer*    storeBuffer;

    // Provide quick access to the runtime from absolutely anywhere.
    JSRuntime*      runtime;
};

static_assert(sizeof(ChunkTrailer) == ChunkTrailerSize,
              "ChunkTrailer size must match the API defined size.");

/* The chunk header (located at the end of the chunk to preserve arena alignment). */
struct ChunkInfo
{
    void init() {
        next = prev = nullptr;
    }

  private:
    friend class ChunkPool;
    Chunk*          next;
    Chunk*          prev;

  public:
    /* Free arenas are linked together with arena.next. */
    Arena*          freeArenasHead;

#if JS_BITS_PER_WORD == 32
    /*
     * Calculating sizes and offsets is simpler if sizeof(ChunkInfo) is
     * architecture-independent.
     */
    char            padding[24];
#endif

    /*
     * Decommitted arenas are tracked by a bitmap in the chunk header. We use
     * this offset to start our search iteration close to a decommitted arena
     * that we can allocate.
     */
    uint32_t        lastDecommittedArenaOffset;

    /* Number of free arenas, either committed or decommitted. */
    uint32_t        numArenasFree;

    /* Number of free, committed arenas. */
    uint32_t        numArenasFreeCommitted;
};

/*
 * Calculating ArenasPerChunk:
 *
 * In order to figure out how many Arenas will fit in a chunk, we need to know
 * how much extra space is available after we allocate the header data. This
 * is a problem because the header size depends on the number of arenas in the
 * chunk. The two dependent fields are bitmap and decommittedArenas.
 *
 * For the mark bitmap, we know that each arena will use a fixed number of full
 * bytes: ArenaBitmapBytes. The full size of the header data is this number
 * multiplied by the eventual number of arenas we have in the header. We,
 * conceptually, distribute this header data among the individual arenas and do
 * not include it in the header. This way we do not have to worry about its
 * variable size: it gets attached to the variable number we are computing.
 *
 * For the decommitted arena bitmap, we only have 1 bit per arena, so this
 * technique will not work. Instead, we observe that we do not have enough
 * header info to fill 8 full arenas: it is currently 4 on 64bit, less on
 * 32bit. Thus, with current numbers, we need 64 bytes for decommittedArenas.
 * This will not become 63 bytes unless we double the data required in the
 * header. Therefore, we just compute the number of bytes required to track
 * every possible arena and do not worry about slop bits, since there are too
 * few to usefully allocate.
 *
 * To actually compute the number of arenas we can allocate in a chunk, we
 * divide the amount of available space less the header info (not including
 * the mark bitmap which is distributed into the arena size) by the size of
 * the arena (with the mark bitmap bytes it uses).
 */
const size_t BytesPerArenaWithHeader = ArenaSize + ArenaBitmapBytes;
const size_t ChunkDecommitBitmapBytes = ChunkSize / ArenaSize / JS_BITS_PER_BYTE;
const size_t ChunkBytesAvailable = ChunkSize - sizeof(ChunkTrailer) - sizeof(ChunkInfo) - ChunkDecommitBitmapBytes;
const size_t ArenasPerChunk = ChunkBytesAvailable / BytesPerArenaWithHeader;

#ifdef JS_GC_SMALL_CHUNK_SIZE
static_assert(ArenasPerChunk == 62, "Do not accidentally change our heap's density.");
#else
static_assert(ArenasPerChunk == 252, "Do not accidentally change our heap's density.");
#endif

/* A chunk bitmap contains enough mark bits for all the cells in a chunk. */
struct ChunkBitmap
{
    volatile uintptr_t bitmap[ArenaBitmapWords * ArenasPerChunk];

  public:
    ChunkBitmap() { }

    MOZ_ALWAYS_INLINE void getMarkWordAndMask(const Cell* cell, ColorBit colorBit,
                                              uintptr_t** wordp, uintptr_t* maskp)
    {
        detail::GetGCThingMarkWordAndMask(uintptr_t(cell), colorBit, wordp, maskp);
    }

    MOZ_ALWAYS_INLINE MOZ_TSAN_BLACKLIST bool markBit(const Cell* cell, ColorBit colorBit) {
        uintptr_t* word, mask;
        getMarkWordAndMask(cell, colorBit, &word, &mask);
        return *word & mask;
    }

    MOZ_ALWAYS_INLINE MOZ_TSAN_BLACKLIST bool isMarked(const Cell* cell, uint32_t color) {
        if (color == BLACK) {
            return markBit(cell, ColorBit::BlackBit) ||
                   markBit(cell, ColorBit::GrayOrBlackBit);
        } else {
            return !markBit(cell, ColorBit::BlackBit) &&
                   markBit(cell, ColorBit::GrayOrBlackBit);
        }
    }

    // The return value indicates if the cell went from unmarked to marked.
    MOZ_ALWAYS_INLINE bool markIfUnmarked(const Cell* cell, uint32_t color) {
        uintptr_t* word, mask;
        getMarkWordAndMask(cell, ColorBit::BlackBit, &word, &mask);
        if (*word & mask)
            return false;
        if (color == BLACK) {
            *word |= mask;
        } else {
            /*
             * We use getMarkWordAndMask to recalculate both mask and word as
             * doing just mask << color may overflow the mask.
             */
            getMarkWordAndMask(cell, ColorBit::GrayOrBlackBit, &word, &mask);
            if (*word & mask)
                return false;
            *word |= mask;
        }
        return true;
    }

    MOZ_ALWAYS_INLINE void markBlack(const Cell* cell) {
        uintptr_t* word, mask;
        getMarkWordAndMask(cell, ColorBit::BlackBit, &word, &mask);
        *word |= mask;
    }

    MOZ_ALWAYS_INLINE void copyMarkBit(Cell* dst, const TenuredCell* src, ColorBit colorBit) {
        uintptr_t* srcWord, srcMask;
        getMarkWordAndMask(src, colorBit, &srcWord, &srcMask);

        uintptr_t* dstWord, dstMask;
        getMarkWordAndMask(dst, colorBit, &dstWord, &dstMask);

        *dstWord &= ~dstMask;
        if (*srcWord & srcMask)
            *dstWord |= dstMask;
    }

    void clear() {
        memset((void*)bitmap, 0, sizeof(bitmap));
    }

    uintptr_t* arenaBits(Arena* arena) {
        static_assert(ArenaBitmapBits == ArenaBitmapWords * JS_BITS_PER_WORD,
                      "We assume that the part of the bitmap corresponding to the arena "
                      "has the exact number of words so we do not need to deal with a word "
                      "that covers bits from two arenas.");

        uintptr_t* word, unused;
        getMarkWordAndMask(reinterpret_cast<Cell*>(arena->address()), ColorBit::BlackBit, &word, &unused);
        return word;
    }
};

static_assert(ArenaBitmapBytes * ArenasPerChunk == sizeof(ChunkBitmap),
              "Ensure our ChunkBitmap actually covers all arenas.");
static_assert(js::gc::ChunkMarkBitmapBits == ArenaBitmapBits * ArenasPerChunk,
              "Ensure that the mark bitmap has the right number of bits.");

typedef BitArray<ArenasPerChunk> PerArenaBitmap;

const size_t ChunkPadSize = ChunkSize
                            - (sizeof(Arena) * ArenasPerChunk)
                            - sizeof(ChunkBitmap)
                            - sizeof(PerArenaBitmap)
                            - sizeof(ChunkInfo)
                            - sizeof(ChunkTrailer);
static_assert(ChunkPadSize < BytesPerArenaWithHeader,
              "If the chunk padding is larger than an arena, we should have one more arena.");

/*
 * Chunks contain arenas and associated data structures (mark bitmap, delayed
 * marking state).
 */
struct Chunk
{
    Arena           arenas[ArenasPerChunk];

    /* Pad to full size to ensure cache alignment of ChunkInfo. */
    uint8_t         padding[ChunkPadSize];

    ChunkBitmap     bitmap;
    PerArenaBitmap  decommittedArenas;
    ChunkInfo       info;
    ChunkTrailer    trailer;

    static Chunk* fromAddress(uintptr_t addr) {
        addr &= ~ChunkMask;
        return reinterpret_cast<Chunk*>(addr);
    }

    static bool withinValidRange(uintptr_t addr) {
        uintptr_t offset = addr & ChunkMask;
        return Chunk::fromAddress(addr)->isNurseryChunk()
               ? offset < ChunkSize - sizeof(ChunkTrailer)
               : offset < ArenasPerChunk * ArenaSize;
    }

    static size_t arenaIndex(uintptr_t addr) {
        MOZ_ASSERT(!Chunk::fromAddress(addr)->isNurseryChunk());
        MOZ_ASSERT(withinValidRange(addr));
        return (addr & ChunkMask) >> ArenaShift;
    }

    uintptr_t address() const {
        uintptr_t addr = reinterpret_cast<uintptr_t>(this);
        MOZ_ASSERT(!(addr & ChunkMask));
        return addr;
    }

    bool unused() const {
        return info.numArenasFree == ArenasPerChunk;
    }

    bool hasAvailableArenas() const {
        return info.numArenasFree != 0;
    }

    bool isNurseryChunk() const {
        return trailer.storeBuffer;
    }

    Arena* allocateArena(JSRuntime* rt, JS::Zone* zone, AllocKind kind, const AutoLockGC& lock);

    void releaseArena(JSRuntime* rt, Arena* arena, const AutoLockGC& lock);
    void recycleArena(Arena* arena, SortedArenaList& dest, size_t thingsPerArena);

    MOZ_MUST_USE bool decommitOneFreeArena(JSRuntime* rt, AutoLockGC& lock);
    void decommitAllArenasWithoutUnlocking(const AutoLockGC& lock);

    static Chunk* allocate(JSRuntime* rt);
    void init(JSRuntime* rt);

  private:
    void decommitAllArenas(JSRuntime* rt);

    /* Search for a decommitted arena to allocate. */
    unsigned findDecommittedArenaOffset();
    Arena* fetchNextDecommittedArena();

    void addArenaToFreeList(JSRuntime* rt, Arena* arena);
    void addArenaToDecommittedList(JSRuntime* rt, const Arena* arena);

    void updateChunkListAfterAlloc(JSRuntime* rt, const AutoLockGC& lock);
    void updateChunkListAfterFree(JSRuntime* rt, const AutoLockGC& lock);

  public:
    /* Unlink and return the freeArenasHead. */
    Arena* fetchNextFreeArena(JSRuntime* rt);
};

static_assert(sizeof(Chunk) == ChunkSize,
              "Ensure the hardcoded chunk size definition actually matches the struct.");
static_assert(js::gc::ChunkMarkBitmapOffset == offsetof(Chunk, bitmap),
              "The hardcoded API bitmap offset must match the actual offset.");
static_assert(js::gc::ChunkRuntimeOffset == offsetof(Chunk, trailer) +
                                            offsetof(ChunkTrailer, runtime),
              "The hardcoded API runtime offset must match the actual offset.");
static_assert(js::gc::ChunkLocationOffset == offsetof(Chunk, trailer) +
                                             offsetof(ChunkTrailer, location),
              "The hardcoded API location offset must match the actual offset.");

/*
 * Tracks the used sizes for owned heap data and automatically maintains the
 * memory usage relationship between GCRuntime and Zones.
 */
class HeapUsage
{
    /*
     * A heap usage that contains our parent's heap usage, or null if this is
     * the top-level usage container.
     */
    HeapUsage* const parent_;

    /*
     * The approximate number of bytes in use on the GC heap, to the nearest
     * ArenaSize. This does not include any malloc data. It also does not
     * include not-actively-used addresses that are still reserved at the OS
     * level for GC usage. It is atomic because it is updated by both the active
     * and GC helper threads.
     */
    mozilla::Atomic<size_t, mozilla::ReleaseAcquire> gcBytes_;

  public:
    explicit HeapUsage(HeapUsage* parent)
      : parent_(parent),
        gcBytes_(0)
    {}

    size_t gcBytes() const { return gcBytes_; }

    void addGCArena() {
        gcBytes_ += ArenaSize;
        if (parent_)
            parent_->addGCArena();
    }
    void removeGCArena() {
        MOZ_ASSERT(gcBytes_ >= ArenaSize);
        gcBytes_ -= ArenaSize;
        if (parent_)
            parent_->removeGCArena();
    }

    /* Pair to adoptArenas. Adopts the attendant usage statistics. */
    void adopt(HeapUsage& other) {
        gcBytes_ += other.gcBytes_;
        other.gcBytes_ = 0;
    }
};

inline void
Arena::checkAddress() const
{
    mozilla::DebugOnly<uintptr_t> addr = uintptr_t(this);
    MOZ_ASSERT(addr);
    MOZ_ASSERT(!(addr & ArenaMask));
    MOZ_ASSERT(Chunk::withinValidRange(addr));
}

inline Chunk*
Arena::chunk() const
{
    return Chunk::fromAddress(address());
}

static void
AssertValidColor(const TenuredCell* thing, uint32_t color)
{
#ifdef DEBUG
    Arena* arena = thing->arena();
    MOZ_ASSERT(color < arena->getThingSize() / CellBytesPerMarkBit);
#endif
}

MOZ_ALWAYS_INLINE const TenuredCell&
Cell::asTenured() const
{
    MOZ_ASSERT(isTenured());
    return *static_cast<const TenuredCell*>(this);
}

MOZ_ALWAYS_INLINE TenuredCell&
Cell::asTenured()
{
    MOZ_ASSERT(isTenured());
    return *static_cast<TenuredCell*>(this);
}

MOZ_ALWAYS_INLINE bool
Cell::isMarked(uint32_t color) const
{
    if (color == BLACK) {
        return !isTenured() || asTenured().isMarked(BLACK);
    } else {
        MOZ_ASSERT(color == GRAY);
        return isTenured() && asTenured().isMarked(GRAY);
    }
}

inline JSRuntime*
Cell::runtimeFromActiveCooperatingThread() const
{
    JSRuntime* rt = chunk()->trailer.runtime;
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(rt));
    return rt;
}

inline JSRuntime*
Cell::runtimeFromAnyThread() const
{
    return chunk()->trailer.runtime;
}

inline uintptr_t
Cell::address() const
{
    uintptr_t addr = uintptr_t(this);
    MOZ_ASSERT(addr % CellAlignBytes == 0);
    MOZ_ASSERT(Chunk::withinValidRange(addr));
    return addr;
}

Chunk*
Cell::chunk() const
{
    uintptr_t addr = uintptr_t(this);
    MOZ_ASSERT(addr % CellAlignBytes == 0);
    addr &= ~ChunkMask;
    return reinterpret_cast<Chunk*>(addr);
}

inline StoreBuffer*
Cell::storeBuffer() const
{
    return chunk()->trailer.storeBuffer;
}

inline JS::TraceKind
Cell::getTraceKind() const
{
    return isTenured() ? asTenured().getTraceKind() : JS::TraceKind::Object;
}

inline bool
InFreeList(Arena* arena, void* thing)
{
    uintptr_t addr = reinterpret_cast<uintptr_t>(thing);
    MOZ_ASSERT(Arena::isAligned(addr, arena->getThingSize()));
    return arena->inFreeList(addr);
}

/* static */ MOZ_ALWAYS_INLINE bool
Cell::needWriteBarrierPre(JS::Zone* zone) {
    return JS::shadow::Zone::asShadowZone(zone)->needsIncrementalBarrier();
}

/* static */ MOZ_ALWAYS_INLINE TenuredCell*
TenuredCell::fromPointer(void* ptr)
{
    MOZ_ASSERT(static_cast<TenuredCell*>(ptr)->isTenured());
    return static_cast<TenuredCell*>(ptr);
}

/* static */ MOZ_ALWAYS_INLINE const TenuredCell*
TenuredCell::fromPointer(const void* ptr)
{
    MOZ_ASSERT(static_cast<const TenuredCell*>(ptr)->isTenured());
    return static_cast<const TenuredCell*>(ptr);
}

bool
TenuredCell::isMarked(uint32_t color /* = BLACK */) const
{
    MOZ_ASSERT(arena()->allocated());
    AssertValidColor(this, color);
    return chunk()->bitmap.isMarked(this, color);
}

bool
TenuredCell::markIfUnmarked(uint32_t color /* = BLACK */) const
{
    AssertValidColor(this, color);
    return chunk()->bitmap.markIfUnmarked(this, color);
}

void
TenuredCell::markBlack() const
{
    chunk()->bitmap.markBlack(this);
}

void
TenuredCell::copyMarkBitsFrom(const TenuredCell* src)
{
    ChunkBitmap& bitmap = chunk()->bitmap;
    bitmap.copyMarkBit(this, src, ColorBit::BlackBit);
    bitmap.copyMarkBit(this, src, ColorBit::GrayOrBlackBit);
}

inline Arena*
TenuredCell::arena() const
{
    MOZ_ASSERT(isTenured());
    uintptr_t addr = address();
    addr &= ~ArenaMask;
    return reinterpret_cast<Arena*>(addr);
}

AllocKind
TenuredCell::getAllocKind() const
{
    return arena()->getAllocKind();
}

JS::TraceKind
TenuredCell::getTraceKind() const
{
    return MapAllocToTraceKind(getAllocKind());
}

JS::Zone*
TenuredCell::zone() const
{
    JS::Zone* zone = arena()->zone;
    MOZ_ASSERT(CurrentThreadCanAccessZone(zone));
    return zone;
}

JS::Zone*
TenuredCell::zoneFromAnyThread() const
{
    return arena()->zone;
}

bool
TenuredCell::isInsideZone(JS::Zone* zone) const
{
    return zone == arena()->zone;
}

/* static */ MOZ_ALWAYS_INLINE void
TenuredCell::readBarrier(TenuredCell* thing)
{
    MOZ_ASSERT(!CurrentThreadIsIonCompiling());
    MOZ_ASSERT(thing);

    // It would be good if barriers were never triggered during collection, but
    // at the moment this can happen e.g. when rekeying tables containing
    // read-barriered GC things after a moving GC.
    //
    // TODO: Fix this and assert we're not collecting if we're on the active
    // thread.

    JS::shadow::Zone* shadowZone = thing->shadowZoneFromAnyThread();
    if (shadowZone->needsIncrementalBarrier()) {
        // Barriers are only enabled on the active thread and are disabled while collecting.
        MOZ_ASSERT(!RuntimeFromActiveCooperatingThreadIsHeapMajorCollecting(shadowZone));
        Cell* tmp = thing;
        TraceManuallyBarrieredGenericPointerEdge(shadowZone->barrierTracer(), &tmp, "read barrier");
        MOZ_ASSERT(tmp == thing);
    }

    if (thing->isMarked(GRAY)) {
        // There shouldn't be anything marked grey unless we're on the active thread.
        MOZ_ASSERT(CurrentThreadCanAccessRuntime(thing->runtimeFromAnyThread()));
        if (!RuntimeFromActiveCooperatingThreadIsHeapMajorCollecting(shadowZone))
            UnmarkGrayCellRecursively(thing, thing->getTraceKind());
    }
}

void
AssertSafeToSkipBarrier(TenuredCell* thing);

/* static */ MOZ_ALWAYS_INLINE void
TenuredCell::writeBarrierPre(TenuredCell* thing)
{
    MOZ_ASSERT(!CurrentThreadIsIonCompiling());
    if (!thing)
        return;

#ifdef JS_GC_ZEAL
    // When verifying pre barriers we need to switch on all barriers, even
    // those on the Atoms Zone. Normally, we never enter a parse task when
    // collecting in the atoms zone, so will filter out atoms below.
    // Unfortuantely, If we try that when verifying pre-barriers, we'd never be
    // able to handle off thread parse tasks at all as we switch on the verifier any
    // time we're not doing GC. This would cause us to deadlock, as off thread parsing
    // is meant to resume after GC work completes. Instead we filter out any
    // off thread barriers that reach us and assert that they would normally not be
    // possible.
    if (!CurrentThreadCanAccessRuntime(thing->runtimeFromAnyThread())) {
        AssertSafeToSkipBarrier(thing);
        return;
    }
#endif

    JS::shadow::Zone* shadowZone = thing->shadowZoneFromAnyThread();
    if (shadowZone->needsIncrementalBarrier()) {
        MOZ_ASSERT(!RuntimeFromActiveCooperatingThreadIsHeapMajorCollecting(shadowZone));
        Cell* tmp = thing;
        TraceManuallyBarrieredGenericPointerEdge(shadowZone->barrierTracer(), &tmp, "pre barrier");
        MOZ_ASSERT(tmp == thing);
    }
}

static MOZ_ALWAYS_INLINE void
AssertValidToSkipBarrier(TenuredCell* thing)
{
    MOZ_ASSERT(!IsInsideNursery(thing));
    MOZ_ASSERT_IF(thing, MapAllocToTraceKind(thing->getAllocKind()) != JS::TraceKind::Object);
}

/* static */ MOZ_ALWAYS_INLINE void
TenuredCell::writeBarrierPost(void* cellp, TenuredCell* prior, TenuredCell* next)
{
    AssertValidToSkipBarrier(next);
}

#ifdef DEBUG
bool
Cell::isAligned() const
{
    if (!isTenured())
        return true;
    return asTenured().isAligned();
}

bool
TenuredCell::isAligned() const
{
    return Arena::isAligned(address(), arena()->getThingSize());
}
#endif

static const int32_t ChunkLocationOffsetFromLastByte =
    int32_t(gc::ChunkLocationOffset) - int32_t(gc::ChunkMask);

} /* namespace gc */

namespace debug {

// Utility functions meant to be called from an interactive debugger.
enum class MarkInfo : int {
    BLACK = js::gc::BLACK,
    GRAY = js::gc::GRAY,
    UNMARKED = -1,
    NURSERY = -2,
};

// Get the mark color for a cell, in a way easily usable from a debugger.
MOZ_NEVER_INLINE MarkInfo
GetMarkInfo(js::gc::Cell* cell);

// Sample usage from gdb:
//
//   (gdb) p $word = js::debug::GetMarkWordAddress(obj)
//   $1 = (uintptr_t *) 0x7fa56d5fe360
//   (gdb) p/x $mask = js::debug::GetMarkMask(obj, js::gc::GRAY)
//   $2 = 0x200000000
//   (gdb) watch *$word
//   Hardware watchpoint 7: *$word
//   (gdb) cond 7 *$word & $mask
//   (gdb) cont
//
// Note that this is *not* a watchpoint on a single bit. It is a watchpoint on
// the whole word, which will trigger whenever the word changes and the
// selected bit is set after the change.
//
// So if the bit changing is the desired one, this is exactly what you want.
// But if a different bit changes (either set or cleared), you may still stop
// execution if the $mask bit happened to already be set. gdb does not expose
// enough information to restrict the watchpoint to just a single bit.

// Return the address of the word containing the mark bits for the given cell,
// or nullptr if the cell is in the nursery.
MOZ_NEVER_INLINE uintptr_t*
GetMarkWordAddress(js::gc::Cell* cell);

// Return the mask for the given cell and color, or 0 if the cell is in the
// nursery.
MOZ_NEVER_INLINE uintptr_t
GetMarkMask(js::gc::Cell* cell, uint32_t color);

} /* namespace debug */
} /* namespace js */

#endif /* gc_Heap_h */
