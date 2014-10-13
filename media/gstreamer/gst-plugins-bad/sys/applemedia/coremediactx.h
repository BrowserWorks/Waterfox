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

#ifndef __GST_CORE_MEDIA_CTX_H__
#define __GST_CORE_MEDIA_CTX_H__

#include "vtapi.h"

#include <glib.h>

G_BEGIN_DECLS

#define GST_TYPE_CORE_MEDIA_CTX \
  (gst_core_media_ctx_get_type ())
#define GST_CORE_MEDIA_CTX(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_CORE_MEDIA_CTX, GstCoreMediaCtx))
#define GST_CORE_MEDIA_CTX_CAST(obj) \
  ((GstCoreMediaCtx *) (obj))
#define GST_CORE_MEDIA_CTX_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_CORE_MEDIA_CTX, GstCoreMediaCtxClass))
#define GST_IS_CORE_MEDIA_CTX(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_CORE_MEDIA_CTX))
#define GST_IS_CORE_MEDIA_CTX_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_CORE_MEDIA_CTX))

typedef struct _GstCoreMediaCtx GstCoreMediaCtx;
typedef struct _GstCoreMediaCtxClass GstCoreMediaCtxClass;

typedef enum _GstCoreMediaApi GstCoreMediaApi;

struct _GstCoreMediaCtx
{
  GObject parent;

  /* Common */
  GstVTApi *vt;
};

struct _GstCoreMediaCtxClass
{
  GObjectClass parent_class;
};

enum _GstCoreMediaApi
{
  GST_API_VIDEO_TOOLBOX = (1 << 0),
};

GType gst_core_media_ctx_get_type (void);

GstCoreMediaCtx * gst_core_media_ctx_new (GstCoreMediaApi required_apis,
    GError ** error);

G_END_DECLS

#endif
