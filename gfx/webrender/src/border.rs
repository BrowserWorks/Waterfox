/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use ellipse::Ellipse;
use frame_builder::FrameBuilder;
use mask_cache::{ClipSource};
use prim_store::{BorderPrimitiveCpu, GpuBlock32, PrimitiveContainer};
use tiling::PrimitiveFlags;
use util::{lerp, pack_as_float};
use webrender_traits::{BorderSide, BorderStyle, BorderWidths, ClipAndScrollInfo, ClipRegion};
use webrender_traits::{ColorF, LayerPoint, LayerRect, LayerSize, NormalBorder};

#[repr(u8)]
#[derive(Debug, Copy, Clone, PartialEq)]
pub enum BorderCornerInstance {
    Single,     // Single instance needed - corner styles are same or similar.
    Double,     // Different corner styles. Draw two instances, one per style.
}

#[repr(C)]
pub enum BorderCornerSide {
    Both,
    First,
    Second,
}

#[repr(C)]
enum BorderCorner {
    TopLeft,
    TopRight,
    BottomLeft,
    BottomRight,
}

#[derive(Clone, Debug, PartialEq)]
pub enum BorderCornerKind {
    None,
    Solid,
    Clip(BorderCornerInstance),
    Mask(BorderCornerClipData, LayerSize, LayerSize, BorderCornerClipKind),
}

impl BorderCornerKind {
    fn new_mask(kind: BorderCornerClipKind,
                width0: f32,
                width1: f32,
                corner: BorderCorner,
                radius: LayerSize,
                border_rect: LayerRect) -> BorderCornerKind {
        let size = LayerSize::new(width0.max(radius.width), width1.max(radius.height));
        let (origin, clip_center) = match corner {
            BorderCorner::TopLeft => {
                let origin = border_rect.origin;
                let clip_center = origin + size;
                (origin, clip_center)
            }
            BorderCorner::TopRight => {
                let origin = LayerPoint::new(border_rect.origin.x +
                                             border_rect.size.width -
                                             size.width,
                                             border_rect.origin.y);
                let clip_center = origin + LayerSize::new(0.0, size.height);
                (origin, clip_center)
            }
            BorderCorner::BottomRight => {
                let origin = border_rect.origin + (border_rect.size - size);
                let clip_center = origin;
                (origin, clip_center)
            }
            BorderCorner::BottomLeft => {
                let origin = LayerPoint::new(border_rect.origin.x,
                                             border_rect.origin.y +
                                             border_rect.size.height -
                                             size.height);
                let clip_center = origin + LayerSize::new(size.width, 0.0);
                (origin, clip_center)
            }
        };
        let clip_data = BorderCornerClipData {
            corner_rect: LayerRect::new(origin, size),
            clip_center: clip_center,
            corner: pack_as_float(corner as u32),
            kind: pack_as_float(kind as u32),
        };
        BorderCornerKind::Mask(clip_data,
                               radius,
                               LayerSize::new(width0, width1),
                               kind)
    }
}

#[derive(Copy, Clone, Debug, PartialEq)]
pub enum BorderEdgeKind {
    None,
    Solid,
    Clip,
}

trait NormalBorderHelpers {
    fn get_corner(&self,
                  edge0: &BorderSide,
                  width0: f32,
                  edge1: &BorderSide,
                  width1: f32,
                  radius: &LayerSize,
                  corner: BorderCorner,
                  border_rect: &LayerRect) -> BorderCornerKind;

    fn get_edge(&self,
                edge: &BorderSide,
                width: f32) -> (BorderEdgeKind, f32);
}

