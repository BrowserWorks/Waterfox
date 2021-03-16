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
#include <stdlib.h>
#include <string.h>

#include "config/aom_config.h"
#include "config/aom_version.h"

#include "aom_ports/aom_once.h"
#include "aom_ports/mem_ops.h"
#include "aom_ports/system_state.h"

#include "aom/aom_encoder.h"
#include "aom/internal/aom_codec_internal.h"

#include "av1/av1_iface_common.h"
#include "av1/encoder/bitstream.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/firstpass.h"

#define MAG_SIZE (4)

struct av1_extracfg {
  int cpu_used;
  unsigned int enable_auto_alt_ref;
  unsigned int enable_auto_bwd_ref;
  unsigned int noise_sensitivity;
  unsigned int sharpness;
  unsigned int static_thresh;
  unsigned int row_mt;
  unsigned int tile_columns;  // log2 number of tile columns
  unsigned int tile_rows;     // log2 number of tile rows
  unsigned int enable_tpl_model;
  unsigned int enable_keyframe_filtering;
  unsigned int arnr_max_frames;
  unsigned int arnr_strength;
  unsigned int min_gf_interval;
  unsigned int max_gf_interval;
  unsigned int gf_min_pyr_height;
  unsigned int gf_max_pyr_height;
  aom_tune_metric tuning;
  const char *vmaf_model_path;
  unsigned int cq_level;  // constrained quality level
  unsigned int rc_max_intra_bitrate_pct;
  unsigned int rc_max_inter_bitrate_pct;
  unsigned int gf_cbr_boost_pct;
  unsigned int lossless;
  unsigned int enable_cdef;
  unsigned int enable_restoration;
  unsigned int force_video_mode;
  unsigned int enable_obmc;
  unsigned int disable_trellis_quant;
  unsigned int enable_qm;
  unsigned int qm_y;
  unsigned int qm_u;
  unsigned int qm_v;
  unsigned int qm_min;
  unsigned int qm_max;
  unsigned int num_tg;
  unsigned int mtu_size;

  aom_timing_info_type_t timing_info_type;
  unsigned int frame_parallel_decoding_mode;
  int enable_dual_filter;
  unsigned int enable_chroma_deltaq;
  AQ_MODE aq_mode;
  DELTAQ_MODE deltaq_mode;
  int deltalf_mode;
  unsigned int frame_periodic_boost;
  aom_bit_depth_t bit_depth;
  aom_tune_content content;
  aom_color_primaries_t color_primaries;
  aom_transfer_characteristics_t transfer_characteristics;
  aom_matrix_coefficients_t matrix_coefficients;
  aom_chroma_sample_position_t chroma_sample_position;
  int color_range;
  int render_width;
  int render_height;
  aom_superblock_size_t superblock_size;
  unsigned int single_tile_decoding;
  int error_resilient_mode;
  int s_frame_mode;

  int film_grain_test_vector;
  const char *film_grain_table_filename;
  unsigned int motion_vector_unit_test;
  unsigned int cdf_update_mode;
  int enable_rect_partitions;    // enable rectangular partitions for sequence
  int enable_ab_partitions;      // enable AB partitions for sequence
  int enable_1to4_partitions;    // enable 1:4 and 4:1 partitions for sequence
  int min_partition_size;        // min partition size [4,8,16,32,64,128]
  int max_partition_size;        // max partition size [4,8,16,32,64,128]
  int enable_intra_edge_filter;  // enable intra-edge filter for sequence
  int enable_order_hint;         // enable order hint for sequence
  int enable_tx64;               // enable 64-pt transform usage for sequence
  int enable_flip_idtx;          // enable flip and identity transform types
  int enable_dist_wtd_comp;      // enable dist wtd compound for sequence
  int max_reference_frames;      // maximum number of references per frame
  int enable_reduced_reference_set;  // enable reduced set of references
  int enable_ref_frame_mvs;          // sequence level
  int allow_ref_frame_mvs;           // frame level
  int enable_masked_comp;            // enable masked compound for sequence
  int enable_onesided_comp;          // enable one sided compound for sequence
  int enable_interintra_comp;        // enable interintra compound for sequence
  int enable_smooth_interintra;      // enable smooth interintra mode usage
  int enable_diff_wtd_comp;          // enable diff-wtd compound usage
  int enable_interinter_wedge;       // enable interinter-wedge compound usage
  int enable_interintra_wedge;       // enable interintra-wedge compound usage
  int enable_global_motion;          // enable global motion usage for sequence
  int enable_warped_motion;          // sequence level
  int allow_warped_motion;           // frame level
  int enable_filter_intra;           // enable filter intra for sequence
  int enable_smooth_intra;           // enable smooth intra modes for sequence
  int enable_paeth_intra;            // enable Paeth intra mode for sequence
  int enable_cfl_intra;              // enable CFL uv intra mode for sequence
  int enable_superres;
  int enable_overlay;  // enable overlay for filtered arf frames
  int enable_palette;
  int enable_intrabc;
  int enable_angle_delta;
#if CONFIG_DENOISE
  float noise_level;
  int noise_block_size;
#endif

  unsigned int chroma_subsampling_x;
  unsigned int chroma_subsampling_y;
  int reduced_tx_type_set;
  int use_intra_dct_only;
  int use_inter_dct_only;
  int use_intra_default_tx_only;
  int quant_b_adapt;
  AV1_LEVEL target_seq_level_idx[MAX_NUM_OPERATING_POINTS];
  // Bit mask to specify which tier each of the 32 possible operating points
  // conforms to.
  unsigned int tier_mask;
  // min_cr / 100 is the target minimum compression ratio for each frame.
  unsigned int min_cr;
  COST_UPDATE_TYPE coeff_cost_upd_freq;
  COST_UPDATE_TYPE mode_cost_upd_freq;
  COST_UPDATE_TYPE mv_cost_upd_freq;
  unsigned int ext_tile_debug;
  unsigned int sb_multipass_unit_test;
};

static struct av1_extracfg default_extra_cfg = {
  0,              // cpu_used
  1,              // enable_auto_alt_ref
  0,              // enable_auto_bwd_ref
  0,              // noise_sensitivity
  0,              // sharpness
  0,              // static_thresh
  1,              // row_mt
  0,              // tile_columns
  0,              // tile_rows
  1,              // enable_tpl_model
  1,              // enable_keyframe_filtering
  7,              // arnr_max_frames
  5,              // arnr_strength
  0,              // min_gf_interval; 0 -> default decision
  0,              // max_gf_interval; 0 -> default decision
  0,              // gf_min_pyr_height
  5,              // gf_max_pyr_height
  AOM_TUNE_PSNR,  // tuning
  "/usr/local/share/model/vmaf_v0.6.1.pkl",  // VMAF model path
  10,                                        // cq_level
  0,                                         // rc_max_intra_bitrate_pct
  0,                                         // rc_max_inter_bitrate_pct
  0,                                         // gf_cbr_boost_pct
  0,                                         // lossless
  1,                                         // enable_cdef
  1,                                         // enable_restoration
  0,                                         // force_video_mode
  1,                                         // enable_obmc
  3,                                         // disable_trellis_quant
  0,                                         // enable_qm
  DEFAULT_QM_Y,                              // qm_y
  DEFAULT_QM_U,                              // qm_u
  DEFAULT_QM_V,                              // qm_v
  DEFAULT_QM_FIRST,                          // qm_min
  DEFAULT_QM_LAST,                           // qm_max
  1,                                         // max number of tile groups
  0,                                         // mtu_size
  AOM_TIMING_UNSPECIFIED,       // No picture timing signaling in bitstream
  0,                            // frame_parallel_decoding_mode
  1,                            // enable dual filter
  0,                            // enable delta quant in chroma planes
  NO_AQ,                        // aq_mode
  DELTA_Q_OBJECTIVE,            // deltaq_mode
  0,                            // delta lf mode
  0,                            // frame_periodic_delta_q
  AOM_BITS_8,                   // Bit depth
  AOM_CONTENT_DEFAULT,          // content
  AOM_CICP_CP_UNSPECIFIED,      // CICP color space
  AOM_CICP_TC_UNSPECIFIED,      // CICP transfer characteristics
  AOM_CICP_MC_UNSPECIFIED,      // CICP matrix coefficients
  AOM_CSP_UNKNOWN,              // chroma sample position
  0,                            // color range
  0,                            // render width
  0,                            // render height
  AOM_SUPERBLOCK_SIZE_DYNAMIC,  // superblock_size
  1,                            // this depends on large_scale_tile.
  0,                            // error_resilient_mode off by default.
  0,                            // s_frame_mode off by default.
  0,                            // film_grain_test_vector
  0,                            // film_grain_table_filename
  0,                            // motion_vector_unit_test
  1,                            // CDF update mode
  1,                            // enable rectangular partitions
  1,                            // enable ab shape partitions
  1,                            // enable 1:4 and 4:1 partitions
  4,                            // min_partition_size
  128,                          // max_partition_size
  1,                            // enable intra edge filter
  1,                            // frame order hint
  1,                            // enable 64-pt transform usage
  1,                            // enable flip and identity transform
  1,                            // dist-wtd compound
  7,                            // max_reference_frames
  0,                            // enable_reduced_reference_set
  1,                            // enable_ref_frame_mvs sequence level
  1,                            // allow ref_frame_mvs frame level
  1,                            // enable masked compound at sequence level
  1,                            // enable one sided compound at sequence level
  1,                            // enable interintra compound at sequence level
  1,                            // enable smooth interintra mode
  1,                            // enable difference-weighted compound
  1,                            // enable interinter wedge compound
  1,                            // enable interintra wedge compound
  1,                            // enable_global_motion usage
  1,                            // enable_warped_motion at sequence level
  1,                            // allow_warped_motion at frame level
  1,                            // enable filter intra at sequence level
  1,                            // enable smooth intra modes usage for sequence
  1,                            // enable Paeth intra mode usage for sequence
  1,                            // enable CFL uv intra mode usage for sequence
  1,                            // superres
  1,                            // enable overlay
  1,                            // enable palette
  !CONFIG_SHARP_SETTINGS,       // enable intrabc
  1,                            // enable angle delta
#if CONFIG_DENOISE
  0,   // noise_level
  32,  // noise_block_size
#endif
  0,  // chroma_subsampling_x
  0,  // chroma_subsampling_y
  0,  // reduced_tx_type_set
  0,  // use_intra_dct_only
  0,  // use_inter_dct_only
  0,  // use_intra_default_tx_only
  0,  // quant_b_adapt
  {
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
      SEQ_LEVEL_MAX, SEQ_LEVEL_MAX,
  },            // target_seq_level_idx
  0,            // tier_mask
  0,            // min_cr
  COST_UPD_SB,  // coeff_cost_upd_freq
  COST_UPD_SB,  // mode_cost_upd_freq
  COST_UPD_SB,  // mv_cost_upd_freq
  0,            // ext_tile_debug
  0,            // sb_multipass_unit_test
};

struct aom_codec_alg_priv {
  aom_codec_priv_t base;
  aom_codec_enc_cfg_t cfg;
  struct av1_extracfg extra_cfg;
  aom_rational64_t timestamp_ratio;
  aom_codec_pts_t pts_offset;
  unsigned char pts_offset_initialized;
  AV1EncoderConfig oxcf;
  AV1_COMP *cpi;
  unsigned char *cx_data;
  size_t cx_data_sz;
  unsigned char *pending_cx_data;
  size_t pending_cx_data_sz;
  int pending_frame_count;
  size_t pending_frame_sizes[8];
  aom_image_t preview_img;
  aom_enc_frame_flags_t next_frame_flags;
  aom_codec_pkt_list_decl(256) pkt_list;
  unsigned int fixed_kf_cntr;
  // BufferPool that holds all reference frames.
  BufferPool *buffer_pool;

  // lookahead instance variables
  BufferPool *buffer_pool_lap;
  AV1_COMP *cpi_lap;
  FIRSTPASS_STATS *frame_stats_buffer;
  // Number of stats buffers required for look ahead
  int num_lap_buffers;
  STATS_BUFFER_CTX stats_buf_context;
};

static INLINE int gcd(int64_t a, int b) {
  int remainder;  // remainder
  while (b > 0) {
    remainder = (int)(a % b);
    a = b;
    b = remainder;
  }

  return (int)a;
}

static INLINE void reduce_ratio(aom_rational64_t *ratio) {
  const int denom = gcd(ratio->num, ratio->den);
  ratio->num /= denom;
  ratio->den /= denom;
}

static aom_codec_err_t update_error_state(
    aom_codec_alg_priv_t *ctx, const struct aom_internal_error_info *error) {
  const aom_codec_err_t res = error->error_code;

  if (res != AOM_CODEC_OK)
    ctx->base.err_detail = error->has_detail ? error->detail : NULL;

  return res;
}

#undef ERROR
#define ERROR(str)                  \
  do {                              \
    ctx->base.err_detail = str;     \
    return AOM_CODEC_INVALID_PARAM; \
  } while (0)

