/*
 * Copyright (c) 2019, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <stdint.h>

#include "config/aom_config.h"
#include "config/aom_scale_rtcd.h"

#include "aom/aom_codec.h"
#include "aom/aom_encoder.h"

#include "aom_ports/system_state.h"

#include "av1/common/av1_common_int.h"

#include "av1/encoder/encoder.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/gop_structure.h"
#include "av1/encoder/pass2_strategy.h"
#include "av1/encoder/ratectrl.h"
#include "av1/encoder/tpl_model.h"
#include "av1/encoder/use_flat_gop_model_params.h"
#include "av1/encoder/encode_strategy.h"

#define DEFAULT_KF_BOOST 2300
#define DEFAULT_GF_BOOST 2000
#define GROUP_ADAPTIVE_MAXQ 1
static void init_gf_stats(GF_GROUP_STATS *gf_stats);

// Calculate an active area of the image that discounts formatting
// bars and partially discounts other 0 energy areas.
#define MIN_ACTIVE_AREA 0.5
#define MAX_ACTIVE_AREA 1.0
static double calculate_active_area(const FRAME_INFO *frame_info,
                                    const FIRSTPASS_STATS *this_frame) {
  const double active_pct =
      1.0 -
      ((this_frame->intra_skip_pct / 2) +
       ((this_frame->inactive_zone_rows * 2) / (double)frame_info->mb_rows));
  return fclamp(active_pct, MIN_ACTIVE_AREA, MAX_ACTIVE_AREA);
}

// Calculate a modified Error used in distributing bits between easier and
// harder frames.
#define ACT_AREA_CORRECTION 0.5
static double calculate_modified_err(const FRAME_INFO *frame_info,
                                     const TWO_PASS *twopass,
                                     const AV1EncoderConfig *oxcf,
                                     const FIRSTPASS_STATS *this_frame) {
  const FIRSTPASS_STATS *const stats = twopass->stats_buf_ctx->total_stats;
  if (stats == NULL) {
    return 0;
  }
  const double av_weight = stats->weight / stats->count;
  const double av_err = (stats->coded_error * av_weight) / stats->count;
  double modified_error =
      av_err * pow(this_frame->coded_error * this_frame->weight /
                       DOUBLE_DIVIDE_CHECK(av_err),
                   oxcf->two_pass_vbrbias / 100.0);

  // Correction for active area. Frames with a reduced active area
  // (eg due to formatting bars) have a higher error per mb for the
  // remaining active MBs. The correction here assumes that coding
  // 0.5N blocks of complexity 2X is a little easier than coding N
  // blocks of complexity X.
  modified_error *=
      pow(calculate_active_area(frame_info, this_frame), ACT_AREA_CORRECTION);

  return fclamp(modified_error, twopass->modified_error_min,
                twopass->modified_error_max);
}

// Resets the first pass file to the given position using a relative seek from
// the current position.
static void reset_fpf_position(TWO_PASS *p, const FIRSTPASS_STATS *position) {
  p->stats_in = position;
}

static int input_stats(TWO_PASS *p, FIRSTPASS_STATS *fps) {
  if (p->stats_in >= p->stats_buf_ctx->stats_in_end) return EOF;

  *fps = *p->stats_in;
  ++p->stats_in;
  return 1;
}

static int input_stats_lap(TWO_PASS *p, FIRSTPASS_STATS *fps) {
  if (p->stats_in >= p->stats_buf_ctx->stats_in_end) return EOF;

  *fps = *p->stats_in;
  /* Move old stats[0] out to accommodate for next frame stats  */
  memmove(p->frame_stats_arr[0], p->frame_stats_arr[1],
          (p->stats_buf_ctx->stats_in_end - p->stats_in - 1) *
              sizeof(FIRSTPASS_STATS));
  p->stats_buf_ctx->stats_in_end--;
  return 1;
}

// Read frame stats at an offset from the current position.
static const FIRSTPASS_STATS *read_frame_stats(const TWO_PASS *p, int offset) {
  if ((offset >= 0 && p->stats_in + offset >= p->stats_buf_ctx->stats_in_end) ||
      (offset < 0 && p->stats_in + offset < p->stats_buf_ctx->stats_in_start)) {
    return NULL;
  }

  return &p->stats_in[offset];
}

static void subtract_stats(FIRSTPASS_STATS *section,
                           const FIRSTPASS_STATS *frame) {
  section->frame -= frame->frame;
  section->weight -= frame->weight;
  section->intra_error -= frame->intra_error;
  section->frame_avg_wavelet_energy -= frame->frame_avg_wavelet_energy;
  section->coded_error -= frame->coded_error;
  section->sr_coded_error -= frame->sr_coded_error;
  section->pcnt_inter -= frame->pcnt_inter;
  section->pcnt_motion -= frame->pcnt_motion;
  section->pcnt_second_ref -= frame->pcnt_second_ref;
  section->pcnt_neutral -= frame->pcnt_neutral;
  section->intra_skip_pct -= frame->intra_skip_pct;
  section->inactive_zone_rows -= frame->inactive_zone_rows;
  section->inactive_zone_cols -= frame->inactive_zone_cols;
  section->MVr -= frame->MVr;
  section->mvr_abs -= frame->mvr_abs;
  section->MVc -= frame->MVc;
  section->mvc_abs -= frame->mvc_abs;
  section->MVrv -= frame->MVrv;
  section->MVcv -= frame->MVcv;
  section->mv_in_out_count -= frame->mv_in_out_count;
  section->new_mv_count -= frame->new_mv_count;
  section->count -= frame->count;
  section->duration -= frame->duration;
}

// This function returns the maximum target rate per frame.
static int frame_max_bits(const RATE_CONTROL *rc,
                          const AV1EncoderConfig *oxcf) {
  int64_t max_bits = ((int64_t)rc->avg_frame_bandwidth *
                      (int64_t)oxcf->two_pass_vbrmax_section) /
                     100;
  if (max_bits < 0)
    max_bits = 0;
  else if (max_bits > rc->max_frame_bandwidth)
    max_bits = rc->max_frame_bandwidth;

  return (int)max_bits;
}

static const double q_pow_term[(QINDEX_RANGE >> 5) + 1] = { 0.65, 0.70, 0.75,
                                                            0.80, 0.85, 0.90,
                                                            0.95, 0.95, 0.95 };
#define ERR_DIVISOR 96.0
static double calc_correction_factor(double err_per_mb, int q) {
  const double error_term = err_per_mb / ERR_DIVISOR;
  const int index = q >> 5;
  // Adjustment to power term based on qindex
  const double power_term =
      q_pow_term[index] +
      (((q_pow_term[index + 1] - q_pow_term[index]) * (q % 32)) / 32.0);
  assert(error_term >= 0.0);
  return fclamp(pow(error_term, power_term), 0.05, 5.0);
}

static void twopass_update_bpm_factor(TWO_PASS *twopass) {
  // Based on recent history adjust expectations of bits per macroblock.
  double last_group_rate_err =
      (double)twopass->rolling_arf_group_actual_bits /
      DOUBLE_DIVIDE_CHECK((double)twopass->rolling_arf_group_target_bits);
  last_group_rate_err = AOMMAX(0.25, AOMMIN(4.0, last_group_rate_err));
  twopass->bpm_factor *= (3.0 + last_group_rate_err) / 4.0;
  twopass->bpm_factor = AOMMAX(0.25, AOMMIN(4.0, twopass->bpm_factor));
}

static int qbpm_enumerator(int rate_err_tol) {
  return 1350000 + ((300000 * AOMMIN(75, AOMMAX(rate_err_tol - 25, 0))) / 75);
}

// Similar to find_qindex_by_rate() function in ratectrl.c, but includes
// calculation of a correction_factor.
static int find_qindex_by_rate_with_correction(
    int desired_bits_per_mb, aom_bit_depth_t bit_depth, double error_per_mb,
    double group_weight_factor, int rate_err_tol, int best_qindex,
    int worst_qindex) {
  assert(best_qindex <= worst_qindex);
  int low = best_qindex;
  int high = worst_qindex;

  while (low < high) {
    const int mid = (low + high) >> 1;
    const double mid_factor = calc_correction_factor(error_per_mb, mid);
    const double q = av1_convert_qindex_to_q(mid, bit_depth);
    const int enumerator = qbpm_enumerator(rate_err_tol);
    const int mid_bits_per_mb =
        (int)((enumerator * mid_factor * group_weight_factor) / q);

    if (mid_bits_per_mb > desired_bits_per_mb) {
      low = mid + 1;
    } else {
      high = mid;
    }
  }
  return low;
}

static int get_twopass_worst_quality(AV1_COMP *cpi, const double section_err,
                                     double inactive_zone,
                                     int section_target_bandwidth,
                                     double group_weight_factor) {
  const RATE_CONTROL *const rc = &cpi->rc;
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;

  inactive_zone = fclamp(inactive_zone, 0.0, 1.0);

  if (section_target_bandwidth <= 0) {
    return rc->worst_quality;  // Highest value allowed
  } else {
    const int num_mbs = (cpi->oxcf.resize_mode != RESIZE_NONE)
                            ? cpi->initial_mbs
                            : cpi->common.mi_params.MBs;
    const int active_mbs = AOMMAX(1, num_mbs - (int)(num_mbs * inactive_zone));
    const double av_err_per_mb = section_err / active_mbs;
    const int target_norm_bits_per_mb =
        (int)((uint64_t)section_target_bandwidth << BPER_MB_NORMBITS) /
        active_mbs;
    int rate_err_tol =
        AOMMIN(cpi->oxcf.under_shoot_pct, cpi->oxcf.over_shoot_pct);

    twopass_update_bpm_factor(&cpi->twopass);
    // Try and pick a max Q that will be high enough to encode the
    // content at the given rate.
    int q = find_qindex_by_rate_with_correction(
        target_norm_bits_per_mb, cpi->common.seq_params.bit_depth,
        av_err_per_mb, group_weight_factor, rate_err_tol, rc->best_quality,
        rc->worst_quality);

    // Restriction on active max q for constrained quality mode.
    if (cpi->oxcf.rc_mode == AOM_CQ) q = AOMMAX(q, oxcf->cq_level);
    return q;
  }
}

#define SR_DIFF_PART 0.0015
#define MOTION_AMP_PART 0.003
#define INTRA_PART 0.005
#define DEFAULT_DECAY_LIMIT 0.75
#define LOW_SR_DIFF_TRHESH 0.1
#define SR_DIFF_MAX 128.0
#define NCOUNT_FRAME_II_THRESH 5.0

static double get_sr_decay_rate(const FRAME_INFO *frame_info,
                                const FIRSTPASS_STATS *frame) {
  const int num_mbs = frame_info->num_mbs;
  double sr_diff = (frame->sr_coded_error - frame->coded_error) / num_mbs;
  double sr_decay = 1.0;
  double modified_pct_inter;
  double modified_pcnt_intra;
  const double motion_amplitude_factor =
      frame->pcnt_motion * ((frame->mvc_abs + frame->mvr_abs) / 2);

  modified_pct_inter = frame->pcnt_inter;
  if ((frame->intra_error / DOUBLE_DIVIDE_CHECK(frame->coded_error)) <
      (double)NCOUNT_FRAME_II_THRESH) {
    modified_pct_inter = frame->pcnt_inter - frame->pcnt_neutral;
  }
  modified_pcnt_intra = 100 * (1.0 - modified_pct_inter);

  if ((sr_diff > LOW_SR_DIFF_TRHESH)) {
    sr_diff = AOMMIN(sr_diff, SR_DIFF_MAX);
    sr_decay = 1.0 - (SR_DIFF_PART * sr_diff) -
               (MOTION_AMP_PART * motion_amplitude_factor) -
               (INTRA_PART * modified_pcnt_intra);
  }
  return AOMMAX(sr_decay, AOMMIN(DEFAULT_DECAY_LIMIT, modified_pct_inter));
}

// This function gives an estimate of how badly we believe the prediction
// quality is decaying from frame to frame.
static double get_zero_motion_factor(const FRAME_INFO *frame_info,
                                     const FIRSTPASS_STATS *frame) {
  const double zero_motion_pct = frame->pcnt_inter - frame->pcnt_motion;
  double sr_decay = get_sr_decay_rate(frame_info, frame);
  return AOMMIN(sr_decay, zero_motion_pct);
}

#define ZM_POWER_FACTOR 0.75

static double get_prediction_decay_rate(const FRAME_INFO *frame_info,
                                        const FIRSTPASS_STATS *next_frame) {
  const double sr_decay_rate = get_sr_decay_rate(frame_info, next_frame);
  const double zero_motion_factor =
      (0.95 * pow((next_frame->pcnt_inter - next_frame->pcnt_motion),
                  ZM_POWER_FACTOR));

  return AOMMAX(zero_motion_factor,
                (sr_decay_rate + ((1.0 - sr_decay_rate) * zero_motion_factor)));
}

// Function to test for a condition where a complex transition is followed
// by a static section. For example in slide shows where there is a fade
// between slides. This is to help with more optimal kf and gf positioning.
static int detect_transition_to_still(TWO_PASS *const twopass,
                                      const int min_gf_interval,
                                      const int frame_interval,
                                      const int still_interval,
                                      const double loop_decay_rate,
                                      const double last_decay_rate) {
  // Break clause to detect very still sections after motion
  // For example a static image after a fade or other transition
  // instead of a clean scene cut.
  if (frame_interval > min_gf_interval && loop_decay_rate >= 0.999 &&
      last_decay_rate < 0.9) {
    int j;
    // Look ahead a few frames to see if static condition persists...
    for (j = 0; j < still_interval; ++j) {
      const FIRSTPASS_STATS *stats = &twopass->stats_in[j];
      if (stats >= twopass->stats_buf_ctx->stats_in_end) break;

      if (stats->pcnt_inter - stats->pcnt_motion < 0.999) break;
    }
    // Only if it does do we signal a transition to still.
    return j == still_interval;
  }
  return 0;
}

// This function detects a flash through the high relative pcnt_second_ref
// score in the frame following a flash frame. The offset passed in should
// reflect this.
static int detect_flash(const TWO_PASS *twopass, const int offset) {
  const FIRSTPASS_STATS *const next_frame = read_frame_stats(twopass, offset);

  // What we are looking for here is a situation where there is a
  // brief break in prediction (such as a flash) but subsequent frames
  // are reasonably well predicted by an earlier (pre flash) frame.
  // The recovery after a flash is indicated by a high pcnt_second_ref
  // compared to pcnt_inter.
  return next_frame != NULL &&
         next_frame->pcnt_second_ref > next_frame->pcnt_inter &&
         next_frame->pcnt_second_ref >= 0.5;
}

// Update the motion related elements to the GF arf boost calculation.
static void accumulate_frame_motion_stats(const FIRSTPASS_STATS *stats,
                                          GF_GROUP_STATS *gf_stats) {
  const double pct = stats->pcnt_motion;

  // Accumulate Motion In/Out of frame stats.
  gf_stats->this_frame_mv_in_out = stats->mv_in_out_count * pct;
  gf_stats->mv_in_out_accumulator += gf_stats->this_frame_mv_in_out;
  gf_stats->abs_mv_in_out_accumulator += fabs(gf_stats->this_frame_mv_in_out);

  // Accumulate a measure of how uniform (or conversely how random) the motion
  // field is (a ratio of abs(mv) / mv).
  if (pct > 0.05) {
    const double mvr_ratio =
        fabs(stats->mvr_abs) / DOUBLE_DIVIDE_CHECK(fabs(stats->MVr));
    const double mvc_ratio =
        fabs(stats->mvc_abs) / DOUBLE_DIVIDE_CHECK(fabs(stats->MVc));

    gf_stats->mv_ratio_accumulator +=
        pct * (mvr_ratio < stats->mvr_abs ? mvr_ratio : stats->mvr_abs);
    gf_stats->mv_ratio_accumulator +=
        pct * (mvc_ratio < stats->mvc_abs ? mvc_ratio : stats->mvc_abs);
  }
}

