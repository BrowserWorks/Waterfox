/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gstvorbistag.c: library for reading / modifying vorbis tags
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
 * SECTION:gsttagvorbis
 * @short_description: tag mappings and support functions for plugins
 *                     dealing with vorbiscomments
 * @see_also: #GstTagList
 *
 * <refsect2>
 * <para>
 * Contains various utility functions for plugins to parse or create
 * vorbiscomments and map them to and from #GstTagList<!-- -->s.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <gst/gsttagsetter.h>
#include <gst/base/gstbytereader.h>
#include <gst/base/gstbytewriter.h>
#include "gsttageditingprivate.h"
#include <stdlib.h>
#include <string.h>

/*
 * see http://xiph.org/ogg/vorbis/doc/v-comment.html
 */
static const GstTagEntryMatch tag_matches[] = {
  {GST_TAG_TITLE, "TITLE"},
  {GST_TAG_VERSION, "VERSION"},
  {GST_TAG_ALBUM, "ALBUM"},
  {GST_TAG_TRACK_NUMBER, "TRACKNUMBER"},
  {GST_TAG_ALBUM_VOLUME_NUMBER, "DISCNUMBER"},
  {GST_TAG_TRACK_COUNT, "TRACKTOTAL"},
  {GST_TAG_TRACK_COUNT, "TOTALTRACKS"}, /* old / non-standard */
  {GST_TAG_ALBUM_VOLUME_COUNT, "DISCTOTAL"},
  {GST_TAG_ALBUM_VOLUME_COUNT, "TOTALDISCS"},   /* old / non-standard */
  {GST_TAG_ARTIST, "ARTIST"},
  {GST_TAG_PERFORMER, "PERFORMER"},
  {GST_TAG_COMPOSER, "COMPOSER"},
  {GST_TAG_COPYRIGHT, "COPYRIGHT"},
  {GST_TAG_LICENSE, "LICENSE"},
  {GST_TAG_LICENSE_URI, "LICENSE"},
  {GST_TAG_GEO_LOCATION_NAME, "LOCATION"},
  {GST_TAG_ORGANIZATION, "ORGANIZATION"},
  {GST_TAG_DESCRIPTION, "DESCRIPTION"},
  {GST_TAG_GENRE, "GENRE"},
  {GST_TAG_DATE_TIME, "DATE"},
  {GST_TAG_CONTACT, "CONTACT"},
  {GST_TAG_ISRC, "ISRC"},
  {GST_TAG_COMMENT, "COMMENT"},
  {GST_TAG_TRACK_GAIN, "REPLAYGAIN_TRACK_GAIN"},
  {GST_TAG_TRACK_PEAK, "REPLAYGAIN_TRACK_PEAK"},
  {GST_TAG_ALBUM_GAIN, "REPLAYGAIN_ALBUM_GAIN"},
  {GST_TAG_ALBUM_PEAK, "REPLAYGAIN_ALBUM_PEAK"},
  {GST_TAG_REFERENCE_LEVEL, "REPLAYGAIN_REFERENCE_LOUDNESS"},
  {GST_TAG_MUSICBRAINZ_TRACKID, "MUSICBRAINZ_TRACKID"},
  {GST_TAG_MUSICBRAINZ_ARTISTID, "MUSICBRAINZ_ARTISTID"},
  {GST_TAG_MUSICBRAINZ_ALBUMID, "MUSICBRAINZ_ALBUMID"},
  {GST_TAG_MUSICBRAINZ_ALBUMARTISTID, "MUSICBRAINZ_ALBUMARTISTID"},
  {GST_TAG_MUSICBRAINZ_TRMID, "MUSICBRAINZ_TRMID"},
  {GST_TAG_ARTIST_SORTNAME, "ARTISTSORT"},
  {GST_TAG_ARTIST_SORTNAME, "ARTISTSORTORDER"},
  {GST_TAG_ARTIST_SORTNAME, "MUSICBRAINZ_SORTNAME"},
  {GST_TAG_ALBUM_SORTNAME, "ALBUMSORT"},
  {GST_TAG_ALBUM_SORTNAME, "ALBUMSORTORDER"},
  {GST_TAG_TITLE_SORTNAME, "TITLESORT"},
  {GST_TAG_TITLE_SORTNAME, "TITLESORTORDER"},
  {GST_TAG_ALBUM_ARTIST, "ALBUMARTIST"},
  {GST_TAG_ALBUM_ARTIST, "ALBUM ARTIST"},
  {GST_TAG_ALBUM_ARTIST_SORTNAME, "ALBUMARTISTSORT"},
  {GST_TAG_ALBUM_ARTIST_SORTNAME, "ALBUMARTISTSORTORDER"},
  {GST_TAG_LANGUAGE_CODE, "LANGUAGE"},
  {GST_TAG_CDDA_MUSICBRAINZ_DISCID, "MUSICBRAINZ_DISCID"},
  {GST_TAG_CDDA_CDDB_DISCID, "DISCID"},
  /* For the apparent de-facto standard for coverart in vorbis comments, see:
   * http://www.hydrogenaudio.org/forums/lofiversion/index.php/t48386.html */
  {GST_TAG_PREVIEW_IMAGE, "COVERART"},
  /* some evidence that "BPM" is used elsewhere:
   * http://mail.kde.org/pipermail/amarok/2006-May/000090.html
   */
  {GST_TAG_BEATS_PER_MINUTE, "BPM"},
  /* What GStreamer calls encoder ("encoder used to encode this stream") is
     stored in the vendor string in Vorbis/Theora/Kate and possibly others.
     The Vorbis comment packet used in those streams uses ENCODER as the name
     of the encoding program, which GStreamer calls application-name. */
  {GST_TAG_APPLICATION_NAME, "ENCODER"},
  {NULL, NULL}
};

