/* GStreamer
 *
 * Copyright (C) 2014 Samsung Electronics. All rights reserved.
 *   Author: Thiago Santos <ts.santos@sisa.samsung.com>
 *
 * gstflowcombiner.h: utility to combine multiple flow returns into a single one
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


#ifndef __GST_FLOW_COMBINER_H__
#define __GST_FLOW_COMBINER_H__

#include <glib.h>
#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_FLOW_COMBINER gst_flow_combiner_get_type()

/**
 * GstFlowCombiner:
 *
 * Opaque helper structure to aggregate flow returns.
 *
 * Since: 1.4
 */
typedef struct _GstFlowCombiner GstFlowCombiner;

GstFlowCombiner * gst_flow_combiner_new (void);

void              gst_flow_combiner_free (GstFlowCombiner * combiner);

GstFlowReturn     gst_flow_combiner_update_flow (GstFlowCombiner * combiner, GstFlowReturn fret);

void              gst_flow_combiner_add_pad    (GstFlowCombiner * combiner, GstPad * pad);

void              gst_flow_combiner_remove_pad (GstFlowCombiner * combiner, GstPad * pad);

GType             gst_flow_combiner_get_type (void);

G_END_DECLS

#endif /* __GST_FLOW_COMBINER_H__ */