static void accumulate_this_frame_stats(const FIRSTPASS_STATS *stats,
                                        const double mod_frame_err,
                                        GF_GROUP_STATS *gf_stats) {
  gf_stats->gf_group_err += mod_frame_err;
#if GROUP_ADAPTIVE_MAXQ
  gf_stats->gf_group_raw_error += stats->coded_error;
#endif
  gf_stats->gf_group_skip_pct += stats->intra_skip_pct;
  gf_stats->gf_group_inactive_zone_rows += stats->inactive_zone_rows;
}

static void accumulate_next_frame_stats(
    const FIRSTPASS_STATS *stats, const FRAME_INFO *frame_info,
    TWO_PASS *const twopass, const int flash_detected,
    const int frames_since_key, const int cur_idx, const int can_disable_arf,
    const int min_gf_interval, GF_GROUP_STATS *gf_stats) {
  accumulate_frame_motion_stats(stats, gf_stats);
  // sum up the metric values of current gf group
  gf_stats->avg_sr_coded_error += stats->sr_coded_error;
  gf_stats->avg_tr_coded_error += stats->tr_coded_error;
  gf_stats->avg_pcnt_second_ref += stats->pcnt_second_ref;
  gf_stats->avg_pcnt_third_ref += stats->pcnt_third_ref;
  gf_stats->avg_new_mv_count += stats->new_mv_count;
  gf_stats->avg_wavelet_energy += stats->frame_avg_wavelet_energy;
  if (fabs(stats->raw_error_stdev) > 0.000001) {
    gf_stats->non_zero_stdev_count++;
    gf_stats->avg_raw_err_stdev += stats->raw_error_stdev;
  }

  // Accumulate the effect of prediction quality decay
  if (!flash_detected) {
    gf_stats->last_loop_decay_rate = gf_stats->loop_decay_rate;
    gf_stats->loop_decay_rate = get_prediction_decay_rate(frame_info, stats);

    gf_stats->decay_accumulator =
        gf_stats->decay_accumulator * gf_stats->loop_decay_rate;

    // Monitor for static sections.
    if ((frames_since_key + cur_idx - 1) > 1) {
      gf_stats->zero_motion_accumulator =
          AOMMIN(gf_stats->zero_motion_accumulator,
                 get_zero_motion_factor(frame_info, stats));
    }

    // Break clause to detect very still sections after motion. For example,
    // a static image after a fade or other transition.
    if (can_disable_arf &&
        detect_transition_to_still(twopass, min_gf_interval, cur_idx, 5,
                                   gf_stats->loop_decay_rate,
                                   gf_stats->last_loop_decay_rate)) {
      gf_stats->allow_alt_ref = 0;
    }
  }
}

static void average_gf_stats(const int total_frame,
                             const FIRSTPASS_STATS *last_stat,
                             GF_GROUP_STATS *gf_stats) {
  if (total_frame) {
    gf_stats->avg_sr_coded_error /= total_frame;
    gf_stats->avg_tr_coded_error /= total_frame;
    gf_stats->avg_pcnt_second_ref /= total_frame;
    if (total_frame - 1) {
      gf_stats->avg_pcnt_third_ref_nolast =
          (gf_stats->avg_pcnt_third_ref - last_stat->pcnt_third_ref) /
          (total_frame - 1);
    } else {
      gf_stats->avg_pcnt_third_ref_nolast =
          gf_stats->avg_pcnt_third_ref / total_frame;
    }
    gf_stats->avg_pcnt_third_ref /= total_frame;
    gf_stats->avg_new_mv_count /= total_frame;
    gf_stats->avg_wavelet_energy /= total_frame;
  }

  if (gf_stats->non_zero_stdev_count)
    gf_stats->avg_raw_err_stdev /= gf_stats->non_zero_stdev_count;
}

static void get_features_from_gf_stats(const GF_GROUP_STATS *gf_stats,
                                       const GF_FRAME_STATS *first_frame,
                                       const GF_FRAME_STATS *last_frame,
                                       const int num_mbs,
                                       const int constrained_gf_group,
                                       const int kf_zeromotion_pct,
                                       const int num_frames, float *features) {
  *features++ = (float)gf_stats->abs_mv_in_out_accumulator;
  *features++ = (float)(gf_stats->avg_new_mv_count / num_mbs);
  *features++ = (float)gf_stats->avg_pcnt_second_ref;
  *features++ = (float)gf_stats->avg_pcnt_third_ref;
  *features++ = (float)gf_stats->avg_pcnt_third_ref_nolast;
  *features++ = (float)(gf_stats->avg_sr_coded_error / num_mbs);
  *features++ = (float)(gf_stats->avg_tr_coded_error / num_mbs);
  *features++ = (float)(gf_stats->avg_wavelet_energy / num_mbs);
  *features++ = (float)(constrained_gf_group);
  *features++ = (float)gf_stats->decay_accumulator;
  *features++ = (float)(first_frame->frame_coded_error / num_mbs);
  *features++ = (float)(first_frame->frame_sr_coded_error / num_mbs);
  *features++ = (float)(first_frame->frame_tr_coded_error / num_mbs);
  *features++ = (float)(first_frame->frame_err / num_mbs);
  *features++ = (float)(kf_zeromotion_pct);
  *features++ = (float)(last_frame->frame_coded_error / num_mbs);
  *features++ = (float)(last_frame->frame_sr_coded_error / num_mbs);
  *features++ = (float)(last_frame->frame_tr_coded_error / num_mbs);
  *features++ = (float)num_frames;
  *features++ = (float)gf_stats->mv_ratio_accumulator;
  *features++ = (float)gf_stats->non_zero_stdev_count;
}

#define BOOST_FACTOR 12.5
static double baseline_err_per_mb(const FRAME_INFO *frame_info) {
  unsigned int screen_area = frame_info->frame_height * frame_info->frame_width;

  // Use a different error per mb factor for calculating boost for
  //  different formats.
  if (screen_area <= 640 * 360) {
    return 500.0;
  } else {
    return 1000.0;
  }
}

static double calc_frame_boost(const RATE_CONTROL *rc,
                               const FRAME_INFO *frame_info,
                               const FIRSTPASS_STATS *this_frame,
                               double this_frame_mv_in_out, double max_boost) {
  double frame_boost;
  const double lq = av1_convert_qindex_to_q(rc->avg_frame_qindex[INTER_FRAME],
                                            frame_info->bit_depth);
  const double boost_q_correction = AOMMIN((0.5 + (lq * 0.015)), 1.5);
  const double active_area = calculate_active_area(frame_info, this_frame);
  int num_mbs = frame_info->num_mbs;

  // Correct for any inactive region in the image
  num_mbs = (int)AOMMAX(1, num_mbs * active_area);

  // Underlying boost factor is based on inter error ratio.
  frame_boost = AOMMAX(baseline_err_per_mb(frame_info) * num_mbs,
                       this_frame->intra_error * active_area) /
                DOUBLE_DIVIDE_CHECK(this_frame->coded_error);
  frame_boost = frame_boost * BOOST_FACTOR * boost_q_correction;

  // Increase boost for frames where new data coming into frame (e.g. zoom out).
  // Slightly reduce boost if there is a net balance of motion out of the frame
  // (zoom in). The range for this_frame_mv_in_out is -1.0 to +1.0.
  if (this_frame_mv_in_out > 0.0)
    frame_boost += frame_boost * (this_frame_mv_in_out * 2.0);
  // In the extreme case the boost is halved.
  else
    frame_boost += frame_boost * (this_frame_mv_in_out / 2.0);

  return AOMMIN(frame_boost, max_boost * boost_q_correction);
}

static double calc_kf_frame_boost(const RATE_CONTROL *rc,
                                  const FRAME_INFO *frame_info,
                                  const FIRSTPASS_STATS *this_frame,
                                  double *sr_accumulator, double max_boost) {
  double frame_boost;
  const double lq = av1_convert_qindex_to_q(rc->avg_frame_qindex[INTER_FRAME],
                                            frame_info->bit_depth);
  const double boost_q_correction = AOMMIN((0.50 + (lq * 0.015)), 2.00);
  const double active_area = calculate_active_area(frame_info, this_frame);
  int num_mbs = frame_info->num_mbs;

  // Correct for any inactive region in the image
  num_mbs = (int)AOMMAX(1, num_mbs * active_area);

  // Underlying boost factor is based on inter error ratio.
  frame_boost = AOMMAX(baseline_err_per_mb(frame_info) * num_mbs,
                       this_frame->intra_error * active_area) /
                DOUBLE_DIVIDE_CHECK(
                    (this_frame->coded_error + *sr_accumulator) * active_area);

  // Update the accumulator for second ref error difference.
  // This is intended to give an indication of how much the coded error is
  // increasing over time.
  *sr_accumulator += (this_frame->sr_coded_error - this_frame->coded_error);
  *sr_accumulator = AOMMAX(0.0, *sr_accumulator);

  // Q correction and scaling
  // The 40.0 value here is an experimentally derived baseline minimum.
  // This value is in line with the minimum per frame boost in the alt_ref
  // boost calculation.
  frame_boost = ((frame_boost + 40.0) * boost_q_correction);

  return AOMMIN(frame_boost, max_boost * boost_q_correction);
}

static int get_projected_gfu_boost(const RATE_CONTROL *rc, int gfu_boost,
                                   int frames_to_project,
                                   int num_stats_used_for_gfu_boost) {
  /*
   * If frames_to_project is equal to num_stats_used_for_gfu_boost,
   * it means that gfu_boost was calculated over frames_to_project to
   * begin with(ie; all stats required were available), hence return
   * the original boost.
   */
  if (num_stats_used_for_gfu_boost >= frames_to_project) return gfu_boost;

  double min_boost_factor = sqrt(rc->baseline_gf_interval);
  // Get the current tpl factor (number of frames = frames_to_project).
  double tpl_factor = av1_get_gfu_boost_projection_factor(
      min_boost_factor, MAX_GFUBOOST_FACTOR, frames_to_project);
  // Get the tpl factor when number of frames = num_stats_used_for_prior_boost.
  double tpl_factor_num_stats = av1_get_gfu_boost_projection_factor(
      min_boost_factor, MAX_GFUBOOST_FACTOR, num_stats_used_for_gfu_boost);
  int projected_gfu_boost =
      (int)rint((tpl_factor * gfu_boost) / tpl_factor_num_stats);
  return projected_gfu_boost;
}

#define GF_MAX_BOOST 90.0
#define MIN_DECAY_FACTOR 0.01
int av1_calc_arf_boost(const TWO_PASS *twopass, const RATE_CONTROL *rc,
                       FRAME_INFO *frame_info, int offset, int f_frames,
                       int b_frames, int *num_fpstats_used,
                       int *num_fpstats_required) {
  int i;
  GF_GROUP_STATS gf_stats;
  init_gf_stats(&gf_stats);
  double boost_score = (double)NORMAL_BOOST;
  int arf_boost;
  int flash_detected = 0;
  if (num_fpstats_used) *num_fpstats_used = 0;

  // Search forward from the proposed arf/next gf position.
  for (i = 0; i < f_frames; ++i) {
    const FIRSTPASS_STATS *this_frame = read_frame_stats(twopass, i + offset);
    if (this_frame == NULL) break;

    // Update the motion related elements to the boost calculation.
    accumulate_frame_motion_stats(this_frame, &gf_stats);

    // We want to discount the flash frame itself and the recovery
    // frame that follows as both will have poor scores.
    flash_detected = detect_flash(twopass, i + offset) ||
                     detect_flash(twopass, i + offset + 1);

    // Accumulate the effect of prediction quality decay.
    if (!flash_detected) {
      gf_stats.decay_accumulator *=
          get_prediction_decay_rate(frame_info, this_frame);
      gf_stats.decay_accumulator = gf_stats.decay_accumulator < MIN_DECAY_FACTOR
                                       ? MIN_DECAY_FACTOR
                                       : gf_stats.decay_accumulator;
    }

    boost_score +=
        gf_stats.decay_accumulator *
        calc_frame_boost(rc, frame_info, this_frame,
                         gf_stats.this_frame_mv_in_out, GF_MAX_BOOST);
    if (num_fpstats_used) (*num_fpstats_used)++;
  }

  arf_boost = (int)boost_score;

  // Reset for backward looking loop.
  boost_score = 0.0;
  init_gf_stats(&gf_stats);
  // Search backward towards last gf position.
  for (i = -1; i >= -b_frames; --i) {
    const FIRSTPASS_STATS *this_frame = read_frame_stats(twopass, i + offset);
    if (this_frame == NULL) break;

    // Update the motion related elements to the boost calculation.
    accumulate_frame_motion_stats(this_frame, &gf_stats);

    // We want to discount the the flash frame itself and the recovery
    // frame that follows as both will have poor scores.
    flash_detected = detect_flash(twopass, i + offset) ||
                     detect_flash(twopass, i + offset + 1);

    // Cumulative effect of prediction quality decay.
    if (!flash_detected) {
      gf_stats.decay_accumulator *=
          get_prediction_decay_rate(frame_info, this_frame);
      gf_stats.decay_accumulator = gf_stats.decay_accumulator < MIN_DECAY_FACTOR
                                       ? MIN_DECAY_FACTOR
                                       : gf_stats.decay_accumulator;
    }

    boost_score +=
        gf_stats.decay_accumulator *
        calc_frame_boost(rc, frame_info, this_frame,
                         gf_stats.this_frame_mv_in_out, GF_MAX_BOOST);
    if (num_fpstats_used) (*num_fpstats_used)++;
  }
  arf_boost += (int)boost_score;

  if (num_fpstats_required) {
    *num_fpstats_required = f_frames + b_frames;
    if (num_fpstats_used) {
      arf_boost = get_projected_gfu_boost(rc, arf_boost, *num_fpstats_required,
                                          *num_fpstats_used);
    }
  }

  if (arf_boost < ((b_frames + f_frames) * 50))
    arf_boost = ((b_frames + f_frames) * 50);

  return arf_boost;
}

// Calculate a section intra ratio used in setting max loop filter.
static int calculate_section_intra_ratio(const FIRSTPASS_STATS *begin,
                                         const FIRSTPASS_STATS *end,
                                         int section_length) {
  const FIRSTPASS_STATS *s = begin;
  double intra_error = 0.0;
  double coded_error = 0.0;
  int i = 0;

  while (s < end && i < section_length) {
    intra_error += s->intra_error;
    coded_error += s->coded_error;
    ++s;
    ++i;
  }

  return (int)(intra_error / DOUBLE_DIVIDE_CHECK(coded_error));
}

