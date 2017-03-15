/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "RootAccessibleWrap.h"

#include "Compatibility.h"
#include "nsCoreUtils.h"
#include "nsWinUtils.h"

using namespace mozilla::a11y;

////////////////////////////////////////////////////////////////////////////////
// Constructor/destructor

RootAccessibleWrap::
  RootAccessibleWrap(nsIDocument* aDocument, nsIPresShell* aPresShell) :
  RootAccessible(aDocument, aPresShell)
{
}

RootAccessibleWrap::~RootAccessibleWrap()
{
}

////////////////////////////////////////////////////////////////////////////////
// RootAccessible

void
RootAccessibleWrap::DocumentActivated(DocAccessible* aDocument)
{
  if (Compatibility::IsDolphin() &&
      nsCoreUtils::IsTabDocument(aDocument->DocumentNode())) {
    uint32_t count = mChildDocuments.Length();
    for (uint32_t idx = 0; idx < count; idx++) {
      DocAccessible* childDoc = mChildDocuments[idx];
      HWND childDocHWND = static_cast<HWND>(childDoc->GetNativeWindow());
      if (childDoc != aDocument)
        nsWinUtils::HideNativeWindow(childDocHWND);
      else
        nsWinUtils::ShowNativeWindow(childDocHWND);
    }
  }
}
