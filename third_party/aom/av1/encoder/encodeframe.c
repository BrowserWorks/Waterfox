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
#include <stdbool.h>
#include <stdio.h>

#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"
#include "config/av1_rtcd.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_dsp/binary_codes_writer.h"
#include "aom_ports/mem.h"
#include "aom_ports/aom_timer.h"
#include "aom_ports/system_state.h"

#if CONFIG_MISMATCH_DEBUG
#include "aom_util/debug_util.h"
#endif  // CONFIG_MISMATCH_DEBUG

#include "av1/common/cfl.h"
#include "av1/common/common.h"
#include "av1/common/entropy.h"
#include "av1/common/entropymode.h"
#include "av1/common/idct.h"
#include "av1/common/mv.h"
#include "av1/common/mvref_common.h"
#include "av1/common/pred_common.h"
#include "av1/common/quant_common.h"
#include "av1/common/reconintra.h"
#include "av1/common/reconinter.h"
#include "av1/common/seg_common.h"
#include "av1/common/tile_common.h"
#include "av1/common/warped_motion.h"

#include "av1/encoder/aq_complexity.h"
#include "av1/encoder/aq_cyclicrefresh.h"
#include "av1/encoder/aq_variance.h"
#include "av1/encoder/corner_detect.h"
#include "av1/encoder/global_motion.h"
#include "av1/encoder/encodeframe.h"
#include "av1/encoder/encodemb.h"
#include "av1/encoder/encodemv.h"
#include "av1/encoder/encodetxb.h"
#include "av1/encoder/ethread.h"
#include "av1/encoder/extend.h"
#include "av1/encoder/ml.h"
#include "av1/encoder/motion_search_facade.h"
#include "av1/encoder/partition_strategy.h"
#if !CONFIG_REALTIME_ONLY
#include "av1/encoder/partition_model_weights.h"
#endif
#include "av1/encoder/rd.h"
#include "av1/encoder/rdopt.h"
#include "av1/encoder/reconinter_enc.h"
#include "av1/encoder/segmentation.h"
#include "av1/encoder/tokenize.h"
#include "av1/encoder/tpl_model.h"
#include "av1/encoder/var_based_part.h"

#if CONFIG_TUNE_VMAF
#include "av1/encoder/tune_vmaf.h"
#endif

static AOM_INLINE void encode_superblock(const AV1_COMP *const cpi,
                                         TileDataEnc *tile_data, ThreadData *td,
                                         TOKENEXTRA **t, RUN_TYPE dry_run,
                                         BLOCK_SIZE bsize, int *rate);

// This is used as a reference when computing the source variance for the
//  purposes of activity masking.
// Eventually this should be replaced by custom no-reference routines,
//  which will be faster.
const uint8_t AV1_VAR_OFFS[MAX_SB_SIZE] = {
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128
};

static const uint16_t AV1_HIGH_VAR_OFFS_8[MAX_SB_SIZE] = {
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
  128, 128, 128, 128, 128, 128, 128, 128
};

static const uint16_t AV1_HIGH_VAR_OFFS_10[MAX_SB_SIZE] = {
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4,
  128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4, 128 * 4
};

static const uint16_t AV1_HIGH_VAR_OFFS_12[MAX_SB_SIZE] = {
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16, 128 * 16,
  128 * 16, 128 * 16
};

typedef struct {
  ENTROPY_CONTEXT a[MAX_MIB_SIZE * MAX_MB_PLANE];
  ENTROPY_CONTEXT l[MAX_MIB_SIZE * MAX_MB_PLANE];
  PARTITION_CONTEXT sa[MAX_MIB_SIZE];
  PARTITION_CONTEXT sl[MAX_MIB_SIZE];
  TXFM_CONTEXT *p_ta;
  TXFM_CONTEXT *p_tl;
  TXFM_CONTEXT ta[MAX_MIB_SIZE];
  TXFM_CONTEXT tl[MAX_MIB_SIZE];
} RD_SEARCH_MACROBLOCK_CONTEXT;

enum { PICK_MODE_RD = 0, PICK_MODE_NONRD };

enum {
  SB_SINGLE_PASS,  // Single pass encoding: all ctxs get updated normally
  SB_DRY_PASS,     // First pass of multi-pass: does not update the ctxs
  SB_WET_PASS      // Second pass of multi-pass: finalize and update the ctx
} UENUM1BYTE(SB_MULTI_PASS_MODE);

// This struct is used to store the statistics used by sb-level multi-pass
// encoding. Currently, this is only used to make a copy of the state before we
// perform the first pass
typedef struct SB_FIRST_PASS_STATS {
  RD_SEARCH_MACROBLOCK_CONTEXT x_ctx;
  RD_COUNTS rd_count;

  int split_count;
  FRAME_COUNTS fc;
  InterModeRdModel inter_mode_rd_models[BLOCK_SIZES_ALL];
  int thresh_freq_fact[BLOCK_SIZES_ALL][MAX_MODES];
  int current_qindex;

#if CONFIG_INTERNAL_STATS
  unsigned int mode_chosen_counts[MAX_MODES];
#endif  // CONFIG_INTERNAL_STATS
} SB_FIRST_PASS_STATS;

unsigned int av1_get_sby_perpixel_variance(const AV1_COMP *cpi,
                                           const struct buf_2d *ref,
                                           BLOCK_SIZE bs) {
  unsigned int sse;
  const unsigned int var =
      cpi->fn_ptr[bs].vf(ref->buf, ref->stride, AV1_VAR_OFFS, 0, &sse);
  return ROUND_POWER_OF_TWO(var, num_pels_log2_lookup[bs]);
}

unsigned int av1_high_get_sby_perpixel_variance(const AV1_COMP *cpi,
                                                const struct buf_2d *ref,
                                                BLOCK_SIZE bs, int bd) {
  unsigned int var, sse;
  assert(bd == 8 || bd == 10 || bd == 12);
  const int off_index = (bd - 8) >> 1;
  const uint16_t *high_var_offs[3] = { AV1_HIGH_VAR_OFFS_8,
                                       AV1_HIGH_VAR_OFFS_10,
                                       AV1_HIGH_VAR_OFFS_12 };
  var =
      cpi->fn_ptr[bs].vf(ref->buf, ref->stride,
                         CONVERT_TO_BYTEPTR(high_var_offs[off_index]), 0, &sse);
  return ROUND_POWER_OF_TWO(var, num_pels_log2_lookup[bs]);
}

static unsigned int get_sby_perpixel_diff_variance(const AV1_COMP *const cpi,
                                                   const struct buf_2d *ref,
                                                   int mi_row, int mi_col,
                                                   BLOCK_SIZE bs) {
  unsigned int sse, var;
  uint8_t *last_y;
  const YV12_BUFFER_CONFIG *last =
      get_ref_frame_yv12_buf(&cpi->common, LAST_FRAME);

  assert(last != NULL);
  last_y =
      &last->y_buffer[mi_row * MI_SIZE * last->y_stride + mi_col * MI_SIZE];
  var = cpi->fn_ptr[bs].vf(ref->buf, ref->stride, last_y, last->y_stride, &sse);
  return ROUND_POWER_OF_TWO(var, num_pels_log2_lookup[bs]);
}

static BLOCK_SIZE get_rd_var_based_fixed_partition(AV1_COMP *cpi, MACROBLOCK *x,
                                                   int mi_row, int mi_col) {
  unsigned int var = get_sby_perpixel_diff_variance(
      cpi, &x->plane[0].src, mi_row, mi_col, BLOCK_64X64);
  if (var < 8)
    return BLOCK_64X64;
  else if (var < 128)
    return BLOCK_32X32;
  else if (var < 2048)
    return BLOCK_16X16;
  else
    return BLOCK_8X8;
}

static int set_deltaq_rdmult(const AV1_COMP *const cpi, MACROBLOCKD *const xd) {
  const AV1_COMMON *const cm = &cpi->common;
  const CommonQuantParams *quant_params = &cm->quant_params;
  return av1_compute_rd_mult(cpi, quant_params->base_qindex + xd->delta_qindex +
                                      quant_params->y_dc_delta_q);
}

static AOM_INLINE void set_ssim_rdmult(const AV1_COMP *const cpi,
                                       MACROBLOCK *const x,
                                       const BLOCK_SIZE bsize, const int mi_row,
                                       const int mi_col, int *const rdmult) {
  const AV1_COMMON *const cm = &cpi->common;

  const int bsize_base = BLOCK_16X16;
  const int num_mi_w = mi_size_wide[bsize_base];
  const int num_mi_h = mi_size_high[bsize_base];
  const int num_cols = (cm->mi_params.mi_cols + num_mi_w - 1) / num_mi_w;
  const int num_rows = (cm->mi_params.mi_rows + num_mi_h - 1) / num_mi_h;
  const int num_bcols = (mi_size_wide[bsize] + num_mi_w - 1) / num_mi_w;
  const int num_brows = (mi_size_high[bsize] + num_mi_h - 1) / num_mi_h;
  int row, col;
  double num_of_mi = 0.0;
  double geom_mean_of_scale = 0.0;

  assert(cpi->oxcf.tuning == AOM_TUNE_SSIM);

  aom_clear_system_state();
  for (row = mi_row / num_mi_w;
       row < num_rows && row < mi_row / num_mi_w + num_brows; ++row) {
    for (col = mi_col / num_mi_h;
         col < num_cols && col < mi_col / num_mi_h + num_bcols; ++col) {
      const int index = row * num_cols + col;
      geom_mean_of_scale += log(cpi->ssim_rdmult_scaling_factors[index]);
      num_of_mi += 1.0;
    }
  }
  geom_mean_of_scale = exp(geom_mean_of_scale / num_of_mi);

  *rdmult = (int)((double)(*rdmult) * geom_mean_of_scale + 0.5);
  *rdmult = AOMMAX(*rdmult, 0);
  set_error_per_bit(x, *rdmult);
  aom_clear_system_state();
}

static int get_hier_tpl_rdmult(const AV1_COMP *const cpi, MACROBLOCK *const x,
                               const BLOCK_SIZE bsize, const int mi_row,
                               const int mi_col, int orig_rdmult) {
  const AV1_COMMON *const cm = &cpi->common;
  assert(IMPLIES(cpi->gf_group.size > 0,
                 cpi->gf_group.index < cpi->gf_group.size));
  const int tpl_idx = cpi->gf_group.index;
  const TplDepFrame *tpl_frame = &cpi->tpl_data.tpl_frame[tpl_idx];
  MACROBLOCKD *const xd = &x->e_mbd;
  const int deltaq_rdmult = set_deltaq_rdmult(cpi, xd);
  if (tpl_frame->is_valid == 0) return deltaq_rdmult;
  if (!is_frame_tpl_eligible((AV1_COMP *)cpi)) return deltaq_rdmult;
  if (tpl_idx >= MAX_LAG_BUFFERS) return deltaq_rdmult;
  if (cpi->superres_mode != SUPERRES_NONE) return deltaq_rdmult;
  if (cpi->oxcf.aq_mode != NO_AQ) return deltaq_rdmult;

  const int bsize_base = BLOCK_16X16;
  const int num_mi_w = mi_size_wide[bsize_base];
  const int num_mi_h = mi_size_high[bsize_base];
  const int num_cols = (cm->mi_params.mi_cols + num_mi_w - 1) / num_mi_w;
  const int num_rows = (cm->mi_params.mi_rows + num_mi_h - 1) / num_mi_h;
  const int num_bcols = (mi_size_wide[bsize] + num_mi_w - 1) / num_mi_w;
  const int num_brows = (mi_size_high[bsize] + num_mi_h - 1) / num_mi_h;
  int row, col;
  double base_block_count = 0.0;
  double geom_mean_of_scale = 0.0;
  aom_clear_system_state();
  for (row = mi_row / num_mi_w;
       row < num_rows && row < mi_row / num_mi_w + num_brows; ++row) {
    for (col = mi_col / num_mi_h;
         col < num_cols && col < mi_col / num_mi_h + num_bcols; ++col) {
      const int index = row * num_cols + col;
      geom_mean_of_scale += log(cpi->tpl_sb_rdmult_scaling_factors[index]);
      base_block_count += 1.0;
    }
  }
  geom_mean_of_scale = exp(geom_mean_of_scale / base_block_count);
  int rdmult = (int)((double)orig_rdmult * geom_mean_of_scale + 0.5);
  rdmult = AOMMAX(rdmult, 0);
  set_error_per_bit(x, rdmult);
  aom_clear_system_state();
  if (bsize == cm->seq_params.sb_size) {
    const int rdmult_sb = set_deltaq_rdmult(cpi, xd);
    assert(rdmult_sb == rdmult);
    (void)rdmult_sb;
  }
  return rdmult;
}

static int set_segment_rdmult(const AV1_COMP *const cpi, MACROBLOCK *const x,
                              int8_t segment_id) {
  const AV1_COMMON *const cm = &cpi->common;
  av1_init_plane_quantizers(cpi, x, segment_id);
  aom_clear_system_state();
  const int segment_qindex =
      av1_get_qindex(&cm->seg, segment_id, cm->quant_params.base_qindex);
  return av1_compute_rd_mult(cpi,
                             segment_qindex + cm->quant_params.y_dc_delta_q);
}

static AOM_INLINE void setup_block_rdmult(const AV1_COMP *const cpi,
                                          MACROBLOCK *const x, int mi_row,
                                          int mi_col, BLOCK_SIZE bsize,
                                          AQ_MODE aq_mode, MB_MODE_INFO *mbmi) {
  x->rdmult = cpi->rd.RDMULT;

  if (aq_mode != NO_AQ) {
    assert(mbmi != NULL);
    if (aq_mode == VARIANCE_AQ) {
      if (cpi->vaq_refresh) {
        const int energy = bsize <= BLOCK_16X16
                               ? x->mb_energy
                               : av1_log_block_var(cpi, x, bsize);
        mbmi->segment_id = energy;
      }
      x->rdmult = set_segment_rdmult(cpi, x, mbmi->segment_id);
    } else if (aq_mode == COMPLEXITY_AQ) {
      x->rdmult = set_segment_rdmult(cpi, x, mbmi->segment_id);
    } else if (aq_mode == CYCLIC_REFRESH_AQ) {
      // If segment is boosted, use rdmult for that segment.
      if (cyclic_refresh_segment_id_boosted(mbmi->segment_id))
        x->rdmult = av1_cyclic_refresh_get_rdmult(cpi->cyclic_refresh);
    }
  }

  const AV1_COMMON *const cm = &cpi->common;
  if (cm->delta_q_info.delta_q_present_flag &&
      !cpi->sf.rt_sf.use_nonrd_pick_mode) {
    x->rdmult = get_hier_tpl_rdmult(cpi, x, bsize, mi_row, mi_col, x->rdmult);
  }

  if (cpi->oxcf.tuning == AOM_TUNE_SSIM) {
    set_ssim_rdmult(cpi, x, bsize, mi_row, mi_col, &x->rdmult);
  }
#if CONFIG_TUNE_VMAF
  if (cpi->oxcf.tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
      cpi->oxcf.tuning == AOM_TUNE_VMAF_MAX_GAIN) {
    av1_set_vmaf_rdmult(cpi, x, bsize, mi_row, mi_col, &x->rdmult);
  }
#endif
}

static AOM_INLINE void set_offsets_without_segment_id(
    const AV1_COMP *const cpi, const TileInfo *const tile, MACROBLOCK *const x,
    int mi_row, int mi_col, BLOCK_SIZE bsize) {
  const AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *const xd = &x->e_mbd;
  assert(bsize < BLOCK_SIZES_ALL);
  const int mi_width = mi_size_wide[bsize];
  const int mi_height = mi_size_high[bsize];

  set_mode_info_offsets(&cpi->common.mi_params, &cpi->mbmi_ext_info, x, xd,
                        mi_row, mi_col);

  set_entropy_context(xd, mi_row, mi_col, num_planes);
  xd->above_txfm_context = cm->above_contexts.txfm[tile->tile_row] + mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);

  // Set up destination pointers.
  av1_setup_dst_planes(xd->plane, bsize, &cm->cur_frame->buf, mi_row, mi_col, 0,
                       num_planes);

  // Set up limit values for MV components.
  // Mv beyond the range do not produce new/different prediction block.
  av1_set_mv_limits(&cm->mi_params, &x->mv_limits, mi_row, mi_col, mi_height,
                    mi_width, cpi->oxcf.border_in_pixels);

  set_plane_n4(xd, mi_width, mi_height, num_planes);

  // Set up distance of MB to edge of frame in 1/8th pel units.
  assert(!(mi_col & (mi_width - 1)) && !(mi_row & (mi_height - 1)));
  set_mi_row_col(xd, tile, mi_row, mi_height, mi_col, mi_width,
                 cm->mi_params.mi_rows, cm->mi_params.mi_cols);

  // Set up source buffers.
  av1_setup_src_planes(x, cpi->source, mi_row, mi_col, num_planes, bsize);

  // required by av1_append_sub8x8_mvs_for_idx() and av1_find_best_ref_mvs()
  xd->tile = *tile;
}

static AOM_INLINE void set_offsets(const AV1_COMP *const cpi,
                                   const TileInfo *const tile,
                                   MACROBLOCK *const x, int mi_row, int mi_col,
                                   BLOCK_SIZE bsize) {
  const AV1_COMMON *const cm = &cpi->common;
  const struct segmentation *const seg = &cm->seg;
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *mbmi;

  set_offsets_without_segment_id(cpi, tile, x, mi_row, mi_col, bsize);

  // Setup segment ID.
  mbmi = xd->mi[0];
  mbmi->segment_id = 0;
  if (seg->enabled) {
    if (seg->enabled && !cpi->vaq_refresh) {
      const uint8_t *const map =
          seg->update_map ? cpi->enc_seg.map : cm->last_frame_seg_map;
      mbmi->segment_id =
          map ? get_segment_id(&cm->mi_params, map, bsize, mi_row, mi_col) : 0;
    }
    av1_init_plane_quantizers(cpi, x, mbmi->segment_id);
  }
}

static AOM_INLINE void update_filter_type_count(FRAME_COUNTS *counts,
                                                const MACROBLOCKD *xd,
                                                const MB_MODE_INFO *mbmi) {
  int dir;
  for (dir = 0; dir < 2; ++dir) {
    const int ctx = av1_get_pred_context_switchable_interp(xd, dir);
    InterpFilter filter = av1_extract_interp_filter(mbmi->interp_filters, dir);
    ++counts->switchable_interp[ctx][filter];
  }
}

static AOM_INLINE void update_filter_type_cdf(const MACROBLOCKD *xd,
                                              const MB_MODE_INFO *mbmi) {
  int dir;
  for (dir = 0; dir < 2; ++dir) {
    const int ctx = av1_get_pred_context_switchable_interp(xd, dir);
    InterpFilter filter = av1_extract_interp_filter(mbmi->interp_filters, dir);
    update_cdf(xd->tile_ctx->switchable_interp_cdf[ctx], filter,
               SWITCHABLE_FILTERS);
  }
}

static AOM_INLINE void update_global_motion_used(PREDICTION_MODE mode,
                                                 BLOCK_SIZE bsize,
                                                 const MB_MODE_INFO *mbmi,
                                                 RD_COUNTS *rdc) {
  if (mode == GLOBALMV || mode == GLOBAL_GLOBALMV) {
    const int num_4x4s = mi_size_wide[bsize] * mi_size_high[bsize];
    int ref;
    for (ref = 0; ref < 1 + has_second_ref(mbmi); ++ref) {
      rdc->global_motion_used[mbmi->ref_frame[ref]] += num_4x4s;
    }
  }
}

static AOM_INLINE void reset_tx_size(MACROBLOCK *x, MB_MODE_INFO *mbmi,
                                     const TX_MODE tx_mode) {
  MACROBLOCKD *const xd = &x->e_mbd;
  if (xd->lossless[mbmi->segment_id]) {
    mbmi->tx_size = TX_4X4;
  } else if (tx_mode != TX_MODE_SELECT) {
    mbmi->tx_size = tx_size_from_tx_mode(mbmi->sb_type, tx_mode);
  } else {
    BLOCK_SIZE bsize = mbmi->sb_type;
    TX_SIZE min_tx_size = depth_to_tx_size(MAX_TX_DEPTH, bsize);
    mbmi->tx_size = (TX_SIZE)TXSIZEMAX(mbmi->tx_size, min_tx_size);
  }
  if (is_inter_block(mbmi)) {
    memset(mbmi->inter_tx_size, mbmi->tx_size, sizeof(mbmi->inter_tx_size));
  }
  const int stride = xd->tx_type_map_stride;
  const int bw = mi_size_wide[mbmi->sb_type];
  for (int row = 0; row < mi_size_high[mbmi->sb_type]; ++row) {
    memset(xd->tx_type_map + row * stride, DCT_DCT,
           bw * sizeof(xd->tx_type_map[0]));
  }
  av1_zero(x->blk_skip);
  x->force_skip = 0;
}

// This function will copy the best reference mode information from
// MB_MODE_INFO_EXT_FRAME to MB_MODE_INFO_EXT.
static INLINE void copy_mbmi_ext_frame_to_mbmi_ext(
    MB_MODE_INFO_EXT *mbmi_ext,
    const MB_MODE_INFO_EXT_FRAME *const mbmi_ext_best, uint8_t ref_frame_type) {
  memcpy(mbmi_ext->ref_mv_stack[ref_frame_type], mbmi_ext_best->ref_mv_stack,
         sizeof(mbmi_ext->ref_mv_stack[USABLE_REF_MV_STACK_SIZE]));
  memcpy(mbmi_ext->weight[ref_frame_type], mbmi_ext_best->weight,
         sizeof(mbmi_ext->weight[USABLE_REF_MV_STACK_SIZE]));
  mbmi_ext->mode_context[ref_frame_type] = mbmi_ext_best->mode_context;
  mbmi_ext->ref_mv_count[ref_frame_type] = mbmi_ext_best->ref_mv_count;
  memcpy(mbmi_ext->global_mvs, mbmi_ext_best->global_mvs,
         sizeof(mbmi_ext->global_mvs));
}

static AOM_INLINE void update_state(const AV1_COMP *const cpi, ThreadData *td,
                                    const PICK_MODE_CONTEXT *const ctx,
                                    int mi_row, int mi_col, BLOCK_SIZE bsize,
                                    RUN_TYPE dry_run) {
  int i, x_idx, y;
  const AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int num_planes = av1_num_planes(cm);
  RD_COUNTS *const rdc = &td->rd_counts;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  struct macroblock_plane *const p = x->plane;
  struct macroblockd_plane *const pd = xd->plane;
  const MB_MODE_INFO *const mi = &ctx->mic;
  MB_MODE_INFO *const mi_addr = xd->mi[0];
  const struct segmentation *const seg = &cm->seg;
  const int bw = mi_size_wide[mi->sb_type];
  const int bh = mi_size_high[mi->sb_type];
  const int mis = mi_params->mi_stride;
  const int mi_width = mi_size_wide[bsize];
  const int mi_height = mi_size_high[bsize];

  assert(mi->sb_type == bsize);

  *mi_addr = *mi;
  copy_mbmi_ext_frame_to_mbmi_ext(x->mbmi_ext, &ctx->mbmi_ext_best,
                                  av1_ref_frame_type(ctx->mic.ref_frame));

  memcpy(x->blk_skip, ctx->blk_skip, sizeof(x->blk_skip[0]) * ctx->num_4x4_blk);

  x->force_skip = ctx->rd_stats.skip;

  xd->tx_type_map = ctx->tx_type_map;
  xd->tx_type_map_stride = mi_size_wide[bsize];
  // If not dry_run, copy the transform type data into the frame level buffer.
  // Encoder will fetch tx types when writing bitstream.
  if (!dry_run) {
    const int grid_idx = get_mi_grid_idx(mi_params, mi_row, mi_col);
    uint8_t *const tx_type_map = mi_params->tx_type_map + grid_idx;
    const int mi_stride = mi_params->mi_stride;
    for (int blk_row = 0; blk_row < bh; ++blk_row) {
      av1_copy_array(tx_type_map + blk_row * mi_stride,
                     xd->tx_type_map + blk_row * xd->tx_type_map_stride, bw);
    }
    xd->tx_type_map = tx_type_map;
    xd->tx_type_map_stride = mi_stride;
  }

  // If segmentation in use
  if (seg->enabled) {
    // For in frame complexity AQ copy the segment id from the segment map.
    if (cpi->oxcf.aq_mode == COMPLEXITY_AQ) {
      const uint8_t *const map =
          seg->update_map ? cpi->enc_seg.map : cm->last_frame_seg_map;
      mi_addr->segment_id =
          map ? get_segment_id(mi_params, map, bsize, mi_row, mi_col) : 0;
      reset_tx_size(x, mi_addr, x->tx_mode_search_type);
    }
    // Else for cyclic refresh mode update the segment map, set the segment id
    // and then update the quantizer.
    if (cpi->oxcf.aq_mode == CYCLIC_REFRESH_AQ) {
      av1_cyclic_refresh_update_segment(cpi, mi_addr, mi_row, mi_col, bsize,
                                        ctx->rd_stats.rate, ctx->rd_stats.dist,
                                        x->force_skip);
    }
    if (mi_addr->uv_mode == UV_CFL_PRED && !is_cfl_allowed(xd))
      mi_addr->uv_mode = UV_DC_PRED;
  }

  for (i = 0; i < num_planes; ++i) {
    p[i].coeff = ctx->coeff[i];
    p[i].qcoeff = ctx->qcoeff[i];
    pd[i].dqcoeff = ctx->dqcoeff[i];
    p[i].eobs = ctx->eobs[i];
    p[i].txb_entropy_ctx = ctx->txb_entropy_ctx[i];
  }
  for (i = 0; i < 2; ++i) pd[i].color_index_map = ctx->color_index_map[i];
  // Restore the coding context of the MB to that that was in place
  // when the mode was picked for it
  for (y = 0; y < mi_height; y++) {
    for (x_idx = 0; x_idx < mi_width; x_idx++) {
      if ((xd->mb_to_right_edge >> (3 + MI_SIZE_LOG2)) + mi_width > x_idx &&
          (xd->mb_to_bottom_edge >> (3 + MI_SIZE_LOG2)) + mi_height > y) {
        xd->mi[x_idx + y * mis] = mi_addr;
      }
    }
  }

  if (cpi->oxcf.aq_mode) av1_init_plane_quantizers(cpi, x, mi_addr->segment_id);

  if (dry_run) return;

#if CONFIG_INTERNAL_STATS
  {
    unsigned int *const mode_chosen_counts =
        (unsigned int *)cpi->mode_chosen_counts;  // Cast const away.
    if (frame_is_intra_only(cm)) {
      static const int kf_mode_index[] = {
        THR_DC /*DC_PRED*/,
        THR_V_PRED /*V_PRED*/,
        THR_H_PRED /*H_PRED*/,
        THR_D45_PRED /*D45_PRED*/,
        THR_D135_PRED /*D135_PRED*/,
        THR_D113_PRED /*D113_PRED*/,
        THR_D157_PRED /*D157_PRED*/,
        THR_D203_PRED /*D203_PRED*/,
        THR_D67_PRED /*D67_PRED*/,
        THR_SMOOTH,   /*SMOOTH_PRED*/
        THR_SMOOTH_V, /*SMOOTH_V_PRED*/
        THR_SMOOTH_H, /*SMOOTH_H_PRED*/
        THR_PAETH /*PAETH_PRED*/,
      };
      ++mode_chosen_counts[kf_mode_index[mi_addr->mode]];
    } else {
      // Note how often each mode chosen as best
      ++mode_chosen_counts[ctx->best_mode_index];
    }
  }
#endif
  if (!frame_is_intra_only(cm)) {
    if (is_inter_block(mi_addr)) {
      // TODO(sarahparker): global motion stats need to be handled per-tile
      // to be compatible with tile-based threading.
      update_global_motion_used(mi_addr->mode, bsize, mi_addr, rdc);
    }

    if (cm->features.interp_filter == SWITCHABLE &&
        mi_addr->motion_mode != WARPED_CAUSAL &&
        !is_nontrans_global_motion(xd, xd->mi[0])) {
      update_filter_type_count(td->counts, xd, mi_addr);
    }

    rdc->comp_pred_diff[SINGLE_REFERENCE] += ctx->single_pred_diff;
    rdc->comp_pred_diff[COMPOUND_REFERENCE] += ctx->comp_pred_diff;
    rdc->comp_pred_diff[REFERENCE_MODE_SELECT] += ctx->hybrid_pred_diff;
  }

  const int x_mis = AOMMIN(bw, mi_params->mi_cols - mi_col);
  const int y_mis = AOMMIN(bh, mi_params->mi_rows - mi_row);
  if (cm->seq_params.order_hint_info.enable_ref_frame_mvs)
    av1_copy_frame_mvs(cm, mi, mi_row, mi_col, x_mis, y_mis);
}

void av1_setup_src_planes(MACROBLOCK *x, const YV12_BUFFER_CONFIG *src,
                          int mi_row, int mi_col, const int num_planes,
                          BLOCK_SIZE bsize) {
  // Set current frame pointer.
  x->e_mbd.cur_buf = src;

  // We use AOMMIN(num_planes, MAX_MB_PLANE) instead of num_planes to quiet
  // the static analysis warnings.
  for (int i = 0; i < AOMMIN(num_planes, MAX_MB_PLANE); i++) {
    const int is_uv = i > 0;
    setup_pred_plane(
        &x->plane[i].src, bsize, src->buffers[i], src->crop_widths[is_uv],
        src->crop_heights[is_uv], src->strides[is_uv], mi_row, mi_col, NULL,
        x->e_mbd.plane[i].subsampling_x, x->e_mbd.plane[i].subsampling_y);
  }
}

static EdgeInfo edge_info(const struct buf_2d *ref, const BLOCK_SIZE bsize,
                          const bool high_bd, const int bd) {
  const int width = block_size_wide[bsize];
  const int height = block_size_high[bsize];
  // Implementation requires width to be a multiple of 8. It also requires
  // height to be a multiple of 4, but this is always the case.
  assert(height % 4 == 0);
  if (width % 8 != 0) {
    EdgeInfo ei = { .magnitude = 0, .x = 0, .y = 0 };
    return ei;
  }
  return av1_edge_exists(ref->buf, ref->stride, width, height, high_bd, bd);
}

static int use_pb_simple_motion_pred_sse(const AV1_COMP *const cpi) {
  // TODO(debargha, yuec): Not in use, need to implement a speed feature
  // utilizing this data point, and replace '0' by the corresponding speed
  // feature flag.
  return 0 && !frame_is_intra_only(&cpi->common);
}

static void hybrid_intra_mode_search(AV1_COMP *cpi, MACROBLOCK *const x,
                                     RD_STATS *rd_cost, BLOCK_SIZE bsize,
                                     PICK_MODE_CONTEXT *ctx) {
  // TODO(jianj): Investigate the failure of ScalabilityTest in AOM_Q mode,
  // which sets base_qindex to 0 on keyframe.
  if (cpi->oxcf.rc_mode != AOM_CBR || !cpi->sf.rt_sf.hybrid_intra_pickmode ||
      bsize < BLOCK_16X16)
    av1_rd_pick_intra_mode_sb(cpi, x, rd_cost, bsize, ctx, INT64_MAX);
  else
    av1_pick_intra_mode(cpi, x, rd_cost, bsize, ctx);
}

static AOM_INLINE void pick_sb_modes(AV1_COMP *const cpi,
                                     TileDataEnc *tile_data,
                                     MACROBLOCK *const x, int mi_row,
                                     int mi_col, RD_STATS *rd_cost,
                                     PARTITION_TYPE partition, BLOCK_SIZE bsize,
                                     PICK_MODE_CONTEXT *ctx, RD_STATS best_rd,
                                     int pick_mode_type) {
  if (best_rd.rdcost < 0) {
    ctx->rd_stats.rdcost = INT64_MAX;
    ctx->rd_stats.skip = 0;
    av1_invalid_rd_stats(rd_cost);
    return;
  }

  set_offsets(cpi, &tile_data->tile_info, x, mi_row, mi_col, bsize);

  if (ctx->rd_mode_is_ready) {
    assert(ctx->mic.sb_type == bsize);
    assert(ctx->mic.partition == partition);
    rd_cost->rate = ctx->rd_stats.rate;
    rd_cost->dist = ctx->rd_stats.dist;
    rd_cost->rdcost = ctx->rd_stats.rdcost;
    return;
  }

  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *mbmi;
  struct macroblock_plane *const p = x->plane;
  struct macroblockd_plane *const pd = xd->plane;
  const AQ_MODE aq_mode = cpi->oxcf.aq_mode;
  int i;

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, rd_pick_sb_modes_time);
#endif

  aom_clear_system_state();

  mbmi = xd->mi[0];
  mbmi->sb_type = bsize;
  mbmi->partition = partition;

#if CONFIG_RD_DEBUG
  mbmi->mi_row = mi_row;
  mbmi->mi_col = mi_col;
#endif

  xd->tx_type_map = x->tx_type_map;
  xd->tx_type_map_stride = mi_size_wide[bsize];

  for (i = 0; i < num_planes; ++i) {
    p[i].coeff = ctx->coeff[i];
    p[i].qcoeff = ctx->qcoeff[i];
    pd[i].dqcoeff = ctx->dqcoeff[i];
    p[i].eobs = ctx->eobs[i];
    p[i].txb_entropy_ctx = ctx->txb_entropy_ctx[i];
  }

  for (i = 0; i < 2; ++i) pd[i].color_index_map = ctx->color_index_map[i];

  ctx->skippable = 0;
  // Set to zero to make sure we do not use the previous encoded frame stats
  mbmi->skip = 0;
  // Reset skip mode flag.
  mbmi->skip_mode = 0;

  if (is_cur_buf_hbd(xd)) {
    x->source_variance = av1_high_get_sby_perpixel_variance(
        cpi, &x->plane[0].src, bsize, xd->bd);
  } else {
    x->source_variance =
        av1_get_sby_perpixel_variance(cpi, &x->plane[0].src, bsize);
  }
  if (use_pb_simple_motion_pred_sse(cpi)) {
    const FULLPEL_MV start_mv = kZeroFullMv;
    unsigned int var = 0;
    av1_simple_motion_sse_var(cpi, x, mi_row, mi_col, bsize, start_mv, 0,
                              &x->simple_motion_pred_sse, &var);
  }

  // If the threshold for disabling wedge search is zero, it means the feature
  // should not be used. Use a value that will always succeed in the check.
  if (cpi->sf.inter_sf.disable_wedge_search_edge_thresh == 0) {
    x->edge_strength = UINT16_MAX;
    x->edge_strength_x = UINT16_MAX;
    x->edge_strength_y = UINT16_MAX;
  } else {
    EdgeInfo ei =
        edge_info(&x->plane[0].src, bsize, is_cur_buf_hbd(xd), xd->bd);
    x->edge_strength = ei.magnitude;
    x->edge_strength_x = ei.x;
    x->edge_strength_y = ei.y;
  }

  // Initialize default mode evaluation params
  set_mode_eval_params(cpi, x, DEFAULT_EVAL);

  // Save rdmult before it might be changed, so it can be restored later.
  const int orig_rdmult = x->rdmult;
  setup_block_rdmult(cpi, x, mi_row, mi_col, bsize, aq_mode, mbmi);
  // Set error per bit for current rdmult
  set_error_per_bit(x, x->rdmult);
  av1_rd_cost_update(x->rdmult, &best_rd);

  // Find best coding mode & reconstruct the MB so it is available
  // as a predictor for MBs that follow in the SB
  if (frame_is_intra_only(cm)) {
#if CONFIG_COLLECT_COMPONENT_TIMING
    start_timing(cpi, av1_rd_pick_intra_mode_sb_time);
#endif
    switch (pick_mode_type) {
      case PICK_MODE_RD:
        av1_rd_pick_intra_mode_sb(cpi, x, rd_cost, bsize, ctx, best_rd.rdcost);
        break;
      case PICK_MODE_NONRD:
        hybrid_intra_mode_search(cpi, x, rd_cost, bsize, ctx);
        break;
      default: assert(0 && "Unknown pick mode type.");
    }
#if CONFIG_COLLECT_COMPONENT_TIMING
    end_timing(cpi, av1_rd_pick_intra_mode_sb_time);
#endif
  } else {
#if CONFIG_COLLECT_COMPONENT_TIMING
    start_timing(cpi, av1_rd_pick_inter_mode_sb_time);
#endif
    if (segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_SKIP)) {
      av1_rd_pick_inter_mode_sb_seg_skip(cpi, tile_data, x, mi_row, mi_col,
                                         rd_cost, bsize, ctx, best_rd.rdcost);
    } else {
      // TODO(kyslov): do the same for pick_inter_mode_sb_seg_skip
      switch (pick_mode_type) {
        case PICK_MODE_RD:
          av1_rd_pick_inter_mode_sb(cpi, tile_data, x, rd_cost, bsize, ctx,
                                    best_rd.rdcost);
          break;
        case PICK_MODE_NONRD:
          av1_nonrd_pick_inter_mode_sb(cpi, tile_data, x, rd_cost, bsize, ctx,
                                       best_rd.rdcost);
          break;
        default: assert(0 && "Unknown pick mode type.");
      }
    }
#if CONFIG_COLLECT_COMPONENT_TIMING
    end_timing(cpi, av1_rd_pick_inter_mode_sb_time);
