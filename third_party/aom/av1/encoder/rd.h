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

#ifndef AOM_AV1_ENCODER_RD_H_
#define AOM_AV1_ENCODER_RD_H_

#include <limits.h>

#include "av1/common/blockd.h"

#include "av1/encoder/block.h"
#include "av1/encoder/context_tree.h"
#include "av1/encoder/cost.h"

#ifdef __cplusplus
extern "C" {
#endif

#define RDDIV_BITS 7
#define RD_EPB_SHIFT 6

#define RDCOST(RM, R, D)                                            \
  (ROUND_POWER_OF_TWO(((int64_t)(R)) * (RM), AV1_PROB_COST_SHIFT) + \
   ((D) * (1 << RDDIV_BITS)))

#define RDCOST_NEG_R(RM, R, D) \
  (((D) * (1 << RDDIV_BITS)) - \
   ROUND_POWER_OF_TWO(((int64_t)(R)) * (RM), AV1_PROB_COST_SHIFT))

#define RDCOST_DBL(RM, R, D)                                       \
  (((((double)(R)) * (RM)) / (double)(1 << AV1_PROB_COST_SHIFT)) + \
   ((double)(D) * (1 << RDDIV_BITS)))

#define QIDX_SKIP_THRESH 115

#define MV_COST_WEIGHT 108
#define MV_COST_WEIGHT_SUB 120

// The fractional part of rd_thresh factor is stored with 5 bits. The maximum
// factor that we allow is two, which is stored as 2 ** (5+1) = 64
#define RD_THRESH_FAC_FRAC_BITS (5)
#define RD_THRESH_FAC_FRAC_VAL (1 << (RD_THRESH_FAC_FRAC_BITS))
#define RD_THRESH_MAX_FACT ((RD_THRESH_FAC_FRAC_VAL) << 1)
#define RD_THRESH_LOG_DEC_FACTOR (4)
#define RD_THRESH_INC (1)

// Factor to weigh the rate for switchable interp filters.
#define SWITCHABLE_INTERP_RATE_FACTOR 1

enum {
  // Default initialization when we are not using winner mode framework. e.g.
  // intrabc
  DEFAULT_EVAL = 0,
  // Initialization for selecting winner mode
  MODE_EVAL,
  // Initialization for winner mode evaluation
  WINNER_MODE_EVAL,
  // All mode evaluation types
  MODE_EVAL_TYPES,
} UENUM1BYTE(MODE_EVAL_TYPE);

typedef struct RD_OPT {
  // Thresh_mult is used to set a threshold for the rd score. A higher value
  // means that we will accept the best mode so far more often. This number
  // is used in combination with the current block size, and thresh_freq_fact
  // to pick a threshold.
  int thresh_mult[MAX_MODES];

  int threshes[MAX_SEGMENTS][BLOCK_SIZES_ALL][MAX_MODES];

  int RDMULT;

  double r0, arf_r0;
  double mc_saved_base, mc_count_base;
} RD_OPT;

typedef struct {
  // Cost of transmitting the actual motion vector.
  // mv_component[0][i] is the cost of motion vector with horizontal component
  // (mv_row) equal to i - MV_MAX.
  // mv_component[1][i] is the cost of motion vector with vertical component
  // (mv_col) equal to i - MV_MAX.
  int mv_component[2][MV_VALS];

  // joint_mv[i] is the cost of transmitting joint mv(MV_JOINT_TYPE) of
  // type i.
  // TODO(huisu@google.com): we can update dv_joint_cost per SB.
  int joint_mv[MV_JOINTS];
} IntraBCMVCosts;

static INLINE void av1_init_rd_stats(RD_STATS *rd_stats) {
#if CONFIG_RD_DEBUG
  int plane;
#endif
  rd_stats->rate = 0;
  rd_stats->dist = 0;
  rd_stats->rdcost = 0;
  rd_stats->sse = 0;
  rd_stats->skip = 1;
  rd_stats->zero_rate = 0;
#if CONFIG_RD_DEBUG
  // This may run into problems when monochrome video is
  // encoded, as there will only be 1 plane
  for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
    rd_stats->txb_coeff_cost[plane] = 0;
    {
      int r, c;
      for (r = 0; r < TXB_COEFF_COST_MAP_SIZE; ++r)
        for (c = 0; c < TXB_COEFF_COST_MAP_SIZE; ++c)
          rd_stats->txb_coeff_cost_map[plane][r][c] = 0;
    }
  }
#endif
}

