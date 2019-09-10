/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"

#include "nsSystemInfo.h"
#include "prsystem.h"
#include "prio.h"
#include "mozilla/SSE.h"
#include "mozilla/arm.h"
#include "mozilla/Sprintf.h"

#ifdef XP_WIN
#  include <comutil.h>
#  include <time.h>
#  ifndef __MINGW32__
#    include <iwscapi.h>
#  endif  // __MINGW32__
#  include <windows.h>
#  include <winioctl.h>
#  ifndef __MINGW32__
#    include <wscapi.h>
#  endif  // __MINGW32__
#  include "base/scoped_handle_win.h"
#  include "nsAppDirectoryServiceDefs.h"
#  include "nsDirectoryServiceDefs.h"
#  include "nsDirectoryServiceUtils.h"
#  include "nsIObserverService.h"
#  include "nsWindowsHelpers.h"

#endif

#ifdef XP_MACOSX
#  include "MacHelpers.h"
#endif

#ifdef MOZ_WIDGET_GTK
#  include <gtk/gtk.h>
#  include <dlfcn.h>
#endif

#if defined(XP_LINUX) && !defined(ANDROID)
#  include <unistd.h>
#  include <fstream>
#  include "mozilla/Tokenizer.h"
#  include "nsCharSeparatedTokenizer.h"

#  include <map>
#  include <string>
#endif

#ifdef MOZ_WIDGET_ANDROID
#  include "AndroidBuild.h"
#  include "GeneratedJNIWrappers.h"
#  include "mozilla/jni/Utils.h"
#endif

#ifdef XP_MACOSX
#  include <sys/sysctl.h>
#endif

#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
#  include "mozilla/SandboxInfo.h"
#endif

// Slot for NS_InitXPCOM to pass information to nsSystemInfo::Init.
// Only set to nonzero (potentially) if XP_UNIX.  On such systems, the
// system call to discover the appropriate value is not thread-safe,
// so we must call it before going multithreaded, but nsSystemInfo::Init
// only happens well after that point.
uint32_t nsSystemInfo::gUserUmask = 0;

using namespace mozilla::dom;

#if defined(XP_LINUX) && !defined(ANDROID)
static void SimpleParseKeyValuePairs(
    const std::string& aFilename,
    std::map<nsCString, nsCString>& aKeyValuePairs) {
  std::ifstream input(aFilename.c_str());
  for (std::string line; std::getline(input, line);) {
    nsAutoCString key, value;

    nsCCharSeparatedTokenizer tokens(nsDependentCString(line.c_str()), ':');
    if (tokens.hasMoreTokens()) {
      key = tokens.nextToken();
      if (tokens.hasMoreTokens()) {
        value = tokens.nextToken();
      }
      // We want the value even if there was just one token, to cover the
      // case where we had the key, and the value was blank (seems to be
      // a valid scenario some files.)
      aKeyValuePairs[key] = value;
    }
  }
}
#endif

