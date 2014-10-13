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

/**
 * This module contains functions for serializing partial information from
 * a mux in progress (by qtmux elements). This enables reconstruction of the
 * moov box if a crash happens and thus recovering the movie file.
 *
 * Usage:
 * 1) pipeline: ...yourelements ! qtmux moov-recovery-file=path.mrf ! \
 * filesink location=moovie.mov
 *
 * 2) CRASH!
 *
 * 3) gst-launch-1.0 qtmoovrecover recovery-input=path.mrf broken-input=moovie.mov \
        fixed-output=recovered.mov
 *
 * 4) (Hopefully) enjoy recovered.mov.
 *
 * --- Recovery file layout ---
 * 1) Version (a guint16)
 * 2) Prefix atom (if present)
 * 3) ftyp atom
 * 4) MVHD atom (without timescale/duration set)
 * 5) moovie timescale
 * 6) number of traks
 * 7) list of trak atoms (stbl data is ignored, except for the stsd atom)
 * 8) Buffers metadata (metadata that is relevant to the container)
 *    Buffers metadata are stored in the order they are added to the mdat,
 *    each entre has a fixed size and is stored in BE. booleans are stored
 *    as a single byte where 0 means false, otherwise is true.
 *   Metadata:
 *   - guint32   track_id;
 *   - guint32   nsamples;
 *   - guint32   delta;
 *   - guint32   size;
 *   - guint64   chunk_offset;
 *   - gboolean  sync;
 *   - gboolean  do_pts;
 *   - guint64   pts_offset; (always present, ignored if do_pts is false)
 *
 * The mdat file might contain ftyp and then mdat, in case this is the faststart
 * temporary file there is no ftyp and no mdat header, only the buffers data.
 *
 * Notes about recovery file layout: We still don't store tags nor EDTS data.
 *
 * IMPORTANT: this is still at a experimental state.
 */

#include "atomsrecovery.h"

#define ATOMS_RECOV_OUTPUT_WRITE_ERROR(err) \
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE, \
        "Failed to write to output file: %s", g_strerror (errno))

static gboolean
atoms_recov_write_version (FILE * f)
{
  guint8 data[2];
  GST_WRITE_UINT16_BE (data, ATOMS_RECOV_FILE_VERSION);
  return fwrite (data, 2, 1, f) == 1;
}

static gboolean
atoms_recov_write_ftyp_info (FILE * f, AtomFTYP * ftyp, GstBuffer * prefix)
{
  guint8 *data = NULL;
  guint64 offset = 0;
  guint64 size = 0;

  if (prefix) {
    GstMapInfo map;

    gst_buffer_map (prefix, &map, GST_MAP_READ);
    if (fwrite (map.data, 1, map.size, f) != map.size) {
      gst_buffer_unmap (prefix, &map);
      return FALSE;
    }
    gst_buffer_unmap (prefix, &map);
  }
  if (!atom_ftyp_copy_data (ftyp, &data, &size, &offset)) {
    return FALSE;
  }
  if (fwrite (data, 1, offset, f) != offset) {
    g_free (data);
    return FALSE;
  }
  g_free (data);
  return TRUE;
}

/**
 * Writes important info on the 'moov' atom (non-trak related)
 * to be able to recover the moov structure after a crash.
 *
 * Currently, it writes the MVHD atom.
 */
static gboolean
atoms_recov_write_moov_info (FILE * f, AtomMOOV * moov)
{
  guint8 *data;
  guint64 size;
  guint64 offset = 0;
  guint64 atom_size = 0;
  gint writen = 0;

  /* likely enough */
  size = 256;
  data = g_malloc (size);
  atom_size = atom_mvhd_copy_data (&moov->mvhd, &data, &size, &offset);
  if (atom_size > 0)
    writen = fwrite (data, 1, atom_size, f);
  g_free (data);
  return atom_size > 0 && writen == atom_size;
}

/**
 * Writes the number of traks to the file.
 * This simply writes a guint32 in BE.
 */
static gboolean
atoms_recov_write_traks_number (FILE * f, guint32 traks)
{
  guint8 data[4];
  GST_WRITE_UINT32_BE (data, traks);
  return fwrite (data, 4, 1, f) == 1;
}

/**
 * Writes the moov's timescale to the file
 * This simply writes a guint32 in BE.
 */
