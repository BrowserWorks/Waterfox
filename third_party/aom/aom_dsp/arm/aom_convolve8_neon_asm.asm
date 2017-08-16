;
; Copyright (c) 2016, Alliance for Open Media. All rights reserved
;
; This source code is subject to the terms of the BSD 2 Clause License and
; the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
; was not distributed with this source code in the LICENSE file, you can
; obtain it at www.aomedia.org/license/software. If the Alliance for Open
; Media Patent License 1.0 was not distributed with this source code in the
; PATENTS file, you can obtain it at www.aomedia.org/license/patent.
;

;


    ; These functions are only valid when:
    ; x_step_q4 == 16
    ; w%4 == 0
    ; h%4 == 0
    ; taps == 8
    ; AV1_FILTER_WEIGHT == 128
    ; AV1_FILTER_SHIFT == 7

    EXPORT  |aom_convolve8_horiz_neon|
    EXPORT  |aom_convolve8_vert_neon|
    ARM
    REQUIRE8
    PRESERVE8

    AREA ||.text||, CODE, READONLY, ALIGN=2

    ; Multiply and accumulate by q0
    MACRO
    MULTIPLY_BY_Q0 $dst, $src0, $src1, $src2, $src3, $src4, $src5, $src6, $src7
    vmull.s16 $dst, $src0, d0[0]
    vmlal.s16 $dst, $src1, d0[1]
    vmlal.s16 $dst, $src2, d0[2]
    vmlal.s16 $dst, $src3, d0[3]
    vmlal.s16 $dst, $src4, d1[0]
    vmlal.s16 $dst, $src5, d1[1]
    vmlal.s16 $dst, $src6, d1[2]
    vmlal.s16 $dst, $src7, d1[3]
    MEND

; r0    const uint8_t *src
; r1    int src_stride
; r2    uint8_t *dst
; r3    int dst_stride
; sp[]const int16_t *filter_x
; sp[]int x_step_q4
; sp[]const int16_t *filter_y ; unused
; sp[]int y_step_q4           ; unused
; sp[]int w
; sp[]int h

