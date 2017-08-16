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

#include "./aom_config.h"
#if !CONFIG_PVQ
#include "aom_mem/aom_mem.h"
#include "aom_ports/mem.h"
#endif  // !CONFIG_PVQ

#include "av1/common/blockd.h"

#define ACCT_STR __func__

#if !CONFIG_PVQ || CONFIG_VAR_TX
#include "av1/common/common.h"
#include "av1/common/entropy.h"
#include "av1/common/idct.h"
#include "av1/decoder/detokenize.h"

#define EOB_CONTEXT_NODE 0
#define ZERO_CONTEXT_NODE 1
#define ONE_CONTEXT_NODE 2
#define LOW_VAL_CONTEXT_NODE 0
#define TWO_CONTEXT_NODE 1
#define THREE_CONTEXT_NODE 2
#define HIGH_LOW_CONTEXT_NODE 3
#define CAT_ONE_CONTEXT_NODE 4
#define CAT_THREEFOUR_CONTEXT_NODE 5
#define CAT_THREE_CONTEXT_NODE 6
#define CAT_FIVE_CONTEXT_NODE 7

#define INCREMENT_COUNT(token)                   \
  do {                                           \
    if (counts) ++coef_counts[band][ctx][token]; \
  } while (0)

#if CONFIG_NEW_MULTISYMBOL
#define READ_COEFF(prob_name, cdf_name, num, r) read_coeff(cdf_name, num, r);
static INLINE int read_coeff(const aom_cdf_prob *const *cdf, int n,
                             aom_reader *r) {
  int val = 0;
  int i = 0;
  int count = 0;
  while (count < n) {
    const int size = AOMMIN(n - count, 4);
    val |= aom_read_cdf(r, cdf[i++], 1 << size, ACCT_STR) << count;
    count += size;
  }
  return val;
}
#else
#define READ_COEFF(prob_name, cdf_name, num, r) read_coeff(prob_name, num, r);
static INLINE int read_coeff(const aom_prob *probs, int n, aom_reader *r) {
  int i, val = 0;
  for (i = 0; i < n; ++i) val = (val << 1) | aom_read(r, probs[i], ACCT_STR);
  return val;
}

#endif

static int token_to_value(aom_reader *const r, int token, TX_SIZE tx_size,
                          int bit_depth) {
#if !CONFIG_HIGHBITDEPTH
  assert(bit_depth == 8);
#endif  // !CONFIG_HIGHBITDEPTH

  switch (token) {
    case ZERO_TOKEN:
    case ONE_TOKEN:
    case TWO_TOKEN:
    case THREE_TOKEN:
    case FOUR_TOKEN: return token;
    case CATEGORY1_TOKEN:
      return CAT1_MIN_VAL + READ_COEFF(av1_cat1_prob, av1_cat1_cdf, 1, r);
    case CATEGORY2_TOKEN:
      return CAT2_MIN_VAL + READ_COEFF(av1_cat2_prob, av1_cat2_cdf, 2, r);
    case CATEGORY3_TOKEN:
      return CAT3_MIN_VAL + READ_COEFF(av1_cat3_prob, av1_cat3_cdf, 3, r);
    case CATEGORY4_TOKEN:
      return CAT4_MIN_VAL + READ_COEFF(av1_cat4_prob, av1_cat4_cdf, 4, r);
    case CATEGORY5_TOKEN:
      return CAT5_MIN_VAL + READ_COEFF(av1_cat5_prob, av1_cat5_cdf, 5, r);
    case CATEGORY6_TOKEN: {
      const int skip_bits = (int)sizeof(av1_cat6_prob) -
                            av1_get_cat6_extrabits_size(tx_size, bit_depth);
      return CAT6_MIN_VAL + READ_COEFF(av1_cat6_prob + skip_bits, av1_cat6_cdf,
                                       18 - skip_bits, r);
    }
    default:
      assert(0);  // Invalid token.
      return -1;
  }
}

