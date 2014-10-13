/* Gstreamer H.265 bitstream parser
 * Copyright (C) 2012 Intel Corporation
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

/**
 * SECTION:gsth265parser
 * @short_description: Convenience library for h265 video bitstream parsing.
 *
 * It offers you bitstream parsing in HEVC mode and non-HEVC mode. To identify
 * Nals in a bitstream and parse its headers, you should call:
 * <itemizedlist>
 *   <listitem>
 *      gst_h265_parser_identify_nalu() to identify the following nalu in
 *        non-HEVC bitstreams
 *   </listitem>
 *   <listitem>
 *      gst_h265_parser_identify_nalu_hevc() to identify the nalu in
 *        HEVC bitstreams
 *   </listitem>
 * </itemizedlist>
 *
 * Then, depending on the #GstH265NalUnitType of the newly parsed #GstH265NalUnit,
 * you should call the differents functions to parse the structure:
 * <itemizedlist>
 *   <listitem>
 *      From #GST_H265_NAL_SLICE_TRAIL_N to #GST_H265_NAL_SLICE_CRA_NUT: gst_h265_parser_parse_slice_hdr()
 *   </listitem>
 *   <listitem>
 *      #GST_H265_NAL_SEI: gst_h265_parser_parse_sei()
 *   </listitem>
 *   <listitem>
 *      #GST_H265_NAL_VPS: gst_h265_parser_parse_vps()
 *   </listitem>
 *   <listitem>
 *      #GST_H265_NAL_SPS: gst_h265_parser_parse_sps()
 *   </listitem>
 *   <listitem>
 *      #GST_H265_NAL_PPS: #gst_h265_parser_parse_pps()
 *   </listitem>
 *   <listitem>
 *      Any other: gst_h265_parser_parse_nal()
 *   </listitem>
 * </itemizedlist>
 *
 * Note: You should always call gst_h265_parser_parse_nal() if you don't
 * actually need #GstH265NalUnitType to be parsed for your personal use, in
 * order to guarantee that the #GstH265Parser is always up to date.
 *
 * For more details about the structures, look at the ITU-T H.265
 * specifications, you can download them from:
 *
 * <itemizedlist>
 *   <listitem>
 *     ITU-T H.265: http://www.itu.int/rec/T-REC-H.265
 *   </listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "nalutils.h"
#include "gsth265parser.h"

#include <gst/base/gstbytereader.h>
#include <gst/base/gstbitreader.h>
#include <string.h>
#include <math.h>

GST_DEBUG_CATEGORY (h265_parser_debug);
#define GST_CAT_DEFAULT h265_parser_debug

static gboolean initialized = FALSE;
#define INITIALIZE_DEBUG_CATEGORY \
  if (!initialized) { \
    GST_DEBUG_CATEGORY_INIT (h265_parser_debug, "codecparsers_h265", 0, \
        "h265 parser library"); \
    initialized = TRUE; \
  }

/**** Default scaling_lists according to Table 7-5 and 7-6 *****/

/* Table 7-5 */
static const guint8 default_scaling_list0[16] = {
  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
  16, 16, 16, 16
};

/*  Combined the values in Table  7-6 to make the calculation easier
 *  Default scaling list of 8x8 and 16x16 matrices for matrixId = 0, 1 and 2
 *  Default scaling list of 32x32 matrix for matrixId = 0
 */
static const guint8 default_scaling_list1[64] = {
  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16,
  17, 16, 17, 18, 17, 18, 18, 17, 18, 21, 19, 20,
  21, 20, 19, 21, 24, 22, 22, 24, 24, 22, 22, 24,
  25, 25, 27, 30, 27, 25, 25, 29, 31, 35, 35, 31,
  29, 36, 41, 44, 41, 36, 47, 54, 54, 47, 65, 70,
  65, 88, 88, 115
};

/*  Combined the values in Table 7-6 to make the calculation easier
 *  Default scaling list of 8x8 and 16x16 matrices for matrixId = 3, 4 and 5
 *  Default scaling list of 32x32 matrix for matrixId = 1
 */
static const guint8 default_scaling_list2[64] = {
  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17,
  17, 17, 17, 17, 18, 18, 18, 18, 18, 20, 20, 20,
  20, 20, 20, 20, 24, 24, 24, 24, 24, 24, 24, 24,
  25, 25, 25, 25, 25, 25, 25, 28, 28, 28, 28, 28,
  28, 33, 33, 33, 33, 33, 41, 41, 41, 41, 54, 54,
  54, 71, 71, 91
};

typedef struct
{
  guint par_n, par_d;
} PAR;

/* Table E-1 - Meaning of sample aspect ratio indicator (1..16) */
static PAR aspect_ratios[17] = {
  {0, 0},
  {1, 1},
  {12, 11},
  {10, 11},
  {16, 11},
  {40, 33},
  {24, 11},
  {20, 11},
  {32, 11},
  {80, 33},
  {18, 11},
  {15, 11},
  {64, 33},
  {160, 99},
  {4, 3},
  {3, 2},
  {2, 1}
};

/*****  Utils ****/
#define EXTENDED_SAR 255

static GstH265VPS *
gst_h265_parser_get_vps (GstH265Parser * parser, guint8 vps_id)
{
  GstH265VPS *vps;

  vps = &parser->vps[vps_id];

  if (vps->valid)
    return vps;

  return NULL;
}

static GstH265SPS *
gst_h265_parser_get_sps (GstH265Parser * parser, guint8 sps_id)
{
  GstH265SPS *sps;

  sps = &parser->sps[sps_id];

  if (sps->valid)
    return sps;

  return NULL;
}

static GstH265PPS *
gst_h265_parser_get_pps (GstH265Parser * parser, guint8 pps_id)
{
  GstH265PPS *pps;

  pps = &parser->pps[pps_id];

  if (pps->valid)
    return pps;

  return NULL;
}

static gboolean
gst_h265_parse_nalu_header (GstH265NalUnit * nalu)
{
  guint8 *data = nalu->data + nalu->offset;
  GstBitReader br;

  if (nalu->size < 2)
    return FALSE;

  gst_bit_reader_init (&br, data, nalu->size - nalu->offset);

  /* skip the forbidden_zero_bit */
  gst_bit_reader_skip_unchecked (&br, 1);

  nalu->type = gst_bit_reader_get_bits_uint8_unchecked (&br, 6);
  nalu->layer_id = gst_bit_reader_get_bits_uint8_unchecked (&br, 6);
  nalu->temporal_id_plus1 = gst_bit_reader_get_bits_uint8_unchecked (&br, 3);
  nalu->header_bytes = 2;

  return TRUE;
}

/****** Parsing functions *****/

static gboolean
gst_h265_parse_profile_tier_level (GstH265ProfileTierLevel * ptl,
    NalReader * nr, guint8 maxNumSubLayersMinus1)
{
  guint i, j;
  GST_DEBUG ("parsing \"ProfileTierLevel parameters\"");

  /* set default values for fields that might not be present in the
   * bitstream and have valid defaults */
  for (i = 0; i < maxNumSubLayersMinus1; i++)
    ptl->sub_layer_tier_flag[i] = 0;

  READ_UINT8 (nr, ptl->profile_space, 2);
  READ_UINT8 (nr, ptl->tier_flag, 1);
  READ_UINT8 (nr, ptl->profile_idc, 5);

  for (j = 0; j < 32; j++)
    READ_UINT8 (nr, ptl->profile_compatibility_flag[j], 1);

  READ_UINT8 (nr, ptl->progressive_source_flag, 1);
  READ_UINT8 (nr, ptl->interlaced_source_flag, 1);
  READ_UINT8 (nr, ptl->non_packed_constraint_flag, 1);
  READ_UINT8 (nr, ptl->frame_only_constraint_flag, 1);

  /* skip the reserved zero bits */
  if (!nal_reader_skip (nr, 44))
    goto error;

  READ_UINT8 (nr, ptl->level_idc, 8);
  for (j = 0; j < maxNumSubLayersMinus1; j++) {
    READ_UINT8 (nr, ptl->sub_layer_profile_present_flag[j], 1);
    READ_UINT8 (nr, ptl->sub_layer_level_present_flag[j], 1);
  }

  if (maxNumSubLayersMinus1 > 0) {
    for (i = maxNumSubLayersMinus1; i < 8; i++)
      if (!nal_reader_skip (nr, 2))
        goto error;
  }

  for (i = 0; i < maxNumSubLayersMinus1; i++) {
    if (ptl->sub_layer_profile_present_flag[i]) {
      READ_UINT8 (nr, ptl->sub_layer_profile_space[i], 2);
      READ_UINT8 (nr, ptl->sub_layer_tier_flag[i], 1);
      READ_UINT8 (nr, ptl->sub_layer_profile_idc[i], 5);

      for (j = 0; j < 32; j++)
        READ_UINT8 (nr, ptl->sub_layer_profile_compatibility_flag[i][j], 1);

      READ_UINT8 (nr, ptl->sub_layer_progressive_source_flag[i], 1);
      READ_UINT8 (nr, ptl->sub_layer_interlaced_source_flag[i], 1);
      READ_UINT8 (nr, ptl->sub_layer_non_packed_constraint_flag[i], 1);
      READ_UINT8 (nr, ptl->sub_layer_frame_only_constraint_flag[i], 1);

      if (!nal_reader_skip (nr, 44))
        goto error;
    }

    if (ptl->sub_layer_level_present_flag[i])
      READ_UINT8 (nr, ptl->sub_layer_level_idc[i], 8);
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"ProfileTierLevel Parameters\"");
  return FALSE;
}

static gboolean
gst_h265_parse_sub_layer_hrd_parameters (GstH265SubLayerHRDParams * sub_hrd,
    NalReader * nr, guint8 CpbCnt, guint8 sub_pic_hrd_params_present_flag)
{
  guint i;

  GST_DEBUG ("parsing \"SubLayer HRD Parameters\"");

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  for (i = 0; i <= CpbCnt; i++)
    sub_hrd->cbr_flag[i] = 0;

  for (i = 0; i <= CpbCnt; i++) {
    READ_UE_ALLOWED (nr, sub_hrd->bit_rate_value_minus1[i], 0, G_MAXUINT32 - 1);
    READ_UE_ALLOWED (nr, sub_hrd->cpb_size_value_minus1[i], 0, G_MAXUINT32 - 1);

    if (sub_pic_hrd_params_present_flag) {
      READ_UE_ALLOWED (nr, sub_hrd->cpb_size_du_value_minus1[i], 0,
          G_MAXUINT32 - 1);
      READ_UE_ALLOWED (nr, sub_hrd->bit_rate_du_value_minus1[i], 0,
          G_MAXUINT32 - 1);
    }

    READ_UINT8 (nr, sub_hrd->cbr_flag[i], 1);
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"SubLayerHRD Parameters \"");
  return FALSE;
}

