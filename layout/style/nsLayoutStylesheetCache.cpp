/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsLayoutStylesheetCache.h"

#include "nsAppDirectoryServiceDefs.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/Preferences.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/css/Loader.h"
#include "mozilla/dom/SRIMetadata.h"
#include "MainThreadUtils.h"
#include "nsColor.h"
#include "nsIConsoleService.h"
#include "nsIFile.h"
#include "nsNetUtil.h"
#include "nsIObserverService.h"
#include "nsServiceManagerUtils.h"
#include "nsIXULRuntime.h"
#include "nsPresContext.h"
#include "nsPrintfCString.h"
#include "nsXULAppAPI.h"

// Includes for the crash report annotation in ErrorLoadingSheet.
#ifdef MOZ_CRASHREPORTER
#include "mozilla/Omnijar.h"
#include "nsDirectoryService.h"
#include "nsDirectoryServiceDefs.h"
#include "nsExceptionHandler.h"
#include "nsIChromeRegistry.h"
#include "nsISimpleEnumerator.h"
#include "nsISubstitutingProtocolHandler.h"
#include "zlib.h"
#include "nsZipArchive.h"
#endif

using namespace mozilla;
using namespace mozilla::css;

static bool sNumberControlEnabled;

#define NUMBER_CONTROL_PREF "dom.forms.number"

NS_IMPL_ISUPPORTS(
  nsLayoutStylesheetCache, nsIObserver, nsIMemoryReporter)

nsresult
nsLayoutStylesheetCache::Observe(nsISupports* aSubject,
                            const char* aTopic,
                            const char16_t* aData)
{
  if (!strcmp(aTopic, "profile-before-change")) {
    mUserContentSheet = nullptr;
    mUserChromeSheet  = nullptr;
  }
  else if (!strcmp(aTopic, "profile-do-change")) {
    InitFromProfile();
  }
  else if (strcmp(aTopic, "chrome-flush-skin-caches") == 0 ||
           strcmp(aTopic, "chrome-flush-caches") == 0) {
    mScrollbarsSheet = nullptr;
    mFormsSheet = nullptr;
    mNumberControlSheet = nullptr;
  }
  else {
    NS_NOTREACHED("Unexpected observer topic.");
  }
  return NS_OK;
}

StyleSheet*
nsLayoutStylesheetCache::ScrollbarsSheet()
{
  if (!mScrollbarsSheet) {
    // Scrollbars don't need access to unsafe rules
    LoadSheetURL("chrome://global/skin/scrollbars.css",
                 &mScrollbarsSheet, eSafeAgentSheetFeatures, eCrash);
  }

  return mScrollbarsSheet;
}

StyleSheet*
nsLayoutStylesheetCache::FormsSheet()
{
  if (!mFormsSheet) {
    // forms.css needs access to unsafe rules
    LoadSheetURL("resource://gre-resources/forms.css",
                 &mFormsSheet, eAgentSheetFeatures, eCrash);
  }

  return mFormsSheet;
}

StyleSheet*
nsLayoutStylesheetCache::NumberControlSheet()
{
  if (!sNumberControlEnabled) {
    return nullptr;
  }

  if (!mNumberControlSheet) {
    LoadSheetURL("resource://gre-resources/number-control.css",
                 &mNumberControlSheet, eAgentSheetFeatures, eCrash);
  }

  return mNumberControlSheet;
}

StyleSheet*
nsLayoutStylesheetCache::UserContentSheet()
{
  return mUserContentSheet;
}

StyleSheet*
nsLayoutStylesheetCache::UserChromeSheet()
{
  return mUserChromeSheet;
}

StyleSheet*
nsLayoutStylesheetCache::UASheet()
{
  if (!mUASheet) {
    LoadSheetURL("resource://gre-resources/ua.css",
                 &mUASheet, eAgentSheetFeatures, eCrash);
  }

  return mUASheet;
}

StyleSheet*
nsLayoutStylesheetCache::HTMLSheet()
{
  return mHTMLSheet;
}

StyleSheet*
nsLayoutStylesheetCache::MinimalXULSheet()
{
  return mMinimalXULSheet;
}

StyleSheet*
nsLayoutStylesheetCache::XULSheet()
{
  if (!mXULSheet) {
    LoadSheetURL("chrome://global/content/xul.css",
                 &mXULSheet, eAgentSheetFeatures, eCrash);
  }

  return mXULSheet;
}

StyleSheet*
nsLayoutStylesheetCache::QuirkSheet()
{
  return mQuirkSheet;
}

StyleSheet*
nsLayoutStylesheetCache::SVGSheet()
{
  return mSVGSheet;
}

