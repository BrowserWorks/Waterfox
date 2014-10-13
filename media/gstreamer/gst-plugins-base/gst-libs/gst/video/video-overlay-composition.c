/* GStreamer Video Overlay Composition
 * Copyright (C) 2011 Intel Corporation
 * Copyright (C) 2011 Collabora Ltd.
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
 * SECTION:gstvideooverlaycomposition
 * @short_description: Video Buffer Overlay Compositions (Subtitles, Logos)
 *
 * <refsect2>
 * <para>
 * Functions to create and handle overlay compositions on video buffers.
 * </para>
 * <para>
 * An overlay composition describes one or more overlay rectangles to be
 * blended on top of a video buffer.
 * </para>
 * <para>
 * This API serves two main purposes:
 * <itemizedlist>
 * <listitem>
 * it can be used to attach overlay information (subtitles or logos)
 * to non-raw video buffers such as GL/VAAPI/VDPAU surfaces. The actual
 * blending of the overlay can then be done by e.g. the video sink that
 * processes these non-raw buffers.
 * </listitem>
 * <listitem>
 * it can also be used to blend overlay rectangles on top of raw video
 * buffers, thus consolidating blending functionality for raw video in
 * one place.
 * </listitem>
 * Together, this allows existing overlay elements to easily handle raw
 * and non-raw video as input in without major changes (once the overlays
 * have been put into a #GstOverlayComposition object anyway) - for raw
 * video the overlay can just use the blending function to blend the data
 * on top of the video, and for surface buffers it can just attach them to
 * the buffer and let the sink render the overlays.
 * </itemizedlist>
 * </para>
 * </refsect2>
 */

/* TODO:
 *  - provide accessors for seq_num and other fields (as needed)
 *  - allow overlay to set/get original pango markup string on/from rectangle
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "video-overlay-composition.h"
#include "video-blend.h"
#include "gstvideometa.h"
#include <string.h>

struct _GstVideoOverlayComposition
{
  GstMiniObject parent;

  guint num_rectangles;
  GstVideoOverlayRectangle **rectangles;

  /* lowest rectangle sequence number still used by the upstream
   * overlay element. This way a renderer maintaining some kind of
   * rectangles <-> surface cache can know when to free cached
   * surfaces/rectangles. */
  guint min_seq_num_used;

  /* sequence number for the composition (same series as rectangles) */
  guint seq_num;
};

struct _GstVideoOverlayRectangle
{
  GstMiniObject parent;

  /* Position on video frame and dimension of output rectangle in
   * output frame terms (already adjusted for the PAR of the output
   * frame). x/y can be negative (overlay will be clipped then) */
  gint x, y;
  guint render_width, render_height;

  /* Info on overlay pixels (format, width, height) */
  GstVideoInfo info;

  /* The flags associated to this rectangle */
  GstVideoOverlayFormatFlags flags;

  /* Refcounted blob of memory, no caps or timestamps */
  GstBuffer *pixels;

  /* FIXME: how to express source like text or pango markup?
   *        (just add source type enum + source buffer with data)
   *
   * FOR 0.10: always send pixel blobs, but attach source data in
   * addition (reason: if downstream changes, we can't renegotiate
   * that properly, if we just do a query of supported formats from
   * the start). Sink will just ignore pixels and use pango markup
   * from source data if it supports that.
   *
   * FOR 0.11: overlay should query formats (pango markup, pixels)
   * supported by downstream and then only send that. We can
   * renegotiate via the reconfigure event.
   */

  /* sequence number: useful for backends/renderers/sinks that want
   * to maintain a cache of rectangles <-> surfaces. The value of
   * the min_seq_num_used in the composition tells the renderer which
   * rectangles have expired. */
  guint seq_num;

  /* global alpha: global alpha value of the rectangle. Each each per-pixel
   * alpha value of image-data will be multiplied with the global alpha value
   * during blending.
   * Can be used for efficient fading in/out of overlay rectangles.
   * GstElements that render OverlayCompositions and don't support global alpha
   * should simply ignore it.*/
  gfloat global_alpha;

  /* track alpha-values already applied: */
  gfloat applied_global_alpha;
  /* store initial per-pixel alpha values: */
  guint8 *initial_alpha;

  /* FIXME: we may also need a (private) way to cache converted/scaled
   * pixel blobs */
  GMutex lock;

  GList *scaled_rectangles;
};

#define GST_RECTANGLE_LOCK(rect)   g_mutex_lock(&rect->lock)
#define GST_RECTANGLE_UNLOCK(rect) g_mutex_unlock(&rect->lock)

/* --------------------------- utility functions --------------------------- */

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT ensure_debug_category()

static GstDebugCategory *
ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat_done;

    cat_done = (gsize) _gst_debug_category_new ("video-composition", 0,
        "video overlay composition");

    g_once_init_leave (&cat_gonce, cat_done);
  }

  return (GstDebugCategory *) cat_gonce;
}

#else

#define ensure_debug_category() /* NOOP */

#endif /* GST_DISABLE_GST_DEBUG */

static guint
gst_video_overlay_get_seqnum (void)
{
  static gint seqnum;           /* 0 */

  return (guint) g_atomic_int_add (&seqnum, 1);
}

static void
gst_video_overlay_composition_meta_free (GstMeta * meta, GstBuffer * buf)
{
  GstVideoOverlayCompositionMeta *ometa;

  ometa = (GstVideoOverlayCompositionMeta *) meta;

  if (ometa->overlay)
    gst_video_overlay_composition_unref (ometa->overlay);
}

static gboolean
gst_video_overlay_composition_meta_transform (GstBuffer * dest, GstMeta * meta,
    GstBuffer * buffer, GQuark type, gpointer data)
{
  GstVideoOverlayCompositionMeta *dmeta, *smeta;

  smeta = (GstVideoOverlayCompositionMeta *) meta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    GstMetaTransformCopy *copy = data;

    if (!copy->region) {
      GST_DEBUG ("copy video overlay composition metadata");

      /* only copy if the complete data is copied as well */
      dmeta =
          (GstVideoOverlayCompositionMeta *) gst_buffer_add_meta (dest,
          GST_VIDEO_OVERLAY_COMPOSITION_META_INFO, NULL);
      dmeta->overlay = gst_video_overlay_composition_ref (smeta->overlay);
    }
  }
  return TRUE;
}

