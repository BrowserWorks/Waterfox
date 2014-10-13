/* GStreamer
 * Copyright (C) 2010 Stefan Kost <stefan.kost@nokia.com>
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
 *
 * gstxmptag.c: library for reading / modifying xmp tags
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
 * SECTION:gsttagxmp
 * @short_description: tag mappings and support functions for plugins
 *                     dealing with xmp packets
 * @see_also: #GstTagList
 *
 * Contains various utility functions for plugins to parse or create
 * xmp packets and map them to and from #GstTagList<!-- -->s.
 *
 * Please note that the xmp parser is very lightweight and not strict at all.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "tag.h"
#include <gst/gsttagsetter.h>
#include "gsttageditingprivate.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

#define GST_CAT_DEFAULT gst_tag_ensure_debug_category()

static GstDebugCategory *
gst_tag_ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    GstDebugCategory *cat = NULL;

    GST_DEBUG_CATEGORY_INIT (cat, "xmp-tags", 0, "XMP GstTag helper functions");

    g_once_init_leave (&cat_gonce, (gsize) cat);
  }

  return (GstDebugCategory *) cat_gonce;
}

static const gchar *schema_list[] = {
  "dc",
  "xap",
  "tiff",
  "exif",
  "photoshop",
  "Iptc4xmpCore",
  "Iptc4xmpExt",
  NULL
};

/**
 * gst_tag_xmp_list_schemas:
 *
 * Gets the list of supported schemas in the xmp lib
 *
 * Returns: (transfer none): a %NULL terminated array of strings with the
 *     schema names
 */
const gchar **
gst_tag_xmp_list_schemas (void)
{
  return schema_list;
}

typedef struct _XmpSerializationData XmpSerializationData;
typedef struct _XmpTag XmpTag;

/*
 * Serializes a GValue into a string.
 */
typedef gchar *(*XmpSerializationFunc) (const GValue * value);

/*
 * Deserializes @str that is the gstreamer tag @gst_tag represented in
 * XMP as the @xmp_tag_value and adds the result to the @taglist.
 *
 * @pending_tags is passed so that compound xmp tags can search for its
 * complements on the list and use them. Note that used complements should
 * be freed and removed from the list.
 * The list is of PendingXmpTag
 */
typedef void (*XmpDeserializationFunc) (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag_value,
    const gchar * str, GSList ** pending_tags);

struct _XmpSerializationData
{
  GString *data;
  const gchar **schemas;
};

static gboolean
xmp_serialization_data_use_schema (XmpSerializationData * serdata,
    const gchar * schemaname)
{
  gint i = 0;
  if (serdata->schemas == NULL)
    return TRUE;

  while (serdata->schemas[i] != NULL) {
    if (strcmp (serdata->schemas[i], schemaname) == 0)
      return TRUE;
    i++;
  }
  return FALSE;
}

typedef enum
{
  GstXmpTagTypeNone = 0,
  GstXmpTagTypeSimple,
  GstXmpTagTypeBag,
  GstXmpTagTypeSeq,
  GstXmpTagTypeStruct,

  /* Not really a xmp type, this is a tag that in gst is represented with
   * a single value and on xmp it needs 2 (or more) simple values
   *
   * e.g. GST_TAG_GEO_LOCATION_ELEVATION needs to be mapped into 2 complementary
   * tags in the exif's schema. One of them stores the absolute elevation,
   * and the other one stores if it is above of below sea level.
   */
  GstXmpTagTypeCompound
} GstXmpTagType;

struct _XmpTag
{
  const gchar *gst_tag;
  const gchar *tag_name;
  GstXmpTagType type;

  /* some tags must be inside a Bag even
   * if they are a single entry. Set it here so we know */
  GstXmpTagType supertype;

  /* For tags that need a rdf:parseType attribute */
  const gchar *parse_type;

  /* Used for struct and compound types */
  GSList *children;

  XmpSerializationFunc serialize;
  XmpDeserializationFunc deserialize;
};

static GstTagMergeMode
xmp_tag_get_merge_mode (XmpTag * xmptag)
{
  switch (xmptag->type) {
    case GstXmpTagTypeBag:
    case GstXmpTagTypeSeq:
      return GST_TAG_MERGE_APPEND;
    case GstXmpTagTypeSimple:
    default:
      return GST_TAG_MERGE_KEEP;
  }
}

static const gchar *
xmp_tag_type_get_name (GstXmpTagType tagtype)
{
  switch (tagtype) {
    case GstXmpTagTypeSeq:
      return "rdf:Seq";
    case GstXmpTagTypeBag:
      return "rdf:Bag";
    default:
      break;
  }

  /* Make compiler happy */
  g_return_val_if_reached ("");
}

struct _PendingXmpTag
{
  XmpTag *xmp_tag;
  gchar *str;
};
typedef struct _PendingXmpTag PendingXmpTag;

/*
 * A schema is a mapping of strings (the tag name in gstreamer) to a list of
 * tags in xmp (XmpTag).
 */
typedef GHashTable GstXmpSchema;
#define gst_xmp_schema_lookup g_hash_table_lookup
#define gst_xmp_schema_insert g_hash_table_insert
static GstXmpSchema *
gst_xmp_schema_new ()
{
  return g_hash_table_new (g_direct_hash, g_direct_equal);
}

/*
 * Mappings from schema names into the schema group of tags (GstXmpSchema)
 */
static GHashTable *__xmp_schemas;

static GstXmpSchema *
_gst_xmp_get_schema (const gchar * name)
{
  GQuark key;
  GstXmpSchema *schema;

  key = g_quark_from_string (name);

  schema = g_hash_table_lookup (__xmp_schemas, GUINT_TO_POINTER (key));
  if (!schema) {
    GST_WARNING ("Schema %s doesn't exist", name);
  }
  return schema;
}

static void
_gst_xmp_add_schema (const gchar * name, GstXmpSchema * schema)
{
  GQuark key;

  key = g_quark_from_string (name);

  if (g_hash_table_lookup (__xmp_schemas, GUINT_TO_POINTER (key))) {
    GST_WARNING ("Schema %s already exists, ignoring", name);
    g_assert_not_reached ();
    return;
  }

  g_hash_table_insert (__xmp_schemas, GUINT_TO_POINTER (key), schema);
}

static void
_gst_xmp_schema_add_mapping (GstXmpSchema * schema, XmpTag * tag)
{
  GQuark key;

  key = g_quark_from_string (tag->gst_tag);

  if (gst_xmp_schema_lookup (schema, GUINT_TO_POINTER (key))) {
    GST_WARNING ("Tag %s already present for the schema", tag->gst_tag);
    g_assert_not_reached ();
    return;
  }
  gst_xmp_schema_insert (schema, GUINT_TO_POINTER (key), tag);
}