StyleSheet*
nsLayoutStylesheetCache::MathMLSheet()
{
  if (!mMathMLSheet) {
    LoadSheetURL("resource://gre-resources/mathml.css",
                 &mMathMLSheet, eAgentSheetFeatures, eCrash);
  }

  return mMathMLSheet;
}

StyleSheet*
nsLayoutStylesheetCache::CounterStylesSheet()
{
  return mCounterStylesSheet;
}

StyleSheet*
nsLayoutStylesheetCache::NoScriptSheet()
{
  if (!mNoScriptSheet) {
    LoadSheetURL("resource://gre-resources/noscript.css",
                 &mNoScriptSheet, eAgentSheetFeatures, eCrash);
  }

  return mNoScriptSheet;
}

StyleSheet*
nsLayoutStylesheetCache::NoFramesSheet()
{
  if (!mNoFramesSheet) {
    LoadSheetURL("resource://gre-resources/noframes.css",
                 &mNoFramesSheet, eAgentSheetFeatures, eCrash);
  }

  return mNoFramesSheet;
}

StyleSheet*
nsLayoutStylesheetCache::ChromePreferenceSheet(nsPresContext* aPresContext)
{
  if (!mChromePreferenceSheet) {
    BuildPreferenceSheet(&mChromePreferenceSheet, aPresContext);
  }

  return mChromePreferenceSheet;
}

StyleSheet*
nsLayoutStylesheetCache::ContentPreferenceSheet(nsPresContext* aPresContext)
{
  if (!mContentPreferenceSheet) {
    BuildPreferenceSheet(&mContentPreferenceSheet, aPresContext);
  }

  return mContentPreferenceSheet;
}

StyleSheet*
nsLayoutStylesheetCache::ContentEditableSheet()
{
  if (!mContentEditableSheet) {
    LoadSheetURL("resource://gre/res/contenteditable.css",
                 &mContentEditableSheet, eAgentSheetFeatures, eCrash);
  }

  return mContentEditableSheet;
}

StyleSheet*
nsLayoutStylesheetCache::DesignModeSheet()
{
  if (!mDesignModeSheet) {
    LoadSheetURL("resource://gre/res/designmode.css",
                 &mDesignModeSheet, eAgentSheetFeatures, eCrash);
  }

  return mDesignModeSheet;
}

void
nsLayoutStylesheetCache::Shutdown()
{
  gCSSLoader_Gecko = nullptr;
  gCSSLoader_Servo = nullptr;
  NS_WARNING_ASSERTION(!gStyleCache_Gecko || !gUserContentSheetURL_Gecko,
                       "Got the URL but never used by Gecko?");
  NS_WARNING_ASSERTION(!gStyleCache_Servo || !gUserContentSheetURL_Servo,
                       "Got the URL but never used by Servo?");
  gStyleCache_Gecko = nullptr;
  gStyleCache_Servo = nullptr;
  gUserContentSheetURL_Gecko = nullptr;
  gUserContentSheetURL_Servo = nullptr;
}

void
nsLayoutStylesheetCache::SetUserContentCSSURL(nsIURI* aURI)
{
  MOZ_ASSERT(XRE_IsContentProcess(), "Only used in content processes.");
  gUserContentSheetURL_Gecko = aURI;
  gUserContentSheetURL_Servo = aURI;
}

MOZ_DEFINE_MALLOC_SIZE_OF(LayoutStylesheetCacheMallocSizeOf)

NS_IMETHODIMP
nsLayoutStylesheetCache::CollectReports(nsIHandleReportCallback* aHandleReport,
                                        nsISupports* aData, bool aAnonymize)
{
  MOZ_COLLECT_REPORT(
    "explicit/layout/style-sheet-cache", KIND_HEAP, UNITS_BYTES,
    SizeOfIncludingThis(LayoutStylesheetCacheMallocSizeOf),
    "Memory used for some built-in style sheets.");

  return NS_OK;
}


size_t
nsLayoutStylesheetCache::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  size_t n = aMallocSizeOf(this);

  #define MEASURE(s) n += s ? s->SizeOfIncludingThis(aMallocSizeOf) : 0;

  MEASURE(mChromePreferenceSheet);
  MEASURE(mContentEditableSheet);
  MEASURE(mContentPreferenceSheet);
  MEASURE(mCounterStylesSheet);
  MEASURE(mDesignModeSheet);
  MEASURE(mFormsSheet);
  MEASURE(mHTMLSheet);
  MEASURE(mMathMLSheet);
  MEASURE(mMinimalXULSheet);
  MEASURE(mNoFramesSheet);
  MEASURE(mNoScriptSheet);
  MEASURE(mNumberControlSheet);
  MEASURE(mQuirkSheet);
  MEASURE(mSVGSheet);
  MEASURE(mScrollbarsSheet);
  MEASURE(mUASheet);
  MEASURE(mUserChromeSheet);
  MEASURE(mUserContentSheet);
  MEASURE(mXULSheet);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - gCSSLoader_Gecko
  // - gCSSLoader_Servo

  return n;
}

