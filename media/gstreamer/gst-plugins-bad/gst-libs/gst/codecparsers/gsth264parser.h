/* Gstreamer
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
 *
 * Some bits C-c,C-v'ed and s/4/3 from h264parse and videoparsers/h264parse.c:
 *    Copyright (C) <2010> Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 *    Copyright (C) <2010> Collabora Multimedia
 *    Copyright (C) <2010> Nokia Corporation
 *
 *    (C) 2005 Michal Benes <michal.benes@itonis.tv>
 *    (C) 2008 Wim Taymans <wim.taymans@gmail.com>
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

#ifndef __GST_H264_PARSER_H__
#define __GST_H264_PARSER_H__

#ifndef GST_USE_UNSTABLE_API
#warning "The H.264 parsing library is unstable API and may change in future."
#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
#endif

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_H264_MAX_SPS_COUNT   32
#define GST_H264_MAX_PPS_COUNT   256

#define GST_H264_IS_P_SLICE(slice)  (((slice)->type % 5) == GST_H264_P_SLICE)
#define GST_H264_IS_B_SLICE(slice)  (((slice)->type % 5) == GST_H264_B_SLICE)
#define GST_H264_IS_I_SLICE(slice)  (((slice)->type % 5) == GST_H264_I_SLICE)
#define GST_H264_IS_SP_SLICE(slice) (((slice)->type % 5) == GST_H264_SP_SLICE)
#define GST_H264_IS_SI_SLICE(slice) (((slice)->type % 5) == GST_H264_SI_SLICE)

/**
 * GstH264Profile:
 * @GST_H264_PROFILE_BASELINE: Baseline profile (A.2.1)
 * @GST_H264_PROFILE_MAIN: Main profile (A.2.2)
 * @GST_H264_PROFILE_EXTENDED: Extended profile (A.2.3)
 * @GST_H264_PROFILE_HIGH: High profile (A.2.4)
 * @GST_H264_PROFILE_HIGH10: High 10 profile (A.2.5) or High 10 Intra
 *   profile (A.2.8), depending on constraint_set3_flag
 * @GST_H264_PROFILE_HIGH_422: High 4:2:2 profile (A.2.6) or High
 *   4:2:2 Intra profile (A.2.9), depending on constraint_set3_flag
 * @GST_H264_PROFILE_HIGH_444: High 4:4:4 Predictive profile (A.2.7)
 *   or High 4:4:4 Intra profile (A.2.10), depending on the value of
 *   constraint_set3_flag
 * @GST_H264_PROFILE_MULTIVIEW_HIGH: Multiview High profile (H.10.1.1)
 * @GST_H264_PROFILE_STEREO_HIGH: Stereo High profile (H.10.1.2)
 * @GST_H264_PROFILE_SCALABLE_BASELINE: Scalable Baseline profile (G.10.1.1)
 * @GST_H264_PROFILE_SCALABLE_HIGH: Scalable High profile (G.10.1.2)
 *   or Scalable High Intra profile (G.10.1.3), depending on the value
 *   of constraint_set3_flag
 *
 * H.264 Profiles.
 *
 * Since: 1.2
 */
typedef enum {
  GST_H264_PROFILE_BASELINE             = 66,
  GST_H264_PROFILE_MAIN                 = 77,
  GST_H264_PROFILE_EXTENDED             = 88,
  GST_H264_PROFILE_HIGH                 = 100,
  GST_H264_PROFILE_HIGH10               = 110,
  GST_H264_PROFILE_HIGH_422             = 122,
  GST_H264_PROFILE_HIGH_444             = 244,
  GST_H264_PROFILE_MULTIVIEW_HIGH       = 118,
  GST_H264_PROFILE_STEREO_HIGH          = 128,
  GST_H264_PROFILE_SCALABLE_BASELINE    = 83,
  GST_H264_PROFILE_SCALABLE_HIGH        = 86
} GstH264Profile;

