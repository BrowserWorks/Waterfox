/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This is a shared part of the OSPreferences API implementation.
 * It defines helper methods and public methods that are calling
 * platform-specific private methods.
 */

#include "OSPreferences.h"

#include "mozilla/ClearOnShutdown.h"
#include "mozilla/Services.h"
#include "nsIObserverService.h"
#ifdef ENABLE_INTL_API
#include "unicode/udat.h"
#include "unicode/udatpg.h"
#endif

using namespace mozilla::intl;

NS_IMPL_ISUPPORTS(OSPreferences, mozIOSPreferences)

mozilla::StaticRefPtr<OSPreferences> OSPreferences::sInstance;

OSPreferences*
OSPreferences::GetInstance()
{
  if (!sInstance) {
    sInstance = new OSPreferences();
    ClearOnShutdown(&sInstance);
  }
  return sInstance;
}

bool
OSPreferences::GetSystemLocales(nsTArray<nsCString>& aRetVal)
{
  if (!mSystemLocales.IsEmpty()) {
    aRetVal = mSystemLocales;
    return true;
  }

  if (ReadSystemLocales(aRetVal)) {
    mSystemLocales = aRetVal;
    return true;
  }

  // If we failed to get the system locale, we still need
  // to return something because there are tests out there that
  // depend on system locale to be set.
  aRetVal.AppendElement(NS_LITERAL_CSTRING("en-US"));
  return false;
}

void
OSPreferences::Refresh()
{
  nsTArray<nsCString> newLocales;
  ReadSystemLocales(newLocales);

  if (mSystemLocales != newLocales) {
    mSystemLocales = Move(newLocales);
    nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
    if (obs) {
      obs->NotifyObservers(nullptr, "intl:system-locales-changed", nullptr);
    }
  }
}

/**
 * This method should be called by every method of OSPreferences that
 * retrieves a locale id from external source.
 *
 * It attempts to retrieve as much of the locale ID as possible, cutting
 * out bits that are not understood (non-strict behavior of ICU).
 *
 * It returns true if the canonicalization was successful.
 */
bool
OSPreferences::CanonicalizeLanguageTag(nsCString& aLoc)
{
#ifdef ENABLE_INTL_API
  char langTag[512];

  UErrorCode status = U_ZERO_ERROR;

  int32_t langTagLen =
    uloc_toLanguageTag(aLoc.get(), langTag, sizeof(langTag) - 1, false, &status);

  if (U_FAILURE(status)) {
    return false;
  }

  aLoc.Assign(langTag, langTagLen);
  return true;
#else
  return false;
#endif
}

/**
 * This method retrieves from ICU the best pattern for a given date/time style.
 */
bool
OSPreferences::GetDateTimePatternForStyle(DateTimeFormatStyle aDateStyle,
                                          DateTimeFormatStyle aTimeStyle,
                                          const nsACString& aLocale,
                                          nsAString& aRetVal)
{
#ifdef ENABLE_INTL_API
  UDateFormatStyle timeStyle = UDAT_NONE;
  UDateFormatStyle dateStyle = UDAT_NONE;

  switch (aTimeStyle) {
    case DateTimeFormatStyle::None:
      timeStyle = UDAT_NONE;
      break;
    case DateTimeFormatStyle::Short:
      timeStyle = UDAT_SHORT;
      break;
    case DateTimeFormatStyle::Medium:
      timeStyle = UDAT_MEDIUM;
      break;
    case DateTimeFormatStyle::Long:
      timeStyle = UDAT_LONG;
      break;
    case DateTimeFormatStyle::Full:
      timeStyle = UDAT_FULL;
      break;
    case DateTimeFormatStyle::Invalid:
      timeStyle = UDAT_NONE;
      break;
  }

  switch (aDateStyle) {
    case DateTimeFormatStyle::None:
      dateStyle = UDAT_NONE;
      break;
    case DateTimeFormatStyle::Short:
      dateStyle = UDAT_SHORT;
      break;
    case DateTimeFormatStyle::Medium:
      dateStyle = UDAT_MEDIUM;
      break;
    case DateTimeFormatStyle::Long:
      dateStyle = UDAT_LONG;
      break;
    case DateTimeFormatStyle::Full:
      dateStyle = UDAT_FULL;
      break;
    case DateTimeFormatStyle::Invalid:
      dateStyle = UDAT_NONE;
      break;
  }

  const int32_t kPatternMax = 160;
  UChar pattern[kPatternMax];

  nsAutoCString locale;
  if (aLocale.IsEmpty()) {
    LocaleService::GetInstance()->GetAppLocaleAsBCP47(locale);
  } else {
    locale.Assign(aLocale);
  }

  UErrorCode status = U_ZERO_ERROR;
  UDateFormat* df = udat_open(timeStyle, dateStyle,
                              locale.get(),
                              nullptr, -1, nullptr, -1, &status);
  if (U_FAILURE(status)) {
    return false;
  }

  int32_t patsize = udat_toPattern(df, false, pattern, kPatternMax, &status);
  udat_close(df);
  if (U_FAILURE(status)) {
    return false;
  }
  aRetVal.Assign((const char16_t*)pattern, patsize);
  return true;
#else
  return false;
#endif
}


