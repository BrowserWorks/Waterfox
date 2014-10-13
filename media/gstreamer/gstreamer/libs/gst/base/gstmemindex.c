/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

#include <gst/gst.h>

#define GST_TYPE_MEM_INDEX              \
  (gst_index_get_type ())
#define GST_MEM_INDEX(obj)              \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_MEM_INDEX, GstMemIndex))
#define GST_MEM_INDEX_CLASS(klass)      \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_MEM_INDEX, GstMemIndexClass))
#define GST_IS_MEM_INDEX(obj)           \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_MEM_INDEX))
#define GST_IS_MEM_INDEX_CLASS(klass)     \
  (GST_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_MEM_INDEX))

/*
 * Object model:
 *
 * All entries are simply added to a GList first. Then we build
 * an index to each entry for each id/format
 *
 *
 *  memindex
 *    -----------------------------...
 *    !                  !
 *   id1                 id2
 *    ------------
 *    !          !
 *   format1  format2
 *    !          !
 *   GTree      GTree
 *
 *
 * The memindex creates a MemIndexId object for each writer id, a
 * Hashtable is kept to map the id to the MemIndexId
 *
 * The MemIndexId keeps a MemIndexFormatIndex for each format the
 * specific writer wants indexed.
 *
 * The MemIndexFormatIndex keeps all the values of the particular
 * format in a GTree, The values of the GTree point back to the entry.
 *
 * Finding a value for an id/format requires locating the correct GTree,
 * then do a lookup in the Tree to get the required value.
 */

typedef struct
{
  GstFormat format;
  gint offset;
  GTree *tree;
}
GstMemIndexFormatIndex;

typedef struct
{
  gint id;
  GHashTable *format_index;
}
GstMemIndexId;

typedef struct _GstMemIndex GstMemIndex;
typedef struct _GstMemIndexClass GstMemIndexClass;

struct _GstMemIndex
{
  GstIndex parent;

  GList *associations;

  GHashTable *id_index;
};

struct _GstMemIndexClass
{
  GstIndexClass parent_class;
};

static void gst_mem_index_finalize (GObject * object);

static void gst_mem_index_add_entry (GstIndex * index, GstIndexEntry * entry);
static GstIndexEntry *gst_mem_index_get_assoc_entry (GstIndex * index, gint id,
    GstIndexLookupMethod method, GstIndexAssociationFlags flags,
    GstFormat format, gint64 value, GCompareDataFunc func, gpointer user_data);

#define CLASS(mem_index)  GST_MEM_INDEX_CLASS (G_OBJECT_GET_CLASS (mem_index))

static GType gst_mem_index_get_type (void);

G_DEFINE_TYPE (GstMemIndex, gst_mem_index, GST_TYPE_INDEX);

static void
gst_mem_index_class_init (GstMemIndexClass * klass)
{
  GObjectClass *gobject_class;
  GstIndexClass *gstindex_class;

  gobject_class = (GObjectClass *) klass;
  gstindex_class = (GstIndexClass *) klass;

  gobject_class->finalize = gst_mem_index_finalize;

  gstindex_class->add_entry = GST_DEBUG_FUNCPTR (gst_mem_index_add_entry);
  gstindex_class->get_assoc_entry =
      GST_DEBUG_FUNCPTR (gst_mem_index_get_assoc_entry);
}

static void
gst_mem_index_init (GstMemIndex * index)
{
  GST_DEBUG ("created new mem index");

  index->associations = NULL;
  index->id_index = g_hash_table_new (g_int_hash, g_int_equal);
}

static void
gst_mem_index_free_format (gpointer key, gpointer value, gpointer user_data)
{
  GstMemIndexFormatIndex *index = (GstMemIndexFormatIndex *) value;

  if (index->tree) {
    g_tree_destroy (index->tree);
  }

  g_slice_free (GstMemIndexFormatIndex, index);
}

static void
gst_mem_index_free_id (gpointer key, gpointer value, gpointer user_data)
{
  GstMemIndexId *id_index = (GstMemIndexId *) value;

  if (id_index->format_index) {
    g_hash_table_foreach (id_index->format_index, gst_mem_index_free_format,
        NULL);
    g_hash_table_destroy (id_index->format_index);
    id_index->format_index = NULL;
  }

  g_slice_free (GstMemIndexId, id_index);
}