#endif
  }

  // Examine the resulting rate and for AQ mode 2 make a segment choice.
  if (rd_cost->rate != INT_MAX && aq_mode == COMPLEXITY_AQ &&
      bsize >= BLOCK_16X16) {
    av1_caq_select_segment(cpi, x, bsize, mi_row, mi_col, rd_cost->rate);
  }

  x->rdmult = orig_rdmult;

  // TODO(jingning) The rate-distortion optimization flow needs to be
  // refactored to provide proper exit/return handle.
  if (rd_cost->rate == INT_MAX) rd_cost->rdcost = INT64_MAX;

  ctx->rd_stats.rate = rd_cost->rate;
  ctx->rd_stats.dist = rd_cost->dist;
  ctx->rd_stats.rdcost = rd_cost->rdcost;

#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, rd_pick_sb_modes_time);
#endif
}

static AOM_INLINE void update_inter_mode_stats(FRAME_CONTEXT *fc,
                                               FRAME_COUNTS *counts,
                                               PREDICTION_MODE mode,
                                               int16_t mode_context) {
  (void)counts;

  int16_t mode_ctx = mode_context & NEWMV_CTX_MASK;
  if (mode == NEWMV) {
#if CONFIG_ENTROPY_STATS
    ++counts->newmv_mode[mode_ctx][0];
#endif
    update_cdf(fc->newmv_cdf[mode_ctx], 0, 2);
    return;
  }

#if CONFIG_ENTROPY_STATS
  ++counts->newmv_mode[mode_ctx][1];
#endif
  update_cdf(fc->newmv_cdf[mode_ctx], 1, 2);

  mode_ctx = (mode_context >> GLOBALMV_OFFSET) & GLOBALMV_CTX_MASK;
  if (mode == GLOBALMV) {
#if CONFIG_ENTROPY_STATS
    ++counts->zeromv_mode[mode_ctx][0];
#endif
    update_cdf(fc->zeromv_cdf[mode_ctx], 0, 2);
    return;
  }

#if CONFIG_ENTROPY_STATS
  ++counts->zeromv_mode[mode_ctx][1];
#endif
  update_cdf(fc->zeromv_cdf[mode_ctx], 1, 2);

  mode_ctx = (mode_context >> REFMV_OFFSET) & REFMV_CTX_MASK;
#if CONFIG_ENTROPY_STATS
  ++counts->refmv_mode[mode_ctx][mode != NEARESTMV];
#endif
  update_cdf(fc->refmv_cdf[mode_ctx], mode != NEARESTMV, 2);
}

static AOM_INLINE void update_palette_cdf(MACROBLOCKD *xd,
                                          const MB_MODE_INFO *const mbmi,
                                          FRAME_COUNTS *counts) {
  FRAME_CONTEXT *fc = xd->tile_ctx;
  const BLOCK_SIZE bsize = mbmi->sb_type;
  const PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
  const int palette_bsize_ctx = av1_get_palette_bsize_ctx(bsize);

  (void)counts;

  if (mbmi->mode == DC_PRED) {
    const int n = pmi->palette_size[0];
    const int palette_mode_ctx = av1_get_palette_mode_ctx(xd);

#if CONFIG_ENTROPY_STATS
    ++counts->palette_y_mode[palette_bsize_ctx][palette_mode_ctx][n > 0];
#endif
    update_cdf(fc->palette_y_mode_cdf[palette_bsize_ctx][palette_mode_ctx],
               n > 0, 2);
    if (n > 0) {
#if CONFIG_ENTROPY_STATS
      ++counts->palette_y_size[palette_bsize_ctx][n - PALETTE_MIN_SIZE];
#endif
      update_cdf(fc->palette_y_size_cdf[palette_bsize_ctx],
                 n - PALETTE_MIN_SIZE, PALETTE_SIZES);
    }
  }

  if (mbmi->uv_mode == UV_DC_PRED) {
    const int n = pmi->palette_size[1];
    const int palette_uv_mode_ctx = (pmi->palette_size[0] > 0);

#if CONFIG_ENTROPY_STATS
    ++counts->palette_uv_mode[palette_uv_mode_ctx][n > 0];
#endif
    update_cdf(fc->palette_uv_mode_cdf[palette_uv_mode_ctx], n > 0, 2);

    if (n > 0) {
#if CONFIG_ENTROPY_STATS
      ++counts->palette_uv_size[palette_bsize_ctx][n - PALETTE_MIN_SIZE];
#endif
      update_cdf(fc->palette_uv_size_cdf[palette_bsize_ctx],
                 n - PALETTE_MIN_SIZE, PALETTE_SIZES);
    }
  }
}

static AOM_INLINE void sum_intra_stats(const AV1_COMMON *const cm,
                                       FRAME_COUNTS *counts, MACROBLOCKD *xd,
                                       const MB_MODE_INFO *const mbmi,
                                       const MB_MODE_INFO *above_mi,
                                       const MB_MODE_INFO *left_mi,
                                       const int intraonly) {
  FRAME_CONTEXT *fc = xd->tile_ctx;
  const PREDICTION_MODE y_mode = mbmi->mode;
  (void)counts;
  const BLOCK_SIZE bsize = mbmi->sb_type;

  if (intraonly) {
#if CONFIG_ENTROPY_STATS
    const PREDICTION_MODE above = av1_above_block_mode(above_mi);
    const PREDICTION_MODE left = av1_left_block_mode(left_mi);
    const int above_ctx = intra_mode_context[above];
    const int left_ctx = intra_mode_context[left];
    ++counts->kf_y_mode[above_ctx][left_ctx][y_mode];
#endif  // CONFIG_ENTROPY_STATS
    update_cdf(get_y_mode_cdf(fc, above_mi, left_mi), y_mode, INTRA_MODES);
  } else {
#if CONFIG_ENTROPY_STATS
    ++counts->y_mode[size_group_lookup[bsize]][y_mode];
#endif  // CONFIG_ENTROPY_STATS
    update_cdf(fc->y_mode_cdf[size_group_lookup[bsize]], y_mode, INTRA_MODES);
  }

  if (av1_filter_intra_allowed(cm, mbmi)) {
    const int use_filter_intra_mode =
        mbmi->filter_intra_mode_info.use_filter_intra;
#if CONFIG_ENTROPY_STATS
    ++counts->filter_intra[mbmi->sb_type][use_filter_intra_mode];
    if (use_filter_intra_mode) {
      ++counts
            ->filter_intra_mode[mbmi->filter_intra_mode_info.filter_intra_mode];
    }
#endif  // CONFIG_ENTROPY_STATS
    update_cdf(fc->filter_intra_cdfs[mbmi->sb_type], use_filter_intra_mode, 2);
    if (use_filter_intra_mode) {
      update_cdf(fc->filter_intra_mode_cdf,
                 mbmi->filter_intra_mode_info.filter_intra_mode,
                 FILTER_INTRA_MODES);
    }
  }
  if (av1_is_directional_mode(mbmi->mode) && av1_use_angle_delta(bsize)) {
#if CONFIG_ENTROPY_STATS
    ++counts->angle_delta[mbmi->mode - V_PRED]
                         [mbmi->angle_delta[PLANE_TYPE_Y] + MAX_ANGLE_DELTA];
#endif
    update_cdf(fc->angle_delta_cdf[mbmi->mode - V_PRED],
               mbmi->angle_delta[PLANE_TYPE_Y] + MAX_ANGLE_DELTA,
               2 * MAX_ANGLE_DELTA + 1);
  }

  if (!xd->is_chroma_ref) return;

  const UV_PREDICTION_MODE uv_mode = mbmi->uv_mode;
  const CFL_ALLOWED_TYPE cfl_allowed = is_cfl_allowed(xd);
#if CONFIG_ENTROPY_STATS
  ++counts->uv_mode[cfl_allowed][y_mode][uv_mode];
#endif  // CONFIG_ENTROPY_STATS
  update_cdf(fc->uv_mode_cdf[cfl_allowed][y_mode], uv_mode,
             UV_INTRA_MODES - !cfl_allowed);
  if (uv_mode == UV_CFL_PRED) {
    const int8_t joint_sign = mbmi->cfl_alpha_signs;
    const uint8_t idx = mbmi->cfl_alpha_idx;

#if CONFIG_ENTROPY_STATS
    ++counts->cfl_sign[joint_sign];
#endif
    update_cdf(fc->cfl_sign_cdf, joint_sign, CFL_JOINT_SIGNS);
    if (CFL_SIGN_U(joint_sign) != CFL_SIGN_ZERO) {
      aom_cdf_prob *cdf_u = fc->cfl_alpha_cdf[CFL_CONTEXT_U(joint_sign)];

#if CONFIG_ENTROPY_STATS
      ++counts->cfl_alpha[CFL_CONTEXT_U(joint_sign)][CFL_IDX_U(idx)];
#endif
      update_cdf(cdf_u, CFL_IDX_U(idx), CFL_ALPHABET_SIZE);
    }
    if (CFL_SIGN_V(joint_sign) != CFL_SIGN_ZERO) {
      aom_cdf_prob *cdf_v = fc->cfl_alpha_cdf[CFL_CONTEXT_V(joint_sign)];

#if CONFIG_ENTROPY_STATS
      ++counts->cfl_alpha[CFL_CONTEXT_V(joint_sign)][CFL_IDX_V(idx)];
#endif
      update_cdf(cdf_v, CFL_IDX_V(idx), CFL_ALPHABET_SIZE);
    }
  }
  if (av1_is_directional_mode(get_uv_mode(uv_mode)) &&
      av1_use_angle_delta(bsize)) {
#if CONFIG_ENTROPY_STATS
    ++counts->angle_delta[uv_mode - UV_V_PRED]
                         [mbmi->angle_delta[PLANE_TYPE_UV] + MAX_ANGLE_DELTA];
#endif
    update_cdf(fc->angle_delta_cdf[uv_mode - UV_V_PRED],
               mbmi->angle_delta[PLANE_TYPE_UV] + MAX_ANGLE_DELTA,
               2 * MAX_ANGLE_DELTA + 1);
  }
  if (av1_allow_palette(cm->features.allow_screen_content_tools, bsize)) {
    update_palette_cdf(xd, mbmi, counts);
  }
}

static AOM_INLINE void update_stats(const AV1_COMMON *const cm,
                                    ThreadData *td) {
  MACROBLOCK *x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const MB_MODE_INFO *const mbmi = xd->mi[0];
  const MB_MODE_INFO_EXT *const mbmi_ext = x->mbmi_ext;
  const CurrentFrame *const current_frame = &cm->current_frame;
  const BLOCK_SIZE bsize = mbmi->sb_type;
  FRAME_CONTEXT *fc = xd->tile_ctx;
  const int seg_ref_active =
      segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_REF_FRAME);

  if (current_frame->skip_mode_info.skip_mode_flag && !seg_ref_active &&
      is_comp_ref_allowed(bsize)) {
    const int skip_mode_ctx = av1_get_skip_mode_context(xd);
#if CONFIG_ENTROPY_STATS
    td->counts->skip_mode[skip_mode_ctx][mbmi->skip_mode]++;
#endif
    update_cdf(fc->skip_mode_cdfs[skip_mode_ctx], mbmi->skip_mode, 2);
  }

  if (!mbmi->skip_mode && !seg_ref_active) {
    const int skip_ctx = av1_get_skip_context(xd);
#if CONFIG_ENTROPY_STATS
    td->counts->skip[skip_ctx][mbmi->skip]++;
#endif
    update_cdf(fc->skip_cdfs[skip_ctx], mbmi->skip, 2);
  }

#if CONFIG_ENTROPY_STATS
  // delta quant applies to both intra and inter
  const int super_block_upper_left =
      ((xd->mi_row & (cm->seq_params.mib_size - 1)) == 0) &&
      ((xd->mi_col & (cm->seq_params.mib_size - 1)) == 0);
  const DeltaQInfo *const delta_q_info = &cm->delta_q_info;
  if (delta_q_info->delta_q_present_flag &&
      (bsize != cm->seq_params.sb_size || !mbmi->skip) &&
      super_block_upper_left) {
    const int dq =
        (mbmi->current_qindex - xd->current_qindex) / delta_q_info->delta_q_res;
    const int absdq = abs(dq);
    for (int i = 0; i < AOMMIN(absdq, DELTA_Q_SMALL); ++i) {
      td->counts->delta_q[i][1]++;
    }
    if (absdq < DELTA_Q_SMALL) td->counts->delta_q[absdq][0]++;
    if (delta_q_info->delta_lf_present_flag) {
      if (delta_q_info->delta_lf_multi) {
        const int frame_lf_count =
            av1_num_planes(cm) > 1 ? FRAME_LF_COUNT : FRAME_LF_COUNT - 2;
        for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id) {
          const int delta_lf = (mbmi->delta_lf[lf_id] - xd->delta_lf[lf_id]) /
                               delta_q_info->delta_lf_res;
          const int abs_delta_lf = abs(delta_lf);
          for (int i = 0; i < AOMMIN(abs_delta_lf, DELTA_LF_SMALL); ++i) {
            td->counts->delta_lf_multi[lf_id][i][1]++;
          }
          if (abs_delta_lf < DELTA_LF_SMALL)
            td->counts->delta_lf_multi[lf_id][abs_delta_lf][0]++;
        }
      } else {
        const int delta_lf =
            (mbmi->delta_lf_from_base - xd->delta_lf_from_base) /
            delta_q_info->delta_lf_res;
        const int abs_delta_lf = abs(delta_lf);
        for (int i = 0; i < AOMMIN(abs_delta_lf, DELTA_LF_SMALL); ++i) {
          td->counts->delta_lf[i][1]++;
        }
        if (abs_delta_lf < DELTA_LF_SMALL)
          td->counts->delta_lf[abs_delta_lf][0]++;
      }
    }
  }
#endif

  if (!is_inter_block(mbmi)) {
    sum_intra_stats(cm, td->counts, xd, mbmi, xd->above_mbmi, xd->left_mbmi,
                    frame_is_intra_only(cm));
  }

  if (av1_allow_intrabc(cm)) {
    update_cdf(fc->intrabc_cdf, is_intrabc_block(mbmi), 2);
#if CONFIG_ENTROPY_STATS
    ++td->counts->intrabc[is_intrabc_block(mbmi)];
#endif  // CONFIG_ENTROPY_STATS
  }

  if (frame_is_intra_only(cm) || mbmi->skip_mode) return;

  FRAME_COUNTS *const counts = td->counts;
  const int inter_block = is_inter_block(mbmi);

  if (!seg_ref_active) {
#if CONFIG_ENTROPY_STATS
    counts->intra_inter[av1_get_intra_inter_context(xd)][inter_block]++;
#endif
    update_cdf(fc->intra_inter_cdf[av1_get_intra_inter_context(xd)],
               inter_block, 2);
    // If the segment reference feature is enabled we have only a single
    // reference frame allowed for the segment so exclude it from
    // the reference frame counts used to work out probabilities.
    if (inter_block) {
      const MV_REFERENCE_FRAME ref0 = mbmi->ref_frame[0];
      const MV_REFERENCE_FRAME ref1 = mbmi->ref_frame[1];
      if (current_frame->reference_mode == REFERENCE_MODE_SELECT) {
        if (is_comp_ref_allowed(bsize)) {
#if CONFIG_ENTROPY_STATS
          counts->comp_inter[av1_get_reference_mode_context(xd)]
                            [has_second_ref(mbmi)]++;
#endif  // CONFIG_ENTROPY_STATS
          update_cdf(av1_get_reference_mode_cdf(xd), has_second_ref(mbmi), 2);
        }
      }

      if (has_second_ref(mbmi)) {
        const COMP_REFERENCE_TYPE comp_ref_type = has_uni_comp_refs(mbmi)
                                                      ? UNIDIR_COMP_REFERENCE
                                                      : BIDIR_COMP_REFERENCE;
        update_cdf(av1_get_comp_reference_type_cdf(xd), comp_ref_type,
                   COMP_REFERENCE_TYPES);
#if CONFIG_ENTROPY_STATS
        counts->comp_ref_type[av1_get_comp_reference_type_context(xd)]
                             [comp_ref_type]++;
#endif  // CONFIG_ENTROPY_STATS

        if (comp_ref_type == UNIDIR_COMP_REFERENCE) {
          const int bit = (ref0 == BWDREF_FRAME);
          update_cdf(av1_get_pred_cdf_uni_comp_ref_p(xd), bit, 2);
#if CONFIG_ENTROPY_STATS
          counts
              ->uni_comp_ref[av1_get_pred_context_uni_comp_ref_p(xd)][0][bit]++;
#endif  // CONFIG_ENTROPY_STATS
          if (!bit) {
            const int bit1 = (ref1 == LAST3_FRAME || ref1 == GOLDEN_FRAME);
            update_cdf(av1_get_pred_cdf_uni_comp_ref_p1(xd), bit1, 2);
#if CONFIG_ENTROPY_STATS
            counts->uni_comp_ref[av1_get_pred_context_uni_comp_ref_p1(xd)][1]
                                [bit1]++;
#endif  // CONFIG_ENTROPY_STATS
            if (bit1) {
              update_cdf(av1_get_pred_cdf_uni_comp_ref_p2(xd),
                         ref1 == GOLDEN_FRAME, 2);
#if CONFIG_ENTROPY_STATS
              counts->uni_comp_ref[av1_get_pred_context_uni_comp_ref_p2(xd)][2]
                                  [ref1 == GOLDEN_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
            }
          }
        } else {
          const int bit = (ref0 == GOLDEN_FRAME || ref0 == LAST3_FRAME);
          update_cdf(av1_get_pred_cdf_comp_ref_p(xd), bit, 2);
#if CONFIG_ENTROPY_STATS
          counts->comp_ref[av1_get_pred_context_comp_ref_p(xd)][0][bit]++;
#endif  // CONFIG_ENTROPY_STATS
          if (!bit) {
            update_cdf(av1_get_pred_cdf_comp_ref_p1(xd), ref0 == LAST2_FRAME,
                       2);
#if CONFIG_ENTROPY_STATS
            counts->comp_ref[av1_get_pred_context_comp_ref_p1(xd)][1]
                            [ref0 == LAST2_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          } else {
            update_cdf(av1_get_pred_cdf_comp_ref_p2(xd), ref0 == GOLDEN_FRAME,
                       2);
#if CONFIG_ENTROPY_STATS
            counts->comp_ref[av1_get_pred_context_comp_ref_p2(xd)][2]
                            [ref0 == GOLDEN_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          }
          update_cdf(av1_get_pred_cdf_comp_bwdref_p(xd), ref1 == ALTREF_FRAME,
                     2);
#if CONFIG_ENTROPY_STATS
          counts->comp_bwdref[av1_get_pred_context_comp_bwdref_p(xd)][0]
                             [ref1 == ALTREF_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          if (ref1 != ALTREF_FRAME) {
            update_cdf(av1_get_pred_cdf_comp_bwdref_p1(xd),
                       ref1 == ALTREF2_FRAME, 2);
#if CONFIG_ENTROPY_STATS
            counts->comp_bwdref[av1_get_pred_context_comp_bwdref_p1(xd)][1]
                               [ref1 == ALTREF2_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          }
        }
      } else {
        const int bit = (ref0 >= BWDREF_FRAME);
        update_cdf(av1_get_pred_cdf_single_ref_p1(xd), bit, 2);
#if CONFIG_ENTROPY_STATS
        counts->single_ref[av1_get_pred_context_single_ref_p1(xd)][0][bit]++;
#endif  // CONFIG_ENTROPY_STATS
        if (bit) {
          assert(ref0 <= ALTREF_FRAME);
          update_cdf(av1_get_pred_cdf_single_ref_p2(xd), ref0 == ALTREF_FRAME,
                     2);
#if CONFIG_ENTROPY_STATS
          counts->single_ref[av1_get_pred_context_single_ref_p2(xd)][1]
                            [ref0 == ALTREF_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          if (ref0 != ALTREF_FRAME) {
            update_cdf(av1_get_pred_cdf_single_ref_p6(xd),
                       ref0 == ALTREF2_FRAME, 2);
#if CONFIG_ENTROPY_STATS
            counts->single_ref[av1_get_pred_context_single_ref_p6(xd)][5]
                              [ref0 == ALTREF2_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          }
        } else {
          const int bit1 = !(ref0 == LAST2_FRAME || ref0 == LAST_FRAME);
          update_cdf(av1_get_pred_cdf_single_ref_p3(xd), bit1, 2);
#if CONFIG_ENTROPY_STATS
          counts->single_ref[av1_get_pred_context_single_ref_p3(xd)][2][bit1]++;
#endif  // CONFIG_ENTROPY_STATS
          if (!bit1) {
            update_cdf(av1_get_pred_cdf_single_ref_p4(xd), ref0 != LAST_FRAME,
                       2);
#if CONFIG_ENTROPY_STATS
            counts->single_ref[av1_get_pred_context_single_ref_p4(xd)][3]
                              [ref0 != LAST_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          } else {
            update_cdf(av1_get_pred_cdf_single_ref_p5(xd), ref0 != LAST3_FRAME,
                       2);
#if CONFIG_ENTROPY_STATS
            counts->single_ref[av1_get_pred_context_single_ref_p5(xd)][4]
                              [ref0 != LAST3_FRAME]++;
#endif  // CONFIG_ENTROPY_STATS
          }
        }
      }

      if (cm->seq_params.enable_interintra_compound &&
          is_interintra_allowed(mbmi)) {
        const int bsize_group = size_group_lookup[bsize];
        if (mbmi->ref_frame[1] == INTRA_FRAME) {
#if CONFIG_ENTROPY_STATS
          counts->interintra[bsize_group][1]++;
#endif
          update_cdf(fc->interintra_cdf[bsize_group], 1, 2);
#if CONFIG_ENTROPY_STATS
          counts->interintra_mode[bsize_group][mbmi->interintra_mode]++;
#endif
          update_cdf(fc->interintra_mode_cdf[bsize_group],
                     mbmi->interintra_mode, INTERINTRA_MODES);
          if (av1_is_wedge_used(bsize)) {
#if CONFIG_ENTROPY_STATS
            counts->wedge_interintra[bsize][mbmi->use_wedge_interintra]++;
#endif
            update_cdf(fc->wedge_interintra_cdf[bsize],
                       mbmi->use_wedge_interintra, 2);
            if (mbmi->use_wedge_interintra) {
#if CONFIG_ENTROPY_STATS
              counts->wedge_idx[bsize][mbmi->interintra_wedge_index]++;
#endif
              update_cdf(fc->wedge_idx_cdf[bsize], mbmi->interintra_wedge_index,
                         16);
            }
          }
        } else {
#if CONFIG_ENTROPY_STATS
          counts->interintra[bsize_group][0]++;
#endif
          update_cdf(fc->interintra_cdf[bsize_group], 0, 2);
        }
      }

      const MOTION_MODE motion_allowed =
          cm->features.switchable_motion_mode
              ? motion_mode_allowed(xd->global_motion, xd, mbmi,
                                    cm->features.allow_warped_motion)
              : SIMPLE_TRANSLATION;
      if (mbmi->ref_frame[1] != INTRA_FRAME) {
        if (motion_allowed == WARPED_CAUSAL) {
#if CONFIG_ENTROPY_STATS
          counts->motion_mode[bsize][mbmi->motion_mode]++;
#endif
          update_cdf(fc->motion_mode_cdf[bsize], mbmi->motion_mode,
                     MOTION_MODES);
        } else if (motion_allowed == OBMC_CAUSAL) {
#if CONFIG_ENTROPY_STATS
          counts->obmc[bsize][mbmi->motion_mode == OBMC_CAUSAL]++;
#endif
          update_cdf(fc->obmc_cdf[bsize], mbmi->motion_mode == OBMC_CAUSAL, 2);
        }
      }

      if (has_second_ref(mbmi)) {
        assert(current_frame->reference_mode != SINGLE_REFERENCE &&
               is_inter_compound_mode(mbmi->mode) &&
               mbmi->motion_mode == SIMPLE_TRANSLATION);

        const int masked_compound_used = is_any_masked_compound_used(bsize) &&
                                         cm->seq_params.enable_masked_compound;
        if (masked_compound_used) {
          const int comp_group_idx_ctx = get_comp_group_idx_context(xd);
#if CONFIG_ENTROPY_STATS
          ++counts->comp_group_idx[comp_group_idx_ctx][mbmi->comp_group_idx];
#endif
          update_cdf(fc->comp_group_idx_cdf[comp_group_idx_ctx],
                     mbmi->comp_group_idx, 2);
        }

        if (mbmi->comp_group_idx == 0) {
          const int comp_index_ctx = get_comp_index_context(cm, xd);
#if CONFIG_ENTROPY_STATS
          ++counts->compound_index[comp_index_ctx][mbmi->compound_idx];
#endif
          update_cdf(fc->compound_index_cdf[comp_index_ctx], mbmi->compound_idx,
                     2);
        } else {
          assert(masked_compound_used);
          if (is_interinter_compound_used(COMPOUND_WEDGE, bsize)) {
#if CONFIG_ENTROPY_STATS
            ++counts->compound_type[bsize][mbmi->interinter_comp.type -
                                           COMPOUND_WEDGE];
#endif
            update_cdf(fc->compound_type_cdf[bsize],
                       mbmi->interinter_comp.type - COMPOUND_WEDGE,
                       MASKED_COMPOUND_TYPES);
          }
        }
      }
      if (mbmi->interinter_comp.type == COMPOUND_WEDGE) {
        if (is_interinter_compound_used(COMPOUND_WEDGE, bsize)) {
#if CONFIG_ENTROPY_STATS
          counts->wedge_idx[bsize][mbmi->interinter_comp.wedge_index]++;
#endif
          update_cdf(fc->wedge_idx_cdf[bsize],
                     mbmi->interinter_comp.wedge_index, 16);
        }
      }
    }
  }

  if (inter_block && cm->features.interp_filter == SWITCHABLE &&
      mbmi->motion_mode != WARPED_CAUSAL &&
      !is_nontrans_global_motion(xd, mbmi)) {
    update_filter_type_cdf(xd, mbmi);
  }
  if (inter_block &&
      !segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_SKIP)) {
    const PREDICTION_MODE mode = mbmi->mode;
    const int16_t mode_ctx =
        av1_mode_context_analyzer(mbmi_ext->mode_context, mbmi->ref_frame);
    if (has_second_ref(mbmi)) {
#if CONFIG_ENTROPY_STATS
      ++counts->inter_compound_mode[mode_ctx][INTER_COMPOUND_OFFSET(mode)];
#endif
      update_cdf(fc->inter_compound_mode_cdf[mode_ctx],
                 INTER_COMPOUND_OFFSET(mode), INTER_COMPOUND_MODES);
    } else {
      update_inter_mode_stats(fc, counts, mode, mode_ctx);
    }

    const int new_mv = mbmi->mode == NEWMV || mbmi->mode == NEW_NEWMV;
    if (new_mv) {
      const uint8_t ref_frame_type = av1_ref_frame_type(mbmi->ref_frame);
      for (int idx = 0; idx < 2; ++idx) {
        if (mbmi_ext->ref_mv_count[ref_frame_type] > idx + 1) {
          const uint8_t drl_ctx =
              av1_drl_ctx(mbmi_ext->weight[ref_frame_type], idx);
          update_cdf(fc->drl_cdf[drl_ctx], mbmi->ref_mv_idx != idx, 2);
#if CONFIG_ENTROPY_STATS
          ++counts->drl_mode[drl_ctx][mbmi->ref_mv_idx != idx];
#endif
          if (mbmi->ref_mv_idx == idx) break;
        }
      }
    }

    if (have_nearmv_in_inter_mode(mbmi->mode)) {
      const uint8_t ref_frame_type = av1_ref_frame_type(mbmi->ref_frame);
      for (int idx = 1; idx < 3; ++idx) {
        if (mbmi_ext->ref_mv_count[ref_frame_type] > idx + 1) {
          const uint8_t drl_ctx =
              av1_drl_ctx(mbmi_ext->weight[ref_frame_type], idx);
          update_cdf(fc->drl_cdf[drl_ctx], mbmi->ref_mv_idx != idx - 1, 2);
#if CONFIG_ENTROPY_STATS
          ++counts->drl_mode[drl_ctx][mbmi->ref_mv_idx != idx - 1];
#endif
          if (mbmi->ref_mv_idx == idx - 1) break;
        }
      }
    }
    if (have_newmv_in_inter_mode(mbmi->mode)) {
      const int allow_hp = cm->features.cur_frame_force_integer_mv
                               ? MV_SUBPEL_NONE
                               : cm->features.allow_high_precision_mv;
      if (new_mv) {
        for (int ref = 0; ref < 1 + has_second_ref(mbmi); ++ref) {
          const int_mv ref_mv = av1_get_ref_mv(x, ref);
          av1_update_mv_stats(&mbmi->mv[ref].as_mv, &ref_mv.as_mv, &fc->nmvc,
                              allow_hp);
        }
      } else if (mbmi->mode == NEAREST_NEWMV || mbmi->mode == NEAR_NEWMV) {
        const int ref = 1;
        const int_mv ref_mv = av1_get_ref_mv(x, ref);
        av1_update_mv_stats(&mbmi->mv[ref].as_mv, &ref_mv.as_mv, &fc->nmvc,
                            allow_hp);
      } else if (mbmi->mode == NEW_NEARESTMV || mbmi->mode == NEW_NEARMV) {
        const int ref = 0;
        const int_mv ref_mv = av1_get_ref_mv(x, ref);
        av1_update_mv_stats(&mbmi->mv[ref].as_mv, &ref_mv.as_mv, &fc->nmvc,
                            allow_hp);
      }
    }
  }
}

static AOM_INLINE void restore_context(MACROBLOCK *x,
                                       const RD_SEARCH_MACROBLOCK_CONTEXT *ctx,
                                       int mi_row, int mi_col, BLOCK_SIZE bsize,
                                       const int num_planes) {
  MACROBLOCKD *xd = &x->e_mbd;
  int p;
  const int num_4x4_blocks_wide = mi_size_wide[bsize];
  const int num_4x4_blocks_high = mi_size_high[bsize];
  int mi_width = mi_size_wide[bsize];
  int mi_height = mi_size_high[bsize];
  for (p = 0; p < num_planes; p++) {
    int tx_col = mi_col;
    int tx_row = mi_row & MAX_MIB_MASK;
    memcpy(
        xd->above_entropy_context[p] + (tx_col >> xd->plane[p].subsampling_x),
        ctx->a + num_4x4_blocks_wide * p,
        (sizeof(ENTROPY_CONTEXT) * num_4x4_blocks_wide) >>
            xd->plane[p].subsampling_x);
    memcpy(xd->left_entropy_context[p] + (tx_row >> xd->plane[p].subsampling_y),
           ctx->l + num_4x4_blocks_high * p,
           (sizeof(ENTROPY_CONTEXT) * num_4x4_blocks_high) >>
               xd->plane[p].subsampling_y);
  }
  memcpy(xd->above_partition_context + mi_col, ctx->sa,
         sizeof(*xd->above_partition_context) * mi_width);
  memcpy(xd->left_partition_context + (mi_row & MAX_MIB_MASK), ctx->sl,
         sizeof(xd->left_partition_context[0]) * mi_height);
  xd->above_txfm_context = ctx->p_ta;
  xd->left_txfm_context = ctx->p_tl;
  memcpy(xd->above_txfm_context, ctx->ta,
         sizeof(*xd->above_txfm_context) * mi_width);
  memcpy(xd->left_txfm_context, ctx->tl,
         sizeof(*xd->left_txfm_context) * mi_height);
}

static AOM_INLINE void save_context(const MACROBLOCK *x,
                                    RD_SEARCH_MACROBLOCK_CONTEXT *ctx,
                                    int mi_row, int mi_col, BLOCK_SIZE bsize,
                                    const int num_planes) {
  const MACROBLOCKD *xd = &x->e_mbd;
  int p;
  int mi_width = mi_size_wide[bsize];
  int mi_height = mi_size_high[bsize];

  // buffer the above/left context information of the block in search.
  for (p = 0; p < num_planes; ++p) {
    int tx_col = mi_col;
    int tx_row = mi_row & MAX_MIB_MASK;
    memcpy(
        ctx->a + mi_width * p,
        xd->above_entropy_context[p] + (tx_col >> xd->plane[p].subsampling_x),
        (sizeof(ENTROPY_CONTEXT) * mi_width) >> xd->plane[p].subsampling_x);
    memcpy(ctx->l + mi_height * p,
           xd->left_entropy_context[p] + (tx_row >> xd->plane[p].subsampling_y),
           (sizeof(ENTROPY_CONTEXT) * mi_height) >> xd->plane[p].subsampling_y);
  }
  memcpy(ctx->sa, xd->above_partition_context + mi_col,
         sizeof(*xd->above_partition_context) * mi_width);
  memcpy(ctx->sl, xd->left_partition_context + (mi_row & MAX_MIB_MASK),
         sizeof(xd->left_partition_context[0]) * mi_height);
  memcpy(ctx->ta, xd->above_txfm_context,
         sizeof(*xd->above_txfm_context) * mi_width);
  memcpy(ctx->tl, xd->left_txfm_context,
         sizeof(*xd->left_txfm_context) * mi_height);
  ctx->p_ta = xd->above_txfm_context;
  ctx->p_tl = xd->left_txfm_context;
}

static AOM_INLINE void encode_b(const AV1_COMP *const cpi,
                                TileDataEnc *tile_data, ThreadData *td,
                                TOKENEXTRA **tp, int mi_row, int mi_col,
                                RUN_TYPE dry_run, BLOCK_SIZE bsize,
                                PARTITION_TYPE partition,
                                PICK_MODE_CONTEXT *const ctx, int *rate) {
  TileInfo *const tile = &tile_data->tile_info;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *xd = &x->e_mbd;

  set_offsets_without_segment_id(cpi, tile, x, mi_row, mi_col, bsize);
  const int origin_mult = x->rdmult;
  setup_block_rdmult(cpi, x, mi_row, mi_col, bsize, NO_AQ, NULL);
  MB_MODE_INFO *mbmi = xd->mi[0];
  mbmi->partition = partition;
  update_state(cpi, td, ctx, mi_row, mi_col, bsize, dry_run);

  if (!dry_run) {
    x->mbmi_ext_frame->cb_offset = x->cb_offset;
    assert(x->cb_offset <
           (1 << num_pels_log2_lookup[cpi->common.seq_params.sb_size]));
  }

  encode_superblock(cpi, tile_data, td, tp, dry_run, bsize, rate);

  if (!dry_run) {
    const AV1_COMMON *const cm = &cpi->common;
    x->cb_offset += block_size_wide[bsize] * block_size_high[bsize];
    if (bsize == cpi->common.seq_params.sb_size && mbmi->skip == 1 &&
        cm->delta_q_info.delta_lf_present_flag) {
      const int frame_lf_count =
          av1_num_planes(cm) > 1 ? FRAME_LF_COUNT : FRAME_LF_COUNT - 2;
      for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id)
        mbmi->delta_lf[lf_id] = xd->delta_lf[lf_id];
      mbmi->delta_lf_from_base = xd->delta_lf_from_base;
    }
    if (has_second_ref(mbmi)) {
      if (mbmi->compound_idx == 0 ||
          mbmi->interinter_comp.type == COMPOUND_AVERAGE)
        mbmi->comp_group_idx = 0;
      else
        mbmi->comp_group_idx = 1;
    }

    // delta quant applies to both intra and inter
    const int super_block_upper_left =
        ((mi_row & (cm->seq_params.mib_size - 1)) == 0) &&
        ((mi_col & (cm->seq_params.mib_size - 1)) == 0);
    const DeltaQInfo *const delta_q_info = &cm->delta_q_info;
    if (delta_q_info->delta_q_present_flag &&
        (bsize != cm->seq_params.sb_size || !mbmi->skip) &&
        super_block_upper_left) {
      xd->current_qindex = mbmi->current_qindex;
      if (delta_q_info->delta_lf_present_flag) {
        if (delta_q_info->delta_lf_multi) {
          const int frame_lf_count =
              av1_num_planes(cm) > 1 ? FRAME_LF_COUNT : FRAME_LF_COUNT - 2;
          for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id) {
            xd->delta_lf[lf_id] = mbmi->delta_lf[lf_id];
          }
        } else {
          xd->delta_lf_from_base = mbmi->delta_lf_from_base;
        }
      }
    }

    RD_COUNTS *rdc = &td->rd_counts;
    if (mbmi->skip_mode) {
      assert(!frame_is_intra_only(cm));
      rdc->skip_mode_used_flag = 1;
      if (cm->current_frame.reference_mode == REFERENCE_MODE_SELECT) {
        assert(has_second_ref(mbmi));
        rdc->compound_ref_used_flag = 1;
      }
      set_ref_ptrs(cm, xd, mbmi->ref_frame[0], mbmi->ref_frame[1]);
    } else {
      const int seg_ref_active =
          segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_REF_FRAME);
      if (!seg_ref_active) {
        // If the segment reference feature is enabled we have only a single
        // reference frame allowed for the segment so exclude it from
        // the reference frame counts used to work out probabilities.
        if (is_inter_block(mbmi)) {
          av1_collect_neighbors_ref_counts(xd);
          if (cm->current_frame.reference_mode == REFERENCE_MODE_SELECT) {
            if (has_second_ref(mbmi)) {
              // This flag is also updated for 4x4 blocks
              rdc->compound_ref_used_flag = 1;
            }
          }
          set_ref_ptrs(cm, xd, mbmi->ref_frame[0], mbmi->ref_frame[1]);
        }
      }
    }

    if (tile_data->allow_update_cdf) update_stats(&cpi->common, td);

    // Gather obmc and warped motion count to update the probability.
    if ((!cpi->sf.inter_sf.disable_obmc &&
         cpi->sf.inter_sf.prune_obmc_prob_thresh > 0) ||
        (cm->features.allow_warped_motion &&
         cpi->sf.inter_sf.prune_warped_prob_thresh > 0)) {
      const int inter_block = is_inter_block(mbmi);
      const int seg_ref_active =
          segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_REF_FRAME);
      if (!seg_ref_active && inter_block) {
        const MOTION_MODE motion_allowed =
            cm->features.switchable_motion_mode
                ? motion_mode_allowed(xd->global_motion, xd, mbmi,
                                      cm->features.allow_warped_motion)
                : SIMPLE_TRANSLATION;

        if (mbmi->ref_frame[1] != INTRA_FRAME) {
          if (motion_allowed >= OBMC_CAUSAL) {
            td->rd_counts.obmc_used[bsize][mbmi->motion_mode == OBMC_CAUSAL]++;
          }
          if (motion_allowed == WARPED_CAUSAL) {
            td->rd_counts.warped_used[mbmi->motion_mode == WARPED_CAUSAL]++;
          }
        }
      }
    }
  }
  // TODO(Ravi/Remya): Move this copy function to a better logical place
  // This function will copy the best mode information from block
  // level (x->mbmi_ext) to frame level (cpi->mbmi_ext_info.frame_base). This
  // frame level buffer (cpi->mbmi_ext_info.frame_base) will be used during
  // bitstream preparation.
  av1_copy_mbmi_ext_to_mbmi_ext_frame(x->mbmi_ext_frame, x->mbmi_ext,
                                      av1_ref_frame_type(xd->mi[0]->ref_frame));
  x->rdmult = origin_mult;
}

static AOM_INLINE void encode_sb(const AV1_COMP *const cpi, ThreadData *td,
                                 TileDataEnc *tile_data, TOKENEXTRA **tp,
                                 int mi_row, int mi_col, RUN_TYPE dry_run,
                                 BLOCK_SIZE bsize, PC_TREE *pc_tree,
                                 int *rate) {
  assert(bsize < BLOCK_SIZES_ALL);
  const AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  assert(bsize < BLOCK_SIZES_ALL);
  const int hbs = mi_size_wide[bsize] / 2;
  const int is_partition_root = bsize >= BLOCK_8X8;
  const int ctx = is_partition_root
                      ? partition_plane_context(xd, mi_row, mi_col, bsize)
                      : -1;
  const PARTITION_TYPE partition = pc_tree->partitioning;
  const BLOCK_SIZE subsize = get_partition_subsize(bsize, partition);
  int quarter_step = mi_size_wide[bsize] / 4;
  int i;
  BLOCK_SIZE bsize2 = get_partition_subsize(bsize, PARTITION_SPLIT);

  if (mi_row >= mi_params->mi_rows || mi_col >= mi_params->mi_cols) return;

  if (!dry_run && ctx >= 0) {
    const int has_rows = (mi_row + hbs) < mi_params->mi_rows;
    const int has_cols = (mi_col + hbs) < mi_params->mi_cols;

    if (has_rows && has_cols) {
#if CONFIG_ENTROPY_STATS
      td->counts->partition[ctx][partition]++;
#endif

      if (tile_data->allow_update_cdf) {
        FRAME_CONTEXT *fc = xd->tile_ctx;
        update_cdf(fc->partition_cdf[ctx], partition,
                   partition_cdf_length(bsize));
      }
    }
  }

  switch (partition) {
    case PARTITION_NONE:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, subsize,
               partition, &pc_tree->none, rate);
      break;
    case PARTITION_VERT:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, subsize,
               partition, &pc_tree->vertical[0], rate);
      if (mi_col + hbs < mi_params->mi_cols) {
        encode_b(cpi, tile_data, td, tp, mi_row, mi_col + hbs, dry_run, subsize,
                 partition, &pc_tree->vertical[1], rate);
      }
      break;
    case PARTITION_HORZ:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, subsize,
               partition, &pc_tree->horizontal[0], rate);
      if (mi_row + hbs < mi_params->mi_rows) {
        encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col, dry_run, subsize,
                 partition, &pc_tree->horizontal[1], rate);
      }
      break;
    case PARTITION_SPLIT:
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, dry_run, subsize,
                pc_tree->split[0], rate);
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col + hbs, dry_run, subsize,
                pc_tree->split[1], rate);
      encode_sb(cpi, td, tile_data, tp, mi_row + hbs, mi_col, dry_run, subsize,
                pc_tree->split[2], rate);
      encode_sb(cpi, td, tile_data, tp, mi_row + hbs, mi_col + hbs, dry_run,
                subsize, pc_tree->split[3], rate);
      break;

    case PARTITION_HORZ_A:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, bsize2,
               partition, &pc_tree->horizontala[0], rate);
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col + hbs, dry_run, bsize2,
               partition, &pc_tree->horizontala[1], rate);
      encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col, dry_run, subsize,
               partition, &pc_tree->horizontala[2], rate);
      break;
    case PARTITION_HORZ_B:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, subsize,
               partition, &pc_tree->horizontalb[0], rate);
      encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col, dry_run, bsize2,
               partition, &pc_tree->horizontalb[1], rate);
      encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col + hbs, dry_run,
               bsize2, partition, &pc_tree->horizontalb[2], rate);
      break;
    case PARTITION_VERT_A:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, bsize2,
               partition, &pc_tree->verticala[0], rate);
      encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col, dry_run, bsize2,
               partition, &pc_tree->verticala[1], rate);
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col + hbs, dry_run, subsize,
               partition, &pc_tree->verticala[2], rate);

      break;
    case PARTITION_VERT_B:
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, dry_run, subsize,
               partition, &pc_tree->verticalb[0], rate);
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col + hbs, dry_run, bsize2,
               partition, &pc_tree->verticalb[1], rate);
      encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col + hbs, dry_run,
               bsize2, partition, &pc_tree->verticalb[2], rate);
      break;
    case PARTITION_HORZ_4:
      for (i = 0; i < 4; ++i) {
        int this_mi_row = mi_row + i * quarter_step;
        if (i > 0 && this_mi_row >= mi_params->mi_rows) break;

        encode_b(cpi, tile_data, td, tp, this_mi_row, mi_col, dry_run, subsize,
                 partition, &pc_tree->horizontal4[i], rate);
      }
      break;
    case PARTITION_VERT_4:
      for (i = 0; i < 4; ++i) {
        int this_mi_col = mi_col + i * quarter_step;
        if (i > 0 && this_mi_col >= mi_params->mi_cols) break;
        encode_b(cpi, tile_data, td, tp, mi_row, this_mi_col, dry_run, subsize,
                 partition, &pc_tree->vertical4[i], rate);
      }
      break;
    default: assert(0 && "Invalid partition type."); break;
  }

  update_ext_partition_context(xd, mi_row, mi_col, subsize, bsize, partition);
}

