/* GStreamer
 * Copyright (C) 2004 Wim Taymans <wim@fluendo.com>
 *
 * gstmessage.c: GstMessage subsystem
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
 * SECTION:gstmessage
 * @short_description: Lightweight objects to signal the application of
 *                     pipeline events
 * @see_also: #GstBus, #GstMiniObject, #GstElement
 *
 * Messages are implemented as a subclass of #GstMiniObject with a generic
 * #GstStructure as the content. This allows for writing custom messages without
 * requiring an API change while allowing a wide range of different types
 * of messages.
 *
 * Messages are posted by objects in the pipeline and are passed to the
 * application using the #GstBus.
 *
 * The basic use pattern of posting a message on a #GstBus is as follows:
 * |[
 *   gst_bus_post (bus, gst_message_new_eos());
 * ]|
 *
 * A #GstElement usually posts messages on the bus provided by the parent
 * container using gst_element_post_message().
 */


#include "gst_private.h"
#include <string.h>             /* memcpy */
#include "gsterror.h"
#include "gstenumtypes.h"
#include "gstinfo.h"
#include "gstmessage.h"
#include "gsttaglist.h"
#include "gstutils.h"
#include "gstquark.h"


typedef struct
{
  GstMessage message;

  GstStructure *structure;
} GstMessageImpl;

#define GST_MESSAGE_STRUCTURE(m)  (((GstMessageImpl *)(m))->structure)

typedef struct
{
  const gint type;
  const gchar *name;
  GQuark quark;
} GstMessageQuarks;

static GstMessageQuarks message_quarks[] = {
  {GST_MESSAGE_UNKNOWN, "unknown", 0},
  {GST_MESSAGE_EOS, "eos", 0},
  {GST_MESSAGE_ERROR, "error", 0},
  {GST_MESSAGE_WARNING, "warning", 0},
  {GST_MESSAGE_INFO, "info", 0},
  {GST_MESSAGE_TAG, "tag", 0},
  {GST_MESSAGE_BUFFERING, "buffering", 0},
  {GST_MESSAGE_STATE_CHANGED, "state-changed", 0},
  {GST_MESSAGE_STATE_DIRTY, "state-dirty", 0},
  {GST_MESSAGE_STEP_DONE, "step-done", 0},
  {GST_MESSAGE_CLOCK_PROVIDE, "clock-provide", 0},
  {GST_MESSAGE_CLOCK_LOST, "clock-lost", 0},
  {GST_MESSAGE_NEW_CLOCK, "new-clock", 0},
  {GST_MESSAGE_STRUCTURE_CHANGE, "structure-change", 0},
  {GST_MESSAGE_STREAM_STATUS, "stream-status", 0},
  {GST_MESSAGE_APPLICATION, "application", 0},
  {GST_MESSAGE_ELEMENT, "element", 0},
  {GST_MESSAGE_SEGMENT_START, "segment-start", 0},
  {GST_MESSAGE_SEGMENT_DONE, "segment-done", 0},
  {GST_MESSAGE_DURATION_CHANGED, "duration-changed", 0},
  {GST_MESSAGE_LATENCY, "latency", 0},
  {GST_MESSAGE_ASYNC_START, "async-start", 0},
  {GST_MESSAGE_ASYNC_DONE, "async-done", 0},
  {GST_MESSAGE_REQUEST_STATE, "request-state", 0},
  {GST_MESSAGE_STEP_START, "step-start", 0},
  {GST_MESSAGE_QOS, "qos", 0},
  {GST_MESSAGE_PROGRESS, "progress", 0},
  {GST_MESSAGE_TOC, "toc", 0},
  {GST_MESSAGE_RESET_TIME, "reset-time", 0},
  {GST_MESSAGE_STREAM_START, "stream-start", 0},
  {GST_MESSAGE_NEED_CONTEXT, "need-context", 0},
  {GST_MESSAGE_HAVE_CONTEXT, "have-context", 0},
  {GST_MESSAGE_DEVICE_ADDED, "device-added", 0},
  {GST_MESSAGE_DEVICE_REMOVED, "device-removed", 0},
  {0, NULL, 0}
};

GType _gst_message_type = 0;
GST_DEFINE_MINI_OBJECT_TYPE (GstMessage, gst_message);

void
_priv_gst_message_initialize (void)
{
  gint i;

  GST_CAT_INFO (GST_CAT_GST_INIT, "init messages");

  /* the GstMiniObject types need to be class_ref'd once before it can be
   * done from multiple threads;
   * see http://bugzilla.gnome.org/show_bug.cgi?id=304551 */
  gst_message_get_type ();

  for (i = 0; message_quarks[i].name; i++) {
    message_quarks[i].quark =
        g_quark_from_static_string (message_quarks[i].name);
  }

  _gst_message_type = gst_message_get_type ();
}

/**
 * gst_message_type_get_name:
 * @type: the message type
 *
 * Get a printable name for the given message type. Do not modify or free.
 *
 * Returns: a reference to the static name of the message.
 */
const gchar *
gst_message_type_get_name (GstMessageType type)
{
  gint i;

  for (i = 0; message_quarks[i].name; i++) {
    if (type == message_quarks[i].type)
      return message_quarks[i].name;
  }
  return "unknown";
}

/**
 * gst_message_type_to_quark:
 * @type: the message type
 *
 * Get the unique quark for the given message type.
 *
 * Returns: the quark associated with the message type
 */
GQuark
gst_message_type_to_quark (GstMessageType type)
{
  gint i;

  for (i = 0; message_quarks[i].name; i++) {
    if (type == message_quarks[i].type)
      return message_quarks[i].quark;
  }
  return 0;
}

static void
_gst_message_free (GstMessage * message)
{
  GstStructure *structure;

  g_return_if_fail (message != NULL);

  GST_CAT_LOG (GST_CAT_MESSAGE, "finalize message %p, %s from %s", message,
      GST_MESSAGE_TYPE_NAME (message), GST_MESSAGE_SRC_NAME (message));

  if (GST_MESSAGE_SRC (message)) {
    gst_object_unref (GST_MESSAGE_SRC (message));
    GST_MESSAGE_SRC (message) = NULL;
  }

  if (message->lock.p) {
    GST_MESSAGE_LOCK (message);
    GST_MESSAGE_SIGNAL (message);
    GST_MESSAGE_UNLOCK (message);
  }

  structure = GST_MESSAGE_STRUCTURE (message);
  if (structure) {
    gst_structure_set_parent_refcount (structure, NULL);
    gst_structure_free (structure);
  }

  g_slice_free1 (sizeof (GstMessageImpl), message);
}

static void
gst_message_init (GstMessageImpl * message, GstMessageType type,
    GstObject * src);

static GstMessage *
_gst_message_copy (GstMessage * message)
{
  GstMessageImpl *copy;
  GstStructure *structure;

  GST_CAT_LOG (GST_CAT_MESSAGE, "copy message %p, %s from %s", message,
      GST_MESSAGE_TYPE_NAME (message),
      GST_OBJECT_NAME (GST_MESSAGE_SRC (message)));

  copy = g_slice_new0 (GstMessageImpl);

  gst_message_init (copy, GST_MESSAGE_TYPE (message),
      GST_MESSAGE_SRC (message));

  GST_MESSAGE_TIMESTAMP (copy) = GST_MESSAGE_TIMESTAMP (message);
  GST_MESSAGE_SEQNUM (copy) = GST_MESSAGE_SEQNUM (message);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (structure) {
    GST_MESSAGE_STRUCTURE (copy) = gst_structure_copy (structure);
    gst_structure_set_parent_refcount (GST_MESSAGE_STRUCTURE (copy),
        &copy->message.mini_object.refcount);
  } else {
    GST_MESSAGE_STRUCTURE (copy) = NULL;
  }

  return GST_MESSAGE_CAST (copy);
}

static void
gst_message_init (GstMessageImpl * message, GstMessageType type,
    GstObject * src)
{
  gst_mini_object_init (GST_MINI_OBJECT_CAST (message), 0, _gst_message_type,
      (GstMiniObjectCopyFunction) _gst_message_copy, NULL,
      (GstMiniObjectFreeFunction) _gst_message_free);

  GST_MESSAGE_TYPE (message) = type;
  if (src)
    gst_object_ref (src);
  GST_MESSAGE_SRC (message) = src;
  GST_MESSAGE_TIMESTAMP (message) = GST_CLOCK_TIME_NONE;
  GST_MESSAGE_SEQNUM (message) = gst_util_seqnum_next ();
}


/**
 * gst_message_new_custom:
 * @type: The #GstMessageType to distinguish messages
 * @src: The object originating the message.
 * @structure: (transfer full) (allow-none): the structure for the
 *     message. The message will take ownership of the structure.
 *
 * Create a new custom-typed message. This can be used for anything not
 * handled by other message-specific functions to pass a message to the
 * app. The structure field can be %NULL.
 *
 * Returns: (transfer full): The new message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_custom (GstMessageType type, GstObject * src,
    GstStructure * structure)
{
  GstMessageImpl *message;

  message = g_slice_new0 (GstMessageImpl);

  GST_CAT_LOG (GST_CAT_MESSAGE, "source %s: creating new message %p %s",
      (src ? GST_OBJECT_NAME (src) : "NULL"), message,
      gst_message_type_get_name (type));

  if (structure) {
    /* structure must not have a parent */
    if (!gst_structure_set_parent_refcount (structure,
            &message->message.mini_object.refcount))
      goto had_parent;
  }
  gst_message_init (message, type, src);

  GST_MESSAGE_STRUCTURE (message) = structure;

  return GST_MESSAGE_CAST (message);

  /* ERRORS */
