/* GStreamer
 * Copyright (C) 2006 Josep Torra <josep@fluendo.com>
 *               2006 Mathieu Garcia <matthieu@fluendo.com>
 *               2006,2007 Stefan Kost <ensonic@users.sf.net>
 *               2008 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstregistrybinary.c: GstRegistryBinary object, support routines
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

/* FIXME:
 * - keep registry binary blob and reference strings
 *   - don't free/unmmap contents when leaving gst_registry_binary_read_cache()
 *     - free at gst_deinit() / _priv_gst_registry_cleanup() ?
 *   - GstPlugin:
 *     - GST_PLUGIN_FLAG_CONST
 *   - GstPluginFeature, GstIndexFactory, GstElementFactory
 *     - needs Flags (GST_PLUGIN_FEATURE_FLAG_CONST)
 *     - can we turn loaded into flag?
 * - why do we collect a list of binary chunks and not write immediately
 *   - because we need to process subchunks, before we can set e.g. nr_of_items
 *     in parent chunk
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include <errno.h>
#include <stdio.h>

#if defined (_MSC_VER) && _MSC_VER >= 1400
#include <io.h>
#endif

#include <gst/gst_private.h>
#include <gst/gstconfig.h>
#include <gst/gstelement.h>
#include <gst/gsttypefind.h>
#include <gst/gsttypefindfactory.h>
#include <gst/gstdeviceproviderfactory.h>
#include <gst/gsturi.h>
#include <gst/gstinfo.h>
#include <gst/gstenumtypes.h>
#include <gst/gstpadtemplate.h>

#include <gst/gstregistrychunks.h>
#include <gst/gstregistrybinary.h>

#include <glib/gstdio.h>        /* for g_stat(), g_mapped_file(), ... */

#include "glib-compat-private.h"


#define GST_CAT_DEFAULT GST_CAT_REGISTRY

/* reading macros */
#define unpack_element(inptr, outptr, element, endptr, error_label) G_STMT_START{ \
  if (inptr + sizeof(element) >= endptr) \
    goto error_label; \
  outptr = (element *) inptr; \
  inptr += sizeof (element); \
}G_STMT_END

#define ALIGNMENT            (sizeof (void *))
#define alignment(_address)  (gsize)_address%ALIGNMENT
#define align(_ptr)          _ptr += (( alignment(_ptr) == 0) ? 0 : ALIGNMENT-alignment(_ptr))

/* Registry saving */

#ifdef G_OS_WIN32
/* On win32, we can't use g_mkstmp(), because of cross-DLL file I/O problems.
 * So, we just create the entire binary registry in memory, then write it out
 * with g_file_set_contents(), which creates a temporary file internally
 */

typedef struct BinaryRegistryCache
{
  const char *location;
  guint8 *mem;
  gssize len;
} BinaryRegistryCache;

static BinaryRegistryCache *
gst_registry_binary_cache_init (GstRegistry * registry, const char *location)
{
  BinaryRegistryCache *cache = g_slice_new0 (BinaryRegistryCache);
  cache->location = location;
  return cache;
}

static int
gst_registry_binary_cache_write (BinaryRegistryCache * cache,
    unsigned long offset, const void *data, int length)
{
  cache->len = MAX (offset + length, cache->len);
  cache->mem = g_realloc (cache->mem, cache->len);

  memcpy (cache->mem + offset, data, length);

  return length;
}