static AOM_INLINE void set_partial_sb_partition(
    const AV1_COMMON *const cm, MB_MODE_INFO *mi, int bh_in, int bw_in,
    int mi_rows_remaining, int mi_cols_remaining, BLOCK_SIZE bsize,
    MB_MODE_INFO **mib) {
  int bh = bh_in;
  int r, c;
  for (r = 0; r < cm->seq_params.mib_size; r += bh) {
    int bw = bw_in;
    for (c = 0; c < cm->seq_params.mib_size; c += bw) {
      const int grid_index = get_mi_grid_idx(&cm->mi_params, r, c);
      const int mi_index = get_alloc_mi_idx(&cm->mi_params, r, c);
      mib[grid_index] = mi + mi_index;
      mib[grid_index]->sb_type = find_partition_size(
          bsize, mi_rows_remaining - r, mi_cols_remaining - c, &bh, &bw);
    }
  }
}

// This function attempts to set all mode info entries in a given superblock
// to the same block partition size.
// However, at the bottom and right borders of the image the requested size
// may not be allowed in which case this code attempts to choose the largest
// allowable partition.
static AOM_INLINE void set_fixed_partitioning(AV1_COMP *cpi,
                                              const TileInfo *const tile,
                                              MB_MODE_INFO **mib, int mi_row,
                                              int mi_col, BLOCK_SIZE bsize) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int mi_rows_remaining = tile->mi_row_end - mi_row;
  const int mi_cols_remaining = tile->mi_col_end - mi_col;
  MB_MODE_INFO *const mi_upper_left =
      mi_params->mi_alloc + get_alloc_mi_idx(mi_params, mi_row, mi_col);
  int bh = mi_size_high[bsize];
  int bw = mi_size_wide[bsize];

  assert(bsize >= mi_params->mi_alloc_bsize &&
         "Attempted to use bsize < mi_params->mi_alloc_bsize");
  assert((mi_rows_remaining > 0) && (mi_cols_remaining > 0));

  // Apply the requested partition size to the SB if it is all "in image"
  if ((mi_cols_remaining >= cm->seq_params.mib_size) &&
      (mi_rows_remaining >= cm->seq_params.mib_size)) {
    for (int block_row = 0; block_row < cm->seq_params.mib_size;
         block_row += bh) {
      for (int block_col = 0; block_col < cm->seq_params.mib_size;
           block_col += bw) {
        const int grid_index = get_mi_grid_idx(mi_params, block_row, block_col);
        const int mi_index = get_alloc_mi_idx(mi_params, block_row, block_col);
        mib[grid_index] = mi_upper_left + mi_index;
        mib[grid_index]->sb_type = bsize;
      }
    }
  } else {
    // Else this is a partial SB.
    set_partial_sb_partition(cm, mi_upper_left, bh, bw, mi_rows_remaining,
                             mi_cols_remaining, bsize, mib);
  }
}

static AOM_INLINE void rd_use_partition(
    AV1_COMP *cpi, ThreadData *td, TileDataEnc *tile_data, MB_MODE_INFO **mib,
    TOKENEXTRA **tp, int mi_row, int mi_col, BLOCK_SIZE bsize, int *rate,
    int64_t *dist, int do_recon, PC_TREE *pc_tree) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int num_planes = av1_num_planes(cm);
  TileInfo *const tile_info = &tile_data->tile_info;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const int bs = mi_size_wide[bsize];
  const int hbs = bs / 2;
  int i;
  const int pl = (bsize >= BLOCK_8X8)
                     ? partition_plane_context(xd, mi_row, mi_col, bsize)
                     : 0;
  const PARTITION_TYPE partition =
      (bsize >= BLOCK_8X8) ? get_partition(cm, mi_row, mi_col, bsize)
                           : PARTITION_NONE;
  const BLOCK_SIZE subsize = get_partition_subsize(bsize, partition);
  RD_SEARCH_MACROBLOCK_CONTEXT x_ctx;
  RD_STATS last_part_rdc, none_rdc, chosen_rdc, invalid_rdc;
  BLOCK_SIZE sub_subsize = BLOCK_4X4;
  int splits_below = 0;
  BLOCK_SIZE bs_type = mib[0]->sb_type;
  PICK_MODE_CONTEXT *ctx_none = &pc_tree->none;

  if (mi_row >= mi_params->mi_rows || mi_col >= mi_params->mi_cols) return;

  assert(mi_size_wide[bsize] == mi_size_high[bsize]);

  av1_invalid_rd_stats(&last_part_rdc);
  av1_invalid_rd_stats(&none_rdc);
  av1_invalid_rd_stats(&chosen_rdc);
  av1_invalid_rd_stats(&invalid_rdc);

  pc_tree->partitioning = partition;

  xd->above_txfm_context =
      cm->above_contexts.txfm[tile_info->tile_row] + mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);
  save_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);

  if (bsize == BLOCK_16X16 && cpi->vaq_refresh) {
    set_offsets(cpi, tile_info, x, mi_row, mi_col, bsize);
    x->mb_energy = av1_log_block_var(cpi, x, bsize);
  }

  // Save rdmult before it might be changed, so it can be restored later.
  const int orig_rdmult = x->rdmult;
  setup_block_rdmult(cpi, x, mi_row, mi_col, bsize, NO_AQ, NULL);

  if (cpi->sf.part_sf.partition_search_type == VAR_BASED_PARTITION &&
      (cpi->sf.part_sf.adjust_var_based_rd_partitioning == 2 ||
       (cpi->sf.part_sf.adjust_var_based_rd_partitioning == 1 &&
        cm->quant_params.base_qindex > 190 && bsize <= BLOCK_32X32 &&
        !frame_is_intra_only(cm)))) {
    // Check if any of the sub blocks are further split.
    if (partition == PARTITION_SPLIT && subsize > BLOCK_8X8) {
      sub_subsize = get_partition_subsize(subsize, PARTITION_SPLIT);
      splits_below = 1;
      for (i = 0; i < 4; i++) {
        int jj = i >> 1, ii = i & 0x01;
        MB_MODE_INFO *this_mi = mib[jj * hbs * mi_params->mi_stride + ii * hbs];
        if (this_mi && this_mi->sb_type >= sub_subsize) {
          splits_below = 0;
        }
      }
    }

    // If partition is not none try none unless each of the 4 splits are split
    // even further..
    if (partition != PARTITION_NONE && !splits_below &&
        mi_row + hbs < mi_params->mi_rows &&
        mi_col + hbs < mi_params->mi_cols) {
      pc_tree->partitioning = PARTITION_NONE;
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &none_rdc,
                    PARTITION_NONE, bsize, ctx_none, invalid_rdc, PICK_MODE_RD);

      if (none_rdc.rate < INT_MAX) {
        none_rdc.rate += x->partition_cost[pl][PARTITION_NONE];
        none_rdc.rdcost = RDCOST(x->rdmult, none_rdc.rate, none_rdc.dist);
      }

      restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
      mib[0]->sb_type = bs_type;
      pc_tree->partitioning = partition;
    }
  }

  switch (partition) {
    case PARTITION_NONE:
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &last_part_rdc,
                    PARTITION_NONE, bsize, ctx_none, invalid_rdc, PICK_MODE_RD);
      break;
    case PARTITION_HORZ:
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &last_part_rdc,
                    PARTITION_HORZ, subsize, &pc_tree->horizontal[0],
                    invalid_rdc, PICK_MODE_RD);
      if (last_part_rdc.rate != INT_MAX && bsize >= BLOCK_8X8 &&
          mi_row + hbs < mi_params->mi_rows) {
        RD_STATS tmp_rdc;
        const PICK_MODE_CONTEXT *const ctx_h = &pc_tree->horizontal[0];
        av1_init_rd_stats(&tmp_rdc);
        update_state(cpi, td, ctx_h, mi_row, mi_col, subsize, 1);
        encode_superblock(cpi, tile_data, td, tp, DRY_RUN_NORMAL, subsize,
                          NULL);
        pick_sb_modes(cpi, tile_data, x, mi_row + hbs, mi_col, &tmp_rdc,
                      PARTITION_HORZ, subsize, &pc_tree->horizontal[1],
                      invalid_rdc, PICK_MODE_RD);
        if (tmp_rdc.rate == INT_MAX || tmp_rdc.dist == INT64_MAX) {
          av1_invalid_rd_stats(&last_part_rdc);
          break;
        }
        last_part_rdc.rate += tmp_rdc.rate;
        last_part_rdc.dist += tmp_rdc.dist;
        last_part_rdc.rdcost += tmp_rdc.rdcost;
      }
      break;
    case PARTITION_VERT:
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &last_part_rdc,
                    PARTITION_VERT, subsize, &pc_tree->vertical[0], invalid_rdc,
                    PICK_MODE_RD);
      if (last_part_rdc.rate != INT_MAX && bsize >= BLOCK_8X8 &&
          mi_col + hbs < mi_params->mi_cols) {
        RD_STATS tmp_rdc;
        const PICK_MODE_CONTEXT *const ctx_v = &pc_tree->vertical[0];
        av1_init_rd_stats(&tmp_rdc);
        update_state(cpi, td, ctx_v, mi_row, mi_col, subsize, 1);
        encode_superblock(cpi, tile_data, td, tp, DRY_RUN_NORMAL, subsize,
                          NULL);
        pick_sb_modes(cpi, tile_data, x, mi_row, mi_col + hbs, &tmp_rdc,
                      PARTITION_VERT, subsize,
                      &pc_tree->vertical[bsize > BLOCK_8X8], invalid_rdc,
                      PICK_MODE_RD);
        if (tmp_rdc.rate == INT_MAX || tmp_rdc.dist == INT64_MAX) {
          av1_invalid_rd_stats(&last_part_rdc);
          break;
        }
        last_part_rdc.rate += tmp_rdc.rate;
        last_part_rdc.dist += tmp_rdc.dist;
        last_part_rdc.rdcost += tmp_rdc.rdcost;
      }
      break;
    case PARTITION_SPLIT:
      if (cpi->sf.part_sf.adjust_var_based_rd_partitioning == 1 &&
          none_rdc.rate < INT_MAX && none_rdc.skip == 1) {
        av1_invalid_rd_stats(&last_part_rdc);
        break;
      }
      last_part_rdc.rate = 0;
      last_part_rdc.dist = 0;
      last_part_rdc.rdcost = 0;
      for (i = 0; i < 4; i++) {
        int x_idx = (i & 1) * hbs;
        int y_idx = (i >> 1) * hbs;
        int jj = i >> 1, ii = i & 0x01;
        RD_STATS tmp_rdc;
        if ((mi_row + y_idx >= mi_params->mi_rows) ||
            (mi_col + x_idx >= mi_params->mi_cols))
          continue;

        av1_init_rd_stats(&tmp_rdc);
        rd_use_partition(cpi, td, tile_data,
                         mib + jj * hbs * mi_params->mi_stride + ii * hbs, tp,
                         mi_row + y_idx, mi_col + x_idx, subsize, &tmp_rdc.rate,
                         &tmp_rdc.dist, i != 3, pc_tree->split[i]);
        if (tmp_rdc.rate == INT_MAX || tmp_rdc.dist == INT64_MAX) {
          av1_invalid_rd_stats(&last_part_rdc);
          break;
        }
        last_part_rdc.rate += tmp_rdc.rate;
        last_part_rdc.dist += tmp_rdc.dist;
      }
      break;
    case PARTITION_VERT_A:
    case PARTITION_VERT_B:
    case PARTITION_HORZ_A:
    case PARTITION_HORZ_B:
    case PARTITION_HORZ_4:
    case PARTITION_VERT_4:
      assert(0 && "Cannot handle extended partition types");
    default: assert(0); break;
  }

  if (last_part_rdc.rate < INT_MAX) {
    last_part_rdc.rate += x->partition_cost[pl][partition];
    last_part_rdc.rdcost =
        RDCOST(x->rdmult, last_part_rdc.rate, last_part_rdc.dist);
  }

  if ((cpi->sf.part_sf.partition_search_type == VAR_BASED_PARTITION &&
       cpi->sf.part_sf.adjust_var_based_rd_partitioning > 2) &&
      partition != PARTITION_SPLIT && bsize > BLOCK_8X8 &&
      (mi_row + bs < mi_params->mi_rows ||
       mi_row + hbs == mi_params->mi_rows) &&
      (mi_col + bs < mi_params->mi_cols ||
       mi_col + hbs == mi_params->mi_cols)) {
    BLOCK_SIZE split_subsize = get_partition_subsize(bsize, PARTITION_SPLIT);
    chosen_rdc.rate = 0;
    chosen_rdc.dist = 0;

    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
    pc_tree->partitioning = PARTITION_SPLIT;

    // Split partition.
    for (i = 0; i < 4; i++) {
      int x_idx = (i & 1) * hbs;
      int y_idx = (i >> 1) * hbs;
      RD_STATS tmp_rdc;

      if ((mi_row + y_idx >= mi_params->mi_rows) ||
          (mi_col + x_idx >= mi_params->mi_cols))
        continue;

      save_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
      pc_tree->split[i]->partitioning = PARTITION_NONE;
      pick_sb_modes(cpi, tile_data, x, mi_row + y_idx, mi_col + x_idx, &tmp_rdc,
                    PARTITION_SPLIT, split_subsize, &pc_tree->split[i]->none,
                    invalid_rdc, PICK_MODE_RD);

      restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
      if (tmp_rdc.rate == INT_MAX || tmp_rdc.dist == INT64_MAX) {
        av1_invalid_rd_stats(&chosen_rdc);
        break;
      }

      chosen_rdc.rate += tmp_rdc.rate;
      chosen_rdc.dist += tmp_rdc.dist;

      if (i != 3)
        encode_sb(cpi, td, tile_data, tp, mi_row + y_idx, mi_col + x_idx,
                  OUTPUT_ENABLED, split_subsize, pc_tree->split[i], NULL);

      chosen_rdc.rate += x->partition_cost[pl][PARTITION_NONE];
    }
    if (chosen_rdc.rate < INT_MAX) {
      chosen_rdc.rate += x->partition_cost[pl][PARTITION_SPLIT];
      chosen_rdc.rdcost = RDCOST(x->rdmult, chosen_rdc.rate, chosen_rdc.dist);
    }
  }

  // If last_part is better set the partitioning to that.
  if (last_part_rdc.rdcost < chosen_rdc.rdcost) {
    mib[0]->sb_type = bsize;
    if (bsize >= BLOCK_8X8) pc_tree->partitioning = partition;
    chosen_rdc = last_part_rdc;
  }
  // If none was better set the partitioning to that.
  if (none_rdc.rdcost < chosen_rdc.rdcost) {
    if (bsize >= BLOCK_8X8) pc_tree->partitioning = PARTITION_NONE;
    chosen_rdc = none_rdc;
  }

  restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);

  // We must have chosen a partitioning and encoding or we'll fail later on.
  // No other opportunities for success.
  if (bsize == cm->seq_params.sb_size)
    assert(chosen_rdc.rate < INT_MAX && chosen_rdc.dist < INT64_MAX);

  if (do_recon) {
    if (bsize == cm->seq_params.sb_size) {
      // NOTE: To get estimate for rate due to the tokens, use:
      // int rate_coeffs = 0;
      // encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, DRY_RUN_COSTCOEFFS,
      //           bsize, pc_tree, &rate_coeffs);
      x->cb_offset = 0;
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, OUTPUT_ENABLED, bsize,
                pc_tree, NULL);
    } else {
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, DRY_RUN_NORMAL, bsize,
                pc_tree, NULL);
    }
  }

  *rate = chosen_rdc.rate;
  *dist = chosen_rdc.dist;
  x->rdmult = orig_rdmult;
}

static int is_leaf_split_partition(AV1_COMMON *cm, int mi_row, int mi_col,
                                   BLOCK_SIZE bsize) {
  const int bs = mi_size_wide[bsize];
  const int hbs = bs / 2;
  assert(bsize >= BLOCK_8X8);
  const BLOCK_SIZE subsize = get_partition_subsize(bsize, PARTITION_SPLIT);

  for (int i = 0; i < 4; i++) {
    int x_idx = (i & 1) * hbs;
    int y_idx = (i >> 1) * hbs;
    if ((mi_row + y_idx >= cm->mi_params.mi_rows) ||
        (mi_col + x_idx >= cm->mi_params.mi_cols))
      return 0;
    if (get_partition(cm, mi_row + y_idx, mi_col + x_idx, subsize) !=
            PARTITION_NONE &&
        subsize != BLOCK_8X8)
      return 0;
  }
  return 1;
}

static AOM_INLINE int do_slipt_check(BLOCK_SIZE bsize) {
  return (bsize == BLOCK_16X16 || bsize == BLOCK_32X32);
}

static AOM_INLINE void nonrd_use_partition(AV1_COMP *cpi, ThreadData *td,
                                           TileDataEnc *tile_data,
                                           MB_MODE_INFO **mib, TOKENEXTRA **tp,
                                           int mi_row, int mi_col,
                                           BLOCK_SIZE bsize, PC_TREE *pc_tree) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  TileInfo *const tile_info = &tile_data->tile_info;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  // Only square blocks from 8x8 to 128x128 are supported
  assert(bsize >= BLOCK_8X8 && bsize <= BLOCK_128X128);
  const int bs = mi_size_wide[bsize];
  const int hbs = bs / 2;
  const PARTITION_TYPE partition =
      (bsize >= BLOCK_8X8) ? get_partition(cm, mi_row, mi_col, bsize)
                           : PARTITION_NONE;
  BLOCK_SIZE subsize = get_partition_subsize(bsize, partition);
  assert(subsize <= BLOCK_LARGEST);
  const int pl = (bsize >= BLOCK_8X8)
                     ? partition_plane_context(xd, mi_row, mi_col, bsize)
                     : 0;

  RD_STATS dummy_cost;
  av1_invalid_rd_stats(&dummy_cost);
  RD_STATS invalid_rd;
  av1_invalid_rd_stats(&invalid_rd);

  if (mi_row >= mi_params->mi_rows || mi_col >= mi_params->mi_cols) return;

  assert(mi_size_wide[bsize] == mi_size_high[bsize]);

  pc_tree->partitioning = partition;

  xd->above_txfm_context =
      cm->above_contexts.txfm[tile_info->tile_row] + mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);

  switch (partition) {
    case PARTITION_NONE:
      if (cpi->sf.rt_sf.nonrd_check_partition_split && do_slipt_check(bsize) &&
          !frame_is_intra_only(cm)) {
        RD_STATS split_rdc, none_rdc, block_rdc;
        RD_SEARCH_MACROBLOCK_CONTEXT x_ctx;

        av1_init_rd_stats(&split_rdc);
        av1_invalid_rd_stats(&none_rdc);

        save_context(x, &x_ctx, mi_row, mi_col, bsize, 3);
        subsize = get_partition_subsize(bsize, PARTITION_SPLIT);
        pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &none_rdc,
                      PARTITION_NONE, bsize, &pc_tree->none, invalid_rd,
                      PICK_MODE_NONRD);
        none_rdc.rate += x->partition_cost[pl][PARTITION_NONE];
        none_rdc.rdcost = RDCOST(x->rdmult, none_rdc.rate, none_rdc.dist);
        restore_context(x, &x_ctx, mi_row, mi_col, bsize, 3);

        for (int i = 0; i < 4; i++) {
          av1_invalid_rd_stats(&block_rdc);
          const int x_idx = (i & 1) * hbs;
          const int y_idx = (i >> 1) * hbs;
          if (mi_row + y_idx >= mi_params->mi_rows ||
              mi_col + x_idx >= mi_params->mi_cols)
            continue;
          xd->above_txfm_context =
              cm->above_contexts.txfm[tile_info->tile_row] + mi_col + x_idx;
          xd->left_txfm_context =
              xd->left_txfm_context_buffer + ((mi_row + y_idx) & MAX_MIB_MASK);
          pc_tree->split[i]->partitioning = PARTITION_NONE;
          pick_sb_modes(cpi, tile_data, x, mi_row + y_idx, mi_col + x_idx,
                        &block_rdc, PARTITION_NONE, subsize,
                        &pc_tree->split[i]->none, invalid_rd, PICK_MODE_NONRD);
          split_rdc.rate += block_rdc.rate;
          split_rdc.dist += block_rdc.dist;

          encode_b(cpi, tile_data, td, tp, mi_row + y_idx, mi_col + x_idx, 1,
                   subsize, PARTITION_NONE, &pc_tree->split[i]->none, NULL);
        }
        split_rdc.rate += x->partition_cost[pl][PARTITION_SPLIT];
        split_rdc.rdcost = RDCOST(x->rdmult, split_rdc.rate, split_rdc.dist);
        restore_context(x, &x_ctx, mi_row, mi_col, bsize, 3);

        if (none_rdc.rdcost < split_rdc.rdcost) {
          mib[0]->sb_type = bsize;
          pc_tree->partitioning = PARTITION_NONE;
          encode_b(cpi, tile_data, td, tp, mi_row, mi_col, 0, bsize, partition,
                   &pc_tree->none, NULL);
        } else {
          mib[0]->sb_type = subsize;
          pc_tree->partitioning = PARTITION_SPLIT;
          for (int i = 0; i < 4; i++) {
            const int x_idx = (i & 1) * hbs;
            const int y_idx = (i >> 1) * hbs;
            if (mi_row + y_idx >= mi_params->mi_rows ||
                mi_col + x_idx >= mi_params->mi_cols)
              continue;

            encode_b(cpi, tile_data, td, tp, mi_row + y_idx, mi_col + x_idx, 0,
                     subsize, PARTITION_NONE, &pc_tree->split[i]->none, NULL);
          }
        }

      } else {
        pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &dummy_cost,
                      PARTITION_NONE, bsize, &pc_tree->none, invalid_rd,
                      PICK_MODE_NONRD);
        encode_b(cpi, tile_data, td, tp, mi_row, mi_col, 0, bsize, partition,
                 &pc_tree->none, NULL);
      }
      break;
    case PARTITION_VERT:
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &dummy_cost,
                    PARTITION_VERT, subsize, &pc_tree->vertical[0], invalid_rd,
                    PICK_MODE_NONRD);
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, 0, subsize,
               PARTITION_VERT, &pc_tree->vertical[0], NULL);
      if (mi_col + hbs < mi_params->mi_cols && bsize > BLOCK_8X8) {
        pick_sb_modes(cpi, tile_data, x, mi_row, mi_col + hbs, &dummy_cost,
                      PARTITION_VERT, subsize, &pc_tree->vertical[1],
                      invalid_rd, PICK_MODE_NONRD);
        encode_b(cpi, tile_data, td, tp, mi_row, mi_col + hbs, 0, subsize,
                 PARTITION_VERT, &pc_tree->vertical[1], NULL);
      }
      break;
    case PARTITION_HORZ:
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &dummy_cost,
                    PARTITION_HORZ, subsize, &pc_tree->horizontal[0],
                    invalid_rd, PICK_MODE_NONRD);
      encode_b(cpi, tile_data, td, tp, mi_row, mi_col, 0, subsize,
               PARTITION_HORZ, &pc_tree->horizontal[0], NULL);

      if (mi_row + hbs < mi_params->mi_rows && bsize > BLOCK_8X8) {
        pick_sb_modes(cpi, tile_data, x, mi_row + hbs, mi_col, &dummy_cost,
                      PARTITION_HORZ, subsize, &pc_tree->horizontal[1],
                      invalid_rd, PICK_MODE_NONRD);
        encode_b(cpi, tile_data, td, tp, mi_row + hbs, mi_col, 0, subsize,
                 PARTITION_HORZ, &pc_tree->horizontal[1], NULL);
      }
      break;
    case PARTITION_SPLIT:
      if (cpi->sf.rt_sf.nonrd_check_partition_merge_mode &&
          is_leaf_split_partition(cm, mi_row, mi_col, bsize) &&
          !frame_is_intra_only(cm) && bsize <= BLOCK_32X32) {
        RD_SEARCH_MACROBLOCK_CONTEXT x_ctx;
        RD_STATS split_rdc, none_rdc;
        av1_invalid_rd_stats(&split_rdc);
        av1_invalid_rd_stats(&none_rdc);
        save_context(x, &x_ctx, mi_row, mi_col, bsize, 3);
        xd->above_txfm_context =
            cm->above_contexts.txfm[tile_info->tile_row] + mi_col;
        xd->left_txfm_context =
            xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);
        pc_tree->partitioning = PARTITION_NONE;
        pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &none_rdc,
                      PARTITION_NONE, bsize, &pc_tree->none, invalid_rd,
                      PICK_MODE_NONRD);
        none_rdc.rate += x->partition_cost[pl][PARTITION_NONE];
        none_rdc.rdcost = RDCOST(x->rdmult, none_rdc.rate, none_rdc.dist);
        restore_context(x, &x_ctx, mi_row, mi_col, bsize, 3);
        if (cpi->sf.rt_sf.nonrd_check_partition_merge_mode != 2 ||
            none_rdc.skip != 1 || pc_tree->none.mic.mode == NEWMV) {
          av1_init_rd_stats(&split_rdc);
          for (int i = 0; i < 4; i++) {
            RD_STATS block_rdc;
            av1_invalid_rd_stats(&block_rdc);
            int x_idx = (i & 1) * hbs;
            int y_idx = (i >> 1) * hbs;
            if ((mi_row + y_idx >= mi_params->mi_rows) ||
                (mi_col + x_idx >= mi_params->mi_cols))
              continue;
            xd->above_txfm_context =
                cm->above_contexts.txfm[tile_info->tile_row] + mi_col + x_idx;
            xd->left_txfm_context = xd->left_txfm_context_buffer +
                                    ((mi_row + y_idx) & MAX_MIB_MASK);
            pc_tree->split[i]->partitioning = PARTITION_NONE;
            pick_sb_modes(cpi, tile_data, x, mi_row + y_idx, mi_col + x_idx,
                          &block_rdc, PARTITION_NONE, subsize,
                          &pc_tree->split[i]->none, invalid_rd,
                          PICK_MODE_NONRD);
            split_rdc.rate += block_rdc.rate;
            split_rdc.dist += block_rdc.dist;

            encode_b(cpi, tile_data, td, tp, mi_row + y_idx, mi_col + x_idx, 1,
                     subsize, PARTITION_NONE, &pc_tree->split[i]->none, NULL);
          }
          restore_context(x, &x_ctx, mi_row, mi_col, bsize, 3);
          split_rdc.rate += x->partition_cost[pl][PARTITION_SPLIT];
          split_rdc.rdcost = RDCOST(x->rdmult, split_rdc.rate, split_rdc.dist);
        }
        if (none_rdc.rdcost < split_rdc.rdcost) {
          mib[0]->sb_type = bsize;
          pc_tree->partitioning = PARTITION_NONE;
          encode_b(cpi, tile_data, td, tp, mi_row, mi_col, 0, bsize, partition,
                   &pc_tree->none, NULL);
        } else {
          mib[0]->sb_type = subsize;
          pc_tree->partitioning = PARTITION_SPLIT;
          for (int i = 0; i < 4; i++) {
            int x_idx = (i & 1) * hbs;
            int y_idx = (i >> 1) * hbs;
            if ((mi_row + y_idx >= mi_params->mi_rows) ||
                (mi_col + x_idx >= mi_params->mi_cols))
              continue;

            encode_b(cpi, tile_data, td, tp, mi_row + y_idx, mi_col + x_idx, 0,
                     subsize, PARTITION_NONE, &pc_tree->split[i]->none, NULL);
          }
        }
      } else {
        for (int i = 0; i < 4; i++) {
          int x_idx = (i & 1) * hbs;
          int y_idx = (i >> 1) * hbs;
          int jj = i >> 1, ii = i & 0x01;
          if ((mi_row + y_idx >= mi_params->mi_rows) ||
              (mi_col + x_idx >= mi_params->mi_cols))
            continue;
          nonrd_use_partition(cpi, td, tile_data,
                              mib + jj * hbs * mi_params->mi_stride + ii * hbs,
                              tp, mi_row + y_idx, mi_col + x_idx, subsize,
                              pc_tree->split[i]);
        }
      }
      break;
    case PARTITION_VERT_A:
    case PARTITION_VERT_B:
    case PARTITION_HORZ_A:
    case PARTITION_HORZ_B:
    case PARTITION_HORZ_4:
    case PARTITION_VERT_4:
      assert(0 && "Cannot handle extended partition types");
    default: assert(0); break;
  }
}

#if !CONFIG_REALTIME_ONLY
static const FIRSTPASS_STATS *read_one_frame_stats(const TWO_PASS *p, int frm) {
  assert(frm >= 0);
  if (frm < 0 ||
      p->stats_buf_ctx->stats_in_start + frm > p->stats_buf_ctx->stats_in_end) {
    return NULL;
  }

  return &p->stats_buf_ctx->stats_in_start[frm];
}
// Checks to see if a super block is on a horizontal image edge.
// In most cases this is the "real" edge unless there are formatting
// bars embedded in the stream.
static int active_h_edge(const AV1_COMP *cpi, int mi_row, int mi_step) {
  int top_edge = 0;
  int bottom_edge = cpi->common.mi_params.mi_rows;
  int is_active_h_edge = 0;

  // For two pass account for any formatting bars detected.
  if (is_stat_consumption_stage_twopass(cpi)) {
    const AV1_COMMON *const cm = &cpi->common;
    const FIRSTPASS_STATS *const this_frame_stats = read_one_frame_stats(
        &cpi->twopass, cm->current_frame.display_order_hint);
    if (this_frame_stats == NULL) return AOM_CODEC_ERROR;

    // The inactive region is specified in MBs not mi units.
    // The image edge is in the following MB row.
    top_edge += (int)(this_frame_stats->inactive_zone_rows * 4);

    bottom_edge -= (int)(this_frame_stats->inactive_zone_rows * 4);
    bottom_edge = AOMMAX(top_edge, bottom_edge);
  }

  if (((top_edge >= mi_row) && (top_edge < (mi_row + mi_step))) ||
      ((bottom_edge >= mi_row) && (bottom_edge < (mi_row + mi_step)))) {
    is_active_h_edge = 1;
  }
  return is_active_h_edge;
}

// Checks to see if a super block is on a vertical image edge.
// In most cases this is the "real" edge unless there are formatting
// bars embedded in the stream.
static int active_v_edge(const AV1_COMP *cpi, int mi_col, int mi_step) {
  int left_edge = 0;
  int right_edge = cpi->common.mi_params.mi_cols;
  int is_active_v_edge = 0;

  // For two pass account for any formatting bars detected.
  if (is_stat_consumption_stage_twopass(cpi)) {
    const AV1_COMMON *const cm = &cpi->common;
    const FIRSTPASS_STATS *const this_frame_stats = read_one_frame_stats(
        &cpi->twopass, cm->current_frame.display_order_hint);
    if (this_frame_stats == NULL) return AOM_CODEC_ERROR;

    // The inactive region is specified in MBs not mi units.
    // The image edge is in the following MB row.
    left_edge += (int)(this_frame_stats->inactive_zone_cols * 4);

    right_edge -= (int)(this_frame_stats->inactive_zone_cols * 4);
    right_edge = AOMMAX(left_edge, right_edge);
  }

  if (((left_edge >= mi_col) && (left_edge < (mi_col + mi_step))) ||
      ((right_edge >= mi_col) && (right_edge < (mi_col + mi_step)))) {
    is_active_v_edge = 1;
  }
  return is_active_v_edge;
}
#endif  // !CONFIG_REALTIME_ONLY

