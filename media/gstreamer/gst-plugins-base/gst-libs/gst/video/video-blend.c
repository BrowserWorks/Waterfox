/* Gstreamer video blending utility functions
 *
 * Copied/pasted from gst/videoconvert/videoconvert.c
 *    Copyright (C) 2010 David Schleef <ds@schleef.org>
 *    Copyright (C) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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
#include "config.h"
#endif

#include "video-blend.h"
#include "video-orc.h"

#include <string.h>

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT ensure_debug_category()

static GstDebugCategory *
ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat_done;

    cat_done = (gsize) _gst_debug_category_new ("video-blending", 0,
        "video blending");

    g_once_init_leave (&cat_gonce, cat_done);
  }

  return (GstDebugCategory *) cat_gonce;
}

#else

#define ensure_debug_category() /* NOOP */

#endif /* GST_DISABLE_GST_DEBUG */

static void
matrix_identity (guint8 * tmpline, guint width)
{
}

static void
matrix_prea_rgb_to_yuv (guint8 * tmpline, guint width)
{
  int i;
  int a, r, g, b;
  int y, u, v;

  for (i = 0; i < width; i++) {
    a = tmpline[i * 4 + 0];
    r = tmpline[i * 4 + 1];
    g = tmpline[i * 4 + 2];
    b = tmpline[i * 4 + 3];
    if (a) {
      r = (r * 255 + a / 2) / a;
      g = (g * 255 + a / 2) / a;
      b = (b * 255 + a / 2) / a;
    }

    y = (47 * r + 157 * g + 16 * b + 4096) >> 8;
    u = (-26 * r - 87 * g + 112 * b + 32768) >> 8;
    v = (112 * r - 102 * g - 10 * b + 32768) >> 8;

    tmpline[i * 4 + 1] = CLAMP (y, 0, 255);
    tmpline[i * 4 + 2] = CLAMP (u, 0, 255);
    tmpline[i * 4 + 3] = CLAMP (v, 0, 255);
  }
}

static void
matrix_rgb_to_yuv (guint8 * tmpline, guint width)
{
  int i;
  int r, g, b;
  int y, u, v;

  for (i = 0; i < width; i++) {
    r = tmpline[i * 4 + 1];
    g = tmpline[i * 4 + 2];
    b = tmpline[i * 4 + 3];

    y = (47 * r + 157 * g + 16 * b + 4096) >> 8;
    u = (-26 * r - 87 * g + 112 * b + 32768) >> 8;
    v = (112 * r - 102 * g - 10 * b + 32768) >> 8;

    tmpline[i * 4 + 1] = CLAMP (y, 0, 255);
    tmpline[i * 4 + 2] = CLAMP (u, 0, 255);
    tmpline[i * 4 + 3] = CLAMP (v, 0, 255);
  }
}

static void
matrix_yuv_to_rgb (guint8 * tmpline, guint width)
{
  int i;
  int r, g, b;
  int y, u, v;

  for (i = 0; i < width; i++) {
    y = tmpline[i * 4 + 1];
    u = tmpline[i * 4 + 2];
    v = tmpline[i * 4 + 3];

    r = (298 * y + 459 * v - 63514) >> 8;
    g = (298 * y - 55 * u - 136 * v + 19681) >> 8;
    b = (298 * y + 541 * u - 73988) >> 8;

    tmpline[i * 4 + 1] = CLAMP (r, 0, 255);
    tmpline[i * 4 + 2] = CLAMP (g, 0, 255);
    tmpline[i * 4 + 3] = CLAMP (b, 0, 255);
  }
}

#define BLEND00(ret, alpha, v0, v1) \
G_STMT_START { \
  ret = (v0 * alpha + v1 * (255 - alpha)) / 255; \
} G_STMT_END

#define BLEND10(ret, alpha, v0, v1) \
G_STMT_START { \
  ret = v0 + (v1 * (255 - alpha)) / 255; \
} G_STMT_END

