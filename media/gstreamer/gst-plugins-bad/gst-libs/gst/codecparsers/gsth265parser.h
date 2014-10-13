/* Gstreamer H.265 bitstream parser
 * Copyright (C) 2013 Intel Corporation
 * Copyright (C) 2013 Sreerenj Balachandran <sreerenj.balachandran@intel.com>
 *
 *  Contact: Sreerenj Balachandran <sreerenj.balachandran@intel.com>
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

#ifndef __GST_H265_PARSER_H__
#define __GST_H265_PARSER_H__

#ifndef GST_USE_UNSTABLE_API
#warning "The H.265 parsing library is unstable API and may change in future."
#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
#endif

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_H265_MAX_SUB_LAYERS   8
#define GST_H265_MAX_VPS_COUNT   16
#define GST_H265_MAX_SPS_COUNT   16
#define GST_H265_MAX_PPS_COUNT   64

#define GST_H265_IS_B_SLICE(slice)  ((slice)->type == GST_H265_B_SLICE)
#define GST_H265_IS_P_SLICE(slice)  ((slice)->type == GST_H265_P_SLICE)
#define GST_H265_IS_I_SLICE(slice)  ((slice)->type == GST_H265_I_SLICE)

/**
 * GstH265Profile:
 * @GST_H265_PROFILE_MAIN: Main profile (A.3.2)
 * @GST_H265_PROFILE_MAIN_10: Main 10 profile (A.3.3)
 * @GST_H265_PROFILE_MAIN_STILL_PICTURE: Main Still Picture profile (A.3.4)
 *
 * H.265 Profiles.
 *
 */
typedef enum {
  GST_H265_PROFILE_MAIN                 = 1,
  GST_H265_PROFILE_MAIN_10              = 2,
  GST_H265_PROFILE_MAIN_STILL_PICTURE   = 3
} GstH265Profile;

/**
 * GstH265NalUnitType:
 * @GST_H265_NAL_SLICE_TRAIL_N: Slice nal of a non-TSA, non-STSA trailing picture
 * @GST_H265_NAL_SLICE_TRAIL_R: Slice nal of a non-TSA, non-STSA trailing picture
 * @GST_H265_NAL_SLICE_TSA_N: Slice nal of a TSA picture
 * @GST_H265_NAL_SLICE_TSA_R: Slice nal of a TSA picture
 * @GST_H265_NAL_SLICE_STSA_N: Slice nal of a STSA picture
 * @GST_H265_NAL_SLICE_STSA_R: Slice nal of a STSA picture
 * @GST_H265_NAL_SLICE_RADL_N: Slice nal of a RADL picture
 * @GST_H265_NAL_SLICE_RADL_R: Slice nal of a RADL piicture
 * @GST_H265_NAL_SLICE_RASL_N: Slice nal of a RASL picture
 * @GST_H265_NAL_SLICE_RASL_R: Slice nal of a RASL picture
 * @GST_H265_NAL_SLICE_BLA_W_LP: Slice nal of a BLA picture
 * @GST_H265_NAL_SLICE_BLA_W_RADL: Slice nal of a BLA picture
 * @GST_H265_NAL_SLICE_BLA_N_LP: Slice nal of a BLA picture
 * @GST_H265_NAL_SLICE_IDR_W_RADL: Slice nal of an IDR picture
 * @GST_H265_NAL_SLICE_IDR_N_LP: Slice nal of an IDR picture
 * @GST_H265_NAL_SLICE_CRA_NUT: Slice nal of a CRA picture
 * @GST_H265_NAL_VPS: Video parameter set(VPS) nal unit
 * @GST_H265_NAL_SPS: Sequence parameter set (SPS) nal unit
 * @GST_H265_NAL_PPS: Picture parameter set (PPS) nal unit
 * @GST_H265_NAL_AUD: Access unit (AU) delimiter nal unit
 * @GST_H265_NAL_EOS: End of sequence (EOS) nal unit
 * @GST_H265_NAL_EOB: End of bitstream (EOB) nal unit
 * @GST_H265_NAL_FD: Filler data (FD) nal lunit
 * @GST_H265_NAL_PREFIX_SEI: Supplemental enhancement information prefix nal unit
 * @GST_H265_NAL_SUFFIX_SEI: Suppliemental enhancement information suffix nal unit
 *
 * Indicates the type of H265 Nal Units
 */
typedef enum
{
  GST_H265_NAL_SLICE_TRAIL_N    = 0,
  GST_H265_NAL_SLICE_TRAIL_R    = 1,
  GST_H265_NAL_SLICE_TSA_N      = 2,
  GST_H265_NAL_SLICE_TSA_R      = 3,
  GST_H265_NAL_SLICE_STSA_N     = 4,
  GST_H265_NAL_SLICE_STSA_R     = 5,
  GST_H265_NAL_SLICE_RADL_N     = 6,
  GST_H265_NAL_SLICE_RADL_R     = 7,
  GST_H265_NAL_SLICE_RASL_N     = 8,
  GST_H265_NAL_SLICE_RASL_R     = 9,
  GST_H265_NAL_SLICE_BLA_W_LP   = 16,
  GST_H265_NAL_SLICE_BLA_W_RADL = 17,
  GST_H265_NAL_SLICE_BLA_N_LP   = 18,
  GST_H265_NAL_SLICE_IDR_W_RADL = 19,
  GST_H265_NAL_SLICE_IDR_N_LP   = 20,
  GST_H265_NAL_SLICE_CRA_NUT    = 21,
  GST_H265_NAL_VPS              = 32,
  GST_H265_NAL_SPS              = 33,
  GST_H265_NAL_PPS              = 34,
  GST_H265_NAL_AUD              = 35,
  GST_H265_NAL_EOS              = 36,
  GST_H265_NAL_EOB              = 37,
  GST_H265_NAL_FD               = 38,
  GST_H265_NAL_PREFIX_SEI       = 39,
  GST_H265_NAL_SUFFIX_SEI       = 40
} GstH265NalUnitType;

