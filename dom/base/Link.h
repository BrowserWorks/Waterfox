/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This is the base class for all link classes.
 */

#ifndef mozilla_dom_Link_h__
#define mozilla_dom_Link_h__

#include "mozilla/MemoryReporting.h"
#include "nsIContent.h"  // for nsLinkState

namespace mozilla {

class EventStates;
class SizeOfState;

namespace dom {

class Element;

#define MOZILLA_DOM_LINK_IMPLEMENTATION_IID          \
  {                                                  \
    0xb25edee6, 0xdd35, 0x4f8b, {                    \
      0xab, 0x90, 0x66, 0xd0, 0xbd, 0x3c, 0x22, 0xd5 \
    }                                                \
  }

class Link : public nsISupports {
 public:
  NS_DECLARE_STATIC_IID_ACCESSOR(MOZILLA_DOM_LINK_IMPLEMENTATION_IID)

  /**
   * aElement is the element pointer corresponding to this link.
   */
  explicit Link(Element* aElement);

  /**
   * This constructor is only used for testing.
   */
  explicit Link();

  virtual void VisitedQueryFinished(bool aVisited);

  /**
   * @return NS_EVENT_STATE_VISITED if this link is visited,
   *         NS_EVENT_STATE_UNVISTED if this link is not visited, or 0 if this
   *         link is not actually a link.
   */
  EventStates LinkState() const;

  /**
   * @return the URI this link is for, if available.
   */
  nsIURI* GetURI() const;
  virtual nsIURI* GetURIExternal() const { return GetURI(); }

  /**
   * Helper methods for modifying and obtaining parts of the URI of the Link.
   */
  void SetProtocol(const nsAString& aProtocol);
  void SetUsername(const nsAString& aUsername);
  void SetPassword(const nsAString& aPassword);
  void SetHost(const nsAString& aHost);
  void SetHostname(const nsAString& aHostname);
  void SetPathname(const nsAString& aPathname);
  void SetSearch(const nsAString& aSearch);
  void SetPort(const nsAString& aPort);
  void SetHash(const nsAString& aHash);
  void GetOrigin(nsAString& aOrigin);
  void GetProtocol(nsAString& _protocol);
  void GetUsername(nsAString& aUsername);
  void GetPassword(nsAString& aPassword);
  void GetHost(nsAString& _host);
  void GetHostname(nsAString& _hostname);
  void GetPathname(nsAString& _pathname);
  void GetSearch(nsAString& _search);
  void GetPort(nsAString& _port);
  void GetHash(nsAString& _hash);

  /**
   * Invalidates any link caching, and resets the state to the default.
   *
   * @param aNotify
   *        true if ResetLinkState should notify the owning document about style
   *        changes or false if it should not.
   */
  void ResetLinkState(bool aNotify, bool aHasHref);

  // This method nevers returns a null element.
  Element* GetElement() const { return mElement; }

  /**
   * DNS prefetch has been deferred until later, e.g. page load complete.
   */
  virtual void OnDNSPrefetchDeferred() { /*do nothing*/
  }

  /**
   * DNS prefetch has been submitted to Host Resolver.
   */
  virtual void OnDNSPrefetchRequested() { /*do nothing*/
  }

  /**
   * Checks if DNS Prefetching is ok
   *
   * @returns boolean
   *          Defaults to true; should be overridden for specialised cases
   */
  virtual bool HasDeferredDNSPrefetchRequest() { return true; }

  virtual size_t SizeOfExcludingThis(mozilla::SizeOfState& aState) const;

  virtual bool ElementHasHref() const;

  // This is called by HTMLAnchorElement and HTMLLinkElement.
  void TryDNSPrefetch();
  void CancelDNSPrefetch(nsWrapperCache::FlagsType aDeferredFlag,
                         nsWrapperCache::FlagsType aRequestedFlag);

  bool HasPendingLinkUpdate() const { return mHasPendingLinkUpdate; }
  void SetHasPendingLinkUpdate() { mHasPendingLinkUpdate = true; }
  void ClearHasPendingLinkUpdate() { mHasPendingLinkUpdate = false; }

  // To ensure correct mHasPendingLinkUpdate handling, we have this method
  // similar to the one in Element. Overriders must call
  // ClearHasPendingLinkUpdate().
  // If you change this, change also the method in nsINode.
  virtual void NodeInfoChanged(Document* aOldDoc) = 0;

  bool IsInDNSPrefetch() { return mInDNSPrefetch; }
  void SetIsInDNSPrefetch() { mInDNSPrefetch = true; }
  void ClearIsInDNSPrefetch() { mInDNSPrefetch = false; }

 protected:
  virtual ~Link();

  /**
   * Return true if the link has associated URI.
   */
  bool HasURI() const {
    if (HasCachedURI()) {
      return true;
    }

    return !!GetURI();
  }

  nsIURI* GetCachedURI() const { return mCachedURI; }
  bool HasCachedURI() const { return !!mCachedURI; }

 private:
  /**
   * Unregisters from History so this node no longer gets notifications about
   * changes to visitedness.
   */
  void UnregisterFromHistory();

  void SetHrefAttribute(nsIURI* aURI);

  mutable nsCOMPtr<nsIURI> mCachedURI;

  Element* const mElement;

  uint16_t mLinkState;

  bool mNeedsRegistration : 1;

  bool mRegistered : 1;

  bool mHasPendingLinkUpdate : 1;

  bool mInDNSPrefetch : 1;

  bool mHistory : 1;
};

NS_DEFINE_STATIC_IID_ACCESSOR(Link, MOZILLA_DOM_LINK_IMPLEMENTATION_IID)

enum ASDestination : uint8_t {
  DESTINATION_INVALID,
  DESTINATION_AUDIO,
  DESTINATION_DOCUMENT,
  DESTINATION_EMBED,
  DESTINATION_FONT,
  DESTINATION_IMAGE,
  DESTINATION_MANIFEST,
  DESTINATION_OBJECT,
  DESTINATION_REPORT,
  DESTINATION_SCRIPT,
  DESTINATION_SERVICEWORKER,
  DESTINATION_SHAREDWORKER,
  DESTINATION_STYLE,
  DESTINATION_TRACK,
  DESTINATION_VIDEO,
  DESTINATION_WORKER,
  DESTINATION_XSLT,
  DESTINATION_FETCH
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_Link_h__
