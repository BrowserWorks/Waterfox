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

#include "gstqtmuxmap.h"
#include "fourcc.h"

/* static info related to various format */

#define COMMON_VIDEO_CAPS \
  "width = (int) [ 16, 4096 ], " \
  "height = (int) [ 16, 4096 ]"

#define COMMON_VIDEO_CAPS_NO_FRAMERATE \
  "width = (int) [ 16, 4096 ], " \
  "height = (int) [ 16, 4096 ] "

#define H263_CAPS \
  "video/x-h263, " \
  COMMON_VIDEO_CAPS

#define H264_CAPS \
  "video/x-h264, " \
  "stream-format = (string) avc, " \
  "alignment = (string) au, " \
  COMMON_VIDEO_CAPS

#define MPEG4V_CAPS \
  "video/mpeg, " \
  "mpegversion = (int) 4, "\
  "systemstream = (boolean) false, " \
  COMMON_VIDEO_CAPS "; " \
  "video/x-divx, " \
  "divxversion = (int) 5, "\
  COMMON_VIDEO_CAPS

#define SVQ_CAPS \
  "video/x-svq, " \
  "svqversion = (int) 3, " \
  COMMON_VIDEO_CAPS

#define COMMON_AUDIO_CAPS(c, r) \
  "channels = (int) [ 1, " G_STRINGIFY (c) " ], " \
  "rate = (int) [ 1, " G_STRINGIFY (r) " ]"

#define PCM_CAPS \
  "audio/x-raw, " \
  "format = (string) { S8, U8 }, " \
  "layout = (string) interleaved, " \
  COMMON_AUDIO_CAPS (2, MAX) "; " \
  "audio/x-raw, " \
  "format = (string) { S16LE, S16BE }, " \
  "layout = (string) interleaved, " \
  COMMON_AUDIO_CAPS (2, MAX)

#define PCM_CAPS_FULL \
  PCM_CAPS "; " \
  "audio/x-raw, " \
  "format = (string) { S24LE, S24BE }, " \
  "layout = (string) interleaved, " \
  COMMON_AUDIO_CAPS (2, MAX) "; " \
  "audio/x-raw, " \
  "format = (string) { S32LE, S32BE }, " \
  "layout = (string) interleaved, " \
  COMMON_AUDIO_CAPS (2, MAX)

#define MP3_CAPS \
  "audio/mpeg, " \
  "mpegversion = (int) 1, " \
  "layer = (int) 3, " \
  COMMON_AUDIO_CAPS (2, MAX)

#define AAC_CAPS \
  "audio/mpeg, " \
  "mpegversion = (int) 4, " \
  "stream-format = (string) raw, " \
  COMMON_AUDIO_CAPS (8, MAX)

#define AMR_CAPS \
  "audio/AMR, " \
  "rate = (int) 8000, " \
  "channels = [ 1, 2 ]; " \
  "audio/AMR-WB, " \
  "rate = (int) 16000, " \
  "channels = [ 1, 2 ] "

#define ADPCM_CAPS  \
  "audio/x-adpcm, " \
  "layout = (string)dvi, " \
  "block_align = (int)[64, 8096], " \
  COMMON_AUDIO_CAPS(2, MAX)

#define ALAC_CAPS \
  "audio/x-alac, " \
  COMMON_AUDIO_CAPS(2, MAX)

#define TEXT_UTF8 \
  "text/x-raw, " \
  "format=(string)utf8"