// Calculate the total bits to allocate in this GF/ARF group.
static int64_t calculate_total_gf_group_bits(AV1_COMP *cpi,
                                             double gf_group_err) {
  const RATE_CONTROL *const rc = &cpi->rc;
  const TWO_PASS *const twopass = &cpi->twopass;
  const int max_bits = frame_max_bits(rc, &cpi->oxcf);
  int64_t total_group_bits;

  // Calculate the bits to be allocated to the group as a whole.
  if ((twopass->kf_group_bits > 0) && (twopass->kf_group_error_left > 0)) {
    total_group_bits = (int64_t)(twopass->kf_group_bits *
                                 (gf_group_err / twopass->kf_group_error_left));
  } else {
    total_group_bits = 0;
  }

  // Clamp odd edge cases.
  total_group_bits = (total_group_bits < 0)
                         ? 0
                         : (total_group_bits > twopass->kf_group_bits)
                               ? twopass->kf_group_bits
                               : total_group_bits;

  // Clip based on user supplied data rate variability limit.
  if (total_group_bits > (int64_t)max_bits * rc->baseline_gf_interval)
    total_group_bits = (int64_t)max_bits * rc->baseline_gf_interval;

  return total_group_bits;
}

// Calculate the number of bits to assign to boosted frames in a group.
static int calculate_boost_bits(int frame_count, int boost,
                                int64_t total_group_bits) {
  int allocation_chunks;

  // return 0 for invalid inputs (could arise e.g. through rounding errors)
  if (!boost || (total_group_bits <= 0)) return 0;

  if (frame_count <= 0) return (int)(AOMMIN(total_group_bits, INT_MAX));

  allocation_chunks = (frame_count * 100) + boost;

  // Prevent overflow.
  if (boost > 1023) {
    int divisor = boost >> 10;
    boost /= divisor;
    allocation_chunks /= divisor;
  }

  // Calculate the number of extra bits for use in the boosted frame or frames.
  return AOMMAX((int)(((int64_t)boost * total_group_bits) / allocation_chunks),
                0);
}

// Calculate the boost factor based on the number of bits assigned, i.e. the
// inverse of calculate_boost_bits().
static int calculate_boost_factor(int frame_count, int bits,
                                  int64_t total_group_bits) {
  aom_clear_system_state();
  return (int)(100.0 * frame_count * bits / (total_group_bits - bits));
}

// Reduce the number of bits assigned to keyframe or arf if necessary, to
// prevent bitrate spikes that may break level constraints.
// frame_type: 0: keyframe; 1: arf.
static int adjust_boost_bits_for_target_level(const AV1_COMP *const cpi,
                                              RATE_CONTROL *const rc,
                                              int bits_assigned,
                                              int64_t group_bits,
                                              int frame_type) {
  const AV1_COMMON *const cm = &cpi->common;
  const SequenceHeader *const seq_params = &cm->seq_params;
  const int temporal_layer_id = cm->temporal_layer_id;
  const int spatial_layer_id = cm->spatial_layer_id;
  for (int index = 0; index < seq_params->operating_points_cnt_minus_1 + 1;
       ++index) {
    if (!is_in_operating_point(seq_params->operating_point_idc[index],
                               temporal_layer_id, spatial_layer_id)) {
      continue;
    }

    const AV1_LEVEL target_level =
        cpi->level_params.target_seq_level_idx[index];
    if (target_level >= SEQ_LEVELS) continue;

    assert(is_valid_seq_level_idx(target_level));

    const double level_bitrate_limit = av1_get_max_bitrate_for_level(
        target_level, seq_params->tier[0], seq_params->profile);
    const int target_bits_per_frame =
        (int)(level_bitrate_limit / cpi->framerate);
    if (frame_type == 0) {
      // Maximum bits for keyframe is 8 times the target_bits_per_frame.
      const int level_enforced_max_kf_bits = target_bits_per_frame * 8;
      if (bits_assigned > level_enforced_max_kf_bits) {
        const int frames = rc->frames_to_key - 1;
        rc->kf_boost = calculate_boost_factor(
            frames, level_enforced_max_kf_bits, group_bits);
        bits_assigned = calculate_boost_bits(frames, rc->kf_boost, group_bits);
      }
    } else if (frame_type == 1) {
      // Maximum bits for arf is 4 times the target_bits_per_frame.
      const int level_enforced_max_arf_bits = target_bits_per_frame * 4;
      if (bits_assigned > level_enforced_max_arf_bits) {
        rc->gfu_boost = calculate_boost_factor(
            rc->baseline_gf_interval, level_enforced_max_arf_bits, group_bits);
        bits_assigned = calculate_boost_bits(rc->baseline_gf_interval,
                                             rc->gfu_boost, group_bits);
      }
    } else {
      assert(0);
    }
  }

  return bits_assigned;
}

// Compile time switch on alternate algorithm to allocate bits in ARF groups
// #define ALT_ARF_ALLOCATION
#ifdef ALT_ARF_ALLOCATION
double layer_fraction[MAX_ARF_LAYERS + 1] = { 1.0,  0.70, 0.55, 0.60,
                                              0.60, 1.0,  1.0 };
static void allocate_gf_group_bits(GF_GROUP *gf_group, RATE_CONTROL *const rc,
                                   int64_t gf_group_bits, int gf_arf_bits,
                                   int key_frame, int use_arf) {
  int64_t total_group_bits = gf_group_bits;
  int base_frame_bits;
  const int gf_group_size = gf_group->size;
  int layer_frames[MAX_ARF_LAYERS + 1] = { 0 };

  // Subtract the extra bits set aside for ARF frames from the Group Total
  if (use_arf || !key_frame) total_group_bits -= gf_arf_bits;

  if (rc->baseline_gf_interval)
    base_frame_bits = (int)(total_group_bits / rc->baseline_gf_interval);
  else
    base_frame_bits = (int)1;

  // For key frames the frame target rate is already set and it
  // is also the golden frame.
  // === [frame_index == 0] ===
  int frame_index = 0;
  if (!key_frame) {
    if (rc->source_alt_ref_active)
      gf_group->bit_allocation[frame_index] = 0;
    else
      gf_group->bit_allocation[frame_index] =
          base_frame_bits + (int)(gf_arf_bits * layer_fraction[1]);
  }
  frame_index++;

  // Check the number of frames in each layer in case we have a
  // non standard group length.
  int max_arf_layer = gf_group->max_layer_depth - 1;
  for (int idx = frame_index; idx < gf_group_size; ++idx) {
    if ((gf_group->update_type[idx] == ARF_UPDATE) ||
        (gf_group->update_type[idx] == INTNL_ARF_UPDATE)) {
      // max_arf_layer = AOMMAX(max_arf_layer, gf_group->layer_depth[idx]);
      layer_frames[gf_group->layer_depth[idx]]++;
    }
  }

  // Allocate extra bits to each ARF layer
  int i;
  int layer_extra_bits[MAX_ARF_LAYERS + 1] = { 0 };
  for (i = 1; i <= max_arf_layer; ++i) {
    double fraction = (i == max_arf_layer) ? 1.0 : layer_fraction[i];
    layer_extra_bits[i] =
        (int)((gf_arf_bits * fraction) / AOMMAX(1, layer_frames[i]));
    gf_arf_bits -= (int)(gf_arf_bits * fraction);
  }

  // Now combine ARF layer and baseline bits to give total bits for each frame.
  int arf_extra_bits;
  for (int idx = frame_index; idx < gf_group_size; ++idx) {
    switch (gf_group->update_type[idx]) {
      case ARF_UPDATE:
      case INTNL_ARF_UPDATE:
        arf_extra_bits = layer_extra_bits[gf_group->layer_depth[idx]];
        gf_group->bit_allocation[idx] = base_frame_bits + arf_extra_bits;
        break;
      case INTNL_OVERLAY_UPDATE:
      case OVERLAY_UPDATE: gf_group->bit_allocation[idx] = 0; break;
      default: gf_group->bit_allocation[idx] = base_frame_bits; break;
    }
  }

  // Set the frame following the current GOP to 0 bit allocation. For ARF
  // groups, this next frame will be overlay frame, which is the first frame
  // in the next GOP. For GF group, next GOP will overwrite the rate allocation.
  // Setting this frame to use 0 bit (of out the current GOP budget) will
  // simplify logics in reference frame management.
  gf_group->bit_allocation[gf_group_size] = 0;
}
#else
static void allocate_gf_group_bits(GF_GROUP *gf_group, RATE_CONTROL *const rc,
                                   int64_t gf_group_bits, int gf_arf_bits,
                                   int key_frame, int use_arf) {
  int64_t total_group_bits = gf_group_bits;

  // For key frames the frame target rate is already set and it
  // is also the golden frame.
  // === [frame_index == 0] ===
  int frame_index = 0;
  if (!key_frame) {
    if (rc->source_alt_ref_active)
      gf_group->bit_allocation[frame_index] = 0;
    else
      gf_group->bit_allocation[frame_index] = gf_arf_bits;
  }

  // Deduct the boost bits for arf (or gf if it is not a key frame)
  // from the group total.
  if (use_arf || !key_frame) total_group_bits -= gf_arf_bits;

  frame_index++;

  // Store the bits to spend on the ARF if there is one.
  // === [frame_index == 1] ===
  if (use_arf) {
    gf_group->bit_allocation[frame_index] = gf_arf_bits;
    ++frame_index;
  }

  const int gf_group_size = gf_group->size;
  int arf_depth_bits[MAX_ARF_LAYERS + 1] = { 0 };
  int arf_depth_count[MAX_ARF_LAYERS + 1] = { 0 };
  int arf_depth_boost[MAX_ARF_LAYERS + 1] = { 0 };
  int total_arfs = 0;
  int total_overlays = rc->source_alt_ref_active;

  for (int idx = 0; idx < gf_group_size; ++idx) {
    if (gf_group->update_type[idx] == ARF_UPDATE ||
        gf_group->update_type[idx] == INTNL_ARF_UPDATE ||
        gf_group->update_type[idx] == LF_UPDATE) {
      arf_depth_boost[gf_group->layer_depth[idx]] += gf_group->arf_boost[idx];
      ++arf_depth_count[gf_group->layer_depth[idx]];
    }
  }

  for (int idx = 2; idx <= MAX_ARF_LAYERS; ++idx) {
    arf_depth_bits[idx] =
        calculate_boost_bits(rc->baseline_gf_interval - total_arfs -
                                 total_overlays - arf_depth_count[idx],
                             arf_depth_boost[idx], total_group_bits);
    total_group_bits -= arf_depth_bits[idx];
    total_arfs += arf_depth_count[idx];
  }

  for (int idx = frame_index; idx < gf_group_size; ++idx) {
    switch (gf_group->update_type[idx]) {
      case ARF_UPDATE:
      case INTNL_ARF_UPDATE:
      case LF_UPDATE:
        gf_group->bit_allocation[idx] =
            (int)(((int64_t)arf_depth_bits[gf_group->layer_depth[idx]] *
                   gf_group->arf_boost[idx]) /
                  arf_depth_boost[gf_group->layer_depth[idx]]);
        break;
      case INTNL_OVERLAY_UPDATE:
      case OVERLAY_UPDATE:
      default: gf_group->bit_allocation[idx] = 0; break;
    }
  }

  // Set the frame following the current GOP to 0 bit allocation. For ARF
  // groups, this next frame will be overlay frame, which is the first frame
  // in the next GOP. For GF group, next GOP will overwrite the rate allocation.
  // Setting this frame to use 0 bit (of out the current GOP budget) will
  // simplify logics in reference frame management.
  gf_group->bit_allocation[gf_group_size] = 0;
}
#endif

// Returns true if KF group and GF group both are almost completely static.
static INLINE int is_almost_static(double gf_zero_motion, int kf_zero_motion) {
  return (gf_zero_motion >= 0.995) &&
         (kf_zero_motion >= STATIC_KF_GROUP_THRESH);
}

#define ARF_ABS_ZOOM_THRESH 4.4
static INLINE int detect_gf_cut(AV1_COMP *cpi, int frame_index, int cur_start,
                                int flash_detected, int active_max_gf_interval,
                                int active_min_gf_interval,
                                GF_GROUP_STATS *gf_stats) {
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;
  // Motion breakout threshold for loop below depends on image size.
  const double mv_ratio_accumulator_thresh =
      (cpi->initial_height + cpi->initial_width) / 4.0;

  if (!flash_detected) {
    // Break clause to detect very still sections after motion. For example,
    // a static image after a fade or other transition.
    if (detect_transition_to_still(
            twopass, rc->min_gf_interval, frame_index - cur_start, 5,
            gf_stats->loop_decay_rate, gf_stats->last_loop_decay_rate)) {
      return 1;
    }
  }

  // Some conditions to breakout after min interval.
  if (frame_index - cur_start >= active_min_gf_interval &&
      // If possible don't break very close to a kf
      (rc->frames_to_key - frame_index >= rc->min_gf_interval) &&
      ((frame_index - cur_start) & 0x01) && !flash_detected &&
      (gf_stats->mv_ratio_accumulator > mv_ratio_accumulator_thresh ||
       gf_stats->abs_mv_in_out_accumulator > ARF_ABS_ZOOM_THRESH)) {
    return 1;
  }

  // If almost totally static, we will not use the the max GF length later,
  // so we can continue for more frames.
  if (((frame_index - cur_start) >= active_max_gf_interval + 1) &&
      !is_almost_static(gf_stats->zero_motion_accumulator,
                        twopass->kf_zeromotion_pct)) {
    return 1;
  }
  return 0;
}

