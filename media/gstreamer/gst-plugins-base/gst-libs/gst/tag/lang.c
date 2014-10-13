/* GStreamer language codes and names utility functions
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gsttaglanguagecodes
 * @short_description: mappings for ISO-639 language codes and names
 * @see_also: #GstTagList
 *
 * <refsect2>
 * <para>
 * Provides helper functions to convert between the various ISO-639 language
 * codes, and to map language codes to language names.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#undef GETTEXT_PACKAGE
#define GETTEXT_PACKAGE "iso_639"

#define ISO_639_XML_PATH ISO_CODES_PREFIX "/share/xml/iso-codes/iso_639.xml"
#define ISO_CODES_LOCALEDIR ISO_CODES_PREFIX "/share/locale"

#include <gst/gst-i18n-plugin.h>
#include <gst/gst.h>

#include <string.h>
#include <stdlib.h>

#include "tag.h"
#include "lang-tables.dat"

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT ensure_debug_category()

static GstDebugCategory *
ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat_done;

    cat_done = (gsize) _gst_debug_category_new ("tag-langcodes", 0,
        "GstTag language codes and names");

    g_once_init_leave (&cat_gonce, cat_done);
  }

  return (GstDebugCategory *) cat_gonce;
}

#else

#define ensure_debug_category() /* NOOP */

#endif /* GST_DISABLE_GST_DEBUG */

/* ------------------------------------------------------------------------- */

/* Loading and initing */

#if defined(HAVE_ISO_CODES)
static const gchar *
get_val (const gchar ** names, const gchar ** vals, const gchar * name)
{
  while (names != NULL && *names != NULL) {
    if (strcmp (*names, name) == 0)
      return *vals;
    ++names;
    ++vals;
  }
  return NULL;
}

static void
parse_start_element (GMarkupParseContext * ctx, const gchar * element_name,
    const gchar ** attr_names, const gchar ** attr_vals,
    gpointer user_data, GError ** error)
{
  GHashTable *ht = (GHashTable *) user_data;
  const gchar *c1, *c2t, *c2b, *name, *tname;

  if (strcmp (element_name, "iso_639_entry") != 0)
    return;

  c1 = get_val (attr_names, attr_vals, "iso_639_1_code");

  /* only interested in languages with an ISO 639-1 code for now */
  if (c1 == NULL)
    return;

  c2t = get_val (attr_names, attr_vals, "iso_639_2T_code");
  c2b = get_val (attr_names, attr_vals, "iso_639_2B_code");
  name = get_val (attr_names, attr_vals, "name");

  if (c2t == NULL || c2b == NULL || name == NULL) {
    GST_WARNING ("broken iso_639.xml entry: c2t=%p, c2b=%p, name=%p", c2t,
        c2b, name);
    return;
  }

  /* translate language name */
  tname = _(name);

  /* if no translation was found, it will return the input string, which we
   * we don't want to put into the hash table because it will be freed again */
  if (G_UNLIKELY (tname == name))
    tname = g_intern_string (name);

  /* now overwrite default/fallback mappings with names in locale language */
  g_hash_table_replace (ht, (gpointer) g_intern_string (c1), (gpointer) tname);
  g_hash_table_replace (ht, (gpointer) g_intern_string (c2b), (gpointer) tname);
  if (strcmp (c2t, c2b) != 0) {
    g_hash_table_replace (ht, (gpointer) g_intern_string (c2t),
        (gpointer) tname);
  }

  GST_LOG ("%s %s %s : %s - %s", c1, c2t, c2b, name, tname);
}