static gboolean
atoms_recov_write_moov_timescale (FILE * f, guint32 timescale)
{
  guint8 data[4];
  GST_WRITE_UINT32_BE (data, timescale);
  return fwrite (data, 4, 1, f) == 1;
}

/**
 * Writes the trak atom to the file.
 */
gboolean
atoms_recov_write_trak_info (FILE * f, AtomTRAK * trak)
{
  guint8 *data;
  guint64 size;
  guint64 offset = 0;
  guint64 atom_size = 0;
  gint writen = 0;

  /* buffer is realloced to a larger size if needed */
  size = 4 * 1024;
  data = g_malloc (size);
  atom_size = atom_trak_copy_data (trak, &data, &size, &offset);
  if (atom_size > 0)
    writen = fwrite (data, atom_size, 1, f);
  g_free (data);
  return atom_size > 0 && writen == atom_size;
}

gboolean
atoms_recov_write_trak_samples (FILE * f, AtomTRAK * trak, guint32 nsamples,
    guint32 delta, guint32 size, guint64 chunk_offset, gboolean sync,
    gboolean do_pts, gint64 pts_offset)
{
  guint8 data[TRAK_BUFFER_ENTRY_INFO_SIZE];
  /*
   * We have to write a TrakBufferEntryInfo
   */
  GST_WRITE_UINT32_BE (data + 0, trak->tkhd.track_ID);
  GST_WRITE_UINT32_BE (data + 4, nsamples);
  GST_WRITE_UINT32_BE (data + 8, delta);
  GST_WRITE_UINT32_BE (data + 12, size);
  GST_WRITE_UINT64_BE (data + 16, chunk_offset);
  if (sync)
    GST_WRITE_UINT8 (data + 24, 1);
  else
    GST_WRITE_UINT8 (data + 24, 0);
  if (do_pts) {
    GST_WRITE_UINT8 (data + 25, 1);
    GST_WRITE_UINT64_BE (data + 26, pts_offset);
  } else {
    GST_WRITE_UINT8 (data + 25, 0);
    GST_WRITE_UINT64_BE (data + 26, 0);
  }

  return fwrite (data, 1, TRAK_BUFFER_ENTRY_INFO_SIZE, f) ==
      TRAK_BUFFER_ENTRY_INFO_SIZE;
}

gboolean
atoms_recov_write_headers (FILE * f, AtomFTYP * ftyp, GstBuffer * prefix,
    AtomMOOV * moov, guint32 timescale, guint32 traks_number)
{
  if (!atoms_recov_write_version (f)) {
    return FALSE;
  }

  if (!atoms_recov_write_ftyp_info (f, ftyp, prefix)) {
    return FALSE;
  }

  if (!atoms_recov_write_moov_info (f, moov)) {
    return FALSE;
  }

  if (!atoms_recov_write_moov_timescale (f, timescale)) {
    return FALSE;
  }

  if (!atoms_recov_write_traks_number (f, traks_number)) {
    return FALSE;
  }

  return TRUE;
}

static gboolean
read_atom_header (FILE * f, guint32 * fourcc, guint32 * size)
{
  guint8 aux[8];

  if (fread (aux, 1, 8, f) != 8)
    return FALSE;
  *size = GST_READ_UINT32_BE (aux);
  *fourcc = GST_READ_UINT32_LE (aux + 4);
  return TRUE;
}

static gboolean
moov_recov_file_parse_prefix (MoovRecovFile * moovrf)
{
  guint32 fourcc;
  guint32 size;
  guint32 total_size = 0;
  if (fseek (moovrf->file, 2, SEEK_SET) != 0)
    return FALSE;
  if (!read_atom_header (moovrf->file, &fourcc, &size)) {
    return FALSE;
  }

  if (fourcc != FOURCC_ftyp) {
    /* we might have a prefix here */
    if (fseek (moovrf->file, size - 8, SEEK_CUR) != 0)
      return FALSE;

    total_size += size;

    /* now read the ftyp */
    if (!read_atom_header (moovrf->file, &fourcc, &size))
      return FALSE;
  }

  /* this has to be the ftyp */
  if (fourcc != FOURCC_ftyp)
    return FALSE;
  total_size += size;
  moovrf->prefix_size = total_size;
  return fseek (moovrf->file, size - 8, SEEK_CUR) == 0;
}