static XmpTag *
gst_xmp_tag_create (const gchar * gst_tag, const gchar * xmp_tag,
    gint xmp_type, XmpSerializationFunc serialization_func,
    XmpDeserializationFunc deserialization_func)
{
  XmpTag *xmpinfo;

  xmpinfo = g_slice_new (XmpTag);
  xmpinfo->gst_tag = gst_tag;
  xmpinfo->tag_name = xmp_tag;
  xmpinfo->type = xmp_type;
  xmpinfo->supertype = GstXmpTagTypeNone;
  xmpinfo->parse_type = NULL;
  xmpinfo->serialize = serialization_func;
  xmpinfo->deserialize = deserialization_func;
  xmpinfo->children = NULL;

  return xmpinfo;
}

static XmpTag *
gst_xmp_tag_create_compound (const gchar * gst_tag, const gchar * xmp_tag_a,
    const gchar * xmp_tag_b, XmpSerializationFunc serialization_func_a,
    XmpSerializationFunc serialization_func_b,
    XmpDeserializationFunc deserialization_func)
{
  XmpTag *xmptag;
  XmpTag *xmptag_a =
      gst_xmp_tag_create (gst_tag, xmp_tag_a, GstXmpTagTypeSimple,
      serialization_func_a, deserialization_func);
  XmpTag *xmptag_b =
      gst_xmp_tag_create (gst_tag, xmp_tag_b, GstXmpTagTypeSimple,
      serialization_func_b, deserialization_func);

  xmptag =
      gst_xmp_tag_create (gst_tag, NULL, GstXmpTagTypeCompound, NULL, NULL);

  xmptag->children = g_slist_prepend (xmptag->children, xmptag_b);
  xmptag->children = g_slist_prepend (xmptag->children, xmptag_a);

  return xmptag;
}

static void
_gst_xmp_schema_add_simple_mapping (GstXmpSchema * schema,
    const gchar * gst_tag, const gchar * xmp_tag, gint xmp_type,
    XmpSerializationFunc serialization_func,
    XmpDeserializationFunc deserialization_func)
{
  _gst_xmp_schema_add_mapping (schema,
      gst_xmp_tag_create (gst_tag, xmp_tag, xmp_type, serialization_func,
          deserialization_func));
}

/*
 * We do not return a copy here because elements are
 * appended, and the API is not public, so we shouldn't
 * have our lists modified during usage
 */
#if 0
static GPtrArray *
_xmp_tag_get_mapping (const gchar * gst_tag, XmpSerializationData * serdata)
{
  GPtrArray *ret = NULL;
  GHashTableIter iter;
  GQuark key = g_quark_from_string (gst_tag);
  gpointer iterkey, value;
  const gchar *schemaname;

  g_hash_table_iter_init (&iter, __xmp_schemas);
  while (!ret && g_hash_table_iter_next (&iter, &iterkey, &value)) {
    GstXmpSchema *schema = (GstXmpSchema *) value;

    schemaname = g_quark_to_string (GPOINTER_TO_UINT (iterkey));
    if (xmp_serialization_data_use_schema (serdata, schemaname))
      ret =
          (GPtrArray *) gst_xmp_schema_lookup (schema, GUINT_TO_POINTER (key));
  }
  return ret;
}
#endif

/* finds the gst tag that maps to this xmp tag in this schema */
static const gchar *
_gst_xmp_schema_get_mapping_reverse (GstXmpSchema * schema,
    const gchar * xmp_tag, XmpTag ** _xmp_tag)
{
  GHashTableIter iter;
  gpointer key, value;
  const gchar *ret = NULL;

  /* Iterate over the hashtable */
  g_hash_table_iter_init (&iter, schema);
  while (!ret && g_hash_table_iter_next (&iter, &key, &value)) {
    XmpTag *xmpinfo = (XmpTag *) value;

    if (xmpinfo->tag_name) {
      if (strcmp (xmpinfo->tag_name, xmp_tag) == 0) {
        *_xmp_tag = xmpinfo;
        ret = g_quark_to_string (GPOINTER_TO_UINT (key));
        goto out;
      }
    } else if (xmpinfo->children) {
      GSList *iter;
      for (iter = xmpinfo->children; iter; iter = g_slist_next (iter)) {
        XmpTag *child = iter->data;
        if (strcmp (child->tag_name, xmp_tag) == 0) {
          *_xmp_tag = child;
          ret = g_quark_to_string (GPOINTER_TO_UINT (key));
          goto out;
        }
      }
    } else {
      g_assert_not_reached ();
    }
  }

out:
  return ret;
}

/* finds the gst tag that maps to this xmp tag (searches on all schemas) */
static const gchar *
_gst_xmp_tag_get_mapping_reverse (const gchar * xmp_tag, XmpTag ** _xmp_tag)
{
  GHashTableIter iter;
  gpointer key, value;
  const gchar *ret = NULL;

  /* Iterate over the hashtable */
  g_hash_table_iter_init (&iter, __xmp_schemas);
  while (!ret && g_hash_table_iter_next (&iter, &key, &value)) {
    ret = _gst_xmp_schema_get_mapping_reverse ((GstXmpSchema *) value, xmp_tag,
        _xmp_tag);
  }
  return ret;
}

/* utility functions/macros */

#define METERS_PER_SECOND_TO_KILOMETERS_PER_HOUR (3.6)
#define KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND (1/3.6)
#define MILES_PER_HOUR_TO_METERS_PER_SECOND (0.44704)
#define KNOTS_TO_METERS_PER_SECOND (0.514444)

static gchar *
double_to_fraction_string (gdouble num)
{
  gint frac_n;
  gint frac_d;

  gst_util_double_to_fraction (num, &frac_n, &frac_d);
  return g_strdup_printf ("%d/%d", frac_n, frac_d);
}

/* (de)serialize functions */
static gchar *
serialize_exif_gps_coordinate (const GValue * value, gchar pos, gchar neg)
{
  gdouble num;
  gchar c;
  gint integer;
  gchar fraction[G_ASCII_DTOSTR_BUF_SIZE];

  g_return_val_if_fail (G_VALUE_TYPE (value) == G_TYPE_DOUBLE, NULL);

  num = g_value_get_double (value);
  if (num < 0) {
    c = neg;
    num *= -1;
  } else {
    c = pos;
  }
  integer = (gint) num;

  g_ascii_dtostr (fraction, sizeof (fraction), (num - integer) * 60);

  /* FIXME review GPSCoordinate serialization spec for the .mm or ,ss
   * decision. Couldn't understand it clearly */
  return g_strdup_printf ("%d,%s%c", integer, fraction, c);
}

static gchar *
serialize_exif_latitude (const GValue * value)
{
  return serialize_exif_gps_coordinate (value, 'N', 'S');
}

static gchar *
serialize_exif_longitude (const GValue * value)
{
  return serialize_exif_gps_coordinate (value, 'E', 'W');
}

