/* GStreamer
 * Copyright (C) 2001 RidgeRun (http://www.ridgerun.com/)
 * Written by Erik Walthinsen <omega@ridgerun.com>
 *
 * gstindex.c: Index for mappings and other data
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
 * SECTION:gstindex
 * @short_description: Generate indexes on objects
 * @see_also: #GstIndexFactory
 *
 * #GstIndex is used to generate a stream index of one or more elements
 * in a pipeline.
 *
 * Elements will overload the set_index and get_index virtual methods in
 * #GstElement. When streaming data, the element will add index entries if it
 * has an index set.
 *
 * Each element that adds to the index will do that using a writer_id. The
 * writer_id is obtained from gst_index_get_writer_id().
 *
 * The application that wants to index the stream will create a new index object
 * using gst_index_new() or gst_index_factory_make(). The index is assigned to a
 * specific element, a bin or the whole pipeline. This will cause indexable
 * elements to add entires to the index while playing.
 */

/* FIXME: complete gobject annotations */
/* FIXME-0.11: cleanup API
 * - no one seems to use GstIndexGroup, GstIndexCertainty
 *
 * - the API for application to use the index is mostly missing
 *   - apps need to get a list of writers
 *   - apps need to be able to iterate over each writers index entry collection
 * - gst_index_get_assoc_entry() should pass ownership
 *   - the GstIndexEntry structure is large and contains repetitive information
 *   - we want to allow Indexers to implement a saner storage and create
 *     GstIndexEntries on demand (the app has to free them), might even make
 *     sense to ask the app to provide a ptr and fill it.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>

/* Index signals and args */
enum
{
  ENTRY_ADDED,
  LAST_SIGNAL
};

enum
{
  ARG_0,
  ARG_RESOLVER
      /* FILL ME */
};

#if 0
GST_DEBUG_CATEGORY_STATIC (index_debug);
#define GST_CAT_DEFAULT index_debug
#endif

static void gst_index_finalize (GObject * object);

static void gst_index_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_index_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static GstIndexGroup *gst_index_group_new (guint groupnum);
static void gst_index_group_free (GstIndexGroup * group);

static gboolean gst_index_path_resolver (GstIndex * index, GstObject * writer,
    gchar ** writer_string, gpointer data);
static gboolean gst_index_gtype_resolver (GstIndex * index, GstObject * writer,
    gchar ** writer_string, gpointer data);
static void gst_index_add_entry (GstIndex * index, GstIndexEntry * entry);

static guint gst_index_signals[LAST_SIGNAL] = { 0 };

typedef struct
{
  GstIndexResolverMethod method;
  GstIndexResolver resolver;
  gpointer user_data;
}
ResolverEntry;

static const ResolverEntry resolvers[] = {
  {GST_INDEX_RESOLVER_CUSTOM, NULL, NULL},
  {GST_INDEX_RESOLVER_GTYPE, gst_index_gtype_resolver, NULL},
  {GST_INDEX_RESOLVER_PATH, gst_index_path_resolver, NULL},
};

#define GST_TYPE_INDEX_RESOLVER (gst_index_resolver_get_type())
static GType
gst_index_resolver_get_type (void)
{
  static GType index_resolver_type = 0;
  static const GEnumValue index_resolver[] = {
    {GST_INDEX_RESOLVER_CUSTOM, "GST_INDEX_RESOLVER_CUSTOM", "custom"},
    {GST_INDEX_RESOLVER_GTYPE, "GST_INDEX_RESOLVER_GTYPE", "gtype"},
    {GST_INDEX_RESOLVER_PATH, "GST_INDEX_RESOLVER_PATH", "path"},
    {0, NULL, NULL},
  };

  if (!index_resolver_type) {
    index_resolver_type =
        g_enum_register_static ("GstIndexResolver", index_resolver);
  }
  return index_resolver_type;
}

