/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "NotificationUtils.h"

#include "mozilla/BasePrincipal.h"
#include "mozilla/Components.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/dom/DOMTypes.h"
#include "mozilla/dom/NotificationBinding.h"
#include "mozilla/glean/DomNotificationMetrics.h"
#include "nsContentUtils.h"
#include "nsIAlertsService.h"
#include "nsINotificationStorage.h"
#include "nsIPermissionManager.h"
#include "nsIPushService.h"
#include "nsNetUtil.h"
#include "nsServiceManagerUtils.h"

static bool gTriedStorageCleanup = false;

namespace mozilla::dom::notification {

using GleanLabel = glean::web_notification::ShowOriginLabel;

static void ReportTelemetry(GleanLabel aLabel,
                            PermissionCheckPurpose aPurpose) {
  switch (aPurpose) {
    case PermissionCheckPurpose::PermissionAttribute:
      glean::web_notification::permission_origin
          .EnumGet(static_cast<glean::web_notification::PermissionOriginLabel>(
              aLabel))
          .Add();
      return;
    case PermissionCheckPurpose::PermissionRequest:
      glean::web_notification::request_permission_origin
          .EnumGet(static_cast<
                   glean::web_notification::RequestPermissionOriginLabel>(
              aLabel))
          .Add();
      return;
    case PermissionCheckPurpose::NotificationShow:
      glean::web_notification::show_origin.EnumGet(aLabel).Add();
      return;
    case PermissionCheckPurpose::LoadImageForShow:
      // This will always be followed by a NotificationShow permissions check
      // anyway.
      return;
    case PermissionCheckPurpose::PushSubscribe:
      glean::web_notification::push_subscribe_origin
          .EnumGet(
              static_cast<glean::web_notification::PushSubscribeOriginLabel>(
                  aLabel))
          .Add();
      return;
    default:
      MOZ_CRASH("Unknown permission checker");
      return;
  }
}

bool IsNotificationAllowedFor(nsIPrincipal* aPrincipal) {
  if (aPrincipal->IsSystemPrincipal()) {
    return true;
  }
  // Allow files to show notifications by default.
  return aPrincipal->SchemeIs("file");
}

bool IsNotificationForbiddenFor(nsIPrincipal* aPrincipal,
                                nsIPrincipal* aEffectiveStoragePrincipal,
                                bool isSecureContext,
                                PermissionCheckPurpose aPurpose,
                                Document* aRequestorDoc) {
  if (aPrincipal->GetIsInPrivateBrowsing() &&
      !StaticPrefs::dom_webnotifications_privateBrowsing_enabled()) {
    return true;
  }

  if (!isSecureContext) {
    if (aRequestorDoc) {
      glean::web_notification::insecure_context_permission_request.Add();
      nsContentUtils::ReportToConsole(
          nsIScriptError::errorFlag, "DOM"_ns, aRequestorDoc,
          PropertiesFile::DOM_PROPERTIES,
          "NotificationsInsecureRequestIsForbidden");
    }
    return true;
  }

  const nsString& partitionKey =
      aEffectiveStoragePrincipal->OriginAttributesRef().mPartitionKey;

  if (aEffectiveStoragePrincipal->OriginAttributesRef()
          .mPartitionKey.IsEmpty()) {
    // first party
    ReportTelemetry(GleanLabel::eFirstParty, aPurpose);
    return false;
  }
  nsString outScheme;
  nsString outBaseDomain;
  int32_t outPort;
  bool outForeignByAncestorContext;
  OriginAttributes::ParsePartitionKey(partitionKey, outScheme, outBaseDomain,
                                      outPort, outForeignByAncestorContext);
  if (outForeignByAncestorContext) {
    // nested first party
    ReportTelemetry(GleanLabel::eNestedFirstParty, aPurpose);
    return StaticPrefs::
        dom_webnotifications_forbid_nested_first_party_enabled();
  }

  // third party
  ReportTelemetry(GleanLabel::eThirdParty, aPurpose);
  if (aRequestorDoc) {
    nsContentUtils::ReportToConsole(
        nsIScriptError::errorFlag, "DOM"_ns, aRequestorDoc,
        PropertiesFile::DOM_PROPERTIES,
        "NotificationsCrossOriginIframeRequestIsForbidden");
  }
  return !StaticPrefs::dom_webnotifications_allowcrossoriginiframe();
}

NotificationPermission GetRawNotificationPermission(nsIPrincipal* aPrincipal) {
  AssertIsOnMainThread();

  uint32_t permission = nsIPermissionManager::UNKNOWN_ACTION;

  nsCOMPtr<nsIPermissionManager> permissionManager =
      components::PermissionManager::Service();
  if (!permissionManager) {
    return NotificationPermission::Default;
  }

  permissionManager->TestExactPermissionFromPrincipal(
      aPrincipal, "desktop-notification"_ns, &permission);

  // Convert the result to one of the enum types.
  switch (permission) {
    case nsIPermissionManager::ALLOW_ACTION:
      return NotificationPermission::Granted;
    case nsIPermissionManager::DENY_ACTION:
      return NotificationPermission::Denied;
    default:
      return NotificationPermission::Default;
  }
}

NotificationPermission GetNotificationPermission(
    nsIPrincipal* aPrincipal, nsIPrincipal* aEffectiveStoragePrincipal,
    bool isSecureContext, PermissionCheckPurpose aPurpose) {
  if (IsNotificationAllowedFor(aPrincipal)) {
    return NotificationPermission::Granted;
  }
  if (IsNotificationForbiddenFor(aPrincipal, aEffectiveStoragePrincipal,
                                 isSecureContext, aPurpose)) {
    return NotificationPermission::Denied;
  }

  return GetRawNotificationPermission(aPrincipal);
}

nsresult GetOrigin(nsIPrincipal* aPrincipal, nsString& aOrigin) {
  if (!aPrincipal) {
    return NS_ERROR_FAILURE;
  }

  nsAutoCString origin;
  MOZ_TRY(aPrincipal->GetOrigin(origin));

  CopyUTF8toUTF16(origin, aOrigin);

  return NS_OK;
}

nsCOMPtr<nsINotificationStorage> GetNotificationStorage(bool isPrivate) {
  return do_GetService(isPrivate ? NS_MEMORY_NOTIFICATION_STORAGE_CONTRACTID
                                 : NS_NOTIFICATION_STORAGE_CONTRACTID);
}

class NotificationsCallback : public nsINotificationStorageCallback {
 public:
  NS_DECL_ISUPPORTS

