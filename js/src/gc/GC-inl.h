/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef gc_GC_inl_h
#define gc_GC_inl_h

#include "gc/GC.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/Maybe.h"

#include "gc/Zone.h"
#include "vm/Runtime.h"

#include "gc/ArenaList-inl.h"

namespace js {
namespace gc {

class AutoAssertEmptyNursery;

class ArenaIter {
  Arena* arena;
  Arena* unsweptArena;
  Arena* sweptArena;
  mozilla::DebugOnly<bool> initialized;

 public:
  ArenaIter()
      : arena(nullptr),
        unsweptArena(nullptr),
        sweptArena(nullptr),
        initialized(false) {}

  ArenaIter(JS::Zone* zone, AllocKind kind) : initialized(false) {
    init(zone, kind);
  }

  void init(JS::Zone* zone, AllocKind kind) {
    MOZ_ASSERT(!initialized);
    MOZ_ASSERT(zone);
    initialized = true;
    arena = zone->arenas.getFirstArena(kind);
    unsweptArena = zone->arenas.getFirstArenaToSweep(kind);
    sweptArena = zone->arenas.getFirstSweptArena(kind);
    if (!unsweptArena) {
      unsweptArena = sweptArena;
      sweptArena = nullptr;
    }
    if (!arena) {
      arena = unsweptArena;
      unsweptArena = sweptArena;
      sweptArena = nullptr;
    }
  }

  bool done() const {
    MOZ_ASSERT(initialized);
    return !arena;
  }

  Arena* get() const {
    MOZ_ASSERT(!done());
    return arena;
  }

  void next() {
    MOZ_ASSERT(!done());
    arena = arena->next;
    if (!arena) {
      arena = unsweptArena;
      unsweptArena = sweptArena;
      sweptArena = nullptr;
    }
  }
};

class ArenaCellIter {
  size_t firstThingOffset;
  size_t thingSize;
  Arena* arenaAddr;
  FreeSpan span;
  uint_fast16_t thing;
  JS::TraceKind traceKind;
  mozilla::DebugOnly<bool> initialized;

  // Upon entry, |thing| points to any thing (free or used) and finds the
  // first used thing, which may be |thing|.
  void moveForwardIfFree() {
    MOZ_ASSERT(!done());
    MOZ_ASSERT(thing);
    // Note: if |span| is empty, this test will fail, which is what we want
    // -- |span| being empty means that we're past the end of the last free
    // thing, all the remaining things in the arena are used, and we'll
    // never need to move forward.
    if (thing == span.first) {
      thing = span.last + thingSize;
      span = *span.nextSpan(arenaAddr);
    }
  }

 public:
  ArenaCellIter()
      : firstThingOffset(0),
        thingSize(0),
        arenaAddr(nullptr),
        thing(0),
        traceKind(JS::TraceKind::Null),
        initialized(false) {
    span.initAsEmpty();
  }

  explicit ArenaCellIter(Arena* arena) : initialized(false) { init(arena); }

  void init(Arena* arena) {
    MOZ_ASSERT(!initialized);
    MOZ_ASSERT(arena);
    initialized = true;
    AllocKind kind = arena->getAllocKind();
    firstThingOffset = Arena::firstThingOffset(kind);
    thingSize = Arena::thingSize(kind);
    traceKind = MapAllocToTraceKind(kind);
    reset(arena);
  }

  // Use this to move from an Arena of a particular kind to another Arena of
  // the same kind.
  void reset(Arena* arena) {
    MOZ_ASSERT(initialized);
    MOZ_ASSERT(arena);
    arenaAddr = arena;
    span = *arena->getFirstFreeSpan();
    thing = firstThingOffset;
    moveForwardIfFree();
  }

  bool done() const {
    MOZ_ASSERT(initialized);
    MOZ_ASSERT(thing <= ArenaSize);
    return thing == ArenaSize;
  }

  TenuredCell* getCell() const {
    MOZ_ASSERT(!done());
    return reinterpret_cast<TenuredCell*>(uintptr_t(arenaAddr) + thing);
  }

  template <typename T>
  T* get() const {
    MOZ_ASSERT(!done());
    MOZ_ASSERT(JS::MapTypeToTraceKind<T>::kind == traceKind);
    return reinterpret_cast<T*>(getCell());
  }

  void next() {
    MOZ_ASSERT(!done());
    thing += thingSize;
    if (thing < ArenaSize) {
      moveForwardIfFree();
    }
  }
};

template <>
inline JSObject* ArenaCellIter::get<JSObject>() const {
  MOZ_ASSERT(!done());
  return reinterpret_cast<JSObject*>(getCell());
}

template <typename T>
class ZoneAllCellIter;

template <>
class ZoneAllCellIter<TenuredCell> {
  ArenaIter arenaIter;
  ArenaCellIter cellIter;
  mozilla::Maybe<JS::AutoAssertNoGC> nogc;

