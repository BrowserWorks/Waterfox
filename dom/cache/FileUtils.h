/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_cache_FileUtils_h
#define mozilla_dom_cache_FileUtils_h

#include "mozilla/Attributes.h"
#include "mozilla/dom/cache/Types.h"
#include "mozIStorageConnection.h"
#include "nsStreamUtils.h"
#include "nsTArrayForwardDeclare.h"

struct nsID;
class nsIFile;

namespace mozilla {
namespace dom {
namespace cache {

#define PADDING_FILE_NAME ".padding"
#define PADDING_TMP_FILE_NAME ".padding-tmp"

enum DirPaddingFile { FILE, TMP_FILE };

nsresult BodyCreateDir(nsIFile* aBaseDir);

// Note that this function can only be used during the initialization of the
// database.  We're unlikely to be able to delete the DB successfully past
// that point due to the file being in use.
nsresult BodyDeleteDir(const QuotaInfo& aQuotaInfo, nsIFile* aBaseDir);

nsresult BodyGetCacheDir(nsIFile* aBaseDir, const nsID& aId,
                         nsIFile** aCacheDirOut);

nsresult BodyStartWriteStream(const QuotaInfo& aQuotaInfo, nsIFile* aBaseDir,
                              nsIInputStream* aSource, void* aClosure,
                              nsAsyncCopyCallbackFun aCallback, nsID* aIdOut,
                              nsISupports** aCopyContextOut);

void BodyCancelWrite(nsIFile* aBaseDir, nsISupports* aCopyContext);

nsresult BodyFinalizeWrite(nsIFile* aBaseDir, const nsID& aId);

nsresult BodyOpen(const QuotaInfo& aQuotaInfo, nsIFile* aBaseDir,
                  const nsID& aId, nsIInputStream** aStreamOut);

nsresult BodyMaybeUpdatePaddingSize(const QuotaInfo& aQuotaInfo,
                                    nsIFile* aBaseDir, const nsID& aId,
                                    const uint32_t aPaddingInfo,
                                    int64_t* aPaddingSizeOut);

nsresult BodyDeleteFiles(const QuotaInfo& aQuotaInfo, nsIFile* aBaseDir,
                         const nsTArray<nsID>& aIdList);

nsresult BodyDeleteOrphanedFiles(const QuotaInfo& aQuotaInfo, nsIFile* aBaseDir,
                                 nsTArray<nsID>& aKnownBodyIdList);

// If aCanRemoveFiles is true, that means we are safe to touch the files which
// can be accessed in other threads.
// If it's not, that means we cannot remove the files which are possible to
// created by other threads. Note that if the files are not expected, we should
// be safe to remove them in any case.
template <typename Func>
nsresult BodyTraverseFiles(const QuotaInfo& aQuotaInfo, nsIFile* aBodyDir,
                           const Func& aHandleFileFunc,
                           const bool aCanRemoveFiles,
                           const bool aTrackQuota = true);

nsresult CreateMarkerFile(const QuotaInfo& aQuotaInfo);

nsresult DeleteMarkerFile(const QuotaInfo& aQuotaInfo);

bool MarkerFileExists(const QuotaInfo& aQuotaInfo);

nsresult RemoveNsIFileRecursively(const QuotaInfo& aQuotaInfo, nsIFile* aFile,
                                  const bool aTrackQuota = true);

nsresult RemoveNsIFile(const QuotaInfo& aQuotaInfo, nsIFile* aFile,
                       const bool aTrackQuota = true);

void DecreaseUsageForQuotaInfo(const QuotaInfo& aQuotaInfo,
                               const int64_t& aUpdatingSize);

/**
 * This function is used to check if the directory padding file is existed.
 */

bool DirectoryPaddingFileExists(nsIFile* aBaseDir,
                                DirPaddingFile aPaddingFileType);

/**
 *
 * The functions below are used to read/write/delete the directory padding file
 * after acquiring the mutex lock. The mutex lock is held by
 * CacheQuotaClient to prevent multi-thread accessing issue. To avoid deadlock,
 * these functions should only access by static functions in
 * dom/cache/QuotaClient.cpp.
 *
 */

nsresult LockedDirectoryPaddingGet(nsIFile* aBaseDir, int64_t* aPaddingSizeOut);

nsresult LockedDirectoryPaddingInit(nsIFile* aBaseDir);

nsresult LockedUpdateDirectoryPaddingFile(nsIFile* aBaseDir,
                                          mozIStorageConnection* aConn,
                                          const int64_t aIncreaseSize,
                                          const int64_t aDecreaseSize,
                                          const bool aTemporaryFileExist);

nsresult LockedDirectoryPaddingTemporaryWrite(nsIFile* aBaseDir,
                                              int64_t aPaddingSize);

nsresult LockedDirectoryPaddingFinalizeWrite(nsIFile* aBaseDir);

nsresult LockedDirectoryPaddingRestore(nsIFile* aBaseDir,
                                       mozIStorageConnection* aConn,
                                       bool aMustRestore,
                                       int64_t* aPaddingSizeOut);

nsresult LockedDirectoryPaddingDeleteFile(nsIFile* aBaseDir,
                                          DirPaddingFile aPaddingFileType);
}  // namespace cache
}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_cache_FileUtils_h