nsLayoutStylesheetCache::nsLayoutStylesheetCache(StyleBackendType aType)
  : mBackendType(aType)
{
  nsCOMPtr<nsIObserverService> obsSvc =
    mozilla::services::GetObserverService();
  NS_ASSERTION(obsSvc, "No global observer service?");

  if (obsSvc) {
    obsSvc->AddObserver(this, "profile-before-change", false);
    obsSvc->AddObserver(this, "profile-do-change", false);
    obsSvc->AddObserver(this, "chrome-flush-skin-caches", false);
    obsSvc->AddObserver(this, "chrome-flush-caches", false);
  }

  InitFromProfile();

  // And make sure that we load our UA sheets.  No need to do this
  // per-profile, since they're profile-invariant.
  LoadSheetURL("resource://gre-resources/counterstyles.css",
               &mCounterStylesSheet, eAgentSheetFeatures, eCrash);
  LoadSheetURL("resource://gre-resources/html.css",
               &mHTMLSheet, eAgentSheetFeatures, eCrash);
  LoadSheetURL("chrome://global/content/minimal-xul.css",
               &mMinimalXULSheet, eAgentSheetFeatures, eCrash);
  LoadSheetURL("resource://gre-resources/quirk.css",
               &mQuirkSheet, eAgentSheetFeatures, eCrash);
  LoadSheetURL("resource://gre/res/svg.css",
               &mSVGSheet, eAgentSheetFeatures, eCrash);
  if (XRE_IsParentProcess()) {
    // We know we need xul.css for the UI, so load that now too:
    XULSheet();
  }

  auto& userContentSheetURL = aType == StyleBackendType::Gecko ?
                              gUserContentSheetURL_Gecko :
                              gUserContentSheetURL_Servo;
  if (userContentSheetURL) {
    MOZ_ASSERT(XRE_IsContentProcess(), "Only used in content processes.");
    LoadSheet(userContentSheetURL, &mUserContentSheet, eUserSheetFeatures, eLogToConsole);
    userContentSheetURL = nullptr;
  }

  // The remaining sheets are created on-demand do to their use being rarer
  // (which helps save memory for Firefox OS apps) or because they need to
  // be re-loadable in DependentPrefChanged.
}

nsLayoutStylesheetCache::~nsLayoutStylesheetCache()
{
  mozilla::UnregisterWeakMemoryReporter(this);
}

void
nsLayoutStylesheetCache::InitMemoryReporter()
{
  mozilla::RegisterWeakMemoryReporter(this);
}

/* static */ nsLayoutStylesheetCache*
nsLayoutStylesheetCache::For(StyleBackendType aType)
{
  MOZ_ASSERT(NS_IsMainThread());

  bool mustInit = !gStyleCache_Gecko && !gStyleCache_Servo;
  auto& cache = aType == StyleBackendType::Gecko ? gStyleCache_Gecko :
                                                   gStyleCache_Servo;

  if (!cache) {
    cache = new nsLayoutStylesheetCache(aType);
    cache->InitMemoryReporter();
  }

  if (mustInit) {
    // Initialization that only needs to be done once for both
    // nsLayoutStylesheetCaches.

    Preferences::AddBoolVarCache(&sNumberControlEnabled, NUMBER_CONTROL_PREF,
                                 true);

    // For each pref that controls a CSS feature that a UA style sheet depends
    // on (such as a pref that enables a property that a UA style sheet uses),
    // register DependentPrefChanged as a callback to ensure that the relevant
    // style sheets will be re-parsed.
    // Preferences::RegisterCallback(&DependentPrefChanged,
    //                               "layout.css.example-pref.enabled");
    Preferences::RegisterCallback(&DependentPrefChanged,
                                  "layout.css.grid.enabled");
  }

  return cache;
}