static void
gst_tag_load_iso_639_xml (GHashTable * ht)
{
  GMappedFile *f;
  GError *err = NULL;
  gchar *xml_data;
  gsize xml_len;

#ifdef ENABLE_NLS
  GST_DEBUG ("binding text domain %s to locale dir %s", GETTEXT_PACKAGE,
      ISO_CODES_LOCALEDIR);
  bindtextdomain (GETTEXT_PACKAGE, ISO_CODES_LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif

  f = g_mapped_file_new (ISO_639_XML_PATH, FALSE, NULL);
  if (f != NULL) {
    xml_data = (gchar *) g_mapped_file_get_contents (f);
    xml_len = g_mapped_file_get_length (f);
  } else {
    if (!g_file_get_contents (ISO_639_XML_PATH, &xml_data, &xml_len, &err)) {
      GST_WARNING ("Could not read %s: %s", ISO_639_XML_PATH, err->message);
      g_error_free (err);
      return;
    }
  }

  if (g_utf8_validate (xml_data, xml_len, NULL)) {
    GMarkupParser xml_parser = { parse_start_element, NULL, NULL, NULL, NULL };
    GMarkupParseContext *ctx;

    ctx = g_markup_parse_context_new (&xml_parser, 0, ht, NULL);
    if (!g_markup_parse_context_parse (ctx, xml_data, xml_len, &err)) {
      GST_WARNING ("Parsing iso_639.xml failed: %s", err->message);
      g_error_free (err);
    }
    g_markup_parse_context_free (ctx);
  } else {
    GST_WARNING ("iso_639.xml file is not valid UTF-8");
    GST_MEMDUMP ("iso_639.xml file", (guint8 *) xml_data, xml_len);
  }

  /* ... and clean up */
  if (f != NULL)
    g_mapped_file_unref (f);
  else
    g_free (xml_data);
}
#endif /* HAVE_ISO_CODES */

static GHashTable *
gst_tag_get_iso_639_ht (void)
{
  static gsize once_val = 0;
  int i;

  if (g_once_init_enter (&once_val)) {
    GHashTable *ht;
    gsize done_val;

    GST_MEMDUMP ("iso 639 language names (internal default/fallback)",
        (guint8 *) iso_639_names, sizeof (iso_639_names));

    /* maps code -> language name; all strings are either interned strings
     * or const static strings from lang-table.c */
    ht = g_hash_table_new (g_str_hash, g_str_equal);

    /* set up default/fallback mappings */
    for (i = 0; i < G_N_ELEMENTS (iso_639_codes); ++i) {
      GST_LOG ("%3d %s %s %c%c 0x%04x  %s", i, iso_639_codes[i].iso_639_1,
          iso_639_codes[i].iso_639_2,
          ((iso_639_codes[i].flags & ISO_639_FLAG_2B)) ? 'B' : '.',
          ((iso_639_codes[i].flags & ISO_639_FLAG_2T)) ? 'T' : '.',
          iso_639_codes[i].name_offset,
          iso_639_names + iso_639_codes[i].name_offset);

#ifdef HAVE_ISO_CODES
      /* intern these in order to minimise allocations when interning strings
       * read from the xml file later */
      g_intern_static_string (iso_639_codes[i].iso_639_1);
      g_intern_static_string (iso_639_codes[i].iso_639_2);
      g_intern_static_string (iso_639_names + iso_639_codes[i].name_offset);
#endif

      /* and add default mapping (these strings are always valid) */
      g_hash_table_insert (ht, (gpointer) iso_639_codes[i].iso_639_1,
          (gpointer) (iso_639_names + iso_639_codes[i].name_offset));
      g_hash_table_insert (ht, (gpointer) iso_639_codes[i].iso_639_2,
          (gpointer) (iso_639_names + iso_639_codes[i].name_offset));
    }

#ifdef HAVE_ISO_CODES
    {
      GstClockTime ts = gst_util_get_timestamp ();

      gst_tag_load_iso_639_xml (ht);

      ts = gst_util_get_timestamp () - ts;
      GST_INFO ("iso_639.xml loading took %.2gms", (double) ts / GST_MSECOND);
    }
#else
    GST_INFO ("iso-codes disabled or not available");
#endif

    done_val = (gsize) ht;
    g_once_init_leave (&once_val, done_val);
  }

  return (GHashTable *) once_val;
}

/* ------------------------------------------------------------------------- */

static int
qsort_strcmp_func (const void *p1, const void *p2)
{
  return strcmp (*(char *const *) p1, *(char *const *) p2);
}

/**
 * gst_tag_get_language_codes:
 *
 * Returns a list of known language codes (in form of two-letter ISO-639-1
 * codes). This is useful for UIs to build a list of available languages for
 * tagging purposes (e.g. to tag an audio track appropriately in a video or
 * audio editor).
 *
 * Returns: (transfer full): NULL-terminated string array with two-letter
 *     language codes. Free with g_strfreev() when no longer needed.
 */
gchar **
gst_tag_get_language_codes (void)
{
  GHashTableIter iter;
  GHashTable *ht;
  gpointer key;
  gchar **codes;
  int i;

  ensure_debug_category ();

  ht = gst_tag_get_iso_639_ht ();

  /* we have at least two keys for each language (-1 code and -2 code) */
  codes = g_new (gchar *, (g_hash_table_size (ht) / 2) + 1);

  i = 0;
  g_hash_table_iter_init (&iter, ht);
  while (g_hash_table_iter_next (&iter, &key, NULL)) {
    const gchar *lang_code = key;

    if (strlen (lang_code) == 2) {
      codes[i] = g_strdup (lang_code);
      ++i;
    }
  }
  codes[i] = NULL;

  /* be nice and sort the list */
  qsort (&codes[0], i, sizeof (gchar *), qsort_strcmp_func);

  return codes;
}

/**
 * gst_tag_get_language_name:
 * @language_code: two or three-letter ISO-639 language code
 *
 * Returns the name of the language given an ISO-639 language code as
 * found in a GST_TAG_LANGUAGE_CODE tag. The name will be translated
 * according to the current locale (if the library was built against the
 * iso-codes package, otherwise the English name will be returned).
 *
 * Language codes are case-sensitive and expected to be lower case.
 *
 * Returns: language name in UTF-8 format, or NULL if @language_code could
 *     not be mapped to a language name. The returned string must not be
 *     modified and does not need to freed; it will stay valid until the
 *     application is terminated.
 */
const gchar *
gst_tag_get_language_name (const gchar * language_code)
{
  const gchar *lang_name;
  GHashTable *ht;

  g_return_val_if_fail (language_code != NULL, NULL);

  ensure_debug_category ();

  ht = gst_tag_get_iso_639_ht ();

  lang_name = g_hash_table_lookup (ht, (gpointer) language_code);
  GST_LOG ("%s -> %s", language_code, GST_STR_NULL (lang_name));

  return lang_name;
}

/**
 * gst_tag_get_language_code_iso_639_1:
 * @lang_code: ISO-639 language code (e.g. "deu" or "ger" or "de")
 *
 * Returns two-letter ISO-639-1 language code given a three-letter ISO-639-2
 * language code or two-letter ISO-639-1 language code (both are accepted for
 * convenience).
 *
 * Language codes are case-sensitive and expected to be lower case.
 *
 * Returns: two-letter ISO-639-1 language code string that maps to @lang_code,
 *     or NULL if no mapping is known. The returned string must not be
 *     modified or freed.
 */
const gchar *
gst_tag_get_language_code_iso_639_1 (const gchar * lang_code)
{
  const gchar *c = NULL;
  int i;

  g_return_val_if_fail (lang_code != NULL, NULL);

  ensure_debug_category ();

  /* FIXME: we are being a bit inconsistent here in the sense that will only
   * map the language codes from our static table. Theoretically the iso-codes
   * XML file might have had additional codes that are now in the hash table.
   * We keep it simple for now and don't waste memory on additional tables. */
  for (i = 0; i < G_N_ELEMENTS (iso_639_codes); ++i) {
    /* we check both codes here, so function can be used in a more versatile
     * way, to convert a language tag to a two-letter language code and/or
     * verify an existing code */
    if (strcmp (lang_code, iso_639_codes[i].iso_639_1) == 0 ||
        strcmp (lang_code, iso_639_codes[i].iso_639_2) == 0) {
      c = iso_639_codes[i].iso_639_1;
      break;
    }
  }

  GST_LOG ("%s -> %s", lang_code, GST_STR_NULL (c));

  return c;
}

static const gchar *
gst_tag_get_language_code_iso_639_2X (const gchar * lang_code, guint8 flags)
{
  int i;

  /* FIXME: we are being a bit inconsistent here in the sense that we will only
   * map the language codes from our static table. Theoretically the iso-codes
   * XML file might have had additional codes that are now in the hash table.
   * We keep it simple for now and don't waste memory on additional tables.
   * Also, we currently only parse the iso_639.xml file if language names or
   * a list of all codes is requested, and it'd be nice to keep it like that. */
  for (i = 0; i < G_N_ELEMENTS (iso_639_codes); ++i) {
    /* we check both codes here, so function can be used in a more versatile
     * way, to convert a language tag to a three-letter language code and/or
     * verify an existing code */
    if (strcmp (lang_code, iso_639_codes[i].iso_639_1) == 0 ||
        strcmp (lang_code, iso_639_codes[i].iso_639_2) == 0) {
      if ((iso_639_codes[i].flags & flags) == flags) {
        return iso_639_codes[i].iso_639_2;
      } else if (i > 0 && (iso_639_codes[i - 1].flags & flags) == flags &&
          iso_639_codes[i].name_offset == iso_639_codes[i - 1].name_offset) {
        return iso_639_codes[i - 1].iso_639_2;
      } else if ((i + 1) < G_N_ELEMENTS (iso_639_codes) &&
          (iso_639_codes[i + 1].flags & flags) == flags &&
          iso_639_codes[i].name_offset == iso_639_codes[i + 1].name_offset) {
        return iso_639_codes[i + 1].iso_639_2;
      }
    }
  }
  return NULL;
}

/**
 * gst_tag_get_language_code_iso_639_2T:
 * @lang_code: ISO-639 language code (e.g. "deu" or "ger" or "de")
 *
 * Returns three-letter ISO-639-2 "terminological" language code given a
 * two-letter ISO-639-1 language code or a three-letter ISO-639-2 language
 * code (both are accepted for convenience).
 *
 * The "terminological" code is derived from the local name of the language
 * (e.g. "deu" for German instead of "ger"). In most scenarios, the
 * "terminological" codes are prefered over the "bibliographic" ones.
 *
 * Language codes are case-sensitive and expected to be lower case.
 *
 * Returns: three-letter ISO-639-2 language code string that maps to @lang_code,
 *     or NULL if no mapping is known. The returned string must not be
 *     modified or freed.
 */
const gchar *
gst_tag_get_language_code_iso_639_2T (const gchar * lang_code)
{
  const gchar *c;

  g_return_val_if_fail (lang_code != NULL, NULL);

  ensure_debug_category ();

  c = gst_tag_get_language_code_iso_639_2X (lang_code, ISO_639_FLAG_2T);

  GST_LOG ("%s -> %s", lang_code, GST_STR_NULL (c));

  return c;
}

/**
 * gst_tag_get_language_code_iso_639_2B:
 * @lang_code: ISO-639 language code (e.g. "deu" or "ger" or "de")
 *
 * Returns three-letter ISO-639-2 "bibliographic" language code given a
 * two-letter ISO-639-1 language code or a three-letter ISO-639-2 language
 * code (both are accepted for convenience).
 *
 * The "bibliographic" code is derived from the English name of the language
 * (e.g. "ger" for German instead of "de" or "deu"). In most scenarios, the
 * "terminological" codes are prefered.
 *
 * Language codes are case-sensitive and expected to be lower case.
 *
 * Returns: three-letter ISO-639-2 language code string that maps to @lang_code,
 *     or NULL if no mapping is known. The returned string must not be
 *     modified or freed.
 */
const gchar *
gst_tag_get_language_code_iso_639_2B (const gchar * lang_code)
{
  const gchar *c;

  g_return_val_if_fail (lang_code != NULL, NULL);

  ensure_debug_category ();

  c = gst_tag_get_language_code_iso_639_2X (lang_code, ISO_639_FLAG_2B);

  GST_LOG ("%s -> %s", lang_code, GST_STR_NULL (c));

  return c;
}

/**
 * gst_tag_check_language_code:
 * @lang_code: ISO-639 language code (e.g. "deu" or "ger" or "de")
 *
 * Check if a given string contains a known ISO 639 language code.
 *
 * This is useful in situations where it's not clear whether a given
 * string is a language code (which should be put into a #GST_TAG_LANGUAGE_CODE
 * tag) or a free-form language name descriptor (which should be put into a
 * #GST_TAG_LANGUAGE_NAME tag instead).
 *
 * Returns: TRUE if the two- or three-letter language code in @lang_code
 *     is a valid ISO-639 language code.
 */
gboolean
gst_tag_check_language_code (const gchar * lang_code)
{
  return (gst_tag_get_language_code_iso_639_1 (lang_code) != NULL);
}
