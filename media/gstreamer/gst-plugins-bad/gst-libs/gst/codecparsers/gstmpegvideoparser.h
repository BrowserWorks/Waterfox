/* Gstreamer
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
 *
 * From bad/sys/vdpau/mpeg/mpegutil.c:
 *   Copyright (C) <2007> Jan Schmidt <thaytan@mad.scientist.com>
 *   Copyright (C) <2009> Carl-Anton Ingmarsson <ca.ingmarsson@gmail.com>
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

#ifndef __GST_MPEG_VIDEO_UTILS_H__
#define __GST_MPEG_VIDEO_UTILS_H__

#ifndef GST_USE_UNSTABLE_API
#warning "The Mpeg video parsing library is unstable API and may change in future."
#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
#endif

#include <gst/gst.h>

G_BEGIN_DECLS

/**
 * GstMpegVideoPacketTypeCode:
 * @GST_MPEG_VIDEO_PACKET_PICTURE: Picture packet starting code
 * @GST_MPEG_VIDEO_PACKET_SLICE_MIN: Slice min packet starting code
 * @GST_MPEG_VIDEO_PACKET_SLICE_MAX: Slice max packet starting code
 * @GST_MPEG_VIDEO_PACKET_USER_DATA: User data packet starting code
 * @GST_MPEG_VIDEO_PACKET_SEQUENCE : Sequence packet starting code
 * @GST_MPEG_VIDEO_PACKET_EXTENSION: Extension packet starting code
 * @GST_MPEG_VIDEO_PACKET_SEQUENCE_END: Sequence end packet code
 * @GST_MPEG_VIDEO_PACKET_GOP: Group of Picture packet starting code
 * @GST_MPEG_VIDEO_PACKET_NONE: None packet code
 *
 * Indicates the type of MPEG packet
 */
typedef enum {
  GST_MPEG_VIDEO_PACKET_PICTURE      = 0x00,
  GST_MPEG_VIDEO_PACKET_SLICE_MIN    = 0x01,
  GST_MPEG_VIDEO_PACKET_SLICE_MAX    = 0xaf,
  GST_MPEG_VIDEO_PACKET_USER_DATA    = 0xb2,
  GST_MPEG_VIDEO_PACKET_SEQUENCE     = 0xb3,
  GST_MPEG_VIDEO_PACKET_EXTENSION    = 0xb5,
  GST_MPEG_VIDEO_PACKET_SEQUENCE_END = 0xb7,
  GST_MPEG_VIDEO_PACKET_GOP          = 0xb8,
  GST_MPEG_VIDEO_PACKET_NONE         = 0xff
} GstMpegVideoPacketTypeCode;

/**
 * GST_MPEG_VIDEO_PACKET_IS_SLICE:
 * @typecode: The MPEG video packet type code
 *
 * Checks whether a packet type code is a slice.
 *
 * Returns: %TRUE if the packet type code corresponds to a slice,
 * else %FALSE.
 */
#define GST_MPEG_VIDEO_PACKET_IS_SLICE(typecode) ((typecode) >= GST_MPEG_VIDEO_PACKET_SLICE_MIN && \
                                                  (typecode) <= GST_MPEG_VIDEO_PACKET_SLICE_MAX)

/**
 * GstMpegVideoPacketExtensionCode:
 * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE: Sequence extension code
 * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY: Sequence Display extension code
 * @GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX: Quantization Matrix extension code
 * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE: Sequence Scalable extension code
 * @GST_MPEG_VIDEO_PACKET_EXT_PICTURE: Picture coding extension
 *
 * Indicates what type of packets are in this block, some are mutually
 * exclusive though - ie, sequence packs are accumulated separately. GOP &
 * Picture may occur together or separately.
 */
typedef enum {
  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE          = 0x01,
  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY  = 0x02,
  GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX      = 0x03,
  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE = 0x05,
  GST_MPEG_VIDEO_PACKET_EXT_PICTURE           = 0x08
} GstMpegVideoPacketExtensionCode;

/**
 * GstMpegVideoSequenceScalableMode:
 * @GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING: Data partitioning
 * @GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL: Spatial Scalability
 * @GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SNR: SNR Scalability
 * @GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL: Temporal Scalability
 */
typedef enum {
  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING  = 0x00,
  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL            = 0x01,
  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SNR                = 0x02,
  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL           = 0x03
} GstMpegVideoSequenceScalableMode;