void
nsLayoutStylesheetCache::InitFromProfile()
{
  nsCOMPtr<nsIXULRuntime> appInfo = do_GetService("@mozilla.org/xre/app-info;1");
  if (appInfo) {
    bool inSafeMode = false;
    appInfo->GetInSafeMode(&inSafeMode);
    if (inSafeMode)
      return;
  }
  nsCOMPtr<nsIFile> contentFile;
  nsCOMPtr<nsIFile> chromeFile;

  NS_GetSpecialDirectory(NS_APP_USER_CHROME_DIR,
                         getter_AddRefs(contentFile));
  if (!contentFile) {
    // if we don't have a profile yet, that's OK!
    return;
  }

  contentFile->Clone(getter_AddRefs(chromeFile));
  if (!chromeFile) return;

  contentFile->Append(NS_LITERAL_STRING("userContent.css"));
  chromeFile->Append(NS_LITERAL_STRING("userChrome.css"));

  LoadSheetFile(contentFile, &mUserContentSheet, eUserSheetFeatures, eLogToConsole);
  LoadSheetFile(chromeFile, &mUserChromeSheet, eUserSheetFeatures, eLogToConsole);
}

void
nsLayoutStylesheetCache::LoadSheetURL(const char* aURL,
                                      RefPtr<StyleSheet>* aSheet,
                                      SheetParsingMode aParsingMode,
                                      FailureAction aFailureAction)
{
  nsCOMPtr<nsIURI> uri;
  NS_NewURI(getter_AddRefs(uri), aURL);
  LoadSheet(uri, aSheet, aParsingMode, aFailureAction);
  if (!aSheet) {
    NS_ERROR(nsPrintfCString("Could not load %s", aURL).get());
  }
}

void
nsLayoutStylesheetCache::LoadSheetFile(nsIFile* aFile,
                                       RefPtr<StyleSheet>* aSheet,
                                       SheetParsingMode aParsingMode,
                                       FailureAction aFailureAction)
{
  bool exists = false;
  aFile->Exists(&exists);

  if (!exists) return;

  nsCOMPtr<nsIURI> uri;
  NS_NewFileURI(getter_AddRefs(uri), aFile);

  LoadSheet(uri, aSheet, aParsingMode, aFailureAction);
}

#ifdef MOZ_CRASHREPORTER
static inline nsresult
ComputeCRC32(nsIFile* aFile, uint32_t* aResult)
{
  PRFileDesc* fd;
  nsresult rv = aFile->OpenNSPRFileDesc(PR_RDONLY, 0, &fd);
  NS_ENSURE_SUCCESS(rv, rv);

  uint32_t crc = crc32(0, nullptr, 0);

  unsigned char buf[512];
  int32_t n;
  while ((n = PR_Read(fd, buf, sizeof(buf))) > 0) {
    crc = crc32(crc, buf, n);
  }
  PR_Close(fd);

  if (n < 0) {
    return NS_ERROR_FAILURE;
  }

  *aResult = crc;
  return NS_OK;
}

static void
ListInterestingFiles(nsString& aAnnotation, nsIFile* aFile,
                     const nsTArray<nsString>& aInterestingFilenames)
{
  nsString filename;
  aFile->GetLeafName(filename);
  for (const nsString& interestingFilename : aInterestingFilenames) {
    if (interestingFilename == filename) {
      nsString path;
      aFile->GetPath(path);
      aAnnotation.AppendLiteral("  ");
      aAnnotation.Append(path);
      aAnnotation.AppendLiteral(" (");
      int64_t size;
      if (NS_SUCCEEDED(aFile->GetFileSize(&size))) {
        aAnnotation.AppendPrintf("%" PRId64, size);
      } else {
        aAnnotation.AppendLiteral("???");
      }
      aAnnotation.AppendLiteral(" bytes, crc32 = ");
      uint32_t crc;
      nsresult rv = ComputeCRC32(aFile, &crc);
      if (NS_SUCCEEDED(rv)) {
        aAnnotation.AppendPrintf("0x%08x)\n", crc);
      } else {
        aAnnotation.AppendPrintf("error 0x%08x)\n", uint32_t(rv));
      }
      return;
    }
  }

  bool isDir = false;
  aFile->IsDirectory(&isDir);

  if (!isDir) {
    return;
  }

  nsCOMPtr<nsISimpleEnumerator> entries;
  if (NS_FAILED(aFile->GetDirectoryEntries(getter_AddRefs(entries)))) {
    aAnnotation.AppendLiteral("  (failed to enumerated directory)\n");
    return;
  }

  for (;;) {
    bool hasMore = false;
    if (NS_FAILED(entries->HasMoreElements(&hasMore))) {
      aAnnotation.AppendLiteral("  (failed during directory enumeration)\n");
      return;
    }
    if (!hasMore) {
      break;
    }

    nsCOMPtr<nsISupports> entry;
    if (NS_FAILED(entries->GetNext(getter_AddRefs(entry)))) {
      aAnnotation.AppendLiteral("  (failed during directory enumeration)\n");
      return;
    }

    nsCOMPtr<nsIFile> file = do_QueryInterface(entry);
    if (file) {
      ListInterestingFiles(aAnnotation, file, aInterestingFilenames);
    }
  }
}