GType
gst_video_overlay_composition_meta_api_get_type (void)
{
  static volatile GType type = 0;
  static const gchar *tags[] = { NULL };

  if (g_once_init_enter (&type)) {
    GType _type =
        gst_meta_api_type_register ("GstVideoOverlayCompositionMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

/* video overlay composition metadata */
const GstMetaInfo *
gst_video_overlay_composition_meta_get_info (void)
{
  static const GstMetaInfo *video_overlay_composition_meta_info = NULL;

  if (g_once_init_enter (&video_overlay_composition_meta_info)) {
    const GstMetaInfo *meta =
        gst_meta_register (GST_VIDEO_OVERLAY_COMPOSITION_META_API_TYPE,
        "GstVideoOverlayCompositionMeta",
        sizeof (GstVideoOverlayCompositionMeta), (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) gst_video_overlay_composition_meta_free,
        (GstMetaTransformFunction)
        gst_video_overlay_composition_meta_transform);
    g_once_init_leave (&video_overlay_composition_meta_info, meta);
  }
  return video_overlay_composition_meta_info;
}

/**
 * gst_buffer_add_video_overlay_composition_meta:
 * @buf: a #GstBuffer
 * @comp: (allow-none): a #GstVideoOverlayComposition
 *
 * Sets an overlay composition on a buffer. The buffer will obtain its own
 * reference to the composition, meaning this function does not take ownership
 * of @comp.
 */
GstVideoOverlayCompositionMeta *
gst_buffer_add_video_overlay_composition_meta (GstBuffer * buf,
    GstVideoOverlayComposition * comp)
{
  GstVideoOverlayCompositionMeta *ometa;

  g_return_val_if_fail (gst_buffer_is_writable (buf), NULL);

  ometa = (GstVideoOverlayCompositionMeta *)
      gst_buffer_add_meta (buf, GST_VIDEO_OVERLAY_COMPOSITION_META_INFO, NULL);

  ometa->overlay = gst_video_overlay_composition_ref (comp);

  return ometa;
}

/* ------------------------------ composition ------------------------------ */

#define RECTANGLE_ARRAY_STEP 4  /* premature optimization */

GST_DEFINE_MINI_OBJECT_TYPE (GstVideoOverlayComposition,
    gst_video_overlay_composition);

static void
gst_video_overlay_composition_free (GstMiniObject * mini_obj)
{
  GstVideoOverlayComposition *comp = (GstVideoOverlayComposition *) mini_obj;
  guint num;

  num = comp->num_rectangles;

  while (num > 0) {
    gst_video_overlay_rectangle_unref (comp->rectangles[num - 1]);
    --num;
  }

  g_free (comp->rectangles);
  comp->rectangles = NULL;
  comp->num_rectangles = 0;

  g_slice_free (GstVideoOverlayComposition, comp);
}

/**
 * gst_video_overlay_composition_new:
 * @rectangle: (transfer none): a #GstVideoOverlayRectangle to add to the
 *     composition
 *
 * Creates a new video overlay composition object to hold one or more
 * overlay rectangles.
 *
 * Returns: (transfer full): a new #GstVideoOverlayComposition. Unref with
 *     gst_video_overlay_composition_unref() when no longer needed.
 */
GstVideoOverlayComposition *
gst_video_overlay_composition_new (GstVideoOverlayRectangle * rectangle)
{
  GstVideoOverlayComposition *comp;


  /* FIXME: should we allow empty compositions? Could also be expressed as
   * buffer without a composition on it. Maybe there are cases where doing
   * an empty new + _add() in a loop is easier? */
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);

  comp = g_slice_new0 (GstVideoOverlayComposition);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (comp), 0,
      GST_TYPE_VIDEO_OVERLAY_COMPOSITION,
      (GstMiniObjectCopyFunction) gst_video_overlay_composition_copy,
      NULL, (GstMiniObjectFreeFunction) gst_video_overlay_composition_free);

  comp->rectangles = g_new0 (GstVideoOverlayRectangle *, RECTANGLE_ARRAY_STEP);
  comp->rectangles[0] = gst_video_overlay_rectangle_ref (rectangle);
  comp->num_rectangles = 1;

  comp->seq_num = gst_video_overlay_get_seqnum ();

  /* since the rectangle was created earlier, its seqnum is smaller than ours */
  comp->min_seq_num_used = rectangle->seq_num;

  GST_LOG ("new composition %p: seq_num %u with rectangle %p", comp,
      comp->seq_num, rectangle);

  return comp;
}

/**
 * gst_video_overlay_composition_add_rectangle:
 * @comp: a #GstVideoOverlayComposition
 * @rectangle: (transfer none): a #GstVideoOverlayRectangle to add to the
 *     composition
 *
 * Adds an overlay rectangle to an existing overlay composition object. This
 * must be done right after creating the overlay composition.
 */
void
gst_video_overlay_composition_add_rectangle (GstVideoOverlayComposition * comp,
    GstVideoOverlayRectangle * rectangle)
{
  g_return_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp));
  g_return_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle));
  g_return_if_fail (GST_MINI_OBJECT_REFCOUNT_VALUE (comp) == 1);

  if (comp->num_rectangles % RECTANGLE_ARRAY_STEP == 0) {
    comp->rectangles =
        g_renew (GstVideoOverlayRectangle *, comp->rectangles,
        comp->num_rectangles + RECTANGLE_ARRAY_STEP);
  }

  comp->rectangles[comp->num_rectangles] =
      gst_video_overlay_rectangle_ref (rectangle);
  comp->num_rectangles += 1;

  comp->min_seq_num_used = MIN (comp->min_seq_num_used, rectangle->seq_num);

  GST_LOG ("composition %p: added rectangle %p", comp, rectangle);
}

/**
 * gst_video_overlay_composition_n_rectangles:
 * @comp: a #GstVideoOverlayComposition
 *
 * Returns the number of #GstVideoOverlayRectangle<!-- -->s contained in @comp.
 *
 * Returns: the number of rectangles
 */
guint
gst_video_overlay_composition_n_rectangles (GstVideoOverlayComposition * comp)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), 0);

  return comp->num_rectangles;
}

/**
 * gst_video_overlay_composition_get_rectangle:
 * @comp: a #GstVideoOverlayComposition
 * @n: number of the rectangle to get
 *
 * Returns the @n-th #GstVideoOverlayRectangle contained in @comp.
 *
 * Returns: (transfer none): the @n-th rectangle, or NULL if @n is out of
 *     bounds. Will not return a new reference, the caller will need to
 *     obtain her own reference using gst_video_overlay_rectangle_ref()
 *     if needed.
 */
GstVideoOverlayRectangle *
gst_video_overlay_composition_get_rectangle (GstVideoOverlayComposition * comp,
    guint n)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), NULL);

  if (n >= comp->num_rectangles)
    return NULL;

  return comp->rectangles[n];
}

static gboolean
gst_video_overlay_rectangle_needs_scaling (GstVideoOverlayRectangle * r)
{
  return (GST_VIDEO_INFO_WIDTH (&r->info) != r->render_width ||
      GST_VIDEO_INFO_HEIGHT (&r->info) != r->render_height);
}

/**
 * gst_video_overlay_composition_blend:
 * @comp: a #GstVideoOverlayComposition
 * @video_buf: a #GstVideoFrame containing raw video data in a supported format
 *
 * Blends the overlay rectangles in @comp on top of the raw video data
 * contained in @video_buf. The data in @video_buf must be writable and
 * mapped appropriately.
 */
