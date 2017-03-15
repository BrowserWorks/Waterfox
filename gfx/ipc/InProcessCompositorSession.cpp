/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "InProcessCompositorSession.h"

// so we can cast an APZCTreeManager to an IAPZCTreeManager
#include "mozilla/layers/APZCTreeManager.h"
#include "mozilla/layers/IAPZCTreeManager.h"

namespace mozilla {
namespace layers {

InProcessCompositorSession::InProcessCompositorSession(widget::CompositorWidget* aWidget,
                                                       CompositorBridgeChild* aChild,
                                                       CompositorBridgeParent* aParent)
 : CompositorSession(aWidget->AsDelegate(), aChild, aParent->RootLayerTreeId()),
   mCompositorBridgeParent(aParent),
   mCompositorWidget(aWidget)
{
}

/* static */ RefPtr<InProcessCompositorSession>
InProcessCompositorSession::Create(nsIWidget* aWidget,
                                   LayerManager* aLayerManager,
                                   const uint64_t& aRootLayerTreeId,
                                   CSSToLayoutDeviceScale aScale,
                                   bool aUseAPZ,
                                   bool aUseExternalSurfaceSize,
                                   const gfx::IntSize& aSurfaceSize)
{
  CompositorWidgetInitData initData;
  aWidget->GetCompositorWidgetInitData(&initData);

  RefPtr<CompositorWidget> widget = CompositorWidget::CreateLocal(initData, aWidget);
  RefPtr<CompositorBridgeChild> child = new CompositorBridgeChild(aLayerManager);
  RefPtr<CompositorBridgeParent> parent =
    child->InitSameProcess(widget, aRootLayerTreeId, aScale, aUseAPZ, aUseExternalSurfaceSize, aSurfaceSize);

  return new InProcessCompositorSession(widget, child, parent);
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

bool
InProcessCompositorSession::Reset(const nsTArray<LayersBackend>& aBackendHints, TextureFactoryIdentifier* aOutIdentifier)
{
  return mCompositorBridgeParent->ResetCompositor(aBackendHints, aOutIdentifier);
}

void
InProcessCompositorSession::Shutdown()
{
  // Destroy will synchronously wait for the parent to acknowledge shutdown,
  // at which point CBP will defer a Release on the compositor thread. We
  // can safely release our reference now, and let the destructor run on either
  // thread.
  mCompositorBridgeChild->Destroy();
  mCompositorBridgeChild = nullptr;
  mCompositorBridgeParent = nullptr;
  mCompositorWidget = nullptr;
}

} // namespace layers
} // namespace mozilla
