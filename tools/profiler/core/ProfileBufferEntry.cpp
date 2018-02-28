/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <ostream>
#include "platform.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/Sprintf.h"

#include "nsThreadUtils.h"
#include "nsXULAppAPI.h"

// JS
#include "jsapi.h"
#include "jsfriendapi.h"
#include "js/TrackedOptimizationInfo.h"

// Self
#include "ProfileBufferEntry.h"

using mozilla::JSONWriter;
using mozilla::MakeUnique;
using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::Some;
using mozilla::TimeStamp;
using mozilla::UniquePtr;

////////////////////////////////////////////////////////////////////////
// BEGIN ProfileBufferEntry

ProfileBufferEntry::ProfileBufferEntry()
  : mKind(Kind::INVALID)
{
  u.mString = nullptr;
}

// aString must be a static string.
ProfileBufferEntry::ProfileBufferEntry(Kind aKind, const char *aString)
  : mKind(aKind)
{
  u.mString = aString;
}

ProfileBufferEntry::ProfileBufferEntry(Kind aKind, char aChars[kNumChars])
  : mKind(aKind)
{
  memcpy(u.mChars, aChars, kNumChars);
}

ProfileBufferEntry::ProfileBufferEntry(Kind aKind, void* aPtr)
  : mKind(aKind)
{
  u.mPtr = aPtr;
}

ProfileBufferEntry::ProfileBufferEntry(Kind aKind, ProfilerMarker* aMarker)
  : mKind(aKind)
{
  u.mMarker = aMarker;
}

ProfileBufferEntry::ProfileBufferEntry(Kind aKind, double aDouble)
  : mKind(aKind)
{
  u.mDouble = aDouble;
}

ProfileBufferEntry::ProfileBufferEntry(Kind aKind, int aInt)
  : mKind(aKind)
{
  u.mInt = aInt;
}

// END ProfileBufferEntry
////////////////////////////////////////////////////////////////////////

class JSONSchemaWriter
{
  JSONWriter& mWriter;
  uint32_t mIndex;

public:
  explicit JSONSchemaWriter(JSONWriter& aWriter)
   : mWriter(aWriter)
   , mIndex(0)
  {
    aWriter.StartObjectProperty("schema");
  }

  void WriteField(const char* aName) {
    mWriter.IntProperty(aName, mIndex++);
  }

  ~JSONSchemaWriter() {
    mWriter.EndObject();
  }
};

class StreamOptimizationTypeInfoOp : public JS::ForEachTrackedOptimizationTypeInfoOp
{
  JSONWriter& mWriter;
  UniqueJSONStrings& mUniqueStrings;
  bool mStartedTypeList;

public:
  StreamOptimizationTypeInfoOp(JSONWriter& aWriter, UniqueJSONStrings& aUniqueStrings)
    : mWriter(aWriter)
    , mUniqueStrings(aUniqueStrings)
    , mStartedTypeList(false)
  { }

  void readType(const char* keyedBy, const char* name,
                const char* location, const Maybe<unsigned>& lineno) override {
    if (!mStartedTypeList) {
      mStartedTypeList = true;
      mWriter.StartObjectElement();
      mWriter.StartArrayProperty("typeset");
    }

    mWriter.StartObjectElement();
    {
      mUniqueStrings.WriteProperty(mWriter, "keyedBy", keyedBy);
      if (name) {
        mUniqueStrings.WriteProperty(mWriter, "name", name);
      }
      if (location) {
        mUniqueStrings.WriteProperty(mWriter, "location", location);
      }
      if (lineno.isSome()) {
        mWriter.IntProperty("line", *lineno);
      }
    }
    mWriter.EndObject();
  }

  void operator()(JS::TrackedTypeSite site, const char* mirType) override {
    if (mStartedTypeList) {
      mWriter.EndArray();
      mStartedTypeList = false;
    } else {
      mWriter.StartObjectElement();
    }

    {
      mUniqueStrings.WriteProperty(mWriter, "site", JS::TrackedTypeSiteString(site));
      mUniqueStrings.WriteProperty(mWriter, "mirType", mirType);
    }
    mWriter.EndObject();
  }
};

