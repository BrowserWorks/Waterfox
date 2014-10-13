/* GStreamer Base Class for Tag Demuxing
 * Copyright (C) 2005 Jan Schmidt <thaytan@mad.scientist.com>
 * Copyright (C) 2006-2007 Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gsttagdemux
 * @see_also: GstApeDemux, GstID3Demux
 * @short_description: Base class for demuxing tags that are in chunks
 *                     directly at the beginning or at the end of a file
 * 
 * <refsect2>
 * <para>
 * Provides a base class for demuxing tags at the beginning or end of a
 * stream and handles things like typefinding, querying, seeking, and
 * different modes of operation (chain-based, pull_range-based, and providing
 * downstream elements with random access if upstream supports that). The tag
 * is stripped from the output, and all offsets are adjusted for the tag
 * sizes, so that to the downstream element the stream will appear as if
 * there was no tag at all. Also, once the tag has been parsed, GstTagDemux
 * will try to determine the media type of the resulting stream and add a
 * source pad with the appropriate caps in order to facilitate auto-plugging.
 * </para>
 * <title>Deriving from GstTagDemux</title>
 * <para>
 * Subclasses have to do four things:
 * <itemizedlist>
 *  <listitem><para>
 *  In their base init function, they must add a pad template for the sink
 *  pad to the element class, describing the media type they can parse in
 *  the caps of the pad template.
 *  </para></listitem>
 *  <listitem><para>
 *  In their class init function, they must override
 *  GST_TAG_DEMUX_CLASS(demux_klass)->identify_tag with their own identify
 *  function.
 *  </para></listitem>
 *  <listitem><para>
 *  In their class init function, they must override
 *  GST_TAG_DEMUX_CLASS(demux_klass)->parse_tag with their own parse
 *  function.
 *  </para></listitem>
 *  <listitem><para>
 *  In their class init function, they must also set
 *  GST_TAG_DEMUX_CLASS(demux_klass)->min_start_size and/or 
 *  GST_TAG_DEMUX_CLASS(demux_klass)->min_end_size to the minimum size required
 *  for the identify function to decide whether the stream has a supported tag
 *  or not. A class parsing ID3v1 tags, for example, would set min_end_size to
 *  128 bytes.
 *  </para></listitem>
 * </itemizedlist>
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gsttagdemux.h"

#include <gst/base/gsttypefindhelper.h>
#include <gst/base/gstadapter.h>
#include <gst/gst-i18n-plugin.h>
#include <string.h>

typedef enum
{
  GST_TAG_DEMUX_READ_START_TAG,
  GST_TAG_DEMUX_TYPEFINDING,
  GST_TAG_DEMUX_STREAMING
} GstTagDemuxState;

struct _GstTagDemuxPrivate
{
  GstPad *srcpad;
  GstPad *sinkpad;

  /* Number of bytes to remove from the
   * start of file (tag at beginning) */
  guint strip_start;

  /* Number of bytes to remove from the
   * end of file (tag at end) */
  guint strip_end;

  gint64 upstream_size;

  GstTagDemuxState state;
  GstAdapter *adapter;
  GstBuffer *collect;
  gsize collect_size;
  guint tagsize;
  GstCaps *src_caps;

  GstTagList *event_tags;
  GstTagList *parsed_tags;
  gboolean send_tag_event;

  GstSegment segment;
  gboolean need_newseg;

  guint64 offset;

  GList *pending_events;
};

/* Require at least 8kB of data before we attempt typefind. 
 * Seems a decent value based on test files
 * 40kB is massive overkill for the maximum, I think, but it 
 * doesn't do any harm (tpm: increased to 64kB after watching
 * typefinding fail on a wavpack file that needed 42kB to succeed) */
#define TYPE_FIND_MIN_SIZE 8192
#define TYPE_FIND_MAX_SIZE 65536

#define DEFAULT_PULL_BLOCKSIZE 4096

GST_DEBUG_CATEGORY_STATIC (tagdemux_debug);
#define GST_CAT_DEFAULT (tagdemux_debug)

static GstStaticPadTemplate src_factory = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("ANY")
    );

static void gst_tag_demux_element_loop (GstTagDemux * demux);

static void gst_tag_demux_dispose (GObject * object);

static GstFlowReturn gst_tag_demux_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buf);
static gboolean gst_tag_demux_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);

static gboolean gst_tag_demux_sink_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_tag_demux_src_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static GstFlowReturn gst_tag_demux_read_range (GstTagDemux * tagdemux,
    GstObject * parent, guint64 offset, guint length, GstBuffer ** buffer);

static GstFlowReturn gst_tag_demux_src_getrange (GstPad * srcpad,
    GstObject * parent, guint64 offset, guint length, GstBuffer ** buffer);

static void gst_tag_demux_set_src_caps (GstTagDemux * tagdemux,
    GstCaps * new_caps);

static gboolean gst_tag_demux_srcpad_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_tag_demux_sink_activate (GstPad * sinkpad,
    GstObject * parent);
static GstStateChangeReturn gst_tag_demux_change_state (GstElement * element,
    GstStateChange transition);
static gboolean gst_tag_demux_pad_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_tag_demux_get_upstream_size (GstTagDemux * tagdemux);
static void gst_tag_demux_send_pending_events (GstTagDemux * tagdemux);
static void gst_tag_demux_send_tag_event (GstTagDemux * tagdemux);
static gboolean gst_tag_demux_send_new_segment (GstTagDemux * tagdemux);

static void gst_tag_demux_base_init (gpointer g_class);
static void gst_tag_demux_class_init (gpointer g_class, gpointer d);
static void gst_tag_demux_init (GstTagDemux * obj, GstTagDemuxClass * klass);

static gpointer parent_class;   /* NULL */

GType
gst_tag_demux_result_get_type (void)
{
  static GType etype = 0;
  if (etype == 0) {
    static const GEnumValue values[] = {
      {GST_TAG_DEMUX_RESULT_BROKEN_TAG, "GST_TAG_DEMUX_RESULT_BROKEN_TAG",
          "broken-tag"},
      {GST_TAG_DEMUX_RESULT_AGAIN, "GST_TAG_DEMUX_RESULT_AGAIN", "again"},
      {GST_TAG_DEMUX_RESULT_OK, "GST_TAG_DEMUX_RESULT_OK", "ok"},
      {0, NULL, NULL}
    };
    etype = g_enum_register_static ("GstTagDemuxResult", values);
  }
  return etype;
}

/* Cannot use boilerplate macros here because we want the abstract flag */
GType
gst_tag_demux_get_type (void)
{
  static GType object_type;     /* 0 */

  if (object_type == 0) {
    static const GTypeInfo object_info = {
      sizeof (GstTagDemuxClass),
      gst_tag_demux_base_init,
      NULL,                     /* base_finalize */
      gst_tag_demux_class_init,
      NULL,                     /* class_finalize */
      NULL,                     /* class_data */
      sizeof (GstTagDemux),
      0,                        /* n_preallocs */
      (GInstanceInitFunc) gst_tag_demux_init
    };

    object_type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstTagDemux", &object_info, G_TYPE_FLAG_ABSTRACT);
  }

  return object_type;
}

static void
gst_tag_demux_base_init (gpointer klass)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_factory));

  GST_DEBUG_CATEGORY_INIT (tagdemux_debug, "tagdemux", 0,
      "tag demux base class");
}

static void
gst_tag_demux_class_init (gpointer klass, gpointer d)
{
  GstTagDemuxClass *tagdemux_class = GST_TAG_DEMUX_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->dispose = gst_tag_demux_dispose;

  element_class->change_state = GST_DEBUG_FUNCPTR (gst_tag_demux_change_state);

  g_type_class_add_private (klass, sizeof (GstTagDemuxPrivate));

  /* subclasses must set at least one of these */
  tagdemux_class->min_start_size = 0;
  tagdemux_class->min_end_size = 0;
}