/* FIXME: formats with more than 8 bit per component which get unpacked into
 * ARGB64 or AYUV64 (such as v210, v216, UYVP, GRAY16_LE and GRAY16_BE)
 * are not supported yet by the code in video-blend.c.
 */
gboolean
gst_video_overlay_composition_blend (GstVideoOverlayComposition * comp,
    GstVideoFrame * video_buf)
{
  GstVideoInfo scaled_info;
  GstVideoInfo *vinfo;
  GstVideoFrame rectangle_frame;
  GstVideoFormat fmt;
  GstBuffer *pixels = NULL;
  gboolean ret = TRUE;
  guint n, num;
  int w, h;

  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), FALSE);
  g_return_val_if_fail (video_buf != NULL, FALSE);

  w = GST_VIDEO_FRAME_WIDTH (video_buf);
  h = GST_VIDEO_FRAME_HEIGHT (video_buf);
  fmt = GST_VIDEO_FRAME_FORMAT (video_buf);

  num = comp->num_rectangles;
  GST_LOG ("Blending composition %p with %u rectangles onto video buffer %p "
      "(%ux%u, format %u)", comp, num, video_buf, w, h, fmt);

  for (n = 0; n < num; ++n) {
    GstVideoOverlayRectangle *rect;
    gboolean needs_scaling;

    rect = comp->rectangles[n];

    GST_LOG (" rectangle %u %p: %ux%u, format %u", n, rect,
        GST_VIDEO_INFO_WIDTH (&rect->info), GST_VIDEO_INFO_HEIGHT (&rect->info),
        GST_VIDEO_INFO_FORMAT (&rect->info));

    needs_scaling = gst_video_overlay_rectangle_needs_scaling (rect);
    if (needs_scaling) {
      gst_video_blend_scale_linear_RGBA (&rect->info, rect->pixels,
          rect->render_height, rect->render_width, &scaled_info, &pixels);
      vinfo = &scaled_info;
    } else {
      pixels = gst_buffer_ref (rect->pixels);
      vinfo = &rect->info;
    }

    gst_video_frame_map (&rectangle_frame, vinfo, pixels, GST_MAP_READ);

    ret = gst_video_blend (video_buf, &rectangle_frame, rect->x, rect->y,
        rect->global_alpha);
    gst_video_frame_unmap (&rectangle_frame);
    if (!ret) {
      GST_WARNING ("Could not blend overlay rectangle onto video buffer");
    }

    /* FIXME: should cache scaled pixels in the rectangle struct */
    gst_buffer_unref (pixels);
  }

  return ret;
}

/**
 * gst_video_overlay_composition_copy:
 * @comp: (transfer none): a #GstVideoOverlayComposition to copy
 *
 * Makes a copy of @comp and all contained rectangles, so that it is possible
 * to modify the composition and contained rectangles (e.g. add additional
 * rectangles or change the render co-ordinates or render dimension). The
 * actual overlay pixel data buffers contained in the rectangles are not
 * copied.
 *
 * Returns: (transfer full): a new #GstVideoOverlayComposition equivalent
 *     to @comp.
 */
GstVideoOverlayComposition *
gst_video_overlay_composition_copy (GstVideoOverlayComposition * comp)
{
  GstVideoOverlayComposition *copy;
  GstVideoOverlayRectangle *rect;
  guint n;

  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), NULL);

  if (G_LIKELY (comp->num_rectangles == 0))
    return gst_video_overlay_composition_new (NULL);

  rect = gst_video_overlay_rectangle_copy (comp->rectangles[0]);
  copy = gst_video_overlay_composition_new (rect);
  gst_video_overlay_rectangle_unref (rect);

  for (n = 1; n < comp->num_rectangles; ++n) {
    rect = gst_video_overlay_rectangle_copy (comp->rectangles[n]);
    gst_video_overlay_composition_add_rectangle (copy, rect);
    gst_video_overlay_rectangle_unref (rect);
  }

  return copy;
}

/**
 * gst_video_overlay_composition_make_writable:
 * @comp: (transfer full): a #GstVideoOverlayComposition to copy
 *
 * Takes ownership of @comp and returns a version of @comp that is writable
 * (i.e. can be modified). Will either return @comp right away, or create a
 * new writable copy of @comp and unref @comp itself. All the contained
 * rectangles will also be copied, but the actual overlay pixel data buffers
 * contained in the rectangles are not copied.
 *
 * Returns: (transfer full): a writable #GstVideoOverlayComposition
 *     equivalent to @comp.
 */
GstVideoOverlayComposition *
gst_video_overlay_composition_make_writable (GstVideoOverlayComposition * comp)
{
  GstVideoOverlayComposition *writable_comp;

  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), NULL);

  if (GST_MINI_OBJECT_REFCOUNT_VALUE (comp) == 1) {
    guint n;

    for (n = 0; n < comp->num_rectangles; ++n) {
      if (GST_MINI_OBJECT_REFCOUNT_VALUE (comp->rectangles[n]) != 1)
        goto copy;
    }
    return comp;
  }

copy:

  writable_comp = gst_video_overlay_composition_copy (comp);
  gst_video_overlay_composition_unref (comp);

  return writable_comp;
}

/**
 * gst_video_overlay_composition_get_seqnum:
 * @comp: a #GstVideoOverlayComposition
 *
 * Returns the sequence number of this composition. Sequence numbers are
 * monotonically increasing and unique for overlay compositions and rectangles
 * (meaning there will never be a rectangle with the same sequence number as
 * a composition).
 *
 * Returns: the sequence number of @comp
 */
guint
gst_video_overlay_composition_get_seqnum (GstVideoOverlayComposition * comp)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_COMPOSITION (comp), 0);

  return comp->seq_num;
}

/* ------------------------------ rectangles ------------------------------ -*/

GST_DEFINE_MINI_OBJECT_TYPE (GstVideoOverlayRectangle,
    gst_video_overlay_rectangle);

static void
gst_video_overlay_rectangle_free (GstMiniObject * mini_obj)
{
  GstVideoOverlayRectangle *rect = (GstVideoOverlayRectangle *) mini_obj;

  gst_buffer_replace (&rect->pixels, NULL);

  while (rect->scaled_rectangles != NULL) {
    GstVideoOverlayRectangle *scaled_rect = rect->scaled_rectangles->data;

    gst_video_overlay_rectangle_unref (scaled_rect);

    rect->scaled_rectangles =
        g_list_delete_link (rect->scaled_rectangles, rect->scaled_rectangles);
  }

  g_free (rect->initial_alpha);
  g_mutex_clear (&rect->lock);

  g_slice_free (GstVideoOverlayRectangle, rect);
}

