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

#include "video-info.h"
#include "video-tile.h"

static int fill_planes (GstVideoInfo * info);

/**
 * gst_video_info_init:
 * @info: a #GstVideoInfo
 *
 * Initialize @info with default values.
 */
void
gst_video_info_init (GstVideoInfo * info)
{
  g_return_if_fail (info != NULL);

  memset (info, 0, sizeof (GstVideoInfo));

  info->finfo = gst_video_format_get_info (GST_VIDEO_FORMAT_UNKNOWN);

  info->views = 1;
  /* arrange for sensible defaults, e.g. if turned into caps */
  info->fps_n = 0;
  info->fps_d = 1;
  info->par_n = 1;
  info->par_d = 1;
}

#define MAKE_COLORIMETRY(r,m,t,p) {  \
  GST_VIDEO_COLOR_RANGE ##r, GST_VIDEO_COLOR_MATRIX_ ##m, \
  GST_VIDEO_TRANSFER_ ##t, GST_VIDEO_COLOR_PRIMARIES_ ##p }

#define DEFAULT_YUV_SD  0
#define DEFAULT_YUV_HD  1
#define DEFAULT_RGB     2
#define DEFAULT_GRAY    3
#define DEFAULT_UNKNOWN 4

static const GstVideoColorimetry default_color[] = {
  MAKE_COLORIMETRY (_16_235, BT601, BT709, BT470M),
  MAKE_COLORIMETRY (_16_235, BT709, BT709, BT709),
  MAKE_COLORIMETRY (_0_255, RGB, UNKNOWN, UNKNOWN),
  MAKE_COLORIMETRY (_0_255, BT601, UNKNOWN, UNKNOWN),
  MAKE_COLORIMETRY (_UNKNOWN, UNKNOWN, UNKNOWN, UNKNOWN),
};

/**
 * gst_video_info_set_format:
 * @info: a #GstVideoInfo
 * @format: the format
 * @width: a width
 * @height: a height
 *
 * Set the default info for a video frame of @format and @width and @height.
 *
 * Note: This initializes @info first, no values are preserved.
 */
void
gst_video_info_set_format (GstVideoInfo * info, GstVideoFormat format,
    guint width, guint height)
{
  const GstVideoFormatInfo *finfo;

  g_return_if_fail (info != NULL);
  g_return_if_fail (format != GST_VIDEO_FORMAT_UNKNOWN);

  gst_video_info_init (info);

  finfo = gst_video_format_get_info (format);

  info->flags = 0;
  info->finfo = finfo;
  info->width = width;
  info->height = height;

  if (GST_VIDEO_FORMAT_INFO_IS_YUV (finfo)) {
    if (height > 576)
      info->colorimetry = default_color[DEFAULT_YUV_HD];
    else
      info->colorimetry = default_color[DEFAULT_YUV_SD];
  } else if (GST_VIDEO_FORMAT_INFO_IS_GRAY (finfo)) {
    info->colorimetry = default_color[DEFAULT_GRAY];
  } else if (GST_VIDEO_FORMAT_INFO_IS_RGB (finfo)) {
    info->colorimetry = default_color[DEFAULT_RGB];
  } else {
    info->colorimetry = default_color[DEFAULT_UNKNOWN];
  }

  fill_planes (info);
}

static const gchar *interlace_mode[] = {
  "progressive",
  "interleaved",
  "mixed",
  "fields"
};

static const gchar *
gst_interlace_mode_to_string (GstVideoInterlaceMode mode)
{
  if (((guint) mode) >= G_N_ELEMENTS (interlace_mode))
    return NULL;

  return interlace_mode[mode];
}

static GstVideoInterlaceMode
gst_interlace_mode_from_string (const gchar * mode)
{
  gint i;
  for (i = 0; i < G_N_ELEMENTS (interlace_mode); i++) {
    if (g_str_equal (interlace_mode[i], mode))
      return i;
  }
  return GST_VIDEO_INTERLACE_MODE_PROGRESSIVE;
}

