/* GStreamer
 * Copyright (C) 2010 David Schleef <ds@schleef.org>
 * Copyright (C) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#include "videoconvert.h"

#include <glib.h>
#include <string.h>
#include <math.h>

#include "gstvideoconvertorc.h"


static void videoconvert_convert_generic (VideoConvert * convert,
    GstVideoFrame * dest, const GstVideoFrame * src);
static void videoconvert_convert_matrix8 (VideoConvert * convert,
    gpointer pixels);
static void videoconvert_convert_matrix16 (VideoConvert * convert,
    gpointer pixels);
static gboolean videoconvert_convert_lookup_fastpath (VideoConvert * convert);
static gboolean videoconvert_convert_compute_matrix (VideoConvert * convert);
static gboolean videoconvert_convert_compute_resample (VideoConvert * convert);
static void videoconvert_dither_verterr (VideoConvert * convert,
    guint16 * pixels, int j);
static void videoconvert_dither_halftone (VideoConvert * convert,
    guint16 * pixels, int j);


VideoConvert *
videoconvert_convert_new (GstVideoInfo * in_info, GstVideoInfo * out_info)
{
  VideoConvert *convert;
  gint width;

  convert = g_malloc0 (sizeof (VideoConvert));

  convert->in_info = *in_info;
  convert->out_info = *out_info;
  convert->dither16 = NULL;

  convert->width = GST_VIDEO_INFO_WIDTH (in_info);
  convert->height = GST_VIDEO_INFO_HEIGHT (in_info);

  if (!videoconvert_convert_lookup_fastpath (convert)) {
    convert->convert = videoconvert_convert_generic;
    if (!videoconvert_convert_compute_matrix (convert))
      goto no_convert;

    if (!videoconvert_convert_compute_resample (convert))
      goto no_convert;
  }

  width = convert->width;

  convert->lines = out_info->finfo->pack_lines;
  convert->errline = g_malloc0 (sizeof (guint16) * width * 4);

  return convert;

  /* ERRORS */
no_convert:
  {
    videoconvert_convert_free (convert);
    return NULL;
  }
}

void
videoconvert_convert_free (VideoConvert * convert)
{
  gint i;

  if (convert->upsample)
    gst_video_chroma_resample_free (convert->upsample);
  if (convert->downsample)
    gst_video_chroma_resample_free (convert->downsample);

  for (i = 0; i < convert->n_tmplines; i++)
    g_free (convert->tmplines[i]);
  g_free (convert->tmplines);
  g_free (convert->errline);

  g_free (convert);
}

void
videoconvert_convert_set_dither (VideoConvert * convert, int type)
{
  switch (type) {
    case 0:
    default:
      convert->dither16 = NULL;
      break;
    case 1:
      convert->dither16 = videoconvert_dither_verterr;
      break;
    case 2:
      convert->dither16 = videoconvert_dither_halftone;
      break;
  }
}

void
videoconvert_convert_convert (VideoConvert * convert,
    GstVideoFrame * dest, const GstVideoFrame * src)
{
  convert->convert (convert, dest, src);
}

#define SCALE    (8)
#define SCALE_F  ((float) (1 << SCALE))

static void
videoconvert_convert_matrix8 (VideoConvert * convert, gpointer pixels)
{
  int i;
  int r, g, b;
  int y, u, v;
  guint8 *p = pixels;

  for (i = 0; i < convert->width; i++) {
    r = p[i * 4 + 1];
    g = p[i * 4 + 2];
    b = p[i * 4 + 3];

    y = (convert->cmatrix[0][0] * r + convert->cmatrix[0][1] * g +
        convert->cmatrix[0][2] * b + convert->cmatrix[0][3]) >> SCALE;
    u = (convert->cmatrix[1][0] * r + convert->cmatrix[1][1] * g +
        convert->cmatrix[1][2] * b + convert->cmatrix[1][3]) >> SCALE;
    v = (convert->cmatrix[2][0] * r + convert->cmatrix[2][1] * g +
        convert->cmatrix[2][2] * b + convert->cmatrix[2][3]) >> SCALE;

    p[i * 4 + 1] = CLAMP (y, 0, 255);
    p[i * 4 + 2] = CLAMP (u, 0, 255);
    p[i * 4 + 3] = CLAMP (v, 0, 255);
  }
}

static void
videoconvert_convert_matrix16 (VideoConvert * convert, gpointer pixels)
{
  int i;
  int r, g, b;
  int y, u, v;
  guint16 *p = pixels;

  for (i = 0; i < convert->width; i++) {
    r = p[i * 4 + 1];
    g = p[i * 4 + 2];
    b = p[i * 4 + 3];

    y = (convert->cmatrix[0][0] * r + convert->cmatrix[0][1] * g +
        convert->cmatrix[0][2] * b + convert->cmatrix[0][3]) >> SCALE;
    u = (convert->cmatrix[1][0] * r + convert->cmatrix[1][1] * g +
        convert->cmatrix[1][2] * b + convert->cmatrix[1][3]) >> SCALE;
    v = (convert->cmatrix[2][0] * r + convert->cmatrix[2][1] * g +
        convert->cmatrix[2][2] * b + convert->cmatrix[2][3]) >> SCALE;

    p[i * 4 + 1] = CLAMP (y, 0, 65535);
    p[i * 4 + 2] = CLAMP (u, 0, 65535);
    p[i * 4 + 3] = CLAMP (v, 0, 65535);
  }
}

