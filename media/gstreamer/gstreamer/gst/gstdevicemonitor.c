/* GStreamer
 * Copyright (C) 2013 Olivier Crete <olivier.crete@collabora.com>
 *
 * gstdevicemonitor.c: device monitor
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
 * SECTION:gstdevicemonitor
 * @short_description: A device monitor and prober
 * @see_also: #GstDevice, #GstDeviceProvider
 *
 * Applications should create a #GstDeviceMonitor when they want
 * to probe, list and monitor devices of a specific type. The
 * #GstDeviceMonitor will create the appropriate
 * #GstDeviceProvider objects and manage them. It will then post
 * messages on its #GstBus for devices that have been added and
 * removed.
 *
 * The device monitor will monitor all devices matching the filters that
 * the application has set.
 *
 *
 * The basic use pattern of a device monitor is as follows:
 * |[
 *   static gboolean
 *   my_bus_func (GstBus * bus, GstMessage * message, gpointer user_data)
 *   {
 *      GstDevice *device;
 *      gchar name;
 *
 *      switch (GST_MESSAGE_TYPE (message)) {
 *        case GST_MESSAGE_DEVICE_ADDED:
 *          gst_message_parse_device_added (message, &device);
 *          name = gst_device_get_display_name (device);
 *          g_print("Device added: %s\n", name);
 *          g_free (name);
 *          break;
 *        case GST_MESSAGE_DEVICE_REMOVED:
 *          gst_message_parse_device_removed (message, &device);
 *          name = gst_device_get_display_name (device);
 *          g_print("Device removed: %s\n", name);
 *          g_free (name);
 *          break;
 *        default:
 *          break;
 *      }
 *
 *      return G_SOURCE_CONTINUE;
 *   }
 *
 *   GstDeviceMonitor *
 *   setup_raw_video_source_device_monitor (void) {
 *      GstDeviceMonitor *monitor;
 *      GstBus *bus;
 *      GstCaps *caps;
 *
 *      monitor = gst_device_monitor_new ();
 *
 *      bus = gst_device_monitor_get_bus (monitor);
 *      gst_bus_add_watch (bus, my_bus_func, NULL);
 *      gst_object_unref (bus);
 *
 *      caps = gst_caps_new_simple_empty ("video/x-raw");
 *      gst_device_monitor_add_filter (monitor, "Video/Source", caps);
 *      gst_caps_unref (caps);
 *
 *      gst_device_monitor_start (monitor);
 *
 *      return monitor;
 *   }
 * ]|
 *
 * Since: 1.4
 */


#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include "gstdevicemonitor.h"

struct _GstDeviceMonitorPrivate
{
  gboolean started;

  GstBus *bus;

  GPtrArray *providers;
  guint cookie;

  GPtrArray *filters;

  guint last_id;
};


G_DEFINE_TYPE (GstDeviceMonitor, gst_device_monitor, GST_TYPE_OBJECT);

static void gst_device_monitor_dispose (GObject * object);

struct DeviceFilter
{
  guint id;

  gchar **classesv;
  GstCaps *caps;
};

static void
device_filter_free (struct DeviceFilter *filter)
{
  g_strfreev (filter->classesv);
  gst_caps_unref (filter->caps);

  g_slice_free (struct DeviceFilter, filter);
}

static void
gst_device_monitor_class_init (GstDeviceMonitorClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);

  g_type_class_add_private (klass, sizeof (GstDeviceMonitorPrivate));

  object_class->dispose = gst_device_monitor_dispose;
}

static void
bus_sync_message (GstBus * bus, GstMessage * message,
    GstDeviceMonitor * monitor)
{
  GstMessageType type = GST_MESSAGE_TYPE (message);

  if (type == GST_MESSAGE_DEVICE_ADDED || type == GST_MESSAGE_DEVICE_REMOVED) {
    gboolean matches;
    GstDevice *device;

    if (type == GST_MESSAGE_DEVICE_ADDED)
      gst_message_parse_device_added (message, &device);
    else
      gst_message_parse_device_removed (message, &device);

    GST_OBJECT_LOCK (monitor);
    if (monitor->priv->filters->len) {
      guint i;

      for (i = 0; i < monitor->priv->filters->len; i++) {
        struct DeviceFilter *filter =
            g_ptr_array_index (monitor->priv->filters, i);
        GstCaps *caps;

        caps = gst_device_get_caps (device);
        matches = gst_caps_can_intersect (filter->caps, caps) &&
            gst_device_has_classesv (device, filter->classesv);
        gst_caps_unref (caps);
        if (matches)
          break;
      }
    } else {
      matches = TRUE;
    }
    GST_OBJECT_UNLOCK (monitor);

    gst_object_unref (device);

    if (matches)
      gst_bus_post (monitor->priv->bus, gst_message_ref (message));
  }
}