/**
 * GstH264NalUnitType:
 * @GST_H264_NAL_UNKNOWN: Unknown nal type
 * @GST_H264_NAL_SLICE: Slice nal
 * @GST_H264_NAL_SLICE_DPA: DPA slice nal
 * @GST_H264_NAL_SLICE_DPB: DPB slice nal
 * @GST_H264_NAL_SLICE_DPC: DPC slice nal
 * @GST_H264_NAL_SLICE_IDR: DPR slice nal
 * @GST_H264_NAL_SEI: Supplemental enhancement information (SEI) nal unit
 * @GST_H264_NAL_SPS: Sequence parameter set (SPS) nal unit
 * @GST_H264_NAL_PPS: Picture parameter set (PPS) nal unit
 * @GST_H264_NAL_AU_DELIMITER: Access unit (AU) delimiter nal unit
 * @GST_H264_NAL_SEQ_END: End of sequence nal unit
 * @GST_H264_NAL_STREAM_END: End of stream nal unit
 * @GST_H264_NAL_FILLER_DATA: Filler data nal lunit
 * @GST_H264_NAL_SPS_EXT: Sequence parameter set (SPS) extension NAL unit
 * @GST_H264_NAL_PREFIX_UNIT: Prefix NAL unit
 * @GST_H264_NAL_SUBSET_SPS: Subset sequence parameter set (SPS) NAL unit
 * @GST_H264_NAL_SLICE_AUX: Auxiliary coded picture without partitioning NAL unit
 * @GST_H264_NAL_SLICE_EXT: Coded slice extension NAL unit
 *
 * Indicates the type of H264 Nal Units
 */
typedef enum
{
  GST_H264_NAL_UNKNOWN      = 0,
  GST_H264_NAL_SLICE        = 1,
  GST_H264_NAL_SLICE_DPA    = 2,
  GST_H264_NAL_SLICE_DPB    = 3,
  GST_H264_NAL_SLICE_DPC    = 4,
  GST_H264_NAL_SLICE_IDR    = 5,
  GST_H264_NAL_SEI          = 6,
  GST_H264_NAL_SPS          = 7,
  GST_H264_NAL_PPS          = 8,
  GST_H264_NAL_AU_DELIMITER = 9,
  GST_H264_NAL_SEQ_END      = 10,
  GST_H264_NAL_STREAM_END   = 11,
  GST_H264_NAL_FILLER_DATA  = 12,
  GST_H264_NAL_SPS_EXT      = 13,
  GST_H264_NAL_PREFIX_UNIT  = 14,
  GST_H264_NAL_SUBSET_SPS   = 15,
  GST_H264_NAL_SLICE_AUX    = 19,
  GST_H264_NAL_SLICE_EXT    = 20
} GstH264NalUnitType;

/**
 * GstH264ParserResult:
 * @GST_H264_PARSER_OK: The parsing succeded
 * @GST_H264_PARSER_BROKEN_DATA: The data to parse is broken
 * @GST_H264_PARSER_BROKEN_LINK: The link to structure needed for the parsing couldn't be found
 * @GST_H264_PARSER_ERROR: An error accured when parsing
 * @GST_H264_PARSER_NO_NAL: No nal found during the parsing
 * @GST_H264_PARSER_NO_NAL_END: Start of the nal found, but not the end.
 *
 * The result of parsing H264 data.
 */
typedef enum
{
  GST_H264_PARSER_OK,
  GST_H264_PARSER_BROKEN_DATA,
  GST_H264_PARSER_BROKEN_LINK,
  GST_H264_PARSER_ERROR,
  GST_H264_PARSER_NO_NAL,
  GST_H264_PARSER_NO_NAL_END
} GstH264ParserResult;

/**
 * GstH264SEIPayloadType:
 * @GST_H264_SEI_BUF_PERIOD: Buffering Period SEI Message
 * @GST_H264_SEI_PIC_TIMING: Picture Timing SEI Message
 * @GST_H264_SEI_RECOVERY_POINT: Recovery Point SEI Message (D.2.7)
 * ...
 *
 * The type of SEI message.
 */
typedef enum
{
  GST_H264_SEI_BUF_PERIOD = 0,
  GST_H264_SEI_PIC_TIMING = 1,
  GST_H264_SEI_RECOVERY_POINT = 6,
      /* and more...  */
} GstH264SEIPayloadType;

