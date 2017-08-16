/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsNavHistory_h_
#define nsNavHistory_h_

#include "nsINavHistoryService.h"
#include "nsPIPlacesDatabase.h"
#include "nsIBrowserHistory.h"
#include "nsINavBookmarksService.h"
#include "nsIFaviconService.h"

#include "nsIObserverService.h"
#include "nsICollation.h"
#include "nsIStringBundle.h"
#include "nsITimer.h"
#include "nsMaybeWeakPtr.h"
#include "nsCategoryCache.h"
#include "nsNetCID.h"
#include "nsToolkitCompsCID.h"
#include "nsURIHashKey.h"
#include "nsTHashtable.h"

#include "nsNavHistoryResult.h"
#include "nsNavHistoryQuery.h"
#include "Database.h"
#include "mozilla/Attributes.h"
#include "mozilla/Atomics.h"

#define QUERYUPDATE_TIME 0
#define QUERYUPDATE_SIMPLE 1
#define QUERYUPDATE_COMPLEX 2
#define QUERYUPDATE_COMPLEX_WITH_BOOKMARKS 3
#define QUERYUPDATE_HOST 4

// Clamp title and URL to generously large, but not too large, length.
// See bug 319004 for details.
#define URI_LENGTH_MAX 65536
#define TITLE_LENGTH_MAX 4096

// Microsecond timeout for "recent" events such as typed and bookmark following.
// If you typed it more than this time ago, it's not recent.
#define RECENT_EVENT_THRESHOLD PRTime((int64_t)15 * 60 * PR_USEC_PER_SEC)

#ifdef MOZ_XUL
// Fired after autocomplete feedback has been updated.
#define TOPIC_AUTOCOMPLETE_FEEDBACK_UPDATED "places-autocomplete-feedback-updated"
#endif

// Fired after frecency has been updated.
#define TOPIC_FRECENCY_UPDATED "places-frecency-updated"

class nsNavHistory;
class QueryKeyValuePair;
class nsIEffectiveTLDService;
class nsIIDNService;
class PlacesSQLQueryBuilder;
class nsIAutoCompleteController;

// nsNavHistory

