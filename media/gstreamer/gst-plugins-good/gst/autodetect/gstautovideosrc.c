/* GStreamer
 * (c) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
 * (c) 2006 Jan Schmidt <thaytan@noraisin.net>
 * (c) 2008 Stefan Kost <ensonic@users.sf.net>
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
 * SECTION:element-autovideosrc
 * @see_also: autoaudiosrc, v4l2src, v4lsrc
 *
 * autovideosrc is a video src that automatically detects an appropriate
 * video source to use.  It does so by scanning the registry for all elements
 * that have <quote>Source</quote> and <quote>Video</quote> in the class field
 * of their element information, and also have a non-zero autoplugging rank.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 -v -m autovideosrc ! xvimagesink
 * ]|
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstautovideosrc.h"

G_DEFINE_TYPE (GstAutoVideoSrc, gst_auto_video_src, GST_TYPE_AUTO_DETECT);

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstElement *
gst_auto_video_src_create_fake_element (GstAutoDetect * autodetect)
{
  GstElement *fake;

  fake = gst_element_factory_make ("videotestsrc", "fake-auto-video-src");
  if (fake != NULL) {
    g_object_set (fake, "is-live", TRUE, NULL);
  } else {
    GST_ELEMENT_ERROR (autodetect, RESOURCE, NOT_FOUND,
        ("Failed to find usable video source element."),
        ("Failed to find a usable video source and couldn't create a video"
            "testsrc as fallback either, check your GStreamer installation."));
    /* This will error out with not-negotiated.. */
    fake = gst_element_factory_make ("fakesrc", "fake-auto-video-src");
  }
  return fake;
}

static void
gst_auto_video_src_class_init (GstAutoVideoSrcClass * klass)
{
  GstAutoDetectClass *autoclass = GST_AUTO_DETECT_CLASS (klass);
  GstElementClass *eklass = GST_ELEMENT_CLASS (klass);

  gst_element_class_add_pad_template (eklass,
      gst_static_pad_template_get (&src_template));
  gst_element_class_set_static_metadata (eklass, "Auto video source",
      "Source/Video",
      "Wrapper video source for automatically detected video source",
      "Jan Schmidt <thaytan@noraisin.net>, "
      "Stefan Kost <ensonic@users.sf.net>");

  autoclass->create_fake_element = gst_auto_video_src_create_fake_element;
}

static void
gst_auto_video_src_init (GstAutoVideoSrc * src)
{
  GstAutoDetect *autodetect = GST_AUTO_DETECT (src);

  autodetect->media_klass = "Video";
  autodetect->flag = GST_ELEMENT_FLAG_SOURCE;
}