static inline gboolean
gst_video_overlay_rectangle_check_flags (GstVideoOverlayFormatFlags flags)
{
  /* Check flags only contains flags we know about */
  return (flags & ~(GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA |
          GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA)) == 0;
}

static gboolean
gst_video_overlay_rectangle_is_same_alpha_type (GstVideoOverlayFormatFlags
    flags1, GstVideoOverlayFormatFlags flags2)
{
  return ((flags1 ^ flags2) & GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA)
      == 0;
}


/**
 * gst_video_overlay_rectangle_new_raw:
 * @pixels: (transfer none): a #GstBuffer pointing to the pixel memory
 * @render_x: the X co-ordinate on the video where the top-left corner of this
 *     overlay rectangle should be rendered to
 * @render_y: the Y co-ordinate on the video where the top-left corner of this
 *     overlay rectangle should be rendered to
 * @render_width: the render width of this rectangle on the video
 * @render_height: the render height of this rectangle on the video
 * @flags: flags
 *
 * Creates a new video overlay rectangle with ARGB or AYUV pixel data.
 * The layout in case of ARGB of the components in memory is B-G-R-A
 * on little-endian platforms
 * (corresponding to #GST_VIDEO_FORMAT_BGRA) and A-R-G-B on big-endian
 * platforms (corresponding to #GST_VIDEO_FORMAT_ARGB). In other words,
 * pixels are treated as 32-bit words and the lowest 8 bits then contain
 * the blue component value and the highest 8 bits contain the alpha
 * component value. Unless specified in the flags, the RGB values are
 * non-premultiplied. This is the format that is used by most hardware,
 * and also many rendering libraries such as Cairo, for example.
 * The pixel data buffer must have #GstVideoMeta set.
 *
 * Returns: (transfer full): a new #GstVideoOverlayRectangle. Unref with
 *     gst_video_overlay_rectangle_unref() when no longer needed.
 */
GstVideoOverlayRectangle *
gst_video_overlay_rectangle_new_raw (GstBuffer * pixels,
    gint render_x, gint render_y, guint render_width, guint render_height,
    GstVideoOverlayFormatFlags flags)
{
  GstVideoOverlayRectangle *rect;
  GstVideoMeta *vmeta;
  GstVideoFormat format;
  guint width, height;

  g_return_val_if_fail (GST_IS_BUFFER (pixels), NULL);
  g_return_val_if_fail (render_height > 0 && render_width > 0, NULL);
  g_return_val_if_fail (gst_video_overlay_rectangle_check_flags (flags), NULL);

  /* buffer must have video meta with some expected settings */
  vmeta = gst_buffer_get_video_meta (pixels);
  g_return_val_if_fail (vmeta, NULL);
  g_return_val_if_fail (vmeta->format ==
      GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB ||
      vmeta->format == GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV, NULL);
  g_return_val_if_fail (vmeta->flags == GST_VIDEO_FRAME_FLAG_NONE, NULL);

  format = vmeta->format;
  width = vmeta->width;
  height = vmeta->height;

  /* technically ((height-1)*stride)+width might be okay too */
  g_return_val_if_fail (gst_buffer_get_size (pixels) >= height * width * 4,
      NULL);
  g_return_val_if_fail (height > 0 && width > 0, NULL);

  rect = g_slice_new0 (GstVideoOverlayRectangle);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (rect), 0,
      GST_TYPE_VIDEO_OVERLAY_RECTANGLE,
      (GstMiniObjectCopyFunction) gst_video_overlay_rectangle_copy,
      NULL, (GstMiniObjectFreeFunction) gst_video_overlay_rectangle_free);

  g_mutex_init (&rect->lock);

  rect->pixels = gst_buffer_ref (pixels);
  rect->scaled_rectangles = NULL;

  gst_video_info_init (&rect->info);
  gst_video_info_set_format (&rect->info, format, width, height);
  if (flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA)
    rect->info.flags |= GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA;

  rect->x = render_x;
  rect->y = render_y;
  rect->render_width = render_width;
  rect->render_height = render_height;

  rect->global_alpha = 1.0;
  rect->applied_global_alpha = 1.0;
  rect->initial_alpha = NULL;

  rect->flags = flags;

  rect->seq_num = gst_video_overlay_get_seqnum ();

  GST_LOG ("new rectangle %p: %ux%u => %ux%u @ %u,%u, seq_num %u, format %u, "
      "flags %x, pixels %p, global_alpha=%f", rect, width, height, render_width,
      render_height, render_x, render_y, rect->seq_num, format,
      rect->flags, pixels, rect->global_alpha);

  return rect;
}

/**
 * gst_video_overlay_rectangle_get_render_rectangle:
 * @rectangle: a #GstVideoOverlayRectangle
 * @render_x: (out) (allow-none): address where to store the X render offset
 * @render_y: (out) (allow-none): address where to store the Y render offset
 * @render_width: (out) (allow-none): address where to store the render width
 * @render_height: (out) (allow-none): address where to store the render height
 *
 * Retrieves the render position and render dimension of the overlay
 * rectangle on the video.
 *
 * Returns: TRUE if valid render dimensions were retrieved.
 */
gboolean
gst_video_overlay_rectangle_get_render_rectangle (GstVideoOverlayRectangle *
    rectangle, gint * render_x, gint * render_y, guint * render_width,
    guint * render_height)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), FALSE);

  if (render_x)
    *render_x = rectangle->x;
  if (render_y)
    *render_y = rectangle->y;
  if (render_width)
    *render_width = rectangle->render_width;
  if (render_height)
    *render_height = rectangle->render_height;

  return TRUE;
}

/**
 * gst_video_overlay_rectangle_set_render_rectangle:
 * @rectangle: a #GstVideoOverlayRectangle
 * @render_x: render X position of rectangle on video
 * @render_y: render Y position of rectangle on video
 * @render_width: render width of rectangle
 * @render_height: render height of rectangle
 *
 * Sets the render position and dimensions of the rectangle on the video.
 * This function is mainly for elements that modify the size of the video
 * in some way (e.g. through scaling or cropping) and need to adjust the
 * details of any overlays to match the operation that changed the size.
 *
 * @rectangle must be writable, meaning its refcount must be 1. You can
 * make the rectangles inside a #GstVideoOverlayComposition writable using
 * gst_video_overlay_composition_make_writable() or
 * gst_video_overlay_composition_copy().
 */
void
gst_video_overlay_rectangle_set_render_rectangle (GstVideoOverlayRectangle *
    rectangle, gint render_x, gint render_y, guint render_width,
    guint render_height)
{
  g_return_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle));
  g_return_if_fail (GST_MINI_OBJECT_REFCOUNT_VALUE (rectangle) == 1);

  rectangle->x = render_x;
  rectangle->y = render_y;
  rectangle->render_width = render_width;
  rectangle->render_height = render_height;
}