had_parent:
  {
    g_slice_free1 (sizeof (GstMessageImpl), message);
    g_warning ("structure is already owned by another object");
    return NULL;
  }
}

/**
 * gst_message_get_seqnum:
 * @message: A #GstMessage.
 *
 * Retrieve the sequence number of a message.
 *
 * Messages have ever-incrementing sequence numbers, which may also be set
 * explicitly via gst_message_set_seqnum(). Sequence numbers are typically used
 * to indicate that a message corresponds to some other set of messages or
 * events, for example a SEGMENT_DONE message corresponding to a SEEK event. It
 * is considered good practice to make this correspondence when possible, though
 * it is not required.
 *
 * Note that events and messages share the same sequence number incrementor;
 * two events or messages will never have the same sequence number unless
 * that correspondence was made explicitly.
 *
 * Returns: The message's sequence number.
 *
 * MT safe.
 */
guint32
gst_message_get_seqnum (GstMessage * message)
{
  g_return_val_if_fail (GST_IS_MESSAGE (message), -1);

  return GST_MESSAGE_SEQNUM (message);
}

/**
 * gst_message_set_seqnum:
 * @message: A #GstMessage.
 * @seqnum: A sequence number.
 *
 * Set the sequence number of a message.
 *
 * This function might be called by the creator of a message to indicate that
 * the message relates to other messages or events. See gst_message_get_seqnum()
 * for more information.
 *
 * MT safe.
 */
void
gst_message_set_seqnum (GstMessage * message, guint32 seqnum)
{
  g_return_if_fail (GST_IS_MESSAGE (message));

  GST_MESSAGE_SEQNUM (message) = seqnum;
}

/**
 * gst_message_new_eos:
 * @src: (transfer none): The object originating the message.
 *
 * Create a new eos message. This message is generated and posted in
 * the sink elements of a GstBin. The bin will only forward the EOS
 * message to the application if all sinks have posted an EOS message.
 *
 * Returns: (transfer full): The new eos message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_eos (GstObject * src)
{
  GstMessage *message;

  message = gst_message_new_custom (GST_MESSAGE_EOS, src, NULL);

  return message;
}

/**
 * gst_message_new_error:
 * @src: (transfer none): The object originating the message.
 * @error: (transfer none): The GError for this message.
 * @debug: A debugging string.
 *
 * Create a new error message. The message will copy @error and
 * @debug. This message is posted by element when a fatal event
 * occurred. The pipeline will probably (partially) stop. The application
 * receiving this message should stop the pipeline.
 *
 * Returns: (transfer full): the new error message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_error (GstObject * src, GError * error, const gchar * debug)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_ERROR),
      GST_QUARK (GERROR), G_TYPE_ERROR, error,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
  message = gst_message_new_custom (GST_MESSAGE_ERROR, src, structure);

  return message;
}

/**
 * gst_message_new_warning:
 * @src: (transfer none): The object originating the message.
 * @error: (transfer none): The GError for this message.
 * @debug: A debugging string.
 *
 * Create a new warning message. The message will make copies of @error and
 * @debug.
 *
 * Returns: (transfer full): The new warning message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_warning (GstObject * src, GError * error, const gchar * debug)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_WARNING),
      GST_QUARK (GERROR), G_TYPE_ERROR, error,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
  message = gst_message_new_custom (GST_MESSAGE_WARNING, src, structure);

  return message;
}

/**
 * gst_message_new_info:
 * @src: (transfer none): The object originating the message.
 * @error: (transfer none): The GError for this message.
 * @debug: A debugging string.
 *
 * Create a new info message. The message will make copies of @error and
 * @debug.
 *
 * MT safe.
 *
 * Returns: (transfer full): the new info message.
 */
GstMessage *
gst_message_new_info (GstObject * src, GError * error, const gchar * debug)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_INFO),
      GST_QUARK (GERROR), G_TYPE_ERROR, error,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
  message = gst_message_new_custom (GST_MESSAGE_INFO, src, structure);

  return message;
}

/**
 * gst_message_new_tag:
 * @src: (transfer none): The object originating the message.
 * @tag_list: (transfer full): the tag list for the message.
 *
 * Create a new tag message. The message will take ownership of the tag list.
 * The message is posted by elements that discovered a new taglist.
 *
 * Returns: (transfer full): the new tag message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_tag (GstObject * src, GstTagList * tag_list)
{
  GstStructure *s;
  GstMessage *message;
  GValue val = G_VALUE_INIT;

  g_return_val_if_fail (GST_IS_TAG_LIST (tag_list), NULL);

  s = gst_structure_new_id_empty (GST_QUARK (MESSAGE_TAG));
  g_value_init (&val, GST_TYPE_TAG_LIST);
  g_value_take_boxed (&val, tag_list);
  gst_structure_id_take_value (s, GST_QUARK (TAGLIST), &val);
  message = gst_message_new_custom (GST_MESSAGE_TAG, src, s);
  return message;
}

/**
 * gst_message_new_buffering:
 * @src: (transfer none): The object originating the message.
 * @percent: The buffering percent
 *
 * Create a new buffering message. This message can be posted by an element that
 * needs to buffer data before it can continue processing. @percent should be a
 * value between 0 and 100. A value of 100 means that the buffering completed.
 *
 * When @percent is < 100 the application should PAUSE a PLAYING pipeline. When
 * @percent is 100, the application can set the pipeline (back) to PLAYING.
 * The application must be prepared to receive BUFFERING messages in the
 * PREROLLING state and may only set the pipeline to PLAYING after receiving a
 * message with @percent set to 100, which can happen after the pipeline
 * completed prerolling.
 *
 * MT safe.
 *
 * Returns: (transfer full): The new buffering message.
 */
GstMessage *
gst_message_new_buffering (GstObject * src, gint percent)
{
  GstMessage *message;
  GstStructure *structure;
  gint64 buffering_left;

  g_return_val_if_fail (percent >= 0 && percent <= 100, NULL);

  buffering_left = (percent == 100 ? 0 : -1);

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_BUFFERING),
      GST_QUARK (BUFFER_PERCENT), G_TYPE_INT, percent,
      GST_QUARK (BUFFERING_MODE), GST_TYPE_BUFFERING_MODE, GST_BUFFERING_STREAM,
      GST_QUARK (AVG_IN_RATE), G_TYPE_INT, -1,
      GST_QUARK (AVG_OUT_RATE), G_TYPE_INT, -1,
      GST_QUARK (BUFFERING_LEFT), G_TYPE_INT64, buffering_left, NULL);
  message = gst_message_new_custom (GST_MESSAGE_BUFFERING, src, structure);

  return message;
}

