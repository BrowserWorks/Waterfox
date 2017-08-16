/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "RenderTextureHost.h"
#include "RenderThread.h"

namespace mozilla {
namespace wr {

RenderTextureHost::RenderTextureHost()
{
  MOZ_COUNT_CTOR(RenderTextureHost);
}

RenderTextureHost::~RenderTextureHost()
{
  MOZ_ASSERT(RenderThread::IsInRenderThread());
  MOZ_COUNT_DTOR(RenderTextureHost);
}

} // namespace wr
} // namespace mozilla