static void
gst_tag_demux_reset (GstTagDemux * tagdemux)
{
  GstBuffer **buffer_p = &tagdemux->priv->collect;
  GstCaps **caps_p = &tagdemux->priv->src_caps;

  tagdemux->priv->strip_start = 0;
  tagdemux->priv->strip_end = 0;
  tagdemux->priv->upstream_size = -1;
  tagdemux->priv->state = GST_TAG_DEMUX_READ_START_TAG;
  tagdemux->priv->send_tag_event = FALSE;

  gst_buffer_replace (buffer_p, NULL);
  tagdemux->priv->collect_size = 0;
  tagdemux->priv->tagsize = 0;
  gst_adapter_clear (tagdemux->priv->adapter);
  gst_caps_replace (caps_p, NULL);

  if (tagdemux->priv->event_tags) {
    gst_tag_list_unref (tagdemux->priv->event_tags);
    tagdemux->priv->event_tags = NULL;
  }
  if (tagdemux->priv->parsed_tags) {
    gst_tag_list_unref (tagdemux->priv->parsed_tags);
    tagdemux->priv->parsed_tags = NULL;
  }

  gst_segment_init (&tagdemux->priv->segment, GST_FORMAT_UNDEFINED);
  tagdemux->priv->need_newseg = TRUE;

  g_list_foreach (tagdemux->priv->pending_events,
      (GFunc) gst_mini_object_unref, NULL);
  g_list_free (tagdemux->priv->pending_events);
  tagdemux->priv->pending_events = NULL;
}

static void
gst_tag_demux_init (GstTagDemux * demux, GstTagDemuxClass * gclass)
{
  GstElementClass *element_klass = GST_ELEMENT_CLASS (gclass);
  GstPadTemplate *tmpl;

  demux->priv = g_type_instance_get_private ((GTypeInstance *) demux,
      GST_TYPE_TAG_DEMUX);

  /* sink pad */
  tmpl = gst_element_class_get_pad_template (element_klass, "sink");
  if (tmpl) {
    demux->priv->sinkpad = gst_pad_new_from_template (tmpl, "sink");

    gst_pad_set_activatemode_function (demux->priv->sinkpad,
        GST_DEBUG_FUNCPTR (gst_tag_demux_sink_activate_mode));
    gst_pad_set_activate_function (demux->priv->sinkpad,
        GST_DEBUG_FUNCPTR (gst_tag_demux_sink_activate));
    gst_pad_set_event_function (demux->priv->sinkpad,
        GST_DEBUG_FUNCPTR (gst_tag_demux_sink_event));
    gst_pad_set_chain_function (demux->priv->sinkpad,
        GST_DEBUG_FUNCPTR (gst_tag_demux_chain));
    gst_element_add_pad (GST_ELEMENT (demux), demux->priv->sinkpad);
  } else {
    g_warning ("GstTagDemux subclass %s must provide a sink pad template",
        G_OBJECT_TYPE_NAME (demux));
  }

  /* source pad */
  tmpl = gst_element_class_get_pad_template (element_klass, "src");
  demux->priv->srcpad = gst_pad_new_from_template (tmpl, "src");
  gst_pad_set_query_function (demux->priv->srcpad,
      GST_DEBUG_FUNCPTR (gst_tag_demux_pad_query));
  gst_pad_set_event_function (demux->priv->srcpad,
      GST_DEBUG_FUNCPTR (gst_tag_demux_srcpad_event));
  gst_pad_set_activatemode_function (demux->priv->srcpad,
      GST_DEBUG_FUNCPTR (gst_tag_demux_src_activate_mode));
  gst_pad_set_getrange_function (demux->priv->srcpad,
      GST_DEBUG_FUNCPTR (gst_tag_demux_src_getrange));
  gst_pad_use_fixed_caps (demux->priv->srcpad);
  gst_element_add_pad (GST_ELEMENT (demux), demux->priv->srcpad);

  demux->priv->adapter = gst_adapter_new ();
  gst_tag_demux_reset (demux);
}