#define MAX_PAD_GF_CHECK 6  // padding length to check for gf length
#define AVG_SI_THRES 0.6    // thres for average silouette
#define GF_SHRINK_OUTPUT 0  // print output for gf length decision
int determine_high_err_gf(double *errs, int *is_high, double *si, int len,
                          double *ratio, int gf_start, int gf_end,
                          int before_pad) {
  (void)gf_start;
  (void)gf_end;
  (void)before_pad;
  // alpha and beta controls the threshold placement
  // e.g. a smaller alpha makes the lower group more rigid
  const double alpha = 0.5;
  const double beta = 1 - alpha;
  double mean = 0;
  double mean_low = 0;
  double mean_high = 0;
  double prev_mean_low = 0;
  double prev_mean_high = 0;
  int count_low = 0;
  int count_high = 0;
  // calculate mean of errs
  for (int i = 0; i < len; i++) {
    mean += errs[i];
  }
  mean /= len;
  // separate into two initial groups with greater / lower than mean
  for (int i = 0; i < len; i++) {
    if (errs[i] <= mean) {
      is_high[i] = 0;
      count_low++;
      prev_mean_low += errs[i];
    } else {
      is_high[i] = 1;
      count_high++;
      prev_mean_high += errs[i];
    }
  }
  prev_mean_low /= count_low;
  prev_mean_high /= count_high;
  // kmeans to refine
  int count = 0;
  while (count < 10) {
    // re-group
    mean_low = 0;
    mean_high = 0;
    count_low = 0;
    count_high = 0;
    double thres = prev_mean_low * alpha + prev_mean_high * beta;
    for (int i = 0; i < len; i++) {
      if (errs[i] <= thres) {
        is_high[i] = 0;
        count_low++;
        mean_low += errs[i];
      } else {
        is_high[i] = 1;
        count_high++;
        mean_high += errs[i];
      }
    }
    mean_low /= count_low;
    mean_high /= count_high;

    // break if not changed much
    if (fabs((mean_low - prev_mean_low) / (prev_mean_low + 0.00001)) <
            0.00001 &&
        fabs((mean_high - prev_mean_high) / (prev_mean_high + 0.00001)) <
            0.00001)
      break;

    // update means
    prev_mean_high = mean_high;
    prev_mean_low = mean_low;

    count++;
  }

  // count how many jumps of group changes
  int num_change = 0;
  for (int i = 0; i < len - 1; i++) {
    if (is_high[i] != is_high[i + 1]) num_change++;
  }

  // get silhouette as a measure of the classification quality
  double avg_si = 0;
  // ai: avg dist of its own class, bi: avg dist to the other class
  double ai, bi;
  if (count_low > 1 && count_high > 1) {
    for (int i = 0; i < len; i++) {
      ai = 0;
      bi = 0;
      // calculate average distance to everyone in the same group
      // and in the other group
      for (int j = 0; j < len; j++) {
        if (i == j) continue;
        if (is_high[i] == is_high[j]) {
          ai += fabs(errs[i] - errs[j]);
        } else {
          bi += fabs(errs[i] - errs[j]);
        }
      }
      if (is_high[i] == 0) {
        ai = ai / (count_low - 1);
        bi = bi / count_high;
      } else {
        ai = ai / (count_high - 1);
        bi = bi / count_low;
      }
      if (ai <= bi) {
        si[i] = 1 - ai / (bi + 0.00001);
      } else {
        si[i] = bi / (ai + 0.00001) - 1;
      }
      avg_si += si[i];
    }
    avg_si /= len;
  }

  int reset = 0;
  *ratio = mean_high / (mean_low + 0.00001);
  // if the two groups too similar, or
  // if too many numbers of changes, or
  // silhouette is too small, not confident
  // reset everything to 0 later so we fallback to the original decision
  if (*ratio < 1.3 || num_change > AOMMAX(len / 3, 6) ||
      avg_si < AVG_SI_THRES) {
    reset = 1;
  }

#if GF_SHRINK_OUTPUT
  printf("\n");
  for (int i = 0; i < len; i++) {
    printf("%d: err %.1f, ishigh %d, si %.2f, (i=%d)\n",
           gf_start + i - before_pad, errs[i], is_high[i], si[i], gf_end);
  }
  printf(
      "count: %d, mean_high: %.1f, mean_low: %.1f, avg_si: %.2f, num_change: "
      "%d, ratio %.2f, reset: %d\n",
      count, mean_high, mean_low, avg_si, num_change,
      mean_high / (mean_low + 0.000001), reset);
#endif

  if (reset) {
    memset(is_high, 0, sizeof(is_high[0]) * len);
    memset(si, 0, sizeof(si[0]) * len);
  }
  return reset;
}

#if GROUP_ADAPTIVE_MAXQ
#define RC_FACTOR_MIN 0.75
#define RC_FACTOR_MAX 1.25
#endif  // GROUP_ADAPTIVE_MAXQ
#define MIN_FWD_KF_INTERVAL 8
#define MIN_SHRINK_LEN 6      // the minimum length of gf if we are shrinking
#define SI_HIGH AVG_SI_THRES  // high quality classification
#define SI_LOW 0.3            // very unsure classification
// this function finds an low error frame previously to the current last frame
// in the gf group, and set the last frame to it.
// The resulting last frame is then returned by *cur_last_ptr
// *cur_start_ptr and cut_pos[n] could also change due to shrinking
// previous gf groups
void set_last_prev_low_err(int *cur_start_ptr, int *cur_last_ptr, int *cut_pos,
                           int count_cuts, int before_pad, double ratio,
                           int *is_high, double *si, int prev_lows) {
  int n;
  int cur_start = *cur_start_ptr;
  int cur_last = *cur_last_ptr;
  for (n = cur_last; n >= cur_start + MIN_SHRINK_LEN; n--) {
    // try to find a point that is very probable to be good
    if (is_high[n - cur_start + before_pad] == 0 &&
        si[n - cur_start + before_pad] > SI_HIGH) {
      *cur_last_ptr = n;
      return;
    }
  }
  // could not find a low-err point, then let's try find an "unsure"
  // point at least
  for (n = cur_last; n >= cur_start + MIN_SHRINK_LEN; n--) {
    if ((is_high[n - cur_start + before_pad] == 0) ||
        (is_high[n - cur_start + before_pad] &&
         si[n - cur_start + before_pad] < SI_LOW)) {
      *cur_last_ptr = n;
      return;
    }
  }
  if (prev_lows) {
    // try with shrinking previous all_zero interval
    for (n = cur_start + MIN_SHRINK_LEN - 1; n > cur_start; n--) {
      if (is_high[n - cur_start + before_pad] == 0 &&
          si[n - cur_start + before_pad] > SI_HIGH) {
        int tentative_start = n - MIN_SHRINK_LEN;
        // check if the previous interval can shrink this much
        int available =
            tentative_start - cut_pos[count_cuts - 2] > MIN_SHRINK_LEN &&
            cur_start - tentative_start < prev_lows;
        // shrinking too agressively may worsen performance
        // set stricter thres for shorter length
        double ratio_thres =
            1.0 * (cur_start - tentative_start) / (double)(MIN_SHRINK_LEN) +
            1.0;

        if (available && (ratio > ratio_thres)) {
          cut_pos[count_cuts - 1] = tentative_start;
          *cur_start_ptr = tentative_start;
          *cur_last_ptr = n;
          return;
        }
      }
    }
  }
  if (prev_lows) {
    // try with shrinking previous all_zero interval with unsure points
    for (n = cur_start + MIN_SHRINK_LEN - 1; n > cur_start; n--) {
      if ((is_high[n - cur_start + before_pad] == 0) ||
          (is_high[n - cur_start + before_pad] &&
           si[n - cur_start + before_pad] < SI_LOW)) {
        int tentative_start = n - MIN_SHRINK_LEN;
        // check if the previous interval can shrink this much
        int available =
            tentative_start - cut_pos[count_cuts - 2] > MIN_SHRINK_LEN &&
            cur_start - tentative_start < prev_lows;
        // shrinking too agressively may worsen performance
        double ratio_thres =
            1.0 * (cur_start - tentative_start) / (double)(MIN_SHRINK_LEN) +
            1.0;

        if (available && (ratio > ratio_thres)) {
          cut_pos[count_cuts - 1] = tentative_start;
          *cur_start_ptr = tentative_start;
          *cur_last_ptr = n;
          return;
        }
      }
    }
  }  // prev_lows
  return;
}

// This function decides the gf group length of future frames in batch
// rc->gf_intervals is modified to store the group lengths
static void calculate_gf_length(AV1_COMP *cpi, int max_gop_length,
                                int max_intervals) {
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;
  FIRSTPASS_STATS next_frame;
  const FIRSTPASS_STATS *const start_pos = twopass->stats_in;
  FRAME_INFO *frame_info = &cpi->frame_info;
  int i;

  int flash_detected;

  aom_clear_system_state();
  av1_zero(next_frame);

  if (has_no_stats_stage(cpi)) {
    for (i = 0; i < MAX_NUM_GF_INTERVALS; i++) {
      rc->gf_intervals[i] = AOMMIN(rc->max_gf_interval, max_gop_length);
    }
    rc->cur_gf_index = 0;
    rc->intervals_till_gf_calculate_due = MAX_NUM_GF_INTERVALS;
    return;
  }

  // TODO(urvang): Try logic to vary min and max interval based on q.
  const int active_min_gf_interval = rc->min_gf_interval;
  const int active_max_gf_interval =
      AOMMIN(rc->max_gf_interval, max_gop_length);

  i = 0;
  max_intervals = cpi->lap_enabled ? 1 : max_intervals;
  int cut_pos[MAX_NUM_GF_INTERVALS + 1] = { 0 };
  int count_cuts = 1;
  int cur_start = 0, cur_last;
  int cut_here;
  int prev_lows = 0;
  GF_GROUP_STATS gf_stats;
  init_gf_stats(&gf_stats);
  while (count_cuts < max_intervals + 1) {
    ++i;

    // reaches next key frame, break here
    if (i >= rc->frames_to_key) {
      cut_pos[count_cuts] = i - 1;
      count_cuts++;
      break;
    }

    // reached maximum len, but nothing special yet (almost static)
    // let's look at the next interval
    if (i - cur_start >= rc->static_scene_max_gf_interval) {
      cut_here = 1;
    } else {
      // reaches last frame, break
      if (EOF == input_stats(twopass, &next_frame)) {
        cut_pos[count_cuts] = i - 1;
        count_cuts++;
        break;
      }
      // Test for the case where there is a brief flash but the prediction
      // quality back to an earlier frame is then restored.
      flash_detected = detect_flash(twopass, 0);
      // TODO(bohanli): remove redundant accumulations here, or unify
      // this and the ones in define_gf_group
      accumulate_next_frame_stats(&next_frame, frame_info, twopass,
                                  flash_detected, rc->frames_since_key, i, 0,
                                  rc->min_gf_interval, &gf_stats);

      cut_here = detect_gf_cut(cpi, i, cur_start, flash_detected,
                               active_max_gf_interval, active_min_gf_interval,
                               &gf_stats);
    }
    if (cut_here) {
      cur_last = i - 1;  // the current last frame in the gf group
      // only try shrinking if interval smaller than active_max_gf_interval
      if (cur_last - cur_start <= active_max_gf_interval) {
        // determine in the current decided gop the higher and lower errs
        int n;
        double ratio;

        // load neighboring coded errs
        int is_high[MAX_GF_INTERVAL + 1 + MAX_PAD_GF_CHECK * 2] = { 0 };
        double errs[MAX_GF_INTERVAL + 1 + MAX_PAD_GF_CHECK * 2] = { 0 };
        double si[MAX_GF_INTERVAL + 1 + MAX_PAD_GF_CHECK * 2] = { 0 };
        int before_pad =
            AOMMIN(MAX_PAD_GF_CHECK, rc->frames_since_key - 1 + cur_start);
        int after_pad =
            AOMMIN(MAX_PAD_GF_CHECK, rc->frames_to_key - cur_last - 1);
        for (n = cur_start - before_pad; n <= cur_last + after_pad; n++) {
          if (start_pos + n - 1 > twopass->stats_buf_ctx->stats_in_end) {
            after_pad = n - cur_last - 1;
            assert(after_pad >= 0);
            break;
          } else if (start_pos + n - 1 <
                     twopass->stats_buf_ctx->stats_in_start) {
            before_pad = cur_start - n - 1;
            continue;
          }
          errs[n + before_pad - cur_start] = (start_pos + n - 1)->coded_error;
        }
        const int len = before_pad + after_pad + cur_last - cur_start + 1;
        const int reset = determine_high_err_gf(
            errs, is_high, si, len, &ratio, cur_start, cur_last, before_pad);

        // if the current frame may have high error, try shrinking
        if (is_high[cur_last - cur_start + before_pad] == 1 ||
            (!reset && si[cur_last - cur_start + before_pad] < SI_LOW)) {
          // try not to cut in high err area
          set_last_prev_low_err(&cur_start, &cur_last, cut_pos, count_cuts,
                                before_pad, ratio, is_high, si, prev_lows);
        }  // if current frame high error
        // count how many trailing lower error frames we have in this decided
        // gf group
        prev_lows = 0;
        for (n = cur_last - 1; n > cur_start + MIN_SHRINK_LEN; n--) {
          if (is_high[n - cur_start + before_pad] == 0 &&
              (si[n - cur_start + before_pad] > SI_HIGH || reset)) {
            prev_lows++;
          } else {
            break;
          }
        }
      }
      cut_pos[count_cuts] = cur_last;
      count_cuts++;

      // reset pointers to the shrinked location
      twopass->stats_in = start_pos + cur_last;
      cur_start = cur_last;
      i = cur_last;

      // reset accumulators
      init_gf_stats(&gf_stats);
    }
  }

  // save intervals
  rc->intervals_till_gf_calculate_due = count_cuts - 1;
  for (int n = 1; n < count_cuts; n++) {
    rc->gf_intervals[n - 1] = cut_pos[n] + 1 - cut_pos[n - 1];
  }
  rc->cur_gf_index = 0;
  twopass->stats_in = start_pos;

#if GF_SHRINK_OUTPUT
  printf("\nf_to_key: %d, count_cut: %d. ", rc->frames_to_key, count_cuts);
  for (int n = 0; n < count_cuts; n++) {
    printf("%d ", cut_pos[n]);
  }
  printf("\n");

  for (int n = 0; n < rc->intervals_till_gf_calculate_due; n++) {
    printf("%d ", rc->gf_intervals[n]);
  }
  printf("\n\n");
#endif
}

static void correct_frames_to_key(AV1_COMP *cpi) {
  int lookahead_size =
      (int)av1_lookahead_depth(cpi->lookahead, cpi->compressor_stage) + 1;
  if (lookahead_size <
      av1_lookahead_pop_sz(cpi->lookahead, cpi->compressor_stage)) {
    cpi->rc.frames_to_key = AOMMIN(cpi->rc.frames_to_key, lookahead_size);
  }
}

static void define_gf_group_pass0(AV1_COMP *cpi,
                                  const EncodeFrameParams *const frame_params) {
  RATE_CONTROL *const rc = &cpi->rc;
  GF_GROUP *const gf_group = &cpi->gf_group;
  int target;

  if (cpi->oxcf.aq_mode == CYCLIC_REFRESH_AQ) {
    av1_cyclic_refresh_set_golden_update(cpi);
  } else {
    rc->baseline_gf_interval = rc->gf_intervals[rc->cur_gf_index];
    rc->intervals_till_gf_calculate_due--;
    rc->cur_gf_index++;
  }

  // correct frames_to_key when lookahead queue is flushing
  correct_frames_to_key(cpi);

  if (rc->baseline_gf_interval > rc->frames_to_key)
    rc->baseline_gf_interval = rc->frames_to_key;

  rc->gfu_boost = DEFAULT_GF_BOOST;
  rc->constrained_gf_group =
      (rc->baseline_gf_interval >= rc->frames_to_key) ? 1 : 0;

  gf_group->max_layer_depth_allowed = cpi->oxcf.gf_max_pyr_height;

  // Rare case when the look-ahead is less than the target GOP length, can't
  // generate ARF frame.
  if (rc->baseline_gf_interval > cpi->oxcf.lag_in_frames ||
      !is_altref_enabled(cpi) || rc->baseline_gf_interval < rc->min_gf_interval)
    gf_group->max_layer_depth_allowed = 0;

  // Set up the structure of this Group-Of-Pictures (same as GF_GROUP)
  av1_gop_setup_structure(cpi, frame_params);

  // Allocate bits to each of the frames in the GF group.
  // TODO(sarahparker) Extend this to work with pyramid structure.
  for (int cur_index = 0; cur_index < gf_group->size; ++cur_index) {
    const FRAME_UPDATE_TYPE cur_update_type = gf_group->update_type[cur_index];
    if (cpi->oxcf.rc_mode == AOM_CBR) {
      if (cur_update_type == KEY_FRAME) {
        target = av1_calc_iframe_target_size_one_pass_cbr(cpi);
      } else {
        target = av1_calc_pframe_target_size_one_pass_cbr(cpi, cur_update_type);
      }
    } else {
      if (cur_update_type == KEY_FRAME) {
        target = av1_calc_iframe_target_size_one_pass_vbr(cpi);
      } else {
        target = av1_calc_pframe_target_size_one_pass_vbr(cpi, cur_update_type);
      }
    }
    gf_group->bit_allocation[cur_index] = target;
  }
}

