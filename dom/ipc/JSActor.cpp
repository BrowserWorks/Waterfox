/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/JSActor.h"
#include "mozilla/dom/JSActorBinding.h"

#include "mozilla/Attributes.h"
#include "mozilla/Telemetry.h"
#include "mozilla/dom/ClonedErrorHolder.h"
#include "mozilla/dom/ClonedErrorHolderBinding.h"
#include "mozilla/dom/DOMException.h"
#include "mozilla/dom/DOMExceptionBinding.h"
#include "mozilla/dom/MessageManagerBinding.h"
#include "mozilla/dom/PWindowGlobal.h"
#include "mozilla/dom/Promise.h"
#include "js/Promise.h"
#include "xpcprivate.h"
#include "nsASCIIMask.h"
#include "nsICrashReporter.h"

namespace mozilla {
namespace dom {

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(JSActor)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(JSActor)
NS_IMPL_CYCLE_COLLECTING_RELEASE(JSActor)

NS_IMPL_CYCLE_COLLECTION_CLASS(JSActor)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(JSActor)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mWrappedJS)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPendingQueries)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(JSActor)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mWrappedJS)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPendingQueries)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_TRACE_WRAPPERCACHE(JSActor)

JSActor::JSActor() : mNextQueryId(0) {}

// RAII class to ensure that, if we crash while handling a message, the
// crash will be annotated with the name of the actor and the message.
struct MOZ_RAII AutoAnnotateMessageInCaseOfCrash {
  AutoAnnotateMessageInCaseOfCrash(const nsCString& aActorName,
                                   const nsCString& aMessageName) {
    CrashReporter::AnnotateCrashReport(CrashReporter::Annotation::JSActorName,
                                       aActorName);
    CrashReporter::AnnotateCrashReport(
        CrashReporter::Annotation::JSActorMessage, aMessageName);
  }
  ~AutoAnnotateMessageInCaseOfCrash() {
    CrashReporter::RemoveCrashReportAnnotation(
        CrashReporter::Annotation::JSActorMessage);
    CrashReporter::RemoveCrashReportAnnotation(
        CrashReporter::Annotation::JSActorName);
  }
};

void JSActor::StartDestroy() {
  AutoAnnotateMessageInCaseOfCrash guard(/* aActorName = */ mName,
                                         NS_LITERAL_CSTRING("<WillDestroy>"));
  InvokeCallback(CallbackFunction::WillDestroy);
}

void JSActor::AfterDestroy() {
  AutoAnnotateMessageInCaseOfCrash guard(/* aActorName = */ mName,
                                         NS_LITERAL_CSTRING("<DidDestroy>"));
  InvokeCallback(CallbackFunction::DidDestroy);
  // Clear out & reject mPendingQueries
  RejectPendingQueries();
}

void JSActor::InvokeCallback(CallbackFunction callback) {
  MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());

  AutoEntryScript aes(GetParentObject(), "JSActor destroy callback");
  JSContext* cx = aes.cx();
  MozJSActorCallbacks callbacksHolder;
  NS_ENSURE_TRUE_VOID(GetWrapper());
  JS::Rooted<JS::Value> val(cx, JS::ObjectValue(*GetWrapper()));
  if (NS_WARN_IF(!callbacksHolder.Init(cx, val))) {
    return;
  }

  // Destroy callback is optional.
  if (callback == CallbackFunction::WillDestroy) {
    if (callbacksHolder.mWillDestroy.WasPassed()) {
      callbacksHolder.mWillDestroy.Value()->Call(this);
    }
  } else if (callback == CallbackFunction::DidDestroy) {
    if (callbacksHolder.mDidDestroy.WasPassed()) {
      callbacksHolder.mDidDestroy.Value()->Call(this);
    }
  } else {
    if (callbacksHolder.mActorCreated.WasPassed()) {
      callbacksHolder.mActorCreated.Value()->Call(this);
    }
  }
}

nsresult JSActor::QueryInterfaceActor(const nsIID& aIID, void** aPtr) {
  MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());

  if (!mWrappedJS) {
    AutoEntryScript aes(GetParentObject(), "JSActor query interface");
    JSContext* cx = aes.cx();

    JS::Rooted<JSObject*> self(cx, GetWrapper());
    JSAutoRealm ar(cx, self);

    RefPtr<nsXPCWrappedJS> wrappedJS;
    nsresult rv = nsXPCWrappedJS::GetNewOrUsed(
        cx, self, NS_GET_IID(nsISupports), getter_AddRefs(wrappedJS));
    NS_ENSURE_SUCCESS(rv, rv);

    mWrappedJS = do_QueryInterface(wrappedJS);
    MOZ_ASSERT(mWrappedJS);
  }

  return mWrappedJS->QueryInterface(aIID, aPtr);
}