static void
gst_device_monitor_init (GstDeviceMonitor * self)
{
  self->priv = G_TYPE_INSTANCE_GET_PRIVATE (self,
      GST_TYPE_DEVICE_MONITOR, GstDeviceMonitorPrivate);

  self->priv->bus = gst_bus_new ();
  gst_bus_set_flushing (self->priv->bus, TRUE);

  self->priv->providers = g_ptr_array_new ();
  self->priv->filters = g_ptr_array_new_with_free_func (
      (GDestroyNotify) device_filter_free);

  self->priv->last_id = 1;
}


static void
gst_device_monitor_remove (GstDeviceMonitor * self, guint i)
{
  GstDeviceProvider *provider = g_ptr_array_index (self->priv->providers, i);
  GstBus *bus;

  g_ptr_array_remove_index_fast (self->priv->providers, i);

  bus = gst_device_provider_get_bus (provider);
  g_signal_handlers_disconnect_by_func (bus, bus_sync_message, self);
  gst_object_unref (bus);

  gst_object_unref (provider);
}

static void
gst_device_monitor_dispose (GObject * object)
{
  GstDeviceMonitor *self = GST_DEVICE_MONITOR (object);

  g_return_if_fail (self->priv->started == FALSE);

  if (self->priv->providers) {
    while (self->priv->providers->len)
      gst_device_monitor_remove (self, self->priv->providers->len - 1);
    g_ptr_array_unref (self->priv->providers);
    self->priv->providers = NULL;
  }

  if (self->priv->filters) {
    g_ptr_array_unref (self->priv->filters);
    self->priv->filters = NULL;
  }

  gst_object_replace ((GstObject **) & self->priv->bus, NULL);

  G_OBJECT_CLASS (gst_device_monitor_parent_class)->dispose (object);
}

/**
 * gst_device_monitor_get_devices:
 * @monitor: A #GstDeviceProvider
 *
 * Gets a list of devices from all of the relevant monitors. This may actually
 * probe the hardware if the monitor is not currently started.
 *
 * Returns: (transfer full) (element-type GstDevice): a #GList of
 *   #GstDevice
 *
 * Since: 1.4
 */

GList *
gst_device_monitor_get_devices (GstDeviceMonitor * monitor)
{
  GList *devices = NULL;
  guint i;
  guint cookie;

  g_return_val_if_fail (GST_IS_DEVICE_MONITOR (monitor), NULL);

  GST_OBJECT_LOCK (monitor);

  if (monitor->priv->filters->len == 0) {
    GST_OBJECT_UNLOCK (monitor);
    GST_WARNING_OBJECT (monitor, "No filters have been set");
    return FALSE;
  }

  if (monitor->priv->providers->len == 0) {
    GST_OBJECT_UNLOCK (monitor);
    GST_WARNING_OBJECT (monitor, "No providers match the current filters");
    return FALSE;
  }

again:

  g_list_free_full (devices, gst_object_unref);
  devices = NULL;

  cookie = monitor->priv->cookie;

  for (i = 0; i < monitor->priv->providers->len; i++) {
    GList *tmpdev;
    GstDeviceProvider *provider =
        gst_object_ref (g_ptr_array_index (monitor->priv->providers, i));
    GList *item;

    GST_OBJECT_UNLOCK (monitor);

    tmpdev = gst_device_provider_get_devices (provider);

    GST_OBJECT_LOCK (monitor);

    for (item = tmpdev; item; item = item->next) {
      GstDevice *dev = GST_DEVICE (item->data);
      GstCaps *caps = gst_device_get_caps (dev);
      guint j;

      for (j = 0; j < monitor->priv->filters->len; j++) {
        struct DeviceFilter *filter =
            g_ptr_array_index (monitor->priv->filters, j);
        if (gst_caps_can_intersect (filter->caps, caps) &&
            gst_device_has_classesv (dev, filter->classesv)) {
          devices = g_list_prepend (devices, gst_object_ref (dev));
          break;
        }
      }
      gst_caps_unref (caps);
    }

    g_list_free_full (tmpdev, gst_object_unref);
    gst_object_unref (provider);


    if (monitor->priv->cookie != cookie)
      goto again;
  }

  GST_OBJECT_UNLOCK (monitor);

  return devices;
}