/* FIXME: orc-ify */
static void
gst_video_overlay_rectangle_premultiply_0 (GstVideoFrame * frame)
{
  int i, j;
  for (j = 0; j < GST_VIDEO_FRAME_HEIGHT (frame); ++j) {
    guint8 *line;

    line = GST_VIDEO_FRAME_PLANE_DATA (frame, 0);
    line += GST_VIDEO_FRAME_PLANE_STRIDE (frame, 0) * j;
    for (i = 0; i < GST_VIDEO_FRAME_WIDTH (frame); ++i) {
      int a = line[0];
      line[1] = line[1] * a / 255;
      line[2] = line[2] * a / 255;
      line[3] = line[3] * a / 255;
      line += 4;
    }
  }
}

static void
gst_video_overlay_rectangle_premultiply_3 (GstVideoFrame * frame)
{
  int i, j;
  for (j = 0; j < GST_VIDEO_FRAME_HEIGHT (frame); ++j) {
    guint8 *line;

    line = GST_VIDEO_FRAME_PLANE_DATA (frame, 0);
    line += GST_VIDEO_FRAME_PLANE_STRIDE (frame, 0) * j;
    for (i = 0; i < GST_VIDEO_FRAME_WIDTH (frame); ++i) {
      int a = line[3];
      line[0] = line[0] * a / 255;
      line[1] = line[1] * a / 255;
      line[2] = line[2] * a / 255;
      line += 4;
    }
  }
}

static void
gst_video_overlay_rectangle_premultiply (GstVideoFrame * frame)
{
  gint alpha_offset;

  alpha_offset = GST_VIDEO_FRAME_COMP_POFFSET (frame, 3);
  switch (alpha_offset) {
    case 0:
      gst_video_overlay_rectangle_premultiply_0 (frame);
      break;
    case 3:
      gst_video_overlay_rectangle_premultiply_3 (frame);
      break;
    default:
      g_assert_not_reached ();
      break;
  }
}

/* FIXME: orc-ify */
static void
gst_video_overlay_rectangle_unpremultiply_0 (GstVideoFrame * frame)
{
  int i, j;
  for (j = 0; j < GST_VIDEO_FRAME_HEIGHT (frame); ++j) {
    guint8 *line;

    line = GST_VIDEO_FRAME_PLANE_DATA (frame, 0);
    line += GST_VIDEO_FRAME_PLANE_STRIDE (frame, 0) * j;
    for (i = 0; i < GST_VIDEO_FRAME_WIDTH (frame); ++i) {
      int a = line[0];
      if (a) {
        line[1] = MIN ((line[1] * 255 + a / 2) / a, 255);
        line[2] = MIN ((line[2] * 255 + a / 2) / a, 255);
        line[3] = MIN ((line[3] * 255 + a / 2) / a, 255);
      }
      line += 4;
    }
  }
}

static void
gst_video_overlay_rectangle_unpremultiply_3 (GstVideoFrame * frame)
{
  int i, j;
  for (j = 0; j < GST_VIDEO_FRAME_HEIGHT (frame); ++j) {
    guint8 *line;

    line = GST_VIDEO_FRAME_PLANE_DATA (frame, 0);
    line += GST_VIDEO_FRAME_PLANE_STRIDE (frame, 0) * j;
    for (i = 0; i < GST_VIDEO_FRAME_WIDTH (frame); ++i) {
      int a = line[3];
      if (a) {
        line[0] = MIN ((line[0] * 255 + a / 2) / a, 255);
        line[1] = MIN ((line[1] * 255 + a / 2) / a, 255);
        line[2] = MIN ((line[2] * 255 + a / 2) / a, 255);
      }
      line += 4;
    }
  }
}

static void
gst_video_overlay_rectangle_unpremultiply (GstVideoFrame * frame)
{
  gint alpha_offset;

  alpha_offset = GST_VIDEO_FRAME_COMP_POFFSET (frame, 3);
  switch (alpha_offset) {
    case 0:
      gst_video_overlay_rectangle_unpremultiply_0 (frame);
      break;
    case 3:
      gst_video_overlay_rectangle_unpremultiply_3 (frame);
      break;
    default:
      g_assert_not_reached ();
      break;
  }
}


static void
gst_video_overlay_rectangle_extract_alpha (GstVideoOverlayRectangle * rect)
{
  guint8 *src, *dst;
  GstVideoFrame frame;
  gint i, j, w, h, stride, alpha_offset;

  alpha_offset = GST_VIDEO_INFO_COMP_POFFSET (&rect->info, 3);
  g_return_if_fail (alpha_offset == 0 || alpha_offset == 3);

  gst_video_frame_map (&frame, &rect->info, rect->pixels, GST_MAP_READ);
  src = GST_VIDEO_FRAME_PLANE_DATA (&frame, 0);
  w = GST_VIDEO_INFO_WIDTH (&rect->info);
  h = GST_VIDEO_INFO_HEIGHT (&rect->info);
  stride = GST_VIDEO_INFO_PLANE_STRIDE (&rect->info, 0);

  g_free (rect->initial_alpha);
  rect->initial_alpha = g_malloc (w * h);
  dst = rect->initial_alpha;

  for (i = 0; i < h; i++) {
    for (j = 0; j < w; j++) {
      *dst = src[alpha_offset];
      dst++;
      src += 4;
    }
    src += stride - 4 * w;
  }
  gst_video_frame_unmap (&frame);
}


static void
gst_video_overlay_rectangle_apply_global_alpha (GstVideoOverlayRectangle * rect,
    float global_alpha)
{
  guint8 *src, *dst;
  GstVideoFrame frame;
  gint i, j, w, h, stride;
  gint argb_a, argb_r, argb_g, argb_b;
  gint alpha_offset;

  g_assert (!(rect->applied_global_alpha != 1.0
          && rect->initial_alpha == NULL));

  alpha_offset = GST_VIDEO_INFO_COMP_POFFSET (&rect->info, 3);
  g_return_if_fail (alpha_offset == 0 || alpha_offset == 3);

  if (global_alpha == rect->applied_global_alpha)
    return;

  if (rect->initial_alpha == NULL)
    gst_video_overlay_rectangle_extract_alpha (rect);

  src = rect->initial_alpha;
  rect->pixels = gst_buffer_make_writable (rect->pixels);

  gst_video_frame_map (&frame, &rect->info, rect->pixels, GST_MAP_READ);
  dst = GST_VIDEO_FRAME_PLANE_DATA (&frame, 0);
  w = GST_VIDEO_INFO_WIDTH (&rect->info);
  h = GST_VIDEO_INFO_HEIGHT (&rect->info);
  stride = GST_VIDEO_INFO_PLANE_STRIDE (&rect->info, 0);

  argb_a = GST_VIDEO_INFO_COMP_POFFSET (&rect->info, 3);
  argb_r = (argb_a + 1) % 4;
  argb_g = (argb_a + 2) % 4;
  argb_b = (argb_a + 3) % 4;

  for (i = 0; i < h; i++) {
    for (j = 0; j < w; j++) {
      guint8 na = (guint8) (*src * global_alpha);

      if (! !(rect->flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA)) {
        dst[argb_r] =
            (guint8) ((double) (dst[argb_r] * 255) / (double) dst[argb_a]) *
            na / 255;
        dst[argb_g] =
            (guint8) ((double) (dst[argb_g] * 255) / (double) dst[argb_a]) *
            na / 255;
        dst[argb_b] =
            (guint8) ((double) (dst[argb_b] * 255) / (double) dst[argb_a]) *
            na / 255;
      }
      dst[argb_a] = na;
      src++;
      dst += 4;
    }
    dst += stride - 4 * w;
  }
  gst_video_frame_unmap (&frame);

  rect->applied_global_alpha = global_alpha;
}