/**
 * GstH264SEIPicStructType:
 * @GST_H264_SEI_PIC_STRUCT_FRAME: Picture is a frame
 * @GST_H264_SEI_PIC_STRUCT_TOP_FIELD: Top field of frame
 * @GST_H264_SEI_PIC_STRUCT_BOTTOM_FIELD: Botom field of frame
 * @GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM: Top bottom field of frame
 * @GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP: bottom top field of frame
 * @GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM_TOP: top bottom top field of frame
 * @GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM: bottom top bottom field of frame
 * @GST_H264_SEI_PIC_STRUCT_FRAME_DOUBLING: indicates that the frame should
 *  be displayed two times consecutively
 * @GST_H264_SEI_PIC_STRUCT_FRAME_TRIPLING: indicates that the frame should be
 *  displayed three times consecutively
 *
 * SEI pic_struct type
 */
typedef enum
{
  GST_H264_SEI_PIC_STRUCT_FRAME             = 0,
  GST_H264_SEI_PIC_STRUCT_TOP_FIELD         = 1,
  GST_H264_SEI_PIC_STRUCT_BOTTOM_FIELD      = 2,
  GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM        = 3,
  GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP        = 4,
  GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM_TOP    = 5,
  GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM = 6,
  GST_H264_SEI_PIC_STRUCT_FRAME_DOUBLING    = 7,
  GST_H264_SEI_PIC_STRUCT_FRAME_TRIPLING    = 8
} GstH264SEIPicStructType;

/**
 * GstH264SliceType:
 *
 * Type of Picture slice
 */

typedef enum
{
  GST_H264_P_SLICE    = 0,
  GST_H264_B_SLICE    = 1,
  GST_H264_I_SLICE    = 2,
  GST_H264_SP_SLICE   = 3,
  GST_H264_SI_SLICE   = 4,
  GST_H264_S_P_SLICE  = 5,
  GST_H264_S_B_SLICE  = 6,
  GST_H264_S_I_SLICE  = 7,
  GST_H264_S_SP_SLICE = 8,
  GST_H264_S_SI_SLICE = 9
} GstH264SliceType;

typedef struct _GstH264NalParser              GstH264NalParser;

typedef struct _GstH264NalUnit                GstH264NalUnit;

typedef struct _GstH264SPS                    GstH264SPS;
typedef struct _GstH264PPS                    GstH264PPS;
typedef struct _GstH264HRDParams              GstH264HRDParams;
typedef struct _GstH264VUIParams              GstH264VUIParams;

typedef struct _GstH264RefPicListModification GstH264RefPicListModification;
typedef struct _GstH264DecRefPicMarking       GstH264DecRefPicMarking;
typedef struct _GstH264RefPicMarking          GstH264RefPicMarking;
typedef struct _GstH264PredWeightTable        GstH264PredWeightTable;
typedef struct _GstH264SliceHdr               GstH264SliceHdr;

typedef struct _GstH264ClockTimestamp         GstH264ClockTimestamp;
typedef struct _GstH264PicTiming              GstH264PicTiming;
typedef struct _GstH264BufferingPeriod        GstH264BufferingPeriod;
typedef struct _GstH264RecoveryPoint          GstH264RecoveryPoint;
typedef struct _GstH264SEIMessage             GstH264SEIMessage;

/**
 * GstH264NalUnit:
 * @ref_idc: not equal to 0 specifies that the content of the NAL unit
 *  contains a sequence parameter set, a sequence parameter set
 *  extension, a subset sequence parameter set, a picture parameter
 *  set, a slice of a reference picture, a slice data partition of a
 *  reference picture, or a prefix NAL unit preceding a slice of a
 *  reference picture.
 * @type: A #GstH264NalUnitType
 * @idr_pic_flag: calculated idr_pic_flag
 * @size: The size of the nal unit starting from @offset, thus
 *  including the header bytes. e.g. @type (nal_unit_type)
 * @offset: The offset of the actual start of the nal unit, thus
 *  including the header bytes
 * @sc_offset: The offset of the start code of the nal unit
 * @valid: If the nal unit is valid, which means it has
 * already been parsed
 * @data: The data from which the Nalu has been parsed
 *
 * Structure defining the Nal unit headers
 */
