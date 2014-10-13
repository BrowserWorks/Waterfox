/* GStreamer
 *
 * unit testing helper lib
 *
 * Copyright (C) 2009 Edward Hervey <bilboed@bilboed.com>
 * Copyright (C) 2012 Stefan Sauer <ensonic@users.sf.net>
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
 * SECTION:gstcheckconsistencychecker
 * @short_description: Data flow consistency checker for GStreamer unit tests.
 *
 * These macros and functions are for internal use of the unit tests found
 * inside the 'check' directories of various GStreamer packages.
 */

#include "gstconsistencychecker.h"

struct _GstStreamConsistency
{
  /* FIXME: do we want to track some states per pad? */
  volatile gboolean flushing;
  volatile gboolean segment;
  volatile gboolean eos;
  volatile gboolean expect_flush;
  volatile gboolean saw_serialized_event;
  volatile gboolean saw_stream_start;
  GstObject *parent;
  GList *pads;
};

typedef struct _GstStreamConsistencyProbe
{
  GstPad *pad;
  gulong probeid;
} GstStreamConsistencyProbe;

static gboolean
source_pad_data_cb (GstPad * pad, GstPadProbeInfo * info,
    GstStreamConsistency * consist)
{
  GstMiniObject *data = GST_PAD_PROBE_INFO_DATA (info);

  GST_DEBUG_OBJECT (pad, "%p: %d %d %d %d", consist, consist->flushing,
      consist->segment, consist->eos, consist->expect_flush);

  if (GST_IS_BUFFER (data)) {
    GST_DEBUG_OBJECT (pad,
        "Buffer pts %" GST_TIME_FORMAT ", dts %" GST_TIME_FORMAT,
        GST_TIME_ARGS (GST_BUFFER_PTS (GST_BUFFER_CAST (data))),
        GST_TIME_ARGS (GST_BUFFER_DTS (GST_BUFFER_CAST (data))));
    /* If an EOS went through, a buffer would be invalid */
    fail_if (consist->eos, "Buffer received after EOS on pad %s:%s",
        GST_DEBUG_PAD_NAME (pad));
    /* Buffers need to be preceded by a segment event */
    fail_unless (consist->segment, "Buffer received without segment "
        "on pad %s:%s", GST_DEBUG_PAD_NAME (pad));
  } else if (GST_IS_EVENT (data)) {
    GstEvent *event = (GstEvent *) data;

    GST_DEBUG_OBJECT (pad, "Event : %s", GST_EVENT_TYPE_NAME (event));
    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_FLUSH_START:
        /* getting two flush_start in a row seems to be okay
           fail_if (consist->flushing, "Received another FLUSH_START");
         */
        consist->flushing = TRUE;
        break;
      case GST_EVENT_FLUSH_STOP:
        /* Receiving a flush-stop is only valid after receiving a flush-start */
        fail_unless (consist->flushing,
            "Received a FLUSH_STOP without a FLUSH_START on pad %s:%s",
            GST_DEBUG_PAD_NAME (pad));
        fail_if (consist->eos, "Received a FLUSH_STOP after an EOS on "
            "pad %s:%s", GST_DEBUG_PAD_NAME (pad));
        consist->flushing = consist->expect_flush = FALSE;
        break;
      case GST_EVENT_STREAM_START:
        fail_if (consist->saw_serialized_event && !consist->saw_stream_start,
            "Got a STREAM_START event after a serialized event on pad %s:%s",
            GST_DEBUG_PAD_NAME (pad));
        consist->saw_stream_start = TRUE;
        break;
      case GST_EVENT_CAPS:
        /* ok to have these before segment event */
        /* FIXME check order more precisely, if so spec'ed somehow ? */
        break;
      case GST_EVENT_SEGMENT:
        fail_if ((consist->expect_flush && consist->flushing),
            "Received SEGMENT while in a flushing seek on pad %s:%s",
            GST_DEBUG_PAD_NAME (pad));
        consist->segment = TRUE;
        consist->eos = FALSE;
        break;
      case GST_EVENT_EOS:
        /* FIXME : not 100% sure about whether two eos in a row is valid */
        fail_if (consist->eos, "Received EOS just after another EOS on "
            "pad %s:%s", GST_DEBUG_PAD_NAME (pad));
        consist->eos = TRUE;
        consist->segment = FALSE;
        break;
      case GST_EVENT_TAG:
        GST_DEBUG_OBJECT (pad, "tag %" GST_PTR_FORMAT,
            gst_event_get_structure (event));
        /* fall through */
      default:
        if (GST_EVENT_IS_SERIALIZED (event) && GST_EVENT_IS_DOWNSTREAM (event)) {
          fail_if (consist->eos, "Event received after EOS");
          fail_unless (consist->segment, "Event %s received before segment "
              "on pad %s:%s", GST_EVENT_TYPE_NAME (event),
              GST_DEBUG_PAD_NAME (pad));
        }
        /* FIXME : Figure out what to do for other events */
        break;
    }
    if (GST_EVENT_IS_SERIALIZED (event)) {
      fail_if (!consist->saw_stream_start
          && GST_EVENT_TYPE (event) != GST_EVENT_STREAM_START,
          "Got a serialized event (%s) before a STREAM_START on pad %s:%s",
          GST_EVENT_TYPE_NAME (event), GST_DEBUG_PAD_NAME (pad));
      consist->saw_serialized_event = TRUE;
    }
  }

  return TRUE;
}