// As mentioned in ProfileBufferEntry.h, the JSON format contains many
// arrays whose elements are laid out according to various schemas to help
// de-duplication. This RAII class helps write these arrays by keeping track of
// the last non-null element written and adding the appropriate number of null
// elements when writing new non-null elements. It also automatically opens and
// closes an array element on the given JSON writer.
//
// Example usage:
//
//     // Define the schema of elements in this type of array: [FOO, BAR, BAZ]
//     enum Schema : uint32_t {
//       FOO = 0,
//       BAR = 1,
//       BAZ = 2
//     };
//
//     AutoArraySchemaWriter writer(someJsonWriter, someUniqueStrings);
//     if (shouldWriteFoo) {
//       writer.IntElement(FOO, getFoo());
//     }
//     ... etc ...
class MOZ_RAII AutoArraySchemaWriter
{
  friend class AutoObjectWriter;

  SpliceableJSONWriter& mJSONWriter;
  UniqueJSONStrings*    mStrings;
  uint32_t              mNextFreeIndex;

public:
  AutoArraySchemaWriter(SpliceableJSONWriter& aWriter, UniqueJSONStrings& aStrings)
    : mJSONWriter(aWriter)
    , mStrings(&aStrings)
    , mNextFreeIndex(0)
  {
    mJSONWriter.StartArrayElement();
  }

  // If you don't have access to a UniqueStrings, you had better not try and
  // write a string element down the line!
  explicit AutoArraySchemaWriter(SpliceableJSONWriter& aWriter)
    : mJSONWriter(aWriter)
    , mStrings(nullptr)
    , mNextFreeIndex(0)
  {
    mJSONWriter.StartArrayElement();
  }

  ~AutoArraySchemaWriter() {
    mJSONWriter.EndArray();
  }

  void FillUpTo(uint32_t aIndex) {
    MOZ_ASSERT(aIndex >= mNextFreeIndex);
    mJSONWriter.NullElements(aIndex - mNextFreeIndex);
    mNextFreeIndex = aIndex + 1;
  }

  void IntElement(uint32_t aIndex, uint32_t aValue) {
    FillUpTo(aIndex);
    mJSONWriter.IntElement(aValue);
  }

  void DoubleElement(uint32_t aIndex, double aValue) {
    FillUpTo(aIndex);
    mJSONWriter.DoubleElement(aValue);
  }

  void StringElement(uint32_t aIndex, const char* aValue) {
    MOZ_RELEASE_ASSERT(mStrings);
    FillUpTo(aIndex);
    mStrings->WriteElement(mJSONWriter, aValue);
  }
};

class StreamOptimizationAttemptsOp : public JS::ForEachTrackedOptimizationAttemptOp
{
  SpliceableJSONWriter& mWriter;
  UniqueJSONStrings& mUniqueStrings;

public:
  StreamOptimizationAttemptsOp(SpliceableJSONWriter& aWriter, UniqueJSONStrings& aUniqueStrings)
    : mWriter(aWriter),
      mUniqueStrings(aUniqueStrings)
  { }

  void operator()(JS::TrackedStrategy strategy, JS::TrackedOutcome outcome) override {
    enum Schema : uint32_t {
      STRATEGY = 0,
      OUTCOME = 1
    };

    AutoArraySchemaWriter writer(mWriter, mUniqueStrings);
    writer.StringElement(STRATEGY, JS::TrackedStrategyString(strategy));
    writer.StringElement(OUTCOME, JS::TrackedOutcomeString(outcome));
  }
};

class StreamJSFramesOp : public JS::ForEachProfiledFrameOp
{
  void* mReturnAddress;
  UniqueStacks::Stack& mStack;
  unsigned mDepth;

public:
  StreamJSFramesOp(void* aReturnAddr, UniqueStacks::Stack& aStack)
   : mReturnAddress(aReturnAddr)
   , mStack(aStack)
   , mDepth(0)
  { }

  unsigned depth() const {
    MOZ_ASSERT(mDepth > 0);
    return mDepth;
  }

  void operator()(const JS::ForEachProfiledFrameOp::FrameHandle& aFrameHandle) override {
    UniqueStacks::OnStackFrameKey frameKey(mReturnAddress, mDepth, aFrameHandle);
    mStack.AppendFrame(frameKey);
    mDepth++;
  }
};

uint32_t UniqueJSONStrings::GetOrAddIndex(const char* aStr)
{
  uint32_t index;
  StringKey key(aStr);

  auto it = mStringToIndexMap.find(key);

  if (it != mStringToIndexMap.end()) {
    return it->second;
  }
  index = mStringToIndexMap.size();
  mStringToIndexMap[key] = index;
  mStringTableWriter.StringElement(aStr);
  return index;
}

