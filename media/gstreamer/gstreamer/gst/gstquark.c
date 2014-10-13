/* GStreamer
 * Copyright (C) 2006 Jan Schmidt <thaytan@noraisin.net>
 *
 * gstquark.c: Registered quarks for the _priv_gst_quark_table, private to 
 *   GStreamer
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

#include "gst_private.h"
#include "gstquark.h"
#include "gstelementmetadata.h"

/* These strings must match order and number declared in the GstQuarkId
 * enum in gstquark.h! */
static const gchar *_quark_strings[] = {
  "format", "current", "duration", "rate",
  "seekable", "segment-start", "segment-end",
  "src_format", "src_value", "dest_format", "dest_value",
  "start_format", "start_value", "stop_format", "stop_value",
  "gerror", "debug", "buffer-percent", "buffering-mode",
  "avg-in-rate", "avg-out-rate", "buffering-left",
  "estimated-total", "old-state", "new-state", "pending-state",
  "clock", "ready", "position", "reset-time", "live", "min-latency",
  "max-latency", "busy", "type", "owner", "update", "applied-rate",
  "start", "stop", "minsize", "maxsize", "async", "proportion",
  "diff", "timestamp", "flags", "cur-type", "cur", "stop-type",
  "latency", "uri", "object", "taglist", "GstEventSegment",
  "GstEventBufferSize", "GstEventQOS", "GstEventSeek", "GstEventLatency",
  "GstMessageError", "GstMessageWarning", "GstMessageInfo",
  "GstMessageBuffering", "GstMessageStateChanged", "GstMessageClockProvide",
  "GstMessageClockLost", "GstMessageNewClock", "GstMessageStructureChange",
  "GstMessageSegmentStart", "GstMessageSegmentDone",
  "GstMessageDurationChanged",
  "GstMessageAsyncDone", "GstMessageRequestState", "GstMessageStreamStatus",
  "GstQueryPosition", "GstQueryDuration", "GstQueryLatency", "GstQueryConvert",
  "GstQuerySegment", "GstQuerySeeking", "GstQueryFormats", "GstQueryBuffering",
  "GstQueryURI", "GstEventStep", "GstMessageStepDone", "amount", "flush",
  "intermediate", "GstMessageStepStart", "active", "eos", "sink-message",
  "message", "GstMessageQOS", "running-time", "stream-time", "jitter",
  "quality", "processed", "dropped", "buffering-ranges", "GstMessageProgress",
  "code", "text", "percent", "timeout", "GstBufferPoolConfig", "caps", "size",
  "min-buffers", "max-buffers", "prefix", "padding", "align", "time",
  "GstQueryAllocation", "need-pool", "meta", "pool", "GstEventCaps",
  "GstEventReconfigure", "segment", "GstQueryScheduling", "pull-mode",
  "allocator", "GstEventFlushStop", "options", "GstQueryAcceptCaps",
  "result", "GstQueryCaps", "filter", "modes", "GstEventStreamConfig",
  "setup-data", "stream-headers", "GstEventGap", "GstQueryDrain", "params",
  "GstEventTocSelect", "uid", "GstQueryToc", GST_ELEMENT_METADATA_LONGNAME,
  GST_ELEMENT_METADATA_KLASS, GST_ELEMENT_METADATA_DESCRIPTION,
  GST_ELEMENT_METADATA_AUTHOR, "toc", "toc-entry", "updated", "extend-uid",
  "uid", "tags", "sub-entries", "info", "GstMessageTag", "GstEventTag",
  "GstMessageResetTime",
  "GstMessageToc", "GstEventTocGlobal", "GstEventTocCurrent",
  "GstEventSegmentDone",
  "GstEventStreamStart", "stream-id", "GstQueryContext",
  "GstMessageNeedContext", "GstMessageHaveContext", "context", "context-type",
  "GstMessageStreamStart", "group-id", "uri-redirection",
  "GstMessageDeviceAdded", "GstMessageDeviceRemoved", "device",
  "uri-redirection-permanent"
};

GQuark _priv_gst_quark_table[GST_QUARK_MAX];

void
_priv_gst_quarks_initialize (void)
{
  gint i;

  if (G_N_ELEMENTS (_quark_strings) != GST_QUARK_MAX)
    g_warning ("the quark table is not consistent! %d != %d",
        (int) G_N_ELEMENTS (_quark_strings), GST_QUARK_MAX);

  for (i = 0; i < GST_QUARK_MAX; i++) {
    _priv_gst_quark_table[i] = g_quark_from_static_string (_quark_strings[i]);
  }
}
