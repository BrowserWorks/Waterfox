/* GStreamer
 * Copyright (C) 2012 Olivier Crete <olivier.crete@collabora.com>
 *
 * gstdeviceprovider.c: Device probing and monitoring
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

/**
 * SECTION:gstdeviceprovider
 * @short_description: A device provider
 * @see_also: #GstDevice, #GstDeviceMonitor
 *
 * A #GstDeviceProvider subclass is provided by a plugin that handles devices
 * if there is a way to programatically list connected devices. It can also
 * optionally provide updates to the list of connected devices.
 *
 * Each #GstDeviceProvider subclass is a singleton, a plugin should
 * normally provide a single subclass for all devices.
 *
 * Applications would normally use a #GstDeviceMonitor to monitor devices
 * from all relevant providers.
 *
 * Since: 1.4
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"

#include "gstdeviceprovider.h"

#include "gstelementmetadata.h"
#include "gstquark.h"

struct _GstDeviceProviderPrivate
{
  GstBus *bus;

  GMutex start_lock;

  gboolean started_count;
};

/* this is used in gstelementfactory.c:gst_element_register() */
GQuark __gst_deviceproviderclass_factory = 0;

static void gst_device_provider_class_init (GstDeviceProviderClass * klass);
static void gst_device_provider_init (GstDeviceProvider * element);
static void gst_device_provider_base_class_init (gpointer g_class);
static void gst_device_provider_base_class_finalize (gpointer g_class);
static void gst_device_provider_dispose (GObject * object);
static void gst_device_provider_finalize (GObject * object);

static gpointer gst_device_provider_parent_class = NULL;

GType
gst_device_provider_get_type (void)
{
  static volatile gsize gst_device_provider_type = 0;

  if (g_once_init_enter (&gst_device_provider_type)) {
    GType _type;
    static const GTypeInfo element_info = {
      sizeof (GstDeviceProviderClass),
      gst_device_provider_base_class_init,
      gst_device_provider_base_class_finalize,
      (GClassInitFunc) gst_device_provider_class_init,
      NULL,
      NULL,
      sizeof (GstDeviceProvider),
      0,
      (GInstanceInitFunc) gst_device_provider_init,
      NULL
    };

    _type = g_type_register_static (GST_TYPE_OBJECT, "GstDeviceProvider",
        &element_info, G_TYPE_FLAG_ABSTRACT);

    __gst_deviceproviderclass_factory =
        g_quark_from_static_string ("GST_DEVICEPROVIDERCLASS_FACTORY");
    g_once_init_leave (&gst_device_provider_type, _type);
  }
  return gst_device_provider_type;
}

static void
gst_device_provider_base_class_init (gpointer g_class)
{
  GstDeviceProviderClass *klass = GST_DEVICE_PROVIDER_CLASS (g_class);

  /* Copy the element details here so elements can inherit the
   * details from their base class and classes only need to set
   * the details in class_init instead of base_init */
  klass->metadata =
      klass->metadata ? gst_structure_copy (klass->metadata) :
      gst_structure_new_empty ("metadata");

  klass->factory = g_type_get_qdata (G_TYPE_FROM_CLASS (klass),
      __gst_deviceproviderclass_factory);
}

static void
gst_device_provider_base_class_finalize (gpointer g_class)
{
  GstDeviceProviderClass *klass = GST_DEVICE_PROVIDER_CLASS (g_class);

  gst_structure_free (klass->metadata);
}

static void
gst_device_provider_class_init (GstDeviceProviderClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gst_device_provider_parent_class = g_type_class_peek_parent (klass);

  g_type_class_add_private (klass, sizeof (GstDeviceProviderPrivate));

  gobject_class->dispose = gst_device_provider_dispose;
  gobject_class->finalize = gst_device_provider_finalize;
}

static void
gst_device_provider_init (GstDeviceProvider * provider)
{
  provider->priv = G_TYPE_INSTANCE_GET_PRIVATE (provider,
      GST_TYPE_DEVICE_PROVIDER, GstDeviceProviderPrivate);

  g_mutex_init (&provider->priv->start_lock);

  provider->priv->bus = gst_bus_new ();
  gst_bus_set_flushing (provider->priv->bus, TRUE);
}


static void
gst_device_provider_dispose (GObject * object)
{
  GstDeviceProvider *provider = GST_DEVICE_PROVIDER (object);

  gst_object_replace ((GstObject **) & provider->priv->bus, NULL);

  GST_OBJECT_LOCK (provider);
  g_list_free_full (provider->devices, (GDestroyNotify) gst_object_unparent);
  provider->devices = NULL;
  GST_OBJECT_UNLOCK (provider);

  G_OBJECT_CLASS (gst_device_provider_parent_class)->dispose (object);
}