static INLINE void av1_invalid_rd_stats(RD_STATS *rd_stats) {
#if CONFIG_RD_DEBUG
  int plane;
#endif
  rd_stats->rate = INT_MAX;
  rd_stats->dist = INT64_MAX;
  rd_stats->rdcost = INT64_MAX;
  rd_stats->sse = INT64_MAX;
  rd_stats->skip = 0;
  rd_stats->zero_rate = 0;
#if CONFIG_RD_DEBUG
  // This may run into problems when monochrome video is
  // encoded, as there will only be 1 plane
  for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
    rd_stats->txb_coeff_cost[plane] = INT_MAX;
    {
      int r, c;
      for (r = 0; r < TXB_COEFF_COST_MAP_SIZE; ++r)
        for (c = 0; c < TXB_COEFF_COST_MAP_SIZE; ++c)
          rd_stats->txb_coeff_cost_map[plane][r][c] = INT16_MAX;
    }
  }
#endif
}

static INLINE void av1_merge_rd_stats(RD_STATS *rd_stats_dst,
                                      const RD_STATS *rd_stats_src) {
  assert(rd_stats_dst->rate != INT_MAX && rd_stats_src->rate != INT_MAX);
  rd_stats_dst->rate = (int)AOMMIN(
      ((int64_t)rd_stats_dst->rate + (int64_t)rd_stats_src->rate), INT_MAX);
  if (!rd_stats_dst->zero_rate)
    rd_stats_dst->zero_rate = rd_stats_src->zero_rate;
  rd_stats_dst->dist += rd_stats_src->dist;
  rd_stats_dst->sse += rd_stats_src->sse;
  rd_stats_dst->skip &= rd_stats_src->skip;
#if CONFIG_RD_DEBUG
  // This may run into problems when monochrome video is
  // encoded, as there will only be 1 plane
  for (int plane = 0; plane < MAX_MB_PLANE; ++plane) {
    rd_stats_dst->txb_coeff_cost[plane] += rd_stats_src->txb_coeff_cost[plane];
    {
      // TODO(angiebird): optimize this part
      int r, c;
      int ref_txb_coeff_cost = 0;
      for (r = 0; r < TXB_COEFF_COST_MAP_SIZE; ++r)
        for (c = 0; c < TXB_COEFF_COST_MAP_SIZE; ++c) {
          rd_stats_dst->txb_coeff_cost_map[plane][r][c] +=
              rd_stats_src->txb_coeff_cost_map[plane][r][c];
          ref_txb_coeff_cost += rd_stats_dst->txb_coeff_cost_map[plane][r][c];
        }
      assert(ref_txb_coeff_cost == rd_stats_dst->txb_coeff_cost[plane]);
    }
  }
#endif
}

static INLINE void av1_accumulate_rd_stats(RD_STATS *rd_stats, int64_t dist,
                                           int rate, int skip, int64_t sse,
                                           int zero_rate) {
  assert(rd_stats->rate != INT_MAX && rate != INT_MAX);
  rd_stats->rate += rate;
  if (!rd_stats->zero_rate) rd_stats->zero_rate = zero_rate;
  rd_stats->dist += dist;
  rd_stats->skip &= skip;
  rd_stats->sse += sse;
}

static INLINE int64_t av1_calculate_rd_cost(int mult, int rate, int64_t dist) {
  assert(mult >= 0);
  if (rate >= 0) {
    return RDCOST(mult, rate, dist);
  }
  return RDCOST_NEG_R(mult, -rate, dist);
}

