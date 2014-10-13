/* GStreamer License Utility Functions
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

/* mklicensestables.c:
 * little program that reads liblicense's license RDF files and outputs tables
 * with the most important information, so we don't have to parse megabytes
 * of mostly redundant RDF files to get some basic information (and vendors
 * don't have to ship it all).
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "tag.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* TODO: we can merge some of the jurisdiction-only license table entries
 * into one entry with multiple jurisdictions and without the 'generic' flag,
 * .e.g. by-nc-nd/2.5/es + by-nc-nd/2.5/au => by-nc-nd/2.5/{es,au} */

#define LIBLICENSE_DATA_PREFIX "/usr/share/liblicense/licenses"

static GHashTable *unknown_sources;     /* NULL */

static GList *licenses;         /* NULL */

/* list of languages used for translations */
static GList *langs;            /* NULL */

/* keep in sync with licenses.c */
static const gchar jurisdictions[] =
    "ar\000at\000au\000be\000bg\000br\000ca\000ch\000cl\000cn\000co\000de\000"
    "dk\000es\000fi\000fr\000hr\000hu\000il\000in\000it\000jp\000kr\000mk\000"
    "mt\000mx\000my\000nl\000pe\000pl\000pt\000scotland\000se\000si\000tw\000"
    "uk\000us\000za";

/* keep in sync with gst_tag_get_license_version() */
static const gchar known_versions[] = "1.0/2.0/2.1/2.5/3.0/";

/* is this license 'generic' (and a base for any of the supported
 * jurisdictions), or jurisdiction-specific only? */
#define JURISDICTION_GENERIC (G_GUINT64_CONSTANT (1) << 63)

typedef struct
{
  gchar *ref;
  guint64 jurisdiction;
  gchar *jurisdiction_suffix;   /* if not generic (e.g. "jp/") */
  gchar *legalcode;
  gchar *version;
  gchar *replaced_by;
  gchar *source;

  GstTagLicenseFlags flags;

  gboolean deprecated;

  GHashTable *titles;
  GHashTable *descriptions;

  /* for processing */
  const gchar *cur_lang;
  gboolean packed_into_source;

  /* list of licenses packed into this one (ie. this is the source of those) */
  GList *derived;
} License;

static GstTagLicenseFlags
ref_to_flag (const gchar * ref)
{
  if (strcmp (ref, "http://creativecommons.org/ns#Reproduction") == 0)
    return GST_TAG_LICENSE_PERMITS_REPRODUCTION;
  if (strcmp (ref, "http://creativecommons.org/ns#Distribution") == 0)
    return GST_TAG_LICENSE_PERMITS_DISTRIBUTION;
  if (strcmp (ref, "http://creativecommons.org/ns#DerivativeWorks") == 0)
    return GST_TAG_LICENSE_PERMITS_DERIVATIVE_WORKS;
  if (strcmp (ref, "http://creativecommons.org/ns#Sharing") == 0)
    return GST_TAG_LICENSE_PERMITS_SHARING;
  if (strcmp (ref, "http://creativecommons.org/ns#Notice") == 0)
    return GST_TAG_LICENSE_REQUIRES_NOTICE;
  if (strcmp (ref, "http://creativecommons.org/ns#Attribution") == 0)
    return GST_TAG_LICENSE_REQUIRES_ATTRIBUTION;
  if (strcmp (ref, "http://creativecommons.org/ns#ShareAlike") == 0)
    return GST_TAG_LICENSE_REQUIRES_SHARE_ALIKE;
  if (strcmp (ref, "http://creativecommons.org/ns#SourceCode") == 0)
    return GST_TAG_LICENSE_REQUIRES_SOURCE_CODE;
  if (strcmp (ref, "http://creativecommons.org/ns#Copyleft") == 0)
    return GST_TAG_LICENSE_REQUIRES_COPYLEFT;
  if (strcmp (ref, "http://creativecommons.org/ns#LesserCopyleft") == 0)
    return GST_TAG_LICENSE_REQUIRES_LESSER_COPYLEFT;
  if (strcmp (ref, "http://creativecommons.org/ns#CommercialUse") == 0)
    return GST_TAG_LICENSE_PROHIBITS_COMMERCIAL_USE;
  if (strcmp (ref, "http://creativecommons.org/ns#HighIncomeNationUse") == 0)
    return GST_TAG_LICENSE_PROHIBITS_HIGH_INCOME_NATION_USE;

  g_error ("Unknown permits/requires/prohibits: %s\n", ref);
  return 0;
};

