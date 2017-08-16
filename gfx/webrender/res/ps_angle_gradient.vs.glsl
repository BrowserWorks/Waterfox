#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    Primitive prim = load_primitive();
    Gradient gradient = fetch_gradient(prim.prim_index);

    VertexInfo vi = write_vertex(prim.local_rect,
                                 prim.local_clip_rect,
                                 prim.z,
                                 prim.layer,
                                 prim.task,
                                 prim.local_rect.p0);

    vPos = vi.local_pos - prim.local_rect.p0;

    vec2 start_point = gradient.start_end_point.xy;
    vec2 end_point = gradient.start_end_point.zw;
    vec2 dir = end_point - start_point;

    vStartPoint = start_point;
    vScaledDir = dir / dot(dir, dir);

    vTileSize = gradient.tile_size_repeat.xy;
    vTileRepeat = gradient.tile_size_repeat.zw;

    // V coordinate of gradient row in lookup texture.
    vGradientIndex = float(prim.user_data0);

    // The texture size of the lookup texture
    vGradientTextureSize = vec2(textureSize(sGradients, 0));

    // Whether to repeat the gradient instead of clamping.
    vGradientRepeat = float(int(gradient.extend_mode.x) == EXTEND_MODE_REPEAT);
}
