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

#include "vth264decbin.h"

#include <string.h>
#include <gst/video/video.h>

#define VT_H264_DEC_BIN_ERROR_STATE_DEFAULT FALSE

GST_DEBUG_CATEGORY_STATIC (gst_vt_h264_dec_bin_debug);
#define GST_CAT_DEFAULT gst_vt_h264_dec_bin_debug

enum
{
  PROP_0,
  PROP_ERROR_STATE,
  PROP_HAPPY
};

enum
{
  H264PARSE_OUTPUT_FORMAT_AVC_SAMPLE = 0,
  H264PARSE_OUTPUT_FORMAT_BYTE_STREAM = 1,
  H264PARSE_OUTPUT_FORMAT_INPUT = 2
};

static GstStaticPadTemplate vth264decbin_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h264, "
        "stream-format = (string) { byte-stream, avc }")
    );

static GstStaticPadTemplate vth264decbin_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (GST_VIDEO_CAPS_YUV ("NV12"))
    );

#define TAA_VT_H264_DEC_BIN_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_VT_H264_DEC_BIN, \
                                 GstVTH264DecBinPrivate))

struct _GstVTH264DecBinPrivate
{
  GstElement *parser;
  GstPad *parser_sinkpad;

  GstElement *decoder;
  GstPad *decoder_srcpad;

  gboolean error_state;

  gboolean seen_output;
  GstClockTime prev_input_ts;

  gulong output_probe;
};

GST_BOILERPLATE (GstVTH264DecBin, gst_vt_h264_dec_bin, GstBin, GST_TYPE_BIN);

static gboolean gst_vt_h264_dec_bin_on_output (GstPad * pad,
    GstMiniObject * mini_obj, gpointer user_data);

static void
gst_vt_h264_dec_bin_update_error_state (GstVTH264DecBin * self,
    gboolean error_state)
{
  GstVTH264DecBinPrivate *priv = self->priv;
  GObject *obj = (GObject *) self;

  GST_OBJECT_LOCK (self);
  priv->error_state = error_state;
  GST_OBJECT_UNLOCK (self);

  if (priv->output_probe == 0 && (error_state || !priv->seen_output)) {
    GST_DEBUG_OBJECT (self, "attaching buffer probe");
    priv->output_probe = gst_pad_add_buffer_probe (priv->decoder_srcpad,
        G_CALLBACK (gst_vt_h264_dec_bin_on_output), self);
  } else if (priv->output_probe != 0 && (!error_state && priv->seen_output)) {
    GST_DEBUG_OBJECT (self, "detaching buffer probe");
    gst_pad_remove_buffer_probe (priv->decoder_srcpad, priv->output_probe);
    priv->output_probe = 0;
  }

  g_object_notify (obj, "error-state");
  g_object_notify (obj, "happy");
}

static gboolean
gst_vt_h264_dec_bin_sink_setcaps (GstPad * pad, GstCaps * caps)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (GST_PAD_PARENT (pad));
  const gchar *format;
  gint output_format;
  gboolean access_unit;

  format = gst_structure_get_string (gst_caps_get_structure (caps, 0),
      "stream-format");
  if (format == NULL)
    goto no_stream_format;

  if (strcmp (format, "byte-stream") == 0) {
    output_format = H264PARSE_OUTPUT_FORMAT_AVC_SAMPLE;
    access_unit = TRUE;
  } else {
    output_format = H264PARSE_OUTPUT_FORMAT_INPUT;
    access_unit = FALSE;
  }

  g_object_set (self->priv->parser, "output-format", output_format,
      "access-unit", access_unit, NULL);

  return gst_pad_set_caps (GST_PAD_PEER (self->priv->parser_sinkpad), caps);

no_stream_format:
  return FALSE;
}

static gboolean
gst_vt_h264_dec_bin_sink_event (GstPad * pad, GstEvent * event)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (GST_PAD_PARENT (pad));
  GstVTH264DecBinPrivate *priv = self->priv;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_NEWSEGMENT:
      if (priv->seen_output) {
        GST_DEBUG_OBJECT (self, "error state ON because of packetloss");
        gst_vt_h264_dec_bin_update_error_state (self, TRUE);
      }
      break;
    case GST_EVENT_FLUSH_STOP:
      priv->seen_output = FALSE;
      priv->prev_input_ts = GST_CLOCK_TIME_NONE;
      GST_DEBUG_OBJECT (self, "error state OFF because of FLUSH_STOP");
      gst_vt_h264_dec_bin_update_error_state (self, FALSE);
      break;
    default:
      break;
  }

  return gst_pad_push_event (GST_PAD_PEER (priv->parser_sinkpad), event);
}

static GstFlowReturn
gst_vt_h264_dec_bin_sink_chain (GstPad * pad, GstBuffer * buffer)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (GST_PAD_PARENT (pad));
  GstVTH264DecBinPrivate *priv = self->priv;
  GstClockTime cur_ts;
  GstFlowReturn flow_ret;

  cur_ts = GST_BUFFER_TIMESTAMP (buffer);

  gst_vt_h264_dec_bin_update_error_state (self, priv->error_state);

  flow_ret = gst_pad_push (GST_PAD_PEER (priv->parser_sinkpad), buffer);

  if (!priv->seen_output && !priv->error_state &&
      GST_CLOCK_TIME_IS_VALID (priv->prev_input_ts)) {
    if (cur_ts != priv->prev_input_ts) {
      GST_DEBUG_OBJECT (self,
          "error state ON because of no output and detected timestamp gap");
      gst_vt_h264_dec_bin_update_error_state (self, TRUE);
    }
  }
  priv->prev_input_ts = cur_ts;

  return flow_ret;
}