static INLINE void store_pred_mv(MACROBLOCK *x, PICK_MODE_CONTEXT *ctx) {
  memcpy(ctx->pred_mv, x->pred_mv, sizeof(x->pred_mv));
}

static INLINE void load_pred_mv(MACROBLOCK *x,
                                const PICK_MODE_CONTEXT *const ctx) {
  memcpy(x->pred_mv, ctx->pred_mv, sizeof(x->pred_mv));
}

#if !CONFIG_REALTIME_ONLY
// Try searching for an encoding for the given subblock. Returns zero if the
// rdcost is already too high (to tell the caller not to bother searching for
// encodings of further subblocks)
static int rd_try_subblock(AV1_COMP *const cpi, ThreadData *td,
                           TileDataEnc *tile_data, TOKENEXTRA **tp, int is_last,
                           int mi_row, int mi_col, BLOCK_SIZE subsize,
                           RD_STATS best_rdcost, RD_STATS *sum_rdc,
                           PARTITION_TYPE partition,
                           PICK_MODE_CONTEXT *prev_ctx,
                           PICK_MODE_CONTEXT *this_ctx) {
  MACROBLOCK *const x = &td->mb;
  const int orig_mult = x->rdmult;
  setup_block_rdmult(cpi, x, mi_row, mi_col, subsize, NO_AQ, NULL);

  av1_rd_cost_update(x->rdmult, &best_rdcost);
  if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, prev_ctx);

  RD_STATS rdcost_remaining;
  av1_rd_stats_subtraction(x->rdmult, &best_rdcost, sum_rdc, &rdcost_remaining);
  RD_STATS this_rdc;
  pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &this_rdc, partition,
                subsize, this_ctx, rdcost_remaining, PICK_MODE_RD);

  if (this_rdc.rate == INT_MAX) {
    sum_rdc->rdcost = INT64_MAX;
  } else {
    sum_rdc->rate += this_rdc.rate;
    sum_rdc->dist += this_rdc.dist;
    av1_rd_cost_update(x->rdmult, sum_rdc);
  }

  if (sum_rdc->rdcost >= best_rdcost.rdcost) {
    x->rdmult = orig_mult;
    return 0;
  }

  if (!is_last) {
    update_state(cpi, td, this_ctx, mi_row, mi_col, subsize, 1);
    encode_superblock(cpi, tile_data, td, tp, DRY_RUN_NORMAL, subsize, NULL);
  }

  x->rdmult = orig_mult;
  return 1;
}

static bool rd_test_partition3(AV1_COMP *const cpi, ThreadData *td,
                               TileDataEnc *tile_data, TOKENEXTRA **tp,
                               PC_TREE *pc_tree, RD_STATS *best_rdc,
                               PICK_MODE_CONTEXT ctxs[3],
                               PICK_MODE_CONTEXT *ctx, int mi_row, int mi_col,
                               BLOCK_SIZE bsize, PARTITION_TYPE partition,
                               int mi_row0, int mi_col0, BLOCK_SIZE subsize0,
                               int mi_row1, int mi_col1, BLOCK_SIZE subsize1,
                               int mi_row2, int mi_col2, BLOCK_SIZE subsize2) {
  const MACROBLOCK *const x = &td->mb;
  const MACROBLOCKD *const xd = &x->e_mbd;
  const int pl = partition_plane_context(xd, mi_row, mi_col, bsize);
  RD_STATS sum_rdc;
  av1_init_rd_stats(&sum_rdc);
  sum_rdc.rate = x->partition_cost[pl][partition];
  sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);
  if (!rd_try_subblock(cpi, td, tile_data, tp, 0, mi_row0, mi_col0, subsize0,
                       *best_rdc, &sum_rdc, partition, ctx, &ctxs[0]))
    return false;

  if (!rd_try_subblock(cpi, td, tile_data, tp, 0, mi_row1, mi_col1, subsize1,
                       *best_rdc, &sum_rdc, partition, &ctxs[0], &ctxs[1]))
    return false;

  if (!rd_try_subblock(cpi, td, tile_data, tp, 1, mi_row2, mi_col2, subsize2,
                       *best_rdc, &sum_rdc, partition, &ctxs[1], &ctxs[2]))
    return false;

  av1_rd_cost_update(x->rdmult, &sum_rdc);
  if (sum_rdc.rdcost >= best_rdc->rdcost) return false;
  sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, sum_rdc.dist);
  if (sum_rdc.rdcost >= best_rdc->rdcost) return false;

  *best_rdc = sum_rdc;
  pc_tree->partitioning = partition;
  return true;
}

static AOM_INLINE void reset_partition(PC_TREE *pc_tree, BLOCK_SIZE bsize) {
  pc_tree->partitioning = PARTITION_NONE;
  pc_tree->none.rd_stats.skip = 0;

  if (bsize >= BLOCK_8X8) {
    BLOCK_SIZE subsize = get_partition_subsize(bsize, PARTITION_SPLIT);
    for (int idx = 0; idx < 4; ++idx)
      reset_partition(pc_tree->split[idx], subsize);
  }
}

// Record the ref frames that have been selected by square partition blocks.
static AOM_INLINE void update_picked_ref_frames_mask(MACROBLOCK *const x,
                                                     int ref_type,
                                                     BLOCK_SIZE bsize,
                                                     int mib_size, int mi_row,
                                                     int mi_col) {
  assert(mi_size_wide[bsize] == mi_size_high[bsize]);
  const int sb_size_mask = mib_size - 1;
  const int mi_row_in_sb = mi_row & sb_size_mask;
  const int mi_col_in_sb = mi_col & sb_size_mask;
  const int mi_size = mi_size_wide[bsize];
  for (int i = mi_row_in_sb; i < mi_row_in_sb + mi_size; ++i) {
    for (int j = mi_col_in_sb; j < mi_col_in_sb + mi_size; ++j) {
      x->picked_ref_frames_mask[i * 32 + j] |= 1 << ref_type;
    }
  }
}

// Structure to keep win flags for HORZ and VERT partition evaluations
typedef struct {
  bool horz_win;
  bool vert_win;
} RD_RECT_PART_WIN_INFO;

// Decide whether to evaluate the AB partition specified by part_type based on
// split and HORZ/VERT info
int evaluate_ab_partition_based_on_split(
    PC_TREE *pc_tree, PARTITION_TYPE rect_part,
    RD_RECT_PART_WIN_INFO *rect_part_win_info, int qindex, int split_idx1,
    int split_idx2) {
  int num_win = 0;
  // Threshold for number of winners
  // Conservative pruning for high quantizers
  const int num_win_thresh = AOMMIN(3 * (2 * (MAXQ - qindex) / MAXQ), 3);
  bool sub_part_win = (rect_part_win_info == NULL)
                          ? (pc_tree->partitioning == rect_part)
                          : (rect_part == PARTITION_HORZ)
                                ? rect_part_win_info->horz_win
                                : rect_part_win_info->vert_win;
  num_win += (sub_part_win) ? 1 : 0;
  num_win +=
      (pc_tree->split[split_idx1]->partitioning == PARTITION_NONE) ? 1 : 0;
  num_win +=
      (pc_tree->split[split_idx2]->partitioning == PARTITION_NONE) ? 1 : 0;
  if (num_win < num_win_thresh) {
    return 0;
  }
  return 1;
}

// Searches for the best partition pattern for a block based on the
// rate-distortion cost, and returns a bool value to indicate whether a valid
// partition pattern is found. The partition can recursively go down to
// the smallest block size.
//
// Inputs:
//     cpi: the global compressor setting
//     td: thread data
//     tile_data: tile data
//     tp: the pointer to the start token
//     mi_row: row coordinate of the block in a step size of MI_SIZE
//     mi_col: column coordinate of the block in a step size of MI_SIZE
//     bsize: block size
//     max_sq_part: the largest square block size for prediction blocks
//     min_sq_part: the smallest square block size for prediction blocks
//     rd_cost: the pointer to the final rd cost of the current block
//     best_rdc: the upper bound of rd cost for a valid partition
//     pc_tree: the pointer to the PC_TREE node storing the picked partitions
//              and mode info for the current block
//     none_rd: the pointer to the rd cost in the case of not splitting the
//              current block
//     multi_pass_mode: SB_SINGLE_PASS/SB_DRY_PASS/SB_WET_PASS
//     rect_part_win_info: the pointer to a struct storing whether horz/vert
//                         partition outperforms previously tested partitions
//
// Output:
//     a bool value indicating whether a valid partition is found
static bool rd_pick_partition(AV1_COMP *const cpi, ThreadData *td,
                              TileDataEnc *tile_data, TOKENEXTRA **tp,
                              int mi_row, int mi_col, BLOCK_SIZE bsize,
                              BLOCK_SIZE max_sq_part, BLOCK_SIZE min_sq_part,
                              RD_STATS *rd_cost, RD_STATS best_rdc,
                              PC_TREE *pc_tree, int64_t *none_rd,
                              SB_MULTI_PASS_MODE multi_pass_mode,
                              RD_RECT_PART_WIN_INFO *rect_part_win_info) {
  const AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int num_planes = av1_num_planes(cm);
  TileInfo *const tile_info = &tile_data->tile_info;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const int mi_step = mi_size_wide[bsize] / 2;
  RD_SEARCH_MACROBLOCK_CONTEXT x_ctx;
  const TOKENEXTRA *const tp_orig = *tp;
  PICK_MODE_CONTEXT *ctx_none = &pc_tree->none;
  int tmp_partition_cost[PARTITION_TYPES];
  BLOCK_SIZE subsize;
  RD_STATS this_rdc, sum_rdc;
  const int bsize_at_least_8x8 = (bsize >= BLOCK_8X8);
  int do_square_split = bsize_at_least_8x8;
  const int pl = bsize_at_least_8x8
                     ? partition_plane_context(xd, mi_row, mi_col, bsize)
                     : 0;
  const int *partition_cost = x->partition_cost[pl];

  int do_rectangular_split = cpi->oxcf.enable_rect_partitions;
  int64_t cur_none_rd = 0;
  int64_t split_rd[4] = { 0, 0, 0, 0 };
  int64_t horz_rd[2] = { 0, 0 };
  int64_t vert_rd[2] = { 0, 0 };
  int prune_horz = 0;
  int prune_vert = 0;
  int terminate_partition_search = 0;

  int split_ctx_is_ready[2] = { 0, 0 };
  int horz_ctx_is_ready = 0;
  int vert_ctx_is_ready = 0;
  BLOCK_SIZE bsize2 = get_partition_subsize(bsize, PARTITION_SPLIT);
  // Initialise HORZ and VERT win flags as true for all split partitions
  RD_RECT_PART_WIN_INFO split_part_rect_win[4] = {
    { true, true }, { true, true }, { true, true }, { true, true }
  };

  bool found_best_partition = false;
  if (best_rdc.rdcost < 0) {
    av1_invalid_rd_stats(rd_cost);
    return found_best_partition;
  }

  if (frame_is_intra_only(cm) && bsize == BLOCK_64X64) {
    x->quad_tree_idx = 0;
    x->cnn_output_valid = 0;
  }

  if (bsize == cm->seq_params.sb_size) x->must_find_valid_partition = 0;

  // Override skipping rectangular partition operations for edge blocks
  const int has_rows = (mi_row + mi_step < mi_params->mi_rows);
  const int has_cols = (mi_col + mi_step < mi_params->mi_cols);
  const int xss = x->e_mbd.plane[1].subsampling_x;
  const int yss = x->e_mbd.plane[1].subsampling_y;

  if (none_rd) *none_rd = 0;
  int partition_none_allowed = has_rows && has_cols;
  int partition_horz_allowed =
      has_cols && bsize_at_least_8x8 && cpi->oxcf.enable_rect_partitions &&
      get_plane_block_size(get_partition_subsize(bsize, PARTITION_HORZ), xss,
                           yss) != BLOCK_INVALID;
  int partition_vert_allowed =
      has_rows && bsize_at_least_8x8 && cpi->oxcf.enable_rect_partitions &&
      get_plane_block_size(get_partition_subsize(bsize, PARTITION_VERT), xss,
                           yss) != BLOCK_INVALID;

  (void)*tp_orig;

#if CONFIG_COLLECT_PARTITION_STATS
  int partition_decisions[EXT_PARTITION_TYPES] = { 0 };
  int partition_attempts[EXT_PARTITION_TYPES] = { 0 };
  int64_t partition_times[EXT_PARTITION_TYPES] = { 0 };
  struct aom_usec_timer partition_timer = { 0 };
  int partition_timer_on = 0;
#if CONFIG_COLLECT_PARTITION_STATS == 2
  PartitionStats *part_stats = &cpi->partition_stats;
#endif
#endif

  // Override partition costs at the edges of the frame in the same
  // way as in read_partition (see decodeframe.c)
  if (!(has_rows && has_cols)) {
    assert(bsize_at_least_8x8 && pl >= 0);
    const aom_cdf_prob *partition_cdf = cm->fc->partition_cdf[pl];
    const int max_cost = av1_cost_symbol(0);
    for (int i = 0; i < PARTITION_TYPES; ++i) tmp_partition_cost[i] = max_cost;
    if (has_cols) {
      // At the bottom, the two possibilities are HORZ and SPLIT
      aom_cdf_prob bot_cdf[2];
      partition_gather_vert_alike(bot_cdf, partition_cdf, bsize);
      static const int bot_inv_map[2] = { PARTITION_HORZ, PARTITION_SPLIT };
      av1_cost_tokens_from_cdf(tmp_partition_cost, bot_cdf, bot_inv_map);
    } else if (has_rows) {
      // At the right, the two possibilities are VERT and SPLIT
      aom_cdf_prob rhs_cdf[2];
      partition_gather_horz_alike(rhs_cdf, partition_cdf, bsize);
      static const int rhs_inv_map[2] = { PARTITION_VERT, PARTITION_SPLIT };
      av1_cost_tokens_from_cdf(tmp_partition_cost, rhs_cdf, rhs_inv_map);
    } else {
      // At the bottom right, we always split
      tmp_partition_cost[PARTITION_SPLIT] = 0;
    }

    partition_cost = tmp_partition_cost;
  }

#ifndef NDEBUG
  // Nothing should rely on the default value of this array (which is just
  // leftover from encoding the previous block. Setting it to fixed pattern
  // when debugging.
  // bit 0, 1, 2 are blk_skip of each plane
  // bit 4, 5, 6 are initialization checking of each plane
  memset(x->blk_skip, 0x77, sizeof(x->blk_skip));
#endif  // NDEBUG

  assert(mi_size_wide[bsize] == mi_size_high[bsize]);

  av1_init_rd_stats(&this_rdc);

  set_offsets(cpi, tile_info, x, mi_row, mi_col, bsize);

  // Save rdmult before it might be changed, so it can be restored later.
  const int orig_rdmult = x->rdmult;
  setup_block_rdmult(cpi, x, mi_row, mi_col, bsize, NO_AQ, NULL);

  av1_rd_cost_update(x->rdmult, &best_rdc);

  if (bsize == BLOCK_16X16 && cpi->vaq_refresh)
    x->mb_energy = av1_log_block_var(cpi, x, bsize);

  if (bsize > cpi->sf.part_sf.use_square_partition_only_threshold) {
    partition_horz_allowed &= !has_rows;
    partition_vert_allowed &= !has_cols;
  }

  xd->above_txfm_context =
      cm->above_contexts.txfm[tile_info->tile_row] + mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);
  save_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);

  const int try_intra_cnn_split =
      !cpi->is_screen_content_type && frame_is_intra_only(cm) &&
      cpi->sf.part_sf.intra_cnn_split &&
      cm->seq_params.sb_size >= BLOCK_64X64 && bsize <= BLOCK_64X64 &&
      bsize >= BLOCK_8X8 &&
      mi_row + mi_size_high[bsize] <= mi_params->mi_rows &&
      mi_col + mi_size_wide[bsize] <= mi_params->mi_cols;

  if (try_intra_cnn_split) {
    av1_intra_mode_cnn_partition(
        &cpi->common, x, bsize, x->quad_tree_idx, &partition_none_allowed,
        &partition_horz_allowed, &partition_vert_allowed, &do_rectangular_split,
        &do_square_split);
  }

  // Use simple_motion_search to prune partitions. This must be done prior to
  // PARTITION_SPLIT to propagate the initial mvs to a smaller blocksize.
  const int try_split_only =
      !cpi->is_screen_content_type &&
      cpi->sf.part_sf.simple_motion_search_split && do_square_split &&
      bsize >= BLOCK_8X8 &&
      mi_row + mi_size_high[bsize] <= mi_params->mi_rows &&
      mi_col + mi_size_wide[bsize] <= mi_params->mi_cols &&
      !frame_is_intra_only(cm) && !av1_superres_scaled(cm);

  if (try_split_only) {
    av1_simple_motion_search_based_split(
        cpi, x, pc_tree, mi_row, mi_col, bsize, &partition_none_allowed,
        &partition_horz_allowed, &partition_vert_allowed, &do_rectangular_split,
        &do_square_split);
  }

  const int try_prune_rect =
      !cpi->is_screen_content_type &&
      cpi->sf.part_sf.simple_motion_search_prune_rect &&
      !frame_is_intra_only(cm) && do_rectangular_split &&
      (do_square_split || partition_none_allowed ||
       (prune_horz && prune_vert)) &&
      (partition_horz_allowed || partition_vert_allowed) && bsize >= BLOCK_8X8;

  if (try_prune_rect) {
    av1_simple_motion_search_prune_rect(
        cpi, x, pc_tree, mi_row, mi_col, bsize, &partition_horz_allowed,
        &partition_vert_allowed, &prune_horz, &prune_vert);
  }

  // Max and min square partition levels are defined as the partition nodes that
  // the recursive function rd_pick_partition() can reach. To implement this:
  // only PARTITION_NONE is allowed if the current node equals min_sq_part,
  // only PARTITION_SPLIT is allowed if the current node exceeds max_sq_part.
  assert(block_size_wide[min_sq_part] == block_size_high[min_sq_part]);
  assert(block_size_wide[max_sq_part] == block_size_high[max_sq_part]);
  assert(min_sq_part <= max_sq_part);
  assert(block_size_wide[bsize] == block_size_high[bsize]);
  const int max_partition_size = block_size_wide[max_sq_part];
  const int min_partition_size = block_size_wide[min_sq_part];
  const int blksize = block_size_wide[bsize];
  assert(min_partition_size <= max_partition_size);
  const int is_le_min_sq_part = blksize <= min_partition_size;
  const int is_gt_max_sq_part = blksize > max_partition_size;
  if (is_gt_max_sq_part) {
    // If current block size is larger than max, only allow split.
    partition_none_allowed = 0;
    partition_horz_allowed = 0;
    partition_vert_allowed = 0;
    do_square_split = 1;
  } else if (is_le_min_sq_part) {
    // If current block size is less or equal to min, only allow none if valid
    // block large enough; only allow split otherwise.
    partition_horz_allowed = 0;
    partition_vert_allowed = 0;
    // only disable square split when current block is not at the picture
    // boundary. otherwise, inherit the square split flag from previous logic
    if (has_rows && has_cols) do_square_split = 0;
    partition_none_allowed = !do_square_split;
  }

BEGIN_PARTITION_SEARCH:
  if (x->must_find_valid_partition) {
    do_square_split = bsize_at_least_8x8 && (blksize > min_partition_size);
    partition_none_allowed =
        has_rows && has_cols && (blksize >= min_partition_size);
    partition_horz_allowed =
        has_cols && bsize_at_least_8x8 && cpi->oxcf.enable_rect_partitions &&
        (blksize > min_partition_size) &&
        get_plane_block_size(get_partition_subsize(bsize, PARTITION_HORZ), xss,
                             yss) != BLOCK_INVALID;
    partition_vert_allowed =
        has_rows && bsize_at_least_8x8 && cpi->oxcf.enable_rect_partitions &&
        (blksize > min_partition_size) &&
        get_plane_block_size(get_partition_subsize(bsize, PARTITION_VERT), xss,
                             yss) != BLOCK_INVALID;
    terminate_partition_search = 0;
  }

  // Partition block source pixel variance.
  unsigned int pb_source_variance = UINT_MAX;

  // Partition block sse after simple motion compensation, not in use now,
  // but will be used for upcoming speed features
  unsigned int pb_simple_motion_pred_sse = UINT_MAX;
  (void)pb_simple_motion_pred_sse;

  // PARTITION_NONE
  if (is_le_min_sq_part && has_rows && has_cols) partition_none_allowed = 1;
  assert(terminate_partition_search == 0);
  int64_t part_none_rd = INT64_MAX;
  if (cpi->is_screen_content_type)
    partition_none_allowed = has_rows && has_cols;
  if (partition_none_allowed && !is_gt_max_sq_part) {
    int pt_cost = 0;
    if (bsize_at_least_8x8) {
      pt_cost = partition_cost[PARTITION_NONE] < INT_MAX
                    ? partition_cost[PARTITION_NONE]
                    : 0;
    }
    RD_STATS partition_rdcost;
    av1_init_rd_stats(&partition_rdcost);
    partition_rdcost.rate = pt_cost;
    av1_rd_cost_update(x->rdmult, &partition_rdcost);
    RD_STATS best_remain_rdcost;
    av1_rd_stats_subtraction(x->rdmult, &best_rdc, &partition_rdcost,
                             &best_remain_rdcost);
#if CONFIG_COLLECT_PARTITION_STATS
    if (best_remain_rdcost >= 0) {
      partition_attempts[PARTITION_NONE] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &this_rdc, PARTITION_NONE,
                  bsize, ctx_none, best_remain_rdcost, PICK_MODE_RD);
    av1_rd_cost_update(x->rdmult, &this_rdc);
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_NONE] += time;
      partition_timer_on = 0;
    }
#endif
    pb_source_variance = x->source_variance;
    pb_simple_motion_pred_sse = x->simple_motion_pred_sse;
    if (none_rd) *none_rd = this_rdc.rdcost;
    cur_none_rd = this_rdc.rdcost;
    if (this_rdc.rate != INT_MAX) {
      if (cpi->sf.inter_sf.prune_ref_frame_for_rect_partitions) {
        const int ref_type = av1_ref_frame_type(ctx_none->mic.ref_frame);
        update_picked_ref_frames_mask(x, ref_type, bsize,
                                      cm->seq_params.mib_size, mi_row, mi_col);
      }
      if (bsize_at_least_8x8) {
        this_rdc.rate += pt_cost;
        this_rdc.rdcost = RDCOST(x->rdmult, this_rdc.rate, this_rdc.dist);
      }

      part_none_rd = this_rdc.rdcost;
      if (this_rdc.rdcost < best_rdc.rdcost) {
        // Adjust dist breakout threshold according to the partition size.
        const int64_t dist_breakout_thr =
            cpi->sf.part_sf.partition_search_breakout_dist_thr >>
            ((2 * (MAX_SB_SIZE_LOG2 - 2)) -
             (mi_size_wide_log2[bsize] + mi_size_high_log2[bsize]));
        const int rate_breakout_thr =
            cpi->sf.part_sf.partition_search_breakout_rate_thr *
            num_pels_log2_lookup[bsize];

        best_rdc = this_rdc;
        found_best_partition = true;
        if (bsize_at_least_8x8) pc_tree->partitioning = PARTITION_NONE;

        if (!frame_is_intra_only(cm) &&
            (do_square_split || do_rectangular_split) &&
            !x->e_mbd.lossless[xd->mi[0]->segment_id] && ctx_none->skippable) {
          const int use_ml_based_breakout =
              bsize <= cpi->sf.part_sf.use_square_partition_only_threshold &&
              bsize > BLOCK_4X4 && xd->bd == 8;
          if (use_ml_based_breakout) {
            if (av1_ml_predict_breakout(cpi, bsize, x, &this_rdc,
                                        pb_source_variance)) {
              do_square_split = 0;
              do_rectangular_split = 0;
            }
          }

          // If all y, u, v transform blocks in this partition are skippable,
          // and the dist & rate are within the thresholds, the partition
          // search is terminated for current branch of the partition search
          // tree. The dist & rate thresholds are set to 0 at speed 0 to
          // disable the early termination at that speed.
          if (best_rdc.dist < dist_breakout_thr &&
              best_rdc.rate < rate_breakout_thr) {
            do_square_split = 0;
            do_rectangular_split = 0;
          }
        }

        if (cpi->sf.part_sf.simple_motion_search_early_term_none &&
            cm->show_frame && !frame_is_intra_only(cm) &&
            bsize >= BLOCK_16X16 && mi_row + mi_step < mi_params->mi_rows &&
            mi_col + mi_step < mi_params->mi_cols &&
            this_rdc.rdcost < INT64_MAX && this_rdc.rdcost >= 0 &&
            this_rdc.rate < INT_MAX && this_rdc.rate >= 0 &&
            (do_square_split || do_rectangular_split)) {
          av1_simple_motion_search_early_term_none(cpi, x, pc_tree, mi_row,
                                                   mi_col, bsize, &this_rdc,
                                                   &terminate_partition_search);
        }
      }
    }

    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  // store estimated motion vector
  if (cpi->sf.mv_sf.adaptive_motion_search) store_pred_mv(x, ctx_none);

  // PARTITION_SPLIT
  int64_t part_split_rd = INT64_MAX;
  if ((!terminate_partition_search && do_square_split) || is_gt_max_sq_part) {
    av1_init_rd_stats(&sum_rdc);
    subsize = get_partition_subsize(bsize, PARTITION_SPLIT);
    sum_rdc.rate = partition_cost[PARTITION_SPLIT];
    sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);

    int idx;
#if CONFIG_COLLECT_PARTITION_STATS
    if (best_rdc.rdcost - sum_rdc.rdcost >= 0) {
      partition_attempts[PARTITION_SPLIT] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    for (idx = 0; idx < 4 && sum_rdc.rdcost < best_rdc.rdcost; ++idx) {
      const int x_idx = (idx & 1) * mi_step;
      const int y_idx = (idx >> 1) * mi_step;

      if (mi_row + y_idx >= mi_params->mi_rows ||
          mi_col + x_idx >= mi_params->mi_cols)
        continue;

      if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, ctx_none);

      pc_tree->split[idx]->index = idx;
      int64_t *p_split_rd = &split_rd[idx];

      RD_STATS best_remain_rdcost;
      av1_rd_stats_subtraction(x->rdmult, &best_rdc, &sum_rdc,
                               &best_remain_rdcost);

      int curr_quad_tree_idx = 0;
      if (frame_is_intra_only(cm) && bsize <= BLOCK_64X64) {
        curr_quad_tree_idx = x->quad_tree_idx;
        x->quad_tree_idx = 4 * curr_quad_tree_idx + idx + 1;
      }
      if (!rd_pick_partition(cpi, td, tile_data, tp, mi_row + y_idx,
                             mi_col + x_idx, subsize, max_sq_part, min_sq_part,
                             &this_rdc, best_remain_rdcost, pc_tree->split[idx],
                             p_split_rd, multi_pass_mode,
                             &split_part_rect_win[idx])) {
        av1_invalid_rd_stats(&sum_rdc);
        break;
      }
      if (frame_is_intra_only(cm) && bsize <= BLOCK_64X64) {
        x->quad_tree_idx = curr_quad_tree_idx;
      }

      sum_rdc.rate += this_rdc.rate;
      sum_rdc.dist += this_rdc.dist;
      av1_rd_cost_update(x->rdmult, &sum_rdc);
      if (idx <= 1 && (bsize <= BLOCK_8X8 ||
                       pc_tree->split[idx]->partitioning == PARTITION_NONE)) {
        const MB_MODE_INFO *const mbmi = &pc_tree->split[idx]->none.mic;
        const PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
        // Neither palette mode nor cfl predicted
        if (pmi->palette_size[0] == 0 && pmi->palette_size[1] == 0) {
          if (mbmi->uv_mode != UV_CFL_PRED) split_ctx_is_ready[idx] = 1;
        }
      }
    }
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_SPLIT] += time;
      partition_timer_on = 0;
    }
#endif
    const int reached_last_index = (idx == 4);

    part_split_rd = sum_rdc.rdcost;
    if (reached_last_index && sum_rdc.rdcost < best_rdc.rdcost) {
      sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, sum_rdc.dist);
      if (sum_rdc.rdcost < best_rdc.rdcost) {
        best_rdc = sum_rdc;
        found_best_partition = true;
        pc_tree->partitioning = PARTITION_SPLIT;
      }
    } else if (cpi->sf.part_sf.less_rectangular_check_level > 0) {
      // Skip rectangular partition test when partition type none gives better
      // rd than partition type split.
      if (cpi->sf.part_sf.less_rectangular_check_level == 2 || idx <= 2) {
        const int partition_none_valid = cur_none_rd > 0;
        const int partition_none_better = cur_none_rd < sum_rdc.rdcost;
        do_rectangular_split &=
            !(partition_none_valid && partition_none_better);
      }
    }

    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }  // if (do_split)

  if (cpi->sf.part_sf.ml_early_term_after_part_split_level &&
      !frame_is_intra_only(cm) && !terminate_partition_search &&
      do_rectangular_split &&
      (partition_horz_allowed || partition_vert_allowed)) {
    av1_ml_early_term_after_split(cpi, x, pc_tree, bsize, best_rdc.rdcost,
                                  part_none_rd, part_split_rd, split_rd, mi_row,
                                  mi_col, &terminate_partition_search);
  }

  if (!cpi->sf.part_sf.ml_early_term_after_part_split_level &&
      cpi->sf.part_sf.ml_prune_rect_partition && !frame_is_intra_only(cm) &&
      (partition_horz_allowed || partition_vert_allowed) &&
      !(prune_horz || prune_vert) && !terminate_partition_search) {
    av1_setup_src_planes(x, cpi->source, mi_row, mi_col, num_planes, bsize);
    av1_ml_prune_rect_partition(cpi, x, bsize, best_rdc.rdcost, cur_none_rd,
                                split_rd, &prune_horz, &prune_vert);
  }

  // PARTITION_HORZ
  assert(IMPLIES(!cpi->oxcf.enable_rect_partitions, !partition_horz_allowed));
  if (!terminate_partition_search && partition_horz_allowed && !prune_horz &&
      (do_rectangular_split || active_h_edge(cpi, mi_row, mi_step)) &&
      !is_gt_max_sq_part) {
    av1_init_rd_stats(&sum_rdc);
    subsize = get_partition_subsize(bsize, PARTITION_HORZ);
    if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, ctx_none);
    sum_rdc.rate = partition_cost[PARTITION_HORZ];
    sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);
    RD_STATS best_remain_rdcost;
    av1_rd_stats_subtraction(x->rdmult, &best_rdc, &sum_rdc,
                             &best_remain_rdcost);
#if CONFIG_COLLECT_PARTITION_STATS
    if (best_remain_rdcost >= 0) {
      partition_attempts[PARTITION_HORZ] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &this_rdc, PARTITION_HORZ,
                  subsize, &pc_tree->horizontal[0], best_remain_rdcost,
                  PICK_MODE_RD);
    av1_rd_cost_update(x->rdmult, &this_rdc);

    if (this_rdc.rate == INT_MAX) {
      sum_rdc.rdcost = INT64_MAX;
    } else {
      sum_rdc.rate += this_rdc.rate;
      sum_rdc.dist += this_rdc.dist;
      av1_rd_cost_update(x->rdmult, &sum_rdc);
    }
    horz_rd[0] = this_rdc.rdcost;

    if (sum_rdc.rdcost < best_rdc.rdcost && has_rows) {
      const PICK_MODE_CONTEXT *const ctx_h = &pc_tree->horizontal[0];
      const MB_MODE_INFO *const mbmi = &pc_tree->horizontal[0].mic;
      const PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
      // Neither palette mode nor cfl predicted
      if (pmi->palette_size[0] == 0 && pmi->palette_size[1] == 0) {
        if (mbmi->uv_mode != UV_CFL_PRED) horz_ctx_is_ready = 1;
      }
      update_state(cpi, td, ctx_h, mi_row, mi_col, subsize, 1);
      encode_superblock(cpi, tile_data, td, tp, DRY_RUN_NORMAL, subsize, NULL);

      if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, ctx_h);

      av1_rd_stats_subtraction(x->rdmult, &best_rdc, &sum_rdc,
                               &best_remain_rdcost);

      pick_sb_modes(cpi, tile_data, x, mi_row + mi_step, mi_col, &this_rdc,
                    PARTITION_HORZ, subsize, &pc_tree->horizontal[1],
                    best_remain_rdcost, PICK_MODE_RD);
      av1_rd_cost_update(x->rdmult, &this_rdc);
      horz_rd[1] = this_rdc.rdcost;

      if (this_rdc.rate == INT_MAX) {
        sum_rdc.rdcost = INT64_MAX;
      } else {
        sum_rdc.rate += this_rdc.rate;
        sum_rdc.dist += this_rdc.dist;
        av1_rd_cost_update(x->rdmult, &sum_rdc);
      }
    }
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_HORZ] += time;
      partition_timer_on = 0;
    }
#endif

    if (sum_rdc.rdcost < best_rdc.rdcost) {
      sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, sum_rdc.dist);
      if (sum_rdc.rdcost < best_rdc.rdcost) {
        best_rdc = sum_rdc;
        found_best_partition = true;
        pc_tree->partitioning = PARTITION_HORZ;
      }
    } else {
      // Update HORZ win flag
      if (rect_part_win_info != NULL) {
        rect_part_win_info->horz_win = false;
      }
    }

    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  // PARTITION_VERT
  assert(IMPLIES(!cpi->oxcf.enable_rect_partitions, !partition_vert_allowed));
  if (!terminate_partition_search && partition_vert_allowed && !prune_vert &&
      (do_rectangular_split || active_v_edge(cpi, mi_col, mi_step)) &&
      !is_gt_max_sq_part) {
    av1_init_rd_stats(&sum_rdc);
    subsize = get_partition_subsize(bsize, PARTITION_VERT);

    if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, ctx_none);

    sum_rdc.rate = partition_cost[PARTITION_VERT];
    sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);
    RD_STATS best_remain_rdcost;
    av1_rd_stats_subtraction(x->rdmult, &best_rdc, &sum_rdc,
                             &best_remain_rdcost);
#if CONFIG_COLLECT_PARTITION_STATS
    if (best_remain_rdcost >= 0) {
      partition_attempts[PARTITION_VERT] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    pick_sb_modes(cpi, tile_data, x, mi_row, mi_col, &this_rdc, PARTITION_VERT,
                  subsize, &pc_tree->vertical[0], best_remain_rdcost,
                  PICK_MODE_RD);
    av1_rd_cost_update(x->rdmult, &this_rdc);

    if (this_rdc.rate == INT_MAX) {
      sum_rdc.rdcost = INT64_MAX;
    } else {
      sum_rdc.rate += this_rdc.rate;
      sum_rdc.dist += this_rdc.dist;
      av1_rd_cost_update(x->rdmult, &sum_rdc);
    }
    vert_rd[0] = this_rdc.rdcost;
    if (sum_rdc.rdcost < best_rdc.rdcost && has_cols) {
      const MB_MODE_INFO *const mbmi = &pc_tree->vertical[0].mic;
      const PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
      // Neither palette mode nor cfl predicted
      if (pmi->palette_size[0] == 0 && pmi->palette_size[1] == 0) {
        if (mbmi->uv_mode != UV_CFL_PRED) vert_ctx_is_ready = 1;
      }
      update_state(cpi, td, &pc_tree->vertical[0], mi_row, mi_col, subsize, 1);
      encode_superblock(cpi, tile_data, td, tp, DRY_RUN_NORMAL, subsize, NULL);

      if (cpi->sf.mv_sf.adaptive_motion_search) load_pred_mv(x, ctx_none);

      av1_rd_stats_subtraction(x->rdmult, &best_rdc, &sum_rdc,
                               &best_remain_rdcost);
      pick_sb_modes(cpi, tile_data, x, mi_row, mi_col + mi_step, &this_rdc,
                    PARTITION_VERT, subsize, &pc_tree->vertical[1],
                    best_remain_rdcost, PICK_MODE_RD);
      av1_rd_cost_update(x->rdmult, &this_rdc);
      vert_rd[1] = this_rdc.rdcost;

      if (this_rdc.rate == INT_MAX) {
        sum_rdc.rdcost = INT64_MAX;
      } else {
        sum_rdc.rate += this_rdc.rate;
        sum_rdc.dist += this_rdc.dist;
        av1_rd_cost_update(x->rdmult, &sum_rdc);
      }
    }
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_VERT] += time;
      partition_timer_on = 0;
    }