#if defined(XP_WIN)
namespace {
nsresult GetHDDInfo(const char* aSpecialDirName, nsAutoCString& aModel,
                    nsAutoCString& aRevision, nsAutoCString& aType) {
  aModel.Truncate();
  aRevision.Truncate();
  aType.Truncate();

  nsCOMPtr<nsIFile> profDir;
  nsresult rv =
      NS_GetSpecialDirectory(aSpecialDirName, getter_AddRefs(profDir));
  NS_ENSURE_SUCCESS(rv, rv);
  nsAutoString profDirPath;
  rv = profDir->GetPath(profDirPath);
  NS_ENSURE_SUCCESS(rv, rv);
  wchar_t volumeMountPoint[MAX_PATH] = {L'\\', L'\\', L'.', L'\\'};
  const size_t PREFIX_LEN = 4;
  if (!::GetVolumePathNameW(
          profDirPath.get(), volumeMountPoint + PREFIX_LEN,
          mozilla::ArrayLength(volumeMountPoint) - PREFIX_LEN)) {
    return NS_ERROR_UNEXPECTED;
  }
  size_t volumeMountPointLen = wcslen(volumeMountPoint);
  // Since we would like to open a drive and not a directory, we need to
  // remove any trailing backslash. A drive handle is valid for
  // DeviceIoControl calls, a directory handle is not.
  if (volumeMountPoint[volumeMountPointLen - 1] == L'\\') {
    volumeMountPoint[volumeMountPointLen - 1] = L'\0';
  }
  ScopedHandle handle(::CreateFileW(volumeMountPoint, 0,
                                    FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr,
                                    OPEN_EXISTING, 0, nullptr));
  if (!handle.IsValid()) {
    return NS_ERROR_UNEXPECTED;
  }
  STORAGE_PROPERTY_QUERY queryParameters = {StorageDeviceProperty,
                                            PropertyStandardQuery};
  STORAGE_DEVICE_DESCRIPTOR outputHeader = {sizeof(STORAGE_DEVICE_DESCRIPTOR)};
  DWORD bytesRead = 0;
  if (!::DeviceIoControl(handle, IOCTL_STORAGE_QUERY_PROPERTY, &queryParameters,
                         sizeof(queryParameters), &outputHeader,
                         sizeof(outputHeader), &bytesRead, nullptr)) {
    return NS_ERROR_FAILURE;
  }
  PSTORAGE_DEVICE_DESCRIPTOR deviceOutput =
      (PSTORAGE_DEVICE_DESCRIPTOR)malloc(outputHeader.Size);
  if (!::DeviceIoControl(handle, IOCTL_STORAGE_QUERY_PROPERTY, &queryParameters,
                         sizeof(queryParameters), deviceOutput,
                         outputHeader.Size, &bytesRead, nullptr)) {
    free(deviceOutput);
    return NS_ERROR_FAILURE;
  }

  queryParameters.PropertyId = StorageDeviceTrimProperty;
  bytesRead = 0;
  bool isSSD = false;
  DEVICE_TRIM_DESCRIPTOR trimDescriptor = {sizeof(DEVICE_TRIM_DESCRIPTOR)};
  if (::DeviceIoControl(handle, IOCTL_STORAGE_QUERY_PROPERTY, &queryParameters,
                        sizeof(queryParameters), &trimDescriptor,
                        sizeof(trimDescriptor), &bytesRead, nullptr)) {
    if (trimDescriptor.TrimEnabled) {
      isSSD = true;
    }
  }

  if (isSSD) {
    // Get Seek Penalty
    queryParameters.PropertyId = StorageDeviceSeekPenaltyProperty;
    bytesRead = 0;
    DEVICE_SEEK_PENALTY_DESCRIPTOR seekPenaltyDescriptor = {
      sizeof(DEVICE_SEEK_PENALTY_DESCRIPTOR)};
    if (::DeviceIoControl(handle, IOCTL_STORAGE_QUERY_PROPERTY, &queryParameters,
          sizeof(queryParameters), &seekPenaltyDescriptor,
          sizeof(seekPenaltyDescriptor), &bytesRead, nullptr)) {
      // It is possible that the disk has TrimEnabled, but also IncursSeekPenalty;
      // In this case, this is an HDD
      if (seekPenaltyDescriptor.IncursSeekPenalty) {
        isSSD = false;
      }
    }
  }

  // Some HDDs are including product ID info in the vendor field. Since PNP
  // IDs include vendor info and product ID concatenated together, we'll do
  // that here and interpret the result as a unique ID for the HDD model.
  if (deviceOutput->VendorIdOffset) {
    aModel =
        reinterpret_cast<char*>(deviceOutput) + deviceOutput->VendorIdOffset;
  }
  if (deviceOutput->ProductIdOffset) {
    aModel +=
        reinterpret_cast<char*>(deviceOutput) + deviceOutput->ProductIdOffset;
  }
  aModel.CompressWhitespace();
  if (deviceOutput->ProductRevisionOffset) {
    aRevision = reinterpret_cast<char*>(deviceOutput) +
                deviceOutput->ProductRevisionOffset;
    aRevision.CompressWhitespace();
  }
  if (isSSD) {
    aType = "SSD";
  } else {
    aType = "HDD";
  }
  free(deviceOutput);
  return NS_OK;
}

nsresult GetInstallYear(uint32_t& aYear) {
  HKEY hKey;
  LONG status = RegOpenKeyExW(
      HKEY_LOCAL_MACHINE, L"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", 0,
      KEY_READ | KEY_WOW64_64KEY, &hKey);

  if (status != ERROR_SUCCESS) {
    return NS_ERROR_UNEXPECTED;
  }

  nsAutoRegKey key(hKey);

  DWORD type = 0;
  time_t raw_time = 0;
  DWORD time_size = sizeof(time_t);

  status = RegQueryValueExW(hKey, L"InstallDate", nullptr, &type,
                            (LPBYTE)&raw_time, &time_size);

  if (status != ERROR_SUCCESS) {
    return NS_ERROR_UNEXPECTED;
  }

  if (type != REG_DWORD) {
    return NS_ERROR_UNEXPECTED;
  }

  tm time;
  if (localtime_s(&time, &raw_time) != 0) {
    return NS_ERROR_UNEXPECTED;
  }

  aYear = 1900UL + time.tm_year;
  return NS_OK;
}

nsresult GetCountryCode(nsAString& aCountryCode) {
  GEOID geoid = GetUserGeoID(GEOCLASS_NATION);
  if (geoid == GEOID_NOT_AVAILABLE) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  // Get required length
  int numChars = GetGeoInfoW(geoid, GEO_ISO2, nullptr, 0, 0);
  if (!numChars) {
    return NS_ERROR_FAILURE;
  }
  // Now get the string for real
  aCountryCode.SetLength(numChars);
  numChars =
      GetGeoInfoW(geoid, GEO_ISO2, char16ptr_t(aCountryCode.BeginWriting()),
                  aCountryCode.Length(), 0);
  if (!numChars) {
    return NS_ERROR_FAILURE;
  }

  // numChars includes null terminator
  aCountryCode.Truncate(numChars - 1);
  return NS_OK;
}

}  // namespace

#  ifndef __MINGW32__

static HRESULT EnumWSCProductList(nsAString& aOutput,
                                  NotNull<IWSCProductList*> aProdList) {
  MOZ_ASSERT(aOutput.IsEmpty());

  LONG count;
  HRESULT hr = aProdList->get_Count(&count);
  if (FAILED(hr)) {
    return hr;
  }

  for (LONG index = 0; index < count; ++index) {
    RefPtr<IWscProduct> product;
    hr = aProdList->get_Item(index, getter_AddRefs(product));
    if (FAILED(hr)) {
      return hr;
    }

    WSC_SECURITY_PRODUCT_STATE state;
    hr = product->get_ProductState(&state);
    if (FAILED(hr)) {
      return hr;
    }

    // We only care about products that are active
    if (state == WSC_SECURITY_PRODUCT_STATE_OFF ||
        state == WSC_SECURITY_PRODUCT_STATE_SNOOZED) {
      continue;
    }

    _bstr_t bName;
    hr = product->get_ProductName(bName.GetAddress());
    if (FAILED(hr)) {
      return hr;
    }

    if (!aOutput.IsEmpty()) {
      aOutput.AppendLiteral(u";");
    }

    aOutput.Append((wchar_t*)bName, bName.length());
  }

  return S_OK;
}