// Generate a crash report annotation to help debug issues with style
// sheets failing to load (bug 1194856).
static void
AnnotateCrashReport(nsIURI* aURI)
{
  nsAutoCString spec;
  nsAutoCString scheme;
  nsDependentCSubstring filename;
  if (aURI) {
    spec = aURI->GetSpecOrDefault();
    aURI->GetScheme(scheme);
    int32_t i = spec.RFindChar('/');
    if (i != -1) {
      filename.Rebind(spec, i + 1);
    }
  }

  nsString annotation;

  // The URL of the sheet that failed to load.
  annotation.AppendLiteral("Error loading sheet: ");
  annotation.Append(NS_ConvertUTF8toUTF16(spec).get());
  annotation.Append('\n');

  annotation.AppendLiteral("NS_ERROR_FILE_CORRUPTION reason: ");
  if (nsZipArchive::sFileCorruptedReason) {
    annotation.Append(NS_ConvertUTF8toUTF16(nsZipArchive::sFileCorruptedReason).get());
    annotation.Append('\n');
  } else {
    annotation.AppendLiteral("(none)\n");
  }

  // The jar: or file: URL that the sheet's resource: or chrome: URL
  // resolves to.
  if (scheme.EqualsLiteral("resource")) {
    annotation.AppendLiteral("Real location: ");
    nsCOMPtr<nsISubstitutingProtocolHandler> handler;
    nsCOMPtr<nsIIOService> io(do_GetIOService());
    if (io) {
      nsCOMPtr<nsIProtocolHandler> ph;
      io->GetProtocolHandler(scheme.get(), getter_AddRefs(ph));
      if (ph) {
        handler = do_QueryInterface(ph);
      }
    }
    if (!handler) {
      annotation.AppendLiteral("(ResolveURI failed)\n");
    } else {
      nsAutoCString resolvedSpec;
      nsresult rv = handler->ResolveURI(aURI, resolvedSpec);
      if (NS_FAILED(rv)) {
        annotation.AppendPrintf("(ResolveURI failed with 0x%08" PRIx32 ")\n",
                                static_cast<uint32_t>(rv));
      }
      annotation.Append(NS_ConvertUTF8toUTF16(resolvedSpec));
      annotation.Append('\n');
    }
  } else if (scheme.EqualsLiteral("chrome")) {
    annotation.AppendLiteral("Real location: ");
    nsCOMPtr<nsIChromeRegistry> reg =
      mozilla::services::GetChromeRegistryService();
    if (!reg) {
      annotation.AppendLiteral("(no chrome registry)\n");
    } else {
      nsCOMPtr<nsIURI> resolvedURI;
      reg->ConvertChromeURL(aURI, getter_AddRefs(resolvedURI));
      if (!resolvedURI) {
        annotation.AppendLiteral("(ConvertChromeURL failed)\n");
      } else {
        annotation.Append(
          NS_ConvertUTF8toUTF16(resolvedURI->GetSpecOrDefault()));
        annotation.Append('\n');
      }
    }
  }

  nsTArray<nsString> interestingFiles;
  interestingFiles.AppendElement(NS_LITERAL_STRING("chrome.manifest"));
  interestingFiles.AppendElement(NS_LITERAL_STRING("omni.ja"));
  interestingFiles.AppendElement(NS_ConvertUTF8toUTF16(filename));

  annotation.AppendLiteral("GRE directory: ");
  nsCOMPtr<nsIFile> file;
  nsDirectoryService::gService->Get(NS_GRE_DIR, NS_GET_IID(nsIFile),
                                    getter_AddRefs(file));
  if (file) {
    // The Firefox installation directory.
    nsString path;
    file->GetPath(path);
    annotation.Append(path);
    annotation.Append('\n');

    // List interesting files -- any chrome.manifest or omni.ja file or any file
    // whose name is the sheet's filename -- under the Firefox installation
    // directory.
    annotation.AppendLiteral("Interesting files in the GRE directory:\n");
    ListInterestingFiles(annotation, file, interestingFiles);

    // If the Firefox installation directory has a chrome.manifest file, let's
    // see what's in it.
    file->Append(NS_LITERAL_STRING("chrome.manifest"));
    bool exists = false;
    file->Exists(&exists);
    if (exists) {
      annotation.AppendLiteral("Contents of chrome.manifest:\n[[[\n");
      PRFileDesc* fd;
      if (NS_SUCCEEDED(file->OpenNSPRFileDesc(PR_RDONLY, 0, &fd))) {
        nsCString contents;
        char buf[512];
        int32_t n;
        while ((n = PR_Read(fd, buf, sizeof(buf))) > 0) {
          contents.Append(buf, n);
        }
        if (n < 0) {
          annotation.AppendLiteral("  (error while reading)\n");
        } else {
          annotation.Append(NS_ConvertUTF8toUTF16(contents));
        }
        PR_Close(fd);
      }
      annotation.AppendLiteral("]]]\n");
    }
  } else {
    annotation.AppendLiteral("(none)\n");
  }

  // The jar: or file: URL prefix that chrome: and resource: URLs get translated
  // to.
  annotation.AppendLiteral("GRE omnijar URI string: ");
  nsCString uri;
  nsresult rv = Omnijar::GetURIString(Omnijar::GRE, uri);
  if (NS_FAILED(rv)) {
    annotation.AppendLiteral("(failed)\n");
  } else {
    annotation.Append(NS_ConvertUTF8toUTF16(uri));
    annotation.Append('\n');
  }

  RefPtr<nsZipArchive> zip = Omnijar::GetReader(Omnijar::GRE);
  if (zip) {
    // List interesting files in the GRE omnijar.
    annotation.AppendLiteral("Interesting files in the GRE omnijar:\n");
    nsZipFind* find;
    rv = zip->FindInit(nullptr, &find);
    if (NS_FAILED(rv)) {
      annotation.AppendPrintf("  (FindInit failed with 0x%08" PRIx32 ")\n",
                              static_cast<uint32_t>(rv));
    } else if (!find) {
      annotation.AppendLiteral("  (FindInit returned null)\n");
    } else {
      const char* result;
      uint16_t len;
      while (NS_SUCCEEDED(find->FindNext(&result, &len))) {
        nsCString itemPathname;
        nsString itemFilename;
        itemPathname.Append(result, len);
        int32_t i = itemPathname.RFindChar('/');
        if (i != -1) {
          itemFilename = NS_ConvertUTF8toUTF16(Substring(itemPathname, i + 1));
        }
        for (const nsString& interestingFile : interestingFiles) {
          if (interestingFile == itemFilename) {
            annotation.AppendLiteral("  ");
            annotation.Append(NS_ConvertUTF8toUTF16(itemPathname));
            nsZipItem* item = zip->GetItem(itemPathname.get());
            if (!item) {
              annotation.AppendLiteral(" (GetItem failed)\n");
            } else {
              annotation.AppendPrintf(" (%d bytes, crc32 = 0x%08x)\n",
                                      item->RealSize(),
                                      item->CRC32());
            }
            break;
          }
        }
      }
      delete find;
    }
  } else {
    annotation.AppendLiteral("No GRE omnijar\n");
  }

  CrashReporter::AnnotateCrashReport(NS_LITERAL_CSTRING("SheetLoadFailure"),
                                     NS_ConvertUTF16toUTF8(annotation));
}
#endif

