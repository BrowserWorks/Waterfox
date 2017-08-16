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

#ifndef AV1_ENCODER_ENCODER_H_
#define AV1_ENCODER_ENCODER_H_

#include <stdio.h>

#include "./aom_config.h"
#include "aom/aomcx.h"

#include "av1/common/alloccommon.h"
#include "av1/common/entropymode.h"
#include "av1/common/thread_common.h"
#include "av1/common/onyxc_int.h"
#include "av1/encoder/aq_cyclicrefresh.h"
#if CONFIG_ANS
#include "aom_dsp/ans.h"
#include "aom_dsp/buf_ans.h"
#endif
#include "av1/encoder/av1_quantize.h"
#include "av1/encoder/context_tree.h"
#include "av1/encoder/encodemb.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/lookahead.h"
#include "av1/encoder/mbgraph.h"
#include "av1/encoder/mcomp.h"
#include "av1/encoder/ratectrl.h"
#include "av1/encoder/rd.h"
#include "av1/encoder/speed_features.h"
#include "av1/encoder/tokenize.h"
#if CONFIG_XIPHRC
#include "av1/encoder/ratectrl_xiph.h"
#endif

#if CONFIG_INTERNAL_STATS
#include "aom_dsp/ssim.h"
#endif
#include "aom_dsp/variance.h"
#include "aom/internal/aom_codec_internal.h"
#include "aom_util/aom_thread.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  int nmv_vec_cost[NMV_CONTEXTS][MV_JOINTS];
  int nmv_costs[NMV_CONTEXTS][2][MV_VALS];
  int nmv_costs_hp[NMV_CONTEXTS][2][MV_VALS];

  // 0 = Intra, Last, GF, ARF
  signed char last_ref_lf_deltas[TOTAL_REFS_PER_FRAME];
  // 0 = ZERO_MV, MV
  signed char last_mode_lf_deltas[MAX_MODE_LF_DELTAS];

  FRAME_CONTEXT fc;
} CODING_CONTEXT;

typedef enum {
  // regular inter frame
  REGULAR_FRAME = 0,
  // alternate reference frame
  ARF_FRAME = 1,
  // overlay frame
  OVERLAY_FRAME = 2,
  // golden frame
  GLD_FRAME = 3,
#if CONFIG_EXT_REFS
  // backward reference frame
  BRF_FRAME = 4,
  // extra alternate reference frame
  EXT_ARF_FRAME = 5
#endif
} FRAME_CONTEXT_INDEX;

typedef enum {
  NORMAL = 0,
  FOURFIVE = 1,
  THREEFIVE = 2,
  ONETWO = 3
} AOM_SCALING;

typedef enum {
  // Good Quality Fast Encoding. The encoder balances quality with the amount of
  // time it takes to encode the output. Speed setting controls how fast.
  GOOD
} MODE;

typedef enum {
  FRAMEFLAGS_KEY = 1 << 0,
  FRAMEFLAGS_GOLDEN = 1 << 1,
#if CONFIG_EXT_REFS
  FRAMEFLAGS_BWDREF = 1 << 2,
  FRAMEFLAGS_ALTREF = 1 << 3,
#else
  FRAMEFLAGS_ALTREF = 1 << 2,
#endif  // CONFIG_EXT_REFS
} FRAMETYPE_FLAGS;

typedef enum {
  NO_AQ = 0,
  VARIANCE_AQ = 1,
  COMPLEXITY_AQ = 2,
  CYCLIC_REFRESH_AQ = 3,
#if CONFIG_DELTA_Q && !CONFIG_EXT_DELTA_Q
  DELTA_AQ = 4,
#endif
  AQ_MODE_COUNT  // This should always be the last member of the enum
} AQ_MODE;
#if CONFIG_EXT_DELTA_Q
typedef enum {
  NO_DELTA_Q = 0,
  DELTA_Q_ONLY = 1,
  DELTA_Q_LF = 2,
  DELTAQ_MODE_COUNT  // This should always be the last member of the enum
} DELTAQ_MODE;
#endif
typedef enum {
  RESIZE_NONE = 0,    // No frame resizing allowed.
  RESIZE_FIXED = 1,   // All frames are coded at the specified dimension.
  RESIZE_DYNAMIC = 2  // Coded size of each frame is determined by the codec.
} RESIZE_TYPE;