static nsresult GetWindowsSecurityCenterInfo(nsAString& aAVInfo,
                                             nsAString& aAntiSpyInfo,
                                             nsAString& aFirewallInfo) {
  aAVInfo.Truncate();
  aAntiSpyInfo.Truncate();
  aFirewallInfo.Truncate();

  if (!XRE_IsParentProcess()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  const CLSID clsid = __uuidof(WSCProductList);
  const IID iid = __uuidof(IWSCProductList);

  // NB: A separate instance of IWSCProductList is needed for each distinct
  // security provider type; MSDN says that we cannot reuse the same object
  // and call Initialize() to pave over the previous data.

  WSC_SECURITY_PROVIDER providerTypes[] = {WSC_SECURITY_PROVIDER_ANTIVIRUS,
                                           WSC_SECURITY_PROVIDER_ANTISPYWARE,
                                           WSC_SECURITY_PROVIDER_FIREWALL};

  // Each output must match the corresponding entry in providerTypes.
  nsAString* outputs[] = {&aAVInfo, &aAntiSpyInfo, &aFirewallInfo};

  static_assert(ArrayLength(providerTypes) == ArrayLength(outputs),
                "Length of providerTypes and outputs arrays must match");

  for (uint32_t index = 0; index < ArrayLength(providerTypes); ++index) {
    RefPtr<IWSCProductList> prodList;
    HRESULT hr = ::CoCreateInstance(clsid, nullptr, CLSCTX_INPROC_SERVER, iid,
                                    getter_AddRefs(prodList));
    if (FAILED(hr)) {
      return NS_ERROR_NOT_AVAILABLE;
    }

    hr = prodList->Initialize(providerTypes[index]);
    if (FAILED(hr)) {
      return NS_ERROR_UNEXPECTED;
    }

    hr = EnumWSCProductList(*outputs[index], WrapNotNull(prodList.get()));
    if (FAILED(hr)) {
      return NS_ERROR_UNEXPECTED;
    }
  }

  return NS_OK;
}

#  endif  // __MINGW32__

#endif  // defined(XP_WIN)

#ifdef XP_MACOSX
static nsresult GetAppleModelId(nsAutoCString& aModelId) {
  size_t numChars = 0;
  size_t result = sysctlbyname("hw.model", nullptr, &numChars, nullptr, 0);
  if (result != 0 || !numChars) {
    return NS_ERROR_FAILURE;
  }
  aModelId.SetLength(numChars);
  result =
      sysctlbyname("hw.model", aModelId.BeginWriting(), &numChars, nullptr, 0);
  if (result != 0) {
    return NS_ERROR_FAILURE;
  }
  // numChars includes null terminator
  aModelId.Truncate(numChars - 1);
  return NS_OK;
}
#endif

using namespace mozilla;

nsSystemInfo::nsSystemInfo() {}

nsSystemInfo::~nsSystemInfo() {}

// CPU-specific information.
static const struct PropItems {
  const char* name;
  bool (*propfun)(void);
} cpuPropItems[] = {
    // x86-specific bits.
    {"hasMMX", mozilla::supports_mmx},
    {"hasSSE", mozilla::supports_sse},
    {"hasSSE2", mozilla::supports_sse2},
    {"hasSSE3", mozilla::supports_sse3},
    {"hasSSSE3", mozilla::supports_ssse3},
    {"hasSSE4A", mozilla::supports_sse4a},
    {"hasSSE4_1", mozilla::supports_sse4_1},
    {"hasSSE4_2", mozilla::supports_sse4_2},
    {"hasAVX", mozilla::supports_avx},
    {"hasAVX2", mozilla::supports_avx2},
    {"hasAES", mozilla::supports_aes},
    // ARM-specific bits.
    {"hasEDSP", mozilla::supports_edsp},
    {"hasARMv6", mozilla::supports_armv6},
    {"hasARMv7", mozilla::supports_armv7},
    {"hasNEON", mozilla::supports_neon}};

#ifdef XP_WIN
// Lifted from media/webrtc/trunk/webrtc/base/systeminfo.cc,
// so keeping the _ instead of switching to camel case for now.
typedef BOOL(WINAPI* LPFN_GLPI)(PSYSTEM_LOGICAL_PROCESSOR_INFORMATION, PDWORD);
static void GetProcessorInformation(int* physical_cpus, int* cache_size_L2,
                                    int* cache_size_L3) {
  MOZ_ASSERT(physical_cpus && cache_size_L2 && cache_size_L3);

  *physical_cpus = 0;
  *cache_size_L2 = 0;  // This will be in kbytes
  *cache_size_L3 = 0;  // This will be in kbytes

  // GetLogicalProcessorInformation() is available on Windows XP SP3 and beyond.
  LPFN_GLPI glpi = reinterpret_cast<LPFN_GLPI>(GetProcAddress(
      GetModuleHandle(L"kernel32"), "GetLogicalProcessorInformation"));
  if (nullptr == glpi) {
    return;
  }
  // Determine buffer size, allocate and get processor information.
  // Size can change between calls (unlikely), so a loop is done.
  SYSTEM_LOGICAL_PROCESSOR_INFORMATION info_buffer[32];
  SYSTEM_LOGICAL_PROCESSOR_INFORMATION* infos = &info_buffer[0];
  DWORD return_length = sizeof(info_buffer);
  while (!glpi(infos, &return_length)) {
    if (GetLastError() == ERROR_INSUFFICIENT_BUFFER &&
        infos == &info_buffer[0]) {
      infos = new SYSTEM_LOGICAL_PROCESSOR_INFORMATION
          [return_length / sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION)];
    } else {
      return;
    }
  }

  for (size_t i = 0;
       i < return_length / sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION); ++i) {
    if (infos[i].Relationship == RelationProcessorCore) {
      ++*physical_cpus;
    } else if (infos[i].Relationship == RelationCache) {
      // Only care about L2 and L3 cache
      switch (infos[i].Cache.Level) {
        case 2:
          *cache_size_L2 = static_cast<int>(infos[i].Cache.Size / 1024);
          break;
        case 3:
          *cache_size_L3 = static_cast<int>(infos[i].Cache.Size / 1024);
          break;
        default:
          break;
      }
    }
  }
  if (infos != &info_buffer[0]) {
    delete[] infos;
  }
  return;
}
#endif