static void
deserialize_exif_gps_coordinate (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * str, gchar pos, gchar neg)
{
  gdouble value = 0;
  gint d = 0, m = 0, s = 0;
  gdouble m2 = 0;
  gchar c = 0;
  const gchar *current;

  /* get the degrees */
  if (sscanf (str, "%d", &d) != 1)
    goto error;

  /* find the beginning of the minutes */
  current = strchr (str, ',');
  if (current == NULL)
    goto end;
  current += 1;

  /* check if it uses ,SS or .mm */
  if (strchr (current, ',') != NULL) {
    sscanf (current, "%d,%d%c", &m, &s, &c);
  } else {
    gchar *copy = g_strdup (current);
    gint len = strlen (copy);
    gint i;

    /* check the last letter */
    for (i = len - 1; len >= 0; len--) {
      if (g_ascii_isspace (copy[i]))
        continue;

      if (g_ascii_isalpha (copy[i])) {
        /* found it */
        c = copy[i];
        copy[i] = '\0';
        break;

      } else {
        /* something is wrong */
        g_free (copy);
        goto error;
      }
    }

    /* use a copy so we can change the last letter as E can cause
     * problems here */
    m2 = g_ascii_strtod (copy, NULL);
    g_free (copy);
  }

end:
  /* we can add them all as those that aren't parsed are 0 */
  value = d + (m / 60.0) + (s / (60.0 * 60.0)) + (m2 / 60.0);

  if (c == pos) {
    //NOP
  } else if (c == neg) {
    value *= -1;
  } else {
    goto error;
  }

  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag), gst_tag, value,
      NULL);
  return;

error:
  GST_WARNING ("Failed to deserialize gps coordinate: %s", str);
}

static void
deserialize_exif_latitude (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  deserialize_exif_gps_coordinate (xmptag, taglist, gst_tag, str, 'N', 'S');
}

static void
deserialize_exif_longitude (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  deserialize_exif_gps_coordinate (xmptag, taglist, gst_tag, str, 'E', 'W');
}

static gchar *
serialize_exif_altitude (const GValue * value)
{
  gdouble num;

  num = g_value_get_double (value);

  if (num < 0)
    num *= -1;

  return double_to_fraction_string (num);
}

static gchar *
serialize_exif_altituderef (const GValue * value)
{
  gdouble num;

  num = g_value_get_double (value);

  /* 0 means above sea level, 1 means below */
  if (num >= 0)
    return g_strdup ("0");
  return g_strdup ("1");
}

static void
deserialize_exif_altitude (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  const gchar *altitude_str = NULL;
  const gchar *altituderef_str = NULL;
  gint frac_n;
  gint frac_d;
  gdouble value;

  GSList *entry;
  PendingXmpTag *ptag = NULL;

  /* find the other missing part */
  if (strcmp (xmp_tag, "exif:GPSAltitude") == 0) {
    altitude_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, "exif:GPSAltitudeRef") == 0) {
        altituderef_str = ptag->str;
        break;
      }
    }

  } else if (strcmp (xmp_tag, "exif:GPSAltitudeRef") == 0) {
    altituderef_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, "exif:GPSAltitude") == 0) {
        altitude_str = ptag->str;
        break;
      }
    }

  } else {
    GST_WARNING ("Unexpected xmp tag %s", xmp_tag);
    return;
  }

  if (!altitude_str) {
    GST_WARNING ("Missing exif:GPSAltitude tag");
    return;
  }
  if (!altituderef_str) {
    GST_WARNING ("Missing exif:GPSAltitudeRef tag");
    return;
  }

  if (sscanf (altitude_str, "%d/%d", &frac_n, &frac_d) != 2) {
    GST_WARNING ("Failed to parse fraction: %s", altitude_str);
    return;
  }

  gst_util_fraction_to_double (frac_n, frac_d, &value);

  if (altituderef_str[0] == '0') {
    /* nop */
  } else if (altituderef_str[0] == '1') {
    value *= -1;
  } else {
    GST_WARNING ("Unexpected exif:AltitudeRef value: %s", altituderef_str);
    return;
  }

  /* add to the taglist */
  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag),
      GST_TAG_GEO_LOCATION_ELEVATION, value, NULL);

  /* clean up entry */
  g_free (ptag->str);
  g_slice_free (PendingXmpTag, ptag);
  *pending_tags = g_slist_delete_link (*pending_tags, entry);
}

static gchar *
serialize_exif_gps_speed (const GValue * value)
{
  return double_to_fraction_string (g_value_get_double (value) *
      METERS_PER_SECOND_TO_KILOMETERS_PER_HOUR);
}

static gchar *
serialize_exif_gps_speedref (const GValue * value)
{
  /* we always use km/h */
  return g_strdup ("K");
}

static void
deserialize_exif_gps_speed (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  const gchar *speed_str = NULL;
  const gchar *speedref_str = NULL;
  gint frac_n;
  gint frac_d;
  gdouble value;

  GSList *entry;
  PendingXmpTag *ptag = NULL;

  /* find the other missing part */
  if (strcmp (xmp_tag, "exif:GPSSpeed") == 0) {
    speed_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, "exif:GPSSpeedRef") == 0) {
        speedref_str = ptag->str;
        break;
      }
    }

  } else if (strcmp (xmp_tag, "exif:GPSSpeedRef") == 0) {
    speedref_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, "exif:GPSSpeed") == 0) {
        speed_str = ptag->str;
        break;
      }
    }

  } else {
    GST_WARNING ("Unexpected xmp tag %s", xmp_tag);
    return;
  }

  if (!speed_str) {
    GST_WARNING ("Missing exif:GPSSpeed tag");
    return;
  }
  if (!speedref_str) {
    GST_WARNING ("Missing exif:GPSSpeedRef tag");
    return;
  }

  if (sscanf (speed_str, "%d/%d", &frac_n, &frac_d) != 2) {
    GST_WARNING ("Failed to parse fraction: %s", speed_str);
    return;
  }

  gst_util_fraction_to_double (frac_n, frac_d, &value);

  if (speedref_str[0] == 'K') {
    value *= KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND;
  } else if (speedref_str[0] == 'M') {
    value *= MILES_PER_HOUR_TO_METERS_PER_SECOND;
  } else if (speedref_str[0] == 'N') {
    value *= KNOTS_TO_METERS_PER_SECOND;
  } else {
    GST_WARNING ("Unexpected exif:SpeedRef value: %s", speedref_str);
    return;
  }

  /* add to the taglist */
  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag),
      GST_TAG_GEO_LOCATION_MOVEMENT_SPEED, value, NULL);

  /* clean up entry */
  g_free (ptag->str);
  g_slice_free (PendingXmpTag, ptag);
  *pending_tags = g_slist_delete_link (*pending_tags, entry);
}

static gchar *
serialize_exif_gps_direction (const GValue * value)
{
  return double_to_fraction_string (g_value_get_double (value));
}

