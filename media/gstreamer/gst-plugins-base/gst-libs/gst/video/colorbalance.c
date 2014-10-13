/* GStreamer Color Balance
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * colorbalance.c: image color balance interface design
 *                 virtual class function wrappers
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

#include "colorbalance.h"

/**
 * SECTION:gstcolorbalance
 * @short_description: Interface for adjusting color balance settings
 *
 * <refsect2><para>
 * This interface is implemented by elements which can perform some color
 * balance operation on video frames they process. For example, modifying
 * the brightness, contrast, hue or saturation.
 * </para><para>
 * Example elements are 'xvimagesink' and 'colorbalance'
 * </para>
 * </refsect2>
 */

/* FIXME 0.11: check if we need to add API for sometimes-supportedness
 * (aka making up for GstImplementsInterface removal) */

/* FIXME 0.11: replace signals with messages (+ make API thread-safe) */

enum
{
  VALUE_CHANGED,
  LAST_SIGNAL
};

static void gst_color_balance_base_init (GstColorBalanceInterface * iface);

static guint gst_color_balance_signals[LAST_SIGNAL] = { 0 };

GType
gst_color_balance_get_type (void)
{
  static GType gst_color_balance_type = 0;

  if (!gst_color_balance_type) {
    static const GTypeInfo gst_color_balance_info = {
      sizeof (GstColorBalanceInterface),
      (GBaseInitFunc) gst_color_balance_base_init,
      NULL,
      NULL,
      NULL,
      NULL,
      0,
      0,
      NULL,
    };

    gst_color_balance_type = g_type_register_static (G_TYPE_INTERFACE,
        "GstColorBalance", &gst_color_balance_info, 0);
  }

  return gst_color_balance_type;
}

static void
gst_color_balance_base_init (GstColorBalanceInterface * iface)
{
  static gboolean initialized = FALSE;

  if (!initialized) {
    /**
     * GstColorBalance::value-changed:
     * @colorbalance: The GstColorBalance instance
     * @channel: The #GstColorBalanceChannel
     * @value: The new value
     *
     * Fired when the value of the indicated channel has changed.
     */
    gst_color_balance_signals[VALUE_CHANGED] =
        g_signal_new ("value-changed",
        GST_TYPE_COLOR_BALANCE, G_SIGNAL_RUN_LAST,
        G_STRUCT_OFFSET (GstColorBalanceInterface, value_changed),
        NULL, NULL, NULL,
        G_TYPE_NONE, 2, GST_TYPE_COLOR_BALANCE_CHANNEL, G_TYPE_INT);

    initialized = TRUE;
  }

  /* default virtual functions */
  iface->list_channels = NULL;
  iface->set_value = NULL;
  iface->get_value = NULL;
  iface->get_balance_type = NULL;
}

/**
 * gst_color_balance_list_channels:
 * @balance: A #GstColorBalance instance
 *
 * Retrieve a list of the available channels.
 *
 * Returns: (element-type GstColorBalanceChannel) (transfer none): A
 *          GList containing pointers to #GstColorBalanceChannel
 *          objects. The list is owned by the #GstColorBalance
 *          instance and must not be freed.
 */
const GList *
gst_color_balance_list_channels (GstColorBalance * balance)
{
  GstColorBalanceInterface *iface;

  g_return_val_if_fail (GST_IS_COLOR_BALANCE (balance), NULL);

  iface = GST_COLOR_BALANCE_GET_INTERFACE (balance);

  if (iface->list_channels) {
    return iface->list_channels (balance);
  }

  return NULL;
}

/**
 * gst_color_balance_set_value:
 * @balance: A #GstColorBalance instance
 * @channel: A #GstColorBalanceChannel instance
 * @value: The new value for the channel.
 *
 * Sets the current value of the channel to the passed value, which must
 * be between min_value and max_value.
 * 
 * See Also: The #GstColorBalanceChannel.min_value and
 *         #GstColorBalanceChannel.max_value members of the
 *         #GstColorBalanceChannel object.
 */
void
gst_color_balance_set_value (GstColorBalance * balance,
    GstColorBalanceChannel * channel, gint value)
{
  GstColorBalanceInterface *iface = GST_COLOR_BALANCE_GET_INTERFACE (balance);

  if (iface->set_value) {
    iface->set_value (balance, channel, value);
  }
}

/**
 * gst_color_balance_get_value:
 * @balance: A #GstColorBalance instance
 * @channel: A #GstColorBalanceChannel instance
 *
 * Retrieve the current value of the indicated channel, between min_value
 * and max_value.
 * 
 * See Also: The #GstColorBalanceChannel.min_value and
 *         #GstColorBalanceChannel.max_value members of the
 *         #GstColorBalanceChannel object.
 * 
 * Returns: The current value of the channel.
 */
gint
gst_color_balance_get_value (GstColorBalance * balance,
    GstColorBalanceChannel * channel)
{
  GstColorBalanceInterface *iface;

  g_return_val_if_fail (GST_IS_COLOR_BALANCE (balance), 0);

  iface = GST_COLOR_BALANCE_GET_INTERFACE (balance);

  if (iface->get_value) {
    return iface->get_value (balance, channel);
  }

  return channel->min_value;
}

/**
 * gst_color_balance_get_balance_type:
 * @balance: The #GstColorBalance implementation
 *
 * Get the #GstColorBalanceType of this implementation.
 *
 * Returns: A the #GstColorBalanceType.
 */
GstColorBalanceType
gst_color_balance_get_balance_type (GstColorBalance * balance)
{
  GstColorBalanceInterface *iface;

  g_return_val_if_fail (GST_IS_COLOR_BALANCE (balance),
      GST_COLOR_BALANCE_SOFTWARE);

  iface = GST_COLOR_BALANCE_GET_INTERFACE (balance);

  g_return_val_if_fail (iface->get_balance_type != NULL,
      GST_COLOR_BALANCE_SOFTWARE);

  return iface->get_balance_type (balance);
}

/**
 * gst_color_balance_value_changed:
 * @balance: A #GstColorBalance instance
 * @channel: A #GstColorBalanceChannel whose value has changed
 * @value: The new value of the channel
 *
 * A helper function called by implementations of the GstColorBalance
 * interface. It fires the #GstColorBalance::value-changed signal on the
 * instance, and the #GstColorBalanceChannel::value-changed signal on the
 * channel object.
 */
void
gst_color_balance_value_changed (GstColorBalance * balance,
    GstColorBalanceChannel * channel, gint value)
{

  g_return_if_fail (GST_IS_COLOR_BALANCE (balance));

  g_signal_emit (G_OBJECT (balance),
      gst_color_balance_signals[VALUE_CHANGED], 0, channel, value);

  g_signal_emit_by_name (G_OBJECT (channel), "value_changed", value);
}
