/* Gstreamer
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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

#include "parserutils.h"

gboolean
decode_vlc (GstBitReader * br, guint * res, const VLCTable * table,
    guint length)
{
  guint8 i;
  guint cbits = 0;
  guint32 value = 0;

  for (i = 0; i < length; i++) {
    if (cbits != table[i].cbits) {
      cbits = table[i].cbits;
      if (!gst_bit_reader_peek_bits_uint32 (br, &value, cbits)) {
        goto failed;
      }
    }

    if (value == table[i].cword) {
      SKIP (br, cbits);
      if (res)
        *res = table[i].value;

      return TRUE;
    }
  }

  GST_DEBUG ("Did not find code");

failed:
  {
    GST_WARNING ("Could not decode VLC returning");

    return FALSE;
  }
}
