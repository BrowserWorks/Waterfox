/* GStreamer
 * (c) 2010, 2012 Alexander Saprykin <xelfium@gmail.com>
 *
 * gsttoc.c: GstToc initialization and parsing/creation
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
 * SECTION:gsttoc
 * @short_description: Generic table of contents support
 * @see_also: #GstStructure, #GstEvent, #GstMessage, #GstQuery
 *
 * #GstToc functions are used to create/free #GstToc and #GstTocEntry structures.
 * Also they are used to convert #GstToc into #GstStructure and vice versa.
 *
 * #GstToc lets you to inform other elements in pipeline or application that playing
 * source has some kind of table of contents (TOC). These may be chapters, editions,
 * angles or other types. For example: DVD chapters, Matroska chapters or cue sheet
 * TOC. Such TOC will be useful for applications to display instead of just a
 * playlist.
 *
 * Using TOC is very easy. Firstly, create #GstToc structure which represents root
 * contents of the source. You can also attach TOC-specific tags to it. Then fill
 * it with #GstTocEntry entries by appending them to the #GstToc using
 * gst_toc_append_entry(), and appending subentries to a #GstTocEntry using
 * gst_toc_entry_append_sub_entry().
 *
 * Note that root level of the TOC can contain only either editions or chapters. You
 * should not mix them together at the same level. Otherwise you will get serialization
 * /deserialization errors. Make sure that no one of the entries has negative start and
 *  stop values.
 *
 * Use gst_event_new_toc() to create a new TOC #GstEvent, and gst_event_parse_toc() to
 * parse received TOC event. Use gst_event_new_toc_select() to create a new TOC select #GstEvent,
 * and gst_event_parse_toc_select() to parse received TOC select event. The same rule for
 * the #GstMessage: gst_message_new_toc() to create new TOC #GstMessage, and
 * gst_message_parse_toc() to parse received TOC message.
 *
 * TOCs can have global scope or current scope. Global scope TOCs contain
 * all entries that can possibly be selected using a toc select event, and
 * are what an application is usually interested in. TOCs with current scope
 * only contain the parts of the TOC relevant to the currently selected/playing
 * stream; the current scope TOC is used by downstream elements such as muxers
 * to write correct TOC entries when transcoding files, for example. When
 * playing a DVD, the global TOC would contain a hierarchy of all titles,
 * chapters and angles, for example, while the current TOC would only contain
 * the chapters for the currently playing title if playback of a specific
 * title was requested.
 *
 * Applications and plugins should not rely on TOCs having a certain kind of
 * structure, but should allow for different alternatives. For example, a
 * simple CUE sheet embedded in a file may be presented as a flat list of
 * track entries, or could have a top-level edition node (or some other
 * alternative type entry) with track entries underneath that node; or even
 * multiple top-level edition nodes (or some other alternative type entries)
 * each with track entries underneath, in case the source file has extracted
 * a track listing from different sources).
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gst_private.h"
#include "gstenumtypes.h"
#include "gsttaglist.h"
#include "gststructure.h"
#include "gstvalue.h"
#include "gsttoc.h"
#include "gstpad.h"
#include "gstquark.h"

struct _GstTocEntry
{
  GstMiniObject mini_object;

  GstToc *toc;
  GstTocEntry *parent;

  gchar *uid;
  GstTocEntryType type;
  GstClockTime start, stop;
  GList *subentries;
  GstTagList *tags;
  GstTocLoopType loop_type;
  gint repeat_count;
};

struct _GstToc
{
  GstMiniObject mini_object;

  GstTocScope scope;
  GList *entries;
  GstTagList *tags;
};

#undef gst_toc_copy
static GstToc *gst_toc_copy (const GstToc * toc);
static void gst_toc_free (GstToc * toc);
#undef gst_toc_entry_copy
static GstTocEntry *gst_toc_entry_copy (const GstTocEntry * toc);
static void gst_toc_entry_free (GstTocEntry * toc);

GType _gst_toc_type = 0;
GType _gst_toc_entry_type = 0;

GST_DEFINE_MINI_OBJECT_TYPE (GstToc, gst_toc);
GST_DEFINE_MINI_OBJECT_TYPE (GstTocEntry, gst_toc_entry);

/**
 * gst_toc_new:
 * @scope: scope of this TOC
 *
 * Create a new #GstToc structure.
 *
 * Returns: (transfer full): newly allocated #GstToc structure, free it
 *     with gst_toc_unref().
 */
