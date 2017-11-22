/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef BOX_H_
#define BOX_H_

#include <stdint.h>
#include "nsTArray.h"
#include "MediaResource.h"
#include "mozilla/EndianUtils.h"
#include "mp4_demuxer/AtomType.h"
#include "mp4_demuxer/ByteReader.h"

using namespace mozilla;

namespace mp4_demuxer {

class Stream;

class BoxContext
{
public:
  BoxContext(Stream* aSource, const MediaByteRangeSet& aByteRanges)
    : mSource(aSource), mByteRanges(aByteRanges)
  {
  }

  RefPtr<Stream> mSource;
  const MediaByteRangeSet& mByteRanges;
};

class Box
{
public:
  Box(BoxContext* aContext, uint64_t aOffset, const Box* aParent = nullptr);
  Box();

  bool IsAvailable() const { return !mRange.IsEmpty(); }
  uint64_t Offset() const { return mRange.mStart; }
  uint64_t Length() const { return mRange.mEnd - mRange.mStart; }
  uint64_t NextOffset() const { return mRange.mEnd; }
  const MediaByteRange& Range() const { return mRange; }
  const Box* Parent() const { return mParent; }
  bool IsType(const char* aType) const { return mType == AtomType(aType); }

  Box Next() const;
  Box FirstChild() const;
  nsTArray<uint8_t> Read() const;
  bool Read(nsTArray<uint8_t>* aDest, const MediaByteRange& aRange) const;

  static const uint64_t kMAX_BOX_READ;

  const nsTArray<uint8_t>& Header() const { return mHeader; }

private:
  bool Contains(MediaByteRange aRange) const;
  BoxContext* mContext;
  mozilla::MediaByteRange mRange;
  uint64_t mBodyOffset;
  uint64_t mChildOffset;
  AtomType mType;
  nsTArray<uint8_t> mHeader;
  const Box* mParent;
};

// BoxReader takes a copy of a box contents and serves through an AutoByteReader.
class MOZ_RAII BoxReader
{
public:
  explicit BoxReader(Box& aBox)
    : mBuffer(aBox.Read())
    , mReader(mBuffer.Elements(), mBuffer.Length())
  {
  }
  ByteReader* operator->() { return &mReader; }

private:
  nsTArray<uint8_t> mBuffer;
  ByteReader mReader;
};
}

#endif
