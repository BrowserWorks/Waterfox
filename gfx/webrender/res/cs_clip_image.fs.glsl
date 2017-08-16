/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    float alpha = 1.f;
    vec2 local_pos = init_transform_fs(vPos, alpha);

    bool repeat_mask = false; //TODO
    vec2 clamped_mask_uv = repeat_mask ? fract(vClipMaskUv.xy) :
        clamp(vClipMaskUv.xy, vec2(0.0, 0.0), vec2(1.0, 1.0));
    vec2 source_uv = clamp(clamped_mask_uv * vClipMaskUvRect.zw + vClipMaskUvRect.xy,
        vClipMaskUvInnerRect.xy, vClipMaskUvInnerRect.zw);
    float clip_alpha = texture(sColor0, source_uv).r; //careful: texture has type A8

    oFragColor = vec4(min(alpha, clip_alpha), 1.0, 1.0, 1.0);
}
