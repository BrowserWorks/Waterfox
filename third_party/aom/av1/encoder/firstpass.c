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
#include <math.h>
#include <stdio.h>

#include "config/aom_dsp_rtcd.h"
#include "config/aom_scale_rtcd.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_dsp/variance.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/mem.h"
#include "aom_ports/system_state.h"
#include "aom_scale/aom_scale.h"
#include "aom_scale/yv12config.h"

#include "av1/common/entropymv.h"
#include "av1/common/quant_common.h"
#include "av1/common/reconinter.h"  // av1_setup_dst_planes()
#include "av1/common/txb_common.h"
#include "av1/encoder/aq_variance.h"
#include "av1/encoder/av1_quantize.h"
#include "av1/encoder/block.h"
#include "av1/encoder/dwt.h"
#include "av1/encoder/encodeframe.h"
#include "av1/encoder/encodemb.h"
#include "av1/encoder/encodemv.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/encode_strategy.h"
#include "av1/encoder/extend.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/mcomp.h"
#include "av1/encoder/rd.h"
#include "av1/encoder/reconinter_enc.h"

#define OUTPUT_FPF 0

#define FIRST_PASS_Q 10.0
#define INTRA_MODE_PENALTY 1024
#define NEW_MV_MODE_PENALTY 32
#define DARK_THRESH 64

#define NCOUNT_INTRA_THRESH 8192
#define NCOUNT_INTRA_FACTOR 3

static AOM_INLINE void output_stats(FIRSTPASS_STATS *stats,
                                    struct aom_codec_pkt_list *pktlist) {
  struct aom_codec_cx_pkt pkt;
  pkt.kind = AOM_CODEC_STATS_PKT;
  pkt.data.twopass_stats.buf = stats;
  pkt.data.twopass_stats.sz = sizeof(FIRSTPASS_STATS);
  if (pktlist != NULL) aom_codec_pkt_list_add(pktlist, &pkt);

// TEMP debug code
#if OUTPUT_FPF
  {
    FILE *fpfile;
    fpfile = fopen("firstpass.stt", "a");

    fprintf(fpfile,
            "%12.0lf %12.4lf %12.0lf %12.0lf %12.0lf %12.4lf %12.4lf"
            "%12.4lf %12.4lf %12.4lf %12.4lf %12.4lf %12.4lf %12.4lf %12.4lf"
            "%12.4lf %12.4lf %12.0lf %12.0lf %12.0lf %12.4lf %12.4lf\n",
            stats->frame, stats->weight, stats->intra_error, stats->coded_error,
            stats->sr_coded_error, stats->pcnt_inter, stats->pcnt_motion,
            stats->pcnt_second_ref, stats->pcnt_neutral, stats->intra_skip_pct,
            stats->inactive_zone_rows, stats->inactive_zone_cols, stats->MVr,
            stats->mvr_abs, stats->MVc, stats->mvc_abs, stats->MVrv,
            stats->MVcv, stats->mv_in_out_count, stats->new_mv_count,
            stats->count, stats->duration);
    fclose(fpfile);
  }
#endif
}

void av1_twopass_zero_stats(FIRSTPASS_STATS *section) {
  section->frame = 0.0;
  section->weight = 0.0;
  section->intra_error = 0.0;
  section->frame_avg_wavelet_energy = 0.0;
  section->coded_error = 0.0;
  section->sr_coded_error = 0.0;
  section->pcnt_inter = 0.0;
  section->pcnt_motion = 0.0;
  section->pcnt_second_ref = 0.0;
  section->pcnt_neutral = 0.0;
  section->intra_skip_pct = 0.0;
  section->inactive_zone_rows = 0.0;
  section->inactive_zone_cols = 0.0;
  section->MVr = 0.0;
  section->mvr_abs = 0.0;
  section->MVc = 0.0;
  section->mvc_abs = 0.0;
  section->MVrv = 0.0;
  section->MVcv = 0.0;
  section->mv_in_out_count = 0.0;
  section->new_mv_count = 0.0;
  section->count = 0.0;
  section->duration = 1.0;
}

static AOM_INLINE void accumulate_stats(FIRSTPASS_STATS *section,
                                        const FIRSTPASS_STATS *frame) {
  section->frame += frame->frame;
  section->weight += frame->weight;
  section->intra_error += frame->intra_error;
  section->frame_avg_wavelet_energy += frame->frame_avg_wavelet_energy;
  section->coded_error += frame->coded_error;
  section->sr_coded_error += frame->sr_coded_error;
  section->pcnt_inter += frame->pcnt_inter;
  section->pcnt_motion += frame->pcnt_motion;
  section->pcnt_second_ref += frame->pcnt_second_ref;
  section->pcnt_neutral += frame->pcnt_neutral;
  section->intra_skip_pct += frame->intra_skip_pct;
  section->inactive_zone_rows += frame->inactive_zone_rows;
  section->inactive_zone_cols += frame->inactive_zone_cols;
  section->MVr += frame->MVr;
  section->mvr_abs += frame->mvr_abs;
  section->MVc += frame->MVc;
  section->mvc_abs += frame->mvc_abs;
  section->MVrv += frame->MVrv;
  section->MVcv += frame->MVcv;
  section->mv_in_out_count += frame->mv_in_out_count;
  section->new_mv_count += frame->new_mv_count;
  section->count += frame->count;
  section->duration += frame->duration;
}

void av1_end_first_pass(AV1_COMP *cpi) {
  if (cpi->twopass.stats_buf_ctx->total_stats)
    output_stats(cpi->twopass.stats_buf_ctx->total_stats, cpi->output_pkt_list);
}

static aom_variance_fn_t get_block_variance_fn(BLOCK_SIZE bsize) {
  switch (bsize) {
    case BLOCK_8X8: return aom_mse8x8;
    case BLOCK_16X8: return aom_mse16x8;
    case BLOCK_8X16: return aom_mse8x16;
    default: return aom_mse16x16;
  }
}

