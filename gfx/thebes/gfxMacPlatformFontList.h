/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef gfxMacPlatformFontList_H_
#define gfxMacPlatformFontList_H_

#include <CoreFoundation/CoreFoundation.h>

#include "mozilla/MemoryReporting.h"
#include "nsDataHashtable.h"
#include "nsRefPtrHashtable.h"

#include "gfxPlatformFontList.h"
#include "gfxPlatform.h"
#include "gfxPlatformMac.h"

#include "nsUnicharUtils.h"
#include "nsTArray.h"
#include "mozilla/LookAndFeel.h"

#include "mozilla/gfx/UnscaledFontMac.h"

class gfxMacPlatformFontList;

// a single member of a font family (i.e. a single face, such as Times Italic)
class MacOSFontEntry : public gfxFontEntry
{
public:
    friend class gfxMacPlatformFontList;

    MacOSFontEntry(const nsAString& aPostscriptName, int32_t aWeight,
                   bool aIsStandardFace = false,
                   double aSizeHint = 0.0);

    // for use with data fonts
    MacOSFontEntry(const nsAString& aPostscriptName, CGFontRef aFontRef,
                   uint16_t aWeight, uint16_t aStretch, uint8_t aStyle,
                   bool aIsDataUserFont, bool aIsLocal);

    virtual ~MacOSFontEntry() {
        ::CGFontRelease(mFontRef);
    }

    CGFontRef GetFontRef();

    // override gfxFontEntry table access function to bypass table cache,
    // use CGFontRef API to get direct access to system font data
    hb_blob_t *GetFontTable(uint32_t aTag) override;

    void AddSizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf,
                                FontListSizes* aSizes) const override;

    nsresult ReadCMAP(FontInfoData *aFontInfoData = nullptr) override;

    bool RequiresAATLayout() const { return mRequiresAAT; }

    bool HasVariations();
    bool IsCFF();

protected:
    gfxFont* CreateFontInstance(const gfxFontStyle *aFontStyle,
                                bool aNeedsBold) override;

    bool HasFontTable(uint32_t aTableTag) override;

    static void DestroyBlobFunc(void* aUserData);

    CGFontRef mFontRef; // owning reference to the CGFont, released on destruction

    double mSizeHint;

    bool mFontRefInitialized;
    bool mRequiresAAT;
    bool mIsCFF;
    bool mIsCFFInitialized;
    bool mHasVariations;
    bool mHasVariationsInitialized;
    nsTHashtable<nsUint32HashKey> mAvailableTables;

    mozilla::WeakPtr<mozilla::gfx::UnscaledFont> mUnscaledFont;
};

class gfxMacPlatformFontList : public gfxPlatformFontList {
public:
    static gfxMacPlatformFontList* PlatformFontList() {
        return static_cast<gfxMacPlatformFontList*>(sPlatformFontList);
    }

    static int32_t AppleWeightToCSSWeight(int32_t aAppleWeight);

    bool GetStandardFamilyName(const nsAString& aFontName, nsAString& aFamilyName) override;

    gfxFontEntry* LookupLocalFont(const nsAString& aFontName,
                                  uint16_t aWeight,
                                  int16_t aStretch,
                                  uint8_t aStyle) override;

    gfxFontEntry* MakePlatformFont(const nsAString& aFontName,
                                   uint16_t aWeight,
                                   int16_t aStretch,
                                   uint8_t aStyle,
                                   const uint8_t* aFontData,
                                   uint32_t aLength) override;

    bool FindAndAddFamilies(const nsAString& aFamily,
                            nsTArray<gfxFontFamily*>* aOutput,
                            gfxFontStyle* aStyle = nullptr,
                            gfxFloat aDevToCssSize = 1.0) override;

    // lookup the system font for a particular system font type and set
    // the name and style characteristics
    void LookupSystemFont(mozilla::LookAndFeel::FontID aSystemFontID,
                          nsAString& aSystemFontName,
                          gfxFontStyle &aFontStyle,
                          float aDevPixPerCSSPixel);

    // Values for the entryType field in FontFamilyListEntry records passed
    // from chrome to content process.
    enum FontFamilyEntryType {
        kStandardFontFamily = 0, // a standard installed font family
        kHiddenSystemFontFamily = 1, // hidden system family, not exposed to UI
        kTextSizeSystemFontFamily = 2, // name of 'system' font at text sizes
        kDisplaySizeSystemFontFamily = 3 // 'system' font at display sizes
    };
    void GetSystemFontFamilyList(
        InfallibleTArray<mozilla::dom::FontFamilyListEntry>* aList);

protected:
    gfxFontFamily*
    GetDefaultFontForPlatform(const gfxFontStyle* aStyle) override;

private:
    friend class gfxPlatformMac;

    gfxMacPlatformFontList();
    virtual ~gfxMacPlatformFontList();

    // initialize font lists
    nsresult InitFontListForPlatform() override;

    // special case font faces treated as font families (set via prefs)
    void InitSingleFaceList();

    // initialize system fonts
    void InitSystemFontNames();

    // helper function to lookup in both hidden system fonts and normal fonts
    gfxFontFamily* FindSystemFontFamily(const nsAString& aFamily);

    static void
    RegisteredFontsChangedNotificationCallback(CFNotificationCenterRef center,
                                               void *observer,
                                               CFStringRef name,
                                               const void *object,
                                               CFDictionaryRef userInfo);

    // attempt to use platform-specific fallback for the given character
    // return null if no usable result found
    gfxFontEntry*
    PlatformGlobalFontFallback(const uint32_t aCh,
                               Script aRunScript,
                               const gfxFontStyle* aMatchStyle,
                               gfxFontFamily** aMatchedFamily) override;

    bool UsesSystemFallback() override { return true; }

    already_AddRefed<FontInfoData> CreateFontInfoData() override;

    // Add the specified family to mSystemFontFamilies or mFontFamilies.
    // Ideally we'd use NSString* instead of CFStringRef here, but this header
    // file is included in .cpp files, so we can't use objective C classes here.
    // But CFStringRef and NSString* are the same thing anyway (they're
    // toll-free bridged).
    void AddFamily(CFStringRef aFamily);

    void AddFamily(const nsAString& aFamilyName, bool aSystemFont);

#ifdef MOZ_BUNDLED_FONTS
    void ActivateBundledFonts();
#endif

    enum {
        kATSGenerationInitial = -1
    };

    // default font for use with system-wide font fallback
    CTFontRef mDefaultFont;

    // hidden system fonts used within UI elements, there may be a whole set
    // for different locales (e.g. .Helvetica Neue UI, .SF NS Text)
    FontFamilyTable mSystemFontFamilies;

    // font families that -apple-system maps to
    // Pre-10.11 this was always a single font family, such as Lucida Grande
    // or Helvetica Neue. For OSX 10.11, Apple uses pair of families
    // for the UI, one for text sizes and another for display sizes
    bool mUseSizeSensitiveSystemFont;
    nsString mSystemTextFontFamilyName;
    nsString mSystemDisplayFontFamilyName; // only used on OSX 10.11
};

#endif /* gfxMacPlatformFontList_H_ */