typedef struct AV1EncoderConfig {
  BITSTREAM_PROFILE profile;
  aom_bit_depth_t bit_depth;     // Codec bit-depth.
  int width;                     // width of data passed to the compressor
  int height;                    // height of data passed to the compressor
  unsigned int input_bit_depth;  // Input bit depth.
  double init_framerate;         // set to passed in framerate
  int64_t target_bandwidth;      // bandwidth to be used in bits per second

  int noise_sensitivity;  // pre processing blur: recommendation 0
  int sharpness;          // sharpening output: recommendation 0:
  int speed;
  // maximum allowed bitrate for any intra frame in % of bitrate target.
  unsigned int rc_max_intra_bitrate_pct;
  // maximum allowed bitrate for any inter frame in % of bitrate target.
  unsigned int rc_max_inter_bitrate_pct;
  // percent of rate boost for golden frame in CBR mode.
  unsigned int gf_cbr_boost_pct;

  MODE mode;
  int pass;

  // Key Framing Operations
  int auto_key;  // autodetect cut scenes and set the keyframes
  int key_freq;  // maximum distance to key frame.

  int lag_in_frames;  // how many frames lag before we start encoding

  // ----------------------------------------------------------------
  // DATARATE CONTROL OPTIONS

  // vbr, cbr, constrained quality or constant quality
  enum aom_rc_mode rc_mode;

  // buffer targeting aggressiveness
  int under_shoot_pct;
  int over_shoot_pct;

  // buffering parameters
  int64_t starting_buffer_level_ms;
  int64_t optimal_buffer_level_ms;
  int64_t maximum_buffer_size_ms;

  // Frame drop threshold.
  int drop_frames_water_mark;

  // controlling quality
  int fixed_q;
  int worst_allowed_q;
  int best_allowed_q;
  int cq_level;
  AQ_MODE aq_mode;  // Adaptive Quantization mode
#if CONFIG_EXT_DELTA_Q
  DELTAQ_MODE deltaq_mode;
#endif
#if CONFIG_AOM_QM
  int using_qm;
  int qm_minlevel;
  int qm_maxlevel;
#endif
#if CONFIG_TILE_GROUPS
  unsigned int num_tile_groups;
  unsigned int mtu;
#endif

#if CONFIG_TEMPMV_SIGNALING
  unsigned int disable_tempmv;
#endif
  // Internal frame size scaling.
  RESIZE_TYPE resize_mode;
  int scaled_frame_width;
  int scaled_frame_height;

#if CONFIG_FRAME_SUPERRES
  // Frame Super-Resolution size scaling
  int superres_enabled;
#endif  // CONFIG_FRAME_SUPERRES

  // Enable feature to reduce the frame quantization every x frames.
  int frame_periodic_boost;

  // two pass datarate control
  int two_pass_vbrbias;  // two pass datarate control tweaks
  int two_pass_vbrmin_section;
  int two_pass_vbrmax_section;
  // END DATARATE CONTROL OPTIONS
  // ----------------------------------------------------------------

  int enable_auto_arf;
#if CONFIG_EXT_REFS
  int enable_auto_brf;  // (b)ackward (r)ef (f)rame
#endif                  // CONFIG_EXT_REFS

  /* Bitfield defining the error resiliency features to enable.
   * Can provide decodable frames after losses in previous
   * frames and decodable partitions after losses in the same frame.
   */
  unsigned int error_resilient_mode;

  /* Bitfield defining the parallel decoding mode where the
   * decoding in successive frames may be conducted in parallel
   * just by decoding the frame headers.
   */
  unsigned int frame_parallel_decoding_mode;

  int arnr_max_frames;
  int arnr_strength;

  int min_gf_interval;
  int max_gf_interval;

  int tile_columns;
  int tile_rows;
#if CONFIG_DEPENDENT_HORZTILES
  int dependent_horz_tiles;
#endif
#if CONFIG_LOOPFILTERING_ACROSS_TILES
  int loop_filter_across_tiles_enabled;
#endif  // CONFIG_LOOPFILTERING_ACROSS_TILES

  int max_threads;

  aom_fixed_buf_t two_pass_stats_in;
  struct aom_codec_pkt_list *output_pkt_list;

#if CONFIG_FP_MB_STATS
  aom_fixed_buf_t firstpass_mb_stats_in;
#endif

  aom_tune_metric tuning;
  aom_tune_content content;
#if CONFIG_HIGHBITDEPTH
  int use_highbitdepth;
#endif
  aom_color_space_t color_space;
  int color_range;
  int render_width;
  int render_height;

#if CONFIG_EXT_PARTITION
  aom_superblock_size_t superblock_size;
#endif  // CONFIG_EXT_PARTITION
#if CONFIG_ANS && ANS_MAX_SYMBOLS
  int ans_window_size_log2;
#endif  // CONFIG_ANS && ANS_MAX_SYMBOLS
#if CONFIG_EXT_TILE
  unsigned int tile_encoding_mode;
#endif  // CONFIG_EXT_TILE

  unsigned int motion_vector_unit_test;
} AV1EncoderConfig;

