/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2008 Thiago Sousa Santos <thiagoss@embedded.ufcg.edu.br>
 * Copyright (C) 2008 Mark Nauwelaerts <mnauw@users.sf.net>
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
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef __GST_QT_MUX_MAP_H__
#define __GST_QT_MUX_MAP_H__

#include "atoms.h"

#include <glib.h>
#include <gst/gst.h>

typedef enum _GstQTMuxFormat
{
  GST_QT_MUX_FORMAT_NONE = 0,
  GST_QT_MUX_FORMAT_QT,
  GST_QT_MUX_FORMAT_MP4,
  GST_QT_MUX_FORMAT_3GP,
  GST_QT_MUX_FORMAT_MJ2,
  GST_QT_MUX_FORMAT_ISML
} GstQTMuxFormat;

typedef struct _GstQTMuxFormatProp
{
  GstQTMuxFormat format;
  GstRank rank;
  const gchar *name;
  const gchar *long_name;
  const gchar *type_name;
  GstStaticCaps src_caps;
  GstStaticCaps video_sink_caps;
  GstStaticCaps audio_sink_caps;
  GstStaticCaps subtitle_sink_caps;
} GstQTMuxFormatProp;

extern GstQTMuxFormatProp gst_qt_mux_format_list[];

void            gst_qt_mux_map_format_to_header      (GstQTMuxFormat format, GstBuffer ** _prefix,
                                                      guint32 * _major, guint32 * verson,
                                                      GList ** _compatible, AtomMOOV * moov,
                                                      GstClockTime longest_chunk,
                                                      gboolean faststart);

AtomsTreeFlavor gst_qt_mux_map_format_to_flavor      (GstQTMuxFormat format);

#endif /* __GST_QT_MUX_MAP_H__ */