static unsigned int get_prediction_error(BLOCK_SIZE bsize,
                                         const struct buf_2d *src,
                                         const struct buf_2d *ref) {
  unsigned int sse;
  const aom_variance_fn_t fn = get_block_variance_fn(bsize);
  fn(src->buf, src->stride, ref->buf, ref->stride, &sse);
  return sse;
}

#if CONFIG_AV1_HIGHBITDEPTH
static aom_variance_fn_t highbd_get_block_variance_fn(BLOCK_SIZE bsize,
                                                      int bd) {
  switch (bd) {
    default:
      switch (bsize) {
        case BLOCK_8X8: return aom_highbd_8_mse8x8;
        case BLOCK_16X8: return aom_highbd_8_mse16x8;
        case BLOCK_8X16: return aom_highbd_8_mse8x16;
        default: return aom_highbd_8_mse16x16;
      }
      break;
    case 10:
      switch (bsize) {
        case BLOCK_8X8: return aom_highbd_10_mse8x8;
        case BLOCK_16X8: return aom_highbd_10_mse16x8;
        case BLOCK_8X16: return aom_highbd_10_mse8x16;
        default: return aom_highbd_10_mse16x16;
      }
      break;
    case 12:
      switch (bsize) {
        case BLOCK_8X8: return aom_highbd_12_mse8x8;
        case BLOCK_16X8: return aom_highbd_12_mse16x8;
        case BLOCK_8X16: return aom_highbd_12_mse8x16;
        default: return aom_highbd_12_mse16x16;
      }
      break;
  }
}

static unsigned int highbd_get_prediction_error(BLOCK_SIZE bsize,
                                                const struct buf_2d *src,
                                                const struct buf_2d *ref,
                                                int bd) {
  unsigned int sse;
  const aom_variance_fn_t fn = highbd_get_block_variance_fn(bsize, bd);
  fn(src->buf, src->stride, ref->buf, ref->stride, &sse);
  return sse;
}
#endif  // CONFIG_AV1_HIGHBITDEPTH

// Refine the motion search range according to the frame dimension
// for first pass test.
static int get_search_range(const AV1_COMP *cpi) {
  int sr = 0;
  const int dim = AOMMIN(cpi->initial_width, cpi->initial_height);

  while ((dim << sr) < MAX_FULL_PEL_VAL) ++sr;
  return sr;
}

static AOM_INLINE void first_pass_motion_search(AV1_COMP *cpi, MACROBLOCK *x,
                                                const MV *ref_mv,
                                                FULLPEL_MV *best_mv,
                                                int *best_motion_err) {
  MACROBLOCKD *const xd = &x->e_mbd;
  FULLPEL_MV start_mv = get_fullmv_from_mv(ref_mv);
  int tmp_err;
  const BLOCK_SIZE bsize = xd->mi[0]->sb_type;
  aom_variance_fn_ptr_t v_fn_ptr = cpi->fn_ptr[bsize];
  const int new_mv_mode_penalty = NEW_MV_MODE_PENALTY;
  const int sr = get_search_range(cpi);
  const int step_param = 3 + sr;

  const search_site_config *first_pass_search_sites =
      &cpi->mv_search_params.ss_cfg[SS_CFG_FPF];
  FULLPEL_MOTION_SEARCH_PARAMS ms_params;
  av1_make_default_fullpel_ms_params(&ms_params, cpi, x, bsize, ref_mv,
                                     first_pass_search_sites);
  ms_params.search_method = NSTEP;

  FULLPEL_MV this_best_mv;
  tmp_err = av1_full_pixel_search(start_mv, &ms_params, step_param, NULL,
                                  &this_best_mv, NULL);

  if (tmp_err < INT_MAX) {
    tmp_err = av1_get_mvpred_sse(x, &this_best_mv, ref_mv, &v_fn_ptr) +
              new_mv_mode_penalty;
  }

  if (tmp_err < *best_motion_err) {
    *best_motion_err = tmp_err;
    *best_mv = this_best_mv;
  }
}

static BLOCK_SIZE get_bsize(const CommonModeInfoParams *const mi_params,
                            int mb_row, int mb_col) {
  if (mi_size_wide[BLOCK_16X16] * mb_col + mi_size_wide[BLOCK_8X8] <
      mi_params->mi_cols) {
    return mi_size_wide[BLOCK_16X16] * mb_row + mi_size_wide[BLOCK_8X8] <
                   mi_params->mi_rows
               ? BLOCK_16X16
               : BLOCK_16X8;
  } else {
    return mi_size_wide[BLOCK_16X16] * mb_row + mi_size_wide[BLOCK_8X8] <
                   mi_params->mi_rows
               ? BLOCK_8X16
               : BLOCK_8X8;
  }
}

static int find_fp_qindex(aom_bit_depth_t bit_depth) {
  return av1_find_qindex(FIRST_PASS_Q, bit_depth, 0, QINDEX_RANGE - 1);
}

static double raw_motion_error_stdev(int *raw_motion_err_list,
                                     int raw_motion_err_counts) {
  int64_t sum_raw_err = 0;
  double raw_err_avg = 0;
  double raw_err_stdev = 0;
  if (raw_motion_err_counts == 0) return 0;

  int i;
  for (i = 0; i < raw_motion_err_counts; i++) {
    sum_raw_err += raw_motion_err_list[i];
  }
  raw_err_avg = (double)sum_raw_err / raw_motion_err_counts;
  for (i = 0; i < raw_motion_err_counts; i++) {
    raw_err_stdev += (raw_motion_err_list[i] - raw_err_avg) *
                     (raw_motion_err_list[i] - raw_err_avg);
  }
  // Calculate the standard deviation for the motion error of all the inter
  // blocks of the 0,0 motion using the last source
  // frame as the reference.
  raw_err_stdev = sqrt(raw_err_stdev / raw_motion_err_counts);
  return raw_err_stdev;
}