static gboolean
get_Kr_Kb (GstVideoColorMatrix matrix, gdouble * Kr, gdouble * Kb)
{
  gboolean res = TRUE;

  switch (matrix) {
      /* RGB */
    default:
    case GST_VIDEO_COLOR_MATRIX_RGB:
      res = FALSE;
      break;
      /* YUV */
    case GST_VIDEO_COLOR_MATRIX_FCC:
      *Kr = 0.30;
      *Kb = 0.11;
      break;
    case GST_VIDEO_COLOR_MATRIX_BT709:
      *Kr = 0.2126;
      *Kb = 0.0722;
      break;
    case GST_VIDEO_COLOR_MATRIX_BT601:
      *Kr = 0.2990;
      *Kb = 0.1140;
      break;
    case GST_VIDEO_COLOR_MATRIX_SMPTE240M:
      *Kr = 0.212;
      *Kb = 0.087;
      break;
  }
  GST_DEBUG ("matrix: %d, Kr %f, Kb %f", matrix, *Kr, *Kb);
  return res;
}

static gboolean
videoconvert_convert_compute_matrix (VideoConvert * convert)
{
  GstVideoInfo *in_info, *out_info;
  ColorMatrix dst;
  gint i, j;
  const GstVideoFormatInfo *sfinfo, *dfinfo;
  const GstVideoFormatInfo *suinfo, *duinfo;
  gint offset[4], scale[4];
  gdouble Kr = 0, Kb = 0;

  in_info = &convert->in_info;
  out_info = &convert->out_info;

  sfinfo = in_info->finfo;
  dfinfo = out_info->finfo;

  if (sfinfo->unpack_func == NULL)
    goto no_unpack_func;

  if (dfinfo->pack_func == NULL)
    goto no_pack_func;

  suinfo = gst_video_format_get_info (sfinfo->unpack_format);
  duinfo = gst_video_format_get_info (dfinfo->unpack_format);

  convert->in_bits = GST_VIDEO_FORMAT_INFO_DEPTH (suinfo, 0);
  convert->out_bits = GST_VIDEO_FORMAT_INFO_DEPTH (duinfo, 0);

  GST_DEBUG ("in bits %d, out bits %d", convert->in_bits, convert->out_bits);

  if (in_info->colorimetry.range == out_info->colorimetry.range &&
      in_info->colorimetry.matrix == out_info->colorimetry.matrix) {
    GST_DEBUG ("using identity color transform");
    convert->matrix = NULL;
    return TRUE;
  }

  /* calculate intermediate format for the matrix. When unpacking, we expand
   * input to 16 when one of the inputs is 16 bits */
  if (convert->in_bits == 16 || convert->out_bits == 16) {
    convert->matrix = videoconvert_convert_matrix16;

    if (GST_VIDEO_FORMAT_INFO_IS_RGB (suinfo))
      suinfo = gst_video_format_get_info (GST_VIDEO_FORMAT_ARGB64);
    else
      suinfo = gst_video_format_get_info (GST_VIDEO_FORMAT_AYUV64);

    if (GST_VIDEO_FORMAT_INFO_IS_RGB (duinfo))
      duinfo = gst_video_format_get_info (GST_VIDEO_FORMAT_ARGB64);
    else
      duinfo = gst_video_format_get_info (GST_VIDEO_FORMAT_AYUV64);
  } else {
    convert->matrix = videoconvert_convert_matrix8;
  }

  color_matrix_set_identity (&dst);

  /* 1, bring color components to [0..1.0] range */
  gst_video_color_range_offsets (in_info->colorimetry.range, suinfo, offset,
      scale);

  color_matrix_offset_components (&dst, -offset[0], -offset[1], -offset[2]);

  color_matrix_scale_components (&dst, 1 / ((float) scale[0]),
      1 / ((float) scale[1]), 1 / ((float) scale[2]));

  /* 2. bring components to R'G'B' space */
  if (get_Kr_Kb (in_info->colorimetry.matrix, &Kr, &Kb))
    color_matrix_YCbCr_to_RGB (&dst, Kr, Kb);

  /* 3. inverse transfer function. R'G'B' to linear RGB */

  /* 4. from RGB to XYZ using the primaries */

  /* 5. from XYZ to RGB using the primaries */

  /* 6. transfer function. linear RGB to R'G'B' */

  /* 7. bring components to YCbCr space */
  if (get_Kr_Kb (out_info->colorimetry.matrix, &Kr, &Kb))
    color_matrix_RGB_to_YCbCr (&dst, Kr, Kb);

  /* 8, bring color components to nominal range */
  gst_video_color_range_offsets (out_info->colorimetry.range, duinfo, offset,
      scale);

  color_matrix_scale_components (&dst, (float) scale[0], (float) scale[1],
      (float) scale[2]);

  color_matrix_offset_components (&dst, offset[0], offset[1], offset[2]);

  /* because we're doing fixed point matrix coefficients */
  color_matrix_scale_components (&dst, SCALE_F, SCALE_F, SCALE_F);

  for (i = 0; i < 4; i++)
    for (j = 0; j < 4; j++)
      convert->cmatrix[i][j] = rint (dst.m[i][j]);

  GST_DEBUG ("[%6d %6d %6d %6d]", convert->cmatrix[0][0],
      convert->cmatrix[0][1], convert->cmatrix[0][2], convert->cmatrix[0][3]);
  GST_DEBUG ("[%6d %6d %6d %6d]", convert->cmatrix[1][0],
      convert->cmatrix[1][1], convert->cmatrix[1][2], convert->cmatrix[1][3]);
  GST_DEBUG ("[%6d %6d %6d %6d]", convert->cmatrix[2][0],
      convert->cmatrix[2][1], convert->cmatrix[2][2], convert->cmatrix[2][3]);
  GST_DEBUG ("[%6d %6d %6d %6d]", convert->cmatrix[3][0],
      convert->cmatrix[3][1], convert->cmatrix[3][2], convert->cmatrix[3][3]);

  return TRUE;

  /* ERRORS */
no_unpack_func:
  {
    GST_ERROR ("no unpack_func for format %s",
        gst_video_format_to_string (GST_VIDEO_INFO_FORMAT (in_info)));
    return FALSE;
  }
no_pack_func:
  {
    GST_ERROR ("no pack_func for format %s",
        gst_video_format_to_string (GST_VIDEO_INFO_FORMAT (out_info)));
    return FALSE;
  }
}

