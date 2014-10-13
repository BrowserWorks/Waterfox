/*
 * GStreamer
 * Copyright (C) 2009 Carl-Anton Ingmarsson <ca.ingmarsson@gmail.com>
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

#ifndef __GST_MPEG4UTIL_H__
#define __GST_MPEG4UTIL_H__

#include <gst/gst.h>

G_BEGIN_DECLS

typedef struct _GstMpeg4VisualObjectSequence    GstMpeg4VisualObjectSequence;
typedef struct _GstMpeg4VisualObject            GstMpeg4VisualObject;
typedef struct _GstMpeg4VideoObjectLayer        GstMpeg4VideoObjectLayer;
typedef struct _GstMpeg4GroupOfVOP              GstMpeg4GroupOfVOP;
typedef struct _GstMpeg4VideoObjectPlane        GstMpeg4VideoObjectPlane;
typedef struct _GstMpeg4VideoSignalType         GstMpeg4VideoSignalType;
typedef struct _GstMpeg4VideoPlaneShortHdr      GstMpeg4VideoPlaneShortHdr;
typedef struct _GstMpeg4VideoPacketHdr          GstMpeg4VideoPacketHdr;

typedef struct _GstMpeg4SpriteTrajectory        GstMpeg4SpriteTrajectory;

typedef struct _GstMpeg4Packet                  GstMpeg4Packet;

/**
 * GstMpeg4StartCode:
 *
 * Defines the different startcodes present in the bitstream as
 * defined in: Table 6-3 — Start code values
 */
typedef enum
{
  GST_MPEG4_VIDEO_OBJ_FIRST      = 0x00,
  GST_MPEG4_VIDEO_OBJ_LAST       = 0x1f,
  GST_MPEG4_VIDEO_LAYER_FIRST    = 0x20,
  GST_MPEG4_VIDEO_LAYER_LAST     = 0x2f,
  GST_MPEG4_VISUAL_OBJ_SEQ_START = 0xb0,
  GST_MPEG4_VISUAL_OBJ_SEQ_END   = 0xb1,
  GST_MPEG4_USER_DATA            = 0xb2,
  GST_MPEG4_GROUP_OF_VOP         = 0xb3,
  GST_MPEG4_VIDEO_SESSION_ERR    = 0xb4,
  GST_MPEG4_VISUAL_OBJ           = 0xb5,
  GST_MPEG4_VIDEO_OBJ_PLANE      = 0xb6,
  GST_MPEG4_FBA                  = 0xba,
  GST_MPEG4_FBA_PLAN             = 0xbb,
  GST_MPEG4_MESH                 = 0xbc,
  GST_MPEG4_MESH_PLAN            = 0xbd,
  GST_MPEG4_STILL_TEXTURE_OBJ    = 0xbe,
  GST_MPEG4_TEXTURE_SPATIAL      = 0xbf,
  GST_MPEG4_TEXTURE_SNR_LAYER    = 0xc0,
  GST_MPEG4_TEXTURE_TILE         = 0xc1,
  GST_MPEG4_SHAPE_LAYER          = 0xc2,
  GST_MPEG4_STUFFING             = 0xc3,
  GST_MPEG4_SYSTEM_FIRST         = 0xc6,
  GST_MPEG4_SYSTEM_LAST          = 0xff,
  GST_MPEG4_RESYNC               = 0xfff
} GstMpeg4StartCode;

/**
 * GstMpeg4VisualObjectType:
 *
 * Defines the different visual object types as
 * defined in: Table 6-5 -- Meaning of visual object type
 */
typedef enum {
  GST_MPEG4_VIDEO_ID         = 0x01,
  GST_MPEG4_STILL_TEXTURE_ID = 0x02,
  GST_MPEG4_STILL_MESH_ID    = 0x03,
  GST_MPEG4_STILL_FBA_ID     = 0x04,
  GST_MPEG4_STILL_3D_MESH_ID = 0x05,
  /*... reserved */

} GstMpeg4VisualObjectType;

