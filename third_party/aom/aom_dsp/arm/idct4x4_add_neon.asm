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

    EXPORT  |aom_idct4x4_16_add_neon|
    ARM
    REQUIRE8
    PRESERVE8

    AREA ||.text||, CODE, READONLY, ALIGN=2

    AREA     Block, CODE, READONLY ; name this block of code
;void aom_idct4x4_16_add_neon(int16_t *input, uint8_t *dest, int dest_stride)
;
; r0  int16_t input
; r1  uint8_t *dest
; r2  int dest_stride)

|aom_idct4x4_16_add_neon| PROC

    ; The 2D transform is done with two passes which are actually pretty
    ; similar. We first transform the rows. This is done by transposing
    ; the inputs, doing an SIMD column transform (the columns are the
    ; transposed rows) and then transpose the results (so that it goes back
    ; in normal/row positions). Then, we transform the columns by doing
    ; another SIMD column transform.
    ; So, two passes of a transpose followed by a column transform.

    ; load the inputs into q8-q9, d16-d19
    vld1.s16        {q8,q9}, [r0]!

    ; generate scalar constants
    ; cospi_8_64 = 15137 = 0x3b21
    mov             r0, #0x3b00
    add             r0, #0x21
    ; cospi_16_64 = 11585 = 0x2d41
    mov             r3, #0x2d00
    add             r3, #0x41
    ; cospi_24_64 = 6270 = 0x 187e
    mov             r12, #0x1800
    add             r12, #0x7e

    ; transpose the input data
    ; 00 01 02 03   d16
    ; 10 11 12 13   d17
    ; 20 21 22 23   d18
    ; 30 31 32 33   d19
    vtrn.16         d16, d17
    vtrn.16         d18, d19

    ; generate constant vectors
    vdup.16         d20, r0         ; replicate cospi_8_64
    vdup.16         d21, r3         ; replicate cospi_16_64

    ; 00 10 02 12   d16
    ; 01 11 03 13   d17
    ; 20 30 22 32   d18
    ; 21 31 23 33   d19
    vtrn.32         q8, q9
    ; 00 10 20 30   d16
    ; 01 11 21 31   d17
    ; 02 12 22 32   d18
    ; 03 13 23 33   d19

    vdup.16         d22, r12        ; replicate cospi_24_64

    ; do the transform on transposed rows

    ; stage 1
    vadd.s16  d23, d16, d18         ; (input[0] + input[2])
    vsub.s16  d24, d16, d18         ; (input[0] - input[2])

    vmull.s16 q15, d17, d22         ; input[1] * cospi_24_64
    vmull.s16 q1,  d17, d20         ; input[1] * cospi_8_64

    ; (input[0] + input[2]) * cospi_16_64;
    ; (input[0] - input[2]) * cospi_16_64;
    vmull.s16 q13, d23, d21
    vmull.s16 q14, d24, d21

    ; input[1] * cospi_24_64 - input[3] * cospi_8_64;
    ; input[1] * cospi_8_64  + input[3] * cospi_24_64;
    vmlsl.s16 q15, d19, d20
    vmlal.s16 q1,  d19, d22

    ; dct_const_round_shift
    vqrshrn.s32 d26, q13, #14
    vqrshrn.s32 d27, q14, #14
    vqrshrn.s32 d29, q15, #14
    vqrshrn.s32 d28, q1,  #14

    ; stage 2
    ; output[0] = step[0] + step[3];
    ; output[1] = step[1] + step[2];
    ; output[3] = step[0] - step[3];
    ; output[2] = step[1] - step[2];
    vadd.s16 q8,  q13, q14
    vsub.s16 q9,  q13, q14
    vswp     d18, d19

    ; transpose the results
    ; 00 01 02 03   d16
    ; 10 11 12 13   d17
    ; 20 21 22 23   d18
    ; 30 31 32 33   d19
    vtrn.16         d16, d17
    vtrn.16         d18, d19
    ; 00 10 02 12   d16
    ; 01 11 03 13   d17
    ; 20 30 22 32   d18
    ; 21 31 23 33   d19
    vtrn.32         q8, q9
    ; 00 10 20 30   d16
    ; 01 11 21 31   d17
    ; 02 12 22 32   d18
    ; 03 13 23 33   d19

    ; do the transform on columns

    ; stage 1
    vadd.s16  d23, d16, d18         ; (input[0] + input[2])
    vsub.s16  d24, d16, d18         ; (input[0] - input[2])

    vmull.s16 q15, d17, d22         ; input[1] * cospi_24_64
    vmull.s16 q1,  d17, d20         ; input[1] * cospi_8_64

    ; (input[0] + input[2]) * cospi_16_64;
    ; (input[0] - input[2]) * cospi_16_64;
    vmull.s16 q13, d23, d21
    vmull.s16 q14, d24, d21

    ; input[1] * cospi_24_64 - input[3] * cospi_8_64;
    ; input[1] * cospi_8_64  + input[3] * cospi_24_64;
    vmlsl.s16 q15, d19, d20
    vmlal.s16 q1,  d19, d22

    ; dct_const_round_shift
    vqrshrn.s32 d26, q13, #14
    vqrshrn.s32 d27, q14, #14
    vqrshrn.s32 d29, q15, #14
    vqrshrn.s32 d28, q1,  #14

    ; stage 2
    ; output[0] = step[0] + step[3];
    ; output[1] = step[1] + step[2];
    ; output[3] = step[0] - step[3];
    ; output[2] = step[1] - step[2];
    vadd.s16 q8,  q13, q14
    vsub.s16 q9,  q13, q14

    ; The results are in two registers, one of them being swapped. This will
    ; be taken care of by loading the 'dest' value in a swapped fashion and
    ; also storing them in the same swapped fashion.
    ; temp_out[0, 1] = d16, d17 = q8
    ; temp_out[2, 3] = d19, d18 = q9 swapped

    ; ROUND_POWER_OF_TWO(temp_out[j], 4)
    vrshr.s16 q8, q8, #4
    vrshr.s16 q9, q9, #4

    vld1.32 {d26[0]}, [r1], r2
    vld1.32 {d26[1]}, [r1], r2
    vld1.32 {d27[1]}, [r1], r2
    vld1.32 {d27[0]}, [r1]  ; no post-increment

    ; ROUND_POWER_OF_TWO(temp_out[j], 4) + dest[j * dest_stride + i]
    vaddw.u8 q8, q8, d26
    vaddw.u8 q9, q9, d27

    ; clip_pixel
    vqmovun.s16 d26, q8
    vqmovun.s16 d27, q9

    ; do the stores in reverse order with negative post-increment, by changing
    ; the sign of the stride
    rsb r2, r2, #0
    vst1.32 {d27[0]}, [r1], r2
    vst1.32 {d27[1]}, [r1], r2
    vst1.32 {d26[1]}, [r1], r2
    vst1.32 {d26[0]}, [r1]  ; no post-increment
    bx              lr
    ENDP  ; |aom_idct4x4_16_add_neon|

    END
