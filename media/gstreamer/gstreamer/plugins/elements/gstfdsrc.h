/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Philippe Khalaf <burger@speedy.org>
 *
 * gstfdsrc.h:
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


#ifndef __GST_FD_SRC_H__
#define __GST_FD_SRC_H__

#include <gst/gst.h>
#include <gst/base/gstpushsrc.h>

G_BEGIN_DECLS


#define GST_TYPE_FD_SRC \
  (gst_fd_src_get_type())
#define GST_FD_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FD_SRC,GstFdSrc))
#define GST_FD_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FD_SRC,GstFdSrcClass))
#define GST_IS_FD_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FD_SRC))
#define GST_IS_FD_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FD_SRC))


typedef struct _GstFdSrc GstFdSrc;
typedef struct _GstFdSrcClass GstFdSrcClass;

/**
 * GstFdSrc:
 *
 * Opaque #GstFdSrc data structure.
 */
struct _GstFdSrc {
  GstPushSrc element;

  /*< private >*/
  /* new_fd is copied to fd on READY->PAUSED */
  gint new_fd;

  /* fd and flag indicating whether fd is seekable */
  gint fd;
  gboolean seekable_fd;
  guint64 size;

  /* poll timeout */
  guint64 timeout;

  gchar *uri;

  GstPoll *fdset;

  gulong curoffset; /* current offset in file */
};

struct _GstFdSrcClass {
  GstPushSrcClass parent_class;

  /* signals */
  void (*timeout) (GstElement *element);
};

G_GNUC_INTERNAL GType gst_fd_src_get_type(void);

G_END_DECLS

#endif /* __GST_FD_SRC_H__ */
