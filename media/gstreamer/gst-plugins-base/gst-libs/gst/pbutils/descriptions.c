/* GStreamer Plugins Base utils library source/sink/codec description support
 * Copyright (C) 2006 Tim-Philipp Müller <tim centricular net>
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

/**
 * SECTION:gstpbutilsdescriptions
 * @short_description: Provides human-readable descriptions for caps/codecs
 * and encoder, decoder, URI source and URI sink elements
 *
 * <refsect2>
 * <para>
 * The above functions provide human-readable strings for media formats
 * and decoder/demuxer/depayloader/encoder/muxer/payloader elements for use
 * in error dialogs or other messages shown to users.
 * </para>
 * <para>
 * gst_pb_utils_add_codec_description_to_tag_list() is a utility function
 * for demuxer and decoder elements to add audio/video codec tags from a
 * given (fixed) #GstCaps.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "gst/gst-i18n-plugin.h"

#include <gst/audio/audio.h>
#include <gst/video/video.h>

#include "pbutils.h"
#include "pbutils-private.h"

#include <string.h>

typedef enum
{
  FLAG_SYSTEMSTREAM = (1 << 0), /* match record only if caps have systemstream=true   */
  FLAG_CONTAINER = (1 << 1),    /* format is a container format (muxed)               */
  FLAG_AUDIO = (1 << 2),        /* format is an audio format, or audio container/tag  */
  FLAG_VIDEO = (1 << 3),        /* format is a video format, or video container/tag   */
  FLAG_IMAGE = (1 << 4),        /* format is an image format, or image container/tag  */
  FLAG_SUB = (1 << 5),          /* format is a subtitle format, or subtitle container */
  FLAG_TAG = (1 << 6),          /* format is a tag/container                          */
  FLAG_GENERIC = (1 << 7)       /* format is a generic container (e.g. multipart)     */
} FormatFlags;

typedef struct
{
  const gchar *type;
  const gchar *desc;
  FormatFlags flags:24;
  gchar ext[5];                 /* file extension */
} FormatInfo;

#define AV_CONTAINER    (FLAG_CONTAINER | FLAG_AUDIO | FLAG_VIDEO)
#define AVS_CONTAINER   (AV_CONTAINER | FLAG_SUB)
#define AVI_CONTAINER   (AV_CONTAINER | FLAG_IMAGE)
#define AVIS_CONTAINER  (AV_CONTAINER | FLAG_IMAGE | FLAG_SUB)
#define AUDIO_CONTAINER (FLAG_CONTAINER | FLAG_AUDIO)
#define VIDEO_CONTAINER (FLAG_CONTAINER | FLAG_VIDEO)
#define AUDIO_TAG       (AUDIO_CONTAINER | FLAG_TAG)