/**
 * gst_message_new_state_changed:
 * @src: (transfer none): the object originating the message
 * @oldstate: the previous state
 * @newstate: the new (current) state
 * @pending: the pending (target) state
 *
 * Create a state change message. This message is posted whenever an element
 * changed its state.
 *
 * Returns: (transfer full): the new state change message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_state_changed (GstObject * src,
    GstState oldstate, GstState newstate, GstState pending)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_STATE_CHANGED),
      GST_QUARK (OLD_STATE), GST_TYPE_STATE, (gint) oldstate,
      GST_QUARK (NEW_STATE), GST_TYPE_STATE, (gint) newstate,
      GST_QUARK (PENDING_STATE), GST_TYPE_STATE, (gint) pending, NULL);
  message = gst_message_new_custom (GST_MESSAGE_STATE_CHANGED, src, structure);

  return message;
}

/**
 * gst_message_new_state_dirty:
 * @src: (transfer none): the object originating the message
 *
 * Create a state dirty message. This message is posted whenever an element
 * changed its state asynchronously and is used internally to update the
 * states of container objects.
 *
 * Returns: (transfer full): the new state dirty message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_state_dirty (GstObject * src)
{
  GstMessage *message;

  message = gst_message_new_custom (GST_MESSAGE_STATE_DIRTY, src, NULL);

  return message;
}

/**
 * gst_message_new_clock_provide:
 * @src: (transfer none): the object originating the message.
 * @clock: (transfer none): the clock it provides
 * @ready: %TRUE if the sender can provide a clock
 *
 * Create a clock provide message. This message is posted whenever an
 * element is ready to provide a clock or lost its ability to provide
 * a clock (maybe because it paused or became EOS).
 *
 * This message is mainly used internally to manage the clock
 * selection.
 *
 * Returns: (transfer full): the new provide clock message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_clock_provide (GstObject * src, GstClock * clock,
    gboolean ready)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_CLOCK_PROVIDE),
      GST_QUARK (CLOCK), GST_TYPE_CLOCK, clock,
      GST_QUARK (READY), G_TYPE_BOOLEAN, ready, NULL);
  message = gst_message_new_custom (GST_MESSAGE_CLOCK_PROVIDE, src, structure);

  return message;
}

/**
 * gst_message_new_clock_lost:
 * @src: (transfer none): the object originating the message.
 * @clock: (transfer none): the clock that was lost
 *
 * Create a clock lost message. This message is posted whenever the
 * clock is not valid anymore.
 *
 * If this message is posted by the pipeline, the pipeline will
 * select a new clock again when it goes to PLAYING. It might therefore
 * be needed to set the pipeline to PAUSED and PLAYING again.
 *
 * Returns: (transfer full): The new clock lost message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_clock_lost (GstObject * src, GstClock * clock)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_CLOCK_LOST),
      GST_QUARK (CLOCK), GST_TYPE_CLOCK, clock, NULL);
  message = gst_message_new_custom (GST_MESSAGE_CLOCK_LOST, src, structure);

  return message;
}

/**
 * gst_message_new_new_clock:
 * @src: (transfer none): The object originating the message.
 * @clock: (transfer none): the new selected clock
 *
 * Create a new clock message. This message is posted whenever the
 * pipeline selects a new clock for the pipeline.
 *
 * Returns: (transfer full): The new new clock message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_new_clock (GstObject * src, GstClock * clock)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_NEW_CLOCK),
      GST_QUARK (CLOCK), GST_TYPE_CLOCK, clock, NULL);
  message = gst_message_new_custom (GST_MESSAGE_NEW_CLOCK, src, structure);

  return message;
}

/**
 * gst_message_new_structure_change:
 * @src: (transfer none): The object originating the message.
 * @type: The change type.
 * @owner: (transfer none): The owner element of @src.
 * @busy: Whether the structure change is busy.
 *
 * Create a new structure change message. This message is posted when the
 * structure of a pipeline is in the process of being changed, for example
 * when pads are linked or unlinked.
 *
 * @src should be the sinkpad that unlinked or linked.
 *
 * Returns: (transfer full): the new structure change message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_structure_change (GstObject * src, GstStructureChangeType type,
    GstElement * owner, gboolean busy)
{
  GstMessage *message;
  GstStructure *structure;

  g_return_val_if_fail (GST_IS_PAD (src), NULL);
  /* g_return_val_if_fail (GST_PAD_DIRECTION (src) == GST_PAD_SINK, NULL); */
  g_return_val_if_fail (GST_IS_ELEMENT (owner), NULL);

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_STRUCTURE_CHANGE),
      GST_QUARK (TYPE), GST_TYPE_STRUCTURE_CHANGE_TYPE, type,
      GST_QUARK (OWNER), GST_TYPE_ELEMENT, owner,
      GST_QUARK (BUSY), G_TYPE_BOOLEAN, busy, NULL);

  message = gst_message_new_custom (GST_MESSAGE_STRUCTURE_CHANGE, src,
      structure);

  return message;
}

/**
 * gst_message_new_segment_start:
 * @src: (transfer none): The object originating the message.
 * @format: The format of the position being played
 * @position: The position of the segment being played
 *
 * Create a new segment message. This message is posted by elements that
 * start playback of a segment as a result of a segment seek. This message
 * is not received by the application but is used for maintenance reasons in
 * container elements.
 *
 * Returns: (transfer full): the new segment start message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_segment_start (GstObject * src, GstFormat format,
    gint64 position)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_SEGMENT_START),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (POSITION), G_TYPE_INT64, position, NULL);
  message = gst_message_new_custom (GST_MESSAGE_SEGMENT_START, src, structure);

  return message;
}

/**
 * gst_message_new_segment_done:
 * @src: (transfer none): the object originating the message.
 * @format: The format of the position being done
 * @position: The position of the segment being done
 *
 * Create a new segment done message. This message is posted by elements that
 * finish playback of a segment as a result of a segment seek. This message
 * is received by the application after all elements that posted a segment_start
 * have posted the segment_done.
 *
 * Returns: (transfer full): the new segment done message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_segment_done (GstObject * src, GstFormat format,
    gint64 position)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_SEGMENT_DONE),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (POSITION), G_TYPE_INT64, position, NULL);
  message = gst_message_new_custom (GST_MESSAGE_SEGMENT_DONE, src, structure);

  return message;
}

/**
 * gst_message_new_application:
 * @src: (transfer none): the object originating the message.
 * @structure: (transfer full): the structure for the message. The message
 *     will take ownership of the structure.
 *
 * Create a new application-typed message. GStreamer will never create these
 * messages; they are a gift from us to you. Enjoy.
 *
 * Returns: (transfer full): The new application message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_application (GstObject * src, GstStructure * structure)
{
  g_return_val_if_fail (structure != NULL, NULL);

  return gst_message_new_custom (GST_MESSAGE_APPLICATION, src, structure);
}

/**
 * gst_message_new_element:
 * @src: (transfer none): The object originating the message.
 * @structure: (transfer full): The structure for the
 *     message. The message will take ownership of the structure.
 *
 * Create a new element-specific message. This is meant as a generic way of
 * allowing one-way communication from an element to an application, for example
 * "the firewire cable was unplugged". The format of the message should be
 * documented in the element's documentation. The structure field can be %NULL.
 *
 * Returns: (transfer full): The new element message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_element (GstObject * src, GstStructure * structure)
{
  g_return_val_if_fail (structure != NULL, NULL);

  return gst_message_new_custom (GST_MESSAGE_ELEMENT, src, structure);
}

/**
 * gst_message_new_duration_changed:
 * @src: (transfer none): The object originating the message.
 *
 * Create a new duration changed message. This message is posted by elements
 * that know the duration of a stream when the duration changes. This message
 * is received by bins and is used to calculate the total duration of a
 * pipeline. Elements may post a duration message with a duration of
 * GST_CLOCK_TIME_NONE to indicate that the duration has changed and the 
 * cached duration should be discarded. The new duration can then be 
 * retrieved via a query.
 *
 * Returns: (transfer full): The new duration-changed message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_duration_changed (GstObject * src)
{
  GstMessage *message;

  message = gst_message_new_custom (GST_MESSAGE_DURATION_CHANGED, src,
      gst_structure_new_id_empty (GST_QUARK (MESSAGE_DURATION_CHANGED)));

  return message;
}

/**
 * gst_message_new_async_start:
 * @src: (transfer none): The object originating the message.
 *
 * This message is posted by elements when they start an ASYNC state change.
 *
 * Returns: (transfer full): The new async_start message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_async_start (GstObject * src)
{
  GstMessage *message;

  message = gst_message_new_custom (GST_MESSAGE_ASYNC_START, src, NULL);

  return message;
}

/**
 * gst_message_new_async_done:
 * @src: (transfer none): The object originating the message.
 * @running_time: the desired running_time
 *
 * The message is posted when elements completed an ASYNC state change.
 * @running_time contains the time of the desired running_time when this
 * elements goes to PLAYING. A value of #GST_CLOCK_TIME_NONE for @running_time
 * means that the element has no clock interaction and thus doesn't care about
 * the running_time of the pipeline.
 *
 * Returns: (transfer full): The new async_done message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_async_done (GstObject * src, GstClockTime running_time)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_ASYNC_DONE),
      GST_QUARK (RUNNING_TIME), G_TYPE_UINT64, running_time, NULL);
  message = gst_message_new_custom (GST_MESSAGE_ASYNC_DONE, src, structure);

  return message;
}

/**
 * gst_message_new_latency:
 * @src: (transfer none): The object originating the message.
 *
 * This message can be posted by elements when their latency requirements have
 * changed.
 *
 * Returns: (transfer full): The new latency message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_latency (GstObject * src)
{
  GstMessage *message;

  message = gst_message_new_custom (GST_MESSAGE_LATENCY, src, NULL);

  return message;
}

/**
 * gst_message_new_request_state:
 * @src: (transfer none): the object originating the message.
 * @state: The new requested state
 *
 * This message can be posted by elements when they want to have their state
 * changed. A typical use case would be an audio server that wants to pause the
 * pipeline because a higher priority stream is being played.
 *
 * Returns: (transfer full): the new request state message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_request_state (GstObject * src, GstState state)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_REQUEST_STATE),
      GST_QUARK (NEW_STATE), GST_TYPE_STATE, (gint) state, NULL);
  message = gst_message_new_custom (GST_MESSAGE_REQUEST_STATE, src, structure);

  return message;
}

/**
 * gst_message_get_structure:
 * @message: The #GstMessage.
 *
 * Access the structure of the message.
 *
 * Returns: (transfer none): The structure of the message. The structure is
 * still owned by the message, which means that you should not free it and
 * that the pointer becomes invalid when you free the message.
 *
 * MT safe.
 */
const GstStructure *
gst_message_get_structure (GstMessage * message)
{
  g_return_val_if_fail (GST_IS_MESSAGE (message), NULL);

  return GST_MESSAGE_STRUCTURE (message);
}

