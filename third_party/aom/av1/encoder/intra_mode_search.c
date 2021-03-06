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

#include "av1/encoder/intra_mode_search.h"
#include "av1/encoder/model_rd.h"
#include "av1/encoder/palette.h"
#include "av1/common/pred_common.h"
#include "av1/common/reconintra.h"
#include "av1/encoder/tx_search.h"

static const PREDICTION_MODE intra_rd_search_mode_order[INTRA_MODES] = {
  DC_PRED,       H_PRED,        V_PRED,    SMOOTH_PRED, PAETH_PRED,
  SMOOTH_V_PRED, SMOOTH_H_PRED, D135_PRED, D203_PRED,   D157_PRED,
  D67_PRED,      D113_PRED,     D45_PRED,
};

static const UV_PREDICTION_MODE uv_rd_search_mode_order[UV_INTRA_MODES] = {
  UV_DC_PRED,     UV_CFL_PRED,   UV_H_PRED,        UV_V_PRED,
  UV_SMOOTH_PRED, UV_PAETH_PRED, UV_SMOOTH_V_PRED, UV_SMOOTH_H_PRED,
  UV_D135_PRED,   UV_D203_PRED,  UV_D157_PRED,     UV_D67_PRED,
  UV_D113_PRED,   UV_D45_PRED,
};

#define BINS 32
static const float intra_hog_model_bias[DIRECTIONAL_MODES] = {
  0.450578f,  0.695518f,  -0.717944f, -0.639894f,
  -0.602019f, -0.453454f, 0.055857f,  -0.465480f,
};

static const float intra_hog_model_weights[BINS * DIRECTIONAL_MODES] = {
  -3.076402f, -3.757063f, -3.275266f, -3.180665f, -3.452105f, -3.216593f,
  -2.871212f, -3.134296f, -1.822324f, -2.401411f, -1.541016f, -1.195322f,
  -0.434156f, 0.322868f,  2.260546f,  3.368715f,  3.989290f,  3.308487f,
  2.277893f,  0.923793f,  0.026412f,  -0.385174f, -0.718622f, -1.408867f,
  -1.050558f, -2.323941f, -2.225827f, -2.585453f, -3.054283f, -2.875087f,
  -2.985709f, -3.447155f, 3.758139f,  3.204353f,  2.170998f,  0.826587f,
  -0.269665f, -0.702068f, -1.085776f, -2.175249f, -1.623180f, -2.975142f,
  -2.779629f, -3.190799f, -3.521900f, -3.375480f, -3.319355f, -3.897389f,
  -3.172334f, -3.594528f, -2.879132f, -2.547777f, -2.921023f, -2.281844f,
  -1.818988f, -2.041771f, -0.618268f, -1.396458f, -0.567153f, -0.285868f,
  -0.088058f, 0.753494f,  2.092413f,  3.215266f,  -3.300277f, -2.748658f,
  -2.315784f, -2.423671f, -2.257283f, -2.269583f, -2.196660f, -2.301076f,
  -2.646516f, -2.271319f, -2.254366f, -2.300102f, -2.217960f, -2.473300f,
  -2.116866f, -2.528246f, -3.314712f, -1.701010f, -0.589040f, -0.088077f,
  0.813112f,  1.702213f,  2.653045f,  3.351749f,  3.243554f,  3.199409f,
  2.437856f,  1.468854f,  0.533039f,  -0.099065f, -0.622643f, -2.200732f,
  -4.228861f, -2.875263f, -1.273956f, -0.433280f, 0.803771f,  1.975043f,
  3.179528f,  3.939064f,  3.454379f,  3.689386f,  3.116411f,  1.970991f,
  0.798406f,  -0.628514f, -1.252546f, -2.825176f, -4.090178f, -3.777448f,
  -3.227314f, -3.479403f, -3.320569f, -3.159372f, -2.729202f, -2.722341f,
  -3.054913f, -2.742923f, -2.612703f, -2.662632f, -2.907314f, -3.117794f,
  -3.102660f, -3.970972f, -4.891357f, -3.935582f, -3.347758f, -2.721924f,
  -2.219011f, -1.702391f, -0.866529f, -0.153743f, 0.107733f,  1.416882f,
  2.572884f,  3.607755f,  3.974820f,  3.997783f,  2.970459f,  0.791687f,
  -1.478921f, -1.228154f, -1.216955f, -1.765932f, -1.951003f, -1.985301f,
  -1.975881f, -1.985593f, -2.422371f, -2.419978f, -2.531288f, -2.951853f,
  -3.071380f, -3.277027f, -3.373539f, -4.462010f, -0.967888f, 0.805524f,
  2.794130f,  3.685984f,  3.745195f,  3.252444f,  2.316108f,  1.399146f,
  -0.136519f, -0.162811f, -1.004357f, -1.667911f, -1.964662f, -2.937579f,
  -3.019533f, -3.942766f, -5.102767f, -3.882073f, -3.532027f, -3.451956f,
  -2.944015f, -2.643064f, -2.529872f, -2.077290f, -2.809965f, -1.803734f,
  -1.783593f, -1.662585f, -1.415484f, -1.392673f, -0.788794f, -1.204819f,
  -1.998864f, -1.182102f, -0.892110f, -1.317415f, -1.359112f, -1.522867f,
  -1.468552f, -1.779072f, -2.332959f, -2.160346f, -2.329387f, -2.631259f,
  -2.744936f, -3.052494f, -2.787363f, -3.442548f, -4.245075f, -3.032172f,
  -2.061609f, -1.768116f, -1.286072f, -0.706587f, -0.192413f, 0.386938f,
  0.716997f,  1.481393f,  2.216702f,  2.737986f,  3.109809f,  3.226084f,
  2.490098f,  -0.095827f, -3.864816f, -3.507248f, -3.128925f, -2.908251f,
  -2.883836f, -2.881411f, -2.524377f, -2.624478f, -2.399573f, -2.367718f,
  -1.918255f, -1.926277f, -1.694584f, -1.723790f, -0.966491f, -1.183115f,
  -1.430687f, 0.872896f,  2.766550f,  3.610080f,  3.578041f,  3.334928f,
  2.586680f,  1.895721f,  1.122195f,  0.488519f,  -0.140689f, -0.799076f,
  -1.222860f, -1.502437f, -1.900969f, -3.206816f,
};

static void generate_hog(const uint8_t *src, int stride, int rows, int cols,
                         float *hist) {
  const float step = (float)PI / BINS;
  float total = 0.1f;
  src += stride;
  for (int r = 1; r < rows - 1; ++r) {
    for (int c = 1; c < cols - 1; ++c) {
      const uint8_t *above = &src[c - stride];
      const uint8_t *below = &src[c + stride];
      const uint8_t *left = &src[c - 1];
      const uint8_t *right = &src[c + 1];
      // Calculate gradient using Sobel fitlers.
      const int dx = (right[-stride] + 2 * right[0] + right[stride]) -
                     (left[-stride] + 2 * left[0] + left[stride]);
      const int dy = (below[-1] + 2 * below[0] + below[1]) -
                     (above[-1] + 2 * above[0] + above[1]);
      if (dx == 0 && dy == 0) continue;
      const int temp = abs(dx) + abs(dy);
      if (!temp) continue;
      total += temp;
      if (dx == 0) {
        hist[0] += temp / 2;
        hist[BINS - 1] += temp / 2;
      } else {
        const float angle = atanf(dy * 1.0f / dx);
        int idx = (int)roundf(angle / step) + BINS / 2;
        idx = AOMMIN(idx, BINS - 1);
        idx = AOMMAX(idx, 0);
        hist[idx] += temp;
      }
    }
    src += stride;
  }

  for (int i = 0; i < BINS; ++i) hist[i] /= total;
}

static void generate_hog_hbd(const uint8_t *src8, int stride, int rows,
                             int cols, float *hist) {
  const float step = (float)PI / BINS;
  float total = 0.1f;
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  src += stride;
  for (int r = 1; r < rows - 1; ++r) {
    for (int c = 1; c < cols - 1; ++c) {
      const uint16_t *above = &src[c - stride];
      const uint16_t *below = &src[c + stride];
      const uint16_t *left = &src[c - 1];
      const uint16_t *right = &src[c + 1];
      // Calculate gradient using Sobel fitlers.
      const int dx = (right[-stride] + 2 * right[0] + right[stride]) -
                     (left[-stride] + 2 * left[0] + left[stride]);
      const int dy = (below[-1] + 2 * below[0] + below[1]) -
                     (above[-1] + 2 * above[0] + above[1]);
      if (dx == 0 && dy == 0) continue;
      const int temp = abs(dx) + abs(dy);
      if (!temp) continue;
      total += temp;
      if (dx == 0) {
        hist[0] += temp / 2;
        hist[BINS - 1] += temp / 2;
      } else {
        const float angle = atanf(dy * 1.0f / dx);
        int idx = (int)roundf(angle / step) + BINS / 2;
        idx = AOMMIN(idx, BINS - 1);
        idx = AOMMAX(idx, 0);
        hist[idx] += temp;
      }
    }
    src += stride;
  }

  for (int i = 0; i < BINS; ++i) hist[i] /= total;
}

static void prune_intra_mode_with_hog(const MACROBLOCK *x, BLOCK_SIZE bsize,
                                      float th,
                                      uint8_t *directional_mode_skip_mask) {
  aom_clear_system_state();

  const int bh = block_size_high[bsize];
  const int bw = block_size_wide[bsize];
  const MACROBLOCKD *xd = &x->e_mbd;
  const int rows =
      (xd->mb_to_bottom_edge >= 0) ? bh : (xd->mb_to_bottom_edge >> 3) + bh;
  const int cols =
      (xd->mb_to_right_edge >= 0) ? bw : (xd->mb_to_right_edge >> 3) + bw;
  const int src_stride = x->plane[0].src.stride;
  const uint8_t *src = x->plane[0].src.buf;
  float hist[BINS] = { 0.0f };
  if (is_cur_buf_hbd(xd)) {
    generate_hog_hbd(src, src_stride, rows, cols, hist);
  } else {
    generate_hog(src, src_stride, rows, cols, hist);
  }

  for (int i = 0; i < DIRECTIONAL_MODES; ++i) {
    float this_score = intra_hog_model_bias[i];
    const float *weights = &intra_hog_model_weights[i * BINS];
    for (int j = 0; j < BINS; ++j) {
      this_score += weights[j] * hist[j];
    }
    if (this_score < th) directional_mode_skip_mask[i + 1] = 1;
  }

  aom_clear_system_state();
}

#undef BINS

// Model based RD estimation for luma intra blocks.
static int64_t intra_model_yrd(const AV1_COMP *const cpi, MACROBLOCK *const x,
                               BLOCK_SIZE bsize, int mode_cost) {
  const AV1_COMMON *cm = &cpi->common;
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  RD_STATS this_rd_stats;
  int row, col;
  int64_t temp_sse, this_rd;
  TX_SIZE tx_size = tx_size_from_tx_mode(bsize, x->tx_mode_search_type);
  const int stepr = tx_size_high_unit[tx_size];
  const int stepc = tx_size_wide_unit[tx_size];
  const int max_blocks_wide = max_block_wide(xd, bsize, 0);
  const int max_blocks_high = max_block_high(xd, bsize, 0);
  mbmi->tx_size = tx_size;
  // Prediction.
  for (row = 0; row < max_blocks_high; row += stepr) {
    for (col = 0; col < max_blocks_wide; col += stepc) {
      av1_predict_intra_block_facade(cm, xd, 0, col, row, tx_size);
    }
  }
  // RD estimation.
  model_rd_sb_fn[cpi->sf.rt_sf.use_simple_rd_model ? MODELRD_LEGACY
                                                   : MODELRD_TYPE_INTRA](
      cpi, bsize, x, xd, 0, 0, &this_rd_stats.rate, &this_rd_stats.dist,
      &this_rd_stats.skip, &temp_sse, NULL, NULL, NULL);
  if (av1_is_directional_mode(mbmi->mode) && av1_use_angle_delta(bsize)) {
    mode_cost +=
        x->angle_delta_cost[mbmi->mode - V_PRED]
                           [MAX_ANGLE_DELTA + mbmi->angle_delta[PLANE_TYPE_Y]];
  }
  if (mbmi->mode == DC_PRED &&
      av1_filter_intra_allowed_bsize(cm, mbmi->sb_type)) {
    if (mbmi->filter_intra_mode_info.use_filter_intra) {
      const int mode = mbmi->filter_intra_mode_info.filter_intra_mode;
      mode_cost += x->filter_intra_cost[mbmi->sb_type][1] +
                   x->filter_intra_mode_cost[mode];
    } else {
      mode_cost += x->filter_intra_cost[mbmi->sb_type][0];
    }
  }
  this_rd =
      RDCOST(x->rdmult, this_rd_stats.rate + mode_cost, this_rd_stats.dist);
  return this_rd;
}

