/* GLIB - Library of useful routines for C programming
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/*
 * Modified by the GLib Team and others 1997-2000.  See the AUTHORS
 * file for a list of people on the GLib Team.  See the ChangeLog
 * files for a list of changes.  These files are distributed with
 * GLib at ftp://ftp.gtk.org/pub/gtk/.
 */

#ifndef __G_ENVIRON_H__
#define __G_ENVIRON_H__

#if !defined (__GLIB_H_INSIDE__) && !defined (GLIB_COMPILATION)
#error "Only <glib.h> can be included directly."
#endif

#include <glib/gtypes.h>

G_BEGIN_DECLS

GLIB_AVAILABLE_IN_ALL
const gchar * g_getenv           (const gchar  *variable);
GLIB_AVAILABLE_IN_ALL
gboolean      g_setenv           (const gchar  *variable,
                                  const gchar  *value,
                                  gboolean      overwrite);
GLIB_AVAILABLE_IN_ALL
void          g_unsetenv         (const gchar  *variable);
GLIB_AVAILABLE_IN_ALL
gchar **      g_listenv          (void);

GLIB_AVAILABLE_IN_ALL
gchar **      g_get_environ      (void);
GLIB_AVAILABLE_IN_ALL
const gchar * g_environ_getenv   (gchar       **envp,
                                  const gchar  *variable);
GLIB_AVAILABLE_IN_ALL
gchar **      g_environ_setenv   (gchar       **envp,
                                  const gchar  *variable,
                                  const gchar  *value,
                                  gboolean      overwrite) G_GNUC_WARN_UNUSED_RESULT;
GLIB_AVAILABLE_IN_ALL
gchar **      g_environ_unsetenv (gchar       **envp,
                                  const gchar  *variable) G_GNUC_WARN_UNUSED_RESULT;

#ifdef G_OS_WIN32
#define g_getenv   g_getenv_utf8
#define g_setenv   g_setenv_utf8
#define g_unsetenv g_unsetenv_utf8

GLIB_AVAILABLE_IN_ALL
const gchar *g_getenv_utf8   (const gchar  *variable);
GLIB_AVAILABLE_IN_ALL
gboolean     g_setenv_utf8   (const gchar  *variable,
                              const gchar  *value,
                              gboolean      overwrite);
GLIB_AVAILABLE_IN_ALL
void         g_unsetenv_utf8 (const gchar  *variable);
#endif

G_END_DECLS

#endif /* __G_ENVIRON_H__ */