static void
gst_mem_index_finalize (GObject * object)
{
  GstMemIndex *memindex = GST_MEM_INDEX (object);

  /* Delete the trees referencing the associations first */
  if (memindex->id_index) {
    g_hash_table_foreach (memindex->id_index, gst_mem_index_free_id, NULL);
    g_hash_table_destroy (memindex->id_index);
    memindex->id_index = NULL;
  }

  /* Then delete the associations themselves */
  if (memindex->associations) {
    g_list_foreach (memindex->associations, (GFunc) gst_index_entry_free, NULL);
    g_list_free (memindex->associations);
    memindex->associations = NULL;
  }

  G_OBJECT_CLASS (gst_mem_index_parent_class)->finalize (object);
}

static void
gst_mem_index_add_id (GstIndex * index, GstIndexEntry * entry)
{
  GstMemIndex *memindex = GST_MEM_INDEX (index);
  GstMemIndexId *id_index;

  id_index = g_hash_table_lookup (memindex->id_index, &entry->id);

  if (!id_index) {
    id_index = g_slice_new0 (GstMemIndexId);

    id_index->id = entry->id;
    id_index->format_index = g_hash_table_new (g_int_hash, g_int_equal);
    g_hash_table_insert (memindex->id_index, &id_index->id, id_index);
  }
}

static gint
mem_index_compare (gconstpointer a, gconstpointer b, gpointer user_data)
{
  GstMemIndexFormatIndex *index = user_data;
  gint64 val1, val2;
  gint64 diff;

  val1 = GST_INDEX_ASSOC_VALUE (((GstIndexEntry *) a), index->offset);
  val2 = GST_INDEX_ASSOC_VALUE (((GstIndexEntry *) b), index->offset);

  diff = (val2 - val1);

  return (diff == 0 ? 0 : (diff > 0 ? 1 : -1));
}

static void
gst_mem_index_index_format (GstMemIndexId * id_index, GstIndexEntry * entry,
    gint assoc)
{
  GstMemIndexFormatIndex *index;
  GstFormat *format;

  format = &GST_INDEX_ASSOC_FORMAT (entry, assoc);

  index = g_hash_table_lookup (id_index->format_index, format);

  if (!index) {
    index = g_slice_new0 (GstMemIndexFormatIndex);

    index->format = *format;
    index->offset = assoc;
    index->tree = g_tree_new_with_data (mem_index_compare, index);

    g_hash_table_insert (id_index->format_index, &index->format, index);
  }

  g_tree_insert (index->tree, entry, entry);
}

static void
gst_mem_index_add_association (GstIndex * index, GstIndexEntry * entry)
{
  GstMemIndex *memindex = GST_MEM_INDEX (index);
  GstMemIndexId *id_index;

  memindex->associations = g_list_prepend (memindex->associations, entry);

  id_index = g_hash_table_lookup (memindex->id_index, &entry->id);
  if (id_index) {
    gint i;

    for (i = 0; i < GST_INDEX_NASSOCS (entry); i++) {
      gst_mem_index_index_format (id_index, entry, i);
    }
  }
}

static void
gst_mem_index_add_object (GstIndex * index, GstIndexEntry * entry)
{
}

static void
gst_mem_index_add_format (GstIndex * index, GstIndexEntry * entry)
{
}

static void
gst_mem_index_add_entry (GstIndex * index, GstIndexEntry * entry)
{
  GST_LOG_OBJECT (index, "added this entry");

  switch (entry->type) {
    case GST_INDEX_ENTRY_ID:
      gst_mem_index_add_id (index, entry);
      break;
    case GST_INDEX_ENTRY_ASSOCIATION:
      gst_mem_index_add_association (index, entry);
      break;
    case GST_INDEX_ENTRY_OBJECT:
      gst_mem_index_add_object (index, entry);
      break;
    case GST_INDEX_ENTRY_FORMAT:
      gst_mem_index_add_format (index, entry);
      break;
    default:
      break;
  }
}

