/* GStreamer
 * Copyright (C) 2008 Nokia Corporation. (contact <stefan.kost@nokia.com>)
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
 
#ifndef __GST_OUTPUT_SELECTOR_H__
#define __GST_OUTPUT_SELECTOR_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_OUTPUT_SELECTOR \
  (gst_output_selector_get_type())
#define GST_OUTPUT_SELECTOR(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_OUTPUT_SELECTOR, GstOutputSelector))
#define GST_OUTPUT_SELECTOR_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_OUTPUT_SELECTOR, GstOutputSelectorClass))
#define GST_IS_OUTPUT_SELECTOR(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_OUTPUT_SELECTOR))
#define GST_IS_OUTPUT_SELECTOR_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_OUTPUT_SELECTOR))

typedef struct _GstOutputSelector GstOutputSelector;
typedef struct _GstOutputSelectorClass GstOutputSelectorClass;

struct _GstOutputSelector {
  GstElement element;

  GstPad *sinkpad;

  GstPad *active_srcpad;
  GstPad *pending_srcpad;
  guint nb_srcpads;

  gint pad_negotiation_mode;

  GstSegment segment;

  /* resend latest buffer after switch */
  gboolean resend_latest;
  GstBuffer *latest_buffer;

};

struct _GstOutputSelectorClass {
  GstElementClass parent_class;
};

/**
 * GstOutputSelectorPadNegotiationMode:
 * @GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_NONE: don't propagate the input
 * stream.
 * @GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL: direct input stream to all
 * output pads.
 * @GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ACTIVE: direct input stream to the
 * currently active output pad as described by the #GstOutputSelector:active-pad
 * property.
 *
 * To what output pad the input stream should be directed.
 */
typedef enum
{
  GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_NONE,
  GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL,
  GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ACTIVE
} GstOutputSelectorPadNegotiationMode;

G_GNUC_INTERNAL GType gst_output_selector_get_type (void);

G_END_DECLS

#endif /* __GST_OUTPUT_SELECTOR_H__ */
