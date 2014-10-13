/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wim@fluendo.com>
 *
 * gstfakesrc.c:
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
 * SECTION:element-fakesrc
 * @see_also: #GstFakeSink
 *
 * The fakesrc element is a multipurpose element that can generate
 * a wide range of buffers and can operate in various scheduling modes.
 *
 * It is mostly used as a testing element, one trivial example for testing
 * basic <application>GStreamer</application> core functionality is:
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch -v fakesrc num-buffers=5 ! fakesink
 * ]| This pipeline will push 5 empty buffers to the fakesink element and then
 * sends an EOS.
 * </refsect2>
 */

/* FIXME: this ignores basesrc::blocksize property, which could be used as an
 * alias to ::sizemax (see gst_base_src_get_blocksize()).
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include "gstelements_private.h"
#include "gstfakesrc.h"

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_fake_src_debug);
#define GST_CAT_DEFAULT gst_fake_src_debug

/* FakeSrc signals and args */
enum
{
  /* FILL ME */
  SIGNAL_HANDOFF,
  LAST_SIGNAL
};

#define DEFAULT_OUTPUT          FAKE_SRC_FIRST_LAST_LOOP
#define DEFAULT_DATA            FAKE_SRC_DATA_ALLOCATE
#define DEFAULT_SIZETYPE        FAKE_SRC_SIZETYPE_EMPTY
#define DEFAULT_SIZEMIN         0
#define DEFAULT_SIZEMAX         4096
#define DEFAULT_FILLTYPE        FAKE_SRC_FILLTYPE_ZERO
#define DEFAULT_DATARATE        0
#define DEFAULT_SYNC            FALSE
#define DEFAULT_PATTERN         NULL
#define DEFAULT_EOS             FALSE
#define DEFAULT_SIGNAL_HANDOFFS FALSE
#define DEFAULT_SILENT          TRUE
#define DEFAULT_DUMP            FALSE
#define DEFAULT_PARENTSIZE      4096*10
#define DEFAULT_CAN_ACTIVATE_PULL TRUE
#define DEFAULT_CAN_ACTIVATE_PUSH TRUE
#define DEFAULT_FORMAT          GST_FORMAT_BYTES

enum
{
  PROP_0,
  PROP_OUTPUT,
  PROP_DATA,
  PROP_SIZETYPE,
  PROP_SIZEMIN,
  PROP_SIZEMAX,
  PROP_FILLTYPE,
  PROP_DATARATE,
  PROP_SYNC,
  PROP_PATTERN,
  PROP_EOS,
  PROP_SIGNAL_HANDOFFS,
  PROP_SILENT,
  PROP_DUMP,
  PROP_PARENTSIZE,
  PROP_LAST_MESSAGE,
  PROP_CAN_ACTIVATE_PULL,
  PROP_CAN_ACTIVATE_PUSH,
  PROP_IS_LIVE,
  PROP_FORMAT,
  PROP_LAST,
};

/* not implemented
#define GST_TYPE_FAKE_SRC_OUTPUT (gst_fake_src_output_get_type())
static GType
gst_fake_src_output_get_type (void)
{
  static GType fakesrc_output_type = 0;
  static const GEnumValue fakesrc_output[] = {
    {FAKE_SRC_FIRST_LAST_LOOP, "1", "First-Last loop"},
    {FAKE_SRC_LAST_FIRST_LOOP, "2", "Last-First loop"},
    {FAKE_SRC_PING_PONG, "3", "Ping-Pong"},
    {FAKE_SRC_ORDERED_RANDOM, "4", "Ordered Random"},
    {FAKE_SRC_RANDOM, "5", "Random"},
    {FAKE_SRC_PATTERN_LOOP, "6", "Patttern loop"},
    {FAKE_SRC_PING_PONG_PATTERN, "7", "Ping-Pong Pattern"},
    {FAKE_SRC_GET_ALWAYS_SUCEEDS, "8", "'_get' Always succeeds"},
    {0, NULL, NULL},
  };

  if (!fakesrc_output_type) {
    fakesrc_output_type =
        g_enum_register_static ("GstFakeSrcOutput", fakesrc_output);
  }
  return fakesrc_output_type;
}
*/