static gchar *
serialize_exif_gps_directionref (const GValue * value)
{
  /* T for true geographic direction (M would mean magnetic) */
  return g_strdup ("T");
}

static void
deserialize_exif_gps_direction (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags, const gchar * direction_tag,
    const gchar * directionref_tag)
{
  const gchar *dir_str = NULL;
  const gchar *dirref_str = NULL;
  gint frac_n;
  gint frac_d;
  gdouble value;

  GSList *entry;
  PendingXmpTag *ptag = NULL;

  /* find the other missing part */
  if (strcmp (xmp_tag, direction_tag) == 0) {
    dir_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, directionref_tag) == 0) {
        dirref_str = ptag->str;
        break;
      }
    }

  } else if (strcmp (xmp_tag, directionref_tag) == 0) {
    dirref_str = str;

    for (entry = *pending_tags; entry; entry = g_slist_next (entry)) {
      ptag = (PendingXmpTag *) entry->data;

      if (strcmp (ptag->xmp_tag->tag_name, direction_tag) == 0) {
        dir_str = ptag->str;
        break;
      }
    }

  } else {
    GST_WARNING ("Unexpected xmp tag %s", xmp_tag);
    return;
  }

  if (!dir_str) {
    GST_WARNING ("Missing %s tag", dir_str);
    return;
  }
  if (!dirref_str) {
    GST_WARNING ("Missing %s tag", dirref_str);
    return;
  }

  if (sscanf (dir_str, "%d/%d", &frac_n, &frac_d) != 2) {
    GST_WARNING ("Failed to parse fraction: %s", dir_str);
    return;
  }

  gst_util_fraction_to_double (frac_n, frac_d, &value);

  if (dirref_str[0] == 'T') {
    /* nop */
  } else if (dirref_str[0] == 'M') {
    GST_WARNING ("Magnetic direction tags aren't supported yet");
    return;
  } else {
    GST_WARNING ("Unexpected %s value: %s", directionref_tag, dirref_str);
    return;
  }

  /* add to the taglist */
  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag), gst_tag, value,
      NULL);

  /* clean up entry */
  g_free (ptag->str);
  g_slice_free (PendingXmpTag, ptag);
  *pending_tags = g_slist_delete_link (*pending_tags, entry);
}

static void
deserialize_exif_gps_track (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  deserialize_exif_gps_direction (xmptag, taglist, gst_tag, xmp_tag, str,
      pending_tags, "exif:GPSTrack", "exif:GPSTrackRef");
}

static void
deserialize_exif_gps_img_direction (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  deserialize_exif_gps_direction (xmptag, taglist, gst_tag, xmp_tag, str,
      pending_tags, "exif:GPSImgDirection", "exif:GPSImgDirectionRef");
}

static void
deserialize_xmp_rating (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  guint value;

  if (sscanf (str, "%u", &value) != 1) {
    GST_WARNING ("Failed to parse xmp:Rating %s", str);
    return;
  }

  if (value > 100) {
    GST_WARNING ("Unsupported Rating tag %u (should be from 0 to 100), "
        "ignoring", value);
    return;
  }

  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag), gst_tag, value,
      NULL);
}

static gchar *
serialize_tiff_orientation (const GValue * value)
{
  const gchar *str;
  gint num;

  str = g_value_get_string (value);
  if (str == NULL) {
    GST_WARNING ("Failed to get image orientation tag value");
    return NULL;
  }

  num = __exif_tag_image_orientation_to_exif_value (str);
  if (num == -1)
    return NULL;

  return g_strdup_printf ("%d", num);
}

static void
deserialize_tiff_orientation (XmpTag * xmptag, GstTagList * taglist,
    const gchar * gst_tag, const gchar * xmp_tag, const gchar * str,
    GSList ** pending_tags)
{
  guint value;
  const gchar *orientation = NULL;

  if (sscanf (str, "%u", &value) != 1) {
    GST_WARNING ("Failed to parse tiff:Orientation %s", str);
    return;
  }

  if (value < 1 || value > 8) {
    GST_WARNING ("Invalid tiff:Orientation tag %u (should be from 1 to 8), "
        "ignoring", value);
    return;
  }

  orientation = __exif_tag_image_orientation_from_exif_value (value);
  if (orientation == NULL)
    return;
  gst_tag_list_add (taglist, xmp_tag_get_merge_mode (xmptag), gst_tag,
      orientation, NULL);
}


/* look at this page for addtional schemas
 * http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.html
 */