#define RESERVED_NON_IRAP_SUBLAYER_NAL_TYPE_MIN 10
#define RESERVED_NON_IRAP_SUBLAYER_NAL_TYPE_MAX 15

#define RESERVED_IRAP_NAL_TYPE_MIN 22
#define RESERVED_IRAP_NAL_TYPE_MAX 23

#define RESERVED_NON_IRAP_NAL_TYPE_MIN 24
#define RESERVED_NON_IRAP_NAL_TYPE_MAX 31

#define RESERVED_NON_VCL_NAL_TYPE_MIN 41
#define RESERVED_NON_VCL_NAL_TYPE_MAX 47

#define UNSPECIFIED_NON_VCL_NAL_TYPE_MIN 48
#define UNSPECIFIED_NON_VCL_NAL_TYPE_MAX 63

/**
 * GstH265ParserResult:
 * @GST_H265_PARSER_OK: The parsing succeded
 * @GST_H265_PARSER_BROKEN_DATA: The data to parse is broken
 * @GST_H265_PARSER_BROKEN_LINK: The link to structure needed for the parsing couldn't be found
 * @GST_H265_PARSER_ERROR: An error accured when parsing
 * @GST_H265_PARSER_NO_NAL: No nal found during the parsing
 * @GST_H265_PARSER_NO_NAL_END: Start of the nal found, but not the end.
 *
 * The result of parsing H265 data.
 */
typedef enum
{
  GST_H265_PARSER_OK,
  GST_H265_PARSER_BROKEN_DATA,
  GST_H265_PARSER_BROKEN_LINK,
  GST_H265_PARSER_ERROR,
  GST_H265_PARSER_NO_NAL,
  GST_H265_PARSER_NO_NAL_END
} GstH265ParserResult;

/**
 * GstH265SEIPayloadType:
 * @GST_H265_SEI_BUF_PERIOD: Buffering Period SEI Message
 * @GST_H265_SEI_PIC_TIMING: Picture Timing SEI Message
 * ...
 *
 * The type of SEI message.
 */
typedef enum
{
  GST_H265_SEI_BUF_PERIOD = 0,
  GST_H265_SEI_PIC_TIMING = 1
      /* and more...  */
} GstH265SEIPayloadType;

/**
 * GstH265SEIPicStructType:
 * @GST_H265_SEI_PIC_STRUCT_FRAME: Picture is a frame
 * @GST_H265_SEI_PIC_STRUCT_TOP_FIELD: Top field of frame
 * @GST_H265_SEI_PIC_STRUCT_BOTTOM_FIELD: Botom field of frame
 * @GST_H265_SEI_PIC_STRUCT_TOP_BOTTOM: Top bottom field of frame
 * @GST_H265_SEI_PIC_STRUCT_BOTTOM_TOP: bottom top field of frame
 * @GST_H265_SEI_PIC_STRUCT_TOP_BOTTOM_TOP: top bottom top field of frame
 * @GST_H265_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM: bottom top bottom field of frame
 * @GST_H265_SEI_PIC_STRUCT_FRAME_DOUBLING: indicates that the frame should
 *  be displayed two times consecutively
 * @GST_H265_SEI_PIC_STRUCT_FRAME_TRIPLING: indicates that the frame should be
 *  displayed three times consecutively
 * @GST_H265_SEI_PIC_STRUCT_TOP_PAIRED_PREVIOUS_BOTTOM: top field paired with
 *  previous bottom field in output order
 * @GST_H265_SEI_PIC_STRUCT_BOTTOM_PAIRED_PREVIOUS_TOP: bottom field paried with
 *  previous top field in output order
 * @GST_H265_SEI_PIC_STRUCT_TOP_PAIRED_NEXT_BOTTOM: top field paired with next
 *  bottom field in output order
 * @GST_H265_SEI_PIC_STRUCT_BOTTOM_PAIRED_NEXT_TOP: bottom field paired with
 *  next top field in output order
 *
 * SEI pic_struct type
 */
typedef enum
{
  GST_H265_SEI_PIC_STRUCT_FRAME                         = 0,
  GST_H265_SEI_PIC_STRUCT_TOP_FIELD                     = 1,
  GST_H265_SEI_PIC_STRUCT_BOTTOM_FIELD                  = 2,
  GST_H265_SEI_PIC_STRUCT_TOP_BOTTOM                    = 3,
  GST_H265_SEI_PIC_STRUCT_BOTTOM_TOP                    = 4,
  GST_H265_SEI_PIC_STRUCT_TOP_BOTTOM_TOP                = 5,
  GST_H265_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM             = 6,
  GST_H265_SEI_PIC_STRUCT_FRAME_DOUBLING                = 7,
  GST_H265_SEI_PIC_STRUCT_FRAME_TRIPLING                = 8,
  GST_H265_SEI_PIC_STRUCT_TOP_PAIRED_PREVIOUS_BOTTOM    = 9,
  GST_H265_SEI_PIC_STRUCT_BOTTOM_PAIRED_PREVIOUS_TOP    = 10,
  GST_H265_SEI_PIC_STRUCT_TOP_PAIRED_NEXT_BOTTOM        = 11,
  GST_H265_SEI_PIC_STRUCT_BOTTOM_PAIRED_NEXT_TOP        = 12
} GstH265SEIPicStructType;