static gboolean
sink_pad_data_cb (GstPad * pad, GstPadProbeInfo * info,
    GstStreamConsistency * consist)
{
  GstMiniObject *data = GST_PAD_PROBE_INFO_DATA (info);

  GST_DEBUG_OBJECT (pad, "%p: %d %d %d %d", consist, consist->flushing,
      consist->segment, consist->eos, consist->expect_flush);

  if (GST_IS_BUFFER (data)) {
    GST_DEBUG_OBJECT (pad, "Buffer %" GST_TIME_FORMAT,
        GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (GST_BUFFER (data))));
    /* If an EOS went through, a buffer would be invalid */
    fail_if (consist->eos, "Buffer received after EOS on pad %s:%s",
        GST_DEBUG_PAD_NAME (pad));
    /* Buffers need to be preceded by a segment event */
    fail_unless (consist->segment, "Buffer received without segment "
        "on pad %s:%s", GST_DEBUG_PAD_NAME (pad));
  } else if (GST_IS_EVENT (data)) {
    GstEvent *event = (GstEvent *) data;

    GST_DEBUG_OBJECT (pad, "%s", GST_EVENT_TYPE_NAME (event));
    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_SEEK:
      {
        GstSeekFlags flags;

        gst_event_parse_seek (event, NULL, NULL, &flags, NULL, NULL, NULL,
            NULL);
        consist->expect_flush =
            ((flags & GST_SEEK_FLAG_FLUSH) == GST_SEEK_FLAG_FLUSH);
        break;
      }
      case GST_EVENT_SEGMENT:
        fail_if ((consist->expect_flush && consist->flushing),
            "Received SEGMENT while in a flushing seek on pad %s:%s",
            GST_DEBUG_PAD_NAME (pad));
        consist->segment = TRUE;
        consist->eos = FALSE;
        break;
      default:
        /* FIXME : Figure out what to do for other events */
        break;
    }
  }

  return TRUE;
}

static void
add_pad (GstStreamConsistency * consist, GstPad * pad)
{
  GstStreamConsistencyProbe *p;
  GstPadDirection dir;

  p = g_new0 (GstStreamConsistencyProbe, 1);
  p->pad = g_object_ref (pad);
  dir = gst_pad_get_direction (pad);
  if (dir == GST_PAD_SRC) {

    p->probeid =
        gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_DATA_DOWNSTREAM,
        (GstPadProbeCallback) source_pad_data_cb, consist, NULL);

  } else if (dir == GST_PAD_SINK) {
    p->probeid =
        gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_DATA_DOWNSTREAM,
        (GstPadProbeCallback) sink_pad_data_cb, consist, NULL);
  }
  consist->pads = g_list_prepend (consist->pads, p);
}

/**
 * gst_consistency_checker_new:
 * @pad: The #GstPad on which the dataflow will be checked.
 *
 * Sets up a data probe on the given pad which will raise assertions if the
 * data flow is inconsistent.
 *
 * Returns: A #GstStreamConsistency structure used to track data flow.
 */
GstStreamConsistency *
gst_consistency_checker_new (GstPad * pad)
{
  GstStreamConsistency *consist;

  g_return_val_if_fail (pad != NULL, NULL);

  consist = g_new0 (GstStreamConsistency, 1);

  if (!consist->pads) {
    consist->parent = GST_OBJECT_PARENT (pad);
  }
  add_pad (consist, pad);
  return consist;
}

/**
 * gst_consistency_checker_add_pad:
 * @consist: The #GstStreamConsistency handle
 * @pad: The #GstPad on which the dataflow will be checked.
 *
 * Sets up a data probe on the given pad which will raise assertions if the
 * data flow is inconsistent.
 *
 * Returns: %TRUE if the pad was added
 */
gboolean
gst_consistency_checker_add_pad (GstStreamConsistency * consist, GstPad * pad)
{
  g_return_val_if_fail (consist != NULL, FALSE);
  g_return_val_if_fail (pad != NULL, FALSE);
  g_return_val_if_fail (GST_OBJECT_PARENT (pad) == consist->parent, FALSE);

  add_pad (consist, pad);
  return TRUE;
}

/**
 * gst_consistency_checker_reset:
 * @consist: The #GstStreamConsistency to reset.
 *
 * Reset the stream checker's internal variables.
 */

void
gst_consistency_checker_reset (GstStreamConsistency * consist)
{
  consist->flushing = FALSE;
  consist->segment = FALSE;
  consist->eos = FALSE;
  consist->expect_flush = FALSE;
  consist->saw_serialized_event = FALSE;
  consist->saw_stream_start = FALSE;
}

/**
 * gst_consistency_checker_free:
 * @consist: The #GstStreamConsistency to free.
 *
 * Frees the allocated data and probes associated with @consist.
 */

void
gst_consistency_checker_free (GstStreamConsistency * consist)
{
  GList *node;
  GstStreamConsistencyProbe *p;

  /* Remove the data probes */
  for (node = consist->pads; node; node = g_list_next (node)) {
    p = (GstStreamConsistencyProbe *) node->data;
    gst_pad_remove_probe (p->pad, p->probeid);
    gst_object_unref (p->pad);
    g_free (p);
  }
  g_list_free (consist->pads);
  g_free (consist);
}
