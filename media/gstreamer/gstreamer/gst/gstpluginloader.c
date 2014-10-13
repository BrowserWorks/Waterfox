/* GStreamer
 * Copyright (C) 2008 Jan Schmidt <jan.schmidt@sun.com>
 *
 * gstpluginloader.c: GstPluginLoader helper for loading plugin files
 * out of process.
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
#  include "config.h"
#endif

#include <gst/gst_private.h>

#ifndef G_OS_WIN32
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#else
#define WIN32_LEAN_AND_MEAN

#define fsync(fd) _commit(fd)
#include <io.h>

#include <windows.h>
extern HMODULE _priv_gst_dll_handle;
#endif

#ifdef HAVE_SYS_UTSNAME_H
#include <sys/utsname.h>
#endif

#include <errno.h>

#include <gst/gstconfig.h>

#include <gst/gstpoll.h>
#include <gst/gstutils.h>

#include <gst/gstpluginloader.h>
#include <gst/gstregistrychunks.h>
#include <gst/gstregistrybinary.h>

/* IMPORTANT: Bump the version number if the plugin loader packet protocol
 * changes. Changes in the binary registry format itself are handled by
 * bumping the GST_MAGIC_BINARY_VERSION_STR
 */
static const guint32 loader_protocol_version = 3;

#define GST_CAT_DEFAULT GST_CAT_PLUGIN_LOADING

static GstPluginLoader *plugin_loader_new (GstRegistry * registry);
static gboolean plugin_loader_free (GstPluginLoader * loader);
static gboolean plugin_loader_load (GstPluginLoader * loader,
    const gchar * filename, off_t file_size, time_t file_mtime);

/* functions used in GstRegistry scanning */
const GstPluginLoaderFuncs _priv_gst_plugin_loader_funcs = {
  plugin_loader_new, plugin_loader_free, plugin_loader_load
};

typedef struct _PendingPluginEntry
{
  /* sequence number */
  guint32 tag;
  gchar *filename;
  off_t file_size;
  time_t file_mtime;
} PendingPluginEntry;

struct _GstPluginLoader
{
  GstRegistry *registry;
  GstPoll *fdset;

  gboolean child_running;
  GPid child_pid;
  GstPollFD fd_w;
  GstPollFD fd_r;

  gboolean is_child;
  gboolean got_plugin_details;

  /* Transmit buffer */
  guint8 *tx_buf;
  guint tx_buf_size;
  guint tx_buf_write;
  guint tx_buf_read;

  /* next sequence number (for PendingPluginEntry) */
  guint32 next_tag;

  guint8 *rx_buf;
  guint rx_buf_size;
  gboolean rx_done;
  gboolean rx_got_sync;

  /* Head and tail of the pending plugins list. List of
     PendingPluginEntry structs */
  GList *pending_plugins;
  GList *pending_plugins_tail;
};

#define PACKET_EXIT 1
#define PACKET_LOAD_PLUGIN 2
#define PACKET_SYNC 3
#define PACKET_PLUGIN_DETAILS 4
#define PACKET_VERSION 5

#define BUF_INIT_SIZE 512
#define BUF_GROW_EXTRA 512
#define BUF_MAX_SIZE (32 * 1024 * 1024)

#define HEADER_SIZE 12
/* 4 magic hex bytes to mark each packet */
#define HEADER_MAGIC 0xbefec0ae
#define ALIGNMENT   (sizeof (void *))

static gboolean gst_plugin_loader_spawn (GstPluginLoader * loader);
static void put_packet (GstPluginLoader * loader, guint type, guint32 tag,
    const guint8 * payload, guint32 payload_len);
static gboolean exchange_packets (GstPluginLoader * l);
static gboolean plugin_loader_replay_pending (GstPluginLoader * l);
static gboolean plugin_loader_load_and_sync (GstPluginLoader * l,
    PendingPluginEntry * entry);
static void plugin_loader_create_blacklist_plugin (GstPluginLoader * l,
    PendingPluginEntry * entry);
static void plugin_loader_cleanup_child (GstPluginLoader * loader);
static gboolean plugin_loader_sync_with_child (GstPluginLoader * l);