static gpointer
_init_xmp_tag_map (gpointer user_data)
{
  XmpTag *xmpinfo;
  GstXmpSchema *schema;

  __xmp_schemas = g_hash_table_new (g_direct_hash, g_direct_equal);

  /* add the maps */
  /* dublic code metadata
   * http://dublincore.org/documents/dces/
   */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_ARTIST,
      "dc:creator", GstXmpTagTypeSeq, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_COPYRIGHT,
      "dc:rights", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_DATE_TIME, "dc:date",
      GstXmpTagTypeSeq, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_DESCRIPTION,
      "dc:description", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_KEYWORDS,
      "dc:subject", GstXmpTagTypeBag, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_TITLE, "dc:title",
      GstXmpTagTypeSimple, NULL, NULL);
  /* FIXME: we probably want GST_TAG_{,AUDIO_,VIDEO_}MIME_TYPE */
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_VIDEO_CODEC,
      "dc:format", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_add_schema ("dc", schema);

  /* xap (xmp) schema */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_USER_RATING,
      "xmp:Rating", GstXmpTagTypeSimple, NULL, deserialize_xmp_rating);
  _gst_xmp_add_schema ("xap", schema);

  /* tiff */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema,
      GST_TAG_DEVICE_MANUFACTURER, "tiff:Make", GstXmpTagTypeSimple, NULL,
      NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_DEVICE_MODEL,
      "tiff:Model", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_APPLICATION_NAME,
      "tiff:Software", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_IMAGE_ORIENTATION,
      "tiff:Orientation", GstXmpTagTypeSimple, serialize_tiff_orientation,
      deserialize_tiff_orientation);
  _gst_xmp_add_schema ("tiff", schema);

  /* exif schema */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_DATE_TIME,
      "exif:DateTimeOriginal", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema,
      GST_TAG_GEO_LOCATION_LATITUDE, "exif:GPSLatitude",
      GstXmpTagTypeSimple, serialize_exif_latitude, deserialize_exif_latitude);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_GEO_LOCATION_LONGITUDE,
      "exif:GPSLongitude", GstXmpTagTypeSimple, serialize_exif_longitude,
      deserialize_exif_longitude);
  _gst_xmp_schema_add_simple_mapping (schema,
      GST_TAG_CAPTURING_EXPOSURE_COMPENSATION, "exif:ExposureBiasValue",
      GstXmpTagTypeSimple, NULL, NULL);

  /* compound exif tags */
  xmpinfo = gst_xmp_tag_create_compound (GST_TAG_GEO_LOCATION_ELEVATION,
      "exif:GPSAltitude", "exif:GPSAltitudeRef", serialize_exif_altitude,
      serialize_exif_altituderef, deserialize_exif_altitude);
  _gst_xmp_schema_add_mapping (schema, xmpinfo);

  xmpinfo = gst_xmp_tag_create_compound (GST_TAG_GEO_LOCATION_MOVEMENT_SPEED,
      "exif:GPSSpeed", "exif:GPSSpeedRef", serialize_exif_gps_speed,
      serialize_exif_gps_speedref, deserialize_exif_gps_speed);
  _gst_xmp_schema_add_mapping (schema, xmpinfo);

  xmpinfo =
      gst_xmp_tag_create_compound (GST_TAG_GEO_LOCATION_MOVEMENT_DIRECTION,
      "exif:GPSTrack", "exif:GPSTrackRef", serialize_exif_gps_direction,
      serialize_exif_gps_directionref, deserialize_exif_gps_track);
  _gst_xmp_schema_add_mapping (schema, xmpinfo);

  xmpinfo = gst_xmp_tag_create_compound (GST_TAG_GEO_LOCATION_CAPTURE_DIRECTION,
      "exif:GPSImgDirection", "exif:GPSImgDirectionRef",
      serialize_exif_gps_direction, serialize_exif_gps_directionref,
      deserialize_exif_gps_img_direction);
  _gst_xmp_schema_add_mapping (schema, xmpinfo);

  _gst_xmp_add_schema ("exif", schema);

  /* photoshop schema */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema,
      GST_TAG_GEO_LOCATION_COUNTRY, "photoshop:Country",
      GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_schema_add_simple_mapping (schema, GST_TAG_GEO_LOCATION_CITY,
      "photoshop:City", GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_add_schema ("photoshop", schema);

  /* iptc4xmpcore schema */
  schema = gst_xmp_schema_new ();
  _gst_xmp_schema_add_simple_mapping (schema,
      GST_TAG_GEO_LOCATION_SUBLOCATION, "Iptc4xmpCore:Location",
      GstXmpTagTypeSimple, NULL, NULL);
  _gst_xmp_add_schema ("Iptc4xmpCore", schema);

  /* iptc4xmpext schema */
  schema = gst_xmp_schema_new ();
  xmpinfo = gst_xmp_tag_create (NULL, "Iptc4xmpExt:LocationShown",
      GstXmpTagTypeStruct, NULL, NULL);
  xmpinfo->supertype = GstXmpTagTypeBag;
  xmpinfo->parse_type = "Resource";
  xmpinfo->children = g_slist_prepend (xmpinfo->children,
      gst_xmp_tag_create (GST_TAG_GEO_LOCATION_SUBLOCATION,
          "LocationDetails:Sublocation", GstXmpTagTypeSimple, NULL, NULL));
  xmpinfo->children =
      g_slist_prepend (xmpinfo->children,
      gst_xmp_tag_create (GST_TAG_GEO_LOCATION_CITY,
          "LocationDetails:City", GstXmpTagTypeSimple, NULL, NULL));
  xmpinfo->children =
      g_slist_prepend (xmpinfo->children,
      gst_xmp_tag_create (GST_TAG_GEO_LOCATION_COUNTRY,
          "LocationDetails:Country", GstXmpTagTypeSimple, NULL, NULL));
  _gst_xmp_schema_add_mapping (schema, xmpinfo);
  _gst_xmp_add_schema ("Iptc4xmpExt", schema);

  return NULL;
}

static void
xmp_tags_initialize ()
{
  static GOnce my_once = G_ONCE_INIT;
  g_once (&my_once, (GThreadFunc) _init_xmp_tag_map, NULL);
}

typedef struct _GstXmpNamespaceMatch GstXmpNamespaceMatch;
struct _GstXmpNamespaceMatch
{
  const gchar *ns_prefix;
  const gchar *ns_uri;

  /*
   * Stores extra namespaces for array tags
   * The namespaces should be writen in the form:
   *
   * xmlns:XpTo="http://some.org/your/ns/name/ (next ones)"
   */
  const gchar *extra_ns;
};

static const GstXmpNamespaceMatch ns_match[] = {
  {"dc", "http://purl.org/dc/elements/1.1/", NULL},
  {"exif", "http://ns.adobe.com/exif/1.0/", NULL},
  {"tiff", "http://ns.adobe.com/tiff/1.0/", NULL},
  {"xap", "http://ns.adobe.com/xap/1.0/", NULL},
  {"photoshop", "http://ns.adobe.com/photoshop/1.0/", NULL},
  {"Iptc4xmpCore", "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/", NULL},
  {"Iptc4xmpExt", "http://iptc.org/std/Iptc4xmpExt/2008-02-29/",
      "xmlns:LocationDetails=\"http://iptc.org/std/Iptc4xmpExt/2008-02-29/LocationDetails/\""},
  {NULL, NULL, NULL}
};

typedef struct _GstXmpNamespaceMap GstXmpNamespaceMap;
struct _GstXmpNamespaceMap
{
  const gchar *original_ns;
  gchar *gstreamer_ns;
};

/* parsing */

static void
read_one_tag (GstTagList * list, XmpTag * xmptag,
    const gchar * v, GSList ** pending_tags)
{
  GType tag_type;
  GstTagMergeMode merge_mode;
  const gchar *tag = xmptag->gst_tag;

  g_return_if_fail (tag != NULL);

  if (xmptag->deserialize) {
    xmptag->deserialize (xmptag, list, tag, xmptag->tag_name, v, pending_tags);
    return;
  }

  merge_mode = xmp_tag_get_merge_mode (xmptag);
  tag_type = gst_tag_get_type (tag);

  /* add gstreamer tag depending on type */
  switch (tag_type) {
    case G_TYPE_STRING:{
      gst_tag_list_add (list, merge_mode, tag, v, NULL);
      break;
    }
    case G_TYPE_DOUBLE:{
      gdouble value = 0;
      gint frac_n, frac_d;

      if (sscanf (v, "%d/%d", &frac_n, &frac_d) == 2) {
        gst_util_fraction_to_double (frac_n, frac_d, &value);
        gst_tag_list_add (list, merge_mode, tag, value, NULL);
      } else {
        GST_WARNING ("Failed to parse fraction: %s", v);
      }
      break;
    }
    default:
      if (tag_type == GST_TYPE_DATE_TIME) {
        GstDateTime *datetime;

        if (v == NULL || *v == '\0') {
          GST_WARNING ("Empty string for datetime parsing");
          return;
        }

        GST_DEBUG ("Parsing %s into a datetime", v);
        datetime = gst_date_time_new_from_iso8601_string (v);
        if (datetime) {
          gst_tag_list_add (list, merge_mode, tag, datetime, NULL);
          gst_date_time_unref (datetime);
        }

      } else if (tag_type == G_TYPE_DATE) {
        GST_ERROR ("Use GST_TYPE_DATE_TIME in tags instead of G_TYPE_DATE");
      } else {
        GST_WARNING ("unhandled type for %s from xmp", tag);
      }
      break;
  }
}

