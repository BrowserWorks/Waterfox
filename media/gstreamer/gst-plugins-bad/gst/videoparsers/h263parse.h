/* GStreamer H.263 Parser
 * Copyright (C) <2010> Arun Raghavan <arun.raghavan@collabora.co.uk>
 * Copyright (C) <2010> Edward Hervey <edward.hervey@collabora.co.uk>
 * Copyright (C) <2010> Collabora Multimedia
 * Copyright (C) <2010> Nokia Corporation
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

#ifndef __GST_H263_PARAMS_H__
#define __GST_H263_PARAMS_H__

#include <gst/gst.h>
#include <gst/base/gstadapter.h>

G_BEGIN_DECLS

typedef enum
{
  PARSING = 0,
  GOT_HEADER,
  PASSTHROUGH
} H263ParseState;

/* H263 Optional Features */
typedef enum
{
  /* Optional Unrestricted Motion Vector (UMV) mode (see Annex D) */
  H263_OPTION_UMV_MODE = 1 << 0,
  /* Optional Syntax-based Arithmetic Coding (SAC) mode (see Annex E) */
  H263_OPTION_SAC_MODE = 1 << 1,
  /* Optional Advanced Prediction mode (AP) (see Annex F) */
  H263_OPTION_AP_MODE = 1 << 2,
  /* Optional PB-frames mode (see Annex G) */
  H263_OPTION_PB_MODE = 1 << 3,
  /* Optional Advanced INTRA Coding (AIC) mode (see Annex I) */
  H263_OPTION_AIC_MODE = 1 << 4,
  /* Optional Deblocking Filter (DF) mode (see Annex J) */
  H263_OPTION_DF_MODE = 1 << 5,
  /* Optional Slice Structured (SS) mode (see Annex K) */
  H263_OPTION_SS_MODE = 1 << 6,
  /* Optional Reference Picture Selection (RPS) mode (see Annex N) */
  H263_OPTION_RPS_MODE = 1 << 7,
  /* Optional Independent Segment Decoding (ISD) mode (see Annex R) */
  H263_OPTION_ISD_MODE = 1 << 8,
  /* Optional Alternative INTER VLC (AIV) mode (see Annex S) */
  H263_OPTION_AIV_MODE = 1 << 9,
  /* Optional Modified Quantization (MQ) mode (see Annex T) */
  H263_OPTION_MQ_MODE = 1 << 10,
  /* Optional Reference Picture Resampling (RPR) mode (see Annex P) */
  H263_OPTION_RPR_MODE = 1 << 11,
  /* Optional Reduced-Resolution Update (RRU) mode (see Annex Q) */
  H263_OPTION_RRU_MODE = 1 << 12,
  /* Optional Enhanced Reference Picture Selection (ERPS) mode (see Annex U) */
  H263_OPTION_ERPS_MODE = 1 << 13,
  /* Optional Data Partitioned Slices (DPS) mode (see Annex V) */
  H263_OPTION_DPS_MODE = 1 << 14
} H263OptionalFeatures;

/* H263 Picture Types */
typedef enum
{
  PICTURE_I = 0,                /* I-picture (INTRA) Baseline */
  PICTURE_P,                    /* P-picture (INTER) Baseline */
  PICTURE_IMPROVED_PB,          /* Improved PB-frame (Annex M) */
  PICTURE_B,                    /* B-picture (Annex O) */
  PICTURE_EI,                   /* EI-picture (Annex O) */
  PICTURE_EP,                   /* EP-picture (Annex O) */
  PICTURE_RESERVED1,
  PICTURE_RESERVED2,
  PICTURE_PB                    /* PB-frame (See Annex G) */
} H263PictureType;

/* H263 Picture Format */
typedef enum
{
  PICTURE_FMT_FORBIDDEN_0 = 0,
  PICTURE_FMT_SUB_QCIF,
  PICTURE_FMT_QCIF,
  PICTURE_FMT_CIF,
  PICTURE_FMT_4CIF,
  PICTURE_FMT_16CIF,
  PICTURE_FMT_RESERVED1,
  PICTURE_FMT_EXTENDEDPTYPE
} H263PictureFormat;

typedef enum
{
  UUI_ABSENT = 0,
  UUI_IS_1,
  UUI_IS_01,
} H263UUI;


typedef struct _H263Params H263Params;

struct _H263Params
{
  guint32 temporal_ref;

  H263OptionalFeatures features;

  gboolean splitscreen;
  gboolean documentcamera;
  gboolean fullpicturefreezerelease;
  gboolean custompcfpresent;
  H263UUI uui;
  guint8 sss;

  H263PictureFormat format;

  H263PictureType type;

  guint32 width;
  guint32 height;
  guint8 parnum, pardenom;
  gint32 pcfnum, pcfdenom;
};

gboolean      gst_h263_parse_is_delta_unit (const H263Params * params);

GstFlowReturn gst_h263_parse_get_params    (H263Params       * params_p,
                                            GstBuffer        * buffer,
                                            gboolean           fast,
                                            H263ParseState   * state);

void          gst_h263_parse_get_framerate (const H263Params * params,
                                            gint             * num,
                                            gint             * denom);

void          gst_h263_parse_get_par       (const H263Params * params,
                                            gint             * num,
                                            gint             * denom);

gint          gst_h263_parse_get_profile   (const H263Params * params);

gint          gst_h263_parse_get_level     (const H263Params * params,
                                            gint               profile,
                                            guint              bitrate,
                                            gint               fps_num,
                                            gint               fps_denom);

G_END_DECLS
#endif
