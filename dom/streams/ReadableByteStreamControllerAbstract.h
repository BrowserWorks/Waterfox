/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DOM_STREAMS_READABLEBYTESTREAMCONTROLLERABSTRACT_H_
#define DOM_STREAMS_READABLEBYTESTREAMCONTROLLERABSTRACT_H_

#include "ReadableByteStreamController.h"

namespace mozilla::dom::streams_abstract {

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerRespond(
    JSContext* aCx, ReadableByteStreamController* aController,
    uint64_t aBytesWritten, ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerRespondInternal(
    JSContext* aCx, ReadableByteStreamController* aController,
    uint64_t aBytesWritten, ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerRespondWithNewView(
    JSContext* aCx, ReadableByteStreamController* aController,
    JS::Handle<JSObject*> aView, ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerPullInto(
    JSContext* aCx, ReadableByteStreamController* aController,
    JS::Handle<JSObject*> aView, uint64_t aMin,
    ReadIntoRequest* aReadIntoRequest, ErrorResult& aRv);

void ReadableByteStreamControllerError(
    JSContext* aCx, ReadableByteStreamController* aController,
    JS::Handle<JS::Value> aValue, ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerEnqueue(
    JSContext* aCx, ReadableByteStreamController* aController,
    JS::Handle<JSObject*> aChunk, ErrorResult& aRv);

already_AddRefed<ReadableStreamBYOBRequest>
ReadableByteStreamControllerGetBYOBRequest(
    JSContext* aCx, ReadableByteStreamController* aController,
    ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerClose(
    JSContext* aCx, ReadableByteStreamController* aController,
    ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void SetUpReadableByteStreamController(
    JSContext* aCx, ReadableStream* aStream,
    ReadableByteStreamController* aController,
    UnderlyingSourceAlgorithmsBase* aAlgorithms, double aHighWaterMark,
    Maybe<uint64_t> aAutoAllocateChunkSize, ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void ReadableByteStreamControllerCallPullIfNeeded(
    JSContext* aCx, ReadableByteStreamController* aController,
    ErrorResult& aRv);

MOZ_CAN_RUN_SCRIPT void SetUpReadableByteStreamControllerFromUnderlyingSource(
    JSContext* aCx, ReadableStream* aStream,
    JS::Handle<JSObject*> aUnderlyingSource,
    UnderlyingSource& aUnderlyingSourceDict, double aHighWaterMark,
    ErrorResult& aRv);

}  // namespace mozilla::dom::streams_abstract

#endif  // DOM_STREAMS_READABLEBYTESTREAMCONTROLLERABSTRACT_H_
