/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/BasePrincipal.h"
#include "nsIBrowserDOMWindow.h"
#include "nsString.h"

namespace mozilla {
class OriginAttributes;
}

class nsOpenURIInFrameParams final : public nsIOpenURIInFrameParams
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOPENURIINFRAMEPARAMS

  explicit nsOpenURIInFrameParams(const mozilla::OriginAttributes& aOriginAttributes);

private:
  ~nsOpenURIInFrameParams();

  mozilla::OriginAttributes mOpenerOriginAttributes;
  nsString mReferrer;
};