static const FormatInfo formats[] = {
  /* container/tag formats with static descriptions */
  /* FIXME: does anyone use oga in practice? */
  {"audio/ogg", "Ogg", AUDIO_CONTAINER, "ogg"},
  {"audio/webm", "WebM", AUDIO_CONTAINER, "webm"},
  {"audio/x-matroska", "Matroska", AUDIO_CONTAINER, "mka"},
  {"application/gxf", "General Exchange Format (GXF)", AVI_CONTAINER, "gxf"},
  {"application/ogg", "Ogg", AVIS_CONTAINER, "ogg"},
  {"application/kate", "Ogg", FLAG_CONTAINER | FLAG_SUB, "ogg"},
  {"application/mxf", "Material eXchange Format (MXF)", AVIS_CONTAINER, "mxf"},
  {"application/vnd.rn-realmedia", "Realmedia", AV_CONTAINER, "rm"},
  {"application/x-id3", N_("ID3 tag"), AUDIO_TAG, ""},
  {"application/x-ape", N_("APE tag"), AUDIO_TAG, ""},
  {"application/x-apetag", N_("APE tag"), AUDIO_TAG, ""},
  {"application/x-icy", N_("ICY internet radio"), AUDIO_TAG, ""},
  {"application/x-3gp", "3GP", AV_CONTAINER, "3gp"},
  {"application/x-pn-realaudio", "RealAudio", AUDIO_CONTAINER, "ra"},
  {"application/x-yuv4mpeg", "Y4M", VIDEO_CONTAINER, "y4m"},
  {"multipart/x-mixed-replace", "Multipart", FLAG_CONTAINER | FLAG_GENERIC, ""},
  {"video/ogg", "Ogg", AVIS_CONTAINER, "ogv"},
  {"video/x-fli", "FLI/FLC/FLX Animation", VIDEO_CONTAINER, "fli"},
  {"video/x-flv", "Flash", AV_CONTAINER, "flv"},
  {"video/x-matroska", "Matroska", AVIS_CONTAINER, "mkv"},
  /* FIXME: does anyone use .mk3d in practice, rather than .mkv? */
  {"video/x-matroska-3d", "Matroska", AVIS_CONTAINER, "mk3d"},
  {"video/webm", "WebM", AVS_CONTAINER, "webm"},
  {"video/x-ms-asf", "Advanced Streaming Format (ASF)", AVIS_CONTAINER, "asf"},
  {"video/x-msvideo", "Audio Video Interleave (AVI)", AVIS_CONTAINER, "avi"},
  {"video/x-quicktime", "Quicktime", AVIS_CONTAINER, "mov"},
  {"video/quicktime", "Quicktime", AVIS_CONTAINER, "mov"},
  {"video/mj2", "Motion JPEG 2000", AVIS_CONTAINER, "mj2"},

  /* audio formats with static descriptions */
  {"audio/x-ac3", "AC-3 (ATSC A/52)", FLAG_AUDIO, "ac3"},
  {"audio/ac3", "AC-3 (ATSC A/52)", FLAG_AUDIO, "ac3"},
  {"audio/x-private-ac3", "DVD AC-3 (ATSC A/52)", FLAG_AUDIO, "ac3"},
  {"audio/x-private1-ac3", "DVD AC-3 (ATSC A/52)", FLAG_AUDIO, "ac3"},
  {"audio/x-alaw", "A-Law", FLAG_AUDIO, ""},
  {"audio/amr", "Adaptive Multi Rate (AMR)", FLAG_AUDIO, "amr"},
  {"audio/AMR", "Adaptive Multi Rate (AMR)", FLAG_AUDIO, "amr"},
  {"audio/AMR-WB", "Adaptive Multi Rate WideBand (AMR-WB)", FLAG_AUDIO, "amr"},
  {"audio/iLBC-sh", "Internet Low Bitrate Codec (iLBC)", AUDIO_CONTAINER,
      "ilbc"},
  {"audio/ms-gsm", "MS GSM", FLAG_AUDIO, "gsm"},
  {"audio/qcelp", "QCELP", FLAG_AUDIO, ""},
  {"audio/aiff", "Audio Interchange File Format (AIFF)", AUDIO_CONTAINER,
      "aiff"},
  {"audio/x-aiff", "Audio Interchange File Format (AIFF)", AUDIO_CONTAINER,
      "aiff"},
  {"audio/x-alac", N_("Apple Lossless Audio (ALAC)"), FLAG_AUDIO, ""},
  {"audio/x-amr-nb-sh", "Adaptive Multi Rate NarrowBand (AMR-NB)",
      AUDIO_CONTAINER, "amr"},
  {"audio/x-amr-wb-sh", "Adaptive Multi Rate WideBand (AMR-WB)",
      AUDIO_CONTAINER, "amr"},
  {"audio/x-au", "Sun .au", AUDIO_CONTAINER, "au"},
  {"audio/x-celt", "Constrained Energy Lapped Transform (CELT)", FLAG_AUDIO,
      ""},
  {"audio/x-cinepak", "Cinepak Audio", FLAG_AUDIO, ""},
  {"audio/x-dpcm", "DPCM", FLAG_AUDIO, ""},
  {"audio/x-dts", "DTS", FLAG_AUDIO, "dts"},
  {"audio/x-private1-dts", "DTS", FLAG_AUDIO, "dts"},
  {"audio/x-dv", "DV Audio", FLAG_AUDIO, ""},
  {"audio/x-eac3", "E-AC-3 (ATSC A/52B)", FLAG_AUDIO, "eac3"},
  {"audio/x-flac", N_("Free Lossless Audio Codec (FLAC)"), FLAG_AUDIO, "flac"},
  {"audio/x-gsm", "GSM", FLAG_AUDIO, "gsm"},
  {"audio/x-iec958", "S/PDIF IEC958", 0, ""},   /* TODO: check description */
  {"audio/x-iLBC", "Internet Low Bitrate Codec (iLBC)", FLAG_AUDIO, "ilbc"},
  {"audio/x-ircam", "Berkeley/IRCAM/CARL", FLAG_AUDIO, ""},
  {"audio/x-lpcm", "LPCM", FLAG_AUDIO, ""},
  {"audio/x-private1-lpcm", "DVD LPCM", FLAG_AUDIO, ""},
  {"audio/x-m4a", "MPEG-4 AAC", FLAG_CONTAINER, "m4a"},
  {"audio/x-mod", "Module Music Format (MOD)", FLAG_AUDIO, "mod"},
  {"audio/x-mulaw", "Mu-Law", FLAG_AUDIO, ""},
  {"audio/x-musepack", "Musepack (MPC)", FLAG_AUDIO, "mpc"},
  {"audio/x-nellymoser", "Nellymoser Asao", FLAG_AUDIO, ""},
  {"audio/x-nist", "Sphere NIST", FLAG_AUDIO, ""},
  {"audio/x-nsf", "Nintendo NSF", FLAG_AUDIO, ""},
  {"audio/x-opus", "Opus", FLAG_AUDIO, ""},
  {"audio/x-paris", "Ensoniq PARIS", FLAG_AUDIO, ""},
  {"audio/x-qdm", "QDesign Music (QDM)", FLAG_AUDIO, ""},
  {"audio/x-qdm2", "QDesign Music (QDM) 2", FLAG_AUDIO, ""},
  {"audio/x-ralf-mpeg4-generic", "Real Audio Lossless (RALF)", FLAG_AUDIO, ""},
  {"audio/x-rf64", "Broadcast Wave Format", AUDIO_CONTAINER, "rf64"},
  {"audio/x-sbc", "Low Complexity Subband Coding", FLAG_AUDIO, "sbc"},
  {"audio/x-sds", "Midi Sample Dump Standard", FLAG_AUDIO, ""},
  {"audio/x-shorten", "Shorten Lossless", FLAG_AUDIO, "shn"},
  {"audio/x-sid", "Sid", FLAG_AUDIO, "sid"},
  {"audio/x-sipro", "Sipro/ACELP.NET Voice", FLAG_AUDIO, ""},
  {"audio/x-siren", "Siren", FLAG_AUDIO, ""},
  {"audio/x-spc", "SNES-SPC700 Sound File Data", FLAG_AUDIO, "spc"},
  {"audio/x-speex", "Speex", FLAG_AUDIO, ""},
  {"audio/x-svx", "Amiga IFF / SVX8 / SV16", FLAG_AUDIO, ""},
  {"audio/x-true-hd", "Dolby TrueHD", FLAG_AUDIO, ""},
  {"audio/x-tta", N_("Lossless True Audio (TTA)"), FLAG_AUDIO, "tta"},
  {"audio/x-ttafile", N_("Lossless True Audio (TTA)"), FLAG_AUDIO, "tta"},
  {"audio/x-vnd.sony.atrac3", "Sony ATRAC3", FLAG_AUDIO, ""},
  {"audio/x-vorbis", "Vorbis", FLAG_AUDIO, ""},
  {"audio/x-voc", "SoundBlaster VOC", FLAG_AUDIO, ""},
  {"audio/x-w64", "Sonic Foundry Wave64", AUDIO_CONTAINER, "w64"},
  {"audio/x-wav", "WAV", AUDIO_CONTAINER, "wav"},
  {"audio/x-wavpack", "Wavpack", FLAG_AUDIO, "wp"},
  {"audio/x-wavpack-correction", "Wavpack", 0, "wpc"},
  {"audio/x-wms", N_("Windows Media Speech"), FLAG_AUDIO, ""},
  {"audio/x-voxware", "Voxware", FLAG_AUDIO, ""},
  {"audio/x-xi", "Fasttracker 2 Extended Instrument", FLAG_AUDIO, "xi"},


  /* video formats with static descriptions */
  {"video/sp5x", "Sunplus JPEG 5.x", FLAG_VIDEO, ""},
  {"video/vivo", "Vivo", FLAG_VIDEO, ""},
  {"video/x-4xm", "4X Technologies Video", FLAG_VIDEO, ""},
  {"video/x-apple-video", "Apple video", FLAG_VIDEO, ""},
  {"video/x-aasc", "Autodesk Animator", FLAG_VIDEO, ""},
  {"video/x-camtasia", "TechSmith Camtasia", FLAG_VIDEO, ""},
  {"video/x-cdxa", "RIFF/CDXA (VCD)", AV_CONTAINER, ""},
  {"video/x-cinepak", "Cinepak Video", FLAG_VIDEO, ""},
  {"video/x-cirrus-logic-accupak", "Cirrus Logipak AccuPak", FLAG_VIDEO, ""},
  {"video/x-compressed-yuv", N_("CYUV Lossless"), FLAG_VIDEO, ""},
  {"video/x-dirac", "Dirac", FLAG_VIDEO, ""},
  {"video/x-dnxhd", "Digital Nonlinear Extensible High Definition (DNxHD)",
      FLAG_VIDEO, ""},
  {"subpicture/x-dvd", "DVD subpicture", FLAG_VIDEO, ""},
  {"video/x-ffv", N_("FFMpeg v1"), FLAG_VIDEO, ""},
  {"video/x-flash-screen", "Flash Screen Video", FLAG_VIDEO, ""},
  {"video/x-flash-video", "Sorenson Spark Video", FLAG_VIDEO, ""},
  {"video/x-h261", "H.261", FLAG_VIDEO, ""},
  {"video/x-huffyuv", "Huffyuv", FLAG_VIDEO, ""},
  {"video/x-intel-h263", "Intel H.263", FLAG_VIDEO, ""},
  {"video/x-jpeg", "Motion JPEG", FLAG_VIDEO, ""},
  /* { "video/x-jpeg-b", "", 0 }, does this actually exist? */
  {"video/x-loco", "LOCO Lossless", FLAG_VIDEO, ""},
  {"video/x-mimic", "MIMIC", FLAG_VIDEO, ""},
  {"video/x-mjpeg", "Motion-JPEG", FLAG_VIDEO, ""},
  {"video/x-mjpeg-b", "Motion-JPEG format B", FLAG_VIDEO, ""},
  {"video/mpegts", "MPEG-2 Transport Stream", AVS_CONTAINER, "ts"},
  {"video/x-mng", "Multiple Image Network Graphics (MNG)", FLAG_VIDEO, ""},
  {"video/x-mszh", N_("Lossless MSZH"), FLAG_VIDEO, ""},
  {"video/x-msvideocodec", "Microsoft Video 1", FLAG_VIDEO, ""},
  {"video/x-mve", "Interplay MVE", AV_CONTAINER, "mve"},
  {"video/x-nut", "NUT", AV_CONTAINER, "nut"},
  {"video/x-nuv", "MythTV NuppelVideo (NUV)", AV_CONTAINER, "nuv"},
  {"video/x-prores", "Apple ProRes", FLAG_VIDEO, ""},
  {"video/x-qdrw", "Apple QuickDraw", FLAG_VIDEO, ""},
  {"video/x-smc", "Apple SMC", FLAG_VIDEO, ""},
  {"video/x-smoke", "Smoke", FLAG_VIDEO, ""},
  {"video/x-tarkin", "Tarkin", FLAG_VIDEO, ""},
  {"video/x-theora", "Theora", FLAG_VIDEO, ""},
  {"video/x-rle", N_("Run-length encoding"), FLAG_VIDEO, ""},
  {"video/x-ultimotion", "IBM UltiMotion", FLAG_VIDEO, ""},
  {"video/x-vcd", "VideoCD (VCD)", 0},
  {"video/x-vmnc", "VMWare NC", FLAG_VIDEO, ""},
  {"video/x-vp3", "On2 VP3", FLAG_VIDEO, ""},
  {"video/x-vp5", "On2 VP5", FLAG_VIDEO, ""},
  {"video/x-vp6", "On2 VP6", FLAG_VIDEO, ""},
  {"video/x-vp6-flash", "On2 VP6/Flash", FLAG_VIDEO, ""},
  {"video/x-vp6-alpha", "On2 VP6 with alpha", FLAG_VIDEO, ""},
  {"video/x-vp7", "On2 VP7", FLAG_VIDEO, ""},
  {"video/x-vp8", "VP8", FLAG_VIDEO, ""},
  {"video/x-vp9", "VP9", FLAG_VIDEO, ""},
  {"video/x-zlib", "Lossless zlib video", FLAG_VIDEO, ""},
  {"video/x-zmbv", "Zip Motion Block video", FLAG_VIDEO, ""},

  /* image formats with static descriptions */
  {"image/bmp", "BMP", FLAG_IMAGE, "bmp"},
  {"image/x-bmp", "BMP", FLAG_IMAGE, "bmp"},
  {"image/x-MS-bmp", "BMP", FLAG_IMAGE, "bmp"},
  {"image/gif", "GIF", FLAG_IMAGE, "gif"},
  {"image/jpeg", "JPEG", FLAG_IMAGE | FLAG_VIDEO, "jpg"},
  {"image/jng", "JPEG Network Graphics (JNG)", FLAG_IMAGE, ""},
  {"image/png", "PNG", FLAG_VIDEO | FLAG_IMAGE, "png"},
  {"image/pbm", "Portable BitMap (PBM)", FLAG_IMAGE, "pbm"},
  {"image/ppm", "Portable PixMap (PPM)", FLAG_IMAGE, "ppm"},
  {"image/svg+xml", "Scalable Vector Graphics (SVG)", FLAG_IMAGE, "svg"},
  {"image/tiff", "TIFF", FLAG_IMAGE, "tiff"},
  {"image/x-cmu-raster", "CMU Raster Format", FLAG_IMAGE, ""},
  {"image/x-degas", "DEGAS", FLAG_IMAGE, ""},
  {"image/x-icon", "ICO", FLAG_IMAGE, "ico"},
  {"image/x-j2c", "JPEG 2000", FLAG_VIDEO | FLAG_IMAGE, ""},
  {"image/x-jpc", "JPEG 2000", FLAG_VIDEO | FLAG_IMAGE, ""},
  {"image/jp2", "JPEG 2000", FLAG_VIDEO | FLAG_IMAGE, ""},
  {"image/x-pcx", "PCX", FLAG_IMAGE, ""},
  {"image/x-xcf", "XFC", FLAG_IMAGE, ""},
  {"image/x-pixmap", "XPM", FLAG_IMAGE, "xpm"},
  {"image/x-portable-anymap", "Portable AnyMap (PNM)", FLAG_IMAGE, "pnm"},
  {"image/x-portable-graymap", "Portable GrayMap (PGM)", FLAG_IMAGE, "pgm"},
  {"image/x-xpixmap", "XPM", FLAG_IMAGE, "xpm"},
  {"image/x-quicktime", "QuickTime Image Format (QTIF)",
      FLAG_IMAGE | FLAG_CONTAINER, ".mov"},
  {"image/x-sun-raster", "Sun Raster Format (RAS)", FLAG_IMAGE, ""},
  {"image/x-tga", "TGA", FLAG_IMAGE, "tga"},
  {"image/vnd.wap.wbmp", "Wireless Bitmap", FLAG_IMAGE, "wbmp"},

  /* subtitle formats with static descriptions */
  {"text/x-raw", N_("Timed Text"), FLAG_SUB, ""},
  {"application/x-ssa", "SubStation Alpha", FLAG_SUB, ""},
  {"application/x-ass", "Advanced SubStation Alpha", FLAG_SUB, ""},
  /* FIXME: add variant field to typefinder? */
  {"application/x-subtitle", N_("Subtitle"), FLAG_SUB, ""},
  {"application/x-subtitle-mpl2", N_("MPL2 subtitle format"), FLAG_SUB, ""},
  {"application/x-subtitle-dks", N_("DKS subtitle format"), FLAG_SUB, ""},
  {"application/x-subtitle-qttext", N_("QTtext subtitle format"), FLAG_SUB, ""},
  {"application/x-subtitle-sami", N_("Sami subtitle format"), FLAG_SUB, ""},
  {"application/x-subtitle-tmplayer", N_("TMPlayer subtitle format"), FLAG_SUB,
      ""},
  {"application/x-teletext", "Teletext", 0, ""},
  {"application/x-kate", "Kate", 0, ""},
  {"subtitle/x-kate", N_("Kate subtitle format"), FLAG_SUB, ""},
  {"subpicture/x-dvb", "DVB subtitles", FLAG_SUB, ""},
  {"subpicture/x-pgs", "PGS subtitles", FLAG_SUB, ""},

  /* non-audio/video/container formats */
  {"hdv/aux-v", "HDV AUX-V", 0, ""},
  {"hdv/aux-a", "HDV AUX-A", 0, ""},

  /* formats with dynamic descriptions */
  {"audio/mpeg", NULL, FLAG_AUDIO, ""},
  {"audio/x-adpcm", NULL, FLAG_AUDIO, ""},
  {"audio/x-mace", NULL, FLAG_AUDIO, ""},
  {"audio/x-pn-realaudio", NULL, FLAG_AUDIO, ""},
  {"audio/x-raw", NULL, FLAG_AUDIO, ""},
  {"audio/x-wma", NULL, FLAG_AUDIO, ""},
  {"video/mpeg", NULL, AVS_CONTAINER | FLAG_SYSTEMSTREAM, "mpg"},
  {"video/mpeg", NULL, FLAG_VIDEO, ""},
  {"video/x-asus", NULL, FLAG_VIDEO, ""},
  {"video/x-ati-vcr", NULL, FLAG_VIDEO, ""},
  {"video/x-divx", NULL, FLAG_VIDEO, ""},
  {"video/x-dv", "Digital Video (DV) System Stream",
      FLAG_CONTAINER | FLAG_SYSTEMSTREAM, "dv"},
  {"video/x-dv", "Digital Video (DV)", FLAG_VIDEO, ""},
  {"video/x-h263", NULL, FLAG_VIDEO, "h263"},
  {"video/x-h264", NULL, FLAG_VIDEO, "h264"},
  {"video/x-h265", NULL, FLAG_VIDEO, "h265"},
  {"video/x-indeo", NULL, FLAG_VIDEO, ""},
  {"video/x-msmpeg", NULL, FLAG_VIDEO, ""},
  {"video/x-pn-realvideo", NULL, FLAG_VIDEO, ""},
#if 0
  /* do these exist? are they used anywhere? */
  {"video/x-pn-multirate-realvideo", NULL, 0},
  {"audio/x-pn-multirate-realaudio", NULL, 0},
  {"audio/x-pn-multirate-realaudio-live", NULL, 0},
#endif
  {"video/x-truemotion", NULL, FLAG_VIDEO, ""},
  {"video/x-raw", NULL, FLAG_VIDEO, ""},
  {"video/x-svq", NULL, FLAG_VIDEO, ""},
  {"video/x-wmv", NULL, FLAG_VIDEO, ""},
  {"video/x-xan", NULL, FLAG_VIDEO, ""},
  {"video/x-tscc", NULL, FLAG_VIDEO, ""}
};