static gboolean
moov_recov_file_parse_mvhd (MoovRecovFile * moovrf)
{
  guint32 fourcc;
  guint32 size;
  if (!read_atom_header (moovrf->file, &fourcc, &size)) {
    return FALSE;
  }
  /* check for sanity */
  if (fourcc != FOURCC_mvhd)
    return FALSE;

  moovrf->mvhd_size = size;
  moovrf->mvhd_pos = ftell (moovrf->file) - 8;

  /* skip the remaining of the mvhd in the file */
  return fseek (moovrf->file, size - 8, SEEK_CUR) == 0;
}

static gboolean
mdat_recov_file_parse_mdat_start (MdatRecovFile * mdatrf)
{
  guint32 fourcc, size;

  if (!read_atom_header (mdatrf->file, &fourcc, &size)) {
    return FALSE;
  }
  if (size == 1) {
    mdatrf->mdat_header_size = 16;
    mdatrf->mdat_size = 16;
  } else {
    mdatrf->mdat_header_size = 8;
    mdatrf->mdat_size = 8;
  }
  mdatrf->mdat_start = ftell (mdatrf->file) - 8;

  return fourcc == FOURCC_mdat;
}

MdatRecovFile *
mdat_recov_file_create (FILE * file, gboolean datafile, GError ** err)
{
  MdatRecovFile *mrf = g_new0 (MdatRecovFile, 1);
  guint32 fourcc, size;

  g_return_val_if_fail (file != NULL, NULL);

  mrf->file = file;
  mrf->rawfile = datafile;

  /* get the file/data length */
  if (fseek (file, 0, SEEK_END) != 0)
    goto file_length_error;
  /* still needs to deduce the mdat header and ftyp size */
  mrf->data_size = ftell (file);
  if (mrf->data_size == -1L)
    goto file_length_error;

  if (fseek (file, 0, SEEK_SET) != 0)
    goto file_seek_error;

  if (datafile) {
    /* this file contains no atoms, only raw data to be placed on the mdat
     * this happens when faststart mode is used */
    mrf->mdat_start = 0;
    mrf->mdat_header_size = 16;
    mrf->mdat_size = 16;
    return mrf;
  }

  if (!read_atom_header (file, &fourcc, &size)) {
    goto parse_error;
  }
  if (fourcc != FOURCC_ftyp) {
    /* this could be a prefix atom, let's skip it and try again */
    if (fseek (file, size - 8, SEEK_CUR) != 0) {
      goto file_seek_error;
    }
    if (!read_atom_header (file, &fourcc, &size)) {
      goto parse_error;
    }
  }

  if (fourcc != FOURCC_ftyp) {
    goto parse_error;
  }
  if (fseek (file, size - 8, SEEK_CUR) != 0)
    goto file_seek_error;

  /* we don't parse this if we have a tmpdatafile */
  if (!mdat_recov_file_parse_mdat_start (mrf)) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Error while parsing mdat atom");
    goto fail;
  }

  return mrf;

parse_error:
  g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
      "Failed to parse atom");
  goto fail;

file_seek_error:
  g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
      "Failed to seek to start of the file");
  goto fail;

file_length_error:
  g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
      "Failed to determine file size");
  goto fail;

fail:
  mdat_recov_file_free (mrf);
  return NULL;
}

void
mdat_recov_file_free (MdatRecovFile * mrf)
{
  fclose (mrf->file);
  g_free (mrf);
}

static gboolean
moov_recov_parse_num_traks (MoovRecovFile * moovrf)
{
  guint8 traks[4];
  if (fread (traks, 1, 4, moovrf->file) != 4)
    return FALSE;
  moovrf->num_traks = GST_READ_UINT32_BE (traks);
  return TRUE;
}

static gboolean
moov_recov_parse_moov_timescale (MoovRecovFile * moovrf)
{
  guint8 ts[4];
  if (fread (ts, 1, 4, moovrf->file) != 4)
    return FALSE;
  moovrf->timescale = GST_READ_UINT32_BE (ts);
  return TRUE;
}

static gboolean
skip_atom (MoovRecovFile * moovrf, guint32 expected_fourcc)
{
  guint32 size;
  guint32 fourcc;

  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != expected_fourcc)
    return FALSE;

  return (fseek (moovrf->file, size - 8, SEEK_CUR) == 0);
}