static INLINE void av1_rd_cost_update(int mult, RD_STATS *rd_cost) {
  if (rd_cost->rate < INT_MAX && rd_cost->dist < INT64_MAX &&
      rd_cost->rdcost < INT64_MAX) {
    rd_cost->rdcost = av1_calculate_rd_cost(mult, rd_cost->rate, rd_cost->dist);
  } else {
    av1_invalid_rd_stats(rd_cost);
  }
}

static INLINE void av1_rd_stats_subtraction(int mult,
                                            const RD_STATS *const left,
                                            const RD_STATS *const right,
                                            RD_STATS *result) {
  if (left->rate == INT_MAX || right->rate == INT_MAX ||
      left->dist == INT64_MAX || right->dist == INT64_MAX ||
      left->rdcost == INT64_MAX || right->rdcost == INT64_MAX) {
    av1_invalid_rd_stats(result);
  } else {
    result->rate = left->rate - right->rate;
    result->dist = left->dist - right->dist;
    result->rdcost = av1_calculate_rd_cost(mult, result->rate, result->dist);
  }
}

struct TileInfo;
struct TileDataEnc;
struct AV1_COMP;
struct macroblock;

int av1_compute_rd_mult_based_on_qindex(const struct AV1_COMP *cpi, int qindex);

int av1_compute_rd_mult(const struct AV1_COMP *cpi, int qindex);

void av1_initialize_rd_consts(struct AV1_COMP *cpi);

void av1_initialize_me_consts(const struct AV1_COMP *cpi, MACROBLOCK *x,
                              int qindex);

void av1_model_rd_from_var_lapndz(int64_t var, unsigned int n,
                                  unsigned int qstep, int *rate, int64_t *dist);

void av1_model_rd_curvfit(BLOCK_SIZE bsize, double sse_norm, double xqr,
                          double *rate_f, double *distbysse_f);
void av1_model_rd_surffit(BLOCK_SIZE bsize, double sse_norm, double xm,
                          double yl, double *rate_f, double *distbysse_f);

int av1_get_switchable_rate(const MACROBLOCK *x, const MACROBLOCKD *xd,
                            InterpFilter interp_filter);

YV12_BUFFER_CONFIG *av1_get_scaled_ref_frame(const struct AV1_COMP *cpi,
                                             int ref_frame);

void av1_init_me_luts(void);

void av1_set_mvcost(MACROBLOCK *x, int ref, int ref_mv_idx);

void av1_get_entropy_contexts(BLOCK_SIZE plane_bsize,
                              const struct macroblockd_plane *pd,
                              ENTROPY_CONTEXT t_above[MAX_MIB_SIZE],
                              ENTROPY_CONTEXT t_left[MAX_MIB_SIZE]);

void av1_set_rd_speed_thresholds(struct AV1_COMP *cpi);

void av1_update_rd_thresh_fact(const AV1_COMMON *const cm,
                               int (*fact)[MAX_MODES], int rd_thresh,
                               BLOCK_SIZE bsize, THR_MODES best_mode_index);

static INLINE void reset_thresh_freq_fact(MACROBLOCK *const x) {
  for (int i = 0; i < BLOCK_SIZES_ALL; ++i) {
    for (int j = 0; j < MAX_MODES; ++j) {
      x->thresh_freq_fact[i][j] = RD_THRESH_FAC_FRAC_VAL;
    }
  }
}

static INLINE int rd_less_than_thresh(int64_t best_rd, int thresh,
                                      int thresh_fact) {
  return best_rd < ((int64_t)thresh * thresh_fact >> 5) || thresh == INT_MAX;
}

void av1_mv_pred(const struct AV1_COMP *cpi, MACROBLOCK *x,
                 uint8_t *ref_y_buffer, int ref_y_stride, int ref_frame,
                 BLOCK_SIZE block_size);

static INLINE void set_error_per_bit(MACROBLOCK *x, int rdmult) {
  x->errorperbit = rdmult >> RD_EPB_SHIFT;
  x->errorperbit += (x->errorperbit == 0);
}

