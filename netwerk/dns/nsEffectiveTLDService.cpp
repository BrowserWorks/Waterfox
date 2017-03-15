/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// This service reads a file of rules describing TLD-like domain names.  For a
// complete description of the expected file format and parsing rules, see
// http://wiki.mozilla.org/Gecko:Effective_TLD_Service

#include "mozilla/ArrayUtils.h"
#include "mozilla/MemoryReporting.h"

#include "nsEffectiveTLDService.h"
#include "nsIIDNService.h"
#include "nsNetUtil.h"
#include "prnetdb.h"
#include "nsIURI.h"
#include "nsNetCID.h"
#include "nsServiceManagerUtils.h"

using namespace mozilla;

NS_IMPL_ISUPPORTS(nsEffectiveTLDService, nsIEffectiveTLDService,
                  nsIMemoryReporter)

// ----------------------------------------------------------------------

#define ETLD_STR_NUM_1(line) str##line
#define ETLD_STR_NUM(line) ETLD_STR_NUM_1(line)
#define ETLD_ENTRY_OFFSET(name) offsetof(struct etld_string_list, ETLD_STR_NUM(__LINE__))

const ETLDEntry ETLDEntry::entries[] = {
#define ETLD_ENTRY(name, ex, wild) { ETLD_ENTRY_OFFSET(name), ex, wild },
#include "etld_data.inc"
#undef ETLD_ENTRY
};

const union ETLDEntry::etld_strings ETLDEntry::strings = {
  {
#define ETLD_ENTRY(name, ex, wild) name,
#include "etld_data.inc"
#undef ETLD_ENTRY
  }
};

/* static */ const ETLDEntry*
ETLDEntry::GetEntry(const char* aDomain)
{
  size_t i;
  if (BinarySearchIf(entries, 0, ArrayLength(ETLDEntry::entries),
                     Cmp(aDomain), &i)) {
    return &entries[i];
  }
  return nullptr;
}

// Dummy function to statically ensure that our indices don't overflow
// the storage provided for them.
void
ETLDEntry::FuncForStaticAsserts(void)
{
#define ETLD_ENTRY(name, ex, wild)                                      \
  static_assert(ETLD_ENTRY_OFFSET(name) < (1 << ETLD_ENTRY_N_INDEX_BITS), \
                "invalid strtab index");
#include "etld_data.inc"
#undef ETLD_ENTRY
}

#undef ETLD_ENTRY_OFFSET
#undef ETLD_STR_NUM
#undef ETLD_STR_NUM1

// ----------------------------------------------------------------------

static nsEffectiveTLDService *gService = nullptr;

nsEffectiveTLDService::nsEffectiveTLDService()
{
}

nsresult
nsEffectiveTLDService::Init()
{
  nsresult rv;
  mIDNService = do_GetService(NS_IDNSERVICE_CONTRACTID, &rv);
  if (NS_FAILED(rv)) return rv;

#ifdef DEBUG
  // Sanity-check the eTLD entries.
  for (uint32_t i = 0; i < ArrayLength(ETLDEntry::entries); i++) {
    const char* domain = ETLDEntry::entries[i].GetEffectiveTLDName();
    nsDependentCString name(domain);
    nsAutoCString normalizedName(domain);
    MOZ_ASSERT(NS_SUCCEEDED(NormalizeHostname(normalizedName)),
               "normalization failure!");
    MOZ_ASSERT(name.Equals(normalizedName), "domain not normalized!");

    // Domains must be in sorted order for binary search to work.
    if (i > 0) {
      const char* domain0 = ETLDEntry::entries[i - 1].GetEffectiveTLDName();
      MOZ_ASSERT(strcmp(domain0, domain) < 0, "domains not in sorted order!");
    }
  }
#endif

  MOZ_ASSERT(!gService);
  gService = this;
  RegisterWeakMemoryReporter(this);

  return NS_OK;
}

nsEffectiveTLDService::~nsEffectiveTLDService()
{
  UnregisterWeakMemoryReporter(this);
  gService = nullptr;
}

MOZ_DEFINE_MALLOC_SIZE_OF(EffectiveTLDServiceMallocSizeOf)

