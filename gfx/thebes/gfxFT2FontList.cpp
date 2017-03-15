/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"
#include "mozilla/Base64.h"
#include "mozilla/MemoryReporting.h"

#include "mozilla/dom/ContentChild.h"
#include "gfxAndroidPlatform.h"
#include "mozilla/Omnijar.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/UniquePtrExtensions.h"
#include "nsIInputStream.h"
#define gfxToolkitPlatform gfxAndroidPlatform

#include "nsXULAppAPI.h"
#include <dirent.h>
#include <android/log.h>
#define ALOG(args...)  __android_log_print(ANDROID_LOG_INFO, "Gecko" , ## args)

#include "ft2build.h"
#include FT_FREETYPE_H
#include FT_TRUETYPE_TAGS_H
#include FT_TRUETYPE_TABLES_H
#include "cairo-ft.h"

#include "gfxFT2FontList.h"
#include "gfxFT2Fonts.h"
#include "gfxUserFontSet.h"
#include "gfxFontUtils.h"

#include "nsServiceManagerUtils.h"
#include "nsIObserverService.h"
#include "nsTArray.h"
#include "nsUnicharUtils.h"
#include "nsCRT.h"

#include "nsDirectoryServiceUtils.h"
#include "nsDirectoryServiceDefs.h"
#include "nsAppDirectoryServiceDefs.h"
#include "nsISimpleEnumerator.h"
#include "nsIMemory.h"
#include "gfxFontConstants.h"

#include "mozilla/Preferences.h"
#include "mozilla/scache/StartupCache.h"
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>

using namespace mozilla;

static LazyLogModule sFontInfoLog("fontInfoLog");

#undef LOG
#define LOG(args) MOZ_LOG(sFontInfoLog, mozilla::LogLevel::Debug, args)
#define LOG_ENABLED() MOZ_LOG_TEST(sFontInfoLog, mozilla::LogLevel::Debug)

static cairo_user_data_key_t sFTUserFontDataKey;

static __inline void
BuildKeyNameFromFontName(nsAString &aName)
{
    ToLowerCase(aName);
}

// Helper to access the FT_Face for a given FT2FontEntry,
// creating a temporary face if the entry does not have one yet.
// This allows us to read font names, tables, etc if necessary
// without permanently instantiating a freetype face and consuming
// memory long-term.
// This may fail (resulting in a null FT_Face), e.g. if it fails to
// allocate memory to uncompress a font from omnijar.
class AutoFTFace {
public:
    AutoFTFace(FT2FontEntry* aFontEntry)
        : mFace(nullptr), mFontDataBuf(nullptr), mOwnsFace(false)
    {
        if (aFontEntry->mFTFace) {
            mFace = aFontEntry->mFTFace;
            return;
        }

        NS_ASSERTION(!aFontEntry->mFilename.IsEmpty(),
                     "can't use AutoFTFace for fonts without a filename");
        FT_Library ft = gfxToolkitPlatform::GetPlatform()->GetFTLibrary();

        // A relative path (no initial "/") means this is a resource in
        // omnijar, not an installed font on the device.
        // The NS_ASSERTIONs here should never fail, as the resource must have
        // been read successfully during font-list initialization or we'd never
        // have created the font entry. The only legitimate runtime failure
        // here would be memory allocation, in which case mFace remains null.
        if (aFontEntry->mFilename[0] != '/') {
            RefPtr<nsZipArchive> reader =
                Omnijar::GetReader(Omnijar::Type::GRE);
            nsZipItem *item = reader->GetItem(aFontEntry->mFilename.get());
            NS_ASSERTION(item, "failed to find zip entry");

            uint32_t bufSize = item->RealSize();
            mFontDataBuf = static_cast<uint8_t*>(malloc(bufSize));
            if (mFontDataBuf) {
                nsZipCursor cursor(item, reader, mFontDataBuf, bufSize);
                cursor.Copy(&bufSize);
                NS_ASSERTION(bufSize == item->RealSize(),
                             "error reading bundled font");

                if (FT_Err_Ok != FT_New_Memory_Face(ft, mFontDataBuf, bufSize,
                                                    aFontEntry->mFTFontIndex,
                                                    &mFace)) {
                    NS_WARNING("failed to create freetype face");
                }
            }
        } else {
            if (FT_Err_Ok != FT_New_Face(ft, aFontEntry->mFilename.get(),
                                         aFontEntry->mFTFontIndex, &mFace)) {
                NS_WARNING("failed to create freetype face");
            }
        }
        if (FT_Err_Ok != FT_Select_Charmap(mFace, FT_ENCODING_UNICODE)) {
            NS_WARNING("failed to select Unicode charmap");
        }
        mOwnsFace = true;
    }

    ~AutoFTFace() {
        if (mFace && mOwnsFace) {
            FT_Done_Face(mFace);
            if (mFontDataBuf) {
                free(mFontDataBuf);
            }
        }
    }

    operator FT_Face() { return mFace; }

    // If we 'forget' the FT_Face (used when ownership is handed over to Cairo),
    // we do -not- free the mFontDataBuf (if used); that also becomes the
    // responsibility of the new owner of the face.
    FT_Face forget() {
        NS_ASSERTION(mOwnsFace, "can't forget() when we didn't own the face");
        mOwnsFace = false;
        return mFace;
    }

    const uint8_t* FontData() const { return mFontDataBuf; }

private:
    FT_Face  mFace;
    uint8_t* mFontDataBuf; // Uncompressed data (for fonts stored in a JAR),
                           // or null for fonts instantiated from a file.
                           // If non-null, this must survive as long as the
                           // FT_Face.
    bool     mOwnsFace;
};

/*
 * FT2FontEntry
 * gfxFontEntry subclass corresponding to a specific face that can be
 * rendered by freetype. This is associated with a face index in a
 * file (normally a .ttf/.otf file holding a single face, but in principle
 * there could be .ttc files with multiple faces).
 * The FT2FontEntry can create the necessary FT_Face on demand, and can
 * then create a Cairo font_face and scaled_font for drawing.
 */

cairo_scaled_font_t *
FT2FontEntry::CreateScaledFont(const gfxFontStyle *aStyle)
{
    cairo_font_face_t *cairoFace = CairoFontFace();
    if (!cairoFace) {
        return nullptr;
    }

    cairo_scaled_font_t *scaledFont = nullptr;

    cairo_matrix_t sizeMatrix;
    cairo_matrix_t identityMatrix;

    // XXX deal with adjusted size
    cairo_matrix_init_scale(&sizeMatrix, aStyle->size, aStyle->size);
    cairo_matrix_init_identity(&identityMatrix);

    // synthetic oblique by skewing via the font matrix
    bool needsOblique = IsUpright() &&
                        aStyle->style != NS_FONT_STYLE_NORMAL &&
                        aStyle->allowSyntheticStyle;

    if (needsOblique) {
        cairo_matrix_t style;
        cairo_matrix_init(&style,
                          1,                //xx
                          0,                //yx
                          -1 * OBLIQUE_SKEW_FACTOR, //xy
                          1,                //yy
                          0,                //x0
                          0);               //y0
        cairo_matrix_multiply(&sizeMatrix, &sizeMatrix, &style);
    }

    cairo_font_options_t *fontOptions = cairo_font_options_create();

    if (gfxPlatform::GetPlatform()->RequiresLinearZoom()) {
        cairo_font_options_set_hint_metrics(fontOptions, CAIRO_HINT_METRICS_OFF);
    }

    scaledFont = cairo_scaled_font_create(cairoFace,
                                          &sizeMatrix,
                                          &identityMatrix, fontOptions);
    cairo_font_options_destroy(fontOptions);

    NS_ASSERTION(cairo_scaled_font_status(scaledFont) == CAIRO_STATUS_SUCCESS,
                 "Failed to make scaled font");

    return scaledFont;
}