static void
videoconvert_dither_verterr (VideoConvert * convert, guint16 * pixels, int j)
{
  int i;
  guint16 *errline = convert->errline;
  unsigned int mask = 0xff;

  for (i = 0; i < 4 * convert->width; i++) {
    int x = pixels[i] + errline[i];
    if (x > 65535)
      x = 65535;
    pixels[i] = x;
    errline[i] = x & mask;
  }
}

static void
videoconvert_dither_halftone (VideoConvert * convert, guint16 * pixels, int j)
{
  int i;
  static guint16 halftone[8][8] = {
    {0, 128, 32, 160, 8, 136, 40, 168},
    {192, 64, 224, 96, 200, 72, 232, 104},
    {48, 176, 16, 144, 56, 184, 24, 152},
    {240, 112, 208, 80, 248, 120, 216, 88},
    {12, 240, 44, 172, 4, 132, 36, 164},
    {204, 76, 236, 108, 196, 68, 228, 100},
    {60, 188, 28, 156, 52, 180, 20, 148},
    {252, 142, 220, 92, 244, 116, 212, 84}
  };

  for (i = 0; i < convert->width * 4; i++) {
    int x;
    x = pixels[i] + halftone[(i >> 2) & 7][j & 7];
    if (x > 65535)
      x = 65535;
    pixels[i] = x;
  }
}

static void
alloc_tmplines (VideoConvert * convert, guint lines, gint width)
{
  gint i;

  convert->n_tmplines = lines;
  convert->tmplines = g_malloc (lines * sizeof (gpointer));
  for (i = 0; i < lines; i++)
    convert->tmplines[i] = g_malloc (sizeof (guint16) * (width + 8) * 4);
}

static gboolean
videoconvert_convert_compute_resample (VideoConvert * convert)
{
  GstVideoInfo *in_info, *out_info;
  const GstVideoFormatInfo *sfinfo, *dfinfo;
  gint width;

  in_info = &convert->in_info;
  out_info = &convert->out_info;

  sfinfo = in_info->finfo;
  dfinfo = out_info->finfo;

  width = convert->width;

  if (sfinfo->w_sub[2] != dfinfo->w_sub[2] ||
      sfinfo->h_sub[2] != dfinfo->h_sub[2] ||
      in_info->chroma_site != out_info->chroma_site) {
    convert->upsample = gst_video_chroma_resample_new (0,
        in_info->chroma_site, 0, sfinfo->unpack_format, sfinfo->w_sub[2],
        sfinfo->h_sub[2]);


    convert->downsample = gst_video_chroma_resample_new (0,
        out_info->chroma_site, 0, dfinfo->unpack_format, -dfinfo->w_sub[2],
        -dfinfo->h_sub[2]);

  } else {
    convert->upsample = NULL;
    convert->downsample = NULL;
  }

  if (convert->upsample) {
    gst_video_chroma_resample_get_info (convert->upsample,
        &convert->up_n_lines, &convert->up_offset);
  } else {
    convert->up_n_lines = 1;
    convert->up_offset = 0;
  }
  if (convert->downsample) {
    gst_video_chroma_resample_get_info (convert->downsample,
        &convert->down_n_lines, &convert->down_offset);
  } else {
    convert->down_n_lines = 1;
    convert->down_offset = 0;
  }
  GST_DEBUG ("upsample: %p, site: %d, offset %d, n_lines %d", convert->upsample,
      in_info->chroma_site, convert->up_offset, convert->up_n_lines);
  GST_DEBUG ("downsample: %p, site: %d, offset %d, n_lines %d",
      convert->downsample, out_info->chroma_site, convert->down_offset,
      convert->down_n_lines);

  alloc_tmplines (convert, convert->down_n_lines + convert->up_n_lines, width);

  return TRUE;
}

