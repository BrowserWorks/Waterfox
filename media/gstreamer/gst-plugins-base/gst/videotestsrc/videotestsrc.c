/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

/* non-GST-specific stuff */

#include "gstvideotestsrc.h"
#include "videotestsrc.h"
#include "gstvideotestsrcorc.h"

#include <gst/math-compat.h>

#include <string.h>
#include <stdlib.h>

#define TO_16(x) (((x)<<8) | (x))

static unsigned char
random_char (void)
{
  static unsigned int state;

  state *= 1103515245;
  state += 12345;
  return (state >> 16) & 0xff;
}

enum
{
  COLOR_WHITE = 0,
  COLOR_YELLOW,
  COLOR_CYAN,
  COLOR_GREEN,
  COLOR_MAGENTA,
  COLOR_RED,
  COLOR_BLUE,
  COLOR_BLACK,
  COLOR_NEG_I,
  COLOR_POS_Q,
  COLOR_SUPER_BLACK,
  COLOR_DARK_GREY
};

static const struct vts_color_struct vts_colors_bt709_ycbcr_100[] = {
  {235, 128, 128, 255, 255, 255, 255, (235 << 8)},
  {219, 16, 138, 255, 255, 255, 0, (219 << 8)},
  {188, 154, 16, 255, 0, 255, 255, (188 < 8)},
  {173, 42, 26, 255, 0, 255, 0, (173 << 8)},
  {78, 214, 230, 255, 255, 0, 255, (78 << 8)},
  {63, 102, 240, 255, 255, 0, 0, (64 << 8)},
  {32, 240, 118, 255, 0, 0, 255, (32 << 8)},
  {16, 128, 128, 255, 0, 0, 0, (16 << 8)},
  {16, 198, 21, 255, 0, 0, 128, (16 << 8)},     /* -I ? */
  {16, 235, 198, 255, 0, 128, 255, (16 << 8)},  /* +Q ? */
  {0, 128, 128, 255, 0, 0, 0, 0},
  {32, 128, 128, 255, 19, 19, 19, (32 << 8)},
};

static const struct vts_color_struct vts_colors_bt709_ycbcr_75[] = {
  {180, 128, 128, 255, 191, 191, 191, (180 << 8)},
  {168, 44, 136, 255, 191, 191, 0, (168 << 8)},
  {145, 147, 44, 255, 0, 191, 191, (145 << 8)},
  {133, 63, 52, 255, 0, 191, 0, (133 << 8)},
  {63, 193, 204, 255, 191, 0, 191, (63 << 8)},
  {51, 109, 212, 255, 191, 0, 0, (51 << 8)},
  {28, 212, 120, 255, 0, 0, 191, (28 << 8)},
  {16, 128, 128, 255, 0, 0, 0, (16 << 8)},
  {16, 198, 21, 255, 0, 0, 128, (16 << 8)},     /* -I ? */
  {16, 235, 198, 255, 0, 128, 255, (16 << 8)},  /* +Q ? */
  {0, 128, 128, 255, 0, 0, 0, 0},
  {32, 128, 128, 255, 19, 19, 19, (32 << 8)},
};

static const struct vts_color_struct vts_colors_bt601_ycbcr_100[] = {
  {235, 128, 128, 255, 255, 255, 255, (235 << 8)},
  {210, 16, 146, 255, 255, 255, 0, (219 << 8)},
  {170, 166, 16, 255, 0, 255, 255, (188 < 8)},
  {145, 54, 34, 255, 0, 255, 0, (173 << 8)},
  {106, 202, 222, 255, 255, 0, 255, (78 << 8)},
  {81, 90, 240, 255, 255, 0, 0, (64 << 8)},
  {41, 240, 110, 255, 0, 0, 255, (32 << 8)},
  {16, 128, 128, 255, 0, 0, 0, (16 << 8)},
  {16, 198, 21, 255, 0, 0, 128, (16 << 8)},     /* -I ? */
  {16, 235, 198, 255, 0, 128, 255, (16 << 8)},  /* +Q ? */
  {-0, 128, 128, 255, 0, 0, 0, 0},
  {32, 128, 128, 255, 19, 19, 19, (32 << 8)},
};

static const struct vts_color_struct vts_colors_bt601_ycbcr_75[] = {
  {180, 128, 128, 255, 191, 191, 191, (180 << 8)},
  {162, 44, 142, 255, 191, 191, 0, (168 << 8)},
  {131, 156, 44, 255, 0, 191, 191, (145 << 8)},
  {112, 72, 58, 255, 0, 191, 0, (133 << 8)},
  {84, 184, 198, 255, 191, 0, 191, (63 << 8)},
  {65, 100, 212, 255, 191, 0, 0, (51 << 8)},
  {35, 212, 114, 255, 0, 0, 191, (28 << 8)},
  {16, 128, 128, 255, 0, 0, 0, (16 << 8)},
  {16, 198, 21, 255, 0, 0, 128, (16 << 8)},     /* -I ? */
  {16, 235, 198, 255, 0, 128, 255, (16 << 8)},  /* +Q ? */
  {-0, 128, 128, 255, 0, 0, 0, 0},
  {32, 128, 128, 255, 19, 19, 19, (32 << 8)},
};


