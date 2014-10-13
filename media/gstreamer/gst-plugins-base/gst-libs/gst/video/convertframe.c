/* Small helper element for format conversion
 * Copyright (C) 2005 Tim-Philipp Müller <tim centricular net>
 * Copyright (C) 2010 Brandon Lewis <brandon.lewis@collabora.co.uk>
 * Copyright (C) 2010 Edward Hervey <edward.hervey@collabora.co.uk>
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

#include <string.h>
#include "video.h"

static gboolean
caps_are_raw (const GstCaps * caps)
{
  guint i, len;

  len = gst_caps_get_size (caps);

  for (i = 0; i < len; i++) {
    GstStructure *st = gst_caps_get_structure (caps, i);
    if (gst_structure_has_name (st, "video/x-raw"))
      return TRUE;
  }

  return FALSE;
}

static gboolean
create_element (const gchar * factory_name, GstElement ** element,
    GError ** err)
{
  *element = gst_element_factory_make (factory_name, NULL);
  if (*element)
    return TRUE;

  if (err && *err == NULL) {
    *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_MISSING_PLUGIN,
        "cannot create element '%s' - please check your GStreamer installation",
        factory_name);
  }

  return FALSE;
}

static GstElement *
get_encoder (const GstCaps * caps, GError ** err)
{
  GList *encoders = NULL;
  GList *filtered = NULL;
  GstElementFactory *factory = NULL;
  GstElement *encoder = NULL;

  encoders =
      gst_element_factory_list_get_elements (GST_ELEMENT_FACTORY_TYPE_ENCODER |
      GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE, GST_RANK_NONE);

  if (encoders == NULL) {
    *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_MISSING_PLUGIN,
        "Cannot find any image encoder");
    goto fail;
  }

  GST_INFO ("got factory list %p", encoders);
  gst_plugin_feature_list_debug (encoders);

  filtered =
      gst_element_factory_list_filter (encoders, caps, GST_PAD_SRC, FALSE);
  GST_INFO ("got filtered list %p", filtered);

  if (filtered == NULL) {
    gchar *tmp = gst_caps_to_string (caps);
    *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_MISSING_PLUGIN,
        "Cannot find any image encoder for caps %s", tmp);
    g_free (tmp);
    goto fail;
  }

  gst_plugin_feature_list_debug (filtered);

  factory = (GstElementFactory *) filtered->data;

  GST_INFO ("got factory %p", factory);
  encoder = gst_element_factory_create (factory, NULL);

  GST_INFO ("created encoder element %p, %s", encoder,
      GST_ELEMENT_NAME (encoder));

fail:
  if (encoders)
    gst_plugin_feature_list_free (encoders);
  if (filtered)
    gst_plugin_feature_list_free (filtered);

  return encoder;
}

static GstElement *
build_convert_frame_pipeline (GstElement ** src_element,
    GstElement ** sink_element, const GstCaps * from_caps,
    const GstCaps * to_caps, GError ** err)
{
  GstElement *src = NULL, *csp = NULL, *vscale = NULL;
  GstElement *sink = NULL, *encoder = NULL, *pipeline;
  GError *error = NULL;

  /* videoscale is here to correct for the pixel-aspect-ratio for us */
  GST_DEBUG ("creating elements");
  if (!create_element ("appsrc", &src, &error) ||
      !create_element ("videoconvert", &csp, &error) ||
      !create_element ("videoscale", &vscale, &error) ||
      !create_element ("appsink", &sink, &error))
    goto no_elements;

  pipeline = gst_pipeline_new ("videoconvert-pipeline");
  if (pipeline == NULL)
    goto no_pipeline;

  /* Add black borders if necessary to keep the DAR */
  g_object_set (vscale, "add-borders", TRUE, NULL);

  GST_DEBUG ("adding elements");
  gst_bin_add_many (GST_BIN (pipeline), src, csp, vscale, sink, NULL);

  /* set caps */
  g_object_set (src, "caps", from_caps, NULL);
  g_object_set (sink, "caps", to_caps, NULL);

  /* FIXME: linking is still way too expensive, profile this properly */
  GST_DEBUG ("linking src->csp");
  if (!gst_element_link_pads (src, "src", csp, "sink"))
    goto link_failed;

  GST_DEBUG ("linking csp->vscale");
  if (!gst_element_link_pads_full (csp, "src", vscale, "sink",
          GST_PAD_LINK_CHECK_NOTHING))
    goto link_failed;

  if (caps_are_raw (to_caps)) {
    GST_DEBUG ("linking vscale->sink");

    if (!gst_element_link_pads_full (vscale, "src", sink, "sink",
            GST_PAD_LINK_CHECK_NOTHING))
      goto link_failed;
  } else {
    encoder = get_encoder (to_caps, &error);
    if (!encoder)
      goto no_encoder;
    gst_bin_add (GST_BIN (pipeline), encoder);

    GST_DEBUG ("linking vscale->encoder");
    if (!gst_element_link (vscale, encoder))
      goto link_failed;

    GST_DEBUG ("linking encoder->sink");
    if (!gst_element_link_pads (encoder, "src", sink, "sink"))
      goto link_failed;
  }

  g_object_set (src, "emit-signals", TRUE, NULL);
  g_object_set (sink, "emit-signals", TRUE, NULL);

  *src_element = src;
  *sink_element = sink;

  return pipeline;
  /* ERRORS */
