/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gsttaglist.c: tag support (aka metadata)
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
 * SECTION:gsttaglist
 * @short_description: List of tags and values used to describe media metadata
 *
 * List of tags and values used to describe media metadata.
 *
 * Strings in structures must be ASCII or UTF-8 encoded. Other encodings are
 * not allowed. Strings must not be empty or %NULL.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gst_private.h"
#include "math-compat.h"
#include "gst-i18n-lib.h"
#include "gsttaglist.h"
#include "gstinfo.h"
#include "gstvalue.h"
#include "gstbuffer.h"
#include "gstquark.h"
#include "gststructure.h"

#include <gobject/gvaluecollector.h>
#include <string.h>

/* FIXME: add category for tags */
#define GST_CAT_TAGS GST_CAT_DEFAULT

#define GST_TAG_IS_VALID(tag)           (gst_tag_get_info (tag) != NULL)

typedef struct _GstTagListImpl
{
  GstTagList taglist;

  GstStructure *structure;
  GstTagScope scope;
} GstTagListImpl;

#define GST_TAG_LIST_STRUCTURE(taglist)  ((GstTagListImpl*)(taglist))->structure
#define GST_TAG_LIST_SCOPE(taglist)  ((GstTagListImpl*)(taglist))->scope

typedef struct
{
  GType type;                   /* type the data is in */

  const gchar *nick;            /* translated short description */
  const gchar *blurb;           /* translated long description  */

  GstTagMergeFunc merge_func;   /* functions to merge the values */
  GstTagFlag flag;              /* type of tag */
  GQuark name_quark;            /* quark for the name */
}
GstTagInfo;

#define g_value_get_char g_value_get_schar

static GMutex __tag_mutex;
#define TAG_LOCK g_mutex_lock (&__tag_mutex)
#define TAG_UNLOCK g_mutex_unlock (&__tag_mutex)

/* tags hash table: maps tag name string => GstTagInfo */
static GHashTable *__tags;

GType _gst_tag_list_type = 0;
GST_DEFINE_MINI_OBJECT_TYPE (GstTagList, gst_tag_list);

static void __gst_tag_list_free (GstTagList * list);
static GstTagList *__gst_tag_list_copy (const GstTagList * list);

/* FIXME: had code:
 *    g_value_register_transform_func (_gst_tag_list_type, G_TYPE_STRING,
 *      _gst_structure_transform_to_string);
 */