static void
gst_tag_demux_dispose (GObject * object)
{
  GstTagDemux *tagdemux = GST_TAG_DEMUX (object);

  gst_tag_demux_reset (tagdemux);
  if (tagdemux->priv->adapter) {
    g_object_unref (tagdemux->priv->adapter);
    tagdemux->priv->adapter = NULL;
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

// FIXME: convert to set_caps / sending a caps event
static void
gst_tag_demux_set_src_caps (GstTagDemux * tagdemux, GstCaps * new_caps)
{
  GstCaps *old_caps = tagdemux->priv->src_caps;

  if (old_caps == NULL || !gst_caps_is_equal (new_caps, old_caps)) {
    GstEvent *event;
    guint group_id;
    gboolean have_group_id;
    gchar *stream_id = gst_pad_create_stream_id (tagdemux->priv->srcpad,
        GST_ELEMENT_CAST (tagdemux), NULL);

    gst_caps_replace (&tagdemux->priv->src_caps, new_caps);

    GST_DEBUG_OBJECT (tagdemux, "Changing src pad caps to %" GST_PTR_FORMAT,
        tagdemux->priv->src_caps);

    event =
        gst_pad_get_sticky_event (tagdemux->priv->sinkpad,
        GST_EVENT_STREAM_START, 0);
    if (event) {
      if (gst_event_parse_group_id (event, &group_id))
        have_group_id = TRUE;
      else
        have_group_id = FALSE;
      gst_event_unref (event);
    } else {
      have_group_id = TRUE;
      group_id = gst_util_group_id_next ();
    }

    event = gst_event_new_stream_start (stream_id);
    if (have_group_id)
      gst_event_set_group_id (event, group_id);

    gst_pad_push_event (tagdemux->priv->srcpad, event);
    g_free (stream_id);
    gst_pad_set_caps (tagdemux->priv->srcpad, tagdemux->priv->src_caps);
  } else {
    /* Caps never changed */
  }
}

/* will return FALSE if buffer is beyond end of data; will return TRUE
 * if buffer was trimmed successfully or didn't need trimming, but may
 * also return TRUE and set *buf_ref to NULL if the buffer was before
 * the start of the data */
static gboolean
gst_tag_demux_trim_buffer (GstTagDemux * tagdemux, GstBuffer ** buf_ref,
    gsize * buf_size)
{
  GstBuffer *buf = *buf_ref;

  guint trim_start = 0;
  guint out_size, bsize;
  guint64 out_offset, boffset;
  gboolean need_sub = FALSE;

  bsize = out_size = gst_buffer_get_size (buf);
  boffset = out_offset = GST_BUFFER_OFFSET (buf);

  /* Adjust offset and length */
  if (!GST_BUFFER_OFFSET_IS_VALID (buf)) {
    /* Can't change anything without an offset */
    *buf_size = bsize;
    return TRUE;
  }

  /* If the buffer crosses the tag at the end of file, trim it */
  if (tagdemux->priv->strip_end > 0) {
    if (gst_tag_demux_get_upstream_size (tagdemux)) {
      guint64 v1tag_offset =
          tagdemux->priv->upstream_size - tagdemux->priv->strip_end;

      if (out_offset >= v1tag_offset) {
        GST_DEBUG_OBJECT (tagdemux, "Buffer is past the end of the data");
        goto no_out_buffer_end;
      }

      if (out_offset + out_size > v1tag_offset) {
        out_size = v1tag_offset - out_offset;
        need_sub = TRUE;
      }
    }
  }

  if (tagdemux->priv->strip_start > 0) {
    /* If the buffer crosses the tag at the start of file, trim it */
    if (out_offset <= tagdemux->priv->strip_start) {
      if (out_offset + out_size <= tagdemux->priv->strip_start) {
        GST_DEBUG_OBJECT (tagdemux, "Buffer is before the start of the data");
        goto no_out_buffer_start;
      }

      trim_start = tagdemux->priv->strip_start - out_offset;
      out_size -= trim_start;
      out_offset = 0;
    } else {
      out_offset -= tagdemux->priv->strip_start;
    }
    need_sub = TRUE;
  }

  if (need_sub == TRUE) {
    if (out_size != bsize || !gst_buffer_is_writable (buf)) {
      GstBuffer *sub;

      GST_DEBUG_OBJECT (tagdemux, "Sub-buffering to trim size %d offset %"
          G_GINT64_FORMAT " to %d offset %" G_GINT64_FORMAT,
          bsize, boffset, out_size, out_offset);

      sub =
          gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, trim_start,
          out_size);
      g_return_val_if_fail (sub != NULL, FALSE);
      gst_buffer_unref (buf);
      *buf_ref = buf = sub;
      *buf_size = out_size;
    } else {
      GST_DEBUG_OBJECT (tagdemux, "Adjusting buffer from size %d offset %"
          G_GINT64_FORMAT " to %d offset %" G_GINT64_FORMAT,
          bsize, boffset, out_size, out_offset);
    }

    GST_BUFFER_OFFSET (buf) = out_offset;
    GST_BUFFER_OFFSET_END (buf) = out_offset + out_size;
  }

  return TRUE;

no_out_buffer_end:
  {
    gst_buffer_unref (buf);
    *buf_ref = NULL;
    return FALSE;
  }
no_out_buffer_start:
  {
    gst_buffer_unref (buf);
    *buf_ref = NULL;
    return TRUE;
  }
}

static void
update_collected (GstTagDemux * demux)
{
  guint avail;
  GstBuffer *buf;

  avail = gst_adapter_available (demux->priv->adapter);
  if (avail == 0)
    return;

  buf = gst_adapter_take_buffer (demux->priv->adapter, avail);

  if (demux->priv->collect == NULL) {
    demux->priv->collect = buf;
  } else {
    demux->priv->collect = gst_buffer_append (demux->priv->collect, buf);
  }
  demux->priv->collect_size += avail;
}

static void
gst_tag_demux_chain_parse_tag (GstTagDemux * demux)
{
  GstBuffer *collect;
  GstTagDemuxResult parse_ret;
  GstTagDemuxClass *klass;
  guint tagsize = 0;
  guint available;

  available =
      demux->priv->collect_size + gst_adapter_available (demux->priv->adapter);

  klass = GST_TAG_DEMUX_CLASS (G_OBJECT_GET_CLASS (demux));

  if (available < klass->min_start_size) {
    GST_DEBUG_OBJECT (demux, "Only %u bytes available, but %u needed "
        "to identify tag", available, klass->min_start_size);
    return;                     /* wait for more data */
  }

  if (available < demux->priv->tagsize) {
    GST_DEBUG_OBJECT (demux, "Only %u bytes available, but %u needed "
        "to parse tag", available, demux->priv->tagsize);
    return;                     /* wait for more data */
  }

  update_collected (demux);
  demux->priv->collect = gst_buffer_make_writable (demux->priv->collect);
  collect = demux->priv->collect;

  g_assert (gst_buffer_is_writable (collect));


  /* If we receive a buffer that's from the middle of the file, 
   * we can't read tags so move to typefinding */
  if (GST_BUFFER_OFFSET_IS_VALID (collect) && GST_BUFFER_OFFSET (collect) != 0) {
    GST_DEBUG_OBJECT (demux, "Received buffer from non-zero offset %"
        G_GINT64_FORMAT ". Can't read tags", GST_BUFFER_OFFSET (collect));
    demux->priv->state = GST_TAG_DEMUX_TYPEFINDING;
    return;
  }

  g_assert (klass->identify_tag != NULL);
  g_assert (klass->parse_tag != NULL);

  if (!klass->identify_tag (demux, collect, TRUE, &tagsize)) {
    GST_DEBUG_OBJECT (demux, "Could not identify start tag");
    demux->priv->state = GST_TAG_DEMUX_TYPEFINDING;
    return;
  }

  demux->priv->tagsize = tagsize;

  /* need to set offset of first buffer to 0 or trimming won't work */
  if (!GST_BUFFER_OFFSET_IS_VALID (collect)) {
    GST_WARNING_OBJECT (demux, "Fixing up first buffer without offset");
    GST_BUFFER_OFFSET (collect) = 0;
  }

  GST_DEBUG_OBJECT (demux, "Identified tag, size = %u bytes", tagsize);

  do {
    GstTagList *tags = NULL;
    guint newsize, saved_size;

    demux->priv->strip_start = tagsize;

    if (available < tagsize) {
      GST_DEBUG_OBJECT (demux, "Only %u bytes available, but %u needed "
          "to parse tag", available, tagsize);
      return;                   /* wait for more data */
    }

    saved_size = gst_buffer_get_size (collect);
    gst_buffer_set_size (collect, tagsize);
    newsize = tagsize;

    parse_ret = klass->parse_tag (demux, collect, TRUE, &newsize, &tags);

    gst_buffer_set_size (collect, saved_size);

    switch (parse_ret) {
      case GST_TAG_DEMUX_RESULT_OK:
        demux->priv->strip_start = newsize;
        demux->priv->parsed_tags = tags;
        GST_DEBUG_OBJECT (demux, "Read start tag of size %u", newsize);
        break;
      case GST_TAG_DEMUX_RESULT_BROKEN_TAG:
        demux->priv->strip_start = newsize;
        demux->priv->parsed_tags = tags;
        GST_WARNING_OBJECT (demux, "Ignoring broken start tag of size %d",
            demux->priv->strip_start);
        break;
      case GST_TAG_DEMUX_RESULT_AGAIN:
        GST_DEBUG_OBJECT (demux, "Re-parse, this time with %u bytes", newsize);
        g_assert (newsize != tagsize);
        tagsize = newsize;
        break;
    }
  } while (parse_ret == GST_TAG_DEMUX_RESULT_AGAIN);

  GST_LOG_OBJECT (demux, "Parsed tag. Proceeding to typefinding");
  demux->priv->state = GST_TAG_DEMUX_TYPEFINDING;
  demux->priv->send_tag_event = TRUE;
}

static GstFlowReturn
gst_tag_demux_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstTagDemux *demux;
  gsize size;

  demux = GST_TAG_DEMUX (parent);

  size = gst_buffer_get_size (buf);

  /* Update our segment position info */
  if (demux->priv->segment.format == GST_FORMAT_BYTES) {
    if (GST_BUFFER_OFFSET_IS_VALID (buf))
      demux->priv->segment.position = GST_BUFFER_OFFSET (buf);
    demux->priv->segment.position += size;
  } else if (demux->priv->segment.format == GST_FORMAT_TIME) {
    if (GST_BUFFER_TIMESTAMP_IS_VALID (buf))
      demux->priv->segment.position = GST_BUFFER_TIMESTAMP (buf);
    if (GST_BUFFER_DURATION_IS_VALID (buf))
      demux->priv->segment.position += GST_BUFFER_DURATION (buf);
  }

  gst_adapter_push (demux->priv->adapter, buf);
  buf = NULL;

  switch (demux->priv->state) {
    case GST_TAG_DEMUX_READ_START_TAG:
      gst_tag_demux_chain_parse_tag (demux);
      if (demux->priv->state != GST_TAG_DEMUX_TYPEFINDING)
        break;
      /* Fall-through */
    case GST_TAG_DEMUX_TYPEFINDING:{
      GstTypeFindProbability probability = 0;
      GstBuffer *typefind_buf = NULL;
      gsize typefind_size;
      GstCaps *caps;

      update_collected (demux);

      if (demux->priv->collect_size <
          TYPE_FIND_MIN_SIZE + demux->priv->strip_start)
        break;                  /* Go get more data first */

      GST_DEBUG_OBJECT (demux, "Typefinding with size %" G_GSIZE_FORMAT,
          demux->priv->collect_size);

      /* Trim the buffer and adjust offset for typefinding */
      typefind_buf = demux->priv->collect;
      gst_buffer_ref (typefind_buf);
      if (!gst_tag_demux_trim_buffer (demux, &typefind_buf, &typefind_size))
        return GST_FLOW_EOS;

      if (typefind_buf == NULL)
        break;                  /* Still need more data */

      caps = gst_type_find_helper_for_buffer (GST_OBJECT (demux),
          typefind_buf, &probability);

      if (caps == NULL) {
        if (typefind_size < TYPE_FIND_MAX_SIZE) {
          /* Just break for more data */
          gst_buffer_unref (typefind_buf);
          return GST_FLOW_OK;
        }

        /* We failed typefind */
        GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND, (NULL),
            ("Could not detect type for contents within tag"));
        gst_buffer_unref (typefind_buf);
        gst_buffer_unref (demux->priv->collect);
        demux->priv->collect = NULL;
        demux->priv->collect_size = 0;
        return GST_FLOW_ERROR;
      }
      gst_buffer_unref (typefind_buf);

      GST_DEBUG_OBJECT (demux, "Found type %" GST_PTR_FORMAT " with a "
          "probability of %u", caps, probability);

      gst_tag_demux_set_src_caps (demux, caps);
      gst_caps_unref (caps);

      /* Move onto streaming and fall-through to push out existing
       * data */
      demux->priv->state = GST_TAG_DEMUX_STREAMING;
      /* fall-through */
    }
    case GST_TAG_DEMUX_STREAMING:{
      GstBuffer *outbuf = NULL;
      gsize outbuf_size;

      update_collected (demux);

      /* Trim the buffer and adjust offset */
      if (demux->priv->collect) {
        outbuf = demux->priv->collect;
        demux->priv->collect = NULL;
        demux->priv->collect_size = 0;
        if (!gst_tag_demux_trim_buffer (demux, &outbuf, &outbuf_size))
          return GST_FLOW_EOS;
      }
      if (outbuf) {
        /* Might need a new segment before the buffer */
        if (demux->priv->need_newseg) {
          if (!gst_tag_demux_send_new_segment (demux)) {
            GST_WARNING_OBJECT (demux, "Downstream did not handle newsegment "
                "event as it should");
          }
          demux->priv->need_newseg = FALSE;
        }

        /* send any pending events we cached */
        gst_tag_demux_send_pending_events (demux);

        /* Send our own pending tag event */
        if (demux->priv->send_tag_event) {
          gst_tag_demux_send_tag_event (demux);
          demux->priv->send_tag_event = FALSE;
        }

        GST_LOG_OBJECT (demux, "Pushing buffer %p", outbuf);

        return gst_pad_push (demux->priv->srcpad, outbuf);
      }
    }
  }
  return GST_FLOW_OK;
}