/* returns static descriptions and dynamic ones (such as video/x-raw),
 * or NULL if caps aren't known at all */
static gchar *
format_info_get_desc (const FormatInfo * info, const GstCaps * caps)
{
  const GstStructure *s;

  g_assert (info != NULL);

  if (info->desc != NULL)
    return g_strdup (_(info->desc));

  s = gst_caps_get_structure (caps, 0);

  if (strcmp (info->type, "video/x-raw") == 0) {
    gchar *ret = NULL;
    const gchar *str = 0;
    GstVideoFormat format;
    const GstVideoFormatInfo *finfo;

    str = gst_structure_get_string (s, "format");
    if (str == NULL)
      return g_strdup (_("Uncompressed video"));
    format = gst_video_format_from_string (str);
    if (format == GST_VIDEO_FORMAT_UNKNOWN)
      return g_strdup (_("Uncompressed video"));

    finfo = gst_video_format_get_info (format);

    if (GST_VIDEO_FORMAT_INFO_IS_GRAY (finfo)) {
      ret = g_strdup (_("Uncompressed gray"));
    } else if (GST_VIDEO_FORMAT_INFO_IS_YUV (finfo)) {
      const gchar *subs;
      gint w_sub, h_sub, n_semi;

      w_sub = GST_VIDEO_FORMAT_INFO_W_SUB (finfo, 1);
      h_sub = GST_VIDEO_FORMAT_INFO_H_SUB (finfo, 1);

      if (w_sub == 1 && h_sub == 1) {
        subs = "4:4:4";
      } else if (w_sub == 2 && h_sub == 1) {
        subs = "4:2:2";
      } else if (w_sub == 2 && h_sub == 2) {
        subs = "4:2:0";
      } else if (w_sub == 4 && h_sub == 1) {
        subs = "4:1:1";
      } else {
        subs = "";
      }

      n_semi = GST_VIDEO_FORMAT_INFO_HAS_ALPHA (finfo) ? 3 : 2;

      if (GST_VIDEO_FORMAT_INFO_N_PLANES (finfo) == 1) {
        ret = g_strdup_printf (_("Uncompressed packed YUV %s"), subs);
      } else if (GST_VIDEO_FORMAT_INFO_N_PLANES (finfo) == n_semi) {
        ret = g_strdup_printf (_("Uncompressed semi-planar YUV %s"), subs);
      } else {
        ret = g_strdup_printf (_("Uncompressed planar YUV %s"), subs);
      }
    } else if (GST_VIDEO_FORMAT_INFO_IS_RGB (finfo)) {
      gboolean alpha, palette;
      gint bits;

      alpha = GST_VIDEO_FORMAT_INFO_HAS_ALPHA (finfo);
      palette = GST_VIDEO_FORMAT_INFO_HAS_PALETTE (finfo);
      bits = GST_VIDEO_FORMAT_INFO_BITS (finfo);

      if (palette) {
        ret = g_strdup_printf (_("Uncompressed palettized %d-bit %s"),
            bits, alpha ? "RGBA" : "RGB");
      } else {
        ret = g_strdup_printf (_("Uncompressed %d-bit %s"),
            bits, alpha ? "RGBA" : "RGB");
      }
    } else {
      ret = g_strdup (_("Uncompressed video"));
    }
    return ret;
  } else if (strcmp (info->type, "video/x-h263") == 0) {
    const gchar *variant, *ret;

    variant = gst_structure_get_string (s, "variant");
    if (variant == NULL)
      ret = "H.263";
    else if (strcmp (variant, "itu") == 0)
      ret = "ITU H.26n";        /* why not ITU H.263? (tpm) */
    else if (strcmp (variant, "lead") == 0)
      ret = "Lead H.263";
    else if (strcmp (variant, "microsoft") == 0)
      ret = "Microsoft H.263";
    else if (strcmp (variant, "vdolive") == 0)
      ret = "VDOLive";
    else if (strcmp (variant, "vivo") == 0)
      ret = "Vivo H.263";
    else if (strcmp (variant, "xirlink") == 0)
      ret = "Xirlink H.263";
    else {
      GST_WARNING ("Unknown H263 variant '%s'", variant);
      ret = "H.263";
    }
    return g_strdup (ret);
  } else if (strcmp (info->type, "video/x-h264") == 0) {
    const gchar *variant, *ret;

    variant = gst_structure_get_string (s, "variant");
    if (variant == NULL)
      ret = "H.264";
    else if (strcmp (variant, "itu") == 0)
      ret = "ITU H.264";
    else if (strcmp (variant, "videosoft") == 0)
      ret = "Videosoft H.264";
    else if (strcmp (variant, "lead") == 0)
      ret = "Lead H.264";
    else {
      GST_WARNING ("Unknown H264 variant '%s'", variant);
      ret = "H.264";
    }
    return g_strdup (ret);
  } else if (strcmp (info->type, "video/x-h265") == 0) {
    /* TODO: Any variants? */
    return g_strdup ("H.265");
  } else if (strcmp (info->type, "video/x-divx") == 0) {
    gint ver = 0;

    if (!gst_structure_get_int (s, "divxversion", &ver) || ver <= 2) {
      GST_WARNING ("Unexpected DivX version in %" GST_PTR_FORMAT, caps);
      return g_strdup ("DivX MPEG-4");
    }
    return g_strdup_printf (_("DivX MPEG-4 Version %d"), ver);
  } else if (strcmp (info->type, "video/x-msmpeg") == 0) {
    gint ver = 0;

    if (!gst_structure_get_int (s, "msmpegversion", &ver) ||
        ver < 40 || ver > 49) {
      GST_WARNING ("Unexpected msmpegversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("Microsoft MPEG-4 4.x");
    }
    return g_strdup_printf ("Microsoft MPEG-4 4.%d", ver % 10);
  } else if (strcmp (info->type, "video/x-truemotion") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "trueversion", &ver);
    switch (ver) {
      case 1:
        return g_strdup_printf ("Duck TrueMotion 1");
      case 2:
        return g_strdup_printf ("TrueMotion 2.0");
      default:
        GST_WARNING ("Unexpected trueversion in %" GST_PTR_FORMAT, caps);
        break;
    }
    return g_strdup_printf ("TrueMotion");
  } else if (strcmp (info->type, "video/x-xan") == 0) {
    gint ver = 0;

    if (!gst_structure_get_int (s, "wcversion", &ver) || ver < 1) {
      GST_WARNING ("Unexpected wcversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("Xan Wing Commander");
    }
    return g_strdup_printf ("Xan Wing Commander %u", ver);
  } else if (strcmp (info->type, "video/x-indeo") == 0) {
    gint ver = 0;

    if (!gst_structure_get_int (s, "indeoversion", &ver) || ver < 2) {
      GST_WARNING ("Unexpected indeoversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("Intel Indeo");
    }
    return g_strdup_printf ("Intel Indeo %u", ver);
  } else if (strcmp (info->type, "audio/x-wma") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "wmaversion", &ver);
    switch (ver) {
      case 1:
      case 2:
      case 3:
        return g_strdup_printf ("Windows Media Audio %d", ver + 6);
      default:
        break;
    }
    GST_WARNING ("Unexpected wmaversion in %" GST_PTR_FORMAT, caps);
    return g_strdup ("Windows Media Audio");
  } else if (strcmp (info->type, "video/x-wmv") == 0) {
    gint ver = 0;
    const gchar *str;

    gst_structure_get_int (s, "wmvversion", &ver);
    str = gst_structure_get_string (s, "format");

    switch (ver) {
      case 1:
      case 2:
      case 3:
        if (str && strncmp (str, "MSS", 3)) {
          return g_strdup_printf ("Windows Media Video %d Screen", ver + 6);
        } else {
          return g_strdup_printf ("Windows Media Video %d", ver + 6);
        }
      default:
        break;
    }
    GST_WARNING ("Unexpected wmvversion in %" GST_PTR_FORMAT, caps);
    return g_strdup ("Windows Media Video");
  } else if (strcmp (info->type, "audio/x-mace") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "maceversion", &ver);
    if (ver == 3 || ver == 6) {
      return g_strdup_printf ("MACE-%d", ver);
    } else {
      GST_WARNING ("Unexpected maceversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("MACE");
    }
  } else if (strcmp (info->type, "video/x-svq") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "svqversion", &ver);
    if (ver == 1 || ver == 3) {
      return g_strdup_printf ("Sorensen Video %d", ver);
    } else {
      GST_WARNING ("Unexpected svqversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("Sorensen Video");
    }
  } else if (strcmp (info->type, "video/x-asus") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "asusversion", &ver);
    if (ver == 1 || ver == 2) {
      return g_strdup_printf ("Asus Video %d", ver);
    } else {
      GST_WARNING ("Unexpected asusversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("Asus Video");
    }
  } else if (strcmp (info->type, "video/x-ati-vcr") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "vcrversion", &ver);
    if (ver == 1 || ver == 2) {
      return g_strdup_printf ("ATI VCR %d", ver);
    } else {
      GST_WARNING ("Unexpected acrversion in %" GST_PTR_FORMAT, caps);
      return g_strdup ("ATI VCR");
    }
  } else if (strcmp (info->type, "audio/x-adpcm") == 0) {
    const GValue *layout_val;

    layout_val = gst_structure_get_value (s, "layout");
    if (layout_val != NULL && G_VALUE_HOLDS_STRING (layout_val)) {
      const gchar *layout;

      if ((layout = g_value_get_string (layout_val))) {
        gchar *layout_upper, *ret;

        if (strcmp (layout, "swf") == 0)
          return g_strdup ("Shockwave ADPCM");
        if (strcmp (layout, "microsoft") == 0)
          return g_strdup ("Microsoft ADPCM");
        if (strcmp (layout, "quicktime") == 0)
          return g_strdup ("Quicktime ADPCM");
        if (strcmp (layout, "westwood") == 0)
          return g_strdup ("Westwood ADPCM");
        if (strcmp (layout, "yamaha") == 0)
          return g_strdup ("Yamaha ADPCM");
        /* FIXME: other layouts: sbpro2, sbpro3, sbpro4, ct, g726, ea,
         * adx, xa, 4xm, smjpeg, dk4, dk3, dvi */
        layout_upper = g_ascii_strup (layout, -1);
        ret = g_strdup_printf ("%s ADPCM", layout_upper);
        g_free (layout_upper);
        return ret;
      }
    }
    return g_strdup ("ADPCM");
  } else if (strcmp (info->type, "audio/mpeg") == 0) {
    gint ver = 0, layer = 0;

    gst_structure_get_int (s, "mpegversion", &ver);

    switch (ver) {
      case 1:
        gst_structure_get_int (s, "layer", &layer);
        switch (layer) {
          case 1:
          case 2:
          case 3:
            return g_strdup_printf ("MPEG-1 Layer %d (MP%d)", layer, layer);
          default:
            break;
        }
        GST_WARNING ("Unexpected MPEG-1 layer in %" GST_PTR_FORMAT, caps);
        return g_strdup ("MPEG-1 Audio");
      case 2:
        return g_strdup ("MPEG-2 AAC");
      case 4:
        return g_strdup ("MPEG-4 AAC");
      default:
        break;
    }
    GST_WARNING ("Unexpected audio mpegversion in %" GST_PTR_FORMAT, caps);
    return g_strdup ("MPEG Audio");
  } else if (strcmp (info->type, "audio/x-pn-realaudio") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "raversion", &ver);
    switch (ver) {
      case 1:
        return g_strdup ("RealAudio 14k4bps");
      case 2:
        return g_strdup ("RealAudio 28k8bps");
      case 8:
        return g_strdup ("RealAudio G2 (Cook)");
      default:
        break;
    }
    GST_WARNING ("Unexpected raversion in %" GST_PTR_FORMAT, caps);
    return g_strdup ("RealAudio");
  } else if (strcmp (info->type, "video/x-pn-realvideo") == 0) {
    gint ver = 0;

    gst_structure_get_int (s, "rmversion", &ver);
    switch (ver) {
      case 1:
        return g_strdup ("RealVideo 1.0");
      case 2:
        return g_strdup ("RealVideo 2.0");
      case 3:
        return g_strdup ("RealVideo 3.0");
      case 4:
        return g_strdup ("RealVideo 4.0");
      default:
        break;
    }
    GST_WARNING ("Unexpected rmversion in %" GST_PTR_FORMAT, caps);
    return g_strdup ("RealVideo");
  } else if (strcmp (info->type, "video/mpeg") == 0) {
    gboolean sysstream;
    gint ver = 0;

    if (!gst_structure_get_boolean (s, "systemstream", &sysstream)) {
      GST_WARNING ("Missing systemstream field in mpeg video caps "
          "%" GST_PTR_FORMAT, caps);
      sysstream = FALSE;
    }

    if (gst_structure_get_int (s, "mpegversion", &ver) && ver > 0 && ver <= 4) {
      if (sysstream) {
        return g_strdup_printf ("MPEG-%d System Stream", ver);
      } else {
        return g_strdup_printf ("MPEG-%d Video", ver);
      }
    }
    GST_WARNING ("Missing mpegversion field in mpeg video caps "
        "%" GST_PTR_FORMAT, caps);
    return g_strdup ("MPEG Video");
  } else if (strcmp (info->type, "audio/x-raw") == 0) {
    gint depth = 0;
    gboolean is_float;
    const gchar *str;
    GstAudioFormat format;
    const GstAudioFormatInfo *finfo;

    str = gst_structure_get_string (s, "format");
    format = gst_audio_format_from_string (str);
    if (format == GST_AUDIO_FORMAT_UNKNOWN)
      return g_strdup (_("Uncompressed audio"));

    finfo = gst_audio_format_get_info (format);
    depth = GST_AUDIO_FORMAT_INFO_DEPTH (finfo);
    is_float = GST_AUDIO_FORMAT_INFO_IS_FLOAT (finfo);

    return g_strdup_printf (_("Raw %d-bit %s audio"), depth,
        is_float ? "floating-point" : "PCM");
  } else if (strcmp (info->type, "video/x-tscc") == 0) {
    gint version;
    gst_structure_get_int (s, "tsccversion", &version);
    switch (version) {
      case 1:
        return g_strdup ("TechSmith Screen Capture 1");
      case 2:
        return g_strdup ("TechSmith Screen Capture 2");
      default:
        break;
    }
    GST_WARNING ("Unexpected version in %" GST_PTR_FORMAT, caps);
    return g_strdup ("TechSmith Screen Capture");
  }
  return NULL;
}