#define TO_16(x) (((x)<<8) | (x))

static void
convert_to16 (gpointer line, gint width)
{
  guint8 *line8 = line;
  guint16 *line16 = line;
  gint i;

  for (i = (width - 1) * 4; i >= 0; i--)
    line16[i] = TO_16 (line8[i]);
}

static void
convert_to8 (gpointer line, gint width)
{
  guint8 *line8 = line;
  guint16 *line16 = line;
  gint i;

  for (i = 0; i < width * 4; i++)
    line8[i] = line16[i] >> 8;
}

#define UNPACK_FRAME(frame,dest,line,width)          \
  frame->info.finfo->unpack_func (frame->info.finfo, \
      (GST_VIDEO_FRAME_IS_INTERLACED (frame) ?       \
        GST_VIDEO_PACK_FLAG_INTERLACED :             \
        GST_VIDEO_PACK_FLAG_NONE),                   \
      dest, frame->data, frame->info.stride, 0,      \
      line, width)
#define PACK_FRAME(frame,dest,line,width)            \
  frame->info.finfo->pack_func (frame->info.finfo,   \
      (GST_VIDEO_FRAME_IS_INTERLACED (frame) ?       \
        GST_VIDEO_PACK_FLAG_INTERLACED :             \
        GST_VIDEO_PACK_FLAG_NONE),                   \
      dest, 0, frame->data, frame->info.stride,      \
      frame->info.chroma_site, line, width);

static void
videoconvert_convert_generic (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int j, k;
  gint width, height, lines, max_lines;
  guint in_bits, out_bits;
  gconstpointer pal;
  gsize palsize;
  guint up_n_lines, down_n_lines;
  gint up_offset, down_offset;
  gint in_lines, out_lines;
  gint up_line, down_line;
  gint start_offset, stop_offset;
  gpointer in_tmplines[8];
  gpointer out_tmplines[8];

  height = convert->height;
  width = convert->width;

  in_bits = convert->in_bits;
  out_bits = convert->out_bits;

  lines = convert->lines;
  up_n_lines = convert->up_n_lines;
  up_offset = convert->up_offset;
  down_n_lines = convert->down_n_lines;
  down_offset = convert->down_offset;
  max_lines = convert->n_tmplines;

  in_lines = 0;
  out_lines = 0;

  GST_DEBUG ("up_offset %d, up_n_lines %u", up_offset, up_n_lines);

  start_offset = MIN (up_offset, down_offset);
  stop_offset = height + start_offset + MAX (up_n_lines, down_n_lines);

  for (; start_offset < stop_offset; start_offset++) {
    guint idx, start;

    idx = CLAMP (start_offset, 0, height);
    in_tmplines[in_lines] = convert->tmplines[idx % max_lines];
    out_tmplines[out_lines] = in_tmplines[in_lines];
    GST_DEBUG ("start_offset %d/%d, %d, idx %u, in %d, out %d", start_offset,
        stop_offset, up_offset, idx, in_lines, out_lines);

    up_line = up_offset + in_lines;

    /* extract the next line */
    if (up_line >= 0 && up_line < height) {
      GST_DEBUG ("unpack line %d into %d", up_line, in_lines);
      UNPACK_FRAME (src, in_tmplines[in_lines], up_line, width);
    }

    if (start_offset >= up_offset)
      in_lines++;

    if (start_offset >= down_offset)
      out_lines++;

    if (in_lines < up_n_lines)
      continue;

    in_lines = 0;

    /* we have enough lines to upsample */
    if (convert->upsample) {
      GST_DEBUG ("doing upsample");
      gst_video_chroma_resample (convert->upsample, in_tmplines, width);
    }

    /* convert upsampled lines */
    for (k = 0; k < up_n_lines; k++) {
      down_line = up_offset + k;

      /* only takes lines with valid output */
      if (down_line < 0 || down_line >= height)
        continue;

      GST_DEBUG ("handle line %d, %d/%d, down_line %d", k, out_lines,
          down_n_lines, down_line);

      if (out_bits == 16 || in_bits == 16) {
        /* FIXME, we can scale in the conversion matrix */
        if (in_bits == 8)
          convert_to16 (in_tmplines[k], width);

        if (convert->matrix)
          convert->matrix (convert, in_tmplines[k]);
        if (convert->dither16)
          convert->dither16 (convert, in_tmplines[k], down_line);

        if (out_bits == 8)
          convert_to8 (in_tmplines[k], width);
      } else {
        if (convert->matrix)
          convert->matrix (convert, in_tmplines[k]);
      }
    }

    start = 0;
    while (out_lines >= down_n_lines) {
      if (convert->downsample) {
        GST_DEBUG ("doing downsample %u", start);
        gst_video_chroma_resample (convert->downsample,
            &out_tmplines[start], width);
      }

      for (j = 0; j < down_n_lines; j += lines) {
        idx = down_offset + j;

        if (idx < height) {
          GST_DEBUG ("packing line %d %d %d", j + start, down_offset, idx);
          /* FIXME, not correct if lines > 1 */
          PACK_FRAME (dest, out_tmplines[j + start], idx, width);
        }
      }
      down_offset += down_n_lines;
      start += down_n_lines;
      out_lines -= down_n_lines;
    }
    /* we didn't process these lines, move them up for the next round */
    for (j = 0; j < out_lines; j++) {
      GST_DEBUG ("move line %d->%d", j + start, j);
      out_tmplines[j] = out_tmplines[j + start];
    }

    up_offset += up_n_lines;
  }
  if ((pal =
          gst_video_format_get_palette (GST_VIDEO_FRAME_FORMAT (dest),
              &palsize))) {
    memcpy (GST_VIDEO_FRAME_PLANE_DATA (dest, 1), pal, palsize);
  }
}

