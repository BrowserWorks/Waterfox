/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gstid3tag.c: plugin for reading / modifying id3 tags
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
 * SECTION:gsttagid3
 * @short_description: tag mappings and support functions for plugins
 *                     dealing with ID3v1 and ID3v2 tags
 * @see_also: #GstTagList
 * 
 * <refsect2>
 * <para>
 * Contains various utility functions for plugins to parse or create
 * ID3 tags and map ID3v2 identifiers to and from GStreamer identifiers.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gsttageditingprivate.h"
#include <stdlib.h>
#include <string.h>

#include "id3v2.h"

#ifndef GST_DISABLE_GST_DEBUG
#define GST_CAT_DEFAULT id3v2_ensure_debug_category()
#endif

static const gchar genres[] =
    "Blues\000Classic Rock\000Country\000Dance\000Disco\000Funk\000Grunge\000"
    "Hip-Hop\000Jazz\000Metal\000New Age\000Oldies\000Other\000Pop\000R&B\000"
    "Rap\000Reggae\000Rock\000Techno\000Industrial\000Alternative\000Ska\000"
    "Death Metal\000Pranks\000Soundtrack\000Euro-Techno\000Ambient\000Trip-Hop"
    "\000Vocal\000Jazz+Funk\000Fusion\000Trance\000Classical\000Instrumental\000"
    "Acid\000House\000Game\000Sound Clip\000Gospel\000Noise\000Alternative Rock"
    "\000Bass\000Soul\000Punk\000Space\000Meditative\000Instrumental Pop\000"
    "Instrumental Rock\000Ethnic\000Gothic\000Darkwave\000Techno-Industrial\000"
    "Electronic\000Pop-Folk\000Eurodance\000Dream\000Southern Rock\000Comedy"
    "\000Cult\000Gangsta\000Top 40\000Christian Rap\000Pop/Funk\000Jungle\000"
    "Native American\000Cabaret\000New Wave\000Psychedelic\000Rave\000Showtunes"
    "\000Trailer\000Lo-Fi\000Tribal\000Acid Punk\000Acid Jazz\000Polka\000"
    "Retro\000Musical\000Rock & Roll\000Hard Rock\000Folk\000Folk/Rock\000"
    "National Folk\000Swing\000Bebob\000Latin\000Revival\000Celtic\000Bluegrass"
    "\000Avantgarde\000Gothic Rock\000Progressive Rock\000Psychedelic Rock\000"
    "Symphonic Rock\000Slow Rock\000Big Band\000Chorus\000Easy Listening\000"
    "Acoustic\000Humour\000Speech\000Chanson\000Opera\000Chamber Music\000"
    "Sonata\000Symphony\000Booty Bass\000Primus\000Porn Groove\000Satire\000"
    "Slow Jam\000Club\000Tango\000Samba\000Folklore\000Ballad\000Power Ballad\000"
    "Rhythmic Soul\000Freestyle\000Duet\000Punk Rock\000Drum Solo\000A Capella"
    "\000Euro-House\000Dance Hall\000Goa\000Drum & Bass\000Club-House\000"
    "Hardcore\000Terror\000Indie\000BritPop\000Negerpunk\000Polsk Punk\000"
    "Beat\000Christian Gangsta Rap\000Heavy Metal\000Black Metal\000"
    "Crossover\000Contemporary Christian\000Christian Rock\000Merengue\000"
    "Salsa\000Thrash Metal\000Anime\000Jpop\000Synthpop";

static const guint16 genres_idx[] = {
  0, 6, 19, 27, 33, 39, 44, 51, 59, 64, 70, 78, 85, 91, 95, 99, 103, 110, 115,
  122, 133, 145, 149, 161, 168, 179, 191, 199, 208, 214, 224, 231, 238, 248,
  261, 266, 272, 277, 288, 295, 301, 318, 323, 328, 333, 339, 350, 367, 385,
  392, 399, 408, 426, 437, 446, 456, 462, 476, 483, 488, 496, 503, 517, 526,
  533, 549, 557, 566, 578, 583, 593, 601, 607, 614, 624, 634, 640, 646, 654,
  666, 676, 681, 691, 705, 224, 711, 717, 723, 731, 738, 748, 759, 771, 788,
  805, 820, 830, 839, 846, 861, 870, 877, 884, 892, 898, 912, 919, 928, 939,
  946, 958, 965, 974, 979, 985, 991, 1000, 1007, 1020, 1034, 1044, 1049,
  1059, 1069, 1079, 1090, 1101, 1105, 1117, 1128, 1137, 1144, 1150, 1158,
  1168, 1179, 1184, 1206, 1218, 1230, 1240, 1263, 1278, 1287, 1293, 1306,
  1312, 1317
};

