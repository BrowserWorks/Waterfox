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

/**
 * SECTION:gsth264parser
 * @short_description: Convenience library for h264 video
 * bitstream parsing.
 *
 * It offers you bitstream parsing in AVC mode or not. To identify Nals in a bitstream and
 * parse its headers, you should call:
 * <itemizedlist>
 *   <listitem>
 *      #gst_h264_parser_identify_nalu to identify the following nalu in not AVC bitstreams
 *   </listitem>
 *   <listitem>
 *      #gst_h264_parser_identify_nalu_avc to identify the nalu in AVC bitstreams
 *   </listitem>
 * </itemizedlist>
 *
 * Then, depending on the #GstH264NalUnitType of the newly parsed #GstH264NalUnit, you should
 * call the differents functions to parse the structure:
 * <itemizedlist>
 *   <listitem>
 *      From #GST_H264_NAL_SLICE to #GST_H264_NAL_SLICE_IDR: #gst_h264_parser_parse_slice_hdr
 *   </listitem>
 *   <listitem>
 *      #GST_H264_NAL_SEI: #gst_h264_parser_parse_sei
 *   </listitem>
 *   <listitem>
 *      #GST_H264_NAL_SPS: #gst_h264_parser_parse_sps
 *   </listitem>
 *   <listitem>
 *      #GST_H264_NAL_PPS: #gst_h264_parser_parse_pps
 *   </listitem>
 *   <listitem>
 *      Any other: #gst_h264_parser_parse_nal
 *   </listitem>
 * </itemizedlist>
 *
 * Note: You should always call gst_h264_parser_parse_nal if you don't actually need
 * #GstH264NalUnitType to be parsed for your personnal use, in order to guarantee that the
 * #GstH264NalParser is always up to date.
 *
 * For more details about the structures, look at the ITU-T H.264 and ISO/IEC 14496-10 – MPEG-4
 * Part 10 specifications, you can download them from:
 *
 * <itemizedlist>
 *   <listitem>
 *     ITU-T H.264: http://www.itu.int/rec/T-REC-H.264
 *   </listitem>
 *   <listitem>
 *     ISO/IEC 14496-10: http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=56538
 *   </listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "nalutils.h"
#include "gsth264parser.h"

#include <gst/base/gstbytereader.h>
#include <gst/base/gstbitreader.h>
#include <string.h>

GST_DEBUG_CATEGORY (h264_parser_debug);
#define GST_CAT_DEFAULT h264_parser_debug

static gboolean initialized = FALSE;
#define INITIALIZE_DEBUG_CATEGORY \
  if (!initialized) { \
    GST_DEBUG_CATEGORY_INIT (h264_parser_debug, "codecparsers_h264", 0, \
        "h264 parser library"); \
    initialized = TRUE; \
  }

/**** Default scaling_lists according to Table 7-2 *****/
static const guint8 default_4x4_intra[16] = {
  6, 13, 13, 20, 20, 20, 28, 28, 28, 28, 32, 32,
  32, 37, 37, 42
};

static const guint8 default_4x4_inter[16] = {
  10, 14, 14, 20, 20, 20, 24, 24, 24, 24, 27, 27,
  27, 30, 30, 34
};

static const guint8 default_8x8_intra[64] = {
  6, 10, 10, 13, 11, 13, 16, 16, 16, 16, 18, 18,
  18, 18, 18, 23, 23, 23, 23, 23, 23, 25, 25, 25, 25, 25, 25, 25, 27, 27, 27,
  27, 27, 27, 27, 27, 29, 29, 29, 29, 29, 29, 29, 31, 31, 31, 31, 31, 31, 33,
  33, 33, 33, 33, 36, 36, 36, 36, 38, 38, 38, 40, 40, 42
};

static const guint8 default_8x8_inter[64] = {
  9, 13, 13, 15, 13, 15, 17, 17, 17, 17, 19, 19,
  19, 19, 19, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 24, 24, 24,
  24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 27, 27, 27, 27, 27, 27, 28,
  28, 28, 28, 28, 30, 30, 30, 30, 32, 32, 32, 33, 33, 35
};

static const guint8 zigzag_8x8[64] = {
  0, 1, 8, 16, 9, 2, 3, 10,
  17, 24, 32, 25, 18, 11, 4, 5,
  12, 19, 26, 33, 40, 48, 41, 34,
  27, 20, 13, 6, 7, 14, 21, 28,
  35, 42, 49, 56, 57, 50, 43, 36,
  29, 22, 15, 23, 30, 37, 44, 51,
  58, 59, 52, 45, 38, 31, 39, 46,
  53, 60, 61, 54, 47, 55, 62, 63
};