// Update the intra model yrd and prune the current mode if the new estimate
// y_rd > 1.5 * best_model_rd.
static AOM_INLINE int model_intra_yrd_and_prune(const AV1_COMP *const cpi,
                                                MACROBLOCK *x, BLOCK_SIZE bsize,
                                                int mode_info_cost,
                                                int64_t *best_model_rd) {
  const int64_t this_model_rd = intra_model_yrd(cpi, x, bsize, mode_info_cost);
  if (*best_model_rd != INT64_MAX &&
      this_model_rd > *best_model_rd + (*best_model_rd >> 1)) {
    return 1;
  } else if (this_model_rd < *best_model_rd) {
    *best_model_rd = this_model_rd;
  }
  return 0;
}

// Run RD calculation with given luma intra prediction angle., and return
// the RD cost. Update the best mode info. if the RD cost is the best so far.
static int64_t calc_rd_given_intra_angle(
    const AV1_COMP *const cpi, MACROBLOCK *x, BLOCK_SIZE bsize, int mode_cost,
    int64_t best_rd_in, int8_t angle_delta, int max_angle_delta, int *rate,
    RD_STATS *rd_stats, int *best_angle_delta, TX_SIZE *best_tx_size,
    int64_t *best_rd, int64_t *best_model_rd, uint8_t *best_tx_type_map,
    uint8_t *best_blk_skip, int skip_model_rd) {
  RD_STATS tokenonly_rd_stats;
  int64_t this_rd;
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  const int n4 = bsize_to_num_blk(bsize);
  assert(!is_inter_block(mbmi));
  mbmi->angle_delta[PLANE_TYPE_Y] = angle_delta;
  if (!skip_model_rd) {
    if (model_intra_yrd_and_prune(cpi, x, bsize, mode_cost, best_model_rd)) {
      return INT64_MAX;
    }
  }
  av1_pick_uniform_tx_size_type_yrd(cpi, x, &tokenonly_rd_stats, bsize,
                                    best_rd_in);
  if (tokenonly_rd_stats.rate == INT_MAX) return INT64_MAX;

  int this_rate =
      mode_cost + tokenonly_rd_stats.rate +
      x->angle_delta_cost[mbmi->mode - V_PRED][max_angle_delta + angle_delta];
  this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);

  if (this_rd < *best_rd) {
    memcpy(best_blk_skip, x->blk_skip, sizeof(best_blk_skip[0]) * n4);
    av1_copy_array(best_tx_type_map, xd->tx_type_map, n4);
    *best_rd = this_rd;
    *best_angle_delta = mbmi->angle_delta[PLANE_TYPE_Y];
    *best_tx_size = mbmi->tx_size;
    *rate = this_rate;
    rd_stats->rate = tokenonly_rd_stats.rate;
    rd_stats->dist = tokenonly_rd_stats.dist;
    rd_stats->skip = tokenonly_rd_stats.skip;
  }
  return this_rd;
}

static INLINE int write_uniform_cost(int n, int v) {
  const int l = get_unsigned_bits(n);
  const int m = (1 << l) - n;
  if (l == 0) return 0;
  if (v < m)
    return av1_cost_literal(l - 1);
  else
    return av1_cost_literal(l);
}

// Return the rate cost for luma prediction mode info. of intra blocks.
static int intra_mode_info_cost_y(const AV1_COMP *cpi, const MACROBLOCK *x,
                                  const MB_MODE_INFO *mbmi, BLOCK_SIZE bsize,
                                  int mode_cost) {
  int total_rate = mode_cost;
  const int use_palette = mbmi->palette_mode_info.palette_size[0] > 0;
  const int use_filter_intra = mbmi->filter_intra_mode_info.use_filter_intra;
  const int use_intrabc = mbmi->use_intrabc;
  // Can only activate one mode.
  assert(((mbmi->mode != DC_PRED) + use_palette + use_intrabc +
          use_filter_intra) <= 1);
  const int try_palette = av1_allow_palette(
      cpi->common.features.allow_screen_content_tools, mbmi->sb_type);
  if (try_palette && mbmi->mode == DC_PRED) {
    const MACROBLOCKD *xd = &x->e_mbd;
    const int bsize_ctx = av1_get_palette_bsize_ctx(bsize);
    const int mode_ctx = av1_get_palette_mode_ctx(xd);
    total_rate += x->palette_y_mode_cost[bsize_ctx][mode_ctx][use_palette];
    if (use_palette) {
      const uint8_t *const color_map = xd->plane[0].color_index_map;
      int block_width, block_height, rows, cols;
      av1_get_block_dimensions(bsize, 0, xd, &block_width, &block_height, &rows,
                               &cols);
      const int plt_size = mbmi->palette_mode_info.palette_size[0];
      int palette_mode_cost =
          x->palette_y_size_cost[bsize_ctx][plt_size - PALETTE_MIN_SIZE] +
          write_uniform_cost(plt_size, color_map[0]);
      uint16_t color_cache[2 * PALETTE_MAX_SIZE];
      const int n_cache = av1_get_palette_cache(xd, 0, color_cache);
      palette_mode_cost +=
          av1_palette_color_cost_y(&mbmi->palette_mode_info, color_cache,
                                   n_cache, cpi->common.seq_params.bit_depth);
      palette_mode_cost +=
          av1_cost_color_map(x, 0, bsize, mbmi->tx_size, PALETTE_MAP);
      total_rate += palette_mode_cost;
    }
  }
  if (av1_filter_intra_allowed(&cpi->common, mbmi)) {
    total_rate += x->filter_intra_cost[mbmi->sb_type][use_filter_intra];
    if (use_filter_intra) {
      total_rate += x->filter_intra_mode_cost[mbmi->filter_intra_mode_info
                                                  .filter_intra_mode];
    }
  }
  if (av1_is_directional_mode(mbmi->mode)) {
    if (av1_use_angle_delta(bsize)) {
      total_rate += x->angle_delta_cost[mbmi->mode - V_PRED]
                                       [MAX_ANGLE_DELTA +
                                        mbmi->angle_delta[PLANE_TYPE_Y]];
    }
  }
  if (av1_allow_intrabc(&cpi->common))
    total_rate += x->intrabc_cost[use_intrabc];
  return total_rate;
}

// Return the rate cost for chroma prediction mode info. of intra blocks.
static int intra_mode_info_cost_uv(const AV1_COMP *cpi, const MACROBLOCK *x,
                                   const MB_MODE_INFO *mbmi, BLOCK_SIZE bsize,
                                   int mode_cost) {
  int total_rate = mode_cost;
  const int use_palette = mbmi->palette_mode_info.palette_size[1] > 0;
  const UV_PREDICTION_MODE mode = mbmi->uv_mode;
  // Can only activate one mode.
  assert(((mode != UV_DC_PRED) + use_palette + mbmi->use_intrabc) <= 1);

  const int try_palette = av1_allow_palette(
      cpi->common.features.allow_screen_content_tools, mbmi->sb_type);
  if (try_palette && mode == UV_DC_PRED) {
    const PALETTE_MODE_INFO *pmi = &mbmi->palette_mode_info;
    total_rate +=
        x->palette_uv_mode_cost[pmi->palette_size[0] > 0][use_palette];
    if (use_palette) {
      const int bsize_ctx = av1_get_palette_bsize_ctx(bsize);
      const int plt_size = pmi->palette_size[1];
      const MACROBLOCKD *xd = &x->e_mbd;
      const uint8_t *const color_map = xd->plane[1].color_index_map;
      int palette_mode_cost =
          x->palette_uv_size_cost[bsize_ctx][plt_size - PALETTE_MIN_SIZE] +
          write_uniform_cost(plt_size, color_map[0]);
      uint16_t color_cache[2 * PALETTE_MAX_SIZE];
      const int n_cache = av1_get_palette_cache(xd, 1, color_cache);
      palette_mode_cost += av1_palette_color_cost_uv(
          pmi, color_cache, n_cache, cpi->common.seq_params.bit_depth);
      palette_mode_cost +=
          av1_cost_color_map(x, 1, bsize, mbmi->tx_size, PALETTE_MAP);
      total_rate += palette_mode_cost;
    }
  }
  if (av1_is_directional_mode(get_uv_mode(mode))) {
    if (av1_use_angle_delta(bsize)) {
      total_rate +=
          x->angle_delta_cost[mode - V_PRED][mbmi->angle_delta[PLANE_TYPE_UV] +
                                             MAX_ANGLE_DELTA];
    }
  }
  return total_rate;
}

// Return 1 if an filter intra mode is selected; return 0 otherwise.
static int rd_pick_filter_intra_sby(const AV1_COMP *const cpi, MACROBLOCK *x,
                                    int *rate, int *rate_tokenonly,
                                    int64_t *distortion, int *skippable,
                                    BLOCK_SIZE bsize, int mode_cost,
                                    int64_t *best_rd, int64_t *best_model_rd,
                                    PICK_MODE_CONTEXT *ctx) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  int filter_intra_selected_flag = 0;
  FILTER_INTRA_MODE mode;
  TX_SIZE best_tx_size = TX_8X8;
  FILTER_INTRA_MODE_INFO filter_intra_mode_info;
  uint8_t best_tx_type_map[MAX_MIB_SIZE * MAX_MIB_SIZE];
  (void)ctx;
  av1_zero(filter_intra_mode_info);
  mbmi->filter_intra_mode_info.use_filter_intra = 1;
  mbmi->mode = DC_PRED;
  mbmi->palette_mode_info.palette_size[0] = 0;

  for (mode = 0; mode < FILTER_INTRA_MODES; ++mode) {
    int64_t this_rd;
    RD_STATS tokenonly_rd_stats;
    mbmi->filter_intra_mode_info.filter_intra_mode = mode;

    if (model_intra_yrd_and_prune(cpi, x, bsize, mode_cost, best_model_rd)) {
      continue;
    }
    av1_pick_uniform_tx_size_type_yrd(cpi, x, &tokenonly_rd_stats, bsize,
                                      *best_rd);
    if (tokenonly_rd_stats.rate == INT_MAX) continue;
    const int this_rate =
        tokenonly_rd_stats.rate +
        intra_mode_info_cost_y(cpi, x, mbmi, bsize, mode_cost);
    this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);

    // Collect mode stats for multiwinner mode processing
    const int txfm_search_done = 1;
    store_winner_mode_stats(
        &cpi->common, x, mbmi, NULL, NULL, NULL, 0, NULL, bsize, this_rd,
        cpi->sf.winner_mode_sf.enable_multiwinner_mode_process,
        txfm_search_done);
    if (this_rd < *best_rd) {
      *best_rd = this_rd;
      best_tx_size = mbmi->tx_size;
      filter_intra_mode_info = mbmi->filter_intra_mode_info;
      av1_copy_array(best_tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
      memcpy(ctx->blk_skip, x->blk_skip,
             sizeof(x->blk_skip[0]) * ctx->num_4x4_blk);
      *rate = this_rate;
      *rate_tokenonly = tokenonly_rd_stats.rate;
      *distortion = tokenonly_rd_stats.dist;
      *skippable = tokenonly_rd_stats.skip;
      filter_intra_selected_flag = 1;
    }
  }

  if (filter_intra_selected_flag) {
    mbmi->mode = DC_PRED;
    mbmi->tx_size = best_tx_size;
    mbmi->filter_intra_mode_info = filter_intra_mode_info;
    av1_copy_array(ctx->tx_type_map, best_tx_type_map, ctx->num_4x4_blk);
    return 1;
  } else {
    return 0;
  }
}

int av1_count_colors(const uint8_t *src, int stride, int rows, int cols,
                     int *val_count) {
  const int max_pix_val = 1 << 8;
  memset(val_count, 0, max_pix_val * sizeof(val_count[0]));
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      const int this_val = src[r * stride + c];
      assert(this_val < max_pix_val);
      ++val_count[this_val];
    }
  }
  int n = 0;
  for (int i = 0; i < max_pix_val; ++i) {
    if (val_count[i]) ++n;
  }
  return n;
}

int av1_count_colors_highbd(const uint8_t *src8, int stride, int rows, int cols,
                            int bit_depth, int *val_count) {
  assert(bit_depth <= 12);
  const int max_pix_val = 1 << bit_depth;
  const uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  memset(val_count, 0, max_pix_val * sizeof(val_count[0]));
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      const int this_val = src[r * stride + c];
      assert(this_val < max_pix_val);
      if (this_val >= max_pix_val) return 0;
      ++val_count[this_val];
    }
  }
  int n = 0;
  for (int i = 0; i < max_pix_val; ++i) {
    if (val_count[i]) ++n;
  }
  return n;
}

// Extends 'color_map' array from 'orig_width x orig_height' to 'new_width x
// new_height'. Extra rows and columns are filled in by copying last valid
// row/column.
static AOM_INLINE void extend_palette_color_map(uint8_t *const color_map,
                                                int orig_width, int orig_height,
                                                int new_width, int new_height) {
  int j;
  assert(new_width >= orig_width);
  assert(new_height >= orig_height);
  if (new_width == orig_width && new_height == orig_height) return;

  for (j = orig_height - 1; j >= 0; --j) {
    memmove(color_map + j * new_width, color_map + j * orig_width, orig_width);
    // Copy last column to extra columns.
    memset(color_map + j * new_width + orig_width,
           color_map[j * new_width + orig_width - 1], new_width - orig_width);
  }
  // Copy last row to extra rows.
  for (j = orig_height; j < new_height; ++j) {
    memcpy(color_map + j * new_width, color_map + (orig_height - 1) * new_width,
           new_width);
  }
}