static GstPluginLoader *
plugin_loader_new (GstRegistry * registry)
{
  GstPluginLoader *l = g_slice_new0 (GstPluginLoader);

  if (registry)
    l->registry = gst_object_ref (registry);
  l->fdset = gst_poll_new (FALSE);
  gst_poll_fd_init (&l->fd_w);
  gst_poll_fd_init (&l->fd_r);

  l->tx_buf_size = BUF_INIT_SIZE;
  l->tx_buf = g_malloc (BUF_INIT_SIZE);

  l->next_tag = 0;

  l->rx_buf_size = BUF_INIT_SIZE;
  l->rx_buf = g_malloc (BUF_INIT_SIZE);

  return l;
}

static gboolean
plugin_loader_free (GstPluginLoader * loader)
{
  GList *cur;
  gboolean got_plugin_details;

  fsync (loader->fd_w.fd);

  if (loader->child_running) {
    put_packet (loader, PACKET_EXIT, 0, NULL, 0);

    /* Swap packets with the child until it exits cleanly */
    while (!loader->rx_done) {
      if (exchange_packets (loader) || loader->rx_done)
        continue;

      if (!plugin_loader_replay_pending (loader))
        break;
      put_packet (loader, PACKET_EXIT, 0, NULL, 0);
    }

    plugin_loader_cleanup_child (loader);
  } else {
    close (loader->fd_w.fd);
    close (loader->fd_r.fd);
  }

  gst_poll_free (loader->fdset);

  g_free (loader->rx_buf);
  g_free (loader->tx_buf);

  if (loader->registry)
    gst_object_unref (loader->registry);

  got_plugin_details = loader->got_plugin_details;

  /* Free any pending plugin entries */
  cur = loader->pending_plugins;
  while (cur) {
    PendingPluginEntry *entry = (PendingPluginEntry *) (cur->data);
    g_free (entry->filename);
    g_slice_free (PendingPluginEntry, entry);

    cur = g_list_delete_link (cur, cur);
  }

  g_slice_free (GstPluginLoader, loader);

  return got_plugin_details;
}

static gboolean
plugin_loader_load (GstPluginLoader * loader, const gchar * filename,
    off_t file_size, time_t file_mtime)
{
  gint len;
  PendingPluginEntry *entry;

  if (!gst_plugin_loader_spawn (loader))
    return FALSE;

  /* Send a packet to the child requesting that it load the given file */
  GST_LOG_OBJECT (loader->registry,
      "Sending file %s to child. tag %u", filename, loader->next_tag);

  entry = g_slice_new (PendingPluginEntry);
  entry->tag = loader->next_tag++;
  entry->filename = g_strdup (filename);
  entry->file_size = file_size;
  entry->file_mtime = file_mtime;
  loader->pending_plugins_tail =
      g_list_append (loader->pending_plugins_tail, entry);

  if (loader->pending_plugins == NULL)
    loader->pending_plugins = loader->pending_plugins_tail;
  else
    loader->pending_plugins_tail = g_list_next (loader->pending_plugins_tail);

  len = strlen (filename);
  put_packet (loader, PACKET_LOAD_PLUGIN, entry->tag,
      (guint8 *) filename, len + 1);

  if (!exchange_packets (loader)) {
    if (!plugin_loader_replay_pending (loader))
      return FALSE;
  }

  return TRUE;
}

static gboolean
plugin_loader_replay_pending (GstPluginLoader * l)
{
  GList *cur, *next;

restart:
  if (!gst_plugin_loader_spawn (l))
    return FALSE;

  /* Load each plugin one by one synchronously until we find the
   * crashing one */
  while ((cur = l->pending_plugins)) {
    PendingPluginEntry *entry = (PendingPluginEntry *) (cur->data);

    if (!plugin_loader_load_and_sync (l, entry)) {
      /* Create dummy plugin entry to block re-scanning this file */
      GST_ERROR ("Plugin file %s failed to load. Blacklisting",
          entry->filename);
      plugin_loader_create_blacklist_plugin (l, entry);
      l->got_plugin_details = TRUE;
      /* Now remove this crashy plugin from the head of the list */
      l->pending_plugins = g_list_delete_link (cur, cur);
      g_free (entry->filename);
      g_slice_free (PendingPluginEntry, entry);
      if (l->pending_plugins == NULL)
        l->pending_plugins_tail = NULL;
      if (!gst_plugin_loader_spawn (l))
        return FALSE;
      break;
    }
  }

  /* We exited after finding the crashing one. If there's any more pending,
   * dispatch them post-haste, but don't wait */
  for (cur = l->pending_plugins; cur != NULL; cur = next) {
    PendingPluginEntry *entry = (PendingPluginEntry *) (cur->data);

    next = g_list_next (cur);

    put_packet (l, PACKET_LOAD_PLUGIN, entry->tag,
        (guint8 *) entry->filename, strlen (entry->filename) + 1);

    /* This might invalidate cur, which is why we grabbed 'next' above */
    if (!exchange_packets (l))
      goto restart;
  }

  return TRUE;
}