static const guint8 zigzag_4x4[16] = {
  0, 1, 4, 8,
  5, 2, 3, 6,
  9, 12, 13, 10,
  7, 11, 14, 15,
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

static GstH264SPS *
gst_h264_parser_get_sps (GstH264NalParser * nalparser, guint8 sps_id)
{
  GstH264SPS *sps;

  sps = &nalparser->sps[sps_id];

  if (sps->valid)
    return sps;

  return NULL;
}

static GstH264PPS *
gst_h264_parser_get_pps (GstH264NalParser * nalparser, guint8 pps_id)
{
  GstH264PPS *pps;

  pps = &nalparser->pps[pps_id];

  if (pps->valid)
    return pps;

  return NULL;
}

static gboolean
gst_h264_parse_nalu_header (GstH264NalUnit * nalu)
{
  guint8 *data = nalu->data + nalu->offset;

  if (nalu->size < 1)
    return FALSE;

  nalu->type = (data[0] & 0x1f);
  nalu->ref_idc = (data[0] & 0x60) >> 5;
  nalu->idr_pic_flag = (nalu->type == 5 ? 1 : 0);

  GST_DEBUG ("Nal type %u, ref_idc %u", nalu->type, nalu->ref_idc);
  return TRUE;
}

/*
 * gst_h264_pps_copy:
 * @dst_pps: The destination #GstH264PPS to copy into
 * @src_pps: The source #GstH264PPS to copy from
 *
 * Copies @src_pps into @dst_pps.
 *
 * Returns: %TRUE if everything went fine, %FALSE otherwise
 */
static gboolean
gst_h264_pps_copy (GstH264PPS * dst_pps, const GstH264PPS * src_pps)
{
  g_return_val_if_fail (dst_pps != NULL, FALSE);
  g_return_val_if_fail (src_pps != NULL, FALSE);

  gst_h264_pps_clear (dst_pps);

  *dst_pps = *src_pps;

  if (src_pps->slice_group_id)
    dst_pps->slice_group_id = g_memdup (src_pps->slice_group_id,
        src_pps->pic_size_in_map_units_minus1 + 1);

  return TRUE;
}

/****** Parsing functions *****/

static gboolean
gst_h264_parse_hrd_parameters (GstH264HRDParams * hrd, NalReader * nr)
{
  guint sched_sel_idx;

  GST_DEBUG ("parsing \"HRD Parameters\"");

  READ_UE_ALLOWED (nr, hrd->cpb_cnt_minus1, 0, 31);
  READ_UINT8 (nr, hrd->bit_rate_scale, 4);
  READ_UINT8 (nr, hrd->cpb_size_scale, 4);

  for (sched_sel_idx = 0; sched_sel_idx <= hrd->cpb_cnt_minus1; sched_sel_idx++) {
    READ_UE (nr, hrd->bit_rate_value_minus1[sched_sel_idx]);
    READ_UE (nr, hrd->cpb_size_value_minus1[sched_sel_idx]);
    READ_UINT8 (nr, hrd->cbr_flag[sched_sel_idx], 1);
  }

  READ_UINT8 (nr, hrd->initial_cpb_removal_delay_length_minus1, 5);
  READ_UINT8 (nr, hrd->cpb_removal_delay_length_minus1, 5);
  READ_UINT8 (nr, hrd->dpb_output_delay_length_minus1, 5);
  READ_UINT8 (nr, hrd->time_offset_length, 5);

  return TRUE;

error:
  GST_WARNING ("error parsing \"HRD Parameters\"");
  return FALSE;
}

static gboolean
gst_h264_parse_vui_parameters (GstH264SPS * sps, NalReader * nr)
{
  GstH264VUIParams *vui = &sps->vui_parameters;

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
  vui->low_delay_hrd_flag = 0;
  vui->par_n = 0;
  vui->par_d = 0;

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

  READ_UINT8 (nr, vui->timing_info_present_flag, 1);
  if (vui->timing_info_present_flag) {
    READ_UINT32 (nr, vui->num_units_in_tick, 32);
    if (vui->num_units_in_tick == 0)
      GST_WARNING ("num_units_in_tick = 0 detected in stream "
          "(incompliant to H.264 E.2.1).");

    READ_UINT32 (nr, vui->time_scale, 32);
    if (vui->time_scale == 0)
      GST_WARNING ("time_scale = 0 detected in stream "
          "(incompliant to H.264 E.2.1).");

    READ_UINT8 (nr, vui->fixed_frame_rate_flag, 1);
  }

  READ_UINT8 (nr, vui->nal_hrd_parameters_present_flag, 1);
  if (vui->nal_hrd_parameters_present_flag) {
    if (!gst_h264_parse_hrd_parameters (&vui->nal_hrd_parameters, nr))
      goto error;
  }

  READ_UINT8 (nr, vui->vcl_hrd_parameters_present_flag, 1);
  if (vui->vcl_hrd_parameters_present_flag) {
    if (!gst_h264_parse_hrd_parameters (&vui->vcl_hrd_parameters, nr))
      goto error;
  }

  if (vui->nal_hrd_parameters_present_flag ||
      vui->vcl_hrd_parameters_present_flag)
    READ_UINT8 (nr, vui->low_delay_hrd_flag, 1);

  READ_UINT8 (nr, vui->pic_struct_present_flag, 1);
  READ_UINT8 (nr, vui->bitstream_restriction_flag, 1);
  if (vui->bitstream_restriction_flag) {
    READ_UINT8 (nr, vui->motion_vectors_over_pic_boundaries_flag, 1);
    READ_UE (nr, vui->max_bytes_per_pic_denom);
    READ_UE_ALLOWED (nr, vui->max_bits_per_mb_denom, 0, 16);
    READ_UE_ALLOWED (nr, vui->log2_max_mv_length_horizontal, 0, 16);
    READ_UE_ALLOWED (nr, vui->log2_max_mv_length_vertical, 0, 16);
    READ_UE (nr, vui->num_reorder_frames);
    READ_UE (nr, vui->max_dec_frame_buffering);
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"VUI Parameters\"");
  return FALSE;
}

static gboolean
gst_h264_parser_parse_scaling_list (NalReader * nr,
    guint8 scaling_lists_4x4[6][16], guint8 scaling_lists_8x8[6][64],
    const guint8 fallback_4x4_inter[16], const guint8 fallback_4x4_intra[16],
    const guint8 fallback_8x8_inter[64], const guint8 fallback_8x8_intra[64],
    guint8 n_lists)
{
  guint i;

  static const guint8 *default_lists[12] = {
    default_4x4_intra, default_4x4_intra, default_4x4_intra,
    default_4x4_inter, default_4x4_inter, default_4x4_inter,
    default_8x8_intra, default_8x8_inter,
    default_8x8_intra, default_8x8_inter,
    default_8x8_intra, default_8x8_inter
  };

  GST_DEBUG ("parsing scaling lists");

  for (i = 0; i < 12; i++) {
    gboolean use_default = FALSE;

    if (i < n_lists) {
      guint8 scaling_list_present_flag;

      READ_UINT8 (nr, scaling_list_present_flag, 1);
      if (scaling_list_present_flag) {
        guint8 *scaling_list;
        guint size;
        guint j;
        guint8 last_scale, next_scale;

        if (i < 6) {
          scaling_list = scaling_lists_4x4[i];
          size = 16;
        } else {
          scaling_list = scaling_lists_8x8[i - 6];
          size = 64;
        }

        last_scale = 8;
        next_scale = 8;
        for (j = 0; j < size; j++) {
          if (next_scale != 0) {
            gint32 delta_scale;

            READ_SE (nr, delta_scale);
            next_scale = (last_scale + delta_scale) & 0xff;
          }
          if (j == 0 && next_scale == 0) {
            /* Use default scaling lists (7.4.2.1.1.1) */
            memcpy (scaling_list, default_lists[i], size);
            break;
          }
          last_scale = scaling_list[j] =
              (next_scale == 0) ? last_scale : next_scale;
        }
      } else
        use_default = TRUE;
    } else
      use_default = TRUE;

    if (use_default) {
      switch (i) {
        case 0:
          memcpy (scaling_lists_4x4[0], fallback_4x4_intra, 16);
          break;
        case 1:
          memcpy (scaling_lists_4x4[1], scaling_lists_4x4[0], 16);
          break;
        case 2:
          memcpy (scaling_lists_4x4[2], scaling_lists_4x4[1], 16);
          break;
        case 3:
          memcpy (scaling_lists_4x4[3], fallback_4x4_inter, 16);
          break;
        case 4:
          memcpy (scaling_lists_4x4[4], scaling_lists_4x4[3], 16);
          break;
        case 5:
          memcpy (scaling_lists_4x4[5], scaling_lists_4x4[4], 16);
          break;
        case 6:
          memcpy (scaling_lists_8x8[0], fallback_8x8_intra, 64);
          break;
        case 7:
          memcpy (scaling_lists_8x8[1], fallback_8x8_inter, 64);
          break;
        case 8:
          memcpy (scaling_lists_8x8[2], scaling_lists_8x8[0], 64);
          break;
        case 9:
          memcpy (scaling_lists_8x8[3], scaling_lists_8x8[1], 64);
          break;
        case 10:
          memcpy (scaling_lists_8x8[4], scaling_lists_8x8[2], 64);
          break;
        case 11:
          memcpy (scaling_lists_8x8[5], scaling_lists_8x8[3], 64);
          break;

        default:
          break;
      }
    }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing scaling lists");
  return FALSE;
}

static gboolean
slice_parse_ref_pic_list_modification_1 (GstH264SliceHdr * slice,
    NalReader * nr, guint list)
{
  GstH264RefPicListModification *entries;
  guint8 *ref_pic_list_modification_flag, *n_ref_pic_list_modification;
  guint32 modification_of_pic_nums_idc;
  guint i = 0;

  if (list == 0) {
    entries = slice->ref_pic_list_modification_l0;
    ref_pic_list_modification_flag = &slice->ref_pic_list_modification_flag_l0;
    n_ref_pic_list_modification = &slice->n_ref_pic_list_modification_l0;
  } else {
    entries = slice->ref_pic_list_modification_l1;
    ref_pic_list_modification_flag = &slice->ref_pic_list_modification_flag_l1;
    n_ref_pic_list_modification = &slice->n_ref_pic_list_modification_l1;
  }

  READ_UINT8 (nr, *ref_pic_list_modification_flag, 1);
  if (*ref_pic_list_modification_flag) {
    while (1) {
      READ_UE (nr, modification_of_pic_nums_idc);
      if (modification_of_pic_nums_idc == 3)
        break;
      if (modification_of_pic_nums_idc == 0 ||
          modification_of_pic_nums_idc == 1) {
        READ_UE_ALLOWED (nr, entries[i].value.abs_diff_pic_num_minus1, 0,
            slice->max_pic_num - 1);
      } else if (modification_of_pic_nums_idc == 2) {
        READ_UE (nr, entries[i].value.long_term_pic_num);
      }
      entries[i++].modification_of_pic_nums_idc = modification_of_pic_nums_idc;
    }
  }
  *n_ref_pic_list_modification = i;
  return TRUE;

error:
  GST_WARNING ("error parsing \"Reference picture list %u modification\"",
      list);
  return FALSE;
}

static gboolean
slice_parse_ref_pic_list_modification (GstH264SliceHdr * slice, NalReader * nr)
{
  if (!GST_H264_IS_I_SLICE (slice) && !GST_H264_IS_SI_SLICE (slice)) {
    if (!slice_parse_ref_pic_list_modification_1 (slice, nr, 0))
      return FALSE;
  }

  if (GST_H264_IS_B_SLICE (slice)) {
    if (!slice_parse_ref_pic_list_modification_1 (slice, nr, 1))
      return FALSE;
  }
  return TRUE;
}

static gboolean
gst_h264_slice_parse_dec_ref_pic_marking (GstH264SliceHdr * slice,
    GstH264NalUnit * nalu, NalReader * nr)
{
  GstH264DecRefPicMarking *dec_ref_pic_m;

  GST_DEBUG ("parsing \"Decoded reference picture marking\"");

  dec_ref_pic_m = &slice->dec_ref_pic_marking;

  if (nalu->idr_pic_flag) {
    READ_UINT8 (nr, dec_ref_pic_m->no_output_of_prior_pics_flag, 1);
    READ_UINT8 (nr, dec_ref_pic_m->long_term_reference_flag, 1);
  } else {
    READ_UINT8 (nr, dec_ref_pic_m->adaptive_ref_pic_marking_mode_flag, 1);
    if (dec_ref_pic_m->adaptive_ref_pic_marking_mode_flag) {
      guint32 mem_mgmt_ctrl_op;
      GstH264RefPicMarking *refpicmarking;

      dec_ref_pic_m->n_ref_pic_marking = 0;
      while (1) {
        refpicmarking =
            &dec_ref_pic_m->ref_pic_marking[dec_ref_pic_m->n_ref_pic_marking];

        READ_UE (nr, mem_mgmt_ctrl_op);
        if (mem_mgmt_ctrl_op == 0)
          break;

        refpicmarking->memory_management_control_operation = mem_mgmt_ctrl_op;

        if (mem_mgmt_ctrl_op == 1 || mem_mgmt_ctrl_op == 3)
          READ_UE (nr, refpicmarking->difference_of_pic_nums_minus1);

        if (mem_mgmt_ctrl_op == 2)
          READ_UE (nr, refpicmarking->long_term_pic_num);

        if (mem_mgmt_ctrl_op == 3 || mem_mgmt_ctrl_op == 6)
          READ_UE (nr, refpicmarking->long_term_frame_idx);

        if (mem_mgmt_ctrl_op == 4)
          READ_UE (nr, refpicmarking->max_long_term_frame_idx_plus1);

        dec_ref_pic_m->n_ref_pic_marking++;
      }
    }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"Decoded reference picture marking\"");
  return FALSE;
}

static gboolean
gst_h264_slice_parse_pred_weight_table (GstH264SliceHdr * slice,
    NalReader * nr, guint8 chroma_array_type)
{
  GstH264PredWeightTable *p;
  gint16 default_luma_weight, default_chroma_weight;
  gint i;

  GST_DEBUG ("parsing \"Prediction weight table\"");

  p = &slice->pred_weight_table;

  READ_UE_ALLOWED (nr, p->luma_log2_weight_denom, 0, 7);
  /* set default values */
  default_luma_weight = 1 << p->luma_log2_weight_denom;
  for (i = 0; i < G_N_ELEMENTS (p->luma_weight_l0); i++)
    p->luma_weight_l0[i] = default_luma_weight;
  memset (p->luma_offset_l0, 0, sizeof (p->luma_offset_l0));
  if (GST_H264_IS_B_SLICE (slice)) {
    for (i = 0; i < G_N_ELEMENTS (p->luma_weight_l1); i++)
      p->luma_weight_l1[i] = default_luma_weight;
    memset (p->luma_offset_l1, 0, sizeof (p->luma_offset_l1));
  }

  if (chroma_array_type != 0) {
    READ_UE_ALLOWED (nr, p->chroma_log2_weight_denom, 0, 7);
    /* set default values */
    default_chroma_weight = 1 << p->chroma_log2_weight_denom;
    for (i = 0; i < G_N_ELEMENTS (p->chroma_weight_l0); i++) {
      p->chroma_weight_l0[i][0] = default_chroma_weight;
      p->chroma_weight_l0[i][1] = default_chroma_weight;
    }
    memset (p->chroma_offset_l0, 0, sizeof (p->chroma_offset_l0));
    if (GST_H264_IS_B_SLICE (slice)) {
      for (i = 0; i < G_N_ELEMENTS (p->chroma_weight_l1); i++) {
        p->chroma_weight_l1[i][0] = default_chroma_weight;
        p->chroma_weight_l1[i][1] = default_chroma_weight;
      }
      memset (p->chroma_offset_l1, 0, sizeof (p->chroma_offset_l1));
    }
  }

  for (i = 0; i <= slice->num_ref_idx_l0_active_minus1; i++) {
    guint8 luma_weight_l0_flag;

    READ_UINT8 (nr, luma_weight_l0_flag, 1);
    if (luma_weight_l0_flag) {
      READ_SE_ALLOWED (nr, p->luma_weight_l0[i], -128, 127);
      READ_SE_ALLOWED (nr, p->luma_offset_l0[i], -128, 127);
    }
    if (chroma_array_type != 0) {
      guint8 chroma_weight_l0_flag;
      gint j;

      READ_UINT8 (nr, chroma_weight_l0_flag, 1);
      if (chroma_weight_l0_flag) {
        for (j = 0; j < 2; j++) {
          READ_SE_ALLOWED (nr, p->chroma_weight_l0[i][j], -128, 127);
          READ_SE_ALLOWED (nr, p->chroma_offset_l0[i][j], -128, 127);
        }
      }
    }
  }

  if (GST_H264_IS_B_SLICE (slice)) {
    for (i = 0; i <= slice->num_ref_idx_l1_active_minus1; i++) {
      guint8 luma_weight_l1_flag;

      READ_UINT8 (nr, luma_weight_l1_flag, 1);
      if (luma_weight_l1_flag) {
        READ_SE_ALLOWED (nr, p->luma_weight_l1[i], -128, 127);
        READ_SE_ALLOWED (nr, p->luma_offset_l1[i], -128, 127);
      }
      if (chroma_array_type != 0) {
        guint8 chroma_weight_l1_flag;
        gint j;

        READ_UINT8 (nr, chroma_weight_l1_flag, 1);
        if (chroma_weight_l1_flag) {
          for (j = 0; j < 2; j++) {
            READ_SE_ALLOWED (nr, p->chroma_weight_l1[i][j], -128, 127);
            READ_SE_ALLOWED (nr, p->chroma_offset_l1[i][j], -128, 127);
          }
        }
      }
    }
  }

  return TRUE;

error:
  GST_WARNING ("error parsing \"Prediction weight table\"");
  return FALSE;
}

static GstH264ParserResult
gst_h264_parser_parse_buffering_period (GstH264NalParser * nalparser,
    GstH264BufferingPeriod * per, NalReader * nr)
{
  GstH264SPS *sps;
  guint8 sps_id;

  GST_DEBUG ("parsing \"Buffering period\"");

  READ_UE_ALLOWED (nr, sps_id, 0, GST_H264_MAX_SPS_COUNT - 1);
  sps = gst_h264_parser_get_sps (nalparser, sps_id);
  if (!sps) {
    GST_WARNING ("couldn't find associated sequence parameter set with id: %d",
        sps_id);
    return GST_H264_PARSER_BROKEN_LINK;
  }
  per->sps = sps;

  if (sps->vui_parameters_present_flag) {
    GstH264VUIParams *vui = &sps->vui_parameters;

    if (vui->nal_hrd_parameters_present_flag) {
      GstH264HRDParams *hrd = &vui->nal_hrd_parameters;
      const guint8 nbits = hrd->initial_cpb_removal_delay_length_minus1 + 1;
      guint8 sched_sel_idx;

      for (sched_sel_idx = 0; sched_sel_idx <= hrd->cpb_cnt_minus1;
          sched_sel_idx++) {
        READ_UINT8 (nr, per->nal_initial_cpb_removal_delay[sched_sel_idx],
            nbits);
        READ_UINT8 (nr,
            per->nal_initial_cpb_removal_delay_offset[sched_sel_idx], nbits);
      }
    }

    if (vui->vcl_hrd_parameters_present_flag) {
      GstH264HRDParams *hrd = &vui->vcl_hrd_parameters;
      const guint8 nbits = hrd->initial_cpb_removal_delay_length_minus1 + 1;
      guint8 sched_sel_idx;

      for (sched_sel_idx = 0; sched_sel_idx <= hrd->cpb_cnt_minus1;
          sched_sel_idx++) {
        READ_UINT8 (nr, per->vcl_initial_cpb_removal_delay[sched_sel_idx],
            nbits);
        READ_UINT8 (nr,
            per->vcl_initial_cpb_removal_delay_offset[sched_sel_idx], nbits);
      }
    }
  }

  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Buffering period\"");
  return GST_H264_PARSER_ERROR;
}

static gboolean
gst_h264_parse_clock_timestamp (GstH264ClockTimestamp * tim,
    GstH264VUIParams * vui, NalReader * nr)
{
  guint8 full_timestamp_flag;
  guint8 time_offset_length;

  GST_DEBUG ("parsing \"Clock timestamp\"");

  /* defalt values */
  tim->time_offset = 0;

  READ_UINT8 (nr, tim->ct_type, 2);
  READ_UINT8 (nr, tim->nuit_field_based_flag, 1);
  READ_UINT8 (nr, tim->counting_type, 5);
  READ_UINT8 (nr, full_timestamp_flag, 1);
  READ_UINT8 (nr, tim->discontinuity_flag, 1);
  READ_UINT8 (nr, tim->cnt_dropped_flag, 1);
  READ_UINT8 (nr, tim->n_frames, 8);

  if (full_timestamp_flag) {
    tim->seconds_flag = TRUE;
    READ_UINT8 (nr, tim->seconds_value, 6);

    tim->minutes_flag = TRUE;
    READ_UINT8 (nr, tim->minutes_value, 6);

    tim->hours_flag = TRUE;
    READ_UINT8 (nr, tim->hours_value, 5);
  } else {
    READ_UINT8 (nr, tim->seconds_flag, 1);
    if (tim->seconds_flag) {
      READ_UINT8 (nr, tim->seconds_value, 6);
      READ_UINT8 (nr, tim->minutes_flag, 1);
      if (tim->minutes_flag) {
        READ_UINT8 (nr, tim->minutes_value, 6);
        READ_UINT8 (nr, tim->hours_flag, 1);
        if (tim->hours_flag)
          READ_UINT8 (nr, tim->hours_value, 5);
      }
    }
  }

  time_offset_length = 0;
  if (vui->nal_hrd_parameters_present_flag)
    time_offset_length = vui->nal_hrd_parameters.time_offset_length;
  else if (vui->vcl_hrd_parameters_present_flag)
    time_offset_length = vui->vcl_hrd_parameters.time_offset_length;

  if (time_offset_length > 0)
    READ_UINT32 (nr, tim->time_offset, time_offset_length);

  return TRUE;

error:
  GST_WARNING ("error parsing \"Clock timestamp\"");
  return FALSE;
}

static GstH264ParserResult
gst_h264_parser_parse_pic_timing (GstH264NalParser * nalparser,
    GstH264PicTiming * tim, NalReader * nr)
{
  GST_DEBUG ("parsing \"Picture timing\"");
  if (!nalparser->last_sps || !nalparser->last_sps->valid) {
    GST_WARNING ("didn't get the associated sequence paramater set for the "
        "current access unit");
    goto error;
  }

  /* default values */
  tim->cpb_removal_delay = 0;
  tim->dpb_output_delay = 0;
  tim->pic_struct_present_flag = FALSE;
  memset (tim->clock_timestamp_flag, 0, 3);

  if (nalparser->last_sps->vui_parameters_present_flag) {
    GstH264VUIParams *vui = &nalparser->last_sps->vui_parameters;

    if (vui->nal_hrd_parameters_present_flag) {
      READ_UINT32 (nr, tim->cpb_removal_delay,
          vui->nal_hrd_parameters.cpb_removal_delay_length_minus1 + 1);
      READ_UINT32 (nr, tim->dpb_output_delay,
          vui->nal_hrd_parameters.dpb_output_delay_length_minus1 + 1);
    } else if (vui->vcl_hrd_parameters_present_flag) {
      READ_UINT32 (nr, tim->cpb_removal_delay,
          vui->vcl_hrd_parameters.cpb_removal_delay_length_minus1 + 1);
      READ_UINT32 (nr, tim->dpb_output_delay,
          vui->vcl_hrd_parameters.dpb_output_delay_length_minus1 + 1);
    }

    if (vui->pic_struct_present_flag) {
      const guint8 num_clock_ts_table[9] = {
        1, 1, 1, 2, 2, 3, 3, 2, 3
      };
      guint8 num_clock_num_ts;
      guint i;

      tim->pic_struct_present_flag = TRUE;
      READ_UINT8 (nr, tim->pic_struct, 4);
      CHECK_ALLOWED ((gint8) tim->pic_struct, 0, 8);

      num_clock_num_ts = num_clock_ts_table[tim->pic_struct];
      for (i = 0; i < num_clock_num_ts; i++) {
        READ_UINT8 (nr, tim->clock_timestamp_flag[i], 1);
        if (tim->clock_timestamp_flag[i]) {
          if (!gst_h264_parse_clock_timestamp (&tim->clock_timestamp[i], vui,
                  nr))
            goto error;
        }
      }
    }
  }

  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Picture timing\"");
  return GST_H264_PARSER_ERROR;
}

