/* GStreamer media licenses utility functions
 * Copyright (C) 2011 Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gsttaglicenses
 * @short_description: utility functions for Creative Commons licenses
 * @see_also: #GstTagList
 *
 * Provides information about Creative Commons media licenses, which are
 * often expressed in media files as a license URI in tags. Also useful
 * for applications creating media files, in case the user wants to license
 * the content under a Creative Commons license.
 */

/* FIXME: add API to check obsolete-ness / replace-by */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>

#include <string.h>
#include <stdlib.h>

#include "tag.h"
#include "licenses-tables.dat"

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT ensure_debug_category()

static GstDebugCategory *
ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat_done;

    cat_done = (gsize) _gst_debug_category_new ("tag-licenses", 0,
        "GstTag licenses");

    g_once_init_leave (&cat_gonce, cat_done);
  }

  return (GstDebugCategory *) cat_gonce;
}

#else

#define ensure_debug_category() /* NOOP */

#endif /* GST_DISABLE_GST_DEBUG */

/* -------------------------------------------------------------------------
 *  Translations
 * ------------------------------------------------------------------------- */

#ifdef ENABLE_NLS
static GVariant *
gst_tag_get_license_translations_dictionary (void)
{
  static gsize var_gonce = 0;

  if (g_once_init_enter (&var_gonce)) {
    const gchar *dict_path;
    GVariant *var = NULL;
    GError *err = NULL;
    gchar *data;
    gsize len;

    /* for gst-uninstalled */
    dict_path = g_getenv ("GST_TAG_LICENSE_TRANSLATIONS_DICT");

    if (dict_path == NULL)
      dict_path = LICENSE_TRANSLATIONS_PATH;

    GST_INFO ("Loading license translations from '%s'", dict_path);
    if (g_file_get_contents (dict_path, &data, &len, &err)) {
      var = g_variant_new_from_data (G_VARIANT_TYPE ("a{sa{ss}}"), data, len,
          TRUE, (GDestroyNotify) g_free, data);
    } else {
      GST_WARNING ("Could not load translation dictionary %s", err->message);
      g_error_free (err);
      var = g_variant_new_array (G_VARIANT_TYPE ("{sa{ss}}"), NULL, 0);
    }

    g_once_init_leave (&var_gonce, (gsize) var);
  }

  return (GVariant *) var_gonce;
}
#endif

#ifdef ENABLE_NLS
static gboolean
gst_variant_lookup_string_value (GVariant * dict, const gchar * lang,
    const gchar ** translation)
{
  GVariant *trans;

  trans = g_variant_lookup_value (dict, lang, G_VARIANT_TYPE ("s"));
  if (trans == NULL)
    return FALSE;

  *translation = g_variant_get_string (trans, NULL);
  /* string will stay valid */
  g_variant_unref (trans);
  GST_TRACE ("Result: '%s' for language '%s'", *translation, lang);
  return TRUE;
}
#endif

static const gchar *
gst_license_str_translate (const gchar * s)
{
#ifdef ENABLE_NLS
  GVariant *v, *dict, *trans;

  v = gst_tag_get_license_translations_dictionary ();
  g_assert (v != NULL);

  dict = g_variant_lookup_value (v, s, G_VARIANT_TYPE ("a{ss}"));
  if (dict != NULL) {
    const gchar *const *lang;
    const gchar *env_lang;

    /* for unit tests */
    if ((env_lang = g_getenv ("GST_TAG_LICENSE_TRANSLATIONS_LANG"))) {
      if (gst_variant_lookup_string_value (dict, env_lang, &s))
        GST_TRACE ("Result: '%s' for forced language '%s'", s, env_lang);
      goto beach;
    }

    lang = g_get_language_names ();
    while (lang != NULL && *lang != NULL) {
      GST_TRACE ("Looking up '%s' for language '%s'", s, *lang);
      trans = g_variant_lookup_value (dict, *lang, G_VARIANT_TYPE ("s"));

      if (trans != NULL) {
        s = g_variant_get_string (trans, NULL);
        /* s will stay valid */
        g_variant_unref (trans);
        GST_TRACE ("Result: '%s'", s);
        break;
      }

      GST_TRACE ("No result for '%s' for language '%s'", s, *lang);
      ++lang;
    }

  beach:

    g_variant_unref (dict);
  } else {
    GST_WARNING ("No dict for string '%s'", s);
  }
#endif

  return s;
}

/* -------------------------------------------------------------------------
 *  License handling
 * ------------------------------------------------------------------------- */

#define CC_LICENSE_REF_PREFIX "http://creativecommons.org/licenses/"

/* is this license 'generic' (and a base for any of the supported
 * jurisdictions), or jurisdiction-specific only? */