static INLINE int is_lossless_requested(const AV1EncoderConfig *cfg) {
  return cfg->best_allowed_q == 0 && cfg->worst_allowed_q == 0;
}

// TODO(jingning) All spatially adaptive variables should go to TileDataEnc.
typedef struct TileDataEnc {
  TileInfo tile_info;
  int thresh_freq_fact[BLOCK_SIZES][MAX_MODES];
  int mode_map[BLOCK_SIZES][MAX_MODES];
  int m_search_count;
  int ex_search_count;
#if CONFIG_PVQ
  PVQ_QUEUE pvq_q;
#endif
#if CONFIG_CFL
  CFL_CTX cfl;
#endif
#if CONFIG_EC_ADAPT
  DECLARE_ALIGNED(16, FRAME_CONTEXT, tctx);
#endif
} TileDataEnc;

typedef struct RD_COUNTS {
  av1_coeff_count coef_counts[TX_SIZES][PLANE_TYPES];
  int64_t comp_pred_diff[REFERENCE_MODES];
#if CONFIG_GLOBAL_MOTION
  // Stores number of 4x4 blocks using global motion per reference frame.
  int global_motion_used[TOTAL_REFS_PER_FRAME];
#endif  // CONFIG_GLOBAL_MOTION
} RD_COUNTS;

typedef struct ThreadData {
  MACROBLOCK mb;
  RD_COUNTS rd_counts;
  FRAME_COUNTS *counts;

  PICK_MODE_CONTEXT *leaf_tree;
  PC_TREE *pc_tree;
  PC_TREE *pc_root[MAX_MIB_SIZE_LOG2 - MIN_MIB_SIZE_LOG2 + 1];
#if CONFIG_MOTION_VAR
  int32_t *wsrc_buf;
  int32_t *mask_buf;
  uint8_t *above_pred_buf;
  uint8_t *left_pred_buf;
#endif

#if CONFIG_PALETTE
  PALETTE_BUFFER *palette_buffer;
#endif  // CONFIG_PALETTE
} ThreadData;

struct EncWorkerData;

typedef struct ActiveMap {
  int enabled;
  int update;
  unsigned char *map;
} ActiveMap;

#define NUM_STAT_TYPES 4  // types of stats: Y, U, V and ALL

typedef struct IMAGE_STAT {
  double stat[NUM_STAT_TYPES];
  double worst;
} ImageStat;

#undef NUM_STAT_TYPES

typedef struct {
  int ref_count;
  YV12_BUFFER_CONFIG buf;
} EncRefCntBuffer;

typedef struct TileBufferEnc {
  uint8_t *data;
  size_t size;
} TileBufferEnc;