static const GstTagEntryMatch tag_matches[] = {
  {GST_TAG_TITLE, "TIT2"},
  {GST_TAG_ALBUM, "TALB"},
  {GST_TAG_TRACK_NUMBER, "TRCK"},
  {GST_TAG_ARTIST, "TPE1"},
  {GST_TAG_ALBUM_ARTIST, "TPE2"},
  {GST_TAG_COMPOSER, "TCOM"},
  {GST_TAG_COPYRIGHT, "TCOP"},
  {GST_TAG_COPYRIGHT_URI, "WCOP"},
  {GST_TAG_ENCODED_BY, "TENC"},
  {GST_TAG_GENRE, "TCON"},
  {GST_TAG_DATE_TIME, "TDRC"},
  {GST_TAG_COMMENT, "COMM"},
  {GST_TAG_ALBUM_VOLUME_NUMBER, "TPOS"},
  {GST_TAG_DURATION, "TLEN"},
  {GST_TAG_ISRC, "TSRC"},
  {GST_TAG_IMAGE, "APIC"},
  {GST_TAG_ENCODER, "TSSE"},
  {GST_TAG_BEATS_PER_MINUTE, "TBPM"},
  {GST_TAG_ARTIST_SORTNAME, "TSOP"},
  {GST_TAG_ALBUM_SORTNAME, "TSOA"},
  {GST_TAG_TITLE_SORTNAME, "TSOT"},
  {GST_TAG_PUBLISHER, "TPUB"},
  {GST_TAG_INTERPRETED_BY, "TPE4"},
  {GST_TAG_MUSICAL_KEY, "TKEY"},
  {NULL, NULL}
};

/**
 * gst_tag_from_id3_tag:
 * @id3_tag: ID3v2 tag to convert to GStreamer tag
 *
 * Looks up the GStreamer tag for a ID3v2 tag.
 *
 * Returns: The corresponding GStreamer tag or NULL if none exists.
 */
const gchar *
gst_tag_from_id3_tag (const gchar * id3_tag)
{
  int i = 0;

  g_return_val_if_fail (id3_tag != NULL, NULL);

  while (tag_matches[i].gstreamer_tag != NULL) {
    if (strncmp (id3_tag, tag_matches[i].original_tag, 5) == 0) {
      return tag_matches[i].gstreamer_tag;
    }
    i++;
  }

  GST_FIXME ("Cannot map ID3v2 tag '%c%c%c%c' to GStreamer tag",
      id3_tag[0], id3_tag[1], id3_tag[2], id3_tag[3]);

  return NULL;
}

static const GstTagEntryMatch user_tag_matches[] = {
  /* musicbrainz identifiers being used in the real world (foobar2000) */
  {GST_TAG_MUSICBRAINZ_ARTISTID, "TXXX|musicbrainz_artistid"},
  {GST_TAG_MUSICBRAINZ_ALBUMID, "TXXX|musicbrainz_albumid"},
  {GST_TAG_MUSICBRAINZ_ALBUMARTISTID, "TXXX|musicbrainz_albumartistid"},
  {GST_TAG_MUSICBRAINZ_TRMID, "TXXX|musicbrainz_trmid"},
  {GST_TAG_CDDA_MUSICBRAINZ_DISCID, "TXXX|musicbrainz_discid"},
  /* musicbrainz identifiers according to spec no one pays
   * attention to (http://musicbrainz.org/docs/specs/metadata_tags.html) */
  {GST_TAG_MUSICBRAINZ_ARTISTID, "TXXX|MusicBrainz Artist Id"},
  {GST_TAG_MUSICBRAINZ_ALBUMID, "TXXX|MusicBrainz Album Id"},
  {GST_TAG_MUSICBRAINZ_ALBUMARTISTID, "TXXX|MusicBrainz Album Artist Id"},
  {GST_TAG_MUSICBRAINZ_TRMID, "TXXX|MusicBrainz TRM Id"},
  /* according to: http://wiki.musicbrainz.org/MusicBrainzTag (yes, no space
   * before 'ID' and not 'Id' either this time, yay for consistency) */
  {GST_TAG_CDDA_MUSICBRAINZ_DISCID, "TXXX|MusicBrainz DiscID"},
  /* foobar2000 uses these identifiers to store gain/peak information in
   * ID3v2 tags <= v2.3.0. In v2.4.0 there's the RVA2 frame for that */
  {GST_TAG_TRACK_GAIN, "TXXX|replaygain_track_gain"},
  {GST_TAG_TRACK_PEAK, "TXXX|replaygain_track_peak"},
  {GST_TAG_ALBUM_GAIN, "TXXX|replaygain_album_gain"},
  {GST_TAG_ALBUM_PEAK, "TXXX|replaygain_album_peak"},
  /* the following two are more or less made up, there seems to be little
   * evidence that any popular application is actually putting this info
   * into TXXX frames; the first one comes from a musicbrainz wiki 'proposed
   * tags' page, the second one is analogue to the vorbis/ape/flac tag. */
  {GST_TAG_CDDA_CDDB_DISCID, "TXXX|discid"},
  {GST_TAG_CDDA_CDDB_DISCID, "TXXX|CDDB DiscID"}
};

