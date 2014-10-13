/* GStreamer PNG Parser
 * Copyright (C) <2013> Collabora Ltd
 *  @author Olivier Crete <olivier.crete@collabora.com>
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

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstpngparse.h"

#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>

#define PNG_SIGNATURE G_GUINT64_CONSTANT (0x89504E470D0A1A0A)

GST_DEBUG_CATEGORY (png_parse_debug);
#define GST_CAT_DEFAULT png_parse_debug

static GstStaticPadTemplate srctemplate =
GST_STATIC_PAD_TEMPLATE ("src", GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("image/png, width = (int)[1, MAX], height = (int)[1, MAX],"
        "parsed = (boolean) true")
    );

static GstStaticPadTemplate sinktemplate =
GST_STATIC_PAD_TEMPLATE ("sink", GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("image/png")
    );

#define parent_class gst_png_parse_parent_class
G_DEFINE_TYPE (GstPngParse, gst_png_parse, GST_TYPE_BASE_PARSE);

static gboolean gst_png_parse_start (GstBaseParse * parse);
static GstFlowReturn gst_png_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_png_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

static void
gst_png_parse_class_init (GstPngParseClass * klass)
{
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (png_parse_debug, "pngparse", 0, "png parser");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));
  gst_element_class_set_static_metadata (gstelement_class, "PNG parser",
      "Codec/Parser/Video/Image",
      "Parses PNG files", "Olivier Crete <olivier.crete@collabora.com>");

  /* Override BaseParse vfuncs */
  parse_class->start = GST_DEBUG_FUNCPTR (gst_png_parse_start);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_png_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_png_parse_pre_push_frame);
}

static void
gst_png_parse_init (GstPngParse * pngparse)
{
}

static gboolean
gst_png_parse_start (GstBaseParse * parse)
{
  GstPngParse *pngparse = GST_PNG_PARSE (parse);

  GST_DEBUG_OBJECT (pngparse, "start");

  /* the start code and at least 2 empty frames (IHDR and IEND) */
  gst_base_parse_set_min_frame_size (parse, 8 + 12 + 12);

  pngparse->width = 0;
  pngparse->height = 0;

  pngparse->sent_codec_tag = FALSE;

  return TRUE;
}


static GstFlowReturn
gst_png_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstPngParse *pngparse = GST_PNG_PARSE (parse);
  GstMapInfo map;
  GstByteReader reader;
  GstFlowReturn ret = GST_FLOW_OK;
  guint64 signature;
  guint width = 0, height = 0;

  gst_buffer_map (frame->buffer, &map, GST_MAP_READ);
  gst_byte_reader_init (&reader, map.data, map.size);

  if (!gst_byte_reader_peek_uint64_be (&reader, &signature))
    goto beach;

  if (signature != PNG_SIGNATURE) {
    for (;;) {
      guint offset;

      offset = gst_byte_reader_masked_scan_uint32 (&reader, 0xffffffff,
          0x89504E47, 0, gst_byte_reader_get_remaining (&reader));

      if (offset == -1) {
        *skipsize = gst_byte_reader_get_remaining (&reader) - 4;
        goto beach;
      }

      gst_byte_reader_skip (&reader, offset);

      if (!gst_byte_reader_peek_uint64_be (&reader, &signature))
        goto beach;

      if (signature == PNG_SIGNATURE) {
        /* We're skipping, go out, we'll be back */
        *skipsize = gst_byte_reader_get_pos (&reader);
        goto beach;
      }
      gst_byte_reader_skip (&reader, 4);
    }
  }

  gst_byte_reader_skip (&reader, 8);

  for (;;) {
    guint32 length;
    guint32 code;

    if (!gst_byte_reader_get_uint32_be (&reader, &length))
      goto beach;
    if (!gst_byte_reader_get_uint32_le (&reader, &code))
      goto beach;

    if (code == GST_MAKE_FOURCC ('I', 'H', 'D', 'R')) {
      if (!gst_byte_reader_get_uint32_be (&reader, &width))
        goto beach;
      if (!gst_byte_reader_get_uint32_be (&reader, &height))
        goto beach;
      length -= 8;
    }

    if (!gst_byte_reader_skip (&reader, length + 4))
      goto beach;

    if (code == GST_MAKE_FOURCC ('I', 'E', 'N', 'D')) {
      if (pngparse->width != width || pngparse->height != height) {
        GstCaps *caps, *sink_caps;

        pngparse->height = height;
        pngparse->width = width;

        caps = gst_caps_new_simple ("image/png",
            "width", G_TYPE_INT, width, "height", G_TYPE_INT, height, NULL);

        sink_caps =
            gst_pad_get_current_caps (GST_BASE_PARSE_SINK_PAD (pngparse));

        if (sink_caps) {
          GstStructure *st;
          gint fr_num, fr_denom;

          st = gst_caps_get_structure (sink_caps, 0);
          if (st
              && gst_structure_get_fraction (st, "framerate", &fr_num,
                  &fr_denom)) {
            gst_caps_set_simple (caps,
                "framerate", GST_TYPE_FRACTION, fr_num, fr_denom, NULL);
          } else {
            GST_WARNING_OBJECT (pngparse, "No framerate set");
          }
        }

        if (!gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (parse), caps))
          ret = GST_FLOW_NOT_NEGOTIATED;

        gst_caps_unref (caps);

        if (ret != GST_FLOW_OK)
          goto beach;
      }


      gst_buffer_unmap (frame->buffer, &map);
      return gst_base_parse_finish_frame (parse, frame,
          gst_byte_reader_get_pos (&reader));
    }
  }

beach:

  gst_buffer_unmap (frame->buffer, &map);

  return ret;
}

static GstFlowReturn
gst_png_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstPngParse *pngparse = GST_PNG_PARSE (parse);

  if (!pngparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_VIDEO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (pngparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    pngparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