static GstH264ParserResult
gst_h264_parser_parse_recovery_point (GstH264NalParser * nalparser,
    GstH264RecoveryPoint * rp, NalReader * nr)
{
  GstH264SPS *const sps = nalparser->last_sps;

  GST_DEBUG ("parsing \"Recovery point\"");
  if (!sps || !sps->valid) {
    GST_WARNING ("didn't get the associated sequence paramater set for the "
        "current access unit");
    goto error;
  }

  READ_UE_ALLOWED (nr, rp->recovery_frame_cnt, 0, sps->max_frame_num - 1);
  READ_UINT8 (nr, rp->exact_match_flag, 1);
  READ_UINT8 (nr, rp->broken_link_flag, 1);
  READ_UINT8 (nr, rp->changing_slice_group_idc, 2);

  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Recovery point\"");
  return GST_H264_PARSER_ERROR;
}

static GstH264ParserResult
gst_h264_parser_parse_sei_message (GstH264NalParser * nalparser,
    NalReader * nr, GstH264SEIMessage * sei)
{
  guint32 payloadSize;
  guint8 payload_type_byte, payload_size_byte;
  guint remaining, payload_size;
  GstH264ParserResult res;

  GST_DEBUG ("parsing \"Sei message\"");

  sei->payloadType = 0;
  do {
    READ_UINT8 (nr, payload_type_byte, 8);
    sei->payloadType += payload_type_byte;
  } while (payload_type_byte == 0xff);

  payloadSize = 0;
  do {
    READ_UINT8 (nr, payload_size_byte, 8);
    payloadSize += payload_size_byte;
  }
  while (payload_size_byte == 0xff);

  remaining = nal_reader_get_remaining (nr);
  payload_size = payloadSize * 8 < remaining ? payloadSize * 8 : remaining;

  GST_DEBUG ("SEI message received: payloadType  %u, payloadSize = %u bits",
      sei->payloadType, payload_size);

  switch (sei->payloadType) {
    case GST_H264_SEI_BUF_PERIOD:
      /* size not set; might depend on emulation_prevention_three_byte */
      res = gst_h264_parser_parse_buffering_period (nalparser,
          &sei->payload.buffering_period, nr);
      break;
    case GST_H264_SEI_PIC_TIMING:
      /* size not set; might depend on emulation_prevention_three_byte */
      res = gst_h264_parser_parse_pic_timing (nalparser,
          &sei->payload.pic_timing, nr);
      break;
    case GST_H264_SEI_RECOVERY_POINT:
      res = gst_h264_parser_parse_recovery_point (nalparser,
          &sei->payload.recovery_point, nr);
      break;
    default:
      /* Just consume payloadSize bytes, which does not account for
         emulation prevention bytes */
      if (!nal_reader_skip_long (nr, payload_size))
        goto error;
      res = GST_H264_PARSER_OK;
      break;
  }

  /* When SEI message doesn't end at byte boundary,
   * check remaining bits fit the specification.
   */
  if (!nal_reader_is_byte_aligned (nr)) {
    guint8 bit_equal_to_one;
    READ_UINT8 (nr, bit_equal_to_one, 1);
    if (!bit_equal_to_one)
      GST_WARNING ("Bit non equal to one.");

    while (!nal_reader_is_byte_aligned (nr)) {
      guint8 bit_equal_to_zero;
      READ_UINT8 (nr, bit_equal_to_zero, 1);
      if (bit_equal_to_zero)
        GST_WARNING ("Bit non equal to zero.");
    }
  }

  return res;

error:
  GST_WARNING ("error parsing \"Sei message\"");
  return GST_H264_PARSER_ERROR;
}