/**
 * GstMpegVideoLevel:
 * @GST_MPEG_VIDEO_LEVEL_LOW: Low level (LL)
 * @GST_MPEG_VIDEO_LEVEL_MAIN: Main level (ML)
 * @GST_MPEG_VIDEO_LEVEL_HIGH_1440: High 1440 level (H-14)
 * @GST_MPEG_VIDEO_LEVEL_HIGH: High level (HL)
 *
 * Mpeg-2 Levels.
 **/
typedef enum {
 GST_MPEG_VIDEO_LEVEL_HIGH      = 0x04,
 GST_MPEG_VIDEO_LEVEL_HIGH_1440 = 0x06,
 GST_MPEG_VIDEO_LEVEL_MAIN      = 0x08,
 GST_MPEG_VIDEO_LEVEL_LOW       = 0x0a
} GstMpegVideoLevel;

/**
 * GstMpegVideoProfile:
 * @GST_MPEG_VIDEO_PROFILE_422: 4:2:2 profile (422)
 * @GST_MPEG_VIDEO_PROFILE_HIGH: High profile (HP)
 * @GST_MPEG_VIDEO_PROFILE_SPATIALLY_SCALABLE: Spatially Scalable profile (Spatial)
 * @GST_MPEG_VIDEO_PROFILE_SNR_SCALABLE: SNR Scalable profile (SNR)
 * @GST_MPEG_VIDEO_PROFILE_MAIN: Main profile (MP)
 * @GST_MPEG_VIDEO_PROFILE_SIMPLE: Simple profile (SP)
 *
 * Mpeg-2 Profiles.
 **/
typedef enum {
  GST_MPEG_VIDEO_PROFILE_422                 = 0x00,
  GST_MPEG_VIDEO_PROFILE_HIGH                = 0x01,
  GST_MPEG_VIDEO_PROFILE_SPATIALLY_SCALABLE  = 0x02,
  GST_MPEG_VIDEO_PROFILE_SNR_SCALABLE        = 0x03,
  GST_MPEG_VIDEO_PROFILE_MAIN                = 0x04,
  GST_MPEG_VIDEO_PROFILE_SIMPLE              = 0x05
} GstMpegVideoProfile;

/**
 * GstMpegVideoChromaFormat:
 * @GST_MPEG_VIDEO_CHROMA_RES: Invalid (reserved for future use)
 * @GST_MPEG_VIDEO_CHROMA_420: 4:2:0 subsampling
 * @GST_MPEG_VIDEO_CHROMA_422: 4:2:2 subsampling
 * @GST_MPEG_VIDEO_CHROMA_444: 4:4:4 (non-subsampled)
 *
 * Chroma subsampling type.
 */
typedef enum {
  GST_MPEG_VIDEO_CHROMA_RES = 0x00,
  GST_MPEG_VIDEO_CHROMA_420 = 0x01,
  GST_MPEG_VIDEO_CHROMA_422 = 0x02,
  GST_MPEG_VIDEO_CHROMA_444 = 0x03,
} GstMpegVideoChromaFormat;

/**
 * GstMpegVideoPictureType:
 * @GST_MPEG_VIDEO_PICTURE_TYPE_I: Intra-coded (I) frame
 * @GST_MPEG_VIDEO_PICTURE_TYPE_P: Predictive-codec (P) frame
 * @GST_MPEG_VIDEO_PICTURE_TYPE_B: Bidirectionally predictive-coded (B) frame
 * @GST_MPEG_VIDEO_PICTURE_TYPE_D: D frame
 *
 * Picture type.
 */
typedef enum {
  GST_MPEG_VIDEO_PICTURE_TYPE_I = 0x01,
  GST_MPEG_VIDEO_PICTURE_TYPE_P = 0x02,
  GST_MPEG_VIDEO_PICTURE_TYPE_B = 0x03,
  GST_MPEG_VIDEO_PICTURE_TYPE_D = 0x04
} GstMpegVideoPictureType;

/**
 * GstMpegVideoPictureStructure:
 * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_TOP_FIELD: Top field
 * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_BOTTOM_FIELD: Bottom field
 * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_FRAME: Frame picture
 *
 * Picture structure type.
 */
typedef enum {
    GST_MPEG_VIDEO_PICTURE_STRUCTURE_TOP_FIELD    = 0x01,
    GST_MPEG_VIDEO_PICTURE_STRUCTURE_BOTTOM_FIELD = 0x02,
    GST_MPEG_VIDEO_PICTURE_STRUCTURE_FRAME        = 0x03
} GstMpegVideoPictureStructure;

