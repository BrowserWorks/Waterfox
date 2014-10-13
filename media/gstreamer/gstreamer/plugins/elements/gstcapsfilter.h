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


#ifndef __GST_CAPSFILTER_H__
#define __GST_CAPSFILTER_H__


#include <gst/gst.h>
#include <gst/base/gstbasetransform.h>

G_BEGIN_DECLS

#define GST_TYPE_CAPSFILTER \
  (gst_capsfilter_get_type())
#define GST_CAPSFILTER(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_CAPSFILTER,GstCapsFilter))
#define GST_CAPSFILTER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_CAPSFILTER,GstCapsFilterClass))
#define GST_IS_CAPSFILTER(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_CAPSFILTER))
#define GST_IS_CAPSFILTER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_CAPSFILTER))

typedef struct _GstCapsFilter GstCapsFilter;
typedef struct _GstCapsFilterClass GstCapsFilterClass;

/**
 * GstCapsFilter:
 *
 * The opaque #GstCapsFilter data structure.
 */
struct _GstCapsFilter {
  GstBaseTransform trans;

  GstCaps *filter_caps;
  GList *pending_events;
};

struct _GstCapsFilterClass {
  GstBaseTransformClass trans_class;
};

G_GNUC_INTERNAL GType gst_capsfilter_get_type (void);

G_END_DECLS

#endif /* __GST_CAPSFILTER_H__ */

