/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "InProcessCompositorSession.h"

// so we can cast an APZCTreeManager to an IAPZCTreeManager
#include "mozilla/layers/APZCTreeManager.h"
#include "mozilla/layers/IAPZCTreeManager.h"
#include "nsBaseWidget.h"

namespace mozilla {
namespace layers {

InProcessCompositorSession::InProcessCompositorSession(widget::CompositorWidget* aWidget,
                                                       nsBaseWidget* baseWidget,
                                                       CompositorBridgeChild* aChild,
                                                       CompositorBridgeParent* aParent)
 : CompositorSession(aWidget->AsDelegate(), aChild, aParent->RootLayerTreeId()),
   mWidget(baseWidget),
   mCompositorBridgeParent(aParent),
   mCompositorWidget(aWidget)
{
  GPUProcessManager::Get()->RegisterInProcessSession(this);
}

/* static */ RefPtr<InProcessCompositorSession>
InProcessCompositorSession::Create(nsBaseWidget* aWidget,
                                   LayerManager* aLayerManager,
                                   const uint64_t& aRootLayerTreeId,
                                   CSSToLayoutDeviceScale aScale,
                                   const CompositorOptions& aOptions,
                                   bool aUseExternalSurfaceSize,
                                   const gfx::IntSize& aSurfaceSize,
                                   uint32_t aNamespace)
{
  CompositorWidgetInitData initData;
  aWidget->GetCompositorWidgetInitData(&initData);

  RefPtr<CompositorWidget> widget = CompositorWidget::CreateLocal(initData, aOptions, aWidget);
  RefPtr<CompositorBridgeParent> parent =
    CompositorManagerParent::CreateSameProcessWidgetCompositorBridge(aScale, aOptions,
                                                                     aUseExternalSurfaceSize,
                                                                     aSurfaceSize);
  MOZ_ASSERT(parent);
  parent->InitSameProcess(widget, aRootLayerTreeId);

  RefPtr<CompositorBridgeChild> child =
    CompositorManagerChild::CreateSameProcessWidgetCompositorBridge(aLayerManager,
                                                                    aNamespace);
  MOZ_ASSERT(child);

  return new InProcessCompositorSession(widget, aWidget, child, parent);
}

void
InProcessCompositorSession::NotifySessionLost()
{
  mWidget->NotifyCompositorSessionLost(this);
}

CompositorBridgeParent*
InProcessCompositorSession::GetInProcessBridge() const
{
  return mCompositorBridgeParent;
}

void
InProcessCompositorSession::SetContentController(GeckoContentController* aController)
{
  mCompositorBridgeParent->SetControllerForLayerTree(mRootLayerTreeId, aController);
}

RefPtr<IAPZCTreeManager>
InProcessCompositorSession::GetAPZCTreeManager() const
{
  return mCompositorBridgeParent->GetAPZCTreeManager(mRootLayerTreeId);
}

nsIWidget*
InProcessCompositorSession::GetWidget() const
{
  return mWidget;
}

void
InProcessCompositorSession::Shutdown()
{
  // Destroy will synchronously wait for the parent to acknowledge shutdown,
  // at which point CBP will defer a Release on the compositor thread. We
  // can safely release our reference now, and let the destructor run on either
  // thread.
#if defined(MOZ_WIDGET_ANDROID)
  if (mUiCompositorControllerChild) {
    mUiCompositorControllerChild->Destroy();
    mUiCompositorControllerChild = nullptr;
  }
#endif //defined(MOZ_WIDGET_ANDROID)
  mCompositorBridgeChild->Destroy();
  mCompositorBridgeChild = nullptr;
  mCompositorBridgeParent = nullptr;
  mCompositorWidget = nullptr;
  GPUProcessManager::Get()->UnregisterInProcessSession(this);
}

} // namespace layers
} // namespace mozilla
