/*
 * Copyright (c) 2016, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#ifndef AOM_AV1_ENCODER_TEMPORAL_FILTER_H_
#define AOM_AV1_ENCODER_TEMPORAL_FILTER_H_

#ifdef __cplusplus
extern "C" {
#endif

// TODO(any): These two variables are only used in avx2, sse2, sse4
// implementations, where the block size is still hard coded. This should be
// fixed to align with the c implementation.
#define BH 32
#define BW 32

// Block size used in temporal filtering.
#define TF_BLOCK_SIZE BLOCK_32X32

// Window size for YUV temporal filtering.
// This is particually used for function `av1_apply_temporal_filter_yuv()`.
#define TF_YUV_FILTER_WINDOW_LENGTH 3
// A scale factor used in YUV temporal filtering for weight adjustment.
#define TF_YUV_FILTER_WEIGHT_SCALE 3

#define TF_ENABLE_PLANEWISE_STRATEGY 1
// Window size for plane-wise temporal filtering.
// This is particually used for function `av1_apply_temporal_filter_planewise()`
#define TF_PLANEWISE_FILTER_WINDOW_LENGTH 5
// A scale factor used in plane-wise temporal filtering to raise the filter
// weight from `double` with range [0, 1] to `int` with range [0, 1000].
#define TF_PLANEWISE_FILTER_WEIGHT_SCALE 1000

#define NOISE_ESTIMATION_EDGE_THRESHOLD 50
// Estimates noise level from a given frame using a single plane (Y, U, or V).
// This is an adaptation of the mehtod in the following paper:
// Shen-Chuan Tai, Shih-Ming Yang, "A fast method for image noise
// estimation using Laplacian operator and adaptive edge detection",
// Proc. 3rd International Symposium on Communications, Control and
// Signal Processing, 2008, St Julians, Malta.
// Inputs:
//   frame: Pointer to the frame to estimate noise level from.
//   plane: Index of the plane used for noise estimation. Commonly, 0 for
//          Y-plane, 1 for U-plane, and 2 for V-plane.
//   bit_depth: Actual bit-depth instead of the encoding bit-depth of the frame.
// Returns:
//   The estimated noise, or -1.0 if there are too few smooth pixels.
double av1_estimate_noise_from_single_plane(const YV12_BUFFER_CONFIG *frame,
                                            const int plane,
                                            const int bit_depth);

#define TF_QINDEX 128  // Q-index used in temporal filtering.
#define TF_NUM_FILTERING_FRAMES_FOR_KEY_FRAME 7
// Performs temporal filtering if needed.
// NOTE: In this function, the lookahead index is different from the 0-based
// real index. For example, if we want to filter the first frame in the
// pre-fetched buffer `cpi->lookahead`, the lookahead index will be -1 instead
// of 0. More concretely, 0 indicates the first LOOKAHEAD frame, which is the
// second frame in the pre-fetched buffer. Another example: if we want to filter
// the 17-th frame, which is an ARF, the lookahead index is 15 instead of 16.
// Futhermore, negative number is used for key frame in one-pass mode, where key
// frame is filtered with the frames before it instead of after it. For example,
// -15 means to filter the 17-th frame, which is a key frame in one-pass mode.
// Inputs:
//   cpi: Pointer to the composed information of input video.
//   filter_frame_lookahead_idx: The index of the to-filter frame in the
//                               lookahead buffer `cpi->lookahead`.
//   show_existing_arf: Whether to show existing ARF. This field will be updated
//                      in this function.
// Returns:
//   Whether temporal filtering is successfully done.
int av1_temporal_filter(AV1_COMP *cpi, const int filter_frame_lookahead_idx,
                        int *show_existing_arf);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_TEMPORAL_FILTER_H_