/**
 * gst_tag_list_from_xmp_buffer:
 * @buffer: buffer
 *
 * Parse a xmp packet into a taglist.
 *
 * Returns: new taglist or %NULL, free the list when done
 */
GstTagList *
gst_tag_list_from_xmp_buffer (GstBuffer * buffer)
{
  GstTagList *list = NULL;
  GstMapInfo info;
  gchar *xps, *xp1, *xp2, *xpe, *ns, *ne;
  gsize len, max_ft_len;
  gboolean in_tag;
  gchar *part = NULL, *pp;
  guint i;
  XmpTag *last_xmp_tag = NULL;
  GSList *pending_tags = NULL;

  /* Used for strucuture xmp tags */
  XmpTag *context_tag = NULL;

  GstXmpNamespaceMap ns_map[] = {
    {"dc", NULL}
    ,
    {"exif", NULL}
    ,
    {"tiff", NULL}
    ,
    {"xap", NULL}
    ,
    {"photoshop", NULL}
    ,
    {"Iptc4xmpCore", NULL}
    ,
    {"Iptc4xmpExt", NULL}
    ,
    {NULL, NULL}
  };

  xmp_tags_initialize ();

  g_return_val_if_fail (GST_IS_BUFFER (buffer), NULL);

  GST_LOG ("Starting xmp parsing");

  gst_buffer_map (buffer, &info, GST_MAP_READ);
  xps = (gchar *) info.data;
  len = info.size;
  g_return_val_if_fail (len > 0, NULL);

  xpe = &xps[len + 1];

  /* check header and footer */
  xp1 = g_strstr_len (xps, len, "<?xpacket begin");
  if (!xp1)
    goto missing_header;
  xp1 = &xp1[strlen ("<?xpacket begin")];
  while (*xp1 != '>' && *xp1 != '<' && xp1 < xpe)
    xp1++;
  if (*xp1 != '>')
    goto missing_header;

  /* Use 2 here to count for an extra trailing \n that was added
   * in old versions, this makes it able to parse xmp packets with
   * and without this trailing char */
  max_ft_len = 2 + strlen ("<?xpacket end=\".\"?>");
  if (len < max_ft_len)
    goto missing_footer;

  GST_DEBUG ("checking footer: [%s]", &xps[len - max_ft_len]);
  xp2 = g_strstr_len (&xps[len - max_ft_len], max_ft_len, "<?xpacket ");
  if (!xp2)
    goto missing_footer;

  GST_INFO ("xmp header okay");

  /* skip > and text until first xml-node */
  xp1++;
  while (*xp1 != '<' && xp1 < xpe)
    xp1++;

  /* no tag can be longer than the whole buffer */
  part = g_malloc (xp2 - xp1);
  list = gst_tag_list_new_empty ();

  /* parse data into a list of nodes */
  /* data is between xp1..xp2 */
  in_tag = TRUE;
  ns = ne = xp1;
  pp = part;
  while (ne < xp2) {
    if (in_tag) {
      ne++;
      while (ne < xp2 && *ne != '>' && *ne != '<') {
        if (*ne == '\n' || *ne == '\t' || *ne == ' ') {
          while (ne < xp2 && (*ne == '\n' || *ne == '\t' || *ne == ' '))
            ne++;
          *pp++ = ' ';
        } else {
          *pp++ = *ne++;
        }
      }
      *pp = '\0';
      if (*ne != '>')
        goto broken_xml;
      /* create node */
      /* {XML, ns, ne-ns} */
      if (ns[0] != '/') {
        gchar *as = strchr (part, ' ');
        /* only log start nodes */
        GST_INFO ("xml: %s", part);

        if (as) {
          gchar *ae, *d;

          /* skip ' ' and scan the attributes */
          as++;
          d = ae = as;

          /* split attr=value pairs */
          while (*ae != '\0') {
            if (*ae == '=') {
              /* attr/value delimmiter */
              d = ae;
            } else if (*ae == '"') {
              /* scan values */
              gchar *v;

              ae++;
              while (*ae != '\0' && *ae != '"')
                ae++;

              *d = *ae = '\0';
              v = &d[2];
              GST_INFO ("   : [%s][%s]", as, v);
              if (!strncmp (as, "xmlns:", 6)) {
                i = 0;
                /* we need to rewrite known namespaces to what we use in
                 * tag_matches */
                while (ns_match[i].ns_prefix) {
                  if (!strcmp (ns_match[i].ns_uri, v))
                    break;
                  i++;
                }
                if (ns_match[i].ns_prefix) {
                  if (strcmp (ns_map[i].original_ns, &as[6])) {
                    ns_map[i].gstreamer_ns = g_strdup (&as[6]);
                  }
                }
              } else {
                XmpTag *xmp_tag = NULL;
                /* FIXME: eventually rewrite ns
                 * find ':'
                 * check if ns before ':' is in ns_map and ns_map[i].gstreamer_ns!=NULL
                 * do 2 stage filter in tag_matches
                 */
                if (context_tag) {
                  GSList *iter;

                  for (iter = context_tag->children; iter;
                      iter = g_slist_next (iter)) {
                    XmpTag *child = iter->data;

                    GST_DEBUG ("Looking at child tag %s : %s", child->tag_name,
                        as);
                    if (strcmp (child->tag_name, as) == 0) {
                      xmp_tag = child;
                      break;
                    }
                  }

                } else {
                  GST_LOG ("Looking for tag: %s", as);
                  _gst_xmp_tag_get_mapping_reverse (as, &xmp_tag);
                }
                if (xmp_tag) {
                  PendingXmpTag *ptag;

                  GST_DEBUG ("Found xmp tag: %s -> %s", xmp_tag->tag_name,
                      xmp_tag->gst_tag);

                  /* we shouldn't find a xmp structure here */
                  g_assert (xmp_tag->gst_tag != NULL);

                  ptag = g_slice_new (PendingXmpTag);
                  ptag->xmp_tag = xmp_tag;
                  ptag->str = g_strdup (v);

                  pending_tags = g_slist_prepend (pending_tags, ptag);
                }
              }
              /* restore chars overwritten by '\0' */
              *d = '=';
              *ae = '"';
            } else if (*ae == '\0' || *ae == ' ') {
              /* end of attr/value pair */
              as = &ae[1];
            }
            /* to next char if not eos */
            if (*ae != '\0')
              ae++;
          }
        } else {
          /*
             <dc:type><rdf:Bag><rdf:li>Image</rdf:li></rdf:Bag></dc:type>
             <dc:creator><rdf:Seq><rdf:li/></rdf:Seq></dc:creator>
           */
          /* FIXME: eventually rewrite ns */

          /* skip rdf tags for now */
          if (strncmp (part, "rdf:", 4)) {
            /* if we're inside some struct, we look only on its children */
            if (context_tag) {
              GSList *iter;

              /* check if this is the closing of the context */
              if (part[0] == '/'
                  && strcmp (part + 1, context_tag->tag_name) == 0) {
                GST_DEBUG ("Closing context tag %s", part);
                context_tag = NULL;
              } else {

                for (iter = context_tag->children; iter;
                    iter = g_slist_next (iter)) {
                  XmpTag *child = iter->data;

                  GST_DEBUG ("Looking at child tag %s : %s", child->tag_name,
                      part);
                  if (strcmp (child->tag_name, part) == 0) {
                    last_xmp_tag = child;
                    break;
                  }
                }
              }

            } else {
              GST_LOG ("Looking for tag: %s", part);
              _gst_xmp_tag_get_mapping_reverse (part, &last_xmp_tag);
              if (last_xmp_tag && last_xmp_tag->type == GstXmpTagTypeStruct) {
                context_tag = last_xmp_tag;
                last_xmp_tag = NULL;
              }
            }
          }
        }
      }
      GST_LOG ("Next cycle");
      /* next cycle */
      ne++;
      if (ne < xp2) {
        if (*ne != '<')
          in_tag = FALSE;
        ns = ne;
        pp = part;
      }
    } else {
      while (ne < xp2 && *ne != '<') {
        *pp++ = *ne;
        ne++;
      }
      *pp = '\0';
      /* create node */
      /* {TXT, ns, (ne-ns)-1} */
      if (ns[0] != '\n' && &ns[1] <= ne) {
        /* only log non-newline nodes, we still have to parse them */
        GST_INFO ("txt: %s", part);
        if (last_xmp_tag) {
          PendingXmpTag *ptag;

          GST_DEBUG ("Found tag %s -> %s", last_xmp_tag->tag_name,
              last_xmp_tag->gst_tag);

          if (last_xmp_tag->type == GstXmpTagTypeStruct) {
            g_assert (context_tag == NULL);     /* we can't handle struct nesting currently */

            context_tag = last_xmp_tag;
          } else {
            ptag = g_slice_new (PendingXmpTag);
            ptag->xmp_tag = last_xmp_tag;
            ptag->str = g_strdup (part);

            pending_tags = g_slist_prepend (pending_tags, ptag);
          }
        }
      }
      /* next cycle */
      in_tag = TRUE;
      ns = ne;
      pp = part;
    }
  }

  pending_tags = g_slist_reverse (pending_tags);

  GST_DEBUG ("Done accumulating tags, now handling them");

  while (pending_tags) {
    PendingXmpTag *ptag = (PendingXmpTag *) pending_tags->data;

    pending_tags = g_slist_delete_link (pending_tags, pending_tags);

    read_one_tag (list, ptag->xmp_tag, ptag->str, &pending_tags);

    g_free (ptag->str);
    g_slice_free (PendingXmpTag, ptag);
  }

  GST_INFO ("xmp packet parsed, %d entries", gst_tag_list_n_tags (list));

out:

  /* free resources */
  i = 0;
  while (ns_map[i].original_ns) {
    g_free (ns_map[i].gstreamer_ns);
    i++;
  }

  g_free (part);

  gst_buffer_unmap (buffer, &info);

  return list;

  /* Errors */
missing_header:
  GST_WARNING ("malformed xmp packet header");
  goto out;
missing_footer:
  GST_WARNING ("malformed xmp packet footer");
  goto out;
broken_xml:
  GST_WARNING ("malformed xml tag: %s", part);
  gst_tag_list_unref (list);
  list = NULL;
  goto out;
}


