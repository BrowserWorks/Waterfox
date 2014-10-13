/* GStreamer
 * Copyright (C) 2012 Olivier Crete <olivier.crete@collabora.com>
 *
 * gstdevice.c: Device discovery
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
 * SECTION:gstdevice
 * @short_description: Object representing a device
 * @see_also: #GstDeviceProvider
 *
 * #GstDevice are objects representing a device, they contain
 * relevant metadata about the device, such as its class and the #GstCaps
 * representing the media types it can produce or handle.
 *
 * #GstDevice are created by #GstDeviceProvider objects which can be
 * aggregated by #GstDeviceMonitor objects.
 *
 * Since: 1.4
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"

#include "gstdevice.h"

enum
{
  PROP_DISPLAY_NAME = 1,
  PROP_CAPS,
  PROP_DEVICE_CLASS
};

enum
{
  REMOVED,
  LAST_SIGNAL
};

struct _GstDevicePrivate
{
  GstCaps *caps;
  gchar *device_class;
  gchar *display_name;
};


static guint signals[LAST_SIGNAL];

G_DEFINE_ABSTRACT_TYPE (GstDevice, gst_device, GST_TYPE_OBJECT);

static void gst_device_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec);
static void gst_device_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec);
static void gst_device_finalize (GObject * object);


static void
gst_device_class_init (GstDeviceClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);

  g_type_class_add_private (klass, sizeof (GstDevicePrivate));

  object_class->get_property = gst_device_get_property;
  object_class->set_property = gst_device_set_property;
  object_class->finalize = gst_device_finalize;

  g_object_class_install_property (object_class, PROP_DISPLAY_NAME,
      g_param_spec_string ("display-name", "Display Name",
          "The user-friendly name of the device", "",
          G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY));
  g_object_class_install_property (object_class, PROP_CAPS,
      g_param_spec_boxed ("caps", "Device Caps",
          "The possible caps of a device", GST_TYPE_CAPS,
          G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY));
  g_object_class_install_property (object_class, PROP_DEVICE_CLASS,
      g_param_spec_string ("device-class", "Device Class",
          "The Class of the device", "",
          G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY));

  signals[REMOVED] = g_signal_new ("removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, NULL, G_TYPE_NONE, 0);
}

static void
gst_device_init (GstDevice * device)
{
  device->priv = G_TYPE_INSTANCE_GET_PRIVATE (device, GST_TYPE_DEVICE,
      GstDevicePrivate);
}

static void
gst_device_finalize (GObject * object)
{
  GstDevice *device = GST_DEVICE (object);

  gst_caps_replace (&device->priv->caps, NULL);

  g_free (device->priv->display_name);
  g_free (device->priv->device_class);

  G_OBJECT_CLASS (gst_device_parent_class)->finalize (object);
}

static void
gst_device_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDevice *gstdevice;

  gstdevice = GST_DEVICE_CAST (object);

  switch (prop_id) {
    case PROP_DISPLAY_NAME:
      g_value_take_string (value, gst_device_get_display_name (gstdevice));
      break;
    case PROP_CAPS:
      if (gstdevice->priv->caps)
        g_value_take_boxed (value, gst_device_get_caps (gstdevice));
      break;
    case PROP_DEVICE_CLASS:
      g_value_take_string (value, gst_device_get_device_class (gstdevice));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}


static void
gst_device_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDevice *gstdevice;

  gstdevice = GST_DEVICE_CAST (object);

  switch (prop_id) {
    case PROP_DISPLAY_NAME:
      gstdevice->priv->display_name = g_value_dup_string (value);
      break;
    case PROP_CAPS:
      gst_caps_replace (&gstdevice->priv->caps, g_value_get_boxed (value));
      break;
    case PROP_DEVICE_CLASS:
      gstdevice->priv->device_class = g_value_dup_string (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/**
 * gst_device_create_element:
 * @device: a #GstDevice
 * @name: (allow-none): name of new element, or %NULL to automatically
 * create a unique name.
 *
 * Creates the element with all of the required paramaters set to use
 * this device.
 *
 * Returns: (transfer full): a new #GstElement configured to use this device
 *
 * Since: 1.4
 */