static int decode_coefs(MACROBLOCKD *xd, PLANE_TYPE type, tran_low_t *dqcoeff,
                        TX_SIZE tx_size, TX_TYPE tx_type, const int16_t *dq,
#if CONFIG_NEW_QUANT
                        dequant_val_type_nuq *dq_val,
#endif  // CONFIG_NEW_QUANT
#if CONFIG_AOM_QM
                        const qm_val_t *iqm[2][TX_SIZES_ALL],
#endif  // CONFIG_AOM_QM
                        int ctx, const int16_t *scan, const int16_t *nb,
                        int16_t *max_scan_line, aom_reader *r) {
  FRAME_COUNTS *counts = xd->counts;
#if CONFIG_EC_ADAPT
  FRAME_CONTEXT *ec_ctx = xd->tile_ctx;
#else
  FRAME_CONTEXT *const ec_ctx = xd->fc;
#endif
  const int max_eob = tx_size_2d[tx_size];
  const int ref = is_inter_block(&xd->mi[0]->mbmi);
#if CONFIG_AOM_QM
  const qm_val_t *iqmatrix = iqm[!ref][tx_size];
#endif  // CONFIG_AOM_QM
  int band, c = 0;
  const int tx_size_ctx = txsize_sqr_map[tx_size];
  aom_cdf_prob(*coef_head_cdfs)[COEFF_CONTEXTS][CDF_SIZE(ENTROPY_TOKENS)] =
      ec_ctx->coef_head_cdfs[tx_size_ctx][type][ref];
  aom_cdf_prob(*coef_tail_cdfs)[COEFF_CONTEXTS][CDF_SIZE(ENTROPY_TOKENS)] =
      ec_ctx->coef_tail_cdfs[tx_size_ctx][type][ref];
  int val = 0;

#if !CONFIG_EC_ADAPT
  unsigned int *blockz_count;
  unsigned int(*coef_counts)[COEFF_CONTEXTS][UNCONSTRAINED_NODES + 1] = NULL;
  unsigned int(*eob_branch_count)[COEFF_CONTEXTS] = NULL;
#endif
  uint8_t token_cache[MAX_TX_SQUARE];
  const uint8_t *band_translate = get_band_translate(tx_size);
  int dq_shift;
  int v, token;
  int16_t dqv = dq[0];
#if CONFIG_NEW_QUANT
  const tran_low_t *dqv_val = &dq_val[0][0];
#endif  // CONFIG_NEW_QUANT
  (void)tx_type;

  if (counts) {
#if !CONFIG_EC_ADAPT
    coef_counts = counts->coef[tx_size_ctx][type][ref];
    eob_branch_count = counts->eob_branch[tx_size_ctx][type][ref];
    blockz_count = counts->blockz_count[tx_size_ctx][type][ref][ctx];
#endif
  }

  dq_shift = av1_get_tx_scale(tx_size);

  band = *band_translate++;

  int more_data = 1;
  while (more_data) {
    int comb_token;
    int last_pos = (c + 1 == max_eob);
    int first_pos = (c == 0);

#if CONFIG_NEW_QUANT
    dqv_val = &dq_val[band][0];
#endif  // CONFIG_NEW_QUANT

    comb_token = last_pos ? 2 * aom_read_bit(r, ACCT_STR) + 2
                          : aom_read_symbol(r, coef_head_cdfs[band][ctx],
                                            HEAD_TOKENS + first_pos, ACCT_STR) +
                                !first_pos;
    if (first_pos) {
#if !CONFIG_EC_ADAPT
      if (counts) ++blockz_count[comb_token != 0];
#endif
      if (comb_token == 0) return 0;
    }
    token = comb_token >> 1;

    while (!token) {
      *max_scan_line = AOMMAX(*max_scan_line, scan[c]);
      token_cache[scan[c]] = 0;
#if !CONFIG_EC_ADAPT
      if (counts && !last_pos) {
        ++coef_counts[band][ctx][ZERO_TOKEN];
      }
#endif
      ++c;
      dqv = dq[1];
      ctx = get_coef_context(nb, token_cache, c);
      band = *band_translate++;

      last_pos = (c + 1 == max_eob);

      comb_token = last_pos ? 2 * aom_read_bit(r, ACCT_STR) + 2
                            : aom_read_symbol(r, coef_head_cdfs[band][ctx],
                                              HEAD_TOKENS, ACCT_STR) +
                                  1;
      token = comb_token >> 1;
    }

    more_data = comb_token & 1;
#if !CONFIG_EC_ADAPT
    if (counts && !last_pos) {
      ++coef_counts[band][ctx][token];
      ++eob_branch_count[band][ctx];
      if (!more_data) ++coef_counts[band][ctx][EOB_MODEL_TOKEN];
    }
#endif

    if (token > ONE_TOKEN)
      token +=
          aom_read_symbol(r, coef_tail_cdfs[band][ctx], TAIL_TOKENS, ACCT_STR);
#if CONFIG_NEW_QUANT
    dqv_val = &dq_val[band][0];
#endif  // CONFIG_NEW_QUANT

    *max_scan_line = AOMMAX(*max_scan_line, scan[c]);
    token_cache[scan[c]] = av1_pt_energy_class[token];

    val = token_to_value(r, token, tx_size, xd->bd);

#if CONFIG_NEW_QUANT
    v = av1_dequant_abscoeff_nuq(val, dqv, dqv_val);
    v = dq_shift ? ROUND_POWER_OF_TWO(v, dq_shift) : v;
#else
#if CONFIG_AOM_QM
    dqv = ((iqmatrix[scan[c]] * (int)dqv) + (1 << (AOM_QM_BITS - 1))) >>
          AOM_QM_BITS;
#endif
    v = (val * dqv) >> dq_shift;
#endif

    v = aom_read_bit(r, ACCT_STR) ? -v : v;
#if CONFIG_COEFFICIENT_RANGE_CHECKING
    check_range(v, xd->bd);
#endif  // CONFIG_COEFFICIENT_RANGE_CHECKING

    dqcoeff[scan[c]] = v;

    ++c;
    more_data &= (c < max_eob);
    if (!more_data) break;
    dqv = dq[1];
    ctx = get_coef_context(nb, token_cache, c);
    band = *band_translate++;
  }

  return c;
}
#endif  // !CONFIG_PVQ

