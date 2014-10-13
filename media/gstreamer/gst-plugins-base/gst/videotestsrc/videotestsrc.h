/* GStreamer
 * Copyright (C) <2003> David A. Schleef <ds@schleef.org>
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

#ifndef __VIDEO_TEST_SRC_H__
#define __VIDEO_TEST_SRC_H__

#include <glib.h>

struct vts_color_struct {
  guint8 Y, U, V, A;
  guint8 R, G, B;
  guint16 gray;
};


typedef struct paintinfo_struct paintinfo;

struct paintinfo_struct
{
  const struct vts_color_struct *colors;
  const struct vts_color_struct *color;

  void (*paint_tmpline) (paintinfo * p, int x, int w);
  void (*convert_tmpline) (paintinfo * p, GstVideoFrame *frame, int y);
  void (*convert_hline) (paintinfo * p, GstVideoFrame *frame, int y);
  GstVideoChromaResample *subsample;
  int x_offset;

  int x_invert;
  int y_invert;

  guint8 *tmpline;
  guint8 *tmpline2;
  guint8 *tmpline_u8;
  guint16 *tmpline_u16;

  guint n_lines;
  gint offset;
  gpointer *lines;

  struct vts_color_struct foreground_color;
  struct vts_color_struct background_color;
};
#define PAINT_INFO_INIT {0, }

void    gst_video_test_src_smpte        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_smpte75      (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_snow         (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_black        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_white        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_red          (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_green        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_blue         (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_solid        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_blink        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_checkers1    (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_checkers2    (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_checkers4    (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_checkers8    (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_circular     (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_zoneplate    (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_gamut        (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_chromazoneplate (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_ball         (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_smpte100     (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_bar          (GstVideoTestSrc * v, GstVideoFrame *frame);
void    gst_video_test_src_pinwheel     (GstVideoTestSrc * v, GstVideoFrame * frame);
void    gst_video_test_src_spokes       (GstVideoTestSrc * v, GstVideoFrame * frame);

#endif