static guint64
ref_to_jurisdiction (const gchar * ref)
{
  const gchar *j = jurisdictions;
  gchar *jur;
  guint64 bit = 1;

  jur = g_strdup (ref + strlen ("http://creativecommons.org/international/"));
  g_strdelimit (jur, "/", '\0');
  while (j < jurisdictions + sizeof (jurisdictions)) {
    if (strcmp (j, jur) == 0) {
      g_free (jur);
      g_assert (bit != 0 && bit != JURISDICTION_GENERIC);
      return bit;
    }
    j += strlen (j) + 1;
    bit <<= 1;
  }
  g_error ("Unknown jurisdiction '%s'\n", ref);
}

typedef enum
{
  TAG_CC_LICENSE,
  TAG_CC_JURISDICTION,
  TAG_CC_LEGALCODE,
  TAG_CC_PROHIBITS,
  TAG_CC_REQUIRES,
  TAG_CC_PERMITS,
  TAG_CC_DEPRECATED_ON,
  TAG_DC_CREATOR,
  TAG_DC_SOURCE,
  TAG_DC_TITLE,
  TAG_DC_DESCRIPTION,
  TAG_DCQ_HAS_VERSION,
  TAG_DCQ_IS_REPLACED_BY,
  TAG_RDF_RDF,
  TAG_RDF_DESCRIPTION,
} Tag;

static const struct
{
  const gchar *element_name;
  const gchar *attribute;
  const Tag element_tag;
} tag_map[] = {
  {
  "cc:License", "rdf:about", TAG_CC_LICENSE}, {
  "cc:deprecatedOn", "rdf:datatype", TAG_CC_DEPRECATED_ON}, {
  "cc:jurisdiction", "rdf:resource", TAG_CC_JURISDICTION}, {
  "cc:legalcode", "rdf:resource", TAG_CC_LEGALCODE}, {
  "cc:prohibits", "rdf:resource", TAG_CC_PROHIBITS}, {
  "cc:requires", "rdf:resource", TAG_CC_REQUIRES}, {
  "cc:permits", "rdf:resource", TAG_CC_PERMITS}, {
  "dc:creator", "rdf:resource", TAG_DC_CREATOR}, {
  "dc:source", "rdf:resource", TAG_DC_SOURCE}, {
  "dc:title", "xml:lang", TAG_DC_TITLE}, {
  "dc:description", "xml:lang", TAG_DC_DESCRIPTION}, {
  "dcq:hasVersion", NULL, TAG_DCQ_HAS_VERSION}, {
  "dcq:isReplacedBy", "rdf:resource", TAG_DCQ_IS_REPLACED_BY}, {
  "rdf:RDF", NULL, TAG_RDF_RDF}, {
  "rdf:Description", "rdf:about", TAG_RDF_DESCRIPTION},
      /* these three are just for by-nc-nd_2.0_jp_.rdf */
  {
  "dc:isBasedOn", "rdf:resource", TAG_DC_SOURCE}, {
  "dc:hasVersion", NULL, TAG_DCQ_HAS_VERSION}, {
  "dc:isReplacedBy", "rdf:resource", TAG_DCQ_IS_REPLACED_BY}
};

