/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstfdsink.c:
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
 * SECTION:element-fdsink
 * @see_also: #GstFdSrc
 *
 * Write data to a unix file descriptor.
 *
 * This element will synchronize on the clock before writing the data on the
 * socket. For file descriptors where this does not make sense (files, ...) the
 * #GstBaseSink:sync property can be used to disable synchronisation.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "../../gst/gst-i18n-lib.h"

#include <sys/types.h>

#include <sys/stat.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#include <fcntl.h>
#include <stdio.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef _MSC_VER
#undef stat
#define stat _stat
#define fstat _fstat
#define S_ISREG(m)	(((m)&S_IFREG)==S_IFREG)
#endif
#include <errno.h>
#include <string.h>

#include "gstfdsink.h"

#ifdef G_OS_WIN32
#include <io.h>                 /* lseek, open, close, read */
#undef lseek
#define lseek _lseeki64
#undef off_t
#define off_t guint64
#endif

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_fd_sink__debug);
#define GST_CAT_DEFAULT gst_fd_sink__debug


/* FdSink signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  ARG_0,
  ARG_FD
};

static void gst_fd_sink_uri_handler_init (gpointer g_iface,
    gpointer iface_data);

#define _do_init \
  G_IMPLEMENT_INTERFACE (GST_TYPE_URI_HANDLER, gst_fd_sink_uri_handler_init); \
  GST_DEBUG_CATEGORY_INIT (gst_fd_sink__debug, "fdsink", 0, "fdsink element");
#define gst_fd_sink_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstFdSink, gst_fd_sink, GST_TYPE_BASE_SINK, _do_init);

static void gst_fd_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_fd_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_fd_sink_dispose (GObject * obj);

static gboolean gst_fd_sink_query (GstBaseSink * bsink, GstQuery * query);
static GstFlowReturn gst_fd_sink_render (GstBaseSink * sink,
    GstBuffer * buffer);
static gboolean gst_fd_sink_start (GstBaseSink * basesink);
static gboolean gst_fd_sink_stop (GstBaseSink * basesink);
static gboolean gst_fd_sink_unlock (GstBaseSink * basesink);
static gboolean gst_fd_sink_unlock_stop (GstBaseSink * basesink);
static gboolean gst_fd_sink_event (GstBaseSink * sink, GstEvent * event);

static gboolean gst_fd_sink_do_seek (GstFdSink * fdsink, guint64 new_offset);

static void
gst_fd_sink_class_init (GstFdSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbasesink_class = GST_BASE_SINK_CLASS (klass);

  gobject_class->set_property = gst_fd_sink_set_property;
  gobject_class->get_property = gst_fd_sink_get_property;
  gobject_class->dispose = gst_fd_sink_dispose;

  gst_element_class_set_static_metadata (gstelement_class,
      "Filedescriptor Sink",
      "Sink/File",
      "Write data to a file descriptor", "Erik Walthinsen <omega@cse.ogi.edu>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_fd_sink_render);
  gstbasesink_class->start = GST_DEBUG_FUNCPTR (gst_fd_sink_start);
  gstbasesink_class->stop = GST_DEBUG_FUNCPTR (gst_fd_sink_stop);
  gstbasesink_class->unlock = GST_DEBUG_FUNCPTR (gst_fd_sink_unlock);
  gstbasesink_class->unlock_stop = GST_DEBUG_FUNCPTR (gst_fd_sink_unlock_stop);
  gstbasesink_class->event = GST_DEBUG_FUNCPTR (gst_fd_sink_event);
  gstbasesink_class->query = GST_DEBUG_FUNCPTR (gst_fd_sink_query);

  g_object_class_install_property (gobject_class, ARG_FD,
      g_param_spec_int ("fd", "fd", "An open file descriptor to write to",
          0, G_MAXINT, 1, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

static void
gst_fd_sink_init (GstFdSink * fdsink)
{
  fdsink->fd = 1;
  fdsink->uri = g_strdup_printf ("fd://%d", fdsink->fd);
  fdsink->bytes_written = 0;
  fdsink->current_pos = 0;

  gst_base_sink_set_sync (GST_BASE_SINK (fdsink), FALSE);
}

static void
gst_fd_sink_dispose (GObject * obj)
{
  GstFdSink *fdsink = GST_FD_SINK (obj);

  g_free (fdsink->uri);
  fdsink->uri = NULL;

  G_OBJECT_CLASS (parent_class)->dispose (obj);
}

static gboolean
gst_fd_sink_query (GstBaseSink * bsink, GstQuery * query)
{
  gboolean res = FALSE;
  GstFdSink *fdsink;

  fdsink = GST_FD_SINK (bsink);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      GstFormat format;

      gst_query_parse_position (query, &format, NULL);

      switch (format) {
        case GST_FORMAT_DEFAULT:
        case GST_FORMAT_BYTES:
          gst_query_set_position (query, GST_FORMAT_BYTES, fdsink->current_pos);
          res = TRUE;
          break;
        default:
          break;
      }
      break;
    }
    case GST_QUERY_FORMATS:
      gst_query_set_formats (query, 2, GST_FORMAT_DEFAULT, GST_FORMAT_BYTES);
      res = TRUE;
      break;
    case GST_QUERY_URI:
      gst_query_set_uri (query, fdsink->uri);
      res = TRUE;
      break;
    case GST_QUERY_SEEKING:{
      GstFormat format;

      gst_query_parse_seeking (query, &format, NULL, NULL, NULL);
      if (format == GST_FORMAT_BYTES || format == GST_FORMAT_DEFAULT) {
        gst_query_set_seeking (query, GST_FORMAT_BYTES, fdsink->seekable, 0,
            -1);
      } else {
        gst_query_set_seeking (query, format, FALSE, 0, -1);
      }
      res = TRUE;
      break;
    }
    default:
      res = GST_BASE_SINK_CLASS (parent_class)->query (bsink, query);
      break;

  }
  return res;
}

static GstFlowReturn
gst_fd_sink_render (GstBaseSink * sink, GstBuffer * buffer)
{
  GstFdSink *fdsink;
  GstMapInfo info;
  guint8 *ptr;
  gsize left;
  gint written;

#ifndef HAVE_WIN32
  gint retval;
#endif

  fdsink = GST_FD_SINK (sink);

  g_return_val_if_fail (fdsink->fd >= 0, GST_FLOW_ERROR);

  gst_buffer_map (buffer, &info, GST_MAP_READ);

  ptr = info.data;
  left = info.size;

again:
#ifndef HAVE_WIN32
  do {
    GST_DEBUG_OBJECT (fdsink, "going into select, have %" G_GSIZE_FORMAT
        " bytes to write", info.size);
    retval = gst_poll_wait (fdsink->fdset, GST_CLOCK_TIME_NONE);
  } while (retval == -1 && (errno == EINTR || errno == EAGAIN));

  if (retval == -1) {
    if (errno == EBUSY)
      goto stopped;
    else
      goto select_error;
  }
#endif

  GST_DEBUG_OBJECT (fdsink, "writing %" G_GSIZE_FORMAT " bytes to"
      " file descriptor %d", info.size, fdsink->fd);

  written = write (fdsink->fd, ptr, left);

  /* check for errors */
  if (G_UNLIKELY (written < 0)) {
    /* try to write again on non-fatal errors */
    if (errno == EAGAIN || errno == EINTR)
      goto again;

    /* else go to our error handler */
    goto write_error;
  }

  /* all is fine when we get here */
  left -= written;
  ptr += written;
  fdsink->bytes_written += written;
  fdsink->current_pos += written;

  GST_DEBUG_OBJECT (fdsink, "wrote %d bytes, %" G_GSIZE_FORMAT " left", written,
      left);

  /* short write, select and try to write the remainder */
  if (G_UNLIKELY (left > 0))
    goto again;

  gst_buffer_unmap (buffer, &info);

  return GST_FLOW_OK;