static gboolean
gst_registry_binary_cache_finish (BinaryRegistryCache * cache, gboolean success)
{
  gboolean ret = TRUE;
  GError *error = NULL;
  if (!g_file_set_contents (cache->location, (const gchar *) cache->mem,
          cache->len, &error)) {
    /* Probably the directory didn't exist; create it */
    gchar *dir;
    dir = g_path_get_dirname (cache->location);
    g_mkdir_with_parents (dir, 0777);
    g_free (dir);

    g_error_free (error);
    error = NULL;

    if (!g_file_set_contents (cache->location, (const gchar *) cache->mem,
            cache->len, &error)) {
      /* Probably the directory didn't exist; create it */
      gchar *dir;
      dir = g_path_get_dirname (cache->location);
      g_mkdir_with_parents (dir, 0777);
      g_free (dir);

      g_error_free (error);
      error = NULL;

      if (!g_file_set_contents (cache->location, (const gchar *) cache->mem,
              cache->len, &error)) {
        GST_ERROR ("Failed to write to cache file: %s", error->message);
        g_error_free (error);
        ret = FALSE;
      }
    }
  }

  g_free (cache->mem);
  g_slice_free (BinaryRegistryCache, cache);
  return ret;
}

#else
typedef struct BinaryRegistryCache
{
  const char *location;
  char *tmp_location;
  unsigned long currentoffset;
  int cache_fd;
} BinaryRegistryCache;

static BinaryRegistryCache *
gst_registry_binary_cache_init (GstRegistry * registry, const char *location)
{
  BinaryRegistryCache *cache = g_slice_new0 (BinaryRegistryCache);

  cache->location = location;
  cache->tmp_location = g_strconcat (location, ".tmpXXXXXX", NULL);
  cache->cache_fd = g_mkstemp (cache->tmp_location);
  if (cache->cache_fd == -1) {
    int ret;
    GStatBuf statbuf;
    gchar *dir;

    /* oops, I bet the directory doesn't exist */
    dir = g_path_get_dirname (location);
    g_mkdir_with_parents (dir, 0777);

    ret = g_stat (dir, &statbuf);
    if (ret != -1 && (statbuf.st_mode & 0700) != 0700) {
      g_chmod (dir, 0700);
    }

    g_free (dir);

    /* the previous g_mkstemp call overwrote the XXXXXX placeholder ... */
    g_free (cache->tmp_location);
    cache->tmp_location = g_strconcat (location, ".tmpXXXXXX", NULL);
    cache->cache_fd = g_mkstemp (cache->tmp_location);

    if (cache->cache_fd == -1) {
      GST_DEBUG ("g_mkstemp() failed: %s", g_strerror (errno));
      g_free (cache->tmp_location);
      g_slice_free (BinaryRegistryCache, cache);
      return NULL;
    }

    ret = g_stat (cache->tmp_location, &statbuf);
    if (ret != -1 && (statbuf.st_mode & 0600) != 0600) {
      g_chmod (cache->tmp_location, 0600);
    }
  }

  return cache;
}

static int
gst_registry_binary_cache_write (BinaryRegistryCache * cache,
    unsigned long offset, const void *data, int length)
{
  long written;
  if (offset != cache->currentoffset) {
    if (lseek (cache->cache_fd, offset, SEEK_SET) < 0) {
      GST_ERROR ("Seeking to new offset failed: %s", g_strerror (errno));
      return -1;
    }
    GST_LOG ("Seeked from offset %lu to %lu", offset, cache->currentoffset);
    cache->currentoffset = offset;
  }

  written = write (cache->cache_fd, data, length);
  if (written != length) {
    GST_ERROR ("Failed to write to cache file");
  }
  cache->currentoffset += written;

  return written;
}

static gboolean
gst_registry_binary_cache_finish (BinaryRegistryCache * cache, gboolean success)
{
  /* only fsync if we're actually going to use and rename the file below */
  if (success && fsync (cache->cache_fd) < 0)
    goto fsync_failed;

  if (close (cache->cache_fd) < 0)
    goto close_failed;

  if (!success)
    goto fail_after_close;

  /* Only do the rename if we wrote the entire file successfully */
  if (g_rename (cache->tmp_location, cache->location) < 0) {
    GST_ERROR ("g_rename() failed: %s", g_strerror (errno));
    goto rename_failed;
  }

  g_free (cache->tmp_location);
  g_slice_free (BinaryRegistryCache, cache);
  GST_INFO ("Wrote binary registry cache");
  return TRUE;

/* ERRORS */
fail_after_close:
  {
    g_unlink (cache->tmp_location);
    g_free (cache->tmp_location);
    g_slice_free (BinaryRegistryCache, cache);
    return FALSE;
  }
fsync_failed:
  {
    GST_ERROR ("fsync() failed: %s", g_strerror (errno));
    goto fail_after_close;
  }
close_failed:
  {
    GST_ERROR ("close() failed: %s", g_strerror (errno));
    goto fail_after_close;
  }
rename_failed:
  {
    GST_ERROR ("g_rename() failed: %s", g_strerror (errno));
    goto fail_after_close;
  }
}
#endif

