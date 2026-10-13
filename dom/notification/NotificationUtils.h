/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DOM_NOTIFICATION_NOTIFICATIONUTILS_H_
#define DOM_NOTIFICATION_NOTIFICATIONUTILS_H_

#include <cstdint>

#include "mozilla/dom/DOMTypes.h"
#include "nsCOMPtr.h"
#include "nsINotificationStorage.h"
#include "nsStringFwd.h"

enum class nsresult : uint32_t;
class nsIAlertNotification;
class nsIPrincipal;
class nsINotificationStorage;
namespace mozilla::dom {
enum class NotificationPermission : uint8_t;
class Document;
}  // namespace mozilla::dom

namespace mozilla::dom::notification {

// The spec defines maxActions to depend on system limitation, but that can be
// used for fingerprinting.
// See also https://github.com/whatwg/notifications/issues/110.
static constexpr uint8_t kMaxActions = 2;

/**
 * Retrieves raw notification permission directly from PermissionManager.
 */
NotificationPermission GetRawNotificationPermission(nsIPrincipal* aPrincipal);

enum class PermissionCheckPurpose : uint8_t {
  PermissionRequest,
  PermissionAttribute,
  NotificationShow,
  LoadImageForShow,
  PushSubscribe,
};

/**
 * Returns true if the current principal must be given notification
 * permission, regardless of the permission status. This one should be dominant
 * compared to FobbiddenFor below.
 */
bool IsNotificationAllowedFor(nsIPrincipal* aPrincipal);

/**
 * Returns true if the current principal must not be given notification
 * permission, regardless of the permission status.
 *
 * @param aRequestorDoc The Document object from the page requesting permission.
 *                      Pass only when this is for requestNotification().
 */
bool IsNotificationForbiddenFor(nsIPrincipal* aPrincipal,
                                nsIPrincipal* aEffectiveStoragePrincipal,
                                bool isSecureContext,
                                PermissionCheckPurpose aPurpose,
                                Document* aRequestorDoc = nullptr);

/**
 * Retrieves notification permission based on the context.
 */
NotificationPermission GetNotificationPermission(
    nsIPrincipal* aPrincipal, nsIPrincipal* aEffectiveStoragePrincipal,
    bool isSecureContext, PermissionCheckPurpose aPurpose);

nsCOMPtr<nsINotificationStorage> GetNotificationStorage(bool isPrivate);

using NotificationsPromise =
    MozPromise<CopyableTArray<IPCNotification>, nsresult, false>;

already_AddRefed<NotificationsPromise> GetStoredNotificationsForScope(
    nsIPrincipal* aPrincipal, const nsACString& aScope, const nsAString& aTag);

nsresult GetOrigin(nsIPrincipal* aPrincipal, nsString& aOrigin);

nsresult PersistNotification(nsIPrincipal* aPrincipal,
                             const IPCNotification& aNotification,
                             const nsString& aScope);
nsresult UnpersistNotification(nsIPrincipal* aPrincipal, const nsString& aId);

enum class CloseMode {
  CloseMethod,
  // Either on global teardown or freeze
  InactiveGlobal,
};
void UnregisterNotification(nsIPrincipal* aPrincipal, const nsString& aId);

// Show an alert and clean up any previously stored notifications that
// aren't currently known to the notification backend.
//
// The cleanup happens when this is globally the first call, or always if
// dom.webnotifications.testing.force_storage_cleanup.enabled is set.
nsresult ShowAlertWithCleanup(nsIAlertNotification* aAlert,
                              nsIObserver* aAlertListener);

nsresult RemovePermission(nsIPrincipal* aPrincipal);
nsresult OpenSettings(nsIPrincipal* aPrincipal);

enum class NotificationStatusChange { Shown, Closed };
nsresult AdjustPushQuota(nsIPrincipal* aPrincipal,
                         NotificationStatusChange aChange);

class NotificationActionStorageEntry
    : public nsINotificationActionStorageEntry {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSINOTIFICATIONACTIONSTORAGEENTRY
  explicit NotificationActionStorageEntry(
      const IPCNotificationAction& aIPCAction)
      : mIPCAction(aIPCAction) {}

  static Result<IPCNotificationAction, nsresult> ToIPC(
      nsINotificationActionStorageEntry& aEntry);

 private:
  virtual ~NotificationActionStorageEntry() = default;

  IPCNotificationAction mIPCAction;
};

class NotificationStorageEntry : public nsINotificationStorageEntry {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSINOTIFICATIONSTORAGEENTRY
  explicit NotificationStorageEntry(const IPCNotification& aIPCNotification)
      : mIPCNotification(aIPCNotification) {}

  static Result<IPCNotification, nsresult> ToIPC(
      nsINotificationStorageEntry& aEntry);

 private:
  virtual ~NotificationStorageEntry() = default;

  IPCNotification mIPCNotification;
};

}  // namespace mozilla::dom::notification

#endif  // DOM_NOTIFICATION_NOTIFICATIONUTILS_H_
