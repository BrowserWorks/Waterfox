//* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
// Originally based on Chrome sources:
// Copyright (c) 2010 The Chromium Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//    * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//    * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#include "HashStore.h"
#include "nsICryptoHash.h"
#include "nsISeekableStream.h"
#include "nsIStreamConverterService.h"
#include "nsNetUtil.h"
#include "nsCheckSummedOutputStream.h"
#include "prio.h"
#include "mozilla/Logging.h"
#include "zlib.h"
#include "Classifier.h"

// Main store for SafeBrowsing protocol data. We store
// known add/sub chunks, prefixes and completions in memory
// during an update, and serialize to disk.
// We do not store the add prefixes, those are retrieved by
// decompressing the PrefixSet cache whenever we need to apply
// an update.
//
// byte slicing: Many of the 4-byte values stored here are strongly
// correlated in the upper bytes, and uncorrelated in the lower
// bytes. Because zlib/DEFLATE requires match lengths of at least
// 3 to achieve good compression, and we don't get those if only
// the upper 16-bits are correlated, it is worthwhile to slice 32-bit
// values into 4 1-byte slices and compress the slices individually.
// The slices corresponding to MSBs will compress very well, and the
// slice corresponding to LSB almost nothing. Because of this, we
// only apply DEFLATE to the 3 most significant bytes, and store the
// LSB uncompressed.
//
// byte sliced (numValues) data format:
//    uint32_t compressed-size
//    compressed-size bytes    zlib DEFLATE data
//        0...numValues        byte MSB of 4-byte numValues data
//    uint32_t compressed-size
//    compressed-size bytes    zlib DEFLATE data
//        0...numValues        byte 2nd byte of 4-byte numValues data
//    uint32_t compressed-size
//    compressed-size bytes    zlib DEFLATE data
//        0...numValues        byte 3rd byte of 4-byte numValues data
//    0...numValues            byte LSB of 4-byte numValues data
//
// Store data format:
//    uint32_t magic
//    uint32_t version
//    uint32_t numAddChunks
//    uint32_t numSubChunks
//    uint32_t numAddPrefixes
//    uint32_t numSubPrefixes
//    uint32_t numAddCompletes
//    uint32_t numSubCompletes
//    0...numAddChunks               uint32_t addChunk
//    0...numSubChunks               uint32_t subChunk
//    byte sliced (numAddPrefixes)   uint32_t add chunk of AddPrefixes
//    byte sliced (numSubPrefixes)   uint32_t add chunk of SubPrefixes
//    byte sliced (numSubPrefixes)   uint32_t sub chunk of SubPrefixes
//    byte sliced (numSubPrefixes)   uint32_t SubPrefixes
//    0...numAddCompletes            32-byte Completions + uint32_t addChunk
//    0...numSubCompletes            32-byte Completions + uint32_t addChunk
//                                                       + uint32_t subChunk
//    16-byte MD5 of all preceding data

// Name of the SafeBrowsing store
#define STORE_SUFFIX ".sbstore"

// MOZ_LOG=UrlClassifierDbService:5
extern mozilla::LazyLogModule gUrlClassifierDbServiceLog;
#define LOG(args) MOZ_LOG(gUrlClassifierDbServiceLog, mozilla::LogLevel::Debug, args)
#define LOG_ENABLED() MOZ_LOG_TEST(gUrlClassifierDbServiceLog, mozilla::LogLevel::Debug)

// Either the return was successful or we call the Reset function (unless we
// hit an OOM).  Used while reading in the store.
#define SUCCESS_OR_RESET(res)                                             \
  do {                                                                    \
    nsresult __rv = res; /* Don't evaluate |res| more than once */        \
    if (__rv == NS_ERROR_OUT_OF_MEMORY) {                                 \
      NS_WARNING("SafeBrowsing OOM.");                                    \
      return __rv;                                                        \
    }                                                                     \
    if (NS_FAILED(__rv)) {                                                \
      NS_WARNING("SafeBrowsing store corrupted or out of date.");         \
      Reset();                                                            \
      return __rv;                                                        \
    }                                                                     \
  } while(0)