static gboolean
gst_vt_h264_dec_bin_on_output (GstPad * pad, GstMiniObject * mini_obj,
    gpointer user_data)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (user_data);

  self->priv->seen_output = TRUE;

  GST_DEBUG_OBJECT (self, "error state OFF because we saw output");
  gst_vt_h264_dec_bin_update_error_state (self, FALSE);

  return TRUE;
}

static void
gst_vt_h264_dec_bin_base_init (gpointer gclass)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (gclass);

  gst_element_class_set_metadata (element_class,
      "VTH264DecBin",
      "Decoder/Video",
      "VideoToolbox H.264 decoder bin",
      "Ole André Vadla Ravnås <oleavr@soundrop.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&vth264decbin_sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&vth264decbin_src_template));
}

static void
gst_vt_h264_dec_bin_init (GstVTH264DecBin * self, GstVTH264DecBinClass * gclass)
{
  GstVTH264DecBinPrivate *priv;
  GstPad *ghost_pad;

  self->priv = priv = TAA_VT_H264_DEC_BIN_GET_PRIVATE (self);

  priv->parser = gst_element_factory_make ("h264parse", "parser");
  priv->decoder = gst_element_factory_make ("vtdec_h264", "decoder");
  gst_bin_add_many (GST_BIN_CAST (self), priv->parser, priv->decoder, NULL);
  gst_element_link (priv->parser, priv->decoder);

  priv->parser_sinkpad = gst_element_get_static_pad (priv->parser, "sink");
  ghost_pad = gst_ghost_pad_new_from_template ("sink", priv->parser_sinkpad,
      gst_static_pad_template_get (&vth264decbin_sink_template));
  gst_pad_set_setcaps_function (ghost_pad, gst_vt_h264_dec_bin_sink_setcaps);
  gst_pad_set_event_function (ghost_pad, gst_vt_h264_dec_bin_sink_event);
  gst_pad_set_chain_function (ghost_pad, gst_vt_h264_dec_bin_sink_chain);
  gst_element_add_pad (GST_ELEMENT_CAST (self), ghost_pad);

  priv->decoder_srcpad = gst_element_get_static_pad (priv->decoder, "src");
  ghost_pad = gst_ghost_pad_new_from_template ("src", priv->decoder_srcpad,
      gst_static_pad_template_get (&vth264decbin_src_template));
  gst_element_add_pad (GST_ELEMENT_CAST (self), ghost_pad);

  priv->seen_output = FALSE;
  priv->prev_input_ts = GST_CLOCK_TIME_NONE;
}

static void
gst_vt_h264_dec_bin_dispose (GObject * obj)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (obj);
  GstVTH264DecBinPrivate *priv = self->priv;

  if (priv->parser_sinkpad != NULL) {
    gst_object_unref (priv->parser_sinkpad);
    priv->parser_sinkpad = NULL;
  }

  if (priv->decoder_srcpad != NULL) {
    gst_object_unref (priv->decoder_srcpad);
    priv->decoder_srcpad = NULL;
  }

  G_OBJECT_CLASS (parent_class)->dispose (obj);
}

static void
gst_vt_h264_dec_bin_get_property (GObject * obj, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstVTH264DecBin *self = GST_VT_H264_DEC_BIN_CAST (obj);

  switch (prop_id) {
    case PROP_ERROR_STATE:
      GST_OBJECT_LOCK (self);
      g_value_set_boolean (value, self->priv->error_state);
      GST_OBJECT_UNLOCK (self);
      break;
    case PROP_HAPPY:
      GST_OBJECT_LOCK (self);
      g_value_set_boolean (value, !self->priv->error_state);
      GST_OBJECT_UNLOCK (self);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (obj, prop_id, pspec);
      break;
  }
}

static void
gst_vt_h264_dec_bin_class_init (GstVTH264DecBinClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->dispose = gst_vt_h264_dec_bin_dispose;
  gobject_class->get_property = gst_vt_h264_dec_bin_get_property;

  g_type_class_add_private (klass, sizeof (GstVTH264DecBinPrivate));

  g_object_class_install_property (gobject_class, PROP_ERROR_STATE,
      g_param_spec_boolean ("error-state", "Error State",
          "Whether the decoder is currently in an error state",
          VT_H264_DEC_BIN_ERROR_STATE_DEFAULT,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_HAPPY,
      g_param_spec_boolean ("happy", "Happy",
          "Whether the decoder is currently not in an error state",
          !VT_H264_DEC_BIN_ERROR_STATE_DEFAULT,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  GST_DEBUG_CATEGORY_INIT (gst_vt_h264_dec_bin_debug,
      "vth264decbin", 0, "VideoToolbox H.264 decoder bin");
}
