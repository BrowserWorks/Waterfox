
/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=4 et sw=4 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Attributes.h"

#include <cstdarg>

#include "mozilla/Logging.h"
#ifdef ANDROID
#include <android/log.h>
#endif
#ifdef XP_WIN
#include <windows.h>
#endif

#include "jsapi.h"
#include "nsCOMPtr.h"
#include "nsAutoPtr.h"
#include "nsIComponentManager.h"
#include "mozilla/Module.h"
#include "nsIFile.h"
#include "mozJSComponentLoader.h"
#include "mozJSLoaderUtils.h"
#include "nsIXPConnect.h"
#include "nsIObserverService.h"
#include "nsIScriptSecurityManager.h"
#include "nsIFileURL.h"
#include "nsIJARURI.h"
#include "nsNetUtil.h"
#include "jsprf.h"
#include "nsJSPrincipals.h"
#include "nsJSUtils.h"
#include "xpcprivate.h"
#include "xpcpublic.h"
#include "nsContentUtils.h"
#include "nsXULAppAPI.h"
#include "WrapperFactory.h"

#include "mozilla/AddonPathService.h"
#include "mozilla/scache/StartupCache.h"
#include "mozilla/scache/StartupCacheUtils.h"
#include "mozilla/MacroForEach.h"
#include "mozilla/Preferences.h"
#include "mozilla/dom/ScriptSettings.h"
#include "mozilla/UniquePtrExtensions.h"
#include "mozilla/Unused.h"

using namespace mozilla;
using namespace mozilla::scache;
using namespace xpc;
using namespace JS;

// This JSClass exists to trick silly code that expects toString()ing the
// global in a component scope to return something with "BackstagePass" in it
// to continue working.
static const JSClass kFakeBackstagePassJSClass = { "FakeBackstagePass" };

static const char kXPConnectServiceContractID[] = "@mozilla.org/js/xpc/XPConnect;1";
static const char kObserverServiceContractID[] = "@mozilla.org/observer-service;1";
static const char kJSCachePrefix[] = "jsloader";

#define HAVE_PR_MEMMAP

/**
 * Buffer sizes for serialization and deserialization of scripts.
 * FIXME: bug #411579 (tune this macro!) Last updated: Jan 2008
 */
#define XPC_SERIALIZATION_BUFFER_SIZE   (64 * 1024)
#define XPC_DESERIALIZATION_BUFFER_SIZE (12 * 8192)

// MOZ_LOG=JSComponentLoader:5
static LazyLogModule gJSCLLog("JSComponentLoader");

#define LOG(args) MOZ_LOG(gJSCLLog, mozilla::LogLevel::Debug, args)

// Components.utils.import error messages
#define ERROR_SCOPE_OBJ "%s - Second argument must be an object."
#define ERROR_NOT_PRESENT "%s - EXPORTED_SYMBOLS is not present."
#define ERROR_NOT_AN_ARRAY "%s - EXPORTED_SYMBOLS is not an array."
#define ERROR_GETTING_ARRAY_LENGTH "%s - Error getting array length of EXPORTED_SYMBOLS."
#define ERROR_ARRAY_ELEMENT "%s - EXPORTED_SYMBOLS[%d] is not a string."
#define ERROR_GETTING_SYMBOL "%s - Could not get symbol '%s'."
#define ERROR_SETTING_SYMBOL "%s - Could not set symbol '%s' on target object."

static bool
Dump(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    if (args.length() == 0)
        return true;

    RootedString str(cx, JS::ToString(cx, args[0]));
    if (!str)
        return false;

    JSAutoByteString utf8str;
    if (!utf8str.encodeUtf8(cx, str))
        return false;

#ifdef ANDROID
    __android_log_print(ANDROID_LOG_INFO, "Gecko", "%s", utf8str.ptr());
#endif
#ifdef XP_WIN
    if (IsDebuggerPresent()) {
        nsAutoJSString wstr;
        if (!wstr.init(cx, str))
            return false;
        OutputDebugStringW(wstr.get());
    }
#endif
    fputs(utf8str.ptr(), stdout);
    fflush(stdout);
    return true;
}

static bool
Debug(JSContext* cx, unsigned argc, Value* vp)
{
#ifdef DEBUG
    return Dump(cx, argc, vp);
#else
    return true;
#endif
}

static const JSFunctionSpec gGlobalFun[] = {
    JS_FS("dump",    Dump,   1,0),
    JS_FS("debug",   Debug,  1,0),
    JS_FS("atob",    Atob,   1,0),
    JS_FS("btoa",    Btoa,   1,0),
    JS_FS_END
};

class MOZ_STACK_CLASS JSCLContextHelper
{
public:
    explicit JSCLContextHelper(JSContext* aCx);
    ~JSCLContextHelper();

    void reportErrorAfterPop(char* buf);

private:
    JSContext* mContext;
    char*      mBuf;

    // prevent copying and assignment
    JSCLContextHelper(const JSCLContextHelper&) = delete;
    const JSCLContextHelper& operator=(const JSCLContextHelper&) = delete;
};

static nsresult
MOZ_FORMAT_PRINTF(2, 3)
ReportOnCallerUTF8(JSContext* callerContext,
                   const char* format, ...) {
    if (!callerContext) {
        return NS_ERROR_FAILURE;
    }

    va_list ap;
    va_start(ap, format);

    char* buf = JS_vsmprintf(format, ap);
    if (!buf) {
        va_end(ap);
        return NS_ERROR_OUT_OF_MEMORY;
    }

    JS_ReportErrorUTF8(callerContext, "%s", buf);
    JS_smprintf_free(buf);

    va_end(ap);
    return NS_OK;
}

static nsresult
MOZ_FORMAT_PRINTF(2, 3)
ReportOnCallerUTF8(JSCLContextHelper& helper,
                   const char* format, ...)
{
    va_list ap;
    va_start(ap, format);

    char* buf = JS_vsmprintf(format, ap);
    if (!buf) {
        va_end(ap);
        return NS_ERROR_OUT_OF_MEMORY;
    }

    helper.reportErrorAfterPop(buf);
    va_end(ap);
    return NS_OK;
}