GstToc *
gst_toc_new (GstTocScope scope)
{
  GstToc *toc;

  g_return_val_if_fail (scope == GST_TOC_SCOPE_GLOBAL ||
      scope == GST_TOC_SCOPE_CURRENT, NULL);

  toc = g_slice_new0 (GstToc);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (toc), 0, GST_TYPE_TOC,
      (GstMiniObjectCopyFunction) gst_toc_copy, NULL,
      (GstMiniObjectFreeFunction) gst_toc_free);

  toc->scope = scope;
  toc->tags = gst_tag_list_new_empty ();

  return toc;
}

/**
 * gst_toc_get_scope:
 * @toc: a #GstToc instance
 *
 * Returns: scope of @toc
 */
GstTocScope
gst_toc_get_scope (const GstToc * toc)
{
  g_return_val_if_fail (toc != NULL, GST_TOC_SCOPE_GLOBAL);

  return toc->scope;
}

/**
 * gst_toc_set_tags:
 * @toc: A #GstToc instance
 * @tags: (allow-none) (transfer full): A #GstTagList or %NULL
 *
 * Set a #GstTagList with tags for the complete @toc.
 */
void
gst_toc_set_tags (GstToc * toc, GstTagList * tags)
{
  g_return_if_fail (toc != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (toc)));

  if (toc->tags)
    gst_tag_list_unref (toc->tags);
  toc->tags = tags;
}

/**
 * gst_toc_merge_tags:
 * @toc: A #GstToc instance
 * @tags: (allow-none): A #GstTagList or %NULL
 * @mode: A #GstTagMergeMode
 *
 * Merge @tags into the existing tags of @toc using @mode.
 */
void
gst_toc_merge_tags (GstToc * toc, GstTagList * tags, GstTagMergeMode mode)
{
  g_return_if_fail (toc != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (toc)));

  if (!toc->tags) {
    toc->tags = gst_tag_list_ref (tags);
  } else {
    GstTagList *tmp = gst_tag_list_merge (toc->tags, tags, mode);
    gst_tag_list_unref (toc->tags);
    toc->tags = tmp;
  }
}

/**
 * gst_toc_get_tags:
 * @toc: A #GstToc instance
 *
 * Gets the tags for @toc.
 *
 * Returns: (transfer none): A #GstTagList for @entry
 */
GstTagList *
gst_toc_get_tags (const GstToc * toc)
{
  g_return_val_if_fail (toc != NULL, NULL);

  return toc->tags;
}

/**
 * gst_toc_append_entry:
 * @toc: A #GstToc instance
 * @entry: (transfer full): A #GstTocEntry
 *
 * Appends the #GstTocEntry @entry to @toc.
 */
void
gst_toc_append_entry (GstToc * toc, GstTocEntry * entry)
{
  g_return_if_fail (toc != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (toc)));
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (entry)));
  g_return_if_fail (entry->toc == NULL);
  g_return_if_fail (entry->parent == NULL);

  toc->entries = g_list_append (toc->entries, entry);
  entry->toc = toc;

  GST_LOG ("appended %s entry with uid %s to toc %p",
      gst_toc_entry_type_get_nick (entry->type), entry->uid, toc);

  gst_toc_dump (toc);
}

/**
 * gst_toc_get_entries:
 * @toc: A #GstToc instance
 *
 * Gets the list of #GstTocEntry of @toc.
 *
 * Returns: (transfer none) (element-type Gst.TocEntry): A #GList of #GstTocEntry for @entry
 */
GList *
gst_toc_get_entries (const GstToc * toc)
{
  g_return_val_if_fail (toc != NULL, NULL);

  return toc->entries;
}