static gboolean
gst_h265_parse_hrd_parameters (GstH265HRDParams * hrd, NalReader * nr,
    guint8 commonInfPresentFlag, guint8 maxNumSubLayersMinus1)
{
  guint i;

  GST_DEBUG ("parsing \"HRD Parameters\"");

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  hrd->sub_pic_hrd_params_present_flag = 0;
  hrd->sub_pic_cpb_params_in_pic_timing_sei_flag = 0;
  hrd->initial_cpb_removal_delay_length_minus1 = 23;
  hrd->au_cpb_removal_delay_length_minus1 = 23;
  hrd->dpb_output_delay_length_minus1 = 23;
  for (i = 0; i <= maxNumSubLayersMinus1; i++) {
    hrd->fixed_pic_rate_general_flag[i] = 0;
    hrd->low_delay_hrd_flag[i] = 0;
    hrd->cpb_cnt_minus1[i] = 0;
  }

  if (commonInfPresentFlag) {
    READ_UINT8 (nr, hrd->nal_hrd_parameters_present_flag, 1);
    READ_UINT8 (nr, hrd->vcl_hrd_parameters_present_flag, 1);

    if (hrd->nal_hrd_parameters_present_flag
        || hrd->vcl_hrd_parameters_present_flag) {

      READ_UINT8 (nr, hrd->sub_pic_hrd_params_present_flag, 1);

      if (hrd->sub_pic_hrd_params_present_flag) {
        READ_UINT8 (nr, hrd->tick_divisor_minus2, 8);
        READ_UINT8 (nr, hrd->du_cpb_removal_delay_increment_length_minus1, 5);
        READ_UINT8 (nr, hrd->sub_pic_cpb_params_in_pic_timing_sei_flag, 1);
        READ_UINT8 (nr, hrd->dpb_output_delay_du_length_minus1, 5);
      }

      READ_UINT8 (nr, hrd->bit_rate_scale, 4);
      READ_UINT8 (nr, hrd->cpb_size_scale, 4);

      if (hrd->sub_pic_hrd_params_present_flag)
        READ_UINT8 (nr, hrd->cpb_size_du_scale, 4);

      READ_UINT8 (nr, hrd->initial_cpb_removal_delay_length_minus1, 5);
      READ_UINT8 (nr, hrd->au_cpb_removal_delay_length_minus1, 5);
      READ_UINT8 (nr, hrd->dpb_output_delay_length_minus1, 5);
    }
  }

  for (i = 0; i <= maxNumSubLayersMinus1; i++) {
    READ_UINT8 (nr, hrd->fixed_pic_rate_general_flag[i], 1);

    if (!hrd->fixed_pic_rate_general_flag[i]) {
      READ_UINT8 (nr, hrd->fixed_pic_rate_within_cvs_flag[i], 1);
    } else
      hrd->fixed_pic_rate_within_cvs_flag[i] = 1;

    if (hrd->fixed_pic_rate_within_cvs_flag[i]) {
      READ_UE_ALLOWED (nr, hrd->elemental_duration_in_tc_minus1[i], 0, 2047);
    } else
      READ_UINT8 (nr, hrd->low_delay_hrd_flag[i], 1);

    if (!hrd->low_delay_hrd_flag[i])
      READ_UE_ALLOWED (nr, hrd->cpb_cnt_minus1[i], 0, 31);

    if (hrd->nal_hrd_parameters_present_flag)
      if (!gst_h265_parse_sub_layer_hrd_parameters (&hrd->sublayer_hrd_params
              [i], nr, hrd->cpb_cnt_minus1[i],
              hrd->sub_pic_hrd_params_present_flag))
        goto error;

    if (hrd->vcl_hrd_parameters_present_flag)
      if (!gst_h265_parse_sub_layer_hrd_parameters (&hrd->sublayer_hrd_params
              [i], nr, hrd->cpb_cnt_minus1[i],
              hrd->sub_pic_hrd_params_present_flag))
        goto error;
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"HRD Parameters\"");
  return FALSE;
}

static gboolean
gst_h265_parse_vui_parameters (GstH265SPS * sps, NalReader * nr)
{
  GstH265VUIParams *vui = &sps->vui_params;

  GST_DEBUG ("parsing \"VUI Parameters\"");

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  vui->aspect_ratio_idc = 0;
  vui->video_format = 5;
  vui->video_full_range_flag = 0;
  vui->colour_primaries = 2;
  vui->transfer_characteristics = 2;
  vui->matrix_coefficients = 2;
  vui->chroma_sample_loc_type_top_field = 0;
  vui->chroma_sample_loc_type_bottom_field = 0;
  vui->neutral_chroma_indication_flag = 0;
  vui->field_seq_flag = 0;
  vui->def_disp_win_left_offset = 0;
  vui->def_disp_win_right_offset = 0;
  vui->def_disp_win_top_offset = 0;
  vui->def_disp_win_bottom_offset = 0;
  vui->tiles_fixed_structure_flag = 0;
  vui->motion_vectors_over_pic_boundaries_flag = 1;
  vui->min_spatial_segmentation_idc = 0;
  vui->max_bytes_per_pic_denom = 2;
  vui->max_bits_per_min_cu_denom = 1;
  vui->log2_max_mv_length_horizontal = 15;
  vui->log2_max_mv_length_vertical = 15;
  vui->par_n = 0;
  vui->par_d = 0;

  if (sps && sps->profile_tier_level.progressive_source_flag
      && sps->profile_tier_level.interlaced_source_flag)
    vui->frame_field_info_present_flag = 1;
  else
    vui->frame_field_info_present_flag = 0;

  READ_UINT8 (nr, vui->aspect_ratio_info_present_flag, 1);
  if (vui->aspect_ratio_info_present_flag) {
    READ_UINT8 (nr, vui->aspect_ratio_idc, 8);
    if (vui->aspect_ratio_idc == EXTENDED_SAR) {
      READ_UINT16 (nr, vui->sar_width, 16);
      READ_UINT16 (nr, vui->sar_height, 16);
      vui->par_n = vui->sar_width;
      vui->par_d = vui->sar_height;
    } else if (vui->aspect_ratio_idc <= 16) {
      vui->par_n = aspect_ratios[vui->aspect_ratio_idc].par_n;
      vui->par_d = aspect_ratios[vui->aspect_ratio_idc].par_d;
    }
  }

  READ_UINT8 (nr, vui->overscan_info_present_flag, 1);
  if (vui->overscan_info_present_flag)
    READ_UINT8 (nr, vui->overscan_appropriate_flag, 1);

  READ_UINT8 (nr, vui->video_signal_type_present_flag, 1);
  if (vui->video_signal_type_present_flag) {

    READ_UINT8 (nr, vui->video_format, 3);
    READ_UINT8 (nr, vui->video_full_range_flag, 1);
    READ_UINT8 (nr, vui->colour_description_present_flag, 1);
    if (vui->colour_description_present_flag) {
      READ_UINT8 (nr, vui->colour_primaries, 8);
      READ_UINT8 (nr, vui->transfer_characteristics, 8);
      READ_UINT8 (nr, vui->matrix_coefficients, 8);
    }
  }

  READ_UINT8 (nr, vui->chroma_loc_info_present_flag, 1);
  if (vui->chroma_loc_info_present_flag) {
    READ_UE_ALLOWED (nr, vui->chroma_sample_loc_type_top_field, 0, 5);
    READ_UE_ALLOWED (nr, vui->chroma_sample_loc_type_bottom_field, 0, 5);
  }

  READ_UINT8 (nr, vui->neutral_chroma_indication_flag, 1);
  READ_UINT8 (nr, vui->field_seq_flag, 1);
  READ_UINT8 (nr, vui->frame_field_info_present_flag, 1);

  READ_UINT8 (nr, vui->default_display_window_flag, 1);
  if (vui->default_display_window_flag) {
    READ_UE (nr, vui->def_disp_win_left_offset);
    READ_UE (nr, vui->def_disp_win_right_offset);
    READ_UE (nr, vui->def_disp_win_top_offset);
    READ_UE (nr, vui->def_disp_win_bottom_offset);
  }

  READ_UINT8 (nr, vui->timing_info_present_flag, 1);
  if (vui->timing_info_present_flag) {
    READ_UINT32 (nr, vui->num_units_in_tick, 32);
    if (vui->num_units_in_tick == 0)
      GST_WARNING ("num_units_in_tick = 0 detected in stream "
          "(incompliant to H.265 E.2.1).");

    READ_UINT32 (nr, vui->time_scale, 32);
    if (vui->time_scale == 0)
      GST_WARNING ("time_scale = 0 detected in stream "
          "(incompliant to H.265 E.2.1).");

    READ_UINT8 (nr, vui->poc_proportional_to_timing_flag, 1);
    if (vui->poc_proportional_to_timing_flag)
      READ_UE_ALLOWED (nr, vui->num_ticks_poc_diff_one_minus1, 0,
          G_MAXUINT32 - 1);

    READ_UINT8 (nr, vui->hrd_parameters_present_flag, 1);
    if (vui->hrd_parameters_present_flag)
      if (!gst_h265_parse_hrd_parameters (&vui->hrd_params, nr, 1,
              sps->max_sub_layers_minus1))
        goto error;
  }

  READ_UINT8 (nr, vui->bitstream_restriction_flag, 1);
  if (vui->bitstream_restriction_flag) {
    READ_UINT8 (nr, vui->tiles_fixed_structure_flag, 1);
    READ_UINT8 (nr, vui->motion_vectors_over_pic_boundaries_flag, 1);
    READ_UINT8 (nr, vui->restricted_ref_pic_lists_flag, 1);
    READ_UE_ALLOWED (nr, vui->min_spatial_segmentation_idc, 0, 4096);
    READ_UE_ALLOWED (nr, vui->max_bytes_per_pic_denom, 0, 16);
    READ_UE_ALLOWED (nr, vui->max_bits_per_min_cu_denom, 0, 16);
    READ_UE_ALLOWED (nr, vui->log2_max_mv_length_horizontal, 0, 16);
    READ_UE_ALLOWED (nr, vui->log2_max_mv_length_vertical, 0, 15);
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"VUI Parameters\"");
  return FALSE;
}

static gboolean
get_scaling_list_params (GstH265ScalingList * dest_scaling_list,
    guint8 sizeId, guint8 matrixId, guint8 ** sl, guint8 * size,
    gint16 ** scaling_list_dc_coef_minus8)
{
  switch (sizeId) {
    case GST_H265_QUANT_MATIX_4X4:
      *sl = dest_scaling_list->scaling_lists_4x4[matrixId];
      if (size)
        *size = 16;
      break;
    case GST_H265_QUANT_MATIX_8X8:
      *sl = dest_scaling_list->scaling_lists_8x8[matrixId];
      if (size)
        *size = 64;
      break;
    case GST_H265_QUANT_MATIX_16X16:
      *sl = dest_scaling_list->scaling_lists_16x16[matrixId];
      if (size)
        *size = 64;
      if (scaling_list_dc_coef_minus8)
        *scaling_list_dc_coef_minus8 =
            dest_scaling_list->scaling_list_dc_coef_minus8_16x16;
      break;
    case GST_H265_QUANT_MATIX_32X32:
      *sl = dest_scaling_list->scaling_lists_32x32[matrixId];
      if (size)
        *size = 64;
      if (scaling_list_dc_coef_minus8)
        *scaling_list_dc_coef_minus8 =
            dest_scaling_list->scaling_list_dc_coef_minus8_32x32;
      break;
    default:
      return FALSE;
  }
  return TRUE;
}

static gboolean
get_default_scaling_lists (guint8 ** sl, guint8 sizeId, guint8 matrixId)
{
  switch (sizeId) {
    case GST_H265_QUANT_MATIX_4X4:
      memcpy (*sl, default_scaling_list0, 16);
      break;

    case GST_H265_QUANT_MATIX_8X8:
    case GST_H265_QUANT_MATIX_16X16:
      if (matrixId >= 0 && matrixId <= 2)
        memcpy (*sl, default_scaling_list1, 64);
      else
        memcpy (*sl, default_scaling_list2, 64);
      break;

    case GST_H265_QUANT_MATIX_32X32:
      if (matrixId == 0)
        memcpy (*sl, default_scaling_list1, 64);
      else
        memcpy (*sl, default_scaling_list2, 64);
      break;

    default:
      return FALSE;
      break;
  }
  return TRUE;
}