/**
 * gst_message_has_name:
 * @message: The #GstMessage.
 * @name: name to check
 *
 * Checks if @message has the given @name. This function is usually used to
 * check the name of a custom message.
 *
 * Returns: %TRUE if @name matches the name of the message structure.
 */
gboolean
gst_message_has_name (GstMessage * message, const gchar * name)
{
  GstStructure *structure;

  g_return_val_if_fail (GST_IS_MESSAGE (message), FALSE);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (structure == NULL)
    return FALSE;

  return gst_structure_has_name (structure, name);
}

/**
 * gst_message_parse_tag:
 * @message: A valid #GstMessage of type GST_MESSAGE_TAG.
 * @tag_list: (out callee-allocates): return location for the tag-list.
 *
 * Extracts the tag list from the GstMessage. The tag list returned in the
 * output argument is a copy; the caller must free it when done.
 *
 * Typical usage of this function might be:
 * |[
 *   ...
 *   switch (GST_MESSAGE_TYPE (msg)) {
 *     case GST_MESSAGE_TAG: {
 *       GstTagList *tags = NULL;
 *       
 *       gst_message_parse_tag (msg, &amp;tags);
 *       g_print ("Got tags from element %s\n", GST_OBJECT_NAME (msg->src));
 *       handle_tags (tags);
 *       gst_tag_list_unref (tags);
 *       break;
 *     }
 *     ...
 *   }
 *   ...
 * ]|
 *
 * MT safe.
 */
void
gst_message_parse_tag (GstMessage * message, GstTagList ** tag_list)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_TAG);
  g_return_if_fail (tag_list != NULL);

  gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (TAGLIST), GST_TYPE_TAG_LIST, tag_list, NULL);
}

/**
 * gst_message_parse_buffering:
 * @message: A valid #GstMessage of type GST_MESSAGE_BUFFERING.
 * @percent: (out) (allow-none): Return location for the percent.
 *
 * Extracts the buffering percent from the GstMessage. see also
 * gst_message_new_buffering().
 *
 * MT safe.
 */
void
gst_message_parse_buffering (GstMessage * message, gint * percent)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_BUFFERING);

  if (percent)
    *percent =
        g_value_get_int (gst_structure_id_get_value (GST_MESSAGE_STRUCTURE
            (message), GST_QUARK (BUFFER_PERCENT)));
}

/**
 * gst_message_set_buffering_stats:
 * @message: A valid #GstMessage of type GST_MESSAGE_BUFFERING.
 * @mode: a buffering mode 
 * @avg_in: the average input rate
 * @avg_out: the average output rate
 * @buffering_left: amount of buffering time left in milliseconds
 *
 * Configures the buffering stats values in @message.
 */
void
gst_message_set_buffering_stats (GstMessage * message, GstBufferingMode mode,
    gint avg_in, gint avg_out, gint64 buffering_left)
{
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_BUFFERING);

  gst_structure_id_set (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (BUFFERING_MODE), GST_TYPE_BUFFERING_MODE, mode,
      GST_QUARK (AVG_IN_RATE), G_TYPE_INT, avg_in,
      GST_QUARK (AVG_OUT_RATE), G_TYPE_INT, avg_out,
      GST_QUARK (BUFFERING_LEFT), G_TYPE_INT64, buffering_left, NULL);
}

/**
 * gst_message_parse_buffering_stats:
 * @message: A valid #GstMessage of type GST_MESSAGE_BUFFERING.
 * @mode: (out) (allow-none): a buffering mode, or %NULL
 * @avg_in: (out) (allow-none): the average input rate, or %NULL
 * @avg_out: (out) (allow-none): the average output rate, or %NULL
 * @buffering_left: (out) (allow-none): amount of buffering time left in
 *     milliseconds, or %NULL
 *
 * Extracts the buffering stats values from @message.
 */
void
gst_message_parse_buffering_stats (GstMessage * message,
    GstBufferingMode * mode, gint * avg_in, gint * avg_out,
    gint64 * buffering_left)
{
  GstStructure *structure;

  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_BUFFERING);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (mode)
    *mode = (GstBufferingMode)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (BUFFERING_MODE)));
  if (avg_in)
    *avg_in = g_value_get_int (gst_structure_id_get_value (structure,
            GST_QUARK (AVG_IN_RATE)));
  if (avg_out)
    *avg_out = g_value_get_int (gst_structure_id_get_value (structure,
            GST_QUARK (AVG_OUT_RATE)));
  if (buffering_left)
    *buffering_left =
        g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (BUFFERING_LEFT)));
}

/**
 * gst_message_parse_state_changed:
 * @message: a valid #GstMessage of type GST_MESSAGE_STATE_CHANGED
 * @oldstate: (out) (allow-none): the previous state, or %NULL
 * @newstate: (out) (allow-none): the new (current) state, or %NULL
 * @pending: (out) (allow-none): the pending (target) state, or %NULL
 *
 * Extracts the old and new states from the GstMessage.
 *
 * Typical usage of this function might be:
 * |[
 *   ...
 *   switch (GST_MESSAGE_TYPE (msg)) {
 *     case GST_MESSAGE_STATE_CHANGED: {
 *       GstState old_state, new_state;
 *       
 *       gst_message_parse_state_changed (msg, &amp;old_state, &amp;new_state, NULL);
 *       g_print ("Element %s changed state from %s to %s.\n",
 *           GST_OBJECT_NAME (msg->src),
 *           gst_element_state_get_name (old_state),
 *           gst_element_state_get_name (new_state));
 *       break;
 *     }
 *     ...
 *   }
 *   ...
 * ]|
 *
 * MT safe.
 */
void
gst_message_parse_state_changed (GstMessage * message,
    GstState * oldstate, GstState * newstate, GstState * pending)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STATE_CHANGED);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (oldstate)
    *oldstate = (GstState)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (OLD_STATE)));
  if (newstate)
    *newstate = (GstState)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (NEW_STATE)));
  if (pending)
    *pending = (GstState)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (PENDING_STATE)));
}

/**
 * gst_message_parse_clock_provide:
 * @message: A valid #GstMessage of type GST_MESSAGE_CLOCK_PROVIDE.
 * @clock: (out) (allow-none) (transfer none): a pointer to  hold a clock
 *     object, or %NULL
 * @ready: (out) (allow-none): a pointer to hold the ready flag, or %NULL
 *
 * Extracts the clock and ready flag from the GstMessage.
 * The clock object returned remains valid until the message is freed.
 *
 * MT safe.
 */
void
gst_message_parse_clock_provide (GstMessage * message, GstClock ** clock,
    gboolean * ready)
{
  const GValue *clock_gvalue;
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_CLOCK_PROVIDE);

  structure = GST_MESSAGE_STRUCTURE (message);
  clock_gvalue = gst_structure_id_get_value (structure, GST_QUARK (CLOCK));
  g_return_if_fail (clock_gvalue != NULL);
  g_return_if_fail (G_VALUE_TYPE (clock_gvalue) == GST_TYPE_CLOCK);

  if (ready)
    *ready =
        g_value_get_boolean (gst_structure_id_get_value (structure,
            GST_QUARK (READY)));
  if (clock)
    *clock = (GstClock *) g_value_get_object (clock_gvalue);
}

/**
 * gst_message_parse_clock_lost:
 * @message: A valid #GstMessage of type GST_MESSAGE_CLOCK_LOST.
 * @clock: (out) (allow-none) (transfer none): a pointer to hold the lost clock
 *
 * Extracts the lost clock from the GstMessage.
 * The clock object returned remains valid until the message is freed.
 *
 * MT safe.
 */
void
gst_message_parse_clock_lost (GstMessage * message, GstClock ** clock)
{
  const GValue *clock_gvalue;
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_CLOCK_LOST);

  structure = GST_MESSAGE_STRUCTURE (message);
  clock_gvalue = gst_structure_id_get_value (structure, GST_QUARK (CLOCK));
  g_return_if_fail (clock_gvalue != NULL);
  g_return_if_fail (G_VALUE_TYPE (clock_gvalue) == GST_TYPE_CLOCK);

  if (clock)
    *clock = (GstClock *) g_value_get_object (clock_gvalue);
}

/**
 * gst_message_parse_new_clock:
 * @message: A valid #GstMessage of type GST_MESSAGE_NEW_CLOCK.
 * @clock: (out) (allow-none) (transfer none): a pointer to hold the selected
 *     new clock
 *
 * Extracts the new clock from the GstMessage.
 * The clock object returned remains valid until the message is freed.
 *
 * MT safe.
 */
void
gst_message_parse_new_clock (GstMessage * message, GstClock ** clock)
{
  const GValue *clock_gvalue;
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_NEW_CLOCK);

  structure = GST_MESSAGE_STRUCTURE (message);
  clock_gvalue = gst_structure_id_get_value (structure, GST_QUARK (CLOCK));
  g_return_if_fail (clock_gvalue != NULL);
  g_return_if_fail (G_VALUE_TYPE (clock_gvalue) == GST_TYPE_CLOCK);

  if (clock)
    *clock = (GstClock *) g_value_get_object (clock_gvalue);
}

