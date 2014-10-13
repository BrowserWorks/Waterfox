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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <glib/gstdio.h>

#include "gstsparsefile.h"

#ifdef G_OS_WIN32
#include <io.h>                 /* lseek, open, close, read */
#undef lseek
#define lseek _lseeki64
#undef off_t
#define off_t guint64
#else
#include <unistd.h>
#endif

#ifdef HAVE_FSEEKO
#define FSEEK_FILE(file,offset)  (fseeko (file, (off_t) offset, SEEK_SET) != 0)
#elif defined (G_OS_UNIX) || defined (G_OS_WIN32)
#define FSEEK_FILE(file,offset)  (lseek (fileno (file), (off_t) offset, SEEK_SET) == (off_t) -1)
#else
#define FSEEK_FILE(file,offset)  (fseek (file, offset, SEEK_SET) != 0)
#endif

#define GST_SPARSE_FILE_IO_ERROR \
    g_quark_from_static_string("gst-sparse-file-io-error-quark")

static GstSparseFileIOErrorEnum
gst_sparse_file_io_error_from_errno (gint err_no);

typedef struct _GstSparseRange GstSparseRange;

struct _GstSparseRange
{
  GstSparseRange *next;

  gsize start;
  gsize stop;
};

#define RANGE_CONTAINS(r,o) ((r)->start <= (o) && (r)->stop > (o))

struct _GstSparseFile
{
  gint fd;
  FILE *file;
  gsize current_pos;

  GstSparseRange *ranges;
  guint n_ranges;

  GstSparseRange *write_range;
  GstSparseRange *read_range;
};

static GstSparseRange *
get_write_range (GstSparseFile * file, gsize offset)
{
  GstSparseRange *next, *prev, *result = NULL;

  if (file->write_range && file->write_range->stop == offset)
    return file->write_range;

  prev = NULL;
  next = file->ranges;
  while (next) {
    if (next->start > offset)
      break;

    if (next->stop >= offset) {
      result = next;
      break;
    }
    prev = next;
    next = next->next;
  }
  if (result == NULL) {
    result = g_slice_new0 (GstSparseRange);
    result->start = offset;
    result->stop = offset;

    result->next = next;
    if (prev)
      prev->next = result;
    else
      file->ranges = result;

    file->write_range = result;
    file->read_range = NULL;

    file->n_ranges++;
  }
  return result;
}

static GstSparseRange *
get_read_range (GstSparseFile * file, gsize offset, gsize count)
{
  GstSparseRange *walk, *result = NULL;

  if (file->read_range && RANGE_CONTAINS (file->read_range, offset))
    return file->read_range;

  for (walk = file->ranges; walk; walk = walk->next) {
    if (walk->start > offset)
      break;

    if (walk->stop >= offset + count) {
      result = walk;
      break;
    }
  }
  return result;
}

/**
 * gst_sparse_file_new:
 *
 * Make a new #GstSparseFile backed by the file represented with @fd.
 *
 * Returns: a new #GstSparseFile, gst_sparse_file_free() after usage.
 *
 * Since: 1.4
 */
GstSparseFile *
gst_sparse_file_new (void)
{
  GstSparseFile *result;

  result = g_slice_new0 (GstSparseFile);
  result->current_pos = 0;
  result->ranges = NULL;
  result->n_ranges = 0;

  return result;
}

/**
 * gst_sparse_file_set_fd:
 * @file: a #GstSparseFile
 * @fd: a file descriptor
 *
 * Store the data for @file in the file represented with @fd.
 *
 * Returns: %TRUE when @fd could be set
 *
 * Since: 1.4
 */
gboolean
gst_sparse_file_set_fd (GstSparseFile * file, gint fd)
{
  g_return_val_if_fail (file != NULL, FALSE);
  g_return_val_if_fail (fd != 0, FALSE);

  file->file = fdopen (fd, "wb+");
  file->fd = fd;

  return file->file != NULL;
}

/**
 * gst_sparse_file_clear:
 * @file: a #GstSparseFile
 *
 * Clear all the ranges in @file.
 */
