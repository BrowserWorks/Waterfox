/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2008-2010 Thiago Santos <thiagoss@embedded.ufcg.edu.br>
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

#ifndef __GST_QT_MUX_H__
#define __GST_QT_MUX_H__

#include <gst/gst.h>
#include <gst/base/gstcollectpads.h>

#include "fourcc.h"
#include "atoms.h"
#include "atomsrecovery.h"
#include "gstqtmuxmap.h"

G_BEGIN_DECLS

#define GST_TYPE_QT_MUX (gst_qt_mux_get_type())
#define GST_QT_MUX(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_QT_MUX, GstQTMux))
#define GST_QT_MUX_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_QT_MUX, GstQTMux))
#define GST_IS_QT_MUX(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_QT_MUX))
#define GST_IS_QT_MUX_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_QT_MUX))
#define GST_QT_MUX_CAST(obj) ((GstQTMux*)(obj))


typedef struct _GstQTMux GstQTMux;
typedef struct _GstQTMuxClass GstQTMuxClass;
typedef struct _GstQTPad GstQTPad;

/*
 * GstQTPadPrepareBufferFunc
 *
 * Receives a buffer (takes ref) and returns a new buffer that should
 * replace the passed one.
 *
 * Useful for when the pad/datatype needs some manipulation before
 * being muxed. (Originally added for image/x-jpc support, for which buffers
 * need to be wrapped into a isom box)
 */
typedef GstBuffer * (*GstQTPadPrepareBufferFunc) (GstQTPad * pad,
    GstBuffer * buf, GstQTMux * qtmux);

typedef gboolean (*GstQTPadSetCapsFunc) (GstQTPad * pad, GstCaps * caps);
typedef GstBuffer * (*GstQTPadCreateEmptyBufferFunc) (GstQTPad * pad, gint64 duration);

#define QTMUX_NO_OF_TS   10

struct _GstQTPad
{
  GstCollectData collect;       /* we extend the CollectData */

  /* fourcc id of stream */
  guint32 fourcc;
  /* whether using format that have out of order buffers */
  gboolean is_out_of_order;
  /* if not 0, track with constant sized samples, e.g. raw audio */
  guint sample_size;
  /* make sync table entry */
  gboolean sync;
  /* if it is a sparse stream
   * (meaning we can't use PTS differences to compute duration) */
  gboolean sparse;
  /* bitrates */
  guint32 avg_bitrate, max_bitrate;

  /* for avg bitrate calculation */
  guint64 total_bytes;
  guint64 total_duration;

  GstBuffer *last_buf;
  /* dts of last_buf */
  GstClockTime last_dts;

  /* store the first timestamp for comparing with other streams and
   * know if there are late streams */
  GstClockTime first_ts;
  guint buf_head;
  guint buf_tail;

  /* all the atom and chunk book-keeping is delegated here
   * unowned/uncounted reference, parent MOOV owns */
  AtomTRAK *trak;
  /* fragmented support */
  /* meta data book-keeping delegated here */
  AtomTRAF *traf;
  /* fragment buffers */
  ATOM_ARRAY (GstBuffer *) fragment_buffers;
  /* running fragment duration */
  gint64 fragment_duration;
  /* optional fragment index book-keeping */
  AtomTFRA *tfra;

  /* if nothing is set, it won't be called */
  GstQTPadPrepareBufferFunc prepare_buf_func;
  GstQTPadSetCapsFunc set_caps;
  GstQTPadCreateEmptyBufferFunc create_empty_buffer;
};

typedef enum _GstQTMuxState
{
  GST_QT_MUX_STATE_NONE,
  GST_QT_MUX_STATE_STARTED,
  GST_QT_MUX_STATE_DATA,
  GST_QT_MUX_STATE_EOS
} GstQTMuxState;

struct _GstQTMux
{
  GstElement element;

  GstPad *srcpad;
  GstCollectPads *collect;
  GSList *sinkpads;

  /* state */
  GstQTMuxState state;

  /* size of header (prefix, atoms (ftyp, mdat)) */
  guint64 header_size;
  /* accumulated size of raw media data (a priori not including mdat header) */
  guint64 mdat_size;
  /* position of mdat atom (for later updating) */
  guint64 mdat_pos;

  /* keep track of the largest chunk to fine-tune brands */
  GstClockTime longest_chunk;

  /* atom helper objects */
  AtomsContext *context;
  AtomFTYP *ftyp;
  AtomMOOV *moov;
  GSList *extra_atoms; /* list of extra top-level atoms (e.g. UUID for xmp)
                        * Stored as AtomInfo structs */

  /* fragmented file index */
  AtomMFRA *mfra;

  /* fast start */
  FILE *fast_start_file;

  /* moov recovery */
  FILE *moov_recov_file;

  /* fragment sequence */
  guint32 fragment_sequence;

  /* properties */
  guint32 timescale;
  guint32 trak_timescale;
  AtomsTreeFlavor flavor;
  gboolean fast_start;
  gboolean guess_pts;
#ifndef GST_REMOVE_DEPRECATED
  gint dts_method;
#endif
  gchar *fast_start_file_path;
  gchar *moov_recov_file_path;
  guint32 fragment_duration;
  gboolean streamable;

  /* for request pad naming */
  guint video_pads, audio_pads, subtitle_pads;
};

struct _GstQTMuxClass
{
  GstElementClass parent_class;

  GstQTMuxFormat format;
};

/* type register helper struct */
typedef struct _GstQTMuxClassParams
{
  GstQTMuxFormatProp *prop;
  GstCaps *src_caps;
  GstCaps *video_sink_caps;
  GstCaps *audio_sink_caps;
  GstCaps *subtitle_sink_caps;
} GstQTMuxClassParams;

#define GST_QT_MUX_PARAMS_QDATA g_quark_from_static_string("qt-mux-params")

GType gst_qt_mux_get_type (void);
gboolean gst_qt_mux_register (GstPlugin * plugin);

/* FIXME: ideally classification tag should be added and
 * registered in gstreamer core gsttaglist
 *
 * this tag is a string in the format: entityfourcc://table_num/content
 * FIXME Shouldn't we add a field for 'language'?
 */
#define GST_TAG_3GP_CLASSIFICATION "classification"

G_END_DECLS

#endif /* __GST_QT_MUX_H__ */
