/* GMODULE - GLIB wrapper code for dynamic module loading
 * Copyright (C) 1998, 2000 Tim Janik
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
 */

/*
 * Modified by the GLib Team and others 1997-2000.  See the AUTHORS
 * file for a list of people on the GLib Team.  See the ChangeLog
 * files for a list of changes.  These files are distributed with
 * GLib at ftp://ftp.gtk.org/pub/gtk/. 
 */

/* 
 * MT safe
 */
#include "config.h"

#include <dl.h>


/* some flags are missing on some systems, so we provide
 * harmless defaults.
 *
 * Mandatory:
 * BIND_IMMEDIATE  - Resolve symbol references when the library is loaded.
 * BIND_DEFERRED   - Delay code symbol resolution until actual reference.
 *
 * Optionally:
 * BIND_FIRST	   - Place the library at the head of the symbol search order.
 * BIND_NONFATAL   - The default BIND_IMMEDIATE behavior is to treat all unsatisfied
 *		     symbols as fatal.	This flag allows binding of unsatisfied code
 *		     symbols to be deferred until use.
 *		     [Perl: For certain libraries, like DCE, deferred binding often
 *		     causes run time problems.	Adding BIND_NONFATAL to BIND_IMMEDIATE
 *		     still allows unresolved references in situations like this.]
 * BIND_NOSTART	   - Do not call the initializer for the shared library when the
 *		     library is loaded, nor on a future call to shl_unload().
 * BIND_VERBOSE	   - Print verbose messages concerning possible unsatisfied symbols.
 *
 * hp9000s700/hp9000s800:
 * BIND_RESTRICTED - Restrict symbols visible by the library to those present at
 *		     library load time.
 * DYNAMIC_PATH	   - Allow the loader to dynamically search for the library specified
 *		     by the path argument.
 */
#ifndef	DYNAMIC_PATH
#define	DYNAMIC_PATH	0
#endif	/* DYNAMIC_PATH */
#ifndef	BIND_RESTRICTED
#define	BIND_RESTRICTED	0
#endif	/* BIND_RESTRICTED */

#define	OPT_BIND_FLAGS	(BIND_NONFATAL | BIND_VERBOSE)


/* --- functions --- */

/*
 * shl_load() does not appear to support making symbols invisible to
 * the global namespace.  However, the default is to put the library
 * last in the search order, which is approximately what we want,
 * since it will cause symbols that conflict with existing symbols to
 * be invisible.  It is unclear if BIND_FIRST should be used when
 * bind_local==0, since it may cause the loaded symbols to be used
 * preferentially to the application's symbols, which is Almost
 * Always Wrong.  --ds
 */
static gpointer
_g_module_open (const gchar *file_name,
		gboolean     bind_lazy,
		gboolean     bind_local)
{
  shl_t shl_handle;
  
  shl_handle = shl_load (file_name,
			 (bind_lazy ? BIND_DEFERRED : BIND_IMMEDIATE) | OPT_BIND_FLAGS, 0);
  if (!shl_handle)
    {
      /* the hp-docs say we should better abort() if errno==ENOSYM ;( */
      g_module_set_error (g_strerror (errno));
    }
  
  return (gpointer) shl_handle;
}

static gpointer
_g_module_self (void)
{
  shl_t shl_handle;
  
  shl_handle = PROG_HANDLE;
  if (!shl_handle)
    g_module_set_error (g_strerror (errno));
  
  return shl_handle;
}

static void
_g_module_close (gpointer handle,
		 gboolean is_unref)
{
  if (!is_unref)
    {
      if (shl_unload ((shl_t) handle) != 0)
	g_module_set_error (g_strerror (errno));
    }
}

static gpointer
_g_module_symbol (gpointer     handle,
		  const gchar *symbol_name)
{
  gpointer p = NULL;
  
  /* should we restrict lookups to TYPE_PROCEDURE?
   */
  if (handle == PROG_HANDLE)
    {
      /* PROG_HANDLE will only lookup symbols in the program itself, not honouring
       * libraries. passing NULL as a handle will also try to lookup the symbol
       * in currently loaded libraries. fix pointed out and supplied by:
       * David Gero <dgero@nortelnetworks.com>
       */
      handle = NULL;
    }
  if (shl_findsym ((shl_t*) &handle, symbol_name, TYPE_UNDEFINED, &p) != 0 ||
      handle == NULL || p == NULL)
    {
      /* the hp-docs say we should better abort() if errno==ENOSYM ;( */
      g_module_set_error (g_strerror (errno));
    }
  
  return p;
}

static gchar*
_g_module_build_path (const gchar *directory,
		      const gchar *module_name)
{
  if (directory && *directory)
    if (strncmp (module_name, "lib", 3) == 0)
      return g_strconcat (directory, "/", module_name, NULL);
    else
      return g_strconcat (directory, "/lib", module_name, ".sl", NULL);
  else if (strncmp (module_name, "lib", 3) == 0)
    return g_strdup (module_name);
  else
    return g_strconcat ("lib", module_name, ".sl", NULL);
}