static gboolean
gst_tag_demux_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstTagDemux *demux;
  gboolean ret;

  demux = GST_TAG_DEMUX (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_EOS:
      /* FIXME, detect this differently */
      if (demux->priv->srcpad == NULL) {
        GST_WARNING_OBJECT (demux, "EOS before we found a type");
        GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND, (NULL), (NULL));
      }
      ret = gst_pad_event_default (pad, parent, event);
      break;
    case GST_EVENT_SEGMENT:
    {
      gst_event_copy_segment (event, &demux->priv->segment);

      demux->priv->need_newseg = TRUE;
      gst_event_unref (event);
      ret = TRUE;
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    case GST_EVENT_FLUSH_START:
      ret = gst_pad_event_default (pad, parent, event);
      break;
    case GST_EVENT_CAPS:
      /* we drop the caps event. We do typefind and push a new caps event. */
      ret = gst_pad_event_default (pad, parent, event);
      break;
    default:
      if (demux->priv->need_newseg && GST_EVENT_IS_SERIALIZED (event)) {
        /* Cache all events if we have a pending segment, so they don't get
         * lost (esp. tag events) */
        GST_INFO_OBJECT (demux, "caching event: %" GST_PTR_FORMAT, event);
        GST_OBJECT_LOCK (demux);
        demux->priv->pending_events =
            g_list_append (demux->priv->pending_events, event);
        GST_OBJECT_UNLOCK (demux);
        ret = TRUE;
      } else {
        ret = gst_pad_event_default (pad, parent, event);
      }
      break;
  }

  return ret;
}

static gboolean
gst_tag_demux_get_upstream_size (GstTagDemux * tagdemux)
{
  gint64 len;

  /* Short-cut if we already queried upstream */
  if (tagdemux->priv->upstream_size > 0)
    return TRUE;

  if (!gst_pad_peer_query_duration (tagdemux->priv->sinkpad, GST_FORMAT_BYTES,
          &len) || len <= 0) {
    return FALSE;
  }

  tagdemux->priv->upstream_size = len;
  return TRUE;
}

static gboolean
gst_tag_demux_seek_pull (GstTagDemux * tagdemux, GstEvent * event)
{
  GstSeekFlags flags;
  GstSeekType start_type, stop_type;
  GstFormat format;
  gboolean flush;
  gdouble rate;
  gint64 start, stop;
  GstSegment seeksegment = { 0, };

  gst_event_parse_seek (event, &rate, &format, &flags, &start_type, &start,
      &stop_type, &stop);

  /* we can only seek on bytes */
  if (format != GST_FORMAT_BYTES) {
    GST_DEBUG_OBJECT (tagdemux, "Can only seek on BYTES");
    return FALSE;
  }

  if (tagdemux->priv->state != GST_TAG_DEMUX_STREAMING) {
    GST_DEBUG_OBJECT (tagdemux, "Can only seek if streaming already");
    return FALSE;
  }

  switch (start_type) {
    case GST_SEEK_TYPE_SET:
      if (start == -1)
        start = 0;
      start += tagdemux->priv->strip_start;
      break;
    case GST_SEEK_TYPE_END:
      /* Adjust the seek to be relative to the start of any end tag
       * (note: 10 bytes before end is represented by stop=-10) */
      if (start > 0)
        start = 0;
      start -= tagdemux->priv->strip_end;
      break;
    case GST_SEEK_TYPE_NONE:
    default:
      break;
  }
  switch (stop_type) {
    case GST_SEEK_TYPE_SET:
      if (stop != -1) {
        /* -1 means the end of the file, pass it upstream intact */
        stop += tagdemux->priv->strip_start;
      }
      break;
    case GST_SEEK_TYPE_END:
      /* Adjust the seek to be relative to the start of any end tag
       * (note: 10 bytes before end is represented by stop=-10) */
      if (stop > 0)
        stop = 0;
      stop -= tagdemux->priv->strip_end;
      break;
    case GST_SEEK_TYPE_NONE:
    default:
      break;
  }

  /* copy segment, we need this because we still need the old
   * segment when we close the current segment. */
  memcpy (&seeksegment, &tagdemux->priv->segment, sizeof (GstSegment));

  GST_DEBUG_OBJECT (tagdemux, "configuring seek");
  gst_segment_do_seek (&seeksegment, rate, format, flags,
      start_type, start, stop_type, stop, NULL);

  flush = ! !(flags & GST_SEEK_FLAG_FLUSH);

  GST_DEBUG_OBJECT (tagdemux, "New segment %" GST_SEGMENT_FORMAT, &seeksegment);

  if (flush) {
    GST_DEBUG_OBJECT (tagdemux, "Starting flush");
    gst_pad_push_event (tagdemux->priv->sinkpad, gst_event_new_flush_start ());
    gst_pad_push_event (tagdemux->priv->srcpad, gst_event_new_flush_start ());
  } else {
    GST_DEBUG_OBJECT (tagdemux, "Non-flushing seek, pausing task");
    gst_pad_pause_task (tagdemux->priv->sinkpad);
  }

  /* now grab the stream lock so that streaming cannot continue, for
   * non flushing seeks when the element is in PAUSED this could block
   * forever. */
  GST_DEBUG_OBJECT (tagdemux, "Waiting for streaming to stop");
  GST_PAD_STREAM_LOCK (tagdemux->priv->sinkpad);

  if (flush) {
    GST_DEBUG_OBJECT (tagdemux, "Stopping flush");
    gst_pad_push_event (tagdemux->priv->sinkpad,
        gst_event_new_flush_stop (TRUE));
    gst_pad_push_event (tagdemux->priv->srcpad,
        gst_event_new_flush_stop (TRUE));
  }

  /* now update the real segment info */
  GST_DEBUG_OBJECT (tagdemux, "Committing new seek segment");
  memcpy (&tagdemux->priv->segment, &seeksegment, sizeof (GstSegment));
  tagdemux->priv->offset = tagdemux->priv->segment.start;

  /* notify start of new segment */
  if (tagdemux->priv->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
    GstMessage *msg;

    msg = gst_message_new_segment_start (GST_OBJECT (tagdemux),
        GST_FORMAT_BYTES, tagdemux->priv->segment.start);
    gst_element_post_message (GST_ELEMENT (tagdemux), msg);
  }

  tagdemux->priv->need_newseg = TRUE;

  /* restart our task since it might have been stopped when we did the
   * flush. */
  gst_pad_start_task (tagdemux->priv->sinkpad,
      (GstTaskFunction) gst_tag_demux_element_loop, tagdemux, NULL);

  /* streaming can continue now */
  GST_PAD_STREAM_UNLOCK (tagdemux->priv->sinkpad);

  return TRUE;
}