static void
ErrorLoadingSheet(nsIURI* aURI, const char* aMsg, FailureAction aFailureAction)
{
  nsPrintfCString errorMessage("%s loading built-in stylesheet '%s'",
                               aMsg,
                               aURI ? aURI->GetSpecOrDefault().get() : "");
  if (aFailureAction == eLogToConsole) {
    nsCOMPtr<nsIConsoleService> cs = do_GetService(NS_CONSOLESERVICE_CONTRACTID);
    if (cs) {
      cs->LogStringMessage(NS_ConvertUTF8toUTF16(errorMessage).get());
      return;
    }
  }

#ifdef MOZ_CRASHREPORTER
  AnnotateCrashReport(aURI);
#endif
  NS_RUNTIMEABORT(errorMessage.get());
}

void
nsLayoutStylesheetCache::LoadSheet(nsIURI* aURI,
                                   RefPtr<StyleSheet>* aSheet,
                                   SheetParsingMode aParsingMode,
                                   FailureAction aFailureAction)
{
  if (!aURI) {
    ErrorLoadingSheet(aURI, "null URI", eCrash);
    return;
  }

  auto& loader = mBackendType == StyleBackendType::Gecko ?
    gCSSLoader_Gecko :
    gCSSLoader_Servo;

  if (!loader) {
    loader = new Loader(mBackendType, nullptr);
    if (!loader) {
      ErrorLoadingSheet(aURI, "no Loader", eCrash);
      return;
    }
  }

#ifdef MOZ_CRASHREPORTER
  nsZipArchive::sFileCorruptedReason = nullptr;
#endif
  nsresult rv = loader->LoadSheetSync(aURI, aParsingMode, true, aSheet);
  if (NS_FAILED(rv)) {
    ErrorLoadingSheet(aURI,
      nsPrintfCString("LoadSheetSync failed with error %" PRIx32, static_cast<uint32_t>(rv)).get(),
      aFailureAction);
  }
}