// This structure contains several key parameters to be accumulate for this
// frame.
typedef struct {
  // Intra prediction error.
  int64_t intra_error;
  // Average wavelet energy computed using Discrete Wavelet Transform (DWT).
  int64_t frame_avg_wavelet_energy;
  // Best of intra pred error and inter pred error using last frame as ref.
  int64_t coded_error;
  // Best of intra pred error and inter pred error using golden frame as ref.
  int64_t sr_coded_error;
  // Best of intra pred error and inter pred error using altref frame as ref.
  int64_t tr_coded_error;
  // Count of motion vector.
  int mv_count;
  // Count of blocks that pick inter prediction (inter pred error is smaller
  // than intra pred error).
  int inter_count;
  // Count of blocks that pick second ref (golden frame).
  int second_ref_count;
  // Count of blocks that pick third ref (altref frame).
  int third_ref_count;
  // Count of blocks where the inter and intra are very close and very low.
  double neutral_count;
  // Count of blocks where intra error is very small.
  int intra_skip_count;
  // Start row.
  int image_data_start_row;
  // Count of unique non-zero motion vectors.
  int new_mv_count;
  // Sum of inward motion vectors.
  int sum_in_vectors;
  // Sum of motion vector row.
  int sum_mvr;
  // Sum of motion vector column.
  int sum_mvc;
  // Sum of absolute value of motion vector row.
  int sum_mvr_abs;
  // Sum of absolute value of motion vector column.
  int sum_mvc_abs;
  // Sum of the square of motion vector row.
  int64_t sum_mvrs;
  // Sum of the square of motion vector column.
  int64_t sum_mvcs;
  // A factor calculated using intra pred error.
  double intra_factor;
  // A factor that measures brightness.
  double brightness_factor;
} FRAME_STATS;

#define UL_INTRA_THRESH 50
#define INVALID_ROW -1
// Computes and returns the intra pred error of a block.
// intra pred error: sum of squared error of the intra predicted residual.
// Inputs:
//   cpi: the encoder setting. Only a few params in it will be used.
//   this_frame: the current frame buffer.
//   tile: tile information (not used in first pass, already init to zero)
//   mb_row: row index in the unit of first pass block size.
//   mb_col: column index in the unit of first pass block size.
//   y_offset: the offset of y frame buffer, indicating the starting point of
//             the current block.
//   uv_offset: the offset of u and v frame buffer, indicating the starting
//              point of the current block.
//   fp_block_size: first pass block size.
//   qindex: quantization step size to encode the frame.
//   stats: frame encoding stats.
// Modifies:
//   stats->intra_skip_count
//   stats->image_data_start_row
//   stats->intra_factor
//   stats->brightness_factor
//   stats->intra_error
//   stats->frame_avg_wavelet_energy
// Returns:
//   this_intra_error.
static int firstpass_intra_prediction(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG *const this_frame,
    const TileInfo *const tile, const int mb_row, const int mb_col,
    const int y_offset, const int uv_offset, const BLOCK_SIZE fp_block_size,
    const int qindex, FRAME_STATS *const stats) {
  const AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const SequenceHeader *const seq_params = &cm->seq_params;
  MACROBLOCK *const x = &cpi->td.mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const int mb_scale = mi_size_wide[fp_block_size];
  const int use_dc_pred = (mb_col || mb_row) && (!mb_col || !mb_row);
  const int num_planes = av1_num_planes(cm);
  const BLOCK_SIZE bsize = get_bsize(mi_params, mb_row, mb_col);

  aom_clear_system_state();
  set_mi_offsets(mi_params, xd, mb_row * mb_scale, mb_col * mb_scale);
  xd->plane[0].dst.buf = this_frame->y_buffer + y_offset;
  xd->plane[1].dst.buf = this_frame->u_buffer + uv_offset;
  xd->plane[2].dst.buf = this_frame->v_buffer + uv_offset;
  xd->left_available = (mb_col != 0);
  xd->mi[0]->sb_type = bsize;
  xd->mi[0]->ref_frame[0] = INTRA_FRAME;
  set_mi_row_col(xd, tile, mb_row * mb_scale, mi_size_high[bsize],
                 mb_col * mb_scale, mi_size_wide[bsize], mi_params->mi_rows,
                 mi_params->mi_cols);
  set_plane_n4(xd, mi_size_wide[bsize], mi_size_high[bsize], num_planes);
  xd->mi[0]->segment_id = 0;
  xd->lossless[xd->mi[0]->segment_id] = (qindex == 0);
  xd->mi[0]->mode = DC_PRED;
  xd->mi[0]->tx_size =
      use_dc_pred ? (bsize >= fp_block_size ? TX_16X16 : TX_8X8) : TX_4X4;

  av1_encode_intra_block_plane(cpi, x, bsize, 0, DRY_RUN_NORMAL, 0);
  int this_intra_error = aom_get_mb_ss(x->plane[0].src_diff);

  if (this_intra_error < UL_INTRA_THRESH) {
    ++stats->intra_skip_count;
  } else if ((mb_col > 0) && (stats->image_data_start_row == INVALID_ROW)) {
    stats->image_data_start_row = mb_row;
  }

  if (seq_params->use_highbitdepth) {
    switch (seq_params->bit_depth) {
      case AOM_BITS_8: break;
      case AOM_BITS_10: this_intra_error >>= 4; break;
      case AOM_BITS_12: this_intra_error >>= 8; break;
      default:
        assert(0 &&
               "seq_params->bit_depth should be AOM_BITS_8, "
               "AOM_BITS_10 or AOM_BITS_12");
        return -1;
    }
  }

  aom_clear_system_state();
  double log_intra = log(this_intra_error + 1.0);
  if (log_intra < 10.0) {
    stats->intra_factor += 1.0 + ((10.0 - log_intra) * 0.05);
  } else {
    stats->intra_factor += 1.0;
  }

  int level_sample;
  if (seq_params->use_highbitdepth) {
    level_sample = CONVERT_TO_SHORTPTR(x->plane[0].src.buf)[0];
  } else {
    level_sample = x->plane[0].src.buf[0];
  }
  if ((level_sample < DARK_THRESH) && (log_intra < 9.0)) {
    stats->brightness_factor += 1.0 + (0.01 * (DARK_THRESH - level_sample));
  } else {
    stats->brightness_factor += 1.0;
  }

  // Intrapenalty below deals with situations where the intra and inter
  // error scores are very low (e.g. a plain black frame).
  // We do not have special cases in first pass for 0,0 and nearest etc so
  // all inter modes carry an overhead cost estimate for the mv.
  // When the error score is very low this causes us to pick all or lots of
  // INTRA modes and throw lots of key frames.
  // This penalty adds a cost matching that of a 0,0 mv to the intra case.
  this_intra_error += INTRA_MODE_PENALTY;

  // Accumulate the intra error.
  stats->intra_error += (int64_t)this_intra_error;

  const int hbd = is_cur_buf_hbd(xd);
  const int stride = x->plane[0].src.stride;
  uint8_t *buf = x->plane[0].src.buf;
  for (int r8 = 0; r8 < 2; ++r8) {
    for (int c8 = 0; c8 < 2; ++c8) {
      stats->frame_avg_wavelet_energy += av1_haar_ac_sad_8x8_uint8_input(
          buf + c8 * 8 + r8 * 8 * stride, stride, hbd);
    }
  }

  return this_intra_error;
}