bool UniqueStacks::FrameKey::operator==(const FrameKey& aOther) const
{
  return mLocation == aOther.mLocation &&
         mLine == aOther.mLine &&
         mCategory == aOther.mCategory &&
         mJITAddress == aOther.mJITAddress &&
         mJITDepth == aOther.mJITDepth;
}

bool UniqueStacks::StackKey::operator==(const StackKey& aOther) const
{
  MOZ_ASSERT_IF(mPrefix == aOther.mPrefix, mPrefixHash == aOther.mPrefixHash);
  return mPrefix == aOther.mPrefix && mFrame == aOther.mFrame;
}

UniqueStacks::Stack::Stack(UniqueStacks& aUniqueStacks, const OnStackFrameKey& aRoot)
 : mUniqueStacks(aUniqueStacks)
 , mStack(aUniqueStacks.GetOrAddFrameIndex(aRoot))
{
}

void UniqueStacks::Stack::AppendFrame(const OnStackFrameKey& aFrame)
{
  // Compute the prefix hash and index before mutating mStack.
  uint32_t prefixHash = mStack.Hash();
  uint32_t prefix = mUniqueStacks.GetOrAddStackIndex(mStack);
  mStack.UpdateHash(prefixHash, prefix, mUniqueStacks.GetOrAddFrameIndex(aFrame));
}

uint32_t UniqueStacks::Stack::GetOrAddIndex() const
{
  return mUniqueStacks.GetOrAddStackIndex(mStack);
}

uint32_t UniqueStacks::FrameKey::Hash() const
{
  uint32_t hash = 0;
  if (!mLocation.IsEmpty()) {
    hash = mozilla::HashString(mLocation.get());
  }
  if (mLine.isSome()) {
    hash = mozilla::AddToHash(hash, *mLine);
  }
  if (mCategory.isSome()) {
    hash = mozilla::AddToHash(hash, *mCategory);
  }
  if (mJITAddress.isSome()) {
    hash = mozilla::AddToHash(hash, *mJITAddress);
    if (mJITDepth.isSome()) {
      hash = mozilla::AddToHash(hash, *mJITDepth);
    }
  }
  return hash;
}

uint32_t UniqueStacks::StackKey::Hash() const
{
  if (mPrefix.isNothing()) {
    return mozilla::HashGeneric(mFrame);
  }
  return mozilla::AddToHash(*mPrefixHash, mFrame);
}

UniqueStacks::Stack UniqueStacks::BeginStack(const OnStackFrameKey& aRoot)
{
  return Stack(*this, aRoot);
}

UniqueStacks::UniqueStacks(JSContext* aContext)
 : mContext(aContext)
 , mFrameCount(0)
{
  mFrameTableWriter.StartBareList();
  mStackTableWriter.StartBareList();
}

uint32_t UniqueStacks::GetOrAddStackIndex(const StackKey& aStack)
{
  uint32_t index;
  if (mStackToIndexMap.Get(aStack, &index)) {
    MOZ_ASSERT(index < mStackToIndexMap.Count());
    return index;
  }

  index = mStackToIndexMap.Count();
  mStackToIndexMap.Put(aStack, index);
  StreamStack(aStack);
  return index;
}

uint32_t UniqueStacks::GetOrAddFrameIndex(const OnStackFrameKey& aFrame)
{
  uint32_t index;
  if (mFrameToIndexMap.Get(aFrame, &index)) {
    MOZ_ASSERT(index < mFrameCount);
    return index;
  }

  // If aFrame isn't canonical, forward it to the canonical frame's index.
  if (aFrame.mJITFrameHandle) {
    void* canonicalAddr = aFrame.mJITFrameHandle->canonicalAddress();
    if (canonicalAddr != *aFrame.mJITAddress) {
      OnStackFrameKey canonicalKey(canonicalAddr, *aFrame.mJITDepth, *aFrame.mJITFrameHandle);
      uint32_t canonicalIndex = GetOrAddFrameIndex(canonicalKey);
      mFrameToIndexMap.Put(aFrame, canonicalIndex);
      return canonicalIndex;
    }
  }

  // A manual count is used instead of mFrameToIndexMap.Count() due to
  // forwarding of canonical JIT frames above.
  index = mFrameCount++;
  mFrameToIndexMap.Put(aFrame, index);
  StreamFrame(aFrame);
  return index;
}

