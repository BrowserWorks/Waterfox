float4x4 mLayerTransform;
float4 vRenderTargetOffset;
float4x4 mProjection;

typedef float4 rect;
rect vTextureCoords;
rect vLayerQuad;
rect vMaskQuad;

texture tex0;
sampler s2D;
sampler s2DWhite;
sampler s2DY;
sampler s2DCb;
sampler s2DCr;
sampler s2DMask;


float fLayerOpacity;
float4 fLayerColor;
row_major float3x3 mYuvColorMatrix : register(ps, c1);

struct VS_INPUT {
  float4 vPosition : POSITION;
};

struct VS_OUTPUT {
  float4 vPosition : POSITION;
  float2 vTexCoords : TEXCOORD0;
};

struct VS_OUTPUT_MASK {
  float4 vPosition : POSITION;
  float2 vTexCoords : TEXCOORD0;
  float3 vMaskCoords : TEXCOORD1;
};

VS_OUTPUT LayerQuadVS(const VS_INPUT aVertex)
{
  VS_OUTPUT outp;
  outp.vPosition = aVertex.vPosition;

  // We use 4 component floats to uniquely describe a rectangle, by the structure
  // of x, y, width, height. This allows us to easily generate the 4 corners
  // of any rectangle from the 4 corners of the 0,0-1,1 quad that we use as the
  // stream source for our LayerQuad vertex shader. We do this by doing:
  // Xout = x + Xin * width
  // Yout = y + Yin * height
  float2 position = vLayerQuad.xy;
  float2 size = vLayerQuad.zw;
  outp.vPosition.x = position.x + outp.vPosition.x * size.x;
  outp.vPosition.y = position.y + outp.vPosition.y * size.y;

  outp.vPosition = mul(mLayerTransform, outp.vPosition);
  outp.vPosition.xyz /= outp.vPosition.w;
  outp.vPosition = outp.vPosition - vRenderTargetOffset;
  outp.vPosition.xyz *= outp.vPosition.w;

  // adjust our vertices to match d3d9's pixel coordinate system
  // which has pixel centers at integer locations
  outp.vPosition.xy -= 0.5;

  outp.vPosition = mul(mProjection, outp.vPosition);

  position = vTextureCoords.xy;
  size = vTextureCoords.zw;
  outp.vTexCoords.x = position.x + aVertex.vPosition.x * size.x;
  outp.vTexCoords.y = position.y + aVertex.vPosition.y * size.y;

  return outp;
}

VS_OUTPUT_MASK LayerQuadVSMask(const VS_INPUT aVertex)
{
  VS_OUTPUT_MASK outp;
  float4 position = float4(0, 0, 0, 1);

  // We use 4 component floats to uniquely describe a rectangle, by the structure
  // of x, y, width, height. This allows us to easily generate the 4 corners
  // of any rectangle from the 4 corners of the 0,0-1,1 quad that we use as the
  // stream source for our LayerQuad vertex shader. We do this by doing:
  // Xout = x + Xin * width
  // Yout = y + Yin * height
  float2 size = vLayerQuad.zw;
  position.x = vLayerQuad.x + aVertex.vPosition.x * size.x;
  position.y = vLayerQuad.y + aVertex.vPosition.y * size.y;

  position = mul(mLayerTransform, position);
  outp.vPosition.w = position.w;
  outp.vPosition.xyz = position.xyz / position.w;
  outp.vPosition = outp.vPosition - vRenderTargetOffset;
  outp.vPosition.xyz *= outp.vPosition.w;

  // adjust our vertices to match d3d9's pixel coordinate system
  // which has pixel centers at integer locations
  outp.vPosition.xy -= 0.5;

  outp.vPosition = mul(mProjection, outp.vPosition);

  // calculate the position on the mask texture
  outp.vMaskCoords.x = (position.x - vMaskQuad.x) / vMaskQuad.z;
  outp.vMaskCoords.y = (position.y - vMaskQuad.y) / vMaskQuad.w;
  // correct for perspective correct interpolation, see comment in D3D11 shader
  outp.vMaskCoords.z = 1;
  outp.vMaskCoords *= position.w;

  size = vTextureCoords.zw;
  outp.vTexCoords.x = vTextureCoords.x + aVertex.vPosition.x * size.x;
  outp.vTexCoords.y = vTextureCoords.y + aVertex.vPosition.y * size.y;

  return outp;
}

float4 ComponentPass1Shader(const VS_OUTPUT aVertex) : COLOR
{
  float4 src = tex2D(s2D, aVertex.vTexCoords);
  float4 alphas = 1.0 - tex2D(s2DWhite, aVertex.vTexCoords) + src;
  alphas.a = alphas.g;
  return alphas * fLayerOpacity;
}

