/*
 * Copyright (c) 2020, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include "av1/common/pred_common.h"
#include "av1/encoder/compound_type.h"
#include "av1/encoder/model_rd.h"
#include "av1/encoder/motion_search_facade.h"
#include "av1/encoder/rdopt_utils.h"
#include "av1/encoder/reconinter_enc.h"
#include "av1/encoder/tx_search.h"

typedef int64_t (*pick_interinter_mask_type)(
    const AV1_COMP *const cpi, MACROBLOCK *x, const BLOCK_SIZE bsize,
    const uint8_t *const p0, const uint8_t *const p1,
    const int16_t *const residual1, const int16_t *const diff10,
    uint64_t *best_sse);

// Checks if characteristics of search match
static INLINE int is_comp_rd_match(const AV1_COMP *const cpi,
                                   const MACROBLOCK *const x,
                                   const COMP_RD_STATS *st,
                                   const MB_MODE_INFO *const mi,
                                   int32_t *comp_rate, int64_t *comp_dist,
                                   int32_t *comp_model_rate,
                                   int64_t *comp_model_dist, int *comp_rs2) {
  // TODO(ranjit): Ensure that compound type search use regular filter always
  // and check if following check can be removed
  // Check if interp filter matches with previous case
  if (st->filter.as_int != mi->interp_filters.as_int) return 0;

  const MACROBLOCKD *const xd = &x->e_mbd;
  // Match MV and reference indices
  for (int i = 0; i < 2; ++i) {
    if ((st->ref_frames[i] != mi->ref_frame[i]) ||
        (st->mv[i].as_int != mi->mv[i].as_int)) {
      return 0;
    }
    const WarpedMotionParams *const wm = &xd->global_motion[mi->ref_frame[i]];
    if (is_global_mv_block(mi, wm->wmtype) != st->is_global[i]) return 0;
  }

  // Store the stats for COMPOUND_AVERAGE and COMPOUND_DISTWTD
  for (int comp_type = COMPOUND_AVERAGE; comp_type <= COMPOUND_DISTWTD;
       comp_type++) {
    comp_rate[comp_type] = st->rate[comp_type];
    comp_dist[comp_type] = st->dist[comp_type];
    comp_model_rate[comp_type] = st->model_rate[comp_type];
    comp_model_dist[comp_type] = st->model_dist[comp_type];
    comp_rs2[comp_type] = st->comp_rs2[comp_type];
  }

  // For compound wedge/segment, reuse data only if NEWMV is not present in
  // either of the directions
  if ((!have_newmv_in_inter_mode(mi->mode) &&
       !have_newmv_in_inter_mode(st->mode)) ||
      (cpi->sf.inter_sf.disable_interinter_wedge_newmv_search)) {
    memcpy(&comp_rate[COMPOUND_WEDGE], &st->rate[COMPOUND_WEDGE],
           sizeof(comp_rate[COMPOUND_WEDGE]) * 2);
    memcpy(&comp_dist[COMPOUND_WEDGE], &st->dist[COMPOUND_WEDGE],
           sizeof(comp_dist[COMPOUND_WEDGE]) * 2);
    memcpy(&comp_model_rate[COMPOUND_WEDGE], &st->model_rate[COMPOUND_WEDGE],
           sizeof(comp_model_rate[COMPOUND_WEDGE]) * 2);
    memcpy(&comp_model_dist[COMPOUND_WEDGE], &st->model_dist[COMPOUND_WEDGE],
           sizeof(comp_model_dist[COMPOUND_WEDGE]) * 2);
    memcpy(&comp_rs2[COMPOUND_WEDGE], &st->comp_rs2[COMPOUND_WEDGE],
           sizeof(comp_rs2[COMPOUND_WEDGE]) * 2);
  }
  return 1;
}

// Checks if similar compound type search case is accounted earlier
// If found, returns relevant rd data
static INLINE int find_comp_rd_in_stats(const AV1_COMP *const cpi,
                                        const MACROBLOCK *x,
                                        const MB_MODE_INFO *const mbmi,
                                        int32_t *comp_rate, int64_t *comp_dist,
                                        int32_t *comp_model_rate,
                                        int64_t *comp_model_dist, int *comp_rs2,
                                        int *match_index) {
  for (int j = 0; j < x->comp_rd_stats_idx; ++j) {
    if (is_comp_rd_match(cpi, x, &x->comp_rd_stats[j], mbmi, comp_rate,
                         comp_dist, comp_model_rate, comp_model_dist,
                         comp_rs2)) {
      *match_index = j;
      return 1;
    }
  }
  return 0;  // no match result found
}

static INLINE bool enable_wedge_search(MACROBLOCK *const x,
                                       const AV1_COMP *const cpi) {
  // Enable wedge search if source variance and edge strength are above
  // the thresholds.
  return x->source_variance >
             cpi->sf.inter_sf.disable_wedge_search_var_thresh &&
         x->edge_strength > cpi->sf.inter_sf.disable_wedge_search_edge_thresh;
}

static INLINE bool enable_wedge_interinter_search(MACROBLOCK *const x,
                                                  const AV1_COMP *const cpi) {
  return enable_wedge_search(x, cpi) && cpi->oxcf.enable_interinter_wedge &&
         !cpi->sf.inter_sf.disable_interinter_wedge;
}

static INLINE bool enable_wedge_interintra_search(MACROBLOCK *const x,
                                                  const AV1_COMP *const cpi) {
  return enable_wedge_search(x, cpi) && cpi->oxcf.enable_interintra_wedge &&
         !cpi->sf.inter_sf.disable_wedge_interintra_search;
}

static int8_t estimate_wedge_sign(const AV1_COMP *cpi, const MACROBLOCK *x,
                                  const BLOCK_SIZE bsize, const uint8_t *pred0,
                                  int stride0, const uint8_t *pred1,
                                  int stride1) {
  static const BLOCK_SIZE split_qtr[BLOCK_SIZES_ALL] = {
    //                            4X4
    BLOCK_INVALID,
    // 4X8,        8X4,           8X8
    BLOCK_INVALID, BLOCK_INVALID, BLOCK_4X4,
    // 8X16,       16X8,          16X16
    BLOCK_4X8, BLOCK_8X4, BLOCK_8X8,
    // 16X32,      32X16,         32X32
    BLOCK_8X16, BLOCK_16X8, BLOCK_16X16,
    // 32X64,      64X32,         64X64
    BLOCK_16X32, BLOCK_32X16, BLOCK_32X32,
    // 64x128,     128x64,        128x128
    BLOCK_32X64, BLOCK_64X32, BLOCK_64X64,
    // 4X16,       16X4,          8X32
    BLOCK_INVALID, BLOCK_INVALID, BLOCK_4X16,
    // 32X8,       16X64,         64X16
    BLOCK_16X4, BLOCK_8X32, BLOCK_32X8
  };
  const struct macroblock_plane *const p = &x->plane[0];
  const uint8_t *src = p->src.buf;
  int src_stride = p->src.stride;
  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  const int bw_by2 = bw >> 1;
  const int bh_by2 = bh >> 1;
  uint32_t esq[2][2];
  int64_t tl, br;

  const BLOCK_SIZE f_index = split_qtr[bsize];
  assert(f_index != BLOCK_INVALID);

  if (is_cur_buf_hbd(&x->e_mbd)) {
    pred0 = CONVERT_TO_BYTEPTR(pred0);
    pred1 = CONVERT_TO_BYTEPTR(pred1);
  }

  // Residual variance computation over relevant quandrants in order to
  // find TL + BR, TL = sum(1st,2nd,3rd) quadrants of (pred0 - pred1),
  // BR = sum(2nd,3rd,4th) quadrants of (pred1 - pred0)
  // The 2nd and 3rd quadrants cancel out in TL + BR
  // Hence TL + BR = 1st quadrant of (pred0-pred1) + 4th of (pred1-pred0)
  // TODO(nithya): Sign estimation assumes 45 degrees (1st and 4th quadrants)
  // for all codebooks; experiment with other quadrant combinations for
  // 0, 90 and 135 degrees also.
  cpi->fn_ptr[f_index].vf(src, src_stride, pred0, stride0, &esq[0][0]);
  cpi->fn_ptr[f_index].vf(src + bh_by2 * src_stride + bw_by2, src_stride,
                          pred0 + bh_by2 * stride0 + bw_by2, stride0,
                          &esq[0][1]);
  cpi->fn_ptr[f_index].vf(src, src_stride, pred1, stride1, &esq[1][0]);
  cpi->fn_ptr[f_index].vf(src + bh_by2 * src_stride + bw_by2, src_stride,
                          pred1 + bh_by2 * stride1 + bw_by2, stride0,
                          &esq[1][1]);

  tl = ((int64_t)esq[0][0]) - ((int64_t)esq[1][0]);
  br = ((int64_t)esq[1][1]) - ((int64_t)esq[0][1]);
  return (tl + br > 0);
}

// Choose the best wedge index and sign
static int64_t pick_wedge(const AV1_COMP *const cpi, const MACROBLOCK *const x,
                          const BLOCK_SIZE bsize, const uint8_t *const p0,
                          const int16_t *const residual1,
                          const int16_t *const diff10,
                          int8_t *const best_wedge_sign,
                          int8_t *const best_wedge_index, uint64_t *best_sse) {
  const MACROBLOCKD *const xd = &x->e_mbd;
  const struct buf_2d *const src = &x->plane[0].src;
  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  const int N = bw * bh;
  assert(N >= 64);
  int rate;
  int64_t dist;
  int64_t rd, best_rd = INT64_MAX;
  int8_t wedge_index;
  int8_t wedge_sign;
  const int8_t wedge_types = get_wedge_types_lookup(bsize);
  const uint8_t *mask;
  uint64_t sse;
  const int hbd = is_cur_buf_hbd(xd);
  const int bd_round = hbd ? (xd->bd - 8) * 2 : 0;

  DECLARE_ALIGNED(32, int16_t, residual0[MAX_SB_SQUARE]);  // src - pred0
#if CONFIG_AV1_HIGHBITDEPTH
  if (hbd) {
    aom_highbd_subtract_block(bh, bw, residual0, bw, src->buf, src->stride,
                              CONVERT_TO_BYTEPTR(p0), bw, xd->bd);
  } else {
    aom_subtract_block(bh, bw, residual0, bw, src->buf, src->stride, p0, bw);
  }
#else
  (void)hbd;
  aom_subtract_block(bh, bw, residual0, bw, src->buf, src->stride, p0, bw);
#endif

  int64_t sign_limit = ((int64_t)aom_sum_squares_i16(residual0, N) -
                        (int64_t)aom_sum_squares_i16(residual1, N)) *
                       (1 << WEDGE_WEIGHT_BITS) / 2;
  int16_t *ds = residual0;

  av1_wedge_compute_delta_squares(ds, residual0, residual1, N);

  for (wedge_index = 0; wedge_index < wedge_types; ++wedge_index) {
    mask = av1_get_contiguous_soft_mask(wedge_index, 0, bsize);

    wedge_sign = av1_wedge_sign_from_residuals(ds, mask, N, sign_limit);

    mask = av1_get_contiguous_soft_mask(wedge_index, wedge_sign, bsize);
    sse = av1_wedge_sse_from_residuals(residual1, diff10, mask, N);
    sse = ROUND_POWER_OF_TWO(sse, bd_round);

    model_rd_sse_fn[MODELRD_TYPE_MASKED_COMPOUND](cpi, x, bsize, 0, sse, N,
                                                  &rate, &dist);
    // int rate2;
    // int64_t dist2;
    // model_rd_with_curvfit(cpi, x, bsize, 0, sse, N, &rate2, &dist2);
    // printf("sse %"PRId64": leagacy: %d %"PRId64", curvfit %d %"PRId64"\n",
    // sse, rate, dist, rate2, dist2); dist = dist2;
    // rate = rate2;

    rate += x->wedge_idx_cost[bsize][wedge_index];
    rd = RDCOST(x->rdmult, rate, dist);

    if (rd < best_rd) {
      *best_wedge_index = wedge_index;
      *best_wedge_sign = wedge_sign;
      best_rd = rd;
      *best_sse = sse;
    }
  }

  return best_rd -
         RDCOST(x->rdmult, x->wedge_idx_cost[bsize][*best_wedge_index], 0);
}

// Choose the best wedge index the specified sign
static int64_t pick_wedge_fixed_sign(
    const AV1_COMP *const cpi, const MACROBLOCK *const x,
    const BLOCK_SIZE bsize, const int16_t *const residual1,
    const int16_t *const diff10, const int8_t wedge_sign,
    int8_t *const best_wedge_index, uint64_t *best_sse) {
  const MACROBLOCKD *const xd = &x->e_mbd;

  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  const int N = bw * bh;
  assert(N >= 64);
  int rate;
  int64_t dist;
  int64_t rd, best_rd = INT64_MAX;
  int8_t wedge_index;
  const int8_t wedge_types = get_wedge_types_lookup(bsize);
  const uint8_t *mask;
  uint64_t sse;
  const int hbd = is_cur_buf_hbd(xd);
  const int bd_round = hbd ? (xd->bd - 8) * 2 : 0;
  for (wedge_index = 0; wedge_index < wedge_types; ++wedge_index) {
    mask = av1_get_contiguous_soft_mask(wedge_index, wedge_sign, bsize);
    sse = av1_wedge_sse_from_residuals(residual1, diff10, mask, N);
    sse = ROUND_POWER_OF_TWO(sse, bd_round);

    model_rd_sse_fn[MODELRD_TYPE_MASKED_COMPOUND](cpi, x, bsize, 0, sse, N,
                                                  &rate, &dist);
    rate += x->wedge_idx_cost[bsize][wedge_index];
    rd = RDCOST(x->rdmult, rate, dist);

    if (rd < best_rd) {
      *best_wedge_index = wedge_index;
      best_rd = rd;
      *best_sse = sse;
    }
  }
  return best_rd -
         RDCOST(x->rdmult, x->wedge_idx_cost[bsize][*best_wedge_index], 0);
}

static int64_t pick_interinter_wedge(
    const AV1_COMP *const cpi, MACROBLOCK *const x, const BLOCK_SIZE bsize,
    const uint8_t *const p0, const uint8_t *const p1,
    const int16_t *const residual1, const int16_t *const diff10,
    uint64_t *best_sse) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  const int bw = block_size_wide[bsize];

  int64_t rd;
  int8_t wedge_index = -1;
  int8_t wedge_sign = 0;

  assert(is_interinter_compound_used(COMPOUND_WEDGE, bsize));
  assert(cpi->common.seq_params.enable_masked_compound);

  if (cpi->sf.inter_sf.fast_wedge_sign_estimate) {
    wedge_sign = estimate_wedge_sign(cpi, x, bsize, p0, bw, p1, bw);
    rd = pick_wedge_fixed_sign(cpi, x, bsize, residual1, diff10, wedge_sign,
                               &wedge_index, best_sse);
  } else {
    rd = pick_wedge(cpi, x, bsize, p0, residual1, diff10, &wedge_sign,
                    &wedge_index, best_sse);
  }

  mbmi->interinter_comp.wedge_sign = wedge_sign;
  mbmi->interinter_comp.wedge_index = wedge_index;
  return rd;
}

static int64_t pick_interinter_seg(const AV1_COMP *const cpi,
                                   MACROBLOCK *const x, const BLOCK_SIZE bsize,
                                   const uint8_t *const p0,
                                   const uint8_t *const p1,
                                   const int16_t *const residual1,
                                   const int16_t *const diff10,
                                   uint64_t *best_sse) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  const int N = 1 << num_pels_log2_lookup[bsize];
  int rate;
  int64_t dist;
  DIFFWTD_MASK_TYPE cur_mask_type;
  int64_t best_rd = INT64_MAX;
  DIFFWTD_MASK_TYPE best_mask_type = 0;
  const int hbd = is_cur_buf_hbd(xd);
  const int bd_round = hbd ? (xd->bd - 8) * 2 : 0;
  DECLARE_ALIGNED(16, uint8_t, seg_mask[2 * MAX_SB_SQUARE]);
  uint8_t *tmp_mask[2] = { xd->seg_mask, seg_mask };
  // try each mask type and its inverse
  for (cur_mask_type = 0; cur_mask_type < DIFFWTD_MASK_TYPES; cur_mask_type++) {
    // build mask and inverse
    if (hbd)
      av1_build_compound_diffwtd_mask_highbd(
          tmp_mask[cur_mask_type], cur_mask_type, CONVERT_TO_BYTEPTR(p0), bw,
          CONVERT_TO_BYTEPTR(p1), bw, bh, bw, xd->bd);
    else
      av1_build_compound_diffwtd_mask(tmp_mask[cur_mask_type], cur_mask_type,
                                      p0, bw, p1, bw, bh, bw);

    // compute rd for mask
    uint64_t sse = av1_wedge_sse_from_residuals(residual1, diff10,
                                                tmp_mask[cur_mask_type], N);
    sse = ROUND_POWER_OF_TWO(sse, bd_round);

    model_rd_sse_fn[MODELRD_TYPE_MASKED_COMPOUND](cpi, x, bsize, 0, sse, N,
                                                  &rate, &dist);
    const int64_t rd0 = RDCOST(x->rdmult, rate, dist);

    if (rd0 < best_rd) {
      best_mask_type = cur_mask_type;
      best_rd = rd0;
      *best_sse = sse;
    }
  }
  mbmi->interinter_comp.mask_type = best_mask_type;
  if (best_mask_type == DIFFWTD_38_INV) {
    memcpy(xd->seg_mask, seg_mask, N * 2);
  }
  return best_rd;
}

static int64_t pick_interintra_wedge(const AV1_COMP *const cpi,
                                     const MACROBLOCK *const x,
                                     const BLOCK_SIZE bsize,
                                     const uint8_t *const p0,
                                     const uint8_t *const p1) {
  const MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(av1_is_wedge_used(bsize));
  assert(cpi->common.seq_params.enable_interintra_compound);

  const struct buf_2d *const src = &x->plane[0].src;
  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  DECLARE_ALIGNED(32, int16_t, residual1[MAX_SB_SQUARE]);  // src - pred1
  DECLARE_ALIGNED(32, int16_t, diff10[MAX_SB_SQUARE]);     // pred1 - pred0
#if CONFIG_AV1_HIGHBITDEPTH
  if (is_cur_buf_hbd(xd)) {
    aom_highbd_subtract_block(bh, bw, residual1, bw, src->buf, src->stride,
                              CONVERT_TO_BYTEPTR(p1), bw, xd->bd);
    aom_highbd_subtract_block(bh, bw, diff10, bw, CONVERT_TO_BYTEPTR(p1), bw,
                              CONVERT_TO_BYTEPTR(p0), bw, xd->bd);
  } else {
    aom_subtract_block(bh, bw, residual1, bw, src->buf, src->stride, p1, bw);
    aom_subtract_block(bh, bw, diff10, bw, p1, bw, p0, bw);
  }
#else
  aom_subtract_block(bh, bw, residual1, bw, src->buf, src->stride, p1, bw);
  aom_subtract_block(bh, bw, diff10, bw, p1, bw, p0, bw);
#endif
  int8_t wedge_index = -1;
  uint64_t sse;
  int64_t rd = pick_wedge_fixed_sign(cpi, x, bsize, residual1, diff10, 0,
                                     &wedge_index, &sse);

  mbmi->interintra_wedge_index = wedge_index;
  return rd;
}

static AOM_INLINE void get_inter_predictors_masked_compound(
    MACROBLOCK *x, const BLOCK_SIZE bsize, uint8_t **preds0, uint8_t **preds1,
    int16_t *residual1, int16_t *diff10, int *strides) {
  MACROBLOCKD *xd = &x->e_mbd;
  const int bw = block_size_wide[bsize];
  const int bh = block_size_high[bsize];
  // get inter predictors to use for masked compound modes
  av1_build_inter_predictors_for_planes_single_buf(xd, bsize, 0, 0, 0, preds0,
                                                   strides);
  av1_build_inter_predictors_for_planes_single_buf(xd, bsize, 0, 0, 1, preds1,
                                                   strides);
  const struct buf_2d *const src = &x->plane[0].src;
#if CONFIG_AV1_HIGHBITDEPTH
  if (is_cur_buf_hbd(xd)) {
    aom_highbd_subtract_block(bh, bw, residual1, bw, src->buf, src->stride,
                              CONVERT_TO_BYTEPTR(*preds1), bw, xd->bd);
    aom_highbd_subtract_block(bh, bw, diff10, bw, CONVERT_TO_BYTEPTR(*preds1),
                              bw, CONVERT_TO_BYTEPTR(*preds0), bw, xd->bd);
  } else {
    aom_subtract_block(bh, bw, residual1, bw, src->buf, src->stride, *preds1,
                       bw);
    aom_subtract_block(bh, bw, diff10, bw, *preds1, bw, *preds0, bw);
  }
#else
  aom_subtract_block(bh, bw, residual1, bw, src->buf, src->stride, *preds1, bw);
  aom_subtract_block(bh, bw, diff10, bw, *preds1, bw, *preds0, bw);
#endif
}

// Computes the rd cost for the given interintra mode and updates the best
static INLINE void compute_best_interintra_mode(
    const AV1_COMP *const cpi, MB_MODE_INFO *mbmi, MACROBLOCKD *xd,
    MACROBLOCK *const x, const int *const interintra_mode_cost,
    const BUFFER_SET *orig_dst, uint8_t *intrapred, const uint8_t *tmp_buf,
    INTERINTRA_MODE *best_interintra_mode, int64_t *best_interintra_rd,
    INTERINTRA_MODE interintra_mode, BLOCK_SIZE bsize) {
  const AV1_COMMON *const cm = &cpi->common;
  int rate, skip_txfm_sb;
  int64_t dist, skip_sse_sb;
  const int bw = block_size_wide[bsize];
  mbmi->interintra_mode = interintra_mode;
  int rmode = interintra_mode_cost[interintra_mode];
  av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                            intrapred, bw);
  av1_combine_interintra(xd, bsize, 0, tmp_buf, bw, intrapred, bw);
  model_rd_sb_fn[MODELRD_TYPE_INTERINTRA](cpi, bsize, x, xd, 0, 0, &rate, &dist,
                                          &skip_txfm_sb, &skip_sse_sb, NULL,
                                          NULL, NULL);
  int64_t rd = RDCOST(x->rdmult, rate + rmode, dist);
  if (rd < *best_interintra_rd) {
    *best_interintra_rd = rd;
    *best_interintra_mode = mbmi->interintra_mode;
  }
}

static int64_t estimate_yrd_for_sb(const AV1_COMP *const cpi, BLOCK_SIZE bs,
                                   MACROBLOCK *x, int64_t ref_best_rd,
                                   RD_STATS *rd_stats) {
  MACROBLOCKD *const xd = &x->e_mbd;
  if (ref_best_rd < 0) return INT64_MAX;
  av1_subtract_plane(x, bs, 0);
  x->rd_model = LOW_TXFM_RD;
  const int skip_trellis = (cpi->optimize_seg_arr[xd->mi[0]->segment_id] ==
                            NO_ESTIMATE_YRD_TRELLIS_OPT);
  const int64_t rd =
      av1_uniform_txfm_yrd(cpi, x, rd_stats, ref_best_rd, bs,
                           max_txsize_rect_lookup[bs], FTXS_NONE, skip_trellis);
  x->rd_model = FULL_TXFM_RD;
  if (rd != INT64_MAX) {
    const int skip_ctx = av1_get_skip_context(xd);
    if (rd_stats->skip) {
      const int s1 = x->skip_cost[skip_ctx][1];
      rd_stats->rate = s1;
    } else {
      const int s0 = x->skip_cost[skip_ctx][0];
      rd_stats->rate += s0;
    }
  }
  return rd;
}

// Computes the rd_threshold for smooth interintra rd search.
static AOM_INLINE int64_t compute_rd_thresh(MACROBLOCK *const x,
                                            int total_mode_rate,
                                            int64_t ref_best_rd) {
  const int64_t rd_thresh = get_rd_thresh_from_best_rd(
      ref_best_rd, (1 << INTER_INTRA_RD_THRESH_SHIFT),
      INTER_INTRA_RD_THRESH_SCALE);
  const int64_t mode_rd = RDCOST(x->rdmult, total_mode_rate, 0);
  return (rd_thresh - mode_rd);
}

// Computes the best wedge interintra mode
static AOM_INLINE int64_t compute_best_wedge_interintra(
    const AV1_COMP *const cpi, MB_MODE_INFO *mbmi, MACROBLOCKD *xd,
    MACROBLOCK *const x, const int *const interintra_mode_cost,
    const BUFFER_SET *orig_dst, uint8_t *intrapred_, uint8_t *tmp_buf_,
    int *best_mode, int *best_wedge_index, BLOCK_SIZE bsize) {
  const AV1_COMMON *const cm = &cpi->common;
  const int bw = block_size_wide[bsize];
  int64_t best_interintra_rd_wedge = INT64_MAX;
  int64_t best_total_rd = INT64_MAX;
  uint8_t *intrapred = get_buf_by_bd(xd, intrapred_);
  for (INTERINTRA_MODE mode = 0; mode < INTERINTRA_MODES; ++mode) {
    mbmi->interintra_mode = mode;
    av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                              intrapred, bw);
    int64_t rd = pick_interintra_wedge(cpi, x, bsize, intrapred_, tmp_buf_);
    const int rate_overhead =
        interintra_mode_cost[mode] +
        x->wedge_idx_cost[bsize][mbmi->interintra_wedge_index];
    const int64_t total_rd = rd + RDCOST(x->rdmult, rate_overhead, 0);
    if (total_rd < best_total_rd) {
      best_total_rd = total_rd;
      best_interintra_rd_wedge = rd;
      *best_mode = mbmi->interintra_mode;
      *best_wedge_index = mbmi->interintra_wedge_index;
    }
  }
  return best_interintra_rd_wedge;
}

int av1_handle_inter_intra_mode(const AV1_COMP *const cpi, MACROBLOCK *const x,
                                BLOCK_SIZE bsize, MB_MODE_INFO *mbmi,
                                HandleInterModeArgs *args, int64_t ref_best_rd,
                                int *rate_mv, int *tmp_rate2,
                                const BUFFER_SET *orig_dst) {
  const int try_smooth_interintra = cpi->oxcf.enable_smooth_interintra &&
                                    !cpi->sf.inter_sf.disable_smooth_interintra;
  const int is_wedge_used = av1_is_wedge_used(bsize);
  const int try_wedge_interintra =
      is_wedge_used && enable_wedge_interintra_search(x, cpi);
  if (!try_smooth_interintra && !try_wedge_interintra) return -1;

  const AV1_COMMON *const cm = &cpi->common;
  MACROBLOCKD *xd = &x->e_mbd;
  int64_t rd = INT64_MAX;
  const int bw = block_size_wide[bsize];
  DECLARE_ALIGNED(16, uint8_t, tmp_buf_[2 * MAX_INTERINTRA_SB_SQUARE]);
  DECLARE_ALIGNED(16, uint8_t, intrapred_[2 * MAX_INTERINTRA_SB_SQUARE]);
  uint8_t *tmp_buf = get_buf_by_bd(xd, tmp_buf_);
  uint8_t *intrapred = get_buf_by_bd(xd, intrapred_);
  const int *const interintra_mode_cost =
      x->interintra_mode_cost[size_group_lookup[bsize]];
  const int mi_row = xd->mi_row;
  const int mi_col = xd->mi_col;

  // Single reference inter prediction
  mbmi->ref_frame[1] = NONE_FRAME;
  xd->plane[0].dst.buf = tmp_buf;
  xd->plane[0].dst.stride = bw;
  av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, NULL, bsize,
                                AOM_PLANE_Y, AOM_PLANE_Y);
  const int num_planes = av1_num_planes(cm);

  // Restore the buffers for intra prediction
  restore_dst_buf(xd, *orig_dst, num_planes);
  mbmi->ref_frame[1] = INTRA_FRAME;
  INTERINTRA_MODE best_interintra_mode =
      args->inter_intra_mode[mbmi->ref_frame[0]];

  // Compute smooth_interintra
  int64_t best_interintra_rd_nowedge = INT64_MAX;
  int best_mode_rate = INT_MAX;
  if (try_smooth_interintra) {
    mbmi->use_wedge_interintra = 0;
    int interintra_mode_reuse = 1;
    if (cpi->sf.inter_sf.reuse_inter_intra_mode == 0 ||
        best_interintra_mode == INTERINTRA_MODES) {
      interintra_mode_reuse = 0;
      int64_t best_interintra_rd = INT64_MAX;
      for (INTERINTRA_MODE cur_mode = 0; cur_mode < INTERINTRA_MODES;
           ++cur_mode) {
        if ((!cpi->oxcf.enable_smooth_intra ||
             cpi->sf.intra_sf.disable_smooth_intra) &&
            cur_mode == II_SMOOTH_PRED)
          continue;
        compute_best_interintra_mode(cpi, mbmi, xd, x, interintra_mode_cost,
                                     orig_dst, intrapred, tmp_buf,
                                     &best_interintra_mode, &best_interintra_rd,
                                     cur_mode, bsize);
      }
      args->inter_intra_mode[mbmi->ref_frame[0]] = best_interintra_mode;
    }
    assert(IMPLIES(!cpi->oxcf.enable_smooth_interintra ||
                       cpi->sf.inter_sf.disable_smooth_interintra,
                   best_interintra_mode != II_SMOOTH_PRED));
    // Recompute prediction if required
    if (interintra_mode_reuse || best_interintra_mode != INTERINTRA_MODES - 1) {
      mbmi->interintra_mode = best_interintra_mode;
      av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                                intrapred, bw);
      av1_combine_interintra(xd, bsize, 0, tmp_buf, bw, intrapred, bw);
    }

    // Compute rd cost for best smooth_interintra
    RD_STATS rd_stats;
    const int rmode = interintra_mode_cost[best_interintra_mode] +
                      (is_wedge_used ? x->wedge_interintra_cost[bsize][0] : 0);
    const int total_mode_rate = rmode + *rate_mv;
    const int64_t rd_thresh =
        compute_rd_thresh(x, total_mode_rate, ref_best_rd);
    rd = estimate_yrd_for_sb(cpi, bsize, x, rd_thresh, &rd_stats);
    if (rd != INT64_MAX) {
      rd = RDCOST(x->rdmult, total_mode_rate + rd_stats.rate, rd_stats.dist);
    } else {
      return -1;
    }
    best_interintra_rd_nowedge = rd;
    best_mode_rate = rmode;
    // Return early if best_interintra_rd_nowedge not good enough
    if (ref_best_rd < INT64_MAX &&
        (best_interintra_rd_nowedge >> INTER_INTRA_RD_THRESH_SHIFT) *
                INTER_INTRA_RD_THRESH_SCALE >
            ref_best_rd) {
      return -1;
    }
  }

  // Compute wedge interintra
  int64_t best_interintra_rd_wedge = INT64_MAX;
  if (try_wedge_interintra) {
    mbmi->use_wedge_interintra = 1;
    if (!cpi->sf.inter_sf.fast_interintra_wedge_search) {
      // Exhaustive search of all wedge and mode combinations.
      int best_mode = 0;
      int best_wedge_index = 0;
      best_interintra_rd_wedge = compute_best_wedge_interintra(
          cpi, mbmi, xd, x, interintra_mode_cost, orig_dst, intrapred_,
          tmp_buf_, &best_mode, &best_wedge_index, bsize);
      mbmi->interintra_mode = best_mode;
      mbmi->interintra_wedge_index = best_wedge_index;
      if (best_mode != INTERINTRA_MODES - 1) {
        av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                                  intrapred, bw);
      }
    } else if (!try_smooth_interintra) {
      if (best_interintra_mode == INTERINTRA_MODES) {
        mbmi->interintra_mode = INTERINTRA_MODES - 1;
        best_interintra_mode = INTERINTRA_MODES - 1;
        av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                                  intrapred, bw);
        // Pick wedge mask based on INTERINTRA_MODES - 1
        best_interintra_rd_wedge =
            pick_interintra_wedge(cpi, x, bsize, intrapred_, tmp_buf_);
        // Find the best interintra mode for the chosen wedge mask
        for (INTERINTRA_MODE cur_mode = 0; cur_mode < INTERINTRA_MODES;
             ++cur_mode) {
          compute_best_interintra_mode(
              cpi, mbmi, xd, x, interintra_mode_cost, orig_dst, intrapred,
              tmp_buf, &best_interintra_mode, &best_interintra_rd_wedge,
              cur_mode, bsize);
        }
        args->inter_intra_mode[mbmi->ref_frame[0]] = best_interintra_mode;
        mbmi->interintra_mode = best_interintra_mode;

        // Recompute prediction if required
        if (best_interintra_mode != INTERINTRA_MODES - 1) {
          av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                                    intrapred, bw);
        }
      } else {
        // Pick wedge mask for the best interintra mode (reused)
        mbmi->interintra_mode = best_interintra_mode;
        av1_build_intra_predictors_for_interintra(cm, xd, bsize, 0, orig_dst,
                                                  intrapred, bw);
        best_interintra_rd_wedge =
            pick_interintra_wedge(cpi, x, bsize, intrapred_, tmp_buf_);
      }
    } else {
      // Pick wedge mask for the best interintra mode from smooth_interintra
      best_interintra_rd_wedge =
          pick_interintra_wedge(cpi, x, bsize, intrapred_, tmp_buf_);
    }

    const int rate_overhead =
        interintra_mode_cost[mbmi->interintra_mode] +
        x->wedge_idx_cost[bsize][mbmi->interintra_wedge_index] +
        x->wedge_interintra_cost[bsize][1];
    best_interintra_rd_wedge += RDCOST(x->rdmult, rate_overhead + *rate_mv, 0);

    const int_mv mv0 = mbmi->mv[0];
    int_mv tmp_mv = mv0;
    rd = INT64_MAX;
    int tmp_rate_mv = 0;
    // Refine motion vector for NEWMV case.
    if (have_newmv_in_inter_mode(mbmi->mode)) {
      int rate_sum, skip_txfm_sb;
      int64_t dist_sum, skip_sse_sb;
      // get negative of mask
      const uint8_t *mask =
          av1_get_contiguous_soft_mask(mbmi->interintra_wedge_index, 1, bsize);
      av1_compound_single_motion_search(cpi, x, bsize, &tmp_mv.as_mv, intrapred,
                                        mask, bw, &tmp_rate_mv, 0);
      if (mbmi->mv[0].as_int != tmp_mv.as_int) {
        mbmi->mv[0].as_int = tmp_mv.as_int;
        // Set ref_frame[1] to NONE_FRAME temporarily so that the intra
        // predictor is not calculated again in av1_enc_build_inter_predictor().
        mbmi->ref_frame[1] = NONE_FRAME;
        av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, orig_dst, bsize,
                                      AOM_PLANE_Y, AOM_PLANE_Y);
        mbmi->ref_frame[1] = INTRA_FRAME;
        av1_combine_interintra(xd, bsize, 0, xd->plane[AOM_PLANE_Y].dst.buf,
                               xd->plane[AOM_PLANE_Y].dst.stride, intrapred,
                               bw);
        model_rd_sb_fn[MODELRD_TYPE_MASKED_COMPOUND](
            cpi, bsize, x, xd, 0, 0, &rate_sum, &dist_sum, &skip_txfm_sb,
            &skip_sse_sb, NULL, NULL, NULL);
        rd =
            RDCOST(x->rdmult, tmp_rate_mv + rate_overhead + rate_sum, dist_sum);
      }
    }
    if (rd >= best_interintra_rd_wedge) {
      tmp_mv.as_int = mv0.as_int;
      tmp_rate_mv = *rate_mv;
      av1_combine_interintra(xd, bsize, 0, tmp_buf, bw, intrapred, bw);
    }
    // Evaluate closer to true rd
    RD_STATS rd_stats;
    const int64_t mode_rd = RDCOST(x->rdmult, rate_overhead + tmp_rate_mv, 0);
    const int64_t tmp_rd_thresh = best_interintra_rd_nowedge - mode_rd;
    rd = estimate_yrd_for_sb(cpi, bsize, x, tmp_rd_thresh, &rd_stats);
    if (rd != INT64_MAX) {
      rd = RDCOST(x->rdmult, rate_overhead + tmp_rate_mv + rd_stats.rate,
                  rd_stats.dist);
    } else {
      if (best_interintra_rd_nowedge == INT64_MAX) return -1;
    }
    best_interintra_rd_wedge = rd;
    if (best_interintra_rd_wedge < best_interintra_rd_nowedge) {
      mbmi->mv[0].as_int = tmp_mv.as_int;
      *tmp_rate2 += tmp_rate_mv - *rate_mv;
      *rate_mv = tmp_rate_mv;
      best_mode_rate = rate_overhead;
    } else {
      mbmi->use_wedge_interintra = 0;
      mbmi->interintra_mode = best_interintra_mode;
      mbmi->mv[0].as_int = mv0.as_int;
      av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, orig_dst, bsize,
                                    AOM_PLANE_Y, AOM_PLANE_Y);
    }
  }

  if (best_interintra_rd_nowedge == INT64_MAX &&
      best_interintra_rd_wedge == INT64_MAX) {
    return -1;
  }

  *tmp_rate2 += best_mode_rate;

  if (num_planes > 1) {
    av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, orig_dst, bsize,
                                  AOM_PLANE_U, num_planes - 1);
  }
  return 0;
}

static void alloc_compound_type_rd_buffers_no_check(
    CompoundTypeRdBuffers *const bufs) {
  bufs->pred0 =
      (uint8_t *)aom_memalign(16, 2 * MAX_SB_SQUARE * sizeof(*bufs->pred0));
  bufs->pred1 =
      (uint8_t *)aom_memalign(16, 2 * MAX_SB_SQUARE * sizeof(*bufs->pred1));
  bufs->residual1 =
      (int16_t *)aom_memalign(32, MAX_SB_SQUARE * sizeof(*bufs->residual1));
  bufs->diff10 =
      (int16_t *)aom_memalign(32, MAX_SB_SQUARE * sizeof(*bufs->diff10));
  bufs->tmp_best_mask_buf = (uint8_t *)aom_malloc(
      2 * MAX_SB_SQUARE * sizeof(*bufs->tmp_best_mask_buf));
}

// Computes the valid compound_types to be evaluated
static INLINE int compute_valid_comp_types(
    MACROBLOCK *x, const AV1_COMP *const cpi, int *try_average_and_distwtd_comp,
    BLOCK_SIZE bsize, int masked_compound_used, int mode_search_mask,
    COMPOUND_TYPE *valid_comp_types) {
  const AV1_COMMON *cm = &cpi->common;
  int valid_type_count = 0;
  int comp_type, valid_check;
  int8_t enable_masked_type[MASKED_COMPOUND_TYPES] = { 0, 0 };

  const int try_average_comp = (mode_search_mask & (1 << COMPOUND_AVERAGE));
  const int try_distwtd_comp =
      ((mode_search_mask & (1 << COMPOUND_DISTWTD)) &&
       cm->seq_params.order_hint_info.enable_dist_wtd_comp == 1 &&
       cpi->sf.inter_sf.use_dist_wtd_comp_flag != DIST_WTD_COMP_DISABLED);
  *try_average_and_distwtd_comp = try_average_comp && try_distwtd_comp;

  // Check if COMPOUND_AVERAGE and COMPOUND_DISTWTD are valid cases
  for (comp_type = COMPOUND_AVERAGE; comp_type <= COMPOUND_DISTWTD;
       comp_type++) {
    valid_check =
        (comp_type == COMPOUND_AVERAGE) ? try_average_comp : try_distwtd_comp;
    if (!*try_average_and_distwtd_comp && valid_check &&
        is_interinter_compound_used(comp_type, bsize))
      valid_comp_types[valid_type_count++] = comp_type;
  }
  // Check if COMPOUND_WEDGE and COMPOUND_DIFFWTD are valid cases
  if (masked_compound_used) {
    // enable_masked_type[0] corresponds to COMPOUND_WEDGE
    // enable_masked_type[1] corresponds to COMPOUND_DIFFWTD
    enable_masked_type[0] = enable_wedge_interinter_search(x, cpi);
    enable_masked_type[1] = cpi->oxcf.enable_diff_wtd_comp;
    for (comp_type = COMPOUND_WEDGE; comp_type <= COMPOUND_DIFFWTD;
         comp_type++) {
      if ((mode_search_mask & (1 << comp_type)) &&
          is_interinter_compound_used(comp_type, bsize) &&
          enable_masked_type[comp_type - COMPOUND_WEDGE])
        valid_comp_types[valid_type_count++] = comp_type;
    }
  }
  return valid_type_count;
}

// Calculates the cost for compound type mask
static INLINE void calc_masked_type_cost(MACROBLOCK *x, BLOCK_SIZE bsize,
                                         int comp_group_idx_ctx,
                                         int comp_index_ctx,
                                         int masked_compound_used,
                                         int *masked_type_cost) {
  av1_zero_array(masked_type_cost, COMPOUND_TYPES);
  // Account for group index cost when wedge and/or diffwtd prediction are
  // enabled
  if (masked_compound_used) {
    // Compound group index of average and distwtd is 0
    // Compound group index of wedge and diffwtd is 1
    masked_type_cost[COMPOUND_AVERAGE] +=
        x->comp_group_idx_cost[comp_group_idx_ctx][0];
    masked_type_cost[COMPOUND_DISTWTD] += masked_type_cost[COMPOUND_AVERAGE];
    masked_type_cost[COMPOUND_WEDGE] +=
        x->comp_group_idx_cost[comp_group_idx_ctx][1];
    masked_type_cost[COMPOUND_DIFFWTD] += masked_type_cost[COMPOUND_WEDGE];
  }

  // Compute the cost to signal compound index/type
  masked_type_cost[COMPOUND_AVERAGE] += x->comp_idx_cost[comp_index_ctx][1];
  masked_type_cost[COMPOUND_DISTWTD] += x->comp_idx_cost[comp_index_ctx][0];
  masked_type_cost[COMPOUND_WEDGE] += x->compound_type_cost[bsize][0];
  masked_type_cost[COMPOUND_DIFFWTD] += x->compound_type_cost[bsize][1];
}

// Updates mbmi structure with the relevant compound type info
static INLINE void update_mbmi_for_compound_type(MB_MODE_INFO *mbmi,
                                                 COMPOUND_TYPE cur_type) {
  mbmi->interinter_comp.type = cur_type;
  mbmi->comp_group_idx = (cur_type >= COMPOUND_WEDGE);
  mbmi->compound_idx = (cur_type != COMPOUND_DISTWTD);
}

// When match is found, populate the compound type data
// and calculate the rd cost using the stored stats and
// update the mbmi appropriately.
static INLINE int populate_reuse_comp_type_data(
    const MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BEST_COMP_TYPE_STATS *best_type_stats, int_mv *cur_mv, int32_t *comp_rate,
    int64_t *comp_dist, int *comp_rs2, int *rate_mv, int64_t *rd,
    int match_index) {
  const int winner_comp_type =
      x->comp_rd_stats[match_index].interinter_comp.type;
  if (comp_rate[winner_comp_type] == INT_MAX)
    return best_type_stats->best_compmode_interinter_cost;
  update_mbmi_for_compound_type(mbmi, winner_comp_type);
  mbmi->interinter_comp = x->comp_rd_stats[match_index].interinter_comp;
  *rd = RDCOST(
      x->rdmult,
      comp_rs2[winner_comp_type] + *rate_mv + comp_rate[winner_comp_type],
      comp_dist[winner_comp_type]);
  mbmi->mv[0].as_int = cur_mv[0].as_int;
  mbmi->mv[1].as_int = cur_mv[1].as_int;
  return comp_rs2[winner_comp_type];
}

// Updates rd cost and relevant compound type data for the best compound type
static INLINE void update_best_info(const MB_MODE_INFO *const mbmi, int64_t *rd,
                                    BEST_COMP_TYPE_STATS *best_type_stats,
                                    int64_t best_rd_cur,
                                    int64_t comp_model_rd_cur, int rs2) {
  *rd = best_rd_cur;
  best_type_stats->comp_best_model_rd = comp_model_rd_cur;
  best_type_stats->best_compound_data = mbmi->interinter_comp;
  best_type_stats->best_compmode_interinter_cost = rs2;
}

// Updates best_mv for masked compound types
static INLINE void update_mask_best_mv(const MB_MODE_INFO *const mbmi,
                                       int_mv *best_mv, int_mv *cur_mv,
                                       const COMPOUND_TYPE cur_type,
                                       int *best_tmp_rate_mv, int tmp_rate_mv,
                                       const SPEED_FEATURES *const sf) {
  if (cur_type == COMPOUND_WEDGE ||
      (sf->inter_sf.enable_interinter_diffwtd_newmv_search &&
       cur_type == COMPOUND_DIFFWTD)) {
    *best_tmp_rate_mv = tmp_rate_mv;
    best_mv[0].as_int = mbmi->mv[0].as_int;
    best_mv[1].as_int = mbmi->mv[1].as_int;
  } else {
    best_mv[0].as_int = cur_mv[0].as_int;
    best_mv[1].as_int = cur_mv[1].as_int;
  }
}

// Choose the better of the two COMPOUND_AVERAGE,
// COMPOUND_DISTWTD based on modeled cost
static int find_best_avg_distwtd_comp_type(MACROBLOCK *x, int *comp_model_rate,
                                           int64_t *comp_model_dist,
                                           int rate_mv, int64_t *best_rd) {
  int64_t est_rd[2];
  est_rd[COMPOUND_AVERAGE] =
      RDCOST(x->rdmult, comp_model_rate[COMPOUND_AVERAGE] + rate_mv,
             comp_model_dist[COMPOUND_AVERAGE]);
  est_rd[COMPOUND_DISTWTD] =
      RDCOST(x->rdmult, comp_model_rate[COMPOUND_DISTWTD] + rate_mv,
             comp_model_dist[COMPOUND_DISTWTD]);
  int best_type = (est_rd[COMPOUND_AVERAGE] <= est_rd[COMPOUND_DISTWTD])
                      ? COMPOUND_AVERAGE
                      : COMPOUND_DISTWTD;
  *best_rd = est_rd[best_type];
  return best_type;
}

static INLINE void save_comp_rd_search_stat(
    MACROBLOCK *x, const MB_MODE_INFO *const mbmi, const int32_t *comp_rate,
    const int64_t *comp_dist, const int32_t *comp_model_rate,
    const int64_t *comp_model_dist, const int_mv *cur_mv, const int *comp_rs2) {
  const int offset = x->comp_rd_stats_idx;
  if (offset < MAX_COMP_RD_STATS) {
    COMP_RD_STATS *const rd_stats = x->comp_rd_stats + offset;
    memcpy(rd_stats->rate, comp_rate, sizeof(rd_stats->rate));
    memcpy(rd_stats->dist, comp_dist, sizeof(rd_stats->dist));
    memcpy(rd_stats->model_rate, comp_model_rate, sizeof(rd_stats->model_rate));
    memcpy(rd_stats->model_dist, comp_model_dist, sizeof(rd_stats->model_dist));
    memcpy(rd_stats->comp_rs2, comp_rs2, sizeof(rd_stats->comp_rs2));
    memcpy(rd_stats->mv, cur_mv, sizeof(rd_stats->mv));
    memcpy(rd_stats->ref_frames, mbmi->ref_frame, sizeof(rd_stats->ref_frames));
    rd_stats->mode = mbmi->mode;
    rd_stats->filter = mbmi->interp_filters;
    rd_stats->ref_mv_idx = mbmi->ref_mv_idx;
    const MACROBLOCKD *const xd = &x->e_mbd;
    for (int i = 0; i < 2; ++i) {
      const WarpedMotionParams *const wm =
          &xd->global_motion[mbmi->ref_frame[i]];
      rd_stats->is_global[i] = is_global_mv_block(mbmi, wm->wmtype);
    }
    memcpy(&rd_stats->interinter_comp, &mbmi->interinter_comp,
           sizeof(rd_stats->interinter_comp));
    ++x->comp_rd_stats_idx;
  }
}

static INLINE int get_interinter_compound_mask_rate(
    const MACROBLOCK *const x, const MB_MODE_INFO *const mbmi) {
  const COMPOUND_TYPE compound_type = mbmi->interinter_comp.type;
  // This function will be called only for COMPOUND_WEDGE and COMPOUND_DIFFWTD
  if (compound_type == COMPOUND_WEDGE) {
    return av1_is_wedge_used(mbmi->sb_type)
               ? av1_cost_literal(1) +
                     x->wedge_idx_cost[mbmi->sb_type]
                                      [mbmi->interinter_comp.wedge_index]
               : 0;
  } else {
    assert(compound_type == COMPOUND_DIFFWTD);
    return av1_cost_literal(1);
  }
}

// Takes a backup of rate, distortion and model_rd for future reuse
static INLINE void backup_stats(COMPOUND_TYPE cur_type, int32_t *comp_rate,
                                int64_t *comp_dist, int32_t *comp_model_rate,
                                int64_t *comp_model_dist, int rate_sum,
                                int64_t dist_sum, RD_STATS *rd_stats,
                                int *comp_rs2, int rs2) {
  comp_rate[cur_type] = rd_stats->rate;
  comp_dist[cur_type] = rd_stats->dist;
  comp_model_rate[cur_type] = rate_sum;
  comp_model_dist[cur_type] = dist_sum;
  comp_rs2[cur_type] = rs2;
}

static int64_t masked_compound_type_rd(
    const AV1_COMP *const cpi, MACROBLOCK *x, const int_mv *const cur_mv,
    const BLOCK_SIZE bsize, const PREDICTION_MODE this_mode, int *rs2,
    int rate_mv, const BUFFER_SET *ctx, int *out_rate_mv, uint8_t **preds0,
    uint8_t **preds1, int16_t *residual1, int16_t *diff10, int *strides,
    int mode_rate, int64_t rd_thresh, int *calc_pred_masked_compound,
    int32_t *comp_rate, int64_t *comp_dist, int32_t *comp_model_rate,
    int64_t *comp_model_dist, const int64_t comp_best_model_rd,
    int64_t *const comp_model_rd_cur, int *comp_rs2, int64_t ref_skip_rd) {
  const AV1_COMMON *const cm = &cpi->common;
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  int64_t best_rd_cur = INT64_MAX;
  int64_t rd = INT64_MAX;
  const COMPOUND_TYPE compound_type = mbmi->interinter_comp.type;
  // This function will be called only for COMPOUND_WEDGE and COMPOUND_DIFFWTD
  assert(compound_type == COMPOUND_WEDGE || compound_type == COMPOUND_DIFFWTD);
  int rate_sum, tmp_skip_txfm_sb;
  int64_t dist_sum, tmp_skip_sse_sb;
  pick_interinter_mask_type pick_interinter_mask[2] = { pick_interinter_wedge,
                                                        pick_interinter_seg };

  // TODO(any): Save pred and mask calculation as well into records. However
  // this may increase memory requirements as compound segment mask needs to be
  // stored in each record.
  if (*calc_pred_masked_compound) {
    get_inter_predictors_masked_compound(x, bsize, preds0, preds1, residual1,
                                         diff10, strides);
    *calc_pred_masked_compound = 0;
  }
  if (cpi->sf.inter_sf.prune_wedge_pred_diff_based &&
      compound_type == COMPOUND_WEDGE) {
    unsigned int sse;
    if (is_cur_buf_hbd(xd))
      (void)cpi->fn_ptr[bsize].vf(CONVERT_TO_BYTEPTR(*preds0), *strides,
                                  CONVERT_TO_BYTEPTR(*preds1), *strides, &sse);
    else
      (void)cpi->fn_ptr[bsize].vf(*preds0, *strides, *preds1, *strides, &sse);
    const unsigned int mse =
        ROUND_POWER_OF_TWO(sse, num_pels_log2_lookup[bsize]);
    // If two predictors are very similar, skip wedge compound mode search
    if (mse < 8 || (!have_newmv_in_inter_mode(this_mode) && mse < 64)) {
      *comp_model_rd_cur = INT64_MAX;
      return INT64_MAX;
    }
  }
  // Function pointer to pick the appropriate mask
  // compound_type == COMPOUND_WEDGE, calls pick_interinter_wedge()
  // compound_type == COMPOUND_DIFFWTD, calls pick_interinter_seg()
  uint64_t cur_sse = UINT64_MAX;
  best_rd_cur = pick_interinter_mask[compound_type - COMPOUND_WEDGE](
      cpi, x, bsize, *preds0, *preds1, residual1, diff10, &cur_sse);
  *rs2 += get_interinter_compound_mask_rate(x, mbmi);
  best_rd_cur += RDCOST(x->rdmult, *rs2 + rate_mv, 0);
  assert(cur_sse != UINT64_MAX);
  int64_t skip_rd_cur = RDCOST(x->rdmult, *rs2 + rate_mv, (cur_sse << 4));

  // Although the true rate_mv might be different after motion search, but it
  // is unlikely to be the best mode considering the transform rd cost and other
  // mode overhead cost
  int64_t mode_rd = RDCOST(x->rdmult, *rs2 + mode_rate, 0);
  if (mode_rd > rd_thresh) {
    *comp_model_rd_cur = INT64_MAX;
    return INT64_MAX;
  }

  // Check if the mode is good enough based on skip rd
  // TODO(nithya): Handle wedge_newmv_search if extending for lower speed
  // setting
  if (cpi->sf.inter_sf.txfm_rd_gate_level) {
    int eval_txfm = check_txfm_eval(x, bsize, ref_skip_rd, skip_rd_cur,
                                    cpi->sf.inter_sf.txfm_rd_gate_level, 1);
    if (!eval_txfm) {
      *comp_model_rd_cur = INT64_MAX;
      return INT64_MAX;
    }
  }

  // Compute cost if matching record not found, else, reuse data
  if (comp_rate[compound_type] == INT_MAX) {
    // Check whether new MV search for wedge is to be done
    int wedge_newmv_search =
        have_newmv_in_inter_mode(this_mode) &&
        (compound_type == COMPOUND_WEDGE) &&
        (!cpi->sf.inter_sf.disable_interinter_wedge_newmv_search);
    int diffwtd_newmv_search =
        cpi->sf.inter_sf.enable_interinter_diffwtd_newmv_search &&
        compound_type == COMPOUND_DIFFWTD &&
        have_newmv_in_inter_mode(this_mode);

    // Search for new MV if needed and build predictor
    if (wedge_newmv_search) {
      *out_rate_mv = av1_interinter_compound_motion_search(cpi, x, cur_mv,
                                                           bsize, this_mode);
      const int mi_row = xd->mi_row;
      const int mi_col = xd->mi_col;
      av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, ctx, bsize,
                                    AOM_PLANE_Y, AOM_PLANE_Y);
    } else if (diffwtd_newmv_search) {
      *out_rate_mv = av1_interinter_compound_motion_search(cpi, x, cur_mv,
                                                           bsize, this_mode);
      // we need to update the mask according to the new motion vector
      CompoundTypeRdBuffers tmp_buf;
      int64_t tmp_rd = INT64_MAX;
      alloc_compound_type_rd_buffers_no_check(&tmp_buf);

      uint8_t *tmp_preds0[1] = { tmp_buf.pred0 };
      uint8_t *tmp_preds1[1] = { tmp_buf.pred1 };

      get_inter_predictors_masked_compound(x, bsize, tmp_preds0, tmp_preds1,
                                           tmp_buf.residual1, tmp_buf.diff10,
                                           strides);

      tmp_rd = pick_interinter_mask[compound_type - COMPOUND_WEDGE](
          cpi, x, bsize, *tmp_preds0, *tmp_preds1, tmp_buf.residual1,
          tmp_buf.diff10, &cur_sse);
      // we can reuse rs2 here
      tmp_rd += RDCOST(x->rdmult, *rs2 + *out_rate_mv, 0);

      if (tmp_rd >= best_rd_cur) {
        // restore the motion vector
        mbmi->mv[0].as_int = cur_mv[0].as_int;
        mbmi->mv[1].as_int = cur_mv[1].as_int;
        *out_rate_mv = rate_mv;
        av1_build_wedge_inter_predictor_from_buf(xd, bsize, 0, 0, preds0,
                                                 strides, preds1, strides);
      } else {
        // build the final prediciton using the updated mv
        av1_build_wedge_inter_predictor_from_buf(xd, bsize, 0, 0, tmp_preds0,
                                                 strides, tmp_preds1, strides);
      }
      av1_release_compound_type_rd_buffers(&tmp_buf);
    } else {
      *out_rate_mv = rate_mv;
      av1_build_wedge_inter_predictor_from_buf(xd, bsize, 0, 0, preds0, strides,
                                               preds1, strides);
    }
    // Get the RD cost from model RD
    model_rd_sb_fn[MODELRD_TYPE_MASKED_COMPOUND](
        cpi, bsize, x, xd, 0, 0, &rate_sum, &dist_sum, &tmp_skip_txfm_sb,
        &tmp_skip_sse_sb, NULL, NULL, NULL);
    rd = RDCOST(x->rdmult, *rs2 + *out_rate_mv + rate_sum, dist_sum);
    *comp_model_rd_cur = rd;
    // Override with best if current is worse than best for new MV
    if (wedge_newmv_search) {
      if (rd >= best_rd_cur) {
        mbmi->mv[0].as_int = cur_mv[0].as_int;
        mbmi->mv[1].as_int = cur_mv[1].as_int;
        *out_rate_mv = rate_mv;
        av1_build_wedge_inter_predictor_from_buf(xd, bsize, 0, 0, preds0,
                                                 strides, preds1, strides);
        *comp_model_rd_cur = best_rd_cur;
      }
    }
    if (cpi->sf.inter_sf.prune_comp_type_by_model_rd &&
        (*comp_model_rd_cur > comp_best_model_rd) &&
        comp_best_model_rd != INT64_MAX) {
      *comp_model_rd_cur = INT64_MAX;
      return INT64_MAX;
    }
    // Compute RD cost for the current type
    RD_STATS rd_stats;
    const int64_t tmp_mode_rd = RDCOST(x->rdmult, *rs2 + *out_rate_mv, 0);
    const int64_t tmp_rd_thresh = rd_thresh - tmp_mode_rd;
    rd = estimate_yrd_for_sb(cpi, bsize, x, tmp_rd_thresh, &rd_stats);
    if (rd != INT64_MAX) {
      rd =
          RDCOST(x->rdmult, *rs2 + *out_rate_mv + rd_stats.rate, rd_stats.dist);
      // Backup rate and distortion for future reuse
      backup_stats(compound_type, comp_rate, comp_dist, comp_model_rate,
                   comp_model_dist, rate_sum, dist_sum, &rd_stats, comp_rs2,
                   *rs2);
    }
  } else {
    // Reuse data as matching record is found
    assert(comp_dist[compound_type] != INT64_MAX);
    // When disable_interinter_wedge_newmv_search is set, motion refinement is
    // disabled. Hence rate and distortion can be reused in this case as well
    assert(IMPLIES(have_newmv_in_inter_mode(this_mode),
                   cpi->sf.inter_sf.disable_interinter_wedge_newmv_search));
    assert(mbmi->mv[0].as_int == cur_mv[0].as_int);
    assert(mbmi->mv[1].as_int == cur_mv[1].as_int);
    *out_rate_mv = rate_mv;
    // Calculate RD cost based on stored stats
    rd = RDCOST(x->rdmult, *rs2 + *out_rate_mv + comp_rate[compound_type],
                comp_dist[compound_type]);
    // Recalculate model rdcost with the updated rate
    *comp_model_rd_cur =
        RDCOST(x->rdmult, *rs2 + *out_rate_mv + comp_model_rate[compound_type],
               comp_model_dist[compound_type]);
  }
  return rd;
}

// scaling values to be used for gating wedge/compound segment based on best
// approximate rd
static int comp_type_rd_threshold_mul[3] = { 1, 11, 12 };
static int comp_type_rd_threshold_div[3] = { 3, 16, 16 };

int av1_compound_type_rd(const AV1_COMP *const cpi, MACROBLOCK *x,
                         BLOCK_SIZE bsize, int_mv *cur_mv, int mode_search_mask,
                         int masked_compound_used, const BUFFER_SET *orig_dst,
                         const BUFFER_SET *tmp_dst,
                         const CompoundTypeRdBuffers *buffers, int *rate_mv,
                         int64_t *rd, RD_STATS *rd_stats, int64_t ref_best_rd,
                         int64_t ref_skip_rd, int *is_luma_interp_done,
                         int64_t rd_thresh) {
  const AV1_COMMON *cm = &cpi->common;
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  const PREDICTION_MODE this_mode = mbmi->mode;
  const int bw = block_size_wide[bsize];
  int rs2;
  int_mv best_mv[2];
  int best_tmp_rate_mv = *rate_mv;
  BEST_COMP_TYPE_STATS best_type_stats;
  // Initializing BEST_COMP_TYPE_STATS
  best_type_stats.best_compound_data.type = COMPOUND_AVERAGE;
  best_type_stats.best_compmode_interinter_cost = 0;
  best_type_stats.comp_best_model_rd = INT64_MAX;

  uint8_t *preds0[1] = { buffers->pred0 };
  uint8_t *preds1[1] = { buffers->pred1 };
  int strides[1] = { bw };
  int tmp_rate_mv;
  const int num_pix = 1 << num_pels_log2_lookup[bsize];
  const int mask_len = 2 * num_pix * sizeof(uint8_t);
  COMPOUND_TYPE cur_type;
  // Local array to store the mask cost for different compound types
  int masked_type_cost[COMPOUND_TYPES];

  int calc_pred_masked_compound = 1;
  int64_t comp_dist[COMPOUND_TYPES] = { INT64_MAX, INT64_MAX, INT64_MAX,
                                        INT64_MAX };
  int32_t comp_rate[COMPOUND_TYPES] = { INT_MAX, INT_MAX, INT_MAX, INT_MAX };
  int comp_rs2[COMPOUND_TYPES] = { INT_MAX, INT_MAX, INT_MAX, INT_MAX };
  int32_t comp_model_rate[COMPOUND_TYPES] = { INT_MAX, INT_MAX, INT_MAX,
                                              INT_MAX };
  int64_t comp_model_dist[COMPOUND_TYPES] = { INT64_MAX, INT64_MAX, INT64_MAX,
                                              INT64_MAX };
  int match_index = 0;
  const int match_found =
      find_comp_rd_in_stats(cpi, x, mbmi, comp_rate, comp_dist, comp_model_rate,
                            comp_model_dist, comp_rs2, &match_index);
  best_mv[0].as_int = cur_mv[0].as_int;
  best_mv[1].as_int = cur_mv[1].as_int;
  *rd = INT64_MAX;
  int rate_sum, tmp_skip_txfm_sb;
  int64_t dist_sum, tmp_skip_sse_sb;

  // Local array to store the valid compound types to be evaluated in the core
  // loop
  COMPOUND_TYPE valid_comp_types[COMPOUND_TYPES] = {
    COMPOUND_AVERAGE, COMPOUND_DISTWTD, COMPOUND_WEDGE, COMPOUND_DIFFWTD
  };
  int valid_type_count = 0;
  int try_average_and_distwtd_comp = 0;
  // compute_valid_comp_types() returns the number of valid compound types to be
  // evaluated and populates the same in the local array valid_comp_types[].
  // It also sets the flag 'try_average_and_distwtd_comp'
  valid_type_count = compute_valid_comp_types(
      x, cpi, &try_average_and_distwtd_comp, bsize, masked_compound_used,
      mode_search_mask, valid_comp_types);

  // The following context indices are independent of compound type
  const int comp_group_idx_ctx = get_comp_group_idx_context(xd);
  const int comp_index_ctx = get_comp_index_context(cm, xd);

  // Populates masked_type_cost local array for the 4 compound types
  calc_masked_type_cost(x, bsize, comp_group_idx_ctx, comp_index_ctx,
                        masked_compound_used, masked_type_cost);

  int64_t comp_model_rd_cur = INT64_MAX;
  int64_t best_rd_cur = INT64_MAX;
  const int mi_row = xd->mi_row;
  const int mi_col = xd->mi_col;

  // If the match is found, calculate the rd cost using the
  // stored stats and update the mbmi appropriately.
  if (match_found && cpi->sf.inter_sf.reuse_compound_type_decision) {
    return populate_reuse_comp_type_data(x, mbmi, &best_type_stats, cur_mv,
                                         comp_rate, comp_dist, comp_rs2,
                                         rate_mv, rd, match_index);
  }
  // Special handling if both compound_average and compound_distwtd
  // are to be searched. In this case, first estimate between the two
  // modes and then call estimate_yrd_for_sb() only for the better of
  // the two.
  if (try_average_and_distwtd_comp) {
    int est_rate[2];
    int64_t est_dist[2], est_rd;
    COMPOUND_TYPE best_type;
    // Since modelled rate and dist are separately stored,
    // compute better of COMPOUND_AVERAGE and COMPOUND_DISTWTD
    // using the stored stats.
    if ((comp_model_rate[COMPOUND_AVERAGE] != INT_MAX) &&
        comp_model_rate[COMPOUND_DISTWTD] != INT_MAX) {
      // Choose the better of the COMPOUND_AVERAGE,
      // COMPOUND_DISTWTD on modeled cost.
      best_type = find_best_avg_distwtd_comp_type(
          x, comp_model_rate, comp_model_dist, *rate_mv, &est_rd);
      update_mbmi_for_compound_type(mbmi, best_type);
      if (comp_rate[best_type] != INT_MAX)
        best_rd_cur = RDCOST(
            x->rdmult,
            masked_type_cost[best_type] + *rate_mv + comp_rate[best_type],
            comp_dist[best_type]);
      comp_model_rd_cur = est_rd;
      // Update stats for best compound type
      if (best_rd_cur < *rd) {
        update_best_info(mbmi, rd, &best_type_stats, best_rd_cur,
                         comp_model_rd_cur, masked_type_cost[best_type]);
      }
      restore_dst_buf(xd, *tmp_dst, 1);
    } else {
      int64_t sse_y[COMPOUND_DISTWTD + 1];
      // Calculate model_rd for COMPOUND_AVERAGE and COMPOUND_DISTWTD
      for (int comp_type = COMPOUND_AVERAGE; comp_type <= COMPOUND_DISTWTD;
           comp_type++) {
        update_mbmi_for_compound_type(mbmi, comp_type);
        av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, orig_dst, bsize,
                                      AOM_PLANE_Y, AOM_PLANE_Y);
        model_rd_sb_fn[MODELRD_CURVFIT](
            cpi, bsize, x, xd, 0, 0, &est_rate[comp_type], &est_dist[comp_type],
            NULL, NULL, NULL, NULL, NULL);
        est_rate[comp_type] += masked_type_cost[comp_type];
        comp_model_rate[comp_type] = est_rate[comp_type];
        comp_model_dist[comp_type] = est_dist[comp_type];
        sse_y[comp_type] = x->pred_sse[xd->mi[0]->ref_frame[0]];
        if (comp_type == COMPOUND_AVERAGE) {
          *is_luma_interp_done = 1;
          restore_dst_buf(xd, *tmp_dst, 1);
        }
      }
      // Choose the better of the two based on modeled cost and call
      // estimate_yrd_for_sb() for that one.
      best_type = find_best_avg_distwtd_comp_type(
          x, comp_model_rate, comp_model_dist, *rate_mv, &est_rd);
      update_mbmi_for_compound_type(mbmi, best_type);
      if (best_type == COMPOUND_AVERAGE) restore_dst_buf(xd, *orig_dst, 1);
      rs2 = masked_type_cost[best_type];
      RD_STATS est_rd_stats;
      const int64_t mode_rd = RDCOST(x->rdmult, rs2 + *rate_mv, 0);
      const int64_t tmp_rd_thresh = AOMMIN(*rd, rd_thresh) - mode_rd;
      int64_t est_rd_ = INT64_MAX;
      int eval_txfm = 1;
      // Check if the mode is good enough based on skip rd
      if (cpi->sf.inter_sf.txfm_rd_gate_level) {
        int64_t skip_rd =
            RDCOST(x->rdmult, rs2 + *rate_mv, (sse_y[best_type] << 4));
        eval_txfm = check_txfm_eval(x, bsize, ref_skip_rd, skip_rd,
                                    cpi->sf.inter_sf.txfm_rd_gate_level, 1);
      }
      // Evaluate further if skip rd is low enough
      if (eval_txfm) {
        est_rd_ =
            estimate_yrd_for_sb(cpi, bsize, x, tmp_rd_thresh, &est_rd_stats);
      }

      if (est_rd_ != INT64_MAX) {
        best_rd_cur = RDCOST(x->rdmult, rs2 + *rate_mv + est_rd_stats.rate,
                             est_rd_stats.dist);
        // Backup rate and distortion for future reuse
        backup_stats(best_type, comp_rate, comp_dist, comp_model_rate,
                     comp_model_dist, est_rate[best_type], est_dist[best_type],
                     &est_rd_stats, comp_rs2, rs2);
        comp_model_rd_cur = est_rd;
      }
      if (best_type == COMPOUND_AVERAGE) restore_dst_buf(xd, *tmp_dst, 1);
      // Update stats for best compound type
      if (best_rd_cur < *rd) {
        update_best_info(mbmi, rd, &best_type_stats, best_rd_cur,
                         comp_model_rd_cur, rs2);
      }
    }
  }

  // If COMPOUND_AVERAGE is not valid, use the spare buffer
  if (valid_comp_types[0] != COMPOUND_AVERAGE) restore_dst_buf(xd, *tmp_dst, 1);

  // Loop over valid compound types
  for (int i = 0; i < valid_type_count; i++) {
    cur_type = valid_comp_types[i];
    comp_model_rd_cur = INT64_MAX;
    tmp_rate_mv = *rate_mv;
    best_rd_cur = INT64_MAX;

    // Case COMPOUND_AVERAGE and COMPOUND_DISTWTD
    if (cur_type < COMPOUND_WEDGE) {
      update_mbmi_for_compound_type(mbmi, cur_type);
      rs2 = masked_type_cost[cur_type];
      const int64_t mode_rd = RDCOST(x->rdmult, rs2 + rd_stats->rate, 0);
      if (mode_rd < ref_best_rd) {
        // Reuse data if matching record is found
        if (comp_rate[cur_type] == INT_MAX) {
          av1_enc_build_inter_predictor(cm, xd, mi_row, mi_col, orig_dst, bsize,
                                        AOM_PLANE_Y, AOM_PLANE_Y);
          if (cur_type == COMPOUND_AVERAGE) *is_luma_interp_done = 1;

          // Compute RD cost for the current type
          RD_STATS est_rd_stats;
          const int64_t tmp_rd_thresh = AOMMIN(*rd, rd_thresh) - mode_rd;
          int64_t est_rd = INT64_MAX;
          int eval_txfm = 1;
          // Check if the mode is good enough based on skip rd
          if (cpi->sf.inter_sf.txfm_rd_gate_level) {
            int64_t sse_y = compute_sse_plane(x, xd, PLANE_TYPE_Y, bsize);
            int64_t skip_rd = RDCOST(x->rdmult, rs2 + *rate_mv, (sse_y << 4));
            eval_txfm = check_txfm_eval(x, bsize, ref_skip_rd, skip_rd,
                                        cpi->sf.inter_sf.txfm_rd_gate_level, 1);
          }
          // Evaluate further if skip rd is low enough
          if (eval_txfm) {
            est_rd = estimate_yrd_for_sb(cpi, bsize, x, tmp_rd_thresh,
                                         &est_rd_stats);
          }

          if (est_rd != INT64_MAX) {
            best_rd_cur = RDCOST(x->rdmult, rs2 + *rate_mv + est_rd_stats.rate,
                                 est_rd_stats.dist);
            model_rd_sb_fn[MODELRD_TYPE_MASKED_COMPOUND](
                cpi, bsize, x, xd, 0, 0, &rate_sum, &dist_sum,
                &tmp_skip_txfm_sb, &tmp_skip_sse_sb, NULL, NULL, NULL);
            comp_model_rd_cur =
                RDCOST(x->rdmult, rs2 + *rate_mv + rate_sum, dist_sum);

            // Backup rate and distortion for future reuse
            backup_stats(cur_type, comp_rate, comp_dist, comp_model_rate,
                         comp_model_dist, rate_sum, dist_sum, &est_rd_stats,
                         comp_rs2, rs2);
          }
        } else {
          // Calculate RD cost based on stored stats
          assert(comp_dist[cur_type] != INT64_MAX);
          best_rd_cur = RDCOST(x->rdmult, rs2 + *rate_mv + comp_rate[cur_type],
                               comp_dist[cur_type]);
          // Recalculate model rdcost with the updated rate
          comp_model_rd_cur =
              RDCOST(x->rdmult, rs2 + *rate_mv + comp_model_rate[cur_type],
                     comp_model_dist[cur_type]);
        }
      }
      // use spare buffer for following compound type try
      if (cur_type == COMPOUND_AVERAGE) restore_dst_buf(xd, *tmp_dst, 1);
    } else {
      // Handle masked compound types
      update_mbmi_for_compound_type(mbmi, cur_type);
      rs2 = masked_type_cost[cur_type];
      // Factors to control gating of compound type selection based on best
      // approximate rd so far
      const int max_comp_type_rd_threshold_mul =
          comp_type_rd_threshold_mul[cpi->sf.inter_sf
                                         .prune_comp_type_by_comp_avg];
      const int max_comp_type_rd_threshold_div =
          comp_type_rd_threshold_div[cpi->sf.inter_sf
                                         .prune_comp_type_by_comp_avg];
      // Evaluate COMPOUND_WEDGE / COMPOUND_DIFFWTD if approximated cost is
      // within threshold
      int64_t approx_rd = ((*rd / max_comp_type_rd_threshold_div) *
                           max_comp_type_rd_threshold_mul);

      if (approx_rd < ref_best_rd) {
        const int64_t tmp_rd_thresh = AOMMIN(*rd, rd_thresh);
        best_rd_cur = masked_compound_type_rd(
            cpi, x, cur_mv, bsize, this_mode, &rs2, *rate_mv, orig_dst,
            &tmp_rate_mv, preds0, preds1, buffers->residual1, buffers->diff10,
            strides, rd_stats->rate, tmp_rd_thresh, &calc_pred_masked_compound,
            comp_rate, comp_dist, comp_model_rate, comp_model_dist,
            best_type_stats.comp_best_model_rd, &comp_model_rd_cur, comp_rs2,
            ref_skip_rd);
      }
    }
    // Update stats for best compound type
    if (best_rd_cur < *rd) {
      update_best_info(mbmi, rd, &best_type_stats, best_rd_cur,
                       comp_model_rd_cur, rs2);
      if (masked_compound_used && cur_type >= COMPOUND_WEDGE) {
        memcpy(buffers->tmp_best_mask_buf, xd->seg_mask, mask_len);
        if (have_newmv_in_inter_mode(this_mode))
          update_mask_best_mv(mbmi, best_mv, cur_mv, cur_type,
                              &best_tmp_rate_mv, tmp_rate_mv, &cpi->sf);
      }
    }
    // reset to original mvs for next iteration
    mbmi->mv[0].as_int = cur_mv[0].as_int;
    mbmi->mv[1].as_int = cur_mv[1].as_int;
  }
  if (mbmi->interinter_comp.type != best_type_stats.best_compound_data.type) {
    mbmi->comp_group_idx =
        (best_type_stats.best_compound_data.type < COMPOUND_WEDGE) ? 0 : 1;
    mbmi->compound_idx =
        !(best_type_stats.best_compound_data.type == COMPOUND_DISTWTD);
    mbmi->interinter_comp = best_type_stats.best_compound_data;
    memcpy(xd->seg_mask, buffers->tmp_best_mask_buf, mask_len);
  }
  if (have_newmv_in_inter_mode(this_mode)) {
    mbmi->mv[0].as_int = best_mv[0].as_int;
    mbmi->mv[1].as_int = best_mv[1].as_int;
    if (mbmi->interinter_comp.type == COMPOUND_WEDGE) {
      rd_stats->rate += best_tmp_rate_mv - *rate_mv;
      *rate_mv = best_tmp_rate_mv;
    }
  }
  restore_dst_buf(xd, *orig_dst, 1);
  if (!match_found)
    save_comp_rd_search_stat(x, mbmi, comp_rate, comp_dist, comp_model_rate,
                             comp_model_dist, cur_mv, comp_rs2);
  return best_type_stats.best_compmode_interinter_cost;
}
