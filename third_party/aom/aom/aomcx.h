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
#ifndef AOM_AOMCX_H_
#define AOM_AOMCX_H_

/*!\defgroup aom_encoder AOMedia AOM/AV1 Encoder
 * \ingroup aom
 *
 * @{
 */
#include "./aom.h"
#include "./aom_encoder.h"

/*!\file
 * \brief Provides definitions for using AOM or AV1 encoder algorithm within the
 *        aom Codec Interface.
 */

#ifdef __cplusplus
extern "C" {
#endif

/*!\name Algorithm interface for AV1
 *
 * This interface provides the capability to encode raw AV1 streams.
 * @{
 */
extern aom_codec_iface_t aom_codec_av1_cx_algo;
extern aom_codec_iface_t *aom_codec_av1_cx(void);
/*!@} - end algorithm interface member group*/

/*
 * Algorithm Flags
 */

/*!\brief Don't reference the last frame
 *
 * When this flag is set, the encoder will not use the last frame as a
 * predictor. When not set, the encoder will choose whether to use the
 * last frame or not automatically.
 */
#define AOM_EFLAG_NO_REF_LAST (1 << 16)

/*!\brief Don't reference the golden frame
 *
 * When this flag is set, the encoder will not use the golden frame as a
 * predictor. When not set, the encoder will choose whether to use the
 * golden frame or not automatically.
 */
#define AOM_EFLAG_NO_REF_GF (1 << 17)

/*!\brief Don't reference the alternate reference frame
 *
 * When this flag is set, the encoder will not use the alt ref frame as a
 * predictor. When not set, the encoder will choose whether to use the
 * alt ref frame or not automatically.
 */
#define AOM_EFLAG_NO_REF_ARF (1 << 21)

/*!\brief Don't update the last frame
 *
 * When this flag is set, the encoder will not update the last frame with
 * the contents of the current frame.
 */
#define AOM_EFLAG_NO_UPD_LAST (1 << 18)

/*!\brief Don't update the golden frame
 *
 * When this flag is set, the encoder will not update the golden frame with
 * the contents of the current frame.
 */
#define AOM_EFLAG_NO_UPD_GF (1 << 22)

/*!\brief Don't update the alternate reference frame
 *
 * When this flag is set, the encoder will not update the alt ref frame with
 * the contents of the current frame.
 */
#define AOM_EFLAG_NO_UPD_ARF (1 << 23)

/*!\brief Force golden frame update
 *
 * When this flag is set, the encoder copy the contents of the current frame
 * to the golden frame buffer.
 */
#define AOM_EFLAG_FORCE_GF (1 << 19)

/*!\brief Force alternate reference frame update
 *
 * When this flag is set, the encoder copy the contents of the current frame
 * to the alternate reference frame buffer.
 */
#define AOM_EFLAG_FORCE_ARF (1 << 24)

/*!\brief Disable entropy update
 *
 * When this flag is set, the encoder will not update its internal entropy
 * model based on the entropy of this frame.
 */
#define AOM_EFLAG_NO_UPD_ENTROPY (1 << 20)

/*!\brief AVx encoder control functions
 *
 * This set of macros define the control functions available for AVx
 * encoder interface.
 *
 * \sa #aom_codec_control
 */
enum aome_enc_control_id {
  /*!\brief Codec control function to set which reference frame encoder can use.
   */
  AOME_USE_REFERENCE = 7,

  /*!\brief Codec control function to pass an ROI map to encoder.
   */
  AOME_SET_ROI_MAP = 8,

  /*!\brief Codec control function to pass an Active map to encoder.
   */
  AOME_SET_ACTIVEMAP,

  /*!\brief Codec control function to set encoder scaling mode.
   */
  AOME_SET_SCALEMODE = 11,

  /*!\brief Codec control function to set encoder internal speed settings.
   *
   * Changes in this value influences, among others, the encoder's selection
   * of motion estimation methods. Values greater than 0 will increase encoder
   * speed at the expense of quality.
   *
   * \note Valid range: 0..8
   */
  AOME_SET_CPUUSED = 13,

  /*!\brief Codec control function to enable automatic set and use alf frames.
   */
  AOME_SET_ENABLEAUTOALTREF,

  /*!\brief Codec control function to set sharpness.
   */
  AOME_SET_SHARPNESS = AOME_SET_ENABLEAUTOALTREF + 2,

  /*!\brief Codec control function to set the threshold for MBs treated static.
   */
  AOME_SET_STATIC_THRESHOLD,

  /*!\brief Codec control function to get last quantizer chosen by the encoder.
   *
   * Return value uses internal quantizer scale defined by the codec.
   */
  AOME_GET_LAST_QUANTIZER = AOME_SET_STATIC_THRESHOLD + 2,

  /*!\brief Codec control function to get last quantizer chosen by the encoder.
   *
   * Return value uses the 0..63 scale as used by the rc_*_quantizer config
   * parameters.
   */
  AOME_GET_LAST_QUANTIZER_64,

  /*!\brief Codec control function to set the max no of frames to create arf.
   */
  AOME_SET_ARNR_MAXFRAMES,

  /*!\brief Codec control function to set the filter strength for the arf.
   */
  AOME_SET_ARNR_STRENGTH,

  /*!\brief Codec control function to set visual tuning.
   */
  AOME_SET_TUNING = AOME_SET_ARNR_STRENGTH + 2,

  /*!\brief Codec control function to set constrained quality level.
   *
   * \attention For this value to be used aom_codec_enc_cfg_t::g_usage must be
   *            set to #AOM_CQ.
   * \note Valid range: 0..63
   */
  AOME_SET_CQ_LEVEL,

  /*!\brief Codec control function to set Max data rate for Intra frames.
   *
   * This value controls additional clamping on the maximum size of a
   * keyframe. It is expressed as a percentage of the average
   * per-frame bitrate, with the special (and default) value 0 meaning
   * unlimited, or no additional clamping beyond the codec's built-in
   * algorithm.
   *
   * For example, to allocate no more than 4.5 frames worth of bitrate
   * to a keyframe, set this to 450.
   */
  AOME_SET_MAX_INTRA_BITRATE_PCT,

  /*!\brief Codec control function to set max data rate for Inter frames.
   *
   * This value controls additional clamping on the maximum size of an
   * inter frame. It is expressed as a percentage of the average
   * per-frame bitrate, with the special (and default) value 0 meaning
   * unlimited, or no additional clamping beyond the codec's built-in
   * algorithm.
   *
   * For example, to allow no more than 4.5 frames worth of bitrate
   * to an inter frame, set this to 450.
   */
  AV1E_SET_MAX_INTER_BITRATE_PCT = AOME_SET_MAX_INTRA_BITRATE_PCT + 2,

  /*!\brief Boost percentage for Golden Frame in CBR mode.
   *
   * This value controls the amount of boost given to Golden Frame in
   * CBR mode. It is expressed as a percentage of the average
   * per-frame bitrate, with the special (and default) value 0 meaning
   * the feature is off, i.e., no golden frame boost in CBR mode and
   * average bitrate target is used.
   *
   * For example, to allow 100% more bits, i.e, 2X, in a golden frame
   * than average frame, set this to 100.
   */
  AV1E_SET_GF_CBR_BOOST_PCT,

  /*!\brief Codec control function to set lossless encoding mode.
   *
   * AV1 can operate in lossless encoding mode, in which the bitstream
   * produced will be able to decode and reconstruct a perfect copy of
   * input source. This control function provides a mean to switch encoder
   * into lossless coding mode(1) or normal coding mode(0) that may be lossy.
   *                          0 = lossy coding mode
   *                          1 = lossless coding mode
   *
   *  By default, encoder operates in normal coding mode (maybe lossy).
   */
  AV1E_SET_LOSSLESS = AV1E_SET_GF_CBR_BOOST_PCT + 2,

  /*!\brief Codec control function to set number of tile columns.
   *
   * In encoding and decoding, AV1 allows an input image frame be partitioned
   * into separated vertical tile columns, which can be encoded or decoded
   * independently. This enables easy implementation of parallel encoding and
   * decoding. This control requests the encoder to use column tiles in
   * encoding an input frame, with number of tile columns (in Log2 unit) as
   * the parameter:
   *             0 = 1 tile column
   *             1 = 2 tile columns
   *             2 = 4 tile columns
   *             .....
   *             n = 2**n tile columns
   * The requested tile columns will be capped by encoder based on image size
   * limitation (The minimum width of a tile column is 256 pixel, the maximum
   * is 4096).
   *
   * By default, the value is 0, i.e. one single column tile for entire image.
   */
  AV1E_SET_TILE_COLUMNS,

  /*!\brief Codec control function to set number of tile rows.
   *
   * In encoding and decoding, AV1 allows an input image frame be partitioned
   * into separated horizontal tile rows. Tile rows are encoded or decoded
   * sequentially. Even though encoding/decoding of later tile rows depends on
   * earlier ones, this allows the encoder to output data packets for tile rows
   * prior to completely processing all tile rows in a frame, thereby reducing
   * the latency in processing between input and output. The parameter
   * for this control describes the number of tile rows, which has a valid
   * range [0, 2]:
   *            0 = 1 tile row
   *            1 = 2 tile rows
   *            2 = 4 tile rows
   *
   * By default, the value is 0, i.e. one single row tile for entire image.
   */
  AV1E_SET_TILE_ROWS,

  /*!\brief Codec control function to enable frame parallel decoding feature.
   *
   * AV1 has a bitstream feature to reduce decoding dependency between frames
   * by turning off backward update of probability context used in encoding
   * and decoding. This allows staged parallel processing of more than one
   * video frames in the decoder. This control function provides a mean to
   * turn this feature on or off for bitstreams produced by encoder.
   *
   * By default, this feature is off.
   */
  AV1E_SET_FRAME_PARALLEL_DECODING,

  /*!\brief Codec control function to set adaptive quantization mode.
   *
   * AV1 has a segment based feature that allows encoder to adaptively change
   * quantization parameter for each segment within a frame to improve the
   * subjective quality. This control makes encoder operate in one of the
   * several AQ_modes supported.
   *
   * By default, encoder operates with AQ_Mode 0(adaptive quantization off).
   */
  AV1E_SET_AQ_MODE,

  /*!\brief Codec control function to enable/disable periodic Q boost.
   *
   * One AV1 encoder speed feature is to enable quality boost by lowering
   * frame level Q periodically. This control function provides a mean to
   * turn on/off this feature.
   *               0 = off
   *               1 = on
   *
   * By default, the encoder is allowed to use this feature for appropriate
   * encoding modes.
   */
  AV1E_SET_FRAME_PERIODIC_BOOST,

  /*!\brief Codec control function to set noise sensitivity.
   *
   *  0: off, 1: On(YOnly)
   */
  AV1E_SET_NOISE_SENSITIVITY,

  /*!\brief Codec control function to set content type.
   * \note Valid parameter range:
   *              AOM_CONTENT_DEFAULT = Regular video content (Default)
   *              AOM_CONTENT_SCREEN  = Screen capture content
   */
  AV1E_SET_TUNE_CONTENT,

  /*!\brief Codec control function to set color space info.
   * \note Valid ranges: 0..7, default is "UNKNOWN".
   *                     0 = UNKNOWN,
   *                     1 = BT_601
   *                     2 = BT_709
   *                     3 = SMPTE_170
   *                     4 = SMPTE_240
   *                     5 = BT_2020
   *                     6 = RESERVED
   *                     7 = SRGB
   */
  AV1E_SET_COLOR_SPACE,

  /*!\brief Codec control function to set minimum interval between GF/ARF frames
   *
   * By default the value is set as 4.
   */
  AV1E_SET_MIN_GF_INTERVAL,

  /*!\brief Codec control function to set minimum interval between GF/ARF frames
   *
   * By default the value is set as 16.
   */
  AV1E_SET_MAX_GF_INTERVAL,

  /*!\brief Codec control function to get an Active map back from the encoder.
   */
  AV1E_GET_ACTIVEMAP,

  /*!\brief Codec control function to set color range bit.
   * \note Valid ranges: 0..1, default is 0
   *                     0 = Limited range (16..235 or HBD equivalent)
   *                     1 = Full range (0..255 or HBD equivalent)
   */
  AV1E_SET_COLOR_RANGE,

  /*!\brief Codec control function to set intended rendering image size.
   *
   * By default, this is identical to the image size in pixels.
   */
  AV1E_SET_RENDER_SIZE,

  /*!\brief Codec control function to set target level.
   *
   * 255: off (default); 0: only keep level stats; 10: target for level 1.0;
   * 11: target for level 1.1; ... 62: target for level 6.2
   */
  AV1E_SET_TARGET_LEVEL,

  /*!\brief Codec control function to get bitstream level.
   */
  AV1E_GET_LEVEL,

  /*!\brief Codec control function to set intended superblock size.
   *
   * By default, the superblock size is determined separately for each
   * frame by the encoder.
   *
   * Experiment: EXT_PARTITION
   */
  AV1E_SET_SUPERBLOCK_SIZE,

  /*!\brief Codec control function to enable automatic set and use
   * bwd-pred frames.
   *
   * Experiment: EXT_REFS
   */
  AOME_SET_ENABLEAUTOBWDREF,

  /*!\brief Codec control function to encode with quantisation matrices.
   *
   * AOM can operate with default quantisation matrices dependent on
   * quantisation level and block type.
   *                          0 = do not use quantisation matrices
   *                          1 = use quantisation matrices
   *
   *  By default, the encoder operates without quantisation matrices.
   *
   * Experiment: AOM_QM
   */
  AV1E_SET_ENABLE_QM,

  /*!\brief Codec control function to set the min quant matrix flatness.
   *
   * AOM can operate with different ranges of quantisation matrices.
   * As quantisation levels increase, the matrices get flatter. This
   * control sets the minimum level of flatness from which the matrices
   * are determined.
   *
   *  By default, the encoder sets this minimum at half the available
   *  range.
   *
   * Experiment: AOM_QM
   */
  AV1E_SET_QM_MIN,

  /*!\brief Codec control function to set the max quant matrix flatness.
   *
   * AOM can operate with different ranges of quantisation matrices.
   * As quantisation levels increase, the matrices get flatter. This
   * control sets the maximum level of flatness possible.
   *
   * By default, the encoder sets this maximum at the top of the
   * available range.
   *
   * Experiment: AOM_QM
   */
  AV1E_SET_QM_MAX,

  /*!\brief Codec control function to set a maximum number of tile groups.
   *
   * This will set the maximum number of tile groups. This will be
   * overridden if an MTU size is set. The default value is 1.
   *
   * Experiment: TILE_GROUPS
   */
  AV1E_SET_NUM_TG,

  /*!\brief Codec control function to set an MTU size for a tile group.
   *
   * This will set the maximum number of bytes in a tile group. This can be
   * exceeded only if a single tile is larger than this amount.
   *
   * By default, the value is 0, in which case a fixed number of tile groups
   * is used.
   *
   * Experiment: TILE_GROUPS
   */
  AV1E_SET_MTU,

  /*!\brief Codec control function to set dependent_horz_tiles.
  *
  * In encoding and decoding, AV1 allows enabling dependent horizontal tile
  * The parameter for this control describes the value of this flag,
  * which has a valid range [0, 1]:
  *            0 = disable dependent horizontal tile
  *            1 = enable dependent horizontal tile,
  *
  * By default, the value is 0, i.e. disable dependent horizontal tile.
  */
  AV1E_SET_TILE_DEPENDENT_ROWS,

  /*!\brief Codec control function to set the number of symbols in an ANS data
   * window.
   *
   * The number of ANS symbols (both boolean and non-booleans alphabets) in an
   * ANS data window is set to 1 << value.
   *
   * \note Valid range: [8, 23]
   *
   * Experiment: ANS
   */
  AV1E_SET_ANS_WINDOW_SIZE_LOG2,

  /*!\brief Codec control function to set temporal mv prediction
  * enabling/disabling.
  *
  * This will enable or disable temporal mv predicton. The default value is 0.
  *
  * Experiment: TEMPMV_SIGNALING
  */
  AV1E_SET_DISABLE_TEMPMV,

  /*!\brief Codec control function to set loop_filter_across_tiles_enabled.
   *
   * In encoding and decoding, AV1 allows disabling loop filter across tile
   * boundary The parameter for this control describes the value of this flag,
   * which has a valid range [0, 1]:
   *            0 = disable loop filter across tile boundary
   *            1 = enable loop filter across tile boundary
   *
   * By default, the value is 1, i.e. enable loop filter across tile boundary.
   *
   * Experiment: LOOPFILTERING_ACROSS_TILES
   */
  AV1E_SET_TILE_LOOPFILTER,

  /*!\brief Codec control function to set the delta q mode
  *
  * AV1 has a segment based feature that allows encoder to adaptively change
  * quantization parameter for each segment within a frame to improve the
  * subjective quality. the delta q mode is added on top of segment based
  * feature, and allows control per 64x64 q and lf delta.This control makes
  * encoder operate in one of the several DELTA_Q_modes supported.
  *
  * By default, encoder operates with DELTAQ_Mode 0(deltaq signaling off).
  */
  AV1E_SET_DELTAQ_MODE,

  /*!\brief Codec control function to set the tile encoding mode to 0 or 1.
   *
   * 0 means that the tile encoding mode is TILE_NORMAL, and 1 means that the
   * tile encoding mode is TILE_VR.
   *
   * Experiment: EXT_TILE
   */
  AV1E_SET_TILE_ENCODING_MODE,

  /*!\brief Codec control function to enable the extreme motion vector unit test
   * in AV1. Please note that this is only used in motion vector unit test.
   *
   * 0 : off, 1 : MAX_EXTREME_MV, 2 : MIN_EXTREME_MV
   */
  AV1E_ENABLE_MOTION_VECTOR_UNIT_TEST,
};

/*!\brief aom 1-D scaling mode
 *
 * This set of constants define 1-D aom scaling modes
 */
typedef enum aom_scaling_mode_1d {
  AOME_NORMAL = 0,
  AOME_FOURFIVE = 1,
  AOME_THREEFIVE = 2,
  AOME_ONETWO = 3
} AOM_SCALING_MODE;

/*!\brief  aom region of interest map
 *
 * These defines the data structures for the region of interest map
 *
 */

typedef struct aom_roi_map {
  /*! An id between 0 and 3 for each 16x16 region within a frame. */
  unsigned char *roi_map;
  unsigned int rows; /**< Number of rows. */
  unsigned int cols; /**< Number of columns. */
  // TODO(paulwilkins): broken for AV1 which has 8 segments
  // q and loop filter deltas for each segment
  // (see MAX_MB_SEGMENTS)
  int delta_q[4];  /**< Quantizer deltas. */
  int delta_lf[4]; /**< Loop filter deltas. */
  /*! Static breakout threshold for each segment. */
  unsigned int static_threshold[4];
} aom_roi_map_t;

/*!\brief  aom active region map
 *
 * These defines the data structures for active region map
 *
 */

typedef struct aom_active_map {
  /*!\brief specify an on (1) or off (0) each 16x16 region within a frame */
  unsigned char *active_map;
  unsigned int rows; /**< number of rows */
  unsigned int cols; /**< number of cols */
} aom_active_map_t;

/*!\brief  aom image scaling mode
 *
 * This defines the data structure for image scaling mode
 *
 */
typedef struct aom_scaling_mode {
  AOM_SCALING_MODE h_scaling_mode; /**< horizontal scaling mode */
  AOM_SCALING_MODE v_scaling_mode; /**< vertical scaling mode   */
} aom_scaling_mode_t;

/*!brief AV1 encoder content type */
typedef enum {
  AOM_CONTENT_DEFAULT,
  AOM_CONTENT_SCREEN,
  AOM_CONTENT_INVALID
} aom_tune_content;

/*!\brief Model tuning parameters
 *
 * Changes the encoder to tune for certain types of input material.
 *
 */
typedef enum { AOM_TUNE_PSNR, AOM_TUNE_SSIM } aom_tune_metric;

/*!\cond */
/*!\brief Encoder control function parameter type
 *
 * Defines the data types that AOME/AV1E control functions take. Note that
 * additional common controls are defined in aom.h
 *
 */

AOM_CTRL_USE_TYPE_DEPRECATED(AOME_USE_REFERENCE, int)
#define AOM_CTRL_AOME_USE_REFERENCE
AOM_CTRL_USE_TYPE(AOME_SET_ROI_MAP, aom_roi_map_t *)
#define AOM_CTRL_AOME_SET_ROI_MAP
AOM_CTRL_USE_TYPE(AOME_SET_ACTIVEMAP, aom_active_map_t *)
#define AOM_CTRL_AOME_SET_ACTIVEMAP
AOM_CTRL_USE_TYPE(AOME_SET_SCALEMODE, aom_scaling_mode_t *)
#define AOM_CTRL_AOME_SET_SCALEMODE

AOM_CTRL_USE_TYPE(AOME_SET_CPUUSED, int)
#define AOM_CTRL_AOME_SET_CPUUSED
AOM_CTRL_USE_TYPE(AOME_SET_ENABLEAUTOALTREF, unsigned int)
#define AOM_CTRL_AOME_SET_ENABLEAUTOALTREF

AOM_CTRL_USE_TYPE(AOME_SET_ENABLEAUTOBWDREF, unsigned int)
#define AOM_CTRL_AOME_SET_ENABLEAUTOBWDREF

AOM_CTRL_USE_TYPE(AOME_SET_SHARPNESS, unsigned int)
#define AOM_CTRL_AOME_SET_SHARPNESS
AOM_CTRL_USE_TYPE(AOME_SET_STATIC_THRESHOLD, unsigned int)
#define AOM_CTRL_AOME_SET_STATIC_THRESHOLD

AOM_CTRL_USE_TYPE(AOME_SET_ARNR_MAXFRAMES, unsigned int)
#define AOM_CTRL_AOME_SET_ARNR_MAXFRAMES
AOM_CTRL_USE_TYPE(AOME_SET_ARNR_STRENGTH, unsigned int)
#define AOM_CTRL_AOME_SET_ARNR_STRENGTH
AOM_CTRL_USE_TYPE(AOME_SET_TUNING, int) /* aom_tune_metric */
#define AOM_CTRL_AOME_SET_TUNING
AOM_CTRL_USE_TYPE(AOME_SET_CQ_LEVEL, unsigned int)
#define AOM_CTRL_AOME_SET_CQ_LEVEL

AOM_CTRL_USE_TYPE(AV1E_SET_TILE_COLUMNS, int)
#define AOM_CTRL_AV1E_SET_TILE_COLUMNS
AOM_CTRL_USE_TYPE(AV1E_SET_TILE_ROWS, int)
#define AOM_CTRL_AV1E_SET_TILE_ROWS

AOM_CTRL_USE_TYPE(AV1E_SET_TILE_DEPENDENT_ROWS, int)
#define AOM_CTRL_AV1E_SET_TILE_DEPENDENT_ROWS

AOM_CTRL_USE_TYPE(AV1E_SET_TILE_LOOPFILTER, int)
#define AOM_CTRL_AV1E_SET_TILE_LOOPFILTER

AOM_CTRL_USE_TYPE(AOME_GET_LAST_QUANTIZER, int *)
#define AOM_CTRL_AOME_GET_LAST_QUANTIZER
AOM_CTRL_USE_TYPE(AOME_GET_LAST_QUANTIZER_64, int *)
#define AOM_CTRL_AOME_GET_LAST_QUANTIZER_64

AOM_CTRL_USE_TYPE(AOME_SET_MAX_INTRA_BITRATE_PCT, unsigned int)
#define AOM_CTRL_AOME_SET_MAX_INTRA_BITRATE_PCT
AOM_CTRL_USE_TYPE(AOME_SET_MAX_INTER_BITRATE_PCT, unsigned int)
#define AOM_CTRL_AOME_SET_MAX_INTER_BITRATE_PCT

AOM_CTRL_USE_TYPE(AV1E_SET_GF_CBR_BOOST_PCT, unsigned int)
#define AOM_CTRL_AV1E_SET_GF_CBR_BOOST_PCT

AOM_CTRL_USE_TYPE(AV1E_SET_LOSSLESS, unsigned int)
#define AOM_CTRL_AV1E_SET_LOSSLESS

AOM_CTRL_USE_TYPE(AV1E_SET_ENABLE_QM, unsigned int)
#define AOM_CTRL_AV1E_SET_ENABLE_QM

AOM_CTRL_USE_TYPE(AV1E_SET_QM_MIN, unsigned int)
#define AOM_CTRL_AV1E_SET_QM_MIN

AOM_CTRL_USE_TYPE(AV1E_SET_QM_MAX, unsigned int)
#define AOM_CTRL_AV1E_SET_QM_MAX

AOM_CTRL_USE_TYPE(AV1E_SET_NUM_TG, unsigned int)
#define AOM_CTRL_AV1E_SET_NUM_TG
AOM_CTRL_USE_TYPE(AV1E_SET_MTU, unsigned int)
#define AOM_CTRL_AV1E_SET_MTU

AOM_CTRL_USE_TYPE(AV1E_SET_DISABLE_TEMPMV, unsigned int)
#define AOM_CTRL_AV1E_SET_DISABLE_TEMPMV

AOM_CTRL_USE_TYPE(AV1E_SET_FRAME_PARALLEL_DECODING, unsigned int)
#define AOM_CTRL_AV1E_SET_FRAME_PARALLEL_DECODING

AOM_CTRL_USE_TYPE(AV1E_SET_AQ_MODE, unsigned int)
#define AOM_CTRL_AV1E_SET_AQ_MODE

AOM_CTRL_USE_TYPE(AV1E_SET_DELTAQ_MODE, unsigned int)
#define AOM_CTRL_AV1E_SET_DELTAQ_MODE

AOM_CTRL_USE_TYPE(AV1E_SET_FRAME_PERIODIC_BOOST, unsigned int)
#define AOM_CTRL_AV1E_SET_FRAME_PERIODIC_BOOST

AOM_CTRL_USE_TYPE(AV1E_SET_NOISE_SENSITIVITY, unsigned int)
#define AOM_CTRL_AV1E_SET_NOISE_SENSITIVITY

AOM_CTRL_USE_TYPE(AV1E_SET_TUNE_CONTENT, int) /* aom_tune_content */
#define AOM_CTRL_AV1E_SET_TUNE_CONTENT

AOM_CTRL_USE_TYPE(AV1E_SET_COLOR_SPACE, int)
#define AOM_CTRL_AV1E_SET_COLOR_SPACE

AOM_CTRL_USE_TYPE(AV1E_SET_MIN_GF_INTERVAL, unsigned int)
#define AOM_CTRL_AV1E_SET_MIN_GF_INTERVAL

AOM_CTRL_USE_TYPE(AV1E_SET_MAX_GF_INTERVAL, unsigned int)
#define AOM_CTRL_AV1E_SET_MAX_GF_INTERVAL

AOM_CTRL_USE_TYPE(AV1E_GET_ACTIVEMAP, aom_active_map_t *)
#define AOM_CTRL_AV1E_GET_ACTIVEMAP

AOM_CTRL_USE_TYPE(AV1E_SET_COLOR_RANGE, int)
#define AOM_CTRL_AV1E_SET_COLOR_RANGE

/*!\brief
 *
 * TODO(rbultje) : add support of the control in ffmpeg
 */
#define AOM_CTRL_AV1E_SET_RENDER_SIZE
AOM_CTRL_USE_TYPE(AV1E_SET_RENDER_SIZE, int *)

AOM_CTRL_USE_TYPE(AV1E_SET_SUPERBLOCK_SIZE, unsigned int)
#define AOM_CTRL_AV1E_SET_SUPERBLOCK_SIZE

AOM_CTRL_USE_TYPE(AV1E_SET_TARGET_LEVEL, unsigned int)
#define AOM_CTRL_AV1E_SET_TARGET_LEVEL

AOM_CTRL_USE_TYPE(AV1E_GET_LEVEL, int *)
#define AOM_CTRL_AV1E_GET_LEVEL

AOM_CTRL_USE_TYPE(AV1E_SET_ANS_WINDOW_SIZE_LOG2, unsigned int)
#define AOM_CTRL_AV1E_SET_ANS_WINDOW_SIZE_LOG2

AOM_CTRL_USE_TYPE(AV1E_SET_TILE_ENCODING_MODE, unsigned int)
#define AOM_CTRL_AV1E_SET_TILE_ENCODING_MODE

AOM_CTRL_USE_TYPE(AV1E_ENABLE_MOTION_VECTOR_UNIT_TEST, unsigned int)
#define AOM_CTRL_AV1E_ENABLE_MOTION_VECTOR_UNIT_TEST

/*!\endcond */
/*! @} - end defgroup aom_encoder */
#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AOMCX_H_
