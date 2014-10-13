/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstbuffer.h: Header for GstBuffer object
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


#ifndef __GST_BUFFER_H__
#define __GST_BUFFER_H__

#include <gst/gstminiobject.h>
#include <gst/gstclock.h>
#include <gst/gstallocator.h>

G_BEGIN_DECLS

GST_EXPORT GType _gst_buffer_type;

typedef struct _GstBuffer GstBuffer;
typedef struct _GstBufferPool GstBufferPool;

#define GST_TYPE_BUFFER                         (_gst_buffer_type)
#define GST_IS_BUFFER(obj)                      (GST_IS_MINI_OBJECT_TYPE(obj, GST_TYPE_BUFFER))
#define GST_BUFFER_CAST(obj)                    ((GstBuffer *)(obj))
#define GST_BUFFER(obj)                         (GST_BUFFER_CAST(obj))

/**
 * GST_BUFFER_FLAGS:
 * @buf: a #GstBuffer.
 *
 * A flags word containing #GstBufferFlags flags set on this buffer.
 */
#define GST_BUFFER_FLAGS(buf)                   GST_MINI_OBJECT_FLAGS(buf)
/**
 * GST_BUFFER_FLAG_IS_SET:
 * @buf: a #GstBuffer.
 * @flag: the #GstBufferFlags flag to check.
 *
 * Gives the status of a specific flag on a buffer.
 */
#define GST_BUFFER_FLAG_IS_SET(buf,flag)        GST_MINI_OBJECT_FLAG_IS_SET (buf, flag)
/**
 * GST_BUFFER_FLAG_SET:
 * @buf: a #GstBuffer.
 * @flag: the #GstBufferFlags flag to set.
 *
 * Sets a buffer flag on a buffer.
 */
#define GST_BUFFER_FLAG_SET(buf,flag)           GST_MINI_OBJECT_FLAG_SET (buf, flag)
/**
 * GST_BUFFER_FLAG_UNSET:
 * @buf: a #GstBuffer.
 * @flag: the #GstBufferFlags flag to clear.
 *
 * Clears a buffer flag.
 */
#define GST_BUFFER_FLAG_UNSET(buf,flag)         GST_MINI_OBJECT_FLAG_UNSET (buf, flag)


/**
 * GST_BUFFER_PTS:
 * @buf: a #GstBuffer.:
 *
 * The presentation timestamp (pts) in nanoseconds (as a #GstClockTime)
 * of the data in the buffer. This is the timestamp when the media should be
 * presented to the user.
 * Value will be %GST_CLOCK_TIME_NONE if the pts is unknown.
 */
#define GST_BUFFER_PTS(buf)                     (GST_BUFFER_CAST(buf)->pts)
/**
 * GST_BUFFER_DTS:
 * @buf: a #GstBuffer.:
 *
 * The decoding timestamp (dts) in nanoseconds (as a #GstClockTime)
 * of the data in the buffer. This is the timestamp when the media should be
 * decoded or processed otherwise.
 * Value will be %GST_CLOCK_TIME_NONE if the dts is unknown.
 */
#define GST_BUFFER_DTS(buf)                     (GST_BUFFER_CAST(buf)->dts)
/**
 * GST_BUFFER_DURATION:
 * @buf: a #GstBuffer.
 *
 * The duration in nanoseconds (as a #GstClockTime) of the data in the buffer.
 * Value will be %GST_CLOCK_TIME_NONE if the duration is unknown.
 */
#define GST_BUFFER_DURATION(buf)                (GST_BUFFER_CAST(buf)->duration)
/**
 * GST_BUFFER_OFFSET:
 * @buf: a #GstBuffer.
 *
 * The offset in the source file of the beginning of this buffer.
 */
#define GST_BUFFER_OFFSET(buf)                  (GST_BUFFER_CAST(buf)->offset)
/**
 * GST_BUFFER_OFFSET_END:
 * @buf: a #GstBuffer.
 *
 * The offset in the source file of the end of this buffer.
 */
#define GST_BUFFER_OFFSET_END(buf)              (GST_BUFFER_CAST(buf)->offset_end)