/*
 * gst_registry_binary_write_chunk:
 *
 * Write from a memory location to the registry cache file
 *
 * Returns: %TRUE for success
 */
inline static gboolean
gst_registry_binary_write_chunk (BinaryRegistryCache * cache,
    GstRegistryChunk * chunk, unsigned long *file_position)
{
  gchar padder[ALIGNMENT] = { 0, };
  int padsize = 0;

  /* Padding to insert the struct that requiere word alignment */
  if ((chunk->align) && (alignment (*file_position) != 0)) {
    padsize = ALIGNMENT - alignment (*file_position);
    if (gst_registry_binary_cache_write (cache, *file_position,
            padder, padsize) != padsize) {
      GST_ERROR ("Failed to write binary registry padder");
      return FALSE;
    }
    *file_position += padsize;
  }

  if (gst_registry_binary_cache_write (cache, *file_position,
          chunk->data, chunk->size) != chunk->size) {
    GST_ERROR ("Failed to write binary registry element");
    return FALSE;
  }

  *file_position += chunk->size;

  return TRUE;
}


/*
 * gst_registry_binary_initialize_magic:
 *
 * Initialize the GstBinaryRegistryMagic, setting both our magic number and
 * gstreamer major/minor version
 */
inline static gboolean
gst_registry_binary_initialize_magic (GstBinaryRegistryMagic * m)
{
  memset (m, 0, sizeof (GstBinaryRegistryMagic));

  if (!strncpy (m->magic, GST_MAGIC_BINARY_REGISTRY_STR,
          GST_MAGIC_BINARY_REGISTRY_LEN)
      || !strncpy (m->version, GST_MAGIC_BINARY_VERSION_STR,
          GST_MAGIC_BINARY_VERSION_LEN)) {
    GST_ERROR ("Failed to write magic to the registry magic structure");
    return FALSE;
  }

  return TRUE;
}

/**
 * gst_registry_binary_write_cache:
 * @registry: a #GstRegistry
 * @location: a filename
 *
 * Write the @registry to a cache to file at given @location.
 *
 * Returns: %TRUE on success.
 */
