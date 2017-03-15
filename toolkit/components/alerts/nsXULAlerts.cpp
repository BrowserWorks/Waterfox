/* -*- Mode: C++; tab-width: 2; indent-tabs-mode:nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsXULAlerts.h"

#include "nsArray.h"
#include "nsComponentManagerUtils.h"
#include "nsCOMPtr.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/dom/Notification.h"
#include "mozilla/Unused.h"
#include "nsIServiceManager.h"
#include "nsISupportsPrimitives.h"
#include "nsPIDOMWindow.h"
#include "nsIWindowWatcher.h"

using namespace mozilla;
using mozilla::dom::NotificationTelemetryService;

#define ALERT_CHROME_URL "chrome://global/content/alerts/alert.xul"

namespace {
StaticRefPtr<nsXULAlerts> gXULAlerts;
} // anonymous namespace

NS_IMPL_CYCLE_COLLECTION(nsXULAlertObserver, mAlertWindow)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsXULAlertObserver)
  NS_INTERFACE_MAP_ENTRY(nsIObserver)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsXULAlertObserver)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsXULAlertObserver)

NS_IMETHODIMP
nsXULAlertObserver::Observe(nsISupports* aSubject, const char* aTopic,
                            const char16_t* aData)
{
  if (!strcmp("alertfinished", aTopic)) {
    mozIDOMWindowProxy* currentAlert = mXULAlerts->mNamedWindows.GetWeak(mAlertName);
    // The window in mNamedWindows might be a replacement, thus it should only
    // be removed if it is the same window that is associated with this listener.
    if (currentAlert == mAlertWindow) {
      mXULAlerts->mNamedWindows.Remove(mAlertName);

      if (mIsPersistent) {
        mXULAlerts->PersistentAlertFinished();
      }
    }
  }

  nsresult rv = NS_OK;
  if (mObserver) {
    rv = mObserver->Observe(aSubject, aTopic, aData);
  }
  return rv;
}

// We don't cycle collect nsXULAlerts since gXULAlerts will keep the instance
// alive till shutdown anyway.
NS_IMPL_ISUPPORTS(nsXULAlerts, nsIAlertsService, nsIAlertsDoNotDisturb, nsIAlertsIconURI)

/* static */ already_AddRefed<nsXULAlerts>
nsXULAlerts::GetInstance()
{
  // Gecko on Android does not fully support XUL windows.
#ifndef MOZ_WIDGET_ANDROID
  if (!gXULAlerts) {
    gXULAlerts = new nsXULAlerts();
    ClearOnShutdown(&gXULAlerts);
  }
#endif // MOZ_WIDGET_ANDROID
  RefPtr<nsXULAlerts> instance = gXULAlerts.get();
  return instance.forget();
}

void
nsXULAlerts::PersistentAlertFinished()
{
  MOZ_ASSERT(mPersistentAlertCount);
  mPersistentAlertCount--;

  // Show next pending persistent alert if any.
  if (!mPendingPersistentAlerts.IsEmpty()) {
    ShowAlertWithIconURI(mPendingPersistentAlerts[0].mAlert,
                         mPendingPersistentAlerts[0].mListener,
                         nullptr);
    mPendingPersistentAlerts.RemoveElementAt(0);
  }
}

NS_IMETHODIMP
nsXULAlerts::ShowAlertNotification(const nsAString& aImageUrl, const nsAString& aAlertTitle,
                                   const nsAString& aAlertText, bool aAlertTextClickable,
                                   const nsAString& aAlertCookie, nsIObserver* aAlertListener,
                                   const nsAString& aAlertName, const nsAString& aBidi,
                                   const nsAString& aLang, const nsAString& aData,
                                   nsIPrincipal* aPrincipal, bool aInPrivateBrowsing,
                                   bool aRequireInteraction)
{
  nsCOMPtr<nsIAlertNotification> alert =
    do_CreateInstance(ALERT_NOTIFICATION_CONTRACTID);
  NS_ENSURE_TRUE(alert, NS_ERROR_FAILURE);
  nsresult rv = alert->Init(aAlertName, aImageUrl, aAlertTitle,
                            aAlertText, aAlertTextClickable,
                            aAlertCookie, aBidi, aLang, aData,
                            aPrincipal, aInPrivateBrowsing,
                            aRequireInteraction);
  NS_ENSURE_SUCCESS(rv, rv);
  return ShowAlert(alert, aAlertListener);
}

NS_IMETHODIMP
nsXULAlerts::ShowPersistentNotification(const nsAString& aPersistentData,
                                        nsIAlertNotification* aAlert,
                                        nsIObserver* aAlertListener)
{
  return ShowAlert(aAlert, aAlertListener);
}