static gboolean
gst_h265_parser_parse_scaling_lists (NalReader * nr,
    GstH265ScalingList * dest_scaling_list, gboolean use_default)
{
  guint8 sizeId;
  guint8 matrixId;
  guint8 scaling_list_pred_mode_flag = 0;
  guint8 scaling_list_pred_matrix_id_delta = 0;
  guint8 size, i;

  GST_DEBUG ("parsing scaling lists");

  for (sizeId = 0; sizeId < 4; sizeId++) {
    for (matrixId = 0; matrixId < ((sizeId == 3) ? 2 : 6); matrixId++) {
      gint16 *scaling_list_dc_coef_minus8 = NULL;
      guint8 *sl;

      if (!get_scaling_list_params (dest_scaling_list, sizeId, matrixId, &sl,
              &size, &scaling_list_dc_coef_minus8))
        goto error;

      /* use_default_scaling_matrices forcefully which means,
       * sps_scaling_list_enabled_flag=TRUE,
       * sps_scaling_list_data_present_flag=FALSE,
       * pps_scaling_list_data_present_falg=FALSE */
      if (use_default) {
        if (!get_default_scaling_lists (&sl, sizeId, matrixId))
          goto error;

        /* Inferring the value of scaling_list_dc_coef_minus8 */
        if (sizeId > 1)
          scaling_list_dc_coef_minus8[matrixId] = 8;

      } else {
        READ_UINT8 (nr, scaling_list_pred_mode_flag, 1);

        if (!scaling_list_pred_mode_flag) {
          guint8 refMatrixId;

          READ_UE_ALLOWED (nr, scaling_list_pred_matrix_id_delta, 0, matrixId);

          if (!scaling_list_pred_matrix_id_delta) {
            if (!get_default_scaling_lists (&sl, sizeId, matrixId))
              goto error;

            /* Inferring the value of scaling_list_dc_coef_minus8 */
            if (sizeId > 1)
              scaling_list_dc_coef_minus8[matrixId] = 8;

          } else {
            guint8 *temp_sl;

            refMatrixId = matrixId - scaling_list_pred_matrix_id_delta; /* 7-30 */

            if (!get_scaling_list_params (dest_scaling_list, sizeId,
                    refMatrixId, &temp_sl, NULL, NULL))
              goto error;

            for (i = 0; i < size; i++)
              sl[i] = temp_sl[i];       /* 7-31 */


            /* Inferring the value of scaling_list_dc_coef_minus8 */
            if (sizeId > 1)
              scaling_list_dc_coef_minus8[matrixId] =
                  scaling_list_dc_coef_minus8[refMatrixId];
          }
        } else {
          guint8 nextCoef = 8;
          gint8 scaling_list_delta_coef;

          if (sizeId > 1) {
            READ_SE_ALLOWED (nr, scaling_list_dc_coef_minus8[matrixId], -7,
                247);
            nextCoef = scaling_list_dc_coef_minus8[matrixId] + 8;
          }

          for (i = 0; i < size; i++) {
            READ_SE_ALLOWED (nr, scaling_list_delta_coef, -128, 127);
            nextCoef = (nextCoef + scaling_list_delta_coef) & 0xff;
            sl[i] = nextCoef;
          }
        }
      }
    }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing scaling lists");
  return FALSE;
}

static gboolean
gst_h265_parser_parse_short_term_ref_pic_sets (GstH265ShortTermRefPicSet *
    stRPS, NalReader * nr, guint8 stRpsIdx, GstH265SPS * sps)
{
  guint8 num_short_term_ref_pic_sets;
  guint8 RefRpsIdx = 0;
  guint16 deltaRps = 0;
  guint8 use_delta_flag[16] = { 0 };
  guint8 used_by_curr_pic_flag[16] = { 0 };
  guint32 delta_poc_s0_minus1[16] = { 0 };
  guint32 delta_poc_s1_minus1[16] = { 0 };
  gint j, i = 0;
  gint dPoc;

  GST_DEBUG ("parsing \"ShortTermRefPicSetParameters\"");

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  stRPS->inter_ref_pic_set_prediction_flag = 0;
  stRPS->delta_idx_minus1 = 0;
  for (j = 0; j < 16; j++)
    use_delta_flag[j] = 1;

  num_short_term_ref_pic_sets = sps->num_short_term_ref_pic_sets;

  if (stRpsIdx != 0)
    READ_UINT8 (nr, stRPS->inter_ref_pic_set_prediction_flag, 1);

  if (stRPS->inter_ref_pic_set_prediction_flag) {
    GstH265ShortTermRefPicSet *RefRPS;

    if (stRpsIdx == num_short_term_ref_pic_sets)
      READ_UE_ALLOWED (nr, stRPS->delta_idx_minus1, 0, stRpsIdx - 1);

    READ_UINT8 (nr, stRPS->delta_rps_sign, 1);
    READ_UE_ALLOWED (nr, stRPS->abs_delta_rps_minus1, 0, 32767);

    RefRpsIdx = stRpsIdx - stRPS->delta_idx_minus1 - 1; /* 7-45 */
    deltaRps = (1 - 2 * stRPS->delta_rps_sign) * (stRPS->abs_delta_rps_minus1 + 1);     /* 7-46 */

    RefRPS = &sps->short_term_ref_pic_set[RefRpsIdx];

    for (j = 0; j <= RefRPS->NumDeltaPocs; j++) {
      READ_UINT8 (nr, used_by_curr_pic_flag[j], 1);
      if (!used_by_curr_pic_flag[j])
        READ_UINT8 (nr, use_delta_flag[j], 1);

      if (used_by_curr_pic_flag[j] || use_delta_flag[j])
        stRPS->NumDeltaPocs++;
    }

    /* 7-47: calcuate NumNegativePics, DeltaPocS0 and UsedByCurrPicS0 */
    i = 0;
    for (j = (RefRPS->NumPositivePics - 1); j >= 0; j--) {
      dPoc = RefRPS->DeltaPocS1[j] + deltaRps;
      if (dPoc < 0 && use_delta_flag[RefRPS->NumNegativePics + j]) {
        stRPS->DeltaPocS0[i] = dPoc;
        stRPS->UsedByCurrPicS0[i++] =
            used_by_curr_pic_flag[RefRPS->NumNegativePics + j];
      }
    }
    if (deltaRps < 0 && use_delta_flag[RefRPS->NumDeltaPocs]) {
      stRPS->DeltaPocS0[i] = deltaRps;
      stRPS->UsedByCurrPicS0[i++] = used_by_curr_pic_flag[RefRPS->NumDeltaPocs];
    }
    for (j = 0; j < RefRPS->NumNegativePics; j++) {
      dPoc = RefRPS->DeltaPocS0[j] + deltaRps;
      if (dPoc < 0 && use_delta_flag[j]) {
        stRPS->DeltaPocS0[i] = dPoc;
        stRPS->UsedByCurrPicS0[i++] = used_by_curr_pic_flag[j];
      }
    }
    stRPS->NumNegativePics = i;

    /* 7-48: calcuate NumPositivePics, DeltaPocS1 and UsedByCurrPicS1 */
    i = 0;
    for (j = (RefRPS->NumNegativePics - 1); j >= 0; j--) {
      dPoc = RefRPS->DeltaPocS0[j] + deltaRps;
      if (dPoc > 0 && use_delta_flag[j]) {
        stRPS->DeltaPocS1[i] = dPoc;
        stRPS->UsedByCurrPicS1[i++] = used_by_curr_pic_flag[j];
      }
    }
    if (deltaRps > 0 && use_delta_flag[RefRPS->NumDeltaPocs]) {
      stRPS->DeltaPocS1[i] = deltaRps;
      stRPS->UsedByCurrPicS1[i++] = used_by_curr_pic_flag[RefRPS->NumDeltaPocs];
    }
    for (j = 0; j < RefRPS->NumPositivePics; j++) {
      dPoc = RefRPS->DeltaPocS1[j] + deltaRps;
      if (dPoc > 0 && use_delta_flag[RefRPS->NumNegativePics + j]) {
        stRPS->DeltaPocS1[i] = dPoc;
        stRPS->UsedByCurrPicS1[i++] =
            used_by_curr_pic_flag[RefRPS->NumNegativePics + j];
      }
    }
    stRPS->NumPositivePics = i;

  } else {
    /* 7-49 */
    READ_UE_ALLOWED (nr, stRPS->NumNegativePics, 0,
        sps->max_dec_pic_buffering_minus1[sps->max_sub_layers_minus1]);

    /* 7-50 */
    READ_UE_ALLOWED (nr, stRPS->NumPositivePics, 0,
        (sps->max_dec_pic_buffering_minus1[sps->max_sub_layers_minus1] -
            stRPS->NumNegativePics));

    for (i = 0; i < stRPS->NumNegativePics; i++) {
      READ_UE_ALLOWED (nr, delta_poc_s0_minus1[i], 0, 32767);
      /* 7-51 */
      READ_UINT8 (nr, stRPS->UsedByCurrPicS0[i], 1);

      if (i == 0) {
        /* 7-53 */
        stRPS->DeltaPocS0[i] = -(delta_poc_s0_minus1[i] + 1);
      } else {
        /* 7-55 */
        stRPS->DeltaPocS0[i] =
            stRPS->DeltaPocS0[i - 1] - (delta_poc_s0_minus1[i] + 1);
      }
    }

    for (j = 0; j < stRPS->NumPositivePics; j++) {
      READ_UE_ALLOWED (nr, delta_poc_s1_minus1[j], 0, 32767);

      /* 7-52 */
      READ_UINT8 (nr, stRPS->UsedByCurrPicS1[j], 1);

      if (j == 0) {
        /* 7-54 */
        stRPS->DeltaPocS1[j] = delta_poc_s1_minus1[j] + 1;
      } else {
        /* 7-56 */
        stRPS->DeltaPocS1[j] =
            stRPS->DeltaPocS1[j - 1] + (delta_poc_s1_minus1[j] + 1);
      }
    }

    /* 7-57 */
    stRPS->NumDeltaPocs = stRPS->NumPositivePics + stRPS->NumNegativePics;
  }
  return TRUE;

error:
  GST_WARNING ("error parsing \"ShortTermRefPicSet Parameters\"");
  return FALSE;
}

static gboolean
gst_h265_slice_parse_ref_pic_list_modification (GstH265SliceHdr * slice,
    NalReader * nr, gint NumPocTotalCurr)
{
  guint i;
  GstH265RefPicListModification *rpl_mod = &slice->ref_pic_list_modification;
  const guint n = ceil_log2 (NumPocTotalCurr);

  /* set default values */
  rpl_mod->ref_pic_list_modification_flag_l0 = 0;
  rpl_mod->ref_pic_list_modification_flag_l1 = 0;
  for (i = 0; i < slice->num_ref_idx_l0_active_minus1; i++)
    rpl_mod->list_entry_l0[i] = 0;
  for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++)
    rpl_mod->list_entry_l1[i] = 0;

  READ_UINT8 (nr, rpl_mod->ref_pic_list_modification_flag_l0, 1);

  if (rpl_mod->ref_pic_list_modification_flag_l0) {
    for (i = 0; i < slice->num_ref_idx_l0_active_minus1; i++) {
      READ_UINT32 (nr, rpl_mod->list_entry_l0[i], n);
      CHECK_ALLOWED (rpl_mod->list_entry_l0[i], 0, (NumPocTotalCurr - 1));
    }
  }
  if (GST_H265_IS_B_SLICE (slice)) {
    READ_UINT8 (nr, rpl_mod->ref_pic_list_modification_flag_l1, 1);
    if (rpl_mod->ref_pic_list_modification_flag_l1)
      for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++) {
        READ_UINT32 (nr, rpl_mod->list_entry_l1[i], n);
        CHECK_ALLOWED (rpl_mod->list_entry_l1[i], 0, (NumPocTotalCurr - 1));
      }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"Prediction weight table\"");
  return FALSE;
}