typedef struct AV1_COMP {
  QUANTS quants;
  ThreadData td;
  MB_MODE_INFO_EXT *mbmi_ext_base;
  Dequants dequants;
  AV1_COMMON common;
  AV1EncoderConfig oxcf;
  struct lookahead_ctx *lookahead;
  struct lookahead_entry *alt_ref_source;

  YV12_BUFFER_CONFIG *source;
  YV12_BUFFER_CONFIG *last_source;  // NULL for first frame and alt_ref frames
  YV12_BUFFER_CONFIG *un_scaled_source;
  YV12_BUFFER_CONFIG scaled_source;
  YV12_BUFFER_CONFIG *unscaled_last_source;
  YV12_BUFFER_CONFIG scaled_last_source;

  // Up-sampled reference buffers
  // NOTE(zoeliu): It is needed to allocate sufficient space to the up-sampled
  // reference buffers, which should include the up-sampled version of all the
  // possibly stored references plus the currently coded frame itself.
  EncRefCntBuffer upsampled_ref_bufs[REF_FRAMES + 1];
  int upsampled_ref_idx[REF_FRAMES + 1];

  // For a still frame, this flag is set to 1 to skip partition search.
  int partition_search_skippable_frame;

  int scaled_ref_idx[TOTAL_REFS_PER_FRAME];
#if CONFIG_EXT_REFS
  int lst_fb_idxes[LAST_REF_FRAMES];
#else
  int lst_fb_idx;
#endif  // CONFIG_EXT_REFS
  int gld_fb_idx;
#if CONFIG_EXT_REFS
  int bwd_fb_idx;  // BWD_REF_FRAME
#endif             // CONFIG_EXT_REFS
  int alt_fb_idx;

  int last_show_frame_buf_idx;  // last show frame buffer index

  int refresh_last_frame;
  int refresh_golden_frame;
#if CONFIG_EXT_REFS
  int refresh_bwd_ref_frame;
#endif  // CONFIG_EXT_REFS
  int refresh_alt_ref_frame;

  int ext_refresh_frame_flags_pending;
  int ext_refresh_last_frame;
  int ext_refresh_golden_frame;
  int ext_refresh_alt_ref_frame;

  int ext_refresh_frame_context_pending;
  int ext_refresh_frame_context;

  YV12_BUFFER_CONFIG last_frame_uf;
#if CONFIG_LOOP_RESTORATION
  YV12_BUFFER_CONFIG last_frame_db;
  YV12_BUFFER_CONFIG trial_frame_rst;
  uint8_t *extra_rstbuf;  // Extra buffers used in restoration search
  RestorationInfo rst_search[MAX_MB_PLANE];  // Used for encoder side search
#endif                                       // CONFIG_LOOP_RESTORATION

  // Ambient reconstruction err target for force key frames
  int64_t ambient_err;

  RD_OPT rd;

  CODING_CONTEXT coding_context;

  int nmv_costs[NMV_CONTEXTS][2][MV_VALS];
  int nmv_costs_hp[NMV_CONTEXTS][2][MV_VALS];

  int64_t last_time_stamp_seen;
  int64_t last_end_time_stamp_seen;
  int64_t first_time_stamp_ever;

  RATE_CONTROL rc;
#if CONFIG_XIPHRC
  od_rc_state od_rc;
#endif
  double framerate;

  // NOTE(zoeliu): Any inter frame allows maximum of REF_FRAMES inter
  // references; Plus the currently coded frame itself, it is needed to allocate
  // sufficient space to the size of the maximum possible number of frames.
  int interp_filter_selected[REF_FRAMES + 1][SWITCHABLE];

  struct aom_codec_pkt_list *output_pkt_list;

  MBGRAPH_FRAME_STATS mbgraph_stats[MAX_LAG_BUFFERS];
  int mbgraph_n_frames;  // number of frames filled in the above
  int static_mb_pct;     // % forced skip mbs by segmentation
  int ref_frame_flags;

  SPEED_FEATURES sf;

  unsigned int max_mv_magnitude;
  int mv_step_param;

  int allow_comp_inter_inter;

  uint8_t *segmentation_map;

  CYCLIC_REFRESH *cyclic_refresh;
  ActiveMap active_map;

  fractional_mv_step_fp *find_fractional_mv_step;
  av1_full_search_fn_t full_search_sad;  // It is currently unused.
  av1_diamond_search_fn_t diamond_search_sad;
  aom_variance_fn_ptr_t fn_ptr[BLOCK_SIZES];
  uint64_t time_receive_data;
  uint64_t time_compress_data;
  uint64_t time_pick_lpf;
  uint64_t time_encode_sb_row;

#if CONFIG_FP_MB_STATS
  int use_fp_mb_stats;
#endif

  TWO_PASS twopass;

  YV12_BUFFER_CONFIG alt_ref_buffer;

#if CONFIG_INTERNAL_STATS
  unsigned int mode_chosen_counts[MAX_MODES];

  int count;
  uint64_t total_sq_error;
  uint64_t total_samples;
  ImageStat psnr;

  double total_blockiness;
  double worst_blockiness;

  int bytes;
  double summed_quality;
  double summed_weights;
  unsigned int tot_recode_hits;
  double worst_ssim;

  ImageStat fastssim;
  ImageStat psnrhvs;

  int b_calculate_blockiness;
  int b_calculate_consistency;

  double total_inconsistency;
  double worst_consistency;
  Ssimv *ssim_vars;
  Metrics metrics;
#endif
  int b_calculate_psnr;

  int droppable;

  int initial_width;
  int initial_height;
  int initial_mbs;  // Number of MBs in the full-size frame; to be used to
                    // normalize the firstpass stats. This will differ from the
                    // number of MBs in the current frame when the frame is
                    // scaled.

  int frame_flags;

  search_site_config ss_cfg;

  int mbmode_cost[BLOCK_SIZE_GROUPS][INTRA_MODES];
  int newmv_mode_cost[NEWMV_MODE_CONTEXTS][2];
  int zeromv_mode_cost[ZEROMV_MODE_CONTEXTS][2];
  int refmv_mode_cost[REFMV_MODE_CONTEXTS][2];
  int drl_mode_cost0[DRL_MODE_CONTEXTS][2];

  unsigned int inter_mode_cost[INTER_MODE_CONTEXTS][INTER_MODES];
#if CONFIG_EXT_INTER
  unsigned int inter_compound_mode_cost[INTER_MODE_CONTEXTS]
                                       [INTER_COMPOUND_MODES];
#if CONFIG_INTERINTRA
  unsigned int interintra_mode_cost[BLOCK_SIZE_GROUPS][INTERINTRA_MODES];
#endif  // CONFIG_INTERINTRA
#endif  // CONFIG_EXT_INTER
#if CONFIG_MOTION_VAR || CONFIG_WARPED_MOTION
  int motion_mode_cost[BLOCK_SIZES][MOTION_MODES];
#if CONFIG_MOTION_VAR && CONFIG_WARPED_MOTION
  int motion_mode_cost1[BLOCK_SIZES][2];
#endif  // CONFIG_MOTION_VAR && CONFIG_WARPED_MOTION
#endif  // CONFIG_MOTION_VAR || CONFIG_WARPED_MOTION
  int intra_uv_mode_cost[INTRA_MODES][INTRA_MODES];
  int y_mode_costs[INTRA_MODES][INTRA_MODES][INTRA_MODES];
  int switchable_interp_costs[SWITCHABLE_FILTER_CONTEXTS][SWITCHABLE_FILTERS];
#if CONFIG_EXT_PARTITION_TYPES
  int partition_cost[PARTITION_CONTEXTS + CONFIG_UNPOISON_PARTITION_CTX]
                    [EXT_PARTITION_TYPES];
#else
  int partition_cost[PARTITION_CONTEXTS + CONFIG_UNPOISON_PARTITION_CTX]
                    [PARTITION_TYPES];
#endif
#if CONFIG_PALETTE
  int palette_y_size_cost[PALETTE_BLOCK_SIZES][PALETTE_SIZES];
  int palette_uv_size_cost[PALETTE_BLOCK_SIZES][PALETTE_SIZES];
  int palette_y_color_cost[PALETTE_SIZES][PALETTE_COLOR_INDEX_CONTEXTS]
                          [PALETTE_COLORS];
  int palette_uv_color_cost[PALETTE_SIZES][PALETTE_COLOR_INDEX_CONTEXTS]
                           [PALETTE_COLORS];
#endif  // CONFIG_PALETTE
  int tx_size_cost[TX_SIZES - 1][TX_SIZE_CONTEXTS][TX_SIZES];
#if CONFIG_EXT_TX
  int inter_tx_type_costs[EXT_TX_SETS_INTER][EXT_TX_SIZES][TX_TYPES];
  int intra_tx_type_costs[EXT_TX_SETS_INTRA][EXT_TX_SIZES][INTRA_MODES]
                         [TX_TYPES];
#else
  int intra_tx_type_costs[EXT_TX_SIZES][TX_TYPES][TX_TYPES];
  int inter_tx_type_costs[EXT_TX_SIZES][TX_TYPES];
#endif  // CONFIG_EXT_TX
#if CONFIG_EXT_INTRA
#if CONFIG_INTRA_INTERP
  int intra_filter_cost[INTRA_FILTERS + 1][INTRA_FILTERS];
#endif  // CONFIG_INTRA_INTERP
#endif  // CONFIG_EXT_INTRA
#if CONFIG_LOOP_RESTORATION
  int switchable_restore_cost[RESTORE_SWITCHABLE_TYPES];
#endif  // CONFIG_LOOP_RESTORATION
#if CONFIG_GLOBAL_MOTION
  int gmtype_cost[TRANS_TYPES];
  int gmparams_cost[TOTAL_REFS_PER_FRAME];
#endif  // CONFIG_GLOBAL_MOTION

  int multi_arf_allowed;
  int multi_arf_enabled;
  int multi_arf_last_grp_enabled;

  TileDataEnc *tile_data;
  int allocated_tiles;  // Keep track of memory allocated for tiles.

  TOKENEXTRA *tile_tok[MAX_TILE_ROWS][MAX_TILE_COLS];
  unsigned int tok_count[MAX_TILE_ROWS][MAX_TILE_COLS];

  TileBufferEnc tile_buffers[MAX_TILE_ROWS][MAX_TILE_COLS];

  int resize_state;
  int resize_scale_num;
  int resize_scale_den;
  int resize_next_scale_num;
  int resize_next_scale_den;
  int resize_avg_qp;
  int resize_buffer_underflow;
  int resize_count;

#if CONFIG_FRAME_SUPERRES
  int superres_pending;
#endif  // CONFIG_FRAME_SUPERRES

  // VARIANCE_AQ segment map refresh
  int vaq_refresh;

  // Multi-threading
  int num_workers;
  AVxWorker *workers;
  struct EncWorkerData *tile_thr_data;
  AV1LfSync lf_row_sync;
#if CONFIG_ANS
  struct BufAnsCoder buf_ans;
#endif
#if CONFIG_EXT_REFS
  int refresh_frame_mask;
  int existing_fb_idx_to_show;
  int is_arf_filter_off[MAX_EXT_ARFS + 1];
  int num_extra_arfs;
  int arf_map[MAX_EXT_ARFS + 1];
#endif  // CONFIG_EXT_REFS
#if CONFIG_GLOBAL_MOTION
  int global_motion_search_done;
#endif
#if CONFIG_REFERENCE_BUFFER
  SequenceHeader seq_params;
#endif
#if CONFIG_LV_MAP
  tran_low_t *tcoeff_buf[MAX_MB_PLANE];
#endif
} AV1_COMP;

