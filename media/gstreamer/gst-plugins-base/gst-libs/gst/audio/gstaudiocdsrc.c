/* GStreamer Audio CD Source Base Class
 * Copyright (C) 2005 Tim-Philipp Müller <tim centricular net>
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

/* TODO:
 *
 *  - in ::start(), we want to post a tags message with an array or a list
 *    of tagslists of all tracks, so that applications know at least the
 *    number of tracks and all track durations immediately without having
 *    to do any querying. We have to decide what type and name to use for
 *    this array of track taglists.
 *
 *  - FIX cddb discid calculation algorithm for mixed mode CDs - do we use
 *    offsets and duration of ALL tracks (data + audio) for the CDDB ID
 *    calculation, or only audio tracks?
 *
 *  - Do we really need properties for the TOC bias/offset stuff? Wouldn't
 *    environment variables make much more sense? Do we need this at all
 *    (does it only affect ancient hardware?)
 */

/**
 * SECTION:gstaudiocdsrc
 * @short_description: Base class for Audio CD sources
 *
 * <para>
 * Provides a base class for CD digital audio (CDDA) sources, which handles
 * things like seeking, querying, discid calculation, tags, and buffer
 * timestamping.
 * </para>
 * <refsect2>
 * <title>Using GstAudioCdSrc-based elements in applications</title>
 * <para>
 * GstAudioCdSrc registers two #GstFormat<!-- -->s of its own, namely
 * the "track" format and the "sector" format. Applications will usually
 * only find the "track" format interesting. You can retrieve that #GstFormat
 * for use in seek events or queries with gst_format_get_by_nick("track").
 * </para>
 * <para>
 * In order to query the number of tracks, for example, an application would
 * set the CDDA source element to READY or PAUSED state and then query the
 * the number of tracks via gst_element_query_duration() using the track
 * format acquired above. Applications can query the currently playing track
 * in the same way.
 * </para>
 * <para>
 * Alternatively, applications may retrieve the currently playing track and
 * the total number of tracks from the taglist that will posted on the bus
 * whenever the CD is opened or the currently playing track changes. The
 * taglist will contain GST_TAG_TRACK_NUMBER and GST_TAG_TRACK_COUNT tags.
 * </para>
 * <para>
 * Applications playing back CD audio using playbin and cdda://n URIs should
 * issue a seek command in track format to change between tracks, rather than
 * setting a new cdda://n+1 URI on playbin (as setting a new URI on playbin
 * involves closing and re-opening the CD device, which is much much slower).
 * </para>
 * <refsect2>
 * </refsect2>
 * <title>Tags and meta-information</title>
 * <para>
 * CDDA sources will automatically emit a number of tags, details about which
 * can be found in the libgsttag documentation. Those tags are:
 * #GST_TAG_CDDA_CDDB_DISCID, #GST_TAG_CDDA_CDDB_DISCID_FULL,
 * #GST_TAG_CDDA_MUSICBRAINZ_DISCID, #GST_TAG_CDDA_MUSICBRAINZ_DISCID_FULL,
 * among others.
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Tracks and Table of Contents (TOC)</title>
 * <para>
 * Applications will be informed of the available tracks via a TOC message
 * on the pipeline's #GstBus. The #GstToc will contain a #GstTocEntry for
 * each track, with information about each track. The duration for each
 * track can be retrieved via the #GST_TAG_DURATION tag from each entry's
 * tag list, or calculated via gst_toc_entry_get_start_stop_times().
 * The track entries in the TOC will be sorted by track number.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <stdlib.h>             /* for strtol */
#include <stdio.h>

#include <gst/tag/tag.h>
#include <gst/audio/audio.h>
#include "gstaudiocdsrc.h"
#include "gst/gst-i18n-plugin.h"

GST_DEBUG_CATEGORY_STATIC (gst_audio_cd_src_debug);
#define GST_CAT_DEFAULT gst_audio_cd_src_debug

#define DEFAULT_DEVICE                       "/dev/cdrom"

#define CD_FRAMESIZE_RAW                     (2352)

#define SECTORS_PER_SECOND                   (75)
#define SECTORS_PER_MINUTE                   (75*60)
#define SAMPLES_PER_SECTOR                   (CD_FRAMESIZE_RAW >> 2)
#define TIME_INTERVAL_FROM_SECTORS(sectors)  ((SAMPLES_PER_SECTOR * sectors * GST_SECOND) / 44100)
#define SECTORS_FROM_TIME_INTERVAL(dtime)    (dtime * 44100 / (SAMPLES_PER_SECTOR * GST_SECOND))

enum
{
  ARG_0,
  ARG_MODE,
  ARG_DEVICE,
  ARG_TRACK,
  ARG_TOC_OFFSET,
  ARG_TOC_BIAS
};

struct _GstAudioCdSrcPrivate
{
  GstAudioCdSrcMode mode;

  gchar *device;

  guint num_tracks;
  guint num_all_tracks;
  GstAudioCdSrcTrack *tracks;

  gint cur_track;               /* current track (starting from 0) */
  gint prev_track;              /* current track last time         */
  gint cur_sector;              /* current sector                  */
  gint seek_sector;             /* -1 or sector to seek to         */

  gint uri_track;
  gchar *uri;

  guint32 discid;               /* cddb disc id (for unit test)    */
  gchar mb_discid[32];          /* musicbrainz discid              */

#if 0
  GstIndex *index;
  gint index_id;
#endif

  gint toc_offset;
  gboolean toc_bias;

  GstEvent *toc_event;          /* pending TOC event */
  GstToc *toc;
};

static void gst_audio_cd_src_uri_handler_init (gpointer g_iface,
    gpointer iface_data);
static void gst_audio_cd_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_audio_cd_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_audio_cd_src_finalize (GObject * obj);
static gboolean gst_audio_cd_src_query (GstBaseSrc * src, GstQuery * query);
static gboolean gst_audio_cd_src_handle_event (GstBaseSrc * basesrc,
    GstEvent * event);
static gboolean gst_audio_cd_src_do_seek (GstBaseSrc * basesrc,
    GstSegment * segment);
static gboolean gst_audio_cd_src_start (GstBaseSrc * basesrc);
static gboolean gst_audio_cd_src_stop (GstBaseSrc * basesrc);
static GstFlowReturn gst_audio_cd_src_create (GstPushSrc * pushsrc,
    GstBuffer ** buf);
static gboolean gst_audio_cd_src_is_seekable (GstBaseSrc * basesrc);
static void gst_audio_cd_src_update_duration (GstAudioCdSrc * src);
#if 0
static void gst_audio_cd_src_set_index (GstElement * src, GstIndex * index);
static GstIndex *gst_audio_cd_src_get_index (GstElement * src);
#endif

#define gst_audio_cd_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAudioCdSrc, gst_audio_cd_src, GST_TYPE_PUSH_SRC,
    G_IMPLEMENT_INTERFACE (GST_TYPE_URI_HANDLER,
        gst_audio_cd_src_uri_handler_init));

#define SRC_CAPS \
  "audio/x-raw, "               \
  "format = (string) " GST_AUDIO_NE(S16) ", " \
  "layout = (string) interleaved, " \
  "rate = (int) 44100, "            \
  "channels = (int) 2"              \

static GstStaticPadTemplate gst_audio_cd_src_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (SRC_CAPS)
    );

/* our two formats */
static GstFormat track_format;
static GstFormat sector_format;

