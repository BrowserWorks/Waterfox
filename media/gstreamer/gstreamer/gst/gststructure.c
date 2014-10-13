/* GStreamer
 * Copyright (C) 2003 David A. Schleef <ds@schleef.org>
 *
 * gststructure.c: lists of { GQuark, GValue } tuples
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
 * SECTION:gststructure
 * @short_description: Generic structure containing fields of names and values
 * @see_also: #GstCaps, #GstMessage, #GstEvent, #GstQuery
 *
 * A #GstStructure is a collection of key/value pairs. The keys are expressed
 * as GQuarks and the values can be of any GType.
 *
 * In addition to the key/value pairs, a #GstStructure also has a name. The name
 * starts with a letter and can be filled by letters, numbers and any of "/-_.:".
 *
 * #GstStructure is used by various GStreamer subsystems to store information
 * in a flexible and extensible way. A #GstStructure does not have a refcount
 * because it usually is part of a higher level object such as #GstCaps,
 * #GstMessage, #GstEvent, #GstQuery. It provides a means to enforce mutability
 * using the refcount of the parent with the gst_structure_set_parent_refcount()
 * method.
 *
 * A #GstStructure can be created with gst_structure_new_empty() or
 * gst_structure_new(), which both take a name and an optional set of
 * key/value pairs along with the types of the values.
 *
 * Field values can be changed with gst_structure_set_value() or
 * gst_structure_set().
 *
 * Field values can be retrieved with gst_structure_get_value() or the more
 * convenient gst_structure_get_*() functions.
 *
 * Fields can be removed with gst_structure_remove_field() or
 * gst_structure_remove_fields().
 *
 * Strings in structures must be ASCII or UTF-8 encoded. Other encodings are
 * not allowed. Strings may be %NULL however.
 *
 * Be aware that the current #GstCaps / #GstStructure serialization into string
 * has limited support for nested #GstCaps / #GstStructure fields. It can only
 * support one level of nesting. Using more levels will lead to unexpected
 * behavior when using serialization features, such as gst_caps_to_string() or
 * gst_value_serialize() and their counterparts.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gst_private.h"
#include "gstquark.h"
#include <gst/gst.h>
#include <gobject/gvaluecollector.h>

GST_DEBUG_CATEGORY_STATIC (gst_structure_debug);
#define GST_CAT_DEFAULT gst_structure_debug

typedef struct _GstStructureField GstStructureField;

struct _GstStructureField
{
  GQuark name;
  GValue value;
};

typedef struct
{
  GstStructure s;

  /* owned by parent structure, NULL if no parent */
  gint *parent_refcount;

  GArray *fields;
} GstStructureImpl;

#define GST_STRUCTURE_REFCOUNT(s) (((GstStructureImpl*)(s))->parent_refcount)
#define GST_STRUCTURE_FIELDS(s) (((GstStructureImpl*)(s))->fields)

#define GST_STRUCTURE_FIELD(structure, index) \
    &g_array_index(GST_STRUCTURE_FIELDS(structure), GstStructureField, (index))

#define IS_MUTABLE(structure) \
    (!GST_STRUCTURE_REFCOUNT(structure) || \
     g_atomic_int_get (GST_STRUCTURE_REFCOUNT(structure)) == 1)

#define IS_TAGLIST(structure) \
    (structure->name == GST_QUARK (TAGLIST))

static void gst_structure_set_field (GstStructure * structure,
    GstStructureField * field);
static GstStructureField *gst_structure_get_field (const GstStructure *
    structure, const gchar * fieldname);
static GstStructureField *gst_structure_id_get_field (const GstStructure *
    structure, GQuark field);
static void gst_structure_transform_to_string (const GValue * src_value,
    GValue * dest_value);
static GstStructure *gst_structure_copy_conditional (const GstStructure *
    structure);
static gboolean gst_structure_parse_value (gchar * str, gchar ** after,
    GValue * value, GType default_type);
static gboolean gst_structure_parse_simple_string (gchar * s, gchar ** end);

GType _gst_structure_type = 0;


G_DEFINE_BOXED_TYPE (GstStructure, gst_structure,
    gst_structure_copy_conditional, gst_structure_free);

void
_priv_gst_structure_initialize (void)
{
  _gst_structure_type = gst_structure_get_type ();

  g_value_register_transform_func (_gst_structure_type, G_TYPE_STRING,
      gst_structure_transform_to_string);

  GST_DEBUG_CATEGORY_INIT (gst_structure_debug, "structure", 0,
      "GstStructure debug");
}

static GstStructure *
gst_structure_new_id_empty_with_size (GQuark quark, guint prealloc)
{
  GstStructureImpl *structure;

  structure = g_slice_new (GstStructureImpl);
  ((GstStructure *) structure)->type = _gst_structure_type;
  ((GstStructure *) structure)->name = quark;
  GST_STRUCTURE_REFCOUNT (structure) = NULL;
  GST_STRUCTURE_FIELDS (structure) =
      g_array_sized_new (FALSE, FALSE, sizeof (GstStructureField), prealloc);

  GST_TRACE ("created structure %p", structure);

  return GST_STRUCTURE_CAST (structure);
}

/**
 * gst_structure_new_id_empty:
 * @quark: name of new structure
 *
 * Creates a new, empty #GstStructure with the given name as a GQuark.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new, empty #GstStructure
 */
GstStructure *
gst_structure_new_id_empty (GQuark quark)
{
  g_return_val_if_fail (quark != 0, NULL);

  return gst_structure_new_id_empty_with_size (quark, 0);
}

#ifndef G_DISABLE_CHECKS
static gboolean
gst_structure_validate_name (const gchar * name)
{
  const gchar *s;

  g_return_val_if_fail (name != NULL, FALSE);

  if (G_UNLIKELY (!g_ascii_isalpha (*name))) {
    GST_WARNING ("Invalid character '%c' at offset 0 in structure name: %s",
        *name, name);
    return FALSE;
  }

  /* FIXME: test name string more */
  s = &name[1];
  while (*s && (g_ascii_isalnum (*s) || strchr ("/-_.:+", *s) != NULL))
    s++;
  if (G_UNLIKELY (*s != '\0')) {
    GST_WARNING ("Invalid character '%c' at offset %" G_GUINTPTR_FORMAT " in"
        " structure name: %s", *s, ((guintptr) s - (guintptr) name), name);
    return FALSE;
  }

  if (strncmp (name, "video/x-raw-", 12) == 0) {
    g_warning ("0.10-style raw video caps are being created. Should be "
        "video/x-raw,format=(string).. now.");
  } else if (strncmp (name, "audio/x-raw-", 12) == 0) {
    g_warning ("0.10-style raw audio caps are being created. Should be "
        "audio/x-raw,format=(string).. now.");
  }

  return TRUE;
}
#endif

/**
 * gst_structure_new_empty:
 * @name: name of new structure
 *
 * Creates a new, empty #GstStructure with the given @name.
 *
 * See gst_structure_set_name() for constraints on the @name parameter.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new, empty #GstStructure
 */
GstStructure *
gst_structure_new_empty (const gchar * name)
{
  g_return_val_if_fail (gst_structure_validate_name (name), NULL);

  return gst_structure_new_id_empty_with_size (g_quark_from_string (name), 0);
}

/**
 * gst_structure_new:
 * @name: name of new structure
 * @firstfield: name of first field to set
 * @...: additional arguments
 *
 * Creates a new #GstStructure with the given name.  Parses the
 * list of variable arguments and sets fields to the values listed.
 * Variable arguments should be passed as field name, field type,
 * and value.  Last variable argument should be %NULL.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new #GstStructure
 */
GstStructure *
gst_structure_new (const gchar * name, const gchar * firstfield, ...)
{
  GstStructure *structure;
  va_list varargs;

  va_start (varargs, firstfield);
  structure = gst_structure_new_valist (name, firstfield, varargs);
  va_end (varargs);

  return structure;
}

/**
 * gst_structure_new_valist:
 * @name: name of new structure
 * @firstfield: name of first field to set
 * @varargs: variable argument list
 *
 * Creates a new #GstStructure with the given @name.  Structure fields
 * are set according to the varargs in a manner similar to
 * gst_structure_new().
 *
 * See gst_structure_set_name() for constraints on the @name parameter.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new #GstStructure
 */
GstStructure *
gst_structure_new_valist (const gchar * name,
    const gchar * firstfield, va_list varargs)
{
  GstStructure *structure;

  structure = gst_structure_new_empty (name);

  if (structure)
    gst_structure_set_valist (structure, firstfield, varargs);

  return structure;
}

/**
 * gst_structure_set_parent_refcount:
 * @structure: a #GstStructure
 * @refcount: (in): a pointer to the parent's refcount
 *
 * Sets the parent_refcount field of #GstStructure. This field is used to
 * determine whether a structure is mutable or not. This function should only be
 * called by code implementing parent objects of #GstStructure, as described in
 * the MT Refcounting section of the design documents.
 *
 * Returns: %TRUE if the parent refcount could be set.
 */
gboolean
gst_structure_set_parent_refcount (GstStructure * structure, gint * refcount)
{
  g_return_val_if_fail (structure != NULL, FALSE);

  /* if we have a parent_refcount already, we can only clear
   * if with a NULL refcount */
  if (GST_STRUCTURE_REFCOUNT (structure)) {
    if (refcount != NULL) {
      g_return_val_if_fail (refcount == NULL, FALSE);
      return FALSE;
    }
  } else {
    if (refcount == NULL) {
      g_return_val_if_fail (refcount != NULL, FALSE);
      return FALSE;
    }
  }

  GST_STRUCTURE_REFCOUNT (structure) = refcount;

  return TRUE;
}

/**
 * gst_structure_copy:
 * @structure: a #GstStructure to duplicate
 *
 * Duplicates a #GstStructure and all its fields and values.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new #GstStructure.
 */
GstStructure *
gst_structure_copy (const GstStructure * structure)
{
  GstStructure *new_structure;
  GstStructureField *field;
  guint i, len;

  g_return_val_if_fail (structure != NULL, NULL);

  len = GST_STRUCTURE_FIELDS (structure)->len;
  new_structure = gst_structure_new_id_empty_with_size (structure->name, len);

  for (i = 0; i < len; i++) {
    GstStructureField new_field = { 0 };

    field = GST_STRUCTURE_FIELD (structure, i);

    new_field.name = field->name;
    gst_value_init_and_copy (&new_field.value, &field->value);
    g_array_append_val (GST_STRUCTURE_FIELDS (new_structure), new_field);
  }
  GST_CAT_TRACE (GST_CAT_PERFORMANCE, "doing copy %p -> %p",
      structure, new_structure);

  return new_structure;
}

/**
 * gst_structure_free:
 * @structure: (in) (transfer full): the #GstStructure to free
 *
 * Frees a #GstStructure and all its fields and values. The structure must not
 * have a parent when this function is called.
 */
