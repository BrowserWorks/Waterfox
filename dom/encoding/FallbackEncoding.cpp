/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/FallbackEncoding.h"

#include "mozilla/Encoding.h"
#include "mozilla/intl/LocaleService.h"
#include "mozilla/Preferences.h"
#include "mozilla/Services.h"
#include "nsIObserverService.h"
#include "nsUConvPropertySearch.h"

using mozilla::intl::LocaleService;

namespace mozilla {
namespace dom {

static constexpr nsUConvProp localesFallbacks[] = {
#include "localesfallbacks.properties.h"
};

static constexpr nsUConvProp domainsFallbacks[] = {
#include "domainsfallbacks.properties.h"
};

static constexpr nsUConvProp nonParticipatingDomains[] = {
#include "nonparticipatingdomains.properties.h"
};

NS_IMPL_ISUPPORTS(FallbackEncoding, nsIObserver)

FallbackEncoding* FallbackEncoding::sInstance = nullptr;
bool FallbackEncoding::sGuessFallbackFromTopLevelDomain = true;

FallbackEncoding::FallbackEncoding()
  : mFallback(nullptr)
{
  MOZ_ASSERT(!FallbackEncoding::sInstance,
             "Singleton already exists.");
}

NotNull<const Encoding*>
FallbackEncoding::Get()
{
  if (mFallback) {
    return WrapNotNull(mFallback);
  }

  nsAutoCString override;
  Preferences::GetCString("intl.charset.fallback.override", override);
  // Don't let the user break things by setting the override to unreasonable
  // values via about:config
  auto encoding = Encoding::ForLabel(override);
  if (!encoding || !encoding->IsAsciiCompatible() ||
      encoding == UTF_8_ENCODING) {
    mFallback = nullptr;
  } else {
    mFallback = encoding;
  }

  if (mFallback) {
    return WrapNotNull(mFallback);
  }

  nsAutoCString locale;
  LocaleService::GetInstance()->GetAppLocaleAsLangTag(locale);

  // Let's lower case the string just in case unofficial language packs
  // don't stick to conventions.
  ToLowerCase(locale); // ASCII lowercasing with CString input!

  // Special case Traditional Chinese before throwing away stuff after the
  // language itself. Today we only ship zh-TW, but be defensive about
  // possible future values.
  if (locale.EqualsLiteral("zh-tw") ||
      locale.EqualsLiteral("zh-hk") ||
      locale.EqualsLiteral("zh-mo") ||
      locale.EqualsLiteral("zh-hant")) {
    mFallback = BIG5_ENCODING;
    return WrapNotNull(mFallback);
  }

  // Throw away regions and other variants to accommodate weird stuff seen
  // in telemetry--apparently unofficial language packs.
  int32_t index = locale.FindChar('-');
  if (index >= 0) {
    locale.Truncate(index);
  }

  nsAutoCString fallback;
  if (NS_FAILED(nsUConvPropertySearch::SearchPropertyValue(
      localesFallbacks, ArrayLength(localesFallbacks), locale, fallback))) {
    mFallback = WINDOWS_1252_ENCODING;
  } else {
    mFallback = Encoding::ForName(fallback);
  }

  return WrapNotNull(mFallback);
}

NotNull<const Encoding*>
FallbackEncoding::FromLocale()
{
  MOZ_ASSERT(FallbackEncoding::sInstance,
             "Using uninitialized fallback cache.");
  return FallbackEncoding::sInstance->Get();
}

// PrefChangedFunc
void
FallbackEncoding::PrefChanged(const char*, void*)
{
  MOZ_ASSERT(FallbackEncoding::sInstance,
             "Pref callback called with null fallback cache.");
  FallbackEncoding::sInstance->Invalidate();
}

NS_IMETHODIMP
FallbackEncoding::Observe(nsISupports *aSubject, const char *aTopic,
                         const char16_t *aData)
{
  MOZ_ASSERT(FallbackEncoding::sInstance,
             "Observe callback called with null fallback cache.");
  FallbackEncoding::sInstance->Invalidate();
  return NS_OK;
}

void
FallbackEncoding::Initialize()
{
  MOZ_ASSERT(!FallbackEncoding::sInstance,
             "Initializing pre-existing fallback cache.");
  FallbackEncoding::sInstance = new FallbackEncoding;
  Preferences::RegisterCallback(FallbackEncoding::PrefChanged,
                                "intl.charset.fallback.override",
                                nullptr);
  Preferences::AddBoolVarCache(&sGuessFallbackFromTopLevelDomain,
                               "intl.charset.fallback.tld");

  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    obs->AddObserver(sInstance, "intl:requested-locales-changed", true);
  }
}

void
FallbackEncoding::Shutdown()
{
  MOZ_ASSERT(FallbackEncoding::sInstance,
             "Releasing non-existent fallback cache.");
  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    obs->RemoveObserver(sInstance, "intl:requested-locales-changed");
  }
  delete FallbackEncoding::sInstance;
  FallbackEncoding::sInstance = nullptr;
}

bool
FallbackEncoding::IsParticipatingTopLevelDomain(const nsACString& aTLD)
{
  nsAutoCString dummy;
  return NS_FAILED(nsUConvPropertySearch::SearchPropertyValue(
      nonParticipatingDomains,
      ArrayLength(nonParticipatingDomains),
      aTLD,
      dummy));
}

NotNull<const Encoding*>
FallbackEncoding::FromTopLevelDomain(const nsACString& aTLD)
{
  nsAutoCString fallback;
  if (NS_FAILED(nsUConvPropertySearch::SearchPropertyValue(
      domainsFallbacks, ArrayLength(domainsFallbacks), aTLD, fallback))) {
    return WINDOWS_1252_ENCODING;
  }
  return Encoding::ForName(fallback);
}

} // namespace dom
} // namespace mozilla
