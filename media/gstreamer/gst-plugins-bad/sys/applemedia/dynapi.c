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

#include "dynapi.h"

#include "dynapi-internal.h"

#include <gmodule.h>
#include <gst/gst.h>

GST_DEBUG_CATEGORY (gst_dyn_api_debug);
#define GST_CAT_DEFAULT gst_dyn_api_debug

enum
{
  PROP_0,
  PROP_FILENAME
};

struct _GstDynApiPrivate
{
  gchar *filename;
  GModule *module;
};

G_DEFINE_TYPE (GstDynApi, gst_dyn_api, G_TYPE_OBJECT);

static void
gst_dyn_api_init (GstDynApi * self)
{
  self->priv = G_TYPE_INSTANCE_GET_PRIVATE (self, GST_TYPE_DYN_API,
      GstDynApiPrivate);
}

static void
gst_dyn_api_dispose (GObject * object)
{
  GstDynApi *self = GST_DYN_API_CAST (object);
  GstDynApiPrivate *priv = self->priv;

  if (priv->module != NULL) {
    g_module_close (priv->module);
    priv->module = NULL;
  }

  G_OBJECT_CLASS (gst_dyn_api_parent_class)->dispose (object);
}

static void
gst_dyn_api_finalize (GObject * object)
{
  GstDynApi *self = GST_DYN_API_CAST (object);
  GstDynApiPrivate *priv = self->priv;

  g_free (priv->filename);

  G_OBJECT_CLASS (gst_dyn_api_parent_class)->finalize (object);
}

static void
gst_dyn_api_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDynApi *self = GST_DYN_API (object);

  switch (prop_id) {
    case PROP_FILENAME:
      g_value_set_string (value, self->priv->filename);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_dyn_api_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDynApi *self = GST_DYN_API (object);

  switch (prop_id) {
    case PROP_FILENAME:
      g_free (self->priv->filename);
      self->priv->filename = g_value_dup_string (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_dyn_api_class_init (GstDynApiClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  gobject_class->dispose = gst_dyn_api_dispose;
  gobject_class->finalize = gst_dyn_api_finalize;
  gobject_class->get_property = gst_dyn_api_get_property;
  gobject_class->set_property = gst_dyn_api_set_property;

  g_type_class_add_private (klass, sizeof (GstDynApiPrivate));

  g_object_class_install_property (gobject_class, PROP_FILENAME,
      g_param_spec_string ("filename", "Filename", "Filename", NULL,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS));
}

gpointer
_gst_dyn_api_new (GType derived_type, const gchar * filename,
    const GstDynSymSpec * symbols, GError ** error)
{
  GstDynApi *api;
  GstDynApiPrivate *priv;
  guint i;
  GArray *names_not_found;

  api = g_object_new (derived_type, "filename", filename, NULL);
  priv = api->priv;

  priv->module = g_module_open (priv->filename, 0);
  if (priv->module == NULL)
    goto open_failed;

  names_not_found = g_array_new (TRUE, FALSE, sizeof (gchar *));

  for (i = 0; symbols[i].name != NULL; i++) {
    const GstDynSymSpec *s = &symbols[i];
    if (!g_module_symbol (priv->module, s->name,
            (gpointer *) (((guint8 *) api) + s->offset)) && s->is_required) {
      g_array_append_val (names_not_found, s->name);
    }
  }

  if (names_not_found->len > 0)
    goto one_or_more_name_not_found;

  g_array_free (names_not_found, TRUE);

  return api;

  /* ERRORS */
open_failed:
  {
    gchar *basename;

    basename = g_path_get_basename (filename);
    g_set_error (error, GST_RESOURCE_ERROR, GST_RESOURCE_ERROR_FAILED,
        "failed to open %s", basename);
    g_free (basename);

    goto any_error;
  }
one_or_more_name_not_found:
  {
    gchar *basename, *names_joined;

    basename = g_path_get_basename (filename);
    names_joined = g_strjoinv (", ", (gchar **) names_not_found->data);
    g_set_error (error, GST_RESOURCE_ERROR, GST_RESOURCE_ERROR_FAILED,
        "missing %u symbol%s in %s: %s",
        names_not_found->len, (names_not_found->len == 1) ? "" : "s",
        basename, names_joined);
    g_free (names_joined);
    g_free (basename);
    g_array_free (names_not_found, TRUE);

    goto any_error;
  }
any_error:
  {
    g_object_unref (api);

    return NULL;
  }
}