static gboolean
plugin_loader_sync_with_child (GstPluginLoader * l)
{
  put_packet (l, PACKET_SYNC, 0, NULL, 0);

  l->rx_got_sync = FALSE;
  while (!l->rx_got_sync) {
    if (!exchange_packets (l))
      return FALSE;
  }
  return TRUE;
}

static gboolean
plugin_loader_load_and_sync (GstPluginLoader * l, PendingPluginEntry * entry)
{
  gint len;

  GST_DEBUG_OBJECT (l->registry, "Synchronously loading plugin file %s",
      entry->filename);

  len = strlen (entry->filename);
  put_packet (l, PACKET_LOAD_PLUGIN, entry->tag,
      (guint8 *) entry->filename, len + 1);

  return plugin_loader_sync_with_child (l);
}

static void
plugin_loader_create_blacklist_plugin (GstPluginLoader * l,
    PendingPluginEntry * entry)
{
  GstPlugin *plugin = g_object_newv (GST_TYPE_PLUGIN, 0, NULL);

  plugin->filename = g_strdup (entry->filename);
  plugin->file_mtime = entry->file_mtime;
  plugin->file_size = entry->file_size;
  GST_OBJECT_FLAG_SET (plugin, GST_PLUGIN_FLAG_BLACKLISTED);

  plugin->basename = g_path_get_basename (plugin->filename);
  plugin->desc.name = g_intern_string (plugin->basename);
  plugin->desc.description = "Plugin for blacklisted file";
  plugin->desc.version = "0.0.0";
  plugin->desc.license = "BLACKLIST";
  plugin->desc.source = plugin->desc.license;
  plugin->desc.package = plugin->desc.license;
  plugin->desc.origin = plugin->desc.license;

  GST_DEBUG ("Adding blacklist plugin '%s'", plugin->desc.name);
  gst_registry_add_plugin (l->registry, plugin);
}

#ifdef __APPLE__
#if defined(__x86_64__)
#define USR_BIN_ARCH_SWITCH "-x86_64"
#elif defined(__i386__)
#define USR_BIN_ARCH_SWITCH "-i386"
#elif defined(__ppc__)
#define USR_BIN_ARCH_SWITCH "-ppc"
#elif defined(__ppc64__)
#define USR_BIN_ARCH_SWITCH "-ppc64"
#endif
#endif

#define YES_MULTIARCH 1
#define NO_MULTIARCH  2

#if defined (__APPLE__) && defined (USR_BIN_ARCH_SWITCH)
static gboolean
gst_plugin_loader_use_usr_bin_arch (void)
{
  static volatile gsize multiarch = 0;

  if (g_once_init_enter (&multiarch)) {
    gsize res = NO_MULTIARCH;

#ifdef HAVE_SYS_UTSNAME_H
    {
      struct utsname uname_data;

      if (uname (&uname_data) == 0) {
        /* Check for OS X >= 10.5 (darwin kernel 9.0) */
        GST_LOG ("%s %s", uname_data.sysname, uname_data.release);
        if (g_ascii_strcasecmp (uname_data.sysname, "Darwin") == 0 &&
            g_strtod (uname_data.release, NULL) >= 9.0) {
          res = YES_MULTIARCH;
        }
      }
    }
#endif

    GST_INFO ("multiarch: %s", (res == YES_MULTIARCH) ? "yes" : "no");
    g_once_init_leave (&multiarch, res);
  }
  return (multiarch == YES_MULTIARCH);
}
#endif /* __APPLE__ && USR_BIN_ARCH_SWITCH */

