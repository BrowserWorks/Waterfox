/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Library       <2002> Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2007 David A. Schleef <ds@schleef.org>
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

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <string.h>
#include <stdio.h>

#include "video-color.h"

typedef struct
{
  const gchar *name;
  GstVideoColorimetry color;
} ColorimetryInfo;

#define MAKE_COLORIMETRY(n,r,m,t,p) { GST_VIDEO_COLORIMETRY_ ##n, \
  { GST_VIDEO_COLOR_RANGE ##r, GST_VIDEO_COLOR_MATRIX_ ##m, \
  GST_VIDEO_TRANSFER_ ##t, GST_VIDEO_COLOR_PRIMARIES_ ##p } }

#define GST_VIDEO_COLORIMETRY_NONAME  NULL

#define DEFAULT_YUV_SD  0
#define DEFAULT_YUV_HD  1
#define DEFAULT_RGB     3
#define DEFAULT_GRAY    4
#define DEFAULT_UNKNOWN 5

static const ColorimetryInfo colorimetry[] = {
  MAKE_COLORIMETRY (BT601, _16_235, BT601, BT709, BT470M),
  MAKE_COLORIMETRY (BT709, _16_235, BT709, BT709, BT709),
  MAKE_COLORIMETRY (SMPTE240M, _16_235, SMPTE240M, SMPTE240M, SMPTE240M),
  MAKE_COLORIMETRY (NONAME, _0_255, RGB, UNKNOWN, UNKNOWN),
  MAKE_COLORIMETRY (NONAME, _0_255, BT601, UNKNOWN, UNKNOWN),
  MAKE_COLORIMETRY (NONAME, _UNKNOWN, UNKNOWN, UNKNOWN, UNKNOWN),
};

static const ColorimetryInfo *
gst_video_get_colorimetry (const gchar * s)
{
  gint i;

  for (i = 0; colorimetry[i].name; i++) {
    if (g_str_equal (colorimetry[i].name, s))
      return &colorimetry[i];
  }
  return NULL;
}

#define IS_EQUAL(ci,i) (((ci)->color.range == (i)->range) && \
                        ((ci)->color.matrix == (i)->matrix) && \
                        ((ci)->color.transfer == (i)->transfer) && \
                        ((ci)->color.primaries == (i)->primaries))

#define IS_UNKNOWN(ci) (IS_EQUAL (&colorimetry[DEFAULT_UNKNOWN], ci))

/**
 * gst_video_colorimetry_from_string:
 * @cinfo: a #GstVideoColorimetry
 * @color: a colorimetry string
 *
 * Parse the colorimetry string and update @cinfo with the parsed
 * values.
 *
 * Returns: #TRUE if @color points to valid colorimetry info.
 */
gboolean
gst_video_colorimetry_from_string (GstVideoColorimetry * cinfo,
    const gchar * color)
{
  const ColorimetryInfo *ci;

  if ((ci = gst_video_get_colorimetry (color))) {
    *cinfo = ci->color;
  } else {
    gint r, m, t, p;

    if (sscanf (color, "%d:%d:%d:%d", &r, &m, &t, &p) == 4) {
      cinfo->range = r;
      cinfo->matrix = m;
      cinfo->transfer = t;
      cinfo->primaries = p;
    }
  }
  return TRUE;
}

/**
 * gst_video_colorimetry_to_string:
 * @cinfo: a #GstVideoColorimetry
 *
 * Make a string representation of @cinfo.
 *
 * Returns: a string representation of @cinfo.
 */
gchar *
gst_video_colorimetry_to_string (GstVideoColorimetry * cinfo)
{
  gint i;

  for (i = 0; colorimetry[i].name; i++) {
    if (IS_EQUAL (&colorimetry[i], cinfo)) {
      return g_strdup (colorimetry[i].name);
    }
  }
  if (!IS_UNKNOWN (cinfo)) {
    return g_strdup_printf ("%d:%d:%d:%d", cinfo->range, cinfo->matrix,
        cinfo->transfer, cinfo->primaries);
  }
  return NULL;
}

/**
 * gst_video_colorimetry_matches:
 * @cinfo: a #GstVideoInfo
 * @color: a colorimetry string
 *
 * Check if the colorimetry information in @info matches that of the
 * string @color.
 *
 * Returns: #TRUE if @color conveys the same colorimetry info as the color
 * information in @info.
 */
