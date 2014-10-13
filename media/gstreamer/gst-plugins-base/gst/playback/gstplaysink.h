/* GStreamer
 * Copyright (C) <2007> Wim Taymans <wim.taymans@gmail.com>
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

#ifndef __GST_PLAY_SINK_H__
#define __GST_PLAY_SINK_H__

#include <gst/gst.h>

#include "gstplay-enum.h"

G_BEGIN_DECLS

#define GST_TYPE_PLAY_SINK \
  (gst_play_sink_get_type())
#define GST_PLAY_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_PLAY_SINK, GstPlaySink))
#define GST_PLAY_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_PLAY_SINK, GstPlaySinkClass))
#define GST_IS_PLAY_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_PLAY_SINK))
#define GST_IS_PLAY_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_PLAY_SINK))
#define GST_PLAY_SINK_CAST(obj) \
  ((GstPlaySink*)(obj))

/**
 * GstPlaySinkType:
 * @GST_PLAY_SINK_TYPE_AUDIO: an audio pad
 * @GST_PLAY_SINK_TYPE_AUDIO_RAW: a raw audio pad. Deprecated.
 * @GST_PLAY_SINK_TYPE_VIDEO: a video pad
 * @GST_PLAY_SINK_TYPE_VIDEO_RAW: a raw video pad. Deprecated.
 * @GST_PLAY_SINK_TYPE_TEXT: a text pad
 * @GST_PLAY_SINK_TYPE_LAST: the last type
 * @GST_PLAY_SINK_TYPE_FLUSHING: a flushing pad, used when shutting down
 *
 * Types of pads that can be requested from the sinks.
 */
typedef enum {
  GST_PLAY_SINK_TYPE_AUDIO     = 0,
  GST_PLAY_SINK_TYPE_AUDIO_RAW = 1,
  GST_PLAY_SINK_TYPE_VIDEO     = 2,
  GST_PLAY_SINK_TYPE_VIDEO_RAW = 3,
  GST_PLAY_SINK_TYPE_TEXT      = 4,
  GST_PLAY_SINK_TYPE_LAST      = 5,

  /* this is a dummy pad */
  GST_PLAY_SINK_TYPE_FLUSHING  = 6
} GstPlaySinkType;

typedef struct _GstPlaySink GstPlaySink;
typedef struct _GstPlaySinkClass GstPlaySinkClass;

GType gst_play_sink_get_type (void);

GstPad *         gst_play_sink_request_pad    (GstPlaySink *playsink, GstPlaySinkType type);
void             gst_play_sink_release_pad    (GstPlaySink *playsink, GstPad *pad);
void             gst_play_sink_refresh_pad    (GstPlaySink *playsink, GstPad *pad, GstPlaySinkType type);

void             gst_play_sink_set_filter     (GstPlaySink * playsink, GstPlaySinkType type, GstElement * filter);
GstElement *     gst_play_sink_get_filter     (GstPlaySink * playsink, GstPlaySinkType type);

void             gst_play_sink_set_sink       (GstPlaySink * playsink, GstPlaySinkType type, GstElement * sink);
GstElement *     gst_play_sink_get_sink       (GstPlaySink * playsink, GstPlaySinkType type);

void             gst_play_sink_set_vis_plugin (GstPlaySink * playsink, GstElement * vis);
GstElement *     gst_play_sink_get_vis_plugin (GstPlaySink * playsink);

void             gst_play_sink_set_volume     (GstPlaySink *playsink, gdouble volume);
gdouble          gst_play_sink_get_volume     (GstPlaySink *playsink);

void             gst_play_sink_set_mute       (GstPlaySink *playsink, gboolean mute);
gboolean         gst_play_sink_get_mute       (GstPlaySink *playsink);

gboolean         gst_play_sink_set_flags      (GstPlaySink * playsink, GstPlayFlags flags);
GstPlayFlags     gst_play_sink_get_flags      (GstPlaySink * playsink);

void             gst_play_sink_set_font_desc  (GstPlaySink *playsink, const gchar * desc);
gchar *          gst_play_sink_get_font_desc  (GstPlaySink *playsink);
void             gst_play_sink_set_subtitle_encoding  (GstPlaySink *playsink, const gchar * encoding);
gchar *          gst_play_sink_get_subtitle_encoding  (GstPlaySink *playsink);

void             gst_play_sink_set_av_offset  (GstPlaySink *playsink, gint64 av_offset);
gint64           gst_play_sink_get_av_offset  (GstPlaySink *playsink);

GstSample *      gst_play_sink_get_last_sample (GstPlaySink * playsink);
GstSample *      gst_play_sink_convert_sample  (GstPlaySink * playsink, GstCaps * caps);

gboolean         gst_play_sink_reconfigure    (GstPlaySink * playsink);

gboolean         gst_play_sink_plugin_init    (GstPlugin * plugin);

G_END_DECLS

#endif /* __GST_PLAY_SINK_H__ */