/**
 * gst_device_monitor_start:
 * @monitor: A #GstDeviceMonitor
 *
 * Starts monitoring the devices, one this has succeeded, the
 * %GST_MESSAGE_DEVICE_ADDED and %GST_MESSAGE_DEVICE_REMOVED messages
 * will be emitted on the bus when the list of devices changes.
 *
 * Returns: %TRUE if the device monitoring could be started
 *
 * Since: 1.4
 */

gboolean
gst_device_monitor_start (GstDeviceMonitor * monitor)
{
  guint i;

  g_return_val_if_fail (GST_IS_DEVICE_MONITOR (monitor), FALSE);

  GST_OBJECT_LOCK (monitor);

  if (monitor->priv->filters->len == 0) {
    GST_OBJECT_UNLOCK (monitor);
    GST_WARNING_OBJECT (monitor, "No filters have been set, will expose all "
        "devices found");
    gst_device_monitor_add_filter (monitor, NULL, NULL);
    GST_OBJECT_LOCK (monitor);
  }

  if (monitor->priv->providers->len == 0) {
    GST_OBJECT_UNLOCK (monitor);
    GST_WARNING_OBJECT (monitor, "No providers match the current filters");
    return FALSE;
  }

  gst_bus_set_flushing (monitor->priv->bus, FALSE);

  for (i = 0; i < monitor->priv->providers->len; i++) {
    GstDeviceProvider *provider =
        g_ptr_array_index (monitor->priv->providers, i);

    if (gst_device_provider_can_monitor (provider)) {
      if (!gst_device_provider_start (provider)) {
        gst_bus_set_flushing (monitor->priv->bus, TRUE);

        for (; i != 0; i--)
          gst_device_provider_stop (g_ptr_array_index (monitor->priv->providers,
                  i - 1));

        GST_OBJECT_UNLOCK (monitor);
        return FALSE;
      }
    }
  }

  monitor->priv->started = TRUE;
  GST_OBJECT_UNLOCK (monitor);

  return TRUE;
}

/**
 * gst_device_monitor_stop:
 * @monitor: A #GstDeviceProvider
 *
 * Stops monitoring the devices.
 *
 * Since: 1.4
 */
void
gst_device_monitor_stop (GstDeviceMonitor * monitor)
{
  guint i;

  g_return_if_fail (GST_IS_DEVICE_MONITOR (monitor));

  gst_bus_set_flushing (monitor->priv->bus, TRUE);

  GST_OBJECT_LOCK (monitor);
  for (i = 0; i < monitor->priv->providers->len; i++) {
    GstDeviceProvider *provider =
        g_ptr_array_index (monitor->priv->providers, i);

    if (gst_device_provider_can_monitor (provider))
      gst_device_provider_stop (provider);
  }
  monitor->priv->started = FALSE;
  GST_OBJECT_UNLOCK (monitor);

}

/**
 * gst_device_monitor_add_filter:
 * @monitor: a device monitor
 * @classes: (allow-none): device classes to use as filter or %NULL for any class
 * @caps: (allow-none): the #GstCaps to filter or %NULL for ANY
 *
 * Adds a filter for which #GstDevice will be monitored, any device that matches
 * all classes and the #GstCaps will be returned.
 *
 * Filters must be added before the #GstDeviceMonitor is started.
 *
 * Returns: The id of the new filter or %0 if no provider matched the filter's
 *  classes.
 *
 * Since: 1.4
 */