/* returns format info structure, will return NULL for dynamic media types! */
static const FormatInfo *
find_format_info (const GstCaps * caps)
{
  const GstStructure *s;
  const gchar *media_type;
  guint i;

  s = gst_caps_get_structure (caps, 0);
  media_type = gst_structure_get_name (s);

  for (i = 0; i < G_N_ELEMENTS (formats); ++i) {
    if (strcmp (media_type, formats[i].type) == 0) {
      gboolean is_sys = FALSE;

      if ((formats[i].flags & FLAG_SYSTEMSTREAM) == 0)
        return &formats[i];

      /* this record should only be matched if the systemstream field is set */
      if (gst_structure_get_boolean (s, "systemstream", &is_sys) && is_sys)
        return &formats[i];
    }
  }

  return NULL;
}

static gboolean
caps_are_rtp_caps (const GstCaps * caps, const gchar * media, gchar ** format)
{
  const GstStructure *s;
  const gchar *str;

  g_assert (media != NULL && format != NULL);

  s = gst_caps_get_structure (caps, 0);
  if (!gst_structure_has_name (s, "application/x-rtp"))
    return FALSE;
  if (!gst_structure_has_field_typed (s, "media", G_TYPE_STRING))
    return FALSE;
  str = gst_structure_get_string (s, "media");
  if (str == NULL || !g_str_equal (str, media))
    return FALSE;
  str = gst_structure_get_string (s, "encoding-name");
  if (str == NULL || *str == '\0')
    return FALSE;

  if (strcmp (str, "X-ASF-PF") == 0) {
    *format = g_strdup ("Windows Media");
  } else if (g_str_has_prefix (str, "X-")) {
    *format = g_strdup (str + 2);
  } else {
    *format = g_strdup (str);
  }

  return TRUE;
}

