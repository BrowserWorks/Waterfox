/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#include "common-vs.hlsl"
#include "color-common.hlsl"

struct VS_COLORQUAD
{
  float2 vPos : POSITION;
  float4 vRect : TEXCOORD0;
  uint vLayerId : TEXCOORD1;
  int vDepth : TEXCOORD2;
  float4 vColor : TEXCOORD3;
};

struct VS_COLORVERTEX
{
  float3 vUnitPos : POSITION0;
  float2 vPos1 : POSITION1;
  float2 vPos2 : POSITION2;
  float2 vPos3 : POSITION3;
  uint vLayerId : TEXCOORD0;
  int vDepth : TEXCOORD1;
  float4 vColor : TEXCOORD2;
};

VS_COLOROUTPUT ColorImpl(float4 aColor, const VertexInfo aInfo)
{
  VS_COLOROUTPUT output;
  output.vPosition = aInfo.worldPos;
  output.vLocalPos = aInfo.screenPos;
  output.vColor = aColor;
  output.vClipRect = aInfo.clipRect;
  output.vMaskCoords = aInfo.maskCoords;
  return output;
}

VS_COLOROUTPUT_CLIPPED ColoredQuadVS(const VS_COLORQUAD aInput)
{
  float4 worldPos = ComputeClippedPosition(
    aInput.vPos,
    aInput.vRect,
    aInput.vLayerId,
    aInput.vDepth);

  VS_COLOROUTPUT_CLIPPED output;
  output.vPosition = worldPos;
  output.vColor = aInput.vColor;
  return output;
}

VS_COLOROUTPUT ColoredVertexVS(const VS_COLORVERTEX aInput)
{
  float2 layerPos = UnitTriangleToPos(aInput.vUnitPos, aInput.vPos1, aInput.vPos2, aInput.vPos3);
  VertexInfo info = ComputePosition(layerPos, aInput.vLayerId, aInput.vDepth);
  return ColorImpl(aInput.vColor, info);
}