nsresult nsSystemInfo::Init() {
  // This uses the observer service on Windows, so for simplicity
  // check that it is called from the main thread on all platforms.
  MOZ_ASSERT(NS_IsMainThread());

  nsresult rv;

  static const struct {
    PRSysInfo cmd;
    const char* name;
  } items[] = {{PR_SI_SYSNAME, "name"},
               {PR_SI_ARCHITECTURE, "arch"},
               {PR_SI_RELEASE, "version"}};

  for (uint32_t i = 0; i < (sizeof(items) / sizeof(items[0])); i++) {
    char buf[SYS_INFO_BUFFER_LENGTH];
    if (PR_GetSystemInfo(items[i].cmd, buf, sizeof(buf)) == PR_SUCCESS) {
      rv = SetPropertyAsACString(NS_ConvertASCIItoUTF16(items[i].name),
                                 nsDependentCString(buf));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    } else {
      NS_WARNING("PR_GetSystemInfo failed");
    }
  }

  rv = SetPropertyAsBool(NS_ConvertASCIItoUTF16("hasWindowsTouchInterface"),
                         false);
  NS_ENSURE_SUCCESS(rv, rv);

  // Additional informations not available through PR_GetSystemInfo.
  SetInt32Property(NS_LITERAL_STRING("pagesize"), PR_GetPageSize());
  SetInt32Property(NS_LITERAL_STRING("pageshift"), PR_GetPageShift());
  SetInt32Property(NS_LITERAL_STRING("memmapalign"), PR_GetMemMapAlignment());
  SetUint64Property(NS_LITERAL_STRING("memsize"), PR_GetPhysicalMemorySize());
  SetUint32Property(NS_LITERAL_STRING("umask"), nsSystemInfo::gUserUmask);

  uint64_t virtualMem = 0;
  nsAutoCString cpuVendor;
  int cpuSpeed = -1;
  int cpuFamily = -1;
  int cpuModel = -1;
  int cpuStepping = -1;
  int logicalCPUs = -1;
  int physicalCPUs = -1;
  int cacheSizeL2 = -1;
  int cacheSizeL3 = -1;

#if defined(XP_WIN)
  // Virtual memory:
  MEMORYSTATUSEX memStat;
  memStat.dwLength = sizeof(memStat);
  if (GlobalMemoryStatusEx(&memStat)) {
    virtualMem = memStat.ullTotalVirtual;
  }

  // CPU speed
  HKEY key;
  static const WCHAR keyName[] =
      L"HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0";

  if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, keyName, 0, KEY_QUERY_VALUE, &key) ==
      ERROR_SUCCESS) {
    DWORD data, len, vtype;
    len = sizeof(data);

    if (RegQueryValueEx(key, L"~Mhz", 0, 0, reinterpret_cast<LPBYTE>(&data),
                        &len) == ERROR_SUCCESS) {
      cpuSpeed = static_cast<int>(data);
    }

    // Limit to 64 double byte characters, should be plenty, but create
    // a buffer one larger as the result may not be null terminated. If
    // it is more than 64, we will not get the value.
    wchar_t cpuVendorStr[64 + 1];
    len = sizeof(cpuVendorStr) - 2;
    if (RegQueryValueExW(key, L"VendorIdentifier", 0, &vtype,
                         reinterpret_cast<LPBYTE>(cpuVendorStr),
                         &len) == ERROR_SUCCESS &&
        vtype == REG_SZ && len % 2 == 0 && len > 1) {
      cpuVendorStr[len / 2] = 0;  // In case it isn't null terminated
      CopyUTF16toUTF8(nsDependentString(cpuVendorStr), cpuVendor);
    }

    RegCloseKey(key);
  }

  // Other CPU attributes:
  SYSTEM_INFO si;
  GetNativeSystemInfo(&si);
  logicalCPUs = si.dwNumberOfProcessors;
  GetProcessorInformation(&physicalCPUs, &cacheSizeL2, &cacheSizeL3);
  if (physicalCPUs <= 0) {
    physicalCPUs = logicalCPUs;
  }
  cpuFamily = si.wProcessorLevel;
  cpuModel = si.wProcessorRevision >> 8;
  cpuStepping = si.wProcessorRevision & 0xFF;