/**
 * GstMpeg4AspectRatioInfo:
 * @GST_MPEG4_SQUARE: 1:1 square
 * @GST_MPEG4_625_TYPE_4_3: 12:11 (625-type for 4:3 picture)
 * @GST_MPEG4_525_TYPE_4_3: 10:11 (525-type for 4:3 picture)
 * @GST_MPEG4_625_TYPE_16_9: 16:11 (625-type stretched for 16:9 picture)
 * @GST_MPEG4_525_TYPE_16_9: 40:33 (525-type stretched for 16:9 picture)
 * @GST_MPEG4_EXTENDED_PAR: Extended par
 *
 * Defines the different pixel aspect ratios as
 * defined in: Table 6-12 -- Meaning of pixel aspect ratio
 */
typedef enum {
  GST_MPEG4_SQUARE        = 0x01,
  GST_MPEG4_625_TYPE_4_3  = 0x02,
  GST_MPEG4_525_TYPE_4_3  = 0x03,
  GST_MPEG4_625_TYPE_16_9 = 0x04,
  GST_MPEG4_525_TYPE_16_9 = 0x05,
  GST_MPEG4_EXTENDED_PAR  = 0x0f,
} GstMpeg4AspectRatioInfo;

/**
 * GstMpeg4ParseResult:
 * @GST_MPEG4_PARSER_OK: The parsing went well
 * @GST_MPEG4_PARSER_BROKEN_DATA: The bitstream was broken
 * @GST_MPEG4_PARSER_NO_PACKET: There was no packet in the buffer
 * @GST_MPEG4_PARSER_NO_PACKET_END: There was no packet end in the buffer
 * @GST_MPEG4_PARSER_NO_PACKET_ERROR: An error accured durint the parsing
 *
 * Result type of any parsing function.
 */
typedef enum {
  GST_MPEG4_PARSER_OK,
  GST_MPEG4_PARSER_BROKEN_DATA,
  GST_MPEG4_PARSER_NO_PACKET,
  GST_MPEG4_PARSER_NO_PACKET_END,
  GST_MPEG4_PARSER_ERROR,
} GstMpeg4ParseResult;

/**
 * GstMpeg4VideoObjectCodingType:
 * @GST_MPEG4_I_VOP: intra-coded (I)
 * @GST_MPEG4_P_VOP: predictive-coded (P)
 * @GST_MPEG4_B_VOP: bidirectionally-predictive-coded (B)
 * @GST_MPEG4_S_VOP: sprite (S)
 *
 * The vop coding types as defined in:
 * Table 6-20 -- Meaning of vop_coding_type
 */
typedef enum {
  GST_MPEG4_I_VOP = 0x0,
  GST_MPEG4_P_VOP = 0x1,
  GST_MPEG4_B_VOP = 0x2,
  GST_MPEG4_S_VOP = 0x3
} GstMpeg4VideoObjectCodingType;

/**
 * GstMpeg4ChromaFormat:
 *
 * The chroma format in use as
 * defined in: Table 6-13 -- Meaning of chroma_format
 */
typedef enum {
  /* Other value are reserved */
  GST_MPEG4_CHROMA_4_2_0 = 0x01
} GstMpeg4ChromaFormat;

/**
 * GstMpeg4VideoObjectLayerShape:
 *
 * The different video object layer shapes as defined in:
 * Table 6-16 — Video Object Layer shape type
 */
typedef enum {
  GST_MPEG4_RECTANGULAR,
  GST_MPEG4_BINARY,
  GST_MPEG4_BINARY_ONLY,
  GST_MPEG4_GRAYSCALE
} GstMpeg4VideoObjectLayerShape;

/**
 * GstMpeg4SpriteEnable:
 *
 * Indicates the usage of static sprite coding
 * or global motion compensation (GMC) as defined in:
 * Table V2 - 2 -- Meaning of sprite_enable codewords
 */
typedef enum {
  GST_MPEG4_SPRITE_UNUSED,
  GST_MPEG4_SPRITE_STATIC,
  GST_MPEG4_SPRITE_GMG
} GstMpeg4SpriteEnable;

/**
 * GstMpeg4Profile:
 *
 * Different defined profiles as defined in:
 * 9- Profiles and levels
 *
 * It is computed using:
 * Table G.1 — FLC table for profile_and_level_indication
 */
