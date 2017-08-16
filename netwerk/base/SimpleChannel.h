/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef SimpleChannel_h
#define SimpleChannel_h

#include "mozilla/Result.h"
#include "mozilla/UniquePtr.h"
#include "nsCOMPtr.h"

class nsIChannel;
class nsIInputStream;
class nsILoadInfo;
class nsIRequest;
class nsIStreamListener;
class nsIURI;

//-----------------------------------------------------------------------------

namespace mozilla {

using InputStreamOrReason = Result<nsCOMPtr<nsIInputStream>, nsresult>;
using RequestOrReason = Result<nsCOMPtr<nsIRequest>, nsresult>;

namespace net {

class SimpleChannelCallbacks
{
public:
  virtual InputStreamOrReason OpenContentStream(bool async, nsIChannel* channel) = 0;

  virtual RequestOrReason StartAsyncRead(nsIStreamListener* stream, nsIChannel* channel) = 0;

  virtual ~SimpleChannelCallbacks() {}
};

template <typename F1, typename F2, typename T>
class SimpleChannelCallbacksImpl final : public SimpleChannelCallbacks
{
public:
  SimpleChannelCallbacksImpl(F1&& aStartAsyncRead, F2&& aOpenContentStream, T* context)
    : mStartAsyncRead(aStartAsyncRead)
    , mOpenContentStream(aOpenContentStream)
    , mContext(context)
  {}

  virtual ~SimpleChannelCallbacksImpl() {}

  virtual InputStreamOrReason OpenContentStream(bool async, nsIChannel* channel) override
  {
    return mOpenContentStream(async, channel, mContext);
  }

  virtual RequestOrReason StartAsyncRead(nsIStreamListener* listener, nsIChannel* channel) override
  {
    return mStartAsyncRead(listener, channel, mContext);
  }

private:
  F1 mStartAsyncRead;
  F2 mOpenContentStream;
  RefPtr<T> mContext;
};

already_AddRefed<nsIChannel>
NS_NewSimpleChannelInternal(nsIURI* aURI, nsILoadInfo* aLoadInfo, UniquePtr<SimpleChannelCallbacks>&& aCallbacks);

} // namespace net
} // namespace mozilla

/**
 * Creates a simple channel which wraps an input stream created by the given
 * callbacks. The callbacks are not called until the underlying AsyncOpen2 or
 * Open2 methods are called, and correspond to the nsBaseChannel::StartAsyncRead
 * and nsBaseChannel::OpenContentStream methods of the same names.
 *
 * The last two arguments of each callback are the created channel instance,
 * and the ref-counted context object passed to NS_NewSimpleChannel. A strong
 * reference to that object is guaranteed to be kept alive until after a
 * callback successfully completes.
 */
template <typename T, typename F1, typename F2>
inline already_AddRefed<nsIChannel>
NS_NewSimpleChannel(nsIURI* aURI, nsILoadInfo* aLoadInfo, T* context, F1&& aStartAsyncRead, F2&& aOpenContentStream)
{
  using namespace mozilla;

  auto callbacks = MakeUnique<net::SimpleChannelCallbacksImpl<F1, F2, T>>(
      Move(aStartAsyncRead), Move(aOpenContentStream), context);

  return net::NS_NewSimpleChannelInternal(aURI, aLoadInfo, Move(callbacks));
}

template <typename T, typename F1>
inline already_AddRefed<nsIChannel>
NS_NewSimpleChannel(nsIURI* aURI, nsILoadInfo* aLoadInfo, T* context, F1&& aStartAsyncRead)
{
  using namespace mozilla;

  auto openContentStream = [] (bool async, nsIChannel* channel, T* context) {
    return Err(NS_ERROR_NOT_IMPLEMENTED);
  };

  return NS_NewSimpleChannel(
      aURI, aLoadInfo, context, Move(aStartAsyncRead), Move(openContentStream));
}

#endif // SimpleChannel_h
