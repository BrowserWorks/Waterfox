/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsXPCOMGlue.h"

#include "nspr.h"
#include "nsDebug.h"
#include "nsIServiceManager.h"
#include "nsXPCOMPrivate.h"
#include "nsCOMPtr.h"
#include <stdlib.h>
#include <stdio.h>

#include "mozilla/FileUtils.h"
#include "mozilla/Sprintf.h"

using namespace mozilla;

#define XPCOM_DEPENDENT_LIBS_LIST "dependentlibs.list"

static XPCOMFunctions xpcomFunctions;
static bool do_preload = false;

#if defined(XP_WIN)
#define READ_TEXTMODE L"rt"
#else
#define READ_TEXTMODE "r"
#endif

#if defined(XP_WIN)
#include <windows.h>
#include <mbstring.h>

typedef HINSTANCE LibHandleType;

static LibHandleType
GetLibHandle(pathstr_t aDependentLib)
{
  LibHandleType libHandle =
    LoadLibraryExW(aDependentLib, nullptr, LOAD_WITH_ALTERED_SEARCH_PATH);

#ifdef DEBUG
  if (!libHandle) {
    DWORD err = GetLastError();
    LPWSTR lpMsgBuf;
    FormatMessageW(
      FORMAT_MESSAGE_ALLOCATE_BUFFER |
      FORMAT_MESSAGE_FROM_SYSTEM |
      FORMAT_MESSAGE_IGNORE_INSERTS,
      nullptr,
      err,
      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      (LPWSTR)&lpMsgBuf,
      0,
      nullptr
    );
    wprintf(L"Error loading %ls: %s\n", aDependentLib, lpMsgBuf);
    LocalFree(lpMsgBuf);
  }
#endif

  return libHandle;
}

static NSFuncPtr
GetSymbol(LibHandleType aLibHandle, const char* aSymbol)
{
  return (NSFuncPtr)GetProcAddress(aLibHandle, aSymbol);
}

static void
CloseLibHandle(LibHandleType aLibHandle)
{
  FreeLibrary(aLibHandle);
}

#else
#include <dlfcn.h>

#if defined(MOZ_LINKER) && !defined(ANDROID)
extern "C" {
NS_HIDDEN __typeof(dlopen) __wrap_dlopen;
NS_HIDDEN __typeof(dlsym) __wrap_dlsym;
NS_HIDDEN __typeof(dlclose) __wrap_dlclose;
}

#define dlopen __wrap_dlopen
#define dlsym __wrap_dlsym
#define dlclose __wrap_dlclose
#endif

typedef void* LibHandleType;

static LibHandleType
GetLibHandle(pathstr_t aDependentLib)
{
  LibHandleType libHandle = dlopen(aDependentLib,
                                   RTLD_GLOBAL | RTLD_LAZY
#ifdef XP_MACOSX
                                   | RTLD_FIRST
#endif
                                   );
  if (!libHandle) {
    fprintf(stderr, "XPCOMGlueLoad error for file %s:\n%s\n", aDependentLib,
            dlerror());
  }
  return libHandle;
}

static NSFuncPtr
GetSymbol(LibHandleType aLibHandle, const char* aSymbol)
{
  return (NSFuncPtr)dlsym(aLibHandle, aSymbol);
}

static void
CloseLibHandle(LibHandleType aLibHandle)
{
  dlclose(aLibHandle);
}
#endif

struct DependentLib
{
  LibHandleType libHandle;
  DependentLib* next;
};

static DependentLib* sTop;

static void
AppendDependentLib(LibHandleType aLibHandle)
{
  DependentLib* d = new DependentLib;
  if (!d) {
    return;
  }

  d->next = sTop;
  d->libHandle = aLibHandle;

  sTop = d;
}