uint32_t UniqueStacks::LookupJITFrameDepth(void* aAddr)
{
  uint32_t depth;

  auto it = mJITFrameDepthMap.find(aAddr);
  if (it != mJITFrameDepthMap.end()) {
    depth = it->second;
    MOZ_ASSERT(depth > 0);
    return depth;
  }
  return 0;
}

void UniqueStacks::AddJITFrameDepth(void* aAddr, unsigned depth)
{
  mJITFrameDepthMap[aAddr] = depth;
}

void UniqueStacks::SpliceFrameTableElements(SpliceableJSONWriter& aWriter)
{
  mFrameTableWriter.EndBareList();
  aWriter.TakeAndSplice(mFrameTableWriter.WriteFunc());
}

void UniqueStacks::SpliceStackTableElements(SpliceableJSONWriter& aWriter)
{
  mStackTableWriter.EndBareList();
  aWriter.TakeAndSplice(mStackTableWriter.WriteFunc());
}

void UniqueStacks::StreamStack(const StackKey& aStack)
{
  enum Schema : uint32_t {
    PREFIX = 0,
    FRAME = 1
  };

  AutoArraySchemaWriter writer(mStackTableWriter, mUniqueStrings);
  if (aStack.mPrefix.isSome()) {
    writer.IntElement(PREFIX, *aStack.mPrefix);
  }
  writer.IntElement(FRAME, aStack.mFrame);
}

void UniqueStacks::StreamFrame(const OnStackFrameKey& aFrame)
{
  enum Schema : uint32_t {
    LOCATION = 0,
    IMPLEMENTATION = 1,
    OPTIMIZATIONS = 2,
    LINE = 3,
    CATEGORY = 4
  };

  AutoArraySchemaWriter writer(mFrameTableWriter, mUniqueStrings);

  if (!aFrame.mJITFrameHandle) {
    writer.StringElement(LOCATION, aFrame.mLocation.get());
    if (aFrame.mLine.isSome()) {
      writer.IntElement(LINE, *aFrame.mLine);
    }
    if (aFrame.mCategory.isSome()) {
      writer.IntElement(CATEGORY, *aFrame.mCategory);
    }
  } else {
    const JS::ForEachProfiledFrameOp::FrameHandle& jitFrame = *aFrame.mJITFrameHandle;

    writer.StringElement(LOCATION, jitFrame.label());

    JS::ProfilingFrameIterator::FrameKind frameKind = jitFrame.frameKind();
    MOZ_ASSERT(frameKind == JS::ProfilingFrameIterator::Frame_Ion ||
               frameKind == JS::ProfilingFrameIterator::Frame_Baseline);
    writer.StringElement(IMPLEMENTATION,
                         frameKind == JS::ProfilingFrameIterator::Frame_Ion
                         ? "ion"
                         : "baseline");

    if (jitFrame.hasTrackedOptimizations()) {
      writer.FillUpTo(OPTIMIZATIONS);
      mFrameTableWriter.StartObjectElement();
      {
        mFrameTableWriter.StartArrayProperty("types");
        {
          StreamOptimizationTypeInfoOp typeInfoOp(mFrameTableWriter, mUniqueStrings);
          jitFrame.forEachOptimizationTypeInfo(typeInfoOp);
        }
        mFrameTableWriter.EndArray();

        JS::Rooted<JSScript*> script(mContext);
        jsbytecode* pc;
        mFrameTableWriter.StartObjectProperty("attempts");
        {
          {
            JSONSchemaWriter schema(mFrameTableWriter);
            schema.WriteField("strategy");
            schema.WriteField("outcome");
          }

          mFrameTableWriter.StartArrayProperty("data");
          {
            StreamOptimizationAttemptsOp attemptOp(mFrameTableWriter, mUniqueStrings);
            jitFrame.forEachOptimizationAttempt(attemptOp, script.address(), &pc);
          }
          mFrameTableWriter.EndArray();
        }
        mFrameTableWriter.EndObject();

        if (JSAtom* name = js::GetPropertyNameFromPC(script, pc)) {
          char buf[512];
          JS_PutEscapedFlatString(buf, mozilla::ArrayLength(buf), js::AtomToFlatString(name), 0);
          mUniqueStrings.WriteProperty(mFrameTableWriter, "propertyName", buf);
        }

        unsigned line, column;
        line = JS_PCToLineNumber(script, pc, &column);
        mFrameTableWriter.IntProperty("line", line);
        mFrameTableWriter.IntProperty("column", column);
      }
      mFrameTableWriter.EndObject();
    }
  }
}

