/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ModuleLoadRequest.h"
#include "mozilla/HoldDropJSObjects.h"
#include "nsICacheInfoChannel.h"
#include "ScriptLoadRequest.h"
#include "ScriptSettings.h"

namespace mozilla {
namespace dom {

//////////////////////////////////////////////////////////////
// ScriptLoadRequest
//////////////////////////////////////////////////////////////

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ScriptLoadRequest)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ScriptLoadRequest)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ScriptLoadRequest)

NS_IMPL_CYCLE_COLLECTION_CLASS(ScriptLoadRequest)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(ScriptLoadRequest)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mCacheInfo)
  tmp->DropBytecodeCacheReferences();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(ScriptLoadRequest)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mCacheInfo)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(ScriptLoadRequest)
  NS_IMPL_CYCLE_COLLECTION_TRACE_JS_MEMBER_CALLBACK(mScript)
NS_IMPL_CYCLE_COLLECTION_TRACE_END

ScriptLoadRequest::ScriptLoadRequest(ScriptKind aKind,
                                     nsIScriptElement* aElement,
                                     uint32_t aVersion,
                                     mozilla::CORSMode aCORSMode,
                                     const mozilla::dom::SRIMetadata& aIntegrity)
  : mKind(aKind)
  , mElement(aElement)
  , mScriptFromHead(false)
  , mProgress(Progress::Loading)
  , mDataType(DataType::Unknown)
  , mIsInline(true)
  , mHasSourceMapURL(false)
  , mIsDefer(false)
  , mIsAsync(false)
  , mIsNonAsyncScriptInserted(false)
  , mIsXSLT(false)
  , mIsCanceled(false)
  , mWasCompiledOMT(false)
  , mIsTracking(false)
  , mOffThreadToken(nullptr)
  , mScriptText()
  , mScriptBytecode()
  , mBytecodeOffset(0)
  , mJSVersion(aVersion)
  , mLineNo(1)
  , mCORSMode(aCORSMode)
  , mIntegrity(aIntegrity)
  , mReferrerPolicy(mozilla::net::RP_Unset)
{
}

ScriptLoadRequest::~ScriptLoadRequest()
{
  // We should always clean up any off-thread script parsing resources.
  MOZ_ASSERT(!mOffThreadToken);

  // But play it safe in release builds and try to clean them up here
  // as a fail safe.
  MaybeCancelOffThreadScript();

  if (mScript) {
    DropBytecodeCacheReferences();
  }
}

void
ScriptLoadRequest::SetReady()
{
  MOZ_ASSERT(mProgress != Progress::Ready);
  mProgress = Progress::Ready;
}

void
ScriptLoadRequest::Cancel()
{
  MaybeCancelOffThreadScript();
  mIsCanceled = true;
}

void
ScriptLoadRequest::MaybeCancelOffThreadScript()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (!mOffThreadToken) {
    return;
  }

  JSContext* cx = danger::GetJSContext();
  // Follow the same conditions as ScriptLoader::AttemptAsyncScriptCompile
  if (IsModuleRequest()) {
    JS::CancelOffThreadModule(cx, mOffThreadToken);
  } else if (IsSource()) {
    JS::CancelOffThreadScript(cx, mOffThreadToken);
  } else {
    MOZ_ASSERT(IsBytecode());
    JS::CancelOffThreadScriptDecoder(cx, mOffThreadToken);
  }
  mOffThreadToken = nullptr;
}

void
ScriptLoadRequest::DropBytecodeCacheReferences()
{
  mCacheInfo = nullptr;
  mScript = nullptr;
  DropJSObjects(this);
}

inline ModuleLoadRequest*
ScriptLoadRequest::AsModuleRequest()
{
  MOZ_ASSERT(IsModuleRequest());
  return static_cast<ModuleLoadRequest*>(this);
}

//////////////////////////////////////////////////////////////
// ScriptLoadRequestList
//////////////////////////////////////////////////////////////

ScriptLoadRequestList::~ScriptLoadRequestList()
{
  Clear();
}

void
ScriptLoadRequestList::Clear()
{
  while (!isEmpty()) {
    RefPtr<ScriptLoadRequest> first = StealFirst();
    first->Cancel();
    // And just let it go out of scope and die.
  }
}

#ifdef DEBUG
bool
ScriptLoadRequestList::Contains(ScriptLoadRequest* aElem) const
{
  for (const ScriptLoadRequest* req = getFirst();
       req; req = req->getNext()) {
    if (req == aElem) {
      return true;
    }
  }

  return false;
}
#endif // DEBUG

inline void
ImplCycleCollectionUnlink(ScriptLoadRequestList& aField)
{
  while (!aField.isEmpty()) {
    RefPtr<ScriptLoadRequest> first = aField.StealFirst();
  }
}

inline void
ImplCycleCollectionTraverse(nsCycleCollectionTraversalCallback& aCallback,
                            ScriptLoadRequestList& aField,
                            const char* aName,
                            uint32_t aFlags)
{
  for (ScriptLoadRequest* request = aField.getFirst();
       request; request = request->getNext())
  {
    CycleCollectionNoteChild(aCallback, request, aName, aFlags);
  }
}

} // dom namespace
} // mozilla namespace
