/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsIDOMHTMLSourceElement.h"
#include "mozilla/dom/HTMLVideoElement.h"
#include "mozilla/dom/HTMLVideoElementBinding.h"
#include "nsGenericHTMLElement.h"
#include "nsGkAtoms.h"
#include "nsSize.h"
#include "nsError.h"
#include "nsNodeInfoManager.h"
#include "plbase64.h"
#include "nsXPCOMStrings.h"
#include "prlock.h"
#include "nsThreadUtils.h"
#include "ImageContainer.h"
#include "VideoFrameContainer.h"

#include "nsIScriptSecurityManager.h"
#include "nsIXPConnect.h"

#include "nsITimer.h"

#include "MediaError.h"
#include "MediaDecoder.h"
#include "mozilla/Preferences.h"
#include "mozilla/dom/WakeLock.h"
#include "mozilla/dom/power/PowerManagerService.h"
#include "mozilla/dom/Performance.h"
#include "mozilla/dom/VideoPlaybackQuality.h"

#include <algorithm>
#include <limits>

NS_IMPL_NS_NEW_HTML_ELEMENT(Video)

namespace mozilla {
namespace dom {

static bool sVideoStatsEnabled;

NS_IMPL_ELEMENT_CLONE(HTMLVideoElement)

HTMLVideoElement::HTMLVideoElement(already_AddRefed<NodeInfo>& aNodeInfo)
  : HTMLMediaElement(aNodeInfo)
  , mUseScreenWakeLock(true)
{
}

HTMLVideoElement::~HTMLVideoElement()
{
}

nsresult HTMLVideoElement::GetVideoSize(nsIntSize* size)
{
  if (!mMediaInfo.HasVideo()) {
    return NS_ERROR_FAILURE;
  }

  if (mDisableVideo) {
    return NS_ERROR_FAILURE;
  }

  switch (mMediaInfo.mVideo.mRotation) {
    case VideoInfo::Rotation::kDegree_90:
    case VideoInfo::Rotation::kDegree_270: {
      size->width = mMediaInfo.mVideo.mDisplay.height;
      size->height = mMediaInfo.mVideo.mDisplay.width;
      break;
    }
    case VideoInfo::Rotation::kDegree_0:
    case VideoInfo::Rotation::kDegree_180:
    default: {
      size->height = mMediaInfo.mVideo.mDisplay.height;
      size->width = mMediaInfo.mVideo.mDisplay.width;
      break;
    }
  }
  return NS_OK;
}

bool
HTMLVideoElement::ParseAttribute(int32_t aNamespaceID,
                                 nsIAtom* aAttribute,
                                 const nsAString& aValue,
                                 nsAttrValue& aResult)
{
   if (aAttribute == nsGkAtoms::width || aAttribute == nsGkAtoms::height) {
     return aResult.ParseSpecialIntValue(aValue);
   }

   return HTMLMediaElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                           aResult);
}

void
HTMLVideoElement::MapAttributesIntoRule(const nsMappedAttributes* aAttributes,
                                        nsRuleData* aData)
{
  nsGenericHTMLElement::MapImageSizeAttributesInto(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesInto(aAttributes, aData);
}

NS_IMETHODIMP_(bool)
HTMLVideoElement::IsAttributeMapped(const nsIAtom* aAttribute) const
{
  static const MappedAttributeEntry attributes[] = {
    { &nsGkAtoms::width },
    { &nsGkAtoms::height },
    { nullptr }
  };

  static const MappedAttributeEntry* const map[] = {
    attributes,
    sCommonAttributeMap
  };

  return FindAttributeDependence(aAttribute, map);
}

nsMapRuleToAttributesFunc
HTMLVideoElement::GetAttributeMappingFunction() const
{
  return &MapAttributesIntoRule;
}

nsresult HTMLVideoElement::SetAcceptHeader(nsIHttpChannel* aChannel)
{
  nsAutoCString value(
      "video/webm,"
      "video/ogg,"
      "video/*;q=0.9,"
      "application/ogg;q=0.7,"
      "audio/*;q=0.6,*/*;q=0.5");

  return aChannel->SetRequestHeader(NS_LITERAL_CSTRING("Accept"),
                                    value,
                                    false);
}

bool
HTMLVideoElement::IsInteractiveHTMLContent(bool aIgnoreTabindex) const
{
  return HasAttr(kNameSpaceID_None, nsGkAtoms::controls) ||
         HTMLMediaElement::IsInteractiveHTMLContent(aIgnoreTabindex);
}

uint32_t HTMLVideoElement::MozParsedFrames() const
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  if (!sVideoStatsEnabled) {
    return 0;
  }
  return mDecoder ? mDecoder->GetFrameStatistics().GetParsedFrames() : 0;
}

uint32_t HTMLVideoElement::MozDecodedFrames() const
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  if (!sVideoStatsEnabled) {
    return 0;
  }
  return mDecoder ? mDecoder->GetFrameStatistics().GetDecodedFrames() : 0;
}