static void
parse_start (GMarkupParseContext * ctx, const gchar * element_name,
    const gchar ** attr_names, const gchar ** attr_vals,
    gpointer user_data, GError ** err)
{
  License *license = user_data;
  const gchar *ref = NULL;
  int i;

  for (i = 0; i < G_N_ELEMENTS (tag_map); ++i) {
    if (strcmp (element_name, tag_map[i].element_name) == 0)
      break;
  }

  if (i == G_N_ELEMENTS (tag_map))
    g_error ("Unexpected tag '%s'\n", element_name);

  if (tag_map[i].attribute == NULL)
    return;

  if (!g_markup_collect_attributes (element_name, attr_names, attr_vals,
          err, G_MARKUP_COLLECT_STRING, tag_map[i].attribute, &ref,
          G_MARKUP_COLLECT_INVALID)) {
    return;
  }

  switch (tag_map[i].element_tag) {
    case TAG_CC_LICENSE:
      if (!g_str_has_prefix (ref, "http://creativecommons.org/licenses/"))
        g_error ("Unexpected license reference: %s\n", ref);
      /* we assume one license per file, and CC license ref */
      g_assert (license->ref == NULL);
      license->ref = g_strdup (ref);
      break;
    case TAG_CC_JURISDICTION:
      if (!g_str_has_prefix (ref, "http://creativecommons.org/international/"))
        g_error ("Unknown license jurisdiction: %s\n", ref);
      /* we assume one jurisdiction per license */
      g_assert (license->jurisdiction == JURISDICTION_GENERIC);
      license->jurisdiction = ref_to_jurisdiction (ref);
      license->jurisdiction_suffix =
          g_strdup (ref + strlen ("http://creativecommons.org/international/"));
      break;
    case TAG_CC_LEGALCODE:
      if (!g_str_has_prefix (ref, "http://creativecommons.org/licenses/"))
        g_error ("Unexpected legalcode reference: %s\n", ref);
      /* we assume one legalcode per license */
      g_assert (license->legalcode == NULL);
      license->legalcode = g_strdup (ref);
      break;
    case TAG_DC_CREATOR:
      if (strcmp (ref, "http://creativecommons.org") == 0) {
        license->flags |= GST_TAG_LICENSE_CREATIVE_COMMONS_LICENSE;
      } else if (strcmp (ref, "http://fsf.org") == 0) {
        license->flags |= GST_TAG_LICENSE_FREE_SOFTWARE_FOUNDATION_LICENSE;
      } else {
        g_error ("Unknown license creator: %s\n", ref);
      }
      break;
    case TAG_CC_DEPRECATED_ON:
      break;
    case TAG_CC_PROHIBITS:
    case TAG_CC_REQUIRES:
    case TAG_CC_PERMITS:
      license->flags |= ref_to_flag (ref);
      break;
    case TAG_DC_TITLE:{
      gchar *cur_lang;

      cur_lang = g_strdelimit (g_strdup (ref), "-", '_');
      license->cur_lang = g_intern_string (cur_lang);
      if (!g_list_find_custom (langs, cur_lang, (GCompareFunc) strcmp))
        langs = g_list_prepend (langs, (gpointer) license->cur_lang);

      g_free (cur_lang);
      break;
    }
    case TAG_DC_DESCRIPTION:{
      gchar *cur_lang;

      cur_lang = g_strdelimit (g_strdup (ref), "-", '_');
      license->cur_lang = g_intern_string (cur_lang);
      if (!g_list_find_custom (langs, cur_lang, (GCompareFunc) strcmp))
        langs = g_list_prepend (langs, (gpointer) license->cur_lang);

      g_free (cur_lang);
      break;
    }
    case TAG_DCQ_IS_REPLACED_BY:
      /* we assume one replacer per license for now */
      g_assert (license->replaced_by == NULL);
      license->replaced_by = g_strdup (ref);
      break;
    case TAG_RDF_DESCRIPTION:
      if (!g_str_has_prefix (ref, "http://creativecommons.org/licenses/"))
        g_error ("Unexpected license reference: %s\n", ref);
      if (license->ref != NULL && strcmp (license->ref, ref) != 0) {
        gchar *f, *r = g_strdup (ref);

        /* work around bug in some of the RDFs ... */
        if ((f = strstr (r, "by-nc-nd"))) {
          memcpy (f, "by-nd-nc", 8);
        }
        if (strcmp (license->ref, r) != 0) {
          g_error ("rdf:Description chunk for other than current license");
        }
        g_free (r);
      }
      break;
    case TAG_DC_SOURCE:
      if (!g_str_has_prefix (ref, "http://creativecommons.org/licenses/"))
        g_error ("Unexpected source reference: %s\n", ref);
      /* we assume one source (for jurisdiction-specific versions) */
      g_assert (license->source == NULL);
      license->source = g_strdup (ref);
      break;
    default:
      g_printerr ("unhandled start tag: %s\n", element_name);
      break;
  }
}