typedef struct _GstMpegVideoSequenceHdr     GstMpegVideoSequenceHdr;
typedef struct _GstMpegVideoSequenceExt     GstMpegVideoSequenceExt;
typedef struct _GstMpegVideoSequenceDisplayExt GstMpegVideoSequenceDisplayExt;
typedef struct _GstMpegVideoSequenceScalableExt GstMpegVideoSequenceScalableExt;
typedef struct _GstMpegVideoPictureHdr      GstMpegVideoPictureHdr;
typedef struct _GstMpegVideoGop             GstMpegVideoGop;
typedef struct _GstMpegVideoPictureExt      GstMpegVideoPictureExt;
typedef struct _GstMpegVideoQuantMatrixExt  GstMpegVideoQuantMatrixExt;
typedef struct _GstMpegVideoSliceHdr        GstMpegVideoSliceHdr;
typedef struct _GstMpegVideoPacket          GstMpegVideoPacket;

/**
 * GstMpegVideoSequenceHdr:
 * @width: Width of each frame
 * @height: Height of each frame
 * @par_w: Calculated Pixel Aspect Ratio width
 * @par_h: Calculated Pixel Aspect Ratio height
 * @fps_n: Calculated Framrate nominator
 * @fps_d: Calculated Framerate denominator
 * @bitrate_value: Value of the bitrate as is in the stream (400bps unit)
 * @bitrate: the real bitrate of the Mpeg video stream in bits per second, 0 if VBR stream
 * @constrained_parameters_flag: %TRUE if this stream uses contrained parameters.
 * @intra_quantizer_matrix: intra-quantization table, in zigzag scan order
 * @non_intra_quantizer_matrix: non-intra quantization table, in zigzag scan order
 *
 * The Mpeg2 Video Sequence Header structure.
 */
struct _GstMpegVideoSequenceHdr
{
  guint16 width, height;
  guint8  aspect_ratio_info;
  guint8  frame_rate_code;
  guint32 bitrate_value;
  guint16 vbv_buffer_size_value;

  guint8  constrained_parameters_flag;

  guint8  intra_quantizer_matrix[64];
  guint8  non_intra_quantizer_matrix[64];

  /* Calculated values */
  guint   par_w, par_h;
  guint   fps_n, fps_d;
  guint   bitrate;
};

/**
 * GstMpegVideoSequenceExt:
 * @profile: mpeg2 decoder profile
 * @level: mpeg2 decoder level
 * @progressive: %TRUE if the frames are progressive %FALSE otherwise
 * @chroma_format: indicates the chrominance format
 * @horiz_size_ext: Horizontal size
 * @vert_size_ext: Vertical size
 * @bitrate_ext: The bitrate
 * @vbv_buffer_size_extension: VBV vuffer size
 * @low_delay: %TRUE if the sequence doesn't contain any B-pictures, %FALSE
 * otherwise
 * @fps_n_ext: Framerate nominator code
 * @fps_d_ext: Framerate denominator code
 *
 * The Mpeg2 Video Sequence Extension structure.
 **/
struct _GstMpegVideoSequenceExt
{
  /* mpeg2 decoder profile */
  guint8 profile;
  /* mpeg2 decoder level */
  guint8 level;

  guint8 progressive;
  guint8 chroma_format;

  guint8 horiz_size_ext, vert_size_ext;

  guint16 bitrate_ext;
  guint8 vbv_buffer_size_extension;
  guint8 low_delay;
  guint8 fps_n_ext, fps_d_ext;

};

/**
 * GstMpegVideoSequenceDisplayExt:
 * @profile: mpeg2 decoder profil

 */
struct _GstMpegVideoSequenceDisplayExt
{
  guint8 video_format;
  guint8 colour_description_flag;

  /* if colour_description_flag: */
    guint8 colour_primaries;
    guint8 transfer_characteristics;
    guint8 matrix_coefficients;

  guint16 display_horizontal_size;
  guint16 display_vertical_size;
};

