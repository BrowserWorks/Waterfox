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
#ifndef AOM_AOM_ENCODER_H_
#define AOM_AOM_ENCODER_H_

/*!\defgroup encoder Encoder Algorithm Interface
 * \ingroup codec
 * This abstraction allows applications using this encoder to easily support
 * multiple video formats with minimal code duplication. This section describes
 * the interface common to all encoders.
 * @{
 */

/*!\file
 * \brief Describes the encoder algorithm interface to applications.
 *
 * This file describes the interface between an application and a
 * video encoder algorithm.
 *
 */
#ifdef __cplusplus
extern "C" {
#endif

#include "./aom_codec.h"

/*!\brief Current ABI version number
 *
 * \internal
 * If this file is altered in any way that changes the ABI, this value
 * must be bumped.  Examples include, but are not limited to, changing
 * types, removing or reassigning enums, adding/removing/rearranging
 * fields to structures
 */
#define AOM_ENCODER_ABI_VERSION \
  (5 + AOM_CODEC_ABI_VERSION) /**<\hideinitializer*/

/*! \brief Encoder capabilities bitfield
 *
 *  Each encoder advertises the capabilities it supports as part of its
 *  ::aom_codec_iface_t interface structure. Capabilities are extra
 *  interfaces or functionality, and are not required to be supported
 *  by an encoder.
 *
 *  The available flags are specified by AOM_CODEC_CAP_* defines.
 */
#define AOM_CODEC_CAP_PSNR 0x10000 /**< Can issue PSNR packets */

/*! Can output one partition at a time. Each partition is returned in its
 *  own AOM_CODEC_CX_FRAME_PKT, with the FRAME_IS_FRAGMENT flag set for
 *  every partition but the last. In this mode all frames are always
 *  returned partition by partition.
 */
#define AOM_CODEC_CAP_OUTPUT_PARTITION 0x20000

/*! Can support input images at greater than 8 bitdepth.
 */
#define AOM_CODEC_CAP_HIGHBITDEPTH 0x40000

/*! \brief Initialization-time Feature Enabling
 *
 *  Certain codec features must be known at initialization time, to allow
 *  for proper memory allocation.
 *
 *  The available flags are specified by AOM_CODEC_USE_* defines.
 */
#define AOM_CODEC_USE_PSNR 0x10000 /**< Calculate PSNR on each frame */
/*!\brief Make the encoder output one  partition at a time. */
#define AOM_CODEC_USE_OUTPUT_PARTITION 0x20000
#define AOM_CODEC_USE_HIGHBITDEPTH 0x40000 /**< Use high bitdepth */

/*!\brief Generic fixed size buffer structure
 *
 * This structure is able to hold a reference to any fixed size buffer.
 */
typedef struct aom_fixed_buf {
  void *buf;       /**< Pointer to the data */
  size_t sz;       /**< Length of the buffer, in chars */
} aom_fixed_buf_t; /**< alias for struct aom_fixed_buf */

/*!\brief Time Stamp Type
 *
 * An integer, which when multiplied by the stream's time base, provides
 * the absolute time of a sample.
 */
typedef int64_t aom_codec_pts_t;

/*!\brief Compressed Frame Flags
 *
 * This type represents a bitfield containing information about a compressed
 * frame that may be useful to an application. The most significant 16 bits
 * can be used by an algorithm to provide additional detail, for example to
 * support frame types that are codec specific (MPEG-1 D-frames for example)
 */
typedef uint32_t aom_codec_frame_flags_t;
#define AOM_FRAME_IS_KEY 0x1 /**< frame is the start of a GOP */
/*!\brief frame can be dropped without affecting the stream (no future frame
 * depends on this one) */
#define AOM_FRAME_IS_DROPPABLE 0x2
/*!\brief frame should be decoded but will not be shown */
#define AOM_FRAME_IS_INVISIBLE 0x4
/*!\brief this is a fragment of the encoded frame */
#define AOM_FRAME_IS_FRAGMENT 0x8

/*!\brief Error Resilient flags
 *
 * These flags define which error resilient features to enable in the
 * encoder. The flags are specified through the
 * aom_codec_enc_cfg::g_error_resilient variable.
 */
typedef uint32_t aom_codec_er_flags_t;
/*!\brief Improve resiliency against losses of whole frames */
#define AOM_ERROR_RESILIENT_DEFAULT 0x1
/*!\brief The frame partitions are independently decodable by the bool decoder,
 * meaning that partitions can be decoded even though earlier partitions have
 * been lost. Note that intra prediction is still done over the partition
 * boundary. */
#define AOM_ERROR_RESILIENT_PARTITIONS 0x2

/*!\brief Encoder output packet variants
 *
 * This enumeration lists the different kinds of data packets that can be
 * returned by calls to aom_codec_get_cx_data(). Algorithms \ref MAY
 * extend this list to provide additional functionality.
 */
enum aom_codec_cx_pkt_kind {
  AOM_CODEC_CX_FRAME_PKT,    /**< Compressed video frame */
  AOM_CODEC_STATS_PKT,       /**< Two-pass statistics for this frame */
  AOM_CODEC_FPMB_STATS_PKT,  /**< first pass mb statistics for this frame */
  AOM_CODEC_PSNR_PKT,        /**< PSNR statistics for this frame */
  AOM_CODEC_CUSTOM_PKT = 256 /**< Algorithm extensions  */
};

/*!\brief Encoder output packet
 *
 * This structure contains the different kinds of output data the encoder
 * may produce while compressing a frame.
 */
typedef struct aom_codec_cx_pkt {
  enum aom_codec_cx_pkt_kind kind; /**< packet variant */
  union {
    struct {
      void *buf; /**< compressed data buffer */
      size_t sz; /**< length of compressed data */
      /*!\brief time stamp to show frame (in timebase units) */
      aom_codec_pts_t pts;
      /*!\brief duration to show frame (in timebase units) */
      unsigned long duration;
      aom_codec_frame_flags_t flags; /**< flags for this frame */
      /*!\brief the partition id defines the decoding order of the partitions.
       * Only applicable when "output partition" mode is enabled. First
       * partition has id 0.*/
      int partition_id;
    } frame;                            /**< data for compressed frame packet */
    aom_fixed_buf_t twopass_stats;      /**< data for two-pass packet */
    aom_fixed_buf_t firstpass_mb_stats; /**< first pass mb packet */
    struct aom_psnr_pkt {
      unsigned int samples[4]; /**< Number of samples, total/y/u/v */
      uint64_t sse[4];         /**< sum squared error, total/y/u/v */
      double psnr[4];          /**< PSNR, total/y/u/v */
    } psnr;                    /**< data for PSNR packet */
    aom_fixed_buf_t raw;       /**< data for arbitrary packets */

    /* This packet size is fixed to allow codecs to extend this
     * interface without having to manage storage for raw packets,
     * i.e., if it's smaller than 128 bytes, you can store in the
     * packet list directly.
     */
    char pad[128 - sizeof(enum aom_codec_cx_pkt_kind)]; /**< fixed sz */
  } data;                                               /**< packet data */
} aom_codec_cx_pkt_t; /**< alias for struct aom_codec_cx_pkt */

/*!\brief Rational Number
 *
 * This structure holds a fractional value.
 */
typedef struct aom_rational {
  int num;        /**< fraction numerator */
  int den;        /**< fraction denominator */
} aom_rational_t; /**< alias for struct aom_rational */

/*!\brief Multi-pass Encoding Pass */
enum aom_enc_pass {
  AOM_RC_ONE_PASS,   /**< Single pass mode */
  AOM_RC_FIRST_PASS, /**< First pass of multi-pass mode */
  AOM_RC_LAST_PASS   /**< Final pass of multi-pass mode */
};

/*!\brief Rate control mode */
enum aom_rc_mode {
  AOM_VBR, /**< Variable Bit Rate (VBR) mode */
  AOM_CBR, /**< Constant Bit Rate (CBR) mode */
  AOM_CQ,  /**< Constrained Quality (CQ)  mode */
  AOM_Q,   /**< Constant Quality (Q) mode */
};

/*!\brief Keyframe placement mode.
 *
 * This enumeration determines whether keyframes are placed automatically by
 * the encoder or whether this behavior is disabled. Older releases of this
 * SDK were implemented such that AOM_KF_FIXED meant keyframes were disabled.
 * This name is confusing for this behavior, so the new symbols to be used
 * are AOM_KF_AUTO and AOM_KF_DISABLED.
 */
enum aom_kf_mode {
  AOM_KF_FIXED,       /**< deprecated, implies AOM_KF_DISABLED */
  AOM_KF_AUTO,        /**< Encoder determines optimal placement automatically */
  AOM_KF_DISABLED = 0 /**< Encoder does not place keyframes. */
};

/*!\brief Encoded Frame Flags
 *
 * This type indicates a bitfield to be passed to aom_codec_encode(), defining
 * per-frame boolean values. By convention, bits common to all codecs will be
 * named AOM_EFLAG_*, and bits specific to an algorithm will be named
 * /algo/_eflag_*. The lower order 16 bits are reserved for common use.
 */
typedef long aom_enc_frame_flags_t;
#define AOM_EFLAG_FORCE_KF (1 << 0) /**< Force this frame to be a keyframe */

/*!\brief Encoder configuration structure
 *
 * This structure contains the encoder settings that have common representations
 * across all codecs. This doesn't imply that all codecs support all features,
 * however.
 */
typedef struct aom_codec_enc_cfg {
  /*
   * generic settings (g)
   */

  /*!\brief Algorithm specific "usage" value
   *
   * Algorithms may define multiple values for usage, which may convey the
   * intent of how the application intends to use the stream. If this value
   * is non-zero, consult the documentation for the codec to determine its
   * meaning.
   */
  unsigned int g_usage;

  /*!\brief Maximum number of threads to use
   *
   * For multi-threaded implementations, use no more than this number of
   * threads. The codec may use fewer threads than allowed. The value
   * 0 is equivalent to the value 1.
   */
  unsigned int g_threads;

  /*!\brief Bitstream profile to use
   *
   * Some codecs support a notion of multiple bitstream profiles. Typically
   * this maps to a set of features that are turned on or off. Often the
   * profile to use is determined by the features of the intended decoder.
   * Consult the documentation for the codec to determine the valid values
   * for this parameter, or set to zero for a sane default.
   */
  unsigned int g_profile; /**< profile of bitstream to use */

  /*!\brief Width of the frame
   *
   * This value identifies the presentation resolution of the frame,
   * in pixels. Note that the frames passed as input to the encoder must
   * have this resolution. Frames will be presented by the decoder in this
   * resolution, independent of any spatial resampling the encoder may do.
   */
  unsigned int g_w;

  /*!\brief Height of the frame
   *
   * This value identifies the presentation resolution of the frame,
   * in pixels. Note that the frames passed as input to the encoder must
   * have this resolution. Frames will be presented by the decoder in this
   * resolution, independent of any spatial resampling the encoder may do.
   */
  unsigned int g_h;

  /*!\brief Bit-depth of the codec
   *
   * This value identifies the bit_depth of the codec,
   * Only certain bit-depths are supported as identified in the
   * aom_bit_depth_t enum.
   */
  aom_bit_depth_t g_bit_depth;

  /*!\brief Bit-depth of the input frames
   *
   * This value identifies the bit_depth of the input frames in bits.
   * Note that the frames passed as input to the encoder must have
   * this bit-depth.
   */
  unsigned int g_input_bit_depth;

  /*!\brief Stream timebase units
   *
   * Indicates the smallest interval of time, in seconds, used by the stream.
   * For fixed frame rate material, or variable frame rate material where
   * frames are timed at a multiple of a given clock (ex: video capture),
   * the \ref RECOMMENDED method is to set the timebase to the reciprocal
   * of the frame rate (ex: 1001/30000 for 29.970 Hz NTSC). This allows the
   * pts to correspond to the frame number, which can be handy. For
   * re-encoding video from containers with absolute time timestamps, the
   * \ref RECOMMENDED method is to set the timebase to that of the parent
   * container or multimedia framework (ex: 1/1000 for ms, as in FLV).
   */
  struct aom_rational g_timebase;

  /*!\brief Enable error resilient modes.
   *
   * The error resilient bitfield indicates to the encoder which features
   * it should enable to take measures for streaming over lossy or noisy
   * links.
   */
  aom_codec_er_flags_t g_error_resilient;

  /*!\brief Multi-pass Encoding Mode
   *
   * This value should be set to the current phase for multi-pass encoding.
   * For single pass, set to #AOM_RC_ONE_PASS.
   */
  enum aom_enc_pass g_pass;

  /*!\brief Allow lagged encoding
   *
   * If set, this value allows the encoder to consume a number of input
   * frames before producing output frames. This allows the encoder to
   * base decisions for the current frame on future frames. This does
   * increase the latency of the encoding pipeline, so it is not appropriate
   * in all situations (ex: realtime encoding).
   *
   * Note that this is a maximum value -- the encoder may produce frames
   * sooner than the given limit. Set this value to 0 to disable this
   * feature.
   */
  unsigned int g_lag_in_frames;

  /*
   * rate control settings (rc)
   */

  /*!\brief Temporal resampling configuration, if supported by the codec.
   *
   * Temporal resampling allows the codec to "drop" frames as a strategy to
   * meet its target data rate. This can cause temporal discontinuities in
   * the encoded video, which may appear as stuttering during playback. This
   * trade-off is often acceptable, but for many applications is not. It can
   * be disabled in these cases.
   *
   * Note that not all codecs support this feature. All aom AVx codecs do.
   * For other codecs, consult the documentation for that algorithm.
   *
   * This threshold is described as a percentage of the target data buffer.
   * When the data buffer falls below this percentage of fullness, a
   * dropped frame is indicated. Set the threshold to zero (0) to disable
   * this feature.
   */
  unsigned int rc_dropframe_thresh;

  /*!\brief Enable/disable spatial resampling, if supported by the codec.
   *
   * Spatial resampling allows the codec to compress a lower resolution
   * version of the frame, which is then upscaled by the encoder to the
   * correct presentation resolution. This increases visual quality at
   * low data rates, at the expense of CPU time on the encoder/decoder.
   */
  unsigned int rc_resize_allowed;

  /*!\brief Internal coded frame width.
   *
   * If spatial resampling is enabled this specifies the width of the
   * encoded frame.
   */
  unsigned int rc_scaled_width;

  /*!\brief Internal coded frame height.
   *
   * If spatial resampling is enabled this specifies the height of the
   * encoded frame.
   */
  unsigned int rc_scaled_height;

  /*!\brief Spatial resampling up watermark.
   *
   * This threshold is described as a percentage of the target data buffer.
   * When the data buffer rises above this percentage of fullness, the
   * encoder will step up to a higher resolution version of the frame.
   */
  unsigned int rc_resize_up_thresh;

  /*!\brief Spatial resampling down watermark.
   *
   * This threshold is described as a percentage of the target data buffer.
   * When the data buffer falls below this percentage of fullness, the
   * encoder will step down to a lower resolution version of the frame.
   */
  unsigned int rc_resize_down_thresh;

  /*!\brief Rate control algorithm to use.
   *
   * Indicates whether the end usage of this stream is to be streamed over
   * a bandwidth constrained link, indicating that Constant Bit Rate (CBR)
   * mode should be used, or whether it will be played back on a high
   * bandwidth link, as from a local disk, where higher variations in
   * bitrate are acceptable.
   */
  enum aom_rc_mode rc_end_usage;

  /*!\brief Two-pass stats buffer.
   *
   * A buffer containing all of the stats packets produced in the first
   * pass, concatenated.
   */
  aom_fixed_buf_t rc_twopass_stats_in;

  /*!\brief first pass mb stats buffer.
   *
   * A buffer containing all of the first pass mb stats packets produced
   * in the first pass, concatenated.
   */
  aom_fixed_buf_t rc_firstpass_mb_stats_in;

  /*!\brief Target data rate
   *
   * Target bandwidth to use for this stream, in kilobits per second.
   */
  unsigned int rc_target_bitrate;

  /*
   * quantizer settings
   */

  /*!\brief Minimum (Best Quality) Quantizer
   *
   * The quantizer is the most direct control over the quality of the
   * encoded image. The range of valid values for the quantizer is codec
   * specific. Consult the documentation for the codec to determine the
   * values to use. To determine the range programmatically, call
   * aom_codec_enc_config_default() with a usage value of 0.
   */
  unsigned int rc_min_quantizer;

  /*!\brief Maximum (Worst Quality) Quantizer
   *
   * The quantizer is the most direct control over the quality of the
   * encoded image. The range of valid values for the quantizer is codec
   * specific. Consult the documentation for the codec to determine the
   * values to use. To determine the range programmatically, call
   * aom_codec_enc_config_default() with a usage value of 0.
   */
  unsigned int rc_max_quantizer;

  /*
   * bitrate tolerance
   */

  /*!\brief Rate control adaptation undershoot control
   *
   * This value, expressed as a percentage of the target bitrate,
   * controls the maximum allowed adaptation speed of the codec.
   * This factor controls the maximum amount of bits that can
   * be subtracted from the target bitrate in order to compensate
   * for prior overshoot.
   *
   * Valid values in the range 0-1000.
   */
  unsigned int rc_undershoot_pct;

  /*!\brief Rate control adaptation overshoot control
   *
   * This value, expressed as a percentage of the target bitrate,
   * controls the maximum allowed adaptation speed of the codec.
   * This factor controls the maximum amount of bits that can
   * be added to the target bitrate in order to compensate for
   * prior undershoot.
   *
   * Valid values in the range 0-1000.
   */
  unsigned int rc_overshoot_pct;

  /*
   * decoder buffer model parameters
   */

  /*!\brief Decoder Buffer Size
   *
   * This value indicates the amount of data that may be buffered by the
   * decoding application. Note that this value is expressed in units of
   * time (milliseconds). For example, a value of 5000 indicates that the
   * client will buffer (at least) 5000ms worth of encoded data. Use the
   * target bitrate (#rc_target_bitrate) to convert to bits/bytes, if
   * necessary.
   */
  unsigned int rc_buf_sz;

  /*!\brief Decoder Buffer Initial Size
   *
   * This value indicates the amount of data that will be buffered by the
   * decoding application prior to beginning playback. This value is
   * expressed in units of time (milliseconds). Use the target bitrate
   * (#rc_target_bitrate) to convert to bits/bytes, if necessary.
   */
  unsigned int rc_buf_initial_sz;

  /*!\brief Decoder Buffer Optimal Size
   *
   * This value indicates the amount of data that the encoder should try
   * to maintain in the decoder's buffer. This value is expressed in units
   * of time (milliseconds). Use the target bitrate (#rc_target_bitrate)
   * to convert to bits/bytes, if necessary.
   */
  unsigned int rc_buf_optimal_sz;

  /*
   * 2 pass rate control parameters
   */

  /*!\brief Two-pass mode CBR/VBR bias
   *
   * Bias, expressed on a scale of 0 to 100, for determining target size
   * for the current frame. The value 0 indicates the optimal CBR mode
   * value should be used. The value 100 indicates the optimal VBR mode
   * value should be used. Values in between indicate which way the
   * encoder should "lean."
   */
  unsigned int rc_2pass_vbr_bias_pct;

  /*!\brief Two-pass mode per-GOP minimum bitrate
   *
   * This value, expressed as a percentage of the target bitrate, indicates
   * the minimum bitrate to be used for a single GOP (aka "section")
   */
  unsigned int rc_2pass_vbr_minsection_pct;

  /*!\brief Two-pass mode per-GOP maximum bitrate
   *
   * This value, expressed as a percentage of the target bitrate, indicates
   * the maximum bitrate to be used for a single GOP (aka "section")
   */
  unsigned int rc_2pass_vbr_maxsection_pct;

  /*
   * keyframing settings (kf)
   */

  /*!\brief Keyframe placement mode
   *
   * This value indicates whether the encoder should place keyframes at a
   * fixed interval, or determine the optimal placement automatically
   * (as governed by the #kf_min_dist and #kf_max_dist parameters)
   */
  enum aom_kf_mode kf_mode;

  /*!\brief Keyframe minimum interval
   *
   * This value, expressed as a number of frames, prevents the encoder from
   * placing a keyframe nearer than kf_min_dist to the previous keyframe. At
   * least kf_min_dist frames non-keyframes will be coded before the next
   * keyframe. Set kf_min_dist equal to kf_max_dist for a fixed interval.
   */
  unsigned int kf_min_dist;

  /*!\brief Keyframe maximum interval
   *
   * This value, expressed as a number of frames, forces the encoder to code
   * a keyframe if one has not been coded in the last kf_max_dist frames.
   * A value of 0 implies all frames will be keyframes. Set kf_min_dist
   * equal to kf_max_dist for a fixed interval.
   */
  unsigned int kf_max_dist;
} aom_codec_enc_cfg_t; /**< alias for struct aom_codec_enc_cfg */

/*!\brief Initialize an encoder instance
 *
 * Initializes a encoder context using the given interface. Applications
 * should call the aom_codec_enc_init convenience macro instead of this
 * function directly, to ensure that the ABI version number parameter
 * is properly initialized.
 *
 * If the library was configured with --disable-multithread, this call
 * is not thread safe and should be guarded with a lock if being used
 * in a multithreaded context.
 *
 * \param[in]    ctx     Pointer to this instance's context.
 * \param[in]    iface   Pointer to the algorithm interface to use.
 * \param[in]    cfg     Configuration to use, if known. May be NULL.
 * \param[in]    flags   Bitfield of AOM_CODEC_USE_* flags
 * \param[in]    ver     ABI version number. Must be set to
 *                       AOM_ENCODER_ABI_VERSION
 * \retval #AOM_CODEC_OK
 *     The decoder algorithm initialized.
 * \retval #AOM_CODEC_MEM_ERROR
 *     Memory allocation failed.
 */
aom_codec_err_t aom_codec_enc_init_ver(aom_codec_ctx_t *ctx,
                                       aom_codec_iface_t *iface,
                                       const aom_codec_enc_cfg_t *cfg,
                                       aom_codec_flags_t flags, int ver);

/*!\brief Convenience macro for aom_codec_enc_init_ver()
 *
 * Ensures the ABI version parameter is properly set.
 */
#define aom_codec_enc_init(ctx, iface, cfg, flags) \
  aom_codec_enc_init_ver(ctx, iface, cfg, flags, AOM_ENCODER_ABI_VERSION)

/*!\brief Initialize multi-encoder instance
 *
 * Initializes multi-encoder context using the given interface.
 * Applications should call the aom_codec_enc_init_multi convenience macro
 * instead of this function directly, to ensure that the ABI version number
 * parameter is properly initialized.
 *
 * \param[in]    ctx     Pointer to this instance's context.
 * \param[in]    iface   Pointer to the algorithm interface to use.
 * \param[in]    cfg     Configuration to use, if known. May be NULL.
 * \param[in]    num_enc Total number of encoders.
 * \param[in]    flags   Bitfield of AOM_CODEC_USE_* flags
 * \param[in]    dsf     Pointer to down-sampling factors.
 * \param[in]    ver     ABI version number. Must be set to
 *                       AOM_ENCODER_ABI_VERSION
 * \retval #AOM_CODEC_OK
 *     The decoder algorithm initialized.
 * \retval #AOM_CODEC_MEM_ERROR
 *     Memory allocation failed.
 */
aom_codec_err_t aom_codec_enc_init_multi_ver(
    aom_codec_ctx_t *ctx, aom_codec_iface_t *iface, aom_codec_enc_cfg_t *cfg,
    int num_enc, aom_codec_flags_t flags, aom_rational_t *dsf, int ver);

/*!\brief Convenience macro for aom_codec_enc_init_multi_ver()
 *
 * Ensures the ABI version parameter is properly set.
 */
#define aom_codec_enc_init_multi(ctx, iface, cfg, num_enc, flags, dsf) \
  aom_codec_enc_init_multi_ver(ctx, iface, cfg, num_enc, flags, dsf,   \
                               AOM_ENCODER_ABI_VERSION)

/*!\brief Get a default configuration
 *
 * Initializes a encoder configuration structure with default values. Supports
 * the notion of "usages" so that an algorithm may offer different default
 * settings depending on the user's intended goal. This function \ref SHOULD
 * be called by all applications to initialize the configuration structure
 * before specializing the configuration with application specific values.
 *
 * \param[in]    iface     Pointer to the algorithm interface to use.
 * \param[out]   cfg       Configuration buffer to populate.
 * \param[in]    reserved  Must set to 0.
 *
 * \retval #AOM_CODEC_OK
 *     The configuration was populated.
 * \retval #AOM_CODEC_INCAPABLE
 *     Interface is not an encoder interface.
 * \retval #AOM_CODEC_INVALID_PARAM
 *     A parameter was NULL, or the usage value was not recognized.
 */
aom_codec_err_t aom_codec_enc_config_default(aom_codec_iface_t *iface,
                                             aom_codec_enc_cfg_t *cfg,
                                             unsigned int reserved);

/*!\brief Set or change configuration
 *
 * Reconfigures an encoder instance according to the given configuration.
 *
 * \param[in]    ctx     Pointer to this instance's context
 * \param[in]    cfg     Configuration buffer to use
 *
 * \retval #AOM_CODEC_OK
 *     The configuration was populated.
 * \retval #AOM_CODEC_INCAPABLE
 *     Interface is not an encoder interface.
 * \retval #AOM_CODEC_INVALID_PARAM
 *     A parameter was NULL, or the usage value was not recognized.
 */
aom_codec_err_t aom_codec_enc_config_set(aom_codec_ctx_t *ctx,
                                         const aom_codec_enc_cfg_t *cfg);

/*!\brief Get global stream headers
 *
 * Retrieves a stream level global header packet, if supported by the codec.
 *
 * \param[in]    ctx     Pointer to this instance's context
 *
 * \retval NULL
 *     Encoder does not support global header
 * \retval Non-NULL
 *     Pointer to buffer containing global header packet
 */
aom_fixed_buf_t *aom_codec_get_global_headers(aom_codec_ctx_t *ctx);

/*!\brief deadline parameter analogous to  AVx GOOD QUALITY mode. */
#define AOM_DL_GOOD_QUALITY (1000000)
/*!\brief Encode a frame
 *
 * Encodes a video frame at the given "presentation time." The presentation
 * time stamp (PTS) \ref MUST be strictly increasing.
 *
 * The encoder supports the notion of a soft real-time deadline. Given a
 * non-zero value to the deadline parameter, the encoder will make a "best
 * effort" guarantee to  return before the given time slice expires. It is
 * implicit that limiting the available time to encode will degrade the
 * output quality. The encoder can be given an unlimited time to produce the
 * best possible frame by specifying a deadline of '0'. This deadline
 * supercedes the AVx notion of "best quality, good quality, realtime".
 * Applications that wish to map these former settings to the new deadline
 * based system can use the symbol #AOM_DL_GOOD_QUALITY.
 *
 * When the last frame has been passed to the encoder, this function should
 * continue to be called, with the img parameter set to NULL. This will
 * signal the end-of-stream condition to the encoder and allow it to encode
 * any held buffers. Encoding is complete when aom_codec_encode() is called
 * and aom_codec_get_cx_data() returns no data.
 *
 * \param[in]    ctx       Pointer to this instance's context
 * \param[in]    img       Image data to encode, NULL to flush.
 * \param[in]    pts       Presentation time stamp, in timebase units.
 * \param[in]    duration  Duration to show frame, in timebase units.
 * \param[in]    flags     Flags to use for encoding this frame.
 * \param[in]    deadline  Time to spend encoding, in microseconds. (0=infinite)
 *
 * \retval #AOM_CODEC_OK
 *     The configuration was populated.
 * \retval #AOM_CODEC_INCAPABLE
 *     Interface is not an encoder interface.
 * \retval #AOM_CODEC_INVALID_PARAM
 *     A parameter was NULL, the image format is unsupported, etc.
 */
aom_codec_err_t aom_codec_encode(aom_codec_ctx_t *ctx, const aom_image_t *img,
                                 aom_codec_pts_t pts, unsigned long duration,
                                 aom_enc_frame_flags_t flags,
                                 unsigned long deadline);

/*!\brief Set compressed data output buffer
 *
 * Sets the buffer that the codec should output the compressed data
 * into. This call effectively sets the buffer pointer returned in the
 * next AOM_CODEC_CX_FRAME_PKT packet. Subsequent packets will be
 * appended into this buffer. The buffer is preserved across frames,
 * so applications must periodically call this function after flushing
 * the accumulated compressed data to disk or to the network to reset
 * the pointer to the buffer's head.
 *
 * `pad_before` bytes will be skipped before writing the compressed
 * data, and `pad_after` bytes will be appended to the packet. The size
 * of the packet will be the sum of the size of the actual compressed
 * data, pad_before, and pad_after. The padding bytes will be preserved
 * (not overwritten).
 *
 * Note that calling this function does not guarantee that the returned
 * compressed data will be placed into the specified buffer. In the
 * event that the encoded data will not fit into the buffer provided,
 * the returned packet \ref MAY point to an internal buffer, as it would
 * if this call were never used. In this event, the output packet will
 * NOT have any padding, and the application must free space and copy it
 * to the proper place. This is of particular note in configurations
 * that may output multiple packets for a single encoded frame (e.g., lagged
 * encoding) or if the application does not reset the buffer periodically.
 *
 * Applications may restore the default behavior of the codec providing
 * the compressed data buffer by calling this function with a NULL
 * buffer.
 *
 * Applications \ref MUSTNOT call this function during iteration of
 * aom_codec_get_cx_data().
 *
 * \param[in]    ctx         Pointer to this instance's context
 * \param[in]    buf         Buffer to store compressed data into
 * \param[in]    pad_before  Bytes to skip before writing compressed data
 * \param[in]    pad_after   Bytes to skip after writing compressed data
 *
 * \retval #AOM_CODEC_OK
 *     The buffer was set successfully.
 * \retval #AOM_CODEC_INVALID_PARAM
 *     A parameter was NULL, the image format is unsupported, etc.
 */
aom_codec_err_t aom_codec_set_cx_data_buf(aom_codec_ctx_t *ctx,
                                          const aom_fixed_buf_t *buf,
                                          unsigned int pad_before,
                                          unsigned int pad_after);

/*!\brief Encoded data iterator
 *
 * Iterates over a list of data packets to be passed from the encoder to the
 * application. The different kinds of packets available are enumerated in
 * #aom_codec_cx_pkt_kind.
 *
 * #AOM_CODEC_CX_FRAME_PKT packets should be passed to the application's
 * muxer. Multiple compressed frames may be in the list.
 * #AOM_CODEC_STATS_PKT packets should be appended to a global buffer.
 *
 * The application \ref MUST silently ignore any packet kinds that it does
 * not recognize or support.
 *
 * The data buffers returned from this function are only guaranteed to be
 * valid until the application makes another call to any aom_codec_* function.
 *
 * \param[in]     ctx      Pointer to this instance's context
 * \param[in,out] iter     Iterator storage, initialized to NULL
 *
 * \return Returns a pointer to an output data packet (compressed frame data,
 *         two-pass statistics, etc.) or NULL to signal end-of-list.
 *
 */
const aom_codec_cx_pkt_t *aom_codec_get_cx_data(aom_codec_ctx_t *ctx,
                                                aom_codec_iter_t *iter);

/*!\brief Get Preview Frame
 *
 * Returns an image that can be used as a preview. Shows the image as it would
 * exist at the decompressor. The application \ref MUST NOT write into this
 * image buffer.
 *
 * \param[in]     ctx      Pointer to this instance's context
 *
 * \return Returns a pointer to a preview image, or NULL if no image is
 *         available.
 *
 */
const aom_image_t *aom_codec_get_preview_frame(aom_codec_ctx_t *ctx);

/*!@} - end defgroup encoder*/
#ifdef __cplusplus
}
#endif
#endif  // AOM_AOM_ENCODER_H_