struct ProfileSample
{
  uint32_t mStack;
  double mTime;
  Maybe<double> mResponsiveness;
  Maybe<double> mRSS;
  Maybe<double> mUSS;
};

static void WriteSample(SpliceableJSONWriter& aWriter, ProfileSample& aSample)
{
  enum Schema : uint32_t {
    STACK = 0,
    TIME = 1,
    RESPONSIVENESS = 2,
    RSS = 3,
    USS = 4
  };

  AutoArraySchemaWriter writer(aWriter);

  writer.IntElement(STACK, aSample.mStack);

  writer.DoubleElement(TIME, aSample.mTime);

  if (aSample.mResponsiveness.isSome()) {
    writer.DoubleElement(RESPONSIVENESS, *aSample.mResponsiveness);
  }

  if (aSample.mRSS.isSome()) {
    writer.DoubleElement(RSS, *aSample.mRSS);
  }

  if (aSample.mUSS.isSome()) {
    writer.DoubleElement(USS, *aSample.mUSS);
  }
}

class EntryGetter
{
public:
  explicit EntryGetter(const ProfileBuffer& aBuffer)
    : mEntries(aBuffer.mEntries.get())
    , mReadPos(aBuffer.mReadPos)
    , mWritePos(aBuffer.mWritePos)
    , mEntrySize(aBuffer.mEntrySize)
  {}

  bool Has() const { return mReadPos != mWritePos; }
  const ProfileBufferEntry& Get() const { return mEntries[mReadPos]; }
  void Next() { mReadPos = (mReadPos + 1) % mEntrySize; }

private:
  const ProfileBufferEntry* const mEntries;
  int mReadPos;
  const int mWritePos;
  const int mEntrySize;
};