void JSActor::RejectPendingQueries() {
  MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());

  // Take our queries out, in case somehow rejecting promises can trigger
  // additions or removals.
  nsRefPtrHashtable<nsUint64HashKey, Promise> pendingQueries;
  mPendingQueries.SwapElements(pendingQueries);
  for (auto iter = pendingQueries.Iter(); !iter.Done(); iter.Next()) {
    iter.Data()->MaybeReject(NS_ERROR_NOT_AVAILABLE);
  }
}

/* static */
bool JSActor::AllowMessage(const JSActorMessageMeta& aMetadata,
                           size_t aDataLength) {
  // A message includes more than structured clone data, so subtract
  // 20KB to make it more likely that a message within this bound won't
  // result in an overly large IPC message.
  static const size_t kMaxMessageSize =
      IPC::Channel::kMaximumMessageSize - 20 * 1024;
  if (aDataLength < kMaxMessageSize) {
    return true;
  }

  nsAutoString messageName(NS_ConvertUTF8toUTF16(aMetadata.actorName()));
  messageName.AppendLiteral("::");
  messageName.Append(aMetadata.messageName());

  // Remove digits to avoid spamming telemetry if anybody is dynamically
  // generating message names with numbers in them.
  messageName.StripTaggedASCII(ASCIIMask::Mask0to9());

  Telemetry::ScalarAdd(
      Telemetry::ScalarID::DOM_IPC_REJECTED_WINDOW_ACTOR_MESSAGE, messageName,
      1);

  return false;
}

void JSActor::SetName(const nsACString& aName) {
  MOZ_ASSERT(mName.IsEmpty(), "Cannot set name twice!");
  mName = aName;
}

static ipc::StructuredCloneData CloneJSStack(JSContext* aCx,
                                             JS::Handle<JSObject*> aStack) {
  JS::Rooted<JS::Value> stackVal(aCx, JS::ObjectOrNullValue(aStack));

  {
    IgnoredErrorResult rv;
    ipc::StructuredCloneData data;
    data.Write(aCx, stackVal, rv);
    if (!rv.Failed()) {
      return data;
    }
  }
  ErrorResult rv;
  ipc::StructuredCloneData data;
  data.Write(aCx, JS::NullHandleValue, rv);
  return data;
}

static ipc::StructuredCloneData CaptureJSStack(JSContext* aCx) {
  JS::Rooted<JSObject*> stack(aCx, nullptr);
  if (JS::ContextOptionsRef(aCx).asyncStack() &&
      !JS::CaptureCurrentStack(aCx, &stack)) {
    JS_ClearPendingException(aCx);
  }

  return CloneJSStack(aCx, stack);
}

void JSActor::SendAsyncMessage(JSContext* aCx, const nsAString& aMessageName,
                               JS::Handle<JS::Value> aObj, ErrorResult& aRv) {
  ipc::StructuredCloneData data;
  if (!nsFrameMessageManager::GetParamsForMessage(
          aCx, aObj, JS::UndefinedHandleValue, data)) {
    aRv.Throw(NS_ERROR_DOM_DATA_CLONE_ERR);
    return;
  }

  JSActorMessageMeta meta;
  meta.actorName() = mName;
  meta.messageName() = aMessageName;
  meta.kind() = JSActorMessageKind::Message;

  SendRawMessage(meta, std::move(data), CaptureJSStack(aCx), aRv);
}

already_AddRefed<Promise> JSActor::SendQuery(JSContext* aCx,
                                             const nsAString& aMessageName,
                                             JS::Handle<JS::Value> aObj,
                                             ErrorResult& aRv) {
  ipc::StructuredCloneData data;
  if (!nsFrameMessageManager::GetParamsForMessage(
          aCx, aObj, JS::UndefinedHandleValue, data)) {
    aRv.Throw(NS_ERROR_DOM_DATA_CLONE_ERR);
    return nullptr;
  }

  nsIGlobalObject* global = xpc::CurrentNativeGlobal(aCx);
  if (NS_WARN_IF(!global)) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }

  RefPtr<Promise> promise = Promise::Create(global, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  JSActorMessageMeta meta;
  meta.actorName() = mName;
  meta.messageName() = aMessageName;
  meta.queryId() = mNextQueryId++;
  meta.kind() = JSActorMessageKind::Query;

  mPendingQueries.Put(meta.queryId(), RefPtr{promise});

  SendRawMessage(meta, std::move(data), CaptureJSStack(aCx), aRv);
  return promise.forget();
}