#define FRAME_GET_PLANE_STRIDE(frame, plane) \
  GST_VIDEO_FRAME_PLANE_STRIDE (frame, plane)
#define FRAME_GET_PLANE_LINE(frame, plane, line) \
  (gpointer)(((guint8*)(GST_VIDEO_FRAME_PLANE_DATA (frame, plane))) + \
      FRAME_GET_PLANE_STRIDE (frame, plane) * (line))

#define FRAME_GET_COMP_STRIDE(frame, comp) \
  GST_VIDEO_FRAME_COMP_STRIDE (frame, comp)
#define FRAME_GET_COMP_LINE(frame, comp, line) \
  (gpointer)(((guint8*)(GST_VIDEO_FRAME_COMP_DATA (frame, comp))) + \
      FRAME_GET_COMP_STRIDE (frame, comp) * (line))

#define FRAME_GET_STRIDE(frame)      FRAME_GET_PLANE_STRIDE (frame, 0)
#define FRAME_GET_LINE(frame,line)   FRAME_GET_PLANE_LINE (frame, 0, line)

#define FRAME_GET_Y_LINE(frame,line) FRAME_GET_COMP_LINE(frame, GST_VIDEO_COMP_Y, line)
#define FRAME_GET_U_LINE(frame,line) FRAME_GET_COMP_LINE(frame, GST_VIDEO_COMP_U, line)
#define FRAME_GET_V_LINE(frame,line) FRAME_GET_COMP_LINE(frame, GST_VIDEO_COMP_V, line)
#define FRAME_GET_A_LINE(frame,line) FRAME_GET_COMP_LINE(frame, GST_VIDEO_COMP_A, line)

#define FRAME_GET_Y_STRIDE(frame)    FRAME_GET_COMP_STRIDE(frame, GST_VIDEO_COMP_Y)
#define FRAME_GET_U_STRIDE(frame)    FRAME_GET_COMP_STRIDE(frame, GST_VIDEO_COMP_U)
#define FRAME_GET_V_STRIDE(frame)    FRAME_GET_COMP_STRIDE(frame, GST_VIDEO_COMP_V)
#define FRAME_GET_A_STRIDE(frame)    FRAME_GET_COMP_STRIDE(frame, GST_VIDEO_COMP_A)

/* Fast paths */

#define GET_LINE_OFFSETS(interlaced,line,l1,l2) \
    if (interlaced) {                           \
      l1 = (line & 2 ? line - 1 : line);        \
      l2 = l1 + 2;                              \
    } else {                                    \
      l1 = line;                                \
      l2 = l1 + 1;                              \
    }


static void
convert_I420_YUY2 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;
  gboolean interlaced = GST_VIDEO_FRAME_IS_INTERLACED (src);
  gint l1, l2;

  for (i = 0; i < GST_ROUND_DOWN_2 (height); i += 2) {
    GET_LINE_OFFSETS (interlaced, i, l1, l2);

    video_convert_orc_convert_I420_YUY2 (FRAME_GET_LINE (dest, l1),
        FRAME_GET_LINE (dest, l2),
        FRAME_GET_Y_LINE (src, l1),
        FRAME_GET_Y_LINE (src, l2),
        FRAME_GET_U_LINE (src, i >> 1),
        FRAME_GET_V_LINE (src, i >> 1), (width + 1) / 2);
  }

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_I420_UYVY (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;
  gboolean interlaced = GST_VIDEO_FRAME_IS_INTERLACED (src);
  gint l1, l2;

  for (i = 0; i < GST_ROUND_DOWN_2 (height); i += 2) {
    GET_LINE_OFFSETS (interlaced, i, l1, l2);

    video_convert_orc_convert_I420_UYVY (FRAME_GET_LINE (dest, l1),
        FRAME_GET_LINE (dest, l2),
        FRAME_GET_Y_LINE (src, l1),
        FRAME_GET_Y_LINE (src, l2),
        FRAME_GET_U_LINE (src, i >> 1),
        FRAME_GET_V_LINE (src, i >> 1), (width + 1) / 2);
  }

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_I420_AYUV (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;
  gboolean interlaced = GST_VIDEO_FRAME_IS_INTERLACED (src);
  gint l1, l2;

  for (i = 0; i < GST_ROUND_DOWN_2 (height); i += 2) {
    GET_LINE_OFFSETS (interlaced, i, l1, l2);

    video_convert_orc_convert_I420_AYUV (FRAME_GET_LINE (dest, l1),
        FRAME_GET_LINE (dest, l2),
        FRAME_GET_Y_LINE (src, l1),
        FRAME_GET_Y_LINE (src, l2),
        FRAME_GET_U_LINE (src, i >> 1), FRAME_GET_V_LINE (src, i >> 1), width);
  }

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_I420_Y42B (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_420_422 (FRAME_GET_U_LINE (dest, 0),
      2 * FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (dest, 1),
      2 * FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), (width + 1) / 2, height / 2);

  video_convert_orc_planar_chroma_420_422 (FRAME_GET_V_LINE (dest, 0),
      2 * FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (dest, 1),
      2 * FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), (width + 1) / 2, height / 2);
}

