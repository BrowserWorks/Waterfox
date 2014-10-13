/* GStreamer
 * Copyright (C) <2002> David A. Schleef <ds@schleef.org>
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

#ifndef __GST_VIDEO_TEST_SRC_H__
#define __GST_VIDEO_TEST_SRC_H__

#include <gst/gst.h>
#include <gst/base/gstpushsrc.h>

#include <gst/video/gstvideometa.h>
#include <gst/video/gstvideopool.h>

G_BEGIN_DECLS

#define GST_TYPE_VIDEO_TEST_SRC \
  (gst_video_test_src_get_type())
#define GST_VIDEO_TEST_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_VIDEO_TEST_SRC,GstVideoTestSrc))
#define GST_VIDEO_TEST_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_VIDEO_TEST_SRC,GstVideoTestSrcClass))
#define GST_IS_VIDEO_TEST_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VIDEO_TEST_SRC))
#define GST_IS_VIDEO_TEST_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VIDEO_TEST_SRC))

/**
 * GstVideoTestSrcPattern:
 * @GST_VIDEO_TEST_SRC_SMPTE: A standard SMPTE test pattern
 * @GST_VIDEO_TEST_SRC_SNOW: Random noise
 * @GST_VIDEO_TEST_SRC_BLACK: A black image
 * @GST_VIDEO_TEST_SRC_WHITE: A white image
 * @GST_VIDEO_TEST_SRC_RED: A red image
 * @GST_VIDEO_TEST_SRC_GREEN: A green image
 * @GST_VIDEO_TEST_SRC_BLUE: A blue image
 * @GST_VIDEO_TEST_SRC_CHECKERS1: Checkers pattern (1px)
 * @GST_VIDEO_TEST_SRC_CHECKERS2: Checkers pattern (2px)
 * @GST_VIDEO_TEST_SRC_CHECKERS4: Checkers pattern (4px)
 * @GST_VIDEO_TEST_SRC_CHECKERS8: Checkers pattern (8px)
 * @GST_VIDEO_TEST_SRC_CIRCULAR: Circular pattern
 * @GST_VIDEO_TEST_SRC_BLINK: Alternate between black and white
 * @GST_VIDEO_TEST_SRC_SMPTE75: SMPTE test pattern (75% color bars)
 * @GST_VIDEO_TEST_SRC_ZONE_PLATE: Zone plate
 * @GST_VIDEO_TEST_SRC_GAMUT: Gamut checking pattern
 * @GST_VIDEO_TEST_SRC_CHROMA_ZONE_PLATE: Chroma zone plate
 * @GST_VIDEO_TEST_SRC_BALL: Moving ball
 * @GST_VIDEO_TEST_SRC_SMPTE100: SMPTE test pattern (100% color bars)
 * @GST_VIDEO_TEST_SRC_BAR: Bar with foreground color
 * @GST_VIDEO_TEST_SRC_PINWHEEL: Pinwheel
 * @GST_VIDEO_TEST_SRC_SPOKES: Spokes
 *
 * The test pattern to produce.
 *
 * The Gamut pattern creates a checkerboard pattern of colors at the
 * edge of the YCbCr gamut and nearby colors that are out of gamut.
 * The pattern is divided into 4 regions: black, white, red, and blue.
 * After conversion to RGB, the out-of-gamut colors should be converted
 * to the same value as their in-gamut neighbors.  If the checkerboard
 * pattern is still visible after conversion, this indicates a faulty
 * conversion.  Image manipulation, such as adjusting contrast or
 * brightness, can also cause the pattern to be visible.
 *
 * The Zone Plate pattern is based on BBC R&D Report 1978/23, and can
 * be used to test spatial frequency response of a system.  This
 * pattern generator is controlled by the xoffset and yoffset parameters
 * and also by all the parameters starting with 'k'.  The default
 * parameters produce a grey pattern.  Try 'videotestsrc
 * pattern=zone-plate kx2=20 ky2=20 kt=1' to produce something
 * interesting.
 */
typedef enum {
  GST_VIDEO_TEST_SRC_SMPTE,
  GST_VIDEO_TEST_SRC_SNOW,
  GST_VIDEO_TEST_SRC_BLACK,
  GST_VIDEO_TEST_SRC_WHITE,
  GST_VIDEO_TEST_SRC_RED,
  GST_VIDEO_TEST_SRC_GREEN,
  GST_VIDEO_TEST_SRC_BLUE,
  GST_VIDEO_TEST_SRC_CHECKERS1,
  GST_VIDEO_TEST_SRC_CHECKERS2,
  GST_VIDEO_TEST_SRC_CHECKERS4,
  GST_VIDEO_TEST_SRC_CHECKERS8,
  GST_VIDEO_TEST_SRC_CIRCULAR,
  GST_VIDEO_TEST_SRC_BLINK,
  GST_VIDEO_TEST_SRC_SMPTE75,
  GST_VIDEO_TEST_SRC_ZONE_PLATE,
  GST_VIDEO_TEST_SRC_GAMUT,
  GST_VIDEO_TEST_SRC_CHROMA_ZONE_PLATE,
  GST_VIDEO_TEST_SRC_SOLID,
  GST_VIDEO_TEST_SRC_BALL,
  GST_VIDEO_TEST_SRC_SMPTE100,
  GST_VIDEO_TEST_SRC_BAR,
  GST_VIDEO_TEST_SRC_PINWHEEL,
  GST_VIDEO_TEST_SRC_SPOKES
} GstVideoTestSrcPattern;

typedef struct _GstVideoTestSrc GstVideoTestSrc;
typedef struct _GstVideoTestSrcClass GstVideoTestSrcClass;

/**
 * GstVideoTestSrc:
 *
 * Opaque data structure.
 */
struct _GstVideoTestSrc {
  GstPushSrc element;

  /*< private >*/

  /* type of output */
  GstVideoTestSrcPattern pattern_type;

  /* video state */
  GstVideoInfo info;
  GstVideoChromaResample *subsample;
  gboolean bayer;
  gint x_invert;
  gint y_invert;

  /* private */
  gint64 timestamp_offset;              /* base offset */

  /* running time and frames for current caps */
  GstClockTime running_time;            /* total running time */
  gint64 n_frames;                      /* total frames sent */
  gboolean reverse;

  /* previous caps running time and frames */
  GstClockTime accum_rtime;              /* accumulated running_time */
  gint64 accum_frames;                  /* accumulated frames */

  /* zoneplate */
  gint k0;
  gint kx;
  gint ky;
  gint kt;
  gint kxt;
  gint kyt;
  gint kxy;
  gint kx2;
  gint ky2;
  gint kt2;
  gint xoffset;
  gint yoffset;

  /* solid color */
  guint foreground_color;
  guint background_color;

  /* moving color bars */
  gint horizontal_offset;
  gint horizontal_speed;

  void (*make_image) (GstVideoTestSrc *v, GstVideoFrame *frame);

  /* temporary AYUV/ARGB scanline */
  guint8 *tmpline_u8;
  guint8 *tmpline;
  guint8 *tmpline2;
  guint16 *tmpline_u16;

  guint n_lines;
  gint offset;
  gpointer *lines;
};

struct _GstVideoTestSrcClass {
  GstPushSrcClass parent_class;
};

GType gst_video_test_src_get_type (void);

G_END_DECLS

#endif /* __GST_VIDEO_TEST_SRC_H__ */