/* returns newly-allocated buffer, which caller must unref */
void
gst_video_blend_scale_linear_RGBA (GstVideoInfo * src, GstBuffer * src_buffer,
    gint dest_height, gint dest_width, GstVideoInfo * dest,
    GstBuffer ** dest_buffer)
{
  const guint8 *src_pixels;
  int acc;
  int y_increment;
  int x_increment;
  int y1;
  int i;
  int j;
  int x;
  int dest_size;
  guint dest_stride;
  guint src_stride;
  guint8 *dest_pixels;
  guint8 *tmpbuf;
  GstVideoFrame src_frame, dest_frame;

  g_return_if_fail (dest_buffer != NULL);

  tmpbuf = g_malloc (dest_width * 8 * 4);

  gst_video_info_init (dest);
  gst_video_info_set_format (dest, GST_VIDEO_INFO_FORMAT (src),
      dest_width, dest_height);

  *dest_buffer = gst_buffer_new_and_alloc (GST_VIDEO_INFO_SIZE (dest));

  gst_video_frame_map (&src_frame, src, src_buffer, GST_MAP_READ);
  gst_video_frame_map (&dest_frame, dest, *dest_buffer, GST_MAP_WRITE);

  if (dest_height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest_height - 1) - 1;

  if (dest_width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest_width - 1) - 1;

  dest_size = dest_stride = dest_width * 4;
  src_stride = GST_VIDEO_FRAME_PLANE_STRIDE (&src_frame, 0);

#define LINE(x) ((tmpbuf) + (dest_size)*((x)&1))

  dest_pixels = GST_VIDEO_FRAME_PLANE_DATA (&dest_frame, 0);
  src_pixels = GST_VIDEO_FRAME_PLANE_DATA (&src_frame, 0);

  acc = 0;
  video_orc_resample_bilinear_u32 (LINE (0), src_pixels, 0, x_increment,
      dest_width);
  y1 = 0;
  for (i = 0; i < dest_height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      memcpy (dest_pixels + i * dest_stride, LINE (j), dest_size);
    } else {
      if (j > y1) {
        video_orc_resample_bilinear_u32 (LINE (j),
            src_pixels + j * src_stride, 0, x_increment, dest_width);
        y1++;
      }
      if (j >= y1) {
        video_orc_resample_bilinear_u32 (LINE (j + 1),
            src_pixels + (j + 1) * src_stride, 0, x_increment, dest_width);
        y1++;
      }
      video_orc_merge_linear_u8 (dest_pixels + i * dest_stride,
          LINE (j), LINE (j + 1), (x >> 8), dest_width * 4);
    }

    acc += y_increment;
  }

  gst_video_frame_unmap (&src_frame);
  gst_video_frame_unmap (&dest_frame);

  g_free (tmpbuf);
}

/* video_blend:
 * @dest: The #GstVideoFrame where to blend @src in
 * @src: the #GstVideoFrame that we want to blend into
 * @x: The x offset in pixel where the @src image should be blended
 * @y: the y offset in pixel where the @src image should be blended
 * @global_alpha: the global_alpha each per-pixel alpha value is multiplied
 *                with
 *
 * Lets you blend the @src image into the @dest image
 */
