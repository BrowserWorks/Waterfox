/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use crate::{
    cow_label, wgpu_string, AdapterInformation, ByteBuf, CommandEncoderAction, DeviceAction,
    FfiSlice, QueueWriteAction, RawString, TexelCopyBufferLayout, TextureAction,
};

use crate::{BufferMapResult, Message, QueueWriteDataSource, ServerMessage, SwapChainId};

use wgc::naga::front::wgsl::ImplementedLanguageExtension;
use wgc::{command::RenderBundleEncoder, id, identity::IdentityManager};
use wgt::{
    error::WebGpuError, BufferAddress, DynamicOffset, IndexFormat, TextureFormat,
};

use wgc::id::markers;

use parking_lot::Mutex;

use nsstring::{nsACString, nsCString, nsString};

use std::array;
use std::fmt::Write;
use std::{borrow::Cow, ptr};

use self::render_pass::{
    FfiOption, FfiRenderPassColorAttachment, RenderPassDepthStencilAttachment,
};

pub mod render_pass;

#[repr(C)]
pub struct ConstantEntry {
    key: RawString,
    value: f64,
}

#[repr(C)]
pub struct ProgrammableStageDescriptor<'a> {
    module: id::ShaderModuleId,
    entry_point: RawString,
    constants: FfiSlice<'a, ConstantEntry>,
}

impl ProgrammableStageDescriptor<'_> {
    fn to_wgpu(&self) -> wgc::pipeline::ProgrammableStageDescriptor<'_> {
        let constants = unsafe { self.constants.as_slice() }
            .iter()
            .map(|ce| {
                (
                    unsafe { std::ffi::CStr::from_ptr(ce.key) }
                        .to_str()
                        .unwrap()
                        .to_string(),
                    ce.value,
                )
            })
            .collect();
        wgc::pipeline::ProgrammableStageDescriptor {
            module: self.module,
            entry_point: cow_label(&self.entry_point),
            constants,
            zero_initialize_workgroup_memory: true,
        }
    }
}

#[repr(C)]
pub struct ComputePipelineDescriptor<'a> {
    label: Option<&'a nsACString>,
    layout: Option<id::PipelineLayoutId>,
    stage: ProgrammableStageDescriptor<'a>,
}

#[repr(C)]
pub struct VertexBufferLayout<'a> {
    array_stride: wgt::BufferAddress,
    step_mode: wgt::VertexStepMode,
    attributes: FfiSlice<'a, wgt::VertexAttribute>,
}

#[repr(C)]
pub struct VertexState<'a> {
    stage: ProgrammableStageDescriptor<'a>,
    buffers: FfiSlice<'a, FfiOption<VertexBufferLayout<'a>>>,
}

impl VertexState<'_> {
    fn to_wgpu(&self) -> wgc::pipeline::VertexState<'_> {
        let buffer_layouts = unsafe { self.buffers.as_slice() }
            .iter()
            .map(|vb| {
                vb.as_ref().map(|vb| wgc::pipeline::VertexBufferLayout {
                    array_stride: vb.array_stride,
                    step_mode: vb.step_mode,
                    attributes: Cow::Borrowed(unsafe { vb.attributes.as_slice() }),
                })
            })
            .collect();
        wgc::pipeline::VertexState {
            stage: self.stage.to_wgpu(),
            buffers: Cow::Owned(buffer_layouts),
        }
    }
}

#[repr(C)]
pub struct ColorTargetState {
    format: wgt::TextureFormat,
    blend: FfiOption<wgt::BlendState>,
    write_mask: wgt::ColorWrites,
}

#[repr(C)]
pub struct FragmentState<'a> {
    stage: ProgrammableStageDescriptor<'a>,
    targets: FfiSlice<'a, FfiOption<ColorTargetState>>,
}

impl FragmentState<'_> {
    fn to_wgpu(&self) -> wgc::pipeline::FragmentState<'_> {
        let color_targets = unsafe { self.targets.as_slice() }
            .iter()
            .map(|ct_opt| {
                ct_opt.as_ref().map(|ct| wgt::ColorTargetState {
                    format: ct.format,
                    blend: ct.blend.to_std(),
                    write_mask: ct.write_mask,
                })
            })
            .collect();
        wgc::pipeline::FragmentState {
            stage: self.stage.to_wgpu(),
            targets: Cow::Owned(color_targets),
        }
    }
}

#[repr(C)]
pub struct PrimitiveState<'a> {
    topology: wgt::PrimitiveTopology,
    strip_index_format: Option<&'a wgt::IndexFormat>,
    front_face: wgt::FrontFace,
    cull_mode: Option<&'a wgt::Face>,
    polygon_mode: wgt::PolygonMode,
    unclipped_depth: bool,
}

impl PrimitiveState<'_> {
    fn to_wgpu(&self) -> wgt::PrimitiveState {
        wgt::PrimitiveState {
            topology: self.topology,
            strip_index_format: self.strip_index_format.cloned(),
            front_face: self.front_face.clone(),
            cull_mode: self.cull_mode.cloned(),
            polygon_mode: self.polygon_mode,
            unclipped_depth: self.unclipped_depth,
            conservative: false,
        }
    }
}

#[repr(C)]
pub struct DepthStencilState {
    format: wgt::TextureFormat,
    depth_write_enabled: FfiOption<bool>,
    depth_compare: FfiOption<wgt::CompareFunction>,
    stencil: wgt::StencilState,
    bias: wgt::DepthBiasState,
}

impl DepthStencilState {
    fn to_wgpu(&self) -> wgt::DepthStencilState {
        wgt::DepthStencilState {
            format: self.format,
            depth_write_enabled: self.depth_write_enabled.to_std(),
            depth_compare: self.depth_compare.to_std(),
            stencil: self.stencil.clone(),
            bias: self.bias,
        }
    }
}

#[repr(C)]
pub struct RenderPipelineDescriptor<'a> {
    label: Option<&'a nsACString>,
    layout: Option<id::PipelineLayoutId>,
    vertex: &'a VertexState<'a>,
    primitive: PrimitiveState<'a>,
    fragment: Option<&'a FragmentState<'a>>,
    depth_stencil: Option<&'a DepthStencilState>,
    multisample: wgt::MultisampleState,
}

#[repr(C)]
pub enum RawTextureSampleType {
    Float,
    UnfilterableFloat,
    Uint,
    Sint,
    Depth,
}

#[repr(C)]
pub enum RawBindingType {
    UniformBuffer,
    StorageBuffer,
    ReadonlyStorageBuffer,
    Sampler,
    SampledTexture,
    ReadonlyStorageTexture,
    WriteonlyStorageTexture,
    ReadWriteStorageTexture,
    ExternalTexture,
    Error,
}

/// A [`BindGroupLayoutEntry::error_case`], specified when [`BindGroupLayoutEntry::ty`] is set to
/// [`RawBindingType::Error`].
#[derive(Clone, Copy)]
#[repr(C)]
pub enum BindingTypeError {
    NoneSpecified,
    MultipleSpecified,
}

/// An FFI-friendly representation of a [`wgt::BindGroupLayoutEntry`].
///
/// This is implemented using a "poor person's tagged union". Most fields are expected to be set
/// only with a specific variant of [`Self::ty`], but all are present at all times.
#[repr(C)]
pub struct BindGroupLayoutEntry<'a> {
    binding: u32,
    visibility: wgt::ShaderStages,
    ty: RawBindingType,
    has_dynamic_offset: bool,
    min_binding_size: Option<wgt::BufferSize>,
    view_dimension: Option<&'a wgt::TextureViewDimension>,
    texture_sample_type: Option<&'a RawTextureSampleType>,
    multisampled: bool,
    storage_texture_format: Option<&'a wgt::TextureFormat>,
    sampler_filter: bool,
    sampler_compare: bool,
    /// The error case, for when [`Self::ty`] is set to [`RawBindingType::Error`].
    error_case: BindingTypeError,
}

#[repr(C)]
pub struct BindGroupLayoutDescriptor<'a> {
    label: Option<&'a nsACString>,
    entries: FfiSlice<'a, BindGroupLayoutEntry<'a>>,
}

#[repr(C)]
#[derive(Debug)]
pub struct BindGroupEntry {
    binding: u32,
    buffer: Option<id::BufferId>,
    offset: wgt::BufferAddress,

