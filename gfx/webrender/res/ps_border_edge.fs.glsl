#line 1

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    float alpha = 1.0;
#ifdef WR_FEATURE_TRANSFORM
    alpha = 0.0;
    vec2 local_pos = init_transform_fs(vLocalPos, alpha);
#else
    vec2 local_pos = vLocalPos;
#endif

    alpha = min(alpha, do_clip());

    // Find the appropriate distance to apply the step over.
    vec2 fw = fwidth(local_pos);
    float afwidth = length(fw);

    // Applies the math necessary to draw a style: double
    // border. In the case of a solid border, the vertex
    // shader sets interpolator values that make this have
    // no effect.

    // Select the x/y coord, depending on which axis this edge is.
    vec2 pos = mix(local_pos.xy, local_pos.yx, vAxisSelect);

    // Get signed distance from each of the inner edges.
    float d0 = pos.x - vEdgeDistance.x;
    float d1 = vEdgeDistance.y - pos.x;

    // SDF union to select both outer edges.
    float d = min(d0, d1);

    // Select fragment on/off based on signed distance.
    // No AA here, since we know we're on a straight edge
    // and the width is rounded to a whole CSS pixel.
    alpha = min(alpha, mix(vAlphaSelect, 1.0, d < 0.0));

    // Mix color based on first distance.
    // TODO(gw): Support AA for groove/ridge border edge with transforms.
    vec4 color = mix(vColor0, vColor1, bvec4(d0 * vEdgeDistance.y > 0.0));

    // Apply dashing / dotting parameters.

    // Get the main-axis position relative to closest dot or dash.
    float x = mod(pos.y - vClipParams.x, vClipParams.y);

    // Calculate dash alpha (on/off) based on dash length
    float dash_alpha = step(x, vClipParams.z);

    // Get the dot alpha
    vec2 dot_relative_pos = vec2(x, pos.x) - vClipParams.zw;
    float dot_distance = length(dot_relative_pos) - vClipParams.z;
    float dot_alpha = 1.0 - smoothstep(-0.5 * afwidth,
                                        0.5 * afwidth,
                                        dot_distance);

    // Select between dot/dash alpha based on clip mode.
    alpha = min(alpha, mix(dash_alpha, dot_alpha, vClipSelect));

    oFragColor = color * vec4(1.0, 1.0, 1.0, alpha);
}
