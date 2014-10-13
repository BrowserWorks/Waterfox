/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

#include "gsttcpclientsrc.h"
#include "gsttcpclientsink.h"
#include "gsttcpserversrc.h"
#include "gsttcpserversink.h"
#include "gstmultifdsink.h"
#include "gstmultisocketsink.h"

GST_DEBUG_CATEGORY (tcp_debug);

static gboolean
plugin_init (GstPlugin * plugin)
{
  if (!gst_element_register (plugin, "tcpclientsink", GST_RANK_NONE,
          GST_TYPE_TCP_CLIENT_SINK))
    return FALSE;
  if (!gst_element_register (plugin, "tcpclientsrc", GST_RANK_NONE,
          GST_TYPE_TCP_CLIENT_SRC))
    return FALSE;
  if (!gst_element_register (plugin, "tcpserversink", GST_RANK_NONE,
          GST_TYPE_TCP_SERVER_SINK))
    return FALSE;
  if (!gst_element_register (plugin, "tcpserversrc", GST_RANK_NONE,
          GST_TYPE_TCP_SERVER_SRC))
    return FALSE;
#ifdef HAVE_SYS_SOCKET_H
  if (!gst_element_register (plugin, "multifdsink", GST_RANK_NONE,
          GST_TYPE_MULTI_FD_SINK))
    return FALSE;
#endif
  if (!gst_element_register (plugin, "multisocketsink", GST_RANK_NONE,
          GST_TYPE_MULTI_SOCKET_SINK))
    return FALSE;

  GST_DEBUG_CATEGORY_INIT (tcp_debug, "tcp", 0, "TCP calls");

  return TRUE;
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    tcp,
    "transfer data over the network via TCP",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