    // In `wgpu_core::binding_model::BufferBinding`, these are an
    // `Option<BufferAddress>`. But since `BufferAddress` can be zero, that is
    // not a type that cbindgen can express in C++, so we use this pair of
    // values instead.
    size_passed: bool,
    size: wgt::BufferAddress,

    sampler: Option<id::SamplerId>,
    texture_view: Option<id::TextureViewId>,
    external_texture: Option<id::ExternalTextureId>,
}

#[repr(C)]
pub struct BindGroupDescriptor<'a> {
    label: Option<&'a nsACString>,
    layout: id::BindGroupLayoutId,
    entries: FfiSlice<'a, BindGroupEntry>,
}

#[repr(C)]
pub struct PipelineLayoutDescriptor<'a> {
    label: Option<&'a nsACString>,
    bind_group_layouts: FfiSlice<'a, Option<id::BindGroupLayoutId>>,
}

#[repr(C)]
pub struct SamplerDescriptor<'a> {
    label: Option<&'a nsACString>,
    address_modes: [wgt::AddressMode; 3],
    mag_filter: wgt::FilterMode,
    min_filter: wgt::FilterMode,
    mipmap_filter: wgt::MipmapFilterMode,
    lod_min_clamp: f32,
    lod_max_clamp: f32,
    compare: Option<&'a wgt::CompareFunction>,
    max_anisotropy: u16,
}

#[repr(C)]
pub struct RenderBundleEncoderDescriptor<'a> {
    label: Option<&'a nsACString>,
    color_formats: FfiSlice<'a, FfiOption<wgt::TextureFormat>>,
    depth_stencil_format: Option<&'a wgt::TextureFormat>,
    depth_read_only: bool,
    stencil_read_only: bool,
    sample_count: u32,
}

#[derive(Debug)]
struct IdentityHub {
    adapters: IdentityManager<markers::Adapter>,
    devices: IdentityManager<markers::Device>,
    queues: IdentityManager<markers::Queue>,
    buffers: IdentityManager<markers::Buffer>,
    command_encoders: IdentityManager<markers::CommandEncoder>,
    render_pass_encoders: IdentityManager<markers::RenderPassEncoder>,
    compute_pass_encoders: IdentityManager<markers::ComputePassEncoder>,
    render_bundle_encoders: IdentityManager<markers::RenderBundleEncoder>,
    command_buffers: IdentityManager<markers::CommandBuffer>,
    render_bundles: IdentityManager<markers::RenderBundle>,
    bind_group_layouts: IdentityManager<markers::BindGroupLayout>,
    pipeline_layouts: IdentityManager<markers::PipelineLayout>,
    bind_groups: IdentityManager<markers::BindGroup>,
    shader_modules: IdentityManager<markers::ShaderModule>,
    compute_pipelines: IdentityManager<markers::ComputePipeline>,
    render_pipelines: IdentityManager<markers::RenderPipeline>,
    textures: IdentityManager<markers::Texture>,
    texture_views: IdentityManager<markers::TextureView>,
    external_texture_sources: IdentityManager<crate::ExternalTextureSource>,
    external_textures: IdentityManager<markers::ExternalTexture>,
    samplers: IdentityManager<markers::Sampler>,
    query_sets: IdentityManager<markers::QuerySet>,
}

impl Default for IdentityHub {
    fn default() -> Self {
        IdentityHub {
            adapters: IdentityManager::new(),
            devices: IdentityManager::new(),
            queues: IdentityManager::new(),
            buffers: IdentityManager::new(),
            command_encoders: IdentityManager::new(),
            render_pass_encoders: IdentityManager::new(),
            compute_pass_encoders: IdentityManager::new(),
            render_bundle_encoders: IdentityManager::new(),
            command_buffers: IdentityManager::new(),
            render_bundles: IdentityManager::new(),
            bind_group_layouts: IdentityManager::new(),
            pipeline_layouts: IdentityManager::new(),
            bind_groups: IdentityManager::new(),
            shader_modules: IdentityManager::new(),
            compute_pipelines: IdentityManager::new(),
            render_pipelines: IdentityManager::new(),
            textures: IdentityManager::new(),
            texture_views: IdentityManager::new(),
            external_texture_sources: IdentityManager::new(),
            external_textures: IdentityManager::new(),
            samplers: IdentityManager::new(),
            query_sets: IdentityManager::new(),
        }
    }
}

/// Opaque pointer to `mozilla::webgpu::WebGPUChild`.
#[derive(Debug, Clone, Copy)]
#[repr(transparent)]
pub struct WebGPUChildPtr(*mut core::ffi::c_void);

#[derive(Debug)]
pub struct Client {
    owner: WebGPUChildPtr,
    message_queue: Mutex<MessageQueue>,
    identities: Mutex<IdentityHub>,
}

impl Client {
    fn queue_message(&self, message: &Message) {
        let mut message_queue = self.message_queue.lock();
        message_queue.push(self.owner, message);
    }
    fn get_serialized_messages(&self) -> (u32, Vec<u8>) {
        let mut message_queue = self.message_queue.lock();
        message_queue.flush()
    }
}

#[derive(Debug)]
struct MessageQueue {
    on_message_queued: extern "C" fn(WebGPUChildPtr),

    serialized_messages: std::io::Cursor<Vec<u8>>,
    nr_of_queued_messages: u32,
}

impl MessageQueue {
    fn new(on_message_queued: extern "C" fn(WebGPUChildPtr)) -> Self {
        Self {
            on_message_queued,
            serialized_messages: std::io::Cursor::new(Vec::new()),
            nr_of_queued_messages: 0,
        }
    }

    fn push(&mut self, child: WebGPUChildPtr, message: &Message) {
        use bincode::Options;
        let options = bincode::DefaultOptions::new()
            .with_fixint_encoding()
            .allow_trailing_bytes();
        let mut serializer = bincode::Serializer::new(&mut self.serialized_messages, options);

        use serde::Serialize;
        message.serialize(&mut serializer).unwrap();

        self.nr_of_queued_messages = self.nr_of_queued_messages.checked_add(1).unwrap();
        (self.on_message_queued)(child);

        // Force send when we have queued up at least 4k messages.
        // We must comply with some static limits:
        //   - `IPC::Message::MAX_DESCRIPTORS_PER_MESSAGE` (32767): currently,
        //     no message can refer to more than one shmem handle; 4k is well below 32k.
        //   - `IPC::Channel::kMaximumMessageSize` (256 * 1024 * 1024, when fuzzing):
        //     with a limit of 4k messages, each message can be up to 64KiB; while we have
        //     some messages that can have arbitrary size (ex. `CreateShaderModule`) most
        //     have a static size.
        // If we ever violate the limits, the worst that can happen is that we trigger asserts.
        if self.nr_of_queued_messages >= 4 * 1024 {
            let (nr_of_messages, serialized_messages) = self.flush();
            let serialized_messages = ByteBuf::from_vec(serialized_messages);
            unsafe { wgpu_child_send_messages(child, nr_of_messages, serialized_messages) };
        }
    }

    fn flush(&mut self) -> (u32, Vec<u8>) {
        let nr_of_messages = self.nr_of_queued_messages;
        self.nr_of_queued_messages = 0;
        (
            nr_of_messages,
            core::mem::take(&mut self.serialized_messages).into_inner(),
        )
    }
}

#[no_mangle]
pub extern "C" fn wgpu_client_get_queued_messages(
    client: &Client,
    serialized_messages_bb: &mut ByteBuf,
) -> u32 {
    let (nr_of_messages, serialized_messages) = client.get_serialized_messages();
    *serialized_messages_bb = ByteBuf::from_vec(serialized_messages);
    nr_of_messages
}

#[no_mangle]
pub extern "C" fn wgpu_client_new(
    owner: WebGPUChildPtr,
    on_message_queued: extern "C" fn(WebGPUChildPtr),
) -> *mut Client {
    log::info!("Initializing WGPU client");
    let client = Client {
        owner,
        message_queue: Mutex::new(MessageQueue::new(on_message_queued)),
        identities: Mutex::new(IdentityHub::default()),
    };
    Box::into_raw(Box::new(client))
}

/// # Safety
///
/// This function is unsafe because improper use may lead to memory
/// problems. For example, a double-free may occur if the function is called
/// twice on the same raw pointer.
#[no_mangle]
pub unsafe extern "C" fn wgpu_client_delete(client: *mut Client) {
    log::info!("Terminating WGPU client");
    let _client = Box::from_raw(client);
}