typedef enum {
  GST_MPEG4_PROFILE_CORE,
  GST_MPEG4_PROFILE_MAIN,
  GST_MPEG4_PROFILE_N_BIT,
  GST_MPEG4_PROFILE_SIMPLE,
  GST_MPEG4_PROFILE_HYBRID,
  GST_MPEG4_PROFILE_RESERVED,
  GST_MPEG4_PROFILE_SIMPLE_FBA,
  GST_MPEG4_PROFILE_CORE_STUDIO,
  GST_MPEG4_PROFILE_SIMPLE_STUDIO,
  GST_MPEG4_PROFILE_CORE_SCALABLE,
  GST_MPEG4_PROFILE_ADVANCED_CORE,
  GST_MPEG4_PROFILE_ADVANCED_SIMPLE,
  GST_MPEG4_PROFILE_SIMPLE_SCALABLE,
  GST_MPEG4_PROFILE_SCALABLE_TEXTURE,
  GST_MPEG4_PROFILE_SIMPLE_FACE_ANIMATION,
  GST_MPEG4_PROFILE_BASIC_ANIMATED_TEXTURE,
  GST_MPEG4_PROFILE_ADVANCED_REALTIME_SIMPLE,
  GST_MPEG4_PROFILE_ADVANCED_SCALABLE_TEXTURE,
  GST_MPEG4_PROFILE_FINE_GRANULARITY_SCALABLE,
  GST_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY
} GstMpeg4Profile;

/**
 * GstMpeg4Level:
 *
 * Different levels as defined in:
 * 9- Profiles and levels
 *
 * It is computed using:
 * Table G.1 — FLC table for profile_and_level_indication
 */
typedef enum {
  GST_MPEG4_LEVEL0,
  GST_MPEG4_LEVEL1,
  GST_MPEG4_LEVEL2,
  GST_MPEG4_LEVEL3,
  GST_MPEG4_LEVEL3b,
  GST_MPEG4_LEVEL4,
  GST_MPEG4_LEVEL5,
  GST_MPEG4_LEVEL_RESERVED
} GstMpeg4Level;

/**
 * GstMpeg4VisualObjectSequence:
 *
 * The visual object sequence structure as defined in:
 * 6.2.2 Visual Object Sequence and Visual Object
 */
struct _GstMpeg4VisualObjectSequence {
  guint8 profile_and_level_indication;

  /* Computed according to:
   * Table G.1 — FLC table for profile_and_level_indication */
  GstMpeg4Level level;
  GstMpeg4Profile profile;
};

/**
 * GstMpeg4VisualObject:
 *
 * The visual object structure as defined in:
 * 6.2.2 Visual Object Sequence and Visual Object
 */
struct _GstMpeg4VisualObject {
  guint8 is_identifier;
  /* If is_identifier */
  guint8 verid;
  guint8 priority;

  GstMpeg4VisualObjectType type;
};

/**
 * GstMpeg4VideoSignalType:
 *
 * The video signal type structure as defined in:
 * 6.2.2 Visual Object Sequence and Visual Object.
 */
struct _GstMpeg4VideoSignalType {
  guint8 type;

  guint8 format;
  guint8 range;
  guint8 color_description;
  guint8 color_primaries;
  guint8 transfer_characteristics;
  guint8 matrix_coefficients;
};

/**
 * GstMpeg4VideoPlaneShortHdr:
 *
 * The video plane short header structure as defined in:
 * 6.2.5.2 Video Plane with Short Header
 */
struct _GstMpeg4VideoPlaneShortHdr {
  guint8 temporal_reference;
  guint8 split_screen_indicator;
  guint8 document_camera_indicator;
  guint8 full_picture_freeze_release;
  guint8 source_format;
  guint8 picture_coding_type;
  guint8 vop_quant;
  guint8 pei;
  guint8 psupp;

  /*  Gob layer specific fields */
  guint8 gob_header_empty;
  guint8 gob_number;
  guint8 gob_frame_id;
  guint8 quant_scale;

  /* Computed
   * If all the values are set to 0, then it is reserved
   * Table 6-25 -- Parameters Defined by source_format Field
   */
  guint16 vop_width;
  guint16 vop_height;
  guint16 num_macroblocks_in_gob;
  guint8 num_gobs_in_vop;