/* formatting */

static void
string_open_tag (GString * string, const char *tag)
{
  g_string_append_c (string, '<');
  g_string_append (string, tag);
  g_string_append_c (string, '>');
}

static void
string_close_tag (GString * string, const char *tag)
{
  g_string_append (string, "</");
  g_string_append (string, tag);
  g_string_append (string, ">\n");
}

static char *
gst_value_serialize_xmp (const GValue * value)
{
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_STRING:
      return g_markup_escape_text (g_value_get_string (value), -1);
    case G_TYPE_INT:
      return g_strdup_printf ("%d", g_value_get_int (value));
    case G_TYPE_UINT:
      return g_strdup_printf ("%u", g_value_get_uint (value));
    case G_TYPE_DOUBLE:
      return double_to_fraction_string (g_value_get_double (value));
    default:
      break;
  }
  /* put non-switchable types here */
  if (G_VALUE_TYPE (value) == G_TYPE_DATE) {
    const GDate *date = g_value_get_boxed (value);

    return g_strdup_printf ("%04d-%02d-%02d",
        (gint) g_date_get_year (date), (gint) g_date_get_month (date),
        (gint) g_date_get_day (date));
  } else if (G_VALUE_TYPE (value) == GST_TYPE_DATE_TIME) {
    gint year, month, day, hour, min, sec, microsec;
    gfloat gmt_offset = 0;
    gint gmt_offset_hour, gmt_offset_min;
    GstDateTime *datetime = (GstDateTime *) g_value_get_boxed (value);

    if (!gst_date_time_has_time (datetime))
      return gst_date_time_to_iso8601_string (datetime);

    /* can't just use gst_date_time_to_iso8601_string() here because we need
     * the timezone info with a colon, i.e. as +03:00 instead of +0300 */
    year = gst_date_time_get_year (datetime);
    month = gst_date_time_get_month (datetime);
    day = gst_date_time_get_day (datetime);
    hour = gst_date_time_get_hour (datetime);
    min = gst_date_time_get_minute (datetime);
    sec = gst_date_time_get_second (datetime);
    microsec = gst_date_time_get_microsecond (datetime);
    gmt_offset = gst_date_time_get_time_zone_offset (datetime);
    if (gmt_offset == 0) {
      /* UTC */
      return g_strdup_printf ("%04d-%02d-%02dT%02d:%02d:%02d.%06dZ",
          year, month, day, hour, min, sec, microsec);
    } else {
      gmt_offset_hour = ABS (gmt_offset);
      gmt_offset_min = (ABS (gmt_offset) - gmt_offset_hour) * 60;

      return g_strdup_printf ("%04d-%02d-%02dT%02d:%02d:%02d.%06d%c%02d:%02d",
          year, month, day, hour, min, sec, microsec,
          gmt_offset >= 0 ? '+' : '-', gmt_offset_hour, gmt_offset_min);
    }
  } else {
    return NULL;
  }
}