void
gst_structure_free (GstStructure * structure)
{
  GstStructureField *field;
  guint i, len;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (GST_STRUCTURE_REFCOUNT (structure) == NULL);

  len = GST_STRUCTURE_FIELDS (structure)->len;
  for (i = 0; i < len; i++) {
    field = GST_STRUCTURE_FIELD (structure, i);

    if (G_IS_VALUE (&field->value)) {
      g_value_unset (&field->value);
    }
  }
  g_array_free (GST_STRUCTURE_FIELDS (structure), TRUE);
#ifdef USE_POISONING
  memset (structure, 0xff, sizeof (GstStructure));
#endif
  GST_TRACE ("free structure %p", structure);

  g_slice_free1 (sizeof (GstStructureImpl), structure);
}

/**
 * gst_structure_get_name:
 * @structure: a #GstStructure
 *
 * Get the name of @structure as a string.
 *
 * Returns: the name of the structure.
 */
const gchar *
gst_structure_get_name (const GstStructure * structure)
{
  g_return_val_if_fail (structure != NULL, NULL);

  return g_quark_to_string (structure->name);
}

/**
 * gst_structure_has_name:
 * @structure: a #GstStructure
 * @name: structure name to check for
 *
 * Checks if the structure has the given name
 *
 * Returns: %TRUE if @name matches the name of the structure.
 */
gboolean
gst_structure_has_name (const GstStructure * structure, const gchar * name)
{
  const gchar *structure_name;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (name != NULL, FALSE);

  /* getting the string is cheap and comparing short strings is too
   * should be faster than getting the quark for name and comparing the quarks
   */
  structure_name = g_quark_to_string (structure->name);

  return (structure_name && strcmp (structure_name, name) == 0);
}

/**
 * gst_structure_get_name_id:
 * @structure: a #GstStructure
 *
 * Get the name of @structure as a GQuark.
 *
 * Returns: the quark representing the name of the structure.
 */
GQuark
gst_structure_get_name_id (const GstStructure * structure)
{
  g_return_val_if_fail (structure != NULL, 0);

  return structure->name;
}

/**
 * gst_structure_set_name:
 * @structure: a #GstStructure
 * @name: the new name of the structure
 *
 * Sets the name of the structure to the given @name.  The string
 * provided is copied before being used. It must not be empty, start with a
 * letter and can be followed by letters, numbers and any of "/-_.:".
 */
void
gst_structure_set_name (GstStructure * structure, const gchar * name)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (IS_MUTABLE (structure));
  g_return_if_fail (gst_structure_validate_name (name));

  structure->name = g_quark_from_string (name);
}

static inline void
gst_structure_id_set_value_internal (GstStructure * structure, GQuark field,
    const GValue * value)
{
  GstStructureField gsfield = { 0, {0,} };

  gsfield.name = field;
  gst_value_init_and_copy (&gsfield.value, value);

  gst_structure_set_field (structure, &gsfield);
}

/**
 * gst_structure_id_set_value:
 * @structure: a #GstStructure
 * @field: a #GQuark representing a field
 * @value: the new value of the field
 *
 * Sets the field with the given GQuark @field to @value.  If the field
 * does not exist, it is created.  If the field exists, the previous
 * value is replaced and freed.
 */
void
gst_structure_id_set_value (GstStructure * structure,
    GQuark field, const GValue * value)
{

  g_return_if_fail (structure != NULL);
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_id_set_value_internal (structure, field, value);
}

/**
 * gst_structure_set_value:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to set
 * @value: the new value of the field
 *
 * Sets the field with the given name @field to @value.  If the field
 * does not exist, it is created.  If the field exists, the previous
 * value is replaced and freed.
 */
void
gst_structure_set_value (GstStructure * structure,
    const gchar * fieldname, const GValue * value)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (fieldname != NULL);
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_id_set_value_internal (structure,
      g_quark_from_string (fieldname), value);
}

static inline void
gst_structure_id_take_value_internal (GstStructure * structure, GQuark field,
    GValue * value)
{
  GstStructureField gsfield = { 0, {0,} };

  gsfield.name = field;
  gsfield.value = *value;

  gst_structure_set_field (structure, &gsfield);

  /* we took ownership */
#ifdef USE_POISONING
  memset (value, 0, sizeof (GValue));
#else
  value->g_type = G_TYPE_INVALID;
#endif
}

/**
 * gst_structure_id_take_value:
 * @structure: a #GstStructure
 * @field: a #GQuark representing a field
 * @value: (transfer full): the new value of the field
 *
 * Sets the field with the given GQuark @field to @value.  If the field
 * does not exist, it is created.  If the field exists, the previous
 * value is replaced and freed.
 */
void
gst_structure_id_take_value (GstStructure * structure, GQuark field,
    GValue * value)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_id_take_value_internal (structure, field, value);
}

/**
 * gst_structure_take_value:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to set
 * @value: (transfer full): the new value of the field
 *
 * Sets the field with the given name @field to @value.  If the field
 * does not exist, it is created.  If the field exists, the previous
 * value is replaced and freed. The function will take ownership of @value.
 */
void
gst_structure_take_value (GstStructure * structure, const gchar * fieldname,
    GValue * value)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (fieldname != NULL);
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_id_take_value_internal (structure,
      g_quark_from_string (fieldname), value);
}

static void
gst_structure_set_valist_internal (GstStructure * structure,
    const gchar * fieldname, va_list varargs)
{
  gchar *err = NULL;
  GType type;

  while (fieldname) {
    GstStructureField field = { 0 };

    field.name = g_quark_from_string (fieldname);

    type = va_arg (varargs, GType);

    G_VALUE_COLLECT_INIT (&field.value, type, varargs, 0, &err);
    if (G_UNLIKELY (err)) {
      g_critical ("%s", err);
      return;
    }
    gst_structure_set_field (structure, &field);

    fieldname = va_arg (varargs, gchar *);
  }
}

/**
 * gst_structure_set:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to set
 * @...: variable arguments
 *
 * Parses the variable arguments and sets fields accordingly.
 * Variable arguments should be in the form field name, field type
 * (as a GType), value(s).  The last variable argument should be %NULL.
 */
void
gst_structure_set (GstStructure * structure, const gchar * field, ...)
{
  va_list varargs;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (IS_MUTABLE (structure) || field == NULL);

  va_start (varargs, field);
  gst_structure_set_valist_internal (structure, field, varargs);
  va_end (varargs);
}

/**
 * gst_structure_set_valist:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to set
 * @varargs: variable arguments
 *
 * va_list form of gst_structure_set().
 */
void
gst_structure_set_valist (GstStructure * structure,
    const gchar * fieldname, va_list varargs)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_set_valist_internal (structure, fieldname, varargs);
}

static void
gst_structure_id_set_valist_internal (GstStructure * structure,
    GQuark fieldname, va_list varargs)
{
  gchar *err = NULL;
  GType type;

  while (fieldname) {
    GstStructureField field = { 0 };

    field.name = fieldname;

    type = va_arg (varargs, GType);

#ifndef G_VALUE_COLLECT_INIT
    g_value_init (&field.value, type);
    G_VALUE_COLLECT (&field.value, varargs, 0, &err);
#else
    G_VALUE_COLLECT_INIT (&field.value, type, varargs, 0, &err);
#endif
    if (G_UNLIKELY (err)) {
      g_critical ("%s", err);
      return;
    }
    gst_structure_set_field (structure, &field);

    fieldname = va_arg (varargs, GQuark);
  }
}

/**
 * gst_structure_id_set:
 * @structure: a #GstStructure
 * @fieldname: the GQuark for the name of the field to set
 * @...: variable arguments
 *
 * Identical to gst_structure_set, except that field names are
 * passed using the GQuark for the field name. This allows more efficient
 * setting of the structure if the caller already knows the associated
 * quark values.
 * The last variable argument must be %NULL.
 */
void
gst_structure_id_set (GstStructure * structure, GQuark field, ...)
{
  va_list varargs;

  g_return_if_fail (structure != NULL);

  va_start (varargs, field);
  gst_structure_id_set_valist_internal (structure, field, varargs);
  va_end (varargs);
}

/**
 * gst_structure_id_set_valist:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to set
 * @varargs: variable arguments
 *
 * va_list form of gst_structure_id_set().
 */
void
gst_structure_id_set_valist (GstStructure * structure,
    GQuark fieldname, va_list varargs)
{
  g_return_if_fail (structure != NULL);
  g_return_if_fail (IS_MUTABLE (structure));

  gst_structure_id_set_valist_internal (structure, fieldname, varargs);
}

/**
 * gst_structure_new_id:
 * @name_quark: name of new structure
 * @field_quark: the GQuark for the name of the field to set
 * @...: variable arguments
 *
 * Creates a new #GstStructure with the given name as a GQuark, followed by
 * fieldname quark, GType, argument(s) "triplets" in the same format as
 * gst_structure_id_set(). Basically a convenience wrapper around
 * gst_structure_new_id_empty() and gst_structure_id_set().
 *
 * The last variable argument must be %NULL (or 0).
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full): a new #GstStructure
 */
GstStructure *
gst_structure_new_id (GQuark name_quark, GQuark field_quark, ...)
{
  GstStructure *s;
  va_list varargs;

  g_return_val_if_fail (name_quark != 0, NULL);
  g_return_val_if_fail (field_quark != 0, NULL);

  s = gst_structure_new_id_empty (name_quark);

  va_start (varargs, field_quark);
  gst_structure_id_set_valist_internal (s, field_quark, varargs);
  va_end (varargs);

  return s;
}

#if GST_VERSION_NANO == 1
#define GIT_G_WARNING g_warning
#else
#define GIT_G_WARNING GST_WARNING
#endif

/* If the structure currently contains a field with the same name, it is
 * replaced with the provided field. Otherwise, the field is added to the
 * structure. The field's value is not deeply copied.
 */
