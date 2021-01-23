/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_plugins_PluginWidgetParent_h
#define mozilla_plugins_PluginWidgetParent_h

#ifndef XP_WIN
#  error "This header should be Windows-only."
#endif

#include "mozilla/plugins/PPluginWidgetParent.h"
#include "mozilla/UniquePtr.h"
#include "nsIWidget.h"
#include "nsCOMPtr.h"

namespace mozilla {

namespace dom {
class BrowserParent;
}  // namespace dom

namespace plugins {

class PluginWidgetParent : public PPluginWidgetParent {
 public:
  PluginWidgetParent();
  virtual ~PluginWidgetParent();

  virtual void ActorDestroy(ActorDestroyReason aWhy) override;
  virtual mozilla::ipc::IPCResult RecvCreate(
      nsresult* aResult, uint64_t* aScrollCaptureId,
      uintptr_t* aPluginInstanceId) override;
  virtual mozilla::ipc::IPCResult RecvSetFocus(
      const bool& aRaise, const mozilla::dom::CallerType& aCallerType) override;
  virtual mozilla::ipc::IPCResult RecvGetNativePluginPort(
      uintptr_t* value) override;
  mozilla::ipc::IPCResult RecvSetNativeChildWindow(
      const uintptr_t& aChildWindow) override;

  // Helper for compositor checks on the channel
  bool ActorDestroyed() { return !mWidget; }

  // Called by PBrowser when it receives a Destroy() call from the child.
  void ParentDestroy();

  // Sets mWidget's parent
  void SetParent(nsIWidget* aParent);

 private:
  // The tab our connection is associated with.
  mozilla::dom::BrowserParent* GetBrowserParent();

 private:
  void KillWidget();

  // The chrome side native widget.
  nsCOMPtr<nsIWidget> mWidget;
};

}  // namespace plugins
}  // namespace mozilla

#endif  // mozilla_plugins_PluginWidgetParent_h