/**
 * gst_video_info_from_caps:
 * @info: a #GstVideoInfo
 * @caps: a #GstCaps
 *
 * Parse @caps and update @info.
 *
 * Returns: TRUE if @caps could be parsed
 */
gboolean
gst_video_info_from_caps (GstVideoInfo * info, const GstCaps * caps)
{
  GstStructure *structure;
  const gchar *s;
  GstVideoFormat format = GST_VIDEO_FORMAT_UNKNOWN;
  gint width = 0, height = 0, views;
  gint fps_n, fps_d;
  gint par_n, par_d;

  g_return_val_if_fail (info != NULL, FALSE);
  g_return_val_if_fail (caps != NULL, FALSE);
  g_return_val_if_fail (gst_caps_is_fixed (caps), FALSE);

  GST_DEBUG ("parsing caps %" GST_PTR_FORMAT, caps);

  structure = gst_caps_get_structure (caps, 0);

  if (gst_structure_has_name (structure, "video/x-raw")) {
    if (!(s = gst_structure_get_string (structure, "format")))
      goto no_format;

    format = gst_video_format_from_string (s);
    if (format == GST_VIDEO_FORMAT_UNKNOWN)
      goto unknown_format;

  } else if (g_str_has_prefix (gst_structure_get_name (structure), "video/") ||
      g_str_has_prefix (gst_structure_get_name (structure), "image/")) {
    format = GST_VIDEO_FORMAT_ENCODED;
  } else {
    goto wrong_name;
  }

  /* width and height are mandatory, except for non-raw-formats */
  if (!gst_structure_get_int (structure, "width", &width) &&
      format != GST_VIDEO_FORMAT_ENCODED)
    goto no_width;
  if (!gst_structure_get_int (structure, "height", &height) &&
      format != GST_VIDEO_FORMAT_ENCODED)
    goto no_height;

  gst_video_info_set_format (info, format, width, height);

  if (gst_structure_get_fraction (structure, "framerate", &fps_n, &fps_d)) {
    if (fps_n == 0) {
      /* variable framerate */
      info->flags |= GST_VIDEO_FLAG_VARIABLE_FPS;
      /* see if we have a max-framerate */
      gst_structure_get_fraction (structure, "max-framerate", &fps_n, &fps_d);
    }
    info->fps_n = fps_n;
    info->fps_d = fps_d;
  } else {
    /* unspecified is variable framerate */
    info->fps_n = 0;
    info->fps_d = 1;
  }

  if ((s = gst_structure_get_string (structure, "interlace-mode")))
    info->interlace_mode = gst_interlace_mode_from_string (s);
  else
    info->interlace_mode = GST_VIDEO_INTERLACE_MODE_PROGRESSIVE;

  if (gst_structure_get_int (structure, "views", &views))
    info->views = views;
  else
    info->views = 1;

  if ((s = gst_structure_get_string (structure, "chroma-site")))
    info->chroma_site = gst_video_chroma_from_string (s);
  else
    info->chroma_site = GST_VIDEO_CHROMA_SITE_UNKNOWN;

  if ((s = gst_structure_get_string (structure, "colorimetry")))
    gst_video_colorimetry_from_string (&info->colorimetry, s);

  if (gst_structure_get_fraction (structure, "pixel-aspect-ratio",
          &par_n, &par_d)) {
    info->par_n = par_n;
    info->par_d = par_d;
  } else {
    info->par_n = 1;
    info->par_d = 1;
  }
  return TRUE;

  /* ERROR */
wrong_name:
  {
    GST_ERROR ("wrong name '%s', expected video/ or image/",
        gst_structure_get_name (structure));
    return FALSE;
  }
no_format:
  {
    GST_ERROR ("no format given");
    return FALSE;
  }
unknown_format:
  {
    GST_ERROR ("unknown format '%s' given", s);
    return FALSE;
  }
no_width:
  {
    GST_ERROR ("no width property given");
    return FALSE;
  }
no_height:
  {
    GST_ERROR ("no height property given");
    return FALSE;
  }
}