/**
 * GstH265SliceType:
 *
 * Type of Picture slice
 */

typedef enum
{
  GST_H265_B_SLICE    = 0,
  GST_H265_P_SLICE    = 1,
  GST_H265_I_SLICE    = 2
} GstH265SliceType;

typedef enum
{
  GST_H265_QUANT_MATIX_4X4   = 0,
  GST_H265_QUANT_MATIX_8X8   = 1,
  GST_H265_QUANT_MATIX_16X16 = 2,
  GST_H265_QUANT_MATIX_32X32 = 3
} GstH265QuantMatrixSize;

typedef struct _GstH265Parser                   GstH265Parser;

typedef struct _GstH265NalUnit                  GstH265NalUnit;

typedef struct _GstH265VPS                      GstH265VPS;
typedef struct _GstH265SPS                      GstH265SPS;
typedef struct _GstH265PPS                      GstH265PPS;
typedef struct _GstH265ProfileTierLevel         GstH265ProfileTierLevel;
typedef struct _GstH265SubLayerHRDParams        GstH265SubLayerHRDParams;
typedef struct _GstH265HRDParams                GstH265HRDParams;
typedef struct _GstH265VUIParams                GstH265VUIParams;

typedef struct _GstH265ScalingList              GstH265ScalingList;
typedef struct _GstH265RefPicListModification   GstH265RefPicListModification;
typedef struct _GstH265PredWeightTable          GstH265PredWeightTable;
typedef struct _GstH265ShortTermRefPicSet       GstH265ShortTermRefPicSet;
typedef struct _GstH265SliceHdr                 GstH265SliceHdr;

typedef struct _GstH265PicTiming                GstH265PicTiming;
typedef struct _GstH265BufferingPeriod          GstH265BufferingPeriod;
typedef struct _GstH265SEIMessage               GstH265SEIMessage;

/**
 * GstH265NalUnit:
 * @type: A #GstH265NalUnitType
 * @layer_id: A nal unit layer id
 * @temporal_id_plus1: A nal unit temporal identifier
 * @size: The size of the nal unit starting from @offset
 * @offset: The offset of the actual start of the nal unit
 * @sc_offset:The offset of the start code of the nal unit
 * @valid: If the nal unit is valid, which mean it has
 * already been parsed
 * @data: The data from which the Nalu has been parsed
 *
 * Structure defining the Nal unit headers
 */
struct _GstH265NalUnit
{
  guint8 type;
  guint8 layer_id;
  guint8 temporal_id_plus1;

  /* calculated values */
  guint size;
  guint offset;
  guint sc_offset;
  gboolean valid;

  guint8 *data;
  guint8 header_bytes;
};

/**
 * GstH265ProfileTierLevel:
 * @profile_space: specifies the context for the interpretation of
 *   general_profile_idc and general_profile_combatibility_flag
 * @tier_flag: the tier context for the interpretation of general_level_idc
 * @profile_idc: profile id
 * @profile_compatibility_flag: compatibility flags
 * @progressive_source_flag: flag to indicate the type of stream
 * @interlaced_source_flag: flag to indicate the type of stream
 * @non_packed_constraint_flag: indicate the presence of frame packing
 *   arragement sei message
 * @frame_only_constraint_flag: recognize the field_seq_flag
 * @level idc: indicate the level which the CVS confirms
 * @sub_layer_profile_present_flag: sublayer profile presence ind
 * @sub_layer_level_present_flag:sublayer level presence indicator.
 * @sub_layer_profile_space: profile space for sublayers
 * @sub_layer_tier_flag: tier flags for sublayers.
 * @sub_layer_profile_idc: conformant profile indicator for sublayers.
 * @sub_layer_profile_compatibility_flag[6][32]: compatibility flags for sublayers
 * @sub_layer_progressive_source_flag:progressive stream indicator for sublayer
 * @sub_layer_interlaced_source_flag: interlaced stream indicator for sublayer
 * @sub_layer_non_packed_constraint_flag: indicate the presence of
 *   frame packing arrangement sei message with in sublayers
 * @sub_layer_frame_only_constraint_flag:recognize the sublayer
 *   specific field_seq_flag
 * @sub_layer_level_idc:indicate the sublayer specific level
 *
 * Define ProfileTierLevel parameters
 */
struct _GstH265ProfileTierLevel {
  guint8 profile_space;
  guint8 tier_flag;
  guint8 profile_idc;

  guint8 profile_compatibility_flag[32];

  guint8 progressive_source_flag;
  guint8 interlaced_source_flag;
  guint8 non_packed_constraint_flag;
  guint8 frame_only_constraint_flag;
  guint8 level_idc;

  guint8 sub_layer_profile_present_flag[6];
  guint8 sub_layer_level_present_flag[6];

  guint8 sub_layer_profile_space[6];
  guint8 sub_layer_tier_flag[6];
  guint8 sub_layer_profile_idc[6];
  guint8 sub_layer_profile_compatibility_flag[6][32];
  guint8 sub_layer_progressive_source_flag[6];
  guint8 sub_layer_interlaced_source_flag[6];
  guint8 sub_layer_non_packed_constraint_flag[6];
  guint8 sub_layer_frame_only_constraint_flag[6];
  guint8 sub_layer_level_idc[6];
};

