/* GStreamer
 * Copyright (C) 2014 Wim Taymans <wtaymans@redhat.com>
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

#include <glib.h>

#ifndef __GST_SPARSE_FILE_H__
#define __GST_SPARSE_FILE_H__

G_BEGIN_DECLS

typedef struct _GstSparseFile GstSparseFile;

/* NOTE: Remove this before making this public API again! */
typedef enum {
  GST_SPARSE_FILE_IO_ERROR_FAILED,
  GST_SPARSE_FILE_IO_ERROR_NOT_FOUND,
  GST_SPARSE_FILE_IO_ERROR_EXISTS,
  GST_SPARSE_FILE_IO_ERROR_IS_DIRECTORY,
  GST_SPARSE_FILE_IO_ERROR_NOT_DIRECTORY,
  GST_SPARSE_FILE_IO_ERROR_NOT_EMPTY,
  GST_SPARSE_FILE_IO_ERROR_NOT_REGULAR_FILE,
  GST_SPARSE_FILE_IO_ERROR_NOT_SYMBOLIC_LINK,
  GST_SPARSE_FILE_IO_ERROR_NOT_MOUNTABLE_FILE,
  GST_SPARSE_FILE_IO_ERROR_FILENAME_TOO_LONG,
  GST_SPARSE_FILE_IO_ERROR_INVALID_FILENAME,
  GST_SPARSE_FILE_IO_ERROR_TOO_MANY_LINKS,
  GST_SPARSE_FILE_IO_ERROR_NO_SPACE,
  GST_SPARSE_FILE_IO_ERROR_INVALID_ARGUMENT,
  GST_SPARSE_FILE_IO_ERROR_PERMISSION_DENIED,
  GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED,
  GST_SPARSE_FILE_IO_ERROR_NOT_MOUNTED,
  GST_SPARSE_FILE_IO_ERROR_ALREADY_MOUNTED,
  GST_SPARSE_FILE_IO_ERROR_CLOSED,
  GST_SPARSE_FILE_IO_ERROR_CANCELLED,
  GST_SPARSE_FILE_IO_ERROR_PENDING,
  GST_SPARSE_FILE_IO_ERROR_READ_ONLY,
  GST_SPARSE_FILE_IO_ERROR_CANT_CREATE_BACKUP,
  GST_SPARSE_FILE_IO_ERROR_WRONG_ETAG,
  GST_SPARSE_FILE_IO_ERROR_TIMED_OUT,
  GST_SPARSE_FILE_IO_ERROR_WOULD_RECURSE,
  GST_SPARSE_FILE_IO_ERROR_BUSY,
  GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK,
  GST_SPARSE_FILE_IO_ERROR_HOST_NOT_FOUND,
  GST_SPARSE_FILE_IO_ERROR_WOULD_MERGE,
  GST_SPARSE_FILE_IO_ERROR_FAILED_HANDLED,
  GST_SPARSE_FILE_IO_ERROR_TOO_MANY_OPEN_FILES,
  GST_SPARSE_FILE_IO_ERROR_NOT_INITIALIZED,
  GST_SPARSE_FILE_IO_ERROR_ADDRESS_IN_USE,
  GST_SPARSE_FILE_IO_ERROR_PARTIAL_INPUT,
  GST_SPARSE_FILE_IO_ERROR_INVALID_DATA,
  GST_SPARSE_FILE_IO_ERROR_DBUS_ERROR,
  GST_SPARSE_FILE_IO_ERROR_HOST_UNREACHABLE,
  GST_SPARSE_FILE_IO_ERROR_NETWORK_UNREACHABLE,
  GST_SPARSE_FILE_IO_ERROR_CONNECTION_REFUSED,
  GST_SPARSE_FILE_IO_ERROR_PROXY_FAILED,
  GST_SPARSE_FILE_IO_ERROR_PROXY_AUTH_FAILED,
  GST_SPARSE_FILE_IO_ERROR_PROXY_NEED_AUTH,
  GST_SPARSE_FILE_IO_ERROR_PROXY_NOT_ALLOWED,
  GST_SPARSE_FILE_IO_ERROR_BROKEN_PIPE
} GstSparseFileIOErrorEnum;

GstSparseFile * gst_sparse_file_new          (void);
void            gst_sparse_file_free         (GstSparseFile *file);

gboolean        gst_sparse_file_set_fd       (GstSparseFile *file, gint fd);
void            gst_sparse_file_clear        (GstSparseFile *file);

gsize           gst_sparse_file_write        (GstSparseFile *file,
                                              gsize offset,
                                              gconstpointer data,
                                              gsize count,
                                              gsize *available,
                                              GError **error);

gsize           gst_sparse_file_read         (GstSparseFile *file,
                                              gsize offset,
                                              gpointer data,
                                              gsize count,
                                              gsize *remaining,
                                              GError **error);

guint           gst_sparse_file_n_ranges         (GstSparseFile *file);

gboolean        gst_sparse_file_get_range_before (GstSparseFile *file, gsize offset,
                                                  gsize *start, gsize *stop);

gboolean        gst_sparse_file_get_range_after  (GstSparseFile *file, gsize offset,
                                                  gsize *start, gsize *stop);

G_END_DECLS

#endif /* __GST_SPARSE_FILE_H__ */