mozJSComponentLoader::mozJSComponentLoader()
    : mModules(16),
      mImports(16),
      mInProgressImports(16),
      mInitialized(false),
      mReuseLoaderGlobal(false)
{
    MOZ_ASSERT(!sSelf, "mozJSComponentLoader should be a singleton");

    sSelf = this;
}

#define ENSURE_DEP(name) { nsresult rv = Ensure##name(); NS_ENSURE_SUCCESS(rv, rv); }
#define ENSURE_DEPS(...) MOZ_FOR_EACH(ENSURE_DEP, (), (__VA_ARGS__));
#define BEGIN_ENSURE(self, ...) { \
    if (m##self) \
        return NS_OK; \
    ENSURE_DEPS(__VA_ARGS__); \
}

class MOZ_STACK_CLASS ComponentLoaderInfo {
  public:
    explicit ComponentLoaderInfo(const nsACString& aLocation) : mLocation(aLocation) {}

    nsIIOService* IOService() { MOZ_ASSERT(mIOService); return mIOService; }
    nsresult EnsureIOService() {
        if (mIOService)
            return NS_OK;
        nsresult rv;
        mIOService = do_GetIOService(&rv);
        return rv;
    }

    nsIURI*  URI() { MOZ_ASSERT(mURI); return mURI; }
    nsresult EnsureURI() {
        BEGIN_ENSURE(URI, IOService);
        return mIOService->NewURI(mLocation, nullptr, nullptr, getter_AddRefs(mURI));
    }

    nsIChannel* ScriptChannel() { MOZ_ASSERT(mScriptChannel); return mScriptChannel; }
    nsresult EnsureScriptChannel() {
        BEGIN_ENSURE(ScriptChannel, IOService, URI);
        return NS_NewChannel(getter_AddRefs(mScriptChannel),
                             mURI,
                             nsContentUtils::GetSystemPrincipal(),
                             nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL,
                             nsIContentPolicy::TYPE_SCRIPT,
                             nullptr, // aLoadGroup
                             nullptr, // aCallbacks
                             nsIRequest::LOAD_NORMAL,
                             mIOService);
    }

    nsIURI* ResolvedURI() { MOZ_ASSERT(mResolvedURI); return mResolvedURI; }
    nsresult EnsureResolvedURI() {
        BEGIN_ENSURE(ResolvedURI, ScriptChannel);
        return mScriptChannel->GetURI(getter_AddRefs(mResolvedURI));
    }

    nsAutoCString& Key() { return *mKey; }
    nsresult EnsureKey() {
        ENSURE_DEPS(ResolvedURI);
        mKey.emplace();
        return mResolvedURI->GetSpec(*mKey);
    }

    MOZ_MUST_USE nsresult GetLocation(nsCString& aLocation) {
        nsresult rv = EnsureURI();
        NS_ENSURE_SUCCESS(rv, rv);
        return mURI->GetSpec(aLocation);
    }

  private:
    const nsACString& mLocation;
    nsCOMPtr<nsIIOService> mIOService;
    nsCOMPtr<nsIURI> mURI;
    nsCOMPtr<nsIChannel> mScriptChannel;
    nsCOMPtr<nsIURI> mResolvedURI;
    Maybe<nsAutoCString> mKey; // This is safe because we're MOZ_STACK_CLASS
};

#undef BEGIN_ENSURE
#undef ENSURE_DEPS
#undef ENSURE_DEP

mozJSComponentLoader::~mozJSComponentLoader()
{
    if (mInitialized) {
        NS_ERROR("'xpcom-shutdown-loaders' was not fired before cleaning up mozJSComponentLoader");
        UnloadModules();
    }

    sSelf = nullptr;
}

mozJSComponentLoader*
mozJSComponentLoader::sSelf;

NS_IMPL_ISUPPORTS(mozJSComponentLoader,
                  mozilla::ModuleLoader,
                  xpcIJSModuleLoader,
                  nsIObserver)