// Returns the sum of square error between source and reference blocks.
static int get_prediction_error_bitdepth(const int is_high_bitdepth,
                                         const int bitdepth,
                                         const BLOCK_SIZE block_size,
                                         const struct buf_2d *src,
                                         const struct buf_2d *ref) {
  (void)is_high_bitdepth;
  (void)bitdepth;
#if CONFIG_AV1_HIGHBITDEPTH
  if (is_high_bitdepth) {
    return highbd_get_prediction_error(block_size, src, ref, bitdepth);
  }
#endif  // CONFIG_AV1_HIGHBITDEPTH
  return get_prediction_error(block_size, src, ref);
}

// Accumulates motion vector stats.
// Modifies member variables of "stats".
static void accumulate_mv_stats(const MV best_mv, const FULLPEL_MV mv,
                                const int mb_row, const int mb_col,
                                const int mb_rows, const int mb_cols,
                                MV *last_mv, FRAME_STATS *stats) {
  if (is_zero_mv(&best_mv)) return;

  ++stats->mv_count;
  // Non-zero vector, was it different from the last non zero vector?
  if (!is_equal_mv(&best_mv, last_mv)) ++stats->new_mv_count;
  *last_mv = best_mv;

  // Does the row vector point inwards or outwards?
  if (mb_row < mb_rows / 2) {
    if (mv.row > 0) {
      --stats->sum_in_vectors;
    } else if (mv.row < 0) {
      ++stats->sum_in_vectors;
    }
  } else if (mb_row > mb_rows / 2) {
    if (mv.row > 0) {
      ++stats->sum_in_vectors;
    } else if (mv.row < 0) {
      --stats->sum_in_vectors;
    }
  }

  // Does the col vector point inwards or outwards?
  if (mb_col < mb_cols / 2) {
    if (mv.col > 0) {
      --stats->sum_in_vectors;
    } else if (mv.col < 0) {
      ++stats->sum_in_vectors;
    }
  } else if (mb_col > mb_cols / 2) {
    if (mv.col > 0) {
      ++stats->sum_in_vectors;
    } else if (mv.col < 0) {
      --stats->sum_in_vectors;
    }
  }
}

