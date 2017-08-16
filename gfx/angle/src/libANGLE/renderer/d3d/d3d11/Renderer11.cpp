//
// Copyright (c) 2012-2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Renderer11.cpp: Implements a back-end specific class for the D3D11 renderer.

#include "libANGLE/renderer/d3d/d3d11/Renderer11.h"

#include <EGL/eglext.h>
#include <iomanip>
#include <sstream>
#include <versionhelpers.h>

#include "common/tls.h"
#include "common/utilities.h"
#include "libANGLE/Buffer.h"
#include "libANGLE/Display.h"
#include "libANGLE/formatutils.h"
#include "libANGLE/Framebuffer.h"
#include "libANGLE/FramebufferAttachment.h"
#include "libANGLE/histogram_macros.h"
#include "libANGLE/Program.h"
#include "libANGLE/renderer/renderer_utils.h"
#include "libANGLE/renderer/d3d/CompilerD3D.h"
#include "libANGLE/renderer/d3d/DisplayD3D.h"
#include "libANGLE/renderer/d3d/d3d11/Blit11.h"
#include "libANGLE/renderer/d3d/d3d11/Buffer11.h"
#include "libANGLE/renderer/d3d/d3d11/Clear11.h"
#include "libANGLE/renderer/d3d/d3d11/Context11.h"
#include "libANGLE/renderer/d3d/d3d11/dxgi_support_table.h"
#include "libANGLE/renderer/d3d/d3d11/Fence11.h"
#include "libANGLE/renderer/d3d/d3d11/formatutils11.h"
#include "libANGLE/renderer/d3d/d3d11/Framebuffer11.h"
#include "libANGLE/renderer/d3d/d3d11/Image11.h"
#include "libANGLE/renderer/d3d/d3d11/IndexBuffer11.h"
#include "libANGLE/renderer/d3d/d3d11/PixelTransfer11.h"
#include "libANGLE/renderer/d3d/d3d11/Query11.h"
#include "libANGLE/renderer/d3d/d3d11/renderer11_utils.h"
#include "libANGLE/renderer/d3d/d3d11/RenderTarget11.h"
#include "libANGLE/renderer/d3d/d3d11/ShaderExecutable11.h"
#include "libANGLE/renderer/d3d/d3d11/StreamProducerNV12.h"
#include "libANGLE/renderer/d3d/d3d11/SwapChain11.h"
#include "libANGLE/renderer/d3d/d3d11/texture_format_table.h"
#include "libANGLE/renderer/d3d/d3d11/TextureStorage11.h"
#include "libANGLE/renderer/d3d/d3d11/TransformFeedback11.h"
#include "libANGLE/renderer/d3d/d3d11/Trim11.h"
#include "libANGLE/renderer/d3d/d3d11/VertexArray11.h"
#include "libANGLE/renderer/d3d/d3d11/VertexBuffer11.h"
#include "libANGLE/renderer/d3d/CompilerD3D.h"
#include "libANGLE/renderer/d3d/DeviceD3D.h"
#include "libANGLE/renderer/d3d/FramebufferD3D.h"
#include "libANGLE/renderer/d3d/IndexDataManager.h"
#include "libANGLE/renderer/d3d/ProgramD3D.h"
#include "libANGLE/renderer/d3d/RenderbufferD3D.h"
#include "libANGLE/renderer/d3d/ShaderD3D.h"
#include "libANGLE/renderer/d3d/SurfaceD3D.h"
#include "libANGLE/renderer/d3d/TextureD3D.h"
#include "libANGLE/renderer/d3d/VertexDataManager.h"
#include "libANGLE/State.h"
#include "libANGLE/Surface.h"
#include "third_party/trace_event/trace_event.h"

#ifdef ANGLE_ENABLE_WINDOWS_STORE
#include "libANGLE/renderer/d3d/d3d11/winrt/NativeWindow11WinRT.h"
#else
#include "libANGLE/renderer/d3d/d3d11/win32/NativeWindow11Win32.h"
#endif

// Include the D3D9 debug annotator header for use by the desktop D3D11 renderer
// because the D3D11 interface method ID3DUserDefinedAnnotation::GetStatus
// doesn't work with the Graphics Diagnostics tools in Visual Studio 2013.
#ifdef ANGLE_ENABLE_D3D9
#include "libANGLE/renderer/d3d/d3d9/DebugAnnotator9.h"
#endif

// Enable ANGLE_SKIP_DXGI_1_2_CHECK if there is not a possibility of using cross-process
// HWNDs or the Windows 7 Platform Update (KB2670838) is expected to be installed.
#ifndef ANGLE_SKIP_DXGI_1_2_CHECK
#define ANGLE_SKIP_DXGI_1_2_CHECK 0
#endif

#ifdef _DEBUG
// this flag enables suppressing some spurious warnings that pop up in certain WebGL samples
// and conformance tests. to enable all warnings, remove this define.
#define ANGLE_SUPPRESS_D3D11_HAZARD_WARNINGS 1
#endif

namespace rx
{

namespace
{

enum
{
    MAX_TEXTURE_IMAGE_UNITS_VTF_SM4 = 16
};

enum ANGLEFeatureLevel
{
    ANGLE_FEATURE_LEVEL_INVALID,
    ANGLE_FEATURE_LEVEL_9_3,
    ANGLE_FEATURE_LEVEL_10_0,
    ANGLE_FEATURE_LEVEL_10_1,
    ANGLE_FEATURE_LEVEL_11_0,
    ANGLE_FEATURE_LEVEL_11_1,
    NUM_ANGLE_FEATURE_LEVELS
};

ANGLEFeatureLevel GetANGLEFeatureLevel(D3D_FEATURE_LEVEL d3dFeatureLevel)
{
    switch (d3dFeatureLevel)
    {
        case D3D_FEATURE_LEVEL_9_3:
            return ANGLE_FEATURE_LEVEL_9_3;
        case D3D_FEATURE_LEVEL_10_0:
            return ANGLE_FEATURE_LEVEL_10_0;
        case D3D_FEATURE_LEVEL_10_1:
            return ANGLE_FEATURE_LEVEL_10_1;
        case D3D_FEATURE_LEVEL_11_0:
            return ANGLE_FEATURE_LEVEL_11_0;
        // Note: we don't ever request a 11_1 device, because this gives
        // an E_INVALIDARG error on systems that don't have the platform update.
        case D3D_FEATURE_LEVEL_11_1:
            return ANGLE_FEATURE_LEVEL_11_1;
        default:
            return ANGLE_FEATURE_LEVEL_INVALID;
    }
}

void SetLineLoopIndices(GLuint *dest, size_t count)
{
    for (size_t i = 0; i < count; i++)
    {
        dest[i] = static_cast<GLuint>(i);
    }
    dest[count] = 0;
}

template <typename T>
void CopyLineLoopIndices(const GLvoid *indices, GLuint *dest, size_t count)
{
    const T *srcPtr = static_cast<const T *>(indices);
    for (size_t i = 0; i < count; ++i)
    {
        dest[i] = static_cast<GLuint>(srcPtr[i]);
    }
    dest[count] = static_cast<GLuint>(srcPtr[0]);
}

void SetTriangleFanIndices(GLuint *destPtr, size_t numTris)
{
    for (size_t i = 0; i < numTris; i++)
    {
        destPtr[i * 3 + 0] = 0;
        destPtr[i * 3 + 1] = static_cast<GLuint>(i) + 1;
        destPtr[i * 3 + 2] = static_cast<GLuint>(i) + 2;
    }
}

template <typename T>
void CopyLineLoopIndicesWithRestart(const GLvoid *indices,
                                    size_t count,
                                    GLenum indexType,
                                    std::vector<GLuint> *bufferOut)
{
    GLuint restartIndex    = gl::GetPrimitiveRestartIndex(indexType);
    GLuint d3dRestartIndex = static_cast<GLuint>(d3d11::GetPrimitiveRestartIndex());
    const T *srcPtr        = static_cast<const T *>(indices);
    Optional<GLuint> currentLoopStart;

    bufferOut->clear();

    for (size_t indexIdx = 0; indexIdx < count; ++indexIdx)
    {
        GLuint value = static_cast<GLuint>(srcPtr[indexIdx]);

        if (value == restartIndex)
        {
            if (currentLoopStart.valid())
            {
                bufferOut->push_back(currentLoopStart.value());
                bufferOut->push_back(d3dRestartIndex);
                currentLoopStart.reset();
            }
        }
        else
        {
            bufferOut->push_back(value);
            if (!currentLoopStart.valid())
            {
                currentLoopStart = value;
            }
        }
    }

    if (currentLoopStart.valid())
    {
        bufferOut->push_back(currentLoopStart.value());
    }
}

void GetLineLoopIndices(const GLvoid *indices,
                        GLenum indexType,
                        GLuint count,
                        bool usePrimitiveRestartFixedIndex,
                        std::vector<GLuint> *bufferOut)
{
    if (indexType != GL_NONE && usePrimitiveRestartFixedIndex)
    {
        switch (indexType)
        {
            case GL_UNSIGNED_BYTE:
                CopyLineLoopIndicesWithRestart<GLubyte>(indices, count, indexType, bufferOut);
                break;
            case GL_UNSIGNED_SHORT:
                CopyLineLoopIndicesWithRestart<GLushort>(indices, count, indexType, bufferOut);
                break;
            case GL_UNSIGNED_INT:
                CopyLineLoopIndicesWithRestart<GLuint>(indices, count, indexType, bufferOut);
                break;
            default:
                UNREACHABLE();
                break;
        }
        return;
    }

    // For non-primitive-restart draws, the index count is static.
    bufferOut->resize(static_cast<size_t>(count) + 1);

    switch (indexType)
    {
        // Non-indexed draw
        case GL_NONE:
            SetLineLoopIndices(&(*bufferOut)[0], count);
            break;
        case GL_UNSIGNED_BYTE:
            CopyLineLoopIndices<GLubyte>(indices, &(*bufferOut)[0], count);
            break;
        case GL_UNSIGNED_SHORT:
            CopyLineLoopIndices<GLushort>(indices, &(*bufferOut)[0], count);
            break;
        case GL_UNSIGNED_INT:
            CopyLineLoopIndices<GLuint>(indices, &(*bufferOut)[0], count);
            break;
        default:
            UNREACHABLE();
            break;
    }
}

template <typename T>
void CopyTriangleFanIndices(const GLvoid *indices, GLuint *destPtr, size_t numTris)
{
    const T *srcPtr = static_cast<const T *>(indices);

    for (size_t i = 0; i < numTris; i++)
    {
        destPtr[i * 3 + 0] = static_cast<GLuint>(srcPtr[0]);
        destPtr[i * 3 + 1] = static_cast<GLuint>(srcPtr[i + 1]);
        destPtr[i * 3 + 2] = static_cast<GLuint>(srcPtr[i + 2]);
    }
}

template <typename T>
void CopyTriangleFanIndicesWithRestart(const GLvoid *indices,
                                       GLuint indexCount,
                                       GLenum indexType,
                                       std::vector<GLuint> *bufferOut)
{
    GLuint restartIndex    = gl::GetPrimitiveRestartIndex(indexType);
    GLuint d3dRestartIndex = gl::GetPrimitiveRestartIndex(GL_UNSIGNED_INT);
    const T *srcPtr        = static_cast<const T *>(indices);
    Optional<GLuint> vertexA;
    Optional<GLuint> vertexB;

    bufferOut->clear();

    for (size_t indexIdx = 0; indexIdx < indexCount; ++indexIdx)
    {
        GLuint value = static_cast<GLuint>(srcPtr[indexIdx]);

        if (value == restartIndex)
        {
            bufferOut->push_back(d3dRestartIndex);
            vertexA.reset();
            vertexB.reset();
        }
        else
        {
            if (!vertexA.valid())
            {
                vertexA = value;
            }
            else if (!vertexB.valid())
            {
                vertexB = value;
            }
            else
            {
                bufferOut->push_back(vertexA.value());
                bufferOut->push_back(vertexB.value());
                bufferOut->push_back(value);
                vertexB = value;
            }
        }
    }
}

void GetTriFanIndices(const GLvoid *indices,
                      GLenum indexType,
                      GLuint count,
                      bool usePrimitiveRestartFixedIndex,
                      std::vector<GLuint> *bufferOut)
{
    if (indexType != GL_NONE && usePrimitiveRestartFixedIndex)
    {
        switch (indexType)
        {
            case GL_UNSIGNED_BYTE:
                CopyTriangleFanIndicesWithRestart<GLubyte>(indices, count, indexType, bufferOut);
                break;
            case GL_UNSIGNED_SHORT:
                CopyTriangleFanIndicesWithRestart<GLushort>(indices, count, indexType, bufferOut);
                break;
            case GL_UNSIGNED_INT:
                CopyTriangleFanIndicesWithRestart<GLuint>(indices, count, indexType, bufferOut);
                break;
            default:
                UNREACHABLE();
                break;
        }
        return;
    }

    // For non-primitive-restart draws, the index count is static.
    GLuint numTris = count - 2;
    bufferOut->resize(numTris * 3);

    switch (indexType)
    {
        // Non-indexed draw
        case GL_NONE:
            SetTriangleFanIndices(&(*bufferOut)[0], numTris);
            break;
        case GL_UNSIGNED_BYTE:
            CopyTriangleFanIndices<GLubyte>(indices, &(*bufferOut)[0], numTris);
            break;
        case GL_UNSIGNED_SHORT:
            CopyTriangleFanIndices<GLushort>(indices, &(*bufferOut)[0], numTris);
            break;
        case GL_UNSIGNED_INT:
            CopyTriangleFanIndices<GLuint>(indices, &(*bufferOut)[0], numTris);
            break;
        default:
            UNREACHABLE();
            break;
    }
}

int GetWrapBits(GLenum wrap)
{
    switch (wrap)
    {
        case GL_CLAMP_TO_EDGE:
            return 0x1;
        case GL_REPEAT:
            return 0x2;
        case GL_MIRRORED_REPEAT:
            return 0x3;
        default:
            UNREACHABLE();
            return 0;
    }
}

// If we request a scratch buffer requesting a smaller size this many times,
// release and recreate the scratch buffer. This ensures we don't have a
// degenerate case where we are stuck hogging memory.
const int ScratchMemoryBufferLifetime = 1000;

}  // anonymous namespace

Renderer11::Renderer11(egl::Display *display)
    : RendererD3D(display),
      mStateCache(this),
      mStateManager(this),
      mLastHistogramUpdateTime(ANGLEPlatformCurrent()->monotonicallyIncreasingTime()),
      mDebug(nullptr),
      mScratchMemoryBufferResetCounter(0),
      mAnnotator(nullptr)
{
    mVertexDataManager = NULL;
    mIndexDataManager  = NULL;

    mLineLoopIB       = NULL;
    mTriangleFanIB    = NULL;
    mAppliedIBChanged = false;

    mBlit          = NULL;
    mPixelTransfer = NULL;

    mClear = NULL;

    mTrim = NULL;

    mSyncQuery = NULL;

    mRenderer11DeviceCaps.supportsClearView             = false;
    mRenderer11DeviceCaps.supportsConstantBufferOffsets = false;
    mRenderer11DeviceCaps.supportsDXGI1_2               = false;
    mRenderer11DeviceCaps.B5G6R5support                 = 0;
    mRenderer11DeviceCaps.B4G4R4A4support               = 0;
    mRenderer11DeviceCaps.B5G5R5A1support               = 0;

    mD3d11Module          = NULL;
    mDxgiModule           = NULL;
    mDCompModule          = NULL;
    mCreatedWithDeviceEXT = false;
    mEGLDevice            = nullptr;

    mDevice         = NULL;
    mDeviceContext  = NULL;
    mDeviceContext1 = NULL;
    mDxgiAdapter    = NULL;
    mDxgiFactory    = NULL;

    mDriverConstantBufferVS = NULL;
    mDriverConstantBufferPS = NULL;

    mAppliedVertexShader   = NULL;
    mAppliedGeometryShader = NULL;
    mAppliedPixelShader    = NULL;

    mAppliedTFObject = angle::DirtyPointer;

    ZeroMemory(&mAdapterDescription, sizeof(mAdapterDescription));

    if (mDisplay->getPlatform() == EGL_PLATFORM_ANGLE_ANGLE)
    {
        const auto &attributes = mDisplay->getAttributeMap();

        EGLint requestedMajorVersion = static_cast<EGLint>(
            attributes.get(EGL_PLATFORM_ANGLE_MAX_VERSION_MAJOR_ANGLE, EGL_DONT_CARE));
        EGLint requestedMinorVersion = static_cast<EGLint>(
            attributes.get(EGL_PLATFORM_ANGLE_MAX_VERSION_MINOR_ANGLE, EGL_DONT_CARE));

        if (requestedMajorVersion == EGL_DONT_CARE || requestedMajorVersion >= 11)
        {
            if (requestedMinorVersion == EGL_DONT_CARE || requestedMinorVersion >= 0)
            {
                mAvailableFeatureLevels.push_back(D3D_FEATURE_LEVEL_11_0);
            }
        }

        if (requestedMajorVersion == EGL_DONT_CARE || requestedMajorVersion >= 10)
        {
            if (requestedMinorVersion == EGL_DONT_CARE || requestedMinorVersion >= 1)
            {
                mAvailableFeatureLevels.push_back(D3D_FEATURE_LEVEL_10_1);
            }
            if (requestedMinorVersion == EGL_DONT_CARE || requestedMinorVersion >= 0)
            {
                mAvailableFeatureLevels.push_back(D3D_FEATURE_LEVEL_10_0);
            }
        }

        if (requestedMajorVersion == 9 && requestedMinorVersion == 3)
        {
            mAvailableFeatureLevels.push_back(D3D_FEATURE_LEVEL_9_3);
        }

        EGLint requestedDeviceType = static_cast<EGLint>(attributes.get(
            EGL_PLATFORM_ANGLE_DEVICE_TYPE_ANGLE, EGL_PLATFORM_ANGLE_DEVICE_TYPE_HARDWARE_ANGLE));
        switch (requestedDeviceType)
        {
            case EGL_PLATFORM_ANGLE_DEVICE_TYPE_HARDWARE_ANGLE:
                mRequestedDriverType = D3D_DRIVER_TYPE_HARDWARE;
                break;

            case EGL_PLATFORM_ANGLE_DEVICE_TYPE_WARP_ANGLE:
                mRequestedDriverType = D3D_DRIVER_TYPE_WARP;
                break;

            case EGL_PLATFORM_ANGLE_DEVICE_TYPE_REFERENCE_ANGLE:
                mRequestedDriverType = D3D_DRIVER_TYPE_REFERENCE;
                break;

            case EGL_PLATFORM_ANGLE_DEVICE_TYPE_NULL_ANGLE:
                mRequestedDriverType = D3D_DRIVER_TYPE_NULL;
                break;

            default:
                UNREACHABLE();
        }

        const EGLenum presentPath = static_cast<EGLenum>(attributes.get(
            EGL_EXPERIMENTAL_PRESENT_PATH_ANGLE, EGL_EXPERIMENTAL_PRESENT_PATH_COPY_ANGLE));
        mPresentPathFastEnabled = (presentPath == EGL_EXPERIMENTAL_PRESENT_PATH_FAST_ANGLE);
    }
    else if (display->getPlatform() == EGL_PLATFORM_DEVICE_EXT)
    {
        mEGLDevice = GetImplAs<DeviceD3D>(display->getDevice());
        ASSERT(mEGLDevice != nullptr);
        mCreatedWithDeviceEXT = true;

        // Also set EGL_PLATFORM_ANGLE_ANGLE variables, in case they're used elsewhere in ANGLE
        // mAvailableFeatureLevels defaults to empty
        mRequestedDriverType    = D3D_DRIVER_TYPE_UNKNOWN;
        mPresentPathFastEnabled = false;
    }

// The D3D11 renderer must choose the D3D9 debug annotator because the D3D11 interface
// method ID3DUserDefinedAnnotation::GetStatus on desktop builds doesn't work with the Graphics
// Diagnostics tools in Visual Studio 2013.
// The D3D9 annotator works properly for both D3D11 and D3D9.
// Incorrect status reporting can cause ANGLE to log unnecessary debug events.
#ifdef ANGLE_ENABLE_D3D9
    mAnnotator = new DebugAnnotator9();
#else
    mAnnotator = new DebugAnnotator11();
#endif
    ASSERT(mAnnotator);
    gl::InitializeDebugAnnotations(mAnnotator);
}

Renderer11::~Renderer11()
{
    release();
}

#ifndef __d3d11_1_h__
#define D3D11_MESSAGE_ID_DEVICE_DRAW_RENDERTARGETVIEW_NOT_SET ((D3D11_MESSAGE_ID)3146081)
#endif

egl::Error Renderer11::initialize()
{
    HRESULT result = S_OK;

    ANGLE_TRY(initializeD3DDevice());

#if !defined(ANGLE_ENABLE_WINDOWS_STORE)
#if !ANGLE_SKIP_DXGI_1_2_CHECK
    {
        TRACE_EVENT0("gpu.angle", "Renderer11::initialize (DXGICheck)");
        // In order to create a swap chain for an HWND owned by another process, DXGI 1.2 is
        // required.
        // The easiest way to check is to query for a IDXGIDevice2.
        bool requireDXGI1_2 = false;
        HWND hwnd           = WindowFromDC(mDisplay->getNativeDisplayId());
        if (hwnd)
        {
            DWORD currentProcessId = GetCurrentProcessId();
            DWORD wndProcessId;
            GetWindowThreadProcessId(hwnd, &wndProcessId);
            requireDXGI1_2 = (currentProcessId != wndProcessId);
        }
        else
        {
            requireDXGI1_2 = true;
        }

        if (requireDXGI1_2)
        {
            IDXGIDevice2 *dxgiDevice2 = NULL;
            result = mDevice->QueryInterface(__uuidof(IDXGIDevice2), (void **)&dxgiDevice2);
            if (FAILED(result))
            {
                return egl::Error(
                    EGL_NOT_INITIALIZED, D3D11_INIT_INCOMPATIBLE_DXGI,
                    "DXGI 1.2 required to present to HWNDs owned by another process.");
            }
            SafeRelease(dxgiDevice2);
        }
    }
#endif
#endif

    {
        TRACE_EVENT0("gpu.angle", "Renderer11::initialize (ComQueries)");
        // Cast the DeviceContext to a DeviceContext1.
        // This could fail on Windows 7 without the Platform Update.
        // Don't error in this case- just don't use mDeviceContext1.
        mDeviceContext1 = d3d11::DynamicCastComObject<ID3D11DeviceContext1>(mDeviceContext);

        IDXGIDevice *dxgiDevice = NULL;
        result = mDevice->QueryInterface(__uuidof(IDXGIDevice), (void **)&dxgiDevice);

        if (FAILED(result))
        {
            return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_OTHER_ERROR,
                              "Could not query DXGI device.");
        }

        result = dxgiDevice->GetParent(__uuidof(IDXGIAdapter), (void **)&mDxgiAdapter);

        if (FAILED(result))
        {
            return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_OTHER_ERROR,
                              "Could not retrieve DXGI adapter");
        }