/**
 * gst_message_parse_structure_change:
 * @message: A valid #GstMessage of type GST_MESSAGE_STRUCTURE_CHANGE.
 * @type: (out): A pointer to hold the change type
 * @owner: (out) (allow-none) (transfer none): The owner element of the
 *     message source
 * @busy: (out) (allow-none): a pointer to hold whether the change is in
 *     progress or has been completed
 *
 * Extracts the change type and completion status from the GstMessage.
 *
 * MT safe.
 */
void
gst_message_parse_structure_change (GstMessage * message,
    GstStructureChangeType * type, GstElement ** owner, gboolean * busy)
{
  const GValue *owner_gvalue;
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STRUCTURE_CHANGE);

  structure = GST_MESSAGE_STRUCTURE (message);
  owner_gvalue = gst_structure_id_get_value (structure, GST_QUARK (OWNER));
  g_return_if_fail (owner_gvalue != NULL);
  g_return_if_fail (G_VALUE_TYPE (owner_gvalue) == GST_TYPE_ELEMENT);

  if (type)
    *type = (GstStructureChangeType)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (TYPE)));
  if (owner)
    *owner = (GstElement *) g_value_get_object (owner_gvalue);
  if (busy)
    *busy =
        g_value_get_boolean (gst_structure_id_get_value (structure,
            GST_QUARK (BUSY)));
}

/**
 * gst_message_parse_error:
 * @message: A valid #GstMessage of type GST_MESSAGE_ERROR.
 * @gerror: (out) (allow-none) (transfer full): location for the GError
 * @debug: (out) (allow-none) (transfer full): location for the debug message,
 *     or %NULL
 *
 * Extracts the GError and debug string from the GstMessage. The values returned
 * in the output arguments are copies; the caller must free them when done.
 *
 * Typical usage of this function might be:
 * |[
 *   ...
 *   switch (GST_MESSAGE_TYPE (msg)) {
 *     case GST_MESSAGE_ERROR: {
 *       GError *err = NULL;
 *       gchar *dbg_info = NULL;
 *       
 *       gst_message_parse_error (msg, &amp;err, &amp;dbg_info);
 *       g_printerr ("ERROR from element %s: %s\n",
 *           GST_OBJECT_NAME (msg->src), err->message);
 *       g_printerr ("Debugging info: %s\n", (dbg_info) ? dbg_info : "none");
 *       g_error_free (err);
 *       g_free (dbg_info);
 *       break;
 *     }
 *     ...
 *   }
 *   ...
 * ]|
 *
 * MT safe.
 */
void
gst_message_parse_error (GstMessage * message, GError ** gerror, gchar ** debug)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_ERROR);

  gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (GERROR), G_TYPE_ERROR, gerror,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
}

/**
 * gst_message_parse_warning:
 * @message: A valid #GstMessage of type GST_MESSAGE_WARNING.
 * @gerror: (out) (allow-none) (transfer full): location for the GError
 * @debug: (out) (allow-none) (transfer full): location for the debug message,
 *     or %NULL
 *
 * Extracts the GError and debug string from the GstMessage. The values returned
 * in the output arguments are copies; the caller must free them when done.
 *
 * MT safe.
 */
void
gst_message_parse_warning (GstMessage * message, GError ** gerror,
    gchar ** debug)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_WARNING);

  gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (GERROR), G_TYPE_ERROR, gerror,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
}

/**
 * gst_message_parse_info:
 * @message: A valid #GstMessage of type GST_MESSAGE_INFO.
 * @gerror: (out) (allow-none) (transfer full): location for the GError
 * @debug: (out) (allow-none) (transfer full): location for the debug message,
 *     or %NULL
 *
 * Extracts the GError and debug string from the GstMessage. The values returned
 * in the output arguments are copies; the caller must free them when done.
 *
 * MT safe.
 */
void
gst_message_parse_info (GstMessage * message, GError ** gerror, gchar ** debug)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_INFO);

  gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (GERROR), G_TYPE_ERROR, gerror,
      GST_QUARK (DEBUG), G_TYPE_STRING, debug, NULL);
}

/**
 * gst_message_parse_segment_start:
 * @message: A valid #GstMessage of type GST_MESSAGE_SEGMENT_START.
 * @format: (out) (allow-none): Result location for the format, or %NULL
 * @position: (out) (allow-none): Result location for the position, or %NULL
 *
 * Extracts the position and format from the segment start message.
 *
 * MT safe.
 */
void
gst_message_parse_segment_start (GstMessage * message, GstFormat * format,
    gint64 * position)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_SEGMENT_START);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (format)
    *format = (GstFormat)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (position)
    *position =
        g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (POSITION)));
}

/**
 * gst_message_parse_segment_done:
 * @message: A valid #GstMessage of type GST_MESSAGE_SEGMENT_DONE.
 * @format: (out) (allow-none): Result location for the format, or %NULL
 * @position: (out) (allow-none): Result location for the position, or %NULL
 *
 * Extracts the position and format from the segment done message.
 *
 * MT safe.
 */
void
gst_message_parse_segment_done (GstMessage * message, GstFormat * format,
    gint64 * position)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_SEGMENT_DONE);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (format)
    *format = (GstFormat)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (position)
    *position =
        g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (POSITION)));
}

/**
 * gst_message_parse_async_done:
 * @message: A valid #GstMessage of type GST_MESSAGE_ASYNC_DONE.
 * @running_time: (out) (allow-none): Result location for the running_time or %NULL
 *
 * Extract the running_time from the async_done message.
 *
 * MT safe.
 */
void
gst_message_parse_async_done (GstMessage * message, GstClockTime * running_time)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_ASYNC_DONE);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (running_time)
    *running_time =
        g_value_get_uint64 (gst_structure_id_get_value (structure,
            GST_QUARK (RUNNING_TIME)));
}

/**
 * gst_message_parse_request_state:
 * @message: A valid #GstMessage of type GST_MESSAGE_REQUEST_STATE.
 * @state: (out) (allow-none): Result location for the requested state or %NULL
 *
 * Extract the requested state from the request_state message.
 *
 * MT safe.
 */
void
gst_message_parse_request_state (GstMessage * message, GstState * state)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_REQUEST_STATE);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (state)
    *state = (GstState)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (NEW_STATE)));
}

/**
 * gst_message_new_stream_status:
 * @src: The object originating the message.
 * @type: The stream status type.
 * @owner: (transfer none): the owner element of @src.
 *
 * Create a new stream status message. This message is posted when a streaming
 * thread is created/destroyed or when the state changed.
 * 
 * Returns: (transfer full): the new stream status message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_stream_status (GstObject * src, GstStreamStatusType type,
    GstElement * owner)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_STREAM_STATUS),
      GST_QUARK (TYPE), GST_TYPE_STREAM_STATUS_TYPE, (gint) type,
      GST_QUARK (OWNER), GST_TYPE_ELEMENT, owner, NULL);
  message = gst_message_new_custom (GST_MESSAGE_STREAM_STATUS, src, structure);

  return message;
}

/**
 * gst_message_parse_stream_status:
 * @message: A valid #GstMessage of type GST_MESSAGE_STREAM_STATUS.
 * @type: (out): A pointer to hold the status type
 * @owner: (out) (transfer none): The owner element of the message source
 *
 * Extracts the stream status type and owner the GstMessage. The returned
 * owner remains valid for as long as the reference to @message is valid and
 * should thus not be unreffed.
 *
 * MT safe.
 */
void
gst_message_parse_stream_status (GstMessage * message,
    GstStreamStatusType * type, GstElement ** owner)
{
  const GValue *owner_gvalue;
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STREAM_STATUS);

  structure = GST_MESSAGE_STRUCTURE (message);
  owner_gvalue = gst_structure_id_get_value (structure, GST_QUARK (OWNER));
  g_return_if_fail (owner_gvalue != NULL);

  if (type)
    *type = (GstStreamStatusType)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (TYPE)));
  if (owner)
    *owner = (GstElement *) g_value_get_object (owner_gvalue);
}

/**
 * gst_message_set_stream_status_object:
 * @message: A valid #GstMessage of type GST_MESSAGE_STREAM_STATUS.
 * @object: the object controlling the streaming
 *
 * Configures the object handling the streaming thread. This is usually a
 * GstTask object but other objects might be added in the future.
 */
void
gst_message_set_stream_status_object (GstMessage * message,
    const GValue * object)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STREAM_STATUS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_set_value (structure, GST_QUARK (OBJECT), object);
}

/**
 * gst_message_get_stream_status_object:
 * @message: A valid #GstMessage of type GST_MESSAGE_STREAM_STATUS.
 *
 * Extracts the object managing the streaming thread from @message.
 *
 * Returns: a GValue containing the object that manages the streaming thread.
 * This object is usually of type GstTask but other types can be added in the
 * future. The object remains valid as long as @message is valid.
 */