/**
 * gst_tag_from_vorbis_tag:
 * @vorbis_tag: vorbiscomment tag to convert to GStreamer tag
 *
 * Looks up the GStreamer tag for a vorbiscomment tag.
 *
 * Returns: The corresponding GStreamer tag or NULL if none exists.
 */
const gchar *
gst_tag_from_vorbis_tag (const gchar * vorbis_tag)
{
  int i = 0;
  gchar *real_vorbis_tag;

  g_return_val_if_fail (vorbis_tag != NULL, NULL);

  gst_tag_register_musicbrainz_tags ();

  real_vorbis_tag = g_ascii_strup (vorbis_tag, -1);
  while (tag_matches[i].gstreamer_tag != NULL) {
    if (strcmp (real_vorbis_tag, tag_matches[i].original_tag) == 0) {
      break;
    }
    i++;
  }
  g_free (real_vorbis_tag);
  return tag_matches[i].gstreamer_tag;
}

/**
 * gst_tag_to_vorbis_tag:
 * @gst_tag: GStreamer tag to convert to vorbiscomment tag
 *
 * Looks up the vorbiscomment tag for a GStreamer tag.
 *
 * Returns: The corresponding vorbiscomment tag or NULL if none exists.
 */
const gchar *
gst_tag_to_vorbis_tag (const gchar * gst_tag)
{
  int i = 0;

  g_return_val_if_fail (gst_tag != NULL, NULL);

  gst_tag_register_musicbrainz_tags ();

  while (tag_matches[i].gstreamer_tag != NULL) {
    if (strcmp (gst_tag, tag_matches[i].gstreamer_tag) == 0) {
      return tag_matches[i].original_tag;
    }
    i++;
  }
  return NULL;
}


/**
 * gst_vorbis_tag_add:
 * @list: a #GstTagList
 * @tag: a vorbiscomment tag string (key in key=value), must be valid UTF-8
 * @value: a vorbiscomment value string (value in key=value), must be valid UTF-8
 *
 * Convenience function using gst_tag_from_vorbis_tag(), parsing
 * a vorbis comment string into the right type and adding it to the
 * given taglist @list.
 *
 * Unknown vorbiscomment tags will be added to the tag list in form
 * of a #GST_TAG_EXTENDED_COMMENT.
 */