void
_priv_gst_tag_initialize (void)
{
  g_mutex_init (&__tag_mutex);

  _gst_tag_list_type = gst_tag_list_get_type ();

  __tags = g_hash_table_new (g_str_hash, g_str_equal);
  gst_tag_register_static (GST_TAG_TITLE, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("title"), _("commonly used title"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_TITLE_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("title sortname"), _("commonly used title for sorting purposes"), NULL);
  gst_tag_register_static (GST_TAG_ARTIST, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("artist"),
      _("person(s) responsible for the recording"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_ARTIST_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("artist sortname"),
      _("person(s) responsible for the recording for sorting purposes"), NULL);
  gst_tag_register_static (GST_TAG_ALBUM, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("album"),
      _("album containing this data"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_ALBUM_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("album sortname"),
      _("album containing this data for sorting purposes"), NULL);
  gst_tag_register_static (GST_TAG_ALBUM_ARTIST, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("album artist"),
      _("The artist of the entire album, as it should be displayed"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_ALBUM_ARTIST_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("album artist sortname"),
      _("The artist of the entire album, as it should be sorted"), NULL);
  gst_tag_register_static (GST_TAG_DATE, GST_TAG_FLAG_META, G_TYPE_DATE,
      _("date"), _("date the data was created (as a GDate structure)"), NULL);
  gst_tag_register_static (GST_TAG_DATE_TIME, GST_TAG_FLAG_META,
      GST_TYPE_DATE_TIME, _("datetime"),
      _("date and time the data was created (as a GstDateTime structure)"),
      NULL);
  gst_tag_register_static (GST_TAG_GENRE, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("genre"),
      _("genre this data belongs to"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_COMMENT, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("comment"),
      _("free text commenting the data"), gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_EXTENDED_COMMENT, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("extended comment"),
      _("free text commenting the data in key=value or key[en]=comment form"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_TRACK_NUMBER, GST_TAG_FLAG_META,
      G_TYPE_UINT,
      _("track number"),
      _("track number inside a collection"), gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_TRACK_COUNT, GST_TAG_FLAG_META,
      G_TYPE_UINT,
      _("track count"),
      _("count of tracks inside collection this track belongs to"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_ALBUM_VOLUME_NUMBER, GST_TAG_FLAG_META,
      G_TYPE_UINT,
      _("disc number"),
      _("disc number inside a collection"), gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_ALBUM_VOLUME_COUNT, GST_TAG_FLAG_META,
      G_TYPE_UINT,
      _("disc count"),
      _("count of discs inside collection this disc belongs to"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_LOCATION, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("location"), _("Origin of media as a URI (location, where the "
          "original of the file or stream is hosted)"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_HOMEPAGE, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("homepage"),
      _("Homepage for this media (i.e. artist or movie homepage)"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_DESCRIPTION, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("description"),
      _("short text describing the content of the data"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_VERSION, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("version"), _("version of this data"), NULL);
  gst_tag_register_static (GST_TAG_ISRC, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("ISRC"),
      _
      ("International Standard Recording Code - see http://www.ifpi.org/isrc/"),
      NULL);
  /* FIXME: organization (fix what? tpm) */
  gst_tag_register_static (GST_TAG_ORGANIZATION, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("organization"), _("organization"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_COPYRIGHT, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("copyright"), _("copyright notice of the data"), NULL);
  gst_tag_register_static (GST_TAG_COPYRIGHT_URI, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("copyright uri"),
      _("URI to the copyright notice of the data"), NULL);
  gst_tag_register_static (GST_TAG_ENCODED_BY, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("encoded by"), _("name of the encoding person or organization"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_CONTACT, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("contact"), _("contact information"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_LICENSE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("license"), _("license of data"), NULL);
  gst_tag_register_static (GST_TAG_LICENSE_URI, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("license uri"),
      _("URI to the license of the data"), NULL);
  gst_tag_register_static (GST_TAG_PERFORMER, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("performer"),
      _("person(s) performing"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_COMPOSER, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("composer"),
      _("person(s) who composed the recording"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_DURATION, GST_TAG_FLAG_DECODED,
      G_TYPE_UINT64,
      _("duration"), _("length in GStreamer time units (nanoseconds)"), NULL);
  gst_tag_register_static (GST_TAG_CODEC, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING,
      _("codec"),
      _("codec the data is stored in"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_VIDEO_CODEC, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING,
      _("video codec"), _("codec the video data is stored in"), NULL);
  gst_tag_register_static (GST_TAG_AUDIO_CODEC, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING,
      _("audio codec"), _("codec the audio data is stored in"), NULL);
  gst_tag_register_static (GST_TAG_SUBTITLE_CODEC, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING,
      _("subtitle codec"), _("codec the subtitle data is stored in"), NULL);
  gst_tag_register_static (GST_TAG_CONTAINER_FORMAT, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING, _("container format"),
      _("container format the data is stored in"), NULL);
  gst_tag_register_static (GST_TAG_BITRATE, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT, _("bitrate"), _("exact or average bitrate in bits/s"), NULL);
  gst_tag_register_static (GST_TAG_NOMINAL_BITRATE, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT, _("nominal bitrate"), _("nominal bitrate in bits/s"), NULL);
  gst_tag_register_static (GST_TAG_MINIMUM_BITRATE, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT, _("minimum bitrate"), _("minimum bitrate in bits/s"), NULL);
  gst_tag_register_static (GST_TAG_MAXIMUM_BITRATE, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT, _("maximum bitrate"), _("maximum bitrate in bits/s"), NULL);
  gst_tag_register_static (GST_TAG_ENCODER, GST_TAG_FLAG_ENCODED,
      G_TYPE_STRING,
      _("encoder"), _("encoder used to encode this stream"), NULL);
  gst_tag_register_static (GST_TAG_ENCODER_VERSION, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT,
      _("encoder version"),
      _("version of the encoder used to encode this stream"), NULL);
  gst_tag_register_static (GST_TAG_SERIAL, GST_TAG_FLAG_ENCODED,
      G_TYPE_UINT, _("serial"), _("serial number of track"), NULL);
  gst_tag_register_static (GST_TAG_TRACK_GAIN, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("replaygain track gain"), _("track gain in db"), NULL);
  gst_tag_register_static (GST_TAG_TRACK_PEAK, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("replaygain track peak"), _("peak of the track"), NULL);
  gst_tag_register_static (GST_TAG_ALBUM_GAIN, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("replaygain album gain"), _("album gain in db"), NULL);
  gst_tag_register_static (GST_TAG_ALBUM_PEAK, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("replaygain album peak"), _("peak of the album"), NULL);
  gst_tag_register_static (GST_TAG_REFERENCE_LEVEL, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("replaygain reference level"),
      _("reference level of track and album gain values"), NULL);
  gst_tag_register_static (GST_TAG_LANGUAGE_CODE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("language code"),
      _("language code for this stream, conforming to ISO-639-1 or ISO-639-2"),
      NULL);
  gst_tag_register_static (GST_TAG_LANGUAGE_NAME, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("language name"),
      _("freeform name of the language this stream is in"), NULL);
  gst_tag_register_static (GST_TAG_IMAGE, GST_TAG_FLAG_META, GST_TYPE_SAMPLE,
      _("image"), _("image related to this stream"), gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_PREVIEW_IMAGE, GST_TAG_FLAG_META,
      GST_TYPE_SAMPLE,
      /* TRANSLATORS: 'preview image' = image that shows a preview of the full image */
      _("preview image"), _("preview image related to this stream"), NULL);
  gst_tag_register_static (GST_TAG_ATTACHMENT, GST_TAG_FLAG_META,
      GST_TYPE_SAMPLE, _("attachment"), _("file attached to this stream"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_BEATS_PER_MINUTE, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("beats per minute"),
      _("number of beats per minute in audio"), NULL);
  gst_tag_register_static (GST_TAG_KEYWORDS, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("keywords"), _("comma separated keywords describing the content"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_NAME, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("geo location name"),
      _("human readable descriptive location of where "
          "the media has been recorded or produced"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_LATITUDE, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("geo location latitude"),
      _("geo latitude location of where the media has been recorded or "
          "produced in degrees according to WGS84 (zero at the equator, "
          "negative values for southern latitudes)"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_LONGITUDE, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("geo location longitude"),
      _("geo longitude location of where the media has been recorded or "
          "produced in degrees according to WGS84 (zero at the prime meridian "
          "in Greenwich/UK,  negative values for western longitudes)"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_ELEVATION, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("geo location elevation"),
      _("geo elevation of where the media has been recorded or produced in "
          "meters according to WGS84 (zero is average sea level)"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_COUNTRY, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("geo location country"),
      _("country (english name) where the media has been recorded "
          "or produced"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_CITY, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("geo location city"),
      _("city (english name) where the media has been recorded "
          "or produced"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_SUBLOCATION, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("geo location sublocation"),
      _("a location within a city where the media has been produced "
          "or created (e.g. the neighborhood)"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_HORIZONTAL_ERROR,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("geo location horizontal error"),
      _("expected error of the horizontal positioning measures (in meters)"),
      NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_MOVEMENT_SPEED,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("geo location movement speed"),
      _("movement speed of the capturing device while performing the capture "
          "in m/s"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_MOVEMENT_DIRECTION,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("geo location movement direction"),
      _("indicates the movement direction of the device performing the capture"
          " of a media. It is represented as degrees in floating point "
          "representation, 0 means the geographic north, and increases "
          "clockwise"), NULL);
  gst_tag_register_static (GST_TAG_GEO_LOCATION_CAPTURE_DIRECTION,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("geo location capture direction"),
      _("indicates the direction the device is pointing to when capturing "
          " a media. It is represented as degrees in floating point "
          " representation, 0 means the geographic north, and increases "
          "clockwise"), NULL);
  gst_tag_register_static (GST_TAG_SHOW_NAME, GST_TAG_FLAG_META, G_TYPE_STRING,
      /* TRANSLATORS: 'show name' = 'TV/radio/podcast show name' here */
      _("show name"),
      _("Name of the tv/podcast/series show the media is from"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_SHOW_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      /* TRANSLATORS: 'show sortname' = 'TV/radio/podcast show name as used for sorting purposes' here */
      _("show sortname"),
      _("Name of the tv/podcast/series show the media is from, for sorting "
          "purposes"), NULL);
  gst_tag_register_static (GST_TAG_SHOW_EPISODE_NUMBER, GST_TAG_FLAG_META,
      G_TYPE_UINT, _("episode number"),
      _("The episode number in the season the media is part of"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_SHOW_SEASON_NUMBER, GST_TAG_FLAG_META,
      G_TYPE_UINT, _("season number"),
      _("The season number of the show the media is part of"),
      gst_tag_merge_use_first);
  gst_tag_register_static (GST_TAG_LYRICS, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("lyrics"), _("The lyrics of the media, commonly used for songs"),
      gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_COMPOSER_SORTNAME, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("composer sortname"),
      _("person(s) who composed the recording, for sorting purposes"), NULL);
  gst_tag_register_static (GST_TAG_GROUPING, GST_TAG_FLAG_META, G_TYPE_STRING,
      _("grouping"),
      _("Groups related media that spans multiple tracks, like the different "
          "pieces of a concerto. It is a higher level than a track, "
          "but lower than an album"), NULL);
  gst_tag_register_static (GST_TAG_USER_RATING, GST_TAG_FLAG_META, G_TYPE_UINT,
      _("user rating"),
      _("Rating attributed by a user. The higher the rank, "
          "the more the user likes this media"), NULL);
  gst_tag_register_static (GST_TAG_DEVICE_MANUFACTURER, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("device manufacturer"),
      _("Manufacturer of the device used to create this media"), NULL);
  gst_tag_register_static (GST_TAG_DEVICE_MODEL, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("device model"),
      _("Model of the device used to create this media"), NULL);
  gst_tag_register_static (GST_TAG_APPLICATION_NAME, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("application name"),
      _("Application used to create the media"), NULL);
  gst_tag_register_static (GST_TAG_APPLICATION_DATA, GST_TAG_FLAG_META,
      GST_TYPE_SAMPLE, _("application data"),
      _("Arbitrary application data to be serialized into the media"), NULL);
  gst_tag_register_static (GST_TAG_IMAGE_ORIENTATION, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("image orientation"),
      _("How the image should be rotated or flipped before display"), NULL);
  gst_tag_register_static (GST_TAG_PUBLISHER, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("publisher"),
      _("Name of the label or publisher"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_INTERPRETED_BY, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("interpreted-by"),
      _("Information about the people behind a remix and similar "
          "interpretations"), gst_tag_merge_strings_with_comma);
  gst_tag_register_static (GST_TAG_MIDI_BASE_NOTE, GST_TAG_FLAG_META,
      G_TYPE_UINT,
      _("midi-base-note"), _("Midi note number of the audio track."), NULL);
}

/**
 * gst_tag_merge_use_first:
 * @dest: (out caller-allocates): uninitialized GValue to store result in
 * @src: GValue to copy from
 *
 * This is a convenience function for the func argument of gst_tag_register().
 * It creates a copy of the first value from the list.
 */
void
gst_tag_merge_use_first (GValue * dest, const GValue * src)
{
  const GValue *ret = gst_value_list_get_value (src, 0);

  g_value_init (dest, G_VALUE_TYPE (ret));
  g_value_copy (ret, dest);
}

/**
 * gst_tag_merge_strings_with_comma:
 * @dest: (out caller-allocates): uninitialized GValue to store result in
 * @src: GValue to copy from
 *
 * This is a convenience function for the func argument of gst_tag_register().
 * It concatenates all given strings using a comma. The tag must be registered
 * as a G_TYPE_STRING or this function will fail.
 */
void
gst_tag_merge_strings_with_comma (GValue * dest, const GValue * src)
{
  GString *str;
  gint i, count;

  count = gst_value_list_get_size (src);
  str = g_string_new (g_value_get_string (gst_value_list_get_value (src, 0)));
  for (i = 1; i < count; i++) {
    /* separator between two strings */
    g_string_append (str, _(", "));
    g_string_append (str,
        g_value_get_string (gst_value_list_get_value (src, i)));
  }

  g_value_init (dest, G_TYPE_STRING);
  g_value_take_string (dest, str->str);
  g_string_free (str, FALSE);
}

static GstTagInfo *
gst_tag_lookup (const gchar * tag_name)
{
  GstTagInfo *ret;

  TAG_LOCK;
  ret = g_hash_table_lookup (__tags, (gpointer) tag_name);
  TAG_UNLOCK;

  return ret;
}

/**
 * gst_tag_register:
 * @name: the name or identifier string
 * @flag: a flag describing the type of tag info
 * @type: the type this data is in
 * @nick: human-readable name
 * @blurb: a human-readable description about this tag
 * @func: (allow-none): function for merging multiple values of this tag, or %NULL
 *
 * Registers a new tag type for the use with GStreamer's type system. If a type
 * with that name is already registered, that one is used.
 * The old registration may have used a different type however. So don't rely
 * on your supplied values.
 *
 * Important: if you do not supply a merge function the implication will be
 * that there can only be one single value for this tag in a tag list and
 * any additional values will silently be discarded when being added (unless
 * #GST_TAG_MERGE_REPLACE, #GST_TAG_MERGE_REPLACE_ALL, or
 * #GST_TAG_MERGE_PREPEND is used as merge mode, in which case the new
 * value will replace the old one in the list).
 *
 * The merge function will be called from gst_tag_list_copy_value() when
 * it is required that one or more values for a tag be condensed into
 * one single value. This may happen from gst_tag_list_get_string(),
 * gst_tag_list_get_int(), gst_tag_list_get_double() etc. What will happen
 * exactly in that case depends on how the tag was registered and if a
 * merge function was supplied and if so which one.
 *
 * Two default merge functions are provided: gst_tag_merge_use_first() and
 * gst_tag_merge_strings_with_comma().
 */
void
gst_tag_register (const gchar * name, GstTagFlag flag, GType type,
    const gchar * nick, const gchar * blurb, GstTagMergeFunc func)
{
  g_return_if_fail (name != NULL);
  g_return_if_fail (nick != NULL);
  g_return_if_fail (blurb != NULL);
  g_return_if_fail (type != 0 && type != GST_TYPE_LIST);

  return gst_tag_register_static (g_intern_string (name), flag, type,
      g_intern_string (nick), g_intern_string (blurb), func);
}

/**
 * gst_tag_register_static:
 * @name: the name or identifier string (string constant)
 * @flag: a flag describing the type of tag info
 * @type: the type this data is in
 * @nick: human-readable name or short description (string constant)
 * @blurb: a human-readable description for this tag (string constant)
 * @func: (allow-none): function for merging multiple values of this tag, or %NULL
 *
 * Registers a new tag type for the use with GStreamer's type system.
 *
 * Same as gst_tag_register(), but @name, @nick, and @blurb must be
 * static strings or inlined strings, as they will not be copied. (GStreamer
 * plugins will be made resident once loaded, so this function can be used
 * even from dynamically loaded plugins.)
 */
void
gst_tag_register_static (const gchar * name, GstTagFlag flag, GType type,
    const gchar * nick, const gchar * blurb, GstTagMergeFunc func)
{
  GstTagInfo *info;

  g_return_if_fail (name != NULL);
  g_return_if_fail (nick != NULL);
  g_return_if_fail (blurb != NULL);
  g_return_if_fail (type != 0 && type != GST_TYPE_LIST);

  info = gst_tag_lookup (name);

  if (info) {
    g_return_if_fail (info->type == type);
    return;
  }

  info = g_slice_new (GstTagInfo);
  info->flag = flag;
  info->type = type;
  info->name_quark = g_quark_from_static_string (name);
  info->nick = nick;
  info->blurb = blurb;
  info->merge_func = func;

  TAG_LOCK;
  g_hash_table_insert (__tags, (gpointer) name, info);
  TAG_UNLOCK;
}

/**
 * gst_tag_exists:
 * @tag: name of the tag
 *
 * Checks if the given type is already registered.
 *
 * Returns: %TRUE if the type is already registered
 */
gboolean
gst_tag_exists (const gchar * tag)
{
  g_return_val_if_fail (tag != NULL, FALSE);

  return gst_tag_lookup (tag) != NULL;
}

/**
 * gst_tag_get_type:
 * @tag: the tag
 *
 * Gets the #GType used for this tag.
 *
 * Returns: the #GType of this tag
 */
GType
gst_tag_get_type (const gchar * tag)
{
  GstTagInfo *info;

  g_return_val_if_fail (tag != NULL, 0);
  info = gst_tag_lookup (tag);
  g_return_val_if_fail (info != NULL, 0);

  return info->type;
}

/**
 * gst_tag_get_nick:
 * @tag: the tag
 *
 * Returns the human-readable name of this tag, You must not change or free
 * this string.
 *
 * Returns: the human-readable name of this tag
 */
const gchar *
gst_tag_get_nick (const gchar * tag)
{
  GstTagInfo *info;

  g_return_val_if_fail (tag != NULL, NULL);
  info = gst_tag_lookup (tag);
  g_return_val_if_fail (info != NULL, NULL);

  return info->nick;
}

/**
 * gst_tag_get_description:
 * @tag: the tag
 *
 * Returns the human-readable description of this tag, You must not change or
 * free this string.
 *
 * Returns: the human-readable description of this tag
 */
const gchar *
gst_tag_get_description (const gchar * tag)
{
  GstTagInfo *info;

  g_return_val_if_fail (tag != NULL, NULL);
  info = gst_tag_lookup (tag);
  g_return_val_if_fail (info != NULL, NULL);

  return info->blurb;
}

/**
 * gst_tag_get_flag:
 * @tag: the tag
 *
 * Gets the flag of @tag.
 *
 * Returns: the flag of this tag.
 */
GstTagFlag
gst_tag_get_flag (const gchar * tag)
{
  GstTagInfo *info;

  g_return_val_if_fail (tag != NULL, GST_TAG_FLAG_UNDEFINED);
  info = gst_tag_lookup (tag);
  g_return_val_if_fail (info != NULL, GST_TAG_FLAG_UNDEFINED);

  return info->flag;
}

/**
 * gst_tag_is_fixed:
 * @tag: tag to check
 *
 * Checks if the given tag is fixed. A fixed tag can only contain one value.
 * Unfixed tags can contain lists of values.
 *
 * Returns: %TRUE, if the given tag is fixed.
 */
gboolean
gst_tag_is_fixed (const gchar * tag)
{
  GstTagInfo *info;

  g_return_val_if_fail (tag != NULL, FALSE);
  info = gst_tag_lookup (tag);
  g_return_val_if_fail (info != NULL, FALSE);

  return info->merge_func == NULL;
}

/* takes ownership of the structure */
static GstTagList *
gst_tag_list_new_internal (GstStructure * s)
{
  GstTagList *tag_list;

  g_assert (s != NULL);

  tag_list = (GstTagList *) g_slice_new (GstTagListImpl);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (tag_list), 0, GST_TYPE_TAG_LIST,
      (GstMiniObjectCopyFunction) __gst_tag_list_copy, NULL,
      (GstMiniObjectFreeFunction) __gst_tag_list_free);

  GST_TAG_LIST_STRUCTURE (tag_list) = s;
  GST_TAG_LIST_SCOPE (tag_list) = GST_TAG_SCOPE_STREAM;

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE (GST_CAT_TAGS, "created taglist %p", tag_list);
#endif

  return tag_list;
}

static void
__gst_tag_list_free (GstTagList * list)
{
  g_return_if_fail (GST_IS_TAG_LIST (list));

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE (GST_CAT_TAGS, "freeing taglist %p", list);
#endif

  gst_structure_free (GST_TAG_LIST_STRUCTURE (list));

  g_slice_free1 (sizeof (GstTagListImpl), list);
}

static GstTagList *
__gst_tag_list_copy (const GstTagList * list)
{
  const GstStructure *s;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), NULL);

  s = GST_TAG_LIST_STRUCTURE (list);
  return gst_tag_list_new_internal (gst_structure_copy (s));
}

/**
 * gst_tag_list_new_empty:
 *
 * Creates a new empty GstTagList.
 *
 * Free-function: gst_tag_list_unref
 *
 * Returns: (transfer full): An empty tag list
 */
GstTagList *
gst_tag_list_new_empty (void)
{
  GstStructure *s;
  GstTagList *tag_list;

  s = gst_structure_new_id_empty (GST_QUARK (TAGLIST));
  tag_list = gst_tag_list_new_internal (s);
  return tag_list;
}

/**
 * gst_tag_list_new:
 * @tag: tag
 * @...: %NULL-terminated list of values to set
 *
 * Creates a new taglist and appends the values for the given tags. It expects
 * tag-value pairs like gst_tag_list_add(), and a %NULL terminator after the
 * last pair. The type of the values is implicit and is documented in the API
 * reference, but can also be queried at runtime with gst_tag_get_type(). It
 * is an error to pass a value of a type not matching the tag type into this
 * function. The tag list will make copies of any arguments passed
 * (e.g. strings, buffers).
 *
 * After creation you might also want to set a #GstTagScope on the returned
 * taglist to signal if the contained tags are global or stream tags. By
 * default stream scope is assumes. See gst_tag_list_set_scope().
 *
 * Free-function: gst_tag_list_unref
 *
 * Returns: (transfer full): a new #GstTagList. Free with gst_tag_list_unref()
 *     when no longer needed.
 */
GstTagList *
gst_tag_list_new (const gchar * tag, ...)
{
  GstTagList *list;
  va_list args;

  g_return_val_if_fail (tag != NULL, NULL);

  list = gst_tag_list_new_empty ();
  va_start (args, tag);
  gst_tag_list_add_valist (list, GST_TAG_MERGE_APPEND, tag, args);
  va_end (args);

  return list;
}

/**
 * gst_tag_list_new_valist:
 * @var_args: tag / value pairs to set
 *
 * Just like gst_tag_list_new(), only that it takes a va_list argument.
 * Useful mostly for language bindings.
 *
 * Free-function: gst_tag_list_unref
 *
 * Returns: (transfer full): a new #GstTagList. Free with gst_tag_list_unref()
 *     when no longer needed.
 */
GstTagList *
gst_tag_list_new_valist (va_list var_args)
{
  GstTagList *list;
  const gchar *tag;

  list = gst_tag_list_new_empty ();

  tag = va_arg (var_args, gchar *);
  gst_tag_list_add_valist (list, GST_TAG_MERGE_APPEND, tag, var_args);

  return list;
}

/**
 * gst_tag_list_set_scope:
 * @list: a #GstTagList
 * @scope: new scope for @list
 *
 * Sets the scope of @list to @scope. By default the scope
 * of a taglist is stream scope.
 *
 */
void
gst_tag_list_set_scope (GstTagList * list, GstTagScope scope)
{
  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));

  GST_TAG_LIST_SCOPE (list) = scope;
}

/**
 * gst_tag_list_get_scope:
 * @list: a #GstTagList
 *
 * Gets the scope of @list.
 *
 * Returns: The scope of @list
 */
GstTagScope
gst_tag_list_get_scope (const GstTagList * list)
{
  g_return_val_if_fail (GST_IS_TAG_LIST (list), GST_TAG_SCOPE_STREAM);

  return GST_TAG_LIST_SCOPE (list);
}

/**
 * gst_tag_list_to_string:
 * @list: a #GstTagList
 *
 * Serializes a tag list to a string.
 *
 * Returns: (nullable): a newly-allocated string, or %NULL in case of
 *     an error. The string must be freed with g_free() when no longer
 *     needed.
 */
gchar *
gst_tag_list_to_string (const GstTagList * list)
{
  g_return_val_if_fail (GST_IS_TAG_LIST (list), NULL);

  return gst_structure_to_string (GST_TAG_LIST_STRUCTURE (list));
}

/**
 * gst_tag_list_new_from_string:
 * @str: a string created with gst_tag_list_to_string()
 *
 * Deserializes a tag list.
 *
 * Returns: (nullable): a new #GstTagList, or %NULL in case of an
 * error.
 */
GstTagList *
gst_tag_list_new_from_string (const gchar * str)
{
  GstTagList *tag_list;
  GstStructure *s;

  g_return_val_if_fail (str != NULL, NULL);
  g_return_val_if_fail (g_str_has_prefix (str, "taglist"), NULL);

  s = gst_structure_from_string (str, NULL);
  if (s == NULL)
    return NULL;

  tag_list = gst_tag_list_new_internal (s);

  return tag_list;
}

/**
 * gst_tag_list_n_tags:
 * @list: A #GstTagList.
 *
 * Get the number of tags in @list.
 *
 * Returns: The number of tags in @list.
 */
gint
gst_tag_list_n_tags (const GstTagList * list)
{
  g_return_val_if_fail (list != NULL, 0);
  g_return_val_if_fail (GST_IS_TAG_LIST (list), 0);

  return gst_structure_n_fields (GST_TAG_LIST_STRUCTURE (list));
}

/**
 * gst_tag_list_nth_tag_name:
 * @list: A #GstTagList.
 * @index: the index
 *
 * Get the name of the tag in @list at @index.
 *
 * Returns: The name of the tag at @index.
 */
const gchar *
gst_tag_list_nth_tag_name (const GstTagList * list, guint index)
{
  g_return_val_if_fail (list != NULL, 0);
  g_return_val_if_fail (GST_IS_TAG_LIST (list), 0);

  return gst_structure_nth_field_name (GST_TAG_LIST_STRUCTURE (list), index);
}

/**
 * gst_tag_list_is_empty:
 * @list: A #GstTagList.
 *
 * Checks if the given taglist is empty.
 *
 * Returns: %TRUE if the taglist is empty, otherwise %FALSE.
 */
gboolean
gst_tag_list_is_empty (const GstTagList * list)
{
  g_return_val_if_fail (list != NULL, FALSE);
  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);

  return (gst_structure_n_fields (GST_TAG_LIST_STRUCTURE (list)) == 0);
}

static gboolean
gst_tag_list_fields_equal (const GValue * value1, const GValue * value2)
{
  gdouble d1, d2;

  if (gst_value_compare (value1, value2) == GST_VALUE_EQUAL)
    return TRUE;

  /* fields not equal: add some tolerance for doubles, otherwise bail out */
  if (!G_VALUE_HOLDS_DOUBLE (value1) || !G_VALUE_HOLDS_DOUBLE (value2))
    return FALSE;

  d1 = g_value_get_double (value1);
  d2 = g_value_get_double (value2);

  /* This will only work for 'normal' values and values around 0,
   * which should be good enough for our purposes here
   * FIXME: maybe add this to gst_value_compare_double() ? */
  return (fabs (d1 - d2) < 0.0000001);
}

/**
 * gst_tag_list_is_equal:
 * @list1: a #GstTagList.
 * @list2: a #GstTagList.
 *
 * Checks if the two given taglists are equal.
 *
 * Returns: %TRUE if the taglists are equal, otherwise %FALSE
 */
gboolean
gst_tag_list_is_equal (const GstTagList * list1, const GstTagList * list2)
{
  const GstStructure *s1, *s2;
  gint num_fields1, num_fields2, i;

  g_return_val_if_fail (GST_IS_TAG_LIST (list1), FALSE);
  g_return_val_if_fail (GST_IS_TAG_LIST (list2), FALSE);

  /* we don't just use gst_structure_is_equal() here so we can add some
   * tolerance for doubles, though maybe we should just add that to
   * gst_value_compare_double() as well? */
  s1 = GST_TAG_LIST_STRUCTURE (list1);
  s2 = GST_TAG_LIST_STRUCTURE (list2);

  num_fields1 = gst_structure_n_fields (s1);
  num_fields2 = gst_structure_n_fields (s2);

  if (num_fields1 != num_fields2)
    return FALSE;

  for (i = 0; i < num_fields1; i++) {
    const GValue *value1, *value2;
    const gchar *tag_name;

    tag_name = gst_structure_nth_field_name (s1, i);
    value1 = gst_structure_get_value (s1, tag_name);
    value2 = gst_structure_get_value (s2, tag_name);

    if (value2 == NULL)
      return FALSE;

    if (!gst_tag_list_fields_equal (value1, value2))
      return FALSE;
  }

  return TRUE;
}

typedef struct
{
  GstTagList *list;
  GstTagMergeMode mode;
}
GstTagCopyData;

static void
gst_tag_list_add_value_internal (GstTagList * tag_list, GstTagMergeMode mode,
    const gchar * tag, const GValue * value, GstTagInfo * info)
{
  GstStructure *list = GST_TAG_LIST_STRUCTURE (tag_list);
  const GValue *value2;
  GQuark tag_quark;

  if (info == NULL) {
    info = gst_tag_lookup (tag);
    if (G_UNLIKELY (info == NULL)) {
      g_warning ("unknown tag '%s'", tag);
      return;
    }
  }

  if (G_UNLIKELY (!G_VALUE_HOLDS (value, info->type) &&
          !GST_VALUE_HOLDS_LIST (value))) {
    g_warning ("tag '%s' should hold value of type '%s', but value of "
        "type '%s' passed", info->nick, g_type_name (info->type),
        g_type_name (G_VALUE_TYPE (value)));
    return;
  }

  tag_quark = info->name_quark;

  if (info->merge_func
      && (value2 = gst_structure_id_get_value (list, tag_quark)) != NULL) {
    GValue dest = { 0, };

    switch (mode) {
      case GST_TAG_MERGE_REPLACE_ALL:
      case GST_TAG_MERGE_REPLACE:
        gst_structure_id_set_value (list, tag_quark, value);
        break;
      case GST_TAG_MERGE_PREPEND:
        if (GST_VALUE_HOLDS_LIST (value2) && !GST_VALUE_HOLDS_LIST (value))
          gst_value_list_prepend_value ((GValue *) value2, value);
        else {
          gst_value_list_merge (&dest, value, value2);
          gst_structure_id_take_value (list, tag_quark, &dest);
        }
        break;
      case GST_TAG_MERGE_APPEND:
        if (GST_VALUE_HOLDS_LIST (value2) && !GST_VALUE_HOLDS_LIST (value))
          gst_value_list_append_value ((GValue *) value2, value);
        else {
          gst_value_list_merge (&dest, value2, value);
          gst_structure_id_take_value (list, tag_quark, &dest);
        }
        break;
      case GST_TAG_MERGE_KEEP:
      case GST_TAG_MERGE_KEEP_ALL:
        break;
      default:
        g_assert_not_reached ();
        break;
    }
  } else {
    switch (mode) {
      case GST_TAG_MERGE_APPEND:
      case GST_TAG_MERGE_KEEP:
        if (gst_structure_id_get_value (list, tag_quark) != NULL)
          break;
        /* fall through */
      case GST_TAG_MERGE_REPLACE_ALL:
      case GST_TAG_MERGE_REPLACE:
      case GST_TAG_MERGE_PREPEND:
        gst_structure_id_set_value (list, tag_quark, value);
        break;
      case GST_TAG_MERGE_KEEP_ALL:
        break;
      default:
        g_assert_not_reached ();
        break;
    }
  }
}

static gboolean
gst_tag_list_copy_foreach (GQuark tag_quark, const GValue * value,
    gpointer user_data)
{
  GstTagCopyData *copy = (GstTagCopyData *) user_data;
  const gchar *tag;

  tag = g_quark_to_string (tag_quark);
  gst_tag_list_add_value_internal (copy->list, copy->mode, tag, value, NULL);

  return TRUE;
}

/**
 * gst_tag_list_insert:
 * @into: list to merge into
 * @from: list to merge from
 * @mode: the mode to use
 *
 * Inserts the tags of the @from list into the first list using the given mode.
 */
void
gst_tag_list_insert (GstTagList * into, const GstTagList * from,
    GstTagMergeMode mode)
{
  GstTagCopyData data;

  g_return_if_fail (GST_IS_TAG_LIST (into));
  g_return_if_fail (gst_tag_list_is_writable (into));
  g_return_if_fail (GST_IS_TAG_LIST (from));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  data.list = into;
  data.mode = mode;
  if (mode == GST_TAG_MERGE_REPLACE_ALL) {
    gst_structure_remove_all_fields (GST_TAG_LIST_STRUCTURE (into));
  }
  gst_structure_foreach (GST_TAG_LIST_STRUCTURE (from),
      gst_tag_list_copy_foreach, &data);
}

/**
 * gst_tag_list_merge:
 * @list1: (allow-none): first list to merge
 * @list2: (allow-none): second list to merge
 * @mode: the mode to use
 *
 * Merges the two given lists into a new list. If one of the lists is %NULL, a
 * copy of the other is returned. If both lists are %NULL, %NULL is returned.
 *
 * Free-function: gst_tag_list_unref
 *
 * Returns: (transfer full) (nullable): the new list
 */
GstTagList *
gst_tag_list_merge (const GstTagList * list1, const GstTagList * list2,
    GstTagMergeMode mode)
{
  GstTagList *list1_cp;
  const GstTagList *list2_cp;

  g_return_val_if_fail (list1 == NULL || GST_IS_TAG_LIST (list1), NULL);
  g_return_val_if_fail (list2 == NULL || GST_IS_TAG_LIST (list2), NULL);
  g_return_val_if_fail (GST_TAG_MODE_IS_VALID (mode), NULL);

  /* nothing to merge */
  if (!list1 && !list2) {
    return NULL;
  }

  /* create empty list, we need to do this to correctly handling merge modes */
  list1_cp = (list1) ? gst_tag_list_copy (list1) : gst_tag_list_new_empty ();
  list2_cp = (list2) ? list2 : gst_tag_list_new_empty ();

  gst_tag_list_insert (list1_cp, list2_cp, mode);

  if (!list2)
    gst_tag_list_unref ((GstTagList *) list2_cp);

  return list1_cp;
}

/**
 * gst_tag_list_get_tag_size:
 * @list: a taglist
 * @tag: the tag to query
 *
 * Checks how many value are stored in this tag list for the given tag.
 *
 * Returns: The number of tags stored
 */
guint
gst_tag_list_get_tag_size (const GstTagList * list, const gchar * tag)
{
  const GValue *value;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), 0);

  value = gst_structure_get_value (GST_TAG_LIST_STRUCTURE (list), tag);
  if (value == NULL)
    return 0;
  if (G_VALUE_TYPE (value) != GST_TYPE_LIST)
    return 1;

  return gst_value_list_get_size (value);
}

/**
 * gst_tag_list_add:
 * @list: list to set tags in
 * @mode: the mode to use
 * @tag: tag
 * @...: %NULL-terminated list of values to set
 *
 * Sets the values for the given tags using the specified mode.
 */
void
gst_tag_list_add (GstTagList * list, GstTagMergeMode mode, const gchar * tag,
    ...)
{
  va_list args;

  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (tag != NULL);

  va_start (args, tag);
  gst_tag_list_add_valist (list, mode, tag, args);
  va_end (args);
}

/**
 * gst_tag_list_add_values:
 * @list: list to set tags in
 * @mode: the mode to use
 * @tag: tag
 * @...: GValues to set
 *
 * Sets the GValues for the given tags using the specified mode.
 */
void
gst_tag_list_add_values (GstTagList * list, GstTagMergeMode mode,
    const gchar * tag, ...)
{
  va_list args;

  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (tag != NULL);

  va_start (args, tag);
  gst_tag_list_add_valist_values (list, mode, tag, args);
  va_end (args);
}

/**
 * gst_tag_list_add_valist:
 * @list: list to set tags in
 * @mode: the mode to use
 * @tag: tag
 * @var_args: tag / value pairs to set
 *
 * Sets the values for the given tags using the specified mode.
 */
void
gst_tag_list_add_valist (GstTagList * list, GstTagMergeMode mode,
    const gchar * tag, va_list var_args)
{
  GstTagInfo *info;
  gchar *error = NULL;

  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (tag != NULL);

  if (mode == GST_TAG_MERGE_REPLACE_ALL) {
    gst_structure_remove_all_fields (GST_TAG_LIST_STRUCTURE (list));
  }

  while (tag != NULL) {
    GValue value = { 0, };

    info = gst_tag_lookup (tag);
    if (G_UNLIKELY (info == NULL)) {
      g_warning ("unknown tag '%s'", tag);
      return;
    }
    G_VALUE_COLLECT_INIT (&value, info->type, var_args, 0, &error);
    if (error) {
      g_warning ("%s: %s", G_STRLOC, error);
      g_free (error);
      /* we purposely leak the value here, it might not be
       * in a sane state if an error condition occoured
       */
      return;
    }
    /* Facilitate GstBuffer -> GstSample transition */
    if (G_UNLIKELY (info->type == GST_TYPE_SAMPLE &&
            !GST_IS_SAMPLE (value.data[0].v_pointer))) {
      g_warning ("Expected GstSample argument for tag '%s'", tag);
    } else {
      gst_tag_list_add_value_internal (list, mode, tag, &value, info);
    }
    g_value_unset (&value);
    tag = va_arg (var_args, gchar *);
  }
}

/**
 * gst_tag_list_add_valist_values:
 * @list: list to set tags in
 * @mode: the mode to use
 * @tag: tag
 * @var_args: tag / GValue pairs to set
 *
 * Sets the GValues for the given tags using the specified mode.
 */
void
gst_tag_list_add_valist_values (GstTagList * list, GstTagMergeMode mode,
    const gchar * tag, va_list var_args)
{
  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (tag != NULL);

  if (mode == GST_TAG_MERGE_REPLACE_ALL) {
    gst_structure_remove_all_fields (GST_TAG_LIST_STRUCTURE (list));
  }

  while (tag != NULL) {
    GstTagInfo *info;

    info = gst_tag_lookup (tag);
    if (G_UNLIKELY (info == NULL)) {
      g_warning ("unknown tag '%s'", tag);
      return;
    }
    gst_tag_list_add_value_internal (list, mode, tag, va_arg (var_args,
            GValue *), info);
    tag = va_arg (var_args, gchar *);
  }
}

/**
 * gst_tag_list_add_value:
 * @list: list to set tags in
 * @mode: the mode to use
 * @tag: tag
 * @value: GValue for this tag
 *
 * Sets the GValue for a given tag using the specified mode.
 */
void
gst_tag_list_add_value (GstTagList * list, GstTagMergeMode mode,
    const gchar * tag, const GValue * value)
{
  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (gst_tag_list_is_writable (list));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (tag != NULL);

  gst_tag_list_add_value_internal (list, mode, tag, value, NULL);
}

/**
 * gst_tag_list_remove_tag:
 * @list: list to remove tag from
 * @tag: tag to remove
 *
 * Removes the given tag from the taglist.
 */
void
gst_tag_list_remove_tag (GstTagList * list, const gchar * tag)
{
  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (tag != NULL);

  gst_structure_remove_field (GST_TAG_LIST_STRUCTURE (list), tag);
}

typedef struct
{
  GstTagForeachFunc func;
  const GstTagList *tag_list;
  gpointer data;
}
TagForeachData;

static int
structure_foreach_wrapper (GQuark field_id, const GValue * value,
    gpointer user_data)
{
  TagForeachData *data = (TagForeachData *) user_data;

  data->func (data->tag_list, g_quark_to_string (field_id), data->data);
  return TRUE;
}

/**
 * gst_tag_list_foreach:
 * @list: list to iterate over
 * @func: (scope call): function to be called for each tag
 * @user_data: (closure): user specified data
 *
 * Calls the given function for each tag inside the tag list. Note that if there
 * is no tag, the function won't be called at all.
 */
void
gst_tag_list_foreach (const GstTagList * list, GstTagForeachFunc func,
    gpointer user_data)
{
  TagForeachData data;

  g_return_if_fail (GST_IS_TAG_LIST (list));
  g_return_if_fail (func != NULL);

  data.func = func;
  data.tag_list = list;
  data.data = user_data;
  gst_structure_foreach (GST_TAG_LIST_STRUCTURE (list),
      structure_foreach_wrapper, &data);
}

/**
 * gst_tag_list_get_value_index:
 * @list: a #GstTagList
 * @tag: tag to read out
 * @index: number of entry to read out
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: (transfer none) (nullable): The GValue for the specified
 *          entry or %NULL if the tag wasn't available or the tag
 *          doesn't have as many entries
 */
const GValue *
gst_tag_list_get_value_index (const GstTagList * list, const gchar * tag,
    guint index)
{
  const GValue *value;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), NULL);
  g_return_val_if_fail (tag != NULL, NULL);

  value = gst_structure_get_value (GST_TAG_LIST_STRUCTURE (list), tag);
  if (value == NULL)
    return NULL;

  if (GST_VALUE_HOLDS_LIST (value)) {
    if (index >= gst_value_list_get_size (value))
      return NULL;
    return gst_value_list_get_value (value, index);
  } else {
    if (index > 0)
      return NULL;
    return value;
  }
}

/**
 * gst_tag_list_copy_value:
 * @dest: (out caller-allocates): uninitialized #GValue to copy into
 * @list: list to get the tag from
 * @tag: tag to read out
 *
 * Copies the contents for the given tag into the value,
 * merging multiple values into one if multiple values are associated
 * with the tag.
 * You must g_value_unset() the value after use.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *          given list.
 */
gboolean
gst_tag_list_copy_value (GValue * dest, const GstTagList * list,
    const gchar * tag)
{
  const GValue *src;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (dest != NULL, FALSE);
  g_return_val_if_fail (G_VALUE_TYPE (dest) == 0, FALSE);

  src = gst_structure_get_value (GST_TAG_LIST_STRUCTURE (list), tag);
  if (!src)
    return FALSE;

  if (G_VALUE_TYPE (src) == GST_TYPE_LIST) {
    GstTagInfo *info = gst_tag_lookup (tag);

    if (!info)
      return FALSE;

    /* must be there or lists aren't allowed */
    g_assert (info->merge_func);
    info->merge_func (dest, src);
  } else {
    g_value_init (dest, G_VALUE_TYPE (src));
    g_value_copy (src, dest);
  }
  return TRUE;
}

/* FIXME 0.11: this whole merge function business is overdesigned, and the
 * _get_foo() API is misleading as well - how many application developers will
 * expect gst_tag_list_get_string (list, GST_TAG_ARTIST, &val) might return a
 * string with multiple comma-separated artists? _get_foo() should just be
 * a convenience wrapper around _get_foo_index (list, tag, 0, &val),
 * supplemented by a special _tag_list_get_string_merged() function if needed
 * (unless someone can actually think of real use cases where the merge
 * function is not 'use first' for non-strings and merge for strings) */

/***** evil macros to get all the gst_tag_list_get_*() functions right *****/

#define TAG_MERGE_FUNCS(name,type,ret)                                  \
gboolean                                                                \
gst_tag_list_get_ ## name (const GstTagList *list, const gchar *tag,    \
                           type *value)                                 \
{                                                                       \
  GValue v = { 0, };                                                    \
                                                                        \
  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);                 \
  g_return_val_if_fail (tag != NULL, FALSE);                            \
  g_return_val_if_fail (value != NULL, FALSE);                          \
                                                                        \
  if (!gst_tag_list_copy_value (&v, list, tag))                         \
      return FALSE;                                                     \
  *value = COPY_FUNC (g_value_get_ ## name (&v));                       \
  g_value_unset (&v);                                                   \
  return ret;                                                           \
}                                                                       \
                                                                        \
gboolean                                                                \
gst_tag_list_get_ ## name ## _index (const GstTagList *list,            \
                                     const gchar *tag,                  \
                                     guint index, type *value)          \
{                                                                       \
  const GValue *v;                                                      \
                                                                        \
  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);                 \
  g_return_val_if_fail (tag != NULL, FALSE);                            \
  g_return_val_if_fail (value != NULL, FALSE);                          \
                                                                        \
  if ((v = gst_tag_list_get_value_index (list, tag, index)) == NULL)    \
      return FALSE;                                                     \
  *value = COPY_FUNC (g_value_get_ ## name (v));                        \
  return ret;                                                           \
}

#define COPY_FUNC /**/
/**
 * gst_tag_list_get_boolean:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_boolean_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (boolean, gboolean, TRUE);
/**
 * gst_tag_list_get_int:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_int_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (int, gint, TRUE);
/**
 * gst_tag_list_get_uint:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_uint_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (uint, guint, TRUE);
/**
 * gst_tag_list_get_int64_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (int64, gint64, TRUE);
/**
 * gst_tag_list_get_uint64:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_uint64_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (uint64, guint64, TRUE);
/**
 * gst_tag_list_get_float:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_float_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (float, gfloat, TRUE);
/**
 * gst_tag_list_get_double:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_double_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (double, gdouble, TRUE);
/**
 * gst_tag_list_get_pointer:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out) (transfer none): location for the result
 *
 * Copies the contents for the given tag into the value, merging multiple values
 * into one if multiple values are associated with the tag.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_pointer_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out) (transfer none): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (pointer, gpointer, (*value != NULL));

static inline gchar *
_gst_strdup0 (const gchar * s)
{
  if (s == NULL || *s == '\0')
    return NULL;

  return g_strdup (s);
}

#undef COPY_FUNC
#define COPY_FUNC _gst_strdup0

/**
 * gst_tag_list_get_string:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out callee-allocates) (transfer full): location for the result
 *
 * Copies the contents for the given tag into the value, possibly merging
 * multiple values into one if multiple values are associated with the tag.
 *
 * Use gst_tag_list_get_string_index (list, tag, 0, value) if you want
 * to retrieve the first string associated with this tag unmodified.
 *
 * The resulting string in @value will be in UTF-8 encoding and should be
 * freed by the caller using g_free when no longer needed. The
 * returned string is also guaranteed to be non-%NULL and non-empty.
 *
 * Free-function: g_free
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
/**
 * gst_tag_list_get_string_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out callee-allocates) (transfer full): location for the result
 *
 * Gets the value that is at the given index for the given tag in the given
 * list.
 *
 * The resulting string in @value will be in UTF-8 encoding and should be
 * freed by the caller using g_free when no longer needed. The
 * returned string is also guaranteed to be non-%NULL and non-empty.
 *
 * Free-function: g_free
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list.
 */
TAG_MERGE_FUNCS (string, gchar *, (*value != NULL));

/*
 *FIXME 0.11: Instead of _peek (non-copy) and _get (copy), we could have
 *            _get (non-copy) and _dup (copy) for strings, seems more
 *            widely used
 */
/**
 * gst_tag_list_peek_string_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out) (transfer none): location for the result
 *
 * Peeks at the value that is at the given index for the given tag in the given
 * list.
 *
 * The resulting string in @value will be in UTF-8 encoding and doesn't need
 * to be freed by the caller. The returned string is also guaranteed to
 * be non-%NULL and non-empty.
 *
 * Returns: %TRUE, if a value was set, %FALSE if the tag didn't exist in the
 *              given list.
 */
gboolean
gst_tag_list_peek_string_index (const GstTagList * list,
    const gchar * tag, guint index, const gchar ** value)
{
  const GValue *v;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  if ((v = gst_tag_list_get_value_index (list, tag, index)) == NULL)
    return FALSE;
  *value = g_value_get_string (v);
  return *value != NULL && **value != '\0';
}

/**
 * gst_tag_list_get_date:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out callee-allocates) (transfer full): address of a GDate pointer
 *     variable to store the result into
 *
 * Copies the first date for the given tag in the taglist into the variable
 * pointed to by @value. Free the date with g_date_free() when it is no longer
 * needed.
 *
 * Free-function: g_date_free
 *
 * Returns: %TRUE, if a date was copied, %FALSE if the tag didn't exist in the
 *              given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_date (const GstTagList * list, const gchar * tag,
    GDate ** value)
{
  GValue v = { 0, };

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  if (!gst_tag_list_copy_value (&v, list, tag))
    return FALSE;
  *value = (GDate *) g_value_dup_boxed (&v);
  g_value_unset (&v);
  return (*value != NULL);
}

/**
 * gst_tag_list_get_date_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out callee-allocates) (transfer full): location for the result
 *
 * Gets the date that is at the given index for the given tag in the given
 * list and copies it into the variable pointed to by @value. Free the date
 * with g_date_free() when it is no longer needed.
 *
 * Free-function: g_date_free
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_date_index (const GstTagList * list,
    const gchar * tag, guint index, GDate ** value)
{
  const GValue *v;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  if ((v = gst_tag_list_get_value_index (list, tag, index)) == NULL)
    return FALSE;
  *value = (GDate *) g_value_dup_boxed (v);
  return (*value != NULL);
}

/**
 * gst_tag_list_get_date_time:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @value: (out callee-allocates) (transfer full): address of a #GstDateTime
 *     pointer variable to store the result into
 *
 * Copies the first datetime for the given tag in the taglist into the variable
 * pointed to by @value. Unref the date with gst_date_time_unref() when
 * it is no longer needed.
 *
 * Free-function: gst_date_time_unref
 *
 * Returns: %TRUE, if a datetime was copied, %FALSE if the tag didn't exist in
 *              the given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_date_time (const GstTagList * list, const gchar * tag,
    GstDateTime ** value)
{
  GValue v = { 0, };

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  if (!gst_tag_list_copy_value (&v, list, tag))
    return FALSE;

  *value = (GstDateTime *) g_value_dup_boxed (&v);
  g_value_unset (&v);
  return (*value != NULL);
}

/**
 * gst_tag_list_get_date_time_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @value: (out callee-allocates) (transfer full): location for the result
 *
 * Gets the datetime that is at the given index for the given tag in the given
 * list and copies it into the variable pointed to by @value. Unref the datetime
 * with gst_date_time_unref() when it is no longer needed.
 *
 * Free-function: gst_date_time_unref
 *
 * Returns: %TRUE, if a value was copied, %FALSE if the tag didn't exist in the
 *              given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_date_time_index (const GstTagList * list,
    const gchar * tag, guint index, GstDateTime ** value)
{
  const GValue *v;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  if ((v = gst_tag_list_get_value_index (list, tag, index)) == NULL)
    return FALSE;
  *value = (GstDateTime *) g_value_dup_boxed (v);
  return (*value != NULL);
}

/**
 * gst_tag_list_get_sample:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @sample: (out callee-allocates) (transfer full): address of a GstSample
 *     pointer variable to store the result into
 *
 * Copies the first sample for the given tag in the taglist into the variable
 * pointed to by @sample. Free the sample with gst_sample_unref() when it is
 * no longer needed. You can retrieve the buffer from the sample using
 * gst_sample_get_buffer() and the associated caps (if any) with
 * gst_sample_get_caps().
 *
 * Free-function: gst_sample_unref
 *
 * Returns: %TRUE, if a sample was returned, %FALSE if the tag didn't exist in
 *              the given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_sample (const GstTagList * list, const gchar * tag,
    GstSample ** sample)
{
  GValue v = { 0, };

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (sample != NULL, FALSE);

  if (!gst_tag_list_copy_value (&v, list, tag))
    return FALSE;
  *sample = g_value_dup_boxed (&v);
  g_value_unset (&v);
  return (*sample != NULL);
}

/**
 * gst_tag_list_get_sample_index:
 * @list: a #GstTagList to get the tag from
 * @tag: tag to read out
 * @index: number of entry to read out
 * @sample: (out callee-allocates) (transfer full): address of a GstSample
 *     pointer variable to store the result into
 *
 * Gets the sample that is at the given index for the given tag in the given
 * list and copies it into the variable pointed to by @sample. Free the sample
 * with gst_sample_unref() when it is no longer needed. You can retrieve the
 * buffer from the sample using gst_sample_get_buffer() and the associated
 * caps (if any) with gst_sample_get_caps().
 *
 * Free-function: gst_sample_unref
 *
 * Returns: %TRUE, if a sample was copied, %FALSE if the tag didn't exist in the
 *              given list or if it was %NULL.
 */
gboolean
gst_tag_list_get_sample_index (const GstTagList * list,
    const gchar * tag, guint index, GstSample ** sample)
{
  const GValue *v;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), FALSE);
  g_return_val_if_fail (tag != NULL, FALSE);
  g_return_val_if_fail (sample != NULL, FALSE);

  if ((v = gst_tag_list_get_value_index (list, tag, index)) == NULL)
    return FALSE;
  *sample = g_value_dup_boxed (v);
  return (*sample != NULL);
}