#ifndef HAVE_WIN32
select_error:
  {
    GST_ELEMENT_ERROR (fdsink, RESOURCE, READ, (NULL),
        ("select on file descriptor: %s.", g_strerror (errno)));
    GST_DEBUG_OBJECT (fdsink, "Error during select");
    gst_buffer_unmap (buffer, &info);
    return GST_FLOW_ERROR;
  }
stopped:
  {
    GST_DEBUG_OBJECT (fdsink, "Select stopped");
    gst_buffer_unmap (buffer, &info);
    return GST_FLOW_FLUSHING;
  }
#endif

write_error:
  {
    switch (errno) {
      case ENOSPC:
        GST_ELEMENT_ERROR (fdsink, RESOURCE, NO_SPACE_LEFT, (NULL), (NULL));
        break;
      default:{
        GST_ELEMENT_ERROR (fdsink, RESOURCE, WRITE, (NULL),
            ("Error while writing to file descriptor %d: %s",
                fdsink->fd, g_strerror (errno)));
      }
    }
    gst_buffer_unmap (buffer, &info);
    return GST_FLOW_ERROR;
  }
}

static gboolean
gst_fd_sink_check_fd (GstFdSink * fdsink, int fd, GError ** error)
{
  struct stat stat_results;
  off_t result;

  /* see that it is a valid file descriptor */
  if (fstat (fd, &stat_results) < 0)
    goto invalid;

  if (!S_ISREG (stat_results.st_mode))
    goto not_seekable;

  /* see if it is a seekable stream */
  result = lseek (fd, 0, SEEK_CUR);
  if (result == -1) {
    switch (errno) {
      case EINVAL:
      case EBADF:
        goto invalid;

      case ESPIPE:
        goto not_seekable;
    }
  } else
    GST_DEBUG_OBJECT (fdsink, "File descriptor %d is seekable", fd);

  return TRUE;

invalid:
  {
    GST_ELEMENT_ERROR (fdsink, RESOURCE, WRITE, (NULL),
        ("File descriptor %d is not valid: %s", fd, g_strerror (errno)));
    g_set_error (error, GST_URI_ERROR, GST_URI_ERROR_BAD_REFERENCE,
        "File descriptor %d is not valid: %s", fd, g_strerror (errno));
    return FALSE;
  }
not_seekable:
  {
    GST_DEBUG_OBJECT (fdsink, "File descriptor %d is a pipe", fd);
    return TRUE;
  }
}