static gboolean
moov_recov_parse_tkhd (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint32 size;
  guint32 fourcc;
  guint8 data[4];

  /* make sure we are on a tkhd atom */
  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != FOURCC_tkhd)
    return FALSE;

  trakrd->tkhd_file_offset = ftell (moovrf->file) - 8;

  /* move 8 bytes forward to the trak_id pos */
  if (fseek (moovrf->file, 12, SEEK_CUR) != 0)
    return FALSE;
  if (fread (data, 1, 4, moovrf->file) != 4)
    return FALSE;

  /* advance the rest of tkhd */
  if (fseek (moovrf->file, 68, SEEK_CUR) != 0)
    return FALSE;

  trakrd->trak_id = GST_READ_UINT32_BE (data);
  return TRUE;
}

static gboolean
moov_recov_parse_stbl (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint32 size;
  guint32 fourcc;
  guint32 auxsize;

  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != FOURCC_stbl)
    return FALSE;

  trakrd->stbl_file_offset = ftell (moovrf->file) - 8;
  trakrd->stbl_size = size;

  /* skip the stsd */
  if (!read_atom_header (moovrf->file, &fourcc, &auxsize))
    return FALSE;
  if (fourcc != FOURCC_stsd)
    return FALSE;
  if (fseek (moovrf->file, auxsize - 8, SEEK_CUR) != 0)
    return FALSE;

  trakrd->stsd_size = auxsize;
  trakrd->post_stsd_offset = ftell (moovrf->file);

  /* as this is the last atom we parse, we don't skip forward */

  return TRUE;
}

static gboolean
moov_recov_parse_minf (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint32 size;
  guint32 fourcc;
  guint32 auxsize;

  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != FOURCC_minf)
    return FALSE;

  trakrd->minf_file_offset = ftell (moovrf->file) - 8;
  trakrd->minf_size = size;

  /* skip either of vmhd, smhd, hmhd that might follow */
  if (!read_atom_header (moovrf->file, &fourcc, &auxsize))
    return FALSE;
  if (fourcc != FOURCC_vmhd && fourcc != FOURCC_smhd && fourcc != FOURCC_hmhd &&
      fourcc != FOURCC_gmhd)
    return FALSE;
  if (fseek (moovrf->file, auxsize - 8, SEEK_CUR))
    return FALSE;

  /* skip a possible hdlr and the following dinf */
  if (!read_atom_header (moovrf->file, &fourcc, &auxsize))
    return FALSE;
  if (fourcc == FOURCC_hdlr) {
    if (fseek (moovrf->file, auxsize - 8, SEEK_CUR))
      return FALSE;
    if (!read_atom_header (moovrf->file, &fourcc, &auxsize))
      return FALSE;
  }
  if (fourcc != FOURCC_dinf)
    return FALSE;
  if (fseek (moovrf->file, auxsize - 8, SEEK_CUR))
    return FALSE;

  /* now we are ready to read the stbl */
  if (!moov_recov_parse_stbl (moovrf, trakrd))
    return FALSE;

  return TRUE;
}

static gboolean
moov_recov_parse_mdhd (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint32 size;
  guint32 fourcc;
  guint8 data[4];

  /* make sure we are on a tkhd atom */
  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != FOURCC_mdhd)
    return FALSE;

  trakrd->mdhd_file_offset = ftell (moovrf->file) - 8;

  /* get the timescale */
  if (fseek (moovrf->file, 12, SEEK_CUR) != 0)
    return FALSE;
  if (fread (data, 1, 4, moovrf->file) != 4)
    return FALSE;
  trakrd->timescale = GST_READ_UINT32_BE (data);
  if (fseek (moovrf->file, 8, SEEK_CUR) != 0)
    return FALSE;
  return TRUE;
}

static gboolean
moov_recov_parse_mdia (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint32 size;
  guint32 fourcc;

  /* make sure we are on a tkhd atom */
  if (!read_atom_header (moovrf->file, &fourcc, &size))
    return FALSE;
  if (fourcc != FOURCC_mdia)
    return FALSE;

  trakrd->mdia_file_offset = ftell (moovrf->file) - 8;
  trakrd->mdia_size = size;

  if (!moov_recov_parse_mdhd (moovrf, trakrd))
    return FALSE;

  if (!skip_atom (moovrf, FOURCC_hdlr))
    return FALSE;
  if (!moov_recov_parse_minf (moovrf, trakrd))
    return FALSE;
  return TRUE;
}