class nsNavHistory final : public nsSupportsWeakReference
                         , public nsINavHistoryService
                         , public nsIObserver
                         , public nsIBrowserHistory
                         , public nsPIPlacesDatabase
                         , public mozIStorageVacuumParticipant
{
  friend class PlacesSQLQueryBuilder;

public:
  nsNavHistory();

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSINAVHISTORYSERVICE
  NS_DECL_NSIBROWSERHISTORY
  NS_DECL_NSIOBSERVER
  NS_DECL_NSPIPLACESDATABASE
  NS_DECL_MOZISTORAGEVACUUMPARTICIPANT

  /**
   * Obtains the nsNavHistory object.
   */
  static already_AddRefed<nsNavHistory> GetSingleton();

  /**
   * Initializes the nsNavHistory object.  This should only be called once.
   */
  nsresult Init();

  /**
   * Used by other components in the places directory such as the annotation
   * service to get a reference to this history object. Returns a pointer to
   * the service if it exists. Otherwise creates one. Returns nullptr on error.
   */
  static nsNavHistory* GetHistoryService()
  {
    if (!gHistoryService) {
      nsCOMPtr<nsINavHistoryService> serv =
        do_GetService(NS_NAVHISTORYSERVICE_CONTRACTID);
      NS_ENSURE_TRUE(serv, nullptr);
      NS_ASSERTION(gHistoryService, "Should have static instance pointer now");
    }
    return gHistoryService;
  }

  /**
   * Used by other components in the places directory to get a reference to a
   * const version of this history object.
   *
   * @return A pointer to a const version of the service if it exists,
   *         nullptr otherwise.
   */
  static const nsNavHistory* GetConstHistoryService()
  {
    const nsNavHistory* const history = gHistoryService;
    return history;
  }

  /**
   * Fetches the database id and the GUID associated to the given URI.
   *
   * @param aURI
   *        The page to look for.
   * @param _pageId
   *        Will be set to the database id associated with the page.
   *        If the page doesn't exist, this will be zero.
   * @param _GUID
   *        Will be set to the unique id associated with the page.
   *        If the page doesn't exist, this will be empty.
   * @note This DOES NOT check for bad URLs other than that they're nonempty.
   */
  nsresult GetIdForPage(nsIURI* aURI,
                        int64_t* _pageId, nsCString& _GUID);

  /**
   * Fetches the database id and the GUID associated to the given URI, creating
   * a new database entry if one doesn't exist yet.
   *
   * @param aURI
   *        The page to look for or create.
   * @param _pageId
   *        Will be set to the database id associated with the page.
   * @param _GUID
   *        Will be set to the unique id associated with the page.
   * @note This DOES NOT check for bad URLs other than that they're nonempty.
   * @note This DOES NOT update frecency of the page.
   */
  nsresult GetOrCreateIdForPage(nsIURI* aURI,
                                int64_t* _pageId, nsCString& _GUID);

  /**
   * Asynchronously recalculates frecency for a given page.
   *
   * @param aPlaceId
   *        Place id to recalculate the frecency for.
   * @note If the new frecency is a non-zero value it will also unhide the page,
   *       otherwise will reuse the old hidden value.
   */
  nsresult UpdateFrecency(int64_t aPlaceId);

  /**
   * Recalculates frecency for all pages requesting that (frecency < 0). Those
   * may be generated:
   *  * After a "clear private data"
   *  * After removing visits
   *  * After migrating from older versions
   */
  nsresult FixInvalidFrecencies();

  /**
   * Invalidate the frecencies of a list of places, so they will be recalculated
   * at the first idle-daily notification.
   *
   * @param aPlacesIdsQueryString
   *        Query string containing list of places to be invalidated.  If it's
   *        an empty string all places will be invalidated.
   */
  nsresult invalidateFrecencies(const nsCString& aPlaceIdsQueryString);

  /**
   * Calls onDeleteVisits and onDeleteURI notifications on registered listeners
   * with the history service.
   *
   * @param aURI
   *        The nsIURI object representing the URI of the page being expired.
   * @param aVisitTime
   *        The time, in microseconds, that the page being expired was visited.
   * @param aWholeEntry
   *        Indicates if this is the last visit for this URI.
   * @param aGUID
   *        The unique ID associated with the page.
   * @param aReason
   *        Indicates the reason for the removal.
   *        See nsINavHistoryObserver::REASON_* constants.
   * @param aTransitionType
   *        If it's a valid TRANSITION_* value, all visits of the specified type
   *        have been removed.
   */
  nsresult NotifyOnPageExpired(nsIURI *aURI, PRTime aVisitTime,
                               bool aWholeEntry, const nsACString& aGUID,
                               uint16_t aReason, uint32_t aTransitionType);

  /**
   * These functions return non-owning references to the locale-specific
   * objects for places components.
   */
  nsIStringBundle* GetBundle();
  nsICollation* GetCollation();
  void GetStringFromName(const char16_t* aName, nsACString& aResult);
  void GetAgeInDaysString(int32_t aInt, const char16_t *aName,
                          nsACString& aResult);
  static void GetMonthName(const PRExplodedTime& aTime, nsACString& aResult);
  static void GetMonthYear(const PRExplodedTime& aTime, nsACString& aResult);

  // Returns whether history is enabled or not.
  bool IsHistoryDisabled() {
    return !mHistoryEnabled;
  }

  // Constants for the columns returned by the above statement.
  static const int32_t kGetInfoIndex_PageID;
  static const int32_t kGetInfoIndex_URL;
  static const int32_t kGetInfoIndex_Title;
  static const int32_t kGetInfoIndex_RevHost;
  static const int32_t kGetInfoIndex_VisitCount;
  static const int32_t kGetInfoIndex_VisitDate;
  static const int32_t kGetInfoIndex_FaviconURL;
  static const int32_t kGetInfoIndex_ItemId;
  static const int32_t kGetInfoIndex_ItemDateAdded;
  static const int32_t kGetInfoIndex_ItemLastModified;
  static const int32_t kGetInfoIndex_ItemParentId;
  static const int32_t kGetInfoIndex_ItemTags;
  static const int32_t kGetInfoIndex_Frecency;
  static const int32_t kGetInfoIndex_Hidden;
  static const int32_t kGetInfoIndex_Guid;
  static const int32_t kGetInfoIndex_VisitId;
  static const int32_t kGetInfoIndex_FromVisitId;
  static const int32_t kGetInfoIndex_VisitType;

  int64_t GetTagsFolder();

  // this actually executes a query and gives you results, it is used by
  // nsNavHistoryQueryResultNode
  nsresult GetQueryResults(nsNavHistoryQueryResultNode *aResultNode,
                           const nsCOMArray<nsNavHistoryQuery>& aQueries,
                           nsNavHistoryQueryOptions *aOptions,
                           nsCOMArray<nsNavHistoryResultNode>* aResults);

  // Take a row of kGetInfoIndex_* columns and construct a ResultNode.
  // The row must contain the full set of columns.
  nsresult RowToResult(mozIStorageValueArray* aRow,
                       nsNavHistoryQueryOptions* aOptions,
                       nsNavHistoryResultNode** aResult);
  nsresult QueryRowToResult(int64_t aItemId,
                            const nsACString& aBookmarkGuid,
                            const nsACString& aURI,
                            const nsACString& aTitle,
                            uint32_t aAccessCount,
                            PRTime aTime,
                            nsNavHistoryResultNode** aNode);

  nsresult VisitIdToResultNode(int64_t visitId,
                               nsNavHistoryQueryOptions* aOptions,
                               nsNavHistoryResultNode** aResult);

  nsresult BookmarkIdToResultNode(int64_t aBookmarkId,
                                  nsNavHistoryQueryOptions* aOptions,
                                  nsNavHistoryResultNode** aResult);
  nsresult URIToResultNode(nsIURI* aURI,
                           nsNavHistoryQueryOptions* aOptions,
                           nsNavHistoryResultNode** aResult);

  // used by other places components to send history notifications (for example,
  // when the favicon has changed)
  void SendPageChangedNotification(nsIURI* aURI, uint32_t aChangedAttribute,
                                   const nsAString& aValue,
                                   const nsACString& aGUID);

  /**
   * Returns current number of days stored in history.
   */
  int32_t GetDaysOfHistory();

  // used by query result nodes to update: see comment on body of CanLiveUpdateQuery
  static uint32_t GetUpdateRequirements(const nsCOMArray<nsNavHistoryQuery>& aQueries,
                                        nsNavHistoryQueryOptions* aOptions,
                                        bool* aHasSearchTerms);
  bool EvaluateQueryForNode(const nsCOMArray<nsNavHistoryQuery>& aQueries,
                              nsNavHistoryQueryOptions* aOptions,
                              nsNavHistoryResultNode* aNode);

  static nsresult AsciiHostNameFromHostString(const nsACString& aHostName,
                                              nsACString& aAscii);
  void DomainNameFromURI(nsIURI* aURI,
                         nsACString& aDomainName);
  static PRTime NormalizeTime(uint32_t aRelative, PRTime aOffset);

  // Don't use these directly, inside nsNavHistory use UpdateBatchScoper,
  // else use nsINavHistoryService::RunInBatchMode
  nsresult BeginUpdateBatch();
  nsresult EndUpdateBatch();

  // The level of batches' nesting, 0 when no batches are open.
  int32_t mBatchLevel;
  // Current active transaction for a batch.
  mozStorageTransaction* mBatchDBTransaction;

  // better alternative to QueryStringToQueries (in nsNavHistoryQuery.cpp)
  nsresult QueryStringToQueryArray(const nsACString& aQueryString,
                                   nsCOMArray<nsNavHistoryQuery>* aQueries,
                                   nsNavHistoryQueryOptions** aOptions);

  typedef nsDataHashtable<nsCStringHashKey, nsCString> StringHash;

  /**
   * Indicates if it is OK to notify history observers or not.
   *
   * @return true if it is OK to notify, false otherwise.
   */
  bool canNotify() { return mCanNotify; }

  enum RecentEventFlags {
    RECENT_TYPED      = 1 << 0,    // User typed in URL recently
    RECENT_ACTIVATED  = 1 << 1,    // User tapped URL link recently
    RECENT_BOOKMARKED = 1 << 2     // User bookmarked URL recently
  };

  /**
   * Returns any recent activity done with a URL.
   * @return Any recent events associated with this URI.  Each bit is set
   *         according to RecentEventFlags enum values.
   */
  uint32_t GetRecentFlags(nsIURI *aURI);

  /**
   * Registers a TRANSITION_EMBED visit for the session.
   *
   * @param aURI
   *        URI of the page.
   * @param aTime
   *        Visit time.  Only the last registered visit time is retained.
   */
  void registerEmbedVisit(nsIURI* aURI, int64_t aTime);

  /**
   * Returns whether the specified url has a embed visit.
   *
   * @param aURI
   *        URI of the page.
   * @return whether the page has a embed visit.
   */
  bool hasEmbedVisit(nsIURI* aURI);

  /**
   * Clears all registered embed visits.
   */
  void clearEmbedVisits();

  int32_t GetFrecencyAgedWeight(int32_t aAgeInDays) const
  {
    if (aAgeInDays <= mFirstBucketCutoffInDays) {
      return mFirstBucketWeight;
    }
    if (aAgeInDays <= mSecondBucketCutoffInDays) {
      return mSecondBucketWeight;
    }
    if (aAgeInDays <= mThirdBucketCutoffInDays) {
      return mThirdBucketWeight;
    }
    if (aAgeInDays <= mFourthBucketCutoffInDays) {
      return mFourthBucketWeight;
    }
    return mDefaultWeight;
  }

  int32_t GetFrecencyBucketWeight(int32_t aBucketIndex) const
  {
    switch(aBucketIndex) {
      case 1:
        return mFirstBucketWeight;
      case 2:
        return mSecondBucketWeight;
      case 3:
        return mThirdBucketWeight;
      case 4:
        return mFourthBucketWeight;
      default:
        return mDefaultWeight;
    }
  }

  int32_t GetFrecencyTransitionBonus(int32_t aTransitionType,
                                     bool aVisited,
                                     bool aRedirect = false) const
  {
    if (aRedirect) {
      return mRedirectSourceVisitBonus;
    }

    switch (aTransitionType) {
      case nsINavHistoryService::TRANSITION_EMBED:
        return mEmbedVisitBonus;
      case nsINavHistoryService::TRANSITION_FRAMED_LINK:
        return mFramedLinkVisitBonus;
      case nsINavHistoryService::TRANSITION_LINK:
        return mLinkVisitBonus;
      case nsINavHistoryService::TRANSITION_TYPED:
        return aVisited ? mTypedVisitBonus : mUnvisitedTypedBonus;
      case nsINavHistoryService::TRANSITION_BOOKMARK:
        return aVisited ? mBookmarkVisitBonus : mUnvisitedBookmarkBonus;
      case nsINavHistoryService::TRANSITION_DOWNLOAD:
        return mDownloadVisitBonus;
      case nsINavHistoryService::TRANSITION_REDIRECT_PERMANENT:
        return mPermRedirectVisitBonus;
      case nsINavHistoryService::TRANSITION_REDIRECT_TEMPORARY:
        return mTempRedirectVisitBonus;
      case nsINavHistoryService::TRANSITION_RELOAD:
        return mReloadVisitBonus;
      default:
        // 0 == undefined (see bug #375777 for details)
        NS_WARNING_ASSERTION(!aTransitionType,
                             "new transition but no bonus for frecency");
        return mDefaultVisitBonus;
    }
  }

  int32_t GetNumVisitsForFrecency() const
  {
    return mNumVisitsForFrecency;
  }

  /**
   * Fires onVisit event to nsINavHistoryService observers
   */
  void NotifyOnVisit(nsIURI* aURI,
                     int64_t aVisitId,
                     PRTime aTime,
                     int64_t aReferrerVisitId,
                     int32_t aTransitionType,
                     const nsACString& aGuid,
                     bool aHidden,
                     uint32_t aVisitCount,
                     uint32_t aTyped,
                     const nsAString& aLastKnownTitle);

  /**
   * Fires onTitleChanged event to nsINavHistoryService observers
   */
  void NotifyTitleChange(nsIURI* aURI,
                         const nsString& title,
                         const nsACString& aGUID);

  /**
   * Fires onFrecencyChanged event to nsINavHistoryService observers
   */
  void NotifyFrecencyChanged(nsIURI* aURI,
                             int32_t aNewFrecency,
                             const nsACString& aGUID,
                             bool aHidden,
                             PRTime aLastVisitDate);

  /**
   * Fires onManyFrecenciesChanged event to nsINavHistoryService observers
   */
  void NotifyManyFrecenciesChanged();

  /**
   * Posts a runnable to the main thread that calls NotifyFrecencyChanged.
   */
  void DispatchFrecencyChangedNotification(const nsACString& aSpec,
                                           int32_t aNewFrecency,
                                           const nsACString& aGUID,
                                           bool aHidden,
                                           PRTime aLastVisitDate) const;

  /**
   * Store last insterted id for a table.
   */
  static mozilla::Atomic<int64_t> sLastInsertedPlaceId;
  static mozilla::Atomic<int64_t> sLastInsertedVisitId;

  static void StoreLastInsertedId(const nsACString& aTable,
                                  const int64_t aLastInsertedId);

  bool isBatching() {
    return mBatchLevel > 0;
  }

private:
  ~nsNavHistory();

  // used by GetHistoryService
  static nsNavHistory *gHistoryService;

protected:

  // Database handle.
  RefPtr<mozilla::places::Database> mDB;

  /**
   * Decays frecency and inputhistory values.  Runs on idle-daily.
   */
  nsresult DecayFrecency();

  nsresult RemovePagesInternal(const nsCString& aPlaceIdsQueryString);
  nsresult CleanupPlacesOnVisitsDelete(const nsCString& aPlaceIdsQueryString);

  /**
   * Loads all of the preferences that we use into member variables.
   *
   * @note If mPrefBranch is nullptr, this does nothing.
   */
  void LoadPrefs();

  /**
   * Calculates and returns value for mCachedNow.
   * This is an hack to avoid calling PR_Now() too often, as is the case when
   * we're asked the ageindays of many history entries in a row.  A timer is
   * set which will clear our valid flag after a short timeout.
   */
  PRTime GetNow();
  PRTime mCachedNow;
  nsCOMPtr<nsITimer> mExpireNowTimer;
  /**
   * Called when the cached now value is expired and needs renewal.
   */
  static void expireNowTimerCallback(nsITimer* aTimer, void* aClosure);

  nsresult ConstructQueryString(const nsCOMArray<nsNavHistoryQuery>& aQueries,
                                nsNavHistoryQueryOptions* aOptions,
                                nsCString& queryString,
                                bool& aParamsPresent,
                                StringHash& aAddParams);

  nsresult QueryToSelectClause(nsNavHistoryQuery* aQuery,
                               nsNavHistoryQueryOptions* aOptions,
                               int32_t aQueryIndex,
                               nsCString* aClause);
  nsresult BindQueryClauseParameters(mozIStorageBaseStatement* statement,
                                     int32_t aQueryIndex,
                                     nsNavHistoryQuery* aQuery,
                                     nsNavHistoryQueryOptions* aOptions);

  nsresult ResultsAsList(mozIStorageStatement* statement,
                         nsNavHistoryQueryOptions* aOptions,
                         nsCOMArray<nsNavHistoryResultNode>* aResults);

  void TitleForDomain(const nsCString& domain, nsACString& aTitle);

  nsresult FilterResultSet(nsNavHistoryQueryResultNode *aParentNode,
                           const nsCOMArray<nsNavHistoryResultNode>& aSet,
                           nsCOMArray<nsNavHistoryResultNode>* aFiltered,
                           const nsCOMArray<nsNavHistoryQuery>& aQueries,
                           nsNavHistoryQueryOptions* aOptions);

  // observers
  nsMaybeWeakPtrArray<nsINavHistoryObserver> mObservers;

  // effective tld service
  nsCOMPtr<nsIEffectiveTLDService> mTLDService;
  nsCOMPtr<nsIIDNService>          mIDNService;

  // localization
  nsCOMPtr<nsIStringBundle> mBundle;
  nsCOMPtr<nsICollation> mCollation;

  // recent events
  typedef nsDataHashtable<nsCStringHashKey, int64_t> RecentEventHash;
  RecentEventHash mRecentTyped;
  RecentEventHash mRecentLink;
  RecentEventHash mRecentBookmark;

  // Embed visits tracking.
  class VisitHashKey : public nsURIHashKey
  {
  public:
    explicit VisitHashKey(const nsIURI* aURI)
    : nsURIHashKey(aURI)
    {
    }
    VisitHashKey(const VisitHashKey& aOther)
    : nsURIHashKey(aOther)
    {
      NS_NOTREACHED("Do not call me!");
    }
    PRTime visitTime;
  };

  nsTHashtable<VisitHashKey> mEmbedVisits;

  bool CheckIsRecentEvent(RecentEventHash* hashTable,
                            const nsACString& url);
  void ExpireNonrecentEvents(RecentEventHash* hashTable);

#ifdef MOZ_XUL
  nsresult AutoCompleteFeedback(int32_t aIndex,
                                nsIAutoCompleteController *aController);
#endif

  // Whether history is enabled or not.
  // Will mimic value of the places.history.enabled preference.
  bool mHistoryEnabled;

  // Frecency preferences.
  int32_t mNumVisitsForFrecency;
  int32_t mFirstBucketCutoffInDays;
  int32_t mSecondBucketCutoffInDays;
  int32_t mThirdBucketCutoffInDays;
  int32_t mFourthBucketCutoffInDays;
  int32_t mFirstBucketWeight;
  int32_t mSecondBucketWeight;
  int32_t mThirdBucketWeight;
  int32_t mFourthBucketWeight;
  int32_t mDefaultWeight;
  int32_t mEmbedVisitBonus;
  int32_t mFramedLinkVisitBonus;
  int32_t mLinkVisitBonus;
  int32_t mTypedVisitBonus;
  int32_t mBookmarkVisitBonus;
  int32_t mDownloadVisitBonus;
  int32_t mPermRedirectVisitBonus;
  int32_t mTempRedirectVisitBonus;
  int32_t mRedirectSourceVisitBonus;
  int32_t mDefaultVisitBonus;
  int32_t mUnvisitedBookmarkBonus;
  int32_t mUnvisitedTypedBonus;
  int32_t mReloadVisitBonus;

  // in nsNavHistoryQuery.cpp
  nsresult TokensToQueries(const nsTArray<QueryKeyValuePair>& aTokens,
                           nsCOMArray<nsNavHistoryQuery>* aQueries,
                           nsNavHistoryQueryOptions* aOptions);

  int64_t mTagsFolder;

  int32_t mDaysOfHistory;
  int64_t mLastCachedStartOfDay;
  int64_t mLastCachedEndOfDay;

  // Used to enable and disable the observer notifications
  bool mCanNotify;
  nsCategoryCache<nsINavHistoryObserver> mCacheObservers;
};


#define PLACES_URI_PREFIX "place:"

/* Returns true if the given URI represents a history query. */
inline bool IsQueryURI(const nsCString &uri)
{
  return StringBeginsWith(uri, NS_LITERAL_CSTRING(PLACES_URI_PREFIX));
}

/* Extracts the query string from a query URI. */
inline const nsDependentCSubstring QueryURIToQuery(const nsCString &uri)
{
  NS_ASSERTION(IsQueryURI(uri), "should only be called for query URIs");
  return Substring(uri, NS_LITERAL_CSTRING(PLACES_URI_PREFIX).Length());
}

#endif // nsNavHistory_h_