struct _GstH264NalUnit
{
  guint16 ref_idc;
  guint16 type;

  /* calculated values */
  guint8 idr_pic_flag;
  guint size;
  guint offset;
  guint sc_offset;
  gboolean valid;

  guint8 *data;
};

/**
 * GstH264HRDParams:
 * @cpb_cnt_minus1: plus 1 specifies the number of alternative
 *    CPB specifications in the bitstream
 * @bit_rate_scale: specifies the maximum input bit rate of the
 * SchedSelIdx-th CPB
 * @cpb_size_scale: specifies the CPB size of the SchedSelIdx-th CPB
 * @guint32 bit_rate_value_minus1: specifies the maximum input bit rate for the
 * SchedSelIdx-th CPB
 * @cpb_size_value_minus1: is used together with cpb_size_scale to specify the
 * SchedSelIdx-th CPB size
 * @cbr_flag: Specifies if running in itermediate bitrate mode or constant
 * @initial_cpb_removal_delay_length_minus1: specifies the length in bits of
 * the cpb_removal_delay syntax element
 * @cpb_removal_delay_length_minus1: specifies the length in bits of the
 * dpb_output_delay syntax element
 * @dpb_output_delay_length_minus1: >0 specifies the length in bits of the time_offset syntax element.
 * =0 specifies that the time_offset syntax element is not present
 * @time_offset_length: Length of the time offset
 *
 * Defines the HRD parameters
 */
struct _GstH264HRDParams
{
  guint8 cpb_cnt_minus1;
  guint8 bit_rate_scale;
  guint8 cpb_size_scale;

  guint32 bit_rate_value_minus1[32];
  guint32 cpb_size_value_minus1[32];
  guint8 cbr_flag[32];

  guint8 initial_cpb_removal_delay_length_minus1;
  guint8 cpb_removal_delay_length_minus1;
  guint8 dpb_output_delay_length_minus1;
  guint8 time_offset_length;
};

/**
 * GstH264VUIParams:
 * @aspect_ratio_info_present_flag: %TRUE specifies that aspect_ratio_idc is present.
 *  %FALSE specifies that aspect_ratio_idc is not present
 * @aspect_ratio_idc specifies the value of the sample aspect ratio of the luma samples
 * @sar_width indicates the horizontal size of the sample aspect ratio
 * @sar_height indicates the vertical size of the sample aspect ratio
 * @overscan_info_present_flag: %TRUE overscan_appropriate_flag is present %FALSE otherwize
 * @overscan_appropriate_flag: %TRUE indicates that the cropped decoded pictures
 *  output are suitable for display using overscan. %FALSE the cropped decoded pictures
 *  output contain visually important information
 * @video_signal_type_present_flag: %TRUE specifies that video_format, video_full_range_flag and
 *  colour_description_present_flag are present.
 * @video_format: indicates the representation of the picture
 * @video_full_range_flag: indicates the black level and range of the luma and chroma signals
 * @colour_description_present_flag: %TRUE specifies that colour_primaries,
 *  transfer_characteristics and matrix_coefficients are present
 * @colour_primaries: indicates the chromaticity coordinates of the source primaries
 * @transfer_characteristics: indicates the opto-electronic transfer characteristic
 * @matrix_coefficients: describes the matrix coefficients used in deriving luma and chroma signals
 * @chroma_loc_info_present_flag: %TRUE specifies that chroma_sample_loc_type_top_field and
 *  chroma_sample_loc_type_bottom_field are present, %FALSE otherwize
 * @chroma_sample_loc_type_top_field: specify the location of chroma for top field
 * @chroma_sample_loc_type_bottom_field specify the location of chroma for bottom field
 * @timing_info_present_flag: %TRUE specifies that num_units_in_tick,
 *  time_scale and fixed_frame_rate_flag are present in the bitstream
 * @num_units_in_tick: is the number of time units of a clock operating at the frequency time_scale Hz
 * time_scale: is the number of time units that pass in one second
 * @fixed_frame_rate_flag: %TRUE indicates that the temporal distance between the HRD output times
 *  of any two consecutive pictures in output order is constrained as specified in the spec, %FALSE
 *  otherwize.
 * @nal_hrd_parameters_present_flag: %TRUE if nal hrd parameters present in the bitstream
 * @vcl_hrd_parameters_present_flag: %TRUE if nal vlc hrd parameters present in the bitstream
 * @low_delay_hrd_flag: specifies the HRD operational mode
 * @pic_struct_present_flag: %TRUE specifies that picture timing SEI messages are present or not
 * @bitstream_restriction_flag: %TRUE specifies that the following coded video sequence bitstream restriction
 * parameters are present
 * @motion_vectors_over_pic_boundaries_flag: %FALSE indicates that no sample outside the
 *  picture boundaries and no sample at a fractional sample position, %TRUE indicates that one or more
 *  samples outside picture boundaries may be used in inter prediction
 * @max_bytes_per_pic_denom: indicates a number of bytes not exceeded by the sum of the sizes of
 *  the VCL NAL units associated with any coded picture in the coded video sequence.
 * @max_bits_per_mb_denom: indicates the maximum number of coded bits of macroblock_layer
 * @log2_max_mv_length_horizontal: indicate the maximum absolute value of a decoded horizontal
 * motion vector component
 * @log2_max_mv_length_vertical: indicate the maximum absolute value of a decoded vertical
 *  motion vector component
 * @num_reorder_frames: indicates the maximum number of frames, complementary field pairs,
 *  or non-paired fields that precede any frame,
 * @max_dec_frame_buffering: specifies the required size of the HRD decoded picture buffer in
 *  units of frame buffers.
 *
 * The structure representing the VUI parameters.
 */
