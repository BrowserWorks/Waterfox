/* GStreamer
 * Copyright (C) 2008 Jan Schmidt <jan.schmidt@sun.com>
 *
 * gst-plugin-scanner.c: tool to load plugins out of process for scanning
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
 *
 * Helper binary that does plugin-loading out of process and feeds results
 * back to the parent over fds.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/gst_private.h>
#include <gst/gst.h>

#include <string.h>

int
main (int argc, char *argv[])
{
  gboolean res;
  char **my_argv;
  int my_argc;

  if (argc != 2 || strcmp (argv[1], "-l"))
    return 1;

  my_argc = 2;
  my_argv = g_malloc (my_argc * sizeof (char *));
  my_argv[0] = argv[0];
  my_argv[1] = (char *) "--gst-disable-registry-update";

#ifndef GST_DISABLE_REGISTRY
  _gst_disable_registry_cache = TRUE;
#endif

  res = gst_init_check (&my_argc, &my_argv, NULL);

  g_free (my_argv);
  if (!res)
    return 1;

  /* Create registry scanner listener and run */
  if (!_gst_plugin_loader_client_run ())
    return 1;

  return 0;
}