#[no_mangle]
pub extern "C" fn wgpu_client_fill_default_limits(limits: &mut wgt::Limits) {
    *limits = wgt::Limits::default();
}

/// Writes the single `WGSLLanguageFeature` associated with `index`, appending its identifier to the
/// provided `buffer`. If `index` does not correspond to a valid feature index, then do nothing.
///
/// This function enables an FFI consumer to extract all implemented features in a loop, like so:
///
/// ```rust
/// let mut buffer = nsstring::nsCString::new();
/// for index in 0usize.. {
///     buffer.truncate();
///     wgpu_client_instance_get_wgsl_language_feature(&mut buffer, index);
///     if buffer.is_empty() {
///         break;
///     }
///     // Handle the identifier in `buffer`…
/// }
/// ```
#[no_mangle]
pub extern "C" fn wgpu_client_instance_get_wgsl_language_feature(
    buffer: &mut nsstring::nsCString,
    index: usize,
) {
    match ImplementedLanguageExtension::all().get(index) {
        Some(some) => buffer.write_str(some.to_ident()).unwrap(),
        None => (),
    }
}

#[repr(C)]
pub struct FfiDeviceDescriptor<'a> {
    pub label: Option<&'a nsACString>,
    pub required_features: wgt::FeaturesWebGPU,
    pub required_limits: wgt::Limits,
}

#[repr(C)]
pub struct DeviceQueueId {
    device: id::DeviceId,
    queue: id::QueueId,
}