#define GST_TYPE_FAKE_SRC_DATA (gst_fake_src_data_get_type())
static GType
gst_fake_src_data_get_type (void)
{
  static GType fakesrc_data_type = 0;
  static const GEnumValue fakesrc_data[] = {
    {FAKE_SRC_DATA_ALLOCATE, "Allocate data", "allocate"},
    {FAKE_SRC_DATA_SUBBUFFER, "Subbuffer data", "subbuffer"},
    {0, NULL, NULL},
  };

  if (!fakesrc_data_type) {
    fakesrc_data_type =
        g_enum_register_static ("GstFakeSrcDataType", fakesrc_data);
  }
  return fakesrc_data_type;
}

#define GST_TYPE_FAKE_SRC_SIZETYPE (gst_fake_src_sizetype_get_type())
static GType
gst_fake_src_sizetype_get_type (void)
{
  static GType fakesrc_sizetype_type = 0;
  static const GEnumValue fakesrc_sizetype[] = {
    {FAKE_SRC_SIZETYPE_EMPTY, "Send empty buffers", "empty"},
    {FAKE_SRC_SIZETYPE_FIXED, "Fixed size buffers (sizemax sized)", "fixed"},
    {FAKE_SRC_SIZETYPE_RANDOM,
        "Random sized buffers (sizemin <= size <= sizemax)", "random"},
    {0, NULL, NULL},
  };

  if (!fakesrc_sizetype_type) {
    fakesrc_sizetype_type =
        g_enum_register_static ("GstFakeSrcSizeType", fakesrc_sizetype);
  }
  return fakesrc_sizetype_type;
}

#define GST_TYPE_FAKE_SRC_FILLTYPE (gst_fake_src_filltype_get_type())
static GType
gst_fake_src_filltype_get_type (void)
{
  static GType fakesrc_filltype_type = 0;
  static const GEnumValue fakesrc_filltype[] = {
    {FAKE_SRC_FILLTYPE_NOTHING, "Leave data as malloced", "nothing"},
    {FAKE_SRC_FILLTYPE_ZERO, "Fill buffers with zeros", "zero"},
    {FAKE_SRC_FILLTYPE_RANDOM, "Fill buffers with random crap", "random"},
    {FAKE_SRC_FILLTYPE_PATTERN, "Fill buffers with pattern 0x00 -> 0xff",
        "pattern"},
    {FAKE_SRC_FILLTYPE_PATTERN_CONT,
          "Fill buffers with pattern 0x00 -> 0xff that spans buffers",
        "pattern-span"},
    {0, NULL, NULL},
  };

  if (!fakesrc_filltype_type) {
    fakesrc_filltype_type =
        g_enum_register_static ("GstFakeSrcFillType", fakesrc_filltype);
  }
  return fakesrc_filltype_type;
}

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_fake_src_debug, "fakesrc", 0, "fakesrc element");
#define gst_fake_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstFakeSrc, gst_fake_src, GST_TYPE_BASE_SRC, _do_init);

static void gst_fake_src_finalize (GObject * object);
static void gst_fake_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_fake_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_fake_src_start (GstBaseSrc * basesrc);
static gboolean gst_fake_src_stop (GstBaseSrc * basesrc);
static gboolean gst_fake_src_is_seekable (GstBaseSrc * basesrc);

static gboolean gst_fake_src_event_handler (GstBaseSrc * src, GstEvent * event);
static void gst_fake_src_get_times (GstBaseSrc * basesrc, GstBuffer * buffer,
    GstClockTime * start, GstClockTime * end);
static GstFlowReturn gst_fake_src_create (GstBaseSrc * src, guint64 offset,
    guint length, GstBuffer ** buf);

static guint gst_fake_src_signals[LAST_SIGNAL] = { 0 };

static GParamSpec *pspec_last_message = NULL;