#define CHILD_DIAGNOSTIC_ASSERT(test, msg) \
  do {                                     \
    if (XRE_IsParentProcess()) {           \
      MOZ_ASSERT(test, msg);               \
    } else {                               \
      MOZ_DIAGNOSTIC_ASSERT(test, msg);    \
    }                                      \
  } while (0)

void JSActor::ReceiveRawMessage(const JSActorMessageMeta& aMetadata,
                                ipc::StructuredCloneData&& aData,
                                ipc::StructuredCloneData&& aStack) {
  MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
  AutoAnnotateMessageInCaseOfCrash guard(
      /* aActorName = */ mName,
      NS_LossyConvertUTF16toASCII(aMetadata.messageName()));

  AutoEntryScript aes(GetParentObject(), "JSActor message handler");
  JSContext* cx = aes.cx();

  // Read the message into a JS object from IPC.
  ErrorResult error;
  JS::Rooted<JS::Value> data(cx);
  aData.Read(cx, &data, error);
  if (NS_WARN_IF(error.Failed())) {
    CHILD_DIAGNOSTIC_ASSERT(false, "Should not receive non-decodable data");
    MOZ_ALWAYS_TRUE(error.MaybeSetPendingException(cx));
    return;
  }

  JS::Rooted<JSObject*> stack(cx);
  Maybe<JS::AutoSetAsyncStackForNewCalls> stackSetter;
  {
    JS::Rooted<JS::Value> stackVal(cx);
    aStack.Read(cx, &stackVal, IgnoreErrors());
    if (stackVal.isObject()) {
      stack = &stackVal.toObject();
      if (!js::IsSavedFrame(stack)) {
        CHILD_DIAGNOSTIC_ASSERT(false, "Stack must be a SavedFrame object");
        return;
      }
      stackSetter.emplace(cx, stack, "JSActor query");
    }
  }

  switch (aMetadata.kind()) {
    case JSActorMessageKind::QueryResolve:
    case JSActorMessageKind::QueryReject:
      ReceiveQueryReply(cx, aMetadata, data, error);
      break;

    case JSActorMessageKind::Message:
    case JSActorMessageKind::Query:
      ReceiveMessageOrQuery(cx, aMetadata, data, error);
      break;

    default:
      MOZ_ASSERT_UNREACHABLE();
  }

  Unused << error.MaybeSetPendingException(cx);
}

void JSActor::ReceiveMessageOrQuery(JSContext* aCx,
                                    const JSActorMessageMeta& aMetadata,
                                    JS::Handle<JS::Value> aData,
                                    ErrorResult& aRv) {
  // The argument which we want to pass to IPC.
  RootedDictionary<ReceiveMessageArgument> argument(aCx);
  argument.mTarget = this;
  argument.mName = aMetadata.messageName();
  argument.mData = aData;
  argument.mJson = aData;
  argument.mSync = false;

  JS::Rooted<JSObject*> self(aCx, GetWrapper());
  JS::Rooted<JSObject*> global(aCx, JS::GetNonCCWObjectGlobal(self));

  // We only need to create a promise if we're dealing with a query here. It
  // will be resolved or rejected once the listener has been called. Our
  // listener on this promise will then send the reply.
  RefPtr<Promise> promise;
  if (aMetadata.kind() == JSActorMessageKind::Query) {
    promise = Promise::Create(xpc::NativeGlobal(global), aRv);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }

    RefPtr<QueryHandler> handler = new QueryHandler(this, aMetadata, promise);
    promise->AppendNativeHandler(handler);
  }

  // Invoke the actual callback.
  JS::Rooted<JS::Value> retval(aCx);
  RefPtr<MessageListener> messageListener =
      new MessageListener(self, global, nullptr, nullptr);
  messageListener->ReceiveMessage(argument, &retval, aRv,
                                  "JSActor receive message",
                                  MessageListener::eRethrowExceptions);

  // If we have a promise, resolve or reject it respectively.
  if (promise) {
    if (aRv.Failed()) {
      if (aRv.IsUncatchableException()) {
        aRv.SuppressException();
        promise->MaybeRejectWithTimeoutError(
            "Message handler threw uncatchable exception");
      } else {
        promise->MaybeReject(std::move(aRv));
      }
    } else {
      promise->MaybeResolve(retval);
    }
  }
}

void JSActor::ReceiveQueryReply(JSContext* aCx,
                                const JSActorMessageMeta& aMetadata,
                                JS::Handle<JS::Value> aData, ErrorResult& aRv) {
  if (NS_WARN_IF(aMetadata.actorName() != mName)) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return;
  }

  RefPtr<Promise> promise;
  if (NS_WARN_IF(!mPendingQueries.Remove(aMetadata.queryId(),
                                         getter_AddRefs(promise)))) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  JSAutoRealm ar(aCx, promise->PromiseObj());
  JS::RootedValue data(aCx, aData);
  if (NS_WARN_IF(!JS_WrapValue(aCx, &data))) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }

  if (aMetadata.kind() == JSActorMessageKind::QueryResolve) {
    promise->MaybeResolve(data);
  } else {
    promise->MaybeReject(data);
  }
}