float4 ComponentPass2Shader(const VS_OUTPUT aVertex) : COLOR
{
  float4 src = tex2D(s2D, aVertex.vTexCoords);
  float4 alphas = 1.0 - tex2D(s2DWhite, aVertex.vTexCoords) + src;
  src.a = alphas.g;
  return src * fLayerOpacity;
}

float4 RGBAShader(const VS_OUTPUT aVertex) : COLOR
{
  return tex2D(s2D, aVertex.vTexCoords) * fLayerOpacity;
}

float4 RGBShader(const VS_OUTPUT aVertex) : COLOR
{
  float4 result;
  result = tex2D(s2D, aVertex.vTexCoords);
  result.a = 1.0;
  return result * fLayerOpacity;
}

/* From Rec601:
[R]   [1.1643835616438356,  0.0,                 1.5960267857142858]      [ Y -  16]
[G] = [1.1643835616438358, -0.3917622900949137, -0.8129676472377708]    x [Cb - 128]
[B]   [1.1643835616438356,  2.017232142857143,   8.862867620416422e-17]   [Cr - 128]

For [0,1] instead of [0,255], and to 5 places:
[R]   [1.16438,  0.00000,  1.59603]   [ Y - 0.06275]
[G] = [1.16438, -0.39176, -0.81297] x [Cb - 0.50196]
[B]   [1.16438,  2.01723,  0.00000]   [Cr - 0.50196]

From Rec709:
[R]   [1.1643835616438356,  4.2781193979771426e-17, 1.7927410714285714]     [ Y -  16]
[G] = [1.1643835616438358, -0.21324861427372963,   -0.532909328559444]    x [Cb - 128]
[B]   [1.1643835616438356,  2.1124017857142854,     0.0]                    [Cr - 128]

For [0,1] instead of [0,255], and to 5 places:
[R]   [1.16438,  0.00000,  1.79274]   [ Y - 0.06275]
[G] = [1.16438, -0.21325, -0.53291] x [Cb - 0.50196]
[B]   [1.16438,  2.11240,  0.00000]   [Cr - 0.50196]
*/
float4 YCbCrShader(const VS_OUTPUT aVertex) : COLOR
{
  float3 yuv;
  float4 color;

  yuv.x = tex2D(s2DY, aVertex.vTexCoords).a  - 0.06275;
  yuv.y = tex2D(s2DCb, aVertex.vTexCoords).a - 0.50196;
  yuv.z = tex2D(s2DCr, aVertex.vTexCoords).a - 0.50196;

  color.rgb = mul(mYuvColorMatrix, yuv);
  color.a = 1.0f;

  return color * fLayerOpacity;
}

float4 SolidColorShader(const VS_OUTPUT aVertex) : COLOR
{
  return fLayerColor;
}

float4 ComponentPass1ShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float4 src = tex2D(s2D, aVertex.vTexCoords);
  float4 alphas = 1.0 - tex2D(s2DWhite, aVertex.vTexCoords) + src;
  alphas.a = alphas.g;
  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return alphas * fLayerOpacity * mask;
}

float4 ComponentPass2ShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float4 src = tex2D(s2D, aVertex.vTexCoords);
  float4 alphas = 1.0 - tex2D(s2DWhite, aVertex.vTexCoords) + src;
  src.a = alphas.g;
  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return src * fLayerOpacity * mask;
}

float4 RGBAShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return tex2D(s2D, aVertex.vTexCoords) * fLayerOpacity * mask;
}

float4 RGBShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float4 result;
  result = tex2D(s2D, aVertex.vTexCoords);
  result.a = 1.0;
  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return result * fLayerOpacity * mask;
}

float4 YCbCrShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float3 yuv;
  float4 color;

  yuv.x = tex2D(s2DY, aVertex.vTexCoords).a  - 0.06275;
  yuv.y = tex2D(s2DCb, aVertex.vTexCoords).a - 0.50196;
  yuv.z = tex2D(s2DCr, aVertex.vTexCoords).a - 0.50196;

  color.rgb = mul((float3x3)mYuvColorMatrix, yuv);
  color.a = 1.0f;

  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return color * fLayerOpacity * mask;
}

float4 SolidColorShaderMask(const VS_OUTPUT_MASK aVertex) : COLOR
{
  float2 maskCoords = aVertex.vMaskCoords.xy / aVertex.vMaskCoords.z;
  float mask = tex2D(s2DMask, maskCoords).a;
  return fLayerColor * mask;
}