  already_AddRefed<NotificationsPromise> Promise() {
    return mPromiseHolder.Ensure(__func__);
  }

  NS_IMETHOD Done(
      const nsTArray<RefPtr<nsINotificationStorageEntry>>& aEntries) final {
    AssertIsOnMainThread();

    nsTArray<IPCNotification> notifications(aEntries.Length());
    for (const auto& entry : aEntries) {
      auto result = NotificationStorageEntry::ToIPC(*entry);
      if (result.isErr()) {
        continue;
      }
      MOZ_ASSERT(!result.inspect().id().IsEmpty());
      notifications.AppendElement(result.unwrap());
    }

    mPromiseHolder.Resolve(std::move(notifications), __func__);
    return NS_OK;
  }

 protected:
  virtual ~NotificationsCallback() {
    // We may be shutting down prematurely without getting the result, so make
    // sure to settle the promise.
    mPromiseHolder.RejectIfExists(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
  };

  MozPromiseHolder<NotificationsPromise> mPromiseHolder;
};

NS_IMPL_ISUPPORTS(NotificationsCallback, nsINotificationStorageCallback)

already_AddRefed<NotificationsPromise> GetStoredNotificationsForScope(
    nsIPrincipal* aPrincipal, const nsACString& aScope, const nsAString& aTag) {
  nsString origin;
  nsresult rv = GetOrigin(aPrincipal, origin);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return NotificationsPromise::CreateAndReject(rv, __func__).forget();
  }

  RefPtr<NotificationsCallback> callback = new NotificationsCallback();
  RefPtr<NotificationsPromise> promise = callback->Promise();

  nsCOMPtr<nsINotificationStorage> notificationStorage =
      GetNotificationStorage(aPrincipal->GetIsInPrivateBrowsing());
  if (!notificationStorage) {
    return NotificationsPromise::CreateAndReject(NS_ERROR_NOT_AVAILABLE,
                                                 __func__)
        .forget();
  }

  rv = notificationStorage->Get(origin, NS_ConvertUTF8toUTF16(aScope), aTag,
                                callback);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return NotificationsPromise::CreateAndReject(rv, __func__).forget();
  }
  return promise.forget();
}

