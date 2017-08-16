//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// dxgi_support_table:
//   Queries for DXGI support of various texture formats. Depends on DXGI
//   version, D3D feature level, and is sometimes guaranteed or optional.
//

#ifndef LIBANGLE_RENDERER_D3D_D3D11_DXGISUPPORTTABLE_H_
#define LIBANGLE_RENDERER_D3D_D3D11_DXGISUPPORTTABLE_H_

#include "common/platform.h"

namespace rx
{

namespace d3d11
{

struct DXGISupport
{
    DXGISupport()
        : alwaysSupportedFlags(0),
          neverSupportedFlags(0),
          optionallySupportedFlags(0)
    {
    }

    DXGISupport(UINT alwaysSupportedIn, UINT neverSupportedIn, UINT optionallySupportedIn)
        : alwaysSupportedFlags(alwaysSupportedIn),
          neverSupportedFlags(neverSupportedIn),
          optionallySupportedFlags(optionallySupportedIn)
    {
    }

    UINT alwaysSupportedFlags;
    UINT neverSupportedFlags;
    UINT optionallySupportedFlags;
};

const DXGISupport &GetDXGISupport(DXGI_FORMAT dxgiFormat, D3D_FEATURE_LEVEL featureLevel);

} // namespace d3d11

} // namespace rx

#endif // LIBANGLE_RENDERER_D3D_D3D11_DXGISUPPORTTABLE_H_