/**
 * GST_BUFFER_OFFSET_NONE:
 *
 * Constant for no-offset return results.
 */
#define GST_BUFFER_OFFSET_NONE  ((guint64)-1)

/**
 * GST_BUFFER_DURATION_IS_VALID:
 * @buffer: a #GstBuffer
 *
 * Tests if the duration is known.
 */
#define GST_BUFFER_DURATION_IS_VALID(buffer)    (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_DURATION (buffer)))
/**
 * GST_BUFFER_PTS_IS_VALID:
 * @buffer: a #GstBuffer
 *
 * Tests if the pts is known.
 */
#define GST_BUFFER_PTS_IS_VALID(buffer)   (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_PTS (buffer)))
/**
 * GST_BUFFER_DTS_IS_VALID:
 * @buffer: a #GstBuffer
 *
 * Tests if the dts is known.
 */
#define GST_BUFFER_DTS_IS_VALID(buffer)   (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_DTS (buffer)))
/**
 * GST_BUFFER_OFFSET_IS_VALID:
 * @buffer: a #GstBuffer
 *
 * Tests if the start offset is known.
 */
#define GST_BUFFER_OFFSET_IS_VALID(buffer)      (GST_BUFFER_OFFSET (buffer) != GST_BUFFER_OFFSET_NONE)
/**
 * GST_BUFFER_OFFSET_END_IS_VALID:
 * @buffer: a #GstBuffer
 *
 * Tests if the end offset is known.
 */
#define GST_BUFFER_OFFSET_END_IS_VALID(buffer)  (GST_BUFFER_OFFSET_END (buffer) != GST_BUFFER_OFFSET_NONE)
/**
 * GST_BUFFER_IS_DISCONT:
 * @buffer: a #GstBuffer
 *
 * Tests if the buffer marks a discontinuity in the stream.
 */
#define GST_BUFFER_IS_DISCONT(buffer)   (GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DISCONT))

/**
 * GstBufferFlags:
 * @GST_BUFFER_FLAG_LIVE:        the buffer is live data and should be discarded in
 *                               the PAUSED state.
 * @GST_BUFFER_FLAG_DECODE_ONLY: the buffer contains data that should be dropped
 *                               because it will be clipped against the segment
 *                               boundaries or because it does not contain data
 *                               that should be shown to the user.
 * @GST_BUFFER_FLAG_DISCONT:     the buffer marks a data discontinuity in the stream.
 *                               This typically occurs after a seek or a dropped buffer
 *                               from a live or network source.
 * @GST_BUFFER_FLAG_RESYNC:      the buffer timestamps might have a discontinuity
 *                               and this buffer is a good point to resynchronize.
 * @GST_BUFFER_FLAG_CORRUPTED:   the buffer data is corrupted.
 * @GST_BUFFER_FLAG_MARKER:      the buffer contains a media specific marker. for
 *                               video this is typically the end of a frame boundary, for audio
 *                               this is usually the start of a talkspurt.
 * @GST_BUFFER_FLAG_HEADER:      the buffer contains header information that is
 *                               needed to decode the following data.
 * @GST_BUFFER_FLAG_GAP:         the buffer has been created to fill a gap in the
 *                               stream and contains media neutral data (elements can
 *                               switch to optimized code path that ignores the buffer
 *                               content).
 * @GST_BUFFER_FLAG_DROPPABLE:   the buffer can be dropped without breaking the
 *                               stream, for example to reduce bandwidth.
 * @GST_BUFFER_FLAG_DELTA_UNIT:  this unit cannot be decoded independently.
 * @GST_BUFFER_FLAG_TAG_MEMORY:  this flag is set when memory of the buffer
 *                               is added/removed
 * @GST_BUFFER_FLAG_LAST:        additional media specific flags can be added starting from
 *                               this flag.
 *
 * A set of buffer flags used to describe properties of a #GstBuffer.
 */