static gboolean
gst_plugin_loader_try_helper (GstPluginLoader * loader, gchar * location)
{
  char *argv[5] = { NULL, };
  int c = 0;

#if defined (__APPLE__) && defined (USR_BIN_ARCH_SWITCH)
  if (gst_plugin_loader_use_usr_bin_arch ()) {
    argv[c++] = (char *) "/usr/bin/arch";
    argv[c++] = (char *) USR_BIN_ARCH_SWITCH;
  }
#endif
  argv[c++] = location;
  argv[c++] = (char *) "-l";
  argv[c++] = NULL;

  if (c > 3) {
    GST_LOG ("Trying to spawn gst-plugin-scanner helper at %s with arch %s",
        location, argv[1]);
  } else {
    GST_LOG ("Trying to spawn gst-plugin-scanner helper at %s", location);
  }

  if (!g_spawn_async_with_pipes (NULL, argv, NULL,
          G_SPAWN_DO_NOT_REAP_CHILD /* | G_SPAWN_STDERR_TO_DEV_NULL */ ,
          NULL, NULL, &loader->child_pid, &loader->fd_w.fd, &loader->fd_r.fd,
          NULL, NULL))
    return FALSE;

  gst_poll_add_fd (loader->fdset, &loader->fd_w);
  gst_poll_add_fd (loader->fdset, &loader->fd_r);

  gst_poll_fd_ctl_read (loader->fdset, &loader->fd_r, TRUE);

  loader->tx_buf_write = loader->tx_buf_read = 0;

  put_packet (loader, PACKET_VERSION, 0, NULL, 0);
  if (!plugin_loader_sync_with_child (loader))
    return FALSE;

  loader->child_running = TRUE;

  return TRUE;
}

static gboolean
gst_plugin_loader_spawn (GstPluginLoader * loader)
{
  const gchar *env;
  char *helper_bin;
  gboolean res = FALSE;

  if (loader->child_running)
    return TRUE;

  /* Find the gst-plugin-scanner: first try the env-var if it is set,
   * otherwise use the installed version */
  env = g_getenv ("GST_PLUGIN_SCANNER_1_0");
  if (env == NULL)
    env = g_getenv ("GST_PLUGIN_SCANNER");

  if (env != NULL && *env != '\0') {
    GST_LOG ("Trying GST_PLUGIN_SCANNER env var: %s", env);
    helper_bin = g_strdup (env);
    res = gst_plugin_loader_try_helper (loader, helper_bin);
    g_free (helper_bin);
  }

  if (!res) {
    GST_LOG ("Trying installed plugin scanner");

#ifdef G_OS_WIN32
    {
      gchar *basedir;

      basedir = g_win32_get_package_installation_directory_of_module (_priv_gst_dll_handle);
      helper_bin = g_build_filename (basedir,
                                     "lib",
                                     "gstreamer-" GST_API_VERSION,
                                     "gst-plugin-scanner.exe",
                                     NULL);
      g_free (basedir);
    }
#else
    helper_bin = g_strdup (GST_PLUGIN_SCANNER_INSTALLED);
#endif
    res = gst_plugin_loader_try_helper (loader, helper_bin);
    g_free (helper_bin);

    if (!res) {
      GST_INFO ("No gst-plugin-scanner available, or not working");
    }
  }

  return loader->child_running;
}

static void
plugin_loader_cleanup_child (GstPluginLoader * l)
{
  if (!l->child_running || l->is_child)
    return;

  gst_poll_remove_fd (l->fdset, &l->fd_w);
  gst_poll_remove_fd (l->fdset, &l->fd_r);

  close (l->fd_w.fd);
  close (l->fd_r.fd);

#ifndef G_OS_WIN32
  GST_LOG ("waiting for child process to exit");
  waitpid (l->child_pid, NULL, 0);
#else
  g_warning ("FIXME: Implement child process shutdown for Win32");
#endif
  g_spawn_close_pid (l->child_pid);

  l->child_running = FALSE;
}