static void
gst_video_overlay_rectangle_convert (GstVideoInfo * src, GstBuffer * src_buffer,
    GstVideoFormat dest_format, GstVideoInfo * dest, GstBuffer ** dest_buffer)
{
  gint width, height, stride;
  GstVideoFrame src_frame, dest_frame;
  GstVideoFormat format;
  gint k, l;
  guint8 *sdata, *ddata;

  format = GST_VIDEO_INFO_FORMAT (src);

  width = GST_VIDEO_INFO_WIDTH (src);
  height = GST_VIDEO_INFO_HEIGHT (src);

  gst_video_info_init (dest);
  gst_video_info_set_format (dest, dest_format, width, height);

  *dest_buffer = gst_buffer_new_and_alloc (GST_VIDEO_INFO_SIZE (dest));

  gst_video_frame_map (&src_frame, src, src_buffer, GST_MAP_READ);
  gst_video_frame_map (&dest_frame, dest, *dest_buffer, GST_MAP_WRITE);

  sdata = GST_VIDEO_FRAME_PLANE_DATA (&src_frame, 0);
  ddata = GST_VIDEO_FRAME_PLANE_DATA (&dest_frame, 0);
  stride = GST_VIDEO_FRAME_PLANE_STRIDE (&src_frame, 0);

  if (format == GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV &&
      dest_format == GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB) {
    gint ayuv;
    gint a, y, u, v, r, g, b;

    for (k = 0; k < height; k++) {
      for (l = 0; l < width; l++) {
        ayuv = GST_READ_UINT32_BE (sdata);
        a = ayuv >> 24;
        y = (ayuv >> 16) & 0xff;
        u = (ayuv >> 8) & 0xff;
        v = (ayuv & 0xff);

        r = (298 * y + 459 * v - 63514) >> 8;
        g = (298 * y - 55 * u - 136 * v + 19681) >> 8;
        b = (298 * y + 541 * u - 73988) >> 8;

        r = CLAMP (r, 0, 255);
        g = CLAMP (g, 0, 255);
        b = CLAMP (b, 0, 255);

        /* native endian ARGB */
        *(guint32 *) ddata = ((a << 24) | (r << 16) | (g << 8) | b);

        sdata += 4;
        ddata += 4;
      }
      sdata += stride - 4 * width;
    }
  } else if (format == GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB &&
      dest_format == GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV) {
    gint argb;
    gint a, y, u, v, r, g, b;

    for (k = 0; k < height; k++) {
      for (l = 0; l < width; l++) {
        /* native endian ARGB */
        argb = *(guint32 *) sdata;
        a = argb >> 24;
        r = (argb >> 16) & 0xff;
        g = (argb >> 8) & 0xff;
        b = (argb & 0xff);

        y = (47 * r + 157 * g + 16 * b + 4096) >> 8;
        u = (-26 * r - 87 * g + 112 * b + 32768) >> 8;
        v = (112 * r - 102 * g - 10 * b + 32768) >> 8;

        y = CLAMP (y, 0, 255);
        u = CLAMP (u, 0, 255);
        v = CLAMP (v, 0, 255);

        GST_WRITE_UINT32_BE (ddata, ((a << 24) | (y << 16) | (u << 8) | v));

        sdata += 4;
        ddata += 4;
      }
      sdata += stride - 4 * width;
    }
  } else {
    GST_ERROR ("unsupported conversion");
    g_assert_not_reached ();
  }

  gst_video_frame_unmap (&src_frame);
  gst_video_frame_unmap (&dest_frame);
}