/******** API *************/

/**
 * gst_h264_nal_parser_new:
 *
 * Creates a new #GstH264NalParser. It should be freed with
 * gst_h264_nal_parser_free after use.
 *
 * Returns: a new #GstH264NalParser
 */
GstH264NalParser *
gst_h264_nal_parser_new (void)
{
  GstH264NalParser *nalparser;

  nalparser = g_slice_new0 (GstH264NalParser);
  INITIALIZE_DEBUG_CATEGORY;

  return nalparser;
}

/**
 * gst_h264_nal_parser_free:
 * @nalparser: the #GstH264NalParser to free
 *
 * Frees @nalparser and sets it to %NULL
 */
void
gst_h264_nal_parser_free (GstH264NalParser * nalparser)
{
  guint i;

  for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++)
    gst_h264_pps_clear (&nalparser->pps[i]);
  g_slice_free (GstH264NalParser, nalparser);

  nalparser = NULL;
}

/**
 * gst_h264_parser_identify_nalu_unchecked:
 * @nalparser: a #GstH264NalParser
 * @data: The data to parse
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nalu: The #GstH264NalUnit where to store parsed nal headers
 *
 * Parses @data and fills @nalu from the next nalu data from @data.
 *
 * This differs from @gst_h264_parser_identify_nalu in that it doesn't
 * check whether the packet is complete or not.
 *
 * Note: Only use this function if you already know the provided @data
 * is a complete NALU, else use @gst_h264_parser_identify_nalu.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_identify_nalu_unchecked (GstH264NalParser * nalparser,
    const guint8 * data, guint offset, gsize size, GstH264NalUnit * nalu)
{
  gint off1;

  if (size < offset + 4) {
    GST_DEBUG ("Can't parse, buffer has too small size %" G_GSIZE_FORMAT
        ", offset %u", size, offset);
    return GST_H264_PARSER_ERROR;
  }

  off1 = scan_for_start_codes (data + offset, size - offset);

  if (off1 < 0) {
    GST_DEBUG ("No start code prefix in this buffer");
    return GST_H264_PARSER_NO_NAL;
  }

  if (offset + off1 == size - 1) {
    GST_DEBUG ("Missing data to identify nal unit");

    return GST_H264_PARSER_ERROR;
  }

  nalu->sc_offset = offset + off1;


  nalu->offset = offset + off1 + 3;
  nalu->data = (guint8 *) data;
  nalu->size = size - nalu->offset;

  if (!gst_h264_parse_nalu_header (nalu)) {
    GST_WARNING ("error parsing \"NAL unit header\"");
    nalu->size = 0;
    return GST_H264_PARSER_BROKEN_DATA;
  }

  nalu->valid = TRUE;

  /* sc might have 2 or 3 0-bytes */
  if (nalu->sc_offset > 0 && data[nalu->sc_offset - 1] == 00
      && (nalu->type == GST_H264_NAL_SPS || nalu->type == GST_H264_NAL_PPS
          || nalu->type == GST_H264_NAL_AU_DELIMITER))
    nalu->sc_offset--;

  if (nalu->type == GST_H264_NAL_SEQ_END ||
      nalu->type == GST_H264_NAL_STREAM_END) {
    GST_DEBUG ("end-of-seq or end-of-stream nal found");
    nalu->size = 1;
    return GST_H264_PARSER_OK;
  }

  return GST_H264_PARSER_OK;
}