/**
 * GstH265SubLayerHRDParams:
 * @bit_rate_value_minus1:togeter with bit_rate_scale, it specifies
 *   the maximum input bitrate when the CPB operates at the access
 *   unit level
 * @cpb_size_value_minus1: is used together with cpb_size_scale to
 *   specify the CPB size when the CPB operates at the access unit
 *   level
 * @cpb_size_du_value_minus1: is used together with cpb_size_du_scale
 *   to specify the CPB size when the CPB operates at sub-picture
 *   level
 * @bit_rate_du_value_minus1: together with bit_rate_scale, it
 *   specifies the maximum input bit rate when the CPB operates at the
 *   sub-picture level
 * @cbr_flag: indicate whether HSS operates in intermittent bit rate
 *   mode or constant bit rate mode.
 *
 * Defines the Sublayer HRD parameters
 */
struct _GstH265SubLayerHRDParams
{
  guint32 bit_rate_value_minus1[32];
  guint32 cpb_size_value_minus1[32];

  guint32 cpb_size_du_value_minus1[32];
  guint32 bit_rate_du_value_minus1[32];

  guint8 cbr_flag[32];
};

/**
 * GstH265HRDParams:
 * @nal_hrd_parameters_present_flag: indicate the presence of NAL HRD parameters
 * @vcl_hrd_parameters_present_flag: indicate the presence of VCL HRD parameters
 * @sub_pic_hrd_params_present_flag: indicate the presence of sub_pic_hrd_params
 * @tick_divisor_minus2: is used to specify the clock sub-tick
 * @du_cpb_removal_delay_increment_length_minus1: specifies the length,
 *   in bits, of the nal_initial_cpb_removal_delay
 * @sub_pic_cpb_params_in_pic_timing_sei_flag: specifies the length, in bits, of
 *   the cpb_delay_offset and the au_cpb_removal_delay_minus1 syntax elements.
 * @dpb_output_delay_du_length_minu1: specifies the length, in bits, of the
 *   dpb_delay_offset and the pic_dpb_output_delay syntax elements
 * @bit_rate_scale: maximum input bitrate
 * @cpb_size_scale: CPB size when operates in access unit level
 * @cpb_size_du_scale: CPB size when operates in sub-picture level
 * @initial_cpb_removal_delay_length_minus1: specifies the length, in bits, of the
 *   nal_initial_cpb_removal_delay, nal_initial_cpb_removal_offset,
 *   vcl_initial_cpb_removal_delay and vcl_initial_cpb_removal_offset.
 * @au_cpb_removal_delay_length_minus1: specifies the length, in bits, of the
 *   cpb_delay_offset and the au_cpb_removal_delay_minus1 syntax elements
 * @dpb_output_delay_length_minus1: specifies the length, in bits, of the
 *   dpb_delay_offset and the pic_dpb_output_delay syntax elements
 * @fixed_pic_rate_general_flag: flag to indicate the presence of constraint
 *   on the temporal distance between the HRD output times of consecutive
 *   pictures in output order
 * @fixed_pic_rate_within_cvs_flag: same as fixed_pic_rate_general_flag
 * @elemental_duration_in_tc_minus1: temporal distance in clock ticks
 * @low_delay_hrd_flag: specifies the HRD operational mode
 * @cpb_cnt_minus1:specifies the number of alternative CPS specifications.
 * @sublayer_hrd_params: Sublayer HRD parameters.
 *
 * Defines the HRD parameters
 */
struct _GstH265HRDParams
{
  guint8 nal_hrd_parameters_present_flag;
  guint8 vcl_hrd_parameters_present_flag;
  guint8 sub_pic_hrd_params_present_flag;

  guint8 tick_divisor_minus2;
  guint8 du_cpb_removal_delay_increment_length_minus1;
  guint8 sub_pic_cpb_params_in_pic_timing_sei_flag;
  guint8 dpb_output_delay_du_length_minus1;

  guint8 bit_rate_scale;
  guint8 cpb_size_scale;
  guint8 cpb_size_du_scale;

  guint8 initial_cpb_removal_delay_length_minus1;
  guint8 au_cpb_removal_delay_length_minus1;
  guint8 dpb_output_delay_length_minus1;

  guint8 fixed_pic_rate_general_flag [7];
  guint8 fixed_pic_rate_within_cvs_flag [7];
  guint16 elemental_duration_in_tc_minus1 [7];
  guint8 low_delay_hrd_flag [7];
  guint8 cpb_cnt_minus1[7];

  GstH265SubLayerHRDParams sublayer_hrd_params[7];
};

/**
 * GstH265VPS:
 * @id: vps id
 * @max_layers_minus1: should be zero, but can be other values in future
 * @max_sub_layers_minus1:specifies the maximum number of temporal sub-layers
 * @temporal_id_nesting_flag: specifies whether inter prediction is
 *   additionally restricted
 * @profile_tier_level: ProfileTierLevel info
 * @sub_layer_ordering_info_present_flag: indicates the presense of
 *   vps_max_dec_pic_buffering_minus1, vps_max_num_reorder_pics and
 *   vps_max_latency_increase_plus1
 * @max_dec_pic_buffering_minus1: specifies the maximum required size
 *   of the decoded picture buffer
 * @max_num_reorder_pics: indicates the maximum allowed number of
 *   pictures that can precede any picture in the CVS in decoding
 *   order
 * @max_latency_increase_plus1: is used to compute the value of
 *   VpsMaxLatencyPictures
 * @max_layer_id: specifies the maximum allowed value of nuh_layer_id
 * @num_layer_sets_minus1: specifies the number of layer sets
 * @layer_id_included_flag: specifies whether a nuh_layer_id included
 *   in the layer identifier list
 * @timing_info_present_flag: indicate the presence of
 *   num_units_in_tick, time_scale, poc_proportional_to_timing_flag
 *   and num_hrd_parameters
 * @num_units_in_tick: number of time units in a tick
 * @time_scale: number of time units that pass in one second
 * @poc_proportional_to_timing_flag: indicate whether the picture
 *   order count is proportional to output timin
 * @num_ticks_poc_diff_one_minus1: specifies the number of clock ticks
 *   corresponding to a difference of picture order count values equal
 *   to 1
 * @num_hrd_parameters: number of hrd_parameters present
 * @hrd_layer_set_idx: index to the list of layer hrd params.
 * @hrd_params: the GstH265HRDParams list
 *
 * Defines the VPS parameters
 */