/**
 * gst_pb_utils_get_source_description:
 * @protocol: the protocol the source element needs to handle, e.g. "http"
 *
 * Returns a localised string describing a source element handling the protocol
 * specified in @protocol, for use in error dialogs or other messages to be
 * seen by the user. Should never return NULL unless @protocol is invalid.
 *
 * This function is mainly for internal use, applications would typically
 * use gst_missing_plugin_message_get_description() to get a description of
 * a missing feature from a missing-plugin message.
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_source_description (const gchar * protocol)
{
  gchar *proto_uc, *ret;

  g_return_val_if_fail (protocol != NULL, NULL);

  if (strcmp (protocol, "cdda") == 0)
    return g_strdup (_("Audio CD source"));

  if (strcmp (protocol, "dvd") == 0)
    return g_strdup (_("DVD source"));

  if (strcmp (protocol, "rtsp") == 0)
    return g_strdup (_("Real Time Streaming Protocol (RTSP) source"));

  /* TODO: what about mmst, mmsu, mmsh? */
  if (strcmp (protocol, "mms") == 0)
    return g_strdup (_("Microsoft Media Server (MMS) protocol source"));

  /* make protocol uppercase */
  proto_uc = g_ascii_strup (protocol, -1);

  /* TODO: find out how to add a comment for translators to the source code
   * (and tell them to make the first letter uppercase below if they move
   * the protocol to the middle or end of the string) */
  ret = g_strdup_printf (_("%s protocol source"), proto_uc);

  g_free (proto_uc);

  return ret;
}