nsresult PersistNotification(nsIPrincipal* aPrincipal,
                             const IPCNotification& aNotification,
                             const nsString& aScope) {
  nsCOMPtr<nsINotificationStorage> notificationStorage =
      GetNotificationStorage(aPrincipal->GetIsInPrivateBrowsing());
  if (NS_WARN_IF(!notificationStorage)) {
    return NS_ERROR_UNEXPECTED;
  }

  nsString origin;
  nsresult rv = GetOrigin(aPrincipal, origin);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  RefPtr<NotificationStorageEntry> entry =
      new NotificationStorageEntry(aNotification);

  rv = notificationStorage->Put(origin, entry, aScope);

  if (NS_FAILED(rv)) {
    return rv;
  }

  return NS_OK;
}

nsresult UnpersistNotification(nsIPrincipal* aPrincipal, const nsString& aId) {
  if (!aPrincipal) {
    return NS_ERROR_FAILURE;
  }
  if (nsCOMPtr<nsINotificationStorage> notificationStorage =
          GetNotificationStorage(aPrincipal->GetIsInPrivateBrowsing())) {
    nsString origin;
    MOZ_TRY(GetOrigin(aPrincipal, origin));
    return notificationStorage->Delete(origin, aId);
  }
  return NS_ERROR_FAILURE;
}

nsresult UnpersistAllNotificationsExcept(const nsTArray<nsString>& aIds) {
  // Cleanup makes only sense for on-disk storage
  if (nsCOMPtr<nsINotificationStorage> notificationStorage =
          GetNotificationStorage(false)) {
    return notificationStorage->DeleteAllExcept(aIds);
  }
  return NS_ERROR_FAILURE;
}

void UnregisterNotification(nsIPrincipal* aPrincipal, const nsString& aId) {
  UnpersistNotification(aPrincipal, aId);
  if (nsCOMPtr<nsIAlertsService> alertService = components::Alerts::Service()) {
    alertService->CloseAlert(aId, /* aContextClosed */ false);
  }
}

nsresult ShowAlertWithCleanup(nsIAlertNotification* aAlert,
                              nsIObserver* aAlertListener) {
  nsCOMPtr<nsIAlertsService> alertService = components::Alerts::Service();
  if (!gTriedStorageCleanup ||
      StaticPrefs::
          dom_webnotifications_testing_force_storage_cleanup_enabled()) {
    // The below may fail, but retry probably won't make it work
    gTriedStorageCleanup = true;

    // Get the list of currently displayed notifications known to the
    // notification backend and unpersist all other notifications from
    // NotificationDB.
    // (This won't affect the following persist call by ShowAlert, as the DB
    // maintains a job queue)
    // Note that we ignore the result of GetHistory - we still go ahead and
    // clears notifications even if it fails, as the failure implies there's no
    // history and thus we should clear everything.
    nsTArray<nsString> history;
    (void)alertService->GetHistory(history);
    UnpersistAllNotificationsExcept(history);
  }

  MOZ_TRY(alertService->ShowAlert(aAlert, aAlertListener));
  return NS_OK;
}

nsresult RemovePermission(nsIPrincipal* aPrincipal) {
  MOZ_ASSERT(XRE_IsParentProcess());
  nsCOMPtr<nsIPermissionManager> permissionManager =
      mozilla::components::PermissionManager::Service();
  if (!permissionManager) {
    return NS_ERROR_FAILURE;
  }
  permissionManager->RemoveFromPrincipal(aPrincipal, "desktop-notification"_ns);
  return NS_OK;
}

nsresult OpenSettings(nsIPrincipal* aPrincipal) {
  MOZ_ASSERT(XRE_IsParentProcess());
  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (!obs) {
    return NS_ERROR_FAILURE;
  }
  // Notify other observers so they can show settings UI.
  obs->NotifyObservers(aPrincipal, "notifications-open-settings", nullptr);
  return NS_OK;
}

nsresult AdjustPushQuota(nsIPrincipal* aPrincipal,
                         NotificationStatusChange aChange) {
  MOZ_ASSERT(XRE_IsParentProcess());
  nsCOMPtr<nsIPushQuotaManager> pushQuotaManager =
      do_GetService("@mozilla.org/push/Service;1");
  if (!pushQuotaManager) {
    return NS_ERROR_FAILURE;
  }

  nsAutoCString origin;
  MOZ_TRY(aPrincipal->GetOrigin(origin));

  if (aChange == NotificationStatusChange::Shown) {
    return pushQuotaManager->NotificationForOriginShown(origin.get());
  }
  return pushQuotaManager->NotificationForOriginClosed(origin.get());
}

NS_IMPL_ISUPPORTS(NotificationActionStorageEntry,
                  nsINotificationActionStorageEntry)

