/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebGPUParent.h"
#include "mozilla/webgpu/ffi/wgpu.h"
#include "mozilla/layers/ImageDataSerializer.h"
#include "mozilla/layers/TextureHost.h"

namespace mozilla {
namespace webgpu {

const uint64_t POLL_TIME_MS = 100;

class PresentationData {
  NS_INLINE_DECL_REFCOUNTING(PresentationData);

 public:
  RawId mDeviceId = 0;
  RawId mQueueId = 0;
  RefPtr<layers::MemoryTextureHost> mTextureHost;
  uint32_t mSourcePitch = 0;
  uint32_t mTargetPitch = 0;
  uint32_t mRowCount = 0;
  std::vector<RawId> mUnassignedBufferIds;
  std::vector<RawId> mAvailableBufferIds;
  std::vector<RawId> mQueuedBufferIds;
  Mutex mBuffersLock;

  PresentationData() : mBuffersLock("WebGPU presentation buffers") {
    MOZ_COUNT_CTOR(PresentationData);
  }

 private:
  ~PresentationData() { MOZ_COUNT_DTOR(PresentationData); }
};

static void FreeAdapter(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeAdapter(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeDevice(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeDevice(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeSwapChain(RawId id, void* param) {
  Unused << id;
  Unused << param;
}
static void FreePipelineLayout(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreePipelineLayout(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeShaderModule(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeShaderModule(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeBindGroupLayout(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeBindGroupLayout(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeBindGroup(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeBindGroup(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeCommandBuffer(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeCommandBuffer(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeRenderPipeline(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeRenderPipeline(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeComputePipeline(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeComputePipeline(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeBuffer(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeBuffer(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeTexture(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeTexture(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeTextureView(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeTextureView(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeSampler(RawId id, void* param) {
  if (!static_cast<WebGPUParent*>(param)->SendFreeSampler(id)) {
    MOZ_CRASH("IPC failure");
  }
}
static void FreeSurface(RawId id, void* param) {
  Unused << id;
  Unused << param;
}

static ffi::WGPUIdentityRecyclerFactory MakeFactory(void* param) {
  // Note: careful about the order here!
  const ffi::WGPUIdentityRecyclerFactory factory = {
      param,
      FreeAdapter,
      FreeDevice,
      FreeSwapChain,
      FreePipelineLayout,
      FreeShaderModule,
      FreeBindGroupLayout,
      FreeBindGroup,
      FreeCommandBuffer,
      FreeRenderPipeline,
      FreeComputePipeline,
      FreeBuffer,
      FreeTexture,
      FreeTextureView,
      FreeSampler,
      FreeSurface,
  };
  return factory;
}

WebGPUParent::WebGPUParent()
    : mContext(ffi::wgpu_server_new(MakeFactory(this))) {
  mTimer.Start(base::TimeDelta::FromMilliseconds(POLL_TIME_MS), this,
               &WebGPUParent::MaintainDevices);
}

WebGPUParent::~WebGPUParent() = default;

void WebGPUParent::MaintainDevices() {
  ffi::wgpu_server_poll_all_devices(mContext, false);
}

ipc::IPCResult WebGPUParent::RecvInstanceRequestAdapter(
    const dom::GPURequestAdapterOptions& aOptions,
    const nsTArray<RawId>& aTargetIds,
    InstanceRequestAdapterResolver&& resolver) {
  ffi::WGPURequestAdapterOptions options = {};
  if (aOptions.mPowerPreference.WasPassed()) {
    options.power_preference = static_cast<ffi::WGPUPowerPreference>(
        aOptions.mPowerPreference.Value());
  }
  // TODO: make available backends configurable by prefs

  int8_t index = ffi::wgpu_server_instance_request_adapter(
      mContext, &options, aTargetIds.Elements(), aTargetIds.Length());
  if (index >= 0) {
    resolver(aTargetIds[index]);
  } else {
    resolver(0);
  }

  // free the unused IDs
  for (size_t i = 0; i < aTargetIds.Length(); ++i) {
    if (static_cast<int8_t>(i) != index && !SendFreeAdapter(aTargetIds[i])) {
      MOZ_CRASH("IPC failure");
    }
  }
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvAdapterRequestDevice(
    RawId aSelfId, const dom::GPUDeviceDescriptor& aDesc, RawId aNewId) {
  ffi::WGPUDeviceDescriptor desc = {};
  desc.limits.max_bind_groups = aDesc.mLimits.WasPassed()
                                    ? aDesc.mLimits.Value().mMaxBindGroups
                                    : WGPUDEFAULT_BIND_GROUPS;
  // TODO: fill up the descriptor
  ffi::wgpu_server_adapter_request_device(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvAdapterDestroy(RawId aSelfId) {
  ffi::wgpu_server_adapter_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceDestroy(RawId aSelfId) {
  ffi::wgpu_server_device_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateBuffer(
    RawId aSelfId, const ffi::WGPUBufferDescriptor& aDesc,
    const nsCString& aLabel, RawId aNewId) {
  ffi::WGPUBufferDescriptor desc = aDesc;
  if (!aLabel.IsEmpty()) {
    desc.label = aLabel.Data();
  }
  ffi::wgpu_server_device_create_buffer(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceUnmapBuffer(RawId aSelfId,
                                                   RawId aBufferId,
                                                   Shmem&& aShmem,
                                                   bool aFlush) {
  if (aFlush) {
    ffi::wgpu_server_device_set_buffer_sub_data(mContext, aSelfId, aBufferId, 0,
                                                aShmem.get<uint8_t>(),
                                                aShmem.Size<uint8_t>());
  } else {
    ffi::wgpu_server_buffer_unmap(mContext, aBufferId);
  }
  DeallocShmem(aShmem);
  return IPC_OK();
}

struct MapReadRequest {
  ipc::Shmem mShmem;
  WebGPUParent::BufferMapReadResolver mResolver;
  MapReadRequest(ipc::Shmem&& shmem,
                 WebGPUParent::BufferMapReadResolver&& resolver)
      : mShmem(shmem), mResolver(resolver) {}
};

static void MapReadCallback(ffi::WGPUBufferMapAsyncStatus status,
                            const uint8_t* ptr, uint8_t* userdata) {
  auto req = reinterpret_cast<MapReadRequest*>(userdata);
  // TODO: better handle errors
  MOZ_ASSERT(status == ffi::WGPUBufferMapAsyncStatus_Success);
  memcpy(req->mShmem.get<uint8_t>(), ptr, req->mShmem.Size<uint8_t>());
  req->mResolver(std::move(req->mShmem));
  delete req;
}

ipc::IPCResult WebGPUParent::RecvBufferMapRead(
    RawId aSelfId, Shmem&& aShmem, BufferMapReadResolver&& aResolver) {
  auto size = aShmem.Size<uint8_t>();
  auto request = new MapReadRequest(std::move(aShmem), std::move(aResolver));
  ffi::wgpu_server_buffer_map_read(mContext, aSelfId, 0, size, &MapReadCallback,
                                   reinterpret_cast<uint8_t*>(request));
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvBufferDestroy(RawId aSelfId) {
  ffi::wgpu_server_buffer_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateTexture(
    RawId aSelfId, const ffi::WGPUTextureDescriptor& aDesc,
    const nsCString& aLabel, RawId aNewId) {
  ffi::WGPUTextureDescriptor desc = aDesc;
  if (!aLabel.IsEmpty()) {
    desc.label = aLabel.Data();
  }
  ffi::wgpu_server_device_create_texture(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvTextureCreateView(
    RawId aSelfId, const ffi::WGPUTextureViewDescriptor& aDesc,
    const nsCString& aLabel, RawId aNewId) {
  ffi::WGPUTextureViewDescriptor desc = aDesc;
  if (!aLabel.IsEmpty()) {
    desc.label = aLabel.Data();
  }
  ffi::wgpu_server_texture_create_view(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvTextureDestroy(RawId aSelfId) {
  ffi::wgpu_server_texture_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvTextureViewDestroy(RawId aSelfId) {
  ffi::wgpu_server_texture_view_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateSampler(
    RawId aSelfId, const ffi::WGPUSamplerDescriptor& aDesc,
    const nsCString& aLabel, RawId aNewId) {
  ffi::WGPUSamplerDescriptor desc = aDesc;
  if (!aLabel.IsEmpty()) {
    desc.label = aLabel.Data();
  }
  ffi::wgpu_server_device_create_sampler(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvSamplerDestroy(RawId aSelfId) {
  ffi::wgpu_server_sampler_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateCommandEncoder(
    RawId aSelfId, const dom::GPUCommandEncoderDescriptor& aDesc,
    RawId aNewId) {
  ffi::WGPUCommandEncoderDescriptor desc = {};
  if (aDesc.mLabel.WasPassed()) {
    // TODO: desc.label = aDesc.mLabel.Value();
  }
  ffi::wgpu_server_device_create_encoder(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderCopyBufferToBuffer(
    RawId aSelfId, RawId aSourceId, BufferAddress aSourceOffset,
    RawId aDestinationId, BufferAddress aDestinationOffset,
    BufferAddress aSize) {
  ffi::wgpu_server_encoder_copy_buffer_to_buffer(mContext, aSelfId, aSourceId,
                                                 aSourceOffset, aDestinationId,
                                                 aDestinationOffset, aSize);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderCopyBufferToTexture(
    RawId aSelfId, WGPUBufferCopyView aSource, WGPUTextureCopyView aDestination,
    WGPUExtent3d aCopySize) {
  ffi::wgpu_server_encoder_copy_buffer_to_texture(mContext, aSelfId, &aSource,
                                                  &aDestination, aCopySize);
  return IPC_OK();
}
ipc::IPCResult WebGPUParent::RecvCommandEncoderCopyTextureToBuffer(
    RawId aSelfId, WGPUTextureCopyView aSource, WGPUBufferCopyView aDestination,
    WGPUExtent3d aCopySize) {
  ffi::wgpu_server_encoder_copy_texture_to_buffer(mContext, aSelfId, &aSource,
                                                  &aDestination, aCopySize);
  return IPC_OK();
}
ipc::IPCResult WebGPUParent::RecvCommandEncoderCopyTextureToTexture(
    RawId aSelfId, WGPUTextureCopyView aSource,
    WGPUTextureCopyView aDestination, WGPUExtent3d aCopySize) {
  ffi::wgpu_server_encoder_copy_texture_to_texture(mContext, aSelfId, &aSource,
                                                   &aDestination, aCopySize);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderRunComputePass(RawId aSelfId,
                                                              Shmem&& aShmem) {
  ffi::wgpu_server_encode_compute_pass(mContext, aSelfId, aShmem.get<uint8_t>(),
                                       aShmem.Size<uint8_t>());
  DeallocShmem(aShmem);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderRunRenderPass(RawId aSelfId,
                                                             Shmem&& aShmem) {
  ffi::wgpu_server_encode_render_pass(mContext, aSelfId, aShmem.get<uint8_t>(),
                                      aShmem.Size<uint8_t>());
  DeallocShmem(aShmem);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderFinish(
    RawId aSelfId, const dom::GPUCommandBufferDescriptor& aDesc) {
  Unused << aDesc;
  ffi::WGPUCommandBufferDescriptor desc = {};
  ffi::wgpu_server_encoder_finish(mContext, aSelfId, &desc);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandEncoderDestroy(RawId aSelfId) {
  ffi::wgpu_server_encoder_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvCommandBufferDestroy(RawId aSelfId) {
  ffi::wgpu_server_command_buffer_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvQueueSubmit(
    RawId aSelfId, const nsTArray<RawId>& aCommandBuffers) {
  ffi::wgpu_server_queue_submit(mContext, aSelfId, aCommandBuffers.Elements(),
                                aCommandBuffers.Length());
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateBindGroupLayout(
    RawId aSelfId, const SerialBindGroupLayoutDescriptor& aDesc, RawId aNewId) {
  ffi::WGPUBindGroupLayoutDescriptor desc = {};
  desc.entries = aDesc.mEntries.Elements();
  desc.entries_length = aDesc.mEntries.Length();
  ffi::wgpu_server_device_create_bind_group_layout(mContext, aSelfId, &desc,
                                                   aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvBindGroupLayoutDestroy(RawId aSelfId) {
  ffi::wgpu_server_bind_group_layout_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreatePipelineLayout(
    RawId aSelfId, const SerialPipelineLayoutDescriptor& aDesc, RawId aNewId) {
  ffi::WGPUPipelineLayoutDescriptor desc = {};
  desc.bind_group_layouts = aDesc.mBindGroupLayouts.Elements();
  desc.bind_group_layouts_length = aDesc.mBindGroupLayouts.Length();
  ffi::wgpu_server_device_create_pipeline_layout(mContext, aSelfId, &desc,
                                                 aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvPipelineLayoutDestroy(RawId aSelfId) {
  ffi::wgpu_server_pipeline_layout_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateBindGroup(
    RawId aSelfId, const SerialBindGroupDescriptor& aDesc, RawId aNewId) {
  nsTArray<ffi::WGPUBindGroupEntry> ffiEntries(aDesc.mEntries.Length());
  for (const auto& entry : aDesc.mEntries) {
    ffi::WGPUBindGroupEntry bgb = {};
    bgb.binding = entry.mBinding;
    switch (entry.mType) {
      case SerialBindGroupEntryType::Buffer:
        bgb.resource.tag = ffi::WGPUBindingResource_Buffer;
        bgb.resource.buffer = {entry.mValue, entry.mBufferOffset, entry.mBufferSize};
        break;
      case SerialBindGroupEntryType::Texture:
        bgb.resource.tag = ffi::WGPUBindingResource_TextureView;
        bgb.resource.texture_view = {entry.mValue};
        break;
      case SerialBindGroupEntryType::Sampler:
        bgb.resource.tag = ffi::WGPUBindingResource_Sampler;
        bgb.resource.sampler = {entry.mValue};
        break;
      default:
        MOZ_CRASH("unreachable");
    }
    ffiEntries.AppendElement(bgb);
  }
  ffi::WGPUBindGroupDescriptor desc = {};
  desc.layout = aDesc.mLayout;
  desc.entries = ffiEntries.Elements();
  desc.entries_length = ffiEntries.Length();
  ffi::wgpu_server_device_create_bind_group(mContext, aSelfId, &desc, aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvBindGroupDestroy(RawId aSelfId) {
  ffi::wgpu_server_bind_group_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateShaderModule(
    RawId aSelfId, const nsTArray<uint32_t>& aData, RawId aNewId) {
  ffi::WGPUShaderModuleDescriptor desc = {};
  desc.code.bytes = aData.Elements();
  desc.code.length = aData.Length();
  ffi::wgpu_server_device_create_shader_module(mContext, aSelfId, &desc,
                                               aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvShaderModuleDestroy(RawId aSelfId) {
  ffi::wgpu_server_shader_module_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateComputePipeline(
    RawId aSelfId, const SerialComputePipelineDescriptor& aDesc, RawId aNewId) {
  const NS_LossyConvertUTF16toASCII entryPoint(aDesc.mComputeStage.mEntryPoint);
  ffi::WGPUComputePipelineDescriptor desc = {};
  desc.layout = aDesc.mLayout;
  desc.compute_stage.module = aDesc.mComputeStage.mModule;
  desc.compute_stage.entry_point = entryPoint.get();
  ffi::wgpu_server_device_create_compute_pipeline(mContext, aSelfId, &desc,
                                                  aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvComputePipelineDestroy(RawId aSelfId) {
  ffi::wgpu_server_compute_pipeline_destroy(mContext, aSelfId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateRenderPipeline(
    RawId aSelfId, const SerialRenderPipelineDescriptor& aDesc, RawId aNewId) {
  const NS_LossyConvertUTF16toASCII vsEntryPoint(
      aDesc.mVertexStage.mEntryPoint);
  const NS_LossyConvertUTF16toASCII fsEntryPoint(
      aDesc.mFragmentStage.mEntryPoint);
  nsTArray<ffi::WGPUVertexBufferLayoutDescriptor> vertexBuffers(
      aDesc.mVertexState.mVertexBuffers.Length());

  ffi::WGPURenderPipelineDescriptor desc = {};
  ffi::WGPUProgrammableStageDescriptor fragmentDesc = {};
  desc.layout = aDesc.mLayout;
  desc.vertex_stage.module = aDesc.mVertexStage.mModule;
  desc.vertex_stage.entry_point = vsEntryPoint.get();
  if (aDesc.mFragmentStage.mModule != 0) {
    fragmentDesc.module = aDesc.mFragmentStage.mModule;
    fragmentDesc.entry_point = fsEntryPoint.get();
    desc.fragment_stage = &fragmentDesc;
  }
  desc.primitive_topology = aDesc.mPrimitiveTopology;
  if (aDesc.mRasterizationState.isSome()) {
    desc.rasterization_state = aDesc.mRasterizationState.ptr();
  }
  desc.color_states = aDesc.mColorStates.Elements();
  desc.color_states_length = aDesc.mColorStates.Length();
  if (aDesc.mDepthStencilState.isSome()) {
    desc.depth_stencil_state = aDesc.mDepthStencilState.ptr();
  }
  for (const auto& vertexBuffer : aDesc.mVertexState.mVertexBuffers) {
    ffi::WGPUVertexBufferLayoutDescriptor vb = {};
    vb.array_stride = vertexBuffer.mArrayStride;
    vb.step_mode = vertexBuffer.mStepMode;
    vb.attributes = vertexBuffer.mAttributes.Elements();
    vb.attributes_length = vertexBuffer.mAttributes.Length();
    vertexBuffers.AppendElement(vb);
  }
  desc.vertex_state.index_format = aDesc.mVertexState.mIndexFormat;
  desc.vertex_state.vertex_buffers = vertexBuffers.Elements();
  desc.vertex_state.vertex_buffers_length = vertexBuffers.Length();
  desc.sample_count = aDesc.mSampleCount;
  desc.sample_mask = aDesc.mSampleMask;
  desc.alpha_to_coverage_enabled = aDesc.mAlphaToCoverageEnabled;
  ffi::wgpu_server_device_create_render_pipeline(mContext, aSelfId, &desc,
                                                 aNewId);
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvRenderPipelineDestroy(RawId aSelfId) {
  ffi::wgpu_server_render_pipeline_destroy(mContext, aSelfId);
  return IPC_OK();
}

// TODO: proper destruction
static const uint64_t kBufferAlignment = 0x100;

static uint64_t Align(uint64_t value) {
  return (value | (kBufferAlignment - 1)) + 1;
}

ipc::IPCResult WebGPUParent::RecvDeviceCreateSwapChain(
    RawId aSelfId, RawId aQueueId, const RGBDescriptor& aDesc,
    const nsTArray<RawId>& aBufferIds, ExternalImageId aExternalId) {
  const auto rows = aDesc.size().height;
  const auto bufferStride =
      Align(static_cast<uint64_t>(aDesc.size().width) * 4);
  const auto textureStride = layers::ImageDataSerializer::GetRGBStride(aDesc);
  const auto wholeBufferSize = CheckedInt<size_t>(textureStride) * rows;
  if (!wholeBufferSize.isValid()) {
    NS_ERROR("Invalid total buffer size!");
    return IPC_OK();
  }
  auto textureHostData = new (fallible) uint8_t[wholeBufferSize.value()];
  if (!textureHostData) {
    NS_ERROR("Unable to allocate host data!");
    return IPC_OK();
  }
  auto textureHost = new layers::MemoryTextureHost(
      textureHostData, aDesc, layers::TextureFlags::NO_FLAGS);
  textureHost->CreateRenderTexture(aExternalId);
  nsTArray<RawId> bufferIds(aBufferIds.Clone());
  RefPtr<PresentationData> data = new PresentationData();
  data->mDeviceId = aSelfId;
  data->mQueueId = aQueueId;
  data->mTextureHost = textureHost;
  data->mSourcePitch = bufferStride;
  data->mTargetPitch = textureStride;
  data->mRowCount = rows;
  for (const RawId id : bufferIds) {
    data->mUnassignedBufferIds.push_back(id);
  }
  if (!mCanvasMap.insert({AsUint64(aExternalId), data}).second) {
    NS_ERROR("External image is already registered as WebGPU canvas!");
  }
  return IPC_OK();
}

static void PresentCallback(ffi::WGPUBufferMapAsyncStatus status,
                            const uint8_t* ptr, uint8_t* userdata) {
  auto data = reinterpret_cast<PresentationData*>(userdata);
  if (status == ffi::WGPUBufferMapAsyncStatus_Success) {
    uint8_t* dst = data->mTextureHost->GetBuffer();
    for (uint32_t row = 0; row < data->mRowCount; ++row) {
      memcpy(dst, ptr, data->mTargetPitch);
      dst += data->mTargetPitch;
      ptr += data->mSourcePitch;
    }
  } else {
    // TODO: better handle errors
    NS_WARNING("WebGPU frame mapping failed!");
  }
  data->mBuffersLock.Lock();
  RawId bufferId = data->mQueuedBufferIds.back();
  data->mQueuedBufferIds.pop_back();
  data->mAvailableBufferIds.push_back(bufferId);
  data->mBuffersLock.Unlock();
  // We artificially did `AddRef` before calling `wgpu_server_buffer_map_read`.
  // Now we can let it go again.
  data->Release();
}

ipc::IPCResult WebGPUParent::RecvSwapChainPresent(
    wr::ExternalImageId aExternalId, RawId aTextureId,
    RawId aCommandEncoderId) {
  // step 0: get the data associated with the swapchain
  const auto& lookup = mCanvasMap.find(AsUint64(aExternalId));
  if (lookup == mCanvasMap.end()) {
    NS_WARNING("WebGPU presenting on a destroyed swap chain!");
    return IPC_OK();
  }
  RefPtr<PresentationData> data = lookup->second.get();
  RawId bufferId = 0;
  const auto& size = data->mTextureHost->GetSize();
  const auto bufferSize = data->mRowCount * data->mSourcePitch;

  // step 1: find an available staging buffer, or create one
  data->mBuffersLock.Lock();
  if (!data->mAvailableBufferIds.empty()) {
    bufferId = data->mAvailableBufferIds.back();
    wgpu_server_buffer_unmap(mContext, bufferId);
    data->mAvailableBufferIds.pop_back();
  } else if (!data->mUnassignedBufferIds.empty()) {
    bufferId = data->mUnassignedBufferIds.back();
    data->mUnassignedBufferIds.pop_back();

    ffi::WGPUBufferUsage usage =
        WGPUBufferUsage_COPY_DST | WGPUBufferUsage_MAP_READ;
    ffi::WGPUBufferDescriptor desc = {};
    desc.size = bufferSize;
    desc.usage = usage;
    ffi::wgpu_server_device_create_buffer(mContext, data->mDeviceId, &desc,
                                          bufferId);
  } else {
    bufferId = 0;
  }
  if (bufferId) {
    data->mQueuedBufferIds.insert(data->mQueuedBufferIds.begin(), bufferId);
  }
  data->mBuffersLock.Unlock();
  if (!bufferId) {
    // TODO: add a warning - no buffer are available!
    return IPC_OK();
  }

  // step 3: submit a copy command for the frame
  ffi::WGPUCommandEncoderDescriptor encoderDesc = {};
  ffi::wgpu_server_device_create_encoder(mContext, data->mDeviceId,
                                         &encoderDesc, aCommandEncoderId);
  const ffi::WGPUTextureCopyView texView = {
      aTextureId,
  };
  const ffi::WGPUBufferCopyView bufView = {
      bufferId,
      0,
      data->mSourcePitch,
      0,
  };
  const ffi::WGPUExtent3d extent = {
      static_cast<uint32_t>(size.width),
      static_cast<uint32_t>(size.height),
      1,
  };
  ffi::wgpu_server_encoder_copy_texture_to_buffer(mContext, aCommandEncoderId,
                                                  &texView, &bufView, extent);
  ffi::WGPUCommandBufferDescriptor commandDesc = {};
  ffi::wgpu_server_encoder_finish(mContext, aCommandEncoderId, &commandDesc);
  ffi::wgpu_server_queue_submit(mContext, data->mQueueId, &aCommandEncoderId,
                                1);

  // step 4: request the pixels to be copied into the external texture
  // TODO: this isn't strictly necessary. When WR wants to Lock() the external
  // texture,
  // we can just give it the contents of the last mapped buffer instead of the
  // copy.
  // This `AddRef` is needed for passing `data` as a raw pointer to
  // `wgpu_server_buffer_map_read` to serve as `userdata`. It's released at
  // the end of `PresentCallback` body.
  const auto userData = do_AddRef(data).take();
  ffi::wgpu_server_buffer_map_read(mContext, bufferId, 0, bufferSize,
                                   &PresentCallback,
                                   reinterpret_cast<uint8_t*>(userData));

  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvSwapChainDestroy(
    wr::ExternalImageId aExternalId) {
  const auto& lookup = mCanvasMap.find(AsUint64(aExternalId));
  MOZ_ASSERT(lookup != mCanvasMap.end());
  RefPtr<PresentationData> data = lookup->second.get();
  mCanvasMap.erase(AsUint64(aExternalId));
  data->mTextureHost = nullptr;
  layers::TextureHost::DestroyRenderTexture(aExternalId);

  data->mBuffersLock.Lock();
  for (const auto bid : data->mUnassignedBufferIds) {
    if (!SendFreeBuffer(bid)) {
      NS_WARNING("Unable to free an ID for non-assigned buffer");
    }
  }
  for (const auto bid : data->mAvailableBufferIds) {
    ffi::wgpu_server_buffer_destroy(mContext, bid);
  }
  for (const auto bid : data->mQueuedBufferIds) {
    ffi::wgpu_server_buffer_destroy(mContext, bid);
  }
  data->mBuffersLock.Unlock();
  return IPC_OK();
}

ipc::IPCResult WebGPUParent::RecvShutdown() {
  mTimer.Stop();
  for (const auto& p : mCanvasMap) {
    const wr::ExternalImageId extId = {p.first};
    layers::TextureHost::DestroyRenderTexture(extId);
  }
  mCanvasMap.clear();
  ffi::wgpu_server_poll_all_devices(mContext, true);
  ffi::wgpu_server_delete(const_cast<ffi::WGPUGlobal*>(mContext));
  return IPC_OK();
}

}  // namespace webgpu
}  // namespace mozilla