static gboolean
gst_fd_sink_start (GstBaseSink * basesink)
{
  GstFdSink *fdsink;
  GstPollFD fd = GST_POLL_FD_INIT;

  fdsink = GST_FD_SINK (basesink);
  if (!gst_fd_sink_check_fd (fdsink, fdsink->fd, NULL))
    return FALSE;

  if ((fdsink->fdset = gst_poll_new (TRUE)) == NULL)
    goto socket_pair;

  fd.fd = fdsink->fd;
  gst_poll_add_fd (fdsink->fdset, &fd);
  gst_poll_fd_ctl_write (fdsink->fdset, &fd, TRUE);

  fdsink->bytes_written = 0;
  fdsink->current_pos = 0;

  fdsink->seekable = gst_fd_sink_do_seek (fdsink, 0);
  GST_INFO_OBJECT (fdsink, "seeking supported: %d", fdsink->seekable);

  return TRUE;

  /* ERRORS */
socket_pair:
  {
    GST_ELEMENT_ERROR (fdsink, RESOURCE, OPEN_READ_WRITE, (NULL),
        GST_ERROR_SYSTEM);
    return FALSE;
  }
}

static gboolean
gst_fd_sink_stop (GstBaseSink * basesink)
{
  GstFdSink *fdsink = GST_FD_SINK (basesink);

  if (fdsink->fdset) {
    gst_poll_free (fdsink->fdset);
    fdsink->fdset = NULL;
  }

  return TRUE;
}

static gboolean
gst_fd_sink_unlock (GstBaseSink * basesink)
{
  GstFdSink *fdsink = GST_FD_SINK (basesink);

  GST_LOG_OBJECT (fdsink, "Flushing");
  GST_OBJECT_LOCK (fdsink);
  gst_poll_set_flushing (fdsink->fdset, TRUE);
  GST_OBJECT_UNLOCK (fdsink);

  return TRUE;
}

static gboolean
gst_fd_sink_unlock_stop (GstBaseSink * basesink)
{
  GstFdSink *fdsink = GST_FD_SINK (basesink);

  GST_LOG_OBJECT (fdsink, "No longer flushing");
  GST_OBJECT_LOCK (fdsink);
  gst_poll_set_flushing (fdsink->fdset, FALSE);
  GST_OBJECT_UNLOCK (fdsink);

  return TRUE;
}

static gboolean
gst_fd_sink_update_fd (GstFdSink * fdsink, int new_fd, GError ** error)
{
  if (new_fd < 0) {
    g_set_error (error, GST_URI_ERROR, GST_URI_ERROR_BAD_REFERENCE,
        "File descriptor %d is not valid", new_fd);
    return FALSE;
  }

  if (!gst_fd_sink_check_fd (fdsink, new_fd, error))
    goto invalid;

  /* assign the fd */
  GST_OBJECT_LOCK (fdsink);
  if (fdsink->fdset) {
    GstPollFD fd = GST_POLL_FD_INIT;

    fd.fd = fdsink->fd;
    gst_poll_remove_fd (fdsink->fdset, &fd);

    fd.fd = new_fd;
    gst_poll_add_fd (fdsink->fdset, &fd);
    gst_poll_fd_ctl_write (fdsink->fdset, &fd, TRUE);
  }
  fdsink->fd = new_fd;
  g_free (fdsink->uri);
  fdsink->uri = g_strdup_printf ("fd://%d", fdsink->fd);

  GST_OBJECT_UNLOCK (fdsink);

  return TRUE;

invalid:
  {
    return FALSE;
  }
}

