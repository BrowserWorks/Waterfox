/*
 * gstvp8parser.h - VP8 parser
 *
 * Copyright (C) 2013-2014 Intel Corporation
 *   Author: Halley Zhao <halley.zhao@intel.com>
 *   Author: Gwenole Beauchesne <gwenole.beauchesne@intel.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifndef GST_VP8_PARSER_H
#define GST_VP8_PARSER_H

#include <gst/gst.h>

G_BEGIN_DECLS

typedef struct _GstVp8FrameHdr          GstVp8FrameHdr;
typedef struct _GstVp8QuantIndices      GstVp8QuantIndices;
typedef struct _GstVp8Segmentation      GstVp8Segmentation;
typedef struct _GstVp8MbLfAdjustments   GstVp8MbLfAdjustments;
typedef struct _GstVp8TokenProbs        GstVp8TokenProbs;
typedef struct _GstVp8MvProbs           GstVp8MvProbs;
typedef struct _GstVp8ModeProbs         GstVp8ModeProbs;
typedef struct _GstVp8Parser            GstVp8Parser;

/**
 * GstVp8ParserResult:
 * @GST_VP8_PARSER_OK: The parsing succeeded
 * @GST_VP8_PARSER_BROKEN_DATA: The data to parse is broken
 * @GST_VP8_PARSER_ERROR: An error accured when parsing
 *
 * The result of parsing VP8 data.
 */
typedef enum {
  GST_VP8_PARSER_OK,
  GST_VP8_PARSER_BROKEN_DATA,
  GST_VP8_PARSER_ERROR,
} GstVp8ParserResult;

/**
 * GstVpQuantIndices:
 * @y_ac_qi: indicates the dequantization table index used for the
 *   luma AC coefficients
 * @y_dc_delta: indicates the delta value that is added to the
 *   baseline index to obtain the luma DC coefficient dequantization
 *   index
 * @y2_dc_delta: indicates the delta value that is added to the
 *   baseline index to obtain the Y2 block DC coefficient dequantization
 *   index
 * @y2_ac_delta: indicates the delta value that is added to the
 *   baseline index to obtain the Y2 block AC coefficient dequantization
 *   index
 * @uv_dc_delta: indicates the delta value that is added to the
 *   baseline index to obtain the chroma DC coefficient dequantization
 *   index
 * @uv_ac_delta: indicates the delta value that is added to the
 *   baseline index to obtain the chroma AC coefficient dequantization
 *   index
 *
 * Dequantization indices.
 */ 
struct _GstVp8QuantIndices
{
  guint8 y_ac_qi;
  gint8 y_dc_delta;
  gint8 y2_dc_delta;
  gint8 y2_ac_delta;
  gint8 uv_dc_delta;
  gint8 uv_ac_delta;
};

/**
 * GstVp8Segmentation:
 * @segmentation_enabled: enables the segmentation feature for the
 *   current frame
 * @update_mb_segmentation_map: determines if the MB segmentation map
 *   is updated in the current frame
 * @update_segment_feature_data: indicates if the segment feature data
 *   is updated in the current frame
 * @segment_feature_mode: indicates the feature data update mode (0:
 *   delta, 1: absolute value)
 * @quantizer_update_value: indicates the update value for the segment
 *   quantizer
 * @lf_update_value: indicates the update value for the loop filter level
 * @segment_prob: indicates the branch probabilities of the segment_id
 *   decoding tree
 *
 * Segmentation feature data.
 */
struct _GstVp8Segmentation
{
  guint8 segmentation_enabled;
  guint8 update_mb_segmentation_map;
  guint8 update_segment_feature_data;

  /* if update_segment_feature_data == 1 */
  guint8 segment_feature_mode;
  gint8 quantizer_update_value[4];
  gint8 lf_update_value[4];

  /* if update_mb_segmentation_map == 1 */
  guint8 segment_prob[3];
};