GType
gst_audio_cd_src_mode_get_type (void)
{
  static GType mode_type;       /* 0 */
  static const GEnumValue modes[] = {
    {GST_AUDIO_CD_SRC_MODE_NORMAL, "Stream consists of a single track",
        "normal"},
    {GST_AUDIO_CD_SRC_MODE_CONTINUOUS, "Stream consists of the whole disc",
        "continuous"},
    {0, NULL, NULL}
  };

  if (mode_type == 0)
    mode_type = g_enum_register_static ("GstAudioCdSrcMode", modes);

  return mode_type;
}

static void
gst_audio_cd_src_class_init (GstAudioCdSrcClass * klass)
{
  GstElementClass *element_class;
  GstPushSrcClass *pushsrc_class;
  GstBaseSrcClass *basesrc_class;
  GObjectClass *gobject_class;

  gobject_class = (GObjectClass *) klass;
  element_class = (GstElementClass *) klass;
  basesrc_class = (GstBaseSrcClass *) klass;
  pushsrc_class = (GstPushSrcClass *) klass;

  GST_DEBUG_CATEGORY_INIT (gst_audio_cd_src_debug, "audiocdsrc", 0,
      "Audio CD source base class");

  g_type_class_add_private (klass, sizeof (GstAudioCdSrcPrivate));

  /* our very own formats */
  track_format = gst_format_register ("track", "CD track");
  sector_format = gst_format_register ("sector", "CD sector");

  /* register CDDA tags */
  gst_tag_register_musicbrainz_tags ();

#if 0
  ///// FIXME: what type to use here? ///////
  gst_tag_register (GST_TAG_CDDA_TRACK_TAGS, GST_TAG_FLAG_META, GST_TYPE_TAG_LIST, "track-tags", "CDDA taglist for one track", gst_tag_merge_use_first);        ///////////// FIXME: right function??? ///////
#endif

  gobject_class->set_property = gst_audio_cd_src_set_property;
  gobject_class->get_property = gst_audio_cd_src_get_property;
  gobject_class->finalize = gst_audio_cd_src_finalize;

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_DEVICE,
      g_param_spec_string ("device", "Device", "CD device location",
          NULL, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_MODE,
      g_param_spec_enum ("mode", "Mode", "Mode", GST_TYPE_AUDIO_CD_SRC_MODE,
          GST_AUDIO_CD_SRC_MODE_NORMAL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TRACK,
      g_param_spec_uint ("track", "Track", "Track", 1, 99, 1,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

#if 0
  /* Do we really need this toc adjustment stuff as properties? does the user
   * have a chance to set it in practice, e.g. when using sound-juicer, rb,
   * totem, whatever? Shouldn't we rather use environment variables
   * for this? (tpm) */

  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TOC_OFFSET,
      g_param_spec_int ("toc-offset", "Table of contents offset",
          "Add <n> sectors to the values reported", G_MININT, G_MAXINT, 0,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (G_OBJECT_CLASS (klass), ARG_TOC_BIAS,
      g_param_spec_boolean ("toc-bias", "Table of contents bias",
          "Assume that the beginning offset of track 1 as reported in the TOC "
          "will be addressed as LBA 0.  Necessary for some Toshiba drives to "
          "get track boundaries", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
#endif

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_audio_cd_src_src_template));

#if 0
  element_class->set_index = GST_DEBUG_FUNCPTR (gst_audio_cd_src_set_index);
  element_class->get_index = GST_DEBUG_FUNCPTR (gst_audio_cd_src_get_index);
#endif

  basesrc_class->start = GST_DEBUG_FUNCPTR (gst_audio_cd_src_start);
  basesrc_class->stop = GST_DEBUG_FUNCPTR (gst_audio_cd_src_stop);
  basesrc_class->query = GST_DEBUG_FUNCPTR (gst_audio_cd_src_query);
  basesrc_class->event = GST_DEBUG_FUNCPTR (gst_audio_cd_src_handle_event);
  basesrc_class->do_seek = GST_DEBUG_FUNCPTR (gst_audio_cd_src_do_seek);
  basesrc_class->is_seekable = GST_DEBUG_FUNCPTR (gst_audio_cd_src_is_seekable);

  pushsrc_class->create = GST_DEBUG_FUNCPTR (gst_audio_cd_src_create);
}

static void
gst_audio_cd_src_init (GstAudioCdSrc * src)
{
  src->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (src, GST_TYPE_AUDIO_CD_SRC,
      GstAudioCdSrcPrivate);

  /* we're not live and we operate in time */
  gst_base_src_set_format (GST_BASE_SRC (src), GST_FORMAT_TIME);
  gst_base_src_set_live (GST_BASE_SRC (src), FALSE);

  GST_OBJECT_FLAG_SET (src, GST_ELEMENT_FLAG_INDEXABLE);

  src->priv->device = NULL;
  src->priv->mode = GST_AUDIO_CD_SRC_MODE_NORMAL;
  src->priv->uri_track = -1;
}

static void
gst_audio_cd_src_finalize (GObject * obj)
{
  GstAudioCdSrc *cddasrc = GST_AUDIO_CD_SRC (obj);

  g_free (cddasrc->priv->uri);
  g_free (cddasrc->priv->device);

#if 0
  if (cddasrc->priv->index)
    gst_object_unref (cddasrc->priv->index);
#endif

  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static void
gst_audio_cd_src_set_device (GstAudioCdSrc * src, const gchar * device)
{
  if (src->priv->device)
    g_free (src->priv->device);
  src->priv->device = NULL;

  if (!device)
    return;

  /* skip multiple slashes */
  while (*device == '/' && *(device + 1) == '/')
    device++;

#ifdef __sun
  /*
   * On Solaris, /dev/rdsk is used for accessing the CD device, but some
   * applications pass in /dev/dsk, so correct.
   */
  if (strncmp (device, "/dev/dsk", 8) == 0) {
    gchar *rdsk_value;
    rdsk_value = g_strdup_printf ("/dev/rdsk%s", device + 8);
    src->priv->device = g_strdup (rdsk_value);
    g_free (rdsk_value);
  } else {
#endif
    src->priv->device = g_strdup (device);
#ifdef __sun
  }
#endif
}

static void
gst_audio_cd_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (object);

  GST_OBJECT_LOCK (src);

  switch (prop_id) {
    case ARG_MODE:{
      src->priv->mode = g_value_get_enum (value);
      break;
    }
    case ARG_DEVICE:{
      const gchar *dev = g_value_get_string (value);

      gst_audio_cd_src_set_device (src, dev);
      break;
    }
    case ARG_TRACK:{
      guint track = g_value_get_uint (value);

      if (src->priv->num_tracks > 0 && track > src->priv->num_tracks) {
        g_warning ("Invalid track %u", track);
      } else if (track > 0 && src->priv->tracks != NULL) {
        src->priv->cur_sector = src->priv->tracks[track - 1].start;
        src->priv->uri_track = track;
      } else {
        src->priv->uri_track = track;   /* seek will be done in start() */
      }
      break;
    }
    case ARG_TOC_OFFSET:{
      src->priv->toc_offset = g_value_get_int (value);
      break;
    }
    case ARG_TOC_BIAS:{
      src->priv->toc_bias = g_value_get_boolean (value);
      break;
    }
    default:{
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
  }

  GST_OBJECT_UNLOCK (src);
}

static void
gst_audio_cd_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
#if 0
  GstAudioCdSrcClass *klass = GST_AUDIO_CD_SRC_GET_CLASS (object);
#endif
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (object);

  GST_OBJECT_LOCK (src);

  switch (prop_id) {
    case ARG_MODE:
      g_value_set_enum (value, src->priv->mode);
      break;
    case ARG_DEVICE:{
#if 0
      if (src->priv->device == NULL && klass->get_default_device != NULL) {
        gchar *d = klass->get_default_device (src);

        if (d != NULL) {
          g_value_set_string (value, DEFAULT_DEVICE);
          g_free (d);
          break;
        }
      }
#endif
      if (src->priv->device == NULL)
        g_value_set_string (value, DEFAULT_DEVICE);
      else
        g_value_set_string (value, src->priv->device);
      break;
    }
    case ARG_TRACK:{
      if (src->priv->num_tracks <= 0 && src->priv->uri_track > 0) {
        g_value_set_uint (value, src->priv->uri_track);
      } else {
        g_value_set_uint (value, src->priv->cur_track + 1);
      }
      break;
    }
    case ARG_TOC_OFFSET:
      g_value_set_int (value, src->priv->toc_offset);
      break;
    case ARG_TOC_BIAS:
      g_value_set_boolean (value, src->priv->toc_bias);
      break;
    default:{
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
  }

  GST_OBJECT_UNLOCK (src);
}

static gint
gst_audio_cd_src_get_track_from_sector (GstAudioCdSrc * src, gint sector)
{
  gint i;

  for (i = 0; i < src->priv->num_tracks; ++i) {
    if (sector >= src->priv->tracks[i].start
        && sector <= src->priv->tracks[i].end)
      return i;
  }
  return -1;
}

static gboolean
gst_audio_cd_src_convert (GstAudioCdSrc * src, GstFormat src_format,
    gint64 src_val, GstFormat dest_format, gint64 * dest_val)
{
  gboolean started;

  GST_LOG_OBJECT (src, "converting value %" G_GINT64_FORMAT " from %s into %s",
      src_val, gst_format_get_name (src_format),
      gst_format_get_name (dest_format));

  if (src_format == dest_format) {
    *dest_val = src_val;
    return TRUE;
  }

  started =
      GST_OBJECT_FLAG_IS_SET (GST_BASE_SRC (src), GST_BASE_SRC_FLAG_STARTED);

  if (src_format == track_format) {
    if (!started)
      goto not_started;
    if (src_val < 0 || src_val >= src->priv->num_tracks) {
      GST_DEBUG_OBJECT (src, "track number %d out of bounds", (gint) src_val);
      goto wrong_value;
    }
    src_format = GST_FORMAT_DEFAULT;
    src_val = src->priv->tracks[src_val].start * (gint64) SAMPLES_PER_SECTOR;
  } else if (src_format == sector_format) {
    src_format = GST_FORMAT_DEFAULT;
    src_val = src_val * SAMPLES_PER_SECTOR;
  }

  if (src_format == dest_format) {
    *dest_val = src_val;
    goto done;
  }

  switch (src_format) {
    case GST_FORMAT_BYTES:
      /* convert to samples (4 bytes per sample) */
      src_val = src_val >> 2;
      /* fallthrough */
    case GST_FORMAT_DEFAULT:{
      switch (dest_format) {
        case GST_FORMAT_BYTES:{
          if (src_val < 0) {
            GST_DEBUG_OBJECT (src, "sample source value negative");
            goto wrong_value;
          }
          *dest_val = src_val << 2;     /* 4 bytes per sample */
          break;
        }
        case GST_FORMAT_TIME:{
          *dest_val = gst_util_uint64_scale_int (src_val, GST_SECOND, 44100);
          break;
        }
        default:{
          gint64 sector = src_val / SAMPLES_PER_SECTOR;

          if (dest_format == sector_format) {
            *dest_val = sector;
          } else if (dest_format == track_format) {
            if (!started)
              goto not_started;
            *dest_val = gst_audio_cd_src_get_track_from_sector (src, sector);
          } else {
            goto unknown_format;
          }
          break;
        }
      }
      break;
    }
    case GST_FORMAT_TIME:{
      gint64 sample_offset;

      if (src_val == GST_CLOCK_TIME_NONE) {
        GST_DEBUG_OBJECT (src, "source time value invalid");
        goto wrong_value;
      }

      sample_offset = gst_util_uint64_scale_int (src_val, 44100, GST_SECOND);
      switch (dest_format) {
        case GST_FORMAT_BYTES:{
          *dest_val = sample_offset << 2;       /* 4 bytes per sample */
          break;
        }
        case GST_FORMAT_DEFAULT:{
          *dest_val = sample_offset;
          break;
        }
        default:{
          gint64 sector = sample_offset / SAMPLES_PER_SECTOR;

          if (dest_format == sector_format) {
            *dest_val = sector;
          } else if (dest_format == track_format) {
            if (!started)
              goto not_started;
            *dest_val = gst_audio_cd_src_get_track_from_sector (src, sector);
          } else {
            goto unknown_format;
          }
          break;
        }
      }
      break;
    }
    default:{
      goto unknown_format;
    }
  }

done:
  {
    GST_LOG_OBJECT (src, "returning %" G_GINT64_FORMAT, *dest_val);
    return TRUE;
  }

unknown_format:
  {
    GST_DEBUG_OBJECT (src, "conversion failed: %s", "unsupported format");
    return FALSE;
  }

wrong_value:
  {
    GST_DEBUG_OBJECT (src, "conversion failed: %s",
        "source value not within allowed range");
    return FALSE;
  }

not_started:
  {
    GST_DEBUG_OBJECT (src, "conversion failed: %s",
        "cannot do this conversion, device not open");
    return FALSE;
  }
}

static gboolean
gst_audio_cd_src_query (GstBaseSrc * basesrc, GstQuery * query)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (basesrc);
  gboolean started;

  started = GST_OBJECT_FLAG_IS_SET (basesrc, GST_BASE_SRC_FLAG_STARTED);

  GST_LOG_OBJECT (src, "handling %s query",
      gst_query_type_get_name (GST_QUERY_TYPE (query)));

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_DURATION:{
      GstFormat dest_format;
      gint64 dest_val;
      guint sectors;

      gst_query_parse_duration (query, &dest_format, NULL);

      if (!started)
        return FALSE;

      g_assert (src->priv->tracks != NULL);

      if (dest_format == track_format) {
        GST_LOG_OBJECT (src, "duration: %d tracks", src->priv->num_tracks);
        gst_query_set_duration (query, track_format, src->priv->num_tracks);
        return TRUE;
      }

      if (src->priv->cur_track < 0
          || src->priv->cur_track >= src->priv->num_tracks)
        return FALSE;

      if (src->priv->mode == GST_AUDIO_CD_SRC_MODE_NORMAL) {
        sectors = src->priv->tracks[src->priv->cur_track].end -
            src->priv->tracks[src->priv->cur_track].start + 1;
      } else {
        sectors = src->priv->tracks[src->priv->num_tracks - 1].end -
            src->priv->tracks[0].start + 1;
      }

      /* ... and convert into final format */
      if (!gst_audio_cd_src_convert (src, sector_format, sectors,
              dest_format, &dest_val)) {
        return FALSE;
      }

      gst_query_set_duration (query, dest_format, dest_val);

      GST_LOG ("duration: %u sectors, %" G_GINT64_FORMAT " in format %s",
          sectors, dest_val, gst_format_get_name (dest_format));
      break;
    }
    case GST_QUERY_POSITION:{
      GstFormat dest_format;
      gint64 pos_sector;
      gint64 dest_val;

      gst_query_parse_position (query, &dest_format, NULL);

      if (!started)
        return FALSE;

      g_assert (src->priv->tracks != NULL);

      if (dest_format == track_format) {
        GST_LOG_OBJECT (src, "position: track %d", src->priv->cur_track);
        gst_query_set_position (query, track_format, src->priv->cur_track);
        return TRUE;
      }

      if (src->priv->cur_track < 0
          || src->priv->cur_track >= src->priv->num_tracks)
        return FALSE;

      if (src->priv->mode == GST_AUDIO_CD_SRC_MODE_NORMAL) {
        pos_sector =
            src->priv->cur_sector -
            src->priv->tracks[src->priv->cur_track].start;
      } else {
        pos_sector = src->priv->cur_sector - src->priv->tracks[0].start;
      }

      if (!gst_audio_cd_src_convert (src, sector_format, pos_sector,
              dest_format, &dest_val)) {
        return FALSE;
      }

      gst_query_set_position (query, dest_format, dest_val);

      GST_LOG ("position: sector %u, %" G_GINT64_FORMAT " in format %s",
          (guint) pos_sector, dest_val, gst_format_get_name (dest_format));
      break;
    }
    case GST_QUERY_CONVERT:{
      GstFormat src_format, dest_format;
      gint64 src_val, dest_val;

      gst_query_parse_convert (query, &src_format, &src_val, &dest_format,
          NULL);

      if (!gst_audio_cd_src_convert (src, src_format, src_val, dest_format,
              &dest_val)) {
        return FALSE;
      }

      gst_query_set_convert (query, src_format, src_val, dest_format, dest_val);
      break;
    }
    default:{
      GST_DEBUG_OBJECT (src, "unhandled query, chaining up to parent class");
      return GST_BASE_SRC_CLASS (parent_class)->query (basesrc, query);
    }
  }

  return TRUE;
}

static gboolean
gst_audio_cd_src_is_seekable (GstBaseSrc * basesrc)
{
  return TRUE;
}

static gboolean
gst_audio_cd_src_do_seek (GstBaseSrc * basesrc, GstSegment * segment)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (basesrc);
  gint64 seek_sector;

  GST_DEBUG_OBJECT (src, "segment %" GST_TIME_FORMAT "-%" GST_TIME_FORMAT,
      GST_TIME_ARGS (segment->start), GST_TIME_ARGS (segment->stop));

  if (!gst_audio_cd_src_convert (src, GST_FORMAT_TIME, segment->start,
          sector_format, &seek_sector)) {
    GST_WARNING_OBJECT (src, "conversion failed");
    return FALSE;
  }

  /* we should only really be called when open */
  g_assert (src->priv->cur_track >= 0
      && src->priv->cur_track < src->priv->num_tracks);

  switch (src->priv->mode) {
    case GST_AUDIO_CD_SRC_MODE_NORMAL:
      seek_sector += src->priv->tracks[src->priv->cur_track].start;
      break;
    case GST_AUDIO_CD_SRC_MODE_CONTINUOUS:
      seek_sector += src->priv->tracks[0].start;
      break;
    default:
      g_return_val_if_reached (FALSE);
  }

  src->priv->cur_sector = (gint) seek_sector;

  GST_DEBUG_OBJECT (src, "seek'd to sector %d", src->priv->cur_sector);

  return TRUE;
}

static gboolean
gst_audio_cd_src_handle_track_seek (GstAudioCdSrc * src, gdouble rate,
    GstSeekFlags flags, GstSeekType start_type, gint64 start,
    GstSeekType stop_type, gint64 stop)
{
  GstBaseSrc *basesrc = GST_BASE_SRC (src);
  GstEvent *event;

  if ((flags & GST_SEEK_FLAG_SEGMENT) == GST_SEEK_FLAG_SEGMENT) {
    gint64 start_time = -1;
    gint64 stop_time = -1;

    if (src->priv->mode != GST_AUDIO_CD_SRC_MODE_CONTINUOUS) {
      GST_DEBUG_OBJECT (src, "segment seek in track format is only "
          "supported in CONTINUOUS mode, not in mode %d", src->priv->mode);
      return FALSE;
    }

    switch (start_type) {
      case GST_SEEK_TYPE_SET:
        if (!gst_audio_cd_src_convert (src, track_format, start,
                GST_FORMAT_TIME, &start_time)) {
          GST_DEBUG_OBJECT (src, "cannot convert track %d to time",
              (gint) start);
          return FALSE;
        }
        break;
      case GST_SEEK_TYPE_END:
        if (!gst_audio_cd_src_convert (src, track_format,
                src->priv->num_tracks - start - 1, GST_FORMAT_TIME,
                &start_time)) {
          GST_DEBUG_OBJECT (src, "cannot convert track %d to time",
              (gint) start);
          return FALSE;
        }
        start_type = GST_SEEK_TYPE_SET;
        break;
      case GST_SEEK_TYPE_NONE:
        start_time = -1;
        break;
      default:
        g_return_val_if_reached (FALSE);
    }

    switch (stop_type) {
      case GST_SEEK_TYPE_SET:
        if (!gst_audio_cd_src_convert (src, track_format, stop,
                GST_FORMAT_TIME, &stop_time)) {
          GST_DEBUG_OBJECT (src, "cannot convert track %d to time",
              (gint) stop);
          return FALSE;
        }
        break;
      case GST_SEEK_TYPE_END:
        if (!gst_audio_cd_src_convert (src, track_format,
                src->priv->num_tracks - stop - 1, GST_FORMAT_TIME,
                &stop_time)) {
          GST_DEBUG_OBJECT (src, "cannot convert track %d to time",
              (gint) stop);
          return FALSE;
        }
        stop_type = GST_SEEK_TYPE_SET;
        break;
      case GST_SEEK_TYPE_NONE:
        stop_time = -1;
        break;
      default:
        g_return_val_if_reached (FALSE);
    }

    GST_LOG_OBJECT (src, "seek segment %" GST_TIME_FORMAT "-%" GST_TIME_FORMAT,
        GST_TIME_ARGS (start_time), GST_TIME_ARGS (stop_time));

    /* send fake segment seek event in TIME format to
     * base class, which will hopefully handle the rest */

    event = gst_event_new_seek (rate, GST_FORMAT_TIME, flags, start_type,
        start_time, stop_type, stop_time);

    return GST_BASE_SRC_CLASS (parent_class)->event (basesrc, event);
  }

  /* not a segment seek */

  if (start_type == GST_SEEK_TYPE_NONE) {
    GST_LOG_OBJECT (src, "start seek type is NONE, nothing to do");
    return TRUE;
  }

  if (stop_type != GST_SEEK_TYPE_NONE) {
    GST_WARNING_OBJECT (src, "ignoring stop seek type (expected NONE)");
  }

  if (start < 0 || start >= src->priv->num_tracks) {
    GST_DEBUG_OBJECT (src, "invalid track %" G_GINT64_FORMAT, start);
    return FALSE;
  }

  GST_DEBUG_OBJECT (src, "seeking to track %" G_GINT64_FORMAT, start + 1);

  src->priv->cur_sector = src->priv->tracks[start].start;
  GST_DEBUG_OBJECT (src, "starting at sector %d", src->priv->cur_sector);

  if (src->priv->cur_track != start) {
    src->priv->cur_track = (gint) start;
    src->priv->uri_track = -1;
    src->priv->prev_track = -1;

    gst_audio_cd_src_update_duration (src);
  } else {
    GST_DEBUG_OBJECT (src, "is current track, just seeking back to start");
  }

  /* send fake segment seek event in TIME format to
   * base class (so we get a newsegment etc.) */
  event = gst_event_new_seek (rate, GST_FORMAT_TIME, flags,
      GST_SEEK_TYPE_SET, 0, GST_SEEK_TYPE_NONE, -1);

  return GST_BASE_SRC_CLASS (parent_class)->event (basesrc, event);
}

static gboolean
gst_audio_cd_src_handle_event (GstBaseSrc * basesrc, GstEvent * event)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (basesrc);
  gboolean ret = FALSE;

  GST_LOG_OBJECT (src, "handling %s event", GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:{
      GstSeekType start_type, stop_type;
      GstSeekFlags flags;
      GstFormat format;
      gdouble rate;
      gint64 start, stop;

      if (!GST_OBJECT_FLAG_IS_SET (basesrc, GST_BASE_SRC_FLAG_STARTED)) {
        GST_DEBUG_OBJECT (src, "seek failed: device not open");
        break;
      }

      gst_event_parse_seek (event, &rate, &format, &flags, &start_type, &start,
          &stop_type, &stop);

      if (format == sector_format) {
        GST_DEBUG_OBJECT (src, "seek in sector format not supported");
        break;
      }

      if (format == track_format) {
        ret = gst_audio_cd_src_handle_track_seek (src, rate, flags,
            start_type, start, stop_type, stop);
      } else {
        GST_LOG_OBJECT (src, "let base class handle seek in %s format",
            gst_format_get_name (format));
        event = gst_event_ref (event);
        ret = GST_BASE_SRC_CLASS (parent_class)->event (basesrc, event);
      }
      break;
    }
    case GST_EVENT_TOC_SELECT:{
      guint track_num = 0;
      gchar *uid = NULL;

      gst_event_parse_toc_select (event, &uid);
      if (uid != NULL && sscanf (uid, "audiocd-track-%03u", &track_num) == 1) {
        ret = gst_audio_cd_src_handle_track_seek (src, 1.0, GST_SEEK_FLAG_FLUSH,
            GST_SEEK_TYPE_SET, track_num, GST_SEEK_TYPE_NONE, -1);
      }
      break;
    }
    default:{
      GST_LOG_OBJECT (src, "let base class handle event");
      ret = GST_BASE_SRC_CLASS (parent_class)->event (basesrc, event);
      break;
    }
  }

  return ret;
}

static GstURIType
gst_audio_cd_src_uri_get_type (GType type)
{
  return GST_URI_SRC;
}

static const gchar *const *
gst_audio_cd_src_uri_get_protocols (GType type)
{
  static const gchar *protocols[] = { "cdda", NULL };

  return protocols;
}

static gchar *
gst_audio_cd_src_uri_get_uri (GstURIHandler * handler)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (handler);

  GST_OBJECT_LOCK (src);

  /* FIXME: can we get rid of all that here and just return a copy of the
   * existing URI perhaps? */
  g_free (src->priv->uri);

  if (GST_OBJECT_FLAG_IS_SET (GST_BASE_SRC (src), GST_BASE_SRC_FLAG_STARTED)) {
    src->priv->uri =
        g_strdup_printf ("cdda://%s#%d", src->priv->device,
        (src->priv->uri_track > 0) ? src->priv->uri_track : 1);
  } else {
    src->priv->uri = g_strdup ("cdda://1");
  }

  GST_OBJECT_UNLOCK (src);

  return g_strdup (src->priv->uri);
}