|aom_convolve8_horiz_neon| PROC
    push            {r4-r10, lr}

    sub             r0, r0, #3              ; adjust for taps

    ldr             r5, [sp, #32]           ; filter_x
    ldr             r6, [sp, #48]           ; w
    ldr             r7, [sp, #52]           ; h

    vld1.s16        {q0}, [r5]              ; filter_x

    sub             r8, r1, r1, lsl #2      ; -src_stride * 3
    add             r8, r8, #4              ; -src_stride * 3 + 4

    sub             r4, r3, r3, lsl #2      ; -dst_stride * 3
    add             r4, r4, #4              ; -dst_stride * 3 + 4

    rsb             r9, r6, r1, lsl #2      ; reset src for outer loop
    sub             r9, r9, #7
    rsb             r12, r6, r3, lsl #2     ; reset dst for outer loop

    mov             r10, r6                 ; w loop counter

aom_convolve8_loop_horiz_v
    vld1.8          {d24}, [r0], r1
    vld1.8          {d25}, [r0], r1
    vld1.8          {d26}, [r0], r1
    vld1.8          {d27}, [r0], r8

    vtrn.16         q12, q13
    vtrn.8          d24, d25
    vtrn.8          d26, d27

    pld             [r0, r1, lsl #2]

    vmovl.u8        q8, d24
    vmovl.u8        q9, d25
    vmovl.u8        q10, d26
    vmovl.u8        q11, d27

    ; save a few instructions in the inner loop
    vswp            d17, d18
    vmov            d23, d21

    add             r0, r0, #3

aom_convolve8_loop_horiz
    add             r5, r0, #64

    vld1.32         {d28[]}, [r0], r1
    vld1.32         {d29[]}, [r0], r1
    vld1.32         {d31[]}, [r0], r1
    vld1.32         {d30[]}, [r0], r8

    pld             [r5]

    vtrn.16         d28, d31
    vtrn.16         d29, d30
    vtrn.8          d28, d29
    vtrn.8          d31, d30

    pld             [r5, r1]

    ; extract to s16
    vtrn.32         q14, q15
    vmovl.u8        q12, d28
    vmovl.u8        q13, d29

    pld             [r5, r1, lsl #1]

    ; src[] * filter_x
    MULTIPLY_BY_Q0  q1,  d16, d17, d20, d22, d18, d19, d23, d24
    MULTIPLY_BY_Q0  q2,  d17, d20, d22, d18, d19, d23, d24, d26
    MULTIPLY_BY_Q0  q14, d20, d22, d18, d19, d23, d24, d26, d27
    MULTIPLY_BY_Q0  q15, d22, d18, d19, d23, d24, d26, d27, d25

    pld             [r5, -r8]

    ; += 64 >> 7
    vqrshrun.s32    d2, q1, #7
    vqrshrun.s32    d3, q2, #7
    vqrshrun.s32    d4, q14, #7
    vqrshrun.s32    d5, q15, #7

    ; saturate
    vqmovn.u16      d2, q1
    vqmovn.u16      d3, q2

    ; transpose
    vtrn.16         d2, d3
    vtrn.32         d2, d3
    vtrn.8          d2, d3

    vst1.u32        {d2[0]}, [r2@32], r3
    vst1.u32        {d3[0]}, [r2@32], r3
    vst1.u32        {d2[1]}, [r2@32], r3
    vst1.u32        {d3[1]}, [r2@32], r4

    vmov            q8,  q9
    vmov            d20, d23
    vmov            q11, q12
    vmov            q9,  q13

    subs            r6, r6, #4              ; w -= 4
    bgt             aom_convolve8_loop_horiz

    ; outer loop
    mov             r6, r10                 ; restore w counter
    add             r0, r0, r9              ; src += src_stride * 4 - w
    add             r2, r2, r12             ; dst += dst_stride * 4 - w
    subs            r7, r7, #4              ; h -= 4
    bgt aom_convolve8_loop_horiz_v

    pop             {r4-r10, pc}

    ENDP

|aom_convolve8_vert_neon| PROC
    push            {r4-r8, lr}

    ; adjust for taps
    sub             r0, r0, r1
    sub             r0, r0, r1, lsl #1

    ldr             r4, [sp, #32]           ; filter_y
    ldr             r6, [sp, #40]           ; w
    ldr             lr, [sp, #44]           ; h

    vld1.s16        {q0}, [r4]              ; filter_y

    lsl             r1, r1, #1
    lsl             r3, r3, #1

aom_convolve8_loop_vert_h
    mov             r4, r0
    add             r7, r0, r1, asr #1
    mov             r5, r2
    add             r8, r2, r3, asr #1
    mov             r12, lr                 ; h loop counter

    vld1.u32        {d16[0]}, [r4], r1
    vld1.u32        {d16[1]}, [r7], r1
    vld1.u32        {d18[0]}, [r4], r1
    vld1.u32        {d18[1]}, [r7], r1
    vld1.u32        {d20[0]}, [r4], r1
    vld1.u32        {d20[1]}, [r7], r1
    vld1.u32        {d22[0]}, [r4], r1

    vmovl.u8        q8, d16
    vmovl.u8        q9, d18
    vmovl.u8        q10, d20
    vmovl.u8        q11, d22

aom_convolve8_loop_vert
    ; always process a 4x4 block at a time
    vld1.u32        {d24[0]}, [r7], r1
    vld1.u32        {d26[0]}, [r4], r1
    vld1.u32        {d26[1]}, [r7], r1
    vld1.u32        {d24[1]}, [r4], r1

    ; extract to s16
    vmovl.u8        q12, d24
    vmovl.u8        q13, d26

    pld             [r5]
    pld             [r8]

    ; src[] * filter_y
    MULTIPLY_BY_Q0  q1,  d16, d17, d18, d19, d20, d21, d22, d24

    pld             [r5, r3]
    pld             [r8, r3]

    MULTIPLY_BY_Q0  q2,  d17, d18, d19, d20, d21, d22, d24, d26

    pld             [r7]
    pld             [r4]

    MULTIPLY_BY_Q0  q14, d18, d19, d20, d21, d22, d24, d26, d27

    pld             [r7, r1]
    pld             [r4, r1]

    MULTIPLY_BY_Q0  q15, d19, d20, d21, d22, d24, d26, d27, d25

    ; += 64 >> 7
    vqrshrun.s32    d2, q1, #7
    vqrshrun.s32    d3, q2, #7
    vqrshrun.s32    d4, q14, #7
    vqrshrun.s32    d5, q15, #7

    ; saturate
    vqmovn.u16      d2, q1
    vqmovn.u16      d3, q2

    vst1.u32        {d2[0]}, [r5@32], r3
    vst1.u32        {d2[1]}, [r8@32], r3
    vst1.u32        {d3[0]}, [r5@32], r3
    vst1.u32        {d3[1]}, [r8@32], r3

    vmov            q8, q10
    vmov            d18, d22
    vmov            d19, d24
    vmov            q10, q13
    vmov            d22, d25

    subs            r12, r12, #4            ; h -= 4
    bgt             aom_convolve8_loop_vert

    ; outer loop
    add             r0, r0, #4
    add             r2, r2, #4
    subs            r6, r6, #4              ; w -= 4
    bgt             aom_convolve8_loop_vert_h

    pop             {r4-r8, pc}

    ENDP
    END
