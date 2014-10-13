/* GStreamer
 * (c) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
 * (c) 2006 Jan Schmidt <thaytan@noraisin.net>
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

/**
 * SECTION:element-autovideosink
 * @see_also: autoaudiosink, ximagesink, xvimagesink, sdlvideosink
 *
 * autovideosink is a video sink that automatically detects an appropriate
 * video sink to use.  It does so by scanning the registry for all elements
 * that have <quote>Sink</quote> and <quote>Video</quote> in the class field
 * of their element information, and also have a non-zero autoplugging rank.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 -v -m videotestsrc ! autovideosink
 * ]|
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstautovideosink.h"

#define DEFAULT_TS_OFFSET           0

/* Properties */
enum
{
  PROP_0,
  PROP_TS_OFFSET,
};

static void gst_auto_video_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_auto_video_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_auto_video_sink_configure (GstAutoDetect * autodetect,
    GstElement * kid);

G_DEFINE_TYPE (GstAutoVideoSink, gst_auto_video_sink, GST_TYPE_AUTO_DETECT);

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static void
gst_auto_video_sink_class_init (GstAutoVideoSinkClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *eklass = GST_ELEMENT_CLASS (klass);
  GstAutoDetectClass *aklass = GST_AUTO_DETECT_CLASS (klass);

  gobject_class->set_property = gst_auto_video_sink_set_property;
  gobject_class->get_property = gst_auto_video_sink_get_property;

  aklass->configure = gst_auto_video_sink_configure;

  g_object_class_install_property (gobject_class, PROP_TS_OFFSET,
      g_param_spec_int64 ("ts-offset", "TS Offset",
          "Timestamp offset in nanoseconds", G_MININT64, G_MAXINT64,
          DEFAULT_TS_OFFSET, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (eklass,
      gst_static_pad_template_get (&sink_template));
  gst_element_class_set_static_metadata (eklass, "Auto video sink",
      "Sink/Video",
      "Wrapper video sink for automatically detected video sink",
      "Jan Schmidt <thaytan@noraisin.net>");
}

static void
gst_auto_video_sink_init (GstAutoVideoSink * sink)
{
  GstAutoDetect *autodetect = GST_AUTO_DETECT (sink);

  autodetect->media_klass = "Video";
  autodetect->flag = GST_ELEMENT_FLAG_SINK;

  sink->ts_offset = DEFAULT_TS_OFFSET;
}

static void
gst_auto_video_sink_configure (GstAutoDetect * autodetect, GstElement * kid)
{
  GstAutoVideoSink *self = GST_AUTO_VIDEO_SINK (autodetect);

  g_object_set (G_OBJECT (kid), "ts-offset", self->ts_offset, NULL);
}

static void
gst_auto_video_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAutoVideoSink *sink = GST_AUTO_VIDEO_SINK (object);
  GstAutoDetect *autodetect = (GstAutoDetect *) sink;

  switch (prop_id) {
    case PROP_TS_OFFSET:
      sink->ts_offset = g_value_get_int64 (value);
      if (autodetect->kid)
        g_object_set_property (G_OBJECT (autodetect->kid), pspec->name, value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_auto_video_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstAutoVideoSink *sink = GST_AUTO_VIDEO_SINK (object);

  switch (prop_id) {
    case PROP_TS_OFFSET:
      g_value_set_int64 (value, sink->ts_offset);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}