typedef enum {
  GST_BUFFER_FLAG_LIVE        = (GST_MINI_OBJECT_FLAG_LAST << 0),
  GST_BUFFER_FLAG_DECODE_ONLY = (GST_MINI_OBJECT_FLAG_LAST << 1),
  GST_BUFFER_FLAG_DISCONT     = (GST_MINI_OBJECT_FLAG_LAST << 2),
  GST_BUFFER_FLAG_RESYNC      = (GST_MINI_OBJECT_FLAG_LAST << 3),
  GST_BUFFER_FLAG_CORRUPTED   = (GST_MINI_OBJECT_FLAG_LAST << 4),
  GST_BUFFER_FLAG_MARKER      = (GST_MINI_OBJECT_FLAG_LAST << 5),
  GST_BUFFER_FLAG_HEADER      = (GST_MINI_OBJECT_FLAG_LAST << 6),
  GST_BUFFER_FLAG_GAP         = (GST_MINI_OBJECT_FLAG_LAST << 7),
  GST_BUFFER_FLAG_DROPPABLE   = (GST_MINI_OBJECT_FLAG_LAST << 8),
  GST_BUFFER_FLAG_DELTA_UNIT  = (GST_MINI_OBJECT_FLAG_LAST << 9),
  GST_BUFFER_FLAG_TAG_MEMORY  = (GST_MINI_OBJECT_FLAG_LAST << 10),

  GST_BUFFER_FLAG_LAST        = (GST_MINI_OBJECT_FLAG_LAST << 16)
} GstBufferFlags;

/**
 * GstBuffer:
 * @mini_object: the parent structure
 * @pool: pointer to the pool owner of the buffer
 * @pts: presentation timestamp of the buffer, can be #GST_CLOCK_TIME_NONE when the
 *     pts is not known or relevant. The pts contains the timestamp when the
 *     media should be presented to the user.
 * @dts: decoding timestamp of the buffer, can be #GST_CLOCK_TIME_NONE when the
 *     dts is not known or relevant. The dts contains the timestamp when the
 *     media should be processed.
 * @duration: duration in time of the buffer data, can be #GST_CLOCK_TIME_NONE
 *     when the duration is not known or relevant.
 * @offset: a media specific offset for the buffer data.
 *     For video frames, this is the frame number of this buffer.
 *     For audio samples, this is the offset of the first sample in this buffer.
 *     For file data or compressed data this is the byte offset of the first
 *       byte in this buffer.
 * @offset_end: the last offset contained in this buffer. It has the same
 *     format as @offset.
 *
 * The structure of a #GstBuffer. Use the associated macros to access the public
 * variables.
 */
struct _GstBuffer {
  GstMiniObject          mini_object;

  /*< public >*/ /* with COW */
  GstBufferPool         *pool;

  /* timestamp */
  GstClockTime           pts;
  GstClockTime           dts;
  GstClockTime           duration;

  /* media specific offset */
  guint64                offset;
  guint64                offset_end;
};

GType       gst_buffer_get_type            (void);

guint       gst_buffer_get_max_memory      (void);

/* allocation */
GstBuffer * gst_buffer_new                 (void);
GstBuffer * gst_buffer_new_allocate        (GstAllocator * allocator, gsize size,
                                            GstAllocationParams * params);
GstBuffer * gst_buffer_new_wrapped_full    (GstMemoryFlags flags, gpointer data, gsize maxsize,
                                            gsize offset, gsize size, gpointer user_data,
                                            GDestroyNotify notify);
GstBuffer * gst_buffer_new_wrapped         (gpointer data, gsize size);

/* memory blocks */
guint       gst_buffer_n_memory             (GstBuffer *buffer);
void        gst_buffer_insert_memory        (GstBuffer *buffer, gint idx, GstMemory *mem);
void        gst_buffer_replace_memory_range (GstBuffer *buffer, guint idx, gint length, GstMemory *mem);
GstMemory * gst_buffer_peek_memory          (GstBuffer *buffer, guint idx);
GstMemory * gst_buffer_get_memory_range     (GstBuffer *buffer, guint idx, gint length);
void        gst_buffer_remove_memory_range  (GstBuffer *buffer, guint idx, gint length);