/**
 * GstMpegVideoSequenceScalableExt:
 * @scalable_mode:
 * @layer_id:
 * @lower_layer_prediction_horizontal_size:
 * @lower_layer_prediction_vertical_size:
 * @horizontal_subsampling_factor_m:
 * @horizontal_subsampling_factor_n:
 * @vertical_subsampling_factor_m:
 * @vertical_subsampling_factor_n:
 * @picture_mux_enable:
 * @mux_to_progressive_sequence:
 * @picture_mux_order:
 * @picture_mux_factor:
 *
 * The Sequence Scalable Extension structure.
 *
 * Since: 1.2
 */
struct _GstMpegVideoSequenceScalableExt
{
  guint8 scalable_mode;
  guint8 layer_id;

  /* if spatial scalability */
  guint16 lower_layer_prediction_horizontal_size;
  guint16 lower_layer_prediction_vertical_size;
  guint8 horizontal_subsampling_factor_m;
  guint8 horizontal_subsampling_factor_n;
  guint8 vertical_subsampling_factor_m;
  guint8 vertical_subsampling_factor_n;

  /* if temporal scalability */
  guint8 picture_mux_enable;
  guint8 mux_to_progressive_sequence;
  guint8 picture_mux_order;
  guint8 picture_mux_factor;
};

/**
 * GstMpegVideoQuantMatrixExt:
 * @load_intra_quantiser_matrix:
 * @intra_quantiser_matrix:
 * @load_non_intra_quantiser_matrix:
 * @non_intra_quantiser_matrix:
 * @load_chroma_intra_quantiser_matrix:
 * @chroma_intra_quantiser_matrix:
 * @load_chroma_non_intra_quantiser_matrix:
 * @chroma_non_intra_quantiser_matrix:
 *
 * The Quant Matrix Extension structure that exposes quantization
 * matrices in zigzag scan order. i.e. the original encoded scan
 * order.
 */
struct _GstMpegVideoQuantMatrixExt
{
 guint8 load_intra_quantiser_matrix;
 guint8 intra_quantiser_matrix[64];
 guint8 load_non_intra_quantiser_matrix;
 guint8 non_intra_quantiser_matrix[64];
 guint8 load_chroma_intra_quantiser_matrix;
 guint8 chroma_intra_quantiser_matrix[64];
 guint8 load_chroma_non_intra_quantiser_matrix;
 guint8 chroma_non_intra_quantiser_matrix[64];
};

/**
 * GstMpegVideoPictureHdr:
 * @tsn: Temporal Sequence Number
 * @pic_type: Type of the frame
 * @full_pel_forward_vector: the full pel forward flag of
 *  the frame: 0 or 1.
 * @full_pel_backward_vector: the full pel backward flag
 *  of the frame: 0 or 1.
 * @f_code: F code
 *
 * The Mpeg2 Video Picture Header structure.
 */
struct _GstMpegVideoPictureHdr
{
  guint16 tsn;
  guint8 pic_type;

  guint8 full_pel_forward_vector, full_pel_backward_vector;

  guint8 f_code[2][2];
};

/**
 * GstMpegVideoPictureExt:
 * @intra_dc_precision: Intra DC precision
 * @picture_structure: Structure of the picture
 * @top_field_first: Top field first
 * @frame_pred_frame_dct: Frame
 * @concealment_motion_vectors: Concealment Motion Vectors
 * @q_scale_type: Q Scale Type
 * @intra_vlc_format: Intra Vlc Format
 * @alternate_scan: Alternate Scan
 * @repeat_first_field: Repeat First Field
 * @chroma_420_type: Chroma 420 Type
 * @progressive_frame: %TRUE if the frame is progressive %FALSE otherwize
 *
 * The Mpeg2 Video Picture Extension structure.
 */
struct _GstMpegVideoPictureExt
{
  guint8 f_code[2][2];

  guint8 intra_dc_precision;
  guint8 picture_structure;
  guint8 top_field_first;
  guint8 frame_pred_frame_dct;
  guint8 concealment_motion_vectors;
  guint8 q_scale_type;
  guint8 intra_vlc_format;
  guint8 alternate_scan;
  guint8 repeat_first_field;
  guint8 chroma_420_type;
  guint8 progressive_frame;
  guint8 composite_display;
  guint8 v_axis;
  guint8 field_sequence;
  guint8 sub_carrier;
  guint8 burst_amplitude;
  guint8 sub_carrier_phase;
};

/**
 * GstMpegVideoGop:
 * @drop_frame_flag: Drop Frame Flag
 * @hour: Hour (0-23)
 * @minute: Minute (O-59)
 * @second: Second (0-59)
 * @frame: Frame (0-59)
 * @closed_gop: Closed Gop
 * @broken_link: Broken link
 *
 * The Mpeg Video Group of Picture structure.
 */
