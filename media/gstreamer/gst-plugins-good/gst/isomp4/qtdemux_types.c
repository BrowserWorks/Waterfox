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

#include "qtdemux_types.h"
#include "qtdemux_dump.h"
#include "fourcc.h"

static const QtNodeType qt_node_types[] = {
  {FOURCC_moov, "movie", QT_FLAG_CONTAINER,},
  {FOURCC_mvhd, "movie header", 0,
      qtdemux_dump_mvhd},
  {FOURCC_clip, "clipping", QT_FLAG_CONTAINER,},
  {FOURCC_trak, "track", QT_FLAG_CONTAINER,},
  {FOURCC_udta, "user data", QT_FLAG_CONTAINER,},       /* special container */
  {FOURCC_ctab, "color table", 0,},
  {FOURCC_tkhd, "track header", 0,
      qtdemux_dump_tkhd},
  {FOURCC_crgn, "clipping region", 0,},
  {FOURCC_matt, "track matte", QT_FLAG_CONTAINER,},
  {FOURCC_kmat, "compressed matte", 0,},
  {FOURCC_edts, "edit", QT_FLAG_CONTAINER,},
  {FOURCC_elst, "edit list", 0,
      qtdemux_dump_elst},
  {FOURCC_load, "track load settings", 0,},
  {FOURCC_tref, "track reference", QT_FLAG_CONTAINER,},
  {FOURCC_imap, "track input map", QT_FLAG_CONTAINER,},
  {FOURCC___in, "track input", 0,},     /* special container */
  {FOURCC___ty, "input type", 0,},
  {FOURCC_mdia, "media", QT_FLAG_CONTAINER},
  {FOURCC_mdhd, "media header", 0,
      qtdemux_dump_mdhd},
  {FOURCC_hdlr, "handler reference", 0,
      qtdemux_dump_hdlr},
  {FOURCC_minf, "media information", QT_FLAG_CONTAINER},
  {FOURCC_vmhd, "video media information", 0,
      qtdemux_dump_vmhd},
  {FOURCC_smhd, "sound media information", 0},
  {FOURCC_gmhd, "base media information header", 0},
  {FOURCC_gmin, "base media info", 0},
  {FOURCC_dinf, "data information", QT_FLAG_CONTAINER},
  {FOURCC_dref, "data reference", 0,
      qtdemux_dump_dref},
  {FOURCC_stbl, "sample table", QT_FLAG_CONTAINER},
  {FOURCC_stsd, "sample description", 0,
      qtdemux_dump_stsd},
  {FOURCC_stts, "time-to-sample", 0,
      qtdemux_dump_stts},
  {FOURCC_stps, "partial sync sample", 0,
      qtdemux_dump_stps},
  {FOURCC_stss, "sync sample", 0,
      qtdemux_dump_stss},
  {FOURCC_stsc, "sample-to-chunk", 0,
      qtdemux_dump_stsc},
  {FOURCC_stsz, "sample size", 0,
      qtdemux_dump_stsz},
  {FOURCC_stco, "chunk offset", 0,
      qtdemux_dump_stco},
  {FOURCC_co64, "64-bit chunk offset", 0,
      qtdemux_dump_co64},
  {FOURCC_vide, "video media", 0},
  {FOURCC_cmov, "compressed movie", QT_FLAG_CONTAINER},
  {FOURCC_dcom, "compressed data", 0, qtdemux_dump_dcom},
  {FOURCC_cmvd, "compressed movie data", 0, qtdemux_dump_cmvd},
  {FOURCC_hint, "hint", 0,},
  {FOURCC_mp4a, "mp4a", 0,},
  {FOURCC_mp4v, "mp4v", 0,},
  {FOURCC_mjp2, "mjp2", 0,},
  {FOURCC_mhdr, "mhdr", QT_FLAG_CONTAINER,},
  {FOURCC_jp2h, "jp2h", QT_FLAG_CONTAINER,},
  {FOURCC_colr, "colr", 0,},
  {FOURCC_fiel, "fiel", 0,},
  {FOURCC_jp2x, "jp2x", 0,},
  {FOURCC_alac, "alac", 0,},
  {FOURCC_wave, "wave", QT_FLAG_CONTAINER},
  {FOURCC_appl, "appl", QT_FLAG_CONTAINER},
  {FOURCC_esds, "esds", 0},
  {FOURCC_hnti, "hnti", QT_FLAG_CONTAINER},
  {FOURCC_rtp_, "rtp ", 0, qtdemux_dump_unknown},
  {FOURCC_sdp_, "sdp ", 0, qtdemux_dump_unknown},
  {FOURCC_meta, "meta", 0, qtdemux_dump_unknown},
  {FOURCC_ilst, "ilst", QT_FLAG_CONTAINER,},
  {FOURCC__nam, "Name", QT_FLAG_CONTAINER,},
  {FOURCC_titl, "Title", QT_FLAG_CONTAINER,},
  {FOURCC__ART, "Artist", QT_FLAG_CONTAINER,},
  {FOURCC_aART, "Album Artist", QT_FLAG_CONTAINER,},
  {FOURCC_auth, "Author", QT_FLAG_CONTAINER,},
  {FOURCC_perf, "Performer", QT_FLAG_CONTAINER,},
  {FOURCC__wrt, "Writer", QT_FLAG_CONTAINER,},
  {FOURCC__grp, "Grouping", QT_FLAG_CONTAINER,},
  {FOURCC__alb, "Album", QT_FLAG_CONTAINER,},
  {FOURCC_albm, "Album", QT_FLAG_CONTAINER,},
  {FOURCC__day, "Date", QT_FLAG_CONTAINER,},
  {FOURCC__cpy, "Copyright", QT_FLAG_CONTAINER,},
  {FOURCC__cmt, "Comment", QT_FLAG_CONTAINER,},
  {FOURCC__des, "Description", QT_FLAG_CONTAINER,},
  {FOURCC_desc, "Description", QT_FLAG_CONTAINER,},
  {FOURCC_dscp, "Description", QT_FLAG_CONTAINER,},
  {FOURCC__lyr, "Lyrics", QT_FLAG_CONTAINER,},
  {FOURCC__req, "Requirement", QT_FLAG_CONTAINER,},
  {FOURCC__enc, "Encoder", QT_FLAG_CONTAINER,},
  {FOURCC_gnre, "Genre", QT_FLAG_CONTAINER,},
  {FOURCC_trkn, "Track Number", QT_FLAG_CONTAINER,},
  {FOURCC_disc, "Disc Number", QT_FLAG_CONTAINER,},
  {FOURCC_disk, "Disc Number", QT_FLAG_CONTAINER,},
  {FOURCC_cprt, "Copyright", QT_FLAG_CONTAINER,},
  {FOURCC_cpil, "Compilation", QT_FLAG_CONTAINER,},
  {FOURCC_pgap, "Gapless", QT_FLAG_CONTAINER,},
  {FOURCC_pcst, "Podcast", QT_FLAG_CONTAINER,},
  {FOURCC_tmpo, "Tempo", QT_FLAG_CONTAINER,},
  {FOURCC_covr, "Cover", QT_FLAG_CONTAINER,},
  {FOURCC_sonm, "Sort Title", QT_FLAG_CONTAINER,},
  {FOURCC_soal, "Sort Album", QT_FLAG_CONTAINER,},
  {FOURCC_soar, "Sort Artist", QT_FLAG_CONTAINER,},
  {FOURCC_soaa, "Sort Album Artist", QT_FLAG_CONTAINER,},
  {FOURCC_soco, "Sort Composer", QT_FLAG_CONTAINER,},
  {FOURCC_sosn, "Sort TV Show", QT_FLAG_CONTAINER,},
  {FOURCC_tvsh, "TV Show", QT_FLAG_CONTAINER,},
  {FOURCC_tven, "TV Episode ID", QT_FLAG_CONTAINER,},
  {FOURCC_tvsn, "TV Season Number", QT_FLAG_CONTAINER,},
  {FOURCC_tves, "TV Episode Number", QT_FLAG_CONTAINER,},
  {FOURCC_keyw, "Keywords", QT_FLAG_CONTAINER,},
  {FOURCC_kywd, "Keywords", QT_FLAG_CONTAINER,},
  {FOURCC__too, "Encoder", QT_FLAG_CONTAINER,},
  {FOURCC_____, "----", QT_FLAG_CONTAINER,},
  {FOURCC_data, "data", 0, qtdemux_dump_unknown},
  {FOURCC_free, "free", 0,},
  {FOURCC_SVQ3, "SVQ3", 0,},
  {FOURCC_rmra, "rmra", QT_FLAG_CONTAINER,},
  {FOURCC_rmda, "rmda", QT_FLAG_CONTAINER,},
  {FOURCC_rdrf, "rdrf", 0,},
  {FOURCC__gen, "Custom Genre", QT_FLAG_CONTAINER,},
  {FOURCC_ctts, "Composition time to sample", 0, qtdemux_dump_ctts},
  {FOURCC_XiTh, "XiTh", 0},
  {FOURCC_XdxT, "XdxT", 0},
  {FOURCC_loci, "loci", 0},
  {FOURCC_clsf, "clsf", 0},
  {FOURCC_mfra, "movie fragment random access",
      QT_FLAG_CONTAINER,},
  {FOURCC_tfra, "track fragment random access", 0,
      qtdemux_dump_tfra},
  {FOURCC_mfro, "movie fragment random access offset", 0,
      qtdemux_dump_mfro},
  {FOURCC_moof, "movie fragment", QT_FLAG_CONTAINER,},
  {FOURCC_mfhd, "movie fragment header", 0,},
  {FOURCC_traf, "track fragment", QT_FLAG_CONTAINER,},
  {FOURCC_tfhd, "track fragment header", 0,
      qtdemux_dump_tfhd},
  {FOURCC_sdtp, "independent and disposable samples", 0,
      qtdemux_dump_sdtp},
  {FOURCC_trun, "track fragment run", 0, qtdemux_dump_trun},
  {FOURCC_mdat, "moovie data", 0, qtdemux_dump_unknown},
  {FOURCC_trex, "moovie data", 0, qtdemux_dump_trex},
  {FOURCC_mvex, "mvex", QT_FLAG_CONTAINER,},
  {FOURCC_mehd, "movie extends header", 0,
      qtdemux_dump_mehd},
  {FOURCC_ovc1, "ovc1", 0},
  {FOURCC_owma, "owma", 0},
  {FOURCC_avcC, "AV codec configuration container", 0},
  {FOURCC_avc1, "AV codec configuration v1", 0},
  {FOURCC_avc3, "AV codec configuration v3", 0},
  {FOURCC_mp4s, "VOBSUB codec configuration", 0},
  {FOURCC_hvc1, "HEVC codec configuration", 0},
  {FOURCC_hev1, "HEVC codec configuration", 0},
  {FOURCC_hvcC, "HEVC codec configuration container", 0},
  {FOURCC_tfdt, "Track fragment decode time", 0, qtdemux_dump_tfdt},
  {FOURCC_chap, "Chapter Reference"},
  {0, "unknown", 0,},
};

static const int n_qt_node_types =
    sizeof (qt_node_types) / sizeof (qt_node_types[0]);

const QtNodeType *
qtdemux_type_get (guint32 fourcc)
{
  int i;

  for (i = 0; i < n_qt_node_types; i++) {
    if (G_UNLIKELY (qt_node_types[i].fourcc == fourcc))
      return qt_node_types + i;
  }

  GST_WARNING ("unknown QuickTime node type %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (fourcc));

  return qt_node_types + n_qt_node_types - 1;
}