FT2FontEntry::~FT2FontEntry()
{
    // Do nothing for mFTFace here since FTFontDestroyFunc is called by cairo.
    mFTFace = nullptr;

#ifndef ANDROID
    if (mFontFace) {
        cairo_font_face_destroy(mFontFace);
        mFontFace = nullptr;
    }
#endif
}

gfxFont*
FT2FontEntry::CreateFontInstance(const gfxFontStyle *aFontStyle, bool aNeedsBold)
{
    cairo_scaled_font_t *scaledFont = CreateScaledFont(aFontStyle);
    if (!scaledFont) {
        return nullptr;
    }
    gfxFont *font = new gfxFT2Font(scaledFont, this, aFontStyle, aNeedsBold);
    cairo_scaled_font_destroy(scaledFont);
    return font;
}

/* static */
FT2FontEntry*
FT2FontEntry::CreateFontEntry(const nsAString& aFontName,
                              uint16_t aWeight,
                              int16_t aStretch,
                              uint8_t aStyle,
                              const uint8_t* aFontData,
                              uint32_t aLength)
{
    // Ownership of aFontData is passed in here; the fontEntry must
    // retain it as long as the FT_Face needs it, and ensure it is
    // eventually deleted.
    FT_Face face;
    FT_Error error =
        FT_New_Memory_Face(gfxToolkitPlatform::GetPlatform()->GetFTLibrary(),
                           aFontData, aLength, 0, &face);
    if (error != FT_Err_Ok) {
        free((void*)aFontData);
        return nullptr;
    }
    if (FT_Err_Ok != FT_Select_Charmap(face, FT_ENCODING_UNICODE)) {
        FT_Done_Face(face);
        free((void*)aFontData);
        return nullptr;
    }
    // Create our FT2FontEntry, which inherits the name of the userfont entry
    // as it's not guaranteed that the face has valid names (bug 737315)
    FT2FontEntry* fe =
        FT2FontEntry::CreateFontEntry(face, nullptr, 0, aFontName,
                                      aFontData);
    if (fe) {
        fe->mStyle = aStyle;
        fe->mWeight = aWeight;
        fe->mStretch = aStretch;
        fe->mIsDataUserFont = true;
    }
    return fe;
}

class FTUserFontData {
public:
    FTUserFontData(FT_Face aFace, const uint8_t* aData)
        : mFace(aFace), mFontData(aData)
    {
    }

    ~FTUserFontData()
    {
        FT_Done_Face(mFace);
        if (mFontData) {
            free((void*)mFontData);
        }
    }

    const uint8_t *FontData() const { return mFontData; }

private:
    FT_Face        mFace;
    const uint8_t *mFontData;
};

static void
FTFontDestroyFunc(void *data)
{
    FTUserFontData *userFontData = static_cast<FTUserFontData*>(data);
    delete userFontData;
}

/* static */
FT2FontEntry*
FT2FontEntry::CreateFontEntry(const FontListEntry& aFLE)
{
    FT2FontEntry *fe = new FT2FontEntry(aFLE.faceName());
    fe->mFilename = aFLE.filepath();
    fe->mFTFontIndex = aFLE.index();
    fe->mWeight = aFLE.weight();
    fe->mStretch = aFLE.stretch();
    fe->mStyle = (aFLE.italic() ? NS_FONT_STYLE_ITALIC : NS_FONT_STYLE_NORMAL);
    return fe;
}

// Helpers to extract font entry properties from an FT_Face
static bool
FTFaceIsItalic(FT_Face aFace)
{
    return !!(aFace->style_flags & FT_STYLE_FLAG_ITALIC);
}

static uint16_t
FTFaceGetWeight(FT_Face aFace)
{
    TT_OS2 *os2 = static_cast<TT_OS2*>(FT_Get_Sfnt_Table(aFace, ft_sfnt_os2));
    uint16_t os2weight = 0;
    if (os2 && os2->version != 0xffff) {
        // Technically, only 100 to 900 are valid, but some fonts
        // have this set wrong -- e.g. "Microsoft Logo Bold Italic" has
        // it set to 6 instead of 600.  We try to be nice and handle that
        // as well.
        if (os2->usWeightClass >= 100 && os2->usWeightClass <= 900) {
            os2weight = os2->usWeightClass;
        } else if (os2->usWeightClass >= 1 && os2->usWeightClass <= 9) {
            os2weight = os2->usWeightClass * 100;
        }
    }

    uint16_t result;
    if (os2weight != 0) {
        result = os2weight;
    } else if (aFace->style_flags & FT_STYLE_FLAG_BOLD) {
        result = 700;
    } else {
        result = 400;
    }

    NS_ASSERTION(result >= 100 && result <= 900, "Invalid weight in font!");

    return result;
}

// Used to create the font entry for installed faces on the device,
// when iterating over the fonts directories.
// We use the FT_Face to retrieve the details needed for the font entry,
// but unless we have been passed font data (i.e. for a user font),
// we do *not* save a reference to it, nor create a cairo face,
// as we don't want to keep a freetype face for every installed font
// permanently in memory.
/* static */
FT2FontEntry*
FT2FontEntry::CreateFontEntry(FT_Face aFace,
                              const char* aFilename, uint8_t aIndex,
                              const nsAString& aName,
                              const uint8_t* aFontData)
{
    FT2FontEntry *fe = new FT2FontEntry(aName);
    fe->mStyle = (FTFaceIsItalic(aFace) ?
                  NS_FONT_STYLE_ITALIC : NS_FONT_STYLE_NORMAL);
    fe->mWeight = FTFaceGetWeight(aFace);
    fe->mFilename = aFilename;
    fe->mFTFontIndex = aIndex;

    if (aFontData) {
        fe->mFTFace = aFace;
        int flags = gfxPlatform::GetPlatform()->FontHintingEnabled() ?
                    FT_LOAD_DEFAULT :
                    (FT_LOAD_NO_AUTOHINT | FT_LOAD_NO_HINTING);
        fe->mFontFace = cairo_ft_font_face_create_for_ft_face(aFace, flags);
        FTUserFontData *userFontData = new FTUserFontData(aFace, aFontData);
        cairo_font_face_set_user_data(fe->mFontFace, &sFTUserFontDataKey,
                                      userFontData, FTFontDestroyFunc);
    }

    return fe;
}