typedef struct
{
  gint64 value;
  GstMemIndexFormatIndex *index;
  gboolean exact;
  GstIndexEntry *lower;
  gint64 low_diff;
  GstIndexEntry *higher;
  gint64 high_diff;
}
GstMemIndexSearchData;

static gint
mem_index_search (gconstpointer a, gconstpointer b)
{
  GstMemIndexSearchData *data = (GstMemIndexSearchData *) b;
  GstMemIndexFormatIndex *index = data->index;
  gint64 val1, val2;
  gint64 diff;

  val1 = GST_INDEX_ASSOC_VALUE (((GstIndexEntry *) a), index->offset);
  val2 = data->value;

  diff = (val1 - val2);
  if (diff == 0)
    return 0;

  /* exact matching, don't update low/high */
  if (data->exact)
    return (diff > 0 ? 1 : -1);

  if (diff < 0) {
    if (diff > data->low_diff) {
      data->low_diff = diff;
      data->lower = (GstIndexEntry *) a;
    }
    diff = -1;
  } else {
    if (diff < data->high_diff) {
      data->high_diff = diff;
      data->higher = (GstIndexEntry *) a;
    }
    diff = 1;
  }

  return diff;
}

static GstIndexEntry *
gst_mem_index_get_assoc_entry (GstIndex * index, gint id,
    GstIndexLookupMethod method,
    GstIndexAssociationFlags flags,
    GstFormat format, gint64 value, GCompareDataFunc func, gpointer user_data)
{
  GstMemIndex *memindex = GST_MEM_INDEX (index);
  GstMemIndexId *id_index;
  GstMemIndexFormatIndex *format_index;
  GstIndexEntry *entry;
  GstMemIndexSearchData data;

  id_index = g_hash_table_lookup (memindex->id_index, &id);
  if (!id_index)
    return NULL;

  format_index = g_hash_table_lookup (id_index->format_index, &format);
  if (!format_index)
    return NULL;

  data.value = value;
  data.index = format_index;
  data.exact = (method == GST_INDEX_LOOKUP_EXACT);

  /* setup data for low/high checks if we are not looking
   * for an exact match */
  if (!data.exact) {
    data.low_diff = G_MININT64;
    data.lower = NULL;
    data.high_diff = G_MAXINT64;
    data.higher = NULL;
  }

  entry = g_tree_search (format_index->tree, mem_index_search, &data);

  /* get the low/high values if we're not exact */
  if (entry == NULL && !data.exact) {
    if (method == GST_INDEX_LOOKUP_BEFORE)
      entry = data.lower;
    else if (method == GST_INDEX_LOOKUP_AFTER) {
      entry = data.higher;
    }
  }

  if (entry && ((GST_INDEX_ASSOC_FLAGS (entry) & flags) != flags)) {
    if (method != GST_INDEX_LOOKUP_EXACT) {
      GList *l_entry = g_list_find (memindex->associations, entry);

      entry = NULL;

      while (l_entry) {
        entry = (GstIndexEntry *) l_entry->data;

        if (entry->id == id && (GST_INDEX_ASSOC_FLAGS (entry) & flags) == flags)
          break;

        if (method == GST_INDEX_LOOKUP_BEFORE)
          l_entry = g_list_next (l_entry);
        else if (method == GST_INDEX_LOOKUP_AFTER) {
          l_entry = g_list_previous (l_entry);
        }
      }
    } else {
      entry = NULL;
    }
  }

  return entry;
}

#if 0
gboolean
gst_mem_index_plugin_init (GstPlugin * plugin)
{
  GstIndexFactory *factory;

  factory = gst_index_factory_new ("memindex",
      "A index that stores entries in memory", gst_mem_index_get_type ());

  if (factory == NULL) {
    g_warning ("failed to create memindex factory");
    return FALSE;
  }

  GST_PLUGIN_FEATURE (factory)->plugin_name = plugin->desc.name;
  GST_PLUGIN_FEATURE (factory)->loaded = TRUE;

  gst_registry_add_feature (gst_registry_get_default (),
      GST_PLUGIN_FEATURE (factory));

  return TRUE;
}
#endif
