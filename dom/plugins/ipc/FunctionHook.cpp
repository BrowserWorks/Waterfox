/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/TextUtils.h"

#include "FunctionHook.h"
#include "FunctionBroker.h"
#include "nsClassHashtable.h"
#include "mozilla/ClearOnShutdown.h"

#if defined(XP_WIN)
#  include <shlobj.h>
#  include "PluginModuleChild.h"
#endif

namespace mozilla {
namespace plugins {

StaticAutoPtr<FunctionHookArray> FunctionHook::sFunctionHooks;

bool AlwaysHook(int) { return true; }

FunctionHookArray* FunctionHook::GetHooks() {
  if (sFunctionHooks) {
    return sFunctionHooks;
  }

  // sFunctionHooks is the StaticAutoPtr to the singleton array of FunctionHook
  // objects.  We free it by clearing the StaticAutoPtr on shutdown.
  sFunctionHooks = new FunctionHookArray();
  ClearOnShutdown(&sFunctionHooks);
  sFunctionHooks->SetLength(ID_FunctionHookCount);

  AddFunctionHooks(*sFunctionHooks);
  AddBrokeredFunctionHooks(*sFunctionHooks);
  return sFunctionHooks;
}

void FunctionHook::HookFunctions(int aQuirks) {
  MOZ_ASSERT(XRE_GetProcessType() == GeckoProcessType_Plugin);
  FunctionHookArray* hooks = FunctionHook::GetHooks();
  MOZ_ASSERT(hooks);
  for (size_t i = 0; i < hooks->Length(); ++i) {
    FunctionHook* mhb = hooks->ElementAt(i);
    // Check that the FunctionHook array is in the same order as the
    // FunctionHookId enum.
    MOZ_ASSERT((size_t)mhb->FunctionId() == i);
    mhb->Register(aQuirks);
  }
}

#if defined(XP_WIN)

// This cache is created when a DLL is registered with a FunctionHook.
// It is cleared on a call to ClearDllInterceptorCache().  It
// must be freed before exit to avoid leaks.
typedef nsClassHashtable<nsStringHashKey, WindowsDllInterceptor>
    DllInterceptors;
DllInterceptors* sDllInterceptorCache = nullptr;

WindowsDllInterceptor* FunctionHook::GetDllInterceptorFor(
    const char* aModuleName) {
  if (!sDllInterceptorCache) {
    sDllInterceptorCache = new DllInterceptors();
  }

  MOZ_ASSERT(IsAsciiNullTerminated(aModuleName),
             "Non-ASCII module names are not supported");
  NS_ConvertASCIItoUTF16 moduleName(aModuleName);

  WindowsDllInterceptor* ret = sDllInterceptorCache->LookupOrAdd(moduleName);
  MOZ_ASSERT(ret);
  ret->Init(moduleName.get());
  return ret;
}

void FunctionHook::ClearDllInterceptorCache() {
  delete sDllInterceptorCache;
  sDllInterceptorCache = nullptr;
}

/* GetWindowInfo */

typedef BasicFunctionHook<ID_GetWindowInfo, decltype(GetWindowInfo)>
    GetWindowInfoFH;

template <>
ShouldHookFunc* const GetWindowInfoFH::mShouldHook =
    &CheckQuirks<QUIRK_FLASH_HOOK_GETWINDOWINFO>;

static const wchar_t* kWaterfoxWindowClass = L"WaterfoxWindowClass";
static HWND sBrowserHwnd = nullptr;

BOOL WINAPI GetWindowInfoHook(HWND hWnd, PWINDOWINFO pwi) {
  if (!pwi) {
    return FALSE;
  }

  MOZ_ASSERT(ID_GetWindowInfo < FunctionHook::GetHooks()->Length());
  GetWindowInfoFH* functionHook = static_cast<GetWindowInfoFH*>(
      FunctionHook::GetHooks()->ElementAt(ID_GetWindowInfo));
  if (!functionHook->OriginalFunction()) {
    NS_ASSERTION(FALSE, "Something is horribly wrong in PHGetWindowInfoHook!");
    return FALSE;
  }

  if (!sBrowserHwnd) {
    wchar_t szClass[20];
    // GetClassNameW returns the length it copied w/o null terminator.
    // Therefore, if the name and null-terminator fit then it returns a
    // value less than the buffer's length.
    int nameLen = GetClassNameW(hWnd, szClass, ArrayLength(szClass));
    if ((nameLen < (int)ArrayLength(szClass)) &&
        !wcscmp(szClass, kWaterfoxWindowClass)) {
      sBrowserHwnd = hWnd;
    }
  }

  // Oddity: flash does strange rect comparisons for mouse input destined for
  // it's internal settings window. Post removing sub widgets for tabs, touch
  // this up so they get the rect they expect.
  // XXX potentially tie this to a specific major version?
  typedef BOOL(WINAPI * GetWindowInfoPtr)(HWND hwnd, PWINDOWINFO pwi);
  GetWindowInfoPtr gwiFunc =
      static_cast<GetWindowInfoPtr>(functionHook->OriginalFunction());
  BOOL result = gwiFunc(hWnd, pwi);
  if (sBrowserHwnd && sBrowserHwnd == hWnd) {
    pwi->rcWindow = pwi->rcClient;
  }
  return result;
}

/* PrintDlgW */

typedef BasicFunctionHook<ID_PrintDlgW, decltype(PrintDlgW)> PrintDlgWFH;

template <>
ShouldHookFunc* const PrintDlgWFH::mShouldHook =
    &CheckQuirks<QUIRK_FLASH_HOOK_PRINTDLGW>;

BOOL WINAPI PrintDlgWHook(LPPRINTDLGW aDlg) {
  // Zero out the HWND supplied by the plugin.  We are sacrificing window
  // parentage for the ability to run in the NPAPI sandbox.
  HWND hwnd = aDlg->hwndOwner;
  aDlg->hwndOwner = 0;
  MOZ_ASSERT(ID_PrintDlgW < FunctionHook::GetHooks()->Length());
  PrintDlgWFH* functionHook = static_cast<PrintDlgWFH*>(
      FunctionHook::GetHooks()->ElementAt(ID_PrintDlgW));
  MOZ_ASSERT(functionHook);
  BOOL ret = functionHook->OriginalFunction()(aDlg);
  aDlg->hwndOwner = hwnd;
  return ret;
}

// Hooking CreateFileW for protected-mode magic
static WindowsDllInterceptor sKernel32Intercept;
typedef HANDLE(WINAPI* CreateFileWPtr)(LPCWSTR aFname, DWORD aAccess,
                                       DWORD aShare,
                                       LPSECURITY_ATTRIBUTES aSecurity,
                                       DWORD aCreation, DWORD aFlags,
                                       HANDLE aFTemplate);
static WindowsDllInterceptor::FuncHookType<CreateFileWPtr> sCreateFileWStub;
typedef HANDLE(WINAPI* CreateFileAPtr)(LPCSTR aFname, DWORD aAccess,
                                       DWORD aShare,
                                       LPSECURITY_ATTRIBUTES aSecurity,
                                       DWORD aCreation, DWORD aFlags,
                                       HANDLE aFTemplate);
static WindowsDllInterceptor::FuncHookType<CreateFileAPtr> sCreateFileAStub;

// Windows 8 RTM (kernelbase's version is 6.2.9200.16384) doesn't call
// CreateFileW from CreateFileA.
// So we hook CreateFileA too to use CreateFileW hook.
static HANDLE WINAPI CreateFileAHookFn(LPCSTR aFname, DWORD aAccess,
                                       DWORD aShare,
                                       LPSECURITY_ATTRIBUTES aSecurity,
                                       DWORD aCreation, DWORD aFlags,
                                       HANDLE aFTemplate) {
  while (true) {  // goto out
    // Our hook is for mms.cfg into \Windows\System32\Macromed\Flash
    // We don't require supporting too long path.
    WCHAR unicodeName[MAX_PATH];
    size_t len = strlen(aFname);

    if (len >= MAX_PATH) {
      break;
    }

    // We call to CreateFileW for workaround of Windows 8 RTM
    int newLen = MultiByteToWideChar(CP_ACP, MB_ERR_INVALID_CHARS, aFname, len,
                                     unicodeName, MAX_PATH);
    if (newLen == 0 || newLen >= MAX_PATH) {
      break;
    }
    unicodeName[newLen] = '\0';

    return CreateFileW(unicodeName, aAccess, aShare, aSecurity, aCreation,
                       aFlags, aFTemplate);
  }

  return sCreateFileAStub(aFname, aAccess, aShare, aSecurity, aCreation, aFlags,
                          aFTemplate);
}

static bool GetLocalLowTempPath(size_t aLen, LPWSTR aPath) {
  NS_NAMED_LITERAL_STRING(tempname, "\\Temp");
  LPWSTR path;
  if (SUCCEEDED(
          SHGetKnownFolderPath(FOLDERID_LocalAppDataLow, 0, nullptr, &path))) {
    if (wcslen(path) + tempname.Length() < aLen) {
      wcscpy(aPath, path);
      wcscat(aPath, tempname.get());
      CoTaskMemFree(path);
      return true;
    }
    CoTaskMemFree(path);
  }

  // XP doesn't support SHGetKnownFolderPath and LocalLow
  if (!GetTempPathW(aLen, aPath)) {
    return false;
  }
  return true;
}

HANDLE WINAPI CreateFileWHookFn(LPCWSTR aFname, DWORD aAccess, DWORD aShare,
                                LPSECURITY_ATTRIBUTES aSecurity,
                                DWORD aCreation, DWORD aFlags,
                                HANDLE aFTemplate) {
  static const WCHAR kConfigFile[] = L"mms.cfg";
  static const size_t kConfigLength = ArrayLength(kConfigFile) - 1;

  while (true) {  // goto out, in sheep's clothing
    size_t len = wcslen(aFname);
    if (len < kConfigLength) {
      break;
    }
    if (wcscmp(aFname + len - kConfigLength, kConfigFile) != 0) {
      break;
    }

    // This is the config file we want to rewrite
    WCHAR tempPath[MAX_PATH + 1];
    if (GetLocalLowTempPath(MAX_PATH, tempPath) == 0) {
      break;
    }
    WCHAR tempFile[MAX_PATH + 1];
    if (GetTempFileNameW(tempPath, L"fx", 0, tempFile) == 0) {
      break;
    }
    HANDLE replacement = sCreateFileWStub(
        tempFile, GENERIC_READ | GENERIC_WRITE, aShare, aSecurity,
        TRUNCATE_EXISTING, FILE_ATTRIBUTE_TEMPORARY | FILE_FLAG_DELETE_ON_CLOSE,
        nullptr);
    if (replacement == INVALID_HANDLE_VALUE) {
      break;
    }

    HANDLE original = sCreateFileWStub(aFname, aAccess, aShare, aSecurity,
                                       aCreation, aFlags, aFTemplate);
    if (original != INVALID_HANDLE_VALUE) {
      // copy original to replacement
      static const size_t kBufferSize = 1024;
      char buffer[kBufferSize];
      DWORD bytes;
      while (ReadFile(original, buffer, kBufferSize, &bytes, NULL)) {
        if (bytes == 0) {
          break;
        }
        DWORD wbytes;
        WriteFile(replacement, buffer, bytes, &wbytes, NULL);
        if (bytes < kBufferSize) {
          break;
        }
      }
      CloseHandle(original);
    }
    static const char kSettingString[] = "\nProtectedMode=0\n";
    DWORD wbytes;
    WriteFile(replacement, static_cast<const void*>(kSettingString),
              sizeof(kSettingString) - 1, &wbytes, NULL);
    SetFilePointer(replacement, 0, NULL, FILE_BEGIN);
    return replacement;
  }
  return sCreateFileWStub(aFname, aAccess, aShare, aSecurity, aCreation, aFlags,
                          aFTemplate);
}

void FunctionHook::HookProtectedMode() {
  // Legacy code.  Uses the nsWindowsDLLInterceptor directly instead of
  // using the FunctionHook
  sKernel32Intercept.Init("kernel32.dll");
  MOZ_ASSERT(XRE_GetProcessType() == GeckoProcessType_Plugin);
  sCreateFileWStub.Set(sKernel32Intercept, "CreateFileW", &CreateFileWHookFn);
  sCreateFileAStub.Set(sKernel32Intercept, "CreateFileA", &CreateFileAHookFn);
}

#  if defined(MOZ_SANDBOX)

/* GetFileAttributesW */

typedef BasicFunctionHook<ID_GetFileAttributesW, decltype(GetFileAttributesW)>
    GetFileAttributesWFH;

DWORD WINAPI GetFileAttributesWHook(LPCWSTR aFilename) {
  MOZ_ASSERT(ID_GetFileAttributesW < FunctionHook::GetHooks()->Length());
  GetFileAttributesWFH* functionHook = static_cast<GetFileAttributesWFH*>(
      FunctionHook::GetHooks()->ElementAt(ID_GetFileAttributesW));
  if (!functionHook->OriginalFunction()) {
    NS_ASSERTION(FALSE,
                 "Something is horribly wrong in GetFileAttributesWHook!");
    return FALSE;
  }

  DWORD ret = functionHook->OriginalFunction()(aFilename);
  if (ret != INVALID_FILE_ATTRIBUTES) {
    return ret;
  }

  // If aFilename is a parent of PluginModuleChild::GetFlashRoamingPath then
  // assume it was blocked by the sandbox and just report it as a plain
  // directory.
  size_t len = wcslen(aFilename);
  std::wstring roamingPath = PluginModuleChild::GetFlashRoamingPath();
  bool isParent = (len > 0) && (aFilename[len - 1] == L'\\') &&
                  (_wcsnicmp(aFilename, roamingPath.c_str(), len) == 0);
  if (!isParent) {
    return ret;
  }
  return FILE_ATTRIBUTE_DIRECTORY;
}

#  endif  // defined(MOZ_SANDBOX)

#endif  // defined(XP_WIN)

#define FUN_HOOK(x) static_cast<FunctionHook*>(x)

void FunctionHook::AddFunctionHooks(FunctionHookArray& aHooks) {
  // We transfer ownership of the FunctionHook objects to the array.
#if defined(XP_WIN)
  aHooks[ID_GetWindowInfo] = FUN_HOOK(new GetWindowInfoFH(
      "user32.dll", "GetWindowInfo", &GetWindowInfo, &GetWindowInfoHook));
  aHooks[ID_PrintDlgW] = FUN_HOOK(
      new PrintDlgWFH("comdlg32.dll", "PrintDlgW", &PrintDlgW, PrintDlgWHook));
#  if defined(MOZ_SANDBOX)
  aHooks[ID_GetFileAttributesW] = FUN_HOOK(
      new GetFileAttributesWFH("kernel32.dll", "GetFileAttributesW",
                               &GetFileAttributesW, &GetFileAttributesWHook));
#  endif  // defined(MOZ_SANDBOX)
#endif    // defined(XP_WIN)
}

#undef FUN_HOOK

}  // namespace plugins
}  // namespace mozilla