static void
gst_device_provider_finalize (GObject * object)
{
  GstDeviceProvider *provider = GST_DEVICE_PROVIDER (object);

  g_mutex_clear (&provider->priv->start_lock);

  G_OBJECT_CLASS (gst_device_provider_parent_class)->finalize (object);
}

/**
 * gst_device_provider_class_add_metadata:
 * @klass: class to set metadata for
 * @key: the key to set
 * @value: the value to set
 *
 * Set @key with @value as metadata in @klass.
 *
 * Since: 1.4
 */
void
gst_device_provider_class_add_metadata (GstDeviceProviderClass * klass,
    const gchar * key, const gchar * value)
{
  g_return_if_fail (GST_IS_DEVICE_PROVIDER_CLASS (klass));
  g_return_if_fail (key != NULL);
  g_return_if_fail (value != NULL);

  gst_structure_set ((GstStructure *) klass->metadata,
      key, G_TYPE_STRING, value, NULL);
}

/**
 * gst_device_provider_class_add_static_metadata:
 * @klass: class to set metadata for
 * @key: the key to set
 * @value: (transfer full): the value to set
 *
 * Set @key with @value as metadata in @klass.
 *
 * Same as gst_device_provider_class_add_metadata(), but @value must be a static string
 * or an inlined string, as it will not be copied. (GStreamer plugins will
 * be made resident once loaded, so this function can be used even from
 * dynamically loaded plugins.)
 *
 * Since: 1.4
 */
void
gst_device_provider_class_add_static_metadata (GstDeviceProviderClass * klass,
    const gchar * key, const gchar * value)
{
  GValue val = G_VALUE_INIT;

  g_return_if_fail (GST_IS_DEVICE_PROVIDER_CLASS (klass));
  g_return_if_fail (key != NULL);
  g_return_if_fail (value != NULL);

  g_value_init (&val, G_TYPE_STRING);
  g_value_set_static_string (&val, value);
  gst_structure_take_value ((GstStructure *) klass->metadata, key, &val);
}

/**
 * gst_device_provider_class_set_metadata:
 * @klass: class to set metadata for
 * @longname: The long English name of the device provider. E.g. "File Sink"
 * @classification: String describing the type of device provider, as an
 *  unordered list separated with slashes ('/'). See draft-klass.txt of the
 *  design docs
 * for more details and common types. E.g: "Sink/File"
 * @description: Sentence describing the purpose of the device provider.
 * E.g: "Write stream to a file"
 * @author: Name and contact details of the author(s). Use \n to separate
 * multiple author metadata. E.g: "Joe Bloggs &lt;joe.blogs at foo.com&gt;"
 *
 * Sets the detailed information for a #GstDeviceProviderClass.
 * <note>This function is for use in _class_init functions only.</note>
 *
 * Since: 1.4
 */
void
gst_device_provider_class_set_metadata (GstDeviceProviderClass * klass,
    const gchar * longname, const gchar * classification,
    const gchar * description, const gchar * author)
{
  g_return_if_fail (GST_IS_DEVICE_PROVIDER_CLASS (klass));
  g_return_if_fail (longname != NULL && *longname != '\0');
  g_return_if_fail (classification != NULL && *classification != '\0');
  g_return_if_fail (description != NULL && *description != '\0');
  g_return_if_fail (author != NULL && *author != '\0');

  gst_structure_id_set ((GstStructure *) klass->metadata,
      GST_QUARK (ELEMENT_METADATA_LONGNAME), G_TYPE_STRING, longname,
      GST_QUARK (ELEMENT_METADATA_KLASS), G_TYPE_STRING, classification,
      GST_QUARK (ELEMENT_METADATA_DESCRIPTION), G_TYPE_STRING, description,
      GST_QUARK (ELEMENT_METADATA_AUTHOR), G_TYPE_STRING, author, NULL);
}

/**
 * gst_device_provider_class_set_static_metadata:
 * @klass: class to set metadata for
 * @longname: (transfer full): The long English name of the element. E.g. "File Sink"
 * @classification: (transfer full): String describing the type of element, as
 * an unordered list separated with slashes ('/'). See draft-klass.txt of the
 * design docs for more details and common types. E.g: "Sink/File"
 * @description: (transfer full): Sentence describing the purpose of the
 * element.  E.g: "Write stream to a file"
 * @author: (transfer full): Name and contact details of the author(s). Use \n
 * to separate multiple author metadata. E.g: "Joe Bloggs &lt;joe.blogs at
 * foo.com&gt;"
 *
 * Sets the detailed information for a #GstDeviceProviderClass.
 * <note>This function is for use in _class_init functions only.</note>
 *
 * Same as gst_device_provider_class_set_metadata(), but @longname, @classification,
 * @description, and @author must be static strings or inlined strings, as
 * they will not be copied. (GStreamer plugins will be made resident once
 * loaded, so this function can be used even from dynamically loaded plugins.)
 *
 * Since: 1.4
 */
