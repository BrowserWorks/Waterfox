/* -*- Mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2; -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AndroidAlerts.h"
#include "mozilla/java/GeckoRuntimeWrappers.h"
#include "mozilla/java/WebNotificationWrappers.h"
#include "nsAlertsUtils.h"

namespace mozilla {
namespace widget {

NS_IMPL_ISUPPORTS(AndroidAlerts, nsIAlertsService)

StaticAutoPtr<AndroidAlerts::ListenerMap> AndroidAlerts::sListenerMap;
nsDataHashtable<nsStringHashKey, java::WebNotification::GlobalRef>
    AndroidAlerts::mNotificationsMap;

NS_IMETHODIMP
AndroidAlerts::ShowAlertNotification(
    const nsAString& aImageUrl, const nsAString& aAlertTitle,
    const nsAString& aAlertText, bool aAlertTextClickable,
    const nsAString& aAlertCookie, nsIObserver* aAlertListener,
    const nsAString& aAlertName, const nsAString& aBidi, const nsAString& aLang,
    const nsAString& aData, nsIPrincipal* aPrincipal, bool aInPrivateBrowsing,
    bool aRequireInteraction) {
  MOZ_ASSERT_UNREACHABLE("Should be implemented by nsAlertsService.");
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
AndroidAlerts::ShowAlert(nsIAlertNotification* aAlert,
                         nsIObserver* aAlertListener) {
  return ShowPersistentNotification(EmptyString(), aAlert, aAlertListener);
}

NS_IMETHODIMP
AndroidAlerts::ShowPersistentNotification(const nsAString& aPersistentData,
                                          nsIAlertNotification* aAlert,
                                          nsIObserver* aAlertListener) {
  // nsAlertsService disables our alerts backend if we ever return failure
  // here. To keep the backend enabled, we always return NS_OK even if we
  // encounter an error here.
  nsresult rv;

  nsAutoString imageUrl;
  rv = aAlert->GetImageURL(imageUrl);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString title;
  rv = aAlert->GetTitle(title);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString text;
  rv = aAlert->GetText(text);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString cookie;
  rv = aAlert->GetCookie(cookie);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString name;
  rv = aAlert->GetName(name);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString lang;
  rv = aAlert->GetLang(lang);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString dir;
  rv = aAlert->GetDir(dir);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  bool requireInteraction;
  rv = aAlert->GetRequireInteraction(&requireInteraction);
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsCOMPtr<nsIPrincipal> principal;
  rv = aAlert->GetPrincipal(getter_AddRefs(principal));
  NS_ENSURE_SUCCESS(rv, NS_OK);

  nsAutoString host;
  nsAlertsUtils::GetSourceHostPort(principal, host);

  if (aPersistentData.IsEmpty() && aAlertListener) {
    if (!sListenerMap) {
      sListenerMap = new ListenerMap();
    }
    // This will remove any observers already registered for this name.
    sListenerMap->Put(name, aAlertListener);
  }

  java::WebNotification::LocalRef notification = notification->New(
      title, name, cookie, text, imageUrl, dir, lang, requireInteraction);
  java::GeckoRuntime::LocalRef runtime = java::GeckoRuntime::GetInstance();
  if (runtime != NULL) {
    runtime->NotifyOnShow(notification);
  }
  mNotificationsMap.Put(name, notification);

  return NS_OK;
}

NS_IMETHODIMP
AndroidAlerts::CloseAlert(const nsAString& aAlertName,
                          nsIPrincipal* aPrincipal) {
  java::WebNotification::LocalRef notification =
      mNotificationsMap.Get(aAlertName);
  if (!notification) {
    return NS_OK;
  }

  java::GeckoRuntime::LocalRef runtime = java::GeckoRuntime::GetInstance();
  if (runtime != NULL) {
    runtime->NotifyOnClose(notification);
  }
  mNotificationsMap.Remove(aAlertName);

  return NS_OK;
}

void AndroidAlerts::NotifyListener(const nsAString& aName, const char* aTopic,
                                   const char16_t* aCookie) {
  if (!sListenerMap) {
    return;
  }

  nsCOMPtr<nsIObserver> listener = sListenerMap->Get(aName);
  if (!listener) {
    return;
  }

  listener->Observe(nullptr, aTopic, aCookie);

  if (NS_LITERAL_CSTRING("alertfinished").Equals(aTopic)) {
    sListenerMap->Remove(aName);
    mNotificationsMap.Remove(aName);
  }
}

}  // namespace widget
}  // namespace mozilla