static gboolean
gst_tag_demux_seek_push (GstTagDemux * tagdemux, GstEvent * event)
{
  gboolean res = FALSE;
  gdouble rate;
  GstFormat format;
  GstSeekType start_type, stop_type;
  GstSeekFlags flags;
  gint64 start, stop;

  gst_event_parse_seek (event, &rate, &format, &flags,
      &start_type, &start, &stop_type, &stop);

  if (format == GST_FORMAT_BYTES &&
      tagdemux->priv->state == GST_TAG_DEMUX_STREAMING &&
      gst_pad_is_linked (tagdemux->priv->sinkpad)) {
    GstEvent *upstream;

    switch (start_type) {
      case GST_SEEK_TYPE_SET:
        if (start == -1)
          start = 0;
        start += tagdemux->priv->strip_start;
        break;
      case GST_SEEK_TYPE_END:
        /* Adjust the seek to be relative to the start of any end tag
         * (note: 10 bytes before end is represented by stop=-10) */
        if (start > 0)
          start = 0;
        start -= tagdemux->priv->strip_end;
        break;
      case GST_SEEK_TYPE_NONE:
      default:
        break;
    }
    switch (stop_type) {
      case GST_SEEK_TYPE_SET:
        if (stop != -1) {
          /* -1 means the end of the file, pass it upstream intact */
          stop += tagdemux->priv->strip_start;
        }
        break;
      case GST_SEEK_TYPE_END:
        /* Adjust the seek to be relative to the start of any end tag
         * (note: 10 bytes before end is represented by stop=-10) */
        if (stop > 0)
          stop = 0;
        stop -= tagdemux->priv->strip_end;
        break;
      case GST_SEEK_TYPE_NONE:
      default:
        break;
    }
    upstream = gst_event_new_seek (rate, format, flags,
        start_type, start, stop_type, stop);
    res = gst_pad_push_event (tagdemux->priv->sinkpad, upstream);
  } else if (format == GST_FORMAT_TIME &&
      tagdemux->priv->state == GST_TAG_DEMUX_STREAMING &&
      gst_pad_is_linked (tagdemux->priv->sinkpad)) {
    res = gst_pad_push_event (tagdemux->priv->sinkpad, gst_event_ref (event));
  }

  return res;
}

static gboolean
gst_tag_demux_srcpad_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstTagDemux *tagdemux;
  gboolean res = FALSE;

  tagdemux = GST_TAG_DEMUX (parent);

  /* Handle SEEK events, with adjusted byte offsets and sizes. */

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
    {
      if (GST_PAD_MODE (tagdemux->priv->sinkpad) == GST_PAD_MODE_PUSH)
        res = gst_tag_demux_seek_push (tagdemux, event);
      else
        res = gst_tag_demux_seek_pull (tagdemux, event);
      break;
    }
    default:
      res = gst_pad_push_event (tagdemux->priv->sinkpad, event);
      event = NULL;
      break;
  }

  if (event)
    gst_event_unref (event);

  return res;
}

/* Read and interpret any end tag when activating in pull_range.
 * Returns FALSE if pad activation should fail. */
static gboolean
gst_tag_demux_pull_end_tag (GstTagDemux * demux, GstTagList ** tags)
{
  GstTagDemuxResult parse_ret;
  GstTagDemuxClass *klass;
  GstFlowReturn flow_ret;
  GstTagList *new_tags = NULL;
  GstBuffer *buffer = NULL;
  gboolean have_tag;
  gboolean res = FALSE;
  guint64 offset;
  guint tagsize;
  gsize bsize;

  klass = GST_TAG_DEMUX_CLASS (G_OBJECT_GET_CLASS (demux));

  g_assert (klass->identify_tag != NULL);
  g_assert (klass->parse_tag != NULL);

  if (klass->min_end_size == 0) {
    GST_DEBUG_OBJECT (demux, "Not looking for tag at the end");
    return TRUE;
  }

  if (demux->priv->upstream_size < klass->min_end_size) {
    GST_DEBUG_OBJECT (demux, "File too small");
    return TRUE;
  }

  /* Pull enough to identify the tag and retrieve its total size */
  offset = demux->priv->upstream_size - klass->min_end_size;

  flow_ret = gst_pad_pull_range (demux->priv->sinkpad, offset,
      klass->min_end_size, &buffer);

  if (flow_ret != GST_FLOW_OK) {
    GST_DEBUG_OBJECT (demux, "Could not read tag header from end of file, "
        "ret = %s", gst_flow_get_name (flow_ret));
    goto done;
  }

  bsize = gst_buffer_get_size (buffer);

  if (bsize < klass->min_end_size) {
    GST_DEBUG_OBJECT (demux, "Only managed to read %" G_GSIZE_FORMAT " bytes"
        "from file (required: %u bytes)", bsize, klass->min_end_size);
    goto done;
  }

  have_tag = klass->identify_tag (demux, buffer, FALSE, &tagsize);

  if (!have_tag) {
    GST_DEBUG_OBJECT (demux, "Could not find tag at end");
    goto done;
  }

  /* Now pull the entire tag */
  do {
    guint newsize, saved_size;

    GST_DEBUG_OBJECT (demux, "Identified tag at end, size=%u bytes", tagsize);

    demux->priv->strip_end = tagsize;

    g_assert (tagsize >= klass->min_end_size);

    /* Get buffer that's exactly the requested size */
    if (bsize != tagsize) {
      gst_buffer_unref (buffer);
      buffer = NULL;

      offset = demux->priv->upstream_size - tagsize;

      flow_ret = gst_pad_pull_range (demux->priv->sinkpad, offset,
          tagsize, &buffer);

      if (flow_ret != GST_FLOW_OK) {
        GST_DEBUG_OBJECT (demux, "Could not read data from end of file at "
            "offset %" G_GUINT64_FORMAT ". ret = %s", offset,
            gst_flow_get_name (flow_ret));
        goto done;
      }

      bsize = gst_buffer_get_size (buffer);

      if (bsize < tagsize) {
        GST_DEBUG_OBJECT (demux, "Only managed to read %" G_GSIZE_FORMAT
            " bytes from file", bsize);
        goto done;
      }
    }

    GST_BUFFER_OFFSET (buffer) = offset;

    saved_size = bsize;
    gst_buffer_set_size (buffer, tagsize);
    newsize = tagsize;

    parse_ret = klass->parse_tag (demux, buffer, FALSE, &newsize, &new_tags);

    gst_buffer_set_size (buffer, saved_size);

    switch (parse_ret) {
      case GST_TAG_DEMUX_RESULT_OK:
        res = TRUE;
        demux->priv->strip_end = newsize;
        GST_DEBUG_OBJECT (demux, "Read tag at end, size %d",
            demux->priv->strip_end);
        break;
      case GST_TAG_DEMUX_RESULT_BROKEN_TAG:
        res = TRUE;
        demux->priv->strip_end = newsize;
        GST_WARNING_OBJECT (demux, "Ignoring broken tag at end, size %d",
            demux->priv->strip_end);
        break;
      case GST_TAG_DEMUX_RESULT_AGAIN:
        GST_DEBUG_OBJECT (demux, "Re-parse, this time with %d bytes", newsize);
        g_assert (newsize != tagsize);
        tagsize = newsize;
        break;
    }
  } while (parse_ret == GST_TAG_DEMUX_RESULT_AGAIN);

  *tags = new_tags;
  new_tags = NULL;

done:
  if (new_tags)
    gst_tag_list_unref (new_tags);
  if (buffer)
    gst_buffer_unref (buffer);
  return res;
}