static gboolean
moov_recov_parse_trak (MoovRecovFile * moovrf, TrakRecovData * trakrd)
{
  guint64 offset;
  guint32 size;
  guint32 fourcc;

  offset = ftell (moovrf->file);
  if (offset == -1) {
    return FALSE;
  }

  /* make sure we are on a trak atom */
  if (!read_atom_header (moovrf->file, &fourcc, &size)) {
    return FALSE;
  }
  if (fourcc != FOURCC_trak) {
    return FALSE;
  }
  trakrd->trak_size = size;

  /* now we should have a trak header 'tkhd' */
  if (!moov_recov_parse_tkhd (moovrf, trakrd))
    return FALSE;

  /* FIXME add edts handling here and in qtmux, as this is only detected
   * after buffers start flowing */

  if (!moov_recov_parse_mdia (moovrf, trakrd))
    return FALSE;

  trakrd->file_offset = offset;
  /* position after the trak */
  return fseek (moovrf->file, (long int) offset + size, SEEK_SET) == 0;
}

MoovRecovFile *
moov_recov_file_create (FILE * file, GError ** err)
{
  gint i;
  MoovRecovFile *moovrf = g_new0 (MoovRecovFile, 1);

  g_return_val_if_fail (file != NULL, NULL);

  moovrf->file = file;

  /* look for ftyp and prefix at the start */
  if (!moov_recov_file_parse_prefix (moovrf)) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Error while parsing prefix atoms");
    goto fail;
  }

  /* parse the mvhd */
  if (!moov_recov_file_parse_mvhd (moovrf)) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Error while parsing mvhd atom");
    goto fail;
  }

  if (!moov_recov_parse_moov_timescale (moovrf)) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Error while parsing timescale");
    goto fail;
  }
  if (!moov_recov_parse_num_traks (moovrf)) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Error while parsing parsing number of traks");
    goto fail;
  }

  /* sanity check */
  if (moovrf->num_traks > 1024) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
        "Unsupported number of traks");
    goto fail;
  }

  /* init the traks */
  moovrf->traks_rd = g_new0 (TrakRecovData, moovrf->num_traks);
  for (i = 0; i < moovrf->num_traks; i++) {
    atom_stbl_init (&(moovrf->traks_rd[i].stbl));
  }
  for (i = 0; i < moovrf->num_traks; i++) {
    if (!moov_recov_parse_trak (moovrf, &(moovrf->traks_rd[i]))) {
      g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
          "Error while parsing trak atom");
      goto fail;
    }
  }

  return moovrf;

fail:
  moov_recov_file_free (moovrf);
  return NULL;
}

void
moov_recov_file_free (MoovRecovFile * moovrf)
{
  gint i;
  fclose (moovrf->file);
  if (moovrf->traks_rd) {
    for (i = 0; i < moovrf->num_traks; i++) {
      atom_stbl_clear (&(moovrf->traks_rd[i].stbl));
    }
    g_free (moovrf->traks_rd);
  }
  g_free (moovrf);
}

static gboolean
moov_recov_parse_buffer_entry (MoovRecovFile * moovrf, TrakBufferEntryInfo * b)
{
  guint8 data[TRAK_BUFFER_ENTRY_INFO_SIZE];
  gint read;

  read = fread (data, 1, TRAK_BUFFER_ENTRY_INFO_SIZE, moovrf->file);
  if (read != TRAK_BUFFER_ENTRY_INFO_SIZE)
    return FALSE;

  b->track_id = GST_READ_UINT32_BE (data);
  b->nsamples = GST_READ_UINT32_BE (data + 4);
  b->delta = GST_READ_UINT32_BE (data + 8);
  b->size = GST_READ_UINT32_BE (data + 12);
  b->chunk_offset = GST_READ_UINT64_BE (data + 16);
  b->sync = data[24] != 0;
  b->do_pts = data[25] != 0;
  b->pts_offset = GST_READ_UINT64_BE (data + 26);
  return TRUE;
}