/**
 * GstVp8MbLfAdjustments:
 * @loop_filter_adj_enable: indicates if the MB-level loop filter
 *   adjustment is on for the current frame
 * @mode_ref_lf_delta_update: indicates if the delta values used in an
 *   adjustment are updated in the current frame
 * @ref_frame_delta: indicates the adjustment delta value
 *   corresponding to a certain used reference frame
 * @mb_mode_delta: indicates the adjustment delta value corresponding
 *   to a certain MB prediction mode
 *
 * MB-level loop filter adjustments.
 */
struct _GstVp8MbLfAdjustments
{
  guint8 loop_filter_adj_enable;
  guint8 mode_ref_lf_delta_update;

  /* if mode_ref_lf_delta_update == 1 */
  gint8 ref_frame_delta[4];
  gint8 mb_mode_delta[4];
};

/**
 * GstVp8TokenProbs:
 * @prob: token probability
 *
 * Token probabilities, with cumulative updates applied.
 *
 * Each probability value in this matrix is live across frames, until
 * they are reset to their default values on key frame.
 */
struct _GstVp8TokenProbs
{
  guint8 prob[4][8][3][11];
};

/**
 * GstVp8MvProbs:
 * @prob: MV probability
 *
 * Probabilities used for motion vector decoding, with cumulative
 * updates applied.
 *
 * Each probability value in this matrix is live across frames, until
 * they are reset to their default values on key frame.
 */
struct _GstVp8MvProbs
{
  guint8 prob[2][19];
};

/**
 * GstVp8ModeProbs:
 * @y_prob: indicates the branch probabilities of the luma
 *   intra-prediction mode decoding tree
 * @uv_prob: indicates the branch probabilities of the chroma
 *   intra-prediction mode decoding tree
 *
 * Probabilities used for intra-prediction mode decoding tree.
 *
 * Each probability value in thie structure is live across frames,
 * until they are reset to their default values on key frame.
 */
struct _GstVp8ModeProbs
{
  guint8 y_prob[4];
  guint8 uv_prob[3];
};

/**
 * GstVp8FrameHdr:
 * @key_frame: indicates whether the frame is a key frame (1), or an
 *   inter frame (0)
 * @version: version number
 * @show_frame: indicates whether the frame is meant to be displayed (1),
 *   or not (0)
 * @data_chunk_size: the size in bytes of the Uncompressed Data Chunk
 * @first_part_size: the size in bytes of the first partition (control
 *   partition), excluding the uncompressed data chunk
 * @width: the frame width in pixels
 * @height: the frame height in pixels
 * @horiz_scale_code: horizontal scale code value
 * @vert_scale_code: vertical scale code value
 * @color_space: defines the YUV color space of the sequence
 * @clamping_type: specifies if the decoder is required to clamp the
 *   reconstructed pixel values
 * @filter_type: determines whether the normal or the simple loop
 *   filter is used
 * @loop_filter_level: controls the deblocking filter
 * @sharpness_level: controls the deblocking filter
 * @log2_nbr_of_dct_partitions: determines the number of separate
 *   partitions containing the DCT coefficients of the macroblocks
 * @partition_size: determines the size of each separate partition
 *   containing the DCT coefficients of the macroblocks, including the
 *   very last one (calculated size)
 * @quant_indices: dequantization indices (see #GstVp8QuantIndices)
 * @token_probs: token probabilities (see #GstVp8TokenProbs)
 * @mv_probs: probabilities used for motion vector decoding
 *   (see #GstVp8MvProbs)
 * @mode_probs: probabilities used for intra-prediction mode decoding
 *   tree (see #GstVp8ModeProbs)
 * @refresh_entropy_probs: determines whether updated token
 *   probabilities are used only for this frame or until further update
 * @refresh_golden_frame: determines if the current decoded frame
 *   refreshes the golden frame
 * @refresh_alternate_frame: determines if the current decoded frame
 *   refreshes the alternate reference frame
 * @copy_buffer_to_golden: determines if the golden reference is
 *   replaced by another reference
 * @copy_buffer_to_alternate: determines if the alternate reference is
 *   replaced by another reference
 * @sign_bias_golden: controls the sign of motion vectors when the
 *   golden frame is referenced
 * @sign_bias_alternate: controls the sign of motion vectors when the
 *   alternate frame is referenced
 * @refresh_last: determines if the current decoded frame refreshes
 *   the last frame reference buffer
 * @mb_no_skip_coeff: enables (0) or disables (1) the skipping of
 *   macroblocks containing no non-zero coefficients
 * @prob_skip_false: indicates the probability that the macroblock is
 *   not skipped
 * @prob_intra: indicates the probability of an intra macroblock
 * @prob_last: indicates the probability that the last reference frame
 *   is used for inter-prediction
 * @prob_gf: indicates the probability that the golden reference frame
 *   is used for inter-prediction
 * @rd_range: last range decoder value for "Range"
 * @rd_value: last range decoder value for "Value"
 * @rd_count: number of bits left in range decoder "Value" (@rd_value)
 * @header_size: the size in bits of the Frame Header, thus excluding
 *   any Uncompressed Data Chunk bytes
 *
 * Frame header.
 */
