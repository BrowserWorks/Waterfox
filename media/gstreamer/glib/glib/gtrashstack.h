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

#ifndef __G_TRASH_STACK_H__
#define __G_TRASH_STACK_H__

#if !defined (__GLIB_H_INSIDE__) && !defined (GLIB_COMPILATION)
#error "Only <glib.h> can be included directly."
#endif

#include <glib/gutils.h>

G_BEGIN_DECLS

typedef struct _GTrashStack GTrashStack;
struct _GTrashStack
{
  GTrashStack *next;
};

G_INLINE_FUNC void      g_trash_stack_push   (GTrashStack **stack_p,
                                              gpointer      data_p);
G_INLINE_FUNC gpointer  g_trash_stack_pop    (GTrashStack **stack_p);
G_INLINE_FUNC gpointer  g_trash_stack_peek   (GTrashStack **stack_p);
G_INLINE_FUNC guint     g_trash_stack_height (GTrashStack **stack_p);

#if defined (G_CAN_INLINE) || defined (__G_TRASH_STACK_C__)

G_INLINE_FUNC void
g_trash_stack_push (GTrashStack **stack_p,
                    gpointer      data_p)
{
  GTrashStack *data = (GTrashStack *) data_p;

  data->next = *stack_p;
  *stack_p = data;
}
G_INLINE_FUNC gpointer
g_trash_stack_pop (GTrashStack **stack_p)
{
  GTrashStack *data;

  data = *stack_p;
  if (data)
    {
      *stack_p = data->next;
      /* NULLify private pointer here, most platforms store NULL as
       * subsequent 0 bytes
       */
      data->next = NULL;
    }

  return data;
}
G_INLINE_FUNC gpointer
g_trash_stack_peek (GTrashStack **stack_p)
{
  GTrashStack *data;

  data = *stack_p;

  return data;
}
G_INLINE_FUNC guint
g_trash_stack_height (GTrashStack **stack_p)
{
  GTrashStack *data;
  guint i = 0;

  for (data = *stack_p; data; data = data->next)
    i++;

  return i;
}

#endif  /* G_CAN_INLINE || __G_TRASH_STACK_C__ */

G_END_DECLS

#endif /* __G_UTILS_H__ */