/**
 * gst_pb_utils_get_sink_description:
 * @protocol: the protocol the sink element needs to handle, e.g. "http"
 *
 * Returns a localised string describing a sink element handling the protocol
 * specified in @protocol, for use in error dialogs or other messages to be
 * seen by the user. Should never return NULL unless @protocol is invalid.
 *
 * This function is mainly for internal use, applications would typically
 * use gst_missing_plugin_message_get_description() to get a description of
 * a missing feature from a missing-plugin message.
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_sink_description (const gchar * protocol)
{
  gchar *proto_uc, *ret;

  g_return_val_if_fail (protocol != NULL, NULL);

  /* make protocol uppercase */
  proto_uc = g_ascii_strup (protocol, -1);

  /* TODO: find out how to add a comment for translators to the source code
   * (and tell them to make the first letter uppercase below if they move
   * the protocol to the middle or end of the string) */
  ret = g_strdup_printf ("%s protocol sink", proto_uc);

  g_free (proto_uc);

  return ret;
}

/**
 * gst_pb_utils_get_decoder_description:
 * @caps: the (fixed) #GstCaps for which an decoder description is needed
 *
 * Returns a localised string describing an decoder for the format specified
 * in @caps, for use in error dialogs or other messages to be seen by the user.
 * Should never return NULL unless @factory_name or @caps are invalid.
 *
 * This function is mainly for internal use, applications would typically
 * use gst_missing_plugin_message_get_description() to get a description of
 * a missing feature from a missing-plugin message.
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_decoder_description (const GstCaps * caps)
{
  gchar *str, *ret;
  GstCaps *tmp;

  g_return_val_if_fail (caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (caps), NULL);

  tmp = copy_and_clean_caps (caps);

  g_return_val_if_fail (gst_caps_is_fixed (tmp), NULL);

  /* special-case RTP caps */
  if (caps_are_rtp_caps (tmp, "video", &str)) {
    ret = g_strdup_printf (_("%s video RTP depayloader"), str);
  } else if (caps_are_rtp_caps (tmp, "audio", &str)) {
    ret = g_strdup_printf (_("%s audio RTP depayloader"), str);
  } else if (caps_are_rtp_caps (tmp, "application", &str)) {
    ret = g_strdup_printf (_("%s RTP depayloader"), str);
  } else {
    const FormatInfo *info;

    str = gst_pb_utils_get_codec_description (tmp);
    info = find_format_info (tmp);
    if (info != NULL && (info->flags & FLAG_CONTAINER) != 0) {
      ret = g_strdup_printf (_("%s demuxer"), str);
    } else {
      ret = g_strdup_printf (_("%s decoder"), str);
    }
  }

  g_free (str);
  gst_caps_unref (tmp);

  return ret;
}

