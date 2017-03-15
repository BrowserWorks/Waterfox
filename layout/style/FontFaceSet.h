/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_FontFaceSet_h
#define mozilla_dom_FontFaceSet_h

#include "mozilla/dom/FontFace.h"
#include "mozilla/dom/FontFaceSetBinding.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "gfxUserFontSet.h"
#include "nsCSSRules.h"
#include "nsICSSLoaderObserver.h"

struct gfxFontFaceSrc;
class gfxUserFontEntry;
class nsFontFaceLoader;
class nsIPrincipal;
class nsPIDOMWindowInner;

namespace mozilla {
namespace css {
class FontFamilyListRefCnt;
} // namespace css
namespace dom {
class FontFace;
class Promise;
} // namespace dom
} // namespace mozilla

namespace mozilla {
namespace dom {

class FontFaceSet final : public DOMEventTargetHelper
                        , public nsIDOMEventListener
                        , public nsICSSLoaderObserver
{
  friend class UserFontSet;

public:
  /**
   * A gfxUserFontSet that integrates with the layout and style systems to
   * manage @font-face rules and handle network requests for font loading.
   *
   * We would combine this class and FontFaceSet into the one class if it were
   * possible; it's not because FontFaceSet is cycle collected and
   * gfxUserFontSet isn't (and can't be, as gfx classes don't use the cycle
   * collector).  So UserFontSet exists just to override the needed virtual
   * methods from gfxUserFontSet and to forward them on FontFaceSet.
   */
  class UserFontSet final : public gfxUserFontSet
  {
    friend class FontFaceSet;

  public:
    explicit UserFontSet(FontFaceSet* aFontFaceSet)
      : mFontFaceSet(aFontFaceSet)
    {
    }

    FontFaceSet* GetFontFaceSet() { return mFontFaceSet; }

    virtual nsresult CheckFontLoad(const gfxFontFaceSrc* aFontFaceSrc,
                                   nsIPrincipal** aPrincipal,
                                   bool* aBypassCache) override;

    virtual bool IsFontLoadAllowed(nsIURI* aFontLocation,
                                   nsIPrincipal* aPrincipal) override;

    virtual nsresult StartLoad(gfxUserFontEntry* aUserFontEntry,
                               const gfxFontFaceSrc* aFontFaceSrc) override;

    void RecordFontLoadDone(uint32_t aFontSize,
                            mozilla::TimeStamp aDoneTime) override;

  protected:
    virtual bool GetPrivateBrowsing() override;
    virtual nsresult SyncLoadFontData(gfxUserFontEntry* aFontToLoad,
                                      const gfxFontFaceSrc* aFontFaceSrc,
                                      uint8_t*& aBuffer,
                                      uint32_t& aBufferLength) override;
    virtual nsresult LogMessage(gfxUserFontEntry* aUserFontEntry,
                                const char* aMessage,
                                uint32_t aFlags = nsIScriptError::errorFlag,
                                nsresult aStatus = NS_OK) override;
    virtual void DoRebuildUserFontSet() override;
    virtual already_AddRefed<gfxUserFontEntry> CreateUserFontEntry(
                                   const nsTArray<gfxFontFaceSrc>& aFontFaceSrcList,
                                   uint32_t aWeight,
                                   int32_t aStretch,
                                   uint8_t aStyle,
                                   const nsTArray<gfxFontFeature>& aFeatureSettings,
                                   uint32_t aLanguageOverride,
                                   gfxSparseBitSet* aUnicodeRanges,
                                   uint8_t aFontDisplay) override;

  private:
    RefPtr<FontFaceSet> mFontFaceSet;
  };

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(FontFaceSet, DOMEventTargetHelper)
  NS_DECL_NSIDOMEVENTLISTENER

  FontFaceSet(nsPIDOMWindowInner* aWindow, nsIDocument* aDocument);

  virtual JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  UserFontSet* GetUserFontSet() { return mUserFontSet; }

  // Called by nsFontFaceLoader when the loader has completed normally.
  // It's removed from the mLoaders set.
  void RemoveLoader(nsFontFaceLoader* aLoader);

  bool UpdateRules(const nsTArray<nsFontFaceRuleContainer>& aRules);

  nsPresContext* GetPresContext();

  // search for @font-face rule that matches a platform font entry
  nsCSSFontFaceRule* FindRuleForEntry(gfxFontEntry* aFontEntry);

  void IncrementGeneration(bool aIsRebuild = false);

  /**
   * Finds an existing entry in the user font cache or creates a new user
   * font entry for the given FontFace object.
   */
  already_AddRefed<gfxUserFontEntry>
    FindOrCreateUserFontEntryFromFontFace(FontFace* aFontFace);

  /**
   * Notification method called by a FontFace to indicate that its loading
   * status has changed.
   */
  void OnFontFaceStatusChanged(FontFace* aFontFace);

  /**
   * Notification method called by the nsPresContext to indicate that the
   * refresh driver ticked and flushed style and layout.
   * were just flushed.
   */
  void DidRefresh();

  /**
   * Returns whether the "layout.css.font-loading-api.enabled" pref is true.
   */
  static bool PrefEnabled();

  // nsICSSLoaderObserver
  NS_IMETHOD StyleSheetLoaded(mozilla::StyleSheet* aSheet,
                              bool aWasAlternate,
                              nsresult aStatus) override;

  FontFace* GetFontFaceAt(uint32_t aIndex);

  void FlushUserFontSet();

  static nsPresContext* GetPresContextFor(gfxUserFontSet* aUserFontSet)
  {
    FontFaceSet* set = static_cast<UserFontSet*>(aUserFontSet)->mFontFaceSet;
    return set ? set->GetPresContext() : nullptr;
  }

  // -- Web IDL --------------------------------------------------------------

  IMPL_EVENT_HANDLER(loading)
  IMPL_EVENT_HANDLER(loadingdone)
  IMPL_EVENT_HANDLER(loadingerror)
  already_AddRefed<mozilla::dom::Promise> Load(JSContext* aCx,
                                               const nsAString& aFont,
                                               const nsAString& aText,
                                               mozilla::ErrorResult& aRv);
  bool Check(const nsAString& aFont,
             const nsAString& aText,
             mozilla::ErrorResult& aRv);
  mozilla::dom::Promise* GetReady(mozilla::ErrorResult& aRv);
  mozilla::dom::FontFaceSetLoadStatus Status();

  FontFaceSet* Add(FontFace& aFontFace, mozilla::ErrorResult& aRv);
  void Clear();
  bool Delete(FontFace& aFontFace);
  bool Has(FontFace& aFontFace);
  uint32_t Size();
  already_AddRefed<mozilla::dom::FontFaceSetIterator> Entries();
  already_AddRefed<mozilla::dom::FontFaceSetIterator> Values();
  void ForEach(JSContext* aCx, FontFaceSetForEachCallback& aCallback,
               JS::Handle<JS::Value> aThisArg,
               mozilla::ErrorResult& aRv);

private:
  ~FontFaceSet();

  /**
   * Returns whether the given FontFace is currently "in" the FontFaceSet.
   */
  bool HasAvailableFontFace(FontFace* aFontFace);

  /**
   * Removes any listeners and observers.
   */
  void Disconnect();

  void RemoveDOMContentLoadedListener();

  /**
   * Returns whether there might be any pending font loads, which should cause
   * the mReady Promise not to be resolved yet.
   */
  bool MightHavePendingFontLoads();

  /**
   * Checks to see whether it is time to replace mReady and dispatch a
   * "loading" event.
   */
  void CheckLoadingStarted();

  /**
   * Checks to see whether it is time to resolve mReady and dispatch any
   * "loadingdone" and "loadingerror" events.
   */
  void CheckLoadingFinished();

  /**
   * Callback for invoking CheckLoadingFinished after going through the
   * event loop.  See OnFontFaceStatusChanged.
   */
  void CheckLoadingFinishedAfterDelay();

  /**
   * Dispatches a FontFaceSetLoadEvent to this object.
   */
  void DispatchLoadingFinishedEvent(
                                const nsAString& aType,
                                const nsTArray<FontFace*>& aFontFaces);

  // Note: if you add new cycle collected objects to FontFaceRecord,
  // make sure to update FontFaceSet's cycle collection macros
  // accordingly.
  struct FontFaceRecord {
    RefPtr<FontFace> mFontFace;
    SheetType mSheetType;  // only relevant for mRuleFaces entries

    // When true, indicates that when finished loading, the FontFace should be
    // included in the subsequent loadingdone/loadingerror event fired at the
    // FontFaceSet.
    bool mLoadEventShouldFire;
  };

  already_AddRefed<gfxUserFontEntry> FindOrCreateUserFontEntryFromFontFace(
                                                   const nsAString& aFamilyName,
                                                   FontFace* aFontFace,
                                                   SheetType aSheetType);

  // search for @font-face rule that matches a userfont font entry
  nsCSSFontFaceRule* FindRuleForUserFontEntry(gfxUserFontEntry* aUserFontEntry);

  nsresult StartLoad(gfxUserFontEntry* aUserFontEntry,
                     const gfxFontFaceSrc* aFontFaceSrc);
  nsresult CheckFontLoad(const gfxFontFaceSrc* aFontFaceSrc,
                         nsIPrincipal** aPrincipal,
                         bool* aBypassCache);
  bool IsFontLoadAllowed(nsIURI* aFontLocation, nsIPrincipal* aPrincipal);
  bool GetPrivateBrowsing();
  nsresult SyncLoadFontData(gfxUserFontEntry* aFontToLoad,
                            const gfxFontFaceSrc* aFontFaceSrc,
                            uint8_t*& aBuffer,
                            uint32_t& aBufferLength);
  nsresult LogMessage(gfxUserFontEntry* aUserFontEntry,
                      const char* aMessage,
                      uint32_t aFlags,
                      nsresult aStatus);
  void RebuildUserFontSet();

  void InsertRuleFontFace(FontFace* aFontFace, SheetType aSheetType,
                          nsTArray<FontFaceRecord>& aOldRecords,
                          bool& aFontSetModified);
  void InsertNonRuleFontFace(FontFace* aFontFace, bool& aFontSetModified);

#ifdef DEBUG
  bool HasRuleFontFace(FontFace* aFontFace);
#endif

  /**
   * Returns whether we have any loading FontFace objects in the FontFaceSet.
   */
  bool HasLoadingFontFaces();

  // Helper function for HasLoadingFontFaces.
  void UpdateHasLoadingFontFaces();

  void ParseFontShorthandForMatching(
              const nsAString& aFont,
              RefPtr<mozilla::css::FontFamilyListRefCnt>& aFamilyList,
              uint32_t& aWeight,
              int32_t& aStretch,
              uint8_t& aStyle,
              ErrorResult& aRv);
  void FindMatchingFontFaces(const nsAString& aFont,
                             const nsAString& aText,
                             nsTArray<FontFace*>& aFontFaces,
                             mozilla::ErrorResult& aRv);

  TimeStamp GetNavigationStartTimeStamp();

  RefPtr<UserFontSet> mUserFontSet;

  // The document this is a FontFaceSet for.
  nsCOMPtr<nsIDocument> mDocument;

  // A Promise that is fulfilled once all of the FontFace objects
  // in mRuleFaces and mNonRuleFaces that started or were loading at the
  // time the Promise was created have finished loading.  It is rejected if
  // any of those fonts failed to load.  mReady is replaced with
  // a new Promise object whenever mReady is settled and another
  // FontFace in mRuleFaces or mNonRuleFaces starts to load.
  // Note that mReady is created lazily when GetReady() is called.
  RefPtr<mozilla::dom::Promise> mReady;
  // Whether the ready promise must be resolved when it's created.
  bool mResolveLazilyCreatedReadyPromise;

  // Set of all loaders pointing to us. These are not strong pointers,
  // but that's OK because nsFontFaceLoader always calls RemoveLoader on
  // us before it dies (unless we die first).
  nsTHashtable< nsPtrHashKey<nsFontFaceLoader> > mLoaders;

  // The @font-face rule backed FontFace objects in the FontFaceSet.
  nsTArray<FontFaceRecord> mRuleFaces;

  // The non rule backed FontFace objects that have been added to this
  // FontFaceSet.
  nsTArray<FontFaceRecord> mNonRuleFaces;

  // The overall status of the loading or loaded fonts in the FontFaceSet.
  mozilla::dom::FontFaceSetLoadStatus mStatus;

  // Whether mNonRuleFaces has changed since last time UpdateRules ran.
  bool mNonRuleFacesDirty;

  // Whether any FontFace objects in mRuleFaces or mNonRuleFaces are
  // loading.  Only valid when mHasLoadingFontFacesIsDirty is false.  Don't use
  // this variable directly; call the HasLoadingFontFaces method instead.
  bool mHasLoadingFontFaces;

  // This variable is only valid when mLoadingDirty is false.
  bool mHasLoadingFontFacesIsDirty;

  // Whether CheckLoadingFinished calls should be ignored.  See comment in
  // OnFontFaceStatusChanged.
  bool mDelayedLoadCheck;
};

} // namespace dom
} // namespace mozilla

#endif // !defined(mozilla_dom_FontFaceSet_h)