static void
convert_I420_Y444 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_420_444 (FRAME_GET_U_LINE (dest, 0),
      2 * FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (dest, 1),
      2 * FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), (width + 1) / 2, height / 2);

  video_convert_orc_planar_chroma_420_444 (FRAME_GET_V_LINE (dest, 0),
      2 * FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (dest, 1),
      2 * FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), (width + 1) / 2, height / 2);

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_YUY2_I420 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;
  gboolean interlaced = GST_VIDEO_FRAME_IS_INTERLACED (src);
  gint l1, l2;

  for (i = 0; i < GST_ROUND_DOWN_2 (height); i += 2) {
    GET_LINE_OFFSETS (interlaced, i, l1, l2);

    video_convert_orc_convert_YUY2_I420 (FRAME_GET_Y_LINE (dest, l1),
        FRAME_GET_Y_LINE (dest, l2),
        FRAME_GET_U_LINE (dest, i >> 1),
        FRAME_GET_V_LINE (dest, i >> 1),
        FRAME_GET_LINE (src, l1), FRAME_GET_LINE (src, l2), (width + 1) / 2);
  }

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_YUY2_AYUV (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_YUY2_AYUV (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_YUY2_Y42B (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_YUY2_Y42B (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_YUY2_Y444 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_YUY2_Y444 (FRAME_GET_COMP_LINE (dest, 0, 0),
      FRAME_GET_COMP_STRIDE (dest, 0), FRAME_GET_COMP_LINE (dest, 1, 0),
      FRAME_GET_COMP_STRIDE (dest, 1), FRAME_GET_COMP_LINE (dest, 2, 0),
      FRAME_GET_COMP_STRIDE (dest, 2), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}


static void
convert_UYVY_I420 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;
  gboolean interlaced = GST_VIDEO_FRAME_IS_INTERLACED (src);
  gint l1, l2;

  for (i = 0; i < GST_ROUND_DOWN_2 (height); i += 2) {
    GET_LINE_OFFSETS (interlaced, i, l1, l2);

    video_convert_orc_convert_UYVY_I420 (FRAME_GET_COMP_LINE (dest, 0, l1),
        FRAME_GET_COMP_LINE (dest, 0, l2),
        FRAME_GET_COMP_LINE (dest, 1, i >> 1),
        FRAME_GET_COMP_LINE (dest, 2, i >> 1),
        FRAME_GET_LINE (src, l1), FRAME_GET_LINE (src, l2), (width + 1) / 2);
  }

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_UYVY_AYUV (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_UYVY_AYUV (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_UYVY_YUY2 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_UYVY_YUY2 (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_UYVY_Y42B (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_UYVY_Y42B (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_UYVY_Y444 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_UYVY_Y444 (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_AYUV_I420 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  /* only for even width/height */
  video_convert_orc_convert_AYUV_I420 (FRAME_GET_Y_LINE (dest, 0),
      2 * FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (dest, 1),
      2 * FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      2 * FRAME_GET_STRIDE (src), FRAME_GET_LINE (src, 1),
      2 * FRAME_GET_STRIDE (src), width / 2, height / 2);
}

static void
convert_AYUV_YUY2 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  /* only for even width */
  video_convert_orc_convert_AYUV_YUY2 (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), width / 2, height);
}

static void
convert_AYUV_UYVY (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  /* only for even width */
  video_convert_orc_convert_AYUV_UYVY (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), width / 2, height);
}

static void
convert_AYUV_Y42B (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  /* only works for even width */
  video_convert_orc_convert_AYUV_Y42B (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), width / 2, height);
}

static void
convert_AYUV_Y444 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_AYUV_Y444 (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), width, height);
}

static void
convert_Y42B_I420 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_422_420 (FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      2 * FRAME_GET_U_STRIDE (src), FRAME_GET_U_LINE (src, 1),
      2 * FRAME_GET_U_STRIDE (src), (width + 1) / 2, height / 2);

  video_convert_orc_planar_chroma_422_420 (FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      2 * FRAME_GET_V_STRIDE (src), FRAME_GET_V_LINE (src, 1),
      2 * FRAME_GET_V_STRIDE (src), (width + 1) / 2, height / 2);

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_Y42B_Y444 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_422_444 (FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), (width + 1) / 2, height);

  video_convert_orc_planar_chroma_422_444 (FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_Y42B_YUY2 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_Y42B_YUY2 (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_Y42B_UYVY (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_Y42B_UYVY (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), (width + 1) / 2, height);
}

static void
convert_Y42B_AYUV (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  /* only for even width */
  video_convert_orc_convert_Y42B_AYUV (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), width / 2, height);
}

static void
convert_Y444_I420 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_444_420 (FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      2 * FRAME_GET_U_STRIDE (src), FRAME_GET_U_LINE (src, 1),
      2 * FRAME_GET_U_STRIDE (src), width / 2, height / 2);

  video_convert_orc_planar_chroma_444_420 (FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      2 * FRAME_GET_V_STRIDE (src), FRAME_GET_V_LINE (src, 1),
      2 * FRAME_GET_V_STRIDE (src), width / 2, height / 2);

  /* now handle last line */
  if (height & 1) {
    UNPACK_FRAME (src, convert->tmplines[0], height - 1, width);
    PACK_FRAME (dest, convert->tmplines[0], height - 1, width);
  }
}

static void
convert_Y444_Y42B (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_memcpy_2d (FRAME_GET_Y_LINE (dest, 0),
      FRAME_GET_Y_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), width, height);

  video_convert_orc_planar_chroma_444_422 (FRAME_GET_U_LINE (dest, 0),
      FRAME_GET_U_STRIDE (dest), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), width / 2, height);

  video_convert_orc_planar_chroma_444_422 (FRAME_GET_V_LINE (dest, 0),
      FRAME_GET_V_STRIDE (dest), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), width / 2, height);
}