nsresult
mozJSComponentLoader::ReallyInit()
{
    nsresult rv;

    mReuseLoaderGlobal = Preferences::GetBool("jsloader.reuseGlobal");

    // XXXkhuey B2G child processes have some sort of preferences race that
    // results in getting the wrong value.
    // But we don't want that on Firefox Mulet as it break most Firefox JSMs...
    // Also disable on debug builds to break js components that rely on this.
#if defined(MOZ_B2G) && !defined(MOZ_MULET) && !defined(DEBUG)
    mReuseLoaderGlobal = true;
#endif

    nsCOMPtr<nsIScriptSecurityManager> secman =
        do_GetService(NS_SCRIPTSECURITYMANAGER_CONTRACTID);
    if (!secman)
        return NS_ERROR_FAILURE;

    rv = secman->GetSystemPrincipal(getter_AddRefs(mSystemPrincipal));
    if (NS_FAILED(rv) || !mSystemPrincipal)
        return NS_ERROR_FAILURE;

    nsCOMPtr<nsIObserverService> obsSvc =
        do_GetService(kObserverServiceContractID, &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = obsSvc->AddObserver(this, "xpcom-shutdown-loaders", false);
    NS_ENSURE_SUCCESS(rv, rv);

    mInitialized = true;

    return NS_OK;
}

// For terrible compatibility reasons, we need to consider both the global
// lexical environment and the global of modules when searching for exported
// symbols.
static JSObject*
ResolveModuleObjectProperty(JSContext* aCx, HandleObject aModObj, const char* name)
{
    if (JS_HasExtensibleLexicalEnvironment(aModObj)) {
        RootedObject lexical(aCx, JS_ExtensibleLexicalEnvironment(aModObj));
        bool found;
        if (!JS_HasOwnProperty(aCx, lexical, name, &found)) {
            return nullptr;
        }
        if (found) {
            return lexical;
        }
    }
    return aModObj;
}

const mozilla::Module*
mozJSComponentLoader::LoadModule(FileLocation& aFile)
{
    if (!NS_IsMainThread()) {
        MOZ_ASSERT(false, "Don't use JS components off the main thread");
        return nullptr;
    }

    nsCOMPtr<nsIFile> file = aFile.GetBaseFile();

    nsCString spec;
    aFile.GetURIString(spec);
    ComponentLoaderInfo info(spec);
    nsresult rv = info.EnsureURI();
    NS_ENSURE_SUCCESS(rv, nullptr);

    if (!mInitialized) {
        rv = ReallyInit();
        if (NS_FAILED(rv))
            return nullptr;
    }

    ModuleEntry* mod;
    if (mModules.Get(spec, &mod))
    return mod;

    dom::AutoJSAPI jsapi;
    jsapi.Init();
    JSContext* cx = jsapi.cx();

    nsAutoPtr<ModuleEntry> entry(new ModuleEntry(RootingContext::get(cx)));
    RootedValue dummy(cx);
    rv = ObjectForLocation(info, file, &entry->obj, &entry->thisObjectKey,
                           &entry->location, false, &dummy);
    if (NS_FAILED(rv)) {
        return nullptr;
    }

    nsCOMPtr<nsIXPConnect> xpc = do_GetService(kXPConnectServiceContractID,
                                               &rv);
    if (NS_FAILED(rv))
        return nullptr;

    nsCOMPtr<nsIComponentManager> cm;
    rv = NS_GetComponentManager(getter_AddRefs(cm));
    if (NS_FAILED(rv))
        return nullptr;

    JSAutoCompartment ac(cx, entry->obj);
    RootedObject entryObj(cx, entry->obj);

    RootedObject NSGetFactoryHolder(cx, ResolveModuleObjectProperty(cx, entryObj, "NSGetFactory"));
    RootedValue NSGetFactory_val(cx);
    if (!NSGetFactoryHolder ||
        !JS_GetProperty(cx, NSGetFactoryHolder, "NSGetFactory", &NSGetFactory_val) ||
        NSGetFactory_val.isUndefined())
    {
        return nullptr;
    }

    if (JS_TypeOfValue(cx, NSGetFactory_val) != JSTYPE_FUNCTION) {
        /*
         * spec's encoding is ASCII unless it's zip file, otherwise it's
         * random encoding.  Latin1 variant is safe for random encoding.
         */
        JS_ReportErrorLatin1(cx, "%s has NSGetFactory property that is not a function",
                             spec.get());
        return nullptr;
    }

    RootedObject jsGetFactoryObj(cx);
    if (!JS_ValueToObject(cx, NSGetFactory_val, &jsGetFactoryObj) ||
        !jsGetFactoryObj) {
        /* XXX report error properly */
        return nullptr;
    }

    rv = xpc->WrapJS(cx, jsGetFactoryObj,
                     NS_GET_IID(xpcIJSGetFactory), getter_AddRefs(entry->getfactoryobj));
    if (NS_FAILED(rv)) {
        /* XXX report error properly */
#ifdef DEBUG
        fprintf(stderr, "mJCL: couldn't get nsIModule from jsval\n");
#endif
        return nullptr;
    }

    // Cache this module for later
    mModules.Put(spec, entry);

    // Set the location information for the new global, so that tools like
    // about:memory may use that information
    if (!mReuseLoaderGlobal) {
        xpc::SetLocationForGlobal(entryObj, spec);
    }

    // The hash owns the ModuleEntry now, forget about it
    return entry.forget();
}

nsresult
mozJSComponentLoader::FindTargetObject(JSContext* aCx,
                                       MutableHandleObject aTargetObject)
{
    aTargetObject.set(nullptr);

    RootedObject targetObject(aCx);
    if (mReuseLoaderGlobal) {
        JSFunction* fun = js::GetOutermostEnclosingFunctionOfScriptedCaller(aCx);
        if (fun) {
            JSObject* funParent = js::GetNearestEnclosingWithEnvironmentObjectForFunction(fun);
            if (JS_GetClass(funParent) == &kFakeBackstagePassJSClass)
                targetObject = funParent;
        }
    }

    // The above could fail, even if mReuseLoaderGlobal, if the scripted
    // caller is not a component/JSM (it could be a DOM scope, for
    // instance).
    if (!targetObject) {
        // Our targetObject is the caller's global object. Let's get it.
        targetObject = CurrentGlobalOrNull(aCx);
    }

    aTargetObject.set(targetObject);
    return NS_OK;
}

// This requires that the keys be strings and the values be pointers.
template <class Key, class Data, class UserData>
static size_t
SizeOfTableExcludingThis(const nsBaseHashtable<Key, Data, UserData>& aTable,
                         MallocSizeOf aMallocSizeOf)
{
    size_t n = aTable.ShallowSizeOfExcludingThis(aMallocSizeOf);
    for (auto iter = aTable.ConstIter(); !iter.Done(); iter.Next()) {
        n += iter.Key().SizeOfExcludingThisIfUnshared(aMallocSizeOf);
        n += iter.Data()->SizeOfIncludingThis(aMallocSizeOf);
    }
    return n;
}

size_t
mozJSComponentLoader::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf)
{
    size_t n = aMallocSizeOf(this);
    n += SizeOfTableExcludingThis(mModules, aMallocSizeOf);
    n += SizeOfTableExcludingThis(mImports, aMallocSizeOf);
    n += SizeOfTableExcludingThis(mInProgressImports, aMallocSizeOf);
    return n;
}

// Some stack based classes for cleaning up on early return
#ifdef HAVE_PR_MEMMAP
class FileAutoCloser
{
 public:
    explicit FileAutoCloser(PRFileDesc* file) : mFile(file) {}
    ~FileAutoCloser() { PR_Close(mFile); }
 private:
    PRFileDesc* mFile;
};

class FileMapAutoCloser
{
 public:
    explicit FileMapAutoCloser(PRFileMap* map) : mMap(map) {}
    ~FileMapAutoCloser() { PR_CloseFileMap(mMap); }
 private:
    PRFileMap* mMap;
};
#else
class ANSIFileAutoCloser
{
 public:
    explicit ANSIFileAutoCloser(FILE* file) : mFile(file) {}
    ~ANSIFileAutoCloser() { fclose(mFile); }
 private:
    FILE* mFile;
};
#endif