void
gst_vorbis_tag_add (GstTagList * list, const gchar * tag, const gchar * value)
{
  const gchar *gst_tag;
  GType tag_type;

  g_return_if_fail (list != NULL);
  g_return_if_fail (tag != NULL);
  g_return_if_fail (value != NULL);

  g_return_if_fail (g_utf8_validate (tag, -1, NULL));
  g_return_if_fail (g_utf8_validate (value, -1, NULL));
  g_return_if_fail (strchr (tag, '=') == NULL);

  gst_tag = gst_tag_from_vorbis_tag (tag);
  if (gst_tag == NULL) {
    gchar *ext_comment;

    ext_comment = g_strdup_printf ("%s=%s", tag, value);
    gst_tag_list_add (list, GST_TAG_MERGE_APPEND, GST_TAG_EXTENDED_COMMENT,
        ext_comment, NULL);
    g_free (ext_comment);
    return;
  }

  tag_type = gst_tag_get_type (gst_tag);
  switch (tag_type) {
    case G_TYPE_UINT:{
      guint tmp;
      gchar *check;
      gboolean is_track_number_tag;
      gboolean is_disc_number_tag;

      is_track_number_tag = (strcmp (gst_tag, GST_TAG_TRACK_NUMBER) == 0);
      is_disc_number_tag = (strcmp (gst_tag, GST_TAG_ALBUM_VOLUME_NUMBER) == 0);
      tmp = strtoul (value, &check, 10);
      if (*check == '/' && (is_track_number_tag || is_disc_number_tag)) {
        guint count;

        check++;
        count = strtoul (check, &check, 10);
        if (*check != '\0' || count == 0)
          break;
        if (is_track_number_tag) {
          gst_tag_list_add (list, GST_TAG_MERGE_APPEND, GST_TAG_TRACK_COUNT,
              count, NULL);
        } else {
          gst_tag_list_add (list, GST_TAG_MERGE_APPEND,
              GST_TAG_ALBUM_VOLUME_COUNT, count, NULL);
        }
      }
      if (*check == '\0') {
        gst_tag_list_add (list, GST_TAG_MERGE_APPEND, gst_tag, tmp, NULL);
      }
      break;
    }
    case G_TYPE_STRING:{
      gchar *valid = NULL;

      /* specialcase for language code */
      if (strcmp (tag, "LANGUAGE") == 0) {
        const gchar *s = strchr (value, '[');

        /* Accept both ISO-639-1 and ISO-639-2 codes */
        if (s && strchr (s, ']') == s + 4) {
          valid = g_strndup (s + 1, 3);
        } else if (s && strchr (s, ']') == s + 3) {
          valid = g_strndup (s + 1, 2);
        } else if (strlen (value) != 2 && strlen (value) != 3) {
          GST_WARNING ("doesn't contain an ISO-639 language code: %s", value);
        }
      } else if (strcmp (tag, "LICENSE") == 0) {
        /* license tags in vorbis comments must contain an URI representing
         * the license and nothing more, at least according to:
         * http://wiki.xiph.org/index.php/LICENSE_and_COPYRIGHT_tags_on_Vorbis_Comments */
        if (value && gst_uri_is_valid (value))
          gst_tag = GST_TAG_LICENSE_URI;
      }

      if (!valid) {
        valid = g_strdup (value);
      }
      gst_tag_list_add (list, GST_TAG_MERGE_APPEND, gst_tag, valid, NULL);
      g_free (valid);
      break;
    }
    case G_TYPE_DOUBLE:{
      gchar *c;

      c = g_strdup (value);
      g_strdelimit (c, ",", '.');
      gst_tag_list_add (list, GST_TAG_MERGE_APPEND, gst_tag,
          g_strtod (c, NULL), NULL);
      g_free (c);
      break;
    }
    default:{
      if (tag_type == GST_TYPE_DATE_TIME) {
        GstDateTime *datetime;

        datetime = gst_date_time_new_from_iso8601_string (value);

        if (datetime) {
          gst_tag_list_add (list, GST_TAG_MERGE_APPEND, gst_tag, datetime,
              NULL);
          gst_date_time_unref (datetime);
        } else {
          GST_WARNING ("could not parse datetime string '%s'", value);
        }
      } else {
        GST_WARNING ("Unhandled tag of type '%s' (%d)",
            g_type_name (tag_type), (gint) tag_type);
      }
      break;
    }
  }
}