static gboolean
gst_h265_slice_parse_pred_weight_table (GstH265SliceHdr * slice, NalReader * nr)
{
  GstH265PredWeightTable *p;
  gint i, j;
  GstH265PPS *pps = slice->pps;
  GstH265SPS *sps = pps->sps;

  GST_DEBUG ("parsing \"Prediction weight table\"");

  p = &slice->pred_weight_table;

  READ_UE_ALLOWED (nr, p->luma_log2_weight_denom, 0, 7);

  /* set default values */
  for (i = 0; i < G_N_ELEMENTS (p->chroma_weight_l0_flag); i++) {
    p->chroma_weight_l0_flag[i] = 0;
    p->luma_offset_l0[i] = 0;
  }

  if (GST_H265_IS_B_SLICE (slice)) {
    for (i = 0; i < G_N_ELEMENTS (p->luma_weight_l1_flag); i++) {
      p->chroma_weight_l1_flag[i] = 0;
      p->luma_offset_l1[i] = 0;
    }
  }

  if (sps->chroma_format_idc != 0)
    READ_SE_ALLOWED (nr, p->delta_chroma_log2_weight_denom, 0, 7);

  for (i = 0; i <= slice->num_ref_idx_l0_active_minus1; i++)
    READ_UINT8 (nr, p->luma_weight_l0_flag[i], 1);

  if (sps->chroma_format_idc != 0)
    for (i = 0; i <= slice->num_ref_idx_l0_active_minus1; i++)
      READ_UINT8 (nr, p->chroma_weight_l0_flag[i], 1);

  for (i = 0; i <= slice->num_ref_idx_l0_active_minus1; i++) {
    if (p->luma_weight_l0_flag[i]) {
      READ_SE_ALLOWED (nr, p->delta_luma_weight_l0[i], -128, 127);
      READ_SE_ALLOWED (nr, p->luma_offset_l0[i], -128, 127);
    }
    if (p->chroma_weight_l0_flag[i])
      for (j = 0; j < 2; j++) {
        READ_SE_ALLOWED (nr, p->delta_chroma_weight_l0[i][j], -128, 127);
        READ_SE_ALLOWED (nr, p->delta_chroma_offset_l0[i][j], -512, 511);
      }
  }

  if (GST_H265_IS_B_SLICE (slice)) {
    for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++)
      READ_UINT8 (nr, p->luma_weight_l1_flag[i], 1);
    if (sps->chroma_format_idc != 0)
      for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++)
        READ_UINT8 (nr, p->chroma_weight_l1_flag[i], 1);

    for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++) {
      if (p->luma_weight_l1_flag[i]) {
        READ_SE_ALLOWED (nr, p->delta_luma_weight_l1[i], -128, 127);
        READ_SE_ALLOWED (nr, p->luma_offset_l1[i], -128, 127);
      }
      if (p->chroma_weight_l1_flag[i])
        for (j = 0; j < 2; j++) {
          READ_SE_ALLOWED (nr, p->delta_chroma_weight_l1[i][j], -128, 127);
          READ_SE_ALLOWED (nr, p->delta_chroma_offset_l1[i][j], -512, 511);
        }
    }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"Prediction weight table\"");
  return FALSE;
}

static GstH265ParserResult
gst_h265_parser_parse_buffering_period (GstH265Parser * parser,
    GstH265BufferingPeriod * per, NalReader * nr)
{
  GstH265SPS *sps;
  guint8 sps_id;
  guint i;
  guint n;

  GST_DEBUG ("parsing \"Buffering period\"");

  READ_UE_ALLOWED (nr, sps_id, 0, GST_H265_MAX_SPS_COUNT - 1);
  sps = gst_h265_parser_get_sps (parser, sps_id);
  if (!sps) {
    GST_WARNING ("couldn't find associated sequence parameter set with id: %d",
        sps_id);
    return GST_H265_PARSER_BROKEN_LINK;
  }
  per->sps = sps;

  /* set default values if not present */
  per->irap_cpb_params_present_flag = 0;
  per->cpb_delay_offset = 0;
  per->dpb_delay_offset = 0;

  if (sps->vui_parameters_present_flag) {
    GstH265VUIParams *vui = &sps->vui_params;
    GstH265HRDParams *hrd = &vui->hrd_params;

    if (!hrd->sub_pic_hrd_params_present_flag)
      READ_UINT8 (nr, per->irap_cpb_params_present_flag, 1);

    if (per->irap_cpb_params_present_flag) {
      READ_UINT8 (nr, per->cpb_delay_offset,
          (hrd->au_cpb_removal_delay_length_minus1 + 1));
      READ_UINT8 (nr, per->dpb_delay_offset,
          (hrd->dpb_output_delay_length_minus1 + 1));
    }

    n = hrd->initial_cpb_removal_delay_length_minus1 + 1;

    READ_UINT8 (nr, per->concatenation_flag, 1);
    READ_UINT8 (nr, per->au_cpb_removal_delay_delta_minus1,
        (hrd->au_cpb_removal_delay_length_minus1 + 1));

    if (hrd->nal_hrd_parameters_present_flag) {
      for (i = 0; i <= hrd->cpb_cnt_minus1[i]; i++) {
        READ_UINT8 (nr, per->nal_initial_cpb_removal_delay[i], n);
        READ_UINT8 (nr, per->nal_initial_cpb_removal_offset[i], n);
        if (hrd->sub_pic_hrd_params_present_flag
            || per->irap_cpb_params_present_flag) {
          READ_UINT8 (nr, per->nal_initial_alt_cpb_removal_delay[i], n);
          READ_UINT8 (nr, per->nal_initial_alt_cpb_removal_offset[i], n);
        }
      }
    }

    if (hrd->vcl_hrd_parameters_present_flag) {
      for (i = 0; i <= hrd->cpb_cnt_minus1[i]; i++) {
        READ_UINT8 (nr, per->vcl_initial_cpb_removal_delay[i], n);
        READ_UINT8 (nr, per->vcl_initial_cpb_removal_offset[i], n);
        if (hrd->sub_pic_hrd_params_present_flag
            || per->irap_cpb_params_present_flag) {
          READ_UINT8 (nr, per->vcl_initial_alt_cpb_removal_delay[i], n);
          READ_UINT8 (nr, per->vcl_initial_alt_cpb_removal_offset[i], n);
        }
      }
    }

  }
  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Buffering period\"");
  return GST_H265_PARSER_ERROR;
}

static GstH265ParserResult
gst_h265_parser_parse_pic_timing (GstH265Parser * parser,
    GstH265PicTiming * tim, NalReader * nr)
{
  GstH265ProfileTierLevel *profile_tier_level;
  guint i;

  GST_DEBUG ("parsing \"Picture timing\"");
  if (!parser->last_sps || !parser->last_sps->valid) {
    GST_WARNING ("didn't get the associated sequence paramater set for the "
        "current access unit");
    goto error;
  }

  profile_tier_level = &parser->last_sps->profile_tier_level;

  /* set default values */
  tim->pic_struct = 0;
  if (!profile_tier_level->progressive_source_flag
      && profile_tier_level->interlaced_source_flag)
    tim->source_scan_type = 0;
  else if (profile_tier_level->progressive_source_flag
      && !profile_tier_level->interlaced_source_flag)
    tim->source_scan_type = 1;
  else
    tim->source_scan_type = 2;

  if (parser->last_sps->vui_parameters_present_flag) {
    GstH265VUIParams *vui = &parser->last_sps->vui_params;

    if (vui->frame_field_info_present_flag) {
      READ_UINT8 (nr, tim->pic_struct, 4);
      READ_UINT8 (nr, tim->source_scan_type, 2);
      READ_UINT8 (nr, tim->duplicate_flag, 1);
    } else {
      /* set default values */
      tim->pic_struct = 0;
    }

    if (vui->hrd_parameters_present_flag) {
      GstH265HRDParams *hrd = &vui->hrd_params;

      READ_UINT8 (nr, tim->au_cpb_removal_delay_minus1,
          (hrd->au_cpb_removal_delay_length_minus1 + 1));
      READ_UINT8 (nr, tim->pic_dpb_output_delay,
          (hrd->dpb_output_delay_length_minus1 + 1));

      if (hrd->sub_pic_hrd_params_present_flag)
        READ_UINT8 (nr, tim->pic_dpb_output_du_delay,
            (hrd->dpb_output_delay_du_length_minus1 + 1));

      if (hrd->sub_pic_hrd_params_present_flag
          && hrd->sub_pic_cpb_params_in_pic_timing_sei_flag) {
        READ_UE (nr, tim->num_decoding_units_minus1);

        READ_UINT8 (nr, tim->du_common_cpb_removal_delay_flag, 1);
        if (tim->du_common_cpb_removal_delay_flag)
          READ_UINT8 (nr, tim->du_common_cpb_removal_delay_increment_minus1,
              (hrd->du_cpb_removal_delay_increment_length_minus1 + 1));

        tim->num_nalus_in_du_minus1 =
            g_new0 (guint32, (tim->num_decoding_units_minus1 + 1));
        tim->du_cpb_removal_delay_increment_minus1 =
            g_new0 (guint8, (tim->num_decoding_units_minus1 + 1));

        for (i = 0; i <= (tim->num_decoding_units_minus1 + 1); i++) {
          READ_UE (nr, tim->num_nalus_in_du_minus1[i]);

          if (!tim->du_common_cpb_removal_delay_flag
              && (i < tim->num_decoding_units_minus1))
            READ_UINT8 (nr, tim->du_cpb_removal_delay_increment_minus1[i],
                (hrd->du_cpb_removal_delay_increment_length_minus1 + 1));
        }
      }
    }
  }
  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Picture timing\"");
  return GST_H265_PARSER_ERROR;
}

/******** API *************/

/**
 * gst_h265_parser_new:
 *
 * Creates a new #GstH265Parser. It should be freed with
 * gst_h265_parser_free after use.
 *
 * Returns: a new #GstH265Parser
 */
GstH265Parser *
gst_h265_parser_new (void)
{
  GstH265Parser *parser;

  parser = g_slice_new0 (GstH265Parser);
  INITIALIZE_DEBUG_CATEGORY;

  return parser;
}

/**
 * gst_h265_parser_free:
 * @parser: the #GstH265Parser to free
 *
 * Frees @parser and sets it to %NULL
 */
void
gst_h265_parser_free (GstH265Parser * parser)
{
  g_slice_free (GstH265Parser, parser);
  parser = NULL;
}

/**
 * gst_h265_parser_identify_nalu_unchecked:
 * @parser: a #GstH265Parser
 * @data: The data to parse
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nalu: The #GstH265NalUnit where to store parsed nal headers
 *
 * Parses @data and fills @nalu from the next nalu data from @data.
 *
 * This differs from @gst_h265_parser_identify_nalu in that it doesn't
 * check whether the packet is complete or not.
 *
 * Note: Only use this function if you already know the provided @data
 * is a complete NALU, else use @gst_h265_parser_identify_nalu.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_identify_nalu_unchecked (GstH265Parser * parser,
    const guint8 * data, guint offset, gsize size, GstH265NalUnit * nalu)
{
  gint off1;

  if (size < offset + 4) {
    GST_DEBUG ("Can't parse, buffer has too small size %" G_GSIZE_FORMAT
        ", offset %u", size, offset);
    return GST_H265_PARSER_ERROR;
  }

  off1 = scan_for_start_codes (data + offset, size - offset);

  if (off1 < 0) {
    GST_DEBUG ("No start code prefix in this buffer");
    return GST_H265_PARSER_NO_NAL;
  }

  if (offset + off1 == size - 1) {
    GST_DEBUG ("Missing data to identify nal unit");

    return GST_H265_PARSER_ERROR;
  }

  nalu->sc_offset = offset + off1;

  /* sc might have 2 or 3 0-bytes */
  if (nalu->sc_offset > 0 && data[nalu->sc_offset - 1] == 00)
    nalu->sc_offset--;

  nalu->offset = offset + off1 + 3;
  nalu->data = (guint8 *) data;
  nalu->size = size - nalu->offset;

  if (!gst_h265_parse_nalu_header (nalu)) {
    GST_WARNING ("error parsing \"NAL unit header\"");
    nalu->size = 0;
    return GST_H265_PARSER_BROKEN_DATA;
  }

  nalu->valid = TRUE;

  if (nalu->type == GST_H265_NAL_EOS || nalu->type == GST_H265_NAL_EOB) {
    GST_DEBUG ("end-of-seq or end-of-stream nal found");
    nalu->size = 0;
    return GST_H265_PARSER_OK;
  }

  return GST_H265_PARSER_OK;
}