#endif

    av1_rd_cost_update(x->rdmult, &sum_rdc);
    if (sum_rdc.rdcost < best_rdc.rdcost) {
      best_rdc = sum_rdc;
      found_best_partition = true;
      pc_tree->partitioning = PARTITION_VERT;
    } else {
      // Update VERT win flag
      if (rect_part_win_info != NULL) {
        rect_part_win_info->vert_win = false;
      }
    }

    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  if (pb_source_variance == UINT_MAX) {
    av1_setup_src_planes(x, cpi->source, mi_row, mi_col, num_planes, bsize);
    if (is_cur_buf_hbd(xd)) {
      pb_source_variance = av1_high_get_sby_perpixel_variance(
          cpi, &x->plane[0].src, bsize, xd->bd);
    } else {
      pb_source_variance =
          av1_get_sby_perpixel_variance(cpi, &x->plane[0].src, bsize);
    }
  }

  if (use_pb_simple_motion_pred_sse(cpi) &&
      pb_simple_motion_pred_sse == UINT_MAX) {
    const FULLPEL_MV start_mv = kZeroFullMv;
    unsigned int var = 0;

    av1_simple_motion_sse_var(cpi, x, mi_row, mi_col, bsize, start_mv, 0,
                              &pb_simple_motion_pred_sse, &var);
  }

  assert(IMPLIES(!cpi->oxcf.enable_rect_partitions, !do_rectangular_split));

  const int ext_partition_allowed =
      do_rectangular_split &&
      bsize > cpi->sf.part_sf.ext_partition_eval_thresh && has_rows && has_cols;

  // The standard AB partitions are allowed whenever ext-partition-types are
  // allowed
  int horzab_partition_allowed =
      ext_partition_allowed & cpi->oxcf.enable_ab_partitions;
  int vertab_partition_allowed =
      ext_partition_allowed & cpi->oxcf.enable_ab_partitions;

  if (cpi->sf.part_sf.prune_ext_partition_types_search_level) {
    if (cpi->sf.part_sf.prune_ext_partition_types_search_level == 1) {
      // TODO(debargha,huisu@google.com): may need to tune the threshold for
      // pb_source_variance.
      horzab_partition_allowed &= (pc_tree->partitioning == PARTITION_HORZ ||
                                   (pc_tree->partitioning == PARTITION_NONE &&
                                    pb_source_variance < 32) ||
                                   pc_tree->partitioning == PARTITION_SPLIT);
      vertab_partition_allowed &= (pc_tree->partitioning == PARTITION_VERT ||
                                   (pc_tree->partitioning == PARTITION_NONE &&
                                    pb_source_variance < 32) ||
                                   pc_tree->partitioning == PARTITION_SPLIT);
    } else {
      horzab_partition_allowed &= (pc_tree->partitioning == PARTITION_HORZ ||
                                   pc_tree->partitioning == PARTITION_SPLIT);
      vertab_partition_allowed &= (pc_tree->partitioning == PARTITION_VERT ||
                                   pc_tree->partitioning == PARTITION_SPLIT);
    }
    horz_rd[0] = (horz_rd[0] < INT64_MAX ? horz_rd[0] : 0);
    horz_rd[1] = (horz_rd[1] < INT64_MAX ? horz_rd[1] : 0);
    vert_rd[0] = (vert_rd[0] < INT64_MAX ? vert_rd[0] : 0);
    vert_rd[1] = (vert_rd[1] < INT64_MAX ? vert_rd[1] : 0);
    split_rd[0] = (split_rd[0] < INT64_MAX ? split_rd[0] : 0);
    split_rd[1] = (split_rd[1] < INT64_MAX ? split_rd[1] : 0);
    split_rd[2] = (split_rd[2] < INT64_MAX ? split_rd[2] : 0);
    split_rd[3] = (split_rd[3] < INT64_MAX ? split_rd[3] : 0);
  }
  int horza_partition_allowed = horzab_partition_allowed;
  int horzb_partition_allowed = horzab_partition_allowed;
  if (cpi->sf.part_sf.prune_ext_partition_types_search_level) {
    const int64_t horz_a_rd = horz_rd[1] + split_rd[0] + split_rd[1];
    const int64_t horz_b_rd = horz_rd[0] + split_rd[2] + split_rd[3];
    switch (cpi->sf.part_sf.prune_ext_partition_types_search_level) {
      case 1:
        horza_partition_allowed &= (horz_a_rd / 16 * 14 < best_rdc.rdcost);
        horzb_partition_allowed &= (horz_b_rd / 16 * 14 < best_rdc.rdcost);
        break;
      case 2:
      default:
        horza_partition_allowed &= (horz_a_rd / 16 * 15 < best_rdc.rdcost);
        horzb_partition_allowed &= (horz_b_rd / 16 * 15 < best_rdc.rdcost);
        break;
    }
  }

  int verta_partition_allowed = vertab_partition_allowed;
  int vertb_partition_allowed = vertab_partition_allowed;
  if (cpi->sf.part_sf.prune_ext_partition_types_search_level) {
    const int64_t vert_a_rd = vert_rd[1] + split_rd[0] + split_rd[2];
    const int64_t vert_b_rd = vert_rd[0] + split_rd[1] + split_rd[3];
    switch (cpi->sf.part_sf.prune_ext_partition_types_search_level) {
      case 1:
        verta_partition_allowed &= (vert_a_rd / 16 * 14 < best_rdc.rdcost);
        vertb_partition_allowed &= (vert_b_rd / 16 * 14 < best_rdc.rdcost);
        break;
      case 2:
      default:
        verta_partition_allowed &= (vert_a_rd / 16 * 15 < best_rdc.rdcost);
        vertb_partition_allowed &= (vert_b_rd / 16 * 15 < best_rdc.rdcost);
        break;
    }
  }

  if (cpi->sf.part_sf.ml_prune_ab_partition && ext_partition_allowed &&
      partition_horz_allowed && partition_vert_allowed) {
    // TODO(huisu@google.com): x->source_variance may not be the current
    // block's variance. The correct one to use is pb_source_variance. Need to
    // re-train the model to fix it.
    av1_ml_prune_ab_partition(
        bsize, pc_tree->partitioning, get_unsigned_bits(x->source_variance),
        best_rdc.rdcost, horz_rd, vert_rd, split_rd, &horza_partition_allowed,
        &horzb_partition_allowed, &verta_partition_allowed,
        &vertb_partition_allowed);
  }

  horza_partition_allowed &= cpi->oxcf.enable_ab_partitions;
  horzb_partition_allowed &= cpi->oxcf.enable_ab_partitions;
  verta_partition_allowed &= cpi->oxcf.enable_ab_partitions;
  vertb_partition_allowed &= cpi->oxcf.enable_ab_partitions;

  if (cpi->sf.part_sf.prune_ab_partition_using_split_info &&
      horza_partition_allowed) {
    horza_partition_allowed &= evaluate_ab_partition_based_on_split(
        pc_tree, PARTITION_HORZ, rect_part_win_info, x->qindex, 0, 1);
  }

  // PARTITION_HORZ_A
  if (!terminate_partition_search && partition_horz_allowed &&
      horza_partition_allowed && !is_gt_max_sq_part) {
    subsize = get_partition_subsize(bsize, PARTITION_HORZ_A);
    pc_tree->horizontala[0].rd_mode_is_ready = 0;
    pc_tree->horizontala[1].rd_mode_is_ready = 0;
    pc_tree->horizontala[2].rd_mode_is_ready = 0;
    if (split_ctx_is_ready[0]) {
      av1_copy_tree_context(&pc_tree->horizontala[0], &pc_tree->split[0]->none);
      pc_tree->horizontala[0].mic.partition = PARTITION_HORZ_A;
      pc_tree->horizontala[0].rd_mode_is_ready = 1;
      if (split_ctx_is_ready[1]) {
        av1_copy_tree_context(&pc_tree->horizontala[1],
                              &pc_tree->split[1]->none);
        pc_tree->horizontala[1].mic.partition = PARTITION_HORZ_A;
        pc_tree->horizontala[1].rd_mode_is_ready = 1;
      }
    }
#if CONFIG_COLLECT_PARTITION_STATS
    {
      RD_STATS tmp_sum_rdc;
      av1_init_rd_stats(&tmp_sum_rdc);
      tmp_sum_rdc.rate = x->partition_cost[pl][PARTITION_HORZ_A];
      tmp_sum_rdc.rdcost = RDCOST(x->rdmult, tmp_sum_rdc.rate, 0);
      if (best_rdc.rdcost - tmp_sum_rdc.rdcost >= 0) {
        partition_attempts[PARTITION_HORZ_A] += 1;
        aom_usec_timer_start(&partition_timer);
        partition_timer_on = 1;
      }
    }
#endif
    found_best_partition |= rd_test_partition3(
        cpi, td, tile_data, tp, pc_tree, &best_rdc, pc_tree->horizontala,
        ctx_none, mi_row, mi_col, bsize, PARTITION_HORZ_A, mi_row, mi_col,
        bsize2, mi_row, mi_col + mi_step, bsize2, mi_row + mi_step, mi_col,
        subsize);
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_HORZ_A] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  if (cpi->sf.part_sf.prune_ab_partition_using_split_info &&
      horzb_partition_allowed) {
    horzb_partition_allowed &= evaluate_ab_partition_based_on_split(
        pc_tree, PARTITION_HORZ, rect_part_win_info, x->qindex, 2, 3);
  }

  // PARTITION_HORZ_B
  if (!terminate_partition_search && partition_horz_allowed &&
      horzb_partition_allowed && !is_gt_max_sq_part) {
    subsize = get_partition_subsize(bsize, PARTITION_HORZ_B);
    pc_tree->horizontalb[0].rd_mode_is_ready = 0;
    pc_tree->horizontalb[1].rd_mode_is_ready = 0;
    pc_tree->horizontalb[2].rd_mode_is_ready = 0;
    if (horz_ctx_is_ready) {
      av1_copy_tree_context(&pc_tree->horizontalb[0], &pc_tree->horizontal[0]);
      pc_tree->horizontalb[0].mic.partition = PARTITION_HORZ_B;
      pc_tree->horizontalb[0].rd_mode_is_ready = 1;
    }
#if CONFIG_COLLECT_PARTITION_STATS
    {
      RD_STATS tmp_sum_rdc;
      av1_init_rd_stats(&tmp_sum_rdc);
      tmp_sum_rdc.rate = x->partition_cost[pl][PARTITION_HORZ_B];
      tmp_sum_rdc.rdcost = RDCOST(x->rdmult, tmp_sum_rdc.rate, 0);
      if (best_rdc.rdcost - tmp_sum_rdc.rdcost >= 0) {
        partition_attempts[PARTITION_HORZ_B] += 1;
        aom_usec_timer_start(&partition_timer);
        partition_timer_on = 1;
      }
    }
#endif
    found_best_partition |= rd_test_partition3(
        cpi, td, tile_data, tp, pc_tree, &best_rdc, pc_tree->horizontalb,
        ctx_none, mi_row, mi_col, bsize, PARTITION_HORZ_B, mi_row, mi_col,
        subsize, mi_row + mi_step, mi_col, bsize2, mi_row + mi_step,
        mi_col + mi_step, bsize2);

#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_HORZ_B] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  if (cpi->sf.part_sf.prune_ab_partition_using_split_info &&
      verta_partition_allowed) {
    verta_partition_allowed &= evaluate_ab_partition_based_on_split(
        pc_tree, PARTITION_VERT, rect_part_win_info, x->qindex, 0, 2);
  }

  // PARTITION_VERT_A
  if (!terminate_partition_search && partition_vert_allowed &&
      verta_partition_allowed && !is_gt_max_sq_part) {
    subsize = get_partition_subsize(bsize, PARTITION_VERT_A);
    pc_tree->verticala[0].rd_mode_is_ready = 0;
    pc_tree->verticala[1].rd_mode_is_ready = 0;
    pc_tree->verticala[2].rd_mode_is_ready = 0;
    if (split_ctx_is_ready[0]) {
      av1_copy_tree_context(&pc_tree->verticala[0], &pc_tree->split[0]->none);
      pc_tree->verticala[0].mic.partition = PARTITION_VERT_A;
      pc_tree->verticala[0].rd_mode_is_ready = 1;
    }
#if CONFIG_COLLECT_PARTITION_STATS
    {
      RD_STATS tmp_sum_rdc;
      av1_init_rd_stats(&tmp_sum_rdc);
      tmp_sum_rdc.rate = x->partition_cost[pl][PARTITION_VERT_A];
      tmp_sum_rdc.rdcost = RDCOST(x->rdmult, tmp_sum_rdc.rate, 0);
      if (best_rdc.rdcost - tmp_sum_rdc.rdcost >= 0) {
        partition_attempts[PARTITION_VERT_A] += 1;
        aom_usec_timer_start(&partition_timer);
        partition_timer_on = 1;
      }
    }
#endif
    found_best_partition |= rd_test_partition3(
        cpi, td, tile_data, tp, pc_tree, &best_rdc, pc_tree->verticala,
        ctx_none, mi_row, mi_col, bsize, PARTITION_VERT_A, mi_row, mi_col,
        bsize2, mi_row + mi_step, mi_col, bsize2, mi_row, mi_col + mi_step,
        subsize);
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_VERT_A] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  if (cpi->sf.part_sf.prune_ab_partition_using_split_info &&
      vertb_partition_allowed) {
    vertb_partition_allowed &= evaluate_ab_partition_based_on_split(
        pc_tree, PARTITION_VERT, rect_part_win_info, x->qindex, 1, 3);
  }

  // PARTITION_VERT_B
  if (!terminate_partition_search && partition_vert_allowed &&
      vertb_partition_allowed && !is_gt_max_sq_part) {
    subsize = get_partition_subsize(bsize, PARTITION_VERT_B);
    pc_tree->verticalb[0].rd_mode_is_ready = 0;
    pc_tree->verticalb[1].rd_mode_is_ready = 0;
    pc_tree->verticalb[2].rd_mode_is_ready = 0;
    if (vert_ctx_is_ready) {
      av1_copy_tree_context(&pc_tree->verticalb[0], &pc_tree->vertical[0]);
      pc_tree->verticalb[0].mic.partition = PARTITION_VERT_B;
      pc_tree->verticalb[0].rd_mode_is_ready = 1;
    }
#if CONFIG_COLLECT_PARTITION_STATS
    {
      RD_STATS tmp_sum_rdc;
      av1_init_rd_stats(&tmp_sum_rdc);
      tmp_sum_rdc.rate = x->partition_cost[pl][PARTITION_VERT_B];
      tmp_sum_rdc.rdcost = RDCOST(x->rdmult, tmp_sum_rdc.rate, 0);
      if (!frame_is_intra_only(cm) &&
          best_rdc.rdcost - tmp_sum_rdc.rdcost >= 0) {
        partition_attempts[PARTITION_VERT_B] += 1;
        aom_usec_timer_start(&partition_timer);
        partition_timer_on = 1;
      }
    }
#endif
    found_best_partition |= rd_test_partition3(
        cpi, td, tile_data, tp, pc_tree, &best_rdc, pc_tree->verticalb,
        ctx_none, mi_row, mi_col, bsize, PARTITION_VERT_B, mi_row, mi_col,
        subsize, mi_row, mi_col + mi_step, bsize2, mi_row + mi_step,
        mi_col + mi_step, bsize2);
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_VERT_B] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  // partition4_allowed is 1 if we can use a PARTITION_HORZ_4 or
  // PARTITION_VERT_4 for this block. This is almost the same as
  // ext_partition_allowed, except that we don't allow 128x32 or 32x128
  // blocks, so we require that bsize is not BLOCK_128X128.
  const int partition4_allowed = cpi->oxcf.enable_1to4_partitions &&
                                 ext_partition_allowed &&
                                 bsize != BLOCK_128X128;

  int partition_horz4_allowed =
      partition4_allowed && partition_horz_allowed &&
      get_plane_block_size(get_partition_subsize(bsize, PARTITION_HORZ_4), xss,
                           yss) != BLOCK_INVALID;
  int partition_vert4_allowed =
      partition4_allowed && partition_vert_allowed &&
      get_plane_block_size(get_partition_subsize(bsize, PARTITION_VERT_4), xss,
                           yss) != BLOCK_INVALID;
  if (cpi->sf.part_sf.prune_ext_partition_types_search_level == 2) {
    partition_horz4_allowed &= (pc_tree->partitioning == PARTITION_HORZ ||
                                pc_tree->partitioning == PARTITION_HORZ_A ||
                                pc_tree->partitioning == PARTITION_HORZ_B ||
                                pc_tree->partitioning == PARTITION_SPLIT ||
                                pc_tree->partitioning == PARTITION_NONE);
    partition_vert4_allowed &= (pc_tree->partitioning == PARTITION_VERT ||
                                pc_tree->partitioning == PARTITION_VERT_A ||
                                pc_tree->partitioning == PARTITION_VERT_B ||
                                pc_tree->partitioning == PARTITION_SPLIT ||
                                pc_tree->partitioning == PARTITION_NONE);
  }
  if (cpi->sf.part_sf.ml_prune_4_partition && partition4_allowed &&
      partition_horz_allowed && partition_vert_allowed) {
    av1_ml_prune_4_partition(cpi, x, bsize, pc_tree->partitioning,
                             best_rdc.rdcost, horz_rd, vert_rd, split_rd,
                             &partition_horz4_allowed, &partition_vert4_allowed,
                             pb_source_variance, mi_row, mi_col);
  }

  if (blksize < (min_partition_size << 2)) {
    partition_horz4_allowed = 0;
    partition_vert4_allowed = 0;
  }

  if (cpi->sf.part_sf.prune_4_partition_using_split_info &&
      (partition_horz4_allowed || partition_vert4_allowed)) {
    // Count of child blocks in which HORZ or VERT partition has won
    int num_child_horz_win = 0, num_child_vert_win = 0;
    for (int idx = 0; idx < 4; idx++) {
      num_child_horz_win += (split_part_rect_win[idx].horz_win) ? 1 : 0;
      num_child_vert_win += (split_part_rect_win[idx].vert_win) ? 1 : 0;
    }

    // Prune HORZ4/VERT4 partitions based on number of HORZ/VERT winners of
    // split partiitons.
    // Conservative pruning for high quantizers
    const int num_win_thresh = AOMMIN(3 * (MAXQ - x->qindex) / MAXQ + 1, 3);
    if (num_child_horz_win < num_win_thresh) {
      partition_horz4_allowed = 0;
    }
    if (num_child_vert_win < num_win_thresh) {
      partition_vert4_allowed = 0;
    }
  }

  // PARTITION_HORZ_4
  assert(IMPLIES(!cpi->oxcf.enable_rect_partitions, !partition_horz4_allowed));
  if (!terminate_partition_search && partition_horz4_allowed && has_rows &&
      (do_rectangular_split || active_h_edge(cpi, mi_row, mi_step)) &&
      !is_gt_max_sq_part) {
    av1_init_rd_stats(&sum_rdc);
    const int quarter_step = mi_size_high[bsize] / 4;
    PICK_MODE_CONTEXT *ctx_prev = ctx_none;

    subsize = get_partition_subsize(bsize, PARTITION_HORZ_4);
    sum_rdc.rate = partition_cost[PARTITION_HORZ_4];
    sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);

#if CONFIG_COLLECT_PARTITION_STATS
    if (best_rdc.rdcost - sum_rdc.rdcost >= 0) {
      partition_attempts[PARTITION_HORZ_4] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    for (int i = 0; i < 4; ++i) {
      const int this_mi_row = mi_row + i * quarter_step;

      if (i > 0 && this_mi_row >= mi_params->mi_rows) break;

      PICK_MODE_CONTEXT *ctx_this = &pc_tree->horizontal4[i];

      ctx_this->rd_mode_is_ready = 0;
      if (!rd_try_subblock(cpi, td, tile_data, tp, (i == 3), this_mi_row,
                           mi_col, subsize, best_rdc, &sum_rdc,
                           PARTITION_HORZ_4, ctx_prev, ctx_this)) {
        av1_invalid_rd_stats(&sum_rdc);
        break;
      }

      ctx_prev = ctx_this;
    }

    av1_rd_cost_update(x->rdmult, &sum_rdc);
    if (sum_rdc.rdcost < best_rdc.rdcost) {
      best_rdc = sum_rdc;
      found_best_partition = true;
      pc_tree->partitioning = PARTITION_HORZ_4;
    }

#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_HORZ_4] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  // PARTITION_VERT_4
  assert(IMPLIES(!cpi->oxcf.enable_rect_partitions, !partition_vert4_allowed));
  if (!terminate_partition_search && partition_vert4_allowed && has_cols &&
      (do_rectangular_split || active_v_edge(cpi, mi_row, mi_step)) &&
      !is_gt_max_sq_part) {
    av1_init_rd_stats(&sum_rdc);
    const int quarter_step = mi_size_wide[bsize] / 4;
    PICK_MODE_CONTEXT *ctx_prev = ctx_none;

    subsize = get_partition_subsize(bsize, PARTITION_VERT_4);
    sum_rdc.rate = partition_cost[PARTITION_VERT_4];
    sum_rdc.rdcost = RDCOST(x->rdmult, sum_rdc.rate, 0);

#if CONFIG_COLLECT_PARTITION_STATS
    if (best_rdc.rdcost - sum_rdc.rdcost >= 0) {
      partition_attempts[PARTITION_VERT_4] += 1;
      aom_usec_timer_start(&partition_timer);
      partition_timer_on = 1;
    }
#endif
    for (int i = 0; i < 4; ++i) {
      const int this_mi_col = mi_col + i * quarter_step;

      if (i > 0 && this_mi_col >= mi_params->mi_cols) break;

      PICK_MODE_CONTEXT *ctx_this = &pc_tree->vertical4[i];

      ctx_this->rd_mode_is_ready = 0;
      if (!rd_try_subblock(cpi, td, tile_data, tp, (i == 3), mi_row,
                           this_mi_col, subsize, best_rdc, &sum_rdc,
                           PARTITION_VERT_4, ctx_prev, ctx_this)) {
        av1_invalid_rd_stats(&sum_rdc);
        break;
      }

      ctx_prev = ctx_this;
    }

    av1_rd_cost_update(x->rdmult, &sum_rdc);
    if (sum_rdc.rdcost < best_rdc.rdcost) {
      best_rdc = sum_rdc;
      found_best_partition = true;
      pc_tree->partitioning = PARTITION_VERT_4;
    }
#if CONFIG_COLLECT_PARTITION_STATS
    if (partition_timer_on) {
      aom_usec_timer_mark(&partition_timer);
      int64_t time = aom_usec_timer_elapsed(&partition_timer);
      partition_times[PARTITION_VERT_4] += time;
      partition_timer_on = 0;
    }
#endif
    restore_context(x, &x_ctx, mi_row, mi_col, bsize, num_planes);
  }

  if (bsize == cm->seq_params.sb_size && !found_best_partition) {
    // Did not find a valid partition, go back and search again, with less
    // constraint on which partition types to search.
    x->must_find_valid_partition = 1;
#if CONFIG_COLLECT_PARTITION_STATS == 2
    part_stats->partition_redo += 1;
#endif
    goto BEGIN_PARTITION_SEARCH;
  }

  *rd_cost = best_rdc;

#if CONFIG_COLLECT_PARTITION_STATS
  if (best_rdc.rate < INT_MAX && best_rdc.dist < INT64_MAX) {
    partition_decisions[pc_tree->partitioning] += 1;
  }
#endif

#if CONFIG_COLLECT_PARTITION_STATS == 1
  // If CONFIG_COLLECT_PARTITION_STATS is 1, then print out the stats for each
  // prediction block
  FILE *f = fopen("data.csv", "a");
  fprintf(f, "%d,%d,%d,", bsize, cm->show_frame, frame_is_intra_only(cm));
  for (int idx = 0; idx < EXT_PARTITION_TYPES; idx++) {
    fprintf(f, "%d,", partition_decisions[idx]);
  }
  for (int idx = 0; idx < EXT_PARTITION_TYPES; idx++) {
    fprintf(f, "%d,", partition_attempts[idx]);
  }
  for (int idx = 0; idx < EXT_PARTITION_TYPES; idx++) {
    fprintf(f, "%ld,", partition_times[idx]);
  }
  fprintf(f, "\n");
  fclose(f);
#endif

#if CONFIG_COLLECT_PARTITION_STATS == 2
  // If CONFIG_COLLECTION_PARTITION_STATS is 2, then we print out the stats for
  // the whole clip. So we need to pass the information upstream to the encoder
  const int bsize_idx = av1_get_bsize_idx_for_part_stats(bsize);
  int *agg_attempts = part_stats->partition_attempts[bsize_idx];
  int *agg_decisions = part_stats->partition_decisions[bsize_idx];
  int64_t *agg_times = part_stats->partition_times[bsize_idx];
  for (int idx = 0; idx < EXT_PARTITION_TYPES; idx++) {
    agg_attempts[idx] += partition_attempts[idx];
    agg_decisions[idx] += partition_decisions[idx];
    agg_times[idx] += partition_times[idx];
  }
#endif

  if (found_best_partition && pc_tree->index != 3) {
    if (bsize == cm->seq_params.sb_size) {
      const int emit_output = multi_pass_mode != SB_DRY_PASS;
      const RUN_TYPE run_type = emit_output ? OUTPUT_ENABLED : DRY_RUN_NORMAL;

      x->cb_offset = 0;
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, run_type, bsize,
                pc_tree, NULL);
    } else {
      encode_sb(cpi, td, tile_data, tp, mi_row, mi_col, DRY_RUN_NORMAL, bsize,
                pc_tree, NULL);
    }
  }

  if (bsize == cm->seq_params.sb_size) {
    assert(best_rdc.rate < INT_MAX);
    assert(best_rdc.dist < INT64_MAX);
  } else {
    assert(tp_orig == *tp);
  }

  x->rdmult = orig_rdmult;
  return found_best_partition;
}
#endif  // !CONFIG_REALTIME_ONLY
#undef NUM_SIMPLE_MOTION_FEATURES

#if !CONFIG_REALTIME_ONLY

static int get_rdmult_delta(AV1_COMP *cpi, BLOCK_SIZE bsize, int analysis_type,
                            int mi_row, int mi_col, int orig_rdmult) {
  AV1_COMMON *const cm = &cpi->common;
  assert(IMPLIES(cpi->gf_group.size > 0,
                 cpi->gf_group.index < cpi->gf_group.size));
  const int tpl_idx = cpi->gf_group.index;
  TplParams *const tpl_data = &cpi->tpl_data;
  TplDepFrame *tpl_frame = &tpl_data->tpl_frame[tpl_idx];
  TplDepStats *tpl_stats = tpl_frame->tpl_stats_ptr;
  const uint8_t block_mis_log2 = tpl_data->tpl_stats_block_mis_log2;
  int tpl_stride = tpl_frame->stride;
  int64_t intra_cost = 0;
  int64_t mc_dep_cost = 0;
  const int mi_wide = mi_size_wide[bsize];
  const int mi_high = mi_size_high[bsize];

  if (tpl_frame->is_valid == 0) return orig_rdmult;

  if (!is_frame_tpl_eligible(cpi)) return orig_rdmult;

  if (cpi->gf_group.index >= MAX_LAG_BUFFERS) return orig_rdmult;

  int64_t mc_count = 0, mc_saved = 0;
  int mi_count = 0;
  const int mi_col_sr =
      coded_to_superres_mi(mi_col, cm->superres_scale_denominator);
  const int mi_col_end_sr =
      coded_to_superres_mi(mi_col + mi_wide, cm->superres_scale_denominator);
  const int mi_cols_sr = av1_pixels_to_mi(cm->superres_upscaled_width);
  const int step = 1 << block_mis_log2;
  for (int row = mi_row; row < mi_row + mi_high; row += step) {
    for (int col = mi_col_sr; col < mi_col_end_sr; col += step) {
      if (row >= cm->mi_params.mi_rows || col >= mi_cols_sr) continue;
      TplDepStats *this_stats =
          &tpl_stats[av1_tpl_ptr_pos(row, col, tpl_stride, block_mis_log2)];
      int64_t mc_dep_delta =
          RDCOST(tpl_frame->base_rdmult, this_stats->mc_dep_rate,
                 this_stats->mc_dep_dist);
      intra_cost += this_stats->recrf_dist << RDDIV_BITS;
      mc_dep_cost += (this_stats->recrf_dist << RDDIV_BITS) + mc_dep_delta;
      mc_count += this_stats->mc_count;
      mc_saved += this_stats->mc_saved;
      mi_count++;
    }
  }

  aom_clear_system_state();

  double beta = 1.0;
  if (analysis_type == 0) {
    if (mc_dep_cost > 0 && intra_cost > 0) {
      const double r0 = cpi->rd.r0;
      const double rk = (double)intra_cost / mc_dep_cost;
      beta = (r0 / rk);
    }
  } else if (analysis_type == 1) {
    const double mc_count_base = (mi_count * cpi->rd.mc_count_base);
    beta = (mc_count + 1.0) / (mc_count_base + 1.0);
    beta = pow(beta, 0.5);
  } else if (analysis_type == 2) {
    const double mc_saved_base = (mi_count * cpi->rd.mc_saved_base);
    beta = (mc_saved + 1.0) / (mc_saved_base + 1.0);
    beta = pow(beta, 0.5);
  }

  int rdmult = av1_get_adaptive_rdmult(cpi, beta);

  aom_clear_system_state();

  rdmult = AOMMIN(rdmult, orig_rdmult * 3 / 2);
  rdmult = AOMMAX(rdmult, orig_rdmult * 1 / 2);

  rdmult = AOMMAX(1, rdmult);

  return rdmult;
}

static int get_tpl_stats_b(AV1_COMP *cpi, BLOCK_SIZE bsize, int mi_row,
                           int mi_col, int64_t *intra_cost_b,
                           int64_t *inter_cost_b,
                           int_mv mv_b[][INTER_REFS_PER_FRAME], int *stride) {
  if (!cpi->oxcf.enable_tpl_model) return 0;
  if (cpi->superres_mode != SUPERRES_NONE) return 0;
  if (cpi->common.current_frame.frame_type == KEY_FRAME) return 0;
  const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);
  if (update_type == INTNL_OVERLAY_UPDATE || update_type == OVERLAY_UPDATE)
    return 0;
  assert(IMPLIES(cpi->gf_group.size > 0,
                 cpi->gf_group.index < cpi->gf_group.size));

  AV1_COMMON *const cm = &cpi->common;
  const int gf_group_index = cpi->gf_group.index;
  TplParams *const tpl_data = &cpi->tpl_data;
  TplDepFrame *tpl_frame = &tpl_data->tpl_frame[gf_group_index];
  TplDepStats *tpl_stats = tpl_frame->tpl_stats_ptr;
  int tpl_stride = tpl_frame->stride;
  const int mi_wide = mi_size_wide[bsize];
  const int mi_high = mi_size_high[bsize];

  if (tpl_frame->is_valid == 0) return 0;
  if (gf_group_index >= MAX_LAG_BUFFERS) return 0;

  int mi_count = 0;
  int count = 0;
  const int mi_col_sr =
      coded_to_superres_mi(mi_col, cm->superres_scale_denominator);
  const int mi_col_end_sr =
      coded_to_superres_mi(mi_col + mi_wide, cm->superres_scale_denominator);
  // mi_cols_sr is mi_cols at superres case.
  const int mi_cols_sr = av1_pixels_to_mi(cm->superres_upscaled_width);

  // TPL store unit size is not the same as the motion estimation unit size.
  // Here always use motion estimation size to avoid getting repetitive inter/
  // intra cost.
  const BLOCK_SIZE tpl_bsize = convert_length_to_bsize(MC_FLOW_BSIZE_1D);
  const int step = mi_size_wide[tpl_bsize];
  assert(mi_size_wide[tpl_bsize] == mi_size_high[tpl_bsize]);

  // Stride is only based on SB size, and we fill in values for every 16x16
  // block in a SB.
  *stride = (mi_col_end_sr - mi_col_sr) / step;

  for (int row = mi_row; row < mi_row + mi_high; row += step) {
    for (int col = mi_col_sr; col < mi_col_end_sr; col += step) {
      // Handle partial SB, so that no invalid values are used later.
      if (row >= cm->mi_params.mi_rows || col >= mi_cols_sr) {
        inter_cost_b[count] = INT64_MAX;
        intra_cost_b[count] = INT64_MAX;
        for (int i = 0; i < INTER_REFS_PER_FRAME; ++i) {
          mv_b[count][i].as_int = INVALID_MV;
        }
        count++;
        continue;
      }

      TplDepStats *this_stats = &tpl_stats[av1_tpl_ptr_pos(
          row, col, tpl_stride, tpl_data->tpl_stats_block_mis_log2)];
      inter_cost_b[count] = this_stats->inter_cost;
      intra_cost_b[count] = this_stats->intra_cost;
      memcpy(mv_b[count], this_stats->mv, sizeof(this_stats->mv));
      mi_count++;
      count++;
    }
  }

  return mi_count;
}

// analysis_type 0: Use mc_dep_cost and intra_cost
// analysis_type 1: Use count of best inter predictor chosen
// analysis_type 2: Use cost reduction from intra to inter for best inter
//                  predictor chosen
static int get_q_for_deltaq_objective(AV1_COMP *const cpi, BLOCK_SIZE bsize,
                                      int mi_row, int mi_col) {
  AV1_COMMON *const cm = &cpi->common;
  assert(IMPLIES(cpi->gf_group.size > 0,
                 cpi->gf_group.index < cpi->gf_group.size));
  const int tpl_idx = cpi->gf_group.index;
  TplParams *const tpl_data = &cpi->tpl_data;
  TplDepFrame *tpl_frame = &tpl_data->tpl_frame[tpl_idx];
  TplDepStats *tpl_stats = tpl_frame->tpl_stats_ptr;
  const uint8_t block_mis_log2 = tpl_data->tpl_stats_block_mis_log2;
  int tpl_stride = tpl_frame->stride;
  int64_t intra_cost = 0;
  int64_t mc_dep_cost = 0;
  const int mi_wide = mi_size_wide[bsize];
  const int mi_high = mi_size_high[bsize];
  const int base_qindex = cm->quant_params.base_qindex;

  if (tpl_frame->is_valid == 0) return base_qindex;

  if (!is_frame_tpl_eligible(cpi)) return base_qindex;

  if (cpi->gf_group.index >= MAX_LAG_BUFFERS) return base_qindex;

  int64_t mc_count = 0, mc_saved = 0;
  int mi_count = 0;
  const int mi_col_sr =
      coded_to_superres_mi(mi_col, cm->superres_scale_denominator);
  const int mi_col_end_sr =
      coded_to_superres_mi(mi_col + mi_wide, cm->superres_scale_denominator);
  const int mi_cols_sr = av1_pixels_to_mi(cm->superres_upscaled_width);
  const int step = 1 << block_mis_log2;
  for (int row = mi_row; row < mi_row + mi_high; row += step) {
    for (int col = mi_col_sr; col < mi_col_end_sr; col += step) {
      if (row >= cm->mi_params.mi_rows || col >= mi_cols_sr) continue;
      TplDepStats *this_stats =
          &tpl_stats[av1_tpl_ptr_pos(row, col, tpl_stride, block_mis_log2)];
      int64_t mc_dep_delta =
          RDCOST(tpl_frame->base_rdmult, this_stats->mc_dep_rate,
                 this_stats->mc_dep_dist);
      intra_cost += this_stats->recrf_dist << RDDIV_BITS;
      mc_dep_cost += (this_stats->recrf_dist << RDDIV_BITS) + mc_dep_delta;
      mc_count += this_stats->mc_count;
      mc_saved += this_stats->mc_saved;
      mi_count++;
    }
  }

  aom_clear_system_state();

  int offset = 0;
  double beta = 1.0;
  if (mc_dep_cost > 0 && intra_cost > 0) {
    const double r0 = cpi->rd.r0;
    const double rk = (double)intra_cost / mc_dep_cost;
    beta = (r0 / rk);
    assert(beta > 0.0);
  }
  offset = av1_get_deltaq_offset(cpi, base_qindex, beta);
  aom_clear_system_state();

  const DeltaQInfo *const delta_q_info = &cm->delta_q_info;
  offset = AOMMIN(offset, delta_q_info->delta_q_res * 9 - 1);
  offset = AOMMAX(offset, -delta_q_info->delta_q_res * 9 + 1);
  int qindex = cm->quant_params.base_qindex + offset;
  qindex = AOMMIN(qindex, MAXQ);
  qindex = AOMMAX(qindex, MINQ);

  return qindex;
}

static AOM_INLINE void setup_delta_q(AV1_COMP *const cpi, ThreadData *td,
                                     MACROBLOCK *const x,
                                     const TileInfo *const tile_info,
                                     int mi_row, int mi_col, int num_planes) {
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const DeltaQInfo *const delta_q_info = &cm->delta_q_info;
  assert(delta_q_info->delta_q_present_flag);

  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
  // Delta-q modulation based on variance
  av1_setup_src_planes(x, cpi->source, mi_row, mi_col, num_planes, sb_size);

  int current_qindex = cm->quant_params.base_qindex;
  if (cpi->oxcf.deltaq_mode == DELTA_Q_PERCEPTUAL) {
    if (DELTA_Q_PERCEPTUAL_MODULATION == 1) {
      const int block_wavelet_energy_level =
          av1_block_wavelet_energy_level(cpi, x, sb_size);
      x->sb_energy_level = block_wavelet_energy_level;
      current_qindex = av1_compute_q_from_energy_level_deltaq_mode(
          cpi, block_wavelet_energy_level);
    } else {
      const int block_var_level = av1_log_block_var(cpi, x, sb_size);
      x->sb_energy_level = block_var_level;
      current_qindex =
          av1_compute_q_from_energy_level_deltaq_mode(cpi, block_var_level);
    }
  } else if (cpi->oxcf.deltaq_mode == DELTA_Q_OBJECTIVE &&
             cpi->oxcf.enable_tpl_model) {
    // Setup deltaq based on tpl stats
    current_qindex = get_q_for_deltaq_objective(cpi, sb_size, mi_row, mi_col);
  }

  const int delta_q_res = delta_q_info->delta_q_res;
  // Right now aq only works with tpl model. So if tpl is disabled, we set the
  // current_qindex to base_qindex.
  if (cpi->oxcf.enable_tpl_model && cpi->oxcf.deltaq_mode != NO_DELTA_Q) {
    current_qindex =
        clamp(current_qindex, delta_q_res, 256 - delta_q_info->delta_q_res);
  } else {
    current_qindex = cm->quant_params.base_qindex;
  }

  MACROBLOCKD *const xd = &x->e_mbd;
  const int sign_deltaq_index =
      current_qindex - xd->current_qindex >= 0 ? 1 : -1;
  const int deltaq_deadzone = delta_q_res / 4;
  const int qmask = ~(delta_q_res - 1);
  int abs_deltaq_index = abs(current_qindex - xd->current_qindex);
  abs_deltaq_index = (abs_deltaq_index + deltaq_deadzone) & qmask;
  current_qindex = xd->current_qindex + sign_deltaq_index * abs_deltaq_index;
  current_qindex = AOMMAX(current_qindex, MINQ + 1);
  assert(current_qindex > 0);

  xd->delta_qindex = current_qindex - cm->quant_params.base_qindex;
  set_offsets(cpi, tile_info, x, mi_row, mi_col, sb_size);
  xd->mi[0]->current_qindex = current_qindex;
  av1_init_plane_quantizers(cpi, x, xd->mi[0]->segment_id);

  // keep track of any non-zero delta-q used
  td->deltaq_used |= (xd->delta_qindex != 0);

  if (cpi->oxcf.deltalf_mode) {
    const int delta_lf_res = delta_q_info->delta_lf_res;
    const int lfmask = ~(delta_lf_res - 1);
    const int delta_lf_from_base =
        ((xd->delta_qindex / 2 + delta_lf_res / 2) & lfmask);
    const int8_t delta_lf =
        (int8_t)clamp(delta_lf_from_base, -MAX_LOOP_FILTER, MAX_LOOP_FILTER);
    const int frame_lf_count =
        av1_num_planes(cm) > 1 ? FRAME_LF_COUNT : FRAME_LF_COUNT - 2;
    const int mib_size = cm->seq_params.mib_size;

    // pre-set the delta lf for loop filter. Note that this value is set
    // before mi is assigned for each block in current superblock
    for (int j = 0; j < AOMMIN(mib_size, mi_params->mi_rows - mi_row); j++) {
      for (int k = 0; k < AOMMIN(mib_size, mi_params->mi_cols - mi_col); k++) {
        const int grid_idx = get_mi_grid_idx(mi_params, mi_row + j, mi_col + k);
        mi_params->mi_grid_base[grid_idx]->delta_lf_from_base = delta_lf;
        for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id) {
          mi_params->mi_grid_base[grid_idx]->delta_lf[lf_id] = delta_lf;
        }
      }
    }
  }
}
#endif  // !CONFIG_REALTIME_ONLY