  /* The size in bits */
  guint size;
};

/**
 * GstMpeg4VideoObjectLayer:
 *
 * The video object layer structure as defined in:
 * 6.2.3 Video Object Layer
 */
struct _GstMpeg4VideoObjectLayer {
  guint8 random_accessible_vol;
  guint8 video_object_type_indication;

  guint8 is_object_layer_identifier;
  /* if is_object_layer_identifier */
  guint8 verid;
  guint8 priority;

  GstMpeg4AspectRatioInfo aspect_ratio_info;
  guint8 par_width;
  guint8 par_height;

  guint8 control_parameters;
  /* if control_parameters */
  GstMpeg4ChromaFormat chroma_format;
  guint8 low_delay;
  guint8 vbv_parameters;
  /* if vbv_parameters */
  guint16 first_half_bitrate;
  guint16 latter_half_bitrate;
  guint16 first_half_vbv_buffer_size;
  guint16 latter_half_vbv_buffer_size;
  guint16 first_half_vbv_occupancy;
  guint16 latter_half_vbv_occupancy;

  /* Computed values */
  guint32 bit_rate;
  guint32 vbv_buffer_size;

  GstMpeg4VideoObjectLayerShape shape;
  /* if shape == GST_MPEG4_GRAYSCALE && verid =! 1 */
  guint8 shape_extension;

  guint16 vop_time_increment_resolution;
  guint8 vop_time_increment_bits;
  guint8 fixed_vop_rate;
  /* if fixed_vop_rate */
  guint16 fixed_vop_time_increment;

  guint16 width;
  guint16 height;
  guint8 interlaced;
  guint8 obmc_disable;

  GstMpeg4SpriteEnable sprite_enable;
  /* if vol->sprite_enable == SPRITE_GMG or SPRITE_STATIC*/
  /* if vol->sprite_enable != GST_MPEG4_SPRITE_GMG */
  guint16 sprite_width;
  guint16 sprite_height;
  guint16 sprite_left_coordinate;
  guint16 sprite_top_coordinate;

  guint8 no_of_sprite_warping_points;
  guint8 sprite_warping_accuracy;
  guint8 sprite_brightness_change;
  /* if vol->sprite_enable != GST_MPEG4_SPRITE_GMG */
  guint8 low_latency_sprite_enable;

  /* if shape != GST_MPEG4_RECTANGULAR */
  guint8 sadct_disable;

  guint8 not_8_bit;

  /* if no_8_bit */
  guint8 quant_precision;
  guint8 bits_per_pixel;

  /* if shape == GRAYSCALE */
  guint8 no_gray_quant_update;
  guint8 composition_method;
  guint8 linear_composition;

  guint8 quant_type;
  /* if quant_type */
  guint8 load_intra_quant_mat;
  guint8 intra_quant_mat[64];
  guint8 load_non_intra_quant_mat;
  guint8 non_intra_quant_mat[64];

  guint8 quarter_sample;
  guint8 complexity_estimation_disable;
  guint8 resync_marker_disable;
  guint8 data_partitioned;
  guint8 reversible_vlc;
  guint8 newpred_enable;
  guint8 reduced_resolution_vop_enable;
  guint8 scalability;
  guint8 enhancement_type;

  GstMpeg4VideoPlaneShortHdr short_hdr;
};

/**
 * GstMpeg4SpriteTrajectory:
 *
 * The sprite trajectory structure as defined in:
 * 7.8.4 Sprite reference point decoding and
 * 6.2.5.4 Sprite coding
 */
struct _GstMpeg4SpriteTrajectory {
  guint16 vop_ref_points[63]; /* Defined as "du" in 6.2.5.4 */
  guint16 sprite_ref_points[63]; /* Defined as "dv" in 6.2.5.4 */
};

/**
 * GstMpeg4GroupOfVOP:
 *
 * The group of video object plane structure as defined in:
 * 6.2.4 Group of Video Object Plane
 */
struct _GstMpeg4GroupOfVOP {
  guint8 hours;
  guint8 minutes;
  guint8 seconds;

  guint8 closed;
  guint8 broken_link;
};

/**
 * GstMpeg4VideoObjectPlane:
 *
 * The Video object plane structure as defined in:
 * 6.2.5 Video Object Plane and Video Plane with Short Header
 */