/**
 * This method retrieves from ICU the best skeleton for a given date/time style.
 *
 * This is useful for cases where an OS does not provide its own patterns,
 * but provide ability to customize the skeleton, like alter hourCycle setting.
 *
 * The returned value is a skeleton that matches the styles.
 */
bool
OSPreferences::GetDateTimeSkeletonForStyle(DateTimeFormatStyle aDateStyle,
                                           DateTimeFormatStyle aTimeStyle,
                                           const nsACString& aLocale,
                                           nsAString& aRetVal)
{
#ifdef ENABLE_INTL_API
  nsAutoString pattern;
  if (!GetDateTimePatternForStyle(aDateStyle, aTimeStyle, aLocale, pattern)) {
    return false;
  }

  const int32_t kSkeletonMax = 160;
  UChar skeleton[kSkeletonMax];

  UErrorCode status = U_ZERO_ERROR;
  int32_t skelsize = udatpg_getSkeleton(
    nullptr, (const UChar*)pattern.BeginReading(), pattern.Length(),
    skeleton, kSkeletonMax, &status
  );
  if (U_FAILURE(status)) {
    return false;
  }

  aRetVal.Assign((const char16_t*)skeleton, skelsize);
  return true;
#else
  return false;
#endif
}

/**
 * This function is a counterpart to GetDateTimeSkeletonForStyle.
 *
 * It takes a skeleton and returns the best available pattern for a given locale
 * that represents the provided skeleton.
 *
 * For example:
 * "Hm" skeleton for "en-US" will return "H:m"
 */
bool
OSPreferences::GetPatternForSkeleton(const nsAString& aSkeleton,
                                     const nsACString& aLocale,
                                     nsAString& aRetVal)
{
#ifdef ENABLE_INTL_API
  UErrorCode status = U_ZERO_ERROR;
  UDateTimePatternGenerator* pg = udatpg_open(PromiseFlatCString(aLocale).get(), &status);
  if (U_FAILURE(status)) {
    return false;
  }

  int32_t len =
    udatpg_getBestPattern(pg, (const UChar*)aSkeleton.BeginReading(),
                          aSkeleton.Length(), nullptr, 0, &status);
  if (status == U_BUFFER_OVERFLOW_ERROR) { // expected
    aRetVal.SetLength(len);
    status = U_ZERO_ERROR;
    udatpg_getBestPattern(pg, (const UChar*)aSkeleton.BeginReading(),
                          aSkeleton.Length(), (UChar*)aRetVal.BeginWriting(),
                          len, &status);
  }

  udatpg_close(pg);

  return U_SUCCESS(status);
#else
  return false;
#endif
}

/**
 * This function returns a pattern that should be used to join date and time
 * patterns into a single date/time pattern string.
 *
 * It's useful for OSes that do not provide an API to retrieve such combined
 * pattern.
 *
 * An example output is "{1}, {0}".
 */