void        gst_buffer_prepend_memory       (GstBuffer *buffer, GstMemory *mem);
void        gst_buffer_append_memory        (GstBuffer *buffer, GstMemory *mem);
void        gst_buffer_replace_memory       (GstBuffer *buffer, guint idx, GstMemory *mem);
void        gst_buffer_replace_all_memory   (GstBuffer *buffer, GstMemory *mem);
GstMemory * gst_buffer_get_memory           (GstBuffer *buffer, guint idx);
GstMemory * gst_buffer_get_all_memory       (GstBuffer *buffer);
void        gst_buffer_remove_memory        (GstBuffer *buffer, guint idx);
void        gst_buffer_remove_all_memory    (GstBuffer *buffer);

gboolean    gst_buffer_find_memory         (GstBuffer *buffer, gsize offset, gsize size,
                                            guint *idx, guint *length, gsize *skip);

gboolean    gst_buffer_is_memory_range_writable  (GstBuffer *buffer, guint idx, gint length);
gboolean    gst_buffer_is_all_memory_writable    (GstBuffer *buffer);

gsize       gst_buffer_fill                (GstBuffer *buffer, gsize offset,
                                            gconstpointer src, gsize size);
gsize       gst_buffer_extract             (GstBuffer *buffer, gsize offset,
                                            gpointer dest, gsize size);
gint        gst_buffer_memcmp              (GstBuffer *buffer, gsize offset,
                                            gconstpointer mem, gsize size);
gsize       gst_buffer_memset              (GstBuffer *buffer, gsize offset,
                                            guint8 val, gsize size);

gsize       gst_buffer_get_sizes_range     (GstBuffer *buffer, guint idx, gint length,
                                            gsize *offset, gsize *maxsize);
gboolean    gst_buffer_resize_range        (GstBuffer *buffer, guint idx, gint length,
                                            gssize offset, gssize size);

gsize       gst_buffer_get_sizes           (GstBuffer *buffer, gsize *offset, gsize *maxsize);
gsize       gst_buffer_get_size            (GstBuffer *buffer);
void        gst_buffer_resize              (GstBuffer *buffer, gssize offset, gssize size);
void        gst_buffer_set_size            (GstBuffer *buffer, gssize size);

gboolean    gst_buffer_map_range           (GstBuffer *buffer, guint idx, gint length,
                                            GstMapInfo *info, GstMapFlags flags);
gboolean    gst_buffer_map                 (GstBuffer *buffer, GstMapInfo *info, GstMapFlags flags);

void        gst_buffer_unmap               (GstBuffer *buffer, GstMapInfo *info);
void        gst_buffer_extract_dup         (GstBuffer *buffer, gsize offset,
                                            gsize size, gpointer *dest,
                                            gsize *dest_size);