/**
 * gst_tag_from_id3_user_tag:
 * @type: the type of ID3v2 user tag (e.g. "TXXX" or "UDIF")
 * @id3_user_tag: ID3v2 user tag to convert to GStreamer tag
 *
 * Looks up the GStreamer tag for an ID3v2 user tag (e.g. description in
 * TXXX frame or owner in UFID frame).
 *
 * Returns: The corresponding GStreamer tag or NULL if none exists.
 */
const gchar *
gst_tag_from_id3_user_tag (const gchar * type, const gchar * id3_user_tag)
{
  int i = 0;

  g_return_val_if_fail (type != NULL && strlen (type) == 4, NULL);
  g_return_val_if_fail (id3_user_tag != NULL, NULL);

  for (i = 0; i < G_N_ELEMENTS (user_tag_matches); ++i) {
    if (strncmp (type, user_tag_matches[i].original_tag, 4) == 0 &&
        g_ascii_strcasecmp (id3_user_tag,
            user_tag_matches[i].original_tag + 5) == 0) {
      GST_LOG ("Mapped ID3v2 user tag '%s' to GStreamer tag '%s'",
          user_tag_matches[i].original_tag, user_tag_matches[i].gstreamer_tag);
      return user_tag_matches[i].gstreamer_tag;
    }
  }

  GST_FIXME ("Cannot map ID3v2 user tag '%s' of type '%s' to GStreamer tag",
      id3_user_tag, type);

  return NULL;
}

/**
 * gst_tag_to_id3_tag:
 * @gst_tag: GStreamer tag to convert to vorbiscomment tag
 *
 * Looks up the ID3v2 tag for a GStreamer tag.
 *
 * Returns: The corresponding ID3v2 tag or NULL if none exists.
 */
const gchar *
gst_tag_to_id3_tag (const gchar * gst_tag)
{
  int i = 0;

  g_return_val_if_fail (gst_tag != NULL, NULL);

  while (tag_matches[i].gstreamer_tag != NULL) {
    if (strcmp (gst_tag, tag_matches[i].gstreamer_tag) == 0) {
      return tag_matches[i].original_tag;
    }
    i++;
  }
  return NULL;
}

static void
gst_tag_extract_id3v1_string (GstTagList * list, const gchar * tag,
    const gchar * start, const guint size)
{
  const gchar *env_vars[] = { "GST_ID3V1_TAG_ENCODING",
    "GST_ID3_TAG_ENCODING", "GST_TAG_ENCODING", NULL
  };
  gchar *utf8;

  utf8 = gst_tag_freeform_string_to_utf8 (start, size, env_vars);

  if (utf8 && *utf8 != '\0') {
    gst_tag_list_add (list, GST_TAG_MERGE_REPLACE, tag, utf8, NULL);
  }

  g_free (utf8);
}

/**
 * gst_tag_list_new_from_id3v1:
 * @data: 128 bytes of data containing the ID3v1 tag
 *
 * Parses the data containing an ID3v1 tag and returns a #GstTagList from the
 * parsed data.
 *
 * Returns: A new tag list or NULL if the data was not an ID3v1 tag.
 */