// The following grammar shows legal sequences of profile buffer entries.
// The sequences beginning with a ThreadId entry are known as "samples".
//
// (
//   (
//     ThreadId
//     Time
//     ( NativeLeafAddr
//     | Label DynamicStringFragment* LineNumber? Category?
//     | JitReturnAddr
//     )+
//     Marker*
//     Responsiveness?
//     ResidentMemory?
//     UnsharedMemory?
//   )
//   | CollectionStart
//   | CollectionEnd
//   | Pause
//   | Resume
// )*
//
// The most complicated part is the stack entry sequence that begins with
// Label. Here are some examples.
//
// - PseudoStack entries without a dynamic string:
//
//     Label("js::RunScript")
//     Category(ProfileEntry::Category::JS)
//
//     Label("XREMain::XRE_main")
//     LineNumber(4660)
//     Category(ProfileEntry::Category::OTHER)
//
//     Label("ElementRestyler::ComputeStyleChangeFor")
//     LineNumber(3003)
//     Category(ProfileEntry::Category::CSS)
//
// - PseudoStack entries with a dynamic string:
//
//     Label("nsObserverService::NotifyObservers")
//     DynamicStringFragment("domwindo")
//     DynamicStringFragment("wopened")
//     LineNumber(291)
//     Category(ProfileEntry::Category::OTHER)
//
//     Label("")
//     DynamicStringFragment("closeWin")
//     DynamicStringFragment("dow (chr")
//     DynamicStringFragment("ome://gl")
//     DynamicStringFragment("obal/con")
//     DynamicStringFragment("tent/glo")
//     DynamicStringFragment("balOverl")
//     DynamicStringFragment("ay.js:5)")
//     DynamicStringFragment("")          # this string holds the closing '\0'
//     LineNumber(25)
//     Category(ProfileEntry::Category::JS)
//
//     Label("")
//     DynamicStringFragment("bound (s")
//     DynamicStringFragment("elf-host")
//     DynamicStringFragment("ed:914)")
//     LineNumber(945)
//     Category(ProfileEntry::Category::JS)
//
// - A pseudoStack entry with a dynamic string, but with privacy enabled:
//
//     Label("nsObserverService::NotifyObservers")
//     DynamicStringFragment("(private")
//     DynamicStringFragment(")")
//     LineNumber(291)
//     Category(ProfileEntry::Category::OTHER)
//
// - A pseudoStack entry with an overly long dynamic string:
//
//     Label("")
//     DynamicStringFragment("(too lon")
//     DynamicStringFragment("g)")
//     LineNumber(100)
//     Category(ProfileEntry::Category::NETWORK)
//
// - A wasm JIT frame entry:
//
//     Label("")
//     DynamicStringFragment("wasm-fun")
//     DynamicStringFragment("ction[87")
//     DynamicStringFragment("36] (blo")
//     DynamicStringFragment("b:http:/")
//     DynamicStringFragment("/webasse")
//     DynamicStringFragment("mbly.org")
//     DynamicStringFragment("/3dc5759")
//     DynamicStringFragment("4-ce58-4")
//     DynamicStringFragment("626-975b")
//     DynamicStringFragment("-08ad116")
//     DynamicStringFragment("30bc1:38")
//     DynamicStringFragment("29856)")
//
// - A JS frame entry in a synchronous sample:
//
//     Label("")
//     DynamicStringFragment("u (https")
//     DynamicStringFragment("://perf-")
//     DynamicStringFragment("html.io/")
//     DynamicStringFragment("ac0da204")
//     DynamicStringFragment("aaa44d75")
//     DynamicStringFragment("a800.bun")
//     DynamicStringFragment("dle.js:2")
//     DynamicStringFragment("5)")
//
void
ProfileBuffer::StreamSamplesToJSON(SpliceableJSONWriter& aWriter, int aThreadId,
                                   double aSinceTime,
                                   double* aOutFirstSampleTime,
                                   JSContext* aContext,
                                   UniqueStacks& aUniqueStacks) const
{
  UniquePtr<char[]> strbuf = MakeUnique<char[]>(kMaxFrameKeyLength);

  // Because this is a format entirely internal to the Profiler, any parsing
  // error indicates a bug in the ProfileBuffer writing or the parser itself,
  // or possibly flaky hardware.
  #define ERROR_AND_CONTINUE(msg) \
    { \
      fprintf(stderr, "ProfileBuffer parse error: %s", msg); \
      MOZ_ASSERT(false, msg); \
      continue; \
    }

  EntryGetter e(*this);
  bool seenFirstSample = false;

  for (;;) {
    // This block skips entries until we find the start of the next sample.
    // This is useful in three situations.
    //
    // - The circular buffer overwrites old entries, so when we start parsing
    //   we might be in the middle of a sample, and we must skip forward to the
    //   start of the next sample.
    //
    // - We skip samples that don't have an appropriate ThreadId or Time.
    //
    // - We skip range Pause, Resume, CollectionStart, and CollectionEnd
    //   entries between samples.
    while (e.Has()) {
      if (e.Get().IsThreadId()) {
        break;
      } else {
        e.Next();
      }
    }

    if (!e.Has()) {
      break;
    }

    if (e.Get().IsThreadId()) {
      int threadId = e.Get().u.mInt;
      e.Next();

      // Ignore samples that are for the wrong thread.
      if (threadId != aThreadId) {
        continue;
      }
    } else {
      // Due to the skip_to_next_sample block above, if we have an entry here
      // it must be a ThreadId entry.
      MOZ_CRASH();
    }

    ProfileSample sample;

    if (e.Has() && e.Get().IsTime()) {
      sample.mTime = e.Get().u.mDouble;
      e.Next();

      // Ignore samples that are too old.
      if (sample.mTime < aSinceTime) {
        continue;
      }

      if (!seenFirstSample) {
        if (aOutFirstSampleTime) {
          *aOutFirstSampleTime = sample.mTime;
        }
        seenFirstSample = true;
      }
    } else {
      ERROR_AND_CONTINUE("expected a Time entry");
    }

    UniqueStacks::Stack stack =
      aUniqueStacks.BeginStack(UniqueStacks::OnStackFrameKey("(root)"));

    int numFrames = 0;
    while (e.Has()) {
      if (e.Get().IsNativeLeafAddr()) {
        numFrames++;

        // Bug 753041: We need a double cast here to tell GCC that we don't
        // want to sign extend 32-bit addresses starting with 0xFXXXXXX.
        unsigned long long pc = (unsigned long long)(uintptr_t)e.Get().u.mPtr;
        char buf[20];
        SprintfLiteral(buf, "%#llx", pc);
        stack.AppendFrame(UniqueStacks::OnStackFrameKey(buf));
        e.Next();

      } else if (e.Get().IsLabel()) {
        numFrames++;

        // Copy the label into strbuf.
        const char* label = e.Get().u.mString;
        strncpy(strbuf.get(), label, kMaxFrameKeyLength);
        size_t i = strlen(label);
        e.Next();

        bool seenFirstDynamicStringFragment = false;
        while (e.Has()) {
          if (e.Get().IsDynamicStringFragment()) {
            // If this is the first dynamic string fragment and we have a
            // non-empty label, insert a ' ' after the label and before the
            // dynamic string.
            if (!seenFirstDynamicStringFragment) {
              if (i > 0 && i < kMaxFrameKeyLength) {
                strbuf[i] = ' ';
                i++;
              }
              seenFirstDynamicStringFragment = true;
            }

            for (size_t j = 0; j < ProfileBufferEntry::kNumChars; j++) {
              const char* chars = e.Get().u.mChars;
              if (i < kMaxFrameKeyLength) {
                strbuf[i] = chars[j];
                i++;
              }
            }
            e.Next();
          } else {
            break;
          }
        }
        strbuf[kMaxFrameKeyLength - 1] = '\0';

        UniqueStacks::OnStackFrameKey frameKey(strbuf.get());

        if (e.Has() && e.Get().IsLineNumber()) {
          frameKey.mLine = Some(unsigned(e.Get().u.mInt));
          e.Next();
        }

        if (e.Has() && e.Get().IsCategory()) {
          frameKey.mCategory = Some(unsigned(e.Get().u.mInt));
          e.Next();
        }

        stack.AppendFrame(frameKey);

      } else if (e.Get().IsJitReturnAddr()) {
        numFrames++;

        // A JIT frame may expand to multiple frames due to inlining.
        void* pc = e.Get().u.mPtr;
        unsigned depth = aUniqueStacks.LookupJITFrameDepth(pc);
        if (depth == 0) {
          StreamJSFramesOp framesOp(pc, stack);
          MOZ_RELEASE_ASSERT(aContext);
          JS::ForEachProfiledFrame(aContext, pc, framesOp);
          aUniqueStacks.AddJITFrameDepth(pc, framesOp.depth());
        } else {
          for (unsigned i = 0; i < depth; i++) {
            UniqueStacks::OnStackFrameKey inlineFrameKey(pc, i);
            stack.AppendFrame(inlineFrameKey);
          }
        }

        e.Next();

      } else {
        break;
      }
    }

    if (numFrames == 0) {
      ERROR_AND_CONTINUE("expected one or more frame entries");
    }

    sample.mStack = stack.GetOrAddIndex();

    // Skip over the markers. We process them in StreamMarkersToJSON().
    while (e.Has()) {
      if (e.Get().IsMarker()) {
        e.Next();
      } else {
        break;
      }
    }

    if (e.Has() && e.Get().IsResponsiveness()) {
      sample.mResponsiveness = Some(e.Get().u.mDouble);
      e.Next();
    }

    if (e.Has() && e.Get().IsResidentMemory()) {
      sample.mRSS = Some(e.Get().u.mDouble);
      e.Next();
    }

    if (e.Has() && e.Get().IsUnsharedMemory()) {
      sample.mUSS = Some(e.Get().u.mDouble);
      e.Next();
    }

    WriteSample(aWriter, sample);
  }

  #undef ERROR_AND_CONTINUE
}