struct _GstH265VPS {
  guint8 id;

  guint8 max_layers_minus1;
  guint8 max_sub_layers_minus1;
  guint8 temporal_id_nesting_flag;

  GstH265ProfileTierLevel profile_tier_level;

  guint8 sub_layer_ordering_info_present_flag;
  guint8 max_dec_pic_buffering_minus1[GST_H265_MAX_SUB_LAYERS];
  guint8 max_num_reorder_pics[GST_H265_MAX_SUB_LAYERS];
  guint32 max_latency_increase_plus1[GST_H265_MAX_SUB_LAYERS];

  guint8 max_layer_id;
  guint16 num_layer_sets_minus1;

  guint8 timing_info_present_flag;
  guint32 num_units_in_tick;
  guint32 time_scale;
  guint8 poc_proportional_to_timing_flag;
  guint32 num_ticks_poc_diff_one_minus1;

  guint16 num_hrd_parameters;
  guint16 hrd_layer_set_idx;
  guint8 cprms_present_flag;

  GstH265HRDParams hrd_params;

  guint8 vps_extension;

  gboolean valid;
};
/**
 * GstH265ShortTermRefPicSet:
 * @inter_ref_pic_set_prediction_flag: %TRUE specifies that the stRpsIdx-th candidate
 *  short-term RPS is predicted from another candidate short-term RPS
 * @delta_idx_minus1: plus 1 specifies the difference between the value of source and
 *  candidate short term RPS.
 * @delta_rps_sign: delta_rps_sign and abs_delta_rps_minus1 together specify
 *  the value of the variable deltaRps.
 * @abs_delta_rps_minus1: delta_rps_sign and abs_delta_rps_minus1 together specify
 *  the value of the variable deltaRps
 *
 * Defines the #GstH265ShortTermRefPicSet params
 */
struct _GstH265ShortTermRefPicSet
{
  guint8 inter_ref_pic_set_prediction_flag;
  guint8 delta_idx_minus1;
  guint8 delta_rps_sign;
  guint16 abs_delta_rps_minus1;

  /* calculated values */
  guint8 NumDeltaPocs;
  guint8 NumNegativePics;
  guint8 NumPositivePics;
  guint8 UsedByCurrPicS0[16];
  guint8 UsedByCurrPicS1[16];
  gint32 DeltaPocS0[16];
  gint32 DeltaPocS1[16];
};

/**
 * GstH265VUIParams:
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
 * @neutral_chroma_indication_flag: %TRUE indicate that the value of chroma samples is equla
 *  to 1<<(BitDepthchrom-1).
 * @field_seq_flag: %TRUE indicate field and %FALSE indicate frame
 * @frame_field_info_present_flag: %TRUE indicate picture timing SEI messages are present for every
 *   picture and include the pic_struct, source_scan_type, and duplicate_flag syntax elements.
 * @default_display_window_flag: %TRUE indicate that the default display window parameters present
 * def_disp_win_left_offset:left offset of display rect
 * def_disp_win_right_offset: right offset of display rect
 * def_disp_win_top_offset: top offset of display rect
 * def_disp_win_bottom_offset: bottom offset of display rect
 * @timing_info_present_flag: %TRUE specifies that num_units_in_tick,
 *  time_scale and fixed_frame_rate_flag are present in the bitstream
 * @num_units_in_tick: is the number of time units of a clock operating at the frequency time_scale Hz
 * @time_scale: is the number of time units that pass in one second
 * @poc_proportional_to_timing_flag: %TRUE indicates that the picture order count value for each picture
 *  in the CVS that is not the first picture in the CVS, in decoding order, is proportional to the output
 *  time of the picture relative to the output time of the first picture in the CVS.
 * @num_ticks_poc_diff_one_minus1: plus 1 specifies the number of clock ticks corresponding to a
 *  difference of picture order count values equal to 1
 * @hrd_parameters_present_flag: %TRUE if hrd parameters present in the bitstream
 * @bitstream_restriction_flag: %TRUE specifies that the following coded video sequence bitstream restriction
 * parameters are present
 * @tiles_fixed_structure_flag: %TRUE indicates that each PPS that is active in the CVS has the same value
 *   of the syntax elements num_tile_columns_minus1, num_tile_rows_minus1, uniform_spacing_flag,
 *   column_width_minus1, row_height_minus1 and loop_filter_across_tiles_enabled_flag, when present
 * @motion_vectors_over_pic_boundaries_flag: %FALSE indicates that no sample outside the
 *  picture boundaries and no sample at a fractional sample position, %TRUE indicates that one or more
 *  samples outside picture boundaries may be used in inter prediction
 * @restricted_ref_pic_list_flag: %TRUE indicates that all P and B slices (when present) that belong to
 *  the same picture have an identical reference picture list 0, and that all B slices (when present)
 *   that belong to the same picture have an identical reference picture list 1
 * @min_spatial_segmentation_idc: when not equal to 0, establishes a bound on the maximum possible size
 *  of distinct coded spatial segmentation regions in the pictures of the CVS
 * @max_bytes_per_pic_denom: indicates a number of bytes not exceeded by the sum of the sizes of
 *  the VCL NAL units associated with any coded picture in the coded video sequence.
 * @max_bits_per_min_cu_denom: indicates an upper bound for the number of coded bits of coding_unit
 *  data for any coding block in any picture of the CVS
 * @log2_max_mv_length_horizontal: indicate the maximum absolute value of a decoded horizontal
 * motion vector component
 * @log2_max_mv_length_vertical: indicate the maximum absolute value of a decoded vertical
 *  motion vector component
 *
 * The structure representing the VUI parameters.
 */