static GstTocEntry *
gst_toc_entry_new_internal (GstTocEntryType type, const gchar * uid)
{
  GstTocEntry *entry;

  entry = g_slice_new0 (GstTocEntry);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (entry), 0, GST_TYPE_TOC_ENTRY,
      (GstMiniObjectCopyFunction) gst_toc_entry_copy, NULL,
      (GstMiniObjectFreeFunction) gst_toc_entry_free);

  entry->uid = g_strdup (uid);
  entry->type = type;
  entry->tags = NULL;
  entry->start = entry->stop = GST_CLOCK_TIME_NONE;

  return entry;
}

/**
 * gst_toc_entry_new:
 * @type: entry type.
 * @uid: unique ID (UID) in the whole TOC.
 *
 * Create new #GstTocEntry structure.
 *
 * Returns: newly allocated #GstTocEntry structure, free it with gst_toc_entry_unref().
 */
GstTocEntry *
gst_toc_entry_new (GstTocEntryType type, const gchar * uid)
{
  g_return_val_if_fail (uid != NULL, NULL);

  return gst_toc_entry_new_internal (type, uid);
}

static void
gst_toc_free (GstToc * toc)
{
  g_list_foreach (toc->entries, (GFunc) gst_mini_object_unref, NULL);
  g_list_free (toc->entries);

  if (toc->tags != NULL)
    gst_tag_list_unref (toc->tags);

  g_slice_free (GstToc, toc);
}

static void
gst_toc_entry_free (GstTocEntry * entry)
{
  g_return_if_fail (entry != NULL);

  g_list_foreach (entry->subentries, (GFunc) gst_mini_object_unref, NULL);
  g_list_free (entry->subentries);

  g_free (entry->uid);

  if (entry->tags != NULL)
    gst_tag_list_unref (entry->tags);

  g_slice_free (GstTocEntry, entry);
}

static GstTocEntry *
gst_toc_entry_find_sub_entry (const GstTocEntry * entry, const gchar * uid)
{
  GList *cur;
  GstTocEntry *subentry, *subsubentry;

  g_return_val_if_fail (entry != NULL, NULL);
  g_return_val_if_fail (uid != NULL, NULL);

  cur = entry->subentries;
  while (cur != NULL) {
    subentry = cur->data;

    if (g_strcmp0 (subentry->uid, uid) == 0)
      return subentry;

    subsubentry = gst_toc_entry_find_sub_entry (subentry, uid);
    if (subsubentry != NULL)
      return subsubentry;

    cur = cur->next;
  }

  return NULL;
}

/**
 * gst_toc_find_entry:
 * @toc: #GstToc to search in.
 * @uid: UID to find #GstTocEntry with.
 *
 * Find #GstTocEntry with given @uid in the @toc.
 *
 * Returns: (transfer none) (nullable): #GstTocEntry with specified
 * @uid from the @toc, or %NULL if not found.
 */
GstTocEntry *
gst_toc_find_entry (const GstToc * toc, const gchar * uid)
{
  GList *cur;
  GstTocEntry *entry, *subentry;

  g_return_val_if_fail (toc != NULL, NULL);
  g_return_val_if_fail (uid != NULL, NULL);

  cur = toc->entries;
  while (cur != NULL) {
    entry = cur->data;

    if (g_strcmp0 (entry->uid, uid) == 0)
      return entry;

    subentry = gst_toc_entry_find_sub_entry (entry, uid);
    if (subentry != NULL)
      return subentry;
    cur = cur->next;
  }

  return NULL;
}

/**
 * gst_toc_entry_copy:
 * @entry: #GstTocEntry to copy.
 *
 * Copy #GstTocEntry with all subentries (deep copy).
 *
 * Returns: (nullable): newly allocated #GstTocEntry in case of
 * success, %NULL otherwise; free it when done with
 * gst_toc_entry_unref().
 */