#define LOW_MOTION_ERROR_THRESH 25
// Computes and returns the inter prediction error from the last frame.
// Computes inter prediction errors from the golden and alt ref frams and
// Updates stats accordingly.
// Inputs:
//   cpi: the encoder setting. Only a few params in it will be used.
//   last_frame: the frame buffer of the last frame.
//   golden_frame: the frame buffer of the golden frame.
//   alt_ref_frame: the frame buffer of the alt ref frame.
//   mb_row: row index in the unit of first pass block size.
//   mb_col: column index in the unit of first pass block size.
//   recon_yoffset: the y offset of the reconstructed  frame buffer,
//                  indicating the starting point of the current block.
//   recont_uvoffset: the u/v offset of the reconstructed frame buffer,
//                    indicating the starting point of the current block.
//   src_yoffset: the y offset of the source frame buffer.
//   alt_ref_frame_offset: the y offset of the alt ref frame buffer.
//   fp_block_size: first pass block size.
//   this_intra_error: the intra prediction error of this block.
//   raw_motion_err_counts: the count of raw motion vectors.
//   raw_motion_err_list: the array that records the raw motion error.
//   best_ref_mv: best reference mv found so far.
//   last_mv: last mv.
//   stats: frame encoding stats.
//  Modifies:
//    raw_motion_err_list
//    best_ref_mv
//    last_mv
//    stats: many member params in it.
//  Returns:
//    this_inter_error
static int firstpass_inter_prediction(
    AV1_COMP *cpi, const YV12_BUFFER_CONFIG *const last_frame,
    const YV12_BUFFER_CONFIG *const golden_frame,
    const YV12_BUFFER_CONFIG *const alt_ref_frame, const int mb_row,
    const int mb_col, const int recon_yoffset, const int recon_uvoffset,
    const int src_yoffset, const int alt_ref_frame_yoffset,
    const BLOCK_SIZE fp_block_size, const int this_intra_error,
    const int raw_motion_err_counts, int *raw_motion_err_list, MV *best_ref_mv,
    MV *last_mv, FRAME_STATS *stats) {
  int this_inter_error = this_intra_error;
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  CurrentFrame *const current_frame = &cm->current_frame;
  MACROBLOCK *const x = &cpi->td.mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const int is_high_bitdepth = is_cur_buf_hbd(xd);
  const int bitdepth = xd->bd;
  const int mb_scale = mi_size_wide[fp_block_size];
  const BLOCK_SIZE bsize = get_bsize(mi_params, mb_row, mb_col);
  const int fp_block_size_height = block_size_wide[fp_block_size];
  // Assume 0,0 motion with no mv overhead.
  FULLPEL_MV mv = kZeroFullMv;
  FULLPEL_MV tmp_mv = kZeroFullMv;
  xd->plane[0].pre[0].buf = last_frame->y_buffer + recon_yoffset;
  // Set up limit values for motion vectors to prevent them extending
  // outside the UMV borders.
  av1_set_mv_col_limits(mi_params, &x->mv_limits, (mb_col << 2),
                        (fp_block_size_height >> MI_SIZE_LOG2),
                        cpi->oxcf.border_in_pixels);

  int motion_error =
      get_prediction_error_bitdepth(is_high_bitdepth, bitdepth, bsize,
                                    &x->plane[0].src, &xd->plane[0].pre[0]);

  // Compute the motion error of the 0,0 motion using the last source
  // frame as the reference. Skip the further motion search on
  // reconstructed frame if this error is small.
  struct buf_2d unscaled_last_source_buf_2d;
  unscaled_last_source_buf_2d.buf =
      cpi->unscaled_last_source->y_buffer + src_yoffset;
  unscaled_last_source_buf_2d.stride = cpi->unscaled_last_source->y_stride;
  const int raw_motion_error = get_prediction_error_bitdepth(
      is_high_bitdepth, bitdepth, bsize, &x->plane[0].src,
      &unscaled_last_source_buf_2d);
  raw_motion_err_list[raw_motion_err_counts] = raw_motion_error;

  // TODO(pengchong): Replace the hard-coded threshold
  if (raw_motion_error > LOW_MOTION_ERROR_THRESH) {
    // Test last reference frame using the previous best mv as the
    // starting point (best reference) for the search.
    first_pass_motion_search(cpi, x, best_ref_mv, &mv, &motion_error);

    // If the current best reference mv is not centered on 0,0 then do a
    // 0,0 based search as well.
    if (!is_zero_mv(best_ref_mv)) {
      int tmp_err = INT_MAX;
      first_pass_motion_search(cpi, x, &kZeroMv, &tmp_mv, &tmp_err);

      if (tmp_err < motion_error) {
        motion_error = tmp_err;
        mv = tmp_mv;
      }
    }

    // Motion search in 2nd reference frame.
    int gf_motion_error = motion_error;
    if ((current_frame->frame_number > 1) && golden_frame != NULL) {
      // Assume 0,0 motion with no mv overhead.
      xd->plane[0].pre[0].buf = golden_frame->y_buffer + recon_yoffset;
      xd->plane[0].pre[0].stride = golden_frame->y_stride;
      gf_motion_error =
          get_prediction_error_bitdepth(is_high_bitdepth, bitdepth, bsize,
                                        &x->plane[0].src, &xd->plane[0].pre[0]);
      first_pass_motion_search(cpi, x, &kZeroMv, &tmp_mv, &gf_motion_error);
    }
    if (gf_motion_error < motion_error && gf_motion_error < this_intra_error) {
      ++stats->second_ref_count;
    }
    // In accumulating a score for the 2nd reference frame take the
    // best of the motion predicted score and the intra coded error
    // (just as will be done for) accumulation of "coded_error" for
    // the last frame.
    if ((current_frame->frame_number > 1) && golden_frame != NULL) {
      stats->sr_coded_error += AOMMIN(gf_motion_error, this_intra_error);
    } else {
      // TODO(chengchen): I believe logically this should also be changed to
      // stats->sr_coded_error += AOMMIN(gf_motion_error, this_intra_error).
      stats->sr_coded_error += motion_error;
    }

    // Motion search in 3rd reference frame.
    int alt_motion_error = motion_error;
    if (alt_ref_frame != NULL) {
      xd->plane[0].pre[0].buf = alt_ref_frame->y_buffer + alt_ref_frame_yoffset;
      xd->plane[0].pre[0].stride = alt_ref_frame->y_stride;
      alt_motion_error =
          get_prediction_error_bitdepth(is_high_bitdepth, bitdepth, bsize,
                                        &x->plane[0].src, &xd->plane[0].pre[0]);
      first_pass_motion_search(cpi, x, &kZeroMv, &tmp_mv, &alt_motion_error);
    }
    if (alt_motion_error < motion_error && alt_motion_error < gf_motion_error &&
        alt_motion_error < this_intra_error) {
      ++stats->third_ref_count;
    }
    // In accumulating a score for the 3rd reference frame take the
    // best of the motion predicted score and the intra coded error
    // (just as will be done for) accumulation of "coded_error" for
    // the last frame.
    if (alt_ref_frame != NULL) {
      stats->tr_coded_error += AOMMIN(alt_motion_error, this_intra_error);
    } else {
      // TODO(chengchen): I believe logically this should also be changed to
      // stats->tr_coded_error += AOMMIN(alt_motion_error, this_intra_error).
      stats->tr_coded_error += motion_error;
    }

    // Reset to last frame as reference buffer.
    xd->plane[0].pre[0].buf = last_frame->y_buffer + recon_yoffset;
    xd->plane[1].pre[0].buf = last_frame->u_buffer + recon_uvoffset;
    xd->plane[2].pre[0].buf = last_frame->v_buffer + recon_uvoffset;
  } else {
    stats->sr_coded_error += motion_error;
    stats->tr_coded_error += motion_error;
  }

  // Start by assuming that intra mode is best.
  best_ref_mv->row = 0;
  best_ref_mv->col = 0;

  if (motion_error <= this_intra_error) {
    aom_clear_system_state();

    // Keep a count of cases where the inter and intra were very close
    // and very low. This helps with scene cut detection for example in
    // cropped clips with black bars at the sides or top and bottom.
    if (((this_intra_error - INTRA_MODE_PENALTY) * 9 <= motion_error * 10) &&
        (this_intra_error < (2 * INTRA_MODE_PENALTY))) {
      stats->neutral_count += 1.0;
      // Also track cases where the intra is not much worse than the inter
      // and use this in limiting the GF/arf group length.
    } else if ((this_intra_error > NCOUNT_INTRA_THRESH) &&
               (this_intra_error < (NCOUNT_INTRA_FACTOR * motion_error))) {
      stats->neutral_count +=
          (double)motion_error / DOUBLE_DIVIDE_CHECK((double)this_intra_error);
    }

    const MV best_mv = get_mv_from_fullmv(&mv);
    this_inter_error = motion_error;
    xd->mi[0]->mode = NEWMV;
    xd->mi[0]->mv[0].as_mv = best_mv;
    xd->mi[0]->tx_size = TX_4X4;
    xd->mi[0]->ref_frame[0] = LAST_FRAME;
    xd->mi[0]->ref_frame[1] = NONE_FRAME;
    av1_enc_build_inter_predictor(cm, xd, mb_row * mb_scale, mb_col * mb_scale,
                                  NULL, bsize, AOM_PLANE_Y, AOM_PLANE_Y);
    av1_encode_sby_pass1(cpi, x, bsize);
    stats->sum_mvr += best_mv.row;
    stats->sum_mvr_abs += abs(best_mv.row);
    stats->sum_mvc += best_mv.col;
    stats->sum_mvc_abs += abs(best_mv.col);
    stats->sum_mvrs += best_mv.row * best_mv.row;
    stats->sum_mvcs += best_mv.col * best_mv.col;
    ++stats->inter_count;

    *best_ref_mv = best_mv;
    accumulate_mv_stats(best_mv, mv, mb_row, mb_col, mi_params->mb_rows,
                        mi_params->mb_cols, last_mv, stats);
  }

  return this_inter_error;
}

