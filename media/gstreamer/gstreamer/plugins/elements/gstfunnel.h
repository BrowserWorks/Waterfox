/*
 * GStreamer Funnel element
 *
 * Copyright 2007 Collabora Ltd.
 *  @author: Olivier Crete <olivier.crete@collabora.co.uk>
 * Copyright 2007 Nokia Corp.
 *
 * gstfunnel.h: Simple Funnel element
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
 */


#ifndef __GST_FUNNEL_H__
#define __GST_FUNNEL_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_FUNNEL \
  (gst_funnel_get_type ())
#define GST_FUNNEL(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FUNNEL,GstFunnel))
#define GST_FUNNEL_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FUNNEL,GstFunnelClass))
#define GST_IS_FUNNEL(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FUNNEL))
#define GST_IS_FUNNEL_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FUNNEL))

typedef struct _GstFunnel          GstFunnel;
typedef struct _GstFunnelClass     GstFunnelClass;

/**
 * GstFunnel:
 *
 * Opaque #GstFunnel data structure.
 */
struct _GstFunnel {
  GstElement      element;

  /*< private >*/
  GstPad         *srcpad;

  GstPad *last_sinkpad;
};

struct _GstFunnelClass {
  GstElementClass parent_class;
};

G_GNUC_INTERNAL GType   gst_funnel_get_type        (void);

G_END_DECLS

#endif /* __GST_FUNNEL_H__ */
