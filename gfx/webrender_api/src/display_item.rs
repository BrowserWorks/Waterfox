/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use app_units::Au;
use euclid::SideOffsets2D;
use {ColorF, FontKey, ImageKey, LayoutPoint, LayoutRect, LayoutSize, LayoutTransform};
use {GlyphOptions, LayoutVector2D, PipelineId, PropertyBinding, WebGLContextId};

// NOTE: some of these structs have an "IMPLICIT" comment.
// This indicates that the BuiltDisplayList will have serialized
// a list of values nearby that this item consumes. The traversal
// iterator should handle finding these.

#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub struct ClipAndScrollInfo {
    pub scroll_node_id: ClipId,
    pub clip_node_id: Option<ClipId>,
}

impl ClipAndScrollInfo {
    pub fn simple(node_id: ClipId) -> ClipAndScrollInfo {
        ClipAndScrollInfo {
            scroll_node_id: node_id,
            clip_node_id: None,
        }
    }

    pub fn new(scroll_node_id: ClipId, clip_node_id: ClipId) -> ClipAndScrollInfo {
        ClipAndScrollInfo {
            scroll_node_id,
            clip_node_id: Some(clip_node_id),
        }
    }

    pub fn clip_node_id(&self) -> ClipId {
        self.clip_node_id.unwrap_or(self.scroll_node_id)
    }
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct DisplayItem {
    pub item: SpecificDisplayItem,
    pub rect: LayoutRect,
    pub local_clip: LocalClip,
    pub clip_and_scroll: ClipAndScrollInfo,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum SpecificDisplayItem {
    Clip(ClipDisplayItem),
    ScrollFrame(ScrollFrameDisplayItem),
    Rectangle(RectangleDisplayItem),
    Line(LineDisplayItem),
    Text(TextDisplayItem),
    Image(ImageDisplayItem),
    YuvImage(YuvImageDisplayItem),
    WebGL(WebGLDisplayItem),
    Border(BorderDisplayItem),
    BoxShadow(BoxShadowDisplayItem),
    Gradient(GradientDisplayItem),
    RadialGradient(RadialGradientDisplayItem),
    Iframe(IframeDisplayItem),
    PushStackingContext(PushStackingContextDisplayItem),
    PopStackingContext,
    SetGradientStops,
    PushNestedDisplayList,
    PopNestedDisplayList,
    PushTextShadow(TextShadow),
    PopTextShadow,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ClipDisplayItem {
    pub id: ClipId,
    pub parent_id: ClipId,
    pub image_mask: Option<ImageMask>,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum ScrollSensitivity {
    ScriptAndInputEvents,
    Script,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ScrollFrameDisplayItem {
    pub id: ClipId,
    pub parent_id: ClipId,
    pub image_mask: Option<ImageMask>,
    pub scroll_sensitivity: ScrollSensitivity,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct RectangleDisplayItem {
    pub color: ColorF,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct LineDisplayItem {
    pub baseline: f32, // LayerPixel
    pub start: f32,
    pub end: f32,
    pub orientation: LineOrientation, // toggles whether above values are interpreted as x/y values
    pub width: f32,
    pub color: ColorF,
    pub style: LineStyle,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum LineOrientation {
    Vertical,
    Horizontal,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum LineStyle {
    Solid,
    Dotted,
    Dashed,
    Wavy,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct TextDisplayItem {
    pub font_key: FontKey,
    pub size: Au,
    pub color: ColorF,
    pub glyph_options: Option<GlyphOptions>,
} // IMPLICIT: glyphs: Vec<GlyphInstance>

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct WebGLDisplayItem {
    pub context_id: WebGLContextId,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct NormalBorder {
    pub left: BorderSide,
    pub right: BorderSide,
    pub top: BorderSide,
    pub bottom: BorderSide,
    pub radius: BorderRadius,
}

#[repr(u32)]
#[derive(Debug, Copy, Clone, PartialEq, Serialize, Deserialize)]
pub enum RepeatMode {
    Stretch,
    Repeat,
    Round,
    Space,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct NinePatchDescriptor {
    pub width: u32,
    pub height: u32,
    pub slice: SideOffsets2D<u32>,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ImageBorder {
    pub image_key: ImageKey,
    pub patch: NinePatchDescriptor,
    /// Controls whether the center of the 9 patch image is
    /// rendered or ignored.
    pub fill: bool,
    pub outset: SideOffsets2D<f32>,
    pub repeat_horizontal: RepeatMode,
    pub repeat_vertical: RepeatMode,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct GradientBorder {
    pub gradient: Gradient,
    pub outset: SideOffsets2D<f32>,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct RadialGradientBorder {
    pub gradient: RadialGradient,
    pub outset: SideOffsets2D<f32>,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum BorderDetails {
    Normal(NormalBorder),
    Image(ImageBorder),
    Gradient(GradientBorder),
    RadialGradient(RadialGradientBorder),
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct BorderDisplayItem {
    pub widths: BorderWidths,
    pub details: BorderDetails,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct BorderRadius {
    pub top_left: LayoutSize,
    pub top_right: LayoutSize,
    pub bottom_left: LayoutSize,
    pub bottom_right: LayoutSize,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct BorderWidths {
    pub left: f32,
    pub top: f32,
    pub right: f32,
    pub bottom: f32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct BorderSide {
    pub color: ColorF,
    pub style: BorderStyle,
}

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum BorderStyle {
    None    = 0,
    Solid   = 1,
    Double  = 2,
    Dotted  = 3,
    Dashed  = 4,
    Hidden  = 5,
    Groove  = 6,
    Ridge   = 7,
    Inset   = 8,
    Outset  = 9,
}

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum BoxShadowClipMode {
    None    = 0,
    Outset  = 1,
    Inset   = 2,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct BoxShadowDisplayItem {
    pub box_bounds: LayoutRect,
    pub offset: LayoutVector2D,
    pub color: ColorF,
    pub blur_radius: f32,
    pub spread_radius: f32,
    pub border_radius: f32,
    pub clip_mode: BoxShadowClipMode,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct TextShadow {
    pub offset: LayoutVector2D,
    pub color: ColorF,
    pub blur_radius: f32,
}

#[repr(u32)]
#[derive(Debug, Copy, Clone, Hash, Eq, PartialEq, Serialize, Deserialize, Ord, PartialOrd)]
pub enum ExtendMode {
    Clamp,
    Repeat,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct Gradient {
    pub start_point: LayoutPoint,
    pub end_point: LayoutPoint,
    pub extend_mode: ExtendMode,
} // IMPLICIT: stops: Vec<GradientStop>

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct GradientDisplayItem {
    pub gradient: Gradient,
    pub tile_size: LayoutSize,
    pub tile_spacing: LayoutSize,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct GradientStop {
    pub offset: f32,
    pub color: ColorF,
}
known_heap_size!(0, GradientStop);

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct RadialGradient {
    pub start_center: LayoutPoint,
    pub start_radius: f32,
    pub end_center: LayoutPoint,
    pub end_radius: f32,
    pub ratio_xy: f32,
    pub extend_mode: ExtendMode,
} // IMPLICIT stops: Vec<GradientStop>

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct RadialGradientDisplayItem {
    pub gradient: RadialGradient,
    pub tile_size: LayoutSize,
    pub tile_spacing: LayoutSize,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct PushStackingContextDisplayItem {
    pub stacking_context: StackingContext,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct StackingContext {
    pub scroll_policy: ScrollPolicy,
    pub transform: Option<PropertyBinding<LayoutTransform>>,
    pub transform_style: TransformStyle,
    pub perspective: Option<LayoutTransform>,
    pub mix_blend_mode: MixBlendMode,
} // IMPLICIT: filters: Vec<FilterOp>

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub enum ScrollPolicy {
    Scrollable  = 0,
    Fixed       = 1,
}

known_heap_size!(0, ScrollPolicy);

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum TransformStyle {
    Flat        = 0,
    Preserve3D  = 1,
}

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum MixBlendMode {
    Normal      = 0,
    Multiply    = 1,
    Screen      = 2,
    Overlay     = 3,
    Darken      = 4,
    Lighten     = 5,
    ColorDodge  = 6,
    ColorBurn   = 7,
    HardLight   = 8,
    SoftLight   = 9,
    Difference  = 10,
    Exclusion   = 11,
    Hue         = 12,
    Saturation  = 13,
    Color       = 14,
    Luminosity  = 15,
}

#[derive(Clone, Copy, Debug, PartialEq, Deserialize, Serialize)]
pub enum FilterOp {
    Blur(f32),
    Brightness(f32),
    Contrast(f32),
    Grayscale(f32),
    HueRotate(f32),
    Invert(f32),
    Opacity(PropertyBinding<f32>),
    Saturate(f32),
    Sepia(f32),
}

impl FilterOp {
    pub fn is_noop(&self) -> bool {
        match *self {
            FilterOp::Blur(length) if length == 0.0 => true,
            FilterOp::Brightness(amount) if amount == 1.0 => true,
            FilterOp::Contrast(amount) if amount == 1.0 => true,
            FilterOp::Grayscale(amount) if amount == 0.0 => true,
            FilterOp::HueRotate(amount) if amount == 0.0 => true,
            FilterOp::Invert(amount) if amount == 0.0 => true,
            FilterOp::Opacity(amount) if amount == PropertyBinding::Value(1.0) => true,
            FilterOp::Saturate(amount) if amount == 1.0 => true,
            FilterOp::Sepia(amount) if amount == 0.0 => true,
            _ => false,
        }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct IframeDisplayItem {
    pub pipeline_id: PipelineId,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ImageDisplayItem {
    pub image_key: ImageKey,
    pub stretch_size: LayoutSize,
    pub tile_spacing: LayoutSize,
    pub image_rendering: ImageRendering,
}

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum ImageRendering {
    Auto        = 0,
    CrispEdges  = 1,
    Pixelated   = 2,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct YuvImageDisplayItem {
    pub yuv_data: YuvData,
    pub color_space: YuvColorSpace,
    pub image_rendering: ImageRendering
}

#[repr(u32)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum YuvColorSpace {
    Rec601 = 0,
    Rec709 = 1,
}
pub const YUV_COLOR_SPACES: [YuvColorSpace; 2] = [YuvColorSpace::Rec601, YuvColorSpace::Rec709];

impl YuvColorSpace {
    pub fn get_feature_string(&self) -> &'static str {
        match *self {
            YuvColorSpace::Rec601 => "YUV_REC601",
            YuvColorSpace::Rec709 => "YUV_REC709",
        }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum YuvData {
    NV12(ImageKey, ImageKey),   // (Y channel, CbCr interleaved channel)
    PlanarYCbCr(ImageKey, ImageKey, ImageKey),  // (Y channel, Cb channel, Cr Channel)
    InterleavedYCbCr(ImageKey), // (YCbCr interleaved channel)
}

impl YuvData {
    pub fn get_format(&self) -> YuvFormat {
        match *self {
            YuvData::NV12(..) => YuvFormat::NV12,
            YuvData::PlanarYCbCr(..) => YuvFormat::PlanarYCbCr,
            YuvData::InterleavedYCbCr(..) => YuvFormat::InterleavedYCbCr,
        }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum YuvFormat {
    NV12 = 0,
    PlanarYCbCr = 1,
    InterleavedYCbCr = 2,
}
pub const YUV_FORMATS: [YuvFormat; 3] = [YuvFormat::NV12, YuvFormat::PlanarYCbCr, YuvFormat::InterleavedYCbCr];

impl YuvFormat {
    pub fn get_plane_num(&self) -> usize {
        match *self {
            YuvFormat::NV12 => 2,
            YuvFormat::PlanarYCbCr => 3,
            YuvFormat::InterleavedYCbCr => 1,
        }
    }

    pub fn get_feature_string(&self) -> &'static str {
        match *self {
            YuvFormat::NV12 => "NV12",
            YuvFormat::PlanarYCbCr => "",
            YuvFormat::InterleavedYCbCr => "INTERLEAVED_Y_CB_CR"
        }
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ImageMask {
    pub image: ImageKey,
    pub rect: LayoutRect,
    pub repeat: bool,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub enum LocalClip {
    Rect(LayoutRect),
    RoundedRect(LayoutRect, ComplexClipRegion),
}

impl From<LayoutRect> for LocalClip {
    fn from(rect: LayoutRect) -> Self {
        LocalClip::Rect(rect)
    }
}

impl LocalClip {
    pub fn clip_rect(&self) -> &LayoutRect {
        match *self {
            LocalClip::Rect(ref rect) => rect,
            LocalClip::RoundedRect(ref rect, _) => &rect,
        }
    }

    pub fn create_with_offset(&self, offset: &LayoutVector2D) -> LocalClip {
        match *self {
            LocalClip::Rect(rect) => LocalClip::from(rect.translate(offset)),
            LocalClip::RoundedRect(rect, complex) => {
                LocalClip::RoundedRect(rect.translate(offset),
                                       ComplexClipRegion {
                                            rect: complex.rect.translate(offset),
                                            radii: complex.radii,
                                        })
            }
        }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Serialize)]
pub struct ComplexClipRegion {
    /// The boundaries of the rectangle.
    pub rect: LayoutRect,
    /// Border radii of this rectangle.
    pub radii: BorderRadius,
}

impl BorderRadius {
    pub fn zero() -> BorderRadius {
        BorderRadius {
            top_left: LayoutSize::new(0.0, 0.0),
            top_right: LayoutSize::new(0.0, 0.0),
            bottom_left: LayoutSize::new(0.0, 0.0),
            bottom_right: LayoutSize::new(0.0, 0.0),
        }
    }

    pub fn uniform(radius: f32) -> BorderRadius {
        BorderRadius {
            top_left: LayoutSize::new(radius, radius),
            top_right: LayoutSize::new(radius, radius),
            bottom_left: LayoutSize::new(radius, radius),
            bottom_right: LayoutSize::new(radius, radius),
        }
    }

    pub fn uniform_size(radius: LayoutSize) -> BorderRadius {
        BorderRadius {
            top_left: radius,
            top_right: radius,
            bottom_left: radius,
            bottom_right: radius,
        }
    }

    pub fn is_uniform(&self) -> Option<f32> {
        match self.is_uniform_size() {
            Some(radius) if radius.width == radius.height => Some(radius.width),
            _ => None
        }
    }

    pub fn is_uniform_size(&self) -> Option<LayoutSize> {
        let uniform_radius = self.top_left;
        if self.top_right == uniform_radius &&
           self.bottom_left == uniform_radius &&
           self.bottom_right == uniform_radius {
            Some(uniform_radius)
        } else {
            None
        }
    }

    pub fn is_zero(&self) -> bool {
        if let Some(radius) = self.is_uniform() {
            radius == 0.0
        } else {
            false
        }
    }
}

impl ComplexClipRegion {
    /// Create a new complex clip region.
    pub fn new(rect: LayoutRect, radii: BorderRadius) -> ComplexClipRegion {
        ComplexClipRegion {
            rect,
            radii,
        }
    }
}

pub type NestingIndex = u64;

#[derive(Clone, Copy, Debug, Deserialize, Eq, Hash, PartialEq, Serialize)]
pub enum ClipId {
    Clip(u64, NestingIndex, PipelineId),
    ClipExternalId(u64, PipelineId),
    DynamicallyAddedNode(u64, PipelineId),
}

impl ClipId {
    pub fn root_scroll_node(pipeline_id: PipelineId) -> ClipId {
        ClipId::Clip(0, 0, pipeline_id)
    }

    pub fn root_reference_frame(pipeline_id: PipelineId) -> ClipId {
        ClipId::DynamicallyAddedNode(0, pipeline_id)
    }

    pub fn new(id: u64, pipeline_id: PipelineId) -> ClipId {
        // We do this because it is very easy to create accidentally create something that
        // seems like a root scroll node, but isn't one.
        if id == 0 {
            return ClipId::root_scroll_node(pipeline_id);
        }

        ClipId::ClipExternalId(id, pipeline_id)
    }

    pub fn pipeline_id(&self) -> PipelineId {
        match *self {
            ClipId::Clip(_, _, pipeline_id) |
            ClipId::ClipExternalId(_, pipeline_id) |
            ClipId::DynamicallyAddedNode(_, pipeline_id) => pipeline_id,
        }
    }

    pub fn external_id(&self) -> Option<u64> {
        match *self {
            ClipId::ClipExternalId(id, _) => Some(id),
            _ => None,
        }
    }

    pub fn is_root_scroll_node(&self) -> bool {
        match *self {
            ClipId::Clip(0, 0, _)  => true,
            _ => false,
        }
    }

    pub fn is_nested(&self) -> bool {
        match *self {
            ClipId::Clip(_, nesting_level, _) => nesting_level != 0,
            _ => false,
        }
    }
}

macro_rules! define_empty_heap_size_of {
    ($name:ident) => {
        impl ::heapsize::HeapSizeOf for $name {
            fn heap_size_of_children(&self) -> usize { 0 }
        }
    }
}

define_empty_heap_size_of!(ClipId);
define_empty_heap_size_of!(RepeatMode);
define_empty_heap_size_of!(ImageKey);
define_empty_heap_size_of!(MixBlendMode);
define_empty_heap_size_of!(TransformStyle);
define_empty_heap_size_of!(LocalClip);
define_empty_heap_size_of!(ScrollSensitivity);
