/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "CookieStoreNotifier.h"

#include "CookieChangeEvent.h"
#include "CookieStore.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/WorkerPrivate.h"
#include "mozilla/net/Cookie.h"
#include "mozilla/net/CookieCommons.h"
#include "nsContentUtils.h"
#include "nsGlobalWindowInner.h"
#include "nsICookie.h"
#include "nsICookieNotification.h"
#include "nsISerialEventTarget.h"
#include "nsPIDOMWindowInlines.h"

namespace mozilla::dom {

NS_IMPL_ISUPPORTS(CookieStoreNotifier, nsIObserver);

// static
already_AddRefed<CookieStoreNotifier> CookieStoreNotifier::Create(
    CookieStore* aCookieStore) {
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsPIDOMWindowInner> window = aCookieStore->GetOwnerWindow();
  MOZ_ASSERT(window);

  nsCOMPtr<Document> document = window->GetExtantDoc();
  if (NS_WARN_IF(!document)) {
    return nullptr;
  }

  nsIPrincipal* principal = document->NodePrincipal();
  if (NS_WARN_IF(!principal)) {
    return nullptr;
  }

  nsCString baseDomain;
  if (NS_WARN_IF(NS_FAILED(
          net::CookieCommons::GetBaseDomain(principal, baseDomain)))) {
    return nullptr;
  }

  if (baseDomain.IsEmpty()) {
    return nullptr;
  }

  nsCString host;
  if (NS_WARN_IF(NS_FAILED(
          nsContentUtils::GetHostOrIPv6WithBrackets(principal, host))) ||
      host.IsEmpty()) {
    return nullptr;
  }

  nsCOMPtr<nsIObserverService> os = mozilla::services::GetObserverService();
  if (NS_WARN_IF(!os)) {
    return nullptr;
  }

  RefPtr<CookieStoreNotifier> notifier = new CookieStoreNotifier(
      aCookieStore, baseDomain, host, principal->OriginAttributesRef());

  nsresult rv =
      os->AddObserver(notifier,
                      principal->OriginAttributesRef().IsPrivateBrowsing()
                          ? "private-cookie-changed"
                          : "cookie-changed",
                      false);
  (void)NS_WARN_IF(NS_FAILED(rv));

  return notifier.forget();
}

CookieStoreNotifier::CookieStoreNotifier(
    CookieStore* aCookieStore, const nsACString& aBaseDomain,
    const nsACString& aHost, const OriginAttributes& aOriginAttributes)
    : mCookieStore(aCookieStore),
      mBaseDomain(aBaseDomain),
      mHost(aHost),
      mOriginAttributes(aOriginAttributes) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aCookieStore);
}

CookieStoreNotifier::~CookieStoreNotifier() = default;

void CookieStoreNotifier::Disentangle() {
  MOZ_ASSERT(NS_IsMainThread());

  mCookieStore = nullptr;
  mDelayedDOMEvents.Clear();

  nsCOMPtr<nsIObserverService> os = mozilla::services::GetObserverService();
  if (NS_WARN_IF(!os)) {
    return;
  }

  nsresult rv = os->RemoveObserver(this, mOriginAttributes.IsPrivateBrowsing()
                                             ? "private-cookie-changed"
                                             : "cookie-changed");
  (void)NS_WARN_IF(NS_FAILED(rv));
}

NS_IMETHODIMP
CookieStoreNotifier::Observe(nsISupports* aSubject, const char* aTopic,
                             const char16_t* aData) {
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsICookieNotification> notification = do_QueryInterface(aSubject);
  NS_ENSURE_TRUE(notification, NS_ERROR_FAILURE);

  auto action = notification->GetAction();
  if (action != nsICookieNotification::COOKIE_DELETED &&
      action != nsICookieNotification::COOKIE_ADDED &&
      action != nsICookieNotification::COOKIE_CHANGED) {
    return NS_OK;
  }

  nsAutoCString baseDomain;
  nsresult rv = notification->GetBaseDomain(baseDomain);
  if (NS_WARN_IF(NS_FAILED(rv)) || baseDomain.IsEmpty()) {
    return rv;
  }

  if (baseDomain != mBaseDomain) {
    return NS_OK;
  }

  nsCOMPtr<nsICookie> cookie;
  rv = notification->GetCookie(getter_AddRefs(cookie));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (cookie->OriginAttributesNative() != mOriginAttributes) {
    return NS_OK;
  }

  if (!net::CookieCommons::DomainMatches(net::Cookie::Cast(cookie), mHost)) {
    return NS_OK;
  }

  bool isHttpOnly;
  rv = cookie->GetIsHttpOnly(&isHttpOnly);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (isHttpOnly) {
    return NS_OK;
  }

  CookieListItem item;
  CookieStore::CookieStructToItem(net::Cookie::Cast(cookie)->ToIPC(), &item);

  if (action == nsICookieNotification::COOKIE_DELETED) {
    item.mValue.Reset();
  }

  bool deletedEvent = action == nsICookieNotification::COOKIE_DELETED;

  GetCurrentSerialEventTarget()->Dispatch(NS_NewRunnableFunction(
      __func__, [self = RefPtr(this), item, deletedEvent] {
        self->DispatchEvent(item, deletedEvent);
      }));

  return NS_OK;
}

void CookieStoreNotifier::DispatchEvent(const CookieListItem& aItem,
                                        bool aDeletedEvent) {
  MOZ_ASSERT(NS_IsMainThread());

  if (!mCookieStore) {
    return;
  }

  RefPtr<Event> event =
      aDeletedEvent
          ? CookieChangeEvent::CreateForDeletedCookie(mCookieStore, aItem)
          : CookieChangeEvent::CreateForChangedCookie(mCookieStore, aItem);

  if (!event) {
    return;
  }

  nsCOMPtr<nsPIDOMWindowInner> window = mCookieStore->GetOwnerWindow();
  if (!window) {
    return;
  }

  RefPtr<BrowsingContext> bc = window->GetBrowsingContext();
  if (!bc) {
    return;
  }

  if (bc->IsInBFCache() ||
      (window->GetExtantDoc() && window->GetExtantDoc()->GetBFCacheEntry())) {
    mDelayedDOMEvents.AppendElement(event);
    return;
  }

  mCookieStore->DispatchEvent(*event);
}

void CookieStoreNotifier::FireDelayedDOMEvents() {
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<CookieStoreNotifier> kungFuDeathGrip(this);

  nsTArray<RefPtr<Event>> delayedDOMEvents;
  delayedDOMEvents.SwapElements(mDelayedDOMEvents);

  for (Event* event : delayedDOMEvents) {
    // mCookieStore is a raw pointer cleared by Disentangle().
    if (!mCookieStore) {
      break;
    }

    mCookieStore->DispatchEvent(*event);
  }
}

}  // namespace mozilla::dom