/**
 * gst_h264_parser_identify_nalu:
 * @nalparser: a #GstH264NalParser
 * @data: The data to parse
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nalu: The #GstH264NalUnit where to store parsed nal headers
 *
 * Parses @data and fills @nalu from the next nalu data from @data
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_identify_nalu (GstH264NalParser * nalparser,
    const guint8 * data, guint offset, gsize size, GstH264NalUnit * nalu)
{
  GstH264ParserResult res;
  gint off2;

  res =
      gst_h264_parser_identify_nalu_unchecked (nalparser, data, offset, size,
      nalu);

  if (res != GST_H264_PARSER_OK || nalu->size == 1)
    goto beach;

  off2 = scan_for_start_codes (data + nalu->offset, size - nalu->offset);
  if (off2 < 0) {
    GST_DEBUG ("Nal start %d, No end found", nalu->offset);

    return GST_H264_PARSER_NO_NAL_END;
  }

  /* Mini performance improvement:
   * We could have a way to store how many 0s were skipped to avoid
   * parsing them again on the next NAL */
  while (off2 > 0 && data[nalu->offset + off2 - 1] == 00)
    off2--;

  nalu->size = off2;
  if (nalu->size < 2)
    return GST_H264_PARSER_BROKEN_DATA;

  GST_DEBUG ("Complete nal found. Off: %d, Size: %d", nalu->offset, nalu->size);

beach:
  return res;
}


/**
 * gst_h264_parser_identify_nalu_avc:
 * @nalparser: a #GstH264NalParser
 * @data: The data to parse, must be the beging of the Nal unit
 * @offset: the offset from which to parse @data
 * @size: the size of @data
 * @nal_length_size: the size in bytes of the AVC nal length prefix.
 * @nalu: The #GstH264NalUnit where to store parsed nal headers
 *
 * Parses @data and sets @nalu.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_identify_nalu_avc (GstH264NalParser * nalparser,
    const guint8 * data, guint offset, gsize size, guint8 nal_length_size,
    GstH264NalUnit * nalu)
{
  GstBitReader br;

  if (size < offset + nal_length_size) {
    GST_DEBUG ("Can't parse, buffer has too small size %" G_GSIZE_FORMAT
        ", offset %u", size, offset);
    return GST_H264_PARSER_ERROR;
  }

  size = size - offset;
  gst_bit_reader_init (&br, data + offset, size);

  nalu->size = gst_bit_reader_get_bits_uint32_unchecked (&br,
      nal_length_size * 8);
  nalu->sc_offset = offset;
  nalu->offset = offset + nal_length_size;

  if (size < nalu->size + nal_length_size) {
    nalu->size = 0;

    return GST_H264_PARSER_NO_NAL_END;
  }

  nalu->data = (guint8 *) data;

  if (!gst_h264_parse_nalu_header (nalu)) {
    GST_WARNING ("error parsing \"NAL unit header\"");
    nalu->size = 0;
    return GST_H264_PARSER_BROKEN_DATA;
  }

  nalu->valid = TRUE;

  return GST_H264_PARSER_OK;
}

/**
 * gst_h264_parser_parse_nal:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GstH264NalUnit to parse
 *
 * This function should be called in the case one doesn't need to
 * parse a specific structure. It is necessary to do so to make
 * sure @nalparser is up to date.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_parse_nal (GstH264NalParser * nalparser, GstH264NalUnit * nalu)
{
  GstH264SPS sps;
  GstH264PPS pps;

  switch (nalu->type) {
    case GST_H264_NAL_SPS:
      return gst_h264_parser_parse_sps (nalparser, nalu, &sps, FALSE);
      break;
    case GST_H264_NAL_PPS:
      return gst_h264_parser_parse_pps (nalparser, nalu, &pps);
  }

  return GST_H264_PARSER_OK;
}

/**
 * gst_h264_parser_parse_sps:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GST_H264_NAL_SPS #GstH264NalUnit to parse
 * @sps: The #GstH264SPS to fill.
 * @parse_vui_params: Whether to parse the vui_params or not
 *
 * Parses @data, and fills the @sps structure.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_parse_sps (GstH264NalParser * nalparser, GstH264NalUnit * nalu,
    GstH264SPS * sps, gboolean parse_vui_params)
{
  GstH264ParserResult res = gst_h264_parse_sps (nalu, sps, parse_vui_params);

  if (res == GST_H264_PARSER_OK) {
    GST_DEBUG ("adding sequence parameter set with id: %d to array", sps->id);

    nalparser->sps[sps->id] = *sps;
    nalparser->last_sps = &nalparser->sps[sps->id];
  }



  return res;
}

/* Parse seq_parameter_set_data() */
static gboolean
gst_h264_parse_sps_data (NalReader * nr, GstH264SPS * sps,
    gboolean parse_vui_params)
{
  gint width, height;
  guint subwc[] = { 1, 2, 2, 1 };
  guint subhc[] = { 1, 2, 1, 1 };
  GstH264VUIParams *vui = NULL;

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  sps->chroma_format_idc = 1;
  sps->separate_colour_plane_flag = 0;
  sps->bit_depth_luma_minus8 = 0;
  sps->bit_depth_chroma_minus8 = 0;
  memset (sps->scaling_lists_4x4, 16, 96);
  memset (sps->scaling_lists_8x8, 16, 384);
  memset (&sps->vui_parameters, 0, sizeof (sps->vui_parameters));
  sps->mb_adaptive_frame_field_flag = 0;
  sps->frame_crop_left_offset = 0;
  sps->frame_crop_right_offset = 0;
  sps->frame_crop_top_offset = 0;
  sps->frame_crop_bottom_offset = 0;
  sps->delta_pic_order_always_zero_flag = 0;

  READ_UINT8 (nr, sps->profile_idc, 8);
  READ_UINT8 (nr, sps->constraint_set0_flag, 1);
  READ_UINT8 (nr, sps->constraint_set1_flag, 1);
  READ_UINT8 (nr, sps->constraint_set2_flag, 1);
  READ_UINT8 (nr, sps->constraint_set3_flag, 1);

  /* skip reserved_zero_4bits */
  if (!nal_reader_skip (nr, 4))
    goto error;

  READ_UINT8 (nr, sps->level_idc, 8);

  READ_UE_ALLOWED (nr, sps->id, 0, GST_H264_MAX_SPS_COUNT - 1);

  if (sps->profile_idc == 100 || sps->profile_idc == 110 ||
      sps->profile_idc == 122 || sps->profile_idc == 244 ||
      sps->profile_idc == 44 || sps->profile_idc == 83 ||
      sps->profile_idc == 86) {
    READ_UE_ALLOWED (nr, sps->chroma_format_idc, 0, 3);
    if (sps->chroma_format_idc == 3)
      READ_UINT8 (nr, sps->separate_colour_plane_flag, 1);

    READ_UE_ALLOWED (nr, sps->bit_depth_luma_minus8, 0, 6);
    READ_UE_ALLOWED (nr, sps->bit_depth_chroma_minus8, 0, 6);
    READ_UINT8 (nr, sps->qpprime_y_zero_transform_bypass_flag, 1);

    READ_UINT8 (nr, sps->scaling_matrix_present_flag, 1);
    if (sps->scaling_matrix_present_flag) {
      guint8 n_lists;

      n_lists = (sps->chroma_format_idc != 3) ? 8 : 12;
      if (!gst_h264_parser_parse_scaling_list (nr,
              sps->scaling_lists_4x4, sps->scaling_lists_8x8,
              default_4x4_inter, default_4x4_intra,
              default_8x8_inter, default_8x8_intra, n_lists))
        goto error;
    }
  }

  READ_UE_ALLOWED (nr, sps->log2_max_frame_num_minus4, 0, 12);

  sps->max_frame_num = 1 << (sps->log2_max_frame_num_minus4 + 4);

  READ_UE_ALLOWED (nr, sps->pic_order_cnt_type, 0, 2);
  if (sps->pic_order_cnt_type == 0) {
    READ_UE_ALLOWED (nr, sps->log2_max_pic_order_cnt_lsb_minus4, 0, 12);
  } else if (sps->pic_order_cnt_type == 1) {
    guint i;

    READ_UINT8 (nr, sps->delta_pic_order_always_zero_flag, 1);
    READ_SE (nr, sps->offset_for_non_ref_pic);
    READ_SE (nr, sps->offset_for_top_to_bottom_field);
    READ_UE_ALLOWED (nr, sps->num_ref_frames_in_pic_order_cnt_cycle, 0, 255);

    for (i = 0; i < sps->num_ref_frames_in_pic_order_cnt_cycle; i++)
      READ_SE (nr, sps->offset_for_ref_frame[i]);
  }

  READ_UE (nr, sps->num_ref_frames);
  READ_UINT8 (nr, sps->gaps_in_frame_num_value_allowed_flag, 1);
  READ_UE (nr, sps->pic_width_in_mbs_minus1);
  READ_UE (nr, sps->pic_height_in_map_units_minus1);
  READ_UINT8 (nr, sps->frame_mbs_only_flag, 1);

  if (!sps->frame_mbs_only_flag)
    READ_UINT8 (nr, sps->mb_adaptive_frame_field_flag, 1);

  READ_UINT8 (nr, sps->direct_8x8_inference_flag, 1);
  READ_UINT8 (nr, sps->frame_cropping_flag, 1);
  if (sps->frame_cropping_flag) {
    READ_UE (nr, sps->frame_crop_left_offset);
    READ_UE (nr, sps->frame_crop_right_offset);
    READ_UE (nr, sps->frame_crop_top_offset);
    READ_UE (nr, sps->frame_crop_bottom_offset);
  }

  READ_UINT8 (nr, sps->vui_parameters_present_flag, 1);
  if (sps->vui_parameters_present_flag && parse_vui_params) {
    if (!gst_h264_parse_vui_parameters (sps, nr))
      goto error;
    vui = &sps->vui_parameters;
  }

  /* calculate ChromaArrayType */
  if (sps->separate_colour_plane_flag)
    sps->chroma_array_type = 0;
  else
    sps->chroma_array_type = sps->chroma_format_idc;

  /* Calculate  width and height */
  width = (sps->pic_width_in_mbs_minus1 + 1);
  width *= 16;
  height = (sps->pic_height_in_map_units_minus1 + 1);
  height *= 16 * (2 - sps->frame_mbs_only_flag);
  GST_LOG ("initial width=%d, height=%d", width, height);
  if (width < 0 || height < 0) {
    GST_WARNING ("invalid width/height in SPS");
    goto error;
  }

  sps->width = width;
  sps->height = height;

  if (sps->frame_cropping_flag) {
    const guint crop_unit_x = subwc[sps->chroma_format_idc];
    const guint crop_unit_y =
        subhc[sps->chroma_format_idc] * (2 - sps->frame_mbs_only_flag);

    width -= (sps->frame_crop_left_offset + sps->frame_crop_right_offset)
        * crop_unit_x;
    height -= (sps->frame_crop_top_offset + sps->frame_crop_bottom_offset)
        * crop_unit_y;

    sps->crop_rect_width = width;
    sps->crop_rect_height = height;
    sps->crop_rect_x = sps->frame_crop_left_offset * crop_unit_x;
    sps->crop_rect_y = sps->frame_crop_top_offset * crop_unit_y;

    GST_LOG ("crop_rectangle x=%u y=%u width=%u, height=%u", sps->crop_rect_x,
        sps->crop_rect_y, width, height);
  }
  sps->fps_num = 0;
  sps->fps_den = 1;

  if (vui && vui->timing_info_present_flag) {
    /* derive framerate */
    /* FIXME verify / also handle other cases */
    GST_LOG ("Framerate: %u %u %u %u", parse_vui_params,
        vui->fixed_frame_rate_flag, sps->frame_mbs_only_flag,
        vui->pic_struct_present_flag);

    if (parse_vui_params && vui->fixed_frame_rate_flag) {
      sps->fps_num = vui->time_scale;
      sps->fps_den = vui->num_units_in_tick;
      /* picture is a frame = 2 fields */
      sps->fps_den *= 2;
      GST_LOG ("framerate %d/%d", sps->fps_num, sps->fps_den);
    }
  } else {
    GST_LOG ("No VUI, unknown framerate");
  }
  return TRUE;

error:
  return FALSE;
}