impl NormalBorderHelpers for NormalBorder {
    fn get_corner(&self,
                  edge0: &BorderSide,
                  width0: f32,
                  edge1: &BorderSide,
                  width1: f32,
                  radius: &LayerSize,
                  corner: BorderCorner,
                  border_rect: &LayerRect) -> BorderCornerKind {
        // If either width is zero, a corner isn't formed.
        if width0 == 0.0 || width1 == 0.0 {
            return BorderCornerKind::None;
        }

        // If both edges are transparent, no corner is formed.
        if edge0.color.a == 0.0 && edge1.color.a == 0.0 {
            return BorderCornerKind::None;
        }

        match (edge0.style, edge1.style) {
            // If either edge is none or hidden, no corner is needed.
            (BorderStyle::None, _) | (_, BorderStyle::None) => BorderCornerKind::None,
            (BorderStyle::Hidden, _) | (_, BorderStyle::Hidden) => BorderCornerKind::None,

            // If both borders are solid, we can draw them with a simple rectangle if
            // both the colors match and there is no radius.
            (BorderStyle::Solid, BorderStyle::Solid) => {
                if edge0.color == edge1.color && radius.width == 0.0 && radius.height == 0.0 {
                    BorderCornerKind::Solid
                } else {
                    BorderCornerKind::Clip(BorderCornerInstance::Single)
                }
            }

            // Inset / outset borders just modtify the color of edges, so can be
            // drawn with the normal border corner shader.
            (BorderStyle::Outset, BorderStyle::Outset) |
            (BorderStyle::Inset, BorderStyle::Inset) |
            (BorderStyle::Double, BorderStyle::Double) |
            (BorderStyle::Groove, BorderStyle::Groove) |
            (BorderStyle::Ridge, BorderStyle::Ridge) => {
                BorderCornerKind::Clip(BorderCornerInstance::Single)
            }

            // Dashed and dotted border corners get drawn into a clip mask.
            (BorderStyle::Dashed, BorderStyle::Dashed) => {
                BorderCornerKind::new_mask(BorderCornerClipKind::Dash,
                                           width0,
                                           width1,
                                           corner,
                                           *radius,
                                           *border_rect)
            }
            (BorderStyle::Dotted, BorderStyle::Dotted) => {
                BorderCornerKind::new_mask(BorderCornerClipKind::Dot,
                                           width0,
                                           width1,
                                           corner,
                                           *radius,
                                           *border_rect)
            }

            // Draw border transitions with dots and/or dashes as
            // solid segments. The old border path didn't support
            // this anyway, so we might as well start using the new
            // border path here, since the dashing in the edges is
            // much higher quality anyway.
            (BorderStyle::Dotted, _) |
            (_, BorderStyle::Dotted) |
            (BorderStyle::Dashed, _) |
            (_, BorderStyle::Dashed) => {
                BorderCornerKind::Clip(BorderCornerInstance::Single)
            }

            // Everything else can be handled by drawing the corner twice,
            // where the shader outputs zero alpha for the side it's not
            // drawing. This is somewhat inefficient in terms of pixels
            // written, but it's a fairly rare case, and we can optimize
            // this case later.
            _ => BorderCornerKind::Clip(BorderCornerInstance::Double),
        }
    }

    fn get_edge(&self,
                edge: &BorderSide,
                width: f32) -> (BorderEdgeKind, f32) {
        if width == 0.0 {
            return (BorderEdgeKind::None, 0.0);
        }

        match edge.style {
            BorderStyle::None |
            BorderStyle::Hidden => (BorderEdgeKind::None, 0.0),

            BorderStyle::Solid |
            BorderStyle::Inset |
            BorderStyle::Outset => (BorderEdgeKind::Solid, width),

            BorderStyle::Double |
            BorderStyle::Groove |
            BorderStyle::Ridge |
            BorderStyle::Dashed |
            BorderStyle::Dotted => (BorderEdgeKind::Clip, width),
        }
    }
}

impl FrameBuilder {
    fn add_normal_border_primitive(&mut self,
                                   rect: &LayerRect,
                                   border: &NormalBorder,
                                   widths: &BorderWidths,
                                   clip_and_scroll: ClipAndScrollInfo,
                                   clip_region: &ClipRegion,
                                   corner_instances: [BorderCornerInstance; 4],
                                   extra_clips: &[ClipSource]) {
        let radius = &border.radius;
        let left = &border.left;
        let right = &border.right;
        let top = &border.top;
        let bottom = &border.bottom;

        // These colors are used during inset/outset scaling.
        let left_color      = left.border_color(1.0, 2.0/3.0, 0.3, 0.7);
        let top_color       = top.border_color(1.0, 2.0/3.0, 0.3, 0.7);
        let right_color     = right.border_color(2.0/3.0, 1.0, 0.7, 0.3);
        let bottom_color    = bottom.border_color(2.0/3.0, 1.0, 0.7, 0.3);

        let prim_cpu = BorderPrimitiveCpu {
            corner_instances: corner_instances,

            // TODO(gw): In the future, we will build these on demand
            //           from the deserialized display list, rather
            //           than creating it immediately.
            gpu_blocks: [
                [ pack_as_float(left.style as u32),
                  pack_as_float(top.style as u32),
                  pack_as_float(right.style as u32),
                  pack_as_float(bottom.style as u32) ].into(),
                [ widths.left,
                  widths.top,
                  widths.right,
                  widths.bottom ].into(),
                left_color.into(),
                top_color.into(),
                right_color.into(),
                bottom_color.into(),
                [ radius.top_left.width,
                  radius.top_left.height,
                  radius.top_right.width,
                  radius.top_right.height ].into(),
                [ radius.bottom_right.width,
                  radius.bottom_right.height,
                  radius.bottom_left.width,
                  radius.bottom_left.height ].into(),
            ],
        };

        self.add_primitive(clip_and_scroll,
                           &rect,
                           clip_region,
                           extra_clips,
                           PrimitiveContainer::Border(prim_cpu));
    }