// Bias toward using colors in the cache.
// TODO(huisu): Try other schemes to improve compression.
static AOM_INLINE void optimize_palette_colors(uint16_t *color_cache,
                                               int n_cache, int n_colors,
                                               int stride, int *centroids) {
  if (n_cache <= 0) return;
  for (int i = 0; i < n_colors * stride; i += stride) {
    int min_diff = abs(centroids[i] - (int)color_cache[0]);
    int idx = 0;
    for (int j = 1; j < n_cache; ++j) {
      const int this_diff = abs(centroids[i] - color_cache[j]);
      if (this_diff < min_diff) {
        min_diff = this_diff;
        idx = j;
      }
    }
    if (min_diff <= 1) centroids[i] = color_cache[idx];
  }
}

// Given the base colors as specified in centroids[], calculate the RD cost
// of palette mode.
static AOM_INLINE void palette_rd_y(
    const AV1_COMP *const cpi, MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BLOCK_SIZE bsize, int dc_mode_cost, const int *data, int *centroids, int n,
    uint16_t *color_cache, int n_cache, MB_MODE_INFO *best_mbmi,
    uint8_t *best_palette_color_map, int64_t *best_rd, int64_t *best_model_rd,
    int *rate, int *rate_tokenonly, int64_t *distortion, int *skippable,
    int *beat_best_rd, PICK_MODE_CONTEXT *ctx, uint8_t *blk_skip,
    uint8_t *tx_type_map, int *beat_best_pallette_rd) {
  optimize_palette_colors(color_cache, n_cache, n, 1, centroids);
  const int num_unique_colors = av1_remove_duplicates(centroids, n);
  if (num_unique_colors < PALETTE_MIN_SIZE) {
    // Too few unique colors to create a palette. And DC_PRED will work
    // well for that case anyway. So skip.
    return;
  }
  PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
  if (cpi->common.seq_params.use_highbitdepth) {
    for (int i = 0; i < num_unique_colors; ++i) {
      pmi->palette_colors[i] = clip_pixel_highbd(
          (int)centroids[i], cpi->common.seq_params.bit_depth);
    }
  } else {
    for (int i = 0; i < num_unique_colors; ++i) {
      pmi->palette_colors[i] = clip_pixel(centroids[i]);
    }
  }
  pmi->palette_size[0] = num_unique_colors;
  MACROBLOCKD *const xd = &x->e_mbd;
  uint8_t *const color_map = xd->plane[0].color_index_map;
  int block_width, block_height, rows, cols;
  av1_get_block_dimensions(bsize, 0, xd, &block_width, &block_height, &rows,
                           &cols);
  av1_calc_indices(data, centroids, color_map, rows * cols, num_unique_colors,
                   1);
  extend_palette_color_map(color_map, cols, rows, block_width, block_height);

  const int palette_mode_cost =
      intra_mode_info_cost_y(cpi, x, mbmi, bsize, dc_mode_cost);
  if (model_intra_yrd_and_prune(cpi, x, bsize, palette_mode_cost,
                                best_model_rd)) {
    return;
  }

  RD_STATS tokenonly_rd_stats;
  av1_pick_uniform_tx_size_type_yrd(cpi, x, &tokenonly_rd_stats, bsize,
                                    *best_rd);
  if (tokenonly_rd_stats.rate == INT_MAX) return;
  int this_rate = tokenonly_rd_stats.rate + palette_mode_cost;
  int64_t this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);
  if (!xd->lossless[mbmi->segment_id] && block_signals_txsize(mbmi->sb_type)) {
    tokenonly_rd_stats.rate -= tx_size_cost(x, bsize, mbmi->tx_size);
  }
  // Collect mode stats for multiwinner mode processing
  const int txfm_search_done = 1;
  store_winner_mode_stats(
      &cpi->common, x, mbmi, NULL, NULL, NULL, THR_DC, color_map, bsize,
      this_rd, cpi->sf.winner_mode_sf.enable_multiwinner_mode_process,
      txfm_search_done);
  if (this_rd < *best_rd) {
    *best_rd = this_rd;
    // Setting beat_best_rd flag because current mode rd is better than best_rd.
    // This flag need to be updated only for palette evaluation in key frames
    if (beat_best_rd) *beat_best_rd = 1;
    memcpy(best_palette_color_map, color_map,
           block_width * block_height * sizeof(color_map[0]));
    *best_mbmi = *mbmi;
    memcpy(blk_skip, x->blk_skip, sizeof(x->blk_skip[0]) * ctx->num_4x4_blk);
    av1_copy_array(tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
    if (rate) *rate = this_rate;
    if (rate_tokenonly) *rate_tokenonly = tokenonly_rd_stats.rate;
    if (distortion) *distortion = tokenonly_rd_stats.dist;
    if (skippable) *skippable = tokenonly_rd_stats.skip;
    if (beat_best_pallette_rd) *beat_best_pallette_rd = 1;
  }
}

static AOM_INLINE int perform_top_color_coarse_palette_search(
    const AV1_COMP *const cpi, MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BLOCK_SIZE bsize, int dc_mode_cost, const int *data,
    const int *const top_colors, int start_n, int end_n, int step_size,
    uint16_t *color_cache, int n_cache, MB_MODE_INFO *best_mbmi,
    uint8_t *best_palette_color_map, int64_t *best_rd, int64_t *best_model_rd,
    int *rate, int *rate_tokenonly, int64_t *distortion, int *skippable,
    int *beat_best_rd, PICK_MODE_CONTEXT *ctx, uint8_t *best_blk_skip,
    uint8_t *tx_type_map) {
  int centroids[PALETTE_MAX_SIZE];
  int n = start_n;
  int top_color_winner = end_n + 1;
  while (1) {
    int beat_best_pallette_rd = 0;
    for (int i = 0; i < n; ++i) centroids[i] = top_colors[i];
    palette_rd_y(cpi, x, mbmi, bsize, dc_mode_cost, data, centroids, n,
                 color_cache, n_cache, best_mbmi, best_palette_color_map,
                 best_rd, best_model_rd, rate, rate_tokenonly, distortion,
                 skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map,
                 &beat_best_pallette_rd);
    // Break if current palette colors is not winning
    if (beat_best_pallette_rd) top_color_winner = n;
    n += step_size;
    if (n > end_n) break;
  }
  return top_color_winner;
}

static AOM_INLINE int perform_k_means_coarse_palette_search(
    const AV1_COMP *const cpi, MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BLOCK_SIZE bsize, int dc_mode_cost, const int *data, int lb, int ub,
    int start_n, int end_n, int step_size, uint16_t *color_cache, int n_cache,
    MB_MODE_INFO *best_mbmi, uint8_t *best_palette_color_map, int64_t *best_rd,
    int64_t *best_model_rd, int *rate, int *rate_tokenonly, int64_t *distortion,
    int *skippable, int *beat_best_rd, PICK_MODE_CONTEXT *ctx,
    uint8_t *best_blk_skip, uint8_t *tx_type_map, uint8_t *color_map,
    int data_points) {
  int centroids[PALETTE_MAX_SIZE];
  const int max_itr = 50;
  int n = start_n;
  int k_means_winner = end_n + 1;
  while (1) {
    int beat_best_pallette_rd = 0;
    for (int i = 0; i < n; ++i) {
      centroids[i] = lb + (2 * i + 1) * (ub - lb) / n / 2;
    }
    av1_k_means(data, centroids, color_map, data_points, n, 1, max_itr);
    palette_rd_y(cpi, x, mbmi, bsize, dc_mode_cost, data, centroids, n,
                 color_cache, n_cache, best_mbmi, best_palette_color_map,
                 best_rd, best_model_rd, rate, rate_tokenonly, distortion,
                 skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map,
                 &beat_best_pallette_rd);
    // Break if current palette colors is not winning
    if (beat_best_pallette_rd) k_means_winner = n;
    n += step_size;
    if (n > end_n) break;
  }
  return k_means_winner;
}

// Perform palette search for top colors from minimum palette colors (/maximum)
// with a step-size of 1 (/-1)
static AOM_INLINE int perform_top_color_palette_search(
    const AV1_COMP *const cpi, MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BLOCK_SIZE bsize, int dc_mode_cost, const int *data, int *top_colors,
    int start_n, int end_n, int step_size, uint16_t *color_cache, int n_cache,
    MB_MODE_INFO *best_mbmi, uint8_t *best_palette_color_map, int64_t *best_rd,
    int64_t *best_model_rd, int *rate, int *rate_tokenonly, int64_t *distortion,
    int *skippable, int *beat_best_rd, PICK_MODE_CONTEXT *ctx,
    uint8_t *best_blk_skip, uint8_t *tx_type_map) {
  int centroids[PALETTE_MAX_SIZE];
  int n = start_n;
  assert((step_size == -1) || (step_size == 1) || (step_size == 0) ||
         (step_size == 2));
  assert(IMPLIES(step_size == -1, start_n > end_n));
  assert(IMPLIES(step_size == 1, start_n < end_n));
  while (1) {
    int beat_best_pallette_rd = 0;
    for (int i = 0; i < n; ++i) centroids[i] = top_colors[i];
    palette_rd_y(cpi, x, mbmi, bsize, dc_mode_cost, data, centroids, n,
                 color_cache, n_cache, best_mbmi, best_palette_color_map,
                 best_rd, best_model_rd, rate, rate_tokenonly, distortion,
                 skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map,
                 &beat_best_pallette_rd);
    // Break if current palette colors is not winning
    if ((cpi->sf.intra_sf.prune_palette_search_level == 2) &&
        !beat_best_pallette_rd)
      return n;
    n += step_size;
    if (n == end_n) break;
  }
  return n;
}
// Perform k-means based palette search from minimum palette colors (/maximum)
// with a step-size of 1 (/-1)
static AOM_INLINE int perform_k_means_palette_search(
    const AV1_COMP *const cpi, MACROBLOCK *x, MB_MODE_INFO *mbmi,
    BLOCK_SIZE bsize, int dc_mode_cost, const int *data, int lb, int ub,
    int start_n, int end_n, int step_size, uint16_t *color_cache, int n_cache,
    MB_MODE_INFO *best_mbmi, uint8_t *best_palette_color_map, int64_t *best_rd,
    int64_t *best_model_rd, int *rate, int *rate_tokenonly, int64_t *distortion,
    int *skippable, int *beat_best_rd, PICK_MODE_CONTEXT *ctx,
    uint8_t *best_blk_skip, uint8_t *tx_type_map, uint8_t *color_map,
    int data_points) {
  int centroids[PALETTE_MAX_SIZE];
  const int max_itr = 50;
  int n = start_n;
  assert((step_size == -1) || (step_size == 1) || (step_size == 0) ||
         (step_size == 2));
  assert(IMPLIES(step_size == -1, start_n > end_n));
  assert(IMPLIES(step_size == 1, start_n < end_n));
  while (1) {
    int beat_best_pallette_rd = 0;
    for (int i = 0; i < n; ++i) {
      centroids[i] = lb + (2 * i + 1) * (ub - lb) / n / 2;
    }
    av1_k_means(data, centroids, color_map, data_points, n, 1, max_itr);
    palette_rd_y(cpi, x, mbmi, bsize, dc_mode_cost, data, centroids, n,
                 color_cache, n_cache, best_mbmi, best_palette_color_map,
                 best_rd, best_model_rd, rate, rate_tokenonly, distortion,
                 skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map,
                 &beat_best_pallette_rd);
    // Break if current palette colors is not winning
    if ((cpi->sf.intra_sf.prune_palette_search_level == 2) &&
        !beat_best_pallette_rd)
      return n;
    n += step_size;
    if (n == end_n) break;
  }
  return n;
}

#define START_N_STAGE2(x)                         \
  ((x == PALETTE_MIN_SIZE) ? PALETTE_MIN_SIZE + 1 \
                           : AOMMAX(x - 1, PALETTE_MIN_SIZE));
#define END_N_STAGE2(x, end_n) \
  ((x == end_n) ? x - 1 : AOMMIN(x + 1, PALETTE_MAX_SIZE));

static AOM_INLINE void update_start_end_stage_2(int *start_n_stage2,
                                                int *end_n_stage2,
                                                int *step_size_stage2,
                                                int winner, int end_n) {
  *start_n_stage2 = START_N_STAGE2(winner);
  *end_n_stage2 = END_N_STAGE2(winner, end_n);
  *step_size_stage2 = *end_n_stage2 - *start_n_stage2;
}

// Start index and step size below are chosen to evaluate unique
// candidates in neighbor search, in case a winner candidate is found in
// coarse search. Example,
// 1) 8 colors (end_n = 8): 2,3,4,5,6,7,8. start_n is chosen as 2 and step
// size is chosen as 3. Therefore, coarse search will evaluate 2, 5 and 8.
// If winner is found at 5, then 4 and 6 are evaluated. Similarly, for 2
// (3) and 8 (7).
// 2) 7 colors (end_n = 7): 2,3,4,5,6,7. If start_n is chosen as 2 (same
// as for 8 colors) then step size should also be 2, to cover all
// candidates. Coarse search will evaluate 2, 4 and 6. If winner is either
// 2 or 4, 3 will be evaluated. Instead, if start_n=3 and step_size=3,
// coarse search will evaluate 3 and 6. For the winner, unique neighbors
// (3: 2,4 or 6: 5,7) would be evaluated.