static GstTocEntry *
gst_toc_entry_copy (const GstTocEntry * entry)
{
  GstTocEntry *ret, *sub;
  GstTagList *list;
  GList *cur;

  g_return_val_if_fail (entry != NULL, NULL);

  ret = gst_toc_entry_new (entry->type, entry->uid);

  ret->start = entry->start;
  ret->stop = entry->stop;

  if (GST_IS_TAG_LIST (entry->tags)) {
    list = gst_tag_list_copy (entry->tags);
    if (ret->tags)
      gst_tag_list_unref (ret->tags);
    ret->tags = list;
  }

  cur = entry->subentries;
  while (cur != NULL) {
    sub = gst_toc_entry_copy (cur->data);

    if (sub != NULL)
      ret->subentries = g_list_prepend (ret->subentries, sub);

    cur = cur->next;
  }
  ret->subentries = g_list_reverse (ret->subentries);

  return ret;
}

/**
 * gst_toc_copy:
 * @toc: #GstToc to copy.
 *
 * Copy #GstToc with all subentries (deep copy).
 *
 * Returns: (nullable): newly allocated #GstToc in case of success,
 * %NULL otherwise; free it when done with gst_toc_unref().
 */
static GstToc *
gst_toc_copy (const GstToc * toc)
{
  GstToc *ret;
  GstTocEntry *entry;
  GList *cur;
  GstTagList *list;

  g_return_val_if_fail (toc != NULL, NULL);

  ret = gst_toc_new (toc->scope);

  if (GST_IS_TAG_LIST (toc->tags)) {
    list = gst_tag_list_copy (toc->tags);
    gst_tag_list_unref (ret->tags);
    ret->tags = list;
  }

  cur = toc->entries;
  while (cur != NULL) {
    entry = gst_toc_entry_copy (cur->data);

    if (entry != NULL)
      ret->entries = g_list_prepend (ret->entries, entry);

    cur = cur->next;
  }
  ret->entries = g_list_reverse (ret->entries);
  return ret;
}

/**
 * gst_toc_entry_set_start_stop_times:
 * @entry: #GstTocEntry to set values.
 * @start: start value to set.
 * @stop: stop value to set.
 *
 * Set @start and @stop values for the @entry.
 */
void
gst_toc_entry_set_start_stop_times (GstTocEntry * entry, gint64 start,
    gint64 stop)
{
  g_return_if_fail (entry != NULL);

  entry->start = start;
  entry->stop = stop;
}

/**
 * gst_toc_entry_get_start_stop_times:
 * @entry: #GstTocEntry to get values from.
 * @start: (out) (allow-none): the storage for the start value, leave
 *   %NULL if not need.
 * @stop: (out) (allow-none): the storage for the stop value, leave
 *   %NULL if not need.
 *
 * Get @start and @stop values from the @entry and write them into appropriate
 * storages.
 *
 * Returns: %TRUE if all non-%NULL storage pointers were filled with appropriate
 * values, %FALSE otherwise.
 */
gboolean
gst_toc_entry_get_start_stop_times (const GstTocEntry * entry, gint64 * start,
    gint64 * stop)
{
  g_return_val_if_fail (entry != NULL, FALSE);

  if (start != NULL)
    *start = entry->start;
  if (stop != NULL)
    *stop = entry->stop;

  return TRUE;
}

/**
 * gst_toc_entry_set_loop:
 * @entry: #GstTocEntry to set values.
 * @loop_type: loop_type value to set.
 * @repeat_count: repeat_count value to set.
 *
 * Set @loop_type and @repeat_count values for the @entry.
 *
 * Since: 1.4
 */
void
gst_toc_entry_set_loop (GstTocEntry * entry, GstTocLoopType loop_type,
    gint repeat_count)
{
  g_return_if_fail (entry != NULL);

  entry->loop_type = loop_type;
  entry->repeat_count = repeat_count;
}

/**
 * gst_toc_entry_get_loop:
 * @entry: #GstTocEntry to get values from.
 * @loop_type: (out) (allow-none): the storage for the loop_type
 *             value, leave %NULL if not need.
 * @repeat_count: (out) (allow-none): the storage for the repeat_count
 *                value, leave %NULL if not need.
 *
 * Get @loop_type and @repeat_count values from the @entry and write them into
 * appropriate storages. Loops are e.g. used by sampled instruments. GStreamer
 * is not automatically applying the loop. The application can process this
 * meta data and use it e.g. to send a seek-event to loop a section.
 *
 * Returns: %TRUE if all non-%NULL storage pointers were filled with appropriate
 * values, %FALSE otherwise.
 *
 * Since: 1.4
 */
