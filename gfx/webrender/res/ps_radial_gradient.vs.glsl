#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    Primitive prim = load_primitive();
    RadialGradient gradient = fetch_radial_gradient(prim.specific_prim_address);

    VertexInfo vi = write_vertex(prim.local_rect,
                                 prim.local_clip_rect,
                                 prim.z,
                                 prim.layer,
                                 prim.task,
                                 prim.local_rect);

    vPos = vi.local_pos - prim.local_rect.p0;

    vStartCenter = gradient.start_end_center.xy;
    vEndCenter = gradient.start_end_center.zw;

    vStartRadius = gradient.start_end_radius_ratio_xy_extend_mode.x;
    vEndRadius = gradient.start_end_radius_ratio_xy_extend_mode.y;

    vTileSize = gradient.tile_size_repeat.xy;
    vTileRepeat = gradient.tile_size_repeat.zw;

    // Transform all coordinates by the y scale so the
    // fragment shader can work with circles
    float ratio_xy = gradient.start_end_radius_ratio_xy_extend_mode.z;
    vPos.y *= ratio_xy;
    vStartCenter.y *= ratio_xy;
    vEndCenter.y *= ratio_xy;
    vTileSize.y *= ratio_xy;
    vTileRepeat.y *= ratio_xy;

    vGradientAddress = prim.specific_prim_address + VECS_PER_GRADIENT;

    // Whether to repeat the gradient instead of clamping.
    vGradientRepeat = float(int(gradient.start_end_radius_ratio_xy_extend_mode.w) == EXTEND_MODE_REPEAT);
}