// start index for coarse palette search for dominant colors and k-means
static const uint8_t start_n_lookup_table[PALETTE_MAX_SIZE + 1] = { 0, 0, 0,
                                                                    3, 3, 2,
                                                                    3, 3, 2 };
// step size for coarse palette search for dominant colors and k-means
static const uint8_t step_size_lookup_table[PALETTE_MAX_SIZE + 1] = { 0, 0, 0,
                                                                      3, 3, 3,
                                                                      3, 3, 3 };

static void rd_pick_palette_intra_sby(
    const AV1_COMP *const cpi, MACROBLOCK *x, BLOCK_SIZE bsize,
    int dc_mode_cost, MB_MODE_INFO *best_mbmi, uint8_t *best_palette_color_map,
    int64_t *best_rd, int64_t *best_model_rd, int *rate, int *rate_tokenonly,
    int64_t *distortion, int *skippable, int *beat_best_rd,
    PICK_MODE_CONTEXT *ctx, uint8_t *best_blk_skip, uint8_t *tx_type_map) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  assert(av1_allow_palette(cpi->common.features.allow_screen_content_tools,
                           bsize));

  const int src_stride = x->plane[0].src.stride;
  const uint8_t *const src = x->plane[0].src.buf;
  int block_width, block_height, rows, cols;
  av1_get_block_dimensions(bsize, 0, xd, &block_width, &block_height, &rows,
                           &cols);
  const SequenceHeader *const seq_params = &cpi->common.seq_params;
  const int is_hbd = seq_params->use_highbitdepth;
  const int bit_depth = seq_params->bit_depth;
  int count_buf[1 << 12];  // Maximum (1 << 12) color levels.
  int colors;
  if (is_hbd) {
    colors = av1_count_colors_highbd(src, src_stride, rows, cols, bit_depth,
                                     count_buf);
  } else {
    colors = av1_count_colors(src, src_stride, rows, cols, count_buf);
  }

  uint8_t *const color_map = xd->plane[0].color_index_map;
  if (colors > 1 && colors <= 64) {
    int *const data = x->palette_buffer->kmeans_data_buf;
    int centroids[PALETTE_MAX_SIZE];
    int lb, ub;
    if (is_hbd) {
      int *data_pt = data;
      const uint16_t *src_pt = CONVERT_TO_SHORTPTR(src);
      lb = ub = src_pt[0];
      for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
          const int val = src_pt[c];
          data_pt[c] = val;
          lb = AOMMIN(lb, val);
          ub = AOMMAX(ub, val);
        }
        src_pt += src_stride;
        data_pt += cols;
      }
    } else {
      int *data_pt = data;
      const uint8_t *src_pt = src;
      lb = ub = src[0];
      for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
          const int val = src_pt[c];
          data_pt[c] = val;
          lb = AOMMIN(lb, val);
          ub = AOMMAX(ub, val);
        }
        src_pt += src_stride;
        data_pt += cols;
      }
    }

    mbmi->mode = DC_PRED;
    mbmi->filter_intra_mode_info.use_filter_intra = 0;

    uint16_t color_cache[2 * PALETTE_MAX_SIZE];
    const int n_cache = av1_get_palette_cache(xd, 0, color_cache);

    // Find the dominant colors, stored in top_colors[].
    int top_colors[PALETTE_MAX_SIZE] = { 0 };
    for (int i = 0; i < AOMMIN(colors, PALETTE_MAX_SIZE); ++i) {
      int max_count = 0;
      for (int j = 0; j < (1 << bit_depth); ++j) {
        if (count_buf[j] > max_count) {
          max_count = count_buf[j];
          top_colors[i] = j;
        }
      }
      assert(max_count > 0);
      count_buf[top_colors[i]] = 0;
    }

    // Try the dominant colors directly.
    // TODO(huisu@google.com): Try to avoid duplicate computation in cases
    // where the dominant colors and the k-means results are similar.
    if ((cpi->sf.intra_sf.prune_palette_search_level == 1) &&
        (colors > PALETTE_MIN_SIZE)) {
      const int end_n = AOMMIN(colors, PALETTE_MAX_SIZE);
      assert(PALETTE_MAX_SIZE == 8);
      assert(PALETTE_MIN_SIZE == 2);
      // Choose the start index and step size for coarse search based on number
      // of colors
      const int start_n = start_n_lookup_table[end_n];
      const int step_size = step_size_lookup_table[end_n];
      // Perform top color coarse palette search to find the winner candidate
      const int top_color_winner = perform_top_color_coarse_palette_search(
          cpi, x, mbmi, bsize, dc_mode_cost, data, top_colors, start_n, end_n,
          step_size, color_cache, n_cache, best_mbmi, best_palette_color_map,
          best_rd, best_model_rd, rate, rate_tokenonly, distortion, skippable,
          beat_best_rd, ctx, best_blk_skip, tx_type_map);
      // Evaluate neighbors for the winner color (if winner is found) in the
      // above coarse search for dominant colors
      if (top_color_winner <= end_n) {
        int start_n_stage2, end_n_stage2, step_size_stage2;
        update_start_end_stage_2(&start_n_stage2, &end_n_stage2,
                                 &step_size_stage2, top_color_winner, end_n);
        // perform finer search for the winner candidate
        perform_top_color_palette_search(
            cpi, x, mbmi, bsize, dc_mode_cost, data, top_colors, start_n_stage2,
            end_n_stage2 + step_size_stage2, step_size_stage2, color_cache,
            n_cache, best_mbmi, best_palette_color_map, best_rd, best_model_rd,
            rate, rate_tokenonly, distortion, skippable, beat_best_rd, ctx,
            best_blk_skip, tx_type_map);
      }
      // K-means clustering.
      // Perform k-means coarse palette search to find the winner candidate
      const int k_means_winner = perform_k_means_coarse_palette_search(
          cpi, x, mbmi, bsize, dc_mode_cost, data, lb, ub, start_n, end_n,
          step_size, color_cache, n_cache, best_mbmi, best_palette_color_map,
          best_rd, best_model_rd, rate, rate_tokenonly, distortion, skippable,
          beat_best_rd, ctx, best_blk_skip, tx_type_map, color_map,
          rows * cols);
      // Evaluate neighbors for the winner color (if winner is found) in the
      // above coarse search for k-means
      if (k_means_winner <= end_n) {
        int start_n_stage2, end_n_stage2, step_size_stage2;
        update_start_end_stage_2(&start_n_stage2, &end_n_stage2,
                                 &step_size_stage2, k_means_winner, end_n);
        // perform finer search for the winner candidate
        perform_k_means_palette_search(
            cpi, x, mbmi, bsize, dc_mode_cost, data, lb, ub, start_n_stage2,
            end_n_stage2 + step_size_stage2, step_size_stage2, color_cache,
            n_cache, best_mbmi, best_palette_color_map, best_rd, best_model_rd,
            rate, rate_tokenonly, distortion, skippable, beat_best_rd, ctx,
            best_blk_skip, tx_type_map, color_map, rows * cols);
      }
    } else {
      const int start_n = AOMMIN(colors, PALETTE_MAX_SIZE),
                end_n = PALETTE_MIN_SIZE;
      // Perform top color palette search from start_n
      const int top_color_winner = perform_top_color_palette_search(
          cpi, x, mbmi, bsize, dc_mode_cost, data, top_colors, start_n,
          end_n - 1, -1, color_cache, n_cache, best_mbmi,
          best_palette_color_map, best_rd, best_model_rd, rate, rate_tokenonly,
          distortion, skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map);

      if (top_color_winner > end_n) {
        // Perform top color palette search in reverse order for the remaining
        // colors
        perform_top_color_palette_search(
            cpi, x, mbmi, bsize, dc_mode_cost, data, top_colors, end_n,
            top_color_winner, 1, color_cache, n_cache, best_mbmi,
            best_palette_color_map, best_rd, best_model_rd, rate,
            rate_tokenonly, distortion, skippable, beat_best_rd, ctx,
            best_blk_skip, tx_type_map);
      }
      // K-means clustering.
      if (colors == PALETTE_MIN_SIZE) {
        // Special case: These colors automatically become the centroids.
        assert(colors == 2);
        centroids[0] = lb;
        centroids[1] = ub;
        palette_rd_y(cpi, x, mbmi, bsize, dc_mode_cost, data, centroids, colors,
                     color_cache, n_cache, best_mbmi, best_palette_color_map,
                     best_rd, best_model_rd, rate, rate_tokenonly, distortion,
                     skippable, beat_best_rd, ctx, best_blk_skip, tx_type_map,
                     NULL);
      } else {
        // Perform k-means palette search from start_n
        const int k_means_winner = perform_k_means_palette_search(
            cpi, x, mbmi, bsize, dc_mode_cost, data, lb, ub, start_n, end_n - 1,
            -1, color_cache, n_cache, best_mbmi, best_palette_color_map,
            best_rd, best_model_rd, rate, rate_tokenonly, distortion, skippable,
            beat_best_rd, ctx, best_blk_skip, tx_type_map, color_map,
            rows * cols);
        if (k_means_winner > end_n) {
          // Perform k-means palette search in reverse order for the remaining
          // colors
          perform_k_means_palette_search(
              cpi, x, mbmi, bsize, dc_mode_cost, data, lb, ub, end_n,
              k_means_winner, 1, color_cache, n_cache, best_mbmi,
              best_palette_color_map, best_rd, best_model_rd, rate,
              rate_tokenonly, distortion, skippable, beat_best_rd, ctx,
              best_blk_skip, tx_type_map, color_map, rows * cols);
        }
      }
    }
  }

  if (best_mbmi->palette_mode_info.palette_size[0] > 0) {
    memcpy(color_map, best_palette_color_map,
           block_width * block_height * sizeof(best_palette_color_map[0]));
  }
  *mbmi = *best_mbmi;
}