 protected:
  // For use when a subclass wants to insert some setup before init().
  ZoneAllCellIter() = default;

  void init(JS::Zone* zone, AllocKind kind) {
    MOZ_ASSERT_IF(IsNurseryAllocable(kind),
                  (zone->isAtomsZone() ||
                   zone->runtimeFromMainThread()->gc.nursery().isEmpty()));
    initForTenuredIteration(zone, kind);
  }

  void initForTenuredIteration(JS::Zone* zone, AllocKind kind) {
    JSRuntime* rt = zone->runtimeFromAnyThread();

    // If called from outside a GC, ensure that the heap is in a state
    // that allows us to iterate.
    if (!JS::RuntimeHeapIsBusy()) {
      // Assert that no GCs can occur while a ZoneAllCellIter is live.
      nogc.emplace();
    }

    // We have a single-threaded runtime, so there's no need to protect
    // against other threads iterating or allocating. However, we do have
    // background finalization; we may have to wait for this to finish if
    // it's currently active.
    if (IsBackgroundFinalized(kind) &&
        zone->arenas.needBackgroundFinalizeWait(kind)) {
      rt->gc.waitBackgroundSweepEnd();
    }
    arenaIter.init(zone, kind);
    if (!arenaIter.done()) {
      cellIter.init(arenaIter.get());
      settle();
    }
  }

 public:
  ZoneAllCellIter(JS::Zone* zone, AllocKind kind) {
    // If we are iterating a nursery-allocated kind then we need to
    // evict first so that we can see all things.
    if (IsNurseryAllocable(kind)) {
      zone->runtimeFromMainThread()->gc.evictNursery();
    }

    init(zone, kind);
  }

  ZoneAllCellIter(JS::Zone* zone, AllocKind kind,
                  const js::gc::AutoAssertEmptyNursery&) {
    // No need to evict the nursery. (This constructor is known statically
    // to not GC.)
    init(zone, kind);
  }

  bool done() const { return arenaIter.done(); }

  template <typename T>
  T* get() const {
    MOZ_ASSERT(!done());
    return cellIter.get<T>();
  }

  TenuredCell* getCell() const {
    MOZ_ASSERT(!done());
    return cellIter.getCell();
  }

  void settle() {
    while (cellIter.done() && !arenaIter.done()) {
      arenaIter.next();
      if (!arenaIter.done()) {
        cellIter.reset(arenaIter.get());
      }
    }
  }

  void next() {
    MOZ_ASSERT(!done());
    cellIter.next();
    settle();
  }
};

/* clang-format off */
//
// Iterator over the cells in a Zone, where the GC type (JSString, JSObject) is
// known, for a single AllocKind. Example usages:
//
//   for (auto obj = zone->cellIter<JSObject>(AllocKind::OBJECT0); !obj.done(); obj.next()) {
//       ...
//   }
//
//   for (auto script = zone->cellIter<JSScript>(); !script.done(); script.next()) {
//       f(script->code());
//   }
//
// As this code demonstrates, you can use 'script' as if it were a JSScript*.
// Its actual type is ZoneAllCellIter<JSScript>, but for most purposes it will
// autoconvert to JSScript*.
//
// Note that in the JSScript case, ZoneAllCellIter is able to infer the AllocKind
// from the type 'JSScript', whereas in the JSObject case, the kind must be
// given (because there are multiple AllocKinds for objects).
//
// Also, the static rooting hazard analysis knows that the JSScript case will
// not GC during construction. The JSObject case needs to GC, or more precisely
// to empty the nursery and clear out the store buffer, so that it can see all
// objects to iterate over (the nursery is not iterable) and remove the
// possibility of having pointers from the store buffer to data hanging off
// stuff we're iterating over that we are going to delete. (The latter should
// not be a problem, since such instances should be using RelocatablePtr do
// remove themselves from the store buffer on deletion, but currently for
// subtle reasons that isn't good enough.)
//
// If the iterator is used within a GC, then there is no need to evict the
// nursery (again). You may select a variant that will skip the eviction either
// by specializing on a GCType that is never allocated in the nursery, or
// explicitly by passing in a trailing AutoAssertEmptyNursery argument.
//
// NOTE: This class can return items that are about to be swept/finalized.
//       You must not keep pointers to such items across GCs.  Use
//       ZoneCellIter below to filter these out.
//
// NOTE: This class also does not read barrier returned items, so may return
//       gray cells. You must not store such items anywhere on the heap without
//       gray-unmarking them. Use ZoneCellIter to automatically unmark them.
//
/* clang-format on */
template <typename GCType>
class ZoneAllCellIter : public ZoneAllCellIter<TenuredCell> {
 public:
  // Non-nursery allocated (equivalent to having an entry in
  // MapTypeToFinalizeKind). The template declaration here is to discard this
  // constructor overload if MapTypeToFinalizeKind<GCType>::kind does not
  // exist. Note that there will be no remaining overloads that will work,
  // which makes sense given that you haven't specified which of the
  // AllocKinds to use for GCType.
  //
  // If we later add a nursery allocable GCType with a single AllocKind, we
  // will want to add an overload of this constructor that does the right
  // thing (ie, it empties the nursery before iterating.)
  explicit ZoneAllCellIter(JS::Zone* zone) : ZoneAllCellIter<TenuredCell>() {
    init(zone, MapTypeToFinalizeKind<GCType>::kind);
  }

