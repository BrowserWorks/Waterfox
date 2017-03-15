/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsCycleCollectionParticipant.h"
#include "jsapi.h"
#include "jsfriendapi.h"

void
CycleCollectionNoteEdgeNameImpl(nsCycleCollectionTraversalCallback& aCallback,
                                const char* aName,
                                uint32_t aFlags)
{
  nsAutoCString arrayEdgeName(aName);
  if (aFlags & CycleCollectionEdgeNameArrayFlag) {
    arrayEdgeName.AppendLiteral("[i]");
  }
  aCallback.NoteNextEdgeName(arrayEdgeName.get());
}

void
nsScriptObjectTracer::NoteJSChild(JS::GCCellPtr aGCThing, const char* aName,
                                  void* aClosure)
{
  nsCycleCollectionTraversalCallback* cb =
    static_cast<nsCycleCollectionTraversalCallback*>(aClosure);
  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(*cb, aName);
  if (mozilla::AddToCCKind(aGCThing.kind())) {
    cb->NoteJSChild(aGCThing);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<JS::Value>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (aPtr->unbarrieredGet().isMarkable()) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGet()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<jsid>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (JSID_IS_GCTHING(aPtr->unbarrieredGet())) {
    mCallback(JSID_TO_GCTHING(aPtr->unbarrieredGet()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<JSObject*>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGet()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JSObject** aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(*aPtr), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::TenuredHeap<JSObject*>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGetPtr()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<JSFunction*>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGet()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<JSString*>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGet()), aName, aClosure);
  }
}

void
TraceCallbackFunc::Trace(JS::Heap<JSScript*>* aPtr, const char* aName,
                         void* aClosure) const
{
  if (*aPtr) {
    mCallback(JS::GCCellPtr(aPtr->unbarrieredGet()), aName, aClosure);
  }
}
