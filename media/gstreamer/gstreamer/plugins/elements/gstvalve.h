/* GStreamer valve element
 *
 *  Copyright 2007 Collabora Ltd, 
 *  Copyright 2007 Nokia Corporation
 *   @author: Olivier Crete <olivier.crete@collabora.co.uk>
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
 *
 */

#ifndef __GST_VALVE_H__
#define __GST_VALVE_H__

#include <gst/gst.h>

G_BEGIN_DECLS
/* #define's don't like whitespacey bits */
#define GST_TYPE_VALVE \
  (gst_valve_get_type())
#define GST_VALVE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), \
  GST_TYPE_VALVE,GstValve))
#define GST_VALVE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), \
  GST_TYPE_VALVE,GstValveClass))
#define GST_IS_VALVE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VALVE))
#define GST_IS_VALVE_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VALVE))

typedef struct _GstValve GstValve;
typedef struct _GstValveClass GstValveClass;

/**
 * GstValve:
 *
 * The private valve structure
 */
struct _GstValve
{
  /*< private >*/
  GstElement parent;

  /* atomic boolean */
  volatile gint drop;

  /* Protected by the stream lock */
  gboolean discont;
  gboolean need_repush_sticky;

  GstPad *srcpad;
  GstPad *sinkpad;
};

struct _GstValveClass
{
  GstElementClass parent_class;
};

G_GNUC_INTERNAL GType gst_valve_get_type (void);

G_END_DECLS

#endif /* __GST_VALVE_H__ */
