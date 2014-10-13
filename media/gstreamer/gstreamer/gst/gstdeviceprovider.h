/* GStreamer
 * Copyright (C) 2012 Olivier Crete <olivier.crete@collabora.com>
 *
 * gstdeviceprovider.h: Device probing and monitoring
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <gst/gstdeviceproviderfactory.h>


#ifndef __GST_DEVICE_PROVIDER_H__
#define __GST_DEVICE_PROVIDER_H__

#include <gst/gstelement.h>

G_BEGIN_DECLS

typedef struct _GstDeviceProvider GstDeviceProvider;
typedef struct _GstDeviceProviderClass GstDeviceProviderClass;
typedef struct _GstDeviceProviderPrivate GstDeviceProviderPrivate;

#define GST_TYPE_DEVICE_PROVIDER                 (gst_device_provider_get_type())
#define GST_IS_DEVICE_PROVIDER(obj)              (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEVICE_PROVIDER))
#define GST_IS_DEVICE_PROVIDER_CLASS(klass)      (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEVICE_PROVIDER))
#define GST_DEVICE_PROVIDER_GET_CLASS(obj)       (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEVICE_PROVIDER, GstDeviceProviderClass))
#define GST_DEVICE_PROVIDER(obj)                 (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEVICE_PROVIDER, GstDeviceProvider))
#define GST_DEVICE_PROVIDER_CLASS(klass)         (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEVICE_PROVIDER, GstDeviceProviderClass))
#define GST_DEVICE_PROVIDER_CAST(obj)            ((GstDeviceProvider *)(obj))


/**
 * GstDeviceProvider:
 * @parent: The parent #GstObject
 * @devices: a #GList of the #GstDevice objects
 *
 * The structure of the base #GstDeviceProvider
 *
 * Since: 1.4
 */
struct _GstDeviceProvider {
  GstObject         parent;

  /* Protected by the Object lock */
  GList *devices;

  /*< private >*/

  GstDeviceProviderPrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};

/**
 * GstDeviceProviderClass:
 * @parent_class: the parent #GstObjectClass structure
 * @factory: a pointer to the #GstDeviceProviderFactory that creates this
 *  provider
 * @probe: Returns a list of devices that are currently available.
 *  This should never block.
 * @start: Starts monitoring for new devices. Only subclasses that can know
 *  that devices have been added or remove need to implement this method.
 * @stop: Stops monitoring for new devices. Only subclasses that implement
 *  the start() method need to implement this method.
 *
 * The structure of the base #GstDeviceProviderClass
 *
 * Since: 1.4
 */

struct _GstDeviceProviderClass {
  GstObjectClass    parent_class;

  GstDeviceProviderFactory     *factory;

  GList*      (*probe) (GstDeviceProvider * provider);

  gboolean    (*start) (GstDeviceProvider * provider);
  void        (*stop)  (GstDeviceProvider * provider);

  /*< private >*/
  gpointer metadata;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

GType       gst_device_provider_get_type (void);


GList *     gst_device_provider_get_devices    (GstDeviceProvider * provider);

gboolean    gst_device_provider_start          (GstDeviceProvider * provider);
void        gst_device_provider_stop           (GstDeviceProvider * provider);

gboolean    gst_device_provider_can_monitor    (GstDeviceProvider * provider);

GstBus *    gst_device_provider_get_bus        (GstDeviceProvider * provider);

void        gst_device_provider_device_add     (GstDeviceProvider * provider,
                                               GstDevice * device);
void        gst_device_provider_device_remove  (GstDeviceProvider * provider,
                                               GstDevice * device);


/* device provider class meta data */
void        gst_device_provider_class_set_metadata          (GstDeviceProviderClass *klass,
                                                            const gchar     *longname,
                                                            const gchar     *classification,
                                                            const gchar     *description,
                                                            const gchar     *author);
void        gst_device_provider_class_set_static_metadata   (GstDeviceProviderClass *klass,
                                                            const gchar     *longname,
                                                            const gchar     *classification,
                                                            const gchar     *description,
                                                            const gchar     *author);
void        gst_device_provider_class_add_metadata          (GstDeviceProviderClass * klass,
                                                            const gchar * key, const gchar * value);
void        gst_device_provider_class_add_static_metadata   (GstDeviceProviderClass * klass,
                                                            const gchar * key, const gchar * value);
const gchar * gst_device_provider_class_get_metadata        (GstDeviceProviderClass * klass,
                                                              const gchar * key);

/* factory management */
GstDeviceProviderFactory * gst_device_provider_get_factory   (GstDeviceProvider * provider);

G_END_DECLS

#endif /* __GST_DEVICE_PROVIDER_H__ */
