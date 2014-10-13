/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Philippe Khalaf <burger@speedy.org>
 *
 * gstfdsrc.c:
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
 * SECTION:element-fdsrc
 * @see_also: #GstFdSink
 *
 * Read data from a unix file descriptor.
 *
 * To generate data, enter some data on the console followed by enter.
 * The above mentioned pipeline should dump data packets to the console.
 *
 * If the #GstFdSrc:timeout property is set to a value bigger than 0, fdsrc will
 * generate an element message named
 * <classname>&quot;GstFdSrcTimeout&quot;</classname>
 * if no data was received in the given timeout.
 * The message's structure contains one field:
 * <itemizedlist>
 * <listitem>
 *   <para>
 *   #guint64
 *   <classname>&quot;timeout&quot;</classname>: the timeout in microseconds that
 *   expired when waiting for data.
 *   </para>
 * </listitem>
 * </itemizedlist>
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * echo "Hello GStreamer" | gst-launch -v fdsrc ! fakesink dump=true
 * ]| A simple pipeline to read from the standard input and dump the data
 * with a fakesink as hex ascii block.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif
#include "gst/gst_private.h"

#include <sys/types.h>

#ifdef G_OS_WIN32
#include <io.h>                 /* lseek, open, close, read */
#undef lseek
#define lseek _lseeki64
#undef off_t
#define off_t guint64
#endif

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
#include <stdlib.h>
#include <errno.h>

#include "gstfdsrc.h"

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_fd_src_debug);
#define GST_CAT_DEFAULT gst_fd_src_debug

#define DEFAULT_FD              0
#define DEFAULT_TIMEOUT         0

enum
{
  PROP_0,

  PROP_FD,
  PROP_TIMEOUT,

  PROP_LAST
};

static void gst_fd_src_uri_handler_init (gpointer g_iface, gpointer iface_data);

#define _do_init \
  G_IMPLEMENT_INTERFACE (GST_TYPE_URI_HANDLER, gst_fd_src_uri_handler_init); \
  GST_DEBUG_CATEGORY_INIT (gst_fd_src_debug, "fdsrc", 0, "fdsrc element");
#define gst_fd_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstFdSrc, gst_fd_src, GST_TYPE_PUSH_SRC, _do_init);

static void gst_fd_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_fd_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_fd_src_dispose (GObject * obj);

static gboolean gst_fd_src_start (GstBaseSrc * bsrc);
static gboolean gst_fd_src_stop (GstBaseSrc * bsrc);
static gboolean gst_fd_src_unlock (GstBaseSrc * bsrc);
static gboolean gst_fd_src_unlock_stop (GstBaseSrc * bsrc);
static gboolean gst_fd_src_is_seekable (GstBaseSrc * bsrc);
static gboolean gst_fd_src_get_size (GstBaseSrc * src, guint64 * size);
static gboolean gst_fd_src_do_seek (GstBaseSrc * src, GstSegment * segment);
static gboolean gst_fd_src_query (GstBaseSrc * src, GstQuery * query);

static GstFlowReturn gst_fd_src_create (GstPushSrc * psrc, GstBuffer ** outbuf);