static INLINE void set_baseline_gf_interval(AV1_COMP *cpi, int arf_position,
                                            int active_max_gf_interval,
                                            int use_alt_ref,
                                            int is_final_pass) {
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;
  // Set the interval until the next gf.
  // If forward keyframes are enabled, ensure the final gf group obeys the
  // MIN_FWD_KF_INTERVAL.
  if (cpi->oxcf.fwd_kf_enabled && use_alt_ref &&
      ((twopass->stats_in - arf_position + rc->frames_to_key) <
       twopass->stats_buf_ctx->stats_in_end) &&
      cpi->rc.next_is_fwd_key) {
    if (arf_position == rc->frames_to_key) {
      rc->baseline_gf_interval = arf_position;
      // if the last gf group will be smaller than MIN_FWD_KF_INTERVAL
    } else if ((rc->frames_to_key - arf_position <
                AOMMAX(MIN_FWD_KF_INTERVAL, rc->min_gf_interval)) &&
               (rc->frames_to_key != arf_position)) {
      // if possible, merge the last two gf groups
      if (rc->frames_to_key <= active_max_gf_interval) {
        rc->baseline_gf_interval = rc->frames_to_key;
        if (is_final_pass) rc->intervals_till_gf_calculate_due = 0;
        // if merging the last two gf groups creates a group that is too long,
        // split them and force the last gf group to be the MIN_FWD_KF_INTERVAL
      } else {
        rc->baseline_gf_interval = rc->frames_to_key - MIN_FWD_KF_INTERVAL;
        if (is_final_pass) rc->intervals_till_gf_calculate_due = 0;
      }
    } else {
      rc->baseline_gf_interval = arf_position - rc->source_alt_ref_pending;
    }
  } else {
    rc->baseline_gf_interval = arf_position - rc->source_alt_ref_pending;
  }
}

// initialize GF_GROUP_STATS
static void init_gf_stats(GF_GROUP_STATS *gf_stats) {
  gf_stats->gf_group_err = 0.0;
  gf_stats->gf_group_raw_error = 0.0;
  gf_stats->gf_group_skip_pct = 0.0;
  gf_stats->gf_group_inactive_zone_rows = 0.0;

  gf_stats->mv_ratio_accumulator = 0.0;
  gf_stats->decay_accumulator = 1.0;
  gf_stats->zero_motion_accumulator = 1.0;
  gf_stats->loop_decay_rate = 1.0;
  gf_stats->last_loop_decay_rate = 1.0;
  gf_stats->this_frame_mv_in_out = 0.0;
  gf_stats->mv_in_out_accumulator = 0.0;
  gf_stats->abs_mv_in_out_accumulator = 0.0;

  gf_stats->avg_sr_coded_error = 0.0;
  gf_stats->avg_tr_coded_error = 0.0;
  gf_stats->avg_pcnt_second_ref = 0.0;
  gf_stats->avg_pcnt_third_ref = 0.0;
  gf_stats->avg_pcnt_third_ref_nolast = 0.0;
  gf_stats->avg_new_mv_count = 0.0;
  gf_stats->avg_wavelet_energy = 0.0;
  gf_stats->avg_raw_err_stdev = 0.0;
  gf_stats->non_zero_stdev_count = 0;

  gf_stats->allow_alt_ref = 0;
}

// Analyse and define a gf/arf group.
#define MAX_GF_BOOST 5400
static void define_gf_group(AV1_COMP *cpi, FIRSTPASS_STATS *this_frame,
                            const EncodeFrameParams *const frame_params,
                            int max_gop_length, int is_final_pass) {
  AV1_COMMON *const cm = &cpi->common;
  RATE_CONTROL *const rc = &cpi->rc;
  AV1EncoderConfig *const oxcf = &cpi->oxcf;
  TWO_PASS *const twopass = &cpi->twopass;
  FIRSTPASS_STATS next_frame;
  const FIRSTPASS_STATS *const start_pos = twopass->stats_in;
  GF_GROUP *gf_group = &cpi->gf_group;
  FRAME_INFO *frame_info = &cpi->frame_info;
  int i;

  int flash_detected;
  int64_t gf_group_bits;
  const int is_intra_only = frame_params->frame_type == KEY_FRAME ||
                            frame_params->frame_type == INTRA_ONLY_FRAME;
  const int arf_active_or_kf = is_intra_only || rc->source_alt_ref_active;

  cpi->internal_altref_allowed = (oxcf->gf_max_pyr_height > 1);

  // Reset the GF group data structures unless this is a key
  // frame in which case it will already have been done.
  if (!is_intra_only) {
    av1_zero(cpi->gf_group);
  }

  aom_clear_system_state();
  av1_zero(next_frame);

  if (has_no_stats_stage(cpi)) {
    define_gf_group_pass0(cpi, frame_params);
    return;
  }

  // correct frames_to_key when lookahead queue is emptying
  if (cpi->lap_enabled) {
    correct_frames_to_key(cpi);
  }

  GF_GROUP_STATS gf_stats;
  init_gf_stats(&gf_stats);
  GF_FRAME_STATS first_frame_stats, last_frame_stats;

  gf_stats.allow_alt_ref = is_altref_enabled(cpi);
  const int can_disable_arf = (oxcf->gf_min_pyr_height == MIN_PYRAMID_LVL);

  // Load stats for the current frame.
  double mod_frame_err =
      calculate_modified_err(frame_info, twopass, oxcf, this_frame);

  // Note the error of the frame at the start of the group. This will be
  // the GF frame error if we code a normal gf.
  first_frame_stats.frame_err = mod_frame_err;
  first_frame_stats.frame_coded_error = this_frame->coded_error;
  first_frame_stats.frame_sr_coded_error = this_frame->sr_coded_error;
  first_frame_stats.frame_tr_coded_error = this_frame->tr_coded_error;

  // If this is a key frame or the overlay from a previous arf then
  // the error score / cost of this frame has already been accounted for.
  if (arf_active_or_kf) {
    gf_stats.gf_group_err -= first_frame_stats.frame_err;
#if GROUP_ADAPTIVE_MAXQ
    gf_stats.gf_group_raw_error -= this_frame->coded_error;
#endif
    gf_stats.gf_group_skip_pct -= this_frame->intra_skip_pct;
    gf_stats.gf_group_inactive_zone_rows -= this_frame->inactive_zone_rows;
  }

  // TODO(urvang): Try logic to vary min and max interval based on q.
  const int active_min_gf_interval = rc->min_gf_interval;
  const int active_max_gf_interval =
      AOMMIN(rc->max_gf_interval, max_gop_length);

  i = 0;
  // get the determined gf group length from rc->gf_intervals
  while (i < rc->gf_intervals[rc->cur_gf_index]) {
    ++i;
    // Accumulate error score of frames in this gf group.
    mod_frame_err =
        calculate_modified_err(frame_info, twopass, oxcf, this_frame);
    // accumulate stats for this frame
    accumulate_this_frame_stats(this_frame, mod_frame_err, &gf_stats);

    // read in the next frame
    if (EOF == input_stats(twopass, &next_frame)) break;

    // Test for the case where there is a brief flash but the prediction
    // quality back to an earlier frame is then restored.
    flash_detected = detect_flash(twopass, 0);

    // accumulate stats for next frame
    accumulate_next_frame_stats(
        &next_frame, frame_info, twopass, flash_detected, rc->frames_since_key,
        i, can_disable_arf, rc->min_gf_interval, &gf_stats);

    *this_frame = next_frame;
  }
  // save the errs for the last frame
  last_frame_stats.frame_coded_error = next_frame.coded_error;
  last_frame_stats.frame_sr_coded_error = next_frame.sr_coded_error;
  last_frame_stats.frame_tr_coded_error = next_frame.tr_coded_error;

  if (is_final_pass) {
    rc->intervals_till_gf_calculate_due--;
    rc->cur_gf_index++;
  }

  // Was the group length constrained by the requirement for a new KF?
  rc->constrained_gf_group = (i >= rc->frames_to_key) ? 1 : 0;

  const int num_mbs = (cpi->oxcf.resize_mode != RESIZE_NONE)
                          ? cpi->initial_mbs
                          : cm->mi_params.MBs;
  assert(num_mbs > 0);

  average_gf_stats(i, &next_frame, &gf_stats);

  // Disable internal ARFs for "still" gf groups.
  //   zero_motion_accumulator: minimum percentage of (0,0) motion;
  //   avg_sr_coded_error:      average of the SSE per pixel of each frame;
  //   avg_raw_err_stdev:       average of the standard deviation of (0,0)
  //                            motion error per block of each frame.
  const int can_disable_internal_arfs =
      (oxcf->gf_min_pyr_height <= MIN_PYRAMID_LVL + 1);
  if (can_disable_internal_arfs &&
      gf_stats.zero_motion_accumulator > MIN_ZERO_MOTION &&
      gf_stats.avg_sr_coded_error / num_mbs < MAX_SR_CODED_ERROR &&
      gf_stats.avg_raw_err_stdev < MAX_RAW_ERR_VAR) {
    cpi->internal_altref_allowed = 0;
  }

  int use_alt_ref;
  if (can_disable_arf) {
    use_alt_ref = !is_almost_static(gf_stats.zero_motion_accumulator,
                                    twopass->kf_zeromotion_pct) &&
                  gf_stats.allow_alt_ref && (i < cpi->oxcf.lag_in_frames) &&
                  (i >= MIN_GF_INTERVAL) &&
                  (cpi->oxcf.gf_max_pyr_height > MIN_PYRAMID_LVL);

    // TODO(urvang): Improve and use model for VBR, CQ etc as well.
    if (use_alt_ref && cpi->oxcf.rc_mode == AOM_Q &&
        cpi->oxcf.cq_level <= 200) {
      aom_clear_system_state();
      float features[21];
      get_features_from_gf_stats(
          &gf_stats, &first_frame_stats, &last_frame_stats, num_mbs,
          rc->constrained_gf_group, twopass->kf_zeromotion_pct, i, features);
      // Infer using ML model.
      float score;
      av1_nn_predict(features, &av1_use_flat_gop_nn_config, 1, &score);
      use_alt_ref = (score <= 0.0);
    }
  } else {
    assert(cpi->oxcf.gf_max_pyr_height > MIN_PYRAMID_LVL);
    use_alt_ref =
        gf_stats.allow_alt_ref && (i < cpi->oxcf.lag_in_frames) && (i > 2);
  }

#define REDUCE_GF_LENGTH_THRESH 4
#define REDUCE_GF_LENGTH_TO_KEY_THRESH 9
#define REDUCE_GF_LENGTH_BY 1
  int alt_offset = 0;
  // The length reduction strategy is tweaked for certain cases, and doesn't
  // work well for certain other cases.
  const int allow_gf_length_reduction =
      ((cpi->oxcf.rc_mode == AOM_Q && cpi->oxcf.cq_level <= 128) ||
       !cpi->internal_altref_allowed) &&
      !is_lossless_requested(&cpi->oxcf);

  if (allow_gf_length_reduction && use_alt_ref) {
    // adjust length of this gf group if one of the following condition met
    // 1: only one overlay frame left and this gf is too long
    // 2: next gf group is too short to have arf compared to the current gf

    // maximum length of next gf group
    const int next_gf_len = rc->frames_to_key - i;
    const int single_overlay_left =
        next_gf_len == 0 && i > REDUCE_GF_LENGTH_THRESH;
    // the next gf is probably going to have a ARF but it will be shorter than
    // this gf
    const int unbalanced_gf =
        i > REDUCE_GF_LENGTH_TO_KEY_THRESH &&
        next_gf_len + 1 < REDUCE_GF_LENGTH_TO_KEY_THRESH &&
        next_gf_len + 1 >= rc->min_gf_interval;

    if (single_overlay_left || unbalanced_gf) {
      const int roll_back = REDUCE_GF_LENGTH_BY;
      // Reduce length only if active_min_gf_interval will be respected later.
      if (i - roll_back >= active_min_gf_interval + 1) {
        alt_offset = -roll_back;
        i -= roll_back;
        if (is_final_pass) rc->intervals_till_gf_calculate_due = 0;
      }
    }
  }

  // Should we use the alternate reference frame.
  if (use_alt_ref) {
    rc->source_alt_ref_pending = 1;
    gf_group->max_layer_depth_allowed = cpi->oxcf.gf_max_pyr_height;
    set_baseline_gf_interval(cpi, i, active_max_gf_interval, use_alt_ref,
                             is_final_pass);

    const int forward_frames = (rc->frames_to_key - i >= i - 1)
                                   ? i - 1
                                   : AOMMAX(0, rc->frames_to_key - i);

    // Calculate the boost for alt ref.
    rc->gfu_boost = av1_calc_arf_boost(
        twopass, rc, frame_info, alt_offset, forward_frames, (i - 1),
        cpi->lap_enabled ? &rc->num_stats_used_for_gfu_boost : NULL,
        cpi->lap_enabled ? &rc->num_stats_required_for_gfu_boost : NULL);
  } else {
    reset_fpf_position(twopass, start_pos);
    rc->source_alt_ref_pending = 0;
    gf_group->max_layer_depth_allowed = 0;
    set_baseline_gf_interval(cpi, i, active_max_gf_interval, use_alt_ref,
                             is_final_pass);

    rc->gfu_boost = AOMMIN(
        MAX_GF_BOOST,
        av1_calc_arf_boost(
            twopass, rc, frame_info, alt_offset, (i - 1), 0,
            cpi->lap_enabled ? &rc->num_stats_used_for_gfu_boost : NULL,
            cpi->lap_enabled ? &rc->num_stats_required_for_gfu_boost : NULL));
  }

  // rc->gf_intervals assumes the usage of alt_ref, therefore adding one overlay
  // frame to the next gf. If no alt_ref is used, should substract 1 frame from
  // the next gf group.
  // TODO(bohanli): should incorporate the usage of alt_ref into
  // calculate_gf_length
  if (is_final_pass && rc->source_alt_ref_pending == 0 &&
      rc->intervals_till_gf_calculate_due > 0) {
    rc->gf_intervals[rc->cur_gf_index]--;
  }

#define LAST_ALR_BOOST_FACTOR 0.2f
  rc->arf_boost_factor = 1.0;
  if (rc->source_alt_ref_pending && !is_lossless_requested(&cpi->oxcf)) {
    // Reduce the boost of altref in the last gf group
    if (rc->frames_to_key - i == REDUCE_GF_LENGTH_BY ||
        rc->frames_to_key - i == 0) {
      rc->arf_boost_factor = LAST_ALR_BOOST_FACTOR;
    }
  }

  rc->frames_till_gf_update_due = rc->baseline_gf_interval;

  // Reset the file position.
  reset_fpf_position(twopass, start_pos);

  // Calculate the bits to be allocated to the gf/arf group as a whole
  gf_group_bits = calculate_total_gf_group_bits(cpi, gf_stats.gf_group_err);
  rc->gf_group_bits = gf_group_bits;

#if GROUP_ADAPTIVE_MAXQ
  // Calculate an estimate of the maxq needed for the group.
  // We are more agressive about correcting for sections
  // where there could be significant overshoot than for easier
  // sections where we do not wish to risk creating an overshoot
  // of the allocated bit budget.
  if ((cpi->oxcf.rc_mode != AOM_Q) && (rc->baseline_gf_interval > 1)) {
    const int vbr_group_bits_per_frame =
        (int)(gf_group_bits / rc->baseline_gf_interval);
    const double group_av_err =
        gf_stats.gf_group_raw_error / rc->baseline_gf_interval;
    const double group_av_skip_pct =
        gf_stats.gf_group_skip_pct / rc->baseline_gf_interval;
    const double group_av_inactive_zone =
        ((gf_stats.gf_group_inactive_zone_rows * 2) /
         (rc->baseline_gf_interval * (double)cm->mi_params.mb_rows));

    int tmp_q;
    // rc factor is a weight factor that corrects for local rate control drift.
    double rc_factor = 1.0;
    int64_t bits = cpi->oxcf.target_bandwidth;

    if (bits > 0) {
      int rate_error;

      rate_error = (int)((rc->vbr_bits_off_target * 100) / bits);
      rate_error = clamp(rate_error, -100, 100);
      if (rate_error > 0) {
        rc_factor = AOMMAX(RC_FACTOR_MIN, (double)(100 - rate_error) / 100.0);
      } else {
        rc_factor = AOMMIN(RC_FACTOR_MAX, (double)(100 - rate_error) / 100.0);
      }
    }

    tmp_q = get_twopass_worst_quality(
        cpi, group_av_err, (group_av_skip_pct + group_av_inactive_zone),
        vbr_group_bits_per_frame, rc_factor);
    rc->active_worst_quality = AOMMAX(tmp_q, rc->active_worst_quality >> 1);
  }
#endif

  // Adjust KF group bits and error remaining.
  if (is_final_pass)
    twopass->kf_group_error_left -= (int64_t)gf_stats.gf_group_err;

  // Set up the structure of this Group-Of-Pictures (same as GF_GROUP)
  av1_gop_setup_structure(cpi, frame_params);

  // Reset the file position.
  reset_fpf_position(twopass, start_pos);

  // Calculate a section intra ratio used in setting max loop filter.
  if (frame_params->frame_type != KEY_FRAME) {
    twopass->section_intra_rating = calculate_section_intra_ratio(
        start_pos, twopass->stats_buf_ctx->stats_in_end,
        rc->baseline_gf_interval);
  }

  // Reset rolling actual and target bits counters for ARF groups.
  twopass->rolling_arf_group_target_bits = 1;
  twopass->rolling_arf_group_actual_bits = 1;

  av1_gop_bit_allocation(cpi, rc, gf_group,
                         frame_params->frame_type == KEY_FRAME, use_alt_ref,
                         gf_group_bits);
}

