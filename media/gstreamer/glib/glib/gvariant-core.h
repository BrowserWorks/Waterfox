/*
 * Copyright © 2007, 2008 Ryan Lortie
 * Copyright © 2010 Codethink Limited
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

#ifndef __G_VARIANT_CORE_H__
#define __G_VARIANT_CORE_H__

#include <glib/gvarianttypeinfo.h>
#include <glib/gvariant.h>
#include <glib/gbytes.h>

/* gvariant-core.c */

GVariant *              g_variant_new_from_children                     (const GVariantType  *type,
                                                                         GVariant           **children,
                                                                         gsize                n_children,
                                                                         gboolean             trusted);

gboolean                g_variant_is_trusted                            (GVariant            *value);

GVariantTypeInfo *      g_variant_get_type_info                         (GVariant            *value);

#endif /* __G_VARIANT_CORE_H__ */
