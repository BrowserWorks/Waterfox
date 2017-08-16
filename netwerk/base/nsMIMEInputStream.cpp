/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * The MIME stream separates headers and a datastream. It also allows
 * automatic creation of the content-length header.
 */

#include "ipc/IPCMessageUtils.h"

#include "nsCOMPtr.h"
#include "nsComponentManagerUtils.h"
#include "nsIHttpHeaderVisitor.h"
#include "nsIMIMEInputStream.h"
#include "nsISeekableStream.h"
#include "nsString.h"
#include "nsMIMEInputStream.h"
#include "nsIClassInfoImpl.h"
#include "nsIIPCSerializableInputStream.h"
#include "mozilla/Move.h"
#include "mozilla/ipc/InputStreamUtils.h"

using namespace mozilla::ipc;
using mozilla::Maybe;
using mozilla::Move;

class nsMIMEInputStream : public nsIMIMEInputStream,
                          public nsISeekableStream,
                          public nsIIPCSerializableInputStream
{
    virtual ~nsMIMEInputStream();

public:
    nsMIMEInputStream();

    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIINPUTSTREAM
    NS_DECL_NSIMIMEINPUTSTREAM
    NS_DECL_NSISEEKABLESTREAM
    NS_DECL_NSIIPCSERIALIZABLEINPUTSTREAM

private:

    void InitStreams();

    struct MOZ_STACK_CLASS ReadSegmentsState {
        nsCOMPtr<nsIInputStream> mThisStream;
        nsWriteSegmentFun mWriter;
        void* mClosure;
    };
    static nsresult ReadSegCb(nsIInputStream* aIn, void* aClosure,
                              const char* aFromRawSegment, uint32_t aToOffset,
                              uint32_t aCount, uint32_t *aWriteCount);

    bool IsIPCSerializable() const;

    nsTArray<HeaderEntry> mHeaders;

    nsCOMPtr<nsIInputStream> mStream;
    bool mStartedReading;
};

NS_IMPL_ADDREF(nsMIMEInputStream)
NS_IMPL_RELEASE(nsMIMEInputStream)

NS_IMPL_CLASSINFO(nsMIMEInputStream, nullptr, nsIClassInfo::THREADSAFE,
                  NS_MIMEINPUTSTREAM_CID)

NS_INTERFACE_MAP_BEGIN(nsMIMEInputStream)
  NS_INTERFACE_MAP_ENTRY(nsIMIMEInputStream)
  NS_INTERFACE_MAP_ENTRY(nsIInputStream)
  NS_INTERFACE_MAP_ENTRY(nsISeekableStream)
  NS_INTERFACE_MAP_ENTRY_CONDITIONAL(nsIIPCSerializableInputStream,
                                     IsIPCSerializable())
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIMIMEInputStream)
  NS_IMPL_QUERY_CLASSINFO(nsMIMEInputStream)
NS_INTERFACE_MAP_END

NS_IMPL_CI_INTERFACE_GETTER(nsMIMEInputStream,
                            nsIMIMEInputStream,
                            nsIInputStream,
                            nsISeekableStream)

nsMIMEInputStream::nsMIMEInputStream() : mStartedReading(false)
{
}

nsMIMEInputStream::~nsMIMEInputStream()
{
}

NS_IMETHODIMP
nsMIMEInputStream::GetAddContentLength(bool *aAddContentLength)
{
    *aAddContentLength = true;
    return NS_OK;
}
NS_IMETHODIMP
nsMIMEInputStream::SetAddContentLength(bool aAddContentLength)
{
    NS_ENSURE_FALSE(mStartedReading, NS_ERROR_FAILURE);
    if (!aAddContentLength) {
      // Content-Length is automatically added by the channel when setting the
      // upload stream, so setting this to false has no practical effect.
      return NS_ERROR_FAILURE;
    }
    return NS_OK;
}

NS_IMETHODIMP
nsMIMEInputStream::AddHeader(const char *aName, const char *aValue)
{
    NS_ENSURE_FALSE(mStartedReading, NS_ERROR_FAILURE);

    HeaderEntry* entry = mHeaders.AppendElement();
    entry->name().Append(aName);
    entry->value().Append(aValue);

    return NS_OK;
}

