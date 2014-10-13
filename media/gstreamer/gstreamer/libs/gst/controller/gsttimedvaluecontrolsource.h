/* GStreamer
 *
 * Copyright (C) 2007 Sebastian Dröge <slomo@circular-chaos.org>
 *               2011 Stefan Sauer <ensonic@users.sf.net>
 *
 * gsttimedvaluecontrolsource.h: Base class for timeed value based control
 *                               sources
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

#ifndef __GST_TIMED_VALUE_CONTROL_SOURCE_H__
#define __GST_TIMED_VALUE_CONTROL_SOURCE_H__

#include <glib-object.h>
#include <gst/gst.h>

#include <gst/gstcontrolsource.h>

G_BEGIN_DECLS

#define GST_TYPE_TIMED_VALUE_CONTROL_SOURCE \
  (gst_timed_value_control_source_get_type ())
#define GST_TIMED_VALUE_CONTROL_SOURCE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_TIMED_VALUE_CONTROL_SOURCE, GstTimedValueControlSource))
#define GST_TIMED_VALUE_CONTROL_SOURCE_CLASS(vtable) \
  (G_TYPE_CHECK_CLASS_CAST ((vtable), GST_TYPE_TIMED_VALUE_CONTROL_SOURCE, GstTimedValueControlSourceClass))
#define GST_IS_TIMED_VALUE_CONTROL_SOURCE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_TIMED_VALUE_CONTROL_SOURCE))
#define GST_IS_TIMED_VALUE_CONTROL_SOURCE_CLASS(vtable) \
  (G_TYPE_CHECK_CLASS_TYPE ((vtable), GST_TYPE_TIMED_VALUE_CONTROL_SOURCE))
#define GST_TIMED_VALUE_CONTROL_SOURCE_GET_CLASS(inst) \
  (G_TYPE_INSTANCE_GET_CLASS ((inst), GST_TYPE_TIMED_VALUE_CONTROL_SOURCE, GstTimedValueControlSourceClass))

typedef struct _GstTimedValueControlSource GstTimedValueControlSource;
typedef struct _GstTimedValueControlSourceClass GstTimedValueControlSourceClass;
typedef struct _GstTimedValueControlSourcePrivate GstTimedValueControlSourcePrivate;
typedef struct _GstControlPoint GstControlPoint;

/**
 * GstControlPoint:
 *
 * a internal structure for value+time and various temporary
 * values used for interpolation. This "inherits" from
 * GstTimedValue.
 */
struct _GstControlPoint
{
  /* fields from GstTimedValue. DO NOT CHANGE! */
  GstClockTime timestamp;       /* timestamp of the value change */
  gdouble value;                /* the new value */

  /* internal fields */

  /* Caches for the interpolators */
  /* FIXME: we should not have this here already ... */
  union {
    struct {
      gdouble h;
      gdouble z;
    } cubic;
  } cache;

};

/**
 * GstTimedValueControlSource:
 *
 * The instance structure of #GstControlSource.
 */
struct _GstTimedValueControlSource {
  GstControlSource parent;

  /*< protected >*/
  GMutex lock;

  GSequence *values;            /* List of GstControlPoint */
  gint nvalues;                 /* Number of control points */
  gboolean valid_cache;

  /*< private >*/
  GstTimedValueControlSourcePrivate *priv;
  gpointer _gst_reserved[GST_PADDING];
};

struct _GstTimedValueControlSourceClass {
  GstControlSourceClass parent_class;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

#define GST_TIMED_VALUE_CONTROL_SOURCE_LOCK(o) \
  g_mutex_lock(&((GstTimedValueControlSource *)o)->lock)
#define GST_TIMED_VALUE_CONTROL_SOURCE_UNLOCK(o) \
  g_mutex_unlock(&((GstTimedValueControlSource *)o)->lock)

GType gst_timed_value_control_source_get_type (void);

/* Functions */

GSequenceIter * gst_timed_value_control_source_find_control_point_iter (
                                                               GstTimedValueControlSource * self, 
                                                               GstClockTime timestamp);

gboolean        gst_timed_value_control_source_set            (GstTimedValueControlSource * self,
                                                               GstClockTime timestamp,
                                                               const gdouble value);
gboolean        gst_timed_value_control_source_set_from_list  (GstTimedValueControlSource * self,
                                                               const GSList * timedvalues);
gboolean        gst_timed_value_control_source_unset          (GstTimedValueControlSource * self,
                                                               GstClockTime timestamp);
void            gst_timed_value_control_source_unset_all      (GstTimedValueControlSource *self);
GList *         gst_timed_value_control_source_get_all        (GstTimedValueControlSource * self);
gint            gst_timed_value_control_source_get_count      (GstTimedValueControlSource * self);
void            gst_timed_value_control_invalidate_cache      (GstTimedValueControlSource * self);

G_END_DECLS

#endif /* __GST_TIMED_VALUE_CONTROL_SOURCE_H__ */