// construct font entry name for an installed font from names in the FT_Face,
// and then create our FT2FontEntry
static FT2FontEntry*
CreateNamedFontEntry(FT_Face aFace, const char* aFilename, uint8_t aIndex)
{
    if (!aFace->family_name) {
        return nullptr;
    }
    nsAutoString fontName;
    AppendUTF8toUTF16(aFace->family_name, fontName);
    if (aFace->style_name && strcmp("Regular", aFace->style_name)) {
        fontName.Append(' ');
        AppendUTF8toUTF16(aFace->style_name, fontName);
    }
    return FT2FontEntry::CreateFontEntry(aFace, aFilename, aIndex, fontName);
}

FT2FontEntry*
gfxFT2Font::GetFontEntry()
{
    return static_cast<FT2FontEntry*> (mFontEntry.get());
}

cairo_font_face_t *
FT2FontEntry::CairoFontFace()
{
    if (!mFontFace) {
        AutoFTFace face(this);
        if (!face) {
            return nullptr;
        }
        mFTFace = face.forget();
        int flags = gfxPlatform::GetPlatform()->FontHintingEnabled() ?
                    FT_LOAD_DEFAULT :
                    (FT_LOAD_NO_AUTOHINT | FT_LOAD_NO_HINTING);
        mFontFace = cairo_ft_font_face_create_for_ft_face(face, flags);
        FTUserFontData *userFontData = new FTUserFontData(face, face.FontData());
        cairo_font_face_set_user_data(mFontFace, &sFTUserFontDataKey,
                                      userFontData, FTFontDestroyFunc);
    }
    return mFontFace;
}

// Copied/modified from similar code in gfxMacPlatformFontList.mm:
// Complex scripts will not render correctly unless Graphite or OT
// layout tables are present.
// For OpenType, we also check that the GSUB table supports the relevant
// script tag, to avoid using things like Arial Unicode MS for Lao (it has
// the characters, but lacks OpenType support).

// TODO: consider whether we should move this to gfxFontEntry and do similar
// cmap-masking on all platforms to avoid using fonts that won't shape
// properly.

nsresult
FT2FontEntry::ReadCMAP(FontInfoData *aFontInfoData)
{
    if (mCharacterMap) {
        return NS_OK;
    }

    RefPtr<gfxCharacterMap> charmap = new gfxCharacterMap();

    AutoTArray<uint8_t, 16384> buffer;
    nsresult rv = CopyFontTable(TTAG_cmap, buffer);
    
    if (NS_SUCCEEDED(rv)) {
        bool unicodeFont;
        bool symbolFont;
        rv = gfxFontUtils::ReadCMAP(buffer.Elements(), buffer.Length(),
                                    *charmap, mUVSOffset,
                                    unicodeFont, symbolFont);
    }

    if (NS_SUCCEEDED(rv) && !HasGraphiteTables()) {
        // We assume a Graphite font knows what it's doing,
        // and provides whatever shaping is needed for the
        // characters it supports, so only check/clear the
        // complex-script ranges for non-Graphite fonts

        // for layout support, check for the presence of opentype layout tables
        bool hasGSUB = HasFontTable(TRUETYPE_TAG('G','S','U','B'));

        for (const ScriptRange* sr = gfxPlatformFontList::sComplexScriptRanges;
             sr->rangeStart; sr++) {
            // check to see if the cmap includes complex script codepoints
            if (charmap->TestRange(sr->rangeStart, sr->rangeEnd)) {
                // We check for GSUB here, as GPOS alone would not be ok.
                if (hasGSUB && SupportsScriptInGSUB(sr->tags)) {
                    continue;
                }
                charmap->ClearRange(sr->rangeStart, sr->rangeEnd);
            }
        }
    }

#ifdef MOZ_WIDGET_ANDROID
    // Hack for the SamsungDevanagari font, bug 1012365:
    // pretend the font supports U+0972.
    if (!charmap->test(0x0972) &&
        charmap->test(0x0905) && charmap->test(0x0945)) {
        charmap->set(0x0972);
    }
#endif

    mHasCmapTable = NS_SUCCEEDED(rv);
    if (mHasCmapTable) {
        gfxPlatformFontList *pfl = gfxPlatformFontList::PlatformFontList();
        mCharacterMap = pfl->FindCharMap(charmap);
    } else {
        // if error occurred, initialize to null cmap
        mCharacterMap = new gfxCharacterMap();
    }
    return rv;
}

nsresult
FT2FontEntry::CopyFontTable(uint32_t aTableTag, nsTArray<uint8_t>& aBuffer)
{
    AutoFTFace face(this);
    if (!face) {
        return NS_ERROR_FAILURE;
    }

    FT_Error status;
    FT_ULong len = 0;
    status = FT_Load_Sfnt_Table(face, aTableTag, 0, nullptr, &len);
    if (status != FT_Err_Ok || len == 0) {
        return NS_ERROR_FAILURE;
    }

    if (!aBuffer.SetLength(len, fallible)) {
        return NS_ERROR_OUT_OF_MEMORY;
    }
    uint8_t *buf = aBuffer.Elements();
    status = FT_Load_Sfnt_Table(face, aTableTag, 0, buf, &len);
    NS_ENSURE_TRUE(status == FT_Err_Ok, NS_ERROR_FAILURE);

    return NS_OK;
}

hb_blob_t*
FT2FontEntry::GetFontTable(uint32_t aTableTag)
{
    if (mFontFace) {
        // if there's a cairo font face, we may be able to return a blob
        // that just wraps a range of the attached user font data
        FTUserFontData *userFontData = static_cast<FTUserFontData*>(
            cairo_font_face_get_user_data(mFontFace, &sFTUserFontDataKey));
        if (userFontData && userFontData->FontData()) {
            return gfxFontUtils::GetTableFromFontData(userFontData->FontData(),
                                                      aTableTag);
        }
    }

    // otherwise, use the default method (which in turn will call our
    // implementation of CopyFontTable)
    return gfxFontEntry::GetFontTable(aTableTag);
}

void
FT2FontEntry::AddSizeOfExcludingThis(MallocSizeOf aMallocSizeOf,
                                     FontListSizes* aSizes) const
{
    gfxFontEntry::AddSizeOfExcludingThis(aMallocSizeOf, aSizes);
    aSizes->mFontListSize +=
        mFilename.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
}

void
FT2FontEntry::AddSizeOfIncludingThis(MallocSizeOf aMallocSizeOf,
                                     FontListSizes* aSizes) const
{
    aSizes->mFontListSize += aMallocSizeOf(this);
    AddSizeOfExcludingThis(aMallocSizeOf, aSizes);
}

/*
 * FT2FontFamily
 * A standard gfxFontFamily; just adds a method used to support sending
 * the font list from chrome to content via IPC.
 */

void
FT2FontFamily::AddFacesToFontList(InfallibleTArray<FontListEntry>* aFontList,
                                  Visibility aVisibility)
{
    for (int i = 0, n = mAvailableFonts.Length(); i < n; ++i) {
        const FT2FontEntry *fe =
            static_cast<const FT2FontEntry*>(mAvailableFonts[i].get());
        if (!fe) {
            continue;
        }
        
        aFontList->AppendElement(FontListEntry(Name(), fe->Name(),
                                               fe->mFilename,
                                               fe->Weight(), fe->Stretch(),
                                               fe->mStyle,
                                               fe->mFTFontIndex,
                                               aVisibility == kHidden));
    }
}