static AOM_INLINE void rd_pick_palette_intra_sbuv(
    const AV1_COMP *const cpi, MACROBLOCK *x, int dc_mode_cost,
    uint8_t *best_palette_color_map, MB_MODE_INFO *const best_mbmi,
    int64_t *best_rd, int *rate, int *rate_tokenonly, int64_t *distortion,
    int *skippable) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  assert(av1_allow_palette(cpi->common.features.allow_screen_content_tools,
                           mbmi->sb_type));
  PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
  const BLOCK_SIZE bsize = mbmi->sb_type;
  const SequenceHeader *const seq_params = &cpi->common.seq_params;
  int this_rate;
  int64_t this_rd;
  int colors_u, colors_v, colors;
  const int src_stride = x->plane[1].src.stride;
  const uint8_t *const src_u = x->plane[1].src.buf;
  const uint8_t *const src_v = x->plane[2].src.buf;
  uint8_t *const color_map = xd->plane[1].color_index_map;
  RD_STATS tokenonly_rd_stats;
  int plane_block_width, plane_block_height, rows, cols;
  av1_get_block_dimensions(bsize, 1, xd, &plane_block_width,
                           &plane_block_height, &rows, &cols);

  mbmi->uv_mode = UV_DC_PRED;

  int count_buf[1 << 12];  // Maximum (1 << 12) color levels.
  if (seq_params->use_highbitdepth) {
    colors_u = av1_count_colors_highbd(src_u, src_stride, rows, cols,
                                       seq_params->bit_depth, count_buf);
    colors_v = av1_count_colors_highbd(src_v, src_stride, rows, cols,
                                       seq_params->bit_depth, count_buf);
  } else {
    colors_u = av1_count_colors(src_u, src_stride, rows, cols, count_buf);
    colors_v = av1_count_colors(src_v, src_stride, rows, cols, count_buf);
  }

  uint16_t color_cache[2 * PALETTE_MAX_SIZE];
  const int n_cache = av1_get_palette_cache(xd, 1, color_cache);

  colors = colors_u > colors_v ? colors_u : colors_v;
  if (colors > 1 && colors <= 64) {
    int r, c, n, i, j;
    const int max_itr = 50;
    int lb_u, ub_u, val_u;
    int lb_v, ub_v, val_v;
    int *const data = x->palette_buffer->kmeans_data_buf;
    int centroids[2 * PALETTE_MAX_SIZE];

    uint16_t *src_u16 = CONVERT_TO_SHORTPTR(src_u);
    uint16_t *src_v16 = CONVERT_TO_SHORTPTR(src_v);
    if (seq_params->use_highbitdepth) {
      lb_u = src_u16[0];
      ub_u = src_u16[0];
      lb_v = src_v16[0];
      ub_v = src_v16[0];
    } else {
      lb_u = src_u[0];
      ub_u = src_u[0];
      lb_v = src_v[0];
      ub_v = src_v[0];
    }

    for (r = 0; r < rows; ++r) {
      for (c = 0; c < cols; ++c) {
        if (seq_params->use_highbitdepth) {
          val_u = src_u16[r * src_stride + c];
          val_v = src_v16[r * src_stride + c];
          data[(r * cols + c) * 2] = val_u;
          data[(r * cols + c) * 2 + 1] = val_v;
        } else {
          val_u = src_u[r * src_stride + c];
          val_v = src_v[r * src_stride + c];
          data[(r * cols + c) * 2] = val_u;
          data[(r * cols + c) * 2 + 1] = val_v;
        }
        if (val_u < lb_u)
          lb_u = val_u;
        else if (val_u > ub_u)
          ub_u = val_u;
        if (val_v < lb_v)
          lb_v = val_v;
        else if (val_v > ub_v)
          ub_v = val_v;
      }
    }

    for (n = colors > PALETTE_MAX_SIZE ? PALETTE_MAX_SIZE : colors; n >= 2;
         --n) {
      for (i = 0; i < n; ++i) {
        centroids[i * 2] = lb_u + (2 * i + 1) * (ub_u - lb_u) / n / 2;
        centroids[i * 2 + 1] = lb_v + (2 * i + 1) * (ub_v - lb_v) / n / 2;
      }
      av1_k_means(data, centroids, color_map, rows * cols, n, 2, max_itr);
      optimize_palette_colors(color_cache, n_cache, n, 2, centroids);
      // Sort the U channel colors in ascending order.
      for (i = 0; i < 2 * (n - 1); i += 2) {
        int min_idx = i;
        int min_val = centroids[i];
        for (j = i + 2; j < 2 * n; j += 2)
          if (centroids[j] < min_val) min_val = centroids[j], min_idx = j;
        if (min_idx != i) {
          int temp_u = centroids[i], temp_v = centroids[i + 1];
          centroids[i] = centroids[min_idx];
          centroids[i + 1] = centroids[min_idx + 1];
          centroids[min_idx] = temp_u, centroids[min_idx + 1] = temp_v;
        }
      }
      av1_calc_indices(data, centroids, color_map, rows * cols, n, 2);
      extend_palette_color_map(color_map, cols, rows, plane_block_width,
                               plane_block_height);
      pmi->palette_size[1] = n;
      for (i = 1; i < 3; ++i) {
        for (j = 0; j < n; ++j) {
          if (seq_params->use_highbitdepth)
            pmi->palette_colors[i * PALETTE_MAX_SIZE + j] = clip_pixel_highbd(
                (int)centroids[j * 2 + i - 1], seq_params->bit_depth);
          else
            pmi->palette_colors[i * PALETTE_MAX_SIZE + j] =
                clip_pixel((int)centroids[j * 2 + i - 1]);
        }
      }

      av1_txfm_uvrd(cpi, x, &tokenonly_rd_stats, bsize, *best_rd);
      if (tokenonly_rd_stats.rate == INT_MAX) continue;
      this_rate = tokenonly_rd_stats.rate +
                  intra_mode_info_cost_uv(cpi, x, mbmi, bsize, dc_mode_cost);
      this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);
      if (this_rd < *best_rd) {
        *best_rd = this_rd;
        *best_mbmi = *mbmi;
        memcpy(best_palette_color_map, color_map,
               plane_block_width * plane_block_height *
                   sizeof(best_palette_color_map[0]));
        *rate = this_rate;
        *distortion = tokenonly_rd_stats.dist;
        *rate_tokenonly = tokenonly_rd_stats.rate;
        *skippable = tokenonly_rd_stats.skip;
      }
    }
  }
  if (best_mbmi->palette_mode_info.palette_size[1] > 0) {
    memcpy(color_map, best_palette_color_map,
           plane_block_width * plane_block_height *
               sizeof(best_palette_color_map[0]));
  }
}

void av1_restore_uv_color_map(const AV1_COMP *const cpi, MACROBLOCK *x) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
  const BLOCK_SIZE bsize = mbmi->sb_type;
  int src_stride = x->plane[1].src.stride;
  const uint8_t *const src_u = x->plane[1].src.buf;
  const uint8_t *const src_v = x->plane[2].src.buf;
  int *const data = x->palette_buffer->kmeans_data_buf;
  int centroids[2 * PALETTE_MAX_SIZE];
  uint8_t *const color_map = xd->plane[1].color_index_map;
  int r, c;
  const uint16_t *const src_u16 = CONVERT_TO_SHORTPTR(src_u);
  const uint16_t *const src_v16 = CONVERT_TO_SHORTPTR(src_v);
  int plane_block_width, plane_block_height, rows, cols;
  av1_get_block_dimensions(bsize, 1, xd, &plane_block_width,
                           &plane_block_height, &rows, &cols);

  for (r = 0; r < rows; ++r) {
    for (c = 0; c < cols; ++c) {
      if (cpi->common.seq_params.use_highbitdepth) {
        data[(r * cols + c) * 2] = src_u16[r * src_stride + c];
        data[(r * cols + c) * 2 + 1] = src_v16[r * src_stride + c];
      } else {
        data[(r * cols + c) * 2] = src_u[r * src_stride + c];
        data[(r * cols + c) * 2 + 1] = src_v[r * src_stride + c];
      }
    }
  }

  for (r = 1; r < 3; ++r) {
    for (c = 0; c < pmi->palette_size[1]; ++c) {
      centroids[c * 2 + r - 1] = pmi->palette_colors[r * PALETTE_MAX_SIZE + c];
    }
  }

  av1_calc_indices(data, centroids, color_map, rows * cols,
                   pmi->palette_size[1], 2);
  extend_palette_color_map(color_map, cols, rows, plane_block_width,
                           plane_block_height);
}

static AOM_INLINE void choose_intra_uv_mode(
    const AV1_COMP *const cpi, MACROBLOCK *const x, BLOCK_SIZE bsize,
    TX_SIZE max_tx_size, int *rate_uv, int *rate_uv_tokenonly, int64_t *dist_uv,
    int *skip_uv, UV_PREDICTION_MODE *mode_uv) {
  const AV1_COMMON *const cm = &cpi->common;
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  // Use an estimated rd for uv_intra based on DC_PRED if the
  // appropriate speed flag is set.
  init_sbuv_mode(mbmi);
  if (!xd->is_chroma_ref) {
    *rate_uv = 0;
    *rate_uv_tokenonly = 0;
    *dist_uv = 0;
    *skip_uv = 1;
    *mode_uv = UV_DC_PRED;
    return;
  }

  // Only store reconstructed luma when there's chroma RDO. When there's no
  // chroma RDO, the reconstructed luma will be stored in encode_superblock().
  xd->cfl.store_y = store_cfl_required_rdo(cm, x);
  if (xd->cfl.store_y) {
    // Restore reconstructed luma values.
    av1_encode_intra_block_plane(cpi, x, mbmi->sb_type, AOM_PLANE_Y,
                                 DRY_RUN_NORMAL,
                                 cpi->optimize_seg_arr[mbmi->segment_id]);
    xd->cfl.store_y = 0;
  }
  av1_rd_pick_intra_sbuv_mode(cpi, x, rate_uv, rate_uv_tokenonly, dist_uv,
                              skip_uv, bsize, max_tx_size);
  *mode_uv = mbmi->uv_mode;
}

// Run RD calculation with given chroma intra prediction angle., and return
// the RD cost. Update the best mode info. if the RD cost is the best so far.
static int64_t pick_intra_angle_routine_sbuv(
    const AV1_COMP *const cpi, MACROBLOCK *x, BLOCK_SIZE bsize,
    int rate_overhead, int64_t best_rd_in, int *rate, RD_STATS *rd_stats,
    int *best_angle_delta, int64_t *best_rd) {
  MB_MODE_INFO *mbmi = x->e_mbd.mi[0];
  assert(!is_inter_block(mbmi));
  int this_rate;
  int64_t this_rd;
  RD_STATS tokenonly_rd_stats;

  if (!av1_txfm_uvrd(cpi, x, &tokenonly_rd_stats, bsize, best_rd_in))
    return INT64_MAX;
  this_rate = tokenonly_rd_stats.rate +
              intra_mode_info_cost_uv(cpi, x, mbmi, bsize, rate_overhead);
  this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);
  if (this_rd < *best_rd) {
    *best_rd = this_rd;
    *best_angle_delta = mbmi->angle_delta[PLANE_TYPE_UV];
    *rate = this_rate;
    rd_stats->rate = tokenonly_rd_stats.rate;
    rd_stats->dist = tokenonly_rd_stats.dist;
    rd_stats->skip = tokenonly_rd_stats.skip;
  }
  return this_rd;
}

// With given chroma directional intra prediction mode, pick the best angle
// delta. Return true if a RD cost that is smaller than the input one is found.
static int rd_pick_intra_angle_sbuv(const AV1_COMP *const cpi, MACROBLOCK *x,
                                    BLOCK_SIZE bsize, int rate_overhead,
                                    int64_t best_rd, int *rate,
                                    RD_STATS *rd_stats) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  int i, angle_delta, best_angle_delta = 0;
  int64_t this_rd, best_rd_in, rd_cost[2 * (MAX_ANGLE_DELTA + 2)];

  rd_stats->rate = INT_MAX;
  rd_stats->skip = 0;
  rd_stats->dist = INT64_MAX;
  for (i = 0; i < 2 * (MAX_ANGLE_DELTA + 2); ++i) rd_cost[i] = INT64_MAX;

  for (angle_delta = 0; angle_delta <= MAX_ANGLE_DELTA; angle_delta += 2) {
    for (i = 0; i < 2; ++i) {
      best_rd_in = (best_rd == INT64_MAX)
                       ? INT64_MAX
                       : (best_rd + (best_rd >> ((angle_delta == 0) ? 3 : 5)));
      mbmi->angle_delta[PLANE_TYPE_UV] = (1 - 2 * i) * angle_delta;
      this_rd = pick_intra_angle_routine_sbuv(cpi, x, bsize, rate_overhead,
                                              best_rd_in, rate, rd_stats,
                                              &best_angle_delta, &best_rd);
      rd_cost[2 * angle_delta + i] = this_rd;
      if (angle_delta == 0) {
        if (this_rd == INT64_MAX) return 0;
        rd_cost[1] = this_rd;
        break;
      }
    }
  }

  assert(best_rd != INT64_MAX);
  for (angle_delta = 1; angle_delta <= MAX_ANGLE_DELTA; angle_delta += 2) {
    int64_t rd_thresh;
    for (i = 0; i < 2; ++i) {
      int skip_search = 0;
      rd_thresh = best_rd + (best_rd >> 5);
      if (rd_cost[2 * (angle_delta + 1) + i] > rd_thresh &&
          rd_cost[2 * (angle_delta - 1) + i] > rd_thresh)
        skip_search = 1;
      if (!skip_search) {
        mbmi->angle_delta[PLANE_TYPE_UV] = (1 - 2 * i) * angle_delta;
        pick_intra_angle_routine_sbuv(cpi, x, bsize, rate_overhead, best_rd,
                                      rate, rd_stats, &best_angle_delta,
                                      &best_rd);
      }
    }
  }

  mbmi->angle_delta[PLANE_TYPE_UV] = best_angle_delta;
  return rd_stats->rate != INT_MAX;
}

#define PLANE_SIGN_TO_JOINT_SIGN(plane, a, b) \
  (plane == CFL_PRED_U ? a * CFL_SIGNS + b - 1 : b * CFL_SIGNS + a - 1)
static int cfl_rd_pick_alpha(MACROBLOCK *const x, const AV1_COMP *const cpi,
                             TX_SIZE tx_size, int64_t best_rd) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  const MACROBLOCKD_PLANE *pd = &xd->plane[AOM_PLANE_U];
  const BLOCK_SIZE plane_bsize =
      get_plane_block_size(mbmi->sb_type, pd->subsampling_x, pd->subsampling_y);

  assert(is_cfl_allowed(xd) && cpi->oxcf.enable_cfl_intra);
  assert(plane_bsize < BLOCK_SIZES_ALL);
  if (!xd->lossless[mbmi->segment_id]) {
    assert(block_size_wide[plane_bsize] == tx_size_wide[tx_size]);
    assert(block_size_high[plane_bsize] == tx_size_high[tx_size]);
  }

  xd->cfl.use_dc_pred_cache = 1;
  const int64_t mode_rd =
      RDCOST(x->rdmult,
             x->intra_uv_mode_cost[CFL_ALLOWED][mbmi->mode][UV_CFL_PRED], 0);
  int64_t best_rd_uv[CFL_JOINT_SIGNS][CFL_PRED_PLANES];
  int best_c[CFL_JOINT_SIGNS][CFL_PRED_PLANES];
#if CONFIG_DEBUG
  int best_rate_uv[CFL_JOINT_SIGNS][CFL_PRED_PLANES];
