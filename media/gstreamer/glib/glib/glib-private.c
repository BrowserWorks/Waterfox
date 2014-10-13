/* GLIB - Library of useful routines for C programming
 * Copyright (C) 2011 Red Hat, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Author: Colin Walters <walters@verbum.org>
 */

#include "config.h"

#include "glib-private.h"

/**
 * glib__private__:
 * @arg: Do not use this argument
 *
 * Do not call this function; it is used to share private
 * API between glib, gobject, and gio.
 */
GLibPrivateVTable *
glib__private__ (void)
{
  static GLibPrivateVTable table = {
    g_wakeup_new,
    g_wakeup_free,
    g_wakeup_get_pollfd,
    g_wakeup_signal,
    g_wakeup_acknowledge,

    g_get_worker_context,

    g_check_setuid,
    g_main_context_new_with_next_id,

    g_dir_open_with_errno,
    g_dir_new_from_dirp
  };

  return &table;
}

