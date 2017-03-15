/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GMPUtils_h_
#define GMPUtils_h_

#include "mozilla/UniquePtr.h"
#include "nsTArray.h"
#include "nsCOMPtr.h"
#include "nsClassHashtable.h"

class nsIFile;
class nsCString;
class nsISimpleEnumerator;

namespace mozilla {

template<typename T>
struct DestroyPolicy
{
  void operator()(T* aGMPObject) const {
    aGMPObject->Destroy();
  }
};

template<typename T>
using GMPUniquePtr = mozilla::UniquePtr<T, DestroyPolicy<T>>;

bool GetEMEVoucherPath(nsIFile** aPath);

bool EMEVoucherFileExists();

void
SplitAt(const char* aDelims,
        const nsACString& aInput,
        nsTArray<nsCString>& aOutTokens);

nsCString
ToBase64(const nsTArray<uint8_t>& aBytes);

bool
FileExists(nsIFile* aFile);

// Enumerate directory entries for a specified path.
class DirectoryEnumerator {
public:

  enum Mode {
    DirsOnly, // Enumeration only includes directories.
    FilesAndDirs // Enumeration includes directories and non-directory files.
  };

  DirectoryEnumerator(nsIFile* aPath, Mode aMode);

  already_AddRefed<nsIFile> Next();

private:
  Mode mMode;
  nsCOMPtr<nsISimpleEnumerator> mIter;
};

class GMPInfoFileParser {
public:
  bool Init(nsIFile* aFile);
  bool Contains(const nsCString& aKey) const;
  nsCString Get(const nsCString& aKey) const;
private:
  nsClassHashtable<nsCStringHashKey, nsCString> mValues;
};

bool
ReadIntoArray(nsIFile* aFile,
              nsTArray<uint8_t>& aOutDst,
              size_t aMaxLength);

bool
ReadIntoString(nsIFile* aFile,
               nsCString& aOutDst,
               size_t aMaxLength);

bool
HaveGMPFor(const nsCString& aAPI,
           nsTArray<nsCString>&& aTags);

} // namespace mozilla

#endif