// Get the threshold for R-D optimization of coefficients depending upon mode
// decision/winner mode processing
static INLINE uint32_t get_rd_opt_coeff_thresh(
    const uint32_t *const coeff_opt_dist_threshold,
    int enable_winner_mode_for_coeff_opt, int is_winner_mode) {
  // Default initialization of threshold
  uint32_t coeff_opt_thresh = coeff_opt_dist_threshold[DEFAULT_EVAL];
  // TODO(any): Experiment with coeff_opt_dist_threshold values when
  // enable_winner_mode_for_coeff_opt is ON
  // TODO(any): Skip the winner mode processing for blocks with lower residual
  // energy as R-D optimization of coefficients would have been enabled during
  // mode decision
  if (enable_winner_mode_for_coeff_opt) {
    // Use conservative threshold during mode decision and perform R-D
    // optimization of coeffs always for winner modes
    if (is_winner_mode)
      coeff_opt_thresh = coeff_opt_dist_threshold[WINNER_MODE_EVAL];
    else
      coeff_opt_thresh = coeff_opt_dist_threshold[MODE_EVAL];
  }
  return coeff_opt_thresh;
}

// Used to reset the state of tx/mb rd hash information
static INLINE void reset_hash_records(MACROBLOCK *const x,
                                      int use_inter_txb_hash) {
  int32_t record_idx;

  // Reset the state for use_inter_txb_hash
  if (use_inter_txb_hash) {
    for (record_idx = 0;
         record_idx < ((MAX_MIB_SIZE >> 1) * (MAX_MIB_SIZE >> 1)); record_idx++)
      x->txb_rd_record_8X8[record_idx].num =
          x->txb_rd_record_8X8[record_idx].index_start = 0;
    for (record_idx = 0;
         record_idx < ((MAX_MIB_SIZE >> 2) * (MAX_MIB_SIZE >> 2)); record_idx++)
      x->txb_rd_record_16X16[record_idx].num =
          x->txb_rd_record_16X16[record_idx].index_start = 0;
    for (record_idx = 0;
         record_idx < ((MAX_MIB_SIZE >> 3) * (MAX_MIB_SIZE >> 3)); record_idx++)
      x->txb_rd_record_32X32[record_idx].num =
          x->txb_rd_record_32X32[record_idx].index_start = 0;
    for (record_idx = 0;
         record_idx < ((MAX_MIB_SIZE >> 4) * (MAX_MIB_SIZE >> 4)); record_idx++)
      x->txb_rd_record_64X64[record_idx].num =
          x->txb_rd_record_64X64[record_idx].index_start = 0;
  }

  // Reset the state for use_intra_txb_hash
  x->txb_rd_record_intra.num = x->txb_rd_record_intra.index_start = 0;

  // Reset the state for use_mb_rd_hash
  x->mb_rd_record.num = x->mb_rd_record.index_start = 0;
}

void av1_setup_pred_block(const MACROBLOCKD *xd,
                          struct buf_2d dst[MAX_MB_PLANE],
                          const YV12_BUFFER_CONFIG *src,
                          const struct scale_factors *scale,
                          const struct scale_factors *scale_uv,
                          const int num_planes);

int av1_get_intra_cost_penalty(int qindex, int qdelta,
                               aom_bit_depth_t bit_depth);

void av1_fill_mode_rates(AV1_COMMON *const cm, MACROBLOCK *x,
                         FRAME_CONTEXT *fc);

void av1_fill_coeff_costs(MACROBLOCK *x, FRAME_CONTEXT *fc,
                          const int num_planes);

void av1_fill_mv_costs(const FRAME_CONTEXT *fc, int integer_mv, int usehp,
                       MACROBLOCK *x);

int av1_get_adaptive_rdmult(const struct AV1_COMP *cpi, double beta);

int av1_get_deltaq_offset(const struct AV1_COMP *cpi, int qindex, double beta);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_RD_H_