guint
gst_device_monitor_add_filter (GstDeviceMonitor * monitor,
    const gchar * classes, GstCaps * caps)
{
  GList *factories = NULL;
  struct DeviceFilter *filter;
  guint id = 0;
  gboolean matched = FALSE;

  g_return_val_if_fail (GST_IS_DEVICE_MONITOR (monitor), 0);
  g_return_val_if_fail (!monitor->priv->started, 0);

  GST_OBJECT_LOCK (monitor);

  filter = g_slice_new0 (struct DeviceFilter);
  filter->id = monitor->priv->last_id++;
  if (caps)
    filter->caps = gst_caps_ref (caps);
  else
    filter->caps = gst_caps_new_any ();
  if (classes)
    filter->classesv = g_strsplit (classes, "/", 0);

  factories = gst_device_provider_factory_list_get_device_providers (1);

  while (factories) {
    GstDeviceProviderFactory *factory = factories->data;


    if (gst_device_provider_factory_has_classesv (factory, filter->classesv)) {
      GstDeviceProvider *provider;

      provider = gst_device_provider_factory_get (factory);

      if (provider) {
        guint i;

        for (i = 0; i < monitor->priv->providers->len; i++) {
          if (g_ptr_array_index (monitor->priv->providers, i) == provider) {
            gst_object_unref (provider);
            provider = NULL;
            matched = TRUE;
            break;
          }
        }
      }

      if (provider) {
        GstBus *bus = gst_device_provider_get_bus (provider);

        matched = TRUE;
        gst_bus_enable_sync_message_emission (bus);
        g_signal_connect (bus, "sync-message",
            G_CALLBACK (bus_sync_message), monitor);
        gst_object_unref (bus);
        g_ptr_array_add (monitor->priv->providers, provider);
        monitor->priv->cookie++;
      }
    }

    factories = g_list_remove (factories, factory);
    gst_object_unref (factory);
  }

  /* Ensure there is no leak here */
  g_assert (factories == NULL);

  if (matched) {
    id = filter->id;
    g_ptr_array_add (monitor->priv->filters, filter);
  } else {
    device_filter_free (filter);
  }

  GST_OBJECT_UNLOCK (monitor);

  return id;
}

/**
 * gst_device_monitor_remove_filter:
 * @monitor: a device monitor
 * @filter_id: the id of the filter
 *
 * Removes a filter from the #GstDeviceMonitor using the id that was returned
 * by gst_device_monitor_add_filter().
 *
 * Returns: %TRUE of the filter id was valid, %FALSE otherwise
 *
 * Since: 1.4
 */
gboolean
gst_device_monitor_remove_filter (GstDeviceMonitor * monitor, guint filter_id)
{
  guint i, j;
  gboolean removed = FALSE;

  g_return_val_if_fail (GST_IS_DEVICE_MONITOR (monitor), FALSE);
  g_return_val_if_fail (!monitor->priv->started, FALSE);
  g_return_val_if_fail (filter_id > 0, FALSE);

  GST_OBJECT_LOCK (monitor);
  for (i = 0; i < monitor->priv->filters->len; i++) {
    struct DeviceFilter *filter = g_ptr_array_index (monitor->priv->filters, i);

    if (filter->id == filter_id) {
      g_ptr_array_remove_index (monitor->priv->filters, i);
      removed = TRUE;
      break;
    }
  }

  if (removed) {
    for (i = 0; i < monitor->priv->providers->len; i++) {
      GstDeviceProvider *provider =
          g_ptr_array_index (monitor->priv->providers, i);
      GstDeviceProviderFactory *factory =
          gst_device_provider_get_factory (provider);
      gboolean valid = FALSE;

      for (j = 0; j < monitor->priv->filters->len; j++) {
        struct DeviceFilter *filter =
            g_ptr_array_index (monitor->priv->filters, j);

        if (gst_device_provider_factory_has_classesv (factory,
                filter->classesv)) {
          valid = TRUE;
          break;
        }
      }

      if (!valid) {
        monitor->priv->cookie++;
        gst_device_monitor_remove (monitor, i);
        i--;
      }
    }
  }

  GST_OBJECT_UNLOCK (monitor);

  return removed;
}



/**
 * gst_device_monitor_new:
 *
 * Create a new #GstDeviceMonitor
 *
 * Returns: (transfer full): a new device monitor.
 *
 * Since: 1.4
 */
GstDeviceMonitor *
gst_device_monitor_new (void)
{
  return g_object_new (GST_TYPE_DEVICE_MONITOR, NULL);
}

/**
 * gst_device_monitor_get_bus:
 * @monitor: a #GstDeviceProvider
 *
 * Gets the #GstBus of this #GstDeviceMonitor
 *
 * Returns: (transfer full): a #GstBus
 *
 * Since: 1.4
 */
GstBus *
gst_device_monitor_get_bus (GstDeviceMonitor * monitor)
{
  g_return_val_if_fail (GST_IS_DEVICE_MONITOR (monitor), NULL);

  return gst_object_ref (monitor->priv->bus);
}