// Native handler for our generated promise which is used to handle Queries and
// send the reply when their promises have been resolved.
JSActor::QueryHandler::QueryHandler(JSActor* aActor,
                                    const JSActorMessageMeta& aMetadata,
                                    Promise* aPromise)
    : mActor(aActor),
      mPromise(aPromise),
      mMessageName(aMetadata.messageName()),
      mQueryId(aMetadata.queryId()) {}

void JSActor::QueryHandler::RejectedCallback(JSContext* aCx,
                                             JS::Handle<JS::Value> aValue) {
  if (!mActor) {
    // Make sure that this rejection is reported. See comment below.
    Unused << JS::CallOriginalPromiseReject(aCx, aValue);
    return;
  }

  JS::Rooted<JS::Value> value(aCx, aValue);
  if (value.isObject()) {
    JS::Rooted<JSObject*> error(aCx, &value.toObject());
    if (RefPtr<ClonedErrorHolder> ceh =
            ClonedErrorHolder::Create(aCx, error, IgnoreErrors())) {
      JS::RootedObject obj(aCx);
      // Note: We can't use `ToJSValue` here because ClonedErrorHolder isn't
      // wrapper cached.
      if (ceh->WrapObject(aCx, nullptr, &obj)) {
        value.setObject(*obj);
      } else {
        JS_ClearPendingException(aCx);
      }
    } else {
      JS_ClearPendingException(aCx);
    }
  }

  Maybe<ipc::StructuredCloneData> data;
  data.emplace();
  IgnoredErrorResult rv;
  data->Write(aCx, value, rv);
  if (rv.Failed()) {
    // Failed to clone the rejection value. Make sure that this rejection is
    // reported, despite being "handled". This is done by creating a new
    // promise in the rejected state, and throwing it away. This will be
    // reported as an unhandled rejected promise.
    Unused << JS::CallOriginalPromiseReject(aCx, aValue);

    data.reset();
    data.emplace();
    data->Write(aCx, JS::UndefinedHandleValue, rv);
  }

  SendReply(aCx, JSActorMessageKind::QueryReject, std::move(*data));
}

void JSActor::QueryHandler::ResolvedCallback(JSContext* aCx,
                                             JS::Handle<JS::Value> aValue) {
  if (!mActor) {
    return;
  }

  ipc::StructuredCloneData data;
  data.InitScope(JS::StructuredCloneScope::DifferentProcess);

  IgnoredErrorResult error;
  data.Write(aCx, aValue, error);
  if (NS_WARN_IF(error.Failed())) {
    nsAutoCString msg;
    msg.Append(mActor->Name());
    msg.Append(':');
    msg.Append(NS_LossyConvertUTF16toASCII(mMessageName));
    msg.AppendLiteral(": message reply cannot be cloned.");

    auto exc = MakeRefPtr<Exception>(msg, NS_ERROR_FAILURE,
                                     NS_LITERAL_CSTRING("DataCloneError"),
                                     nullptr, nullptr);

    JS::Rooted<JS::Value> val(aCx);
    if (ToJSValue(aCx, exc, &val)) {
      RejectedCallback(aCx, val);
    }
    return;
  }

  SendReply(aCx, JSActorMessageKind::QueryResolve, std::move(data));
}

void JSActor::QueryHandler::SendReply(JSContext* aCx, JSActorMessageKind aKind,
                                      ipc::StructuredCloneData&& aData) {
  MOZ_ASSERT(mActor);

  JSActorMessageMeta meta;
  meta.actorName() = mActor->Name();
  meta.messageName() = mMessageName;
  meta.queryId() = mQueryId;
  meta.kind() = aKind;

  JS::Rooted<JSObject*> promise(aCx, mPromise->PromiseObj());
  JS::Rooted<JSObject*> stack(aCx, JS::GetPromiseResolutionSite(promise));

  mActor->SendRawMessage(meta, std::move(aData), CloneJSStack(aCx, stack),
                         IgnoreErrors());
  mActor = nullptr;
  mPromise = nullptr;
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(JSActor::QueryHandler)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(JSActor::QueryHandler)
NS_IMPL_CYCLE_COLLECTING_RELEASE(JSActor::QueryHandler)

NS_IMPL_CYCLE_COLLECTION(JSActor::QueryHandler, mActor, mPromise)

}  // namespace dom
}  // namespace mozilla