        SafeRelease(dxgiDevice);

        IDXGIAdapter2 *dxgiAdapter2 = d3d11::DynamicCastComObject<IDXGIAdapter2>(mDxgiAdapter);

        // On D3D_FEATURE_LEVEL_9_*, IDXGIAdapter::GetDesc returns "Software Adapter" for the
        // description string.
        // If DXGI1.2 is available then IDXGIAdapter2::GetDesc2 can be used to get the actual
        // hardware values.
        if (mRenderer11DeviceCaps.featureLevel <= D3D_FEATURE_LEVEL_9_3 && dxgiAdapter2 != NULL)
        {
            DXGI_ADAPTER_DESC2 adapterDesc2 = {};
            result                          = dxgiAdapter2->GetDesc2(&adapterDesc2);
            if (SUCCEEDED(result))
            {
                // Copy the contents of the DXGI_ADAPTER_DESC2 into mAdapterDescription (a
                // DXGI_ADAPTER_DESC).
                memcpy(mAdapterDescription.Description, adapterDesc2.Description,
                       sizeof(mAdapterDescription.Description));
                mAdapterDescription.VendorId              = adapterDesc2.VendorId;
                mAdapterDescription.DeviceId              = adapterDesc2.DeviceId;
                mAdapterDescription.SubSysId              = adapterDesc2.SubSysId;
                mAdapterDescription.Revision              = adapterDesc2.Revision;
                mAdapterDescription.DedicatedVideoMemory  = adapterDesc2.DedicatedVideoMemory;
                mAdapterDescription.DedicatedSystemMemory = adapterDesc2.DedicatedSystemMemory;
                mAdapterDescription.SharedSystemMemory    = adapterDesc2.SharedSystemMemory;
                mAdapterDescription.AdapterLuid           = adapterDesc2.AdapterLuid;
            }
        }
        else
        {
            result = mDxgiAdapter->GetDesc(&mAdapterDescription);
        }

        SafeRelease(dxgiAdapter2);

        if (FAILED(result))
        {
            return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_OTHER_ERROR,
                              "Could not read DXGI adaptor description.");
        }

        memset(mDescription, 0, sizeof(mDescription));
        wcstombs(mDescription, mAdapterDescription.Description, sizeof(mDescription) - 1);

        result = mDxgiAdapter->GetParent(__uuidof(IDXGIFactory), (void **)&mDxgiFactory);

        if (!mDxgiFactory || FAILED(result))
        {
            return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_OTHER_ERROR,
                              "Could not create DXGI factory.");
        }
    }

// Disable some spurious D3D11 debug warnings to prevent them from flooding the output log
#if defined(ANGLE_SUPPRESS_D3D11_HAZARD_WARNINGS) && defined(_DEBUG)
    {
        TRACE_EVENT0("gpu.angle", "Renderer11::initialize (HideWarnings)");
        ID3D11InfoQueue *infoQueue;
        result = mDevice->QueryInterface(__uuidof(ID3D11InfoQueue), (void **)&infoQueue);

        if (SUCCEEDED(result))
        {
            D3D11_MESSAGE_ID hideMessages[] = {
                D3D11_MESSAGE_ID_DEVICE_DRAW_RENDERTARGETVIEW_NOT_SET};

            D3D11_INFO_QUEUE_FILTER filter = {};
            filter.DenyList.NumIDs         = static_cast<unsigned int>(ArraySize(hideMessages));
            filter.DenyList.pIDList        = hideMessages;

            infoQueue->AddStorageFilterEntries(&filter);
            SafeRelease(infoQueue);
        }
    }
#endif

#if !defined(NDEBUG)
    mDebug = d3d11::DynamicCastComObject<ID3D11Debug>(mDevice);
#endif

    initializeDevice();

    return egl::Error(EGL_SUCCESS);
}

egl::Error Renderer11::initializeD3DDevice()
{
    HRESULT result = S_OK;

    if (!mCreatedWithDeviceEXT)
    {
#if !defined(ANGLE_ENABLE_WINDOWS_STORE)
        PFN_D3D11_CREATE_DEVICE D3D11CreateDevice = nullptr;
        {
            SCOPED_ANGLE_HISTOGRAM_TIMER("GPU.ANGLE.Renderer11InitializeDLLsMS");
            TRACE_EVENT0("gpu.angle", "Renderer11::initialize (Load DLLs)");
            mDxgiModule  = LoadLibrary(TEXT("dxgi.dll"));
            mD3d11Module = LoadLibrary(TEXT("d3d11.dll"));
            mDCompModule = LoadLibrary(TEXT("dcomp.dll"));

            if (mD3d11Module == nullptr || mDxgiModule == nullptr)
            {
                return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_MISSING_DEP,
                                  "Could not load D3D11 or DXGI library.");
            }

            // create the D3D11 device
            ASSERT(mDevice == nullptr);
            D3D11CreateDevice = reinterpret_cast<PFN_D3D11_CREATE_DEVICE>(
                GetProcAddress(mD3d11Module, "D3D11CreateDevice"));

            if (D3D11CreateDevice == nullptr)
            {
                return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_MISSING_DEP,
                                  "Could not retrieve D3D11CreateDevice address.");
            }
        }
#endif

#ifdef _DEBUG
        {
            TRACE_EVENT0("gpu.angle", "D3D11CreateDevice (Debug)");
            result = D3D11CreateDevice(nullptr, mRequestedDriverType, nullptr,
                                       D3D11_CREATE_DEVICE_DEBUG, mAvailableFeatureLevels.data(),
                                       static_cast<unsigned int>(mAvailableFeatureLevels.size()),
                                       D3D11_SDK_VERSION, &mDevice,
                                       &(mRenderer11DeviceCaps.featureLevel), &mDeviceContext);
        }

        if (!mDevice || FAILED(result))
        {
            ERR("Failed creating Debug D3D11 device - falling back to release runtime.\n");
        }

        if (!mDevice || FAILED(result))
#endif
        {
            SCOPED_ANGLE_HISTOGRAM_TIMER("GPU.ANGLE.D3D11CreateDeviceMS");
            TRACE_EVENT0("gpu.angle", "D3D11CreateDevice");

            result = D3D11CreateDevice(
                nullptr, mRequestedDriverType, nullptr, 0, mAvailableFeatureLevels.data(),
                static_cast<unsigned int>(mAvailableFeatureLevels.size()), D3D11_SDK_VERSION,
                &mDevice, &(mRenderer11DeviceCaps.featureLevel), &mDeviceContext);

            // Cleanup done by destructor
            if (!mDevice || FAILED(result))
            {
                ANGLE_HISTOGRAM_SPARSE_SLOWLY("GPU.ANGLE.D3D11CreateDeviceError",
                                              static_cast<int>(result));
                return egl::Error(EGL_NOT_INITIALIZED, D3D11_INIT_CREATEDEVICE_ERROR,
                                  "Could not create D3D11 device.");
            }
        }
    }
    else
    {
        // We should use the inputted D3D11 device instead
        void *device = nullptr;
        ANGLE_TRY(mEGLDevice->getDevice(&device));

        ID3D11Device *d3dDevice = reinterpret_cast<ID3D11Device *>(device);
        if (FAILED(d3dDevice->GetDeviceRemovedReason()))
        {
            return egl::Error(EGL_NOT_INITIALIZED, "Inputted D3D11 device has been lost.");
        }

        if (d3dDevice->GetFeatureLevel() < D3D_FEATURE_LEVEL_9_3)
        {
            return egl::Error(EGL_NOT_INITIALIZED,
                              "Inputted D3D11 device must be Feature Level 9_3 or greater.");
        }

        // The Renderer11 adds a ref to the inputted D3D11 device, like D3D11CreateDevice does.
        mDevice = d3dDevice;
        mDevice->AddRef();
        mDevice->GetImmediateContext(&mDeviceContext);
        mRenderer11DeviceCaps.featureLevel = mDevice->GetFeatureLevel();
    }

    d3d11::SetDebugName(mDeviceContext, "DeviceContext");

    return egl::Error(EGL_SUCCESS);
}

// do any one-time device initialization
// NOTE: this is also needed after a device lost/reset
// to reset the scene status and ensure the default states are reset.
void Renderer11::initializeDevice()
{
    SCOPED_ANGLE_HISTOGRAM_TIMER("GPU.ANGLE.Renderer11InitializeDeviceMS");
    TRACE_EVENT0("gpu.angle", "Renderer11::initializeDevice");

    populateRenderer11DeviceCaps();

    mStateCache.initialize(mDevice);
    mInputLayoutCache.initialize(mDevice, mDeviceContext);

    ASSERT(!mVertexDataManager && !mIndexDataManager);
    mVertexDataManager = new VertexDataManager(this);
    mIndexDataManager  = new IndexDataManager(this, getRendererClass());

    ASSERT(!mBlit);
    mBlit = new Blit11(this);

    ASSERT(!mClear);
    mClear = new Clear11(this);

    const auto &attributes = mDisplay->getAttributeMap();
    // If automatic trim is enabled, DXGIDevice3::Trim( ) is called for the application
    // automatically when an application is suspended by the OS. This feature is currently
    // only supported for Windows Store applications.
    EGLint enableAutoTrim = static_cast<EGLint>(
        attributes.get(EGL_PLATFORM_ANGLE_ENABLE_AUTOMATIC_TRIM_ANGLE, EGL_FALSE));

    if (enableAutoTrim == EGL_TRUE)
    {
        ASSERT(!mTrim);
        mTrim = new Trim11(this);
    }

    ASSERT(!mPixelTransfer);
    mPixelTransfer = new PixelTransfer11(this);

    const gl::Caps &rendererCaps = getNativeCaps();

    mStateManager.initialize(rendererCaps);

    mForceSetVertexSamplerStates.resize(rendererCaps.maxVertexTextureImageUnits);
    mCurVertexSamplerStates.resize(rendererCaps.maxVertexTextureImageUnits);
    mSamplerMetadataVS.initData(rendererCaps.maxVertexTextureImageUnits);

    mForceSetPixelSamplerStates.resize(rendererCaps.maxTextureImageUnits);
    mCurPixelSamplerStates.resize(rendererCaps.maxTextureImageUnits);
    mSamplerMetadataPS.initData(rendererCaps.maxTextureImageUnits);

    mStateManager.initialize(rendererCaps);

    markAllStateDirty();

    // Gather stats on DXGI and D3D feature level
    ANGLE_HISTOGRAM_BOOLEAN("GPU.ANGLE.SupportsDXGI1_2", mRenderer11DeviceCaps.supportsDXGI1_2);

    ANGLEFeatureLevel angleFeatureLevel = GetANGLEFeatureLevel(mRenderer11DeviceCaps.featureLevel);

    // We don't actually request a 11_1 device, because of complications with the platform
    // update. Instead we check if the mDeviceContext1 pointer cast succeeded.
    // Note: we should support D3D11_0 always, but we aren't guaranteed to be at FL11_0
    // because the app can specify a lower version (such as 9_3) on Display creation.
    if (mDeviceContext1 != nullptr)
    {
        angleFeatureLevel = ANGLE_FEATURE_LEVEL_11_1;
    }

    ANGLE_HISTOGRAM_ENUMERATION("GPU.ANGLE.D3D11FeatureLevel", angleFeatureLevel,
                                NUM_ANGLE_FEATURE_LEVELS);
}

void Renderer11::populateRenderer11DeviceCaps()
{
    HRESULT hr = S_OK;

    LARGE_INTEGER version;
    hr = mDxgiAdapter->CheckInterfaceSupport(__uuidof(IDXGIDevice), &version);
    if (FAILED(hr))
    {
        mRenderer11DeviceCaps.driverVersion.reset();
        ERR("Error querying driver version from DXGI Adapter.");
    }
    else
    {
        mRenderer11DeviceCaps.driverVersion = version;
    }

    if (mDeviceContext1)
    {
        D3D11_FEATURE_DATA_D3D11_OPTIONS d3d11Options;
        HRESULT result = mDevice->CheckFeatureSupport(D3D11_FEATURE_D3D11_OPTIONS, &d3d11Options,
                                                      sizeof(D3D11_FEATURE_DATA_D3D11_OPTIONS));
        if (SUCCEEDED(result))
        {
            mRenderer11DeviceCaps.supportsClearView = (d3d11Options.ClearView != FALSE);
            mRenderer11DeviceCaps.supportsConstantBufferOffsets =
                (d3d11Options.ConstantBufferOffsetting != FALSE);
        }
    }

    if (getWorkarounds().disableB5G6R5Support)
    {
        mRenderer11DeviceCaps.B5G6R5support = 0;
    }
    else
    {
        hr = mDevice->CheckFormatSupport(DXGI_FORMAT_B5G6R5_UNORM,
                                         &(mRenderer11DeviceCaps.B5G6R5support));
        if (FAILED(hr))
        {
            mRenderer11DeviceCaps.B5G6R5support = 0;
        }
    }

    hr = mDevice->CheckFormatSupport(DXGI_FORMAT_B4G4R4A4_UNORM,
                                     &(mRenderer11DeviceCaps.B4G4R4A4support));
    if (FAILED(hr))
    {
        mRenderer11DeviceCaps.B4G4R4A4support = 0;
    }

    hr = mDevice->CheckFormatSupport(DXGI_FORMAT_B5G5R5A1_UNORM,
                                     &(mRenderer11DeviceCaps.B5G5R5A1support));
    if (FAILED(hr))
    {
        mRenderer11DeviceCaps.B5G5R5A1support = 0;
    }

    IDXGIAdapter2 *dxgiAdapter2 = d3d11::DynamicCastComObject<IDXGIAdapter2>(mDxgiAdapter);
    mRenderer11DeviceCaps.supportsDXGI1_2 = (dxgiAdapter2 != nullptr);
    SafeRelease(dxgiAdapter2);
}

egl::ConfigSet Renderer11::generateConfigs()
{
    std::vector<GLenum> colorBufferFormats;

    // 32-bit supported formats
    colorBufferFormats.push_back(GL_BGRA8_EXT);
    colorBufferFormats.push_back(GL_RGBA8_OES);

    // 24-bit supported formats
    colorBufferFormats.push_back(GL_RGB8_OES);

    if (!mPresentPathFastEnabled)
    {
        // 16-bit supported formats
        // These aren't valid D3D11 swapchain formats, so don't expose them as configs
        // if present path fast is active
        colorBufferFormats.push_back(GL_RGBA4);
        colorBufferFormats.push_back(GL_RGB5_A1);
        colorBufferFormats.push_back(GL_RGB565);
    }

    static const GLenum depthStencilBufferFormats[] = {
        GL_NONE, GL_DEPTH24_STENCIL8_OES, GL_DEPTH_COMPONENT16,
    };

    const gl::Caps &rendererCaps                  = getNativeCaps();
    const gl::TextureCapsMap &rendererTextureCaps = getNativeTextureCaps();

    const EGLint optimalSurfaceOrientation =
        mPresentPathFastEnabled ? 0 : EGL_SURFACE_ORIENTATION_INVERT_Y_ANGLE;

    egl::ConfigSet configs;
    for (GLenum colorBufferInternalFormat : colorBufferFormats)
    {
        const gl::TextureCaps &colorBufferFormatCaps =
            rendererTextureCaps.get(colorBufferInternalFormat);
        if (!colorBufferFormatCaps.renderable)
        {
            continue;
        }

        for (GLenum depthStencilBufferInternalFormat : depthStencilBufferFormats)
        {
            const gl::TextureCaps &depthStencilBufferFormatCaps =
                rendererTextureCaps.get(depthStencilBufferInternalFormat);
            if (!depthStencilBufferFormatCaps.renderable &&
                depthStencilBufferInternalFormat != GL_NONE)
            {
                continue;
            }

            const gl::InternalFormat &colorBufferFormatInfo =
                gl::GetInternalFormatInfo(colorBufferInternalFormat);
            const gl::InternalFormat &depthStencilBufferFormatInfo =
                gl::GetInternalFormatInfo(depthStencilBufferInternalFormat);
            const gl::Version &maxVersion = getMaxSupportedESVersion();

            egl::Config config;
            config.renderTargetFormat = colorBufferInternalFormat;
            config.depthStencilFormat = depthStencilBufferInternalFormat;
            config.bufferSize         = colorBufferFormatInfo.pixelBytes * 8;
            config.redSize            = colorBufferFormatInfo.redBits;
            config.greenSize          = colorBufferFormatInfo.greenBits;
            config.blueSize           = colorBufferFormatInfo.blueBits;
            config.luminanceSize      = colorBufferFormatInfo.luminanceBits;
            config.alphaSize          = colorBufferFormatInfo.alphaBits;
            config.alphaMaskSize      = 0;
            config.bindToTextureRGB   = (colorBufferFormatInfo.format == GL_RGB);
            config.bindToTextureRGBA  = (colorBufferFormatInfo.format == GL_RGBA ||
                                        colorBufferFormatInfo.format == GL_BGRA_EXT);
            config.colorBufferType = EGL_RGB_BUFFER;
            config.configCaveat    = EGL_NONE;
            config.configID        = static_cast<EGLint>(configs.size() + 1);

            // PresentPathFast may not be conformant
            config.conformant = 0;
            if (!mPresentPathFastEnabled)
            {
                // Can only support a conformant ES2 with feature level greater than 10.0.
                if (mRenderer11DeviceCaps.featureLevel >= D3D_FEATURE_LEVEL_10_0)
                {
                    config.conformant |= EGL_OPENGL_ES2_BIT;
                }

                // We can only support conformant ES3 on FL 10.1+
                if (maxVersion.major >= 3)
                {
                    config.conformant |= EGL_OPENGL_ES3_BIT_KHR;
                }
            }

            config.depthSize         = depthStencilBufferFormatInfo.depthBits;
            config.level             = 0;
            config.matchNativePixmap = EGL_NONE;
            config.maxPBufferWidth   = rendererCaps.max2DTextureSize;
            config.maxPBufferHeight  = rendererCaps.max2DTextureSize;
            config.maxPBufferPixels = rendererCaps.max2DTextureSize * rendererCaps.max2DTextureSize;
            config.maxSwapInterval  = 4;
            config.minSwapInterval  = 0;
            config.nativeRenderable = EGL_FALSE;
            config.nativeVisualID   = 0;
            config.nativeVisualType = EGL_NONE;

            // Can't support ES3 at all without feature level 10.1
            config.renderableType = EGL_OPENGL_ES2_BIT;
            if (maxVersion.major >= 3)
            {
                config.renderableType |= EGL_OPENGL_ES3_BIT_KHR;
            }

            config.sampleBuffers = 0;  // FIXME: enumerate multi-sampling
            config.samples       = 0;
            config.stencilSize   = depthStencilBufferFormatInfo.stencilBits;
            config.surfaceType = EGL_PBUFFER_BIT | EGL_WINDOW_BIT | EGL_SWAP_BEHAVIOR_PRESERVED_BIT;
            config.transparentType       = EGL_NONE;
            config.transparentRedValue   = 0;
            config.transparentGreenValue = 0;
            config.transparentBlueValue  = 0;
            config.optimalOrientation    = optimalSurfaceOrientation;

            configs.add(config);
        }
    }

    ASSERT(configs.size() > 0);
    return configs;
}

void Renderer11::generateDisplayExtensions(egl::DisplayExtensions *outExtensions) const
{
    outExtensions->createContextRobustness = true;

    if (getShareHandleSupport())
    {
        outExtensions->d3dShareHandleClientBuffer     = true;
        outExtensions->surfaceD3DTexture2DShareHandle = true;
    }
    outExtensions->d3dTextureClientBuffer = true;

    outExtensions->keyedMutex          = true;
    outExtensions->querySurfacePointer = true;
    outExtensions->windowFixedSize     = true;

    // If present path fast is active then the surface orientation extension isn't supported
    outExtensions->surfaceOrientation = !mPresentPathFastEnabled;

    // D3D11 does not support present with dirty rectangles until DXGI 1.2.
    outExtensions->postSubBuffer = mRenderer11DeviceCaps.supportsDXGI1_2;

    outExtensions->deviceQuery = true;

    outExtensions->image                 = true;
    outExtensions->imageBase             = true;
    outExtensions->glTexture2DImage      = true;
    outExtensions->glTextureCubemapImage = true;
    outExtensions->glRenderbufferImage   = true;

    outExtensions->stream                     = true;
    outExtensions->streamConsumerGLTexture    = true;
    outExtensions->streamConsumerGLTextureYUV = true;
    // Not all D3D11 devices support NV12 textures
    if (getNV12TextureSupport())
    {
        outExtensions->streamProducerD3DTextureNV12 = true;
    }

    outExtensions->flexibleSurfaceCompatibility = true;
    outExtensions->directComposition            = !!mDCompModule;
}

