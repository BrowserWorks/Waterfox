/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOOF_PARSER_H_
#define MOOF_PARSER_H_

#include "mp4_demuxer/Atom.h"
#include "mp4_demuxer/AtomType.h"
#include "mp4_demuxer/SinfParser.h"
#include "mp4_demuxer/Stream.h"
#include "mp4_demuxer/Interval.h"
#include "MediaResource.h"

namespace mp4_demuxer {
typedef int64_t Microseconds;

class Box;
class BoxContext;
class BoxReader;
class Moof;

class Mvhd : public Atom
{
public:
  Mvhd()
    : mCreationTime(0)
    , mModificationTime(0)
    , mTimescale(0)
    , mDuration(0)
  {
  }
  explicit Mvhd(Box& aBox);

  Microseconds ToMicroseconds(int64_t aTimescaleUnits)
  {
    int64_t major = aTimescaleUnits / mTimescale;
    int64_t remainder = aTimescaleUnits % mTimescale;
    return major * 1000000ll + remainder * 1000000ll / mTimescale;
  }

  uint64_t mCreationTime;
  uint64_t mModificationTime;
  uint32_t mTimescale;
  uint64_t mDuration;
};

class Tkhd : public Mvhd
{
public:
  Tkhd()
    : mTrackId(0)
  {
  }
  explicit Tkhd(Box& aBox);

  uint32_t mTrackId;
};

class Mdhd : public Mvhd
{
public:
  Mdhd() = default;
  explicit Mdhd(Box& aBox);
};

class Trex : public Atom
{
public:
  explicit Trex(uint32_t aTrackId)
    : mFlags(0)
    , mTrackId(aTrackId)
    , mDefaultSampleDescriptionIndex(0)
    , mDefaultSampleDuration(0)
    , mDefaultSampleSize(0)
    , mDefaultSampleFlags(0)
  {
  }

  explicit Trex(Box& aBox);

  uint32_t mFlags;
  uint32_t mTrackId;
  uint32_t mDefaultSampleDescriptionIndex;
  uint32_t mDefaultSampleDuration;
  uint32_t mDefaultSampleSize;
  uint32_t mDefaultSampleFlags;
};

class Tfhd : public Trex
{
public:
  explicit Tfhd(Trex& aTrex)
    : Trex(aTrex)
    , mBaseDataOffset(0)
  {
    mValid = aTrex.IsValid();
  }
  Tfhd(Box& aBox, Trex& aTrex);

  uint64_t mBaseDataOffset;
};

class Tfdt : public Atom
{
public:
  Tfdt()
    : mBaseMediaDecodeTime(0)
  {
  }
  explicit Tfdt(Box& aBox);

  uint64_t mBaseMediaDecodeTime;
};

class Edts : public Atom
{
public:
  Edts()
    : mMediaStart(0)
    , mEmptyOffset(0)
  {
  }
  explicit Edts(Box& aBox);
  virtual bool IsValid()
  {
    // edts is optional
    return true;
  }

  int64_t mMediaStart;
  int64_t mEmptyOffset;
};

struct Sample
{
  mozilla::MediaByteRange mByteRange;
  mozilla::MediaByteRange mCencRange;
  Microseconds mDecodeTime;
  Interval<Microseconds> mCompositionRange;
  bool mSync;
};

class Saiz final : public Atom
{
public:
  Saiz(Box& aBox, AtomType aDefaultType);

  AtomType mAuxInfoType;
  uint32_t mAuxInfoTypeParameter;
  FallibleTArray<uint8_t> mSampleInfoSize;
};

class Saio final : public Atom
{
public:
  Saio(Box& aBox, AtomType aDefaultType);

  AtomType mAuxInfoType;
  uint32_t mAuxInfoTypeParameter;
  FallibleTArray<uint64_t> mOffsets;
};

struct SampleToGroupEntry
{
public:
  static const uint32_t kTrackGroupDescriptionIndexBase = 0;
  static const uint32_t kFragmentGroupDescriptionIndexBase = 0x10000;

  SampleToGroupEntry(uint32_t aSampleCount, uint32_t aGroupDescriptionIndex)
    : mSampleCount(aSampleCount)
    , mGroupDescriptionIndex(aGroupDescriptionIndex)
    {
    }

  uint32_t mSampleCount;
  uint32_t mGroupDescriptionIndex;
};

class Sbgp final : public Atom // SampleToGroup box.
{
public:
  explicit Sbgp(Box& aBox);

  AtomType mGroupingType;
  uint32_t mGroupingTypeParam;
  nsTArray<SampleToGroupEntry> mEntries;
};

struct CencSampleEncryptionInfoEntry final
{
public:
  CencSampleEncryptionInfoEntry() { }

  bool Init(BoxReader& aReader);