gboolean
gst_video_colorimetry_matches (GstVideoColorimetry * cinfo, const gchar * color)
{
  const ColorimetryInfo *ci;

  if ((ci = gst_video_get_colorimetry (color)))
    return IS_EQUAL (ci, cinfo);

  return FALSE;
}

/**
 * gst_video_color_range_offsets:
 * @range: a #GstVideoColorRange
 * @info: a #GstVideoFormatInfo
 * @offset: (out): output offsets
 * @scale: (out): output scale
 *
 * Compute the offset and scale values for each component of @info. For each
 * component, (c[i] - offset[i]) / scale[i] will scale the component c[i] to the
 * range [0.0 .. 1.0].
 *
 * The reverse operation (c[i] * scale[i]) + offset[i] can be used to convert
 * the component values in range [0.0 .. 1.0] back to their representation in
 * @info and @range.
 */
void
gst_video_color_range_offsets (GstVideoColorRange range,
    const GstVideoFormatInfo * info, gint offset[GST_VIDEO_MAX_COMPONENTS],
    gint scale[GST_VIDEO_MAX_COMPONENTS])
{
  gboolean yuv;

  yuv = GST_VIDEO_FORMAT_INFO_IS_YUV (info);

  switch (range) {
    default:
    case GST_VIDEO_COLOR_RANGE_0_255:
      offset[0] = 0;
      if (yuv) {
        offset[1] = 1 << (info->depth[1] - 1);
        offset[2] = 1 << (info->depth[2] - 1);
      } else {
        offset[1] = 0;
        offset[2] = 0;
      }
      scale[0] = (1 << info->depth[0]) - 1;
      scale[1] = (1 << info->depth[1]) - 1;
      scale[2] = (1 << info->depth[2]) - 1;
      break;
    case GST_VIDEO_COLOR_RANGE_16_235:
      offset[0] = 1 << (info->depth[0] - 4);
      scale[0] = 219 << (info->depth[0] - 8);
      if (yuv) {
        offset[1] = 1 << (info->depth[1] - 1);
        offset[2] = 1 << (info->depth[2] - 1);
        scale[1] = 224 << (info->depth[1] - 8);
        scale[2] = 224 << (info->depth[2] - 8);
      } else {
        offset[1] = 1 << (info->depth[1] - 4);
        offset[2] = 1 << (info->depth[2] - 4);
        scale[1] = 219 << (info->depth[1] - 8);
        scale[2] = 219 << (info->depth[2] - 8);
      }
      break;
  }
  /* alpha channel is always full range */
  offset[3] = 0;
  scale[3] = (1 << info->depth[3]) - 1;

  GST_DEBUG ("scale: %d %d %d %d", scale[0], scale[1], scale[2], scale[3]);
  GST_DEBUG ("offset: %d %d %d %d", offset[0], offset[1], offset[2], offset[3]);
}


#if 0
typedef struct
{
  GstVideoColorPrimaries primaries;
  gdouble xW, yW;
  gdouble xR, yR;
  gdouble xG, yG;
  gdouble xB, yB;
} PrimariesInfo;

#define WP_C    0.31006, 0.31616
#define WP_D65  0.31271, 0.32902

static const PrimariesInfo primaries[] = {
  {GST_VIDEO_COLOR_PRIMARIES_UNKNOWN, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
  {GST_VIDEO_COLOR_PRIMARIES_BT709, WP_D65, 0.64, 0.33, 0.30, 0.60, 0.15, 0.06},
  {GST_VIDEO_COLOR_PRIMARIES_BT470M, WP_C, 0.67, 0.33, 0.21, 0.71, 0.14, 0.08},
  {GST_VIDEO_COLOR_PRIMARIES_BT470BG, WP_D65, 0.64, 0.33, 0.29, 0.60, 0.15,
      0.06},
  {GST_VIDEO_COLOR_PRIMARIES_SMPTE170M, WP_D65, 0.63, 0.34, 0.31, 0.595, 0.155,
      0.07},
  {GST_VIDEO_COLOR_PRIMARIES_SMPTE240M, WP_D65, 0.63, 0.34, 0.31, 0.595, 0.155,
      0.07},
  {GST_VIDEO_COLOR_PRIMARIES_FILM, WP_C, 0.681, 0.319, 0.243, 0.692, 0.145,
      0.049}
};
#endif