gboolean
_gst_plugin_loader_client_run (void)
{
  gboolean res = TRUE;
  GstPluginLoader *l;

  l = plugin_loader_new (NULL);
  if (l == NULL)
    return FALSE;

  /* On entry, the inward pipe is STDIN, and outward is STDOUT.
   * Dup those somewhere better so that plugins printing things
   * won't interfere with anything */
#ifndef G_OS_WIN32
  {
    int dup_fd;

    dup_fd = dup (0);           /* STDIN */
    if (dup_fd == -1) {
      GST_ERROR ("Failed to start. Could no dup STDIN, errno %d", errno);
      res = FALSE;
      goto beach;
    }
    l->fd_r.fd = dup_fd;
    close (0);

    dup_fd = dup (1);           /* STDOUT */
    if (dup_fd == -1) {
      GST_ERROR ("Failed to start. Could no dup STDOUT, errno %d", errno);
      res = FALSE;
      goto beach;
    }
    l->fd_w.fd = dup_fd;
    close (1);

    /* Dup stderr down to stdout so things that plugins print are visible,
     * but don't care if it fails */
    dup2 (2, 1);
  }
#else
  /* FIXME: Use DuplicateHandle and friends on win32 */
  l->fd_w.fd = 1;               /* STDOUT */
  l->fd_r.fd = 0;               /* STDIN */
#endif

  gst_poll_add_fd (l->fdset, &l->fd_w);
  gst_poll_add_fd (l->fdset, &l->fd_r);
  gst_poll_fd_ctl_read (l->fdset, &l->fd_r, TRUE);

  l->is_child = TRUE;

  GST_DEBUG ("Plugin scanner child running. Waiting for instructions");

  /* Loop, listening for incoming packets on the fd and writing responses */
  while (!l->rx_done && exchange_packets (l));

#ifndef G_OS_WIN32
beach:
#endif

  plugin_loader_free (l);

  return res;
}

static void
put_packet (GstPluginLoader * l, guint type, guint32 tag,
    const guint8 * payload, guint32 payload_len)
{
  guint8 *out;
  guint len = payload_len + HEADER_SIZE;

  if (l->tx_buf_write + len >= l->tx_buf_size) {
    GST_LOG ("Expanding tx buf from %d to %d for packet of size %d",
        l->tx_buf_size, l->tx_buf_write + len + BUF_GROW_EXTRA, len);
    l->tx_buf_size = l->tx_buf_write + len + BUF_GROW_EXTRA;
    l->tx_buf = g_realloc (l->tx_buf, l->tx_buf_size);
  }

  out = l->tx_buf + l->tx_buf_write;

  /* one byte packet type */
  out[0] = type;
  /* 3 byte packet tag number */
  GST_WRITE_UINT24_BE (out + 1, tag);
  /* 4 bytes packet length */
  GST_WRITE_UINT32_BE (out + 4, payload_len);
  /* payload */
  if (payload && payload_len)
    memcpy (out + HEADER_SIZE, payload, payload_len);
  /* Write magic into the header */
  GST_WRITE_UINT32_BE (out + 8, HEADER_MAGIC);

  l->tx_buf_write += len;
  gst_poll_fd_ctl_write (l->fdset, &l->fd_w, TRUE);
}

static void
put_chunk (GstPluginLoader * l, GstRegistryChunk * chunk, guint * pos)
{
  guint padsize = 0;
  guint len;
  guint8 *out;

  /* Might need to align the chunk */
  if (chunk->align && ((*pos) % ALIGNMENT) != 0)
    padsize = ALIGNMENT - ((*pos) % ALIGNMENT);

  len = padsize + chunk->size;

  if (G_UNLIKELY (l->tx_buf_write + len >= l->tx_buf_size)) {
    guint new_size = MAX (l->tx_buf_write + len,
        l->tx_buf_size + l->tx_buf_size / 4) + BUF_GROW_EXTRA;
    GST_LOG ("Expanding tx buf from %d to %d for chunk of size %d",
        l->tx_buf_size, new_size, chunk->size);
    l->tx_buf_size = new_size;
    l->tx_buf = g_realloc (l->tx_buf, l->tx_buf_size);
  }

  out = l->tx_buf + l->tx_buf_write;
  /* Clear the padding */
  if (padsize)
    memset (out, 0, padsize);
  memcpy (out + padsize, chunk->data, chunk->size);

  l->tx_buf_write += len;
  *pos += len;

  gst_poll_fd_ctl_write (l->fdset, &l->fd_w, TRUE);
};

