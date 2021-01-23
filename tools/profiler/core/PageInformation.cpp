/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "PageInformation.h"

#include "ProfileJSONWriter.h"

PageInformation::PageInformation(uint64_t aBrowsingContextID,
                                 uint64_t aInnerWindowID, const nsCString& aUrl,
                                 uint64_t aEmbedderInnerWindowID)
    : mBrowsingContextID(aBrowsingContextID),
      mInnerWindowID(aInnerWindowID),
      mUrl(aUrl),
      mEmbedderInnerWindowID(aEmbedderInnerWindowID) {}

bool PageInformation::Equals(PageInformation* aOtherPageInfo) const {
  // It's enough to check inner window IDs because they are unique for each
  // page. Therefore, we don't have to check browsing context ID or url.
  return InnerWindowID() == aOtherPageInfo->InnerWindowID();
}

void PageInformation::StreamJSON(SpliceableJSONWriter& aWriter) const {
  // Here, we are converting uint64_t to double. Both Browsing Context and Inner
  // Window IDs are creating using `nsContentUtils::GenerateProcessSpecificId`,
  // which is specifically designed to only use 53 of the 64 bits to be lossless
  // when passed into and out of JS as a double.
  aWriter.StartObjectElement();
  aWriter.DoubleProperty("browsingContextID", BrowsingContextID());
  aWriter.DoubleProperty("innerWindowID", InnerWindowID());
  aWriter.StringProperty("url", Url().get());
  aWriter.DoubleProperty("embedderInnerWindowID", EmbedderInnerWindowID());
  aWriter.EndObject();
}

size_t PageInformation::SizeOfIncludingThis(
    mozilla::MallocSizeOf aMallocSizeOf) const {
  return aMallocSizeOf(this);
}
