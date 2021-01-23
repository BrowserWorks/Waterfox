/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gc/WeakMap-inl.h"

#include <string.h>

#include "jsapi.h"
#include "jsfriendapi.h"

#include "gc/PublicIterators.h"
#include "js/Wrapper.h"
#include "vm/GlobalObject.h"
#include "vm/JSContext.h"
#include "vm/JSObject.h"

#include "vm/JSObject-inl.h"

using namespace js;
using namespace js::gc;

WeakMapBase::WeakMapBase(JSObject* memOf, Zone* zone)
    : memberOf(memOf), zone_(zone), mapColor(CellColor::White) {
  MOZ_ASSERT_IF(memberOf, memberOf->compartment()->zone() == zone);
}

WeakMapBase::~WeakMapBase() {
  MOZ_ASSERT(CurrentThreadIsGCFinalizing() ||
             CurrentThreadCanAccessZone(zone_));
}

void WeakMapBase::unmarkZone(JS::Zone* zone) {
  AutoEnterOOMUnsafeRegion oomUnsafe;
  if (!zone->gcWeakKeys().clear()) {
    oomUnsafe.crash("clearing weak keys table");
  }
  MOZ_ASSERT(zone->gcNurseryWeakKeys().count() == 0);

  for (WeakMapBase* m : zone->gcWeakMapList()) {
    m->mapColor = CellColor::White;
  }
}

void WeakMapBase::traceZone(JS::Zone* zone, JSTracer* tracer) {
  MOZ_ASSERT(tracer->weakMapAction() != DoNotTraceWeakMaps);
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    m->trace(tracer);
    TraceNullableEdge(tracer, &m->memberOf, "memberOf");
  }
}

#if defined(JS_GC_ZEAL) || defined(DEBUG)
bool WeakMapBase::checkMarkingForZone(JS::Zone* zone) {
  // This is called at the end of marking.
  MOZ_ASSERT(zone->isGCMarking());

  bool ok = true;
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    if (m->mapColor && !m->checkMarking()) {
      ok = false;
    }
  }

  return ok;
}
#endif

bool WeakMapBase::markZoneIteratively(JS::Zone* zone, GCMarker* marker) {
  bool markedAny = false;
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    if (m->mapColor && m->markEntries(marker)) {
      markedAny = true;
    }
  }
  return markedAny;
}

bool WeakMapBase::findSweepGroupEdgesForZone(JS::Zone* zone) {
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    if (!m->findSweepGroupEdges()) {
      return false;
    }
  }
  return true;
}

void WeakMapBase::sweepZone(JS::Zone* zone) {
  for (WeakMapBase* m = zone->gcWeakMapList().getFirst(); m;) {
    WeakMapBase* next = m->getNext();
    if (m->mapColor) {
      m->sweep();
    } else {
      m->clearAndCompact();
      m->removeFrom(zone->gcWeakMapList());
    }
    m = next;
  }

#ifdef DEBUG
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    MOZ_ASSERT(m->isInList() && m->mapColor);
  }
#endif
}

void WeakMapBase::traceAllMappings(WeakMapTracer* tracer) {
  JSRuntime* rt = tracer->runtime;
  for (ZonesIter zone(rt, SkipAtoms); !zone.done(); zone.next()) {
    for (WeakMapBase* m : zone->gcWeakMapList()) {
      // The WeakMapTracer callback is not allowed to GC.
      JS::AutoSuppressGCAnalysis nogc;
      m->traceMappings(tracer);
    }
  }
}

bool WeakMapBase::saveZoneMarkedWeakMaps(JS::Zone* zone,
                                         WeakMapColors& markedWeakMaps) {
  for (WeakMapBase* m : zone->gcWeakMapList()) {
    if (m->mapColor && !markedWeakMaps.put(m, m->mapColor)) {
      return false;
    }
  }
  return true;
}

void WeakMapBase::restoreMarkedWeakMaps(WeakMapColors& markedWeakMaps) {
  for (WeakMapColors::Range r = markedWeakMaps.all(); !r.empty();
       r.popFront()) {
    WeakMapBase* map = r.front().key();
    MOZ_ASSERT(map->zone()->isGCMarking());
    MOZ_ASSERT(map->mapColor == CellColor::White);
    map->mapColor = r.front().value();
  }
}

size_t ObjectValueWeakMap::sizeOfIncludingThis(
    mozilla::MallocSizeOf mallocSizeOf) {
  return mallocSizeOf(this) + shallowSizeOfExcludingThis(mallocSizeOf);
}

bool ObjectValueWeakMap::findSweepGroupEdges() {
  // For weakmap keys with delegates in a different zone, add a zone edge to
  // ensure that the delegate zone finishes marking before the key zone.
  JS::AutoSuppressGCAnalysis nogc;
  for (Range r = all(); !r.empty(); r.popFront()) {
    JSObject* key = r.front().key();
    JSObject* delegate = gc::detail::GetDelegate(key);
    if (!delegate) {
      continue;
    }

    // Marking a WeakMap key's delegate will mark the key, so process the
    // delegate zone no later than the key zone.
    Zone* delegateZone = delegate->zone();
    if (delegateZone != zone() && delegateZone->isGCMarking()) {
      if (!delegateZone->addSweepGroupEdgeTo(key->zone())) {
        return false;
      }
    }
  }
  return true;
}

ObjectWeakMap::ObjectWeakMap(JSContext* cx) : map(cx, nullptr) {}

JSObject* ObjectWeakMap::lookup(const JSObject* obj) {
  if (ObjectValueWeakMap::Ptr p = map.lookup(const_cast<JSObject*>(obj))) {
    return &p->value().toObject();
  }
  return nullptr;
}

bool ObjectWeakMap::add(JSContext* cx, JSObject* obj, JSObject* target) {
  MOZ_ASSERT(obj && target);

  Value targetVal(ObjectValue(*target));
  if (!map.putNew(obj, targetVal)) {
    ReportOutOfMemory(cx);
    return false;
  }

  return true;
}

void ObjectWeakMap::remove(JSObject* key) {
  MOZ_ASSERT(key);
  map.remove(key);
}

void ObjectWeakMap::clear() { map.clear(); }

void ObjectWeakMap::trace(JSTracer* trc) { map.trace(trc); }

size_t ObjectWeakMap::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) {
  return map.shallowSizeOfExcludingThis(mallocSizeOf);
}

#ifdef JSGC_HASH_TABLE_CHECKS
void ObjectWeakMap::checkAfterMovingGC() {
  for (ObjectValueWeakMap::Range r = map.all(); !r.empty(); r.popFront()) {
    CheckGCThingAfterMovingGC(r.front().key().get());
    CheckGCThingAfterMovingGC(&r.front().value().toObject());
  }
}
#endif  // JSGC_HASH_TABLE_CHECKS