#elif defined(XP_MACOSX)
  // CPU speed
  uint64_t sysctlValue64 = 0;
  uint32_t sysctlValue32 = 0;
  size_t len = 0;
  len = sizeof(sysctlValue64);
  if (!sysctlbyname("hw.cpufrequency_max", &sysctlValue64, &len, NULL, 0)) {
    cpuSpeed = static_cast<int>(sysctlValue64 / 1000000);
  }
  MOZ_ASSERT(sizeof(sysctlValue64) == len);

  len = sizeof(sysctlValue32);
  if (!sysctlbyname("hw.physicalcpu_max", &sysctlValue32, &len, NULL, 0)) {
    physicalCPUs = static_cast<int>(sysctlValue32);
  }
  MOZ_ASSERT(sizeof(sysctlValue32) == len);

  len = sizeof(sysctlValue32);
  if (!sysctlbyname("hw.logicalcpu_max", &sysctlValue32, &len, NULL, 0)) {
    logicalCPUs = static_cast<int>(sysctlValue32);
  }
  MOZ_ASSERT(sizeof(sysctlValue32) == len);

  len = sizeof(sysctlValue64);
  if (!sysctlbyname("hw.l2cachesize", &sysctlValue64, &len, NULL, 0)) {
    cacheSizeL2 = static_cast<int>(sysctlValue64 / 1024);
  }
  MOZ_ASSERT(sizeof(sysctlValue64) == len);

  len = sizeof(sysctlValue64);
  if (!sysctlbyname("hw.l3cachesize", &sysctlValue64, &len, NULL, 0)) {
    cacheSizeL3 = static_cast<int>(sysctlValue64 / 1024);
  }
  MOZ_ASSERT(sizeof(sysctlValue64) == len);

  if (!sysctlbyname("machdep.cpu.vendor", NULL, &len, NULL, 0)) {
    char* cpuVendorStr = new char[len];
    if (!sysctlbyname("machdep.cpu.vendor", cpuVendorStr, &len, NULL, 0)) {
      cpuVendor = cpuVendorStr;
    }
    delete[] cpuVendorStr;
  }

  len = sizeof(sysctlValue32);
  if (!sysctlbyname("machdep.cpu.family", &sysctlValue32, &len, NULL, 0)) {
    cpuFamily = static_cast<int>(sysctlValue32);
  }
  MOZ_ASSERT(sizeof(sysctlValue32) == len);

  len = sizeof(sysctlValue32);
  if (!sysctlbyname("machdep.cpu.model", &sysctlValue32, &len, NULL, 0)) {
    cpuModel = static_cast<int>(sysctlValue32);
  }
  MOZ_ASSERT(sizeof(sysctlValue32) == len);

  len = sizeof(sysctlValue32);
  if (!sysctlbyname("machdep.cpu.stepping", &sysctlValue32, &len, NULL, 0)) {
    cpuStepping = static_cast<int>(sysctlValue32);
  }
  MOZ_ASSERT(sizeof(sysctlValue32) == len);

#elif defined(XP_LINUX) && !defined(ANDROID)
  // Get vendor, family, model, stepping, physical cores, L3 cache size
  // from /proc/cpuinfo file
  {
    std::map<nsCString, nsCString> keyValuePairs;
    SimpleParseKeyValuePairs("/proc/cpuinfo", keyValuePairs);

    // cpuVendor from "vendor_id"
    cpuVendor.Assign(keyValuePairs[NS_LITERAL_CSTRING("vendor_id")]);

    {
      // cpuFamily from "cpu family"
      Tokenizer::Token t;
      Tokenizer p(keyValuePairs[NS_LITERAL_CSTRING("cpu family")]);
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cpuFamily = static_cast<int>(t.AsInteger());
      }
    }

    {
      // cpuModel from "model"
      Tokenizer::Token t;
      Tokenizer p(keyValuePairs[NS_LITERAL_CSTRING("model")]);
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cpuModel = static_cast<int>(t.AsInteger());
      }
    }

    {
      // cpuStepping from "stepping"
      Tokenizer::Token t;
      Tokenizer p(keyValuePairs[NS_LITERAL_CSTRING("stepping")]);
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cpuStepping = static_cast<int>(t.AsInteger());
      }
    }

    {
      // physicalCPUs from "cpu cores"
      Tokenizer::Token t;
      Tokenizer p(keyValuePairs[NS_LITERAL_CSTRING("cpu cores")]);
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        physicalCPUs = static_cast<int>(t.AsInteger());
      }
    }

    {
      // cacheSizeL3 from "cache size"
      Tokenizer::Token t;
      Tokenizer p(keyValuePairs[NS_LITERAL_CSTRING("cache size")]);
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cacheSizeL3 = static_cast<int>(t.AsInteger());
        if (p.Next(t) && t.Type() == Tokenizer::TOKEN_WORD &&
            t.AsString() != NS_LITERAL_CSTRING("KB")) {
          // If we get here, there was some text after the cache size value
          // and that text was not KB.  For now, just don't report the
          // L3 cache.
          cacheSizeL3 = -1;
        }
      }
    }
  }

  {
    // Get cpuSpeed from another file.
    std::ifstream input(
        "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq");
    std::string line;
    if (getline(input, line)) {
      Tokenizer::Token t;
      Tokenizer p(line.c_str());
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cpuSpeed = static_cast<int>(t.AsInteger() / 1000);
      }
    }
  }

  {
    // Get cacheSizeL2 from yet another file
    std::ifstream input("/sys/devices/system/cpu/cpu0/cache/index2/size");
    std::string line;
    if (getline(input, line)) {
      Tokenizer::Token t;
      Tokenizer p(line.c_str(), nullptr, "K");
      if (p.Next(t) && t.Type() == Tokenizer::TOKEN_INTEGER &&
          t.AsInteger() <= INT32_MAX) {
        cacheSizeL2 = static_cast<int>(t.AsInteger());
      }
    }
  }

  SetInt32Property(NS_LITERAL_STRING("cpucount"), PR_GetNumberOfProcessors());