/* Note: gst_element_make_from_uri() might call us with just 'cdda://' as
 * URI and expects us to return TRUE then (and this might be in any state) */

/* We accept URIs of the format cdda://(device#track)|(track) */

static gboolean
gst_audio_cd_src_uri_set_uri (GstURIHandler * handler, const gchar * uri,
    GError ** error)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (handler);
  const gchar *location;
  gchar *track_number;

  GST_OBJECT_LOCK (src);

  location = uri + 7;
  track_number = g_strrstr (location, "#");
  src->priv->uri_track = 0;
  /* FIXME 0.11: ignore URI fragments that look like device paths for
   * the benefit of rhythmbox and possibly other applications.
   */
  if (track_number && track_number[1] != '/') {
    gchar *device, *nuri = g_strdup (uri);

    track_number = nuri + (track_number - uri);
    *track_number = '\0';
    device = gst_uri_get_location (nuri);
    gst_audio_cd_src_set_device (src, device);
    g_free (device);
    src->priv->uri_track = strtol (track_number + 1, NULL, 10);
    g_free (nuri);
  } else {
    if (*location == '\0')
      src->priv->uri_track = 1;
    else
      src->priv->uri_track = strtol (location, NULL, 10);
  }

  if (src->priv->uri_track < 1)
    goto failed;

  if (src->priv->num_tracks > 0
      && src->priv->tracks != NULL
      && src->priv->uri_track > src->priv->num_tracks)
    goto failed;

  if (src->priv->uri_track > 0 && src->priv->tracks != NULL) {
    GST_OBJECT_UNLOCK (src);

    gst_pad_send_event (GST_BASE_SRC_PAD (src),
        gst_event_new_seek (1.0, track_format, GST_SEEK_FLAG_FLUSH,
            GST_SEEK_TYPE_SET, src->priv->uri_track - 1, GST_SEEK_TYPE_NONE,
            -1));
  } else {
    /* seek will be done in start() */
    GST_OBJECT_UNLOCK (src);
  }

  GST_LOG_OBJECT (handler, "successfully handled uri '%s'", uri);

  return TRUE;