#endif  // CONFIG_DEBUG

  const int skip_trellis = 0;
  for (int plane = 0; plane < CFL_PRED_PLANES; plane++) {
    RD_STATS rd_stats;
    av1_init_rd_stats(&rd_stats);
    for (int joint_sign = 0; joint_sign < CFL_JOINT_SIGNS; joint_sign++) {
      best_rd_uv[joint_sign][plane] = INT64_MAX;
      best_c[joint_sign][plane] = 0;
    }
    // Collect RD stats for an alpha value of zero in this plane.
    // Skip i == CFL_SIGN_ZERO as (0, 0) is invalid.
    for (int i = CFL_SIGN_NEG; i < CFL_SIGNS; i++) {
      const int8_t joint_sign =
          PLANE_SIGN_TO_JOINT_SIGN(plane, CFL_SIGN_ZERO, i);
      if (i == CFL_SIGN_NEG) {
        mbmi->cfl_alpha_idx = 0;
        mbmi->cfl_alpha_signs = joint_sign;
        av1_txfm_rd_in_plane(
            x, cpi, &rd_stats, best_rd, 0, plane + 1, plane_bsize, tx_size,
            cpi->sf.rd_sf.use_fast_coef_costing, FTXS_NONE, skip_trellis);
        if (rd_stats.rate == INT_MAX) break;
      }
      const int alpha_rate = x->cfl_cost[joint_sign][plane][0];
      best_rd_uv[joint_sign][plane] =
          RDCOST(x->rdmult, rd_stats.rate + alpha_rate, rd_stats.dist);
#if CONFIG_DEBUG
      best_rate_uv[joint_sign][plane] = rd_stats.rate;
#endif  // CONFIG_DEBUG
    }
  }

  int8_t best_joint_sign = -1;

  for (int plane = 0; plane < CFL_PRED_PLANES; plane++) {
    for (int pn_sign = CFL_SIGN_NEG; pn_sign < CFL_SIGNS; pn_sign++) {
      int progress = 0;
      for (int c = 0; c < CFL_ALPHABET_SIZE; c++) {
        int flag = 0;
        RD_STATS rd_stats;
        if (c > 2 && progress < c) break;
        av1_init_rd_stats(&rd_stats);
        for (int i = 0; i < CFL_SIGNS; i++) {
          const int8_t joint_sign = PLANE_SIGN_TO_JOINT_SIGN(plane, pn_sign, i);
          if (i == 0) {
            mbmi->cfl_alpha_idx = (c << CFL_ALPHABET_SIZE_LOG2) + c;
            mbmi->cfl_alpha_signs = joint_sign;
            av1_txfm_rd_in_plane(
                x, cpi, &rd_stats, best_rd, 0, plane + 1, plane_bsize, tx_size,
                cpi->sf.rd_sf.use_fast_coef_costing, FTXS_NONE, skip_trellis);
            if (rd_stats.rate == INT_MAX) break;
          }
          const int alpha_rate = x->cfl_cost[joint_sign][plane][c];
          int64_t this_rd =
              RDCOST(x->rdmult, rd_stats.rate + alpha_rate, rd_stats.dist);
          if (this_rd >= best_rd_uv[joint_sign][plane]) continue;
          best_rd_uv[joint_sign][plane] = this_rd;
          best_c[joint_sign][plane] = c;
#if CONFIG_DEBUG
          best_rate_uv[joint_sign][plane] = rd_stats.rate;
#endif  // CONFIG_DEBUG
          flag = 2;
          if (best_rd_uv[joint_sign][!plane] == INT64_MAX) continue;
          this_rd += mode_rd + best_rd_uv[joint_sign][!plane];
          if (this_rd >= best_rd) continue;
          best_rd = this_rd;
          best_joint_sign = joint_sign;
        }
        progress += flag;
      }
    }
  }

  int best_rate_overhead = INT_MAX;
  uint8_t ind = 0;
  if (best_joint_sign >= 0) {
    const int u = best_c[best_joint_sign][CFL_PRED_U];
    const int v = best_c[best_joint_sign][CFL_PRED_V];
    ind = (u << CFL_ALPHABET_SIZE_LOG2) + v;
    best_rate_overhead = x->cfl_cost[best_joint_sign][CFL_PRED_U][u] +
                         x->cfl_cost[best_joint_sign][CFL_PRED_V][v];
#if CONFIG_DEBUG
    xd->cfl.rate = x->intra_uv_mode_cost[CFL_ALLOWED][mbmi->mode][UV_CFL_PRED] +
                   best_rate_overhead +
                   best_rate_uv[best_joint_sign][CFL_PRED_U] +
                   best_rate_uv[best_joint_sign][CFL_PRED_V];
#endif  // CONFIG_DEBUG
  } else {
    best_joint_sign = 0;
  }

  mbmi->cfl_alpha_idx = ind;
  mbmi->cfl_alpha_signs = best_joint_sign;
  xd->cfl.use_dc_pred_cache = 0;
  xd->cfl.dc_pred_is_cached[0] = 0;
  xd->cfl.dc_pred_is_cached[1] = 0;
  return best_rate_overhead;
}

int64_t av1_rd_pick_intra_sbuv_mode(const AV1_COMP *const cpi, MACROBLOCK *x,
                                    int *rate, int *rate_tokenonly,
                                    int64_t *distortion, int *skippable,
                                    BLOCK_SIZE bsize, TX_SIZE max_tx_size) {
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  MB_MODE_INFO best_mbmi = *mbmi;
  int64_t best_rd = INT64_MAX, this_rd;

  for (int mode_idx = 0; mode_idx < UV_INTRA_MODES; ++mode_idx) {
    int this_rate;
    RD_STATS tokenonly_rd_stats;
    UV_PREDICTION_MODE mode = uv_rd_search_mode_order[mode_idx];
    const int is_directional_mode = av1_is_directional_mode(get_uv_mode(mode));
    if (!(cpi->sf.intra_sf.intra_uv_mode_mask[txsize_sqr_up_map[max_tx_size]] &
          (1 << mode)))
      continue;
    if (!cpi->oxcf.enable_smooth_intra && mode >= UV_SMOOTH_PRED &&
        mode <= UV_SMOOTH_H_PRED)
      continue;

    if (!cpi->oxcf.enable_paeth_intra && mode == UV_PAETH_PRED) continue;

    mbmi->uv_mode = mode;
    int cfl_alpha_rate = 0;
    if (mode == UV_CFL_PRED) {
      if (!is_cfl_allowed(xd) || !cpi->oxcf.enable_cfl_intra) continue;
      assert(!is_directional_mode);
      const TX_SIZE uv_tx_size = av1_get_tx_size(AOM_PLANE_U, xd);
      cfl_alpha_rate = cfl_rd_pick_alpha(x, cpi, uv_tx_size, best_rd);
      if (cfl_alpha_rate == INT_MAX) continue;
    }
    mbmi->angle_delta[PLANE_TYPE_UV] = 0;
    if (is_directional_mode && av1_use_angle_delta(mbmi->sb_type) &&
        cpi->oxcf.enable_angle_delta) {
      const int rate_overhead =
          x->intra_uv_mode_cost[is_cfl_allowed(xd)][mbmi->mode][mode];
      if (!rd_pick_intra_angle_sbuv(cpi, x, bsize, rate_overhead, best_rd,
                                    &this_rate, &tokenonly_rd_stats))
        continue;
    } else {
      if (!av1_txfm_uvrd(cpi, x, &tokenonly_rd_stats, bsize, best_rd)) {
        continue;
      }
    }
    const int mode_cost =
        x->intra_uv_mode_cost[is_cfl_allowed(xd)][mbmi->mode][mode] +
        cfl_alpha_rate;
    this_rate = tokenonly_rd_stats.rate +
                intra_mode_info_cost_uv(cpi, x, mbmi, bsize, mode_cost);
    if (mode == UV_CFL_PRED) {
      assert(is_cfl_allowed(xd) && cpi->oxcf.enable_cfl_intra);
#if CONFIG_DEBUG
      if (!xd->lossless[mbmi->segment_id])
        assert(xd->cfl.rate == tokenonly_rd_stats.rate + mode_cost);
#endif  // CONFIG_DEBUG
    }
    this_rd = RDCOST(x->rdmult, this_rate, tokenonly_rd_stats.dist);

    if (this_rd < best_rd) {
      best_mbmi = *mbmi;
      best_rd = this_rd;
      *rate = this_rate;
      *rate_tokenonly = tokenonly_rd_stats.rate;
      *distortion = tokenonly_rd_stats.dist;
      *skippable = tokenonly_rd_stats.skip;
    }
  }

  const int try_palette =
      cpi->oxcf.enable_palette &&
      av1_allow_palette(cpi->common.features.allow_screen_content_tools,
                        mbmi->sb_type);
  if (try_palette) {
    uint8_t *best_palette_color_map = x->palette_buffer->best_palette_color_map;
    rd_pick_palette_intra_sbuv(
        cpi, x,
        x->intra_uv_mode_cost[is_cfl_allowed(xd)][mbmi->mode][UV_DC_PRED],
        best_palette_color_map, &best_mbmi, &best_rd, rate, rate_tokenonly,
        distortion, skippable);
  }

  *mbmi = best_mbmi;
  // Make sure we actually chose a mode
  assert(best_rd < INT64_MAX);
  return best_rd;
}

int av1_search_palette_mode(const AV1_COMP *cpi, MACROBLOCK *x,
                            RD_STATS *this_rd_cost, PICK_MODE_CONTEXT *ctx,
                            BLOCK_SIZE bsize, MB_MODE_INFO *const mbmi,
                            PALETTE_MODE_INFO *const pmi,
                            unsigned int *ref_costs_single,
                            IntraModeSearchState *intra_search_state,
                            int64_t best_rd) {
  const AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCKD *const xd = &x->e_mbd;
  int rate2 = 0;
  int64_t distortion2 = 0, best_rd_palette = best_rd, this_rd,
          best_model_rd_palette = INT64_MAX;
  int skippable = 0;
  TX_SIZE uv_tx = TX_4X4;
  uint8_t *const best_palette_color_map =
      x->palette_buffer->best_palette_color_map;
  uint8_t *const color_map = xd->plane[0].color_index_map;
  MB_MODE_INFO best_mbmi_palette = *mbmi;
  uint8_t best_blk_skip[MAX_MIB_SIZE * MAX_MIB_SIZE];
  uint8_t best_tx_type_map[MAX_MIB_SIZE * MAX_MIB_SIZE];
  const int *const intra_mode_cost = x->mbmode_cost[size_group_lookup[bsize]];
  const int rows = block_size_high[bsize];
  const int cols = block_size_wide[bsize];

  mbmi->mode = DC_PRED;
  mbmi->uv_mode = UV_DC_PRED;
  mbmi->ref_frame[0] = INTRA_FRAME;
  mbmi->ref_frame[1] = NONE_FRAME;
  RD_STATS rd_stats_y;
  av1_invalid_rd_stats(&rd_stats_y);
  rd_pick_palette_intra_sby(
      cpi, x, bsize, intra_mode_cost[DC_PRED], &best_mbmi_palette,
      best_palette_color_map, &best_rd_palette, &best_model_rd_palette,
      &rd_stats_y.rate, NULL, &rd_stats_y.dist, &rd_stats_y.skip, NULL, ctx,
      best_blk_skip, best_tx_type_map);
  if (rd_stats_y.rate == INT_MAX || pmi->palette_size[0] == 0) {
    this_rd_cost->rdcost = INT64_MAX;
    return skippable;
  }

  memcpy(x->blk_skip, best_blk_skip,
         sizeof(best_blk_skip[0]) * bsize_to_num_blk(bsize));
  av1_copy_array(xd->tx_type_map, best_tx_type_map, ctx->num_4x4_blk);
  memcpy(color_map, best_palette_color_map,
         rows * cols * sizeof(best_palette_color_map[0]));

  skippable = rd_stats_y.skip;
  distortion2 = rd_stats_y.dist;
  rate2 = rd_stats_y.rate + ref_costs_single[INTRA_FRAME];
  if (num_planes > 1) {
    uv_tx = av1_get_tx_size(AOM_PLANE_U, xd);
    if (intra_search_state->rate_uv_intra == INT_MAX) {
      choose_intra_uv_mode(
          cpi, x, bsize, uv_tx, &intra_search_state->rate_uv_intra,
          &intra_search_state->rate_uv_tokenonly, &intra_search_state->dist_uvs,
          &intra_search_state->skip_uvs, &intra_search_state->mode_uv);
      intra_search_state->pmi_uv = *pmi;
      intra_search_state->uv_angle_delta = mbmi->angle_delta[PLANE_TYPE_UV];
    }
    mbmi->uv_mode = intra_search_state->mode_uv;
    pmi->palette_size[1] = intra_search_state->pmi_uv.palette_size[1];
    if (pmi->palette_size[1] > 0) {
      memcpy(pmi->palette_colors + PALETTE_MAX_SIZE,
             intra_search_state->pmi_uv.palette_colors + PALETTE_MAX_SIZE,
             2 * PALETTE_MAX_SIZE * sizeof(pmi->palette_colors[0]));
    }
    mbmi->angle_delta[PLANE_TYPE_UV] = intra_search_state->uv_angle_delta;
    skippable = skippable && intra_search_state->skip_uvs;
    distortion2 += intra_search_state->dist_uvs;
    rate2 += intra_search_state->rate_uv_intra;
  }

  if (skippable) {
    rate2 -= rd_stats_y.rate;
    if (num_planes > 1) rate2 -= intra_search_state->rate_uv_tokenonly;
    rate2 += x->skip_cost[av1_get_skip_context(xd)][1];
  } else {
    rate2 += x->skip_cost[av1_get_skip_context(xd)][0];
  }
  this_rd = RDCOST(x->rdmult, rate2, distortion2);
  this_rd_cost->rate = rate2;
  this_rd_cost->dist = distortion2;
  this_rd_cost->rdcost = this_rd;
  return skippable;
}