namespace mozilla {
namespace safebrowsing {

const uint32_t STORE_MAGIC = 0x1231af3b;
const uint32_t CURRENT_VERSION = 3;

nsresult
TableUpdateV2::NewAddPrefix(uint32_t aAddChunk, const Prefix& aHash)
{
  AddPrefix *add = mAddPrefixes.AppendElement(fallible);
  if (!add) return NS_ERROR_OUT_OF_MEMORY;
  add->addChunk = aAddChunk;
  add->prefix = aHash;
  return NS_OK;
}

nsresult
TableUpdateV2::NewSubPrefix(uint32_t aAddChunk, const Prefix& aHash, uint32_t aSubChunk)
{
  SubPrefix *sub = mSubPrefixes.AppendElement(fallible);
  if (!sub) return NS_ERROR_OUT_OF_MEMORY;
  sub->addChunk = aAddChunk;
  sub->prefix = aHash;
  sub->subChunk = aSubChunk;
  return NS_OK;
}

nsresult
TableUpdateV2::NewAddComplete(uint32_t aAddChunk, const Completion& aHash)
{
  AddComplete *add = mAddCompletes.AppendElement(fallible);
  if (!add) return NS_ERROR_OUT_OF_MEMORY;
  add->addChunk = aAddChunk;
  add->complete = aHash;
  return NS_OK;
}

nsresult
TableUpdateV2::NewSubComplete(uint32_t aAddChunk, const Completion& aHash, uint32_t aSubChunk)
{
  SubComplete *sub = mSubCompletes.AppendElement(fallible);
  if (!sub) return NS_ERROR_OUT_OF_MEMORY;
  sub->addChunk = aAddChunk;
  sub->complete = aHash;
  sub->subChunk = aSubChunk;
  return NS_OK;
}

void
TableUpdateV4::NewPrefixes(int32_t aSize, std::string& aPrefixes)
{
  NS_ENSURE_TRUE_VOID(aPrefixes.size() % aSize == 0);
  NS_ENSURE_TRUE_VOID(!mPrefixesMap.Get(aSize));

  if (LOG_ENABLED() && 4 == aSize) {
    int numOfPrefixes = aPrefixes.size() / 4;
    uint32_t* p = (uint32_t*)aPrefixes.c_str();

    // Dump the first/last 10 fixed-length prefixes for debugging.
    LOG(("* The first 10 (maximum) fixed-length prefixes: "));
    for (int i = 0; i < std::min(10, numOfPrefixes); i++) {
      uint8_t* c = (uint8_t*)&p[i];
      LOG(("%.2X%.2X%.2X%.2X", c[0], c[1], c[2], c[3]));
    }

    LOG(("* The last 10 (maximum) fixed-length prefixes: "));
    for (int i = std::max(0, numOfPrefixes - 10); i < numOfPrefixes; i++) {
      uint8_t* c = (uint8_t*)&p[i];
      LOG(("%.2X%.2X%.2X%.2X", c[0], c[1], c[2], c[3]));
    }

    LOG(("---- %d fixed-length prefixes in total.", aPrefixes.size() / aSize));
  }

  PrefixStdString* prefix = new PrefixStdString(aPrefixes);
  mPrefixesMap.Put(aSize, prefix);
}

void
TableUpdateV4::NewRemovalIndices(const uint32_t* aIndices, size_t aNumOfIndices)
{
  for (size_t i = 0; i < aNumOfIndices; i++) {
    mRemovalIndiceArray.AppendElement(aIndices[i]);
  }
}

void
TableUpdateV4::NewChecksum(const std::string& aChecksum)
{
  mChecksum.Assign(aChecksum.data(), aChecksum.size());
}

HashStore::HashStore(const nsACString& aTableName,
                     const nsACString& aProvider,
                     nsIFile* aRootStoreDir)
  : mTableName(aTableName)
  , mInUpdate(false)
  , mFileSize(0)
{
  nsresult rv = Classifier::GetPrivateStoreDirectory(aRootStoreDir,
                                                     aTableName,
                                                     aProvider,
                                                     getter_AddRefs(mStoreDirectory));
  if (NS_FAILED(rv)) {
    LOG(("Failed to get private store directory for %s", mTableName.get()));
    mStoreDirectory = aRootStoreDir;
  }
}

HashStore::~HashStore()
{
}

nsresult
HashStore::Reset()
{
  LOG(("HashStore resetting"));

  nsCOMPtr<nsIFile> storeFile;
  nsresult rv = mStoreDirectory->Clone(getter_AddRefs(storeFile));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = storeFile->AppendNative(mTableName + NS_LITERAL_CSTRING(STORE_SUFFIX));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = storeFile->Remove(false);
  NS_ENSURE_SUCCESS(rv, rv);

  mFileSize = 0;

  return NS_OK;
}

nsresult
HashStore::CheckChecksum(uint32_t aFileSize)
{
  if (!mInputStream) {
    return NS_OK;
  }

  // Check for file corruption by
  // comparing the stored checksum to actual checksum of data
  nsAutoCString hash;
  nsAutoCString compareHash;
  char *data;
  uint32_t read;

  nsresult rv = CalculateChecksum(hash, aFileSize, true);
  NS_ENSURE_SUCCESS(rv, rv);

  compareHash.GetMutableData(&data, hash.Length());

  if (hash.Length() > aFileSize) {
    NS_WARNING("SafeBrowing file not long enough to store its hash");
    return NS_ERROR_FAILURE;
  }
  nsCOMPtr<nsISeekableStream> seekIn = do_QueryInterface(mInputStream);
  rv = seekIn->Seek(nsISeekableStream::NS_SEEK_SET, aFileSize - hash.Length());
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mInputStream->Read(data, hash.Length(), &read);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ASSERTION(read == hash.Length(), "Could not read hash bytes");

  if (!hash.Equals(compareHash)) {
    NS_WARNING("Safebrowing file failed checksum.");
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
HashStore::Open()
{
  nsCOMPtr<nsIFile> storeFile;
  nsresult rv = mStoreDirectory->Clone(getter_AddRefs(storeFile));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = storeFile->AppendNative(mTableName + NS_LITERAL_CSTRING(".sbstore"));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIInputStream> origStream;
  rv = NS_NewLocalFileInputStream(getter_AddRefs(origStream), storeFile,
                                  PR_RDONLY | nsIFile::OS_READAHEAD);

  if (rv == NS_ERROR_FILE_NOT_FOUND) {
    UpdateHeader();
    return NS_OK;
  } else {
    SUCCESS_OR_RESET(rv);
  }

  int64_t fileSize;
  rv = storeFile->GetFileSize(&fileSize);
  NS_ENSURE_SUCCESS(rv, rv);

  if (fileSize < 0 || fileSize > UINT32_MAX) {
    return NS_ERROR_FAILURE;
  }

  mFileSize = static_cast<uint32_t>(fileSize);
  mInputStream = NS_BufferInputStream(origStream, mFileSize);

  rv = ReadHeader();
  SUCCESS_OR_RESET(rv);

  rv = SanityCheck();
  SUCCESS_OR_RESET(rv);

  return NS_OK;
}

nsresult
HashStore::ReadHeader()
{
  if (!mInputStream) {
    UpdateHeader();
    return NS_OK;
  }

  nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mInputStream);
  nsresult rv = seekable->Seek(nsISeekableStream::NS_SEEK_SET, 0);
  NS_ENSURE_SUCCESS(rv, rv);

  void *buffer = &mHeader;
  rv = NS_ReadInputStreamToBuffer(mInputStream,
                                  &buffer,
                                  sizeof(Header));
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

nsresult
HashStore::SanityCheck()
{
  if (mHeader.magic != STORE_MAGIC || mHeader.version != CURRENT_VERSION) {
    NS_WARNING("Unexpected header data in the store.");
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
HashStore::CalculateChecksum(nsAutoCString& aChecksum,
                             uint32_t aFileSize,
                             bool aChecksumPresent)
{
  aChecksum.Truncate();

  // Reset mInputStream to start
  nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mInputStream);
  nsresult rv = seekable->Seek(nsISeekableStream::NS_SEEK_SET, 0);

  nsCOMPtr<nsICryptoHash> hash = do_CreateInstance(NS_CRYPTO_HASH_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  // Size of MD5 hash in bytes
  const uint32_t CHECKSUM_SIZE = 16;

  // MD5 is not a secure hash function, but since this is a filesystem integrity
  // check, this usage is ok.
  rv = hash->Init(nsICryptoHash::MD5);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!aChecksumPresent) {
    // Hash entire file
    rv = hash->UpdateFromStream(mInputStream, UINT32_MAX);
  } else {
    // Hash everything but last checksum bytes
    if (aFileSize < CHECKSUM_SIZE) {
      NS_WARNING("SafeBrowsing file isn't long enough to store its checksum");
      return NS_ERROR_FAILURE;
    }
    rv = hash->UpdateFromStream(mInputStream, aFileSize - CHECKSUM_SIZE);
  }
  NS_ENSURE_SUCCESS(rv, rv);

  rv = hash->Finish(false, aChecksum);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

void
HashStore::UpdateHeader()
{
  mHeader.magic = STORE_MAGIC;
  mHeader.version = CURRENT_VERSION;

  mHeader.numAddChunks = mAddChunks.Length();
  mHeader.numSubChunks = mSubChunks.Length();
  mHeader.numAddPrefixes = mAddPrefixes.Length();
  mHeader.numSubPrefixes = mSubPrefixes.Length();
  mHeader.numAddCompletes = mAddCompletes.Length();
  mHeader.numSubCompletes = mSubCompletes.Length();
}

nsresult
HashStore::ReadChunkNumbers()
{
  if (!mInputStream || AlreadyReadChunkNumbers()) {
    return NS_OK;
  }

  nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mInputStream);
  nsresult rv = seekable->Seek(nsISeekableStream::NS_SEEK_SET,
                               sizeof(Header));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mAddChunks.Read(mInputStream, mHeader.numAddChunks);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ASSERTION(mAddChunks.Length() == mHeader.numAddChunks, "Read the right amount of add chunks.");

  rv = mSubChunks.Read(mInputStream, mHeader.numSubChunks);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ASSERTION(mSubChunks.Length() == mHeader.numSubChunks, "Read the right amount of sub chunks.");

  return NS_OK;
}

nsresult
HashStore::ReadHashes()
{
  if (!mInputStream) {
    // BeginUpdate has been called but Open hasn't initialized mInputStream,
    // because the existing HashStore is empty.
    return NS_OK;
  }

  nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mInputStream);

  uint32_t offset = sizeof(Header);
  offset += (mHeader.numAddChunks + mHeader.numSubChunks) * sizeof(uint32_t);
  nsresult rv = seekable->Seek(nsISeekableStream::NS_SEEK_SET, offset);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadAddPrefixes();
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadSubPrefixes();
  NS_ENSURE_SUCCESS(rv, rv);

  // If completions was read before, then we are done here.
  if (AlreadyReadCompletions()) {
    return NS_OK;
  }

  rv = ReadTArray(mInputStream, &mAddCompletes, mHeader.numAddCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadTArray(mInputStream, &mSubCompletes, mHeader.numSubCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}


nsresult
HashStore::ReadCompletions()
{
  if (!mInputStream || AlreadyReadCompletions()) {
    return NS_OK;
  }

  nsCOMPtr<nsIFile> storeFile;
  nsresult rv = mStoreDirectory->Clone(getter_AddRefs(storeFile));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = storeFile->AppendNative(mTableName + NS_LITERAL_CSTRING(STORE_SUFFIX));
  NS_ENSURE_SUCCESS(rv, rv);

  uint32_t offset = mFileSize -
                    sizeof(struct AddComplete) * mHeader.numAddCompletes -
                    sizeof(struct SubComplete) * mHeader.numSubCompletes -
                    nsCheckSummedOutputStream::CHECKSUM_SIZE;

  nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mInputStream);

  rv = seekable->Seek(nsISeekableStream::NS_SEEK_SET, offset);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadTArray(mInputStream, &mAddCompletes, mHeader.numAddCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadTArray(mInputStream, &mSubCompletes, mHeader.numSubCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

nsresult
HashStore::PrepareForUpdate()
{
  nsresult rv = CheckChecksum(mFileSize);
  SUCCESS_OR_RESET(rv);

  rv = ReadChunkNumbers();
  SUCCESS_OR_RESET(rv);

  rv = ReadHashes();
  SUCCESS_OR_RESET(rv);

  return NS_OK;
}

nsresult
HashStore::BeginUpdate()
{
  // Check wether the file is corrupted and read the rest of the store
  // in memory.
  nsresult rv = PrepareForUpdate();
  NS_ENSURE_SUCCESS(rv, rv);

  // Close input stream, won't be needed any more and
  // we will rewrite ourselves.
  if (mInputStream) {
    rv = mInputStream->Close();
    NS_ENSURE_SUCCESS(rv, rv);
  }

  mInUpdate = true;

  return NS_OK;
}

template<class T>
static nsresult
Merge(ChunkSet* aStoreChunks,
      FallibleTArray<T>* aStorePrefixes,
      ChunkSet& aUpdateChunks,
      FallibleTArray<T>& aUpdatePrefixes,
      bool aAllowMerging = false)
{
  EntrySort(aUpdatePrefixes);

  T* updateIter = aUpdatePrefixes.Elements();
  T* updateEnd = aUpdatePrefixes.Elements() + aUpdatePrefixes.Length();

  T* storeIter = aStorePrefixes->Elements();
  T* storeEnd = aStorePrefixes->Elements() + aStorePrefixes->Length();

  // use a separate array so we can keep the iterators valid
  // if the nsTArray grows
  nsTArray<T> adds;

  for (; updateIter != updateEnd; updateIter++) {
    // skip this chunk if we already have it, unless we're
    // merging completions, in which case we'll always already
    // have the chunk from the original prefix
    if (aStoreChunks->Has(updateIter->Chunk()))
      if (!aAllowMerging)
        continue;
    // XXX: binary search for insertion point might be faster in common
    // case?
    while (storeIter < storeEnd && (storeIter->Compare(*updateIter) < 0)) {
      // skip forward to matching element (or not...)
      storeIter++;
    }
    // no match, add
    if (storeIter == storeEnd
        || storeIter->Compare(*updateIter) != 0) {
      if (!adds.AppendElement(*updateIter))
        return NS_ERROR_OUT_OF_MEMORY;
    }
  }

  // Chunks can be empty, but we should still report we have them
  // to make the chunkranges continuous.
  aStoreChunks->Merge(aUpdateChunks);

  if (!aStorePrefixes->AppendElements(adds, fallible))
    return NS_ERROR_OUT_OF_MEMORY;

  EntrySort(*aStorePrefixes);

  return NS_OK;
}

nsresult
HashStore::ApplyUpdate(TableUpdate &aUpdate)
{
  auto updateV2 = TableUpdate::Cast<TableUpdateV2>(&aUpdate);
  NS_ENSURE_TRUE(updateV2, NS_ERROR_FAILURE);

  TableUpdateV2& update = *updateV2;

  nsresult rv = mAddExpirations.Merge(update.AddExpirations());
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mSubExpirations.Merge(update.SubExpirations());
  NS_ENSURE_SUCCESS(rv, rv);

  rv = Expire();
  NS_ENSURE_SUCCESS(rv, rv);

  rv = Merge(&mAddChunks, &mAddPrefixes,
             update.AddChunks(), update.AddPrefixes());
  NS_ENSURE_SUCCESS(rv, rv);

  rv = Merge(&mAddChunks, &mAddCompletes,
             update.AddChunks(), update.AddCompletes(), true);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = Merge(&mSubChunks, &mSubPrefixes,
             update.SubChunks(), update.SubPrefixes());
  NS_ENSURE_SUCCESS(rv, rv);

  rv = Merge(&mSubChunks, &mSubCompletes,
             update.SubChunks(), update.SubCompletes(), true);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

nsresult
HashStore::Rebuild()
{
  NS_ASSERTION(mInUpdate, "Must be in update to rebuild.");

  nsresult rv = ProcessSubs();
  NS_ENSURE_SUCCESS(rv, rv);

  UpdateHeader();

  return NS_OK;
}

void
HashStore::ClearCompletes()
{
  NS_ASSERTION(mInUpdate, "Must be in update to clear completes.");

  mAddCompletes.Clear();
  mSubCompletes.Clear();

  UpdateHeader();
}

template<class T>
static void
ExpireEntries(FallibleTArray<T>* aEntries, ChunkSet& aExpirations)
{
  T* addIter = aEntries->Elements();
  T* end = aEntries->Elements() + aEntries->Length();

  for (T *iter = addIter; iter != end; iter++) {
    if (!aExpirations.Has(iter->Chunk())) {
      *addIter = *iter;
      addIter++;
    }
  }

  aEntries->TruncateLength(addIter - aEntries->Elements());
}

nsresult
HashStore::Expire()
{
  ExpireEntries(&mAddPrefixes, mAddExpirations);
  ExpireEntries(&mAddCompletes, mAddExpirations);
  ExpireEntries(&mSubPrefixes, mSubExpirations);
  ExpireEntries(&mSubCompletes, mSubExpirations);

  mAddChunks.Remove(mAddExpirations);
  mSubChunks.Remove(mSubExpirations);

  mAddExpirations.Clear();
  mSubExpirations.Clear();

  return NS_OK;
}

template<class T>
nsresult DeflateWriteTArray(nsIOutputStream* aStream, nsTArray<T>& aIn)
{
  uLongf insize = aIn.Length() * sizeof(T);
  uLongf outsize = compressBound(insize);
  FallibleTArray<char> outBuff;
  if (!outBuff.SetLength(outsize, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  int zerr = compress(reinterpret_cast<Bytef*>(outBuff.Elements()),
                      &outsize,
                      reinterpret_cast<const Bytef*>(aIn.Elements()),
                      insize);
  if (zerr != Z_OK) {
    return NS_ERROR_FAILURE;
  }
  LOG(("DeflateWriteTArray: %d in %d out", insize, outsize));

  outBuff.TruncateLength(outsize);

  // Length of compressed data stream
  uint32_t dataLen = outBuff.Length();
  uint32_t written;
  nsresult rv = aStream->Write(reinterpret_cast<char*>(&dataLen), sizeof(dataLen), &written);
  NS_ENSURE_SUCCESS(rv, rv);

  NS_ASSERTION(written == sizeof(dataLen), "Error writing deflate length");

  // Store to stream
  rv = WriteTArray(aStream, outBuff);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

template<class T>
nsresult InflateReadTArray(nsIInputStream* aStream, FallibleTArray<T>* aOut,
                           uint32_t aExpectedSize)
{

  uint32_t inLen;
  uint32_t read;
  nsresult rv = aStream->Read(reinterpret_cast<char*>(&inLen), sizeof(inLen), &read);
  NS_ENSURE_SUCCESS(rv, rv);

  NS_ASSERTION(read == sizeof(inLen), "Error reading inflate length");

  FallibleTArray<char> inBuff;
  if (!inBuff.SetLength(inLen, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  rv = ReadTArray(aStream, &inBuff, inLen);
  NS_ENSURE_SUCCESS(rv, rv);

  uLongf insize = inLen;
  uLongf outsize = aExpectedSize * sizeof(T);
  if (!aOut->SetLength(aExpectedSize, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  int zerr = uncompress(reinterpret_cast<Bytef*>(aOut->Elements()),
                        &outsize,
                        reinterpret_cast<const Bytef*>(inBuff.Elements()),
                        insize);
  if (zerr != Z_OK) {
    return NS_ERROR_FAILURE;
  }
  LOG(("InflateReadTArray: %d in %d out", insize, outsize));

  NS_ASSERTION(outsize == aExpectedSize * sizeof(T), "Decompression size mismatch");

  return NS_OK;
}

static nsresult
ByteSliceWrite(nsIOutputStream* aOut, nsTArray<uint32_t>& aData)
{
  nsTArray<uint8_t> slice;
  uint32_t count = aData.Length();

  // Only process one slice at a time to avoid using too much memory.
  if (!slice.SetLength(count, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  // Process slice 1.
  for (uint32_t i = 0; i < count; i++) {
    slice[i] = (aData[i] >> 24);
  }

  nsresult rv = DeflateWriteTArray(aOut, slice);
  NS_ENSURE_SUCCESS(rv, rv);

  // Process slice 2.
  for (uint32_t i = 0; i < count; i++) {
    slice[i] = ((aData[i] >> 16) & 0xFF);
  }

  rv = DeflateWriteTArray(aOut, slice);
  NS_ENSURE_SUCCESS(rv, rv);

  // Process slice 3.
  for (uint32_t i = 0; i < count; i++) {
    slice[i] = ((aData[i] >> 8) & 0xFF);
  }

  rv = DeflateWriteTArray(aOut, slice);
  NS_ENSURE_SUCCESS(rv, rv);

  // Process slice 4.
  for (uint32_t i = 0; i < count; i++) {
    slice[i] = (aData[i] & 0xFF);
  }

  // The LSB slice is generally uncompressible, don't bother
  // compressing it.
  rv = WriteTArray(aOut, slice);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

static nsresult
ByteSliceRead(nsIInputStream* aInStream, FallibleTArray<uint32_t>* aData, uint32_t count)
{
  FallibleTArray<uint8_t> slice1;
  FallibleTArray<uint8_t> slice2;
  FallibleTArray<uint8_t> slice3;
  FallibleTArray<uint8_t> slice4;

  nsresult rv = InflateReadTArray(aInStream, &slice1, count);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = InflateReadTArray(aInStream, &slice2, count);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = InflateReadTArray(aInStream, &slice3, count);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ReadTArray(aInStream, &slice4, count);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!aData->SetCapacity(count, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  for (uint32_t i = 0; i < count; i++) {
    aData->AppendElement((slice1[i] << 24) |
                           (slice2[i] << 16) |
                           (slice3[i] << 8) |
                           (slice4[i]),
                         fallible);
  }

  return NS_OK;
}

nsresult
HashStore::ReadAddPrefixes()
{
  FallibleTArray<uint32_t> chunks;
  uint32_t count = mHeader.numAddPrefixes;

  nsresult rv = ByteSliceRead(mInputStream, &chunks, count);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!mAddPrefixes.SetCapacity(count, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  for (uint32_t i = 0; i < count; i++) {
    AddPrefix *add = mAddPrefixes.AppendElement(fallible);
    add->prefix.FromUint32(0);
    add->addChunk = chunks[i];
  }

  return NS_OK;
}

nsresult
HashStore::ReadSubPrefixes()
{
  FallibleTArray<uint32_t> addchunks;
  FallibleTArray<uint32_t> subchunks;
  FallibleTArray<uint32_t> prefixes;
  uint32_t count = mHeader.numSubPrefixes;

  nsresult rv = ByteSliceRead(mInputStream, &addchunks, count);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ByteSliceRead(mInputStream, &subchunks, count);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ByteSliceRead(mInputStream, &prefixes, count);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!mSubPrefixes.SetCapacity(count, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  for (uint32_t i = 0; i < count; i++) {
    SubPrefix *sub = mSubPrefixes.AppendElement(fallible);
    sub->addChunk = addchunks[i];
    sub->prefix.FromUint32(prefixes[i]);
    sub->subChunk = subchunks[i];
  }

  return NS_OK;
}

// Split up PrefixArray back into the constituents
nsresult
HashStore::WriteAddPrefixes(nsIOutputStream* aOut)
{
  nsTArray<uint32_t> chunks;
  uint32_t count = mAddPrefixes.Length();
  if (!chunks.SetCapacity(count, fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  for (uint32_t i = 0; i < count; i++) {
    chunks.AppendElement(mAddPrefixes[i].Chunk());
  }

  nsresult rv = ByteSliceWrite(aOut, chunks);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

nsresult
HashStore::WriteSubPrefixes(nsIOutputStream* aOut)
{
  nsTArray<uint32_t> addchunks;
  nsTArray<uint32_t> subchunks;
  nsTArray<uint32_t> prefixes;
  uint32_t count = mSubPrefixes.Length();
  addchunks.SetCapacity(count);
  subchunks.SetCapacity(count);
  prefixes.SetCapacity(count);

  for (uint32_t i = 0; i < count; i++) {
    addchunks.AppendElement(mSubPrefixes[i].AddChunk());
    prefixes.AppendElement(mSubPrefixes[i].PrefixHash().ToUint32());
    subchunks.AppendElement(mSubPrefixes[i].Chunk());
  }

  nsresult rv = ByteSliceWrite(aOut, addchunks);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ByteSliceWrite(aOut, subchunks);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = ByteSliceWrite(aOut, prefixes);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

nsresult
HashStore::WriteFile()
{
  NS_ASSERTION(mInUpdate, "Must be in update to write database.");

  nsCOMPtr<nsIFile> storeFile;
  nsresult rv = mStoreDirectory->Clone(getter_AddRefs(storeFile));
  NS_ENSURE_SUCCESS(rv, rv);
  rv = storeFile->AppendNative(mTableName + NS_LITERAL_CSTRING(".sbstore"));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIOutputStream> out;
  rv = NS_NewCheckSummedOutputStream(getter_AddRefs(out), storeFile,
                                     PR_WRONLY | PR_TRUNCATE | PR_CREATE_FILE);
  NS_ENSURE_SUCCESS(rv, rv);

  uint32_t written;
  rv = out->Write(reinterpret_cast<char*>(&mHeader), sizeof(mHeader), &written);
  NS_ENSURE_SUCCESS(rv, rv);

  // Write chunk numbers.
  rv = mAddChunks.Write(out);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mSubChunks.Write(out);
  NS_ENSURE_SUCCESS(rv, rv);

  // Write hashes.
  rv = WriteAddPrefixes(out);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = WriteSubPrefixes(out);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = WriteTArray(out, mAddCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = WriteTArray(out, mSubCompletes);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISafeOutputStream> safeOut = do_QueryInterface(out, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = safeOut->Finish();
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

template <class T>
static void
Erase(FallibleTArray<T>* array, T* iterStart, T* iterEnd)
{
  uint32_t start = iterStart - array->Elements();
  uint32_t count = iterEnd - iterStart;

  if (count > 0) {
    array->RemoveElementsAt(start, count);
  }
}

// Find items matching between |subs| and |adds|, and remove them,
// recording the item from |adds| in |adds_removed|.  To minimize
// copies, the inputs are processing in parallel, so |subs| and |adds|
// should be compatibly ordered (either by SBAddPrefixLess or
// SBAddPrefixHashLess).
//
// |predAS| provides add < sub, |predSA| provides sub < add, for the
// tightest compare appropriate (see calls in SBProcessSubs).
template<class TSub, class TAdd>
static void
KnockoutSubs(FallibleTArray<TSub>* aSubs, FallibleTArray<TAdd>* aAdds)
{
  // Keep a pair of output iterators for writing kept items.  Due to
  // deletions, these may lag the main iterators.  Using erase() on
  // individual items would result in O(N^2) copies.  Using a list
  // would work around that, at double or triple the memory cost.
  TAdd* addOut = aAdds->Elements();
  TAdd* addIter = aAdds->Elements();

  TSub* subOut = aSubs->Elements();
  TSub* subIter = aSubs->Elements();

  TAdd* addEnd = addIter + aAdds->Length();
  TSub* subEnd = subIter + aSubs->Length();

  while (addIter != addEnd && subIter != subEnd) {
    // additer compare, so it compares on add chunk
    int32_t cmp = addIter->Compare(*subIter);
    if (cmp > 0) {
      // If |*sub_iter| < |*add_iter|, retain the sub.
      *subOut = *subIter;
      ++subOut;
      ++subIter;
    } else if (cmp < 0) {
      // If |*add_iter| < |*sub_iter|, retain the add.
      *addOut = *addIter;
      ++addOut;
      ++addIter;
    } else {
      // Drop equal items
      ++addIter;
      ++subIter;
    }
  }

  Erase(aAdds, addOut, addIter);
  Erase(aSubs, subOut, subIter);
}

// Remove items in |removes| from |fullHashes|.  |fullHashes| and
// |removes| should be ordered by SBAddPrefix component.
template <class T>
static void
RemoveMatchingPrefixes(const SubPrefixArray& aSubs, FallibleTArray<T>* aFullHashes)
{
  // Where to store kept items.
  T* out = aFullHashes->Elements();
  T* hashIter = out;
  T* hashEnd = aFullHashes->Elements() + aFullHashes->Length();

  SubPrefix const * removeIter = aSubs.Elements();
  SubPrefix const * removeEnd = aSubs.Elements() + aSubs.Length();

  while (hashIter != hashEnd && removeIter != removeEnd) {
    int32_t cmp = removeIter->CompareAlt(*hashIter);
    if (cmp > 0) {
      // Keep items less than |*removeIter|.
      *out = *hashIter;
      ++out;
      ++hashIter;
    } else if (cmp < 0) {
      // No hit for |*removeIter|, bump it forward.
      ++removeIter;
    } else {
      // Drop equal items, there may be multiple hits.
      do {
        ++hashIter;
      } while (hashIter != hashEnd &&
               !(removeIter->CompareAlt(*hashIter) < 0));
      ++removeIter;
    }
  }
  Erase(aFullHashes, out, hashIter);
}

static void
RemoveDeadSubPrefixes(SubPrefixArray& aSubs, ChunkSet& aAddChunks)
{
  SubPrefix * subIter = aSubs.Elements();
  SubPrefix * subEnd = aSubs.Elements() + aSubs.Length();

  for (SubPrefix * iter = subIter; iter != subEnd; iter++) {
    bool hasChunk = aAddChunks.Has(iter->AddChunk());
    // Keep the subprefix if the chunk it refers to is one
    // we haven't seen it yet.
    if (!hasChunk) {
      *subIter = *iter;
      subIter++;
    }
  }

  LOG(("Removed %u dead SubPrefix entries.", subEnd - subIter));
  aSubs.TruncateLength(subIter - aSubs.Elements());
}

#ifdef DEBUG
template <class T>
static void EnsureSorted(FallibleTArray<T>* aArray)
{
  T* start = aArray->Elements();
  T* end = aArray->Elements() + aArray->Length();
  T* iter = start;
  T* previous = start;

  while (iter != end) {
    previous = iter;
    ++iter;
    if (iter != end) {
      MOZ_ASSERT(iter->Compare(*previous) >= 0);
    }
  }

  return;
}
#endif

nsresult
HashStore::ProcessSubs()
{
#ifdef DEBUG
  EnsureSorted(&mAddPrefixes);
  EnsureSorted(&mSubPrefixes);
  EnsureSorted(&mAddCompletes);
  EnsureSorted(&mSubCompletes);
  LOG(("All databases seem to have a consistent sort order."));
#endif

  RemoveMatchingPrefixes(mSubPrefixes, &mAddCompletes);
  RemoveMatchingPrefixes(mSubPrefixes, &mSubCompletes);

  // Remove any remaining subbed prefixes from both addprefixes
  // and addcompletes.
  KnockoutSubs(&mSubPrefixes, &mAddPrefixes);
  KnockoutSubs(&mSubCompletes, &mAddCompletes);

  // Remove any remaining subprefixes referring to addchunks that
  // we have (and hence have been processed above).
  RemoveDeadSubPrefixes(mSubPrefixes, mAddChunks);

#ifdef DEBUG
  EnsureSorted(&mAddPrefixes);
  EnsureSorted(&mSubPrefixes);
  EnsureSorted(&mAddCompletes);
  EnsureSorted(&mSubCompletes);
  LOG(("All databases seem to have a consistent sort order."));
#endif

  return NS_OK;
}

nsresult
HashStore::AugmentAdds(const nsTArray<uint32_t>& aPrefixes)
{
  uint32_t cnt = aPrefixes.Length();
  if (cnt != mAddPrefixes.Length()) {
    LOG(("Amount of prefixes in cache not consistent with store (%d vs %d)",
         aPrefixes.Length(), mAddPrefixes.Length()));
    return NS_ERROR_FAILURE;
  }
  for (uint32_t i = 0; i < cnt; i++) {
    mAddPrefixes[i].prefix.FromUint32(aPrefixes[i]);
  }
  return NS_OK;
}

ChunkSet&
HashStore::AddChunks()
{
  ReadChunkNumbers();

  return mAddChunks;
}

ChunkSet&
HashStore::SubChunks()
{
  ReadChunkNumbers();

  return mSubChunks;
}

AddCompleteArray&
HashStore::AddCompletes()
{
  ReadCompletions();

  return mAddCompletes;
}

SubCompleteArray&
HashStore::SubCompletes()
{
  ReadCompletions();

  return mSubCompletes;
}

bool
HashStore::AlreadyReadChunkNumbers()
{
  // If there are chunks but chunk set not yet contains any data
  // Then we haven't read chunk numbers.
  if ((mHeader.numAddChunks != 0 && mAddChunks.Length() == 0) ||
      (mHeader.numSubChunks != 0 && mSubChunks.Length() == 0)) {
    return false;
  }
  return true;
}

bool
HashStore::AlreadyReadCompletions()
{
  // If there are completions but completion set not yet contains any data
  // Then we haven't read completions.
  if ((mHeader.numAddCompletes != 0 && mAddCompletes.Length() == 0) ||
      (mHeader.numSubCompletes != 0 && mSubCompletes.Length() == 0)) {
    return false;
  }
  return true;
}

} // namespace safebrowsing
} // namespace mozilla