void av1_initialize_enc(void);

struct AV1_COMP *av1_create_compressor(AV1EncoderConfig *oxcf,
                                       BufferPool *const pool);
void av1_remove_compressor(AV1_COMP *cpi);

void av1_change_config(AV1_COMP *cpi, const AV1EncoderConfig *oxcf);

// receive a frames worth of data. caller can assume that a copy of this
// frame is made and not just a copy of the pointer..
int av1_receive_raw_frame(AV1_COMP *cpi, aom_enc_frame_flags_t frame_flags,
                          YV12_BUFFER_CONFIG *sd, int64_t time_stamp,
                          int64_t end_time_stamp);

int av1_get_compressed_data(AV1_COMP *cpi, unsigned int *frame_flags,
                            size_t *size, uint8_t *dest, int64_t *time_stamp,
                            int64_t *time_end, int flush);

int av1_get_preview_raw_frame(AV1_COMP *cpi, YV12_BUFFER_CONFIG *dest);

int av1_get_last_show_frame(AV1_COMP *cpi, YV12_BUFFER_CONFIG *frame);

int av1_use_as_reference(AV1_COMP *cpi, int ref_frame_flags);

void av1_update_reference(AV1_COMP *cpi, int ref_frame_flags);

int av1_copy_reference_enc(AV1_COMP *cpi, AOM_REFFRAME ref_frame_flag,
                           YV12_BUFFER_CONFIG *sd);

