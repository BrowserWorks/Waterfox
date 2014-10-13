/* GStreamer
 * Copyright (C) 2009 Wim Taymans <wim.taymans@gmail.be>
 *
 * gstmeta.h: Header for Metadata structures
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


#ifndef __GST_META_H__
#define __GST_META_H__

G_BEGIN_DECLS

typedef struct _GstMeta GstMeta;
typedef struct _GstMetaInfo GstMetaInfo;

#define GST_META_CAST(meta)   ((GstMeta *)(meta))

/**
 * GstMetaFlags:
 * @GST_META_FLAG_NONE: no flags
 * @GST_META_FLAG_READONLY: metadata should not be modified
 * @GST_META_FLAG_POOLED: metadata is managed by a bufferpool
 * @GST_META_FLAG_LOCKED: metadata should not be removed
 * @GST_META_FLAG_LAST: additional flags can be added starting from this flag.
 *
 * Extra metadata flags.
 */
typedef enum {
  GST_META_FLAG_NONE        = 0,
  GST_META_FLAG_READONLY    = (1 << 0),
  GST_META_FLAG_POOLED      = (1 << 1),
  GST_META_FLAG_LOCKED      = (1 << 2),

  GST_META_FLAG_LAST        = (1 << 16)
} GstMetaFlags;

/**
 * GST_META_FLAGS:
 * @meta: a #GstMeta.
 *
 * A flags word containing #GstMetaFlags flags set on @meta
 */
#define GST_META_FLAGS(meta)  (GST_META_CAST (meta)->flags)
/**
 * GST_META_FLAG_IS_SET:
 * @meta: a #GstMeta.
 * @flag: the #GstMetaFlags to check.
 *
 * Gives the status of a specific flag on a metadata.
 */
#define GST_META_FLAG_IS_SET(meta,flag)        !!(GST_META_FLAGS (meta) & (flag))
/**
 * GST_META_FLAG_SET:
 * @meta: a #GstMeta.
 * @flag: the #GstMetaFlags to set.
 *
 * Sets a metadata flag on a metadata.
 */
#define GST_META_FLAG_SET(meta,flag)           (GST_META_FLAGS (meta) |= (flag))
/**
 * GST_META_FLAG_UNSET:
 * @meta: a #GstMeta.
 * @flag: the #GstMetaFlags to clear.
 *
 * Clears a metadata flag.
 */
#define GST_META_FLAG_UNSET(meta,flag)         (GST_META_FLAGS (meta) &= ~(flag))

/**
 * GST_META_TAG_MEMORY_STR:
 *
 * This metadata stays relevant as long as memory layout is unchanged.
 *
 * Since: 1.2
 */
#define GST_META_TAG_MEMORY_STR "memory"

/**
 * GstMeta:
 * @flags: extra flags for the metadata
 * @info: pointer to the #GstMetaInfo
 *
 * Base structure for metadata. Custom metadata will put this structure
 * as the first member of their structure.
 */
struct _GstMeta {
  GstMetaFlags       flags;
  const GstMetaInfo *info;
};

/**
 * GstMetaInitFunction:
 * @meta: a #GstMeta
 * @params: parameters passed to the init function
 * @buffer: a #GstBuffer
 *
 * Function called when @meta is initialized in @buffer.
 */
typedef gboolean (*GstMetaInitFunction) (GstMeta *meta, gpointer params, GstBuffer *buffer);

/**
 * GstMetaFreeFunction:
 * @meta: a #GstMeta
 * @buffer: a #GstBuffer
 *
 * Function called when @meta is freed in @buffer.
 */
typedef void (*GstMetaFreeFunction)     (GstMeta *meta, GstBuffer *buffer);

/**
 * gst_meta_transform_copy:
 *
 * GQuark for the "gst-copy" transform.
 */
GST_EXPORT GQuark _gst_meta_transform_copy;

/**
 * GST_META_TRANSFORM_IS_COPY:
 * @type: a transform type
 *
 * Check if the transform type is a copy transform
 */
#define GST_META_TRANSFORM_IS_COPY(type) ((type) == _gst_meta_transform_copy)

/**
 * GstMetaTransformCopy:
 * @region: %TRUE if only region is copied
 * @offset: the offset to copy, 0 if @region is %FALSE, otherwise > 0
 * @size: the size to copy, -1 or the buffer size when @region is %FALSE
 *
 * Extra data passed to a "gst-copy" transform #GstMetaTransformFunction.
 */
typedef struct {
  gboolean region;
  gsize offset;
  gsize size;
} GstMetaTransformCopy;

/**
 * GstMetaTransformFunction:
 * @transbuf: a #GstBuffer
 * @meta: a #GstMeta
 * @buffer: a #GstBuffer
 * @type: the transform type
 * @data: transform specific data.
 *
 * Function called for each @meta in @buffer as a result of performing a
 * transformation on @transbuf. Additional @type specific transform data
 * is passed to the function as @data.
 *
 * Implementations should check the @type of the transform and parse
 * additional type specific fields in @data that should be used to update
 * the metadata on @transbuf.
 *
 * Returns: %TRUE if the transform could be performed
 */
typedef gboolean (*GstMetaTransformFunction) (GstBuffer *transbuf,
                                              GstMeta *meta, GstBuffer *buffer,
                                              GQuark type, gpointer data);

/**
 * GstMetaInfo:
 * @api: tag identifying the metadata structure and api
 * @type: type identifying the implementor of the api
 * @size: size of the metadata
 * @init_func: function for initializing the metadata
 * @free_func: function for freeing the metadata
 * @transform_func: function for transforming the metadata
 *
 * The #GstMetaInfo provides information about a specific metadata
 * structure.
 */
struct _GstMetaInfo {
  GType                      api;
  GType                      type;
  gsize                      size;

  GstMetaInitFunction        init_func;
  GstMetaFreeFunction        free_func;
  GstMetaTransformFunction   transform_func;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

GType                gst_meta_api_type_register (const gchar *api,
                                                 const gchar **tags);
gboolean             gst_meta_api_type_has_tag  (GType api, GQuark tag);

const GstMetaInfo *  gst_meta_register          (GType api, const gchar *impl,
                                                 gsize size,
                                                 GstMetaInitFunction      init_func,
                                                 GstMetaFreeFunction      free_func,
                                                 GstMetaTransformFunction transform_func);
const GstMetaInfo *  gst_meta_get_info          (const gchar * impl);
const gchar* const*  gst_meta_api_type_get_tags (GType api);

/* some default tags */
GST_EXPORT GQuark _gst_meta_tag_memory;

/**
 * GST_META_TAG_MEMORY:
 *
 * Metadata tagged with this tag depends on the particular memory
 * or buffer that it is on.
 *
 * Deprecated: The GQuarks are not exported by any public API, use
 *   GST_META_TAG_MEMORY_STR instead.
 */
#ifndef GST_DISABLE_DEPRECATED
#define GST_META_TAG_MEMORY (_gst_meta_tag_memory)
#endif

G_END_DECLS

#endif /* __GST_META_H__ */