/* Read and interpret any tag at the start when activating in
 * pull_range. Returns FALSE if pad activation should fail. */
static gboolean
gst_tag_demux_pull_start_tag (GstTagDemux * demux, GstTagList ** tags)
{
  GstTagDemuxResult parse_ret;
  GstTagDemuxClass *klass;
  GstFlowReturn flow_ret;
  GstTagList *new_tags = NULL;
  GstBuffer *buffer = NULL;
  gboolean have_tag;
  gboolean res = FALSE;
  guint req, tagsize;
  gsize bsize;

  klass = GST_TAG_DEMUX_CLASS (G_OBJECT_GET_CLASS (demux));

  g_assert (klass->identify_tag != NULL);
  g_assert (klass->parse_tag != NULL);

  if (klass->min_start_size == 0) {
    GST_DEBUG_OBJECT (demux, "Not looking for tag at the beginning");
    return TRUE;
  }

  /* Handle tag at start. Try with 4kB to start with */
  req = MAX (klass->min_start_size, 4096);

  /* Pull enough to identify the tag and retrieve its total size */
  flow_ret = gst_pad_pull_range (demux->priv->sinkpad, 0, req, &buffer);
  if (flow_ret != GST_FLOW_OK) {
    GST_DEBUG_OBJECT (demux, "Could not read data from start of file ret=%s",
        gst_flow_get_name (flow_ret));
    goto done;
  }

  bsize = gst_buffer_get_size (buffer);

  if (bsize < klass->min_start_size) {
    GST_DEBUG_OBJECT (demux, "Only managed to read %" G_GSIZE_FORMAT
        " bytes from file - no tag in this file", bsize);
    goto done;
  }

  have_tag = klass->identify_tag (demux, buffer, TRUE, &tagsize);

  if (!have_tag) {
    GST_DEBUG_OBJECT (demux, "Could not find start tag");
    res = TRUE;
    goto done;
  }

  GST_DEBUG_OBJECT (demux, "Identified start tag, size = %u bytes", tagsize);

  do {
    guint newsize, saved_size;

    demux->priv->strip_start = tagsize;

    /* Now pull the entire tag */
    g_assert (tagsize >= klass->min_start_size);

    if (bsize < tagsize) {
      gst_buffer_unref (buffer);
      buffer = NULL;

      flow_ret = gst_pad_pull_range (demux->priv->sinkpad, 0, tagsize, &buffer);
      if (flow_ret != GST_FLOW_OK) {
        GST_DEBUG_OBJECT (demux, "Could not read data from start of file, "
            "ret = %s", gst_flow_get_name (flow_ret));
        goto done;
      }

      bsize = gst_buffer_get_size (buffer);

      if (bsize < tagsize) {
        GST_DEBUG_OBJECT (demux, "Only managed to read %" G_GSIZE_FORMAT
            " bytes from file", bsize);
        GST_ELEMENT_ERROR (demux, STREAM, DECODE,
            (_("Failed to read tag: not enough data")), (NULL));
        goto done;
      }
    }

    saved_size = bsize;
    gst_buffer_set_size (buffer, tagsize);
    newsize = tagsize;
    parse_ret = klass->parse_tag (demux, buffer, TRUE, &newsize, &new_tags);

    gst_buffer_set_size (buffer, saved_size);

    switch (parse_ret) {
      case GST_TAG_DEMUX_RESULT_OK:
        res = TRUE;
        demux->priv->strip_start = newsize;
        GST_DEBUG_OBJECT (demux, "Read start tag of size %d", newsize);
        break;
      case GST_TAG_DEMUX_RESULT_BROKEN_TAG:
        res = TRUE;
        demux->priv->strip_start = newsize;
        GST_WARNING_OBJECT (demux, "Ignoring broken start tag of size %d",
            demux->priv->strip_start);
        break;
      case GST_TAG_DEMUX_RESULT_AGAIN:
        GST_DEBUG_OBJECT (demux, "Re-parse, this time with %d bytes", newsize);
        g_assert (newsize != tagsize);
        tagsize = newsize;
        break;
    }
  } while (parse_ret == GST_TAG_DEMUX_RESULT_AGAIN);

  *tags = new_tags;
  new_tags = NULL;

done:
  if (new_tags)
    gst_tag_list_unref (new_tags);
  if (buffer)
    gst_buffer_unref (buffer);
  return res;
}

/* This function operates similarly to gst_type_find_element_loop
 * in the typefind element
 * 1. try to read tags in pull mode
 * 2. typefind the contents
 * 3. if we didn't find any caps, fail.
 * 4. set caps on srcpad
 */
static GstFlowReturn
gst_tag_demux_element_find (GstTagDemux * demux)
{
  GstTagDemuxClass *klass;
  GstTypeFindProbability probability = 0;
  GstFlowReturn ret = GST_FLOW_OK;
  GstTagList *start_tags = NULL;
  GstTagList *end_tags = NULL;
  gboolean e_tag_ok, s_tag_ok;
  GstCaps *caps = NULL;

  /* Look for tags at start and end of file */
  GST_DEBUG_OBJECT (demux, "Activated pull mode. Looking for tags");
  if (!gst_tag_demux_get_upstream_size (demux))
    goto no_size;

  demux->priv->strip_start = 0;
  demux->priv->strip_end = 0;

  /* 1 - Read tags */
  s_tag_ok = gst_tag_demux_pull_start_tag (demux, &start_tags);
  e_tag_ok = gst_tag_demux_pull_end_tag (demux, &end_tags);

  klass = GST_TAG_DEMUX_CLASS (G_OBJECT_GET_CLASS (demux));

  if (klass->merge_tags != NULL) {
    demux->priv->parsed_tags = klass->merge_tags (demux, start_tags, end_tags);
  } else {
    /* we merge in REPLACE mode, so put the less important tags first, which
     * we'll just assume is the end tag (subclasses may change this behaviour
     * or make it configurable by overriding the merge_tags vfunc) */
    demux->priv->parsed_tags =
        gst_tag_list_merge (end_tags, start_tags, GST_TAG_MERGE_REPLACE);
  }

  if (start_tags)
    gst_tag_list_unref (start_tags);
  if (end_tags)
    gst_tag_list_unref (end_tags);

  if (!e_tag_ok && !s_tag_ok)
    goto no_tags;

  if (demux->priv->parsed_tags != NULL) {
    demux->priv->send_tag_event = TRUE;
  }

  if (demux->priv->upstream_size <=
      demux->priv->strip_start + demux->priv->strip_end)
    goto no_data;

  /* 2 - Do typefinding on data, but not if downstream is in charge */
  if (GST_PAD_MODE (demux->priv->srcpad) == GST_PAD_MODE_PULL)
    goto skip_typefinding;

  caps = gst_type_find_helper_get_range (GST_OBJECT (demux), NULL,
      (GstTypeFindHelperGetRangeFunction) gst_tag_demux_read_range,
      demux->priv->upstream_size
      - (demux->priv->strip_start + demux->priv->strip_end), NULL,
      &probability);

  GST_INFO_OBJECT (demux, "Found type %" GST_PTR_FORMAT " with a "
      "probability of %u", caps, probability);

  /* 3 - If we didn't find the caps, fail */
  if (caps == NULL)
    goto no_caps;

  /* tag reading and typefinding were already done, don't do them again in
   * the chain function if we end up in push mode */
  demux->priv->state = GST_TAG_DEMUX_STREAMING;

  /* 6 Set the srcpad caps now that we know them */
  gst_tag_demux_set_src_caps (demux, caps);
  gst_caps_unref (caps);

skip_typefinding:

  /* set it again, in case we skipped typefinding */
  demux->priv->state = GST_TAG_DEMUX_STREAMING;
  demux->priv->offset += demux->priv->strip_start;

  return ret;

  /* ERRORS */
no_size:
  {
    GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND,
        ("Could not get stream size"), (NULL));
    return GST_FLOW_ERROR;
  }
