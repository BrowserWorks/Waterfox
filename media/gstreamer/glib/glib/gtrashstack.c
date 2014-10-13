/* GLIB - Library of useful routines for C programming
 * Copyright (C) 1995-1998  Peter Mattis, Spencer Kimball and Josh MacDonald
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

#include "config.h"

/**
 * SECTION:trash_stack
 * @title: Trash Stacks
 * @short_description: maintain a stack of unused allocated memory chunks
 *
 * A #GTrashStack is an efficient way to keep a stack of unused allocated
 * memory chunks. Each memory chunk is required to be large enough to hold
 * a #gpointer. This allows the stack to be maintained without any space
 * overhead, since the stack pointers can be stored inside the memory chunks.
 *
 * There is no function to create a #GTrashStack. A %NULL #GTrashStack*
 * is a perfectly valid empty stack.
 */

/**
 * GTrashStack:
 * @next: pointer to the previous element of the stack,
 *     gets stored in the first <literal>sizeof (gpointer)</literal>
 *     bytes of the element
 *
 * Each piece of memory that is pushed onto the stack
 * is cast to a <structname>GTrashStack*</structname>.
 */

/**
 * g_trash_stack_push:
 * @stack_p: a #GTrashStack
 * @data_p: the piece of memory to push on the stack
 *
 * Pushes a piece of memory onto a #GTrashStack.
 */

/**
 * g_trash_stack_pop:
 * @stack_p: a #GTrashStack
 *
 * Pops a piece of memory off a #GTrashStack.
 *
 * Returns: the element at the top of the stack
 */

/**
 * g_trash_stack_peek:
 * @stack_p: a #GTrashStack
 *
 * Returns the element at the top of a #GTrashStack
 * which may be %NULL.
 *
 * Returns: the element at the top of the stack
 */

/**
 * g_trash_stack_height:
 * @stack_p: a #GTrashStack
 *
 * Returns the height of a #GTrashStack.
 *
 * Note that execution of this function is of O(N) complexity
 * where N denotes the number of items on the stack.
 *
 * Returns: the height of the stack
 */

#define G_IMPLEMENT_INLINES 1
#define __G_TRASH_STACK_C__
#include "gtrashstack.h"
