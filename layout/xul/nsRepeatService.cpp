/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
// Eric Vaughan
// Netscape Communications
//
// See documentation in associated header file
//

#include "nsRepeatService.h"
#include "mozilla/StaticPtr.h"
#include "nsIDocument.h"
#include "nsIServiceManager.h"

using namespace mozilla;

static StaticAutoPtr<nsRepeatService> gRepeatService;

nsRepeatService::nsRepeatService()
: mCallback(nullptr), mCallbackData(nullptr)
{
}

nsRepeatService::~nsRepeatService()
{
  NS_ASSERTION(!mCallback && !mCallbackData, "Callback was not removed before shutdown");
}

/* static */ nsRepeatService*
nsRepeatService::GetInstance()
{
  if (!gRepeatService) {
    gRepeatService = new nsRepeatService();
  }
  return gRepeatService;
}

/*static*/ void
nsRepeatService::Shutdown()
{
  gRepeatService = nullptr;
}

void
nsRepeatService::Start(Callback aCallback, void* aCallbackData,
                       nsIDocument* aDocument, const nsACString& aCallbackName,
                       uint32_t aInitialDelay)
{
  NS_PRECONDITION(aCallback != nullptr, "null ptr");

  mCallback = aCallback;
  mCallbackData = aCallbackData;
  mCallbackName = aCallbackName;

  nsresult rv;
  mRepeatTimer = do_CreateInstance("@mozilla.org/timer;1", &rv);

  if (NS_SUCCEEDED(rv))  {
    mRepeatTimer->SetTarget(aDocument->EventTargetFor(TaskCategory::Other));
    InitTimerCallback(aInitialDelay);
  }
}

void nsRepeatService::Stop(Callback aCallback, void* aCallbackData)
{
  if (mCallback != aCallback || mCallbackData != aCallbackData)
    return;

  //printf("Stopping repeat timer\n");
  if (mRepeatTimer) {
     mRepeatTimer->Cancel();
     mRepeatTimer = nullptr;
  }
  mCallback = nullptr;
  mCallbackData = nullptr;
}

void
nsRepeatService::InitTimerCallback(uint32_t aInitialDelay)
{
  if (!mRepeatTimer) {
    return;
  }

  mRepeatTimer->InitWithNamedFuncCallback([](nsITimer* aTimer, void* aClosure) {
    // Use gRepeatService instead of nsRepeatService::GetInstance() (because
    // we don't want nsRepeatService::GetInstance() to re-create a new instance
    // for us, if we happen to get invoked after nsRepeatService::Shutdown() has
    // nulled out gRepeatService).
    nsRepeatService* rs = gRepeatService;
    if (!rs) {
      return;
    }

    if (rs->mCallback) {
      rs->mCallback(rs->mCallbackData);
    }

    rs->InitTimerCallback(REPEAT_DELAY);
  }, nullptr, aInitialDelay, nsITimer::TYPE_ONE_SHOT, mCallbackName.Data());
}
