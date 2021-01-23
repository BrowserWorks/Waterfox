/* vim: set sw=2 ts=8 et tw=80 : */

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_DocumentChannelParent_h
#define mozilla_net_DocumentChannelParent_h

#include "mozilla/net/PDocumentChannelParent.h"
#include "mozilla/net/DocumentLoadListener.h"

namespace mozilla {
namespace dom {
class CanonicalBrowsingContext;
}
namespace net {

/**
 * An implementation of ADocumentChannelBridge that forwards all changes across
 * to DocumentChannelChild, the nsIChannel implementation owned by a content
 * process docshell.
 */
class DocumentChannelParent final : public ADocumentChannelBridge,
                                    public PDocumentChannelParent {
 public:
  NS_INLINE_DECL_REFCOUNTING(DocumentChannelParent, override);

  explicit DocumentChannelParent();

  bool Init(dom::CanonicalBrowsingContext* aContext,
            const DocumentChannelCreationArgs& aArgs);

  // PDocumentChannelParent
  bool RecvCancel(const nsresult& aStatus) {
    if (mParent) {
      mParent->Cancel(aStatus);
    }
    return true;
  }
  void ActorDestroy(ActorDestroyReason aWhy) override {
    if (mParent) {
      mParent->DocumentChannelBridgeDisconnected();
      mParent = nullptr;
    }
  }

 private:
  // DocumentChannelListener
  void DisconnectChildListeners(nsresult aStatus,
                                nsresult aLoadGroupStatus) override {
    if (CanSend()) {
      Unused << SendDisconnectChildListeners(aStatus, aLoadGroupStatus);
    }
    mParent = nullptr;
  }

  void Delete() override {
    if (CanSend()) {
      Unused << SendDeleteSelf();
    }
  }

  ProcessId OtherPid() const override { return IProtocol::OtherPid(); }

  RefPtr<PDocumentChannelParent::RedirectToRealChannelPromise>
  RedirectToRealChannel(
      nsTArray<ipc::Endpoint<extensions::PStreamFilterParent>>&&
          aStreamFilterEndpoints,
      uint32_t aRedirectFlags, uint32_t aLoadFlags) override;

  virtual ~DocumentChannelParent();

  RefPtr<DocumentLoadListener> mParent;
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_DocumentChannelParent_h