static void
parse_text (GMarkupParseContext * ctx, const gchar * text, gsize text_len,
    gpointer user_data, GError ** err)
{
  License *license = user_data;
  const gchar *element_name, *found;
  int i;

  element_name = g_markup_parse_context_get_element (ctx);
  for (i = 0; i < G_N_ELEMENTS (tag_map); ++i) {
    if (strcmp (element_name, tag_map[i].element_name) == 0)
      break;
  }

  if (i == G_N_ELEMENTS (tag_map))
    g_error ("Unexpected tag '%s'\n", element_name);

  switch (tag_map[i].element_tag) {
    case TAG_CC_LICENSE:
    case TAG_CC_JURISDICTION:
    case TAG_CC_LEGALCODE:
    case TAG_DC_CREATOR:
    case TAG_CC_PROHIBITS:
    case TAG_CC_REQUIRES:
    case TAG_CC_PERMITS:
    case TAG_RDF_RDF:
    case TAG_RDF_DESCRIPTION:
      break;
    case TAG_DC_TITLE:
      if (license->titles == NULL) {
        license->titles = g_hash_table_new (g_str_hash, g_str_equal);
      }
      g_hash_table_insert (license->titles, (gpointer) license->cur_lang,
          (gpointer) g_intern_string (text));
      break;
    case TAG_DC_DESCRIPTION:{
      gchar *txt = g_strdup (text);

      if (license->descriptions == NULL) {
        license->descriptions = g_hash_table_new (g_str_hash, g_str_equal);
      }
      g_strdelimit (txt, "\n", ' ');
      g_hash_table_insert (license->descriptions, (gpointer) license->cur_lang,
          (gpointer) g_intern_string (txt));
      g_free (txt);
      break;
    }
    case TAG_DCQ_HAS_VERSION:
      /* we assume one version per license */
      g_assert (license->version == NULL);
      license->version = g_strdup (text);
      found = strstr (known_versions, license->version);
      if (found == NULL || found[strlen (license->version)] != '/')
        g_error ("Unexpected version '%s', please add to table.", text);
      break;
    case TAG_CC_DEPRECATED_ON:
      license->deprecated = TRUE;
      break;
    case TAG_DC_SOURCE:        // FIXME
    default:
      g_print ("text (%s) (%s): '%s'\n", element_name, license->cur_lang, text);
  }
}

static void
parse_passthrough (GMarkupParseContext * ctx, const gchar * text, gsize len,
    gpointer user_data, GError ** err)
{
  if (!g_str_has_prefix (text, "<?xml ")) {
    g_error ("Unexpected passthrough text: %s\n", text);
  }
}

static void
parse_error (GMarkupParseContext * ctx, GError * err, gpointer data)
{
  g_error ("parse error: %s\n", err->message);
}

static const GMarkupParser license_rdf_parser = {
  parse_start, NULL, parse_text, parse_passthrough, parse_error
};

static void
parse_license_rdf (const gchar * fn, const gchar * rdf)
{
  GMarkupParseContext *ctx;
  License *license;
  GError *err = NULL;

  if (!g_utf8_validate (rdf, -1, NULL)) {
    g_error ("%s is not valid UTF-8\n", fn);
  }

  license = g_new0 (License, 1);

  /* mark as generic until proven otherwise */
  license->jurisdiction = JURISDICTION_GENERIC;

  ctx = g_markup_parse_context_new (&license_rdf_parser,
      G_MARKUP_TREAT_CDATA_AS_TEXT, license, NULL);

  /* g_print ("Parsing %s\n", fn); */

  if (!g_markup_parse_context_parse (ctx, rdf, -1, &err)) {
    g_error ("Error parsing file %s: %s\n", fn, err->message);
  }

  licenses = g_list_append (licenses, license);

  g_markup_parse_context_free (ctx);
}

static void
read_licenses (const gchar * licenses_dir)
{
  const gchar *name;
  GError *err = NULL;
  GDir *dir;

  dir = g_dir_open (licenses_dir, 0, &err);

  if (dir == NULL)
    g_error ("Failed to g_dir_open('%s'): %s", licenses_dir, err->message);

  while ((name = g_dir_read_name (dir))) {
    gchar *fn, *rdf;

    fn = g_build_filename (licenses_dir, name, NULL);
    if (g_file_get_contents (fn, &rdf, NULL, &err)) {
      parse_license_rdf (fn, rdf);
      g_free (rdf);
    } else {
      g_printerr ("Could not read file '%s': %s\n", fn, err->message);
      g_error_free (err);
      err = NULL;
    }
    g_free (fn);
  }

  g_dir_close (dir);
}

static License *
find_license (const gchar * ref)
{
  GList *l;

  if (!g_str_has_prefix (ref, "http://creativecommons.org/"))
    return NULL;

  for (l = licenses; l != NULL; l = l->next) {
    License *license = l->data;

    if (strcmp (license->ref, ref) == 0)
      return license;
  }

  return NULL;
}

