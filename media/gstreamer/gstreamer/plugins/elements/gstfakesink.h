/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstfakesink.h:
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


#ifndef __GST_FAKE_SINK_H__
#define __GST_FAKE_SINK_H__

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>

G_BEGIN_DECLS


#define GST_TYPE_FAKE_SINK \
  (gst_fake_sink_get_type())
#define GST_FAKE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FAKE_SINK,GstFakeSink))
#define GST_FAKE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FAKE_SINK,GstFakeSinkClass))
#define GST_IS_FAKE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FAKE_SINK))
#define GST_IS_FAKE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FAKE_SINK))
#define GST_FAKE_SINK_CAST(obj) ((GstFakeSink *)obj)

/**
 * GstFakeSinkStateError:
 * @FAKE_SINK_STATE_ERROR_NONE: no error
 * @FAKE_SINK_STATE_ERROR_NULL_READY: cause the NULL to READY state change to fail
 * @FAKE_SINK_STATE_ERROR_READY_PAUSED: cause the READY to PAUSED state change to fail:
 * @FAKE_SINK_STATE_ERROR_PAUSED_PLAYING: cause the PAUSED to PLAYING state change to fail:
 * @FAKE_SINK_STATE_ERROR_PLAYING_PAUSED: cause the PLAYING to PAUSED state change to fail:
 * @FAKE_SINK_STATE_ERROR_PAUSED_READY: cause the PAUSED to READY state change to fail:
 * @FAKE_SINK_STATE_ERROR_READY_NULL: cause the READY to NULL state change to fail:
 *
 * Possible state change errors for the state-error property.
 */
typedef enum {
  FAKE_SINK_STATE_ERROR_NONE = 0,
  FAKE_SINK_STATE_ERROR_NULL_READY,
  FAKE_SINK_STATE_ERROR_READY_PAUSED,
  FAKE_SINK_STATE_ERROR_PAUSED_PLAYING,
  FAKE_SINK_STATE_ERROR_PLAYING_PAUSED,
  FAKE_SINK_STATE_ERROR_PAUSED_READY,
  FAKE_SINK_STATE_ERROR_READY_NULL
} GstFakeSinkStateError;

typedef struct _GstFakeSink GstFakeSink;
typedef struct _GstFakeSinkClass GstFakeSinkClass;

/**
 * GstFakeSink:
 *
 * The opaque #GstFakeSink data structure.
 */
struct _GstFakeSink {
  GstBaseSink		element;

  gboolean		silent;
  gboolean		dump;
  gboolean		signal_handoffs;
  GstFakeSinkStateError state_error;
  gchar			*last_message;
  gint                  num_buffers;
  gint                  num_buffers_left;
};

struct _GstFakeSinkClass {
  GstBaseSinkClass parent_class;

  /* signals */
  void (*handoff) (GstElement *element, GstBuffer *buf, GstPad *pad);
  void (*preroll_handoff) (GstElement *element, GstBuffer *buf, GstPad *pad);
};

G_GNUC_INTERNAL GType gst_fake_sink_get_type (void);

G_END_DECLS

#endif /* __GST_FAKE_SINK_H__ */