static gboolean
write_one (GstPluginLoader * l)
{
  guint8 *out;
  guint32 to_write, magic;
  int res;

  if (l->tx_buf_read + HEADER_SIZE > l->tx_buf_write)
    return FALSE;

  out = l->tx_buf + l->tx_buf_read;

  magic = GST_READ_UINT32_BE (out + 8);
  if (magic != HEADER_MAGIC) {
    GST_ERROR ("Packet magic number is missing. Memory corruption detected");
    goto fail_and_cleanup;
  }

  to_write = GST_READ_UINT32_BE (out + 4) + HEADER_SIZE;
  /* Check that the magic is intact, and the size is sensible */
  if (to_write > l->tx_buf_size) {
    GST_ERROR ("Indicated packet size is too large. Corruption detected");
    goto fail_and_cleanup;
  }

  l->tx_buf_read += to_write;

  GST_LOG ("Writing packet of size %d bytes to fd %d", to_write, l->fd_w.fd);

  do {
    res = write (l->fd_w.fd, out, to_write);
    if (G_UNLIKELY (res < 0)) {
      if (errno == EAGAIN || errno == EINTR)
        continue;
      /* Failed to write -> child died */
      goto fail_and_cleanup;
    }
    to_write -= res;
    out += res;
  } while (to_write > 0);

  if (l->tx_buf_read == l->tx_buf_write) {
    gst_poll_fd_ctl_write (l->fdset, &l->fd_w, FALSE);
    l->tx_buf_read = l->tx_buf_write = 0;
  }

  return TRUE;

fail_and_cleanup:
  plugin_loader_cleanup_child (l);
  return FALSE;
}

static gboolean
do_plugin_load (GstPluginLoader * l, const gchar * filename, guint tag)
{
  GstPlugin *newplugin;
  GList *chunks = NULL;

  GST_DEBUG ("Plugin scanner loading file %s. tag %u", filename, tag);

#if 0                           /* Test code - crash based on filename */
  if (strstr (filename, "coreelements") == NULL) {
    g_printerr ("Crashing on file %s\n", filename);
    g_printerr ("%d", *(gint *) (NULL));
  }
#endif

  newplugin = gst_plugin_load_file ((gchar *) filename, NULL);
  if (newplugin) {
    guint hdr_pos;
    guint offset;

    /* Now serialise the plugin details and send */
    if (!_priv_gst_registry_chunks_save_plugin (&chunks,
            gst_registry_get (), newplugin))
      goto fail;

    /* Store where the header is, write an empty one, then write
     * all the payload chunks, then fix up the header size */
    hdr_pos = l->tx_buf_write;
    offset = HEADER_SIZE;
    put_packet (l, PACKET_PLUGIN_DETAILS, tag, NULL, 0);

    if (chunks) {
      GList *walk;
      for (walk = chunks; walk; walk = g_list_next (walk)) {
        GstRegistryChunk *cur = walk->data;
        put_chunk (l, cur, &offset);

        _priv_gst_registry_chunk_free (cur);
      }

      g_list_free (chunks);

      /* Store the size of the written payload */
      GST_WRITE_UINT32_BE (l->tx_buf + hdr_pos + 4, offset - HEADER_SIZE);
    }
#if 0                           /* Test code - corrupt the tx buffer based on filename */
    if (strstr (filename, "sink") != NULL) {
      int fd, res;
      g_printerr ("Corrupting tx buf on file %s\n", filename);
      fd = open ("/dev/urandom", O_RDONLY);
      res = read (fd, l->tx_buf, l->tx_buf_size);
      close (fd);
    }
#endif

    gst_object_unref (newplugin);
  } else {
    put_packet (l, PACKET_PLUGIN_DETAILS, tag, NULL, 0);
  }

  return TRUE;
fail:
  put_packet (l, PACKET_PLUGIN_DETAILS, tag, NULL, 0);
  if (chunks) {
    GList *walk;
    for (walk = chunks; walk; walk = g_list_next (walk)) {
      GstRegistryChunk *cur = walk->data;

      _priv_gst_registry_chunk_free (cur);
    }

    g_list_free (chunks);
  }

  return FALSE;
}

static gboolean
check_protocol_version (GstPluginLoader * l, guint8 * payload,
    guint payload_len)
{
  guint32 got_version;
  guint8 *binary_reg_ver;

  if (payload_len < sizeof (guint32) + GST_MAGIC_BINARY_VERSION_LEN)
    return FALSE;

  got_version = GST_READ_UINT32_BE (payload);
  GST_LOG ("Got VERSION %u from child. Ours is %u", got_version,
      loader_protocol_version);
  if (got_version != loader_protocol_version)
    return FALSE;

  binary_reg_ver = payload + sizeof (guint32);
  if (strcmp ((gchar *) binary_reg_ver, GST_MAGIC_BINARY_VERSION_STR)) {
    GST_LOG ("Binary chunk format of child is different. Ours: %s, child %s\n",
        GST_MAGIC_BINARY_VERSION_STR, binary_reg_ver);
    return FALSE;
  }

  return TRUE;
};