no_tags:
  {
    GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND,
        ("Could not get start and/or end tag"), (NULL));
    return GST_FLOW_ERROR;
  }
no_data:
  {
    /* There was no data (probably due to a truncated file) */
    /* so we don't know about type either */
    GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND, ("No data in file"),
        (NULL));
    return GST_FLOW_ERROR;
  }
no_caps:
  {
    GST_ELEMENT_ERROR (demux, STREAM, TYPE_NOT_FOUND,
        ("Could not detect type of contents"), (NULL));
    return GST_FLOW_ERROR;
  }
}

/* This function operates similarly to gst_type_find_element_loop
 * in the typefind element
 * 1. try to read tags in pull mode
 * 2. typefind the contents
 * 3. if we didn't find any caps, fail.
 * 4. set caps on srcpad
 */
static void
gst_tag_demux_element_loop (GstTagDemux * demux)
{
  GstFlowReturn ret;

  switch (demux->priv->state) {
    case GST_TAG_DEMUX_READ_START_TAG:
    case GST_TAG_DEMUX_TYPEFINDING:
      ret = gst_tag_demux_element_find (demux);
      break;
    case GST_TAG_DEMUX_STREAMING:
    {
      GstBuffer *outbuf = NULL;

      if (demux->priv->need_newseg) {
        demux->priv->need_newseg = FALSE;
        /* FIXME: check segment, should be 0-N for downstream */
        gst_tag_demux_send_new_segment (demux);
      }

      /* Send our own pending tag event */
      if (demux->priv->send_tag_event) {
        gst_tag_demux_send_tag_event (demux);
        demux->priv->send_tag_event = FALSE;
      }

      /* Pull data and push it downstream */
      ret = gst_pad_pull_range (demux->priv->sinkpad, demux->priv->offset,
          DEFAULT_PULL_BLOCKSIZE, &outbuf);

      if (ret != GST_FLOW_OK)
        break;

      GST_BUFFER_OFFSET (outbuf) =
          demux->priv->offset - demux->priv->strip_start;
      demux->priv->offset += gst_buffer_get_size (outbuf);
      GST_BUFFER_OFFSET_END (outbuf) =
          demux->priv->offset - demux->priv->strip_start;

      ret = gst_pad_push (demux->priv->srcpad, outbuf);
      break;
    }
    default:
      ret = GST_FLOW_ERROR;
      break;
  }
  if (ret != GST_FLOW_OK)
    goto pause;

  return;

  /* ERRORS */
pause:
  {
    const gchar *reason = gst_flow_get_name (ret);
    gboolean push_eos = FALSE;

    GST_LOG_OBJECT (demux, "pausing task, reason %s", reason);
    gst_pad_pause_task (demux->priv->sinkpad);

    if (ret == GST_FLOW_EOS) {
      /* perform EOS logic */

      if (demux->priv->segment.flags & GST_SEEK_FLAG_SEGMENT) {
        gint64 stop;

        /* for segment playback we need to post when (in stream time)
         * we stopped, this is either stop (when set) or the duration. */
        if ((stop = demux->priv->segment.stop) == -1)
          stop = demux->priv->offset;

        GST_LOG_OBJECT (demux, "Sending segment done, at end of segment");
        gst_element_post_message (GST_ELEMENT_CAST (demux),
            gst_message_new_segment_done (GST_OBJECT_CAST (demux),
                GST_FORMAT_BYTES, stop));
        gst_pad_push_event (demux->priv->srcpad,
            gst_event_new_segment_done (GST_FORMAT_BYTES, stop));
      } else {
        push_eos = TRUE;
      }
    } else if (ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS) {
      /* for fatal errors we post an error message */
      GST_ELEMENT_ERROR (demux, STREAM, FAILED, (NULL),
          ("Stream stopped, reason %s", reason));
      push_eos = TRUE;
    }
    if (push_eos) {
      /* send EOS, and prevent hanging if no streams yet */
      GST_LOG_OBJECT (demux, "Sending EOS, at end of stream");
      gst_pad_push_event (demux->priv->srcpad, gst_event_new_eos ());
    }
    return;
  }
}

static gboolean
gst_tag_demux_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  GstTagDemux *demux = GST_TAG_DEMUX (parent);
  gboolean res;

  switch (mode) {
    case GST_PAD_MODE_PULL:
      if (active) {
        demux->priv->need_newseg = TRUE;
        demux->priv->offset = 0;
        res = TRUE;
      } else {
        res = gst_pad_stop_task (pad);
      }
      break;
    default:
      res = TRUE;
      break;
  }

  if (active)
    GST_TAG_DEMUX (parent)->priv->state = GST_TAG_DEMUX_READ_START_TAG;

  return res;
}

static gboolean
gst_tag_demux_sink_activate (GstPad * sinkpad, GstObject * parent)
{
  GstTagDemux *demux;
  GstQuery *query;
  gboolean pull_mode;

  demux = GST_TAG_DEMUX (parent);

  /* 1: */
  /* If we can activate pull_range upstream, then read any end and start
   * tags, otherwise activate in push mode and the chain function will 
   * collect buffers, read the start tag and output a buffer to end
   * preroll.
   */
  query = gst_query_new_scheduling ();

  if (!gst_pad_peer_query (sinkpad, query)) {
    gst_query_unref (query);
    goto activate_push;
  }

  pull_mode = gst_query_has_scheduling_mode_with_flags (query,
      GST_PAD_MODE_PULL, GST_SCHEDULING_FLAG_SEEKABLE);
  gst_query_unref (query);

  if (!pull_mode)
    goto activate_push;

  if (!gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PULL, TRUE))
    goto activate_push;

  /* only start our task if we ourselves decide to start in pull mode */
  return gst_pad_start_task (sinkpad,
      (GstTaskFunction) gst_tag_demux_element_loop, demux, NULL);

activate_push:
  {
    GST_DEBUG_OBJECT (demux, "No pull mode. Changing to push, but won't be "
        "able to read end tags");
    return gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PUSH, TRUE);
  }
}

static gboolean
gst_tag_demux_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;
  GstTagDemux *demux = GST_TAG_DEMUX (parent);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      /* make sure our task stops pushing, we can't call _stop here
       * because this activation might happen from the streaming thread. */
      gst_pad_pause_task (demux->priv->sinkpad);
      res = gst_pad_activate_mode (demux->priv->sinkpad, mode, active);
      break;
    default:
      res = TRUE;
      break;
  }
  return res;
}