gboolean
priv_gst_registry_binary_write_cache (GstRegistry * registry, GList * plugins,
    const char *location)
{
  GList *walk;
  GstBinaryRegistryMagic magic;
  GList *to_write = NULL;
  unsigned long file_position = 0;
  BinaryRegistryCache *cache;

  GST_INFO ("Building binary registry cache image");

  g_return_val_if_fail (GST_IS_REGISTRY (registry), FALSE);

  if (!gst_registry_binary_initialize_magic (&magic))
    goto fail;

  /* iterate trough the list of plugins and fit them into binary structures */
  for (walk = plugins; walk != NULL; walk = walk->next) {
    GstPlugin *plugin = GST_PLUGIN (walk->data);

    if (!plugin->filename)
      continue;

    if (GST_OBJECT_FLAG_IS_SET (plugin, GST_PLUGIN_FLAG_CACHED)) {
      GStatBuf statbuf;

      if (g_stat (plugin->filename, &statbuf) < 0 ||
          plugin->file_mtime != statbuf.st_mtime ||
          plugin->file_size != statbuf.st_size)
        continue;
    }

    if (!_priv_gst_registry_chunks_save_plugin (&to_write, registry, plugin)) {
      GST_ERROR ("Can't write binary plugin information for \"%s\"",
          plugin->filename);
    }
  }

  _priv_gst_registry_chunks_save_global_header (&to_write, registry,
      priv_gst_plugin_loading_get_whitelist_hash ());

  GST_INFO ("Writing binary registry cache");

  cache = gst_registry_binary_cache_init (registry, location);
  if (!cache)
    goto fail_free_list;

  /* write magic */
  if (gst_registry_binary_cache_write (cache, file_position,
          &magic, sizeof (GstBinaryRegistryMagic)) !=
      sizeof (GstBinaryRegistryMagic)) {
    GST_ERROR ("Failed to write binary registry magic");
    goto fail_free_list;
  }
  file_position += sizeof (GstBinaryRegistryMagic);

  /* write out data chunks */
  for (walk = to_write; walk; walk = g_list_next (walk)) {
    GstRegistryChunk *cur = walk->data;
    gboolean res;

    res = gst_registry_binary_write_chunk (cache, cur, &file_position);

    _priv_gst_registry_chunk_free (cur);
    walk->data = NULL;
    if (!res)
      goto fail_free_list;
  }
  g_list_free (to_write);

  if (!gst_registry_binary_cache_finish (cache, TRUE))
    return FALSE;

  return TRUE;

  /* Errors */
fail_free_list:
  {
    for (walk = to_write; walk; walk = g_list_next (walk)) {
      GstRegistryChunk *cur = walk->data;

      if (cur)
        _priv_gst_registry_chunk_free (cur);
    }
    g_list_free (to_write);

    if (cache)
      (void) gst_registry_binary_cache_finish (cache, FALSE);
    /* fall through */
  }
fail:
  {
    return FALSE;
  }
}


/* Registry loading */

/*
 * gst_registry_binary_check_magic:
 *
 * Check GstBinaryRegistryMagic validity.
 * Return < 0 if something is wrong, -2 means
 * that just the version of the registry is out of
 * date, -1 is a general failure.
 */
static gint
gst_registry_binary_check_magic (gchar ** in, gsize size)
{
  GstBinaryRegistryMagic *m;

  align (*in);
  GST_DEBUG ("Reading/casting for GstBinaryRegistryMagic at address %p", *in);
  unpack_element (*in, m, GstBinaryRegistryMagic, (*in + size), fail);

  if (strncmp (m->magic, GST_MAGIC_BINARY_REGISTRY_STR,
          GST_MAGIC_BINARY_REGISTRY_LEN) != 0) {
    GST_WARNING
        ("Binary registry magic is different : %02x%02x%02x%02x != %02x%02x%02x%02x",
        GST_MAGIC_BINARY_REGISTRY_STR[0] & 0xff,
        GST_MAGIC_BINARY_REGISTRY_STR[1] & 0xff,
        GST_MAGIC_BINARY_REGISTRY_STR[2] & 0xff,
        GST_MAGIC_BINARY_REGISTRY_STR[3] & 0xff, m->magic[0] & 0xff,
        m->magic[1] & 0xff, m->magic[2] & 0xff, m->magic[3] & 0xff);
    return -1;
  }
  if (strncmp (m->version, GST_MAGIC_BINARY_VERSION_STR,
          GST_MAGIC_BINARY_VERSION_LEN)) {
    GST_WARNING ("Binary registry magic version is different : %s != %s",
        GST_MAGIC_BINARY_VERSION_STR, m->version);
    return -2;
  }

  return 0;

fail:
  GST_WARNING ("Not enough data for binary registry magic structure");
  return -1;
}

/**
 * gst_registry_binary_read_cache:
 * @registry: a #GstRegistry
 * @location: a filename
 *
 * Read the contents of the binary cache file at @location into @registry.
 *
 * Returns: %TRUE on success.
 */