/**
 * gst_h264_parse_sps:
 * @nalu: The #GST_H264_NAL_SPS #GstH264NalUnit to parse
 * @sps: The #GstH264SPS to fill.
 * @parse_vui_params: Whether to parse the vui_params or not
 *
 * Parses @data, and fills the @sps structure.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parse_sps (GstH264NalUnit * nalu, GstH264SPS * sps,
    gboolean parse_vui_params)
{
  NalReader nr;

  INITIALIZE_DEBUG_CATEGORY;
  GST_DEBUG ("parsing SPS");

  nal_reader_init (&nr, nalu->data + nalu->offset + 1, nalu->size - 1);

  if (!gst_h264_parse_sps_data (&nr, sps, parse_vui_params))
    goto error;

  sps->valid = TRUE;

  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Sequence parameter set\"");
  sps->valid = FALSE;
  return GST_H264_PARSER_ERROR;
}

/**
 * gst_h264_parse_pps:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GST_H264_NAL_PPS #GstH264NalUnit to parse
 * @pps: The #GstH264PPS to fill.
 *
 * Parses @data, and fills the @pps structure.
 *
 * The resulting @pps data structure shall be deallocated with the
 * gst_h264_pps_clear() function when it is no longer needed, or prior
 * to parsing a new PPS NAL unit.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parse_pps (GstH264NalParser * nalparser, GstH264NalUnit * nalu,
    GstH264PPS * pps)
{
  NalReader nr;
  GstH264SPS *sps;
  gint sps_id;
  guint8 pic_scaling_matrix_present_flag;
  gint qp_bd_offset;

  INITIALIZE_DEBUG_CATEGORY;
  GST_DEBUG ("parsing PPS");

  nal_reader_init (&nr, nalu->data + nalu->offset + 1, nalu->size - 1);

  READ_UE_ALLOWED (&nr, pps->id, 0, GST_H264_MAX_PPS_COUNT - 1);
  READ_UE_ALLOWED (&nr, sps_id, 0, GST_H264_MAX_SPS_COUNT - 1);

  sps = gst_h264_parser_get_sps (nalparser, sps_id);
  if (!sps) {
    GST_WARNING ("couldn't find associated sequence parameter set with id: %d",
        sps_id);
    return GST_H264_PARSER_BROKEN_LINK;
  }
  pps->sequence = sps;
  qp_bd_offset = 6 * (sps->bit_depth_luma_minus8 +
      sps->separate_colour_plane_flag);

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  pps->slice_group_id = NULL;
  pps->transform_8x8_mode_flag = 0;
  memcpy (&pps->scaling_lists_4x4, &sps->scaling_lists_4x4, 96);
  memcpy (&pps->scaling_lists_8x8, &sps->scaling_lists_8x8, 384);

  READ_UINT8 (&nr, pps->entropy_coding_mode_flag, 1);
  READ_UINT8 (&nr, pps->pic_order_present_flag, 1);
  READ_UE_ALLOWED (&nr, pps->num_slice_groups_minus1, 0, 7);
  if (pps->num_slice_groups_minus1 > 0) {
    READ_UE_ALLOWED (&nr, pps->slice_group_map_type, 0, 6);

    if (pps->slice_group_map_type == 0) {
      gint i;

      for (i = 0; i <= pps->num_slice_groups_minus1; i++)
        READ_UE (&nr, pps->run_length_minus1[i]);
    } else if (pps->slice_group_map_type == 2) {
      gint i;

      for (i = 0; i < pps->num_slice_groups_minus1; i++) {
        READ_UE (&nr, pps->top_left[i]);
        READ_UE (&nr, pps->bottom_right[i]);
      }
    } else if (pps->slice_group_map_type >= 3 && pps->slice_group_map_type <= 5) {
      READ_UINT8 (&nr, pps->slice_group_change_direction_flag, 1);
      READ_UE (&nr, pps->slice_group_change_rate_minus1);
    } else if (pps->slice_group_map_type == 6) {
      gint bits;
      gint i;

      READ_UE (&nr, pps->pic_size_in_map_units_minus1);
      bits = g_bit_storage (pps->num_slice_groups_minus1);

      pps->slice_group_id =
          g_new (guint8, pps->pic_size_in_map_units_minus1 + 1);
      for (i = 0; i <= pps->pic_size_in_map_units_minus1; i++)
        READ_UINT8 (&nr, pps->slice_group_id[i], bits);
    }
  }

  READ_UE_ALLOWED (&nr, pps->num_ref_idx_l0_active_minus1, 0, 31);
  READ_UE_ALLOWED (&nr, pps->num_ref_idx_l1_active_minus1, 0, 31);
  READ_UINT8 (&nr, pps->weighted_pred_flag, 1);
  READ_UINT8 (&nr, pps->weighted_bipred_idc, 2);
  READ_SE_ALLOWED (&nr, pps->pic_init_qp_minus26, -(26 + qp_bd_offset), 25);
  READ_SE_ALLOWED (&nr, pps->pic_init_qs_minus26, -26, 25);
  READ_SE_ALLOWED (&nr, pps->chroma_qp_index_offset, -12, 12);
  pps->second_chroma_qp_index_offset = pps->chroma_qp_index_offset;
  READ_UINT8 (&nr, pps->deblocking_filter_control_present_flag, 1);
  READ_UINT8 (&nr, pps->constrained_intra_pred_flag, 1);
  READ_UINT8 (&nr, pps->redundant_pic_cnt_present_flag, 1);

  if (!nal_reader_has_more_data (&nr))
    goto done;

  READ_UINT8 (&nr, pps->transform_8x8_mode_flag, 1);

  READ_UINT8 (&nr, pic_scaling_matrix_present_flag, 1);
  if (pic_scaling_matrix_present_flag) {
    guint8 n_lists;

    n_lists = 6 + ((sps->chroma_format_idc != 3) ? 2 : 6) *
        pps->transform_8x8_mode_flag;

    if (sps->scaling_matrix_present_flag) {
      if (!gst_h264_parser_parse_scaling_list (&nr,
              pps->scaling_lists_4x4, pps->scaling_lists_8x8,
              sps->scaling_lists_4x4[3], sps->scaling_lists_4x4[0],
              sps->scaling_lists_8x8[3], sps->scaling_lists_8x8[0], n_lists))
        goto error;
    } else {
      if (!gst_h264_parser_parse_scaling_list (&nr,
              pps->scaling_lists_4x4, pps->scaling_lists_8x8,
              default_4x4_inter, default_4x4_intra,
              default_8x8_inter, default_8x8_intra, n_lists))
        goto error;
    }
  }

  READ_SE_ALLOWED (&nr, pps->second_chroma_qp_index_offset, -12, 12);

done:
  pps->valid = TRUE;
  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Picture parameter set\"");
  pps->valid = FALSE;
  gst_h264_pps_clear (pps);
  return GST_H264_PARSER_ERROR;
}

/**
 * gst_h264_parser_parse_pps:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GST_H264_NAL_PPS #GstH264NalUnit to parse
 * @pps: The #GstH264PPS to fill.
 *
 * Parses @data, and fills the @pps structure.
 *
 * The resulting @pps data structure shall be deallocated with the
 * gst_h264_pps_clear() function when it is no longer needed, or prior
 * to parsing a new PPS NAL unit.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_parse_pps (GstH264NalParser * nalparser,
    GstH264NalUnit * nalu, GstH264PPS * pps)
{
  GstH264ParserResult res = gst_h264_parse_pps (nalparser, nalu, pps);

  if (res == GST_H264_PARSER_OK) {
    GST_DEBUG ("adding picture parameter set with id: %d to array", pps->id);

    if (!gst_h264_pps_copy (&nalparser->pps[pps->id], pps))
      return GST_H264_PARSER_ERROR;
    nalparser->last_pps = &nalparser->pps[pps->id];
  }

  return res;
}

/**
 * gst_h264_pps_clear:
 * @pps: The #GstH264PPS to free
 *
 * Clears all @pps internal resources.
 *
 * Since: 1.4
 */