/**
 * gst_video_info_is_equal:
 * @info: a #GstVideoInfo
 * @other: a #GstVideoInfo
 *
 * Compares two #GstVideoInfo and returns whether they are equal or not
 *
 * Returns: %TRUE if @info and @other are equal, else %FALSE.
 */
gboolean
gst_video_info_is_equal (const GstVideoInfo * info, const GstVideoInfo * other)
{
  gint i;

  if (GST_VIDEO_INFO_FORMAT (info) != GST_VIDEO_INFO_FORMAT (other))
    return FALSE;
  if (GST_VIDEO_INFO_INTERLACE_MODE (info) !=
      GST_VIDEO_INFO_INTERLACE_MODE (other))
    return FALSE;
  if (GST_VIDEO_INFO_FLAGS (info) != GST_VIDEO_INFO_FLAGS (other))
    return FALSE;
  if (GST_VIDEO_INFO_WIDTH (info) != GST_VIDEO_INFO_WIDTH (other))
    return FALSE;
  if (GST_VIDEO_INFO_HEIGHT (info) != GST_VIDEO_INFO_HEIGHT (other))
    return FALSE;
  if (GST_VIDEO_INFO_SIZE (info) != GST_VIDEO_INFO_SIZE (other))
    return FALSE;
  if (GST_VIDEO_INFO_PAR_N (info) != GST_VIDEO_INFO_PAR_N (other))
    return FALSE;
  if (GST_VIDEO_INFO_PAR_D (info) != GST_VIDEO_INFO_PAR_D (other))
    return FALSE;
  if (GST_VIDEO_INFO_FPS_N (info) != GST_VIDEO_INFO_FPS_N (other))
    return FALSE;
  if (GST_VIDEO_INFO_FPS_D (info) != GST_VIDEO_INFO_FPS_D (other))
    return FALSE;

  for (i = 0; i < info->finfo->n_planes; i++) {
    if (info->stride[i] != other->stride[i])
      return FALSE;
    if (info->offset[i] != other->offset[i])
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_video_info_to_caps:
 * @info: a #GstVideoInfo
 *
 * Convert the values of @info into a #GstCaps.
 *
 * Returns: a new #GstCaps containing the info of @info.
 */
GstCaps *
gst_video_info_to_caps (GstVideoInfo * info)
{
  GstCaps *caps;
  const gchar *format;
  gchar *color;

  g_return_val_if_fail (info != NULL, NULL);
  g_return_val_if_fail (info->finfo != NULL, NULL);
  g_return_val_if_fail (info->finfo->format != GST_VIDEO_FORMAT_UNKNOWN, NULL);

  format = gst_video_format_to_string (info->finfo->format);
  g_return_val_if_fail (format != NULL, NULL);

  caps = gst_caps_new_simple ("video/x-raw",
      "format", G_TYPE_STRING, format,
      "width", G_TYPE_INT, info->width,
      "height", G_TYPE_INT, info->height,
      "pixel-aspect-ratio", GST_TYPE_FRACTION, info->par_n, info->par_d, NULL);

  gst_caps_set_simple (caps, "interlace-mode", G_TYPE_STRING,
      gst_interlace_mode_to_string (info->interlace_mode), NULL);

  if (info->chroma_site != GST_VIDEO_CHROMA_SITE_UNKNOWN)
    gst_caps_set_simple (caps, "chroma-site", G_TYPE_STRING,
        gst_video_chroma_to_string (info->chroma_site), NULL);

  if ((color = gst_video_colorimetry_to_string (&info->colorimetry))) {
    gst_caps_set_simple (caps, "colorimetry", G_TYPE_STRING, color, NULL);
    g_free (color);
  }

  if (info->views > 1)
    gst_caps_set_simple (caps, "views", G_TYPE_INT, info->views, NULL);

  if (info->flags & GST_VIDEO_FLAG_VARIABLE_FPS && info->fps_n != 0) {
    /* variable fps with a max-framerate */
    gst_caps_set_simple (caps, "framerate", GST_TYPE_FRACTION, 0, 1,
        "max-framerate", GST_TYPE_FRACTION, info->fps_n, info->fps_d, NULL);
  } else {
    /* no variable fps or no max-framerate */
    gst_caps_set_simple (caps, "framerate", GST_TYPE_FRACTION,
        info->fps_n, info->fps_d, NULL);
  }

  return caps;
}

static int
fill_planes (GstVideoInfo * info)
{
  gsize width, height;

  width = (gsize) info->width;
  height = (gsize) info->height;

  switch (info->finfo->format) {
    case GST_VIDEO_FORMAT_YUY2:
    case GST_VIDEO_FORMAT_YVYU:
    case GST_VIDEO_FORMAT_UYVY:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_AYUV:
    case GST_VIDEO_FORMAT_RGBx:
    case GST_VIDEO_FORMAT_RGBA:
    case GST_VIDEO_FORMAT_BGRx:
    case GST_VIDEO_FORMAT_BGRA:
    case GST_VIDEO_FORMAT_xRGB:
    case GST_VIDEO_FORMAT_ARGB:
    case GST_VIDEO_FORMAT_xBGR:
    case GST_VIDEO_FORMAT_ABGR:
    case GST_VIDEO_FORMAT_r210:
      info->stride[0] = width * 4;
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_RGB16:
    case GST_VIDEO_FORMAT_BGR16:
    case GST_VIDEO_FORMAT_RGB15:
    case GST_VIDEO_FORMAT_BGR15:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_RGB:
    case GST_VIDEO_FORMAT_BGR:
    case GST_VIDEO_FORMAT_v308:
      info->stride[0] = GST_ROUND_UP_4 (width * 3);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_v210:
      info->stride[0] = ((width + 47) / 48) * 128;
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_v216:
      info->stride[0] = GST_ROUND_UP_8 (width * 4);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_GRAY8:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_GRAY16_BE:
    case GST_VIDEO_FORMAT_GRAY16_LE:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_UYVP:
      info->stride[0] = GST_ROUND_UP_4 ((width * 2 * 5 + 3) / 4);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_RGB8P:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = 4;
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->size = info->offset[1] + (4 * 256);
      break;
    case GST_VIDEO_FORMAT_IYU1:
      info->stride[0] = GST_ROUND_UP_4 (GST_ROUND_UP_4 (width) +
          GST_ROUND_UP_4 (width) / 2);
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_ARGB64:
    case GST_VIDEO_FORMAT_AYUV64:
      info->stride[0] = width * 8;
      info->offset[0] = 0;
      info->size = info->stride[0] * height;
      break;
    case GST_VIDEO_FORMAT_I420:
    case GST_VIDEO_FORMAT_YV12:        /* same as I420, but plane 1+2 swapped */
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_4 (GST_ROUND_UP_2 (width) / 2);
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * GST_ROUND_UP_2 (height);
      info->offset[2] = info->offset[1] +
          info->stride[1] * (GST_ROUND_UP_2 (height) / 2);
      info->size = info->offset[2] +
          info->stride[2] * (GST_ROUND_UP_2 (height) / 2);
      break;
    case GST_VIDEO_FORMAT_Y41B:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_16 (width) / 4;
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->offset[2] = info->offset[1] + info->stride[1] * height;
      /* simplification of ROUNDUP4(w)*h + 2*((ROUNDUP16(w)/4)*h */
      info->size = (info->stride[0] + (GST_ROUND_UP_16 (width) / 2)) * height;
      break;
    case GST_VIDEO_FORMAT_Y42B:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_8 (width) / 2;
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->offset[2] = info->offset[1] + info->stride[1] * height;
      /* simplification of ROUNDUP4(w)*h + 2*(ROUNDUP8(w)/2)*h */
      info->size = (info->stride[0] + GST_ROUND_UP_8 (width)) * height;
      break;
    case GST_VIDEO_FORMAT_Y444:
    case GST_VIDEO_FORMAT_GBR:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = info->stride[0];
      info->stride[2] = info->stride[0];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->offset[2] = info->offset[1] * 2;
      info->size = info->stride[0] * height * 3;
      break;
    case GST_VIDEO_FORMAT_NV12:
    case GST_VIDEO_FORMAT_NV21:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = info->stride[0];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * GST_ROUND_UP_2 (height);
      info->size = info->stride[0] * GST_ROUND_UP_2 (height) * 3 / 2;
      break;
    case GST_VIDEO_FORMAT_NV16:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = info->stride[0];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->size = info->stride[0] * height * 2;
      break;
    case GST_VIDEO_FORMAT_NV24:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_4 (width * 2);
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->size = info->stride[0] * height + info->stride[1] * height;
      break;
    case GST_VIDEO_FORMAT_A420:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_4 (GST_ROUND_UP_2 (width) / 2);
      info->stride[2] = info->stride[1];
      info->stride[3] = info->stride[0];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * GST_ROUND_UP_2 (height);
      info->offset[2] = info->offset[1] +
          info->stride[1] * (GST_ROUND_UP_2 (height) / 2);
      info->offset[3] = info->offset[2] +
          info->stride[2] * (GST_ROUND_UP_2 (height) / 2);
      info->size = info->offset[3] + info->stride[0] * GST_ROUND_UP_2 (height);
      break;
    case GST_VIDEO_FORMAT_YUV9:
    case GST_VIDEO_FORMAT_YVU9:
      info->stride[0] = GST_ROUND_UP_4 (width);
      info->stride[1] = GST_ROUND_UP_4 (GST_ROUND_UP_4 (width) / 4);
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->offset[2] = info->offset[1] +
          info->stride[1] * (GST_ROUND_UP_4 (height) / 4);
      info->size = info->offset[2] +
          info->stride[2] * (GST_ROUND_UP_4 (height) / 4);
      break;
    case GST_VIDEO_FORMAT_I420_10LE:
    case GST_VIDEO_FORMAT_I420_10BE:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->stride[1] = GST_ROUND_UP_4 (width);
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * GST_ROUND_UP_2 (height);
      info->offset[2] = info->offset[1] +
          info->stride[1] * (GST_ROUND_UP_2 (height) / 2);
      info->size = info->offset[2] +
          info->stride[2] * (GST_ROUND_UP_2 (height) / 2);
      break;
    case GST_VIDEO_FORMAT_I422_10LE:
    case GST_VIDEO_FORMAT_I422_10BE:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->stride[1] = GST_ROUND_UP_4 (width);
      info->stride[2] = info->stride[1];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * GST_ROUND_UP_2 (height);
      info->offset[2] = info->offset[1] +
          info->stride[1] * GST_ROUND_UP_2 (height);
      info->size = info->offset[2] + info->stride[2] * GST_ROUND_UP_2 (height);
      break;
    case GST_VIDEO_FORMAT_Y444_10LE:
    case GST_VIDEO_FORMAT_Y444_10BE:
    case GST_VIDEO_FORMAT_GBR_10LE:
    case GST_VIDEO_FORMAT_GBR_10BE:
      info->stride[0] = GST_ROUND_UP_4 (width * 2);
      info->stride[1] = info->stride[0];
      info->stride[2] = info->stride[0];
      info->offset[0] = 0;
      info->offset[1] = info->stride[0] * height;
      info->offset[2] = info->offset[1] * 2;
      info->size = info->stride[0] * height * 3;
      break;
    case GST_VIDEO_FORMAT_NV12_64Z32:
      info->stride[0] =
          GST_VIDEO_TILE_MAKE_STRIDE (GST_ROUND_UP_128 (width) / 64,
          GST_ROUND_UP_32 (height) / 32);
      info->stride[1] =
          GST_VIDEO_TILE_MAKE_STRIDE (GST_ROUND_UP_128 (width) / 64,
          GST_ROUND_UP_64 (height) / 64);
      info->offset[0] = 0;
      info->offset[1] = GST_ROUND_UP_128 (width) * GST_ROUND_UP_32 (height);
      info->size = info->offset[1] +
          GST_ROUND_UP_128 (width) * GST_ROUND_UP_64 (height) / 2;
      break;
    case GST_VIDEO_FORMAT_ENCODED:
      break;
    case GST_VIDEO_FORMAT_UNKNOWN:
      GST_ERROR ("invalid format");
      g_warning ("invalid format");
      break;
  }
  return 0;
}

/**
 * gst_video_info_convert:
 * @info: a #GstVideoInfo
 * @src_format: #GstFormat of the @src_value
 * @src_value: value to convert
 * @dest_format: #GstFormat of the @dest_value
 * @dest_value: pointer to destination value
 *
 * Converts among various #GstFormat types.  This function handles
 * GST_FORMAT_BYTES, GST_FORMAT_TIME, and GST_FORMAT_DEFAULT.  For
 * raw video, GST_FORMAT_DEFAULT corresponds to video frames.  This
 * function can be used to handle pad queries of the type GST_QUERY_CONVERT.
 *
 * Returns: TRUE if the conversion was successful.
 */
gboolean
gst_video_info_convert (GstVideoInfo * info,
    GstFormat src_format, gint64 src_value,
    GstFormat dest_format, gint64 * dest_value)
{
  gboolean ret = FALSE;
  int fps_n, fps_d;
  gsize size;

  g_return_val_if_fail (info != NULL, 0);
  g_return_val_if_fail (info->finfo != NULL, 0);
  g_return_val_if_fail (info->finfo->format != GST_VIDEO_FORMAT_UNKNOWN, 0);
  g_return_val_if_fail (info->size > 0, 0);

  size = info->size;
  fps_n = info->fps_n;
  fps_d = info->fps_d;

  GST_DEBUG ("converting value %" G_GINT64_FORMAT " from %s to %s",
      src_value, gst_format_get_name (src_format),
      gst_format_get_name (dest_format));

  if (src_format == dest_format) {
    *dest_value = src_value;
    ret = TRUE;
    goto done;
  }

  if (src_value == -1) {
    *dest_value = -1;
    ret = TRUE;
    goto done;
  }

  /* bytes to frames */
  if (src_format == GST_FORMAT_BYTES && dest_format == GST_FORMAT_DEFAULT) {
    if (size != 0) {
      *dest_value = gst_util_uint64_scale (src_value, 1, size);
    } else {
      GST_ERROR ("blocksize is 0");
      *dest_value = 0;
    }
    ret = TRUE;
    goto done;
  }

  /* frames to bytes */
  if (src_format == GST_FORMAT_DEFAULT && dest_format == GST_FORMAT_BYTES) {
    *dest_value = gst_util_uint64_scale (src_value, size, 1);
    ret = TRUE;
    goto done;
  }

  /* time to frames */
  if (src_format == GST_FORMAT_TIME && dest_format == GST_FORMAT_DEFAULT) {
    if (fps_d != 0) {
      *dest_value = gst_util_uint64_scale (src_value,
          fps_n, GST_SECOND * fps_d);
    } else {
      GST_ERROR ("framerate denominator is 0");
      *dest_value = 0;
    }
    ret = TRUE;
    goto done;
  }

  /* frames to time */
  if (src_format == GST_FORMAT_DEFAULT && dest_format == GST_FORMAT_TIME) {
    if (fps_n != 0) {
      *dest_value = gst_util_uint64_scale (src_value,
          GST_SECOND * fps_d, fps_n);
    } else {
      GST_ERROR ("framerate numerator is 0");
      *dest_value = 0;
    }
    ret = TRUE;
    goto done;
  }

  /* time to bytes */
  if (src_format == GST_FORMAT_TIME && dest_format == GST_FORMAT_BYTES) {
    if (fps_d != 0) {
      *dest_value = gst_util_uint64_scale (src_value,
          fps_n * size, GST_SECOND * fps_d);
    } else {
      GST_ERROR ("framerate denominator is 0");
      *dest_value = 0;
    }
    ret = TRUE;
    goto done;
  }

  /* bytes to time */
  if (src_format == GST_FORMAT_BYTES && dest_format == GST_FORMAT_TIME) {
    if (fps_n != 0 && size != 0) {
      *dest_value = gst_util_uint64_scale (src_value,
          GST_SECOND * fps_d, fps_n * size);
    } else {
      GST_ERROR ("framerate denominator and/or blocksize is 0");
      *dest_value = 0;
    }
    ret = TRUE;
  }

done:

  GST_DEBUG ("ret=%d result %" G_GINT64_FORMAT, ret, *dest_value);

  return ret;
}

/**
 * gst_video_info_align:
 * @info: a #GstVideoInfo
 * @align: alignment parameters
 *
 * Adjust the offset and stride fields in @info so that the padding and
 * stride alignment in @align is respected.
 *
 * Extra padding will be added to the right side when stride alignment padding
 * is required and @align will be updated with the new padding values.
 */
void
gst_video_info_align (GstVideoInfo * info, GstVideoAlignment * align)
{
  const GstVideoFormatInfo *vinfo = info->finfo;
  gint width, height;
  gint padded_width, padded_height;
  gint i, n_planes;
  gboolean aligned;

  width = GST_VIDEO_INFO_WIDTH (info);
  height = GST_VIDEO_INFO_HEIGHT (info);

  GST_LOG ("padding %u-%ux%u-%u", align->padding_top,
      align->padding_left, align->padding_right, align->padding_bottom);

  n_planes = GST_VIDEO_INFO_N_PLANES (info);

  if (GST_VIDEO_FORMAT_INFO_HAS_PALETTE (vinfo))
    n_planes--;

  /* first make sure the left padding does not cause alignment problems later */
  do {
    GST_LOG ("left padding %u", align->padding_left);
    aligned = TRUE;
    for (i = 0; i < n_planes; i++) {
      gint hedge;

      /* this is the amout of pixels to add as left padding */
      hedge = GST_VIDEO_FORMAT_INFO_SCALE_WIDTH (vinfo, i, align->padding_left);
      hedge *= GST_VIDEO_FORMAT_INFO_PSTRIDE (vinfo, i);

      GST_LOG ("plane %d, padding %d, alignment %u", i, hedge,
          align->stride_align[i]);
      aligned &= (hedge & align->stride_align[i]) == 0;
    }
    if (aligned)
      break;

    GST_LOG ("unaligned padding, increasing padding");
    /* increase padded_width */
    align->padding_left += align->padding_left & ~(align->padding_left - 1);
  } while (!aligned);

  /* add the padding */
  padded_width = width + align->padding_left + align->padding_right;
  padded_height = height + align->padding_top + align->padding_bottom;

  do {
    GST_LOG ("padded dimension %u-%u", padded_width, padded_height);

    info->width = padded_width;
    info->height = padded_height;
    fill_planes (info);

    /* check alignment */
    aligned = TRUE;
    for (i = 0; i < n_planes; i++) {
      GST_LOG ("plane %d, stride %d, alignment %u", i, info->stride[i],
          align->stride_align[i]);
      aligned &= (info->stride[i] & align->stride_align[i]) == 0;
    }
    if (aligned)
      break;

    GST_LOG ("unaligned strides, increasing dimension");
    /* increase padded_width */
    padded_width += padded_width & ~(padded_width - 1);
  } while (!aligned);

  align->padding_right = padded_width - width - align->padding_left;

  info->width = width;
  info->height = height;

  for (i = 0; i < n_planes; i++) {
    gint vedge, hedge, comp;

    /* Find the component for this plane, FIXME, we assume the plane number and
     * component number is the same for now, for scaling the dimensions this is
     * currently true for all formats but it might not be when adding new
     * formats. We might need to add a plane subsamling in the format info to
     * make this more generic or maybe use a plane -> component mapping. */
    comp = i;

    hedge =
        GST_VIDEO_FORMAT_INFO_SCALE_WIDTH (vinfo, comp, align->padding_left);
    vedge =
        GST_VIDEO_FORMAT_INFO_SCALE_HEIGHT (vinfo, comp, align->padding_top);

    GST_DEBUG ("plane %d: comp: %d, hedge %d vedge %d align %d stride %d", i,
        comp, hedge, vedge, align->stride_align[i], info->stride[i]);

    info->offset[i] += (vedge * info->stride[i]) +
        (hedge * GST_VIDEO_FORMAT_INFO_PSTRIDE (vinfo, comp));
  }
}