no_encoder:
  {
    gst_object_unref (pipeline);

    GST_ERROR ("could not find an encoder for provided caps");
    if (err)
      *err = error;
    else
      g_error_free (error);

    return NULL;
  }
no_elements:
  {
    if (src)
      gst_object_unref (src);
    if (csp)
      gst_object_unref (csp);
    if (vscale)
      gst_object_unref (vscale);
    if (sink)
      gst_object_unref (sink);
    GST_ERROR ("Could not convert video frame: %s", error->message);
    if (err)
      *err = error;
    else
      g_error_free (error);
    return NULL;
  }
no_pipeline:
  {
    gst_object_unref (src);
    gst_object_unref (csp);
    gst_object_unref (vscale);
    gst_object_unref (sink);

    GST_ERROR ("Could not convert video frame: no pipeline (unknown error)");
    if (err)
      *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
          "Could not convert video frame: no pipeline (unknown error)");
    return NULL;
  }
link_failed:
  {
    gst_object_unref (pipeline);

    GST_ERROR ("Could not convert video frame: failed to link elements");
    if (err)
      *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_NEGOTIATION,
          "Could not convert video frame: failed to link elements");
    return NULL;
  }
}

/**
 * gst_video_convert_sample:
 * @sample: a #GstSample
 * @to_caps: the #GstCaps to convert to
 * @timeout: the maximum amount of time allowed for the processing.
 * @error: pointer to a #GError. Can be %NULL.
 *
 * Converts a raw video buffer into the specified output caps.
 *
 * The output caps can be any raw video formats or any image formats (jpeg, png, ...).
 *
 * The width, height and pixel-aspect-ratio can also be specified in the output caps.
 *
 * Returns: The converted #GstSample, or %NULL if an error happened (in which case @err
 * will point to the #GError).
 */