// #define FIXED_ARF_BITS
#ifdef FIXED_ARF_BITS
#define ARF_BITS_FRACTION 0.75
#endif
void av1_gop_bit_allocation(const AV1_COMP *cpi, RATE_CONTROL *const rc,
                            GF_GROUP *gf_group, int is_key_frame, int use_arf,
                            int64_t gf_group_bits) {
  // Calculate the extra bits to be used for boosted frame(s)
#ifdef FIXED_ARF_BITS
  int gf_arf_bits = (int)(ARF_BITS_FRACTION * gf_group_bits);
#else
  int gf_arf_bits = calculate_boost_bits(rc->baseline_gf_interval,
                                         rc->gfu_boost, gf_group_bits);
#endif

  gf_arf_bits = adjust_boost_bits_for_target_level(cpi, rc, gf_arf_bits,
                                                   gf_group_bits, 1);

  // Allocate bits to each of the frames in the GF group.
  allocate_gf_group_bits(gf_group, rc, gf_group_bits, gf_arf_bits, is_key_frame,
                         use_arf);
}

// Minimum % intra coding observed in first pass (1.0 = 100%)
#define MIN_INTRA_LEVEL 0.25
// Minimum ratio between the % of intra coding and inter coding in the first
// pass after discounting neutral blocks (discounting neutral blocks in this
// way helps catch scene cuts in clips with very flat areas or letter box
// format clips with image padding.
#define INTRA_VS_INTER_THRESH 2.0
// Hard threshold where the first pass chooses intra for almost all blocks.
// In such a case even if the frame is not a scene cut coding a key frame
// may be a good option.
#define VERY_LOW_INTER_THRESH 0.05
// Maximum threshold for the relative ratio of intra error score vs best
// inter error score.
#define KF_II_ERR_THRESHOLD 2.5
// In real scene cuts there is almost always a sharp change in the intra
// or inter error score.
#define ERR_CHANGE_THRESHOLD 0.4
// For real scene cuts we expect an improvment in the intra inter error
// ratio in the next frame.
#define II_IMPROVEMENT_THRESHOLD 3.5
#define KF_II_MAX 128.0

// Threshold for use of the lagging second reference frame. High second ref
// usage may point to a transient event like a flash or occlusion rather than
// a real scene cut.
// We adapt the threshold based on number of frames in this key-frame group so
// far.
static double get_second_ref_usage_thresh(int frame_count_so_far) {
  const int adapt_upto = 32;
  const double min_second_ref_usage_thresh = 0.085;
  const double second_ref_usage_thresh_max_delta = 0.035;
  if (frame_count_so_far >= adapt_upto) {
    return min_second_ref_usage_thresh + second_ref_usage_thresh_max_delta;
  }
  return min_second_ref_usage_thresh +
         ((double)frame_count_so_far / (adapt_upto - 1)) *
             second_ref_usage_thresh_max_delta;
}

static int test_candidate_kf(TWO_PASS *twopass,
                             const FIRSTPASS_STATS *last_frame,
                             const FIRSTPASS_STATS *this_frame,
                             const FIRSTPASS_STATS *next_frame,
                             int frame_count_so_far, enum aom_rc_mode rc_mode) {
  int is_viable_kf = 0;
  double pcnt_intra = 1.0 - this_frame->pcnt_inter;
  double modified_pcnt_inter =
      this_frame->pcnt_inter - this_frame->pcnt_neutral;
  const double second_ref_usage_thresh =
      get_second_ref_usage_thresh(frame_count_so_far);

  // Does the frame satisfy the primary criteria of a key frame?
  // See above for an explanation of the test criteria.
  // If so, then examine how well it predicts subsequent frames.
  if (IMPLIES(rc_mode == AOM_Q, frame_count_so_far >= 3) &&
      (this_frame->pcnt_second_ref < second_ref_usage_thresh) &&
      (next_frame->pcnt_second_ref < second_ref_usage_thresh) &&
      ((this_frame->pcnt_inter < VERY_LOW_INTER_THRESH) ||
       ((pcnt_intra > MIN_INTRA_LEVEL) &&
        (pcnt_intra > (INTRA_VS_INTER_THRESH * modified_pcnt_inter)) &&
        ((this_frame->intra_error /
          DOUBLE_DIVIDE_CHECK(this_frame->coded_error)) <
         KF_II_ERR_THRESHOLD) &&
        ((fabs(last_frame->coded_error - this_frame->coded_error) /
              DOUBLE_DIVIDE_CHECK(this_frame->coded_error) >
          ERR_CHANGE_THRESHOLD) ||
         (fabs(last_frame->intra_error - this_frame->intra_error) /
              DOUBLE_DIVIDE_CHECK(this_frame->intra_error) >
          ERR_CHANGE_THRESHOLD) ||
         ((next_frame->intra_error /
           DOUBLE_DIVIDE_CHECK(next_frame->coded_error)) >
          II_IMPROVEMENT_THRESHOLD))))) {
    int i;
    const FIRSTPASS_STATS *start_pos = twopass->stats_in;
    FIRSTPASS_STATS local_next_frame = *next_frame;
    double boost_score = 0.0;
    double old_boost_score = 0.0;
    double decay_accumulator = 1.0;

    // Examine how well the key frame predicts subsequent frames.
    for (i = 0; i < SCENE_CUT_KEY_TEST_INTERVAL; ++i) {
      double next_iiratio = (BOOST_FACTOR * local_next_frame.intra_error /
                             DOUBLE_DIVIDE_CHECK(local_next_frame.coded_error));

      if (next_iiratio > KF_II_MAX) next_iiratio = KF_II_MAX;

      // Cumulative effect of decay in prediction quality.
      if (local_next_frame.pcnt_inter > 0.85)
        decay_accumulator *= local_next_frame.pcnt_inter;
      else
        decay_accumulator *= (0.85 + local_next_frame.pcnt_inter) / 2.0;

      // Keep a running total.
      boost_score += (decay_accumulator * next_iiratio);

      // Test various breakout clauses.
      if ((local_next_frame.pcnt_inter < 0.05) || (next_iiratio < 1.5) ||
          (((local_next_frame.pcnt_inter - local_next_frame.pcnt_neutral) <
            0.20) &&
           (next_iiratio < 3.0)) ||
          ((boost_score - old_boost_score) < 3.0) ||
          (local_next_frame.intra_error < 200)) {
        break;
      }

      old_boost_score = boost_score;

      // Get the next frame details
      if (EOF == input_stats(twopass, &local_next_frame)) break;
    }

    // If there is tolerable prediction for at least the next 3 frames then
    // break out else discard this potential key frame and move on
    if (boost_score > 30.0 && (i > 3)) {
      is_viable_kf = 1;
    } else {
      // Reset the file position
      reset_fpf_position(twopass, start_pos);

      is_viable_kf = 0;
    }
  }

  return is_viable_kf;
}

#define FRAMES_TO_CHECK_DECAY 8
#define KF_MIN_FRAME_BOOST 80.0
#define KF_MAX_FRAME_BOOST 128.0
#define MIN_KF_BOOST 600  // Minimum boost for non-static KF interval
#define MAX_KF_BOOST 3200
#define MIN_STATIC_KF_BOOST 5400  // Minimum boost for static KF interval

static int detect_app_forced_key(AV1_COMP *cpi) {
  if (cpi->oxcf.fwd_kf_enabled) cpi->rc.next_is_fwd_key = 1;
  int num_frames_to_app_forced_key = is_forced_keyframe_pending(
      cpi->lookahead, cpi->lookahead->max_sz, cpi->compressor_stage);
  if (num_frames_to_app_forced_key != -1) cpi->rc.next_is_fwd_key = 0;
  return num_frames_to_app_forced_key;
}

static int get_projected_kf_boost(AV1_COMP *cpi) {
  /*
   * If num_stats_used_for_kf_boost >= frames_to_key, then
   * all stats needed for prior boost calculation are available.
   * Hence projecting the prior boost is not needed in this cases.
   */
  if (cpi->rc.num_stats_used_for_kf_boost >= cpi->rc.frames_to_key)
    return cpi->rc.kf_boost;

  // Get the current tpl factor (number of frames = frames_to_key).
  double tpl_factor = av1_get_kf_boost_projection_factor(cpi->rc.frames_to_key);
  // Get the tpl factor when number of frames = num_stats_used_for_kf_boost.
  double tpl_factor_num_stats =
      av1_get_kf_boost_projection_factor(cpi->rc.num_stats_used_for_kf_boost);
  int projected_kf_boost =
      (int)rint((tpl_factor * cpi->rc.kf_boost) / tpl_factor_num_stats);
  return projected_kf_boost;
}

static int define_kf_interval(AV1_COMP *cpi, FIRSTPASS_STATS *this_frame,
                              double *kf_group_err,
                              int num_frames_to_detect_scenecut) {
  TWO_PASS *const twopass = &cpi->twopass;
  RATE_CONTROL *const rc = &cpi->rc;
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  double recent_loop_decay[FRAMES_TO_CHECK_DECAY];
  FIRSTPASS_STATS last_frame;
  double decay_accumulator = 1.0;
  int i = 0, j;
  int frames_to_key = 1;
  int frames_since_key = rc->frames_since_key + 1;
  FRAME_INFO *const frame_info = &cpi->frame_info;
  int num_stats_used_for_kf_boost = 1;
  int scenecut_detected = 0;

  int num_frames_to_next_key = detect_app_forced_key(cpi);

  if (num_frames_to_detect_scenecut == 0) {
    if (num_frames_to_next_key != -1)
      return num_frames_to_next_key;
    else
      return rc->frames_to_key;
  }

  if (num_frames_to_next_key != -1)
    num_frames_to_detect_scenecut =
        AOMMIN(num_frames_to_detect_scenecut, num_frames_to_next_key);

  // Initialize the decay rates for the recent frames to check
  for (j = 0; j < FRAMES_TO_CHECK_DECAY; ++j) recent_loop_decay[j] = 1.0;

  i = 0;
  while (twopass->stats_in < twopass->stats_buf_ctx->stats_in_end &&
         frames_to_key < num_frames_to_detect_scenecut) {
    // Accumulate total number of stats available till next key frame
    num_stats_used_for_kf_boost++;

    // Accumulate kf group error.
    if (kf_group_err != NULL)
      *kf_group_err +=
          calculate_modified_err(frame_info, twopass, oxcf, this_frame);

    // Load the next frame's stats.
    last_frame = *this_frame;
    input_stats(twopass, this_frame);

    // Provided that we are not at the end of the file...
    if (cpi->rc.enable_scenecut_detection && cpi->oxcf.auto_key &&
        twopass->stats_in < twopass->stats_buf_ctx->stats_in_end) {
      double loop_decay_rate;

      // Check for a scene cut.
      if (test_candidate_kf(twopass, &last_frame, this_frame, twopass->stats_in,
                            frames_since_key, oxcf->rc_mode)) {
        scenecut_detected = 1;
        break;
      }

      // How fast is the prediction quality decaying?
      loop_decay_rate =
          get_prediction_decay_rate(frame_info, twopass->stats_in);

      // We want to know something about the recent past... rather than
      // as used elsewhere where we are concerned with decay in prediction
      // quality since the last GF or KF.
      recent_loop_decay[i % FRAMES_TO_CHECK_DECAY] = loop_decay_rate;
      decay_accumulator = 1.0;
      for (j = 0; j < FRAMES_TO_CHECK_DECAY; ++j)
        decay_accumulator *= recent_loop_decay[j];

      // Special check for transition or high motion followed by a
      // static scene.
      if (detect_transition_to_still(twopass, rc->min_gf_interval, i,
                                     cpi->oxcf.key_freq - i, loop_decay_rate,
                                     decay_accumulator)) {
        scenecut_detected = 1;
        break;
      }

      // Step on to the next frame.
      ++frames_to_key;
      ++frames_since_key;

      // If we don't have a real key frame within the next two
      // key_freq intervals then break out of the loop.
      if (frames_to_key >= 2 * cpi->oxcf.key_freq) break;
    } else {
      ++frames_to_key;
      ++frames_since_key;
    }
    ++i;
  }

  if (kf_group_err != NULL)
    rc->num_stats_used_for_kf_boost = num_stats_used_for_kf_boost;

  if (cpi->lap_enabled && !scenecut_detected)
    frames_to_key = num_frames_to_next_key;

  return frames_to_key;
}

