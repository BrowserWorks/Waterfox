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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "coremediactx.h"

#include <gst/gst.h>

typedef struct _GstApiProvider GstApiProvider;

typedef gpointer (*GstApiProviderObtainFunc) (GError ** error);

struct _GstApiProvider
{
  GstCoreMediaApi api;
  GstApiProviderObtainFunc obtain;
  guint offset;
};

#define API_PROVIDER(AN, a_n) \
  { GST_API_##AN, (GstApiProviderObtainFunc) gst_##a_n##_api_obtain, \
    G_STRUCT_OFFSET (GstCoreMediaCtx, a_n) }

static const GstApiProvider api_provider[] = {
  API_PROVIDER (VIDEO_TOOLBOX, vt),
};

G_DEFINE_TYPE (GstCoreMediaCtx, gst_core_media_ctx, G_TYPE_OBJECT);

static void
gst_core_media_ctx_init (GstCoreMediaCtx * self)
{
}

static void
gst_core_media_ctx_dispose (GObject * object)
{
  GstCoreMediaCtx *self = GST_CORE_MEDIA_CTX_CAST (object);
  guint i;

  for (i = 0; i != G_N_ELEMENTS (api_provider); i++) {
    const GstApiProvider *ap = &api_provider[i];
    gpointer *api_ptr = (gpointer *) ((guint8 *) self + ap->offset);

    if (*api_ptr != NULL) {
      g_object_unref (*api_ptr);
      *api_ptr = NULL;
    }
  }

  G_OBJECT_CLASS (gst_core_media_ctx_parent_class)->dispose (object);
}

static void
gst_core_media_ctx_class_init (GstCoreMediaCtxClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  gobject_class->dispose = gst_core_media_ctx_dispose;
}

GstCoreMediaCtx *
gst_core_media_ctx_new (GstCoreMediaApi required_apis, GError ** error)
{
  GstCoreMediaCtx *ctx;
  GArray *error_messages;
  guint i;

  ctx = g_object_new (GST_TYPE_CORE_MEDIA_CTX, NULL);

  error_messages = g_array_new (TRUE, FALSE, sizeof (gchar *));

  for (i = 0; i != G_N_ELEMENTS (api_provider); i++) {
    const GstApiProvider *ap = &api_provider[i];

    if ((required_apis & ap->api) != 0) {
      gpointer *api_ptr = (gpointer *) ((guint8 *) ctx + ap->offset);
      GError *tmp_error = NULL;

      *api_ptr = ap->obtain (&tmp_error);
      if (tmp_error != NULL) {
        gchar *message_copy = g_strdup (tmp_error->message);
        g_array_append_val (error_messages, message_copy);
        g_clear_error (&tmp_error);
      }
    }
  }

  if (error_messages->len != 0) {
    gchar *errors_joined;

    errors_joined = g_strjoinv ("\n\t* ", (gchar **) error_messages->data);
    g_set_error (error, GST_RESOURCE_ERROR, GST_RESOURCE_ERROR_FAILED,
        "Could not obtain required API%s:%s%s",
        (error_messages->len == 1) ? "" : "s",
        (error_messages->len == 1) ? " " : "\n\t* ", errors_joined);
    g_free (errors_joined);

    g_object_unref (ctx);
    ctx = NULL;
  }

  for (i = 0; i != error_messages->len; i++)
    g_free (g_array_index (error_messages, gchar *, i));
  g_array_free (error_messages, TRUE);

  return ctx;
}