// Given selected prediction mode, search for the best tx type and size.
static AOM_INLINE int intra_block_yrd(const AV1_COMP *const cpi, MACROBLOCK *x,
                                      BLOCK_SIZE bsize, const int *bmode_costs,
                                      int64_t *best_rd, int *rate,
                                      int *rate_tokenonly, int64_t *distortion,
                                      int *skippable, MB_MODE_INFO *best_mbmi,
                                      PICK_MODE_CONTEXT *ctx) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  RD_STATS rd_stats;
  // In order to improve txfm search avoid rd based breakouts during winner
  // mode evaluation. Hence passing ref_best_rd as a maximum value
  av1_pick_uniform_tx_size_type_yrd(cpi, x, &rd_stats, bsize, INT64_MAX);
  if (rd_stats.rate == INT_MAX) return 0;
  int this_rate_tokenonly = rd_stats.rate;
  if (!xd->lossless[mbmi->segment_id] && block_signals_txsize(mbmi->sb_type)) {
    // av1_pick_uniform_tx_size_type_yrd above includes the cost of the tx_size
    // in the tokenonly rate, but for intra blocks, tx_size is always coded
    // (prediction granularity), so we account for it in the full rate,
    // not the tokenonly rate.
    this_rate_tokenonly -= tx_size_cost(x, bsize, mbmi->tx_size);
  }
  const int this_rate =
      rd_stats.rate +
      intra_mode_info_cost_y(cpi, x, mbmi, bsize, bmode_costs[mbmi->mode]);
  const int64_t this_rd = RDCOST(x->rdmult, this_rate, rd_stats.dist);
  if (this_rd < *best_rd) {
    *best_mbmi = *mbmi;
    *best_rd = this_rd;
    *rate = this_rate;
    *rate_tokenonly = this_rate_tokenonly;
    *distortion = rd_stats.dist;
    *skippable = rd_stats.skip;
    av1_copy_array(ctx->blk_skip, x->blk_skip, ctx->num_4x4_blk);
    av1_copy_array(ctx->tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
    return 1;
  }
  return 0;
}

// With given luma directional intra prediction mode, pick the best angle delta
// Return the RD cost corresponding to the best angle delta.
static int64_t rd_pick_intra_angle_sby(const AV1_COMP *const cpi, MACROBLOCK *x,
                                       int *rate, RD_STATS *rd_stats,
                                       BLOCK_SIZE bsize, int mode_cost,
                                       int64_t best_rd, int64_t *best_model_rd,
                                       int skip_model_rd_for_zero_deg) {
  MACROBLOCKD *xd = &x->e_mbd;
  MB_MODE_INFO *mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));

  int best_angle_delta = 0;
  int64_t rd_cost[2 * (MAX_ANGLE_DELTA + 2)];
  TX_SIZE best_tx_size = mbmi->tx_size;
  uint8_t best_blk_skip[MAX_MIB_SIZE * MAX_MIB_SIZE];
  uint8_t best_tx_type_map[MAX_MIB_SIZE * MAX_MIB_SIZE];

  for (int i = 0; i < 2 * (MAX_ANGLE_DELTA + 2); ++i) rd_cost[i] = INT64_MAX;

  int first_try = 1;
  for (int angle_delta = 0; angle_delta <= MAX_ANGLE_DELTA; angle_delta += 2) {
    for (int i = 0; i < 2; ++i) {
      const int64_t best_rd_in =
          (best_rd == INT64_MAX) ? INT64_MAX
                                 : (best_rd + (best_rd >> (first_try ? 3 : 5)));
      const int64_t this_rd = calc_rd_given_intra_angle(
          cpi, x, bsize, mode_cost, best_rd_in, (1 - 2 * i) * angle_delta,
          MAX_ANGLE_DELTA, rate, rd_stats, &best_angle_delta, &best_tx_size,
          &best_rd, best_model_rd, best_tx_type_map, best_blk_skip,
          (skip_model_rd_for_zero_deg & !angle_delta));
      rd_cost[2 * angle_delta + i] = this_rd;
      if (first_try && this_rd == INT64_MAX) return best_rd;
      first_try = 0;
      if (angle_delta == 0) {
        rd_cost[1] = this_rd;
        break;
      }
    }
  }

  assert(best_rd != INT64_MAX);
  for (int angle_delta = 1; angle_delta <= MAX_ANGLE_DELTA; angle_delta += 2) {
    for (int i = 0; i < 2; ++i) {
      int skip_search = 0;
      const int64_t rd_thresh = best_rd + (best_rd >> 5);
      if (rd_cost[2 * (angle_delta + 1) + i] > rd_thresh &&
          rd_cost[2 * (angle_delta - 1) + i] > rd_thresh)
        skip_search = 1;
      if (!skip_search) {
        calc_rd_given_intra_angle(
            cpi, x, bsize, mode_cost, best_rd, (1 - 2 * i) * angle_delta,
            MAX_ANGLE_DELTA, rate, rd_stats, &best_angle_delta, &best_tx_size,
            &best_rd, best_model_rd, best_tx_type_map, best_blk_skip, 0);
      }
    }
  }

  if (rd_stats->rate != INT_MAX) {
    mbmi->tx_size = best_tx_size;
    mbmi->angle_delta[PLANE_TYPE_Y] = best_angle_delta;
    const int n4 = bsize_to_num_blk(bsize);
    memcpy(x->blk_skip, best_blk_skip, sizeof(best_blk_skip[0]) * n4);
    av1_copy_array(xd->tx_type_map, best_tx_type_map, n4);
  }
  return best_rd;
}

