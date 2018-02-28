/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:expandtab:shiftwidth=2:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#include "nsString.h"
#include "nsUTF8ConverterService.h"
#include "nsEscape.h"
#include "mozilla/Encoding.h"

using namespace mozilla;

NS_IMPL_ISUPPORTS(nsUTF8ConverterService, nsIUTF8ConverterService)

static nsresult
ToUTF8(const nsACString& aString,
       const char* aCharset,
       bool aAllowSubstitution,
       nsACString& aResult)
{
  if (!aCharset || !*aCharset)
    return NS_ERROR_INVALID_ARG;

  auto encoding = Encoding::ForLabelNoReplacement(MakeStringSpan(aCharset));
  if (!encoding) {
    return NS_ERROR_UCONV_NOCONV;
  }
  if (aAllowSubstitution) {
    nsresult rv = encoding->DecodeWithoutBOMHandling(aString, aResult);
    if (NS_SUCCEEDED(rv)) {
      return NS_OK;
    }
    return rv;
  }
  return encoding->DecodeWithoutBOMHandlingAndWithoutReplacement(aString,
                                                                 aResult);
}

NS_IMETHODIMP
nsUTF8ConverterService::ConvertStringToUTF8(const nsACString& aString,
                                            const char* aCharset,
                                            bool aSkipCheck,
                                            bool aAllowSubstitution,
                                            uint8_t aOptionalArgc,
                                            nsACString& aUTF8String)
{
  bool allowSubstitution = (aOptionalArgc == 1) ? aAllowSubstitution : true;

  // return if ASCII only or valid UTF-8 providing that the ASCII/UTF-8
  // check is requested. It may not be asked for if a caller suspects
  // that the input is in non-ASCII 7bit charset (ISO-2022-xx, HZ) or
  // it's in a charset other than UTF-8 that can be mistaken for UTF-8.
  if (!aSkipCheck && (IsASCII(aString) || IsUTF8(aString))) {
    aUTF8String = aString;
    return NS_OK;
  }

  aUTF8String.Truncate();

  nsresult rv = ToUTF8(aString, aCharset, allowSubstitution, aUTF8String);

  // additional protection for cases where check is skipped and  the input
  // is actually in UTF-8 as opposed to aCharset. (i.e. caller's hunch
  // was wrong.) We don't check ASCIIness assuming there's no charset
  // incompatible with ASCII (we don't support EBCDIC).
  if (aSkipCheck && NS_FAILED(rv) && IsUTF8(aString)) {
    aUTF8String = aString;
    return NS_OK;
  }

  return rv;
}

NS_IMETHODIMP
nsUTF8ConverterService::ConvertURISpecToUTF8(const nsACString& aSpec,
                                             const char* aCharset,
                                             nsACString& aUTF8Spec)
{
  // assume UTF-8 if the spec contains unescaped non-ASCII characters.
  // No valid spec in Mozilla would break this assumption.
  if (!IsASCII(aSpec)) {
    aUTF8Spec = aSpec;
    return NS_OK;
  }

  aUTF8Spec.Truncate();

  nsAutoCString unescapedSpec;
  // NS_UnescapeURL does not fill up unescapedSpec unless there's at least
  // one character to unescape.
  bool written = NS_UnescapeURL(PromiseFlatCString(aSpec).get(),
                                aSpec.Length(),
                                esc_OnlyNonASCII,
                                unescapedSpec);

  if (!written) {
    aUTF8Spec = aSpec;
    return NS_OK;
  }
  // return if ASCII only or escaped UTF-8
  if (IsASCII(unescapedSpec) || IsUTF8(unescapedSpec)) {
    aUTF8Spec = unescapedSpec;
    return NS_OK;
  }

  return ToUTF8(unescapedSpec, aCharset, true, aUTF8Spec);
}