GstElement *
gst_device_create_element (GstDevice * device, const gchar * name)
{
  GstDeviceClass *klass = GST_DEVICE_GET_CLASS (device);

  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  if (klass->create_element)
    return klass->create_element (device, name);
  else
    return NULL;
}

/**
 * gst_device_get_caps:
 * @device: a #GstDevice
 *
 * Getter for the #GstCaps that this device supports.
 *
 * Returns: The #GstCaps supported by this device. Unref with
 * gst_caps_unref() when done.
 *
 * Since: 1.4
 */
GstCaps *
gst_device_get_caps (GstDevice * device)
{
  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  if (device->priv->caps)
    return gst_caps_ref (device->priv->caps);
  else
    return NULL;
}

/**
 * gst_device_get_display_name:
 * @device: a #GstDevice
 *
 * Gets the user-friendly name of the device.
 *
 * Returns: The device name. Free with g_free() after use.
 *
 * Since: 1.4
 */
gchar *
gst_device_get_display_name (GstDevice * device)
{
  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  return
      g_strdup (device->priv->display_name ? device->priv->display_name : "");
}

/**
 * gst_device_get_device_class:
 * @device: a #GstDevice
 *
 * Gets the "class" of a device. This is a "/" separated list of
 * classes that represent this device. They are a subset of the
 * classes of the #GstDeviceProvider that produced this device.
 *
 * Returns: The device class. Free with g_free() after use.
 *
 * Since: 1.4
 */
gchar *
gst_device_get_device_class (GstDevice * device)
{
  g_return_val_if_fail (GST_IS_DEVICE (device), NULL);

  if (device->priv->device_class != NULL)
    return g_strdup (device->priv->device_class);
  else
    return g_strdup ("");
}

/**
 * gst_device_reconfigure_element:
 * @device: a #GstDevice
 * @element: a #GstElement
 *
 * Tries to reconfigure an existing element to use the device. If this
 * function fails, then one must destroy the element and create a new one
 * using gst_device_create_element().
 *
 * Note: This should only be implemented for elements can change their
 * device in the PLAYING state.
 *
 * Returns: %TRUE if the element could be reconfigured to use this device,
 * %FALSE otherwise.
 *
 * Since: 1.4
 */
gboolean
gst_device_reconfigure_element (GstDevice * device, GstElement * element)
{
  GstDeviceClass *klass = GST_DEVICE_GET_CLASS (device);

  g_return_val_if_fail (GST_IS_DEVICE (device), FALSE);

  if (klass->reconfigure_element)
    return klass->reconfigure_element (device, element);
  else
    return FALSE;
}

/**
 * gst_device_has_classesv:
 * @device: a #GstDevice
 * @classes: (array zero-terminated=1): a %NULL terminated array of classes to match, only match if all
 *   classes are matched
 *
 * Check if @factory matches all of the given classes
 *
 * Returns: %TRUE if @device matches.
 *
 * Since: 1.4
 */
gboolean
gst_device_has_classesv (GstDevice * device, gchar ** classes)
{
  g_return_val_if_fail (GST_IS_DEVICE (device), FALSE);

  if (!classes)
    return TRUE;

  for (; classes[0]; classes++) {
    const gchar *found;
    guint len;

    if (classes[0] == '\0')
      continue;

    found = strstr (device->priv->device_class, classes[0]);

    if (!found)
      return FALSE;
    if (found != device->priv->device_class && *(found - 1) != '/')
      return FALSE;

    len = strlen (classes[0]);
    if (found[len] != 0 && found[len] != '/')
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_device_has_classes:
 * @device: a #GstDevice
 * @classes: a "/" separate list of device classes to match, only match if
 *  all classes are matched
 *
 * Check if @device matches all of the given classes
 *
 * Returns: %TRUE if @device matches.
 *
 * Since: 1.4
 */
gboolean
gst_device_has_classes (GstDevice * device, const gchar * classes)
{
  gchar **classesv;
  gboolean res;

  g_return_val_if_fail (GST_IS_DEVICE (device), FALSE);

  if (!classes)
    return TRUE;

  classesv = g_strsplit (classes, "/", 0);

  res = gst_device_has_classesv (device, classesv);

  g_strfreev (classesv);

  return res;
}