static void
gst_fd_src_class_init (GstFdSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSrcClass *gstbasesrc_class;
  GstPushSrcClass *gstpush_src_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbasesrc_class = GST_BASE_SRC_CLASS (klass);
  gstpush_src_class = GST_PUSH_SRC_CLASS (klass);

  gobject_class->set_property = gst_fd_src_set_property;
  gobject_class->get_property = gst_fd_src_get_property;
  gobject_class->dispose = gst_fd_src_dispose;

  g_object_class_install_property (gobject_class, PROP_FD,
      g_param_spec_int ("fd", "fd", "An open file descriptor to read from",
          0, G_MAXINT, DEFAULT_FD, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstFdSrc:timeout
   *
   * Post a message after timeout microseconds
   */
  g_object_class_install_property (G_OBJECT_CLASS (klass), PROP_TIMEOUT,
      g_param_spec_uint64 ("timeout", "Timeout",
          "Post a message after timeout microseconds (0 = disabled)", 0,
          G_MAXUINT64, DEFAULT_TIMEOUT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (gstelement_class,
      "Filedescriptor Source",
      "Source/File",
      "Read from a file descriptor", "Erik Walthinsen <omega@cse.ogi.edu>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));

  gstbasesrc_class->start = GST_DEBUG_FUNCPTR (gst_fd_src_start);
  gstbasesrc_class->stop = GST_DEBUG_FUNCPTR (gst_fd_src_stop);
  gstbasesrc_class->unlock = GST_DEBUG_FUNCPTR (gst_fd_src_unlock);
  gstbasesrc_class->unlock_stop = GST_DEBUG_FUNCPTR (gst_fd_src_unlock_stop);
  gstbasesrc_class->is_seekable = GST_DEBUG_FUNCPTR (gst_fd_src_is_seekable);
  gstbasesrc_class->get_size = GST_DEBUG_FUNCPTR (gst_fd_src_get_size);
  gstbasesrc_class->do_seek = GST_DEBUG_FUNCPTR (gst_fd_src_do_seek);
  gstbasesrc_class->query = GST_DEBUG_FUNCPTR (gst_fd_src_query);

  gstpush_src_class->create = GST_DEBUG_FUNCPTR (gst_fd_src_create);
}

static void
gst_fd_src_init (GstFdSrc * fdsrc)
{
  fdsrc->new_fd = DEFAULT_FD;
  fdsrc->seekable_fd = FALSE;
  fdsrc->fd = -1;
  fdsrc->size = -1;
  fdsrc->timeout = DEFAULT_TIMEOUT;
  fdsrc->uri = g_strdup_printf ("fd://0");
  fdsrc->curoffset = 0;
}

static void
gst_fd_src_dispose (GObject * obj)
{
  GstFdSrc *src = GST_FD_SRC (obj);

  g_free (src->uri);
  src->uri = NULL;

  G_OBJECT_CLASS (parent_class)->dispose (obj);
}

static void
gst_fd_src_update_fd (GstFdSrc * src, guint64 size)
{
  struct stat stat_results;

  GST_DEBUG_OBJECT (src, "fdset %p, old_fd %d, new_fd %d", src->fdset, src->fd,
      src->new_fd);

  /* we need to always update the fdset since it may not have existed when
   * gst_fd_src_update_fd () was called earlier */
  if (src->fdset != NULL) {
    GstPollFD fd = GST_POLL_FD_INIT;

    if (src->fd >= 0) {
      fd.fd = src->fd;
      /* this will log a harmless warning, if it was never added */
      gst_poll_remove_fd (src->fdset, &fd);
    }

    fd.fd = src->new_fd;
    gst_poll_add_fd (src->fdset, &fd);
    gst_poll_fd_ctl_read (src->fdset, &fd, TRUE);
  }


  if (src->fd != src->new_fd) {
    GST_INFO_OBJECT (src, "Updating to fd %d", src->new_fd);

    src->fd = src->new_fd;

    GST_INFO_OBJECT (src, "Setting size to fd %" G_GUINT64_FORMAT, size);
    src->size = size;

    g_free (src->uri);
    src->uri = g_strdup_printf ("fd://%d", src->fd);

    if (fstat (src->fd, &stat_results) < 0)
      goto not_seekable;

    if (!S_ISREG (stat_results.st_mode))
      goto not_seekable;

    /* Try a seek of 0 bytes offset to check for seekability */
    if (lseek (src->fd, 0, SEEK_CUR) < 0)
      goto not_seekable;

    GST_INFO_OBJECT (src, "marking fd %d as seekable", src->fd);
    src->seekable_fd = TRUE;

    gst_base_src_set_dynamic_size (GST_BASE_SRC (src), TRUE);
  }
  return;

not_seekable:
  {
    GST_INFO_OBJECT (src, "marking fd %d as NOT seekable", src->fd);
    src->seekable_fd = FALSE;
    gst_base_src_set_dynamic_size (GST_BASE_SRC (src), FALSE);
  }
}

static gboolean
gst_fd_src_start (GstBaseSrc * bsrc)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);

  src->curoffset = 0;

  if ((src->fdset = gst_poll_new (TRUE)) == NULL)
    goto socket_pair;

  gst_fd_src_update_fd (src, -1);

  return TRUE;

  /* ERRORS */
socket_pair:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ_WRITE, (NULL),
        GST_ERROR_SYSTEM);
    return FALSE;
  }
}

static gboolean
gst_fd_src_stop (GstBaseSrc * bsrc)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);

  if (src->fdset) {
    gst_poll_free (src->fdset);
    src->fdset = NULL;
  }

  return TRUE;
}

static gboolean
gst_fd_src_unlock (GstBaseSrc * bsrc)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);

  GST_LOG_OBJECT (src, "Flushing");
  GST_OBJECT_LOCK (src);
  gst_poll_set_flushing (src->fdset, TRUE);
  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

static gboolean
gst_fd_src_unlock_stop (GstBaseSrc * bsrc)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);

  GST_LOG_OBJECT (src, "No longer flushing");
  GST_OBJECT_LOCK (src);
  gst_poll_set_flushing (src->fdset, FALSE);
  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

