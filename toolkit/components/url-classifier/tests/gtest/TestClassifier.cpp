/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "Common.h"
#include "Classifier.h"
#include "LookupCacheV4.h"

#define GTEST_TABLE_V4 NS_LITERAL_CSTRING("gtest-malware-proto")
#define GTEST_TABLE_V2 NS_LITERAL_CSTRING("gtest-malware-simple")

typedef nsCString _Fragment;
typedef nsTArray<nsCString> _PrefixArray;

static UniquePtr<Classifier>
GetClassifier()
{
  nsCOMPtr<nsIFile> file;
  NS_GetSpecialDirectory(NS_APP_USER_PROFILE_50_DIR, getter_AddRefs(file));

  UniquePtr<Classifier> classifier = MakeUnique<Classifier>();
  nsresult rv = classifier->Open(*file);
  EXPECT_TRUE(rv == NS_OK);

  return Move(classifier);
}

static nsresult
SetupLookupCacheV4(Classifier* classifier,
                   const _PrefixArray& aPrefixArray,
                   const nsACString& aTable)
{
  LookupCacheV4* lookupCache =
    LookupCache::Cast<LookupCacheV4>(classifier->GetLookupCache(aTable, false));
  if (!lookupCache) {
    return NS_ERROR_FAILURE;
  }

  PrefixStringMap map;
  PrefixArrayToPrefixStringMap(aPrefixArray, map);

  return lookupCache->Build(map);
}

static nsresult
SetupLookupCacheV2(Classifier* classifier,
                   const _PrefixArray& aPrefixArray,
                   const nsACString& aTable)
{
  LookupCacheV2* lookupCache =
    LookupCache::Cast<LookupCacheV2>(classifier->GetLookupCache(aTable, false));
  if (!lookupCache) {
    return NS_ERROR_FAILURE;
  }

  AddPrefixArray prefixes;
  AddCompleteArray completions;
  nsresult rv = PrefixArrayToAddPrefixArrayV2(aPrefixArray, prefixes);
  if (NS_FAILED(rv)) {
    return rv;
  }

  EntrySort(prefixes);
  return lookupCache->Build(prefixes, completions);
}

static void
TestReadNoiseEntries(Classifier* classifier,
                     const _PrefixArray& aPrefixArray,
                     const nsCString& aTable,
                     const nsCString& aFragment)
{
  Completion lookupHash;
  lookupHash.FromPlaintext(aFragment);
  LookupResult result;
  result.hash.complete = lookupHash;

  PrefixArray noiseEntries;
  uint32_t noiseCount = 3;
  nsresult rv;
  rv = classifier->ReadNoiseEntries(result.hash.fixedLengthPrefix,
                                    aTable, noiseCount,
                                    &noiseEntries);
  ASSERT_TRUE(rv == NS_OK);
  EXPECT_TRUE(noiseEntries.Length() > 0);

  for (uint32_t i = 0; i < noiseEntries.Length(); i++) {
    // Test the noise entry should not equal the "real" hash request
    EXPECT_NE(noiseEntries[i], result.hash.fixedLengthPrefix);
    // Test the noise entry should exist in the cached prefix array
    nsAutoCString partialHash;
    partialHash.Assign(reinterpret_cast<char*>(&noiseEntries[i]), PREFIX_SIZE);
    EXPECT_TRUE(aPrefixArray.Contains(partialHash));
  }

}

TEST(Classifier, ReadNoiseEntriesV4)
{
  UniquePtr<Classifier> classifier(GetClassifier());
  _PrefixArray array = { GeneratePrefix(_Fragment("bravo.com/"), 5),
                         GeneratePrefix(_Fragment("browsing.com/"), 9),
                         GeneratePrefix(_Fragment("gound.com/"), 4),
                         GeneratePrefix(_Fragment("small.com/"), 4),
                         GeneratePrefix(_Fragment("gdfad.com/"), 4),
                         GeneratePrefix(_Fragment("afdfound.com/"), 4),
                         GeneratePrefix(_Fragment("dffa.com/"), 4),
                       };
  array.Sort();

  nsresult rv;
  rv = SetupLookupCacheV4(classifier.get(), array, GTEST_TABLE_V4);
  ASSERT_TRUE(rv == NS_OK);

  TestReadNoiseEntries(classifier.get(), array, GTEST_TABLE_V4, _Fragment("gound.com/"));
}

TEST(Classifier, ReadNoiseEntriesV2)
{
  UniquePtr<Classifier> classifier(GetClassifier());
  _PrefixArray array = { GeneratePrefix(_Fragment("helloworld.com/"), 4),
                         GeneratePrefix(_Fragment("firefox.com/"), 4),
                         GeneratePrefix(_Fragment("chrome.com/"), 4),
                         GeneratePrefix(_Fragment("safebrowsing.com/"), 4),
                         GeneratePrefix(_Fragment("opera.com/"), 4),
                         GeneratePrefix(_Fragment("torbrowser.com/"), 4),
                         GeneratePrefix(_Fragment("gfaads.com/"), 4),
                         GeneratePrefix(_Fragment("qggdsas.com/"), 4),
                         GeneratePrefix(_Fragment("nqtewq.com/"), 4),
                       };

  nsresult rv;
  rv = SetupLookupCacheV2(classifier.get(), array, GTEST_TABLE_V2);
  ASSERT_TRUE(rv == NS_OK);

  TestReadNoiseEntries(classifier.get(), array, GTEST_TABLE_V2, _Fragment("helloworld.com/"));
}
