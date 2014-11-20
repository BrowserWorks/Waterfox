/*
 * Copyright © 2011 Canonical Limited
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * licence, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
 * USA.
 *
 * Author: Ryan Lortie <desrt@desrt.ca>
 */

#ifndef __GLIB_INIT_H__
#define __GLIB_INIT_H__

#include "gmessages.h"

extern GLogLevelFlags g_log_always_fatal;
extern GLogLevelFlags g_log_msg_prefix;
GLIB_VAR gboolean g_mem_gc_friendly;

#ifdef G_OS_WIN32
#include <windows.h>

void g_thread_win32_thread_detach (void);
void g_thread_win32_init (void);
void g_clock_win32_init (void);
extern HMODULE glib_dll;
#endif

#endif /* __GLIB_INIT_H__ */