/**
 * gst_pb_utils_get_encoder_description:
 * @caps: the (fixed) #GstCaps for which an encoder description is needed
 *
 * Returns a localised string describing an encoder for the format specified
 * in @caps, for use in error dialogs or other messages to be seen by the user.
 * Should never return NULL unless @factory_name or @caps are invalid.
 *
 * This function is mainly for internal use, applications would typically
 * use gst_missing_plugin_message_get_description() to get a description of
 * a missing feature from a missing-plugin message.
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_encoder_description (const GstCaps * caps)
{
  gchar *str, *ret;
  GstCaps *tmp;

  g_return_val_if_fail (caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (caps), NULL);
  tmp = copy_and_clean_caps (caps);
  g_return_val_if_fail (gst_caps_is_fixed (tmp), NULL);

  /* special-case RTP caps */
  if (caps_are_rtp_caps (tmp, "video", &str)) {
    ret = g_strdup_printf (_("%s video RTP payloader"), str);
  } else if (caps_are_rtp_caps (tmp, "audio", &str)) {
    ret = g_strdup_printf (_("%s audio RTP payloader"), str);
  } else if (caps_are_rtp_caps (tmp, "application", &str)) {
    ret = g_strdup_printf (_("%s RTP payloader"), str);
  } else {
    const FormatInfo *info;

    str = gst_pb_utils_get_codec_description (tmp);
    info = find_format_info (tmp);
    if (info != NULL && (info->flags & FLAG_CONTAINER) != 0) {
      ret = g_strdup_printf (_("%s muxer"), str);
    } else {
      ret = g_strdup_printf (_("%s encoder"), str);
    }
  }

  g_free (str);
  gst_caps_unref (tmp);

  return ret;
}

