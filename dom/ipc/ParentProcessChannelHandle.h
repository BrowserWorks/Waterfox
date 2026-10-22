/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_ParentProcessChannelHandle_h
#define mozilla_dom_ParentProcessChannelHandle_h

#include "mozilla/Variant.h"
#include "nsIChannel.h"
#include "nsISupportsImpl.h"

namespace mozilla::dom {

class CanonicalBrowsingContext;
class WindowGlobalParent;

// A handle corresponding to a parent-process channel which was created to load
// a document by DocumentLoadListener.
//
// In the parent process, this type contains both the channel, created by
// DocumentLoadListener, which resulted in the document being loaded, as well as
// some information about the expected target which can be used to validate that
// the document is being loaded into that expected context.
//
// Within a content process, this type contains a UUID, which can be used to
// look up the parent process object from ContentParent. This is done implicitly
// as the object is sent over IPC.
class ParentProcessChannelHandle {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING_WITH_DELETE_ON_MAIN_THREAD(
      ParentProcessChannelHandle)

  // Expect that this ParentProcessChannelHandle is loaded within the
  // BrowsingContext identified by mBrowsingContextId.
  struct ExpectLoadedWithin {
    const uint64_t mBrowsingContextId;
  };

  // Expect that this ParentProcessChannelHandle is loaded in a child
  // BrowsingContext of mParentWindowId. This is used for object/embed loads
  // where the BrowsingContext may be materialized within the content process.
  struct ExpectChildOf {
    const uint64_t mParentWindowId;
  };

  using ExpectedContext = Variant<ExpectLoadedWithin, ExpectChildOf>;

  // aHistoryLoadId is the LoadingSessionHistoryInfo::mLoadId of the load the
  // channel was created for, or 0 if it has none.
  ParentProcessChannelHandle(const ExpectedContext& aExpectedContext,
                             nsIChannel* aChannel, uint64_t aHistoryLoadId);

  // The provided BrowsingContext is the context where the load is expected to
  // complete. If provided `aStaticCloneOf` is the WindowGlobal which the
  // document being loaded was statically cloned from.
  //
  // NOTE: This method should only be called in the parent process.
  Result<nsCOMPtr<nsIChannel>, StaticString> GetChannel(
      CanonicalBrowsingContext* aBrowsingContext,
      WindowGlobalParent* aStaticCloneOf = nullptr) const;

  // NOTE: This method should only be called in the parent process.
  uint64_t HistoryLoadId() const;

 private:
  friend struct IPC::ParamTraits<ParentProcessChannelHandle*>;

  ~ParentProcessChannelHandle();

  explicit ParentProcessChannelHandle(const nsID& aUuid);

  // NOTE: This method should only be called in the content process.
  const nsID& GetUuid() const;

  struct Record {
    // The context where we expect the ParentProcessChannelHandle to be loaded.
    // See documentation above for the meaning.
    const ExpectedContext mExpectedContext;

    // The actual nsIChannel instance which was loaded into the content process.
    const nsCOMPtr<nsIChannel> mChannel;

    // The session history load which mChannel was created for, or 0.
    const uint64_t mHistoryLoadId;
  };

  const Variant<nsID, Record> mUuidOrRecord;
};

}  // namespace mozilla::dom

namespace IPC {

template <>
struct ParamTraits<mozilla::dom::ParentProcessChannelHandle*> {
  using paramType = mozilla::dom::ParentProcessChannelHandle;
  static void Write(MessageWriter* aWriter, paramType* aParam);
  static bool Read(MessageReader* aReader, RefPtr<paramType>* aResult);
};

}  // namespace IPC

#endif  // mozilla_dom_ParentProcessChannelHandle_h