gboolean
gst_video_blend (GstVideoFrame * dest,
    GstVideoFrame * src, gint x, gint y, gfloat global_alpha)
{
  guint i, j, global_alpha_val, src_width, src_height, dest_width, dest_height;
  gint xoff;
  guint8 *tmpdestline = NULL, *tmpsrcline = NULL;
  gboolean src_premultiplied_alpha, dest_premultiplied_alpha;
  void (*matrix) (guint8 * tmpline, guint width);
  const GstVideoFormatInfo *sinfo, *dinfo, *dunpackinfo, *sunpackinfo;

  g_assert (dest != NULL);
  g_assert (src != NULL);

  global_alpha_val = 256.0 * global_alpha;

  dest_premultiplied_alpha =
      GST_VIDEO_INFO_FLAGS (&dest->info) & GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA;
  src_premultiplied_alpha =
      GST_VIDEO_INFO_FLAGS (&src->info) & GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA;

  /* we do no support writing to premultiplied alpha, though that should
     just be a matter of adding blenders below (BLEND01 and BLEND11) */
  g_return_val_if_fail (!dest_premultiplied_alpha, FALSE);

  src_width = GST_VIDEO_FRAME_WIDTH (src);
  src_height = GST_VIDEO_FRAME_HEIGHT (src);

  dest_width = GST_VIDEO_FRAME_WIDTH (dest);
  dest_height = GST_VIDEO_FRAME_HEIGHT (dest);

  ensure_debug_category ();

  dinfo = gst_video_format_get_info (GST_VIDEO_FRAME_FORMAT (dest));
  sinfo = gst_video_format_get_info (GST_VIDEO_FRAME_FORMAT (src));

  if (!sinfo || !dinfo)
    goto failed;

  dunpackinfo = gst_video_format_get_info (dinfo->unpack_format);
  sunpackinfo = gst_video_format_get_info (sinfo->unpack_format);

  if (dunpackinfo == NULL || sunpackinfo == NULL)
    goto failed;

  g_assert (GST_VIDEO_FORMAT_INFO_BITS (sunpackinfo) == 8);

  if (GST_VIDEO_FORMAT_INFO_BITS (dunpackinfo) != 8)
    goto unpack_format_not_supported;

  tmpdestline = g_malloc (sizeof (guint8) * (dest_width + 8) * 4);
  tmpsrcline = g_malloc (sizeof (guint8) * (dest_width + 8) * 4);

  matrix = matrix_identity;
  if (GST_VIDEO_INFO_IS_RGB (&src->info) != GST_VIDEO_INFO_IS_RGB (&dest->info)) {
    if (GST_VIDEO_INFO_IS_RGB (&src->info)) {
      if (src_premultiplied_alpha) {
        matrix = matrix_prea_rgb_to_yuv;
        src_premultiplied_alpha = FALSE;
      } else {
        matrix = matrix_rgb_to_yuv;
      }
    } else {
      matrix = matrix_yuv_to_rgb;
    }
  }

  xoff = 0;

  /* adjust src pointers for negative sizes */
  if (x < 0) {
    src_width -= -x;
    x = 0;
    xoff = -x;
  }

  if (y < 0) {
    src_height -= -y;
    y = 0;
  }

  /* adjust width/height if the src is bigger than dest */
  if (x + src_width > dest_width)
    src_width = dest_width - x;

  if (y + src_height > dest_height)
    src_height = dest_height - y;

  /* Mainloop doing the needed conversions, and blending */
  for (i = y; i < y + src_height; i++) {

    dinfo->unpack_func (dinfo, 0, tmpdestline, dest->data, dest->info.stride,
        0, i, dest_width);
    sinfo->unpack_func (sinfo, 0, tmpsrcline, src->data, src->info.stride,
        xoff, i - y, src_width - xoff);

    matrix (tmpsrcline, src_width);

    tmpdestline += 4 * x;

    /* Here dest and src are both either in AYUV or ARGB
     * TODO: Make the orc version working properly*/
#define BLENDLOOP(blender,alpha_val,alpha_scale)                                  \
  do {                                                                            \
    for (j = 0; j < src_width * 4; j += 4) {                                      \
      guint8 alpha;                                                               \
                                                                                  \
      alpha = (tmpsrcline[j] * alpha_val) / alpha_scale;                          \
                                                                                  \
      blender (tmpdestline[j + 1], alpha, tmpsrcline[j + 1], tmpdestline[j + 1]); \
      blender (tmpdestline[j + 2], alpha, tmpsrcline[j + 2], tmpdestline[j + 2]); \
      blender (tmpdestline[j + 3], alpha, tmpsrcline[j + 3], tmpdestline[j + 3]); \
    }                                                                             \
  } while(0)

    if (G_LIKELY (global_alpha == 1.0)) {
      if (src_premultiplied_alpha && dest_premultiplied_alpha) {
        /* BLENDLOOP (BLEND11, 1, 1); */
      } else if (!src_premultiplied_alpha && dest_premultiplied_alpha) {
        /* BLENDLOOP (BLEND01, 1, 1); */
      } else if (src_premultiplied_alpha && !dest_premultiplied_alpha) {
        BLENDLOOP (BLEND10, 1, 1);
      } else {
        BLENDLOOP (BLEND00, 1, 1);
      }
    } else {
      if (src_premultiplied_alpha && dest_premultiplied_alpha) {
        /* BLENDLOOP (BLEND11, global_alpha_val, 256); */
      } else if (!src_premultiplied_alpha && dest_premultiplied_alpha) {
        /* BLENDLOOP (BLEND01, global_alpha_val, 256); */
      } else if (src_premultiplied_alpha && !dest_premultiplied_alpha) {
        BLENDLOOP (BLEND10, global_alpha_val, 256);
      } else {
        BLENDLOOP (BLEND00, global_alpha_val, 256);
      }
    }

#undef BLENDLOOP

    tmpdestline -= 4 * x;

    /* FIXME
     * #if G_BYTE_ORDER == LITTLE_ENDIAN
     * video_orc_blend_little (tmpdestline, tmpsrcline, dest->width);
     * #else
     * video_orc_blend_big (tmpdestline, tmpsrcline, src->width);
     * #endif
     */

    dinfo->pack_func (dinfo, 0, tmpdestline, dest_width,
        dest->data, dest->info.stride, dest->info.chroma_site, i, dest_width);
  }

  g_free (tmpdestline);
  g_free (tmpsrcline);

  return TRUE;

failed:
  {
    GST_WARNING ("Could not do the blending");
    return FALSE;
  }
unpack_format_not_supported:
  {
    GST_FIXME ("video format %s not supported yet for blending",
        gst_video_format_to_string (dinfo->unpack_format));
    return FALSE;
  }
}