#define JURISDICTION_GENERIC (G_GUINT64_CONSTANT (1) << 63)

static const gchar jurisdictions[] =
    "ar\000at\000au\000be\000bg\000br\000ca\000ch\000cl\000cn\000co\000de\000"
    "dk\000es\000fi\000fr\000hr\000hu\000il\000in\000it\000jp\000kr\000mk\000"
    "mt\000mx\000my\000nl\000pe\000pl\000pt\000scotland\000se\000si\000tw\000"
    "uk\000us\000za";

/**
 * gst_tag_get_licenses:
 *
 * Returns a list of known license references (in form of URIs). This is
 * useful for UIs to build a list of available licenses for tagging purposes
 * (e.g. to tag an audio track appropriately in a video or audio editor, or
 * an image in a camera application).
 *
 * Returns: (transfer full): NULL-terminated array of license strings. Free
 *     with g_strfreev() when no longer needed.
 */
gchar **
gst_tag_get_licenses (void)
{
  GPtrArray *arr;
  int i;

  arr = g_ptr_array_new ();
  for (i = 0; i < G_N_ELEMENTS (licenses); ++i) {
    const gchar *jurs;
    gboolean is_generic;
    guint64 jbits;
    gchar *ref;

    jbits = licenses[i].jurisdictions;
    is_generic = (jbits & JURISDICTION_GENERIC) != 0;
    if (is_generic) {
      ref = g_strconcat (CC_LICENSE_REF_PREFIX, licenses[i].ref, NULL);
      GST_LOG ("Adding %2d %s (generic)", i, ref);
      g_ptr_array_add (arr, ref);
      jbits &= ~JURISDICTION_GENERIC;
    }

    jurs = jurisdictions;
    while (jbits != 0) {
      if ((jbits & 1)) {
        ref = g_strconcat (CC_LICENSE_REF_PREFIX, licenses[i].ref, jurs, "/",
            NULL);
        GST_LOG ("Adding %2d %s (%s: %s)", i, ref,
            (is_generic) ? "derived" : "specific", jurs);
        g_ptr_array_add (arr, ref);
      }
      g_assert (jurs < (jurisdictions + sizeof (jurisdictions)));
      jurs += strlen (jurs) + 1;
      jbits >>= 1;
    }
  }
  g_ptr_array_add (arr, NULL);
  return (gchar **) g_ptr_array_free (arr, FALSE);
}

static gint
gst_tag_get_license_idx (const gchar * license_ref, const gchar ** jurisdiction)
{
  const gchar *ref, *jur_suffix;
  int i;

  GST_TRACE ("Looking up '%s'", license_ref);

  if (!g_str_has_prefix (license_ref, CC_LICENSE_REF_PREFIX)) {
    GST_WARNING ("unknown license prefix in ref '%s'", license_ref);
    return -1;
  }

  if (jurisdiction != NULL)
    *jurisdiction = NULL;

  ref = license_ref + sizeof (CC_LICENSE_REF_PREFIX) - 1;
  for (i = 0; i < G_N_ELEMENTS (licenses); ++i) {
    guint64 jbits = licenses[i].jurisdictions;
    const gchar *jurs, *lref = licenses[i].ref;
    gsize lref_len = strlen (lref);

    /* table should have "foo/bar/" with trailing slash */
    g_assert (lref[lref_len - 1] == '/');

    if ((jbits & JURISDICTION_GENERIC)) {
      GST_TRACE ("[%2d] %s checking generic match", i, licenses[i].ref);

      /* exact match? */
      if (strcmp (ref, lref) == 0)
        return i;

      /* exact match but without the trailing slash in ref? */
      if (strncmp (ref, lref, lref_len - 1) == 0 && ref[lref_len - 1] == '\0')
        return i;
    }

    if (!g_str_has_prefix (ref, lref))
      continue;

    GST_TRACE ("[%2d] %s checking jurisdictions", i, licenses[i].ref);

    jbits &= ~JURISDICTION_GENERIC;

    jur_suffix = ref + lref_len;
    if (*jur_suffix == '\0')
      continue;

    jurs = jurisdictions;
    while (jbits != 0) {
      guint jur_len = strlen (jurs);

      if ((jbits & 1)) {
        if (strncmp (jur_suffix, jurs, jur_len) == 0 &&
            (jur_suffix[jur_len] == '\0' || jur_suffix[jur_len] == '/')) {
          GST_LOG ("matched %s to %s with jurisdiction %s (idx %d)",
              license_ref, licenses[i].ref, jurs, i);
          if (jurisdiction != NULL)
            *jurisdiction = jurs;
          return i;
        }
      }
      g_assert (jurs < (jurisdictions + sizeof (jurisdictions)));
      jurs += jur_len + 1;
      jbits >>= 1;
    }
  }

  GST_WARNING ("unhandled license ref '%s'", license_ref);
  return -1;
}

