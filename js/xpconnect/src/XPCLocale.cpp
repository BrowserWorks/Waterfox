/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Assertions.h"

#include "jsapi.h"

#include "nsCollationCID.h"
#include "nsJSUtils.h"
#include "nsICollation.h"
#include "nsIObserver.h"
#include "nsNativeCharsetUtils.h"
#include "nsComponentManagerUtils.h"
#include "nsServiceManagerUtils.h"
#include "mozilla/CycleCollectedJSContext.h"
#include "mozilla/intl/LocaleService.h"
#include "mozilla/Preferences.h"

#include "xpcpublic.h"

using namespace JS;
using namespace mozilla;
using mozilla::intl::LocaleService;

class XPCLocaleObserver : public nsIObserver
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOBSERVER

  void Init();

private:
  virtual ~XPCLocaleObserver() {};
};

NS_IMPL_ISUPPORTS(XPCLocaleObserver, nsIObserver);

void
XPCLocaleObserver::Init()
{
  nsCOMPtr<nsIObserverService> observerService =
    mozilla::services::GetObserverService();

  observerService->AddObserver(this, "intl:app-locales-changed", false);
}

NS_IMETHODIMP
XPCLocaleObserver::Observe(nsISupports* aSubject, const char* aTopic, const char16_t* aData)
{
  if (!strcmp(aTopic, "intl:app-locales-changed")) {
    JSContext* cx = CycleCollectedJSContext::Get()->Context();
    if (!xpc_LocalizeContext(cx)) {
      return NS_ERROR_OUT_OF_MEMORY;
    }
    return NS_OK;
  }

  return NS_ERROR_UNEXPECTED;
}

/**
 * JS locale callbacks implemented by XPCOM modules.  These are theoretically
 * safe for use on multiple threads.  Unfortunately, the intl code underlying
 * these XPCOM modules doesn't yet support this, so in practice
 * XPCLocaleCallbacks are limited to the main thread.
 */
struct XPCLocaleCallbacks : public JSLocaleCallbacks
{
  XPCLocaleCallbacks()
  {
    MOZ_COUNT_CTOR(XPCLocaleCallbacks);

    // Disable the toLocaleUpper/Lower case hooks to use the standard,
    // locale-insensitive definition from String.prototype. (These hooks are
    // only consulted when EXPOSE_INTL_API is not set.)
    localeToUpperCase = nullptr;
    localeToLowerCase = nullptr;
    localeCompare = LocaleCompare;
    localeToUnicode = LocaleToUnicode;

    // It's going to be retained by the ObserverService.
    RefPtr<XPCLocaleObserver> locObs = new XPCLocaleObserver();
    locObs->Init();
  }

  ~XPCLocaleCallbacks()
  {
    AssertThreadSafety();
    MOZ_COUNT_DTOR(XPCLocaleCallbacks);
  }

  /**
   * Return the XPCLocaleCallbacks that's hidden away in |cx|. (This impl uses
   * the locale callbacks struct to store away its per-context data.)
   */
  static XPCLocaleCallbacks*
  This(JSContext* cx)
  {
    // Locale information for |cx| was associated using xpc_LocalizeContext;
    // assert and double-check this.
    const JSLocaleCallbacks* lc = JS_GetLocaleCallbacks(cx);
    MOZ_ASSERT(lc);
    MOZ_ASSERT(lc->localeToUpperCase == nullptr);
    MOZ_ASSERT(lc->localeToLowerCase == nullptr);
    MOZ_ASSERT(lc->localeCompare == LocaleCompare);
    MOZ_ASSERT(lc->localeToUnicode == LocaleToUnicode);

    const XPCLocaleCallbacks* ths = static_cast<const XPCLocaleCallbacks*>(lc);
    ths->AssertThreadSafety();
    return const_cast<XPCLocaleCallbacks*>(ths);
  }

  static bool
  LocaleToUnicode(JSContext* cx, const char* src, MutableHandleValue rval)
  {
    return This(cx)->ToUnicode(cx, src, rval);
  }

  static bool
  LocaleCompare(JSContext* cx, HandleString src1, HandleString src2, MutableHandleValue rval)
  {
    return This(cx)->Compare(cx, src1, src2, rval);
  }

private:
  bool
  Compare(JSContext* cx, HandleString src1, HandleString src2, MutableHandleValue rval)
  {
    nsresult rv;

    if (!mCollation) {
      nsCOMPtr<nsICollationFactory> colFactory =
        do_CreateInstance(NS_COLLATIONFACTORY_CONTRACTID, &rv);

      if (NS_SUCCEEDED(rv)) {
        rv = colFactory->CreateCollation(getter_AddRefs(mCollation));
      }

      if (NS_FAILED(rv)) {
        xpc::Throw(cx, rv);
        return false;
      }
    }

    nsAutoJSString autoStr1, autoStr2;
    if (!autoStr1.init(cx, src1) || !autoStr2.init(cx, src2)) {
      return false;
    }

    int32_t result;
    rv = mCollation->CompareString(nsICollation::kCollationStrengthDefault,
                                   autoStr1, autoStr2, &result);

    if (NS_FAILED(rv)) {
      xpc::Throw(cx, rv);
      return false;
    }

    rval.setInt32(result);
    return true;
  }

  bool
  ToUnicode(JSContext* cx, const char* src, MutableHandleValue rval)
  {
    // This code is only used by our prioprietary toLocaleFormat method
    // and should be removed once we get rid of it.
    // toLocaleFormat is used in non-ICU scenarios where we don't have
    // access to any other date/time than the OS one, so we have to also
    // use the OS locale for unicode conversions.
    // See bug 1349470 for more details.
    nsAutoString result;
    NS_CopyNativeToUnicode(nsDependentCString(src), result);
    JSString* ucstr =
      JS_NewUCStringCopyN(cx, result.get(), result.Length());
    if (ucstr) {
      rval.setString(ucstr);
      return true;
    }

    xpc::Throw(cx, NS_ERROR_OUT_OF_MEMORY);
    return false;
  }

  void AssertThreadSafety() const
  {
    NS_ASSERT_OWNINGTHREAD(XPCLocaleCallbacks);
  }

  nsCOMPtr<nsICollation> mCollation;

  NS_DECL_OWNINGTHREAD
};

bool
xpc_LocalizeContext(JSContext* cx)
{
  // We want to assign the locale callbacks only the first time we
  // localize the context.
  // All consequent calls to this function are result of language changes
  // and should not assign it again.
  const JSLocaleCallbacks* lc = JS_GetLocaleCallbacks(cx);
  if (!lc) {
    JS_SetLocaleCallbacks(cx, new XPCLocaleCallbacks());
  }

  // Set the default locale.

  // Check a pref to see if we should use US English locale regardless
  // of the system locale.
  if (Preferences::GetBool("javascript.use_us_english_locale", false)) {
    return JS_SetDefaultLocale(cx, "en-US");
  }

  // No pref has been found, so get the default locale from the
  // application's locale.
  nsAutoCString appLocaleStr;
  LocaleService::GetInstance()->GetAppLocaleAsBCP47(appLocaleStr);

  return JS_SetDefaultLocale(cx, appLocaleStr.get());
}

void
xpc_DelocalizeContext(JSContext* cx)
{
  const XPCLocaleCallbacks* lc = XPCLocaleCallbacks::This(cx);
  JS_SetLocaleCallbacks(cx, nullptr);
  delete lc;
}