struct _GstH265VUIParams
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

  guint8 neutral_chroma_indication_flag;
  guint8 field_seq_flag;
  guint8 frame_field_info_present_flag;
  guint8 default_display_window_flag;
  guint32 def_disp_win_left_offset;
  guint32 def_disp_win_right_offset;
  guint32 def_disp_win_top_offset;
  guint32 def_disp_win_bottom_offset;

  guint8 timing_info_present_flag;
  /* if timing_info_present_flag */
  guint32 num_units_in_tick;
  guint32 time_scale;
  guint8 poc_proportional_to_timing_flag;
  /* if poc_proportional_to_timing_flag */
  guint32 num_ticks_poc_diff_one_minus1;
  guint8 hrd_parameters_present_flag;
  /*if hrd_parameters_present_flat */
  GstH265HRDParams hrd_params;

  guint8 bitstream_restriction_flag;
  /*  if bitstream_restriction_flag */
  guint8 tiles_fixed_structure_flag;
  guint8 motion_vectors_over_pic_boundaries_flag;
  guint8 restricted_ref_pic_lists_flag;
  guint16 min_spatial_segmentation_idc;
  guint8 max_bytes_per_pic_denom;
  guint8 max_bits_per_min_cu_denom;
  guint8 log2_max_mv_length_horizontal;
  guint8 log2_max_mv_length_vertical;

  /* calculated values */
  guint par_n;
  guint par_d;
};

/**
 * GstH265ScalingList:
 * @scaling_list_dc_coef_minus8_16x16: this plus 8 specifies the DC
 *   Coefficient values for 16x16 scaling list
 * @scaling_list_dc_coef_minus8_32x32: this plus 8 specifies the DC
 *   Coefficient values for 32x32 scaling list
 * @scaling_lists_4x4: 4x4 scaling list
 * @scaling_lists_8x8: 8x8 scaling list
 * @scaling_lists_16x16: 16x16 scaling list
 * @guint8 scaling_lists_32x32: 32x32 scaling list
 *
 * Defines the GstH265ScalingList
 */
struct _GstH265ScalingList {

  gint16 scaling_list_dc_coef_minus8_16x16[6];
  gint16 scaling_list_dc_coef_minus8_32x32[2];

  guint8 scaling_lists_4x4 [6][16];
  guint8 scaling_lists_8x8 [6][64];
  guint8 scaling_lists_16x16 [6][64];
  guint8 scaling_lists_32x32 [2][64];
};

/**
 * GstH265SPS:
 * @id: The ID of the sequence parameter set
 * @profile_idc: indicate the profile to which the coded video sequence conforms
 *
 * H265 Sequence Parameter Set (SPS)
 */
struct _GstH265SPS
{
  guint8 id;

  GstH265VPS *vps;

  guint8 max_sub_layers_minus1;
  guint8 temporal_id_nesting_flag;

  GstH265ProfileTierLevel profile_tier_level;

  guint8 chroma_format_idc;
  guint8 separate_colour_plane_flag;
  guint16 pic_width_in_luma_samples;
  guint16 pic_height_in_luma_samples;

  guint8 conformance_window_flag;
  /* if conformance_window_flag */
  guint32 conf_win_left_offset;
  guint32 conf_win_right_offset;
  guint32 conf_win_top_offset;
  guint32 conf_win_bottom_offset;

  guint8 bit_depth_luma_minus8;
  guint8 bit_depth_chroma_minus8;
  guint8 log2_max_pic_order_cnt_lsb_minus4;

  guint8 sub_layer_ordering_info_present_flag;
  guint8 max_dec_pic_buffering_minus1[GST_H265_MAX_SUB_LAYERS];
  guint8 max_num_reorder_pics[GST_H265_MAX_SUB_LAYERS];
  guint8 max_latency_increase_plus1[GST_H265_MAX_SUB_LAYERS];

  guint8 log2_min_luma_coding_block_size_minus3;
  guint8 log2_diff_max_min_luma_coding_block_size;
  guint8 log2_min_transform_block_size_minus2;
  guint8 log2_diff_max_min_transform_block_size;
  guint8 max_transform_hierarchy_depth_inter;
  guint8 max_transform_hierarchy_depth_intra;

  guint8 scaling_list_enabled_flag;
  /* if scaling_list_enabled_flag */
  guint8 scaling_list_data_present_flag;

  GstH265ScalingList scaling_list;

  guint8 amp_enabled_flag;
  guint8 sample_adaptive_offset_enabled_flag;
  guint8 pcm_enabled_flag;
  /* if pcm_enabled_flag */
  guint8 pcm_sample_bit_depth_luma_minus1;
  guint8 pcm_sample_bit_depth_chroma_minus1;
  guint8 log2_min_pcm_luma_coding_block_size_minus3;
  guint8 log2_diff_max_min_pcm_luma_coding_block_size;
  guint8 pcm_loop_filter_disabled_flag;