static void
gst_structure_set_field (GstStructure * structure, GstStructureField * field)
{
  GstStructureField *f;
  GType field_value_type;
  guint i, len;

  len = GST_STRUCTURE_FIELDS (structure)->len;

  field_value_type = G_VALUE_TYPE (&field->value);
  if (field_value_type == G_TYPE_STRING) {
    const gchar *s;

    s = g_value_get_string (&field->value);
    /* only check for NULL strings in taglists, as they are allowed in message
     * structs, e.g. error message debug strings */
    if (G_UNLIKELY (IS_TAGLIST (structure) && (s == NULL || *s == '\0'))) {
      if (s == NULL) {
        GIT_G_WARNING ("Trying to set NULL string on field '%s' on taglist. "
            "Please file a bug.", g_quark_to_string (field->name));
        g_value_unset (&field->value);
        return;
      } else {
        /* empty strings never make sense */
        GIT_G_WARNING ("Trying to set empty string on taglist field '%s'. "
            "Please file a bug.", g_quark_to_string (field->name));
        g_value_unset (&field->value);
        return;
      }
    } else if (G_UNLIKELY (s != NULL && !g_utf8_validate (s, -1, NULL))) {
      g_warning ("Trying to set string on %s field '%s', but string is not "
          "valid UTF-8. Please file a bug.",
          IS_TAGLIST (structure) ? "taglist" : "structure",
          g_quark_to_string (field->name));
      g_value_unset (&field->value);
      return;
    }
  } else if (G_UNLIKELY (field_value_type == G_TYPE_DATE)) {
    const GDate *d;

    d = g_value_get_boxed (&field->value);
    /* only check for NULL GDates in taglists, as they might make sense
     * in other, generic structs */
    if (G_UNLIKELY ((IS_TAGLIST (structure) && d == NULL))) {
      GIT_G_WARNING ("Trying to set NULL GDate on field '%s' on taglist. "
          "Please file a bug.", g_quark_to_string (field->name));
      g_value_unset (&field->value);
      return;
    } else if (G_UNLIKELY (d != NULL && !g_date_valid (d))) {
      g_warning
          ("Trying to set invalid GDate on %s field '%s'. Please file a bug.",
          IS_TAGLIST (structure) ? "taglist" : "structure",
          g_quark_to_string (field->name));
      g_value_unset (&field->value);
      return;
    }
  }

  for (i = 0; i < len; i++) {
    f = GST_STRUCTURE_FIELD (structure, i);

    if (G_UNLIKELY (f->name == field->name)) {
      g_value_unset (&f->value);
      memcpy (f, field, sizeof (GstStructureField));
      return;
    }
  }

  g_array_append_val (GST_STRUCTURE_FIELDS (structure), *field);
}

/* If there is no field with the given ID, NULL is returned.
 */
static GstStructureField *
gst_structure_id_get_field (const GstStructure * structure, GQuark field_id)
{
  GstStructureField *field;
  guint i, len;

  len = GST_STRUCTURE_FIELDS (structure)->len;

  for (i = 0; i < len; i++) {
    field = GST_STRUCTURE_FIELD (structure, i);

    if (G_UNLIKELY (field->name == field_id))
      return field;
  }

  return NULL;
}

/* If there is no field with the given ID, NULL is returned.
 */
static GstStructureField *
gst_structure_get_field (const GstStructure * structure,
    const gchar * fieldname)
{
  g_return_val_if_fail (structure != NULL, NULL);
  g_return_val_if_fail (fieldname != NULL, NULL);

  return gst_structure_id_get_field (structure,
      g_quark_from_string (fieldname));
}

/**
 * gst_structure_get_value:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to get
 *
 * Get the value of the field with name @fieldname.
 *
 * Returns: the #GValue corresponding to the field with the given name.
 */
const GValue *
gst_structure_get_value (const GstStructure * structure,
    const gchar * fieldname)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, NULL);
  g_return_val_if_fail (fieldname != NULL, NULL);

  field = gst_structure_get_field (structure, fieldname);
  if (field == NULL)
    return NULL;

  return &field->value;
}

/**
 * gst_structure_id_get_value:
 * @structure: a #GstStructure
 * @field: the #GQuark of the field to get
 *
 * Get the value of the field with GQuark @field.
 *
 * Returns: the #GValue corresponding to the field with the given name
 *          identifier.
 */
const GValue *
gst_structure_id_get_value (const GstStructure * structure, GQuark field)
{
  GstStructureField *gsfield;

  g_return_val_if_fail (structure != NULL, NULL);

  gsfield = gst_structure_id_get_field (structure, field);
  if (gsfield == NULL)
    return NULL;

  return &gsfield->value;
}

/**
 * gst_structure_remove_field:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to remove
 *
 * Removes the field with the given name.  If the field with the given
 * name does not exist, the structure is unchanged.
 */
void
gst_structure_remove_field (GstStructure * structure, const gchar * fieldname)
{
  GstStructureField *field;
  GQuark id;
  guint i, len;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (fieldname != NULL);
  g_return_if_fail (IS_MUTABLE (structure));

  id = g_quark_from_string (fieldname);
  len = GST_STRUCTURE_FIELDS (structure)->len;

  for (i = 0; i < len; i++) {
    field = GST_STRUCTURE_FIELD (structure, i);

    if (field->name == id) {
      if (G_IS_VALUE (&field->value)) {
        g_value_unset (&field->value);
      }
      GST_STRUCTURE_FIELDS (structure) =
          g_array_remove_index (GST_STRUCTURE_FIELDS (structure), i);
      return;
    }
  }
}

/**
 * gst_structure_remove_fields:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to remove
 * @...: %NULL-terminated list of more fieldnames to remove
 *
 * Removes the fields with the given names. If a field does not exist, the
 * argument is ignored.
 */
void
gst_structure_remove_fields (GstStructure * structure,
    const gchar * fieldname, ...)
{
  va_list varargs;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (fieldname != NULL);
  /* mutability checked in remove_field */

  va_start (varargs, fieldname);
  gst_structure_remove_fields_valist (structure, fieldname, varargs);
  va_end (varargs);
}

/**
 * gst_structure_remove_fields_valist:
 * @structure: a #GstStructure
 * @fieldname: the name of the field to remove
 * @varargs: %NULL-terminated list of more fieldnames to remove
 *
 * va_list form of gst_structure_remove_fields().
 */
void
gst_structure_remove_fields_valist (GstStructure * structure,
    const gchar * fieldname, va_list varargs)
{
  gchar *field = (gchar *) fieldname;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (fieldname != NULL);
  /* mutability checked in remove_field */

  while (field) {
    gst_structure_remove_field (structure, field);
    field = va_arg (varargs, char *);
  }
}

/**
 * gst_structure_remove_all_fields:
 * @structure: a #GstStructure
 *
 * Removes all fields in a GstStructure.
 */
void
gst_structure_remove_all_fields (GstStructure * structure)
{
  GstStructureField *field;
  int i;

  g_return_if_fail (structure != NULL);
  g_return_if_fail (IS_MUTABLE (structure));

  for (i = GST_STRUCTURE_FIELDS (structure)->len - 1; i >= 0; i--) {
    field = GST_STRUCTURE_FIELD (structure, i);

    if (G_IS_VALUE (&field->value)) {
      g_value_unset (&field->value);
    }
    GST_STRUCTURE_FIELDS (structure) =
        g_array_remove_index (GST_STRUCTURE_FIELDS (structure), i);
  }
}

/**
 * gst_structure_get_field_type:
 * @structure: a #GstStructure
 * @fieldname: the name of the field
 *
 * Finds the field with the given name, and returns the type of the
 * value it contains.  If the field is not found, G_TYPE_INVALID is
 * returned.
 *
 * Returns: the #GValue of the field
 */
GType
gst_structure_get_field_type (const GstStructure * structure,
    const gchar * fieldname)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, G_TYPE_INVALID);
  g_return_val_if_fail (fieldname != NULL, G_TYPE_INVALID);

  field = gst_structure_get_field (structure, fieldname);
  if (field == NULL)
    return G_TYPE_INVALID;

  return G_VALUE_TYPE (&field->value);
}

/**
 * gst_structure_n_fields:
 * @structure: a #GstStructure
 *
 * Get the number of fields in the structure.
 *
 * Returns: the number of fields in the structure
 */
gint
gst_structure_n_fields (const GstStructure * structure)
{
  g_return_val_if_fail (structure != NULL, 0);

  return GST_STRUCTURE_FIELDS (structure)->len;
}

/**
 * gst_structure_nth_field_name:
 * @structure: a #GstStructure
 * @index: the index to get the name of
 *
 * Get the name of the given field number, counting from 0 onwards.
 *
 * Returns: the name of the given field number
 */
const gchar *
gst_structure_nth_field_name (const GstStructure * structure, guint index)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, NULL);
  g_return_val_if_fail (index < GST_STRUCTURE_FIELDS (structure)->len, NULL);

  field = GST_STRUCTURE_FIELD (structure, index);

  return g_quark_to_string (field->name);
}

/**
 * gst_structure_foreach:
 * @structure: a #GstStructure
 * @func: (scope call): a function to call for each field
 * @user_data: (closure): private data
 *
 * Calls the provided function once for each field in the #GstStructure. The
 * function must not modify the fields. Also see gst_structure_map_in_place().
 *
 * Returns: %TRUE if the supplied function returns %TRUE For each of the fields,
 * %FALSE otherwise.
 */
