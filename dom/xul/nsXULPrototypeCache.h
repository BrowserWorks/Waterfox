/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsXULPrototypeCache_h__
#define nsXULPrototypeCache_h__

#include "nsCOMPtr.h"
#include "nsIObserver.h"
#include "nsXBLDocumentInfo.h"
#include "nsJSThingHashtable.h"
#include "nsInterfaceHashtable.h"
#include "nsRefPtrHashtable.h"
#include "nsURIHashKey.h"
#include "nsXULPrototypeDocument.h"
#include "nsIInputStream.h"
#include "nsIStorageStream.h"

#include "mozilla/scache/StartupCache.h"

namespace mozilla {
class StyleSheet;
} // namespace mozilla

/**
 * The XUL prototype cache can be used to store and retrieve shared data for
 * XUL documents, style sheets, XBL, and scripts.
 *
 * The cache has two levels:
 *  1. In-memory hashtables
 *  2. The on-disk cache file.
 */
class nsXULPrototypeCache : public nsIObserver
{
public:
    // nsISupports
    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIOBSERVER

    bool IsCached(nsIURI* aURI) {
        return GetPrototype(aURI) != nullptr;
    }
    void AbortCaching();


    /**
     * Whether the prototype cache is enabled.
     */
    bool IsEnabled();

    /**
     * Flush the cache; remove all XUL prototype documents, style
     * sheets, and scripts.
     */
    void Flush();


    // The following methods are used to put and retrive various items into and
    // from the cache.

    nsXULPrototypeDocument* GetPrototype(nsIURI* aURI);
    nsresult PutPrototype(nsXULPrototypeDocument* aDocument);

    JSScript* GetScript(nsIURI* aURI);
    nsresult PutScript(nsIURI* aURI, JS::Handle<JSScript*> aScriptObject);

    nsXBLDocumentInfo* GetXBLDocumentInfo(nsIURI* aURL,
                                          mozilla::StyleBackendType aType);

    nsresult PutXBLDocumentInfo(nsXBLDocumentInfo* aDocumentInfo);

    /**
     * Get a style sheet by URI. If the style sheet is not in the cache,
     * returns nullptr.
     */
    mozilla::StyleSheet* GetStyleSheet(nsIURI* aURI,
                                       mozilla::StyleBackendType aType);

    /**
     * Store a style sheet in the cache. The key, style sheet's URI is obtained
     * from the style sheet itself.
     */
    nsresult PutStyleSheet(mozilla::StyleSheet* aStyleSheet,
                           mozilla::StyleBackendType aType);

    /**
     * Write the XUL prototype document to a cache file. The proto must be
     * fully loaded.
     */
    nsresult WritePrototype(nsXULPrototypeDocument* aPrototypeDocument);

    /**
     * This interface allows partial reads and writes from the buffers in the
     * startupCache.
     */
    nsresult GetInputStream(nsIURI* aURI, nsIObjectInputStream** objectInput);
    nsresult FinishInputStream(nsIURI* aURI);
    nsresult GetOutputStream(nsIURI* aURI, nsIObjectOutputStream** objectOutput);
    nsresult FinishOutputStream(nsIURI* aURI);
    nsresult HasData(nsIURI* aURI, bool* exists);

    static nsXULPrototypeCache* GetInstance();
    static nsXULPrototypeCache* MaybeGetInstance() { return sInstance; }

    static void ReleaseGlobals()
    {
        NS_IF_RELEASE(sInstance);
    }

    void MarkInCCGeneration(uint32_t aGeneration);
    void MarkInGC(JSTracer* aTrc);
    void FlushScripts();
protected:
    friend nsresult
    NS_NewXULPrototypeCache(nsISupports* aOuter, REFNSIID aIID, void** aResult);

    nsXULPrototypeCache();
    virtual ~nsXULPrototypeCache();

    static nsXULPrototypeCache* sInstance;

    void FlushSkinFiles();

    using StyleSheetTable = nsRefPtrHashtable<nsURIHashKey, mozilla::StyleSheet>;
    using XBLDocTable = nsRefPtrHashtable<nsURIHashKey, nsXBLDocumentInfo>;

    StyleSheetTable& StyleSheetTableFor(mozilla::StyleBackendType aType) {
      return aType == mozilla::StyleBackendType::Gecko ? mGeckoStyleSheetTable
                                                       : mServoStyleSheetTable;
    }

    XBLDocTable& XBLDocTableFor(mozilla::StyleBackendType aType) {
      return aType == mozilla::StyleBackendType::Gecko ? mGeckoXBLDocTable
                                                       : mServoXBLDocTable;
    }

    nsRefPtrHashtable<nsURIHashKey,nsXULPrototypeDocument>   mPrototypeTable; // owns the prototypes
    StyleSheetTable                                          mGeckoStyleSheetTable;
    StyleSheetTable                                          mServoStyleSheetTable;
    nsJSThingHashtable<nsURIHashKey, JSScript*>              mScriptTable;
    XBLDocTable                                              mGeckoXBLDocTable;
    XBLDocTable                                              mServoXBLDocTable;

    // URIs already written to the startup cache, to prevent double-caching.
    nsTHashtable<nsURIHashKey>                               mStartupCacheURITable;

    nsInterfaceHashtable<nsURIHashKey, nsIStorageStream>     mOutputStreamTable;
    nsInterfaceHashtable<nsURIHashKey, nsIObjectInputStream> mInputStreamTable;

    // Bootstrap caching service
    nsresult BeginCaching(nsIURI* aDocumentURI);
};

#endif // nsXULPrototypeCache_h__