static bool
ReadDependentCB(pathstr_t aDependentLib, bool aDoPreload)
{
  if (aDoPreload) {
    ReadAheadLib(aDependentLib);
  }
  LibHandleType libHandle = GetLibHandle(aDependentLib);
  if (libHandle) {
    AppendDependentLib(libHandle);
  }

  return libHandle;
}

#ifdef XP_WIN
static bool
ReadDependentCB(const char* aDependentLib, bool do_preload)
{
  wchar_t wideDependentLib[MAX_PATH];
  MultiByteToWideChar(CP_UTF8, 0, aDependentLib, -1, wideDependentLib, MAX_PATH);
  return ReadDependentCB(wideDependentLib, do_preload);
}

inline FILE*
TS_tfopen(const char* path, const wchar_t* mode)
{
  wchar_t wPath[MAX_PATH];
  MultiByteToWideChar(CP_UTF8, 0, path, -1, wPath, MAX_PATH);
  return _wfopen(wPath, mode);
}
#else
inline FILE*
TS_tfopen(const char* aPath, const char* aMode)
{
  return fopen(aPath, aMode);
}
#endif

/* RAII wrapper for FILE descriptors */
struct ScopedCloseFileTraits
{
  typedef FILE* type;
  static type empty() { return nullptr; }
  static void release(type aFile)
  {
    if (aFile) {
      fclose(aFile);
    }
  }
};
typedef Scoped<ScopedCloseFileTraits> ScopedCloseFile;

static void
XPCOMGlueUnload()
{
  while (sTop) {
    CloseLibHandle(sTop->libHandle);

    DependentLib* temp = sTop;
    sTop = sTop->next;

    delete temp;
  }
}

#if defined(XP_WIN)
// like strpbrk but finds the *last* char, not the first
static const char*
ns_strrpbrk(const char* string, const char* strCharSet)
{
  const char* found = nullptr;
  for (; *string; ++string) {
    for (const char* search = strCharSet; *search; ++search) {
      if (*search == *string) {
        found = string;
        // Since we're looking for the last char, we save "found"
        // until we're at the end of the string.
      }
    }
  }

  return found;
}
#endif