#define AVG_CDF_WEIGHT_LEFT 3
#define AVG_CDF_WEIGHT_TOP_RIGHT 1

static AOM_INLINE void avg_cdf_symbol(aom_cdf_prob *cdf_ptr_left,
                                      aom_cdf_prob *cdf_ptr_tr, int num_cdfs,
                                      int cdf_stride, int nsymbs, int wt_left,
                                      int wt_tr) {
  for (int i = 0; i < num_cdfs; i++) {
    for (int j = 0; j <= nsymbs; j++) {
      cdf_ptr_left[i * cdf_stride + j] =
          (aom_cdf_prob)(((int)cdf_ptr_left[i * cdf_stride + j] * wt_left +
                          (int)cdf_ptr_tr[i * cdf_stride + j] * wt_tr +
                          ((wt_left + wt_tr) / 2)) /
                         (wt_left + wt_tr));
      assert(cdf_ptr_left[i * cdf_stride + j] >= 0 &&
             cdf_ptr_left[i * cdf_stride + j] < CDF_PROB_TOP);
    }
  }
}

#define AVERAGE_CDF(cname_left, cname_tr, nsymbs) \
  AVG_CDF_STRIDE(cname_left, cname_tr, nsymbs, CDF_SIZE(nsymbs))

#define AVG_CDF_STRIDE(cname_left, cname_tr, nsymbs, cdf_stride)           \
  do {                                                                     \
    aom_cdf_prob *cdf_ptr_left = (aom_cdf_prob *)cname_left;               \
    aom_cdf_prob *cdf_ptr_tr = (aom_cdf_prob *)cname_tr;                   \
    int array_size = (int)sizeof(cname_left) / sizeof(aom_cdf_prob);       \
    int num_cdfs = array_size / cdf_stride;                                \
    avg_cdf_symbol(cdf_ptr_left, cdf_ptr_tr, num_cdfs, cdf_stride, nsymbs, \
                   wt_left, wt_tr);                                        \
  } while (0)

static AOM_INLINE void avg_nmv(nmv_context *nmv_left, nmv_context *nmv_tr,
                               int wt_left, int wt_tr) {
  AVERAGE_CDF(nmv_left->joints_cdf, nmv_tr->joints_cdf, 4);
  for (int i = 0; i < 2; i++) {
    AVERAGE_CDF(nmv_left->comps[i].classes_cdf, nmv_tr->comps[i].classes_cdf,
                MV_CLASSES);
    AVERAGE_CDF(nmv_left->comps[i].class0_fp_cdf,
                nmv_tr->comps[i].class0_fp_cdf, MV_FP_SIZE);
    AVERAGE_CDF(nmv_left->comps[i].fp_cdf, nmv_tr->comps[i].fp_cdf, MV_FP_SIZE);
    AVERAGE_CDF(nmv_left->comps[i].sign_cdf, nmv_tr->comps[i].sign_cdf, 2);
    AVERAGE_CDF(nmv_left->comps[i].class0_hp_cdf,
                nmv_tr->comps[i].class0_hp_cdf, 2);
    AVERAGE_CDF(nmv_left->comps[i].hp_cdf, nmv_tr->comps[i].hp_cdf, 2);
    AVERAGE_CDF(nmv_left->comps[i].class0_cdf, nmv_tr->comps[i].class0_cdf,
                CLASS0_SIZE);
    AVERAGE_CDF(nmv_left->comps[i].bits_cdf, nmv_tr->comps[i].bits_cdf, 2);
  }
}

// In case of row-based multi-threading of encoder, since we always
// keep a top - right sync, we can average the top - right SB's CDFs and
// the left SB's CDFs and use the same for current SB's encoding to
// improve the performance. This function facilitates the averaging
// of CDF and used only when row-mt is enabled in encoder.
static AOM_INLINE void avg_cdf_symbols(FRAME_CONTEXT *ctx_left,
                                       FRAME_CONTEXT *ctx_tr, int wt_left,
                                       int wt_tr) {
  AVERAGE_CDF(ctx_left->txb_skip_cdf, ctx_tr->txb_skip_cdf, 2);
  AVERAGE_CDF(ctx_left->eob_extra_cdf, ctx_tr->eob_extra_cdf, 2);
  AVERAGE_CDF(ctx_left->dc_sign_cdf, ctx_tr->dc_sign_cdf, 2);
  AVERAGE_CDF(ctx_left->eob_flag_cdf16, ctx_tr->eob_flag_cdf16, 5);
  AVERAGE_CDF(ctx_left->eob_flag_cdf32, ctx_tr->eob_flag_cdf32, 6);
  AVERAGE_CDF(ctx_left->eob_flag_cdf64, ctx_tr->eob_flag_cdf64, 7);
  AVERAGE_CDF(ctx_left->eob_flag_cdf128, ctx_tr->eob_flag_cdf128, 8);
  AVERAGE_CDF(ctx_left->eob_flag_cdf256, ctx_tr->eob_flag_cdf256, 9);
  AVERAGE_CDF(ctx_left->eob_flag_cdf512, ctx_tr->eob_flag_cdf512, 10);
  AVERAGE_CDF(ctx_left->eob_flag_cdf1024, ctx_tr->eob_flag_cdf1024, 11);
  AVERAGE_CDF(ctx_left->coeff_base_eob_cdf, ctx_tr->coeff_base_eob_cdf, 3);
  AVERAGE_CDF(ctx_left->coeff_base_cdf, ctx_tr->coeff_base_cdf, 4);
  AVERAGE_CDF(ctx_left->coeff_br_cdf, ctx_tr->coeff_br_cdf, BR_CDF_SIZE);
  AVERAGE_CDF(ctx_left->newmv_cdf, ctx_tr->newmv_cdf, 2);
  AVERAGE_CDF(ctx_left->zeromv_cdf, ctx_tr->zeromv_cdf, 2);
  AVERAGE_CDF(ctx_left->refmv_cdf, ctx_tr->refmv_cdf, 2);
  AVERAGE_CDF(ctx_left->drl_cdf, ctx_tr->drl_cdf, 2);
  AVERAGE_CDF(ctx_left->inter_compound_mode_cdf,
              ctx_tr->inter_compound_mode_cdf, INTER_COMPOUND_MODES);
  AVERAGE_CDF(ctx_left->compound_type_cdf, ctx_tr->compound_type_cdf,
              MASKED_COMPOUND_TYPES);
  AVERAGE_CDF(ctx_left->wedge_idx_cdf, ctx_tr->wedge_idx_cdf, 16);
  AVERAGE_CDF(ctx_left->interintra_cdf, ctx_tr->interintra_cdf, 2);
  AVERAGE_CDF(ctx_left->wedge_interintra_cdf, ctx_tr->wedge_interintra_cdf, 2);
  AVERAGE_CDF(ctx_left->interintra_mode_cdf, ctx_tr->interintra_mode_cdf,
              INTERINTRA_MODES);
  AVERAGE_CDF(ctx_left->motion_mode_cdf, ctx_tr->motion_mode_cdf, MOTION_MODES);
  AVERAGE_CDF(ctx_left->obmc_cdf, ctx_tr->obmc_cdf, 2);
  AVERAGE_CDF(ctx_left->palette_y_size_cdf, ctx_tr->palette_y_size_cdf,
              PALETTE_SIZES);
  AVERAGE_CDF(ctx_left->palette_uv_size_cdf, ctx_tr->palette_uv_size_cdf,
              PALETTE_SIZES);
  for (int j = 0; j < PALETTE_SIZES; j++) {
    int nsymbs = j + PALETTE_MIN_SIZE;
    AVG_CDF_STRIDE(ctx_left->palette_y_color_index_cdf[j],
                   ctx_tr->palette_y_color_index_cdf[j], nsymbs,
                   CDF_SIZE(PALETTE_COLORS));
    AVG_CDF_STRIDE(ctx_left->palette_uv_color_index_cdf[j],
                   ctx_tr->palette_uv_color_index_cdf[j], nsymbs,
                   CDF_SIZE(PALETTE_COLORS));
  }
  AVERAGE_CDF(ctx_left->palette_y_mode_cdf, ctx_tr->palette_y_mode_cdf, 2);
  AVERAGE_CDF(ctx_left->palette_uv_mode_cdf, ctx_tr->palette_uv_mode_cdf, 2);
  AVERAGE_CDF(ctx_left->comp_inter_cdf, ctx_tr->comp_inter_cdf, 2);
  AVERAGE_CDF(ctx_left->single_ref_cdf, ctx_tr->single_ref_cdf, 2);
  AVERAGE_CDF(ctx_left->comp_ref_type_cdf, ctx_tr->comp_ref_type_cdf, 2);
  AVERAGE_CDF(ctx_left->uni_comp_ref_cdf, ctx_tr->uni_comp_ref_cdf, 2);
  AVERAGE_CDF(ctx_left->comp_ref_cdf, ctx_tr->comp_ref_cdf, 2);
  AVERAGE_CDF(ctx_left->comp_bwdref_cdf, ctx_tr->comp_bwdref_cdf, 2);
  AVERAGE_CDF(ctx_left->txfm_partition_cdf, ctx_tr->txfm_partition_cdf, 2);
  AVERAGE_CDF(ctx_left->compound_index_cdf, ctx_tr->compound_index_cdf, 2);
  AVERAGE_CDF(ctx_left->comp_group_idx_cdf, ctx_tr->comp_group_idx_cdf, 2);
  AVERAGE_CDF(ctx_left->skip_mode_cdfs, ctx_tr->skip_mode_cdfs, 2);
  AVERAGE_CDF(ctx_left->skip_cdfs, ctx_tr->skip_cdfs, 2);
  AVERAGE_CDF(ctx_left->intra_inter_cdf, ctx_tr->intra_inter_cdf, 2);
  avg_nmv(&ctx_left->nmvc, &ctx_tr->nmvc, wt_left, wt_tr);
  avg_nmv(&ctx_left->ndvc, &ctx_tr->ndvc, wt_left, wt_tr);
  AVERAGE_CDF(ctx_left->intrabc_cdf, ctx_tr->intrabc_cdf, 2);
  AVERAGE_CDF(ctx_left->seg.tree_cdf, ctx_tr->seg.tree_cdf, MAX_SEGMENTS);
  AVERAGE_CDF(ctx_left->seg.pred_cdf, ctx_tr->seg.pred_cdf, 2);
  AVERAGE_CDF(ctx_left->seg.spatial_pred_seg_cdf,
              ctx_tr->seg.spatial_pred_seg_cdf, MAX_SEGMENTS);
  AVERAGE_CDF(ctx_left->filter_intra_cdfs, ctx_tr->filter_intra_cdfs, 2);
  AVERAGE_CDF(ctx_left->filter_intra_mode_cdf, ctx_tr->filter_intra_mode_cdf,
              FILTER_INTRA_MODES);
  AVERAGE_CDF(ctx_left->switchable_restore_cdf, ctx_tr->switchable_restore_cdf,
              RESTORE_SWITCHABLE_TYPES);
  AVERAGE_CDF(ctx_left->wiener_restore_cdf, ctx_tr->wiener_restore_cdf, 2);
  AVERAGE_CDF(ctx_left->sgrproj_restore_cdf, ctx_tr->sgrproj_restore_cdf, 2);
  AVERAGE_CDF(ctx_left->y_mode_cdf, ctx_tr->y_mode_cdf, INTRA_MODES);
  AVG_CDF_STRIDE(ctx_left->uv_mode_cdf[0], ctx_tr->uv_mode_cdf[0],
                 UV_INTRA_MODES - 1, CDF_SIZE(UV_INTRA_MODES));
  AVERAGE_CDF(ctx_left->uv_mode_cdf[1], ctx_tr->uv_mode_cdf[1], UV_INTRA_MODES);
  for (int i = 0; i < PARTITION_CONTEXTS; i++) {
    if (i < 4) {
      AVG_CDF_STRIDE(ctx_left->partition_cdf[i], ctx_tr->partition_cdf[i], 4,
                     CDF_SIZE(10));
    } else if (i < 16) {
      AVERAGE_CDF(ctx_left->partition_cdf[i], ctx_tr->partition_cdf[i], 10);
    } else {
      AVG_CDF_STRIDE(ctx_left->partition_cdf[i], ctx_tr->partition_cdf[i], 8,
                     CDF_SIZE(10));
    }
  }
  AVERAGE_CDF(ctx_left->switchable_interp_cdf, ctx_tr->switchable_interp_cdf,
              SWITCHABLE_FILTERS);
  AVERAGE_CDF(ctx_left->kf_y_cdf, ctx_tr->kf_y_cdf, INTRA_MODES);
  AVERAGE_CDF(ctx_left->angle_delta_cdf, ctx_tr->angle_delta_cdf,
              2 * MAX_ANGLE_DELTA + 1);
  AVG_CDF_STRIDE(ctx_left->tx_size_cdf[0], ctx_tr->tx_size_cdf[0], MAX_TX_DEPTH,
                 CDF_SIZE(MAX_TX_DEPTH + 1));
  AVERAGE_CDF(ctx_left->tx_size_cdf[1], ctx_tr->tx_size_cdf[1],
              MAX_TX_DEPTH + 1);
  AVERAGE_CDF(ctx_left->tx_size_cdf[2], ctx_tr->tx_size_cdf[2],
              MAX_TX_DEPTH + 1);
  AVERAGE_CDF(ctx_left->tx_size_cdf[3], ctx_tr->tx_size_cdf[3],
              MAX_TX_DEPTH + 1);
  AVERAGE_CDF(ctx_left->delta_q_cdf, ctx_tr->delta_q_cdf, DELTA_Q_PROBS + 1);
  AVERAGE_CDF(ctx_left->delta_lf_cdf, ctx_tr->delta_lf_cdf, DELTA_LF_PROBS + 1);
  for (int i = 0; i < FRAME_LF_COUNT; i++) {
    AVERAGE_CDF(ctx_left->delta_lf_multi_cdf[i], ctx_tr->delta_lf_multi_cdf[i],
                DELTA_LF_PROBS + 1);
  }
  AVG_CDF_STRIDE(ctx_left->intra_ext_tx_cdf[1], ctx_tr->intra_ext_tx_cdf[1], 7,
                 CDF_SIZE(TX_TYPES));
  AVG_CDF_STRIDE(ctx_left->intra_ext_tx_cdf[2], ctx_tr->intra_ext_tx_cdf[2], 5,
                 CDF_SIZE(TX_TYPES));
  AVG_CDF_STRIDE(ctx_left->inter_ext_tx_cdf[1], ctx_tr->inter_ext_tx_cdf[1], 16,
                 CDF_SIZE(TX_TYPES));
  AVG_CDF_STRIDE(ctx_left->inter_ext_tx_cdf[2], ctx_tr->inter_ext_tx_cdf[2], 12,
                 CDF_SIZE(TX_TYPES));
  AVG_CDF_STRIDE(ctx_left->inter_ext_tx_cdf[3], ctx_tr->inter_ext_tx_cdf[3], 2,
                 CDF_SIZE(TX_TYPES));
  AVERAGE_CDF(ctx_left->cfl_sign_cdf, ctx_tr->cfl_sign_cdf, CFL_JOINT_SIGNS);
  AVERAGE_CDF(ctx_left->cfl_alpha_cdf, ctx_tr->cfl_alpha_cdf,
              CFL_ALPHABET_SIZE);
}

#if !CONFIG_REALTIME_ONLY
static AOM_INLINE void adjust_rdmult_tpl_model(AV1_COMP *cpi, MACROBLOCK *x,
                                               int mi_row, int mi_col) {
  const BLOCK_SIZE sb_size = cpi->common.seq_params.sb_size;
  const int orig_rdmult = cpi->rd.RDMULT;

  assert(IMPLIES(cpi->gf_group.size > 0,
                 cpi->gf_group.index < cpi->gf_group.size));
  const int gf_group_index = cpi->gf_group.index;
  if (cpi->oxcf.enable_tpl_model && cpi->oxcf.aq_mode == NO_AQ &&
      cpi->oxcf.deltaq_mode == NO_DELTA_Q && gf_group_index > 0 &&
      cpi->gf_group.update_type[gf_group_index] == ARF_UPDATE) {
    const int dr =
        get_rdmult_delta(cpi, sb_size, 0, mi_row, mi_col, orig_rdmult);
    x->rdmult = dr;
  }
}
#endif

static void source_content_sb(AV1_COMP *cpi, MACROBLOCK *x, int shift) {
  unsigned int tmp_sse;
  unsigned int tmp_variance;
  const BLOCK_SIZE bsize = BLOCK_64X64;
  uint8_t *src_y = cpi->source->y_buffer;
  int src_ystride = cpi->source->y_stride;
  uint8_t *last_src_y = cpi->last_source->y_buffer;
  int last_src_ystride = cpi->last_source->y_stride;
  uint64_t avg_source_sse_threshold = 100000;        // ~5*5*(64*64)
  uint64_t avg_source_sse_threshold_high = 1000000;  // ~15*15*(64*64)
  uint64_t sum_sq_thresh = 10000;  // sum = sqrt(thresh / 64*64)) ~1.5
#if CONFIG_AV1_HIGHBITDEPTH
  MACROBLOCKD *xd = &x->e_mbd;
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) return;
#endif
  src_y += shift;
  last_src_y += shift;
  tmp_variance = cpi->fn_ptr[bsize].vf(src_y, src_ystride, last_src_y,
                                       last_src_ystride, &tmp_sse);
  // Note: tmp_sse - tmp_variance = ((sum * sum) >> 12)
  // Detect large lighting change.
  if (tmp_variance < (tmp_sse >> 1) && (tmp_sse - tmp_variance) > sum_sq_thresh)
    x->content_state_sb = kLowVarHighSumdiff;
  else if (tmp_sse < avg_source_sse_threshold)
    x->content_state_sb = kLowSad;
  else if (tmp_sse > avg_source_sse_threshold_high)
    x->content_state_sb = kHighSad;
}

static AOM_INLINE void encode_nonrd_sb(AV1_COMP *cpi, ThreadData *td,
                                       TileDataEnc *tile_data,
                                       PC_TREE *const pc_root, TOKENEXTRA **tp,
                                       const int mi_row, const int mi_col,
                                       const int seg_skip) {
  AV1_COMMON *const cm = &cpi->common;
  MACROBLOCK *const x = &td->mb;
  const SPEED_FEATURES *const sf = &cpi->sf;
  const TileInfo *const tile_info = &tile_data->tile_info;
  MB_MODE_INFO **mi = cm->mi_params.mi_grid_base +
                      get_mi_grid_idx(&cm->mi_params, mi_row, mi_col);
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
  if (sf->rt_sf.source_metrics_sb_nonrd && sb_size == BLOCK_64X64 &&
      cpi->svc.number_spatial_layers <= 1 &&
      cm->current_frame.frame_type != KEY_FRAME) {
    int shift = cpi->source->y_stride * (mi_row << 2) + (mi_col << 2);
    source_content_sb(cpi, x, shift);
  }
  if (sf->part_sf.partition_search_type == FIXED_PARTITION || seg_skip) {
    set_offsets(cpi, tile_info, x, mi_row, mi_col, sb_size);
    const BLOCK_SIZE bsize =
        seg_skip ? sb_size : sf->part_sf.always_this_block_size;
    set_fixed_partitioning(cpi, tile_info, mi, mi_row, mi_col, bsize);
  } else if (cpi->partition_search_skippable_frame) {
    set_offsets(cpi, tile_info, x, mi_row, mi_col, sb_size);
    const BLOCK_SIZE bsize =
        get_rd_var_based_fixed_partition(cpi, x, mi_row, mi_col);
    set_fixed_partitioning(cpi, tile_info, mi, mi_row, mi_col, bsize);
  } else if (sf->part_sf.partition_search_type == VAR_BASED_PARTITION) {
    set_offsets_without_segment_id(cpi, tile_info, x, mi_row, mi_col, sb_size);
    av1_choose_var_based_partitioning(cpi, tile_info, td, x, mi_row, mi_col);
  }
  assert(sf->part_sf.partition_search_type == FIXED_PARTITION || seg_skip ||
         cpi->partition_search_skippable_frame ||
         sf->part_sf.partition_search_type == VAR_BASED_PARTITION);
  td->mb.cb_offset = 0;
  nonrd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, sb_size,
                      pc_root);
}

// Memset the mbmis at the current superblock to 0
static INLINE void reset_mbmi(CommonModeInfoParams *const mi_params,
                              BLOCK_SIZE sb_size, int mi_row, int mi_col) {
  // size of sb in unit of mi (BLOCK_4X4)
  const int sb_size_mi = mi_size_wide[sb_size];
  const int mi_alloc_size_1d = mi_size_wide[mi_params->mi_alloc_bsize];
  // size of sb in unit of allocated mi size
  const int sb_size_alloc_mi = mi_size_wide[sb_size] / mi_alloc_size_1d;
  assert(mi_params->mi_alloc_stride % sb_size_alloc_mi == 0 &&
         "mi is not allocated as a multiple of sb!");
  assert(mi_params->mi_stride % sb_size_mi == 0 &&
         "mi_grid_base is not allocated as a multiple of sb!");

  const int mi_rows = mi_size_high[sb_size];
  for (int cur_mi_row = 0; cur_mi_row < mi_rows; cur_mi_row++) {
    assert(get_mi_grid_idx(mi_params, 0, mi_col + mi_alloc_size_1d) <
           mi_params->mi_stride);
    const int mi_grid_idx =
        get_mi_grid_idx(mi_params, mi_row + cur_mi_row, mi_col);
    const int alloc_mi_idx =
        get_alloc_mi_idx(mi_params, mi_row + cur_mi_row, mi_col);
    memset(&mi_params->mi_grid_base[mi_grid_idx], 0,
           sb_size_mi * sizeof(*mi_params->mi_grid_base));
    memset(&mi_params->tx_type_map[mi_grid_idx], 0,
           sb_size_mi * sizeof(*mi_params->tx_type_map));
    if (cur_mi_row % mi_alloc_size_1d == 0) {
      memset(&mi_params->mi_alloc[alloc_mi_idx], 0,
             sb_size_alloc_mi * sizeof(*mi_params->mi_alloc));
    }
  }
}

static INLINE void backup_sb_state(SB_FIRST_PASS_STATS *sb_fp_stats,
                                   const AV1_COMP *cpi, ThreadData *td,
                                   const TileDataEnc *tile_data, int mi_row,
                                   int mi_col) {
  MACROBLOCK *x = &td->mb;
  MACROBLOCKD *xd = &x->e_mbd;
  const TileInfo *tile_info = &tile_data->tile_info;

  const AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;

  xd->above_txfm_context =
      cm->above_contexts.txfm[tile_info->tile_row] + mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (mi_row & MAX_MIB_MASK);
  save_context(x, &sb_fp_stats->x_ctx, mi_row, mi_col, sb_size, num_planes);

  sb_fp_stats->rd_count = cpi->td.rd_counts;
  sb_fp_stats->split_count = cpi->td.mb.txb_split_count;

  sb_fp_stats->fc = *td->counts;

  memcpy(sb_fp_stats->inter_mode_rd_models, tile_data->inter_mode_rd_models,
         sizeof(sb_fp_stats->inter_mode_rd_models));

  memcpy(sb_fp_stats->thresh_freq_fact, x->thresh_freq_fact,
         sizeof(sb_fp_stats->thresh_freq_fact));

  const int alloc_mi_idx = get_alloc_mi_idx(&cm->mi_params, mi_row, mi_col);
  sb_fp_stats->current_qindex =
      cm->mi_params.mi_alloc[alloc_mi_idx].current_qindex;

#if CONFIG_INTERNAL_STATS
  memcpy(sb_fp_stats->mode_chosen_counts, cpi->mode_chosen_counts,
         sizeof(sb_fp_stats->mode_chosen_counts));
#endif  // CONFIG_INTERNAL_STATS
}

static INLINE void restore_sb_state(const SB_FIRST_PASS_STATS *sb_fp_stats,
                                    AV1_COMP *cpi, ThreadData *td,
                                    TileDataEnc *tile_data, int mi_row,
                                    int mi_col) {
  MACROBLOCK *x = &td->mb;

  const AV1_COMMON *cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;

  restore_context(x, &sb_fp_stats->x_ctx, mi_row, mi_col, sb_size, num_planes);

  cpi->td.rd_counts = sb_fp_stats->rd_count;
  cpi->td.mb.txb_split_count = sb_fp_stats->split_count;

  *td->counts = sb_fp_stats->fc;

  memcpy(tile_data->inter_mode_rd_models, sb_fp_stats->inter_mode_rd_models,
         sizeof(sb_fp_stats->inter_mode_rd_models));
  memcpy(x->thresh_freq_fact, sb_fp_stats->thresh_freq_fact,
         sizeof(sb_fp_stats->thresh_freq_fact));

  const int alloc_mi_idx = get_alloc_mi_idx(&cm->mi_params, mi_row, mi_col);
  cm->mi_params.mi_alloc[alloc_mi_idx].current_qindex =
      sb_fp_stats->current_qindex;

#if CONFIG_INTERNAL_STATS
  memcpy(cpi->mode_chosen_counts, sb_fp_stats->mode_chosen_counts,
         sizeof(sb_fp_stats->mode_chosen_counts));
#endif  // CONFIG_INTERNAL_STATS
}

#if !CONFIG_REALTIME_ONLY
static void init_ref_frame_space(AV1_COMP *cpi, ThreadData *td, int mi_row,
                                 int mi_col) {
  const AV1_COMMON *cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  MACROBLOCK *x = &td->mb;
  const int frame_idx = cpi->gf_group.index;
  TplParams *const tpl_data = &cpi->tpl_data;
  TplDepFrame *tpl_frame = &tpl_data->tpl_frame[frame_idx];
  const uint8_t block_mis_log2 = tpl_data->tpl_stats_block_mis_log2;

  av1_zero(x->search_ref_frame);

  if (tpl_frame->is_valid == 0) return;
  if (!is_frame_tpl_eligible(cpi)) return;
  if (frame_idx >= MAX_LAG_BUFFERS) return;
  if (cpi->superres_mode != SUPERRES_NONE) return;
  if (cpi->oxcf.aq_mode != NO_AQ) return;

  const int is_overlay = cpi->gf_group.update_type[frame_idx] == OVERLAY_UPDATE;
  if (is_overlay) {
    memset(x->search_ref_frame, 1, sizeof(x->search_ref_frame));
    return;
  }

  TplDepStats *tpl_stats = tpl_frame->tpl_stats_ptr;
  const int tpl_stride = tpl_frame->stride;
  int64_t inter_cost[INTER_REFS_PER_FRAME] = { 0 };
  const int step = 1 << block_mis_log2;
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
  const int mi_row_end =
      AOMMIN(mi_size_high[sb_size] + mi_row, mi_params->mi_rows);
  const int mi_col_end =
      AOMMIN(mi_size_wide[sb_size] + mi_col, mi_params->mi_cols);

  for (int row = mi_row; row < mi_row_end; row += step) {
    for (int col = mi_col; col < mi_col_end; col += step) {
      const TplDepStats *this_stats =
          &tpl_stats[av1_tpl_ptr_pos(row, col, tpl_stride, block_mis_log2)];
      int64_t tpl_pred_error[INTER_REFS_PER_FRAME] = { 0 };
      // Find the winner ref frame idx for the current block
      int64_t best_inter_cost = this_stats->pred_error[0];
      int best_rf_idx = 0;
      for (int idx = 1; idx < INTER_REFS_PER_FRAME; ++idx) {
        if ((this_stats->pred_error[idx] < best_inter_cost) &&
            (this_stats->pred_error[idx] != 0)) {
          best_inter_cost = this_stats->pred_error[idx];
          best_rf_idx = idx;
        }
      }
      // tpl_pred_error is the pred_error reduction of best_ref w.r.t.
      // LAST_FRAME.
      tpl_pred_error[best_rf_idx] = this_stats->pred_error[best_rf_idx] -
                                    this_stats->pred_error[LAST_FRAME - 1];

      for (int rf_idx = 1; rf_idx < INTER_REFS_PER_FRAME; ++rf_idx)
        inter_cost[rf_idx] += tpl_pred_error[rf_idx];
    }
  }

  int rank_index[INTER_REFS_PER_FRAME - 1];
  for (int idx = 0; idx < INTER_REFS_PER_FRAME - 1; ++idx) {
    rank_index[idx] = idx + 1;
    for (int i = idx; i > 0; --i) {
      if (inter_cost[rank_index[i - 1]] > inter_cost[rank_index[i]]) {
        const int tmp = rank_index[i - 1];
        rank_index[i - 1] = rank_index[i];
        rank_index[i] = tmp;
      }
    }
  }

  x->search_ref_frame[INTRA_FRAME] = 1;
  x->search_ref_frame[LAST_FRAME] = 1;

  int cutoff_ref = 0;
  for (int idx = 0; idx < INTER_REFS_PER_FRAME - 1; ++idx) {
    x->search_ref_frame[rank_index[idx] + LAST_FRAME] = 1;
    if (idx > 2) {
      if (!cutoff_ref) {
        // If the predictive coding gains are smaller than the previous more
        // relevant frame over certain amount, discard this frame and all the
        // frames afterwards.
        if (llabs(inter_cost[rank_index[idx]]) <
                llabs(inter_cost[rank_index[idx - 1]]) / 8 ||
            inter_cost[rank_index[idx]] == 0)
          cutoff_ref = 1;
      }

      if (cutoff_ref) x->search_ref_frame[rank_index[idx] + LAST_FRAME] = 0;
    }
  }
}
#endif  // !CONFIG_REALTIME_ONLY

// This function initializes the stats for encode_rd_sb.
static INLINE void init_encode_rd_sb(AV1_COMP *cpi, ThreadData *td,
                                     const TileDataEnc *tile_data,
                                     PC_TREE *pc_root, RD_STATS *rd_cost,
                                     int mi_row, int mi_col,
                                     int gather_tpl_data) {
  const AV1_COMMON *cm = &cpi->common;
  const TileInfo *tile_info = &tile_data->tile_info;
  MACROBLOCK *x = &td->mb;

  const SPEED_FEATURES *sf = &cpi->sf;
  const int use_simple_motion_search =
      (sf->part_sf.simple_motion_search_split ||
       sf->part_sf.simple_motion_search_prune_rect ||
       sf->part_sf.simple_motion_search_early_term_none ||
       sf->part_sf.ml_early_term_after_part_split_level) &&
      !frame_is_intra_only(cm);
  if (use_simple_motion_search) {
    init_simple_motion_search_mvs(pc_root);
  }

#if !CONFIG_REALTIME_ONLY
  init_ref_frame_space(cpi, td, mi_row, mi_col);
  x->sb_energy_level = 0;
  x->cnn_output_valid = 0;
  if (gather_tpl_data) {
    if (cm->delta_q_info.delta_q_present_flag) {
      const int num_planes = av1_num_planes(cm);
      const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
      setup_delta_q(cpi, td, x, tile_info, mi_row, mi_col, num_planes);
      av1_tpl_rdmult_setup_sb(cpi, x, sb_size, mi_row, mi_col);
    }
    if (cpi->oxcf.enable_tpl_model) {
      adjust_rdmult_tpl_model(cpi, x, mi_row, mi_col);
    }
  }
#else
  (void)tile_info;
  (void)mi_row;
  (void)mi_col;
  (void)gather_tpl_data;
#endif

  // Reset hash state for transform/mode rd hash information
  reset_hash_records(x, cpi->sf.tx_sf.use_inter_txb_hash);
  av1_zero(x->picked_ref_frames_mask);
  av1_zero(x->pred_mv);
  av1_invalid_rd_stats(rd_cost);
}

static AOM_INLINE void encode_rd_sb(AV1_COMP *cpi, ThreadData *td,
                                    TileDataEnc *tile_data,
                                    PC_TREE *const pc_root, TOKENEXTRA **tp,
                                    const int mi_row, const int mi_col,
                                    const int seg_skip) {
  AV1_COMMON *const cm = &cpi->common;
  MACROBLOCK *const x = &td->mb;
  const SPEED_FEATURES *const sf = &cpi->sf;
  const TileInfo *const tile_info = &tile_data->tile_info;
  MB_MODE_INFO **mi = cm->mi_params.mi_grid_base +
                      get_mi_grid_idx(&cm->mi_params, mi_row, mi_col);
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
  int dummy_rate;
  int64_t dummy_dist;
  RD_STATS dummy_rdc;

#if CONFIG_REALTIME_ONLY
  (void)seg_skip;
#endif  // CONFIG_REALTIME_ONLY

  init_encode_rd_sb(cpi, td, tile_data, pc_root, &dummy_rdc, mi_row, mi_col, 1);

  if (sf->part_sf.partition_search_type == VAR_BASED_PARTITION) {
    set_offsets_without_segment_id(cpi, tile_info, x, mi_row, mi_col, sb_size);
    av1_choose_var_based_partitioning(cpi, tile_info, td, x, mi_row, mi_col);
    rd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, sb_size,
                     &dummy_rate, &dummy_dist, 1, pc_root);
  }
#if !CONFIG_REALTIME_ONLY
  else if (sf->part_sf.partition_search_type == FIXED_PARTITION || seg_skip) {
    set_offsets(cpi, tile_info, x, mi_row, mi_col, sb_size);
    const BLOCK_SIZE bsize =
        seg_skip ? sb_size : sf->part_sf.always_this_block_size;
    set_fixed_partitioning(cpi, tile_info, mi, mi_row, mi_col, bsize);
    rd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, sb_size,
                     &dummy_rate, &dummy_dist, 1, pc_root);
  } else if (cpi->partition_search_skippable_frame) {
    set_offsets(cpi, tile_info, x, mi_row, mi_col, sb_size);
    const BLOCK_SIZE bsize =
        get_rd_var_based_fixed_partition(cpi, x, mi_row, mi_col);
    set_fixed_partitioning(cpi, tile_info, mi, mi_row, mi_col, bsize);
    rd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, sb_size,
                     &dummy_rate, &dummy_dist, 1, pc_root);
  } else {
    // No stats for overlay frames. Exclude key frame.
    x->valid_cost_b =
        get_tpl_stats_b(cpi, sb_size, mi_row, mi_col, x->intra_cost_b,
                        x->inter_cost_b, x->mv_b, &x->cost_stride);

    reset_partition(pc_root, sb_size);

#if CONFIG_COLLECT_COMPONENT_TIMING
    start_timing(cpi, rd_pick_partition_time);
#endif
    BLOCK_SIZE max_sq_size = x->max_partition_size;
    BLOCK_SIZE min_sq_size = x->min_partition_size;

    if (use_auto_max_partition(cpi, sb_size, mi_row, mi_col)) {
      float features[FEATURE_SIZE_MAX_MIN_PART_PRED] = { 0.0f };

      av1_get_max_min_partition_features(cpi, x, mi_row, mi_col, features);
      max_sq_size = AOMMAX(
          AOMMIN(av1_predict_max_partition(cpi, x, features), max_sq_size),
          min_sq_size);
    }

    const int num_passes = cpi->oxcf.sb_multipass_unit_test ? 2 : 1;

    if (num_passes == 1) {
      rd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, sb_size,
                        max_sq_size, min_sq_size, &dummy_rdc, dummy_rdc,
                        pc_root, NULL, SB_SINGLE_PASS, NULL);
    } else {
      // First pass
      SB_FIRST_PASS_STATS sb_fp_stats;
      backup_sb_state(&sb_fp_stats, cpi, td, tile_data, mi_row, mi_col);
      rd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, sb_size,
                        max_sq_size, min_sq_size, &dummy_rdc, dummy_rdc,
                        pc_root, NULL, SB_DRY_PASS, NULL);

      // Second pass
      init_encode_rd_sb(cpi, td, tile_data, pc_root, &dummy_rdc, mi_row, mi_col,
                        0);
      reset_mbmi(&cm->mi_params, sb_size, mi_row, mi_col);
      reset_partition(pc_root, sb_size);

      restore_sb_state(&sb_fp_stats, cpi, td, tile_data, mi_row, mi_col);

      rd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, sb_size,
                        max_sq_size, min_sq_size, &dummy_rdc, dummy_rdc,
                        pc_root, NULL, SB_WET_PASS, NULL);
    }
    // Reset to 0 so that it wouldn't be used elsewhere mistakenly.
    x->valid_cost_b = 0;
