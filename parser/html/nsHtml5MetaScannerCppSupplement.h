/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 
#include "nsEncoderDecoderUtils.h"
#include "nsISupportsImpl.h"

#include "mozilla/dom/EncodingUtils.h"

using mozilla::dom::EncodingUtils;

void
nsHtml5MetaScanner::sniff(nsHtml5ByteReadable* bytes, nsACString& charset)
{
  readable = bytes;
  stateLoop(stateSave);
  readable = nullptr;
  charset.Assign(mCharset);
}

bool
nsHtml5MetaScanner::tryCharset(nsHtml5String charset)
{
  // This code needs to stay in sync with
  // nsHtml5StreamParser::internalEncodingDeclaration. Unfortunately, the
  // trickery with member fields here leads to some copy-paste reuse. :-(
  nsAutoCString label;
  nsString charset16; // Not Auto, because using it to hold nsStringBuffer*
  charset.ToString(charset16);
  CopyUTF16toUTF8(charset16, label);
  nsAutoCString encoding;
  if (!EncodingUtils::FindEncodingForLabel(label, encoding)) {
    return false;
  }
  if (encoding.EqualsLiteral("UTF-16BE") ||
      encoding.EqualsLiteral("UTF-16LE")) {
    mCharset.AssignLiteral("UTF-8");
    return true;
  }
  if (encoding.EqualsLiteral("x-user-defined")) {
    // WebKit/Blink hack for Indian and Armenian legacy sites
    mCharset.AssignLiteral("windows-1252");
    return true;
  }
  mCharset.Assign(encoding);
  return true;
}
