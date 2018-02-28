/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ChromiumCDMAdapter.h"
#include "content_decryption_module.h"
#include "content_decryption_module_ext.h"
#include "VideoUtils.h"
#include "gmp-api/gmp-entrypoints.h"
#include "gmp-api/gmp-decryption.h"
#include "gmp-api/gmp-video-codec.h"
#include "gmp-api/gmp-platform.h"
#include "WidevineUtils.h"
#include "GMPLog.h"
#include "mozilla/Move.h"

#ifdef XP_WIN
#include "WinUtils.h"
#include "nsWindowsDllInterceptor.h"
#include <windows.h>
#include <strsafe.h>
#include <unordered_map>
#include <vector>
#else
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#endif

// Declared in WidevineAdapter.cpp.
extern const GMPPlatformAPI* sPlatform;

namespace mozilla {

#ifdef XP_WIN
static void
InitializeHooks();
#endif

ChromiumCDMAdapter::ChromiumCDMAdapter(nsTArray<Pair<nsCString, nsCString>>&& aHostPathPairs)
{
#ifdef XP_WIN
  InitializeHooks();
#endif
  PopulateHostFiles(Move(aHostPathPairs));
}

void
ChromiumCDMAdapter::SetAdaptee(PRLibrary* aLib)
{
  mLib = aLib;
}

void*
ChromiumCdmHost(int aHostInterfaceVersion, void* aUserData)
{
  CDM_LOG("ChromiumCdmHostFunc(%d, %p)", aHostInterfaceVersion, aUserData);
  if (aHostInterfaceVersion != cdm::Host_8::kVersion) {
    return nullptr;
  }
  return static_cast<cdm::Host_8*>(aUserData);
}

#define STRINGIFY(s) _STRINGIFY(s)
#define _STRINGIFY(s) #s

#ifdef MOZILLA_OFFICIAL
static cdm::HostFile
TakeToCDMHostFile(HostFileData& aHostFileData)
{
  return cdm::HostFile(aHostFileData.mBinary.Path().get(),
                       aHostFileData.mBinary.TakePlatformFile(),
                       aHostFileData.mSig.TakePlatformFile());
}
#endif

GMPErr
ChromiumCDMAdapter::GMPInit(const GMPPlatformAPI* aPlatformAPI)
{
  CDM_LOG("ChromiumCDMAdapter::GMPInit");
  sPlatform = aPlatformAPI;
  if (!mLib) {
    return GMPGenericErr;
  }

#ifdef MOZILLA_OFFICIAL
  // Note: we must call the VerifyCdmHost_0 function if it's present before
  // we call the initialize function.
  auto verify = reinterpret_cast<decltype(::VerifyCdmHost_0)*>(
    PR_FindFunctionSymbol(mLib, STRINGIFY(VerifyCdmHost_0)));
  if (verify) {
    nsTArray<cdm::HostFile> files;
    for (HostFileData& hostFile : mHostFiles) {
      files.AppendElement(TakeToCDMHostFile(hostFile));
    }
    bool result = verify(files.Elements(), files.Length());
    GMP_LOG("%s VerifyCdmHost_0 returned %d", __func__, result);
  }
#endif

  auto init = reinterpret_cast<decltype(::INITIALIZE_CDM_MODULE)*>(
    PR_FindFunctionSymbol(mLib, STRINGIFY(INITIALIZE_CDM_MODULE)));
  if (!init) {
    return GMPGenericErr;
  }

  CDM_LOG(STRINGIFY(INITIALIZE_CDM_MODULE)"()");
  init();

  return GMPNoErr;
}

GMPErr
ChromiumCDMAdapter::GMPGetAPI(const char* aAPIName,
                              void* aHostAPI,
                              void** aPluginAPI,
                              uint32_t aDecryptorId)
{
  CDM_LOG("ChromiumCDMAdapter::GMPGetAPI(%s, 0x%p, 0x%p, %u) this=0x%p",
          aAPIName,
          aHostAPI,
          aPluginAPI,
          aDecryptorId,
          this);
  if (!strcmp(aAPIName, CHROMIUM_CDM_API)) {
    auto create = reinterpret_cast<decltype(::CreateCdmInstance)*>(
      PR_FindFunctionSymbol(mLib, "CreateCdmInstance"));
    if (!create) {
      CDM_LOG("ChromiumCDMAdapter::GMPGetAPI(%s, 0x%p, 0x%p, %u) this=0x%p "
              "FAILED to find CreateCdmInstance",
              aAPIName,
              aHostAPI,
              aPluginAPI,
              aDecryptorId,
              this);
      return GMPGenericErr;
    }

    auto cdm = reinterpret_cast<cdm::ContentDecryptionModule_8*>(
      create(cdm::ContentDecryptionModule_8::kVersion,
             kEMEKeySystemWidevine.get(),
             kEMEKeySystemWidevine.Length(),
             &ChromiumCdmHost,
             aHostAPI));
    if (!cdm) {
      CDM_LOG("ChromiumCDMAdapter::GMPGetAPI(%s, 0x%p, 0x%p, %u) this=0x%p "
              "FAILED to create cdm",
              aAPIName,
              aHostAPI,
              aPluginAPI,
              aDecryptorId,
              this);
      return GMPGenericErr;
    }
    CDM_LOG("cdm: 0x%p", cdm);
    *aPluginAPI = cdm;
  }
  return *aPluginAPI ? GMPNoErr : GMPNotImplementedErr;
}

void
ChromiumCDMAdapter::GMPShutdown()
{
  CDM_LOG("ChromiumCDMAdapter::GMPShutdown()");

  decltype(::DeinitializeCdmModule)* deinit;
  deinit = (decltype(deinit))(PR_FindFunctionSymbol(mLib, "DeinitializeCdmModule"));
  if (deinit) {
    CDM_LOG("DeinitializeCdmModule()");
    deinit();
  }
}

/* static */
bool
ChromiumCDMAdapter::Supports(int32_t aModuleVersion,
                             int32_t aInterfaceVersion,
                             int32_t aHostVersion)
{
  return aModuleVersion == CDM_MODULE_VERSION &&
         aInterfaceVersion == cdm::ContentDecryptionModule_8::kVersion &&
         aHostVersion == cdm::Host_8::kVersion;
}

#ifdef XP_WIN

static WindowsDllInterceptor sKernel32Intercept;

typedef DWORD(WINAPI* QueryDosDeviceWFnPtr)(_In_opt_ LPCWSTR lpDeviceName,
                                            _Out_ LPWSTR lpTargetPath,
                                            _In_ DWORD ucchMax);

static QueryDosDeviceWFnPtr sOriginalQueryDosDeviceWFnPtr = nullptr;

static std::unordered_map<std::wstring, std::wstring>* sDeviceNames = nullptr;

DWORD WINAPI
QueryDosDeviceWHook(LPCWSTR lpDeviceName, LPWSTR lpTargetPath, DWORD ucchMax)
{
  if (!sDeviceNames) {
    return 0;
  }
  std::wstring name = std::wstring(lpDeviceName);
  auto iter = sDeviceNames->find(name);
  if (iter == sDeviceNames->end()) {
    return 0;
  }
  const std::wstring& device = iter->second;
  if (device.size() + 1 > ucchMax) {
    return 0;
  }
  PodCopy(lpTargetPath, device.c_str(), device.size());
  lpTargetPath[device.size()] = 0;
  GMP_LOG("QueryDosDeviceWHook %S -> %S", lpDeviceName, lpTargetPath);
  return name.size();
}

static std::vector<std::wstring>
GetDosDeviceNames()
{
  std::vector<std::wstring> v;
  std::vector<wchar_t> buf;
  buf.resize(1024);
  DWORD rv = GetLogicalDriveStringsW(buf.size(), buf.data());
  if (rv == 0 || rv > buf.size()) {
    return v;
  }

  // buf will be a list of null terminated strings, with the last string
  // being 0 length.
  const wchar_t* p = buf.data();
  const wchar_t* end = &buf.back();
  size_t l;
  while (p < end && (l = wcsnlen_s(p, end - p)) > 0) {
    // The string is of the form "C:\". We need to strip off the trailing
    // backslash.
    std::wstring drive = std::wstring(p, p + l);
    if (drive.back() == '\\') {
      drive.erase(drive.end() - 1);
    }
    v.push_back(move(drive));
    p += l + 1;
  }
  return v;
}

static std::wstring
GetDeviceMapping(const std::wstring& aDosDeviceName)
{
  wchar_t buf[MAX_PATH] = { 0 };
  DWORD rv = QueryDosDeviceW(aDosDeviceName.c_str(), buf, MAX_PATH);
  if (rv == 0) {
    return std::wstring(L"");
  }
  return std::wstring(buf, buf + rv);
}

static void
InitializeHooks()
{
  static bool initialized = false;
  if (initialized) {
    return;
  }
  initialized = true;
  sDeviceNames = new std::unordered_map<std::wstring, std::wstring>();
  for (const std::wstring& name : GetDosDeviceNames()) {
    sDeviceNames->emplace(name, GetDeviceMapping(name));
  }

  sKernel32Intercept.Init("kernelbase.dll");
  sKernel32Intercept.AddHook("QueryDosDeviceW",
                             reinterpret_cast<intptr_t>(QueryDosDeviceWHook),
                             (void**)(&sOriginalQueryDosDeviceWFnPtr));
}
#endif

HostFile::HostFile(HostFile&& aOther)
  : mPath(aOther.mPath)
  , mFile(aOther.TakePlatformFile())
{
}

HostFile::~HostFile()
{
  if (mFile != cdm::kInvalidPlatformFile) {
#ifdef XP_WIN
    CloseHandle(mFile);
#else
    close(mFile);
#endif
    mFile = cdm::kInvalidPlatformFile;
  }
}

#ifdef XP_WIN
HostFile::HostFile(const nsCString& aPath)
  : mPath(NS_ConvertUTF8toUTF16(aPath))
{
  HANDLE handle = CreateFileW(mPath.get(),
                              GENERIC_READ,
                              FILE_SHARE_READ | FILE_SHARE_WRITE,
                              NULL,
                              OPEN_EXISTING,
                              0,
                              NULL);
  mFile = (handle == INVALID_HANDLE_VALUE) ? cdm::kInvalidPlatformFile : handle;
}
#endif

#ifndef XP_WIN
HostFile::HostFile(const nsCString& aPath)
  : mPath(aPath)
{
  // Note: open() returns -1 on failure; i.e. kInvalidPlatformFile.
  mFile = open(aPath.get(), O_RDONLY);
}
#endif

cdm::PlatformFile
HostFile::TakePlatformFile()
{
  cdm::PlatformFile f = mFile;
  mFile = cdm::kInvalidPlatformFile;
  return f;
}

void
ChromiumCDMAdapter::PopulateHostFiles(nsTArray<Pair<nsCString, nsCString>>&& aHostPathPairs)
{
  for (const auto& pair : aHostPathPairs) {
    mHostFiles.AppendElement(
      HostFileData(mozilla::HostFile(pair.first()),
                   mozilla::HostFile(pair.second())));
  }
}

} // namespace mozilla