GstSample *
gst_video_convert_sample (GstSample * sample, const GstCaps * to_caps,
    GstClockTime timeout, GError ** error)
{
  GstMessage *msg;
  GstBuffer *buf;
  GstSample *result = NULL;
  GError *err = NULL;
  GstBus *bus;
  GstCaps *from_caps, *to_caps_copy = NULL;
  GstFlowReturn ret;
  GstElement *pipeline, *src, *sink;
  guint i, n;

  g_return_val_if_fail (sample != NULL, NULL);
  g_return_val_if_fail (to_caps != NULL, NULL);

  buf = gst_sample_get_buffer (sample);
  g_return_val_if_fail (buf != NULL, NULL);

  from_caps = gst_sample_get_caps (sample);
  g_return_val_if_fail (from_caps != NULL, NULL);


  to_caps_copy = gst_caps_new_empty ();
  n = gst_caps_get_size (to_caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (to_caps, i);

    s = gst_structure_copy (s);
    gst_structure_remove_field (s, "framerate");
    gst_caps_append_structure (to_caps_copy, s);
  }

  pipeline =
      build_convert_frame_pipeline (&src, &sink, from_caps, to_caps_copy, &err);
  if (!pipeline)
    goto no_pipeline;

  /* now set the pipeline to the paused state, after we push the buffer into
   * appsrc, this should preroll the converted buffer in appsink */
  GST_DEBUG ("running conversion pipeline to caps %" GST_PTR_FORMAT,
      to_caps_copy);
  gst_element_set_state (pipeline, GST_STATE_PAUSED);

  /* feed buffer in appsrc */
  GST_DEBUG ("feeding buffer %p, size %" G_GSIZE_FORMAT ", caps %"
      GST_PTR_FORMAT, buf, gst_buffer_get_size (buf), from_caps);
  g_signal_emit_by_name (src, "push-buffer", buf, &ret);

  /* now see what happens. We either got an error somewhere or the pipeline
   * prerolled */
  bus = gst_element_get_bus (pipeline);
  msg = gst_bus_timed_pop_filtered (bus,
      timeout, GST_MESSAGE_ERROR | GST_MESSAGE_ASYNC_DONE);

  if (msg) {
    switch (GST_MESSAGE_TYPE (msg)) {
      case GST_MESSAGE_ASYNC_DONE:
      {
        /* we're prerolled, get the frame from appsink */
        g_signal_emit_by_name (sink, "pull-preroll", &result);

        if (result) {
          GST_DEBUG ("conversion successful: result = %p", result);
        } else {
          GST_ERROR ("prerolled but no result frame?!");
        }
        break;
      }
      case GST_MESSAGE_ERROR:{
        gchar *dbg = NULL;

        gst_message_parse_error (msg, &err, &dbg);
        if (err) {
          GST_ERROR ("Could not convert video frame: %s", err->message);
          GST_DEBUG ("%s [debug: %s]", err->message, GST_STR_NULL (dbg));
          if (error)
            *error = err;
          else
            g_error_free (err);
        }
        g_free (dbg);
        break;
      }
      default:{
        g_return_val_if_reached (NULL);
      }
    }
    gst_message_unref (msg);
  } else {
    GST_ERROR ("Could not convert video frame: timeout during conversion");
    if (error)
      *error = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
          "Could not convert video frame: timeout during conversion");
  }

  gst_element_set_state (pipeline, GST_STATE_NULL);
  gst_object_unref (bus);
  gst_object_unref (pipeline);
  gst_caps_unref (to_caps_copy);

  return result;

  /* ERRORS */
no_pipeline:
  {
    gst_caps_unref (to_caps_copy);

    if (error)
      *error = err;
    else
      g_error_free (err);

    return NULL;
  }
}

typedef struct
{
  GMutex mutex;
  GstElement *pipeline;
  GstVideoConvertSampleCallback callback;
  gpointer user_data;
  GDestroyNotify destroy_notify;
  GMainContext *context;
  GstSample *sample;
  //GstBuffer *buffer;
  gulong timeout_id;
  gboolean finished;
} GstVideoConvertSampleContext;

typedef struct
{
  GstVideoConvertSampleCallback callback;
  GstSample *sample;
  //GstBuffer *buffer;
  GError *error;
  gpointer user_data;
  GDestroyNotify destroy_notify;

  GstVideoConvertSampleContext *context;
} GstVideoConvertSampleCallbackContext;

static void
gst_video_convert_frame_context_free (GstVideoConvertSampleContext * ctx)
{
  /* Wait until all users of the mutex are done */
  g_mutex_lock (&ctx->mutex);
  g_mutex_unlock (&ctx->mutex);
  g_mutex_clear (&ctx->mutex);
  if (ctx->timeout_id)
    g_source_remove (ctx->timeout_id);
  //if (ctx->buffer)
  //  gst_buffer_unref (ctx->buffer);
  if (ctx->sample)
    gst_sample_unref (ctx->sample);
  g_main_context_unref (ctx->context);

  gst_element_set_state (ctx->pipeline, GST_STATE_NULL);
  gst_object_unref (ctx->pipeline);

  g_slice_free (GstVideoConvertSampleContext, ctx);
}

static void
    gst_video_convert_frame_callback_context_free
    (GstVideoConvertSampleCallbackContext * ctx)
{
  if (ctx->context)
    gst_video_convert_frame_context_free (ctx->context);
  g_slice_free (GstVideoConvertSampleCallbackContext, ctx);
}

static gboolean
convert_frame_dispatch_callback (GstVideoConvertSampleCallbackContext * ctx)
{
  ctx->callback (ctx->sample, ctx->error, ctx->user_data);

  if (ctx->destroy_notify)
    ctx->destroy_notify (ctx->user_data);

  return FALSE;
}