static void find_next_key_frame(AV1_COMP *cpi, FIRSTPASS_STATS *this_frame) {
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;
  GF_GROUP *const gf_group = &cpi->gf_group;
  FRAME_INFO *const frame_info = &cpi->frame_info;
  AV1_COMMON *const cm = &cpi->common;
  CurrentFrame *const current_frame = &cm->current_frame;
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  const FIRSTPASS_STATS first_frame = *this_frame;
  FIRSTPASS_STATS next_frame;
  av1_zero(next_frame);

  rc->frames_since_key = 0;

  // Reset the GF group data structures.
  av1_zero(*gf_group);

  // Clear the alt ref active flag and last group multi arf flags as they
  // can never be set for a key frame.
  rc->source_alt_ref_active = 0;

  // KF is always a GF so clear frames till next gf counter.
  rc->frames_till_gf_update_due = 0;

  rc->frames_to_key = 1;

  if (has_no_stats_stage(cpi)) {
    int num_frames_to_app_forced_key = detect_app_forced_key(cpi);
    rc->this_key_frame_forced =
        current_frame->frame_number != 0 && rc->frames_to_key == 0;
    if (num_frames_to_app_forced_key != -1)
      rc->frames_to_key = num_frames_to_app_forced_key;
    else
      rc->frames_to_key = AOMMAX(1, cpi->oxcf.key_freq);
    correct_frames_to_key(cpi);
    rc->kf_boost = DEFAULT_KF_BOOST;
    rc->source_alt_ref_active = 0;
    gf_group->update_type[0] = KF_UPDATE;
    return;
  }
  int i;
  const FIRSTPASS_STATS *const start_position = twopass->stats_in;
  int kf_bits = 0;
  double zero_motion_accumulator = 1.0;
  double boost_score = 0.0;
  double kf_raw_err = 0.0;
  double kf_mod_err = 0.0;
  double kf_group_err = 0.0;
  double sr_accumulator = 0.0;
  int frames_to_key;
  // Is this a forced key frame by interval.
  rc->this_key_frame_forced = rc->next_key_frame_forced;

  twopass->kf_group_bits = 0;        // Total bits available to kf group
  twopass->kf_group_error_left = 0;  // Group modified error score.

  kf_raw_err = this_frame->intra_error;
  kf_mod_err = calculate_modified_err(frame_info, twopass, oxcf, this_frame);

  frames_to_key =
      define_kf_interval(cpi, this_frame, &kf_group_err, oxcf->key_freq);

  if (frames_to_key != -1)
    rc->frames_to_key = AOMMIN(oxcf->key_freq, frames_to_key);
  else
    rc->frames_to_key = oxcf->key_freq;

  if (cpi->lap_enabled) correct_frames_to_key(cpi);

  // If there is a max kf interval set by the user we must obey it.
  // We already breakout of the loop above at 2x max.
  // This code centers the extra kf if the actual natural interval
  // is between 1x and 2x.
  if (cpi->oxcf.auto_key && rc->frames_to_key > cpi->oxcf.key_freq) {
    FIRSTPASS_STATS tmp_frame = first_frame;

    rc->frames_to_key /= 2;

    // Reset to the start of the group.
    reset_fpf_position(twopass, start_position);

    kf_group_err = 0.0;

    // Rescan to get the correct error data for the forced kf group.
    for (i = 0; i < rc->frames_to_key; ++i) {
      kf_group_err +=
          calculate_modified_err(frame_info, twopass, oxcf, &tmp_frame);
      if (EOF == input_stats(twopass, &tmp_frame)) break;
    }
    rc->next_key_frame_forced = 1;
  } else if ((twopass->stats_in == twopass->stats_buf_ctx->stats_in_end &&
              is_stat_consumption_stage_twopass(cpi)) ||
             rc->frames_to_key >= cpi->oxcf.key_freq) {
    rc->next_key_frame_forced = 1;
  } else {
    rc->next_key_frame_forced = 0;
  }

  // Special case for the last key frame of the file.
  if (twopass->stats_in >= twopass->stats_buf_ctx->stats_in_end) {
    // Accumulate kf group error.
    kf_group_err +=
        calculate_modified_err(frame_info, twopass, oxcf, this_frame);
  }

  // Calculate the number of bits that should be assigned to the kf group.
  if (twopass->bits_left > 0 && twopass->modified_error_left > 0.0) {
    // Maximum number of bits for a single normal frame (not key frame).
    const int max_bits = frame_max_bits(rc, &cpi->oxcf);

    // Maximum number of bits allocated to the key frame group.
    int64_t max_grp_bits;

    // Default allocation based on bits left and relative
    // complexity of the section.
    twopass->kf_group_bits = (int64_t)(
        twopass->bits_left * (kf_group_err / twopass->modified_error_left));

    // Clip based on maximum per frame rate defined by the user.
    max_grp_bits = (int64_t)max_bits * (int64_t)rc->frames_to_key;
    if (twopass->kf_group_bits > max_grp_bits)
      twopass->kf_group_bits = max_grp_bits;
  } else {
    twopass->kf_group_bits = 0;
  }
  twopass->kf_group_bits = AOMMAX(0, twopass->kf_group_bits);

  // Reset the first pass file position.
  reset_fpf_position(twopass, start_position);

  // Scan through the kf group collating various stats used to determine
  // how many bits to spend on it.
  boost_score = 0.0;
  const double kf_max_boost =
      cpi->oxcf.rc_mode == AOM_Q
          ? AOMMIN(AOMMAX(rc->frames_to_key * 2.0, KF_MIN_FRAME_BOOST),
                   KF_MAX_FRAME_BOOST)
          : KF_MAX_FRAME_BOOST;
  for (i = 0; i < (rc->frames_to_key - 1); ++i) {
    if (EOF == input_stats(twopass, &next_frame)) break;

    // Monitor for static sections.
    // For the first frame in kf group, the second ref indicator is invalid.
    if (i > 0) {
      zero_motion_accumulator =
          AOMMIN(zero_motion_accumulator,
                 get_zero_motion_factor(frame_info, &next_frame));
    } else {
      zero_motion_accumulator = next_frame.pcnt_inter - next_frame.pcnt_motion;
    }

    // Not all frames in the group are necessarily used in calculating boost.
    if ((sr_accumulator < (kf_raw_err * 1.50)) &&
        (i <= rc->max_gf_interval * 2)) {
      double frame_boost;
      double zm_factor;

      // Factor 0.75-1.25 based on how much of frame is static.
      zm_factor = (0.75 + (zero_motion_accumulator / 2.0));

      if (i < 2) sr_accumulator = 0.0;
      frame_boost = calc_kf_frame_boost(rc, frame_info, &next_frame,
                                        &sr_accumulator, kf_max_boost);
      boost_score += frame_boost * zm_factor;
    }
  }

  reset_fpf_position(twopass, start_position);

  // Store the zero motion percentage
  twopass->kf_zeromotion_pct = (int)(zero_motion_accumulator * 100.0);

  // Calculate a section intra ratio used in setting max loop filter.
  twopass->section_intra_rating = calculate_section_intra_ratio(
      start_position, twopass->stats_buf_ctx->stats_in_end, rc->frames_to_key);

  rc->kf_boost = (int)boost_score;

  if (cpi->lap_enabled) {
    rc->kf_boost = get_projected_kf_boost(cpi);
  }

  // Special case for static / slide show content but don't apply
  // if the kf group is very short.
  if ((zero_motion_accumulator > STATIC_KF_GROUP_FLOAT_THRESH) &&
      (rc->frames_to_key > 8)) {
    rc->kf_boost = AOMMAX(rc->kf_boost, MIN_STATIC_KF_BOOST);
  } else {
    // Apply various clamps for min and max boost
    rc->kf_boost = AOMMAX(rc->kf_boost, (rc->frames_to_key * 3));
    rc->kf_boost = AOMMAX(rc->kf_boost, MIN_KF_BOOST);
#ifdef STRICT_RC
    rc->kf_boost = AOMMIN(rc->kf_boost, MAX_KF_BOOST);
#endif
  }

  // Work out how many bits to allocate for the key frame itself.
  kf_bits = calculate_boost_bits((rc->frames_to_key - 1), rc->kf_boost,
                                 twopass->kf_group_bits);
  // printf("kf boost = %d kf_bits = %d kf_zeromotion_pct = %d\n", rc->kf_boost,
  //        kf_bits, twopass->kf_zeromotion_pct);
  kf_bits = adjust_boost_bits_for_target_level(cpi, rc, kf_bits,
                                               twopass->kf_group_bits, 0);

  twopass->kf_group_bits -= kf_bits;

  // Save the bits to spend on the key frame.
  gf_group->bit_allocation[0] = kf_bits;
  gf_group->update_type[0] = KF_UPDATE;

  // Note the total error score of the kf group minus the key frame itself.
  twopass->kf_group_error_left = (int)(kf_group_err - kf_mod_err);

  // Adjust the count of total modified error left.
  // The count of bits left is adjusted elsewhere based on real coded frame
  // sizes.
  twopass->modified_error_left -= kf_group_err;
}

static int is_skippable_frame(const AV1_COMP *cpi) {
  if (has_no_stats_stage(cpi)) return 0;
  // If the current frame does not have non-zero motion vector detected in the
  // first  pass, and so do its previous and forward frames, then this frame
  // can be skipped for partition check, and the partition size is assigned
  // according to the variance
  const TWO_PASS *const twopass = &cpi->twopass;

  return (!frame_is_intra_only(&cpi->common) &&
          twopass->stats_in - 2 > twopass->stats_buf_ctx->stats_in_start &&
          twopass->stats_in < twopass->stats_buf_ctx->stats_in_end &&
          (twopass->stats_in - 1)->pcnt_inter -
                  (twopass->stats_in - 1)->pcnt_motion ==
              1 &&
          (twopass->stats_in - 2)->pcnt_inter -
                  (twopass->stats_in - 2)->pcnt_motion ==
              1 &&
          twopass->stats_in->pcnt_inter - twopass->stats_in->pcnt_motion == 1);
}

#define ARF_STATS_OUTPUT 0
#if ARF_STATS_OUTPUT
unsigned int arf_count = 0;
#endif
#define DEFAULT_GRP_WEIGHT 1.0

static void process_first_pass_stats(AV1_COMP *cpi,
                                     FIRSTPASS_STATS *this_frame) {
  AV1_COMMON *const cm = &cpi->common;
  CurrentFrame *const current_frame = &cm->current_frame;
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;

  if (cpi->oxcf.rc_mode != AOM_Q && current_frame->frame_number == 0 &&
      cpi->twopass.stats_buf_ctx->total_stats &&
      cpi->twopass.stats_buf_ctx->total_left_stats) {
    if (cpi->lap_enabled) {
      /*
       * Accumulate total_stats using available limited number of stats,
       * and assign it to total_left_stats.
       */
      *cpi->twopass.stats_buf_ctx->total_left_stats =
          *cpi->twopass.stats_buf_ctx->total_stats;
    }
    const int frames_left = (int)(twopass->stats_buf_ctx->total_stats->count -
                                  current_frame->frame_number);

    // Special case code for first frame.
    const int section_target_bandwidth =
        (int)(twopass->bits_left / frames_left);
    const double section_length =
        twopass->stats_buf_ctx->total_left_stats->count;
    const double section_error =
        twopass->stats_buf_ctx->total_left_stats->coded_error / section_length;
    const double section_intra_skip =
        twopass->stats_buf_ctx->total_left_stats->intra_skip_pct /
        section_length;
    const double section_inactive_zone =
        (twopass->stats_buf_ctx->total_left_stats->inactive_zone_rows * 2) /
        ((double)cm->mi_params.mb_rows * section_length);
    const int tmp_q = get_twopass_worst_quality(
        cpi, section_error, section_intra_skip + section_inactive_zone,
        section_target_bandwidth, DEFAULT_GRP_WEIGHT);

    rc->active_worst_quality = tmp_q;
    rc->ni_av_qi = tmp_q;
    rc->last_q[INTER_FRAME] = tmp_q;
    rc->avg_q = av1_convert_qindex_to_q(tmp_q, cm->seq_params.bit_depth);
    rc->avg_frame_qindex[INTER_FRAME] = tmp_q;
    rc->last_q[KEY_FRAME] = (tmp_q + cpi->oxcf.best_allowed_q) / 2;
    rc->avg_frame_qindex[KEY_FRAME] = rc->last_q[KEY_FRAME];
  }

  int err = 0;
  if (cpi->lap_enabled) {
    err = input_stats_lap(twopass, this_frame);
  } else {
    err = input_stats(twopass, this_frame);
  }
  if (err == EOF) return;

  {
    const int num_mbs = (cpi->oxcf.resize_mode != RESIZE_NONE)
                            ? cpi->initial_mbs
                            : cm->mi_params.MBs;
    // The multiplication by 256 reverses a scaling factor of (>> 8)
    // applied when combining MB error values for the frame.
    twopass->mb_av_energy = log((this_frame->intra_error / num_mbs) + 1.0);
    twopass->frame_avg_haar_energy =
        log((this_frame->frame_avg_wavelet_energy / num_mbs) + 1.0);
  }

  // Update the total stats remaining structure.
  if (twopass->stats_buf_ctx->total_left_stats)
    subtract_stats(twopass->stats_buf_ctx->total_left_stats, this_frame);

  // Set the frame content type flag.
  if (this_frame->intra_skip_pct >= FC_ANIMATION_THRESH)
    twopass->fr_content_type = FC_GRAPHICS_ANIMATION;
  else
    twopass->fr_content_type = FC_NORMAL;
}

static void setup_target_rate(AV1_COMP *cpi) {
  RATE_CONTROL *const rc = &cpi->rc;
  GF_GROUP *const gf_group = &cpi->gf_group;

  int target_rate = gf_group->bit_allocation[gf_group->index];

  if (has_no_stats_stage(cpi)) {
    av1_rc_set_frame_target(cpi, target_rate, cpi->common.width,
                            cpi->common.height);
  }

  rc->base_frame_target = target_rate;
}