    // TODO(gw): This allows us to move border types over to the
    // simplified shader model one at a time. Once all borders
    // are converted, this can be removed, along with the complex
    // border code path.
    pub fn add_normal_border(&mut self,
                             rect: &LayerRect,
                             border: &NormalBorder,
                             widths: &BorderWidths,
                             clip_and_scroll: ClipAndScrollInfo,
                             clip_region: &ClipRegion) {
        // The border shader is quite expensive. For simple borders, we can just draw
        // the border with a few rectangles. This generally gives better batching, and
        // a GPU win in fragment shader time.
        // More importantly, the software (OSMesa) implementation we run tests on is
        // particularly slow at running our complex border shader, compared to the
        // rectangle shader. This has the effect of making some of our tests time
        // out more often on CI (the actual cause is simply too many Servo processes and
        // threads being run on CI at once).

        let radius = &border.radius;
        let left = &border.left;
        let right = &border.right;
        let top = &border.top;
        let bottom = &border.bottom;

        let corners = [
            border.get_corner(left,
                              widths.left,
                              top,
                              widths.top,
                              &radius.top_left,
                              BorderCorner::TopLeft,
                              rect),
            border.get_corner(right,
                              widths.right,
                              top,
                              widths.top,
                              &radius.top_right,
                              BorderCorner::TopRight,
                              rect),
            border.get_corner(right,
                              widths.right,
                              bottom,
                              widths.bottom,
                              &radius.bottom_right,
                              BorderCorner::BottomRight,
                              rect),
            border.get_corner(left,
                              widths.left,
                              bottom,
                              widths.bottom,
                              &radius.bottom_left,
                              BorderCorner::BottomLeft,
                              rect),
        ];

        let (left_edge, left_len) = border.get_edge(left, widths.left);
        let (top_edge, top_len) = border.get_edge(top, widths.top);
        let (right_edge, right_len) = border.get_edge(right, widths.right);
        let (bottom_edge, bottom_len) = border.get_edge(bottom, widths.bottom);

        let edges = [
            left_edge,
            top_edge,
            right_edge,
            bottom_edge,
        ];

        // Use a simple rectangle case when all edges and corners are either
        // solid or none.
        let all_corners_simple = corners.iter().all(|c| {
            *c == BorderCornerKind::Solid || *c == BorderCornerKind::None
        });
        let all_edges_simple = edges.iter().all(|e| {
            *e == BorderEdgeKind::Solid || *e == BorderEdgeKind::None
        });

        let has_no_curve = radius.is_zero();

        if has_no_curve && all_corners_simple && all_edges_simple {
            let p0 = rect.origin;
            let p1 = rect.bottom_right();
            let rect_width = rect.size.width;
            let rect_height = rect.size.height;

            // Add a solid rectangle for each visible edge/corner combination.
            if top_edge == BorderEdgeKind::Solid {
                self.add_solid_rectangle(clip_and_scroll,
                                         &LayerRect::new(p0, LayerSize::new(rect_width, top_len)),
                                         clip_region,
                                         &border.top.color,
                                         PrimitiveFlags::None);
            }
            if left_edge == BorderEdgeKind::Solid {
                self.add_solid_rectangle(clip_and_scroll,
                                         &LayerRect::new(LayerPoint::new(p0.x, p0.y + top_len),
                                                         LayerSize::new(left_len,
                                                                        rect_height - top_len - bottom_len)),
                                         clip_region,
                                         &border.left.color,
                                         PrimitiveFlags::None);
            }
            if right_edge == BorderEdgeKind::Solid {
                self.add_solid_rectangle(clip_and_scroll,
                                         &LayerRect::new(LayerPoint::new(p1.x - right_len,
                                                                         p0.y + top_len),
                                                         LayerSize::new(right_len,
                                                                        rect_height - top_len - bottom_len)),
                                         clip_region,
                                         &border.right.color,
                                         PrimitiveFlags::None);
            }
            if bottom_edge == BorderEdgeKind::Solid {
                self.add_solid_rectangle(clip_and_scroll,
                                         &LayerRect::new(LayerPoint::new(p0.x, p1.y - bottom_len),
                                                         LayerSize::new(rect_width, bottom_len)),
                                         clip_region,
                                         &border.bottom.color,
                                         PrimitiveFlags::None);
            }
        } else {
            // Create clip masks for border corners, if required.
            let mut extra_clips = Vec::new();
            let mut corner_instances = [BorderCornerInstance::Single; 4];

            for (i, corner) in corners.iter().enumerate() {
                match corner {
                    &BorderCornerKind::Mask(corner_data, corner_radius, widths, kind) => {
                        let clip_source = BorderCornerClipSource::new(corner_data,
                                                                      corner_radius,
                                                                      widths,
                                                                      kind);
                        extra_clips.push(ClipSource::BorderCorner(clip_source));
                    }
                    &BorderCornerKind::Clip(instance_kind) => {
                        corner_instances[i] = instance_kind;
                    }
                    _ => {}
                }
            }

            self.add_normal_border_primitive(rect,
                                             border,
                                             widths,
                                             clip_and_scroll,
                                             clip_region,
                                             corner_instances,
                                             &extra_clips);
        }
    }
}