const GValue *
gst_message_get_stream_status_object (GstMessage * message)
{
  const GValue *result;
  GstStructure *structure;

  g_return_val_if_fail (GST_IS_MESSAGE (message), NULL);
  g_return_val_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STREAM_STATUS,
      NULL);

  structure = GST_MESSAGE_STRUCTURE (message);
  result = gst_structure_id_get_value (structure, GST_QUARK (OBJECT));

  return result;
}

/**
 * gst_message_new_step_done:
 * @src: The object originating the message.
 * @format: the format of @amount
 * @amount: the amount of stepped data
 * @rate: the rate of the stepped amount
 * @flush: is this an flushing step
 * @intermediate: is this an intermediate step
 * @duration: the duration of the data
 * @eos: the step caused EOS
 *
 * This message is posted by elements when they complete a part, when @intermediate set
 * to %TRUE, or a complete step operation.
 *
 * @duration will contain the amount of time (in GST_FORMAT_TIME) of the stepped
 * @amount of media in format @format.
 *
 * Returns: (transfer full): the new step_done message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_step_done (GstObject * src, GstFormat format, guint64 amount,
    gdouble rate, gboolean flush, gboolean intermediate, guint64 duration,
    gboolean eos)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_STEP_DONE),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (AMOUNT), G_TYPE_UINT64, amount,
      GST_QUARK (RATE), G_TYPE_DOUBLE, rate,
      GST_QUARK (FLUSH), G_TYPE_BOOLEAN, flush,
      GST_QUARK (INTERMEDIATE), G_TYPE_BOOLEAN, intermediate,
      GST_QUARK (DURATION), G_TYPE_UINT64, duration,
      GST_QUARK (EOS), G_TYPE_BOOLEAN, eos, NULL);
  message = gst_message_new_custom (GST_MESSAGE_STEP_DONE, src, structure);

  return message;
}

/**
 * gst_message_parse_step_done:
 * @message: A valid #GstMessage of type GST_MESSAGE_STEP_DONE.
 * @format: (out) (allow-none): result location for the format
 * @amount: (out) (allow-none): result location for the amount
 * @rate: (out) (allow-none): result location for the rate
 * @flush: (out) (allow-none): result location for the flush flag
 * @intermediate: (out) (allow-none): result location for the intermediate flag
 * @duration: (out) (allow-none): result location for the duration
 * @eos: (out) (allow-none): result location for the EOS flag
 *
 * Extract the values the step_done message.
 *
 * MT safe.
 */
void
gst_message_parse_step_done (GstMessage * message, GstFormat * format,
    guint64 * amount, gdouble * rate, gboolean * flush, gboolean * intermediate,
    guint64 * duration, gboolean * eos)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STEP_DONE);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (AMOUNT), G_TYPE_UINT64, amount,
      GST_QUARK (RATE), G_TYPE_DOUBLE, rate,
      GST_QUARK (FLUSH), G_TYPE_BOOLEAN, flush,
      GST_QUARK (INTERMEDIATE), G_TYPE_BOOLEAN, intermediate,
      GST_QUARK (DURATION), G_TYPE_UINT64, duration,
      GST_QUARK (EOS), G_TYPE_BOOLEAN, eos, NULL);
}

/**
 * gst_message_new_step_start:
 * @src: The object originating the message.
 * @active: if the step is active or queued
 * @format: the format of @amount
 * @amount: the amount of stepped data
 * @rate: the rate of the stepped amount
 * @flush: is this an flushing step
 * @intermediate: is this an intermediate step
 *
 * This message is posted by elements when they accept or activate a new step
 * event for @amount in @format. 
 *
 * @active is set to %FALSE when the element accepted the new step event and has
 * queued it for execution in the streaming threads.
 *
 * @active is set to %TRUE when the element has activated the step operation and
 * is now ready to start executing the step in the streaming thread. After this
 * message is emitted, the application can queue a new step operation in the
 * element.
 *
 * Returns: (transfer full): The new step_start message. 
 *
 * MT safe.
 */
GstMessage *
gst_message_new_step_start (GstObject * src, gboolean active, GstFormat format,
    guint64 amount, gdouble rate, gboolean flush, gboolean intermediate)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_STEP_START),
      GST_QUARK (ACTIVE), G_TYPE_BOOLEAN, active,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (AMOUNT), G_TYPE_UINT64, amount,
      GST_QUARK (RATE), G_TYPE_DOUBLE, rate,
      GST_QUARK (FLUSH), G_TYPE_BOOLEAN, flush,
      GST_QUARK (INTERMEDIATE), G_TYPE_BOOLEAN, intermediate, NULL);
  message = gst_message_new_custom (GST_MESSAGE_STEP_START, src, structure);

  return message;
}

/**
 * gst_message_parse_step_start:
 * @message: A valid #GstMessage of type GST_MESSAGE_STEP_DONE.
 * @active: (out) (allow-none): result location for the active flag
 * @format: (out) (allow-none): result location for the format
 * @amount: (out) (allow-none): result location for the amount
 * @rate: (out) (allow-none): result location for the rate
 * @flush: (out) (allow-none): result location for the flush flag
 * @intermediate: (out) (allow-none): result location for the intermediate flag
 *
 * Extract the values from step_start message.
 *
 * MT safe.
 */
void
gst_message_parse_step_start (GstMessage * message, gboolean * active,
    GstFormat * format, guint64 * amount, gdouble * rate, gboolean * flush,
    gboolean * intermediate)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STEP_START);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (ACTIVE), G_TYPE_BOOLEAN, active,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (AMOUNT), G_TYPE_UINT64, amount,
      GST_QUARK (RATE), G_TYPE_DOUBLE, rate,
      GST_QUARK (FLUSH), G_TYPE_BOOLEAN, flush,
      GST_QUARK (INTERMEDIATE), G_TYPE_BOOLEAN, intermediate, NULL);
}

/**
 * gst_message_new_qos:
 * @src: The object originating the message.
 * @live: if the message was generated by a live element
 * @running_time: the running time of the buffer that generated the message
 * @stream_time: the stream time of the buffer that generated the message
 * @timestamp: the timestamps of the buffer that generated the message
 * @duration: the duration of the buffer that generated the message
 *
 * A QOS message is posted on the bus whenever an element decides to drop a
 * buffer because of QoS reasons or whenever it changes its processing strategy
 * because of QoS reasons (quality adjustments such as processing at lower
 * accuracy).
 *
 * This message can be posted by an element that performs synchronisation against the
 * clock (live) or it could be dropped by an element that performs QoS because of QOS
 * events received from a downstream element (!live).
 *
 * @running_time, @stream_time, @timestamp, @duration should be set to the
 * respective running-time, stream-time, timestamp and duration of the (dropped)
 * buffer that generated the QoS event. Values can be left to
 * GST_CLOCK_TIME_NONE when unknown.
 *
 * Returns: (transfer full): The new qos message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_qos (GstObject * src, gboolean live, guint64 running_time,
    guint64 stream_time, guint64 timestamp, guint64 duration)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_QOS),
      GST_QUARK (LIVE), G_TYPE_BOOLEAN, live,
      GST_QUARK (RUNNING_TIME), G_TYPE_UINT64, running_time,
      GST_QUARK (STREAM_TIME), G_TYPE_UINT64, stream_time,
      GST_QUARK (TIMESTAMP), G_TYPE_UINT64, timestamp,
      GST_QUARK (DURATION), G_TYPE_UINT64, duration,
      GST_QUARK (JITTER), G_TYPE_INT64, (gint64) 0,
      GST_QUARK (PROPORTION), G_TYPE_DOUBLE, (gdouble) 1.0,
      GST_QUARK (QUALITY), G_TYPE_INT, (gint) 1000000,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, GST_FORMAT_UNDEFINED,
      GST_QUARK (PROCESSED), G_TYPE_UINT64, (guint64) - 1,
      GST_QUARK (DROPPED), G_TYPE_UINT64, (guint64) - 1, NULL);
  message = gst_message_new_custom (GST_MESSAGE_QOS, src, structure);

  return message;
}

/**
 * gst_message_set_qos_values:
 * @message: A valid #GstMessage of type GST_MESSAGE_QOS.
 * @jitter: The difference of the running-time against the deadline.
 * @proportion: Long term prediction of the ideal rate relative to normal rate
 * to get optimal quality.
 * @quality: An element dependent integer value that specifies the current
 * quality level of the element. The default maximum quality is 1000000.
 *
 * Set the QoS values that have been calculated/analysed from the QoS data
 *
 * MT safe.
 */
void
gst_message_set_qos_values (GstMessage * message, gint64 jitter,
    gdouble proportion, gint quality)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_QOS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_set (structure,
      GST_QUARK (JITTER), G_TYPE_INT64, jitter,
      GST_QUARK (PROPORTION), G_TYPE_DOUBLE, proportion,
      GST_QUARK (QUALITY), G_TYPE_INT, quality, NULL);
}

