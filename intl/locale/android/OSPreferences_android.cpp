/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "OSPreferences.h"
#include "mozilla/Preferences.h"

using namespace mozilla::intl;

bool
OSPreferences::ReadSystemLocales(nsTArray<nsCString>& aLocaleList)
{
  //XXX: This is a quite sizable hack to work around the fact that we cannot
  //     retrieve OS locale in C++ without reaching out to JNI.
  //     Once we fix this (bug 1337078), this hack should not be necessary.
  //
  //XXX: Notice, this value may be empty on an early read. In that case
  //     we won't add anything to the return list so that it doesn't get
  //     cached in mSystemLocales.
  nsAdoptingCString locale = Preferences::GetCString("intl.locale.os");
  if (!locale.IsEmpty()) {
    aLocaleList.AppendElement(locale);
    return true;
  }
  return false;
}

bool
OSPreferences::ReadDateTimePattern(DateTimeFormatStyle aDateStyle,
                                   DateTimeFormatStyle aTimeStyle,
                                   const nsACString& aLocale, nsAString& aRetVal)
{
  return false;
}