#[no_mangle]
pub extern "C" fn wgpu_client_request_device(
    client: &Client,
    adapter_id: id::AdapterId,
    desc: &FfiDeviceDescriptor,
) -> DeviceQueueId {
    let identities = client.identities.lock();
    let device_id = identities.devices.process();
    let queue_id = identities.queues.process();
    drop(identities);

    let label = wgpu_string(desc.label);
    let required_features =
        wgt::Features::from_internal_flags(wgt::FeaturesWGPU::empty(), desc.required_features);
    let desc = wgt::DeviceDescriptor {
        label,
        required_features,
        required_limits: desc.required_limits.clone(),
        // The content process is untrusted, so values set here in fields of the device descriptor
        // not intended to be set by content are ignored, and are overridden in
        // `server::request_device`.
        ..wgt::DeviceDescriptor::default()
    };
    let message = Message::RequestDevice {
        adapter_id,
        device_id,
        queue_id,
        desc,
    };
    client.queue_message(&message);
    DeviceQueueId {
        device: device_id,
        queue: queue_id,
    }
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_render_pass_encoder_id(
    client: &Client,
) -> id::RenderPassEncoderId {
    client.identities.lock().render_pass_encoders.process()
}
#[no_mangle]
pub extern "C" fn wgpu_client_make_compute_pass_encoder_id(
    client: &Client,
) -> id::ComputePassEncoderId {
    client.identities.lock().compute_pass_encoders.process()
}
#[no_mangle]
pub extern "C" fn wgpu_client_make_render_bundle_encoder_id(
    client: &Client,
) -> id::RenderBundleEncoderId {
    client.identities.lock().render_bundle_encoders.process()
}

#[rustfmt::skip]
mod drop {
    use super::*;

    #[no_mangle] pub extern "C" fn wgpu_client_destroy_buffer(client: &Client, id: id::BufferId) { client.queue_message(&Message::DestroyBuffer(id)); }
    #[no_mangle] pub extern "C" fn wgpu_client_destroy_texture(client: &Client, id: id::TextureId) { client.queue_message(&Message::DestroyTexture(id)); }
    #[no_mangle] pub extern "C" fn wgpu_client_destroy_external_texture(client: &Client, id: id::ExternalTextureId) { client.queue_message(&Message::DestroyExternalTexture(id)); }
    #[no_mangle] pub extern "C" fn wgpu_client_destroy_external_texture_source(client: &Client, id: crate::ExternalTextureSourceId) { client.queue_message(&&Message::DestroyExternalTextureSource(id)); }
    #[no_mangle] pub extern "C" fn wgpu_client_destroy_device(client: &Client, id: id::DeviceId) { client.queue_message(&Message::DestroyDevice(id)); }

    #[no_mangle] pub extern "C" fn wgpu_client_drop_adapter(client: &Client, id: id::AdapterId) { client.queue_message(&Message::DropAdapter(id)); client.identities.lock().adapters.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_device(client: &Client, id: id::DeviceId) { client.queue_message(&Message::DropDevice(id)); client.identities.lock().devices.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_queue(client: &Client, id: id::QueueId) { client.queue_message(&Message::DropQueue(id)); client.identities.lock().queues.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_buffer(client: &Client, id: id::BufferId) { client.queue_message(&Message::DropBuffer(id)); client.identities.lock().buffers.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_command_encoder(client: &Client, id: id::CommandEncoderId) { client.queue_message(&Message::DropCommandEncoder(id)); client.identities.lock().command_encoders.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_render_pass_encoder(client: &Client, id: id::RenderPassEncoderId) { client.queue_message(&Message::DropRenderPassEncoder(id)); client.identities.lock().render_pass_encoders.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_compute_pass_encoder(client: &Client, id: id::ComputePassEncoderId) { client.queue_message(&Message::DropComputePassEncoder(id)); client.identities.lock().compute_pass_encoders.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_render_bundle_encoder(client: &Client, id: id::RenderBundleEncoderId) { client.queue_message(&Message::DropRenderBundleEncoder(id)); client.identities.lock().render_bundle_encoders.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_command_buffer(client: &Client, id: id::CommandBufferId) { client.queue_message(&Message::DropCommandBuffer(id)); client.identities.lock().command_buffers.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_render_bundle(client: &Client, id: id::RenderBundleId) { client.queue_message(&Message::DropRenderBundle(id)); client.identities.lock().render_bundles.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_bind_group_layout(client: &Client, id: id::BindGroupLayoutId) { client.queue_message(&Message::DropBindGroupLayout(id)); client.identities.lock().bind_group_layouts.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_pipeline_layout(client: &Client, id: id::PipelineLayoutId) { client.queue_message(&Message::DropPipelineLayout(id)); client.identities.lock().pipeline_layouts.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_bind_group(client: &Client, id: id::BindGroupId) { client.queue_message(&Message::DropBindGroup(id)); client.identities.lock().bind_groups.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_shader_module(client: &Client, id: id::ShaderModuleId) { client.queue_message(&Message::DropShaderModule(id)); client.identities.lock().shader_modules.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_compute_pipeline(client: &Client, id: id::ComputePipelineId) { client.queue_message(&Message::DropComputePipeline(id)); client.identities.lock().compute_pipelines.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_render_pipeline(client: &Client, id: id::RenderPipelineId) { client.queue_message(&Message::DropRenderPipeline(id)); client.identities.lock().render_pipelines.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_texture(client: &Client, id: id::TextureId) { client.queue_message(&Message::DropTexture(id)); client.identities.lock().textures.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_texture_view(client: &Client, id: id::TextureViewId) { client.queue_message(&Message::DropTextureView(id)); client.identities.lock().texture_views.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_external_texture(client: &Client, id: id::ExternalTextureId) { client.queue_message(&Message::DropExternalTexture(id)); client.identities.lock().external_textures.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_external_texture_source(client: &Client, id: crate::ExternalTextureSourceId) { client.queue_message(&Message::DropExternalTextureSource(id)); client.identities.lock().external_texture_sources.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_sampler(client: &Client, id: id::SamplerId) { client.queue_message(&Message::DropSampler(id)); client.identities.lock().samplers.free(id); }
    #[no_mangle] pub extern "C" fn wgpu_client_drop_query_set(client: &Client, id: id::QuerySetId) { client.queue_message(&Message::DropQuerySet(id)); client.identities.lock().query_sets.free(id); }
}

#[repr(C)]
pub struct FfiShaderModuleCompilationMessage {
    pub line_number: u64,
    pub line_pos: u64,
    pub utf16_offset: u64,
    pub utf16_length: u64,
    pub message: nsString,
}

extern "C" {
    fn wgpu_child_send_messages(
        child: WebGPUChildPtr,
        nr_of_messages: u32,
        serialized_messages: ByteBuf,
    );
    fn wgpu_child_resolve_request_adapter_promise(
        child: WebGPUChildPtr,
        adapter_id: id::AdapterId,
        adapter_info: Option<&AdapterInformation<nsString>>,
    );
    fn wgpu_child_resolve_request_device_promise(
        child: WebGPUChildPtr,
        device_id: id::DeviceId,
        queue_id: id::QueueId,
        error: Option<&nsCString>,
    );
    fn wgpu_child_resolve_pop_error_scope_promise(
        child: WebGPUChildPtr,
        device_id: id::DeviceId,
        ty: u8,
        message: &nsCString,
    );
    fn wgpu_child_resolve_create_pipeline_promise(
        child: WebGPUChildPtr,
        pipeline_id: id::RawId,
        is_render_pipeline: bool,
        is_validation_error: bool,
        error: Option<&nsCString>,
    );
    fn wgpu_child_resolve_create_shader_module_promise(
        child: WebGPUChildPtr,
        shader_module_id: id::ShaderModuleId,
        messages: FfiSlice<FfiShaderModuleCompilationMessage>,
    );
    fn wgpu_child_resolve_buffer_map_promise(
        child: WebGPUChildPtr,
        buffer_id: id::BufferId,
        is_writable: bool,
        offset: u64,
        size: u64,
        error: Option<&nsCString>,
    );
    fn wgpu_child_resolve_on_submitted_work_done_promise(
        child: WebGPUChildPtr,
        queue_id: id::QueueId,
    );
}

#[no_mangle]
pub extern "C" fn wgpu_client_receive_server_message(client: &Client, byte_buf: &ByteBuf) {
    let message: ServerMessage = bincode::deserialize(unsafe { byte_buf.as_slice() }).unwrap();
    match message {
        ServerMessage::RequestAdapterResponse(adapter_id, adapter_information) => {
            if let Some(AdapterInformation {
                backend,
                device_type,
                device,
                driver_info,
                driver,
                features,
                id,
                limits,
                name,
                vendor,
                support_use_shared_texture_in_swap_chain,
                transient_saves_memory,
                subgroup_min_size,
                subgroup_max_size,
            }) = adapter_information
            {
                let nss = |s: &str| {
                    let mut ns_string = nsString::new();
                    ns_string.assign_str(s);
                    ns_string
                };
                let adapter_info = AdapterInformation {
                    backend,
                    device_type,
                    device,
                    driver_info: nss(&driver_info),
                    driver: nss(&driver),
                    features,
                    id,
                    limits,
                    name: nss(&name),
                    vendor,
                    support_use_shared_texture_in_swap_chain,
                    transient_saves_memory,
                    subgroup_min_size,
                    subgroup_max_size,
                };
                unsafe {
                    wgpu_child_resolve_request_adapter_promise(
                        client.owner,
                        adapter_id,
                        Some(&adapter_info),
                    );
                }
            } else {
                unsafe {
                    wgpu_child_resolve_request_adapter_promise(client.owner, adapter_id, None);
                }
                client.identities.lock().adapters.free(adapter_id)
            }
        }
        ServerMessage::RequestDeviceResponse(device_id, queue_id, error) => {
            if let Some(error) = error {
                let error = nsCString::from(error);
                unsafe {
                    wgpu_child_resolve_request_device_promise(
                        client.owner,
                        device_id,
                        queue_id,
                        Some(&error),
                    );
                }
                let identities = client.identities.lock();
                identities.devices.free(device_id);
                identities.queues.free(queue_id);
            } else {
                unsafe {
                    wgpu_child_resolve_request_device_promise(
                        client.owner,
                        device_id,
                        queue_id,
                        None,
                    );
                }
            }
        }
        ServerMessage::PopErrorScopeResponse(device_id, ty, message) => {
            let message = nsCString::from(message.as_ref());
            unsafe {
                wgpu_child_resolve_pop_error_scope_promise(client.owner, device_id, ty, &message);
            }
        }
        ServerMessage::CreateRenderPipelineResponse { pipeline_id, error } => {
            let is_render_pipeline = true;
            if let Some(error) = error {
                let ns_error = nsCString::from(error.error);
                unsafe {
                    wgpu_child_resolve_create_pipeline_promise(
                        client.owner,
                        pipeline_id.into_raw(),
                        is_render_pipeline,
                        error.is_validation_error,
                        Some(&ns_error),
                    );
                }
                client.identities.lock().render_pipelines.free(pipeline_id);
            } else {
                unsafe {
                    wgpu_child_resolve_create_pipeline_promise(
                        client.owner,
                        pipeline_id.into_raw(),
                        is_render_pipeline,
                        false,
                        None,
                    );
                }
            }
        }
        ServerMessage::CreateComputePipelineResponse { pipeline_id, error } => {
            let is_render_pipeline = false;
            if let Some(error) = error {
                let ns_error = nsCString::from(error.error);
                unsafe {
                    wgpu_child_resolve_create_pipeline_promise(
                        client.owner,
                        pipeline_id.into_raw(),
                        is_render_pipeline,
                        error.is_validation_error,
                        Some(&ns_error),
                    );
                }
                client.identities.lock().compute_pipelines.free(pipeline_id);
            } else {
                unsafe {
                    wgpu_child_resolve_create_pipeline_promise(
                        client.owner,
                        pipeline_id.into_raw(),
                        is_render_pipeline,
                        false,
                        None,
                    );
                }
            }
        }
        ServerMessage::CreateShaderModuleResponse(shader_module_id, compilation_messages) => {
            let ffi_compilation_messages: Vec<_> = compilation_messages
                .iter()
                .map(|m| FfiShaderModuleCompilationMessage {
                    line_number: m.line_number,
                    line_pos: m.line_pos,
                    utf16_offset: m.utf16_offset,
                    utf16_length: m.utf16_length,
                    message: nsString::from(&m.message),
                })
                .collect();

            unsafe {
                wgpu_child_resolve_create_shader_module_promise(
                    client.owner,
                    shader_module_id,
                    FfiSlice::from_slice(&ffi_compilation_messages),
                )
            }
        }
        ServerMessage::BufferMapResponse(buffer_id, buffer_map_result) => {
            match buffer_map_result {
                BufferMapResult::Success {
                    is_writable,
                    offset,
                    size,
                } => unsafe {
                    wgpu_child_resolve_buffer_map_promise(
                        client.owner,
                        buffer_id,
                        is_writable,
                        offset,
                        size,
                        None,
                    );
                },
                BufferMapResult::Error(error) => {
                    let ns_error = nsCString::from(error.as_ref());
                    unsafe {
                        wgpu_child_resolve_buffer_map_promise(
                            client.owner,
                            buffer_id,
                            false,
                            0,
                            0,
                            Some(&ns_error),
                        );
                    }
                }
            };
        }
        ServerMessage::QueueOnSubmittedWorkDoneResponse(queue_id) => unsafe {
            wgpu_child_resolve_on_submitted_work_done_promise(client.owner, queue_id);
        },

        ServerMessage::FreeSwapChainBufferIds(buffer_ids) => {
            let identities = client.identities.lock();
            for id in buffer_ids {
                identities.buffers.free(id);
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn wgpu_client_request_adapter(
    client: &Client,
    power_preference: wgt::PowerPreference,
    force_fallback_adapter: bool,
) -> id::AdapterId {
    let adapter_id = client.identities.lock().adapters.process();
    let message = Message::RequestAdapter {
        adapter_id,
        power_preference,
        force_fallback_adapter,
    };
    client.queue_message(&message);
    adapter_id
}

#[no_mangle]
pub extern "C" fn wgpu_client_pop_error_scope(client: &Client, device_id: id::DeviceId) {
    let message = Message::Device(device_id, DeviceAction::PopErrorScope);
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_shader_module(
    client: &Client,
    device_id: id::DeviceId,
    label: Option<&nsACString>,
    code: &nsACString,
) -> id::ShaderModuleId {
    let shader_module_id = client.identities.lock().shader_modules.process();
    let label = wgpu_string(label);
    let action =
        DeviceAction::CreateShaderModule(shader_module_id, label, Cow::Owned(code.to_string()));
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    shader_module_id
}

#[no_mangle]
pub extern "C" fn wgpu_client_on_submitted_work_done(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
) {
    let message = Message::QueueOnSubmittedWorkDone {
        device_id,
        queue_id,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_swap_chain(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
    desc: &wgt::TextureDescriptor<Option<&nsACString>, FfiSlice<TextureFormat>>,
    format: crate::SurfaceFormat,
    remote_texture_owner_id: crate::RemoteTextureOwnerId,
    use_shared_texture_in_swap_chain: bool,
) {
    let identities = client.identities.lock();
    let buffer_ids: [id::BufferId; crate::MAX_SWAPCHAIN_BUFFER_COUNT] =
        array::from_fn(|_| identities.buffers.process());
    drop(identities);

    let message = Message::CreateSwapChain {
        device_id,
        queue_id,
        format,
        desc: desc.map_label_and_view_formats(
            |_| (),
            |view_formats| Cow::from(unsafe { view_formats.as_slice() }),
        ),
        buffer_ids,
        remote_texture_owner_id,
        use_shared_texture_in_swap_chain,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_swap_chain_present(
    client: &Client,
    texture_id: id::TextureId,
    command_encoder_id: id::CommandEncoderId,
    command_buffer_id: id::CommandBufferId,
    remote_texture_id: crate::RemoteTextureId,
    remote_texture_owner_id: crate::RemoteTextureOwnerId,
) {
    let message = Message::SwapChainPresent {
        texture_id,
        command_encoder_id,
        command_buffer_id,
        remote_texture_id,
        remote_texture_owner_id,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_swap_chain_drop(
    client: &Client,
    remote_texture_owner_id: crate::RemoteTextureOwnerId,
    txn_type: crate::RemoteTextureTxnType,
    txn_id: crate::RemoteTextureTxnId,
) {
    let message = Message::SwapChainDrop {
        remote_texture_owner_id,
        txn_type,
        txn_id,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_queue_submit(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
    command_buffers: FfiSlice<'_, id::CommandBufferId>,
    swap_chain_textures: FfiSlice<'_, id::TextureId>,
    external_texture_sources: FfiSlice<'_, crate::ExternalTextureSourceId>,
) {
    let message = Message::QueueSubmit(
        device_id,
        queue_id,
        Cow::Borrowed(unsafe { command_buffers.as_slice() }),
        Cow::Borrowed(unsafe { swap_chain_textures.as_slice() }),
        Cow::Borrowed(unsafe { external_texture_sources.as_slice() }),
    );
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_buffer_map(
    client: &Client,
    device_id: id::DeviceId,
    buffer_id: id::BufferId,
    mode: u32,
    offset: u64,
    size: u64,
) {
    let message = Message::BufferMap {
        device_id,
        buffer_id,
        mode,
        offset,
        size,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_buffer_unmap(
    client: &Client,
    device_id: id::DeviceId,
    buffer_id: id::BufferId,
    flush: bool,
) {
    let message = Message::BufferUnmap(device_id, buffer_id, flush);
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_push_error_scope(
    client: &Client,
    device_id: id::DeviceId,
    filter: u8,
) {
    let action = DeviceAction::PushErrorScope(filter);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_buffer(
    client: &Client,
    device_id: id::DeviceId,
    desc: &wgt::BufferDescriptor<Option<&nsACString>>,
    shmem_handle_index: usize,
) -> id::BufferId {
    let buffer_id = client.identities.lock().buffers.process();
    let label = wgpu_string(desc.label);
    let desc = desc.map_label(|_| label);
    let action = DeviceAction::CreateBuffer {
        buffer_id,
        desc,
        shmem_handle_index,
    };
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    buffer_id
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_texture(
    client: &Client,
    device_id: id::DeviceId,
    desc: &wgt::TextureDescriptor<Option<&nsACString>, FfiSlice<TextureFormat>>,
    swap_chain_id: Option<&SwapChainId>,
) -> id::TextureId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().textures.process();

    let view_formats = unsafe { desc.view_formats.as_slice() }.to_vec();

    let action = DeviceAction::CreateTexture(
        id,
        desc.map_label_and_view_formats(|_| label, |_| view_formats),
        swap_chain_id.copied(),
    );
    let message = Message::Device(device_id, action);
    client.queue_message(&message);

    id
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_texture_id(client: &Client) -> id::TextureId {
    client.identities.lock().textures.process()
}

#[no_mangle]
pub extern "C" fn wgpu_client_free_texture_id(client: &Client, id: id::TextureId) {
    client.identities.lock().textures.free(id)
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_texture_view(
    client: &Client,
    device_id: id::DeviceId,
    texture_id: id::TextureId,
    desc: &crate::TextureViewDescriptor,
) -> id::TextureViewId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().texture_views.process();

    let wgpu_desc = wgc::resource::TextureViewDescriptor {
        label,
        format: desc.format.cloned(),
        dimension: desc.dimension.cloned(),
        range: wgt::ImageSubresourceRange {
            aspect: desc.aspect,
            base_mip_level: desc.base_mip_level,
            mip_level_count: desc.mip_level_count.map(|ptr| *ptr),
            base_array_layer: desc.base_array_layer,
            array_layer_count: desc.array_layer_count.map(|ptr| *ptr),
        },
        usage: Some(desc.usage),
    };

    let action = TextureAction::CreateView(id, wgpu_desc);
    let message = Message::Texture(device_id, texture_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_texture_view_id(client: &Client) -> id::TextureViewId {
    client.identities.lock().texture_views.process()
}

#[no_mangle]
pub extern "C" fn wgpu_client_free_texture_view_id(client: &Client, id: id::TextureViewId) {
    client.identities.lock().texture_views.free(id)
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_external_texture_source_id(
    client: &Client,
) -> crate::ExternalTextureSourceId {
    client.identities.lock().external_texture_sources.process()
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_external_texture(
    client: &Client,
    device_id: id::DeviceId,
    desc: &crate::ExternalTextureDescriptor<Option<&nsACString>>,
) -> id::ExternalTextureId {
    let desc = desc.map_label(|l| wgpu_string(*l));
    let id = client.identities.lock().external_textures.process();

    let action = DeviceAction::CreateExternalTexture(id, desc);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_sampler(
    client: &Client,
    device_id: id::DeviceId,
    desc: &SamplerDescriptor,
) -> id::SamplerId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().samplers.process();

    let wgpu_desc = wgc::resource::SamplerDescriptor {
        label,
        address_modes: desc.address_modes,
        mag_filter: desc.mag_filter,
        min_filter: desc.min_filter,
        mipmap_filter: desc.mipmap_filter,
        lod_min_clamp: desc.lod_min_clamp,
        lod_max_clamp: desc.lod_max_clamp,
        compare: desc.compare.cloned(),
        anisotropy_clamp: desc.max_anisotropy,
        border_color: None,
    };
    let action = DeviceAction::CreateSampler(id, wgpu_desc);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_command_encoder_id(client: &Client) -> id::CommandEncoderId {
    client.identities.lock().command_encoders.process()
}

#[no_mangle]
pub extern "C" fn wgpu_client_free_command_encoder_id(client: &Client, id: id::CommandEncoderId) {
    client.identities.lock().command_encoders.free(id)
}

#[no_mangle]
pub extern "C" fn wgpu_client_make_command_buffer_id(client: &Client) -> id::CommandBufferId {
    client.identities.lock().command_buffers.process()
}

#[no_mangle]
pub extern "C" fn wgpu_client_free_command_buffer_id(client: &Client, id: id::CommandBufferId) {
    client.identities.lock().command_buffers.free(id)
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_command_encoder(
    client: &Client,
    device_id: id::DeviceId,
    desc: &wgt::CommandEncoderDescriptor<Option<&nsACString>>,
) -> id::CommandEncoderId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().command_encoders.process();

    let action = DeviceAction::CreateCommandEncoder(id, desc.map_label(|_| label));
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub extern "C" fn wgpu_device_create_render_bundle_encoder(
    client: &Client,
    device_id: id::DeviceId,
    desc: &RenderBundleEncoderDescriptor,
) -> *mut wgc::command::RenderBundleEncoder {
    let label = wgpu_string(desc.label);

    let color_formats: Vec<_> = unsafe { desc.color_formats.as_slice() }
        .iter()
        .map(|format_opt| format_opt.to_std())
        .collect();
    let descriptor = wgc::command::RenderBundleEncoderDescriptor {
        label,
        color_formats: Cow::Owned(color_formats),
        depth_stencil: desc
            .depth_stencil_format
            .map(|&format| wgt::RenderBundleDepthStencil {
                format,
                depth_read_only: desc.depth_read_only,
                stencil_read_only: desc.stencil_read_only,
            }),
        sample_count: desc.sample_count,
        multiview: None,
    };
    match wgc::command::RenderBundleEncoder::new(&descriptor, None, device_id) {
        Ok(encoder) => Box::into_raw(Box::new(encoder)),
        Err(e) => {
            let message = format!("Error in `Device::create_render_bundle_encoder`: {}", e);
            let action = DeviceAction::Error {
                message,
                r#type: e.webgpu_error_type(),
            };
            let message = Message::Device(device_id, action);
            client.queue_message(&message);
            ptr::null_mut()
        }
    }
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_bundle_encoder_destroy(
    pass: *mut wgc::command::RenderBundleEncoder,
) {
    // The RB encoder is just a boxed Rust struct, it doesn't have any API primitives
    // associated with it right now, but in the future it will.
    let _ = Box::from_raw(pass);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_render_bundle(
    client: &Client,
    device_id: id::DeviceId,
    encoder: *mut wgc::command::RenderBundleEncoder,
    desc: &wgt::RenderBundleDescriptor<Option<&nsACString>>,
) -> id::RenderBundleId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().render_bundles.process();

    let action =
        DeviceAction::CreateRenderBundle(id, *Box::from_raw(encoder), desc.map_label(|_| label));
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_render_bundle_error(
    client: &Client,
    device_id: id::DeviceId,
    label: Option<&nsACString>,
) -> id::RenderBundleId {
    let label = wgpu_string(label);

    let id = client.identities.lock().render_bundles.process();

    let action = DeviceAction::CreateRenderBundleError(id, label);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[repr(C)]
pub struct RawQuerySetDescriptor<'a> {
    label: Option<&'a nsACString>,
    ty: RawQueryType,
    count: u32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
pub enum RawQueryType {
    Occlusion,
    Timestamp,
}

#[no_mangle]
pub extern "C" fn wgpu_client_create_query_set(
    client: &Client,
    device_id: id::DeviceId,
    desc: &RawQuerySetDescriptor,
) -> wgc::id::QuerySetId {
    let &RawQuerySetDescriptor { label, ty, count } = desc;

    let label = wgpu_string(label);
    let ty = match ty {
        RawQueryType::Occlusion => wgt::QueryType::Occlusion,
        RawQueryType::Timestamp => wgt::QueryType::Timestamp,
    };

    let desc = wgc::resource::QuerySetDescriptor { label, ty, count };

    let id = client.identities.lock().query_sets.process();

    let action = DeviceAction::CreateQuerySet(id, desc);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);

    id
}

#[repr(C)]
pub struct ComputePassDescriptor<'a> {
    pub label: Option<&'a nsACString>,
    pub timestamp_writes: Option<&'a PassTimestampWrites<'a>>,
}

#[repr(C)]
pub struct PassTimestampWrites<'a> {
    pub query_set: id::QuerySetId,
    pub beginning_of_pass_write_index: Option<&'a u32>,
    pub end_of_pass_write_index: Option<&'a u32>,
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_begin_compute_pass(
    desc: &ComputePassDescriptor,
) -> *mut crate::command::RecordedComputePass {
    let &ComputePassDescriptor {
        label,
        timestamp_writes,
    } = desc;

    let label = wgpu_string(label);

    let timestamp_writes = timestamp_writes.map(|tsw| {
        let &PassTimestampWrites {
            query_set,
            beginning_of_pass_write_index,
            end_of_pass_write_index,
        } = tsw;
        let beginning_of_pass_write_index = beginning_of_pass_write_index.cloned();
        let end_of_pass_write_index = end_of_pass_write_index.cloned();
        wgc::command::PassTimestampWrites {
            query_set,
            beginning_of_pass_write_index,
            end_of_pass_write_index,
        }
    });

    let pass = crate::command::RecordedComputePass::new(&wgc::command::ComputePassDescriptor {
        label,
        timestamp_writes,
    });
    Box::into_raw(Box::new(pass))
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_compute_pass_finish(
    client: &Client,
    device_id: id::DeviceId,
    encoder_id: id::CommandEncoderId,
    pass: *mut crate::command::RecordedComputePass,
) {
    let pass = *Box::from_raw(pass);
    let message = Message::ReplayComputePass(device_id, encoder_id, pass);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_compute_pass_destroy(pass: *mut crate::command::RecordedComputePass) {
    let _ = Box::from_raw(pass);
}

#[repr(C)]
pub struct RenderPassDescriptor<'a> {
    pub label: Option<&'a nsACString>,
    pub color_attachments: FfiSlice<'a, FfiOption<FfiRenderPassColorAttachment>>,
    pub depth_stencil_attachment: Option<&'a RenderPassDepthStencilAttachment>,
    pub timestamp_writes: Option<&'a PassTimestampWrites<'a>>,
    pub occlusion_query_set: Option<wgc::id::QuerySetId>,
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_begin_render_pass(
    desc: &RenderPassDescriptor,
) -> *mut crate::command::RecordedRenderPass {
    let &RenderPassDescriptor {
        label,
        color_attachments,
        depth_stencil_attachment,
        timestamp_writes,
        occlusion_query_set,
    } = desc;

    let label = wgpu_string(label).map(|l| l.to_string());

    let timestamp_writes = timestamp_writes.map(|tsw| {
        let &PassTimestampWrites {
            query_set,
            beginning_of_pass_write_index,
            end_of_pass_write_index,
        } = tsw;
        let beginning_of_pass_write_index = beginning_of_pass_write_index.cloned();
        let end_of_pass_write_index = end_of_pass_write_index.cloned();
        wgc::command::PassTimestampWrites {
            query_set,
            beginning_of_pass_write_index,
            end_of_pass_write_index,
        }
    });

    let color_attachments: Vec<_> = color_attachments
        .as_slice()
        .iter()
        .map(|att_opt| att_opt.as_ref().map(|att| att.clone().to_wgpu()))
        .collect();
    let depth_stencil_attachment = depth_stencil_attachment.cloned().map(|dsa| dsa.to_wgpu());
    let pass = crate::command::RecordedRenderPass::new(
        label,
        color_attachments,
        depth_stencil_attachment,
        timestamp_writes,
        occlusion_query_set,
    );
    Box::into_raw(Box::new(pass))
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_pass_finish(
    client: &Client,
    device_id: id::DeviceId,
    encoder_id: id::CommandEncoderId,
    pass: *mut crate::command::RecordedRenderPass,
) {
    let pass = *Box::from_raw(pass);
    let message = Message::ReplayRenderPass(device_id, encoder_id, pass);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_pass_destroy(pass: *mut crate::command::RecordedRenderPass) {
    let _ = Box::from_raw(pass);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_bind_group_layout(
    client: &Client,
    device_id: id::DeviceId,
    desc: &BindGroupLayoutDescriptor,
) -> id::BindGroupLayoutId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().bind_group_layouts.process();

    let entries = desc
        .entries
        .as_slice()
        .iter()
        .enumerate()
        .map(|(idx, entry)| {
            Ok(wgt::BindGroupLayoutEntry {
                binding: entry.binding,
                visibility: entry.visibility,
                count: None,
                ty: match entry.ty {
                    RawBindingType::UniformBuffer => wgt::BindingType::Buffer {
                        ty: wgt::BufferBindingType::Uniform,
                        has_dynamic_offset: entry.has_dynamic_offset,
                        min_binding_size: entry.min_binding_size,
                    },
                    RawBindingType::StorageBuffer => wgt::BindingType::Buffer {
                        ty: wgt::BufferBindingType::Storage { read_only: false },
                        has_dynamic_offset: entry.has_dynamic_offset,
                        min_binding_size: entry.min_binding_size,
                    },
                    RawBindingType::ReadonlyStorageBuffer => wgt::BindingType::Buffer {
                        ty: wgt::BufferBindingType::Storage { read_only: true },
                        has_dynamic_offset: entry.has_dynamic_offset,
                        min_binding_size: entry.min_binding_size,
                    },
                    RawBindingType::Sampler => {
                        wgt::BindingType::Sampler(if entry.sampler_compare {
                            wgt::SamplerBindingType::Comparison
                        } else if entry.sampler_filter {
                            wgt::SamplerBindingType::Filtering
                        } else {
                            wgt::SamplerBindingType::NonFiltering
                        })
                    }
                    RawBindingType::SampledTexture => wgt::BindingType::Texture {
                        //TODO: the spec has a bug here
                        view_dimension: *entry
                            .view_dimension
                            .unwrap_or(&wgt::TextureViewDimension::D2),
                        sample_type: match entry.texture_sample_type {
                            None | Some(RawTextureSampleType::Float) => {
                                wgt::TextureSampleType::Float { filterable: true }
                            }
                            Some(RawTextureSampleType::UnfilterableFloat) => {
                                wgt::TextureSampleType::Float { filterable: false }
                            }
                            Some(RawTextureSampleType::Uint) => wgt::TextureSampleType::Uint,
                            Some(RawTextureSampleType::Sint) => wgt::TextureSampleType::Sint,
                            Some(RawTextureSampleType::Depth) => wgt::TextureSampleType::Depth,
                        },
                        multisampled: entry.multisampled,
                    },
                    RawBindingType::ReadonlyStorageTexture => wgt::BindingType::StorageTexture {
                        access: wgt::StorageTextureAccess::ReadOnly,
                        view_dimension: *entry.view_dimension.unwrap(),
                        format: *entry.storage_texture_format.unwrap(),
                    },
                    RawBindingType::WriteonlyStorageTexture => wgt::BindingType::StorageTexture {
                        access: wgt::StorageTextureAccess::WriteOnly,
                        view_dimension: *entry.view_dimension.unwrap(),
                        format: *entry.storage_texture_format.unwrap(),
                    },
                    RawBindingType::ReadWriteStorageTexture => wgt::BindingType::StorageTexture {
                        access: wgt::StorageTextureAccess::ReadWrite,
                        view_dimension: *entry.view_dimension.unwrap(),
                        format: *entry.storage_texture_format.unwrap(),
                    },
                    RawBindingType::ExternalTexture => wgt::BindingType::ExternalTexture,
                    RawBindingType::Error => return Err((idx, entry.error_case)),
                },
            })
        })
        .collect::<Result<_, _>>();

    let action = match entries {
        Ok(entries) => {
            let wgpu_desc = wgc::binding_model::BindGroupLayoutDescriptor {
                label,
                entries: Cow::Owned(entries),
            };
            DeviceAction::CreateBindGroupLayout(id, wgpu_desc)
        }
        Err((idx, error_case)) => {
            let initial_msg = match error_case {
                BindingTypeError::NoneSpecified => "no type specified",
                BindingTypeError::MultipleSpecified => "multiple types specified",
            };
            let mut message = format!("{initial_msg} for entry {idx} of bind group layout");
            if let Some(label) = label.as_deref() {
                write!(&mut message, "\"{label}\"").unwrap();
            }

            client.queue_message(&Message::Device(
                device_id,
                DeviceAction::Error {
                    message,
                    r#type: wgt::error::ErrorType::Validation,
                },
            ));
            DeviceAction::CreateBindGroupLayoutError(id, label)
        }
    };
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_render_pipeline_get_bind_group_layout(
    client: &Client,
    device_id: id::DeviceId,
    pipeline_id: id::RenderPipelineId,
    index: u32,
) -> id::BindGroupLayoutId {
    let bgl_id = client.identities.lock().bind_group_layouts.process();

    let action = DeviceAction::RenderPipelineGetBindGroupLayout(pipeline_id, index, bgl_id);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);

    bgl_id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_compute_pipeline_get_bind_group_layout(
    client: &Client,
    device_id: id::DeviceId,
    pipeline_id: id::ComputePipelineId,
    index: u32,
) -> id::BindGroupLayoutId {
    let bgl_id = client.identities.lock().bind_group_layouts.process();

    let action = DeviceAction::ComputePipelineGetBindGroupLayout(pipeline_id, index, bgl_id);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);

    bgl_id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_pipeline_layout(
    client: &Client,
    device_id: id::DeviceId,
    desc: &PipelineLayoutDescriptor,
) -> id::PipelineLayoutId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().pipeline_layouts.process();

    let wgpu_desc = wgc::binding_model::PipelineLayoutDescriptor {
        label,
        bind_group_layouts: Cow::Borrowed(desc.bind_group_layouts.as_slice()),
        immediate_size: 0,
    };

    let action = DeviceAction::CreatePipelineLayout(id, wgpu_desc);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_bind_group(
    client: &Client,
    device_id: id::DeviceId,
    desc: &BindGroupDescriptor,
) -> id::BindGroupId {
    let label = wgpu_string(desc.label);

    let id = client.identities.lock().bind_groups.process();

    let entries = desc
        .entries
        .as_slice()
        .iter()
        .map(|entry| wgc::binding_model::BindGroupEntry {
            binding: entry.binding,
            resource: if let Some(id) = entry.buffer {
                wgc::binding_model::BindingResource::Buffer(wgc::binding_model::BufferBinding {
                    buffer: id,
                    offset: entry.offset,
                    size: entry.size_passed.then_some(entry.size),
                })
            } else if let Some(id) = entry.sampler {
                wgc::binding_model::BindingResource::Sampler(id)
            } else if let Some(id) = entry.texture_view {
                wgc::binding_model::BindingResource::TextureView(id)
            } else if let Some(id) = entry.external_texture {
                wgc::binding_model::BindingResource::ExternalTexture(id)
            } else {
                panic!("Unexpected binding entry {:?}", entry);
            },
        })
        .collect();
    let wgpu_desc = wgc::binding_model::BindGroupDescriptor {
        label,
        layout: desc.layout,
        entries: Cow::Owned(entries),
    };

    let action = DeviceAction::CreateBindGroup(id, wgpu_desc);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_compute_pipeline(
    client: &Client,
    device_id: id::DeviceId,
    desc: &ComputePipelineDescriptor,
    is_async: bool,
) -> id::ComputePipelineId {
    let label = wgpu_string(desc.label);

    let identities = client.identities.lock();
    let id = identities.compute_pipelines.process();

    let wgpu_desc = wgc::pipeline::ComputePipelineDescriptor {
        label,
        layout: desc.layout,
        stage: desc.stage.to_wgpu(),
        cache: None,
    };

    let action = DeviceAction::CreateComputePipeline(id, wgpu_desc, is_async);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_client_create_render_pipeline(
    client: &Client,
    device_id: id::DeviceId,
    desc: &RenderPipelineDescriptor,
    is_async: bool,
) -> id::RenderPipelineId {
    let label = wgpu_string(desc.label);

    let identities = client.identities.lock();
    let id = identities.render_pipelines.process();

    let wgpu_desc = wgc::pipeline::RenderPipelineDescriptor {
        label,
        layout: desc.layout,
        vertex: desc.vertex.to_wgpu(),
        fragment: desc.fragment.map(FragmentState::to_wgpu),
        primitive: desc.primitive.to_wgpu(),
        depth_stencil: desc.depth_stencil.map(DepthStencilState::to_wgpu),
        multisample: desc.multisample.clone(),
        multiview_mask: None,
        cache: None,
    };

    let action = DeviceAction::CreateRenderPipeline(id, wgpu_desc, is_async);
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
    id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_copy_buffer_to_buffer(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    src: id::BufferId,
    src_offset: wgt::BufferAddress,
    dst: id::BufferId,
    dst_offset: wgt::BufferAddress,
    size: wgt::BufferAddress,
) {
    // In Javascript, `size === undefined` means "copy from src_offset to end of
    // buffer". The `size` argument to this function uses a value of
    // `wgt::BufferAddress::MAX` to encode that case. (Valid copy
    // sizes must be multiples of four, so in the case that the application
    // really asked to copy BufferAddress::MAX bytes,
    // CommandEncoder::CopyBufferToBuffer decrements it by four, which
    // will still fail for mis-alignment.)
    let size = (size != wgt::BufferAddress::MAX).then_some(size);
    let action = CommandEncoderAction::CopyBufferToBuffer {
        src,
        src_offset,
        dst,
        dst_offset,
        size,
    };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_copy_texture_to_buffer(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    src: wgc::command::TexelCopyTextureInfo,
    dst_buffer: wgc::id::BufferId,
    dst_layout: &TexelCopyBufferLayout,
    size: wgt::Extent3d,
) {
    let action = CommandEncoderAction::CopyTextureToBuffer {
        src,
        dst: wgc::command::TexelCopyBufferInfo {
            buffer: dst_buffer,
            layout: dst_layout.into_wgt(),
        },
        size,
    };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_copy_buffer_to_texture(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    src_buffer: wgc::id::BufferId,
    src_layout: &TexelCopyBufferLayout,
    dst: wgc::command::TexelCopyTextureInfo,
    size: wgt::Extent3d,
) {
    let action = CommandEncoderAction::CopyBufferToTexture {
        src: wgc::command::TexelCopyBufferInfo {
            buffer: src_buffer,
            layout: src_layout.into_wgt(),
        },
        dst,
        size,
    };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_copy_texture_to_texture(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    src: wgc::command::TexelCopyTextureInfo,
    dst: wgc::command::TexelCopyTextureInfo,
    size: wgt::Extent3d,
) {
    let action = CommandEncoderAction::CopyTextureToTexture { src, dst, size };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_clear_buffer(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    dst: wgc::id::BufferId,
    offset: u64,
    size: Option<&u64>,
) {
    let action = CommandEncoderAction::ClearBuffer {
        dst,
        offset,
        size: size.cloned(),
    };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub extern "C" fn wgpu_command_encoder_push_debug_group(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    marker: &nsACString,
) {
    let string = marker.to_string();
    let action = CommandEncoderAction::PushDebugGroup(string);
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_pop_debug_group(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
) {
    let action = CommandEncoderAction::PopDebugGroup;
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_insert_debug_marker(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    marker: &nsACString,
) {
    let string = marker.to_string();
    let action = CommandEncoderAction::InsertDebugMarker(string);
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_resolve_query_set(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    query_set_id: id::QuerySetId,
    start_query: u32,
    query_count: u32,
    destination: id::BufferId,
    destination_offset: wgt::BufferAddress,
) {
    let action = CommandEncoderAction::ResolveQuerySet {
        query_set: query_set_id,
        start_query,
        query_count,
        destination,
        destination_offset,
    };
    let message = Message::CommandEncoder(device_id, command_encoder_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_report_internal_error(
    client: &Client,
    device_id: id::DeviceId,
    message: *const core::ffi::c_char,
) {
    let action = DeviceAction::Error {
        message: core::ffi::CStr::from_ptr(message)
            .to_str()
            .unwrap()
            .to_string(),
        r#type: wgt::error::ErrorType::Internal,
    };
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_report_validation_error(
    client: &Client,
    device_id: id::DeviceId,
    message: *const core::ffi::c_char,
) {
    let action = DeviceAction::Error {
        message: core::ffi::CStr::from_ptr(message)
            .to_str()
            .unwrap()
            .to_string(),
        r#type: wgt::error::ErrorType::Validation,
    };
    let message = Message::Device(device_id, action);
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_command_encoder_finish(
    client: &Client,
    device_id: id::DeviceId,
    command_encoder_id: id::CommandEncoderId,
    desc: &wgt::CommandBufferDescriptor<Option<&nsACString>>,
) -> id::CommandBufferId {
    let command_buffer_id = client.identities.lock().command_buffers.process();
    let label = wgpu_string(desc.label);
    let message = Message::CommandEncoderFinish(
        device_id,
        command_encoder_id,
        command_buffer_id,
        desc.map_label(|_| label),
    );
    client.queue_message(&message);
    command_buffer_id
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_queue_write_buffer_inline(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
    dst: id::BufferId,
    offset: wgt::BufferAddress,
    data_buffer_index: usize,
) {
    let data_source = QueueWriteDataSource::DataBuffer(data_buffer_index);

    let action = QueueWriteAction::Buffer { dst, offset };
    let message = Message::QueueWrite {
        device_id,
        queue_id,
        data_source,
        action,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_queue_write_buffer_via_shmem(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
    dst: id::BufferId,
    offset: wgt::BufferAddress,
    shmem_handle_index: usize,
) {
    let data_source = QueueWriteDataSource::Shmem(shmem_handle_index);

    let action = QueueWriteAction::Buffer { dst, offset };
    let message = Message::QueueWrite {
        device_id,
        queue_id,
        data_source,
        action,
    };
    client.queue_message(&message);
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_queue_write_texture_via_shmem(
    client: &Client,
    device_id: id::DeviceId,
    queue_id: id::QueueId,
    dst: wgt::TexelCopyTextureInfo<id::TextureId>,
    layout: TexelCopyBufferLayout,
    size: wgt::Extent3d,
    shmem_handle_index: usize,
) {
    let data_source = QueueWriteDataSource::Shmem(shmem_handle_index);

    let layout = layout.into_wgt();
    let action = QueueWriteAction::Texture { dst, layout, size };
    let message = Message::QueueWrite {
        device_id,
        queue_id,
        data_source,
        action,
    };
    client.queue_message(&message);
}

#[repr(C)]
pub struct TextureFormatBlockInfo {
    copy_size: u32,
    width: u32,
    height: u32,
}

/// Obtain the block size and dimensions for a single aspect.
///
/// Populates `info` and returns true on success. Returns false if `format` has
/// multiple aspects and `aspect` is `All`.
#[no_mangle]
pub extern "C" fn wgpu_texture_format_get_block_info(
    format: wgt::TextureFormat,
    aspect: wgt::TextureAspect,
    info: &mut TextureFormatBlockInfo,
) -> bool {
    let (width, height) = format.block_dimensions();
    let (copy_size, ret) = match format.block_copy_size(Some(aspect)) {
        Some(size) => (size, true),
        None => (0, false),
    };
    *info = TextureFormatBlockInfo {
        width,
        height,
        copy_size,
    };
    ret
}

#[no_mangle]
pub extern "C" fn wgpu_client_use_shared_texture_in_swapChain(format: wgt::TextureFormat) -> bool {
    let supported = match format {
        wgt::TextureFormat::Bgra8Unorm => true,
        _ => false,
    };

    supported
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_bundle_set_bind_group(
    bundle: &mut RenderBundleEncoder,
    index: u32,
    bind_group_id: Option<id::BindGroupId>,
    offsets: *const DynamicOffset,
    offset_length: usize,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_set_bind_group(
        bundle,
        index,
        bind_group_id,
        offsets,
        offset_length,
    )
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_set_pipeline(
    bundle: &mut RenderBundleEncoder,
    pipeline_id: id::RenderPipelineId,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_set_pipeline(bundle, pipeline_id)
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_set_vertex_buffer(
    bundle: &mut RenderBundleEncoder,
    slot: u32,
    buffer_id: Option<id::BufferId>,
    offset: BufferAddress,
    size: Option<&BufferAddress>,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_set_vertex_buffer(
        bundle,
        slot,
        buffer_id,
        offset,
        size.copied(),
    )
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_set_index_buffer(
    encoder: &mut RenderBundleEncoder,
    buffer: id::BufferId,
    index_format: IndexFormat,
    offset: BufferAddress,
    size: Option<&BufferAddress>,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_set_index_buffer(
        encoder,
        buffer,
        index_format,
        offset,
        size.copied(),
    )
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_draw(
    bundle: &mut RenderBundleEncoder,
    vertex_count: u32,
    instance_count: u32,
    first_vertex: u32,
    first_instance: u32,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_draw(
        bundle,
        vertex_count,
        instance_count,
        first_vertex,
        first_instance,
    )
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_draw_indexed(
    bundle: &mut RenderBundleEncoder,
    index_count: u32,
    instance_count: u32,
    first_index: u32,
    base_vertex: i32,
    first_instance: u32,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_draw_indexed(
        bundle,
        index_count,
        instance_count,
        first_index,
        base_vertex,
        first_instance,
    )
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_draw_indirect(
    bundle: &mut RenderBundleEncoder,
    buffer_id: id::BufferId,
    offset: BufferAddress,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_draw_indirect(bundle, buffer_id, offset)
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_draw_indexed_indirect(
    bundle: &mut RenderBundleEncoder,
    buffer_id: id::BufferId,
    offset: BufferAddress,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_draw_indexed_indirect(bundle, buffer_id, offset)
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_bundle_push_debug_group(
    _bundle: &mut RenderBundleEncoder,
    _label: RawString,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_push_debug_group(_bundle, _label)
}

#[no_mangle]
pub extern "C" fn wgpu_render_bundle_pop_debug_group(_bundle: &mut RenderBundleEncoder) {
    wgc::command::bundle_ffi::wgpu_render_bundle_pop_debug_group(_bundle)
}

#[no_mangle]
pub unsafe extern "C" fn wgpu_render_bundle_insert_debug_marker(
    _bundle: &mut RenderBundleEncoder,
    _label: RawString,
) {
    wgc::command::bundle_ffi::wgpu_render_bundle_insert_debug_marker(_bundle, _label)
}
