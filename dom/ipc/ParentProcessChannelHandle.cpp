/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ParentProcessChannelHandle.h"

#include "mozilla/dom/CanonicalBrowsingContext.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/WindowGlobalParent.h"

namespace mozilla::dom {

ParentProcessChannelHandle::ParentProcessChannelHandle(
    const ExpectedContext& aExpectedContext, nsIChannel* aChannel,
    uint64_t aHistoryLoadId)
    : mUuidOrRecord(VariantType<Record>{},
                    Record{
                        .mExpectedContext = aExpectedContext,
                        .mChannel = aChannel,
                        .mHistoryLoadId = aHistoryLoadId,
                    }) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(XRE_IsParentProcess());
}

ParentProcessChannelHandle::ParentProcessChannelHandle(const nsID& aUuid)
    : mUuidOrRecord(VariantType<nsID>{}, aUuid) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(XRE_IsContentProcess());
}

Result<nsCOMPtr<nsIChannel>, StaticString>
ParentProcessChannelHandle::GetChannel(
    CanonicalBrowsingContext* aBrowsingContext,
    WindowGlobalParent* aStaticCloneOf) const {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(mUuidOrRecord.is<Record>());

  const Record& record = mUuidOrRecord.as<Record>();

  // Static clones do not create additional requests, meaning that channels will
  // be attributed to the original BrowsingContext which was statically cloned.
  if (aStaticCloneOf) {
    aBrowsingContext = aStaticCloneOf->BrowsingContext();
  }

  MOZ_TRY(record.mExpectedContext.match(
      [&](const ParentProcessChannelHandle::ExpectLoadedWithin& aExpect)
          -> Result<Ok, StaticString> {
        if (aExpect.mBrowsingContextId != aBrowsingContext->Id()) {
          return Err(StaticString("wrong browsing context"));
        }
        return Ok();
      },
      [&](const ParentProcessChannelHandle::ExpectChildOf& aExpect)
          -> Result<Ok, StaticString> {
        if (!aBrowsingContext->GetParentWindowContext()) {
          return Err(StaticString("missing parent window context"));
        }
        if (aExpect.mParentWindowId !=
            aBrowsingContext->GetParentWindowContext()->InnerWindowId()) {
          return Err(StaticString("wrong parent window context"));
        }
        return Ok();
      }));

  return record.mChannel;
}

uint64_t ParentProcessChannelHandle::HistoryLoadId() const {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(mUuidOrRecord.is<Record>());

  return mUuidOrRecord.as<Record>().mHistoryLoadId;
}

const nsID& ParentProcessChannelHandle::GetUuid() const {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(XRE_IsContentProcess());
  MOZ_ASSERT(mUuidOrRecord.is<nsID>());

  return mUuidOrRecord.as<nsID>();
}

ParentProcessChannelHandle::~ParentProcessChannelHandle() {
  MOZ_ASSERT(NS_IsMainThread());

  // If we're in a content process, let our ContentParent know that there are no
  // more references to this uuid.
  if (XRE_IsContentProcess()) {
    MOZ_ASSERT(mUuidOrRecord.is<nsID>());
    RefPtr<ContentChild> cc = ContentChild::GetSingleton();
    if (cc && cc->CanSend()) {
      cc->SendDropParentProcessChannelHandle(mUuidOrRecord.as<nsID>());
    }
  }
}

}  // namespace mozilla::dom

namespace IPC {

void ParamTraits<mozilla::dom::ParentProcessChannelHandle*>::Write(
    MessageWriter* aWriter, paramType* aParam) {
  IPC::WriteParam(aWriter, !!aParam);
  if (!aParam) {
    return;
  }

  if (!aWriter->GetActor() ||
      aWriter->GetActor()->ToplevelProtocol()->GetProtocolId() !=
          PContentMsgStart) {
    aWriter->FatalError(
        "ParentProcessChannelHandle can only be sent over PContent");
    return;
  }

  if (XRE_IsContentProcess()) {
    MOZ_RELEASE_ASSERT(aWriter->GetActor()->GetSide() ==
                       mozilla::ipc::ChildSide);
    IPC::WriteParam(aWriter, aParam->GetUuid());
  } else {
    MOZ_RELEASE_ASSERT(aWriter->GetActor()->GetSide() ==
                       mozilla::ipc::ParentSide);
    mozilla::dom::ContentParent* cp = static_cast<mozilla::dom::ContentParent*>(
        aWriter->GetActor()->ToplevelProtocol());
    nsID uuid = cp->AddParentProcessChannelHandle(aParam);
    IPC::WriteParam(aWriter, uuid);
  }
}

bool ParamTraits<mozilla::dom::ParentProcessChannelHandle*>::Read(
    MessageReader* aReader, RefPtr<paramType>* aResult) {
  bool nonNull = false;
  if (!IPC::ReadParam(aReader, &nonNull)) {
    return false;
  }
  if (!nonNull) {
    *aResult = nullptr;
    return true;
  }

  if (!aReader->GetActor() ||
      aReader->GetActor()->ToplevelProtocol()->GetProtocolId() !=
          PContentMsgStart) {
    aReader->FatalError(
        "ParentProcessChannelHandle can only be sent over PContent");
    return false;
  }

  nsID uuid{};
  if (!IPC::ReadParam(aReader, &uuid)) {
    return false;
  }

  if (XRE_IsContentProcess()) {
    MOZ_RELEASE_ASSERT(aReader->GetActor()->GetSide() ==
                       mozilla::ipc::ChildSide);
    *aResult = new paramType(uuid);
    return true;
  }

  MOZ_RELEASE_ASSERT(aReader->GetActor()->GetSide() ==
                     mozilla::ipc::ParentSide);
  mozilla::dom::ContentParent* cp = static_cast<mozilla::dom::ContentParent*>(
      aReader->GetActor()->ToplevelProtocol());
  *aResult = cp->ReadParentProcessChannelHandle(uuid);
  return *aResult != nullptr;
}

}  // namespace IPC