/**
 * gst_tag_get_license_flags:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the flags of a license, which describe most of the features of
 * a license in their most general form.
 *
 * Returns: the flags of the license, or 0 if the license is unknown
 */
GstTagLicenseFlags
gst_tag_get_license_flags (const gchar * license_ref)
{
  int idx;

  g_return_val_if_fail (license_ref != NULL, 0);

  idx = gst_tag_get_license_idx (license_ref, NULL);
  return (idx < 0) ? 0 : licenses[idx].flags;
}

/**
 * gst_tag_get_license_nick:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the nick name of a license, which is a short (untranslated) string
 * such as e.g. "CC BY-NC-ND 2.0 UK".
 *
 * Returns: the nick name of the license, or NULL if the license is unknown
 */
const gchar *
gst_tag_get_license_nick (const gchar * license_ref)
{
  GstTagLicenseFlags flags;
  const gchar *creator_prefix, *res;
  gchar *nick, *c;

  g_return_val_if_fail (license_ref != NULL, NULL);

  flags = gst_tag_get_license_flags (license_ref);

  if ((flags & GST_TAG_LICENSE_CREATIVE_COMMONS_LICENSE)) {
    creator_prefix = "CC ";
  } else if ((flags & GST_TAG_LICENSE_FREE_SOFTWARE_FOUNDATION_LICENSE)) {
    creator_prefix = "FSF ";
  } else if (g_str_has_suffix (license_ref, "publicdomain/")) {
    creator_prefix = "";
  } else {
    return NULL;
  }

  nick = g_strdup_printf ("%s%s", creator_prefix,
      license_ref + sizeof (CC_LICENSE_REF_PREFIX) - 1);
  g_strdelimit (nick, "/", ' ');
  g_strchomp (nick);
  for (c = nick; *c != '\0'; ++c)
    *c = g_ascii_toupper (*c);

  GST_LOG ("%s => nick %s", license_ref, nick);
  res = g_intern_string (nick); /* for convenience */
  g_free (nick);

  return res;
}

/**
 * gst_tag_get_license_title:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the title of a license, which is a short translated description
 * of the license's features (generally not very pretty though).
 *
 * Returns: the title of the license, or NULL if the license is unknown or
 *    no title is available.
 */
const gchar *
gst_tag_get_license_title (const gchar * license_ref)
{
  int idx;

  g_return_val_if_fail (license_ref != NULL, NULL);

  idx = gst_tag_get_license_idx (license_ref, NULL);

  if (idx < 0 || licenses[idx].title_idx < 0)
    return NULL;

  return gst_license_str_translate (&license_strings[licenses[idx].title_idx]);
}

/**
 * gst_tag_get_license_description:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the description of a license, which is a translated description
 * of the license's main features.
 *
 * Returns: the description of the license, or NULL if the license is unknown
 *    or a description is not available.
 */
const gchar *
gst_tag_get_license_description (const gchar * license_ref)
{
  int idx;

  g_return_val_if_fail (license_ref != NULL, NULL);

  idx = gst_tag_get_license_idx (license_ref, NULL);

  if (idx < 0 || licenses[idx].desc_idx < 0)
    return NULL;

  return gst_license_str_translate (&license_strings[licenses[idx].desc_idx]);
}

/**
 * gst_tag_get_license_jurisdiction:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the jurisdiction code of a license. This is usually a two-letter
 * ISO 3166-1 alpha-2 code, but there is also the special case of Scotland,
 * for which no code exists and which is thus represented as "scotland".
 *
 * Known jurisdictions: ar, at, au, be, bg, br, ca, ch, cl, cn, co, de,
 * dk, es, fi, fr, hr, hu, il, in, it, jp, kr, mk, mt, mx, my, nl, pe, pl,
 * pt, scotland, se, si, tw, uk, us, za.
 *
 * Returns: the jurisdiction code of the license, or NULL if the license is
 *    unknown or is not specific to a particular jurisdiction.
 */
const gchar *
gst_tag_get_license_jurisdiction (const gchar * license_ref)
{
  const gchar *jurisdiction;
  int idx;

  g_return_val_if_fail (license_ref != NULL, NULL);

  idx = gst_tag_get_license_idx (license_ref, &jurisdiction);
  return (idx < 0) ? NULL : jurisdiction;
}