uint32_t HTMLVideoElement::MozPresentedFrames() const
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  if (!sVideoStatsEnabled) {
    return 0;
  }
  return mDecoder ? mDecoder->GetFrameStatistics().GetPresentedFrames() : 0;
}

uint32_t HTMLVideoElement::MozPaintedFrames()
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  if (!sVideoStatsEnabled) {
    return 0;
  }
  layers::ImageContainer* container = GetImageContainer();
  return container ? container->GetPaintCount() : 0;
}

double HTMLVideoElement::MozFrameDelay()
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  VideoFrameContainer* container = GetVideoFrameContainer();
  // Hide negative delays. Frame timing tweaks in the compositor (e.g.
  // adding a bias value to prevent multiple dropped/duped frames when
  // frame times are aligned with composition times) may produce apparent
  // negative delay, but we shouldn't report that.
  return container ? std::max(0.0, container->GetFrameDelay()) : 0.0;
}

bool HTMLVideoElement::MozHasAudio() const
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  return HasAudio();
}

bool HTMLVideoElement::MozUseScreenWakeLock() const
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  return mUseScreenWakeLock;
}

void HTMLVideoElement::SetMozUseScreenWakeLock(bool aValue)
{
  MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread.");
  mUseScreenWakeLock = aValue;
  UpdateScreenWakeLock();
}

JSObject*
HTMLVideoElement::WrapNode(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return HTMLVideoElementBinding::Wrap(aCx, this, aGivenProto);
}

void
HTMLVideoElement::NotifyOwnerDocumentActivityChanged()
{
  HTMLMediaElement::NotifyOwnerDocumentActivityChanged();
  UpdateScreenWakeLock();
}

FrameStatistics*
HTMLVideoElement::GetFrameStatistics()
{
  return mDecoder ? &(mDecoder->GetFrameStatistics()) : nullptr;
}

already_AddRefed<VideoPlaybackQuality>
HTMLVideoElement::GetVideoPlaybackQuality()
{
  DOMHighResTimeStamp creationTime = 0;
  uint32_t totalFrames = 0;
  uint32_t droppedFrames = 0;
  uint32_t corruptedFrames = 0;

  if (sVideoStatsEnabled) {
    if (nsPIDOMWindowInner* window = OwnerDoc()->GetInnerWindow()) {
      Performance* perf = window->GetPerformance();
      if (perf) {
        creationTime = perf->Now();
      }
    }

    if (mDecoder) {
      FrameStatisticsData stats =
        mDecoder->GetFrameStatistics().GetFrameStatisticsData();
      if (sizeof(totalFrames) >= sizeof(stats.mParsedFrames)) {
        totalFrames = stats.mPresentedFrames + stats.mDroppedFrames;
        droppedFrames = stats.mDroppedFrames;
      } else {
        uint64_t total = stats.mPresentedFrames + stats.mDroppedFrames;
        const auto maxNumber = std::numeric_limits<uint32_t>::max();
        if (total <= maxNumber) {
          totalFrames = uint32_t(total);
          droppedFrames = uint32_t(stats.mDroppedFrames);
        } else {
          // Too big number(s) -> Resize everything to fit in 32 bits.
          double ratio = double(maxNumber) / double(total);
          totalFrames = maxNumber; // === total * ratio
          droppedFrames = uint32_t(double(stats.mDroppedFrames) * ratio);
        }
      }
      corruptedFrames = 0;
    }
  }

  RefPtr<VideoPlaybackQuality> playbackQuality =
    new VideoPlaybackQuality(this, creationTime, totalFrames, droppedFrames,
                             corruptedFrames);
  return playbackQuality.forget();
}

void
HTMLVideoElement::WakeLockCreate()
{
  HTMLMediaElement::WakeLockCreate();
  UpdateScreenWakeLock();
}

void
HTMLVideoElement::WakeLockRelease()
{
  UpdateScreenWakeLock();
  HTMLMediaElement::WakeLockRelease();
}

void
HTMLVideoElement::UpdateScreenWakeLock()
{
  bool hidden = OwnerDoc()->Hidden();

  if (mScreenWakeLock && (mPaused || hidden || !mUseScreenWakeLock)) {
    ErrorResult rv;
    mScreenWakeLock->Unlock(rv);
    rv.SuppressException();
    mScreenWakeLock = nullptr;
    return;
  }

  if (!mScreenWakeLock && !mPaused && !hidden &&
      mUseScreenWakeLock && HasVideo()) {
    RefPtr<power::PowerManagerService> pmService =
      power::PowerManagerService::GetInstance();
    NS_ENSURE_TRUE_VOID(pmService);

    ErrorResult rv;
    mScreenWakeLock = pmService->NewWakeLock(NS_LITERAL_STRING("screen"),
                                             OwnerDoc()->GetInnerWindow(),
                                             rv);
  }
}

void
HTMLVideoElement::Init()
{
  Preferences::AddBoolVarCache(&sVideoStatsEnabled, "media.video_stats.enabled");
}

} // namespace dom
} // namespace mozilla
