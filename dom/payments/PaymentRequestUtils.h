/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_PaymentRequestUtils_h
#define mozilla_dom_PaymentRequestUtils_h

#include "nsIArray.h"
#include "nsTArray.h"

namespace mozilla {
namespace dom {

nsresult
ConvertStringstoISupportsStrings(const nsTArray<nsString>& aStrings,
                                 nsIArray** aIStrings);

nsresult
ConvertISupportsStringstoStrings(nsIArray* aIStrings,
                                 nsTArray<nsString>& aStrings);

nsresult
CopyISupportsStrings(nsIArray* aSourceStrings, nsIArray** aTargetStrings);

} // end of namespace dom
} // end of namespace mozilla

#endif