/* FIXME 0.11 - take a look at bugs #580005 and #340375 */
GstQTMuxFormatProp gst_qt_mux_format_list[] = {
  /* original QuickTime format; see Apple site (e.g. qtff.pdf) */
  {
        GST_QT_MUX_FORMAT_QT,
        GST_RANK_PRIMARY,
        "qtmux",
        "QuickTime",
        "GstQTMux",
        GST_STATIC_CAPS ("video/quicktime, variant = (string) apple; "
            "video/quicktime"),
        GST_STATIC_CAPS ("video/x-raw, "
            "format = (string) { RGB, UYVY }, "
            COMMON_VIDEO_CAPS "; "
            MPEG4V_CAPS "; "
            H263_CAPS "; "
            H264_CAPS "; "
            SVQ_CAPS "; "
            "video/x-dv, "
            "systemstream = (boolean) false, "
            COMMON_VIDEO_CAPS "; "
            "image/jpeg, "
            COMMON_VIDEO_CAPS_NO_FRAMERATE "; "
            "video/x-vp8, "
            COMMON_VIDEO_CAPS "; "
            "video/x-dirac, "
            COMMON_VIDEO_CAPS "; " "video/x-qt-part, " COMMON_VIDEO_CAPS),
        GST_STATIC_CAPS (PCM_CAPS_FULL "; "
            MP3_CAPS " ; "
            AAC_CAPS " ; "
            ADPCM_CAPS " ; "
            "audio/x-alaw, " COMMON_AUDIO_CAPS (2, MAX) "; "
            "audio/x-mulaw, " COMMON_AUDIO_CAPS (2, MAX) "; "
            AMR_CAPS " ; " ALAC_CAPS),
      GST_STATIC_CAPS (TEXT_UTF8)}
  ,
  /* ISO 14496-14: mp42 as ISO base media extension
   * (supersedes original ISO 144996-1 mp41) */
  {
        GST_QT_MUX_FORMAT_MP4,
        GST_RANK_PRIMARY,
        "mp4mux",
        "MP4",
        "GstMP4Mux",
        GST_STATIC_CAPS ("video/quicktime, variant = (string) iso"),
        GST_STATIC_CAPS (MPEG4V_CAPS "; " H264_CAPS ";"
            "video/x-mp4-part," COMMON_VIDEO_CAPS),
        GST_STATIC_CAPS (MP3_CAPS "; " AAC_CAPS " ; " ALAC_CAPS),
      GST_STATIC_CAPS (TEXT_UTF8)}
  ,
  /* Microsoft Smooth Streaming fmp4/isml */
  /* TODO add WMV/WMA support */
  {
        GST_QT_MUX_FORMAT_ISML,
        GST_RANK_PRIMARY,
        "ismlmux",
        "ISML",
        "GstISMLMux",
        GST_STATIC_CAPS ("video/quicktime, variant = (string) iso-fragmented"),
        GST_STATIC_CAPS (MPEG4V_CAPS "; " H264_CAPS),
        GST_STATIC_CAPS (MP3_CAPS "; " AAC_CAPS),
      GST_STATIC_CAPS_NONE}
  ,
  /* 3GPP Technical Specification 26.244 V7.3.0
   * (extended in 3GPP2 File Formats for Multimedia Services) */
  {
        GST_QT_MUX_FORMAT_3GP,
        GST_RANK_PRIMARY,
        "3gppmux",
        "3GPP",
        "Gst3GPPMux",
        GST_STATIC_CAPS ("video/quicktime, variant = (string) 3gpp"),
        GST_STATIC_CAPS (H263_CAPS "; " MPEG4V_CAPS "; " H264_CAPS),
        GST_STATIC_CAPS (AMR_CAPS "; " MP3_CAPS "; " AAC_CAPS),
      GST_STATIC_CAPS (TEXT_UTF8)}
  ,
  /* ISO 15444-3: Motion-JPEG-2000 (also ISO base media extension) */
  {
        GST_QT_MUX_FORMAT_MJ2,
        GST_RANK_PRIMARY,
        "mj2mux",
        "MJ2",
        "GstMJ2Mux",
        GST_STATIC_CAPS ("video/mj2"),
        GST_STATIC_CAPS ("image/x-j2c, " COMMON_VIDEO_CAPS "; "
            "image/x-jpc, " COMMON_VIDEO_CAPS),
        GST_STATIC_CAPS (PCM_CAPS),
      GST_STATIC_CAPS_NONE}
  ,
  {
        GST_QT_MUX_FORMAT_NONE,
      }
};

/* pretty static, but may turn out needed a few times */
AtomsTreeFlavor
gst_qt_mux_map_format_to_flavor (GstQTMuxFormat format)
{
  if (format == GST_QT_MUX_FORMAT_QT)
    return ATOMS_TREE_FLAVOR_MOV;
  else if (format == GST_QT_MUX_FORMAT_3GP)
    return ATOMS_TREE_FLAVOR_3GP;
  else if (format == GST_QT_MUX_FORMAT_ISML)
    return ATOMS_TREE_FLAVOR_ISML;
  else
    return ATOMS_TREE_FLAVOR_ISOM;
}