static void
convert_frame_finish (GstVideoConvertSampleContext * context,
    GstSample * sample, GError * error)
{
  GSource *source;
  GstVideoConvertSampleCallbackContext *ctx;

  if (context->timeout_id)
    g_source_remove (context->timeout_id);
  context->timeout_id = 0;

  ctx = g_slice_new (GstVideoConvertSampleCallbackContext);
  ctx->callback = context->callback;
  ctx->user_data = context->user_data;
  ctx->destroy_notify = context->destroy_notify;
  ctx->sample = sample;
  //ctx->buffer = buffer;
  ctx->error = error;
  ctx->context = context;

  source = g_timeout_source_new (0);
  g_source_set_callback (source,
      (GSourceFunc) convert_frame_dispatch_callback, ctx,
      (GDestroyNotify) gst_video_convert_frame_callback_context_free);
  g_source_attach (source, context->context);
  g_source_unref (source);

  context->finished = TRUE;
}

static gboolean
convert_frame_timeout_callback (GstVideoConvertSampleContext * context)
{
  GError *error;

  g_mutex_lock (&context->mutex);

  if (context->finished)
    goto done;

  GST_ERROR ("Could not convert video frame: timeout");

  error = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
      "Could not convert video frame: timeout");

  convert_frame_finish (context, NULL, error);

done:
  g_mutex_unlock (&context->mutex);
  return FALSE;
}

static gboolean
convert_frame_bus_callback (GstBus * bus, GstMessage * message,
    GstVideoConvertSampleContext * context)
{
  g_mutex_lock (&context->mutex);

  if (context->finished)
    goto done;

  switch (GST_MESSAGE_TYPE (message)) {
    case GST_MESSAGE_ERROR:{
      GError *error;
      gchar *dbg = NULL;

      gst_message_parse_error (message, &error, &dbg);

      GST_ERROR ("Could not convert video frame: %s", error->message);
      GST_DEBUG ("%s [debug: %s]", error->message, GST_STR_NULL (dbg));

      convert_frame_finish (context, NULL, error);

      g_free (dbg);
      break;
    }
    default:
      break;
  }

done:
  g_mutex_unlock (&context->mutex);

  return FALSE;
}

static void
convert_frame_need_data_callback (GstElement * src, guint size,
    GstVideoConvertSampleContext * context)
{
  GstFlowReturn ret = GST_FLOW_ERROR;
  GError *error;
  GstBuffer *buffer;

  g_mutex_lock (&context->mutex);

  if (context->finished)
    goto done;

  buffer = gst_sample_get_buffer (context->sample);
  g_signal_emit_by_name (src, "push-buffer", buffer, &ret);
  gst_sample_unref (context->sample);
  context->sample = NULL;

  if (ret != GST_FLOW_OK) {
    GST_ERROR ("Could not push video frame: %s", gst_flow_get_name (ret));

    error = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
        "Could not push video frame: %s", gst_flow_get_name (ret));

    convert_frame_finish (context, NULL, error);
  }

  g_signal_handlers_disconnect_by_func (src, convert_frame_need_data_callback,
      context);

done:
  g_mutex_unlock (&context->mutex);
}

static GstFlowReturn
convert_frame_new_preroll_callback (GstElement * sink,
    GstVideoConvertSampleContext * context)
{
  GstSample *sample = NULL;
  GError *error = NULL;

  g_mutex_lock (&context->mutex);

  if (context->finished)
    goto done;

  g_signal_emit_by_name (sink, "pull-preroll", &sample);

  if (!sample) {
    error = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
        "Could not get converted video sample");
  }
  convert_frame_finish (context, sample, error);

  g_signal_handlers_disconnect_by_func (sink, convert_frame_need_data_callback,
      context);

done:
  g_mutex_unlock (&context->mutex);

  return GST_FLOW_OK;
}