#if CONFIG_COLLECT_COMPONENT_TIMING
    end_timing(cpi, rd_pick_partition_time);
#endif
  }
#endif  // !CONFIG_REALTIME_ONLY

  // TODO(angiebird): Let inter_mode_rd_model_estimation support multi-tile.
  if (cpi->sf.inter_sf.inter_mode_rd_model_estimation == 1 &&
      cm->tiles.cols == 1 && cm->tiles.rows == 1) {
    av1_inter_mode_data_fit(tile_data, x->rdmult);
  }
}

static AOM_INLINE void set_cost_upd_freq(AV1_COMP *cpi, ThreadData *td,
                                         const TileInfo *const tile_info,
                                         const int mi_row, const int mi_col) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;

  switch (cpi->oxcf.coeff_cost_upd_freq) {
    case COST_UPD_TILE:  // Tile level
      if (mi_row != tile_info->mi_row_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SBROW:  // SB row level in tile
      if (mi_col != tile_info->mi_col_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SB:  // SB level
      if (cpi->sf.inter_sf.disable_sb_level_coeff_cost_upd &&
          mi_col != tile_info->mi_col_start)
        break;
      av1_fill_coeff_costs(&td->mb, xd->tile_ctx, num_planes);
      break;
    default: assert(0);
  }

  switch (cpi->oxcf.mode_cost_upd_freq) {
    case COST_UPD_TILE:  // Tile level
      if (mi_row != tile_info->mi_row_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SBROW:  // SB row level in tile
      if (mi_col != tile_info->mi_col_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SB:  // SB level
      av1_fill_mode_rates(cm, x, xd->tile_ctx);
      break;
    default: assert(0);
  }
  switch (cpi->oxcf.mv_cost_upd_freq) {
    case COST_UPD_OFF: break;
    case COST_UPD_TILE:  // Tile level
      if (mi_row != tile_info->mi_row_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SBROW:  // SB row level in tile
      if (mi_col != tile_info->mi_col_start) break;
      AOM_FALLTHROUGH_INTENDED;
    case COST_UPD_SB:  // SB level
      if (cpi->sf.inter_sf.disable_sb_level_mv_cost_upd &&
          mi_col != tile_info->mi_col_start)
        break;
      av1_fill_mv_costs(xd->tile_ctx, cm->features.cur_frame_force_integer_mv,
                        cm->features.allow_high_precision_mv, x);
      break;
    default: assert(0);
  }
}

static AOM_INLINE void encode_sb_row(AV1_COMP *cpi, ThreadData *td,
                                     TileDataEnc *tile_data, int mi_row,
                                     TOKENEXTRA **tp) {
  AV1_COMMON *const cm = &cpi->common;
  const TileInfo *const tile_info = &tile_data->tile_info;
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const int sb_cols_in_tile = av1_get_sb_cols_in_tile(cm, tile_data->tile_info);
  const BLOCK_SIZE sb_size = cm->seq_params.sb_size;
  const int mib_size = cm->seq_params.mib_size;
  const int mib_size_log2 = cm->seq_params.mib_size_log2;
  const int sb_row = (mi_row - tile_info->mi_row_start) >> mib_size_log2;
  const int use_nonrd_mode = cpi->sf.rt_sf.use_nonrd_pick_mode;

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, encode_sb_time);
#endif

  // Initialize the left context for the new SB row
  av1_zero_left_context(xd);

  // Reset delta for every tile
  if (mi_row == tile_info->mi_row_start || cpi->row_mt) {
    if (cm->delta_q_info.delta_q_present_flag)
      xd->current_qindex = cm->quant_params.base_qindex;
    if (cm->delta_q_info.delta_lf_present_flag) {
      av1_reset_loop_filter_delta(xd, av1_num_planes(cm));
    }
  }
  reset_thresh_freq_fact(x);

  // Code each SB in the row
  for (int mi_col = tile_info->mi_col_start, sb_col_in_tile = 0;
       mi_col < tile_info->mi_col_end; mi_col += mib_size, sb_col_in_tile++) {
    (*(cpi->row_mt_sync_read_ptr))(&tile_data->row_mt_sync, sb_row,
                                   sb_col_in_tile);
    if (tile_data->allow_update_cdf && (cpi->row_mt == 1) &&
        (tile_info->mi_row_start != mi_row)) {
      if ((tile_info->mi_col_start == mi_col)) {
        // restore frame context of 1st column sb
        memcpy(xd->tile_ctx, x->row_ctx, sizeof(*xd->tile_ctx));
      } else {
        int wt_left = AVG_CDF_WEIGHT_LEFT;
        int wt_tr = AVG_CDF_WEIGHT_TOP_RIGHT;
        if (tile_info->mi_col_end > (mi_col + mib_size))
          avg_cdf_symbols(xd->tile_ctx, x->row_ctx + sb_col_in_tile, wt_left,
                          wt_tr);
        else
          avg_cdf_symbols(xd->tile_ctx, x->row_ctx + sb_col_in_tile - 1,
                          wt_left, wt_tr);
      }
    }

    set_cost_upd_freq(cpi, td, tile_info, mi_row, mi_col);

    x->color_sensitivity[0] = 0;
    x->color_sensitivity[1] = 0;
    x->content_state_sb = 0;

    PC_TREE *const pc_root = td->pc_root;
    pc_root->index = 0;

    xd->cur_frame_force_integer_mv = cm->features.cur_frame_force_integer_mv;
    td->mb.cb_coef_buff = av1_get_cb_coeff_buffer(cpi, mi_row, mi_col);
    x->source_variance = UINT_MAX;
    x->simple_motion_pred_sse = UINT_MAX;

    const struct segmentation *const seg = &cm->seg;
    int seg_skip = 0;
    if (seg->enabled) {
      const uint8_t *const map =
          seg->update_map ? cpi->enc_seg.map : cm->last_frame_seg_map;
      const int segment_id =
          map ? get_segment_id(&cm->mi_params, map, sb_size, mi_row, mi_col)
              : 0;
      seg_skip = segfeature_active(seg, segment_id, SEG_LVL_SKIP);
    }

    if (use_nonrd_mode) {
      encode_nonrd_sb(cpi, td, tile_data, pc_root, tp, mi_row, mi_col,
                      seg_skip);
    } else {
      encode_rd_sb(cpi, td, tile_data, pc_root, tp, mi_row, mi_col, seg_skip);
    }

    if (tile_data->allow_update_cdf && (cpi->row_mt == 1) &&
        (tile_info->mi_row_end > (mi_row + mib_size))) {
      if (sb_cols_in_tile == 1)
        memcpy(x->row_ctx, xd->tile_ctx, sizeof(*xd->tile_ctx));
      else if (sb_col_in_tile >= 1)
        memcpy(x->row_ctx + sb_col_in_tile - 1, xd->tile_ctx,
               sizeof(*xd->tile_ctx));
    }
    (*(cpi->row_mt_sync_write_ptr))(&tile_data->row_mt_sync, sb_row,
                                    sb_col_in_tile, sb_cols_in_tile);
  }
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, encode_sb_time);
#endif
}

static AOM_INLINE void init_encode_frame_mb_context(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCK *const x = &cpi->td.mb;
  MACROBLOCKD *const xd = &x->e_mbd;

  // Copy data over into macro block data structures.
  av1_setup_src_planes(x, cpi->source, 0, 0, num_planes,
                       cm->seq_params.sb_size);

  av1_setup_block_planes(xd, cm->seq_params.subsampling_x,
                         cm->seq_params.subsampling_y, num_planes);
}

void av1_alloc_tile_data(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;

  if (cpi->tile_data != NULL) aom_free(cpi->tile_data);
  CHECK_MEM_ERROR(
      cm, cpi->tile_data,
      aom_memalign(32, tile_cols * tile_rows * sizeof(*cpi->tile_data)));

  cpi->allocated_tiles = tile_cols * tile_rows;
}

void av1_init_tile_data(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;
  int tile_col, tile_row;
  TOKENEXTRA *pre_tok = cpi->tile_tok[0][0];
  TOKENLIST *tplist = cpi->tplist[0][0];
  unsigned int tile_tok = 0;
  int tplist_count = 0;

  for (tile_row = 0; tile_row < tile_rows; ++tile_row) {
    for (tile_col = 0; tile_col < tile_cols; ++tile_col) {
      TileDataEnc *const tile_data =
          &cpi->tile_data[tile_row * tile_cols + tile_col];
      TileInfo *const tile_info = &tile_data->tile_info;
      av1_tile_init(tile_info, cm, tile_row, tile_col);

      cpi->tile_tok[tile_row][tile_col] = pre_tok + tile_tok;
      pre_tok = cpi->tile_tok[tile_row][tile_col];
      tile_tok = allocated_tokens(
          *tile_info, cm->seq_params.mib_size_log2 + MI_SIZE_LOG2, num_planes);
      cpi->tplist[tile_row][tile_col] = tplist + tplist_count;
      tplist = cpi->tplist[tile_row][tile_col];
      tplist_count = av1_get_sb_rows_in_tile(cm, tile_data->tile_info);
      tile_data->allow_update_cdf = !cm->tiles.large_scale;
      tile_data->allow_update_cdf =
          tile_data->allow_update_cdf && !cm->features.disable_cdf_update;
      tile_data->tctx = *cm->fc;
    }
  }
}

void av1_encode_sb_row(AV1_COMP *cpi, ThreadData *td, int tile_row,
                       int tile_col, int mi_row) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  const int tile_cols = cm->tiles.cols;
  TileDataEnc *this_tile = &cpi->tile_data[tile_row * tile_cols + tile_col];
  const TileInfo *const tile_info = &this_tile->tile_info;
  TOKENEXTRA *tok = NULL;
  const int sb_row_in_tile =
      (mi_row - tile_info->mi_row_start) >> cm->seq_params.mib_size_log2;
  const int tile_mb_cols =
      (tile_info->mi_col_end - tile_info->mi_col_start + 2) >> 2;
  const int num_mb_rows_in_sb =
      ((1 << (cm->seq_params.mib_size_log2 + MI_SIZE_LOG2)) + 8) >> 4;

  get_start_tok(cpi, tile_row, tile_col, mi_row, &tok,
                cm->seq_params.mib_size_log2 + MI_SIZE_LOG2, num_planes);
  cpi->tplist[tile_row][tile_col][sb_row_in_tile].start = tok;

  encode_sb_row(cpi, td, this_tile, mi_row, &tok);

  cpi->tplist[tile_row][tile_col][sb_row_in_tile].stop = tok;
  cpi->tplist[tile_row][tile_col][sb_row_in_tile].count =
      (unsigned int)(cpi->tplist[tile_row][tile_col][sb_row_in_tile].stop -
                     cpi->tplist[tile_row][tile_col][sb_row_in_tile].start);

  assert(
      (unsigned int)(tok -
                     cpi->tplist[tile_row][tile_col][sb_row_in_tile].start) <=
      get_token_alloc(num_mb_rows_in_sb, tile_mb_cols,
                      cm->seq_params.mib_size_log2 + MI_SIZE_LOG2, num_planes));

  (void)tile_mb_cols;
  (void)num_mb_rows_in_sb;
}

void av1_encode_tile(AV1_COMP *cpi, ThreadData *td, int tile_row,
                     int tile_col) {
  AV1_COMMON *const cm = &cpi->common;
  TileDataEnc *const this_tile =
      &cpi->tile_data[tile_row * cm->tiles.cols + tile_col];
  const TileInfo *const tile_info = &this_tile->tile_info;

  if (!cpi->sf.rt_sf.use_nonrd_pick_mode) av1_inter_mode_data_init(this_tile);

  av1_zero_above_context(cm, &td->mb.e_mbd, tile_info->mi_col_start,
                         tile_info->mi_col_end, tile_row);
  av1_init_above_context(&cm->above_contexts, av1_num_planes(cm), tile_row,
                         &td->mb.e_mbd);

  if (cpi->oxcf.enable_cfl_intra) cfl_init(&td->mb.e_mbd.cfl, &cm->seq_params);

  av1_crc32c_calculator_init(&td->mb.mb_rd_record.crc_calculator);

  for (int mi_row = tile_info->mi_row_start; mi_row < tile_info->mi_row_end;
       mi_row += cm->seq_params.mib_size) {
    av1_encode_sb_row(cpi, td, tile_row, tile_col, mi_row);
  }
}

static AOM_INLINE void encode_tiles(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;
  int tile_col, tile_row;

  if (cpi->tile_data == NULL || cpi->allocated_tiles < tile_cols * tile_rows)
    av1_alloc_tile_data(cpi);

  av1_init_tile_data(cpi);

  for (tile_row = 0; tile_row < tile_rows; ++tile_row) {
    for (tile_col = 0; tile_col < tile_cols; ++tile_col) {
      TileDataEnc *const this_tile =
          &cpi->tile_data[tile_row * cm->tiles.cols + tile_col];
      cpi->td.intrabc_used = 0;
      cpi->td.deltaq_used = 0;
      cpi->td.mb.e_mbd.tile_ctx = &this_tile->tctx;
      cpi->td.mb.tile_pb_ctx = &this_tile->tctx;
      av1_encode_tile(cpi, &cpi->td, tile_row, tile_col);
      cpi->intrabc_used |= cpi->td.intrabc_used;
      cpi->deltaq_used |= cpi->td.deltaq_used;
    }
  }
}

#define GLOBAL_TRANS_TYPES_ENC 3  // highest motion model to search
static int gm_get_params_cost(const WarpedMotionParams *gm,
                              const WarpedMotionParams *ref_gm, int allow_hp) {
  int params_cost = 0;
  int trans_bits, trans_prec_diff;
  switch (gm->wmtype) {
    case AFFINE:
    case ROTZOOM:
      params_cost += aom_count_signed_primitive_refsubexpfin(
          GM_ALPHA_MAX + 1, SUBEXPFIN_K,
          (ref_gm->wmmat[2] >> GM_ALPHA_PREC_DIFF) - (1 << GM_ALPHA_PREC_BITS),
          (gm->wmmat[2] >> GM_ALPHA_PREC_DIFF) - (1 << GM_ALPHA_PREC_BITS));
      params_cost += aom_count_signed_primitive_refsubexpfin(
          GM_ALPHA_MAX + 1, SUBEXPFIN_K,
          (ref_gm->wmmat[3] >> GM_ALPHA_PREC_DIFF),
          (gm->wmmat[3] >> GM_ALPHA_PREC_DIFF));
      if (gm->wmtype >= AFFINE) {
        params_cost += aom_count_signed_primitive_refsubexpfin(
            GM_ALPHA_MAX + 1, SUBEXPFIN_K,
            (ref_gm->wmmat[4] >> GM_ALPHA_PREC_DIFF),
            (gm->wmmat[4] >> GM_ALPHA_PREC_DIFF));
        params_cost += aom_count_signed_primitive_refsubexpfin(
            GM_ALPHA_MAX + 1, SUBEXPFIN_K,
            (ref_gm->wmmat[5] >> GM_ALPHA_PREC_DIFF) -
                (1 << GM_ALPHA_PREC_BITS),
            (gm->wmmat[5] >> GM_ALPHA_PREC_DIFF) - (1 << GM_ALPHA_PREC_BITS));
      }
      AOM_FALLTHROUGH_INTENDED;
    case TRANSLATION:
      trans_bits = (gm->wmtype == TRANSLATION)
                       ? GM_ABS_TRANS_ONLY_BITS - !allow_hp
                       : GM_ABS_TRANS_BITS;
      trans_prec_diff = (gm->wmtype == TRANSLATION)
                            ? GM_TRANS_ONLY_PREC_DIFF + !allow_hp
                            : GM_TRANS_PREC_DIFF;
      params_cost += aom_count_signed_primitive_refsubexpfin(
          (1 << trans_bits) + 1, SUBEXPFIN_K,
          (ref_gm->wmmat[0] >> trans_prec_diff),
          (gm->wmmat[0] >> trans_prec_diff));
      params_cost += aom_count_signed_primitive_refsubexpfin(
          (1 << trans_bits) + 1, SUBEXPFIN_K,
          (ref_gm->wmmat[1] >> trans_prec_diff),
          (gm->wmmat[1] >> trans_prec_diff));
      AOM_FALLTHROUGH_INTENDED;
    case IDENTITY: break;
    default: assert(0);
  }
  return (params_cost << AV1_PROB_COST_SHIFT);
}

static int do_gm_search_logic(SPEED_FEATURES *const sf, int frame) {
  (void)frame;
  switch (sf->gm_sf.gm_search_type) {
    case GM_FULL_SEARCH: return 1;
    case GM_REDUCED_REF_SEARCH_SKIP_L2_L3:
      return !(frame == LAST2_FRAME || frame == LAST3_FRAME);
    case GM_REDUCED_REF_SEARCH_SKIP_L2_L3_ARF2:
      return !(frame == LAST2_FRAME || frame == LAST3_FRAME ||
               (frame == ALTREF2_FRAME));
    case GM_DISABLE_SEARCH: return 0;
    default: assert(0);
  }
  return 1;
}

// Set the relative distance of a reference frame w.r.t. current frame
static AOM_INLINE void set_rel_frame_dist(AV1_COMP *cpi) {
  const AV1_COMMON *const cm = &cpi->common;
  const OrderHintInfo *const order_hint_info = &cm->seq_params.order_hint_info;
  MV_REFERENCE_FRAME ref_frame;
  int min_past_dist = INT32_MAX, min_future_dist = INT32_MAX;
  cpi->nearest_past_ref = NONE_FRAME;
  cpi->nearest_future_ref = NONE_FRAME;
  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    cpi->ref_relative_dist[ref_frame - LAST_FRAME] = 0;
    if (cpi->ref_frame_flags & av1_ref_frame_flag_list[ref_frame]) {
      int dist = av1_encoder_get_relative_dist(
          order_hint_info,
          cm->cur_frame->ref_display_order_hint[ref_frame - LAST_FRAME],
          cm->current_frame.display_order_hint);
      cpi->ref_relative_dist[ref_frame - LAST_FRAME] = dist;
      // Get the nearest ref_frame in the past
      if (abs(dist) < min_past_dist && dist < 0) {
        cpi->nearest_past_ref = ref_frame;
        min_past_dist = abs(dist);
      }
      // Get the nearest ref_frame in the future
      if (dist < min_future_dist && dist > 0) {
        cpi->nearest_future_ref = ref_frame;
        min_future_dist = dist;
      }
    }
  }
}

static INLINE int refs_are_one_sided(const AV1_COMMON *cm) {
  assert(!frame_is_intra_only(cm));

  int one_sided_refs = 1;
  for (int ref = LAST_FRAME; ref <= ALTREF_FRAME; ++ref) {
    const RefCntBuffer *const buf = get_ref_frame_buf(cm, ref);
    if (buf == NULL) continue;

    const int ref_display_order_hint = buf->display_order_hint;
    if (av1_encoder_get_relative_dist(
            &cm->seq_params.order_hint_info, ref_display_order_hint,
            (int)cm->current_frame.display_order_hint) > 0) {
      one_sided_refs = 0;  // bwd reference
      break;
    }
  }
  return one_sided_refs;
}

static INLINE void get_skip_mode_ref_offsets(const AV1_COMMON *cm,
                                             int ref_order_hint[2]) {
  const SkipModeInfo *const skip_mode_info = &cm->current_frame.skip_mode_info;
  ref_order_hint[0] = ref_order_hint[1] = 0;
  if (!skip_mode_info->skip_mode_allowed) return;

  const RefCntBuffer *const buf_0 =
      get_ref_frame_buf(cm, LAST_FRAME + skip_mode_info->ref_frame_idx_0);
  const RefCntBuffer *const buf_1 =
      get_ref_frame_buf(cm, LAST_FRAME + skip_mode_info->ref_frame_idx_1);
  assert(buf_0 != NULL && buf_1 != NULL);

  ref_order_hint[0] = buf_0->order_hint;
  ref_order_hint[1] = buf_1->order_hint;
}

static int check_skip_mode_enabled(AV1_COMP *const cpi) {
  AV1_COMMON *const cm = &cpi->common;

  av1_setup_skip_mode_allowed(cm);
  if (!cm->current_frame.skip_mode_info.skip_mode_allowed) return 0;

  // Turn off skip mode if the temporal distances of the reference pair to the
  // current frame are different by more than 1 frame.
  const int cur_offset = (int)cm->current_frame.order_hint;
  int ref_offset[2];
  get_skip_mode_ref_offsets(cm, ref_offset);
  const int cur_to_ref0 = get_relative_dist(&cm->seq_params.order_hint_info,
                                            cur_offset, ref_offset[0]);
  const int cur_to_ref1 = abs(get_relative_dist(&cm->seq_params.order_hint_info,
                                                cur_offset, ref_offset[1]));
  if (abs(cur_to_ref0 - cur_to_ref1) > 1) return 0;

  // High Latency: Turn off skip mode if all refs are fwd.
  if (cpi->all_one_sided_refs && cpi->oxcf.lag_in_frames > 0) return 0;

  static const int flag_list[REF_FRAMES] = { 0,
                                             AOM_LAST_FLAG,
                                             AOM_LAST2_FLAG,
                                             AOM_LAST3_FLAG,
                                             AOM_GOLD_FLAG,
                                             AOM_BWD_FLAG,
                                             AOM_ALT2_FLAG,
                                             AOM_ALT_FLAG };
  const int ref_frame[2] = {
    cm->current_frame.skip_mode_info.ref_frame_idx_0 + LAST_FRAME,
    cm->current_frame.skip_mode_info.ref_frame_idx_1 + LAST_FRAME
  };
  if (!(cpi->ref_frame_flags & flag_list[ref_frame[0]]) ||
      !(cpi->ref_frame_flags & flag_list[ref_frame[1]]))
    return 0;

  return 1;
}

// Function to decide if we can skip the global motion parameter computation
// for a particular ref frame
static INLINE int skip_gm_frame(AV1_COMMON *const cm, int ref_frame) {
  if ((ref_frame == LAST3_FRAME || ref_frame == LAST2_FRAME) &&
      cm->global_motion[GOLDEN_FRAME].wmtype != IDENTITY) {
    return get_relative_dist(
               &cm->seq_params.order_hint_info,
               cm->cur_frame->ref_order_hints[ref_frame - LAST_FRAME],
               cm->cur_frame->ref_order_hints[GOLDEN_FRAME - LAST_FRAME]) <= 0;
  }
  return 0;
}

static AOM_INLINE void set_default_interp_skip_flags(
    const AV1_COMMON *cm, InterpSearchFlags *interp_search_flags) {
  const int num_planes = av1_num_planes(cm);
  interp_search_flags->default_interp_skip_flags =
      (num_planes == 1) ? INTERP_SKIP_LUMA_EVAL_CHROMA
                        : INTERP_SKIP_LUMA_SKIP_CHROMA;
}

// TODO(Remya): Can include erroradv_prod_tr[] for threshold calculation
static INLINE int64_t calc_erroradv_threshold(AV1_COMP *cpi,
                                              int64_t ref_frame_error) {
  if (!cpi->sf.gm_sf.disable_adaptive_warp_error_thresh)
    return (int64_t)(
        ref_frame_error * erroradv_tr[cpi->sf.gm_sf.gm_erroradv_type] + 0.5);
  else
    return INT64_MAX;
}

static void compute_global_motion_for_ref_frame(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG *ref_buf[REF_FRAMES], int frame,
    int *num_frm_corners, int *frm_corners, unsigned char *frm_buffer,
    MotionModel *params_by_motion, uint8_t *segment_map,
    const int segment_map_w, const int segment_map_h,
    const WarpedMotionParams *ref_params) {
  ThreadData *const td = &cpi->td;
  MACROBLOCK *const x = &td->mb;
  AV1_COMMON *const cm = &cpi->common;
  MACROBLOCKD *const xd = &x->e_mbd;
  int i;
  // clang-format off
  static const double kIdentityParams[MAX_PARAMDIM - 1] = {
     0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0
  };
  // clang-format on
  WarpedMotionParams tmp_wm_params;
  const double *params_this_motion;
  int inliers_by_motion[RANSAC_NUM_MOTIONS];
  assert(ref_buf[frame] != NULL);
  if (*num_frm_corners < 0) {
    // compute interest points using FAST features
    *num_frm_corners = av1_fast_corner_detect(
        frm_buffer, cpi->source->y_width, cpi->source->y_height,
        cpi->source->y_stride, frm_corners, MAX_CORNERS);
  }
  TransformationType model;

  aom_clear_system_state();

  // TODO(sarahparker, debargha): Explore do_adaptive_gm_estimation = 1
  const int do_adaptive_gm_estimation = 0;

  const int ref_frame_dist = get_relative_dist(
      &cm->seq_params.order_hint_info, cm->current_frame.order_hint,
      cm->cur_frame->ref_order_hints[frame - LAST_FRAME]);
  const GlobalMotionEstimationType gm_estimation_type =
      cm->seq_params.order_hint_info.enable_order_hint &&
              abs(ref_frame_dist) <= 2 && do_adaptive_gm_estimation
          ? GLOBAL_MOTION_DISFLOW_BASED
          : GLOBAL_MOTION_FEATURE_BASED;
  for (model = ROTZOOM; model < GLOBAL_TRANS_TYPES_ENC; ++model) {
    int64_t best_warp_error = INT64_MAX;
    // Initially set all params to identity.
    for (i = 0; i < RANSAC_NUM_MOTIONS; ++i) {
      memcpy(params_by_motion[i].params, kIdentityParams,
             (MAX_PARAMDIM - 1) * sizeof(*(params_by_motion[i].params)));
      params_by_motion[i].num_inliers = 0;
    }

    av1_compute_global_motion(
        model, frm_buffer, cpi->source->y_width, cpi->source->y_height,
        cpi->source->y_stride, frm_corners, *num_frm_corners, ref_buf[frame],
        cpi->common.seq_params.bit_depth, gm_estimation_type, inliers_by_motion,
        params_by_motion, RANSAC_NUM_MOTIONS);
    int64_t ref_frame_error = 0;
    for (i = 0; i < RANSAC_NUM_MOTIONS; ++i) {
      if (inliers_by_motion[i] == 0) continue;

      params_this_motion = params_by_motion[i].params;
      av1_convert_model_to_params(params_this_motion, &tmp_wm_params);

      if (tmp_wm_params.wmtype != IDENTITY) {
        av1_compute_feature_segmentation_map(
            segment_map, segment_map_w, segment_map_h,
            params_by_motion[i].inliers, params_by_motion[i].num_inliers);

        ref_frame_error = av1_segmented_frame_error(
            is_cur_buf_hbd(xd), xd->bd, ref_buf[frame]->y_buffer,
            ref_buf[frame]->y_stride, cpi->source->y_buffer,
            cpi->source->y_width, cpi->source->y_height, cpi->source->y_stride,
            segment_map, segment_map_w);

        int64_t erroradv_threshold =
            calc_erroradv_threshold(cpi, ref_frame_error);

        const int64_t warp_error = av1_refine_integerized_param(
            &tmp_wm_params, tmp_wm_params.wmtype, is_cur_buf_hbd(xd), xd->bd,
            ref_buf[frame]->y_buffer, ref_buf[frame]->y_width,
            ref_buf[frame]->y_height, ref_buf[frame]->y_stride,
            cpi->source->y_buffer, cpi->source->y_width, cpi->source->y_height,
            cpi->source->y_stride, GM_REFINEMENT_COUNT, best_warp_error,
            segment_map, segment_map_w, erroradv_threshold);

        if (warp_error < best_warp_error) {
          best_warp_error = warp_error;
          // Save the wm_params modified by
          // av1_refine_integerized_param() rather than motion index to
          // avoid rerunning refine() below.
          memcpy(&(cm->global_motion[frame]), &tmp_wm_params,
                 sizeof(WarpedMotionParams));
        }
      }
    }
    if (cm->global_motion[frame].wmtype <= AFFINE)
      if (!av1_get_shear_params(&cm->global_motion[frame]))
        cm->global_motion[frame] = default_warp_params;

    if (cm->global_motion[frame].wmtype == TRANSLATION) {
      cm->global_motion[frame].wmmat[0] =
          convert_to_trans_prec(cm->features.allow_high_precision_mv,
                                cm->global_motion[frame].wmmat[0]) *
          GM_TRANS_ONLY_DECODE_FACTOR;
      cm->global_motion[frame].wmmat[1] =
          convert_to_trans_prec(cm->features.allow_high_precision_mv,
                                cm->global_motion[frame].wmmat[1]) *
          GM_TRANS_ONLY_DECODE_FACTOR;
    }

    if (cm->global_motion[frame].wmtype == IDENTITY) continue;

    if (ref_frame_error == 0) continue;

    // If the best error advantage found doesn't meet the threshold for
    // this motion type, revert to IDENTITY.
    if (!av1_is_enough_erroradvantage(
            (double)best_warp_error / ref_frame_error,
            gm_get_params_cost(&cm->global_motion[frame], ref_params,
                               cm->features.allow_high_precision_mv),
            cpi->sf.gm_sf.gm_erroradv_type)) {
      cm->global_motion[frame] = default_warp_params;
    }

    if (cm->global_motion[frame].wmtype != IDENTITY) break;
  }

  aom_clear_system_state();
}

typedef struct {
  int distance;
  MV_REFERENCE_FRAME frame;
} FrameDistPair;

static INLINE void update_valid_ref_frames_for_gm(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG *ref_buf[REF_FRAMES],
    FrameDistPair *past_ref_frame, FrameDistPair *future_ref_frame,
    int *num_past_ref_frames, int *num_future_ref_frames) {
  AV1_COMMON *const cm = &cpi->common;
  const OrderHintInfo *const order_hint_info = &cm->seq_params.order_hint_info;
  for (int frame = ALTREF_FRAME; frame >= LAST_FRAME; --frame) {
    const MV_REFERENCE_FRAME ref_frame[2] = { frame, NONE_FRAME };
    RefCntBuffer *buf = get_ref_frame_buf(cm, frame);
    const int ref_disabled =
        !(cpi->ref_frame_flags & av1_ref_frame_flag_list[frame]);
    ref_buf[frame] = NULL;
    cm->global_motion[frame] = default_warp_params;
    // Skip global motion estimation for invalid ref frames
    if (buf == NULL ||
        (ref_disabled && cpi->sf.hl_sf.recode_loop != DISALLOW_RECODE)) {
      cpi->gm_info.params_cost[frame] = 0;
      continue;
    } else {
      ref_buf[frame] = &buf->buf;
    }

    if (ref_buf[frame]->y_crop_width == cpi->source->y_crop_width &&
        ref_buf[frame]->y_crop_height == cpi->source->y_crop_height &&
        do_gm_search_logic(&cpi->sf, frame) &&
        !prune_ref_by_selective_ref_frame(
            cpi, NULL, ref_frame, cm->cur_frame->ref_display_order_hint) &&
        !(cpi->sf.gm_sf.selective_ref_gm && skip_gm_frame(cm, frame))) {
      assert(ref_buf[frame] != NULL);
      int relative_frame_dist = av1_encoder_get_relative_dist(
          order_hint_info, buf->display_order_hint,
          cm->cur_frame->display_order_hint);
      // Populate past and future ref frames
      if (relative_frame_dist <= 0) {
        past_ref_frame[*num_past_ref_frames].distance =
            abs(relative_frame_dist);
        past_ref_frame[*num_past_ref_frames].frame = frame;
        (*num_past_ref_frames)++;
      } else {
        future_ref_frame[*num_future_ref_frames].distance =
            abs(relative_frame_dist);
        future_ref_frame[*num_future_ref_frames].frame = frame;
        (*num_future_ref_frames)++;
      }
    }
  }
}

static INLINE void compute_gm_for_valid_ref_frames(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG *ref_buf[REF_FRAMES], int frame,
    int *num_frm_corners, int *frm_corners, unsigned char *frm_buffer,
    MotionModel *params_by_motion, uint8_t *segment_map,
    const int segment_map_w, const int segment_map_h) {
  AV1_COMMON *const cm = &cpi->common;
  GlobalMotionInfo *const gm_info = &cpi->gm_info;
  const WarpedMotionParams *ref_params =
      cm->prev_frame ? &cm->prev_frame->global_motion[frame]
                     : &default_warp_params;

  compute_global_motion_for_ref_frame(
      cpi, ref_buf, frame, num_frm_corners, frm_corners, frm_buffer,
      params_by_motion, segment_map, segment_map_w, segment_map_h, ref_params);

  gm_info->params_cost[frame] =
      gm_get_params_cost(&cm->global_motion[frame], ref_params,
                         cm->features.allow_high_precision_mv) +
      gm_info->type_cost[cm->global_motion[frame].wmtype] -
      gm_info->type_cost[IDENTITY];
}

static int compare_distance(const void *a, const void *b) {
  const int diff =
      ((FrameDistPair *)a)->distance - ((FrameDistPair *)b)->distance;
  if (diff > 0)
    return 1;
  else if (diff < 0)
    return -1;
  return 0;
}

static INLINE void compute_global_motion_for_references(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG *ref_buf[REF_FRAMES],
    FrameDistPair reference_frame[REF_FRAMES - 1], int num_ref_frames,
    int *num_frm_corners, int *frm_corners, unsigned char *frm_buffer,
    MotionModel *params_by_motion, uint8_t *segment_map,
    const int segment_map_w, const int segment_map_h) {
  AV1_COMMON *const cm = &cpi->common;
  // Compute global motion w.r.t. reference frames starting from the nearest ref
  // frame in a given direction
  for (int frame = 0; frame < num_ref_frames; frame++) {
    int ref_frame = reference_frame[frame].frame;
    compute_gm_for_valid_ref_frames(cpi, ref_buf, ref_frame, num_frm_corners,
                                    frm_corners, frm_buffer, params_by_motion,
                                    segment_map, segment_map_w, segment_map_h);
    // If global motion w.r.t. current ref frame is
    // INVALID/TRANSLATION/IDENTITY, skip the evaluation of global motion w.r.t
    // the remaining ref frames in that direction. The below exit is disabled
    // when ref frame distance w.r.t. current frame is zero. E.g.:
    // source_alt_ref_frame w.r.t. ARF frames
    if (cpi->sf.gm_sf.prune_ref_frame_for_gm_search &&
        reference_frame[frame].distance != 0 &&
        cm->global_motion[ref_frame].wmtype != ROTZOOM)
      break;
  }
}

static AOM_INLINE void setup_prune_ref_frame_mask(AV1_COMP *cpi) {
  if (!cpi->sf.rt_sf.use_nonrd_pick_mode &&
      cpi->sf.inter_sf.selective_ref_frame >= 2) {
    AV1_COMMON *const cm = &cpi->common;
    const OrderHintInfo *const order_hint_info =
        &cm->seq_params.order_hint_info;
    const int cur_frame_display_order_hint =
        cm->current_frame.display_order_hint;
    unsigned int *ref_display_order_hint =
        cm->cur_frame->ref_display_order_hint;
    const int arf2_dist = av1_encoder_get_relative_dist(
        order_hint_info, ref_display_order_hint[ALTREF2_FRAME - LAST_FRAME],
        cur_frame_display_order_hint);
    const int bwd_dist = av1_encoder_get_relative_dist(
        order_hint_info, ref_display_order_hint[BWDREF_FRAME - LAST_FRAME],
        cur_frame_display_order_hint);

    for (int ref_idx = REF_FRAMES; ref_idx < MODE_CTX_REF_FRAMES; ++ref_idx) {
      MV_REFERENCE_FRAME rf[2];
      av1_set_ref_frame(rf, ref_idx);
      if (!(cpi->ref_frame_flags & av1_ref_frame_flag_list[rf[0]]) ||
          !(cpi->ref_frame_flags & av1_ref_frame_flag_list[rf[1]])) {
        continue;
      }

      if (!cpi->all_one_sided_refs) {
        int ref_dist[2];
        for (int i = 0; i < 2; ++i) {
          ref_dist[i] = av1_encoder_get_relative_dist(
              order_hint_info, ref_display_order_hint[rf[i] - LAST_FRAME],
              cur_frame_display_order_hint);
        }

        // One-sided compound is used only when all reference frames are
        // one-sided.
        if ((ref_dist[0] > 0) == (ref_dist[1] > 0)) {
          cpi->prune_ref_frame_mask |= 1 << ref_idx;
        }
      }

      if (cpi->sf.inter_sf.selective_ref_frame >= 4 &&
          (rf[0] == ALTREF2_FRAME || rf[1] == ALTREF2_FRAME) &&
          (cpi->ref_frame_flags & av1_ref_frame_flag_list[BWDREF_FRAME])) {
        // Check if both ALTREF2_FRAME and BWDREF_FRAME are future references.
        if (arf2_dist > 0 && bwd_dist > 0 && bwd_dist <= arf2_dist) {
          // Drop ALTREF2_FRAME as a reference if BWDREF_FRAME is a closer
          // reference to the current frame than ALTREF2_FRAME
          cpi->prune_ref_frame_mask |= 1 << ref_idx;
        }
      }
    }
  }
}

#define CHECK_PRECOMPUTED_REF_FRAME_MAP 0