JSObject*
mozJSComponentLoader::PrepareObjectForLocation(JSContext* aCx,
                                               nsIFile* aComponentFile,
                                               nsIURI* aURI,
                                               bool aReuseLoaderGlobal,
                                               bool* aRealFile)
{
    nsCOMPtr<nsIXPConnectJSObjectHolder> holder;
    if (aReuseLoaderGlobal) {
        holder = mLoaderGlobal;
    }

    nsresult rv = NS_OK;
    nsCOMPtr<nsIXPConnect> xpc =
        do_GetService(kXPConnectServiceContractID, &rv);
    NS_ENSURE_SUCCESS(rv, nullptr);
    bool createdNewGlobal = false;

    if (!mLoaderGlobal) {
        RefPtr<BackstagePass> backstagePass;
        rv = NS_NewBackstagePass(getter_AddRefs(backstagePass));
        NS_ENSURE_SUCCESS(rv, nullptr);

        CompartmentOptions options;

        options.creationOptions()
               .setZone(SystemZone)
               .setAddonId(aReuseLoaderGlobal ? nullptr : MapURIToAddonID(aURI));

        options.behaviors().setVersion(JSVERSION_LATEST);

        if (xpc::SharedMemoryEnabled())
            options.creationOptions().setSharedMemoryAndAtomicsEnabled(true);

        // Defer firing OnNewGlobalObject until after the __URI__ property has
        // been defined so the JS debugger can tell what module the global is
        // for
        rv = xpc->InitClassesWithNewWrappedGlobal(aCx,
                                                  static_cast<nsIGlobalObject*>(backstagePass),
                                                  mSystemPrincipal,
                                                  nsIXPConnect::DONT_FIRE_ONNEWGLOBALHOOK,
                                                  options,
                                                  getter_AddRefs(holder));
        NS_ENSURE_SUCCESS(rv, nullptr);
        createdNewGlobal = true;

        RootedObject global(aCx, holder->GetJSObject());
        NS_ENSURE_TRUE(global, nullptr);

        backstagePass->SetGlobalObject(global);

        JSAutoCompartment ac(aCx, global);
        if (!JS_DefineFunctions(aCx, global, gGlobalFun) ||
            !JS_DefineProfilingFunctions(aCx, global)) {
            return nullptr;
        }

        if (aReuseLoaderGlobal) {
            mLoaderGlobal = holder;
        }
    }

    RootedObject obj(aCx, holder->GetJSObject());
    NS_ENSURE_TRUE(obj, nullptr);

    JSAutoCompartment ac(aCx, obj);

    if (aReuseLoaderGlobal) {
        // If we're reusing the loader global, we don't actually use the
        // global, but rather we use a different object as the 'this' object.
        obj = JS_NewObject(aCx, &kFakeBackstagePassJSClass);
        NS_ENSURE_TRUE(obj, nullptr);
    }

    *aRealFile = false;

    // need to be extra careful checking for URIs pointing to files
    // EnsureFile may not always get called, especially on resource URIs
    // so we need to call GetFile to make sure this is a valid file
    nsCOMPtr<nsIFileURL> fileURL = do_QueryInterface(aURI, &rv);
    nsCOMPtr<nsIFile> testFile;
    if (NS_SUCCEEDED(rv)) {
        fileURL->GetFile(getter_AddRefs(testFile));
    }

    if (testFile) {
        *aRealFile = true;

        if (XRE_IsParentProcess()) {
            RootedObject locationObj(aCx);

            rv = xpc->WrapNative(aCx, obj, aComponentFile,
                                 NS_GET_IID(nsIFile),
                                 locationObj.address());
            NS_ENSURE_SUCCESS(rv, nullptr);
            NS_ENSURE_TRUE(locationObj, nullptr);

            if (!JS_DefineProperty(aCx, obj, "__LOCATION__", locationObj, 0))
                return nullptr;
        }
    }

    nsAutoCString nativePath;
    rv = aURI->GetSpec(nativePath);
    NS_ENSURE_SUCCESS(rv, nullptr);

    // Expose the URI from which the script was imported through a special
    // variable that we insert into the JSM.
    RootedString exposedUri(aCx, JS_NewStringCopyN(aCx, nativePath.get(), nativePath.Length()));
    NS_ENSURE_TRUE(exposedUri, nullptr);

    if (!JS_DefineProperty(aCx, obj, "__URI__", exposedUri, 0))
        return nullptr;

    if (createdNewGlobal) {
        // AutoEntryScript required to invoke debugger hook, which is a
        // Gecko-specific concept at present.
        dom::AutoEntryScript aes(holder->GetJSObject(),
                                 "component loader report global");
        RootedObject global(aes.cx(), holder->GetJSObject());
        JS_FireOnNewGlobalObject(aes.cx(), global);
    }

    return obj;
}