static GetFrozenFunctionsFunc
XPCOMGlueLoad(const char* aXPCOMFile)
{
  char xpcomDir[MAXPATHLEN];
#ifdef XP_WIN
  const char* lastSlash = ns_strrpbrk(aXPCOMFile, "/\\");
#elif XP_MACOSX
  // On OSX, the dependentlibs.list file lives under Contents/Resources.
  // However, the actual libraries listed in dependentlibs.list live under
  // Contents/MacOS. We want to read the list from Contents/Resources, then
  // load the libraries from Contents/MacOS.
  const char *tempSlash = strrchr(aXPCOMFile, '/');
  size_t tempLen = size_t(tempSlash - aXPCOMFile);
  if (tempLen > MAXPATHLEN) {
    return nullptr;
  }
  char tempBuffer[MAXPATHLEN];
  memcpy(tempBuffer, aXPCOMFile, tempLen);
  tempBuffer[tempLen] = '\0';
  const char *slash = strrchr(tempBuffer, '/');
  tempLen = size_t(slash - tempBuffer);
  const char *lastSlash = aXPCOMFile + tempLen;
#else
  const char* lastSlash = strrchr(aXPCOMFile, '/');
#endif
  char* cursor;
  if (lastSlash) {
    size_t len = size_t(lastSlash - aXPCOMFile);

    if (len > MAXPATHLEN - sizeof(XPCOM_FILE_PATH_SEPARATOR
#ifdef XP_MACOSX
                                  "Resources"
                                  XPCOM_FILE_PATH_SEPARATOR
#endif
                                  XPCOM_DEPENDENT_LIBS_LIST)) {
      return nullptr;
    }
    memcpy(xpcomDir, aXPCOMFile, len);
    strcpy(xpcomDir + len, XPCOM_FILE_PATH_SEPARATOR
#ifdef XP_MACOSX
                           "Resources"
                           XPCOM_FILE_PATH_SEPARATOR
#endif
                           XPCOM_DEPENDENT_LIBS_LIST);
    cursor = xpcomDir + len + 1;
  } else {
    strcpy(xpcomDir, XPCOM_DEPENDENT_LIBS_LIST);
    cursor = xpcomDir;
  }

  if (getenv("MOZ_RUN_GTEST")) {
    strcat(xpcomDir, ".gtest");
  }

  ScopedCloseFile flist;
  flist = TS_tfopen(xpcomDir, READ_TEXTMODE);
  if (!flist) {
    return nullptr;
  }

#ifdef XP_MACOSX
  tempLen = size_t(cursor - xpcomDir);
  if (tempLen > MAXPATHLEN - sizeof("MacOS" XPCOM_FILE_PATH_SEPARATOR) - 1) {
    return nullptr;
  }
  strcpy(cursor, "MacOS" XPCOM_FILE_PATH_SEPARATOR);
  cursor += strlen(cursor);
#endif
  *cursor = '\0';

  char buffer[MAXPATHLEN];

  while (fgets(buffer, sizeof(buffer), flist)) {
    int l = strlen(buffer);

    // ignore empty lines and comments
    if (l == 0 || *buffer == '#') {
      continue;
    }

    // cut the trailing newline, if present
    if (buffer[l - 1] == '\n') {
      buffer[l - 1] = '\0';
    }

    if (l + size_t(cursor - xpcomDir) > MAXPATHLEN) {
      return nullptr;
    }

    strcpy(cursor, buffer);
    if (!ReadDependentCB(xpcomDir, do_preload)) {
      XPCOMGlueUnload();
      return nullptr;
    }
  }

  GetFrozenFunctionsFunc sym =
    (GetFrozenFunctionsFunc)GetSymbol(sTop->libHandle,
                                      "NS_GetFrozenFunctions");

  if (!sym) { // No symbol found.
    XPCOMGlueUnload();
    return nullptr;
  }

  return sym;
}

nsresult
XPCOMGlueLoadXULFunctions(const nsDynamicFunctionLoad* aSymbols)
{
  // We don't null-check sXULLibHandle because this might work even
  // if it is null (same as RTLD_DEFAULT)

  nsresult rv = NS_OK;
  while (aSymbols->functionName) {
    char buffer[512];
    SprintfLiteral(buffer, "%s", aSymbols->functionName);

    *aSymbols->function = (NSFuncPtr)GetSymbol(sTop->libHandle, buffer);
    if (!*aSymbols->function) {
      rv = NS_ERROR_LOSS_OF_SIGNIFICANT_DATA;
    }

    ++aSymbols;
  }
  return rv;
}

void
XPCOMGlueEnablePreload()
{
  do_preload = true;
}

#if defined(MOZ_WIDGET_GTK) && (defined(MOZ_MEMORY) || defined(__FreeBSD__) || defined(__NetBSD__))
#define MOZ_GSLICE_INIT
#endif

#ifdef MOZ_GSLICE_INIT
#include <glib.h>

class GSliceInit {
public:
  GSliceInit() {
    mHadGSlice = bool(getenv("G_SLICE"));
    if (!mHadGSlice) {
      // Disable the slice allocator, since jemalloc already uses similar layout
      // algorithms, and using a sub-allocator tends to increase fragmentation.
      // This must be done before g_thread_init() is called.
      // glib >= 2.36 initializes g_slice as a side effect of its various static
      // initializers, so this needs to happen before glib is loaded, which is
      // this is hooked in XPCOMGlueStartup before libxul is loaded. This
      // relies on the main executable not depending on glib.
      setenv("G_SLICE", "always-malloc", 1);
    }
  }