struct _GstMpegVideoGop
{
  guint8 drop_frame_flag;

  guint8 hour, minute, second, frame;

  guint8 closed_gop;
  guint8 broken_link;
};

/**
 * GstMpegVideoSliceHdr:
 * @slice_vertical_position_extension: Extension to slice_vertical_position
 * @priority_breakpoint: Point where the bitstream shall be partitioned
 * @quantiser_scale_code: Quantiser value (range: 1-31)
 * @intra_slice: Equal to one if all the macroblocks are intra macro blocks.
 * @slice_picture_id: Intended to aid recovery on severe bursts of
 *   errors for certain types of applications
 *
 * The Mpeg2 Video Slice Header structure.
 *
 * Since: 1.2
 */
struct _GstMpegVideoSliceHdr
{
  guint8 priority_breakpoint;
  guint8 quantiser_scale_code;
  guint8 intra_slice;
  guint8 slice_picture_id;

  /* Calculated values */
  guint header_size;            /* slice_header size in bits */
  gint mb_row;                  /* macroblock row */
  gint mb_column;               /* macroblock column */
};

/**
 * GstMpegVideoPacket:
 * @type: the type of the packet that start at @offset, as a #GstMpegVideoPacketTypeCode
 * @data: the data containing the packet starting at @offset
 * @offset: the offset of the packet start in bytes from @data. This is the
 *     start of the packet itself without the sync code
 * @size: The size in bytes of the packet or -1 if the end wasn't found. This
 *     is the size of the packet itself without the sync code
 *
 * A structure that contains the type of a packet, its offset and its size
 */
struct _GstMpegVideoPacket
{
  const guint8 *data;
  guint8 type;
  guint  offset;
  gint   size;
};

gboolean gst_mpeg_video_parse                         (GstMpegVideoPacket * packet,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_packet_parse_sequence_header    (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoSequenceHdr * seqhdr);

gboolean gst_mpeg_video_packet_parse_sequence_extension (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoSequenceExt * seqext);

gboolean gst_mpeg_video_packet_parse_sequence_display_extension (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoSequenceDisplayExt * seqdisplayext);

gboolean gst_mpeg_video_packet_parse_sequence_scalable_extension (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoSequenceScalableExt * seqscaleext);

gboolean gst_mpeg_video_packet_parse_picture_header     (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoPictureHdr* pichdr);

gboolean gst_mpeg_video_packet_parse_picture_extension  (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoPictureExt *picext);

gboolean gst_mpeg_video_packet_parse_gop                (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoGop * gop);

gboolean gst_mpeg_video_packet_parse_slice_header       (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoSliceHdr * slice_hdr,
                                                         GstMpegVideoSequenceHdr * seq_hdr,
                                                         GstMpegVideoSequenceScalableExt * seqscaleext);

gboolean gst_mpeg_video_packet_parse_quant_matrix_extension (const GstMpegVideoPacket * packet,
                                                         GstMpegVideoQuantMatrixExt * quant);

/* seqext and displayext may be NULL if not received */
gboolean gst_mpeg_video_finalise_mpeg2_sequence_header (GstMpegVideoSequenceHdr *hdr,
   GstMpegVideoSequenceExt *seqext, GstMpegVideoSequenceDisplayExt *displayext);

#ifndef GST_DISABLE_DEPRECATED
gboolean gst_mpeg_video_parse_picture_header          (GstMpegVideoPictureHdr* hdr,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_picture_extension       (GstMpegVideoPictureExt *ext,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_gop                     (GstMpegVideoGop * gop,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_sequence_header         (GstMpegVideoSequenceHdr * seqhdr,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_sequence_extension      (GstMpegVideoSequenceExt * seqext,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt * seqdisplayext,
                                                       const guint8 * data, gsize size, guint offset);

gboolean gst_mpeg_video_parse_quant_matrix_extension  (GstMpegVideoQuantMatrixExt * quant,
                                                       const guint8 * data, gsize size, guint offset);
#endif

void     gst_mpeg_video_quant_matrix_get_raster_from_zigzag (guint8 out_quant[64],
                                                             const guint8 quant[64]);

void     gst_mpeg_video_quant_matrix_get_zigzag_from_raster (guint8 out_quant[64],
                                                             const guint8 quant[64]);

G_END_DECLS

#endif