nsresult
mozJSComponentLoader::ObjectForLocation(ComponentLoaderInfo& aInfo,
                                        nsIFile* aComponentFile,
                                        MutableHandleObject aObject,
                                        MutableHandleScript aTableScript,
                                        char** aLocation,
                                        bool aPropagateExceptions,
                                        MutableHandleValue aException)
{
    MOZ_ASSERT(NS_IsMainThread(), "Must be on main thread.");

    dom::AutoJSAPI jsapi;
    jsapi.Init();
    JSContext* cx = jsapi.cx();

    bool realFile = false;
    nsresult rv = aInfo.EnsureURI();
    NS_ENSURE_SUCCESS(rv, rv);
    RootedObject obj(cx, PrepareObjectForLocation(cx, aComponentFile, aInfo.URI(),
                                                  mReuseLoaderGlobal, &realFile));
    NS_ENSURE_TRUE(obj, NS_ERROR_FAILURE);
    MOZ_ASSERT(JS_IsGlobalObject(obj) == !mReuseLoaderGlobal);

    JSAutoCompartment ac(cx, obj);

    RootedScript script(cx);
    RootedFunction function(cx);

    nsAutoCString nativePath;
    rv = aInfo.URI()->GetSpec(nativePath);
    NS_ENSURE_SUCCESS(rv, rv);

    // Before compiling the script, first check to see if we have it in
    // the startupcache.  Note: as a rule, startupcache errors are not fatal
    // to loading the script, since we can always slow-load.

    bool writeToCache = false;
    StartupCache* cache = StartupCache::GetSingleton();

    nsAutoCString cachePath(kJSCachePrefix);
    rv = PathifyURI(aInfo.URI(), cachePath);
    NS_ENSURE_SUCCESS(rv, rv);

    if (cache) {
        if (!mReuseLoaderGlobal) {
            rv = ReadCachedScript(cache, cachePath, cx, mSystemPrincipal, &script);
        } else {
            rv = ReadCachedFunction(cache, cachePath, cx, mSystemPrincipal,
                                    function.address());
        }

        if (NS_SUCCEEDED(rv)) {
            LOG(("Successfully loaded %s from startupcache\n", nativePath.get()));
        } else {
            // This is ok, it just means the script is not yet in the
            // cache. Could mean that the cache was corrupted and got removed,
            // but either way we're going to write this out.
            writeToCache = true;
            // ReadCachedScript and ReadCachedFunction may have set a pending
            // exception.
            JS_ClearPendingException(cx);
        }
    }

    if (!script && !function) {
        // The script wasn't in the cache , so compile it now.
        LOG(("Slow loading %s\n", nativePath.get()));

        // Use lazy source if both of these conditions hold:
        //
        // (1) mReuseLoaderGlobal is false. If mReuseLoaderGlobal is true, we
        //     can't do lazy source because we compile things as functions
        //     (rather than script), and lazy source isn't supported in that
        //     configuration. That's ok though, because we only do
        //     mReuseLoaderGlobal on b2g, where we invoke setDiscardSource(true)
        //     on the entire global.
        //
        // (2) We're using the startup cache. Non-lazy source + startup cache
        //     regresses installer size (due to source code stored in XDR
        //     encoded modules in omni.ja). Also, XDR decoding is relatively
        //     fast. Content processes don't use the startup cache, so we want
        //     them to use non-lazy source code to enable lazy parsing.
        //     See bug 1303754.
        CompileOptions options(cx);
        options.setNoScriptRval(mReuseLoaderGlobal ? false : true)
               .setVersion(JSVERSION_LATEST)
               .setFileAndLine(nativePath.get(), 1)
               .setSourceIsLazy(!mReuseLoaderGlobal && !!cache);

        if (realFile) {
#ifdef HAVE_PR_MEMMAP
            int64_t fileSize;
            rv = aComponentFile->GetFileSize(&fileSize);
            if (NS_FAILED(rv)) {
                return rv;
            }

            int64_t maxSize = UINT32_MAX;
            if (fileSize > maxSize) {
                NS_ERROR("file too large");
                return NS_ERROR_FAILURE;
            }

            PRFileDesc* fileHandle;
            rv = aComponentFile->OpenNSPRFileDesc(PR_RDONLY, 0, &fileHandle);
            if (NS_FAILED(rv)) {
                return NS_ERROR_FILE_NOT_FOUND;
            }

            // Make sure the file is closed, no matter how we return.
            FileAutoCloser fileCloser(fileHandle);

            // We don't provide the file size here.  If we did, PR_CreateFileMap
            // would simply stat() the file to verify that the size we provided
            // didn't require extending the file.  We know that the file doesn't
            // need to be extended, so skip the extra work by not providing the
            // size.
            PRFileMap* map = PR_CreateFileMap(fileHandle, 0, PR_PROT_READONLY);
            if (!map) {
                NS_ERROR("Failed to create file map");
                return NS_ERROR_FAILURE;
            }

            // Make sure the file map is closed, no matter how we return.
            FileMapAutoCloser mapCloser(map);

            uint32_t fileSize32 = fileSize;

            char* buf = static_cast<char*>(PR_MemMap(map, 0, fileSize32));
            if (!buf) {
                NS_WARNING("Failed to map file");
                return NS_ERROR_FAILURE;
            }

            if (!mReuseLoaderGlobal) {
                Compile(cx, options, buf, fileSize32, &script);
            } else {
                // Note: exceptions will get handled further down;
                // don't early return for them here.
                AutoObjectVector envChain(cx);
                if (envChain.append(obj)) {
                    CompileFunction(cx, envChain,
                                    options, nullptr, 0, nullptr,
                                    buf, fileSize32, &function);
                }
            }

            PR_MemUnmap(buf, fileSize32);

#else  /* HAVE_PR_MEMMAP */

            /**
             * No memmap implementation, so fall back to
             * reading in the file
             */

            FILE* fileHandle;
            rv = aComponentFile->OpenANSIFileDesc("r", &fileHandle);
            if (NS_FAILED(rv)) {
                return NS_ERROR_FILE_NOT_FOUND;
            }

            // Ensure file fclose
            ANSIFileAutoCloser fileCloser(fileHandle);

            int64_t len;
            rv = aComponentFile->GetFileSize(&len);
            if (NS_FAILED(rv) || len < 0) {
                NS_WARNING("Failed to get file size");
                return NS_ERROR_FAILURE;
            }

            char* buf = (char*) malloc(len * sizeof(char));
            if (!buf) {
                return NS_ERROR_FAILURE;
            }

            size_t rlen = fread(buf, 1, len, fileHandle);
            if (rlen != (uint64_t)len) {
                free(buf);
                NS_WARNING("Failed to read file");
                return NS_ERROR_FAILURE;
            }

            if (!mReuseLoaderGlobal) {
                script = Compile(cx, options, buf, fileSize32);
            } else {
                // Note: exceptions will get handled further down;
                // don't early return for them here.
                AutoObjectVector envChain(cx);
                if (envChain.append(obj)) {
                    CompileFunction(cx, envChain,
                                    options, nullptr, 0, nullptr,
                                    buf, fileSize32, &function);
                }
            }

            free(buf);

#endif /* HAVE_PR_MEMMAP */
        } else {
            rv = aInfo.EnsureScriptChannel();
            NS_ENSURE_SUCCESS(rv, rv);
            nsCOMPtr<nsIInputStream> scriptStream;
            rv = NS_MaybeOpenChannelUsingOpen2(aInfo.ScriptChannel(),
                   getter_AddRefs(scriptStream));
            NS_ENSURE_SUCCESS(rv, rv);

            uint64_t len64;
            uint32_t bytesRead;

            rv = scriptStream->Available(&len64);
            NS_ENSURE_SUCCESS(rv, rv);
            NS_ENSURE_TRUE(len64 < UINT32_MAX, NS_ERROR_FILE_TOO_BIG);
            if (!len64)
                return NS_ERROR_FAILURE;
            uint32_t len = (uint32_t)len64;

            /* malloc an internal buf the size of the file */
            auto buf = MakeUniqueFallible<char[]>(len + 1);
            if (!buf)
                return NS_ERROR_OUT_OF_MEMORY;

            /* read the file in one swoop */
            rv = scriptStream->Read(buf.get(), len, &bytesRead);
            if (bytesRead != len)
                return NS_BASE_STREAM_OSERROR;

            buf[len] = '\0';

            if (!mReuseLoaderGlobal) {
                Compile(cx, options, buf.get(), bytesRead, &script);
            } else {
                // Note: exceptions will get handled further down;
                // don't early return for them here.
                AutoObjectVector envChain(cx);
                if (envChain.append(obj)) {
                    CompileFunction(cx, envChain,
                                    options, nullptr, 0, nullptr,
                                    buf.get(), bytesRead, &function);
                }
            }
        }
        // Propagate the exception, if one exists. Also, don't leave the stale
        // exception on this context.
        if (!script && !function && aPropagateExceptions &&
            jsapi.HasException()) {
            if (!jsapi.StealException(aException))
                return NS_ERROR_OUT_OF_MEMORY;
        }
    }

    if (!script && !function) {
        return NS_ERROR_FAILURE;
    }

    // We must have a script or a function (but not both!) here.  We have a
    // script when we're not reusing the loader global, and a function
    // otherwise.
    MOZ_ASSERT(!!script != !!function);
    MOZ_ASSERT(!!script == JS_IsGlobalObject(obj));

    if (writeToCache) {
        // We successfully compiled the script, so cache it.
        if (script) {
            rv = WriteCachedScript(cache, cachePath, cx, mSystemPrincipal,
                                   script);
        } else {
            rv = WriteCachedFunction(cache, cachePath, cx, mSystemPrincipal,
                                     function);
        }

        // Don't treat failure to write as fatal, since we might be working
        // with a read-only cache.
        if (NS_SUCCEEDED(rv)) {
            LOG(("Successfully wrote to cache\n"));
        } else {
            LOG(("Failed to write to cache\n"));
        }
    }

    // Assign aObject here so that it's available to recursive imports.
    // See bug 384168.
    aObject.set(obj);

    RootedScript tableScript(cx, script);
    if (!tableScript) {
        tableScript = JS_GetFunctionScript(cx, function);
        MOZ_ASSERT(tableScript);
    }

    aTableScript.set(tableScript);


    {   // Scope for AutoEntryScript

        // We're going to run script via JS_ExecuteScript or
        // JS_CallFunction, so we need an AutoEntryScript.
        // This is Gecko-specific and not in any spec.
        dom::AutoEntryScript aes(CurrentGlobalOrNull(cx),
                                 "component loader load module");
        JSContext* aescx = aes.cx();
        bool ok;
        if (script) {
            ok = JS_ExecuteScript(aescx, script);
        } else {
            RootedValue rval(cx);
            ok = JS_CallFunction(aescx, obj, function,
                                 JS::HandleValueArray::empty(), &rval);
        }

        if (!ok) {
            if (aPropagateExceptions && aes.HasException()) {
                // Ignore return value because we're returning an error code
                // anyway.
                Unused << aes.StealException(aException);
            }
            aObject.set(nullptr);
            aTableScript.set(nullptr);
            return NS_ERROR_FAILURE;
        }
    }

    /* Freed when we remove from the table. */
    *aLocation = ToNewCString(nativePath);
    if (!*aLocation) {
        aObject.set(nullptr);
        aTableScript.set(nullptr);
        return NS_ERROR_OUT_OF_MEMORY;
    }

    return NS_OK;
}