int64_t av1_handle_intra_mode(IntraModeSearchState *intra_search_state,
                              const AV1_COMP *cpi, MACROBLOCK *x,
                              BLOCK_SIZE bsize, int ref_frame_cost,
                              const PICK_MODE_CONTEXT *ctx, int disable_skip,
                              RD_STATS *rd_stats, RD_STATS *rd_stats_y,
                              RD_STATS *rd_stats_uv, int64_t best_rd,
                              int64_t *best_intra_rd, int8_t best_mbmode_skip) {
  const AV1_COMMON *cm = &cpi->common;
  const SPEED_FEATURES *const sf = &cpi->sf;
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(mbmi->ref_frame[0] == INTRA_FRAME);
  const PREDICTION_MODE mode = mbmi->mode;
  const int mode_cost =
      x->mbmode_cost[size_group_lookup[bsize]][mode] + ref_frame_cost;
  const int intra_cost_penalty = av1_get_intra_cost_penalty(
      cm->quant_params.base_qindex, cm->quant_params.y_dc_delta_q,
      cm->seq_params.bit_depth);
  const int skip_ctx = av1_get_skip_context(xd);

  int known_rate = mode_cost;
  known_rate += ref_frame_cost;
  if (mode != DC_PRED && mode != PAETH_PRED) known_rate += intra_cost_penalty;
  known_rate += AOMMIN(x->skip_cost[skip_ctx][0], x->skip_cost[skip_ctx][1]);
  const int64_t known_rd = RDCOST(x->rdmult, known_rate, 0);
  if (known_rd > best_rd) {
    intra_search_state->skip_intra_modes = 1;
    return INT64_MAX;
  }

  const int is_directional_mode = av1_is_directional_mode(mode);
  if (is_directional_mode && av1_use_angle_delta(bsize) &&
      cpi->oxcf.enable_angle_delta) {
    if (sf->intra_sf.intra_pruning_with_hog &&
        !intra_search_state->angle_stats_ready) {
      prune_intra_mode_with_hog(x, bsize,
                                cpi->sf.intra_sf.intra_pruning_with_hog_thresh,
                                intra_search_state->directional_mode_skip_mask);
      intra_search_state->angle_stats_ready = 1;
    }
    if (intra_search_state->directional_mode_skip_mask[mode]) return INT64_MAX;
    av1_init_rd_stats(rd_stats_y);
    rd_stats_y->rate = INT_MAX;
    int64_t model_rd = INT64_MAX;
    int rate_dummy;
    rd_pick_intra_angle_sby(cpi, x, &rate_dummy, rd_stats_y, bsize, mode_cost,
                            best_rd, &model_rd, 0);

  } else {
    av1_init_rd_stats(rd_stats_y);
    mbmi->angle_delta[PLANE_TYPE_Y] = 0;
    av1_pick_uniform_tx_size_type_yrd(cpi, x, rd_stats_y, bsize, best_rd);
  }

  // Pick filter intra modes.
  if (mode == DC_PRED && av1_filter_intra_allowed_bsize(cm, bsize)) {
    int try_filter_intra = 0;
    int64_t best_rd_so_far = INT64_MAX;
    if (rd_stats_y->rate != INT_MAX) {
      const int tmp_rate =
          rd_stats_y->rate + x->filter_intra_cost[bsize][0] + mode_cost;
      best_rd_so_far = RDCOST(x->rdmult, tmp_rate, rd_stats_y->dist);
      try_filter_intra = (best_rd_so_far / 2) <= best_rd;
    } else {
      try_filter_intra = !best_mbmode_skip;
    }

    if (try_filter_intra) {
      RD_STATS rd_stats_y_fi;
      int filter_intra_selected_flag = 0;
      TX_SIZE best_tx_size = mbmi->tx_size;
      FILTER_INTRA_MODE best_fi_mode = FILTER_DC_PRED;
      uint8_t best_blk_skip[MAX_MIB_SIZE * MAX_MIB_SIZE];
      memcpy(best_blk_skip, x->blk_skip,
             sizeof(best_blk_skip[0]) * ctx->num_4x4_blk);
      uint8_t best_tx_type_map[MAX_MIB_SIZE * MAX_MIB_SIZE];
      av1_copy_array(best_tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
      mbmi->filter_intra_mode_info.use_filter_intra = 1;
      for (FILTER_INTRA_MODE fi_mode = FILTER_DC_PRED;
           fi_mode < FILTER_INTRA_MODES; ++fi_mode) {
        mbmi->filter_intra_mode_info.filter_intra_mode = fi_mode;
        av1_pick_uniform_tx_size_type_yrd(cpi, x, &rd_stats_y_fi, bsize,
                                          best_rd);
        if (rd_stats_y_fi.rate == INT_MAX) continue;
        const int this_rate_tmp =
            rd_stats_y_fi.rate +
            intra_mode_info_cost_y(cpi, x, mbmi, bsize, mode_cost);
        const int64_t this_rd_tmp =
            RDCOST(x->rdmult, this_rate_tmp, rd_stats_y_fi.dist);

        if (this_rd_tmp != INT64_MAX && this_rd_tmp / 2 > best_rd) {
          break;
        }
        if (this_rd_tmp < best_rd_so_far) {
          best_tx_size = mbmi->tx_size;
          av1_copy_array(best_tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
          memcpy(best_blk_skip, x->blk_skip,
                 sizeof(best_blk_skip[0]) * ctx->num_4x4_blk);
          best_fi_mode = fi_mode;
          *rd_stats_y = rd_stats_y_fi;
          filter_intra_selected_flag = 1;
          best_rd_so_far = this_rd_tmp;
        }
      }

      mbmi->tx_size = best_tx_size;
      av1_copy_array(xd->tx_type_map, best_tx_type_map, ctx->num_4x4_blk);
      memcpy(x->blk_skip, best_blk_skip,
             sizeof(x->blk_skip[0]) * ctx->num_4x4_blk);

      if (filter_intra_selected_flag) {
        mbmi->filter_intra_mode_info.use_filter_intra = 1;
        mbmi->filter_intra_mode_info.filter_intra_mode = best_fi_mode;
      } else {
        mbmi->filter_intra_mode_info.use_filter_intra = 0;
      }
    }
  }

  if (rd_stats_y->rate == INT_MAX) return INT64_MAX;

  const int mode_cost_y =
      intra_mode_info_cost_y(cpi, x, mbmi, bsize, mode_cost);
  av1_init_rd_stats(rd_stats);
  av1_init_rd_stats(rd_stats_uv);
  const int num_planes = av1_num_planes(cm);
  if (num_planes > 1) {
    PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
    const int try_palette =
        cpi->oxcf.enable_palette &&
        av1_allow_palette(cm->features.allow_screen_content_tools,
                          mbmi->sb_type);
    const TX_SIZE uv_tx = av1_get_tx_size(AOM_PLANE_U, xd);
    if (intra_search_state->rate_uv_intra == INT_MAX) {
      const int rate_y =
          rd_stats_y->skip ? x->skip_cost[skip_ctx][1] : rd_stats_y->rate;
      const int64_t rdy =
          RDCOST(x->rdmult, rate_y + mode_cost_y, rd_stats_y->dist);
      if (best_rd < (INT64_MAX / 2) && rdy > (best_rd + (best_rd >> 2))) {
        intra_search_state->skip_intra_modes = 1;
        return INT64_MAX;
      }
      choose_intra_uv_mode(
          cpi, x, bsize, uv_tx, &intra_search_state->rate_uv_intra,
          &intra_search_state->rate_uv_tokenonly, &intra_search_state->dist_uvs,
          &intra_search_state->skip_uvs, &intra_search_state->mode_uv);
      if (try_palette) intra_search_state->pmi_uv = *pmi;
      intra_search_state->uv_angle_delta = mbmi->angle_delta[PLANE_TYPE_UV];

      const int uv_rate = intra_search_state->rate_uv_tokenonly;
      const int64_t uv_dist = intra_search_state->dist_uvs;
      const int64_t uv_rd = RDCOST(x->rdmult, uv_rate, uv_dist);
      if (uv_rd > best_rd) {
        intra_search_state->skip_intra_modes = 1;
        return INT64_MAX;
      }
    }

    rd_stats_uv->rate = intra_search_state->rate_uv_tokenonly;
    rd_stats_uv->dist = intra_search_state->dist_uvs;
    rd_stats_uv->skip = intra_search_state->skip_uvs;
    rd_stats->skip = rd_stats_y->skip && rd_stats_uv->skip;
    mbmi->uv_mode = intra_search_state->mode_uv;
    if (try_palette) {
      pmi->palette_size[1] = intra_search_state->pmi_uv.palette_size[1];
      memcpy(pmi->palette_colors + PALETTE_MAX_SIZE,
             intra_search_state->pmi_uv.palette_colors + PALETTE_MAX_SIZE,
             2 * PALETTE_MAX_SIZE * sizeof(pmi->palette_colors[0]));
    }
    mbmi->angle_delta[PLANE_TYPE_UV] = intra_search_state->uv_angle_delta;
  }

  rd_stats->rate = rd_stats_y->rate + mode_cost_y;
  if (!xd->lossless[mbmi->segment_id] && block_signals_txsize(bsize)) {
    // av1_pick_uniform_tx_size_type_yrd above includes the cost of the tx_size
    // in the tokenonly rate, but for intra blocks, tx_size is always coded
    // (prediction granularity), so we account for it in the full rate,
    // not the tokenonly rate.
    rd_stats_y->rate -= tx_size_cost(x, bsize, mbmi->tx_size);
  }
  if (num_planes > 1 && xd->is_chroma_ref) {
    const int uv_mode_cost =
        x->intra_uv_mode_cost[is_cfl_allowed(xd)][mode][mbmi->uv_mode];
    rd_stats->rate +=
        rd_stats_uv->rate +
        intra_mode_info_cost_uv(cpi, x, mbmi, bsize, uv_mode_cost);
  }
  if (mode != DC_PRED && mode != PAETH_PRED) {
    rd_stats->rate += intra_cost_penalty;
  }

  // Intra block is always coded as non-skip
  rd_stats->skip = 0;
  rd_stats->dist = rd_stats_y->dist + rd_stats_uv->dist;
  // Add in the cost of the no skip flag.
  rd_stats->rate += x->skip_cost[skip_ctx][0];
  // Calculate the final RD estimate for this mode.
  const int64_t this_rd = RDCOST(x->rdmult, rd_stats->rate, rd_stats->dist);
  // Keep record of best intra rd
  if (this_rd < *best_intra_rd) {
    *best_intra_rd = this_rd;
    intra_search_state->best_intra_mode = mode;
  }

  if (sf->intra_sf.skip_intra_in_interframe) {
    if (best_rd < (INT64_MAX / 2) && this_rd > (best_rd + (best_rd >> 1)))
      intra_search_state->skip_intra_modes = 1;
  }

  if (!disable_skip) {
    for (int i = 0; i < REFERENCE_MODES; ++i) {
      intra_search_state->best_pred_rd[i] =
          AOMMIN(intra_search_state->best_pred_rd[i], this_rd);
    }
  }
  return this_rd;
}

// This function is used only for intra_only frames
int64_t av1_rd_pick_intra_sby_mode(const AV1_COMP *const cpi, MACROBLOCK *x,
                                   int *rate, int *rate_tokenonly,
                                   int64_t *distortion, int *skippable,
                                   BLOCK_SIZE bsize, int64_t best_rd,
                                   PICK_MODE_CONTEXT *ctx) {
  MACROBLOCKD *const xd = &x->e_mbd;
  MB_MODE_INFO *const mbmi = xd->mi[0];
  assert(!is_inter_block(mbmi));
  int64_t best_model_rd = INT64_MAX;
  int is_directional_mode;
  uint8_t directional_mode_skip_mask[INTRA_MODES] = { 0 };
  // Flag to check rd of any intra mode is better than best_rd passed to this
  // function
  int beat_best_rd = 0;
  const int *bmode_costs;
  PALETTE_MODE_INFO *const pmi = &mbmi->palette_mode_info;
  const int try_palette =
      cpi->oxcf.enable_palette &&
      av1_allow_palette(cpi->common.features.allow_screen_content_tools,
                        mbmi->sb_type);
  uint8_t *best_palette_color_map =
      try_palette ? x->palette_buffer->best_palette_color_map : NULL;
  const MB_MODE_INFO *above_mi = xd->above_mbmi;
  const MB_MODE_INFO *left_mi = xd->left_mbmi;
  const PREDICTION_MODE A = av1_above_block_mode(above_mi);
  const PREDICTION_MODE L = av1_left_block_mode(left_mi);
  const int above_ctx = intra_mode_context[A];
  const int left_ctx = intra_mode_context[L];
  bmode_costs = x->y_mode_costs[above_ctx][left_ctx];

  mbmi->angle_delta[PLANE_TYPE_Y] = 0;
  if (cpi->sf.intra_sf.intra_pruning_with_hog) {
    prune_intra_mode_with_hog(x, bsize,
                              cpi->sf.intra_sf.intra_pruning_with_hog_thresh,
                              directional_mode_skip_mask);
  }
  mbmi->filter_intra_mode_info.use_filter_intra = 0;
  pmi->palette_size[0] = 0;

  // Set params for mode evaluation
  set_mode_eval_params(cpi, x, MODE_EVAL);

  MB_MODE_INFO best_mbmi = *mbmi;
  av1_zero(x->winner_mode_stats);
  x->winner_mode_count = 0;

  /* Y Search for intra prediction mode */
  for (int mode_idx = INTRA_MODE_START; mode_idx < INTRA_MODE_END; ++mode_idx) {
    RD_STATS this_rd_stats;
    int this_rate, this_rate_tokenonly, s;
    int64_t this_distortion, this_rd;
    mbmi->mode = intra_rd_search_mode_order[mode_idx];
    if ((!cpi->oxcf.enable_smooth_intra ||
         cpi->sf.intra_sf.disable_smooth_intra) &&
        (mbmi->mode == SMOOTH_PRED || mbmi->mode == SMOOTH_H_PRED ||
         mbmi->mode == SMOOTH_V_PRED))
      continue;
    if (!cpi->oxcf.enable_paeth_intra && mbmi->mode == PAETH_PRED) continue;
    mbmi->angle_delta[PLANE_TYPE_Y] = 0;

    if (model_intra_yrd_and_prune(cpi, x, bsize, bmode_costs[mbmi->mode],
                                  &best_model_rd)) {
      continue;
    }

    is_directional_mode = av1_is_directional_mode(mbmi->mode);
    if (is_directional_mode && directional_mode_skip_mask[mbmi->mode]) continue;
    if (is_directional_mode && av1_use_angle_delta(bsize) &&
        cpi->oxcf.enable_angle_delta) {
      this_rd_stats.rate = INT_MAX;
      rd_pick_intra_angle_sby(cpi, x, &this_rate, &this_rd_stats, bsize,
                              bmode_costs[mbmi->mode], best_rd, &best_model_rd,
                              1);
    } else {
      av1_pick_uniform_tx_size_type_yrd(cpi, x, &this_rd_stats, bsize, best_rd);
    }
    this_rate_tokenonly = this_rd_stats.rate;
    this_distortion = this_rd_stats.dist;
    s = this_rd_stats.skip;

    if (this_rate_tokenonly == INT_MAX) continue;

    if (!xd->lossless[mbmi->segment_id] &&
        block_signals_txsize(mbmi->sb_type)) {
      // av1_pick_uniform_tx_size_type_yrd above includes the cost of the
      // tx_size in the tokenonly rate, but for intra blocks, tx_size is always
      // coded (prediction granularity), so we account for it in the full rate,
      // not the tokenonly rate.
      this_rate_tokenonly -= tx_size_cost(x, bsize, mbmi->tx_size);
    }
    this_rate =
        this_rd_stats.rate +
        intra_mode_info_cost_y(cpi, x, mbmi, bsize, bmode_costs[mbmi->mode]);
    this_rd = RDCOST(x->rdmult, this_rate, this_distortion);
    // Collect mode stats for multiwinner mode processing
    const int txfm_search_done = 1;
    store_winner_mode_stats(
        &cpi->common, x, mbmi, NULL, NULL, NULL, 0, NULL, bsize, this_rd,
        cpi->sf.winner_mode_sf.enable_multiwinner_mode_process,
        txfm_search_done);
    if (this_rd < best_rd) {
      best_mbmi = *mbmi;
      best_rd = this_rd;
      // Setting beat_best_rd flag because current mode rd is better than
      // best_rd passed to this function
      beat_best_rd = 1;
      *rate = this_rate;
      *rate_tokenonly = this_rate_tokenonly;
      *distortion = this_distortion;
      *skippable = s;
      memcpy(ctx->blk_skip, x->blk_skip,
             sizeof(x->blk_skip[0]) * ctx->num_4x4_blk);
      av1_copy_array(ctx->tx_type_map, xd->tx_type_map, ctx->num_4x4_blk);
    }
  }

  if (try_palette) {
    rd_pick_palette_intra_sby(
        cpi, x, bsize, bmode_costs[DC_PRED], &best_mbmi, best_palette_color_map,
        &best_rd, &best_model_rd, rate, rate_tokenonly, distortion, skippable,
        &beat_best_rd, ctx, ctx->blk_skip, ctx->tx_type_map);
  }

  if (beat_best_rd && av1_filter_intra_allowed_bsize(&cpi->common, bsize)) {
    if (rd_pick_filter_intra_sby(cpi, x, rate, rate_tokenonly, distortion,
                                 skippable, bsize, bmode_costs[DC_PRED],
                                 &best_rd, &best_model_rd, ctx)) {
      best_mbmi = *mbmi;
    }
  }
  // No mode is identified with less rd value than best_rd passed to this
  // function. In such cases winner mode processing is not necessary and return
  // best_rd as INT64_MAX to indicate best mode is not identified
  if (!beat_best_rd) return INT64_MAX;

  // In multi-winner mode processing, perform tx search for few best modes
  // identified during mode evaluation. Winner mode processing uses best tx
  // configuration for tx search.
  if (cpi->sf.winner_mode_sf.enable_multiwinner_mode_process) {
    int best_mode_idx = 0;
    int block_width, block_height;
    uint8_t *color_map_dst = xd->plane[PLANE_TYPE_Y].color_index_map;
    av1_get_block_dimensions(bsize, AOM_PLANE_Y, xd, &block_width,
                             &block_height, NULL, NULL);

    for (int mode_idx = 0; mode_idx < x->winner_mode_count; mode_idx++) {
      *mbmi = x->winner_mode_stats[mode_idx].mbmi;
      if (is_winner_mode_processing_enabled(cpi, mbmi, mbmi->mode)) {
        // Restore color_map of palette mode before winner mode processing
        if (mbmi->palette_mode_info.palette_size[0] > 0) {
          uint8_t *color_map_src =
              x->winner_mode_stats[mode_idx].color_index_map;
          memcpy(color_map_dst, color_map_src,
                 block_width * block_height * sizeof(*color_map_src));
        }
        // Set params for winner mode evaluation
        set_mode_eval_params(cpi, x, WINNER_MODE_EVAL);

        // Winner mode processing
        // If previous searches use only the default tx type/no R-D optimization
        // of quantized coeffs, do an extra search for the best tx type/better
        // R-D optimization of quantized coeffs
        if (intra_block_yrd(cpi, x, bsize, bmode_costs, &best_rd, rate,
                            rate_tokenonly, distortion, skippable, &best_mbmi,
                            ctx))
          best_mode_idx = mode_idx;
      }
    }
    // Copy color_map of palette mode for final winner mode
    if (best_mbmi.palette_mode_info.palette_size[0] > 0) {
      uint8_t *color_map_src =
          x->winner_mode_stats[best_mode_idx].color_index_map;
      memcpy(color_map_dst, color_map_src,
             block_width * block_height * sizeof(*color_map_src));
    }
  } else {
    // If previous searches use only the default tx type/no R-D optimization of
    // quantized coeffs, do an extra search for the best tx type/better R-D
    // optimization of quantized coeffs
    if (is_winner_mode_processing_enabled(cpi, mbmi, best_mbmi.mode)) {
      // Set params for winner mode evaluation
      set_mode_eval_params(cpi, x, WINNER_MODE_EVAL);
      *mbmi = best_mbmi;
      intra_block_yrd(cpi, x, bsize, bmode_costs, &best_rd, rate,
                      rate_tokenonly, distortion, skippable, &best_mbmi, ctx);
    }
  }
  *mbmi = best_mbmi;
  av1_copy_array(xd->tx_type_map, ctx->tx_type_map, ctx->num_4x4_blk);
  return best_rd;
}
