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

#include <limits.h>
#include <float.h>
#include <math.h>
#include <stdio.h>

#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"
#include "config/aom_scale_rtcd.h"
#include "config/av1_rtcd.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_dsp/aom_filter.h"
#if CONFIG_DENOISE
#include "aom_dsp/grain_table.h"
#include "aom_dsp/noise_util.h"
#include "aom_dsp/noise_model.h"
#endif
#include "aom_dsp/psnr.h"
#if CONFIG_INTERNAL_STATS
#include "aom_dsp/ssim.h"
#endif
#include "aom_ports/aom_timer.h"
#include "aom_ports/mem.h"
#include "aom_ports/system_state.h"
#include "aom_scale/aom_scale.h"
#if CONFIG_BITSTREAM_DEBUG
#include "aom_util/debug_util.h"
#endif  // CONFIG_BITSTREAM_DEBUG

#include "av1/common/alloccommon.h"
#include "av1/common/cdef.h"
#include "av1/common/filter.h"
#include "av1/common/idct.h"
#include "av1/common/reconinter.h"
#include "av1/common/reconintra.h"
#include "av1/common/resize.h"
#include "av1/common/tile_common.h"

#include "av1/encoder/av1_multi_thread.h"
#include "av1/encoder/aq_complexity.h"
#include "av1/encoder/aq_cyclicrefresh.h"
#include "av1/encoder/aq_variance.h"
#include "av1/encoder/bitstream.h"
#include "av1/encoder/context_tree.h"
#include "av1/encoder/encodeframe.h"
#include "av1/encoder/encodemv.h"
#include "av1/encoder/encode_strategy.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/encodetxb.h"
#include "av1/encoder/ethread.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/grain_test_vectors.h"
#include "av1/encoder/hash_motion.h"
#include "av1/encoder/mv_prec.h"
#include "av1/encoder/pass2_strategy.h"
#include "av1/encoder/picklpf.h"
#include "av1/encoder/pickrst.h"
#include "av1/encoder/random.h"
#include "av1/encoder/ratectrl.h"
#include "av1/encoder/rd.h"
#include "av1/encoder/rdopt.h"
#include "av1/encoder/segmentation.h"
#include "av1/encoder/speed_features.h"
#include "av1/encoder/tpl_model.h"
#include "av1/encoder/reconinter_enc.h"
#include "av1/encoder/var_based_part.h"

#if CONFIG_TUNE_VMAF
#include "av1/encoder/tune_vmaf.h"
#endif

#define DEFAULT_EXPLICIT_ORDER_HINT_BITS 7

#if CONFIG_ENTROPY_STATS
FRAME_COUNTS aggregate_fc;
#endif  // CONFIG_ENTROPY_STATS

#define AM_SEGMENT_ID_INACTIVE 7
#define AM_SEGMENT_ID_ACTIVE 0

// #define OUTPUT_YUV_REC
#ifdef OUTPUT_YUV_SKINMAP
FILE *yuv_skinmap_file = NULL;
#endif
#ifdef OUTPUT_YUV_REC
FILE *yuv_rec_file;
#define FILE_NAME_LEN 100
#endif

const int default_tx_type_probs[FRAME_UPDATE_TYPES][TX_SIZES_ALL][TX_TYPES] = {
  { { 221, 189, 214, 292, 0, 0, 0, 0, 0, 2, 38, 68, 0, 0, 0, 0 },
    { 262, 203, 216, 239, 0, 0, 0, 0, 0, 1, 37, 66, 0, 0, 0, 0 },
    { 315, 231, 239, 226, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 222, 188, 214, 287, 0, 0, 0, 0, 0, 2, 50, 61, 0, 0, 0, 0 },
    { 256, 182, 205, 282, 0, 0, 0, 0, 0, 2, 21, 76, 0, 0, 0, 0 },
    { 281, 214, 217, 222, 0, 0, 0, 0, 0, 1, 48, 41, 0, 0, 0, 0 },
    { 263, 194, 225, 225, 0, 0, 0, 0, 0, 2, 15, 100, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 170, 192, 242, 293, 0, 0, 0, 0, 0, 1, 68, 58, 0, 0, 0, 0 },
    { 199, 210, 213, 291, 0, 0, 0, 0, 0, 1, 14, 96, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } },
  { { 106, 69, 107, 278, 9, 15, 20, 45, 49, 23, 23, 88, 36, 74, 25, 57 },
    { 105, 72, 81, 98, 45, 49, 47, 50, 56, 72, 30, 81, 33, 95, 27, 83 },
    { 211, 105, 109, 120, 57, 62, 43, 49, 52, 58, 42, 116, 0, 0, 0, 0 },
    { 1008, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 131, 57, 98, 172, 19, 40, 37, 64, 69, 22, 41, 52, 51, 77, 35, 59 },
    { 176, 83, 93, 202, 22, 24, 28, 47, 50, 16, 12, 93, 26, 76, 17, 59 },
    { 136, 72, 89, 95, 46, 59, 47, 56, 61, 68, 35, 51, 32, 82, 26, 69 },
    { 122, 80, 87, 105, 49, 47, 46, 46, 57, 52, 13, 90, 19, 103, 15, 93 },
    { 1009, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0 },
    { 1011, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 202, 20, 84, 114, 14, 60, 41, 79, 99, 21, 41, 15, 50, 84, 34, 66 },
    { 196, 44, 23, 72, 30, 22, 28, 57, 67, 13, 4, 165, 15, 148, 9, 131 },
    { 882, 0, 0, 0, 0, 0, 0, 0, 0, 142, 0, 0, 0, 0, 0, 0 },
    { 840, 0, 0, 0, 0, 0, 0, 0, 0, 184, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } },
  { { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 } },
  { { 213, 110, 141, 269, 12, 16, 15, 19, 21, 11, 38, 68, 22, 29, 16, 24 },
    { 216, 119, 128, 143, 38, 41, 26, 30, 31, 30, 42, 70, 23, 36, 19, 32 },
    { 367, 149, 154, 154, 38, 35, 17, 21, 21, 10, 22, 36, 0, 0, 0, 0 },
    { 1022, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 219, 96, 127, 191, 21, 40, 25, 32, 34, 18, 45, 45, 33, 39, 26, 33 },
    { 296, 99, 122, 198, 23, 21, 19, 24, 25, 13, 20, 64, 23, 32, 18, 27 },
    { 275, 128, 142, 143, 35, 48, 23, 30, 29, 18, 42, 36, 18, 23, 14, 20 },
    { 239, 132, 166, 175, 36, 27, 19, 21, 24, 14, 13, 85, 9, 31, 8, 25 },
    { 1022, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 },
    { 1022, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 309, 25, 79, 59, 25, 80, 34, 53, 61, 25, 49, 23, 43, 64, 36, 59 },
    { 270, 57, 40, 54, 50, 42, 41, 53, 56, 28, 17, 81, 45, 86, 34, 70 },
    { 1005, 0, 0, 0, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0, 0 },
    { 992, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } },
  { { 133, 63, 55, 83, 57, 87, 58, 72, 68, 16, 24, 35, 29, 105, 25, 114 },
    { 131, 75, 74, 60, 71, 77, 65, 66, 73, 33, 21, 79, 20, 83, 18, 78 },
    { 276, 95, 82, 58, 86, 93, 63, 60, 64, 17, 38, 92, 0, 0, 0, 0 },
    { 1006, 0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 147, 49, 75, 78, 50, 97, 60, 67, 76, 17, 42, 35, 31, 93, 27, 80 },
    { 157, 49, 58, 75, 61, 52, 56, 67, 69, 12, 15, 79, 24, 119, 11, 120 },
    { 178, 69, 83, 77, 69, 85, 72, 77, 77, 20, 35, 40, 25, 48, 23, 46 },
    { 174, 55, 64, 57, 73, 68, 62, 61, 75, 15, 12, 90, 17, 99, 16, 86 },
    { 1008, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0 },
    { 1018, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 266, 31, 63, 64, 21, 52, 39, 54, 63, 30, 52, 31, 48, 89, 46, 75 },
    { 272, 26, 32, 44, 29, 31, 32, 53, 51, 13, 13, 88, 22, 153, 16, 149 },
    { 923, 0, 0, 0, 0, 0, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0 },
    { 969, 0, 0, 0, 0, 0, 0, 0, 0, 55, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } },
  { { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 },
    { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64 } },
  { { 158, 92, 125, 298, 12, 15, 20, 29, 31, 12, 29, 67, 34, 44, 23, 35 },
    { 147, 94, 103, 123, 45, 48, 38, 41, 46, 48, 37, 78, 33, 63, 27, 53 },
    { 268, 126, 125, 136, 54, 53, 31, 38, 38, 33, 35, 87, 0, 0, 0, 0 },
    { 1018, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 159, 72, 103, 194, 20, 35, 37, 50, 56, 21, 39, 40, 51, 61, 38, 48 },
    { 259, 86, 95, 188, 32, 20, 25, 34, 37, 13, 12, 85, 25, 53, 17, 43 },
    { 189, 99, 113, 123, 45, 59, 37, 46, 48, 44, 39, 41, 31, 47, 26, 37 },
    { 175, 110, 113, 128, 58, 38, 33, 33, 43, 29, 13, 100, 14, 68, 12, 57 },
    { 1017, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0 },
    { 1019, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 208, 22, 84, 101, 21, 59, 44, 70, 90, 25, 59, 13, 64, 67, 49, 48 },
    { 277, 52, 32, 63, 43, 26, 33, 48, 54, 11, 6, 130, 18, 119, 11, 101 },
    { 963, 0, 0, 0, 0, 0, 0, 0, 0, 61, 0, 0, 0, 0, 0, 0 },
    { 979, 0, 0, 0, 0, 0, 0, 0, 0, 45, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } }
};

const int default_obmc_probs[FRAME_UPDATE_TYPES][BLOCK_SIZES_ALL] = {
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0,  0,  0,  106, 90, 90, 97, 67, 59, 70, 28,
    30, 38, 16, 16,  16, 0,  0,  44, 50, 26, 25 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0,  0,  0,  98, 93, 97, 68, 82, 85, 33, 30,
    33, 16, 16, 16, 16, 0,  0,  43, 37, 26, 16 },
  { 0,  0,  0,  91, 80, 76, 78, 55, 49, 24, 16,
    16, 16, 16, 16, 16, 0,  0,  29, 45, 16, 38 },
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
  { 0,  0,  0,  103, 89, 89, 89, 62, 63, 76, 34,
    35, 32, 19, 16,  16, 0,  0,  49, 55, 29, 19 }
};

const int default_warped_probs[FRAME_UPDATE_TYPES] = { 64, 64, 64, 64,
                                                       64, 64, 64 };

// TODO(yunqing): the default probs can be trained later from better
// performance.
const int default_switchable_interp_probs[FRAME_UPDATE_TYPES]
                                         [SWITCHABLE_FILTER_CONTEXTS]
                                         [SWITCHABLE_FILTERS] = {
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } },
                                           { { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 },
                                             { 512, 512, 512 } }
                                         };

static INLINE void Scale2Ratio(AOM_SCALING mode, int *hr, int *hs) {
  switch (mode) {
    case NORMAL:
      *hr = 1;
      *hs = 1;
      break;
    case FOURFIVE:
      *hr = 4;
      *hs = 5;
      break;
    case THREEFIVE:
      *hr = 3;
      *hs = 5;
      break;
    case ONETWO:
      *hr = 1;
      *hs = 2;
      break;
    default:
      *hr = 1;
      *hs = 1;
      assert(0);
      break;
  }
}

// Mark all inactive blocks as active. Other segmentation features may be set
// so memset cannot be used, instead only inactive blocks should be reset.
static void suppress_active_map(AV1_COMP *cpi) {
  unsigned char *const seg_map = cpi->enc_seg.map;
  int i;
  if (cpi->active_map.enabled || cpi->active_map.update)
    for (i = 0;
         i < cpi->common.mi_params.mi_rows * cpi->common.mi_params.mi_cols; ++i)
      if (seg_map[i] == AM_SEGMENT_ID_INACTIVE)
        seg_map[i] = AM_SEGMENT_ID_ACTIVE;
}

static void apply_active_map(AV1_COMP *cpi) {
  struct segmentation *const seg = &cpi->common.seg;
  unsigned char *const seg_map = cpi->enc_seg.map;
  const unsigned char *const active_map = cpi->active_map.map;
  int i;

  assert(AM_SEGMENT_ID_ACTIVE == CR_SEGMENT_ID_BASE);

  if (frame_is_intra_only(&cpi->common)) {
    cpi->active_map.enabled = 0;
    cpi->active_map.update = 1;
  }

  if (cpi->active_map.update) {
    if (cpi->active_map.enabled) {
      for (i = 0;
           i < cpi->common.mi_params.mi_rows * cpi->common.mi_params.mi_cols;
           ++i)
        if (seg_map[i] == AM_SEGMENT_ID_ACTIVE) seg_map[i] = active_map[i];
      av1_enable_segmentation(seg);
      av1_enable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_SKIP);
      av1_enable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_H);
      av1_enable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_V);
      av1_enable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_U);
      av1_enable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_V);

      av1_set_segdata(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_H,
                      -MAX_LOOP_FILTER);
      av1_set_segdata(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_V,
                      -MAX_LOOP_FILTER);
      av1_set_segdata(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_U,
                      -MAX_LOOP_FILTER);
      av1_set_segdata(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_V,
                      -MAX_LOOP_FILTER);
    } else {
      av1_disable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_SKIP);
      av1_disable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_H);
      av1_disable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_Y_V);
      av1_disable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_U);
      av1_disable_segfeature(seg, AM_SEGMENT_ID_INACTIVE, SEG_LVL_ALT_LF_V);
      if (seg->enabled) {
        seg->update_data = 1;
        seg->update_map = 1;
      }
    }
    cpi->active_map.update = 0;
  }
}

int av1_set_active_map(AV1_COMP *cpi, unsigned char *new_map_16x16, int rows,
                       int cols) {
  const CommonModeInfoParams *const mi_params = &cpi->common.mi_params;
  if (rows == mi_params->mb_rows && cols == mi_params->mb_cols) {
    unsigned char *const active_map_8x8 = cpi->active_map.map;
    const int mi_rows = mi_params->mi_rows;
    const int mi_cols = mi_params->mi_cols;
    const int row_scale = mi_size_high[BLOCK_16X16] == 2 ? 1 : 2;
    const int col_scale = mi_size_wide[BLOCK_16X16] == 2 ? 1 : 2;
    cpi->active_map.update = 1;
    if (new_map_16x16) {
      int r, c;
      for (r = 0; r < mi_rows; ++r) {
        for (c = 0; c < mi_cols; ++c) {
          active_map_8x8[r * mi_cols + c] =
              new_map_16x16[(r >> row_scale) * cols + (c >> col_scale)]
                  ? AM_SEGMENT_ID_ACTIVE
                  : AM_SEGMENT_ID_INACTIVE;
        }
      }
      cpi->active_map.enabled = 1;
    } else {
      cpi->active_map.enabled = 0;
    }
    return 0;
  } else {
    return -1;
  }
}

int av1_get_active_map(AV1_COMP *cpi, unsigned char *new_map_16x16, int rows,
                       int cols) {
  const CommonModeInfoParams *const mi_params = &cpi->common.mi_params;
  if (rows == mi_params->mb_rows && cols == mi_params->mb_cols &&
      new_map_16x16) {
    unsigned char *const seg_map_8x8 = cpi->enc_seg.map;
    const int mi_rows = mi_params->mi_rows;
    const int mi_cols = mi_params->mi_cols;
    const int row_scale = mi_size_high[BLOCK_16X16] == 2 ? 1 : 2;
    const int col_scale = mi_size_wide[BLOCK_16X16] == 2 ? 1 : 2;

    memset(new_map_16x16, !cpi->active_map.enabled, rows * cols);
    if (cpi->active_map.enabled) {
      int r, c;
      for (r = 0; r < mi_rows; ++r) {
        for (c = 0; c < mi_cols; ++c) {
          // Cyclic refresh segments are considered active despite not having
          // AM_SEGMENT_ID_ACTIVE
          new_map_16x16[(r >> row_scale) * cols + (c >> col_scale)] |=
              seg_map_8x8[r * mi_cols + c] != AM_SEGMENT_ID_INACTIVE;
        }
      }
    }
    return 0;
  } else {
    return -1;
  }
}

// Compute the horizontal frequency components' energy in a frame
// by calculuating the 16x4 Horizontal DCT. This is to be used to
// decide the superresolution parameters.
static void analyze_hor_freq(const AV1_COMP *cpi, double *energy) {
  uint64_t freq_energy[16] = { 0 };
  const YV12_BUFFER_CONFIG *buf = cpi->source;
  const int bd = cpi->td.mb.e_mbd.bd;
  const int width = buf->y_crop_width;
  const int height = buf->y_crop_height;
  DECLARE_ALIGNED(16, int32_t, coeff[16 * 4]);
  int n = 0;
  memset(freq_energy, 0, sizeof(freq_energy));
  if (buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    const int16_t *src16 = (const int16_t *)CONVERT_TO_SHORTPTR(buf->y_buffer);
    for (int i = 0; i < height - 4; i += 4) {
      for (int j = 0; j < width - 16; j += 16) {
        av1_fwd_txfm2d_16x4(src16 + i * buf->y_stride + j, coeff, buf->y_stride,
                            H_DCT, bd);
        for (int k = 1; k < 16; ++k) {
          const uint64_t this_energy =
              ((int64_t)coeff[k] * coeff[k]) +
              ((int64_t)coeff[k + 16] * coeff[k + 16]) +
              ((int64_t)coeff[k + 32] * coeff[k + 32]) +
              ((int64_t)coeff[k + 48] * coeff[k + 48]);
          freq_energy[k] += ROUND_POWER_OF_TWO(this_energy, 2 + 2 * (bd - 8));
        }
        n++;
      }
    }
  } else {
    assert(bd == 8);
    DECLARE_ALIGNED(16, int16_t, src16[16 * 4]);
    for (int i = 0; i < height - 4; i += 4) {
      for (int j = 0; j < width - 16; j += 16) {
        for (int ii = 0; ii < 4; ++ii)
          for (int jj = 0; jj < 16; ++jj)
            src16[ii * 16 + jj] =
                buf->y_buffer[(i + ii) * buf->y_stride + (j + jj)];
        av1_fwd_txfm2d_16x4(src16, coeff, 16, H_DCT, bd);
        for (int k = 1; k < 16; ++k) {
          const uint64_t this_energy =
              ((int64_t)coeff[k] * coeff[k]) +
              ((int64_t)coeff[k + 16] * coeff[k + 16]) +
              ((int64_t)coeff[k + 32] * coeff[k + 32]) +
              ((int64_t)coeff[k + 48] * coeff[k + 48]);
          freq_energy[k] += ROUND_POWER_OF_TWO(this_energy, 2);
        }
        n++;
      }
    }
  }
  if (n) {
    for (int k = 1; k < 16; ++k) energy[k] = (double)freq_energy[k] / n;
    // Convert to cumulative energy
    for (int k = 14; k > 0; --k) energy[k] += energy[k + 1];
  } else {
    for (int k = 1; k < 16; ++k) energy[k] = 1e+20;
  }
}

static BLOCK_SIZE select_sb_size(const AV1_COMP *const cpi) {
  const AV1_COMMON *const cm = &cpi->common;

  if (cpi->oxcf.superblock_size == AOM_SUPERBLOCK_SIZE_64X64)
    return BLOCK_64X64;
  if (cpi->oxcf.superblock_size == AOM_SUPERBLOCK_SIZE_128X128)
    return BLOCK_128X128;

  assert(cpi->oxcf.superblock_size == AOM_SUPERBLOCK_SIZE_DYNAMIC);

  if (cpi->svc.number_spatial_layers > 1) {
    // Use the configured size (top resolution) for spatial layers.
    return AOMMIN(cpi->oxcf.width, cpi->oxcf.height) > 480 ? BLOCK_128X128
                                                           : BLOCK_64X64;
  }

  // TODO(any): Possibly could improve this with a heuristic.
  // When superres / resize is on, 'cm->width / height' can change between
  // calls, so we don't apply this heuristic there.
  // Things break if superblock size changes between the first pass and second
  // pass encoding, which is why this heuristic is not configured as a
  // speed-feature.
  if (cpi->oxcf.superres_mode == SUPERRES_NONE &&
      cpi->oxcf.resize_mode == RESIZE_NONE && cpi->oxcf.speed >= 1) {
    return AOMMIN(cm->width, cm->height) > 480 ? BLOCK_128X128 : BLOCK_64X64;
  }

  return BLOCK_128X128;
}

static void setup_frame(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  // Set up entropy context depending on frame type. The decoder mandates
  // the use of the default context, index 0, for keyframes and inter
  // frames where the error_resilient_mode or intra_only flag is set. For
  // other inter-frames the encoder currently uses only two contexts;
  // context 1 for ALTREF frames and context 0 for the others.

  if (frame_is_intra_only(cm) || cm->features.error_resilient_mode ||
      cpi->ext_flags.use_primary_ref_none) {
    av1_setup_past_independence(cm);
  }

  if ((cm->current_frame.frame_type == KEY_FRAME && cm->show_frame) ||
      frame_is_sframe(cm)) {
    if (!cpi->seq_params_locked) {
      set_sb_size(&cm->seq_params, select_sb_size(cpi));
    }
  } else {
    const RefCntBuffer *const primary_ref_buf = get_primary_ref_frame_buf(cm);
    if (primary_ref_buf == NULL) {
      av1_setup_past_independence(cm);
      cm->seg.update_map = 1;
      cm->seg.update_data = 1;
    } else {
      *cm->fc = primary_ref_buf->frame_context;
    }
  }

  av1_zero(cm->cur_frame->interp_filter_selected);
  cm->prev_frame = get_primary_ref_frame_buf(cm);
  cpi->vaq_refresh = 0;
}

static void set_mb_mi(CommonModeInfoParams *mi_params, int width, int height) {
  // Ensure that the decoded width and height are both multiples of
  // 8 luma pixels (note: this may only be a multiple of 4 chroma pixels if
  // subsampling is used).
  // This simplifies the implementation of various experiments,
  // eg. cdef, which operates on units of 8x8 luma pixels.
  const int aligned_width = ALIGN_POWER_OF_TWO(width, 3);
  const int aligned_height = ALIGN_POWER_OF_TWO(height, 3);

  mi_params->mi_cols = aligned_width >> MI_SIZE_LOG2;
  mi_params->mi_rows = aligned_height >> MI_SIZE_LOG2;
  mi_params->mi_stride = calc_mi_size(mi_params->mi_cols);

  mi_params->mb_cols = (mi_params->mi_cols + 2) >> 2;
  mi_params->mb_rows = (mi_params->mi_rows + 2) >> 2;
  mi_params->MBs = mi_params->mb_rows * mi_params->mb_cols;

  const int mi_alloc_size_1d = mi_size_wide[mi_params->mi_alloc_bsize];
  mi_params->mi_alloc_stride =
      (mi_params->mi_stride + mi_alloc_size_1d - 1) / mi_alloc_size_1d;

  assert(mi_size_wide[mi_params->mi_alloc_bsize] ==
         mi_size_high[mi_params->mi_alloc_bsize]);

#if CONFIG_LPF_MASK
  av1_alloc_loop_filter_mask(mi_params);
#endif
}

static void enc_set_mb_mi(CommonModeInfoParams *mi_params, int width,
                          int height) {
  const int is_4k_or_larger = AOMMIN(width, height) >= 2160;
  mi_params->mi_alloc_bsize = is_4k_or_larger ? BLOCK_8X8 : BLOCK_4X4;

  set_mb_mi(mi_params, width, height);
}

static void stat_stage_set_mb_mi(CommonModeInfoParams *mi_params, int width,
                                 int height) {
  mi_params->mi_alloc_bsize = BLOCK_16X16;

  set_mb_mi(mi_params, width, height);
}

static void enc_setup_mi(CommonModeInfoParams *mi_params) {
  const int mi_grid_size =
      mi_params->mi_stride * calc_mi_size(mi_params->mi_rows);
  memset(mi_params->mi_alloc, 0,
         mi_params->mi_alloc_size * sizeof(*mi_params->mi_alloc));
  memset(mi_params->mi_grid_base, 0,
         mi_grid_size * sizeof(*mi_params->mi_grid_base));
  memset(mi_params->tx_type_map, 0,
         mi_grid_size * sizeof(*mi_params->tx_type_map));
}

static void enc_free_mi(CommonModeInfoParams *mi_params) {
  aom_free(mi_params->mi_alloc);
  mi_params->mi_alloc = NULL;
  aom_free(mi_params->mi_grid_base);
  mi_params->mi_grid_base = NULL;
  mi_params->mi_alloc_size = 0;
  aom_free(mi_params->tx_type_map);
  mi_params->tx_type_map = NULL;
}

void av1_initialize_enc(void) {
  av1_rtcd();
  aom_dsp_rtcd();
  aom_scale_rtcd();
  av1_init_intra_predictors();
  av1_init_me_luts();
  av1_rc_init_minq_luts();
  av1_init_wedge_masks();
}

static void dealloc_context_buffers_ext(MBMIExtFrameBufferInfo *mbmi_ext_info) {
  if (mbmi_ext_info->frame_base) {
    aom_free(mbmi_ext_info->frame_base);
    mbmi_ext_info->frame_base = NULL;
    mbmi_ext_info->alloc_size = 0;
  }
}

static void alloc_context_buffers_ext(AV1_COMMON *cm,
                                      MBMIExtFrameBufferInfo *mbmi_ext_info) {
  const CommonModeInfoParams *const mi_params = &cm->mi_params;

  const int mi_alloc_size_1d = mi_size_wide[mi_params->mi_alloc_bsize];
  const int mi_alloc_rows =
      (mi_params->mi_rows + mi_alloc_size_1d - 1) / mi_alloc_size_1d;
  const int mi_alloc_cols =
      (mi_params->mi_cols + mi_alloc_size_1d - 1) / mi_alloc_size_1d;
  const int new_ext_mi_size = mi_alloc_rows * mi_alloc_cols;

  if (new_ext_mi_size > mbmi_ext_info->alloc_size) {
    dealloc_context_buffers_ext(mbmi_ext_info);
    CHECK_MEM_ERROR(
        cm, mbmi_ext_info->frame_base,
        aom_calloc(new_ext_mi_size, sizeof(*mbmi_ext_info->frame_base)));
    mbmi_ext_info->alloc_size = new_ext_mi_size;
  }
  // The stride needs to be updated regardless of whether new allocation
  // happened or not.
  mbmi_ext_info->stride = mi_alloc_cols;
}

static void reset_film_grain_chroma_params(aom_film_grain_t *pars) {
  pars->num_cr_points = 0;
  pars->cr_mult = 0;
  pars->cr_luma_mult = 0;
  memset(pars->scaling_points_cr, 0, sizeof(pars->scaling_points_cr));
  memset(pars->ar_coeffs_cr, 0, sizeof(pars->ar_coeffs_cr));
  pars->num_cb_points = 0;
  pars->cb_mult = 0;
  pars->cb_luma_mult = 0;
  pars->chroma_scaling_from_luma = 0;
  memset(pars->scaling_points_cb, 0, sizeof(pars->scaling_points_cb));
  memset(pars->ar_coeffs_cb, 0, sizeof(pars->ar_coeffs_cb));
}

static void update_film_grain_parameters(struct AV1_COMP *cpi,
                                         const AV1EncoderConfig *oxcf) {
  AV1_COMMON *const cm = &cpi->common;
  cpi->oxcf = *oxcf;

  if (cpi->film_grain_table) {
    aom_film_grain_table_free(cpi->film_grain_table);
    aom_free(cpi->film_grain_table);
    cpi->film_grain_table = NULL;
  }

  if (oxcf->film_grain_test_vector) {
    cm->seq_params.film_grain_params_present = 1;
    if (cm->current_frame.frame_type == KEY_FRAME) {
      memcpy(&cm->film_grain_params,
             film_grain_test_vectors + oxcf->film_grain_test_vector - 1,
             sizeof(cm->film_grain_params));
      if (oxcf->monochrome)
        reset_film_grain_chroma_params(&cm->film_grain_params);
      cm->film_grain_params.bit_depth = cm->seq_params.bit_depth;
      if (cm->seq_params.color_range == AOM_CR_FULL_RANGE) {
        cm->film_grain_params.clip_to_restricted_range = 0;
      }
    }
  } else if (oxcf->film_grain_table_filename) {
    cm->seq_params.film_grain_params_present = 1;

    cpi->film_grain_table = aom_malloc(sizeof(*cpi->film_grain_table));
    memset(cpi->film_grain_table, 0, sizeof(aom_film_grain_table_t));

    aom_film_grain_table_read(cpi->film_grain_table,
                              oxcf->film_grain_table_filename, &cm->error);
  } else {
#if CONFIG_DENOISE
    cm->seq_params.film_grain_params_present = (cpi->oxcf.noise_level > 0);
#else
    cm->seq_params.film_grain_params_present = 0;
#endif
    memset(&cm->film_grain_params, 0, sizeof(cm->film_grain_params));
  }
}

static void dealloc_compressor_data(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);

  dealloc_context_buffers_ext(&cpi->mbmi_ext_info);

  aom_free(cpi->tile_data);
  cpi->tile_data = NULL;

  // Delete sementation map
  aom_free(cpi->enc_seg.map);
  cpi->enc_seg.map = NULL;

  av1_cyclic_refresh_free(cpi->cyclic_refresh);
  cpi->cyclic_refresh = NULL;

  aom_free(cpi->active_map.map);
  cpi->active_map.map = NULL;

  aom_free(cpi->ssim_rdmult_scaling_factors);
  cpi->ssim_rdmult_scaling_factors = NULL;

  aom_free(cpi->tpl_rdmult_scaling_factors);
  cpi->tpl_rdmult_scaling_factors = NULL;

  aom_free(cpi->tpl_sb_rdmult_scaling_factors);
  cpi->tpl_sb_rdmult_scaling_factors = NULL;

#if CONFIG_TUNE_VMAF
  aom_free(cpi->vmaf_rdmult_scaling_factors);
  cpi->vmaf_rdmult_scaling_factors = NULL;
#endif

  aom_free(cpi->td.mb.above_pred_buf);
  cpi->td.mb.above_pred_buf = NULL;

  aom_free(cpi->td.mb.left_pred_buf);
  cpi->td.mb.left_pred_buf = NULL;

  aom_free(cpi->td.mb.wsrc_buf);
  cpi->td.mb.wsrc_buf = NULL;

  aom_free(cpi->td.mb.inter_modes_info);
  cpi->td.mb.inter_modes_info = NULL;

  for (int i = 0; i < 2; i++)
    for (int j = 0; j < 2; j++) {
      aom_free(cpi->td.mb.intrabc_hash_info.hash_value_buffer[i][j]);
      cpi->td.mb.intrabc_hash_info.hash_value_buffer[i][j] = NULL;
    }
  aom_free(cpi->td.mb.mask_buf);
  cpi->td.mb.mask_buf = NULL;

  aom_free(cm->tpl_mvs);
  cm->tpl_mvs = NULL;

  aom_free(cpi->td.mb.mbmi_ext);
  cpi->td.mb.mbmi_ext = NULL;

  if (cpi->td.vt64x64) {
    aom_free(cpi->td.vt64x64);
    cpi->td.vt64x64 = NULL;
  }

  av1_free_ref_frame_buffers(cm->buffer_pool);
  av1_free_txb_buf(cpi);
  av1_free_context_buffers(cm);

  aom_free_frame_buffer(&cpi->last_frame_uf);
  av1_free_restoration_buffers(cm);
  aom_free_frame_buffer(&cpi->trial_frame_rst);
  aom_free_frame_buffer(&cpi->scaled_source);
  aom_free_frame_buffer(&cpi->scaled_last_source);
  aom_free_frame_buffer(&cpi->alt_ref_buffer);
  av1_lookahead_destroy(cpi->lookahead);

  aom_free(cpi->tile_tok[0][0]);
  cpi->tile_tok[0][0] = 0;

  aom_free(cpi->tplist[0][0]);
  cpi->tplist[0][0] = NULL;

  av1_free_pc_tree(cpi, &cpi->td, num_planes, cm->seq_params.sb_size);

  aom_free(cpi->td.mb.palette_buffer);
  av1_release_compound_type_rd_buffers(&cpi->td.mb.comp_rd_buffer);
  aom_free(cpi->td.mb.tmp_conv_dst);
  for (int j = 0; j < 2; ++j) {
    aom_free(cpi->td.mb.tmp_obmc_bufs[j]);
  }

#if CONFIG_DENOISE
  if (cpi->denoise_and_model) {
    aom_denoise_and_model_free(cpi->denoise_and_model);
    cpi->denoise_and_model = NULL;
  }
#endif
  if (cpi->film_grain_table) {
    aom_film_grain_table_free(cpi->film_grain_table);
    cpi->film_grain_table = NULL;
  }

  for (int i = 0; i < MAX_NUM_OPERATING_POINTS; ++i) {
    aom_free(cpi->level_params.level_info[i]);
  }

  if (cpi->use_svc) av1_free_svc_cyclic_refresh(cpi);
}

static void configure_static_seg_features(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const RATE_CONTROL *const rc = &cpi->rc;
  struct segmentation *const seg = &cm->seg;

  int high_q = (int)(rc->avg_q > 48.0);
  int qi_delta;

  // Disable and clear down for KF
  if (cm->current_frame.frame_type == KEY_FRAME) {
    // Clear down the global segmentation map
    memset(cpi->enc_seg.map, 0, cm->mi_params.mi_rows * cm->mi_params.mi_cols);
    seg->update_map = 0;
    seg->update_data = 0;

    // Disable segmentation
    av1_disable_segmentation(seg);

    // Clear down the segment features.
    av1_clearall_segfeatures(seg);
  } else if (cpi->refresh_alt_ref_frame) {
    // If this is an alt ref frame
    // Clear down the global segmentation map
    memset(cpi->enc_seg.map, 0, cm->mi_params.mi_rows * cm->mi_params.mi_cols);
    seg->update_map = 0;
    seg->update_data = 0;

    // Disable segmentation and individual segment features by default
    av1_disable_segmentation(seg);
    av1_clearall_segfeatures(seg);

    // If segmentation was enabled set those features needed for the
    // arf itself.
    if (seg->enabled) {
      seg->update_map = 1;
      seg->update_data = 1;

      qi_delta = av1_compute_qdelta(rc, rc->avg_q, rc->avg_q * 0.875,
                                    cm->seq_params.bit_depth);
      av1_set_segdata(seg, 1, SEG_LVL_ALT_Q, qi_delta - 2);
      av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_Y_H, -2);
      av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_Y_V, -2);
      av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_U, -2);
      av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_V, -2);

      av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_Y_H);
      av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_Y_V);
      av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_U);
      av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_V);

      av1_enable_segfeature(seg, 1, SEG_LVL_ALT_Q);
    }
  } else if (seg->enabled) {
    // All other frames if segmentation has been enabled

    // First normal frame in a valid gf or alt ref group
    if (rc->frames_since_golden == 0) {
      // Set up segment features for normal frames in an arf group
      if (rc->source_alt_ref_active) {
        seg->update_map = 0;
        seg->update_data = 1;

        qi_delta = av1_compute_qdelta(rc, rc->avg_q, rc->avg_q * 1.125,
                                      cm->seq_params.bit_depth);
        av1_set_segdata(seg, 1, SEG_LVL_ALT_Q, qi_delta + 2);
        av1_enable_segfeature(seg, 1, SEG_LVL_ALT_Q);

        av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_Y_H, -2);
        av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_Y_V, -2);
        av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_U, -2);
        av1_set_segdata(seg, 1, SEG_LVL_ALT_LF_V, -2);

        av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_Y_H);
        av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_Y_V);
        av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_U);
        av1_enable_segfeature(seg, 1, SEG_LVL_ALT_LF_V);

        // Segment coding disabled for compred testing
        if (high_q) {
          av1_set_segdata(seg, 1, SEG_LVL_REF_FRAME, ALTREF_FRAME);
          av1_enable_segfeature(seg, 1, SEG_LVL_REF_FRAME);
          av1_enable_segfeature(seg, 1, SEG_LVL_SKIP);
        }
      } else {
        // Disable segmentation and clear down features if alt ref
        // is not active for this group

        av1_disable_segmentation(seg);

        memset(cpi->enc_seg.map, 0,
               cm->mi_params.mi_rows * cm->mi_params.mi_cols);

        seg->update_map = 0;
        seg->update_data = 0;

        av1_clearall_segfeatures(seg);
      }
    } else if (rc->is_src_frame_alt_ref) {
      // Special case where we are coding over the top of a previous
      // alt ref frame.
      // Segment coding disabled for compred testing

      // Enable ref frame features for segment 0 as well
      av1_enable_segfeature(seg, 0, SEG_LVL_REF_FRAME);
      av1_enable_segfeature(seg, 1, SEG_LVL_REF_FRAME);

      // All mbs should use ALTREF_FRAME
      av1_clear_segdata(seg, 0, SEG_LVL_REF_FRAME);
      av1_set_segdata(seg, 0, SEG_LVL_REF_FRAME, ALTREF_FRAME);
      av1_clear_segdata(seg, 1, SEG_LVL_REF_FRAME);
      av1_set_segdata(seg, 1, SEG_LVL_REF_FRAME, ALTREF_FRAME);

      // Skip all MBs if high Q (0,0 mv and skip coeffs)
      if (high_q) {
        av1_enable_segfeature(seg, 0, SEG_LVL_SKIP);
        av1_enable_segfeature(seg, 1, SEG_LVL_SKIP);
      }
      // Enable data update
      seg->update_data = 1;
    } else {
      // All other frames.

      // No updates.. leave things as they are.
      seg->update_map = 0;
      seg->update_data = 0;
    }
  }
}

static void update_reference_segmentation_map(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  MB_MODE_INFO **mi_4x4_ptr = mi_params->mi_grid_base;
  uint8_t *cache_ptr = cm->cur_frame->seg_map;

  for (int row = 0; row < mi_params->mi_rows; row++) {
    MB_MODE_INFO **mi_4x4 = mi_4x4_ptr;
    uint8_t *cache = cache_ptr;
    for (int col = 0; col < mi_params->mi_cols; col++, mi_4x4++, cache++)
      cache[0] = mi_4x4[0]->segment_id;
    mi_4x4_ptr += mi_params->mi_stride;
    cache_ptr += mi_params->mi_cols;
  }
}

static void alloc_altref_frame_buffer(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const AV1EncoderConfig *oxcf = &cpi->oxcf;

  // TODO(agrange) Check if ARF is enabled and skip allocation if not.
  if (aom_realloc_frame_buffer(
          &cpi->alt_ref_buffer, oxcf->width, oxcf->height,
          seq_params->subsampling_x, seq_params->subsampling_y,
          seq_params->use_highbitdepth, cpi->oxcf.border_in_pixels,
          cm->features.byte_alignment, NULL, NULL, NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate altref buffer");
}

static void alloc_util_frame_buffers(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const int byte_alignment = cm->features.byte_alignment;
  if (aom_realloc_frame_buffer(
          &cpi->last_frame_uf, cm->width, cm->height, seq_params->subsampling_x,
          seq_params->subsampling_y, seq_params->use_highbitdepth,
          cpi->oxcf.border_in_pixels, byte_alignment, NULL, NULL, NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate last frame buffer");

  if (aom_realloc_frame_buffer(
          &cpi->trial_frame_rst, cm->superres_upscaled_width,
          cm->superres_upscaled_height, seq_params->subsampling_x,
          seq_params->subsampling_y, seq_params->use_highbitdepth,
          AOM_RESTORATION_FRAME_BORDER, byte_alignment, NULL, NULL, NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate trial restored frame buffer");

  if (aom_realloc_frame_buffer(
          &cpi->scaled_source, cm->width, cm->height, seq_params->subsampling_x,
          seq_params->subsampling_y, seq_params->use_highbitdepth,
          cpi->oxcf.border_in_pixels, byte_alignment, NULL, NULL, NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate scaled source buffer");

  if (aom_realloc_frame_buffer(
          &cpi->scaled_last_source, cm->width, cm->height,
          seq_params->subsampling_x, seq_params->subsampling_y,
          seq_params->use_highbitdepth, cpi->oxcf.border_in_pixels,
          byte_alignment, NULL, NULL, NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate scaled last source buffer");
}

static void alloc_compressor_data(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);

  if (av1_alloc_context_buffers(cm, cm->width, cm->height)) {
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate context buffers");
  }

  int mi_rows_aligned_to_sb =
      ALIGN_POWER_OF_TWO(cm->mi_params.mi_rows, cm->seq_params.mib_size_log2);
  int sb_rows = mi_rows_aligned_to_sb >> cm->seq_params.mib_size_log2;

  if (!is_stat_generation_stage(cpi)) {
    av1_alloc_txb_buf(cpi);

    alloc_context_buffers_ext(cm, &cpi->mbmi_ext_info);
  }

  aom_free(cpi->tile_tok[0][0]);
  aom_free(cpi->tplist[0][0]);

  if (!is_stat_generation_stage(cpi)) {
    unsigned int tokens =
        get_token_alloc(cm->mi_params.mb_rows, cm->mi_params.mb_cols,
                        MAX_SB_SIZE_LOG2, num_planes);
    CHECK_MEM_ERROR(cm, cpi->tile_tok[0][0],
                    aom_calloc(tokens, sizeof(*cpi->tile_tok[0][0])));

    CHECK_MEM_ERROR(cm, cpi->tplist[0][0],
                    aom_calloc(sb_rows * MAX_TILE_ROWS * MAX_TILE_COLS,
                               sizeof(*cpi->tplist[0][0])));
  }

  av1_setup_pc_tree(cpi, &cpi->td);
}

void av1_new_framerate(AV1_COMP *cpi, double framerate) {
  cpi->framerate = framerate < 0.1 ? 30 : framerate;
  av1_rc_update_framerate(cpi, cpi->common.width, cpi->common.height);
}

double av1_get_compression_ratio(const AV1_COMMON *const cm,
                                 size_t encoded_frame_size) {
  const int upscaled_width = cm->superres_upscaled_width;
  const int height = cm->height;
  const int luma_pic_size = upscaled_width * height;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const BITSTREAM_PROFILE profile = seq_params->profile;
  const int pic_size_profile_factor =
      profile == PROFILE_0 ? 15 : (profile == PROFILE_1 ? 30 : 36);
  encoded_frame_size =
      (encoded_frame_size > 129 ? encoded_frame_size - 128 : 1);
  const size_t uncompressed_frame_size =
      (luma_pic_size * pic_size_profile_factor) >> 3;
  return uncompressed_frame_size / (double)encoded_frame_size;
}

static void set_tile_info(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const SequenceHeader *const seq_params = &cm->seq_params;
  CommonTileParams *const tiles = &cm->tiles;
  int i, start_sb;

  av1_get_tile_limits(cm);

  // configure tile columns
  if (cpi->oxcf.tile_width_count == 0 || cpi->oxcf.tile_height_count == 0) {
    tiles->uniform_spacing = 1;
    tiles->log2_cols = AOMMAX(cpi->oxcf.tile_columns, tiles->min_log2_cols);
    tiles->log2_cols = AOMMIN(tiles->log2_cols, tiles->max_log2_cols);
  } else {
    int mi_cols =
        ALIGN_POWER_OF_TWO(mi_params->mi_cols, seq_params->mib_size_log2);
    int sb_cols = mi_cols >> seq_params->mib_size_log2;
    int size_sb, j = 0;
    tiles->uniform_spacing = 0;
    for (i = 0, start_sb = 0; start_sb < sb_cols && i < MAX_TILE_COLS; i++) {
      tiles->col_start_sb[i] = start_sb;
      size_sb = cpi->oxcf.tile_widths[j++];
      if (j >= cpi->oxcf.tile_width_count) j = 0;
      start_sb += AOMMIN(size_sb, tiles->max_width_sb);
    }
    tiles->cols = i;
    tiles->col_start_sb[i] = sb_cols;
  }
  av1_calculate_tile_cols(seq_params, mi_params->mi_rows, mi_params->mi_cols,
                          tiles);

  // configure tile rows
  if (tiles->uniform_spacing) {
    tiles->log2_rows = AOMMAX(cpi->oxcf.tile_rows, tiles->min_log2_rows);
    tiles->log2_rows = AOMMIN(tiles->log2_rows, tiles->max_log2_rows);
  } else {
    int mi_rows =
        ALIGN_POWER_OF_TWO(mi_params->mi_rows, seq_params->mib_size_log2);
    int sb_rows = mi_rows >> seq_params->mib_size_log2;
    int size_sb, j = 0;
    for (i = 0, start_sb = 0; start_sb < sb_rows && i < MAX_TILE_ROWS; i++) {
      tiles->row_start_sb[i] = start_sb;
      size_sb = cpi->oxcf.tile_heights[j++];
      if (j >= cpi->oxcf.tile_height_count) j = 0;
      start_sb += AOMMIN(size_sb, tiles->max_height_sb);
    }
    tiles->rows = i;
    tiles->row_start_sb[i] = sb_rows;
  }
  av1_calculate_tile_rows(seq_params, mi_params->mi_rows, tiles);
}

static void update_frame_size(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  MACROBLOCKD *const xd = &cpi->td.mb.e_mbd;

  // We need to reallocate the context buffers here in case we need more mis.
  if (av1_alloc_context_buffers(cm, cm->width, cm->height)) {
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate context buffers");
  }
  av1_init_mi_buffers(&cm->mi_params);

  av1_init_macroblockd(cm, xd, NULL);

  if (!is_stat_generation_stage(cpi))
    alloc_context_buffers_ext(cm, &cpi->mbmi_ext_info);
  set_tile_info(cpi);
}

static void init_buffer_indices(ForceIntegerMVInfo *const force_intpel_info,
                                int *const remapped_ref_idx) {
  int fb_idx;
  for (fb_idx = 0; fb_idx < REF_FRAMES; ++fb_idx)
    remapped_ref_idx[fb_idx] = fb_idx;
  force_intpel_info->rate_index = 0;
  force_intpel_info->rate_size = 0;
}

static INLINE int does_level_match(int width, int height, double fps,
                                   int lvl_width, int lvl_height,
                                   double lvl_fps, int lvl_dim_mult) {
  const int64_t lvl_luma_pels = lvl_width * lvl_height;
  const double lvl_display_sample_rate = lvl_luma_pels * lvl_fps;
  const int64_t luma_pels = width * height;
  const double display_sample_rate = luma_pels * fps;
  return luma_pels <= lvl_luma_pels &&
         display_sample_rate <= lvl_display_sample_rate &&
         width <= lvl_width * lvl_dim_mult &&
         height <= lvl_height * lvl_dim_mult;
}

static void set_bitstream_level_tier(SequenceHeader *seq, AV1_COMMON *cm,
                                     const AV1EncoderConfig *oxcf) {
  // TODO(any): This is a placeholder function that only addresses dimensions
  // and max display sample rates.
  // Need to add checks for max bit rate, max decoded luma sample rate, header
  // rate, etc. that are not covered by this function.
  AV1_LEVEL level = SEQ_LEVEL_MAX;
  if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate, 512,
                       288, 30.0, 4)) {
    level = SEQ_LEVEL_2_0;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              704, 396, 30.0, 4)) {
    level = SEQ_LEVEL_2_1;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              1088, 612, 30.0, 4)) {
    level = SEQ_LEVEL_3_0;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              1376, 774, 30.0, 4)) {
    level = SEQ_LEVEL_3_1;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              2048, 1152, 30.0, 3)) {
    level = SEQ_LEVEL_4_0;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              2048, 1152, 60.0, 3)) {
    level = SEQ_LEVEL_4_1;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              4096, 2176, 30.0, 2)) {
    level = SEQ_LEVEL_5_0;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              4096, 2176, 60.0, 2)) {
    level = SEQ_LEVEL_5_1;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              4096, 2176, 120.0, 2)) {
    level = SEQ_LEVEL_5_2;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              8192, 4352, 30.0, 2)) {
    level = SEQ_LEVEL_6_0;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              8192, 4352, 60.0, 2)) {
    level = SEQ_LEVEL_6_1;
  } else if (does_level_match(oxcf->width, oxcf->height, oxcf->init_framerate,
                              8192, 4352, 120.0, 2)) {
    level = SEQ_LEVEL_6_2;
  }

  SequenceHeader *const seq_params = &cm->seq_params;
  for (int i = 0; i < MAX_NUM_OPERATING_POINTS; ++i) {
    seq->seq_level_idx[i] = level;
    // Set the maximum parameters for bitrate and buffer size for this profile,
    // level, and tier
    seq_params->op_params[i].bitrate = av1_max_level_bitrate(
        cm->seq_params.profile, seq->seq_level_idx[i], seq->tier[i]);
    // Level with seq_level_idx = 31 returns a high "dummy" bitrate to pass the
    // check
    if (seq_params->op_params[i].bitrate == 0)
      aom_internal_error(
          &cm->error, AOM_CODEC_UNSUP_BITSTREAM,
          "AV1 does not support this combination of profile, level, and tier.");
    // Buffer size in bits/s is bitrate in bits/s * 1 s
    seq_params->op_params[i].buffer_size = seq_params->op_params[i].bitrate;
  }
}

static void init_seq_coding_tools(SequenceHeader *seq, AV1_COMMON *cm,
                                  const AV1EncoderConfig *oxcf, int use_svc) {
  seq->still_picture = (oxcf->force_video_mode == 0) && (oxcf->limit == 1);
  seq->reduced_still_picture_hdr = seq->still_picture;
  seq->reduced_still_picture_hdr &= !oxcf->full_still_picture_hdr;
  seq->force_screen_content_tools = (oxcf->mode == REALTIME) ? 0 : 2;
  seq->force_integer_mv = 2;
  seq->order_hint_info.enable_order_hint = oxcf->enable_order_hint;
  seq->frame_id_numbers_present_flag =
      !(seq->still_picture && seq->reduced_still_picture_hdr) &&
      !oxcf->large_scale_tile && oxcf->error_resilient_mode && !use_svc;
  if (seq->still_picture && seq->reduced_still_picture_hdr) {
    seq->order_hint_info.enable_order_hint = 0;
    seq->force_screen_content_tools = 2;
    seq->force_integer_mv = 2;
  }
  seq->order_hint_info.order_hint_bits_minus_1 =
      seq->order_hint_info.enable_order_hint
          ? DEFAULT_EXPLICIT_ORDER_HINT_BITS - 1
          : -1;

  seq->max_frame_width =
      oxcf->forced_max_frame_width ? oxcf->forced_max_frame_width : oxcf->width;
  seq->max_frame_height = oxcf->forced_max_frame_height
                              ? oxcf->forced_max_frame_height
                              : oxcf->height;
  seq->num_bits_width =
      (seq->max_frame_width > 1) ? get_msb(seq->max_frame_width - 1) + 1 : 1;
  seq->num_bits_height =
      (seq->max_frame_height > 1) ? get_msb(seq->max_frame_height - 1) + 1 : 1;
  assert(seq->num_bits_width <= 16);
  assert(seq->num_bits_height <= 16);

  seq->frame_id_length = FRAME_ID_LENGTH;
  seq->delta_frame_id_length = DELTA_FRAME_ID_LENGTH;

  seq->enable_dual_filter = oxcf->enable_dual_filter;
  seq->order_hint_info.enable_dist_wtd_comp = oxcf->enable_dist_wtd_comp;
  seq->order_hint_info.enable_dist_wtd_comp &=
      seq->order_hint_info.enable_order_hint;
  seq->order_hint_info.enable_ref_frame_mvs = oxcf->enable_ref_frame_mvs;
  seq->order_hint_info.enable_ref_frame_mvs &=
      seq->order_hint_info.enable_order_hint;
  seq->enable_superres = oxcf->enable_superres;
  seq->enable_cdef = oxcf->enable_cdef;
  seq->enable_restoration = oxcf->enable_restoration;
  seq->enable_warped_motion = oxcf->enable_warped_motion;
  seq->enable_interintra_compound = oxcf->enable_interintra_comp;
  seq->enable_masked_compound = oxcf->enable_masked_comp;
  seq->enable_intra_edge_filter = oxcf->enable_intra_edge_filter;
  seq->enable_filter_intra = oxcf->enable_filter_intra;

  set_bitstream_level_tier(seq, cm, oxcf);

  if (seq->operating_points_cnt_minus_1 == 0) {
    seq->operating_point_idc[0] = 0;
  } else {
    // Set operating_point_idc[] such that the i=0 point corresponds to the
    // highest quality operating point (all layers), and subsequent
    // operarting points (i > 0) are lower quality corresponding to
    // skip decoding enhancement  layers (temporal first).
    int i = 0;
    assert(seq->operating_points_cnt_minus_1 ==
           (int)(cm->number_spatial_layers * cm->number_temporal_layers - 1));
    for (unsigned int sl = 0; sl < cm->number_spatial_layers; sl++) {
      for (unsigned int tl = 0; tl < cm->number_temporal_layers; tl++) {
        seq->operating_point_idc[i] =
            (~(~0u << (cm->number_spatial_layers - sl)) << 8) |
            ~(~0u << (cm->number_temporal_layers - tl));
        i++;
      }
    }
  }
}

static void init_config(struct AV1_COMP *cpi, AV1EncoderConfig *oxcf) {
  AV1_COMMON *const cm = &cpi->common;
  SequenceHeader *const seq_params = &cm->seq_params;
  ResizePendingParams *resize_pending_params = &cpi->resize_pending_params;

  cpi->oxcf = *oxcf;
  cpi->framerate = oxcf->init_framerate;

  seq_params->profile = oxcf->profile;
  seq_params->bit_depth = oxcf->bit_depth;
  seq_params->use_highbitdepth = oxcf->use_highbitdepth;
  seq_params->color_primaries = oxcf->color_primaries;
  seq_params->transfer_characteristics = oxcf->transfer_characteristics;
  seq_params->matrix_coefficients = oxcf->matrix_coefficients;
  seq_params->monochrome = oxcf->monochrome;
  seq_params->chroma_sample_position = oxcf->chroma_sample_position;
  seq_params->color_range = oxcf->color_range;
  seq_params->timing_info_present = oxcf->timing_info_present;
  seq_params->timing_info.num_units_in_display_tick =
      oxcf->timing_info.num_units_in_display_tick;
  seq_params->timing_info.time_scale = oxcf->timing_info.time_scale;
  seq_params->timing_info.equal_picture_interval =
      oxcf->timing_info.equal_picture_interval;
  seq_params->timing_info.num_ticks_per_picture =
      oxcf->timing_info.num_ticks_per_picture;

  seq_params->display_model_info_present_flag =
      oxcf->display_model_info_present_flag;
  seq_params->decoder_model_info_present_flag =
      oxcf->decoder_model_info_present_flag;
  if (oxcf->decoder_model_info_present_flag) {
    // set the decoder model parameters in schedule mode
    seq_params->decoder_model_info.num_units_in_decoding_tick =
        oxcf->buffer_model.num_units_in_decoding_tick;
    cm->buffer_removal_time_present = 1;
    av1_set_aom_dec_model_info(&seq_params->decoder_model_info);
    av1_set_dec_model_op_parameters(&seq_params->op_params[0]);
  } else if (seq_params->timing_info_present &&
             seq_params->timing_info.equal_picture_interval &&
             !seq_params->decoder_model_info_present_flag) {
    // set the decoder model parameters in resource availability mode
    av1_set_resource_availability_parameters(&seq_params->op_params[0]);
  } else {
    seq_params->op_params[0].initial_display_delay =
        10;  // Default value (not signaled)
  }

  if (seq_params->monochrome) {
    seq_params->subsampling_x = 1;
    seq_params->subsampling_y = 1;
  } else if (seq_params->color_primaries == AOM_CICP_CP_BT_709 &&
             seq_params->transfer_characteristics == AOM_CICP_TC_SRGB &&
             seq_params->matrix_coefficients == AOM_CICP_MC_IDENTITY) {
    seq_params->subsampling_x = 0;
    seq_params->subsampling_y = 0;
  } else {
    if (seq_params->profile == 0) {
      seq_params->subsampling_x = 1;
      seq_params->subsampling_y = 1;
    } else if (seq_params->profile == 1) {
      seq_params->subsampling_x = 0;
      seq_params->subsampling_y = 0;
    } else {
      if (seq_params->bit_depth == AOM_BITS_12) {
        seq_params->subsampling_x = oxcf->chroma_subsampling_x;
        seq_params->subsampling_y = oxcf->chroma_subsampling_y;
      } else {
        seq_params->subsampling_x = 1;
        seq_params->subsampling_y = 0;
      }
    }
  }

  cm->width = oxcf->width;
  cm->height = oxcf->height;
  set_sb_size(seq_params,
              select_sb_size(cpi));  // set sb size before allocations
  alloc_compressor_data(cpi);

  update_film_grain_parameters(cpi, oxcf);

  // Single thread case: use counts in common.
  cpi->td.counts = &cpi->counts;

  // Set init SVC parameters.
  cpi->use_svc = 0;
  cpi->svc.external_ref_frame_config = 0;
  cpi->svc.non_reference_frame = 0;
  cpi->svc.number_spatial_layers = 1;
  cpi->svc.number_temporal_layers = 1;
  cm->number_spatial_layers = 1;
  cm->number_temporal_layers = 1;
  cm->spatial_layer_id = 0;
  cm->temporal_layer_id = 0;

  // change includes all joint functionality
  av1_change_config(cpi, oxcf);

  cpi->ref_frame_flags = 0;

  // Reset resize pending flags
  resize_pending_params->width = 0;
  resize_pending_params->height = 0;

  init_buffer_indices(&cpi->force_intpel_info, cm->remapped_ref_idx);
}

static void set_rc_buffer_sizes(RATE_CONTROL *rc,
                                const AV1EncoderConfig *oxcf) {
  const int64_t bandwidth = oxcf->target_bandwidth;
  const int64_t starting = oxcf->starting_buffer_level_ms;
  const int64_t optimal = oxcf->optimal_buffer_level_ms;
  const int64_t maximum = oxcf->maximum_buffer_size_ms;

  rc->starting_buffer_level = starting * bandwidth / 1000;
  rc->optimal_buffer_level =
      (optimal == 0) ? bandwidth / 8 : optimal * bandwidth / 1000;
  rc->maximum_buffer_size =
      (maximum == 0) ? bandwidth / 8 : maximum * bandwidth / 1000;
}

#define HIGHBD_BFP(BT, SDF, SDAF, VF, SVF, SVAF, SDX4DF, JSDAF, JSVAF) \
  cpi->fn_ptr[BT].sdf = SDF;                                           \
  cpi->fn_ptr[BT].sdaf = SDAF;                                         \
  cpi->fn_ptr[BT].vf = VF;                                             \
  cpi->fn_ptr[BT].svf = SVF;                                           \
  cpi->fn_ptr[BT].svaf = SVAF;                                         \
  cpi->fn_ptr[BT].sdx4df = SDX4DF;                                     \
  cpi->fn_ptr[BT].jsdaf = JSDAF;                                       \
  cpi->fn_ptr[BT].jsvaf = JSVAF;

#define MAKE_BFP_SAD_WRAPPER(fnname)                                           \
  static unsigned int fnname##_bits8(const uint8_t *src_ptr,                   \
                                     int source_stride,                        \
                                     const uint8_t *ref_ptr, int ref_stride) { \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride);                \
  }                                                                            \
  static unsigned int fnname##_bits10(                                         \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,       \
      int ref_stride) {                                                        \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride) >> 2;           \
  }                                                                            \
  static unsigned int fnname##_bits12(                                         \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,       \
      int ref_stride) {                                                        \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride) >> 4;           \
  }

#define MAKE_BFP_SADAVG_WRAPPER(fnname)                                        \
  static unsigned int fnname##_bits8(                                          \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,       \
      int ref_stride, const uint8_t *second_pred) {                            \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred);   \
  }                                                                            \
  static unsigned int fnname##_bits10(                                         \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,       \
      int ref_stride, const uint8_t *second_pred) {                            \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred) >> \
           2;                                                                  \
  }                                                                            \
  static unsigned int fnname##_bits12(                                         \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,       \
      int ref_stride, const uint8_t *second_pred) {                            \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred) >> \
           4;                                                                  \
  }

#define MAKE_BFP_SAD4D_WRAPPER(fnname)                                        \
  static void fnname##_bits8(const uint8_t *src_ptr, int source_stride,       \
                             const uint8_t *const ref_ptr[], int ref_stride,  \
                             unsigned int *sad_array) {                       \
    fnname(src_ptr, source_stride, ref_ptr, ref_stride, sad_array);           \
  }                                                                           \
  static void fnname##_bits10(const uint8_t *src_ptr, int source_stride,      \
                              const uint8_t *const ref_ptr[], int ref_stride, \
                              unsigned int *sad_array) {                      \
    int i;                                                                    \
    fnname(src_ptr, source_stride, ref_ptr, ref_stride, sad_array);           \
    for (i = 0; i < 4; i++) sad_array[i] >>= 2;                               \
  }                                                                           \
  static void fnname##_bits12(const uint8_t *src_ptr, int source_stride,      \
                              const uint8_t *const ref_ptr[], int ref_stride, \
                              unsigned int *sad_array) {                      \
    int i;                                                                    \
    fnname(src_ptr, source_stride, ref_ptr, ref_stride, sad_array);           \
    for (i = 0; i < 4; i++) sad_array[i] >>= 4;                               \
  }

#define MAKE_BFP_JSADAVG_WRAPPER(fnname)                                    \
  static unsigned int fnname##_bits8(                                       \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,    \
      int ref_stride, const uint8_t *second_pred,                           \
      const DIST_WTD_COMP_PARAMS *jcp_param) {                              \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred, \
                  jcp_param);                                               \
  }                                                                         \
  static unsigned int fnname##_bits10(                                      \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,    \
      int ref_stride, const uint8_t *second_pred,                           \
      const DIST_WTD_COMP_PARAMS *jcp_param) {                              \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred, \
                  jcp_param) >>                                             \
           2;                                                               \
  }                                                                         \
  static unsigned int fnname##_bits12(                                      \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr,    \
      int ref_stride, const uint8_t *second_pred,                           \
      const DIST_WTD_COMP_PARAMS *jcp_param) {                              \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride, second_pred, \
                  jcp_param) >>                                             \
           4;                                                               \
  }

#if CONFIG_AV1_HIGHBITDEPTH
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad128x128)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad128x128_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad128x128x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad128x64)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad128x64_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad128x64x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad64x128)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad64x128_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad64x128x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad32x16)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad32x16_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad32x16x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad16x32)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad16x32_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad16x32x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad64x32)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad64x32_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad64x32x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad32x64)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad32x64_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad32x64x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad32x32)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad32x32_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad32x32x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad64x64)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad64x64_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad64x64x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad16x16)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad16x16_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad16x16x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad16x8)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad16x8_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad16x8x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad8x16)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad8x16_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad8x16x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad8x8)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad8x8_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad8x8x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad8x4)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad8x4_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad8x4x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad4x8)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad4x8_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad4x8x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad4x4)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad4x4_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad4x4x4d)

MAKE_BFP_SAD_WRAPPER(aom_highbd_sad4x16)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad4x16_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad4x16x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad16x4)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad16x4_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad16x4x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad8x32)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad8x32_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad8x32x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad32x8)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad32x8_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad32x8x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad16x64)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad16x64_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad16x64x4d)
MAKE_BFP_SAD_WRAPPER(aom_highbd_sad64x16)
MAKE_BFP_SADAVG_WRAPPER(aom_highbd_sad64x16_avg)
MAKE_BFP_SAD4D_WRAPPER(aom_highbd_sad64x16x4d)

MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad128x128_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad128x64_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad64x128_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad32x16_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad16x32_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad64x32_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad32x64_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad32x32_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad64x64_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad16x16_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad16x8_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad8x16_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad8x8_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad8x4_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad4x8_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad4x4_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad4x16_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad16x4_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad8x32_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad32x8_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad16x64_avg)
MAKE_BFP_JSADAVG_WRAPPER(aom_highbd_dist_wtd_sad64x16_avg)
#endif  // CONFIG_AV1_HIGHBITDEPTH

#define HIGHBD_MBFP(BT, MCSDF, MCSVF) \
  cpi->fn_ptr[BT].msdf = MCSDF;       \
  cpi->fn_ptr[BT].msvf = MCSVF;

#define MAKE_MBFP_COMPOUND_SAD_WRAPPER(fnname)                           \
  static unsigned int fnname##_bits8(                                    \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr, \
      int ref_stride, const uint8_t *second_pred_ptr, const uint8_t *m,  \
      int m_stride, int invert_mask) {                                   \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride,           \
                  second_pred_ptr, m, m_stride, invert_mask);            \
  }                                                                      \
  static unsigned int fnname##_bits10(                                   \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr, \
      int ref_stride, const uint8_t *second_pred_ptr, const uint8_t *m,  \
      int m_stride, int invert_mask) {                                   \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride,           \
                  second_pred_ptr, m, m_stride, invert_mask) >>          \
           2;                                                            \
  }                                                                      \
  static unsigned int fnname##_bits12(                                   \
      const uint8_t *src_ptr, int source_stride, const uint8_t *ref_ptr, \
      int ref_stride, const uint8_t *second_pred_ptr, const uint8_t *m,  \
      int m_stride, int invert_mask) {                                   \
    return fnname(src_ptr, source_stride, ref_ptr, ref_stride,           \
                  second_pred_ptr, m, m_stride, invert_mask) >>          \
           4;                                                            \
  }

#if CONFIG_AV1_HIGHBITDEPTH
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad128x128)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad128x64)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad64x128)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad64x64)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad64x32)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad32x64)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad32x32)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad32x16)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad16x32)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad16x16)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad16x8)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad8x16)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad8x8)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad8x4)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad4x8)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad4x4)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad4x16)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad16x4)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad8x32)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad32x8)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad16x64)
MAKE_MBFP_COMPOUND_SAD_WRAPPER(aom_highbd_masked_sad64x16)
#endif

#define HIGHBD_OBFP(BT, OSDF, OVF, OSVF) \
  cpi->fn_ptr[BT].osdf = OSDF;           \
  cpi->fn_ptr[BT].ovf = OVF;             \
  cpi->fn_ptr[BT].osvf = OSVF;

#define MAKE_OBFP_SAD_WRAPPER(fnname)                                     \
  static unsigned int fnname##_bits8(const uint8_t *ref, int ref_stride,  \
                                     const int32_t *wsrc,                 \
                                     const int32_t *msk) {                \
    return fnname(ref, ref_stride, wsrc, msk);                            \
  }                                                                       \
  static unsigned int fnname##_bits10(const uint8_t *ref, int ref_stride, \
                                      const int32_t *wsrc,                \
                                      const int32_t *msk) {               \
    return fnname(ref, ref_stride, wsrc, msk) >> 2;                       \
  }                                                                       \
  static unsigned int fnname##_bits12(const uint8_t *ref, int ref_stride, \
                                      const int32_t *wsrc,                \
                                      const int32_t *msk) {               \
    return fnname(ref, ref_stride, wsrc, msk) >> 4;                       \
  }

#if CONFIG_AV1_HIGHBITDEPTH
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad128x128)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad128x64)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad64x128)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad64x64)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad64x32)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad32x64)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad32x32)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad32x16)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad16x32)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad16x16)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad16x8)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad8x16)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad8x8)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad8x4)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad4x8)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad4x4)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad4x16)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad16x4)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad8x32)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad32x8)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad16x64)
MAKE_OBFP_SAD_WRAPPER(aom_highbd_obmc_sad64x16)

static void highbd_set_var_fns(AV1_COMP *const cpi) {
  AV1_COMMON *const cm = &cpi->common;
  if (cm->seq_params.use_highbitdepth) {
    switch (cm->seq_params.bit_depth) {
      case AOM_BITS_8:
        HIGHBD_BFP(BLOCK_64X16, aom_highbd_sad64x16_bits8,
                   aom_highbd_sad64x16_avg_bits8, aom_highbd_8_variance64x16,
                   aom_highbd_8_sub_pixel_variance64x16,
                   aom_highbd_8_sub_pixel_avg_variance64x16,
                   aom_highbd_sad64x16x4d_bits8,
                   aom_highbd_dist_wtd_sad64x16_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance64x16)

        HIGHBD_BFP(BLOCK_16X64, aom_highbd_sad16x64_bits8,
                   aom_highbd_sad16x64_avg_bits8, aom_highbd_8_variance16x64,
                   aom_highbd_8_sub_pixel_variance16x64,
                   aom_highbd_8_sub_pixel_avg_variance16x64,
                   aom_highbd_sad16x64x4d_bits8,
                   aom_highbd_dist_wtd_sad16x64_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance16x64)

        HIGHBD_BFP(
            BLOCK_32X8, aom_highbd_sad32x8_bits8, aom_highbd_sad32x8_avg_bits8,
            aom_highbd_8_variance32x8, aom_highbd_8_sub_pixel_variance32x8,
            aom_highbd_8_sub_pixel_avg_variance32x8,
            aom_highbd_sad32x8x4d_bits8, aom_highbd_dist_wtd_sad32x8_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance32x8)

        HIGHBD_BFP(
            BLOCK_8X32, aom_highbd_sad8x32_bits8, aom_highbd_sad8x32_avg_bits8,
            aom_highbd_8_variance8x32, aom_highbd_8_sub_pixel_variance8x32,
            aom_highbd_8_sub_pixel_avg_variance8x32,
            aom_highbd_sad8x32x4d_bits8, aom_highbd_dist_wtd_sad8x32_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance8x32)

        HIGHBD_BFP(
            BLOCK_16X4, aom_highbd_sad16x4_bits8, aom_highbd_sad16x4_avg_bits8,
            aom_highbd_8_variance16x4, aom_highbd_8_sub_pixel_variance16x4,
            aom_highbd_8_sub_pixel_avg_variance16x4,
            aom_highbd_sad16x4x4d_bits8, aom_highbd_dist_wtd_sad16x4_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance16x4)

        HIGHBD_BFP(
            BLOCK_4X16, aom_highbd_sad4x16_bits8, aom_highbd_sad4x16_avg_bits8,
            aom_highbd_8_variance4x16, aom_highbd_8_sub_pixel_variance4x16,
            aom_highbd_8_sub_pixel_avg_variance4x16,
            aom_highbd_sad4x16x4d_bits8, aom_highbd_dist_wtd_sad4x16_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance4x16)

        HIGHBD_BFP(BLOCK_32X16, aom_highbd_sad32x16_bits8,
                   aom_highbd_sad32x16_avg_bits8, aom_highbd_8_variance32x16,
                   aom_highbd_8_sub_pixel_variance32x16,
                   aom_highbd_8_sub_pixel_avg_variance32x16,
                   aom_highbd_sad32x16x4d_bits8,
                   aom_highbd_dist_wtd_sad32x16_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance32x16)

        HIGHBD_BFP(BLOCK_16X32, aom_highbd_sad16x32_bits8,
                   aom_highbd_sad16x32_avg_bits8, aom_highbd_8_variance16x32,
                   aom_highbd_8_sub_pixel_variance16x32,
                   aom_highbd_8_sub_pixel_avg_variance16x32,
                   aom_highbd_sad16x32x4d_bits8,
                   aom_highbd_dist_wtd_sad16x32_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance16x32)

        HIGHBD_BFP(BLOCK_64X32, aom_highbd_sad64x32_bits8,
                   aom_highbd_sad64x32_avg_bits8, aom_highbd_8_variance64x32,
                   aom_highbd_8_sub_pixel_variance64x32,
                   aom_highbd_8_sub_pixel_avg_variance64x32,
                   aom_highbd_sad64x32x4d_bits8,
                   aom_highbd_dist_wtd_sad64x32_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance64x32)

        HIGHBD_BFP(BLOCK_32X64, aom_highbd_sad32x64_bits8,
                   aom_highbd_sad32x64_avg_bits8, aom_highbd_8_variance32x64,
                   aom_highbd_8_sub_pixel_variance32x64,
                   aom_highbd_8_sub_pixel_avg_variance32x64,
                   aom_highbd_sad32x64x4d_bits8,
                   aom_highbd_dist_wtd_sad32x64_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance32x64)

        HIGHBD_BFP(BLOCK_32X32, aom_highbd_sad32x32_bits8,
                   aom_highbd_sad32x32_avg_bits8, aom_highbd_8_variance32x32,
                   aom_highbd_8_sub_pixel_variance32x32,
                   aom_highbd_8_sub_pixel_avg_variance32x32,
                   aom_highbd_sad32x32x4d_bits8,
                   aom_highbd_dist_wtd_sad32x32_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance32x32)

        HIGHBD_BFP(BLOCK_64X64, aom_highbd_sad64x64_bits8,
                   aom_highbd_sad64x64_avg_bits8, aom_highbd_8_variance64x64,
                   aom_highbd_8_sub_pixel_variance64x64,
                   aom_highbd_8_sub_pixel_avg_variance64x64,
                   aom_highbd_sad64x64x4d_bits8,
                   aom_highbd_dist_wtd_sad64x64_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance64x64)

        HIGHBD_BFP(BLOCK_16X16, aom_highbd_sad16x16_bits8,
                   aom_highbd_sad16x16_avg_bits8, aom_highbd_8_variance16x16,
                   aom_highbd_8_sub_pixel_variance16x16,
                   aom_highbd_8_sub_pixel_avg_variance16x16,
                   aom_highbd_sad16x16x4d_bits8,
                   aom_highbd_dist_wtd_sad16x16_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance16x16)

        HIGHBD_BFP(
            BLOCK_16X8, aom_highbd_sad16x8_bits8, aom_highbd_sad16x8_avg_bits8,
            aom_highbd_8_variance16x8, aom_highbd_8_sub_pixel_variance16x8,
            aom_highbd_8_sub_pixel_avg_variance16x8,
            aom_highbd_sad16x8x4d_bits8, aom_highbd_dist_wtd_sad16x8_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance16x8)

        HIGHBD_BFP(
            BLOCK_8X16, aom_highbd_sad8x16_bits8, aom_highbd_sad8x16_avg_bits8,
            aom_highbd_8_variance8x16, aom_highbd_8_sub_pixel_variance8x16,
            aom_highbd_8_sub_pixel_avg_variance8x16,
            aom_highbd_sad8x16x4d_bits8, aom_highbd_dist_wtd_sad8x16_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance8x16)

        HIGHBD_BFP(
            BLOCK_8X8, aom_highbd_sad8x8_bits8, aom_highbd_sad8x8_avg_bits8,
            aom_highbd_8_variance8x8, aom_highbd_8_sub_pixel_variance8x8,
            aom_highbd_8_sub_pixel_avg_variance8x8, aom_highbd_sad8x8x4d_bits8,
            aom_highbd_dist_wtd_sad8x8_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance8x8)

        HIGHBD_BFP(
            BLOCK_8X4, aom_highbd_sad8x4_bits8, aom_highbd_sad8x4_avg_bits8,
            aom_highbd_8_variance8x4, aom_highbd_8_sub_pixel_variance8x4,
            aom_highbd_8_sub_pixel_avg_variance8x4, aom_highbd_sad8x4x4d_bits8,
            aom_highbd_dist_wtd_sad8x4_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance8x4)

        HIGHBD_BFP(
            BLOCK_4X8, aom_highbd_sad4x8_bits8, aom_highbd_sad4x8_avg_bits8,
            aom_highbd_8_variance4x8, aom_highbd_8_sub_pixel_variance4x8,
            aom_highbd_8_sub_pixel_avg_variance4x8, aom_highbd_sad4x8x4d_bits8,
            aom_highbd_dist_wtd_sad4x8_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance4x8)

        HIGHBD_BFP(
            BLOCK_4X4, aom_highbd_sad4x4_bits8, aom_highbd_sad4x4_avg_bits8,
            aom_highbd_8_variance4x4, aom_highbd_8_sub_pixel_variance4x4,
            aom_highbd_8_sub_pixel_avg_variance4x4, aom_highbd_sad4x4x4d_bits8,
            aom_highbd_dist_wtd_sad4x4_avg_bits8,
            aom_highbd_8_dist_wtd_sub_pixel_avg_variance4x4)

        HIGHBD_BFP(BLOCK_128X128, aom_highbd_sad128x128_bits8,
                   aom_highbd_sad128x128_avg_bits8,
                   aom_highbd_8_variance128x128,
                   aom_highbd_8_sub_pixel_variance128x128,
                   aom_highbd_8_sub_pixel_avg_variance128x128,
                   aom_highbd_sad128x128x4d_bits8,
                   aom_highbd_dist_wtd_sad128x128_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance128x128)

        HIGHBD_BFP(BLOCK_128X64, aom_highbd_sad128x64_bits8,
                   aom_highbd_sad128x64_avg_bits8, aom_highbd_8_variance128x64,
                   aom_highbd_8_sub_pixel_variance128x64,
                   aom_highbd_8_sub_pixel_avg_variance128x64,
                   aom_highbd_sad128x64x4d_bits8,
                   aom_highbd_dist_wtd_sad128x64_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance128x64)

        HIGHBD_BFP(BLOCK_64X128, aom_highbd_sad64x128_bits8,
                   aom_highbd_sad64x128_avg_bits8, aom_highbd_8_variance64x128,
                   aom_highbd_8_sub_pixel_variance64x128,
                   aom_highbd_8_sub_pixel_avg_variance64x128,
                   aom_highbd_sad64x128x4d_bits8,
                   aom_highbd_dist_wtd_sad64x128_avg_bits8,
                   aom_highbd_8_dist_wtd_sub_pixel_avg_variance64x128)

        HIGHBD_MBFP(BLOCK_128X128, aom_highbd_masked_sad128x128_bits8,
                    aom_highbd_8_masked_sub_pixel_variance128x128)
        HIGHBD_MBFP(BLOCK_128X64, aom_highbd_masked_sad128x64_bits8,
                    aom_highbd_8_masked_sub_pixel_variance128x64)
        HIGHBD_MBFP(BLOCK_64X128, aom_highbd_masked_sad64x128_bits8,
                    aom_highbd_8_masked_sub_pixel_variance64x128)
        HIGHBD_MBFP(BLOCK_64X64, aom_highbd_masked_sad64x64_bits8,
                    aom_highbd_8_masked_sub_pixel_variance64x64)
        HIGHBD_MBFP(BLOCK_64X32, aom_highbd_masked_sad64x32_bits8,
                    aom_highbd_8_masked_sub_pixel_variance64x32)
        HIGHBD_MBFP(BLOCK_32X64, aom_highbd_masked_sad32x64_bits8,
                    aom_highbd_8_masked_sub_pixel_variance32x64)
        HIGHBD_MBFP(BLOCK_32X32, aom_highbd_masked_sad32x32_bits8,
                    aom_highbd_8_masked_sub_pixel_variance32x32)
        HIGHBD_MBFP(BLOCK_32X16, aom_highbd_masked_sad32x16_bits8,
                    aom_highbd_8_masked_sub_pixel_variance32x16)
        HIGHBD_MBFP(BLOCK_16X32, aom_highbd_masked_sad16x32_bits8,
                    aom_highbd_8_masked_sub_pixel_variance16x32)
        HIGHBD_MBFP(BLOCK_16X16, aom_highbd_masked_sad16x16_bits8,
                    aom_highbd_8_masked_sub_pixel_variance16x16)
        HIGHBD_MBFP(BLOCK_8X16, aom_highbd_masked_sad8x16_bits8,
                    aom_highbd_8_masked_sub_pixel_variance8x16)
        HIGHBD_MBFP(BLOCK_16X8, aom_highbd_masked_sad16x8_bits8,
                    aom_highbd_8_masked_sub_pixel_variance16x8)
        HIGHBD_MBFP(BLOCK_8X8, aom_highbd_masked_sad8x8_bits8,
                    aom_highbd_8_masked_sub_pixel_variance8x8)
        HIGHBD_MBFP(BLOCK_4X8, aom_highbd_masked_sad4x8_bits8,
                    aom_highbd_8_masked_sub_pixel_variance4x8)
        HIGHBD_MBFP(BLOCK_8X4, aom_highbd_masked_sad8x4_bits8,
                    aom_highbd_8_masked_sub_pixel_variance8x4)
        HIGHBD_MBFP(BLOCK_4X4, aom_highbd_masked_sad4x4_bits8,
                    aom_highbd_8_masked_sub_pixel_variance4x4)
        HIGHBD_MBFP(BLOCK_64X16, aom_highbd_masked_sad64x16_bits8,
                    aom_highbd_8_masked_sub_pixel_variance64x16)
        HIGHBD_MBFP(BLOCK_16X64, aom_highbd_masked_sad16x64_bits8,
                    aom_highbd_8_masked_sub_pixel_variance16x64)
        HIGHBD_MBFP(BLOCK_32X8, aom_highbd_masked_sad32x8_bits8,
                    aom_highbd_8_masked_sub_pixel_variance32x8)
        HIGHBD_MBFP(BLOCK_8X32, aom_highbd_masked_sad8x32_bits8,
                    aom_highbd_8_masked_sub_pixel_variance8x32)
        HIGHBD_MBFP(BLOCK_16X4, aom_highbd_masked_sad16x4_bits8,
                    aom_highbd_8_masked_sub_pixel_variance16x4)
        HIGHBD_MBFP(BLOCK_4X16, aom_highbd_masked_sad4x16_bits8,
                    aom_highbd_8_masked_sub_pixel_variance4x16)
        HIGHBD_OBFP(BLOCK_128X128, aom_highbd_obmc_sad128x128_bits8,
                    aom_highbd_obmc_variance128x128,
                    aom_highbd_obmc_sub_pixel_variance128x128)
        HIGHBD_OBFP(BLOCK_128X64, aom_highbd_obmc_sad128x64_bits8,
                    aom_highbd_obmc_variance128x64,
                    aom_highbd_obmc_sub_pixel_variance128x64)
        HIGHBD_OBFP(BLOCK_64X128, aom_highbd_obmc_sad64x128_bits8,
                    aom_highbd_obmc_variance64x128,
                    aom_highbd_obmc_sub_pixel_variance64x128)
        HIGHBD_OBFP(BLOCK_64X64, aom_highbd_obmc_sad64x64_bits8,
                    aom_highbd_obmc_variance64x64,
                    aom_highbd_obmc_sub_pixel_variance64x64)
        HIGHBD_OBFP(BLOCK_64X32, aom_highbd_obmc_sad64x32_bits8,
                    aom_highbd_obmc_variance64x32,
                    aom_highbd_obmc_sub_pixel_variance64x32)
        HIGHBD_OBFP(BLOCK_32X64, aom_highbd_obmc_sad32x64_bits8,
                    aom_highbd_obmc_variance32x64,
                    aom_highbd_obmc_sub_pixel_variance32x64)
        HIGHBD_OBFP(BLOCK_32X32, aom_highbd_obmc_sad32x32_bits8,
                    aom_highbd_obmc_variance32x32,
                    aom_highbd_obmc_sub_pixel_variance32x32)
        HIGHBD_OBFP(BLOCK_32X16, aom_highbd_obmc_sad32x16_bits8,
                    aom_highbd_obmc_variance32x16,
                    aom_highbd_obmc_sub_pixel_variance32x16)
        HIGHBD_OBFP(BLOCK_16X32, aom_highbd_obmc_sad16x32_bits8,
                    aom_highbd_obmc_variance16x32,
                    aom_highbd_obmc_sub_pixel_variance16x32)
        HIGHBD_OBFP(BLOCK_16X16, aom_highbd_obmc_sad16x16_bits8,
                    aom_highbd_obmc_variance16x16,
                    aom_highbd_obmc_sub_pixel_variance16x16)
        HIGHBD_OBFP(BLOCK_8X16, aom_highbd_obmc_sad8x16_bits8,
                    aom_highbd_obmc_variance8x16,
                    aom_highbd_obmc_sub_pixel_variance8x16)
        HIGHBD_OBFP(BLOCK_16X8, aom_highbd_obmc_sad16x8_bits8,
                    aom_highbd_obmc_variance16x8,
                    aom_highbd_obmc_sub_pixel_variance16x8)
        HIGHBD_OBFP(BLOCK_8X8, aom_highbd_obmc_sad8x8_bits8,
                    aom_highbd_obmc_variance8x8,
                    aom_highbd_obmc_sub_pixel_variance8x8)
        HIGHBD_OBFP(BLOCK_4X8, aom_highbd_obmc_sad4x8_bits8,
                    aom_highbd_obmc_variance4x8,
                    aom_highbd_obmc_sub_pixel_variance4x8)
        HIGHBD_OBFP(BLOCK_8X4, aom_highbd_obmc_sad8x4_bits8,
                    aom_highbd_obmc_variance8x4,
                    aom_highbd_obmc_sub_pixel_variance8x4)
        HIGHBD_OBFP(BLOCK_4X4, aom_highbd_obmc_sad4x4_bits8,
                    aom_highbd_obmc_variance4x4,
                    aom_highbd_obmc_sub_pixel_variance4x4)
        HIGHBD_OBFP(BLOCK_64X16, aom_highbd_obmc_sad64x16_bits8,
                    aom_highbd_obmc_variance64x16,
                    aom_highbd_obmc_sub_pixel_variance64x16)
        HIGHBD_OBFP(BLOCK_16X64, aom_highbd_obmc_sad16x64_bits8,
                    aom_highbd_obmc_variance16x64,
                    aom_highbd_obmc_sub_pixel_variance16x64)
        HIGHBD_OBFP(BLOCK_32X8, aom_highbd_obmc_sad32x8_bits8,
                    aom_highbd_obmc_variance32x8,
                    aom_highbd_obmc_sub_pixel_variance32x8)
        HIGHBD_OBFP(BLOCK_8X32, aom_highbd_obmc_sad8x32_bits8,
                    aom_highbd_obmc_variance8x32,
                    aom_highbd_obmc_sub_pixel_variance8x32)
        HIGHBD_OBFP(BLOCK_16X4, aom_highbd_obmc_sad16x4_bits8,
                    aom_highbd_obmc_variance16x4,
                    aom_highbd_obmc_sub_pixel_variance16x4)
        HIGHBD_OBFP(BLOCK_4X16, aom_highbd_obmc_sad4x16_bits8,
                    aom_highbd_obmc_variance4x16,
                    aom_highbd_obmc_sub_pixel_variance4x16)
        break;

      case AOM_BITS_10:
        HIGHBD_BFP(BLOCK_64X16, aom_highbd_sad64x16_bits10,
                   aom_highbd_sad64x16_avg_bits10, aom_highbd_10_variance64x16,
                   aom_highbd_10_sub_pixel_variance64x16,
                   aom_highbd_10_sub_pixel_avg_variance64x16,
                   aom_highbd_sad64x16x4d_bits10,
                   aom_highbd_dist_wtd_sad64x16_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance64x16);

        HIGHBD_BFP(BLOCK_16X64, aom_highbd_sad16x64_bits10,
                   aom_highbd_sad16x64_avg_bits10, aom_highbd_10_variance16x64,
                   aom_highbd_10_sub_pixel_variance16x64,
                   aom_highbd_10_sub_pixel_avg_variance16x64,
                   aom_highbd_sad16x64x4d_bits10,
                   aom_highbd_dist_wtd_sad16x64_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance16x64);

        HIGHBD_BFP(BLOCK_32X8, aom_highbd_sad32x8_bits10,
                   aom_highbd_sad32x8_avg_bits10, aom_highbd_10_variance32x8,
                   aom_highbd_10_sub_pixel_variance32x8,
                   aom_highbd_10_sub_pixel_avg_variance32x8,
                   aom_highbd_sad32x8x4d_bits10,
                   aom_highbd_dist_wtd_sad32x8_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance32x8);

        HIGHBD_BFP(BLOCK_8X32, aom_highbd_sad8x32_bits10,
                   aom_highbd_sad8x32_avg_bits10, aom_highbd_10_variance8x32,
                   aom_highbd_10_sub_pixel_variance8x32,
                   aom_highbd_10_sub_pixel_avg_variance8x32,
                   aom_highbd_sad8x32x4d_bits10,
                   aom_highbd_dist_wtd_sad8x32_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance8x32);

        HIGHBD_BFP(BLOCK_16X4, aom_highbd_sad16x4_bits10,
                   aom_highbd_sad16x4_avg_bits10, aom_highbd_10_variance16x4,
                   aom_highbd_10_sub_pixel_variance16x4,
                   aom_highbd_10_sub_pixel_avg_variance16x4,
                   aom_highbd_sad16x4x4d_bits10,
                   aom_highbd_dist_wtd_sad16x4_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance16x4);

        HIGHBD_BFP(BLOCK_4X16, aom_highbd_sad4x16_bits10,
                   aom_highbd_sad4x16_avg_bits10, aom_highbd_10_variance4x16,
                   aom_highbd_10_sub_pixel_variance4x16,
                   aom_highbd_10_sub_pixel_avg_variance4x16,
                   aom_highbd_sad4x16x4d_bits10,
                   aom_highbd_dist_wtd_sad4x16_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance4x16);

        HIGHBD_BFP(BLOCK_32X16, aom_highbd_sad32x16_bits10,
                   aom_highbd_sad32x16_avg_bits10, aom_highbd_10_variance32x16,
                   aom_highbd_10_sub_pixel_variance32x16,
                   aom_highbd_10_sub_pixel_avg_variance32x16,
                   aom_highbd_sad32x16x4d_bits10,
                   aom_highbd_dist_wtd_sad32x16_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance32x16);

        HIGHBD_BFP(BLOCK_16X32, aom_highbd_sad16x32_bits10,
                   aom_highbd_sad16x32_avg_bits10, aom_highbd_10_variance16x32,
                   aom_highbd_10_sub_pixel_variance16x32,
                   aom_highbd_10_sub_pixel_avg_variance16x32,
                   aom_highbd_sad16x32x4d_bits10,
                   aom_highbd_dist_wtd_sad16x32_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance16x32);

        HIGHBD_BFP(BLOCK_64X32, aom_highbd_sad64x32_bits10,
                   aom_highbd_sad64x32_avg_bits10, aom_highbd_10_variance64x32,
                   aom_highbd_10_sub_pixel_variance64x32,
                   aom_highbd_10_sub_pixel_avg_variance64x32,
                   aom_highbd_sad64x32x4d_bits10,
                   aom_highbd_dist_wtd_sad64x32_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance64x32);

        HIGHBD_BFP(BLOCK_32X64, aom_highbd_sad32x64_bits10,
                   aom_highbd_sad32x64_avg_bits10, aom_highbd_10_variance32x64,
                   aom_highbd_10_sub_pixel_variance32x64,
                   aom_highbd_10_sub_pixel_avg_variance32x64,
                   aom_highbd_sad32x64x4d_bits10,
                   aom_highbd_dist_wtd_sad32x64_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance32x64);

        HIGHBD_BFP(BLOCK_32X32, aom_highbd_sad32x32_bits10,
                   aom_highbd_sad32x32_avg_bits10, aom_highbd_10_variance32x32,
                   aom_highbd_10_sub_pixel_variance32x32,
                   aom_highbd_10_sub_pixel_avg_variance32x32,
                   aom_highbd_sad32x32x4d_bits10,
                   aom_highbd_dist_wtd_sad32x32_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance32x32);

        HIGHBD_BFP(BLOCK_64X64, aom_highbd_sad64x64_bits10,
                   aom_highbd_sad64x64_avg_bits10, aom_highbd_10_variance64x64,
                   aom_highbd_10_sub_pixel_variance64x64,
                   aom_highbd_10_sub_pixel_avg_variance64x64,
                   aom_highbd_sad64x64x4d_bits10,
                   aom_highbd_dist_wtd_sad64x64_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance64x64);

        HIGHBD_BFP(BLOCK_16X16, aom_highbd_sad16x16_bits10,
                   aom_highbd_sad16x16_avg_bits10, aom_highbd_10_variance16x16,
                   aom_highbd_10_sub_pixel_variance16x16,
                   aom_highbd_10_sub_pixel_avg_variance16x16,
                   aom_highbd_sad16x16x4d_bits10,
                   aom_highbd_dist_wtd_sad16x16_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance16x16);

        HIGHBD_BFP(BLOCK_16X8, aom_highbd_sad16x8_bits10,
                   aom_highbd_sad16x8_avg_bits10, aom_highbd_10_variance16x8,
                   aom_highbd_10_sub_pixel_variance16x8,
                   aom_highbd_10_sub_pixel_avg_variance16x8,
                   aom_highbd_sad16x8x4d_bits10,
                   aom_highbd_dist_wtd_sad16x8_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance16x8);

        HIGHBD_BFP(BLOCK_8X16, aom_highbd_sad8x16_bits10,
                   aom_highbd_sad8x16_avg_bits10, aom_highbd_10_variance8x16,
                   aom_highbd_10_sub_pixel_variance8x16,
                   aom_highbd_10_sub_pixel_avg_variance8x16,
                   aom_highbd_sad8x16x4d_bits10,
                   aom_highbd_dist_wtd_sad8x16_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance8x16);

        HIGHBD_BFP(
            BLOCK_8X8, aom_highbd_sad8x8_bits10, aom_highbd_sad8x8_avg_bits10,
            aom_highbd_10_variance8x8, aom_highbd_10_sub_pixel_variance8x8,
            aom_highbd_10_sub_pixel_avg_variance8x8,
            aom_highbd_sad8x8x4d_bits10, aom_highbd_dist_wtd_sad8x8_avg_bits10,
            aom_highbd_10_dist_wtd_sub_pixel_avg_variance8x8);

        HIGHBD_BFP(
            BLOCK_8X4, aom_highbd_sad8x4_bits10, aom_highbd_sad8x4_avg_bits10,
            aom_highbd_10_variance8x4, aom_highbd_10_sub_pixel_variance8x4,
            aom_highbd_10_sub_pixel_avg_variance8x4,
            aom_highbd_sad8x4x4d_bits10, aom_highbd_dist_wtd_sad8x4_avg_bits10,
            aom_highbd_10_dist_wtd_sub_pixel_avg_variance8x4);

        HIGHBD_BFP(
            BLOCK_4X8, aom_highbd_sad4x8_bits10, aom_highbd_sad4x8_avg_bits10,
            aom_highbd_10_variance4x8, aom_highbd_10_sub_pixel_variance4x8,
            aom_highbd_10_sub_pixel_avg_variance4x8,
            aom_highbd_sad4x8x4d_bits10, aom_highbd_dist_wtd_sad4x8_avg_bits10,
            aom_highbd_10_dist_wtd_sub_pixel_avg_variance4x8);

        HIGHBD_BFP(
            BLOCK_4X4, aom_highbd_sad4x4_bits10, aom_highbd_sad4x4_avg_bits10,
            aom_highbd_10_variance4x4, aom_highbd_10_sub_pixel_variance4x4,
            aom_highbd_10_sub_pixel_avg_variance4x4,
            aom_highbd_sad4x4x4d_bits10, aom_highbd_dist_wtd_sad4x4_avg_bits10,
            aom_highbd_10_dist_wtd_sub_pixel_avg_variance4x4);

        HIGHBD_BFP(BLOCK_128X128, aom_highbd_sad128x128_bits10,
                   aom_highbd_sad128x128_avg_bits10,
                   aom_highbd_10_variance128x128,
                   aom_highbd_10_sub_pixel_variance128x128,
                   aom_highbd_10_sub_pixel_avg_variance128x128,
                   aom_highbd_sad128x128x4d_bits10,
                   aom_highbd_dist_wtd_sad128x128_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance128x128);

        HIGHBD_BFP(BLOCK_128X64, aom_highbd_sad128x64_bits10,
                   aom_highbd_sad128x64_avg_bits10,
                   aom_highbd_10_variance128x64,
                   aom_highbd_10_sub_pixel_variance128x64,
                   aom_highbd_10_sub_pixel_avg_variance128x64,
                   aom_highbd_sad128x64x4d_bits10,
                   aom_highbd_dist_wtd_sad128x64_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance128x64);

        HIGHBD_BFP(BLOCK_64X128, aom_highbd_sad64x128_bits10,
                   aom_highbd_sad64x128_avg_bits10,
                   aom_highbd_10_variance64x128,
                   aom_highbd_10_sub_pixel_variance64x128,
                   aom_highbd_10_sub_pixel_avg_variance64x128,
                   aom_highbd_sad64x128x4d_bits10,
                   aom_highbd_dist_wtd_sad64x128_avg_bits10,
                   aom_highbd_10_dist_wtd_sub_pixel_avg_variance64x128);

        HIGHBD_MBFP(BLOCK_128X128, aom_highbd_masked_sad128x128_bits10,
                    aom_highbd_10_masked_sub_pixel_variance128x128)
        HIGHBD_MBFP(BLOCK_128X64, aom_highbd_masked_sad128x64_bits10,
                    aom_highbd_10_masked_sub_pixel_variance128x64)
        HIGHBD_MBFP(BLOCK_64X128, aom_highbd_masked_sad64x128_bits10,
                    aom_highbd_10_masked_sub_pixel_variance64x128)
        HIGHBD_MBFP(BLOCK_64X64, aom_highbd_masked_sad64x64_bits10,
                    aom_highbd_10_masked_sub_pixel_variance64x64)
        HIGHBD_MBFP(BLOCK_64X32, aom_highbd_masked_sad64x32_bits10,
                    aom_highbd_10_masked_sub_pixel_variance64x32)
        HIGHBD_MBFP(BLOCK_32X64, aom_highbd_masked_sad32x64_bits10,
                    aom_highbd_10_masked_sub_pixel_variance32x64)
        HIGHBD_MBFP(BLOCK_32X32, aom_highbd_masked_sad32x32_bits10,
                    aom_highbd_10_masked_sub_pixel_variance32x32)
        HIGHBD_MBFP(BLOCK_32X16, aom_highbd_masked_sad32x16_bits10,
                    aom_highbd_10_masked_sub_pixel_variance32x16)
        HIGHBD_MBFP(BLOCK_16X32, aom_highbd_masked_sad16x32_bits10,
                    aom_highbd_10_masked_sub_pixel_variance16x32)
        HIGHBD_MBFP(BLOCK_16X16, aom_highbd_masked_sad16x16_bits10,
                    aom_highbd_10_masked_sub_pixel_variance16x16)
        HIGHBD_MBFP(BLOCK_8X16, aom_highbd_masked_sad8x16_bits10,
                    aom_highbd_10_masked_sub_pixel_variance8x16)
        HIGHBD_MBFP(BLOCK_16X8, aom_highbd_masked_sad16x8_bits10,
                    aom_highbd_10_masked_sub_pixel_variance16x8)
        HIGHBD_MBFP(BLOCK_8X8, aom_highbd_masked_sad8x8_bits10,
                    aom_highbd_10_masked_sub_pixel_variance8x8)
        HIGHBD_MBFP(BLOCK_4X8, aom_highbd_masked_sad4x8_bits10,
                    aom_highbd_10_masked_sub_pixel_variance4x8)
        HIGHBD_MBFP(BLOCK_8X4, aom_highbd_masked_sad8x4_bits10,
                    aom_highbd_10_masked_sub_pixel_variance8x4)
        HIGHBD_MBFP(BLOCK_4X4, aom_highbd_masked_sad4x4_bits10,
                    aom_highbd_10_masked_sub_pixel_variance4x4)
        HIGHBD_MBFP(BLOCK_64X16, aom_highbd_masked_sad64x16_bits10,
                    aom_highbd_10_masked_sub_pixel_variance64x16)
        HIGHBD_MBFP(BLOCK_16X64, aom_highbd_masked_sad16x64_bits10,
                    aom_highbd_10_masked_sub_pixel_variance16x64)
        HIGHBD_MBFP(BLOCK_32X8, aom_highbd_masked_sad32x8_bits10,
                    aom_highbd_10_masked_sub_pixel_variance32x8)
        HIGHBD_MBFP(BLOCK_8X32, aom_highbd_masked_sad8x32_bits10,
                    aom_highbd_10_masked_sub_pixel_variance8x32)
        HIGHBD_MBFP(BLOCK_16X4, aom_highbd_masked_sad16x4_bits10,
                    aom_highbd_10_masked_sub_pixel_variance16x4)
        HIGHBD_MBFP(BLOCK_4X16, aom_highbd_masked_sad4x16_bits10,
                    aom_highbd_10_masked_sub_pixel_variance4x16)
        HIGHBD_OBFP(BLOCK_128X128, aom_highbd_obmc_sad128x128_bits10,
                    aom_highbd_10_obmc_variance128x128,
                    aom_highbd_10_obmc_sub_pixel_variance128x128)
        HIGHBD_OBFP(BLOCK_128X64, aom_highbd_obmc_sad128x64_bits10,
                    aom_highbd_10_obmc_variance128x64,
                    aom_highbd_10_obmc_sub_pixel_variance128x64)
        HIGHBD_OBFP(BLOCK_64X128, aom_highbd_obmc_sad64x128_bits10,
                    aom_highbd_10_obmc_variance64x128,
                    aom_highbd_10_obmc_sub_pixel_variance64x128)
        HIGHBD_OBFP(BLOCK_64X64, aom_highbd_obmc_sad64x64_bits10,
                    aom_highbd_10_obmc_variance64x64,
                    aom_highbd_10_obmc_sub_pixel_variance64x64)
        HIGHBD_OBFP(BLOCK_64X32, aom_highbd_obmc_sad64x32_bits10,
                    aom_highbd_10_obmc_variance64x32,
                    aom_highbd_10_obmc_sub_pixel_variance64x32)
        HIGHBD_OBFP(BLOCK_32X64, aom_highbd_obmc_sad32x64_bits10,
                    aom_highbd_10_obmc_variance32x64,
                    aom_highbd_10_obmc_sub_pixel_variance32x64)
        HIGHBD_OBFP(BLOCK_32X32, aom_highbd_obmc_sad32x32_bits10,
                    aom_highbd_10_obmc_variance32x32,
                    aom_highbd_10_obmc_sub_pixel_variance32x32)
        HIGHBD_OBFP(BLOCK_32X16, aom_highbd_obmc_sad32x16_bits10,
                    aom_highbd_10_obmc_variance32x16,
                    aom_highbd_10_obmc_sub_pixel_variance32x16)
        HIGHBD_OBFP(BLOCK_16X32, aom_highbd_obmc_sad16x32_bits10,
                    aom_highbd_10_obmc_variance16x32,
                    aom_highbd_10_obmc_sub_pixel_variance16x32)
        HIGHBD_OBFP(BLOCK_16X16, aom_highbd_obmc_sad16x16_bits10,
                    aom_highbd_10_obmc_variance16x16,
                    aom_highbd_10_obmc_sub_pixel_variance16x16)
        HIGHBD_OBFP(BLOCK_8X16, aom_highbd_obmc_sad8x16_bits10,
                    aom_highbd_10_obmc_variance8x16,
                    aom_highbd_10_obmc_sub_pixel_variance8x16)
        HIGHBD_OBFP(BLOCK_16X8, aom_highbd_obmc_sad16x8_bits10,
                    aom_highbd_10_obmc_variance16x8,
                    aom_highbd_10_obmc_sub_pixel_variance16x8)
        HIGHBD_OBFP(BLOCK_8X8, aom_highbd_obmc_sad8x8_bits10,
                    aom_highbd_10_obmc_variance8x8,
                    aom_highbd_10_obmc_sub_pixel_variance8x8)
        HIGHBD_OBFP(BLOCK_4X8, aom_highbd_obmc_sad4x8_bits10,
                    aom_highbd_10_obmc_variance4x8,
                    aom_highbd_10_obmc_sub_pixel_variance4x8)
        HIGHBD_OBFP(BLOCK_8X4, aom_highbd_obmc_sad8x4_bits10,
                    aom_highbd_10_obmc_variance8x4,
                    aom_highbd_10_obmc_sub_pixel_variance8x4)
        HIGHBD_OBFP(BLOCK_4X4, aom_highbd_obmc_sad4x4_bits10,
                    aom_highbd_10_obmc_variance4x4,
                    aom_highbd_10_obmc_sub_pixel_variance4x4)

        HIGHBD_OBFP(BLOCK_64X16, aom_highbd_obmc_sad64x16_bits10,
                    aom_highbd_10_obmc_variance64x16,
                    aom_highbd_10_obmc_sub_pixel_variance64x16)

        HIGHBD_OBFP(BLOCK_16X64, aom_highbd_obmc_sad16x64_bits10,
                    aom_highbd_10_obmc_variance16x64,
                    aom_highbd_10_obmc_sub_pixel_variance16x64)

        HIGHBD_OBFP(BLOCK_32X8, aom_highbd_obmc_sad32x8_bits10,
                    aom_highbd_10_obmc_variance32x8,
                    aom_highbd_10_obmc_sub_pixel_variance32x8)

        HIGHBD_OBFP(BLOCK_8X32, aom_highbd_obmc_sad8x32_bits10,
                    aom_highbd_10_obmc_variance8x32,
                    aom_highbd_10_obmc_sub_pixel_variance8x32)

        HIGHBD_OBFP(BLOCK_16X4, aom_highbd_obmc_sad16x4_bits10,
                    aom_highbd_10_obmc_variance16x4,
                    aom_highbd_10_obmc_sub_pixel_variance16x4)

        HIGHBD_OBFP(BLOCK_4X16, aom_highbd_obmc_sad4x16_bits10,
                    aom_highbd_10_obmc_variance4x16,
                    aom_highbd_10_obmc_sub_pixel_variance4x16)
        break;

      case AOM_BITS_12:
        HIGHBD_BFP(BLOCK_64X16, aom_highbd_sad64x16_bits12,
                   aom_highbd_sad64x16_avg_bits12, aom_highbd_12_variance64x16,
                   aom_highbd_12_sub_pixel_variance64x16,
                   aom_highbd_12_sub_pixel_avg_variance64x16,
                   aom_highbd_sad64x16x4d_bits12,
                   aom_highbd_dist_wtd_sad64x16_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance64x16);

        HIGHBD_BFP(BLOCK_16X64, aom_highbd_sad16x64_bits12,
                   aom_highbd_sad16x64_avg_bits12, aom_highbd_12_variance16x64,
                   aom_highbd_12_sub_pixel_variance16x64,
                   aom_highbd_12_sub_pixel_avg_variance16x64,
                   aom_highbd_sad16x64x4d_bits12,
                   aom_highbd_dist_wtd_sad16x64_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance16x64);

        HIGHBD_BFP(BLOCK_32X8, aom_highbd_sad32x8_bits12,
                   aom_highbd_sad32x8_avg_bits12, aom_highbd_12_variance32x8,
                   aom_highbd_12_sub_pixel_variance32x8,
                   aom_highbd_12_sub_pixel_avg_variance32x8,
                   aom_highbd_sad32x8x4d_bits12,
                   aom_highbd_dist_wtd_sad32x8_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance32x8);

        HIGHBD_BFP(BLOCK_8X32, aom_highbd_sad8x32_bits12,
                   aom_highbd_sad8x32_avg_bits12, aom_highbd_12_variance8x32,
                   aom_highbd_12_sub_pixel_variance8x32,
                   aom_highbd_12_sub_pixel_avg_variance8x32,
                   aom_highbd_sad8x32x4d_bits12,
                   aom_highbd_dist_wtd_sad8x32_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance8x32);

        HIGHBD_BFP(BLOCK_16X4, aom_highbd_sad16x4_bits12,
                   aom_highbd_sad16x4_avg_bits12, aom_highbd_12_variance16x4,
                   aom_highbd_12_sub_pixel_variance16x4,
                   aom_highbd_12_sub_pixel_avg_variance16x4,
                   aom_highbd_sad16x4x4d_bits12,
                   aom_highbd_dist_wtd_sad16x4_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance16x4);

        HIGHBD_BFP(BLOCK_4X16, aom_highbd_sad4x16_bits12,
                   aom_highbd_sad4x16_avg_bits12, aom_highbd_12_variance4x16,
                   aom_highbd_12_sub_pixel_variance4x16,
                   aom_highbd_12_sub_pixel_avg_variance4x16,
                   aom_highbd_sad4x16x4d_bits12,
                   aom_highbd_dist_wtd_sad4x16_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance4x16);

        HIGHBD_BFP(BLOCK_32X16, aom_highbd_sad32x16_bits12,
                   aom_highbd_sad32x16_avg_bits12, aom_highbd_12_variance32x16,
                   aom_highbd_12_sub_pixel_variance32x16,
                   aom_highbd_12_sub_pixel_avg_variance32x16,
                   aom_highbd_sad32x16x4d_bits12,
                   aom_highbd_dist_wtd_sad32x16_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance32x16);

        HIGHBD_BFP(BLOCK_16X32, aom_highbd_sad16x32_bits12,
                   aom_highbd_sad16x32_avg_bits12, aom_highbd_12_variance16x32,
                   aom_highbd_12_sub_pixel_variance16x32,
                   aom_highbd_12_sub_pixel_avg_variance16x32,
                   aom_highbd_sad16x32x4d_bits12,
                   aom_highbd_dist_wtd_sad16x32_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance16x32);

        HIGHBD_BFP(BLOCK_64X32, aom_highbd_sad64x32_bits12,
                   aom_highbd_sad64x32_avg_bits12, aom_highbd_12_variance64x32,
                   aom_highbd_12_sub_pixel_variance64x32,
                   aom_highbd_12_sub_pixel_avg_variance64x32,
                   aom_highbd_sad64x32x4d_bits12,
                   aom_highbd_dist_wtd_sad64x32_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance64x32);

        HIGHBD_BFP(BLOCK_32X64, aom_highbd_sad32x64_bits12,
                   aom_highbd_sad32x64_avg_bits12, aom_highbd_12_variance32x64,
                   aom_highbd_12_sub_pixel_variance32x64,
                   aom_highbd_12_sub_pixel_avg_variance32x64,
                   aom_highbd_sad32x64x4d_bits12,
                   aom_highbd_dist_wtd_sad32x64_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance32x64);

        HIGHBD_BFP(BLOCK_32X32, aom_highbd_sad32x32_bits12,
                   aom_highbd_sad32x32_avg_bits12, aom_highbd_12_variance32x32,
                   aom_highbd_12_sub_pixel_variance32x32,
                   aom_highbd_12_sub_pixel_avg_variance32x32,
                   aom_highbd_sad32x32x4d_bits12,
                   aom_highbd_dist_wtd_sad32x32_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance32x32);

        HIGHBD_BFP(BLOCK_64X64, aom_highbd_sad64x64_bits12,
                   aom_highbd_sad64x64_avg_bits12, aom_highbd_12_variance64x64,
                   aom_highbd_12_sub_pixel_variance64x64,
                   aom_highbd_12_sub_pixel_avg_variance64x64,
                   aom_highbd_sad64x64x4d_bits12,
                   aom_highbd_dist_wtd_sad64x64_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance64x64);

        HIGHBD_BFP(BLOCK_16X16, aom_highbd_sad16x16_bits12,
                   aom_highbd_sad16x16_avg_bits12, aom_highbd_12_variance16x16,
                   aom_highbd_12_sub_pixel_variance16x16,
                   aom_highbd_12_sub_pixel_avg_variance16x16,
                   aom_highbd_sad16x16x4d_bits12,
                   aom_highbd_dist_wtd_sad16x16_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance16x16);

        HIGHBD_BFP(BLOCK_16X8, aom_highbd_sad16x8_bits12,
                   aom_highbd_sad16x8_avg_bits12, aom_highbd_12_variance16x8,
                   aom_highbd_12_sub_pixel_variance16x8,
                   aom_highbd_12_sub_pixel_avg_variance16x8,
                   aom_highbd_sad16x8x4d_bits12,
                   aom_highbd_dist_wtd_sad16x8_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance16x8);

        HIGHBD_BFP(BLOCK_8X16, aom_highbd_sad8x16_bits12,
                   aom_highbd_sad8x16_avg_bits12, aom_highbd_12_variance8x16,
                   aom_highbd_12_sub_pixel_variance8x16,
                   aom_highbd_12_sub_pixel_avg_variance8x16,
                   aom_highbd_sad8x16x4d_bits12,
                   aom_highbd_dist_wtd_sad8x16_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance8x16);

        HIGHBD_BFP(
            BLOCK_8X8, aom_highbd_sad8x8_bits12, aom_highbd_sad8x8_avg_bits12,
            aom_highbd_12_variance8x8, aom_highbd_12_sub_pixel_variance8x8,
            aom_highbd_12_sub_pixel_avg_variance8x8,
            aom_highbd_sad8x8x4d_bits12, aom_highbd_dist_wtd_sad8x8_avg_bits12,
            aom_highbd_12_dist_wtd_sub_pixel_avg_variance8x8);

        HIGHBD_BFP(
            BLOCK_8X4, aom_highbd_sad8x4_bits12, aom_highbd_sad8x4_avg_bits12,
            aom_highbd_12_variance8x4, aom_highbd_12_sub_pixel_variance8x4,
            aom_highbd_12_sub_pixel_avg_variance8x4,
            aom_highbd_sad8x4x4d_bits12, aom_highbd_dist_wtd_sad8x4_avg_bits12,
            aom_highbd_12_dist_wtd_sub_pixel_avg_variance8x4);

        HIGHBD_BFP(
            BLOCK_4X8, aom_highbd_sad4x8_bits12, aom_highbd_sad4x8_avg_bits12,
            aom_highbd_12_variance4x8, aom_highbd_12_sub_pixel_variance4x8,
            aom_highbd_12_sub_pixel_avg_variance4x8,
            aom_highbd_sad4x8x4d_bits12, aom_highbd_dist_wtd_sad4x8_avg_bits12,
            aom_highbd_12_dist_wtd_sub_pixel_avg_variance4x8);

        HIGHBD_BFP(
            BLOCK_4X4, aom_highbd_sad4x4_bits12, aom_highbd_sad4x4_avg_bits12,
            aom_highbd_12_variance4x4, aom_highbd_12_sub_pixel_variance4x4,
            aom_highbd_12_sub_pixel_avg_variance4x4,
            aom_highbd_sad4x4x4d_bits12, aom_highbd_dist_wtd_sad4x4_avg_bits12,
            aom_highbd_12_dist_wtd_sub_pixel_avg_variance4x4);

        HIGHBD_BFP(BLOCK_128X128, aom_highbd_sad128x128_bits12,
                   aom_highbd_sad128x128_avg_bits12,
                   aom_highbd_12_variance128x128,
                   aom_highbd_12_sub_pixel_variance128x128,
                   aom_highbd_12_sub_pixel_avg_variance128x128,
                   aom_highbd_sad128x128x4d_bits12,
                   aom_highbd_dist_wtd_sad128x128_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance128x128);

        HIGHBD_BFP(BLOCK_128X64, aom_highbd_sad128x64_bits12,
                   aom_highbd_sad128x64_avg_bits12,
                   aom_highbd_12_variance128x64,
                   aom_highbd_12_sub_pixel_variance128x64,
                   aom_highbd_12_sub_pixel_avg_variance128x64,
                   aom_highbd_sad128x64x4d_bits12,
                   aom_highbd_dist_wtd_sad128x64_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance128x64);

        HIGHBD_BFP(BLOCK_64X128, aom_highbd_sad64x128_bits12,
                   aom_highbd_sad64x128_avg_bits12,
                   aom_highbd_12_variance64x128,
                   aom_highbd_12_sub_pixel_variance64x128,
                   aom_highbd_12_sub_pixel_avg_variance64x128,
                   aom_highbd_sad64x128x4d_bits12,
                   aom_highbd_dist_wtd_sad64x128_avg_bits12,
                   aom_highbd_12_dist_wtd_sub_pixel_avg_variance64x128);

        HIGHBD_MBFP(BLOCK_128X128, aom_highbd_masked_sad128x128_bits12,
                    aom_highbd_12_masked_sub_pixel_variance128x128)
        HIGHBD_MBFP(BLOCK_128X64, aom_highbd_masked_sad128x64_bits12,
                    aom_highbd_12_masked_sub_pixel_variance128x64)
        HIGHBD_MBFP(BLOCK_64X128, aom_highbd_masked_sad64x128_bits12,
                    aom_highbd_12_masked_sub_pixel_variance64x128)
        HIGHBD_MBFP(BLOCK_64X64, aom_highbd_masked_sad64x64_bits12,
                    aom_highbd_12_masked_sub_pixel_variance64x64)
        HIGHBD_MBFP(BLOCK_64X32, aom_highbd_masked_sad64x32_bits12,
                    aom_highbd_12_masked_sub_pixel_variance64x32)
        HIGHBD_MBFP(BLOCK_32X64, aom_highbd_masked_sad32x64_bits12,
                    aom_highbd_12_masked_sub_pixel_variance32x64)
        HIGHBD_MBFP(BLOCK_32X32, aom_highbd_masked_sad32x32_bits12,
                    aom_highbd_12_masked_sub_pixel_variance32x32)
        HIGHBD_MBFP(BLOCK_32X16, aom_highbd_masked_sad32x16_bits12,
                    aom_highbd_12_masked_sub_pixel_variance32x16)
        HIGHBD_MBFP(BLOCK_16X32, aom_highbd_masked_sad16x32_bits12,
                    aom_highbd_12_masked_sub_pixel_variance16x32)
        HIGHBD_MBFP(BLOCK_16X16, aom_highbd_masked_sad16x16_bits12,
                    aom_highbd_12_masked_sub_pixel_variance16x16)
        HIGHBD_MBFP(BLOCK_8X16, aom_highbd_masked_sad8x16_bits12,
                    aom_highbd_12_masked_sub_pixel_variance8x16)
        HIGHBD_MBFP(BLOCK_16X8, aom_highbd_masked_sad16x8_bits12,
                    aom_highbd_12_masked_sub_pixel_variance16x8)
        HIGHBD_MBFP(BLOCK_8X8, aom_highbd_masked_sad8x8_bits12,
                    aom_highbd_12_masked_sub_pixel_variance8x8)
        HIGHBD_MBFP(BLOCK_4X8, aom_highbd_masked_sad4x8_bits12,
                    aom_highbd_12_masked_sub_pixel_variance4x8)
        HIGHBD_MBFP(BLOCK_8X4, aom_highbd_masked_sad8x4_bits12,
                    aom_highbd_12_masked_sub_pixel_variance8x4)
        HIGHBD_MBFP(BLOCK_4X4, aom_highbd_masked_sad4x4_bits12,
                    aom_highbd_12_masked_sub_pixel_variance4x4)
        HIGHBD_MBFP(BLOCK_64X16, aom_highbd_masked_sad64x16_bits12,
                    aom_highbd_12_masked_sub_pixel_variance64x16)
        HIGHBD_MBFP(BLOCK_16X64, aom_highbd_masked_sad16x64_bits12,
                    aom_highbd_12_masked_sub_pixel_variance16x64)
        HIGHBD_MBFP(BLOCK_32X8, aom_highbd_masked_sad32x8_bits12,
                    aom_highbd_12_masked_sub_pixel_variance32x8)
        HIGHBD_MBFP(BLOCK_8X32, aom_highbd_masked_sad8x32_bits12,
                    aom_highbd_12_masked_sub_pixel_variance8x32)
        HIGHBD_MBFP(BLOCK_16X4, aom_highbd_masked_sad16x4_bits12,
                    aom_highbd_12_masked_sub_pixel_variance16x4)
        HIGHBD_MBFP(BLOCK_4X16, aom_highbd_masked_sad4x16_bits12,
                    aom_highbd_12_masked_sub_pixel_variance4x16)
        HIGHBD_OBFP(BLOCK_128X128, aom_highbd_obmc_sad128x128_bits12,
                    aom_highbd_12_obmc_variance128x128,
                    aom_highbd_12_obmc_sub_pixel_variance128x128)
        HIGHBD_OBFP(BLOCK_128X64, aom_highbd_obmc_sad128x64_bits12,
                    aom_highbd_12_obmc_variance128x64,
                    aom_highbd_12_obmc_sub_pixel_variance128x64)
        HIGHBD_OBFP(BLOCK_64X128, aom_highbd_obmc_sad64x128_bits12,
                    aom_highbd_12_obmc_variance64x128,
                    aom_highbd_12_obmc_sub_pixel_variance64x128)
        HIGHBD_OBFP(BLOCK_64X64, aom_highbd_obmc_sad64x64_bits12,
                    aom_highbd_12_obmc_variance64x64,
                    aom_highbd_12_obmc_sub_pixel_variance64x64)
        HIGHBD_OBFP(BLOCK_64X32, aom_highbd_obmc_sad64x32_bits12,
                    aom_highbd_12_obmc_variance64x32,
                    aom_highbd_12_obmc_sub_pixel_variance64x32)
        HIGHBD_OBFP(BLOCK_32X64, aom_highbd_obmc_sad32x64_bits12,
                    aom_highbd_12_obmc_variance32x64,
                    aom_highbd_12_obmc_sub_pixel_variance32x64)
        HIGHBD_OBFP(BLOCK_32X32, aom_highbd_obmc_sad32x32_bits12,
                    aom_highbd_12_obmc_variance32x32,
                    aom_highbd_12_obmc_sub_pixel_variance32x32)
        HIGHBD_OBFP(BLOCK_32X16, aom_highbd_obmc_sad32x16_bits12,
                    aom_highbd_12_obmc_variance32x16,
                    aom_highbd_12_obmc_sub_pixel_variance32x16)
        HIGHBD_OBFP(BLOCK_16X32, aom_highbd_obmc_sad16x32_bits12,
                    aom_highbd_12_obmc_variance16x32,
                    aom_highbd_12_obmc_sub_pixel_variance16x32)
        HIGHBD_OBFP(BLOCK_16X16, aom_highbd_obmc_sad16x16_bits12,
                    aom_highbd_12_obmc_variance16x16,
                    aom_highbd_12_obmc_sub_pixel_variance16x16)
        HIGHBD_OBFP(BLOCK_8X16, aom_highbd_obmc_sad8x16_bits12,
                    aom_highbd_12_obmc_variance8x16,
                    aom_highbd_12_obmc_sub_pixel_variance8x16)
        HIGHBD_OBFP(BLOCK_16X8, aom_highbd_obmc_sad16x8_bits12,
                    aom_highbd_12_obmc_variance16x8,
                    aom_highbd_12_obmc_sub_pixel_variance16x8)
        HIGHBD_OBFP(BLOCK_8X8, aom_highbd_obmc_sad8x8_bits12,
                    aom_highbd_12_obmc_variance8x8,
                    aom_highbd_12_obmc_sub_pixel_variance8x8)
        HIGHBD_OBFP(BLOCK_4X8, aom_highbd_obmc_sad4x8_bits12,
                    aom_highbd_12_obmc_variance4x8,
                    aom_highbd_12_obmc_sub_pixel_variance4x8)
        HIGHBD_OBFP(BLOCK_8X4, aom_highbd_obmc_sad8x4_bits12,
                    aom_highbd_12_obmc_variance8x4,
                    aom_highbd_12_obmc_sub_pixel_variance8x4)
        HIGHBD_OBFP(BLOCK_4X4, aom_highbd_obmc_sad4x4_bits12,
                    aom_highbd_12_obmc_variance4x4,
                    aom_highbd_12_obmc_sub_pixel_variance4x4)
        HIGHBD_OBFP(BLOCK_64X16, aom_highbd_obmc_sad64x16_bits12,
                    aom_highbd_12_obmc_variance64x16,
                    aom_highbd_12_obmc_sub_pixel_variance64x16)
        HIGHBD_OBFP(BLOCK_16X64, aom_highbd_obmc_sad16x64_bits12,
                    aom_highbd_12_obmc_variance16x64,
                    aom_highbd_12_obmc_sub_pixel_variance16x64)
        HIGHBD_OBFP(BLOCK_32X8, aom_highbd_obmc_sad32x8_bits12,
                    aom_highbd_12_obmc_variance32x8,
                    aom_highbd_12_obmc_sub_pixel_variance32x8)
        HIGHBD_OBFP(BLOCK_8X32, aom_highbd_obmc_sad8x32_bits12,
                    aom_highbd_12_obmc_variance8x32,
                    aom_highbd_12_obmc_sub_pixel_variance8x32)
        HIGHBD_OBFP(BLOCK_16X4, aom_highbd_obmc_sad16x4_bits12,
                    aom_highbd_12_obmc_variance16x4,
                    aom_highbd_12_obmc_sub_pixel_variance16x4)
        HIGHBD_OBFP(BLOCK_4X16, aom_highbd_obmc_sad4x16_bits12,
                    aom_highbd_12_obmc_variance4x16,
                    aom_highbd_12_obmc_sub_pixel_variance4x16)
        break;

      default:
        assert(0 &&
               "cm->seq_params.bit_depth should be AOM_BITS_8, "
               "AOM_BITS_10 or AOM_BITS_12");
    }
  }
}
#endif  // CONFIG_AV1_HIGHBITDEPTH

static void realloc_segmentation_maps(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  CommonModeInfoParams *const mi_params = &cm->mi_params;

  // Create the encoder segmentation map and set all entries to 0
  aom_free(cpi->enc_seg.map);
  CHECK_MEM_ERROR(cm, cpi->enc_seg.map,
                  aom_calloc(mi_params->mi_rows * mi_params->mi_cols, 1));

  // Create a map used for cyclic background refresh.
  if (cpi->cyclic_refresh) av1_cyclic_refresh_free(cpi->cyclic_refresh);
  CHECK_MEM_ERROR(
      cm, cpi->cyclic_refresh,
      av1_cyclic_refresh_alloc(mi_params->mi_rows, mi_params->mi_cols));

  // Create a map used to mark inactive areas.
  aom_free(cpi->active_map.map);
  CHECK_MEM_ERROR(cm, cpi->active_map.map,
                  aom_calloc(mi_params->mi_rows * mi_params->mi_cols, 1));
}

static AOM_INLINE void set_tpl_stats_block_size(int width, int height,
                                                uint8_t *block_mis_log2) {
  const int is_720p_or_larger = AOMMIN(width, height) >= 720;

  // 0: 4x4, 1: 8x8, 2: 16x16
  *block_mis_log2 = is_720p_or_larger ? 2 : 1;
}

void av1_alloc_compound_type_rd_buffers(AV1_COMMON *const cm,
                                        CompoundTypeRdBuffers *const bufs) {
  CHECK_MEM_ERROR(
      cm, bufs->pred0,
      (uint8_t *)aom_memalign(16, 2 * MAX_SB_SQUARE * sizeof(*bufs->pred0)));
  CHECK_MEM_ERROR(
      cm, bufs->pred1,
      (uint8_t *)aom_memalign(16, 2 * MAX_SB_SQUARE * sizeof(*bufs->pred1)));
  CHECK_MEM_ERROR(
      cm, bufs->residual1,
      (int16_t *)aom_memalign(32, MAX_SB_SQUARE * sizeof(*bufs->residual1)));
  CHECK_MEM_ERROR(
      cm, bufs->diff10,
      (int16_t *)aom_memalign(32, MAX_SB_SQUARE * sizeof(*bufs->diff10)));
  CHECK_MEM_ERROR(cm, bufs->tmp_best_mask_buf,
                  (uint8_t *)aom_malloc(2 * MAX_SB_SQUARE *
                                        sizeof(*bufs->tmp_best_mask_buf)));
}

void av1_release_compound_type_rd_buffers(CompoundTypeRdBuffers *const bufs) {
  aom_free(bufs->pred0);
  aom_free(bufs->pred1);
  aom_free(bufs->residual1);
  aom_free(bufs->diff10);
  aom_free(bufs->tmp_best_mask_buf);
  av1_zero(*bufs);  // Set all pointers to NULL for safety.
}

static void config_target_level(AV1_COMP *const cpi, AV1_LEVEL target_level,
                                int tier) {
  aom_clear_system_state();

  AV1EncoderConfig *const oxcf = &cpi->oxcf;
  SequenceHeader *const seq_params = &cpi->common.seq_params;

  // Adjust target bitrate to be no larger than 70% of level limit.
  const BITSTREAM_PROFILE profile = seq_params->profile;
  const double level_bitrate_limit =
      av1_get_max_bitrate_for_level(target_level, tier, profile);
  const int64_t max_bitrate = (int64_t)(level_bitrate_limit * 0.70);
  oxcf->target_bandwidth = AOMMIN(oxcf->target_bandwidth, max_bitrate);
  // Also need to update cpi->twopass.bits_left.
  TWO_PASS *const twopass = &cpi->twopass;
  FIRSTPASS_STATS *stats = twopass->stats_buf_ctx->total_stats;
  if (stats != NULL)
    cpi->twopass.bits_left =
        (int64_t)(stats->duration * cpi->oxcf.target_bandwidth / 10000000.0);

  // Adjust max over-shoot percentage.
  oxcf->over_shoot_pct = 0;

  // Adjust max quantizer.
  oxcf->worst_allowed_q = 255;

  // Adjust number of tiles and tile columns to be under level limit.
  int max_tiles, max_tile_cols;
  av1_get_max_tiles_for_level(target_level, &max_tiles, &max_tile_cols);
  while (oxcf->tile_columns > 0 && (1 << oxcf->tile_columns) > max_tile_cols) {
    --oxcf->tile_columns;
  }
  const int tile_cols = (1 << oxcf->tile_columns);
  while (oxcf->tile_rows > 0 &&
         tile_cols * (1 << oxcf->tile_rows) > max_tiles) {
    --oxcf->tile_rows;
  }

  // Adjust min compression ratio.
  const int still_picture = seq_params->still_picture;
  const double min_cr =
      av1_get_min_cr_for_level(target_level, tier, still_picture);
  oxcf->min_cr = AOMMAX(oxcf->min_cr, (unsigned int)(min_cr * 100));
}

void av1_change_config(struct AV1_COMP *cpi, const AV1EncoderConfig *oxcf) {
  AV1_COMMON *const cm = &cpi->common;
  SequenceHeader *const seq_params = &cm->seq_params;
  const int num_planes = av1_num_planes(cm);
  RATE_CONTROL *const rc = &cpi->rc;
  MACROBLOCK *const x = &cpi->td.mb;
  AV1LevelParams *const level_params = &cpi->level_params;

  if (seq_params->profile != oxcf->profile) seq_params->profile = oxcf->profile;
  seq_params->bit_depth = oxcf->bit_depth;
  seq_params->color_primaries = oxcf->color_primaries;
  seq_params->transfer_characteristics = oxcf->transfer_characteristics;
  seq_params->matrix_coefficients = oxcf->matrix_coefficients;
  seq_params->monochrome = oxcf->monochrome;
  seq_params->chroma_sample_position = oxcf->chroma_sample_position;
  seq_params->color_range = oxcf->color_range;

  assert(IMPLIES(seq_params->profile <= PROFILE_1,
                 seq_params->bit_depth <= AOM_BITS_10));

  seq_params->timing_info_present = oxcf->timing_info_present;
  seq_params->timing_info.num_units_in_display_tick =
      oxcf->timing_info.num_units_in_display_tick;
  seq_params->timing_info.time_scale = oxcf->timing_info.time_scale;
  seq_params->timing_info.equal_picture_interval =
      oxcf->timing_info.equal_picture_interval;
  seq_params->timing_info.num_ticks_per_picture =
      oxcf->timing_info.num_ticks_per_picture;

  seq_params->display_model_info_present_flag =
      oxcf->display_model_info_present_flag;
  seq_params->decoder_model_info_present_flag =
      oxcf->decoder_model_info_present_flag;
  if (oxcf->decoder_model_info_present_flag) {
    // set the decoder model parameters in schedule mode
    seq_params->decoder_model_info.num_units_in_decoding_tick =
        oxcf->buffer_model.num_units_in_decoding_tick;
    cm->buffer_removal_time_present = 1;
    av1_set_aom_dec_model_info(&seq_params->decoder_model_info);
    av1_set_dec_model_op_parameters(&seq_params->op_params[0]);
  } else if (seq_params->timing_info_present &&
             seq_params->timing_info.equal_picture_interval &&
             !seq_params->decoder_model_info_present_flag) {
    // set the decoder model parameters in resource availability mode
    av1_set_resource_availability_parameters(&seq_params->op_params[0]);
  } else {
    seq_params->op_params[0].initial_display_delay =
        10;  // Default value (not signaled)
  }

  update_film_grain_parameters(cpi, oxcf);

  cpi->oxcf = *oxcf;
  cpi->superres_mode = oxcf->superres_mode;  // default
  x->e_mbd.bd = (int)seq_params->bit_depth;
  x->e_mbd.global_motion = cm->global_motion;

  memcpy(level_params->target_seq_level_idx, cpi->oxcf.target_seq_level_idx,
         sizeof(level_params->target_seq_level_idx));
  level_params->keep_level_stats = 0;
  for (int i = 0; i < MAX_NUM_OPERATING_POINTS; ++i) {
    if (level_params->target_seq_level_idx[i] <= SEQ_LEVELS) {
      level_params->keep_level_stats |= 1u << i;
      if (!level_params->level_info[i]) {
        CHECK_MEM_ERROR(cm, level_params->level_info[i],
                        aom_calloc(1, sizeof(*level_params->level_info[i])));
      }
    }
  }

  // TODO(huisu@): level targeting currently only works for the 0th operating
  // point, so scalable coding is not supported yet.
  if (level_params->target_seq_level_idx[0] < SEQ_LEVELS) {
    // Adjust encoder config in order to meet target level.
    config_target_level(cpi, level_params->target_seq_level_idx[0],
                        seq_params->tier[0]);
  }

  if ((has_no_stats_stage(cpi)) && (oxcf->rc_mode == AOM_Q)) {
    rc->baseline_gf_interval = FIXED_GF_INTERVAL;
  } else {
    rc->baseline_gf_interval = (MIN_GF_INTERVAL + MAX_GF_INTERVAL) / 2;
  }

  cpi->refresh_golden_frame = 0;
  cpi->refresh_bwd_ref_frame = 0;

  cm->features.refresh_frame_context = (oxcf->frame_parallel_decoding_mode)
                                           ? REFRESH_FRAME_CONTEXT_DISABLED
                                           : REFRESH_FRAME_CONTEXT_BACKWARD;
  if (oxcf->large_scale_tile)
    cm->features.refresh_frame_context = REFRESH_FRAME_CONTEXT_DISABLED;

  if (x->palette_buffer == NULL) {
    CHECK_MEM_ERROR(cm, x->palette_buffer,
                    aom_memalign(16, sizeof(*x->palette_buffer)));
  }

  if (x->comp_rd_buffer.pred0 == NULL) {
    av1_alloc_compound_type_rd_buffers(cm, &x->comp_rd_buffer);
  }

  if (x->tmp_conv_dst == NULL) {
    CHECK_MEM_ERROR(
        cm, x->tmp_conv_dst,
        aom_memalign(32, MAX_SB_SIZE * MAX_SB_SIZE * sizeof(*x->tmp_conv_dst)));
    x->e_mbd.tmp_conv_dst = x->tmp_conv_dst;
  }
  for (int i = 0; i < 2; ++i) {
    if (x->tmp_obmc_bufs[i] == NULL) {
      CHECK_MEM_ERROR(cm, x->tmp_obmc_bufs[i],
                      aom_memalign(32, 2 * MAX_MB_PLANE * MAX_SB_SQUARE *
                                           sizeof(*x->tmp_obmc_bufs[i])));
      x->e_mbd.tmp_obmc_bufs[i] = x->tmp_obmc_bufs[i];
    }
  }

  av1_reset_segment_features(cm);

  av1_set_high_precision_mv(cpi, 1, 0);

  set_rc_buffer_sizes(rc, &cpi->oxcf);

  // Under a configuration change, where maximum_buffer_size may change,
  // keep buffer level clipped to the maximum allowed buffer size.
  rc->bits_off_target = AOMMIN(rc->bits_off_target, rc->maximum_buffer_size);
  rc->buffer_level = AOMMIN(rc->buffer_level, rc->maximum_buffer_size);

  // Set up frame rate and related parameters rate control values.
  av1_new_framerate(cpi, cpi->framerate);

  // Set absolute upper and lower quality limits
  rc->worst_quality = cpi->oxcf.worst_allowed_q;
  rc->best_quality = cpi->oxcf.best_allowed_q;

  cm->features.interp_filter =
      oxcf->large_scale_tile ? EIGHTTAP_REGULAR : SWITCHABLE;
  cm->features.switchable_motion_mode = 1;

  if (cpi->oxcf.render_width > 0 && cpi->oxcf.render_height > 0) {
    cm->render_width = cpi->oxcf.render_width;
    cm->render_height = cpi->oxcf.render_height;
  } else {
    cm->render_width = cpi->oxcf.width;
    cm->render_height = cpi->oxcf.height;
  }
  cm->width = cpi->oxcf.width;
  cm->height = cpi->oxcf.height;

  int sb_size = seq_params->sb_size;
  // Superblock size should not be updated after the first key frame.
  if (!cpi->seq_params_locked) {
    set_sb_size(&cm->seq_params, select_sb_size(cpi));
    for (int i = 0; i < MAX_NUM_OPERATING_POINTS; ++i)
      seq_params->tier[i] = (oxcf->tier_mask >> i) & 1;
  }

  if (cpi->initial_width || sb_size != seq_params->sb_size) {
    if (cm->width > cpi->initial_width || cm->height > cpi->initial_height ||
        seq_params->sb_size != sb_size) {
      av1_free_context_buffers(cm);
      av1_free_pc_tree(cpi, &cpi->td, num_planes, (BLOCK_SIZE)sb_size);
      alloc_compressor_data(cpi);
      realloc_segmentation_maps(cpi);
      cpi->initial_width = cpi->initial_height = 0;
    }
  }
  update_frame_size(cpi);

  rc->is_src_frame_alt_ref = 0;

  set_tile_info(cpi);

  if (!cpi->svc.external_ref_frame_config)
    cpi->ext_flags.refresh_frame_flags_pending = 0;
  cpi->ext_flags.refresh_frame_context_pending = 0;

#if CONFIG_AV1_HIGHBITDEPTH
  highbd_set_var_fns(cpi);
#endif

  // Init sequence level coding tools
  // This should not be called after the first key frame.
  if (!cpi->seq_params_locked) {
    seq_params->operating_points_cnt_minus_1 =
        (cm->number_spatial_layers > 1 || cm->number_temporal_layers > 1)
            ? cm->number_spatial_layers * cm->number_temporal_layers - 1
            : 0;
    init_seq_coding_tools(&cm->seq_params, cm, oxcf, cpi->use_svc);
  }

  if (cpi->use_svc)
    av1_update_layer_context_change_config(cpi, oxcf->target_bandwidth);
}

static INLINE void setup_tpl_buffers(AV1_COMMON *const cm,
                                     TplParams *const tpl_data) {
  CommonModeInfoParams *const mi_params = &cm->mi_params;
  set_tpl_stats_block_size(cm->width, cm->height,
                           &tpl_data->tpl_stats_block_mis_log2);
  const uint8_t block_mis_log2 = tpl_data->tpl_stats_block_mis_log2;

  for (int frame = 0; frame < MAX_LENGTH_TPL_FRAME_STATS; ++frame) {
    const int mi_cols =
        ALIGN_POWER_OF_TWO(mi_params->mi_cols, MAX_MIB_SIZE_LOG2);
    const int mi_rows =
        ALIGN_POWER_OF_TWO(mi_params->mi_rows, MAX_MIB_SIZE_LOG2);

    tpl_data->tpl_stats_buffer[frame].is_valid = 0;
    tpl_data->tpl_stats_buffer[frame].width = mi_cols >> block_mis_log2;
    tpl_data->tpl_stats_buffer[frame].height = mi_rows >> block_mis_log2;
    tpl_data->tpl_stats_buffer[frame].stride =
        tpl_data->tpl_stats_buffer[frame].width;
    tpl_data->tpl_stats_buffer[frame].mi_rows = mi_params->mi_rows;
    tpl_data->tpl_stats_buffer[frame].mi_cols = mi_params->mi_cols;
  }

  for (int frame = 0; frame < MAX_LAG_BUFFERS; ++frame) {
    CHECK_MEM_ERROR(
        cm, tpl_data->tpl_stats_pool[frame],
        aom_calloc(tpl_data->tpl_stats_buffer[frame].width *
                       tpl_data->tpl_stats_buffer[frame].height,
                   sizeof(*tpl_data->tpl_stats_buffer[frame].tpl_stats_ptr)));
    if (aom_alloc_frame_buffer(
            &tpl_data->tpl_rec_pool[frame], cm->width, cm->height,
            cm->seq_params.subsampling_x, cm->seq_params.subsampling_y,
            cm->seq_params.use_highbitdepth, AOM_ENC_NO_SCALE_BORDER,
            cm->features.byte_alignment))
      aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                         "Failed to allocate frame buffer");
  }

  tpl_data->tpl_frame = &tpl_data->tpl_stats_buffer[REF_FRAMES + 1];
}

static INLINE void init_frame_info(FRAME_INFO *frame_info,
                                   const AV1_COMMON *const cm) {
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const SequenceHeader *const seq_params = &cm->seq_params;
  frame_info->frame_width = cm->width;
  frame_info->frame_height = cm->height;
  frame_info->mi_cols = mi_params->mi_cols;
  frame_info->mi_rows = mi_params->mi_rows;
  frame_info->mb_cols = mi_params->mb_cols;
  frame_info->mb_rows = mi_params->mb_rows;
  frame_info->num_mbs = mi_params->MBs;
  frame_info->bit_depth = seq_params->bit_depth;
  frame_info->subsampling_x = seq_params->subsampling_x;
  frame_info->subsampling_y = seq_params->subsampling_y;
}

AV1_COMP *av1_create_compressor(AV1EncoderConfig *oxcf, BufferPool *const pool,
                                FIRSTPASS_STATS *frame_stats_buf,
                                COMPRESSOR_STAGE stage, int num_lap_buffers,
                                int lap_lag_in_frames,
                                STATS_BUFFER_CTX *stats_buf_context) {
  AV1_COMP *volatile const cpi = aom_memalign(32, sizeof(AV1_COMP));
  AV1_COMMON *volatile const cm = cpi != NULL ? &cpi->common : NULL;

  if (!cm) return NULL;

  av1_zero(*cpi);

  // The jmp_buf is valid only for the duration of the function that calls
  // setjmp(). Therefore, this function must reset the 'setjmp' field to 0
  // before it returns.
  if (setjmp(cm->error.jmp)) {
    cm->error.setjmp = 0;
    av1_remove_compressor(cpi);
    return 0;
  }

  cm->error.setjmp = 1;
  cpi->lap_enabled = num_lap_buffers > 0;
  cpi->compressor_stage = stage;

  CommonModeInfoParams *const mi_params = &cm->mi_params;
  mi_params->free_mi = enc_free_mi;
  mi_params->setup_mi = enc_setup_mi;
  mi_params->set_mb_mi = (oxcf->pass == 1 || cpi->compressor_stage == LAP_STAGE)
                             ? stat_stage_set_mb_mi
                             : enc_set_mb_mi;

  mi_params->mi_alloc_bsize = BLOCK_4X4;

  CHECK_MEM_ERROR(cm, cm->fc,
                  (FRAME_CONTEXT *)aom_memalign(32, sizeof(*cm->fc)));
  CHECK_MEM_ERROR(
      cm, cm->default_frame_context,
      (FRAME_CONTEXT *)aom_memalign(32, sizeof(*cm->default_frame_context)));
  memset(cm->fc, 0, sizeof(*cm->fc));
  memset(cm->default_frame_context, 0, sizeof(*cm->default_frame_context));

  cpi->common.buffer_pool = pool;

  init_config(cpi, oxcf);
  if (cpi->compressor_stage == LAP_STAGE) {
    cpi->oxcf.lag_in_frames = lap_lag_in_frames;
  }

  av1_rc_init(&cpi->oxcf, oxcf->pass, &cpi->rc);

  cpi->rc.enable_scenecut_detection = 1;
  if (cpi->lap_enabled &&
      (num_lap_buffers < (MAX_GF_LENGTH_LAP + SCENE_CUT_KEY_TEST_INTERVAL + 1)))
    cpi->rc.enable_scenecut_detection = 0;
  init_frame_info(&cpi->frame_info, cm);

  cm->current_frame.frame_number = 0;
  cm->current_frame_id = -1;
  cpi->seq_params_locked = 0;
  cpi->partition_search_skippable_frame = 0;
  cpi->tile_data = NULL;
  cpi->last_show_frame_buf = NULL;
  realloc_segmentation_maps(cpi);

  cpi->refresh_alt_ref_frame = 0;

  cpi->b_calculate_psnr = CONFIG_INTERNAL_STATS;
#if CONFIG_INTERNAL_STATS
  cpi->b_calculate_blockiness = 1;
  cpi->b_calculate_consistency = 1;
  cpi->total_inconsistency = 0;
  cpi->psnr.worst = 100.0;
  cpi->worst_ssim = 100.0;

  cpi->count = 0;
  cpi->bytes = 0;
#if CONFIG_SPEED_STATS
  cpi->tx_search_count = 0;
#endif  // CONFIG_SPEED_STATS

  if (cpi->b_calculate_psnr) {
    cpi->total_sq_error = 0;
    cpi->total_samples = 0;
    cpi->tot_recode_hits = 0;
    cpi->summed_quality = 0;
    cpi->summed_weights = 0;
  }

  cpi->fastssim.worst = 100.0;
  cpi->psnrhvs.worst = 100.0;

  if (cpi->b_calculate_blockiness) {
    cpi->total_blockiness = 0;
    cpi->worst_blockiness = 0.0;
  }

  if (cpi->b_calculate_consistency) {
    CHECK_MEM_ERROR(
        cm, cpi->ssim_vars,
        aom_malloc(sizeof(*cpi->ssim_vars) * 4 * cpi->common.mi_params.mi_rows *
                   cpi->common.mi_params.mi_cols));
    cpi->worst_consistency = 100.0;
  }
#endif
#if CONFIG_ENTROPY_STATS
  av1_zero(aggregate_fc);
#endif  // CONFIG_ENTROPY_STATS

  cpi->time_stamps.first_ever = INT64_MAX;

#ifdef OUTPUT_YUV_SKINMAP
  yuv_skinmap_file = fopen("skinmap.yuv", "ab");
#endif
#ifdef OUTPUT_YUV_REC
  yuv_rec_file = fopen("rec.yuv", "wb");
#endif

  assert(MAX_LAP_BUFFERS >= MAX_LAG_BUFFERS);
  int size = get_stats_buf_size(num_lap_buffers, MAX_LAG_BUFFERS);
  for (int i = 0; i < size; i++)
    cpi->twopass.frame_stats_arr[i] = &frame_stats_buf[i];

  cpi->twopass.stats_buf_ctx = stats_buf_context;
  cpi->twopass.stats_in = cpi->twopass.stats_buf_ctx->stats_in_start;

#if !CONFIG_REALTIME_ONLY
  if (is_stat_consumption_stage(cpi)) {
    const size_t packet_sz = sizeof(FIRSTPASS_STATS);
    const int packets = (int)(oxcf->two_pass_stats_in.sz / packet_sz);

    if (!cpi->lap_enabled) {
      /*Re-initialize to stats buffer, populated by application in the case of
       * two pass*/
      cpi->twopass.stats_buf_ctx->stats_in_start = oxcf->two_pass_stats_in.buf;
      cpi->twopass.stats_in = cpi->twopass.stats_buf_ctx->stats_in_start;
      cpi->twopass.stats_buf_ctx->stats_in_end =
          &cpi->twopass.stats_buf_ctx->stats_in_start[packets - 1];

      av1_init_second_pass(cpi);
    } else {
      av1_init_single_pass_lap(cpi);
    }
  }
#endif

  int sb_mi_size = av1_get_sb_mi_size(cm);

  CHECK_MEM_ERROR(
      cm, cpi->td.mb.above_pred_buf,
      (uint8_t *)aom_memalign(16, MAX_MB_PLANE * MAX_SB_SQUARE *
                                      sizeof(*cpi->td.mb.above_pred_buf)));
  CHECK_MEM_ERROR(
      cm, cpi->td.mb.left_pred_buf,
      (uint8_t *)aom_memalign(16, MAX_MB_PLANE * MAX_SB_SQUARE *
                                      sizeof(*cpi->td.mb.left_pred_buf)));

  CHECK_MEM_ERROR(cm, cpi->td.mb.wsrc_buf,
                  (int32_t *)aom_memalign(
                      16, MAX_SB_SQUARE * sizeof(*cpi->td.mb.wsrc_buf)));

  CHECK_MEM_ERROR(
      cm, cpi->td.mb.inter_modes_info,
      (InterModesInfo *)aom_malloc(sizeof(*cpi->td.mb.inter_modes_info)));

  for (int x = 0; x < 2; x++)
    for (int y = 0; y < 2; y++)
      CHECK_MEM_ERROR(
          cm, cpi->td.mb.intrabc_hash_info.hash_value_buffer[x][y],
          (uint32_t *)aom_malloc(
              AOM_BUFFER_SIZE_FOR_BLOCK_HASH *
              sizeof(*cpi->td.mb.intrabc_hash_info.hash_value_buffer[0][0])));

  cpi->td.mb.intrabc_hash_info.g_crc_initialized = 0;

  CHECK_MEM_ERROR(cm, cpi->td.mb.mask_buf,
                  (int32_t *)aom_memalign(
                      16, MAX_SB_SQUARE * sizeof(*cpi->td.mb.mask_buf)));

  CHECK_MEM_ERROR(cm, cpi->td.mb.mbmi_ext,
                  aom_calloc(sb_mi_size, sizeof(*cpi->td.mb.mbmi_ext)));

  av1_set_speed_features_framesize_independent(cpi, oxcf->speed);
  av1_set_speed_features_framesize_dependent(cpi, oxcf->speed);

  {
    const int bsize = BLOCK_16X16;
    const int w = mi_size_wide[bsize];
    const int h = mi_size_high[bsize];
    const int num_cols = (mi_params->mi_cols + w - 1) / w;
    const int num_rows = (mi_params->mi_rows + h - 1) / h;
    CHECK_MEM_ERROR(cm, cpi->tpl_rdmult_scaling_factors,
                    aom_calloc(num_rows * num_cols,
                               sizeof(*cpi->tpl_rdmult_scaling_factors)));
    CHECK_MEM_ERROR(cm, cpi->tpl_sb_rdmult_scaling_factors,
                    aom_calloc(num_rows * num_cols,
                               sizeof(*cpi->tpl_sb_rdmult_scaling_factors)));
  }

  {
    const int bsize = BLOCK_16X16;
    const int w = mi_size_wide[bsize];
    const int h = mi_size_high[bsize];
    const int num_cols = (mi_params->mi_cols + w - 1) / w;
    const int num_rows = (mi_params->mi_rows + h - 1) / h;
    CHECK_MEM_ERROR(cm, cpi->ssim_rdmult_scaling_factors,
                    aom_calloc(num_rows * num_cols,
                               sizeof(*cpi->ssim_rdmult_scaling_factors)));
  }

#if CONFIG_TUNE_VMAF
  {
    const int bsize = BLOCK_64X64;
    const int w = mi_size_wide[bsize];
    const int h = mi_size_high[bsize];
    const int num_cols = (mi_params->mi_cols + w - 1) / w;
    const int num_rows = (mi_params->mi_rows + h - 1) / h;
    CHECK_MEM_ERROR(cm, cpi->vmaf_rdmult_scaling_factors,
                    aom_calloc(num_rows * num_cols,
                               sizeof(*cpi->vmaf_rdmult_scaling_factors)));
    cpi->last_frame_unsharp_amount = 0.0;
  }
#endif

  if (!is_stat_generation_stage(cpi)) {
    setup_tpl_buffers(cm, &cpi->tpl_data);
  }

#if CONFIG_COLLECT_PARTITION_STATS == 2
  av1_zero(cpi->partition_stats);
#endif

#define BFP(BT, SDF, SDAF, VF, SVF, SVAF, SDX4DF, JSDAF, JSVAF) \
  cpi->fn_ptr[BT].sdf = SDF;                                    \
  cpi->fn_ptr[BT].sdaf = SDAF;                                  \
  cpi->fn_ptr[BT].vf = VF;                                      \
  cpi->fn_ptr[BT].svf = SVF;                                    \
  cpi->fn_ptr[BT].svaf = SVAF;                                  \
  cpi->fn_ptr[BT].sdx4df = SDX4DF;                              \
  cpi->fn_ptr[BT].jsdaf = JSDAF;                                \
  cpi->fn_ptr[BT].jsvaf = JSVAF;

  BFP(BLOCK_4X16, aom_sad4x16, aom_sad4x16_avg, aom_variance4x16,
      aom_sub_pixel_variance4x16, aom_sub_pixel_avg_variance4x16,
      aom_sad4x16x4d, aom_dist_wtd_sad4x16_avg,
      aom_dist_wtd_sub_pixel_avg_variance4x16)

  BFP(BLOCK_16X4, aom_sad16x4, aom_sad16x4_avg, aom_variance16x4,
      aom_sub_pixel_variance16x4, aom_sub_pixel_avg_variance16x4,
      aom_sad16x4x4d, aom_dist_wtd_sad16x4_avg,
      aom_dist_wtd_sub_pixel_avg_variance16x4)

  BFP(BLOCK_8X32, aom_sad8x32, aom_sad8x32_avg, aom_variance8x32,
      aom_sub_pixel_variance8x32, aom_sub_pixel_avg_variance8x32,
      aom_sad8x32x4d, aom_dist_wtd_sad8x32_avg,
      aom_dist_wtd_sub_pixel_avg_variance8x32)

  BFP(BLOCK_32X8, aom_sad32x8, aom_sad32x8_avg, aom_variance32x8,
      aom_sub_pixel_variance32x8, aom_sub_pixel_avg_variance32x8,
      aom_sad32x8x4d, aom_dist_wtd_sad32x8_avg,
      aom_dist_wtd_sub_pixel_avg_variance32x8)

  BFP(BLOCK_16X64, aom_sad16x64, aom_sad16x64_avg, aom_variance16x64,
      aom_sub_pixel_variance16x64, aom_sub_pixel_avg_variance16x64,
      aom_sad16x64x4d, aom_dist_wtd_sad16x64_avg,
      aom_dist_wtd_sub_pixel_avg_variance16x64)

  BFP(BLOCK_64X16, aom_sad64x16, aom_sad64x16_avg, aom_variance64x16,
      aom_sub_pixel_variance64x16, aom_sub_pixel_avg_variance64x16,
      aom_sad64x16x4d, aom_dist_wtd_sad64x16_avg,
      aom_dist_wtd_sub_pixel_avg_variance64x16)

  BFP(BLOCK_128X128, aom_sad128x128, aom_sad128x128_avg, aom_variance128x128,
      aom_sub_pixel_variance128x128, aom_sub_pixel_avg_variance128x128,
      aom_sad128x128x4d, aom_dist_wtd_sad128x128_avg,
      aom_dist_wtd_sub_pixel_avg_variance128x128)

  BFP(BLOCK_128X64, aom_sad128x64, aom_sad128x64_avg, aom_variance128x64,
      aom_sub_pixel_variance128x64, aom_sub_pixel_avg_variance128x64,
      aom_sad128x64x4d, aom_dist_wtd_sad128x64_avg,
      aom_dist_wtd_sub_pixel_avg_variance128x64)

  BFP(BLOCK_64X128, aom_sad64x128, aom_sad64x128_avg, aom_variance64x128,
      aom_sub_pixel_variance64x128, aom_sub_pixel_avg_variance64x128,
      aom_sad64x128x4d, aom_dist_wtd_sad64x128_avg,
      aom_dist_wtd_sub_pixel_avg_variance64x128)

  BFP(BLOCK_32X16, aom_sad32x16, aom_sad32x16_avg, aom_variance32x16,
      aom_sub_pixel_variance32x16, aom_sub_pixel_avg_variance32x16,
      aom_sad32x16x4d, aom_dist_wtd_sad32x16_avg,
      aom_dist_wtd_sub_pixel_avg_variance32x16)

  BFP(BLOCK_16X32, aom_sad16x32, aom_sad16x32_avg, aom_variance16x32,
      aom_sub_pixel_variance16x32, aom_sub_pixel_avg_variance16x32,
      aom_sad16x32x4d, aom_dist_wtd_sad16x32_avg,
      aom_dist_wtd_sub_pixel_avg_variance16x32)

  BFP(BLOCK_64X32, aom_sad64x32, aom_sad64x32_avg, aom_variance64x32,
      aom_sub_pixel_variance64x32, aom_sub_pixel_avg_variance64x32,
      aom_sad64x32x4d, aom_dist_wtd_sad64x32_avg,
      aom_dist_wtd_sub_pixel_avg_variance64x32)

  BFP(BLOCK_32X64, aom_sad32x64, aom_sad32x64_avg, aom_variance32x64,
      aom_sub_pixel_variance32x64, aom_sub_pixel_avg_variance32x64,
      aom_sad32x64x4d, aom_dist_wtd_sad32x64_avg,
      aom_dist_wtd_sub_pixel_avg_variance32x64)

  BFP(BLOCK_32X32, aom_sad32x32, aom_sad32x32_avg, aom_variance32x32,
      aom_sub_pixel_variance32x32, aom_sub_pixel_avg_variance32x32,
      aom_sad32x32x4d, aom_dist_wtd_sad32x32_avg,
      aom_dist_wtd_sub_pixel_avg_variance32x32)

  BFP(BLOCK_64X64, aom_sad64x64, aom_sad64x64_avg, aom_variance64x64,
      aom_sub_pixel_variance64x64, aom_sub_pixel_avg_variance64x64,
      aom_sad64x64x4d, aom_dist_wtd_sad64x64_avg,
      aom_dist_wtd_sub_pixel_avg_variance64x64)

  BFP(BLOCK_16X16, aom_sad16x16, aom_sad16x16_avg, aom_variance16x16,
      aom_sub_pixel_variance16x16, aom_sub_pixel_avg_variance16x16,
      aom_sad16x16x4d, aom_dist_wtd_sad16x16_avg,
      aom_dist_wtd_sub_pixel_avg_variance16x16)

  BFP(BLOCK_16X8, aom_sad16x8, aom_sad16x8_avg, aom_variance16x8,
      aom_sub_pixel_variance16x8, aom_sub_pixel_avg_variance16x8,
      aom_sad16x8x4d, aom_dist_wtd_sad16x8_avg,
      aom_dist_wtd_sub_pixel_avg_variance16x8)

  BFP(BLOCK_8X16, aom_sad8x16, aom_sad8x16_avg, aom_variance8x16,
      aom_sub_pixel_variance8x16, aom_sub_pixel_avg_variance8x16,
      aom_sad8x16x4d, aom_dist_wtd_sad8x16_avg,
      aom_dist_wtd_sub_pixel_avg_variance8x16)

  BFP(BLOCK_8X8, aom_sad8x8, aom_sad8x8_avg, aom_variance8x8,
      aom_sub_pixel_variance8x8, aom_sub_pixel_avg_variance8x8, aom_sad8x8x4d,
      aom_dist_wtd_sad8x8_avg, aom_dist_wtd_sub_pixel_avg_variance8x8)

  BFP(BLOCK_8X4, aom_sad8x4, aom_sad8x4_avg, aom_variance8x4,
      aom_sub_pixel_variance8x4, aom_sub_pixel_avg_variance8x4, aom_sad8x4x4d,
      aom_dist_wtd_sad8x4_avg, aom_dist_wtd_sub_pixel_avg_variance8x4)

  BFP(BLOCK_4X8, aom_sad4x8, aom_sad4x8_avg, aom_variance4x8,
      aom_sub_pixel_variance4x8, aom_sub_pixel_avg_variance4x8, aom_sad4x8x4d,
      aom_dist_wtd_sad4x8_avg, aom_dist_wtd_sub_pixel_avg_variance4x8)

  BFP(BLOCK_4X4, aom_sad4x4, aom_sad4x4_avg, aom_variance4x4,
      aom_sub_pixel_variance4x4, aom_sub_pixel_avg_variance4x4, aom_sad4x4x4d,
      aom_dist_wtd_sad4x4_avg, aom_dist_wtd_sub_pixel_avg_variance4x4)

#define OBFP(BT, OSDF, OVF, OSVF) \
  cpi->fn_ptr[BT].osdf = OSDF;    \
  cpi->fn_ptr[BT].ovf = OVF;      \
  cpi->fn_ptr[BT].osvf = OSVF;

  OBFP(BLOCK_128X128, aom_obmc_sad128x128, aom_obmc_variance128x128,
       aom_obmc_sub_pixel_variance128x128)
  OBFP(BLOCK_128X64, aom_obmc_sad128x64, aom_obmc_variance128x64,
       aom_obmc_sub_pixel_variance128x64)
  OBFP(BLOCK_64X128, aom_obmc_sad64x128, aom_obmc_variance64x128,
       aom_obmc_sub_pixel_variance64x128)
  OBFP(BLOCK_64X64, aom_obmc_sad64x64, aom_obmc_variance64x64,
       aom_obmc_sub_pixel_variance64x64)
  OBFP(BLOCK_64X32, aom_obmc_sad64x32, aom_obmc_variance64x32,
       aom_obmc_sub_pixel_variance64x32)
  OBFP(BLOCK_32X64, aom_obmc_sad32x64, aom_obmc_variance32x64,
       aom_obmc_sub_pixel_variance32x64)
  OBFP(BLOCK_32X32, aom_obmc_sad32x32, aom_obmc_variance32x32,
       aom_obmc_sub_pixel_variance32x32)
  OBFP(BLOCK_32X16, aom_obmc_sad32x16, aom_obmc_variance32x16,
       aom_obmc_sub_pixel_variance32x16)
  OBFP(BLOCK_16X32, aom_obmc_sad16x32, aom_obmc_variance16x32,
       aom_obmc_sub_pixel_variance16x32)
  OBFP(BLOCK_16X16, aom_obmc_sad16x16, aom_obmc_variance16x16,
       aom_obmc_sub_pixel_variance16x16)
  OBFP(BLOCK_16X8, aom_obmc_sad16x8, aom_obmc_variance16x8,
       aom_obmc_sub_pixel_variance16x8)
  OBFP(BLOCK_8X16, aom_obmc_sad8x16, aom_obmc_variance8x16,
       aom_obmc_sub_pixel_variance8x16)
  OBFP(BLOCK_8X8, aom_obmc_sad8x8, aom_obmc_variance8x8,
       aom_obmc_sub_pixel_variance8x8)
  OBFP(BLOCK_4X8, aom_obmc_sad4x8, aom_obmc_variance4x8,
       aom_obmc_sub_pixel_variance4x8)
  OBFP(BLOCK_8X4, aom_obmc_sad8x4, aom_obmc_variance8x4,
       aom_obmc_sub_pixel_variance8x4)
  OBFP(BLOCK_4X4, aom_obmc_sad4x4, aom_obmc_variance4x4,
       aom_obmc_sub_pixel_variance4x4)
  OBFP(BLOCK_4X16, aom_obmc_sad4x16, aom_obmc_variance4x16,
       aom_obmc_sub_pixel_variance4x16)
  OBFP(BLOCK_16X4, aom_obmc_sad16x4, aom_obmc_variance16x4,
       aom_obmc_sub_pixel_variance16x4)
  OBFP(BLOCK_8X32, aom_obmc_sad8x32, aom_obmc_variance8x32,
       aom_obmc_sub_pixel_variance8x32)
  OBFP(BLOCK_32X8, aom_obmc_sad32x8, aom_obmc_variance32x8,
       aom_obmc_sub_pixel_variance32x8)
  OBFP(BLOCK_16X64, aom_obmc_sad16x64, aom_obmc_variance16x64,
       aom_obmc_sub_pixel_variance16x64)
  OBFP(BLOCK_64X16, aom_obmc_sad64x16, aom_obmc_variance64x16,
       aom_obmc_sub_pixel_variance64x16)

#define MBFP(BT, MCSDF, MCSVF)  \
  cpi->fn_ptr[BT].msdf = MCSDF; \
  cpi->fn_ptr[BT].msvf = MCSVF;

  MBFP(BLOCK_128X128, aom_masked_sad128x128,
       aom_masked_sub_pixel_variance128x128)
  MBFP(BLOCK_128X64, aom_masked_sad128x64, aom_masked_sub_pixel_variance128x64)
  MBFP(BLOCK_64X128, aom_masked_sad64x128, aom_masked_sub_pixel_variance64x128)
  MBFP(BLOCK_64X64, aom_masked_sad64x64, aom_masked_sub_pixel_variance64x64)
  MBFP(BLOCK_64X32, aom_masked_sad64x32, aom_masked_sub_pixel_variance64x32)
  MBFP(BLOCK_32X64, aom_masked_sad32x64, aom_masked_sub_pixel_variance32x64)
  MBFP(BLOCK_32X32, aom_masked_sad32x32, aom_masked_sub_pixel_variance32x32)
  MBFP(BLOCK_32X16, aom_masked_sad32x16, aom_masked_sub_pixel_variance32x16)
  MBFP(BLOCK_16X32, aom_masked_sad16x32, aom_masked_sub_pixel_variance16x32)
  MBFP(BLOCK_16X16, aom_masked_sad16x16, aom_masked_sub_pixel_variance16x16)
  MBFP(BLOCK_16X8, aom_masked_sad16x8, aom_masked_sub_pixel_variance16x8)
  MBFP(BLOCK_8X16, aom_masked_sad8x16, aom_masked_sub_pixel_variance8x16)
  MBFP(BLOCK_8X8, aom_masked_sad8x8, aom_masked_sub_pixel_variance8x8)
  MBFP(BLOCK_4X8, aom_masked_sad4x8, aom_masked_sub_pixel_variance4x8)
  MBFP(BLOCK_8X4, aom_masked_sad8x4, aom_masked_sub_pixel_variance8x4)
  MBFP(BLOCK_4X4, aom_masked_sad4x4, aom_masked_sub_pixel_variance4x4)

  MBFP(BLOCK_4X16, aom_masked_sad4x16, aom_masked_sub_pixel_variance4x16)

  MBFP(BLOCK_16X4, aom_masked_sad16x4, aom_masked_sub_pixel_variance16x4)

  MBFP(BLOCK_8X32, aom_masked_sad8x32, aom_masked_sub_pixel_variance8x32)

  MBFP(BLOCK_32X8, aom_masked_sad32x8, aom_masked_sub_pixel_variance32x8)

  MBFP(BLOCK_16X64, aom_masked_sad16x64, aom_masked_sub_pixel_variance16x64)

  MBFP(BLOCK_64X16, aom_masked_sad64x16, aom_masked_sub_pixel_variance64x16)

#if CONFIG_AV1_HIGHBITDEPTH
  highbd_set_var_fns(cpi);
#endif

  /* av1_init_quantizer() is first called here. Add check in
   * av1_frame_init_quantizer() so that av1_init_quantizer is only
   * called later when needed. This will avoid unnecessary calls of
   * av1_init_quantizer() for every frame.
   */
  av1_init_quantizer(&cpi->enc_quant_dequant_params, &cm->quant_params,
                     cm->seq_params.bit_depth);
  av1_qm_init(&cm->quant_params, av1_num_planes(cm));

  av1_loop_filter_init(cm);
  cm->superres_scale_denominator = SCALE_NUMERATOR;
  cm->superres_upscaled_width = oxcf->width;
  cm->superres_upscaled_height = oxcf->height;
  av1_loop_restoration_precal();

  cm->error.setjmp = 0;

  return cpi;
}

#if CONFIG_INTERNAL_STATS
#define SNPRINT(H, T) snprintf((H) + strlen(H), sizeof(H) - strlen(H), (T))

#define SNPRINT2(H, T, V) \
  snprintf((H) + strlen(H), sizeof(H) - strlen(H), (T), (V))
#endif  // CONFIG_INTERNAL_STATS

void av1_remove_compressor(AV1_COMP *cpi) {
  AV1_COMMON *cm;
  TplParams *const tpl_data = &cpi->tpl_data;
  int t;

  if (!cpi) return;

  cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);

  if (cm->current_frame.frame_number > 0) {
#if CONFIG_ENTROPY_STATS
    if (!is_stat_generation_stage(cpi)) {
      fprintf(stderr, "Writing counts.stt\n");
      FILE *f = fopen("counts.stt", "wb");
      fwrite(&aggregate_fc, sizeof(aggregate_fc), 1, f);
      fclose(f);
    }
#endif  // CONFIG_ENTROPY_STATS
#if CONFIG_INTERNAL_STATS
    aom_clear_system_state();

    if (!is_stat_generation_stage(cpi)) {
      char headings[512] = { 0 };
      char results[512] = { 0 };
      FILE *f = fopen("opsnr.stt", "a");
      double time_encoded =
          (cpi->time_stamps.prev_end_seen - cpi->time_stamps.first_ever) /
          10000000.000;
      double total_encode_time =
          (cpi->time_receive_data + cpi->time_compress_data) / 1000.000;
      const double dr =
          (double)cpi->bytes * (double)8 / (double)1000 / time_encoded;
      const double peak = (double)((1 << cpi->oxcf.input_bit_depth) - 1);
      const double target_rate = (double)cpi->oxcf.target_bandwidth / 1000;
      const double rate_err = ((100.0 * (dr - target_rate)) / target_rate);

      if (cpi->b_calculate_psnr) {
        const double total_psnr = aom_sse_to_psnr(
            (double)cpi->total_samples, peak, (double)cpi->total_sq_error);
        const double total_ssim =
            100 * pow(cpi->summed_quality / cpi->summed_weights, 8.0);
        snprintf(headings, sizeof(headings),
                 "Bitrate\tAVGPsnr\tGLBPsnr\tAVPsnrP\tGLPsnrP\t"
                 "AOMSSIM\tVPSSIMP\tFASTSIM\tPSNRHVS\t"
                 "WstPsnr\tWstSsim\tWstFast\tWstHVS\t"
                 "AVPsrnY\tAPsnrCb\tAPsnrCr");
        snprintf(results, sizeof(results),
                 "%7.2f\t%7.3f\t%7.3f\t%7.3f\t%7.3f\t"
                 "%7.3f\t%7.3f\t%7.3f\t%7.3f\t"
                 "%7.3f\t%7.3f\t%7.3f\t%7.3f\t"
                 "%7.3f\t%7.3f\t%7.3f",
                 dr, cpi->psnr.stat[STAT_ALL] / cpi->count, total_psnr,
                 cpi->psnr.stat[STAT_ALL] / cpi->count, total_psnr, total_ssim,
                 total_ssim, cpi->fastssim.stat[STAT_ALL] / cpi->count,
                 cpi->psnrhvs.stat[STAT_ALL] / cpi->count, cpi->psnr.worst,
                 cpi->worst_ssim, cpi->fastssim.worst, cpi->psnrhvs.worst,
                 cpi->psnr.stat[STAT_Y] / cpi->count,
                 cpi->psnr.stat[STAT_U] / cpi->count,
                 cpi->psnr.stat[STAT_V] / cpi->count);

        if (cpi->b_calculate_blockiness) {
          SNPRINT(headings, "\t  Block\tWstBlck");
          SNPRINT2(results, "\t%7.3f", cpi->total_blockiness / cpi->count);
          SNPRINT2(results, "\t%7.3f", cpi->worst_blockiness);
        }

        if (cpi->b_calculate_consistency) {
          double consistency =
              aom_sse_to_psnr((double)cpi->total_samples, peak,
                              (double)cpi->total_inconsistency);

          SNPRINT(headings, "\tConsist\tWstCons");
          SNPRINT2(results, "\t%7.3f", consistency);
          SNPRINT2(results, "\t%7.3f", cpi->worst_consistency);
        }

        SNPRINT(headings, "\t    Time\tRcErr\tAbsErr");
        SNPRINT2(results, "\t%8.0f", total_encode_time);
        SNPRINT2(results, "\t%7.2f", rate_err);
        SNPRINT2(results, "\t%7.2f", fabs(rate_err));

        fprintf(f, "%s\tAPsnr611\n", headings);
        fprintf(f, "%s\t%7.3f\n", results,
                (6 * cpi->psnr.stat[STAT_Y] + cpi->psnr.stat[STAT_U] +
                 cpi->psnr.stat[STAT_V]) /
                    (cpi->count * 8));
      }

      fclose(f);
    }
#endif  // CONFIG_INTERNAL_STATS
#if CONFIG_SPEED_STATS
    if (!is_stat_generation_stage(cpi)) {
      fprintf(stdout, "tx_search_count = %d\n", cpi->tx_search_count);
    }
#endif  // CONFIG_SPEED_STATS

#if CONFIG_COLLECT_PARTITION_STATS == 2
    if (!is_stat_generation_stage(cpi)) {
      av1_print_partition_stats(&cpi->partition_stats);
    }
#endif
  }

  for (int frame = 0; frame < MAX_LAG_BUFFERS; ++frame) {
    aom_free(tpl_data->tpl_stats_pool[frame]);
    aom_free_frame_buffer(&tpl_data->tpl_rec_pool[frame]);
  }

  for (t = cpi->num_workers - 1; t >= 0; --t) {
    AVxWorker *const worker = &cpi->workers[t];
    EncWorkerData *const thread_data = &cpi->tile_thr_data[t];

    // Deallocate allocated threads.
    aom_get_worker_interface()->end(worker);

    // Deallocate allocated thread data.
    aom_free(thread_data->td->tctx);
    if (t > 0) {
      aom_free(thread_data->td->palette_buffer);
      aom_free(thread_data->td->tmp_conv_dst);
      av1_release_compound_type_rd_buffers(&thread_data->td->comp_rd_buffer);
      for (int j = 0; j < 2; ++j) {
        aom_free(thread_data->td->tmp_obmc_bufs[j]);
      }
      aom_free(thread_data->td->above_pred_buf);
      aom_free(thread_data->td->left_pred_buf);
      aom_free(thread_data->td->wsrc_buf);
      aom_free(thread_data->td->vt64x64);

      aom_free(thread_data->td->inter_modes_info);
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 2; y++) {
          aom_free(thread_data->td->hash_value_buffer[x][y]);
          thread_data->td->hash_value_buffer[x][y] = NULL;
        }
      }
      aom_free(thread_data->td->mask_buf);
      aom_free(thread_data->td->counts);
      av1_free_pc_tree(cpi, thread_data->td, num_planes,
                       cm->seq_params.sb_size);
      aom_free(thread_data->td->mbmi_ext);
      aom_free(thread_data->td);
    }
  }
#if CONFIG_MULTITHREAD
  if (cpi->row_mt_mutex_ != NULL) {
    pthread_mutex_destroy(cpi->row_mt_mutex_);
    aom_free(cpi->row_mt_mutex_);
  }
#endif
  av1_row_mt_mem_dealloc(cpi);
  aom_free(cpi->tile_thr_data);
  aom_free(cpi->workers);

  if (cpi->num_workers > 1) {
    av1_loop_filter_dealloc(&cpi->lf_row_sync);
    av1_loop_restoration_dealloc(&cpi->lr_row_sync, cpi->num_workers);
  }

  dealloc_compressor_data(cpi);

#if CONFIG_INTERNAL_STATS
  aom_free(cpi->ssim_vars);
  cpi->ssim_vars = NULL;
#endif  // CONFIG_INTERNAL_STATS

  av1_remove_common(cm);
#if CONFIG_HTB_TRELLIS
  if (cpi->sf.use_hash_based_trellis) hbt_destroy();
#endif  // CONFIG_HTB_TRELLIS
  av1_free_ref_frame_buffers(cm->buffer_pool);

  aom_free(cpi);

#ifdef OUTPUT_YUV_SKINMAP
  fclose(yuv_skinmap_file);
#endif
#ifdef OUTPUT_YUV_REC
  fclose(yuv_rec_file);
#endif
}

static void generate_psnr_packet(AV1_COMP *cpi) {
  struct aom_codec_cx_pkt pkt;
  int i;
  PSNR_STATS psnr;
#if CONFIG_AV1_HIGHBITDEPTH
  const uint32_t in_bit_depth = cpi->oxcf.input_bit_depth;
  const uint32_t bit_depth = cpi->td.mb.e_mbd.bd;
  aom_calc_highbd_psnr(cpi->source, &cpi->common.cur_frame->buf, &psnr,
                       bit_depth, in_bit_depth);
#else
  aom_calc_psnr(cpi->source, &cpi->common.cur_frame->buf, &psnr);
#endif

  for (i = 0; i < 4; ++i) {
    pkt.data.psnr.samples[i] = psnr.samples[i];
    pkt.data.psnr.sse[i] = psnr.sse[i];
    pkt.data.psnr.psnr[i] = psnr.psnr[i];
  }
  pkt.kind = AOM_CODEC_PSNR_PKT;
  aom_codec_pkt_list_add(cpi->output_pkt_list, &pkt);
}

int av1_use_as_reference(int *ext_ref_frame_flags, int ref_frame_flags) {
  if (ref_frame_flags > ((1 << INTER_REFS_PER_FRAME) - 1)) return -1;

  *ext_ref_frame_flags = ref_frame_flags;
  return 0;
}

int av1_copy_reference_enc(AV1_COMP *cpi, int idx, YV12_BUFFER_CONFIG *sd) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  YV12_BUFFER_CONFIG *cfg = get_ref_frame(cm, idx);
  if (cfg) {
    aom_yv12_copy_frame(cfg, sd, num_planes);
    return 0;
  } else {
    return -1;
  }
}

int av1_set_reference_enc(AV1_COMP *cpi, int idx, YV12_BUFFER_CONFIG *sd) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  YV12_BUFFER_CONFIG *cfg = get_ref_frame(cm, idx);
  if (cfg) {
    aom_yv12_copy_frame(sd, cfg, num_planes);
    return 0;
  } else {
    return -1;
  }
}

int av1_update_entropy(bool *ext_refresh_frame_context,
                       bool *ext_refresh_frame_context_pending, bool update) {
  *ext_refresh_frame_context = update;
  *ext_refresh_frame_context_pending = 1;
  return 0;
}

#if defined(OUTPUT_YUV_DENOISED) || defined(OUTPUT_YUV_SKINMAP)
// The denoiser buffer is allocated as a YUV 440 buffer. This function writes it
// as YUV 420. We simply use the top-left pixels of the UV buffers, since we do
// not denoise the UV channels at this time. If ever we implement UV channel
// denoising we will have to modify this.
void aom_write_yuv_frame_420(YV12_BUFFER_CONFIG *s, FILE *f) {
  uint8_t *src = s->y_buffer;
  int h = s->y_height;

  do {
    fwrite(src, s->y_width, 1, f);
    src += s->y_stride;
  } while (--h);

  src = s->u_buffer;
  h = s->uv_height;

  do {
    fwrite(src, s->uv_width, 1, f);
    src += s->uv_stride;
  } while (--h);

  src = s->v_buffer;
  h = s->uv_height;

  do {
    fwrite(src, s->uv_width, 1, f);
    src += s->uv_stride;
  } while (--h);
}
#endif

#ifdef OUTPUT_YUV_REC
void aom_write_one_yuv_frame(AV1_COMMON *cm, YV12_BUFFER_CONFIG *s) {
  uint8_t *src = s->y_buffer;
  int h = cm->height;
  if (yuv_rec_file == NULL) return;
  if (s->flags & YV12_FLAG_HIGHBITDEPTH) {
    uint16_t *src16 = CONVERT_TO_SHORTPTR(s->y_buffer);

    do {
      fwrite(src16, s->y_width, 2, yuv_rec_file);
      src16 += s->y_stride;
    } while (--h);

    src16 = CONVERT_TO_SHORTPTR(s->u_buffer);
    h = s->uv_height;

    do {
      fwrite(src16, s->uv_width, 2, yuv_rec_file);
      src16 += s->uv_stride;
    } while (--h);

    src16 = CONVERT_TO_SHORTPTR(s->v_buffer);
    h = s->uv_height;

    do {
      fwrite(src16, s->uv_width, 2, yuv_rec_file);
      src16 += s->uv_stride;
    } while (--h);

    fflush(yuv_rec_file);
    return;
  }

  do {
    fwrite(src, s->y_width, 1, yuv_rec_file);
    src += s->y_stride;
  } while (--h);

  src = s->u_buffer;
  h = s->uv_height;

  do {
    fwrite(src, s->uv_width, 1, yuv_rec_file);
    src += s->uv_stride;
  } while (--h);

  src = s->v_buffer;
  h = s->uv_height;

  do {
    fwrite(src, s->uv_width, 1, yuv_rec_file);
    src += s->uv_stride;
  } while (--h);

  fflush(yuv_rec_file);
}
#endif  // OUTPUT_YUV_REC

#define GM_RECODE_LOOP_NUM4X4_FACTOR 192
static int recode_loop_test_global_motion(
    WarpedMotionParams *const global_motion,
    const int *const global_motion_used, int *const gm_params_cost) {
  int i;
  int recode = 0;
  for (i = LAST_FRAME; i <= ALTREF_FRAME; ++i) {
    if (global_motion[i].wmtype != IDENTITY &&
        global_motion_used[i] * GM_RECODE_LOOP_NUM4X4_FACTOR <
            gm_params_cost[i]) {
      global_motion[i] = default_warp_params;
      assert(global_motion[i].wmtype == IDENTITY);
      gm_params_cost[i] = 0;
      recode = 1;
      // TODO(sarahparker): The earlier condition for recoding here was:
      // "recode |= (rdc->global_motion_used[i] > 0);". Can we bring something
      // similar to that back to speed up global motion?
    }
  }
  return recode;
}

// Function to test for conditions that indicate we should loop
// back and recode a frame.
static int recode_loop_test(AV1_COMP *cpi, int high_limit, int low_limit, int q,
                            int maxq, int minq) {
  const RATE_CONTROL *const rc = &cpi->rc;
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  const int frame_is_kfgfarf = frame_is_kf_gf_arf(cpi);
  int force_recode = 0;

  if ((rc->projected_frame_size >= rc->max_frame_bandwidth) ||
      (cpi->sf.hl_sf.recode_loop == ALLOW_RECODE) ||
      (frame_is_kfgfarf &&
       (cpi->sf.hl_sf.recode_loop == ALLOW_RECODE_KFARFGF))) {
    // TODO(agrange) high_limit could be greater than the scale-down threshold.
    if ((rc->projected_frame_size > high_limit && q < maxq) ||
        (rc->projected_frame_size < low_limit && q > minq)) {
      force_recode = 1;
    } else if (cpi->oxcf.rc_mode == AOM_CQ) {
      // Deal with frame undershoot and whether or not we are
      // below the automatically set cq level.
      if (q > oxcf->cq_level &&
          rc->projected_frame_size < ((rc->this_frame_target * 7) >> 3)) {
        force_recode = 1;
      }
    }
  }
  return force_recode;
}

static void scale_references(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MV_REFERENCE_FRAME ref_frame;

  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    // Need to convert from AOM_REFFRAME to index into ref_mask (subtract 1).
    if (cpi->ref_frame_flags & av1_ref_frame_flag_list[ref_frame]) {
      BufferPool *const pool = cm->buffer_pool;
      const YV12_BUFFER_CONFIG *const ref =
          get_ref_frame_yv12_buf(cm, ref_frame);

      if (ref == NULL) {
        cpi->scaled_ref_buf[ref_frame - 1] = NULL;
        continue;
      }

      if (ref->y_crop_width != cm->width || ref->y_crop_height != cm->height) {
        // Replace the reference buffer with a copy having a thicker border,
        // if the reference buffer is higher resolution than the current
        // frame, and the border is thin.
        if ((ref->y_crop_width > cm->width ||
             ref->y_crop_height > cm->height) &&
            ref->border < AOM_BORDER_IN_PIXELS) {
          RefCntBuffer *ref_fb = get_ref_frame_buf(cm, ref_frame);
          if (aom_yv12_realloc_with_new_border(
                  &ref_fb->buf, AOM_BORDER_IN_PIXELS,
                  cm->features.byte_alignment, num_planes) != 0) {
            aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                               "Failed to allocate frame buffer");
          }
        }
        int force_scaling = 0;
        RefCntBuffer *new_fb = cpi->scaled_ref_buf[ref_frame - 1];
        if (new_fb == NULL) {
          const int new_fb_idx = get_free_fb(cm);
          if (new_fb_idx == INVALID_IDX) {
            aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                               "Unable to find free frame buffer");
          }
          force_scaling = 1;
          new_fb = &pool->frame_bufs[new_fb_idx];
        }

        if (force_scaling || new_fb->buf.y_crop_width != cm->width ||
            new_fb->buf.y_crop_height != cm->height) {
          if (aom_realloc_frame_buffer(
                  &new_fb->buf, cm->width, cm->height,
                  cm->seq_params.subsampling_x, cm->seq_params.subsampling_y,
                  cm->seq_params.use_highbitdepth, AOM_BORDER_IN_PIXELS,
                  cm->features.byte_alignment, NULL, NULL, NULL)) {
            if (force_scaling) {
              // Release the reference acquired in the get_free_fb() call above.
              --new_fb->ref_count;
            }
            aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                               "Failed to allocate frame buffer");
          }
          av1_resize_and_extend_frame(
              ref, &new_fb->buf, (int)cm->seq_params.bit_depth, num_planes);
          cpi->scaled_ref_buf[ref_frame - 1] = new_fb;
          alloc_frame_mvs(cm, new_fb);
        }
      } else {
        RefCntBuffer *buf = get_ref_frame_buf(cm, ref_frame);
        buf->buf.y_crop_width = ref->y_crop_width;
        buf->buf.y_crop_height = ref->y_crop_height;
        cpi->scaled_ref_buf[ref_frame - 1] = buf;
        ++buf->ref_count;
      }
    } else {
      if (!has_no_stats_stage(cpi)) cpi->scaled_ref_buf[ref_frame - 1] = NULL;
    }
  }
}

static void release_scaled_references(AV1_COMP *cpi) {
  // TODO(isbs): only refresh the necessary frames, rather than all of them
  for (int i = 0; i < INTER_REFS_PER_FRAME; ++i) {
    RefCntBuffer *const buf = cpi->scaled_ref_buf[i];
    if (buf != NULL) {
      --buf->ref_count;
      cpi->scaled_ref_buf[i] = NULL;
    }
  }
}

static void set_mv_search_params(AV1_COMP *cpi) {
  const AV1_COMMON *const cm = &cpi->common;
  MotionVectorSearchParams *const mv_search_params = &cpi->mv_search_params;
  const int max_mv_def = AOMMAX(cm->width, cm->height);

  // Default based on max resolution.
  mv_search_params->mv_step_param = av1_init_search_range(max_mv_def);

  if (cpi->sf.mv_sf.auto_mv_step_size) {
    if (frame_is_intra_only(cm)) {
      // Initialize max_mv_magnitude for use in the first INTER frame
      // after a key/intra-only frame.
      mv_search_params->max_mv_magnitude = max_mv_def;
    } else {
      // Use cpi->max_mv_magnitude == -1 to exclude first pass case.
      if (cm->show_frame && mv_search_params->max_mv_magnitude != -1) {
        // Allow mv_steps to correspond to twice the max mv magnitude found
        // in the previous frame, capped by the default max_mv_magnitude based
        // on resolution.
        mv_search_params->mv_step_param = av1_init_search_range(
            AOMMIN(max_mv_def, 2 * mv_search_params->max_mv_magnitude));
      }
      mv_search_params->max_mv_magnitude = -1;
    }
  }
}

void av1_set_screen_content_options(const AV1_COMP *cpi,
                                    FeatureFlags *features) {
  const AV1_COMMON *const cm = &cpi->common;

  if (cm->seq_params.force_screen_content_tools != 2) {
    features->allow_screen_content_tools = features->allow_intrabc =
        cm->seq_params.force_screen_content_tools;
    return;
  }

  if (cpi->oxcf.mode == REALTIME) {
    assert(cm->seq_params.reduced_still_picture_hdr);
    features->allow_screen_content_tools = features->allow_intrabc = 0;
    return;
  }

  if (cpi->oxcf.content == AOM_CONTENT_SCREEN) {
    features->allow_screen_content_tools = features->allow_intrabc = 1;
    return;
  }

  // Estimate if the source frame is screen content, based on the portion of
  // blocks that have few luma colors.
  const uint8_t *src = cpi->unfiltered_source->y_buffer;
  assert(src != NULL);
  const int use_hbd = cpi->unfiltered_source->flags & YV12_FLAG_HIGHBITDEPTH;
  const int stride = cpi->unfiltered_source->y_stride;
  const int width = cpi->unfiltered_source->y_width;
  const int height = cpi->unfiltered_source->y_height;
  const int bd = cm->seq_params.bit_depth;
  const int blk_w = 16;
  const int blk_h = 16;
  // These threshold values are selected experimentally.
  const int color_thresh = 4;
  const unsigned int var_thresh = 0;
  // Counts of blocks with no more than color_thresh colors.
  int counts_1 = 0;
  // Counts of blocks with no more than color_thresh colors and variance larger
  // than var_thresh.
  int counts_2 = 0;

  for (int r = 0; r + blk_h <= height; r += blk_h) {
    for (int c = 0; c + blk_w <= width; c += blk_w) {
      int count_buf[1 << 12];  // Maximum (1 << 12) color levels.
      const uint8_t *const this_src = src + r * stride + c;
      const int n_colors =
          use_hbd ? av1_count_colors_highbd(this_src, stride, blk_w, blk_h, bd,
                                            count_buf)
                  : av1_count_colors(this_src, stride, blk_w, blk_h, count_buf);
      if (n_colors > 1 && n_colors <= color_thresh) {
        ++counts_1;
        struct buf_2d buf;
        buf.stride = stride;
        buf.buf = (uint8_t *)this_src;
        const unsigned int var =
            use_hbd
                ? av1_high_get_sby_perpixel_variance(cpi, &buf, BLOCK_16X16, bd)
                : av1_get_sby_perpixel_variance(cpi, &buf, BLOCK_16X16);
        if (var > var_thresh) ++counts_2;
      }
    }
  }

  // The threshold values are selected experimentally.
  features->allow_screen_content_tools =
      counts_1 * blk_h * blk_w * 10 > width * height;
  // IntraBC would force loop filters off, so we use more strict rules that also
  // requires that the block has high variance.
  features->allow_intrabc = features->allow_screen_content_tools &&
                            counts_2 * blk_h * blk_w * 12 > width * height;
}

static void set_size_independent_vars(AV1_COMP *cpi) {
  int i;
  AV1_COMMON *const cm = &cpi->common;
  for (i = LAST_FRAME; i <= ALTREF_FRAME; ++i) {
    cm->global_motion[i] = default_warp_params;
  }
  cpi->gm_info.search_done = 0;

  av1_set_speed_features_framesize_independent(cpi, cpi->speed);
  av1_set_rd_speed_thresholds(cpi);
  cm->features.interp_filter = SWITCHABLE;
  cm->features.switchable_motion_mode = 1;
}

#if !CONFIG_REALTIME_ONLY
double av1_get_gfu_boost_projection_factor(double min_factor, double max_factor,
                                           int frame_count) {
  double factor = sqrt((double)frame_count);
  factor = AOMMIN(factor, max_factor);
  factor = AOMMAX(factor, min_factor);
  factor = (200.0 + 10.0 * factor);
  return factor;
}

static int get_gfu_boost_from_r0_lap(double min_factor, double max_factor,
                                     double r0, int frames_to_key) {
  double factor = av1_get_gfu_boost_projection_factor(min_factor, max_factor,
                                                      frames_to_key);
  const int boost = (int)rint(factor / r0);
  return boost;
}

double av1_get_kf_boost_projection_factor(int frame_count) {
  double factor = sqrt((double)frame_count);
  factor = AOMMIN(factor, 10.0);
  factor = AOMMAX(factor, 4.0);
  factor = (75.0 + 14.0 * factor);
  return factor;
}

static int get_kf_boost_from_r0(double r0, int frames_to_key) {
  double factor = av1_get_kf_boost_projection_factor(frames_to_key);
  const int boost = (int)rint(factor / r0);
  return boost;
}
#endif

#define MIN_BOOST_COMBINE_FACTOR 4.0
#define MAX_BOOST_COMBINE_FACTOR 12.0
int combine_prior_with_tpl_boost(double min_factor, double max_factor,
                                 int prior_boost, int tpl_boost,
                                 int frames_to_key) {
  double factor = sqrt((double)frames_to_key);
  double range = max_factor - min_factor;
  factor = AOMMIN(factor, max_factor);
  factor = AOMMAX(factor, min_factor);
  factor -= min_factor;
  int boost =
      (int)((factor * prior_boost + (range - factor) * tpl_boost) / range);
  return boost;
}

#if !CONFIG_REALTIME_ONLY
static void process_tpl_stats_frame(AV1_COMP *cpi) {
  const GF_GROUP *const gf_group = &cpi->gf_group;
  AV1_COMMON *const cm = &cpi->common;

  assert(IMPLIES(gf_group->size > 0, gf_group->index < gf_group->size));

  const int tpl_idx = gf_group->index;
  TplParams *const tpl_data = &cpi->tpl_data;
  TplDepFrame *tpl_frame = &tpl_data->tpl_frame[tpl_idx];
  TplDepStats *tpl_stats = tpl_frame->tpl_stats_ptr;

  if (tpl_frame->is_valid) {
    int tpl_stride = tpl_frame->stride;
    int64_t intra_cost_base = 0;
    int64_t mc_dep_cost_base = 0;
    int64_t mc_saved_base = 0;
    int64_t mc_count_base = 0;
    const int step = 1 << tpl_data->tpl_stats_block_mis_log2;
    const int mi_cols_sr = av1_pixels_to_mi(cm->superres_upscaled_width);

    for (int row = 0; row < cm->mi_params.mi_rows; row += step) {
      for (int col = 0; col < mi_cols_sr; col += step) {
        TplDepStats *this_stats = &tpl_stats[av1_tpl_ptr_pos(
            row, col, tpl_stride, tpl_data->tpl_stats_block_mis_log2)];
        int64_t mc_dep_delta =
            RDCOST(tpl_frame->base_rdmult, this_stats->mc_dep_rate,
                   this_stats->mc_dep_dist);
        intra_cost_base += (this_stats->recrf_dist << RDDIV_BITS);
        mc_dep_cost_base +=
            (this_stats->recrf_dist << RDDIV_BITS) + mc_dep_delta;
        mc_count_base += this_stats->mc_count;
        mc_saved_base += this_stats->mc_saved;
      }
    }

    if (mc_dep_cost_base == 0) {
      tpl_frame->is_valid = 0;
    } else {
      aom_clear_system_state();
      cpi->rd.r0 = (double)intra_cost_base / mc_dep_cost_base;
      if (is_frame_arf_and_tpl_eligible(gf_group)) {
        cpi->rd.arf_r0 = cpi->rd.r0;
        if (cpi->lap_enabled) {
          double min_boost_factor = sqrt(cpi->rc.baseline_gf_interval);
          const int gfu_boost = get_gfu_boost_from_r0_lap(
              min_boost_factor, MAX_GFUBOOST_FACTOR, cpi->rd.arf_r0,
              cpi->rc.num_stats_required_for_gfu_boost);
          // printf("old boost %d new boost %d\n", cpi->rc.gfu_boost,
          //        gfu_boost);
          cpi->rc.gfu_boost = combine_prior_with_tpl_boost(
              min_boost_factor, MAX_BOOST_COMBINE_FACTOR, cpi->rc.gfu_boost,
              gfu_boost, cpi->rc.num_stats_used_for_gfu_boost);
        } else {
          const int gfu_boost = (int)(200.0 / cpi->rd.r0);
          cpi->rc.gfu_boost = combine_prior_with_tpl_boost(
              MIN_BOOST_COMBINE_FACTOR, MAX_BOOST_COMBINE_FACTOR,
              cpi->rc.gfu_boost, gfu_boost, cpi->rc.frames_to_key);
        }
      } else if (frame_is_intra_only(cm)) {
        // TODO(debargha): Turn off q adjustment for kf temporarily to
        // reduce impact on speed of encoding. Need to investigate how
        // to mitigate the issue.
        if (cpi->oxcf.rc_mode == AOM_Q) {
          const int kf_boost =
              get_kf_boost_from_r0(cpi->rd.r0, cpi->rc.frames_to_key);
          if (cpi->lap_enabled) {
            cpi->rc.kf_boost = combine_prior_with_tpl_boost(
                MIN_BOOST_COMBINE_FACTOR, MAX_BOOST_COMBINE_FACTOR,
                cpi->rc.kf_boost, kf_boost,
                cpi->rc.num_stats_used_for_kf_boost);
          } else {
            cpi->rc.kf_boost = combine_prior_with_tpl_boost(
                MIN_BOOST_COMBINE_FACTOR, MAX_BOOST_COMBINE_FACTOR,
                cpi->rc.kf_boost, kf_boost, cpi->rc.frames_to_key);
          }
        }
      }
      cpi->rd.mc_count_base = (double)mc_count_base /
                              (cm->mi_params.mi_rows * cm->mi_params.mi_cols);
      cpi->rd.mc_saved_base = (double)mc_saved_base /
                              (cm->mi_params.mi_rows * cm->mi_params.mi_cols);
      aom_clear_system_state();
    }
  }
}
#endif  // !CONFIG_REALTIME_ONLY

static void set_size_dependent_vars(AV1_COMP *cpi, int *q, int *bottom_index,
                                    int *top_index) {
  AV1_COMMON *const cm = &cpi->common;

  // Setup variables that depend on the dimensions of the frame.
  av1_set_speed_features_framesize_dependent(cpi, cpi->speed);

#if !CONFIG_REALTIME_ONLY
  if (cpi->oxcf.enable_tpl_model && is_frame_tpl_eligible(cpi)) {
    process_tpl_stats_frame(cpi);
    av1_tpl_rdmult_setup(cpi);
  }
#endif

  // Decide q and q bounds.
  *q = av1_rc_pick_q_and_bounds(cpi, &cpi->rc, cm->width, cm->height,
                                cpi->gf_group.index, bottom_index, top_index);

  // Configure experimental use of segmentation for enhanced coding of
  // static regions if indicated.
  // Only allowed in the second pass of a two pass encode, as it requires
  // lagged coding, and if the relevant speed feature flag is set.
  if (is_stat_consumption_stage_twopass(cpi) &&
      cpi->sf.hl_sf.static_segmentation)
    configure_static_seg_features(cpi);
}

static void init_motion_estimation(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  MotionVectorSearchParams *const mv_search_params = &cpi->mv_search_params;
  const int y_stride = cpi->scaled_source.y_stride;
  const int y_stride_src =
      ((cpi->oxcf.width != cm->width || cpi->oxcf.height != cm->height) ||
       av1_superres_scaled(cm))
          ? y_stride
          : cpi->lookahead->buf->img.y_stride;
  int fpf_y_stride = cm->cur_frame != NULL ? cm->cur_frame->buf.y_stride
                                           : cpi->scaled_source.y_stride;

  // Update if ss_cfg is uninitialized or the current frame has a new stride
  const int should_update =
      !mv_search_params->ss_cfg[SS_CFG_SRC].stride ||
      !mv_search_params->ss_cfg[SS_CFG_LOOKAHEAD].stride ||
      (y_stride != mv_search_params->ss_cfg[SS_CFG_SRC].stride);

  if (!should_update) {
    return;
  }

  if (cpi->sf.mv_sf.search_method == DIAMOND) {
    av1_init_dsmotion_compensation(&mv_search_params->ss_cfg[SS_CFG_SRC],
                                   y_stride);
    av1_init_dsmotion_compensation(&mv_search_params->ss_cfg[SS_CFG_LOOKAHEAD],
                                   y_stride_src);
  } else {
    av1_init3smotion_compensation(&mv_search_params->ss_cfg[SS_CFG_SRC],
                                  y_stride);
    av1_init3smotion_compensation(&mv_search_params->ss_cfg[SS_CFG_LOOKAHEAD],
                                  y_stride_src);
  }
  av1_init_motion_fpf(&mv_search_params->ss_cfg[SS_CFG_FPF], fpf_y_stride);
}

#define COUPLED_CHROMA_FROM_LUMA_RESTORATION 0
static void set_restoration_unit_size(int width, int height, int sx, int sy,
                                      RestorationInfo *rst) {
  (void)width;
  (void)height;
  (void)sx;
  (void)sy;
#if COUPLED_CHROMA_FROM_LUMA_RESTORATION
  int s = AOMMIN(sx, sy);
#else
  int s = 0;
#endif  // !COUPLED_CHROMA_FROM_LUMA_RESTORATION

  if (width * height > 352 * 288)
    rst[0].restoration_unit_size = RESTORATION_UNITSIZE_MAX;
  else
    rst[0].restoration_unit_size = (RESTORATION_UNITSIZE_MAX >> 1);
  rst[1].restoration_unit_size = rst[0].restoration_unit_size >> s;
  rst[2].restoration_unit_size = rst[1].restoration_unit_size;
}

static void init_ref_frame_bufs(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  int i;
  BufferPool *const pool = cm->buffer_pool;
  cm->cur_frame = NULL;
  for (i = 0; i < REF_FRAMES; ++i) {
    cm->ref_frame_map[i] = NULL;
  }
  for (i = 0; i < FRAME_BUFFERS; ++i) {
    pool->frame_bufs[i].ref_count = 0;
  }
}

void av1_check_initial_width(AV1_COMP *cpi, int use_highbitdepth,
                             int subsampling_x, int subsampling_y) {
  AV1_COMMON *const cm = &cpi->common;
  SequenceHeader *const seq_params = &cm->seq_params;

  if (!cpi->initial_width || seq_params->use_highbitdepth != use_highbitdepth ||
      seq_params->subsampling_x != subsampling_x ||
      seq_params->subsampling_y != subsampling_y) {
    seq_params->subsampling_x = subsampling_x;
    seq_params->subsampling_y = subsampling_y;
    seq_params->use_highbitdepth = use_highbitdepth;

    av1_set_speed_features_framesize_independent(cpi, cpi->oxcf.speed);
    av1_set_speed_features_framesize_dependent(cpi, cpi->oxcf.speed);

    if (!is_stat_generation_stage(cpi)) {
      alloc_altref_frame_buffer(cpi);
      alloc_util_frame_buffers(cpi);
    }
    init_ref_frame_bufs(cpi);

    init_motion_estimation(cpi);  // TODO(agrange) This can be removed.

    cpi->initial_width = cm->width;
    cpi->initial_height = cm->height;
    cpi->initial_mbs = cm->mi_params.MBs;
  }
}

// Returns 1 if the assigned width or height was <= 0.
int av1_set_size_literal(AV1_COMP *cpi, int width, int height) {
  AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  av1_check_initial_width(cpi, cm->seq_params.use_highbitdepth,
                          cm->seq_params.subsampling_x,
                          cm->seq_params.subsampling_y);

  if (width <= 0 || height <= 0) return 1;

  cm->width = width;
  cm->height = height;

  if (cpi->initial_width && cpi->initial_height &&
      (cm->width > cpi->initial_width || cm->height > cpi->initial_height)) {
    av1_free_context_buffers(cm);
    av1_free_pc_tree(cpi, &cpi->td, num_planes, cm->seq_params.sb_size);
    alloc_compressor_data(cpi);
    realloc_segmentation_maps(cpi);
    cpi->initial_width = cpi->initial_height = 0;
  }
  update_frame_size(cpi);

  return 0;
}

void av1_set_frame_size(AV1_COMP *cpi, int width, int height) {
  AV1_COMMON *const cm = &cpi->common;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *const xd = &cpi->td.mb.e_mbd;
  int ref_frame;

  if (width != cm->width || height != cm->height) {
    // There has been a change in the encoded frame size
    av1_set_size_literal(cpi, width, height);
    // Recalculate 'all_lossless' in case super-resolution was (un)selected.
    cm->features.all_lossless =
        cm->features.coded_lossless && !av1_superres_scaled(cm);
  }
  set_mv_search_params(cpi);

  if (is_stat_consumption_stage(cpi)) {
    av1_set_target_rate(cpi, cm->width, cm->height);
  }

  alloc_frame_mvs(cm, cm->cur_frame);

  // Allocate above context buffers
  CommonContexts *const above_contexts = &cm->above_contexts;
  if (above_contexts->num_planes < av1_num_planes(cm) ||
      above_contexts->num_mi_cols < cm->mi_params.mi_cols ||
      above_contexts->num_tile_rows < cm->tiles.rows) {
    av1_free_above_context_buffers(above_contexts);
    if (av1_alloc_above_context_buffers(above_contexts, cm->tiles.rows,
                                        cm->mi_params.mi_cols,
                                        av1_num_planes(cm)))
      aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                         "Failed to allocate context buffers");
  }

  // Reset the frame pointers to the current frame size.
  if (aom_realloc_frame_buffer(
          &cm->cur_frame->buf, cm->width, cm->height, seq_params->subsampling_x,
          seq_params->subsampling_y, seq_params->use_highbitdepth,
          cpi->oxcf.border_in_pixels, cm->features.byte_alignment, NULL, NULL,
          NULL))
    aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                       "Failed to allocate frame buffer");

  const int frame_width = cm->superres_upscaled_width;
  const int frame_height = cm->superres_upscaled_height;
  set_restoration_unit_size(frame_width, frame_height,
                            seq_params->subsampling_x,
                            seq_params->subsampling_y, cm->rst_info);
  for (int i = 0; i < num_planes; ++i)
    cm->rst_info[i].frame_restoration_type = RESTORE_NONE;

  av1_alloc_restoration_buffers(cm);
  if (!is_stat_generation_stage(cpi)) alloc_util_frame_buffers(cpi);
  init_motion_estimation(cpi);

  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    RefCntBuffer *const buf = get_ref_frame_buf(cm, ref_frame);
    if (buf != NULL) {
      struct scale_factors *sf = get_ref_scale_factors(cm, ref_frame);
      av1_setup_scale_factors_for_frame(sf, buf->buf.y_crop_width,
                                        buf->buf.y_crop_height, cm->width,
                                        cm->height);
      if (av1_is_scaled(sf)) aom_extend_frame_borders(&buf->buf, num_planes);
    }
  }

  av1_setup_scale_factors_for_frame(&cm->sf_identity, cm->width, cm->height,
                                    cm->width, cm->height);

  set_ref_ptrs(cm, xd, LAST_FRAME, LAST_FRAME);
}

static uint8_t calculate_next_resize_scale(const AV1_COMP *cpi) {
  // Choose an arbitrary random number
  static unsigned int seed = 56789;
  const AV1EncoderConfig *oxcf = &cpi->oxcf;
  if (is_stat_generation_stage(cpi)) return SCALE_NUMERATOR;
  uint8_t new_denom = SCALE_NUMERATOR;

  if (cpi->common.seq_params.reduced_still_picture_hdr) return SCALE_NUMERATOR;
  switch (oxcf->resize_mode) {
    case RESIZE_NONE: new_denom = SCALE_NUMERATOR; break;
    case RESIZE_FIXED:
      if (cpi->common.current_frame.frame_type == KEY_FRAME)
        new_denom = oxcf->resize_kf_scale_denominator;
      else
        new_denom = oxcf->resize_scale_denominator;
      break;
    case RESIZE_RANDOM: new_denom = lcg_rand16(&seed) % 9 + 8; break;
    default: assert(0);
  }
  return new_denom;
}

#if CONFIG_SUPERRES_IN_RECODE
static int superres_in_recode_allowed(const AV1_COMP *const cpi) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  // Empirically found to not be beneficial for AOM_Q mode and images coding.
  return oxcf->superres_mode == SUPERRES_AUTO &&
         (oxcf->rc_mode == AOM_VBR || oxcf->rc_mode == AOM_CQ) &&
         cpi->rc.frames_to_key > 1;
}
#endif  // CONFIG_SUPERRES_IN_RECODE

#define SUPERRES_ENERGY_BY_Q2_THRESH_KEYFRAME_SOLO 0.012
#define SUPERRES_ENERGY_BY_Q2_THRESH_KEYFRAME 0.008
#define SUPERRES_ENERGY_BY_Q2_THRESH_ARFFRAME 0.008
#define SUPERRES_ENERGY_BY_AC_THRESH 0.2

static double get_energy_by_q2_thresh(const GF_GROUP *gf_group,
                                      const RATE_CONTROL *rc) {
  // TODO(now): Return keyframe thresh * factor based on frame type / pyramid
  // level.
  if (gf_group->update_type[gf_group->index] == ARF_UPDATE) {
    return SUPERRES_ENERGY_BY_Q2_THRESH_ARFFRAME;
  } else if (gf_group->update_type[gf_group->index] == KF_UPDATE) {
    if (rc->frames_to_key <= 1)
      return SUPERRES_ENERGY_BY_Q2_THRESH_KEYFRAME_SOLO;
    else
      return SUPERRES_ENERGY_BY_Q2_THRESH_KEYFRAME;
  } else {
    assert(0);
  }
  return 0;
}

static uint8_t get_superres_denom_from_qindex_energy(int qindex, double *energy,
                                                     double threshq,
                                                     double threshp) {
  const double q = av1_convert_qindex_to_q(qindex, AOM_BITS_8);
  const double tq = threshq * q * q;
  const double tp = threshp * energy[1];
  const double thresh = AOMMIN(tq, tp);
  int k;
  for (k = SCALE_NUMERATOR * 2; k > SCALE_NUMERATOR; --k) {
    if (energy[k - 1] > thresh) break;
  }
  return 3 * SCALE_NUMERATOR - k;
}

static uint8_t get_superres_denom_for_qindex(const AV1_COMP *cpi, int qindex,
                                             int sr_kf, int sr_arf) {
  // Use superres for Key-frames and Alt-ref frames only.
  const GF_GROUP *gf_group = &cpi->gf_group;
  if (gf_group->update_type[gf_group->index] != KF_UPDATE &&
      gf_group->update_type[gf_group->index] != ARF_UPDATE) {
    return SCALE_NUMERATOR;
  }
  if (gf_group->update_type[gf_group->index] == KF_UPDATE && !sr_kf) {
    return SCALE_NUMERATOR;
  }
  if (gf_group->update_type[gf_group->index] == ARF_UPDATE && !sr_arf) {
    return SCALE_NUMERATOR;
  }

  double energy[16];
  analyze_hor_freq(cpi, energy);

  const double energy_by_q2_thresh =
      get_energy_by_q2_thresh(gf_group, &cpi->rc);
  int denom = get_superres_denom_from_qindex_energy(
      qindex, energy, energy_by_q2_thresh, SUPERRES_ENERGY_BY_AC_THRESH);
  /*
  printf("\nenergy = [");
  for (int k = 1; k < 16; ++k) printf("%f, ", energy[k]);
  printf("]\n");
  printf("boost = %d\n",
         (gf_group->update_type[gf_group->index] == KF_UPDATE)
             ? cpi->rc.kf_boost
             : cpi->rc.gfu_boost);
  printf("denom = %d\n", denom);
  */
#if CONFIG_SUPERRES_IN_RECODE
  if (superres_in_recode_allowed(cpi)) {
    assert(cpi->superres_mode != SUPERRES_NONE);
    // Force superres to be tried in the recode loop, as full-res is also going
    // to be tried anyway.
    denom = AOMMAX(denom, SCALE_NUMERATOR + 1);
  }
#endif  // CONFIG_SUPERRES_IN_RECODE
  return denom;
}

// If true, SUPERRES_AUTO mode will exhaustively search over all superres
// denominators for all frames (except overlay and internal overlay frames).
#define SUPERRES_RECODE_ALL_RATIOS 0

static uint8_t calculate_next_superres_scale(AV1_COMP *cpi) {
  // Choose an arbitrary random number
  static unsigned int seed = 34567;
  const AV1EncoderConfig *oxcf = &cpi->oxcf;
  if (is_stat_generation_stage(cpi)) return SCALE_NUMERATOR;
  uint8_t new_denom = SCALE_NUMERATOR;

  // Make sure that superres mode of the frame is consistent with the
  // sequence-level flag.
  assert(IMPLIES(oxcf->superres_mode != SUPERRES_NONE,
                 cpi->common.seq_params.enable_superres));
  assert(IMPLIES(!cpi->common.seq_params.enable_superres,
                 oxcf->superres_mode == SUPERRES_NONE));
  // Make sure that superres mode for current encoding is consistent with user
  // provided superres mode.
  assert(IMPLIES(oxcf->superres_mode != SUPERRES_AUTO,
                 cpi->superres_mode == oxcf->superres_mode));

  // Note: we must look at the current superres_mode to be tried in 'cpi' here,
  // not the user given mode in 'oxcf'.
  switch (cpi->superres_mode) {
    case SUPERRES_NONE: new_denom = SCALE_NUMERATOR; break;
    case SUPERRES_FIXED:
      if (cpi->common.current_frame.frame_type == KEY_FRAME)
        new_denom = oxcf->superres_kf_scale_denominator;
      else
        new_denom = oxcf->superres_scale_denominator;
      break;
    case SUPERRES_RANDOM: new_denom = lcg_rand16(&seed) % 9 + 8; break;
    case SUPERRES_QTHRESH: {
      // Do not use superres when screen content tools are used.
      if (cpi->common.features.allow_screen_content_tools) break;
      if (oxcf->rc_mode == AOM_VBR || oxcf->rc_mode == AOM_CQ)
        av1_set_target_rate(cpi, cpi->oxcf.width, cpi->oxcf.height);

      // Now decide the use of superres based on 'q'.
      int bottom_index, top_index;
      const int q = av1_rc_pick_q_and_bounds(
          cpi, &cpi->rc, cpi->oxcf.width, cpi->oxcf.height, cpi->gf_group.index,
          &bottom_index, &top_index);

      const int qthresh = (frame_is_intra_only(&cpi->common))
                              ? oxcf->superres_kf_qthresh
                              : oxcf->superres_qthresh;
      if (q <= qthresh) {
        new_denom = SCALE_NUMERATOR;
      } else {
        new_denom = get_superres_denom_for_qindex(cpi, q, 1, 1);
      }
      break;
    }
    case SUPERRES_AUTO: {
      // Do not use superres when screen content tools are used.
      if (cpi->common.features.allow_screen_content_tools) break;
      if (oxcf->rc_mode == AOM_VBR || oxcf->rc_mode == AOM_CQ)
        av1_set_target_rate(cpi, cpi->oxcf.width, cpi->oxcf.height);

      // Now decide the use of superres based on 'q'.
      int bottom_index, top_index;
      const int q = av1_rc_pick_q_and_bounds(
          cpi, &cpi->rc, cpi->oxcf.width, cpi->oxcf.height, cpi->gf_group.index,
          &bottom_index, &top_index);

      const int qthresh = 128;
      if (q <= qthresh) {
        new_denom = SCALE_NUMERATOR;
      } else {
#if SUPERRES_RECODE_ALL_RATIOS
        if (cpi->common.current_frame.frame_type == KEY_FRAME)
          new_denom = oxcf->superres_kf_scale_denominator;
        else
          new_denom = oxcf->superres_scale_denominator;
#else
        new_denom = get_superres_denom_for_qindex(cpi, q, 1, 1);
#endif  // SUPERRES_RECODE_ALL_RATIOS
      }
      break;
    }
    default: assert(0);
  }
  return new_denom;
}

static int dimension_is_ok(int orig_dim, int resized_dim, int denom) {
  return (resized_dim * SCALE_NUMERATOR >= orig_dim * denom / 2);
}

static int dimensions_are_ok(int owidth, int oheight, size_params_type *rsz) {
  // Only need to check the width, as scaling is horizontal only.
  (void)oheight;
  return dimension_is_ok(owidth, rsz->resize_width, rsz->superres_denom);
}

static int validate_size_scales(RESIZE_MODE resize_mode,
                                SUPERRES_MODE superres_mode, int owidth,
                                int oheight, size_params_type *rsz) {
  if (dimensions_are_ok(owidth, oheight, rsz)) {  // Nothing to do.
    return 1;
  }

  // Calculate current resize scale.
  int resize_denom =
      AOMMAX(DIVIDE_AND_ROUND(owidth * SCALE_NUMERATOR, rsz->resize_width),
             DIVIDE_AND_ROUND(oheight * SCALE_NUMERATOR, rsz->resize_height));

  if (resize_mode != RESIZE_RANDOM && superres_mode == SUPERRES_RANDOM) {
    // Alter superres scale as needed to enforce conformity.
    rsz->superres_denom =
        (2 * SCALE_NUMERATOR * SCALE_NUMERATOR) / resize_denom;
    if (!dimensions_are_ok(owidth, oheight, rsz)) {
      if (rsz->superres_denom > SCALE_NUMERATOR) --rsz->superres_denom;
    }
  } else if (resize_mode == RESIZE_RANDOM && superres_mode != SUPERRES_RANDOM) {
    // Alter resize scale as needed to enforce conformity.
    resize_denom =
        (2 * SCALE_NUMERATOR * SCALE_NUMERATOR) / rsz->superres_denom;
    rsz->resize_width = owidth;
    rsz->resize_height = oheight;
    av1_calculate_scaled_size(&rsz->resize_width, &rsz->resize_height,
                              resize_denom);
    if (!dimensions_are_ok(owidth, oheight, rsz)) {
      if (resize_denom > SCALE_NUMERATOR) {
        --resize_denom;
        rsz->resize_width = owidth;
        rsz->resize_height = oheight;
        av1_calculate_scaled_size(&rsz->resize_width, &rsz->resize_height,
                                  resize_denom);
      }
    }
  } else if (resize_mode == RESIZE_RANDOM && superres_mode == SUPERRES_RANDOM) {
    // Alter both resize and superres scales as needed to enforce conformity.
    do {
      if (resize_denom > rsz->superres_denom)
        --resize_denom;
      else
        --rsz->superres_denom;
      rsz->resize_width = owidth;
      rsz->resize_height = oheight;
      av1_calculate_scaled_size(&rsz->resize_width, &rsz->resize_height,
                                resize_denom);
    } while (!dimensions_are_ok(owidth, oheight, rsz) &&
             (resize_denom > SCALE_NUMERATOR ||
              rsz->superres_denom > SCALE_NUMERATOR));
  } else {  // We are allowed to alter neither resize scale nor superres
            // scale.
    return 0;
  }
  return dimensions_are_ok(owidth, oheight, rsz);
}

// Calculates resize and superres params for next frame
static size_params_type calculate_next_size_params(AV1_COMP *cpi) {
  const AV1EncoderConfig *oxcf = &cpi->oxcf;
  ResizePendingParams *resize_pending_params = &cpi->resize_pending_params;
  size_params_type rsz = { oxcf->width, oxcf->height, SCALE_NUMERATOR };
  int resize_denom = SCALE_NUMERATOR;
  if (has_no_stats_stage(cpi) && cpi->use_svc &&
      cpi->svc.spatial_layer_id < cpi->svc.number_spatial_layers - 1) {
    rsz.resize_width = cpi->common.width;
    rsz.resize_height = cpi->common.height;
    return rsz;
  }
  if (is_stat_generation_stage(cpi)) return rsz;
  if (resize_pending_params->width && resize_pending_params->height) {
    rsz.resize_width = resize_pending_params->width;
    rsz.resize_height = resize_pending_params->height;
    resize_pending_params->width = resize_pending_params->height = 0;
  } else {
    resize_denom = calculate_next_resize_scale(cpi);
    rsz.resize_width = oxcf->width;
    rsz.resize_height = oxcf->height;
    av1_calculate_scaled_size(&rsz.resize_width, &rsz.resize_height,
                              resize_denom);
  }
  rsz.superres_denom = calculate_next_superres_scale(cpi);
  if (!validate_size_scales(oxcf->resize_mode, cpi->superres_mode, oxcf->width,
                            oxcf->height, &rsz))
    assert(0 && "Invalid scale parameters");
  return rsz;
}

static void setup_frame_size_from_params(AV1_COMP *cpi,
                                         const size_params_type *rsz) {
  int encode_width = rsz->resize_width;
  int encode_height = rsz->resize_height;

  AV1_COMMON *cm = &cpi->common;
  cm->superres_upscaled_width = encode_width;
  cm->superres_upscaled_height = encode_height;
  cm->superres_scale_denominator = rsz->superres_denom;
  av1_calculate_scaled_superres_size(&encode_width, &encode_height,
                                     rsz->superres_denom);
  av1_set_frame_size(cpi, encode_width, encode_height);
}

void av1_setup_frame_size(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  // Reset superres params from previous frame.
  cm->superres_scale_denominator = SCALE_NUMERATOR;
  const size_params_type rsz = calculate_next_size_params(cpi);
  setup_frame_size_from_params(cpi, &rsz);

  assert(av1_is_min_tile_width_satisfied(cm));
}

static void superres_post_encode(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);

  if (!av1_superres_scaled(cm)) return;

  assert(cpi->oxcf.enable_superres);
  assert(!is_lossless_requested(&cpi->oxcf));
  assert(!cm->features.all_lossless);

  av1_superres_upscale(cm, NULL);

  // If regular resizing is occurring the source will need to be downscaled to
  // match the upscaled superres resolution. Otherwise the original source is
  // used.
  if (!av1_resize_scaled(cm)) {
    cpi->source = cpi->unscaled_source;
    if (cpi->last_source != NULL) cpi->last_source = cpi->unscaled_last_source;
  } else {
    assert(cpi->unscaled_source->y_crop_width != cm->superres_upscaled_width);
    assert(cpi->unscaled_source->y_crop_height != cm->superres_upscaled_height);
    // Do downscale. cm->(width|height) has been updated by
    // av1_superres_upscale
    if (aom_realloc_frame_buffer(
            &cpi->scaled_source, cm->superres_upscaled_width,
            cm->superres_upscaled_height, cm->seq_params.subsampling_x,
            cm->seq_params.subsampling_y, cm->seq_params.use_highbitdepth,
            AOM_BORDER_IN_PIXELS, cm->features.byte_alignment, NULL, NULL,
            NULL))
      aom_internal_error(
          &cm->error, AOM_CODEC_MEM_ERROR,
          "Failed to reallocate scaled source buffer for superres");
    assert(cpi->scaled_source.y_crop_width == cm->superres_upscaled_width);
    assert(cpi->scaled_source.y_crop_height == cm->superres_upscaled_height);
    av1_resize_and_extend_frame(cpi->unscaled_source, &cpi->scaled_source,
                                (int)cm->seq_params.bit_depth, num_planes);
    cpi->source = &cpi->scaled_source;
  }
}

static void cdef_restoration_frame(AV1_COMP *cpi, AV1_COMMON *cm,
                                   MACROBLOCKD *xd, int use_restoration,
                                   int use_cdef) {
  if (use_restoration)
    av1_loop_restoration_save_boundary_lines(&cm->cur_frame->buf, cm, 0);

  if (use_cdef) {
#if CONFIG_COLLECT_COMPONENT_TIMING
    start_timing(cpi, cdef_time);
#endif
    // Find CDEF parameters
    av1_cdef_search(&cm->cur_frame->buf, cpi->source, cm, xd,
                    cpi->sf.lpf_sf.cdef_pick_method, cpi->td.mb.rdmult);

    // Apply the filter
    av1_cdef_frame(&cm->cur_frame->buf, cm, xd);
#if CONFIG_COLLECT_COMPONENT_TIMING
    end_timing(cpi, cdef_time);
#endif
  } else {
    cm->cdef_info.cdef_bits = 0;
    cm->cdef_info.cdef_strengths[0] = 0;
    cm->cdef_info.nb_cdef_strengths = 1;
    cm->cdef_info.cdef_uv_strengths[0] = 0;
  }

  superres_post_encode(cpi);

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, loop_restoration_time);
#endif
  if (use_restoration) {
    av1_loop_restoration_save_boundary_lines(&cm->cur_frame->buf, cm, 1);
    av1_pick_filter_restoration(cpi->source, cpi);
    if (cm->rst_info[0].frame_restoration_type != RESTORE_NONE ||
        cm->rst_info[1].frame_restoration_type != RESTORE_NONE ||
        cm->rst_info[2].frame_restoration_type != RESTORE_NONE) {
      if (cpi->num_workers > 1)
        av1_loop_restoration_filter_frame_mt(&cm->cur_frame->buf, cm, 0,
                                             cpi->workers, cpi->num_workers,
                                             &cpi->lr_row_sync, &cpi->lr_ctxt);
      else
        av1_loop_restoration_filter_frame(&cm->cur_frame->buf, cm, 0,
                                          &cpi->lr_ctxt);
    }
  } else {
    cm->rst_info[0].frame_restoration_type = RESTORE_NONE;
    cm->rst_info[1].frame_restoration_type = RESTORE_NONE;
    cm->rst_info[2].frame_restoration_type = RESTORE_NONE;
  }
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, loop_restoration_time);
#endif
}

static void loopfilter_frame(AV1_COMP *cpi, AV1_COMMON *cm) {
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *xd = &cpi->td.mb.e_mbd;

  assert(IMPLIES(is_lossless_requested(&cpi->oxcf),
                 cm->features.coded_lossless && cm->features.all_lossless));

  const int use_loopfilter =
      !cm->features.coded_lossless && !cm->tiles.large_scale;
  const int use_cdef = cm->seq_params.enable_cdef &&
                       !cm->features.coded_lossless && !cm->tiles.large_scale;
  const int use_restoration = cm->seq_params.enable_restoration &&
                              !cm->features.all_lossless &&
                              !cm->tiles.large_scale;

  struct loopfilter *lf = &cm->lf;

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, loop_filter_time);
#endif
  if (use_loopfilter) {
    aom_clear_system_state();
    av1_pick_filter_level(cpi->source, cpi, cpi->sf.lpf_sf.lpf_pick);
  } else {
    lf->filter_level[0] = 0;
    lf->filter_level[1] = 0;
  }

  if (lf->filter_level[0] || lf->filter_level[1]) {
    if (cpi->num_workers > 1)
      av1_loop_filter_frame_mt(&cm->cur_frame->buf, cm, xd, 0, num_planes, 0,
#if CONFIG_LPF_MASK
                               0,
#endif
                               cpi->workers, cpi->num_workers,
                               &cpi->lf_row_sync);
    else
      av1_loop_filter_frame(&cm->cur_frame->buf, cm, xd,
#if CONFIG_LPF_MASK
                            0,
#endif
                            0, num_planes, 0);
  }
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, loop_filter_time);
#endif

  cdef_restoration_frame(cpi, cm, xd, use_restoration, use_cdef);
}

static void fix_interp_filter(InterpFilter *const interp_filter,
                              const FRAME_COUNTS *const counts) {
  if (*interp_filter == SWITCHABLE) {
    // Check to see if only one of the filters is actually used
    int count[SWITCHABLE_FILTERS] = { 0 };
    int num_filters_used = 0;
    for (int i = 0; i < SWITCHABLE_FILTERS; ++i) {
      for (int j = 0; j < SWITCHABLE_FILTER_CONTEXTS; ++j)
        count[i] += counts->switchable_interp[j][i];
      num_filters_used += (count[i] > 0);
    }
    if (num_filters_used == 1) {
      // Only one filter is used. So set the filter at frame level
      for (int i = 0; i < SWITCHABLE_FILTERS; ++i) {
        if (count[i]) {
          if (i == EIGHTTAP_REGULAR) *interp_filter = i;
          break;
        }
      }
    }
  }
}

static void finalize_encoded_frame(AV1_COMP *const cpi) {
  AV1_COMMON *const cm = &cpi->common;
  CurrentFrame *const current_frame = &cm->current_frame;

  if (!cm->seq_params.reduced_still_picture_hdr &&
      encode_show_existing_frame(cm)) {
    RefCntBuffer *const frame_to_show =
        cm->ref_frame_map[cpi->existing_fb_idx_to_show];

    if (frame_to_show == NULL) {
      aom_internal_error(&cm->error, AOM_CODEC_UNSUP_BITSTREAM,
                         "Buffer does not contain a reconstructed frame");
    }
    assert(frame_to_show->ref_count > 0);
    assign_frame_buffer_p(&cm->cur_frame, frame_to_show);
  }

  if (!encode_show_existing_frame(cm) &&
      cm->seq_params.film_grain_params_present &&
      (cm->show_frame || cm->showable_frame)) {
    // Copy the current frame's film grain params to the its corresponding
    // RefCntBuffer slot.
    cm->cur_frame->film_grain_params = cm->film_grain_params;

    // We must update the parameters if this is not an INTER_FRAME
    if (current_frame->frame_type != INTER_FRAME)
      cm->cur_frame->film_grain_params.update_parameters = 1;

    // Iterate the random seed for the next frame.
    cm->film_grain_params.random_seed += 3381;
    if (cm->film_grain_params.random_seed == 0)
      cm->film_grain_params.random_seed = 7391;
  }

  // Initialise all tiles' contexts from the global frame context
  for (int tile_col = 0; tile_col < cm->tiles.cols; tile_col++) {
    for (int tile_row = 0; tile_row < cm->tiles.rows; tile_row++) {
      const int tile_idx = tile_row * cm->tiles.cols + tile_col;
      cpi->tile_data[tile_idx].tctx = *cm->fc;
    }
  }

  fix_interp_filter(&cm->features.interp_filter, cpi->td.counts);
}

static int get_regulated_q_overshoot(AV1_COMP *const cpi, int q_low, int q_high,
                                     int top_index, int bottom_index) {
  const AV1_COMMON *const cm = &cpi->common;
  const RATE_CONTROL *const rc = &cpi->rc;

  av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);

  int q_regulated =
      av1_rc_regulate_q(cpi, rc->this_frame_target, bottom_index,
                        AOMMAX(q_high, top_index), cm->width, cm->height);

  int retries = 0;
  while (q_regulated < q_low && retries < 10) {
    av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);
    q_regulated =
        av1_rc_regulate_q(cpi, rc->this_frame_target, bottom_index,
                          AOMMAX(q_high, top_index), cm->width, cm->height);
    retries++;
  }
  return q_regulated;
}

static int get_regulated_q_undershoot(AV1_COMP *const cpi, int q_high,
                                      int top_index, int bottom_index) {
  const AV1_COMMON *const cm = &cpi->common;
  const RATE_CONTROL *const rc = &cpi->rc;

  av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);
  int q_regulated = av1_rc_regulate_q(cpi, rc->this_frame_target, bottom_index,
                                      top_index, cm->width, cm->height);

  int retries = 0;
  while (q_regulated > q_high && retries < 10) {
    av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);
    q_regulated = av1_rc_regulate_q(cpi, rc->this_frame_target, bottom_index,
                                    top_index, cm->width, cm->height);
    retries++;
  }
  return q_regulated;
}

// Called after encode_with_recode_loop() has just encoded a frame and packed
// its bitstream.  This function works out whether we under- or over-shot
// our bitrate target and adjusts q as appropriate.  Also decides whether
// or not we should do another recode loop, indicated by *loop
static void recode_loop_update_q(
    AV1_COMP *const cpi, int *const loop, int *const q, int *const q_low,
    int *const q_high, const int top_index, const int bottom_index,
    int *const undershoot_seen, int *const overshoot_seen,
    int *const low_cr_seen, const int loop_at_this_size) {
  AV1_COMMON *const cm = &cpi->common;
  RATE_CONTROL *const rc = &cpi->rc;
  *loop = 0;

  const int min_cr = cpi->oxcf.min_cr;
  if (min_cr > 0) {
    aom_clear_system_state();
    const double compression_ratio =
        av1_get_compression_ratio(cm, rc->projected_frame_size >> 3);
    const double target_cr = min_cr / 100.0;
    if (compression_ratio < target_cr) {
      *low_cr_seen = 1;
      if (*q < rc->worst_quality) {
        const double cr_ratio = target_cr / compression_ratio;
        const int projected_q = AOMMAX(*q + 1, (int)(*q * cr_ratio * cr_ratio));
        *q = AOMMIN(AOMMIN(projected_q, *q + 32), rc->worst_quality);
        *q_low = AOMMAX(*q, *q_low);
        *q_high = AOMMAX(*q, *q_high);
        *loop = 1;
      }
    }
    if (*low_cr_seen) return;
  }

  if (cpi->oxcf.rc_mode == AOM_Q) return;

  const int last_q = *q;
  int frame_over_shoot_limit = 0, frame_under_shoot_limit = 0;
  av1_rc_compute_frame_size_bounds(cpi, rc->this_frame_target,
                                   &frame_under_shoot_limit,
                                   &frame_over_shoot_limit);
  if (frame_over_shoot_limit == 0) frame_over_shoot_limit = 1;

  if (cm->current_frame.frame_type == KEY_FRAME && rc->this_key_frame_forced &&
      rc->projected_frame_size < rc->max_frame_bandwidth) {
    int64_t kf_err;
    const int64_t high_err_target = cpi->ambient_err;
    const int64_t low_err_target = cpi->ambient_err >> 1;

#if CONFIG_AV1_HIGHBITDEPTH
    if (cm->seq_params.use_highbitdepth) {
      kf_err = aom_highbd_get_y_sse(cpi->source, &cm->cur_frame->buf);
    } else {
      kf_err = aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
    }
#else
    kf_err = aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
#endif
    // Prevent possible divide by zero error below for perfect KF
    kf_err += !kf_err;

    // The key frame is not good enough or we can afford
    // to make it better without undue risk of popping.
    if ((kf_err > high_err_target &&
         rc->projected_frame_size <= frame_over_shoot_limit) ||
        (kf_err > low_err_target &&
         rc->projected_frame_size <= frame_under_shoot_limit)) {
      // Lower q_high
      *q_high = AOMMAX(*q - 1, *q_low);

      // Adjust Q
      *q = (int)((*q * high_err_target) / kf_err);
      *q = AOMMIN(*q, (*q_high + *q_low) >> 1);
    } else if (kf_err < low_err_target &&
               rc->projected_frame_size >= frame_under_shoot_limit) {
      // The key frame is much better than the previous frame
      // Raise q_low
      *q_low = AOMMIN(*q + 1, *q_high);

      // Adjust Q
      *q = (int)((*q * low_err_target) / kf_err);
      *q = AOMMIN(*q, (*q_high + *q_low + 1) >> 1);
    }

    // Clamp Q to upper and lower limits:
    *q = clamp(*q, *q_low, *q_high);
    *loop = (*q != last_q);
    return;
  }

  if (recode_loop_test(cpi, frame_over_shoot_limit, frame_under_shoot_limit, *q,
                       AOMMAX(*q_high, top_index), bottom_index)) {
    // Is the projected frame size out of range and are we allowed
    // to attempt to recode.

    // Frame size out of permitted range:
    // Update correction factor & compute new Q to try...
    // Frame is too large
    if (rc->projected_frame_size > rc->this_frame_target) {
      // Special case if the projected size is > the max allowed.
      if (*q == *q_high &&
          rc->projected_frame_size >= rc->max_frame_bandwidth) {
        const double q_val_high_current =
            av1_convert_qindex_to_q(*q_high, cm->seq_params.bit_depth);
        const double q_val_high_new =
            q_val_high_current *
            ((double)rc->projected_frame_size / rc->max_frame_bandwidth);
        *q_high = av1_find_qindex(q_val_high_new, cm->seq_params.bit_depth,
                                  rc->best_quality, rc->worst_quality);
      }

      // Raise Qlow as to at least the current value
      *q_low = AOMMIN(*q + 1, *q_high);

      if (*undershoot_seen || loop_at_this_size > 2 ||
          (loop_at_this_size == 2 && !frame_is_intra_only(cm))) {
        av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);

        *q = (*q_high + *q_low + 1) / 2;
      } else if (loop_at_this_size == 2 && frame_is_intra_only(cm)) {
        const int q_mid = (*q_high + *q_low + 1) / 2;
        const int q_regulated = get_regulated_q_overshoot(
            cpi, *q_low, *q_high, top_index, bottom_index);
        // Get 'q' in-between 'q_mid' and 'q_regulated' for a smooth
        // transition between loop_at_this_size < 2 and loop_at_this_size > 2.
        *q = (q_mid + q_regulated + 1) / 2;
      } else {
        *q = get_regulated_q_overshoot(cpi, *q_low, *q_high, top_index,
                                       bottom_index);
      }

      *overshoot_seen = 1;
    } else {
      // Frame is too small
      *q_high = AOMMAX(*q - 1, *q_low);

      if (*overshoot_seen || loop_at_this_size > 2 ||
          (loop_at_this_size == 2 && !frame_is_intra_only(cm))) {
        av1_rc_update_rate_correction_factors(cpi, cm->width, cm->height);
        *q = (*q_high + *q_low) / 2;
      } else if (loop_at_this_size == 2 && frame_is_intra_only(cm)) {
        const int q_mid = (*q_high + *q_low) / 2;
        const int q_regulated =
            get_regulated_q_undershoot(cpi, *q_high, top_index, bottom_index);
        // Get 'q' in-between 'q_mid' and 'q_regulated' for a smooth
        // transition between loop_at_this_size < 2 and loop_at_this_size > 2.
        *q = (q_mid + q_regulated) / 2;

        // Special case reset for qlow for constrained quality.
        // This should only trigger where there is very substantial
        // undershoot on a frame and the auto cq level is above
        // the user passsed in value.
        if (cpi->oxcf.rc_mode == AOM_CQ && q_regulated < *q_low) {
          *q_low = *q;
        }
      } else {
        *q = get_regulated_q_undershoot(cpi, *q_high, top_index, bottom_index);

        // Special case reset for qlow for constrained quality.
        // This should only trigger where there is very substantial
        // undershoot on a frame and the auto cq level is above
        // the user passsed in value.
        if (cpi->oxcf.rc_mode == AOM_CQ && *q < *q_low) {
          *q_low = *q;
        }
      }

      *undershoot_seen = 1;
    }

    // Clamp Q to upper and lower limits:
    *q = clamp(*q, *q_low, *q_high);
  }

  *loop = (*q != last_q);
}

static int get_interp_filter_selected(const AV1_COMMON *const cm,
                                      MV_REFERENCE_FRAME ref,
                                      InterpFilter ifilter) {
  const RefCntBuffer *const buf = get_ref_frame_buf(cm, ref);
  if (buf == NULL) return 0;
  return buf->interp_filter_selected[ifilter];
}

static uint16_t setup_interp_filter_search_mask(AV1_COMP *cpi) {
  const AV1_COMMON *const cm = &cpi->common;
  int ref_total[REF_FRAMES] = { 0 };
  uint16_t mask = ALLOW_ALL_INTERP_FILT_MASK;

  if (cpi->last_frame_type == KEY_FRAME || cpi->refresh_alt_ref_frame)
    return mask;

  for (MV_REFERENCE_FRAME ref = LAST_FRAME; ref <= ALTREF_FRAME; ++ref) {
    for (InterpFilter ifilter = EIGHTTAP_REGULAR; ifilter <= MULTITAP_SHARP;
         ++ifilter) {
      ref_total[ref] += get_interp_filter_selected(cm, ref, ifilter);
    }
  }
  int ref_total_total = (ref_total[LAST2_FRAME] + ref_total[LAST3_FRAME] +
                         ref_total[GOLDEN_FRAME] + ref_total[BWDREF_FRAME] +
                         ref_total[ALTREF2_FRAME] + ref_total[ALTREF_FRAME]);

  for (InterpFilter ifilter = EIGHTTAP_REGULAR; ifilter <= MULTITAP_SHARP;
       ++ifilter) {
    int last_score = get_interp_filter_selected(cm, LAST_FRAME, ifilter) * 30;
    if (ref_total[LAST_FRAME] && last_score <= ref_total[LAST_FRAME]) {
      int filter_score =
          get_interp_filter_selected(cm, LAST2_FRAME, ifilter) * 20 +
          get_interp_filter_selected(cm, LAST3_FRAME, ifilter) * 20 +
          get_interp_filter_selected(cm, GOLDEN_FRAME, ifilter) * 20 +
          get_interp_filter_selected(cm, BWDREF_FRAME, ifilter) * 10 +
          get_interp_filter_selected(cm, ALTREF2_FRAME, ifilter) * 10 +
          get_interp_filter_selected(cm, ALTREF_FRAME, ifilter) * 10;
      if (filter_score < ref_total_total) {
        DUAL_FILTER_TYPE filt_type = ifilter + SWITCHABLE_FILTERS * ifilter;
        reset_interp_filter_allowed_mask(&mask, filt_type);
      }
    }
  }
  return mask;
}

#if !CONFIG_REALTIME_ONLY
#define STRICT_PSNR_DIFF_THRESH 0.9
// Encode key frame with/without screen content tools to determine whether
// screen content tools should be enabled for this key frame group or not.
// The first encoding is without screen content tools.
// The second encoding is with screen content tools.
// We compare the psnr and frame size to make the decision.
static void screen_content_tools_determination(
    AV1_COMP *cpi, const int allow_screen_content_tools_orig_decision,
    const int allow_intrabc_orig_decision,
    const int is_screen_content_type_orig_decision, const int pass,
    int *projected_size_pass, PSNR_STATS *psnr) {
  AV1_COMMON *const cm = &cpi->common;
  FeatureFlags *const features = &cm->features;
  projected_size_pass[pass] = cpi->rc.projected_frame_size;
#if CONFIG_AV1_HIGHBITDEPTH
  const uint32_t in_bit_depth = cpi->oxcf.input_bit_depth;
  const uint32_t bit_depth = cpi->td.mb.e_mbd.bd;
  aom_calc_highbd_psnr(cpi->source, &cpi->common.cur_frame->buf, &psnr[pass],
                       bit_depth, in_bit_depth);
#else
  aom_calc_psnr(cpi->source, &cpi->common.cur_frame->buf, &psnr[pass]);
#endif
  if (pass != 1) return;

  const double psnr_diff = psnr[1].psnr[0] - psnr[0].psnr[0];
  const int is_sc_encoding_much_better = psnr_diff > STRICT_PSNR_DIFF_THRESH;
  if (is_sc_encoding_much_better) {
    // Use screen content tools, if we get coding gain.
    features->allow_screen_content_tools = 1;
    features->allow_intrabc = cpi->intrabc_used;
    cpi->is_screen_content_type = 1;
  } else {
    // Use original screen content decision.
    features->allow_screen_content_tools =
        allow_screen_content_tools_orig_decision;
    features->allow_intrabc = allow_intrabc_orig_decision;
    cpi->is_screen_content_type = is_screen_content_type_orig_decision;
  }
}

// Set some encoding parameters to make the encoding process fast.
// A fixed block partition size, and a large q is used.
static void set_encoding_params_for_screen_content(AV1_COMP *cpi,
                                                   const int pass) {
  AV1_COMMON *const cm = &cpi->common;
  if (pass == 0) {
    // In the first pass, encode without screen content tools.
    // Use a high q, and a fixed block size for fast encoding.
    cm->features.allow_screen_content_tools = 0;
    cm->features.allow_intrabc = 0;
    cpi->is_screen_content_type = 0;
    cpi->sf.part_sf.partition_search_type = FIXED_PARTITION;
    cpi->sf.part_sf.always_this_block_size = BLOCK_32X32;
    return;
  }
  assert(pass == 1);
  // In the second pass, encode with screen content tools.
  // Use a high q, and a fixed block size for fast encoding.
  cm->features.allow_screen_content_tools = 1;
  // TODO(chengchen): turn intrabc on could lead to data race issue.
  // cm->allow_intrabc = 1;
  cpi->is_screen_content_type = 1;
  cpi->sf.part_sf.partition_search_type = FIXED_PARTITION;
  cpi->sf.part_sf.always_this_block_size = BLOCK_32X32;
}

// Determines whether to use screen content tools for the key frame group.
// This function modifies "cm->features.allow_screen_content_tools",
// "cm->features.allow_intrabc" and "cpi->is_screen_content_type".
static void determine_sc_tools_with_encoding(AV1_COMP *cpi, const int q_orig) {
  AV1_COMMON *const cm = &cpi->common;
  // Variables to help determine if we should allow screen content tools.
  int projected_size_pass[3] = { 0 };
  PSNR_STATS psnr[3];
  const int is_key_frame = cm->current_frame.frame_type == KEY_FRAME;
  const int allow_screen_content_tools_orig_decision =
      cm->features.allow_screen_content_tools;
  const int allow_intrabc_orig_decision = cm->features.allow_intrabc;
  const int is_screen_content_type_orig_decision = cpi->is_screen_content_type;
  // Turn off the encoding trial for forward key frame and superres.
  if (cpi->sf.rt_sf.use_nonrd_pick_mode || cpi->oxcf.fwd_kf_enabled ||
      cpi->superres_mode != SUPERRES_NONE || cpi->oxcf.mode == REALTIME ||
      is_screen_content_type_orig_decision || !is_key_frame) {
    return;
  }

  // TODO(chengchen): multiple encoding for the lossless mode is time consuming.
  // Find a better way to determine whether screen content tools should be used
  // for lossless coding.
  // Use a high q and a fixed partition to do quick encoding.
  const int q_for_screen_content_quick_run =
      is_lossless_requested(&cpi->oxcf) ? q_orig : AOMMAX(q_orig, 244);
  const int partition_search_type_orig = cpi->sf.part_sf.partition_search_type;
  const BLOCK_SIZE fixed_partition_block_size_orig =
      cpi->sf.part_sf.always_this_block_size;

  // Setup necessary params for encoding, including frame source, etc.
  aom_clear_system_state();

  cpi->source =
      av1_scale_if_required(cm, cpi->unscaled_source, &cpi->scaled_source);
  if (cpi->unscaled_last_source != NULL) {
    cpi->last_source = av1_scale_if_required(cm, cpi->unscaled_last_source,
                                             &cpi->scaled_last_source);
  }

  setup_frame(cpi);

  if (cm->seg.enabled) {
    if (!cm->seg.update_data && cm->prev_frame) {
      segfeatures_copy(&cm->seg, &cm->prev_frame->seg);
      cm->seg.enabled = cm->prev_frame->seg.enabled;
    } else {
      av1_calculate_segdata(&cm->seg);
    }
  } else {
    memset(&cm->seg, 0, sizeof(cm->seg));
  }
  segfeatures_copy(&cm->cur_frame->seg, &cm->seg);
  cm->cur_frame->seg.enabled = cm->seg.enabled;

  // The two encoding passes aim to help determine whether to use screen
  // content tools, with a high q and fixed partition.
  for (int pass = 0; pass < 2; ++pass) {
    set_encoding_params_for_screen_content(cpi, pass);
#if CONFIG_TUNE_VMAF
    if (cpi->oxcf.tuning == AOM_TUNE_VMAF_WITH_PREPROCESSING ||
        cpi->oxcf.tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
        cpi->oxcf.tuning == AOM_TUNE_VMAF_MAX_GAIN) {
      av1_set_quantizer(
          cm, cpi->oxcf.qm_minlevel, cpi->oxcf.qm_maxlevel,
          av1_get_vmaf_base_qindex(cpi, q_for_screen_content_quick_run));
    } else {
#endif
      av1_set_quantizer(cm, cpi->oxcf.qm_minlevel, cpi->oxcf.qm_maxlevel,
                        q_for_screen_content_quick_run);
#if CONFIG_TUNE_VMAF
    }
#endif
    av1_set_speed_features_qindex_dependent(cpi, cpi->oxcf.speed);
    if (cpi->oxcf.deltaq_mode != NO_DELTA_Q)
      av1_init_quantizer(&cpi->enc_quant_dequant_params, &cm->quant_params,
                         cm->seq_params.bit_depth);

    av1_set_variance_partition_thresholds(cpi, q_for_screen_content_quick_run,
                                          0);
    // transform / motion compensation build reconstruction frame
    av1_encode_frame(cpi);
    // Screen content decision
    screen_content_tools_determination(
        cpi, allow_screen_content_tools_orig_decision,
        allow_intrabc_orig_decision, is_screen_content_type_orig_decision, pass,
        projected_size_pass, psnr);
  }

  // Set partition speed feature back.
  cpi->sf.part_sf.partition_search_type = partition_search_type_orig;
  cpi->sf.part_sf.always_this_block_size = fixed_partition_block_size_orig;
}
#endif  // CONFIG_REALTIME_ONLY

static int encode_with_recode_loop(AV1_COMP *cpi, size_t *size, uint8_t *dest) {
  AV1_COMMON *const cm = &cpi->common;
  RATE_CONTROL *const rc = &cpi->rc;
  GlobalMotionInfo *const gm_info = &cpi->gm_info;
  const int allow_recode = (cpi->sf.hl_sf.recode_loop != DISALLOW_RECODE);
  // Must allow recode if minimum compression ratio is set.
  assert(IMPLIES(cpi->oxcf.min_cr > 0, allow_recode));

  set_size_independent_vars(cpi);
  if (is_stat_consumption_stage_twopass(cpi) &&
      cpi->sf.interp_sf.adaptive_interp_filter_search)
    cpi->interp_search_flags.interp_filter_search_mask =
        setup_interp_filter_search_mask(cpi);
  cpi->source->buf_8bit_valid = 0;

  av1_setup_frame_size(cpi);

#if CONFIG_SUPERRES_IN_RECODE
  if (superres_in_recode_allowed(cpi) && cpi->superres_mode != SUPERRES_NONE &&
      cm->superres_scale_denominator == SCALE_NUMERATOR) {
    // Superres mode is currently enabled, but the denominator selected will
    // disable superres. So no need to continue, as we will go through another
    // recode loop for full-resolution after this anyway.
    return -1;
  }
#endif  // CONFIG_SUPERRES_IN_RECODE

  int top_index = 0, bottom_index = 0;
  int q = 0, q_low = 0, q_high = 0;
  set_size_dependent_vars(cpi, &q, &bottom_index, &top_index);
  q_low = bottom_index;
  q_high = top_index;
  if (cpi->sf.part_sf.partition_search_type == VAR_BASED_PARTITION) {
    const int num_64x64_blocks =
        (cm->seq_params.sb_size == BLOCK_64X64) ? 1 : 4;
    if (cpi->td.vt64x64) {
      if (num_64x64_blocks != cpi->td.num_64x64_blocks) {
        aom_free(cpi->td.vt64x64);
        cpi->td.vt64x64 = NULL;
      }
    }
    if (!cpi->td.vt64x64) {
      CHECK_MEM_ERROR(cm, cpi->td.vt64x64,
                      aom_malloc(sizeof(*cpi->td.vt64x64) * num_64x64_blocks));
      cpi->td.num_64x64_blocks = num_64x64_blocks;
    }
  }

  if (cm->current_frame.frame_type == KEY_FRAME) {
    FrameProbInfo *const frame_probs = &cpi->frame_probs;

    if (cpi->sf.tx_sf.tx_type_search.prune_tx_type_using_stats) {
      av1_copy(frame_probs->tx_type_probs, default_tx_type_probs);
    }

    if (!cpi->sf.inter_sf.disable_obmc &&
        cpi->sf.inter_sf.prune_obmc_prob_thresh > 0) {
      av1_copy(frame_probs->obmc_probs, default_obmc_probs);
    }

    if (cpi->sf.inter_sf.prune_warped_prob_thresh > 0) {
      av1_copy(frame_probs->warped_probs, default_warped_probs);
    }

    if (cpi->sf.interp_sf.adaptive_interp_filter_search == 2) {
      av1_copy(frame_probs->switchable_interp_probs,
               default_switchable_interp_probs);
    }
  }
#if !CONFIG_REALTIME_ONLY
  // Determine whether to use screen content tools using two fast encoding.
  determine_sc_tools_with_encoding(cpi, q);
#endif  // CONFIG_REALTIME_ONLY

#if CONFIG_COLLECT_COMPONENT_TIMING
  printf("\n Encoding a frame:");
#endif

  // Loop variables
  int loop = 0;
  int loop_count = 0;
  int loop_at_this_size = 0;
  int overshoot_seen = 0;
  int undershoot_seen = 0;
  int low_cr_seen = 0;
  int last_loop_allow_hp = 0;

  do {
    loop = 0;
    aom_clear_system_state();

    // if frame was scaled calculate global_motion_search again if already
    // done
    if (loop_count > 0 && cpi->source && gm_info->search_done) {
      if (cpi->source->y_crop_width != cm->width ||
          cpi->source->y_crop_height != cm->height) {
        gm_info->search_done = 0;
      }
    }
    cpi->source =
        av1_scale_if_required(cm, cpi->unscaled_source, &cpi->scaled_source);
    if (cpi->unscaled_last_source != NULL) {
      cpi->last_source = av1_scale_if_required(cm, cpi->unscaled_last_source,
                                               &cpi->scaled_last_source);
    }

    if (!frame_is_intra_only(cm)) {
      if (loop_count > 0) {
        release_scaled_references(cpi);
      }
      scale_references(cpi);
    }
#if CONFIG_TUNE_VMAF
    if (cpi->oxcf.tuning == AOM_TUNE_VMAF_WITH_PREPROCESSING ||
        cpi->oxcf.tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
        cpi->oxcf.tuning == AOM_TUNE_VMAF_MAX_GAIN) {
      av1_set_quantizer(cm, cpi->oxcf.qm_minlevel, cpi->oxcf.qm_maxlevel,
                        av1_get_vmaf_base_qindex(cpi, q));
    } else {
#endif
      av1_set_quantizer(cm, cpi->oxcf.qm_minlevel, cpi->oxcf.qm_maxlevel, q);
#if CONFIG_TUNE_VMAF
    }
#endif
    av1_set_speed_features_qindex_dependent(cpi, cpi->oxcf.speed);

    if (cpi->oxcf.deltaq_mode != NO_DELTA_Q)
      av1_init_quantizer(&cpi->enc_quant_dequant_params, &cm->quant_params,
                         cm->seq_params.bit_depth);

    av1_set_variance_partition_thresholds(cpi, q, 0);

    // printf("Frame %d/%d: q = %d, frame_type = %d superres_denom = %d\n",
    //        cm->current_frame.frame_number, cm->show_frame, q,
    //        cm->current_frame.frame_type, cm->superres_scale_denominator);

    if (loop_count == 0) {
      setup_frame(cpi);
    } else if (get_primary_ref_frame_buf(cm) == NULL) {
      // Base q-index may have changed, so we need to assign proper default coef
      // probs before every iteration.
      av1_default_coef_probs(cm);
      av1_setup_frame_contexts(cm);
    }

    if (cpi->oxcf.aq_mode == VARIANCE_AQ) {
      av1_vaq_frame_setup(cpi);
    } else if (cpi->oxcf.aq_mode == COMPLEXITY_AQ) {
      av1_setup_in_frame_q_adj(cpi);
    } else if (cpi->oxcf.aq_mode == CYCLIC_REFRESH_AQ && !allow_recode) {
      suppress_active_map(cpi);
      av1_cyclic_refresh_setup(cpi);
      apply_active_map(cpi);
    }

    if (cm->seg.enabled) {
      if (!cm->seg.update_data && cm->prev_frame) {
        segfeatures_copy(&cm->seg, &cm->prev_frame->seg);
        cm->seg.enabled = cm->prev_frame->seg.enabled;
      } else {
        av1_calculate_segdata(&cm->seg);
      }
    } else {
      memset(&cm->seg, 0, sizeof(cm->seg));
    }
    segfeatures_copy(&cm->cur_frame->seg, &cm->seg);
    cm->cur_frame->seg.enabled = cm->seg.enabled;

#if CONFIG_COLLECT_COMPONENT_TIMING
    start_timing(cpi, av1_encode_frame_time);
#endif
    // Set the motion vector precision based on mv stats from the last coded
    // frame.
    if (!frame_is_intra_only(cm)) {
      av1_pick_and_set_high_precision_mv(cpi, q);

      // If the precision has changed during different iteration of the loop,
      // then we need to reset the global motion vectors
      if (loop_count > 0 &&
          cm->features.allow_high_precision_mv != last_loop_allow_hp) {
        gm_info->search_done = 0;
      }
      last_loop_allow_hp = cm->features.allow_high_precision_mv;
    }

    // transform / motion compensation build reconstruction frame
    av1_encode_frame(cpi);
#if !CONFIG_REALTIME_ONLY
    // Reset the mv_stats in case we are interrupted by an intraframe or an
    // overlay frame.
    if (cpi->mv_stats.valid) {
      av1_zero(cpi->mv_stats);
    }
    // Gather the mv_stats for the next frame
    if (cpi->sf.hl_sf.high_precision_mv_usage == LAST_MV_DATA &&
        av1_frame_allows_smart_mv(cpi)) {
      av1_collect_mv_stats(cpi, q);
    }
#endif  // !CONFIG_REALTIME_ONLY

#if CONFIG_COLLECT_COMPONENT_TIMING
    end_timing(cpi, av1_encode_frame_time);
#endif

    aom_clear_system_state();

    // Dummy pack of the bitstream using up to date stats to get an
    // accurate estimate of output frame size to determine if we need
    // to recode.
    const int do_dummy_pack =
        (cpi->sf.hl_sf.recode_loop >= ALLOW_RECODE_KFARFGF &&
         cpi->oxcf.rc_mode != AOM_Q) ||
        cpi->oxcf.min_cr > 0;
    if (do_dummy_pack) {
      finalize_encoded_frame(cpi);
      int largest_tile_id = 0;  // Output from bitstream: unused here
      if (av1_pack_bitstream(cpi, dest, size, &largest_tile_id) !=
          AOM_CODEC_OK) {
        return AOM_CODEC_ERROR;
      }

      rc->projected_frame_size = (int)(*size) << 3;
    }

    if (allow_recode) {
      // Update q and decide whether to do a recode loop
      recode_loop_update_q(cpi, &loop, &q, &q_low, &q_high, top_index,
                           bottom_index, &undershoot_seen, &overshoot_seen,
                           &low_cr_seen, loop_at_this_size);
    }

    // Special case for overlay frame.
    if (loop && rc->is_src_frame_alt_ref &&
        rc->projected_frame_size < rc->max_frame_bandwidth) {
      loop = 0;
    }

    if (allow_recode && !cpi->sf.gm_sf.gm_disable_recode &&
        recode_loop_test_global_motion(cm->global_motion,
                                       cpi->td.rd_counts.global_motion_used,
                                       gm_info->params_cost)) {
      loop = 1;
    }

    if (loop) {
      ++loop_count;
      ++loop_at_this_size;

#if CONFIG_INTERNAL_STATS
      ++cpi->tot_recode_hits;
#endif
    }
#if CONFIG_COLLECT_COMPONENT_TIMING
    if (loop) printf("\n Recoding:");
#endif
  } while (loop);

  // Update some stats from cyclic refresh.
  if (cpi->oxcf.aq_mode == CYCLIC_REFRESH_AQ && !frame_is_intra_only(cm))
    av1_cyclic_refresh_postencode(cpi);

  return AOM_CODEC_OK;
}

static int encode_with_recode_loop_and_filter(AV1_COMP *cpi, size_t *size,
                                              uint8_t *dest, int64_t *sse,
                                              int64_t *rate,
                                              int *largest_tile_id) {
#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, encode_with_recode_loop_time);
#endif
  int err = encode_with_recode_loop(cpi, size, dest);
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, encode_with_recode_loop_time);
#endif
  if (err != AOM_CODEC_OK) {
    if (err == -1) {
      // special case as described in encode_with_recode_loop().
      // Encoding was skipped.
      err = AOM_CODEC_OK;
      if (sse != NULL) *sse = INT64_MAX;
      if (rate != NULL) *rate = INT64_MAX;
      *largest_tile_id = 0;
    }
    return err;
  }

#ifdef OUTPUT_YUV_SKINMAP
  if (cpi->common.current_frame.frame_number > 1) {
    av1_compute_skin_map(cpi, yuv_skinmap_file);
  }
#endif  // OUTPUT_YUV_SKINMAP

  AV1_COMMON *const cm = &cpi->common;
  SequenceHeader *const seq_params = &cm->seq_params;

  // Special case code to reduce pulsing when key frames are forced at a
  // fixed interval. Note the reconstruction error if it is the frame before
  // the force key frame
  if (cpi->rc.next_key_frame_forced && cpi->rc.frames_to_key == 1) {
#if CONFIG_AV1_HIGHBITDEPTH
    if (seq_params->use_highbitdepth) {
      cpi->ambient_err = aom_highbd_get_y_sse(cpi->source, &cm->cur_frame->buf);
    } else {
      cpi->ambient_err = aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
    }
#else
    cpi->ambient_err = aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
#endif
  }

  cm->cur_frame->buf.color_primaries = seq_params->color_primaries;
  cm->cur_frame->buf.transfer_characteristics =
      seq_params->transfer_characteristics;
  cm->cur_frame->buf.matrix_coefficients = seq_params->matrix_coefficients;
  cm->cur_frame->buf.monochrome = seq_params->monochrome;
  cm->cur_frame->buf.chroma_sample_position =
      seq_params->chroma_sample_position;
  cm->cur_frame->buf.color_range = seq_params->color_range;
  cm->cur_frame->buf.render_width = cm->render_width;
  cm->cur_frame->buf.render_height = cm->render_height;

  // TODO(zoeliu): For non-ref frames, loop filtering may need to be turned
  // off.

  // Pick the loop filter level for the frame.
  if (!cm->features.allow_intrabc) {
    loopfilter_frame(cpi, cm);
  } else {
    cm->lf.filter_level[0] = 0;
    cm->lf.filter_level[1] = 0;
    cm->cdef_info.cdef_bits = 0;
    cm->cdef_info.cdef_strengths[0] = 0;
    cm->cdef_info.nb_cdef_strengths = 1;
    cm->cdef_info.cdef_uv_strengths[0] = 0;
    cm->rst_info[0].frame_restoration_type = RESTORE_NONE;
    cm->rst_info[1].frame_restoration_type = RESTORE_NONE;
    cm->rst_info[2].frame_restoration_type = RESTORE_NONE;
  }

  // TODO(debargha): Fix mv search range on encoder side
  // aom_extend_frame_inner_borders(&cm->cur_frame->buf, av1_num_planes(cm));
  aom_extend_frame_borders(&cm->cur_frame->buf, av1_num_planes(cm));

#ifdef OUTPUT_YUV_REC
  aom_write_one_yuv_frame(cm, &cm->cur_frame->buf);
#endif

  finalize_encoded_frame(cpi);
  // Build the bitstream
#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, av1_pack_bitstream_final_time);
#endif
  if (av1_pack_bitstream(cpi, dest, size, largest_tile_id) != AOM_CODEC_OK)
    return AOM_CODEC_ERROR;
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, av1_pack_bitstream_final_time);
#endif

  // Compute sse and rate.
  if (sse != NULL) {
#if CONFIG_AV1_HIGHBITDEPTH
    *sse = (seq_params->use_highbitdepth)
               ? aom_highbd_get_y_sse(cpi->source, &cm->cur_frame->buf)
               : aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
#else
    *sse = aom_get_y_sse(cpi->source, &cm->cur_frame->buf);
#endif
  }
  if (rate != NULL) {
    const int64_t bits = (*size << 3);
    *rate = (bits << 5);  // To match scale.
  }
  return AOM_CODEC_OK;
}

#if CONFIG_SUPERRES_IN_RECODE

static void save_cur_buf(AV1_COMP *cpi) {
  CODING_CONTEXT *const cc = &cpi->coding_context;
  AV1_COMMON *cm = &cpi->common;
  const YV12_BUFFER_CONFIG *ybf = &cm->cur_frame->buf;
  memset(&cc->copy_buffer, 0, sizeof(cc->copy_buffer));
  if (aom_alloc_frame_buffer(&cc->copy_buffer, ybf->y_crop_width,
                             ybf->y_crop_height, ybf->subsampling_x,
                             ybf->subsampling_y,
                             ybf->flags & YV12_FLAG_HIGHBITDEPTH, ybf->border,
                             cm->features.byte_alignment) != AOM_CODEC_OK) {
    aom_internal_error(
        &cm->error, AOM_CODEC_MEM_ERROR,
        "Failed to allocate copy buffer for saving coding context");
  }
  aom_yv12_copy_frame(ybf, &cc->copy_buffer, av1_num_planes(cm));
}

// Coding context that only needs to be saved when recode loop includes
// filtering (deblocking, CDEF, superres post-encode upscale and/or loop
// restoraton).
static void save_extra_coding_context(AV1_COMP *cpi) {
  CODING_CONTEXT *const cc = &cpi->coding_context;
  AV1_COMMON *cm = &cpi->common;

  cc->lf = cm->lf;
  cc->cdef_info = cm->cdef_info;
  cc->rc = cpi->rc;
}

static void save_all_coding_context(AV1_COMP *cpi) {
  save_cur_buf(cpi);
  save_extra_coding_context(cpi);
  if (!frame_is_intra_only(&cpi->common)) release_scaled_references(cpi);
}

static void restore_cur_buf(AV1_COMP *cpi) {
  CODING_CONTEXT *const cc = &cpi->coding_context;
  AV1_COMMON *cm = &cpi->common;
  aom_yv12_copy_frame(&cc->copy_buffer, &cm->cur_frame->buf,
                      av1_num_planes(cm));
}

// Coding context that only needs to be restored when recode loop includes
// filtering (deblocking, CDEF, superres post-encode upscale and/or loop
// restoraton).
static void restore_extra_coding_context(AV1_COMP *cpi) {
  CODING_CONTEXT *const cc = &cpi->coding_context;
  AV1_COMMON *cm = &cpi->common;
  cm->lf = cc->lf;
  cm->cdef_info = cc->cdef_info;
  cpi->rc = cc->rc;
}

static void restore_all_coding_context(AV1_COMP *cpi) {
  restore_cur_buf(cpi);
  restore_extra_coding_context(cpi);
  if (!frame_is_intra_only(&cpi->common)) release_scaled_references(cpi);
}

static void release_copy_buffer(CODING_CONTEXT *cc) {
  aom_free_frame_buffer(&cc->copy_buffer);
}

static int encode_with_and_without_superres(AV1_COMP *cpi, size_t *size,
                                            uint8_t *dest,
                                            int *largest_tile_id) {
  const AV1_COMMON *const cm = &cpi->common;
  assert(cm->seq_params.enable_superres);
  assert(superres_in_recode_allowed(cpi));
  aom_codec_err_t err = AOM_CODEC_OK;
  save_all_coding_context(cpi);

  // Encode with superres.
#if SUPERRES_RECODE_ALL_RATIOS
  AV1EncoderConfig *const oxcf = &cpi->oxcf;
  int64_t superres_sses[SCALE_NUMERATOR];
  int64_t superres_rates[SCALE_NUMERATOR];
  int superres_largest_tile_ids[SCALE_NUMERATOR];
  // Use superres for Key-frames and Alt-ref frames only.
  const GF_GROUP *const gf_group = &cpi->gf_group;
  if (gf_group->update_type[gf_group->index] != OVERLAY_UPDATE &&
      gf_group->update_type[gf_group->index] != INTNL_OVERLAY_UPDATE) {
    for (int denom = SCALE_NUMERATOR + 1; denom <= 2 * SCALE_NUMERATOR;
         ++denom) {
      oxcf->superres_scale_denominator = denom;
      oxcf->superres_kf_scale_denominator = denom;
      const int this_index = denom - (SCALE_NUMERATOR + 1);
      err = encode_with_recode_loop_and_filter(
          cpi, size, dest, &superres_sses[this_index],
          &superres_rates[this_index], &superres_largest_tile_ids[this_index]);
      if (err != AOM_CODEC_OK) return err;
      restore_all_coding_context(cpi);
    }
    // Reset.
    oxcf->superres_scale_denominator = SCALE_NUMERATOR;
    oxcf->superres_kf_scale_denominator = SCALE_NUMERATOR;
  } else {
    for (int denom = SCALE_NUMERATOR + 1; denom <= 2 * SCALE_NUMERATOR;
         ++denom) {
      const int this_index = denom - (SCALE_NUMERATOR + 1);
      superres_sses[this_index] = INT64_MAX;
      superres_rates[this_index] = INT64_MAX;
    }
  }
#else
  int64_t sse1 = INT64_MAX;
  int64_t rate1 = INT64_MAX;
  int largest_tile_id1;
  err = encode_with_recode_loop_and_filter(cpi, size, dest, &sse1, &rate1,
                                           &largest_tile_id1);
  if (err != AOM_CODEC_OK) return err;
  restore_all_coding_context(cpi);
#endif  // SUPERRES_RECODE_ALL_RATIOS

  // Encode without superres.
  int64_t sse2 = INT64_MAX;
  int64_t rate2 = INT64_MAX;
  int largest_tile_id2;
  cpi->superres_mode = SUPERRES_NONE;  // To force full-res.
  err = encode_with_recode_loop_and_filter(cpi, size, dest, &sse2, &rate2,
                                           &largest_tile_id2);
  cpi->superres_mode = cpi->oxcf.superres_mode;  // Reset.
  assert(cpi->oxcf.superres_mode == SUPERRES_AUTO);
  if (err != AOM_CODEC_OK) return err;

  // Note: Both use common rdmult based on base qindex of fullres.
  const int64_t rdmult =
      av1_compute_rd_mult_based_on_qindex(cpi, cm->quant_params.base_qindex);

#if SUPERRES_RECODE_ALL_RATIOS
  // Find the best rdcost among all superres denoms.
  double proj_rdcost1 = DBL_MAX;
  int64_t sse1 = INT64_MAX;
  int64_t rate1 = INT64_MAX;
  int largest_tile_id1 = 0;
  (void)sse1;
  (void)rate1;
  (void)largest_tile_id1;
  int best_denom = -1;
  for (int denom = SCALE_NUMERATOR + 1; denom <= 2 * SCALE_NUMERATOR; ++denom) {
    const int this_index = denom - (SCALE_NUMERATOR + 1);
    const int64_t this_sse = superres_sses[this_index];
    const int64_t this_rate = superres_rates[this_index];
    const int this_largest_tile_id = superres_largest_tile_ids[this_index];
    const double this_rdcost = RDCOST_DBL(rdmult, this_rate, this_sse);
    if (this_rdcost < proj_rdcost1) {
      sse1 = this_sse;
      rate1 = this_rate;
      largest_tile_id1 = this_largest_tile_id;
      proj_rdcost1 = this_rdcost;
      best_denom = denom;
    }
  }
#else
  const double proj_rdcost1 = RDCOST_DBL(rdmult, rate1, sse1);
#endif  // SUPERRES_RECODE_ALL_RATIOS
  const double proj_rdcost2 = RDCOST_DBL(rdmult, rate2, sse2);

  // Re-encode with superres if it's better.
  if (proj_rdcost1 < proj_rdcost2) {
    restore_all_coding_context(cpi);
    // TODO(urvang): We should avoid rerunning the recode loop by saving
    // previous output+state, or running encode only for the selected 'q' in
    // previous step.
#if SUPERRES_RECODE_ALL_RATIOS
    // Again, temporarily force the best denom.
    oxcf->superres_scale_denominator = best_denom;
    oxcf->superres_kf_scale_denominator = best_denom;
#endif  // SUPERRES_RECODE_ALL_RATIOS
    int64_t sse3 = INT64_MAX;
    int64_t rate3 = INT64_MAX;
    err = encode_with_recode_loop_and_filter(cpi, size, dest, &sse3, &rate3,
                                             largest_tile_id);
    assert(sse1 == sse3);
    assert(rate1 == rate3);
    assert(largest_tile_id1 == *largest_tile_id);
#if SUPERRES_RECODE_ALL_RATIOS
    // Reset.
    oxcf->superres_scale_denominator = SCALE_NUMERATOR;
    oxcf->superres_kf_scale_denominator = SCALE_NUMERATOR;
#endif  // SUPERRES_RECODE_ALL_RATIOS
  } else {
    *largest_tile_id = largest_tile_id2;
  }

  release_copy_buffer(&cpi->coding_context);

  return err;
}
#endif  // CONFIG_SUPERRES_IN_RECODE

#define DUMP_RECON_FRAMES 0

#if DUMP_RECON_FRAMES == 1
// NOTE(zoeliu): For debug - Output the filtered reconstructed video.
static void dump_filtered_recon_frames(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const CurrentFrame *const current_frame = &cm->current_frame;
  const YV12_BUFFER_CONFIG *recon_buf = &cm->cur_frame->buf;

  if (recon_buf == NULL) {
    printf("Frame %d is not ready.\n", current_frame->frame_number);
    return;
  }

  static const int flag_list[REF_FRAMES] = { 0,
                                             AOM_LAST_FLAG,
                                             AOM_LAST2_FLAG,
                                             AOM_LAST3_FLAG,
                                             AOM_GOLD_FLAG,
                                             AOM_BWD_FLAG,
                                             AOM_ALT2_FLAG,
                                             AOM_ALT_FLAG };
  printf(
      "\n***Frame=%d (frame_offset=%d, show_frame=%d, "
      "show_existing_frame=%d) "
      "[LAST LAST2 LAST3 GOLDEN BWD ALT2 ALT]=[",
      current_frame->frame_number, current_frame->order_hint, cm->show_frame,
      cm->show_existing_frame);
  for (int ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    const RefCntBuffer *const buf = get_ref_frame_buf(cm, ref_frame);
    const int ref_offset = buf != NULL ? (int)buf->order_hint : -1;
    printf(" %d(%c)", ref_offset,
           (cpi->ref_frame_flags & flag_list[ref_frame]) ? 'Y' : 'N');
  }
  printf(" ]\n");

  if (!cm->show_frame) {
    printf("Frame %d is a no show frame, so no image dump.\n",
           current_frame->frame_number);
    return;
  }

  int h;
  char file_name[256] = "/tmp/enc_filtered_recon.yuv";
  FILE *f_recon = NULL;

  if (current_frame->frame_number == 0) {
    if ((f_recon = fopen(file_name, "wb")) == NULL) {
      printf("Unable to open file %s to write.\n", file_name);
      return;
    }
  } else {
    if ((f_recon = fopen(file_name, "ab")) == NULL) {
      printf("Unable to open file %s to append.\n", file_name);
      return;
    }
  }
  printf(
      "\nFrame=%5d, encode_update_type[%5d]=%1d, frame_offset=%d, "
      "show_frame=%d, show_existing_frame=%d, source_alt_ref_active=%d, "
      "refresh_alt_ref_frame=%d, "
      "y_stride=%4d, uv_stride=%4d, cm->width=%4d, cm->height=%4d\n\n",
      current_frame->frame_number, cpi->gf_group.index,
      cpi->gf_group.update_type[cpi->gf_group.index], current_frame->order_hint,
      cm->show_frame, cm->show_existing_frame, cpi->rc.source_alt_ref_active,
      cpi->refresh_alt_ref_frame, recon_buf->y_stride, recon_buf->uv_stride,
      cm->width, cm->height);
#if 0
  int ref_frame;
  printf("get_ref_frame_map_idx: [");
  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame)
    printf(" %d", get_ref_frame_map_idx(cm, ref_frame));
  printf(" ]\n");
#endif  // 0

  // --- Y ---
  for (h = 0; h < cm->height; ++h) {
    fwrite(&recon_buf->y_buffer[h * recon_buf->y_stride], 1, cm->width,
           f_recon);
  }
  // --- U ---
  for (h = 0; h < (cm->height >> 1); ++h) {
    fwrite(&recon_buf->u_buffer[h * recon_buf->uv_stride], 1, (cm->width >> 1),
           f_recon);
  }
  // --- V ---
  for (h = 0; h < (cm->height >> 1); ++h) {
    fwrite(&recon_buf->v_buffer[h * recon_buf->uv_stride], 1, (cm->width >> 1),
           f_recon);
  }

  fclose(f_recon);
}
#endif  // DUMP_RECON_FRAMES

static int is_integer_mv(const YV12_BUFFER_CONFIG *cur_picture,
                         const YV12_BUFFER_CONFIG *last_picture,
                         ForceIntegerMVInfo *const force_intpel_info) {
  aom_clear_system_state();
  // check use hash ME
  int k;

  const int block_size = FORCE_INT_MV_DECISION_BLOCK_SIZE;
  const double threshold_current = 0.8;
  const double threshold_average = 0.95;
  const int max_history_size = 32;
  int T = 0;  // total block
  int C = 0;  // match with collocated block
  int S = 0;  // smooth region but not match with collocated block

  const int pic_width = cur_picture->y_width;
  const int pic_height = cur_picture->y_height;
  for (int i = 0; i + block_size <= pic_height; i += block_size) {
    for (int j = 0; j + block_size <= pic_width; j += block_size) {
      const int x_pos = j;
      const int y_pos = i;
      int match = 1;
      T++;

      // check whether collocated block match with current
      uint8_t *p_cur = cur_picture->y_buffer;
      uint8_t *p_ref = last_picture->y_buffer;
      int stride_cur = cur_picture->y_stride;
      int stride_ref = last_picture->y_stride;
      p_cur += (y_pos * stride_cur + x_pos);
      p_ref += (y_pos * stride_ref + x_pos);

      if (cur_picture->flags & YV12_FLAG_HIGHBITDEPTH) {
        uint16_t *p16_cur = CONVERT_TO_SHORTPTR(p_cur);
        uint16_t *p16_ref = CONVERT_TO_SHORTPTR(p_ref);
        for (int tmpY = 0; tmpY < block_size && match; tmpY++) {
          for (int tmpX = 0; tmpX < block_size && match; tmpX++) {
            if (p16_cur[tmpX] != p16_ref[tmpX]) {
              match = 0;
            }
          }
          p16_cur += stride_cur;
          p16_ref += stride_ref;
        }
      } else {
        for (int tmpY = 0; tmpY < block_size && match; tmpY++) {
          for (int tmpX = 0; tmpX < block_size && match; tmpX++) {
            if (p_cur[tmpX] != p_ref[tmpX]) {
              match = 0;
            }
          }
          p_cur += stride_cur;
          p_ref += stride_ref;
        }
      }

      if (match) {
        C++;
        continue;
      }

      if (av1_hash_is_horizontal_perfect(cur_picture, block_size, x_pos,
                                         y_pos) ||
          av1_hash_is_vertical_perfect(cur_picture, block_size, x_pos, y_pos)) {
        S++;
        continue;
      }
    }
  }

  assert(T > 0);
  double cs_rate = ((double)(C + S)) / ((double)(T));

  force_intpel_info->cs_rate_array[force_intpel_info->rate_index] = cs_rate;

  force_intpel_info->rate_index =
      (force_intpel_info->rate_index + 1) % max_history_size;
  force_intpel_info->rate_size++;
  force_intpel_info->rate_size =
      AOMMIN(force_intpel_info->rate_size, max_history_size);

  if (cs_rate < threshold_current) {
    return 0;
  }

  if (C == T) {
    return 1;
  }

  double cs_average = 0.0;

  for (k = 0; k < force_intpel_info->rate_size; k++) {
    cs_average += force_intpel_info->cs_rate_array[k];
  }
  cs_average /= force_intpel_info->rate_size;

  if (cs_average < threshold_average) {
    return 0;
  }

  if ((T - C - S) < 0) {
    return 1;
  }

  if (cs_average > 1.01) {
    return 1;
  }

  return 0;
}

// Refresh reference frame buffers according to refresh_frame_flags.
static void refresh_reference_frames(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  // All buffers are refreshed for shown keyframes and S-frames.

  for (int ref_frame = 0; ref_frame < REF_FRAMES; ref_frame++) {
    if (((cm->current_frame.refresh_frame_flags >> ref_frame) & 1) == 1) {
      assign_frame_buffer_p(&cm->ref_frame_map[ref_frame], cm->cur_frame);
    }
  }
}

static void set_mb_ssim_rdmult_scaling(AV1_COMP *cpi) {
  const CommonModeInfoParams *const mi_params = &cpi->common.mi_params;
  ThreadData *td = &cpi->td;
  MACROBLOCK *x = &td->mb;
  MACROBLOCKD *xd = &x->e_mbd;
  uint8_t *y_buffer = cpi->source->y_buffer;
  const int y_stride = cpi->source->y_stride;
  const int block_size = BLOCK_16X16;

  const int num_mi_w = mi_size_wide[block_size];
  const int num_mi_h = mi_size_high[block_size];
  const int num_cols = (mi_params->mi_cols + num_mi_w - 1) / num_mi_w;
  const int num_rows = (mi_params->mi_rows + num_mi_h - 1) / num_mi_h;
  double log_sum = 0.0;
  const int use_hbd = cpi->source->flags & YV12_FLAG_HIGHBITDEPTH;

  // Loop through each 16x16 block.
  for (int row = 0; row < num_rows; ++row) {
    for (int col = 0; col < num_cols; ++col) {
      double var = 0.0, num_of_var = 0.0;
      const int index = row * num_cols + col;

      // Loop through each 8x8 block.
      for (int mi_row = row * num_mi_h;
           mi_row < mi_params->mi_rows && mi_row < (row + 1) * num_mi_h;
           mi_row += 2) {
        for (int mi_col = col * num_mi_w;
             mi_col < mi_params->mi_cols && mi_col < (col + 1) * num_mi_w;
             mi_col += 2) {
          struct buf_2d buf;
          const int row_offset_y = mi_row << 2;
          const int col_offset_y = mi_col << 2;

          buf.buf = y_buffer + row_offset_y * y_stride + col_offset_y;
          buf.stride = y_stride;

          if (use_hbd) {
            var += av1_high_get_sby_perpixel_variance(cpi, &buf, BLOCK_8X8,
                                                      xd->bd);
          } else {
            var += av1_get_sby_perpixel_variance(cpi, &buf, BLOCK_8X8);
          }

          num_of_var += 1.0;
        }
      }
      var = var / num_of_var;

      // Curve fitting with an exponential model on all 16x16 blocks from the
      // midres dataset.
      var = 67.035434 * (1 - exp(-0.0021489 * var)) + 17.492222;
      cpi->ssim_rdmult_scaling_factors[index] = var;
      log_sum += log(var);
    }
  }
  log_sum = exp(log_sum / (double)(num_rows * num_cols));

  for (int row = 0; row < num_rows; ++row) {
    for (int col = 0; col < num_cols; ++col) {
      const int index = row * num_cols + col;
      cpi->ssim_rdmult_scaling_factors[index] /= log_sum;
    }
  }
}

extern void av1_print_frame_contexts(const FRAME_CONTEXT *fc,
                                     const char *filename);

static int encode_frame_to_data_rate(AV1_COMP *cpi, size_t *size,
                                     uint8_t *dest) {
  AV1_COMMON *const cm = &cpi->common;
  SequenceHeader *const seq_params = &cm->seq_params;
  CurrentFrame *const current_frame = &cm->current_frame;
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  struct segmentation *const seg = &cm->seg;
  FeatureFlags *const features = &cm->features;

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, encode_frame_to_data_rate_time);
#endif

  // frame type has been decided outside of this function call
  cm->cur_frame->frame_type = current_frame->frame_type;

  cm->tiles.large_scale = cpi->oxcf.large_scale_tile;
  cm->tiles.single_tile_decoding = cpi->oxcf.single_tile_decoding;

  features->allow_ref_frame_mvs &= frame_might_allow_ref_frame_mvs(cm);
  // features->allow_ref_frame_mvs needs to be written into the frame header
  // while cm->tiles.large_scale is 1, therefore, "cm->tiles.large_scale=1" case
  // is separated from frame_might_allow_ref_frame_mvs().
  features->allow_ref_frame_mvs &= !cm->tiles.large_scale;

  features->allow_warped_motion =
      cpi->oxcf.allow_warped_motion && frame_might_allow_warped_motion(cm);

  cpi->last_frame_type = current_frame->frame_type;

  if (encode_show_existing_frame(cm)) {
    finalize_encoded_frame(cpi);
    // Build the bitstream
    int largest_tile_id = 0;  // Output from bitstream: unused here
    if (av1_pack_bitstream(cpi, dest, size, &largest_tile_id) != AOM_CODEC_OK)
      return AOM_CODEC_ERROR;

    if (seq_params->frame_id_numbers_present_flag &&
        current_frame->frame_type == KEY_FRAME) {
      // Displaying a forward key-frame, so reset the ref buffer IDs
      int display_frame_id = cm->ref_frame_id[cpi->existing_fb_idx_to_show];
      for (int i = 0; i < REF_FRAMES; i++)
        cm->ref_frame_id[i] = display_frame_id;
    }

    cpi->seq_params_locked = 1;

#if DUMP_RECON_FRAMES == 1
    // NOTE(zoeliu): For debug - Output the filtered reconstructed video.
    dump_filtered_recon_frames(cpi);
#endif  // DUMP_RECON_FRAMES

    // NOTE: Save the new show frame buffer index for --test-code=warn, i.e.,
    //       for the purpose to verify no mismatch between encoder and decoder.
    if (cm->show_frame) cpi->last_show_frame_buf = cm->cur_frame;

    refresh_reference_frames(cpi);

    // Since we allocate a spot for the OVERLAY frame in the gf group, we need
    // to do post-encoding update accordingly.
    if (cpi->rc.is_src_frame_alt_ref) {
      av1_set_target_rate(cpi, cm->width, cm->height);
      av1_rc_postencode_update(cpi, *size);
    }

    ++current_frame->frame_number;

    return AOM_CODEC_OK;
  }

  // Work out whether to force_integer_mv this frame
  if (!is_stat_generation_stage(cpi) &&
      cpi->common.features.allow_screen_content_tools &&
      !frame_is_intra_only(cm)) {
    if (cpi->common.seq_params.force_integer_mv == 2) {
      // Adaptive mode: see what previous frame encoded did
      if (cpi->unscaled_last_source != NULL) {
        features->cur_frame_force_integer_mv = is_integer_mv(
            cpi->source, cpi->unscaled_last_source, &cpi->force_intpel_info);
      } else {
        cpi->common.features.cur_frame_force_integer_mv = 0;
      }
    } else {
      cpi->common.features.cur_frame_force_integer_mv =
          cpi->common.seq_params.force_integer_mv;
    }
  } else {
    cpi->common.features.cur_frame_force_integer_mv = 0;
  }

  // Set default state for segment based loop filter update flags.
  cm->lf.mode_ref_delta_update = 0;

  // Set various flags etc to special state if it is a key frame.
  if (frame_is_intra_only(cm) || frame_is_sframe(cm)) {
    // Reset the loop filter deltas and segmentation map.
    av1_reset_segment_features(cm);

    // If segmentation is enabled force a map update for key frames.
    if (seg->enabled) {
      seg->update_map = 1;
      seg->update_data = 1;
    }

    // The alternate reference frame cannot be active for a key frame.
    cpi->rc.source_alt_ref_active = 0;
  }
  if (cpi->oxcf.mtu == 0) {
    cpi->num_tg = cpi->oxcf.num_tile_groups;
  } else {
    // Use a default value for the purposes of weighting costs in probability
    // updates
    cpi->num_tg = DEFAULT_MAX_NUM_TG;
  }

  // For 1 pass CBR, check if we are dropping this frame.
  // Never drop on key frame.
  if (has_no_stats_stage(cpi) && oxcf->rc_mode == AOM_CBR &&
      current_frame->frame_type != KEY_FRAME) {
    if (av1_rc_drop_frame(cpi)) {
      av1_setup_frame_size(cpi);
      av1_rc_postencode_update_drop_frame(cpi);
      release_scaled_references(cpi);
      return AOM_CODEC_OK;
    }
  }

  if (oxcf->tuning == AOM_TUNE_SSIM) set_mb_ssim_rdmult_scaling(cpi);

#if CONFIG_TUNE_VMAF
  if (oxcf->tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
      oxcf->tuning == AOM_TUNE_VMAF_MAX_GAIN) {
    av1_set_mb_vmaf_rdmult_scaling(cpi);
  }
#endif

  aom_clear_system_state();

#if CONFIG_INTERNAL_STATS
  memset(cpi->mode_chosen_counts, 0,
         MAX_MODES * sizeof(*cpi->mode_chosen_counts));
#endif

  if (seq_params->frame_id_numbers_present_flag) {
    /* Non-normative definition of current_frame_id ("frame counter" with
     * wraparound) */
    if (cm->current_frame_id == -1) {
      int lsb, msb;
      /* quasi-random initialization of current_frame_id for a key frame */
      if (cpi->source->flags & YV12_FLAG_HIGHBITDEPTH) {
        lsb = CONVERT_TO_SHORTPTR(cpi->source->y_buffer)[0] & 0xff;
        msb = CONVERT_TO_SHORTPTR(cpi->source->y_buffer)[1] & 0xff;
      } else {
        lsb = cpi->source->y_buffer[0] & 0xff;
        msb = cpi->source->y_buffer[1] & 0xff;
      }
      cm->current_frame_id =
          ((msb << 8) + lsb) % (1 << seq_params->frame_id_length);

      // S_frame is meant for stitching different streams of different
      // resolutions together, so current_frame_id must be the
      // same across different streams of the same content current_frame_id
      // should be the same and not random. 0x37 is a chosen number as start
      // point
      if (cpi->oxcf.sframe_enabled) cm->current_frame_id = 0x37;
    } else {
      cm->current_frame_id =
          (cm->current_frame_id + 1 + (1 << seq_params->frame_id_length)) %
          (1 << seq_params->frame_id_length);
    }
  }

  switch (cpi->oxcf.cdf_update_mode) {
    case 0:  // No CDF update for any frames(4~6% compression loss).
      features->disable_cdf_update = 1;
      break;
    case 1:  // Enable CDF update for all frames.
      features->disable_cdf_update = 0;
      break;
    case 2:
      // Strategically determine at which frames to do CDF update.
      // Currently only enable CDF update for all-intra and no-show frames(1.5%
      // compression loss).
      // TODO(huisu@google.com): design schemes for various trade-offs between
      // compression quality and decoding speed.
      features->disable_cdf_update =
          (frame_is_intra_only(cm) || !cm->show_frame) ? 0 : 1;
      break;
  }
  seq_params->timing_info_present &= !seq_params->reduced_still_picture_hdr;

  int largest_tile_id = 0;
#if CONFIG_SUPERRES_IN_RECODE
  if (superres_in_recode_allowed(cpi)) {
    if (encode_with_and_without_superres(cpi, size, dest, &largest_tile_id) !=
        AOM_CODEC_OK) {
      return AOM_CODEC_ERROR;
    }
  } else {
#endif  // CONFIG_SUPERRES_IN_RECODE
    if (encode_with_recode_loop_and_filter(cpi, size, dest, NULL, NULL,
                                           &largest_tile_id) != AOM_CODEC_OK) {
      return AOM_CODEC_ERROR;
    }
#if CONFIG_SUPERRES_IN_RECODE
  }
#endif  // CONFIG_SUPERRES_IN_RECODE

  cpi->seq_params_locked = 1;

  // Update reference frame ids for reference frames this frame will overwrite
  if (seq_params->frame_id_numbers_present_flag) {
    for (int i = 0; i < REF_FRAMES; i++) {
      if ((current_frame->refresh_frame_flags >> i) & 1) {
        cm->ref_frame_id[i] = cm->current_frame_id;
      }
    }
  }

#if DUMP_RECON_FRAMES == 1
  // NOTE(zoeliu): For debug - Output the filtered reconstructed video.
  dump_filtered_recon_frames(cpi);
#endif  // DUMP_RECON_FRAMES

  if (cm->seg.enabled) {
    if (cm->seg.update_map) {
      update_reference_segmentation_map(cpi);
    } else if (cm->last_frame_seg_map) {
      memcpy(cm->cur_frame->seg_map, cm->last_frame_seg_map,
             cm->mi_params.mi_cols * cm->mi_params.mi_rows * sizeof(uint8_t));
    }
  }

  if (frame_is_intra_only(cm) == 0) {
    release_scaled_references(cpi);
  }

  // NOTE: Save the new show frame buffer index for --test-code=warn, i.e.,
  //       for the purpose to verify no mismatch between encoder and decoder.
  if (cm->show_frame) cpi->last_show_frame_buf = cm->cur_frame;

  refresh_reference_frames(cpi);

#if CONFIG_ENTROPY_STATS
  av1_accumulate_frame_counts(&aggregate_fc, &cpi->counts);
#endif  // CONFIG_ENTROPY_STATS

  if (features->refresh_frame_context == REFRESH_FRAME_CONTEXT_BACKWARD) {
    *cm->fc = cpi->tile_data[largest_tile_id].tctx;
    av1_reset_cdf_symbol_counters(cm->fc);
  }
  if (!cm->tiles.large_scale) {
    cm->cur_frame->frame_context = *cm->fc;
  }

  if (cpi->oxcf.ext_tile_debug) {
    // (yunqing) This test ensures the correctness of large scale tile coding.
    if (cm->tiles.large_scale && is_stat_consumption_stage(cpi)) {
      char fn[20] = "./fc";
      fn[4] = current_frame->frame_number / 100 + '0';
      fn[5] = (current_frame->frame_number % 100) / 10 + '0';
      fn[6] = (current_frame->frame_number % 10) + '0';
      fn[7] = '\0';
      av1_print_frame_contexts(cm->fc, fn);
    }
  }

#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, encode_frame_to_data_rate_time);

  // Print out timing information.
  int i;
  fprintf(stderr, "\n Frame number: %d, Frame type: %s, Show Frame: %d\n",
          cm->current_frame.frame_number,
          get_frame_type_enum(cm->current_frame.frame_type), cm->show_frame);
  for (i = 0; i < kTimingComponents; i++) {
    cpi->component_time[i] += cpi->frame_component_time[i];
    fprintf(stderr, " %s:  %" PRId64 " us (total: %" PRId64 " us)\n",
            get_component_name(i), cpi->frame_component_time[i],
            cpi->component_time[i]);
    cpi->frame_component_time[i] = 0;
  }
#endif

  cpi->last_frame_type = current_frame->frame_type;

  av1_rc_postencode_update(cpi, *size);

  // Clear the one shot update flags for segmentation map and mode/ref loop
  // filter deltas.
  cm->seg.update_map = 0;
  cm->seg.update_data = 0;
  cm->lf.mode_ref_delta_update = 0;

  // A droppable frame might not be shown but it always
  // takes a space in the gf group. Therefore, even when
  // it is not shown, we still need update the count down.

  if (cm->show_frame) {
    // Don't increment frame counters if this was an altref buffer
    // update not a real frame
    ++current_frame->frame_number;
  }

  return AOM_CODEC_OK;
}

int av1_encode(AV1_COMP *const cpi, uint8_t *const dest,
               const EncodeFrameInput *const frame_input,
               const EncodeFrameParams *const frame_params,
               EncodeFrameResults *const frame_results) {
  AV1_COMMON *const cm = &cpi->common;
  CurrentFrame *const current_frame = &cm->current_frame;

  cpi->unscaled_source = frame_input->source;
  cpi->source = frame_input->source;
  cpi->unscaled_last_source = frame_input->last_source;

  current_frame->refresh_frame_flags = frame_params->refresh_frame_flags;
  cm->features.error_resilient_mode = frame_params->error_resilient_mode;
  cm->features.primary_ref_frame = frame_params->primary_ref_frame;
  cm->current_frame.frame_type = frame_params->frame_type;
  cm->show_frame = frame_params->show_frame;
  cpi->ref_frame_flags = frame_params->ref_frame_flags;
  cpi->speed = frame_params->speed;
  cm->show_existing_frame = frame_params->show_existing_frame;
  cpi->existing_fb_idx_to_show = frame_params->existing_fb_idx_to_show;

  memcpy(cm->remapped_ref_idx, frame_params->remapped_ref_idx,
         REF_FRAMES * sizeof(*cm->remapped_ref_idx));

  cpi->refresh_golden_frame = frame_params->refresh_golden_frame;
  cpi->refresh_bwd_ref_frame = frame_params->refresh_bwd_ref_frame;
  cpi->refresh_alt_ref_frame = frame_params->refresh_alt_ref_frame;

  if (current_frame->frame_type == KEY_FRAME && cm->show_frame)
    current_frame->frame_number = 0;

  current_frame->order_hint =
      current_frame->frame_number + frame_params->order_offset;
  current_frame->display_order_hint = current_frame->order_hint;
  current_frame->order_hint %=
      (1 << (cm->seq_params.order_hint_info.order_hint_bits_minus_1 + 1));

  if (is_stat_generation_stage(cpi)) {
#if !CONFIG_REALTIME_ONLY
    av1_first_pass(cpi, frame_input->ts_duration);
#endif
  } else if (cpi->oxcf.pass == 0 || cpi->oxcf.pass == 2) {
    if (encode_frame_to_data_rate(cpi, &frame_results->size, dest) !=
        AOM_CODEC_OK) {
      return AOM_CODEC_ERROR;
    }
  } else {
    return AOM_CODEC_ERROR;
  }

  return AOM_CODEC_OK;
}

#if CONFIG_DENOISE
static int apply_denoise_2d(AV1_COMP *cpi, YV12_BUFFER_CONFIG *sd,
                            int block_size, float noise_level,
                            int64_t time_stamp, int64_t end_time) {
  AV1_COMMON *const cm = &cpi->common;
  if (!cpi->denoise_and_model) {
    cpi->denoise_and_model = aom_denoise_and_model_alloc(
        cm->seq_params.bit_depth, block_size, noise_level);
    if (!cpi->denoise_and_model) {
      aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                         "Error allocating denoise and model");
      return -1;
    }
  }
  if (!cpi->film_grain_table) {
    cpi->film_grain_table = aom_malloc(sizeof(*cpi->film_grain_table));
    if (!cpi->film_grain_table) {
      aom_internal_error(&cm->error, AOM_CODEC_MEM_ERROR,
                         "Error allocating grain table");
      return -1;
    }
    memset(cpi->film_grain_table, 0, sizeof(*cpi->film_grain_table));
  }
  if (aom_denoise_and_model_run(cpi->denoise_and_model, sd,
                                &cm->film_grain_params)) {
    if (cm->film_grain_params.apply_grain) {
      aom_film_grain_table_append(cpi->film_grain_table, time_stamp, end_time,
                                  &cm->film_grain_params);
    }
  }
  return 0;
}
#endif

int av1_receive_raw_frame(AV1_COMP *cpi, aom_enc_frame_flags_t frame_flags,
                          YV12_BUFFER_CONFIG *sd, int64_t time_stamp,
                          int64_t end_time) {
  AV1_COMMON *const cm = &cpi->common;
  const SequenceHeader *const seq_params = &cm->seq_params;
  int res = 0;
  const int subsampling_x = sd->subsampling_x;
  const int subsampling_y = sd->subsampling_y;
  const int use_highbitdepth = (sd->flags & YV12_FLAG_HIGHBITDEPTH) != 0;

#if CONFIG_TUNE_VMAF
  if (!is_stat_generation_stage(cpi) &&
      cpi->oxcf.tuning == AOM_TUNE_VMAF_WITH_PREPROCESSING) {
    av1_vmaf_frame_preprocessing(cpi, sd);
  }
  if (!is_stat_generation_stage(cpi) &&
      cpi->oxcf.tuning == AOM_TUNE_VMAF_MAX_GAIN) {
    av1_vmaf_blk_preprocessing(cpi, sd);
  }
#endif

#if CONFIG_INTERNAL_STATS
  struct aom_usec_timer timer;
  aom_usec_timer_start(&timer);
#endif
#if CONFIG_DENOISE
  if (cpi->oxcf.noise_level > 0)
    if (apply_denoise_2d(cpi, sd, cpi->oxcf.noise_block_size,
                         cpi->oxcf.noise_level, time_stamp, end_time) < 0)
      res = -1;
#endif  //  CONFIG_DENOISE

  if (av1_lookahead_push(cpi->lookahead, sd, time_stamp, end_time,
                         use_highbitdepth, frame_flags))
    res = -1;
#if CONFIG_INTERNAL_STATS
  aom_usec_timer_mark(&timer);
  cpi->time_receive_data += aom_usec_timer_elapsed(&timer);
#endif
  if ((seq_params->profile == PROFILE_0) && !seq_params->monochrome &&
      (subsampling_x != 1 || subsampling_y != 1)) {
    aom_internal_error(&cm->error, AOM_CODEC_INVALID_PARAM,
                       "Non-4:2:0 color format requires profile 1 or 2");
    res = -1;
  }
  if ((seq_params->profile == PROFILE_1) &&
      !(subsampling_x == 0 && subsampling_y == 0)) {
    aom_internal_error(&cm->error, AOM_CODEC_INVALID_PARAM,
                       "Profile 1 requires 4:4:4 color format");
    res = -1;
  }
  if ((seq_params->profile == PROFILE_2) &&
      (seq_params->bit_depth <= AOM_BITS_10) &&
      !(subsampling_x == 1 && subsampling_y == 0)) {
    aom_internal_error(&cm->error, AOM_CODEC_INVALID_PARAM,
                       "Profile 2 bit-depth < 10 requires 4:2:2 color format");
    res = -1;
  }

  return res;
}

#if CONFIG_INTERNAL_STATS
extern double av1_get_blockiness(const unsigned char *img1, int img1_pitch,
                                 const unsigned char *img2, int img2_pitch,
                                 int width, int height);

static void adjust_image_stat(double y, double u, double v, double all,
                              ImageStat *s) {
  s->stat[STAT_Y] += y;
  s->stat[STAT_U] += u;
  s->stat[STAT_V] += v;
  s->stat[STAT_ALL] += all;
  s->worst = AOMMIN(s->worst, all);
}

static void compute_internal_stats(AV1_COMP *cpi, int frame_bytes) {
  AV1_COMMON *const cm = &cpi->common;
  double samples = 0.0;
  const uint32_t in_bit_depth = cpi->oxcf.input_bit_depth;
  const uint32_t bit_depth = cpi->td.mb.e_mbd.bd;

#if CONFIG_INTER_STATS_ONLY
  if (cm->current_frame.frame_type == KEY_FRAME) return;  // skip key frame
#endif
  cpi->bytes += frame_bytes;
  if (cm->show_frame) {
    const YV12_BUFFER_CONFIG *orig = cpi->source;
    const YV12_BUFFER_CONFIG *recon = &cpi->common.cur_frame->buf;
    double y, u, v, frame_all;

    cpi->count++;
    if (cpi->b_calculate_psnr) {
      PSNR_STATS psnr;
      double frame_ssim2 = 0.0, weight = 0.0;
      aom_clear_system_state();
#if CONFIG_AV1_HIGHBITDEPTH
      aom_calc_highbd_psnr(orig, recon, &psnr, bit_depth, in_bit_depth);
#else
      aom_calc_psnr(orig, recon, &psnr);
#endif
      adjust_image_stat(psnr.psnr[1], psnr.psnr[2], psnr.psnr[3], psnr.psnr[0],
                        &cpi->psnr);
      cpi->total_sq_error += psnr.sse[0];
      cpi->total_samples += psnr.samples[0];
      samples = psnr.samples[0];
      // TODO(yaowu): unify these two versions into one.
      if (cm->seq_params.use_highbitdepth)
        frame_ssim2 =
            aom_highbd_calc_ssim(orig, recon, &weight, bit_depth, in_bit_depth);
      else
        frame_ssim2 = aom_calc_ssim(orig, recon, &weight);

      cpi->worst_ssim = AOMMIN(cpi->worst_ssim, frame_ssim2);
      cpi->summed_quality += frame_ssim2 * weight;
      cpi->summed_weights += weight;

#if 0
      {
        FILE *f = fopen("q_used.stt", "a");
        double y2 = psnr.psnr[1];
        double u2 = psnr.psnr[2];
        double v2 = psnr.psnr[3];
        double frame_psnr2 = psnr.psnr[0];
        fprintf(f, "%5d : Y%f7.3:U%f7.3:V%f7.3:F%f7.3:S%7.3f\n",
                cm->current_frame.frame_number, y2, u2, v2,
                frame_psnr2, frame_ssim2);
        fclose(f);
      }
#endif
    }
    if (cpi->b_calculate_blockiness) {
      if (!cm->seq_params.use_highbitdepth) {
        const double frame_blockiness =
            av1_get_blockiness(orig->y_buffer, orig->y_stride, recon->y_buffer,
                               recon->y_stride, orig->y_width, orig->y_height);
        cpi->worst_blockiness = AOMMAX(cpi->worst_blockiness, frame_blockiness);
        cpi->total_blockiness += frame_blockiness;
      }

      if (cpi->b_calculate_consistency) {
        if (!cm->seq_params.use_highbitdepth) {
          const double this_inconsistency = aom_get_ssim_metrics(
              orig->y_buffer, orig->y_stride, recon->y_buffer, recon->y_stride,
              orig->y_width, orig->y_height, cpi->ssim_vars, &cpi->metrics, 1);

          const double peak = (double)((1 << in_bit_depth) - 1);
          const double consistency =
              aom_sse_to_psnr(samples, peak, cpi->total_inconsistency);
          if (consistency > 0.0)
            cpi->worst_consistency =
                AOMMIN(cpi->worst_consistency, consistency);
          cpi->total_inconsistency += this_inconsistency;
        }
      }
    }

    frame_all =
        aom_calc_fastssim(orig, recon, &y, &u, &v, bit_depth, in_bit_depth);
    adjust_image_stat(y, u, v, frame_all, &cpi->fastssim);
    frame_all = aom_psnrhvs(orig, recon, &y, &u, &v, bit_depth, in_bit_depth);
    adjust_image_stat(y, u, v, frame_all, &cpi->psnrhvs);
  }
}
#endif  // CONFIG_INTERNAL_STATS
int av1_get_compressed_data(AV1_COMP *cpi, unsigned int *frame_flags,
                            size_t *size, uint8_t *dest, int64_t *time_stamp,
                            int64_t *time_end, int flush,
                            const aom_rational64_t *timestamp_ratio) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  AV1_COMMON *const cm = &cpi->common;

#if CONFIG_BITSTREAM_DEBUG
  assert(cpi->oxcf.max_threads == 0 &&
         "bitstream debug tool does not support multithreading");
  bitstream_queue_record_write();
  aom_bitstream_queue_set_frame_write(cm->current_frame.frame_number * 2 +
                                      cm->show_frame);
#endif
  if (cpi->use_svc && cm->number_spatial_layers > 1) {
    av1_one_pass_cbr_svc_start_layer(cpi);
  }

  cm->showable_frame = 0;
  *size = 0;
#if CONFIG_INTERNAL_STATS
  struct aom_usec_timer cmptimer;
  aom_usec_timer_start(&cmptimer);
#endif
  av1_set_high_precision_mv(cpi, 1, 0);

  // Normal defaults
  cm->features.refresh_frame_context = oxcf->frame_parallel_decoding_mode
                                           ? REFRESH_FRAME_CONTEXT_DISABLED
                                           : REFRESH_FRAME_CONTEXT_BACKWARD;
  if (oxcf->large_scale_tile)
    cm->features.refresh_frame_context = REFRESH_FRAME_CONTEXT_DISABLED;

  // Initialize fields related to forward keyframes
  cpi->no_show_kf = 0;

  if (assign_cur_frame_new_fb(cm) == NULL) return AOM_CODEC_ERROR;

  const int result =
      av1_encode_strategy(cpi, size, dest, frame_flags, time_stamp, time_end,
                          timestamp_ratio, flush);
  if (result != AOM_CODEC_OK && result != -1) {
    return AOM_CODEC_ERROR;
  } else if (result == -1) {
    // Returning -1 indicates no frame encoded; more input is required
    return -1;
  }
#if CONFIG_INTERNAL_STATS
  aom_usec_timer_mark(&cmptimer);
  cpi->time_compress_data += aom_usec_timer_elapsed(&cmptimer);
#endif  // CONFIG_INTERNAL_STATS
  if (cpi->b_calculate_psnr) {
    if (cm->show_existing_frame ||
        (!is_stat_generation_stage(cpi) && cm->show_frame)) {
      generate_psnr_packet(cpi);
    }
  }

#if CONFIG_TUNE_VMAF
  if (!is_stat_generation_stage(cpi) &&
      (oxcf->tuning == AOM_TUNE_VMAF_WITH_PREPROCESSING ||
       oxcf->tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
       oxcf->tuning == AOM_TUNE_VMAF_MAX_GAIN)) {
    av1_update_vmaf_curve(cpi, cpi->source, &cpi->common.cur_frame->buf);
  }
#endif

  if (cpi->level_params.keep_level_stats && !is_stat_generation_stage(cpi)) {
    // Initialize level info. at the beginning of each sequence.
    if (cm->current_frame.frame_type == KEY_FRAME && cm->show_frame) {
      av1_init_level_info(cpi);
    }
    av1_update_level_info(cpi, *size, *time_stamp, *time_end);
  }

#if CONFIG_INTERNAL_STATS
  if (!is_stat_generation_stage(cpi)) {
    compute_internal_stats(cpi, (int)(*size));
  }
#endif  // CONFIG_INTERNAL_STATS
#if CONFIG_SPEED_STATS
  if (!is_stat_generation_stage(cpi) && !cm->show_existing_frame) {
    cpi->tx_search_count += cpi->td.mb.tx_search_count;
    cpi->td.mb.tx_search_count = 0;
  }
#endif  // CONFIG_SPEED_STATS

  aom_clear_system_state();

  return AOM_CODEC_OK;
}

int av1_get_preview_raw_frame(AV1_COMP *cpi, YV12_BUFFER_CONFIG *dest) {
  AV1_COMMON *cm = &cpi->common;
  if (!cm->show_frame) {
    return -1;
  } else {
    int ret;
    if (cm->cur_frame != NULL) {
      *dest = cm->cur_frame->buf;
      dest->y_width = cm->width;
      dest->y_height = cm->height;
      dest->uv_width = cm->width >> cm->seq_params.subsampling_x;
      dest->uv_height = cm->height >> cm->seq_params.subsampling_y;
      ret = 0;
    } else {
      ret = -1;
    }
    aom_clear_system_state();
    return ret;
  }
}

int av1_get_last_show_frame(AV1_COMP *cpi, YV12_BUFFER_CONFIG *frame) {
  if (cpi->last_show_frame_buf == NULL) return -1;

  *frame = cpi->last_show_frame_buf->buf;
  return 0;
}

static int equal_dimensions_and_border(const YV12_BUFFER_CONFIG *a,
                                       const YV12_BUFFER_CONFIG *b) {
  return a->y_height == b->y_height && a->y_width == b->y_width &&
         a->uv_height == b->uv_height && a->uv_width == b->uv_width &&
         a->y_stride == b->y_stride && a->uv_stride == b->uv_stride &&
         a->border == b->border &&
         (a->flags & YV12_FLAG_HIGHBITDEPTH) ==
             (b->flags & YV12_FLAG_HIGHBITDEPTH);
}

aom_codec_err_t av1_copy_new_frame_enc(AV1_COMMON *cm,
                                       YV12_BUFFER_CONFIG *new_frame,
                                       YV12_BUFFER_CONFIG *sd) {
  const int num_planes = av1_num_planes(cm);
  if (!equal_dimensions_and_border(new_frame, sd))
    aom_internal_error(&cm->error, AOM_CODEC_ERROR,
                       "Incorrect buffer dimensions");
  else
    aom_yv12_copy_frame(new_frame, sd, num_planes);

  return cm->error.error_code;
}

int av1_set_internal_size(AV1EncoderConfig *const oxcf,
                          ResizePendingParams *resize_pending_params,
                          AOM_SCALING horiz_mode, AOM_SCALING vert_mode) {
  int hr = 0, hs = 0, vr = 0, vs = 0;

  if (horiz_mode > ONETWO || vert_mode > ONETWO) return -1;

  Scale2Ratio(horiz_mode, &hr, &hs);
  Scale2Ratio(vert_mode, &vr, &vs);

  // always go to the next whole number
  resize_pending_params->width = (hs - 1 + oxcf->width * hr) / hs;
  resize_pending_params->height = (vs - 1 + oxcf->height * vr) / vs;

  return 0;
}

int av1_get_quantizer(AV1_COMP *cpi) {
  return cpi->common.quant_params.base_qindex;
}

int av1_convert_sect5obus_to_annexb(uint8_t *buffer, size_t *frame_size) {
  size_t output_size = 0;
  size_t total_bytes_read = 0;
  size_t remaining_size = *frame_size;
  uint8_t *buff_ptr = buffer;

  // go through each OBUs
  while (total_bytes_read < *frame_size) {
    uint8_t saved_obu_header[2];
    uint64_t obu_payload_size;
    size_t length_of_payload_size;
    size_t length_of_obu_size;
    uint32_t obu_header_size = (buff_ptr[0] >> 2) & 0x1 ? 2 : 1;
    size_t obu_bytes_read = obu_header_size;  // bytes read for current obu

    // save the obu header (1 or 2 bytes)
    memmove(saved_obu_header, buff_ptr, obu_header_size);
    // clear the obu_has_size_field
    saved_obu_header[0] = saved_obu_header[0] & (~0x2);

    // get the payload_size and length of payload_size
    if (aom_uleb_decode(buff_ptr + obu_header_size, remaining_size,
                        &obu_payload_size, &length_of_payload_size) != 0) {
      return AOM_CODEC_ERROR;
    }
    obu_bytes_read += length_of_payload_size;

    // calculate the length of size of the obu header plus payload
    length_of_obu_size =
        aom_uleb_size_in_bytes((uint64_t)(obu_header_size + obu_payload_size));

    // move the rest of data to new location
    memmove(buff_ptr + length_of_obu_size + obu_header_size,
            buff_ptr + obu_bytes_read, remaining_size - obu_bytes_read);
    obu_bytes_read += (size_t)obu_payload_size;

    // write the new obu size
    const uint64_t obu_size = obu_header_size + obu_payload_size;
    size_t coded_obu_size;
    if (aom_uleb_encode(obu_size, sizeof(obu_size), buff_ptr,
                        &coded_obu_size) != 0) {
      return AOM_CODEC_ERROR;
    }

    // write the saved (modified) obu_header following obu size
    memmove(buff_ptr + length_of_obu_size, saved_obu_header, obu_header_size);

    total_bytes_read += obu_bytes_read;
    remaining_size -= obu_bytes_read;
    buff_ptr += length_of_obu_size + obu_size;
    output_size += length_of_obu_size + (size_t)obu_size;
  }

  *frame_size = output_size;
  return AOM_CODEC_OK;
}

static void svc_set_updates_external_ref_frame_config(
    ExternalFlags *const ext_flags, SVC *const svc) {
  ext_flags->refresh_frame_flags_pending = 1;
  ext_flags->refresh_last_frame = svc->refresh[svc->ref_idx[0]];
  ext_flags->refresh_golden_frame = svc->refresh[svc->ref_idx[3]];
  ext_flags->refresh_bwd_ref_frame = svc->refresh[svc->ref_idx[4]];
  ext_flags->refresh_alt2_ref_frame = svc->refresh[svc->ref_idx[5]];
  ext_flags->refresh_alt_ref_frame = svc->refresh[svc->ref_idx[6]];
  svc->non_reference_frame = 1;
  for (int i = 0; i < REF_FRAMES; i++) {
    if (svc->refresh[i] == 1) {
      svc->non_reference_frame = 0;
      break;
    }
  }
}

static int svc_set_references_external_ref_frame_config(AV1_COMP *cpi) {
  // LAST_FRAME (0), LAST2_FRAME(1), LAST3_FRAME(2), GOLDEN_FRAME(3),
  // BWDREF_FRAME(4), ALTREF2_FRAME(5), ALTREF_FRAME(6).
  int ref = AOM_REFFRAME_ALL;
  for (int i = 0; i < INTER_REFS_PER_FRAME; i++) {
    if (!cpi->svc.reference[i]) ref ^= (1 << i);
  }
  return ref;
}

void av1_apply_encoding_flags(AV1_COMP *cpi, aom_enc_frame_flags_t flags) {
  // TODO(yunqingwang): For what references to use, external encoding flags
  // should be consistent with internal reference frame selection. Need to
  // ensure that there is not conflict between the two. In AV1 encoder, the
  // priority rank for 7 reference frames are: LAST, ALTREF, LAST2, LAST3,
  // GOLDEN, BWDREF, ALTREF2.

  ExternalFlags *const ext_flags = &cpi->ext_flags;
  ext_flags->ref_frame_flags = AOM_REFFRAME_ALL;
  if (flags &
      (AOM_EFLAG_NO_REF_LAST | AOM_EFLAG_NO_REF_LAST2 | AOM_EFLAG_NO_REF_LAST3 |
       AOM_EFLAG_NO_REF_GF | AOM_EFLAG_NO_REF_ARF | AOM_EFLAG_NO_REF_BWD |
       AOM_EFLAG_NO_REF_ARF2)) {
    int ref = AOM_REFFRAME_ALL;

    if (flags & AOM_EFLAG_NO_REF_LAST) ref ^= AOM_LAST_FLAG;
    if (flags & AOM_EFLAG_NO_REF_LAST2) ref ^= AOM_LAST2_FLAG;
    if (flags & AOM_EFLAG_NO_REF_LAST3) ref ^= AOM_LAST3_FLAG;

    if (flags & AOM_EFLAG_NO_REF_GF) ref ^= AOM_GOLD_FLAG;

    if (flags & AOM_EFLAG_NO_REF_ARF) {
      ref ^= AOM_ALT_FLAG;
      ref ^= AOM_BWD_FLAG;
      ref ^= AOM_ALT2_FLAG;
    } else {
      if (flags & AOM_EFLAG_NO_REF_BWD) ref ^= AOM_BWD_FLAG;
      if (flags & AOM_EFLAG_NO_REF_ARF2) ref ^= AOM_ALT2_FLAG;
    }

    av1_use_as_reference(&ext_flags->ref_frame_flags, ref);
  } else {
    if (cpi->svc.external_ref_frame_config) {
      int ref = svc_set_references_external_ref_frame_config(cpi);
      av1_use_as_reference(&ext_flags->ref_frame_flags, ref);
    }
  }

  if (flags &
      (AOM_EFLAG_NO_UPD_LAST | AOM_EFLAG_NO_UPD_GF | AOM_EFLAG_NO_UPD_ARF)) {
    int upd = AOM_REFFRAME_ALL;

    // Refreshing LAST/LAST2/LAST3 is handled by 1 common flag.
    if (flags & AOM_EFLAG_NO_UPD_LAST) upd ^= AOM_LAST_FLAG;

    if (flags & AOM_EFLAG_NO_UPD_GF) upd ^= AOM_GOLD_FLAG;

    if (flags & AOM_EFLAG_NO_UPD_ARF) {
      upd ^= AOM_ALT_FLAG;
      upd ^= AOM_BWD_FLAG;
      upd ^= AOM_ALT2_FLAG;
    }

    ext_flags->refresh_last_frame = (upd & AOM_LAST_FLAG) != 0;
    ext_flags->refresh_golden_frame = (upd & AOM_GOLD_FLAG) != 0;
    ext_flags->refresh_alt_ref_frame = (upd & AOM_ALT_FLAG) != 0;
    ext_flags->refresh_bwd_ref_frame = (upd & AOM_BWD_FLAG) != 0;
    ext_flags->refresh_alt2_ref_frame = (upd & AOM_ALT2_FLAG) != 0;
    ext_flags->refresh_frame_flags_pending = 1;
  } else {
    if (cpi->svc.external_ref_frame_config)
      svc_set_updates_external_ref_frame_config(ext_flags, &cpi->svc);
    else
      ext_flags->refresh_frame_flags_pending = 0;
  }

  ext_flags->use_ref_frame_mvs = cpi->oxcf.allow_ref_frame_mvs &
                                 ((flags & AOM_EFLAG_NO_REF_FRAME_MVS) == 0);
  ext_flags->use_error_resilient = cpi->oxcf.error_resilient_mode |
                                   ((flags & AOM_EFLAG_ERROR_RESILIENT) != 0);
  ext_flags->use_s_frame =
      cpi->oxcf.s_frame_mode | ((flags & AOM_EFLAG_SET_S_FRAME) != 0);
  ext_flags->use_primary_ref_none =
      (flags & AOM_EFLAG_SET_PRIMARY_REF_NONE) != 0;

  if (flags & AOM_EFLAG_NO_UPD_ENTROPY) {
    av1_update_entropy(&ext_flags->refresh_frame_context,
                       &ext_flags->refresh_frame_context_pending, 0);
  }
}

aom_fixed_buf_t *av1_get_global_headers(AV1_COMP *cpi) {
  if (!cpi) return NULL;

  uint8_t header_buf[512] = { 0 };
  const uint32_t sequence_header_size =
      av1_write_sequence_header_obu(&cpi->common.seq_params, &header_buf[0]);
  assert(sequence_header_size <= sizeof(header_buf));
  if (sequence_header_size == 0) return NULL;

  const size_t obu_header_size = 1;
  const size_t size_field_size = aom_uleb_size_in_bytes(sequence_header_size);
  const size_t payload_offset = obu_header_size + size_field_size;

  if (payload_offset + sequence_header_size > sizeof(header_buf)) return NULL;
  memmove(&header_buf[payload_offset], &header_buf[0], sequence_header_size);

  if (av1_write_obu_header(&cpi->level_params, OBU_SEQUENCE_HEADER, 0,
                           &header_buf[0]) != obu_header_size) {
    return NULL;
  }

  size_t coded_size_field_size = 0;
  if (aom_uleb_encode(sequence_header_size, size_field_size,
                      &header_buf[obu_header_size],
                      &coded_size_field_size) != 0) {
    return NULL;
  }
  assert(coded_size_field_size == size_field_size);

  aom_fixed_buf_t *global_headers =
      (aom_fixed_buf_t *)malloc(sizeof(*global_headers));
  if (!global_headers) return NULL;

  const size_t global_header_buf_size =
      obu_header_size + size_field_size + sequence_header_size;

  global_headers->buf = malloc(global_header_buf_size);
  if (!global_headers->buf) {
    free(global_headers);
    return NULL;
  }

  memcpy(global_headers->buf, &header_buf[0], global_header_buf_size);
  global_headers->sz = global_header_buf_size;
  return global_headers;
}
