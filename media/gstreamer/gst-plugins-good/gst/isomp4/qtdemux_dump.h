/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2009> STEricsson <benjamin.gaignard@stericsson.com>
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

#ifndef __GST_QTDEMUX_DUMP_H__
#define __GST_QTDEMUX_DUMP_H__

#include <gst/gst.h>
#include <qtdemux.h>

G_BEGIN_DECLS
    gboolean qtdemux_dump_mvhd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_tkhd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_elst (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_mdhd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_hdlr (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_vmhd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_dref (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stsd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stts (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stss (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stps (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stsc (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stsz (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_stco (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_co64 (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_dcom (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_cmvd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_ctts (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_mfro (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_tfra (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_tfhd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_trun (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_trex (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_mehd (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_sdtp (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_tfdt (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);
gboolean qtdemux_dump_unknown (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);

gboolean qtdemux_node_dump (GstQTDemux * qtdemux, GNode * node);

G_END_DECLS
#endif /* __GST_QTDEMUX_DUMP_H__ */