static void
gst_qt_mux_map_check_tracks (AtomMOOV * moov, gint * _video, gint * _audio,
    gboolean * _has_h264)
{
  GList *it;
  gint video = 0, audio = 0;
  gboolean has_h264 = FALSE;

  for (it = moov->traks; it != NULL; it = g_list_next (it)) {
    AtomTRAK *track = it->data;

    if (track->is_video) {
      video++;
      if (track->is_h264)
        has_h264 = TRUE;
    } else
      audio++;
  }

  if (_video)
    *_video = video;
  if (_audio)
    *_audio = audio;
  if (_has_h264)
    *_has_h264 = has_h264;
}

/* pretty static, but possibly dynamic format info */

/* notes:
 * - avc1 brand is not used, since the specific extensions indicated by it
 *   are not used (e.g. sample groupings, etc)
 * - TODO: maybe even more 3GPP brand fine-tuning ??
 *   (but that might need ftyp rewriting at the end) */
void
gst_qt_mux_map_format_to_header (GstQTMuxFormat format, GstBuffer ** _prefix,
    guint32 * _major, guint32 * _version, GList ** _compatible, AtomMOOV * moov,
    GstClockTime longest_chunk, gboolean faststart)
{
  static guint32 qt_brands[] = { 0 };
  static guint32 mp4_brands[] = { FOURCC_mp41, FOURCC_isom, FOURCC_iso2, 0 };
  static guint32 isml_brands[] = { FOURCC_iso2, 0 };
  static guint32 gpp_brands[] = { FOURCC_isom, FOURCC_iso2, 0 };
  static guint32 mjp2_brands[] = { FOURCC_isom, FOURCC_iso2, 0 };
  static guint8 mjp2_prefix[] =
      { 0, 0, 0, 12, 'j', 'P', ' ', ' ', 0x0D, 0x0A, 0x87, 0x0A };
  guint32 *comp = NULL;
  guint32 major = 0, version = 0;
  GstBuffer *prefix = NULL;
  GList *result = NULL;

  g_return_if_fail (_prefix != NULL);
  g_return_if_fail (_major != NULL);
  g_return_if_fail (_version != NULL);
  g_return_if_fail (_compatible != NULL);

  switch (format) {
    case GST_QT_MUX_FORMAT_QT:
      major = FOURCC_qt__;
      comp = qt_brands;
      version = 0x20050300;
      break;
    case GST_QT_MUX_FORMAT_MP4:
      major = FOURCC_mp42;
      comp = mp4_brands;
      break;
    case GST_QT_MUX_FORMAT_ISML:
      major = FOURCC_isml;
      comp = isml_brands;
      break;
    case GST_QT_MUX_FORMAT_3GP:
    {
      gint video, audio;
      gboolean has_h264;

      gst_qt_mux_map_check_tracks (moov, &video, &audio, &has_h264);
      /* only track restriction really matters for Basic Profile */
      if (video <= 1 && audio <= 1) {
        /* it seems only newer spec knows about H264 */
        major = has_h264 ? FOURCC_3gp6 : FOURCC_3gp4;
        version = has_h264 ? 0x100 : 0x200;
      } else {
        major = FOURCC_3gg6;
        version = 0x100;
      }
      comp = gpp_brands;

      /*
       * We assume that we have chunks in dts order
       */
      if (faststart && longest_chunk <= GST_SECOND) {
        /* add progressive download profile */
        result = g_list_append (result, GUINT_TO_POINTER (FOURCC_3gr6));
      }
      break;
    }
    case GST_QT_MUX_FORMAT_MJ2:
    {
      major = FOURCC_mjp2;
      comp = mjp2_brands;
      version = 0;
      prefix = gst_buffer_new_and_alloc (sizeof (mjp2_prefix));
      gst_buffer_fill (prefix, 0, mjp2_prefix, sizeof (mjp2_prefix));
      break;
    }
    default:
      g_assert_not_reached ();
      break;
  }

  /* convert list to list, hm */
  while (comp && *comp != 0) {
    /* order matters over efficiency */
    result = g_list_append (result, GUINT_TO_POINTER (*comp));
    comp++;
  }

  *_major = major;
  *_version = version;
  *_prefix = prefix;
  *_compatible = result;

  /* TODO 3GPP may include mp42 as compatible if applicable */
  /* TODO 3GPP major brand 3gp7 if at most 1 video and audio track */
}