static gboolean
mdat_recov_add_sample (MdatRecovFile * mdatrf, guint32 size)
{
  /* test if this data exists */
  if (mdatrf->mdat_size - mdatrf->mdat_header_size + size > mdatrf->data_size)
    return FALSE;

  mdatrf->mdat_size += size;
  return TRUE;
}

static TrakRecovData *
moov_recov_get_trak (MoovRecovFile * moovrf, guint32 id)
{
  gint i;
  for (i = 0; i < moovrf->num_traks; i++) {
    if (moovrf->traks_rd[i].trak_id == id)
      return &(moovrf->traks_rd[i]);
  }
  return NULL;
}

static void
trak_recov_data_add_sample (TrakRecovData * trak, TrakBufferEntryInfo * b)
{
  trak->duration += b->nsamples * b->delta;
  atom_stbl_add_samples (&trak->stbl, b->nsamples, b->delta, b->size,
      b->chunk_offset, b->sync, b->pts_offset);
}

/**
 * Parses the buffer entries in the MoovRecovFile and matches the inputs
 * with the data in the MdatRecovFile. Whenever a buffer entry of that
 * represents 'x' bytes of data, the same amount of data is 'validated' in
 * the MdatRecovFile and will be inluded in the generated moovie file.
 */
gboolean
moov_recov_parse_buffers (MoovRecovFile * moovrf, MdatRecovFile * mdatrf,
    GError ** err)
{
  TrakBufferEntryInfo entry;
  TrakRecovData *trak;

  /* we assume both moovrf and mdatrf are at the starting points of their
   * data reading */
  while (moov_recov_parse_buffer_entry (moovrf, &entry)) {
    /* be sure we still have this data in mdat */
    trak = moov_recov_get_trak (moovrf, entry.track_id);
    if (trak == NULL) {
      g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_PARSING,
          "Invalid trak id found in buffer entry");
      return FALSE;
    }
    if (!mdat_recov_add_sample (mdatrf, entry.size))
      break;
    trak_recov_data_add_sample (trak, &entry);
  }
  return TRUE;
}

static guint32
trak_recov_data_get_trak_atom_size (TrakRecovData * trak)
{
  AtomSTBL *stbl = &trak->stbl;
  guint64 offset;

  /* write out our stbl child atoms */
  offset = 0;

  if (!atom_stts_copy_data (&stbl->stts, NULL, NULL, &offset)) {
    goto fail;
  }
  if (atom_array_get_len (&stbl->stss.entries) > 0) {
    if (!atom_stss_copy_data (&stbl->stss, NULL, NULL, &offset)) {
      goto fail;
    }
  }
  if (!atom_stsc_copy_data (&stbl->stsc, NULL, NULL, &offset)) {
    goto fail;
  }
  if (!atom_stsz_copy_data (&stbl->stsz, NULL, NULL, &offset)) {
    goto fail;
  }
  if (stbl->ctts) {
    if (!atom_ctts_copy_data (stbl->ctts, NULL, NULL, &offset)) {
      goto fail;
    }
  }
  if (!atom_stco64_copy_data (&stbl->stco64, NULL, NULL, &offset)) {
    goto fail;
  }

  return trak->trak_size + ((trak->stsd_size + offset + 8) - trak->stbl_size);

fail:
  return 0;
}

static guint8 *
moov_recov_get_stbl_children_data (MoovRecovFile * moovrf, TrakRecovData * trak,
    guint64 * p_size)
{
  AtomSTBL *stbl = &trak->stbl;
  guint8 *buffer;
  guint64 size;
  guint64 offset;

  /* write out our stbl child atoms
   *
   * Use 1MB as a starting size, *_copy_data functions
   * will grow the buffer if needed.
   */
  size = 1024 * 1024;
  buffer = g_malloc0 (size);
  offset = 0;

  if (!atom_stts_copy_data (&stbl->stts, &buffer, &size, &offset)) {
    goto fail;
  }
  if (atom_array_get_len (&stbl->stss.entries) > 0) {
    if (!atom_stss_copy_data (&stbl->stss, &buffer, &size, &offset)) {
      goto fail;
    }
  }
  if (!atom_stsc_copy_data (&stbl->stsc, &buffer, &size, &offset)) {
    goto fail;
  }
  if (!atom_stsz_copy_data (&stbl->stsz, &buffer, &size, &offset)) {
    goto fail;
  }
  if (stbl->ctts) {
    if (!atom_ctts_copy_data (stbl->ctts, &buffer, &size, &offset)) {
      goto fail;
    }
  }
  if (!atom_stco64_copy_data (&stbl->stco64, &buffer, &size, &offset)) {
    goto fail;
  }
  *p_size = offset;
  return buffer;

fail:
  g_free (buffer);
  return NULL;
}