/**
 * gst_pb_utils_get_element_description:
 * @factory_name: the name of the element, e.g. "giosrc"
 *
 * Returns a localised string describing the given element, for use in
 * error dialogs or other messages to be seen by the user. Should never
 * return NULL unless @factory_name is invalid.
 *
 * This function is mainly for internal use, applications would typically
 * use gst_missing_plugin_message_get_description() to get a description of
 * a missing feature from a missing-plugin message.
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_element_description (const gchar * factory_name)
{
  gchar *ret;

  g_return_val_if_fail (factory_name != NULL, NULL);

  ret = g_strdup_printf (_("GStreamer element %s"), factory_name);
  if (ret && g_str_has_prefix (ret, factory_name))
    *ret = g_ascii_toupper (*ret);

  return ret;
}

/**
 * gst_pb_utils_add_codec_description_to_tag_list:
 * @taglist: a #GstTagList
 * @codec_tag: (allow-none): a GStreamer codec tag such as #GST_TAG_AUDIO_CODEC,
 *             #GST_TAG_VIDEO_CODEC or #GST_TAG_CODEC. If none is specified,
 *             the function will attempt to detect the appropriate category.
 * @caps: the (fixed) #GstCaps for which a codec tag should be added.
 *
 * Adds a codec tag describing the format specified by @caps to @taglist.
 *
 * Returns: TRUE if a codec tag was added, FALSE otherwise.
 */
gboolean
gst_pb_utils_add_codec_description_to_tag_list (GstTagList * taglist,
    const gchar * codec_tag, const GstCaps * caps)
{
  const FormatInfo *info;
  gchar *desc;

  g_return_val_if_fail (taglist != NULL, FALSE);
  g_return_val_if_fail (GST_IS_TAG_LIST (taglist), FALSE);
  g_return_val_if_fail (codec_tag == NULL || (gst_tag_exists (codec_tag)
          && gst_tag_get_type (codec_tag) == G_TYPE_STRING), FALSE);
  g_return_val_if_fail (caps != NULL, FALSE);
  g_return_val_if_fail (GST_IS_CAPS (caps), FALSE);

  info = find_format_info (caps);
  if (info == NULL)
    return FALSE;

  /* Attempt to find tag classification */
  if (codec_tag == NULL) {
    if (info->flags & FLAG_CONTAINER)
      codec_tag = GST_TAG_CONTAINER_FORMAT;
    else if (info->flags & FLAG_AUDIO)
      codec_tag = GST_TAG_AUDIO_CODEC;
    else if (info->flags & FLAG_VIDEO)
      codec_tag = GST_TAG_VIDEO_CODEC;
    else if (info->flags & FLAG_SUB)
      codec_tag = GST_TAG_SUBTITLE_CODEC;
    else
      codec_tag = GST_TAG_CODEC;
  }

  desc = format_info_get_desc (info, caps);
  gst_tag_list_add (taglist, GST_TAG_MERGE_REPLACE, codec_tag, desc, NULL);
  g_free (desc);

  return TRUE;
}

/**
 * gst_pb_utils_get_codec_description:
 * @caps: the (fixed) #GstCaps for which an format description is needed
 *
 * Returns a localised (as far as this is possible) string describing the
 * media format specified in @caps, for use in error dialogs or other messages
 * to be seen by the user. Should never return NULL unless @caps is invalid.
 *
 * Also see the convenience function
 * gst_pb_utils_add_codec_description_to_tag_list().
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_pb_utils_get_codec_description (const GstCaps * caps)
{
  const FormatInfo *info;
  gchar *str, *comma;
  GstCaps *tmp;

  g_return_val_if_fail (caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (caps), NULL);
  tmp = copy_and_clean_caps (caps);
  g_return_val_if_fail (gst_caps_is_fixed (tmp), NULL);

  info = find_format_info (tmp);

  if (info) {
    str = format_info_get_desc (info, tmp);
  } else {
    str = gst_caps_to_string (tmp);

    /* cut off everything after the media type, if there is anything */
    if ((comma = strchr (str, ','))) {
      *comma = '\0';
      g_strchomp (str);
      /* we could do something more elaborate here, like taking into account
       * audio/, video/, image/ and application/ prefixes etc. */
    }

    GST_WARNING ("No description available for media type: %s", str);
  }
  gst_caps_unref (tmp);

  return str;
}

/* internal helper functions for gst_encoding_profile_get_file_extension() */
const gchar *pb_utils_get_file_extension_from_caps (const GstCaps * caps);
gboolean pb_utils_is_tag (const GstCaps * caps);

const gchar *
pb_utils_get_file_extension_from_caps (const GstCaps * caps)
{
  const FormatInfo *info;
  const gchar *ext = NULL;
  GstCaps *stripped_caps;

  g_assert (GST_IS_CAPS (caps));

  stripped_caps = copy_and_clean_caps (caps);

  g_assert (gst_caps_is_fixed (stripped_caps));

  info = find_format_info (stripped_caps);

  if (info && info->ext[0] != '\0') {
    ext = info->ext;
  } else if (info && info->desc == NULL) {
    const GstStructure *s;

    s = gst_caps_get_structure (stripped_caps, 0);

    /* cases where we have to evaluate the caps more closely */
    if (strcmp (info->type, "audio/mpeg") == 0) {
      int version = 0, layer = 3;

      if (gst_structure_get_int (s, "mpegversion", &version)) {
        if (version == 2 || version == 4) {
          ext = "aac";
        } else if (version == 1) {
          gst_structure_get_int (s, "layer", &layer);
          if (layer == 1)
            ext = "mp1";
          else if (layer == 2)
            ext = "mp2";
          else
            ext = "mp3";
        }
      }
    }
  }

  gst_caps_unref (stripped_caps);
  return ext;
}

gboolean
pb_utils_is_tag (const GstCaps * caps)
{
  const FormatInfo *info;
  GstCaps *stripped_caps;
  gboolean is_tag = FALSE;

  g_assert (GST_IS_CAPS (caps));

  stripped_caps = copy_and_clean_caps (caps);

  g_assert (gst_caps_is_fixed (stripped_caps));

  info = find_format_info (stripped_caps);

  if (info) {
    is_tag = (info->flags & FLAG_TAG) != 0;
  }
  gst_caps_unref (stripped_caps);

  return is_tag;
}

#if 0
void
gst_pb_utils_list_all (void)
{
  gint i;

  g_print ("static const gchar *caps_strings[] = { ");

  for (i = 0; i < G_N_ELEMENTS (formats); ++i) {
    if (formats[i].desc != NULL)
      g_print ("  \"%s\", ", formats[i].type);
  }
  g_print ("\n#if 0\n");
  for (i = 0; i < G_N_ELEMENTS (formats); ++i) {
    if (formats[i].desc == NULL)
      g_print ("  \"%s\", \n", formats[i].type);
  }
  g_print ("\n#endif\n");
}
#endif