static int
license_ref_cmp (License * a, License * b)
{
  return strcmp (a->ref, b->ref);
}

#define STRING_TABLE_MAX_STRINGS 100
typedef struct
{
  GString *s;
  guint num_escaped;
  guint num_strings;
  guint indices[STRING_TABLE_MAX_STRINGS];
  gchar *strings[STRING_TABLE_MAX_STRINGS];     /* unescaped strings */
} StringTable;

static StringTable *
string_table_new (void)
{
  StringTable *t = g_new0 (StringTable, 1);

  t->s = g_string_new (NULL);
  return t;
}

static void
string_table_free (StringTable * t)
{
  int i;

  for (i = 0; i < t->num_strings; ++i)
    g_free (t->strings[i]);

  g_string_free (t->s, TRUE);
  g_free (t);
}

static guint
string_table_add_string (StringTable * t, const gchar * str)
{
  const gchar *s;
  guint idx, i;

  /* check if we already have this string */
  for (i = 0; i < t->num_strings; ++i) {
    if (strcmp (t->strings[i], str) == 0)
      return t->indices[i];
  }

  /* save current offset */
  idx = t->s->len;

  /* adjust for fact that \000 is 4 chars now but will take up only 1 later */
  idx -= t->num_escaped * 3;

  /* append one char at a time, making sure to escape UTF-8 characters */
  for (s = str; s != NULL && *s != '\0'; ++s) {
    if (g_ascii_isprint (*s) && *s != '"' && *s != '\\') {
      g_string_append_c (t->s, *s);
    } else {
      g_string_append_printf (t->s, "\\%03o", (unsigned char) *s);
      t->num_escaped++;
    }
  }
  g_string_append (t->s, "\\000");
  t->num_escaped++;

  t->indices[t->num_strings] = idx;
  t->strings[t->num_strings] = g_strdup (str);
  ++t->num_strings;

  return idx;
}

static void
string_table_print (StringTable * t)
{
  const gchar *s;

  s = t->s->str;
  while (s != NULL && *s != '\0') {
    gchar line[74], *lastesc;
    guint left;

    left = strlen (s);
    g_strlcpy (line, s, MIN (left, sizeof (line)));
    s += sizeof (line) - 1;
    /* avoid partial escaped codes at the end of a line */
    if ((lastesc = strrchr (line, '\\')) && strlen (lastesc) < 4) {
      s -= strlen (lastesc);
      *lastesc = '\0';
    }
    g_print ("  \"%s\"", line);
    if (left < 74)
      break;
    g_print ("\n");
  }
  g_print (";\n");
}

/* skip translation if translated string for e.g. "fr_ca" is same as for "fr" */
static gboolean
skip_translation (GHashTable * ht_strings, const gchar * lang,
    const gchar * trans)
{
  const gchar *simple_trans;
  gchar *simple_lang;

  if (strchr (lang, '_') == NULL)
    return FALSE;

  simple_lang = g_strdup (lang);
  g_strdelimit (simple_lang, "_", '\0');

  simple_trans = g_hash_table_lookup (ht_strings, (gpointer) simple_lang);
  g_free (simple_lang);

  return (simple_trans != NULL && strcmp (trans, simple_trans) == 0);
}

static GVariant *
create_translation_dict (GHashTable * ht_strings, const gchar * en)
{
  GVariantBuilder array;
  guint count = 0;
  GList *l;

  g_variant_builder_init (&array, G_VARIANT_TYPE_ARRAY);

  for (l = langs; l != NULL; l = l->next) {
    const gchar *trans, *lang;

    lang = (const gchar *) l->data;
    trans = g_hash_table_lookup (ht_strings, (gpointer) lang);
    if (trans != NULL && *trans != '\0' && strcmp (en, trans) != 0 &&
        !skip_translation (ht_strings, lang, trans)) {
      /* g_print ("%s (%s) => %s\n", en, lang, trans); */
      g_variant_builder_add_value (&array,
          g_variant_new_dict_entry (g_variant_new_string (lang),
              g_variant_new_string (trans)));
      ++count;
    }
  }

  if (count == 0) {
    g_variant_builder_clear (&array);
    return NULL;
  }

  return g_variant_builder_end (&array);
}