int av1_set_reference_enc(AV1_COMP *cpi, AOM_REFFRAME ref_frame_flag,
                          YV12_BUFFER_CONFIG *sd);

int av1_update_entropy(AV1_COMP *cpi, int update);

int av1_set_active_map(AV1_COMP *cpi, unsigned char *map, int rows, int cols);

int av1_get_active_map(AV1_COMP *cpi, unsigned char *map, int rows, int cols);

int av1_set_internal_size(AV1_COMP *cpi, AOM_SCALING horiz_mode,
                          AOM_SCALING vert_mode);

// Returns 1 if the assigned width or height was <= 0.
int av1_set_size_literal(AV1_COMP *cpi, int width, int height);

int av1_get_quantizer(struct AV1_COMP *cpi);

void av1_full_to_model_counts(av1_coeff_count_model *model_count,
                              av1_coeff_count *full_count);

static INLINE int frame_is_kf_gf_arf(const AV1_COMP *cpi) {
  return frame_is_intra_only(&cpi->common) || cpi->refresh_alt_ref_frame ||
         (cpi->refresh_golden_frame && !cpi->rc.is_src_frame_alt_ref);
}

static INLINE int get_ref_frame_map_idx(const AV1_COMP *cpi,
                                        MV_REFERENCE_FRAME ref_frame) {
#if CONFIG_EXT_REFS
  if (ref_frame >= LAST_FRAME && ref_frame <= LAST3_FRAME)
    return cpi->lst_fb_idxes[ref_frame - 1];
#else
  if (ref_frame == LAST_FRAME) return cpi->lst_fb_idx;
#endif  // CONFIG_EXT_REFS
  else if (ref_frame == GOLDEN_FRAME)
    return cpi->gld_fb_idx;
#if CONFIG_EXT_REFS
  else if (ref_frame == BWDREF_FRAME)
    return cpi->bwd_fb_idx;
#endif  // CONFIG_EXT_REFS
  else
    return cpi->alt_fb_idx;
}