/*
 * Startup cache support for the font list:
 * We store the list of families and faces, with their style attributes and the
 * corresponding font files, in the startup cache.
 * This allows us to recreate the gfxFT2FontList collection of families and
 * faces without instantiating Freetype faces for each font file (in order to
 * find their attributes), leading to significantly quicker startup.
 */

#define CACHE_KEY "font.cached-list"

class FontNameCache {
public:
    // Creates the object but does NOT load the cached data from the startup
    // cache; call Init() after creation to do that.
    FontNameCache()
        : mMap(&mOps, sizeof(FNCMapEntry), 0)
        , mWriteNeeded(false)
    {
        // HACK ALERT: it's weird to assign |mOps| after we passed a pointer to
        // it to |mMap|'s constructor. A more normal approach here would be to
        // have a static |sOps| member. Unfortunately, this mysteriously but
        // consistently makes Fennec start-up slower, so we take this
        // unorthodox approach instead. It's safe because PLDHashTable's
        // constructor doesn't dereference the pointer; it just makes a copy of
        // it.
        mOps = (PLDHashTableOps) {
            StringHash,
            HashMatchEntry,
            MoveEntry,
            PLDHashTable::ClearEntryStub,
            nullptr
        };

        MOZ_ASSERT(XRE_IsParentProcess(),
                   "FontNameCache should only be used in chrome process");
        mCache = mozilla::scache::StartupCache::GetSingleton();
    }

    ~FontNameCache()
    {
        if (!mWriteNeeded || !mCache) {
            return;
        }

        nsAutoCString buf;
        for (auto iter = mMap.Iter(); !iter.Done(); iter.Next()) {
            auto entry = static_cast<FNCMapEntry*>(iter.Get());
            if (!entry->mFileExists) {
                // skip writing entries for files that are no longer present
                continue;
            }
            buf.Append(entry->mFilename);
            buf.Append(';');
            buf.Append(entry->mFaces);
            buf.Append(';');
            buf.AppendInt(entry->mTimestamp);
            buf.Append(';');
            buf.AppendInt(entry->mFilesize);
            buf.Append(';');
        }
        mCache->PutBuffer(CACHE_KEY, buf.get(), buf.Length() + 1);
    }

    // This may be called more than once (if we re-load the font list).
    void Init()
    {
        if (!mCache) {
            return;
        }

        uint32_t size;
        UniquePtr<char[]> buf;
        if (NS_FAILED(mCache->GetBuffer(CACHE_KEY, &buf, &size))) {
            return;
        }

        LOG(("got: %s from the cache", nsDependentCString(buf.get(), size).get()));

        mMap.Clear();
        mWriteNeeded = false;

        const char* beginning = buf.get();
        const char* end = strchr(beginning, ';');
        while (end) {
            nsCString filename(beginning, end - beginning);
            beginning = end + 1;
            if (!(end = strchr(beginning, ';'))) {
                break;
            }
            nsCString faceList(beginning, end - beginning);
            beginning = end + 1;
            if (!(end = strchr(beginning, ';'))) {
                break;
            }
            uint32_t timestamp = strtoul(beginning, nullptr, 10);
            beginning = end + 1;
            if (!(end = strchr(beginning, ';'))) {
                break;
            }
            uint32_t filesize = strtoul(beginning, nullptr, 10);

            auto mapEntry =
                static_cast<FNCMapEntry*>(mMap.Add(filename.get(), fallible));
            if (mapEntry) {
                mapEntry->mFilename.Assign(filename);
                mapEntry->mTimestamp = timestamp;
                mapEntry->mFilesize = filesize;
                mapEntry->mFaces.Assign(faceList);
                // entries from the startupcache are marked "non-existing"
                // until we have confirmed that the file still exists
                mapEntry->mFileExists = false;
            }

            beginning = end + 1;
            end = strchr(beginning, ';');
        }
    }

    void
    GetInfoForFile(const nsCString& aFileName, nsCString& aFaceList,
                   uint32_t *aTimestamp, uint32_t *aFilesize)
    {
        auto entry = static_cast<FNCMapEntry*>(mMap.Search(aFileName.get()));
        if (entry) {
            *aTimestamp = entry->mTimestamp;
            *aFilesize = entry->mFilesize;
            aFaceList.Assign(entry->mFaces);
            // this entry does correspond to an existing file
            // (although it might not be up-to-date, in which case
            // it will get overwritten via CacheFileInfo)
            entry->mFileExists = true;
        }
    }

    void
    CacheFileInfo(const nsCString& aFileName, const nsCString& aFaceList,
                  uint32_t aTimestamp, uint32_t aFilesize)
    {
        auto entry =
            static_cast<FNCMapEntry*>(mMap.Add(aFileName.get(), fallible));
        if (entry) {
            entry->mFilename.Assign(aFileName);
            entry->mTimestamp = aTimestamp;
            entry->mFilesize = aFilesize;
            entry->mFaces.Assign(aFaceList);
            entry->mFileExists = true;
        }
        mWriteNeeded = true;
    }

private:
    mozilla::scache::StartupCache* mCache;
    PLDHashTable mMap;
    bool mWriteNeeded;

    PLDHashTableOps mOps;

    typedef struct : public PLDHashEntryHdr {
    public:
        nsCString mFilename;
        uint32_t  mTimestamp;
        uint32_t  mFilesize;
        nsCString mFaces;
        bool      mFileExists;
    } FNCMapEntry;

    static PLDHashNumber StringHash(const void *key)
    {
        return HashString(reinterpret_cast<const char*>(key));
    }

    static bool HashMatchEntry(const PLDHashEntryHdr *aHdr, const void *key)
    {
        const FNCMapEntry* entry =
            static_cast<const FNCMapEntry*>(aHdr);
        return entry->mFilename.Equals(reinterpret_cast<const char*>(key));
    }

    static void MoveEntry(PLDHashTable *table, const PLDHashEntryHdr *aFrom,
                          PLDHashEntryHdr *aTo)
    {
        FNCMapEntry* to = static_cast<FNCMapEntry*>(aTo);
        const FNCMapEntry* from = static_cast<const FNCMapEntry*>(aFrom);
        to->mFilename.Assign(from->mFilename);
        to->mTimestamp = from->mTimestamp;
        to->mFilesize = from->mFilesize;
        to->mFaces.Assign(from->mFaces);
        to->mFileExists = from->mFileExists;
    }
};

/***************************************************************
 *
 * gfxFT2FontList
 *
 */

// For Mobile, we use gfxFT2Fonts, and we build the font list by directly
// scanning the system's Fonts directory for OpenType and TrueType files.

#define JAR_LAST_MODIFED_TIME "jar-last-modified-time"

class WillShutdownObserver : public nsIObserver
{
public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIOBSERVER

    explicit WillShutdownObserver(gfxFT2FontList* aFontList)
        : mFontList(aFontList)
    { }

protected:
    virtual ~WillShutdownObserver()
    { }

    gfxFT2FontList *mFontList;
};

NS_IMPL_ISUPPORTS(WillShutdownObserver, nsIObserver)

NS_IMETHODIMP
WillShutdownObserver::Observe(nsISupports *aSubject,
                              const char *aTopic,
                              const char16_t *aData)
{
    if (!nsCRT::strcmp(aTopic, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID)) {
        mFontList->WillShutdown();
    } else {
        NS_NOTREACHED("unexpected notification topic");
    }
    return NS_OK;
}