void
ProfileBuffer::StreamMarkersToJSON(SpliceableJSONWriter& aWriter,
                                   int aThreadId,
                                   const TimeStamp& aProcessStartTime,
                                   double aSinceTime,
                                   UniqueStacks& aUniqueStacks) const
{
  EntryGetter e(*this);

  int currentThreadID = -1;

  // Stream all markers whose threadId matches aThreadId. All other entries are
  // skipped, because we process them in StreamSamplesToJSON().
  while (e.Has()) {
    if (e.Get().IsThreadId()) {
      currentThreadID = e.Get().u.mInt;
    } else if (currentThreadID == aThreadId && e.Get().IsMarker()) {
      const ProfilerMarker* marker = e.Get().u.mMarker;
      if (marker->GetTime() >= aSinceTime) {
        marker->StreamJSON(aWriter, aProcessStartTime, aUniqueStacks);
      }
    }
    e.Next();
  }
}

static void
AddPausedRange(SpliceableJSONWriter& aWriter, const char* aReason,
               const Maybe<double>& aStartTime, const Maybe<double>& aEndTime)
{
  aWriter.Start(SpliceableJSONWriter::SingleLineStyle);
  if (aStartTime) {
    aWriter.DoubleProperty("startTime", *aStartTime);
  } else {
    aWriter.NullProperty("startTime");
  }
  if (aEndTime) {
    aWriter.DoubleProperty("endTime", *aEndTime);
  } else {
    aWriter.NullProperty("endTime");
  }
  aWriter.StringProperty("reason", aReason);
  aWriter.End();
}

