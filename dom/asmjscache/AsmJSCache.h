/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_asmjscache_asmjscache_h
#define mozilla_dom_asmjscache_asmjscache_h

#include "ipc/IPCMessageUtils.h"
#include "js/TypeDecls.h"
#include "js/Vector.h"
#include "jsapi.h"

class nsIPrincipal;

namespace mozilla {

namespace ipc {

class PrincipalInfo;

} // namespace ipc

namespace dom {

namespace quota {
class Client;
} // namespace quota

namespace asmjscache {

class PAsmJSCacheEntryChild;
class PAsmJSCacheEntryParent;

enum OpenMode
{
  eOpenForRead,
  eOpenForWrite,
  NUM_OPEN_MODES
};

// Each origin stores a fixed size (kNumEntries) LRU cache of compiled asm.js
// modules. Each compiled asm.js module is stored in a separate file with one
// extra metadata file that stores the LRU cache and enough information for a
// client to pick which cached module's file to open.
struct Metadata
{
  static const unsigned kNumEntries = 16;
  static const unsigned kLastEntry = kNumEntries - 1;

  struct Entry
  {
    uint32_t mFastHash;
    uint32_t mNumChars;
    uint32_t mFullHash;
    unsigned mModuleIndex;

    void clear() {
      mFastHash = -1;
      mNumChars = -1;
      mFullHash = -1;
    }
  };

  Entry mEntries[kNumEntries];
};

// Parameters specific to opening a cache entry for writing
struct WriteParams
{
  int64_t mSize;
  int64_t mFastHash;
  int64_t mNumChars;
  int64_t mFullHash;

  WriteParams()
  : mSize(0),
    mFastHash(0),
    mNumChars(0),
    mFullHash(0)
  { }
};

// Parameters specific to opening a cache entry for reading
struct ReadParams
{
  const char16_t* mBegin;
  const char16_t* mLimit;

  ReadParams()
  : mBegin(nullptr),
    mLimit(nullptr)
  { }
};

// Implementation of AsmJSCacheOps, installed for the main JSRuntime by
// nsJSEnvironment.cpp and DOM Worker JSRuntimes in RuntimeService.cpp.
//
// The Open* functions cannot be called directly from AsmJSCacheOps: they take
// an nsIPrincipal as the first argument instead of a Handle<JSObject*>. The
// caller must map the object to an nsIPrincipal.
//
// These methods may be called off the main thread and guarantee not to
// access the given aPrincipal except on the main thread. In exchange, the
// caller must ensure the given principal is alive from when OpenEntryForX is
// called to when CloseEntryForX returns.

bool
OpenEntryForRead(nsIPrincipal* aPrincipal,
                 const char16_t* aBegin,
                 const char16_t* aLimit,
                 size_t* aSize,
                 const uint8_t** aMemory,
                 intptr_t *aHandle);
void
CloseEntryForRead(size_t aSize,
                  const uint8_t* aMemory,
                  intptr_t aHandle);
JS::AsmJSCacheResult
OpenEntryForWrite(nsIPrincipal* aPrincipal,
                  const char16_t* aBegin,
                  const char16_t* aEnd,
                  size_t aSize,
                  uint8_t** aMemory,
                  intptr_t* aHandle);
void
CloseEntryForWrite(size_t aSize,
                   uint8_t* aMemory,
                   intptr_t aHandle);

// Called from QuotaManager.cpp:

quota::Client*
CreateClient();

// Called from ipc/ContentParent.cpp:

PAsmJSCacheEntryParent*
AllocEntryParent(OpenMode aOpenMode, WriteParams aWriteParams,
                 const mozilla::ipc::PrincipalInfo& aPrincipalInfo);

void
DeallocEntryParent(PAsmJSCacheEntryParent* aActor);

// Called from ipc/ContentChild.cpp:

void
DeallocEntryChild(PAsmJSCacheEntryChild* aActor);

} // namespace asmjscache
} // namespace dom
} // namespace mozilla

namespace IPC {

template <>
struct ParamTraits<mozilla::dom::asmjscache::OpenMode> :
  public ContiguousEnumSerializer<mozilla::dom::asmjscache::OpenMode,
                                  mozilla::dom::asmjscache::eOpenForRead,
                                  mozilla::dom::asmjscache::NUM_OPEN_MODES>
{ };

template <>
struct ParamTraits<mozilla::dom::asmjscache::Metadata>
{
  typedef mozilla::dom::asmjscache::Metadata paramType;
  static void Write(Message* aMsg, const paramType& aParam);
  static bool Read(const Message* aMsg, PickleIterator* aIter, paramType* aResult);
  static void Log(const paramType& aParam, std::wstring* aLog);
};

template <>
struct ParamTraits<mozilla::dom::asmjscache::WriteParams>
{
  typedef mozilla::dom::asmjscache::WriteParams paramType;
  static void Write(Message* aMsg, const paramType& aParam);
  static bool Read(const Message* aMsg, PickleIterator* aIter, paramType* aResult);
  static void Log(const paramType& aParam, std::wstring* aLog);
};

template <>
struct ParamTraits<JS::AsmJSCacheResult> :
  public ContiguousEnumSerializer<JS::AsmJSCacheResult,
                                  JS::AsmJSCache_MIN,
                                  JS::AsmJSCache_LIMIT>
{ };

} // namespace IPC

#endif  // mozilla_dom_asmjscache_asmjscache_h