/**
 * gst_h265_parser_identify_nalu:
 * @parser: a #GstH265Parser
 * @data: The data to parse
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nalu: The #GstH265NalUnit where to store parsed nal headers
 *
 * Parses @data and fills @nalu from the next nalu data from @data
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_identify_nalu (GstH265Parser * parser,
    const guint8 * data, guint offset, gsize size, GstH265NalUnit * nalu)
{
  GstH265ParserResult res;
  gint off2;

  res =
      gst_h265_parser_identify_nalu_unchecked (parser, data, offset, size,
      nalu);

  if (res != GST_H265_PARSER_OK || nalu->size == 0)
    goto beach;

  off2 = scan_for_start_codes (data + nalu->offset, size - nalu->offset);
  if (off2 < 0) {
    GST_DEBUG ("Nal start %d, No end found", nalu->offset);

    return GST_H265_PARSER_NO_NAL_END;
  }

  /* Mini performance improvement:
   * We could have a way to store how many 0s were skipped to avoid
   * parsing them again on the next NAL */
  while (off2 > 0 && data[nalu->offset + off2 - 1] == 00)
    off2--;

  nalu->size = off2;
  if (nalu->size < 2)
    return GST_H265_PARSER_BROKEN_DATA;

  GST_DEBUG ("Complete nal found. Off: %d, Size: %d", nalu->offset, nalu->size);

beach:
  return res;
}

/**
 * gst_h265_parser_identify_nalu_hevc:
 * @parser: a #GstH265Parser
 * @data: The data to parse, must be the beging of the Nal unit
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nal_length_size: the size in bytes of the HEVC nal length prefix.
 * @nalu: The #GstH265NalUnit where to store parsed nal headers
 *
 * Parses @data and sets @nalu.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_identify_nalu_hevc (GstH265Parser * parser,
    const guint8 * data, guint offset, gsize size, guint8 nal_length_size,
    GstH265NalUnit * nalu)
{
  GstBitReader br;

  if (size < offset + nal_length_size) {
    GST_DEBUG ("Can't parse, buffer has too small size %" G_GSIZE_FORMAT
        ", offset %u", size, offset);
    return GST_H265_PARSER_ERROR;
  }

  size = size - offset;
  gst_bit_reader_init (&br, data + offset, size);

  nalu->size = gst_bit_reader_get_bits_uint32_unchecked (&br,
      nal_length_size * 8);
  nalu->sc_offset = offset;
  nalu->offset = offset + nal_length_size;

  if (size < nalu->size + nal_length_size) {
    nalu->size = 0;

    return GST_H265_PARSER_NO_NAL_END;
  }

  nalu->data = (guint8 *) data;

  if (!gst_h265_parse_nalu_header (nalu)) {
    GST_WARNING ("error parsing \"NAL unit header\"");
    nalu->size = 0;
    return GST_H265_PARSER_BROKEN_DATA;
  }

  if (nalu->size < 2)
    return GST_H265_PARSER_BROKEN_DATA;

  nalu->valid = TRUE;

  return GST_H265_PARSER_OK;
}

/**
 * gst_h265_parser_parse_nal:
 * @parser: a #GstH265Parser
 * @nalu: The #GstH265NalUnit to parse
 *
 * This function should be called in the case one doesn't need to
 * parse a specific structure. It is necessary to do so to make
 * sure @parser is up to date.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_nal (GstH265Parser * parser, GstH265NalUnit * nalu)
{
  GstH265VPS vps;
  GstH265SPS sps;
  GstH265PPS pps;

  switch (nalu->type) {
    case GST_H265_NAL_VPS:
      return gst_h265_parser_parse_vps (parser, nalu, &vps);
      break;
    case GST_H265_NAL_SPS:
      return gst_h265_parser_parse_sps (parser, nalu, &sps, FALSE);
      break;
    case GST_H265_NAL_PPS:
      return gst_h265_parser_parse_pps (parser, nalu, &pps);
  }

  return GST_H265_PARSER_OK;
}

/**
 * gst_h265_parser_parse_vps:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_VPS #GstH265NalUnit to parse
 * @vps: The #GstH265VPS to fill.
 *
 * Parses @data, and fills the @vps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_vps (GstH265Parser * parser, GstH265NalUnit * nalu,
    GstH265VPS * vps)
{
  GstH265ParserResult res = gst_h265_parse_vps (nalu, vps);

  if (res == GST_H265_PARSER_OK) {
    GST_DEBUG ("adding video parameter set with id: %d to array", vps->id);

    parser->vps[vps->id] = *vps;
    parser->last_vps = &parser->vps[vps->id];
  }

  return res;
}

/**
 * gst_h265_parse_vps:
 * @nalu: The #GST_H265_NAL_VPS #GstH265NalUnit to parse
 * @sps: The #GstH265VPS to fill.
 *
 * Parses @data, and fills the @vps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parse_vps (GstH265NalUnit * nalu, GstH265VPS * vps)
{
  NalReader nr;
  guint i, j;

  INITIALIZE_DEBUG_CATEGORY;
  GST_DEBUG ("parsing VPS");

  nal_reader_init (&nr, nalu->data + nalu->offset + nalu->header_bytes,
      nalu->size - nalu->header_bytes);

  memset (&vps->profile_tier_level, 0, sizeof (vps->profile_tier_level));
  memset (&vps->hrd_params, 0, sizeof (vps->hrd_params));
  vps->cprms_present_flag = 1;

  READ_UINT8 (&nr, vps->id, 4);

  /* skip reserved_three_2bits */
  if (!nal_reader_skip (&nr, 2))
    goto error;

  READ_UINT8 (&nr, vps->max_layers_minus1, 6);
  READ_UINT8 (&nr, vps->max_sub_layers_minus1, 3);
  READ_UINT8 (&nr, vps->temporal_id_nesting_flag, 1);

  /* skip reserved_0xffff_16bits */
  if (!nal_reader_skip (&nr, 16))
    goto error;

  if (!gst_h265_parse_profile_tier_level (&vps->profile_tier_level, &nr,
          vps->max_sub_layers_minus1))
    goto error;

  READ_UINT8 (&nr, vps->sub_layer_ordering_info_present_flag, 1);

  for (i =
      (vps->sub_layer_ordering_info_present_flag ? 0 :
          vps->max_sub_layers_minus1); i <= vps->max_sub_layers_minus1; i++) {
    READ_UE_ALLOWED (&nr, vps->max_dec_pic_buffering_minus1[i], 0,
        G_MAXUINT32 - 1);
    READ_UE_ALLOWED (&nr, vps->max_num_reorder_pics[i], 0,
        vps->max_dec_pic_buffering_minus1[i]);
    READ_UE_ALLOWED (&nr, vps->max_latency_increase_plus1[i], 0,
        G_MAXUINT32 - 1);
  }
  /* setting default values if vps->sub_layer_ordering_info_present_flag is zero */
  if (!vps->sub_layer_ordering_info_present_flag && vps->max_sub_layers_minus1) {
    for (i = 0; i <= (vps->max_sub_layers_minus1 - 1); i++) {
      vps->max_dec_pic_buffering_minus1[i] =
          vps->max_dec_pic_buffering_minus1[vps->max_sub_layers_minus1];
      vps->max_num_reorder_pics[i] =
          vps->max_num_reorder_pics[vps->max_sub_layers_minus1];
      vps->max_latency_increase_plus1[i] =
          vps->max_latency_increase_plus1[vps->max_sub_layers_minus1];
    }
  }

  READ_UINT8 (&nr, vps->max_layer_id, 6);
  CHECK_ALLOWED (vps->max_layer_id, 0, 0);

  READ_UE_ALLOWED (&nr, vps->num_layer_sets_minus1, 0, 1023);
  CHECK_ALLOWED (vps->num_layer_sets_minus1, 0, 0);

  for (i = 1; i <= vps->num_layer_sets_minus1; i++)
    for (j = 0; j <= vps->max_layer_id; j++)
      nal_reader_skip (&nr, 1);

  READ_UINT8 (&nr, vps->timing_info_present_flag, 1);

  if (vps->timing_info_present_flag) {
    READ_UINT32 (&nr, vps->num_units_in_tick, 32);
    READ_UINT32 (&nr, vps->time_scale, 32);
    READ_UINT8 (&nr, vps->poc_proportional_to_timing_flag, 1);

    if (vps->poc_proportional_to_timing_flag)
      READ_UE_ALLOWED (&nr, vps->num_ticks_poc_diff_one_minus1, 0,
          G_MAXUINT32 - 1);

    READ_UE_ALLOWED (&nr, vps->num_hrd_parameters, 0, 1024);
    CHECK_ALLOWED (vps->num_hrd_parameters, 0, 1);

    if (vps->num_hrd_parameters) {
      READ_UE_ALLOWED (&nr, vps->hrd_layer_set_idx, 0, 1023);
      CHECK_ALLOWED (vps->hrd_layer_set_idx, 0, 0);

      if (!gst_h265_parse_hrd_parameters (&vps->hrd_params, &nr,
              vps->cprms_present_flag, vps->max_sub_layers_minus1))
        goto error;
    }
  }
  READ_UINT8 (&nr, vps->vps_extension, 1);
  vps->valid = TRUE;

  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Video parameter set\"");
  vps->valid = FALSE;
  return GST_H265_PARSER_ERROR;
}