struct _GstH264VUIParams
{
  guint8 aspect_ratio_info_present_flag;
  guint8 aspect_ratio_idc;
  /* if aspect_ratio_idc == 255 */
  guint16 sar_width;
  guint16 sar_height;

  guint8 overscan_info_present_flag;
  /* if overscan_info_present_flag */
  guint8 overscan_appropriate_flag;

  guint8 video_signal_type_present_flag;
  guint8 video_format;
  guint8 video_full_range_flag;
  guint8 colour_description_present_flag;
  guint8 colour_primaries;
  guint8 transfer_characteristics;
  guint8 matrix_coefficients;

  guint8 chroma_loc_info_present_flag;
  guint8 chroma_sample_loc_type_top_field;
  guint8 chroma_sample_loc_type_bottom_field;

  guint8 timing_info_present_flag;
  /* if timing_info_present_flag */
  guint32 num_units_in_tick;
  guint32 time_scale;
  guint8 fixed_frame_rate_flag;

  guint8 nal_hrd_parameters_present_flag;
  /* if nal_hrd_parameters_present_flag */
  GstH264HRDParams nal_hrd_parameters;

  guint8 vcl_hrd_parameters_present_flag;
  /* if vcl_hrd_parameters_present_flag */
  GstH264HRDParams vcl_hrd_parameters;

  guint8 low_delay_hrd_flag;
  guint8 pic_struct_present_flag;

  guint8 bitstream_restriction_flag;
  /*  if bitstream_restriction_flag */
  guint8 motion_vectors_over_pic_boundaries_flag;
  guint32 max_bytes_per_pic_denom;
  guint32 max_bits_per_mb_denom;
  guint32 log2_max_mv_length_horizontal;
  guint32 log2_max_mv_length_vertical;
  guint32 num_reorder_frames;
  guint32 max_dec_frame_buffering;

  /* calculated values */
  guint par_n;
  guint par_d;
};

/**
 * GstH264SPS:
 * @id: The ID of the sequence parameter set
 * @profile_idc: indicate the profile to which the coded video sequence conforms
 *
 * H264 Sequence Parameter Set (SPS)
 */
struct _GstH264SPS
{
  gint id;

  guint8 profile_idc;
  guint8 constraint_set0_flag;
  guint8 constraint_set1_flag;
  guint8 constraint_set2_flag;
  guint8 constraint_set3_flag;
  guint8 level_idc;