NS_IMETHODIMP NotificationActionStorageEntry::GetName(nsAString& aName) {
  aName = mIPCAction.name();
  return NS_OK;
}

NS_IMETHODIMP NotificationActionStorageEntry::GetTitle(nsAString& aTitle) {
  aTitle = mIPCAction.title();
  return NS_OK;
}

Result<IPCNotificationAction, nsresult> NotificationActionStorageEntry::ToIPC(
    nsINotificationActionStorageEntry& aEntry) {
  IPCNotificationAction action;
  MOZ_TRY(aEntry.GetName(action.name()));
  MOZ_TRY(aEntry.GetTitle(action.title()));
  return action;
}

NS_IMPL_ISUPPORTS(NotificationStorageEntry, nsINotificationStorageEntry)

NS_IMETHODIMP NotificationStorageEntry::GetId(nsAString& aId) {
  aId = mIPCNotification.id();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetTitle(nsAString& aTitle) {
  aTitle = mIPCNotification.options().title();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetDir(nsACString& aDir) {
  aDir = GetEnumString(mIPCNotification.options().dir());
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetLang(nsAString& aLang) {
  aLang = mIPCNotification.options().lang();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetBody(nsAString& aBody) {
  aBody = mIPCNotification.options().body();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetTag(nsAString& aTag) {
  aTag = mIPCNotification.options().tag();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetIcon(nsACString& aIcon) {
  nsIURI* iconUri = mIPCNotification.options().icon();
  if (!iconUri) {
    aIcon.Truncate();
    return NS_OK;
  }
  iconUri->GetSpec(aIcon);
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetRequireInteraction(
    bool* aRequireInteraction) {
  *aRequireInteraction = mIPCNotification.options().requireInteraction();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetSilent(bool* aSilent) {
  *aSilent = mIPCNotification.options().silent();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetDataSerialized(
    nsAString& aDataSerialized) {
  aDataSerialized = mIPCNotification.options().dataSerialized();
  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetActions(
    nsTArray<RefPtr<nsINotificationActionStorageEntry>>& aRetVal) {
  nsTArray<RefPtr<nsINotificationActionStorageEntry>> actions(
      mIPCNotification.options().actions().Length());

  for (const auto& action : mIPCNotification.options().actions()) {
    actions.AppendElement(new NotificationActionStorageEntry(action));
  }

  aRetVal = std::move(actions);

  return NS_OK;
}

NS_IMETHODIMP NotificationStorageEntry::GetServiceWorkerRegistrationScope(
    nsAString& aScope) {
  // Scope is only provided from JS, for now
  // TODO(krosylight): Change nsINotificationStorage::Put to provide scope via
  // storage entry?
  aScope.SetIsVoid(true);
  return NS_OK;
}

Result<IPCNotification, nsresult> NotificationStorageEntry::ToIPC(
    nsINotificationStorageEntry& aEntry) {
  IPCNotification notification;
  IPCNotificationOptions& options = notification.options();
  MOZ_TRY(aEntry.GetId(notification.id()));
  MOZ_TRY(aEntry.GetTitle(options.title()));

  nsCString dir;
  MOZ_TRY(aEntry.GetDir(dir));
  options.dir() = StringToEnum<NotificationDirection>(dir).valueOr(
      NotificationDirection::Auto);

  MOZ_TRY(aEntry.GetLang(options.lang()));
  MOZ_TRY(aEntry.GetBody(options.body()));
  MOZ_TRY(aEntry.GetTag(options.tag()));

  nsAutoCString iconUrl;
  MOZ_TRY(aEntry.GetIcon(iconUrl));
  if (!iconUrl.IsEmpty()) {
    MOZ_TRY(NS_NewURI(getter_AddRefs(notification.options().icon()), iconUrl));
  }

  MOZ_TRY(aEntry.GetRequireInteraction(&options.requireInteraction()));
  MOZ_TRY(aEntry.GetSilent(&options.silent()));
  MOZ_TRY(aEntry.GetDataSerialized(options.dataSerialized()));

  nsTArray<RefPtr<nsINotificationActionStorageEntry>> actionEntries;
  MOZ_TRY(aEntry.GetActions(actionEntries));
  nsTArray<IPCNotificationAction> actions(actionEntries.Length());
  for (const auto& actionEntry : actionEntries) {
    IPCNotificationAction action =
        MOZ_TRY(NotificationActionStorageEntry::ToIPC(*actionEntry));
    actions.AppendElement(std::move(action));
  }
  options.actions() = std::move(actions);

  return notification;
}

}  // namespace mozilla::dom::notification