gboolean
gst_structure_foreach (const GstStructure * structure,
    GstStructureForeachFunc func, gpointer user_data)
{
  guint i, len;
  GstStructureField *field;
  gboolean ret;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (func != NULL, FALSE);

  len = GST_STRUCTURE_FIELDS (structure)->len;

  for (i = 0; i < len; i++) {
    field = GST_STRUCTURE_FIELD (structure, i);

    ret = func (field->name, &field->value, user_data);
    if (G_UNLIKELY (!ret))
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_structure_map_in_place:
 * @structure: a #GstStructure
 * @func: (scope call): a function to call for each field
 * @user_data: (closure): private data
 *
 * Calls the provided function once for each field in the #GstStructure. In
 * contrast to gst_structure_foreach(), the function may modify but not delete the
 * fields. The structure must be mutable.
 *
 * Returns: %TRUE if the supplied function returns %TRUE For each of the fields,
 * %FALSE otherwise.
 */
gboolean
gst_structure_map_in_place (GstStructure * structure,
    GstStructureMapFunc func, gpointer user_data)
{
  guint i, len;
  GstStructureField *field;
  gboolean ret;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);
  g_return_val_if_fail (func != NULL, FALSE);
  len = GST_STRUCTURE_FIELDS (structure)->len;

  for (i = 0; i < len; i++) {
    field = GST_STRUCTURE_FIELD (structure, i);

    ret = func (field->name, &field->value, user_data);
    if (!ret)
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_structure_id_has_field:
 * @structure: a #GstStructure
 * @field: #GQuark of the field name
 *
 * Check if @structure contains a field named @field.
 *
 * Returns: %TRUE if the structure contains a field with the given name
 */
gboolean
gst_structure_id_has_field (const GstStructure * structure, GQuark field)
{
  GstStructureField *f;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (field != 0, FALSE);

  f = gst_structure_id_get_field (structure, field);

  return (f != NULL);
}

/**
 * gst_structure_has_field:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 *
 * Check if @structure contains a field named @fieldname.
 *
 * Returns: %TRUE if the structure contains a field with the given name
 */
gboolean
gst_structure_has_field (const GstStructure * structure,
    const gchar * fieldname)
{
  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);

  return gst_structure_id_has_field (structure,
      g_quark_from_string (fieldname));
}

/**
 * gst_structure_id_has_field_typed:
 * @structure: a #GstStructure
 * @field: #GQuark of the field name
 * @type: the type of a value
 *
 * Check if @structure contains a field named @field and with GType @type.
 *
 * Returns: %TRUE if the structure contains a field with the given name and type
 */
gboolean
gst_structure_id_has_field_typed (const GstStructure * structure,
    GQuark field, GType type)
{
  GstStructureField *f;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (field != 0, FALSE);

  f = gst_structure_id_get_field (structure, field);
  if (f == NULL)
    return FALSE;

  return (G_VALUE_TYPE (&f->value) == type);
}

/**
 * gst_structure_has_field_typed:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @type: the type of a value
 *
 * Check if @structure contains a field named @fieldname and with GType @type.
 *
 * Returns: %TRUE if the structure contains a field with the given name and type
 */
gboolean
gst_structure_has_field_typed (const GstStructure * structure,
    const gchar * fieldname, GType type)
{
  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);

  return gst_structure_id_has_field_typed (structure,
      g_quark_from_string (fieldname), type);
}

/* utility functions */

/**
 * gst_structure_get_boolean:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a #gboolean to set
 *
 * Sets the boolean pointed to by @value corresponding to the value of the
 * given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a boolean, this
 * function returns %FALSE.
 */
gboolean
gst_structure_get_boolean (const GstStructure * structure,
    const gchar * fieldname, gboolean * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_BOOLEAN)
    return FALSE;

  *value = gst_g_value_get_boolean_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_int:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to an int to set
 *
 * Sets the int pointed to by @value corresponding to the value of the
 * given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain an int, this function
 * returns %FALSE.
 */
gboolean
gst_structure_get_int (const GstStructure * structure,
    const gchar * fieldname, gint * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_INT)
    return FALSE;

  *value = gst_g_value_get_int_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_uint:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a uint to set
 *
 * Sets the uint pointed to by @value corresponding to the value of the
 * given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a uint, this function
 * returns %FALSE.
 */
gboolean
gst_structure_get_uint (const GstStructure * structure,
    const gchar * fieldname, guint * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_UINT)
    return FALSE;

  *value = gst_g_value_get_uint_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_int64:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a #gint64 to set
 *
 * Sets the #gint64 pointed to by @value corresponding to the value of the
 * given field. Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a #gint64, this function
 * returns %FALSE.
 *
 * Since: 1.4
 */
gboolean
gst_structure_get_int64 (const GstStructure * structure,
    const gchar * fieldname, gint64 * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_INT64)
    return FALSE;

  *value = gst_g_value_get_int64_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_uint64:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a #guint64 to set
 *
 * Sets the #guint64 pointed to by @value corresponding to the value of the
 * given field. Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a #guint64, this function
 * returns %FALSE.
 *
 * Since: 1.4
 */
gboolean
gst_structure_get_uint64 (const GstStructure * structure,
    const gchar * fieldname, guint64 * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_UINT64)
    return FALSE;

  *value = gst_g_value_get_uint64_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_date:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out callee-allocates): a pointer to a #GDate to set
 *
 * Sets the date pointed to by @value corresponding to the date of the
 * given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * On success @value will point to a newly-allocated copy of the date which
 * should be freed with g_date_free() when no longer needed (note: this is
 * inconsistent with e.g. gst_structure_get_string() which doesn't return a
 * copy of the string).
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a data, this function
 * returns %FALSE.
 */
gboolean
gst_structure_get_date (const GstStructure * structure, const gchar * fieldname,
    GDate ** value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_DATE)
    return FALSE;

  /* FIXME: 2.0 g_value_dup_boxed() -> g_value_get_boxed() */
  *value = g_value_dup_boxed (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_date_time:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out callee-allocates): a pointer to a #GstDateTime to set
 *
 * Sets the datetime pointed to by @value corresponding to the datetime of the
 * given field. Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * On success @value will point to a reference of the datetime which
 * should be unreffed with gst_date_time_unref() when no longer needed
 * (note: this is inconsistent with e.g. gst_structure_get_string()
 * which doesn't return a copy of the string).
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a data, this function
 * returns %FALSE.
 */
gboolean
gst_structure_get_date_time (const GstStructure * structure,
    const gchar * fieldname, GstDateTime ** value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL)
    return FALSE;
  if (!GST_VALUE_HOLDS_DATE_TIME (&field->value))
    return FALSE;

  /* FIXME: 0.11 g_value_dup_boxed() -> g_value_get_boxed() */
  *value = g_value_dup_boxed (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_clock_time:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a #GstClockTime to set
 *
 * Sets the clock time pointed to by @value corresponding to the clock time
 * of the given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a #GstClockTime, this
 * function returns %FALSE.
 */
gboolean
gst_structure_get_clock_time (const GstStructure * structure,
    const gchar * fieldname, GstClockTime * value)
{
  return gst_structure_get_uint64 (structure, fieldname, value);
}

/**
 * gst_structure_get_double:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value: (out): a pointer to a gdouble to set
 *
 * Sets the double pointed to by @value corresponding to the value of the
 * given field.  Caller is responsible for making sure the field exists
 * and has the correct type.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a double, this
 * function returns %FALSE.
 */
gboolean
gst_structure_get_double (const GstStructure * structure,
    const gchar * fieldname, gdouble * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_DOUBLE)
    return FALSE;

  *value = gst_g_value_get_double_unchecked (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_string:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 *
 * Finds the field corresponding to @fieldname, and returns the string
 * contained in the field's value.  Caller is responsible for making
 * sure the field exists and has the correct type.
 *
 * The string should not be modified, and remains valid until the next
 * call to a gst_structure_*() function with the given structure.
 *
 * Returns: (nullable): a pointer to the string or %NULL when the
 * field did not exist or did not contain a string.
 */
const gchar *
gst_structure_get_string (const GstStructure * structure,
    const gchar * fieldname)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, NULL);
  g_return_val_if_fail (fieldname != NULL, NULL);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != G_TYPE_STRING)
    return NULL;

  return gst_g_value_get_string_unchecked (&field->value);
}

/**
 * gst_structure_get_enum:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @enumtype: the enum type of a field
 * @value: (out): a pointer to an int to set
 *
 * Sets the int pointed to by @value corresponding to the value of the
 * given field.  Caller is responsible for making sure the field exists,
 * has the correct type and that the enumtype is correct.
 *
 * Returns: %TRUE if the value could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain an enum of the given
 * type, this function returns %FALSE.
 */
gboolean
gst_structure_get_enum (const GstStructure * structure,
    const gchar * fieldname, GType enumtype, gint * value)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (enumtype != G_TYPE_INVALID, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL)
    return FALSE;
  if (!G_TYPE_CHECK_VALUE_TYPE (&field->value, enumtype))
    return FALSE;

  *value = g_value_get_enum (&field->value);

  return TRUE;
}

/**
 * gst_structure_get_fraction:
 * @structure: a #GstStructure
 * @fieldname: the name of a field
 * @value_numerator: (out): a pointer to an int to set
 * @value_denominator: (out): a pointer to an int to set
 *
 * Sets the integers pointed to by @value_numerator and @value_denominator
 * corresponding to the value of the given field.  Caller is responsible
 * for making sure the field exists and has the correct type.
 *
 * Returns: %TRUE if the values could be set correctly. If there was no field
 * with @fieldname or the existing field did not contain a GstFraction, this
 * function returns %FALSE.
 */
gboolean
gst_structure_get_fraction (const GstStructure * structure,
    const gchar * fieldname, gint * value_numerator, gint * value_denominator)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (fieldname != NULL, FALSE);
  g_return_val_if_fail (value_numerator != NULL, FALSE);
  g_return_val_if_fail (value_denominator != NULL, FALSE);

  field = gst_structure_get_field (structure, fieldname);

  if (field == NULL || G_VALUE_TYPE (&field->value) != GST_TYPE_FRACTION)
    return FALSE;

  *value_numerator = gst_value_get_fraction_numerator (&field->value);
  *value_denominator = gst_value_get_fraction_denominator (&field->value);

  return TRUE;
}

typedef struct _GstStructureAbbreviation
{
  const gchar *type_name;
  GType type;
}
GstStructureAbbreviation;

/* return a copy of an array of GstStructureAbbreviation containing all the
 * known type_string, GType maps, including abbreviations for common types */
static GstStructureAbbreviation *
gst_structure_get_abbrs (gint * n_abbrs)
{
  static GstStructureAbbreviation *abbrs = NULL;
  static volatile gsize num = 0;

  if (g_once_init_enter (&num)) {
    /* dynamically generate the array */
    gsize _num;
    GstStructureAbbreviation dyn_abbrs[] = {
      {"int", G_TYPE_INT}
      ,
      {"i", G_TYPE_INT}
      ,
      {"uint", G_TYPE_UINT}
      ,
      {"u", G_TYPE_UINT}
      ,
      {"float", G_TYPE_FLOAT}
      ,
      {"f", G_TYPE_FLOAT}
      ,
      {"double", G_TYPE_DOUBLE}
      ,
      {"d", G_TYPE_DOUBLE}
      ,
      {"buffer", GST_TYPE_BUFFER}
      ,
      {"fraction", GST_TYPE_FRACTION}
      ,
      {"boolean", G_TYPE_BOOLEAN}
      ,
      {"bool", G_TYPE_BOOLEAN}
      ,
      {"b", G_TYPE_BOOLEAN}
      ,
      {"string", G_TYPE_STRING}
      ,
      {"str", G_TYPE_STRING}
      ,
      {"s", G_TYPE_STRING}
      ,
      {"structure", GST_TYPE_STRUCTURE}
      ,
      {"date", G_TYPE_DATE}
      ,
      {"datetime", GST_TYPE_DATE_TIME}
      ,
      {"bitmask", GST_TYPE_BITMASK}
      ,
      {"sample", GST_TYPE_SAMPLE}
      ,
      {"taglist", GST_TYPE_TAG_LIST}
    };
    _num = G_N_ELEMENTS (dyn_abbrs);
    /* permanently allocate and copy the array now */
    abbrs = g_new0 (GstStructureAbbreviation, _num);
    memcpy (abbrs, dyn_abbrs, sizeof (GstStructureAbbreviation) * _num);
    g_once_init_leave (&num, _num);
  }
  *n_abbrs = num;

  return abbrs;
}

/* given a type_name that could be a type abbreviation or a registered GType,
 * return a matching GType */
static GType
gst_structure_gtype_from_abbr (const char *type_name)
{
  int i;
  GstStructureAbbreviation *abbrs;
  gint n_abbrs;

  g_return_val_if_fail (type_name != NULL, G_TYPE_INVALID);

  abbrs = gst_structure_get_abbrs (&n_abbrs);

  for (i = 0; i < n_abbrs; i++) {
    if (strcmp (type_name, abbrs[i].type_name) == 0) {
      return abbrs[i].type;
    }
  }

  /* this is the fallback */
  return g_type_from_name (type_name);
}

static const char *
gst_structure_to_abbr (GType type)
{
  int i;
  GstStructureAbbreviation *abbrs;
  gint n_abbrs;

  g_return_val_if_fail (type != G_TYPE_INVALID, NULL);

  abbrs = gst_structure_get_abbrs (&n_abbrs);

  for (i = 0; i < n_abbrs; i++) {
    if (type == abbrs[i].type) {
      return abbrs[i].type_name;
    }
  }

  return g_type_name (type);
}

