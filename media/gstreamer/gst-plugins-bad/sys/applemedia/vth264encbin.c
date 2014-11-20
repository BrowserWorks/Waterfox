/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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
# include <config.h>
#endif

#include "vth264encbin.h"

#include <string.h>
#include <gst/video/video.h>

#define VT_H264_ENC_BIN_DEFAULT_BITRATE 768

GST_DEBUG_CATEGORY_STATIC (gst_vt_h264_enc_bin_debug);
#define GST_CAT_DEFAULT gst_vt_h264_enc_bin_debug

enum
{
  PROP_0,
  PROP_BITRATE
};

enum
{
  H264PARSE_OUTPUT_FORMAT_AVC_SAMPLE = 0,
  H264PARSE_OUTPUT_FORMAT_BYTE_STREAM = 1,
  H264PARSE_OUTPUT_FORMAT_INPUT = 2
};

static GstStaticPadTemplate vth264encbin_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (GST_VIDEO_CAPS_YUV ("NV12"))
    );

static GstStaticPadTemplate vth264encbin_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h264, stream-format = (string) byte-stream"));

#define TAA_VT_H264_ENC_BIN_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_VT_H264_ENC_BIN, \
                                 GstVTH264EncBinPrivate))

struct _GstVTH264EncBinPrivate
{
  GstElement *encoder;
  GstElement *parser;
};

GST_BOILERPLATE (GstVTH264EncBin, gst_vt_h264_enc_bin, GstBin, GST_TYPE_BIN);

static void
gst_vt_h264_enc_bin_base_init (gpointer gclass)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (gclass);

  gst_element_class_set_metadata (element_class,
      "VTH264EncBin",
      "Encoder/Video",
      "VideoToolbox H.264 encoder bin",
      "Ole André Vadla Ravnås <oleavr@soundrop.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&vth264encbin_sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&vth264encbin_src_template));
}

static void
gst_vt_h264_enc_bin_init (GstVTH264EncBin * self, GstVTH264EncBinClass * gclass)
{
  GstVTH264EncBinPrivate *priv;
  GstPad *encoder_sinkpad, *parser_srcpad, *ghost_pad;

  self->priv = priv = TAA_VT_H264_ENC_BIN_GET_PRIVATE (self);

  priv->encoder = gst_element_factory_make ("vtenc_h264", "encoder");
  priv->parser = gst_element_factory_make ("h264parse", "parser");
  gst_bin_add_many (GST_BIN_CAST (self), priv->encoder, priv->parser, NULL);
  gst_element_link (priv->encoder, priv->parser);

  encoder_sinkpad = gst_element_get_static_pad (priv->encoder, "sink");
  ghost_pad = gst_ghost_pad_new_from_template ("sink", encoder_sinkpad,
      gst_static_pad_template_get (&vth264encbin_sink_template));
  gst_object_unref (encoder_sinkpad);
  gst_element_add_pad (GST_ELEMENT_CAST (self), ghost_pad);

  parser_srcpad = gst_element_get_static_pad (priv->parser, "src");
  ghost_pad = gst_ghost_pad_new_from_template ("src", parser_srcpad,
      gst_static_pad_template_get (&vth264encbin_src_template));
  gst_object_unref (parser_srcpad);
  gst_element_add_pad (GST_ELEMENT_CAST (self), ghost_pad);

  g_object_set (priv->encoder, "usage", 6, NULL);

  g_object_set (priv->parser,
      "output-format", H264PARSE_OUTPUT_FORMAT_BYTE_STREAM,
      "split-packetized", TRUE, NULL);
}

static void
gst_vt_h264_enc_bin_get_property (GObject * obj, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstVTH264EncBin *self = GST_VT_H264_ENC_BIN_CAST (obj);

  switch (prop_id) {
    case PROP_BITRATE:
      g_object_get_property (G_OBJECT (self->priv->encoder),
          g_param_spec_get_name (pspec), value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (obj, prop_id, pspec);
      break;
  }
}

static void
gst_vt_h264_enc_bin_set_property (GObject * obj, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstVTH264EncBin *self = GST_VT_H264_ENC_BIN_CAST (obj);

  switch (prop_id) {
    case PROP_BITRATE:
      g_object_set_property (G_OBJECT (self->priv->encoder),
          g_param_spec_get_name (pspec), value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (obj, prop_id, pspec);
      break;
  }
}

static void
gst_vt_h264_enc_bin_class_init (GstVTH264EncBinClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->get_property = gst_vt_h264_enc_bin_get_property;
  gobject_class->set_property = gst_vt_h264_enc_bin_set_property;

  g_type_class_add_private (klass, sizeof (GstVTH264EncBinPrivate));

  g_object_class_install_property (gobject_class, PROP_BITRATE,
      g_param_spec_uint ("bitrate", "Bitrate",
          "Target video bitrate in kbps",
          1, G_MAXUINT, VT_H264_ENC_BIN_DEFAULT_BITRATE,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));

  GST_DEBUG_CATEGORY_INIT (gst_vt_h264_enc_bin_debug,
      "vth264encbin", 0, "VideoToolbox H.264 encoder bin");
}