GstTagList *
gst_tag_list_new_from_id3v1 (const guint8 * data)
{
  guint year;
  gchar *ystr;
  GstTagList *list;

  g_return_val_if_fail (data != NULL, NULL);

  if (data[0] != 'T' || data[1] != 'A' || data[2] != 'G')
    return NULL;
  list = gst_tag_list_new_empty ();
  gst_tag_extract_id3v1_string (list, GST_TAG_TITLE, (gchar *) & data[3], 30);
  gst_tag_extract_id3v1_string (list, GST_TAG_ARTIST, (gchar *) & data[33], 30);
  gst_tag_extract_id3v1_string (list, GST_TAG_ALBUM, (gchar *) & data[63], 30);
  ystr = g_strndup ((gchar *) & data[93], 4);
  year = strtoul (ystr, NULL, 10);
  g_free (ystr);
  if (year > 0) {
    GstDateTime *dt = gst_date_time_new_y (year);

    gst_tag_list_add (list, GST_TAG_MERGE_REPLACE, GST_TAG_DATE_TIME, dt, NULL);
    gst_date_time_unref (dt);
  }
  if (data[125] == 0 && data[126] != 0) {
    gst_tag_extract_id3v1_string (list, GST_TAG_COMMENT, (gchar *) & data[97],
        28);
    gst_tag_list_add (list, GST_TAG_MERGE_REPLACE, GST_TAG_TRACK_NUMBER,
        (guint) data[126], NULL);
  } else {
    gst_tag_extract_id3v1_string (list, GST_TAG_COMMENT, (gchar *) & data[97],
        30);
  }
  if (data[127] < gst_tag_id3_genre_count () && !gst_tag_list_is_empty (list)) {
    gst_tag_list_add (list, GST_TAG_MERGE_REPLACE, GST_TAG_GENRE,
        gst_tag_id3_genre_get (data[127]), NULL);
  }

  return list;
}

/**
 * gst_tag_id3_genre_count:
 *
 * Gets the number of ID3v1 genres that can be identified. Winamp genres are 
 * included.
 *
 * Returns: the number of ID3v1 genres that can be identified
 */
guint
gst_tag_id3_genre_count (void)
{
  return G_N_ELEMENTS (genres_idx);
}

/**
 * gst_tag_id3_genre_get:
 * @id: ID of genre to query
 *
 * Gets the ID3v1 genre name for a given ID.
 *
 * Returns: the genre or NULL if no genre is associated with that ID.
 */
const gchar *
gst_tag_id3_genre_get (const guint id)
{
  guint idx;

  if (id >= G_N_ELEMENTS (genres_idx))
    return NULL;
  idx = genres_idx[id];
  g_assert (idx < sizeof (genres));
  return &genres[idx];
}

/**
 * gst_tag_list_add_id3_image:
 * @tag_list: a tag list
 * @image_data: the (encoded) image
 * @image_data_len: the length of the encoded image data at @image_data
 * @id3_picture_type: picture type as per the ID3 (v2.4.0) specification for
 *    the APIC frame (0 = unknown/other)
 *
 * Adds an image from an ID3 APIC frame (or similar, such as used in FLAC)
 * to the given tag list. Also see gst_tag_image_data_to_image_sample() for
 * more information on image tags in GStreamer.
 *
 * Returns: %TRUE if the image was processed, otherwise %FALSE
 */
gboolean
gst_tag_list_add_id3_image (GstTagList * tag_list, const guint8 * image_data,
    guint image_data_len, guint id3_picture_type)
{
  GstTagImageType tag_image_type;
  const gchar *tag_name;
  GstSample *image;

  g_return_val_if_fail (GST_IS_TAG_LIST (tag_list), FALSE);
  g_return_val_if_fail (image_data != NULL, FALSE);
  g_return_val_if_fail (image_data_len > 0, FALSE);

  if (id3_picture_type == 0x01 || id3_picture_type == 0x02) {
    /* file icon for preview. Don't add image-type to caps, since there
     * is only supposed to be one of these, and the type is already indicated
     * via the special tag */
    tag_name = GST_TAG_PREVIEW_IMAGE;
    tag_image_type = GST_TAG_IMAGE_TYPE_NONE;
  } else {
    tag_name = GST_TAG_IMAGE;

    /* Remap the ID3v2 APIC type our ImageType enum */
    if (id3_picture_type >= 0x3 && id3_picture_type <= 0x14)
      tag_image_type = (GstTagImageType) (id3_picture_type - 2);
    else
      tag_image_type = GST_TAG_IMAGE_TYPE_UNDEFINED;
  }

  image = gst_tag_image_data_to_image_sample (image_data, image_data_len,
      tag_image_type);

  if (image == NULL)
    return FALSE;

  gst_tag_list_add (tag_list, GST_TAG_MERGE_APPEND, tag_name, image, NULL);
  gst_sample_unref (image);
  return TRUE;
}
