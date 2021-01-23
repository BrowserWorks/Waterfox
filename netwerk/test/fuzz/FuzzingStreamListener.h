#ifndef FuzzingStreamListener_h__
#define FuzzingStreamListener_h__

#include "nsCOMPtr.h"
#include "nsNetCID.h"
#include "nsString.h"
#include "nsNetUtil.h"
#include "nsIStreamListener.h"
#include "nsThreadUtils.h"

namespace mozilla {
namespace net {

class FuzzingStreamListener final : public nsIStreamListener {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER

  FuzzingStreamListener() = default;

  void waitUntilDone() {
    SpinEventLoopUntil([&]() { return mChannelDone; });
  }

  bool isDone() { return mChannelDone; }

 private:
  ~FuzzingStreamListener() = default;
  bool mChannelDone = false;
};

}  // namespace net
}  // namespace mozilla

#endif
