//! Memory buffers.
//!
//! # Buffer
//!
//! Buffers interpret memory slices as linear contiguous data array.
//! They can be used as shader resources, vertex buffers, index buffers or for
//! specifying the action commands for indirect execution.

use crate::{device, format, Backend, IndexType};

/// An offset inside a buffer, in bytes.
pub type Offset = u64;

/// A subrange of the buffer.
#[derive(Clone, Debug, Default, Hash, PartialEq, Eq)]
#[cfg_attr(feature = "serde", derive(Serialize, Deserialize))]
pub struct SubRange {
    /// Offset to the subrange.
    pub offset: Offset,
    /// Size of the subrange, or None for the remaining size of the buffer.
    pub size: Option<Offset>,
}

impl SubRange {
    /// Whole buffer subrange.
    pub const WHOLE: Self = SubRange {
        offset: 0,
        size: None,
    };

    /// Return the stored size, if present, or computed size based on the limit.
    pub fn size_to(&self, limit: Offset) -> Offset {
        self.size.unwrap_or(limit - self.offset)
    }
}

/// Buffer state.
pub type State = Access;

/// Error creating a buffer.
#[derive(Clone, Debug, PartialEq)]
pub enum CreationError {
    /// Out of either host or device memory.
    OutOfMemory(device::OutOfMemory),

    /// Requested buffer usage is not supported.
    ///
    /// Older GL version don't support constant buffers or multiple usage flags.
    UnsupportedUsage {
        /// Unsupported usage passed on buffer creation.
        usage: Usage,
    },
}

impl From<device::OutOfMemory> for CreationError {
    fn from(error: device::OutOfMemory) -> Self {
        CreationError::OutOfMemory(error)
    }
}

impl std::fmt::Display for CreationError {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            CreationError::OutOfMemory(err) => write!(fmt, "Failed to create buffer: {}", err),
            CreationError::UnsupportedUsage { usage } => write!(
                fmt,
                "Failed to create buffer: Unsupported usage: {:?}",
                usage
            ),
        }
    }
}

impl std::error::Error for CreationError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            CreationError::OutOfMemory(err) => Some(err),
            _ => None,
        }
    }
}

/// Error creating a buffer view.
#[derive(Clone, Debug, PartialEq)]
pub enum ViewCreationError {
    /// Out of either host or device memory.
    OutOfMemory(device::OutOfMemory),

    /// Buffer view format is not supported.
    UnsupportedFormat(Option<format::Format>),
}

impl From<device::OutOfMemory> for ViewCreationError {
    fn from(error: device::OutOfMemory) -> Self {
        ViewCreationError::OutOfMemory(error)
    }
}

impl std::fmt::Display for ViewCreationError {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ViewCreationError::OutOfMemory(err) => {
                write!(fmt, "Failed to create buffer view: {}", err)
            }
            ViewCreationError::UnsupportedFormat(Some(format)) => write!(
                fmt,
                "Failed to create buffer view: Unsupported format {:?}",
                format
            ),
            ViewCreationError::UnsupportedFormat(None) => {
                write!(fmt, "Failed to create buffer view: Unspecified format")
            }
        }
    }
}

impl std::error::Error for ViewCreationError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ViewCreationError::OutOfMemory(err) => Some(err),
            _ => None,
        }
    }
}

bitflags!(
    /// Buffer usage flags.
    #[cfg_attr(feature = "serde", derive(Serialize, Deserialize))]
    pub struct Usage: u32 {
        ///
        const TRANSFER_SRC  = 0x1;
        ///
        const TRANSFER_DST = 0x2;
        ///
        const UNIFORM_TEXEL = 0x4;
        ///
        const STORAGE_TEXEL = 0x8;
        ///
        const UNIFORM = 0x10;
        ///
        const STORAGE = 0x20;
        ///
        const INDEX = 0x40;
        ///
        const VERTEX = 0x80;
        ///
        const INDIRECT = 0x100;
    }
);

impl Usage {
    /// Returns if the buffer can be used in transfer operations.
    pub fn can_transfer(&self) -> bool {
        self.intersects(Usage::TRANSFER_SRC | Usage::TRANSFER_DST)
    }
}

bitflags!(
    /// Buffer access flags.
    ///
    /// Access of buffers by the pipeline or shaders.
    #[cfg_attr(feature = "serde", derive(Serialize, Deserialize))]
    pub struct Access: u32 {
        /// Read commands instruction for indirect execution.
        const INDIRECT_COMMAND_READ = 0x1;
        /// Read index values for indexed draw commands.
        ///
        /// See [`draw_indexed`](../command/trait.RawCommandBuffer.html#tymethod.draw_indexed)
        /// and [`draw_indexed_indirect`](../command/trait.RawCommandBuffer.html#tymethod.draw_indexed_indirect).
        const INDEX_BUFFER_READ = 0x2;
        /// Read vertices from vertex buffer for draw commands in the [`VERTEX_INPUT`](
        /// ../pso/struct.PipelineStage.html#associatedconstant.VERTEX_INPUT) stage.
        const VERTEX_BUFFER_READ = 0x4;
        ///
        const UNIFORM_READ = 0x8;
        ///
        const SHADER_READ = 0x20;
        ///
        const SHADER_WRITE = 0x40;
        ///
        const TRANSFER_READ = 0x800;
        ///
        const TRANSFER_WRITE = 0x1000;
        ///
        const HOST_READ = 0x2000;
        ///
        const HOST_WRITE = 0x4000;
        ///
        const MEMORY_READ = 0x8000;
        ///
        const MEMORY_WRITE = 0x10000;
    }
);

/// Index buffer view for `bind_index_buffer`.
///
/// Defines a buffer slice used for acquiring the indices on draw commands.
/// Indices are used to lookup vertex indices in the vertex buffers.
#[derive(Debug)]
pub struct IndexBufferView<'a, B: Backend> {
    /// The buffer to bind.
    pub buffer: &'a B::Buffer,
    /// The subrange of the buffer.
    pub range: SubRange,
    /// The type of the table elements (`u16` or `u32`).
    pub index_type: IndexType,
}