static gboolean
handle_rx_packet (GstPluginLoader * l,
    guint pack_type, guint32 tag, guint8 * payload, guint payload_len)
{
  gboolean res = TRUE;

  switch (pack_type) {
    case PACKET_EXIT:
      gst_poll_fd_ctl_read (l->fdset, &l->fd_r, FALSE);
      if (l->is_child) {
        /* Respond */
        put_packet (l, PACKET_EXIT, 0, NULL, 0);
      }
      l->rx_done = TRUE;
      return TRUE;
    case PACKET_LOAD_PLUGIN:{
      if (!l->is_child)
        return TRUE;

      /* Payload is the filename to load */
      res = do_plugin_load (l, (gchar *) payload, tag);

      break;
    }
    case PACKET_PLUGIN_DETAILS:{
      gchar *tmp = (gchar *) payload;
      PendingPluginEntry *entry = NULL;
      GList *cur;

      GST_DEBUG_OBJECT (l->registry,
          "Received plugin details from child w/ tag %u. %d bytes info",
          tag, payload_len);

      /* Assume that tagged details come back in the order
       * we requested, and delete anything before (but not
       * including) this one */
      cur = l->pending_plugins;
      while (cur) {
        PendingPluginEntry *e = (PendingPluginEntry *) (cur->data);

        if (e->tag > tag)
          break;

        if (e->tag == tag) {
          entry = e;
          break;
        } else {
          cur = g_list_delete_link (cur, cur);
          g_free (e->filename);
          g_slice_free (PendingPluginEntry, e);
        }
      }

      l->pending_plugins = cur;
      if (cur == NULL)
        l->pending_plugins_tail = NULL;

      if (payload_len > 0) {
        GstPlugin *newplugin = NULL;
        if (!_priv_gst_registry_chunks_load_plugin (l->registry, &tmp,
                tmp + payload_len, &newplugin)) {
          /* Got garbage from the child, so fail and trigger replay of plugins */
          GST_ERROR_OBJECT (l->registry,
              "Problems loading plugin details with tag %u from scanner", tag);
          return FALSE;
        }

        GST_OBJECT_FLAG_UNSET (newplugin, GST_PLUGIN_FLAG_CACHED);
        GST_LOG_OBJECT (l->registry,
            "marking plugin %p as registered as %s", newplugin,
            newplugin->filename);
        newplugin->registered = TRUE;

        /* We got a set of plugin details - remember it for later */
        l->got_plugin_details = TRUE;
      } else if (entry != NULL) {
        /* Create a blacklist entry for this file to prevent scanning every time */
        plugin_loader_create_blacklist_plugin (l, entry);
        l->got_plugin_details = TRUE;
      }

      if (entry != NULL) {
        g_free (entry->filename);
        g_slice_free (PendingPluginEntry, entry);
      }

      /* Remove the plugin entry we just loaded */
      cur = l->pending_plugins;
      if (cur != NULL)
        cur = g_list_delete_link (cur, cur);
      l->pending_plugins = cur;
      if (cur == NULL)
        l->pending_plugins_tail = NULL;

      break;
    }
    case PACKET_SYNC:
      if (l->is_child) {
        /* Respond with our reply - also a sync */
        put_packet (l, PACKET_SYNC, tag, NULL, 0);
        GST_LOG ("Got SYNC in child - replying");
      } else
        l->rx_got_sync = TRUE;
      break;
    case PACKET_VERSION:
      if (l->is_child) {
        /* Respond with our reply - a version packet, with the version */
        const gint version_len =
            sizeof (guint32) + GST_MAGIC_BINARY_VERSION_LEN;
        guint8 version_info[sizeof (guint32) + GST_MAGIC_BINARY_VERSION_LEN];
        memset (version_info, 0, version_len);
        GST_WRITE_UINT32_BE (version_info, loader_protocol_version);
        memcpy (version_info + sizeof (guint32), GST_MAGIC_BINARY_VERSION_STR,
            strlen (GST_MAGIC_BINARY_VERSION_STR));
        put_packet (l, PACKET_VERSION, tag, version_info, version_len);
        GST_LOG ("Got VERSION in child - replying %u", loader_protocol_version);
      } else {
        res = check_protocol_version (l, payload, payload_len);
      }
      break;
    default:
      return FALSE;             /* Invalid packet -> something is wrong */
  }

  return res;
}