  ~GSliceInit() {
#if MOZ_WIDGET_GTK == 2
    if (sTop) {
      auto XRE_GlibInit = (void (*)(void)) GetSymbol(sTop->libHandle,
        "XRE_GlibInit");
      // Initialize glib enough for G_SLICE to have an effect before it is unset.
      // unset.
      XRE_GlibInit();
    }
#endif
    if (!mHadGSlice) {
      unsetenv("G_SLICE");
    }
  }

private:
  bool mHadGSlice;
};
#endif

nsresult
XPCOMGlueStartup(const char* aXPCOMFile)
{
#ifdef MOZ_GSLICE_INIT
  GSliceInit gSliceInit;
#endif
  xpcomFunctions.version = XPCOM_GLUE_VERSION;
  xpcomFunctions.size    = sizeof(XPCOMFunctions);

  if (!aXPCOMFile) {
    aXPCOMFile = XPCOM_DLL;
  }

  GetFrozenFunctionsFunc func = XPCOMGlueLoad(aXPCOMFile);
  if (!func) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  nsresult rv = (*func)(&xpcomFunctions, nullptr);
  if (NS_FAILED(rv)) {
    XPCOMGlueUnload();
    return rv;
  }

  return NS_OK;
}

XPCOM_API(nsresult)
NS_InitXPCOM2(nsIServiceManager** aResult,
              nsIFile* aBinDirectory,
              nsIDirectoryServiceProvider* aAppFileLocationProvider)
{
  if (!xpcomFunctions.init) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.init(aResult, aBinDirectory, aAppFileLocationProvider);
}

XPCOM_API(nsresult)
NS_ShutdownXPCOM(nsIServiceManager* aServMgr)
{
  if (!xpcomFunctions.shutdown) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.shutdown(aServMgr);
}

XPCOM_API(nsresult)
NS_GetServiceManager(nsIServiceManager** aResult)
{
  if (!xpcomFunctions.getServiceManager) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.getServiceManager(aResult);
}

XPCOM_API(nsresult)
NS_GetComponentManager(nsIComponentManager** aResult)
{
  if (!xpcomFunctions.getComponentManager) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.getComponentManager(aResult);
}

XPCOM_API(nsresult)
NS_GetComponentRegistrar(nsIComponentRegistrar** aResult)
{
  if (!xpcomFunctions.getComponentRegistrar) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.getComponentRegistrar(aResult);
}

XPCOM_API(nsresult)
NS_GetMemoryManager(nsIMemory** aResult)
{
  if (!xpcomFunctions.getMemoryManager) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.getMemoryManager(aResult);
}

XPCOM_API(nsresult)
NS_NewLocalFile(const nsAString& aPath, bool aFollowLinks, nsIFile** aResult)
{
  if (!xpcomFunctions.newLocalFile) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.newLocalFile(aPath, aFollowLinks, aResult);
}

XPCOM_API(nsresult)
NS_NewNativeLocalFile(const nsACString& aPath, bool aFollowLinks,
                      nsIFile** aResult)
{
  if (!xpcomFunctions.newNativeLocalFile) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.newNativeLocalFile(aPath, aFollowLinks, aResult);
}

XPCOM_API(nsresult)
NS_GetDebug(nsIDebug2** aResult)
{
  if (!xpcomFunctions.getDebug) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.getDebug(aResult);
}


XPCOM_API(nsresult)
NS_StringContainerInit(nsStringContainer& aStr)
{
  if (!xpcomFunctions.stringContainerInit) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.stringContainerInit(aStr);
}

XPCOM_API(nsresult)
NS_StringContainerInit2(nsStringContainer& aStr, const char16_t* aData,
                        uint32_t aDataLength, uint32_t aFlags)
{
  if (!xpcomFunctions.stringContainerInit2) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.stringContainerInit2(aStr, aData, aDataLength, aFlags);
}

XPCOM_API(void)
NS_StringContainerFinish(nsStringContainer& aStr)
{
  if (xpcomFunctions.stringContainerFinish) {
    xpcomFunctions.stringContainerFinish(aStr);
  }
}