/**
 * gst_message_set_qos_stats:
 * @message: A valid #GstMessage of type GST_MESSAGE_QOS.
 * @format: Units of the 'processed' and 'dropped' fields. Video sinks and video
 * filters will use GST_FORMAT_BUFFERS (frames). Audio sinks and audio filters
 * will likely use GST_FORMAT_DEFAULT (samples).
 * @processed: Total number of units correctly processed since the last state
 * change to READY or a flushing operation.
 * @dropped: Total number of units dropped since the last state change to READY
 * or a flushing operation.
 *
 * Set the QoS stats representing the history of the current continuous pipeline
 * playback period.
 *
 * When @format is @GST_FORMAT_UNDEFINED both @dropped and @processed are
 * invalid. Values of -1 for either @processed or @dropped mean unknown values.
 *
 * MT safe.
 */
void
gst_message_set_qos_stats (GstMessage * message, GstFormat format,
    guint64 processed, guint64 dropped)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_QOS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_set (structure,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (PROCESSED), G_TYPE_UINT64, processed,
      GST_QUARK (DROPPED), G_TYPE_UINT64, dropped, NULL);
}

/**
 * gst_message_parse_qos:
 * @message: A valid #GstMessage of type GST_MESSAGE_QOS.
 * @live: (out) (allow-none): if the message was generated by a live element
 * @running_time: (out) (allow-none): the running time of the buffer that
 *     generated the message
 * @stream_time: (out) (allow-none): the stream time of the buffer that
 *     generated the message
 * @timestamp: (out) (allow-none): the timestamps of the buffer that
 *     generated the message
 * @duration: (out) (allow-none): the duration of the buffer that
 *     generated the message
 *
 * Extract the timestamps and live status from the QoS message.
 *
 * The returned values give the running_time, stream_time, timestamp and
 * duration of the dropped buffer. Values of GST_CLOCK_TIME_NONE mean unknown
 * values.
 *
 * MT safe.
 */
void
gst_message_parse_qos (GstMessage * message, gboolean * live,
    guint64 * running_time, guint64 * stream_time, guint64 * timestamp,
    guint64 * duration)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_QOS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (LIVE), G_TYPE_BOOLEAN, live,
      GST_QUARK (RUNNING_TIME), G_TYPE_UINT64, running_time,
      GST_QUARK (STREAM_TIME), G_TYPE_UINT64, stream_time,
      GST_QUARK (TIMESTAMP), G_TYPE_UINT64, timestamp,
      GST_QUARK (DURATION), G_TYPE_UINT64, duration, NULL);
}

/**
 * gst_message_parse_qos_values:
 * @message: A valid #GstMessage of type GST_MESSAGE_QOS.
 * @jitter: (out) (allow-none): The difference of the running-time against
 *     the deadline.
 * @proportion: (out) (allow-none): Long term prediction of the ideal rate
 *     relative to normal rate to get optimal quality.
 * @quality: (out) (allow-none): An element dependent integer value that
 *     specifies the current quality level of the element. The default
 *     maximum quality is 1000000.
 *
 * Extract the QoS values that have been calculated/analysed from the QoS data
 *
 * MT safe.
 */
void
gst_message_parse_qos_values (GstMessage * message, gint64 * jitter,
    gdouble * proportion, gint * quality)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_QOS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (JITTER), G_TYPE_INT64, jitter,
      GST_QUARK (PROPORTION), G_TYPE_DOUBLE, proportion,
      GST_QUARK (QUALITY), G_TYPE_INT, quality, NULL);
}

/**
 * gst_message_parse_qos_stats:
 * @message: A valid #GstMessage of type GST_MESSAGE_QOS.
 * @format: (out) (allow-none): Units of the 'processed' and 'dropped' fields.
 *     Video sinks and video filters will use GST_FORMAT_BUFFERS (frames).
 *     Audio sinks and audio filters will likely use GST_FORMAT_DEFAULT
 *     (samples).
 * @processed: (out) (allow-none): Total number of units correctly processed
 *     since the last state change to READY or a flushing operation.
 * @dropped: (out) (allow-none): Total number of units dropped since the last
 *     state change to READY or a flushing operation.
 *
 * Extract the QoS stats representing the history of the current continuous
 * pipeline playback period.
 *
 * When @format is @GST_FORMAT_UNDEFINED both @dropped and @processed are
 * invalid. Values of -1 for either @processed or @dropped mean unknown values.
 *
 * MT safe.
 */
void
gst_message_parse_qos_stats (GstMessage * message, GstFormat * format,
    guint64 * processed, guint64 * dropped)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_QOS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (PROCESSED), G_TYPE_UINT64, processed,
      GST_QUARK (DROPPED), G_TYPE_UINT64, dropped, NULL);
}

/**
 * gst_message_new_progress:
 * @src: The object originating the message.
 * @type: a #GstProgressType
 * @code: a progress code
 * @text: free, user visible text describing the progress
 *
 * Progress messages are posted by elements when they use an asynchronous task
 * to perform actions triggered by a state change.
 *
 * @code contains a well defined string describing the action.
 * @test should contain a user visible string detailing the current action.
 *
 * Returns: (transfer full): The new qos message.
 */
GstMessage *
gst_message_new_progress (GstObject * src, GstProgressType type,
    const gchar * code, const gchar * text)
{
  GstMessage *message;
  GstStructure *structure;
  gint percent = 100, timeout = -1;

  g_return_val_if_fail (code != NULL, NULL);
  g_return_val_if_fail (text != NULL, NULL);

  if (type == GST_PROGRESS_TYPE_START || type == GST_PROGRESS_TYPE_CONTINUE)
    percent = 0;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_PROGRESS),
      GST_QUARK (TYPE), GST_TYPE_PROGRESS_TYPE, type,
      GST_QUARK (CODE), G_TYPE_STRING, code,
      GST_QUARK (TEXT), G_TYPE_STRING, text,
      GST_QUARK (PERCENT), G_TYPE_INT, percent,
      GST_QUARK (TIMEOUT), G_TYPE_INT, timeout, NULL);
  message = gst_message_new_custom (GST_MESSAGE_PROGRESS, src, structure);

  return message;
}

/**
 * gst_message_parse_progress:
 * @message: A valid #GstMessage of type GST_MESSAGE_PROGRESS.
 * @type: (out) (allow-none): location for the type
 * @code: (out) (allow-none) (transfer full): location for the code
 * @text: (out) (allow-none) (transfer full): location for the text
 *
 * Parses the progress @type, @code and @text.
 */
void
gst_message_parse_progress (GstMessage * message, GstProgressType * type,
    gchar ** code, gchar ** text)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_PROGRESS);

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_get (structure,
      GST_QUARK (TYPE), GST_TYPE_PROGRESS_TYPE, type,
      GST_QUARK (CODE), G_TYPE_STRING, code,
      GST_QUARK (TEXT), G_TYPE_STRING, text, NULL);
}

/**
 * gst_message_new_toc:
 * @src: the object originating the message.
 * @toc: (transfer none): #GstToc structure for the message.
 * @updated: whether TOC was updated or not.
 *
 * Create a new TOC message. The message is posted by elements
 * that discovered or updated a TOC.
 *
 * Returns: (transfer full): a new TOC message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_toc (GstObject * src, GstToc * toc, gboolean updated)
{
  GstStructure *toc_struct;

  g_return_val_if_fail (toc != NULL, NULL);

  toc_struct = gst_structure_new_id (GST_QUARK (MESSAGE_TOC),
      GST_QUARK (TOC), GST_TYPE_TOC, toc,
      GST_QUARK (UPDATED), G_TYPE_BOOLEAN, updated, NULL);

  return gst_message_new_custom (GST_MESSAGE_TOC, src, toc_struct);
}

/**
 * gst_message_parse_toc:
 * @message: a valid #GstMessage of type GST_MESSAGE_TOC.
 * @toc: (out) (transfer full): return location for the TOC.
 * @updated: (out): return location for the updated flag.
 *
 * Extract the TOC from the #GstMessage. The TOC returned in the
 * output argument is a copy; the caller must free it with
 * gst_toc_unref() when done.
 *
 * MT safe.
 */
void
gst_message_parse_toc (GstMessage * message, GstToc ** toc, gboolean * updated)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_TOC);
  g_return_if_fail (toc != NULL);

  gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
      GST_QUARK (TOC), GST_TYPE_TOC, toc,
      GST_QUARK (UPDATED), G_TYPE_BOOLEAN, updated, NULL);
}

/**
 * gst_message_new_reset_time:
 * @src: (transfer none): The object originating the message.
 * @running_time: the requested running-time
 *
 * This message is posted when the pipeline running-time should be reset to
 * @running_time, like after a flushing seek.
 *
 * Returns: (transfer full): The new reset_time message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_reset_time (GstObject * src, GstClockTime running_time)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_RESET_TIME),
      GST_QUARK (RUNNING_TIME), G_TYPE_UINT64, running_time, NULL);
  message = gst_message_new_custom (GST_MESSAGE_RESET_TIME, src, structure);

  return message;
}

/**
 * gst_message_parse_reset_time:
 * @message: A valid #GstMessage of type GST_MESSAGE_RESET_TIME.
 * @running_time: (out) (allow-none): Result location for the running_time or
 *      %NULL
 *
 * Extract the running-time from the RESET_TIME message.
 *
 * MT safe.
 */