pub trait BorderSideHelpers {
    fn border_color(&self,
                    scale_factor_0: f32,
                    scale_factor_1: f32,
                    black_color_0: f32,
                    black_color_1: f32) -> ColorF;
}

impl BorderSideHelpers for BorderSide {
    fn border_color(&self,
                    scale_factor_0: f32,
                    scale_factor_1: f32,
                    black_color_0: f32,
                    black_color_1: f32) -> ColorF {
        match self.style {
            BorderStyle::Inset => {
                if self.color.r != 0.0 || self.color.g != 0.0 || self.color.b != 0.0 {
                    self.color.scale_rgb(scale_factor_1)
                } else {
                    ColorF::new(black_color_0, black_color_0, black_color_0, self.color.a)
                }
            }
            BorderStyle::Outset => {
                if self.color.r != 0.0 || self.color.g != 0.0 || self.color.b != 0.0 {
                    self.color.scale_rgb(scale_factor_0)
                } else {
                    ColorF::new(black_color_1, black_color_1, black_color_1, self.color.a)
                }
            }
            _ => self.color,
        }
    }
}

/// The kind of border corner clip.
#[repr(C)]
#[derive(Copy, Debug, Clone, PartialEq)]
pub enum BorderCornerClipKind {
    Dash,
    Dot,
}

/// The source data for a border corner clip mask.
#[derive(Debug, Clone)]
pub struct BorderCornerClipSource {
    pub corner_data: BorderCornerClipData,
    pub max_clip_count: usize,
    pub actual_clip_count: usize,
    kind: BorderCornerClipKind,
    widths: LayerSize,
    ellipse: Ellipse,
}

