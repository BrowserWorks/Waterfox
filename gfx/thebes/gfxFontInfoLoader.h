/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_FONT_INFO_LOADER_H
#define GFX_FONT_INFO_LOADER_H

#include "nsCOMPtr.h"
#include "nsIObserver.h"
#include "nsITimer.h"
#include "nsIThread.h"
#include "nsRefPtrHashtable.h"
#include "nsString.h"
#include "gfxFont.h"
#include "mozilla/Atomics.h"
#include "mozilla/TimeStamp.h"
#include "nsISupportsImpl.h"

// data retrieved for a given face

struct FontFaceData {
  nsCString mFullName;
  nsCString mPostscriptName;
  RefPtr<gfxCharacterMap> mCharacterMap;
  uint32_t mUVSOffset = 0;
};

// base class used to contain cached system-wide font info.
// methods in this class are called on off-main threads so
// all methods use only static methods or other thread-safe
// font data access API's. specifically, no use is made of
// gfxPlatformFontList, gfxFontFamily, gfxFamily or any
// harfbuzz API methods within FontInfoData subclasses.

class FontInfoData {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(FontInfoData)

  FontInfoData(bool aLoadOtherNames, bool aLoadFaceNames, bool aLoadCmaps)
      : mCanceled(false),
        mLoadOtherNames(aLoadOtherNames),
        mLoadFaceNames(aLoadFaceNames),
        mLoadCmaps(aLoadCmaps) {
    MOZ_COUNT_CTOR(FontInfoData);
  }

 protected:
  // Protected destructor, to discourage deletion outside of Release():
  MOZ_COUNTED_DTOR_VIRTUAL(FontInfoData)

 public:
  virtual void Load();

  // loads font data for all fonts of a given family
  // (called on async thread)
  virtual void LoadFontFamilyData(const nsACString& aFamilyName) = 0;

  // -- methods overriden by platform-specific versions --

  // fetches cmap data for a particular font from cached font data
  virtual already_AddRefed<gfxCharacterMap> GetCMAP(const nsACString& aFontName,
                                                    uint32_t& aUVSOffset) {
    FontFaceData faceData;
    if (!mFontFaceData.Get(aFontName, &faceData) || !faceData.mCharacterMap) {
      return nullptr;
    }

    aUVSOffset = faceData.mUVSOffset;
    RefPtr<gfxCharacterMap> cmap = faceData.mCharacterMap;
    return cmap.forget();
  }

  // fetches fullname/postscript names from cached font data
  virtual void GetFaceNames(const nsACString& aFontName, nsACString& aFullName,
                            nsACString& aPostscriptName) {
    FontFaceData faceData;
    if (!mFontFaceData.Get(aFontName, &faceData)) {
      return;
    }

    aFullName = faceData.mFullName;
    aPostscriptName = faceData.mPostscriptName;
  }

  // fetches localized family name data from cached font data
  const nsTArray<nsCString>* GetOtherFamilyNames(
      const nsACString& aFamilyName) {
    return mOtherFamilyNames.GetValue(aFamilyName);
  }

  nsTArray<nsCString> mFontFamiliesToLoad;

  // currently non-issue but beware,
  // this is also set during cleanup after finishing
  mozilla::Atomic<bool> mCanceled;

  // time spent on the loader thread
  mozilla::TimeDuration mLoadTime;

  struct FontCounts {
    uint32_t families;
    uint32_t fonts;
    uint32_t cmaps;
    uint32_t facenames;
    uint32_t othernames;
  };

  FontCounts mLoadStats;

  bool mLoadOtherNames;
  bool mLoadFaceNames;
  bool mLoadCmaps;

  // face name ==> per-face data
  nsDataHashtable<nsCStringHashKey, FontFaceData> mFontFaceData;

  // canonical family name ==> array of localized family names
  nsDataHashtable<nsCStringHashKey, CopyableTArray<nsCString> >
      mOtherFamilyNames;
};

// gfxFontInfoLoader - helper class for loading font info on async thread
// For large, "all fonts on system" data, data needed on a given platform
// (e.g. localized names, face names, cmaps) are loaded async.

// helper class for loading in font info on a separate async thread
// once async thread completes, completion process is run on regular
// intervals to prevent tying up the main thread

class gfxFontInfoLoader {
 public:
  // state transitions:
  //   initial ---StartLoader with delay---> timer on delay
  //   initial ---StartLoader without delay---> timer on interval
  //   timer on delay ---LoaderTimerFire---> timer on interval
  //   timer on delay ---CancelLoader---> timer off
  //   timer on interval ---CancelLoader---> timer off
  //   timer off ---StartLoader with delay---> timer on delay
  //   timer off ---StartLoader without delay---> timer on interval
  typedef enum {
    stateInitial,
    stateTimerOnDelay,
    stateAsyncLoad,
    stateTimerOnInterval,
    stateTimerOff
  } TimerState;

  gfxFontInfoLoader() : mInterval(0), mState(stateInitial) {
    MOZ_COUNT_CTOR(gfxFontInfoLoader);
  }

  virtual ~gfxFontInfoLoader();

  // start timer with an initial delay, then call Run method at regular
  // intervals
  void StartLoader(uint32_t aDelay, uint32_t aInterval);

  // Finalize - async load complete, transfer data (on intervals if necessary)
  virtual void FinalizeLoader(FontInfoData* aFontInfo);

  // cancel the timer and cleanup
  void CancelLoader();

  uint32_t GetInterval() { return mInterval; }

 protected:
  class ShutdownObserver : public nsIObserver {
   public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIOBSERVER

    explicit ShutdownObserver(gfxFontInfoLoader* aLoader) : mLoader(aLoader) {}

   protected:
    virtual ~ShutdownObserver() = default;

    gfxFontInfoLoader* mLoader;
  };

  // CreateFontInfo - create platform-specific object used
  //                  to load system-wide font info
  virtual already_AddRefed<FontInfoData> CreateFontInfoData() {
    return nullptr;
  }

  // Init - initialization before async loader thread runs
  virtual void InitLoader() = 0;

  // LoadFontInfo - transfer font info data within a time limit, return
  //                true when done
  virtual bool LoadFontInfo() = 0;

  // Cleanup - finish and cleanup after done, including possible reflows
  virtual void CleanupLoader() { mFontInfo = nullptr; }

  // Timer interval callbacks
  static void LoadFontInfoCallback(nsITimer* aTimer, void* aThis) {
    gfxFontInfoLoader* loader = static_cast<gfxFontInfoLoader*>(aThis);
    loader->LoadFontInfoTimerFire();
  }

  static void DelayedStartCallback(nsITimer* aTimer, void* aThis) {
    gfxFontInfoLoader* loader = static_cast<gfxFontInfoLoader*>(aThis);
    loader->StartLoader(0, loader->GetInterval());
  }

  void LoadFontInfoTimerFire();

  void AddShutdownObserver();
  void RemoveShutdownObserver();

  nsCOMPtr<nsITimer> mTimer;
  nsCOMPtr<nsIObserver> mObserver;
  nsCOMPtr<nsIThread> mFontLoaderThread;
  uint32_t mInterval;
  TimerState mState;

  // after async font loader completes, data is stored here
  RefPtr<FontInfoData> mFontInfo;

  // time spent on the loader thread
  mozilla::TimeDuration mLoadTime;
};

#endif /* GFX_FONT_INFO_LOADER_H */