static GstBuffer *
gst_video_overlay_rectangle_get_pixels_raw_internal (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags, gboolean unscaled,
    GstVideoFormat wanted_format)
{
  GstVideoOverlayFormatFlags new_flags;
  GstVideoOverlayRectangle *scaled_rect = NULL, *conv_rect = NULL;
  GstVideoInfo info;
  GstVideoFrame frame;
  GstBuffer *buf;
  GList *l;
  guint width, height;
  guint wanted_width;
  guint wanted_height;
  gboolean apply_global_alpha;
  gboolean revert_global_alpha;
  GstVideoFormat format;

  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);
  g_return_val_if_fail (gst_video_overlay_rectangle_check_flags (flags), NULL);

  width = GST_VIDEO_INFO_WIDTH (&rectangle->info);
  height = GST_VIDEO_INFO_HEIGHT (&rectangle->info);
  wanted_width = unscaled ? width : rectangle->render_width;
  wanted_height = unscaled ? height : rectangle->render_height;
  format = GST_VIDEO_INFO_FORMAT (&rectangle->info);

  apply_global_alpha =
      (! !(rectangle->flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA)
      && !(flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA));
  revert_global_alpha =
      (! !(rectangle->flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA)
      && ! !(flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA));

  /* This assumes we don't need to adjust the format */
  if (wanted_width == width &&
      wanted_height == height &&
      wanted_format == format &&
      gst_video_overlay_rectangle_is_same_alpha_type (rectangle->flags,
          flags)) {
    /* don't need to apply/revert global-alpha either: */
    if ((!apply_global_alpha
            || rectangle->applied_global_alpha == rectangle->global_alpha)
        && (!revert_global_alpha || rectangle->applied_global_alpha == 1.0)) {
      return rectangle->pixels;
    } else {
      /* only apply/revert global-alpha */
      scaled_rect = rectangle;
      goto done;
    }
  }

  /* see if we've got one cached already */
  GST_RECTANGLE_LOCK (rectangle);
  for (l = rectangle->scaled_rectangles; l != NULL; l = l->next) {
    GstVideoOverlayRectangle *r = l->data;

    if (GST_VIDEO_INFO_WIDTH (&r->info) == wanted_width &&
        GST_VIDEO_INFO_HEIGHT (&r->info) == wanted_height &&
        GST_VIDEO_INFO_FORMAT (&r->info) == wanted_format &&
        gst_video_overlay_rectangle_is_same_alpha_type (r->flags, flags)) {
      /* we'll keep these rectangles around until finalize, so it's ok not
       * to take our own ref here */
      scaled_rect = r;
      break;
    }
  }
  GST_RECTANGLE_UNLOCK (rectangle);

  if (scaled_rect != NULL)
    goto done;

  /* maybe have one in the right format though */
  if (format != wanted_format) {
    GST_RECTANGLE_LOCK (rectangle);
    for (l = rectangle->scaled_rectangles; l != NULL; l = l->next) {
      GstVideoOverlayRectangle *r = l->data;

      if (GST_VIDEO_INFO_FORMAT (&r->info) == wanted_format &&
          gst_video_overlay_rectangle_is_same_alpha_type (r->flags, flags)) {
        /* we'll keep these rectangles around until finalize, so it's ok not
         * to take our own ref here */
        conv_rect = r;
        break;
      }
    }
    GST_RECTANGLE_UNLOCK (rectangle);
  } else {
    conv_rect = rectangle;
  }

  if (conv_rect == NULL) {
    GstVideoInfo conv_info;

    gst_video_overlay_rectangle_convert (&rectangle->info, rectangle->pixels,
        wanted_format, &conv_info, &buf);
    gst_buffer_add_video_meta (buf, GST_VIDEO_FRAME_FLAG_NONE,
        GST_VIDEO_INFO_FORMAT (&conv_info), width, height);
    conv_rect = gst_video_overlay_rectangle_new_raw (buf,
        0, 0, width, height, rectangle->flags);
    if (rectangle->global_alpha != 1.0)
      gst_video_overlay_rectangle_set_global_alpha (scaled_rect,
          rectangle->global_alpha);
    gst_buffer_unref (buf);
    /* keep this converted one around as well in any case */
    GST_RECTANGLE_LOCK (rectangle);
    rectangle->scaled_rectangles =
        g_list_prepend (rectangle->scaled_rectangles, conv_rect);
    GST_RECTANGLE_UNLOCK (rectangle);
  }

  /* now we continue from conv_rect */
  width = GST_VIDEO_INFO_WIDTH (&conv_rect->info);
  height = GST_VIDEO_INFO_HEIGHT (&conv_rect->info);
  format = GST_VIDEO_INFO_FORMAT (&conv_rect->info);

  /* not cached yet, do the preprocessing and put the result into our cache */
  if (wanted_width != width || wanted_height != height) {
    GstVideoInfo scaled_info;

    /* we could check the cache for a scaled rect with global_alpha == 1 here */
    gst_video_blend_scale_linear_RGBA (&conv_rect->info, conv_rect->pixels,
        wanted_height, wanted_width, &scaled_info, &buf);
    info = scaled_info;
    gst_buffer_add_video_meta (buf, GST_VIDEO_FRAME_FLAG_NONE,
        GST_VIDEO_INFO_FORMAT (&conv_rect->info), wanted_width, wanted_height);
  } else if (!gst_video_overlay_rectangle_is_same_alpha_type (conv_rect->flags,
          flags)) {
    /* if we don't have to scale, we have to modify the alpha values, so we
     * need to make a copy of the pixel memory (and we take ownership below) */
    buf = gst_buffer_copy (conv_rect->pixels);
    info = conv_rect->info;
  } else {
    /* do not need to scale or modify alpha values, almost done then */
    scaled_rect = conv_rect;
    goto done;
  }

  new_flags = conv_rect->flags;
  gst_video_frame_map (&frame, &info, buf, GST_MAP_READWRITE);
  if (!gst_video_overlay_rectangle_is_same_alpha_type (conv_rect->flags, flags)) {
    if (rectangle->flags & GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA) {
      gst_video_overlay_rectangle_unpremultiply (&frame);
      new_flags &= ~GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA;
    } else {
      gst_video_overlay_rectangle_premultiply (&frame);
      new_flags |= GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA;
    }
  }
  gst_video_frame_unmap (&frame);

  scaled_rect = gst_video_overlay_rectangle_new_raw (buf,
      0, 0, wanted_width, wanted_height, new_flags);
  if (conv_rect->global_alpha != 1.0)
    gst_video_overlay_rectangle_set_global_alpha (scaled_rect,
        conv_rect->global_alpha);
  gst_buffer_unref (buf);

  GST_RECTANGLE_LOCK (rectangle);
  rectangle->scaled_rectangles =
      g_list_prepend (rectangle->scaled_rectangles, scaled_rect);
  GST_RECTANGLE_UNLOCK (rectangle);

done:

  GST_RECTANGLE_LOCK (rectangle);
  if (apply_global_alpha
      && scaled_rect->applied_global_alpha != rectangle->global_alpha) {
    gst_video_overlay_rectangle_apply_global_alpha (scaled_rect,
        rectangle->global_alpha);
    gst_video_overlay_rectangle_set_global_alpha (scaled_rect,
        rectangle->global_alpha);
  } else if (revert_global_alpha && scaled_rect->applied_global_alpha != 1.0) {
    gst_video_overlay_rectangle_apply_global_alpha (scaled_rect, 1.0);
  }
  GST_RECTANGLE_UNLOCK (rectangle);

  return scaled_rect->pixels;
}


/**
 * gst_video_overlay_rectangle_get_pixels_raw:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Returns: (transfer none): a #GstBuffer holding the pixel data with
 *    format as originally provided and specified in video meta with
 *    width and height of the render dimensions as per
 *    gst_video_overlay_rectangle_get_render_rectangle(). This function does
 *    not return a reference, the caller should obtain a reference of her own
 *    with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_raw (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, FALSE, GST_VIDEO_INFO_FORMAT (&rectangle->info));
}

/**
 * gst_video_overlay_rectangle_get_pixels_argb:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Returns: (transfer none): a #GstBuffer holding the ARGB pixel data with
 *    width and height of the render dimensions as per
 *    gst_video_overlay_rectangle_get_render_rectangle(). This function does
 *    not return a reference, the caller should obtain a reference of her own
 *    with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_argb (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, FALSE, GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB);
}

/**
 * gst_video_overlay_rectangle_get_pixels_ayuv:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Returns: (transfer none): a #GstBuffer holding the AYUV pixel data with
 *    width and height of the render dimensions as per
 *    gst_video_overlay_rectangle_get_render_rectangle(). This function does
 *    not return a reference, the caller should obtain a reference of her own
 *    with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_ayuv (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, FALSE, GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV);
}

/**
 * gst_video_overlay_rectangle_get_pixels_unscaled_raw:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags.
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Retrieves the pixel data as it is. This is useful if the caller can
 * do the scaling itself when handling the overlaying. The rectangle will
 * need to be scaled to the render dimensions, which can be retrieved using
 * gst_video_overlay_rectangle_get_render_rectangle().
 *
 * Returns: (transfer none): a #GstBuffer holding the pixel data with
 *    #GstVideoMeta set. This function does not return a reference, the caller
 *    should obtain a reference of her own with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_unscaled_raw (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);

  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, TRUE, GST_VIDEO_INFO_FORMAT (&rectangle->info));
}

/**
 * gst_video_overlay_rectangle_get_pixels_unscaled_argb:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags.
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Retrieves the pixel data as it is. This is useful if the caller can
 * do the scaling itself when handling the overlaying. The rectangle will
 * need to be scaled to the render dimensions, which can be retrieved using
 * gst_video_overlay_rectangle_get_render_rectangle().
 *
 * Returns: (transfer none): a #GstBuffer holding the ARGB pixel data with
 *    #GstVideoMeta set. This function does not return a reference, the caller
 *    should obtain a reference of her own with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_unscaled_argb (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);

  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, TRUE, GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB);
}

/**
 * gst_video_overlay_rectangle_get_pixels_unscaled_ayuv:
 * @rectangle: a #GstVideoOverlayRectangle
 * @flags: flags.
 *    If a global_alpha value != 1 is set for the rectangle, the caller
 *    should set the #GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA flag
 *    if he wants to apply global-alpha himself. If the flag is not set
 *    global_alpha is applied internally before returning the pixel-data.
 *
 * Retrieves the pixel data as it is. This is useful if the caller can
 * do the scaling itself when handling the overlaying. The rectangle will
 * need to be scaled to the render dimensions, which can be retrieved using
 * gst_video_overlay_rectangle_get_render_rectangle().
 *
 * Returns: (transfer none): a #GstBuffer holding the AYUV pixel data with
 *    #GstVideoMeta set. This function does not return a reference, the caller
 *    should obtain a reference of her own with gst_buffer_ref() if needed.
 */