// The amount of heap memory measured here is tiny. It used to be bigger when
// nsEffectiveTLDService used a separate hash table instead of binary search.
// Nonetheless, we keep this code here in anticipation of bug 1083971 which will
// change ETLDEntries::entries to a heap-allocated array modifiable at runtime.
NS_IMETHODIMP
nsEffectiveTLDService::CollectReports(nsIHandleReportCallback* aHandleReport,
                                      nsISupports* aData, bool aAnonymize)
{
  MOZ_COLLECT_REPORT(
    "explicit/network/effective-TLD-service", KIND_HEAP, UNITS_BYTES,
    SizeOfIncludingThis(EffectiveTLDServiceMallocSizeOf),
    "Memory used by the effective TLD service.");

  return NS_OK;
}

size_t
nsEffectiveTLDService::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf)
{
  size_t n = aMallocSizeOf(this);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mIDNService

  return n;
}

// External function for dealing with URI's correctly.
// Pulls out the host portion from an nsIURI, and calls through to
// GetPublicSuffixFromHost().
NS_IMETHODIMP
nsEffectiveTLDService::GetPublicSuffix(nsIURI     *aURI,
                                       nsACString &aPublicSuffix)
{
  NS_ENSURE_ARG_POINTER(aURI);

  nsCOMPtr<nsIURI> innerURI = NS_GetInnermostURI(aURI);
  NS_ENSURE_ARG_POINTER(innerURI);

  nsAutoCString host;
  nsresult rv = innerURI->GetAsciiHost(host);
  if (NS_FAILED(rv)) return rv;

  return GetBaseDomainInternal(host, 0, aPublicSuffix);
}

// External function for dealing with URI's correctly.
// Pulls out the host portion from an nsIURI, and calls through to
// GetBaseDomainFromHost().
NS_IMETHODIMP
nsEffectiveTLDService::GetBaseDomain(nsIURI     *aURI,
                                     uint32_t    aAdditionalParts,
                                     nsACString &aBaseDomain)
{
  NS_ENSURE_ARG_POINTER(aURI);
  NS_ENSURE_TRUE( ((int32_t)aAdditionalParts) >= 0, NS_ERROR_INVALID_ARG);

  nsCOMPtr<nsIURI> innerURI = NS_GetInnermostURI(aURI);
  NS_ENSURE_ARG_POINTER(innerURI);

  nsAutoCString host;
  nsresult rv = innerURI->GetAsciiHost(host);
  if (NS_FAILED(rv)) return rv;

  return GetBaseDomainInternal(host, aAdditionalParts + 1, aBaseDomain);
}

// External function for dealing with a host string directly: finds the public
// suffix (e.g. co.uk) for the given hostname. See GetBaseDomainInternal().
NS_IMETHODIMP
nsEffectiveTLDService::GetPublicSuffixFromHost(const nsACString &aHostname,
                                               nsACString       &aPublicSuffix)
{
  // Create a mutable copy of the hostname and normalize it to ACE.
  // This will fail if the hostname includes invalid characters.
  nsAutoCString normHostname(aHostname);
  nsresult rv = NormalizeHostname(normHostname);
  if (NS_FAILED(rv)) return rv;

  return GetBaseDomainInternal(normHostname, 0, aPublicSuffix);
}

// External function for dealing with a host string directly: finds the base
// domain (e.g. www.co.uk) for the given hostname and number of subdomain parts
// requested. See GetBaseDomainInternal().
NS_IMETHODIMP
nsEffectiveTLDService::GetBaseDomainFromHost(const nsACString &aHostname,
                                             uint32_t          aAdditionalParts,
                                             nsACString       &aBaseDomain)
{
  NS_ENSURE_TRUE( ((int32_t)aAdditionalParts) >= 0, NS_ERROR_INVALID_ARG);

  // Create a mutable copy of the hostname and normalize it to ACE.
  // This will fail if the hostname includes invalid characters.
  nsAutoCString normHostname(aHostname);
  nsresult rv = NormalizeHostname(normHostname);
  if (NS_FAILED(rv)) return rv;

  return GetBaseDomainInternal(normHostname, aAdditionalParts + 1, aBaseDomain);
}

NS_IMETHODIMP
nsEffectiveTLDService::GetNextSubDomain(const nsACString& aHostname,
                                        nsACString&       aBaseDomain)
{
  // Create a mutable copy of the hostname and normalize it to ACE.
  // This will fail if the hostname includes invalid characters.
  nsAutoCString normHostname(aHostname);
  nsresult rv = NormalizeHostname(normHostname);
  NS_ENSURE_SUCCESS(rv, rv);

  return GetBaseDomainInternal(normHostname, -1, aBaseDomain);
}