NS_IMETHODIMP
nsMIMEInputStream::VisitHeaders(nsIHttpHeaderVisitor *visitor)
{
  nsresult rv;

  for (auto& header : mHeaders) {
    rv = visitor->VisitHeader(header.name(), header.value());
    if (NS_FAILED(rv)) {
      return rv;
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsMIMEInputStream::SetData(nsIInputStream *aStream)
{
    NS_ENSURE_FALSE(mStartedReading, NS_ERROR_FAILURE);

    nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(aStream);
    if (!seekable) {
      return NS_ERROR_INVALID_ARG;
    }

    mStream = aStream;
    return NS_OK;
}

NS_IMETHODIMP
nsMIMEInputStream::GetData(nsIInputStream **aStream)
{
  NS_ENSURE_ARG_POINTER(aStream);
  *aStream = mStream;
  NS_IF_ADDREF(*aStream);
  return NS_OK;
}

// set up the internal streams
void nsMIMEInputStream::InitStreams()
{
    NS_ASSERTION(!mStartedReading,
                 "Don't call initStreams twice without rewinding");

    mStartedReading = true;
}



#define INITSTREAMS         \
if (!mStartedReading) {     \
    NS_ENSURE_TRUE(mStream, NS_ERROR_UNEXPECTED); \
    InitStreams();          \
}

// Reset mStartedReading when Seek-ing to start
NS_IMETHODIMP
nsMIMEInputStream::Seek(int32_t whence, int64_t offset)
{
    NS_ENSURE_TRUE(mStream, NS_ERROR_UNEXPECTED);

    nsresult rv;
    nsCOMPtr<nsISeekableStream> stream = do_QueryInterface(mStream);

    if (whence == NS_SEEK_SET && offset == 0) {
        rv = stream->Seek(whence, offset);
        if (NS_SUCCEEDED(rv))
            mStartedReading = false;
    }
    else {
        INITSTREAMS;
        rv = stream->Seek(whence, offset);
    }

    return rv;
}

// Proxy ReadSegments since we need to be a good little nsIInputStream
NS_IMETHODIMP nsMIMEInputStream::ReadSegments(nsWriteSegmentFun aWriter,
                                              void *aClosure, uint32_t aCount,
                                              uint32_t *_retval)
{
    INITSTREAMS;
    ReadSegmentsState state;
    state.mThisStream = this;
    state.mWriter = aWriter;
    state.mClosure = aClosure;
    return mStream->ReadSegments(ReadSegCb, &state, aCount, _retval);
}

nsresult
nsMIMEInputStream::ReadSegCb(nsIInputStream* aIn, void* aClosure,
                             const char* aFromRawSegment,
                             uint32_t aToOffset, uint32_t aCount,
                             uint32_t *aWriteCount)
{
    ReadSegmentsState* state = (ReadSegmentsState*)aClosure;
    return  (state->mWriter)(state->mThisStream,
                             state->mClosure,
                             aFromRawSegment,
                             aToOffset,
                             aCount,
                             aWriteCount);
}

/**
 * Forward everything else to the mStream after calling InitStreams()
 */

// nsIInputStream
NS_IMETHODIMP nsMIMEInputStream::Close(void) { INITSTREAMS; return mStream->Close(); }
NS_IMETHODIMP nsMIMEInputStream::Available(uint64_t *_retval) { INITSTREAMS; return mStream->Available(_retval); }
NS_IMETHODIMP nsMIMEInputStream::Read(char * buf, uint32_t count, uint32_t *_retval) { INITSTREAMS; return mStream->Read(buf, count, _retval); }
NS_IMETHODIMP nsMIMEInputStream::IsNonBlocking(bool *aNonBlocking) { INITSTREAMS; return mStream->IsNonBlocking(aNonBlocking); }

// nsISeekableStream
NS_IMETHODIMP nsMIMEInputStream::Tell(int64_t *_retval)
{
    INITSTREAMS;
    nsCOMPtr<nsISeekableStream> stream = do_QueryInterface(mStream);
    return stream->Tell(_retval);
}
NS_IMETHODIMP nsMIMEInputStream::SetEOF(void) {
    INITSTREAMS;
    nsCOMPtr<nsISeekableStream> stream = do_QueryInterface(mStream);
    return stream->SetEOF();
}


/**
 * Factory method used by do_CreateInstance
 */

nsresult
nsMIMEInputStreamConstructor(nsISupports *outer, REFNSIID iid, void **result)
{
    *result = nullptr;

    if (outer)
        return NS_ERROR_NO_AGGREGATION;

    RefPtr<nsMIMEInputStream> inst = new nsMIMEInputStream();
    if (!inst)
        return NS_ERROR_OUT_OF_MEMORY;

    return inst->QueryInterface(iid, result);
}

void
nsMIMEInputStream::Serialize(InputStreamParams& aParams,
                             FileDescriptorArray& aFileDescriptors)
{
    MIMEInputStreamParams params;

    if (mStream) {
        InputStreamParams wrappedParams;
        InputStreamHelper::SerializeInputStream(mStream, wrappedParams,
                                                aFileDescriptors);

        NS_ASSERTION(wrappedParams.type() != InputStreamParams::T__None,
                     "Wrapped stream failed to serialize!");

        params.optionalStream() = wrappedParams;
    }
    else {
        params.optionalStream() = mozilla::void_t();
    }

    params.headers() = mHeaders;
    params.startedReading() = mStartedReading;

    aParams = params;
}

bool
nsMIMEInputStream::Deserialize(const InputStreamParams& aParams,
                               const FileDescriptorArray& aFileDescriptors)
{
    if (aParams.type() != InputStreamParams::TMIMEInputStreamParams) {
        NS_ERROR("Received unknown parameters from the other process!");
        return false;
    }

    const MIMEInputStreamParams& params =
        aParams.get_MIMEInputStreamParams();
    const OptionalInputStreamParams& wrappedParams = params.optionalStream();

    mHeaders = params.headers();
    mStartedReading = params.startedReading();

    if (wrappedParams.type() == OptionalInputStreamParams::TInputStreamParams) {
        nsCOMPtr<nsIInputStream> stream;
        stream =
            InputStreamHelper::DeserializeInputStream(wrappedParams.get_InputStreamParams(),
                                                      aFileDescriptors);
        if (!stream) {
            NS_WARNING("Failed to deserialize wrapped stream!");
            return false;
        }

        mStream = stream;
    }
    else {
        NS_ASSERTION(wrappedParams.type() == OptionalInputStreamParams::Tvoid_t,
                     "Unknown type for OptionalInputStreamParams!");
    }

    return true;
}

Maybe<uint64_t>
nsMIMEInputStream::ExpectedSerializedLength()
{
    nsCOMPtr<nsIIPCSerializableInputStream> serializable = do_QueryInterface(mStream);
    return serializable ? serializable->ExpectedSerializedLength() : Nothing();
}

bool
nsMIMEInputStream::IsIPCSerializable() const
{
    // If SetData() or Deserialize() has not be called yet, mStream is null.
    if (!mStream) {
      return true;
    }

    nsCOMPtr<nsIIPCSerializableInputStream> serializable = do_QueryInterface(mStream);
    return !!serializable;
}