  guint8 chroma_format_idc;
  guint8 separate_colour_plane_flag;
  guint8 bit_depth_luma_minus8;
  guint8 bit_depth_chroma_minus8;
  guint8 qpprime_y_zero_transform_bypass_flag;

  guint8 scaling_matrix_present_flag;
  guint8 scaling_lists_4x4[6][16];
  guint8 scaling_lists_8x8[6][64];

  guint8 log2_max_frame_num_minus4;
  guint8 pic_order_cnt_type;

  /* if pic_order_cnt_type == 0 */
  guint8 log2_max_pic_order_cnt_lsb_minus4;

  /* else if pic_order_cnt_type == 1 */
  guint8 delta_pic_order_always_zero_flag;
  gint32 offset_for_non_ref_pic;
  gint32 offset_for_top_to_bottom_field;
  guint8 num_ref_frames_in_pic_order_cnt_cycle;
  gint32 offset_for_ref_frame[255];

  guint32 num_ref_frames;
  guint8 gaps_in_frame_num_value_allowed_flag;
  guint32 pic_width_in_mbs_minus1;
  guint32 pic_height_in_map_units_minus1;
  guint8 frame_mbs_only_flag;

  guint8 mb_adaptive_frame_field_flag;

  guint8 direct_8x8_inference_flag;

  guint8 frame_cropping_flag;

  /* if frame_cropping_flag */
  guint32 frame_crop_left_offset;
  guint32 frame_crop_right_offset;
  guint32 frame_crop_top_offset;
  guint32 frame_crop_bottom_offset;

  guint8 vui_parameters_present_flag;
  /* if vui_parameters_present_flag */
  GstH264VUIParams vui_parameters;

  /* calculated values */
  guint8 chroma_array_type;
  guint32 max_frame_num;
  gint width, height;
  gint crop_rect_width, crop_rect_height;
  gint crop_rect_x, crop_rect_y;
  gint fps_num, fps_den;
  gboolean valid;
};

/**
 * GstH264PPS:
 *
 * H264 Picture Parameter Set
 */
struct _GstH264PPS
{
  gint id;

  GstH264SPS *sequence;

  guint8 entropy_coding_mode_flag;
  guint8 pic_order_present_flag;

  guint32 num_slice_groups_minus1;

  /* if num_slice_groups_minus1 > 0 */
  guint8 slice_group_map_type;
  /* and if slice_group_map_type == 0 */
  guint32 run_length_minus1[8];
  /* or if slice_group_map_type == 2 */
  guint32 top_left[8];
  guint32 bottom_right[8];
  /* or if slice_group_map_type == (3, 4, 5) */
  guint8 slice_group_change_direction_flag;
  guint32 slice_group_change_rate_minus1;
  /* or if slice_group_map_type == 6 */
  guint32 pic_size_in_map_units_minus1;
  guint8 *slice_group_id;

  guint8 num_ref_idx_l0_active_minus1;
  guint8 num_ref_idx_l1_active_minus1;
  guint8 weighted_pred_flag;
  guint8 weighted_bipred_idc;
  gint8 pic_init_qp_minus26;
  gint8 pic_init_qs_minus26;
  gint8 chroma_qp_index_offset;
  guint8 deblocking_filter_control_present_flag;
  guint8 constrained_intra_pred_flag;
  guint8 redundant_pic_cnt_present_flag;

  guint8 transform_8x8_mode_flag;

  guint8 scaling_lists_4x4[6][16];
  guint8 scaling_lists_8x8[6][64];

  guint8 second_chroma_qp_index_offset;

  gboolean valid;
};

struct _GstH264RefPicListModification
{
  guint8 modification_of_pic_nums_idc;
  union
  {
    /* if modification_of_pic_nums_idc == 0 || 1 */
    guint32 abs_diff_pic_num_minus1;
    /* if modification_of_pic_nums_idc == 2 */
    guint32 long_term_pic_num;
  } value;
};

struct _GstH264PredWeightTable
{
  guint8 luma_log2_weight_denom;
  guint8 chroma_log2_weight_denom;

  gint16 luma_weight_l0[32];
  gint8 luma_offset_l0[32];

  /* if seq->ChromaArrayType != 0 */
  gint16 chroma_weight_l0[32][2];
  gint8 chroma_offset_l0[32][2];