#define RANGE_CHECK(p, memb, lo, hi)                   \
  do {                                                 \
    if (!((p)->memb >= (lo) && (p)->memb <= (hi)))     \
      ERROR(#memb " out of range [" #lo ".." #hi "]"); \
  } while (0)

#define RANGE_CHECK_HI(p, memb, hi)                                     \
  do {                                                                  \
    if (!((p)->memb <= (hi))) ERROR(#memb " out of range [.." #hi "]"); \
  } while (0)

#define RANGE_CHECK_BOOL(p, memb)                                     \
  do {                                                                \
    if (!!((p)->memb) != (p)->memb) ERROR(#memb " expected boolean"); \
  } while (0)

static aom_codec_err_t validate_config(aom_codec_alg_priv_t *ctx,
                                       const aom_codec_enc_cfg_t *cfg,
                                       const struct av1_extracfg *extra_cfg) {
  RANGE_CHECK(cfg, g_w, 1, 65535);  // 16 bits available
  RANGE_CHECK(cfg, g_h, 1, 65535);  // 16 bits available
  RANGE_CHECK(cfg, g_timebase.den, 1, 1000000000);
  RANGE_CHECK(cfg, g_timebase.num, 1, cfg->g_timebase.den);
  RANGE_CHECK_HI(cfg, g_profile, MAX_PROFILES - 1);

  RANGE_CHECK_HI(cfg, rc_max_quantizer, 63);
  RANGE_CHECK_HI(cfg, rc_min_quantizer, cfg->rc_max_quantizer);
  RANGE_CHECK_BOOL(extra_cfg, lossless);
  RANGE_CHECK_HI(extra_cfg, aq_mode, AQ_MODE_COUNT - 1);
  RANGE_CHECK_HI(extra_cfg, deltaq_mode, DELTA_Q_MODE_COUNT - 1);
  RANGE_CHECK_HI(extra_cfg, deltalf_mode, 1);
  RANGE_CHECK_HI(extra_cfg, frame_periodic_boost, 1);
  RANGE_CHECK_HI(cfg, g_usage, 1);
  RANGE_CHECK_HI(cfg, g_threads, MAX_NUM_THREADS);
  RANGE_CHECK(cfg, rc_end_usage, AOM_VBR, AOM_Q);
  RANGE_CHECK_HI(cfg, rc_undershoot_pct, 100);
  RANGE_CHECK_HI(cfg, rc_overshoot_pct, 100);
  RANGE_CHECK_HI(cfg, rc_2pass_vbr_bias_pct, 100);
  RANGE_CHECK(cfg, kf_mode, AOM_KF_DISABLED, AOM_KF_AUTO);
  RANGE_CHECK_HI(cfg, rc_dropframe_thresh, 100);
  RANGE_CHECK(cfg, g_pass, AOM_RC_ONE_PASS, AOM_RC_LAST_PASS);
  if (cfg->g_pass == AOM_RC_ONE_PASS) {
    RANGE_CHECK_HI(cfg, g_lag_in_frames, MAX_TOTAL_BUFFERS);
  } else {
    RANGE_CHECK_HI(cfg, g_lag_in_frames, MAX_LAG_BUFFERS);
  }
  RANGE_CHECK_HI(extra_cfg, min_gf_interval, MAX_LAG_BUFFERS - 1);
  RANGE_CHECK_HI(extra_cfg, max_gf_interval, MAX_LAG_BUFFERS - 1);
  if (extra_cfg->max_gf_interval > 0) {
    RANGE_CHECK(extra_cfg, max_gf_interval,
                AOMMAX(2, extra_cfg->min_gf_interval), (MAX_LAG_BUFFERS - 1));
  }
  RANGE_CHECK_HI(extra_cfg, gf_min_pyr_height, 5);
  RANGE_CHECK_HI(extra_cfg, gf_max_pyr_height, 5);
  if (extra_cfg->gf_min_pyr_height > extra_cfg->gf_max_pyr_height) {
    ERROR(
        "gf_min_pyr_height must be less than or equal to "
        "gf_max_pyramid_height");
  }

  RANGE_CHECK_HI(cfg, rc_resize_mode, RESIZE_MODES - 1);
  RANGE_CHECK(cfg, rc_resize_denominator, SCALE_NUMERATOR,
              SCALE_NUMERATOR << 1);
  RANGE_CHECK(cfg, rc_resize_kf_denominator, SCALE_NUMERATOR,
              SCALE_NUMERATOR << 1);
  RANGE_CHECK_HI(cfg, rc_superres_mode, SUPERRES_MODES - 1);
  RANGE_CHECK(cfg, rc_superres_denominator, SCALE_NUMERATOR,
              SCALE_NUMERATOR << 1);
  RANGE_CHECK(cfg, rc_superres_kf_denominator, SCALE_NUMERATOR,
              SCALE_NUMERATOR << 1);
  RANGE_CHECK(cfg, rc_superres_qthresh, 1, 63);
  RANGE_CHECK(cfg, rc_superres_kf_qthresh, 1, 63);
  RANGE_CHECK_HI(extra_cfg, cdf_update_mode, 2);

  // AV1 does not support a lower bound on the keyframe interval in
  // automatic keyframe placement mode.
  if (cfg->kf_mode != AOM_KF_DISABLED && cfg->kf_min_dist != cfg->kf_max_dist &&
      cfg->kf_min_dist > 0)
    ERROR(
        "kf_min_dist not supported in auto mode, use 0 "
        "or kf_max_dist instead.");

  RANGE_CHECK_HI(extra_cfg, motion_vector_unit_test, 2);
  RANGE_CHECK_HI(extra_cfg, sb_multipass_unit_test, 1);
  RANGE_CHECK_HI(extra_cfg, ext_tile_debug, 1);
  RANGE_CHECK_HI(extra_cfg, enable_auto_alt_ref, 1);
  RANGE_CHECK_HI(extra_cfg, enable_auto_bwd_ref, 2);
  RANGE_CHECK(extra_cfg, cpu_used, 0, 8);
  RANGE_CHECK_HI(extra_cfg, noise_sensitivity, 6);
  RANGE_CHECK(extra_cfg, superblock_size, AOM_SUPERBLOCK_SIZE_64X64,
              AOM_SUPERBLOCK_SIZE_DYNAMIC);
  RANGE_CHECK_HI(cfg, large_scale_tile, 1);
  RANGE_CHECK_HI(extra_cfg, single_tile_decoding, 1);

  RANGE_CHECK_HI(extra_cfg, row_mt, 1);

  RANGE_CHECK_HI(extra_cfg, tile_columns, 6);
  RANGE_CHECK_HI(extra_cfg, tile_rows, 6);

  RANGE_CHECK_HI(cfg, monochrome, 1);

  if (cfg->large_scale_tile && extra_cfg->aq_mode)
    ERROR(
        "Adaptive quantization are not supported in large scale tile "
        "coding.");

  RANGE_CHECK_HI(extra_cfg, sharpness, 7);
  RANGE_CHECK_HI(extra_cfg, arnr_max_frames, 15);
  RANGE_CHECK_HI(extra_cfg, arnr_strength, 6);
  RANGE_CHECK_HI(extra_cfg, cq_level, 63);
  RANGE_CHECK(cfg, g_bit_depth, AOM_BITS_8, AOM_BITS_12);
  RANGE_CHECK(cfg, g_input_bit_depth, 8, 12);
  RANGE_CHECK(extra_cfg, content, AOM_CONTENT_DEFAULT, AOM_CONTENT_INVALID - 1);

  if (cfg->g_pass == AOM_RC_LAST_PASS) {
    const size_t packet_sz = sizeof(FIRSTPASS_STATS);
    const int n_packets = (int)(cfg->rc_twopass_stats_in.sz / packet_sz);
    const FIRSTPASS_STATS *stats;

    if (cfg->rc_twopass_stats_in.buf == NULL)
      ERROR("rc_twopass_stats_in.buf not set.");

    if (cfg->rc_twopass_stats_in.sz % packet_sz)
      ERROR("rc_twopass_stats_in.sz indicates truncated packet.");

    if (cfg->rc_twopass_stats_in.sz < 2 * packet_sz)
      ERROR("rc_twopass_stats_in requires at least two packets.");

    stats =
        (const FIRSTPASS_STATS *)cfg->rc_twopass_stats_in.buf + n_packets - 1;

    if ((int)(stats->count + 0.5) != n_packets - 1)
      ERROR("rc_twopass_stats_in missing EOS stats packet");
  }

  if (cfg->g_profile <= (unsigned int)PROFILE_1 &&
      cfg->g_bit_depth > AOM_BITS_10) {
    ERROR("Codec bit-depth 12 not supported in profile < 2");
  }
  if (cfg->g_profile <= (unsigned int)PROFILE_1 &&
      cfg->g_input_bit_depth > 10) {
    ERROR("Source bit-depth 12 not supported in profile < 2");
  }

  if (cfg->rc_end_usage == AOM_Q) {
    RANGE_CHECK_HI(cfg, use_fixed_qp_offsets, 1);
    for (int i = 0; i < FIXED_QP_OFFSET_COUNT; ++i) {
      RANGE_CHECK_HI(cfg, fixed_qp_offsets[i], 63);
    }
  } else {
    if (cfg->use_fixed_qp_offsets > 0) {
      ERROR("--use_fixed_qp_offsets can only be used with --end-usage=q");
    }
    for (int i = 0; i < FIXED_QP_OFFSET_COUNT; ++i) {
      if (cfg->fixed_qp_offsets[i] >= 0) {
        ERROR("--fixed_qp_offsets can only be used with --end-usage=q");
      }
    }
  }

  RANGE_CHECK(extra_cfg, color_primaries, AOM_CICP_CP_BT_709,
              AOM_CICP_CP_EBU_3213);  // Need to check range more precisely to
                                      // check for reserved values?
  RANGE_CHECK(extra_cfg, transfer_characteristics, AOM_CICP_TC_BT_709,
              AOM_CICP_TC_HLG);
  RANGE_CHECK(extra_cfg, matrix_coefficients, AOM_CICP_MC_IDENTITY,
              AOM_CICP_MC_ICTCP);
  RANGE_CHECK(extra_cfg, color_range, 0, 1);

#if !CONFIG_TUNE_VMAF
  if (extra_cfg->tuning == AOM_TUNE_VMAF_WITH_PREPROCESSING ||
      extra_cfg->tuning == AOM_TUNE_VMAF_WITHOUT_PREPROCESSING ||
      extra_cfg->tuning == AOM_TUNE_VMAF_MAX_GAIN) {
    ERROR(
        "This error may be related to the wrong configuration options: try to "
        "set -DCONFIG_TUNE_VMAF=1 at the time CMake is run.");
  }
#endif

#if CONFIG_TUNE_VMAF
  RANGE_CHECK(extra_cfg, tuning, AOM_TUNE_PSNR, AOM_TUNE_VMAF_MAX_GAIN);
#else
  RANGE_CHECK(extra_cfg, tuning, AOM_TUNE_PSNR, AOM_TUNE_SSIM);
#endif

  RANGE_CHECK(extra_cfg, timing_info_type, AOM_TIMING_UNSPECIFIED,
              AOM_TIMING_DEC_MODEL);

  RANGE_CHECK(extra_cfg, film_grain_test_vector, 0, 16);

  if (extra_cfg->lossless) {
    if (extra_cfg->aq_mode != 0)
      ERROR("Only --aq_mode=0 can be used with --lossless=1.");
    if (extra_cfg->enable_chroma_deltaq)
      ERROR("Only --enable_chroma_deltaq=0 can be used with --lossless=1.");
  }

  if (cfg->rc_resize_mode != RESIZE_NONE &&
      extra_cfg->aq_mode == CYCLIC_REFRESH_AQ) {
    ERROR("--aq_mode=3 is only supported for --resize-mode=0.");
  }

  RANGE_CHECK(extra_cfg, max_reference_frames, 3, 7);
  RANGE_CHECK(extra_cfg, enable_reduced_reference_set, 0, 1);
  RANGE_CHECK_HI(extra_cfg, chroma_subsampling_x, 1);
  RANGE_CHECK_HI(extra_cfg, chroma_subsampling_y, 1);

  RANGE_CHECK_HI(extra_cfg, disable_trellis_quant, 3);
  RANGE_CHECK(extra_cfg, coeff_cost_upd_freq, 0, 2);
  RANGE_CHECK(extra_cfg, mode_cost_upd_freq, 0, 2);
  RANGE_CHECK(extra_cfg, mv_cost_upd_freq, 0, 3);

  RANGE_CHECK(extra_cfg, min_partition_size, 4, 128);
  RANGE_CHECK(extra_cfg, max_partition_size, 4, 128);
  RANGE_CHECK_HI(extra_cfg, min_partition_size, extra_cfg->max_partition_size);

  for (int i = 0; i < MAX_NUM_OPERATING_POINTS; ++i) {
    const int level_idx = extra_cfg->target_seq_level_idx[i];
    if (!is_valid_seq_level_idx(level_idx) && level_idx != SEQ_LEVELS) {
      ERROR("Target sequence level index is invalid");
    }
  }

  return AOM_CODEC_OK;
}

static aom_codec_err_t validate_img(aom_codec_alg_priv_t *ctx,
                                    const aom_image_t *img) {
  switch (img->fmt) {
    case AOM_IMG_FMT_YV12:
    case AOM_IMG_FMT_I420:
    case AOM_IMG_FMT_YV1216:
    case AOM_IMG_FMT_I42016: break;
    case AOM_IMG_FMT_I444:
    case AOM_IMG_FMT_I44416:
      if (ctx->cfg.g_profile == (unsigned int)PROFILE_0 &&
          !ctx->cfg.monochrome) {
        ERROR("Invalid image format. I444 images not supported in profile.");
      }
      break;
    case AOM_IMG_FMT_I422:
    case AOM_IMG_FMT_I42216:
      if (ctx->cfg.g_profile != (unsigned int)PROFILE_2) {
        ERROR("Invalid image format. I422 images not supported in profile.");
      }
      break;
    default:
      ERROR(
          "Invalid image format. Only YV12, I420, I422, I444 images are "
          "supported.");
      break;
  }

  if (img->d_w != ctx->cfg.g_w || img->d_h != ctx->cfg.g_h)
    ERROR("Image size must match encoder init configuration size");

  if (img->fmt != AOM_IMG_FMT_I420 && !ctx->extra_cfg.enable_tx64) {
    ERROR("TX64 can only be disabled on I420 images.");
  }

  return AOM_CODEC_OK;
}

static int get_image_bps(const aom_image_t *img) {
  switch (img->fmt) {
    case AOM_IMG_FMT_YV12:
    case AOM_IMG_FMT_I420: return 12;
    case AOM_IMG_FMT_I422: return 16;
    case AOM_IMG_FMT_I444: return 24;
    case AOM_IMG_FMT_YV1216:
    case AOM_IMG_FMT_I42016: return 24;
    case AOM_IMG_FMT_I42216: return 32;
    case AOM_IMG_FMT_I44416: return 48;
    default: assert(0 && "Invalid image format"); break;
  }
  return 0;
}

// Set appropriate options to disable frame super-resolution.
static void disable_superres(AV1EncoderConfig *const oxcf) {
  oxcf->superres_mode = SUPERRES_NONE;
  oxcf->superres_scale_denominator = SCALE_NUMERATOR;
  oxcf->superres_kf_scale_denominator = SCALE_NUMERATOR;
  oxcf->superres_qthresh = 255;
  oxcf->superres_kf_qthresh = 255;
}

static void update_default_encoder_config(const cfg_options_t *cfg,
                                          struct av1_extracfg *extra_cfg) {
  extra_cfg->enable_cdef = (cfg->disable_cdef == 0);
  extra_cfg->enable_restoration = (cfg->disable_lr == 0);
  extra_cfg->superblock_size = (cfg->super_block_size == 64)
                                   ? AOM_SUPERBLOCK_SIZE_64X64
                                   : (cfg->super_block_size == 128)
                                         ? AOM_SUPERBLOCK_SIZE_128X128
                                         : AOM_SUPERBLOCK_SIZE_DYNAMIC;
  extra_cfg->enable_warped_motion = (cfg->disable_warp_motion == 0);
  extra_cfg->enable_dist_wtd_comp = (cfg->disable_dist_wtd_comp == 0);
  extra_cfg->enable_diff_wtd_comp = (cfg->disable_diff_wtd_comp == 0);
  extra_cfg->enable_dual_filter = (cfg->disable_dual_filter == 0);
  extra_cfg->enable_angle_delta = (cfg->disable_intra_angle_delta == 0);
  extra_cfg->enable_rect_partitions = (cfg->disable_rect_partition_type == 0);
  extra_cfg->enable_ab_partitions = (cfg->disable_ab_partition_type == 0);
  extra_cfg->enable_1to4_partitions = (cfg->disable_1to4_partition_type == 0);
  extra_cfg->max_partition_size = cfg->max_partition_size;
  extra_cfg->min_partition_size = cfg->min_partition_size;
  extra_cfg->enable_intra_edge_filter = (cfg->disable_intra_edge_filter == 0);
  extra_cfg->enable_tx64 = (cfg->disable_tx_64x64 == 0);
  extra_cfg->enable_flip_idtx = (cfg->disable_flip_idtx == 0);
  extra_cfg->enable_masked_comp = (cfg->disable_masked_comp == 0);
  extra_cfg->enable_interintra_comp = (cfg->disable_inter_intra_comp == 0);
  extra_cfg->enable_smooth_interintra = (cfg->disable_smooth_inter_intra == 0);
  extra_cfg->enable_interinter_wedge = (cfg->disable_inter_inter_wedge == 0);
  extra_cfg->enable_interintra_wedge = (cfg->disable_inter_intra_wedge == 0);
  extra_cfg->enable_global_motion = (cfg->disable_global_motion == 0);
  extra_cfg->enable_filter_intra = (cfg->disable_filter_intra == 0);
  extra_cfg->enable_smooth_intra = (cfg->disable_smooth_intra == 0);
  extra_cfg->enable_paeth_intra = (cfg->disable_paeth_intra == 0);
  extra_cfg->enable_cfl_intra = (cfg->disable_cfl == 0);
  extra_cfg->enable_obmc = (cfg->disable_obmc == 0);
  extra_cfg->enable_palette = (cfg->disable_palette == 0);
  extra_cfg->enable_intrabc = (cfg->disable_intrabc == 0);
  extra_cfg->disable_trellis_quant = cfg->disable_trellis_quant;
  extra_cfg->allow_ref_frame_mvs = (cfg->disable_ref_frame_mv == 0);
  extra_cfg->enable_ref_frame_mvs = (cfg->disable_ref_frame_mv == 0);
  extra_cfg->enable_onesided_comp = (cfg->disable_one_sided_comp == 0);
  extra_cfg->enable_reduced_reference_set = cfg->reduced_reference_set;
  extra_cfg->reduced_tx_type_set = cfg->reduced_tx_type_set;
}

static double convert_qp_offset(int cq_level, int q_offset, int bit_depth) {
  const double base_q_val = av1_convert_qindex_to_q(cq_level, bit_depth);
  const int new_q_index_offset = av1_quantizer_to_qindex(q_offset);
  const int new_q_index = AOMMAX(cq_level - new_q_index_offset, 0);
  const double new_q_val = av1_convert_qindex_to_q(new_q_index, bit_depth);
  return (base_q_val - new_q_val);
}

static double get_modeled_qp_offset(int cq_level, int level, int bit_depth) {
  // 80% for keyframe was derived empirically.
  // 40% similar to rc_pick_q_and_bounds_one_pass_vbr() for Q mode ARF.
  // Rest derived similar to rc_pick_q_and_bounds_two_pass()
  static const int percents[FIXED_QP_OFFSET_COUNT] = { 76, 60, 30, 15, 8 };
  const double q_val = av1_convert_qindex_to_q(cq_level, bit_depth);
  return q_val * percents[level] / 100;
}

static aom_codec_err_t set_encoder_config(AV1EncoderConfig *oxcf,
                                          const aom_codec_enc_cfg_t *cfg,
                                          struct av1_extracfg *extra_cfg) {
  if (cfg->encoder_cfg.init_by_cfg_file) {
    update_default_encoder_config(&cfg->encoder_cfg, extra_cfg);
  }

  const int is_vbr = cfg->rc_end_usage == AOM_VBR;
  oxcf->profile = cfg->g_profile;
  oxcf->fwd_kf_enabled = cfg->fwd_kf_enabled;
  oxcf->max_threads = (int)cfg->g_threads;
  oxcf->mode = (cfg->g_usage == AOM_USAGE_REALTIME) ? REALTIME : GOOD;
  oxcf->width = cfg->g_w;
  oxcf->height = cfg->g_h;
  oxcf->forced_max_frame_width = cfg->g_forced_max_frame_width;
  oxcf->forced_max_frame_height = cfg->g_forced_max_frame_height;
  oxcf->bit_depth = cfg->g_bit_depth;
  oxcf->input_bit_depth = cfg->g_input_bit_depth;
  // guess a frame rate if out of whack, use 30
  oxcf->init_framerate = (double)cfg->g_timebase.den / cfg->g_timebase.num;
  if (extra_cfg->timing_info_type == AOM_TIMING_EQUAL ||
      extra_cfg->timing_info_type == AOM_TIMING_DEC_MODEL) {
    oxcf->timing_info_present = 1;
    oxcf->timing_info.num_units_in_display_tick = cfg->g_timebase.num;
    oxcf->timing_info.time_scale = cfg->g_timebase.den;
    oxcf->timing_info.num_ticks_per_picture = 1;
  } else {
    oxcf->timing_info_present = 0;
  }
  if (extra_cfg->timing_info_type == AOM_TIMING_EQUAL) {
    oxcf->timing_info.equal_picture_interval = 1;
    oxcf->decoder_model_info_present_flag = 0;
    oxcf->display_model_info_present_flag = 1;
  } else if (extra_cfg->timing_info_type == AOM_TIMING_DEC_MODEL) {
    //    if( extra_cfg->arnr_strength > 0 )
    //    {
    //      printf("Only --arnr-strength=0 can currently be used with
    //      --timing-info=model."); return AOM_CODEC_INVALID_PARAM;
    //    }
    //    if( extra_cfg->enable_superres)
    //    {
    //      printf("Only --superres-mode=0 can currently be used with
    //      --timing-info=model."); return AOM_CODEC_INVALID_PARAM;
    //    }
    oxcf->buffer_model.num_units_in_decoding_tick = cfg->g_timebase.num;
    oxcf->timing_info.equal_picture_interval = 0;
    oxcf->decoder_model_info_present_flag = 1;
    oxcf->buffer_removal_time_present = 1;
    oxcf->display_model_info_present_flag = 1;
  }
  if (oxcf->init_framerate > 180) {
    oxcf->init_framerate = 30;
    oxcf->timing_info_present = 0;
  }
  oxcf->encoder_cfg = &cfg->encoder_cfg;

  switch (cfg->g_pass) {
    case AOM_RC_ONE_PASS: oxcf->pass = 0; break;
    case AOM_RC_FIRST_PASS: oxcf->pass = 1; break;
    case AOM_RC_LAST_PASS: oxcf->pass = 2; break;
  }

  oxcf->lag_in_frames = clamp(cfg->g_lag_in_frames, 0, MAX_LAG_BUFFERS);
  oxcf->rc_mode = cfg->rc_end_usage;

  // Convert target bandwidth from Kbit/s to Bit/s
  oxcf->target_bandwidth = 1000 * cfg->rc_target_bitrate;
  oxcf->rc_max_intra_bitrate_pct = extra_cfg->rc_max_intra_bitrate_pct;
  oxcf->rc_max_inter_bitrate_pct = extra_cfg->rc_max_inter_bitrate_pct;
  oxcf->gf_cbr_boost_pct = extra_cfg->gf_cbr_boost_pct;

  oxcf->best_allowed_q =
      extra_cfg->lossless ? 0 : av1_quantizer_to_qindex(cfg->rc_min_quantizer);
  oxcf->worst_allowed_q =
      extra_cfg->lossless ? 0 : av1_quantizer_to_qindex(cfg->rc_max_quantizer);
  oxcf->cq_level = av1_quantizer_to_qindex(extra_cfg->cq_level);
  oxcf->fixed_q = -1;

  oxcf->enable_cdef = extra_cfg->enable_cdef;
  oxcf->enable_restoration =
      (cfg->g_usage == AOM_USAGE_REALTIME) ? 0 : extra_cfg->enable_restoration;
  oxcf->force_video_mode = extra_cfg->force_video_mode;
  oxcf->enable_obmc = extra_cfg->enable_obmc;
  oxcf->enable_overlay = extra_cfg->enable_overlay;
  oxcf->enable_palette = extra_cfg->enable_palette;
  oxcf->enable_intrabc = extra_cfg->enable_intrabc;
  oxcf->enable_angle_delta = extra_cfg->enable_angle_delta;
  oxcf->disable_trellis_quant = extra_cfg->disable_trellis_quant;
  oxcf->allow_ref_frame_mvs = extra_cfg->enable_ref_frame_mvs;
  oxcf->using_qm = extra_cfg->enable_qm;
  oxcf->qm_y = extra_cfg->qm_y;
  oxcf->qm_u = extra_cfg->qm_u;
  oxcf->qm_v = extra_cfg->qm_v;
  oxcf->qm_minlevel = extra_cfg->qm_min;
  oxcf->qm_maxlevel = extra_cfg->qm_max;
  oxcf->reduced_tx_type_set = extra_cfg->reduced_tx_type_set;
  oxcf->use_intra_dct_only = extra_cfg->use_intra_dct_only;
  oxcf->use_inter_dct_only = extra_cfg->use_inter_dct_only;
  oxcf->use_intra_default_tx_only = extra_cfg->use_intra_default_tx_only;
  oxcf->quant_b_adapt = extra_cfg->quant_b_adapt;
  oxcf->coeff_cost_upd_freq = (COST_UPDATE_TYPE)extra_cfg->coeff_cost_upd_freq;
  oxcf->mode_cost_upd_freq = (COST_UPDATE_TYPE)extra_cfg->mode_cost_upd_freq;
  oxcf->mv_cost_upd_freq = (COST_UPDATE_TYPE)extra_cfg->mv_cost_upd_freq;
  oxcf->num_tile_groups = extra_cfg->num_tg;
  // In large-scale tile encoding mode, num_tile_groups is always 1.
  if (cfg->large_scale_tile) oxcf->num_tile_groups = 1;
  oxcf->mtu = extra_cfg->mtu_size;

  // FIXME(debargha): Should this be:
  // oxcf->allow_ref_frame_mvs = extra_cfg->allow_ref_frame_mvs &
  //                             extra_cfg->enable_order_hint ?
  // Disallow using temporal MVs while large_scale_tile = 1.
  oxcf->allow_ref_frame_mvs =
      extra_cfg->allow_ref_frame_mvs && !cfg->large_scale_tile;
  oxcf->under_shoot_pct = cfg->rc_undershoot_pct;
  oxcf->over_shoot_pct = cfg->rc_overshoot_pct;

  oxcf->resize_mode = (RESIZE_MODE)cfg->rc_resize_mode;
  oxcf->resize_scale_denominator = (uint8_t)cfg->rc_resize_denominator;
  oxcf->resize_kf_scale_denominator = (uint8_t)cfg->rc_resize_kf_denominator;
  if (oxcf->resize_mode == RESIZE_FIXED &&
      oxcf->resize_scale_denominator == SCALE_NUMERATOR &&
      oxcf->resize_kf_scale_denominator == SCALE_NUMERATOR)
    oxcf->resize_mode = RESIZE_NONE;

  if (extra_cfg->lossless || cfg->large_scale_tile) {
    disable_superres(oxcf);
  } else {
    oxcf->superres_mode = (SUPERRES_MODE)cfg->rc_superres_mode;
    oxcf->superres_scale_denominator = (uint8_t)cfg->rc_superres_denominator;
    oxcf->superres_kf_scale_denominator =
        (uint8_t)cfg->rc_superres_kf_denominator;
    oxcf->superres_qthresh = av1_quantizer_to_qindex(cfg->rc_superres_qthresh);
    oxcf->superres_kf_qthresh =
        av1_quantizer_to_qindex(cfg->rc_superres_kf_qthresh);
    if (oxcf->superres_mode == SUPERRES_FIXED &&
        oxcf->superres_scale_denominator == SCALE_NUMERATOR &&
        oxcf->superres_kf_scale_denominator == SCALE_NUMERATOR) {
      disable_superres(oxcf);
    }
    if (oxcf->superres_mode == SUPERRES_QTHRESH &&
        oxcf->superres_qthresh == 255 && oxcf->superres_kf_qthresh == 255) {
      disable_superres(oxcf);
    }
  }

  oxcf->maximum_buffer_size_ms = is_vbr ? 240000 : cfg->rc_buf_sz;
  oxcf->starting_buffer_level_ms = is_vbr ? 60000 : cfg->rc_buf_initial_sz;
  oxcf->optimal_buffer_level_ms = is_vbr ? 60000 : cfg->rc_buf_optimal_sz;

  oxcf->drop_frames_water_mark = cfg->rc_dropframe_thresh;

  oxcf->two_pass_vbrbias = cfg->rc_2pass_vbr_bias_pct;
  oxcf->two_pass_vbrmin_section = cfg->rc_2pass_vbr_minsection_pct;
  oxcf->two_pass_vbrmax_section = cfg->rc_2pass_vbr_maxsection_pct;

  oxcf->auto_key =
      cfg->kf_mode == AOM_KF_AUTO && cfg->kf_min_dist != cfg->kf_max_dist;

  oxcf->key_freq = cfg->kf_max_dist;
  oxcf->sframe_dist = cfg->sframe_dist;
  oxcf->sframe_mode = cfg->sframe_mode;
  oxcf->sframe_enabled = cfg->sframe_dist != 0;
  oxcf->speed = extra_cfg->cpu_used;
  oxcf->enable_auto_arf = extra_cfg->enable_auto_alt_ref;
  oxcf->enable_auto_brf = extra_cfg->enable_auto_bwd_ref;
  oxcf->noise_sensitivity = extra_cfg->noise_sensitivity;
  oxcf->sharpness = extra_cfg->sharpness;

  oxcf->two_pass_stats_in = cfg->rc_twopass_stats_in;

  oxcf->color_primaries = extra_cfg->color_primaries;
  oxcf->transfer_characteristics = extra_cfg->transfer_characteristics;
  oxcf->matrix_coefficients = extra_cfg->matrix_coefficients;
  oxcf->chroma_sample_position = extra_cfg->chroma_sample_position;

  oxcf->color_range = extra_cfg->color_range;
  oxcf->render_width = extra_cfg->render_width;
  oxcf->render_height = extra_cfg->render_height;
  oxcf->arnr_max_frames = extra_cfg->arnr_max_frames;
  oxcf->arnr_strength = extra_cfg->arnr_strength;
  oxcf->min_gf_interval = extra_cfg->min_gf_interval;
  oxcf->max_gf_interval = extra_cfg->max_gf_interval;
  oxcf->gf_min_pyr_height = extra_cfg->gf_min_pyr_height;
  oxcf->gf_max_pyr_height = extra_cfg->gf_max_pyr_height;

  oxcf->tuning = extra_cfg->tuning;
  oxcf->vmaf_model_path = extra_cfg->vmaf_model_path;
  oxcf->content = extra_cfg->content;
  oxcf->cdf_update_mode = (uint8_t)extra_cfg->cdf_update_mode;
  oxcf->superblock_size = extra_cfg->superblock_size;
  if (cfg->large_scale_tile) {
    oxcf->film_grain_test_vector = 0;
    oxcf->film_grain_table_filename = NULL;
  } else {
    oxcf->film_grain_test_vector = extra_cfg->film_grain_test_vector;
    oxcf->film_grain_table_filename = extra_cfg->film_grain_table_filename;
  }
#if CONFIG_DENOISE
  oxcf->noise_level = extra_cfg->noise_level;
  oxcf->noise_block_size = extra_cfg->noise_block_size;
#endif
  oxcf->large_scale_tile = cfg->large_scale_tile;
  oxcf->single_tile_decoding =
      (oxcf->large_scale_tile) ? extra_cfg->single_tile_decoding : 0;
  if (oxcf->large_scale_tile) {
    // The superblock_size can only be AOM_SUPERBLOCK_SIZE_64X64 or
    // AOM_SUPERBLOCK_SIZE_128X128 while oxcf->large_scale_tile = 1. If
    // superblock_size = AOM_SUPERBLOCK_SIZE_DYNAMIC, hard set it to
    // AOM_SUPERBLOCK_SIZE_64X64(default value in large_scale_tile).
    if (extra_cfg->superblock_size != AOM_SUPERBLOCK_SIZE_64X64 &&
        extra_cfg->superblock_size != AOM_SUPERBLOCK_SIZE_128X128)
      oxcf->superblock_size = AOM_SUPERBLOCK_SIZE_64X64;
  }

  oxcf->row_mt = extra_cfg->row_mt;

  oxcf->tile_columns = extra_cfg->tile_columns;
  oxcf->tile_rows = extra_cfg->tile_rows;

  oxcf->monochrome = cfg->monochrome;
  oxcf->full_still_picture_hdr = cfg->full_still_picture_hdr;
  oxcf->enable_dual_filter = extra_cfg->enable_dual_filter;
  oxcf->enable_rect_partitions = extra_cfg->enable_rect_partitions;
  oxcf->enable_ab_partitions = extra_cfg->enable_ab_partitions;
  oxcf->enable_1to4_partitions = extra_cfg->enable_1to4_partitions;
  oxcf->min_partition_size = extra_cfg->min_partition_size;
  oxcf->max_partition_size = extra_cfg->max_partition_size;
  oxcf->enable_intra_edge_filter = extra_cfg->enable_intra_edge_filter;
  oxcf->enable_tx64 = extra_cfg->enable_tx64;
  oxcf->enable_flip_idtx = extra_cfg->enable_flip_idtx;
  oxcf->enable_order_hint = extra_cfg->enable_order_hint;
  oxcf->enable_dist_wtd_comp =
      extra_cfg->enable_dist_wtd_comp & extra_cfg->enable_order_hint;
  oxcf->max_reference_frames = extra_cfg->max_reference_frames;
  oxcf->enable_reduced_reference_set = extra_cfg->enable_reduced_reference_set;
  oxcf->enable_masked_comp = extra_cfg->enable_masked_comp;
  oxcf->enable_onesided_comp = extra_cfg->enable_onesided_comp;
  oxcf->enable_diff_wtd_comp =
      extra_cfg->enable_masked_comp & extra_cfg->enable_diff_wtd_comp;
  oxcf->enable_interinter_wedge =
      extra_cfg->enable_masked_comp & extra_cfg->enable_interinter_wedge;
  oxcf->enable_interintra_comp = extra_cfg->enable_interintra_comp;
  oxcf->enable_smooth_interintra =
      extra_cfg->enable_interintra_comp && extra_cfg->enable_smooth_interintra;
  oxcf->enable_interintra_wedge =
      extra_cfg->enable_interintra_comp & extra_cfg->enable_interintra_wedge;
  oxcf->enable_ref_frame_mvs =
      extra_cfg->enable_ref_frame_mvs & extra_cfg->enable_order_hint;

  oxcf->enable_global_motion = extra_cfg->enable_global_motion;
  oxcf->enable_warped_motion = extra_cfg->enable_warped_motion;
  oxcf->allow_warped_motion =
      (cfg->g_usage == AOM_USAGE_REALTIME)
          ? 0
          : (extra_cfg->allow_warped_motion & extra_cfg->enable_warped_motion);
  oxcf->enable_filter_intra = extra_cfg->enable_filter_intra;
  oxcf->enable_smooth_intra = extra_cfg->enable_smooth_intra;
  oxcf->enable_paeth_intra = extra_cfg->enable_paeth_intra;
  oxcf->enable_cfl_intra = extra_cfg->enable_cfl_intra;

  oxcf->enable_superres =
      (oxcf->superres_mode != SUPERRES_NONE) && extra_cfg->enable_superres;
  if (!oxcf->enable_superres) {
    disable_superres(oxcf);
  }

  oxcf->tile_width_count = AOMMIN(cfg->tile_width_count, MAX_TILE_COLS);
  oxcf->tile_height_count = AOMMIN(cfg->tile_height_count, MAX_TILE_ROWS);
  for (int i = 0; i < oxcf->tile_width_count; i++) {
    oxcf->tile_widths[i] = AOMMAX(cfg->tile_widths[i], 1);
  }
  for (int i = 0; i < oxcf->tile_height_count; i++) {
    oxcf->tile_heights[i] = AOMMAX(cfg->tile_heights[i], 1);
  }
  oxcf->error_resilient_mode =
      cfg->g_error_resilient | extra_cfg->error_resilient_mode;
  oxcf->s_frame_mode = extra_cfg->s_frame_mode;
  oxcf->frame_parallel_decoding_mode = extra_cfg->frame_parallel_decoding_mode;
  if (cfg->g_pass == AOM_RC_LAST_PASS) {
    const size_t packet_sz = sizeof(FIRSTPASS_STATS);
    const int n_packets = (int)(cfg->rc_twopass_stats_in.sz / packet_sz);
    oxcf->limit = n_packets - 1;
  } else {
    oxcf->limit = cfg->g_limit;
  }

  if (oxcf->limit == 1) {
    // still picture mode, display model and timing is meaningless
    oxcf->display_model_info_present_flag = 0;
    oxcf->timing_info_present = 0;
  }

  oxcf->enable_tpl_model = extra_cfg->enable_tpl_model;
  oxcf->enable_keyframe_filtering = extra_cfg->enable_keyframe_filtering;

  oxcf->enable_chroma_deltaq = extra_cfg->enable_chroma_deltaq;
  oxcf->aq_mode = extra_cfg->aq_mode;
  oxcf->deltaq_mode = extra_cfg->deltaq_mode;

  oxcf->deltalf_mode =
      (oxcf->deltaq_mode != NO_DELTA_Q) && extra_cfg->deltalf_mode;

  oxcf->save_as_annexb = cfg->save_as_annexb;

  oxcf->frame_periodic_boost = extra_cfg->frame_periodic_boost;
  oxcf->motion_vector_unit_test = extra_cfg->motion_vector_unit_test;
  oxcf->sb_multipass_unit_test = extra_cfg->sb_multipass_unit_test;
  oxcf->ext_tile_debug = extra_cfg->ext_tile_debug;

  oxcf->chroma_subsampling_x = extra_cfg->chroma_subsampling_x;
  oxcf->chroma_subsampling_y = extra_cfg->chroma_subsampling_y;
  oxcf->border_in_pixels = (oxcf->resize_mode || oxcf->superres_mode)
                               ? AOM_BORDER_IN_PIXELS
                               : AOM_ENC_NO_SCALE_BORDER;
  memcpy(oxcf->target_seq_level_idx, extra_cfg->target_seq_level_idx,
         sizeof(oxcf->target_seq_level_idx));
  oxcf->tier_mask = extra_cfg->tier_mask;

  oxcf->use_fixed_qp_offsets =
      cfg->use_fixed_qp_offsets && (oxcf->rc_mode == AOM_Q);
  for (int i = 0; i < FIXED_QP_OFFSET_COUNT; ++i) {
    if (oxcf->use_fixed_qp_offsets) {
      if (cfg->fixed_qp_offsets[i] >= 0) {  // user-provided qp offset
        oxcf->fixed_qp_offsets[i] = convert_qp_offset(
            oxcf->cq_level, cfg->fixed_qp_offsets[i], oxcf->bit_depth);
      } else {  // auto-selected qp offset
        oxcf->fixed_qp_offsets[i] =
            get_modeled_qp_offset(oxcf->cq_level, i, oxcf->bit_depth);
      }
    } else {
      oxcf->fixed_qp_offsets[i] = -1.0;
    }
  }

  oxcf->min_cr = extra_cfg->min_cr;
  return AOM_CODEC_OK;
}

static aom_codec_err_t encoder_set_config(aom_codec_alg_priv_t *ctx,
                                          const aom_codec_enc_cfg_t *cfg) {
  aom_codec_err_t res;
  int force_key = 0;

  if (cfg->g_w != ctx->cfg.g_w || cfg->g_h != ctx->cfg.g_h) {
    if (cfg->g_lag_in_frames > 1 || cfg->g_pass != AOM_RC_ONE_PASS)
      ERROR("Cannot change width or height after initialization");
    if (!valid_ref_frame_size(ctx->cfg.g_w, ctx->cfg.g_h, cfg->g_w, cfg->g_h) ||
        (ctx->cpi->initial_width && (int)cfg->g_w > ctx->cpi->initial_width) ||
        (ctx->cpi->initial_height && (int)cfg->g_h > ctx->cpi->initial_height))
      force_key = 1;
  }

  // Prevent increasing lag_in_frames. This check is stricter than it needs
  // to be -- the limit is not increasing past the first lag_in_frames
  // value, but we don't track the initial config, only the last successful
  // config.
  if (cfg->g_lag_in_frames > ctx->cfg.g_lag_in_frames)
    ERROR("Cannot increase lag_in_frames");
  // Prevent changing lag_in_frames if Lookahead Processing is enabled
  if (cfg->g_lag_in_frames != ctx->cfg.g_lag_in_frames &&
      ctx->num_lap_buffers > 0)
    ERROR("Cannot change lag_in_frames if LAP is enabled");

  res = validate_config(ctx, cfg, &ctx->extra_cfg);

  if (res == AOM_CODEC_OK) {
    ctx->cfg = *cfg;
    set_encoder_config(&ctx->oxcf, &ctx->cfg, &ctx->extra_cfg);
    // On profile change, request a key frame
    force_key |= ctx->cpi->common.seq_params.profile != ctx->oxcf.profile;
    av1_change_config(ctx->cpi, &ctx->oxcf);
  }

  if (force_key) ctx->next_frame_flags |= AOM_EFLAG_FORCE_KF;

  return res;
}

static aom_fixed_buf_t *encoder_get_global_headers(aom_codec_alg_priv_t *ctx) {
  return av1_get_global_headers(ctx->cpi);
}

static aom_codec_err_t ctrl_get_quantizer(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  int *const arg = va_arg(args, int *);
  if (arg == NULL) return AOM_CODEC_INVALID_PARAM;
  *arg = av1_get_quantizer(ctx->cpi);
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_get_quantizer64(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  int *const arg = va_arg(args, int *);
  if (arg == NULL) return AOM_CODEC_INVALID_PARAM;
  *arg = av1_qindex_to_quantizer(av1_get_quantizer(ctx->cpi));
  return AOM_CODEC_OK;
}

static aom_codec_err_t update_extra_cfg(aom_codec_alg_priv_t *ctx,
                                        struct av1_extracfg *extra_cfg) {
  const aom_codec_err_t res = validate_config(ctx, &ctx->cfg, extra_cfg);
  if (res == AOM_CODEC_OK) {
    ctx->extra_cfg = *extra_cfg;
    set_encoder_config(&ctx->oxcf, &ctx->cfg, &ctx->extra_cfg);
    av1_change_config(ctx->cpi, &ctx->oxcf);
  }
  return res;
}

static aom_codec_err_t ctrl_set_cpuused(aom_codec_alg_priv_t *ctx,
                                        va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.cpu_used = CAST(AOME_SET_CPUUSED, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_auto_alt_ref(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_auto_alt_ref = CAST(AOME_SET_ENABLEAUTOALTREF, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_auto_bwd_ref(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_auto_bwd_ref = CAST(AOME_SET_ENABLEAUTOBWDREF, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_noise_sensitivity(aom_codec_alg_priv_t *ctx,
                                                  va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.noise_sensitivity = CAST(AV1E_SET_NOISE_SENSITIVITY, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_sharpness(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.sharpness = CAST(AOME_SET_SHARPNESS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_static_thresh(aom_codec_alg_priv_t *ctx,
                                              va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.static_thresh = CAST(AOME_SET_STATIC_THRESHOLD, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_row_mt(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.row_mt = CAST(AV1E_SET_ROW_MT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_tile_columns(aom_codec_alg_priv_t *ctx,
                                             va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.tile_columns = CAST(AV1E_SET_TILE_COLUMNS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_tile_rows(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.tile_rows = CAST(AV1E_SET_TILE_ROWS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_tpl_model(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_tpl_model = CAST(AV1E_SET_ENABLE_TPL_MODEL, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_keyframe_filtering(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_keyframe_filtering =
      CAST(AV1E_SET_ENABLE_KEYFRAME_FILTERING, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_arnr_max_frames(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.arnr_max_frames = CAST(AOME_SET_ARNR_MAXFRAMES, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_arnr_strength(aom_codec_alg_priv_t *ctx,
                                              va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.arnr_strength = CAST(AOME_SET_ARNR_STRENGTH, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_tuning(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.tuning = CAST(AOME_SET_TUNING, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_cq_level(aom_codec_alg_priv_t *ctx,
                                         va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.cq_level = CAST(AOME_SET_CQ_LEVEL, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_rc_max_intra_bitrate_pct(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.rc_max_intra_bitrate_pct =
      CAST(AOME_SET_MAX_INTRA_BITRATE_PCT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_rc_max_inter_bitrate_pct(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.rc_max_inter_bitrate_pct =
      CAST(AOME_SET_MAX_INTER_BITRATE_PCT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_rc_gf_cbr_boost_pct(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.gf_cbr_boost_pct = CAST(AV1E_SET_GF_CBR_BOOST_PCT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_lossless(aom_codec_alg_priv_t *ctx,
                                         va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.lossless = CAST(AV1E_SET_LOSSLESS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_cdef(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_cdef = CAST(AV1E_SET_ENABLE_CDEF, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_restoration(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_restoration = CAST(AV1E_SET_ENABLE_RESTORATION, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_force_video_mode(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.force_video_mode = CAST(AV1E_SET_FORCE_VIDEO_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_obmc(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_obmc = CAST(AV1E_SET_ENABLE_OBMC, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_disable_trellis_quant(aom_codec_alg_priv_t *ctx,
                                                      va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.disable_trellis_quant = CAST(AV1E_SET_DISABLE_TRELLIS_QUANT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_qm(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_qm = CAST(AV1E_SET_ENABLE_QM, args);
  return update_extra_cfg(ctx, &extra_cfg);
}
static aom_codec_err_t ctrl_set_qm_y(aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.qm_y = CAST(AV1E_SET_QM_Y, args);
  return update_extra_cfg(ctx, &extra_cfg);
}
static aom_codec_err_t ctrl_set_qm_u(aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.qm_u = CAST(AV1E_SET_QM_U, args);
  return update_extra_cfg(ctx, &extra_cfg);
}
static aom_codec_err_t ctrl_set_qm_v(aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.qm_v = CAST(AV1E_SET_QM_V, args);
  return update_extra_cfg(ctx, &extra_cfg);
}
static aom_codec_err_t ctrl_set_qm_min(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.qm_min = CAST(AV1E_SET_QM_MIN, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_qm_max(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.qm_max = CAST(AV1E_SET_QM_MAX, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_num_tg(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.num_tg = CAST(AV1E_SET_NUM_TG, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_mtu(aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.mtu_size = CAST(AV1E_SET_MTU, args);
  return update_extra_cfg(ctx, &extra_cfg);
}
static aom_codec_err_t ctrl_set_timing_info_type(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.timing_info_type = CAST(AV1E_SET_TIMING_INFO_TYPE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_dual_filter(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_dual_filter = CAST(AV1E_SET_ENABLE_DUAL_FILTER, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_chroma_deltaq(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_chroma_deltaq = CAST(AV1E_SET_ENABLE_CHROMA_DELTAQ, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_rect_partitions(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_rect_partitions =
      CAST(AV1E_SET_ENABLE_RECT_PARTITIONS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_ab_partitions(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_ab_partitions = CAST(AV1E_SET_ENABLE_AB_PARTITIONS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_1to4_partitions(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_1to4_partitions =
      CAST(AV1E_SET_ENABLE_1TO4_PARTITIONS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_min_partition_size(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.min_partition_size = CAST(AV1E_SET_MIN_PARTITION_SIZE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_max_partition_size(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.max_partition_size = CAST(AV1E_SET_MAX_PARTITION_SIZE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_intra_edge_filter(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_intra_edge_filter =
      CAST(AV1E_SET_ENABLE_INTRA_EDGE_FILTER, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_order_hint(aom_codec_alg_priv_t *ctx,
                                                  va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_order_hint = CAST(AV1E_SET_ENABLE_ORDER_HINT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_tx64(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_tx64 = CAST(AV1E_SET_ENABLE_TX64, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_flip_idtx(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_flip_idtx = CAST(AV1E_SET_ENABLE_FLIP_IDTX, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_dist_wtd_comp(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_dist_wtd_comp = CAST(AV1E_SET_ENABLE_DIST_WTD_COMP, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_max_reference_frames(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.max_reference_frames = CAST(AV1E_SET_MAX_REFERENCE_FRAMES, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_reduced_reference_set(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_reduced_reference_set =
      CAST(AV1E_SET_REDUCED_REFERENCE_SET, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_ref_frame_mvs(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_ref_frame_mvs = CAST(AV1E_SET_ENABLE_REF_FRAME_MVS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_allow_ref_frame_mvs(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.allow_ref_frame_mvs = CAST(AV1E_SET_ALLOW_REF_FRAME_MVS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_masked_comp(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_masked_comp = CAST(AV1E_SET_ENABLE_MASKED_COMP, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_onesided_comp(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_onesided_comp = CAST(AV1E_SET_ENABLE_ONESIDED_COMP, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_interintra_comp(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_interintra_comp =
      CAST(AV1E_SET_ENABLE_INTERINTRA_COMP, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_smooth_interintra(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_smooth_interintra =
      CAST(AV1E_SET_ENABLE_SMOOTH_INTERINTRA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_diff_wtd_comp(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_diff_wtd_comp = CAST(AV1E_SET_ENABLE_DIFF_WTD_COMP, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_interinter_wedge(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_interinter_wedge =
      CAST(AV1E_SET_ENABLE_INTERINTER_WEDGE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_interintra_wedge(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_interintra_wedge =
      CAST(AV1E_SET_ENABLE_INTERINTRA_WEDGE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_global_motion(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_global_motion = CAST(AV1E_SET_ENABLE_GLOBAL_MOTION, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_warped_motion(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_warped_motion = CAST(AV1E_SET_ENABLE_WARPED_MOTION, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_allow_warped_motion(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.allow_warped_motion = CAST(AV1E_SET_ALLOW_WARPED_MOTION, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_filter_intra(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_filter_intra = CAST(AV1E_SET_ENABLE_FILTER_INTRA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_smooth_intra(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_smooth_intra = CAST(AV1E_SET_ENABLE_SMOOTH_INTRA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_paeth_intra(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_paeth_intra = CAST(AV1E_SET_ENABLE_PAETH_INTRA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_cfl_intra(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_cfl_intra = CAST(AV1E_SET_ENABLE_CFL_INTRA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_superres(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_superres = CAST(AV1E_SET_ENABLE_SUPERRES, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_overlay(aom_codec_alg_priv_t *ctx,
                                               va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_overlay = CAST(AV1E_SET_ENABLE_OVERLAY, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_palette(aom_codec_alg_priv_t *ctx,
                                               va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_palette = CAST(AV1E_SET_ENABLE_PALETTE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_intrabc(aom_codec_alg_priv_t *ctx,
                                               va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_intrabc = CAST(AV1E_SET_ENABLE_INTRABC, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_enable_angle_delta(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.enable_angle_delta = CAST(AV1E_SET_ENABLE_ANGLE_DELTA, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_error_resilient_mode(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.error_resilient_mode = CAST(AV1E_SET_ERROR_RESILIENT_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_s_frame_mode(aom_codec_alg_priv_t *ctx,
                                             va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.s_frame_mode = CAST(AV1E_SET_S_FRAME_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_frame_parallel_decoding_mode(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.frame_parallel_decoding_mode =
      CAST(AV1E_SET_FRAME_PARALLEL_DECODING, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_single_tile_decoding(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.single_tile_decoding = CAST(AV1E_SET_SINGLE_TILE_DECODING, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_aq_mode(aom_codec_alg_priv_t *ctx,
                                        va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.aq_mode = CAST(AV1E_SET_AQ_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_reduced_tx_type_set(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.reduced_tx_type_set = CAST(AV1E_SET_REDUCED_TX_TYPE_SET, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_intra_dct_only(aom_codec_alg_priv_t *ctx,
                                               va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.use_intra_dct_only = CAST(AV1E_SET_INTRA_DCT_ONLY, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_inter_dct_only(aom_codec_alg_priv_t *ctx,
                                               va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.use_inter_dct_only = CAST(AV1E_SET_INTER_DCT_ONLY, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_intra_default_tx_only(aom_codec_alg_priv_t *ctx,
                                                      va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.use_intra_default_tx_only =
      CAST(AV1E_SET_INTRA_DEFAULT_TX_ONLY, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_quant_b_adapt(aom_codec_alg_priv_t *ctx,
                                              va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.quant_b_adapt = CAST(AV1E_SET_QUANT_B_ADAPT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_coeff_cost_upd_freq(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.coeff_cost_upd_freq = CAST(AV1E_SET_COEFF_COST_UPD_FREQ, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_mode_cost_upd_freq(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.mode_cost_upd_freq = CAST(AV1E_SET_MODE_COST_UPD_FREQ, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_mv_cost_upd_freq(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.mv_cost_upd_freq = CAST(AV1E_SET_MV_COST_UPD_FREQ, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_vmaf_model_path(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.vmaf_model_path = CAST(AV1E_SET_VMAF_MODEL_PATH, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_film_grain_test_vector(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.film_grain_test_vector =
      CAST(AV1E_SET_FILM_GRAIN_TEST_VECTOR, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_film_grain_table(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.film_grain_table_filename = CAST(AV1E_SET_FILM_GRAIN_TABLE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_denoise_noise_level(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
#if !CONFIG_DENOISE
  (void)ctx;
  (void)args;
  return AOM_CODEC_INCAPABLE;
#else
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.noise_level =
      ((float)CAST(AV1E_SET_DENOISE_NOISE_LEVEL, args)) / 10.0f;
  return update_extra_cfg(ctx, &extra_cfg);
#endif
}

static aom_codec_err_t ctrl_set_denoise_block_size(aom_codec_alg_priv_t *ctx,
                                                   va_list args) {
#if !CONFIG_DENOISE
  (void)ctx;
  (void)args;
  return AOM_CODEC_INCAPABLE;
#else
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.noise_block_size = CAST(AV1E_SET_DENOISE_BLOCK_SIZE, args);
  return update_extra_cfg(ctx, &extra_cfg);
#endif
}

static aom_codec_err_t ctrl_set_deltaq_mode(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.deltaq_mode = CAST(AV1E_SET_DELTAQ_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_deltalf_mode(aom_codec_alg_priv_t *ctx,
                                             va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.deltalf_mode = CAST(AV1E_SET_DELTALF_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_min_gf_interval(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.min_gf_interval = CAST(AV1E_SET_MIN_GF_INTERVAL, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_max_gf_interval(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.max_gf_interval = CAST(AV1E_SET_MAX_GF_INTERVAL, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_gf_min_pyr_height(aom_codec_alg_priv_t *ctx,
                                                  va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.gf_min_pyr_height = CAST(AV1E_SET_GF_MIN_PYRAMID_HEIGHT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_gf_max_pyr_height(aom_codec_alg_priv_t *ctx,
                                                  va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.gf_max_pyr_height = CAST(AV1E_SET_GF_MAX_PYRAMID_HEIGHT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_frame_periodic_boost(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.frame_periodic_boost = CAST(AV1E_SET_FRAME_PERIODIC_BOOST, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_enable_motion_vector_unit_test(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.motion_vector_unit_test =
      CAST(AV1E_ENABLE_MOTION_VECTOR_UNIT_TEST, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_enable_ext_tile_debug(aom_codec_alg_priv_t *ctx,
                                                  va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.ext_tile_debug = CAST(AV1E_ENABLE_EXT_TILE_DEBUG, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_target_seq_level_idx(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  const int val = CAST(AV1E_SET_TARGET_SEQ_LEVEL_IDX, args);
  const int level = val % 100;
  const int operating_point_idx = val / 100;
  if (operating_point_idx >= 0 &&
      operating_point_idx < MAX_NUM_OPERATING_POINTS) {
    extra_cfg.target_seq_level_idx[operating_point_idx] = (AV1_LEVEL)level;
  }
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_tier_mask(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.tier_mask = CAST(AV1E_SET_TIER_MASK, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_min_cr(aom_codec_alg_priv_t *ctx,
                                       va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.min_cr = CAST(AV1E_SET_MIN_CR, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_enable_sb_multipass_unit_test(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.sb_multipass_unit_test =
      CAST(AV1E_ENABLE_SB_MULTIPASS_UNIT_TEST, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

#if !CONFIG_REALTIME_ONLY
static aom_codec_err_t create_stats_buffer(FIRSTPASS_STATS **frame_stats_buffer,
                                           STATS_BUFFER_CTX *stats_buf_context,
                                           int num_lap_buffers) {
  aom_codec_err_t res = AOM_CODEC_OK;

  int size = get_stats_buf_size(num_lap_buffers, MAX_LAG_BUFFERS);
  *frame_stats_buffer =
      (FIRSTPASS_STATS *)aom_calloc(size, sizeof(FIRSTPASS_STATS));
  if (*frame_stats_buffer == NULL) return AOM_CODEC_MEM_ERROR;

  stats_buf_context->stats_in_start = *frame_stats_buffer;
  stats_buf_context->stats_in_end = stats_buf_context->stats_in_start;
  stats_buf_context->stats_in_buf_end =
      stats_buf_context->stats_in_start + size;

  stats_buf_context->total_left_stats = aom_calloc(1, sizeof(FIRSTPASS_STATS));
  if (stats_buf_context->total_left_stats == NULL) return AOM_CODEC_MEM_ERROR;
  av1_twopass_zero_stats(stats_buf_context->total_left_stats);
  stats_buf_context->total_stats = aom_calloc(1, sizeof(FIRSTPASS_STATS));
  if (stats_buf_context->total_stats == NULL) return AOM_CODEC_MEM_ERROR;
  av1_twopass_zero_stats(stats_buf_context->total_stats);
  return res;
}
#endif

static aom_codec_err_t create_context_and_bufferpool(
    AV1_COMP **p_cpi, BufferPool **p_buffer_pool, AV1EncoderConfig *oxcf,
    struct aom_codec_pkt_list *pkt_list_head, FIRSTPASS_STATS *frame_stats_buf,
    COMPRESSOR_STAGE stage, int num_lap_buffers, int lap_lag_in_frames,
    STATS_BUFFER_CTX *stats_buf_context) {
  aom_codec_err_t res = AOM_CODEC_OK;

  *p_buffer_pool = (BufferPool *)aom_calloc(1, sizeof(BufferPool));
  if (*p_buffer_pool == NULL) return AOM_CODEC_MEM_ERROR;

#if CONFIG_MULTITHREAD
  if (pthread_mutex_init(&((*p_buffer_pool)->pool_mutex), NULL)) {
    return AOM_CODEC_MEM_ERROR;
  }
#endif
  *p_cpi = av1_create_compressor(oxcf, *p_buffer_pool, frame_stats_buf, stage,
                                 num_lap_buffers, lap_lag_in_frames,
                                 stats_buf_context);
  if (*p_cpi == NULL)
    res = AOM_CODEC_MEM_ERROR;
  else
    (*p_cpi)->output_pkt_list = pkt_list_head;

  return res;
}

static aom_codec_err_t encoder_init(aom_codec_ctx_t *ctx) {
  aom_codec_err_t res = AOM_CODEC_OK;

  if (ctx->priv == NULL) {
    aom_codec_alg_priv_t *const priv = aom_calloc(1, sizeof(*priv));
    if (priv == NULL) return AOM_CODEC_MEM_ERROR;

    ctx->priv = (aom_codec_priv_t *)priv;
    ctx->priv->init_flags = ctx->init_flags;

    if (ctx->config.enc) {
      // Update the reference to the config structure to an internal copy.
      priv->cfg = *ctx->config.enc;
      ctx->config.enc = &priv->cfg;
    }

    priv->extra_cfg = default_extra_cfg;
    aom_once(av1_initialize_enc);

    res = validate_config(priv, &priv->cfg, &priv->extra_cfg);

    if (res == AOM_CODEC_OK) {
      int *num_lap_buffers = &priv->num_lap_buffers;
      int lap_lag_in_frames = 0;
      *num_lap_buffers = 0;
      priv->timestamp_ratio.den = priv->cfg.g_timebase.den;
      priv->timestamp_ratio.num =
          (int64_t)priv->cfg.g_timebase.num * TICKS_PER_SEC;
      reduce_ratio(&priv->timestamp_ratio);

      set_encoder_config(&priv->oxcf, &priv->cfg, &priv->extra_cfg);
      if (priv->oxcf.rc_mode == AOM_Q && priv->oxcf.pass == 0 &&
          priv->oxcf.mode == GOOD) {
        // Enable look ahead
        *num_lap_buffers = priv->cfg.g_lag_in_frames;
        *num_lap_buffers =
            clamp(*num_lap_buffers, 1,
                  AOMMIN(MAX_LAP_BUFFERS,
                         priv->oxcf.key_freq + SCENE_CUT_KEY_TEST_INTERVAL));
        if ((int)priv->cfg.g_lag_in_frames - (*num_lap_buffers) >=
            LAP_LAG_IN_FRAMES) {
          lap_lag_in_frames = LAP_LAG_IN_FRAMES;
        }
      }
      priv->oxcf.use_highbitdepth =
          (ctx->init_flags & AOM_CODEC_USE_HIGHBITDEPTH) ? 1 : 0;

#if !CONFIG_REALTIME_ONLY
      res = create_stats_buffer(&priv->frame_stats_buffer,
                                &priv->stats_buf_context, *num_lap_buffers);
      if (res != AOM_CODEC_OK) return AOM_CODEC_MEM_ERROR;
#endif

      res = create_context_and_bufferpool(
          &priv->cpi, &priv->buffer_pool, &priv->oxcf, &priv->pkt_list.head,
          priv->frame_stats_buffer, ENCODE_STAGE, *num_lap_buffers, -1,
          &priv->stats_buf_context);

      // Create another compressor if look ahead is enabled
      if (res == AOM_CODEC_OK && *num_lap_buffers) {
        res = create_context_and_bufferpool(
            &priv->cpi_lap, &priv->buffer_pool_lap, &priv->oxcf, NULL,
            priv->frame_stats_buffer, LAP_STAGE, *num_lap_buffers,
            clamp(lap_lag_in_frames, 0, MAX_LAG_BUFFERS),
            &priv->stats_buf_context);
      }
    }
  }

  return res;
}

static void destroy_context_and_bufferpool(AV1_COMP *cpi,
                                           BufferPool *buffer_pool) {
  av1_remove_compressor(cpi);
#if CONFIG_MULTITHREAD
  if (buffer_pool) pthread_mutex_destroy(&buffer_pool->pool_mutex);
#endif
  aom_free(buffer_pool);
}

static void destroy_stats_buffer(STATS_BUFFER_CTX *stats_buf_context,
                                 FIRSTPASS_STATS *frame_stats_buffer) {
  aom_free(stats_buf_context->total_left_stats);
  aom_free(stats_buf_context->total_stats);
  aom_free(frame_stats_buffer);
}

static aom_codec_err_t encoder_destroy(aom_codec_alg_priv_t *ctx) {
  free(ctx->cx_data);
  destroy_context_and_bufferpool(ctx->cpi, ctx->buffer_pool);
  if (ctx->cpi_lap) {
    // As both cpi and cpi_lap have the same lookahead_ctx, it is already freed
    // when destroy is called on cpi. Thus, setting lookahead_ctx to null here,
    // so that it doesn't attempt to free it again.
    ctx->cpi_lap->lookahead = NULL;
    destroy_context_and_bufferpool(ctx->cpi_lap, ctx->buffer_pool_lap);
  }
  destroy_stats_buffer(&ctx->stats_buf_context, ctx->frame_stats_buffer);
  aom_free(ctx);
  return AOM_CODEC_OK;
}

static aom_codec_frame_flags_t get_frame_pkt_flags(const AV1_COMP *cpi,
                                                   unsigned int lib_flags) {
  aom_codec_frame_flags_t flags = lib_flags << 16;

  if (lib_flags & FRAMEFLAGS_KEY) flags |= AOM_FRAME_IS_KEY;
  if (lib_flags & FRAMEFLAGS_INTRAONLY) flags |= AOM_FRAME_IS_INTRAONLY;
  if (lib_flags & FRAMEFLAGS_SWITCH) flags |= AOM_FRAME_IS_SWITCH;
  if (lib_flags & FRAMEFLAGS_ERROR_RESILIENT)
    flags |= AOM_FRAME_IS_ERROR_RESILIENT;
  if (cpi->droppable) flags |= AOM_FRAME_IS_DROPPABLE;

  return flags;
}

// TODO(Mufaddal): Check feasibility of abstracting functions related to LAP
// into a separate function.
static aom_codec_err_t encoder_encode(aom_codec_alg_priv_t *ctx,
                                      const aom_image_t *img,
                                      aom_codec_pts_t pts,
                                      unsigned long duration,
                                      aom_enc_frame_flags_t enc_flags) {
  const size_t kMinCompressedSize = 8192;
  volatile aom_codec_err_t res = AOM_CODEC_OK;
  AV1_COMP *const cpi = ctx->cpi;
  const aom_rational64_t *const timestamp_ratio = &ctx->timestamp_ratio;
  volatile aom_codec_pts_t ptsvol = pts;
  // LAP context
  AV1_COMP *cpi_lap = ctx->cpi_lap;

  if (cpi == NULL) return AOM_CODEC_INVALID_PARAM;

  if (cpi->lap_enabled && cpi_lap == NULL && cpi->oxcf.pass == 0)
    return AOM_CODEC_INVALID_PARAM;

  if (img != NULL) {
    res = validate_img(ctx, img);
    // TODO(jzern) the checks related to cpi's validity should be treated as a
    // failure condition, encoder setup is done fully in init() currently.
    if (res == AOM_CODEC_OK) {
      size_t data_sz = ALIGN_POWER_OF_TWO(ctx->cfg.g_w, 5) *
                       ALIGN_POWER_OF_TWO(ctx->cfg.g_h, 5) * get_image_bps(img);
      if (data_sz < kMinCompressedSize) data_sz = kMinCompressedSize;
      if (ctx->cx_data == NULL || ctx->cx_data_sz < data_sz) {
        ctx->cx_data_sz = data_sz;
        free(ctx->cx_data);
        ctx->cx_data = (unsigned char *)malloc(ctx->cx_data_sz);
        if (ctx->cx_data == NULL) {
          return AOM_CODEC_MEM_ERROR;
        }
      }
    }
  }
  if (ctx->oxcf.mode != GOOD && ctx->oxcf.mode != REALTIME) {
    ctx->oxcf.mode = GOOD;
    av1_change_config(ctx->cpi, &ctx->oxcf);
  }

  if (!ctx->pts_offset_initialized) {
    ctx->pts_offset = ptsvol;
    ctx->pts_offset_initialized = 1;
  }
  ptsvol -= ctx->pts_offset;

  aom_codec_pkt_list_init(&ctx->pkt_list);

  volatile aom_enc_frame_flags_t flags = enc_flags;

  // The jmp_buf is valid only for the duration of the function that calls
  // setjmp(). Therefore, this function must reset the 'setjmp' field to 0
  // before it returns.
  if (setjmp(cpi->common.error.jmp)) {
    cpi->common.error.setjmp = 0;
    res = update_error_state(ctx, &cpi->common.error);
    aom_clear_system_state();
    return res;
  }
  cpi->common.error.setjmp = 1;
  if (cpi_lap != NULL) {
    if (setjmp(cpi_lap->common.error.jmp)) {
      cpi_lap->common.error.setjmp = 0;
      res = update_error_state(ctx, &cpi_lap->common.error);
      aom_clear_system_state();
      return res;
    }
    cpi_lap->common.error.setjmp = 1;
  }

  // Note(yunqing): While applying encoding flags, always start from enabling
  // all, and then modifying according to the flags. Previous frame's flags are
  // overwritten.
  av1_apply_encoding_flags(cpi, flags);
  if (cpi_lap != NULL) {
    av1_apply_encoding_flags(cpi_lap, flags);
  }

  // Handle fixed keyframe intervals
  if (is_stat_generation_stage(cpi)) {
    if (ctx->cfg.kf_mode == AOM_KF_AUTO &&
        ctx->cfg.kf_min_dist == ctx->cfg.kf_max_dist) {
      if (cpi->common.spatial_layer_id == 0 &&
          ++ctx->fixed_kf_cntr > ctx->cfg.kf_min_dist) {
        flags |= AOM_EFLAG_FORCE_KF;
        ctx->fixed_kf_cntr = 1;
      }
    }
  }

  if (res == AOM_CODEC_OK) {
    int64_t dst_time_stamp = timebase_units_to_ticks(timestamp_ratio, ptsvol);
    int64_t dst_end_time_stamp =
        timebase_units_to_ticks(timestamp_ratio, ptsvol + duration);

    // Set up internal flags
    if (ctx->base.init_flags & AOM_CODEC_USE_PSNR) cpi->b_calculate_psnr = 1;

    if (img != NULL) {
      YV12_BUFFER_CONFIG sd;
      int use_highbitdepth, subsampling_x, subsampling_y;
      res = image2yuvconfig(img, &sd);
      use_highbitdepth = (sd.flags & YV12_FLAG_HIGHBITDEPTH) != 0;
      subsampling_x = sd.subsampling_x;
      subsampling_y = sd.subsampling_y;

      if (!cpi->lookahead) {
        int lag_in_frames = cpi_lap != NULL ? cpi_lap->oxcf.lag_in_frames
                                            : cpi->oxcf.lag_in_frames;

        cpi->lookahead = av1_lookahead_init(
            cpi->oxcf.width, cpi->oxcf.height, subsampling_x, subsampling_y,
            use_highbitdepth, lag_in_frames, cpi->oxcf.border_in_pixels,
            cpi->common.features.byte_alignment, ctx->num_lap_buffers);
      }
      if (!cpi->lookahead)
        aom_internal_error(&cpi->common.error, AOM_CODEC_MEM_ERROR,
                           "Failed to allocate lag buffers");

      av1_check_initial_width(cpi, use_highbitdepth, subsampling_x,
                              subsampling_y);
      if (cpi_lap != NULL) {
        cpi_lap->lookahead = cpi->lookahead;
        av1_check_initial_width(cpi_lap, use_highbitdepth, subsampling_x,
                                subsampling_y);
      }

      // Store the original flags in to the frame buffer. Will extract the
      // key frame flag when we actually encode this frame.
      if (av1_receive_raw_frame(cpi, flags | ctx->next_frame_flags, &sd,
                                dst_time_stamp, dst_end_time_stamp)) {
        res = update_error_state(ctx, &cpi->common.error);
      }
      ctx->next_frame_flags = 0;
    }

    unsigned char *cx_data = ctx->cx_data;
    size_t cx_data_sz = ctx->cx_data_sz;

    assert(!(cx_data == NULL && cx_data_sz != 0));

    /* Any pending invisible frames? */
    if (ctx->pending_cx_data) {
      memmove(cx_data, ctx->pending_cx_data, ctx->pending_cx_data_sz);
      ctx->pending_cx_data = cx_data;
      cx_data += ctx->pending_cx_data_sz;
      cx_data_sz -= ctx->pending_cx_data_sz;

      /* TODO: this is a minimal check, the underlying codec doesn't respect
       * the buffer size anyway.
       */
      if (cx_data_sz < ctx->cx_data_sz / 2) {
        aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR,
                           "Compressed data buffer too small");
      }
    }

    size_t frame_size = 0;
    unsigned int lib_flags = 0;
    int is_frame_visible = 0;
    int index_size = 0;
    int has_fwd_keyframe = 0;

    // Call for LAP stage
    if (cpi_lap != NULL) {
      int status;
      aom_rational64_t timestamp_ratio_la = *timestamp_ratio;
      int64_t dst_time_stamp_la = dst_time_stamp;
      int64_t dst_end_time_stamp_la = dst_end_time_stamp;
      status = av1_get_compressed_data(
          cpi_lap, &lib_flags, &frame_size, NULL, &dst_time_stamp_la,
          &dst_end_time_stamp_la, !img, &timestamp_ratio_la);
      if (status != -1) {
        if (status != AOM_CODEC_OK) {
          aom_internal_error(&cpi_lap->common.error, AOM_CODEC_ERROR, NULL);
        }
        cpi_lap->seq_params_locked = 1;
      }
      lib_flags = 0;
      frame_size = 0;
    }

    // invisible frames get packed with the next visible frame
    while (cx_data_sz - index_size >= ctx->cx_data_sz / 2 &&
           !is_frame_visible) {
      const int status = av1_get_compressed_data(
          cpi, &lib_flags, &frame_size, cx_data, &dst_time_stamp,
          &dst_end_time_stamp, !img, timestamp_ratio);
      if (status == -1) break;
      if (status != AOM_CODEC_OK) {
        aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR, NULL);
      }

      cpi->seq_params_locked = 1;
      if (frame_size) {
        if (ctx->pending_cx_data == 0) ctx->pending_cx_data = cx_data;

        const int write_temporal_delimiter =
            !cpi->common.spatial_layer_id && !ctx->pending_frame_count;

        if (write_temporal_delimiter) {
          uint32_t obu_header_size = 1;
          const uint32_t obu_payload_size = 0;
          const size_t length_field_size =
              aom_uleb_size_in_bytes(obu_payload_size);

          if (ctx->pending_cx_data) {
            const size_t move_offset = length_field_size + 1;
            memmove(ctx->pending_cx_data + move_offset, ctx->pending_cx_data,
                    frame_size);
          }
          const uint32_t obu_header_offset = 0;
          obu_header_size = av1_write_obu_header(
              &cpi->level_params, OBU_TEMPORAL_DELIMITER, 0,
              (uint8_t *)(ctx->pending_cx_data + obu_header_offset));

          // OBUs are preceded/succeeded by an unsigned leb128 coded integer.
          if (av1_write_uleb_obu_size(obu_header_size, obu_payload_size,
                                      ctx->pending_cx_data) != AOM_CODEC_OK) {
            aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR, NULL);
          }

          frame_size += obu_header_size + obu_payload_size + length_field_size;
        }

        if (ctx->oxcf.save_as_annexb) {
          size_t curr_frame_size = frame_size;
          if (av1_convert_sect5obus_to_annexb(cx_data, &curr_frame_size) !=
              AOM_CODEC_OK) {
            aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR, NULL);
          }
          frame_size = curr_frame_size;

          // B_PRIME (add frame size)
          const size_t length_field_size = aom_uleb_size_in_bytes(frame_size);
          if (ctx->pending_cx_data) {
            const size_t move_offset = length_field_size;
            memmove(cx_data + move_offset, cx_data, frame_size);
          }
          if (av1_write_uleb_obu_size(0, (uint32_t)frame_size, cx_data) !=
              AOM_CODEC_OK) {
            aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR, NULL);
          }
          frame_size += length_field_size;
        }

        ctx->pending_frame_sizes[ctx->pending_frame_count++] = frame_size;
        ctx->pending_cx_data_sz += frame_size;

        cx_data += frame_size;
        cx_data_sz -= frame_size;

        index_size = MAG_SIZE * (ctx->pending_frame_count - 1) + 2;

        is_frame_visible = cpi->common.show_frame;

        has_fwd_keyframe |= (!is_frame_visible &&
                             cpi->common.current_frame.frame_type == KEY_FRAME);
      }
    }
    if (is_frame_visible) {
      // Add the frame packet to the list of returned packets.
      aom_codec_cx_pkt_t pkt;

      if (ctx->oxcf.save_as_annexb) {
        //  B_PRIME (add TU size)
        size_t tu_size = ctx->pending_cx_data_sz;
        const size_t length_field_size = aom_uleb_size_in_bytes(tu_size);
        if (ctx->pending_cx_data) {
          const size_t move_offset = length_field_size;
          memmove(ctx->pending_cx_data + move_offset, ctx->pending_cx_data,
                  tu_size);
        }
        if (av1_write_uleb_obu_size(0, (uint32_t)tu_size,
                                    ctx->pending_cx_data) != AOM_CODEC_OK) {
          aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR, NULL);
        }
        ctx->pending_cx_data_sz += length_field_size;
      }

      pkt.kind = AOM_CODEC_CX_FRAME_PKT;

      pkt.data.frame.buf = ctx->pending_cx_data;
      pkt.data.frame.sz = ctx->pending_cx_data_sz;
      pkt.data.frame.partition_id = -1;
      pkt.data.frame.vis_frame_size = frame_size;

      pkt.data.frame.pts =
          ticks_to_timebase_units(timestamp_ratio, dst_time_stamp) +
          ctx->pts_offset;
      pkt.data.frame.flags = get_frame_pkt_flags(cpi, lib_flags);
      if (has_fwd_keyframe) {
        // If one of the invisible frames in the packet is a keyframe, set
        // the delayed random access point flag.
        pkt.data.frame.flags |= AOM_FRAME_IS_DELAYED_RANDOM_ACCESS_POINT;
      }
      pkt.data.frame.duration = (uint32_t)ticks_to_timebase_units(
          timestamp_ratio, dst_end_time_stamp - dst_time_stamp);

      aom_codec_pkt_list_add(&ctx->pkt_list.head, &pkt);

      ctx->pending_cx_data = NULL;
      ctx->pending_cx_data_sz = 0;
      ctx->pending_frame_count = 0;
    }
  }

  cpi->common.error.setjmp = 0;
  return res;
}

static const aom_codec_cx_pkt_t *encoder_get_cxdata(aom_codec_alg_priv_t *ctx,
                                                    aom_codec_iter_t *iter) {
  return aom_codec_pkt_list_get(&ctx->pkt_list.head, iter);
}

static aom_codec_err_t ctrl_set_reference(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  av1_ref_frame_t *const frame = va_arg(args, av1_ref_frame_t *);

  if (frame != NULL) {
    YV12_BUFFER_CONFIG sd;

    image2yuvconfig(&frame->img, &sd);
    av1_set_reference_enc(ctx->cpi, frame->idx, &sd);
    return AOM_CODEC_OK;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_copy_reference(aom_codec_alg_priv_t *ctx,
                                           va_list args) {
  av1_ref_frame_t *const frame = va_arg(args, av1_ref_frame_t *);

  if (frame != NULL) {
    YV12_BUFFER_CONFIG sd;

    image2yuvconfig(&frame->img, &sd);
    av1_copy_reference_enc(ctx->cpi, frame->idx, &sd);
    return AOM_CODEC_OK;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_get_reference(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  av1_ref_frame_t *const frame = va_arg(args, av1_ref_frame_t *);

  if (frame != NULL) {
    YV12_BUFFER_CONFIG *fb = get_ref_frame(&ctx->cpi->common, frame->idx);
    if (fb == NULL) return AOM_CODEC_ERROR;

    yuvconfig2image(&frame->img, fb, NULL);
    return AOM_CODEC_OK;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_get_new_frame_image(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  aom_image_t *const new_img = va_arg(args, aom_image_t *);

  if (new_img != NULL) {
    YV12_BUFFER_CONFIG new_frame;

    if (av1_get_last_show_frame(ctx->cpi, &new_frame) == 0) {
      yuvconfig2image(new_img, &new_frame, NULL);
      return AOM_CODEC_OK;
    } else {
      return AOM_CODEC_ERROR;
    }
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_copy_new_frame_image(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  aom_image_t *const new_img = va_arg(args, aom_image_t *);

  if (new_img != NULL) {
    YV12_BUFFER_CONFIG new_frame;

    if (av1_get_last_show_frame(ctx->cpi, &new_frame) == 0) {
      YV12_BUFFER_CONFIG sd;
      image2yuvconfig(new_img, &sd);
      return av1_copy_new_frame_enc(&ctx->cpi->common, &new_frame, &sd);
    } else {
      return AOM_CODEC_ERROR;
    }
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_image_t *encoder_get_preview(aom_codec_alg_priv_t *ctx) {
  YV12_BUFFER_CONFIG sd;

  if (av1_get_preview_raw_frame(ctx->cpi, &sd) == 0) {
    yuvconfig2image(&ctx->preview_img, &sd, NULL);
    return &ctx->preview_img;
  } else {
    return NULL;
  }
}

static aom_codec_err_t ctrl_use_reference(aom_codec_alg_priv_t *ctx,
                                          va_list args) {
  const int reference_flag = va_arg(args, int);

  av1_use_as_reference(&ctx->cpi->ext_flags.ref_frame_flags, reference_flag);
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_roi_map(aom_codec_alg_priv_t *ctx,
                                        va_list args) {
  (void)ctx;
  (void)args;

  // TODO(yaowu): Need to re-implement and test for AV1.
  return AOM_CODEC_INVALID_PARAM;
}

static aom_codec_err_t ctrl_set_active_map(aom_codec_alg_priv_t *ctx,
                                           va_list args) {
  aom_active_map_t *const map = va_arg(args, aom_active_map_t *);

  if (map) {
    if (!av1_set_active_map(ctx->cpi, map->active_map, (int)map->rows,
                            (int)map->cols))
      return AOM_CODEC_OK;
    else
      return AOM_CODEC_INVALID_PARAM;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_get_active_map(aom_codec_alg_priv_t *ctx,
                                           va_list args) {
  aom_active_map_t *const map = va_arg(args, aom_active_map_t *);

  if (map) {
    if (!av1_get_active_map(ctx->cpi, map->active_map, (int)map->rows,
                            (int)map->cols))
      return AOM_CODEC_OK;
    else
      return AOM_CODEC_INVALID_PARAM;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_set_scale_mode(aom_codec_alg_priv_t *ctx,
                                           va_list args) {
  aom_scaling_mode_t *const mode = va_arg(args, aom_scaling_mode_t *);

  if (mode) {
    const int res = av1_set_internal_size(
        &ctx->cpi->oxcf, &ctx->cpi->resize_pending_params,
        (AOM_SCALING)mode->h_scaling_mode, (AOM_SCALING)mode->v_scaling_mode);
    return (res == 0) ? AOM_CODEC_OK : AOM_CODEC_INVALID_PARAM;
  } else {
    return AOM_CODEC_INVALID_PARAM;
  }
}

static aom_codec_err_t ctrl_set_spatial_layer_id(aom_codec_alg_priv_t *ctx,
                                                 va_list args) {
  const int spatial_layer_id = va_arg(args, int);
  if (spatial_layer_id >= MAX_NUM_SPATIAL_LAYERS)
    return AOM_CODEC_INVALID_PARAM;
  ctx->cpi->common.spatial_layer_id = spatial_layer_id;
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_number_spatial_layers(aom_codec_alg_priv_t *ctx,
                                                      va_list args) {
  const int number_spatial_layers = va_arg(args, int);
  if (number_spatial_layers > MAX_NUM_SPATIAL_LAYERS)
    return AOM_CODEC_INVALID_PARAM;
  ctx->cpi->common.number_spatial_layers = number_spatial_layers;
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_layer_id(aom_codec_alg_priv_t *ctx,
                                         va_list args) {
  aom_svc_layer_id_t *const data = va_arg(args, aom_svc_layer_id_t *);
  ctx->cpi->common.spatial_layer_id = data->spatial_layer_id;
  ctx->cpi->common.temporal_layer_id = data->temporal_layer_id;
  ctx->cpi->svc.spatial_layer_id = data->spatial_layer_id;
  ctx->cpi->svc.temporal_layer_id = data->temporal_layer_id;
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_svc_params(aom_codec_alg_priv_t *ctx,
                                           va_list args) {
  AV1_COMP *const cpi = ctx->cpi;
  aom_svc_params_t *const params = va_arg(args, aom_svc_params_t *);
  cpi->common.number_spatial_layers = params->number_spatial_layers;
  cpi->common.number_temporal_layers = params->number_temporal_layers;
  cpi->svc.number_spatial_layers = params->number_spatial_layers;
  cpi->svc.number_temporal_layers = params->number_temporal_layers;
  if (cpi->common.number_spatial_layers > 1 ||
      cpi->common.number_temporal_layers > 1) {
    unsigned int sl, tl;
    cpi->use_svc = 1;
    for (sl = 0; sl < cpi->common.number_spatial_layers; ++sl) {
      for (tl = 0; tl < cpi->common.number_temporal_layers; ++tl) {
        const int layer =
            LAYER_IDS_TO_IDX(sl, tl, cpi->common.number_temporal_layers);
        LAYER_CONTEXT *lc = &cpi->svc.layer_context[layer];
        lc->max_q = params->max_quantizers[layer];
        lc->min_q = params->min_quantizers[layer];
        lc->scaling_factor_num = params->scaling_factor_num[sl];
        lc->scaling_factor_den = params->scaling_factor_den[sl];
        lc->layer_target_bitrate = 1000 * params->layer_target_bitrate[layer];
        lc->framerate_factor = params->framerate_factor[tl];
      }
    }
    if (cpi->common.current_frame.frame_number == 0)
      av1_init_layer_context(cpi);
    else
      av1_update_layer_context_change_config(cpi, cpi->oxcf.target_bandwidth);
  }
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_svc_ref_frame_config(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  AV1_COMP *const cpi = ctx->cpi;
  aom_svc_ref_frame_config_t *const data =
      va_arg(args, aom_svc_ref_frame_config_t *);
  cpi->svc.external_ref_frame_config = 1;
  for (unsigned int i = 0; i < INTER_REFS_PER_FRAME; ++i) {
    cpi->svc.reference[i] = data->reference[i];
    cpi->svc.ref_idx[i] = data->ref_idx[i];
  }
  for (unsigned int i = 0; i < REF_FRAMES; ++i)
    cpi->svc.refresh[i] = data->refresh[i];
  return AOM_CODEC_OK;
}

static aom_codec_err_t ctrl_set_tune_content(aom_codec_alg_priv_t *ctx,
                                             va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.content = CAST(AV1E_SET_TUNE_CONTENT, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_cdf_update_mode(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.cdf_update_mode = CAST(AV1E_SET_CDF_UPDATE_MODE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_color_primaries(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.color_primaries = CAST(AV1E_SET_COLOR_PRIMARIES, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_transfer_characteristics(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.transfer_characteristics =
      CAST(AV1E_SET_TRANSFER_CHARACTERISTICS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_matrix_coefficients(aom_codec_alg_priv_t *ctx,
                                                    va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.matrix_coefficients = CAST(AV1E_SET_MATRIX_COEFFICIENTS, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_chroma_sample_position(
    aom_codec_alg_priv_t *ctx, va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.chroma_sample_position =
      CAST(AV1E_SET_CHROMA_SAMPLE_POSITION, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_color_range(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.color_range = CAST(AV1E_SET_COLOR_RANGE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_render_size(aom_codec_alg_priv_t *ctx,
                                            va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  int *const render_size = va_arg(args, int *);
  extra_cfg.render_width = render_size[0];
  extra_cfg.render_height = render_size[1];
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_superblock_size(aom_codec_alg_priv_t *ctx,
                                                va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.superblock_size = CAST(AV1E_SET_SUPERBLOCK_SIZE, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_chroma_subsampling_x(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.chroma_subsampling_x = CAST(AV1E_SET_CHROMA_SUBSAMPLING_X, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_set_chroma_subsampling_y(aom_codec_alg_priv_t *ctx,
                                                     va_list args) {
  struct av1_extracfg extra_cfg = ctx->extra_cfg;
  extra_cfg.chroma_subsampling_y = CAST(AV1E_SET_CHROMA_SUBSAMPLING_Y, args);
  return update_extra_cfg(ctx, &extra_cfg);
}

static aom_codec_err_t ctrl_get_seq_level_idx(aom_codec_alg_priv_t *ctx,
                                              va_list args) {
  int *const arg = va_arg(args, int *);
  const AV1_COMP *const cpi = ctx->cpi;
  if (arg == NULL) return AOM_CODEC_INVALID_PARAM;
  return av1_get_seq_level_idx(&cpi->common.seq_params, &cpi->level_params,
                               arg);
}

static aom_codec_ctrl_fn_map_t encoder_ctrl_maps[] = {
  { AV1_COPY_REFERENCE, ctrl_copy_reference },
  { AOME_USE_REFERENCE, ctrl_use_reference },

  // Setters
  { AV1_SET_REFERENCE, ctrl_set_reference },
  { AOME_SET_ROI_MAP, ctrl_set_roi_map },
  { AOME_SET_ACTIVEMAP, ctrl_set_active_map },
  { AOME_SET_SCALEMODE, ctrl_set_scale_mode },
  { AOME_SET_SPATIAL_LAYER_ID, ctrl_set_spatial_layer_id },
  { AOME_SET_CPUUSED, ctrl_set_cpuused },
  { AOME_SET_ENABLEAUTOALTREF, ctrl_set_enable_auto_alt_ref },
  { AOME_SET_ENABLEAUTOBWDREF, ctrl_set_enable_auto_bwd_ref },
  { AOME_SET_SHARPNESS, ctrl_set_sharpness },
  { AOME_SET_STATIC_THRESHOLD, ctrl_set_static_thresh },
  { AV1E_SET_ROW_MT, ctrl_set_row_mt },
  { AV1E_SET_TILE_COLUMNS, ctrl_set_tile_columns },
  { AV1E_SET_TILE_ROWS, ctrl_set_tile_rows },
  { AV1E_SET_ENABLE_TPL_MODEL, ctrl_set_enable_tpl_model },
  { AV1E_SET_ENABLE_KEYFRAME_FILTERING, ctrl_set_enable_keyframe_filtering },
  { AOME_SET_ARNR_MAXFRAMES, ctrl_set_arnr_max_frames },
  { AOME_SET_ARNR_STRENGTH, ctrl_set_arnr_strength },
  { AOME_SET_TUNING, ctrl_set_tuning },
  { AOME_SET_CQ_LEVEL, ctrl_set_cq_level },
  { AOME_SET_MAX_INTRA_BITRATE_PCT, ctrl_set_rc_max_intra_bitrate_pct },
  { AOME_SET_NUMBER_SPATIAL_LAYERS, ctrl_set_number_spatial_layers },
  { AV1E_SET_MAX_INTER_BITRATE_PCT, ctrl_set_rc_max_inter_bitrate_pct },
  { AV1E_SET_GF_CBR_BOOST_PCT, ctrl_set_rc_gf_cbr_boost_pct },
  { AV1E_SET_LOSSLESS, ctrl_set_lossless },
  { AV1E_SET_ENABLE_CDEF, ctrl_set_enable_cdef },
  { AV1E_SET_ENABLE_RESTORATION, ctrl_set_enable_restoration },
  { AV1E_SET_FORCE_VIDEO_MODE, ctrl_set_force_video_mode },
  { AV1E_SET_ENABLE_OBMC, ctrl_set_enable_obmc },
  { AV1E_SET_DISABLE_TRELLIS_QUANT, ctrl_set_disable_trellis_quant },
  { AV1E_SET_ENABLE_QM, ctrl_set_enable_qm },
  { AV1E_SET_QM_Y, ctrl_set_qm_y },
  { AV1E_SET_QM_U, ctrl_set_qm_u },
  { AV1E_SET_QM_V, ctrl_set_qm_v },
  { AV1E_SET_QM_MIN, ctrl_set_qm_min },
  { AV1E_SET_QM_MAX, ctrl_set_qm_max },
  { AV1E_SET_NUM_TG, ctrl_set_num_tg },
  { AV1E_SET_MTU, ctrl_set_mtu },
  { AV1E_SET_TIMING_INFO_TYPE, ctrl_set_timing_info_type },
  { AV1E_SET_FRAME_PARALLEL_DECODING, ctrl_set_frame_parallel_decoding_mode },
  { AV1E_SET_ERROR_RESILIENT_MODE, ctrl_set_error_resilient_mode },
  { AV1E_SET_S_FRAME_MODE, ctrl_set_s_frame_mode },
  { AV1E_SET_ENABLE_RECT_PARTITIONS, ctrl_set_enable_rect_partitions },
  { AV1E_SET_ENABLE_AB_PARTITIONS, ctrl_set_enable_ab_partitions },
  { AV1E_SET_ENABLE_1TO4_PARTITIONS, ctrl_set_enable_1to4_partitions },
  { AV1E_SET_MIN_PARTITION_SIZE, ctrl_set_min_partition_size },
  { AV1E_SET_MAX_PARTITION_SIZE, ctrl_set_max_partition_size },
  { AV1E_SET_ENABLE_DUAL_FILTER, ctrl_set_enable_dual_filter },
  { AV1E_SET_ENABLE_CHROMA_DELTAQ, ctrl_set_enable_chroma_deltaq },
  { AV1E_SET_ENABLE_INTRA_EDGE_FILTER, ctrl_set_enable_intra_edge_filter },
  { AV1E_SET_ENABLE_ORDER_HINT, ctrl_set_enable_order_hint },
  { AV1E_SET_ENABLE_TX64, ctrl_set_enable_tx64 },
  { AV1E_SET_ENABLE_FLIP_IDTX, ctrl_set_enable_flip_idtx },
  { AV1E_SET_ENABLE_DIST_WTD_COMP, ctrl_set_enable_dist_wtd_comp },
  { AV1E_SET_MAX_REFERENCE_FRAMES, ctrl_set_max_reference_frames },
  { AV1E_SET_REDUCED_REFERENCE_SET, ctrl_set_enable_reduced_reference_set },
  { AV1E_SET_ENABLE_REF_FRAME_MVS, ctrl_set_enable_ref_frame_mvs },
  { AV1E_SET_ALLOW_REF_FRAME_MVS, ctrl_set_allow_ref_frame_mvs },
  { AV1E_SET_ENABLE_MASKED_COMP, ctrl_set_enable_masked_comp },
  { AV1E_SET_ENABLE_ONESIDED_COMP, ctrl_set_enable_onesided_comp },
  { AV1E_SET_ENABLE_INTERINTRA_COMP, ctrl_set_enable_interintra_comp },
  { AV1E_SET_ENABLE_SMOOTH_INTERINTRA, ctrl_set_enable_smooth_interintra },
  { AV1E_SET_ENABLE_DIFF_WTD_COMP, ctrl_set_enable_diff_wtd_comp },
  { AV1E_SET_ENABLE_INTERINTER_WEDGE, ctrl_set_enable_interinter_wedge },
  { AV1E_SET_ENABLE_INTERINTRA_WEDGE, ctrl_set_enable_interintra_wedge },
  { AV1E_SET_ENABLE_GLOBAL_MOTION, ctrl_set_enable_global_motion },
  { AV1E_SET_ENABLE_WARPED_MOTION, ctrl_set_enable_warped_motion },
  { AV1E_SET_ALLOW_WARPED_MOTION, ctrl_set_allow_warped_motion },
  { AV1E_SET_ENABLE_FILTER_INTRA, ctrl_set_enable_filter_intra },
  { AV1E_SET_ENABLE_SMOOTH_INTRA, ctrl_set_enable_smooth_intra },
  { AV1E_SET_ENABLE_PAETH_INTRA, ctrl_set_enable_paeth_intra },
  { AV1E_SET_ENABLE_CFL_INTRA, ctrl_set_enable_cfl_intra },
  { AV1E_SET_ENABLE_SUPERRES, ctrl_set_enable_superres },
  { AV1E_SET_ENABLE_OVERLAY, ctrl_set_enable_overlay },
  { AV1E_SET_ENABLE_PALETTE, ctrl_set_enable_palette },
  { AV1E_SET_ENABLE_INTRABC, ctrl_set_enable_intrabc },
  { AV1E_SET_ENABLE_ANGLE_DELTA, ctrl_set_enable_angle_delta },
  { AV1E_SET_AQ_MODE, ctrl_set_aq_mode },
  { AV1E_SET_REDUCED_TX_TYPE_SET, ctrl_set_reduced_tx_type_set },
  { AV1E_SET_INTRA_DCT_ONLY, ctrl_set_intra_dct_only },
  { AV1E_SET_INTER_DCT_ONLY, ctrl_set_inter_dct_only },
  { AV1E_SET_INTRA_DEFAULT_TX_ONLY, ctrl_set_intra_default_tx_only },
  { AV1E_SET_QUANT_B_ADAPT, ctrl_set_quant_b_adapt },
  { AV1E_SET_COEFF_COST_UPD_FREQ, ctrl_set_coeff_cost_upd_freq },
  { AV1E_SET_MODE_COST_UPD_FREQ, ctrl_set_mode_cost_upd_freq },
  { AV1E_SET_MV_COST_UPD_FREQ, ctrl_set_mv_cost_upd_freq },
  { AV1E_SET_DELTAQ_MODE, ctrl_set_deltaq_mode },
  { AV1E_SET_DELTALF_MODE, ctrl_set_deltalf_mode },
  { AV1E_SET_FRAME_PERIODIC_BOOST, ctrl_set_frame_periodic_boost },
  { AV1E_SET_TUNE_CONTENT, ctrl_set_tune_content },
  { AV1E_SET_CDF_UPDATE_MODE, ctrl_set_cdf_update_mode },
  { AV1E_SET_COLOR_PRIMARIES, ctrl_set_color_primaries },
  { AV1E_SET_TRANSFER_CHARACTERISTICS, ctrl_set_transfer_characteristics },
  { AV1E_SET_MATRIX_COEFFICIENTS, ctrl_set_matrix_coefficients },
  { AV1E_SET_CHROMA_SAMPLE_POSITION, ctrl_set_chroma_sample_position },
  { AV1E_SET_COLOR_RANGE, ctrl_set_color_range },
  { AV1E_SET_NOISE_SENSITIVITY, ctrl_set_noise_sensitivity },
  { AV1E_SET_MIN_GF_INTERVAL, ctrl_set_min_gf_interval },
  { AV1E_SET_MAX_GF_INTERVAL, ctrl_set_max_gf_interval },
  { AV1E_SET_GF_MIN_PYRAMID_HEIGHT, ctrl_set_gf_min_pyr_height },
  { AV1E_SET_GF_MAX_PYRAMID_HEIGHT, ctrl_set_gf_max_pyr_height },
  { AV1E_SET_RENDER_SIZE, ctrl_set_render_size },
  { AV1E_SET_SUPERBLOCK_SIZE, ctrl_set_superblock_size },
  { AV1E_SET_SINGLE_TILE_DECODING, ctrl_set_single_tile_decoding },
  { AV1E_SET_VMAF_MODEL_PATH, ctrl_set_vmaf_model_path },
  { AV1E_SET_FILM_GRAIN_TEST_VECTOR, ctrl_set_film_grain_test_vector },
  { AV1E_SET_FILM_GRAIN_TABLE, ctrl_set_film_grain_table },
  { AV1E_SET_DENOISE_NOISE_LEVEL, ctrl_set_denoise_noise_level },
  { AV1E_SET_DENOISE_BLOCK_SIZE, ctrl_set_denoise_block_size },
  { AV1E_ENABLE_MOTION_VECTOR_UNIT_TEST, ctrl_enable_motion_vector_unit_test },
  { AV1E_ENABLE_EXT_TILE_DEBUG, ctrl_enable_ext_tile_debug },
  { AV1E_SET_TARGET_SEQ_LEVEL_IDX, ctrl_set_target_seq_level_idx },
  { AV1E_SET_TIER_MASK, ctrl_set_tier_mask },
  { AV1E_SET_MIN_CR, ctrl_set_min_cr },
  { AV1E_SET_SVC_LAYER_ID, ctrl_set_layer_id },
  { AV1E_SET_SVC_PARAMS, ctrl_set_svc_params },
  { AV1E_SET_SVC_REF_FRAME_CONFIG, ctrl_set_svc_ref_frame_config },
  { AV1E_ENABLE_SB_MULTIPASS_UNIT_TEST, ctrl_enable_sb_multipass_unit_test },

  // Getters
  { AOME_GET_LAST_QUANTIZER, ctrl_get_quantizer },
  { AOME_GET_LAST_QUANTIZER_64, ctrl_get_quantizer64 },
  { AV1_GET_REFERENCE, ctrl_get_reference },
  { AV1E_GET_ACTIVEMAP, ctrl_get_active_map },
  { AV1_GET_NEW_FRAME_IMAGE, ctrl_get_new_frame_image },
  { AV1_COPY_NEW_FRAME_IMAGE, ctrl_copy_new_frame_image },
  { AV1E_SET_CHROMA_SUBSAMPLING_X, ctrl_set_chroma_subsampling_x },
  { AV1E_SET_CHROMA_SUBSAMPLING_Y, ctrl_set_chroma_subsampling_y },
  { AV1E_GET_SEQ_LEVEL_IDX, ctrl_get_seq_level_idx },
  { -1, NULL },
};

static const aom_codec_enc_cfg_t encoder_usage_cfg[] = {
  {
      // NOLINT
      AOM_USAGE_GOOD_QUALITY,  // g_usage - non-realtime usage
      0,                       // g_threads
      0,                       // g_profile

      320,         // g_width
      240,         // g_height
      0,           // g_limit
      0,           // g_forced_max_frame_width
      0,           // g_forced_max_frame_height
      AOM_BITS_8,  // g_bit_depth
      8,           // g_input_bit_depth

      { 1, 30 },  // g_timebase

      0,  // g_error_resilient

      AOM_RC_ONE_PASS,  // g_pass

      19,  // g_lag_in_frames

      0,                // rc_dropframe_thresh
      RESIZE_NONE,      // rc_resize_mode
      SCALE_NUMERATOR,  // rc_resize_denominator
      SCALE_NUMERATOR,  // rc_resize_kf_denominator

      SUPERRES_NONE,    // rc_superres_mode
      SCALE_NUMERATOR,  // rc_superres_denominator
      SCALE_NUMERATOR,  // rc_superres_kf_denominator
      63,               // rc_superres_qthresh
      32,               // rc_superres_kf_qthresh

      AOM_VBR,      // rc_end_usage
      { NULL, 0 },  // rc_twopass_stats_in
      { NULL, 0 },  // rc_firstpass_mb_stats_in
      256,          // rc_target_bandwidth
      0,            // rc_min_quantizer
      63,           // rc_max_quantizer
      25,           // rc_undershoot_pct
      25,           // rc_overshoot_pct

      6000,  // rc_max_buffer_size
      4000,  // rc_buffer_initial_size
      5000,  // rc_buffer_optimal_size

      50,    // rc_two_pass_vbrbias
      0,     // rc_two_pass_vbrmin_section
      2000,  // rc_two_pass_vbrmax_section

      // keyframing settings (kf)
      0,                       // fwd_kf_enabled
      AOM_KF_AUTO,             // g_kfmode
      0,                       // kf_min_dist
      9999,                    // kf_max_dist
      0,                       // sframe_dist
      1,                       // sframe_mode
      0,                       // large_scale_tile
      0,                       // monochrome
      0,                       // full_still_picture_hdr
      0,                       // save_as_annexb
      0,                       // tile_width_count
      0,                       // tile_height_count
      { 0 },                   // tile_widths
      { 0 },                   // tile_heights
      0,                       // use_fixed_qp_offsets
      { -1, -1, -1, -1, -1 },  // fixed_qp_offsets
      { 0, 128, 128, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0,   0,   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },  // cfg
  },
  {
      // NOLINT
      AOM_USAGE_REALTIME,  // g_usage - real-time usage
      0,                   // g_threads
      0,                   // g_profile

      320,         // g_width
      240,         // g_height
      0,           // g_limit
      0,           // g_forced_max_frame_width
      0,           // g_forced_max_frame_height
      AOM_BITS_8,  // g_bit_depth
      8,           // g_input_bit_depth

      { 1, 30 },  // g_timebase

      0,  // g_error_resilient

      AOM_RC_ONE_PASS,  // g_pass

      1,  // g_lag_in_frames

      0,                // rc_dropframe_thresh
      RESIZE_NONE,      // rc_resize_mode
      SCALE_NUMERATOR,  // rc_resize_denominator
      SCALE_NUMERATOR,  // rc_resize_kf_denominator

      0,                // rc_superres_mode
      SCALE_NUMERATOR,  // rc_superres_denominator
      SCALE_NUMERATOR,  // rc_superres_kf_denominator
      63,               // rc_superres_qthresh
      32,               // rc_superres_kf_qthresh

      AOM_CBR,      // rc_end_usage
      { NULL, 0 },  // rc_twopass_stats_in
      { NULL, 0 },  // rc_firstpass_mb_stats_in
      256,          // rc_target_bandwidth
      0,            // rc_min_quantizer
      63,           // rc_max_quantizer
      25,           // rc_undershoot_pct
      25,           // rc_overshoot_pct

      6000,  // rc_max_buffer_size
      4000,  // rc_buffer_initial_size
      5000,  // rc_buffer_optimal_size

      50,    // rc_two_pass_vbrbias
      0,     // rc_two_pass_vbrmin_section
      2000,  // rc_two_pass_vbrmax_section

      // keyframing settings (kf)
      0,                       // fwd_kf_enabled
      AOM_KF_AUTO,             // g_kfmode
      0,                       // kf_min_dist
      9999,                    // kf_max_dist
      0,                       // sframe_dist
      1,                       // sframe_mode
      0,                       // large_scale_tile
      0,                       // monochrome
      0,                       // full_still_picture_hdr
      0,                       // save_as_annexb
      0,                       // tile_width_count
      0,                       // tile_height_count
      { 0 },                   // tile_widths
      { 0 },                   // tile_heights
      0,                       // use_fixed_qp_offsets
      { -1, -1, -1, -1, -1 },  // fixed_qp_offsets
      { 0, 128, 128, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0,   0,   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },  // cfg
  },
};

#ifndef VERSION_STRING
#define VERSION_STRING
#endif
CODEC_INTERFACE(aom_codec_av1_cx) = {
  "AOMedia Project AV1 Encoder" VERSION_STRING,
  AOM_CODEC_INTERNAL_ABI_VERSION,
  AOM_CODEC_CAP_HIGHBITDEPTH | AOM_CODEC_CAP_ENCODER |
      AOM_CODEC_CAP_PSNR,  // aom_codec_caps_t
  encoder_init,            // aom_codec_init_fn_t
  encoder_destroy,         // aom_codec_destroy_fn_t
  encoder_ctrl_maps,       // aom_codec_ctrl_fn_map_t
  {
      // NOLINT
      NULL,  // aom_codec_peek_si_fn_t
      NULL,  // aom_codec_get_si_fn_t
      NULL,  // aom_codec_decode_fn_t
      NULL,  // aom_codec_get_frame_fn_t
      NULL   // aom_codec_set_fb_fn_t
  },
  {
      // NOLINT
      2,                           // 2 cfg
      encoder_usage_cfg,           // aom_codec_enc_cfg_t
      encoder_encode,              // aom_codec_encode_fn_t
      encoder_get_cxdata,          // aom_codec_get_cx_data_fn_t
      encoder_set_config,          // aom_codec_enc_config_set_fn_t
      encoder_get_global_headers,  // aom_codec_get_global_headers_fn_t
      encoder_get_preview          // aom_codec_get_preview_frame_fn_t
  }
};