static void
convert_Y444_YUY2 (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_Y444_YUY2 (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), width / 2, height);
}

static void
convert_Y444_UYVY (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_Y444_UYVY (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), width / 2, height);
}

static void
convert_Y444_AYUV (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_Y444_AYUV (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_Y_LINE (src, 0),
      FRAME_GET_Y_STRIDE (src), FRAME_GET_U_LINE (src, 0),
      FRAME_GET_U_STRIDE (src), FRAME_GET_V_LINE (src, 0),
      FRAME_GET_V_STRIDE (src), width, height);
}

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
static void
convert_AYUV_ARGB (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_AYUV_ARGB (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), convert->cmatrix[0][0], convert->cmatrix[0][2],
      convert->cmatrix[2][1], convert->cmatrix[1][1], convert->cmatrix[1][2],
      width, height);
}

static void
convert_AYUV_BGRA (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_AYUV_BGRA (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), convert->cmatrix[0][0], convert->cmatrix[0][2],
      convert->cmatrix[2][1], convert->cmatrix[1][1], convert->cmatrix[1][2],
      width, height);
}

static void
convert_AYUV_ABGR (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_AYUV_ABGR (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), convert->cmatrix[0][0], convert->cmatrix[0][2],
      convert->cmatrix[2][1], convert->cmatrix[1][1], convert->cmatrix[1][2],
      width, height);
}

static void
convert_AYUV_RGBA (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  gint width = convert->width;
  gint height = convert->height;

  video_convert_orc_convert_AYUV_RGBA (FRAME_GET_LINE (dest, 0),
      FRAME_GET_STRIDE (dest), FRAME_GET_LINE (src, 0),
      FRAME_GET_STRIDE (src), convert->cmatrix[0][0], convert->cmatrix[0][2],
      convert->cmatrix[2][1], convert->cmatrix[1][1], convert->cmatrix[1][2],
      width, height);
}

static void
convert_I420_BGRA (VideoConvert * convert, GstVideoFrame * dest,
    const GstVideoFrame * src)
{
  int i;
  gint width = convert->width;
  gint height = convert->height;

  for (i = 0; i < height; i++) {
    video_convert_orc_convert_I420_BGRA (FRAME_GET_LINE (dest, i),
        FRAME_GET_Y_LINE (src, i),
        FRAME_GET_U_LINE (src, i >> 1), FRAME_GET_V_LINE (src, i >> 1),
        convert->cmatrix[0][0], convert->cmatrix[0][2],
        convert->cmatrix[2][1], convert->cmatrix[1][1], convert->cmatrix[1][2],
        width);
  }
}
#endif



/* Fast paths */

typedef struct
{
  GstVideoFormat in_format;
  GstVideoColorMatrix in_matrix;
  GstVideoFormat out_format;
  GstVideoColorMatrix out_matrix;
  gboolean keeps_color_matrix;
  gboolean keeps_interlaced;
  gboolean needs_color_matrix;
  gint width_align, height_align;
  void (*convert) (VideoConvert * convert, GstVideoFrame * dest,
      const GstVideoFrame * src);
} VideoTransform;

