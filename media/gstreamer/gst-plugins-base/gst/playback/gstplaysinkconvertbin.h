/* GStreamer
 * Copyright (C) <2011> Sebastian Dröge <sebastian.droege@collabora.co.uk>
 * Copyright (C) <2011> Vincent Penquerc'h <vincent.penquerch@collabora.co.uk>
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

#include <gst/gst.h>

#ifndef __GST_PLAY_SINK_CONVERT_BIN_H__
#define __GST_PLAY_SINK_CONVERT_BIN_H__

G_BEGIN_DECLS
#define GST_TYPE_PLAY_SINK_CONVERT_BIN \
  (gst_play_sink_convert_bin_get_type())
#define GST_PLAY_SINK_CONVERT_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_PLAY_SINK_CONVERT_BIN, GstPlaySinkConvertBin))
#define GST_PLAY_SINK_CONVERT_BIN_CAST(obj) \
  ((GstPlaySinkConvertBin *) obj)
#define GST_PLAY_SINK_CONVERT_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_PLAY_SINK_CONVERT_BIN, GstPlaySinkConvertBinClass))
#define GST_IS_PLAY_SINK_CONVERT_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_PLAY_SINK_CONVERT_BIN))
#define GST_IS_PLAY_SINK_CONVERT_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_PLAY_SINK_CONVERT_BIN))

#define GST_PLAY_SINK_CONVERT_BIN_LOCK(obj) G_STMT_START {                   \
    GST_LOG_OBJECT (obj,                                                \
                    "locking from thread %p",                           \
                    g_thread_self ());                                  \
    g_mutex_lock (&GST_PLAY_SINK_CONVERT_BIN_CAST(obj)->lock);                \
    GST_LOG_OBJECT (obj,                                                \
                    "locked from thread %p",                            \
                    g_thread_self ());                                  \
} G_STMT_END

#define GST_PLAY_SINK_CONVERT_BIN_UNLOCK(obj) G_STMT_START {                 \
    GST_LOG_OBJECT (obj,                                                \
                    "unlocking from thread %p",                         \
                    g_thread_self ());                                  \
    g_mutex_unlock (&GST_PLAY_SINK_CONVERT_BIN_CAST(obj)->lock);              \
} G_STMT_END

typedef struct _GstPlaySinkConvertBin GstPlaySinkConvertBin;
typedef struct _GstPlaySinkConvertBinClass GstPlaySinkConvertBinClass;

struct _GstPlaySinkConvertBin
{
  GstBin parent;

  /* < private > */
  GMutex lock;

  GstPad *sinkpad, *sink_proxypad;
  guint sink_proxypad_block_id;

  GstPad *srcpad;

  gboolean raw;
  GList *conversion_elements;
  GstElement *identity;

  GstCaps *converter_caps;

  /* configuration for derived classes */
  gboolean audio;
};

struct _GstPlaySinkConvertBinClass
{
  GstBinClass parent;
};

GType gst_play_sink_convert_bin_get_type (void);
GstElement *
gst_play_sink_convert_bin_add_conversion_element_factory (GstPlaySinkConvertBin *self,
    const char *factory, const char *name);
void
gst_play_sink_convert_bin_add_conversion_element (GstPlaySinkConvertBin *self,
    GstElement *el);
void
gst_play_sink_convert_bin_cache_converter_caps (GstPlaySinkConvertBin * self);
void
gst_play_sink_convert_bin_remove_elements (GstPlaySinkConvertBin * self);
void
gst_play_sink_convert_bin_add_identity (GstPlaySinkConvertBin * self);

G_END_DECLS
#endif /* __GST_PLAY_SINK_CONVERT_BIN_H__ */