static void
gst_vorbis_tag_add_coverart (GstTagList * tags, gchar * img_data_base64,
    gint base64_len)
{
  GstSample *img;
  gsize img_len;

  if (base64_len < 2)
    goto not_enough_data;

  /* img_data_base64 points to a temporary copy of the base64 encoded data, so
   * it's safe to do inpace decoding here
   */
  g_base64_decode_inplace (img_data_base64, &img_len);
  if (img_len == 0)
    goto decode_failed;

  img =
      gst_tag_image_data_to_image_sample ((const guint8 *) img_data_base64,
      img_len, GST_TAG_IMAGE_TYPE_NONE);

  if (img == NULL)
    goto convert_failed;

  gst_tag_list_add (tags, GST_TAG_MERGE_APPEND,
      GST_TAG_PREVIEW_IMAGE, img, NULL);

  gst_sample_unref (img);
  return;

/* ERRORS */
not_enough_data:
  {
    GST_WARNING ("COVERART tag with too little base64-encoded data");
    return;
  }
decode_failed:
  {
    GST_WARNING ("Couldn't decode base64 image data from COVERART tag");
    return;
  }
convert_failed:
  {
    GST_WARNING ("Couldn't extract image or image type from COVERART tag");
    return;
  }
}

/* Standardized way of adding pictures to vorbiscomments:
 * http://wiki.xiph.org/VorbisComment#METADATA_BLOCK_PICTURE
 */
static void
gst_vorbis_tag_add_metadata_block_picture (GstTagList * tags,
    gchar * value, gint value_len)
{
  GstByteReader reader;
  guint32 img_len = 0, img_type = 0;
  guint32 img_mimetype_len = 0, img_description_len = 0;
  gsize decoded_len;
  const guint8 *data = NULL;

  /* img_data_base64 points to a temporary copy of the base64 encoded data, so
   * it's safe to do inpace decoding here
   */
  g_base64_decode_inplace (value, &decoded_len);
  if (decoded_len == 0)
    goto decode_failed;

  gst_byte_reader_init (&reader, (guint8 *) value, decoded_len);

  if (!gst_byte_reader_get_uint32_be (&reader, &img_type))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_mimetype_len))
    goto error;
  if (!gst_byte_reader_skip (&reader, img_mimetype_len))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_description_len))
    goto error;
  if (!gst_byte_reader_skip (&reader, img_description_len))
    goto error;

  /* Skip width, height, color depth and number of colors for
   * indexed formats */
  if (!gst_byte_reader_skip (&reader, 4 * 4))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_len))
    goto error;

  if (!gst_byte_reader_get_data (&reader, img_len, &data))
    goto error;

  gst_tag_list_add_id3_image (tags, data, img_len, img_type);

  return;

error:
  GST_WARNING
      ("Couldn't extract image or image type from METADATA_BLOCK_PICTURE tag");
  return;
decode_failed:
  GST_WARNING ("Failed to decode Base64 data from METADATA_BLOCK_PICTURE tag");
  return;
}