void
mozJSComponentLoader::UnloadModules()
{
    mInitialized = false;

    if (mLoaderGlobal) {
        MOZ_ASSERT(mReuseLoaderGlobal, "How did this happen?");

        dom::AutoJSAPI jsapi;
        jsapi.Init();
        JSContext* cx = jsapi.cx();
        RootedObject global(cx, mLoaderGlobal->GetJSObject());
        if (global) {
            JSAutoCompartment ac(cx, global);
            if (JS_HasExtensibleLexicalEnvironment(global)) {
                JS_SetAllNonReservedSlotsToUndefined(cx, JS_ExtensibleLexicalEnvironment(global));
            }
            JS_SetAllNonReservedSlotsToUndefined(cx, global);
        } else {
            NS_WARNING("Going to leak!");
        }

        mLoaderGlobal = nullptr;
    }

    mInProgressImports.Clear();
    mImports.Clear();

    for (auto iter = mModules.Iter(); !iter.Done(); iter.Next()) {
        iter.Data()->Clear();
        iter.Remove();
    }
}

NS_IMETHODIMP
mozJSComponentLoader::Import(const nsACString& registryLocation,
                             HandleValue targetValArg,
                             JSContext* cx,
                             uint8_t optionalArgc,
                             MutableHandleValue retval)
{
    MOZ_ASSERT(nsContentUtils::IsCallerChrome());

    RootedValue targetVal(cx, targetValArg);
    RootedObject targetObject(cx, nullptr);
    if (optionalArgc) {
        // The caller passed in the optional second argument. Get it.
        if (targetVal.isObject()) {
            // If we're passing in something like a content DOM window, chances
            // are the caller expects the properties to end up on the object
            // proper and not on the Xray holder. This is dubious, but can be used
            // during testing. Given that dumb callers can already leak JSMs into
            // content by passing a raw content JS object (where Xrays aren't
            // possible), we aim for consistency here. Waive xray.
            if (WrapperFactory::IsXrayWrapper(&targetVal.toObject()) &&
                !WrapperFactory::WaiveXrayAndWrap(cx, &targetVal))
            {
                return NS_ERROR_FAILURE;
            }
            targetObject = &targetVal.toObject();
        } else if (!targetVal.isNull()) {
            // If targetVal isNull(), we actually want to leave targetObject null.
            // Not doing so breaks |make package|.
            return ReportOnCallerUTF8(cx, ERROR_SCOPE_OBJ,
                                      PromiseFlatCString(registryLocation).get());
        }
    } else {
        nsresult rv = FindTargetObject(cx, &targetObject);
        NS_ENSURE_SUCCESS(rv, rv);
    }

    Maybe<JSAutoCompartment> ac;
    if (targetObject) {
        ac.emplace(cx, targetObject);
    }

    RootedObject global(cx);
    nsresult rv = ImportInto(registryLocation, targetObject, cx, &global);

    if (global) {
        if (!JS_WrapObject(cx, &global)) {
            NS_ERROR("can't wrap return value");
            return NS_ERROR_FAILURE;
        }

        retval.setObject(*global);
    }
    return rv;
}