static GType
gst_structure_value_get_generic_type (GValue * val)
{
  if (G_VALUE_TYPE (val) == GST_TYPE_LIST
      || G_VALUE_TYPE (val) == GST_TYPE_ARRAY) {
    GArray *array = g_value_peek_pointer (val);

    if (array->len > 0) {
      GValue *value = &g_array_index (array, GValue, 0);

      return gst_structure_value_get_generic_type (value);
    } else {
      return G_TYPE_INT;
    }
  } else if (G_VALUE_TYPE (val) == GST_TYPE_INT_RANGE) {
    return G_TYPE_INT;
  } else if (G_VALUE_TYPE (val) == GST_TYPE_INT64_RANGE) {
    return G_TYPE_INT64;
  } else if (G_VALUE_TYPE (val) == GST_TYPE_DOUBLE_RANGE) {
    return G_TYPE_DOUBLE;
  } else if (G_VALUE_TYPE (val) == GST_TYPE_FRACTION_RANGE) {
    return GST_TYPE_FRACTION;
  }
  return G_VALUE_TYPE (val);
}

gboolean
priv_gst_structure_append_to_gstring (const GstStructure * structure,
    GString * s)
{
  GstStructureField *field;
  guint i, len;

  g_return_val_if_fail (s != NULL, FALSE);

  len = GST_STRUCTURE_FIELDS (structure)->len;
  for (i = 0; i < len; i++) {
    char *t;
    GType type;

    field = GST_STRUCTURE_FIELD (structure, i);

    t = gst_value_serialize (&field->value);
    type = gst_structure_value_get_generic_type (&field->value);

    g_string_append_len (s, ", ", 2);
    /* FIXME: do we need to escape fieldnames? */
    g_string_append (s, g_quark_to_string (field->name));
    g_string_append_len (s, "=(", 2);
    g_string_append (s, gst_structure_to_abbr (type));
    g_string_append_c (s, ')');
    g_string_append (s, t == NULL ? "NULL" : t);
    g_free (t);
  }

  g_string_append_c (s, ';');
  return TRUE;
}

/**
 * gst_structure_to_string:
 * @structure: a #GstStructure
 *
 * Converts @structure to a human-readable string representation.
 *
 * For debugging purposes its easier to do something like this:
 * |[
 * GST_LOG ("structure is %" GST_PTR_FORMAT, structure);
 * ]|
 * This prints the structure in human readable form.
 *
 * The current implementation of serialization will lead to unexpected results
 * when there are nested #GstCaps / #GstStructure deeper than one level.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full): a pointer to string allocated by g_malloc().
 *     g_free() after usage.
 */
gchar *
gst_structure_to_string (const GstStructure * structure)
{
  GString *s;

  /* NOTE:  This function is potentially called by the debug system,
   * so any calls to gst_log() (and GST_DEBUG(), GST_LOG(), etc.)
   * should be careful to avoid recursion.  This includes any functions
   * called by gst_structure_to_string.  In particular, calls should
   * not use the GST_PTR_FORMAT extension.  */

  g_return_val_if_fail (structure != NULL, NULL);

  /* we estimate a minimum size based on the number of fields in order to
   * avoid unnecessary reallocs within GString */
  s = g_string_sized_new (STRUCTURE_ESTIMATED_STRING_LEN (structure));
  g_string_append (s, g_quark_to_string (structure->name));
  priv_gst_structure_append_to_gstring (structure, s);
  return g_string_free (s, FALSE);
}

/*
 * r will still point to the string. if end == next, the string will not be
 * null-terminated. In all other cases it will be.
 * end = pointer to char behind end of string, next = pointer to start of
 * unread data.
 * THIS FUNCTION MODIFIES THE STRING AND DETECTS INSIDE A NONTERMINATED STRING
 */
static gboolean
gst_structure_parse_string (gchar * s, gchar ** end, gchar ** next,
    gboolean unescape)
{
  gchar *w;

  if (*s == 0)
    return FALSE;

  if (*s != '"') {
    int ret;

    ret = gst_structure_parse_simple_string (s, end);
    *next = *end;

    return ret;
  }

  if (unescape) {
    w = s;
    s++;
    while (*s != '"') {
      if (G_UNLIKELY (*s == 0))
        return FALSE;
      if (G_UNLIKELY (*s == '\\'))
        s++;
      *w = *s;
      w++;
      s++;
    }
    s++;
  } else {
    /* Find the closing quotes */
    s++;
    while (*s != '"') {
      if (G_UNLIKELY (*s == 0))
        return FALSE;
      if (G_UNLIKELY (*s == '\\'))
        s++;
      s++;
    }
    s++;
    w = s;
  }

  *end = w;
  *next = s;

  return TRUE;
}

static gboolean
gst_structure_parse_range (gchar * s, gchar ** after, GValue * value,
    GType type)
{
  GValue value1 = { 0 };
  GValue value2 = { 0 };
  GValue value3 = { 0 };
  GType range_type;
  gboolean ret, have_step = FALSE;

  if (*s != '[')
    return FALSE;
  s++;

  ret = gst_structure_parse_value (s, &s, &value1, type);
  if (ret == FALSE)
    return FALSE;

  while (g_ascii_isspace (*s))
    s++;

  if (*s != ',')
    return FALSE;
  s++;

  while (g_ascii_isspace (*s))
    s++;

  ret = gst_structure_parse_value (s, &s, &value2, type);
  if (ret == FALSE)
    return FALSE;

  while (g_ascii_isspace (*s))
    s++;

  /* optional step for int and int64 */
  if (G_VALUE_TYPE (&value1) == G_TYPE_INT
      || G_VALUE_TYPE (&value1) == G_TYPE_INT64) {
    if (*s == ',') {
      s++;

      while (g_ascii_isspace (*s))
        s++;

      ret = gst_structure_parse_value (s, &s, &value3, type);
      if (ret == FALSE)
        return FALSE;

      while (g_ascii_isspace (*s))
        s++;

      have_step = TRUE;
    }
  }

  if (*s != ']')
    return FALSE;
  s++;

  if (G_VALUE_TYPE (&value1) != G_VALUE_TYPE (&value2))
    return FALSE;
  if (have_step && G_VALUE_TYPE (&value1) != G_VALUE_TYPE (&value3))
    return FALSE;

  if (G_VALUE_TYPE (&value1) == G_TYPE_DOUBLE) {
    range_type = GST_TYPE_DOUBLE_RANGE;
    g_value_init (value, range_type);
    gst_value_set_double_range (value,
        gst_g_value_get_double_unchecked (&value1),
        gst_g_value_get_double_unchecked (&value2));
  } else if (G_VALUE_TYPE (&value1) == G_TYPE_INT) {
    range_type = GST_TYPE_INT_RANGE;
    g_value_init (value, range_type);
    if (have_step)
      gst_value_set_int_range_step (value,
          gst_g_value_get_int_unchecked (&value1),
          gst_g_value_get_int_unchecked (&value2),
          gst_g_value_get_int_unchecked (&value3));
    else
      gst_value_set_int_range (value, gst_g_value_get_int_unchecked (&value1),
          gst_g_value_get_int_unchecked (&value2));
  } else if (G_VALUE_TYPE (&value1) == G_TYPE_INT64) {
    range_type = GST_TYPE_INT64_RANGE;
    g_value_init (value, range_type);
    if (have_step)
      gst_value_set_int64_range_step (value,
          gst_g_value_get_int64_unchecked (&value1),
          gst_g_value_get_int64_unchecked (&value2),
          gst_g_value_get_int64_unchecked (&value3));
    else
      gst_value_set_int64_range (value,
          gst_g_value_get_int64_unchecked (&value1),
          gst_g_value_get_int64_unchecked (&value2));
  } else if (G_VALUE_TYPE (&value1) == GST_TYPE_FRACTION) {
    range_type = GST_TYPE_FRACTION_RANGE;
    g_value_init (value, range_type);
    gst_value_set_fraction_range (value, &value1, &value2);
  } else {
    return FALSE;
  }

  *after = s;
  return TRUE;
}

static gboolean
gst_structure_parse_any_list (gchar * s, gchar ** after, GValue * value,
    GType type, GType list_type, char begin, char end)
{
  GValue list_value = { 0 };
  gboolean ret;
  GArray *array;

  g_value_init (value, list_type);
  array = g_value_peek_pointer (value);

  if (*s != begin)
    return FALSE;
  s++;

  while (g_ascii_isspace (*s))
    s++;
  if (*s == end) {
    s++;
    *after = s;
    return TRUE;
  }

  ret = gst_structure_parse_value (s, &s, &list_value, type);
  if (ret == FALSE)
    return FALSE;

  g_array_append_val (array, list_value);

  while (g_ascii_isspace (*s))
    s++;

  while (*s != end) {
    if (*s != ',')
      return FALSE;
    s++;

    while (g_ascii_isspace (*s))
      s++;

    memset (&list_value, 0, sizeof (list_value));
    ret = gst_structure_parse_value (s, &s, &list_value, type);
    if (ret == FALSE)
      return FALSE;

    g_array_append_val (array, list_value);
    while (g_ascii_isspace (*s))
      s++;
  }

  s++;

  *after = s;
  return TRUE;
}

static gboolean
gst_structure_parse_list (gchar * s, gchar ** after, GValue * value, GType type)
{
  return gst_structure_parse_any_list (s, after, value, type, GST_TYPE_LIST,
      '{', '}');
}

static gboolean
gst_structure_parse_array (gchar * s, gchar ** after, GValue * value,
    GType type)
{
  return gst_structure_parse_any_list (s, after, value, type,
      GST_TYPE_ARRAY, '<', '>');
}

static gboolean
gst_structure_parse_simple_string (gchar * str, gchar ** end)
{
  char *s = str;

  while (G_LIKELY (GST_ASCII_IS_STRING (*s))) {
    s++;
  }

  *end = s;

  return (s != str);
}

static gboolean
gst_structure_parse_field (gchar * str,
    gchar ** after, GstStructureField * field)
{
  gchar *name;
  gchar *name_end;
  gchar *s;
  gchar c;

  s = str;

  while (g_ascii_isspace (*s) || (s[0] == '\\' && g_ascii_isspace (s[1])))
    s++;
  name = s;
  if (G_UNLIKELY (!gst_structure_parse_simple_string (s, &name_end))) {
    GST_WARNING ("failed to parse simple string, str=%s", str);
    return FALSE;
  }

  s = name_end;
  while (g_ascii_isspace (*s) || (s[0] == '\\' && g_ascii_isspace (s[1])))
    s++;

  if (G_UNLIKELY (*s != '=')) {
    GST_WARNING ("missing assignment operator in the field, str=%s", str);
    return FALSE;
  }
  s++;

  c = *name_end;
  *name_end = '\0';
  field->name = g_quark_from_string (name);
  GST_DEBUG ("trying field name '%s'", name);
  *name_end = c;

  if (G_UNLIKELY (!gst_structure_parse_value (s, &s, &field->value,
              G_TYPE_INVALID))) {
    GST_WARNING ("failed to parse value %s", str);
    return FALSE;
  }

  *after = s;
  return TRUE;
}