/* refcounting */
/**
 * gst_buffer_ref:
 * @buf: a #GstBuffer.
 *
 * Increases the refcount of the given buffer by one.
 *
 * Note that the refcount affects the writability
 * of @buf and its metadata, see gst_buffer_is_writable().
 * It is important to note that keeping additional references to
 * GstBuffer instances can potentially increase the number
 * of memcpy operations in a pipeline.
 *
 * Returns: (transfer full): @buf
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstBuffer * gst_buffer_ref (GstBuffer * buf);
#endif

static inline GstBuffer *
gst_buffer_ref (GstBuffer * buf)
{
  return (GstBuffer *) gst_mini_object_ref (GST_MINI_OBJECT_CAST (buf));
}

/**
 * gst_buffer_unref:
 * @buf: (transfer full): a #GstBuffer.
 *
 * Decreases the refcount of the buffer. If the refcount reaches 0, the buffer
 * with the associated metadata and memory will be freed.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC void gst_buffer_unref (GstBuffer * buf);
#endif

static inline void
gst_buffer_unref (GstBuffer * buf)
{
  gst_mini_object_unref (GST_MINI_OBJECT_CAST (buf));
}

/* copy buffer */
/**
 * gst_buffer_copy:
 * @buf: a #GstBuffer.
 *
 * Create a copy of the given buffer. This will also make a newly allocated
 * copy of the data the source buffer contains.
 *
 * Returns: (transfer full): a new copy of @buf.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstBuffer * gst_buffer_copy (const GstBuffer * buf);
#endif

static inline GstBuffer *
gst_buffer_copy (const GstBuffer * buf)
{
  return GST_BUFFER (gst_mini_object_copy (GST_MINI_OBJECT_CONST_CAST (buf)));
}


/**
 * GstBufferCopyFlags:
 * @GST_BUFFER_COPY_NONE: copy nothing
 * @GST_BUFFER_COPY_FLAGS: flag indicating that buffer flags should be copied
 * @GST_BUFFER_COPY_TIMESTAMPS: flag indicating that buffer pts, dts,
 *   duration, offset and offset_end should be copied
 * @GST_BUFFER_COPY_MEMORY: flag indicating that buffer memory should be reffed
 *   and appended to already existing memory. Unless the memory is marked as
 *   NO_SHARE, no actual copy of the memory is made but it is simply reffed.
 *   Add @GST_BUFFER_COPY_DEEP to force a real copy.
 * @GST_BUFFER_COPY_MERGE: flag indicating that buffer memory should be
 *   merged
 * @GST_BUFFER_COPY_META: flag indicating that buffer meta should be
 *   copied
 * @GST_BUFFER_COPY_DEEP: flag indicating that memory should always be
 *   copied instead of reffed (Since 1.2)
 *
 * A set of flags that can be provided to the gst_buffer_copy_into()
 * function to specify which items should be copied.
 */
typedef enum {
  GST_BUFFER_COPY_NONE           = 0,
  GST_BUFFER_COPY_FLAGS          = (1 << 0),
  GST_BUFFER_COPY_TIMESTAMPS     = (1 << 1),
  GST_BUFFER_COPY_META           = (1 << 2),
  GST_BUFFER_COPY_MEMORY         = (1 << 3),
  GST_BUFFER_COPY_MERGE          = (1 << 4),
  GST_BUFFER_COPY_DEEP           = (1 << 5)
} GstBufferCopyFlags;

/**
 * GST_BUFFER_COPY_METADATA:
 *
 * Combination of all possible metadata fields that can be copied with
 * gst_buffer_copy_into().
 */
#define GST_BUFFER_COPY_METADATA       (GST_BUFFER_COPY_FLAGS | GST_BUFFER_COPY_TIMESTAMPS |\
                                        GST_BUFFER_COPY_META)

/**
 * GST_BUFFER_COPY_ALL:
 *
 * Combination of all possible fields that can be copied with
 * gst_buffer_copy_into().
 */
#define GST_BUFFER_COPY_ALL  ((GstBufferCopyFlags)(GST_BUFFER_COPY_METADATA | GST_BUFFER_COPY_MEMORY))

/* copies memory or metadata into newly allocated buffer */
gboolean        gst_buffer_copy_into            (GstBuffer *dest, GstBuffer *src,
                                                 GstBufferCopyFlags flags,
                                                 gsize offset, gsize size);

/**
 * gst_buffer_is_writable:
 * @buf: a #GstBuffer
 *
 * Tests if you can safely write to a buffer's metadata or its memory array.
 * It is only safe to change buffer metadata when the current reference is
 * writable, i.e. nobody can see the modifications you will make.
 */
#define         gst_buffer_is_writable(buf)     gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (buf))
/**
 * gst_buffer_make_writable:
 * @buf: (transfer full): a #GstBuffer
 *
 * Makes a writable buffer from the given buffer. If the source buffer is
 * already writable, this will simply return the same buffer. A copy will
 * otherwise be made using gst_buffer_copy().
 *
 * Returns: (transfer full): a writable buffer which may or may not be the
 *     same as @buf
 */
#define         gst_buffer_make_writable(buf)   GST_BUFFER_CAST (gst_mini_object_make_writable (GST_MINI_OBJECT_CAST (buf)))