/**
 * gst_h265_parser_parse_sps:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_SPS #GstH265NalUnit to parse
 * @sps: The #GstH265SPS to fill.
 * @parse_vui_params: Whether to parse the vui_params or not
 *
 * Parses @data, and fills the @sps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_sps (GstH265Parser * parser, GstH265NalUnit * nalu,
    GstH265SPS * sps, gboolean parse_vui_params)
{
  GstH265ParserResult res =
      gst_h265_parse_sps (parser, nalu, sps, parse_vui_params);

  if (res == GST_H265_PARSER_OK) {
    GST_DEBUG ("adding sequence parameter set with id: %d to array", sps->id);

    parser->sps[sps->id] = *sps;
    parser->last_sps = &parser->sps[sps->id];
  }

  return res;
}

/**
 * gst_h265_parse_sps:
 * parser: The #GstH265Parser
 * @nalu: The #GST_H265_NAL_SPS #GstH265NalUnit to parse
 * @sps: The #GstH265SPS to fill.
 * @parse_vui_params: Whether to parse the vui_params or not
 *
 * Parses @data, and fills the @sps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parse_sps (GstH265Parser * parser, GstH265NalUnit * nalu,
    GstH265SPS * sps, gboolean parse_vui_params)
{
  NalReader nr;
  GstH265VPS *vps;
  guint8 vps_id;
  guint i;
  GstH265VUIParams *vui = NULL;

  INITIALIZE_DEBUG_CATEGORY;
  GST_DEBUG ("parsing SPS");

  nal_reader_init (&nr, nalu->data + nalu->offset + nalu->header_bytes,
      nalu->size - nalu->header_bytes);

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  memset (&sps->profile_tier_level, 0, sizeof (sps->profile_tier_level));
  memset (sps->short_term_ref_pic_set, 0, sizeof (sps->short_term_ref_pic_set));
  sps->scaling_list_data_present_flag = 0;
  sps->separate_colour_plane_flag = 0;
  sps->conf_win_left_offset = 0;
  sps->conf_win_right_offset = 0;
  sps->conf_win_top_offset = 0;
  sps->conf_win_bottom_offset = 0;
  sps->pcm_loop_filter_disabled_flag = 0;

  READ_UINT8 (&nr, vps_id, 4);
  vps = gst_h265_parser_get_vps (parser, vps_id);
  if (!vps) {
    GST_DEBUG ("couldn't find associated video parameter set with id: %d",
        vps_id);
  }
  sps->vps = vps;

  READ_UINT8 (&nr, sps->max_sub_layers_minus1, 3);
  READ_UINT8 (&nr, sps->temporal_id_nesting_flag, 1);

  if (!gst_h265_parse_profile_tier_level (&sps->profile_tier_level, &nr,
          sps->max_sub_layers_minus1))
    goto error;

  READ_UE_ALLOWED (&nr, sps->id, 0, GST_H265_MAX_SPS_COUNT - 1);

  READ_UE_ALLOWED (&nr, sps->chroma_format_idc, 0, 3);
  if (sps->chroma_format_idc == 3)
    READ_UINT8 (&nr, sps->separate_colour_plane_flag, 1);

  READ_UE_ALLOWED (&nr, sps->pic_width_in_luma_samples, 1, 16888);
  READ_UE_ALLOWED (&nr, sps->pic_height_in_luma_samples, 1, 16888);

  READ_UINT8 (&nr, sps->conformance_window_flag, 1);
  if (sps->conformance_window_flag) {
    READ_UE (&nr, sps->conf_win_left_offset);
    READ_UE (&nr, sps->conf_win_right_offset);
    READ_UE (&nr, sps->conf_win_top_offset);
    READ_UE (&nr, sps->conf_win_bottom_offset);
  }

  READ_UE_ALLOWED (&nr, sps->bit_depth_luma_minus8, 0, 6);
  READ_UE_ALLOWED (&nr, sps->bit_depth_chroma_minus8, 0, 6);
  READ_UE_ALLOWED (&nr, sps->log2_max_pic_order_cnt_lsb_minus4, 0, 12);

  READ_UINT8 (&nr, sps->sub_layer_ordering_info_present_flag, 1);
  for (i =
      (sps->sub_layer_ordering_info_present_flag ? 0 :
          sps->max_sub_layers_minus1); i <= sps->max_sub_layers_minus1; i++) {
    READ_UE_ALLOWED (&nr, sps->max_dec_pic_buffering_minus1[i], 0, 16);
    READ_UE_ALLOWED (&nr, sps->max_num_reorder_pics[i], 0,
        sps->max_dec_pic_buffering_minus1[i]);
    READ_UE_ALLOWED (&nr, sps->max_latency_increase_plus1[i], 0,
        G_MAXUINT32 - 1);
  }
  /* setting default values if sps->sub_layer_ordering_info_present_flag is zero */
  if (!sps->sub_layer_ordering_info_present_flag && sps->max_sub_layers_minus1) {
    for (i = 0; i <= (sps->max_sub_layers_minus1 - 1); i++) {
      sps->max_dec_pic_buffering_minus1[i] =
          sps->max_dec_pic_buffering_minus1[sps->max_sub_layers_minus1];
      sps->max_num_reorder_pics[i] =
          sps->max_num_reorder_pics[sps->max_sub_layers_minus1];
      sps->max_latency_increase_plus1[i] =
          sps->max_latency_increase_plus1[sps->max_sub_layers_minus1];
    }
  }

  /* The limits are calculted based on the profile_tier_level constraint
   * in Annex-A: CtbLog2SizeY = 4 to 6 */
  READ_UE_ALLOWED (&nr, sps->log2_min_luma_coding_block_size_minus3, 0, 3);
  READ_UE_ALLOWED (&nr, sps->log2_diff_max_min_luma_coding_block_size, 0, 6);
  READ_UE_ALLOWED (&nr, sps->log2_min_transform_block_size_minus2, 0, 3);
  READ_UE_ALLOWED (&nr, sps->log2_diff_max_min_transform_block_size, 0, 3);
  READ_UE_ALLOWED (&nr, sps->max_transform_hierarchy_depth_inter, 0, 4);
  READ_UE_ALLOWED (&nr, sps->max_transform_hierarchy_depth_intra, 0, 4);

  READ_UINT8 (&nr, sps->scaling_list_enabled_flag, 1);
  if (sps->scaling_list_enabled_flag) {
    READ_UINT8 (&nr, sps->scaling_list_data_present_flag, 1);

    if (sps->scaling_list_data_present_flag)
      if (!gst_h265_parser_parse_scaling_lists (&nr, &sps->scaling_list, FALSE))
        goto error;
  }

  READ_UINT8 (&nr, sps->amp_enabled_flag, 1);
  READ_UINT8 (&nr, sps->sample_adaptive_offset_enabled_flag, 1);
  READ_UINT8 (&nr, sps->pcm_enabled_flag, 1);

  if (sps->pcm_enabled_flag) {
    READ_UINT8 (&nr, sps->pcm_sample_bit_depth_luma_minus1, 4);
    READ_UINT8 (&nr, sps->pcm_sample_bit_depth_chroma_minus1, 4);
    READ_UE_ALLOWED (&nr, sps->log2_min_pcm_luma_coding_block_size_minus3, 0,
        2);
    READ_UE_ALLOWED (&nr, sps->log2_diff_max_min_pcm_luma_coding_block_size, 0,
        2);
    READ_UINT8 (&nr, sps->pcm_loop_filter_disabled_flag, 1);
  }

  READ_UE_ALLOWED (&nr, sps->num_short_term_ref_pic_sets, 0, 64);
  for (i = 0; i < sps->num_short_term_ref_pic_sets; i++)
    if (!gst_h265_parser_parse_short_term_ref_pic_sets
        (&sps->short_term_ref_pic_set[i], &nr, i, sps))
      goto error;

  READ_UINT8 (&nr, sps->long_term_ref_pics_present_flag, 1);
  if (sps->long_term_ref_pics_present_flag) {
    READ_UE_ALLOWED (&nr, sps->num_long_term_ref_pics_sps, 0, 32);
    for (i = 0; i < sps->num_long_term_ref_pics_sps; i++) {
      READ_UINT16 (&nr, sps->lt_ref_pic_poc_lsb_sps[i],
          sps->log2_max_pic_order_cnt_lsb_minus4 + 4);
      READ_UINT8 (&nr, sps->used_by_curr_pic_lt_sps_flag[i], 1);
    }
  }

  READ_UINT8 (&nr, sps->temporal_mvp_enabled_flag, 1);
  READ_UINT8 (&nr, sps->strong_intra_smoothing_enabled_flag, 1);
  READ_UINT8 (&nr, sps->vui_parameters_present_flag, 1);

  if (sps->vui_parameters_present_flag && parse_vui_params) {
    if (!gst_h265_parse_vui_parameters (sps, &nr))
      goto error;
    vui = &sps->vui_params;
  }

  READ_UINT8 (&nr, sps->sps_extension_flag, 1);

  /* calculate ChromaArrayType */
  if (sps->separate_colour_plane_flag)
    sps->chroma_array_type = 0;
  else
    sps->chroma_array_type = sps->chroma_format_idc;

  /* Calculate  width and height */
  sps->width = sps->pic_width_in_luma_samples;
  sps->height = sps->pic_height_in_luma_samples;
  if (sps->width < 0 || sps->height < 0) {
    GST_WARNING ("invalid width/height in SPS");
    goto error;
  }

  /* ToDo: Add crop_rectangle dimensions */

  sps->fps_num = 0;
  sps->fps_den = 1;

  if (vui && vui->timing_info_present_flag) {
    /* derive framerate for progressive stream if the pic_struct
     * syntax element is not present in picture timing SEI messages */
    /* Fixme: handle other cases also */
    if (parse_vui_params && vui->timing_info_present_flag
        && !vui->field_seq_flag && !vui->frame_field_info_present_flag) {
      sps->fps_num = vui->time_scale;
      sps->fps_den = vui->num_units_in_tick;
      GST_LOG ("framerate %d/%d", sps->fps_num, sps->fps_den);
    }
  } else {
    GST_LOG ("No VUI, unknown framerate");
  }

  sps->valid = TRUE;

  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Sequence parameter set\"");
  sps->valid = FALSE;
  return GST_H265_PARSER_ERROR;
}