static gboolean
gst_structure_parse_value (gchar * str,
    gchar ** after, GValue * value, GType default_type)
{
  gchar *type_name;
  gchar *type_end;
  gchar *value_s;
  gchar *value_end;
  gchar *s;
  gchar c;
  int ret = 0;
  GType type = default_type;

  s = str;
  while (g_ascii_isspace (*s))
    s++;

  /* check if there's a (type_name) 'cast' */
  type_name = NULL;
  if (*s == '(') {
    s++;
    while (g_ascii_isspace (*s))
      s++;
    type_name = s;
    if (G_UNLIKELY (!gst_structure_parse_simple_string (s, &type_end)))
      return FALSE;
    s = type_end;
    while (g_ascii_isspace (*s))
      s++;
    if (G_UNLIKELY (*s != ')'))
      return FALSE;
    s++;
    while (g_ascii_isspace (*s))
      s++;

    c = *type_end;
    *type_end = 0;
    type = gst_structure_gtype_from_abbr (type_name);
    GST_DEBUG ("trying type name '%s'", type_name);
    *type_end = c;

    if (G_UNLIKELY (type == G_TYPE_INVALID)) {
      GST_WARNING ("invalid type");
      return FALSE;
    }
  }

  while (g_ascii_isspace (*s))
    s++;
  if (*s == '[') {
    ret = gst_structure_parse_range (s, &s, value, type);
  } else if (*s == '{') {
    ret = gst_structure_parse_list (s, &s, value, type);
  } else if (*s == '<') {
    ret = gst_structure_parse_array (s, &s, value, type);
  } else {
    value_s = s;

    if (G_UNLIKELY (type == G_TYPE_INVALID)) {
      GType try_types[] =
          { G_TYPE_INT, G_TYPE_DOUBLE, GST_TYPE_FRACTION, G_TYPE_BOOLEAN,
        G_TYPE_STRING
      };
      int i;

      if (G_UNLIKELY (!gst_structure_parse_string (s, &value_end, &s, TRUE)))
        return FALSE;
      /* Set NULL terminator for deserialization */
      c = *value_end;
      *value_end = '\0';

      for (i = 0; i < G_N_ELEMENTS (try_types); i++) {
        g_value_init (value, try_types[i]);
        ret = gst_value_deserialize (value, value_s);
        if (ret)
          break;
        g_value_unset (value);
      }
    } else {
      g_value_init (value, type);

      if (G_UNLIKELY (!gst_structure_parse_string (s, &value_end, &s,
                  (type != G_TYPE_STRING))))
        return FALSE;
      /* Set NULL terminator for deserialization */
      c = *value_end;
      *value_end = '\0';

      ret = gst_value_deserialize (value, value_s);
      if (G_UNLIKELY (!ret))
        g_value_unset (value);
    }
    *value_end = c;
  }

  *after = s;

  return ret;
}

gboolean
priv_gst_structure_parse_name (gchar * str, gchar ** start, gchar ** end,
    gchar ** next)
{
  char *w;
  char *r;

  r = str;

  /* skip spaces (FIXME: _isspace treats tabs and newlines as space!) */
  while (*r && (g_ascii_isspace (*r) || (r[0] == '\\'
              && g_ascii_isspace (r[1]))))
    r++;

  *start = r;

  if (G_UNLIKELY (!gst_structure_parse_string (r, &w, &r, TRUE))) {
    GST_WARNING ("Failed to parse structure string '%s'", str);
    return FALSE;
  }

  *end = w;
  *next = r;

  return TRUE;
}

gboolean
priv_gst_structure_parse_fields (gchar * str, gchar ** end,
    GstStructure * structure)
{
  gchar *r;
  GstStructureField field;

  r = str;

  do {
    while (*r && (g_ascii_isspace (*r) || (r[0] == '\\'
                && g_ascii_isspace (r[1]))))
      r++;
    if (*r == ';') {
      /* end of structure, get the next char and finish */
      r++;
      break;
    }
    if (*r == '\0') {
      /* accept \0 as end delimiter */
      break;
    }
    if (G_UNLIKELY (*r != ',')) {
      GST_WARNING ("Failed to find delimiter, r=%s", r);
      return FALSE;
    }
    r++;
    while (*r && (g_ascii_isspace (*r) || (r[0] == '\\'
                && g_ascii_isspace (r[1]))))
      r++;

    memset (&field, 0, sizeof (field));
    if (G_UNLIKELY (!gst_structure_parse_field (r, &r, &field))) {
      GST_WARNING ("Failed to parse field, r=%s", r);
      return FALSE;
    }
    gst_structure_set_field (structure, &field);
  } while (TRUE);

  *end = r;

  return TRUE;
}

/**
 * gst_structure_new_from_string:
 * @string: a string representation of a #GstStructure
 *
 * Creates a #GstStructure from a string representation.
 * If end is not %NULL, a pointer to the place inside the given string
 * where parsing ended will be returned.
 *
 * The current implementation of serialization will lead to unexpected results
 * when there are nested #GstCaps / #GstStructure deeper than one level.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full) (nullable): a new #GstStructure or %NULL
 *     when the string could not be parsed. Free with
 *     gst_structure_free() after use.
 *
 * Since: 1.2
 */
GstStructure *
gst_structure_new_from_string (const gchar * string)
{
  return gst_structure_from_string (string, NULL);
}

/**
 * gst_structure_from_string:
 * @string: a string representation of a #GstStructure.
 * @end: (out) (allow-none) (transfer none) (skip): pointer to store the end of the string in.
 *
 * Creates a #GstStructure from a string representation.
 * If end is not %NULL, a pointer to the place inside the given string
 * where parsing ended will be returned.
 *
 * Free-function: gst_structure_free
 *
 * Returns: (transfer full) (nullable): a new #GstStructure or %NULL
 *     when the string could not be parsed. Free with
 *     gst_structure_free() after use.
 */
GstStructure *
gst_structure_from_string (const gchar * string, gchar ** end)
{
  char *name;
  char *copy;
  char *w;
  char *r;
  char save;
  GstStructure *structure = NULL;

  g_return_val_if_fail (string != NULL, NULL);

  copy = g_strdup (string);
  r = copy;

  if (!priv_gst_structure_parse_name (r, &name, &w, &r))
    goto error;

  save = *w;
  *w = '\0';
  structure = gst_structure_new_empty (name);
  *w = save;

  if (G_UNLIKELY (structure == NULL))
    goto error;

  if (!priv_gst_structure_parse_fields (r, &r, structure))
    goto error;

  if (end)
    *end = (char *) string + (r - copy);
  else if (*r)
    g_warning ("gst_structure_from_string did not consume whole string,"
        " but caller did not provide end pointer (\"%s\")", string);

  g_free (copy);
  return structure;

error:
  if (structure)
    gst_structure_free (structure);
  g_free (copy);
  return NULL;
}

static void
gst_structure_transform_to_string (const GValue * src_value,
    GValue * dest_value)
{
  g_return_if_fail (src_value != NULL);
  g_return_if_fail (dest_value != NULL);

  dest_value->data[0].v_pointer =
      gst_structure_to_string (src_value->data[0].v_pointer);
}

static GstStructure *
gst_structure_copy_conditional (const GstStructure * structure)
{
  if (structure)
    return gst_structure_copy (structure);
  return NULL;
}

/* fixate utility functions */

/**
 * gst_structure_fixate_field_nearest_int:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 * @target: the target value of the fixation
 *
 * Fixates a #GstStructure by changing the given field to the nearest
 * integer to @target that is a subset of the existing field.
 *
 * Returns: %TRUE if the structure could be fixated
 */
gboolean
gst_structure_fixate_field_nearest_int (GstStructure * structure,
    const char *field_name, int target)
{
  const GValue *value;

  g_return_val_if_fail (gst_structure_has_field (structure, field_name), FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);

  value = gst_structure_get_value (structure, field_name);

  if (G_VALUE_TYPE (value) == G_TYPE_INT) {
    /* already fixed */
    return FALSE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_INT_RANGE) {
    int x;

    x = gst_value_get_int_range_min (value);
    if (target < x)
      target = x;
    x = gst_value_get_int_range_max (value);
    if (target > x)
      target = x;
    gst_structure_set (structure, field_name, G_TYPE_INT, target, NULL);
    return TRUE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_LIST) {
    const GValue *list_value;
    int i, n;
    int best = 0;
    int best_index = -1;

    n = gst_value_list_get_size (value);
    for (i = 0; i < n; i++) {
      list_value = gst_value_list_get_value (value, i);
      if (G_VALUE_TYPE (list_value) == G_TYPE_INT) {
        int x = gst_g_value_get_int_unchecked (list_value);

        if (best_index == -1 || (ABS (target - x) < ABS (target - best))) {
          best_index = i;
          best = x;
        }
      }
    }
    if (best_index != -1) {
      gst_structure_set (structure, field_name, G_TYPE_INT, best, NULL);
      return TRUE;
    }
    return FALSE;
  }

  return FALSE;
}

/**
 * gst_structure_fixate_field_nearest_double:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 * @target: the target value of the fixation
 *
 * Fixates a #GstStructure by changing the given field to the nearest
 * double to @target that is a subset of the existing field.
 *
 * Returns: %TRUE if the structure could be fixated
 */
gboolean
gst_structure_fixate_field_nearest_double (GstStructure * structure,
    const char *field_name, double target)
{
  const GValue *value;

  g_return_val_if_fail (gst_structure_has_field (structure, field_name), FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);

  value = gst_structure_get_value (structure, field_name);

  if (G_VALUE_TYPE (value) == G_TYPE_DOUBLE) {
    /* already fixed */
    return FALSE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_DOUBLE_RANGE) {
    double x;

    x = gst_value_get_double_range_min (value);
    if (target < x)
      target = x;
    x = gst_value_get_double_range_max (value);
    if (target > x)
      target = x;
    gst_structure_set (structure, field_name, G_TYPE_DOUBLE, target, NULL);
    return TRUE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_LIST) {
    const GValue *list_value;
    int i, n;
    double best = 0;
    int best_index = -1;

    n = gst_value_list_get_size (value);
    for (i = 0; i < n; i++) {
      list_value = gst_value_list_get_value (value, i);
      if (G_VALUE_TYPE (list_value) == G_TYPE_DOUBLE) {
        double x = gst_g_value_get_double_unchecked (list_value);

        if (best_index == -1 || (ABS (target - x) < ABS (target - best))) {
          best_index = i;
          best = x;
        }
      }
    }
    if (best_index != -1) {
      gst_structure_set (structure, field_name, G_TYPE_DOUBLE, best, NULL);
      return TRUE;
    }
    return FALSE;
  }

  return FALSE;

}

/**
 * gst_structure_fixate_field_boolean:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 * @target: the target value of the fixation
 *
 * Fixates a #GstStructure by changing the given @field_name field to the given
 * @target boolean if that field is not fixed yet.
 *
 * Returns: %TRUE if the structure could be fixated
 */