static INLINE int get_ref_frame_buf_idx(const AV1_COMP *cpi,
                                        MV_REFERENCE_FRAME ref_frame) {
  const AV1_COMMON *const cm = &cpi->common;
  const int map_idx = get_ref_frame_map_idx(cpi, ref_frame);
  return (map_idx != INVALID_IDX) ? cm->ref_frame_map[map_idx] : INVALID_IDX;
}

static INLINE YV12_BUFFER_CONFIG *get_ref_frame_buffer(
    const AV1_COMP *cpi, MV_REFERENCE_FRAME ref_frame) {
  const AV1_COMMON *const cm = &cpi->common;
  const int buf_idx = get_ref_frame_buf_idx(cpi, ref_frame);
  return buf_idx != INVALID_IDX ? &cm->buffer_pool->frame_bufs[buf_idx].buf
                                : NULL;
}

static INLINE const YV12_BUFFER_CONFIG *get_upsampled_ref(
    const AV1_COMP *cpi, const MV_REFERENCE_FRAME ref_frame) {
  // Use up-sampled reference frames.
  const int buf_idx =
      cpi->upsampled_ref_idx[get_ref_frame_map_idx(cpi, ref_frame)];
  return &cpi->upsampled_ref_bufs[buf_idx].buf;
}

#if CONFIG_EXT_REFS || CONFIG_TEMPMV_SIGNALING
static INLINE int enc_is_ref_frame_buf(AV1_COMP *cpi, RefCntBuffer *frame_buf) {
  MV_REFERENCE_FRAME ref_frame;
  AV1_COMMON *const cm = &cpi->common;
  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    const int buf_idx = get_ref_frame_buf_idx(cpi, ref_frame);
    if (buf_idx == INVALID_IDX) continue;
    if (frame_buf == &cm->buffer_pool->frame_bufs[buf_idx]) break;
  }
  return (ref_frame <= ALTREF_FRAME);
}
#endif  // CONFIG_EXT_REFS

static INLINE unsigned int get_token_alloc(int mb_rows, int mb_cols) {
  // We assume 3 planes all at full resolution. We assume up to 1 token per
  // pixel, and then allow a head room of 1 EOSB token per 4x4 block per plane,
  // plus EOSB_TOKEN per plane.
  return mb_rows * mb_cols * (16 * 16 + 17) * 3;
}