static void
gst_fd_src_set_property (GObject * object, guint prop_id, const GValue * value,
    GParamSpec * pspec)
{
  GstFdSrc *src = GST_FD_SRC (object);

  switch (prop_id) {
    case PROP_FD:
      src->new_fd = g_value_get_int (value);

      /* If state is ready or below, update the current fd immediately
       * so it is reflected in get_properties and uri */
      GST_OBJECT_LOCK (object);
      if (GST_STATE (GST_ELEMENT (src)) <= GST_STATE_READY) {
        GST_DEBUG_OBJECT (src, "state ready or lower, updating to use new fd");
        gst_fd_src_update_fd (src, -1);
      } else {
        GST_DEBUG_OBJECT (src, "state above ready, not updating to new fd yet");
      }
      GST_OBJECT_UNLOCK (object);
      break;
    case PROP_TIMEOUT:
      src->timeout = g_value_get_uint64 (value);
      GST_DEBUG_OBJECT (src, "poll timeout set to %" GST_TIME_FORMAT,
          GST_TIME_ARGS (src->timeout));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fd_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstFdSrc *src = GST_FD_SRC (object);

  switch (prop_id) {
    case PROP_FD:
      g_value_set_int (value, src->fd);
      break;
    case PROP_TIMEOUT:
      g_value_set_uint64 (value, src->timeout);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstFlowReturn
gst_fd_src_create (GstPushSrc * psrc, GstBuffer ** outbuf)
{
  GstFdSrc *src;
  GstBuffer *buf;
  gssize readbytes;
  guint blocksize;
  GstMapInfo info;

#ifndef HAVE_WIN32
  GstClockTime timeout;
  gboolean try_again;
  gint retval;
#endif

  src = GST_FD_SRC (psrc);

#ifndef HAVE_WIN32
  if (src->timeout > 0) {
    timeout = src->timeout * GST_USECOND;
  } else {
    timeout = GST_CLOCK_TIME_NONE;
  }

  do {
    try_again = FALSE;

    GST_LOG_OBJECT (src, "doing poll, timeout %" GST_TIME_FORMAT,
        GST_TIME_ARGS (src->timeout));

    retval = gst_poll_wait (src->fdset, timeout);
    GST_LOG_OBJECT (src, "poll returned %d", retval);

    if (G_UNLIKELY (retval == -1)) {
      if (errno == EINTR || errno == EAGAIN) {
        /* retry if interrupted */
        try_again = TRUE;
      } else if (errno == EBUSY) {
        goto stopped;
      } else {
        goto poll_error;
      }
    } else if (G_UNLIKELY (retval == 0)) {
      try_again = TRUE;
      /* timeout, post element message */
      gst_element_post_message (GST_ELEMENT_CAST (src),
          gst_message_new_element (GST_OBJECT_CAST (src),
              gst_structure_new ("GstFdSrcTimeout",
                  "timeout", G_TYPE_UINT64, src->timeout, NULL)));
    }
  } while (G_UNLIKELY (try_again));     /* retry if interrupted or timeout */
#endif

  blocksize = GST_BASE_SRC (src)->blocksize;

  /* create the buffer */
  buf = gst_buffer_new_allocate (NULL, blocksize, NULL);
  if (G_UNLIKELY (buf == NULL))
    goto alloc_failed;

  gst_buffer_map (buf, &info, GST_MAP_WRITE);

  do {
    readbytes = read (src->fd, info.data, blocksize);
    GST_LOG_OBJECT (src, "read %" G_GSSIZE_FORMAT, readbytes);
  } while (readbytes == -1 && errno == EINTR);  /* retry if interrupted */

  if (readbytes < 0)
    goto read_error;

  gst_buffer_unmap (buf, &info);
  gst_buffer_resize (buf, 0, readbytes);

  if (readbytes == 0)
    goto eos;

  GST_BUFFER_OFFSET (buf) = src->curoffset;
  GST_BUFFER_TIMESTAMP (buf) = GST_CLOCK_TIME_NONE;
  src->curoffset += readbytes;

  GST_LOG_OBJECT (psrc, "Read buffer of size %" G_GSSIZE_FORMAT, readbytes);

  /* we're done, return the buffer */
  *outbuf = buf;

  return GST_FLOW_OK;

  /* ERRORS */
#ifndef HAVE_WIN32
poll_error:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
        ("poll on file descriptor: %s.", g_strerror (errno)));
    GST_DEBUG_OBJECT (psrc, "Error during poll");
    return GST_FLOW_ERROR;
  }
stopped:
  {
    GST_DEBUG_OBJECT (psrc, "Poll stopped");
    return GST_FLOW_FLUSHING;
  }
#endif
alloc_failed:
  {
    GST_ERROR_OBJECT (src, "Failed to allocate %u bytes", blocksize);
    return GST_FLOW_ERROR;
  }
eos:
  {
    GST_DEBUG_OBJECT (psrc, "Read 0 bytes. EOS.");
    gst_buffer_unref (buf);
    return GST_FLOW_EOS;
  }
read_error:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
        ("read on file descriptor: %s.", g_strerror (errno)));
    GST_DEBUG_OBJECT (psrc, "Error reading from fd");
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return GST_FLOW_ERROR;
  }
}