gboolean
gst_structure_fixate_field_boolean (GstStructure * structure,
    const char *field_name, gboolean target)
{
  const GValue *value;

  g_return_val_if_fail (gst_structure_has_field (structure, field_name), FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);

  value = gst_structure_get_value (structure, field_name);

  if (G_VALUE_TYPE (value) == G_TYPE_BOOLEAN) {
    /* already fixed */
    return FALSE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_LIST) {
    const GValue *list_value;
    int i, n;
    int best = 0;
    int best_index = -1;

    n = gst_value_list_get_size (value);
    for (i = 0; i < n; i++) {
      list_value = gst_value_list_get_value (value, i);
      if (G_VALUE_TYPE (list_value) == G_TYPE_BOOLEAN) {
        gboolean x = gst_g_value_get_boolean_unchecked (list_value);

        if (best_index == -1 || x == target) {
          best_index = i;
          best = x;
        }
      }
    }
    if (best_index != -1) {
      gst_structure_set (structure, field_name, G_TYPE_BOOLEAN, best, NULL);
      return TRUE;
    }
    return FALSE;
  }

  return FALSE;
}

/**
 * gst_structure_fixate_field_string:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 * @target: the target value of the fixation
 *
 * Fixates a #GstStructure by changing the given @field_name field to the given
 * @target string if that field is not fixed yet.
 *
 * Returns: %TRUE if the structure could be fixated
 */
gboolean
gst_structure_fixate_field_string (GstStructure * structure,
    const gchar * field_name, const gchar * target)
{
  const GValue *value;

  g_return_val_if_fail (gst_structure_has_field (structure, field_name), FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);

  value = gst_structure_get_value (structure, field_name);

  if (G_VALUE_TYPE (value) == G_TYPE_STRING) {
    /* already fixed */
    return FALSE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_LIST) {
    const GValue *list_value;
    int i, n;
    const gchar *best = NULL;
    int best_index = -1;

    n = gst_value_list_get_size (value);
    for (i = 0; i < n; i++) {
      list_value = gst_value_list_get_value (value, i);
      if (G_VALUE_TYPE (list_value) == G_TYPE_STRING) {
        const gchar *x = g_value_get_string (list_value);

        if (best_index == -1 || g_str_equal (x, target)) {
          best_index = i;
          best = x;
        }
      }
    }
    if (best_index != -1) {
      gst_structure_set (structure, field_name, G_TYPE_STRING, best, NULL);
      return TRUE;
    }
    return FALSE;
  }

  return FALSE;
}

/**
 * gst_structure_fixate_field_nearest_fraction:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 * @target_numerator: The numerator of the target value of the fixation
 * @target_denominator: The denominator of the target value of the fixation
 *
 * Fixates a #GstStructure by changing the given field to the nearest
 * fraction to @target_numerator/@target_denominator that is a subset
 * of the existing field.
 *
 * Returns: %TRUE if the structure could be fixated
 */
gboolean
gst_structure_fixate_field_nearest_fraction (GstStructure * structure,
    const char *field_name, const gint target_numerator,
    const gint target_denominator)
{
  const GValue *value;

  g_return_val_if_fail (gst_structure_has_field (structure, field_name), FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);
  g_return_val_if_fail (target_denominator != 0, FALSE);

  value = gst_structure_get_value (structure, field_name);

  if (G_VALUE_TYPE (value) == GST_TYPE_FRACTION) {
    /* already fixed */
    return FALSE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_FRACTION_RANGE) {
    const GValue *x, *new_value;
    GValue target = { 0 };
    g_value_init (&target, GST_TYPE_FRACTION);
    gst_value_set_fraction (&target, target_numerator, target_denominator);

    new_value = &target;
    x = gst_value_get_fraction_range_min (value);
    if (gst_value_compare (&target, x) == GST_VALUE_LESS_THAN)
      new_value = x;
    x = gst_value_get_fraction_range_max (value);
    if (gst_value_compare (&target, x) == GST_VALUE_GREATER_THAN)
      new_value = x;

    gst_structure_set_value (structure, field_name, new_value);
    g_value_unset (&target);
    return TRUE;
  } else if (G_VALUE_TYPE (value) == GST_TYPE_LIST) {
    const GValue *list_value;
    int i, n;
    const GValue *best = NULL;
    gdouble target;
    gdouble cur_diff;
    gdouble best_diff = G_MAXDOUBLE;

    target = (gdouble) target_numerator / (gdouble) target_denominator;

    GST_DEBUG ("target %g, best %g", target, best_diff);

    best = NULL;

    n = gst_value_list_get_size (value);
    for (i = 0; i < n; i++) {
      list_value = gst_value_list_get_value (value, i);
      if (G_VALUE_TYPE (list_value) == GST_TYPE_FRACTION) {
        gint num, denom;
        gdouble list_double;

        num = gst_value_get_fraction_numerator (list_value);
        denom = gst_value_get_fraction_denominator (list_value);

        list_double = ((gdouble) num / (gdouble) denom);
        cur_diff = target - list_double;

        GST_DEBUG ("curr diff %g, list %g", cur_diff, list_double);

        if (cur_diff < 0)
          cur_diff = -cur_diff;

        if (!best || cur_diff < best_diff) {
          GST_DEBUG ("new best %g", list_double);
          best = list_value;
          best_diff = cur_diff;
        }
      }
    }
    if (best != NULL) {
      gst_structure_set_value (structure, field_name, best);
      return TRUE;
    }
  }

  return FALSE;
}

static gboolean
default_fixate (GQuark field_id, const GValue * value, gpointer data)
{
  GstStructure *s = data;
  GValue v = { 0 };

  if (gst_value_fixate (&v, value)) {
    gst_structure_id_take_value (s, field_id, &v);
  }
  return TRUE;
}

/**
 * gst_structure_fixate_field:
 * @structure: a #GstStructure
 * @field_name: a field in @structure
 *
 * Fixates a #GstStructure by changing the given field with its fixated value.
 *
 * Returns: %TRUE if the structure field could be fixated
 */
gboolean
gst_structure_fixate_field (GstStructure * structure, const char *field_name)
{
  GstStructureField *field;

  g_return_val_if_fail (structure != NULL, FALSE);
  g_return_val_if_fail (IS_MUTABLE (structure), FALSE);

  if (!(field = gst_structure_get_field (structure, field_name)))
    return FALSE;

  return default_fixate (field->name, &field->value, structure);
}

/* our very own version of G_VALUE_LCOPY that allows NULL return locations
 * (useful for message parsing functions where the return location is user
 * supplied and the user may pass %NULL if the value isn't of interest) */
#define GST_VALUE_LCOPY(value, var_args, flags, __error, fieldname)           \
G_STMT_START {                                                                \
  const GValue *_value = (value);                                             \
  guint _flags = (flags);                                                     \
  GType _value_type = G_VALUE_TYPE (_value);                                  \
  GTypeValueTable *_vtable = g_type_value_table_peek (_value_type);           \
  const gchar *_lcopy_format = _vtable->lcopy_format;                         \
  GTypeCValue _cvalues[G_VALUE_COLLECT_FORMAT_MAX_LENGTH] = { { 0, }, };      \
  guint _n_values = 0;                                                        \
                                                                              \
  while (*_lcopy_format != '\0') {                                            \
    g_assert (*_lcopy_format == G_VALUE_COLLECT_POINTER);                     \
    _cvalues[_n_values++].v_pointer = va_arg ((var_args), gpointer);          \
    _lcopy_format++;                                                          \
  }                                                                           \
  if (_n_values == 2 && !!_cvalues[0].v_pointer != !!_cvalues[1].v_pointer) { \
    *(__error) = g_strdup_printf ("either all or none of the return "         \
        "locations for field '%s' need to be NULL", fieldname);               \
  } else if (_cvalues[0].v_pointer != NULL) {                                 \
    *(__error) = _vtable->lcopy_value (_value, _n_values, _cvalues, _flags);  \
  }                                                                           \
} G_STMT_END

/**
 * gst_structure_get_valist:
 * @structure: a #GstStructure
 * @first_fieldname: the name of the first field to read
 * @args: variable arguments
 *
 * Parses the variable arguments and reads fields from @structure accordingly.
 * valist-variant of gst_structure_get(). Look at the documentation of
 * gst_structure_get() for more details.
 *
 * Returns: %TRUE, or %FALSE if there was a problem reading any of the fields
 */
gboolean
gst_structure_get_valist (const GstStructure * structure,
    const char *first_fieldname, va_list args)
{
  const char *field_name;
  GType expected_type = G_TYPE_INVALID;

  g_return_val_if_fail (GST_IS_STRUCTURE (structure), FALSE);
  g_return_val_if_fail (first_fieldname != NULL, FALSE);

  field_name = first_fieldname;
  while (field_name) {
    const GValue *val = NULL;
    gchar *err = NULL;

    expected_type = va_arg (args, GType);

    val = gst_structure_get_value (structure, field_name);

    if (val == NULL)
      goto no_such_field;

    if (G_VALUE_TYPE (val) != expected_type)
      goto wrong_type;

    GST_VALUE_LCOPY (val, args, 0, &err, field_name);
    if (err) {
      g_warning ("%s: %s", G_STRFUNC, err);
      g_free (err);
      return FALSE;
    }

    field_name = va_arg (args, const gchar *);
  }

  return TRUE;

/* ERRORS */
no_such_field:
  {
    GST_INFO ("Expected field '%s' in structure: %" GST_PTR_FORMAT,
        field_name, structure);
    return FALSE;
  }
wrong_type:
  {
    GST_INFO ("Expected field '%s' in structure to be of type '%s', but "
        "field was of type '%s': %" GST_PTR_FORMAT, field_name,
        GST_STR_NULL (g_type_name (expected_type)),
        G_VALUE_TYPE_NAME (gst_structure_get_value (structure, field_name)),
        structure);
    return FALSE;
  }
}

/**
 * gst_structure_id_get_valist:
 * @structure: a #GstStructure
 * @first_field_id: the quark of the first field to read
 * @args: variable arguments
 *
 * Parses the variable arguments and reads fields from @structure accordingly.
 * valist-variant of gst_structure_id_get(). Look at the documentation of
 * gst_structure_id_get() for more details.
 *
 * Returns: %TRUE, or %FALSE if there was a problem reading any of the fields
 */