gl::Error Renderer11::flush()
{
    mDeviceContext->Flush();
    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::finish()
{
    HRESULT result;

    if (!mSyncQuery)
    {
        D3D11_QUERY_DESC queryDesc;
        queryDesc.Query     = D3D11_QUERY_EVENT;
        queryDesc.MiscFlags = 0;

        result = mDevice->CreateQuery(&queryDesc, &mSyncQuery);
        ASSERT(SUCCEEDED(result));
        if (FAILED(result))
        {
            return gl::Error(GL_OUT_OF_MEMORY, "Failed to create event query, result: 0x%X.",
                             result);
        }
    }

    mDeviceContext->End(mSyncQuery);

    unsigned int attempt = 0;
    do
    {
        unsigned int flushFrequency = 100;
        UINT flags = (attempt % flushFrequency == 0) ? 0 : D3D11_ASYNC_GETDATA_DONOTFLUSH;
        attempt++;

        result = mDeviceContext->GetData(mSyncQuery, NULL, 0, flags);
        if (FAILED(result))
        {
            return gl::Error(GL_OUT_OF_MEMORY, "Failed to get event query data, result: 0x%X.",
                             result);
        }

        // Keep polling, but allow other threads to do something useful first
        ScheduleYield();

        if (testDeviceLost())
        {
            mDisplay->notifyDeviceLost();
            return gl::Error(GL_OUT_OF_MEMORY, "Device was lost while waiting for sync.");
        }
    } while (result == S_FALSE);

    return gl::Error(GL_NO_ERROR);
}

bool Renderer11::isValidNativeWindow(EGLNativeWindowType window) const
{
#ifdef ANGLE_ENABLE_WINDOWS_STORE
    return NativeWindow11WinRT::IsValidNativeWindow(window);
#else
    return NativeWindow11Win32::IsValidNativeWindow(window);
#endif
}

NativeWindowD3D *Renderer11::createNativeWindow(EGLNativeWindowType window,
                                                const egl::Config *config,
                                                const egl::AttributeMap &attribs) const
{
#ifdef ANGLE_ENABLE_WINDOWS_STORE
    UNUSED_VARIABLE(attribs);
    return new NativeWindow11WinRT(window, config->alphaSize > 0);
#else
    return new NativeWindow11Win32(
        window, config->alphaSize > 0,
        attribs.get(EGL_DIRECT_COMPOSITION_ANGLE, EGL_FALSE) == EGL_TRUE);
#endif
}

egl::Error Renderer11::getD3DTextureInfo(IUnknown *d3dTexture,
                                         EGLint *width,
                                         EGLint *height,
                                         GLenum *fboFormat) const
{
    ID3D11Texture2D *texture = d3d11::DynamicCastComObject<ID3D11Texture2D>(d3dTexture);
    if (texture == nullptr)
    {
        return egl::Error(EGL_BAD_PARAMETER, "client buffer is not a ID3D11Texture2D");
    }

    ID3D11Device *textureDevice = nullptr;
    texture->GetDevice(&textureDevice);
    if (textureDevice != mDevice)
    {
        SafeRelease(texture);
        return egl::Error(EGL_BAD_PARAMETER, "Texture's device does not match.");
    }
    SafeRelease(textureDevice);

    D3D11_TEXTURE2D_DESC desc = {0};
    texture->GetDesc(&desc);
    SafeRelease(texture);

    if (width)
    {
        *width = static_cast<EGLint>(desc.Width);
    }
    if (height)
    {
        *height = static_cast<EGLint>(desc.Height);
    }

    // From table egl.restrictions in EGL_ANGLE_d3d_texture_client_buffer.
    switch (desc.Format)
    {
        case DXGI_FORMAT_R8G8B8A8_UNORM:
        case DXGI_FORMAT_R8G8B8A8_UNORM_SRGB:
        case DXGI_FORMAT_B8G8R8A8_UNORM:
        case DXGI_FORMAT_B8G8R8A8_UNORM_SRGB:
        case DXGI_FORMAT_R16G16B16A16_FLOAT:
        case DXGI_FORMAT_R32G32B32A32_FLOAT:
            break;

        default:
            return egl::Error(EGL_BAD_PARAMETER, "Unknown client buffer texture format: %u.",
                              desc.Format);
    }

    if (fboFormat)
    {
        const angle::Format &angleFormat = d3d11_angle::GetFormat(desc.Format);
        *fboFormat                       = angleFormat.fboImplementationInternalFormat;
    }

    return egl::Error(EGL_SUCCESS);
}

egl::Error Renderer11::validateShareHandle(const egl::Config *config,
                                           HANDLE shareHandle,
                                           const egl::AttributeMap &attribs) const
{
    if (shareHandle == nullptr)
    {
        return egl::Error(EGL_BAD_PARAMETER, "NULL share handle.");
    }

    ID3D11Resource *tempResource11 = nullptr;
    HRESULT result = mDevice->OpenSharedResource(shareHandle, __uuidof(ID3D11Resource),
                                                 (void **)&tempResource11);
    if (FAILED(result))
    {
        return egl::Error(EGL_BAD_PARAMETER, "Failed to open share handle, result: 0x%X.", result);
    }

    ID3D11Texture2D *texture2D = d3d11::DynamicCastComObject<ID3D11Texture2D>(tempResource11);
    SafeRelease(tempResource11);

    if (texture2D == nullptr)
    {
        return egl::Error(EGL_BAD_PARAMETER,
                          "Failed to query ID3D11Texture2D object from share handle.");
    }

    D3D11_TEXTURE2D_DESC desc = {0};
    texture2D->GetDesc(&desc);
    SafeRelease(texture2D);

    EGLint width  = attribs.getAsInt(EGL_WIDTH, 0);
    EGLint height = attribs.getAsInt(EGL_HEIGHT, 0);
    ASSERT(width != 0 && height != 0);

    const d3d11::Format &backbufferFormatInfo =
        d3d11::Format::Get(config->renderTargetFormat, getRenderer11DeviceCaps());

    if (desc.Width != static_cast<UINT>(width) || desc.Height != static_cast<UINT>(height) ||
        desc.Format != backbufferFormatInfo.texFormat || desc.MipLevels != 1 || desc.ArraySize != 1)
    {
        return egl::Error(EGL_BAD_PARAMETER, "Invalid texture parameters in share handle texture.");
    }

    return egl::Error(EGL_SUCCESS);
}

SwapChainD3D *Renderer11::createSwapChain(NativeWindowD3D *nativeWindow,
                                          HANDLE shareHandle,
                                          IUnknown *d3dTexture,
                                          GLenum backBufferFormat,
                                          GLenum depthBufferFormat,
                                          EGLint orientation)
{
    return new SwapChain11(this, GetAs<NativeWindow11>(nativeWindow), shareHandle, d3dTexture,
                           backBufferFormat, depthBufferFormat, orientation);
}

void *Renderer11::getD3DDevice()
{
    return reinterpret_cast<void *>(mDevice);
}

gl::Error Renderer11::generateSwizzle(gl::Texture *texture)
{
    if (texture)
    {
        TextureD3D *textureD3D = GetImplAs<TextureD3D>(texture);
        ASSERT(textureD3D);

        TextureStorage *texStorage = nullptr;
        ANGLE_TRY(textureD3D->getNativeTexture(&texStorage));

        if (texStorage)
        {
            TextureStorage11 *storage11          = GetAs<TextureStorage11>(texStorage);
            const gl::TextureState &textureState = texture->getTextureState();
            ANGLE_TRY(storage11->generateSwizzles(textureState.getSwizzleState()));
        }
    }

    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::generateSwizzles(const gl::ContextState &data, gl::SamplerType type)
{
    ProgramD3D *programD3D = GetImplAs<ProgramD3D>(data.getState().getProgram());

    unsigned int samplerRange = programD3D->getUsedSamplerRange(type);

    for (unsigned int i = 0; i < samplerRange; i++)
    {
        GLenum textureType = programD3D->getSamplerTextureType(type, i);
        GLint textureUnit  = programD3D->getSamplerMapping(type, i, data.getCaps());
        if (textureUnit != -1)
        {
            gl::Texture *texture = data.getState().getSamplerTexture(textureUnit, textureType);
            ASSERT(texture);
            if (texture->getTextureState().swizzleRequired())
            {
                ANGLE_TRY(generateSwizzle(texture));
            }
        }
    }

    return gl::NoError();
}

gl::Error Renderer11::generateSwizzles(const gl::ContextState &data)
{
    ANGLE_TRY(generateSwizzles(data, gl::SAMPLER_VERTEX));
    ANGLE_TRY(generateSwizzles(data, gl::SAMPLER_PIXEL));
    return gl::NoError();
}
gl::Error Renderer11::setSamplerState(gl::SamplerType type,
                                      int index,
                                      gl::Texture *texture,
                                      const gl::SamplerState &samplerState)
{
    // Make sure to add the level offset for our tiny compressed texture workaround
    TextureD3D *textureD3D = GetImplAs<TextureD3D>(texture);

    TextureStorage *storage = nullptr;
    ANGLE_TRY(textureD3D->getNativeTexture(&storage));

    // Storage should exist, texture should be complete
    ASSERT(storage);

    // Sampler metadata that's passed to shaders in uniforms is stored separately from rest of the
    // sampler state since having it in contiguous memory makes it possible to memcpy to a constant
    // buffer, and it doesn't affect the state set by PSSetSamplers/VSSetSamplers.
    SamplerMetadataD3D11 *metadata = nullptr;

    if (type == gl::SAMPLER_PIXEL)
    {
        ASSERT(static_cast<unsigned int>(index) < getNativeCaps().maxTextureImageUnits);

        if (mForceSetPixelSamplerStates[index] ||
            memcmp(&samplerState, &mCurPixelSamplerStates[index], sizeof(gl::SamplerState)) != 0)
        {
            ID3D11SamplerState *dxSamplerState = NULL;
            ANGLE_TRY(mStateCache.getSamplerState(samplerState, &dxSamplerState));

            ASSERT(dxSamplerState != NULL);
            mDeviceContext->PSSetSamplers(index, 1, &dxSamplerState);

            mCurPixelSamplerStates[index] = samplerState;
        }

        mForceSetPixelSamplerStates[index] = false;

        metadata = &mSamplerMetadataPS;
    }
    else if (type == gl::SAMPLER_VERTEX)
    {
        ASSERT(static_cast<unsigned int>(index) < getNativeCaps().maxVertexTextureImageUnits);

        if (mForceSetVertexSamplerStates[index] ||
            memcmp(&samplerState, &mCurVertexSamplerStates[index], sizeof(gl::SamplerState)) != 0)
        {
            ID3D11SamplerState *dxSamplerState = NULL;
            ANGLE_TRY(mStateCache.getSamplerState(samplerState, &dxSamplerState));

            ASSERT(dxSamplerState != NULL);
            mDeviceContext->VSSetSamplers(index, 1, &dxSamplerState);

            mCurVertexSamplerStates[index] = samplerState;
        }

        mForceSetVertexSamplerStates[index] = false;

        metadata = &mSamplerMetadataVS;
    }
    else
        UNREACHABLE();

    ASSERT(metadata != nullptr);
    metadata->update(index, *texture);

    return gl::NoError();
}

gl::Error Renderer11::setTexture(gl::SamplerType type, int index, gl::Texture *texture)
{
    ID3D11ShaderResourceView *textureSRV = NULL;

    if (texture)
    {
        TextureD3D *textureImpl = GetImplAs<TextureD3D>(texture);

        TextureStorage *texStorage = nullptr;
        ANGLE_TRY(textureImpl->getNativeTexture(&texStorage));

        // Texture should be complete and have a storage
        ASSERT(texStorage);

        TextureStorage11 *storage11 = GetAs<TextureStorage11>(texStorage);

        ANGLE_TRY(storage11->getSRV(texture->getTextureState(), &textureSRV));

        // If we get NULL back from getSRV here, something went wrong in the texture class and we're
        // unexpectedly missing the shader resource view
        ASSERT(textureSRV != NULL);

        textureImpl->resetDirty();
    }

    ASSERT((type == gl::SAMPLER_PIXEL &&
            static_cast<unsigned int>(index) < getNativeCaps().maxTextureImageUnits) ||
           (type == gl::SAMPLER_VERTEX &&
            static_cast<unsigned int>(index) < getNativeCaps().maxVertexTextureImageUnits));

    mStateManager.setShaderResource(type, index, textureSRV);

    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::setUniformBuffers(const gl::ContextState &data,
                                        const std::vector<GLint> &vertexUniformBuffers,
                                        const std::vector<GLint> &fragmentUniformBuffers)
{
    for (size_t uniformBufferIndex = 0; uniformBufferIndex < vertexUniformBuffers.size();
         uniformBufferIndex++)
    {
        GLint binding = vertexUniformBuffers[uniformBufferIndex];

        if (binding == -1)
        {
            continue;
        }

        const OffsetBindingPointer<gl::Buffer> &uniformBuffer =
            data.getState().getIndexedUniformBuffer(binding);
        GLintptr uniformBufferOffset = uniformBuffer.getOffset();
        GLsizeiptr uniformBufferSize = uniformBuffer.getSize();

        if (uniformBuffer.get() == nullptr)
        {
            continue;
        }

        Buffer11 *bufferStorage      = GetImplAs<Buffer11>(uniformBuffer.get());
        ID3D11Buffer *constantBuffer = nullptr;
        UINT firstConstant           = 0;
        UINT numConstants            = 0;

        ANGLE_TRY(bufferStorage->getConstantBufferRange(uniformBufferOffset, uniformBufferSize,
                                                        &constantBuffer, &firstConstant,
                                                        &numConstants));

        if (!constantBuffer)
        {
            return gl::Error(GL_OUT_OF_MEMORY, "Error retrieving constant buffer");
        }

        if (mCurrentConstantBufferVS[uniformBufferIndex] != bufferStorage->getSerial() ||
            mCurrentConstantBufferVSOffset[uniformBufferIndex] != uniformBufferOffset ||
            mCurrentConstantBufferVSSize[uniformBufferIndex] != uniformBufferSize)
        {
            if (firstConstant != 0 && uniformBufferSize != 0)
            {
                ASSERT(numConstants != 0);
                mDeviceContext1->VSSetConstantBuffers1(
                    getReservedVertexUniformBuffers() +
                        static_cast<unsigned int>(uniformBufferIndex),
                    1, &constantBuffer, &firstConstant, &numConstants);
            }
            else
            {
                mDeviceContext->VSSetConstantBuffers(
                    getReservedVertexUniformBuffers() +
                        static_cast<unsigned int>(uniformBufferIndex),
                    1, &constantBuffer);
            }

            mCurrentConstantBufferVS[uniformBufferIndex]       = bufferStorage->getSerial();
            mCurrentConstantBufferVSOffset[uniformBufferIndex] = uniformBufferOffset;
            mCurrentConstantBufferVSSize[uniformBufferIndex]   = uniformBufferSize;
        }
    }

    for (size_t uniformBufferIndex = 0; uniformBufferIndex < fragmentUniformBuffers.size();
         uniformBufferIndex++)
    {
        GLint binding = fragmentUniformBuffers[uniformBufferIndex];

        if (binding == -1)
        {
            continue;
        }

        const OffsetBindingPointer<gl::Buffer> &uniformBuffer =
            data.getState().getIndexedUniformBuffer(binding);
        GLintptr uniformBufferOffset = uniformBuffer.getOffset();
        GLsizeiptr uniformBufferSize = uniformBuffer.getSize();

        if (uniformBuffer.get() == nullptr)
        {
            continue;
        }

        Buffer11 *bufferStorage      = GetImplAs<Buffer11>(uniformBuffer.get());
        ID3D11Buffer *constantBuffer = nullptr;
        UINT firstConstant           = 0;
        UINT numConstants            = 0;

        ANGLE_TRY(bufferStorage->getConstantBufferRange(uniformBufferOffset, uniformBufferSize,
                                                        &constantBuffer, &firstConstant,
                                                        &numConstants));

        if (!constantBuffer)
        {
            return gl::Error(GL_OUT_OF_MEMORY, "Error retrieving constant buffer");
        }

        if (mCurrentConstantBufferPS[uniformBufferIndex] != bufferStorage->getSerial() ||
            mCurrentConstantBufferPSOffset[uniformBufferIndex] != uniformBufferOffset ||
            mCurrentConstantBufferPSSize[uniformBufferIndex] != uniformBufferSize)
        {
            if (firstConstant != 0 && uniformBufferSize != 0)
            {
                mDeviceContext1->PSSetConstantBuffers1(
                    getReservedFragmentUniformBuffers() +
                        static_cast<unsigned int>(uniformBufferIndex),
                    1, &constantBuffer, &firstConstant, &numConstants);
            }
            else
            {
                mDeviceContext->PSSetConstantBuffers(
                    getReservedFragmentUniformBuffers() +
                        static_cast<unsigned int>(uniformBufferIndex),
                    1, &constantBuffer);
            }

            mCurrentConstantBufferPS[uniformBufferIndex]       = bufferStorage->getSerial();
            mCurrentConstantBufferPSOffset[uniformBufferIndex] = uniformBufferOffset;
            mCurrentConstantBufferPSSize[uniformBufferIndex]   = uniformBufferSize;
        }
    }

    return gl::NoError();
}

gl::Error Renderer11::updateState(const gl::ContextState &data, GLenum drawMode)
{
    const auto &glState = data.getState();

    // Applies the render target surface, depth stencil surface, viewport rectangle and
    // scissor rectangle to the renderer
    gl::Framebuffer *framebuffer = glState.getDrawFramebuffer();
    ASSERT(framebuffer && !framebuffer->hasAnyDirtyBit() && framebuffer->complete(data));
    ANGLE_TRY(applyRenderTarget(framebuffer));

    // Set the present path state
    auto firstColorAttachment        = framebuffer->getFirstColorbuffer();
    const bool presentPathFastActive = UsePresentPathFast(this, firstColorAttachment);
    mStateManager.updatePresentPath(presentPathFastActive, firstColorAttachment);

    // Setting viewport state
    mStateManager.setViewport(&data.getCaps(), glState.getViewport(), glState.getNearPlane(),
                              glState.getFarPlane());

    // Setting scissor state
    mStateManager.setScissorRectangle(glState.getScissor(), glState.isScissorTestEnabled());

    // Applying rasterizer state to D3D11 device
    // Since framebuffer->getSamples will return the original samples which may be different with
    // the sample counts that we set in render target view, here we use renderTarget->getSamples to
    // get the actual samples.
    GLsizei samples = 0;
    if (firstColorAttachment)
    {
        ASSERT(firstColorAttachment->isAttached());
        RenderTarget11 *renderTarget = nullptr;
        ANGLE_TRY(firstColorAttachment->getRenderTarget(&renderTarget));
        samples = renderTarget->getSamples();
    }
    gl::RasterizerState rasterizer = glState.getRasterizerState();
    rasterizer.pointDrawMode       = (drawMode == GL_POINTS);
    rasterizer.multiSample         = (samples != 0);

    ANGLE_TRY(mStateManager.setRasterizerState(rasterizer));

    // Setting blend state
    unsigned int mask = GetBlendSampleMask(data, samples);
    ANGLE_TRY(mStateManager.setBlendState(framebuffer, glState.getBlendState(),
                                          glState.getBlendColor(), mask));

    // Setting depth stencil state
    ANGLE_TRY(mStateManager.setDepthStencilState(glState));

    return gl::NoError();
}

bool Renderer11::applyPrimitiveType(GLenum mode, GLsizei count, bool usesPointSize)
{
    D3D11_PRIMITIVE_TOPOLOGY primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_UNDEFINED;

    GLsizei minCount = 0;

    switch (mode)
    {
        case GL_POINTS:
            primitiveTopology = D3D11_PRIMITIVE_TOPOLOGY_POINTLIST;
            minCount          = 1;
            break;
        case GL_LINES:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_LINELIST;
            minCount          = 2;
            break;
        case GL_LINE_LOOP:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_LINESTRIP;
            minCount          = 2;
            break;
        case GL_LINE_STRIP:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_LINESTRIP;
            minCount          = 2;
            break;
        case GL_TRIANGLES:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
            minCount          = 3;
            break;
        case GL_TRIANGLE_STRIP:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP;
            minCount          = 3;
            break;
        // emulate fans via rewriting index buffer
        case GL_TRIANGLE_FAN:
            primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
            minCount          = 3;
            break;
        default:
            UNREACHABLE();
            return false;
    }

    // If instanced pointsprite emulation is being used and  If gl_PointSize is used in the shader,
    // GL_POINTS mode is expected to render pointsprites.
    // Instanced PointSprite emulation requires that the topology to be
    // D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST.
    if (mode == GL_POINTS && usesPointSize && getWorkarounds().useInstancedPointSpriteEmulation)
    {
        primitiveTopology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
    }

    if (primitiveTopology != mCurrentPrimitiveTopology)
    {
        mDeviceContext->IASetPrimitiveTopology(primitiveTopology);
        mCurrentPrimitiveTopology = primitiveTopology;
    }

    return count >= minCount;
}

gl::Error Renderer11::applyRenderTarget(gl::Framebuffer *framebuffer)
{
    return mStateManager.syncFramebuffer(framebuffer);
}

gl::Error Renderer11::applyVertexBuffer(const gl::State &state,
                                        GLenum mode,
                                        GLint first,
                                        GLsizei count,
                                        GLsizei instances,
                                        TranslatedIndexData *indexInfo)
{
    const auto &vertexArray = state.getVertexArray();
    auto *vertexArray11     = GetImplAs<VertexArray11>(vertexArray);

    ANGLE_TRY(vertexArray11->updateDirtyAndDynamicAttribs(mVertexDataManager, state, first, count,
                                                          instances));

    ANGLE_TRY(mStateManager.updateCurrentValueAttribs(state, mVertexDataManager));

    // If index information is passed, mark it with the current changed status.
    if (indexInfo)
    {
        indexInfo->srcIndexData.srcIndicesChanged = mAppliedIBChanged;
    }

    GLsizei numIndicesPerInstance = 0;
    if (instances > 0)
    {
        numIndicesPerInstance = count;
    }
    const auto &vertexArrayAttribs  = vertexArray11->getTranslatedAttribs();
    const auto &currentValueAttribs = mStateManager.getCurrentValueAttribs();
    ANGLE_TRY(mInputLayoutCache.applyVertexBuffers(state, vertexArrayAttribs, currentValueAttribs,
                                                   mode, first, indexInfo, numIndicesPerInstance));

    // InputLayoutCache::applyVertexBuffers calls through to the Bufer11 to get the native vertex
    // buffer (ID3D11Buffer *). Because we allocate these buffers lazily, this will trigger
    // allocation. This in turn will signal that the buffer is dirty. Since we just resolved the
    // dirty-ness in VertexArray11::updateDirtyAndDynamicAttribs, this can make us do a needless
    // update on the second draw call.
    // Hence we clear the flags here, after we've applied vertex data, since we know everything
    // is clean. This is a bit of a hack.
    vertexArray11->clearDirtyAndPromoteDynamicAttribs(state, count);

    return gl::NoError();
}

gl::Error Renderer11::applyIndexBuffer(const gl::ContextState &data,
                                       const GLvoid *indices,
                                       GLsizei count,
                                       GLenum mode,
                                       GLenum type,
                                       TranslatedIndexData *indexInfo)
{
    const auto &glState            = data.getState();
    gl::VertexArray *vao           = glState.getVertexArray();
    gl::Buffer *elementArrayBuffer = vao->getElementArrayBuffer().get();
    ANGLE_TRY(mIndexDataManager->prepareIndexData(type, count, elementArrayBuffer, indices,
                                                  indexInfo, glState.isPrimitiveRestartEnabled()));

    ID3D11Buffer *buffer = nullptr;
    DXGI_FORMAT bufferFormat =
        (indexInfo->indexType == GL_UNSIGNED_INT) ? DXGI_FORMAT_R32_UINT : DXGI_FORMAT_R16_UINT;

    if (indexInfo->storage)
    {
        Buffer11 *storage = GetAs<Buffer11>(indexInfo->storage);
        ANGLE_TRY_RESULT(storage->getBuffer(BUFFER_USAGE_INDEX), buffer);
    }
    else
    {
        IndexBuffer11 *indexBuffer = GetAs<IndexBuffer11>(indexInfo->indexBuffer);
        buffer                     = indexBuffer->getBuffer();
    }

    mAppliedIBChanged = false;
    if (buffer != mAppliedIB || bufferFormat != mAppliedIBFormat ||
        indexInfo->startOffset != mAppliedIBOffset)
    {
        mDeviceContext->IASetIndexBuffer(buffer, bufferFormat, indexInfo->startOffset);

        mAppliedIB        = buffer;
        mAppliedIBFormat  = bufferFormat;
        mAppliedIBOffset  = indexInfo->startOffset;
        mAppliedIBChanged = true;
    }

    return gl::NoError();
}

gl::Error Renderer11::applyTransformFeedbackBuffers(const gl::ContextState &data)
{
    const auto &state = data.getState();

    // If transform feedback is not active, unbind all buffers
    if (!state.isTransformFeedbackActiveUnpaused())
    {
        if (mAppliedTFObject != 0)
        {
            mDeviceContext->SOSetTargets(0, nullptr, nullptr);
            mAppliedTFObject = 0;
        }
        return gl::NoError();
    }

    gl::TransformFeedback *transformFeedback = state.getCurrentTransformFeedback();
    TransformFeedback11 *transformFeedback11 = GetImplAs<TransformFeedback11>(transformFeedback);
    uintptr_t transformFeedbackId            = reinterpret_cast<uintptr_t>(transformFeedback11);
    if (mAppliedTFObject == transformFeedbackId && !transformFeedback11->isDirty())
    {
        return gl::NoError();
    }

    const std::vector<ID3D11Buffer *> *soBuffers = nullptr;
    ANGLE_TRY_RESULT(transformFeedback11->getSOBuffers(), soBuffers);
    const std::vector<UINT> &soOffsets = transformFeedback11->getSOBufferOffsets();

    mDeviceContext->SOSetTargets(transformFeedback11->getNumSOBuffers(), soBuffers->data(),
                                 soOffsets.data());

    mAppliedTFObject = transformFeedbackId;
    transformFeedback11->onApply();

    return gl::NoError();
}

gl::Error Renderer11::drawArraysImpl(const gl::ContextState &data,
                                     GLenum mode,
                                     GLint startVertex,
                                     GLsizei count,
                                     GLsizei instances)
{
    const auto &glState    = data.getState();
    ProgramD3D *programD3D = GetImplAs<ProgramD3D>(glState.getProgram());

    if (programD3D->usesGeometryShader(mode) && glState.isTransformFeedbackActiveUnpaused())
    {
        // Since we use a geometry if-and-only-if we rewrite vertex streams, transform feedback
        // won't get the correct output. To work around this, draw with *only* the stream out
        // first (no pixel shader) to feed the stream out buffers and then draw again with the
        // geometry shader + pixel shader to rasterize the primitives.
        mDeviceContext->PSSetShader(nullptr, nullptr, 0);

        if (instances > 0)
        {
            mDeviceContext->DrawInstanced(count, instances, 0, 0);
        }
        else
        {
            mDeviceContext->Draw(count, 0);
        }

        rx::ShaderExecutableD3D *pixelExe = nullptr;
        ANGLE_TRY(
            programD3D->getPixelExecutableForFramebuffer(glState.getDrawFramebuffer(), &pixelExe));

        // Skip the draw call if rasterizer discard is enabled (or no fragment shader).
        if (!pixelExe || glState.getRasterizerState().rasterizerDiscard)
        {
            return gl::Error(GL_NO_ERROR);
        }

        ID3D11PixelShader *pixelShader = GetAs<ShaderExecutable11>(pixelExe)->getPixelShader();
        ASSERT(reinterpret_cast<uintptr_t>(pixelShader) == mAppliedPixelShader);
        mDeviceContext->PSSetShader(pixelShader, NULL, 0);

        // Retrieve the geometry shader.
        rx::ShaderExecutableD3D *geometryExe = nullptr;
        ANGLE_TRY(
            programD3D->getGeometryExecutableForPrimitiveType(data, mode, &geometryExe, nullptr));

        ID3D11GeometryShader *geometryShader =
            (geometryExe ? GetAs<ShaderExecutable11>(geometryExe)->getGeometryShader() : NULL);
        mAppliedGeometryShader = reinterpret_cast<uintptr_t>(geometryShader);
        ASSERT(geometryShader);
        mDeviceContext->GSSetShader(geometryShader, NULL, 0);

        if (instances > 0)
        {
            mDeviceContext->DrawInstanced(count, instances, 0, 0);
        }
        else
        {
            mDeviceContext->Draw(count, 0);
        }
        return gl::Error(GL_NO_ERROR);
    }

    if (mode == GL_LINE_LOOP)
    {
        return drawLineLoop(data, count, GL_NONE, nullptr, nullptr, instances);
    }

    if (mode == GL_TRIANGLE_FAN)
    {
        return drawTriangleFan(data, count, GL_NONE, nullptr, 0, instances);
    }

    bool useInstancedPointSpriteEmulation =
        programD3D->usesPointSize() && getWorkarounds().useInstancedPointSpriteEmulation;

    if (instances > 0)
    {
        if (mode == GL_POINTS && useInstancedPointSpriteEmulation)
        {
            // If pointsprite emulation is used with glDrawArraysInstanced then we need to take a
            // less efficent code path.
            // Instanced rendering of emulated pointsprites requires a loop to draw each batch of
            // points. An offset into the instanced data buffer is calculated and applied on each
            // iteration to ensure all instances are rendered correctly.

            // Each instance being rendered requires the inputlayout cache to reapply buffers and
            // offsets.
            for (GLsizei i = 0; i < instances; i++)
            {
                ANGLE_TRY(
                    mInputLayoutCache.updateVertexOffsetsForPointSpritesEmulation(startVertex, i));
                mDeviceContext->DrawIndexedInstanced(6, count, 0, 0, 0);
            }
        }
        else
        {
            mDeviceContext->DrawInstanced(count, instances, 0, 0);
        }
        return gl::Error(GL_NO_ERROR);
    }

    // If the shader is writing to gl_PointSize, then pointsprites are being rendered.
    // Emulating instanced point sprites for FL9_3 requires the topology to be
    // D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST and DrawIndexedInstanced is called instead.
    if (mode == GL_POINTS && useInstancedPointSpriteEmulation)
    {
        mDeviceContext->DrawIndexedInstanced(6, count, 0, 0, 0);
    }
    else
    {
        mDeviceContext->Draw(count, 0);
    }
    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::drawElementsImpl(const gl::ContextState &data,
                                       const TranslatedIndexData &indexInfo,
                                       GLenum mode,
                                       GLsizei count,
                                       GLenum type,
                                       const GLvoid *indices,
                                       GLsizei instances)
{
    int minIndex = static_cast<int>(indexInfo.indexRange.start);

    if (mode == GL_LINE_LOOP)
    {
        return drawLineLoop(data, count, type, indices, &indexInfo, instances);
    }

    if (mode == GL_TRIANGLE_FAN)
    {
        return drawTriangleFan(data, count, type, indices, minIndex, instances);
    }

    const ProgramD3D *programD3D = GetImplAs<ProgramD3D>(data.getState().getProgram());
    if (instances > 0)
    {
        if (mode == GL_POINTS && programD3D->usesInstancedPointSpriteEmulation())
        {
            // If pointsprite emulation is used with glDrawElementsInstanced then we need to take a
            // less efficent code path.
            // Instanced rendering of emulated pointsprites requires a loop to draw each batch of
            // points. An offset into the instanced data buffer is calculated and applied on each
            // iteration to ensure all instances are rendered correctly.
            GLsizei elementsToRender = static_cast<GLsizei>(indexInfo.indexRange.vertexCount());

            // Each instance being rendered requires the inputlayout cache to reapply buffers and
            // offsets.
            for (GLsizei i = 0; i < instances; i++)
            {
                ANGLE_TRY(
                    mInputLayoutCache.updateVertexOffsetsForPointSpritesEmulation(minIndex, i));
                mDeviceContext->DrawIndexedInstanced(6, elementsToRender, 0, 0, 0);
            }
        }
        else
        {
            mDeviceContext->DrawIndexedInstanced(count, instances, 0, -minIndex, 0);
        }
        return gl::Error(GL_NO_ERROR);
    }

    // If the shader is writing to gl_PointSize, then pointsprites are being rendered.
    // Emulating instanced point sprites for FL9_3 requires the topology to be
    // D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST and DrawIndexedInstanced is called instead.
    if (mode == GL_POINTS && programD3D->usesInstancedPointSpriteEmulation())
    {
        // The count parameter passed to drawElements represents the total number of instances
        // to be rendered. Each instance is referenced by the bound index buffer from the
        // the caller.
        //
        // Indexed pointsprite emulation replicates data for duplicate entries found
        // in the index buffer.
        // This is not an efficent rendering mechanism and is only used on downlevel renderers
        // that do not support geometry shaders.
        mDeviceContext->DrawIndexedInstanced(6, count, 0, 0, 0);
    }
    else
    {
        mDeviceContext->DrawIndexed(count, 0, -minIndex);
    }
    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::drawLineLoop(const gl::ContextState &data,
                                   GLsizei count,
                                   GLenum type,
                                   const GLvoid *indexPointer,
                                   const TranslatedIndexData *indexInfo,
                                   int instances)
{
    const auto &glState            = data.getState();
    gl::VertexArray *vao           = glState.getVertexArray();
    gl::Buffer *elementArrayBuffer = vao->getElementArrayBuffer().get();

    const GLvoid *indices = indexPointer;

    // Get the raw indices for an indexed draw
    if (type != GL_NONE && elementArrayBuffer)
    {
        BufferD3D *storage = GetImplAs<BufferD3D>(elementArrayBuffer);
        intptr_t offset    = reinterpret_cast<intptr_t>(indices);

        const uint8_t *bufferData = NULL;
        ANGLE_TRY(storage->getData(&bufferData));

        indices = bufferData + offset;
    }

    if (!mLineLoopIB)
    {
        mLineLoopIB = new StreamingIndexBufferInterface(this);
        gl::Error error =
            mLineLoopIB->reserveBufferSpace(INITIAL_INDEX_BUFFER_SIZE, GL_UNSIGNED_INT);
        if (error.isError())
        {
            SafeDelete(mLineLoopIB);
            return error;
        }
    }

    // Checked by Renderer11::applyPrimitiveType
    ASSERT(count >= 0);

    if (static_cast<unsigned int>(count) + 1 >
        (std::numeric_limits<unsigned int>::max() / sizeof(unsigned int)))
    {
        return gl::Error(GL_OUT_OF_MEMORY,
                         "Failed to create a 32-bit looping index buffer for GL_LINE_LOOP, too "
                         "many indices required.");
    }

    GetLineLoopIndices(indices, type, static_cast<GLuint>(count),
                       glState.isPrimitiveRestartEnabled(), &mScratchIndexDataBuffer);

    unsigned int spaceNeeded =
        static_cast<unsigned int>(sizeof(GLuint) * mScratchIndexDataBuffer.size());
    ANGLE_TRY(mLineLoopIB->reserveBufferSpace(spaceNeeded, GL_UNSIGNED_INT));

    void *mappedMemory = NULL;
    unsigned int offset;
    ANGLE_TRY(mLineLoopIB->mapBuffer(spaceNeeded, &mappedMemory, &offset));

    // Copy over the converted index data.
    memcpy(mappedMemory, &mScratchIndexDataBuffer[0],
           sizeof(GLuint) * mScratchIndexDataBuffer.size());

    ANGLE_TRY(mLineLoopIB->unmapBuffer());

    IndexBuffer11 *indexBuffer   = GetAs<IndexBuffer11>(mLineLoopIB->getIndexBuffer());
    ID3D11Buffer *d3dIndexBuffer = indexBuffer->getBuffer();
    DXGI_FORMAT indexFormat      = indexBuffer->getIndexFormat();

    if (mAppliedIB != d3dIndexBuffer || mAppliedIBFormat != indexFormat ||
        mAppliedIBOffset != offset)
    {
        mDeviceContext->IASetIndexBuffer(d3dIndexBuffer, indexFormat, offset);
        mAppliedIB       = d3dIndexBuffer;
        mAppliedIBFormat = indexFormat;
        mAppliedIBOffset = offset;
    }

    INT baseVertexLocation = (indexInfo ? -static_cast<int>(indexInfo->indexRange.start) : 0);
    UINT indexCount        = static_cast<UINT>(mScratchIndexDataBuffer.size());

    if (instances > 0)
    {
        mDeviceContext->DrawIndexedInstanced(indexCount, instances, 0, baseVertexLocation, 0);
    }
    else
    {
        mDeviceContext->DrawIndexed(indexCount, 0, baseVertexLocation);
    }

    return gl::NoError();
}

gl::Error Renderer11::drawTriangleFan(const gl::ContextState &data,
                                      GLsizei count,
                                      GLenum type,
                                      const GLvoid *indices,
                                      int minIndex,
                                      int instances)
{
    gl::VertexArray *vao           = data.getState().getVertexArray();
    gl::Buffer *elementArrayBuffer = vao->getElementArrayBuffer().get();

    const GLvoid *indexPointer = indices;

    // Get the raw indices for an indexed draw
    if (type != GL_NONE && elementArrayBuffer)
    {
        BufferD3D *storage = GetImplAs<BufferD3D>(elementArrayBuffer);
        intptr_t offset    = reinterpret_cast<intptr_t>(indices);

        const uint8_t *bufferData = NULL;
        ANGLE_TRY(storage->getData(&bufferData));

        indexPointer = bufferData + offset;
    }

    if (!mTriangleFanIB)
    {
        mTriangleFanIB = new StreamingIndexBufferInterface(this);
        gl::Error error =
            mTriangleFanIB->reserveBufferSpace(INITIAL_INDEX_BUFFER_SIZE, GL_UNSIGNED_INT);
        if (error.isError())
        {
            SafeDelete(mTriangleFanIB);
            return error;
        }
    }

    // Checked by Renderer11::applyPrimitiveType
    ASSERT(count >= 3);

    const GLuint numTris = count - 2;

    if (numTris > (std::numeric_limits<unsigned int>::max() / (sizeof(unsigned int) * 3)))
    {
        return gl::Error(GL_OUT_OF_MEMORY,
                         "Failed to create a scratch index buffer for GL_TRIANGLE_FAN, too many "
                         "indices required.");
    }

    GetTriFanIndices(indexPointer, type, count, data.getState().isPrimitiveRestartEnabled(),
                     &mScratchIndexDataBuffer);

    const unsigned int spaceNeeded =
        static_cast<unsigned int>(mScratchIndexDataBuffer.size() * sizeof(unsigned int));
    ANGLE_TRY(mTriangleFanIB->reserveBufferSpace(spaceNeeded, GL_UNSIGNED_INT));

    void *mappedMemory = nullptr;
    unsigned int offset;
    ANGLE_TRY(mTriangleFanIB->mapBuffer(spaceNeeded, &mappedMemory, &offset));

    memcpy(mappedMemory, &mScratchIndexDataBuffer[0], spaceNeeded);

    ANGLE_TRY(mTriangleFanIB->unmapBuffer());

    IndexBuffer11 *indexBuffer   = GetAs<IndexBuffer11>(mTriangleFanIB->getIndexBuffer());
    ID3D11Buffer *d3dIndexBuffer = indexBuffer->getBuffer();
    DXGI_FORMAT indexFormat      = indexBuffer->getIndexFormat();

    if (mAppliedIB != d3dIndexBuffer || mAppliedIBFormat != indexFormat ||
        mAppliedIBOffset != offset)
    {
        mDeviceContext->IASetIndexBuffer(d3dIndexBuffer, indexFormat, offset);
        mAppliedIB       = d3dIndexBuffer;
        mAppliedIBFormat = indexFormat;
        mAppliedIBOffset = offset;
    }

    UINT indexCount = static_cast<UINT>(mScratchIndexDataBuffer.size());

    if (instances > 0)
    {
        mDeviceContext->DrawIndexedInstanced(indexCount, instances, 0, -minIndex, 0);
    }
    else
    {
        mDeviceContext->DrawIndexed(indexCount, 0, -minIndex);
    }

    return gl::NoError();
}

gl::Error Renderer11::applyShaders(const gl::ContextState &data, GLenum drawMode)
{
    const auto &glState    = data.getState();
    ProgramD3D *programD3D = GetImplAs<ProgramD3D>(glState.getProgram());
    programD3D->updateCachedInputLayout(glState);

    const auto &inputLayout = programD3D->getCachedInputLayout();

    ShaderExecutableD3D *vertexExe = nullptr;
    ANGLE_TRY(programD3D->getVertexExecutableForInputLayout(inputLayout, &vertexExe, nullptr));

    const gl::Framebuffer *drawFramebuffer = glState.getDrawFramebuffer();
    ShaderExecutableD3D *pixelExe          = nullptr;
    ANGLE_TRY(programD3D->getPixelExecutableForFramebuffer(drawFramebuffer, &pixelExe));

    ShaderExecutableD3D *geometryExe = nullptr;
    ANGLE_TRY(
        programD3D->getGeometryExecutableForPrimitiveType(data, drawMode, &geometryExe, nullptr));

    ID3D11VertexShader *vertexShader =
        (vertexExe ? GetAs<ShaderExecutable11>(vertexExe)->getVertexShader() : nullptr);

    ID3D11PixelShader *pixelShader = nullptr;
    // Skip pixel shader if we're doing rasterizer discard.
    bool rasterizerDiscard = glState.getRasterizerState().rasterizerDiscard;
    if (!rasterizerDiscard)
    {
        pixelShader = (pixelExe ? GetAs<ShaderExecutable11>(pixelExe)->getPixelShader() : nullptr);
    }

    ID3D11GeometryShader *geometryShader = nullptr;
    bool transformFeedbackActive         = glState.isTransformFeedbackActiveUnpaused();
    if (transformFeedbackActive)
    {
        geometryShader =
            (vertexExe ? GetAs<ShaderExecutable11>(vertexExe)->getStreamOutShader() : nullptr);
    }
    else
    {
        geometryShader =
            (geometryExe ? GetAs<ShaderExecutable11>(geometryExe)->getGeometryShader() : nullptr);
    }

    bool dirtyUniforms = false;

    if (reinterpret_cast<uintptr_t>(vertexShader) != mAppliedVertexShader)
    {
        mDeviceContext->VSSetShader(vertexShader, nullptr, 0);
        mAppliedVertexShader = reinterpret_cast<uintptr_t>(vertexShader);
        dirtyUniforms        = true;
    }

    if (reinterpret_cast<uintptr_t>(geometryShader) != mAppliedGeometryShader)
    {
        mDeviceContext->GSSetShader(geometryShader, nullptr, 0);
        mAppliedGeometryShader = reinterpret_cast<uintptr_t>(geometryShader);
        dirtyUniforms          = true;
    }

    if (reinterpret_cast<uintptr_t>(pixelShader) != mAppliedPixelShader)
    {
        mDeviceContext->PSSetShader(pixelShader, nullptr, 0);
        mAppliedPixelShader = reinterpret_cast<uintptr_t>(pixelShader);
        dirtyUniforms       = true;
    }

    if (dirtyUniforms)
    {
        programD3D->dirtyAllUniforms();
    }

    return programD3D->applyUniforms(drawMode);
}

gl::Error Renderer11::applyUniforms(const ProgramD3D &programD3D,
                                    GLenum drawMode,
                                    const std::vector<D3DUniform *> &uniformArray)
{
    unsigned int totalRegisterCountVS = 0;
    unsigned int totalRegisterCountPS = 0;

    bool vertexUniformsDirty = false;
    bool pixelUniformsDirty  = false;

    for (const D3DUniform *uniform : uniformArray)
    {
        if (uniform->isReferencedByVertexShader() && !uniform->isSampler())
        {
            totalRegisterCountVS += uniform->registerCount;
            vertexUniformsDirty = (vertexUniformsDirty || uniform->dirty);
        }

        if (uniform->isReferencedByFragmentShader() && !uniform->isSampler())
        {
            totalRegisterCountPS += uniform->registerCount;
            pixelUniformsDirty = (pixelUniformsDirty || uniform->dirty);
        }
    }

    const UniformStorage11 *vertexUniformStorage =
        GetAs<UniformStorage11>(&programD3D.getVertexUniformStorage());
    const UniformStorage11 *fragmentUniformStorage =
        GetAs<UniformStorage11>(&programD3D.getFragmentUniformStorage());
    ASSERT(vertexUniformStorage);
    ASSERT(fragmentUniformStorage);

    ID3D11Buffer *vertexConstantBuffer = vertexUniformStorage->getConstantBuffer();
    ID3D11Buffer *pixelConstantBuffer  = fragmentUniformStorage->getConstantBuffer();

    float(*mapVS)[4] = NULL;
    float(*mapPS)[4] = NULL;

    if (totalRegisterCountVS > 0 && vertexUniformsDirty)
    {
        D3D11_MAPPED_SUBRESOURCE map = {0};
        HRESULT result =
            mDeviceContext->Map(vertexConstantBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &map);
        ASSERT(SUCCEEDED(result));
        mapVS = (float(*)[4])map.pData;
    }

    if (totalRegisterCountPS > 0 && pixelUniformsDirty)
    {
        D3D11_MAPPED_SUBRESOURCE map = {0};
        HRESULT result =
            mDeviceContext->Map(pixelConstantBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &map);
        ASSERT(SUCCEEDED(result));
        mapPS = (float(*)[4])map.pData;
    }

    for (const D3DUniform *uniform : uniformArray)
    {
        if (uniform->isSampler())
            continue;

        unsigned int componentCount = (4 - uniform->registerElement);

        // we assume that uniforms from structs are arranged in struct order in our uniforms list.
        // otherwise we would overwrite previously written regions of memory.

        if (uniform->isReferencedByVertexShader() && mapVS)
        {
            memcpy(&mapVS[uniform->vsRegisterIndex][uniform->registerElement], uniform->data,
                   uniform->registerCount * sizeof(float) * componentCount);
        }

        if (uniform->isReferencedByFragmentShader() && mapPS)
        {
            memcpy(&mapPS[uniform->psRegisterIndex][uniform->registerElement], uniform->data,
                   uniform->registerCount * sizeof(float) * componentCount);
        }
    }

    if (mapVS)
    {
        mDeviceContext->Unmap(vertexConstantBuffer, 0);
    }

    if (mapPS)
    {
        mDeviceContext->Unmap(pixelConstantBuffer, 0);
    }

    if (mCurrentVertexConstantBuffer != vertexConstantBuffer)
    {
        mDeviceContext->VSSetConstantBuffers(
            d3d11::RESERVED_CONSTANT_BUFFER_SLOT_DEFAULT_UNIFORM_BLOCK, 1, &vertexConstantBuffer);
        mCurrentVertexConstantBuffer = vertexConstantBuffer;
    }

    if (mCurrentPixelConstantBuffer != pixelConstantBuffer)
    {
        mDeviceContext->PSSetConstantBuffers(
            d3d11::RESERVED_CONSTANT_BUFFER_SLOT_DEFAULT_UNIFORM_BLOCK, 1, &pixelConstantBuffer);
        mCurrentPixelConstantBuffer = pixelConstantBuffer;
    }

    if (!mDriverConstantBufferVS)
    {
        D3D11_BUFFER_DESC constantBufferDescription = {0};
        d3d11::InitConstantBufferDesc(
            &constantBufferDescription,
            sizeof(dx_VertexConstants11) + mSamplerMetadataVS.sizeBytes());
        HRESULT result =
            mDevice->CreateBuffer(&constantBufferDescription, nullptr, &mDriverConstantBufferVS);
        ASSERT(SUCCEEDED(result));
        if (FAILED(result))
        {
            return gl::Error(GL_OUT_OF_MEMORY,
                             "Failed to create vertex shader constant buffer, result: 0x%X.",
                             result);
        }
        mDeviceContext->VSSetConstantBuffers(d3d11::RESERVED_CONSTANT_BUFFER_SLOT_DRIVER, 1,
                                             &mDriverConstantBufferVS);
    }
    if (!mDriverConstantBufferPS)
    {
        D3D11_BUFFER_DESC constantBufferDescription = {0};
        d3d11::InitConstantBufferDesc(&constantBufferDescription,
                                      sizeof(dx_PixelConstants11) + mSamplerMetadataPS.sizeBytes());
        HRESULT result =
            mDevice->CreateBuffer(&constantBufferDescription, nullptr, &mDriverConstantBufferPS);
        ASSERT(SUCCEEDED(result));
        if (FAILED(result))
        {
            return gl::Error(GL_OUT_OF_MEMORY,
                             "Failed to create pixel shader constant buffer, result: 0x%X.",
                             result);
        }
        mDeviceContext->PSSetConstantBuffers(d3d11::RESERVED_CONSTANT_BUFFER_SLOT_DRIVER, 1,
                                             &mDriverConstantBufferPS);
    }

    // Sampler metadata and driver constants need to coexist in the same constant buffer to conserve
    // constant buffer slots. We update both in the constant buffer if needed.
    const dx_VertexConstants11 &vertexConstants = mStateManager.getVertexConstants();
    size_t samplerMetadataReferencedBytesVS     = sizeof(SamplerMetadataD3D11::dx_SamplerMetadata) *
                                              programD3D.getUsedSamplerRange(gl::SAMPLER_VERTEX);
    applyDriverConstantsIfNeeded(&mAppliedVertexConstants, vertexConstants, &mSamplerMetadataVS,
                                 samplerMetadataReferencedBytesVS, mDriverConstantBufferVS);

    const dx_PixelConstants11 &pixelConstants = mStateManager.getPixelConstants();
    size_t samplerMetadataReferencedBytesPS   = sizeof(SamplerMetadataD3D11::dx_SamplerMetadata) *
                                              programD3D.getUsedSamplerRange(gl::SAMPLER_PIXEL);
    applyDriverConstantsIfNeeded(&mAppliedPixelConstants, pixelConstants, &mSamplerMetadataPS,
                                 samplerMetadataReferencedBytesPS, mDriverConstantBufferPS);

    // GSSetConstantBuffers triggers device removal on 9_3, so we should only call it if necessary
    if (programD3D.usesGeometryShader(drawMode))
    {
        // needed for the point sprite geometry shader
        if (mCurrentGeometryConstantBuffer != mDriverConstantBufferPS)
        {
            ASSERT(mDriverConstantBufferPS != nullptr);
            mDeviceContext->GSSetConstantBuffers(0, 1, &mDriverConstantBufferPS);
            mCurrentGeometryConstantBuffer = mDriverConstantBufferPS;
        }
    }

    return gl::Error(GL_NO_ERROR);
}

// SamplerMetadataD3D11 implementation

Renderer11::SamplerMetadataD3D11::SamplerMetadataD3D11() : mDirty(true)
{
}

Renderer11::SamplerMetadataD3D11::~SamplerMetadataD3D11()
{
}

void Renderer11::SamplerMetadataD3D11::initData(unsigned int samplerCount)
{
    mSamplerMetadata.resize(samplerCount);
}

void Renderer11::SamplerMetadataD3D11::update(unsigned int samplerIndex, const gl::Texture &texture)
{
    unsigned int baseLevel = texture.getTextureState().getEffectiveBaseLevel();
    GLenum sizedFormat     = texture.getFormat(texture.getTarget(), baseLevel).asSized();
    if (mSamplerMetadata[samplerIndex].baseLevel != static_cast<int>(baseLevel))
    {
        mSamplerMetadata[samplerIndex].baseLevel = static_cast<int>(baseLevel);
        mDirty                                   = true;
    }

    // Some metadata is needed only for integer textures. We avoid updating the constant buffer
    // unnecessarily by changing the data only in case the texture is an integer texture and
    // the values have changed.
    bool needIntegerTextureMetadata = false;
    // internalFormatBits == 0 means a 32-bit texture in the case of integer textures.
    int internalFormatBits = 0;
    switch (sizedFormat)
    {
        case GL_RGBA32I:
        case GL_RGBA32UI:
        case GL_RGB32I:
        case GL_RGB32UI:
        case GL_RG32I:
        case GL_RG32UI:
        case GL_R32I:
        case GL_R32UI:
            needIntegerTextureMetadata = true;
            break;
        case GL_RGBA16I:
        case GL_RGBA16UI:
        case GL_RGB16I:
        case GL_RGB16UI:
        case GL_RG16I:
        case GL_RG16UI:
        case GL_R16I:
        case GL_R16UI:
            needIntegerTextureMetadata = true;
            internalFormatBits         = 16;
            break;
        case GL_RGBA8I:
        case GL_RGBA8UI:
        case GL_RGB8I:
        case GL_RGB8UI:
        case GL_RG8I:
        case GL_RG8UI:
        case GL_R8I:
        case GL_R8UI:
            needIntegerTextureMetadata = true;
            internalFormatBits         = 8;
            break;
        case GL_RGB10_A2UI:
            needIntegerTextureMetadata = true;
            internalFormatBits         = 10;
            break;
        default:
            break;
    }
    if (needIntegerTextureMetadata)
    {
        if (mSamplerMetadata[samplerIndex].internalFormatBits != internalFormatBits)
        {
            mSamplerMetadata[samplerIndex].internalFormatBits = internalFormatBits;
            mDirty                                            = true;
        }
        // Pack the wrap values into one integer so we can fit all the metadata in one 4-integer
        // vector.
        GLenum wrapS  = texture.getWrapS();
        GLenum wrapT  = texture.getWrapT();
        GLenum wrapR  = texture.getWrapR();
        int wrapModes = GetWrapBits(wrapS) | (GetWrapBits(wrapT) << 2) | (GetWrapBits(wrapR) << 4);
        if (mSamplerMetadata[samplerIndex].wrapModes != wrapModes)
        {
            mSamplerMetadata[samplerIndex].wrapModes = wrapModes;
            mDirty                                   = true;
        }
    }
}

const Renderer11::SamplerMetadataD3D11::dx_SamplerMetadata *
Renderer11::SamplerMetadataD3D11::getData() const
{
    return mSamplerMetadata.data();
}

size_t Renderer11::SamplerMetadataD3D11::sizeBytes() const
{
    return sizeof(SamplerMetadataD3D11::dx_SamplerMetadata) * mSamplerMetadata.size();
}

template <class TShaderConstants>
void Renderer11::applyDriverConstantsIfNeeded(TShaderConstants *appliedConstants,
                                              const TShaderConstants &constants,
                                              SamplerMetadataD3D11 *samplerMetadata,
                                              size_t samplerMetadataReferencedBytes,
                                              ID3D11Buffer *driverConstantBuffer)
{
    ASSERT(driverConstantBuffer != nullptr);
    if (memcmp(appliedConstants, &constants, sizeof(TShaderConstants)) != 0 ||
        samplerMetadata->isDirty())
    {
        memcpy(appliedConstants, &constants, sizeof(TShaderConstants));

        D3D11_MAPPED_SUBRESOURCE mapping = {0};
        HRESULT result =
            mDeviceContext->Map(driverConstantBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mapping);
        ASSERT(SUCCEEDED(result));
        memcpy(mapping.pData, appliedConstants, sizeof(TShaderConstants));
        // Previous buffer contents were discarded, so we need to refresh also the area of the
        // buffer that isn't used by this program.
        memcpy(&reinterpret_cast<uint8_t *>(mapping.pData)[sizeof(TShaderConstants)],
               samplerMetadata->getData(), samplerMetadata->sizeBytes());
        mDeviceContext->Unmap(driverConstantBuffer, 0);

        samplerMetadata->markClean();
    }
}

template void Renderer11::applyDriverConstantsIfNeeded<dx_VertexConstants11>(
    dx_VertexConstants11 *appliedConstants,
    const dx_VertexConstants11 &constants,
    SamplerMetadataD3D11 *samplerMetadata,
    size_t samplerMetadataReferencedBytes,
    ID3D11Buffer *driverConstantBuffer);
template void Renderer11::applyDriverConstantsIfNeeded<dx_PixelConstants11>(
    dx_PixelConstants11 *appliedConstants,
    const dx_PixelConstants11 &constants,
    SamplerMetadataD3D11 *samplerMetadata,
    size_t samplerMetadataReferencedBytes,
    ID3D11Buffer *driverConstantBuffer);

void Renderer11::markAllStateDirty()
{
    TRACE_EVENT0("gpu.angle", "Renderer11::markAllStateDirty");

    for (size_t vsamplerId = 0; vsamplerId < mForceSetVertexSamplerStates.size(); ++vsamplerId)
    {
        mForceSetVertexSamplerStates[vsamplerId] = true;
    }

    for (size_t fsamplerId = 0; fsamplerId < mForceSetPixelSamplerStates.size(); ++fsamplerId)
    {
        mForceSetPixelSamplerStates[fsamplerId] = true;
    }

    mStateManager.invalidateEverything();

    mAppliedIB       = NULL;
    mAppliedIBFormat = DXGI_FORMAT_UNKNOWN;
    mAppliedIBOffset = 0;

    mAppliedVertexShader   = angle::DirtyPointer;
    mAppliedGeometryShader = angle::DirtyPointer;
    mAppliedPixelShader    = angle::DirtyPointer;

    mAppliedTFObject = angle::DirtyPointer;

    memset(&mAppliedVertexConstants, 0, sizeof(dx_VertexConstants11));
    memset(&mAppliedPixelConstants, 0, sizeof(dx_PixelConstants11));

    mInputLayoutCache.markDirty();

    for (unsigned int i = 0; i < gl::IMPLEMENTATION_MAX_VERTEX_SHADER_UNIFORM_BUFFERS; i++)
    {
        mCurrentConstantBufferVS[i]       = static_cast<unsigned int>(-1);
        mCurrentConstantBufferVSOffset[i] = 0;
        mCurrentConstantBufferVSSize[i]   = 0;
        mCurrentConstantBufferPS[i]       = static_cast<unsigned int>(-1);
        mCurrentConstantBufferPSOffset[i] = 0;
        mCurrentConstantBufferPSSize[i]   = 0;
    }

    mCurrentVertexConstantBuffer   = NULL;
    mCurrentPixelConstantBuffer    = NULL;
    mCurrentGeometryConstantBuffer = NULL;

    mCurrentPrimitiveTopology = D3D_PRIMITIVE_TOPOLOGY_UNDEFINED;
}

void Renderer11::releaseDeviceResources()
{
    mStateManager.deinitialize();
    mStateCache.clear();
    mInputLayoutCache.clear();

    SafeDelete(mVertexDataManager);
    SafeDelete(mIndexDataManager);
    SafeDelete(mLineLoopIB);
    SafeDelete(mTriangleFanIB);
    SafeDelete(mBlit);
    SafeDelete(mClear);
    SafeDelete(mTrim);
    SafeDelete(mPixelTransfer);

    SafeRelease(mDriverConstantBufferVS);
    SafeRelease(mDriverConstantBufferPS);
    SafeRelease(mSyncQuery);
}

// set notify to true to broadcast a message to all contexts of the device loss
bool Renderer11::testDeviceLost()
{
    bool isLost = false;

    if (!mDevice)
    {
        return true;
    }

    // GetRemovedReason is used to test if the device is removed
    HRESULT result = mDevice->GetDeviceRemovedReason();
    isLost         = d3d11::isDeviceLostError(result);

    if (isLost)
    {
        ERR("The D3D11 device was removed: 0x%08X", result);
    }

    return isLost;
}

bool Renderer11::testDeviceResettable()
{
    // determine if the device is resettable by creating a dummy device
    PFN_D3D11_CREATE_DEVICE D3D11CreateDevice =
        (PFN_D3D11_CREATE_DEVICE)GetProcAddress(mD3d11Module, "D3D11CreateDevice");

    if (D3D11CreateDevice == NULL)
    {
        return false;
    }

    ID3D11Device *dummyDevice;
    D3D_FEATURE_LEVEL dummyFeatureLevel;
    ID3D11DeviceContext *dummyContext;

    ASSERT(mRequestedDriverType != D3D_DRIVER_TYPE_UNKNOWN);
    HRESULT result = D3D11CreateDevice(
        NULL, mRequestedDriverType, NULL,
#if defined(_DEBUG)
        D3D11_CREATE_DEVICE_DEBUG,
#else
        0,
#endif
        mAvailableFeatureLevels.data(), static_cast<unsigned int>(mAvailableFeatureLevels.size()),
        D3D11_SDK_VERSION, &dummyDevice, &dummyFeatureLevel, &dummyContext);

    if (!mDevice || FAILED(result))
    {
        return false;
    }

    SafeRelease(dummyContext);
    SafeRelease(dummyDevice);

    return true;
}

void Renderer11::release()
{
    RendererD3D::cleanup();

    mScratchMemoryBuffer.resize(0);

    if (mAnnotator != nullptr)
    {
        gl::UninitializeDebugAnnotations();
        SafeDelete(mAnnotator);
    }

    releaseDeviceResources();

    if (!mCreatedWithDeviceEXT)
    {
        // Only delete the device if the Renderer11 owns it
        // Otherwise we should keep it around in case we try to reinitialize the renderer later
        SafeDelete(mEGLDevice);
    }

    SafeRelease(mDxgiFactory);
    SafeRelease(mDxgiAdapter);

    SafeRelease(mDeviceContext1);

    if (mDeviceContext)
    {
        mDeviceContext->ClearState();
        mDeviceContext->Flush();
        SafeRelease(mDeviceContext);
    }

    SafeRelease(mDevice);
    SafeRelease(mDebug);

    if (mD3d11Module)
    {
        FreeLibrary(mD3d11Module);
        mD3d11Module = NULL;
    }

    if (mDxgiModule)
    {
        FreeLibrary(mDxgiModule);
        mDxgiModule = NULL;
    }

    if (mDCompModule)
    {
        FreeLibrary(mDCompModule);
        mDCompModule = NULL;
    }

    mCompiler.release();

    mSupportsShareHandles.reset();
}

bool Renderer11::resetDevice()
{
    // recreate everything
    release();
    egl::Error result = initialize();

    if (result.isError())
    {
        ERR("Could not reinitialize D3D11 device: %08X", result.getCode());
        return false;
    }

    return true;
}

SIZE_T Renderer11::getMaxResourceSize() const
{
    // This formula comes from http://msdn.microsoft.com/en-us/library/windows/desktop/ff819065%28v=vs.85%29.aspx
    return std::min(std::max(SIZE_T(128 * 1024 * 1024), mAdapterDescription.DedicatedVideoMemory), SIZE_T(2048) * 1024 * 1024);
}

std::string Renderer11::getRendererDescription() const
{
    std::ostringstream rendererString;

    rendererString << mDescription;
    rendererString << " Direct3D11";

    rendererString << " vs_" << getMajorShaderModel() << "_" << getMinorShaderModel()
                   << getShaderModelSuffix();
    rendererString << " ps_" << getMajorShaderModel() << "_" << getMinorShaderModel()
                   << getShaderModelSuffix();

    return rendererString.str();
}

DeviceIdentifier Renderer11::getAdapterIdentifier() const
{
    // Don't use the AdapterLuid here, since that doesn't persist across reboot.
    DeviceIdentifier deviceIdentifier = {0};
    deviceIdentifier.VendorId         = mAdapterDescription.VendorId;
    deviceIdentifier.DeviceId         = mAdapterDescription.DeviceId;
    deviceIdentifier.SubSysId         = mAdapterDescription.SubSysId;
    deviceIdentifier.Revision         = mAdapterDescription.Revision;
    deviceIdentifier.FeatureLevel     = static_cast<UINT>(mRenderer11DeviceCaps.featureLevel);

    return deviceIdentifier;
}

unsigned int Renderer11::getReservedVertexUniformVectors() const
{
    // Driver uniforms are stored in a separate constant buffer
    return d3d11_gl::GetReservedVertexUniformVectors(mRenderer11DeviceCaps.featureLevel);
}

unsigned int Renderer11::getReservedFragmentUniformVectors() const
{
    // Driver uniforms are stored in a separate constant buffer
    return d3d11_gl::GetReservedFragmentUniformVectors(mRenderer11DeviceCaps.featureLevel);
}

unsigned int Renderer11::getReservedVertexUniformBuffers() const
{
    // we reserve one buffer for the application uniforms, and one for driver uniforms
    return 2;
}

unsigned int Renderer11::getReservedFragmentUniformBuffers() const
{
    // we reserve one buffer for the application uniforms, and one for driver uniforms
    return 2;
}

d3d11::ANGLED3D11DeviceType Renderer11::getDeviceType() const
{
    if (mCreatedWithDeviceEXT)
    {
        return d3d11::GetDeviceType(mDevice);
    }

    if ((mRequestedDriverType == D3D_DRIVER_TYPE_SOFTWARE) ||
        (mRequestedDriverType == D3D_DRIVER_TYPE_REFERENCE) ||
        (mRequestedDriverType == D3D_DRIVER_TYPE_NULL))
    {
        return d3d11::ANGLE_D3D11_DEVICE_TYPE_SOFTWARE_REF_OR_NULL;
    }

    if (mRequestedDriverType == D3D_DRIVER_TYPE_WARP)
    {
        return d3d11::ANGLE_D3D11_DEVICE_TYPE_WARP;
    }

    return d3d11::ANGLE_D3D11_DEVICE_TYPE_HARDWARE;
}

bool Renderer11::getShareHandleSupport() const
{
    if (mSupportsShareHandles.valid())
    {
        return mSupportsShareHandles.value();
    }

    // We only currently support share handles with BGRA surfaces, because
    // chrome needs BGRA. Once chrome fixes this, we should always support them.
    if (!getNativeExtensions().textureFormatBGRA8888)
    {
        mSupportsShareHandles = false;
        return false;
    }

    // PIX doesn't seem to support using share handles, so disable them.
    if (gl::DebugAnnotationsActive())
    {
        mSupportsShareHandles = false;
        return false;
    }

    // Also disable share handles on Feature Level 9_3, since it doesn't support share handles on
    // RGBA8 textures/swapchains.
    if (mRenderer11DeviceCaps.featureLevel <= D3D_FEATURE_LEVEL_9_3)
    {
        mSupportsShareHandles = false;
        return false;
    }

    // Find out which type of D3D11 device the Renderer11 is using
    d3d11::ANGLED3D11DeviceType deviceType = getDeviceType();
    if (deviceType == d3d11::ANGLE_D3D11_DEVICE_TYPE_UNKNOWN)
    {
        mSupportsShareHandles = false;
        return false;
    }

    if (deviceType == d3d11::ANGLE_D3D11_DEVICE_TYPE_SOFTWARE_REF_OR_NULL)
    {
        // Software/Reference/NULL devices don't support share handles
        mSupportsShareHandles = false;
        return false;
    }

    if (deviceType == d3d11::ANGLE_D3D11_DEVICE_TYPE_WARP)
    {
#ifndef ANGLE_ENABLE_WINDOWS_STORE
        if (!IsWindows8OrGreater())
        {
            // WARP on Windows 7 doesn't support shared handles
            mSupportsShareHandles = false;
            return false;
        }
#endif  // ANGLE_ENABLE_WINDOWS_STORE

        // WARP on Windows 8.0+ supports shared handles when shared with another WARP device
        // TODO: allow applications to query for HARDWARE or WARP-specific share handles,
        //       to prevent them trying to use a WARP share handle with an a HW device (or
        //       vice-versa)
        //       e.g. by creating EGL_D3D11_[HARDWARE/WARP]_DEVICE_SHARE_HANDLE_ANGLE
        mSupportsShareHandles = true;
        return true;
    }

    ASSERT(mCreatedWithDeviceEXT || mRequestedDriverType == D3D_DRIVER_TYPE_HARDWARE);
    mSupportsShareHandles = true;
    return true;
}

bool Renderer11::getNV12TextureSupport() const
{
    HRESULT result;
    UINT formatSupport;
    result = mDevice->CheckFormatSupport(DXGI_FORMAT_NV12, &formatSupport);
    if (result == E_FAIL)
    {
        return false;
    }
    return (formatSupport & D3D11_FORMAT_SUPPORT_TEXTURE2D) != 0;
}

int Renderer11::getMajorShaderModel() const
{
    switch (mRenderer11DeviceCaps.featureLevel)
    {
        case D3D_FEATURE_LEVEL_11_0:
            return D3D11_SHADER_MAJOR_VERSION;  // 5
        case D3D_FEATURE_LEVEL_10_1:
            return D3D10_1_SHADER_MAJOR_VERSION;  // 4
        case D3D_FEATURE_LEVEL_10_0:
            return D3D10_SHADER_MAJOR_VERSION;  // 4
        case D3D_FEATURE_LEVEL_9_3:
            return D3D10_SHADER_MAJOR_VERSION;  // 4
        default:
            UNREACHABLE();
            return 0;
    }
}

int Renderer11::getMinorShaderModel() const
{
    switch (mRenderer11DeviceCaps.featureLevel)
    {
        case D3D_FEATURE_LEVEL_11_0:
            return D3D11_SHADER_MINOR_VERSION;  // 0
        case D3D_FEATURE_LEVEL_10_1:
            return D3D10_1_SHADER_MINOR_VERSION;  // 1
        case D3D_FEATURE_LEVEL_10_0:
            return D3D10_SHADER_MINOR_VERSION;  // 0
        case D3D_FEATURE_LEVEL_9_3:
            return D3D10_SHADER_MINOR_VERSION;  // 0
        default:
            UNREACHABLE();
            return 0;
    }
}

std::string Renderer11::getShaderModelSuffix() const
{
    switch (mRenderer11DeviceCaps.featureLevel)
    {
        case D3D_FEATURE_LEVEL_11_0:
            return "";
        case D3D_FEATURE_LEVEL_10_1:
            return "";
        case D3D_FEATURE_LEVEL_10_0:
            return "";
        case D3D_FEATURE_LEVEL_9_3:
            return "_level_9_3";
        default:
            UNREACHABLE();
            return "";
    }
}

const WorkaroundsD3D &RendererD3D::getWorkarounds() const
{
    if (!mWorkaroundsInitialized)
    {
        mWorkarounds            = generateWorkarounds();
        mWorkaroundsInitialized = true;
    }

    return mWorkarounds;
}

gl::Error Renderer11::copyImageInternal(const gl::Framebuffer *framebuffer,
                                        const gl::Rectangle &sourceRect,
                                        GLenum destFormat,
                                        const gl::Offset &destOffset,
                                        RenderTargetD3D *destRenderTarget)
{
    const gl::FramebufferAttachment *colorAttachment = framebuffer->getReadColorbuffer();
    ASSERT(colorAttachment);

    RenderTarget11 *sourceRenderTarget = nullptr;
    ANGLE_TRY(colorAttachment->getRenderTarget(&sourceRenderTarget));
    ASSERT(sourceRenderTarget);

    ID3D11ShaderResourceView *source = sourceRenderTarget->getBlitShaderResourceView();
    ASSERT(source);

    ID3D11RenderTargetView *dest = GetAs<RenderTarget11>(destRenderTarget)->getRenderTargetView();
    ASSERT(dest);

    gl::Box sourceArea(sourceRect.x, sourceRect.y, 0, sourceRect.width, sourceRect.height, 1);
    gl::Extents sourceSize(sourceRenderTarget->getWidth(), sourceRenderTarget->getHeight(), 1);

    const bool invertSource = UsePresentPathFast(this, colorAttachment);
    if (invertSource)
    {
        sourceArea.y      = sourceSize.height - sourceRect.y;
        sourceArea.height = -sourceArea.height;
    }

    gl::Box destArea(destOffset.x, destOffset.y, 0, sourceRect.width, sourceRect.height, 1);
    gl::Extents destSize(destRenderTarget->getWidth(), destRenderTarget->getHeight(), 1);

    // Use nearest filtering because source and destination are the same size for the direct copy.
    // Convert to the unsized format before calling copyTexture.
    const gl::InternalFormat &internalFormat = gl::GetInternalFormatInfo(destFormat);
    ANGLE_TRY(mBlit->copyTexture(source, sourceArea, sourceSize, dest, destArea, destSize, nullptr,
                                 internalFormat.format, GL_NEAREST, false, false, false));

    return gl::NoError();
}

gl::Error Renderer11::copyImage2D(const gl::Framebuffer *framebuffer,
                                  const gl::Rectangle &sourceRect,
                                  GLenum destFormat,
                                  const gl::Offset &destOffset,
                                  TextureStorage *storage,
                                  GLint level)
{
    TextureStorage11_2D *storage11 = GetAs<TextureStorage11_2D>(storage);
    ASSERT(storage11);

    gl::ImageIndex index              = gl::ImageIndex::Make2D(level);
    RenderTargetD3D *destRenderTarget = nullptr;
    ANGLE_TRY(storage11->getRenderTarget(index, &destRenderTarget));
    ASSERT(destRenderTarget);

    ANGLE_TRY(copyImageInternal(framebuffer, sourceRect, destFormat, destOffset, destRenderTarget));

    storage11->markLevelDirty(level);

    return gl::NoError();
}

gl::Error Renderer11::copyImageCube(const gl::Framebuffer *framebuffer,
                                    const gl::Rectangle &sourceRect,
                                    GLenum destFormat,
                                    const gl::Offset &destOffset,
                                    TextureStorage *storage,
                                    GLenum target,
                                    GLint level)
{
    TextureStorage11_Cube *storage11 = GetAs<TextureStorage11_Cube>(storage);
    ASSERT(storage11);

    gl::ImageIndex index              = gl::ImageIndex::MakeCube(target, level);
    RenderTargetD3D *destRenderTarget = nullptr;
    ANGLE_TRY(storage11->getRenderTarget(index, &destRenderTarget));
    ASSERT(destRenderTarget);

    ANGLE_TRY(copyImageInternal(framebuffer, sourceRect, destFormat, destOffset, destRenderTarget));

    storage11->markLevelDirty(level);

    return gl::NoError();
}

gl::Error Renderer11::copyImage3D(const gl::Framebuffer *framebuffer,
                                  const gl::Rectangle &sourceRect,
                                  GLenum destFormat,
                                  const gl::Offset &destOffset,
                                  TextureStorage *storage,
                                  GLint level)
{
    TextureStorage11_3D *storage11 = GetAs<TextureStorage11_3D>(storage);
    ASSERT(storage11);

    gl::ImageIndex index              = gl::ImageIndex::Make3D(level, destOffset.z);
    RenderTargetD3D *destRenderTarget = nullptr;
    ANGLE_TRY(storage11->getRenderTarget(index, &destRenderTarget));
    ASSERT(destRenderTarget);

    ANGLE_TRY(copyImageInternal(framebuffer, sourceRect, destFormat, destOffset, destRenderTarget));

    storage11->markLevelDirty(level);

    return gl::NoError();
}

gl::Error Renderer11::copyImage2DArray(const gl::Framebuffer *framebuffer,
                                       const gl::Rectangle &sourceRect,
                                       GLenum destFormat,
                                       const gl::Offset &destOffset,
                                       TextureStorage *storage,
                                       GLint level)
{
    TextureStorage11_2DArray *storage11 = GetAs<TextureStorage11_2DArray>(storage);
    ASSERT(storage11);

    gl::ImageIndex index              = gl::ImageIndex::Make2DArray(level, destOffset.z);
    RenderTargetD3D *destRenderTarget = nullptr;
    ANGLE_TRY(storage11->getRenderTarget(index, &destRenderTarget));
    ASSERT(destRenderTarget);

    ANGLE_TRY(copyImageInternal(framebuffer, sourceRect, destFormat, destOffset, destRenderTarget));
    storage11->markLevelDirty(level);

    return gl::NoError();
}

gl::Error Renderer11::copyTexture(const gl::Texture *source,
                                  GLint sourceLevel,
                                  const gl::Rectangle &sourceRect,
                                  GLenum destFormat,
                                  const gl::Offset &destOffset,
                                  TextureStorage *storage,
                                  GLint destLevel,
                                  bool unpackFlipY,
                                  bool unpackPremultiplyAlpha,
                                  bool unpackUnmultiplyAlpha)
{
    const TextureD3D *sourceD3D = GetImplAs<TextureD3D>(source);

    TextureStorage *sourceStorage = nullptr;
    ANGLE_TRY(const_cast<TextureD3D *>(sourceD3D)->getNativeTexture(&sourceStorage));

    TextureStorage11_2D *sourceStorage11 = GetAs<TextureStorage11_2D>(sourceStorage);
    ASSERT(sourceStorage11);

    TextureStorage11_2D *destStorage11 = GetAs<TextureStorage11_2D>(storage);
    ASSERT(destStorage11);

    // Check for fast path where a CopySubresourceRegion can be used.
    if (unpackPremultiplyAlpha == unpackUnmultiplyAlpha && !unpackFlipY &&
        sourceStorage11->getFormatSet().texFormat == destStorage11->getFormatSet().texFormat)
    {
        ID3D11Resource *sourceResource = nullptr;
        ANGLE_TRY(sourceStorage11->getResource(&sourceResource));

        gl::ImageIndex sourceIndex = gl::ImageIndex::Make2D(sourceLevel);
        UINT sourceSubresource     = sourceStorage11->getSubresourceIndex(sourceIndex);

        ID3D11Resource *destResource = nullptr;
        ANGLE_TRY(destStorage11->getResource(&destResource));

        gl::ImageIndex destIndex = gl::ImageIndex::Make2D(destLevel);
        UINT destSubresource     = destStorage11->getSubresourceIndex(destIndex);

        D3D11_BOX sourceBox{
            static_cast<UINT>(sourceRect.x),
            static_cast<UINT>(sourceRect.y),
            0u,
            static_cast<UINT>(sourceRect.x + sourceRect.width),
            static_cast<UINT>(sourceRect.y + sourceRect.height),
            1u,
        };

        mDeviceContext->CopySubresourceRegion(destResource, destSubresource, destOffset.x,
                                              destOffset.y, destOffset.z, sourceResource,
                                              sourceSubresource, &sourceBox);
    }
    else
    {
        ID3D11ShaderResourceView *sourceSRV = nullptr;
        ANGLE_TRY(sourceStorage11->getSRVLevels(sourceLevel, sourceLevel, &sourceSRV));

        gl::ImageIndex destIndex             = gl::ImageIndex::Make2D(destLevel);
        RenderTargetD3D *destRenderTargetD3D = nullptr;
        ANGLE_TRY(destStorage11->getRenderTarget(destIndex, &destRenderTargetD3D));

        RenderTarget11 *destRenderTarget11 = GetAs<RenderTarget11>(destRenderTargetD3D);

        ID3D11RenderTargetView *destRTV = destRenderTarget11->getRenderTargetView();
        ASSERT(destRTV);

        gl::Box sourceArea(sourceRect.x, sourceRect.y, 0, sourceRect.width, sourceRect.height, 1);
        gl::Extents sourceSize(
            static_cast<int>(source->getWidth(source->getTarget(), sourceLevel)),
            static_cast<int>(source->getHeight(source->getTarget(), sourceLevel)), 1);
        if (unpackFlipY)
        {
            sourceArea.y      = sourceSize.height - sourceRect.y;
            sourceArea.height = -sourceArea.height;
        }

        gl::Box destArea(destOffset.x, destOffset.y, 0, sourceRect.width, sourceRect.height, 1);
        gl::Extents destSize(destRenderTarget11->getWidth(), destRenderTarget11->getHeight(), 1);

        // Use nearest filtering because source and destination are the same size for the direct
        // copy
        ANGLE_TRY(mBlit->copyTexture(sourceSRV, sourceArea, sourceSize, destRTV, destArea, destSize,
                                     nullptr, destFormat, GL_NEAREST, false, unpackPremultiplyAlpha,
                                     unpackUnmultiplyAlpha));
    }

    destStorage11->markLevelDirty(destLevel);

    return gl::NoError();
}

UINT64 EstimateSize(D3D11_TEXTURE2D_DESC &desc)
{
    //XXX: handle overflow (64 bits should be enough for anyone...)
    const d3d11::DXGIFormatSize &dxgiFormatInfo = d3d11::GetDXGIFormatSizeInfo(desc.Format);
    // NVIDIA seems to align the width of buffers by 8 and the height by 64, so we do the same.
    UINT64 total = UINT64(rx::roundUp(desc.Width, UINT(8))) * rx::roundUp(desc.Height, UINT(64)) * desc.SampleDesc.Count * dxgiFormatInfo.pixelBytes;
    return total;
}

gl::Error Renderer11::copyCompressedTexture(const gl::Texture *source,
                                            GLint sourceLevel,
                                            TextureStorage *storage,
                                            GLint destLevel)
{
    TextureStorage11_2D *destStorage11 = GetAs<TextureStorage11_2D>(storage);
    ASSERT(destStorage11);

    ID3D11Resource *destResource = nullptr;
    ANGLE_TRY(destStorage11->getResource(&destResource));

    gl::ImageIndex destIndex = gl::ImageIndex::Make2D(destLevel);
    UINT destSubresource     = destStorage11->getSubresourceIndex(destIndex);

    TextureD3D *sourceD3D = GetImplAs<TextureD3D>(source);
    ASSERT(sourceD3D);

    TextureStorage *sourceStorage = nullptr;
    ANGLE_TRY(sourceD3D->getNativeTexture(&sourceStorage));

    TextureStorage11_2D *sourceStorage11 = GetAs<TextureStorage11_2D>(sourceStorage);
    ASSERT(sourceStorage11);

    ID3D11Resource *sourceResource = nullptr;
    ANGLE_TRY(sourceStorage11->getResource(&sourceResource));

    gl::ImageIndex sourceIndex = gl::ImageIndex::Make2D(sourceLevel);
    UINT sourceSubresource     = sourceStorage11->getSubresourceIndex(sourceIndex);

    mDeviceContext->CopySubresourceRegion(destResource, destSubresource, 0, 0, 0, sourceResource,
                                          sourceSubresource, nullptr);

    return gl::NoError();
}

gl::Error Renderer11::createRenderTarget(int width,
                                         int height,
                                         GLenum format,
                                         GLsizei samples,
                                         RenderTargetD3D **outRT)
{
    const d3d11::Format &formatInfo = d3d11::Format::Get(format, mRenderer11DeviceCaps);

    const gl::TextureCaps &textureCaps = getNativeTextureCaps().get(format);
    GLuint supportedSamples            = textureCaps.getNearestSamples(samples);

    if (width > 0 && height > 0)
    {
        // Create texture resource
        D3D11_TEXTURE2D_DESC desc;
        desc.Width              = width;
        desc.Height             = height;
        desc.MipLevels          = 1;
        desc.ArraySize          = 1;
        desc.Format             = formatInfo.texFormat;
        desc.SampleDesc.Count   = (supportedSamples == 0) ? 1 : supportedSamples;
        desc.SampleDesc.Quality = 0;
        desc.Usage              = D3D11_USAGE_DEFAULT;
        desc.CPUAccessFlags     = 0;
        desc.MiscFlags          = 0;

        // If a rendertarget or depthstencil format exists for this texture format,
        // we'll flag it to allow binding that way. Shader resource views are a little
        // more complicated.
        bool bindRTV = false, bindDSV = false, bindSRV = false;
        bindRTV = (formatInfo.rtvFormat != DXGI_FORMAT_UNKNOWN);
        bindDSV = (formatInfo.dsvFormat != DXGI_FORMAT_UNKNOWN);
        bindSRV = (formatInfo.srvFormat != DXGI_FORMAT_UNKNOWN);

        // D3D feature level 10.0 no longer allows creation of textures with both the bind SRV and
        // DSV flags when multisampled.  crbug.com/656989
        bool supportsMultisampledDepthStencilSRVs =
            mRenderer11DeviceCaps.featureLevel > D3D_FEATURE_LEVEL_10_0;
        bool isMultisampledDepthStencil = bindDSV && desc.SampleDesc.Count > 1;
        if (isMultisampledDepthStencil && !supportsMultisampledDepthStencilSRVs)
        {
            bindSRV = false;
        }

        desc.BindFlags = (bindRTV ? D3D11_BIND_RENDER_TARGET : 0) |
                         (bindDSV ? D3D11_BIND_DEPTH_STENCIL : 0) |
                         (bindSRV ? D3D11_BIND_SHADER_RESOURCE : 0);

        // The format must be either an RTV or a DSV
        ASSERT(bindRTV != bindDSV);

        ID3D11Texture2D *texture = NULL;

        HRESULT result;

        // Some Nvidia drivers (GeForce GT 610 w/ 9.18.13.3523) crash with very large render targets
        if (EstimateSize(desc) > getMaxResourceSize())
        {
            result = E_OUTOFMEMORY;
        }
        else
        {
            result = mDevice->CreateTexture2D(&desc, NULL, &texture);
        }

        if (FAILED(result))
        {
            ASSERT(result == E_OUTOFMEMORY);
            return gl::Error(GL_OUT_OF_MEMORY,
                             "Failed to create render target texture, result: 0x%X.", result);
        }

        ID3D11ShaderResourceView *srv     = nullptr;
        ID3D11ShaderResourceView *blitSRV = nullptr;
        if (bindSRV)
        {
            D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
            srvDesc.Format        = formatInfo.srvFormat;
            srvDesc.ViewDimension = (supportedSamples == 0) ? D3D11_SRV_DIMENSION_TEXTURE2D
                                                            : D3D11_SRV_DIMENSION_TEXTURE2DMS;
            srvDesc.Texture2D.MostDetailedMip = 0;
            srvDesc.Texture2D.MipLevels       = 1;

            result = mDevice->CreateShaderResourceView(texture, &srvDesc, &srv);
            if (FAILED(result))
            {
                ASSERT(result == E_OUTOFMEMORY);
                SafeRelease(texture);
                return gl::Error(
                    GL_OUT_OF_MEMORY,
                    "Failed to create render target shader resource view, result: 0x%X.", result);
            }

            if (formatInfo.blitSRVFormat != formatInfo.srvFormat)
            {
                D3D11_SHADER_RESOURCE_VIEW_DESC blitSRVDesc;
                blitSRVDesc.Format        = formatInfo.blitSRVFormat;
                blitSRVDesc.ViewDimension = (supportedSamples == 0)
                                                ? D3D11_SRV_DIMENSION_TEXTURE2D
                                                : D3D11_SRV_DIMENSION_TEXTURE2DMS;
                blitSRVDesc.Texture2D.MostDetailedMip = 0;
                blitSRVDesc.Texture2D.MipLevels       = 1;

                result = mDevice->CreateShaderResourceView(texture, &blitSRVDesc, &blitSRV);
                if (FAILED(result))
                {
                    ASSERT(result == E_OUTOFMEMORY);
                    SafeRelease(texture);
                    SafeRelease(srv);
                    return gl::Error(GL_OUT_OF_MEMORY,
                                     "Failed to create render target shader resource view for "
                                     "blits, result: 0x%X.",
                                     result);
                }
            }
            else
            {
                blitSRV = srv;
                srv->AddRef();
            }
        }

        if (bindDSV)
        {
            D3D11_DEPTH_STENCIL_VIEW_DESC dsvDesc;
            dsvDesc.Format        = formatInfo.dsvFormat;
            dsvDesc.ViewDimension = (supportedSamples == 0) ? D3D11_DSV_DIMENSION_TEXTURE2D
                                                            : D3D11_DSV_DIMENSION_TEXTURE2DMS;
            dsvDesc.Texture2D.MipSlice = 0;
            dsvDesc.Flags              = 0;

            ID3D11DepthStencilView *dsv = NULL;
            result                      = mDevice->CreateDepthStencilView(texture, &dsvDesc, &dsv);
            if (FAILED(result))
            {
                ASSERT(result == E_OUTOFMEMORY);
                SafeRelease(texture);
                SafeRelease(srv);
                SafeRelease(blitSRV);
                return gl::Error(GL_OUT_OF_MEMORY,
                                 "Failed to create render target depth stencil view, result: 0x%X.",
                                 result);
            }

            *outRT = new TextureRenderTarget11(dsv, texture, srv, format, formatInfo, width, height,
                                               1, supportedSamples);

            SafeRelease(dsv);
        }
        else if (bindRTV)
        {
            D3D11_RENDER_TARGET_VIEW_DESC rtvDesc;
            rtvDesc.Format        = formatInfo.rtvFormat;
            rtvDesc.ViewDimension = (supportedSamples == 0) ? D3D11_RTV_DIMENSION_TEXTURE2D
                                                            : D3D11_RTV_DIMENSION_TEXTURE2DMS;
            rtvDesc.Texture2D.MipSlice = 0;

            ID3D11RenderTargetView *rtv = NULL;
            result                      = mDevice->CreateRenderTargetView(texture, &rtvDesc, &rtv);
            if (FAILED(result))
            {
                ASSERT(result == E_OUTOFMEMORY);
                SafeRelease(texture);
                SafeRelease(srv);
                SafeRelease(blitSRV);
                return gl::Error(GL_OUT_OF_MEMORY,
                                 "Failed to create render target render target view, result: 0x%X.",
                                 result);
            }

            if (formatInfo.dataInitializerFunction != NULL)
            {
                const float clearValues[4] = {0.0f, 0.0f, 0.0f, 1.0f};
                mDeviceContext->ClearRenderTargetView(rtv, clearValues);
            }

            *outRT = new TextureRenderTarget11(rtv, texture, srv, blitSRV, format, formatInfo,
                                               width, height, 1, supportedSamples);

            SafeRelease(rtv);
        }
        else
        {
            UNREACHABLE();
        }

        SafeRelease(texture);
        SafeRelease(srv);
        SafeRelease(blitSRV);
    }
    else
    {
        *outRT = new TextureRenderTarget11(
            static_cast<ID3D11RenderTargetView *>(nullptr), nullptr, nullptr, nullptr, format,
            d3d11::Format::Get(GL_NONE, mRenderer11DeviceCaps), width, height, 1, supportedSamples);
    }

    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::createRenderTargetCopy(RenderTargetD3D *source, RenderTargetD3D **outRT)
{
    ASSERT(source != nullptr);

    RenderTargetD3D *newRT = nullptr;
    ANGLE_TRY(createRenderTarget(source->getWidth(), source->getHeight(),
                                 source->getInternalFormat(), source->getSamples(), &newRT));

    RenderTarget11 *source11 = GetAs<RenderTarget11>(source);
    RenderTarget11 *dest11   = GetAs<RenderTarget11>(newRT);

    mDeviceContext->CopySubresourceRegion(dest11->getTexture(), dest11->getSubresourceIndex(), 0, 0,
                                          0, source11->getTexture(),
                                          source11->getSubresourceIndex(), nullptr);
    *outRT = newRT;
    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::loadExecutable(const void *function,
                                     size_t length,
                                     ShaderType type,
                                     const std::vector<D3DVarying> &streamOutVaryings,
                                     bool separatedOutputBuffers,
                                     ShaderExecutableD3D **outExecutable)
{
    switch (type)
    {
        case SHADER_VERTEX:
        {
            ID3D11VertexShader *vertexShader      = NULL;
            ID3D11GeometryShader *streamOutShader = NULL;

            HRESULT result = mDevice->CreateVertexShader(function, length, NULL, &vertexShader);
            ASSERT(SUCCEEDED(result));
            if (FAILED(result))
            {
                return gl::Error(GL_OUT_OF_MEMORY, "Failed to create vertex shader, result: 0x%X.",
                                 result);
            }

            if (!streamOutVaryings.empty())
            {
                std::vector<D3D11_SO_DECLARATION_ENTRY> soDeclaration;
                soDeclaration.reserve(streamOutVaryings.size());

                for (const auto &streamOutVarying : streamOutVaryings)
                {
                    D3D11_SO_DECLARATION_ENTRY entry = {0};
                    entry.Stream                     = 0;
                    entry.SemanticName               = streamOutVarying.semanticName.c_str();
                    entry.SemanticIndex              = streamOutVarying.semanticIndex;
                    entry.StartComponent             = 0;
                    entry.ComponentCount = static_cast<BYTE>(streamOutVarying.componentCount);
                    entry.OutputSlot     = static_cast<BYTE>(
                        (separatedOutputBuffers ? streamOutVarying.outputSlot : 0));
                    soDeclaration.push_back(entry);
                }

                result = mDevice->CreateGeometryShaderWithStreamOutput(
                    function, static_cast<unsigned int>(length), soDeclaration.data(),
                    static_cast<unsigned int>(soDeclaration.size()), NULL, 0, 0, NULL,
                    &streamOutShader);
                ASSERT(SUCCEEDED(result));
                if (FAILED(result))
                {
                    return gl::Error(GL_OUT_OF_MEMORY,
                                     "Failed to create steam output shader, result: 0x%X.", result);
                }
            }

            *outExecutable =
                new ShaderExecutable11(function, length, vertexShader, streamOutShader);
        }
        break;
        case SHADER_PIXEL:
        {
            ID3D11PixelShader *pixelShader = NULL;

            HRESULT result = mDevice->CreatePixelShader(function, length, NULL, &pixelShader);
            ASSERT(SUCCEEDED(result));
            if (FAILED(result))
            {
                return gl::Error(GL_OUT_OF_MEMORY, "Failed to create pixel shader, result: 0x%X.",
                                 result);
            }

            *outExecutable = new ShaderExecutable11(function, length, pixelShader);
        }
        break;
        case SHADER_GEOMETRY:
        {
            ID3D11GeometryShader *geometryShader = NULL;

            HRESULT result = mDevice->CreateGeometryShader(function, length, NULL, &geometryShader);
            ASSERT(SUCCEEDED(result));
            if (FAILED(result))
            {
                return gl::Error(GL_OUT_OF_MEMORY,
                                 "Failed to create geometry shader, result: 0x%X.", result);
            }

            *outExecutable = new ShaderExecutable11(function, length, geometryShader);
        }
        break;
        default:
            UNREACHABLE();
            return gl::Error(GL_INVALID_OPERATION);
    }

    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::compileToExecutable(gl::InfoLog &infoLog,
                                          const std::string &shaderHLSL,
                                          ShaderType type,
                                          const std::vector<D3DVarying> &streamOutVaryings,
                                          bool separatedOutputBuffers,
                                          const D3DCompilerWorkarounds &workarounds,
                                          ShaderExecutableD3D **outExectuable)
{
    std::stringstream profileStream;

    switch (type)
    {
        case SHADER_VERTEX:
            profileStream << "vs";
            break;
        case SHADER_PIXEL:
            profileStream << "ps";
            break;
        case SHADER_GEOMETRY:
            profileStream << "gs";
            break;
        default:
            UNREACHABLE();
            return gl::Error(GL_INVALID_OPERATION);
    }

    profileStream << "_" << getMajorShaderModel() << "_" << getMinorShaderModel()
                  << getShaderModelSuffix();
    std::string profile = profileStream.str();

    UINT flags = D3DCOMPILE_OPTIMIZATION_LEVEL2;

    if (gl::DebugAnnotationsActive())
    {
#ifndef NDEBUG
        flags = D3DCOMPILE_SKIP_OPTIMIZATION;
#endif

        flags |= D3DCOMPILE_DEBUG;
    }

    if (workarounds.enableIEEEStrictness)
        flags |= D3DCOMPILE_IEEE_STRICTNESS;

    // Sometimes D3DCompile will fail with the default compilation flags for complicated shaders
    // when it would otherwise pass with alternative options.
    // Try the default flags first and if compilation fails, try some alternatives.
    std::vector<CompileConfig> configs;
    configs.push_back(CompileConfig(flags, "default"));
    configs.push_back(CompileConfig(flags | D3DCOMPILE_SKIP_VALIDATION, "skip validation"));
    configs.push_back(CompileConfig(flags | D3DCOMPILE_SKIP_OPTIMIZATION, "skip optimization"));

    if (getMajorShaderModel() == 4 && getShaderModelSuffix() != "")
    {
        // Some shaders might cause a "blob content mismatch between level9 and d3d10 shader".
        // e.g. dEQP-GLES2.functional.shaders.struct.local.loop_nested_struct_array_*.
        // Using the [unroll] directive works around this, as does this D3DCompile flag.
        configs.push_back(
            CompileConfig(flags | D3DCOMPILE_AVOID_FLOW_CONTROL, "avoid flow control"));
    }

    D3D_SHADER_MACRO loopMacros[] = {{"ANGLE_ENABLE_LOOP_FLATTEN", "1"}, {0, 0}};

    ID3DBlob *binary = NULL;
    std::string debugInfo;
    ANGLE_TRY(mCompiler.compileToBinary(infoLog, shaderHLSL, profile, configs, loopMacros, &binary,
                                        &debugInfo));

    // It's possible that binary is NULL if the compiler failed in all configurations.  Set the
    // executable to NULL and return GL_NO_ERROR to signify that there was a link error but the
    // internal state is still OK.
    if (!binary)
    {
        *outExectuable = NULL;
        return gl::Error(GL_NO_ERROR);
    }

    gl::Error error = loadExecutable(binary->GetBufferPointer(), binary->GetBufferSize(), type,
                                     streamOutVaryings, separatedOutputBuffers, outExectuable);

    SafeRelease(binary);
    if (error.isError())
    {
        return error;
    }

    if (!debugInfo.empty())
    {
        (*outExectuable)->appendDebugInfo(debugInfo);
    }

    return gl::NoError();
}

gl::Error Renderer11::ensureHLSLCompilerInitialized()
{
    return mCompiler.ensureInitialized();
}

UniformStorageD3D *Renderer11::createUniformStorage(size_t storageSize)
{
    return new UniformStorage11(this, storageSize);
}

VertexBuffer *Renderer11::createVertexBuffer()
{
    return new VertexBuffer11(this);
}

IndexBuffer *Renderer11::createIndexBuffer()
{
    return new IndexBuffer11(this);
}

StreamProducerImpl *Renderer11::createStreamProducerD3DTextureNV12(
    egl::Stream::ConsumerType consumerType,
    const egl::AttributeMap &attribs)
{
    return new StreamProducerNV12(this);
}

bool Renderer11::supportsFastCopyBufferToTexture(GLenum internalFormat) const
{
    ASSERT(getNativeExtensions().pixelBufferObject);

    const gl::InternalFormat &internalFormatInfo = gl::GetInternalFormatInfo(internalFormat);
    const d3d11::Format &d3d11FormatInfo =
        d3d11::Format::Get(internalFormat, mRenderer11DeviceCaps);

    // sRGB formats do not work with D3D11 buffer SRVs
    if (internalFormatInfo.colorEncoding == GL_SRGB)
    {
        return false;
    }

    // We cannot support direct copies to non-color-renderable formats
    if (d3d11FormatInfo.rtvFormat == DXGI_FORMAT_UNKNOWN)
    {
        return false;
    }

    // We skip all 3-channel formats since sometimes format support is missing
    if (internalFormatInfo.componentCount == 3)
    {
        return false;
    }

    // We don't support formats which we can't represent without conversion
    if (d3d11FormatInfo.format().glInternalFormat != internalFormat)
    {
        return false;
    }

    // Buffer SRV creation for this format was not working on Windows 10.
    if (d3d11FormatInfo.texFormat == DXGI_FORMAT_B5G5R5A1_UNORM)
    {
        return false;
    }

    // This format is not supported as a buffer SRV.
    if (d3d11FormatInfo.texFormat == DXGI_FORMAT_A8_UNORM)
    {
        return false;
    }

    return true;
}

gl::Error Renderer11::fastCopyBufferToTexture(const gl::PixelUnpackState &unpack,
                                              unsigned int offset,
                                              RenderTargetD3D *destRenderTarget,
                                              GLenum destinationFormat,
                                              GLenum sourcePixelsType,
                                              const gl::Box &destArea)
{
    ASSERT(supportsFastCopyBufferToTexture(destinationFormat));
    return mPixelTransfer->copyBufferToTexture(unpack, offset, destRenderTarget, destinationFormat,
                                               sourcePixelsType, destArea);
}

ImageD3D *Renderer11::createImage()
{
    return new Image11(this);
}

gl::Error Renderer11::generateMipmap(ImageD3D *dest, ImageD3D *src)
{
    Image11 *dest11 = GetAs<Image11>(dest);
    Image11 *src11  = GetAs<Image11>(src);
    return Image11::generateMipmap(dest11, src11, mRenderer11DeviceCaps);
}

gl::Error Renderer11::generateMipmapUsingD3D(TextureStorage *storage,
                                             const gl::TextureState &textureState)
{
    TextureStorage11 *storage11 = GetAs<TextureStorage11>(storage);

    ASSERT(storage11->isRenderTarget());
    ASSERT(storage11->supportsNativeMipmapFunction());

    ID3D11ShaderResourceView *srv;
    ANGLE_TRY(storage11->getSRVLevels(textureState.getEffectiveBaseLevel(),
                                      textureState.getEffectiveMaxLevel(), &srv));

    mDeviceContext->GenerateMips(srv);

    return gl::NoError();
}

TextureStorage *Renderer11::createTextureStorage2D(SwapChainD3D *swapChain)
{
    SwapChain11 *swapChain11 = GetAs<SwapChain11>(swapChain);
    return new TextureStorage11_2D(this, swapChain11);
}

TextureStorage *Renderer11::createTextureStorageEGLImage(EGLImageD3D *eglImage,
                                                         RenderTargetD3D *renderTargetD3D)
{
    return new TextureStorage11_EGLImage(this, eglImage, GetAs<RenderTarget11>(renderTargetD3D));
}

TextureStorage *Renderer11::createTextureStorageExternal(
    egl::Stream *stream,
    const egl::Stream::GLTextureDescription &desc)
{
    return new TextureStorage11_External(this, stream, desc);
}

TextureStorage *Renderer11::createTextureStorage2D(GLenum internalformat,
                                                   bool renderTarget,
                                                   GLsizei width,
                                                   GLsizei height,
                                                   int levels,
                                                   bool hintLevelZeroOnly)
{
    return new TextureStorage11_2D(this, internalformat, renderTarget, width, height, levels,
                                   hintLevelZeroOnly);
}

TextureStorage *Renderer11::createTextureStorageCube(GLenum internalformat,
                                                     bool renderTarget,
                                                     int size,
                                                     int levels,
                                                     bool hintLevelZeroOnly)
{
    return new TextureStorage11_Cube(this, internalformat, renderTarget, size, levels,
                                     hintLevelZeroOnly);
}

TextureStorage *Renderer11::createTextureStorage3D(GLenum internalformat,
                                                   bool renderTarget,
                                                   GLsizei width,
                                                   GLsizei height,
                                                   GLsizei depth,
                                                   int levels)
{
    return new TextureStorage11_3D(this, internalformat, renderTarget, width, height, depth,
                                   levels);
}

TextureStorage *Renderer11::createTextureStorage2DArray(GLenum internalformat,
                                                        bool renderTarget,
                                                        GLsizei width,
                                                        GLsizei height,
                                                        GLsizei depth,
                                                        int levels)
{
    return new TextureStorage11_2DArray(this, internalformat, renderTarget, width, height, depth,
                                        levels);
}

gl::Error Renderer11::readFromAttachment(const gl::FramebufferAttachment &srcAttachment,
                                         const gl::Rectangle &sourceArea,
                                         GLenum format,
                                         GLenum type,
                                         GLuint outputPitch,
                                         const gl::PixelPackState &pack,
                                         uint8_t *pixelsOut)
{
    ASSERT(sourceArea.width >= 0);
    ASSERT(sourceArea.height >= 0);

    const bool invertTexture = UsePresentPathFast(this, &srcAttachment);

    RenderTargetD3D *renderTarget = nullptr;
    ANGLE_TRY(srcAttachment.getRenderTarget(&renderTarget));

    RenderTarget11 *rt11 = GetAs<RenderTarget11>(renderTarget);
    ASSERT(rt11->getTexture());

    TextureHelper11 textureHelper =
        TextureHelper11::MakeAndReference(rt11->getTexture(), rt11->getFormatSet());
    unsigned int sourceSubResource = rt11->getSubresourceIndex();

    const gl::Extents &texSize = textureHelper.getExtents();

    gl::Rectangle actualArea = sourceArea;
    if (invertTexture)
    {
        actualArea.y = texSize.height - actualArea.y - actualArea.height;
    }

    // Clamp read region to the defined texture boundaries, preventing out of bounds reads
    // and reads of uninitialized data.
    gl::Rectangle safeArea;
    safeArea.x = gl::clamp(actualArea.x, 0, texSize.width);
    safeArea.y = gl::clamp(actualArea.y, 0, texSize.height);
    safeArea.width =
        gl::clamp(actualArea.width + std::min(actualArea.x, 0), 0, texSize.width - safeArea.x);
    safeArea.height =
        gl::clamp(actualArea.height + std::min(actualArea.y, 0), 0, texSize.height - safeArea.y);

    ASSERT(safeArea.x >= 0 && safeArea.y >= 0);
    ASSERT(safeArea.x + safeArea.width <= texSize.width);
    ASSERT(safeArea.y + safeArea.height <= texSize.height);

    if (safeArea.width == 0 || safeArea.height == 0)
    {
        // no work to do
        return gl::NoError();
    }

    gl::Extents safeSize(safeArea.width, safeArea.height, 1);
    TextureHelper11 stagingHelper;
    ANGLE_TRY_RESULT(
        CreateStagingTexture(textureHelper.getTextureType(), textureHelper.getFormatSet(), safeSize,
                             StagingAccess::READ, mDevice),
        stagingHelper);

    TextureHelper11 resolvedTextureHelper;

    // "srcTexture" usually points to the source texture.
    // For 2D multisampled textures, it points to the multisampled resolve texture.
    const TextureHelper11 *srcTexture = &textureHelper;

    if (textureHelper.getTextureType() == GL_TEXTURE_2D && textureHelper.getSampleCount() > 1)
    {
        D3D11_TEXTURE2D_DESC resolveDesc;
        resolveDesc.Width              = static_cast<UINT>(texSize.width);
        resolveDesc.Height             = static_cast<UINT>(texSize.height);
        resolveDesc.MipLevels          = 1;
        resolveDesc.ArraySize          = 1;
        resolveDesc.Format             = textureHelper.getFormat();
        resolveDesc.SampleDesc.Count   = 1;
        resolveDesc.SampleDesc.Quality = 0;
        resolveDesc.Usage              = D3D11_USAGE_DEFAULT;
        resolveDesc.BindFlags          = 0;
        resolveDesc.CPUAccessFlags     = 0;
        resolveDesc.MiscFlags          = 0;

        ID3D11Texture2D *resolveTex2D = nullptr;
        HRESULT result = mDevice->CreateTexture2D(&resolveDesc, nullptr, &resolveTex2D);
        if (FAILED(result))
        {
            return gl::Error(GL_OUT_OF_MEMORY,
                             "Renderer11::readTextureData failed to create internal resolve "
                             "texture for ReadPixels, HRESULT: 0x%X.",
                             result);
        }

        mDeviceContext->ResolveSubresource(resolveTex2D, 0, textureHelper.getTexture2D(),
                                           sourceSubResource, textureHelper.getFormat());
        resolvedTextureHelper =
            TextureHelper11::MakeAndReference(resolveTex2D, textureHelper.getFormatSet());

        sourceSubResource = 0;
        srcTexture        = &resolvedTextureHelper;
    }

    D3D11_BOX srcBox;
    srcBox.left   = static_cast<UINT>(safeArea.x);
    srcBox.right  = static_cast<UINT>(safeArea.x + safeArea.width);
    srcBox.top    = static_cast<UINT>(safeArea.y);
    srcBox.bottom = static_cast<UINT>(safeArea.y + safeArea.height);

    // Select the correct layer from a 3D attachment
    srcBox.front = 0;
    if (textureHelper.getTextureType() == GL_TEXTURE_3D)
    {
        srcBox.front = static_cast<UINT>(srcAttachment.layer());
    }
    srcBox.back = srcBox.front + 1;

    mDeviceContext->CopySubresourceRegion(stagingHelper.getResource(), 0, 0, 0, 0,
                                          srcTexture->getResource(), sourceSubResource, &srcBox);

    if (!invertTexture)
    {
        PackPixelsParams packParams(safeArea, format, type, outputPitch, pack, 0);
        return packPixels(stagingHelper, packParams, pixelsOut);
    }

    gl::PixelPackState invertTexturePack;

    // Create a new PixelPackState with reversed row order. Note that we can't just assign
    // 'invertTexturePack' to be 'pack' (or memcpy) since that breaks the ref counting/object
    // tracking in the 'pixelBuffer' members, causing leaks. Instead we must use
    // pixelBuffer.set() twice, which performs the addRef/release correctly
    invertTexturePack.alignment = pack.alignment;
    invertTexturePack.pixelBuffer.set(pack.pixelBuffer.get());
    invertTexturePack.reverseRowOrder = !pack.reverseRowOrder;

    PackPixelsParams packParams(safeArea, format, type, outputPitch, invertTexturePack, 0);
    gl::Error error = packPixels(stagingHelper, packParams, pixelsOut);
    invertTexturePack.pixelBuffer.set(nullptr);
    ANGLE_TRY(error);
    return gl::NoError();
}

gl::Error Renderer11::packPixels(const TextureHelper11 &textureHelper,
                                 const PackPixelsParams &params,
                                 uint8_t *pixelsOut)
{
    ID3D11Resource *readResource = textureHelper.getResource();

    D3D11_MAPPED_SUBRESOURCE mapping;
    HRESULT hr = mDeviceContext->Map(readResource, 0, D3D11_MAP_READ, 0, &mapping);
    if (FAILED(hr))
    {
        ASSERT(hr == E_OUTOFMEMORY);
        return gl::Error(GL_OUT_OF_MEMORY,
                         "Failed to map internal texture for reading, result: 0x%X.", hr);
    }

    uint8_t *source = static_cast<uint8_t *>(mapping.pData);
    int inputPitch  = static_cast<int>(mapping.RowPitch);

    const auto &formatInfo = textureHelper.getFormatSet();
    ASSERT(formatInfo.format().glInternalFormat != GL_NONE);

    PackPixels(params, formatInfo.format(), inputPitch, source, pixelsOut);

    mDeviceContext->Unmap(readResource, 0);

    return gl::Error(GL_NO_ERROR);
}

gl::Error Renderer11::blitRenderbufferRect(const gl::Rectangle &readRectIn,
                                           const gl::Rectangle &drawRectIn,
                                           RenderTargetD3D *readRenderTarget,
                                           RenderTargetD3D *drawRenderTarget,
                                           GLenum filter,
                                           const gl::Rectangle *scissor,
                                           bool colorBlit,
                                           bool depthBlit,
                                           bool stencilBlit)
{
    // Since blitRenderbufferRect is called for each render buffer that needs to be blitted,
    // it should never be the case that both color and depth/stencil need to be blitted at
    // at the same time.
    ASSERT(colorBlit != (depthBlit || stencilBlit));

    RenderTarget11 *drawRenderTarget11 = GetAs<RenderTarget11>(drawRenderTarget);
    if (!drawRenderTarget11)
    {
        return gl::Error(
            GL_OUT_OF_MEMORY,
            "Failed to retrieve the internal draw render target from the draw framebuffer.");
    }

    TextureHelper11 drawTexture = TextureHelper11::MakeAndReference(
        drawRenderTarget11->getTexture(), drawRenderTarget11->getFormatSet());
    unsigned int drawSubresource    = drawRenderTarget11->getSubresourceIndex();
    ID3D11RenderTargetView *drawRTV = drawRenderTarget11->getRenderTargetView();
    ID3D11DepthStencilView *drawDSV = drawRenderTarget11->getDepthStencilView();

    RenderTarget11 *readRenderTarget11 = GetAs<RenderTarget11>(readRenderTarget);
    if (!readRenderTarget11)
    {
        return gl::Error(
            GL_OUT_OF_MEMORY,
            "Failed to retrieve the internal read render target from the read framebuffer.");
    }

    TextureHelper11 readTexture;
    unsigned int readSubresource      = 0;
    ID3D11ShaderResourceView *readSRV = nullptr;

    if (readRenderTarget->getSamples() > 1)
    {
        auto readRT11 = GetAs<RenderTarget11>(readRenderTarget);
        ANGLE_TRY_RESULT(resolveMultisampledTexture(readRT11, depthBlit, stencilBlit), readTexture);

        if (!stencilBlit)
        {
            const auto &readFormatSet = readTexture.getFormatSet();

            D3D11_SHADER_RESOURCE_VIEW_DESC viewDesc;
            viewDesc.Format                    = readFormatSet.srvFormat;
            viewDesc.ViewDimension             = D3D11_SRV_DIMENSION_TEXTURE2D;
            viewDesc.Texture2D.MipLevels       = 1;
            viewDesc.Texture2D.MostDetailedMip = 0;

            HRESULT hresult =
                mDevice->CreateShaderResourceView(readTexture.getResource(), &viewDesc, &readSRV);
            if (FAILED(hresult))
            {
                return gl::Error(
                    GL_OUT_OF_MEMORY,
                    "Renderer11::blitRenderbufferRect: Failed to create temporary SRV.");
            }
        }
    }
    else
    {
        ASSERT(readRenderTarget11);
        readTexture = TextureHelper11::MakeAndReference(readRenderTarget11->getTexture(),
                                                        readRenderTarget11->getFormatSet());
        readSubresource = readRenderTarget11->getSubresourceIndex();
        readSRV         = readRenderTarget11->getBlitShaderResourceView();
        if (readSRV == nullptr)
        {
            ASSERT(depthBlit || stencilBlit);
            readSRV = readRenderTarget11->getShaderResourceView();
        }
        ASSERT(readSRV);
        readSRV->AddRef();
    }

    // Stencil blits don't use shaders.
    ASSERT(readSRV || stencilBlit);

    const gl::Extents readSize(readRenderTarget->getWidth(), readRenderTarget->getHeight(), 1);
    const gl::Extents drawSize(drawRenderTarget->getWidth(), drawRenderTarget->getHeight(), 1);

    // From the spec:
    // "The actual region taken from the read framebuffer is limited to the intersection of the
    // source buffers being transferred, which may include the color buffer selected by the read
    // buffer, the depth buffer, and / or the stencil buffer depending on mask."
    // This means negative x and y are out of bounds, and not to be read from. We handle this here
    // by internally scaling the read and draw rectangles.
    gl::Rectangle readRect = readRectIn;
    gl::Rectangle drawRect = drawRectIn;
    auto readToDrawX       = [&drawRectIn, &readRectIn](int readOffset) {
        double readToDrawScale =
            static_cast<double>(drawRectIn.width) / static_cast<double>(readRectIn.width);
        return static_cast<int>(round(static_cast<double>(readOffset) * readToDrawScale));
    };
    if (readRect.x < 0)
    {
        int readOffset = -readRect.x;
        readRect.x += readOffset;
        readRect.width -= readOffset;

        int drawOffset = readToDrawX(readOffset);
        drawRect.x += drawOffset;
        drawRect.width -= drawOffset;
    }

    auto readToDrawY = [&drawRectIn, &readRectIn](int readOffset) {
        double readToDrawScale =
            static_cast<double>(drawRectIn.height) / static_cast<double>(readRectIn.height);
        return static_cast<int>(round(static_cast<double>(readOffset) * readToDrawScale));
    };
    if (readRect.y < 0)
    {
        int readOffset = -readRect.y;
        readRect.y += readOffset;
        readRect.height -= readOffset;

        int drawOffset = readToDrawY(readOffset);
        drawRect.y += drawOffset;
        drawRect.height -= drawOffset;
    }

    if (readRect.x1() < 0)
    {
        int readOffset = -readRect.x1();
        readRect.width += readOffset;

        int drawOffset = readToDrawX(readOffset);
        drawRect.width += drawOffset;
    }

    if (readRect.y1() < 0)
    {
        int readOffset = -readRect.y1();
        readRect.height += readOffset;

        int drawOffset = readToDrawY(readOffset);
        drawRect.height += drawOffset;
    }

    bool scissorNeeded = scissor && gl::ClipRectangle(drawRect, *scissor, nullptr);

    const auto &destFormatInfo = gl::GetInternalFormatInfo(drawRenderTarget->getInternalFormat());
    const auto &srcFormatInfo  = gl::GetInternalFormatInfo(readRenderTarget->getInternalFormat());
    const auto &formatSet      = drawRenderTarget11->getFormatSet();
    const auto &nativeFormat   = formatSet.format();

    // Some blits require masking off emulated texture channels. eg: from RGBA8 to RGB8, we
    // emulate RGB8 with RGBA8, so we need to mask off the alpha channel when we copy.

    gl::Color<bool> colorMask;
    colorMask.red =
        (srcFormatInfo.redBits > 0) && (destFormatInfo.redBits == 0) && (nativeFormat.redBits > 0);
    colorMask.green = (srcFormatInfo.greenBits > 0) && (destFormatInfo.greenBits == 0) &&
                      (nativeFormat.greenBits > 0);
    colorMask.blue = (srcFormatInfo.blueBits > 0) && (destFormatInfo.blueBits == 0) &&
                     (nativeFormat.blueBits > 0);
    colorMask.alpha = (srcFormatInfo.alphaBits > 0) && (destFormatInfo.alphaBits == 0) &&
                      (nativeFormat.alphaBits > 0);

    // We only currently support masking off the alpha channel.
    bool colorMaskingNeeded = colorMask.alpha;
    ASSERT(!colorMask.red && !colorMask.green && !colorMask.blue);

    bool wholeBufferCopy = !scissorNeeded && !colorMaskingNeeded && readRect.x == 0 &&
                           readRect.width == readSize.width && readRect.y == 0 &&
                           readRect.height == readSize.height && drawRect.x == 0 &&
                           drawRect.width == drawSize.width && drawRect.y == 0 &&
                           drawRect.height == drawSize.height;

    bool stretchRequired = readRect.width != drawRect.width || readRect.height != drawRect.height;

    bool flipRequired =
        readRect.width < 0 || readRect.height < 0 || drawRect.width < 0 || drawRect.height < 0;

    bool outOfBounds = readRect.x < 0 || readRect.x + readRect.width > readSize.width ||
                       readRect.y < 0 || readRect.y + readRect.height > readSize.height ||
                       drawRect.x < 0 || drawRect.x + drawRect.width > drawSize.width ||
                       drawRect.y < 0 || drawRect.y + drawRect.height > drawSize.height;

    bool partialDSBlit =
        (nativeFormat.depthBits > 0 && depthBlit) != (nativeFormat.stencilBits > 0 && stencilBlit);

    if (readRenderTarget11->getFormatSet().formatID ==
            drawRenderTarget11->getFormatSet().formatID &&
        !stretchRequired && !outOfBounds && !flipRequired && !partialDSBlit &&
        !colorMaskingNeeded && (!(depthBlit || stencilBlit) || wholeBufferCopy))
    {
        UINT dstX = drawRect.x;
        UINT dstY = drawRect.y;

        D3D11_BOX readBox;
        readBox.left   = readRect.x;
        readBox.right  = readRect.x + readRect.width;
        readBox.top    = readRect.y;
        readBox.bottom = readRect.y + readRect.height;
        readBox.front  = 0;
        readBox.back   = 1;

        if (scissorNeeded)
        {
            // drawRect is guaranteed to have positive width and height because stretchRequired is
            // false.
            ASSERT(drawRect.width >= 0 || drawRect.height >= 0);

            if (drawRect.x < scissor->x)
            {
                dstX = scissor->x;
                readBox.left += (scissor->x - drawRect.x);
            }
            if (drawRect.y < scissor->y)
            {
                dstY = scissor->y;
                readBox.top += (scissor->y - drawRect.y);
            }
            if (drawRect.x + drawRect.width > scissor->x + scissor->width)
            {
                readBox.right -= ((drawRect.x + drawRect.width) - (scissor->x + scissor->width));
            }
            if (drawRect.y + drawRect.height > scissor->y + scissor->height)
            {
                readBox.bottom -= ((drawRect.y + drawRect.height) - (scissor->y + scissor->height));
            }
        }

        // D3D11 needs depth-stencil CopySubresourceRegions to have a NULL pSrcBox
        // We also require complete framebuffer copies for depth-stencil blit.
        D3D11_BOX *pSrcBox = wholeBufferCopy ? nullptr : &readBox;

        mDeviceContext->CopySubresourceRegion(drawTexture.getResource(), drawSubresource, dstX,
                                              dstY, 0, readTexture.getResource(), readSubresource,
                                              pSrcBox);
    }
    else
    {
        gl::Box readArea(readRect.x, readRect.y, 0, readRect.width, readRect.height, 1);
        gl::Box drawArea(drawRect.x, drawRect.y, 0, drawRect.width, drawRect.height, 1);

        if (depthBlit && stencilBlit)
        {
            ANGLE_TRY(mBlit->copyDepthStencil(readTexture, readSubresource, readArea, readSize,
                                              drawTexture, drawSubresource, drawArea, drawSize,
                                              scissor));
        }
        else if (depthBlit)
        {
            ASSERT(readSRV);
            ANGLE_TRY(mBlit->copyDepth(readSRV, readArea, readSize, drawDSV, drawArea, drawSize,
                                       scissor));
        }
        else if (stencilBlit)
        {
            ANGLE_TRY(mBlit->copyStencil(readTexture, readSubresource, readArea, readSize,
                                         drawTexture, drawSubresource, drawArea, drawSize,
                                         scissor));
        }
        else
        {
            // We don't currently support masking off any other channel than alpha
            bool maskOffAlpha = colorMaskingNeeded && colorMask.alpha;
            ASSERT(readSRV);
            ANGLE_TRY(mBlit->copyTexture(readSRV, readArea, readSize, drawRTV, drawArea, drawSize,
                                         scissor, destFormatInfo.format, filter, maskOffAlpha,
                                         false, false));
        }
    }

    SafeRelease(readSRV);

    return gl::NoError();
}

bool Renderer11::isES3Capable() const
{
    return (d3d11_gl::GetMaximumClientVersion(mRenderer11DeviceCaps.featureLevel).major > 2);
};

void Renderer11::onSwap()
{
    // Send histogram updates every half hour
    const double kHistogramUpdateInterval = 30 * 60;

    const double currentTime         = ANGLEPlatformCurrent()->monotonicallyIncreasingTime();
    const double timeSinceLastUpdate = currentTime - mLastHistogramUpdateTime;

    if (timeSinceLastUpdate > kHistogramUpdateInterval)
    {
        updateHistograms();
        mLastHistogramUpdateTime = currentTime;
    }
}

void Renderer11::updateHistograms()
{
    // Update the buffer CPU memory histogram
    {
        size_t sizeSum = 0;
        for (auto &buffer : mAliveBuffers)
        {
            sizeSum += buffer->getTotalCPUBufferMemoryBytes();
        }
        const int kOneMegaByte = 1024 * 1024;
        ANGLE_HISTOGRAM_MEMORY_MB("GPU.ANGLE.Buffer11CPUMemoryMB",
                                  static_cast<int>(sizeSum) / kOneMegaByte);
    }
}

void Renderer11::onBufferCreate(const Buffer11 *created)
{
    mAliveBuffers.insert(created);
}

void Renderer11::onBufferDelete(const Buffer11 *deleted)
{
    mAliveBuffers.erase(deleted);
}

gl::ErrorOrResult<TextureHelper11>
Renderer11::resolveMultisampledTexture(RenderTarget11 *renderTarget, bool depth, bool stencil)
{
    if (depth && !stencil)
    {
        return mBlit->resolveDepth(renderTarget);
    }

    if (stencil)
    {
        return mBlit->resolveStencil(renderTarget, depth);
    }

    const auto &formatSet = renderTarget->getFormatSet();

    ASSERT(renderTarget->getSamples() > 1);

    D3D11_TEXTURE2D_DESC resolveDesc;
    resolveDesc.Width              = renderTarget->getWidth();
    resolveDesc.Height             = renderTarget->getHeight();
    resolveDesc.MipLevels          = 1;
    resolveDesc.ArraySize          = 1;
    resolveDesc.Format             = formatSet.texFormat;
    resolveDesc.SampleDesc.Count   = 1;
    resolveDesc.SampleDesc.Quality = 0;
    resolveDesc.Usage              = D3D11_USAGE_DEFAULT;
    resolveDesc.BindFlags          = D3D11_BIND_SHADER_RESOURCE;
    resolveDesc.CPUAccessFlags     = 0;
    resolveDesc.MiscFlags          = 0;

    ID3D11Texture2D *resolveTexture = nullptr;
    HRESULT result = mDevice->CreateTexture2D(&resolveDesc, nullptr, &resolveTexture);
    if (FAILED(result))
    {
        return gl::Error(GL_OUT_OF_MEMORY,
                         "Failed to create a multisample resolve texture, HRESULT: 0x%X.", result);
    }

    mDeviceContext->ResolveSubresource(resolveTexture, 0, renderTarget->getTexture(),
                                       renderTarget->getSubresourceIndex(), formatSet.texFormat);
    return TextureHelper11::MakeAndPossess2D(resolveTexture, renderTarget->getFormatSet());
}

bool Renderer11::getLUID(LUID *adapterLuid) const
{
    adapterLuid->HighPart = 0;
    adapterLuid->LowPart  = 0;

    if (!mDxgiAdapter)
    {
        return false;
    }

    DXGI_ADAPTER_DESC adapterDesc;
    if (FAILED(mDxgiAdapter->GetDesc(&adapterDesc)))
    {
        return false;
    }

    *adapterLuid = adapterDesc.AdapterLuid;
    return true;
}

VertexConversionType Renderer11::getVertexConversionType(
    gl::VertexFormatType vertexFormatType) const
{
    return d3d11::GetVertexFormatInfo(vertexFormatType, mRenderer11DeviceCaps.featureLevel)
        .conversionType;
}

GLenum Renderer11::getVertexComponentType(gl::VertexFormatType vertexFormatType) const
{
    const auto &format =
        d3d11::GetVertexFormatInfo(vertexFormatType, mRenderer11DeviceCaps.featureLevel);
    return d3d11::GetComponentType(format.nativeFormat);
}

gl::ErrorOrResult<unsigned int> Renderer11::getVertexSpaceRequired(
    const gl::VertexAttribute &attrib,
    GLsizei count,
    GLsizei instances) const
{
    if (!attrib.enabled)
    {
        return 16u;
    }

    unsigned int elementCount = 0;
    if (instances == 0 || attrib.divisor == 0)
    {
        elementCount = count;
    }
    else
    {
        // Round up to divisor, if possible
        elementCount = UnsignedCeilDivide(static_cast<unsigned int>(instances), attrib.divisor);
    }

    gl::VertexFormatType formatType      = gl::GetVertexFormatType(attrib);
    const D3D_FEATURE_LEVEL featureLevel = mRenderer11DeviceCaps.featureLevel;
    const d3d11::VertexFormat &vertexFormatInfo =
        d3d11::GetVertexFormatInfo(formatType, featureLevel);
    const d3d11::DXGIFormatSize &dxgiFormatInfo =
        d3d11::GetDXGIFormatSizeInfo(vertexFormatInfo.nativeFormat);
    unsigned int elementSize = dxgiFormatInfo.pixelBytes;
    if (elementSize > std::numeric_limits<unsigned int>::max() / elementCount)
    {
        return gl::Error(GL_OUT_OF_MEMORY, "New vertex buffer size would result in an overflow.");
    }

    return elementSize * elementCount;
}

void Renderer11::generateCaps(gl::Caps *outCaps,
                              gl::TextureCapsMap *outTextureCaps,
                              gl::Extensions *outExtensions,
                              gl::Limitations *outLimitations) const
{
    d3d11_gl::GenerateCaps(mDevice, mDeviceContext, mRenderer11DeviceCaps, outCaps, outTextureCaps,
                           outExtensions, outLimitations);
}

WorkaroundsD3D Renderer11::generateWorkarounds() const
{
    return d3d11::GenerateWorkarounds(mRenderer11DeviceCaps, mAdapterDescription);
}

gl::Error Renderer11::clearTextures(gl::SamplerType samplerType, size_t rangeStart, size_t rangeEnd)
{
    return mStateManager.clearTextures(samplerType, rangeStart, rangeEnd);
}

egl::Error Renderer11::getEGLDevice(DeviceImpl **device)
{
    if (mEGLDevice == nullptr)
    {
        ASSERT(mDevice != nullptr);
        mEGLDevice       = new DeviceD3D();
        egl::Error error = mEGLDevice->initialize(reinterpret_cast<void *>(mDevice),
                                                  EGL_D3D11_DEVICE_ANGLE, EGL_FALSE);

        if (error.isError())
        {
            SafeDelete(mEGLDevice);
            return error;
        }
    }

    *device = static_cast<DeviceImpl *>(mEGLDevice);
    return egl::Error(EGL_SUCCESS);
}

ContextImpl *Renderer11::createContext(const gl::ContextState &state)
{
    return new Context11(state, this);
}

gl::Error Renderer11::genericDrawElements(Context11 *context,
                                          GLenum mode,
                                          GLsizei count,
                                          GLenum type,
                                          const GLvoid *indices,
                                          GLsizei instances,
                                          const gl::IndexRange &indexRange)
{
    const auto &data     = context->getContextState();
    const auto &glState  = data.getState();
    gl::Program *program = glState.getProgram();
    ASSERT(program != nullptr);
    ProgramD3D *programD3D = GetImplAs<ProgramD3D>(program);
    bool usesPointSize     = programD3D->usesPointSize();

    programD3D->updateSamplerMapping();

    ANGLE_TRY(generateSwizzles(data));

    if (!applyPrimitiveType(mode, count, usesPointSize))
    {
        return gl::NoError();
    }

    ANGLE_TRY(updateState(data, mode));

    TranslatedIndexData indexInfo;
    indexInfo.indexRange = indexRange;

    ANGLE_TRY(applyIndexBuffer(data, indices, count, mode, type, &indexInfo));

    applyTransformFeedbackBuffers(data);
    // Transform feedback is not allowed for DrawElements, this error should have been caught at the
    // API validation layer.
    ASSERT(!glState.isTransformFeedbackActiveUnpaused());

    size_t vertexCount = indexInfo.indexRange.vertexCount();
    ANGLE_TRY(applyVertexBuffer(glState, mode, static_cast<GLsizei>(indexInfo.indexRange.start),
                                static_cast<GLsizei>(vertexCount), instances, &indexInfo));
    ANGLE_TRY(applyTextures(context, data));
    ANGLE_TRY(applyShaders(data, mode));
    ANGLE_TRY(programD3D->applyUniformBuffers(data));

    if (!skipDraw(data, mode))
    {
        ANGLE_TRY(drawElementsImpl(data, indexInfo, mode, count, type, indices, instances));
    }

    return gl::NoError();
}

gl::Error Renderer11::genericDrawArrays(Context11 *context,
                                        GLenum mode,
                                        GLint first,
                                        GLsizei count,
                                        GLsizei instances)
{
    const auto &data     = context->getContextState();
    const auto &glState  = data.getState();
    gl::Program *program = glState.getProgram();
    ASSERT(program != nullptr);
    ProgramD3D *programD3D = GetImplAs<ProgramD3D>(program);
    bool usesPointSize     = programD3D->usesPointSize();

    programD3D->updateSamplerMapping();

    ANGLE_TRY(generateSwizzles(data));
    if (!applyPrimitiveType(mode, count, usesPointSize))
    {
        return gl::NoError();
    }

    ANGLE_TRY(updateState(data, mode));
    ANGLE_TRY(applyTransformFeedbackBuffers(data));
    ANGLE_TRY(applyVertexBuffer(glState, mode, first, count, instances, nullptr));
    ANGLE_TRY(applyTextures(context, data));
    ANGLE_TRY(applyShaders(data, mode));
    ANGLE_TRY(programD3D->applyUniformBuffers(data));

    if (!skipDraw(data, mode))
    {
        ANGLE_TRY(drawArraysImpl(data, mode, first, count, instances));

        if (glState.isTransformFeedbackActiveUnpaused())
        {
            ANGLE_TRY(markTransformFeedbackUsage(data));
        }
    }

    return gl::NoError();
}

FramebufferImpl *Renderer11::createDefaultFramebuffer(const gl::FramebufferState &state)
{
    return new Framebuffer11(state, this);
}

gl::Error Renderer11::getScratchMemoryBuffer(size_t requestedSize, MemoryBuffer **bufferOut)
{
    if (mScratchMemoryBuffer.size() == requestedSize)
    {
        mScratchMemoryBufferResetCounter = ScratchMemoryBufferLifetime;
        *bufferOut                       = &mScratchMemoryBuffer;
        return gl::NoError();
    }

    if (mScratchMemoryBuffer.size() > requestedSize)
    {
        mScratchMemoryBufferResetCounter--;
    }

    if (mScratchMemoryBufferResetCounter <= 0 || mScratchMemoryBuffer.size() < requestedSize)
    {
        mScratchMemoryBuffer.resize(0);
        if (!mScratchMemoryBuffer.resize(requestedSize))
        {
            return gl::Error(GL_OUT_OF_MEMORY, "Failed to allocate internal buffer.");
        }
        mScratchMemoryBufferResetCounter = ScratchMemoryBufferLifetime;
    }

    ASSERT(mScratchMemoryBuffer.size() >= requestedSize);

    *bufferOut = &mScratchMemoryBuffer;
    return gl::NoError();
}

gl::Version Renderer11::getMaxSupportedESVersion() const
{
    return d3d11_gl::GetMaximumClientVersion(mRenderer11DeviceCaps.featureLevel);
}

gl::DebugAnnotator *Renderer11::getAnnotator()
{
    return mAnnotator;
}

}  // namespace rx