static void
write_translations_dictionary (GList * licenses, const gchar * dict_filename)
{
  /* maps C string => (dictionary of: locale => translation) */
  GVariantBuilder array;
  /* maps C string => boolean (if it's in the dictionary already */
  GHashTable *translations;
  GVariant *var;
  GList *l;
  FILE *f;

  /* sort langs for prettiness / to make variant dumps easier to read */
  langs = g_list_sort (langs, (GCompareFunc) strcmp);

  g_variant_builder_init (&array, G_VARIANT_TYPE_ARRAY);

  translations = g_hash_table_new (g_str_hash, g_str_equal);

  for (l = licenses; l != NULL; l = l->next) {
    const gchar *en;
    License *license;

    license = l->data;

    if (license->packed_into_source)
      continue;

    /* add title + translations */
    en = g_hash_table_lookup (license->titles, "en");
    g_assert (en != NULL);

    /* check if we already have added translations for this string */
    if (!g_hash_table_lookup (translations, (gpointer) en)) {
      GVariant *trans;

      trans = create_translation_dict (license->titles, en);
      if (trans != NULL) {
        g_variant_builder_add_value (&array,
            g_variant_new_dict_entry (g_variant_new_string (en), trans));
        g_hash_table_insert (translations, (gpointer) en,
            GINT_TO_POINTER (TRUE));
      }
    }

    /* add description + translations */
    if (license->descriptions == NULL)
      continue;

    en = g_hash_table_lookup (license->descriptions, "en");
    g_assert (en != NULL);

    /* check if we already have added translations for this string */
    if (!g_hash_table_lookup (translations, (gpointer) en)) {
      GVariant *trans;

      trans = create_translation_dict (license->descriptions, en);
      if (trans != NULL) {
        g_variant_builder_add_value (&array,
            g_variant_new_dict_entry (g_variant_new_string (en), trans));
        g_hash_table_insert (translations, (gpointer) en,
            GINT_TO_POINTER (TRUE));
      }
    }
  }

  var = g_variant_builder_end (&array);

  f = fopen (dict_filename, "wb");
  if (fwrite (g_variant_get_data (var), g_variant_get_size (var), 1, f) != 1) {
    g_error ("failed to write dict to file: %s", g_strerror (errno));
  }
  fclose (f);

  g_printerr ("Wrote dictionary to %s, size: %u, type: %s\n", dict_filename,
      (guint) g_variant_get_size (var), (gchar *) g_variant_get_type (var));

  g_variant_unref (var);
  g_hash_table_destroy (translations);
}