/**
 * gst_tag_list_from_vorbiscomment:
 * @data: data to convert
 * @size: size of @data
 * @id_data: identification data at start of stream
 * @id_data_length: length of identification data
 * @vendor_string: pointer to a string that should take the vendor string
 *                 of this vorbis comment or NULL if you don't need it.
 *
 * Creates a new tag list that contains the information parsed out of a
 * vorbiscomment packet.
 *
 * Returns: A new #GstTagList with all tags that could be extracted from the
 *          given vorbiscomment buffer or NULL on error.
 */
GstTagList *
gst_tag_list_from_vorbiscomment (const guint8 * data, gsize size,
    const guint8 * id_data, const guint id_data_length, gchar ** vendor_string)
{
#define ADVANCE(x) G_STMT_START{                                                \
  data += x;                                                                    \
  size -= x;                                                                    \
  if (size < 4) goto error;                                                     \
  cur_size = GST_READ_UINT32_LE (data);                                         \
  data += 4;                                                                    \
  size -= 4;                                                                    \
  if (cur_size > size) goto error;                                              \
  cur = (gchar*)data;                                                                   \
}G_STMT_END
  gchar *cur, *value;
  guint cur_size;
  guint iterations;
  guint value_len;
  GstTagList *list;

  g_return_val_if_fail (data != NULL, NULL);
  g_return_val_if_fail (id_data != NULL || id_data_length == 0, NULL);

  list = gst_tag_list_new_empty ();

  if (size < 11 || size <= id_data_length + 4)
    goto error;

  if (id_data_length > 0 && memcmp (data, id_data, id_data_length) != 0)
    goto error;

  ADVANCE (id_data_length);

  if (vendor_string)
    *vendor_string = g_strndup (cur, cur_size);

  ADVANCE (cur_size);
  iterations = cur_size;
  cur_size = 0;

  while (iterations) {
    ADVANCE (cur_size);
    iterations--;
    cur = g_strndup (cur, cur_size);
    value = strchr (cur, '=');
    if (value == NULL) {
      g_free (cur);
      continue;
    }
    *value = '\0';
    value++;
    value_len = strlen (value);
    if (value_len == 0 || !g_utf8_validate (value, value_len, NULL)) {
      g_free (cur);
      continue;
    }
    /* we'll just ignore COVERARTMIME and typefind the image data */
    if (g_ascii_strcasecmp (cur, "COVERARTMIME") == 0) {
      g_free (cur);
      continue;
    } else if (g_ascii_strcasecmp (cur, "COVERART") == 0) {
      gst_vorbis_tag_add_coverart (list, value, value_len);
    } else if (g_ascii_strcasecmp (cur, "METADATA_BLOCK_PICTURE") == 0) {
      gst_vorbis_tag_add_metadata_block_picture (list, value, value_len);
    } else {
      gst_vorbis_tag_add (list, cur, value);
    }
    g_free (cur);
  }

  return list;

error:
  gst_tag_list_unref (list);
  return NULL;
#undef ADVANCE
}

/**
 * gst_tag_list_from_vorbiscomment_buffer:
 * @buffer: buffer to convert
 * @id_data: identification data at start of stream
 * @id_data_length: length of identification data
 * @vendor_string: pointer to a string that should take the vendor string
 *                 of this vorbis comment or NULL if you don't need it.
 *
 * Creates a new tag list that contains the information parsed out of a
 * vorbiscomment packet.
 *
 * Returns: A new #GstTagList with all tags that could be extracted from the
 *          given vorbiscomment buffer or NULL on error.
 */
GstTagList *
gst_tag_list_from_vorbiscomment_buffer (GstBuffer * buffer,
    const guint8 * id_data, const guint id_data_length, gchar ** vendor_string)
{
  GstTagList *res;
  GstMapInfo info;

  if (!gst_buffer_map (buffer, &info, GST_MAP_READ))
    g_return_val_if_reached (NULL);

  res =
      gst_tag_list_from_vorbiscomment (info.data, info.size, id_data,
      id_data_length, vendor_string);
  gst_buffer_unmap (buffer, &info);

  return res;
}