failed:
  {
    GST_OBJECT_UNLOCK (src);
    GST_DEBUG_OBJECT (src, "cannot handle URI '%s'", uri);
    g_set_error_literal (error, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "Could not handle CDDA URI");
    return FALSE;
  }
}

static void
gst_audio_cd_src_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_audio_cd_src_uri_get_type;
  iface->get_uri = gst_audio_cd_src_uri_get_uri;
  iface->set_uri = gst_audio_cd_src_uri_set_uri;
  iface->get_protocols = gst_audio_cd_src_uri_get_protocols;
}

/**
 * gst_audio_cd_src_add_track:
 * @src: a #GstAudioCdSrc
 * @track: address of #GstAudioCdSrcTrack to add
 *
 * CDDA sources use this function from their start vfunc to announce the
 * available data and audio tracks to the base source class. The caller
 * should allocate @track on the stack, the base source will do a shallow
 * copy of the structure (and take ownership of the taglist if there is one).
 *
 * Returns: FALSE on error, otherwise TRUE.
 */

gboolean
gst_audio_cd_src_add_track (GstAudioCdSrc * src, GstAudioCdSrcTrack * track)
{
  g_return_val_if_fail (GST_IS_AUDIO_CD_SRC (src), FALSE);
  g_return_val_if_fail (track != NULL, FALSE);
  g_return_val_if_fail (track->num > 0, FALSE);

  GST_DEBUG_OBJECT (src, "adding track %2u (%2u) [%6u-%6u] [%5s], tags: %"
      GST_PTR_FORMAT, src->priv->num_tracks + 1, track->num, track->start,
      track->end, (track->is_audio) ? "AUDIO" : "DATA ", track->tags);

  if (src->priv->num_tracks > 0) {
    guint end_of_previous_track =
        src->priv->tracks[src->priv->num_tracks - 1].end;

    if (track->start <= end_of_previous_track) {
      GST_WARNING ("track %2u overlaps with previous tracks", track->num);
      return FALSE;
    }
  }

  GST_OBJECT_LOCK (src);

  ++src->priv->num_tracks;
  src->priv->tracks =
      g_renew (GstAudioCdSrcTrack, src->priv->tracks, src->priv->num_tracks);
  src->priv->tracks[src->priv->num_tracks - 1] = *track;

  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

static void
gst_audio_cd_src_update_duration (GstAudioCdSrc * src)
{
  GstBaseSrc *basesrc;
  gint64 dur;

  basesrc = GST_BASE_SRC (src);

  if (!gst_pad_query_duration (GST_BASE_SRC_PAD (src), GST_FORMAT_TIME, &dur)) {
    dur = GST_CLOCK_TIME_NONE;
  }
  basesrc->segment.duration = dur;

  gst_element_post_message (GST_ELEMENT (src),
      gst_message_new_duration_changed (GST_OBJECT (src)));

  GST_LOG_OBJECT (src, "duration updated to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (dur));
}

#define CD_MSF_OFFSET 150

/* the cddb hash function */
static guint
cddb_sum (gint n)
{
  guint ret;

  ret = 0;
  while (n > 0) {
    ret += (n % 10);
    n /= 10;
  }
  return ret;
}

static void
gst_audio_cd_src_calculate_musicbrainz_discid (GstAudioCdSrc * src)
{
  GString *s;
  GChecksum *sha;
  guchar digest[20];
  gchar *ptr;
  gchar tmp[9];
  gulong i;
  unsigned int last_audio_track;
  guint leadout_sector;
  gsize digest_len;

  s = g_string_new (NULL);

  /* MusicBrainz doesn't consider trailing data tracks
   * data tracks up front stay, since the disc has to start with 1 */
  last_audio_track = 0;
  for (i = 0; i < src->priv->num_tracks; i++) {
    if (src->priv->tracks[i].is_audio) {
      last_audio_track = src->priv->tracks[i].num;
    }
  }

  leadout_sector =
      src->priv->tracks[last_audio_track - 1].end + 1 + CD_MSF_OFFSET;

  /* generate SHA digest */
  sha = g_checksum_new (G_CHECKSUM_SHA1);
  g_snprintf (tmp, sizeof (tmp), "%02X", src->priv->tracks[0].num);
  g_string_append_printf (s, "%02X", src->priv->tracks[0].num);
  g_checksum_update (sha, (guchar *) tmp, 2);

  g_snprintf (tmp, sizeof (tmp), "%02X", last_audio_track);
  g_string_append_printf (s, " %02X", last_audio_track);
  g_checksum_update (sha, (guchar *) tmp, 2);

  g_snprintf (tmp, sizeof (tmp), "%08X", leadout_sector);
  g_string_append_printf (s, " %08X", leadout_sector);
  g_checksum_update (sha, (guchar *) tmp, 8);

  for (i = 0; i < 99; i++) {
    if (i < last_audio_track) {
      guint frame_offset = src->priv->tracks[i].start + CD_MSF_OFFSET;

      g_snprintf (tmp, sizeof (tmp), "%08X", frame_offset);
      g_string_append_printf (s, " %08X", frame_offset);
      g_checksum_update (sha, (guchar *) tmp, 8);
    } else {
      g_checksum_update (sha, (guchar *) "00000000", 8);
    }
  }
  digest_len = 20;
  g_checksum_get_digest (sha, (guint8 *) & digest, &digest_len);

  /* re-encode to base64 */
  ptr = g_base64_encode (digest, digest_len);
  g_checksum_free (sha);
  i = strlen (ptr);

  g_assert (i < sizeof (src->priv->mb_discid) + 1);
  memcpy (src->priv->mb_discid, ptr, i);
  src->priv->mb_discid[i] = '\0';
  free (ptr);

  /* Replace '/', '+' and '=' by '_', '.' and '-' as specified on
   * http://musicbrainz.org/doc/DiscIDCalculation
   */
  for (ptr = src->priv->mb_discid; *ptr != '\0'; ptr++) {
    if (*ptr == '/')
      *ptr = '_';
    else if (*ptr == '+')
      *ptr = '.';
    else if (*ptr == '=')
      *ptr = '-';
  }

  GST_DEBUG_OBJECT (src, "musicbrainz-discid      = %s", src->priv->mb_discid);
  GST_DEBUG_OBJECT (src, "musicbrainz-discid-full = %s", s->str);

  gst_tag_list_add (src->tags, GST_TAG_MERGE_REPLACE,
      GST_TAG_CDDA_MUSICBRAINZ_DISCID, src->priv->mb_discid,
      GST_TAG_CDDA_MUSICBRAINZ_DISCID_FULL, s->str, NULL);

  g_string_free (s, TRUE);
}

static void
lba_to_msf (guint sector, guint * p_m, guint * p_s, guint * p_f, guint * p_secs)
{
  guint m, s, f;

  m = sector / SECTORS_PER_MINUTE;
  sector = sector % SECTORS_PER_MINUTE;
  s = sector / SECTORS_PER_SECOND;
  f = sector % SECTORS_PER_SECOND;

  if (p_m)
    *p_m = m;
  if (p_s)
    *p_s = s;
  if (p_f)
    *p_f = f;
  if (p_secs)
    *p_secs = s + (m * 60);
}

static void
gst_audio_cd_src_calculate_cddb_id (GstAudioCdSrc * src)
{
  GString *s;
  guint first_sector = 0, last_sector = 0;
  guint start_secs, end_secs, secs, len_secs;
  guint total_secs, num_audio_tracks;
  guint id, t, i;

  id = 0;
  total_secs = 0;
  num_audio_tracks = 0;

  /* FIXME: do we use offsets and duration of ALL tracks (data + audio)
   * for the CDDB ID calculation, or only audio tracks? */
  for (i = 0; i < src->priv->num_tracks; ++i) {
    if (1) {                    /* src->priv->tracks[i].is_audio) { */
      if (num_audio_tracks == 0) {
        first_sector = src->priv->tracks[i].start + CD_MSF_OFFSET;
      }
      last_sector = src->priv->tracks[i].end + CD_MSF_OFFSET + 1;
      ++num_audio_tracks;

      lba_to_msf (src->priv->tracks[i].start + CD_MSF_OFFSET, NULL, NULL, NULL,
          &secs);

      len_secs =
          (src->priv->tracks[i].end - src->priv->tracks[i].start + 1) / 75;

      GST_DEBUG_OBJECT (src, "track %02u: lsn %6u (%02u:%02u), "
          "length: %u seconds (%02u:%02u)",
          num_audio_tracks, src->priv->tracks[i].start + CD_MSF_OFFSET,
          secs / 60, secs % 60, len_secs, len_secs / 60, len_secs % 60);

      id += cddb_sum (secs);
      total_secs += len_secs;
    }
  }

  /* first_sector = src->priv->tracks[0].start + CD_MSF_OFFSET; */
  lba_to_msf (first_sector, NULL, NULL, NULL, &start_secs);

  /* last_sector = src->priv->tracks[src->priv->num_tracks-1].end + CD_MSF_OFFSET; */
  lba_to_msf (last_sector, NULL, NULL, NULL, &end_secs);

  GST_DEBUG_OBJECT (src, "first_sector = %u = %u secs (%02u:%02u)",
      first_sector, start_secs, start_secs / 60, start_secs % 60);
  GST_DEBUG_OBJECT (src, "last_sector  = %u = %u secs (%02u:%02u)",
      last_sector, end_secs, end_secs / 60, end_secs % 60);

  t = end_secs - start_secs;

  GST_DEBUG_OBJECT (src, "total length = %u secs (%02u:%02u), added title "
      "lengths = %u seconds (%02u:%02u)", t, t / 60, t % 60, total_secs,
      total_secs / 60, total_secs % 60);

  src->priv->discid = ((id % 0xff) << 24 | t << 8 | num_audio_tracks);

  s = g_string_new (NULL);
  g_string_append_printf (s, "%08x", src->priv->discid);

  gst_tag_list_add (src->tags, GST_TAG_MERGE_REPLACE,
      GST_TAG_CDDA_CDDB_DISCID, s->str, NULL);

  g_string_append_printf (s, " %u", src->priv->num_tracks);
  for (i = 0; i < src->priv->num_tracks; ++i) {
    g_string_append_printf (s, " %u",
        src->priv->tracks[i].start + CD_MSF_OFFSET);
  }
  g_string_append_printf (s, " %u", t);

  gst_tag_list_add (src->tags, GST_TAG_MERGE_REPLACE,
      GST_TAG_CDDA_CDDB_DISCID_FULL, s->str, NULL);

  GST_DEBUG_OBJECT (src, "cddb discid = %s", s->str);

  g_string_free (s, TRUE);
}

static void
gst_audio_cd_src_add_tags (GstAudioCdSrc * src)
{
  gint i;

  /* fill in details for each track */
  for (i = 0; i < src->priv->num_tracks; ++i) {
    gint64 duration;
    guint num_sectors;

    if (src->priv->tracks[i].tags == NULL)
      src->priv->tracks[i].tags = gst_tag_list_new_empty ();

    num_sectors = src->priv->tracks[i].end - src->priv->tracks[i].start + 1;
    gst_audio_cd_src_convert (src, sector_format, num_sectors,
        GST_FORMAT_TIME, &duration);

    gst_tag_list_add (src->priv->tracks[i].tags,
        GST_TAG_MERGE_REPLACE,
        GST_TAG_TRACK_NUMBER, i + 1,
        GST_TAG_TRACK_COUNT, src->priv->num_tracks, GST_TAG_DURATION, duration,
        NULL);
  }

  /* now fill in per-album tags and include each track's tags
   * in the album tags, so that interested parties can retrieve
   * the relevant details for each track in one go */

  /* /////////////////////////////// FIXME should we rather insert num_tracks
   * tags by the name of 'track-tags' and have the caller use
   * gst_tag_list_get_value_index() rather than use tag names incl.
   * the track number ?? *////////////////////////////////////////

  gst_tag_list_add (src->tags, GST_TAG_MERGE_REPLACE,
      GST_TAG_TRACK_COUNT, src->priv->num_tracks, NULL);
#if 0
  for (i = 0; i < src->priv->num_tracks; ++i) {
    gst_tag_list_add (src->tags, GST_TAG_MERGE_APPEND,
        GST_TAG_CDDA_TRACK_TAGS, src->priv->tracks[i].tags, NULL);
  }
#endif

  GST_DEBUG ("src->tags = %" GST_PTR_FORMAT, src->tags);
}

static GstToc *
gst_audio_cd_src_make_toc (GstAudioCdSrc * src, GstTocScope scope)
{
  GstToc *toc;
  gint i;

  toc = gst_toc_new (scope);

  for (i = 0; i < src->priv->num_tracks; ++i) {
    GstAudioCdSrcTrack *track;
    gint64 start_time, stop_time;
    GstTocEntry *entry;
    gchar *uid;

    track = &src->priv->tracks[i];

    /* keep uid in sync with toc select event handler below */
    uid = g_strdup_printf ("audiocd-track-%03u", track->num);
    entry = gst_toc_entry_new (GST_TOC_ENTRY_TYPE_TRACK, uid);
    gst_toc_entry_set_tags (entry, gst_tag_list_ref (track->tags));

    gst_audio_cd_src_convert (src, sector_format, track->start,
        GST_FORMAT_TIME, &start_time);
    gst_audio_cd_src_convert (src, sector_format, track->end + 1,
        GST_FORMAT_TIME, &stop_time);

    GST_INFO ("Track %03u  %" GST_TIME_FORMAT " - %" GST_TIME_FORMAT,
        track->num, GST_TIME_ARGS (start_time), GST_TIME_ARGS (stop_time));

    gst_toc_entry_set_start_stop_times (entry, start_time, stop_time);
    gst_toc_append_entry (toc, entry);
    g_free (uid);
  }

  return toc;
}

static void
gst_audio_cd_src_add_toc (GstAudioCdSrc * src)
{
  GstToc *toc;

  /* FIXME: send two TOC events if needed, one global, one current */
  toc = gst_audio_cd_src_make_toc (src, GST_TOC_SCOPE_GLOBAL);

  src->priv->toc_event = gst_event_new_toc (toc, FALSE);

  /* If we're in continuous mode (stream = whole disc), send a TOC event
   * downstream, so matroskamux etc. can write a TOC to indicate where the
   * various tracks are */
  if (src->priv->mode == GST_AUDIO_CD_SRC_MODE_CONTINUOUS)
    src->priv->toc_event = gst_event_new_toc (toc, FALSE);

  src->priv->toc = toc;
}

#if 0
static void
gst_audio_cd_src_add_index_associations (GstAudioCdSrc * src)
{
  gint i;

  for (i = 0; i < src->priv->num_tracks; i++) {
    gint64 sector;

    sector = src->priv->tracks[i].start;
    gst_index_add_association (src->priv->index, src->priv->index_id, GST_ASSOCIATION_FLAG_KEY_UNIT, track_format, i,   /* here we count from 0 */
        sector_format, sector,
        GST_FORMAT_TIME,
        (gint64) (((CD_FRAMESIZE_RAW >> 2) * sector * GST_SECOND) / 44100),
        GST_FORMAT_BYTES, (gint64) (sector << 2), GST_FORMAT_DEFAULT,
        (gint64) ((CD_FRAMESIZE_RAW >> 2) * sector), NULL);
  }
}

static void
gst_audio_cd_src_set_index (GstElement * element, GstIndex * index)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (element);
  GstIndex *old;

  GST_OBJECT_LOCK (element);
  old = src->priv->index;
  if (old == index) {
    GST_OBJECT_UNLOCK (element);
    return;
  }
  if (index)
    gst_object_ref (index);
  src->priv->index = index;
  GST_OBJECT_UNLOCK (element);
  if (old)
    gst_object_unref (old);

  if (index) {
    gst_index_get_writer_id (index, GST_OBJECT (src), &src->priv->index_id);
    gst_index_add_format (index, src->priv->index_id, track_format);
    gst_index_add_format (index, src->priv->index_id, sector_format);
  }
}


static GstIndex *
gst_audio_cd_src_get_index (GstElement * element)
{
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (element);
  GstIndex *index;

  GST_OBJECT_LOCK (element);
  if ((index = src->priv->index))
    gst_object_ref (index);
  GST_OBJECT_UNLOCK (element);

  return index;
}
#endif

static gint
gst_audio_cd_src_track_sort_func (gconstpointer a, gconstpointer b,
    gpointer foo)
{
  GstAudioCdSrcTrack *track_a = ((GstAudioCdSrcTrack *) a);
  GstAudioCdSrcTrack *track_b = ((GstAudioCdSrcTrack *) b);

  /* sort data tracks to the end, and audio tracks by track number */
  if (track_a->is_audio == track_b->is_audio)
    return (gint) track_a->num - (gint) track_b->num;

  if (track_a->is_audio) {
    return -1;
  } else {
    return 1;
  }
}

static gboolean
gst_audio_cd_src_start (GstBaseSrc * basesrc)
{
  GstAudioCdSrcClass *klass = GST_AUDIO_CD_SRC_GET_CLASS (basesrc);
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (basesrc);
  gboolean ret;
  gchar *device = NULL;

  src->priv->discid = 0;
  src->priv->mb_discid[0] = '\0';

  g_assert (klass->open != NULL);

  if (src->priv->device != NULL) {
    device = g_strdup (src->priv->device);
  }
#if 0
  else if (klass->get_default_device != NULL) {
    device = klass->get_default_device (src);
  }
#endif

  if (device == NULL)
    device = g_strdup (DEFAULT_DEVICE);

  GST_LOG_OBJECT (basesrc, "opening device %s", device);

  src->tags = gst_tag_list_new_empty ();

  ret = klass->open (src, device);
  g_free (device);
  device = NULL;

  if (!ret)
    goto open_failed;

  if (src->priv->num_tracks == 0 || src->priv->tracks == NULL)
    goto no_tracks;

  /* need to calculate disc IDs before we ditch the data tracks */
  gst_audio_cd_src_calculate_cddb_id (src);
  gst_audio_cd_src_calculate_musicbrainz_discid (src);

#if 0
  /* adjust sector offsets if necessary */
  if (src->priv->toc_bias) {
    src->priv->toc_offset -= src->priv->tracks[0].start;
  }
  for (i = 0; i < src->priv->num_tracks; ++i) {
    src->priv->tracks[i].start += src->priv->toc_offset;
    src->priv->tracks[i].end += src->priv->toc_offset;
  }
#endif

  /* now that we calculated the various disc IDs,
   * sort the data tracks to end and ignore them */
  src->priv->num_all_tracks = src->priv->num_tracks;

  g_qsort_with_data (src->priv->tracks, src->priv->num_tracks,
      sizeof (GstAudioCdSrcTrack), gst_audio_cd_src_track_sort_func, NULL);

  while (src->priv->num_tracks > 0
      && !src->priv->tracks[src->priv->num_tracks - 1].is_audio)
    --src->priv->num_tracks;

  if (src->priv->num_tracks == 0)
    goto no_tracks;

  gst_audio_cd_src_add_tags (src);
  gst_audio_cd_src_add_toc (src);

#if 0
  if (src->priv->index && GST_INDEX_IS_WRITABLE (src->priv->index))
    gst_audio_cd_src_add_index_associations (src);
#endif

  src->priv->cur_track = 0;
  src->priv->prev_track = -1;

  if (src->priv->uri_track > 0 && src->priv->uri_track <= src->priv->num_tracks) {
    GST_LOG_OBJECT (src, "seek to track %d", src->priv->uri_track);
    src->priv->cur_track = src->priv->uri_track - 1;
    src->priv->uri_track = -1;
    src->priv->mode = GST_AUDIO_CD_SRC_MODE_NORMAL;
  }

  src->priv->cur_sector = src->priv->tracks[src->priv->cur_track].start;
  GST_LOG_OBJECT (src, "starting at sector %d", src->priv->cur_sector);

  gst_audio_cd_src_update_duration (src);

  return TRUE;

  /* ERRORS */
open_failed:
  {
    GST_DEBUG_OBJECT (basesrc, "failed to open device");
    /* subclass (should have) posted an error message with the details */
    gst_audio_cd_src_stop (basesrc);
    return FALSE;
  }
no_tracks:
  {
    GST_DEBUG_OBJECT (src, "no audio tracks");
    GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ,
        (_("This CD has no audio tracks")), (NULL));
    gst_audio_cd_src_stop (basesrc);
    return FALSE;
  }
}

