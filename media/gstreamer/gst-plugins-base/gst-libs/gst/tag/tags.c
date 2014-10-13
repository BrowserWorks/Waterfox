/* GStreamer non-core tag registration and tag utility functions
 * Copyright (C) 2005 Ross Burton <ross@burtonini.com>
 * Copyright (C) 2006-2008 Tim-Philipp Müller <tim centricular net>
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>
#include <gst/base/gsttypefindhelper.h>
#include <gst/gst.h>
#include "tag.h"
#include "id3v2.h"

#include <string.h>

/**
 * SECTION:gsttag
 * @short_description: additional tag definitions for plugins and applications
 * @see_also: #GstTagList
 * 
 * <refsect2>
 * <para>
 * Contains additional standardized GStreamer tag definitions for plugins
 * and applications, and functions to register them with the GStreamer
 * tag system.
 * </para>
 * </refsect2>
 */

#ifndef GST_DISABLE_GST_DEBUG
#define GST_CAT_DEFAULT gst_tag_ensure_debug_category()

static GstDebugCategory *
gst_tag_ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    GstDebugCategory *cat = NULL;

    GST_DEBUG_CATEGORY_INIT (cat, "tag-tags", 0, "GstTag helper functions");

    g_once_init_leave (&cat_gonce, (gsize) cat);
  }

  return (GstDebugCategory *) cat_gonce;
}
#endif /* GST_DISABLE_GST_DEBUG */

