/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstidentity.h:
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


#ifndef __GST_IDENTITY_H__
#define __GST_IDENTITY_H__


#include <gst/gst.h>
#include <gst/base/gstbasetransform.h>

G_BEGIN_DECLS


#define GST_TYPE_IDENTITY \
  (gst_identity_get_type())
#define GST_IDENTITY(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_IDENTITY,GstIdentity))
#define GST_IDENTITY_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_IDENTITY,GstIdentityClass))
#define GST_IS_IDENTITY(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_IDENTITY))
#define GST_IS_IDENTITY_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_IDENTITY))

typedef struct _GstIdentity GstIdentity;
typedef struct _GstIdentityClass GstIdentityClass;

/**
 * GstIdentity:
 *
 * Opaque #GstIdentity data structure
 */
struct _GstIdentity {
  GstBaseTransform 	 element;

  /*< private >*/
  GstClockID     clock_id;
  gint 	 	 error_after;
  gfloat 	 drop_probability;
  gint		 datarate;
  guint 	 sleep_time;
  gboolean 	 silent;
  gboolean 	 dump;
  gboolean 	 sync;
  gboolean 	 check_imperfect_timestamp;
  gboolean 	 check_imperfect_offset;
  gboolean	 single_segment;
  GstClockTime   prev_timestamp;
  GstClockTime   prev_duration;
  guint64        prev_offset;
  guint64        prev_offset_end;
  gchar 	*last_message;
  guint64        offset;
  gboolean       signal_handoffs;
};

struct _GstIdentityClass {
  GstBaseTransformClass parent_class;

  /* signals */
  void (*handoff) (GstElement *element, GstBuffer *buf);
};

G_GNUC_INTERNAL GType gst_identity_get_type (void);

G_END_DECLS

#endif /* __GST_IDENTITY_H__ */