static gboolean
gst_fd_src_query (GstBaseSrc * basesrc, GstQuery * query)
{
  gboolean ret = FALSE;
  GstFdSrc *src = GST_FD_SRC (basesrc);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_URI:
      gst_query_set_uri (query, src->uri);
      ret = TRUE;
      break;
    default:
      ret = FALSE;
      break;
  }

  if (!ret)
    ret = GST_BASE_SRC_CLASS (parent_class)->query (basesrc, query);

  return ret;
}

static gboolean
gst_fd_src_is_seekable (GstBaseSrc * bsrc)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);

  return src->seekable_fd;
}

static gboolean
gst_fd_src_get_size (GstBaseSrc * bsrc, guint64 * size)
{
  GstFdSrc *src = GST_FD_SRC (bsrc);
  struct stat stat_results;

  if (src->size != -1) {
    *size = src->size;
    return TRUE;
  }

  if (!src->seekable_fd) {
    /* If it isn't seekable, we won't know the length (but fstat will still
     * succeed, and wrongly say our length is zero. */
    return FALSE;
  }

  if (fstat (src->fd, &stat_results) < 0)
    goto could_not_stat;

  *size = stat_results.st_size;

  return TRUE;

  /* ERROR */
could_not_stat:
  {
    return FALSE;
  }
}

static gboolean
gst_fd_src_do_seek (GstBaseSrc * bsrc, GstSegment * segment)
{
  gint res;
  gint64 offset;
  GstFdSrc *src = GST_FD_SRC (bsrc);

  offset = segment->start;

  /* No need to seek to the current position */
  if (offset == src->curoffset)
    return TRUE;

  res = lseek (src->fd, offset, SEEK_SET);
  if (G_UNLIKELY (res < 0 || res != offset))
    goto seek_failed;

  segment->position = segment->start;
  segment->time = segment->start;

  return TRUE;

seek_failed:
  GST_DEBUG_OBJECT (src, "lseek returned %" G_GINT64_FORMAT, offset);
  return FALSE;
}

/*** GSTURIHANDLER INTERFACE *************************************************/

static GstURIType
gst_fd_src_uri_get_type (GType type)
{
  return GST_URI_SRC;
}

static const gchar *const *
gst_fd_src_uri_get_protocols (GType type)
{
  static const gchar *protocols[] = { "fd", NULL };

  return protocols;
}

static gchar *
gst_fd_src_uri_get_uri (GstURIHandler * handler)
{
  GstFdSrc *src = GST_FD_SRC (handler);

  /* FIXME: make thread-safe */
  return g_strdup (src->uri);
}

static gboolean
gst_fd_src_uri_set_uri (GstURIHandler * handler, const gchar * uri,
    GError ** err)
{
  gchar *protocol, *q;
  GstFdSrc *src = GST_FD_SRC (handler);
  gint fd;
  guint64 size = (guint64) - 1;

  GST_INFO_OBJECT (src, "checking uri %s", uri);

  protocol = gst_uri_get_protocol (uri);
  if (strcmp (protocol, "fd") != 0) {
    g_set_error (err, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "Wrong protocol for fdsrc in uri: '%s'", uri);
    g_free (protocol);
    return FALSE;
  }
  g_free (protocol);

  if (sscanf (uri, "fd://%d", &fd) != 1 || fd < 0) {
    g_set_error (err, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "Bad file descriptor number in uri: '%s'", uri);
    return FALSE;
  }

  if ((q = g_strstr_len (uri, -1, "?"))) {
    gchar *sp;

    GST_INFO_OBJECT (src, "found ?");

    if ((sp = g_strstr_len (q, -1, "size="))) {
      if (sscanf (sp, "size=%" G_GUINT64_FORMAT, &size) != 1) {
        GST_INFO_OBJECT (src, "parsing size failed");
        size = -1;
      } else {
        GST_INFO_OBJECT (src, "found size %" G_GUINT64_FORMAT, size);
      }
    }
  }

  src->new_fd = fd;

  GST_OBJECT_LOCK (src);
  if (GST_STATE (GST_ELEMENT (src)) <= GST_STATE_READY) {
    gst_fd_src_update_fd (src, size);
  }
  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

static void
gst_fd_src_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_fd_src_uri_get_type;
  iface->get_protocols = gst_fd_src_uri_get_protocols;
  iface->get_uri = gst_fd_src_uri_get_uri;
  iface->set_uri = gst_fd_src_uri_set_uri;
}