void av1_get_second_pass_params(AV1_COMP *cpi,
                                EncodeFrameParams *const frame_params,
                                const EncodeFrameInput *const frame_input,
                                unsigned int frame_flags) {
  RATE_CONTROL *const rc = &cpi->rc;
  TWO_PASS *const twopass = &cpi->twopass;
  GF_GROUP *const gf_group = &cpi->gf_group;
  AV1_COMMON *cm = &cpi->common;

  if (frame_is_intra_only(cm)) {
    FeatureFlags *const features = &cm->features;
    av1_set_screen_content_options(cpi, features);
    cpi->is_screen_content_type = features->allow_screen_content_tools;
  }

  if (is_stat_consumption_stage(cpi) && !twopass->stats_in) return;

  if (rc->frames_till_gf_update_due > 0 && !(frame_flags & FRAMEFLAGS_KEY)) {
    assert(gf_group->index < gf_group->size);
    const int update_type = gf_group->update_type[gf_group->index];

    setup_target_rate(cpi);

    // If this is an arf frame then we dont want to read the stats file or
    // advance the input pointer as we already have what we need.
    if (update_type == ARF_UPDATE || update_type == INTNL_ARF_UPDATE) {
      if (cpi->no_show_kf) {
        assert(update_type == ARF_UPDATE);
        frame_params->frame_type = KEY_FRAME;
      } else {
        frame_params->frame_type = INTER_FRAME;
      }

      // Do the firstpass stats indicate that this frame is skippable for the
      // partition search?
      if (cpi->sf.part_sf.allow_partition_search_skip && cpi->oxcf.pass == 2) {
        cpi->partition_search_skippable_frame = is_skippable_frame(cpi);
      }

      return;
    }
  }

  aom_clear_system_state();

  if (cpi->oxcf.rc_mode == AOM_Q) rc->active_worst_quality = cpi->oxcf.cq_level;
  FIRSTPASS_STATS this_frame;
  av1_zero(this_frame);
  // call above fn
  if (is_stat_consumption_stage(cpi)) {
    process_first_pass_stats(cpi, &this_frame);
  } else {
    rc->active_worst_quality = cpi->oxcf.cq_level;
  }

  // Keyframe and section processing.
  if (rc->frames_to_key == 0 || (frame_flags & FRAMEFLAGS_KEY)) {
    FIRSTPASS_STATS this_frame_copy;
    this_frame_copy = this_frame;
    frame_params->frame_type = KEY_FRAME;
    // Define next KF group and assign bits to it.
    find_next_key_frame(cpi, &this_frame);
    this_frame = this_frame_copy;
  } else {
    frame_params->frame_type = INTER_FRAME;
    const int altref_enabled = is_altref_enabled(cpi);
    const int sframe_dist = cpi->oxcf.sframe_dist;
    const int sframe_mode = cpi->oxcf.sframe_mode;
    const int sframe_enabled = cpi->oxcf.sframe_enabled;
    const int update_type = gf_group->update_type[gf_group->index];
    CurrentFrame *const current_frame = &cpi->common.current_frame;
    if (sframe_enabled) {
      if (altref_enabled) {
        if (sframe_mode == 1) {
          // sframe_mode == 1: insert sframe if it matches altref frame.
          if (current_frame->frame_number % sframe_dist == 0 &&
              current_frame->frame_number != 0 && update_type == ARF_UPDATE) {
            frame_params->frame_type = S_FRAME;
          }
        } else {
          // sframe_mode != 1: if sframe will be inserted at the next available
          // altref frame
          if (current_frame->frame_number % sframe_dist == 0 &&
              current_frame->frame_number != 0) {
            rc->sframe_due = 1;
          }
          if (rc->sframe_due && update_type == ARF_UPDATE) {
            frame_params->frame_type = S_FRAME;
            rc->sframe_due = 0;
          }
        }
      } else {
        if (current_frame->frame_number % sframe_dist == 0 &&
            current_frame->frame_number != 0) {
          frame_params->frame_type = S_FRAME;
        }
      }
    }
  }

  // Define a new GF/ARF group. (Should always enter here for key frames).
  if (rc->frames_till_gf_update_due == 0) {
    assert(cpi->common.current_frame.frame_number == 0 ||
           gf_group->index == gf_group->size);
    const FIRSTPASS_STATS *const start_position = twopass->stats_in;
    int num_frames_to_detect_scenecut, frames_to_key;
    if (cpi->lap_enabled && cpi->rc.enable_scenecut_detection)
      num_frames_to_detect_scenecut = MAX_GF_LENGTH_LAP + 1;
    else
      num_frames_to_detect_scenecut = 0;
    frames_to_key = define_kf_interval(cpi, &this_frame, NULL,
                                       num_frames_to_detect_scenecut);
    reset_fpf_position(twopass, start_position);
    if (frames_to_key != -1)
      rc->frames_to_key = AOMMIN(rc->frames_to_key, frames_to_key);

    int max_gop_length = (cpi->oxcf.lag_in_frames >= 32 &&
                          is_stat_consumption_stage_twopass(cpi))
                             ? MAX_GF_INTERVAL
                             : MAX_GF_LENGTH_LAP;
    if (rc->intervals_till_gf_calculate_due == 0) {
      calculate_gf_length(cpi, max_gop_length, MAX_NUM_GF_INTERVALS);
    }

    if (max_gop_length > 16) {
      if (rc->gf_intervals[rc->cur_gf_index] - 1 > 16) {
        // The calculate_gf_length function is previously used with
        // max_gop_length = 32 with look-ahead gf intervals.
        define_gf_group(cpi, &this_frame, frame_params, max_gop_length, 0);
        if (!av1_tpl_setup_stats(cpi, 1, frame_params, frame_input)) {
          // Tpl decides that a shorter gf interval is better.
          // TODO(jingning): Remove redundant computations here.
          max_gop_length = 16;
          calculate_gf_length(cpi, max_gop_length, 1);
        }
      } else {
        // Even based on 32 we still decide to use a short gf interval.
        // Better to re-decide based on 16 then
        max_gop_length = 16;
        calculate_gf_length(cpi, max_gop_length, 1);
      }
    }
    define_gf_group(cpi, &this_frame, frame_params, max_gop_length, 1);
    rc->frames_till_gf_update_due = rc->baseline_gf_interval;
    cpi->num_gf_group_show_frames = 0;
    assert(gf_group->index == 0);

#if ARF_STATS_OUTPUT
    {
      FILE *fpfile;
      fpfile = fopen("arf.stt", "a");
      ++arf_count;
      fprintf(fpfile, "%10d %10d %10d %10d %10d\n",
              cpi->common.current_frame.frame_number,
              rc->frames_till_gf_update_due, rc->kf_boost, arf_count,
              rc->gfu_boost);

      fclose(fpfile);
    }
#endif
  }
  assert(gf_group->index < gf_group->size);

  // Do the firstpass stats indicate that this frame is skippable for the
  // partition search?
  if (cpi->sf.part_sf.allow_partition_search_skip && cpi->oxcf.pass == 2) {
    cpi->partition_search_skippable_frame = is_skippable_frame(cpi);
  }

  setup_target_rate(cpi);
}

void av1_init_second_pass(AV1_COMP *cpi) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  TWO_PASS *const twopass = &cpi->twopass;
  FRAME_INFO *const frame_info = &cpi->frame_info;
  double frame_rate;
  FIRSTPASS_STATS *stats;

  if (!twopass->stats_buf_ctx->stats_in_end) return;

  stats = twopass->stats_buf_ctx->total_stats;

  *stats = *twopass->stats_buf_ctx->stats_in_end;
  *twopass->stats_buf_ctx->total_left_stats = *stats;

  frame_rate = 10000000.0 * stats->count / stats->duration;
  // Each frame can have a different duration, as the frame rate in the source
  // isn't guaranteed to be constant. The frame rate prior to the first frame
  // encoded in the second pass is a guess. However, the sum duration is not.
  // It is calculated based on the actual durations of all frames from the
  // first pass.
  av1_new_framerate(cpi, frame_rate);
  twopass->bits_left =
      (int64_t)(stats->duration * oxcf->target_bandwidth / 10000000.0);

  // This variable monitors how far behind the second ref update is lagging.
  twopass->sr_update_lag = 1;

  // Scan the first pass file and calculate a modified total error based upon
  // the bias/power function used to allocate bits.
  {
    const double avg_error =
        stats->coded_error / DOUBLE_DIVIDE_CHECK(stats->count);
    const FIRSTPASS_STATS *s = twopass->stats_in;
    double modified_error_total = 0.0;
    twopass->modified_error_min =
        (avg_error * oxcf->two_pass_vbrmin_section) / 100;
    twopass->modified_error_max =
        (avg_error * oxcf->two_pass_vbrmax_section) / 100;
    while (s < twopass->stats_buf_ctx->stats_in_end) {
      modified_error_total +=
          calculate_modified_err(frame_info, twopass, oxcf, s);
      ++s;
    }
    twopass->modified_error_left = modified_error_total;
  }

  // Reset the vbr bits off target counters
  cpi->rc.vbr_bits_off_target = 0;
  cpi->rc.vbr_bits_off_target_fast = 0;

  cpi->rc.rate_error_estimate = 0;

  // Static sequence monitor variables.
  twopass->kf_zeromotion_pct = 100;
  twopass->last_kfgroup_zeromotion_pct = 100;

  // Initialize bits per macro_block estimate correction factor.
  twopass->bpm_factor = 1.0;
  // Initialize actual and target bits counters for ARF groups so that
  // at the start we have a neutral bpm adjustment.
  twopass->rolling_arf_group_target_bits = 1;
  twopass->rolling_arf_group_actual_bits = 1;
}

void av1_init_single_pass_lap(AV1_COMP *cpi) {
  TWO_PASS *const twopass = &cpi->twopass;

  if (!twopass->stats_buf_ctx->stats_in_end) return;

  // This variable monitors how far behind the second ref update is lagging.
  twopass->sr_update_lag = 1;

  twopass->bits_left = 0;
  twopass->modified_error_min = 0.0;
  twopass->modified_error_max = 0.0;
  twopass->modified_error_left = 0.0;

  // Reset the vbr bits off target counters
  cpi->rc.vbr_bits_off_target = 0;
  cpi->rc.vbr_bits_off_target_fast = 0;

  cpi->rc.rate_error_estimate = 0;

  // Static sequence monitor variables.
  twopass->kf_zeromotion_pct = 100;
  twopass->last_kfgroup_zeromotion_pct = 100;

  // Initialize bits per macro_block estimate correction factor.
  twopass->bpm_factor = 1.0;
  // Initialize actual and target bits counters for ARF groups so that
  // at the start we have a neutral bpm adjustment.
  twopass->rolling_arf_group_target_bits = 1;
  twopass->rolling_arf_group_actual_bits = 1;
}

#define MINQ_ADJ_LIMIT 48
#define MINQ_ADJ_LIMIT_CQ 20
#define HIGH_UNDERSHOOT_RATIO 2
void av1_twopass_postencode_update(AV1_COMP *cpi) {
  TWO_PASS *const twopass = &cpi->twopass;
  RATE_CONTROL *const rc = &cpi->rc;
  const int bits_used = rc->base_frame_target;

  // VBR correction is done through rc->vbr_bits_off_target. Based on the
  // sign of this value, a limited % adjustment is made to the target rate
  // of subsequent frames, to try and push it back towards 0. This method
  // is designed to prevent extreme behaviour at the end of a clip
  // or group of frames.
  rc->vbr_bits_off_target += rc->base_frame_target - rc->projected_frame_size;
  twopass->bits_left = AOMMAX(twopass->bits_left - bits_used, 0);

  // Target vs actual bits for this arf group.
  twopass->rolling_arf_group_target_bits += rc->this_frame_target;
  twopass->rolling_arf_group_actual_bits += rc->projected_frame_size;

  // Calculate the pct rc error.
  if (rc->total_actual_bits) {
    rc->rate_error_estimate =
        (int)((rc->vbr_bits_off_target * 100) / rc->total_actual_bits);
    rc->rate_error_estimate = clamp(rc->rate_error_estimate, -100, 100);
  } else {
    rc->rate_error_estimate = 0;
  }

  // Update the active best quality pyramid.
  if (!rc->is_src_frame_alt_ref) {
    const int pyramid_level = cpi->gf_group.layer_depth[cpi->gf_group.index];
    int i;
    for (i = pyramid_level; i <= MAX_ARF_LAYERS; ++i) {
      rc->active_best_quality[i] = cpi->common.quant_params.base_qindex;
      // if (pyramid_level >= 2) {
      //   rc->active_best_quality[pyramid_level] =
      //     AOMMAX(rc->active_best_quality[pyramid_level],
      //            cpi->common.base_qindex);
      // }
    }
  }

#if 0
  {
    AV1_COMMON *cm = &cpi->common;
    FILE *fpfile;
    fpfile = fopen("details.stt", "a");
    fprintf(fpfile,
            "%10d %10d %10d %10" PRId64 " %10" PRId64
            " %10d %10d %10d %10.4lf %10.4lf %10.4lf %10.4lf\n",
            cm->current_frame.frame_number, rc->base_frame_target,
            rc->projected_frame_size, rc->total_actual_bits,
            rc->vbr_bits_off_target, rc->rate_error_estimate,
            twopass->rolling_arf_group_target_bits,
            twopass->rolling_arf_group_actual_bits,
            (double)twopass->rolling_arf_group_actual_bits /
                (double)twopass->rolling_arf_group_target_bits,
            twopass->bpm_factor,
            av1_convert_qindex_to_q(quant_params->base_qindex,
                                    cm->seq_params.bit_depth),
            av1_convert_qindex_to_q(rc->active_worst_quality,
                                    cm->seq_params.bit_depth));
    fclose(fpfile);
  }
#endif

  if (cpi->common.current_frame.frame_type != KEY_FRAME) {
    twopass->kf_group_bits -= bits_used;
    twopass->last_kfgroup_zeromotion_pct = twopass->kf_zeromotion_pct;
  }
  twopass->kf_group_bits = AOMMAX(twopass->kf_group_bits, 0);

  // If the rate control is drifting consider adjustment to min or maxq.
  if ((cpi->oxcf.rc_mode != AOM_Q) && !cpi->rc.is_src_frame_alt_ref) {
    const int maxq_adj_limit = rc->worst_quality - rc->active_worst_quality;
    const int minq_adj_limit =
        (cpi->oxcf.rc_mode == AOM_CQ ? MINQ_ADJ_LIMIT_CQ : MINQ_ADJ_LIMIT);

    // Undershoot.
    if (rc->rate_error_estimate > cpi->oxcf.under_shoot_pct) {
      --twopass->extend_maxq;
      if (rc->rolling_target_bits >= rc->rolling_actual_bits)
        ++twopass->extend_minq;
      // Overshoot.
    } else if (rc->rate_error_estimate < -cpi->oxcf.over_shoot_pct) {
      --twopass->extend_minq;
      if (rc->rolling_target_bits < rc->rolling_actual_bits)
        ++twopass->extend_maxq;
    } else {
      // Adjustment for extreme local overshoot.
      if (rc->projected_frame_size > (2 * rc->base_frame_target) &&
          rc->projected_frame_size > (2 * rc->avg_frame_bandwidth))
        ++twopass->extend_maxq;

      // Unwind undershoot or overshoot adjustment.
      if (rc->rolling_target_bits < rc->rolling_actual_bits)
        --twopass->extend_minq;
      else if (rc->rolling_target_bits > rc->rolling_actual_bits)
        --twopass->extend_maxq;
    }

    twopass->extend_minq = clamp(twopass->extend_minq, 0, minq_adj_limit);
    twopass->extend_maxq = clamp(twopass->extend_maxq, 0, maxq_adj_limit);

    // If there is a big and undexpected undershoot then feed the extra
    // bits back in quickly. One situation where this may happen is if a
    // frame is unexpectedly almost perfectly predicted by the ARF or GF
    // but not very well predcited by the previous frame.
    if (!frame_is_kf_gf_arf(cpi) && !cpi->rc.is_src_frame_alt_ref) {
      int fast_extra_thresh = rc->base_frame_target / HIGH_UNDERSHOOT_RATIO;
      if (rc->projected_frame_size < fast_extra_thresh) {
        rc->vbr_bits_off_target_fast +=
            fast_extra_thresh - rc->projected_frame_size;
        rc->vbr_bits_off_target_fast =
            AOMMIN(rc->vbr_bits_off_target_fast, (4 * rc->avg_frame_bandwidth));

        // Fast adaptation of minQ if necessary to use up the extra bits.
        if (rc->avg_frame_bandwidth) {
          twopass->extend_minq_fast =
              (int)(rc->vbr_bits_off_target_fast * 8 / rc->avg_frame_bandwidth);
        }
        twopass->extend_minq_fast = AOMMIN(
            twopass->extend_minq_fast, minq_adj_limit - twopass->extend_minq);
      } else if (rc->vbr_bits_off_target_fast) {
        twopass->extend_minq_fast = AOMMIN(
            twopass->extend_minq_fast, minq_adj_limit - twopass->extend_minq);
      } else {
        twopass->extend_minq_fast = 0;
      }
    }
  }
}