static void
gst_fake_src_class_init (GstFakeSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSrcClass *gstbase_src_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbase_src_class = GST_BASE_SRC_CLASS (klass);

  gobject_class->finalize = gst_fake_src_finalize;

  gobject_class->set_property = gst_fake_src_set_property;
  gobject_class->get_property = gst_fake_src_get_property;

/*
  FIXME: this is not implemented; would make sense once basesrc and fakesrc
  support multiple pads
  g_object_class_install_property (gobject_class, PROP_OUTPUT,
      g_param_spec_enum ("output", "output", "Output method (currently unused)",
          GST_TYPE_FAKE_SRC_OUTPUT, DEFAULT_OUTPUT, G_PARAM_READWRITE));
*/
  g_object_class_install_property (gobject_class, PROP_DATA,
      g_param_spec_enum ("data", "data", "Data allocation method",
          GST_TYPE_FAKE_SRC_DATA, DEFAULT_DATA,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (G_OBJECT_CLASS (klass), PROP_SIZETYPE,
      g_param_spec_enum ("sizetype", "sizetype",
          "How to determine buffer sizes", GST_TYPE_FAKE_SRC_SIZETYPE,
          DEFAULT_SIZETYPE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SIZEMIN,
      g_param_spec_int ("sizemin", "sizemin", "Minimum buffer size", 0,
          G_MAXINT, DEFAULT_SIZEMIN,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SIZEMAX,
      g_param_spec_int ("sizemax", "sizemax", "Maximum buffer size", 0,
          G_MAXINT, DEFAULT_SIZEMAX,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PARENTSIZE,
      g_param_spec_int ("parentsize", "parentsize",
          "Size of parent buffer for sub-buffered allocation", 0, G_MAXINT,
          DEFAULT_PARENTSIZE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_FILLTYPE,
      g_param_spec_enum ("filltype", "filltype",
          "How to fill the buffer, if at all", GST_TYPE_FAKE_SRC_FILLTYPE,
          DEFAULT_FILLTYPE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DATARATE,
      g_param_spec_int ("datarate", "Datarate",
          "Timestamps buffers with number of bytes per second (0 = none)", 0,
          G_MAXINT, DEFAULT_DATARATE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SYNC,
      g_param_spec_boolean ("sync", "Sync", "Sync to the clock to the datarate",
          DEFAULT_SYNC, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PATTERN,
      g_param_spec_string ("pattern", "pattern", "pattern", DEFAULT_PATTERN,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  pspec_last_message = g_param_spec_string ("last-message", "last-message",
      "The last status message", NULL,
      G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_LAST_MESSAGE,
      pspec_last_message);
  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "Silent",
          "Don't produce last_message events", DEFAULT_SILENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SIGNAL_HANDOFFS,
      g_param_spec_boolean ("signal-handoffs", "Signal handoffs",
          "Send a signal before pushing the buffer", DEFAULT_SIGNAL_HANDOFFS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DUMP,
      g_param_spec_boolean ("dump", "Dump", "Dump buffer contents to stdout",
          DEFAULT_DUMP, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_CAN_ACTIVATE_PUSH,
      g_param_spec_boolean ("can-activate-push", "Can activate push",
          "Can activate in push mode", DEFAULT_CAN_ACTIVATE_PUSH,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_CAN_ACTIVATE_PULL,
      g_param_spec_boolean ("can-activate-pull", "Can activate pull",
          "Can activate in pull mode", DEFAULT_CAN_ACTIVATE_PULL,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_IS_LIVE,
      g_param_spec_boolean ("is-live", "Is this a live source",
          "True if the element cannot produce data in PAUSED", FALSE,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));
  /**
   * GstFakeSrc:format
   *
   * Set the format of the newsegment events to produce.
   */
  g_object_class_install_property (gobject_class, PROP_FORMAT,
      g_param_spec_enum ("format", "Format",
          "The format of the segment events", GST_TYPE_FORMAT,
          DEFAULT_FORMAT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstFakeSrc::handoff:
   * @fakesrc: the fakesrc instance
   * @buffer: the buffer that will be pushed
   * @pad: the pad that will sent it
   *
   * This signal gets emitted before sending the buffer.
   */
  gst_fake_src_signals[SIGNAL_HANDOFF] =
      g_signal_new ("handoff", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstFakeSrcClass, handoff), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 2,
      GST_TYPE_BUFFER | G_SIGNAL_TYPE_STATIC_SCOPE, GST_TYPE_PAD);

  gst_element_class_set_static_metadata (gstelement_class,
      "Fake Source",
      "Source",
      "Push empty (no data) buffers around",
      "Erik Walthinsen <omega@cse.ogi.edu>, " "Wim Taymans <wim@fluendo.com>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));

  gstbase_src_class->is_seekable = GST_DEBUG_FUNCPTR (gst_fake_src_is_seekable);
  gstbase_src_class->start = GST_DEBUG_FUNCPTR (gst_fake_src_start);
  gstbase_src_class->stop = GST_DEBUG_FUNCPTR (gst_fake_src_stop);
  gstbase_src_class->event = GST_DEBUG_FUNCPTR (gst_fake_src_event_handler);
  gstbase_src_class->get_times = GST_DEBUG_FUNCPTR (gst_fake_src_get_times);
  gstbase_src_class->create = GST_DEBUG_FUNCPTR (gst_fake_src_create);
}

static void
gst_fake_src_init (GstFakeSrc * fakesrc)
{
  fakesrc->output = FAKE_SRC_FIRST_LAST_LOOP;
  fakesrc->silent = DEFAULT_SILENT;
  fakesrc->signal_handoffs = DEFAULT_SIGNAL_HANDOFFS;
  fakesrc->dump = DEFAULT_DUMP;
  fakesrc->pattern_byte = 0x00;
  fakesrc->data = FAKE_SRC_DATA_ALLOCATE;
  fakesrc->sizetype = FAKE_SRC_SIZETYPE_EMPTY;
  fakesrc->filltype = FAKE_SRC_FILLTYPE_NOTHING;
  fakesrc->sizemin = DEFAULT_SIZEMIN;
  fakesrc->sizemax = DEFAULT_SIZEMAX;
  fakesrc->parent = NULL;
  fakesrc->parentsize = DEFAULT_PARENTSIZE;
  fakesrc->last_message = NULL;
  fakesrc->datarate = DEFAULT_DATARATE;
  fakesrc->sync = DEFAULT_SYNC;
  fakesrc->format = DEFAULT_FORMAT;
}

static void
gst_fake_src_finalize (GObject * object)
{
  GstFakeSrc *src;

  src = GST_FAKE_SRC (object);

  g_free (src->last_message);
  if (src->parent) {
    gst_buffer_unref (src->parent);
    src->parent = NULL;
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_fake_src_event_handler (GstBaseSrc * basesrc, GstEvent * event)
{
  GstFakeSrc *src;

  src = GST_FAKE_SRC (basesrc);

  if (!src->silent) {
    const GstStructure *s;
    const gchar *tstr;
    gchar *sstr;

    GST_OBJECT_LOCK (src);
    g_free (src->last_message);

    tstr = gst_event_type_get_name (GST_EVENT_TYPE (event));

    if ((s = gst_event_get_structure (event)))
      sstr = gst_structure_to_string (s);
    else
      sstr = g_strdup ("");

    src->last_message =
        g_strdup_printf ("event   ******* (%s:%s) E (type: %s (%d), %s) %p",
        GST_DEBUG_PAD_NAME (GST_BASE_SRC_CAST (src)->srcpad),
        tstr, GST_EVENT_TYPE (event), sstr, event);
    g_free (sstr);
    GST_OBJECT_UNLOCK (src);

    g_object_notify_by_pspec ((GObject *) src, pspec_last_message);
  }

  return GST_BASE_SRC_CLASS (parent_class)->event (basesrc, event);
}

static void
gst_fake_src_alloc_parent (GstFakeSrc * src)
{
  GstBuffer *buf;

  buf = gst_buffer_new_allocate (NULL, src->parentsize, NULL);

  src->parent = buf;
  src->parentoffset = 0;
}

static void
gst_fake_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstFakeSrc *src;
  GstBaseSrc *basesrc;

  src = GST_FAKE_SRC (object);
  basesrc = GST_BASE_SRC (object);

  switch (prop_id) {
    case PROP_OUTPUT:
      g_warning ("not yet implemented");
      break;
    case PROP_DATA:
      src->data = (GstFakeSrcDataType) g_value_get_enum (value);

      if (src->data == FAKE_SRC_DATA_SUBBUFFER) {
        if (!src->parent)
          gst_fake_src_alloc_parent (src);
      } else {
        if (src->parent) {
          gst_buffer_unref (src->parent);
          src->parent = NULL;
        }
      }
      break;
    case PROP_SIZETYPE:
      src->sizetype = (GstFakeSrcSizeType) g_value_get_enum (value);
      break;
    case PROP_SIZEMIN:
      src->sizemin = g_value_get_int (value);
      break;
    case PROP_SIZEMAX:
      src->sizemax = g_value_get_int (value);
      break;
    case PROP_PARENTSIZE:
      src->parentsize = g_value_get_int (value);
      break;
    case PROP_FILLTYPE:
      src->filltype = (GstFakeSrcFillType) g_value_get_enum (value);
      break;
    case PROP_DATARATE:
      src->datarate = g_value_get_int (value);
      break;
    case PROP_SYNC:
      src->sync = g_value_get_boolean (value);
      break;
    case PROP_PATTERN:
      break;
    case PROP_SILENT:
      src->silent = g_value_get_boolean (value);
      break;
    case PROP_SIGNAL_HANDOFFS:
      src->signal_handoffs = g_value_get_boolean (value);
      break;
    case PROP_DUMP:
      src->dump = g_value_get_boolean (value);
      break;
    case PROP_CAN_ACTIVATE_PUSH:
      g_return_if_fail (!GST_OBJECT_FLAG_IS_SET (object,
              GST_BASE_SRC_FLAG_STARTED));
      GST_BASE_SRC (src)->can_activate_push = g_value_get_boolean (value);
      break;
    case PROP_CAN_ACTIVATE_PULL:
      g_return_if_fail (!GST_OBJECT_FLAG_IS_SET (object,
              GST_BASE_SRC_FLAG_STARTED));
      src->can_activate_pull = g_value_get_boolean (value);
      break;
    case PROP_IS_LIVE:
      gst_base_src_set_live (basesrc, g_value_get_boolean (value));
      break;
    case PROP_FORMAT:
      src->format = (GstFormat) g_value_get_enum (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fake_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstFakeSrc *src;
  GstBaseSrc *basesrc;

  g_return_if_fail (GST_IS_FAKE_SRC (object));

  src = GST_FAKE_SRC (object);
  basesrc = GST_BASE_SRC (object);

  switch (prop_id) {
    case PROP_OUTPUT:
      g_value_set_enum (value, src->output);
      break;
    case PROP_DATA:
      g_value_set_enum (value, src->data);
      break;
    case PROP_SIZETYPE:
      g_value_set_enum (value, src->sizetype);
      break;
    case PROP_SIZEMIN:
      g_value_set_int (value, src->sizemin);
      break;
    case PROP_SIZEMAX:
      g_value_set_int (value, src->sizemax);
      break;
    case PROP_PARENTSIZE:
      g_value_set_int (value, src->parentsize);
      break;
    case PROP_FILLTYPE:
      g_value_set_enum (value, src->filltype);
      break;
    case PROP_DATARATE:
      g_value_set_int (value, src->datarate);
      break;
    case PROP_SYNC:
      g_value_set_boolean (value, src->sync);
      break;
    case PROP_PATTERN:
      g_value_set_string (value, src->pattern);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, src->silent);
      break;
    case PROP_SIGNAL_HANDOFFS:
      g_value_set_boolean (value, src->signal_handoffs);
      break;
    case PROP_DUMP:
      g_value_set_boolean (value, src->dump);
      break;
    case PROP_LAST_MESSAGE:
      GST_OBJECT_LOCK (src);
      g_value_set_string (value, src->last_message);
      GST_OBJECT_UNLOCK (src);
      break;
    case PROP_CAN_ACTIVATE_PUSH:
      g_value_set_boolean (value, GST_BASE_SRC (src)->can_activate_push);
      break;
    case PROP_CAN_ACTIVATE_PULL:
      g_value_set_boolean (value, src->can_activate_pull);
      break;
    case PROP_IS_LIVE:
      g_value_set_boolean (value, gst_base_src_is_live (basesrc));
      break;
    case PROP_FORMAT:
      g_value_set_enum (value, src->format);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fake_src_prepare_buffer (GstFakeSrc * src, guint8 * data, gsize size)
{
  if (size == 0)
    return;

  switch (src->filltype) {
    case FAKE_SRC_FILLTYPE_ZERO:
      memset (data, 0, size);
      break;
    case FAKE_SRC_FILLTYPE_RANDOM:
    {
      gint i;
      guint8 *ptr = data;

      for (i = size; i; i--) {
        *ptr++ = g_random_int_range (0, 256);
      }
      break;
    }
    case FAKE_SRC_FILLTYPE_PATTERN:
      src->pattern_byte = 0x00;
    case FAKE_SRC_FILLTYPE_PATTERN_CONT:
    {
      gint i;
      guint8 *ptr = data;

      for (i = size; i; i--) {
        *ptr++ = src->pattern_byte++;
      }
      break;
    }
    case FAKE_SRC_FILLTYPE_NOTHING:
    default:
      break;
  }
}

static GstBuffer *
gst_fake_src_alloc_buffer (GstFakeSrc * src, guint size)
{
  GstBuffer *buf;
  gpointer data;
  gboolean do_prepare = FALSE;

  buf = gst_buffer_new ();

  if (size != 0) {
    switch (src->filltype) {
      case FAKE_SRC_FILLTYPE_NOTHING:
        data = g_malloc (size);
        break;
      case FAKE_SRC_FILLTYPE_ZERO:
        data = g_malloc0 (size);
        break;
      case FAKE_SRC_FILLTYPE_RANDOM:
      case FAKE_SRC_FILLTYPE_PATTERN:
      case FAKE_SRC_FILLTYPE_PATTERN_CONT:
      default:
        data = g_malloc (size);
        do_prepare = TRUE;
        break;
    }
    if (do_prepare)
      gst_fake_src_prepare_buffer (src, data, size);

    gst_buffer_append_memory (buf,
        gst_memory_new_wrapped (0, data, size, 0, size, data, g_free));
  }

  return buf;
}

static guint
gst_fake_src_get_size (GstFakeSrc * src)
{
  guint size;

  switch (src->sizetype) {
    case FAKE_SRC_SIZETYPE_FIXED:
      size = src->sizemax;
      break;
    case FAKE_SRC_SIZETYPE_RANDOM:
      size = g_random_int_range (src->sizemin, src->sizemax);
      break;
    case FAKE_SRC_SIZETYPE_EMPTY:
    default:
      size = 0;
      break;
  }

  return size;
}

static GstBuffer *
gst_fake_src_create_buffer (GstFakeSrc * src, gsize * bufsize)
{
  GstBuffer *buf;
  gsize size = gst_fake_src_get_size (src);
  gboolean dump = src->dump;
  GstMapInfo info;

  *bufsize = size;

  switch (src->data) {
    case FAKE_SRC_DATA_ALLOCATE:
      buf = gst_fake_src_alloc_buffer (src, size);
      break;
    case FAKE_SRC_DATA_SUBBUFFER:
      /* see if we have a parent to subbuffer */
      if (!src->parent) {
        gst_fake_src_alloc_parent (src);
        g_assert (src->parent);
      }
      /* see if it's large enough */
      if ((src->parentsize - src->parentoffset) >= size) {
        buf =
            gst_buffer_copy_region (src->parent, GST_BUFFER_COPY_ALL,
            src->parentoffset, size);
        src->parentoffset += size;
      } else {
        /* the parent is useless now */
        gst_buffer_unref (src->parent);
        src->parent = NULL;
        /* try again (this will allocate a new parent) */
        return gst_fake_src_create_buffer (src, bufsize);
      }
      gst_buffer_map (buf, &info, GST_MAP_WRITE);
      gst_fake_src_prepare_buffer (src, info.data, info.size);
      gst_buffer_unmap (buf, &info);
      break;
    default:
      g_warning ("fakesrc: dunno how to allocate buffers !");
      buf = gst_buffer_new ();
      break;
  }
  if (dump) {
    gst_buffer_map (buf, &info, GST_MAP_READ);
    gst_util_dump_mem (info.data, info.size);
    gst_buffer_unmap (buf, &info);
  }

  return buf;
}

static void
gst_fake_src_get_times (GstBaseSrc * basesrc, GstBuffer * buffer,
    GstClockTime * start, GstClockTime * end)
{
  GstFakeSrc *src;

  src = GST_FAKE_SRC (basesrc);

  /* sync on the timestamp of the buffer if requested. */
  if (src->sync) {
    GstClockTime timestamp, duration;

    /* first sync on DTS, else use PTS */
    timestamp = GST_BUFFER_DTS (buffer);
    if (!GST_CLOCK_TIME_IS_VALID (timestamp))
      timestamp = GST_BUFFER_PTS (buffer);

    if (GST_CLOCK_TIME_IS_VALID (timestamp)) {
      /* get duration to calculate end time */
      duration = GST_BUFFER_DURATION (buffer);
      if (GST_CLOCK_TIME_IS_VALID (duration)) {
        *end = timestamp + duration;
      }
      *start = timestamp;
    }
  } else {
    *start = -1;
    *end = -1;
  }
}

static GstFlowReturn
gst_fake_src_create (GstBaseSrc * basesrc, guint64 offset, guint length,
    GstBuffer ** ret)
{
  GstFakeSrc *src;
  GstBuffer *buf;
  GstClockTime time;
  gsize size;

  src = GST_FAKE_SRC (basesrc);

  buf = gst_fake_src_create_buffer (src, &size);
  GST_BUFFER_OFFSET (buf) = offset;

  if (src->datarate > 0) {
    time = (src->bytes_sent * GST_SECOND) / src->datarate;

    GST_BUFFER_DURATION (buf) = size * GST_SECOND / src->datarate;
  } else if (gst_base_src_is_live (basesrc)) {
    GstClock *clock;

    clock = gst_element_get_clock (GST_ELEMENT (src));

    if (clock) {
      time = gst_clock_get_time (clock);
      time -= gst_element_get_base_time (GST_ELEMENT (src));
      gst_object_unref (clock);
    } else {
      /* not an error not to have a clock */
      time = GST_CLOCK_TIME_NONE;
    }
  } else {
    time = GST_CLOCK_TIME_NONE;
  }

  GST_BUFFER_DTS (buf) = time;
  GST_BUFFER_PTS (buf) = time;

  if (!src->silent) {
    gchar dts_str[64], pts_str[64], dur_str[64];
    gchar *flag_str;

    GST_OBJECT_LOCK (src);
    g_free (src->last_message);

    if (GST_BUFFER_DTS (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (dts_str, sizeof (dts_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_DTS (buf)));
    } else {
      g_strlcpy (dts_str, "none", sizeof (dts_str));
    }
    if (GST_BUFFER_PTS (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (pts_str, sizeof (pts_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_PTS (buf)));
    } else {
      g_strlcpy (pts_str, "none", sizeof (pts_str));
    }
    if (GST_BUFFER_DURATION (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (dur_str, sizeof (dur_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_DURATION (buf)));
    } else {
      g_strlcpy (dur_str, "none", sizeof (dur_str));
    }

    flag_str = gst_buffer_get_flags_string (buf);
    src->last_message =
        g_strdup_printf ("create   ******* (%s:%s) (%u bytes, dts: %s, pts:%s"
        ", duration: %s, offset: %" G_GINT64_FORMAT ", offset_end: %"
        G_GINT64_FORMAT ", flags: %08x %s) %p",
        GST_DEBUG_PAD_NAME (GST_BASE_SRC_CAST (src)->srcpad), (guint) size,
        dts_str, pts_str, dur_str, GST_BUFFER_OFFSET (buf),
        GST_BUFFER_OFFSET_END (buf), GST_MINI_OBJECT_CAST (buf)->flags,
        flag_str, buf);
    g_free (flag_str);
    GST_OBJECT_UNLOCK (src);

    g_object_notify_by_pspec ((GObject *) src, pspec_last_message);
  }

  if (src->signal_handoffs) {
    GST_LOG_OBJECT (src, "pre handoff emit");
    g_signal_emit (src, gst_fake_src_signals[SIGNAL_HANDOFF], 0, buf,
        basesrc->srcpad);
    GST_LOG_OBJECT (src, "post handoff emit");
  }

  src->bytes_sent += size;

  *ret = buf;
  return GST_FLOW_OK;
}

static gboolean
gst_fake_src_start (GstBaseSrc * basesrc)
{
  GstFakeSrc *src;

  src = GST_FAKE_SRC (basesrc);

  src->pattern_byte = 0x00;
  src->bytes_sent = 0;

  gst_base_src_set_format (basesrc, src->format);

  return TRUE;
}

static gboolean
gst_fake_src_stop (GstBaseSrc * basesrc)
{
  GstFakeSrc *src;

  src = GST_FAKE_SRC (basesrc);

  GST_OBJECT_LOCK (src);
  if (src->parent) {
    gst_buffer_unref (src->parent);
    src->parent = NULL;
  }
  g_free (src->last_message);
  src->last_message = NULL;
  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

static gboolean
gst_fake_src_is_seekable (GstBaseSrc * basesrc)
{
  GstFakeSrc *src = GST_FAKE_SRC (basesrc);

  return src->can_activate_pull;
}