/**
 * gst_h265_parse_pps:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_PPS #GstH265NalUnit to parse
 * @pps: The #GstH265PPS to fill.
 *
 * Parses @data, and fills the @pps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parse_pps (GstH265Parser * parser, GstH265NalUnit * nalu,
    GstH265PPS * pps)
{
  NalReader nr;
  GstH265SPS *sps;
  gint sps_id;
  gint qp_bd_offset;
  guint8 i;

  INITIALIZE_DEBUG_CATEGORY;
  GST_DEBUG ("parsing PPS");

  nal_reader_init (&nr, nalu->data + nalu->offset + nalu->header_bytes,
      nalu->size - nalu->header_bytes);

  READ_UE_ALLOWED (&nr, pps->id, 0, GST_H265_MAX_PPS_COUNT - 1);
  READ_UE_ALLOWED (&nr, sps_id, 0, GST_H265_MAX_SPS_COUNT - 1);

  sps = gst_h265_parser_get_sps (parser, sps_id);
  if (!sps) {
    GST_WARNING ("couldn't find associated sequence parameter set with id: %d",
        sps_id);
    return GST_H265_PARSER_BROKEN_LINK;
  }
  pps->sps = sps;
  qp_bd_offset = 6 * sps->bit_depth_luma_minus8;

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  pps->diff_cu_qp_delta_depth = 0;
  pps->num_tile_columns_minus1 = 0;
  pps->num_tile_rows_minus1 = 0;
  pps->uniform_spacing_flag = 1;
  pps->loop_filter_across_tiles_enabled_flag = 1;
  pps->deblocking_filter_override_enabled_flag = 0;
  pps->deblocking_filter_disabled_flag = 0;
  pps->beta_offset_div2 = 0;
  pps->tc_offset_div2 = 0;

  READ_UINT8 (&nr, pps->dependent_slice_segments_enabled_flag, 1);
  READ_UINT8 (&nr, pps->output_flag_present_flag, 1);
  READ_UINT8 (&nr, pps->num_extra_slice_header_bits, 3);
  READ_UINT8 (&nr, pps->sign_data_hiding_enabled_flag, 1);
  READ_UINT8 (&nr, pps->cabac_init_present_flag, 1);

  READ_UE_ALLOWED (&nr, pps->num_ref_idx_l0_default_active_minus1, 0, 14);
  READ_UE_ALLOWED (&nr, pps->num_ref_idx_l1_default_active_minus1, 0, 14);
  READ_SE_ALLOWED (&nr, pps->init_qp_minus26, -(26 + qp_bd_offset), 25);

  READ_UINT8 (&nr, pps->constrained_intra_pred_flag, 1);
  READ_UINT8 (&nr, pps->transform_skip_enabled_flag, 1);

  READ_UINT8 (&nr, pps->cu_qp_delta_enabled_flag, 1);
  if (pps->cu_qp_delta_enabled_flag)
    READ_UE_ALLOWED (&nr, pps->diff_cu_qp_delta_depth, 0,
        sps->log2_diff_max_min_luma_coding_block_size);

  READ_SE_ALLOWED (&nr, pps->cb_qp_offset, -12, 12);
  READ_SE_ALLOWED (&nr, pps->cr_qp_offset, -12, 12);

  READ_UINT8 (&nr, pps->slice_chroma_qp_offsets_present_flag, 1);
  READ_UINT8 (&nr, pps->weighted_pred_flag, 1);
  READ_UINT8 (&nr, pps->weighted_bipred_flag, 1);
  READ_UINT8 (&nr, pps->transquant_bypass_enabled_flag, 1);
  READ_UINT8 (&nr, pps->tiles_enabled_flag, 1);
  READ_UINT8 (&nr, pps->entropy_coding_sync_enabled_flag, 1);

  if (pps->tiles_enabled_flag) {
    READ_UE_ALLOWED (&nr, pps->num_tile_columns_minus1, 1, 19);
    READ_UE_ALLOWED (&nr, pps->num_tile_rows_minus1, 1, 21);

    READ_UINT8 (&nr, pps->uniform_spacing_flag, 1);
    if (!pps->uniform_spacing_flag) {
      for (i = 0; i < pps->num_tile_columns_minus1; i++)
        READ_UE (&nr, pps->column_width_minus1[i]);

      for (i = 0; i < pps->num_tile_rows_minus1; i++)
        READ_UE (&nr, pps->row_height_minus1[i]);
    }
    READ_UINT8 (&nr, pps->loop_filter_across_tiles_enabled_flag, 1);
  }

  READ_UINT8 (&nr, pps->loop_filter_across_slices_enabled_flag, 1);

  READ_UINT8 (&nr, pps->deblocking_filter_control_present_flag, 1);
  if (pps->deblocking_filter_control_present_flag) {
    READ_UINT8 (&nr, pps->deblocking_filter_override_enabled_flag, 1);

    READ_UINT8 (&nr, pps->deblocking_filter_disabled_flag, 1);
    if (!pps->deblocking_filter_disabled_flag) {
      READ_SE_ALLOWED (&nr, pps->beta_offset_div2, -6, 6);
      READ_SE_ALLOWED (&nr, pps->tc_offset_div2, -6, +6);
    }
  }

  READ_UINT8 (&nr, pps->scaling_list_data_present_flag, 1);
  if (pps->scaling_list_data_present_flag)
    if (!gst_h265_parser_parse_scaling_lists (&nr, &pps->scaling_list, FALSE))
      goto error;
  if (sps->scaling_list_enabled_flag && !sps->scaling_list_data_present_flag
      && !pps->scaling_list_data_present_flag)
    if (!gst_h265_parser_parse_scaling_lists (&nr, &pps->scaling_list, TRUE))
      goto error;

  READ_UINT8 (&nr, pps->lists_modification_present_flag, 1);
  READ_UE_ALLOWED (&nr, pps->log2_parallel_merge_level_minus2, 0, 4);
  READ_UINT8 (&nr, pps->slice_segment_header_extension_present_flag, 1);
  READ_UINT8 (&nr, pps->pps_extension_flag, 1);

  pps->valid = TRUE;
  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Picture parameter set\"");
  pps->valid = FALSE;
  return GST_H265_PARSER_ERROR;
}

/**
 * gst_h265_parser_parse_pps:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_PPS #GstH265NalUnit to parse
 * @pps: The #GstH265PPS to fill.
 *
 * Parses @data, and fills the @pps structure.
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_pps (GstH265Parser * parser,
    GstH265NalUnit * nalu, GstH265PPS * pps)
{
  GstH265ParserResult res = gst_h265_parse_pps (parser, nalu, pps);
  if (res == GST_H265_PARSER_OK) {
    GST_DEBUG ("adding picture parameter set with id: %d to array", pps->id);

    parser->pps[pps->id] = *pps;
    parser->last_pps = &parser->pps[pps->id];
  }

  return res;
}

/**
 * gst_h265_parser_parse_slice_hdr:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_SLICE #GstH265NalUnit to parse
 * @slice: The #GstH265SliceHdr to fill.
 *
 * Parses @data, and fills the @slice structure.
 * The resulting @slice_hdr structure shall be deallocated with
 * gst_h265_slice_hdr_free() when it is no longer needed
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_slice_hdr (GstH265Parser * parser,
    GstH265NalUnit * nalu, GstH265SliceHdr * slice)
{
  NalReader nr;
  gint pps_id;
  GstH265PPS *pps;
  GstH265SPS *sps;
  guint i;
  guint CurrRpsIdx = 0;
  GstH265ShortTermRefPicSet *stRPS = NULL;
  guint32 UsedByCurrPicLt[16];
  guint32 PicSizeInCtbsY;
  guint32 PicWidthInCtbsY;
  guint32 PicHeightInCtbsY;
  guint32 CtbSizeY;
  guint32 MinCbLog2SizeY;
  guint32 CtbLog2SizeY;
  gint NumPocTotalCurr = 0;

  if (!nalu->size) {
    GST_DEBUG ("Invalid Nal Unit");
    return GST_H265_PARSER_ERROR;
  }

  nal_reader_init (&nr, nalu->data + nalu->offset + nalu->header_bytes,
      nalu->size - nalu->header_bytes);

  GST_DEBUG ("parsing \"Slice header\", slice type");

  READ_UINT8 (&nr, slice->first_slice_segment_in_pic_flag, 1);

  if (nalu->type >= GST_H265_NAL_SLICE_BLA_W_LP
      && nalu->type <= RESERVED_IRAP_NAL_TYPE_MAX)
    READ_UINT8 (&nr, slice->no_output_of_prior_pics_flag, 1);

  READ_UE_ALLOWED (&nr, pps_id, 0, GST_H265_MAX_PPS_COUNT - 1);
  pps = gst_h265_parser_get_pps (parser, pps_id);
  if (!pps) {
    GST_WARNING
        ("couldn't find associated picture parameter set with id: %d", pps_id);
    return GST_H265_PARSER_BROKEN_LINK;
  }

  slice->pps = pps;
  sps = pps->sps;
  if (!sps) {
    GST_WARNING
        ("couldn't find associated sequence parameter set with id: %d",
        pps->id);
    return GST_H265_PARSER_BROKEN_LINK;
  }

  MinCbLog2SizeY = sps->log2_min_luma_coding_block_size_minus3 + 3;
  CtbLog2SizeY = MinCbLog2SizeY + sps->log2_diff_max_min_luma_coding_block_size;
  CtbSizeY = 1 << CtbLog2SizeY;
  PicHeightInCtbsY =
      ceil ((gdouble) sps->pic_height_in_luma_samples / (gdouble) CtbSizeY);
  PicWidthInCtbsY =
      ceil ((gdouble) sps->pic_width_in_luma_samples / (gdouble) CtbSizeY);
  PicSizeInCtbsY = PicWidthInCtbsY * PicHeightInCtbsY;
  /* set default values for fields that might not be present in the bitstream
   * and have valid defaults */
  slice->dependent_slice_segment_flag = 0;
  slice->segment_address = 0;
  slice->pic_output_flag = 1;
  slice->pic_order_cnt_lsb = 0;
  slice->short_term_ref_pic_set_idx = 0;
  slice->num_long_term_sps = 0;
  slice->num_long_term_pics = 0;
  for (i = 0; i < 16; i++) {
    slice->lt_idx_sps[i] = 0;
    slice->delta_poc_msb_cycle_lt[i] = 0;
  }
  slice->temporal_mvp_enabled_flag = 0;
  slice->sao_luma_flag = 0;
  slice->sao_chroma_flag = 0;
  slice->cabac_init_flag = 0;
  slice->collocated_from_l0_flag = 1;
  slice->cb_qp_offset = 0;
  slice->cr_qp_offset = 0;
  slice->deblocking_filter_override_flag = 0;
  slice->deblocking_filter_disabled_flag = 0;
  slice->beta_offset_div2 = pps->beta_offset_div2;
  slice->tc_offset_div2 = pps->tc_offset_div2;
  slice->loop_filter_across_slices_enabled_flag =
      pps->loop_filter_across_slices_enabled_flag;
  slice->num_entry_point_offsets = 0;
  slice->entry_point_offset_minus1 = NULL;

  if (!slice->first_slice_segment_in_pic_flag) {
    const guint n = ceil_log2 (PicSizeInCtbsY);

    if (pps->dependent_slice_segments_enabled_flag)
      READ_UINT8 (&nr, slice->dependent_slice_segment_flag, 1);
    /* sice_segment_address parsing */
    READ_UINT32 (&nr, slice->segment_address, n);
  }

  if (!slice->dependent_slice_segment_flag) {
    for (i = 0; i < pps->num_extra_slice_header_bits; i++)
      nal_reader_skip (&nr, 1);
    READ_UE_ALLOWED (&nr, slice->type, 0, 63);


    if (pps->output_flag_present_flag)
      READ_UINT8 (&nr, slice->pic_output_flag, 1);
    if (sps->separate_colour_plane_flag == 1)
      READ_UINT8 (&nr, slice->colour_plane_id, 2);

    if ((nalu->type != GST_H265_NAL_SLICE_IDR_W_RADL)
        && (nalu->type != GST_H265_NAL_SLICE_IDR_N_LP)) {
      READ_UINT16 (&nr, slice->pic_order_cnt_lsb,
          (sps->log2_max_pic_order_cnt_lsb_minus4 + 4));
      CHECK_ALLOWED (slice->pic_order_cnt_lsb, 0, G_MAXUINT16);

      READ_UINT8 (&nr, slice->short_term_ref_pic_set_sps_flag, 1);
      if (!slice->short_term_ref_pic_set_sps_flag) {
        if (!gst_h265_parser_parse_short_term_ref_pic_sets
            (&slice->short_term_ref_pic_sets, &nr,
                sps->num_short_term_ref_pic_sets, sps))
          goto error;
      } else if (sps->num_short_term_ref_pic_sets > 1) {
        const guint n = ceil_log2 (sps->num_short_term_ref_pic_sets);
        READ_UINT8 (&nr, slice->short_term_ref_pic_set_idx, n);
        CHECK_ALLOWED (slice->short_term_ref_pic_set_idx, 0,
            sps->num_short_term_ref_pic_sets - 1);
      }

      if (sps->long_term_ref_pics_present_flag) {
        guint32 limit;

        if (sps->num_long_term_ref_pics_sps > 0)
          READ_UE_ALLOWED (&nr, slice->num_long_term_sps, 0,
              sps->num_long_term_ref_pics_sps);

        READ_UE_ALLOWED (&nr, slice->num_long_term_pics, 0, 16);
        limit = slice->num_long_term_sps + slice->num_long_term_pics;
        for (i = 0; i < limit; i++) {
          if (i < slice->num_long_term_sps) {
            if (sps->num_long_term_ref_pics_sps > 1) {
              const guint n = ceil_log2 (sps->num_long_term_ref_pics_sps);
              READ_UINT8 (&nr, slice->lt_idx_sps[i], n);
            }
          } else {
            READ_UINT32 (&nr, slice->poc_lsb_lt[i],
                (sps->log2_max_pic_order_cnt_lsb_minus4 + 4));
            READ_UINT8 (&nr, slice->used_by_curr_pic_lt_flag[i], 1);
          }

          /* calculate UsedByCurrPicLt */
          if (i < slice->num_long_term_sps)
            UsedByCurrPicLt[i] =
                sps->used_by_curr_pic_lt_sps_flag[slice->lt_idx_sps[i]];
          else
            UsedByCurrPicLt[i] = slice->used_by_curr_pic_lt_flag[i];
          READ_UINT8 (&nr, slice->delta_poc_msb_present_flag[i], 1);
          if (slice->delta_poc_msb_present_flag[i])
            READ_UE (&nr, slice->delta_poc_msb_cycle_lt[i]);
        }
      }
      if (sps->temporal_mvp_enabled_flag)
        READ_UINT8 (&nr, slice->temporal_mvp_enabled_flag, 1);
    }

    if (sps->sample_adaptive_offset_enabled_flag) {
      READ_UINT8 (&nr, slice->sao_luma_flag, 1);
      READ_UINT8 (&nr, slice->sao_chroma_flag, 1);
    }

    if (GST_H265_IS_B_SLICE (slice) || GST_H265_IS_P_SLICE (slice)) {
      READ_UINT8 (&nr, slice->num_ref_idx_active_override_flag, 1);

      if (slice->num_ref_idx_active_override_flag) {
        READ_UE_ALLOWED (&nr, slice->num_ref_idx_l0_active_minus1, 0, 14);
        if (GST_H265_IS_B_SLICE (slice))
          READ_UE_ALLOWED (&nr, slice->num_ref_idx_l1_active_minus1, 0, 14);
      } else {
        /*set default values */
        slice->num_ref_idx_l0_active_minus1 =
            pps->num_ref_idx_l0_default_active_minus1;
        slice->num_ref_idx_l1_active_minus1 =
            pps->num_ref_idx_l1_default_active_minus1;
      }

      if (pps->lists_modification_present_flag) {
        /* calculate NumPocTotalCurr */
        if (slice->short_term_ref_pic_set_sps_flag)
          CurrRpsIdx = slice->short_term_ref_pic_set_idx;
        else
          CurrRpsIdx = sps->num_short_term_ref_pic_sets;
        stRPS = &sps->short_term_ref_pic_set[CurrRpsIdx];
        for (i = 0; i < stRPS->NumNegativePics; i++)
          if (stRPS->UsedByCurrPicS0[i])
            NumPocTotalCurr++;
        for (i = 0; i < stRPS->NumPositivePics; i++)
          if (stRPS->UsedByCurrPicS1[i])
            NumPocTotalCurr++;
        for (i = 0;
            i < (slice->num_long_term_sps + slice->num_long_term_pics); i++)
          if (UsedByCurrPicLt[i])
            NumPocTotalCurr++;
        slice->NumPocTotalCurr = NumPocTotalCurr;
        if (NumPocTotalCurr > 1)
          if (!gst_h265_slice_parse_ref_pic_list_modification (slice, &nr,
                  NumPocTotalCurr))
            goto error;
      }

      if (GST_H265_IS_B_SLICE (slice))
        READ_UINT8 (&nr, slice->mvd_l1_zero_flag, 1);
      if (pps->cabac_init_present_flag)
        READ_UINT8 (&nr, slice->cabac_init_flag, 1);
      if (slice->temporal_mvp_enabled_flag) {
        if (GST_H265_IS_B_SLICE (slice))
          READ_UINT8 (&nr, slice->collocated_from_l0_flag, 1);

        if ((slice->collocated_from_l0_flag
                && slice->num_ref_idx_l0_active_minus1 > 0)
            || (!slice->collocated_from_l0_flag
                && slice->num_ref_idx_l1_active_minus1 > 0)) {

          /*fixme: add optimization */
          if ((GST_H265_IS_P_SLICE (slice))
              || ((GST_H265_IS_B_SLICE (slice))
                  && (slice->collocated_from_l0_flag))) {
            READ_UE_ALLOWED (&nr, slice->collocated_ref_idx, 0,
                slice->num_ref_idx_l0_active_minus1);
          } else if ((GST_H265_IS_B_SLICE (slice))
              && (!slice->collocated_from_l0_flag)) {
            READ_UE_ALLOWED (&nr, slice->collocated_ref_idx, 0,
                slice->num_ref_idx_l1_active_minus1);
          }
        }
      }
      if ((pps->weighted_pred_flag && GST_H265_IS_P_SLICE (slice)) ||
          (pps->weighted_bipred_flag && GST_H265_IS_B_SLICE (slice)))
        if (!gst_h265_slice_parse_pred_weight_table (slice, &nr))
          goto error;
      READ_UE_ALLOWED (&nr, slice->five_minus_max_num_merge_cand, 0, 4);
    }

    READ_SE_ALLOWED (&nr, slice->qp_delta, -87, 77);
    if (pps->slice_chroma_qp_offsets_present_flag) {
      READ_SE_ALLOWED (&nr, slice->cb_qp_offset, -12, 12);
      READ_SE_ALLOWED (&nr, slice->cr_qp_offset, -12, 12);
    }

    if (pps->deblocking_filter_override_enabled_flag)
      READ_UINT8 (&nr, slice->deblocking_filter_override_flag, 1);
    if (slice->deblocking_filter_override_flag) {
      READ_UINT8 (&nr, slice->deblocking_filter_disabled_flag, 1);
      if (!slice->deblocking_filter_disabled_flag) {
        READ_SE_ALLOWED (&nr, slice->beta_offset_div2, -6, 6);
        READ_SE_ALLOWED (&nr, slice->tc_offset_div2, -6, 6);
      }
    }

    if (pps->loop_filter_across_slices_enabled_flag &&
        (slice->sao_luma_flag || slice->sao_chroma_flag ||
            !slice->deblocking_filter_disabled_flag))
      READ_UINT8 (&nr, slice->loop_filter_across_slices_enabled_flag, 1);
  }

  if (pps->tiles_enabled_flag || pps->entropy_coding_sync_enabled_flag) {
    guint32 offset_max;

    if (!pps->tiles_enabled_flag && pps->entropy_coding_sync_enabled_flag)
      offset_max = PicHeightInCtbsY - 1;
    else if (pps->tiles_enabled_flag && !pps->entropy_coding_sync_enabled_flag)
      offset_max =
          (pps->num_tile_columns_minus1 + 1) * (pps->num_tile_rows_minus1 + 1) -
          1;
    else
      offset_max = (pps->num_tile_columns_minus1 + 1) * PicHeightInCtbsY - 1;

    READ_UE_ALLOWED (&nr, slice->num_entry_point_offsets, 0, offset_max);
    if (slice->num_entry_point_offsets > 0) {
      READ_UE_ALLOWED (&nr, slice->offset_len_minus1, 0, 31);
      slice->entry_point_offset_minus1 =
          g_new0 (guint32, slice->num_entry_point_offsets);
      for (i = 0; i < slice->num_entry_point_offsets; i++)
        READ_UINT32 (&nr, slice->entry_point_offset_minus1[i],
            (slice->offset_len_minus1 + 1));
    }
  }

  if (pps->slice_segment_header_extension_present_flag) {
    guint16 slice_segment_header_extension_length;
    READ_UE_ALLOWED (&nr, slice_segment_header_extension_length, 0, 256);
    for (i = 0; i < slice_segment_header_extension_length; i++)
      if (!nal_reader_skip (&nr, 8))
        goto error;
  }

  slice->header_size = nal_reader_get_pos (&nr);
  slice->n_emulation_prevention_bytes = nal_reader_get_epb_count (&nr);

  return GST_H265_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Slice header\"");

  gst_h265_slice_hdr_free (slice);

  return GST_H265_PARSER_ERROR;
}