impl BorderCornerClipSource {
    pub fn new(corner_data: BorderCornerClipData,
               corner_radius: LayerSize,
               widths: LayerSize,
               kind: BorderCornerClipKind) -> BorderCornerClipSource {
        // Work out a dash length (and therefore dash count)
        // based on the width of the border edges. The "correct"
        // dash length is not mentioned in the CSS borders
        // spec. The calculation below is similar, but not exactly
        // the same as what Gecko uses.
        // TODO(gw): Iterate on this to get it closer to what Gecko
        //           uses for dash length.

        let (ellipse, max_clip_count) = match kind {
            BorderCornerClipKind::Dash => {
                let ellipse = Ellipse::new(corner_radius);

                // The desired dash length is ~3x the border width.
                let average_border_width = 0.5 * (widths.width + widths.height);
                let desired_dash_arc_length = average_border_width * 3.0;

                // Get the ideal number of dashes for that arc length.
                // This is scaled by 0.5 since there is an on/off length
                // for each dash.
                let desired_count = 0.5 * ellipse.total_arc_length / desired_dash_arc_length;

                // Round that up to the nearest integer, so that the dash length
                // doesn't exceed the ratio above. Add one extra dash to cover
                // the last half-dash of the arc.
                (ellipse, 1 + desired_count.ceil() as usize)
            }
            BorderCornerClipKind::Dot => {
                // The centers of dots follow an ellipse along the middle of the
                // border radius.
                let inner_radius = corner_radius - widths * 0.5;
                let ellipse = Ellipse::new(inner_radius);

                // Allocate a "worst case" number of dot clips. This can be
                // calculated by taking the minimum edge radius, since that
                // will result in the maximum number of dots along the path.
                let min_diameter = widths.width.min(widths.height);

                // Get the number of circles (assuming spacing of one diameter
                // between dots).
                let max_dot_count = 0.5 * ellipse.total_arc_length / min_diameter;

                // Add space for one extra dot since they are centered at the
                // start of the arc.
                (ellipse, 1 + max_dot_count.ceil() as usize)
            }
        };

        BorderCornerClipSource {
            kind: kind,
            corner_data: corner_data,
            max_clip_count: max_clip_count,
            actual_clip_count: 0,
            ellipse: ellipse,
            widths: widths,
        }
    }

    pub fn populate_gpu_data(&mut self, slice: &mut [GpuBlock32]) {
        let (header, clips) = slice.split_first_mut().unwrap();
        *header = self.corner_data.into();

        match self.kind {
            BorderCornerClipKind::Dash => {
                // Get the correct dash arc length.
                self.actual_clip_count = self.max_clip_count;
                let dash_arc_length = 0.5 * self.ellipse.total_arc_length / (self.actual_clip_count - 1) as f32;
                let mut current_arc_length = -0.5 * dash_arc_length;
                for dash_index in 0..self.actual_clip_count {
                    let arc_length0 = current_arc_length;
                    current_arc_length += dash_arc_length;

                    let arc_length1 = current_arc_length;
                    current_arc_length += dash_arc_length;

                    let dash_data = BorderCornerDashClipData::new(arc_length0,
                                                                  arc_length1,
                                                                  &self.ellipse);

                    clips[dash_index] = dash_data.into();
                }
            }
            BorderCornerClipKind::Dot => {
                let mut forward_dots = Vec::new();
                let mut back_dots = Vec::new();
                let mut leftover_arc_length = 0.0;

                // Alternate between adding dots at the start and end of the
                // ellipse arc. This ensures that we always end up with an exact
                // half dot at each end of the arc, to match up with the edges.
                forward_dots.push(DotInfo::new(0.0, self.widths.width));
                back_dots.push(DotInfo::new(self.ellipse.total_arc_length, self.widths.height));

                for dot_index in 0..self.max_clip_count {
                    let prev_forward_pos = *forward_dots.last().unwrap();
                    let prev_back_pos = *back_dots.last().unwrap();

                    // Select which end of the arc to place a dot from.
                    // This just alternates between the start and end of
                    // the arc, which ensures that there is always an
                    // exact half-dot at each end of the ellipse.
                    let going_forward = dot_index & 1 == 0;

                    let (next_dot_pos, leftover) = if going_forward {
                        let next_dot_pos = prev_forward_pos.arc_pos + 2.0 * prev_forward_pos.diameter;
                        (next_dot_pos, prev_back_pos.arc_pos - next_dot_pos)
                    } else {
                        let next_dot_pos = prev_back_pos.arc_pos - 2.0 * prev_back_pos.diameter;
                        (next_dot_pos, next_dot_pos - prev_forward_pos.arc_pos)
                    };

                    // Use a lerp between each edge's dot
                    // diameter, based on the linear distance
                    // along the arc to get the diameter of the
                    // dot at this arc position.
                    let t = next_dot_pos / self.ellipse.total_arc_length;
                    let dot_diameter = lerp(self.widths.width, self.widths.height, t);

                    // If we can't fit a dot, bail out.
                    if leftover < dot_diameter {
                        leftover_arc_length = leftover;
                        break;
                    }

                    // We can place a dot!
                    let dot = DotInfo::new(next_dot_pos, dot_diameter);
                    if going_forward {
                        forward_dots.push(dot);
                    } else {
                        back_dots.push(dot);
                    }
                }

                // Now step through the dots, and distribute any extra
                // leftover space on the arc between them evenly. Once
                // the final arc position is determined, generate the correct
                // arc positions and angles that get passed to the clip shader.
                self.actual_clip_count = 0;
                let dot_count = forward_dots.len() + back_dots.len();
                let extra_space_per_dot = leftover_arc_length / (dot_count - 1) as f32;

                for (i, dot) in forward_dots.iter().enumerate() {
                    let extra_dist = i as f32 * extra_space_per_dot;
                    let dot = BorderCornerDotClipData::new(dot.arc_pos + extra_dist,
                                                           0.5 * dot.diameter,
                                                           &self.ellipse);
                    clips[self.actual_clip_count] = dot.into();
                    self.actual_clip_count += 1;
                }

                for (i, dot) in back_dots.iter().enumerate() {
                    let extra_dist = i as f32 * extra_space_per_dot;
                    let dot = BorderCornerDotClipData::new(dot.arc_pos - extra_dist,
                                                           0.5 * dot.diameter,
                                                           &self.ellipse);
                    clips[self.actual_clip_count] = dot.into();
                    self.actual_clip_count += 1;
                }
            }
        }
    }
}