  /* if slice->slice_type % 5 == 1 */
  gint16 luma_weight_l1[32];
  gint8 luma_offset_l1[32];

  /* and if seq->ChromaArrayType != 0 */
  gint16 chroma_weight_l1[32][2];
  gint8 chroma_offset_l1[32][2];
};

struct _GstH264RefPicMarking
{
  guint8 memory_management_control_operation;

  guint32 difference_of_pic_nums_minus1;
  guint32 long_term_pic_num;
  guint32 long_term_frame_idx;
  guint32 max_long_term_frame_idx_plus1;
};

struct _GstH264DecRefPicMarking
{
  /* if slice->nal_unit.IdrPicFlag */
  guint8 no_output_of_prior_pics_flag;
  guint8 long_term_reference_flag;

  guint8 adaptive_ref_pic_marking_mode_flag;
  GstH264RefPicMarking ref_pic_marking[10];
  guint8 n_ref_pic_marking;
};


struct _GstH264SliceHdr
{
  guint32 first_mb_in_slice;
  guint32 type;
  GstH264PPS *pps;

  /* if seq->separate_colour_plane_flag */
  guint8 colour_plane_id;

  guint16 frame_num;

  guint8 field_pic_flag;
  guint8 bottom_field_flag;

  /* if nal_unit.type == 5 */
  guint16 idr_pic_id;

  /* if seq->pic_order_cnt_type == 0 */
  guint16 pic_order_cnt_lsb;
  /* if seq->pic_order_present_flag && !field_pic_flag */
  gint32 delta_pic_order_cnt_bottom;

  gint32 delta_pic_order_cnt[2];
  guint8 redundant_pic_cnt;

  /* if slice_type == B_SLICE */
  guint8 direct_spatial_mv_pred_flag;

  guint8 num_ref_idx_l0_active_minus1;
  guint8 num_ref_idx_l1_active_minus1;

  guint8 ref_pic_list_modification_flag_l0;
  guint8 n_ref_pic_list_modification_l0;
  GstH264RefPicListModification ref_pic_list_modification_l0[32];
  guint8 ref_pic_list_modification_flag_l1;
  guint8 n_ref_pic_list_modification_l1;
  GstH264RefPicListModification ref_pic_list_modification_l1[32];

  GstH264PredWeightTable pred_weight_table;
  /* if nal_unit.ref_idc != 0 */
  GstH264DecRefPicMarking dec_ref_pic_marking;

  guint8 cabac_init_idc;
  gint8 slice_qp_delta;
  gint8 slice_qs_delta;

  guint8 disable_deblocking_filter_idc;
  gint8 slice_alpha_c0_offset_div2;
  gint8 slice_beta_offset_div2;

  guint16 slice_group_change_cycle;

  /* calculated values */
  guint32 max_pic_num;
  gboolean valid;

  /* Size of the slice_header() in bits */
  guint header_size;

  /* Number of emulation prevention bytes (EPB) in this slice_header() */
  guint n_emulation_prevention_bytes;
};


struct _GstH264ClockTimestamp
{
  guint8 ct_type;
  guint8 nuit_field_based_flag;
  guint8 counting_type;
  guint8 discontinuity_flag;
  guint8 cnt_dropped_flag;
  guint8 n_frames;

  guint8 seconds_flag;
  guint8 seconds_value;

  guint8 minutes_flag;
  guint8 minutes_value;

  guint8 hours_flag;
  guint8 hours_value;

  guint32 time_offset;
};

struct _GstH264PicTiming
{
  guint32 cpb_removal_delay;
  guint32 dpb_output_delay;

  guint8 pic_struct_present_flag;
  /* if pic_struct_present_flag */
  guint8 pic_struct;

  guint8 clock_timestamp_flag[3];
  GstH264ClockTimestamp clock_timestamp[3];
};

struct _GstH264BufferingPeriod
{
  GstH264SPS *sps;

  /* seq->vui_parameters->nal_hrd_parameters_present_flag */
  guint8 nal_initial_cpb_removal_delay[32];
  guint8 nal_initial_cpb_removal_delay_offset[32];