XPCOM_API(uint32_t)
NS_StringGetData(const nsAString& aStr, const char16_t** aBuf, bool* aTerm)
{
  if (!xpcomFunctions.stringGetData) {
    *aBuf = nullptr;
    return 0;
  }
  return xpcomFunctions.stringGetData(aStr, aBuf, aTerm);
}

XPCOM_API(uint32_t)
NS_StringGetMutableData(nsAString& aStr, uint32_t aLen, char16_t** aBuf)
{
  if (!xpcomFunctions.stringGetMutableData) {
    *aBuf = nullptr;
    return 0;
  }
  return xpcomFunctions.stringGetMutableData(aStr, aLen, aBuf);
}

XPCOM_API(char16_t*)
NS_StringCloneData(const nsAString& aStr)
{
  if (!xpcomFunctions.stringCloneData) {
    return nullptr;
  }
  return xpcomFunctions.stringCloneData(aStr);
}

XPCOM_API(nsresult)
NS_StringSetData(nsAString& aStr, const char16_t* aBuf, uint32_t aCount)
{
  if (!xpcomFunctions.stringSetData) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  return xpcomFunctions.stringSetData(aStr, aBuf, aCount);
}

XPCOM_API(nsresult)
NS_StringSetDataRange(nsAString& aStr, uint32_t aCutStart, uint32_t aCutLength,
                      const char16_t* aBuf, uint32_t aCount)
{
  if (!xpcomFunctions.stringSetDataRange) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.stringSetDataRange(aStr, aCutStart, aCutLength, aBuf,
                                           aCount);
}

XPCOM_API(nsresult)
NS_StringCopy(nsAString& aDest, const nsAString& aSrc)
{
  if (!xpcomFunctions.stringCopy) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.stringCopy(aDest, aSrc);
}

XPCOM_API(void)
NS_StringSetIsVoid(nsAString& aStr, const bool aIsVoid)
{
  if (xpcomFunctions.stringSetIsVoid) {
    xpcomFunctions.stringSetIsVoid(aStr, aIsVoid);
  }
}

XPCOM_API(bool)
NS_StringGetIsVoid(const nsAString& aStr)
{
  if (!xpcomFunctions.stringGetIsVoid) {
    return false;
  }
  return xpcomFunctions.stringGetIsVoid(aStr);
}

XPCOM_API(nsresult)
NS_CStringContainerInit(nsCStringContainer& aStr)
{
  if (!xpcomFunctions.cstringContainerInit) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringContainerInit(aStr);
}

XPCOM_API(nsresult)
NS_CStringContainerInit2(nsCStringContainer& aStr, const char* aData,
                         uint32_t aDataLength, uint32_t aFlags)
{
  if (!xpcomFunctions.cstringContainerInit2) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringContainerInit2(aStr, aData, aDataLength, aFlags);
}

XPCOM_API(void)
NS_CStringContainerFinish(nsCStringContainer& aStr)
{
  if (xpcomFunctions.cstringContainerFinish) {
    xpcomFunctions.cstringContainerFinish(aStr);
  }
}

XPCOM_API(uint32_t)
NS_CStringGetData(const nsACString& aStr, const char** aBuf, bool* aTerm)
{
  if (!xpcomFunctions.cstringGetData) {
    *aBuf = nullptr;
    return 0;
  }
  return xpcomFunctions.cstringGetData(aStr, aBuf, aTerm);
}

XPCOM_API(uint32_t)
NS_CStringGetMutableData(nsACString& aStr, uint32_t aLen, char** aBuf)
{
  if (!xpcomFunctions.cstringGetMutableData) {
    *aBuf = nullptr;
    return 0;
  }
  return xpcomFunctions.cstringGetMutableData(aStr, aLen, aBuf);
}

XPCOM_API(char*)
NS_CStringCloneData(const nsACString& aStr)
{
  if (!xpcomFunctions.cstringCloneData) {
    return nullptr;
  }
  return xpcomFunctions.cstringCloneData(aStr);
}