void
gst_device_provider_class_set_static_metadata (GstDeviceProviderClass * klass,
    const gchar * longname, const gchar * classification,
    const gchar * description, const gchar * author)
{
  GstStructure *s = (GstStructure *) klass->metadata;
  GValue val = G_VALUE_INIT;

  g_return_if_fail (GST_IS_DEVICE_PROVIDER_CLASS (klass));
  g_return_if_fail (longname != NULL && *longname != '\0');
  g_return_if_fail (classification != NULL && *classification != '\0');
  g_return_if_fail (description != NULL && *description != '\0');
  g_return_if_fail (author != NULL && *author != '\0');

  g_value_init (&val, G_TYPE_STRING);

  g_value_set_static_string (&val, longname);
  gst_structure_id_set_value (s, GST_QUARK (ELEMENT_METADATA_LONGNAME), &val);

  g_value_set_static_string (&val, classification);
  gst_structure_id_set_value (s, GST_QUARK (ELEMENT_METADATA_KLASS), &val);

  g_value_set_static_string (&val, description);
  gst_structure_id_set_value (s, GST_QUARK (ELEMENT_METADATA_DESCRIPTION),
      &val);

  g_value_set_static_string (&val, author);
  gst_structure_id_take_value (s, GST_QUARK (ELEMENT_METADATA_AUTHOR), &val);
}

/**
 * gst_device_provider_class_get_metadata:
 * @klass: class to get metadata for
 * @key: the key to get
 *
 * Get metadata with @key in @klass.
 *
 * Returns: the metadata for @key.
 *
 * Since: 1.4
 */
const gchar *
gst_device_provider_class_get_metadata (GstDeviceProviderClass * klass,
    const gchar * key)
{
  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER_CLASS (klass), NULL);
  g_return_val_if_fail (key != NULL, NULL);

  return gst_structure_get_string ((GstStructure *) klass->metadata, key);
}

/**
 * gst_device_provider_get_devices:
 * @provider: A #GstDeviceProvider
 *
 * Gets a list of devices that this provider understands. This may actually
 * probe the hardware if the provider is not currently started.
 *
 * Returns: (transfer full) (element-type GstDevice): a #GList of
 *   #GstDevice
 *
 * Since: 1.4
 */

GList *
gst_device_provider_get_devices (GstDeviceProvider * provider)
{
  GstDeviceProviderClass *klass;
  GList *devices = NULL;
  gboolean started;
  GList *item;

  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER (provider), NULL);
  klass = GST_DEVICE_PROVIDER_GET_CLASS (provider);

  g_mutex_lock (&provider->priv->start_lock);
  started = (provider->priv->started_count > 0);

  if (started) {
    GST_OBJECT_LOCK (provider);
    for (item = provider->devices; item; item = item->next)
      devices = g_list_prepend (devices, gst_object_ref (item->data));
    GST_OBJECT_UNLOCK (provider);
  } else if (klass->probe)
    devices = klass->probe (provider);

  g_mutex_unlock (&provider->priv->start_lock);

  return devices;
}

/**
 * gst_device_provider_start:
 * @provider: A #GstDeviceProvider
 *
 * Starts providering the devices. This will cause #GST_MESSAGE_DEVICE_ADDED
 * and #GST_MESSAGE_DEVICE_REMOVED messages to be posted on the provider's bus
 * when devices are added or removed from the system.
 *
 * Since the #GstDeviceProvider is a singleton,
 * gst_device_provider_start() may already have been called by another
 * user of the object, gst_device_provider_stop() needs to be called the same
 * number of times.
 *
 * Returns: %TRUE if the device providering could be started
 *
 * Since: 1.4
 */

gboolean
gst_device_provider_start (GstDeviceProvider * provider)
{
  GstDeviceProviderClass *klass;
  gboolean ret = FALSE;

  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER (provider), FALSE);
  klass = GST_DEVICE_PROVIDER_GET_CLASS (provider);

  g_mutex_lock (&provider->priv->start_lock);

  if (provider->priv->started_count > 0) {
    ret = TRUE;
    goto started;
  }

  if (klass->start)
    ret = klass->start (provider);

  if (ret) {
    provider->priv->started_count++;
    gst_bus_set_flushing (provider->priv->bus, FALSE);
  }

started:

  g_mutex_unlock (&provider->priv->start_lock);

  return ret;
}

/**
 * gst_device_provider_stop:
 * @provider: A #GstDeviceProvider
 *
 * Decreases the use-count by one. If the use count reaches zero, this
 * #GstDeviceProvider will stop providering the devices. This needs to be
 * called the same number of times that gst_device_provider_start() was called.
 *
 * Since: 1.4
 */