/// Represents the common GPU data for writing a
/// clip mask for a border corner.
#[derive(Debug, Copy, Clone, PartialEq)]
#[repr(C)]
pub struct BorderCornerClipData {
    /// Local space rect of the border corner.
    corner_rect: LayerRect,
    /// Local space point that is the center of the
    /// circle or ellipse that we are clipping against.
    clip_center: LayerPoint,
    /// The shader needs to know which corner, to
    /// be able to flip the dash tangents to the
    /// right orientation.
    corner: f32,        // Of type BorderCorner enum
    kind: f32,          // Of type BorderCornerClipKind enum
}

/// Represents the GPU data for drawing a single dash
/// to a clip mask. A dash clip is defined by two lines.
/// We store a point on the ellipse curve, and a tangent
/// to that point, which allows for efficient line-distance
/// calculations in the fragment shader.
#[derive(Debug, Clone)]
#[repr(C)]
pub struct BorderCornerDashClipData {
    pub point0: LayerPoint,
    pub tangent0: LayerPoint,
    pub point1: LayerPoint,
    pub tangent1: LayerPoint,
}

impl BorderCornerDashClipData {
    pub fn new(arc_length0: f32,
               arc_length1: f32,
               ellipse: &Ellipse) -> BorderCornerDashClipData {
        let alpha = ellipse.find_angle_for_arc_length(arc_length0);
        let beta = ellipse.find_angle_for_arc_length(arc_length1);

        let (p0, t0) = ellipse.get_point_and_tangent(alpha);
        let (p1, t1) = ellipse.get_point_and_tangent(beta);

        BorderCornerDashClipData {
            point0: p0,
            tangent0: t0,
            point1: p1,
            tangent1: t1,
        }
    }
}

/// Represents the GPU data for drawing a single dot
/// to a clip mask.
#[derive(Debug, Clone)]
#[repr(C)]
pub struct BorderCornerDotClipData {
    pub center: LayerPoint,
    pub radius: f32,
    pub padding: [f32; 5],
}

impl BorderCornerDotClipData {
    pub fn new(arc_length: f32,
               radius: f32,
               ellipse: &Ellipse) -> BorderCornerDotClipData {
        let theta = ellipse.find_angle_for_arc_length(arc_length);
        let (center, _) = ellipse.get_point_and_tangent(theta);

        BorderCornerDotClipData {
            center: center,
            radius: radius,
            padding: [0.0; 5],
        }
    }
}

#[derive(Copy, Clone, Debug)]
struct DotInfo {
    arc_pos: f32,
    diameter: f32,
}

impl DotInfo {
    fn new(arc_pos: f32, diameter: f32) -> DotInfo {
        DotInfo {
            arc_pos: arc_pos,
            diameter: diameter,
        }
    }
}
