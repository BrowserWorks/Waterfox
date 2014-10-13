/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstsample.h: Header for GstSample object
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


#ifndef __GST_SAMPLE_H__
#define __GST_SAMPLE_H__

#include <gst/gstbuffer.h>
#include <gst/gstcaps.h>
#include <gst/gstsegment.h>

G_BEGIN_DECLS

GST_EXPORT GType _gst_sample_type;

#define GST_TYPE_SAMPLE      (_gst_sample_type)
#define GST_IS_SAMPLE(obj)   (GST_IS_MINI_OBJECT_TYPE(obj, GST_TYPE_SAMPLE))
#define GST_SAMPLE_CAST(obj) ((GstSample *)obj)
#define GST_SAMPLE(obj)      (GST_SAMPLE_CAST(obj))

/**
 * GstSample:
 *
 * The opaque structure of a #GstSample. A sample contains a typed memory
 * block and the associated timing information. It is mainly used to
 * exchange buffers with an application.
 */
typedef struct _GstSample GstSample;

GType gst_sample_get_type            (void);

/* allocation */
GstSample *          gst_sample_new           (GstBuffer          *buffer,
                                               GstCaps            *caps,
                                               const GstSegment   *segment,
                                               GstStructure       *info);

GstBuffer *          gst_sample_get_buffer    (GstSample *sample);
GstCaps *            gst_sample_get_caps      (GstSample *sample);
GstSegment *         gst_sample_get_segment   (GstSample *sample);
const GstStructure * gst_sample_get_info      (GstSample *sample);

/* refcounting */
/**
 * gst_sample_ref:
 * @sample: a #GstSample
 *
 * Increases the refcount of the given sample by one.
 *
 * Returns: (transfer full): @sample
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstSample * gst_sample_ref (GstSample * sample);
#endif

static inline GstSample *
gst_sample_ref (GstSample * sample)
{
  return GST_SAMPLE_CAST (gst_mini_object_ref (GST_MINI_OBJECT_CAST (
      sample)));
}

/**
 * gst_sample_unref:
 * @sample: (transfer full): a #GstSample
 *
 * Decreases the refcount of the sample. If the refcount reaches 0, the
 * sample will be freed.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC void gst_sample_unref (GstSample * sample);
#endif

static inline void
gst_sample_unref (GstSample * sample)
{
  gst_mini_object_unref (GST_MINI_OBJECT_CAST (sample));
}

/* copy sample */
/**
 * gst_sample_copy:
 * @buf: a #GstSample.
 *
 * Create a copy of the given sample. This will also make a newly allocated
 * copy of the data the source sample contains.
 *
 * Returns: (transfer full): a new copy of @buf.
 *
 * Since: 1.2
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstSample * gst_sample_copy (const GstSample * buf);
#endif

static inline GstSample *
gst_sample_copy (const GstSample * buf)
{
  return GST_SAMPLE_CAST (gst_mini_object_copy (GST_MINI_OBJECT_CONST_CAST (buf)));
}

/**
 * gst_value_set_sample:
 * @v: a #GValue to receive the data
 * @b: (transfer none): a #GstSample to assign to the GstValue
 *
 * Sets @b as the value of @v.  Caller retains reference to sample.
 */
#define         gst_value_set_sample(v,b)       g_value_set_boxed((v),(b))
/**
 * gst_value_take_sample:
 * @v: a #GValue to receive the data
 * @b: (transfer full): a #GstSample to assign to the GstValue
 *
 * Sets @b as the value of @v.  Caller gives away reference to sample.
 */
#define         gst_value_take_sample(v,b)      g_value_take_boxed(v,(b))
/**
 * gst_value_get_sample:
 * @v: a #GValue to query
 *
 * Receives a #GstSample as the value of @v. Does not return a reference to
 * the sample, so the pointer is only valid for as long as the caller owns
 * a reference to @v.
 *
 * Returns: (transfer none): sample
 */
#define         gst_value_get_sample(v)         GST_SAMPLE_CAST (g_value_get_boxed(v))

G_END_DECLS

#endif /* __GST_SAMPLE_H__ */
