/* GStreamer
 * Copyright (C) 2009 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#ifndef __GST_SUBTITLE_OVERLAY_H__
#define __GST_SUBTITLE_OVERLAY_H__

#include <gst/gst.h>

G_BEGIN_DECLS
#define GST_TYPE_SUBTITLE_OVERLAY \
  (gst_subtitle_overlay_get_type())
#define GST_SUBTITLE_OVERLAY(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_SUBTITLE_OVERLAY, GstSubtitleOverlay))
#define GST_SUBTITLE_OVERLAY_CAST(obj) \
  ((GstSubtitleOverlay *) obj)
#define GST_SUBTITLE_OVERLAY_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_SUBTITLE_OVERLAY, GstSubtitleOverlayClass))
#define GST_IS_SUBTITLE_OVERLAY(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_SUBTITLE_OVERLAY))
#define GST_IS_SUBTITLE_OVERLAY_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_SUBTITLE_OVERLAY))

#define GST_SUBTITLE_OVERLAY_LOCK(obj) G_STMT_START {                   \
    GST_LOG_OBJECT (obj,                                                \
                    "locking from thread %p",                           \
                    g_thread_self ());                                  \
    g_mutex_lock (&GST_SUBTITLE_OVERLAY_CAST(obj)->lock);               \
    GST_LOG_OBJECT (obj,                                                \
                    "locked from thread %p",                            \
                    g_thread_self ());                                  \
} G_STMT_END

#define GST_SUBTITLE_OVERLAY_UNLOCK(obj) G_STMT_START {                 \
    GST_LOG_OBJECT (obj,                                                \
                    "unlocking from thread %p",                         \
                    g_thread_self ());                                  \
    g_mutex_unlock (&GST_SUBTITLE_OVERLAY_CAST(obj)->lock);             \
} G_STMT_END

typedef struct _GstSubtitleOverlay GstSubtitleOverlay;
typedef struct _GstSubtitleOverlayClass GstSubtitleOverlayClass;

struct _GstSubtitleOverlay
{
  GstBin parent;

  gboolean silent;
  gchar *font_desc;
  gchar *encoding;

  /* < private > */
  gboolean do_async;

  GstPad *srcpad;
  gboolean downstream_chain_error;

  GstPad *video_sinkpad;
  GstPad *video_block_pad;
  gulong video_block_id;
  gboolean video_sink_blocked;
  gint fps_n, fps_d;

  GstPad *subtitle_sinkpad;
  GstPad *subtitle_block_pad;
  gulong subtitle_block_id;
  gboolean subtitle_sink_blocked;
  gboolean subtitle_flush;
  gboolean subtitle_error;

  GMutex factories_lock;
  GList *factories;
  guint32 factories_cookie;
  GstCaps *factory_caps;

  GMutex lock;
  GstCaps *subcaps;

  GstElement *passthrough_identity;

  GstElement *pre_colorspace;
  GstElement *post_colorspace;

  GstElement *parser;
  GstElement *overlay;

  GstElement *renderer;

  const gchar *silent_property;
  gboolean silent_property_invert;
};

struct _GstSubtitleOverlayClass
{
  GstBinClass parent;
};

GType gst_subtitle_overlay_get_type (void);
gboolean gst_subtitle_overlay_plugin_init (GstPlugin * plugin);

GstCaps *gst_subtitle_overlay_create_factory_caps (void);

G_END_DECLS
#endif /* __GST_SUBTITLE_OVERLAY_H__ */