gfxFT2FontList::gfxFT2FontList()
    : mJarModifiedTime(0)
{
    nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
    if (obs) {
        mObserver = new WillShutdownObserver(this);
        obs->AddObserver(mObserver, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID, false);
    }
}

gfxFT2FontList::~gfxFT2FontList()
{
    if (mObserver) {
        nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
        if (obs) {
            obs->RemoveObserver(mObserver, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID);
        }
        mObserver = nullptr;
    }
}

void
gfxFT2FontList::AppendFacesFromCachedFaceList(
    const nsCString& aFileName,
    const nsCString& aFaceList,
    StandardFile aStdFile,
    FT2FontFamily::Visibility aVisibility)
{
    const char *beginning = aFaceList.get();
    const char *end = strchr(beginning, ',');
    while (end) {
        NS_ConvertUTF8toUTF16 familyName(beginning, end - beginning);
        ToLowerCase(familyName);
        beginning = end + 1;
        if (!(end = strchr(beginning, ','))) {
            break;
        }
        NS_ConvertUTF8toUTF16 faceName(beginning, end - beginning);
        beginning = end + 1;
        if (!(end = strchr(beginning, ','))) {
            break;
        }
        uint32_t index = strtoul(beginning, nullptr, 10);
        beginning = end + 1;
        if (!(end = strchr(beginning, ','))) {
            break;
        }
        bool italic = (*beginning != '0');
        beginning = end + 1;
        if (!(end = strchr(beginning, ','))) {
            break;
        }
        uint32_t weight = strtoul(beginning, nullptr, 10);
        beginning = end + 1;
        if (!(end = strchr(beginning, ','))) {
            break;
        }
        int32_t stretch = strtol(beginning, nullptr, 10);

        FontListEntry fle(familyName, faceName, aFileName,
                          weight, stretch, italic, index,
                          aVisibility == FT2FontFamily::kHidden);
        AppendFaceFromFontListEntry(fle, aStdFile);

        beginning = end + 1;
        end = strchr(beginning, ',');
    }
}

static void
AppendToFaceList(nsCString& aFaceList,
                 nsAString& aFamilyName, FT2FontEntry* aFontEntry)
{
    aFaceList.Append(NS_ConvertUTF16toUTF8(aFamilyName));
    aFaceList.Append(',');
    aFaceList.Append(NS_ConvertUTF16toUTF8(aFontEntry->Name()));
    aFaceList.Append(',');
    aFaceList.AppendInt(aFontEntry->mFTFontIndex);
    aFaceList.Append(',');
    aFaceList.Append(aFontEntry->IsItalic() ? '1' : '0');
    aFaceList.Append(',');
    aFaceList.AppendInt(aFontEntry->Weight());
    aFaceList.Append(',');
    aFaceList.AppendInt(aFontEntry->Stretch());
    aFaceList.Append(',');
}

void
FT2FontEntry::CheckForBrokenFont(gfxFontFamily *aFamily)
{
    // note if the family is in the "bad underline" blacklist
    if (aFamily->IsBadUnderlineFamily()) {
        mIsBadUnderlineFont = true;
    }

    // bug 721719 - set the IgnoreGSUB flag on entries for Roboto
    // because of unwanted on-by-default "ae" ligature.
    // (See also AppendFaceFromFontListEntry.)
    if (aFamily->Name().EqualsLiteral("roboto")) {
        mIgnoreGSUB = true;
    }

    // bug 706888 - set the IgnoreGSUB flag on the broken version of
    // Droid Sans Arabic from certain phones, as identified by the
    // font checksum in the 'head' table
    else if (aFamily->Name().EqualsLiteral("droid sans arabic")) {
        AutoFTFace face(this);
        if (face) {
            const TT_Header *head = static_cast<const TT_Header*>
                (FT_Get_Sfnt_Table(face, ft_sfnt_head));
            if (head && head->CheckSum_Adjust == 0xe445242) {
                mIgnoreGSUB = true;
            }
        }
    }
}

void
gfxFT2FontList::AppendFacesFromFontFile(const nsCString& aFileName,
                                        FontNameCache *aCache,
                                        StandardFile aStdFile,
                                        FT2FontFamily::Visibility aVisibility)
{
    nsCString cachedFaceList;
    uint32_t filesize = 0, timestamp = 0;
    if (aCache) {
        aCache->GetInfoForFile(aFileName, cachedFaceList, &timestamp, &filesize);
    }

    struct stat s;
    int statRetval = stat(aFileName.get(), &s);
    if (!cachedFaceList.IsEmpty() && 0 == statRetval &&
        s.st_mtime == timestamp && s.st_size == filesize)
    {
        LOG(("using cached font info for %s", aFileName.get()));
        AppendFacesFromCachedFaceList(aFileName, cachedFaceList, aStdFile,
                                      aVisibility);
        return;
    }

    FT_Library ftLibrary = gfxAndroidPlatform::GetPlatform()->GetFTLibrary();
    FT_Face dummy;
    if (FT_Err_Ok == FT_New_Face(ftLibrary, aFileName.get(), -1, &dummy)) {
        LOG(("reading font info via FreeType for %s", aFileName.get()));
        nsCString newFaceList;
        timestamp = s.st_mtime;
        filesize = s.st_size;
        for (FT_Long i = 0; i < dummy->num_faces; i++) {
            FT_Face face;
            if (FT_Err_Ok != FT_New_Face(ftLibrary, aFileName.get(), i, &face)) {
                continue;
            }
            AddFaceToList(aFileName, i, aStdFile, aVisibility, face, newFaceList);
            FT_Done_Face(face);
        }
        FT_Done_Face(dummy);
        if (aCache && 0 == statRetval && !newFaceList.IsEmpty()) {
            aCache->CacheFileInfo(aFileName, newFaceList, timestamp, filesize);
        }
    }
}

void
gfxFT2FontList::FindFontsInOmnijar(FontNameCache *aCache)
{
    bool jarChanged = false;

    mozilla::scache::StartupCache* cache =
        mozilla::scache::StartupCache::GetSingleton();
    UniquePtr<char[]> cachedModifiedTimeBuf;
    uint32_t longSize;
    if (cache &&
        NS_SUCCEEDED(cache->GetBuffer(JAR_LAST_MODIFED_TIME,
                                      &cachedModifiedTimeBuf,
                                      &longSize)) &&
        longSize == sizeof(int64_t))
    {
        nsCOMPtr<nsIFile> jarFile = Omnijar::GetPath(Omnijar::Type::GRE);
        jarFile->GetLastModifiedTime(&mJarModifiedTime);
        if (mJarModifiedTime > *(int64_t*)cachedModifiedTimeBuf.get()) {
            jarChanged = true;
        }
    }

    static const char* sJarSearchPaths[] = {
        "res/fonts/*.ttf$",
    };
    RefPtr<nsZipArchive> reader = Omnijar::GetReader(Omnijar::Type::GRE);
    for (unsigned i = 0; i < ArrayLength(sJarSearchPaths); i++) {
        nsZipFind* find;
        if (NS_SUCCEEDED(reader->FindInit(sJarSearchPaths[i], &find))) {
            const char* path;
            uint16_t len;
            while (NS_SUCCEEDED(find->FindNext(&path, &len))) {
                nsCString entryName(path, len);
                AppendFacesFromOmnijarEntry(reader, entryName, aCache,
                                            jarChanged);
            }
            delete find;
        }
    }
}