static void paint_tmpline_ARGB (paintinfo * p, int x, int w);
static void paint_tmpline_AYUV (paintinfo * p, int x, int w);

static void convert_hline_generic (paintinfo * p, GstVideoFrame * frame, int y);
static void convert_hline_bayer (paintinfo * p, GstVideoFrame * frame, int y);

#define SCALEBITS 10
#define ONE_HALF  (1 << (SCALEBITS - 1))
#define FIX(x)    ((int) ((x) * (1<<SCALEBITS) + 0.5))

#define RGB_TO_Y(r, g, b) \
((FIX(0.29900) * (r) + FIX(0.58700) * (g) + \
  FIX(0.11400) * (b) + ONE_HALF) >> SCALEBITS)

#define RGB_TO_U(r1, g1, b1, shift)\
(((- FIX(0.16874) * r1 - FIX(0.33126) * g1 +         \
     FIX(0.50000) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

#define RGB_TO_V(r1, g1, b1, shift)\
(((FIX(0.50000) * r1 - FIX(0.41869) * g1 -           \
   FIX(0.08131) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

#define RGB_TO_Y_CCIR(r, g, b) \
((FIX(0.29900*219.0/255.0) * (r) + FIX(0.58700*219.0/255.0) * (g) + \
  FIX(0.11400*219.0/255.0) * (b) + (ONE_HALF + (16 << SCALEBITS))) >> SCALEBITS)

#define RGB_TO_U_CCIR(r1, g1, b1, shift)\
(((- FIX(0.16874*224.0/255.0) * r1 - FIX(0.33126*224.0/255.0) * g1 +         \
     FIX(0.50000*224.0/255.0) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

#define RGB_TO_V_CCIR(r1, g1, b1, shift)\
(((FIX(0.50000*224.0/255.0) * r1 - FIX(0.41869*224.0/255.0) * g1 -           \
   FIX(0.08131*224.0/255.0) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

#define RGB_TO_Y_CCIR_709(r, g, b) \
((FIX(0.212600*219.0/255.0) * (r) + FIX(0.715200*219.0/255.0) * (g) + \
  FIX(0.072200*219.0/255.0) * (b) + (ONE_HALF + (16 << SCALEBITS))) >> SCALEBITS)

#define RGB_TO_U_CCIR_709(r1, g1, b1, shift)\
(((- FIX(0.114572*224.0/255.0) * r1 - FIX(0.385427*224.0/255.0) * g1 +         \
     FIX(0.50000*224.0/255.0) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

#define RGB_TO_V_CCIR_709(r1, g1, b1, shift)\
(((FIX(0.50000*224.0/255.0) * r1 - FIX(0.454153*224.0/255.0) * g1 -           \
   FIX(0.045847*224.0/255.0) * b1 + (ONE_HALF << shift) - 1) >> (SCALEBITS + shift)) + 128)

static void
videotestsrc_setup_paintinfo (GstVideoTestSrc * v, paintinfo * p, int w, int h)
{
  gint a, r, g, b;
  gint width;
  GstVideoInfo *info = &v->info;

  width = GST_VIDEO_INFO_WIDTH (info);

  if (info->colorimetry.matrix == GST_VIDEO_COLOR_MATRIX_BT601) {
    p->colors = vts_colors_bt601_ycbcr_100;
  } else {
    p->colors = vts_colors_bt709_ycbcr_100;
  }

  if (v->bayer) {
    p->paint_tmpline = paint_tmpline_ARGB;
    p->convert_tmpline = convert_hline_bayer;
  } else {
    p->convert_tmpline = convert_hline_generic;
    if (GST_VIDEO_INFO_IS_RGB (info)) {
      p->paint_tmpline = paint_tmpline_ARGB;
    } else {
      p->paint_tmpline = paint_tmpline_AYUV;
    }
  }
  p->tmpline = v->tmpline;
  p->tmpline2 = v->tmpline2;
  p->tmpline_u8 = v->tmpline_u8;
  p->tmpline_u16 = v->tmpline_u16;
  p->n_lines = v->n_lines;
  p->offset = v->offset;
  p->lines = v->lines;
  p->x_offset = (v->horizontal_speed * v->n_frames) % width;
  if (p->x_offset < 0)
    p->x_offset += width;
  p->x_invert = v->x_invert;
  p->y_invert = v->y_invert;

  a = (v->foreground_color >> 24) & 0xff;
  r = (v->foreground_color >> 16) & 0xff;
  g = (v->foreground_color >> 8) & 0xff;
  b = (v->foreground_color >> 0) & 0xff;
  p->foreground_color.A = a;
  p->foreground_color.R = r;
  p->foreground_color.G = g;
  p->foreground_color.B = b;

  if (info->colorimetry.matrix == GST_VIDEO_COLOR_MATRIX_BT601) {
    p->foreground_color.Y = RGB_TO_Y_CCIR (r, g, b);
    p->foreground_color.U = RGB_TO_U_CCIR (r, g, b, 0);
    p->foreground_color.V = RGB_TO_V_CCIR (r, g, b, 0);
  } else {
    p->foreground_color.Y = RGB_TO_Y_CCIR_709 (r, g, b);
    p->foreground_color.U = RGB_TO_U_CCIR_709 (r, g, b, 0);
    p->foreground_color.V = RGB_TO_V_CCIR_709 (r, g, b, 0);
  }
  p->foreground_color.gray = RGB_TO_Y (r, g, b);

  a = (v->background_color >> 24) & 0xff;
  r = (v->background_color >> 16) & 0xff;
  g = (v->background_color >> 8) & 0xff;
  b = (v->background_color >> 0) & 0xff;
  p->background_color.A = a;
  p->background_color.R = r;
  p->background_color.G = g;
  p->background_color.B = b;

  if (info->colorimetry.matrix == GST_VIDEO_COLOR_MATRIX_BT601) {
    p->background_color.Y = RGB_TO_Y_CCIR (r, g, b);
    p->background_color.U = RGB_TO_U_CCIR (r, g, b, 0);
    p->background_color.V = RGB_TO_V_CCIR (r, g, b, 0);
  } else {
    p->background_color.Y = RGB_TO_Y_CCIR_709 (r, g, b);
    p->background_color.U = RGB_TO_U_CCIR_709 (r, g, b, 0);
    p->background_color.V = RGB_TO_V_CCIR_709 (r, g, b, 0);
  }
  p->background_color.gray = RGB_TO_Y (r, g, b);

  p->subsample = v->subsample;
}

static void
videotestsrc_convert_tmpline (paintinfo * p, GstVideoFrame * frame, int j)
{
  int x = p->x_offset;
  int i;
  int width = frame->info.width;
  int height = frame->info.height;
  int n_lines = p->n_lines;
  int offset = p->offset;

  if (x != 0) {
    memcpy (p->tmpline2, p->tmpline, width * 4);
    memcpy (p->tmpline, p->tmpline2 + x * 4, (width - x) * 4);
    memcpy (p->tmpline + (width - x) * 4, p->tmpline2, x * 4);
  }

  for (i = width; i < width + 5; i++) {
    p->tmpline[4 * i + 0] = p->tmpline[4 * (width - 1) + 0];
    p->tmpline[4 * i + 1] = p->tmpline[4 * (width - 1) + 1];
    p->tmpline[4 * i + 2] = p->tmpline[4 * (width - 1) + 2];
    p->tmpline[4 * i + 3] = p->tmpline[4 * (width - 1) + 3];
  }

  p->convert_tmpline (p, frame, j);

  if (j == height - 1) {
    while (j % n_lines - offset != n_lines - 1) {
      j++;
      p->convert_tmpline (p, frame, j);
    }
  }
}

#define BLEND1(a,b,x) ((a)*(x) + (b)*(255-(x)))
#define DIV255(x) (((x) + (((x)+128)>>8) + 128)>>8)
#define BLEND(a,b,x) DIV255(BLEND1(a,b,x))

#ifdef unused
static void
videotestsrc_blend_color (struct vts_color_struct *dest,
    struct vts_color_struct *a, struct vts_color_struct *b, int x)
{
  dest->Y = BLEND (a->Y, b->Y, x);
  dest->U = BLEND (a->U, b->U, x);
  dest->V = BLEND (a->V, b->V, x);
  dest->R = BLEND (a->R, b->R, x);
  dest->G = BLEND (a->G, b->G, x);
  dest->B = BLEND (a->B, b->B, x);
  dest->gray = BLEND (a->gray, b->gray, x);

}
#endif

static void
videotestsrc_blend_line (GstVideoTestSrc * v, guint8 * dest, guint8 * src,
    struct vts_color_struct *a, struct vts_color_struct *b, int n)
{
  int i;
  if (v->bayer || GST_VIDEO_INFO_IS_RGB (&v->info)) {
    for (i = 0; i < n; i++) {
      dest[i * 4 + 0] = BLEND (a->A, b->A, src[i]);
      dest[i * 4 + 1] = BLEND (a->R, b->R, src[i]);
      dest[i * 4 + 2] = BLEND (a->G, b->G, src[i]);
      dest[i * 4 + 3] = BLEND (a->B, b->B, src[i]);
    }
  } else {
    for (i = 0; i < n; i++) {
      dest[i * 4 + 0] = BLEND (a->A, b->A, src[i]);
      dest[i * 4 + 1] = BLEND (a->Y, b->Y, src[i]);
      dest[i * 4 + 2] = BLEND (a->U, b->U, src[i]);
      dest[i * 4 + 3] = BLEND (a->V, b->V, src[i]);
    }
  }
#undef BLEND
}

void
gst_video_test_src_smpte (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int y1, y2;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  y1 = 2 * h / 3;
  y2 = 3 * h / 4;

  /* color bars */
  for (j = 0; j < y1; j++) {
    for (i = 0; i < 7; i++) {
      int x1 = i * w / 7;
      int x2 = (i + 1) * w / 7;

      p->color = p->colors + i;
      p->paint_tmpline (p, x1, (x2 - x1));
    }
    videotestsrc_convert_tmpline (p, frame, j);
  }

  /* inverse blue bars */
  for (j = y1; j < y2; j++) {
    for (i = 0; i < 7; i++) {
      int x1 = i * w / 7;
      int x2 = (i + 1) * w / 7;
      int k;

      if (i & 1) {
        k = 7;
      } else {
        k = 6 - i;
      }
      p->color = p->colors + k;
      p->paint_tmpline (p, x1, (x2 - x1));
    }
    videotestsrc_convert_tmpline (p, frame, j);
  }

  for (j = y2; j < h; j++) {
    /* -I, white, Q regions */
    for (i = 0; i < 3; i++) {
      int x1 = i * w / 6;
      int x2 = (i + 1) * w / 6;
      int k;

      if (i == 0) {
        k = 8;
      } else if (i == 1) {
        k = 0;
      } else
        k = 9;

      p->color = p->colors + k;
      p->paint_tmpline (p, x1, (x2 - x1));
    }

    /* superblack, black, dark grey */
    for (i = 0; i < 3; i++) {
      int x1 = w / 2 + i * w / 12;
      int x2 = w / 2 + (i + 1) * w / 12;
      int k;

      if (i == 0) {
        k = COLOR_SUPER_BLACK;
      } else if (i == 1) {
        k = COLOR_BLACK;
      } else
        k = COLOR_DARK_GREY;

      p->color = p->colors + k;
      p->paint_tmpline (p, x1, (x2 - x1));
    }

    {
      int x1 = w * 3 / 4;
      struct vts_color_struct color;

      color = p->colors[COLOR_BLACK];
      p->color = &color;

      for (i = x1; i < w; i++) {
        int y = random_char ();
        p->tmpline_u8[i] = y;
      }
      videotestsrc_blend_line (v, p->tmpline + x1 * 4, p->tmpline_u8 + x1,
          &p->foreground_color, &p->background_color, w - x1);

    }
    videotestsrc_convert_tmpline (p, frame, j);

  }
}

void
gst_video_test_src_smpte75 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);
  if (v->info.colorimetry.matrix == GST_VIDEO_COLOR_MATRIX_BT601) {
    p->colors = vts_colors_bt601_ycbcr_75;
  } else {
    p->colors = vts_colors_bt709_ycbcr_75;
  }

  /* color bars */
  for (j = 0; j < h; j++) {
    for (i = 0; i < 7; i++) {
      int x1 = i * w / 7;
      int x2 = (i + 1) * w / 7;

      p->color = p->colors + i;
      p->paint_tmpline (p, x1, (x2 - x1));
    }
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_smpte100 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  /* color bars */
  for (j = 0; j < h; j++) {
    for (i = 0; i < 7; i++) {
      int x1 = i * w / 7;
      int x2 = (i + 1) * w / 7;

      p->color = p->colors + i;
      p->paint_tmpline (p, x1, (x2 - x1));
    }
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_bar (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (j = 0; j < h; j++) {
    /* use fixed size for now */
    int x2 = w / 7;

    p->color = &p->foreground_color;
    p->paint_tmpline (p, 0, x2);
    p->color = &p->background_color;
    p->paint_tmpline (p, x2, (w - x2));
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_snow (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct color;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  color = p->colors[COLOR_BLACK];
  p->color = &color;

  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      int y = random_char ();
      p->tmpline_u8[i] = y;
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

static void
gst_video_test_src_unicolor (GstVideoTestSrc * v, GstVideoFrame * frame,
    int color_index)
{
  int i;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  p->color = p->colors + color_index;
  if (color_index == COLOR_BLACK) {
    p->color = &p->background_color;
  }
  if (color_index == COLOR_WHITE) {
    p->color = &p->foreground_color;
  }

  for (i = 0; i < h; i++) {
    p->paint_tmpline (p, 0, w);
    videotestsrc_convert_tmpline (p, frame, i);
  }
}

void
gst_video_test_src_black (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  gst_video_test_src_unicolor (v, frame, COLOR_BLACK);
}

void
gst_video_test_src_white (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  gst_video_test_src_unicolor (v, frame, COLOR_WHITE);
}

void
gst_video_test_src_red (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  gst_video_test_src_unicolor (v, frame, COLOR_RED);
}

void
gst_video_test_src_green (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  gst_video_test_src_unicolor (v, frame, COLOR_GREEN);
}

void
gst_video_test_src_blue (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  gst_video_test_src_unicolor (v, frame, COLOR_BLUE);
}

void
gst_video_test_src_blink (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  if (v->n_frames & 1) {
    p->color = &p->foreground_color;
  } else {
    p->color = &p->background_color;
  }

  for (i = 0; i < h; i++) {
    p->paint_tmpline (p, 0, w);
    videotestsrc_convert_tmpline (p, frame, i);
  }
}

void
gst_video_test_src_solid (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  p->color = &p->foreground_color;

  for (i = 0; i < h; i++) {
    p->paint_tmpline (p, 0, w);
    videotestsrc_convert_tmpline (p, frame, i);
  }
}

void
gst_video_test_src_checkers1 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int x, y;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (y = 0; y < h; y++) {
    for (x = 0; x < w; x++) {
      if ((x ^ y) & 1) {
        p->color = p->colors + COLOR_GREEN;
      } else {
        p->color = p->colors + COLOR_RED;
      }
      p->paint_tmpline (p, x, 1);
    }
    videotestsrc_convert_tmpline (p, frame, y);
  }
}

void
gst_video_test_src_checkers2 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int x, y;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (y = 0; y < h; y++) {
    for (x = 0; x < w; x += 2) {
      guint len = MIN (2, w - x);

      if ((x ^ y) & 2) {
        p->color = p->colors + COLOR_GREEN;
      } else {
        p->color = p->colors + COLOR_RED;
      }
      p->paint_tmpline (p, x, len);
    }
    videotestsrc_convert_tmpline (p, frame, y);
  }
}

void
gst_video_test_src_checkers4 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int x, y;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (y = 0; y < h; y++) {
    for (x = 0; x < w; x += 4) {
      guint len = MIN (4, w - x);

      if ((x ^ y) & 4) {
        p->color = p->colors + COLOR_GREEN;
      } else {
        p->color = p->colors + COLOR_RED;
      }
      p->paint_tmpline (p, x, len);
    }
    videotestsrc_convert_tmpline (p, frame, y);
  }
}

void
gst_video_test_src_checkers8 (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int x, y;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (y = 0; y < h; y++) {
    for (x = 0; x < w; x += 8) {
      guint len = MIN (8, w - x);

      if ((x ^ y) & 8) {
        p->color = p->colors + COLOR_GREEN;
      } else {
        p->color = p->colors + COLOR_RED;
      }
      p->paint_tmpline (p, x, len);
    }
    videotestsrc_convert_tmpline (p, frame, y);
  }
}

static const guint8 sine_table[256] = {
  128, 131, 134, 137, 140, 143, 146, 149,
  152, 156, 159, 162, 165, 168, 171, 174,
  176, 179, 182, 185, 188, 191, 193, 196,
  199, 201, 204, 206, 209, 211, 213, 216,
  218, 220, 222, 224, 226, 228, 230, 232,
  234, 236, 237, 239, 240, 242, 243, 245,
  246, 247, 248, 249, 250, 251, 252, 252,
  253, 254, 254, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 254, 254,
  253, 252, 252, 251, 250, 249, 248, 247,
  246, 245, 243, 242, 240, 239, 237, 236,
  234, 232, 230, 228, 226, 224, 222, 220,
  218, 216, 213, 211, 209, 206, 204, 201,
  199, 196, 193, 191, 188, 185, 182, 179,
  176, 174, 171, 168, 165, 162, 159, 156,
  152, 149, 146, 143, 140, 137, 134, 131,
  128, 124, 121, 118, 115, 112, 109, 106,
  103, 99, 96, 93, 90, 87, 84, 81,
  79, 76, 73, 70, 67, 64, 62, 59,
  56, 54, 51, 49, 46, 44, 42, 39,
  37, 35, 33, 31, 29, 27, 25, 23,
  21, 19, 18, 16, 15, 13, 12, 10,
  9, 8, 7, 6, 5, 4, 3, 3,
  2, 1, 1, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1,
  2, 3, 3, 4, 5, 6, 7, 8,
  9, 10, 12, 13, 15, 16, 18, 19,
  21, 23, 25, 27, 29, 31, 33, 35,
  37, 39, 42, 44, 46, 49, 51, 54,
  56, 59, 62, 64, 67, 70, 73, 76,
  79, 81, 84, 87, 90, 93, 96, 99,
  103, 106, 109, 112, 115, 118, 121, 124
};


void
gst_video_test_src_zoneplate (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct color;
  int t = v->n_frames;
  int w = frame->info.width, h = frame->info.height;
  int xreset = -(w / 2) - v->xoffset;   /* starting values for x^2 and y^2, centering the ellipse */
  int yreset = -(h / 2) - v->yoffset;

  int x, y;
  int accum_kx;
  int accum_kxt;
  int accum_ky;
  int accum_kyt;
  int accum_kxy;
  int kt;
  int kt2;
  int ky2;
  int delta_kxt = v->kxt * t;
  int delta_kxy;
  int scale_kxy = 0xffff / (w / 2);
  int scale_kx2 = 0xffff / w;

  videotestsrc_setup_paintinfo (v, p, w, h);

  color = p->colors[COLOR_BLACK];
  p->color = &color;

  /* Zoneplate equation:
   *
   * phase = k0 + kx*x + ky*y + kt*t
   *       + kxt*x*t + kyt*y*t + kxy*x*y
   *       + kx2*x*x + ky2*y*y + Kt2*t*t
   */

#if 0
  for (j = 0, y = yreset; j < h; j++, y++) {
    for (i = 0, x = xreset; i < w; i++, x++) {

      /* zero order */
      int phase = v->k0;

      /* first order */
      phase = phase + (v->kx * i) + (v->ky * j) + (v->kt * t);

      /* cross term */
      /* phase = phase + (v->kxt * i * t) + (v->kyt * j * t); */
      /* phase = phase + (v->kxy * x * y) / (w/2); */

      /*second order */
      /*normalise x/y terms to rate of change of phase at the picture edge */
      phase =
          phase + ((v->kx2 * x * x) / w) + ((v->ky2 * y * y) / h) +
          ((v->kt2 * t * t) >> 1);

      color.Y = sine_table[phase & 0xff];

      color.R = color.Y;
      color.G = color.Y;
      color.B = color.Y;
      p->paint_tmpline (p, i, 1);
    }
  }
#endif

  /* optimised version, with original code shown in comments */
  accum_ky = 0;
  accum_kyt = 0;
  kt = v->kt * t;
  kt2 = v->kt2 * t * t;
  for (j = 0, y = yreset; j < h; j++, y++) {
    accum_kx = 0;
    accum_kxt = 0;
    accum_ky += v->ky;
    accum_kyt += v->kyt * t;
    delta_kxy = v->kxy * y * scale_kxy;
    accum_kxy = delta_kxy * xreset;
    ky2 = (v->ky2 * y * y) / h;
    for (i = 0, x = xreset; i < w; i++, x++) {

      /* zero order */
      int phase = v->k0;

      /* first order */
      accum_kx += v->kx;
      /* phase = phase + (v->kx * i) + (v->ky * j) + (v->kt * t); */
      phase = phase + accum_kx + accum_ky + kt;

      /* cross term */
      accum_kxt += delta_kxt;
      accum_kxy += delta_kxy;
      /* phase = phase + (v->kxt * i * t) + (v->kyt * j * t); */
      phase = phase + accum_kxt + accum_kyt;

      /* phase = phase + (v->kxy * x * y) / (w/2); */
      /* phase = phase + accum_kxy / (w/2); */
      phase = phase + (accum_kxy >> 16);

      /*second order */
      /*normalise x/y terms to rate of change of phase at the picture edge */
      /*phase = phase + ((v->kx2 * x * x)/w) + ((v->ky2 * y * y)/h) + ((v->kt2 * t * t)>>1); */
      phase = phase + ((v->kx2 * x * x * scale_kx2) >> 16) + ky2 + (kt2 >> 1);

      p->tmpline_u8[i] = sine_table[phase & 0xff];
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_chromazoneplate (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct color;
  int t = v->n_frames;
  int w = frame->info.width, h = frame->info.height;

  int xreset = -(w / 2) - v->xoffset;   /* starting values for x^2 and y^2, centering the ellipse */
  int yreset = -(h / 2) - v->yoffset;

  int x, y;
  int accum_kx;
  int accum_kxt;
  int accum_ky;
  int accum_kyt;
  int accum_kxy;
  int kt;
  int kt2;
  int ky2;
  int delta_kxt = v->kxt * t;
  int delta_kxy;
  int scale_kxy = 0xffff / (w / 2);
  int scale_kx2 = 0xffff / w;

  videotestsrc_setup_paintinfo (v, p, w, h);

  color = p->colors[COLOR_BLACK];
  p->color = &color;

  /* Zoneplate equation:
   *
   * phase = k0 + kx*x + ky*y + kt*t
   *       + kxt*x*t + kyt*y*t + kxy*x*y
   *       + kx2*x*x + ky2*y*y + Kt2*t*t
   */

  /* optimised version, with original code shown in comments */
  accum_ky = 0;
  accum_kyt = 0;
  kt = v->kt * t;
  kt2 = v->kt2 * t * t;
  for (j = 0, y = yreset; j < h; j++, y++) {
    accum_kx = 0;
    accum_kxt = 0;
    accum_ky += v->ky;
    accum_kyt += v->kyt * t;
    delta_kxy = v->kxy * y * scale_kxy;
    accum_kxy = delta_kxy * xreset;
    ky2 = (v->ky2 * y * y) / h;
    for (i = 0, x = xreset; i < w; i++, x++) {

      /* zero order */
      int phase = v->k0;

      /* first order */
      accum_kx += v->kx;
      /* phase = phase + (v->kx * i) + (v->ky * j) + (v->kt * t); */
      phase = phase + accum_kx + accum_ky + kt;

      /* cross term */
      accum_kxt += delta_kxt;
      accum_kxy += delta_kxy;
      /* phase = phase + (v->kxt * i * t) + (v->kyt * j * t); */
      phase = phase + accum_kxt + accum_kyt;

      /* phase = phase + (v->kxy * x * y) / (w/2); */
      /* phase = phase + accum_kxy / (w/2); */
      phase = phase + (accum_kxy >> 16);

      /*second order */
      /*normalise x/y terms to rate of change of phase at the picture edge */
      /*phase = phase + ((v->kx2 * x * x)/w) + ((v->ky2 * y * y)/h) + ((v->kt2 * t * t)>>1); */
      phase = phase + ((v->kx2 * x * x * scale_kx2) >> 16) + ky2 + (kt2 >> 1);

      color.Y = 128;
      color.U = sine_table[phase & 0xff];
      color.V = sine_table[phase & 0xff];

      color.R = 128;
      color.G = 128;
      color.B = color.V;

      color.gray = color.Y << 8;
      p->paint_tmpline (p, i, 1);
    }
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

#undef SCALE_AMPLITUDE
void
gst_video_test_src_circular (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  double freq[8];
  int w = frame->info.width, h = frame->info.height;

  int d;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (i = 1; i < 8; i++) {
    freq[i] = 200 * pow (2.0, -(i - 1) / 4.0);
  }

  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      double dist;
      int seg;

      dist =
          sqrt ((2 * i - w) * (2 * i - w) + (2 * j - h) * (2 * j -
              h)) / (2 * w);
      seg = floor (dist * 16);
      if (seg == 0 || seg >= 8) {
        p->tmpline_u8[i] = 0;
      } else {
        d = floor (256 * dist * freq[seg] + 0.5);
        p->tmpline_u8[i] = sine_table[d & 0xff];
      }
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_gamut (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int x, y;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct yuv_primary;
  struct vts_color_struct yuv_secondary;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  for (y = 0; y < h; y++) {
    int region = (y * 4) / h;

    switch (region) {
      case 0:                  /* black */
        yuv_primary = p->colors[COLOR_BLACK];
        yuv_secondary = p->colors[COLOR_BLACK];
        yuv_secondary.Y = 0;
        break;
      case 1:
        yuv_primary = p->colors[COLOR_WHITE];
        yuv_secondary = p->colors[COLOR_WHITE];
        yuv_secondary.Y = 255;
        break;
      case 2:
        yuv_primary = p->colors[COLOR_RED];
        yuv_secondary = p->colors[COLOR_RED];
        yuv_secondary.V = 255;
        break;
      case 3:
        yuv_primary = p->colors[COLOR_BLUE];
        yuv_secondary = p->colors[COLOR_BLUE];
        yuv_secondary.U = 255;
        break;
    }

    for (x = 0; x < w; x += 8) {
      int len = MIN (8, w - x);

      if ((x ^ y) & (1 << 4)) {
        p->color = &yuv_primary;
      } else {
        p->color = &yuv_secondary;
      }
      p->paint_tmpline (p, x, len);
    }
    videotestsrc_convert_tmpline (p, frame, y);
  }
}

void
gst_video_test_src_ball (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  int t = v->n_frames;
  double x, y;
  int radius = 20;
  int w = frame->info.width, h = frame->info.height;

  videotestsrc_setup_paintinfo (v, p, w, h);

  x = radius + (0.5 + 0.5 * sin (2 * G_PI * t / 200)) * (w - 2 * radius);
  y = radius + (0.5 + 0.5 * sin (2 * G_PI * sqrt (2) * t / 200)) * (h -
      2 * radius);

  for (i = 0; i < h; i++) {
    if (i < y - radius || i > y + radius) {
      memset (p->tmpline_u8, 0, w);
    } else {
      int r = rint (sqrt (radius * radius - (i - y) * (i - y)));
      int x1, x2;
      int j;

      x1 = 0;
      x2 = MAX (0, x - r);
      for (j = x1; j < x2; j++) {
        p->tmpline_u8[j] = 0;
      }

      x1 = MAX (0, x - r);
      x2 = MIN (w, x + r + 1);
      for (j = x1; j < x2; j++) {
        double rr = radius - sqrt ((j - x) * (j - x) + (i - y) * (i - y));

        rr *= 0.5;
        p->tmpline_u8[j] = CLAMP ((int) floor (256 * rr), 0, 255);
      }

      x1 = MIN (w, x + r + 1);
      x2 = w;
      for (j = x1; j < x2; j++) {
        p->tmpline_u8[j] = 0;
      }
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, i);
  }
}

static void
paint_tmpline_ARGB (paintinfo * p, int x, int w)
{
  int offset;
  guint32 value;

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
  value = (p->color->A << 0) | (p->color->R << 8) |
      (p->color->G << 16) | (p->color->B << 24);
#else
  value = (p->color->A << 24) | (p->color->R << 16) |
      (p->color->G << 8) | (p->color->B << 0);
#endif

  offset = (x * 4);
  video_test_src_orc_splat_u32 (p->tmpline + offset, value, w);
}

static void
paint_tmpline_AYUV (paintinfo * p, int x, int w)
{
  int offset;
  guint32 value;

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
  value = (p->color->A << 0) | (p->color->Y << 8) |
      (p->color->U << 16) | ((guint32) p->color->V << 24);
#else
  value = ((guint32) p->color->A << 24) | (p->color->Y << 16) |
      (p->color->U << 8) | (p->color->V << 0);
#endif

  offset = (x * 4);
  video_test_src_orc_splat_u32 (p->tmpline + offset, value, w);
}

static void
convert_hline_generic (paintinfo * p, GstVideoFrame * frame, int y)
{
  const GstVideoFormatInfo *finfo, *uinfo;
  gint line, offset, i, width, height, bits;
  guint n_lines;
  gpointer dest;

  finfo = frame->info.finfo;
  uinfo = gst_video_format_get_info (finfo->unpack_format);

  width = GST_VIDEO_FRAME_WIDTH (frame);
  height = GST_VIDEO_FRAME_HEIGHT (frame);

  bits = GST_VIDEO_FORMAT_INFO_DEPTH (uinfo, 0);

  n_lines = p->n_lines;
  offset = p->offset;
  line = y % n_lines;
  dest = p->lines[line];

  if (bits == 16) {
    /* 16 bits */
    for (i = 0; i < width; i++) {
      p->tmpline_u16[i * 4 + 0] = TO_16 (p->tmpline[i * 4 + 0]);
      p->tmpline_u16[i * 4 + 1] = TO_16 (p->tmpline[i * 4 + 1]);
      p->tmpline_u16[i * 4 + 2] = TO_16 (p->tmpline[i * 4 + 2]);
      p->tmpline_u16[i * 4 + 3] = TO_16 (p->tmpline[i * 4 + 3]);
    }
    memcpy (dest, p->tmpline_u16, width * 8);
  } else {
    memcpy (dest, p->tmpline, width * 4);
  }

  if (line - offset == n_lines - 1) {
    gpointer lines[8];
    guint idx;

    y -= n_lines - 1;

    for (i = 0; i < n_lines; i++) {
      idx = CLAMP (y + i + offset, 0, height - 1);

      GST_DEBUG ("line %d, %d, idx %d", i, y + i + offset, idx);
      lines[i] = p->lines[idx % n_lines];
    }

    if (p->subsample)
      gst_video_chroma_resample (p->subsample, lines, width);

    for (i = 0; i < n_lines; i++) {
      idx = y + i + offset;
      if (idx > height - 1)
        break;
      GST_DEBUG ("pack line %d", idx);
      finfo->pack_func (finfo, GST_VIDEO_PACK_FLAG_NONE,
          lines[i], 0, frame->data, frame->info.stride,
          frame->info.chroma_site, idx, width);
    }
  }
}

static void
convert_hline_bayer (paintinfo * p, GstVideoFrame * frame, int y)
{
  int i;
  guint8 *data = GST_VIDEO_FRAME_PLANE_DATA (frame, 0);
  guint8 *R = data + y * GST_VIDEO_FRAME_PLANE_STRIDE (frame, 0);
  guint8 *argb = p->tmpline;
  gint width = GST_VIDEO_FRAME_WIDTH (frame);
  int x_inv = p->x_invert;
  int y_inv = p->y_invert;

  if ((y ^ y_inv) & 1) {
    for (i = 0; i < width; i++) {
      if ((i ^ x_inv) & 1) {
        R[i] = argb[4 * i + 1];
      } else {
        R[i] = argb[4 * i + 2];
      }
    }
  } else {
    for (i = 0; i < width; i++) {
      if ((i ^ x_inv) & 1) {
        R[i] = argb[4 * i + 2];
      } else {
        R[i] = argb[4 * i + 3];
      }
    }
  }
}

void
gst_video_test_src_pinwheel (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  int k;
  int t = v->n_frames;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct color;
  int w = frame->info.width, h = frame->info.height;
  double c[20];
  double s[20];

  videotestsrc_setup_paintinfo (v, p, w, h);

  color = p->colors[COLOR_BLACK];
  p->color = &color;

  for (k = 0; k < 19; k++) {
    double theta = M_PI / 19 * k + 0.001 * v->kt * t;
    c[k] = cos (theta);
    s[k] = sin (theta);
  }

  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      double v;
      v = 0;
      for (k = 0; k < 19; k++) {
        double x, y;

        x = c[k] * (i - 0.5 * w) + s[k] * (j - 0.5 * h);
        x *= 1.0;

        y = CLAMP (x, -1, 1);
        if (k & 1)
          y = -y;

        v += y;
      }

      p->tmpline_u8[i] = CLAMP (rint (v * 128 + 128), 0, 255);
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, j);
  }
}

void
gst_video_test_src_spokes (GstVideoTestSrc * v, GstVideoFrame * frame)
{
  int i;
  int j;
  int k;
  int t = v->n_frames;
  paintinfo pi = PAINT_INFO_INIT;
  paintinfo *p = &pi;
  struct vts_color_struct color;
  int w = frame->info.width, h = frame->info.height;
  double c[20];
  double s[20];

  videotestsrc_setup_paintinfo (v, p, w, h);

  color = p->colors[COLOR_BLACK];
  p->color = &color;

  for (k = 0; k < 19; k++) {
    double theta = M_PI / 19 * k + 0.001 * v->kt * t;
    c[k] = cos (theta);
    s[k] = sin (theta);
  }

  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      double v;
      v = 0;
      for (k = 0; k < 19; k++) {
        double x, y;
        double sharpness = 1.0;
        double linewidth = 2.0;

        x = c[k] * (i - 0.5 * w) + s[k] * (j - 0.5 * h);
        x = linewidth * 0.5 - fabs (x);
        x *= sharpness;

        y = CLAMP (x + 0.5, 0.0, 1.0);

        v += y;
      }

      p->tmpline_u8[i] = CLAMP (rint (v * 255), 0, 255);
    }
    videotestsrc_blend_line (v, p->tmpline, p->tmpline_u8,
        &p->foreground_color, &p->background_color, w);
    videotestsrc_convert_tmpline (p, frame, j);
  }
}