gboolean
moov_recov_write_file (MoovRecovFile * moovrf, MdatRecovFile * mdatrf,
    FILE * outf, GError ** err)
{
  guint8 auxdata[16];
  guint8 *data = NULL;
  guint8 *prefix_data = NULL;
  guint8 *mvhd_data = NULL;
  guint8 *trak_data = NULL;
  guint32 moov_size = 0;
  gint i;
  guint64 stbl_children_size = 0;
  guint8 *stbl_children = NULL;
  guint32 longest_duration = 0;
  guint16 version;

  /* check the version */
  if (fseek (moovrf->file, 0, SEEK_SET) != 0) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
        "Failed to seek to the start of the moov recovery file");
    goto fail;
  }
  if (fread (auxdata, 1, 2, moovrf->file) != 2) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
        "Failed to read version from file");
  }

  version = GST_READ_UINT16_BE (auxdata);
  if (version != ATOMS_RECOV_FILE_VERSION) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_VERSION,
        "Input file version (%u) is not supported in this version (%u)",
        version, ATOMS_RECOV_FILE_VERSION);
    return FALSE;
  }

  /* write the ftyp */
  prefix_data = g_malloc (moovrf->prefix_size);
  if (fread (prefix_data, 1, moovrf->prefix_size,
          moovrf->file) != moovrf->prefix_size) {
    g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
        "Failed to read the ftyp atom from file");
    goto fail;
  }
  if (fwrite (prefix_data, 1, moovrf->prefix_size, outf) != moovrf->prefix_size) {
    ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
    goto fail;
  }
  g_free (prefix_data);
  prefix_data = NULL;

  /* need to calculate the moov size beforehand to add the offset to
   * chunk offset entries */
  moov_size += moovrf->mvhd_size + 8;   /* mvhd + moov size + fourcc */
  for (i = 0; i < moovrf->num_traks; i++) {
    TrakRecovData *trak = &(moovrf->traks_rd[i]);
    guint32 duration;           /* in moov's timescale */
    guint32 trak_size;

    /* convert trak duration to moov's duration */
    duration = gst_util_uint64_scale_round (trak->duration, moovrf->timescale,
        trak->timescale);

    if (duration > longest_duration)
      longest_duration = duration;
    trak_size = trak_recov_data_get_trak_atom_size (trak);
    if (trak_size == 0) {
      g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_GENERIC,
          "Failed to estimate trak atom size");
      goto fail;
    }
    moov_size += trak_size;
  }

  /* add chunks offsets */
  for (i = 0; i < moovrf->num_traks; i++) {
    TrakRecovData *trak = &(moovrf->traks_rd[i]);
    /* 16 for the mdat header */
    gint64 offset = moov_size + ftell (outf) + 16;
    atom_stco64_chunks_add_offset (&trak->stbl.stco64, offset);
  }

  /* write the moov */
  GST_WRITE_UINT32_BE (auxdata, moov_size);
  GST_WRITE_UINT32_LE (auxdata + 4, FOURCC_moov);
  if (fwrite (auxdata, 1, 8, outf) != 8) {
    ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
    goto fail;
  }

  /* write the mvhd */
  mvhd_data = g_malloc (moovrf->mvhd_size);
  if (fseek (moovrf->file, moovrf->mvhd_pos, SEEK_SET) != 0)
    goto fail;
  if (fread (mvhd_data, 1, moovrf->mvhd_size,
          moovrf->file) != moovrf->mvhd_size)
    goto fail;
  GST_WRITE_UINT32_BE (mvhd_data + 20, moovrf->timescale);
  GST_WRITE_UINT32_BE (mvhd_data + 24, longest_duration);
  if (fwrite (mvhd_data, 1, moovrf->mvhd_size, outf) != moovrf->mvhd_size) {
    ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
    goto fail;
  }
  g_free (mvhd_data);
  mvhd_data = NULL;

  /* write the traks, this is the tough part because we need to update:
   * - stbl atom
   * - sizes of atoms from stbl to trak
   * - trak duration
   */
  for (i = 0; i < moovrf->num_traks; i++) {
    TrakRecovData *trak = &(moovrf->traks_rd[i]);
    guint trak_data_size;
    guint32 stbl_new_size;
    guint32 minf_new_size;
    guint32 mdia_new_size;
    guint32 trak_new_size;
    guint32 size_diff;
    guint32 duration;           /* in moov's timescale */

    /* convert trak duration to moov's duration */
    duration = gst_util_uint64_scale_round (trak->duration, moovrf->timescale,
        trak->timescale);

    stbl_children = moov_recov_get_stbl_children_data (moovrf, trak,
        &stbl_children_size);
    if (stbl_children == NULL)
      goto fail;

    /* calc the new size of the atoms from stbl to trak in the atoms tree */
    stbl_new_size = trak->stsd_size + stbl_children_size + 8;
    size_diff = stbl_new_size - trak->stbl_size;
    minf_new_size = trak->minf_size + size_diff;
    mdia_new_size = trak->mdia_size + size_diff;
    trak_new_size = trak->trak_size + size_diff;

    if (fseek (moovrf->file, trak->file_offset, SEEK_SET) != 0)
      goto fail;
    trak_data_size = trak->post_stsd_offset - trak->file_offset;
    trak_data = g_malloc (trak_data_size);
    if (fread (trak_data, 1, trak_data_size, moovrf->file) != trak_data_size) {
      goto fail;
    }
    /* update the size values in those read atoms before writing */
    GST_WRITE_UINT32_BE (trak_data, trak_new_size);
    GST_WRITE_UINT32_BE (trak_data + (trak->mdia_file_offset -
            trak->file_offset), mdia_new_size);
    GST_WRITE_UINT32_BE (trak_data + (trak->minf_file_offset -
            trak->file_offset), minf_new_size);
    GST_WRITE_UINT32_BE (trak_data + (trak->stbl_file_offset -
            trak->file_offset), stbl_new_size);

    /* update duration values in tkhd and mdhd */
    GST_WRITE_UINT32_BE (trak_data + (trak->tkhd_file_offset -
            trak->file_offset) + 28, duration);
    GST_WRITE_UINT32_BE (trak_data + (trak->mdhd_file_offset -
            trak->file_offset) + 24, trak->duration);

    if (fwrite (trak_data, 1, trak_data_size, outf) != trak_data_size) {
      ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
      goto fail;
    }
    if (fwrite (stbl_children, 1, stbl_children_size, outf) !=
        stbl_children_size) {
      ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
      goto fail;
    }
    g_free (trak_data);
    trak_data = NULL;
    g_free (stbl_children);
    stbl_children = NULL;
  }

  /* write the mdat */
  /* write the header first */
  GST_WRITE_UINT32_BE (auxdata, 1);
  GST_WRITE_UINT32_LE (auxdata + 4, FOURCC_mdat);
  GST_WRITE_UINT64_BE (auxdata + 8, mdatrf->mdat_size);
  if (fwrite (auxdata, 1, 16, outf) != 16) {
    ATOMS_RECOV_OUTPUT_WRITE_ERROR (err);
    goto fail;
  }

  /* now read the mdat data and output to the file */
  if (fseek (mdatrf->file, mdatrf->mdat_start +
          (mdatrf->rawfile ? 0 : mdatrf->mdat_header_size), SEEK_SET) != 0)
    goto fail;

  data = g_malloc (4096);
  while (!feof (mdatrf->file)) {
    gint read, write;

    read = fread (data, 1, 4096, mdatrf->file);
    write = fwrite (data, 1, read, outf);

    if (write != read) {
      g_set_error (err, ATOMS_RECOV_QUARK, ATOMS_RECOV_ERR_FILE,
          "Failed to copy data to output file: %s", g_strerror (errno));
      goto fail;
    }
  }
  g_free (data);

  return TRUE;

fail:
  g_free (stbl_children);
  g_free (mvhd_data);
  g_free (prefix_data);
  g_free (trak_data);
  g_free (data);
  return FALSE;
}