/* static */ void
nsLayoutStylesheetCache::InvalidateSheet(RefPtr<StyleSheet>* aGeckoSheet,
                                         RefPtr<StyleSheet>* aServoSheet)
{
  MOZ_ASSERT(gCSSLoader_Gecko || gCSSLoader_Servo,
             "pref changed before we loaded a sheet?");

  const bool gotGeckoSheet = aGeckoSheet && *aGeckoSheet;
  const bool gotServoSheet = aServoSheet && *aServoSheet;

  // Make sure sheets have the expected types
  MOZ_ASSERT(!gotGeckoSheet || (*aGeckoSheet)->IsGecko());
  MOZ_ASSERT(!gotServoSheet || (*aServoSheet)->IsServo());
  // Make sure the URIs match
  MOZ_ASSERT(!gotServoSheet || !gotGeckoSheet ||
             (*aGeckoSheet)->GetSheetURI() == (*aServoSheet)->GetSheetURI(),
             "Sheets passed should have the same URI");

  nsIURI* uri;
  if (gotGeckoSheet) {
    uri = (*aGeckoSheet)->GetSheetURI();
  } else if (gotServoSheet) {
    uri = (*aServoSheet)->GetSheetURI();
  } else {
    return;
  }

  if (gCSSLoader_Gecko) {
    gCSSLoader_Gecko->ObsoleteSheet(uri);
  }
  if (gCSSLoader_Servo) {
    gCSSLoader_Servo->ObsoleteSheet(uri);
  }
  if (gotGeckoSheet) {
    *aGeckoSheet = nullptr;
  }
  if (gotServoSheet) {
    *aServoSheet = nullptr;
  }
}

/* static */ void
nsLayoutStylesheetCache::DependentPrefChanged(const char* aPref, void* aData)
{
  MOZ_ASSERT(gStyleCache_Gecko || gStyleCache_Servo,
             "pref changed after shutdown?");

  // Cause any UA style sheets whose parsing depends on the value of prefs
  // to be re-parsed by dropping the sheet from gCSSLoader_{Gecko,Servo}'s cache
  // then setting our cached sheet pointer to null.  This will only work for
  // sheets that are loaded lazily.

#define INVALIDATE(sheet_) \
  InvalidateSheet(gStyleCache_Gecko ? &gStyleCache_Gecko->sheet_ : nullptr, \
                  gStyleCache_Servo ? &gStyleCache_Servo->sheet_ : nullptr);

  INVALIDATE(mUASheet);  // for layout.css.grid.enabled

#undef INVALIDATE
}

/* static */ void
nsLayoutStylesheetCache::InvalidatePreferenceSheets()
{
  if (gStyleCache_Gecko) {
    gStyleCache_Gecko->mContentPreferenceSheet = nullptr;
    gStyleCache_Gecko->mChromePreferenceSheet = nullptr;
  }
  if (gStyleCache_Servo) {
    gStyleCache_Servo->mContentPreferenceSheet = nullptr;
    gStyleCache_Servo->mChromePreferenceSheet = nullptr;
  }
}