static GstFlowReturn
gst_tag_demux_read_range (GstTagDemux * demux, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buffer)
{
  GstFlowReturn ret;
  guint64 in_offset;
  guint in_length;
  gsize size;

  g_return_val_if_fail (buffer != NULL, GST_FLOW_ERROR);

  /* Adjust offset and length of the request to trim off tag information. 
   * For the returned buffer, adjust the output offset to match what downstream
   * should see */
  in_offset = offset + demux->priv->strip_start;

  if (!gst_tag_demux_get_upstream_size (demux))
    return GST_FLOW_ERROR;

  if (in_offset + length >= demux->priv->upstream_size - demux->priv->strip_end) {
    if (in_offset + demux->priv->strip_end >= demux->priv->upstream_size)
      return GST_FLOW_EOS;
    in_length = demux->priv->upstream_size - demux->priv->strip_end - in_offset;
  } else {
    in_length = length;
  }

  ret = gst_pad_pull_range (demux->priv->sinkpad, in_offset, in_length, buffer);

  if (ret == GST_FLOW_OK && *buffer) {
    if (!gst_tag_demux_trim_buffer (demux, buffer, &size))
      goto read_beyond_end;

    /* this should only happen in streaming mode */
    g_assert (*buffer != NULL);
  }

  return ret;

read_beyond_end:
  {
    GST_DEBUG_OBJECT (demux, "attempted read beyond end of file");
    if (*buffer != NULL) {
      gst_buffer_unref (*buffer);
      *buffer = NULL;
    }
    return GST_FLOW_EOS;
  }
}

static GstFlowReturn
gst_tag_demux_src_getrange (GstPad * srcpad, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buffer)
{
  GstTagDemux *demux = GST_TAG_DEMUX (parent);

  /* downstream in pull mode won't miss a newsegment event,
   * but it likely appreciates other (tag) events */
  if (demux->priv->need_newseg) {
    gst_tag_demux_send_pending_events (demux);
    demux->priv->need_newseg = FALSE;
  }

  if (demux->priv->send_tag_event) {
    gst_tag_demux_send_tag_event (demux);
    demux->priv->send_tag_event = FALSE;
  }

  return gst_tag_demux_read_range (demux, NULL, offset, length, buffer);
}

static GstStateChangeReturn
gst_tag_demux_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstTagDemux *demux = GST_TAG_DEMUX (element);

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_tag_demux_reset (demux);
      break;
    default:
      break;
  }
  return ret;
}

static gboolean
gst_tag_demux_pad_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  /* For a position or duration query, adjust the returned
   * bytes to strip off the end and start areas */
  GstTagDemux *demux = GST_TAG_DEMUX (parent);
  GstFormat format;
  gint64 result;
  gboolean res = TRUE;

  /* FIXME: locking ? */
  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SCHEDULING:
      res = gst_pad_peer_query (demux->priv->sinkpad, query);
      break;
    case GST_QUERY_POSITION:
    {
      if (!(res = gst_pad_peer_query (demux->priv->sinkpad, query)))
        goto done;

      gst_query_parse_position (query, &format, &result);
      if (format == GST_FORMAT_BYTES) {
        result -= demux->priv->strip_start;
        gst_query_set_position (query, format, result);
      }
      break;
    }
    case GST_QUERY_DURATION:
    {
      if (!(res = gst_pad_peer_query (demux->priv->sinkpad, query)))
        goto done;

      gst_query_parse_duration (query, &format, &result);
      if (format == GST_FORMAT_BYTES) {
        /* if downstream activated us in pull mode right away, e.g. in case of
         * filesrc ! id3demux ! xyzparse ! .., read tags here, since we don't
         * have a streaming thread of our own to do that. We do it here and
         * not in get_range(), so we can return the right size in bytes.. */
        if (demux->priv->state == GST_TAG_DEMUX_READ_START_TAG &&
            GST_PAD_MODE (demux->priv->srcpad) == GST_PAD_MODE_PULL) {
          GstFlowReturn flow G_GNUC_UNUSED;

          flow = gst_tag_demux_element_find (demux);
          GST_INFO_OBJECT (demux, "pulled tags: %s", gst_flow_get_name (flow));
        }
        result -= demux->priv->strip_start + demux->priv->strip_end;
        if (result < 0)
          result = 0;
        gst_query_set_duration (query, format, result);
      }
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
done:
  return res;
}

static void
gst_tag_demux_send_pending_events (GstTagDemux * demux)
{
  GList *events;

  /* send any pending events we cached */
  GST_OBJECT_LOCK (demux);
  events = demux->priv->pending_events;
  demux->priv->pending_events = NULL;
  GST_OBJECT_UNLOCK (demux);

  while (events != NULL) {
    GST_DEBUG_OBJECT (demux->priv->srcpad, "sending cached %s event: %"
        GST_PTR_FORMAT, GST_EVENT_TYPE_NAME (events->data), events->data);
    gst_pad_push_event (demux->priv->srcpad, GST_EVENT (events->data));
    events = g_list_delete_link (events, events);
  }
}

static void
gst_tag_demux_send_tag_event (GstTagDemux * demux)
{
  /* FIXME: what's the correct merge mode? Docs need to tell... */
  GstTagList *merged = gst_tag_list_merge (demux->priv->event_tags,
      demux->priv->parsed_tags, GST_TAG_MERGE_KEEP);

  if (merged) {
    GstEvent *event = gst_event_new_tag (merged);

    GST_EVENT_TIMESTAMP (event) = 0;
    GST_DEBUG_OBJECT (demux, "Sending tag event on src pad");
    gst_pad_push_event (demux->priv->srcpad, event);
  }
}

static gboolean
gst_tag_demux_send_new_segment (GstTagDemux * tagdemux)
{
  GstEvent *event;
  gint64 start, stop, time;
  GstSegment *seg = &tagdemux->priv->segment;
  GstSegment newseg;

  if (seg->format == GST_FORMAT_UNDEFINED) {
    GST_LOG_OBJECT (tagdemux,
        "No new segment received before first buffer. Using default");
    gst_segment_init (seg, GST_FORMAT_BYTES);
    seg->start = tagdemux->priv->strip_start;
    seg->time = tagdemux->priv->strip_start;
  }

  /* Can't adjust segments in non-BYTES formats */
  if (tagdemux->priv->segment.format != GST_FORMAT_BYTES) {
    event = gst_event_new_segment (seg);
    return gst_pad_push_event (tagdemux->priv->srcpad, event);
  }

  start = seg->start;
  stop = seg->stop;
  time = seg->time;

  g_return_val_if_fail (start != -1, FALSE);
  g_return_val_if_fail (time != -1, FALSE);

  if (tagdemux->priv->strip_end > 0) {
    if (gst_tag_demux_get_upstream_size (tagdemux)) {
      guint64 v1tag_offset =
          tagdemux->priv->upstream_size - tagdemux->priv->strip_end;

      if (start >= v1tag_offset) {
        /* Segment is completely within the end tag, output an open-ended
         * segment, even though all the buffers will get trimmed away */
        start = v1tag_offset;
        stop = -1;
      }

      if (stop != -1 && stop >= v1tag_offset) {
        GST_DEBUG_OBJECT (tagdemux,
            "Segment crosses the end tag. Trimming end");
        stop = v1tag_offset;
      }
    }
  }

  if (tagdemux->priv->strip_start > 0) {
    if (start > tagdemux->priv->strip_start)
      start -= tagdemux->priv->strip_start;
    else
      start = 0;

    if (time > tagdemux->priv->strip_start)
      time -= tagdemux->priv->strip_start;
    else
      time = 0;

    if (stop != -1) {
      if (stop > tagdemux->priv->strip_start)
        stop -= tagdemux->priv->strip_start;
      else
        stop = 0;
    }
  }

  GST_DEBUG_OBJECT (tagdemux, "Sending segment %" GST_SEGMENT_FORMAT, seg);

  gst_segment_copy_into (seg, &newseg);
  newseg.start = start;
  newseg.stop = stop;
  newseg.time = time;
  event = gst_event_new_segment (&newseg);

  return gst_pad_push_event (tagdemux->priv->srcpad, event);
}
