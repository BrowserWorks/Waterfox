/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gsttee.h: Header for GstTee element
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


#ifndef __GST_TEE_H__
#define __GST_TEE_H__

#include <gst/gst.h>

G_BEGIN_DECLS


#define GST_TYPE_TEE \
  (gst_tee_get_type())
#define GST_TEE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TEE,GstTee))
#define GST_TEE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TEE,GstTeeClass))
#define GST_IS_TEE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TEE))
#define GST_IS_TEE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TEE))
#define GST_TEE_CAST(obj) ((GstTee*) obj)

typedef struct _GstTee 		GstTee;
typedef struct _GstTeeClass 	GstTeeClass;

/**
 * GstTeePullMode:
 * @GST_TEE_PULL_MODE_NEVER: Never activate in pull mode.
 * @GST_TEE_PULL_MODE_SINGLE: Only one src pad can be active in pull mode.
 *
 * The different ways that tee can behave in pull mode. @TEE_PULL_MODE_NEVER
 * disables pull mode.
 */
typedef enum {
  GST_TEE_PULL_MODE_NEVER,
  GST_TEE_PULL_MODE_SINGLE,
} GstTeePullMode;

/**
 * GstTee:
 *
 * Opaque #GstTee data structure.
 */
struct _GstTee {
  GstElement      element;

  /*< private >*/
  GstPad         *sinkpad;
  GstPad         *allocpad;

  GHashTable     *pad_indexes;
  guint           next_pad_index;

  gboolean        has_chain;
  gboolean        silent;
  gchar          *last_message;

  GstPadMode      sink_mode;
  GstTeePullMode  pull_mode;
  GstPad         *pull_pad;
};

struct _GstTeeClass {
  GstElementClass parent_class;
};

G_GNUC_INTERNAL GType	gst_tee_get_type	(void);

G_END_DECLS

#endif /* __GST_TEE_H__ */
