/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
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

#ifndef __ATOMS_RECOVERY_H__
#define __ATOMS_RECOVERY_H__

#include <glib.h>
#include <string.h>
#include <stdio.h>
#include <gst/gst.h>

#include "atoms.h"

/* Version to be incremented each time we decide
 * to change the file layout */
#define ATOMS_RECOV_FILE_VERSION          1

#define ATOMS_RECOV_QUARK (g_quark_from_string ("qtmux-atoms-recovery"))

/* gerror error codes */
#define ATOMS_RECOV_ERR_GENERIC           1
#define ATOMS_RECOV_ERR_FILE              2
#define ATOMS_RECOV_ERR_PARSING           3
#define ATOMS_RECOV_ERR_VERSION           4

/* this struct represents each buffer in a moov file, containing the info
 * that is placed in the stsd children atoms
 * Fields should be writen in BE order, and booleans should be writen as
 * 1byte with 0 for false, anything otherwise */
#define TRAK_BUFFER_ENTRY_INFO_SIZE 34
typedef struct
{
  guint32   track_id;
  guint32   nsamples;
  guint32   delta;
  guint32   size;
  guint64   chunk_offset;
  guint64   pts_offset;
  gboolean  sync;
  gboolean  do_pts;
} TrakBufferEntryInfo;

typedef struct
{
  guint32 trak_id;
  guint32 duration;  /* duration in trak timescale */
  guint32 timescale; /* trak's timescale */

  guint64 file_offset;

  /* need for later updating duration */
  guint64 tkhd_file_offset;
  guint64 mdhd_file_offset;

  /* need these offsets to update size */
  guint32 trak_size;
  guint64 mdia_file_offset;
  guint32 mdia_size;
  guint64 minf_file_offset;
  guint32 minf_size;
  guint64 stbl_file_offset;
  guint32 stbl_size;

  guint64 post_stsd_offset;
  guint32 stsd_size;

  /* for storing the samples info */
  AtomSTBL stbl;
} TrakRecovData;

typedef struct
{
  FILE * file;
  gboolean rawfile;

  /* results from parsing the input file */
  guint64   data_size;
  guint32   mdat_header_size;
  guint     mdat_start;

  guint64   mdat_size;
} MdatRecovFile;

typedef struct
{
  FILE * file;
  guint32 timescale;

  guint32 mvhd_pos;
  guint32 mvhd_size;
  guint32 prefix_size; /* prefix + ftyp total size */

  gint num_traks;
  TrakRecovData *traks_rd;
} MoovRecovFile;

gboolean atoms_recov_write_trak_info      (FILE * f, AtomTRAK * trak);
gboolean atoms_recov_write_headers        (FILE * f, AtomFTYP * ftyp,
                                           GstBuffer * prefix, AtomMOOV * moov,
                                           guint32 timescale,
                                           guint32 traks_number);
gboolean atoms_recov_write_trak_samples   (FILE * f, AtomTRAK * trak,
                                           guint32 nsamples, guint32 delta,
                                           guint32 size, guint64 chunk_offset,
                                           gboolean sync, gboolean do_pts,
                                           gint64 pts_offset);

MdatRecovFile * mdat_recov_file_create   (FILE * file, gboolean datafile,
                                          GError ** err);
void            mdat_recov_file_free     (MdatRecovFile * mrf);
MoovRecovFile * moov_recov_file_create   (FILE * file, GError ** err);
void            moov_recov_file_free     (MoovRecovFile * moovrf);
gboolean        moov_recov_parse_buffers (MoovRecovFile * moovrf,
                                          MdatRecovFile * mdatrf,
                                          GError ** err);
gboolean        moov_recov_write_file    (MoovRecovFile * moovrf,
                                          MdatRecovFile * mdatrf, FILE * outf,
                                          GError ** err);

#endif /* __ATOMS_RECOVERY_H__ */