// Updates the first pass stats of this frame.
// Input:
//   cpi: the encoder setting. Only a few params in it will be used.
//   stats: stats accumulated for this frame.
//   raw_err_stdev: the statndard deviation for the motion error of all the
//                  inter blocks of the (0,0) motion using the last source
//                  frame as the reference.
//   frame_number: current frame number.
//   ts_duration: Duration of the frame / collection of frames.
// Updates:
//   twopass->total_stats: the accumulated stats.
//   twopass->stats_buf_ctx->stats_in_end: the pointer to the current stats,
//                                         update its value and its position
//                                         in the buffer.
static void update_firstpass_stats(AV1_COMP *cpi,
                                   const FRAME_STATS *const stats,
                                   const double raw_err_stdev,
                                   const int frame_number,
                                   const int64_t ts_duration) {
  TWO_PASS *twopass = &cpi->twopass;
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  FIRSTPASS_STATS *this_frame_stats = twopass->stats_buf_ctx->stats_in_end;
  FIRSTPASS_STATS fps;
  // The minimum error here insures some bit allocation to frames even
  // in static regions. The allocation per MB declines for larger formats
  // where the typical "real" energy per MB also falls.
  // Initial estimate here uses sqrt(mbs) to define the min_err, where the
  // number of mbs is proportional to the image area.
  const int num_mbs = (cpi->oxcf.resize_mode != RESIZE_NONE) ? cpi->initial_mbs
                                                             : mi_params->MBs;
  const double min_err = 200 * sqrt(num_mbs);

  fps.weight = stats->intra_factor * stats->brightness_factor;
  fps.frame = frame_number;
  fps.coded_error = (double)(stats->coded_error >> 8) + min_err;
  fps.sr_coded_error = (double)(stats->sr_coded_error >> 8) + min_err;
  fps.tr_coded_error = (double)(stats->tr_coded_error >> 8) + min_err;
  fps.intra_error = (double)(stats->intra_error >> 8) + min_err;
  fps.frame_avg_wavelet_energy = (double)stats->frame_avg_wavelet_energy;
  fps.count = 1.0;
  fps.pcnt_inter = (double)stats->inter_count / num_mbs;
  fps.pcnt_second_ref = (double)stats->second_ref_count / num_mbs;
  fps.pcnt_third_ref = (double)stats->third_ref_count / num_mbs;
  fps.pcnt_neutral = (double)stats->neutral_count / num_mbs;
  fps.intra_skip_pct = (double)stats->intra_skip_count / num_mbs;
  fps.inactive_zone_rows = (double)stats->image_data_start_row;
  fps.inactive_zone_cols = (double)0;  // TODO(paulwilkins): fix
  fps.raw_error_stdev = raw_err_stdev;

  if (stats->mv_count > 0) {
    fps.MVr = (double)stats->sum_mvr / stats->mv_count;
    fps.mvr_abs = (double)stats->sum_mvr_abs / stats->mv_count;
    fps.MVc = (double)stats->sum_mvc / stats->mv_count;
    fps.mvc_abs = (double)stats->sum_mvc_abs / stats->mv_count;
    fps.MVrv = ((double)stats->sum_mvrs -
                ((double)stats->sum_mvr * stats->sum_mvr / stats->mv_count)) /
               stats->mv_count;
    fps.MVcv = ((double)stats->sum_mvcs -
                ((double)stats->sum_mvc * stats->sum_mvc / stats->mv_count)) /
               stats->mv_count;
    fps.mv_in_out_count = (double)stats->sum_in_vectors / (stats->mv_count * 2);
    fps.new_mv_count = stats->new_mv_count;
    fps.pcnt_motion = (double)stats->mv_count / num_mbs;
  } else {
    fps.MVr = 0.0;
    fps.mvr_abs = 0.0;
    fps.MVc = 0.0;
    fps.mvc_abs = 0.0;
    fps.MVrv = 0.0;
    fps.MVcv = 0.0;
    fps.mv_in_out_count = 0.0;
    fps.new_mv_count = 0.0;
    fps.pcnt_motion = 0.0;
  }

  // TODO(paulwilkins):  Handle the case when duration is set to 0, or
  // something less than the full time between subsequent values of
  // cpi->source_time_stamp.
  fps.duration = (double)ts_duration;

  // We will store the stats inside the persistent twopass struct (and NOT the
  // local variable 'fps'), and then cpi->output_pkt_list will point to it.
  *this_frame_stats = fps;
  output_stats(this_frame_stats, cpi->output_pkt_list);
  if (cpi->twopass.stats_buf_ctx->total_stats != NULL) {
    accumulate_stats(cpi->twopass.stats_buf_ctx->total_stats, &fps);
  }
  /*In the case of two pass, first pass uses it as a circular buffer,
   * when LAP is enabled it is used as a linear buffer*/
  twopass->stats_buf_ctx->stats_in_end++;
  if ((cpi->oxcf.pass == 1) && (twopass->stats_buf_ctx->stats_in_end >=
                                twopass->stats_buf_ctx->stats_in_buf_end)) {
    twopass->stats_buf_ctx->stats_in_end =
        twopass->stats_buf_ctx->stats_in_start;
  }
}