bool
OSPreferences::GetDateTimeConnectorPattern(const nsACString& aLocale,
                                           nsAString& aRetVal)
{
  bool result = false;
#ifdef ENABLE_INTL_API
  UErrorCode status = U_ZERO_ERROR;
  UDateTimePatternGenerator* pg = udatpg_open(PromiseFlatCString(aLocale).get(), &status);
  if (U_SUCCESS(status)) {
    int32_t resultSize;
    const UChar* value = udatpg_getDateTimeFormat(pg, &resultSize);
    MOZ_ASSERT(resultSize >= 0);

    aRetVal.Assign((char16_t*)value, resultSize);
    result = true;
  }
  udatpg_close(pg);
#endif
  return result;
}

/**
 * mozIOSPreferences methods
 */
NS_IMETHODIMP
OSPreferences::GetSystemLocales(uint32_t* aCount, char*** aOutArray)
{
  AutoTArray<nsCString,10> tempLocales;
  nsTArray<nsCString>* systemLocalesPtr;

  if (!mSystemLocales.IsEmpty()) {
    // use cached value
    systemLocalesPtr = &mSystemLocales;
  } else {
    // get a (perhaps temporary/fallback/hack) value
    GetSystemLocales(tempLocales);
    systemLocalesPtr = &tempLocales;
  }
  *aCount = systemLocalesPtr->Length();
  *aOutArray = static_cast<char**>(moz_xmalloc(*aCount * sizeof(char*)));

  for (uint32_t i = 0; i < *aCount; i++) {
    (*aOutArray)[i] = moz_xstrdup((*systemLocalesPtr)[i].get());
  }

  return NS_OK;
}

NS_IMETHODIMP
OSPreferences::GetSystemLocale(nsACString& aRetVal)
{
  if (!mSystemLocales.IsEmpty()) {
    aRetVal = mSystemLocales[0];
  } else {
    AutoTArray<nsCString,10> locales;
    GetSystemLocales(locales);
    if (!locales.IsEmpty()) {
      aRetVal = locales[0];
    }
  }
  return NS_OK;
}

static OSPreferences::DateTimeFormatStyle
ToDateTimeFormatStyle(int32_t aTimeFormat)
{
  switch (aTimeFormat) {
    // See mozIOSPreferences.idl for the integer values here.
    case 0:
      return OSPreferences::DateTimeFormatStyle::None;
    case 1:
      return OSPreferences::DateTimeFormatStyle::Short;
    case 2:
      return OSPreferences::DateTimeFormatStyle::Medium;
    case 3:
      return OSPreferences::DateTimeFormatStyle::Long;
    case 4:
      return OSPreferences::DateTimeFormatStyle::Full;
  }
  return OSPreferences::DateTimeFormatStyle::Invalid;
}

NS_IMETHODIMP
OSPreferences::GetDateTimePattern(int32_t aDateFormatStyle,
                                  int32_t aTimeFormatStyle,
                                  const nsACString& aLocale,
                                  nsAString& aRetVal)
{
  DateTimeFormatStyle dateStyle = ToDateTimeFormatStyle(aDateFormatStyle);
  if (dateStyle == DateTimeFormatStyle::Invalid) {
    return NS_ERROR_INVALID_ARG;
  }
  DateTimeFormatStyle timeStyle = ToDateTimeFormatStyle(aTimeFormatStyle);
  if (timeStyle == DateTimeFormatStyle::Invalid) {
    return NS_ERROR_INVALID_ARG;
  }

  // If the user is asking for None on both, date and time style,
  // let's exit early.
  if (timeStyle == DateTimeFormatStyle::None &&
      dateStyle == DateTimeFormatStyle::None) {
    return NS_OK;
  }

  if (!ReadDateTimePattern(dateStyle, timeStyle, aLocale, aRetVal)) {
    if (!GetDateTimePatternForStyle(dateStyle, timeStyle, aLocale, aRetVal)) {
      return NS_ERROR_FAILURE;
    }
  }

  return NS_OK;
}