  guint8 num_short_term_ref_pic_sets;
  GstH265ShortTermRefPicSet short_term_ref_pic_set[65];

  guint8 long_term_ref_pics_present_flag;
  /* if long_term_ref_pics_present_flag */
  guint8 num_long_term_ref_pics_sps;
  guint16 lt_ref_pic_poc_lsb_sps[32];
  guint8 used_by_curr_pic_lt_sps_flag[32];

  guint8 temporal_mvp_enabled_flag;
  guint8 strong_intra_smoothing_enabled_flag;
  guint8 vui_parameters_present_flag;

  /* if vui_parameters_present_flat */
  GstH265VUIParams vui_params;

  guint8 sps_extension_flag;

  /* calculated values */
  guint8 chroma_array_type;
  gint width, height;
  gint fps_num, fps_den;
  gboolean valid;
};

/**
 * GstH265PPS:
 *
 * H265 Picture Parameter Set
 */
struct _GstH265PPS
{
  guint id;

  GstH265SPS *sps;

  guint8 dependent_slice_segments_enabled_flag;
  guint8 output_flag_present_flag;
  guint8 num_extra_slice_header_bits;
  guint8 sign_data_hiding_enabled_flag;
  guint8 cabac_init_present_flag;
  guint8 num_ref_idx_l0_default_active_minus1;
  guint8 num_ref_idx_l1_default_active_minus1;
  gint8 init_qp_minus26;
  guint8 constrained_intra_pred_flag;
  guint8 transform_skip_enabled_flag;
  guint8 cu_qp_delta_enabled_flag;
  /*if cu_qp_delta_enabled_flag */
  guint8 diff_cu_qp_delta_depth;

  gint8 cb_qp_offset;
  gint8 cr_qp_offset;
  guint8 slice_chroma_qp_offsets_present_flag;
  guint8 weighted_pred_flag;
  guint8 weighted_bipred_flag;
  guint8 transquant_bypass_enabled_flag;
  guint8 tiles_enabled_flag;
  guint8 entropy_coding_sync_enabled_flag;

  guint8 num_tile_columns_minus1;
  guint8 num_tile_rows_minus1;
  guint8 uniform_spacing_flag;
  guint32 column_width_minus1[19];
  guint32 row_height_minus1[21];
  guint8 loop_filter_across_tiles_enabled_flag;

  guint8 loop_filter_across_slices_enabled_flag;
  guint8 deblocking_filter_control_present_flag;
  guint8 deblocking_filter_override_enabled_flag;
  guint8 deblocking_filter_disabled_flag;
  gint8 beta_offset_div2;
  gint8 tc_offset_div2;

  guint8 scaling_list_data_present_flag;

  GstH265ScalingList scaling_list;

  guint8 lists_modification_present_flag;
  guint8 log2_parallel_merge_level_minus2;
  guint8 slice_segment_header_extension_present_flag;

  guint8 pps_extension_flag;

  gboolean valid;
};

struct _GstH265RefPicListModification
{
  guint8 ref_pic_list_modification_flag_l0;
  guint32 list_entry_l0[15];
  guint8 ref_pic_list_modification_flag_l1;
  guint32 list_entry_l1[15];
};

struct _GstH265PredWeightTable
{
  guint8 luma_log2_weight_denom;
  gint8 delta_chroma_log2_weight_denom;

  guint8 luma_weight_l0_flag[15];
  guint8  chroma_weight_l0_flag[15];
  gint8 delta_luma_weight_l0[15];
  gint8 luma_offset_l0[15];
  gint8 delta_chroma_weight_l0 [15][2];
  gint16 delta_chroma_offset_l0 [15][2];

  guint8 luma_weight_l1_flag[15];
  guint8 chroma_weight_l1_flag[15];
  gint8 delta_luma_weight_l1[15];
  gint8 luma_offset_l1[15];
  gint8 delta_chroma_weight_l1[15][2];
  gint16 delta_chroma_offset_l1[15][2];
};

struct _GstH265SliceHdr
{
  guint8 first_slice_segment_in_pic_flag;
  guint8 no_output_of_prior_pics_flag;

  GstH265PPS *pps;

  guint8 dependent_slice_segment_flag;
  guint32 segment_address;

  guint8 type;

  guint8 pic_output_flag;
  guint8 colour_plane_id;
  guint16 pic_order_cnt_lsb;

  guint8  short_term_ref_pic_set_sps_flag;
  GstH265ShortTermRefPicSet short_term_ref_pic_sets;
  guint8 short_term_ref_pic_set_idx;

  guint8 num_long_term_sps;
  guint8 num_long_term_pics;
  guint8 lt_idx_sps[16];
  guint32 poc_lsb_lt[16];
  guint8 used_by_curr_pic_lt_flag[16];
  guint8 delta_poc_msb_present_flag[16];
  guint32 delta_poc_msb_cycle_lt[16];

  guint8 temporal_mvp_enabled_flag;
  guint8 sao_luma_flag;
  guint8 sao_chroma_flag;
  guint8 num_ref_idx_active_override_flag;
  guint8 num_ref_idx_l0_active_minus1;
  guint8 num_ref_idx_l1_active_minus1;

  GstH265RefPicListModification ref_pic_list_modification;

  guint8 mvd_l1_zero_flag;
  guint8 cabac_init_flag;
  guint8 collocated_from_l0_flag;
  guint8 collocated_ref_idx;

  GstH265PredWeightTable pred_weight_table;

  guint8 five_minus_max_num_merge_cand;

  gint8 qp_delta;
  gint8 cb_qp_offset;
  gint8 cr_qp_offset;

