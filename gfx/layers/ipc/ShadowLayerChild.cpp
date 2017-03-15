/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ShadowLayerChild.h"
#include "Layers.h"                     // for Layer
#include "ShadowLayers.h"               // for ShadowableLayer

namespace mozilla {
namespace layers {

ShadowLayerChild::ShadowLayerChild()
  : mLayer(nullptr)
{ }

ShadowLayerChild::~ShadowLayerChild()
{ }

void
ShadowLayerChild::SetShadowableLayer(ShadowableLayer* aLayer)
{
  MOZ_ASSERT(!mLayer);
  mLayer = aLayer;
}

void
ShadowLayerChild::ActorDestroy(ActorDestroyReason why)
{
  MOZ_ASSERT(AncestorDeletion != why,
             "shadowable layer should have been cleaned up by now");

  if (AbnormalShutdown == why && mLayer) {
    // This is last-ditch emergency shutdown.  Just have the layer
    // forget its IPDL resources; IPDL-generated code will clean up
    // automatically in this case.
    mLayer->AsLayer()->Disconnect();
    mLayer = nullptr;
  }
}

} // namespace layers
} // namespace mozilla