void
gst_message_parse_reset_time (GstMessage * message, GstClockTime * running_time)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_RESET_TIME);

  structure = GST_MESSAGE_STRUCTURE (message);
  if (running_time)
    *running_time =
        g_value_get_uint64 (gst_structure_id_get_value (structure,
            GST_QUARK (RUNNING_TIME)));
}

/**
 * gst_message_new_stream_start:
 * @src: (transfer none): The object originating the message.
 *
 * Create a new stream_start message. This message is generated and posted in
 * the sink elements of a GstBin. The bin will only forward the STREAM_START
 * message to the application if all sinks have posted an STREAM_START message.
 *
 * Returns: (transfer full): The new stream_start message.
 *
 * MT safe.
 */
GstMessage *
gst_message_new_stream_start (GstObject * src)
{
  GstMessage *message;
  GstStructure *s;

  s = gst_structure_new_id_empty (GST_QUARK (MESSAGE_STREAM_START));
  message = gst_message_new_custom (GST_MESSAGE_STREAM_START, src, s);

  return message;
}


/**
 * gst_message_set_group_id:
 * @message: the message
 * @group_id: the group id
 *
 * Sets the group id on the stream-start message.
 *
 * All streams that have the same group id are supposed to be played
 * together, i.e. all streams inside a container file should have the
 * same group id but different stream ids. The group id should change
 * each time the stream is started, resulting in different group ids
 * each time a file is played for example.
 *
 * MT safe.
 *
 * Since: 1.2
 */
void
gst_message_set_group_id (GstMessage * message, guint group_id)
{
  GstStructure *structure;

  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STREAM_START);
  g_return_if_fail (gst_message_is_writable (message));

  structure = GST_MESSAGE_STRUCTURE (message);
  gst_structure_id_set (structure, GST_QUARK (GROUP_ID), G_TYPE_UINT, group_id,
      NULL);
}

/**
 * gst_message_parse_group_id:
 * @message: A valid #GstMessage of type GST_MESSAGE_STREAM_START.
 * @group_id: (out) (allow-none): Result location for the group id or
 *      %NULL
 *
 * Extract the group from the STREAM_START message.
 *
 * Returns: %TRUE if the message had a group id set, %FALSE otherwise
 *
 * MT safe.
 *
 * Since: 1.2
 */
gboolean
gst_message_parse_group_id (GstMessage * message, guint * group_id)
{
  GstStructure *structure;
  const GValue *v;

  g_return_val_if_fail (GST_IS_MESSAGE (message), FALSE);
  g_return_val_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_STREAM_START,
      FALSE);

  if (!group_id)
    return TRUE;

  structure = GST_MESSAGE_STRUCTURE (message);

  v = gst_structure_id_get_value (structure, GST_QUARK (GROUP_ID));
  if (!v)
    return FALSE;

  *group_id = g_value_get_uint (v);
  return TRUE;
}

/**
 * gst_message_new_need_context:
 * @src: (transfer none): The object originating the message.
 * @context_type: The context type that is needed
 *
 * This message is posted when an element needs a specific #GstContext.
 *
 * Returns: (transfer full): The new need-context message.
 *
 * MT safe.
 *
 * Since: 1.2
 */
GstMessage *
gst_message_new_need_context (GstObject * src, const gchar * context_type)
{
  GstMessage *message;
  GstStructure *structure;

  g_return_val_if_fail (context_type != NULL, NULL);

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_NEED_CONTEXT),
      GST_QUARK (CONTEXT_TYPE), G_TYPE_STRING, context_type, NULL);
  message = gst_message_new_custom (GST_MESSAGE_NEED_CONTEXT, src, structure);

  return message;
}

/**
 * gst_message_parse_context_type:
 * @message: a GST_MESSAGE_NEED_CONTEXT type message
 * @context_type: (out) (allow-none): the context type, or %NULL
 *
 * Parse a context type from an existing GST_MESSAGE_NEED_CONTEXT message.
 *
 * Returns: a #gboolean indicating if the parsing succeeded.
 *
 * Since: 1.2
 */
gboolean
gst_message_parse_context_type (GstMessage * message,
    const gchar ** context_type)
{
  GstStructure *structure;
  const GValue *value;

  g_return_val_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_NEED_CONTEXT,
      FALSE);

  structure = GST_MESSAGE_STRUCTURE (message);

  if (context_type) {
    value = gst_structure_id_get_value (structure, GST_QUARK (CONTEXT_TYPE));
    *context_type = g_value_get_string (value);
  }

  return TRUE;
}

/**
 * gst_message_new_have_context:
 * @src: (transfer none): The object originating the message.
 * @context: (transfer full): the context
 *
 * This message is posted when an element has a new local #GstContext.
 *
 * Returns: (transfer full): The new have-context message.
 *
 * MT safe.
 *
 * Since: 1.2
 */
GstMessage *
gst_message_new_have_context (GstObject * src, GstContext * context)
{
  GstMessage *message;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_HAVE_CONTEXT),
      GST_QUARK (CONTEXT), GST_TYPE_CONTEXT, context, NULL);
  message = gst_message_new_custom (GST_MESSAGE_HAVE_CONTEXT, src, structure);
  gst_context_unref (context);

  return message;
}

/**
 * gst_message_parse_have_context:
 * @message: A valid #GstMessage of type GST_MESSAGE_HAVE_CONTEXT.
 * @context: (out) (transfer full) (allow-none): Result location for the
 *      context or %NULL
 *
 * Extract the context from the HAVE_CONTEXT message.
 *
 * MT safe.
 *
 * Since: 1.2
 */
void
gst_message_parse_have_context (GstMessage * message, GstContext ** context)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_HAVE_CONTEXT);

  if (context)
    gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
        GST_QUARK (CONTEXT), GST_TYPE_CONTEXT, context, NULL);
}

/**
 * gst_message_new_device_added:
 * @src: The #GstObject that created the message
 * @device: (transfer none): The new #GstDevice
 *
 * Creates a new device-added message. The device-added message is produced by
 * #GstDeviceProvider or a #GstDeviceMonitor. They announce the appearance
 * of monitored devices.
 *
 * Returns: a newly allocated #GstMessage
 *
 * Since: 1.4
 */
GstMessage *
gst_message_new_device_added (GstObject * src, GstDevice * device)
{
  GstMessage *message;
  GstStructure *structure;

  g_return_val_if_fail (device != NULL, NULL);
  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_DEVICE_ADDED),
      GST_QUARK (DEVICE), GST_TYPE_DEVICE, device, NULL);
  message = gst_message_new_custom (GST_MESSAGE_DEVICE_ADDED, src, structure);

  return message;
}

/**
 * gst_message_parse_device_added:
 * @message: a #GstMessage of type %GST_MESSAGE_DEVICE_ADDED
 * @device: (out) (allow-none) (transfer none): A location where to store a
 *  pointer to the new #GstDevice, or %NULL
 * 
 * Parses a device-added message. The device-added message is produced by
 * #GstDeviceProvider or a #GstDeviceMonitor. It announces the appearance
 * of monitored devices.
 *
 * Since: 1.4
 */
void
gst_message_parse_device_added (GstMessage * message, GstDevice ** device)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_DEVICE_ADDED);

  if (device)
    gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
        GST_QUARK (DEVICE), GST_TYPE_DEVICE, device, NULL);
}

/**
 * gst_message_new_device_removed:
 * @src: The #GstObject that created the message
 * @device: (transfer none): The removed #GstDevice
 *
 * Creates a new device-removed message. The device-removed message is produced
 * by #GstDeviceProvider or a #GstDeviceMonitor. They announce the
 * disappearance of monitored devices.
 *
 * Returns: a newly allocated #GstMessage
 *
 * Since: 1.4
 */
GstMessage *
gst_message_new_device_removed (GstObject * src, GstDevice * device)
{
  GstMessage *message;
  GstStructure *structure;

  g_return_val_if_fail (device != NULL, NULL);
  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  structure = gst_structure_new_id (GST_QUARK (MESSAGE_DEVICE_REMOVED),
      GST_QUARK (DEVICE), GST_TYPE_DEVICE, device, NULL);
  message = gst_message_new_custom (GST_MESSAGE_DEVICE_REMOVED, src, structure);

  return message;
}

/**
 * gst_message_parse_device_removed:
 * @message: a #GstMessage of type %GST_MESSAGE_DEVICE_REMOVED
 * @device: (out) (allow-none) (transfer none): A location where to store a
 *  pointer to the removed #GstDevice, or %NULL
 *
 * Parses a device-removed message. The device-removed message is produced by
 * #GstDeviceProvider or a #GstDeviceMonitor. It announces the
 * disappearance of monitored devices.
 *
 * Since: 1.4
 */
void
gst_message_parse_device_removed (GstMessage * message, GstDevice ** device)
{
  g_return_if_fail (GST_IS_MESSAGE (message));
  g_return_if_fail (GST_MESSAGE_TYPE (message) == GST_MESSAGE_DEVICE_REMOVED);

  if (device)
    gst_structure_id_get (GST_MESSAGE_STRUCTURE (message),
        GST_QUARK (DEVICE), GST_TYPE_DEVICE, device, NULL);
}