static void print_reconstruction_frame(
    const YV12_BUFFER_CONFIG *const last_frame, int frame_number,
    int do_print) {
  if (!do_print) return;

  char filename[512];
  FILE *recon_file;
  snprintf(filename, sizeof(filename), "enc%04d.yuv", frame_number);

  if (frame_number == 0) {
    recon_file = fopen(filename, "wb");
  } else {
    recon_file = fopen(filename, "ab");
  }

  fwrite(last_frame->buffer_alloc, last_frame->frame_size, 1, recon_file);
  fclose(recon_file);
}

#define FIRST_PASS_ALT_REF_DISTANCE 16
void av1_first_pass(AV1_COMP *cpi, const int64_t ts_duration) {
  MACROBLOCK *const x = &cpi->td.mb;
  AV1_COMMON *const cm = &cpi->common;
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  CurrentFrame *const current_frame = &cm->current_frame;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *const xd = &x->e_mbd;
  const PICK_MODE_CONTEXT *ctx = &cpi->td.pc_root->none;
  MV last_mv = kZeroMv;
  const int qindex = find_fp_qindex(seq_params->bit_depth);
  // Detect if the key frame is screen content type.
  if (frame_is_intra_only(cm)) {
    FeatureFlags *const features = &cm->features;
    av1_set_screen_content_options(cpi, features);
    cpi->is_screen_content_type = features->allow_screen_content_tools;
  }
  // First pass coding proceeds in raster scan order with unit size of 16x16.
  const BLOCK_SIZE fp_block_size = BLOCK_16X16;
  const int fp_block_size_width = block_size_high[fp_block_size];
  const int fp_block_size_height = block_size_wide[fp_block_size];
  int *raw_motion_err_list;
  int raw_motion_err_counts = 0;
  CHECK_MEM_ERROR(cm, raw_motion_err_list,
                  aom_calloc(mi_params->mb_rows * mi_params->mb_cols,
                             sizeof(*raw_motion_err_list)));
  // Tiling is ignored in the first pass.
  TileInfo tile;
  av1_tile_init(&tile, cm, 0, 0);
  FRAME_STATS stats = { 0 };
  stats.image_data_start_row = INVALID_ROW;

  const YV12_BUFFER_CONFIG *const last_frame =
      get_ref_frame_yv12_buf(cm, LAST_FRAME);
  const YV12_BUFFER_CONFIG *golden_frame =
      get_ref_frame_yv12_buf(cm, GOLDEN_FRAME);
  const YV12_BUFFER_CONFIG *alt_ref_frame = NULL;
  const int alt_ref_offset =
      FIRST_PASS_ALT_REF_DISTANCE -
      (current_frame->frame_number % FIRST_PASS_ALT_REF_DISTANCE);
  if (alt_ref_offset < FIRST_PASS_ALT_REF_DISTANCE) {
    const struct lookahead_entry *const alt_ref_frame_buffer =
        av1_lookahead_peek(cpi->lookahead, alt_ref_offset,
                           cpi->compressor_stage);
    if (alt_ref_frame_buffer != NULL) {
      alt_ref_frame = &alt_ref_frame_buffer->img;
    }
  }
  YV12_BUFFER_CONFIG *const this_frame = &cm->cur_frame->buf;
  // First pass code requires valid last and new frame buffers.
  assert(this_frame != NULL);
  assert(frame_is_intra_only(cm) || (last_frame != NULL));

  av1_setup_frame_size(cpi);
  aom_clear_system_state();

  set_mi_offsets(mi_params, xd, 0, 0);
  xd->mi[0]->sb_type = fp_block_size;

  // Do not use periodic key frames.
  cpi->rc.frames_to_key = INT_MAX;

  av1_set_quantizer(cm, cpi->oxcf.qm_minlevel, cpi->oxcf.qm_maxlevel, qindex);

  av1_setup_block_planes(xd, seq_params->subsampling_x,
                         seq_params->subsampling_y, num_planes);

  av1_setup_src_planes(x, cpi->source, 0, 0, num_planes, fp_block_size);
  av1_setup_dst_planes(xd->plane, seq_params->sb_size, this_frame, 0, 0, 0,
                       num_planes);

  if (!frame_is_intra_only(cm)) {
    av1_setup_pre_planes(xd, 0, last_frame, 0, 0, NULL, num_planes);
  }

  set_mi_offsets(mi_params, xd, 0, 0);

  // Don't store luma on the fist pass since chroma is not computed
  xd->cfl.store_y = 0;
  av1_frame_init_quantizer(cpi);

  for (int i = 0; i < num_planes; ++i) {
    x->plane[i].coeff = ctx->coeff[i];
    x->plane[i].qcoeff = ctx->qcoeff[i];
    x->plane[i].eobs = ctx->eobs[i];
    x->plane[i].txb_entropy_ctx = ctx->txb_entropy_ctx[i];
    xd->plane[i].dqcoeff = ctx->dqcoeff[i];
  }

  av1_init_mv_probs(cm);
  av1_initialize_rd_consts(cpi);

  const int src_y_stride = cpi->source->y_stride;
  const int recon_y_stride = this_frame->y_stride;
  const int recon_uv_stride = this_frame->uv_stride;
  const int uv_mb_height =
      fp_block_size_height >> (this_frame->y_height > this_frame->uv_height);

  for (int mb_row = 0; mb_row < mi_params->mb_rows; ++mb_row) {
    MV best_ref_mv = kZeroMv;

    // Reset above block coeffs.
    xd->up_available = (mb_row != 0);
    int recon_yoffset = (mb_row * recon_y_stride * fp_block_size_height);
    int src_yoffset = (mb_row * src_y_stride * fp_block_size_height);
    int recon_uvoffset = (mb_row * recon_uv_stride * uv_mb_height);
    int alt_ref_frame_yoffset =
        (alt_ref_frame != NULL)
            ? mb_row * alt_ref_frame->y_stride * fp_block_size_height
            : -1;

    // Set up limit values for motion vectors to prevent them extending
    // outside the UMV borders.
    av1_set_mv_row_limits(mi_params, &x->mv_limits, (mb_row << 2),
                          (fp_block_size_height >> MI_SIZE_LOG2),
                          cpi->oxcf.border_in_pixels);

    for (int mb_col = 0; mb_col < mi_params->mb_cols; ++mb_col) {
      int this_intra_error = firstpass_intra_prediction(
          cpi, this_frame, &tile, mb_row, mb_col, recon_yoffset, recon_uvoffset,
          fp_block_size, qindex, &stats);

      if (!frame_is_intra_only(cm)) {
        const int this_inter_error = firstpass_inter_prediction(
            cpi, last_frame, golden_frame, alt_ref_frame, mb_row, mb_col,
            recon_yoffset, recon_uvoffset, src_yoffset, alt_ref_frame_yoffset,
            fp_block_size, this_intra_error, raw_motion_err_counts,
            raw_motion_err_list, &best_ref_mv, &last_mv, &stats);
        stats.coded_error += this_inter_error;
        ++raw_motion_err_counts;
      } else {
        stats.sr_coded_error += this_intra_error;
        stats.tr_coded_error += this_intra_error;
        stats.coded_error += this_intra_error;
      }

      // Adjust to the next column of MBs.
      x->plane[0].src.buf += fp_block_size_width;
      x->plane[1].src.buf += uv_mb_height;
      x->plane[2].src.buf += uv_mb_height;

      recon_yoffset += fp_block_size_width;
      src_yoffset += fp_block_size_width;
      recon_uvoffset += uv_mb_height;
      alt_ref_frame_yoffset += fp_block_size_width;
    }
    // Adjust to the next row of MBs.
    x->plane[0].src.buf += fp_block_size_height * x->plane[0].src.stride -
                           fp_block_size_width * mi_params->mb_cols;
    x->plane[1].src.buf += uv_mb_height * x->plane[1].src.stride -
                           uv_mb_height * mi_params->mb_cols;
    x->plane[2].src.buf += uv_mb_height * x->plane[1].src.stride -
                           uv_mb_height * mi_params->mb_cols;
  }
  const double raw_err_stdev =
      raw_motion_error_stdev(raw_motion_err_list, raw_motion_err_counts);
  aom_free(raw_motion_err_list);

  // Clamp the image start to rows/2. This number of rows is discarded top
  // and bottom as dead data so rows / 2 means the frame is blank.
  if ((stats.image_data_start_row > mi_params->mb_rows / 2) ||
      (stats.image_data_start_row == INVALID_ROW)) {
    stats.image_data_start_row = mi_params->mb_rows / 2;
  }
  // Exclude any image dead zone
  if (stats.image_data_start_row > 0) {
    stats.intra_skip_count =
        AOMMAX(0, stats.intra_skip_count -
                      (stats.image_data_start_row * mi_params->mb_cols * 2));
  }

  TWO_PASS *twopass = &cpi->twopass;
  const int num_mbs = (cpi->oxcf.resize_mode != RESIZE_NONE) ? cpi->initial_mbs
                                                             : mi_params->MBs;
  stats.intra_factor = stats.intra_factor / (double)num_mbs;
  stats.brightness_factor = stats.brightness_factor / (double)num_mbs;
  FIRSTPASS_STATS *this_frame_stats = twopass->stats_buf_ctx->stats_in_end;
  update_firstpass_stats(cpi, &stats, raw_err_stdev,
                         current_frame->frame_number, ts_duration);

  // Copy the previous Last Frame back into gf buffer if the prediction is good
  // enough... but also don't allow it to lag too far.
  if ((twopass->sr_update_lag > 3) ||
      ((current_frame->frame_number > 0) &&
       (this_frame_stats->pcnt_inter > 0.20) &&
       ((this_frame_stats->intra_error /
         DOUBLE_DIVIDE_CHECK(this_frame_stats->coded_error)) > 2.0))) {
    if (golden_frame != NULL) {
      assign_frame_buffer_p(
          &cm->ref_frame_map[get_ref_frame_map_idx(cm, GOLDEN_FRAME)],
          cm->ref_frame_map[get_ref_frame_map_idx(cm, LAST_FRAME)]);
    }
    twopass->sr_update_lag = 1;
  } else {
    ++twopass->sr_update_lag;
  }

  aom_extend_frame_borders(this_frame, num_planes);

  // The frame we just compressed now becomes the last frame.
  assign_frame_buffer_p(
      &cm->ref_frame_map[get_ref_frame_map_idx(cm, LAST_FRAME)], cm->cur_frame);

  // Special case for the first frame. Copy into the GF buffer as a second
  // reference.
  if (current_frame->frame_number == 0 &&
      get_ref_frame_map_idx(cm, GOLDEN_FRAME) != INVALID_IDX) {
    assign_frame_buffer_p(
        &cm->ref_frame_map[get_ref_frame_map_idx(cm, GOLDEN_FRAME)],
        cm->ref_frame_map[get_ref_frame_map_idx(cm, LAST_FRAME)]);
  }

  print_reconstruction_frame(last_frame, current_frame->frame_number,
                             /*do_print=*/0);

  ++current_frame->frame_number;
}
