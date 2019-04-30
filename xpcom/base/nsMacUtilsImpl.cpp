/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsMacUtilsImpl.h"

#include <CoreFoundation/CoreFoundation.h>
#include <sys/sysctl.h>

#include "mozilla/Unused.h"

NS_IMPL_ISUPPORTS(nsMacUtilsImpl, nsIMacUtils)

using mozilla::Unused;

// Initialize with Unknown until we've checked if TCSM is available to set
Atomic<nsMacUtilsImpl::TCSMStatus> nsMacUtilsImpl::sTCSMStatus(TCSM_Unknown);

nsresult nsMacUtilsImpl::GetArchString(nsAString& aArchString) {
  if (!mBinaryArchs.IsEmpty()) {
    aArchString.Assign(mBinaryArchs);
    return NS_OK;
  }

  aArchString.Truncate();

  bool foundPPC = false,
       foundX86 = false,
       foundPPC64 = false,
       foundX86_64 = false;

  CFBundleRef mainBundle = ::CFBundleGetMainBundle();
  if (!mainBundle) {
    return NS_ERROR_FAILURE;
  }

  CFArrayRef archList = ::CFBundleCopyExecutableArchitectures(mainBundle);
  if (!archList) {
    return NS_ERROR_FAILURE;
  }

  CFIndex archCount = ::CFArrayGetCount(archList);
  for (CFIndex i = 0; i < archCount; i++) {
    CFNumberRef arch =
      static_cast<CFNumberRef>(::CFArrayGetValueAtIndex(archList, i));

    int archInt = 0;
    if (!::CFNumberGetValue(arch, kCFNumberIntType, &archInt)) {
      ::CFRelease(archList);
      return NS_ERROR_FAILURE;
    }

    if (archInt == kCFBundleExecutableArchitecturePPC) {
      foundPPC = true;
    } else if (archInt == kCFBundleExecutableArchitectureI386) {
      foundX86 = true;
    } else if (archInt == kCFBundleExecutableArchitecturePPC64) {
      foundPPC64 = true;
    } else if (archInt == kCFBundleExecutableArchitectureX86_64) {
      foundX86_64 = true;
    }
  }

  ::CFRelease(archList);

  // The order in the string must always be the same so
  // don't do this in the loop.
  if (foundPPC) {
    mBinaryArchs.AppendLiteral("ppc");
  }

  if (foundX86) {
    if (!mBinaryArchs.IsEmpty()) {
      mBinaryArchs.Append('-');
    }
    mBinaryArchs.AppendLiteral("i386");
  }

  if (foundPPC64) {
    if (!mBinaryArchs.IsEmpty()) {
      mBinaryArchs.Append('-');
    }
    mBinaryArchs.AppendLiteral("ppc64");
  }

  if (foundX86_64) {
    if (!mBinaryArchs.IsEmpty()) {
      mBinaryArchs.Append('-');
    }
    mBinaryArchs.AppendLiteral("x86_64");
  }

  aArchString.Assign(mBinaryArchs);

  return (aArchString.IsEmpty() ? NS_ERROR_FAILURE : NS_OK);
}

NS_IMETHODIMP
nsMacUtilsImpl::GetIsUniversalBinary(bool* aIsUniversalBinary)
{
  if (NS_WARN_IF(!aIsUniversalBinary)) {
    return NS_ERROR_INVALID_ARG;
  }
  *aIsUniversalBinary = false;

  nsAutoString archString;
  nsresult rv = GetArchString(archString);
  if (NS_FAILED(rv)) {
    return rv;
  }

  // The delimiter char in the arch string is '-', so if that character
  // is in the string we know we have multiple architectures.
  *aIsUniversalBinary = (archString.Find("-") > -1);

  return NS_OK;
}

NS_IMETHODIMP
nsMacUtilsImpl::GetArchitecturesInBinary(nsAString& aArchString)
{
  return GetArchString(aArchString);
}

// True when running under binary translation (Rosetta).
NS_IMETHODIMP
nsMacUtilsImpl::GetIsTranslated(bool* aIsTranslated)
{
#ifdef __ppc__
  static bool    sInitialized = false;

  // Initialize sIsNative to 1.  If the sysctl fails because it doesn't
  // exist, then translation is not possible, so the process must not be
  // running translated.
  static int32_t sIsNative = 1;

  if (!sInitialized) {
    size_t sz = sizeof(sIsNative);
    sysctlbyname("sysctl.proc_native", &sIsNative, &sz, nullptr, 0);
    sInitialized = true;
  }

  *aIsTranslated = !sIsNative;
#else
  // Translation only exists for ppc code.  Other architectures aren't
  // translated.
  *aIsTranslated = false;
#endif

  return NS_OK;
}

/* static */
bool nsMacUtilsImpl::IsTCSMAvailable() {
  if (sTCSMStatus == TCSM_Unknown) {
    uint32_t oldVal = 0;
    size_t oldValSize = sizeof(oldVal);
    int rv = sysctlbyname("kern.tcsm_available", &oldVal, &oldValSize, NULL, 0);
    TCSMStatus newStatus;
    if (rv < 0 || oldVal == 0) {
      newStatus = TCSM_Unavailable;
    } else {
      newStatus = TCSM_Available;
    }
    // The value of sysctl kern.tcsm_available is the same for all
    // threads within the same process. If another thread raced with us
    // and initialized sTCSMStatus first (changing it from
    // TCSM_Unknown), we can continue without needing to update it
    // again. Hence, we ignore compareExchange's return value.
    Unused << sTCSMStatus.compareExchange(TCSM_Unknown, newStatus);
  }
  return (sTCSMStatus == TCSM_Available);
}

/* static */
nsresult nsMacUtilsImpl::EnableTCSM() {
  uint32_t newVal = 1;
  int rv = sysctlbyname("kern.tcsm_enable", NULL, 0, &newVal, sizeof(newVal));
  if (rv < 0) {
    return NS_ERROR_UNEXPECTED;
  }
  return NS_OK;
}

/*
 * Intentionally return void so that failures will be ignored in non-debug
 * builds. This method uses new sysctls which may not be as thoroughly tested
 * and we don't want to cause crashes handling the failure due to an OS bug.
 */
/* static */
void nsMacUtilsImpl::EnableTCSMIfAvailable() {
  if (IsTCSMAvailable()) {
    if (NS_FAILED(EnableTCSM())) {
      NS_WARNING("Failed to enable TCSM");
    }
    MOZ_ASSERT(IsTCSMEnabled());
  }
}

#if defined(DEBUG)
/* static */
bool nsMacUtilsImpl::IsTCSMEnabled() {
  uint32_t oldVal = 0;
  size_t oldValSize = sizeof(oldVal);
  int rv = sysctlbyname("kern.tcsm_enable", &oldVal, &oldValSize, NULL, 0);
  return (rv == 0) && (oldVal != 0);
}
#endif