// Get the allocated token size for a tile. It does the same calculation as in
// the frame token allocation.
static INLINE unsigned int allocated_tokens(TileInfo tile) {
#if CONFIG_CB4X4
  int tile_mb_rows = (tile.mi_row_end - tile.mi_row_start + 2) >> 2;
  int tile_mb_cols = (tile.mi_col_end - tile.mi_col_start + 2) >> 2;
#else
  int tile_mb_rows = (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
  int tile_mb_cols = (tile.mi_col_end - tile.mi_col_start + 1) >> 1;
#endif

  return get_token_alloc(tile_mb_rows, tile_mb_cols);
}

void av1_alloc_compressor_data(AV1_COMP *cpi);

void av1_scale_references(AV1_COMP *cpi);

void av1_update_reference_frames(AV1_COMP *cpi);

void av1_set_high_precision_mv(AV1_COMP *cpi, int allow_high_precision_mv);
#if CONFIG_TEMPMV_SIGNALING
void av1_set_temporal_mv_prediction(AV1_COMP *cpi, int allow_tempmv_prediction);
#endif

void av1_apply_encoding_flags(AV1_COMP *cpi, aom_enc_frame_flags_t flags);

static INLINE int is_altref_enabled(const AV1_COMP *const cpi) {
  return cpi->oxcf.lag_in_frames > 0 && cpi->oxcf.enable_auto_arf;
}

// TODO(zoeliu): To set up cpi->oxcf.enable_auto_brf
#if 0 && CONFIG_EXT_REFS
static INLINE int is_bwdref_enabled(const AV1_COMP *const cpi) {
  // NOTE(zoeliu): The enabling of bi-predictive frames depends on the use of
  //               alt_ref, and now will be off when the alt_ref interval is
  //               not sufficiently large.
  return is_altref_enabled(cpi) && cpi->oxcf.enable_auto_brf;
}
#endif  // CONFIG_EXT_REFS

static INLINE void set_ref_ptrs(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                MV_REFERENCE_FRAME ref0,
                                MV_REFERENCE_FRAME ref1) {
  xd->block_refs[0] =
      &cm->frame_refs[ref0 >= LAST_FRAME ? ref0 - LAST_FRAME : 0];
  xd->block_refs[1] =
      &cm->frame_refs[ref1 >= LAST_FRAME ? ref1 - LAST_FRAME : 0];
}

static INLINE int get_chessboard_index(int frame_index) {
  return frame_index & 0x1;
}

static INLINE int *cond_cost_list(const struct AV1_COMP *cpi, int *cost_list) {
  return cpi->sf.mv.subpel_search_method != SUBPEL_TREE ? cost_list : NULL;
}

void av1_new_framerate(AV1_COMP *cpi, double framerate);

#define LAYER_IDS_TO_IDX(sl, tl, num_tl) ((sl) * (num_tl) + (tl))

// Update up-sampled reference frame index.
static INLINE void uref_cnt_fb(EncRefCntBuffer *ubufs, int *uidx,
                               int new_uidx) {
  const int ref_index = *uidx;

  if (ref_index >= 0 && ubufs[ref_index].ref_count > 0)
    ubufs[ref_index].ref_count--;

  *uidx = new_uidx;
  ubufs[new_uidx].ref_count++;
}

// Returns 1 if a resize is pending and 0 otherwise.
static INLINE int av1_resize_pending(const struct AV1_COMP *cpi) {
  return cpi->resize_scale_num != cpi->resize_next_scale_num ||
         cpi->resize_scale_den != cpi->resize_next_scale_den;
}

// Returns 1 if a frame is unscaled and 0 otherwise.
static INLINE int av1_resize_unscaled(const struct AV1_COMP *cpi) {
  return cpi->resize_scale_num == cpi->resize_scale_den;
}

// Moves resizing to the next state. This is just setting the numerator and
// denominator to the next numerator and denominator, causing
// av1_resize_pending to subsequently return false.
static INLINE void av1_resize_step(struct AV1_COMP *cpi) {
  cpi->resize_scale_num = cpi->resize_next_scale_num;
  cpi->resize_scale_den = cpi->resize_next_scale_den;
}

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AV1_ENCODER_ENCODER_H_