/**
 * gst_buffer_replace:
 * @obuf: (inout) (transfer full) (nullable): pointer to a pointer to
 *     a #GstBuffer to be replaced.
 * @nbuf: (transfer none) (allow-none): pointer to a #GstBuffer that will
 *     replace the buffer pointed to by @obuf.
 *
 * Modifies a pointer to a #GstBuffer to point to a different #GstBuffer. The
 * modification is done atomically (so this is useful for ensuring thread safety
 * in some cases), and the reference counts are updated appropriately (the old
 * buffer is unreffed, the new is reffed).
 *
 * Either @nbuf or the #GstBuffer pointed to by @obuf may be %NULL.
 *
 * Returns: %TRUE when @obuf was different from @nbuf.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC gboolean gst_buffer_replace (GstBuffer **obuf, GstBuffer *nbuf);
#endif

static inline gboolean
gst_buffer_replace (GstBuffer **obuf, GstBuffer *nbuf)
{
  return gst_mini_object_replace ((GstMiniObject **) obuf, (GstMiniObject *) nbuf);
}

/* creating a region */
GstBuffer*      gst_buffer_copy_region          (GstBuffer *parent, GstBufferCopyFlags flags,
                                                 gsize offset, gsize size);

/* append two buffers */
GstBuffer*      gst_buffer_append_region        (GstBuffer *buf1, GstBuffer *buf2,
                                                 gssize offset, gssize size);
GstBuffer*      gst_buffer_append               (GstBuffer *buf1, GstBuffer *buf2);

/* metadata */
#include <gst/gstmeta.h>

/**
 * GstBufferForeachMetaFunc:
 * @buffer: a #GstBuffer
 * @meta: (out) (nullable): a pointer to a #GstMeta
 * @user_data: user data passed to gst_buffer_foreach_meta()
 *
 * A function that will be called from gst_buffer_foreach_meta(). The @meta
 * field will point to a the reference of the meta.
 *
 * @buffer should not be modified from this callback.
 *
 * When this function returns %TRUE, the next meta will be
 * returned. When %FALSE is returned, gst_buffer_foreach_meta() will return.
 *
 * When @meta is set to %NULL, the item will be removed from the buffer.
 *
 * Returns: %FALSE when gst_buffer_foreach_meta() should stop
 */
typedef gboolean (*GstBufferForeachMetaFunc)    (GstBuffer *buffer, GstMeta **meta,
                                                 gpointer user_data);

GstMeta *       gst_buffer_get_meta             (GstBuffer *buffer, GType api);
GstMeta *       gst_buffer_add_meta             (GstBuffer *buffer, const GstMetaInfo *info,
                                                 gpointer params);
gboolean        gst_buffer_remove_meta          (GstBuffer *buffer, GstMeta *meta);

GstMeta *       gst_buffer_iterate_meta         (GstBuffer *buffer, gpointer *state);

gboolean        gst_buffer_foreach_meta         (GstBuffer *buffer,
                                                 GstBufferForeachMetaFunc func,
                                                 gpointer user_data);

/**
 * gst_value_set_buffer:
 * @v: a #GValue to receive the data
 * @b: (transfer none): a #GstBuffer to assign to the GstValue
 *
 * Sets @b as the value of @v.  Caller retains reference to buffer.
 */
#define         gst_value_set_buffer(v,b)       g_value_set_boxed((v),(b))
/**
 * gst_value_take_buffer:
 * @v: a #GValue to receive the data
 * @b: (transfer full): a #GstBuffer to assign to the GstValue
 *
 * Sets @b as the value of @v.  Caller gives away reference to buffer.
 */
#define         gst_value_take_buffer(v,b)      g_value_take_boxed(v,(b))
/**
 * gst_value_get_buffer:
 * @v: a #GValue to query
 *
 * Receives a #GstBuffer as the value of @v. Does not return a reference to
 * the buffer, so the pointer is only valid for as long as the caller owns
 * a reference to @v.
 *
 * Returns: (transfer none): buffer
 */
#define         gst_value_get_buffer(v)         GST_BUFFER_CAST (g_value_get_boxed(v))

G_END_DECLS

#endif /* __GST_BUFFER_H__ */
