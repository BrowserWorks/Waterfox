/* GMODULE - GLIB wrapper code for dynamic module loading
 * Copyright (C) 1998, 2000 Tim Janik  
 *
 * BeOS GMODULE implementation
 * Copyright (C) 1999 Richard Offer and Shawn T. Amundson (amundson@gtk.org)
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
 * MT safe
 */
#include "config.h"

#include <be/kernel/image.h> /* image (aka DSO) handling functions... */

/*
 * The BeOS doesn't use the same symantics as Unix's dlopen....
 * 
 */
#ifndef	RTLD_GLOBAL
#define	RTLD_GLOBAL	0
#endif	/* RTLD_GLOBAL */
#ifndef	RTLD_LAZY
#define	RTLD_LAZY	1
#endif	/* RTLD_LAZY */
#ifndef	RTLD_NOW
#define	RTLD_NOW	0
#endif	/* RTLD_NOW */


/*
 * Points to Ponder
 * 
 * You can load the same DSO more than once, in which case you'll have 
 * different image_id's. While this means that we don't have to worry about 
 * reference counts, it could lead to problems in the future....
 * richard.
 *
 * load_add_on() apparently does not support lazy or local binding.  Need
 * to confirm that the actual behavior is non-lazy/local.  --ds
 */

#include <Errors.h>
#include <stdio.h>

/* --- functions --- */
static gpointer
_g_module_open (const gchar *file_name,
		gboolean     bind_lazy,
		gboolean     bind_local)
{
  image_id handle;
  
  handle = load_add_on (file_name);
  if (handle < B_OK)
    {
      gchar *msg = g_strdup_printf ("failed to load_add_on(%s): %s",
				    file_name,
				    strerror (handle));
      
      g_module_set_error (msg);
      g_free (msg);
      
      return NULL;
    }
  
  return (gpointer) handle;
}

static gpointer
_g_module_self (void)
{
  image_info info;
  int32 cookie = 0;
  status_t status;
  
  /* Is it always the first one?  I'm guessing yes. */
  status = get_next_image_info (0, &cookie, &info);
  if (status == B_OK)
    return (gpointer) info.id;
  else
    {
      gchar *msg = g_strdup_printf ("failed to get_next_image_info(self): %s",
				    strerror (status));
      
      g_module_set_error (msg);
      g_free (msg);
      
      return NULL;
    }
}

static void
_g_module_close (gpointer handle,
		 gboolean is_unref)
{
  image_info info;
  gchar *name;
  
  if (unload_add_on ((image_id) handle) != B_OK)
    {
      gchar *msg;
      
      /* Try and get the name of the image. */
      if (get_image_info ((image_id) handle, &info) != B_OK)
	name = g_strdup ("unknown");
      else
	name = g_strdup (info.name);
      
      msg = g_strdup_printf ("failed to unload_add_on(%s): %s", name, strerror (status));
      g_module_set_error (msg);
      g_free (msg);
      g_free (name);
    }
}

static gpointer
_g_module_symbol (gpointer     handle,
		  const gchar *symbol_name)
{
  image_id id;
  status_t status;
  image_info info;
  int32 type, name_len;
  void *p;
  gchar *msg, name[256];
  gint n, l;
  
  id = (image_id) handle;
  
  status = get_image_info (id, &info);
  if (status != B_OK)
    {
      msg = g_strdup_printf ("failed to get_image_info(): %s", strerror (status));
      g_module_set_error (msg);
      g_free (msg);
      
      return NULL;
    }
  
  l = strlen (symbol_name);
  name_len = 256;
  type = B_SYMBOL_TYPE_ANY;
  n = 0;
  status = get_nth_image_symbol (id, n, name, &name_len, &type, &p);
  while (status == B_OK)
    {
      if (p && strncmp (name, symbol_name, l) == 0)
	return p;
      
      if (strcmp (name, "_end") == 0)
        {
	  msg = g_strdup_printf ("unmatched symbol name '%s'", symbol_name);
          g_module_set_error (msg);
	  g_free (msg);
	  
	  return NULL;
        }
      
      name_len = 256;
      type = B_SYMBOL_TYPE_ANY;
      n++;
      status = get_nth_image_symbol (id, n, name, &name_len, &type, &p);
    }
  
  msg = g_strdup_printf ("failed to get_image_symbol(%s): %s", symbol_name, strerror (status));
  g_module_set_error (msg);
  g_free (msg);
  
  return NULL;
}

static gchar*
_g_module_build_path (const gchar *directory,
		      const gchar *module_name)
{
  g_warning ("_g_module_build_path() untested for BeOS!");
  
  if (directory && *directory)
    {
      if (strncmp (module_name, "lib", 3) == 0)
	return g_strconcat (directory, "/", module_name, NULL);
      else
	return g_strconcat (directory, "/lib", module_name, "." G_MODULE_SUFFIX, NULL);
    }
  else if (strncmp (module_name, "lib", 3) == 0)
    return g_strdup (module_name);
  else
    return g_strconcat ("lib", module_name, "." G_MODULE_SUFFIX, NULL);
}