// Given the freetype face corresponding to an entryName and face index,
// add the face to the available font list and to the faceList string
void
gfxFT2FontList::AddFaceToList(const nsCString& aEntryName, uint32_t aIndex,
                              StandardFile aStdFile,
                              FT2FontFamily::Visibility aVisibility,
                              FT_Face aFace,
                              nsCString& aFaceList)
{
    if (FT_Err_Ok != FT_Select_Charmap(aFace, FT_ENCODING_UNICODE)) {
        // ignore faces that don't support a Unicode charmap
        return;
    }

    // build the font entry name and create an FT2FontEntry,
    // but do -not- keep a reference to the FT_Face
    RefPtr<FT2FontEntry> fe =
        CreateNamedFontEntry(aFace, aEntryName.get(), aIndex);

    auto& fontFamilies =
        (aVisibility == FT2FontFamily::kHidden) ? mHiddenFontFamilies :
                                                  mFontFamilies;

    if (fe) {
        NS_ConvertUTF8toUTF16 name(aFace->family_name);
        BuildKeyNameFromFontName(name);
        RefPtr<gfxFontFamily> family = fontFamilies.GetWeak(name);
        if (!family) {
            family = new FT2FontFamily(name);
            fontFamilies.Put(name, family);
            if (mSkipSpaceLookupCheckFamilies.Contains(name)) {
                family->SetSkipSpaceFeatureCheck(true);
            }
            if (mBadUnderlineFamilyNames.Contains(name)) {
                family->SetBadUnderlineFamily();
            }
        }
        fe->mStandardFace = (aStdFile == kStandard);
        family->AddFontEntry(fe);

        fe->CheckForBrokenFont(family);

        AppendToFaceList(aFaceList, name, fe);
        if (LOG_ENABLED()) {
            LOG(("(fontinit) added (%s) to family (%s)"
                 " with style: %s weight: %d stretch: %d",
                 NS_ConvertUTF16toUTF8(fe->Name()).get(),
                 NS_ConvertUTF16toUTF8(family->Name()).get(),
                 fe->IsItalic() ? "italic" : "normal",
                 fe->Weight(), fe->Stretch()));
        }
    }
}

void
gfxFT2FontList::AppendFacesFromOmnijarEntry(nsZipArchive* aArchive,
                                            const nsCString& aEntryName,
                                            FontNameCache *aCache,
                                            bool aJarChanged)
{
    nsCString faceList;
    if (aCache && !aJarChanged) {
        uint32_t filesize, timestamp;
        aCache->GetInfoForFile(aEntryName, faceList, &timestamp, &filesize);
        if (faceList.Length() > 0) {
            AppendFacesFromCachedFaceList(aEntryName, faceList);
            return;
        }
    }

    nsZipItem *item = aArchive->GetItem(aEntryName.get());
    NS_ASSERTION(item, "failed to find zip entry");

    uint32_t bufSize = item->RealSize();
    // We use fallible allocation here; if there's not enough RAM, we'll simply
    // ignore the bundled fonts and fall back to the device's installed fonts.
    auto buf = MakeUniqueFallible<uint8_t[]>(bufSize);
    if (!buf) {
        return;
    }

    nsZipCursor cursor(item, aArchive, buf.get(), bufSize);
    uint8_t* data = cursor.Copy(&bufSize);
    NS_ASSERTION(data && bufSize == item->RealSize(),
                 "error reading bundled font");
    if (!data) {
        return;
    }

    FT_Library ftLibrary = gfxAndroidPlatform::GetPlatform()->GetFTLibrary();

    FT_Face dummy;
    if (FT_Err_Ok != FT_New_Memory_Face(ftLibrary, buf.get(), bufSize, 0, &dummy)) {
        return;
    }

    for (FT_Long i = 0; i < dummy->num_faces; i++) {
        FT_Face face;
        if (FT_Err_Ok != FT_New_Memory_Face(ftLibrary, buf.get(), bufSize, i, &face)) {
            continue;
        }
        AddFaceToList(aEntryName, i, kStandard, FT2FontFamily::kVisible,
                      face, faceList);
        FT_Done_Face(face);
    }

    FT_Done_Face(dummy);

    if (aCache && !faceList.IsEmpty()) {
        aCache->CacheFileInfo(aEntryName, faceList, 0, bufSize);
    }
}

// Called on each family after all fonts are added to the list;
// this will sort faces to give priority to "standard" font files
// if aUserArg is non-null (i.e. we're using it as a boolean flag)
static void
FinalizeFamilyMemberList(nsStringHashKey::KeyType aKey,
                         RefPtr<gfxFontFamily>& aFamily,
                         bool aSortFaces)
{
    gfxFontFamily *family = aFamily.get();

    family->SetHasStyles(true);

    if (aSortFaces) {
        family->SortAvailableFonts();
    }
    family->CheckForSimpleFamily();
}