NS_IMETHODIMP
nsXULAlerts::ShowAlert(nsIAlertNotification* aAlert,
                       nsIObserver* aAlertListener)
{
  nsAutoString name;
  nsresult rv = aAlert->GetName(name);
  NS_ENSURE_SUCCESS(rv, rv);

  // If there is a pending alert with the same name in the list of
  // pending alerts, replace it.
  if (!mPendingPersistentAlerts.IsEmpty()) {
    for (uint32_t i = 0; i < mPendingPersistentAlerts.Length(); i++) {
      nsAutoString pendingAlertName;
      nsCOMPtr<nsIAlertNotification> pendingAlert = mPendingPersistentAlerts[i].mAlert;
      rv = pendingAlert->GetName(pendingAlertName);
      NS_ENSURE_SUCCESS(rv, rv);

      if (pendingAlertName.Equals(name)) {
        nsAutoString cookie;
        rv = pendingAlert->GetCookie(cookie);
        NS_ENSURE_SUCCESS(rv, rv);

        if (mPendingPersistentAlerts[i].mListener) {
          rv = mPendingPersistentAlerts[i].mListener->Observe(nullptr, "alertfinished", cookie.get());
          NS_ENSURE_SUCCESS(rv, rv);
        }

        mPendingPersistentAlerts[i].Init(aAlert, aAlertListener);
        return NS_OK;
      }
    }
  }

  bool requireInteraction;
  rv = aAlert->GetRequireInteraction(&requireInteraction);
  NS_ENSURE_SUCCESS(rv, rv);

  if (requireInteraction &&
      !mNamedWindows.Contains(name) &&
      static_cast<int32_t>(mPersistentAlertCount) >=
        Preferences::GetInt("dom.webnotifications.requireinteraction.count", 0)) {
    PendingAlert* pa = mPendingPersistentAlerts.AppendElement();
    pa->Init(aAlert, aAlertListener);
    return NS_OK;
  } else {
    return ShowAlertWithIconURI(aAlert, aAlertListener, nullptr);
  }
}