struct _GstMpeg4VideoObjectPlane {
  GstMpeg4VideoObjectCodingType coding_type;

  guint8  modulo_time_base;
  guint16 time_increment;

  guint8  coded;
  /* if newpred_enable */
  guint16 id;
  guint8  id_for_prediction_indication;
  guint16 id_for_prediction;

  guint16 width;
  guint16 height;
  guint16 horizontal_mc_spatial_ref;
  guint16 vertical_mc_spatial_ref;

  guint8  rounding_type;
  /*if vol->shape != GST_MPEG4_RECTANGULAR */
  guint8  background_composition;
  guint8  change_conv_ratio_disable;
  guint8  constant_alpha;
  guint8  constant_alpha_value;
  guint8  reduced_resolution;

  guint8  intra_dc_vlc_thr;


  guint8  top_field_first;
  guint8  alternate_vertical_scan_flag;

  guint16 quant;

  guint8  fcode_forward;
  guint8  fcode_backward;

  guint8  shape_coding_type;
  guint8  load_backward_shape;
  guint8  ref_select_code;

  /* Computed macroblock informations */
  guint16 mb_height;
  guint16 mb_width;
  guint mb_num;

  /* The size of the header */
  guint    size;
};

/**
 * GstMpeg4VideoPacketHdr:
 * @size: Size of the header in bit.
 *
 * The video packet header structure as defined in:
 * 6.2.5.2 Video Plane with Short Header
 */
struct _GstMpeg4VideoPacketHdr {
  guint8  header_extension_code;
  guint16 macroblock_number;
  guint16 quant_scale;
  guint   size;
};

/**
 * GstMpeg4Packet:
 * @type: the type of the packet that start at @offset
 * @data: the data containing packet starting at @offset
 * @offset: offset of the start of the packet (without the 3 bytes startcode), but
 * including the #GstMpeg4StartCode byte.
 * @size: The size in bytes of the packet or %G_MAXUINT if the end wasn't found.
 * @marker_size: The size in bit of the resync marker.
 *
 * A structure that contains the type of a packet, its offset and its size
 */
struct _GstMpeg4Packet
{
  const guint8     *data;
  guint             offset;
  gsize             size;
  guint             marker_size;

  GstMpeg4StartCode type;
};

GstMpeg4ParseResult gst_h263_parse       (GstMpeg4Packet * packet,
                                          const guint8 * data, guint offset,
                                          gsize size);


GstMpeg4ParseResult gst_mpeg4_parse      (GstMpeg4Packet * packet,
                                          gboolean skip_user_data,
                                          GstMpeg4VideoObjectPlane *vop,
                                          const guint8 * data, guint offset,
                                          gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_video_object_plane       (GstMpeg4VideoObjectPlane *vop,
                                          GstMpeg4SpriteTrajectory *sprite_trajectory,
                                          GstMpeg4VideoObjectLayer *vol,
                                          const guint8 * data,
                                          gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_group_of_vop             (GstMpeg4GroupOfVOP *gov,
                                          const guint8 * data, gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_video_object_layer       (GstMpeg4VideoObjectLayer *vol,
                                          GstMpeg4VisualObject *vo,
                                          const guint8 * data, gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_visual_object            (GstMpeg4VisualObject *vo,
                                          GstMpeg4VideoSignalType *signal_type,
                                          const guint8 * data, gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_visual_object_sequence   (GstMpeg4VisualObjectSequence *vos,
                                          const guint8 * data, gsize size);
GstMpeg4ParseResult
gst_mpeg4_parse_video_plane_short_header (GstMpeg4VideoPlaneShortHdr * shorthdr,
                                          const guint8 * data, gsize size);

GstMpeg4ParseResult
gst_mpeg4_parse_video_packet_header      (GstMpeg4VideoPacketHdr * videopackethdr,
                                          GstMpeg4VideoObjectLayer * vol,
                                          GstMpeg4VideoObjectPlane * vop,
                                          GstMpeg4SpriteTrajectory * sprite_trajectory,
                                          const guint8 * data, gsize size);

G_END_DECLS

#endif /* __GST_MPEG4UTIL_H__ */