void
gst_sparse_file_clear (GstSparseFile * file)
{
  g_return_if_fail (file != NULL);

  if (file->file) {
    fclose (file->file);
    file->file = fdopen (file->fd, "wb+");
  }
  g_slice_free_chain (GstSparseRange, file->ranges, next);
  file->current_pos = 0;
  file->ranges = NULL;
  file->n_ranges = 0;
}

/**
 * gst_sparse_file_free:
 * @file: a #GstSparseFile
 *
 * Free the memory used by @file.
 *
 * Since: 1.4
 */
void
gst_sparse_file_free (GstSparseFile * file)
{
  g_return_if_fail (file != NULL);

  if (file->file) {
    fflush (file->file);
    fclose (file->file);
  }
  g_slice_free_chain (GstSparseRange, file->ranges, next);
  g_slice_free (GstSparseFile, file);
}

/**
 * gst_sparse_file_write:
 * @file: a #GstSparseFile
 * @offset: the offset
 * @data: the data
 * @count: amount of bytes
 * @available: amount of bytes already available
 * @error: a #GError
 *
 * Write @count bytes from @data to @file at @offset.
 *
 * If @available is not %NULL, it will be updated with the amount of
 * data already available after the last written byte.
 *
 * Returns: The number of bytes written of 0 on error.
 *
 * Since: 1.4
 */
gsize
gst_sparse_file_write (GstSparseFile * file, gsize offset, gconstpointer data,
    gsize count, gsize * available, GError ** error)
{
  GstSparseRange *range, *next;
  gsize stop;

  g_return_val_if_fail (file != NULL, 0);
  g_return_val_if_fail (count != 0, 0);

  if (file->file) {
    if (file->current_pos != offset) {
      GST_DEBUG ("seeking to %" G_GSIZE_FORMAT, offset);
      if (FSEEK_FILE (file->file, offset))
        goto error;
    }
    if (fwrite (data, count, 1, file->file) != 1)
      goto error;
  }

  file->current_pos = offset + count;

  /* update the new stop position in the range */
  range = get_write_range (file, offset);
  stop = offset + count;
  range->stop = MAX (range->stop, stop);

  /* see if we can merge with next region */
  while ((next = range->next)) {
    if (next->start > range->stop)
      break;

    GST_DEBUG ("merging range %" G_GSIZE_FORMAT "-%" G_GSIZE_FORMAT ", next %"
        G_GSIZE_FORMAT "-%" G_GSIZE_FORMAT, range->start, range->stop,
        next->start, next->stop);

    range->stop = MAX (next->stop, range->stop);
    range->next = next->next;

    if (file->write_range == next)
      file->write_range = NULL;
    if (file->read_range == next)
      file->read_range = NULL;
    g_slice_free (GstSparseRange, next);
    file->n_ranges--;
  }
  if (available)
    *available = range->stop - stop;

  return count;

  /* ERRORS */
error:
  {
    g_set_error (error, GST_SPARSE_FILE_IO_ERROR,
        gst_sparse_file_io_error_from_errno (errno), "Error writing file: %s",
        g_strerror (errno));
    return 0;
  }
}

/**
 * gst_sparse_file_read:
 * @file: a #GstSparseFile
 * @offset: the offset
 * @data: the data
 * @count: amount of bytes
 * @remaining: amount of bytes remaining
 * @error: a #GError
 *
 * Read @count bytes from @file at @offset into @data.
 *
 * On error, @error will be set. If there are no @count bytes available
 * at @offset, %GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK is returned.
 *
 * @remaining will be set to the amount of bytes remaining in the read
 * range.
 *
 * Returns: The number of bytes read of 0 on error.
 *
 * Since: 1.4
 */
gsize
gst_sparse_file_read (GstSparseFile * file, gsize offset, gpointer data,
    gsize count, gsize * remaining, GError ** error)
{
  GstSparseRange *range;
  gsize res = 0;

  g_return_val_if_fail (file != NULL, 0);
  g_return_val_if_fail (count != 0, 0);

  if ((range = get_read_range (file, offset, count)) == NULL)
    goto no_range;

  if (file->file) {
    if (file->current_pos != offset) {
      GST_DEBUG ("seeking from %" G_GSIZE_FORMAT " to %" G_GSIZE_FORMAT,
          file->current_pos, offset);
      if (FSEEK_FILE (file->file, offset))
        goto error;
    }
    res = fread (data, 1, count, file->file);
  }

  file->current_pos = offset + res;

  if (G_UNLIKELY (res < count))
    goto error;

  if (remaining)
    *remaining = range->stop - file->current_pos;

  return count;

  /* ERRORS */
no_range:
  {
    g_set_error_literal (error, GST_SPARSE_FILE_IO_ERROR,
        GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK, "Offset not written to file yet");
    return 0;
  }
error:
  {
    if (ferror (file->file)) {
      g_set_error (error, GST_SPARSE_FILE_IO_ERROR,
          gst_sparse_file_io_error_from_errno (errno), "Error reading file: %s",
          g_strerror (errno));
    } else if (feof (file->file)) {
      return res;
    }
    return 0;
  }
}