void
gst_h264_pps_clear (GstH264PPS * pps)
{
  g_return_if_fail (pps != NULL);

  g_free (pps->slice_group_id);
  pps->slice_group_id = NULL;
}

/**
 * gst_h264_parser_parse_slice_hdr:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GST_H264_NAL_SLICE #GstH264NalUnit to parse
 * @slice: The #GstH264SliceHdr to fill.
 * @parse_pred_weight_table: Whether to parse the pred_weight_table or not
 * @parse_dec_ref_pic_marking: Whether to parse the dec_ref_pic_marking or not
 *
 * Parses @data, and fills the @slice structure.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_parse_slice_hdr (GstH264NalParser * nalparser,
    GstH264NalUnit * nalu, GstH264SliceHdr * slice,
    gboolean parse_pred_weight_table, gboolean parse_dec_ref_pic_marking)
{
  NalReader nr;
  gint pps_id;
  GstH264PPS *pps;
  GstH264SPS *sps;

  if (!nalu->size) {
    GST_DEBUG ("Invalid Nal Unit");
    return GST_H264_PARSER_ERROR;
  }


  nal_reader_init (&nr, nalu->data + nalu->offset + 1, nalu->size - 1);

  READ_UE (&nr, slice->first_mb_in_slice);
  READ_UE (&nr, slice->type);

  GST_DEBUG ("parsing \"Slice header\", slice type %u", slice->type);

  READ_UE_ALLOWED (&nr, pps_id, 0, GST_H264_MAX_PPS_COUNT - 1);
  pps = gst_h264_parser_get_pps (nalparser, pps_id);

  if (!pps) {
    GST_WARNING ("couldn't find associated picture parameter set with id: %d",
        pps_id);

    return GST_H264_PARSER_BROKEN_LINK;
  }

  slice->pps = pps;
  sps = pps->sequence;
  if (!sps) {
    GST_WARNING ("couldn't find associated sequence parameter set with id: %d",
        pps->id);
    return GST_H264_PARSER_BROKEN_LINK;
  }

  /* set default values for fields that might not be present in the bitstream
     and have valid defaults */
  slice->field_pic_flag = 0;
  slice->bottom_field_flag = 0;
  slice->delta_pic_order_cnt_bottom = 0;
  slice->delta_pic_order_cnt[0] = 0;
  slice->delta_pic_order_cnt[1] = 0;
  slice->redundant_pic_cnt = 0;
  slice->num_ref_idx_l0_active_minus1 = pps->num_ref_idx_l0_active_minus1;
  slice->num_ref_idx_l1_active_minus1 = pps->num_ref_idx_l1_active_minus1;
  slice->disable_deblocking_filter_idc = 0;
  slice->slice_alpha_c0_offset_div2 = 0;
  slice->slice_beta_offset_div2 = 0;

  if (sps->separate_colour_plane_flag)
    READ_UINT8 (&nr, slice->colour_plane_id, 2);

  READ_UINT16 (&nr, slice->frame_num, sps->log2_max_frame_num_minus4 + 4);

  if (!sps->frame_mbs_only_flag) {
    READ_UINT8 (&nr, slice->field_pic_flag, 1);
    if (slice->field_pic_flag)
      READ_UINT8 (&nr, slice->bottom_field_flag, 1);
  }

  /* calculate MaxPicNum */
  if (slice->field_pic_flag)
    slice->max_pic_num = sps->max_frame_num;
  else
    slice->max_pic_num = 2 * sps->max_frame_num;

  if (nalu->idr_pic_flag)
    READ_UE_ALLOWED (&nr, slice->idr_pic_id, 0, G_MAXUINT16);

  if (sps->pic_order_cnt_type == 0) {
    READ_UINT16 (&nr, slice->pic_order_cnt_lsb,
        sps->log2_max_pic_order_cnt_lsb_minus4 + 4);

    if (pps->pic_order_present_flag && !slice->field_pic_flag)
      READ_SE (&nr, slice->delta_pic_order_cnt_bottom);
  }

  if (sps->pic_order_cnt_type == 1 && !sps->delta_pic_order_always_zero_flag) {
    READ_SE (&nr, slice->delta_pic_order_cnt[0]);
    if (pps->pic_order_present_flag && !slice->field_pic_flag)
      READ_SE (&nr, slice->delta_pic_order_cnt[1]);
  }

  if (pps->redundant_pic_cnt_present_flag)
    READ_UE_ALLOWED (&nr, slice->redundant_pic_cnt, 0, G_MAXINT8);

  if (GST_H264_IS_B_SLICE (slice))
    READ_UINT8 (&nr, slice->direct_spatial_mv_pred_flag, 1);

  if (GST_H264_IS_P_SLICE (slice) || GST_H264_IS_SP_SLICE (slice) ||
      GST_H264_IS_B_SLICE (slice)) {
    guint8 num_ref_idx_active_override_flag;

    READ_UINT8 (&nr, num_ref_idx_active_override_flag, 1);
    if (num_ref_idx_active_override_flag) {
      READ_UE_ALLOWED (&nr, slice->num_ref_idx_l0_active_minus1, 0, 31);

      if (GST_H264_IS_B_SLICE (slice))
        READ_UE_ALLOWED (&nr, slice->num_ref_idx_l1_active_minus1, 0, 31);
    }
  }

  if (!slice_parse_ref_pic_list_modification (slice, &nr))
    goto error;

  if ((pps->weighted_pred_flag && (GST_H264_IS_P_SLICE (slice)
              || GST_H264_IS_SP_SLICE (slice)))
      || (pps->weighted_bipred_idc == 1 && GST_H264_IS_B_SLICE (slice))) {
    if (!gst_h264_slice_parse_pred_weight_table (slice, &nr,
            sps->chroma_array_type))
      goto error;
  }

  if (nalu->ref_idc != 0) {
    if (!gst_h264_slice_parse_dec_ref_pic_marking (slice, nalu, &nr))
      goto error;
  }

  if (pps->entropy_coding_mode_flag && !GST_H264_IS_I_SLICE (slice) &&
      !GST_H264_IS_SI_SLICE (slice))
    READ_UE_ALLOWED (&nr, slice->cabac_init_idc, 0, 2);

  READ_SE_ALLOWED (&nr, slice->slice_qp_delta, -87, 77);

  if (GST_H264_IS_SP_SLICE (slice) || GST_H264_IS_SI_SLICE (slice)) {
    guint8 sp_for_switch_flag;

    if (GST_H264_IS_SP_SLICE (slice))
      READ_UINT8 (&nr, sp_for_switch_flag, 1);
    READ_SE_ALLOWED (&nr, slice->slice_qs_delta, -51, 51);
  }

  if (pps->deblocking_filter_control_present_flag) {
    READ_UE_ALLOWED (&nr, slice->disable_deblocking_filter_idc, 0, 2);
    if (slice->disable_deblocking_filter_idc != 1) {
      READ_SE_ALLOWED (&nr, slice->slice_alpha_c0_offset_div2, -6, 6);
      READ_SE_ALLOWED (&nr, slice->slice_beta_offset_div2, -6, 6);
    }
  }

  if (pps->num_slice_groups_minus1 > 0 &&
      pps->slice_group_map_type >= 3 && pps->slice_group_map_type <= 5) {
    /* Ceil(Log2(PicSizeInMapUnits / SliceGroupChangeRate + 1))  [7-33] */
    guint32 PicWidthInMbs = sps->pic_width_in_mbs_minus1 + 1;
    guint32 PicHeightInMapUnits = sps->pic_height_in_map_units_minus1 + 1;
    guint32 PicSizeInMapUnits = PicWidthInMbs * PicHeightInMapUnits;
    guint32 SliceGroupChangeRate = pps->slice_group_change_rate_minus1 + 1;
    const guint n = ceil_log2 (PicSizeInMapUnits / SliceGroupChangeRate + 1);
    READ_UINT16 (&nr, slice->slice_group_change_cycle, n);
  }

  slice->header_size = nal_reader_get_pos (&nr);
  slice->n_emulation_prevention_bytes = nal_reader_get_epb_count (&nr);

  return GST_H264_PARSER_OK;