static void
gst_fd_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstFdSink *fdsink;

  fdsink = GST_FD_SINK (object);

  switch (prop_id) {
    case ARG_FD:{
      int fd;

      fd = g_value_get_int (value);
      gst_fd_sink_update_fd (fdsink, fd, NULL);
      break;
    }
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fd_sink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstFdSink *fdsink;

  fdsink = GST_FD_SINK (object);

  switch (prop_id) {
    case ARG_FD:
      g_value_set_int (value, fdsink->fd);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_fd_sink_do_seek (GstFdSink * fdsink, guint64 new_offset)
{
  off_t result;

  result = lseek (fdsink->fd, new_offset, SEEK_SET);

  if (result == -1)
    goto seek_failed;

  fdsink->current_pos = new_offset;

  GST_DEBUG_OBJECT (fdsink, "File descriptor %d to seek to position "
      "%" G_GUINT64_FORMAT, fdsink->fd, fdsink->current_pos);

  return TRUE;

  /* ERRORS */
seek_failed:
  {
    GST_DEBUG_OBJECT (fdsink, "File descriptor %d failed to seek to position "
        "%" G_GUINT64_FORMAT, fdsink->fd, new_offset);
    return FALSE;
  }
}

static gboolean
gst_fd_sink_event (GstBaseSink * sink, GstEvent * event)
{
  GstEventType type;
  GstFdSink *fdsink;

  fdsink = GST_FD_SINK (sink);

  type = GST_EVENT_TYPE (event);

  switch (type) {
    case GST_EVENT_SEGMENT:
    {
      const GstSegment *segment;

      gst_event_parse_segment (event, &segment);

      if (segment->format == GST_FORMAT_BYTES) {
        /* only try to seek and fail when we are going to a different
         * position */
        if (fdsink->current_pos != segment->start) {
          /* FIXME, the seek should be performed on the pos field, start/stop are
           * just boundaries for valid bytes offsets. We should also fill the file
           * with zeroes if the new position extends the current EOF (sparse streams
           * and segment accumulation). */
          if (!gst_fd_sink_do_seek (fdsink, (guint64) segment->start))
            goto seek_failed;
        }
      } else {
        GST_DEBUG_OBJECT (fdsink,
            "Ignored SEGMENT event of format %u (%s)", (guint) segment->format,
            gst_format_get_name (segment->format));
      }
      break;
    }
    default:
      break;
  }

  return GST_BASE_SINK_CLASS (parent_class)->event (sink, event);

seek_failed:
  {
    GST_ELEMENT_ERROR (fdsink, RESOURCE, SEEK, (NULL),
        ("Error while seeking on file descriptor %d: %s",
            fdsink->fd, g_strerror (errno)));
    gst_event_unref (event);
    return FALSE;
  }

}

/*** GSTURIHANDLER INTERFACE *************************************************/

static GstURIType
gst_fd_sink_uri_get_type (GType type)
{
  return GST_URI_SINK;
}

static const gchar *const *
gst_fd_sink_uri_get_protocols (GType type)
{
  static const gchar *protocols[] = { "fd", NULL };

  return protocols;
}

static gchar *
gst_fd_sink_uri_get_uri (GstURIHandler * handler)
{
  GstFdSink *sink = GST_FD_SINK (handler);

  /* FIXME: make thread-safe */
  return g_strdup (sink->uri);
}

static gboolean
gst_fd_sink_uri_set_uri (GstURIHandler * handler, const gchar * uri,
    GError ** error)
{
  GstFdSink *sink = GST_FD_SINK (handler);
  gint fd;

  if (sscanf (uri, "fd://%d", &fd) != 1) {
    g_set_error (error, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "File descriptor URI could not be parsed");
    return FALSE;
  }

  return gst_fd_sink_update_fd (sink, fd, error);
}

static void
gst_fd_sink_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_fd_sink_uri_get_type;
  iface->get_protocols = gst_fd_sink_uri_get_protocols;
  iface->get_uri = gst_fd_sink_uri_get_uri;
  iface->set_uri = gst_fd_sink_uri_set_uri;
}