  bool mIsEncrypted = false;
  uint8_t mIVSize = 0;
  nsTArray<uint8_t> mKeyId;
};

class Sgpd final : public Atom // SampleGroupDescription box.
{
public:
  explicit Sgpd(Box& aBox);

  AtomType mGroupingType;
  nsTArray<CencSampleEncryptionInfoEntry> mEntries;
};

class AuxInfo {
public:
  AuxInfo(int64_t aMoofOffset, Saiz& aSaiz, Saio& aSaio);

private:
  int64_t mMoofOffset;
  Saiz& mSaiz;
  Saio& mSaio;
};

class Moof final : public Atom
{
public:
  Moof(Box& aBox, Trex& aTrex, Mvhd& aMvhd, Mdhd& aMdhd, Edts& aEdts, Sinf& aSinf, uint64_t* aDecoderTime, bool aIsAudio);
  bool GetAuxInfo(AtomType aType, nsTArray<MediaByteRange>* aByteRanges);
  void FixRounding(const Moof& aMoof);

  mozilla::MediaByteRange mRange;
  mozilla::MediaByteRange mMdatRange;
  Interval<Microseconds> mTimeRange;
  FallibleTArray<Sample> mIndex;

  nsTArray<CencSampleEncryptionInfoEntry> mFragmentSampleEncryptionInfoEntries;
  nsTArray<SampleToGroupEntry> mFragmentSampleToGroupEntries;

  nsTArray<Saiz> mSaizs;
  nsTArray<Saio> mSaios;

private:
    // aDecodeTime is updated to the end of the parsed TRAF on return.
  void ParseTraf(Box& aBox, Trex& aTrex, Mvhd& aMvhd, Mdhd& aMdhd, Edts& aEdts, Sinf& aSinf, uint64_t* aDecodeTime, bool aIsAudio);
  // aDecodeTime is updated to the end of the parsed TRUN on return.
  bool ParseTrun(Box& aBox, Tfhd& aTfhd, Mvhd& aMvhd, Mdhd& aMdhd, Edts& aEdts, uint64_t* aDecodeTime, bool aIsAudio);
  void ParseSaiz(Box& aBox);
  void ParseSaio(Box& aBox);
  bool ProcessCenc();
  uint64_t mMaxRoundingError;
};

class MoofParser
{
public:
  MoofParser(Stream* aSource, uint32_t aTrackId, bool aIsAudio)
    : mSource(aSource)
    , mOffset(0)
    , mTrex(aTrackId)
    , mIsAudio(aIsAudio)
    , mLastDecodeTime(0)
  {
    // Setting the mTrex.mTrackId to 0 is a nasty work around for calculating
    // the composition range for MSE. We need an array of tracks.
  }
  bool RebuildFragmentedIndex(
    const mozilla::MediaByteRangeSet& aByteRanges);
  // If *aCanEvict is set to true. then will remove all moofs already parsed
  // from index then rebuild the index. *aCanEvict is set to true upon return if
  // some moofs were removed.
  bool RebuildFragmentedIndex(
    const mozilla::MediaByteRangeSet& aByteRanges, bool* aCanEvict);
  bool RebuildFragmentedIndex(BoxContext& aContext);
  Interval<Microseconds> GetCompositionRange(
    const mozilla::MediaByteRangeSet& aByteRanges);
  bool ReachedEnd();
  void ParseMoov(Box& aBox);
  void ParseTrak(Box& aBox);
  void ParseMdia(Box& aBox, Tkhd& aTkhd);
  void ParseMvex(Box& aBox);

  void ParseMinf(Box& aBox);
  void ParseStbl(Box& aBox);
  void ParseStsd(Box& aBox);
  void ParseEncrypted(Box& aBox);
  void ParseSinf(Box& aBox);

  bool BlockingReadNextMoof();
  bool HasMetadata();
  already_AddRefed<mozilla::MediaByteBuffer> Metadata();
  MediaByteRange FirstCompleteMediaSegment();
  MediaByteRange FirstCompleteMediaHeader();

  mozilla::MediaByteRange mInitRange;
  RefPtr<Stream> mSource;
  uint64_t mOffset;
  Mvhd mMvhd;
  Mdhd mMdhd;
  Trex mTrex;
  Tfdt mTfdt;
  Edts mEdts;
  Sinf mSinf;

  nsTArray<CencSampleEncryptionInfoEntry> mTrackSampleEncryptionInfoEntries;
  nsTArray<SampleToGroupEntry> mTrackSampleToGroupEntries;

  nsTArray<Moof>& Moofs() { return mMoofs; }
private:
  void ScanForMetadata(mozilla::MediaByteRange& aFtyp,
                       mozilla::MediaByteRange& aMoov);
  nsTArray<Moof> mMoofs;
  nsTArray<MediaByteRange> mMediaRanges;
  bool mIsAudio;
  uint64_t mLastDecodeTime;
};
}

#endif
