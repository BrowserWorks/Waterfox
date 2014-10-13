/* GObject - GLib Type, Object, Parameter and Signal Library
 * Copyright (C) 2001 Red Hat, Inc.
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
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 */
#ifndef __G_SOURCECLOSURE_H__
#define __G_SOURCECLOSURE_H__

#if !defined (__GLIB_GOBJECT_H_INSIDE__) && !defined (GOBJECT_COMPILATION)
#error "Only <glib-object.h> can be included directly."
#endif

#include <gobject/gclosure.h>
#include <gobject/glib-types.h>

G_BEGIN_DECLS

GLIB_AVAILABLE_IN_ALL
void g_source_set_closure        (GSource  *source,
				  GClosure *closure);

GLIB_AVAILABLE_IN_ALL
void g_source_set_dummy_callback (GSource  *source);

G_END_DECLS

#endif /* __G_SOURCECLOSURE_H__ */