/**
 * gst_tag_get_license_version:
 * @license_ref: a license reference string in form of a URI,
 *     e.g. "http://creativecommons.org/licenses/by-nc-nd/2.0/"
 *
 * Get the version of a license.
 *
 * Returns: the version of the license, or NULL if the license is not known or
 *    has no version
 */
const gchar *
gst_tag_get_license_version (const gchar * license_ref)
{
  int idx;

  g_return_val_if_fail (license_ref != NULL, NULL);

  idx = gst_tag_get_license_idx (license_ref, NULL);
  if (idx < 0)
    return NULL;

#define LICENSE_FLAG_CC_OR_FSF \
 (GST_TAG_LICENSE_CREATIVE_COMMONS_LICENSE|\
  GST_TAG_LICENSE_FREE_SOFTWARE_FOUNDATION_LICENSE)

  /* e.g. publicdomain isn't versioned */
  if (!(licenses[idx].flags & LICENSE_FLAG_CC_OR_FSF))
    return NULL;

  /* KISS for now... */
  if (strstr (licenses[idx].ref, "/1.0/"))
    return "1.0";
  else if (strstr (licenses[idx].ref, "/2.0/"))
    return "2.0";
  else if (strstr (licenses[idx].ref, "/2.1/"))
    return "2.1";
  else if (strstr (licenses[idx].ref, "/2.5/"))
    return "2.5";
  else if (strstr (licenses[idx].ref, "/3.0/"))
    return "3.0";

  GST_ERROR ("Could not determine version for ref '%s'", license_ref);
  return NULL;
}

GType
gst_tag_license_flags_get_type (void)
{
  /* FIXME: we should really be using glib-mkenums for this.. */
#define C_FLAGS(v) ((guint) v)
  static gsize id = 0;
  static const GFlagsValue values[] = {
    {C_FLAGS (GST_TAG_LICENSE_PERMITS_REPRODUCTION),
        "GST_TAG_LICENSE_PERMITS_REPRODUCTION", "permits-reproduction"},
    {C_FLAGS (GST_TAG_LICENSE_PERMITS_DISTRIBUTION),
        "GST_TAG_LICENSE_PERMITS_DISTRIBUTION", "permits-distribution"},
    {C_FLAGS (GST_TAG_LICENSE_PERMITS_DERIVATIVE_WORKS),
          "GST_TAG_LICENSE_PERMITS_DERIVATIVE_WORKS",
        "permits-derivative-works"},
    {C_FLAGS (GST_TAG_LICENSE_PERMITS_SHARING),
        "GST_TAG_LICENSE_PERMITS_SHARING", "permits-sharing"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_NOTICE),
        "GST_TAG_LICENSE_REQUIRES_NOTICE", "requires-notice"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_ATTRIBUTION),
        "GST_TAG_LICENSE_REQUIRES_ATTRIBUTION", "requires-attributions"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_SHARE_ALIKE),
        "GST_TAG_LICENSE_REQUIRES_SHARE_ALIKE", "requires-share-alike"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_SOURCE_CODE),
        "GST_TAG_LICENSE_REQUIRES_SOURCE_CODE", "requires-source-code"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_COPYLEFT),
        "GST_TAG_LICENSE_REQUIRES_COPYLEFT", "requires-copyleft"},
    {C_FLAGS (GST_TAG_LICENSE_REQUIRES_LESSER_COPYLEFT),
          "GST_TAG_LICENSE_REQUIRES_LESSER_COPYLEFT",
        "requires-lesser-copyleft"},
    {C_FLAGS (GST_TAG_LICENSE_PROHIBITS_COMMERCIAL_USE),
          "GST_TAG_LICENSE_PROHIBITS_COMMERCIAL_USE",
        "prohibits-commercial-use"},
    {C_FLAGS (GST_TAG_LICENSE_PROHIBITS_HIGH_INCOME_NATION_USE),
          "GST_TAG_LICENSE_PROHIBITS_HIGH_INCOME_NATION_USE",
        "prohibits-high-income-nation-use"},
    {C_FLAGS (GST_TAG_LICENSE_CREATIVE_COMMONS_LICENSE),
          "GST_TAG_LICENSE_CREATIVE_COMMONS_LICENSE",
        "creative-commons-license"},
    {C_FLAGS (GST_TAG_LICENSE_FREE_SOFTWARE_FOUNDATION_LICENSE),
          "GST_TAG_LICENSE_FREE_SOFTWARE_FOUNDATION_LICENSE",
        "free-software-foundation-license"},
    {0, NULL, NULL}
  };

  if (g_once_init_enter (&id)) {
    GType tmp = g_flags_register_static ("GstTagLicenseFlags", values);
    g_once_init_leave (&id, tmp);
  }

  return (GType) id;
}