static gboolean
read_one (GstPluginLoader * l)
{
  guint64 magic;
  guint32 to_read, packet_len, tag;
  guint8 *in;
  gint res;

  to_read = HEADER_SIZE;
  in = l->rx_buf;
  do {
    res = read (l->fd_r.fd, in, to_read);
    if (G_UNLIKELY (res < 0)) {
      if (errno == EAGAIN || errno == EINTR)
        continue;
      GST_LOG ("Failed reading packet header");
      return FALSE;
    }
    to_read -= res;
    in += res;
  } while (to_read > 0);

  magic = GST_READ_UINT32_BE (l->rx_buf + 8);
  if (magic != HEADER_MAGIC) {
    GST_WARNING
        ("Invalid packet (bad magic number) received from plugin scanner subprocess");
    return FALSE;
  }

  packet_len = GST_READ_UINT32_BE (l->rx_buf + 4);
  if (packet_len + HEADER_SIZE > BUF_MAX_SIZE) {
    GST_WARNING
        ("Received excessively large packet for plugin scanner subprocess");
    return FALSE;
  }
  tag = GST_READ_UINT24_BE (l->rx_buf + 1);

  if (packet_len > 0) {
    if (packet_len + HEADER_SIZE >= l->rx_buf_size) {
      GST_LOG ("Expanding rx buf from %d to %d",
          l->rx_buf_size, packet_len + HEADER_SIZE + BUF_GROW_EXTRA);
      l->rx_buf_size = packet_len + HEADER_SIZE + BUF_GROW_EXTRA;
      l->rx_buf = g_realloc (l->rx_buf, l->rx_buf_size);
    }

    in = l->rx_buf + HEADER_SIZE;
    to_read = packet_len;
    do {
      res = read (l->fd_r.fd, in, to_read);
      if (G_UNLIKELY (res < 0)) {
        if (errno == EAGAIN || errno == EINTR)
          continue;
        GST_ERROR ("Packet payload read failed");
        return FALSE;
      }
      to_read -= res;
      in += res;
    } while (to_read > 0);
  } else {
    GST_LOG ("No payload to read for 0 length packet type %d tag %u",
        l->rx_buf[0], tag);
  }

  return handle_rx_packet (l, l->rx_buf[0], tag,
      l->rx_buf + HEADER_SIZE, packet_len);
}

static gboolean
exchange_packets (GstPluginLoader * l)
{
  gint res;

  /* Wait for activity on our FDs */
  do {
    do {
      res = gst_poll_wait (l->fdset, GST_SECOND);
    } while (res == -1 && (errno == EINTR || errno == EAGAIN));

    if (res < 0)
      return FALSE;

    GST_LOG ("Poll res = %d. %d bytes pending for write", res,
        l->tx_buf_write - l->tx_buf_read);

    if (!l->rx_done) {
      if (gst_poll_fd_has_error (l->fdset, &l->fd_r)) {
        GST_LOG ("read fd %d errored", l->fd_r.fd);
        goto fail_and_cleanup;
      }

      if (gst_poll_fd_can_read (l->fdset, &l->fd_r)) {
        if (!read_one (l))
          goto fail_and_cleanup;
      } else if (gst_poll_fd_has_closed (l->fdset, &l->fd_r)) {
        GST_LOG ("read fd %d closed", l->fd_r.fd);
        goto fail_and_cleanup;
      }
    }

    if (l->tx_buf_read < l->tx_buf_write) {
      if (gst_poll_fd_has_error (l->fdset, &l->fd_w)) {
        GST_ERROR ("write fd %d errored", l->fd_w.fd);
        goto fail_and_cleanup;
      }
      if (gst_poll_fd_can_write (l->fdset, &l->fd_w)) {
        if (!write_one (l))
          goto fail_and_cleanup;
      } else if (gst_poll_fd_has_closed (l->fdset, &l->fd_w)) {
        GST_LOG ("write fd %d closed", l->fd_w.fd);
        goto fail_and_cleanup;
      }
    }
  } while (l->tx_buf_read < l->tx_buf_write);

  return TRUE;
fail_and_cleanup:
  plugin_loader_cleanup_child (l);
  return FALSE;
}