void
nsLayoutStylesheetCache::BuildPreferenceSheet(RefPtr<StyleSheet>* aSheet,
                                              nsPresContext* aPresContext)
{
  if (mBackendType == StyleBackendType::Gecko) {
    *aSheet = new CSSStyleSheet(eAgentSheetFeatures, CORS_NONE,
                                mozilla::net::RP_Unset);
  } else {
    *aSheet = new ServoStyleSheet(eAgentSheetFeatures, CORS_NONE,
                                  mozilla::net::RP_Unset, dom::SRIMetadata());
  }

  StyleSheet* sheet = *aSheet;

  nsCOMPtr<nsIURI> uri;
  NS_NewURI(getter_AddRefs(uri), "about:PreferenceStyleSheet", nullptr);
  MOZ_ASSERT(uri, "URI creation shouldn't fail");

  sheet->SetURIs(uri, uri, uri);
  sheet->SetComplete();

  static const uint32_t kPreallocSize = 1024;

  nsString sheetText;
  sheetText.SetCapacity(kPreallocSize);

#define NS_GET_R_G_B(color_) \
  NS_GET_R(color_), NS_GET_G(color_), NS_GET_B(color_)

  sheetText.AppendLiteral(
      "@namespace url(http://www.w3.org/1999/xhtml);\n"
      "@namespace svg url(http://www.w3.org/2000/svg);\n");

  // Rules for link styling.
  nscolor linkColor = aPresContext->DefaultLinkColor();
  nscolor activeColor = aPresContext->DefaultActiveLinkColor();
  nscolor visitedColor = aPresContext->DefaultVisitedLinkColor();

  sheetText.AppendPrintf(
      "*|*:link { color: #%02x%02x%02x; }\n"
      "*|*:any-link:active { color: #%02x%02x%02x; }\n"
      "*|*:visited { color: #%02x%02x%02x; }\n",
      NS_GET_R_G_B(linkColor),
      NS_GET_R_G_B(activeColor),
      NS_GET_R_G_B(visitedColor));

  bool underlineLinks =
    aPresContext->GetCachedBoolPref(kPresContext_UnderlineLinks);
  sheetText.AppendPrintf(
      "*|*:any-link%s { text-decoration: %s; }\n",
      underlineLinks ? ":not(svg|a)" : "",
      underlineLinks ? "underline" : "none");

  // Rules for focus styling.

  bool focusRingOnAnything = aPresContext->GetFocusRingOnAnything();
  uint8_t focusRingWidth = aPresContext->FocusRingWidth();
  uint8_t focusRingStyle = aPresContext->GetFocusRingStyle();

  if ((focusRingWidth != 1 && focusRingWidth <= 4) || focusRingOnAnything) {
    if (focusRingWidth != 1) {
      // If the focus ring width is different from the default, fix buttons
      // with rings.
      sheetText.AppendPrintf(
          "button::-moz-focus-inner, input[type=\"reset\"]::-moz-focus-inner, "
          "input[type=\"button\"]::-moz-focus-inner, "
          "input[type=\"submit\"]::-moz-focus-inner { "
          "border: %dpx %s transparent !important; }\n",
          focusRingWidth,
          focusRingStyle == 0 ? "solid" : "dotted");

      sheetText.AppendLiteral(
          "button:focus::-moz-focus-inner, "
          "input[type=\"reset\"]:focus::-moz-focus-inner, "
          "input[type=\"button\"]:focus::-moz-focus-inner, "
          "input[type=\"submit\"]:focus::-moz-focus-inner { "
          "border-color: ButtonText !important; }\n");
    }

    sheetText.AppendPrintf(
        "%s { outline: %dpx %s !important; %s}\n",
        focusRingOnAnything ?
          ":focus" :
          "*|*:link:focus, *|*:visited:focus",
        focusRingWidth,
        focusRingStyle == 0 ? // solid
          "solid -moz-mac-focusring" : "dotted WindowText",
        focusRingStyle == 0 ? // solid
          "-moz-outline-radius: 3px; outline-offset: 1px; " : "");
  }

  if (aPresContext->GetUseFocusColors()) {
    nscolor focusText = aPresContext->FocusTextColor();
    nscolor focusBG = aPresContext->FocusBackgroundColor();
    sheetText.AppendPrintf(
        "*:focus, *:focus > font { color: #%02x%02x%02x !important; "
        "background-color: #%02x%02x%02x !important; }\n",
        NS_GET_R_G_B(focusText),
        NS_GET_R_G_B(focusBG));
  }

  NS_ASSERTION(sheetText.Length() <= kPreallocSize,
               "kPreallocSize should be big enough to build preference style "
               "sheet without reallocation");

  if (sheet->IsGecko()) {
    sheet->AsGecko()->ReparseSheet(sheetText);
  } else {
    ServoStyleSheet* servoSheet = sheet->AsServo();
    // NB: The pref sheet never has @import rules.
    nsresult rv =
      servoSheet->ParseSheet(nullptr, sheetText, uri, uri, nullptr, 0,
                             eCompatibility_FullStandards);
    // Parsing the about:PreferenceStyleSheet URI can only fail on OOM. If we
    // are OOM before we parsed any documents we might as well abort.
    MOZ_RELEASE_ASSERT(NS_SUCCEEDED(rv));
  }

#undef NS_GET_R_G_B
}

mozilla::StaticRefPtr<nsLayoutStylesheetCache>
nsLayoutStylesheetCache::gStyleCache_Gecko;

mozilla::StaticRefPtr<nsLayoutStylesheetCache>
nsLayoutStylesheetCache::gStyleCache_Servo;

mozilla::StaticRefPtr<mozilla::css::Loader>
nsLayoutStylesheetCache::gCSSLoader_Gecko;

mozilla::StaticRefPtr<mozilla::css::Loader>
nsLayoutStylesheetCache::gCSSLoader_Servo;

mozilla::StaticRefPtr<nsIURI>
nsLayoutStylesheetCache::gUserContentSheetURL_Gecko;

mozilla::StaticRefPtr<nsIURI>
nsLayoutStylesheetCache::gUserContentSheetURL_Servo;