typedef struct
{
  guint count;
  guint data_count;
  GList *entries;
}
MyForEach;

static GList *
gst_tag_to_metadata_block_picture (const gchar * tag,
    const GValue * image_value)
{
  gchar *comment_data, *data_result;
  const gchar *mime_type;
  guint mime_type_len;
  GstStructure *mime_struct;
  GstSample *sample;
  GstBuffer *buffer;
  GstCaps *caps;
  GList *l = NULL;
  GstMapInfo mapinfo = { 0, };
  GstByteWriter writer;
  GstTagImageType image_type = GST_TAG_IMAGE_TYPE_NONE;
  gint width = 0, height = 0;
  guint8 *metadata_block;
  guint metadata_block_len;

  g_return_val_if_fail (image_value != NULL, NULL);

  sample = gst_value_get_sample (image_value);
  buffer = gst_sample_get_buffer (sample);
  caps = gst_sample_get_caps (sample);
  g_return_val_if_fail (gst_caps_is_fixed (caps), NULL);
  mime_struct = gst_caps_get_structure (caps, 0);

  mime_type = gst_structure_get_name (mime_struct);
  if (strcmp (mime_type, "text/uri-list") == 0)
    mime_type = "-->";
  mime_type_len = strlen (mime_type);

  /* FIXME 2.0: Remove the image-type reading from the caps, this was
   * a bug until 1.2.2. The image-type is only supposed to be in the
   * info structure */
  gst_structure_get (mime_struct, "image-type", GST_TYPE_TAG_IMAGE_TYPE,
      &image_type, "width", G_TYPE_INT, &width, "height", G_TYPE_INT, &height,
      NULL);

  if (image_type == GST_TAG_IMAGE_TYPE_NONE) {
    const GstStructure *info_struct;

    info_struct = gst_sample_get_info (sample);
    if (info_struct && gst_structure_has_name (info_struct, "GstTagImageInfo")) {
      gst_structure_get (info_struct, "image-type", GST_TYPE_TAG_IMAGE_TYPE,
          &image_type, NULL);
    }
  }

  metadata_block_len = 32 + mime_type_len + gst_buffer_get_size (buffer);
  gst_byte_writer_init_with_size (&writer, metadata_block_len, TRUE);

  if (image_type == GST_TAG_IMAGE_TYPE_NONE
      && strcmp (tag, GST_TAG_PREVIEW_IMAGE) == 0) {
    gst_byte_writer_put_uint32_be_unchecked (&writer, 0x01);
  } else {
    /* Convert to ID3v2 APIC image type */
    if (image_type == GST_TAG_IMAGE_TYPE_NONE)
      image_type = GST_TAG_IMAGE_TYPE_UNDEFINED;
    else
      image_type = image_type + 2;
    gst_byte_writer_put_uint32_be_unchecked (&writer, image_type);
  }

  gst_byte_writer_put_uint32_be_unchecked (&writer, mime_type_len);
  gst_byte_writer_put_data_unchecked (&writer, (guint8 *) mime_type,
      mime_type_len);
  /* description length */
  gst_byte_writer_put_uint32_be_unchecked (&writer, 0);
  gst_byte_writer_put_uint32_be_unchecked (&writer, width);
  gst_byte_writer_put_uint32_be_unchecked (&writer, height);
  /* color depth */
  gst_byte_writer_put_uint32_be_unchecked (&writer, 0);
  /* for indexed formats the number of colors */
  gst_byte_writer_put_uint32_be_unchecked (&writer, 0);

  if (gst_buffer_map (buffer, &mapinfo, GST_MAP_READ)) {
    gst_byte_writer_put_uint32_be_unchecked (&writer, mapinfo.size);
    gst_byte_writer_put_data_unchecked (&writer, mapinfo.data, mapinfo.size);
    gst_buffer_unmap (buffer, &mapinfo);
  } else {
    GST_WARNING ("Failed to map vorbistag image buffer");
    gst_byte_writer_reset (&writer);
    return NULL;                /* List is always null up to here */
  }

  g_assert (gst_byte_writer_get_pos (&writer) == metadata_block_len);

  metadata_block = gst_byte_writer_reset_and_get_data (&writer);
  comment_data = g_base64_encode (metadata_block, metadata_block_len);
  g_free (metadata_block);
  data_result = g_strdup_printf ("METADATA_BLOCK_PICTURE=%s", comment_data);
  g_free (comment_data);

  l = g_list_append (l, data_result);

  return l;
}