static gpointer
gst_tag_register_tags_internal (gpointer unused)
{
#ifdef ENABLE_NLS
  GST_DEBUG ("binding text domain %s to locale dir %s", GETTEXT_PACKAGE,
      LOCALEDIR);
  bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif

  /* musicbrainz tags */
  gst_tag_register_static (GST_TAG_MUSICBRAINZ_TRACKID, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("track ID"), _("MusicBrainz track ID"), NULL);
  gst_tag_register_static (GST_TAG_MUSICBRAINZ_ARTISTID, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("artist ID"), _("MusicBrainz artist ID"), NULL);
  gst_tag_register_static (GST_TAG_MUSICBRAINZ_ALBUMID, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("album ID"), _("MusicBrainz album ID"), NULL);
  gst_tag_register_static (GST_TAG_MUSICBRAINZ_ALBUMARTISTID, GST_TAG_FLAG_META,
      G_TYPE_STRING,
      _("album artist ID"), _("MusicBrainz album artist ID"), NULL);
  gst_tag_register_static (GST_TAG_MUSICBRAINZ_TRMID, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("track TRM ID"), _("MusicBrainz TRM ID"), NULL);

  /* CDDA tags */
  gst_tag_register_static (GST_TAG_CDDA_CDDB_DISCID, GST_TAG_FLAG_META,
      G_TYPE_STRING, "discid", "CDDB discid for metadata retrieval",
      gst_tag_merge_use_first);

  gst_tag_register_static (GST_TAG_CDDA_CDDB_DISCID_FULL, GST_TAG_FLAG_META,
      G_TYPE_STRING, "discid full",
      "CDDB discid for metadata retrieval (full)", gst_tag_merge_use_first);

  gst_tag_register_static (GST_TAG_CDDA_MUSICBRAINZ_DISCID, GST_TAG_FLAG_META,
      G_TYPE_STRING, "musicbrainz-discid",
      "Musicbrainz discid for metadata retrieval", gst_tag_merge_use_first);

  gst_tag_register_static (GST_TAG_CDDA_MUSICBRAINZ_DISCID_FULL,
      GST_TAG_FLAG_META, G_TYPE_STRING, "musicbrainz-discid-full",
      "Musicbrainz discid for metadata retrieval (full)",
      gst_tag_merge_use_first);

  /* photography tags */
  gst_tag_register_static (GST_TAG_CAPTURING_SHUTTER_SPEED, GST_TAG_FLAG_META,
      GST_TYPE_FRACTION, _("capturing shutter speed"),
      _("Shutter speed used when capturing an image, in seconds"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_FOCAL_RATIO, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("capturing focal ratio"),
      _("Focal ratio (f-number) used when capturing the image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_FOCAL_LENGTH, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("capturing focal length"),
      _("Focal length of the lens used capturing the image, in mm"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_DIGITAL_ZOOM_RATIO,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("capturing digital zoom ratio"),
      _("Digital zoom ratio used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_ISO_SPEED, GST_TAG_FLAG_META,
      G_TYPE_INT, _("capturing iso speed"),
      _("The ISO speed used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_EXPOSURE_PROGRAM,
      GST_TAG_FLAG_META, G_TYPE_STRING, _("capturing exposure program"),
      _("The exposure program used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_EXPOSURE_MODE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing exposure mode"),
      _("The exposure mode used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_EXPOSURE_COMPENSATION,
      GST_TAG_FLAG_META, G_TYPE_DOUBLE, _("capturing exposure compensation"),
      _("The exposure compensation used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_SCENE_CAPTURE_TYPE,
      GST_TAG_FLAG_META, G_TYPE_STRING, _("capturing scene capture type"),
      _("The scene capture mode used when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_GAIN_ADJUSTMENT, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing gain adjustment"),
      _("The overall gain adjustment applied on an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_WHITE_BALANCE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing white balance"),
      _("The white balance mode set when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_CONTRAST, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing contrast"),
      _("The direction of contrast processing applied "
          "when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_SATURATION, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing saturation"),
      _("The direction of saturation processing applied when "
          "capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_SHARPNESS, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing sharpness"),
      _("The direction of sharpness processing applied "
          "when capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_FLASH_FIRED, GST_TAG_FLAG_META,
      G_TYPE_BOOLEAN, _("capturing flash fired"),
      _("If the flash fired while capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_FLASH_MODE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing flash mode"),
      _("The selected flash mode while capturing an image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_METERING_MODE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing metering mode"),
      _("The metering mode used while determining exposure for capturing an"
          " image"), NULL);

  gst_tag_register_static (GST_TAG_CAPTURING_SOURCE, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("capturing source"),
      _("The source or type of device used for the capture"), NULL);

  gst_tag_register_static (GST_TAG_IMAGE_HORIZONTAL_PPI, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("image horizontal ppi"),
      _("Media (image/video) intended horizontal pixel density in ppi"), NULL);

  gst_tag_register_static (GST_TAG_IMAGE_VERTICAL_PPI, GST_TAG_FLAG_META,
      G_TYPE_DOUBLE, _("image vertical ppi"),
      _("Media (image/video) intended vertical pixel density in ppi"), NULL);

  gst_tag_register_static (GST_TAG_ID3V2_FRAME, GST_TAG_FLAG_META,
      GST_TYPE_SAMPLE, _("ID3v2 frame"), _("unparsed id3v2 tag frame"),
      gst_tag_merge_use_first);

  gst_tag_register_static (GST_TAG_MUSICAL_KEY, GST_TAG_FLAG_META,
      G_TYPE_STRING, _("musical-key"), _("Initial key in which the "
          "sound starts"), gst_tag_merge_use_first);

  return NULL;
}

/* FIXME 0.11: rename this to gst_tag_init() or gst_tag_register_tags() or
 * even better: make tags auto-register themselves, either by defining them
 * to a wrapper func that does the initing, or by adding tag factories so
 * that the core can load+register tags automatically when needed. */

/**
 * gst_tag_register_musicbrainz_tags:
 *
 * Registers additional musicbrainz-specific tags with the GStreamer tag
 * system. Plugins and applications that use these tags should call this
 * function before using them. Can be called multiple times.
 */
void
gst_tag_register_musicbrainz_tags (void)
{
  static GOnce mb_once = G_ONCE_INIT;

  g_once (&mb_once, gst_tag_register_tags_internal, NULL);
}

static void
register_tag_image_type_enum (GType * id)
{
  static const GEnumValue image_types[] = {
    {GST_TAG_IMAGE_TYPE_NONE, "GST_TAG_IMAGE_TYPE_NONE", "none"},
    {GST_TAG_IMAGE_TYPE_UNDEFINED, "GST_TAG_IMAGE_TYPE_UNDEFINED", "undefined"},
    {GST_TAG_IMAGE_TYPE_FRONT_COVER, "GST_TAG_IMAGE_TYPE_FRONT_COVER",
        "front-cover"},
    {GST_TAG_IMAGE_TYPE_BACK_COVER, "GST_TAG_IMAGE_TYPE_BACK_COVER",
        "back-cover"},
    {GST_TAG_IMAGE_TYPE_LEAFLET_PAGE, "GST_TAG_IMAGE_TYPE_LEAFLET_PAGE",
        "leaflet-page"},
    {GST_TAG_IMAGE_TYPE_MEDIUM, "GST_TAG_IMAGE_TYPE_MEDIUM", "medium"},
    {GST_TAG_IMAGE_TYPE_LEAD_ARTIST, "GST_TAG_IMAGE_TYPE_LEAD_ARTIST",
        "lead-artist"},
    {GST_TAG_IMAGE_TYPE_ARTIST, "GST_TAG_IMAGE_TYPE_ARTIST", "artist"},
    {GST_TAG_IMAGE_TYPE_CONDUCTOR, "GST_TAG_IMAGE_TYPE_CONDUCTOR", "conductor"},
    {GST_TAG_IMAGE_TYPE_BAND_ORCHESTRA, "GST_TAG_IMAGE_TYPE_BAND_ORCHESTRA",
        "band-orchestra"},
    {GST_TAG_IMAGE_TYPE_COMPOSER, "GST_TAG_IMAGE_TYPE_COMPOSER", "composer"},
    {GST_TAG_IMAGE_TYPE_LYRICIST, "GST_TAG_IMAGE_TYPE_LYRICIST", "lyricist"},
    {GST_TAG_IMAGE_TYPE_RECORDING_LOCATION,
          "GST_TAG_IMAGE_TYPE_RECORDING_LOCATION",
        "recording-location"},
    {GST_TAG_IMAGE_TYPE_DURING_RECORDING, "GST_TAG_IMAGE_TYPE_DURING_RECORDING",
        "during-recording"},
    {GST_TAG_IMAGE_TYPE_DURING_PERFORMANCE,
          "GST_TAG_IMAGE_TYPE_DURING_PERFORMANCE",
        "during-performance"},
    {GST_TAG_IMAGE_TYPE_VIDEO_CAPTURE, "GST_TAG_IMAGE_TYPE_VIDEO_CAPTURE",
        "video-capture"},
    {GST_TAG_IMAGE_TYPE_FISH, "GST_TAG_IMAGE_TYPE_FISH", "fish"},
    {GST_TAG_IMAGE_TYPE_ILLUSTRATION, "GST_TAG_IMAGE_TYPE_ILLUSTRATION",
        "illustration"},
    {GST_TAG_IMAGE_TYPE_BAND_ARTIST_LOGO, "GST_TAG_IMAGE_TYPE_BAND_ARTIST_LOGO",
        "artist-logo"},
    {GST_TAG_IMAGE_TYPE_PUBLISHER_STUDIO_LOGO,
          "GST_TAG_IMAGE_TYPE_PUBLISHER_STUDIO_LOGO",
        "publisher-studio-logo"},
    {0, NULL, NULL}
  };

  *id = g_enum_register_static ("GstTagImageType", image_types);

  /* work around thread-safety issue with class creation in GLib */
  g_type_class_ref (*id);
}

GType
gst_tag_image_type_get_type (void)
{
  static GType id;

  static GOnce once = G_ONCE_INIT;

  g_once (&once, (GThreadFunc) register_tag_image_type_enum, &id);
  return id;
}

static inline gboolean
gst_tag_image_type_is_valid (GstTagImageType type)
{
  GEnumClass *klass;

  gboolean res;

  klass = g_type_class_ref (gst_tag_image_type_get_type ());
  res = (g_enum_get_value (klass, type) != NULL);
  g_type_class_unref (klass);

  return res;
}

/**
 * gst_tag_parse_extended_comment:
 * @ext_comment: an extended comment string, see #GST_TAG_EXTENDED_COMMENT
 * @key: return location for the comment description key, or NULL
 * @lang: return location for the comment ISO-639 language code, or NULL
 * @value: return location for the actual comment string, or NULL
 * @fail_if_no_key: whether to fail if strings are not in key=value form
 *
 * Convenience function to parse a GST_TAG_EXTENDED_COMMENT string and
 * separate it into its components.
 *
 * If successful, @key, @lang and/or @value will be set to newly allocated
 * strings that you need to free with g_free() when done. @key and @lang
 * may also be set to NULL by this function if there is no key or no language
 * code in the extended comment string.
 *
 * Returns: TRUE if the string could be parsed, otherwise FALSE
 */
gboolean
gst_tag_parse_extended_comment (const gchar * ext_comment, gchar ** key,
    gchar ** lang, gchar ** value, gboolean fail_if_no_key)
{
  const gchar *div, *bop, *bcl;

  g_return_val_if_fail (ext_comment != NULL, FALSE);
  g_return_val_if_fail (g_utf8_validate (ext_comment, -1, NULL), FALSE);

  if (key)
    *key = NULL;
  if (lang)
    *lang = NULL;

  div = strchr (ext_comment, '=');
  bop = strchr (ext_comment, '[');
  bcl = strchr (ext_comment, ']');

  if (div == NULL) {
    if (fail_if_no_key)
      return FALSE;
    if (value)
      *value = g_strdup (ext_comment);
    return TRUE;
  }

  if (bop != NULL && bop < div) {
    if (bcl < bop || bcl > div)
      return FALSE;
    if (key)
      *key = g_strndup (ext_comment, bop - ext_comment);
    if (lang)
      *lang = g_strndup (bop + 1, bcl - bop - 1);
  } else {
    if (key)
      *key = g_strndup (ext_comment, div - ext_comment);
  }

  if (value)
    *value = g_strdup (div + 1);

  return TRUE;
}

/**
 * gst_tag_freeform_string_to_utf8:
 * @data: string data
 * @size: length of string data, or -1 if the string is NUL-terminated
 * @env_vars: a NULL-terminated string array of environment variable names,
 *            or NULL
 *
 * Convenience function to read a string with unknown character encoding. If
 * the string is already in UTF-8 encoding, it will be returned right away.
 * If not it tries to detect byte-order-mark for UTF-16/32 cases and use that.
 * Otherwise, the environment will be searched for a number of environment
 * variables (whose names are specified in the NULL-terminated string array
 * @env_vars) containing a list of character encodings to try/use. If none
 * are specified, the current locale will be tried. If that also doesn't work,
 * WINDOWS-1252/ISO-8859-1 is assumed (which will almost always succeed).
 *
 * Returns: a newly-allocated string in UTF-8 encoding, or NULL
 */
gchar *
gst_tag_freeform_string_to_utf8 (const gchar * data, gint size,
    const gchar ** env_vars)
{
  const gchar *cur_loc = NULL;

  gsize bytes_read;

  gchar *utf8 = NULL;

  g_return_val_if_fail (data != NULL, NULL);

  if (size < 0)
    size = strlen (data);

  /* chop off trailing string terminators to make sure utf8_validate doesn't
   * get to see them (since that would make the utf8 check fail) */
  while (size > 0 && data[size - 1] == '\0')
    --size;

  /* Should we try the charsets specified
   * via environment variables FIRST ? */
  if (g_utf8_validate (data, size, NULL)) {
    utf8 = g_strndup (data, size);
    GST_LOG ("String '%s' is valid UTF-8 already", utf8);
    goto beach;
  }

  /* check for and use byte-order-mark for UTF-16/32 cases */
  if (size >= 2) {
    const gchar *c = NULL;
    gint prefix, ssize;

    if (size >= 4) {
      prefix = 4;
      ssize = GST_ROUND_DOWN_4 (size - 4);
      switch (GST_READ_UINT32_BE (data)) {
        case 0x0000FEFF:
          c = "UTF-32BE";
          break;
        case 0xFFFE0000:
          c = "UTF-32LE";
          break;
        default:
          break;
      }
    }
    if (!c) {
      prefix = 2;
      ssize = GST_ROUND_DOWN_2 (size - 2);
      switch (GST_READ_UINT16_BE (data)) {
        case 0xFEFF:
          c = "UTF-16BE";
          break;
        case 0xFFFE:
          c = "UTF-16LE";
          break;
        default:
          break;
      }
    }
    if (c) {
      GST_LOG ("Trying to convert freeform string to UTF-8 from '%s'", c);
      if ((utf8 =
              g_convert (data + prefix, ssize, "UTF-8", c, &bytes_read, NULL,
                  NULL))) {
        if (bytes_read == ssize)
          goto beach;
        g_free (utf8);
        utf8 = NULL;
      }
    }
  }

  while (env_vars && *env_vars != NULL) {
    const gchar *env = NULL;

    /* Try charsets specified via the environment */
    env = g_getenv (*env_vars);
    if (env != NULL && *env != '\0') {
      gchar **c, **csets;

      csets = g_strsplit (env, G_SEARCHPATH_SEPARATOR_S, -1);

      for (c = csets; c && *c; ++c) {
        GST_LOG ("Trying to convert freeform string to UTF-8 from '%s'", *c);
        if ((utf8 =
                g_convert (data, size, "UTF-8", *c, &bytes_read, NULL, NULL))) {
          if (bytes_read == size) {
            g_strfreev (csets);
            goto beach;
          }
          g_free (utf8);
          utf8 = NULL;
        }
      }

      g_strfreev (csets);
    }
    ++env_vars;
  }

  /* Try current locale (if not UTF-8) */
  if (!g_get_charset (&cur_loc)) {
    GST_LOG ("Trying to convert freeform string using locale ('%s')", cur_loc);
    if ((utf8 = g_locale_to_utf8 (data, size, &bytes_read, NULL, NULL))) {
      if (bytes_read == size) {
        goto beach;
      }
      g_free (utf8);
      utf8 = NULL;
    }
  }

  /* Try Windows-1252 (which is a superset of ISO 8859-1 that uses a control
   * character range in ISO 8859-1 for more printable characters) */
  {
    GError *err = NULL;

    GST_LOG ("Trying to convert freeform string using Windows-1252/ISO-8859-1 "
        "fallback");
    utf8 = g_convert (data, size, "UTF-8", "WINDOWS-1252", &bytes_read, NULL,
        &err);
    if (err != NULL) {
      /* fallback in case iconv implementation doesn't support windows-1252
       * for some reason */
      if (err->code == G_CONVERT_ERROR_NO_CONVERSION) {
        g_free (utf8);
        utf8 = g_convert (data, size, "UTF-8", "ISO-8859-1", &bytes_read,
            NULL, NULL);
      }
      g_error_free (err);
    }

    if (utf8 != NULL && bytes_read == size)
      goto beach;
  }

  g_free (utf8);
  return NULL;

beach:

  g_strchomp (utf8);
  if (utf8 && utf8[0] != '\0') {
    GST_LOG ("Returning '%s'", utf8);
    return utf8;
  }

  g_free (utf8);
  return NULL;
}

/**
 * gst_tag_image_data_to_image_sample:
 * @image_data: the (encoded) image
 * @image_data_len: the length of the encoded image data at @image_data
 * @image_type: type of the image, or #GST_TAG_IMAGE_TYPE_UNDEFINED. Pass
 *     #GST_TAG_IMAGE_TYPE_NONE if no image type should be set at all (e.g.
 *     for preview images)
 *
 * Helper function for tag-reading plugins to create a #GstSample suitable to
 * add to a #GstTagList as an image tag (such as #GST_TAG_IMAGE or
 * #GST_TAG_PREVIEW_IMAGE) from the encoded image data and an (optional) image
 * type.
 *
 * Background: cover art and other images in tags are usually stored as a
 * blob of binary image data, often accompanied by a MIME type or some other
 * content type string (e.g. 'png', 'jpeg', 'jpg'). Sometimes there is also an
 * 'image type' to indicate what kind of image this is (e.g. front cover,
 * back cover, artist, etc.). The image data may also be an URI to the image
 * rather than the image itself.
 *
 * In GStreamer, image tags are #GstSample<!-- -->s containing the raw image
 * data, with the sample caps describing the content type of the image
 * (e.g. image/jpeg, image/png, text/uri-list). The sample info may contain
 * an additional 'image-type' field of #GST_TYPE_TAG_IMAGE_TYPE to describe
 * the type of image (front cover, back cover etc.). #GST_TAG_PREVIEW_IMAGE
 * tags should not carry an image type, their type is already indicated via
 * the special tag name.
 *
 * This function will do various checks and typefind the encoded image
 * data (we can't trust the declared mime type).
 *
 * Returns: a newly-allocated image sample for use in tag lists, or NULL
 */
GstSample *
gst_tag_image_data_to_image_sample (const guint8 * image_data,
    guint image_data_len, GstTagImageType image_type)
{
  const gchar *name;
  GstBuffer *image;
  GstSample *sample;
  GstCaps *caps;
  GstMapInfo info;
  GstStructure *image_info = NULL;

  g_return_val_if_fail (image_data != NULL, NULL);
  g_return_val_if_fail (image_data_len > 0, NULL);
  g_return_val_if_fail (gst_tag_image_type_is_valid (image_type), NULL);

  GST_DEBUG ("image data len: %u bytes", image_data_len);

  /* allocate space for a NUL terminator for an uri too */
  image = gst_buffer_new_and_alloc (image_data_len + 1);
  if (image == NULL)
    goto alloc_failed;

  gst_buffer_map (image, &info, GST_MAP_WRITE);
  memcpy (info.data, image_data, image_data_len);
  info.data[image_data_len] = '\0';
  gst_buffer_unmap (image, &info);

  /* Find GStreamer media type, can't trust declared type */
  caps = gst_type_find_helper_for_buffer (NULL, image, NULL);

  if (caps == NULL)
    goto no_type;

  GST_DEBUG ("Found GStreamer media type: %" GST_PTR_FORMAT, caps);

  /* sanity check: make sure typefound/declared caps are either URI or image */
  name = gst_structure_get_name (gst_caps_get_structure (caps, 0));

  if (!g_str_has_prefix (name, "image/") &&
      !g_str_has_prefix (name, "video/") &&
      !g_str_equal (name, "text/uri-list")) {
    GST_DEBUG ("Unexpected image type '%s', ignoring image frame", name);
    goto error;
  }

  /* Decrease size by 1 if we don't have an URI list
   * to keep the original size of the image
   */
  if (!g_str_equal (name, "text/uri-list"))
    gst_buffer_set_size (image, image_data_len);

  if (image_type != GST_TAG_IMAGE_TYPE_NONE) {
    GST_LOG ("Setting image type: %d", image_type);
    image_info = gst_structure_new ("GstTagImageInfo",
        "image-type", GST_TYPE_TAG_IMAGE_TYPE, image_type, NULL);
  }
  sample = gst_sample_new (image, caps, NULL, image_info);
  gst_buffer_unref (image);
  gst_caps_unref (caps);

  return sample;

/* ERRORS */
no_type:
  {
    GST_DEBUG ("Could not determine GStreamer media type, ignoring image");
    /* fall through */
  }
error:
  {
    if (image)
      gst_buffer_unref (image);
    if (caps)
      gst_caps_unref (caps);
    return NULL;
  }
alloc_failed:
  {
    GST_WARNING ("failed to allocate buffer of %d for image", image_data_len);
    gst_buffer_unref (image);
    return NULL;
  }

}