gboolean
gst_toc_entry_get_loop (const GstTocEntry * entry, GstTocLoopType * loop_type,
    gint * repeat_count)
{
  g_return_val_if_fail (entry != NULL, FALSE);

  if (loop_type != NULL)
    *loop_type = entry->loop_type;
  if (repeat_count != NULL)
    *repeat_count = entry->repeat_count;

  return TRUE;
}


/**
 * gst_toc_entry_type_get_nick:
 * @type: a #GstTocEntryType.
 *
 * Converts @type to a string representation.
 *
 * Returns: Returns a human-readable string for @type. This string is
 *    only for debugging purpose and should not be displayed in a user
 *    interface.
 */
const gchar *
gst_toc_entry_type_get_nick (GstTocEntryType type)
{
  switch (type) {
    case GST_TOC_ENTRY_TYPE_ANGLE:
      return "angle";
    case GST_TOC_ENTRY_TYPE_VERSION:
      return "version";
    case GST_TOC_ENTRY_TYPE_EDITION:
      return "edition";
    case GST_TOC_ENTRY_TYPE_TITLE:
      return "title";
    case GST_TOC_ENTRY_TYPE_TRACK:
      return "track";
    case GST_TOC_ENTRY_TYPE_CHAPTER:
      return "chapter";
    default:
      break;
  }
  return "invalid";
}

/**
 * gst_toc_entry_get_entry_type:
 * @entry: a #GstTocEntry
 *
 * Returns: @entry's entry type
 */
GstTocEntryType
gst_toc_entry_get_entry_type (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, GST_TOC_ENTRY_TYPE_INVALID);

  return entry->type;
}

/**
 * gst_toc_entry_is_alternative:
 * @entry: a #GstTocEntry
 *
 * Returns: %TRUE if @entry's type is an alternative type, otherwise %FALSE
 */
gboolean
gst_toc_entry_is_alternative (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, FALSE);

  return GST_TOC_ENTRY_TYPE_IS_ALTERNATIVE (entry->type);
}

/**
 * gst_toc_entry_is_sequence:
 * @entry: a #GstTocEntry
 *
 * Returns: %TRUE if @entry's type is a sequence type, otherwise %FALSE
 */
gboolean
gst_toc_entry_is_sequence (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, FALSE);

  return GST_TOC_ENTRY_TYPE_IS_SEQUENCE (entry->type);
}

/**
 * gst_toc_entry_get_uid:
 * @entry: A #GstTocEntry instance
 *
 * Gets the UID of @entry.
 *
 * Returns: (transfer none): The UID of @entry
 */
const gchar *
gst_toc_entry_get_uid (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, NULL);

  return entry->uid;
}

/**
 * gst_toc_entry_append_sub_entry:
 * @entry: A #GstTocEntry instance
 * @subentry: (transfer full): A #GstTocEntry
 *
 * Appends the #GstTocEntry @subentry to @entry.
 */
void
gst_toc_entry_append_sub_entry (GstTocEntry * entry, GstTocEntry * subentry)
{
  g_return_if_fail (entry != NULL);
  g_return_if_fail (subentry != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (entry)));
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST
          (subentry)));
  g_return_if_fail (subentry->toc == NULL);
  g_return_if_fail (subentry->parent == NULL);

  entry->subentries = g_list_append (entry->subentries, subentry);
  subentry->toc = entry->toc;
  subentry->parent = entry;

  GST_LOG ("appended %s subentry with uid %s to entry %s",
      gst_toc_entry_type_get_nick (subentry->type), subentry->uid, entry->uid);
}

/**
 * gst_toc_entry_get_sub_entries:
 * @entry: A #GstTocEntry instance
 *
 * Gets the sub-entries of @entry.
 *
 * Returns: (transfer none) (element-type Gst.TocEntry): A #GList of #GstTocEntry of @entry
 */