gboolean
priv_gst_registry_binary_read_cache (GstRegistry * registry,
    const char *location)
{
  GMappedFile *mapped = NULL;
  gchar *contents = NULL;
  gchar *in = NULL;
  gsize size;
  GError *err = NULL;
  gboolean res = FALSE;
  guint32 filter_env_hash = 0;
  gint check_magic_result;
#ifndef GST_DISABLE_GST_DEBUG
  GTimer *timer = NULL;
  gdouble seconds;
#endif

  /* make sure these types exist */
  GST_TYPE_ELEMENT_FACTORY;
  GST_TYPE_TYPE_FIND_FACTORY;
  GST_TYPE_DEVICE_PROVIDER_FACTORY;

#ifndef GST_DISABLE_GST_DEBUG
  timer = g_timer_new ();
#endif

  mapped = g_mapped_file_new (location, FALSE, &err);
  if (G_UNLIKELY (err != NULL)) {
    GST_INFO ("Unable to mmap file %s : %s", location, err->message);
    g_error_free (err);
    err = NULL;
  }

  if (mapped == NULL) {
    /* Error mmap-ing the cache, try a plain memory read */

    g_file_get_contents (location, &contents, &size, &err);
    if (err != NULL) {
      GST_INFO ("Unable to read file %s : %s", location, err->message);
#ifndef GST_DISABLE_GST_DEBUG
      g_timer_destroy (timer);
#endif
      g_error_free (err);
      return FALSE;
    }
  } else {
    /* This can't fail if g_mapped_file_new() succeeded */
    contents = g_mapped_file_get_contents (mapped);
    size = g_mapped_file_get_length (mapped);
  }

  /* in is a cursor pointer, we initialize it with the begin of registry and is updated on each read */
  in = contents;
  GST_DEBUG ("File data at address %p", in);
  if (G_UNLIKELY (size < sizeof (GstBinaryRegistryMagic))) {
    GST_ERROR ("No or broken registry header for file at %s", location);
    goto Error;
  }

  /* check if header is valid */
  if (G_UNLIKELY ((check_magic_result =
              gst_registry_binary_check_magic (&in, size)) < 0)) {

    if (check_magic_result == -1)
      GST_ERROR
          ("Binary registry type not recognized (invalid magic) for file at %s",
          location);
    goto Error;
  }

  if (!_priv_gst_registry_chunks_load_global_header (registry, &in,
          contents + size, &filter_env_hash)) {
    GST_ERROR ("Couldn't read global header chunk");
    goto Error;
  }

  if (filter_env_hash != priv_gst_plugin_loading_get_whitelist_hash ()) {
    GST_INFO_OBJECT (registry, "Plugin loading filter environment changed, "
        "ignoring plugin cache to force update with new filter environment");
    goto done;
  }

  /* check if there are plugins in the file */
  if (G_UNLIKELY (!(((gsize) in + sizeof (GstRegistryChunkPluginElement)) <
              (gsize) contents + size))) {
    GST_INFO ("No binary plugins structure to read");
    /* empty file, this is not an error */
  } else {
    gchar *end = contents + size;
    /* read as long as we still have space for a GstRegistryChunkPluginElement */
    for (;
        ((gsize) in + sizeof (GstRegistryChunkPluginElement)) <
        (gsize) contents + size;) {
      GST_DEBUG ("reading binary registry %" G_GSIZE_FORMAT "(%x)/%"
          G_GSIZE_FORMAT, (gsize) in - (gsize) contents,
          (guint) ((gsize) in - (gsize) contents), size);
      if (!_priv_gst_registry_chunks_load_plugin (registry, &in, end, NULL)) {
        GST_ERROR ("Problem while reading binary registry %s", location);
        goto Error;
      }
    }
  }

done:

#ifndef GST_DISABLE_GST_DEBUG
  g_timer_stop (timer);
  seconds = g_timer_elapsed (timer, NULL);
#endif

  GST_INFO ("loaded %s in %lf seconds", location, seconds);

  res = TRUE;
  /* TODO: once we re-use the pointers to registry contents, return here */

Error:
#ifndef GST_DISABLE_GST_DEBUG
  g_timer_destroy (timer);
#endif
  if (mapped) {
    g_mapped_file_unref (mapped);
  } else {
    g_free (contents);
  }
  return res;
}
