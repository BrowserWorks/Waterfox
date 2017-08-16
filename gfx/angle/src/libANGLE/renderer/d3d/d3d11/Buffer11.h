//
// Copyright 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Buffer11.h: Defines the rx::Buffer11 class which implements rx::BufferImpl via rx::BufferD3D.

#ifndef LIBANGLE_RENDERER_D3D_D3D11_BUFFER11_H_
#define LIBANGLE_RENDERER_D3D_D3D11_BUFFER11_H_

#include <array>
#include <map>

#include "libANGLE/angletypes.h"
#include "libANGLE/renderer/d3d/BufferD3D.h"
#include "libANGLE/signal_utils.h"

namespace gl
{
class FramebufferAttachment;
}

namespace rx
{
struct PackPixelsParams;
class Renderer11;
struct SourceIndexData;
struct TranslatedAttribute;

// The order of this enum governs priority of 'getLatestBufferStorage'.
enum BufferUsage
{
    BUFFER_USAGE_SYSTEM_MEMORY,
    BUFFER_USAGE_STAGING,
    BUFFER_USAGE_VERTEX_OR_TRANSFORM_FEEDBACK,
    BUFFER_USAGE_INDEX,
    BUFFER_USAGE_PIXEL_UNPACK,
    BUFFER_USAGE_PIXEL_PACK,
    BUFFER_USAGE_UNIFORM,
    BUFFER_USAGE_EMULATED_INDEXED_VERTEX,

    BUFFER_USAGE_COUNT,
};

typedef size_t DataRevision;

class Buffer11 : public BufferD3D
{
  public:
    Buffer11(const gl::BufferState &state, Renderer11 *renderer);
    virtual ~Buffer11();

    gl::ErrorOrResult<ID3D11Buffer *> getBuffer(BufferUsage usage);
    gl::ErrorOrResult<ID3D11Buffer *> getEmulatedIndexedBuffer(SourceIndexData *indexInfo,
                                                               const TranslatedAttribute &attribute,
                                                               GLint startVertex);
    gl::Error getConstantBufferRange(GLintptr offset,
                                     GLsizeiptr size,
                                     ID3D11Buffer **bufferOut,
                                     UINT *firstConstantOut,
                                     UINT *numConstantsOut);
    gl::ErrorOrResult<ID3D11ShaderResourceView *> getSRV(DXGI_FORMAT srvFormat);
    bool isMapped() const { return mMappedStorage != nullptr; }
    gl::Error packPixels(const gl::FramebufferAttachment &readAttachment,
                         const PackPixelsParams &params);
    size_t getTotalCPUBufferMemoryBytes() const;

    // BufferD3D implementation
    size_t getSize() const override { return mSize; }
    bool supportsDirectBinding() const override;
    gl::Error getData(const uint8_t **outData) override;
    void initializeStaticData() override;
    void invalidateStaticData() override;

    // BufferImpl implementation
    gl::Error setData(GLenum target, const void *data, size_t size, GLenum usage) override;
    gl::Error setSubData(GLenum target, const void *data, size_t size, size_t offset) override;
    gl::Error copySubData(BufferImpl *source,
                          GLintptr sourceOffset,
                          GLintptr destOffset,
                          GLsizeiptr size) override;
    gl::Error map(GLenum access, GLvoid **mapPtr) override;
    gl::Error mapRange(size_t offset, size_t length, GLbitfield access, GLvoid **mapPtr) override;
    gl::Error unmap(GLboolean *result) override;
    gl::Error markTransformFeedbackUsage() override;

    // We use two set of dirty events. Static buffers are marked dirty whenever
    // data changes, because they must be re-translated. Direct buffers only need to be
    // updated when the underlying ID3D11Buffer pointer changes - hopefully far less often.
    angle::BroadcastChannel *getStaticBroadcastChannel();
    angle::BroadcastChannel *getDirectBroadcastChannel();

  private:
    class BufferStorage;
    class EmulatedIndexedStorage;
    class NativeStorage;
    class PackStorage;
    class SystemMemoryStorage;

    struct ConstantBufferCacheEntry
    {
        ConstantBufferCacheEntry() : storage(nullptr), lruCount(0) { }

        BufferStorage *storage;
        unsigned int lruCount;
    };

    gl::Error markBufferUsage(BufferUsage usage);
    gl::ErrorOrResult<NativeStorage *> getStagingStorage();
    gl::ErrorOrResult<PackStorage *> getPackStorage();
    gl::ErrorOrResult<SystemMemoryStorage *> getSystemMemoryStorage();

    gl::Error updateBufferStorage(BufferStorage *storage, size_t sourceOffset, size_t storageSize);
    gl::ErrorOrResult<BufferStorage *> getBufferStorage(BufferUsage usage);
    gl::ErrorOrResult<BufferStorage *> getLatestBufferStorage() const;

    gl::ErrorOrResult<BufferStorage *> getConstantBufferRangeStorage(GLintptr offset,
                                                                     GLsizeiptr size);

    BufferStorage *allocateStorage(BufferUsage usage);
    void updateDeallocThreshold(BufferUsage usage);

    // Free the storage if we decide it isn't being used very often.
    gl::Error checkForDeallocation(BufferUsage usage);

    // For some cases of uniform buffer storage, we can't deallocate system memory storage.
    bool canDeallocateSystemMemory() const;

    Renderer11 *mRenderer;
    size_t mSize;

    BufferStorage *mMappedStorage;

    std::array<BufferStorage *, BUFFER_USAGE_COUNT> mBufferStorages;

    // These two arrays are used to track when to free unused storage.
    std::array<unsigned int, BUFFER_USAGE_COUNT> mDeallocThresholds;
    std::array<unsigned int, BUFFER_USAGE_COUNT> mIdleness;

    // Cache of D3D11 constant buffer for specific ranges of buffer data.
    // This is used to emulate UBO ranges on 11.0 devices.
    // Constant buffers are indexed by there start offset.
    typedef std::map<GLintptr /*offset*/, ConstantBufferCacheEntry> ConstantBufferCache;
    ConstantBufferCache mConstantBufferRangeStoragesCache;
    size_t mConstantBufferStorageAdditionalSize;
    unsigned int mMaxConstantBufferLruCount;

    angle::BroadcastChannel mStaticBroadcastChannel;
    angle::BroadcastChannel mDirectBroadcastChannel;
};

}  // namespace rx

#endif // LIBANGLE_RENDERER_D3D_D3D11_BUFFER11_H_
