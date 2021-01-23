/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef BASEPROFILEJSONWRITER_H
#define BASEPROFILEJSONWRITER_H

#include "BaseProfiler.h"

#ifndef MOZ_GECKO_PROFILER
#  error Do not #include this header when MOZ_GECKO_PROFILER is not #defined.
#endif

#include "mozilla/JSONWriter.h"
#include "mozilla/UniquePtr.h"

#include <functional>
#include <ostream>
#include <string>

namespace mozilla {
namespace baseprofiler {

class SpliceableJSONWriter;

// On average, profile JSONs are large enough such that we want to avoid
// reallocating its buffer when expanding. Additionally, the contents of the
// profile are not accessed until the profile is entirely written. For these
// reasons we use a chunked writer that keeps an array of chunks, which is
// concatenated together after writing is finished.
class ChunkedJSONWriteFunc : public JSONWriteFunc {
 public:
  friend class SpliceableJSONWriter;

  ChunkedJSONWriteFunc() : mChunkPtr{nullptr}, mChunkEnd{nullptr} {
    AllocChunk(kChunkSize);
  }

  bool IsEmpty() const {
    MOZ_ASSERT_IF(!mChunkPtr, !mChunkEnd && mChunkList.length() == 0 &&
                                  mChunkLengths.length() == 0);
    return !mChunkPtr;
  }

  void Write(const char* aStr) override;
  void Write(const char* aStr, size_t aLen) override;
  void CopyDataIntoLazilyAllocatedBuffer(
      const std::function<char*(size_t)>& aAllocator) const;
  UniquePtr<char[]> CopyData() const;
  void Take(ChunkedJSONWriteFunc&& aOther);
  // Returns the byte length of the complete combined string, including the
  // null terminator byte.
  size_t GetTotalLength() const;

 private:
  void AllocChunk(size_t aChunkSize);

  static const size_t kChunkSize = 4096 * 512;

  // Pointer for writing inside the current chunk.
  //
  // The current chunk is always at the back of mChunkList, i.e.,
  // mChunkList.back() <= mChunkPtr <= mChunkEnd.
  char* mChunkPtr;

  // Pointer to the end of the current chunk.
  //
  // The current chunk is always at the back of mChunkList, i.e.,
  // mChunkEnd >= mChunkList.back() + mChunkLengths.back().
  char* mChunkEnd;

  // List of chunks and their lengths.
  //
  // For all i, the length of the string in mChunkList[i] is
  // mChunkLengths[i].
  Vector<UniquePtr<char[]>> mChunkList;
  Vector<size_t> mChunkLengths;
};

struct OStreamJSONWriteFunc : public JSONWriteFunc {
  explicit OStreamJSONWriteFunc(std::ostream& aStream) : mStream(aStream) {}

  void Write(const char* aStr) override { mStream << aStr; }
  void Write(const char* aStr, size_t aLen) override { mStream << aStr; }

  std::ostream& mStream;
};

class SpliceableJSONWriter : public JSONWriter {
 public:
  explicit SpliceableJSONWriter(UniquePtr<JSONWriteFunc> aWriter)
      : JSONWriter(std::move(aWriter)) {}

  void StartBareList(CollectionStyle aStyle = MultiLineStyle) {
    StartCollection(nullptr, "", aStyle);
  }

  void EndBareList() { EndCollection(""); }

  void NullElements(uint32_t aCount) {
    for (uint32_t i = 0; i < aCount; i++) {
      NullElement();
    }
  }

  void Splice(const ChunkedJSONWriteFunc* aFunc);
  void Splice(const char* aStr);

  // Splice the given JSON directly in, without quoting.
  void SplicedJSONProperty(const char* aMaybePropertyName,
                           const char* aJsonValue) {
    Scalar(aMaybePropertyName, aJsonValue);
  }

  // Takes the chunks from aFunc and write them. If move is not possible
  // (e.g., using OStreamJSONWriteFunc), aFunc's chunks are copied and its
  // storage cleared.
  virtual void TakeAndSplice(ChunkedJSONWriteFunc* aFunc);
};

class SpliceableChunkedJSONWriter : public SpliceableJSONWriter {
 public:
  explicit SpliceableChunkedJSONWriter()
      : SpliceableJSONWriter(MakeUnique<ChunkedJSONWriteFunc>()) {}

  ChunkedJSONWriteFunc* WriteFunc() const {
    return static_cast<ChunkedJSONWriteFunc*>(JSONWriter::WriteFunc());
  }

  // Adopts the chunks from aFunc without copying.
  virtual void TakeAndSplice(ChunkedJSONWriteFunc* aFunc) override;
};

class JSONSchemaWriter {
  JSONWriter& mWriter;
  uint32_t mIndex;

 public:
  explicit JSONSchemaWriter(JSONWriter& aWriter) : mWriter(aWriter), mIndex(0) {
    aWriter.StartObjectProperty("schema",
                                SpliceableJSONWriter::SingleLineStyle);
  }

  void WriteField(const char* aName) { mWriter.IntProperty(aName, mIndex++); }

  ~JSONSchemaWriter() { mWriter.EndObject(); }
};

}  // namespace baseprofiler
}  // namespace mozilla

#endif  // BASEPROFILEJSONWRITER_H