struct _GstVp8FrameHdr
{
  guint8 key_frame;
  guint8 version;
  guint8 show_frame;
  guint8 data_chunk_size;
  guint32 first_part_size;

  /* if key_frame == 1 */
  guint16 width;
  guint16 height;
  guint8 horiz_scale_code;
  guint8 vert_scale_code;
  guint8 color_space;
  guint8 clamping_type;

  guint8 filter_type;
  guint8 loop_filter_level;
  guint8 sharpness_level;
  guint8 log2_nbr_of_dct_partitions;
  guint partition_size[8];

  GstVp8QuantIndices quant_indices;
  GstVp8TokenProbs token_probs;
  GstVp8MvProbs mv_probs;
  GstVp8ModeProbs mode_probs;

  guint8 refresh_entropy_probs;
  guint8 refresh_last;
  /* if key_frame != 1 */
  guint8 refresh_golden_frame;
  guint8 refresh_alternate_frame;
  guint8 copy_buffer_to_golden;
  guint8 copy_buffer_to_alternate;
  guint8 sign_bias_golden;
  guint8 sign_bias_alternate;

  guint8 mb_no_skip_coeff;
  guint8 prob_skip_false;

  /* if key_frame != 1 */
  guint8 prob_intra;
  guint8 prob_last;
  guint8 prob_gf;

  /* Range decoder state */
  guint8 rd_range;
  guint8 rd_value;
  guint8 rd_count;

  /* Size of the Frame Header in bits */
  guint header_size;
};

/**
 * GstVp8Parser:
 * @segmentation: segmentation feature data
 * @mb_lf_adjust: MB-level loop filter adjustments
 * @token_probs: token probabilities
 * @mv_probs: probabilities used for motion vector decoding
 * @mode_probs: probabilities used for intra-prediction mode decoding tree.
 *
 * Parser context that needs to be live across frames. For instance
 * the probabilities tables stored in #GstVp8FrameHdr may depend on
 * the previous frames.
 */
struct _GstVp8Parser
{
  GstVp8Segmentation segmentation;
  GstVp8MbLfAdjustments mb_lf_adjust;
  GstVp8TokenProbs token_probs;
  GstVp8MvProbs mv_probs;
  GstVp8ModeProbs mode_probs;
};

void
gst_vp8_parser_init (GstVp8Parser * parser);

GstVp8ParserResult
gst_vp8_parser_parse_frame_header (GstVp8Parser * parser,
    GstVp8FrameHdr * frame_hdr, const guint8 * data, gsize size);

G_END_DECLS

#endif /* GST_VP8_PARSER_H */