void
gfxFT2FontList::FindFonts()
{
    gfxFontCache *fc = gfxFontCache::GetCache();
    if (fc)
        fc->AgeAllGenerations();
    ClearLangGroupPrefFonts();
    mCodepointsWithNoFonts.reset();

    mCodepointsWithNoFonts.SetRange(0,0x1f);     // C0 controls
    mCodepointsWithNoFonts.SetRange(0x7f,0x9f);  // C1 controls

    if (!XRE_IsParentProcess()) {
        // Content process: ask the Chrome process to give us the list
        InfallibleTArray<FontListEntry> fonts;
        mozilla::dom::ContentChild::GetSingleton()->SendReadFontList(&fonts);
        for (uint32_t i = 0, n = fonts.Length(); i < n; ++i) {
            // We don't need to identify "standard" font files here,
            // as the faces are already sorted.
            AppendFaceFromFontListEntry(fonts[i], kUnknown);
        }
        // Passing null for userdata tells Finalize that it does not need
        // to sort faces (because they were already sorted by chrome,
        // so we just maintain the existing order)
        for (auto iter = mFontFamilies.Iter(); !iter.Done(); iter.Next()) {
            nsStringHashKey::KeyType key = iter.Key();
            RefPtr<gfxFontFamily>& family = iter.Data();
            FinalizeFamilyMemberList(key, family, /* aSortFaces */ false);
        }
        for (auto iter = mHiddenFontFamilies.Iter(); !iter.Done(); iter.Next()) {
            nsStringHashKey::KeyType key = iter.Key();
            RefPtr<gfxFontFamily>& family = iter.Data();
            FinalizeFamilyMemberList(key, family, /* aSortFaces */ false );
        }

        LOG(("got font list from chrome process: %d faces in %d families "
             "and %d in hidden families",
            fonts.Length(), mFontFamilies.Count(),
            mHiddenFontFamilies.Count()));
        return;
    }

    // Chrome process: get the cached list (if any)
    if (!mFontNameCache) {
        mFontNameCache = MakeUnique<FontNameCache>();
    }
    mFontNameCache->Init();

    // ANDROID_ROOT is the root of the android system, typically /system;
    // font files are in /$ANDROID_ROOT/fonts/
    nsCString root;
    char *androidRoot = PR_GetEnv("ANDROID_ROOT");
    if (androidRoot) {
        root = androidRoot;
    } else {
        root = NS_LITERAL_CSTRING("/system");
    }
    root.AppendLiteral("/fonts");

    FindFontsInDir(root, mFontNameCache.get(), FT2FontFamily::kVisible);

    if (mFontFamilies.Count() == 0) {
        // if we can't find/read the font directory, we are doomed!
        NS_RUNTIMEABORT("Could not read the system fonts directory");
    }

    // Look for fonts stored in omnijar, unless we're on a low-memory
    // device where we don't want to spend the RAM to decompress them.
    // (Prefs may disable this, or force-enable it even with low memory.)
    bool lowmem;
    nsCOMPtr<nsIMemory> mem = nsMemory::GetGlobalMemoryService();
    if ((NS_SUCCEEDED(mem->IsLowMemoryPlatform(&lowmem)) && !lowmem &&
         Preferences::GetBool("gfx.bundled_fonts.enabled")) ||
        Preferences::GetBool("gfx.bundled_fonts.force-enabled")) {
        FindFontsInOmnijar(mFontNameCache.get());
    }

    // Look for downloaded fonts in a profile-agnostic "fonts" directory.
    nsCOMPtr<nsIProperties> dirSvc =
      do_GetService(NS_DIRECTORY_SERVICE_CONTRACTID);
    if (dirSvc) {
        nsCOMPtr<nsIFile> appDir;
        nsresult rv = dirSvc->Get(NS_XPCOM_CURRENT_PROCESS_DIR,
                         NS_GET_IID(nsIFile), getter_AddRefs(appDir));
        if (NS_SUCCEEDED(rv)) {
            appDir->AppendNative(NS_LITERAL_CSTRING("fonts"));
            nsCString localPath;
            if (NS_SUCCEEDED(appDir->GetNativePath(localPath))) {
                FindFontsInDir(localPath, mFontNameCache.get(),
                               FT2FontFamily::kVisible);
            }
        }
    }

    // look for locally-added fonts in a "fonts" subdir of the profile
    nsCOMPtr<nsIFile> localDir;
    nsresult rv = NS_GetSpecialDirectory(NS_APP_USER_PROFILE_LOCAL_50_DIR,
                                         getter_AddRefs(localDir));
    if (NS_SUCCEEDED(rv) &&
        NS_SUCCEEDED(localDir->Append(NS_LITERAL_STRING("fonts")))) {
        nsCString localPath;
        rv = localDir->GetNativePath(localPath);
        if (NS_SUCCEEDED(rv)) {
            FindFontsInDir(localPath, mFontNameCache.get(),
                           FT2FontFamily::kVisible);
        }
    }

    // Finalize the families by sorting faces into standard order
    // and marking "simple" families.
    // Passing non-null userData here says that we want faces to be sorted.
    for (auto iter = mFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        nsStringHashKey::KeyType key = iter.Key();
        RefPtr<gfxFontFamily>& family = iter.Data();
        FinalizeFamilyMemberList(key, family, /* aSortFaces */ true);
    }
    for (auto iter = mHiddenFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        nsStringHashKey::KeyType key = iter.Key();
        RefPtr<gfxFontFamily>& family = iter.Data();
        FinalizeFamilyMemberList(key, family, /* aSortFaces */ true);
    }
}

void
gfxFT2FontList::FindFontsInDir(const nsCString& aDir,
                               FontNameCache *aFNC,
                               FT2FontFamily::Visibility aVisibility)
{
    static const char* sStandardFonts[] = {
        "DroidSans.ttf",
        "DroidSans-Bold.ttf",
        "DroidSerif-Regular.ttf",
        "DroidSerif-Bold.ttf",
        "DroidSerif-Italic.ttf",
        "DroidSerif-BoldItalic.ttf",
        "DroidSansMono.ttf",
        "DroidSansArabic.ttf",
        "DroidSansHebrew.ttf",
        "DroidSansThai.ttf",
        "MTLmr3m.ttf",
        "MTLc3m.ttf",
        "NanumGothic.ttf",
        "DroidSansJapanese.ttf",
        "DroidSansFallback.ttf"
    };

    DIR *d = opendir(aDir.get());
    if (!d) {
        return;
    }

    struct dirent *ent = nullptr;
    while ((ent = readdir(d)) != nullptr) {
        const char *ext = strrchr(ent->d_name, '.');
        if (!ext) {
            continue;
        }
        if (strcasecmp(ext, ".ttf") == 0 ||
            strcasecmp(ext, ".otf") == 0 ||
            strcasecmp(ext, ".woff") == 0 ||
            strcasecmp(ext, ".ttc") == 0) {
            bool isStdFont = false;
            for (unsigned int i = 0;
                 i < ArrayLength(sStandardFonts) && !isStdFont; i++) {
                isStdFont = strcmp(sStandardFonts[i], ent->d_name) == 0;
            }

            nsCString s(aDir);
            s.Append('/');
            s.Append(ent->d_name);

            // Add the face(s) from this file to our font list;
            // note that if we have cached info for this file in fnc,
            // and the file is unchanged, we won't actually need to read it.
            // If the file is new/changed, this will update the FontNameCache.
            AppendFacesFromFontFile(s, aFNC, isStdFont ? kStandard : kUnknown,
                                    aVisibility);
        }
    }

    closedir(d);
}

void
gfxFT2FontList::AppendFaceFromFontListEntry(const FontListEntry& aFLE,
                                            StandardFile aStdFile)
{
    FT2FontEntry* fe = FT2FontEntry::CreateFontEntry(aFLE);
    if (fe) {
        auto& fontFamilies =
            aFLE.isHidden() ? mHiddenFontFamilies : mFontFamilies;
        fe->mStandardFace = (aStdFile == kStandard);
        nsAutoString name(aFLE.familyName());
        RefPtr<gfxFontFamily> family = fontFamilies.GetWeak(name);
        if (!family) {
            family = new FT2FontFamily(name);
            fontFamilies.Put(name, family);
            if (mSkipSpaceLookupCheckFamilies.Contains(name)) {
                family->SetSkipSpaceFeatureCheck(true);
            }
            if (mBadUnderlineFamilyNames.Contains(name)) {
                family->SetBadUnderlineFamily();
            }
        }
        family->AddFontEntry(fe);

        fe->CheckForBrokenFont(family);
    }
}

void
gfxFT2FontList::GetSystemFontList(InfallibleTArray<FontListEntry>* retValue)
{
    for (auto iter = mFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        auto family = static_cast<FT2FontFamily*>(iter.Data().get());
        family->AddFacesToFontList(retValue, FT2FontFamily::kVisible);
    }
    for (auto iter = mHiddenFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        auto family = static_cast<FT2FontFamily*>(iter.Data().get());
        family->AddFacesToFontList(retValue, FT2FontFamily::kHidden);
    }
}

