/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstfilesrc.h:
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

#ifndef __GST_FILE_SRC_H__
#define __GST_FILE_SRC_H__

#include <sys/types.h>

#include <gst/gst.h>
#include <gst/base/gstbasesrc.h>

G_BEGIN_DECLS

#define GST_TYPE_FILE_SRC \
  (gst_file_src_get_type())
#define GST_FILE_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FILE_SRC,GstFileSrc))
#define GST_FILE_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FILE_SRC,GstFileSrcClass))
#define GST_IS_FILE_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FILE_SRC))
#define GST_IS_FILE_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FILE_SRC))
#define GST_FILE_SRC_CAST(obj) ((GstFileSrc*) obj)

typedef struct _GstFileSrc GstFileSrc;
typedef struct _GstFileSrcClass GstFileSrcClass;

/**
 * GstFileSrc:
 *
 * Opaque #GstFileSrc structure.
 */
struct _GstFileSrc {
  GstBaseSrc element;

  /*< private >*/
  gchar *filename;			/* filename */
  gchar *uri;				/* caching the URI */
  gint fd;				/* open file descriptor */
  guint64 read_position;		/* position of fd */

  gboolean seekable;                    /* whether the file is seekable */
  gboolean is_regular;                  /* whether it's a (symlink to a)
                                           regular file */
};

struct _GstFileSrcClass {
  GstBaseSrcClass parent_class;
};

G_GNUC_INTERNAL GType gst_file_src_get_type (void);

G_END_DECLS

#endif /* __GST_FILE_SRC_H__ */