GstBuffer *
gst_video_overlay_rectangle_get_pixels_unscaled_ayuv (GstVideoOverlayRectangle *
    rectangle, GstVideoOverlayFormatFlags flags)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);

  return gst_video_overlay_rectangle_get_pixels_raw_internal (rectangle,
      flags, TRUE, GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV);
}

/**
 * gst_video_overlay_rectangle_get_flags:
 * @rectangle: a #GstVideoOverlayRectangle
 *
 * Retrieves the flags associated with a #GstVideoOverlayRectangle.
 * This is useful if the caller can handle both premultiplied alpha and
 * non premultiplied alpha, for example. By knowing whether the rectangle
 * uses premultiplied or not, it can request the pixel data in the format
 * it is stored in, to avoid unnecessary conversion.
 *
 * Returns: the #GstVideoOverlayFormatFlags associated with the rectangle.
 */
GstVideoOverlayFormatFlags
gst_video_overlay_rectangle_get_flags (GstVideoOverlayRectangle * rectangle)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle),
      GST_VIDEO_OVERLAY_FORMAT_FLAG_NONE);

  return rectangle->flags;
}

/**
 * gst_video_overlay_rectangle_get_global_alpha:
 * @rectangle: a #GstVideoOverlayRectangle
 *
 * Retrieves the global-alpha value associated with a #GstVideoOverlayRectangle.
 *
 * Returns: the global-alpha value associated with the rectangle.
 */
gfloat
gst_video_overlay_rectangle_get_global_alpha (GstVideoOverlayRectangle *
    rectangle)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), -1);

  return rectangle->global_alpha;
}

/**
 * gst_video_overlay_rectangle_set_global_alpha:
 * @rectangle: a #GstVideoOverlayRectangle
 *
 * Sets the global alpha value associated with a #GstVideoOverlayRectangle. Per-
 * pixel alpha values are multiplied with this value. Valid
 * values: 0 <= global_alpha <= 1; 1 to deactivate.
 *
 # @rectangle must be writable, meaning its refcount must be 1. You can
 * make the rectangles inside a #GstVideoOverlayComposition writable using
 * gst_video_overlay_composition_make_writable() or
 * gst_video_overlay_composition_copy().
 */
void
gst_video_overlay_rectangle_set_global_alpha (GstVideoOverlayRectangle *
    rectangle, gfloat global_alpha)
{
  g_return_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle));
  g_return_if_fail (global_alpha >= 0 && global_alpha <= 1);

  if (rectangle->global_alpha != global_alpha) {
    rectangle->global_alpha = global_alpha;
    if (global_alpha != 1)
      rectangle->flags |= GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA;
    else
      rectangle->flags &= ~GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA;
    /* update seq_num automatically to signal the consumer, that data has changed
     * note, that this might mislead renderers, that can handle global-alpha
     * themselves, because what they want to know is whether the actual pixel data
     * has changed. */
    rectangle->seq_num = gst_video_overlay_get_seqnum ();
  }
}

/**
 * gst_video_overlay_rectangle_copy:
 * @rectangle: (transfer none): a #GstVideoOverlayRectangle to copy
 *
 * Makes a copy of @rectangle, so that it is possible to modify it
 * (e.g. to change the render co-ordinates or render dimension). The
 * actual overlay pixel data buffers contained in the rectangle are not
 * copied.
 *
 * Returns: (transfer full): a new #GstVideoOverlayRectangle equivalent
 *     to @rectangle.
 */
GstVideoOverlayRectangle *
gst_video_overlay_rectangle_copy (GstVideoOverlayRectangle * rectangle)
{
  GstVideoOverlayRectangle *copy;

  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), NULL);

  copy = gst_video_overlay_rectangle_new_raw (rectangle->pixels,
      rectangle->x, rectangle->y,
      rectangle->render_width, rectangle->render_height, rectangle->flags);
  if (rectangle->global_alpha != 1)
    gst_video_overlay_rectangle_set_global_alpha (copy,
        rectangle->global_alpha);

  return copy;
}

/**
 * gst_video_overlay_rectangle_get_seqnum:
 * @rectangle: a #GstVideoOverlayRectangle
 *
 * Returns the sequence number of this rectangle. Sequence numbers are
 * monotonically increasing and unique for overlay compositions and rectangles
 * (meaning there will never be a rectangle with the same sequence number as
 * a composition).
 *
 * Using the sequence number of a rectangle as an indicator for changed
 * pixel-data of a rectangle is dangereous. Some API calls, like e.g.
 * gst_video_overlay_rectangle_set_global_alpha(), automatically update
 * the per rectangle sequence number, which is misleading for renderers/
 * consumers, that handle global-alpha themselves. For them  the
 * pixel-data returned by gst_video_overlay_rectangle_get_pixels_*()
 * wont be different for different global-alpha values. In this case a
 * renderer could also use the GstBuffer pointers as a hint for changed
 * pixel-data.
 *
 * Returns: the sequence number of @rectangle
 */
guint
gst_video_overlay_rectangle_get_seqnum (GstVideoOverlayRectangle * rectangle)
{
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY_RECTANGLE (rectangle), 0);

  return rectangle->seq_num;
}