static void
gst_audio_cd_src_clear_tracks (GstAudioCdSrc * src)
{
  if (src->priv->tracks != NULL) {
    gint i;

    for (i = 0; i < src->priv->num_all_tracks; ++i) {
      if (src->priv->tracks[i].tags)
        gst_tag_list_unref (src->priv->tracks[i].tags);
    }

    g_free (src->priv->tracks);
    src->priv->tracks = NULL;
  }
  src->priv->num_tracks = 0;
  src->priv->num_all_tracks = 0;
}

static gboolean
gst_audio_cd_src_stop (GstBaseSrc * basesrc)
{
  GstAudioCdSrcClass *klass = GST_AUDIO_CD_SRC_GET_CLASS (basesrc);
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (basesrc);

  g_assert (klass->close != NULL);

  klass->close (src);

  gst_audio_cd_src_clear_tracks (src);

  if (src->tags) {
    gst_tag_list_unref (src->tags);
    src->tags = NULL;
  }

  gst_event_replace (&src->priv->toc_event, NULL);

  if (src->priv->toc) {
    gst_toc_unref (src->priv->toc);
    src->priv->toc = NULL;
  }

  src->priv->prev_track = -1;
  src->priv->cur_track = -1;

  return TRUE;
}


static GstFlowReturn
gst_audio_cd_src_create (GstPushSrc * pushsrc, GstBuffer ** buffer)
{
  GstAudioCdSrcClass *klass = GST_AUDIO_CD_SRC_GET_CLASS (pushsrc);
  GstAudioCdSrc *src = GST_AUDIO_CD_SRC (pushsrc);
  GstBuffer *buf;
  gboolean eos;

  GstClockTime position = GST_CLOCK_TIME_NONE;
  GstClockTime duration = GST_CLOCK_TIME_NONE;
  gint64 qry_position;

  g_assert (klass->read_sector != NULL);

  switch (src->priv->mode) {
    case GST_AUDIO_CD_SRC_MODE_NORMAL:
      eos =
          (src->priv->cur_sector > src->priv->tracks[src->priv->cur_track].end);
      break;
    case GST_AUDIO_CD_SRC_MODE_CONTINUOUS:
      eos =
          (src->priv->cur_sector >
          src->priv->tracks[src->priv->num_tracks - 1].end);
      src->priv->cur_track =
          gst_audio_cd_src_get_track_from_sector (src, src->priv->cur_sector);
      break;
    default:
      g_return_val_if_reached (GST_FLOW_ERROR);
  }

  if (eos) {
    src->priv->prev_track = -1;
    GST_DEBUG_OBJECT (src, "EOS at sector %d, cur_track=%d, mode=%d",
        src->priv->cur_sector, src->priv->cur_track, src->priv->mode);
    /* base class will send EOS for us */
    return GST_FLOW_EOS;
  }

  if (src->priv->toc_event != NULL) {
    gst_pad_push_event (GST_BASE_SRC_PAD (src), src->priv->toc_event);
    src->priv->toc_event = NULL;
  }

  if (src->priv->prev_track != src->priv->cur_track) {
    GstTagList *tags;

    tags =
        gst_tag_list_merge (src->tags,
        src->priv->tracks[src->priv->cur_track].tags, GST_TAG_MERGE_REPLACE);
    GST_LOG_OBJECT (src, "announcing tags: %" GST_PTR_FORMAT, tags);
    gst_pad_push_event (GST_BASE_SRC_PAD (src), gst_event_new_tag (tags));
    src->priv->prev_track = src->priv->cur_track;

    gst_audio_cd_src_update_duration (src);

    g_object_notify (G_OBJECT (src), "track");
  }

  GST_LOG_OBJECT (src, "asking for sector %u", src->priv->cur_sector);

  buf = klass->read_sector (src, src->priv->cur_sector);

  if (buf == NULL) {
    GST_WARNING_OBJECT (src, "failed to read sector %u", src->priv->cur_sector);
    return GST_FLOW_ERROR;
  }

  if (gst_pad_query_position (GST_BASE_SRC_PAD (src), GST_FORMAT_TIME,
          &qry_position)) {
    gint64 next_ts = 0;

    position = (GstClockTime) qry_position;

    ++src->priv->cur_sector;
    if (gst_pad_query_position (GST_BASE_SRC_PAD (src), GST_FORMAT_TIME,
            &next_ts)) {
      duration = (GstClockTime) (next_ts - qry_position);
    }
    --src->priv->cur_sector;
  }

  /* fallback duration: 4 bytes per sample, 44100 samples per second */
  if (duration == GST_CLOCK_TIME_NONE) {
    duration = gst_util_uint64_scale_int (gst_buffer_get_size (buf) >> 2,
        GST_SECOND, 44100);
  }

  GST_BUFFER_TIMESTAMP (buf) = position;
  GST_BUFFER_DURATION (buf) = duration;

  GST_LOG_OBJECT (src, "pushing sector %d with timestamp %" GST_TIME_FORMAT,
      src->priv->cur_sector, GST_TIME_ARGS (position));

  ++src->priv->cur_sector;

  *buffer = buf;

  return GST_FLOW_OK;
}