  guint8 deblocking_filter_override_flag;
  guint8 deblocking_filter_disabled_flag;
  gint8 beta_offset_div2;
  gint8 tc_offset_div2;

  guint8 loop_filter_across_slices_enabled_flag;

  guint32 num_entry_point_offsets;
  guint8 offset_len_minus1;
  guint32 *entry_point_offset_minus1;

  /* calculated values */

  gint NumPocTotalCurr;
  /* Size of the slice_header() in bits */
  guint header_size;
  /* Number of emulation prevention bytes (EPB) in this slice_header() */
  guint n_emulation_prevention_bytes;
};

struct _GstH265PicTiming
{
  guint8 pic_struct;
  guint8 source_scan_type;
  guint8 duplicate_flag;

  guint8 au_cpb_removal_delay_minus1;
  guint8 pic_dpb_output_delay;
  guint8 pic_dpb_output_du_delay;
  guint32 num_decoding_units_minus1;
  guint8 du_common_cpb_removal_delay_flag;
  guint8 du_common_cpb_removal_delay_increment_minus1;
  guint32 *num_nalus_in_du_minus1;
  guint8 *du_cpb_removal_delay_increment_minus1;
};

struct _GstH265BufferingPeriod
{
  GstH265SPS *sps;

  guint8 irap_cpb_params_present_flag;
  guint8 cpb_delay_offset;
  guint8 dpb_delay_offset;
  guint8 concatenation_flag;
  guint8 au_cpb_removal_delay_delta_minus1;

  /* seq->vui_parameters->nal_hrd_parameters_present_flag */
  guint8 nal_initial_cpb_removal_delay[32];
  guint8 nal_initial_cpb_removal_offset[32];
  guint8 nal_initial_alt_cpb_removal_delay[32];
  guint8 nal_initial_alt_cpb_removal_offset [32];

  /* seq->vui_parameters->vcl_hrd_parameters_present_flag */
  guint8 vcl_initial_cpb_removal_delay[32];
  guint8 vcl_initial_cpb_removal_offset[32];
  guint8 vcl_initial_alt_cpb_removal_delay[32];
  guint8 vcl_initial_alt_cpb_removal_offset[32];
};

struct _GstH265SEIMessage
{
  GstH265SEIPayloadType payloadType;

  union {
    GstH265BufferingPeriod buffering_period;
    GstH265PicTiming pic_timing;
    /* ... could implement more */
  } payload;
};

/**
 * GstH265Parser:
 *
 * H265 NAL Parser (opaque structure).
 */
struct _GstH265Parser
{
  /*< private >*/
  GstH265VPS vps[GST_H265_MAX_VPS_COUNT];
  GstH265SPS sps[GST_H265_MAX_SPS_COUNT];
  GstH265PPS pps[GST_H265_MAX_PPS_COUNT];
  GstH265VPS *last_vps;
  GstH265SPS *last_sps;
  GstH265PPS *last_pps;
};

GstH265Parser *     gst_h265_parser_new               (void);

GstH265ParserResult gst_h265_parser_identify_nalu      (GstH265Parser  * parser,
                                                        const guint8   * data,
                                                        guint            offset,
                                                        gsize            size,
                                                        GstH265NalUnit * nalu);

GstH265ParserResult gst_h265_parser_identify_nalu_unchecked (GstH265Parser * parser,
                                                        const guint8   * data,
                                                        guint            offset,
                                                        gsize            size,
                                                        GstH265NalUnit * nalu);

GstH265ParserResult gst_h265_parser_identify_nalu_hevc (GstH265Parser  * parser,
                                                        const guint8   * data,
                                                        guint            offset,
                                                        gsize            size,
                                                        guint8           nal_length_size,
                                                        GstH265NalUnit * nalu);

GstH265ParserResult gst_h265_parser_parse_nal       (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu);

GstH265ParserResult gst_h265_parser_parse_slice_hdr (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu,
                                                     GstH265SliceHdr * slice);

GstH265ParserResult gst_h265_parser_parse_vps       (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu,
                                                     GstH265VPS      * vps);

GstH265ParserResult gst_h265_parser_parse_sps       (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu,
                                                     GstH265SPS      * sps,
                                                     gboolean          parse_vui_params);

GstH265ParserResult gst_h265_parser_parse_pps       (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu,
                                                     GstH265PPS      * pps);

GstH265ParserResult gst_h265_parser_parse_sei       (GstH265Parser   * parser,
                                                     GstH265NalUnit  * nalu,
                                                     GstH265SEIMessage * sei);

void                gst_h265_parser_free            (GstH265Parser  * parser);

GstH265ParserResult gst_h265_parse_vps              (GstH265NalUnit * nalu,
                                                     GstH265VPS     * vps);

GstH265ParserResult gst_h265_parse_sps              (GstH265Parser  * parser,
                                                     GstH265NalUnit * nalu,
                                                     GstH265SPS     * sps,
                                                     gboolean         parse_vui_params);

GstH265ParserResult gst_h265_parse_pps              (GstH265Parser  * parser,
                                                     GstH265NalUnit * nalu,
                                                     GstH265PPS     * pps);

gboolean            gst_h265_slice_hdr_copy (GstH265SliceHdr       * dst_slice,
                                             const GstH265SliceHdr * src_slice);

void                gst_h265_slice_hdr_free (GstH265SliceHdr * slice_hdr);

gboolean            gst_h265_sei_copy       (GstH265SEIMessage       * dest_sei,
                                             const GstH265SEIMessage * src_sei);

void                gst_h265_sei_free       (GstH265SEIMessage * sei);

G_END_DECLS
#endif