NS_IMETHODIMP
mozJSComponentLoader::ImportInto(const nsACString& aLocation,
                                 JSObject* aTargetObj,
                                 nsAXPCNativeCallContext* cc,
                                 JSObject** _retval)
{
    JSContext* callercx;
    nsresult rv = cc->GetJSContext(&callercx);
    NS_ENSURE_SUCCESS(rv, rv);

    RootedObject targetObject(callercx, aTargetObj);
    RootedObject global(callercx);
    rv = ImportInto(aLocation, targetObject, callercx, &global);
    NS_ENSURE_SUCCESS(rv, rv);
    *_retval = global;
    return NS_OK;
}

NS_IMETHODIMP
mozJSComponentLoader::IsModuleLoaded(const nsACString& aLocation,
                                     bool* retval)
{
    MOZ_ASSERT(nsContentUtils::IsCallerChrome());

    nsresult rv;
    if (!mInitialized) {
        rv = ReallyInit();
        NS_ENSURE_SUCCESS(rv, rv);
    }

    ComponentLoaderInfo info(aLocation);
    rv = info.EnsureKey();
    NS_ENSURE_SUCCESS(rv, rv);

    *retval = !!mImports.Get(info.Key());
    return NS_OK;
}

static JSObject*
ResolveModuleObjectPropertyById(JSContext* aCx, HandleObject aModObj, HandleId id)
{
    if (JS_HasExtensibleLexicalEnvironment(aModObj)) {
        RootedObject lexical(aCx, JS_ExtensibleLexicalEnvironment(aModObj));
        bool found;
        if (!JS_HasOwnPropertyById(aCx, lexical, id, &found)) {
            return nullptr;
        }
        if (found) {
            return lexical;
        }
    }
    return aModObj;
}