void
gst_device_provider_stop (GstDeviceProvider * provider)
{
  GstDeviceProviderClass *klass;

  g_return_if_fail (GST_IS_DEVICE_PROVIDER (provider));
  klass = GST_DEVICE_PROVIDER_GET_CLASS (provider);

  g_mutex_lock (&provider->priv->start_lock);

  if (provider->priv->started_count == 1) {
    gst_bus_set_flushing (provider->priv->bus, TRUE);
    if (klass->stop)
      klass->stop (provider);
    GST_OBJECT_LOCK (provider);
    g_list_free_full (provider->devices, (GDestroyNotify) gst_object_unparent);
    provider->devices = NULL;
    GST_OBJECT_UNLOCK (provider);
  } else if (provider->priv->started_count < 1) {
    g_critical
        ("Trying to stop a GstDeviceProvider %s which is already stopped",
        GST_OBJECT_NAME (provider));
  }

  provider->priv->started_count--;
  g_mutex_unlock (&provider->priv->start_lock);
}


/**
 * gst_device_provider_get_factory:
 * @provider: a #GstDeviceProvider to request the device provider factory of.
 *
 * Retrieves the factory that was used to create this device provider.
 *
 * Returns: (transfer none): the #GstDeviceProviderFactory used for
 *     creating this device provider. no refcounting is needed.
 *
 * Since: 1.4
 */
GstDeviceProviderFactory *
gst_device_provider_get_factory (GstDeviceProvider * provider)
{
  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER (provider), NULL);

  return GST_DEVICE_PROVIDER_GET_CLASS (provider)->factory;
}

/**
 * gst_device_provider_can_provider:
 * @provider: a #GstDeviceProvider
 *
 * If this function returns %TRUE, then the device provider can provider if
 * devices are added or removed. Otherwise, it can only do static probing.
 *
 * Returns: %TRUE if the #GstDeviceProvider support providering, %FALSE otherwise
 */
gboolean
gst_device_provider_can_monitor (GstDeviceProvider * provider)
{
  GstDeviceProviderClass *klass;

  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER (provider), FALSE);
  klass = GST_DEVICE_PROVIDER_GET_CLASS (provider);

  if (klass->start)
    return TRUE;
  else
    return FALSE;
}

/**
 * gst_device_provider_get_bus:
 * @provider: a #GstDeviceProvider
 *
 * Gets the #GstBus of this #GstDeviceProvider
 *
 * Returns: (transfer full): a #GstBus
 *
 * Since: 1.4
 */
GstBus *
gst_device_provider_get_bus (GstDeviceProvider * provider)
{
  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER (provider), NULL);

  return gst_object_ref (provider->priv->bus);
}

/**
 * gst_device_provider_device_add:
 * @provider: a #GstDeviceProvider
 * @device: (transfer full): a #GstDevice that has been added
 *
 * Posts a message on the provider's #GstBus to inform applications that
 * a new device has been added.
 *
 * This is for use by subclasses.
 *
 * Since: 1.4
 */
void
gst_device_provider_device_add (GstDeviceProvider * provider,
    GstDevice * device)
{
  GstMessage *message;

  if (!gst_object_set_parent (GST_OBJECT (device), GST_OBJECT (provider))) {
    GST_WARNING_OBJECT (provider, "Could not parent device %p to provider,"
        " it already has a parent", device);
    return;
  }

  GST_OBJECT_LOCK (provider);
  provider->devices = g_list_prepend (provider->devices,
      gst_object_ref (device));
  GST_OBJECT_UNLOCK (provider);

  message = gst_message_new_device_added (GST_OBJECT (provider), device);
  gst_bus_post (provider->priv->bus, message);
  gst_object_unref (device);
}


/**
 * gst_device_provider_device_remove:
 * @provider: a #GstDeviceProvider
 * @device: a #GstDevice that has been removed
 *
 * Posts a message on the provider's #GstBus to inform applications that
 * a device has been removed.
 *
 * This is for use by subclasses.
 *
 * Since: 1.4
 */
void
gst_device_provider_device_remove (GstDeviceProvider * provider,
    GstDevice * device)
{
  GstMessage *message;
  GList *item;

  GST_OBJECT_LOCK (provider);
  item = g_list_find (provider->devices, device);
  if (item) {
    provider->devices = g_list_delete_link (provider->devices, item);
  }
  GST_OBJECT_UNLOCK (provider);

  message = gst_message_new_device_removed (GST_OBJECT (provider), device);
  g_signal_emit_by_name (device, "removed");
  gst_bus_post (provider->priv->bus, message);
  if (item)
    gst_object_unparent (GST_OBJECT (device));
}