G_DEFINE_BOXED_TYPE (GstIndexEntry, gst_index_entry,
    (GBoxedCopyFunc) gst_index_entry_copy,
    (GBoxedFreeFunc) gst_index_entry_free);

#if 0
#define _do_init \
{ \
  GST_DEBUG_CATEGORY_INIT (index_debug, "GST_INDEX", GST_DEBUG_BOLD, \
      "Generic indexing support"); \
}
#endif

G_DEFINE_TYPE (GstIndex, gst_index, GST_TYPE_OBJECT);

static void
gst_index_class_init (GstIndexClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  /**
   * GstIndex::entry-added
   * @gstindex: the object which received the signal.
   * @arg1: The entry added to the index.
   *
   * Is emitted when a new entry is added to the index.
   */
  gst_index_signals[ENTRY_ADDED] =
      g_signal_new ("entry-added", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstIndexClass, entry_added), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_INDEX_ENTRY);

  gobject_class->set_property = gst_index_set_property;
  gobject_class->get_property = gst_index_get_property;
  gobject_class->finalize = gst_index_finalize;

  g_object_class_install_property (gobject_class, ARG_RESOLVER,
      g_param_spec_enum ("resolver", "Resolver",
          "Select a predefined object to string mapper",
          GST_TYPE_INDEX_RESOLVER, GST_INDEX_RESOLVER_PATH,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

static void
gst_index_init (GstIndex * index)
{
  index->curgroup = gst_index_group_new (0);
  index->maxgroup = 0;
  index->groups = g_list_prepend (NULL, index->curgroup);

  index->writers = g_hash_table_new (NULL, NULL);
  index->last_id = 0;

  index->method = GST_INDEX_RESOLVER_PATH;
  index->resolver = resolvers[index->method].resolver;
  index->resolver_user_data = resolvers[index->method].user_data;

  GST_OBJECT_FLAG_SET (index, GST_INDEX_WRITABLE);
  GST_OBJECT_FLAG_SET (index, GST_INDEX_READABLE);

  GST_DEBUG ("created new index");
}

static void
gst_index_free_writer (gpointer key, gpointer value, gpointer user_data)
{
  GstIndexEntry *entry = (GstIndexEntry *) value;

  if (entry) {
    gst_index_entry_free (entry);
  }
}

static void
gst_index_finalize (GObject * object)
{
  GstIndex *index = GST_INDEX (object);

  if (index->groups) {
    g_list_foreach (index->groups, (GFunc) gst_index_group_free, NULL);
    g_list_free (index->groups);
    index->groups = NULL;
  }

  if (index->writers) {
    g_hash_table_foreach (index->writers, gst_index_free_writer, NULL);
    g_hash_table_destroy (index->writers);
    index->writers = NULL;
  }

  if (index->filter_user_data && index->filter_user_data_destroy)
    index->filter_user_data_destroy (index->filter_user_data);

  if (index->resolver_user_data && index->resolver_user_data_destroy)
    index->resolver_user_data_destroy (index->resolver_user_data);

  G_OBJECT_CLASS (gst_index_parent_class)->finalize (object);
}

static void
gst_index_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstIndex *index;

  index = GST_INDEX (object);

  switch (prop_id) {
    case ARG_RESOLVER:
      index->method = (GstIndexResolverMethod) g_value_get_enum (value);
      index->resolver = resolvers[index->method].resolver;
      index->resolver_user_data = resolvers[index->method].user_data;
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_index_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstIndex *index;

  index = GST_INDEX (object);

  switch (prop_id) {
    case ARG_RESOLVER:
      g_value_set_enum (value, index->method);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstIndexGroup *
gst_index_group_new (guint groupnum)
{
  GstIndexGroup *indexgroup = g_slice_new (GstIndexGroup);

  indexgroup->groupnum = groupnum;
  indexgroup->entries = NULL;
  indexgroup->certainty = GST_INDEX_UNKNOWN;
  indexgroup->peergroup = -1;

  GST_DEBUG ("created new index group %d", groupnum);

  return indexgroup;
}

static void
gst_index_group_free (GstIndexGroup * group)
{
  g_slice_free (GstIndexGroup, group);
}

/* do not resurrect this, add a derived dummy index class instead */
#if 0
/**
 * gst_index_new:
 *
 * Create a new dummy index object. Use gst_element_set_index() to assign that
 * to an element or pipeline. This index is not storing anything, but will
 * still emit e.g. the #GstIndex::entry-added signal.
 *
 * Returns: (transfer full): a new index object
 */
GstIndex *
gst_index_new (void)
{
  GstIndex *index;

  index = g_object_newv (gst_index_get_type (), 0, NULL);

  return index;
}

/**
 * gst_index_commit:
 * @index: the index to commit
 * @id: the writer that commited the index
 *
 * Tell the index that the writer with the given id is done
 * with this index and is not going to write any more entries
 * to it.
 */
void
gst_index_commit (GstIndex * index, gint id)
{
  GstIndexClass *iclass;

  iclass = GST_INDEX_GET_CLASS (index);

  if (iclass->commit)
    iclass->commit (index, id);
}

/**
 * gst_index_get_group:
 * @index: the index to get the current group from
 *
 * Get the id of the current group.
 *
 * Returns: the id of the current group.
 */
gint
gst_index_get_group (GstIndex * index)
{
  return index->curgroup->groupnum;
}

/**
 * gst_index_new_group:
 * @index: the index to create the new group in
 *
 * Create a new group for the given index. It will be
 * set as the current group.
 *
 * Returns: the id of the newly created group.
 */
gint
gst_index_new_group (GstIndex * index)
{
  index->curgroup = gst_index_group_new (++index->maxgroup);
  index->groups = g_list_append (index->groups, index->curgroup);
  GST_DEBUG ("created new group %d in index", index->maxgroup);
  return index->maxgroup;
}

/**
 * gst_index_set_group:
 * @index: the index to set the new group in
 * @groupnum: the groupnumber to set
 *
 * Set the current groupnumber to the given argument.
 *
 * Returns: %TRUE if the operation succeeded, %FALSE if the group
 * did not exist.
 */
gboolean
gst_index_set_group (GstIndex * index, gint groupnum)
{
  GList *list;
  GstIndexGroup *indexgroup;

  /* first check for null change */
  if (groupnum == index->curgroup->groupnum)
    return TRUE;

  /* else search for the proper group */
  list = index->groups;
  while (list) {
    indexgroup = (GstIndexGroup *) (list->data);
    list = g_list_next (list);
    if (indexgroup->groupnum == groupnum) {
      index->curgroup = indexgroup;
      GST_DEBUG ("switched to index group %d", indexgroup->groupnum);
      return TRUE;
    }
  }

  /* couldn't find the group in question */
  GST_DEBUG ("couldn't find index group %d", groupnum);
  return FALSE;
}
#endif

#if 0
/**
 * gst_index_set_certainty:
 * @index: the index to set the certainty on
 * @certainty: the certainty to set
 *
 * Set the certainty of the given index.
 */
void
gst_index_set_certainty (GstIndex * index, GstIndexCertainty certainty)
{
  index->curgroup->certainty = certainty;
}

/**
 * gst_index_get_certainty:
 * @index: the index to get the certainty of
 *
 * Get the certainty of the given index.
 *
 * Returns: the certainty of the index.
 */
GstIndexCertainty
gst_index_get_certainty (GstIndex * index)
{
  return index->curgroup->certainty;
}
#endif

#if 0
/**
 * gst_index_set_filter:
 * @index: the index to register the filter on
 * @filter: the filter to register
 * @user_data: data passed to the filter function
 *
 * Lets the app register a custom filter function so that
 * it can select what entries should be stored in the index.
 */
void
gst_index_set_filter (GstIndex * index,
    GstIndexFilter filter, gpointer user_data)
{
  g_return_if_fail (GST_IS_INDEX (index));

  gst_index_set_filter_full (index, filter, user_data, NULL);
}

/**
 * gst_index_set_filter_full:
 * @index: the index to register the filter on
 * @filter: the filter to register
 * @user_data: data passed to the filter function
 * @user_data_destroy: function to call when @user_data is unset
 *
 * Lets the app register a custom filter function so that
 * it can select what entries should be stored in the index.
 */
void
gst_index_set_filter_full (GstIndex * index,
    GstIndexFilter filter, gpointer user_data, GDestroyNotify user_data_destroy)
{
  g_return_if_fail (GST_IS_INDEX (index));

  if (index->filter_user_data && index->filter_user_data_destroy)
    index->filter_user_data_destroy (index->filter_user_data);

  index->filter = filter;
  index->filter_user_data = user_data;
  index->filter_user_data_destroy = user_data_destroy;
}

/**
 * gst_index_set_resolver:
 * @index: the index to register the resolver on
 * @resolver: the resolver to register
 * @user_data: data passed to the resolver function
 *
 * Lets the app register a custom function to map index
 * ids to writer descriptions.
 */
void
gst_index_set_resolver (GstIndex * index,
    GstIndexResolver resolver, gpointer user_data)
{
  gst_index_set_resolver_full (index, resolver, user_data, NULL);
}

/**
 * gst_index_set_resolver_full:
 * @index: the index to register the resolver on
 * @resolver: the resolver to register
 * @user_data: data passed to the resolver function
 * @user_data_destroy: destroy function for @user_data
 *
 * Lets the app register a custom function to map index
 * ids to writer descriptions.
 */
void
gst_index_set_resolver_full (GstIndex * index, GstIndexResolver resolver,
    gpointer user_data, GDestroyNotify user_data_destroy)
{
  g_return_if_fail (GST_IS_INDEX (index));

  if (index->resolver_user_data && index->resolver_user_data_destroy)
    index->resolver_user_data_destroy (index->resolver_user_data);

  index->resolver = resolver;
  index->resolver_user_data = user_data;
  index->resolver_user_data_destroy = user_data_destroy;
  index->method = GST_INDEX_RESOLVER_CUSTOM;
}
#endif

/**
 * gst_index_entry_copy:
 * @entry: the entry to copy
 *
 * Copies an entry and returns the result.
 *
 * Free-function: gst_index_entry_free
 *
 * Returns: (transfer full): a newly allocated #GstIndexEntry.
 */
GstIndexEntry *
gst_index_entry_copy (GstIndexEntry * entry)
{
  GstIndexEntry *new_entry = g_slice_new (GstIndexEntry);

  memcpy (new_entry, entry, sizeof (GstIndexEntry));
  return new_entry;
}

/**
 * gst_index_entry_free:
 * @entry: (transfer full): the entry to free
 *
 * Free the memory used by the given entry.
 */
void
gst_index_entry_free (GstIndexEntry * entry)
{
  switch (entry->type) {
    case GST_INDEX_ENTRY_ID:
      if (entry->data.id.description) {
        g_free (entry->data.id.description);
        entry->data.id.description = NULL;
      }
      break;
    case GST_INDEX_ENTRY_ASSOCIATION:
      if (entry->data.assoc.assocs) {
        g_free (entry->data.assoc.assocs);
        entry->data.assoc.assocs = NULL;
      }
      break;
    case GST_INDEX_ENTRY_OBJECT:
      break;
    case GST_INDEX_ENTRY_FORMAT:
      break;
  }

  g_slice_free (GstIndexEntry, entry);
}

#if 0
/**
 * gst_index_add_format:
 * @index: the index to add the entry to
 * @id: the id of the index writer
 * @format: the format to add to the index
 *
 * Adds a format entry into the index. This function is
 * used to map dynamic #GstFormat ids to their original
 * format key.
 *
 * Free-function: gst_index_entry_free
 *
 * Returns: (transfer full): a pointer to the newly added entry in the index.
 */
GstIndexEntry *
gst_index_add_format (GstIndex * index, gint id, GstFormat format)
{
  GstIndexEntry *entry;
  const GstFormatDefinition *def;

  g_return_val_if_fail (GST_IS_INDEX (index), NULL);
  g_return_val_if_fail (format != 0, NULL);

  if (!GST_INDEX_IS_WRITABLE (index) || id == -1)
    return NULL;

  entry = g_slice_new (GstIndexEntry);
  entry->type = GST_INDEX_ENTRY_FORMAT;
  entry->id = id;
  entry->data.format.format = format;

  def = gst_format_get_details (format);
  entry->data.format.key = def->nick;

  gst_index_add_entry (index, entry);

  return entry;
}
#endif

/**
 * gst_index_add_id:
 * @index: the index to add the entry to
 * @id: the id of the index writer
 * @description: the description of the index writer
 *
 * Add an id entry into the index.
 *
 * Returns: a pointer to the newly added entry in the index.
 */
GstIndexEntry *
gst_index_add_id (GstIndex * index, gint id, gchar * description)
{
  GstIndexEntry *entry;

  g_return_val_if_fail (GST_IS_INDEX (index), NULL);
  g_return_val_if_fail (description != NULL, NULL);

  if (!GST_INDEX_IS_WRITABLE (index) || id == -1)
    return NULL;

  entry = g_slice_new (GstIndexEntry);
  entry->type = GST_INDEX_ENTRY_ID;
  entry->id = id;
  entry->data.id.description = description;

  gst_index_add_entry (index, entry);

  return entry;
}

static gboolean
gst_index_path_resolver (GstIndex * index, GstObject * writer,
    gchar ** writer_string, gpointer data)
{
  *writer_string = gst_object_get_path_string (writer);

  return TRUE;
}

static gboolean
gst_index_gtype_resolver (GstIndex * index, GstObject * writer,
    gchar ** writer_string, gpointer data)
{
  g_return_val_if_fail (writer != NULL, FALSE);

  if (GST_IS_PAD (writer)) {
    GstObject *element = gst_object_get_parent (GST_OBJECT (writer));
    gchar *name;

    name = gst_object_get_name (writer);
    if (element) {
      *writer_string = g_strdup_printf ("%s.%s",
          G_OBJECT_TYPE_NAME (element), name);
      gst_object_unref (element);
    } else {
      *writer_string = name;
      name = NULL;
    }

    g_free (name);

  } else {
    *writer_string = g_strdup (G_OBJECT_TYPE_NAME (writer));
  }

  return TRUE;
}

/**
 * gst_index_get_writer_id:
 * @index: the index to get a unique write id for
 * @writer: the #GstObject to allocate an id for
 * @id: a pointer to a gint to hold the id
 *
 * Before entries can be added to the index, a writer
 * should obtain a unique id. The methods to add new entries
 * to the index require this id as an argument.
 *
 * The application can implement a custom function to map the writer object
 * to a string. That string will be used to register or look up an id
 * in the index.
 *
 * <note>
 * The caller must not hold @writer's GST_OBJECT_LOCK(), as the default
 * resolver may call functions that take the object lock as well, and
 * the lock is not recursive.
 * </note>
 *
 * Returns: %TRUE if the writer would be mapped to an id.
 */
gboolean
gst_index_get_writer_id (GstIndex * index, GstObject * writer, gint * id)
{
  gchar *writer_string = NULL;
  GstIndexEntry *entry;
  GstIndexClass *iclass;
  gboolean success = FALSE;

  g_return_val_if_fail (GST_IS_INDEX (index), FALSE);
  g_return_val_if_fail (GST_IS_OBJECT (writer), FALSE);
  g_return_val_if_fail (id, FALSE);

  *id = -1;

  /* first try to get a previously cached id */
  entry = g_hash_table_lookup (index->writers, writer);
  if (entry == NULL) {

    iclass = GST_INDEX_GET_CLASS (index);

    /* let the app make a string */
    if (index->resolver) {
      gboolean res;

      res =
          index->resolver (index, writer, &writer_string,
          index->resolver_user_data);
      if (!res)
        return FALSE;
    } else {
      g_warning ("no resolver found");
      return FALSE;
    }

    /* if the index has a resolver, make it map this string to an id */
    if (iclass->get_writer_id) {
      success = iclass->get_writer_id (index, id, writer_string);
    }
    /* if the index could not resolve, we allocate one ourselves */
    if (!success) {
      *id = ++index->last_id;
    }

    entry = gst_index_add_id (index, *id, writer_string);
    if (!entry) {
      /* index is probably not writable, make an entry anyway
       * to keep it in our cache */
      entry = g_slice_new (GstIndexEntry);
      entry->type = GST_INDEX_ENTRY_ID;
      entry->id = *id;
      entry->data.id.description = writer_string;
    }
    g_hash_table_insert (index->writers, writer, entry);
  } else {
    *id = entry->id;
  }

  return TRUE;
}

static void
gst_index_add_entry (GstIndex * index, GstIndexEntry * entry)
{
  GstIndexClass *iclass;

  iclass = GST_INDEX_GET_CLASS (index);

  if (iclass->add_entry) {
    iclass->add_entry (index, entry);
  }

  g_signal_emit (index, gst_index_signals[ENTRY_ADDED], 0, entry);
}

/**
 * gst_index_add_associationv:
 * @index: the index to add the entry to
 * @id: the id of the index writer
 * @flags: optinal flags for this entry
 * @n: number of associations
 * @list: (array length=n): list of associations
 *
 * Associate given format/value pairs with each other.
 *
 * Returns: a pointer to the newly added entry in the index.
 */
GstIndexEntry *
gst_index_add_associationv (GstIndex * index, gint id,
    GstIndexAssociationFlags flags, gint n, const GstIndexAssociation * list)
{
  GstIndexEntry *entry;

  g_return_val_if_fail (n > 0, NULL);
  g_return_val_if_fail (list != NULL, NULL);
  g_return_val_if_fail (GST_IS_INDEX (index), NULL);

  if (!GST_INDEX_IS_WRITABLE (index) || id == -1)
    return NULL;

  entry = g_slice_new (GstIndexEntry);

  entry->type = GST_INDEX_ENTRY_ASSOCIATION;
  entry->id = id;
  entry->data.assoc.flags = flags;
  entry->data.assoc.assocs = g_memdup (list, sizeof (GstIndexAssociation) * n);
  entry->data.assoc.nassocs = n;

  gst_index_add_entry (index, entry);

  return entry;
}

#if 0
/**
 * gst_index_add_association:
 * @index: the index to add the entry to
 * @id: the id of the index writer
 * @flags: optinal flags for this entry
 * @format: the format of the value
 * @value: the value
 * @...: other format/value pairs or 0 to end the list
 *
 * Associate given format/value pairs with each other.
 * Be sure to pass gint64 values to this functions varargs,
 * you might want to use a gint64 cast to be sure.
 *
 * Returns: a pointer to the newly added entry in the index.
 */
GstIndexEntry *
gst_index_add_association (GstIndex * index, gint id,
    GstIndexAssociationFlags flags, GstFormat format, gint64 value, ...)
{
  va_list args;
  GstIndexEntry *entry;
  GstIndexAssociation *list;
  gint n_assocs = 0;
  GstFormat cur_format;
  GArray *array;

  g_return_val_if_fail (GST_IS_INDEX (index), NULL);
  g_return_val_if_fail (format != 0, NULL);

  if (!GST_INDEX_IS_WRITABLE (index) || id == -1)
    return NULL;

  array = g_array_new (FALSE, FALSE, sizeof (GstIndexAssociation));

  {
    GstIndexAssociation a;

    a.format = format;
    a.value = value;
    n_assocs = 1;
    g_array_append_val (array, a);
  }

  va_start (args, value);

  while ((cur_format = va_arg (args, GstFormat))) {
    GstIndexAssociation a;

    a.format = cur_format;
    a.value = va_arg (args, gint64);
    n_assocs++;
    g_array_append_val (array, a);
  }

  va_end (args);

  list = (GstIndexAssociation *) g_array_free (array, FALSE);

  entry = gst_index_add_associationv (index, id, flags, n_assocs, list);
  g_free (list);

  return entry;
}

/**
 * gst_index_add_object:
 * @index: the index to add the object to
 * @id: the id of the index writer
 * @key: a key for the object
 * @type: the GType of the object
 * @object: a pointer to the object to add
 *
 * Add the given object to the index with the given key.
 *
 * This function is not yet implemented.
 *
 * Returns: a pointer to the newly added entry in the index.
 */
GstIndexEntry *
gst_index_add_object (GstIndex * index, gint id, gchar * key,
    GType type, gpointer object)
{
  if (!GST_INDEX_IS_WRITABLE (index) || id == -1)
    return NULL;

  return NULL;
}
#endif

static gint
gst_index_compare_func (gconstpointer a, gconstpointer b, gpointer user_data)
{
  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

/**
 * gst_index_get_assoc_entry:
 * @index: the index to search
 * @id: the id of the index writer
 * @method: The lookup method to use
 * @flags: Flags for the entry
 * @format: the format of the value
 * @value: the value to find
 *
 * Finds the given format/value in the index
 *
 * Returns: (nullable): the entry associated with the value or %NULL if the
 *   value was not found.
 */
GstIndexEntry *
gst_index_get_assoc_entry (GstIndex * index, gint id,
    GstIndexLookupMethod method, GstIndexAssociationFlags flags,
    GstFormat format, gint64 value)
{
  g_return_val_if_fail (GST_IS_INDEX (index), NULL);

  if (id == -1)
    return NULL;

  return gst_index_get_assoc_entry_full (index, id, method, flags, format,
      value, gst_index_compare_func, NULL);
}

/**
 * gst_index_get_assoc_entry_full:
 * @index: the index to search
 * @id: the id of the index writer
 * @method: The lookup method to use
 * @flags: Flags for the entry
 * @format: the format of the value
 * @value: the value to find
 * @func: the function used to compare entries
 * @user_data: user data passed to the compare function
 *
 * Finds the given format/value in the index with the given
 * compare function and user_data.
 *
 * Returns: (nullable): the entry associated with the value or %NULL if the
 *   value was not found.
 */
GstIndexEntry *
gst_index_get_assoc_entry_full (GstIndex * index, gint id,
    GstIndexLookupMethod method, GstIndexAssociationFlags flags,
    GstFormat format, gint64 value, GCompareDataFunc func, gpointer user_data)
{
  GstIndexClass *iclass;

  g_return_val_if_fail (GST_IS_INDEX (index), NULL);

  if (id == -1)
    return NULL;

  iclass = GST_INDEX_GET_CLASS (index);

  if (iclass->get_assoc_entry)
    return iclass->get_assoc_entry (index, id, method, flags, format, value,
        func, user_data);

  return NULL;
}

/**
 * gst_index_entry_assoc_map:
 * @entry: the index to search
 * @format: the format of the value the find
 * @value: a pointer to store the value
 *
 * Gets alternative formats associated with the indexentry.
 *
 * Returns: %TRUE if there was a value associated with the given
 * format.
 */
gboolean
gst_index_entry_assoc_map (GstIndexEntry * entry,
    GstFormat format, gint64 * value)
{
  gint i;

  g_return_val_if_fail (entry != NULL, FALSE);
  g_return_val_if_fail (value != NULL, FALSE);

  for (i = 0; i < GST_INDEX_NASSOCS (entry); i++) {
    if (GST_INDEX_ASSOC_FORMAT (entry, i) == format) {
      *value = GST_INDEX_ASSOC_VALUE (entry, i);
      return TRUE;
    }
  }
  return FALSE;
}