gboolean
gst_structure_id_get_valist (const GstStructure * structure,
    GQuark first_field_id, va_list args)
{
  GQuark field_id;
  GType expected_type = G_TYPE_INVALID;

  g_return_val_if_fail (GST_IS_STRUCTURE (structure), FALSE);
  g_return_val_if_fail (first_field_id != 0, FALSE);

  field_id = first_field_id;
  while (field_id) {
    const GValue *val = NULL;
    gchar *err = NULL;

    expected_type = va_arg (args, GType);

    val = gst_structure_id_get_value (structure, field_id);

    if (val == NULL)
      goto no_such_field;

    if (G_VALUE_TYPE (val) != expected_type)
      goto wrong_type;

    GST_VALUE_LCOPY (val, args, 0, &err, g_quark_to_string (field_id));
    if (err) {
      g_warning ("%s: %s", G_STRFUNC, err);
      g_free (err);
      return FALSE;
    }

    field_id = va_arg (args, GQuark);
  }

  return TRUE;

/* ERRORS */
no_such_field:
  {
    GST_DEBUG ("Expected field '%s' in structure: %" GST_PTR_FORMAT,
        GST_STR_NULL (g_quark_to_string (field_id)), structure);
    return FALSE;
  }
wrong_type:
  {
    GST_DEBUG ("Expected field '%s' in structure to be of type '%s', but "
        "field was of type '%s': %" GST_PTR_FORMAT,
        g_quark_to_string (field_id),
        GST_STR_NULL (g_type_name (expected_type)),
        G_VALUE_TYPE_NAME (gst_structure_id_get_value (structure, field_id)),
        structure);
    return FALSE;
  }
}

/**
 * gst_structure_get:
 * @structure: a #GstStructure
 * @first_fieldname: the name of the first field to read
 * @...: variable arguments
 *
 * Parses the variable arguments and reads fields from @structure accordingly.
 * Variable arguments should be in the form field name, field type
 * (as a GType), pointer(s) to a variable(s) to hold the return value(s).
 * The last variable argument should be %NULL.
 *
 * For refcounted (mini)objects you will receive a new reference which
 * you must release with a suitable _unref() when no longer needed. For
 * strings and boxed types you will receive a copy which you will need to
 * release with either g_free() or the suitable function for the boxed type.
 *
 * Returns: %FALSE if there was a problem reading any of the fields (e.g.
 *     because the field requested did not exist, or was of a type other
 *     than the type specified), otherwise %TRUE.
 */
gboolean
gst_structure_get (const GstStructure * structure, const char *first_fieldname,
    ...)
{
  gboolean ret;
  va_list args;

  g_return_val_if_fail (GST_IS_STRUCTURE (structure), FALSE);
  g_return_val_if_fail (first_fieldname != NULL, FALSE);

  va_start (args, first_fieldname);
  ret = gst_structure_get_valist (structure, first_fieldname, args);
  va_end (args);

  return ret;
}

/**
 * gst_structure_id_get:
 * @structure: a #GstStructure
 * @first_field_id: the quark of the first field to read
 * @...: variable arguments
 *
 * Parses the variable arguments and reads fields from @structure accordingly.
 * Variable arguments should be in the form field id quark, field type
 * (as a GType), pointer(s) to a variable(s) to hold the return value(s).
 * The last variable argument should be %NULL (technically it should be a
 * 0 quark, but we require %NULL so compilers that support it can check for
 * the %NULL terminator and warn if it's not there).
 *
 * This function is just like gst_structure_get() only that it is slightly
 * more efficient since it saves the string-to-quark lookup in the global
 * quark hashtable.
 *
 * For refcounted (mini)objects you will receive a new reference which
 * you must release with a suitable _unref() when no longer needed. For
 * strings and boxed types you will receive a copy which you will need to
 * release with either g_free() or the suitable function for the boxed type.
 *
 * Returns: %FALSE if there was a problem reading any of the fields (e.g.
 *     because the field requested did not exist, or was of a type other
 *     than the type specified), otherwise %TRUE.
 */
gboolean
gst_structure_id_get (const GstStructure * structure, GQuark first_field_id,
    ...)
{
  gboolean ret;
  va_list args;

  g_return_val_if_fail (GST_IS_STRUCTURE (structure), FALSE);
  g_return_val_if_fail (first_field_id != 0, FALSE);

  va_start (args, first_field_id);
  ret = gst_structure_id_get_valist (structure, first_field_id, args);
  va_end (args);

  return ret;
}

static gboolean
gst_structure_is_equal_foreach (GQuark field_id, const GValue * val2,
    gpointer data)
{
  const GstStructure *struct1 = (const GstStructure *) data;
  const GValue *val1 = gst_structure_id_get_value (struct1, field_id);

  if (G_UNLIKELY (val1 == NULL))
    return FALSE;
  if (gst_value_compare (val1, val2) == GST_VALUE_EQUAL) {
    return TRUE;
  }

  return FALSE;
}

/**
 * gst_structure_is_equal:
 * @structure1: a #GstStructure.
 * @structure2: a #GstStructure.
 *
 * Tests if the two #GstStructure are equal.
 *
 * Returns: %TRUE if the two structures have the same name and field.
 **/
gboolean
gst_structure_is_equal (const GstStructure * structure1,
    const GstStructure * structure2)
{
  g_return_val_if_fail (GST_IS_STRUCTURE (structure1), FALSE);
  g_return_val_if_fail (GST_IS_STRUCTURE (structure2), FALSE);

  if (G_UNLIKELY (structure1 == structure2))
    return TRUE;

  if (structure1->name != structure2->name) {
    return FALSE;
  }
  if (GST_STRUCTURE_FIELDS (structure1)->len !=
      GST_STRUCTURE_FIELDS (structure2)->len) {
    return FALSE;
  }

  return gst_structure_foreach (structure1, gst_structure_is_equal_foreach,
      (gpointer) structure2);
}


typedef struct
{
  GstStructure *dest;
  const GstStructure *intersect;
}
IntersectData;

static gboolean
gst_structure_intersect_field1 (GQuark id, const GValue * val1, gpointer data)
{
  IntersectData *idata = (IntersectData *) data;
  const GValue *val2 = gst_structure_id_get_value (idata->intersect, id);

  if (G_UNLIKELY (val2 == NULL)) {
    gst_structure_id_set_value (idata->dest, id, val1);
  } else {
    GValue dest_value = { 0 };
    if (gst_value_intersect (&dest_value, val1, val2)) {
      gst_structure_id_take_value (idata->dest, id, &dest_value);
    } else {
      return FALSE;
    }
  }
  return TRUE;
}

static gboolean
gst_structure_intersect_field2 (GQuark id, const GValue * val1, gpointer data)
{
  IntersectData *idata = (IntersectData *) data;
  const GValue *val2 = gst_structure_id_get_value (idata->intersect, id);

  if (G_UNLIKELY (val2 == NULL)) {
    gst_structure_id_set_value (idata->dest, id, val1);
  }
  return TRUE;
}

/**
 * gst_structure_intersect:
 * @struct1: a #GstStructure
 * @struct2: a #GstStructure
 *
 * Intersects @struct1 and @struct2 and returns the intersection.
 *
 * Returns: Intersection of @struct1 and @struct2
 */
GstStructure *
gst_structure_intersect (const GstStructure * struct1,
    const GstStructure * struct2)
{
  IntersectData data;

  g_assert (struct1 != NULL);
  g_assert (struct2 != NULL);

  if (G_UNLIKELY (struct1->name != struct2->name))
    return NULL;

  /* copy fields from struct1 which we have not in struct2 to target
   * intersect if we have the field in both */
  data.dest = gst_structure_new_id_empty (struct1->name);
  data.intersect = struct2;
  if (G_UNLIKELY (!gst_structure_foreach ((GstStructure *) struct1,
              gst_structure_intersect_field1, &data)))
    goto error;

  /* copy fields from struct2 which we have not in struct1 to target */
  data.intersect = struct1;
  if (G_UNLIKELY (!gst_structure_foreach ((GstStructure *) struct2,
              gst_structure_intersect_field2, &data)))
    goto error;

  return data.dest;

error:
  gst_structure_free (data.dest);
  return NULL;
}

static gboolean
gst_caps_structure_can_intersect_field (GQuark id, const GValue * val1,
    gpointer data)
{
  GstStructure *other = (GstStructure *) data;
  const GValue *val2 = gst_structure_id_get_value (other, id);

  if (G_LIKELY (val2)) {
    if (!gst_value_can_intersect (val1, val2)) {
      return FALSE;
    } else {
      gint eq = gst_value_compare (val1, val2);

      if (eq == GST_VALUE_UNORDERED) {
        /* we need to try interseting */
        if (!gst_value_intersect (NULL, val1, val2)) {
          return FALSE;
        }
      } else if (eq != GST_VALUE_EQUAL) {
        return FALSE;
      }
    }
  }
  return TRUE;
}

/**
 * gst_structure_can_intersect:
 * @struct1: a #GstStructure
 * @struct2: a #GstStructure
 *
 * Tries intersecting @struct1 and @struct2 and reports whether the result
 * would not be empty.
 *
 * Returns: %TRUE if intersection would not be empty
 */
gboolean
gst_structure_can_intersect (const GstStructure * struct1,
    const GstStructure * struct2)
{
  g_return_val_if_fail (GST_IS_STRUCTURE (struct1), FALSE);
  g_return_val_if_fail (GST_IS_STRUCTURE (struct2), FALSE);

  if (G_UNLIKELY (struct1->name != struct2->name))
    return FALSE;

  /* tries to intersect if we have the field in both */
  return gst_structure_foreach ((GstStructure *) struct1,
      gst_caps_structure_can_intersect_field, (gpointer) struct2);
}

static gboolean
gst_caps_structure_is_superset_field (GQuark field_id, const GValue * value,
    gpointer user_data)
{
  GstStructure *subset = user_data;
  const GValue *other;
  int comparison;

  if (!(other = gst_structure_id_get_value (subset, field_id)))
    /* field is missing in the subset => no subset */
    return FALSE;

  comparison = gst_value_compare (value, other);

  /* equal values are subset */
  if (comparison == GST_VALUE_EQUAL)
    return TRUE;

  /* ordered, but unequal, values are not */
  if (comparison != GST_VALUE_UNORDERED)
    return FALSE;

  return gst_value_is_subset (other, value);
}

/**
 * gst_structure_is_subset:
 * @subset: a #GstStructure
 * @superset: a potentially greater #GstStructure
 *
 * Checks if @subset is a subset of @superset, i.e. has the same
 * structure name and for all fields that are existing in @superset,
 * @subset has a value that is a subset of the value in @superset.
 *
 * Returns: %TRUE if @subset is a subset of @superset
 */
gboolean
gst_structure_is_subset (const GstStructure * subset,
    const GstStructure * superset)
{
  if ((superset->name != subset->name) ||
      (gst_structure_n_fields (superset) > gst_structure_n_fields (subset)))
    return FALSE;

  return gst_structure_foreach ((GstStructure *) superset,
      gst_caps_structure_is_superset_field, (gpointer) subset);
}


/**
 * gst_structure_fixate:
 * @structure: a #GstStructure
 *
 * Fixate all values in @structure using gst_value_fixate().
 * @structure will be modified in-place and should be writable.
 */
void
gst_structure_fixate (GstStructure * structure)
{
  g_return_if_fail (GST_IS_STRUCTURE (structure));

  gst_structure_foreach (structure, default_fixate, structure);
}
