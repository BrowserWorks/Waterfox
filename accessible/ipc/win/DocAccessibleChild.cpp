/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DocAccessibleChild.h"

#include "Accessible-inl.h"
#include "mozilla/a11y/PlatformChild.h"
#include "mozilla/ClearOnShutdown.h"
#include "RootAccessible.h"

namespace mozilla {
namespace a11y {

static StaticAutoPtr<PlatformChild> sPlatformChild;

DocAccessibleChild::DocAccessibleChild(DocAccessible* aDoc)
  : DocAccessibleChildBase(aDoc)
  , mIsRemoteConstructed(false)
{
  MOZ_COUNT_CTOR_INHERITED(DocAccessibleChild, DocAccessibleChildBase);
  if (!sPlatformChild) {
    sPlatformChild = new PlatformChild();
    ClearOnShutdown(&sPlatformChild, ShutdownPhase::Shutdown);
  }
}

DocAccessibleChild::~DocAccessibleChild()
{
  MOZ_COUNT_DTOR_INHERITED(DocAccessibleChild, DocAccessibleChildBase);
}

void
DocAccessibleChild::Shutdown()
{
  if (IsConstructedInParentProcess()) {
    DocAccessibleChildBase::Shutdown();
    return;
  }

  PushDeferredEvent(MakeUnique<SerializedShutdown>(this));
  DetachDocument();
}

bool
DocAccessibleChild::RecvParentCOMProxy(const IAccessibleHolder& aParentCOMProxy)
{
  MOZ_ASSERT(!mParentProxy && !aParentCOMProxy.IsNull());
  mParentProxy.reset(const_cast<IAccessibleHolder&>(aParentCOMProxy).Release());
  SetConstructedInParentProcess();

  for (uint32_t i = 0, l = mDeferredEvents.Length(); i < l; ++i) {
    mDeferredEvents[i]->Dispatch();
  }

  mDeferredEvents.Clear();

  return true;
}

void
DocAccessibleChild::PushDeferredEvent(UniquePtr<DeferredEvent> aEvent)
{
  DocAccessibleChild* topLevelIPCDoc = nullptr;

  if (mDoc && mDoc->IsRoot()) {
    topLevelIPCDoc = this;
  } else {
    auto tabChild = static_cast<dom::TabChild*>(Manager());
    if (!tabChild) {
      return;
    }

    nsTArray<PDocAccessibleChild*> ipcDocAccs;
    tabChild->ManagedPDocAccessibleChild(ipcDocAccs);

    // Look for the top-level DocAccessibleChild - there will only be one
    // per TabChild.
    for (uint32_t i = 0, l = ipcDocAccs.Length(); i < l; ++i) {
      auto ipcDocAcc = static_cast<DocAccessibleChild*>(ipcDocAccs[i]);
      if (ipcDocAcc->mDoc && ipcDocAcc->mDoc->IsRoot()) {
        topLevelIPCDoc = ipcDocAcc;
        break;
      }
    }
  }

  if (topLevelIPCDoc) {
    topLevelIPCDoc->mDeferredEvents.AppendElement(Move(aEvent));
  }
}

bool
DocAccessibleChild::SendEvent(const uint64_t& aID, const uint32_t& aType)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendEvent(aID, aType);
  }

  PushDeferredEvent(MakeUnique<SerializedEvent>(this, aID, aType));
  return false;
}

void
DocAccessibleChild::MaybeSendShowEvent(ShowEventData& aData, bool aFromUser)
{
  if (IsConstructedInParentProcess()) {
    Unused << SendShowEvent(aData, aFromUser);
    return;
  }

  PushDeferredEvent(MakeUnique<SerializedShow>(this, aData, aFromUser));
}

bool
DocAccessibleChild::SendHideEvent(const uint64_t& aRootID,
                                  const bool& aFromUser)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendHideEvent(aRootID, aFromUser);
  }

  PushDeferredEvent(MakeUnique<SerializedHide>(this, aRootID, aFromUser));
  return true;
}

bool
DocAccessibleChild::SendStateChangeEvent(const uint64_t& aID,
                                         const uint64_t& aState,
                                         const bool& aEnabled)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendStateChangeEvent(aID, aState, aEnabled);
  }

  PushDeferredEvent(MakeUnique<SerializedStateChange>(this, aID, aState,
                                                      aEnabled));
  return true;
}

bool
DocAccessibleChild::SendCaretMoveEvent(const uint64_t& aID,
                                       const int32_t& aOffset)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendCaretMoveEvent(aID, aOffset);
  }

  PushDeferredEvent(MakeUnique<SerializedCaretMove>(this, aID, aOffset));
  return true;
}

bool
DocAccessibleChild::SendTextChangeEvent(const uint64_t& aID,
                                        const nsString& aStr,
                                        const int32_t& aStart,
                                        const uint32_t& aLen,
                                        const bool& aIsInsert,
                                        const bool& aFromUser)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendTextChangeEvent(aID, aStr, aStart,
                                                    aLen, aIsInsert, aFromUser);
  }

  PushDeferredEvent(MakeUnique<SerializedTextChange>(this, aID, aStr, aStart,
                                                     aLen, aIsInsert, aFromUser));
  return true;
}

bool
DocAccessibleChild::SendSelectionEvent(const uint64_t& aID,
                                       const uint64_t& aWidgetID,
                                       const uint32_t& aType)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendSelectionEvent(aID, aWidgetID, aType);
  }

  PushDeferredEvent(MakeUnique<SerializedSelection>(this, aID,
                                                                aWidgetID,
                                                                aType));
  return true;
}

bool
DocAccessibleChild::SendRoleChangedEvent(const uint32_t& aRole)
{
  if (IsConstructedInParentProcess()) {
    return PDocAccessibleChild::SendRoleChangedEvent(aRole);
  }

  PushDeferredEvent(MakeUnique<SerializedRoleChanged>(this, aRole));
  return true;
}

bool
DocAccessibleChild::ConstructChildDocInParentProcess(
                                        DocAccessibleChild* aNewChildDoc,
                                        uint64_t aUniqueID, uint32_t aMsaaID)
{
  if (IsConstructedInParentProcess()) {
    // We may send the constructor immediately
    auto tabChild = static_cast<dom::TabChild*>(Manager());
    MOZ_ASSERT(tabChild);
    bool result = tabChild->SendPDocAccessibleConstructor(aNewChildDoc, this,
                                                          aUniqueID, aMsaaID,
                                                          IAccessibleHolder());
    if (result) {
      aNewChildDoc->SetConstructedInParentProcess();
    }
    return result;
  }

  PushDeferredEvent(MakeUnique<SerializedChildDocConstructor>(aNewChildDoc, this,
                                                              aUniqueID, aMsaaID));
  return true;
}

bool
DocAccessibleChild::SendBindChildDoc(DocAccessibleChild* aChildDoc,
                                     const uint64_t& aNewParentID)
{
  if (IsConstructedInParentProcess()) {
    return DocAccessibleChildBase::SendBindChildDoc(aChildDoc, aNewParentID);
  }

  PushDeferredEvent(MakeUnique<SerializedBindChildDoc>(this, aChildDoc,
                                                       aNewParentID));
  return true;
}

} // namespace a11y
} // namespace mozilla