/**
 * gst_tag_to_vorbis_comments:
 * @list: a #GstTagList
 * @tag: a GStreamer tag identifier, such as #GST_TAG_ARTIST
 *
 * Creates a new tag list that contains the information parsed out of a
 * vorbiscomment packet.
 *
 * Returns: (element-type utf8) (transfer full): A #GList of newly-allocated
 *     key=value strings. Free with g_list_foreach (list, (GFunc) g_free, NULL)
 *     plus g_list_free (list)
 */
GList *
gst_tag_to_vorbis_comments (const GstTagList * list, const gchar * tag)
{
  const gchar *vorbis_tag = NULL;
  GList *l = NULL;
  guint i;

  g_return_val_if_fail (list != NULL, NULL);
  g_return_val_if_fail (tag != NULL, NULL);

  /* Special case: cover art is split into two tags to store data and
   * MIME-type. Even if the tag list contains multiple entries, there is
   * no reasonable way to save more than one.
   * If both, preview image and image, are present we prefer the
   * image tag.
   */
  if ((strcmp (tag, GST_TAG_PREVIEW_IMAGE) == 0 &&
          gst_tag_list_get_tag_size (list, GST_TAG_IMAGE) == 0) ||
      strcmp (tag, GST_TAG_IMAGE) == 0) {
    return gst_tag_to_metadata_block_picture (tag,
        gst_tag_list_get_value_index (list, tag, 0));
  }

  if (strcmp (tag, GST_TAG_EXTENDED_COMMENT) != 0) {
    vorbis_tag = gst_tag_to_vorbis_tag (tag);
    if (!vorbis_tag)
      return NULL;
  }

  /* FIXME: for tags that can map to multiple vorbis comment keys, add all
   * of the possible keys */
  for (i = 0; i < gst_tag_list_get_tag_size (list, tag); i++) {
    GType tag_type = gst_tag_get_type (tag);
    gchar *result = NULL;

    switch (tag_type) {
      case G_TYPE_UINT:{
        guint u;

        if (!gst_tag_list_get_uint_index (list, tag, i, &u))
          g_return_val_if_reached (NULL);
        result = g_strdup_printf ("%s=%u", vorbis_tag, u);
        break;
      }
      case G_TYPE_STRING:{
        const gchar *str = NULL;

        if (!gst_tag_list_peek_string_index (list, tag, i, &str))
          g_return_val_if_reached (NULL);

        /* special case: GST_TAG_EXTENDED_COMMENT */
        if (vorbis_tag == NULL) {
          gchar *key = NULL, *val = NULL;

          if (gst_tag_parse_extended_comment (str, &key, NULL, &val, TRUE)) {
            result = g_strdup_printf ("%s=%s", key, val);
            g_free (key);
            g_free (val);
          } else {
            GST_WARNING ("Not a valid extended comment string: %s", str);
            continue;
          }
        } else {
          result = g_strdup_printf ("%s=%s", vorbis_tag, str);
        }
        break;
      }
      case G_TYPE_DOUBLE:{
        gdouble value;
        gchar buf[G_ASCII_DTOSTR_BUF_SIZE];

        if (!gst_tag_list_get_double_index (list, tag, i, &value))
          g_return_val_if_reached (NULL);
        g_ascii_formatd (buf, G_ASCII_DTOSTR_BUF_SIZE, "%f", value);
        result = g_strconcat (vorbis_tag, "=", buf, NULL);
        break;
      }
      default:{
        if (tag_type == GST_TYPE_DATE_TIME) {
          GstDateTime *datetime;

          if (gst_tag_list_get_date_time_index (list, tag, i, &datetime)) {
            gchar *string;

            /* vorbis suggests using ISO date formats:
             * http://wiki.xiph.org/VorbisComment#Date_and_time */
            string = gst_date_time_to_iso8601_string (datetime);
            result = g_strdup_printf ("%s=%s", vorbis_tag, string);
            g_free (string);

            gst_date_time_unref (datetime);
          }
        } else {
          GST_DEBUG ("Couldn't write tag %s", tag);
          continue;
        }
        break;
      }
    }
    l = g_list_prepend (l, result);
  }

  return g_list_reverse (l);
}