XPCOM_API(nsresult)
NS_CStringSetData(nsACString& aStr, const char* aBuf, uint32_t aCount)
{
  if (!xpcomFunctions.cstringSetData) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringSetData(aStr, aBuf, aCount);
}

XPCOM_API(nsresult)
NS_CStringSetDataRange(nsACString& aStr, uint32_t aCutStart,
                       uint32_t aCutLength, const char* aBuf, uint32_t aCount)
{
  if (!xpcomFunctions.cstringSetDataRange) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringSetDataRange(aStr, aCutStart, aCutLength, aBuf,
                                            aCount);
}

XPCOM_API(nsresult)
NS_CStringCopy(nsACString& aDest, const nsACString& aSrc)
{
  if (!xpcomFunctions.cstringCopy) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringCopy(aDest, aSrc);
}

XPCOM_API(void)
NS_CStringSetIsVoid(nsACString& aStr, const bool aIsVoid)
{
  if (xpcomFunctions.cstringSetIsVoid) {
    xpcomFunctions.cstringSetIsVoid(aStr, aIsVoid);
  }
}

XPCOM_API(bool)
NS_CStringGetIsVoid(const nsACString& aStr)
{
  if (!xpcomFunctions.cstringGetIsVoid) {
    return false;
  }
  return xpcomFunctions.cstringGetIsVoid(aStr);
}

XPCOM_API(nsresult)
NS_CStringToUTF16(const nsACString& aSrc, nsCStringEncoding aSrcEncoding,
                  nsAString& aDest)
{
  if (!xpcomFunctions.cstringToUTF16) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.cstringToUTF16(aSrc, aSrcEncoding, aDest);
}

XPCOM_API(nsresult)
NS_UTF16ToCString(const nsAString& aSrc, nsCStringEncoding aDestEncoding,
                  nsACString& aDest)
{
  if (!xpcomFunctions.utf16ToCString) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  return xpcomFunctions.utf16ToCString(aSrc, aDestEncoding, aDest);
}

XPCOM_API(void*)
NS_Alloc(size_t aSize)
{
  if (!xpcomFunctions.allocFunc) {
    return nullptr;
  }
  return xpcomFunctions.allocFunc(aSize);
}

XPCOM_API(void*)
NS_Realloc(void* aPtr, size_t aSize)
{
  if (!xpcomFunctions.reallocFunc) {
    return nullptr;
  }
  return xpcomFunctions.reallocFunc(aPtr, aSize);
}

XPCOM_API(void)
NS_Free(void* aPtr)
{
  if (xpcomFunctions.freeFunc) {
    xpcomFunctions.freeFunc(aPtr);
  }
}

XPCOM_API(void)
NS_DebugBreak(uint32_t aSeverity, const char* aStr, const char* aExpr,
              const char* aFile, int32_t aLine)
{
  if (xpcomFunctions.debugBreakFunc) {
    xpcomFunctions.debugBreakFunc(aSeverity, aStr, aExpr, aFile, aLine);
  }
}

XPCOM_API(void)
NS_LogInit()
{
  if (xpcomFunctions.logInitFunc) {
    xpcomFunctions.logInitFunc();
  }
}

XPCOM_API(void)
NS_LogTerm()
{
  if (xpcomFunctions.logTermFunc) {
    xpcomFunctions.logTermFunc();
  }
}

XPCOM_API(void)
NS_LogAddRef(void* aPtr, nsrefcnt aNewRefCnt,
             const char* aTypeName, uint32_t aInstanceSize)
{
  if (xpcomFunctions.logAddRefFunc)
    xpcomFunctions.logAddRefFunc(aPtr, aNewRefCnt,
                                 aTypeName, aInstanceSize);
}

XPCOM_API(void)
NS_LogRelease(void* aPtr, nsrefcnt aNewRefCnt, const char* aTypeName)
{
  if (xpcomFunctions.logReleaseFunc) {
    xpcomFunctions.logReleaseFunc(aPtr, aNewRefCnt, aTypeName);
  }
}