static void
write_one_tag (const GstTagList * list, XmpTag * xmp_tag, gpointer user_data)
{
  guint i = 0, ct;
  XmpSerializationData *serialization_data = user_data;
  GString *data = serialization_data->data;
  char *s;

  /* struct type handled differently */
  if (xmp_tag->type == GstXmpTagTypeStruct ||
      xmp_tag->type == GstXmpTagTypeCompound) {
    GSList *iter;
    gboolean use_it = FALSE;

    /* check if any of the inner tags are present on the taglist */
    for (iter = xmp_tag->children; iter && !use_it; iter = g_slist_next (iter)) {
      XmpTag *child_tag = iter->data;

      if (gst_tag_list_get_value_index (list, child_tag->gst_tag, 0) != NULL) {
        use_it = TRUE;
        break;
      }
    }

    if (use_it) {
      if (xmp_tag->tag_name)
        string_open_tag (data, xmp_tag->tag_name);

      if (xmp_tag->supertype) {
        string_open_tag (data, xmp_tag_type_get_name (xmp_tag->supertype));
        if (xmp_tag->parse_type) {
          g_string_append (data, "<rdf:li rdf:parseType=\"");
          g_string_append (data, xmp_tag->parse_type);
          g_string_append_c (data, '"');
          g_string_append_c (data, '>');
        } else {
          string_open_tag (data, "rdf:li");
        }
      }

      /* now write it */
      for (iter = xmp_tag->children; iter; iter = g_slist_next (iter)) {
        write_one_tag (list, iter->data, user_data);
      }

      if (xmp_tag->supertype) {
        string_close_tag (data, "rdf:li");
        string_close_tag (data, xmp_tag_type_get_name (xmp_tag->supertype));
      }

      if (xmp_tag->tag_name)
        string_close_tag (data, xmp_tag->tag_name);
    }
    return;
  }

  /* at this point we must have a gst_tag */
  g_assert (xmp_tag->gst_tag);
  if (gst_tag_list_get_value_index (list, xmp_tag->gst_tag, 0) == NULL)
    return;

  ct = gst_tag_list_get_tag_size (list, xmp_tag->gst_tag);
  string_open_tag (data, xmp_tag->tag_name);

  /* fast path for single valued tag */
  if (ct == 1 || xmp_tag->type == GstXmpTagTypeSimple) {
    if (xmp_tag->serialize) {
      s = xmp_tag->serialize (gst_tag_list_get_value_index (list,
              xmp_tag->gst_tag, 0));
    } else {
      s = gst_value_serialize_xmp (gst_tag_list_get_value_index (list,
              xmp_tag->gst_tag, 0));
    }
    if (s) {
      g_string_append (data, s);
      g_free (s);
    } else {
      GST_WARNING ("unhandled type for %s to xmp", xmp_tag->gst_tag);
    }
  } else {
    const gchar *typename;

    typename = xmp_tag_type_get_name (xmp_tag->type);

    string_open_tag (data, typename);
    for (i = 0; i < ct; i++) {
      GST_DEBUG ("mapping %s[%u/%u] to xmp", xmp_tag->gst_tag, i, ct);
      if (xmp_tag->serialize) {
        s = xmp_tag->serialize (gst_tag_list_get_value_index (list,
                xmp_tag->gst_tag, i));
      } else {
        s = gst_value_serialize_xmp (gst_tag_list_get_value_index (list,
                xmp_tag->gst_tag, i));
      }
      if (s) {
        string_open_tag (data, "rdf:li");
        g_string_append (data, s);
        string_close_tag (data, "rdf:li");
        g_free (s);
      } else {
        GST_WARNING ("unhandled type for %s to xmp", xmp_tag->gst_tag);
      }
    }
    string_close_tag (data, typename);
  }

  string_close_tag (data, xmp_tag->tag_name);
}

/**
 * gst_tag_list_to_xmp_buffer:
 * @list: tags
 * @read_only: does the container forbid inplace editing
 * @schemas: %NULL terminated array of schemas to be used on serialization
 *
 * Formats a taglist as a xmp packet using only the selected
 * schemas. An empty list (%NULL) means that all schemas should
 * be used
 *
 * Returns: new buffer or %NULL, unref the buffer when done
 */
GstBuffer *
gst_tag_list_to_xmp_buffer (const GstTagList * list, gboolean read_only,
    const gchar ** schemas)
{
  GstBuffer *buffer = NULL;
  XmpSerializationData serialization_data;
  GString *data;
  guint i;
  gsize bsize;
  gpointer bdata;

  serialization_data.data = g_string_sized_new (4096);
  serialization_data.schemas = schemas;
  data = serialization_data.data;

  xmp_tags_initialize ();

  g_return_val_if_fail (GST_IS_TAG_LIST (list), NULL);

  /* xmp header */
  g_string_append (data,
      "<?xpacket begin=\"\xEF\xBB\xBF\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>\n");
  g_string_append (data,
      "<x:xmpmeta xmlns:x=\"adobe:ns:meta/\" x:xmptk=\"GStreamer\">\n");
  g_string_append (data,
      "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"");
  i = 0;
  while (ns_match[i].ns_prefix) {
    if (xmp_serialization_data_use_schema (&serialization_data,
            ns_match[i].ns_prefix)) {
      g_string_append_printf (data, " xmlns:%s=\"%s\"",
          ns_match[i].ns_prefix, ns_match[i].ns_uri);
      if (ns_match[i].extra_ns) {
        g_string_append_printf (data, " %s", ns_match[i].extra_ns);
      }
    }
    i++;
  }
  g_string_append (data, ">\n");
  g_string_append (data, "<rdf:Description rdf:about=\"\">\n");

  /* iterate the schemas */
  if (schemas == NULL) {
    /* use all schemas */
    schemas = gst_tag_xmp_list_schemas ();
  }
  for (i = 0; schemas[i] != NULL; i++) {
    GstXmpSchema *schema = _gst_xmp_get_schema (schemas[i]);
    GHashTableIter iter;
    gpointer key, value;

    if (schema == NULL)
      continue;

    /* Iterate over the hashtable */
    g_hash_table_iter_init (&iter, schema);
    while (g_hash_table_iter_next (&iter, &key, &value)) {
      write_one_tag (list, value, (gpointer) & serialization_data);
    }
  }

  /* xmp footer */
  g_string_append (data, "</rdf:Description>\n");
  g_string_append (data, "</rdf:RDF>\n");
  g_string_append (data, "</x:xmpmeta>\n");

  if (!read_only) {
    /* the xmp spec recommends to add 2-4KB padding for in-place editable xmp */
    guint i;

    for (i = 0; i < 32; i++) {
      g_string_append (data, "                " "                "
          "                " "                " "\n");
    }
  }
  g_string_append_printf (data, "<?xpacket end=\"%c\"?>",
      (read_only ? 'r' : 'w'));

  bsize = data->len;
  bdata = g_string_free (data, FALSE);

  buffer = gst_buffer_new_wrapped (bdata, bsize);

  return buffer;
}

#undef gst_xmp_schema_lookup
#undef gst_xmp_schema_insert