/**
 * gst_video_convert_sample_async:
 * @sample: a #GstSample
 * @to_caps: the #GstCaps to convert to
 * @timeout: the maximum amount of time allowed for the processing.
 * @callback: %GstVideoConvertSampleCallback that will be called after conversion.
 * @user_data: extra data that will be passed to the @callback
 * @destroy_notify: %GDestroyNotify to be called after @user_data is not needed anymore
 *
 * Converts a raw video buffer into the specified output caps.
 *
 * The output caps can be any raw video formats or any image formats (jpeg, png, ...).
 *
 * The width, height and pixel-aspect-ratio can also be specified in the output caps.
 *
 * @callback will be called after conversion, when an error occured or if conversion didn't
 * finish after @timeout. @callback will always be called from the thread default
 * %GMainContext, see g_main_context_get_thread_default(). If GLib before 2.22 is used,
 * this will always be the global default main context.
 *
 * @destroy_notify will be called after the callback was called and @user_data is not needed
 * anymore.
 */
void
gst_video_convert_sample_async (GstSample * sample,
    const GstCaps * to_caps, GstClockTime timeout,
    GstVideoConvertSampleCallback callback, gpointer user_data,
    GDestroyNotify destroy_notify)
{
  GMainContext *context = NULL;
  GError *error = NULL;
  GstBus *bus;
  GstBuffer *buf;
  GstCaps *from_caps, *to_caps_copy = NULL;
  GstElement *pipeline, *src, *sink;
  guint i, n;
  GSource *source;
  GstVideoConvertSampleContext *ctx;

  g_return_if_fail (sample != NULL);
  buf = gst_sample_get_buffer (sample);
  g_return_if_fail (buf != NULL);

  g_return_if_fail (to_caps != NULL);

  from_caps = gst_sample_get_caps (sample);
  g_return_if_fail (from_caps != NULL);
  g_return_if_fail (callback != NULL);

  context = g_main_context_get_thread_default ();

  if (!context)
    context = g_main_context_default ();

  to_caps_copy = gst_caps_new_empty ();
  n = gst_caps_get_size (to_caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (to_caps, i);

    s = gst_structure_copy (s);
    gst_structure_remove_field (s, "framerate");
    gst_caps_append_structure (to_caps_copy, s);
  }

  pipeline =
      build_convert_frame_pipeline (&src, &sink, from_caps, to_caps_copy,
      &error);
  if (!pipeline)
    goto no_pipeline;

  bus = gst_element_get_bus (pipeline);

  ctx = g_slice_new0 (GstVideoConvertSampleContext);
  g_mutex_init (&ctx->mutex);
  //ctx->buffer = gst_buffer_ref (buf);
  ctx->sample = gst_sample_ref (sample);
  ctx->callback = callback;
  ctx->user_data = user_data;
  ctx->destroy_notify = destroy_notify;
  ctx->context = g_main_context_ref (context);
  ctx->finished = FALSE;
  ctx->pipeline = pipeline;

  if (timeout != GST_CLOCK_TIME_NONE) {
    source = g_timeout_source_new (timeout / GST_MSECOND);
    g_source_set_callback (source,
        (GSourceFunc) convert_frame_timeout_callback, ctx, NULL);
    ctx->timeout_id = g_source_attach (source, context);
    g_source_unref (source);
  }

  g_signal_connect (src, "need-data",
      G_CALLBACK (convert_frame_need_data_callback), ctx);
  g_signal_connect (sink, "new-preroll",
      G_CALLBACK (convert_frame_new_preroll_callback), ctx);

  source = gst_bus_create_watch (bus);
  g_source_set_callback (source, (GSourceFunc) convert_frame_bus_callback,
      ctx, NULL);
  g_source_attach (source, context);
  g_source_unref (source);

  gst_element_set_state (pipeline, GST_STATE_PLAYING);

  gst_object_unref (bus);
  gst_caps_unref (to_caps_copy);

  return;
  /* ERRORS */
no_pipeline:
  {
    GstVideoConvertSampleCallbackContext *ctx;
    GSource *source;

    gst_caps_unref (to_caps_copy);

    ctx = g_slice_new0 (GstVideoConvertSampleCallbackContext);
    ctx->callback = callback;
    ctx->user_data = user_data;
    ctx->destroy_notify = destroy_notify;
    ctx->sample = NULL;
    ctx->error = error;

    source = g_timeout_source_new (0);
    g_source_set_callback (source,
        (GSourceFunc) convert_frame_dispatch_callback, ctx,
        (GDestroyNotify) gst_video_convert_frame_callback_context_free);
    g_source_attach (source, context);
    g_source_unref (source);
  }
}