static const VideoTransform transforms[] = {
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_YUY2},
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_UYVY},
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_AYUV},
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_I420_Y42B},
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_I420_Y444},

  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_YUY2},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_UYVY},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_I420_AYUV},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_I420_Y42B},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_I420_Y444},

  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_I420,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_YUY2_I420},
  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YV12,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_YUY2_I420},
  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
      GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0, convert_UYVY_YUY2},      /* alias */
  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_YUY2_AYUV},
  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_YUY2_Y42B},
  {GST_VIDEO_FORMAT_YUY2, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_YUY2_Y444},

  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_I420,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_I420},
  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YV12,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_I420},
  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_YUY2},
  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_AYUV},
  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_Y42B},
  {GST_VIDEO_FORMAT_UYVY, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_UYVY_Y444},

  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_I420,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 1, 1,
      convert_AYUV_I420},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YV12,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 1, 1,
      convert_AYUV_I420},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_AYUV_YUY2},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_AYUV_UYVY},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_AYUV_Y42B},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_AYUV_Y444},

  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_I420,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_Y42B_I420},
  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YV12,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 0, 0,
      convert_Y42B_I420},
  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_Y42B_YUY2},
  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_Y42B_UYVY},
  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_Y42B_AYUV},
  {GST_VIDEO_FORMAT_Y42B, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y444,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_Y42B_Y444},

  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_I420,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 1, 0,
      convert_Y444_I420},
  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YV12,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, FALSE, 1, 0,
      convert_Y444_I420},
  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_YUY2,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_Y444_YUY2},
  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_UYVY,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_Y444_UYVY},
  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_AYUV,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 0, 0,
      convert_Y444_AYUV},
  {GST_VIDEO_FORMAT_Y444, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_Y42B,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, FALSE, 1, 0,
      convert_Y444_Y42B},

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_ARGB,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0,
      convert_AYUV_ARGB},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRA,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0,
      convert_AYUV_BGRA},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_xRGB,
      GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0, convert_AYUV_ARGB},       /* alias */
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRx,
      GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0, convert_AYUV_BGRA},       /* alias */
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_ABGR,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0,
      convert_AYUV_ABGR},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_RGBA,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0,
      convert_AYUV_RGBA},
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_xBGR,
      GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0, convert_AYUV_ABGR},       /* alias */
  {GST_VIDEO_FORMAT_AYUV, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_RGBx,
      GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, TRUE, TRUE, 0, 0, convert_AYUV_RGBA},       /* alias */

  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRA,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, TRUE, 0, 0,
      convert_I420_BGRA},
  {GST_VIDEO_FORMAT_I420, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRx,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, TRUE, 0, 0,
      convert_I420_BGRA},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRA,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, TRUE, 0, 0,
      convert_I420_BGRA},
  {GST_VIDEO_FORMAT_YV12, GST_VIDEO_COLOR_MATRIX_UNKNOWN, GST_VIDEO_FORMAT_BGRx,
        GST_VIDEO_COLOR_MATRIX_UNKNOWN, TRUE, FALSE, TRUE, 0, 0,
      convert_I420_BGRA},
#endif
};

static gboolean
videoconvert_convert_lookup_fastpath (VideoConvert * convert)
{
  int i;
  GstVideoFormat in_format, out_format;
  GstVideoColorMatrix in_matrix, out_matrix;
  gboolean interlaced;
  gint width, height;

  in_format = GST_VIDEO_INFO_FORMAT (&convert->in_info);
  out_format = GST_VIDEO_INFO_FORMAT (&convert->out_info);

  width = GST_VIDEO_INFO_WIDTH (&convert->in_info);
  height = GST_VIDEO_INFO_HEIGHT (&convert->in_info);

  in_matrix = convert->in_info.colorimetry.matrix;
  out_matrix = convert->out_info.colorimetry.matrix;

  interlaced = GST_VIDEO_INFO_IS_INTERLACED (&convert->in_info);
  interlaced |= GST_VIDEO_INFO_IS_INTERLACED (&convert->out_info);

  for (i = 0; i < sizeof (transforms) / sizeof (transforms[0]); i++) {
    if (transforms[i].in_format == in_format &&
        transforms[i].out_format == out_format &&
        (transforms[i].keeps_color_matrix ||
            (transforms[i].in_matrix == in_matrix &&
                transforms[i].out_matrix == out_matrix)) &&
        (transforms[i].keeps_interlaced || !interlaced) &&
        (transforms[i].width_align & width) == 0 &&
        (transforms[i].height_align & height) == 0) {
      GST_DEBUG ("using fastpath");
      if (transforms[i].needs_color_matrix)
        if (!videoconvert_convert_compute_matrix (convert))
          goto no_convert;
      convert->convert = transforms[i].convert;
      alloc_tmplines (convert, 1, GST_VIDEO_INFO_WIDTH (&convert->in_info));
      return TRUE;
    }
  }
  GST_DEBUG ("no fastpath found");
  return FALSE;

no_convert:
  {
    GST_DEBUG ("can't create matrix");
    return FALSE;
  }
}