// Finds the base domain for a host, with requested number of additional parts.
// This will fail, generating an error, if the host is an IPv4/IPv6 address,
// if more subdomain parts are requested than are available, or if the hostname
// includes characters that are not valid in a URL. Normalization is performed
// on the host string and the result will be in UTF8.
nsresult
nsEffectiveTLDService::GetBaseDomainInternal(nsCString  &aHostname,
                                             int32_t    aAdditionalParts,
                                             nsACString &aBaseDomain)
{
  if (aHostname.IsEmpty())
    return NS_ERROR_INSUFFICIENT_DOMAIN_LEVELS;

  // chomp any trailing dot, and keep track of it for later
  bool trailingDot = aHostname.Last() == '.';
  if (trailingDot)
    aHostname.Truncate(aHostname.Length() - 1);

  // check the edge cases of the host being '.' or having a second trailing '.',
  // since subsequent checks won't catch it.
  if (aHostname.IsEmpty() || aHostname.Last() == '.')
    return NS_ERROR_INVALID_ARG;

  // Check if we're dealing with an IPv4/IPv6 hostname, and return
  PRNetAddr addr;
  PRStatus result = PR_StringToNetAddr(aHostname.get(), &addr);
  if (result == PR_SUCCESS)
    return NS_ERROR_HOST_IS_IP_ADDRESS;

  // Walk up the domain tree, most specific to least specific,
  // looking for matches at each level.  Note that a given level may
  // have multiple attributes (e.g. IsWild() and IsNormal()).
  const char *prevDomain = nullptr;
  const char *currDomain = aHostname.get();
  const char *nextDot = strchr(currDomain, '.');
  const char *end = currDomain + aHostname.Length();
  // Default value of *eTLD is currDomain as set in the while loop below
  const char *eTLD = nullptr;
  while (true) {
    // sanity check the string we're about to look up: it should not begin with
    // a '.'; this would mean the hostname began with a '.' or had an
    // embedded '..' sequence.
    if (*currDomain == '.')
      return NS_ERROR_INVALID_ARG;

    // Perform the lookup.
    const ETLDEntry* entry = ETLDEntry::GetEntry(currDomain);
    if (entry) {
      if (entry->IsWild() && prevDomain) {
        // wildcard rules imply an eTLD one level inferior to the match.
        eTLD = prevDomain;
        break;

      } else if (entry->IsNormal() || !nextDot) {
        // specific match, or we've hit the top domain level
        eTLD = currDomain;
        break;

      } else if (entry->IsException()) {
        // exception rules imply an eTLD one level superior to the match.
        eTLD = nextDot + 1;
        break;
      }
    }

    if (!nextDot) {
      // we've hit the top domain level; use it by default.
      eTLD = currDomain;
      break;
    }

    prevDomain = currDomain;
    currDomain = nextDot + 1;
    nextDot = strchr(currDomain, '.');
  }

  const char *begin, *iter;
  if (aAdditionalParts < 0) {
    NS_ASSERTION(aAdditionalParts == -1,
                 "aAdditionalParts can't be negative and different from -1");

    for (iter = aHostname.get(); iter != eTLD && *iter != '.'; iter++);

    if (iter != eTLD) {
      iter++;
    }
    if (iter != eTLD) {
      aAdditionalParts = 0;
    }
  } else {
    // count off the number of requested domains.
    begin = aHostname.get();
    iter = eTLD;

    while (true) {
      if (iter == begin)
        break;

      if (*(--iter) == '.' && aAdditionalParts-- == 0) {
        ++iter;
        ++aAdditionalParts;
        break;
      }
    }
  }

  if (aAdditionalParts != 0)
    return NS_ERROR_INSUFFICIENT_DOMAIN_LEVELS;

  aBaseDomain = Substring(iter, end);
  // add on the trailing dot, if applicable
  if (trailingDot)
    aBaseDomain.Append('.');

  return NS_OK;
}

// Normalizes the given hostname, component by component.  ASCII/ACE
// components are lower-cased, and UTF-8 components are normalized per
// RFC 3454 and converted to ACE.
nsresult
nsEffectiveTLDService::NormalizeHostname(nsCString &aHostname)
{
  if (!IsASCII(aHostname)) {
    nsresult rv = mIDNService->ConvertUTF8toACE(aHostname, aHostname);
    if (NS_FAILED(rv))
      return rv;
  }

  ToLowerCase(aHostname);
  return NS_OK;
}