int
main (int argc, char **argv)
{
  gchar *translation_dict_fn = NULL;
  GOptionContext *ctx;
  GOptionEntry options[] = {
    {"translation-dictionary", 0, 0, G_OPTION_ARG_FILENAME,
          &translation_dict_fn, "Filename of translations dictionary to write",
        NULL},
    {NULL}
  };
  StringTable *string_table;
  GError *err = NULL;
  GList *l;
  int idx = 0;

  ctx = g_option_context_new ("");
  g_option_context_add_main_entries (ctx, options, NULL);
  if (!g_option_context_parse (ctx, &argc, &argv, &err)) {
    g_printerr ("Error initializing: %s\n", err->message);
    exit (1);
  }
  g_option_context_free (ctx);

  read_licenses (LIBLICENSE_DATA_PREFIX);

  g_printerr ("%d licenses\n", g_list_length (licenses));

  unknown_sources = g_hash_table_new (g_str_hash, g_str_equal);

  for (l = licenses; l != NULL; l = l->next) {
    License *license = l->data;

    /* if the license has as source, check if we can 'pack' it into the
     * original license as a jurisdiction-specific variant */
    if (license->source != NULL) {
      License *source = find_license (license->source);

      if (source != NULL) {
        if (source->flags != license->flags) {
          g_printerr ("Source and derived license have different flags:\n"
              "\t0x%08x : %s\n\t0x%08x : %s\n", source->flags, source->ref,
              license->flags, license->ref);
          source = NULL;
        } else {
          if (source->descriptions == NULL) {
            /* neither should the derived one then */
            g_assert (license->descriptions == NULL);
          } else {
            /* make sure we're not settling for fewer descriptions than
             * there are */
            g_assert (g_hash_table_size (license->titles) <=
                g_hash_table_size (source->titles));
            g_assert (g_hash_table_size (license->descriptions) <=
                g_hash_table_size (source->descriptions));
          }
        }
      } else {
        /* a source is referenced that we haven't encountered
         * (possibly a referencing bug? seems to happen e.g. when there's a
         * 2.1 version of a jurisdiction license and it refers to a 2.1
         * source version, but there's only a 2.0 or 2.5 source version. So
         * maybe it's supposed to refer to the 2.0 source then, who knows) */
        if (!g_hash_table_lookup (unknown_sources, license->source)) {
          g_printerr ("Unknown source license %s\n", license->source);
          g_hash_table_insert (unknown_sources, g_strdup (license->source),
              GUINT_TO_POINTER (TRUE));
        }
        /* g_print ("Unknown source license %s referenced from %s\n",
         * license->source, license->ref); */
      }

      /* should we pack this into the source or not */
      if (source != NULL) {
        source->jurisdiction |= license->jurisdiction;
        source->derived = g_list_insert_sorted (source->derived, license,
            (GCompareFunc) license_ref_cmp);
        license->packed_into_source = TRUE;
      }
    } else {
      /* no source license */
      if (license->titles == NULL)
        g_error ("License has no titles: %s\n", license->ref);
      if (license->descriptions == NULL);
      g_printerr ("License %s has no descriptions!\n", license->ref);
    }
  }

  licenses = g_list_sort (licenses, (GCompareFunc) license_ref_cmp);

  string_table = string_table_new ();

  g_print ("/* created by mklicensestables.c */\n");
  g_print ("static const struct {\n"
      "  /* jurisdictions in addition to the generic version, bitfield */\n"
      "  const guint64             jurisdictions;\n"
      "  const GstTagLicenseFlags  flags;\n"
      "  /* the bit after http://creativecommons.org/licenses/ */\n"
      "  const gchar               ref[18];\n"
      "  gint16                    title_idx;  /* index in string table */\n"
      "  gint16                    desc_idx;   /* index in string table */\n"
      "} licenses[] = {\n");

  for (l = licenses; l != NULL; l = l->next) {
    const gchar *title_en, *desc_en;
    int idx_title, idx_desc;
    License *license;

    license = l->data;

    if (license->packed_into_source)
      continue;

    title_en = g_hash_table_lookup (license->titles, "en");
    g_assert (title_en != NULL);
    idx_title = string_table_add_string (string_table, title_en);
    g_assert (idx_title <= G_MAXINT16);

    if (license->descriptions != NULL) {
      desc_en = g_hash_table_lookup (license->descriptions, "en");
      g_assert (desc_en != NULL);
      idx_desc = string_table_add_string (string_table, desc_en);
      g_assert (idx_desc <= G_MAXINT16);
    } else {
      idx_desc = -1;
    }

    /* output comments with license refs covered by the next stanza */
    if (license->derived != NULL) {
      GList *d;

      g_print ("  /* %2d %s\n", idx, license->ref);

      for (d = license->derived; d != NULL; d = d->next) {
        License *derived_license = d->data;

        g_print ("   * %2d %s%s\n", idx, derived_license->ref,
            (d->next == NULL) ? " */" : "");
      }
    } else {
      g_print ("  /* %2d %s */\n", idx, license->ref);
    }
    /* output essential data */
    {
      gchar *ref;

      ref =
          g_strdup (license->ref +
          strlen ("http://creativecommons.org/licenses/"));

      /* remove jurisdiction suffix from ref if this is non-generic, since
       * the suffix is already contained in the jurisdiction flags */
      if (license->jurisdiction_suffix != NULL) {
        gsize suffix_len = strlen (license->jurisdiction_suffix);
        gchar *cutoff;

        cutoff = ref + strlen (ref) - suffix_len;
        g_assert (!strncmp (cutoff, license->jurisdiction_suffix, suffix_len));
        g_assert (cutoff[suffix_len - 1] == '/');
        g_assert (cutoff[suffix_len] == '\0');
        *cutoff = '\0';
      }

      g_print ("  { 0x%016" G_GINT64_MODIFIER "x, 0x%08x, \"%s\", %d, %d }%s\n",
          license->jurisdiction, license->flags, ref, idx_title, idx_desc,
          (l->next != NULL) ? "," : "");

      g_free (ref);
    }
    ++idx;
  }
  g_print ("};\n");

  g_print ("\nstatic const gchar license_strings[] =\n");
  string_table_print (string_table);
  string_table_free (string_table);
  string_table = NULL;

  if (translation_dict_fn != NULL) {
    write_translations_dictionary (licenses, translation_dict_fn);
  }

  return 0;
}
