/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstfakesrc.h:
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


#ifndef __GST_FAKE_SRC_H__
#define __GST_FAKE_SRC_H__

#include <gst/gst.h>
#include <gst/base/gstbasesrc.h>

G_BEGIN_DECLS

/**
 * GstFakeSrcOutputType:
 * @FAKE_SRC_FIRST_LAST_LOOP: first pad then last pad
 * @FAKE_SRC_LAST_FIRST_LOOP: last pad then first pad
 * @FAKE_SRC_PING_PONG: ping pong between pads
 * @FAKE_SRC_ORDERED_RANDOM: ordered random pad
 * @FAKE_SRC_RANDOM: random pad
 * @FAKE_SRC_PATTERN_LOOP: loop between pads in a particular pattern
 * @FAKE_SRC_PING_PONG_PATTERN: ping pong based on a pattern
 * @FAKE_SRC_GET_ALWAYS_SUCEEDS: a get always succeeds on a pad
 *
 * The different output types. Unused currently.
 */
typedef enum {
  FAKE_SRC_FIRST_LAST_LOOP = 1,
  FAKE_SRC_LAST_FIRST_LOOP,
  FAKE_SRC_PING_PONG,
  FAKE_SRC_ORDERED_RANDOM,
  FAKE_SRC_RANDOM,
  FAKE_SRC_PATTERN_LOOP,
  FAKE_SRC_PING_PONG_PATTERN,
  FAKE_SRC_GET_ALWAYS_SUCEEDS
} GstFakeSrcOutputType;

/**
 * GstFakeSrcDataType:
 * @FAKE_SRC_DATA_ALLOCATE: allocate buffers
 * @FAKE_SRC_DATA_SUBBUFFER: subbuffer each buffer
 *
 * The different ways buffers are allocated.
 */
typedef enum {
  FAKE_SRC_DATA_ALLOCATE = 1,
  FAKE_SRC_DATA_SUBBUFFER
} GstFakeSrcDataType;

/**
 * GstFakeSrcSizeType:
 * @FAKE_SRC_SIZETYPE_EMPTY: create empty buffers
 * @FAKE_SRC_SIZETYPE_FIXED: fixed buffer size (sizemax sized)
 * @FAKE_SRC_SIZETYPE_RANDOM: random buffer size (sizemin <= size <= sizemax)
 *
 * The different size of the allocated buffers.
 */
typedef enum {
  FAKE_SRC_SIZETYPE_EMPTY = 1,
  FAKE_SRC_SIZETYPE_FIXED,
  FAKE_SRC_SIZETYPE_RANDOM
} GstFakeSrcSizeType;

/**
 * GstFakeSrcFillType:
 * @FAKE_SRC_FILLTYPE_NOTHING: do not fill buffers 
 * @FAKE_SRC_FILLTYPE_ZERO: fill buffers with 0
 * @FAKE_SRC_FILLTYPE_RANDOM: fill buffers with random bytes
 * @FAKE_SRC_FILLTYPE_PATTERN: fill buffers with a pattern
 * @FAKE_SRC_FILLTYPE_PATTERN_CONT: fill buffers with a continuous pattern
 *
 * The different ways of filling the buffers.
 */
typedef enum {
  FAKE_SRC_FILLTYPE_NOTHING = 1,
  FAKE_SRC_FILLTYPE_ZERO,
  FAKE_SRC_FILLTYPE_RANDOM,
  FAKE_SRC_FILLTYPE_PATTERN,
  FAKE_SRC_FILLTYPE_PATTERN_CONT
} GstFakeSrcFillType;

#define GST_TYPE_FAKE_SRC \
  (gst_fake_src_get_type())
#define GST_FAKE_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FAKE_SRC,GstFakeSrc))
#define GST_FAKE_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FAKE_SRC,GstFakeSrcClass))
#define GST_IS_FAKE_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FAKE_SRC))
#define GST_IS_FAKE_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FAKE_SRC))

typedef struct _GstFakeSrc GstFakeSrc;
typedef struct _GstFakeSrcClass GstFakeSrcClass;

/**
 * GstFakeSrc:
 *
 * Opaque #GstFakeSrc data structure.
 */
struct _GstFakeSrc {
  GstBaseSrc     element;

  /*< private >*/
  gboolean	 has_loop;
  gboolean	 has_getrange;

  GstFakeSrcOutputType output;
  GstFakeSrcDataType   data;
  GstFakeSrcSizeType   sizetype;
  GstFakeSrcFillType   filltype;

  guint		sizemin;
  guint		sizemax;
  GstBuffer	*parent;
  guint		parentsize;
  guint		parentoffset;
  guint8	 pattern_byte;
  gchar		*pattern;
  GList		*patternlist;
  gint		 datarate;
  gboolean	 sync;
  GstClock	*clock;

  gboolean	 silent;
  gboolean	 signal_handoffs;
  gboolean	 dump;
  gboolean	 can_activate_pull;
  GstFormat      format;

  guint64        bytes_sent;

  gchar		*last_message;
};

struct _GstFakeSrcClass {
  GstBaseSrcClass parent_class;

  /*< public >*/
  /* signals */
  void (*handoff) (GstElement *element, GstBuffer *buf, GstPad *pad);
};

G_GNUC_INTERNAL GType gst_fake_src_get_type (void);

G_END_DECLS

#endif /* __GST_FAKE_SRC_H__ */