#else
  SetInt32Property(NS_LITERAL_STRING("cpucount"), PR_GetNumberOfProcessors());
#endif

  if (virtualMem)
    SetUint64Property(NS_LITERAL_STRING("virtualmemsize"), virtualMem);
  if (cpuSpeed >= 0) SetInt32Property(NS_LITERAL_STRING("cpuspeed"), cpuSpeed);
  if (!cpuVendor.IsEmpty())
    SetPropertyAsACString(NS_LITERAL_STRING("cpuvendor"), cpuVendor);
  if (cpuFamily >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpufamily"), cpuFamily);
  if (cpuModel >= 0) SetInt32Property(NS_LITERAL_STRING("cpumodel"), cpuModel);
  if (cpuStepping >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpustepping"), cpuStepping);

  if (logicalCPUs >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpucount"), logicalCPUs);
  if (physicalCPUs >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpucores"), physicalCPUs);

  if (cacheSizeL2 >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpucachel2"), cacheSizeL2);
  if (cacheSizeL3 >= 0)
    SetInt32Property(NS_LITERAL_STRING("cpucachel3"), cacheSizeL3);

  for (uint32_t i = 0; i < ArrayLength(cpuPropItems); i++) {
    rv = SetPropertyAsBool(NS_ConvertASCIItoUTF16(cpuPropItems[i].name),
                           cpuPropItems[i].propfun());
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

#ifdef XP_WIN
  bool isMinGW =
#  ifdef __MINGW32__
      true;
#  else
      false;
#  endif
  rv = SetPropertyAsBool(NS_LITERAL_STRING("isMinGW"), !!isMinGW);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  // IsWow64Process2 is only available on Windows 10+, so we have to dynamically
  // check for its existence.
  typedef BOOL(WINAPI * LPFN_IWP2)(HANDLE, USHORT*, USHORT*);
  LPFN_IWP2 iwp2 = reinterpret_cast<LPFN_IWP2>(
      GetProcAddress(GetModuleHandle(L"kernel32"), "IsWow64Process2"));
  BOOL isWow64 = false;
  USHORT processMachine = IMAGE_FILE_MACHINE_UNKNOWN;
  USHORT nativeMachine = IMAGE_FILE_MACHINE_UNKNOWN;
  BOOL gotWow64Value;
  if (iwp2) {
    gotWow64Value = iwp2(GetCurrentProcess(), &processMachine, &nativeMachine);
    if (gotWow64Value) {
      isWow64 = (processMachine != IMAGE_FILE_MACHINE_UNKNOWN);
    }
  } else {
    gotWow64Value = IsWow64Process(GetCurrentProcess(), &isWow64);
    // The function only indicates a WOW64 environment if it's 32-bit x86
    // running on x86-64, so emulate what IsWow64Process2 would have given.
    if (gotWow64Value && isWow64) {
      processMachine = IMAGE_FILE_MACHINE_I386;
      nativeMachine = IMAGE_FILE_MACHINE_AMD64;
    }
  }
  NS_WARNING_ASSERTION(gotWow64Value, "IsWow64Process failed");
  if (gotWow64Value) {
    // Set this always, even for the x86-on-arm64 case.
    rv = SetPropertyAsBool(NS_LITERAL_STRING("isWow64"), !!isWow64);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    // Additional information if we're running x86-on-arm64
    bool isWowARM64 = (processMachine == IMAGE_FILE_MACHINE_I386 &&
                       nativeMachine == IMAGE_FILE_MACHINE_ARM64);
    rv = SetPropertyAsBool(NS_LITERAL_STRING("isWowARM64"), !!isWowARM64);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }
  if (NS_FAILED(GetProfileHDDInfo())) {
    // We might have been called before profile-do-change. We'll observe that
    // event so that we can fill this in later.
    nsCOMPtr<nsIObserverService> obsService =
        do_GetService(NS_OBSERVERSERVICE_CONTRACTID, &rv);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    rv = obsService->AddObserver(this, "profile-do-change", false);
    if (NS_FAILED(rv)) {
      return rv;
    }
  }
  nsAutoCString hddModel, hddRevision, hddType;
  if (NS_SUCCEEDED(GetHDDInfo(NS_GRE_DIR, hddModel, hddRevision, hddType))) {
    rv = SetPropertyAsACString(NS_LITERAL_STRING("binHDDModel"), hddModel);
    NS_ENSURE_SUCCESS(rv, rv);
    rv =
        SetPropertyAsACString(NS_LITERAL_STRING("binHDDRevision"), hddRevision);
    NS_ENSURE_SUCCESS(rv, rv);
    rv = SetPropertyAsACString(NS_LITERAL_STRING("binHDDType"), hddType);
    NS_ENSURE_SUCCESS(rv, rv);
  }
  if (NS_SUCCEEDED(
          GetHDDInfo(NS_WIN_WINDOWS_DIR, hddModel, hddRevision, hddType))) {
    rv = SetPropertyAsACString(NS_LITERAL_STRING("winHDDModel"), hddModel);
    NS_ENSURE_SUCCESS(rv, rv);
    rv =
        SetPropertyAsACString(NS_LITERAL_STRING("winHDDRevision"), hddRevision);
    NS_ENSURE_SUCCESS(rv, rv);
    rv = SetPropertyAsACString(NS_LITERAL_STRING("winHDDType"), hddType);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsAutoString countryCode;
  if (NS_SUCCEEDED(GetCountryCode(countryCode))) {
    rv = SetPropertyAsAString(NS_LITERAL_STRING("countryCode"), countryCode);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  uint32_t installYear = 0;
  if (NS_SUCCEEDED(GetInstallYear(installYear))) {
    rv = SetPropertyAsUint32(NS_LITERAL_STRING("installYear"), installYear);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

#  ifndef __MINGW32__
  nsAutoString avInfo, antiSpyInfo, firewallInfo;
  if (NS_SUCCEEDED(
          GetWindowsSecurityCenterInfo(avInfo, antiSpyInfo, firewallInfo))) {
    if (!avInfo.IsEmpty()) {
      rv = SetPropertyAsAString(NS_LITERAL_STRING("registeredAntiVirus"),
                                avInfo);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }

    if (!antiSpyInfo.IsEmpty()) {
      rv = SetPropertyAsAString(NS_LITERAL_STRING("registeredAntiSpyware"),
                                antiSpyInfo);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }

    if (!firewallInfo.IsEmpty()) {
      rv = SetPropertyAsAString(NS_LITERAL_STRING("registeredFirewall"),
                                firewallInfo);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }
  }
#  endif  // __MINGW32__
#endif

#if defined(XP_MACOSX)
  nsAutoString countryCode;
  if (NS_SUCCEEDED(GetSelectedCityInfo(countryCode))) {
    rv = SetPropertyAsAString(NS_LITERAL_STRING("countryCode"), countryCode);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsAutoCString modelId;
  if (NS_SUCCEEDED(GetAppleModelId(modelId))) {
    rv = SetPropertyAsACString(NS_LITERAL_STRING("appleModelId"), modelId);
    NS_ENSURE_SUCCESS(rv, rv);
  }
#endif

#if defined(MOZ_WIDGET_GTK)
  // This must be done here because NSPR can only separate OS's when compiled,
  // not libraries. 64 bytes is going to be well enough for "GTK " followed by 3
  // integers separated with dots.
  char gtkver[64];
  ssize_t gtkver_len = 0;

  if (gtkver_len <= 0) {
    gtkver_len = SprintfLiteral(gtkver, "GTK %u.%u.%u", gtk_major_version,
                                gtk_minor_version, gtk_micro_version);
  }

  nsAutoCString secondaryLibrary;
  if (gtkver_len > 0 && gtkver_len < int(sizeof(gtkver))) {
    secondaryLibrary.Append(nsDependentCSubstring(gtkver, gtkver_len));
  }

  void* libpulse = dlopen("libpulse.so.0", RTLD_LAZY);
  const char* libpulseVersion = "not-available";
  if (libpulse) {
    auto pa_get_library_version = reinterpret_cast<const char* (*)()>(
        dlsym(libpulse, "pa_get_library_version"));

    if (pa_get_library_version) {
      libpulseVersion = pa_get_library_version();
    }
  }

  secondaryLibrary.AppendPrintf(",libpulse %s", libpulseVersion);

  if (libpulse) {
    dlclose(libpulse);
  }

  rv = SetPropertyAsACString(NS_LITERAL_STRING("secondaryLibrary"),
                             secondaryLibrary);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
#endif

#ifdef MOZ_WIDGET_ANDROID
  AndroidSystemInfo info;
  GetAndroidSystemInfo(&info);
  SetupAndroidInfo(info);
#endif

#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
  SandboxInfo sandInfo = SandboxInfo::Get();

  SetPropertyAsBool(NS_LITERAL_STRING("hasSeccompBPF"),
                    sandInfo.Test(SandboxInfo::kHasSeccompBPF));
  SetPropertyAsBool(NS_LITERAL_STRING("hasSeccompTSync"),
                    sandInfo.Test(SandboxInfo::kHasSeccompTSync));
  SetPropertyAsBool(NS_LITERAL_STRING("hasUserNamespaces"),
                    sandInfo.Test(SandboxInfo::kHasUserNamespaces));
  SetPropertyAsBool(NS_LITERAL_STRING("hasPrivilegedUserNamespaces"),
                    sandInfo.Test(SandboxInfo::kHasPrivilegedUserNamespaces));

  if (sandInfo.Test(SandboxInfo::kEnabledForContent)) {
    SetPropertyAsBool(NS_LITERAL_STRING("canSandboxContent"),
                      sandInfo.CanSandboxContent());
  }

  if (sandInfo.Test(SandboxInfo::kEnabledForMedia)) {
    SetPropertyAsBool(NS_LITERAL_STRING("canSandboxMedia"),
                      sandInfo.CanSandboxMedia());
  }
#endif  // XP_LINUX && MOZ_SANDBOX

  return NS_OK;
}

#ifdef MOZ_WIDGET_ANDROID
// Prerelease versions of Android use a letter instead of version numbers.
// Unfortunately this breaks websites due to the user agent.
// Chrome works around this by hardcoding an Android version when a
// numeric version can't be obtained. We're doing the same.
// This version will need to be updated whenever there is a new official
// Android release.
// See: https://cs.chromium.org/chromium/src/base/sys_info_android.cc?l=61
#  define DEFAULT_ANDROID_VERSION "6.0.99"

/* static */
void nsSystemInfo::GetAndroidSystemInfo(AndroidSystemInfo* aInfo) {
  if (!jni::IsAvailable()) {
    // called from xpcshell etc.
    aInfo->sdk_version() = 0;
    return;
  }

  jni::String::LocalRef model = java::sdk::Build::MODEL();
  aInfo->device() = model->ToString();

  jni::String::LocalRef manufacturer =
      mozilla::java::sdk::Build::MANUFACTURER();
  aInfo->manufacturer() = manufacturer->ToString();

  jni::String::LocalRef hardware = java::sdk::Build::HARDWARE();
  aInfo->hardware() = hardware->ToString();

  jni::String::LocalRef release = java::sdk::VERSION::RELEASE();
  nsString str(release->ToString());
  int major_version;
  int minor_version;
  int bugfix_version;
  int num_read = sscanf(NS_ConvertUTF16toUTF8(str).get(), "%d.%d.%d",
                        &major_version, &minor_version, &bugfix_version);
  if (num_read == 0) {
    aInfo->release_version() = NS_LITERAL_STRING(DEFAULT_ANDROID_VERSION);
  } else {
    aInfo->release_version() = str;
  }

  aInfo->sdk_version() = jni::GetAPIVersion();
  aInfo->isTablet() = java::GeckoAppShell::IsTablet();
}

void nsSystemInfo::SetupAndroidInfo(const AndroidSystemInfo& aInfo) {
  if (!aInfo.device().IsEmpty()) {
    SetPropertyAsAString(NS_LITERAL_STRING("device"), aInfo.device());
  }
  if (!aInfo.manufacturer().IsEmpty()) {
    SetPropertyAsAString(NS_LITERAL_STRING("manufacturer"),
                         aInfo.manufacturer());
  }
  if (!aInfo.release_version().IsEmpty()) {
    SetPropertyAsAString(NS_LITERAL_STRING("release_version"),
                         aInfo.release_version());
  }
  SetPropertyAsBool(NS_LITERAL_STRING("tablet"), aInfo.isTablet());
  // NSPR "version" is the kernel version. For Android we want the Android
  // version. Rename SDK version to version and put the kernel version into
  // kernel_version.
  nsAutoString str;
  nsresult rv = GetPropertyAsAString(NS_LITERAL_STRING("version"), str);
  if (NS_SUCCEEDED(rv)) {
    SetPropertyAsAString(NS_LITERAL_STRING("kernel_version"), str);
  }
  // When JNI is not available (eg. in xpcshell tests), sdk_version is 0.
  if (aInfo.sdk_version() != 0) {
    if (!aInfo.hardware().IsEmpty()) {
      SetPropertyAsAString(NS_LITERAL_STRING("hardware"), aInfo.hardware());
    }
    SetPropertyAsInt32(NS_LITERAL_STRING("version"), aInfo.sdk_version());
  }
}
#endif  // MOZ_WIDGET_ANDROID

void nsSystemInfo::SetInt32Property(const nsAString& aPropertyName,
                                    const int32_t aValue) {
  NS_WARNING_ASSERTION(aValue > 0, "Unable to read system value");
  if (aValue > 0) {
#ifdef DEBUG
    nsresult rv =
#endif
        SetPropertyAsInt32(aPropertyName, aValue);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "Unable to set property");
  }
}

void nsSystemInfo::SetUint32Property(const nsAString& aPropertyName,
                                     const uint32_t aValue) {
  // Only one property is currently set via this function.
  // It may legitimately be zero.
#ifdef DEBUG
  nsresult rv =
#endif
      SetPropertyAsUint32(aPropertyName, aValue);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "Unable to set property");
}

void nsSystemInfo::SetUint64Property(const nsAString& aPropertyName,
                                     const uint64_t aValue) {
  NS_WARNING_ASSERTION(aValue > 0, "Unable to read system value");
  if (aValue > 0) {
#ifdef DEBUG
    nsresult rv =
#endif
        SetPropertyAsUint64(aPropertyName, aValue);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "Unable to set property");
  }
}

#if defined(XP_WIN)
NS_IMETHODIMP
nsSystemInfo::Observe(nsISupports* aSubject, const char* aTopic,
                      const char16_t* aData) {
  if (!strcmp(aTopic, "profile-do-change")) {
    nsresult rv;
    nsCOMPtr<nsIObserverService> obsService =
        do_GetService(NS_OBSERVERSERVICE_CONTRACTID, &rv);
    if (NS_FAILED(rv)) {
      return rv;
    }
    rv = obsService->RemoveObserver(this, "profile-do-change");
    if (NS_FAILED(rv)) {
      return rv;
    }
    return GetProfileHDDInfo();
  }
  return NS_OK;
}

nsresult nsSystemInfo::GetProfileHDDInfo() {
  nsAutoCString hddModel, hddRevision, hddType;
  nsresult rv =
      GetHDDInfo(NS_APP_USER_PROFILE_50_DIR, hddModel, hddRevision, hddType);
  if (NS_FAILED(rv)) {
    return rv;
  }
  rv = SetPropertyAsACString(NS_LITERAL_STRING("profileHDDModel"), hddModel);
  if (NS_FAILED(rv)) {
    return rv;
  }
  rv = SetPropertyAsACString(NS_LITERAL_STRING("profileHDDRevision"),
                             hddRevision);
  if (NS_FAILED(rv)) {
    return rv;
  }
  rv = SetPropertyAsACString(NS_LITERAL_STRING("profileHDDType"), hddType);
  return rv;
}

NS_IMPL_ISUPPORTS_INHERITED(nsSystemInfo, nsHashPropertyBag, nsIObserver)
#endif  // defined(XP_WIN)