static void
write_one_tag (const GstTagList * list, const gchar * tag, gpointer user_data)
{
  MyForEach *data = (MyForEach *) user_data;
  GList *comments;
  GList *it;

  comments = gst_tag_to_vorbis_comments (list, tag);

  for (it = comments; it != NULL; it = it->next) {
    gchar *result = it->data;

    data->count++;
    data->data_count += strlen (result);
    data->entries = g_list_prepend (data->entries, result);
  }

  g_list_free (comments);
}

/**
 * gst_tag_list_to_vorbiscomment_buffer:
 * @list: tag list to convert
 * @id_data: identification data at start of stream
 * @id_data_length: length of identification data, may be 0 if @id_data is NULL
 * @vendor_string: string that describes the vendor string or NULL
 *
 * Creates a new vorbiscomment buffer from a tag list.
 *
 * Returns: A new #GstBuffer containing a vorbiscomment buffer with all tags
 *          that could be converted from the given tag list.
 */
GstBuffer *
gst_tag_list_to_vorbiscomment_buffer (const GstTagList * list,
    const guint8 * id_data, const guint id_data_length,
    const gchar * vendor_string)
{
  GstBuffer *buffer;
  GstMapInfo info;
  guint8 *data;
  guint i;
  GList *l;
  MyForEach my_data = { 0, 0, NULL };
  guint vendor_len;
  int required_size;

  g_return_val_if_fail (GST_IS_TAG_LIST (list), NULL);
  g_return_val_if_fail (id_data != NULL || id_data_length == 0, NULL);

  if (vendor_string == NULL)
    vendor_string = "GStreamer encoded vorbiscomment";
  vendor_len = strlen (vendor_string);
  required_size = id_data_length + 4 + vendor_len + 4 + 1;
  gst_tag_list_foreach ((GstTagList *) list, write_one_tag, &my_data);
  required_size += 4 * my_data.count + my_data.data_count;

  buffer = gst_buffer_new_and_alloc (required_size);
  gst_buffer_map (buffer, &info, GST_MAP_WRITE);
  data = info.data;
  if (id_data_length > 0) {
    memcpy (data, id_data, id_data_length);
    data += id_data_length;
  }
  GST_WRITE_UINT32_LE (data, vendor_len);
  data += 4;
  memcpy (data, vendor_string, vendor_len);
  data += vendor_len;
  l = my_data.entries = g_list_reverse (my_data.entries);
  GST_WRITE_UINT32_LE (data, my_data.count);
  data += 4;
  for (i = 0; i < my_data.count; i++) {
    guint size;
    gchar *cur;

    g_assert (l != NULL);
    cur = l->data;
    l = g_list_next (l);
    size = strlen (cur);
    GST_WRITE_UINT32_LE (data, size);
    data += 4;
    memcpy (data, cur, size);
    data += size;
  }
  g_list_foreach (my_data.entries, (GFunc) g_free, NULL);
  g_list_free (my_data.entries);
  *data = 1;
  gst_buffer_unmap (buffer, &info);

  return buffer;
}
