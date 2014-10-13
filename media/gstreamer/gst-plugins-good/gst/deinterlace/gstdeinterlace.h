/*
 * GStreamer
 * Copyright (C) 2005 Martin Eikermann <meiker@upb.de>
 * Copyright (C) 2008-2010 Sebastian Dröge <slomo@collabora.co.uk>
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

#ifndef __GST_DEINTERLACE_H__
#define __GST_DEINTERLACE_H__

#include <gst/gst.h>
#include <gst/video/video.h>
#include <gst/video/gstvideopool.h>
#include <gst/video/gstvideometa.h>

#include "gstdeinterlacemethod.h"

G_BEGIN_DECLS

#define GST_TYPE_DEINTERLACE \
  (gst_deinterlace_get_type())
#define GST_DEINTERLACE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_DEINTERLACE,GstDeinterlace))
#define GST_DEINTERLACE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_DEINTERLACE,GstDeinterlace))
#define GST_IS_DEINTERLACE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_DEINTERLACE))
#define GST_IS_DEINTERLACE_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_DEINTERLACE))

typedef struct _GstDeinterlace GstDeinterlace;
typedef struct _GstDeinterlaceClass GstDeinterlaceClass;

typedef enum
{
  GST_DEINTERLACE_TOMSMOCOMP,
  GST_DEINTERLACE_GREEDY_H,
  GST_DEINTERLACE_GREEDY_L,
  GST_DEINTERLACE_VFIR,
  GST_DEINTERLACE_LINEAR,
  GST_DEINTERLACE_LINEAR_BLEND,
  GST_DEINTERLACE_SCALER_BOB,
  GST_DEINTERLACE_WEAVE,
  GST_DEINTERLACE_WEAVE_TFF,
  GST_DEINTERLACE_WEAVE_BFF
} GstDeinterlaceMethods;

typedef enum
{
  GST_DEINTERLACE_ALL,         /* All (missing data is interp.) */
  GST_DEINTERLACE_TF,          /* Top Fields Only */
  GST_DEINTERLACE_BF           /* Bottom Fields Only */
} GstDeinterlaceFields;

typedef enum
{
  GST_DEINTERLACE_LAYOUT_AUTO,
  GST_DEINTERLACE_LAYOUT_TFF,
  GST_DEINTERLACE_LAYOUT_BFF
} GstDeinterlaceFieldLayout;

typedef enum {
  GST_DEINTERLACE_MODE_AUTO,
  GST_DEINTERLACE_MODE_INTERLACED,
  GST_DEINTERLACE_MODE_DISABLED
} GstDeinterlaceMode;

typedef enum
{
  GST_DEINTERLACE_LOCKING_NONE,
  GST_DEINTERLACE_LOCKING_AUTO,
  GST_DEINTERLACE_LOCKING_ACTIVE,
  GST_DEINTERLACE_LOCKING_PASSIVE,
} GstDeinterlaceLocking;

#define GST_DEINTERLACE_MAX_FIELD_HISTORY 10
#define GST_DEINTERLACE_MAX_BUFFER_STATE_HISTORY 50
/* check max field history is large enough */
#if GST_DEINTERLACE_MAX_FIELD_HISTORY < GST_DEINTERLACE_MAX_BUFFER_STATE_HISTORY * 3
#undef GST_DEINTERLACE_MAX_FIELD_HISTORY
#define GST_DEINTERLACE_MAX_FIELD_HISTORY (GST_DEINTERLACE_MAX_BUFFER_STATE_HISTORY * 3)
#endif

typedef struct _TelecinePattern TelecinePattern;
struct _TelecinePattern
{
  const gchar *nick;
  guint8 length;
  guint8 ratio_n, ratio_d;
  guint8 states[GST_DEINTERLACE_MAX_BUFFER_STATE_HISTORY];
};

typedef struct _GstDeinterlaceBufferState GstDeinterlaceBufferState;
struct _GstDeinterlaceBufferState
{
  GstClockTime timestamp;
  GstClockTime duration;
  guint8 state;
};

struct _GstDeinterlace
{
  GstElement parent;

  GstPad *srcpad, *sinkpad;

  /* <private> */
  GstDeinterlaceMode mode;

  GstDeinterlaceFieldLayout field_layout;

  GstDeinterlaceFields fields;

  /* current state (differs when flushing/inverse telecine using weave) */
  GstDeinterlaceMethods method_id;
  /* property value */
  GstDeinterlaceMethods user_set_method_id;
  GstDeinterlaceMethod *method;

  GstVideoInfo vinfo;
  GstBufferPool *pool;
  GstAllocator *allocator;
  GstAllocationParams params;

  gboolean passthrough;

  GstClockTime field_duration; /* Duration of one field */

  /* The most recent pictures 
     PictureHistory[0] is always the most recent.
     Pointers are NULL if the picture in question isn't valid, e.g. because
     the program just started or a picture was skipped.
   */
  GstDeinterlaceField field_history[GST_DEINTERLACE_MAX_FIELD_HISTORY];
  guint history_count;
  int cur_field_idx;

  /* Set to TRUE if we're in still frame mode,
     i.e. just forward all buffers
   */
  gboolean still_frame_mode;

  /* Last buffer that was pushed in */
  GstBuffer *last_buffer;

  /* Current segment */
  GstSegment segment;

  /* QoS stuff */
  gdouble proportion;
  GstClockTime earliest_time;
  gint64 processed;
  gint64 dropped;

  GstCaps *request_caps;

  gboolean reconfigure;
  GstDeinterlaceMode new_mode;
  GstDeinterlaceFields new_fields;

  GstDeinterlaceLocking locking;
  gint low_latency;
  gboolean drop_orphans;
  gboolean ignore_obscure;
  gboolean pattern_lock;
  gboolean pattern_refresh;
  GstDeinterlaceBufferState buf_states[GST_DEINTERLACE_MAX_BUFFER_STATE_HISTORY];
  gint state_count;
  gint pattern;
  guint8 pattern_phase;
  guint8 pattern_count;
  guint8 output_count;
  GstClockTime pattern_base_ts;
  GstClockTime pattern_buf_dur;

  gboolean need_more;
  gboolean have_eos;
};

struct _GstDeinterlaceClass
{
  GstElementClass parent_class;
};

GType gst_deinterlace_get_type (void);

G_END_DECLS

#endif /* __GST_DEINTERLACE_H__ */