static AOM_INLINE void encode_frame_internal(AV1_COMP *cpi) {
  ThreadData *const td = &cpi->td;
  MACROBLOCK *const x = &td->mb;
  AV1_COMMON *const cm = &cpi->common;
  CommonModeInfoParams *const mi_params = &cm->mi_params;
  FeatureFlags *const features = &cm->features;
  MACROBLOCKD *const xd = &x->e_mbd;
  RD_COUNTS *const rdc = &cpi->td.rd_counts;
  GlobalMotionInfo *const gm_info = &cpi->gm_info;
  FrameProbInfo *const frame_probs = &cpi->frame_probs;
  IntraBCHashInfo *const intrabc_hash_info = &x->intrabc_hash_info;
  int i;

  if (!cpi->sf.rt_sf.use_nonrd_pick_mode) {
    mi_params->setup_mi(mi_params);
  }

  set_mi_offsets(mi_params, xd, 0, 0);

#if CONFIG_AV1_HIGHBITDEPTH
  x->fwd_txfm4x4 = aom_fdct4x4;
#else
  x->fwd_txfm4x4 = aom_fdct4x4_lp;
#endif

  av1_zero(*td->counts);
  av1_zero(rdc->comp_pred_diff);
  av1_zero(rdc->tx_type_used);
  av1_zero(rdc->obmc_used);
  av1_zero(rdc->warped_used);

  // Reset the flag.
  cpi->intrabc_used = 0;
  // Need to disable intrabc when superres is selected
  if (av1_superres_scaled(cm)) {
    features->allow_intrabc = 0;
  }

  features->allow_intrabc &= (cpi->oxcf.enable_intrabc);

  if (features->allow_warped_motion &&
      cpi->sf.inter_sf.prune_warped_prob_thresh > 0) {
    const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);
    if (frame_probs->warped_probs[update_type] <
        cpi->sf.inter_sf.prune_warped_prob_thresh)
      features->allow_warped_motion = 0;
  }

  int hash_table_created = 0;
  if (!is_stat_generation_stage(cpi) && av1_use_hash_me(cpi) &&
      !cpi->sf.rt_sf.use_nonrd_pick_mode) {
    // TODO(any): move this outside of the recoding loop to avoid recalculating
    // the hash table.
    // add to hash table
    const int pic_width = cpi->source->y_crop_width;
    const int pic_height = cpi->source->y_crop_height;
    uint32_t *block_hash_values[2][2];
    int8_t *is_block_same[2][3];
    int k, j;

    for (k = 0; k < 2; k++) {
      for (j = 0; j < 2; j++) {
        CHECK_MEM_ERROR(cm, block_hash_values[k][j],
                        aom_malloc(sizeof(uint32_t) * pic_width * pic_height));
      }

      for (j = 0; j < 3; j++) {
        CHECK_MEM_ERROR(cm, is_block_same[k][j],
                        aom_malloc(sizeof(int8_t) * pic_width * pic_height));
      }
    }

    av1_hash_table_init(intrabc_hash_info);
    av1_hash_table_create(&intrabc_hash_info->intrabc_hash_table);
    hash_table_created = 1;
    av1_generate_block_2x2_hash_value(intrabc_hash_info, cpi->source,
                                      block_hash_values[0], is_block_same[0]);
    // Hash data generated for screen contents is used for intraBC ME
    const int min_alloc_size = block_size_wide[mi_params->mi_alloc_bsize];
    const int max_sb_size =
        (1 << (cm->seq_params.mib_size_log2 + MI_SIZE_LOG2));
    int src_idx = 0;
    for (int size = 4; size <= max_sb_size; size *= 2, src_idx = !src_idx) {
      const int dst_idx = !src_idx;
      av1_generate_block_hash_value(
          intrabc_hash_info, cpi->source, size, block_hash_values[src_idx],
          block_hash_values[dst_idx], is_block_same[src_idx],
          is_block_same[dst_idx]);
      if (size >= min_alloc_size) {
        av1_add_to_hash_map_by_row_with_precal_data(
            &intrabc_hash_info->intrabc_hash_table, block_hash_values[dst_idx],
            is_block_same[dst_idx][2], pic_width, pic_height, size);
      }
    }

    for (k = 0; k < 2; k++) {
      for (j = 0; j < 2; j++) {
        aom_free(block_hash_values[k][j]);
      }

      for (j = 0; j < 3; j++) {
        aom_free(is_block_same[k][j]);
      }
    }
  }

  const CommonQuantParams *quant_params = &cm->quant_params;
  for (i = 0; i < MAX_SEGMENTS; ++i) {
    const int qindex =
        cm->seg.enabled ? av1_get_qindex(&cm->seg, i, quant_params->base_qindex)
                        : quant_params->base_qindex;
    xd->lossless[i] =
        qindex == 0 && quant_params->y_dc_delta_q == 0 &&
        quant_params->u_dc_delta_q == 0 && quant_params->u_ac_delta_q == 0 &&
        quant_params->v_dc_delta_q == 0 && quant_params->v_ac_delta_q == 0;
    if (xd->lossless[i]) cpi->enc_seg.has_lossless_segment = 1;
    xd->qindex[i] = qindex;
    if (xd->lossless[i]) {
      cpi->optimize_seg_arr[i] = NO_TRELLIS_OPT;
    } else {
      cpi->optimize_seg_arr[i] = cpi->sf.rd_sf.optimize_coefficients;
    }
  }
  features->coded_lossless = is_coded_lossless(cm, xd);
  features->all_lossless = features->coded_lossless && !av1_superres_scaled(cm);

  // Fix delta q resolution for the moment
  cm->delta_q_info.delta_q_res = 0;
  if (cpi->oxcf.deltaq_mode == DELTA_Q_OBJECTIVE)
    cm->delta_q_info.delta_q_res = DEFAULT_DELTA_Q_RES_OBJECTIVE;
  else if (cpi->oxcf.deltaq_mode == DELTA_Q_PERCEPTUAL)
    cm->delta_q_info.delta_q_res = DEFAULT_DELTA_Q_RES_PERCEPTUAL;
  // Set delta_q_present_flag before it is used for the first time
  cm->delta_q_info.delta_lf_res = DEFAULT_DELTA_LF_RES;
  cm->delta_q_info.delta_q_present_flag = cpi->oxcf.deltaq_mode != NO_DELTA_Q;

  // Turn off cm->delta_q_info.delta_q_present_flag if objective delta_q is used
  // for ineligible frames. That effectively will turn off row_mt usage.
  // Note objective delta_q and tpl eligible frames are only altref frames
  // currently.
  if (cm->delta_q_info.delta_q_present_flag) {
    if (cpi->oxcf.deltaq_mode == DELTA_Q_OBJECTIVE &&
        !is_frame_tpl_eligible(cpi))
      cm->delta_q_info.delta_q_present_flag = 0;
  }

  // Reset delta_q_used flag
  cpi->deltaq_used = 0;

  cm->delta_q_info.delta_lf_present_flag =
      cm->delta_q_info.delta_q_present_flag && cpi->oxcf.deltalf_mode;
  cm->delta_q_info.delta_lf_multi = DEFAULT_DELTA_LF_MULTI;

  // update delta_q_present_flag and delta_lf_present_flag based on
  // base_qindex
  cm->delta_q_info.delta_q_present_flag &= quant_params->base_qindex > 0;
  cm->delta_q_info.delta_lf_present_flag &= quant_params->base_qindex > 0;

  av1_frame_init_quantizer(cpi);
  av1_initialize_rd_consts(cpi);
  av1_initialize_me_consts(cpi, x, quant_params->base_qindex);

  init_encode_frame_mb_context(cpi);
  set_default_interp_skip_flags(cm, &cpi->interp_search_flags);
  if (cm->prev_frame && cm->prev_frame->seg.enabled)
    cm->last_frame_seg_map = cm->prev_frame->seg_map;
  else
    cm->last_frame_seg_map = NULL;
  if (features->allow_intrabc || features->coded_lossless) {
    av1_set_default_ref_deltas(cm->lf.ref_deltas);
    av1_set_default_mode_deltas(cm->lf.mode_deltas);
  } else if (cm->prev_frame) {
    memcpy(cm->lf.ref_deltas, cm->prev_frame->ref_deltas, REF_FRAMES);
    memcpy(cm->lf.mode_deltas, cm->prev_frame->mode_deltas, MAX_MODE_LF_DELTAS);
  }
  memcpy(cm->cur_frame->ref_deltas, cm->lf.ref_deltas, REF_FRAMES);
  memcpy(cm->cur_frame->mode_deltas, cm->lf.mode_deltas, MAX_MODE_LF_DELTAS);

  cpi->all_one_sided_refs =
      frame_is_intra_only(cm) ? 0 : refs_are_one_sided(cm);

  cpi->prune_ref_frame_mask = 0;
  // Figure out which ref frames can be skipped at frame level.
  setup_prune_ref_frame_mask(cpi);

  x->txb_split_count = 0;
#if CONFIG_SPEED_STATS
  x->tx_search_count = 0;
#endif  // CONFIG_SPEED_STATS

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, av1_compute_global_motion_time);
#endif
  av1_zero(rdc->global_motion_used);
  av1_zero(gm_info->params_cost);
  if (cpi->common.current_frame.frame_type == INTER_FRAME && cpi->source &&
      cpi->oxcf.enable_global_motion && !gm_info->search_done) {
    YV12_BUFFER_CONFIG *ref_buf[REF_FRAMES];
    MotionModel params_by_motion[RANSAC_NUM_MOTIONS];
    for (int m = 0; m < RANSAC_NUM_MOTIONS; m++) {
      memset(&params_by_motion[m], 0, sizeof(params_by_motion[m]));
      params_by_motion[m].inliers =
          aom_malloc(sizeof(*(params_by_motion[m].inliers)) * 2 * MAX_CORNERS);
    }

    int num_frm_corners = -1;
    int frm_corners[2 * MAX_CORNERS];
    unsigned char *frm_buffer = cpi->source->y_buffer;
    if (cpi->source->flags & YV12_FLAG_HIGHBITDEPTH) {
      // The frame buffer is 16-bit, so we need to convert to 8 bits for the
      // following code. We cache the result until the frame is released.
      frm_buffer =
          av1_downconvert_frame(cpi->source, cpi->common.seq_params.bit_depth);
    }
    const int segment_map_w =
        (cpi->source->y_width + WARP_ERROR_BLOCK) >> WARP_ERROR_BLOCK_LOG;
    const int segment_map_h =
        (cpi->source->y_height + WARP_ERROR_BLOCK) >> WARP_ERROR_BLOCK_LOG;

    uint8_t *segment_map =
        aom_malloc(sizeof(*segment_map) * segment_map_w * segment_map_h);
    memset(segment_map, 0,
           sizeof(*segment_map) * segment_map_w * segment_map_h);

    FrameDistPair future_ref_frame[REF_FRAMES - 1] = {
      { -1, NONE_FRAME }, { -1, NONE_FRAME }, { -1, NONE_FRAME },
      { -1, NONE_FRAME }, { -1, NONE_FRAME }, { -1, NONE_FRAME },
      { -1, NONE_FRAME }
    };
    FrameDistPair past_ref_frame[REF_FRAMES - 1] = {
      { -1, NONE_FRAME }, { -1, NONE_FRAME }, { -1, NONE_FRAME },
      { -1, NONE_FRAME }, { -1, NONE_FRAME }, { -1, NONE_FRAME },
      { -1, NONE_FRAME }
    };
    int num_past_ref_frames = 0;
    int num_future_ref_frames = 0;
    // Populate ref_buf for valid ref frames in global motion
    update_valid_ref_frames_for_gm(cpi, ref_buf, past_ref_frame,
                                   future_ref_frame, &num_past_ref_frames,
                                   &num_future_ref_frames);

    // Sort the ref frames in the ascending order of their distance from the
    // current frame
    qsort(past_ref_frame, num_past_ref_frames, sizeof(past_ref_frame[0]),
          compare_distance);
    qsort(future_ref_frame, num_future_ref_frames, sizeof(future_ref_frame[0]),
          compare_distance);

    // Compute global motion w.r.t. past reference frames
    if (num_past_ref_frames > 0)
      compute_global_motion_for_references(
          cpi, ref_buf, past_ref_frame, num_past_ref_frames, &num_frm_corners,
          frm_corners, frm_buffer, params_by_motion, segment_map, segment_map_w,
          segment_map_h);

    // Compute global motion w.r.t. future reference frames
    if (num_future_ref_frames > 0)
      compute_global_motion_for_references(
          cpi, ref_buf, future_ref_frame, num_future_ref_frames,
          &num_frm_corners, frm_corners, frm_buffer, params_by_motion,
          segment_map, segment_map_w, segment_map_h);

    aom_free(segment_map);

    gm_info->search_done = 1;
    for (int m = 0; m < RANSAC_NUM_MOTIONS; m++) {
      aom_free(params_by_motion[m].inliers);
    }
  }
  memcpy(cm->cur_frame->global_motion, cm->global_motion,
         REF_FRAMES * sizeof(WarpedMotionParams));
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, av1_compute_global_motion_time);
#endif

#if CONFIG_COLLECT_COMPONENT_TIMING
  start_timing(cpi, av1_setup_motion_field_time);
#endif
  if (features->allow_ref_frame_mvs) av1_setup_motion_field(cm);
#if CONFIG_COLLECT_COMPONENT_TIMING
  end_timing(cpi, av1_setup_motion_field_time);
#endif

  cm->current_frame.skip_mode_info.skip_mode_flag =
      check_skip_mode_enabled(cpi);

  cpi->row_mt_sync_read_ptr = av1_row_mt_sync_read_dummy;
  cpi->row_mt_sync_write_ptr = av1_row_mt_sync_write_dummy;
  cpi->row_mt = 0;

  if (cpi->oxcf.row_mt && (cpi->oxcf.max_threads > 1)) {
    cpi->row_mt = 1;
    cpi->row_mt_sync_read_ptr = av1_row_mt_sync_read;
    cpi->row_mt_sync_write_ptr = av1_row_mt_sync_write;
    av1_encode_tiles_row_mt(cpi);
  } else {
    if (AOMMIN(cpi->oxcf.max_threads, cm->tiles.cols * cm->tiles.rows) > 1)
      av1_encode_tiles_mt(cpi);
    else
      encode_tiles(cpi);
  }

  // If intrabc is allowed but never selected, reset the allow_intrabc flag.
  if (features->allow_intrabc && !cpi->intrabc_used) {
    features->allow_intrabc = 0;
  }
  if (features->allow_intrabc) {
    cm->delta_q_info.delta_lf_present_flag = 0;
  }

  if (cm->delta_q_info.delta_q_present_flag && cpi->deltaq_used == 0) {
    cm->delta_q_info.delta_q_present_flag = 0;
  }

  // Set the transform size appropriately before bitstream creation
  const MODE_EVAL_TYPE eval_type =
      cpi->sf.winner_mode_sf.enable_winner_mode_for_tx_size_srch
          ? WINNER_MODE_EVAL
          : DEFAULT_EVAL;
  const TX_SIZE_SEARCH_METHOD tx_search_type =
      cpi->winner_mode_params.tx_size_search_methods[eval_type];
  assert(cpi->oxcf.enable_tx64 || tx_search_type != USE_LARGESTALL);
  features->tx_mode = select_tx_mode(cm, tx_search_type);

  if (cpi->sf.tx_sf.tx_type_search.prune_tx_type_using_stats) {
    const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);

    for (i = 0; i < TX_SIZES_ALL; i++) {
      int sum = 0;
      int j;
      int left = 1024;

      for (j = 0; j < TX_TYPES; j++)
        sum += cpi->td.rd_counts.tx_type_used[i][j];

      for (j = TX_TYPES - 1; j >= 0; j--) {
        const int new_prob =
            sum ? 1024 * cpi->td.rd_counts.tx_type_used[i][j] / sum
                : (j ? 0 : 1024);
        int prob =
            (frame_probs->tx_type_probs[update_type][i][j] + new_prob) >> 1;
        left -= prob;
        if (j == 0) prob += left;
        frame_probs->tx_type_probs[update_type][i][j] = prob;
      }
    }
  }

  if (!cpi->sf.inter_sf.disable_obmc &&
      cpi->sf.inter_sf.prune_obmc_prob_thresh > 0) {
    const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);

    for (i = 0; i < BLOCK_SIZES_ALL; i++) {
      int sum = 0;
      for (int j = 0; j < 2; j++) sum += cpi->td.rd_counts.obmc_used[i][j];

      const int new_prob =
          sum ? 128 * cpi->td.rd_counts.obmc_used[i][1] / sum : 0;
      frame_probs->obmc_probs[update_type][i] =
          (frame_probs->obmc_probs[update_type][i] + new_prob) >> 1;
    }
  }

  if (features->allow_warped_motion &&
      cpi->sf.inter_sf.prune_warped_prob_thresh > 0) {
    const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);
    int sum = 0;
    for (i = 0; i < 2; i++) sum += cpi->td.rd_counts.warped_used[i];
    const int new_prob = sum ? 128 * cpi->td.rd_counts.warped_used[1] / sum : 0;
    frame_probs->warped_probs[update_type] =
        (frame_probs->warped_probs[update_type] + new_prob) >> 1;
  }

  if (cm->current_frame.frame_type != KEY_FRAME &&
      cpi->sf.interp_sf.adaptive_interp_filter_search == 2 &&
      features->interp_filter == SWITCHABLE) {
    const FRAME_UPDATE_TYPE update_type = get_frame_update_type(&cpi->gf_group);

    for (i = 0; i < SWITCHABLE_FILTER_CONTEXTS; i++) {
      int sum = 0;
      int j;
      int left = 1536;

      for (j = 0; j < SWITCHABLE_FILTERS; j++) {
        sum += cpi->td.counts->switchable_interp[i][j];
      }

      for (j = SWITCHABLE_FILTERS - 1; j >= 0; j--) {
        const int new_prob =
            sum ? 1536 * cpi->td.counts->switchable_interp[i][j] / sum
                : (j ? 0 : 1536);
        int prob = (frame_probs->switchable_interp_probs[update_type][i][j] +
                    new_prob) >>
                   1;
        left -= prob;
        if (j == 0) prob += left;
        frame_probs->switchable_interp_probs[update_type][i][j] = prob;
      }
    }
  }

  if ((!is_stat_generation_stage(cpi) && av1_use_hash_me(cpi) &&
       !cpi->sf.rt_sf.use_nonrd_pick_mode) ||
      hash_table_created) {
    av1_hash_table_destroy(&intrabc_hash_info->intrabc_hash_table);
  }
}

void av1_encode_frame(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  CurrentFrame *const current_frame = &cm->current_frame;
  FeatureFlags *const features = &cm->features;
  const int num_planes = av1_num_planes(cm);
  // Indicates whether or not to use a default reduced set for ext-tx
  // rather than the potential full set of 16 transforms
  features->reduced_tx_set_used = cpi->oxcf.reduced_tx_type_set;

  // Make sure segment_id is no larger than last_active_segid.
  if (cm->seg.enabled && cm->seg.update_map) {
    const int mi_rows = cm->mi_params.mi_rows;
    const int mi_cols = cm->mi_params.mi_cols;
    const int last_active_segid = cm->seg.last_active_segid;
    uint8_t *map = cpi->enc_seg.map;
    for (int mi_row = 0; mi_row < mi_rows; ++mi_row) {
      for (int mi_col = 0; mi_col < mi_cols; ++mi_col) {
        map[mi_col] = AOMMIN(map[mi_col], last_active_segid);
      }
      map += mi_cols;
    }
  }

  av1_setup_frame_buf_refs(cm);
  enforce_max_ref_frames(cpi, &cpi->ref_frame_flags);
  set_rel_frame_dist(cpi);
  av1_setup_frame_sign_bias(cm);

#if CHECK_PRECOMPUTED_REF_FRAME_MAP
  GF_GROUP *gf_group = &cpi->gf_group;
  // TODO(yuec): The check is disabled on OVERLAY frames for now, because info
  // in cpi->gf_group has been refreshed for the next GOP when the check is
  // performed for OVERLAY frames. Since we have not support inter-GOP ref
  // frame map computation, the precomputed ref map for an OVERLAY frame is all
  // -1 at this point (although it is meaning before gf_group is refreshed).
  if (!frame_is_intra_only(cm) && gf_group->index != 0) {
    const RefCntBuffer *const golden_buf = get_ref_frame_buf(cm, GOLDEN_FRAME);

    if (golden_buf) {
      const int golden_order_hint = golden_buf->order_hint;

      for (int ref = LAST_FRAME; ref < EXTREF_FRAME; ++ref) {
        const RefCntBuffer *const buf = get_ref_frame_buf(cm, ref);
        const int ref_disp_idx_precomputed =
            gf_group->ref_frame_disp_idx[gf_group->index][ref - LAST_FRAME];

        (void)ref_disp_idx_precomputed;

        if (buf != NULL) {
          const int ref_disp_idx =
              get_relative_dist(&cm->seq_params.order_hint_info,
                                buf->order_hint, golden_order_hint);

          if (ref_disp_idx >= 0)
            assert(ref_disp_idx == ref_disp_idx_precomputed);
          else
            assert(ref_disp_idx_precomputed == -1);
        } else {
          assert(ref_disp_idx_precomputed == -1);
        }
      }
    }
  }
#endif

#if CONFIG_MISMATCH_DEBUG
  mismatch_reset_frame(num_planes);
#else
  (void)num_planes;
#endif

  if (cpi->sf.hl_sf.frame_parameter_update) {
    RD_COUNTS *const rdc = &cpi->td.rd_counts;

    if (frame_is_intra_only(cm))
      current_frame->reference_mode = SINGLE_REFERENCE;
    else
      current_frame->reference_mode = REFERENCE_MODE_SELECT;

    features->interp_filter = SWITCHABLE;
    if (cm->tiles.large_scale) features->interp_filter = EIGHTTAP_REGULAR;

    features->switchable_motion_mode = 1;

    rdc->compound_ref_used_flag = 0;
    rdc->skip_mode_used_flag = 0;

    encode_frame_internal(cpi);

    if (current_frame->reference_mode == REFERENCE_MODE_SELECT) {
      // Use a flag that includes 4x4 blocks
      if (rdc->compound_ref_used_flag == 0) {
        current_frame->reference_mode = SINGLE_REFERENCE;
#if CONFIG_ENTROPY_STATS
        av1_zero(cpi->td.counts->comp_inter);
#endif  // CONFIG_ENTROPY_STATS
      }
    }
    // Re-check on the skip mode status as reference mode may have been
    // changed.
    SkipModeInfo *const skip_mode_info = &current_frame->skip_mode_info;
    if (frame_is_intra_only(cm) ||
        current_frame->reference_mode == SINGLE_REFERENCE) {
      skip_mode_info->skip_mode_allowed = 0;
      skip_mode_info->skip_mode_flag = 0;
    }
    if (skip_mode_info->skip_mode_flag && rdc->skip_mode_used_flag == 0)
      skip_mode_info->skip_mode_flag = 0;

    if (!cm->tiles.large_scale) {
      if (features->tx_mode == TX_MODE_SELECT &&
          cpi->td.mb.txb_split_count == 0)
        features->tx_mode = TX_MODE_LARGEST;
    }
  } else {
    encode_frame_internal(cpi);
  }
}

static AOM_INLINE void update_txfm_count(MACROBLOCK *x, MACROBLOCKD *xd,
                                         FRAME_COUNTS *counts, TX_SIZE tx_size,
                                         int depth, int blk_row, int blk_col,
                                         uint8_t allow_update_cdf) {
  MB_MODE_INFO *mbmi = xd->mi[0];
  const BLOCK_SIZE bsize = mbmi->sb_type;
  const int max_blocks_high = max_block_high(xd, bsize, 0);
  const int max_blocks_wide = max_block_wide(xd, bsize, 0);
  int ctx = txfm_partition_context(xd->above_txfm_context + blk_col,
                                   xd->left_txfm_context + blk_row,
                                   mbmi->sb_type, tx_size);
  const int txb_size_index = av1_get_txb_size_index(bsize, blk_row, blk_col);
  const TX_SIZE plane_tx_size = mbmi->inter_tx_size[txb_size_index];

  if (blk_row >= max_blocks_high || blk_col >= max_blocks_wide) return;
  assert(tx_size > TX_4X4);

  if (depth == MAX_VARTX_DEPTH) {
    // Don't add to counts in this case
    mbmi->tx_size = tx_size;
    txfm_partition_update(xd->above_txfm_context + blk_col,
                          xd->left_txfm_context + blk_row, tx_size, tx_size);
    return;
  }

  if (tx_size == plane_tx_size) {
#if CONFIG_ENTROPY_STATS
    ++counts->txfm_partition[ctx][0];
#endif
    if (allow_update_cdf)
      update_cdf(xd->tile_ctx->txfm_partition_cdf[ctx], 0, 2);
    mbmi->tx_size = tx_size;
    txfm_partition_update(xd->above_txfm_context + blk_col,
                          xd->left_txfm_context + blk_row, tx_size, tx_size);
  } else {
    const TX_SIZE sub_txs = sub_tx_size_map[tx_size];
    const int bsw = tx_size_wide_unit[sub_txs];
    const int bsh = tx_size_high_unit[sub_txs];

#if CONFIG_ENTROPY_STATS
    ++counts->txfm_partition[ctx][1];
#endif
    if (allow_update_cdf)
      update_cdf(xd->tile_ctx->txfm_partition_cdf[ctx], 1, 2);
    ++x->txb_split_count;

    if (sub_txs == TX_4X4) {
      mbmi->inter_tx_size[txb_size_index] = TX_4X4;
      mbmi->tx_size = TX_4X4;
      txfm_partition_update(xd->above_txfm_context + blk_col,
                            xd->left_txfm_context + blk_row, TX_4X4, tx_size);
      return;
    }

    for (int row = 0; row < tx_size_high_unit[tx_size]; row += bsh) {
      for (int col = 0; col < tx_size_wide_unit[tx_size]; col += bsw) {
        int offsetr = row;
        int offsetc = col;

        update_txfm_count(x, xd, counts, sub_txs, depth + 1, blk_row + offsetr,
                          blk_col + offsetc, allow_update_cdf);
      }
    }
  }
}

static AOM_INLINE void tx_partition_count_update(const AV1_COMMON *const cm,
                                                 MACROBLOCK *x,
                                                 BLOCK_SIZE plane_bsize,
                                                 FRAME_COUNTS *td_counts,
                                                 uint8_t allow_update_cdf) {
  MACROBLOCKD *xd = &x->e_mbd;
  const int mi_width = mi_size_wide[plane_bsize];
  const int mi_height = mi_size_high[plane_bsize];
  const TX_SIZE max_tx_size = get_vartx_max_txsize(xd, plane_bsize, 0);
  const int bh = tx_size_high_unit[max_tx_size];
  const int bw = tx_size_wide_unit[max_tx_size];

  xd->above_txfm_context =
      cm->above_contexts.txfm[xd->tile.tile_row] + xd->mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (xd->mi_row & MAX_MIB_MASK);

  for (int idy = 0; idy < mi_height; idy += bh) {
    for (int idx = 0; idx < mi_width; idx += bw) {
      update_txfm_count(x, xd, td_counts, max_tx_size, 0, idy, idx,
                        allow_update_cdf);
    }
  }
}

static AOM_INLINE void set_txfm_context(MACROBLOCKD *xd, TX_SIZE tx_size,
                                        int blk_row, int blk_col) {
  MB_MODE_INFO *mbmi = xd->mi[0];
  const BLOCK_SIZE bsize = mbmi->sb_type;
  const int max_blocks_high = max_block_high(xd, bsize, 0);
  const int max_blocks_wide = max_block_wide(xd, bsize, 0);
  const int txb_size_index = av1_get_txb_size_index(bsize, blk_row, blk_col);
  const TX_SIZE plane_tx_size = mbmi->inter_tx_size[txb_size_index];

  if (blk_row >= max_blocks_high || blk_col >= max_blocks_wide) return;

  if (tx_size == plane_tx_size) {
    mbmi->tx_size = tx_size;
    txfm_partition_update(xd->above_txfm_context + blk_col,
                          xd->left_txfm_context + blk_row, tx_size, tx_size);

  } else {
    if (tx_size == TX_8X8) {
      mbmi->inter_tx_size[txb_size_index] = TX_4X4;
      mbmi->tx_size = TX_4X4;
      txfm_partition_update(xd->above_txfm_context + blk_col,
                            xd->left_txfm_context + blk_row, TX_4X4, tx_size);
      return;
    }
    const TX_SIZE sub_txs = sub_tx_size_map[tx_size];
    const int bsw = tx_size_wide_unit[sub_txs];
    const int bsh = tx_size_high_unit[sub_txs];
    for (int row = 0; row < tx_size_high_unit[tx_size]; row += bsh) {
      for (int col = 0; col < tx_size_wide_unit[tx_size]; col += bsw) {
        const int offsetr = blk_row + row;
        const int offsetc = blk_col + col;
        if (offsetr >= max_blocks_high || offsetc >= max_blocks_wide) continue;
        set_txfm_context(xd, sub_txs, offsetr, offsetc);
      }
    }
  }
}

static AOM_INLINE void tx_partition_set_contexts(const AV1_COMMON *const cm,
                                                 MACROBLOCKD *xd,
                                                 BLOCK_SIZE plane_bsize) {
  const int mi_width = mi_size_wide[plane_bsize];
  const int mi_height = mi_size_high[plane_bsize];
  const TX_SIZE max_tx_size = get_vartx_max_txsize(xd, plane_bsize, 0);
  const int bh = tx_size_high_unit[max_tx_size];
  const int bw = tx_size_wide_unit[max_tx_size];

  xd->above_txfm_context =
      cm->above_contexts.txfm[xd->tile.tile_row] + xd->mi_col;
  xd->left_txfm_context =
      xd->left_txfm_context_buffer + (xd->mi_row & MAX_MIB_MASK);

  for (int idy = 0; idy < mi_height; idy += bh) {
    for (int idx = 0; idx < mi_width; idx += bw) {
      set_txfm_context(xd, max_tx_size, idy, idx);
    }
  }
}

static AOM_INLINE void encode_superblock(const AV1_COMP *const cpi,
                                         TileDataEnc *tile_data, ThreadData *td,
                                         TOKENEXTRA **t, RUN_TYPE dry_run,
                                         BLOCK_SIZE bsize, int *rate) {
  const AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCK *const x = &td->mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO **mi_4x4 = xd->mi;
  MB_MODE_INFO *mbmi = mi_4x4[0];
  const int seg_skip =
      segfeature_active(&cm->seg, mbmi->segment_id, SEG_LVL_SKIP);
  const int mis = cm->mi_params.mi_stride;
  const int mi_width = mi_size_wide[bsize];
  const int mi_height = mi_size_high[bsize];
  const int is_inter = is_inter_block(mbmi);

  // Initialize tx_mode and tx_size_search_method
  set_tx_size_search_method(
      cm, &cpi->winner_mode_params, x,
      cpi->sf.winner_mode_sf.enable_winner_mode_for_tx_size_srch, 1);

  const int mi_row = xd->mi_row;
  const int mi_col = xd->mi_col;
  if (!is_inter) {
    xd->cfl.store_y = store_cfl_required(cm, xd);
    mbmi->skip = 1;
    for (int plane = 0; plane < num_planes; ++plane) {
      av1_encode_intra_block_plane(cpi, x, bsize, plane, dry_run,
                                   cpi->optimize_seg_arr[mbmi->segment_id]);
    }

    // If there is at least one lossless segment, force the skip for intra
    // block to be 0, in order to avoid the segment_id to be changed by in
    // write_segment_id().
    if (!cpi->common.seg.segid_preskip && cpi->common.seg.update_map &&
        cpi->enc_seg.has_lossless_segment)
      mbmi->skip = 0;

    xd->cfl.store_y = 0;
    if (av1_allow_palette(cm->features.allow_screen_content_tools, bsize)) {
      for (int plane = 0; plane < AOMMIN(2, num_planes); ++plane) {
        if (mbmi->palette_mode_info.palette_size[plane] > 0) {
          if (!dry_run) {
            av1_tokenize_color_map(x, plane, t, bsize, mbmi->tx_size,
                                   PALETTE_MAP, tile_data->allow_update_cdf,
                                   td->counts);
          } else if (dry_run == DRY_RUN_COSTCOEFFS) {
            rate +=
                av1_cost_color_map(x, plane, bsize, mbmi->tx_size, PALETTE_MAP);
          }
        }
      }
    }

    av1_update_txb_context(cpi, td, dry_run, bsize,
                           tile_data->allow_update_cdf);
  } else {
    int ref;
    const int is_compound = has_second_ref(mbmi);

    set_ref_ptrs(cm, xd, mbmi->ref_frame[0], mbmi->ref_frame[1]);
    for (ref = 0; ref < 1 + is_compound; ++ref) {
      const YV12_BUFFER_CONFIG *cfg =
          get_ref_frame_yv12_buf(cm, mbmi->ref_frame[ref]);
      assert(IMPLIES(!is_intrabc_block(mbmi), cfg));
      av1_setup_pre_planes(xd, ref, cfg, mi_row, mi_col,
                           xd->block_ref_scale_factors[ref], num_planes);
    }
    int start_plane = (cpi->sf.rt_sf.reuse_inter_pred_nonrd) ? 1 : 0;
    av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, NULL, bsize,
                                  start_plane, av1_num_planes(cm) - 1);
    if (mbmi->motion_mode == OBMC_CAUSAL) {
      assert(cpi->oxcf.enable_obmc == 1);
      av1_build_obmc_inter_predictors_sb(cm, xd);
    }

#if CONFIG_MISMATCH_DEBUG
    if (dry_run == OUTPUT_ENABLED) {
      for (int plane = 0; plane < num_planes; ++plane) {
        const struct macroblockd_plane *pd = &xd->plane[plane];
        int pixel_c, pixel_r;
        mi_to_pixel_loc(&pixel_c, &pixel_r, mi_col, mi_row, 0, 0,
                        pd->subsampling_x, pd->subsampling_y);
        if (!is_chroma_reference(mi_row, mi_col, bsize, pd->subsampling_x,
                                 pd->subsampling_y))
          continue;
        mismatch_record_block_pre(pd->dst.buf, pd->dst.stride,
                                  cm->current_frame.order_hint, plane, pixel_c,
                                  pixel_r, pd->width, pd->height,
                                  xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH);
      }
    }
#else
    (void)num_planes;
#endif

    av1_encode_sb(cpi, x, bsize, dry_run);
    av1_tokenize_sb_vartx(cpi, td, dry_run, bsize, rate,
                          tile_data->allow_update_cdf);
  }

  if (!dry_run) {
    if (av1_allow_intrabc(cm) && is_intrabc_block(mbmi)) td->intrabc_used = 1;
    if (x->tx_mode_search_type == TX_MODE_SELECT &&
        !xd->lossless[mbmi->segment_id] && mbmi->sb_type > BLOCK_4X4 &&
        !(is_inter && (mbmi->skip || seg_skip))) {
      if (is_inter) {
        tx_partition_count_update(cm, x, bsize, td->counts,
                                  tile_data->allow_update_cdf);
      } else {
        if (mbmi->tx_size != max_txsize_rect_lookup[bsize])
          ++x->txb_split_count;
        if (block_signals_txsize(bsize)) {
          const int tx_size_ctx = get_tx_size_context(xd);
          const int32_t tx_size_cat = bsize_to_tx_size_cat(bsize);
          const int depth = tx_size_to_depth(mbmi->tx_size, bsize);
          const int max_depths = bsize_to_max_depth(bsize);

          if (tile_data->allow_update_cdf)
            update_cdf(xd->tile_ctx->tx_size_cdf[tx_size_cat][tx_size_ctx],
                       depth, max_depths + 1);
#if CONFIG_ENTROPY_STATS
          ++td->counts->intra_tx_size[tx_size_cat][tx_size_ctx][depth];
#endif
        }
      }
      assert(IMPLIES(is_rect_tx(mbmi->tx_size), is_rect_tx_allowed(xd, mbmi)));
    } else {
      int i, j;
      TX_SIZE intra_tx_size;
      // The new intra coding scheme requires no change of transform size
      if (is_inter) {
        if (xd->lossless[mbmi->segment_id]) {
          intra_tx_size = TX_4X4;
        } else {
          intra_tx_size = tx_size_from_tx_mode(bsize, x->tx_mode_search_type);
        }
      } else {
        intra_tx_size = mbmi->tx_size;
      }

      for (j = 0; j < mi_height; j++)
        for (i = 0; i < mi_width; i++)
          if (mi_col + i < cm->mi_params.mi_cols &&
              mi_row + j < cm->mi_params.mi_rows)
            mi_4x4[mis * j + i]->tx_size = intra_tx_size;

      if (intra_tx_size != max_txsize_rect_lookup[bsize]) ++x->txb_split_count;
    }
  }

  if (x->tx_mode_search_type == TX_MODE_SELECT &&
      block_signals_txsize(mbmi->sb_type) && is_inter &&
      !(mbmi->skip || seg_skip) && !xd->lossless[mbmi->segment_id]) {
    if (dry_run) tx_partition_set_contexts(cm, xd, bsize);
  } else {
    TX_SIZE tx_size = mbmi->tx_size;
    // The new intra coding scheme requires no change of transform size
    if (is_inter) {
      if (xd->lossless[mbmi->segment_id]) {
        tx_size = TX_4X4;
      } else {
        tx_size = tx_size_from_tx_mode(bsize, x->tx_mode_search_type);
      }
    } else {
      tx_size = (bsize > BLOCK_4X4) ? tx_size : TX_4X4;
    }
    mbmi->tx_size = tx_size;
    set_txfm_ctxs(tx_size, xd->width, xd->height,
                  (mbmi->skip || seg_skip) && is_inter_block(mbmi), xd);
  }

  if (is_inter_block(mbmi) && !xd->is_chroma_ref && is_cfl_allowed(xd)) {
    cfl_store_block(xd, mbmi->sb_type, mbmi->tx_size);
  }
}