/**
 * gst_sparse_file_n_ranges:
 * @file: a #GstSparseFile
 *
 * Get the number of ranges that are written in @file.
 *
 * Returns: the number of written ranges.
 *
 * Since: 1.4
 */
guint
gst_sparse_file_n_ranges (GstSparseFile * file)
{
  g_return_val_if_fail (file != NULL, 0);

  return file->n_ranges;
}

/**
 * gst_sparse_file_get_range_before:
 * @file: a #GstSparseFile
 * @offset: the range offset
 * @start: result start
 * @stop: result stop
 *
 * Get the start and stop offset of the range containing data before or
 * including @offset.
 *
 * Returns: %TRUE if the range with data before @offset exists.
 *
 * Since: 1.4
 */
gboolean
gst_sparse_file_get_range_before (GstSparseFile * file, gsize offset,
    gsize * start, gsize * stop)
{
  GstSparseRange *walk, *result = NULL;

  g_return_val_if_fail (file != NULL, FALSE);

  for (walk = file->ranges; walk; walk = walk->next) {
    GST_DEBUG ("start %" G_GSIZE_FORMAT " > %" G_GSIZE_FORMAT,
        walk->stop, offset);
    if (walk->start > offset)
      break;

    if (walk->start <= offset)
      result = walk;
  }

  if (result) {
    if (start)
      *start = result->start;
    if (stop)
      *stop = result->stop;
  }
  return result != NULL;
}

/**
 * gst_sparse_file_get_range_after:
 * @file: a #GstSparseFile
 * @offset: the range offset
 * @start: result start
 * @stop: result stop
 *
 * Get the start and stop offset of the range containing data after or
 * including @offset.
 *
 * Returns: %TRUE if the range with data after @offset exists.
 *
 * Since: 1.4
 */
gboolean
gst_sparse_file_get_range_after (GstSparseFile * file, gsize offset,
    gsize * start, gsize * stop)
{
  GstSparseRange *walk, *result = NULL;

  g_return_val_if_fail (file != NULL, FALSE);

  for (walk = file->ranges; walk; walk = walk->next) {
    GST_DEBUG ("stop %" G_GSIZE_FORMAT " > %" G_GSIZE_FORMAT,
        walk->stop, offset);
    if (walk->stop > offset) {
      result = walk;
      break;
    }
  }
  if (result) {
    if (start)
      *start = result->start;
    if (stop)
      *stop = result->stop;
  }
  return result != NULL;
}