error:
  GST_WARNING ("error parsing \"Slice header\"");
  return GST_H264_PARSER_ERROR;
}

/**
 * gst_h264_parser_parse_sei:
 * @nalparser: a #GstH264NalParser
 * @nalu: The #GST_H264_NAL_SEI #GstH264NalUnit to parse
 * @messages: The GArray of #GstH264SEIMessage to fill. The caller must free it when done.
 *
 * Parses @data, create and fills the @messages array.
 *
 * Returns: a #GstH264ParserResult
 */
GstH264ParserResult
gst_h264_parser_parse_sei (GstH264NalParser * nalparser, GstH264NalUnit * nalu,
    GArray ** messages)
{
  NalReader nr;
  GstH264SEIMessage sei;
  GstH264ParserResult res;

  GST_DEBUG ("parsing SEI nal");
  nal_reader_init (&nr, nalu->data + nalu->offset + 1, nalu->size - 1);
  *messages = g_array_new (FALSE, FALSE, sizeof (GstH264SEIMessage));

  do {
    res = gst_h264_parser_parse_sei_message (nalparser, &nr, &sei);
    if (res == GST_H264_PARSER_OK)
      g_array_append_val (*messages, sei);
    else
      break;
  } while (nal_reader_has_more_data (&nr));

  return res;
}

/**
 * gst_h264_quant_matrix_8x8_get_zigzag_from_raster:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from raster scan order to
 * zigzag scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.4
 */
void
gst_h264_quant_matrix_8x8_get_zigzag_from_raster (guint8 out_quant[64],
    const guint8 quant[64])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 64; i++)
    out_quant[i] = quant[zigzag_8x8[i]];
}

/**
 * gst_h264_quant_matrix_8x8_get_raster_from_zigzag:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from zigzag scan order to
 * raster scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.4
 */
void
gst_h264_quant_matrix_8x8_get_raster_from_zigzag (guint8 out_quant[64],
    const guint8 quant[64])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 64; i++)
    out_quant[zigzag_8x8[i]] = quant[i];
}

/**
 * gst_h264_quant_matrix_4x4_get_zigzag_from_raster:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from raster scan order to
 * zigzag scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.4
 */
void
gst_h264_quant_matrix_4x4_get_zigzag_from_raster (guint8 out_quant[16],
    const guint8 quant[16])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 16; i++)
    out_quant[i] = quant[zigzag_4x4[i]];
}

/**
 * gst_h264_quant_matrix_4x4_get_raster_from_zigzag:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from zigzag scan order to
 * raster scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.4
 */
void
gst_h264_quant_matrix_4x4_get_raster_from_zigzag (guint8 out_quant[16],
    const guint8 quant[16])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 16; i++)
    out_quant[zigzag_4x4[i]] = quant[i];
}

/**
 * gst_h264_video_calculate_framerate:
 * @sps: Current Sequence Parameter Set
 * @field_pic_flag: Current @field_pic_flag, obtained from latest slice header
 * @pic_struct: @pic_struct value if available, 0 otherwise
 * @fps_num: (out): The resulting fps numerator
 * @fps_den: (out): The resulting fps denominator
 *
 * Calculate framerate of a video sequence using @sps VUI information,
 * @field_pic_flag from a slice header and @pic_struct from #GstH264PicTiming SEI
 * message.
 *
 * If framerate is variable or can't be determined, @fps_num will be set to 0
 * and @fps_den to 1.
 */
void
gst_h264_video_calculate_framerate (const GstH264SPS * sps,
    guint field_pic_flag, guint pic_struct, gint * fps_num, gint * fps_den)
{
  gint num = 0;
  gint den = 1;

  /* To calculate framerate, we use this formula:
   *          time_scale                1                         1
   * fps = -----------------  x  ---------------  x  ------------------------
   *       num_units_in_tick     DeltaTfiDivisor     (field_pic_flag ? 2 : 1)
   *
   * See H264 specification E2.1 for more details.
   */

  if (sps) {
    if (sps->vui_parameters_present_flag) {
      const GstH264VUIParams *vui = &sps->vui_parameters;
      if (vui->timing_info_present_flag && vui->fixed_frame_rate_flag) {
        int delta_tfi_divisor = 1;
        num = vui->time_scale;
        den = vui->num_units_in_tick;

        if (vui->pic_struct_present_flag) {
          switch (pic_struct) {
            case 1:
            case 2:
              delta_tfi_divisor = 1;
              break;
            case 0:
            case 3:
            case 4:
              delta_tfi_divisor = 2;
              break;
            case 5:
            case 6:
              delta_tfi_divisor = 3;
              break;
            case 7:
              delta_tfi_divisor = 4;
              break;
            case 8:
              delta_tfi_divisor = 6;
              break;
          }
        } else {
          delta_tfi_divisor = field_pic_flag ? 1 : 2;
        }
        den *= delta_tfi_divisor;

        /* Picture is two fields ? */
        den *= (field_pic_flag ? 2 : 1);
      }
    }
  }

  *fps_num = num;
  *fps_den = den;
}