GList *
gst_toc_entry_get_sub_entries (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, NULL);

  return entry->subentries;
}

/**
 * gst_toc_entry_set_tags:
 * @entry: A #GstTocEntry instance
 * @tags: (allow-none) (transfer full): A #GstTagList or %NULL
 *
 * Set a #GstTagList with tags for the complete @entry.
 */
void
gst_toc_entry_set_tags (GstTocEntry * entry, GstTagList * tags)
{
  g_return_if_fail (entry != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (entry)));

  if (entry->tags)
    gst_tag_list_unref (entry->tags);
  entry->tags = tags;
}

/**
 * gst_toc_entry_merge_tags:
 * @entry: A #GstTocEntry instance
 * @tags: (allow-none): A #GstTagList or %NULL
 * @mode: A #GstTagMergeMode
 *
 * Merge @tags into the existing tags of @entry using @mode.
 */
void
gst_toc_entry_merge_tags (GstTocEntry * entry, GstTagList * tags,
    GstTagMergeMode mode)
{
  g_return_if_fail (entry != NULL);
  g_return_if_fail (gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (entry)));

  if (!entry->tags) {
    entry->tags = gst_tag_list_ref (tags);
  } else {
    GstTagList *tmp = gst_tag_list_merge (entry->tags, tags, mode);
    gst_tag_list_unref (entry->tags);
    entry->tags = tmp;
  }
}

/**
 * gst_toc_entry_get_tags:
 * @entry: A #GstTocEntry instance
 *
 * Gets the tags for @entry.
 *
 * Returns: (transfer none): A #GstTagList for @entry
 */
GstTagList *
gst_toc_entry_get_tags (const GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, NULL);

  return entry->tags;
}

/**
 * gst_toc_entry_get_toc:
 * @entry: A #GstTocEntry instance
 *
 * Gets the parent #GstToc of @entry.
 *
 * Returns: (transfer none): The parent #GstToc of @entry
 */
GstToc *
gst_toc_entry_get_toc (GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, NULL);

  return entry->toc;
}

/**
 * gst_toc_entry_get_parent:
 * @entry: A #GstTocEntry instance
 *
 * Gets the parent #GstTocEntry of @entry.
 *
 * Returns: (transfer none): The parent #GstTocEntry of @entry
 */
GstTocEntry *
gst_toc_entry_get_parent (GstTocEntry * entry)
{
  g_return_val_if_fail (entry != NULL, NULL);

  return entry->parent;
}

#ifndef GST_DISABLE_GST_DEBUG
static void
gst_toc_dump_entries (GList * entries, guint depth)
{
  GList *e;
  gchar *indent;

  indent = g_malloc0 (depth + 1);
  memset (indent, ' ', depth);
  for (e = entries; e != NULL; e = e->next) {
    GstTocEntry *entry = e->data;

    GST_TRACE ("%s+ %s (%s), %" GST_TIME_FORMAT " - %" GST_TIME_FORMAT ", "
        "tags: %" GST_PTR_FORMAT, indent, entry->uid,
        gst_toc_entry_type_get_nick (entry->type),
        GST_TIME_ARGS (entry->start), GST_TIME_ARGS (entry->stop), entry->tags);

    if (entry->subentries != NULL)
      gst_toc_dump_entries (entry->subentries, depth + 2);
  }
  g_free (indent);
}
#endif

void
gst_toc_dump (GstToc * toc)
{
#ifndef GST_DISABLE_GST_DEBUG
  GST_TRACE ("        Toc %p, scope: %s, tags: %" GST_PTR_FORMAT, toc,
      (toc->scope == GST_TOC_SCOPE_GLOBAL) ? "global" : "current", toc->tags);
  gst_toc_dump_entries (toc->entries, 2);
#endif
}

void
_priv_gst_toc_initialize (void)
{
  _gst_toc_type = gst_toc_get_type ();
  _gst_toc_entry_type = gst_toc_entry_get_type ();
}
