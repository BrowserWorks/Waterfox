/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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
 */

#ifndef __GST_DYN_API_H__
#define __GST_DYN_API_H__

#include <glib-object.h>

G_BEGIN_DECLS

#define GST_TYPE_DYN_API \
  (gst_dyn_api_get_type ())
#define GST_DYN_API(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DYN_API, GstDynApi))
#define GST_DYN_API_CAST(obj) \
  ((GstDynApi *) (obj))
#define GST_DYN_API_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DYN_API, GstDynApiClass))
#define GST_IS_DYN_API(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DYN_API))
#define GST_IS_DYN_API_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DYN_API))

#define GST_DYN_SYM_SPEC(type, name) \
  { G_STRINGIFY (name), G_STRUCT_OFFSET (type, name), TRUE }
#define GST_DYN_SYM_SPEC_OPTIONAL(type, name) \
  { G_STRINGIFY (name), G_STRUCT_OFFSET (type, name), FALSE }

typedef struct _GstDynApi GstDynApi;
typedef struct _GstDynApiClass GstDynApiClass;
typedef struct _GstDynApiPrivate GstDynApiPrivate;

struct _GstDynApi
{
  GObject parent;

  GstDynApiPrivate * priv;
};

struct _GstDynApiClass
{
  GObjectClass parent_class;
};

GType gst_dyn_api_get_type (void);

G_END_DECLS

#endif
