/* GStreamer Color Balance
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * colorbalancechannel.c: colorbalance channel object design
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

#include "colorbalancechannel.h"

/**
 * SECTION:gstcolorbalancechannel
 * @short_description: Object representing a channel from the #GstColorBalance
 *         interface.
 *
 * <refsect2><para>The #GstColorBalanceChannel object represents a parameter
 * for modifying the color balance implemented by an element providing the
 * #GstColorBalance interface. For example, Hue or Saturation.
 * </para></refsect2>
 */

enum
{
  /* FILL ME */
  SIGNAL_VALUE_CHANGED,
  LAST_SIGNAL
};

static void gst_color_balance_channel_class_init (GstColorBalanceChannelClass *
    klass);
static void gst_color_balance_channel_init (GstColorBalanceChannel * balance);
static void gst_color_balance_channel_dispose (GObject * object);

static GObjectClass *parent_class = NULL;
static guint signals[LAST_SIGNAL] = { 0 };

GType
gst_color_balance_channel_get_type (void)
{
  static GType gst_color_balance_channel_type = 0;

  if (!gst_color_balance_channel_type) {
    static const GTypeInfo color_balance_channel_info = {
      sizeof (GstColorBalanceChannelClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_color_balance_channel_class_init,
      NULL,
      NULL,
      sizeof (GstColorBalanceChannel),
      0,
      (GInstanceInitFunc) gst_color_balance_channel_init,
      NULL
    };

    gst_color_balance_channel_type =
        g_type_register_static (G_TYPE_OBJECT,
        "GstColorBalanceChannel", &color_balance_channel_info, 0);
  }

  return gst_color_balance_channel_type;
}

static void
gst_color_balance_channel_class_init (GstColorBalanceChannelClass * klass)
{
  GObjectClass *object_klass = (GObjectClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  /**
   * GstColorBalanceChannel::value-changed:
   * @channel: The #GstColorBalanceChannel
   * @value: The new value
   *
   * Fired when the value of the indicated channel has changed.
   */
  signals[SIGNAL_VALUE_CHANGED] =
      g_signal_new ("value-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstColorBalanceChannelClass,
          value_changed), NULL, NULL, NULL, G_TYPE_NONE, 1, G_TYPE_INT);

  object_klass->dispose = gst_color_balance_channel_dispose;
}

static void
gst_color_balance_channel_init (GstColorBalanceChannel * channel)
{
  channel->label = NULL;
  channel->min_value = channel->max_value = 0;
}

static void
gst_color_balance_channel_dispose (GObject * object)
{
  GstColorBalanceChannel *channel = GST_COLOR_BALANCE_CHANNEL (object);

  if (channel->label)
    g_free (channel->label);

  channel->label = NULL;

  if (parent_class->dispose)
    parent_class->dispose (object);
}
