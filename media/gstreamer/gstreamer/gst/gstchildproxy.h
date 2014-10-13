/* GStreamer
 * Copyright (C) 2005 Stefan Kost <ensonic@users.sf.net>
 *
 * gstchildproxy.h: interface header for multi child elements
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

#ifndef __GST_CHILD_PROXY_H__
#define __GST_CHILD_PROXY_H__

#include <glib-object.h>
#include <gst/gst.h>

G_BEGIN_DECLS


#define GST_TYPE_CHILD_PROXY               (gst_child_proxy_get_type ())
#define GST_CHILD_PROXY(obj)               (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_CHILD_PROXY, GstChildProxy))
#define GST_IS_CHILD_PROXY(obj)            (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_CHILD_PROXY))
#define GST_CHILD_PROXY_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), GST_TYPE_CHILD_PROXY, GstChildProxyInterface))

/**
 * GstChildProxy:
 *
 * Opaque #GstChildProxy data structure.
 */
typedef struct _GstChildProxy GstChildProxy;    /* dummy object */
typedef struct _GstChildProxyInterface GstChildProxyInterface;

/**
 * GstChildProxyInterface:
 * @parent: parent interface type.
 * @get_child_by_name:  virtual method to fetch the child by name
 * @get_child_by_index: virtual method to fetch the child by index
 * @get_children_count: virtual method to get the children count
 *
 * #GstChildProxy interface.
 */
struct _GstChildProxyInterface
{
  GTypeInterface parent;

  /* methods */
  GObject * (*get_child_by_name)  (GstChildProxy * parent, const gchar * name);
  GObject * (*get_child_by_index) (GstChildProxy * parent, guint index);
  guint     (*get_children_count) (GstChildProxy * parent);
  /*< private >*/
  /* signals */
  void      (*child_added)        (GstChildProxy * parent, GObject * child, const gchar * name);
  void      (*child_removed)      (GstChildProxy * parent, GObject * child, const gchar * name);

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

GType     gst_child_proxy_get_type (void);

GObject * gst_child_proxy_get_child_by_name  (GstChildProxy * parent, const gchar * name);

guint     gst_child_proxy_get_children_count (GstChildProxy * parent);
GObject * gst_child_proxy_get_child_by_index (GstChildProxy * parent, guint index);

gboolean  gst_child_proxy_lookup             (GstChildProxy *object, const gchar *name,
                                              GObject **target, GParamSpec **pspec);

void      gst_child_proxy_get_property       (GstChildProxy * object, const gchar *name,
                                              GValue *value);
void      gst_child_proxy_get_valist         (GstChildProxy * object,
                                              const gchar * first_property_name,
                                              va_list var_args);
void      gst_child_proxy_get                (GstChildProxy * object,
                                              const gchar * first_property_name,
                                              ...) G_GNUC_NULL_TERMINATED;

void      gst_child_proxy_set_property       (GstChildProxy * object, const gchar *name,
                                              const GValue *value);
void      gst_child_proxy_set_valist         (GstChildProxy* object,
                                              const gchar * first_property_name,
                                              va_list var_args);
void      gst_child_proxy_set                (GstChildProxy * object,
                                              const gchar * first_property_name,
                                              ...) G_GNUC_NULL_TERMINATED;

void      gst_child_proxy_child_added        (GstChildProxy * parent, GObject * child,
                                              const gchar *name);
void      gst_child_proxy_child_removed      (GstChildProxy * parent, GObject * child,
                                              const gchar *name);

G_END_DECLS

#endif /* __GST_CHILD_PROXY_H__ */