nsresult
mozJSComponentLoader::ImportInto(const nsACString& aLocation,
                                 HandleObject targetObj,
                                 JSContext* callercx,
                                 MutableHandleObject vp)
{
    vp.set(nullptr);

    nsresult rv;
    if (!mInitialized) {
        rv = ReallyInit();
        NS_ENSURE_SUCCESS(rv, rv);
    }

    ComponentLoaderInfo info(aLocation);
    rv = info.EnsureResolvedURI();
    NS_ENSURE_SUCCESS(rv, rv);

    // get the JAR if there is one
    nsCOMPtr<nsIJARURI> jarURI;
    jarURI = do_QueryInterface(info.ResolvedURI(), &rv);
    nsCOMPtr<nsIFileURL> baseFileURL;
    if (NS_SUCCEEDED(rv)) {
        nsCOMPtr<nsIURI> baseURI;
        while (jarURI) {
            jarURI->GetJARFile(getter_AddRefs(baseURI));
            jarURI = do_QueryInterface(baseURI, &rv);
        }
        baseFileURL = do_QueryInterface(baseURI, &rv);
        NS_ENSURE_SUCCESS(rv, rv);
    } else {
        baseFileURL = do_QueryInterface(info.ResolvedURI(), &rv);
        NS_ENSURE_SUCCESS(rv, rv);
    }

    nsCOMPtr<nsIFile> sourceFile;
    rv = baseFileURL->GetFile(getter_AddRefs(sourceFile));
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIFile> sourceLocalFile;
    sourceLocalFile = do_QueryInterface(sourceFile, &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = info.EnsureKey();
    NS_ENSURE_SUCCESS(rv, rv);

    ModuleEntry* mod;
    nsAutoPtr<ModuleEntry> newEntry;
    if (!mImports.Get(info.Key(), &mod) && !mInProgressImports.Get(info.Key(), &mod)) {
        newEntry = new ModuleEntry(RootingContext::get(callercx));
        if (!newEntry)
            return NS_ERROR_OUT_OF_MEMORY;
        mInProgressImports.Put(info.Key(), newEntry);

        rv = info.EnsureURI();
        NS_ENSURE_SUCCESS(rv, rv);
        RootedValue exception(callercx);
        rv = ObjectForLocation(info, sourceLocalFile, &newEntry->obj,
                               &newEntry->thisObjectKey,
                               &newEntry->location, true, &exception);

        mInProgressImports.Remove(info.Key());

        if (NS_FAILED(rv)) {
            if (!exception.isUndefined()) {
                // An exception was thrown during compilation. Propagate it
                // out to our caller so they can report it.
                if (!JS_WrapValue(callercx, &exception))
                    return NS_ERROR_OUT_OF_MEMORY;
                JS_SetPendingException(callercx, exception);
                return NS_OK;
            }

            // Something failed, but we don't know what it is, guess.
            return NS_ERROR_FILE_NOT_FOUND;
        }

        // Set the location information for the new global, so that tools like
        // about:memory may use that information
        if (!mReuseLoaderGlobal) {
            xpc::SetLocationForGlobal(newEntry->obj, aLocation);
        }

        mod = newEntry;
    }

    MOZ_ASSERT(mod->obj, "Import table contains entry with no object");
    vp.set(mod->obj);

    if (targetObj) {
        // cxhelper must be created before jsapi, so that jsapi is detroyed and
        // pops any context it has pushed before we report to the caller context.
        JSCLContextHelper cxhelper(callercx);

        // Even though we are calling JS_SetPropertyById on targetObj, we want
        // to ensure that we never run script here, so we use an AutoJSAPI and
        // not an AutoEntryScript.
        dom::AutoJSAPI jsapi;
        jsapi.Init();
        JSContext* cx = jsapi.cx();
        JSAutoCompartment ac(cx, mod->obj);

        RootedValue symbols(cx);
        RootedObject exportedSymbolsHolder(cx, ResolveModuleObjectProperty(cx, mod->obj,
                                                                           "EXPORTED_SYMBOLS"));
        if (!exportedSymbolsHolder ||
            !JS_GetProperty(cx, exportedSymbolsHolder,
                            "EXPORTED_SYMBOLS", &symbols)) {
            nsCString location;
            rv = info.GetLocation(location);
            NS_ENSURE_SUCCESS(rv, rv);
            return ReportOnCallerUTF8(cxhelper, ERROR_NOT_PRESENT,
                                      location.get());
        }

        bool isArray;
        if (!JS_IsArrayObject(cx, symbols, &isArray)) {
            return NS_ERROR_FAILURE;
        }
        if (!isArray) {
            nsCString location;
            rv = info.GetLocation(location);
            NS_ENSURE_SUCCESS(rv, rv);
            return ReportOnCallerUTF8(cxhelper, ERROR_NOT_AN_ARRAY,
                                      location.get());
        }

        RootedObject symbolsObj(cx, &symbols.toObject());

        // Iterate over symbols array, installing symbols on targetObj:

        uint32_t symbolCount = 0;
        if (!JS_GetArrayLength(cx, symbolsObj, &symbolCount)) {
            nsCString location;
            rv = info.GetLocation(location);
            NS_ENSURE_SUCCESS(rv, rv);
            return ReportOnCallerUTF8(cxhelper, ERROR_GETTING_ARRAY_LENGTH,
                                      location.get());
        }

#ifdef DEBUG
        nsAutoCString logBuffer;
#endif

        RootedValue value(cx);
        RootedId symbolId(cx);
        RootedObject symbolHolder(cx);
        for (uint32_t i = 0; i < symbolCount; ++i) {
            if (!JS_GetElement(cx, symbolsObj, i, &value) ||
                !value.isString() ||
                !JS_ValueToId(cx, value, &symbolId)) {
                nsCString location;
                rv = info.GetLocation(location);
                NS_ENSURE_SUCCESS(rv, rv);
                return ReportOnCallerUTF8(cxhelper, ERROR_ARRAY_ELEMENT,
                                          location.get(), i);
            }

            symbolHolder = ResolveModuleObjectPropertyById(cx, mod->obj, symbolId);
            if (!symbolHolder ||
                !JS_GetPropertyById(cx, symbolHolder, symbolId, &value)) {
                JSAutoByteString bytes;
                RootedString symbolStr(cx, JSID_TO_STRING(symbolId));
                if (!bytes.encodeUtf8(cx, symbolStr))
                    return NS_ERROR_FAILURE;
                nsCString location;
                rv = info.GetLocation(location);
                NS_ENSURE_SUCCESS(rv, rv);
                return ReportOnCallerUTF8(cxhelper, ERROR_GETTING_SYMBOL,
                                          location.get(), bytes.ptr());
            }

            JSAutoCompartment target_ac(cx, targetObj);

            if (!JS_WrapValue(cx, &value) ||
                !JS_SetPropertyById(cx, targetObj, symbolId, value)) {
                JSAutoByteString bytes;
                RootedString symbolStr(cx, JSID_TO_STRING(symbolId));
                if (!bytes.encodeUtf8(cx, symbolStr))
                    return NS_ERROR_FAILURE;
                nsCString location;
                rv = info.GetLocation(location);
                NS_ENSURE_SUCCESS(rv, rv);
                return ReportOnCallerUTF8(cxhelper, ERROR_SETTING_SYMBOL,
                                          location.get(), bytes.ptr());
            }
#ifdef DEBUG
            if (i == 0) {
                logBuffer.AssignLiteral("Installing symbols [ ");
            }
            JSAutoByteString bytes(cx, JSID_TO_STRING(symbolId));
            if (!!bytes)
                logBuffer.Append(bytes.ptr());
            logBuffer.Append(' ');
            if (i == symbolCount - 1) {
                nsCString location;
                rv = info.GetLocation(location);
                NS_ENSURE_SUCCESS(rv, rv);
                LOG(("%s] from %s\n", logBuffer.get(), location.get()));
            }
#endif
        }
    }

    // Cache this module for later
    if (newEntry) {
        mImports.Put(info.Key(), newEntry);
        newEntry.forget();
    }

    return NS_OK;
}

NS_IMETHODIMP
mozJSComponentLoader::Unload(const nsACString & aLocation)
{
    nsresult rv;

    if (!mInitialized) {
        return NS_OK;
    }

    MOZ_RELEASE_ASSERT(!mReuseLoaderGlobal, "Module unloading not supported when "
                                            "compartment sharing is enabled");

    ComponentLoaderInfo info(aLocation);
    rv = info.EnsureKey();
    NS_ENSURE_SUCCESS(rv, rv);
    ModuleEntry* mod;
    if (mImports.Get(info.Key(), &mod)) {
        mImports.Remove(info.Key());
    }

    return NS_OK;
}

NS_IMETHODIMP
mozJSComponentLoader::Observe(nsISupports* subject, const char* topic,
                              const char16_t* data)
{
    if (!strcmp(topic, "xpcom-shutdown-loaders")) {
        UnloadModules();
    } else {
        NS_ERROR("Unexpected observer topic.");
    }

    return NS_OK;
}

size_t
mozJSComponentLoader::ModuleEntry::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
    size_t n = aMallocSizeOf(this);
    n += aMallocSizeOf(location);

    return n;
}

/* static */ already_AddRefed<nsIFactory>
mozJSComponentLoader::ModuleEntry::GetFactory(const mozilla::Module& module,
                                              const mozilla::Module::CIDEntry& entry)
{
    const ModuleEntry& self = static_cast<const ModuleEntry&>(module);
    MOZ_ASSERT(self.getfactoryobj, "Handing out an uninitialized module?");

    nsCOMPtr<nsIFactory> f;
    nsresult rv = self.getfactoryobj->Get(*entry.cid, getter_AddRefs(f));
    if (NS_FAILED(rv))
        return nullptr;

    return f.forget();
}

//----------------------------------------------------------------------

JSCLContextHelper::JSCLContextHelper(JSContext* aCx)
    : mContext(aCx)
    , mBuf(nullptr)
{
}

JSCLContextHelper::~JSCLContextHelper()
{
    if (mBuf) {
        JS_ReportErrorUTF8(mContext, "%s", mBuf);
        JS_smprintf_free(mBuf);
    }
}

void
JSCLContextHelper::reportErrorAfterPop(char* buf)
{
    MOZ_ASSERT(!mBuf, "Already called reportErrorAfterPop");
    mBuf = buf;
}