/**
 * gst_h265_parser_parse_sei:
 * @parser: a #GstH265Parser
 * @nalu: The #GST_H265_NAL_SEI #GstH265NalUnit to parse
 * @sei: The #GstH265SEIMessage to fill.
 *
 * Parses @data, and fills the @sei structures.
 * The resulting @sei  structure shall be deallocated with
 * gst_h265_sei_free() when it is no longer needed
 *
 * Returns: a #GstH265ParserResult
 */
GstH265ParserResult
gst_h265_parser_parse_sei (GstH265Parser * parser,
    GstH265NalUnit * nalu, GstH265SEIMessage * sei)
{
  NalReader nr;
  guint32 payloadSize;
  guint8 payload_type_byte, payload_size_byte;
#ifndef GST_DISABLE_GST_DEBUG
  guint remaining, payload_size;
#endif
  GstH265ParserResult res;
  GST_DEBUG ("parsing \"Sei message\"");
  nal_reader_init (&nr, nalu->data + nalu->offset + 1, nalu->size - 1);
  /* init */
  memset (sei, 0, sizeof (*sei));
  sei->payloadType = 0;
  do {
    READ_UINT8 (&nr, payload_type_byte, 8);
    sei->payloadType += payload_type_byte;
  } while (payload_type_byte == 0xff);
  payloadSize = 0;
  do {
    READ_UINT8 (&nr, payload_size_byte, 8);
    payloadSize += payload_size_byte;
  }
  while (payload_size_byte == 0xff);
#ifndef GST_DISABLE_GST_DEBUG
  remaining = nal_reader_get_remaining (&nr) * 8;
  payload_size = payloadSize < remaining ? payloadSize : remaining;
  GST_DEBUG
      ("SEI message received: payloadType  %u, payloadSize = %u bytes",
      sei->payloadType, payload_size);
#endif
  if (sei->payloadType == GST_H265_SEI_BUF_PERIOD) {
    /* size not set; might depend on emulation_prevention_three_byte */
    res = gst_h265_parser_parse_buffering_period (parser,
        &sei->payload.buffering_period, &nr);
  } else if (sei->payloadType == GST_H265_SEI_PIC_TIMING) {
    /* size not set; might depend on emulation_prevention_three_byte */
    res = gst_h265_parser_parse_pic_timing (parser,
        &sei->payload.pic_timing, &nr);
  } else
    res = GST_H265_PARSER_OK;

  return res;

error:
  GST_WARNING ("error parsing \"Sei message\"");
  gst_h265_sei_free (sei);

  return GST_H265_PARSER_ERROR;
}

/**
 * gst_h265_slice_hdr_copy:
 * @dst_slice: The destination #GstH265SliceHdr to copy into
 * @src_slice: The source #GstH265SliceHdr to copy from
 *
 * Copies @src_slice into @dst_slice
 *
 * Returns: %TRUE if everything went fine, %FALSE otherwise
 */
gboolean
gst_h265_slice_hdr_copy (GstH265SliceHdr * dst_slice,
    const GstH265SliceHdr * src_slice)
{
  guint i;

  g_return_val_if_fail (dst_slice != NULL, FALSE);
  g_return_val_if_fail (src_slice != NULL, FALSE);

  gst_h265_slice_hdr_free (dst_slice);

  *dst_slice = *src_slice;

  if (dst_slice->num_entry_point_offsets > 0) {
    dst_slice->entry_point_offset_minus1 =
        g_new0 (guint32, dst_slice->num_entry_point_offsets);
    for (i = 0; i < dst_slice->num_entry_point_offsets; i++)
      dst_slice->entry_point_offset_minus1[i] =
          src_slice->entry_point_offset_minus1[i];
  }

  return TRUE;
}

/**
 * gst_h265_slice_hdr_free:
 * slice_hdr: The #GstH265SliceHdr to free
 *
 * Frees @slice_hdr fields.
 */
void
gst_h265_slice_hdr_free (GstH265SliceHdr * slice_hdr)
{
  g_return_if_fail (slice_hdr != NULL);

  if (slice_hdr->num_entry_point_offsets > 0)
    g_free (slice_hdr->entry_point_offset_minus1);
  slice_hdr->entry_point_offset_minus1 = 0;
}

/**
 * gst_h265_sei_copy:
 * @dst_sei: The destination #GstH265SEIMessage to copy into
 * @src_sei: The source #GstH265SEIMessage to copy from
 *
 * Copies @src_sei into @dst_sei
 *
 * Returns: %TRUE if everything went fine, %FALSE otherwise
 */
gboolean
gst_h265_sei_copy (GstH265SEIMessage * dst_sei,
    const GstH265SEIMessage * src_sei)
{
  guint i;

  g_return_val_if_fail (dst_sei != NULL, FALSE);
  g_return_val_if_fail (src_sei != NULL, FALSE);

  gst_h265_sei_free (dst_sei);

  *dst_sei = *src_sei;

  if (dst_sei->payloadType == GST_H265_SEI_PIC_TIMING) {
    GstH265PicTiming *dst_pic_timing = &dst_sei->payload.pic_timing;
    const GstH265PicTiming *src_pic_timing = &src_sei->payload.pic_timing;

    if (dst_pic_timing->num_decoding_units_minus1 > 0) {
      dst_pic_timing->num_nalus_in_du_minus1 =
          g_new0 (guint32, (dst_pic_timing->num_decoding_units_minus1 + 1));
      dst_pic_timing->du_cpb_removal_delay_increment_minus1 =
          g_new0 (guint8, (dst_pic_timing->num_decoding_units_minus1 + 1));

      for (i = 0; i <= dst_pic_timing->num_decoding_units_minus1; i++) {
        dst_pic_timing->num_nalus_in_du_minus1[i] =
            src_pic_timing->num_nalus_in_du_minus1[i];
        dst_pic_timing->du_cpb_removal_delay_increment_minus1[i] =
            src_pic_timing->du_cpb_removal_delay_increment_minus1[i];
      }
    }
  }

  return TRUE;
}

/**
 * gst_h265_sei_free:
 * sei: The #GstH265SEIMessage to free
 *
 * Frees @sei fields.
 */
void
gst_h265_sei_free (GstH265SEIMessage * sei)
{
  g_return_if_fail (sei != NULL);

  if (sei->payloadType == GST_H265_SEI_PIC_TIMING) {
    GstH265PicTiming *pic_timing = &sei->payload.pic_timing;
    if (pic_timing->num_decoding_units_minus1 > 0) {
      g_free (pic_timing->num_nalus_in_du_minus1);
      g_free (pic_timing->du_cpb_removal_delay_increment_minus1);
    }
    pic_timing->num_nalus_in_du_minus1 = 0;
    pic_timing->du_cpb_removal_delay_increment_minus1 = 0;
  }
}