static void
LoadSkipSpaceLookupCheck(nsTHashtable<nsStringHashKey>& aSkipSpaceLookupCheck)
{
    AutoTArray<nsString, 5> skiplist;
    gfxFontUtils::GetPrefsFontList(
        "font.whitelist.skip_default_features_space_check",
        skiplist);
    uint32_t numFonts = skiplist.Length();
    for (uint32_t i = 0; i < numFonts; i++) {
        ToLowerCase(skiplist[i]);
        aSkipSpaceLookupCheck.PutEntry(skiplist[i]);
    }
}

void
PreloadAsUserFontFaces(nsStringHashKey::KeyType aKey,
                       RefPtr<gfxFontFamily>& aFamily)
{
    gfxFontFamily *family = aFamily.get();

    auto& faces = family->GetFontList();
    size_t count = faces.Length();
    for (size_t i = 0; i < count; ++i) {
        FT2FontEntry* fe = static_cast<FT2FontEntry*>(faces[i].get());
        if (fe->mFTFontIndex != 0) {
            NS_NOTREACHED("don't try to preload a multi-face font");
            continue;
        }

        // XXX Should we move the i/o here off the main thread?

        // Map the font data in fe->mFilename, so we can calculate its CRC32.
        int fd = open(fe->mFilename.get(), O_RDONLY);
        if (fd < 0) {
            continue;
        }
        struct stat buf;
        if (fstat(fd, &buf) != 0 || buf.st_size < 12) {
            close(fd);
            continue;
        }
        char* data = static_cast<char*>(
            mmap(0, buf.st_size, PROT_READ, MAP_PRIVATE, fd, 0));
        close(fd);
        if (data == MAP_FAILED) {
            continue;
        }

        // Calculate CRC32
        uint32_t crc = crc32(0, nullptr, 0);
        crc = crc32(crc, (Bytef*)data, buf.st_size);
        munmap(data, buf.st_size);

#if 0
        ALOG("\n**** Preloading family [%s] face [%s] CRC32 [0x%08x]",
             NS_ConvertUTF16toUTF8(family->Name()).get(),
             fe->mFilename.get(),
             crc);
#endif

        fe->mUserFontData = MakeUnique<gfxUserFontData>();
        fe->mUserFontData->mRealName = fe->Name();
        fe->mUserFontData->mCRC32 = crc;
        fe->mUserFontData->mLength = buf.st_size;

        // Stash it persistently in the user-font cache.
        gfxUserFontSet::UserFontCache::CacheFont(
            fe, gfxUserFontSet::UserFontCache::kPersistent);
    }
}

nsresult
gfxFT2FontList::InitFontListForPlatform()
{
    // reset hidden font list
    mHiddenFontFamilies.Clear();

    LoadSkipSpaceLookupCheck(mSkipSpaceLookupCheckFamilies);

    FindFonts();

    for (auto iter = mHiddenFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        nsStringHashKey::KeyType key = iter.Key();
        RefPtr<gfxFontFamily>& family = iter.Data();
        PreloadAsUserFontFaces(key, family);
    }
    return NS_OK;
}

// called for each family name, based on the assumption that the
// first part of the full name is the family name

gfxFontEntry*
gfxFT2FontList::LookupLocalFont(const nsAString& aFontName,
                                uint16_t aWeight,
                                int16_t aStretch,
                                uint8_t aStyle)
{
    // walk over list of names
    FT2FontEntry* fontEntry = nullptr;
    nsString fullName(aFontName);

    // Note that we only check mFontFamilies here, not mHiddenFontFamilies;
    // hence @font-face { src:local(...) } will not find hidden fonts.
    for (auto iter = mFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        // Check family name, based on the assumption that the
        // first part of the full name is the family name
        RefPtr<gfxFontFamily>& fontFamily = iter.Data();

        // does the family name match up to the length of the family name?
        const nsString& family = fontFamily->Name();
        nsString fullNameFamily;

        fullName.Left(fullNameFamily, family.Length());

        // if so, iterate over faces in this family to see if there is a match
        if (family.Equals(fullNameFamily, nsCaseInsensitiveStringComparator())) {
            nsTArray<RefPtr<gfxFontEntry> >& fontList = fontFamily->GetFontList();
            int index, len = fontList.Length();
            for (index = 0; index < len; index++) {
                gfxFontEntry* fe = fontList[index];
                if (!fe) {
                    continue;
                }
                if (fe->Name().Equals(fullName,
                                      nsCaseInsensitiveStringComparator())) {
                    fontEntry = static_cast<FT2FontEntry*>(fe);
                    goto searchDone;
                }
            }
        }
    }

searchDone:
    if (!fontEntry) {
        return nullptr;
    }

    // Clone the font entry so that we can then set its style descriptors
    // from the userfont entry rather than the actual font.

    // Ensure existence of mFTFace in the original entry
    fontEntry->CairoFontFace();
    if (!fontEntry->mFTFace) {
        return nullptr;
    }

    FT2FontEntry* fe =
        FT2FontEntry::CreateFontEntry(fontEntry->mFTFace,
                                      fontEntry->mFilename.get(),
                                      fontEntry->mFTFontIndex,
                                      fontEntry->Name(), nullptr);
    if (fe) {
        fe->mStyle = aStyle;
        fe->mWeight = aWeight;
        fe->mStretch = aStretch;
        fe->mIsLocalUserFont = true;
    }

    return fe;
}

gfxFontFamily*
gfxFT2FontList::GetDefaultFontForPlatform(const gfxFontStyle* aStyle)
{
    gfxFontFamily *ff = nullptr;
#if defined(MOZ_WIDGET_ANDROID)
    ff = FindFamily(NS_LITERAL_STRING("Roboto"));
    if (!ff) {
        ff = FindFamily(NS_LITERAL_STRING("Droid Sans"));
    }
#endif
    /* TODO: what about Qt or other platforms that may use this? */
    return ff;
}

gfxFontEntry*
gfxFT2FontList::MakePlatformFont(const nsAString& aFontName,
                                 uint16_t aWeight,
                                 int16_t aStretch,
                                 uint8_t aStyle,
                                 const uint8_t* aFontData,
                                 uint32_t aLength)
{
    // The FT2 font needs the font data to persist, so we do NOT free it here
    // but instead pass ownership to the font entry.
    // Deallocation will happen later, when the font face is destroyed.
    return FT2FontEntry::CreateFontEntry(aFontName, aWeight, aStretch,
                                         aStyle, aFontData, aLength);
}

void
gfxFT2FontList::GetFontFamilyList(nsTArray<RefPtr<gfxFontFamily> >& aFamilyArray)
{
    for (auto iter = mFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        RefPtr<gfxFontFamily>& family = iter.Data();
        aFamilyArray.AppendElement(family);
    }
    for (auto iter = mHiddenFontFamilies.Iter(); !iter.Done(); iter.Next()) {
        RefPtr<gfxFontFamily>& family = iter.Data();
        aFamilyArray.AppendElement(family);
    }
}

void
gfxFT2FontList::WillShutdown()
{
    mozilla::scache::StartupCache* cache =
        mozilla::scache::StartupCache::GetSingleton();
    if (cache && mJarModifiedTime > 0) {
        cache->PutBuffer(JAR_LAST_MODIFED_TIME,
                         (char*)&mJarModifiedTime, sizeof(mJarModifiedTime));
    }
    mFontNameCache = nullptr;
}