#if CONFIG_PALETTE
void av1_decode_palette_tokens(MACROBLOCKD *const xd, int plane,
                               aom_reader *r) {
  const MODE_INFO *const mi = xd->mi[0];
  const MB_MODE_INFO *const mbmi = &mi->mbmi;
  uint8_t color_order[PALETTE_MAX_SIZE];
  const int n = mbmi->palette_mode_info.palette_size[plane];
  int i, j;
  uint8_t *const color_map = xd->plane[plane].color_index_map;
  const aom_prob(
      *const prob)[PALETTE_COLOR_INDEX_CONTEXTS][PALETTE_COLORS - 1] =
      plane ? av1_default_palette_uv_color_index_prob
            : av1_default_palette_y_color_index_prob;
  int plane_block_width, plane_block_height, rows, cols;
  av1_get_block_dimensions(mbmi->sb_type, plane, xd, &plane_block_width,
                           &plane_block_height, &rows, &cols);
  assert(plane == 0 || plane == 1);

#if CONFIG_PALETTE_THROUGHPUT
  // Run wavefront on the palette map index decoding.
  for (i = 1; i < rows + cols - 1; ++i) {
    for (j = AOMMIN(i, cols - 1); j >= AOMMAX(0, i - rows + 1); --j) {
      const int color_ctx = av1_get_palette_color_index_context(
          color_map, plane_block_width, (i - j), j, n, color_order, NULL);
      const int color_idx =
          aom_read_tree(r, av1_palette_color_index_tree[n - 2],
                        prob[n - 2][color_ctx], ACCT_STR);
      assert(color_idx >= 0 && color_idx < n);
      color_map[(i - j) * plane_block_width + j] = color_order[color_idx];
    }
  }
  // Copy last column to extra columns.
  if (cols < plane_block_width) {
    for (i = 0; i < plane_block_height; ++i) {
      memset(color_map + i * plane_block_width + cols,
             color_map[i * plane_block_width + cols - 1],
             (plane_block_width - cols));
    }
  }
#else
  for (i = 0; i < rows; ++i) {
    for (j = (i == 0 ? 1 : 0); j < cols; ++j) {
      const int color_ctx = av1_get_palette_color_index_context(
          color_map, plane_block_width, i, j, n, color_order, NULL);
      const int color_idx =
          aom_read_tree(r, av1_palette_color_index_tree[n - PALETTE_MIN_SIZE],
                        prob[n - PALETTE_MIN_SIZE][color_ctx], ACCT_STR);
      assert(color_idx >= 0 && color_idx < n);
      color_map[i * plane_block_width + j] = color_order[color_idx];
    }
    memset(color_map + i * plane_block_width + cols,
           color_map[i * plane_block_width + cols - 1],
           (plane_block_width - cols));  // Copy last column to extra columns.
  }
#endif  // CONFIG_PALETTE_THROUGHPUT
  // Copy last row to extra rows.
  for (i = rows; i < plane_block_height; ++i) {
    memcpy(color_map + i * plane_block_width,
           color_map + (rows - 1) * plane_block_width, plane_block_width);
  }
}
#endif  // CONFIG_PALETTE

#if !CONFIG_PVQ || CONFIG_VAR_TX
int av1_decode_block_tokens(AV1_COMMON *cm, MACROBLOCKD *const xd, int plane,
                            const SCAN_ORDER *sc, int x, int y, TX_SIZE tx_size,
                            TX_TYPE tx_type, int16_t *max_scan_line,
                            aom_reader *r, int seg_id) {
  struct macroblockd_plane *const pd = &xd->plane[plane];
  const int16_t *const dequant = pd->seg_dequant[seg_id];
  const int ctx =
      get_entropy_context(tx_size, pd->above_context + x, pd->left_context + y);
#if CONFIG_NEW_QUANT
  const int ref = is_inter_block(&xd->mi[0]->mbmi);
  int dq =
      get_dq_profile_from_ctx(xd->qindex[seg_id], ctx, ref, pd->plane_type);
#endif  //  CONFIG_NEW_QUANT

  const int eob =
      decode_coefs(xd, pd->plane_type, pd->dqcoeff, tx_size, tx_type, dequant,
#if CONFIG_NEW_QUANT
                   pd->seg_dequant_nuq[seg_id][dq],
#endif  // CONFIG_NEW_QUANT
#if CONFIG_AOM_QM
                   pd->seg_iqmatrix[seg_id],
#endif  // CONFIG_AOM_QM
                   ctx, sc->scan, sc->neighbors, max_scan_line, r);
  av1_set_contexts(xd, pd, plane, tx_size, eob > 0, x, y);
#if CONFIG_ADAPT_SCAN
  if (xd->counts)
    av1_update_scan_count_facade(cm, xd->counts, tx_size, tx_type, pd->dqcoeff,
                                 eob);
#else
  (void)cm;
#endif
  return eob;
}
#endif  // !CONFIG_PVQ