void
ProfileBuffer::StreamPausedRangesToJSON(SpliceableJSONWriter& aWriter,
                                        double aSinceTime) const
{
  EntryGetter e(*this);

  Maybe<double> currentPauseStartTime;
  Maybe<double> currentCollectionStartTime;

  while (e.Has()) {
    if (e.Get().IsPause()) {
      currentPauseStartTime = Some(e.Get().u.mDouble);
    } else if (e.Get().IsResume()) {
      AddPausedRange(aWriter, "profiler-paused",
                     currentPauseStartTime, Some(e.Get().u.mDouble));
      currentPauseStartTime = Nothing();
    } else if (e.Get().IsCollectionStart()) {
      currentCollectionStartTime = Some(e.Get().u.mDouble);
    } else if (e.Get().IsCollectionEnd()) {
      AddPausedRange(aWriter, "collecting",
                     currentCollectionStartTime, Some(e.Get().u.mDouble));
      currentCollectionStartTime = Nothing();
    }
    e.Next();
  }

  if (currentPauseStartTime) {
    AddPausedRange(aWriter, "profiler-paused",
                   currentPauseStartTime, Nothing());
  }
  if (currentCollectionStartTime) {
    AddPausedRange(aWriter, "collecting",
                   currentCollectionStartTime, Nothing());
  }
}

int
ProfileBuffer::FindLastSampleOfThread(int aThreadId, const LastSample& aLS)
  const
{
  // |aLS| has a valid generation number if either it matches the buffer's
  // generation, or is one behind the buffer's generation, since the buffer's
  // generation is incremented on wraparound.  There's no ambiguity relative to
  // ProfileBuffer::reset, since that increments mGeneration by two.
  if (aLS.mGeneration == mGeneration ||
      (mGeneration > 0 && aLS.mGeneration == mGeneration - 1)) {
    int ix = aLS.mPos;

    if (ix == -1) {
      // There's no record of |aLS|'s thread ever having recorded a sample in
      // the buffer.
      return -1;
    }

    // It might be that the sample has since been overwritten, so check that it
    // is still valid.
    MOZ_RELEASE_ASSERT(0 <= ix && ix < mEntrySize);
    ProfileBufferEntry& entry = mEntries[ix];
    bool isStillValid = entry.IsThreadId() && entry.u.mInt == aThreadId;
    return isStillValid ? ix : -1;
  }

  // |aLS| denotes a sample which is older than either two wraparounds or one
  // call to ProfileBuffer::reset.  In either case it is no longer valid.
  MOZ_ASSERT(aLS.mGeneration <= mGeneration - 2);
  return -1;
}

bool
ProfileBuffer::DuplicateLastSample(int aThreadId,
                                   const TimeStamp& aProcessStartTime,
                                   LastSample& aLS)
{
  int lastSampleStartPos = FindLastSampleOfThread(aThreadId, aLS);
  if (lastSampleStartPos == -1) {
    return false;
  }

  MOZ_ASSERT(mEntries[lastSampleStartPos].IsThreadId() &&
             mEntries[lastSampleStartPos].u.mInt == aThreadId);

  AddThreadIdEntry(aThreadId, &aLS);

  // Go through the whole entry and duplicate it, until we find the next one.
  for (int readPos = (lastSampleStartPos + 1) % mEntrySize;
       readPos != mWritePos;
       readPos = (readPos + 1) % mEntrySize) {
    switch (mEntries[readPos].GetKind()) {
      case ProfileBufferEntry::Kind::Pause:
      case ProfileBufferEntry::Kind::Resume:
      case ProfileBufferEntry::Kind::CollectionStart:
      case ProfileBufferEntry::Kind::CollectionEnd:
      case ProfileBufferEntry::Kind::ThreadId:
        // We're done.
        return true;
      case ProfileBufferEntry::Kind::Time:
        // Copy with new time
        AddEntry(ProfileBufferEntry::Time(
          (TimeStamp::Now() - aProcessStartTime).ToMilliseconds()));
        break;
      case ProfileBufferEntry::Kind::Marker:
        // Don't copy markers
        break;
      default:
        // Copy anything else we don't know about.
        AddEntry(mEntries[readPos]);
        break;
    }
  }
  return true;
}

// END ProfileBuffer
////////////////////////////////////////////////////////////////////////