NS_IMETHODIMP
nsXULAlerts::ShowAlertWithIconURI(nsIAlertNotification* aAlert,
                                  nsIObserver* aAlertListener,
                                  nsIURI* aIconURI)
{
  bool inPrivateBrowsing;
  nsresult rv = aAlert->GetInPrivateBrowsing(&inPrivateBrowsing);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString cookie;
  rv = aAlert->GetCookie(cookie);
  NS_ENSURE_SUCCESS(rv, rv);

  if (mDoNotDisturb) {
    if (!inPrivateBrowsing) {
      RefPtr<NotificationTelemetryService> telemetry =
        NotificationTelemetryService::GetInstance();
      if (telemetry) {
        // Record the number of unique senders for XUL alerts. The OS X and
        // libnotify backends will fire `alertshow` even if "do not disturb"
        // is enabled. In that case, `NotificationObserver` will record the
        // sender.
        nsCOMPtr<nsIPrincipal> principal;
        if (NS_SUCCEEDED(aAlert->GetPrincipal(getter_AddRefs(principal)))) {
          Unused << NS_WARN_IF(NS_FAILED(telemetry->RecordSender(principal)));
        }
      }
    }
    if (aAlertListener)
      aAlertListener->Observe(nullptr, "alertfinished", cookie.get());
    return NS_OK;
  }

  nsAutoString name;
  rv = aAlert->GetName(name);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString imageUrl;
  rv = aAlert->GetImageURL(imageUrl);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString title;
  rv = aAlert->GetTitle(title);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString text;
  rv = aAlert->GetText(text);
  NS_ENSURE_SUCCESS(rv, rv);

  bool textClickable;
  rv = aAlert->GetTextClickable(&textClickable);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString bidi;
  rv = aAlert->GetDir(bidi);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString lang;
  rv = aAlert->GetLang(lang);
  NS_ENSURE_SUCCESS(rv, rv);

  nsAutoString source;
  rv = aAlert->GetSource(source);
  NS_ENSURE_SUCCESS(rv, rv);

  bool requireInteraction;
  rv = aAlert->GetRequireInteraction(&requireInteraction);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIWindowWatcher> wwatch(do_GetService(NS_WINDOWWATCHER_CONTRACTID));

  nsCOMPtr<nsIMutableArray> argsArray = nsArray::Create();

  // create scriptable versions of our strings that we can store in our nsIMutableArray....
  nsCOMPtr<nsISupportsString> scriptableImageUrl (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableImageUrl, NS_ERROR_FAILURE);

  scriptableImageUrl->SetData(imageUrl);
  rv = argsArray->AppendElement(scriptableImageUrl, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsString> scriptableAlertTitle (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableAlertTitle, NS_ERROR_FAILURE);

  scriptableAlertTitle->SetData(title);
  rv = argsArray->AppendElement(scriptableAlertTitle, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsString> scriptableAlertText (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableAlertText, NS_ERROR_FAILURE);

  scriptableAlertText->SetData(text);
  rv = argsArray->AppendElement(scriptableAlertText, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsPRBool> scriptableIsClickable (do_CreateInstance(NS_SUPPORTS_PRBOOL_CONTRACTID));
  NS_ENSURE_TRUE(scriptableIsClickable, NS_ERROR_FAILURE);

  scriptableIsClickable->SetData(textClickable);
  rv = argsArray->AppendElement(scriptableIsClickable, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsString> scriptableAlertCookie (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableAlertCookie, NS_ERROR_FAILURE);

  scriptableAlertCookie->SetData(cookie);
  rv = argsArray->AppendElement(scriptableAlertCookie, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsPRInt32> scriptableOrigin (do_CreateInstance(NS_SUPPORTS_PRINT32_CONTRACTID));
  NS_ENSURE_TRUE(scriptableOrigin, NS_ERROR_FAILURE);

  int32_t origin =
    LookAndFeel::GetInt(LookAndFeel::eIntID_AlertNotificationOrigin);
  scriptableOrigin->SetData(origin);

  rv = argsArray->AppendElement(scriptableOrigin, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsString> scriptableBidi (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableBidi, NS_ERROR_FAILURE);

  scriptableBidi->SetData(bidi);
  rv = argsArray->AppendElement(scriptableBidi, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsString> scriptableLang (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableLang, NS_ERROR_FAILURE);

  scriptableLang->SetData(lang);
  rv = argsArray->AppendElement(scriptableLang, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsPRBool> scriptableRequireInteraction (do_CreateInstance(NS_SUPPORTS_PRBOOL_CONTRACTID));
  NS_ENSURE_TRUE(scriptableRequireInteraction, NS_ERROR_FAILURE);

  scriptableRequireInteraction->SetData(requireInteraction);
  rv = argsArray->AppendElement(scriptableRequireInteraction, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  // Alerts with the same name should replace the old alert in the same position.
  // Provide the new alert window with a pointer to the replaced window so that
  // it may take the same position.
  nsCOMPtr<nsISupportsInterfacePointer> replacedWindow = do_CreateInstance(NS_SUPPORTS_INTERFACE_POINTER_CONTRACTID, &rv);
  NS_ENSURE_TRUE(replacedWindow, NS_ERROR_FAILURE);
  mozIDOMWindowProxy* previousAlert = mNamedWindows.GetWeak(name);
  replacedWindow->SetData(previousAlert);
  replacedWindow->SetDataIID(&NS_GET_IID(mozIDOMWindowProxy));
  rv = argsArray->AppendElement(replacedWindow, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  if (requireInteraction) {
    mPersistentAlertCount++;
  }

  // Add an observer (that wraps aAlertListener) to remove the window from
  // mNamedWindows when it is closed.
  nsCOMPtr<nsISupportsInterfacePointer> ifptr = do_CreateInstance(NS_SUPPORTS_INTERFACE_POINTER_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);
  RefPtr<nsXULAlertObserver> alertObserver = new nsXULAlertObserver(this, name, aAlertListener, requireInteraction);
  nsCOMPtr<nsISupports> iSupports(do_QueryInterface(alertObserver));
  ifptr->SetData(iSupports);
  ifptr->SetDataIID(&NS_GET_IID(nsIObserver));
  rv = argsArray->AppendElement(ifptr, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  // The source contains the host and port of the site that sent the
  // notification. It is empty for system alerts.
  nsCOMPtr<nsISupportsString> scriptableAlertSource (do_CreateInstance(NS_SUPPORTS_STRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableAlertSource, NS_ERROR_FAILURE);
  scriptableAlertSource->SetData(source);
  rv = argsArray->AppendElement(scriptableAlertSource, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISupportsCString> scriptableIconURL (do_CreateInstance(NS_SUPPORTS_CSTRING_CONTRACTID));
  NS_ENSURE_TRUE(scriptableIconURL, NS_ERROR_FAILURE);
  if (aIconURI) {
    nsAutoCString iconURL;
    rv = aIconURI->GetSpec(iconURL);
    NS_ENSURE_SUCCESS(rv, rv);
    scriptableIconURL->SetData(iconURL);
  }
  rv = argsArray->AppendElement(scriptableIconURL, /*weak =*/ false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<mozIDOMWindowProxy> newWindow;
  nsAutoCString features("chrome,dialog=yes,titlebar=no,popup=yes");
  if (inPrivateBrowsing) {
    features.AppendLiteral(",private");
  }
  rv = wwatch->OpenWindow(nullptr, ALERT_CHROME_URL, "_blank", features.get(),
                          argsArray, getter_AddRefs(newWindow));
  NS_ENSURE_SUCCESS(rv, rv);

  mNamedWindows.Put(name, newWindow);
  alertObserver->SetAlertWindow(newWindow);

  return NS_OK;
}

NS_IMETHODIMP
nsXULAlerts::SetManualDoNotDisturb(bool aDoNotDisturb)
{
  mDoNotDisturb = aDoNotDisturb;
  return NS_OK;
}

NS_IMETHODIMP
nsXULAlerts::GetManualDoNotDisturb(bool* aRetVal)
{
  *aRetVal = mDoNotDisturb;
  return NS_OK;
}

NS_IMETHODIMP
nsXULAlerts::CloseAlert(const nsAString& aAlertName,
                        nsIPrincipal* aPrincipal)
{
  mozIDOMWindowProxy* alert = mNamedWindows.GetWeak(aAlertName);
  if (nsCOMPtr<nsPIDOMWindowOuter> domWindow = nsPIDOMWindowOuter::From(alert)) {
    domWindow->DispatchCustomEvent(NS_LITERAL_STRING("XULAlertClose"));
  }
  return NS_OK;
}