  /* seq->vui_parameters->vcl_hrd_parameters_present_flag */
  guint8 vcl_initial_cpb_removal_delay[32];
  guint8 vcl_initial_cpb_removal_delay_offset[32];
};

struct _GstH264RecoveryPoint
{
  guint32 recovery_frame_cnt;
  guint8 exact_match_flag;
  guint8 broken_link_flag;
  guint8 changing_slice_group_idc;
};

struct _GstH264SEIMessage
{
  GstH264SEIPayloadType payloadType;

  union {
    GstH264BufferingPeriod buffering_period;
    GstH264PicTiming pic_timing;
    GstH264RecoveryPoint recovery_point;
    /* ... could implement more */
  } payload;
};

/**
 * GstH264NalParser:
 *
 * H264 NAL Parser (opaque structure).
 */
struct _GstH264NalParser
{
  /*< private >*/
  GstH264SPS sps[GST_H264_MAX_SPS_COUNT];
  GstH264PPS pps[GST_H264_MAX_PPS_COUNT];
  GstH264SPS *last_sps;
  GstH264PPS *last_pps;
};

GstH264NalParser *gst_h264_nal_parser_new             (void);

GstH264ParserResult gst_h264_parser_identify_nalu     (GstH264NalParser *nalparser,
                                                       const guint8 *data, guint offset,
                                                       gsize size, GstH264NalUnit *nalu);

GstH264ParserResult gst_h264_parser_identify_nalu_unchecked (GstH264NalParser *nalparser,
                                                       const guint8 *data, guint offset,
                                                       gsize size, GstH264NalUnit *nalu);

GstH264ParserResult gst_h264_parser_identify_nalu_avc (GstH264NalParser *nalparser, const guint8 *data,
                                                       guint offset, gsize size, guint8 nal_length_size,
                                                       GstH264NalUnit *nalu);

GstH264ParserResult gst_h264_parser_parse_nal         (GstH264NalParser *nalparser,
                                                       GstH264NalUnit *nalu);

GstH264ParserResult gst_h264_parser_parse_slice_hdr   (GstH264NalParser *nalparser, GstH264NalUnit *nalu,
                                                       GstH264SliceHdr *slice, gboolean parse_pred_weight_table,
                                                       gboolean parse_dec_ref_pic_marking);

GstH264ParserResult gst_h264_parser_parse_sps         (GstH264NalParser *nalparser, GstH264NalUnit *nalu,
                                                       GstH264SPS *sps, gboolean parse_vui_params);

GstH264ParserResult gst_h264_parser_parse_pps         (GstH264NalParser *nalparser,
                                                       GstH264NalUnit *nalu, GstH264PPS *pps);

GstH264ParserResult gst_h264_parser_parse_sei         (GstH264NalParser *nalparser,
                                                       GstH264NalUnit *nalu, GArray ** messages);

void gst_h264_nal_parser_free                         (GstH264NalParser *nalparser);

GstH264ParserResult gst_h264_parse_sps                (GstH264NalUnit *nalu,
                                                       GstH264SPS *sps, gboolean parse_vui_params);

GstH264ParserResult gst_h264_parse_pps                (GstH264NalParser *nalparser,
                                                       GstH264NalUnit *nalu, GstH264PPS *pps);

void                gst_h264_pps_clear                (GstH264PPS *pps);

void    gst_h264_quant_matrix_8x8_get_zigzag_from_raster (guint8 out_quant[64],
                                                          const guint8 quant[64]);

void    gst_h264_quant_matrix_8x8_get_raster_from_zigzag (guint8 out_quant[64],
                                                          const guint8 quant[64]);

void    gst_h264_quant_matrix_4x4_get_zigzag_from_raster (guint8 out_quant[16],
                                                          const guint8 quant[16]);

void    gst_h264_quant_matrix_4x4_get_raster_from_zigzag (guint8 out_quant[16],
                                                          const guint8 quant[16]);

void gst_h264_video_calculate_framerate (const GstH264SPS * sps, guint field_pic_flag,
    guint pic_struct, gint * fps_num, gint * fps_den);

G_END_DECLS

#endif