/* we don't want to rely on libgio just for g_io_error_from_errno() */
static GstSparseFileIOErrorEnum
gst_sparse_file_io_error_from_errno (gint err_no)
{
  switch (err_no) {
#ifdef EEXIST
    case EEXIST:
      return GST_SPARSE_FILE_IO_ERROR_EXISTS;
      break;
#endif

#ifdef EISDIR
    case EISDIR:
      return GST_SPARSE_FILE_IO_ERROR_IS_DIRECTORY;
      break;
#endif

#ifdef EACCES
    case EACCES:
      return GST_SPARSE_FILE_IO_ERROR_PERMISSION_DENIED;
      break;
#endif

#ifdef ENAMETOOLONG
    case ENAMETOOLONG:
      return GST_SPARSE_FILE_IO_ERROR_FILENAME_TOO_LONG;
      break;
#endif

#ifdef ENOENT
    case ENOENT:
      return GST_SPARSE_FILE_IO_ERROR_NOT_FOUND;
      break;
#endif

#ifdef ENOTDIR
    case ENOTDIR:
      return GST_SPARSE_FILE_IO_ERROR_NOT_DIRECTORY;
      break;
#endif

#ifdef EROFS
    case EROFS:
      return GST_SPARSE_FILE_IO_ERROR_READ_ONLY;
      break;
#endif

#ifdef ELOOP
    case ELOOP:
      return GST_SPARSE_FILE_IO_ERROR_TOO_MANY_LINKS;
      break;
#endif

#ifdef ENOSPC
    case ENOSPC:
      return GST_SPARSE_FILE_IO_ERROR_NO_SPACE;
      break;
#endif

#ifdef ENOMEM
    case ENOMEM:
      return GST_SPARSE_FILE_IO_ERROR_NO_SPACE;
      break;
#endif

#ifdef EINVAL
    case EINVAL:
      return GST_SPARSE_FILE_IO_ERROR_INVALID_ARGUMENT;
      break;
#endif

#ifdef EPERM
    case EPERM:
      return GST_SPARSE_FILE_IO_ERROR_PERMISSION_DENIED;
      break;
#endif

#ifdef ECANCELED
    case ECANCELED:
      return GST_SPARSE_FILE_IO_ERROR_CANCELLED;
      break;
#endif

      /* ENOTEMPTY == EEXIST on AIX for backward compatibility reasons */
#if defined (ENOTEMPTY) && (!defined (EEXIST) || (ENOTEMPTY != EEXIST))
    case ENOTEMPTY:
      return GST_SPARSE_FILE_IO_ERROR_NOT_EMPTY;
      break;
#endif

#ifdef ENOTSUP
    case ENOTSUP:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

      /* EOPNOTSUPP == ENOTSUP on Linux, but POSIX considers them distinct */
#if defined (EOPNOTSUPP) && (!defined (ENOTSUP) || (EOPNOTSUPP != ENOTSUP))
    case EOPNOTSUPP:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

#ifdef EPROTONOSUPPORT
    case EPROTONOSUPPORT:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

#ifdef ESOCKTNOSUPPORT
    case ESOCKTNOSUPPORT:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

#ifdef EPFNOSUPPORT
    case EPFNOSUPPORT:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

#ifdef EAFNOSUPPORT
    case EAFNOSUPPORT:
      return GST_SPARSE_FILE_IO_ERROR_NOT_SUPPORTED;
      break;
#endif

#ifdef ETIMEDOUT
    case ETIMEDOUT:
      return GST_SPARSE_FILE_IO_ERROR_TIMED_OUT;
      break;
#endif

#ifdef EBUSY
    case EBUSY:
      return GST_SPARSE_FILE_IO_ERROR_BUSY;
      break;
#endif

#ifdef EWOULDBLOCK
    case EWOULDBLOCK:
      return GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK;
      break;
#endif

      /* EWOULDBLOCK == EAGAIN on most systems, but POSIX considers them distinct */
#if defined (EAGAIN) && (!defined (EWOULDBLOCK) || (EWOULDBLOCK != EAGAIN))
    case EAGAIN:
      return GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK;
      break;
#endif

#ifdef EMFILE
    case EMFILE:
      return GST_SPARSE_FILE_IO_ERROR_TOO_MANY_OPEN_FILES;
      break;
#endif

#ifdef EADDRINUSE
    case EADDRINUSE:
      return GST_SPARSE_FILE_IO_ERROR_ADDRESS_IN_USE;
      break;
#endif

#ifdef EHOSTUNREACH
    case EHOSTUNREACH:
      return GST_SPARSE_FILE_IO_ERROR_HOST_UNREACHABLE;
      break;
#endif

#ifdef ENETUNREACH
    case ENETUNREACH:
      return GST_SPARSE_FILE_IO_ERROR_NETWORK_UNREACHABLE;
      break;
#endif

#ifdef ECONNREFUSED
    case ECONNREFUSED:
      return GST_SPARSE_FILE_IO_ERROR_CONNECTION_REFUSED;
      break;
#endif

#ifdef EPIPE
    case EPIPE:
      return GST_SPARSE_FILE_IO_ERROR_BROKEN_PIPE;
      break;
#endif

    default:
      return GST_SPARSE_FILE_IO_ERROR_FAILED;
      break;
  }
}