XPCOM_API(void)
NS_LogCtor(void* aPtr, const char* aTypeName, uint32_t aInstanceSize)
{
  if (xpcomFunctions.logCtorFunc) {
    xpcomFunctions.logCtorFunc(aPtr, aTypeName, aInstanceSize);
  }
}

XPCOM_API(void)
NS_LogDtor(void* aPtr, const char* aTypeName, uint32_t aInstanceSize)
{
  if (xpcomFunctions.logDtorFunc) {
    xpcomFunctions.logDtorFunc(aPtr, aTypeName, aInstanceSize);
  }
}

XPCOM_API(void)
NS_LogCOMPtrAddRef(void* aCOMPtr, nsISupports* aObject)
{
  if (xpcomFunctions.logCOMPtrAddRefFunc) {
    xpcomFunctions.logCOMPtrAddRefFunc(aCOMPtr, aObject);
  }
}

XPCOM_API(void)
NS_LogCOMPtrRelease(void* aCOMPtr, nsISupports* aObject)
{
  if (xpcomFunctions.logCOMPtrReleaseFunc) {
    xpcomFunctions.logCOMPtrReleaseFunc(aCOMPtr, aObject);
  }
}

XPCOM_API(nsresult)
NS_GetXPTCallStub(REFNSIID aIID, nsIXPTCProxy* aOuter,
                  nsISomeInterface** aStub)
{
  if (!xpcomFunctions.getXPTCallStubFunc) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  return xpcomFunctions.getXPTCallStubFunc(aIID, aOuter, aStub);
}

XPCOM_API(void)
NS_DestroyXPTCallStub(nsISomeInterface* aStub)
{
  if (xpcomFunctions.destroyXPTCallStubFunc) {
    xpcomFunctions.destroyXPTCallStubFunc(aStub);
  }
}

XPCOM_API(nsresult)
NS_InvokeByIndex(nsISupports* aThat, uint32_t aMethodIndex,
                 uint32_t aParamCount, nsXPTCVariant* aParams)
{
  if (!xpcomFunctions.invokeByIndexFunc) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  return xpcomFunctions.invokeByIndexFunc(aThat, aMethodIndex,
                                          aParamCount, aParams);
}

XPCOM_API(bool)
NS_CycleCollectorSuspect(nsISupports* aObj)
{
  if (!xpcomFunctions.cycleSuspectFunc) {
    return false;
  }

  return xpcomFunctions.cycleSuspectFunc(aObj);
}

XPCOM_API(bool)
NS_CycleCollectorForget(nsISupports* aObj)
{
  if (!xpcomFunctions.cycleForgetFunc) {
    return false;
  }

  return xpcomFunctions.cycleForgetFunc(aObj);
}

XPCOM_API(nsPurpleBufferEntry*)
NS_CycleCollectorSuspect2(void* aObj, nsCycleCollectionParticipant* aCp)
{
  if (!xpcomFunctions.cycleSuspect2Func) {
    return nullptr;
  }

  return xpcomFunctions.cycleSuspect2Func(aObj, aCp);
}

XPCOM_API(void)
NS_CycleCollectorSuspect3(void* aObj, nsCycleCollectionParticipant* aCp,
                          nsCycleCollectingAutoRefCnt* aRefCnt,
                          bool* aShouldDelete)
{
  if (xpcomFunctions.cycleSuspect3Func) {
    xpcomFunctions.cycleSuspect3Func(aObj, aCp, aRefCnt, aShouldDelete);
  }
}

XPCOM_API(bool)
NS_CycleCollectorForget2(nsPurpleBufferEntry* aEntry)
{
  if (!xpcomFunctions.cycleForget2Func) {
    return false;
  }

  return xpcomFunctions.cycleForget2Func(aEntry);
}