  // Non-nursery allocated, nursery is known to be empty: same behavior as
  // above.
  ZoneAllCellIter(JS::Zone* zone, const js::gc::AutoAssertEmptyNursery&)
      : ZoneAllCellIter(zone) {}

  // Arbitrary kind, which will be assumed to be nursery allocable (and
  // therefore the nursery will be emptied before iterating.)
  ZoneAllCellIter(JS::Zone* zone, AllocKind kind)
      : ZoneAllCellIter<TenuredCell>(zone, kind) {}

  // Arbitrary kind, which will be assumed to be nursery allocable, but the
  // nursery is known to be empty already: same behavior as non-nursery types.
  ZoneAllCellIter(JS::Zone* zone, AllocKind kind,
                  const js::gc::AutoAssertEmptyNursery& empty)
      : ZoneAllCellIter<TenuredCell>(zone, kind, empty) {}

  GCType* get() const { return ZoneAllCellIter<TenuredCell>::get<GCType>(); }
  operator GCType*() const { return get(); }
  GCType* operator->() const { return get(); }
};

// Like the above class but filter out cells that are about to be finalized.
// Also, read barrier all cells returned (unless the Unbarriered variants are
// used) to prevent gray cells from escaping.
template <typename T>
class ZoneCellIter : protected ZoneAllCellIter<T> {
  using Base = ZoneAllCellIter<T>;

 public:
  /*
   * The same constructors as above.
   */
  explicit ZoneCellIter(JS::Zone* zone) : ZoneAllCellIter<T>(zone) {
    skipDying();
  }
  ZoneCellIter(JS::Zone* zone, const js::gc::AutoAssertEmptyNursery& empty)
      : ZoneAllCellIter<T>(zone, empty) {
    skipDying();
  }
  ZoneCellIter(JS::Zone* zone, AllocKind kind)
      : ZoneAllCellIter<T>(zone, kind) {
    skipDying();
  }
  ZoneCellIter(JS::Zone* zone, AllocKind kind,
               const js::gc::AutoAssertEmptyNursery& empty)
      : ZoneAllCellIter<T>(zone, kind, empty) {
    skipDying();
  }

  using Base::done;

  void next() {
    ZoneAllCellIter<T>::next();
    skipDying();
  }

  TenuredCell* getCell() const {
    TenuredCell* cell = Base::getCell();

    // This can result in a new reference being created to an object that an
    // ongoing incremental GC may find to be unreachable, so we may need a
    // barrier here.
    JSRuntime* rt = cell->runtimeFromAnyThread();
    if (!JS::RuntimeHeapIsCollecting(rt->heapState())) {
      JS::TraceKind traceKind = JS::MapTypeToTraceKind<T>::kind;
      ExposeGCThingToActiveJS(JS::GCCellPtr(cell, traceKind));
    }

    return cell;
  }

  T* get() const { return reinterpret_cast<T*>(getCell()); }

  TenuredCell* unbarrieredGetCell() const { return Base::getCell(); }
  T* unbarrieredGet() const { return Base::get(); }
  operator T*() const { return get(); }
  T* operator->() const { return get(); }

 private:
  void skipDying() {
    while (!ZoneAllCellIter<T>::done()) {
      T* current = ZoneAllCellIter<T>::get();
      if (!IsAboutToBeFinalizedUnbarriered(&current)) {
        return;
      }
      ZoneAllCellIter<T>::next();
    }
  }
};

} /* namespace gc */
} /* namespace js */

#endif /* gc_GC_inl_h */
