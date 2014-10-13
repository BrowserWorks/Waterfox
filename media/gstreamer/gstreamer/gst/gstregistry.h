/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wim.taymans@chello.be>
 *
 * gstregistry.h: Header for registry handling
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


#ifndef __GST_REGISTRY_H__
#define __GST_REGISTRY_H__

#include <gst/gstconfig.h>
#include <gst/gstplugin.h>
#include <gst/gstpluginfeature.h>

G_BEGIN_DECLS

#define GST_TYPE_REGISTRY               (gst_registry_get_type ())
#define GST_REGISTRY(obj)               (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_REGISTRY, GstRegistry))
#define GST_IS_REGISTRY(obj)            (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_REGISTRY))
#define GST_REGISTRY_CLASS(klass)       (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_REGISTRY, GstRegistryClass))
#define GST_IS_REGISTRY_CLASS(klass)    (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_REGISTRY))
#define GST_REGISTRY_GET_CLASS(obj)     (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_REGISTRY, GstRegistryClass))

typedef struct _GstRegistry GstRegistry;
typedef struct _GstRegistryClass GstRegistryClass;
typedef struct _GstRegistryPrivate GstRegistryPrivate;

/**
 * GstRegistry:
 *
 * Opaque #GstRegistry structure.
 */
struct _GstRegistry {
  GstObject      object;

  /*< private >*/
  GstRegistryPrivate *priv;
};

struct _GstRegistryClass {
  GstObjectClass        parent_class;
};

GType                   gst_registry_get_type           (void);

GstRegistry *           gst_registry_get                (void);

gboolean                gst_registry_scan_path          (GstRegistry *registry, const gchar *path);

#if 0
void                    gst_registry_add_path           (GstRegistry * registry, const gchar * path);
GList*                  gst_registry_get_path_list      (GstRegistry *registry);
#endif

gboolean                gst_registry_add_plugin         (GstRegistry *registry, GstPlugin *plugin);
void                    gst_registry_remove_plugin      (GstRegistry *registry, GstPlugin *plugin);
gboolean                gst_registry_add_feature        (GstRegistry * registry, GstPluginFeature * feature);
void                    gst_registry_remove_feature     (GstRegistry * registry, GstPluginFeature * feature);

GList*                  gst_registry_get_plugin_list    (GstRegistry *registry);
GList*                  gst_registry_plugin_filter      (GstRegistry *registry,
                                                         GstPluginFilter filter,
                                                         gboolean first,
                                                         gpointer user_data);
GList*                  gst_registry_feature_filter     (GstRegistry *registry,
                                                         GstPluginFeatureFilter filter,
                                                         gboolean first,
                                                         gpointer user_data);
GList *                 gst_registry_get_feature_list   (GstRegistry *registry,
                                                         GType type);
GList *                 gst_registry_get_feature_list_by_plugin (GstRegistry *registry, const gchar *name);
guint32                 gst_registry_get_feature_list_cookie (GstRegistry *registry);

GstPlugin*              gst_registry_find_plugin        (GstRegistry *registry, const gchar *name);
GstPluginFeature*       gst_registry_find_feature       (GstRegistry *registry, const gchar *name, GType type);

GstPlugin *             gst_registry_lookup             (GstRegistry *registry, const char *filename);
GstPluginFeature *      gst_registry_lookup_feature     (GstRegistry *registry, const char *name);

gboolean                gst_registry_check_feature_version (GstRegistry *registry,
                                                            const gchar *feature_name,
                                                            guint        min_major,
                                                            guint        min_minor,
                                                            guint        min_micro);

G_END_DECLS

#endif /* __GST_REGISTRY_H__ */

