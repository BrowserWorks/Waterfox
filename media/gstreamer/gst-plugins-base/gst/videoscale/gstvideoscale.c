/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) 2005-2012 David Schleef <ds@schleef.org>
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
 * SECTION:element-videoscale
 * @see_also: videorate, videoconvert
 *
 * This element resizes video frames. By default the element will try to
 * negotiate to the same size on the source and sinkpad so that no scaling
 * is needed. It is therefore safe to insert this element in a pipeline to
 * get more robust behaviour without any cost if no scaling is needed.
 *
 * This element supports a wide range of color spaces including various YUV and
 * RGB formats and is therefore generally able to operate anywhere in a
 * pipeline.
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch -v filesrc location=videotestsrc.ogg ! oggdemux ! theoradec ! videoconvert ! videoscale ! ximagesink
 * ]| Decode an Ogg/Theora and display the video using ximagesink. Since
 * ximagesink cannot perform scaling, the video scaling will be performed by
 * videoscale when you resize the video window.
 * To create the test Ogg/Theora file refer to the documentation of theoraenc.
 * |[
 * gst-launch -v filesrc location=videotestsrc.ogg ! oggdemux ! theoradec ! videoscale ! video/x-raw, width=50 ! xvimagesink
 * ]| Decode an Ogg/Theora and display the video using xvimagesink with a width
 * of 50.
 * </refsect2>
 */

/* 
 * Formulas for PAR, DAR, width and height relations:
 *
 * dar_n   w   par_n
 * ----- = - * -----
 * dar_d   h   par_d
 *
 * par_n    h   dar_n
 * ----- =  - * -----
 * par_d    w   dar_d
 * 
 *         dar_n   par_d
 * w = h * ----- * -----
 *         dar_d   par_n
 *
 *         dar_d   par_n
 * h = w * ----- * -----
 *         dar_n   par_d
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include <math.h>

#include <gst/video/gstvideometa.h>
#include <gst/video/gstvideopool.h>

#include "gstvideoscale.h"
#include "gstvideoscaleorc.h"
#include "vs_image.h"
#include "vs_4tap.h"
#include "vs_fill_borders.h"

/* debug variable definition */
GST_DEBUG_CATEGORY (video_scale_debug);
GST_DEBUG_CATEGORY_STATIC (GST_CAT_PERFORMANCE);

#define DEFAULT_PROP_METHOD       GST_VIDEO_SCALE_BILINEAR
#define DEFAULT_PROP_ADD_BORDERS  TRUE
#define DEFAULT_PROP_SHARPNESS    1.0
#define DEFAULT_PROP_SHARPEN      0.0
#define DEFAULT_PROP_DITHER       FALSE
#define DEFAULT_PROP_SUBMETHOD    1
#define DEFAULT_PROP_ENVELOPE     2.0

enum
{
  PROP_0,
  PROP_METHOD,
  PROP_ADD_BORDERS,
  PROP_SHARPNESS,
  PROP_SHARPEN,
  PROP_DITHER,
  PROP_SUBMETHOD,
  PROP_ENVELOPE
};

#undef GST_VIDEO_SIZE_RANGE
#define GST_VIDEO_SIZE_RANGE "(int) [ 1, 32767]"

/* FIXME: add v210 support
 * FIXME: add v216 support
 * FIXME: add NV21 support
 * FIXME: add UYVP support
 * FIXME: add A420 support
 * FIXME: add YUV9 support
 * FIXME: add YVU9 support
 * FIXME: add IYU1 support
 * FIXME: add r210 support
 */

/* FIXME: if we can do NV12, NV21 shouldn't be so hard */
#define GST_VIDEO_FORMATS "{ I420, YV12, YUY2, UYVY, AYUV, RGBx, " \
    "BGRx, xRGB, xBGR, RGBA, BGRA, ARGB, ABGR, RGB, " \
    "BGR, Y41B, Y42B, YVYU, Y444, GRAY8, GRAY16_BE, GRAY16_LE, " \
    "v308, RGB16, RGB15, ARGB64, AYUV64, NV12 } "


static GstStaticCaps gst_video_scale_format_caps =
    GST_STATIC_CAPS (GST_VIDEO_CAPS_MAKE (GST_VIDEO_FORMATS) ";"
    GST_VIDEO_CAPS_MAKE_WITH_FEATURES ("ANY", GST_VIDEO_FORMATS));

#define GST_TYPE_VIDEO_SCALE_METHOD (gst_video_scale_method_get_type())
static GType
gst_video_scale_method_get_type (void)
{
  static GType video_scale_method_type = 0;

  static const GEnumValue video_scale_methods[] = {
    {GST_VIDEO_SCALE_NEAREST, "Nearest Neighbour", "nearest-neighbour"},
    {GST_VIDEO_SCALE_BILINEAR, "Bilinear", "bilinear"},
    {GST_VIDEO_SCALE_4TAP, "4-tap", "4-tap"},
    {GST_VIDEO_SCALE_LANCZOS, "Lanczos (experimental/unstable)", "lanczos"},
    {0, NULL, NULL},
  };

  if (!video_scale_method_type) {
    video_scale_method_type =
        g_enum_register_static ("GstVideoScaleMethod", video_scale_methods);
  }
  return video_scale_method_type;
}

static GstCaps *
gst_video_scale_get_capslist (void)
{
  static GstCaps *caps = NULL;
  static volatile gsize inited = 0;

  if (g_once_init_enter (&inited)) {
    caps = gst_static_caps_get (&gst_video_scale_format_caps);
    g_once_init_leave (&inited, 1);
  }
  return caps;
}

static GstPadTemplate *
gst_video_scale_src_template_factory (void)
{
  return gst_pad_template_new ("src", GST_PAD_SRC, GST_PAD_ALWAYS,
      gst_video_scale_get_capslist ());
}

static GstPadTemplate *
gst_video_scale_sink_template_factory (void)
{
  return gst_pad_template_new ("sink", GST_PAD_SINK, GST_PAD_ALWAYS,
      gst_video_scale_get_capslist ());
}


static void gst_video_scale_finalize (GstVideoScale * videoscale);
static gboolean gst_video_scale_src_event (GstBaseTransform * trans,
    GstEvent * event);

/* base transform vmethods */
static GstCaps *gst_video_scale_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter);
static GstCaps *gst_video_scale_fixate_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps, GstCaps * othercaps);

static gboolean gst_video_scale_set_info (GstVideoFilter * filter,
    GstCaps * in, GstVideoInfo * in_info, GstCaps * out,
    GstVideoInfo * out_info);
static GstFlowReturn gst_video_scale_transform_frame (GstVideoFilter * filter,
    GstVideoFrame * in, GstVideoFrame * out);

static void gst_video_scale_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_video_scale_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static GstFlowReturn do_scale (GstVideoFilter * filter, VSImage dest[4],
    VSImage src[4]);

#define gst_video_scale_parent_class parent_class
G_DEFINE_TYPE (GstVideoScale, gst_video_scale, GST_TYPE_VIDEO_FILTER);

static void
gst_video_scale_class_init (GstVideoScaleClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;
  GstElementClass *element_class = (GstElementClass *) klass;
  GstBaseTransformClass *trans_class = (GstBaseTransformClass *) klass;
  GstVideoFilterClass *filter_class = (GstVideoFilterClass *) klass;

  gobject_class->finalize = (GObjectFinalizeFunc) gst_video_scale_finalize;
  gobject_class->set_property = gst_video_scale_set_property;
  gobject_class->get_property = gst_video_scale_get_property;

  g_object_class_install_property (gobject_class, PROP_METHOD,
      g_param_spec_enum ("method", "method", "method",
          GST_TYPE_VIDEO_SCALE_METHOD, DEFAULT_PROP_METHOD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_ADD_BORDERS,
      g_param_spec_boolean ("add-borders", "Add Borders",
          "Add black borders if necessary to keep the display aspect ratio",
          DEFAULT_PROP_ADD_BORDERS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SHARPNESS,
      g_param_spec_double ("sharpness", "Sharpness",
          "Sharpness of filter", 0.5, 1.5, DEFAULT_PROP_SHARPNESS,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SHARPEN,
      g_param_spec_double ("sharpen", "Sharpen",
          "Sharpening", 0.0, 1.0, DEFAULT_PROP_SHARPEN,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_DITHER,
      g_param_spec_boolean ("dither", "Dither",
          "Add dither (only used for Lanczos method)",
          DEFAULT_PROP_DITHER,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

#if 0
  /* I am hiding submethod for now, since it's poorly named, poorly
   * documented, and will probably just get people into trouble. */
  g_object_class_install_property (gobject_class, PROP_SUBMETHOD,
      g_param_spec_int ("submethod", "submethod",
          "submethod", 0, 3, DEFAULT_PROP_SUBMETHOD,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
#endif

  g_object_class_install_property (gobject_class, PROP_ENVELOPE,
      g_param_spec_double ("envelope", "Envelope",
          "Size of filter envelope", 1.0, 5.0, DEFAULT_PROP_ENVELOPE,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (element_class,
      "Video scaler", "Filter/Converter/Video/Scaler",
      "Resizes video", "Wim Taymans <wim.taymans@chello.be>");

  gst_element_class_add_pad_template (element_class,
      gst_video_scale_sink_template_factory ());
  gst_element_class_add_pad_template (element_class,
      gst_video_scale_src_template_factory ());

  trans_class->transform_caps =
      GST_DEBUG_FUNCPTR (gst_video_scale_transform_caps);
  trans_class->fixate_caps = GST_DEBUG_FUNCPTR (gst_video_scale_fixate_caps);
  trans_class->src_event = GST_DEBUG_FUNCPTR (gst_video_scale_src_event);

  filter_class->set_info = GST_DEBUG_FUNCPTR (gst_video_scale_set_info);
  filter_class->transform_frame =
      GST_DEBUG_FUNCPTR (gst_video_scale_transform_frame);
}

static void
gst_video_scale_init (GstVideoScale * videoscale)
{
  videoscale->tmp_buf = NULL;
  videoscale->method = DEFAULT_PROP_METHOD;
  videoscale->add_borders = DEFAULT_PROP_ADD_BORDERS;
  videoscale->submethod = DEFAULT_PROP_SUBMETHOD;
  videoscale->sharpness = DEFAULT_PROP_SHARPNESS;
  videoscale->sharpen = DEFAULT_PROP_SHARPEN;
  videoscale->dither = DEFAULT_PROP_DITHER;
  videoscale->envelope = DEFAULT_PROP_ENVELOPE;
}

static void
gst_video_scale_finalize (GstVideoScale * videoscale)
{
  if (videoscale->tmp_buf)
    g_free (videoscale->tmp_buf);

  G_OBJECT_CLASS (parent_class)->finalize (G_OBJECT (videoscale));
}

static void
gst_video_scale_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstVideoScale *vscale = GST_VIDEO_SCALE (object);

  switch (prop_id) {
    case PROP_METHOD:
      GST_OBJECT_LOCK (vscale);
      vscale->method = g_value_get_enum (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_ADD_BORDERS:
      GST_OBJECT_LOCK (vscale);
      vscale->add_borders = g_value_get_boolean (value);
      GST_OBJECT_UNLOCK (vscale);
      gst_base_transform_reconfigure_src (GST_BASE_TRANSFORM_CAST (vscale));
      break;
    case PROP_SHARPNESS:
      GST_OBJECT_LOCK (vscale);
      vscale->sharpness = g_value_get_double (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_SHARPEN:
      GST_OBJECT_LOCK (vscale);
      vscale->sharpen = g_value_get_double (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_DITHER:
      GST_OBJECT_LOCK (vscale);
      vscale->dither = g_value_get_boolean (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_SUBMETHOD:
      GST_OBJECT_LOCK (vscale);
      vscale->submethod = g_value_get_int (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_ENVELOPE:
      GST_OBJECT_LOCK (vscale);
      vscale->envelope = g_value_get_double (value);
      GST_OBJECT_UNLOCK (vscale);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_video_scale_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstVideoScale *vscale = GST_VIDEO_SCALE (object);

  switch (prop_id) {
    case PROP_METHOD:
      GST_OBJECT_LOCK (vscale);
      g_value_set_enum (value, vscale->method);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_ADD_BORDERS:
      GST_OBJECT_LOCK (vscale);
      g_value_set_boolean (value, vscale->add_borders);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_SHARPNESS:
      GST_OBJECT_LOCK (vscale);
      g_value_set_double (value, vscale->sharpness);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_SHARPEN:
      GST_OBJECT_LOCK (vscale);
      g_value_set_double (value, vscale->sharpen);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_DITHER:
      GST_OBJECT_LOCK (vscale);
      g_value_set_boolean (value, vscale->dither);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_SUBMETHOD:
      GST_OBJECT_LOCK (vscale);
      g_value_set_int (value, vscale->submethod);
      GST_OBJECT_UNLOCK (vscale);
      break;
    case PROP_ENVELOPE:
      GST_OBJECT_LOCK (vscale);
      g_value_set_double (value, vscale->envelope);
      GST_OBJECT_UNLOCK (vscale);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstCaps *
get_formats_filter (GstVideoScaleMethod method)
{
  switch (method) {
    case GST_VIDEO_SCALE_NEAREST:
    case GST_VIDEO_SCALE_BILINEAR:
      return NULL;
    case GST_VIDEO_SCALE_4TAP:
    {
      static GstStaticCaps fourtap_filter =
          GST_STATIC_CAPS ("video/x-raw(ANY),"
          "format = (string) { RGBx, xRGB, BGRx, xBGR, RGBA, "
          "ARGB, BGRA, ABGR, AYUV, ARGB64, AYUV64, "
          "RGB, BGR, v308, YUY2, YVYU, UYVY, "
          "GRAY8, GRAY16_LE, GRAY16_BE, I420, YV12, "
          "Y444, Y42B, Y41B, RGB16, RGB15 }");
      return gst_static_caps_get (&fourtap_filter);
    }
    case GST_VIDEO_SCALE_LANCZOS:
    {
      static GstStaticCaps lanczos_filter =
          GST_STATIC_CAPS ("video/x-raw(ANY),"
          "format = (string) { RGBx, xRGB, BGRx, xBGR, RGBA, "
          "ARGB, BGRA, ABGR, AYUV, ARGB64, AYUV64, "
          "I420, YV12, Y444, Y42B, Y41B }");
      return gst_static_caps_get (&lanczos_filter);
    }
    default:
      g_assert_not_reached ();
      break;
  }
  return NULL;
}

static GstCaps *
gst_video_scale_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter)
{
  GstVideoScale *videoscale = GST_VIDEO_SCALE (trans);
  GstVideoScaleMethod method;
  GstCaps *ret, *mfilter;
  GstStructure *structure;
  GstCapsFeatures *features;
  gint i, n;

  GST_DEBUG_OBJECT (trans,
      "Transforming caps %" GST_PTR_FORMAT " in direction %s", caps,
      (direction == GST_PAD_SINK) ? "sink" : "src");

  GST_OBJECT_LOCK (videoscale);
  method = videoscale->method;
  GST_OBJECT_UNLOCK (videoscale);

  /* filter the supported formats */
  /* FIXME: Ideally we would still allow passthrough for the color formats
   * that are unsupported by the selected method */
  if ((mfilter = get_formats_filter (method))) {
    caps = gst_caps_intersect_full (caps, mfilter, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (mfilter);
  } else {
    gst_caps_ref (caps);
  }

  ret = gst_caps_new_empty ();
  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    structure = gst_caps_get_structure (caps, i);
    features = gst_caps_get_features (caps, i);

    /* If this is already expressed by the existing caps
     * skip this structure */
    if (i > 0 && gst_caps_is_subset_structure_full (ret, structure, features))
      continue;

    /* make copy */
    structure = gst_structure_copy (structure);

    /* If the features are non-sysmem we can only do passthrough */
    if (!gst_caps_features_is_any (features)
        && gst_caps_features_is_equal (features,
            GST_CAPS_FEATURES_MEMORY_SYSTEM_MEMORY)) {
      gst_structure_set (structure, "width", GST_TYPE_INT_RANGE, 1, G_MAXINT,
          "height", GST_TYPE_INT_RANGE, 1, G_MAXINT, NULL);

      /* if pixel aspect ratio, make a range of it */
      if (gst_structure_has_field (structure, "pixel-aspect-ratio")) {
        gst_structure_set (structure, "pixel-aspect-ratio",
            GST_TYPE_FRACTION_RANGE, 1, G_MAXINT, G_MAXINT, 1, NULL);
      }
    }

    gst_caps_append_structure_full (ret, structure,
        gst_caps_features_copy (features));
  }

  if (filter) {
    GstCaps *intersection;

    intersection =
        gst_caps_intersect_full (filter, ret, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (ret);
    ret = intersection;
  }

  gst_caps_unref (caps);
  GST_DEBUG_OBJECT (trans, "returning caps: %" GST_PTR_FORMAT, ret);

  return ret;
}

static gboolean
gst_video_scale_set_info (GstVideoFilter * filter, GstCaps * in,
    GstVideoInfo * in_info, GstCaps * out, GstVideoInfo * out_info)
{
  GstVideoScale *videoscale = GST_VIDEO_SCALE (filter);
  gint from_dar_n, from_dar_d, to_dar_n, to_dar_d;

  if (!gst_util_fraction_multiply (in_info->width,
          in_info->height, in_info->par_n, in_info->par_d, &from_dar_n,
          &from_dar_d)) {
    from_dar_n = from_dar_d = -1;
  }

  if (!gst_util_fraction_multiply (out_info->width,
          out_info->height, out_info->par_n, out_info->par_d, &to_dar_n,
          &to_dar_d)) {
    to_dar_n = to_dar_d = -1;
  }

  videoscale->borders_w = videoscale->borders_h = 0;
  if (to_dar_n != from_dar_n || to_dar_d != from_dar_d) {
    if (videoscale->add_borders) {
      gint n, d, to_h, to_w;

      if (from_dar_n != -1 && from_dar_d != -1
          && gst_util_fraction_multiply (from_dar_n, from_dar_d,
              out_info->par_d, out_info->par_n, &n, &d)) {
        to_h = gst_util_uint64_scale_int (out_info->width, d, n);
        if (to_h <= out_info->height) {
          videoscale->borders_h = out_info->height - to_h;
          videoscale->borders_w = 0;
        } else {
          to_w = gst_util_uint64_scale_int (out_info->height, n, d);
          g_assert (to_w <= out_info->width);
          videoscale->borders_h = 0;
          videoscale->borders_w = out_info->width - to_w;
        }
      } else {
        GST_WARNING_OBJECT (videoscale, "Can't calculate borders");
      }
    } else {
      GST_WARNING_OBJECT (videoscale, "Can't keep DAR!");
    }
  }

  if (videoscale->tmp_buf)
    g_free (videoscale->tmp_buf);
  videoscale->tmp_buf = g_malloc (out_info->width * sizeof (guint64) * 4);

  if (in_info->width == out_info->width && in_info->height == out_info->height
      && videoscale->borders_w == 0 && videoscale->borders_h == 0) {
    gst_base_transform_set_passthrough (GST_BASE_TRANSFORM (filter), TRUE);
  } else {
    GST_CAT_DEBUG_OBJECT (GST_CAT_PERFORMANCE, filter, "setup videoscaling");
    gst_base_transform_set_passthrough (GST_BASE_TRANSFORM (filter), FALSE);
  }

  GST_DEBUG_OBJECT (videoscale, "from=%dx%d (par=%d/%d dar=%d/%d), size %"
      G_GSIZE_FORMAT " -> to=%dx%d (par=%d/%d dar=%d/%d borders=%d:%d), "
      "size %" G_GSIZE_FORMAT,
      in_info->width, in_info->height, in_info->par_n, in_info->par_d,
      from_dar_n, from_dar_d, in_info->size, out_info->width,
      out_info->height, out_info->par_n, out_info->par_d, to_dar_n, to_dar_d,
      videoscale->borders_w, videoscale->borders_h, out_info->size);

  return TRUE;
}

static GstCaps *
gst_video_scale_fixate_caps (GstBaseTransform * base, GstPadDirection direction,
    GstCaps * caps, GstCaps * othercaps)
{
  GstStructure *ins, *outs;
  const GValue *from_par, *to_par;
  GValue fpar = { 0, }, tpar = {
  0,};

  othercaps = gst_caps_truncate (othercaps);
  othercaps = gst_caps_make_writable (othercaps);

  GST_DEBUG_OBJECT (base, "trying to fixate othercaps %" GST_PTR_FORMAT
      " based on caps %" GST_PTR_FORMAT, othercaps, caps);

  ins = gst_caps_get_structure (caps, 0);
  outs = gst_caps_get_structure (othercaps, 0);

  from_par = gst_structure_get_value (ins, "pixel-aspect-ratio");
  to_par = gst_structure_get_value (outs, "pixel-aspect-ratio");

  /* If we're fixating from the sinkpad we always set the PAR and
   * assume that missing PAR on the sinkpad means 1/1 and
   * missing PAR on the srcpad means undefined
   */
  if (direction == GST_PAD_SINK) {
    if (!from_par) {
      g_value_init (&fpar, GST_TYPE_FRACTION);
      gst_value_set_fraction (&fpar, 1, 1);
      from_par = &fpar;
    }
    if (!to_par) {
      g_value_init (&tpar, GST_TYPE_FRACTION_RANGE);
      gst_value_set_fraction_range_full (&tpar, 1, G_MAXINT, G_MAXINT, 1);
      to_par = &tpar;
    }
  } else {
    if (!to_par) {
      g_value_init (&tpar, GST_TYPE_FRACTION);
      gst_value_set_fraction (&tpar, 1, 1);
      to_par = &tpar;

      gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION, 1, 1,
          NULL);
    }
    if (!from_par) {
      g_value_init (&fpar, GST_TYPE_FRACTION);
      gst_value_set_fraction (&fpar, 1, 1);
      from_par = &fpar;
    }
  }

  /* we have both PAR but they might not be fixated */
  {
    gint from_w, from_h, from_par_n, from_par_d, to_par_n, to_par_d;
    gint w = 0, h = 0;
    gint from_dar_n, from_dar_d;
    gint num, den;

    /* from_par should be fixed */
    g_return_val_if_fail (gst_value_is_fixed (from_par), othercaps);

    from_par_n = gst_value_get_fraction_numerator (from_par);
    from_par_d = gst_value_get_fraction_denominator (from_par);

    gst_structure_get_int (ins, "width", &from_w);
    gst_structure_get_int (ins, "height", &from_h);

    gst_structure_get_int (outs, "width", &w);
    gst_structure_get_int (outs, "height", &h);

    /* if both width and height are already fixed, we can't do anything
     * about it anymore */
    if (w && h) {
      guint n, d;

      GST_DEBUG_OBJECT (base, "dimensions already set to %dx%d, not fixating",
          w, h);
      if (!gst_value_is_fixed (to_par)) {
        if (gst_video_calculate_display_ratio (&n, &d, from_w, from_h,
                from_par_n, from_par_d, w, h)) {
          GST_DEBUG_OBJECT (base, "fixating to_par to %dx%d", n, d);
          if (gst_structure_has_field (outs, "pixel-aspect-ratio"))
            gst_structure_fixate_field_nearest_fraction (outs,
                "pixel-aspect-ratio", n, d);
          else if (n != d)
            gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
                n, d, NULL);
        }
      }
      goto done;
    }

    /* Calculate input DAR */
    if (!gst_util_fraction_multiply (from_w, from_h, from_par_n, from_par_d,
            &from_dar_n, &from_dar_d)) {
      GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
          ("Error calculating the output scaled size - integer overflow"));
      goto done;
    }

    GST_DEBUG_OBJECT (base, "Input DAR is %d/%d", from_dar_n, from_dar_d);

    /* If either width or height are fixed there's not much we
     * can do either except choosing a height or width and PAR
     * that matches the DAR as good as possible
     */
    if (h) {
      GstStructure *tmp;
      gint set_w, set_par_n, set_par_d;

      GST_DEBUG_OBJECT (base, "height is fixed (%d)", h);

      /* If the PAR is fixed too, there's not much to do
       * except choosing the width that is nearest to the
       * width with the same DAR */
      if (gst_value_is_fixed (to_par)) {
        to_par_n = gst_value_get_fraction_numerator (to_par);
        to_par_d = gst_value_get_fraction_denominator (to_par);

        GST_DEBUG_OBJECT (base, "PAR is fixed %d/%d", to_par_n, to_par_d);

        if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, to_par_d,
                to_par_n, &num, &den)) {
          GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
              ("Error calculating the output scaled size - integer overflow"));
          goto done;
        }

        w = (guint) gst_util_uint64_scale_int (h, num, den);
        gst_structure_fixate_field_nearest_int (outs, "width", w);

        goto done;
      }

      /* The PAR is not fixed and it's quite likely that we can set
       * an arbitrary PAR. */

      /* Check if we can keep the input width */
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "width", from_w);
      gst_structure_get_int (tmp, "width", &set_w);

      /* Might have failed but try to keep the DAR nonetheless by
       * adjusting the PAR */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, h, set_w,
              &to_par_n, &to_par_d)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        gst_structure_free (tmp);
        goto done;
      }

      if (!gst_structure_has_field (tmp, "pixel-aspect-ratio"))
        gst_structure_set_value (tmp, "pixel-aspect-ratio", to_par);
      gst_structure_fixate_field_nearest_fraction (tmp, "pixel-aspect-ratio",
          to_par_n, to_par_d);
      gst_structure_get_fraction (tmp, "pixel-aspect-ratio", &set_par_n,
          &set_par_d);
      gst_structure_free (tmp);

      /* Check if the adjusted PAR is accepted */
      if (set_par_n == to_par_n && set_par_d == to_par_d) {
        if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
            set_par_n != set_par_d)
          gst_structure_set (outs, "width", G_TYPE_INT, set_w,
              "pixel-aspect-ratio", GST_TYPE_FRACTION, set_par_n, set_par_d,
              NULL);
        goto done;
      }

      /* Otherwise scale the width to the new PAR and check if the
       * adjusted with is accepted. If all that fails we can't keep
       * the DAR */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, set_par_d,
              set_par_n, &num, &den)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        goto done;
      }

      w = (guint) gst_util_uint64_scale_int (h, num, den);
      gst_structure_fixate_field_nearest_int (outs, "width", w);
      if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
          set_par_n != set_par_d)
        gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
            set_par_n, set_par_d, NULL);

      goto done;
    } else if (w) {
      GstStructure *tmp;
      gint set_h, set_par_n, set_par_d;

      GST_DEBUG_OBJECT (base, "width is fixed (%d)", w);

      /* If the PAR is fixed too, there's not much to do
       * except choosing the height that is nearest to the
       * height with the same DAR */
      if (gst_value_is_fixed (to_par)) {
        to_par_n = gst_value_get_fraction_numerator (to_par);
        to_par_d = gst_value_get_fraction_denominator (to_par);

        GST_DEBUG_OBJECT (base, "PAR is fixed %d/%d", to_par_n, to_par_d);

        if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, to_par_d,
                to_par_n, &num, &den)) {
          GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
              ("Error calculating the output scaled size - integer overflow"));
          goto done;
        }

        h = (guint) gst_util_uint64_scale_int (w, den, num);
        gst_structure_fixate_field_nearest_int (outs, "height", h);

        goto done;
      }

      /* The PAR is not fixed and it's quite likely that we can set
       * an arbitrary PAR. */

      /* Check if we can keep the input height */
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "height", from_h);
      gst_structure_get_int (tmp, "height", &set_h);

      /* Might have failed but try to keep the DAR nonetheless by
       * adjusting the PAR */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, set_h, w,
              &to_par_n, &to_par_d)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        gst_structure_free (tmp);
        goto done;
      }
      if (!gst_structure_has_field (tmp, "pixel-aspect-ratio"))
        gst_structure_set_value (tmp, "pixel-aspect-ratio", to_par);
      gst_structure_fixate_field_nearest_fraction (tmp, "pixel-aspect-ratio",
          to_par_n, to_par_d);
      gst_structure_get_fraction (tmp, "pixel-aspect-ratio", &set_par_n,
          &set_par_d);
      gst_structure_free (tmp);

      /* Check if the adjusted PAR is accepted */
      if (set_par_n == to_par_n && set_par_d == to_par_d) {
        if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
            set_par_n != set_par_d)
          gst_structure_set (outs, "height", G_TYPE_INT, set_h,
              "pixel-aspect-ratio", GST_TYPE_FRACTION, set_par_n, set_par_d,
              NULL);
        goto done;
      }

      /* Otherwise scale the height to the new PAR and check if the
       * adjusted with is accepted. If all that fails we can't keep
       * the DAR */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, set_par_d,
              set_par_n, &num, &den)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        goto done;
      }

      h = (guint) gst_util_uint64_scale_int (w, den, num);
      gst_structure_fixate_field_nearest_int (outs, "height", h);
      if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
          set_par_n != set_par_d)
        gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
            set_par_n, set_par_d, NULL);

      goto done;
    } else if (gst_value_is_fixed (to_par)) {
      GstStructure *tmp;
      gint set_h, set_w, f_h, f_w;

      to_par_n = gst_value_get_fraction_numerator (to_par);
      to_par_d = gst_value_get_fraction_denominator (to_par);

      /* Calculate scale factor for the PAR change */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, to_par_n,
              to_par_d, &num, &den)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        goto done;
      }

      /* Try to keep the input height (because of interlacing) */
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "height", from_h);
      gst_structure_get_int (tmp, "height", &set_h);

      /* This might have failed but try to scale the width
       * to keep the DAR nonetheless */
      w = (guint) gst_util_uint64_scale_int (set_h, num, den);
      gst_structure_fixate_field_nearest_int (tmp, "width", w);
      gst_structure_get_int (tmp, "width", &set_w);
      gst_structure_free (tmp);

      /* We kept the DAR and the height is nearest to the original height */
      if (set_w == w) {
        gst_structure_set (outs, "width", G_TYPE_INT, set_w, "height",
            G_TYPE_INT, set_h, NULL);
        goto done;
      }

      f_h = set_h;
      f_w = set_w;

      /* If the former failed, try to keep the input width at least */
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "width", from_w);
      gst_structure_get_int (tmp, "width", &set_w);

      /* This might have failed but try to scale the width
       * to keep the DAR nonetheless */
      h = (guint) gst_util_uint64_scale_int (set_w, den, num);
      gst_structure_fixate_field_nearest_int (tmp, "height", h);
      gst_structure_get_int (tmp, "height", &set_h);
      gst_structure_free (tmp);

      /* We kept the DAR and the width is nearest to the original width */
      if (set_h == h) {
        gst_structure_set (outs, "width", G_TYPE_INT, set_w, "height",
            G_TYPE_INT, set_h, NULL);
        goto done;
      }

      /* If all this failed, keep the height that was nearest to the orignal
       * height and the nearest possible width. This changes the DAR but
       * there's not much else to do here.
       */
      gst_structure_set (outs, "width", G_TYPE_INT, f_w, "height", G_TYPE_INT,
          f_h, NULL);
      goto done;
    } else {
      GstStructure *tmp;
      gint set_h, set_w, set_par_n, set_par_d, tmp2;

      /* width, height and PAR are not fixed but passthrough is not possible */

      /* First try to keep the height and width as good as possible
       * and scale PAR */
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "height", from_h);
      gst_structure_get_int (tmp, "height", &set_h);
      gst_structure_fixate_field_nearest_int (tmp, "width", from_w);
      gst_structure_get_int (tmp, "width", &set_w);

      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, set_h, set_w,
              &to_par_n, &to_par_d)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        goto done;
      }

      if (!gst_structure_has_field (tmp, "pixel-aspect-ratio"))
        gst_structure_set_value (tmp, "pixel-aspect-ratio", to_par);
      gst_structure_fixate_field_nearest_fraction (tmp, "pixel-aspect-ratio",
          to_par_n, to_par_d);
      gst_structure_get_fraction (tmp, "pixel-aspect-ratio", &set_par_n,
          &set_par_d);
      gst_structure_free (tmp);

      if (set_par_n == to_par_n && set_par_d == to_par_d) {
        gst_structure_set (outs, "width", G_TYPE_INT, set_w, "height",
            G_TYPE_INT, set_h, NULL);

        if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
            set_par_n != set_par_d)
          gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
              set_par_n, set_par_d, NULL);
        goto done;
      }

      /* Otherwise try to scale width to keep the DAR with the set
       * PAR and height */
      if (!gst_util_fraction_multiply (from_dar_n, from_dar_d, set_par_d,
              set_par_n, &num, &den)) {
        GST_ELEMENT_ERROR (base, CORE, NEGOTIATION, (NULL),
            ("Error calculating the output scaled size - integer overflow"));
        goto done;
      }

      w = (guint) gst_util_uint64_scale_int (set_h, num, den);
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "width", w);
      gst_structure_get_int (tmp, "width", &tmp2);
      gst_structure_free (tmp);

      if (tmp2 == w) {
        gst_structure_set (outs, "width", G_TYPE_INT, tmp2, "height",
            G_TYPE_INT, set_h, NULL);
        if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
            set_par_n != set_par_d)
          gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
              set_par_n, set_par_d, NULL);
        goto done;
      }

      /* ... or try the same with the height */
      h = (guint) gst_util_uint64_scale_int (set_w, den, num);
      tmp = gst_structure_copy (outs);
      gst_structure_fixate_field_nearest_int (tmp, "height", h);
      gst_structure_get_int (tmp, "height", &tmp2);
      gst_structure_free (tmp);

      if (tmp2 == h) {
        gst_structure_set (outs, "width", G_TYPE_INT, set_w, "height",
            G_TYPE_INT, tmp2, NULL);
        if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
            set_par_n != set_par_d)
          gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
              set_par_n, set_par_d, NULL);
        goto done;
      }

      /* If all fails we can't keep the DAR and take the nearest values
       * for everything from the first try */
      gst_structure_set (outs, "width", G_TYPE_INT, set_w, "height",
          G_TYPE_INT, set_h, NULL);
      if (gst_structure_has_field (outs, "pixel-aspect-ratio") ||
          set_par_n != set_par_d)
        gst_structure_set (outs, "pixel-aspect-ratio", GST_TYPE_FRACTION,
            set_par_n, set_par_d, NULL);
    }
  }

done:
  GST_DEBUG_OBJECT (base, "fixated othercaps to %" GST_PTR_FORMAT, othercaps);

  if (from_par == &fpar)
    g_value_unset (&fpar);
  if (to_par == &tpar)
    g_value_unset (&tpar);

  return othercaps;
}

static void
gst_video_scale_setup_vs_image (VSImage * image, GstVideoFrame * frame,
    gint component, gint b_w, gint b_h, gboolean interlaced, gint field)
{
  GstVideoFormat format;
  gint width, height;

  format = GST_VIDEO_FRAME_FORMAT (frame);
  width = GST_VIDEO_FRAME_WIDTH (frame);
  height = GST_VIDEO_FRAME_HEIGHT (frame);

  image->real_width = GST_VIDEO_FRAME_COMP_WIDTH (frame, component);
  image->real_height = GST_VIDEO_FRAME_COMP_HEIGHT (frame, component);
  image->width = GST_VIDEO_FORMAT_INFO_SCALE_WIDTH (frame->info.finfo,
      component, MAX (1, width - b_w));
  image->height = GST_VIDEO_FORMAT_INFO_SCALE_HEIGHT (frame->info.finfo,
      component, MAX (1, height - b_h));

  if (interlaced) {
    image->real_height /= 2;
    image->height /= 2;
  }

  image->border_top = (image->real_height - image->height) / 2;
  image->border_bottom = image->real_height - image->height - image->border_top;

  if (format == GST_VIDEO_FORMAT_YUY2 || format == GST_VIDEO_FORMAT_YVYU
      || format == GST_VIDEO_FORMAT_UYVY) {
    g_assert (component == 0);

    image->border_left = (image->real_width - image->width) / 2;

    if (image->border_left % 2 == 1)
      image->border_left--;
    image->border_right = image->real_width - image->width - image->border_left;
  } else {
    image->border_left = (image->real_width - image->width) / 2;
    image->border_right = image->real_width - image->width - image->border_left;
  }

  image->real_pixels = GST_VIDEO_FRAME_PLANE_DATA (frame, component);
  image->stride = GST_VIDEO_FRAME_PLANE_STRIDE (frame, component);

  if (interlaced) {
    if (field == 1)
      image->real_pixels += image->stride;
    image->stride *= 2;
  }

  image->pixels =
      image->real_pixels + image->border_top * image->stride +
      image->border_left * GST_VIDEO_FRAME_COMP_PSTRIDE (frame, component);

}

static const guint8 *
_get_black_for_format (GstVideoFormat format)
{
  static const guint8 black[][4] = {
    {255, 0, 0, 0},             /*  0 = ARGB, ABGR, xRGB, xBGR */
    {0, 0, 0, 255},             /*  1 = RGBA, BGRA, RGBx, BGRx */
    {255, 16, 128, 128},        /*  2 = AYUV */
    {0, 0, 0, 0},               /*  3 = RGB and BGR */
    {16, 128, 128, 0},          /*  4 = v301 */
    {16, 128, 16, 128},         /*  5 = YUY2, YUYV */
    {128, 16, 128, 16},         /*  6 = UYVY */
    {16, 0, 0, 0},              /*  7 = Y */
    {0, 0, 0, 0}                /*  8 = RGB565, RGB666 */
  };

  switch (format) {
    case GST_VIDEO_FORMAT_ARGB:
    case GST_VIDEO_FORMAT_ABGR:
    case GST_VIDEO_FORMAT_xRGB:
    case GST_VIDEO_FORMAT_xBGR:
    case GST_VIDEO_FORMAT_ARGB64:
      return black[0];
    case GST_VIDEO_FORMAT_RGBA:
    case GST_VIDEO_FORMAT_BGRA:
    case GST_VIDEO_FORMAT_RGBx:
    case GST_VIDEO_FORMAT_BGRx:
      return black[1];
    case GST_VIDEO_FORMAT_AYUV:
    case GST_VIDEO_FORMAT_AYUV64:
      return black[2];
    case GST_VIDEO_FORMAT_RGB:
    case GST_VIDEO_FORMAT_BGR:
      return black[3];
    case GST_VIDEO_FORMAT_v308:
      return black[4];
    case GST_VIDEO_FORMAT_YUY2:
    case GST_VIDEO_FORMAT_YVYU:
      return black[5];
    case GST_VIDEO_FORMAT_UYVY:
      return black[6];
    case GST_VIDEO_FORMAT_GRAY8:
      return black[7];
    case GST_VIDEO_FORMAT_GRAY16_LE:
    case GST_VIDEO_FORMAT_GRAY16_BE:
      return NULL;              /* Handled by the caller */
    case GST_VIDEO_FORMAT_I420:
    case GST_VIDEO_FORMAT_YV12:
    case GST_VIDEO_FORMAT_Y444:
    case GST_VIDEO_FORMAT_Y42B:
    case GST_VIDEO_FORMAT_Y41B:
    case GST_VIDEO_FORMAT_NV12:
      return black[4];          /* Y, U, V, 0 */
    case GST_VIDEO_FORMAT_RGB16:
    case GST_VIDEO_FORMAT_RGB15:
      return black[8];
    default:
      return NULL;
  }
}

static GstFlowReturn
gst_video_scale_transform_frame (GstVideoFilter * filter,
    GstVideoFrame * in_frame, GstVideoFrame * out_frame)
{
  GstVideoScale *videoscale = GST_VIDEO_SCALE (filter);
  GstFlowReturn ret = GST_FLOW_OK;
  VSImage dest[4] = { {NULL,}, };
  VSImage src[4] = { {NULL,}, };
  gint i;
  gboolean interlaced;

  interlaced = GST_VIDEO_FRAME_IS_INTERLACED (in_frame);

  for (i = 0; i < GST_VIDEO_FRAME_N_PLANES (in_frame); i++) {
    gst_video_scale_setup_vs_image (&src[i], in_frame, i, 0, 0, interlaced, 0);
    gst_video_scale_setup_vs_image (&dest[i], out_frame, i,
        videoscale->borders_w, videoscale->borders_h, interlaced, 0);
  }
  ret = do_scale (filter, dest, src);

  if (interlaced) {
    for (i = 0; i < GST_VIDEO_FRAME_N_PLANES (in_frame); i++) {
      gst_video_scale_setup_vs_image (&src[i], in_frame, i, 0, 0, interlaced,
          1);
      gst_video_scale_setup_vs_image (&dest[i], out_frame, i,
          videoscale->borders_w, videoscale->borders_h, interlaced, 1);
    }
    ret = do_scale (filter, dest, src);
  }
  return ret;
}

static GstFlowReturn
do_scale (GstVideoFilter * filter, VSImage dest[4], VSImage src[4])
{
  GstVideoScale *videoscale = GST_VIDEO_SCALE (filter);
  GstFlowReturn ret = GST_FLOW_OK;
  gint method;
  const guint8 *black;
  GstVideoFormat format;
  gboolean add_borders;

  GST_OBJECT_LOCK (videoscale);
  method = videoscale->method;
  add_borders = videoscale->add_borders;
  GST_OBJECT_UNLOCK (videoscale);

  format = GST_VIDEO_INFO_FORMAT (&filter->in_info);
  black = _get_black_for_format (format);

  if (filter->in_info.width == 1) {
    method = GST_VIDEO_SCALE_NEAREST;
  }
  if (method == GST_VIDEO_SCALE_4TAP &&
      (filter->in_info.width < 4 || filter->in_info.height < 4)) {
    method = GST_VIDEO_SCALE_BILINEAR;
  }

  GST_CAT_DEBUG_OBJECT (GST_CAT_PERFORMANCE, filter,
      "doing videoscale format %s", GST_VIDEO_INFO_NAME (&filter->in_info));

  switch (format) {
    case GST_VIDEO_FORMAT_RGBx:
    case GST_VIDEO_FORMAT_xRGB:
    case GST_VIDEO_FORMAT_BGRx:
    case GST_VIDEO_FORMAT_xBGR:
    case GST_VIDEO_FORMAT_RGBA:
    case GST_VIDEO_FORMAT_ARGB:
    case GST_VIDEO_FORMAT_BGRA:
    case GST_VIDEO_FORMAT_ABGR:
    case GST_VIDEO_FORMAT_AYUV:
      if (add_borders)
        vs_fill_borders_RGBA (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_RGBA (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_RGBA (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_RGBA (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_LANCZOS:
          vs_image_scale_lanczos_AYUV (&dest[0], &src[0], videoscale->tmp_buf,
              videoscale->sharpness, videoscale->dither, videoscale->submethod,
              videoscale->envelope, videoscale->sharpen);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_ARGB64:
    case GST_VIDEO_FORMAT_AYUV64:
      if (add_borders)
        vs_fill_borders_AYUV64 (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_AYUV64 (&dest[0], &src[0],
              videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_AYUV64 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_AYUV64 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_LANCZOS:
          vs_image_scale_lanczos_AYUV64 (&dest[0], &src[0], videoscale->tmp_buf,
              videoscale->sharpness, videoscale->dither, videoscale->submethod,
              videoscale->envelope, videoscale->sharpen);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_RGB:
    case GST_VIDEO_FORMAT_BGR:
    case GST_VIDEO_FORMAT_v308:
      if (add_borders)
        vs_fill_borders_RGB (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_RGB (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_RGB (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_RGB (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_YUY2:
    case GST_VIDEO_FORMAT_YVYU:
      if (add_borders)
        vs_fill_borders_YUYV (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_YUYV (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_YUYV (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_YUYV (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_UYVY:
      if (add_borders)
        vs_fill_borders_UYVY (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_UYVY (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_UYVY (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_UYVY (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_GRAY8:
      if (add_borders)
        vs_fill_borders_Y (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_Y (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_Y (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_Y (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_GRAY16_LE:
    case GST_VIDEO_FORMAT_GRAY16_BE:
      if (add_borders)
        vs_fill_borders_Y16 (&dest[0], 0);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_Y16 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_Y16 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_Y16 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_I420:
    case GST_VIDEO_FORMAT_YV12:
    case GST_VIDEO_FORMAT_Y444:
    case GST_VIDEO_FORMAT_Y42B:
    case GST_VIDEO_FORMAT_Y41B:
      if (add_borders) {
        vs_fill_borders_Y (&dest[0], black);
        vs_fill_borders_Y (&dest[1], black + 1);
        vs_fill_borders_Y (&dest[2], black + 2);
      }
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_Y (&dest[0], &src[0], videoscale->tmp_buf);
          vs_image_scale_nearest_Y (&dest[1], &src[1], videoscale->tmp_buf);
          vs_image_scale_nearest_Y (&dest[2], &src[2], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_Y (&dest[0], &src[0], videoscale->tmp_buf);
          vs_image_scale_linear_Y (&dest[1], &src[1], videoscale->tmp_buf);
          vs_image_scale_linear_Y (&dest[2], &src[2], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_Y (&dest[0], &src[0], videoscale->tmp_buf);
          vs_image_scale_4tap_Y (&dest[1], &src[1], videoscale->tmp_buf);
          vs_image_scale_4tap_Y (&dest[2], &src[2], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_LANCZOS:
          vs_image_scale_lanczos_Y (&dest[0], &src[0], videoscale->tmp_buf,
              videoscale->sharpness, videoscale->dither, videoscale->submethod,
              videoscale->envelope, videoscale->sharpen);
          vs_image_scale_lanczos_Y (&dest[1], &src[1], videoscale->tmp_buf,
              videoscale->sharpness, videoscale->dither, videoscale->submethod,
              videoscale->envelope, videoscale->sharpen);
          vs_image_scale_lanczos_Y (&dest[2], &src[2], videoscale->tmp_buf,
              videoscale->sharpness, videoscale->dither, videoscale->submethod,
              videoscale->envelope, videoscale->sharpen);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_NV12:
      if (add_borders) {
        vs_fill_borders_Y (&dest[0], black);
        vs_fill_borders_Y16 (&dest[1], (black[1] << 8) | black[2]);
      }
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_Y (&dest[0], &src[0], videoscale->tmp_buf);
          vs_image_scale_nearest_NV12 (&dest[1], &src[1], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_Y (&dest[0], &src[0], videoscale->tmp_buf);
          vs_image_scale_linear_NV12 (&dest[1], &src[1], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_RGB16:
      if (add_borders)
        vs_fill_borders_RGB565 (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_RGB565 (&dest[0], &src[0],
              videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_RGB565 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_RGB565 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    case GST_VIDEO_FORMAT_RGB15:
      if (add_borders)
        vs_fill_borders_RGB555 (&dest[0], black);
      switch (method) {
        case GST_VIDEO_SCALE_NEAREST:
          vs_image_scale_nearest_RGB555 (&dest[0], &src[0],
              videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_BILINEAR:
          vs_image_scale_linear_RGB555 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        case GST_VIDEO_SCALE_4TAP:
          vs_image_scale_4tap_RGB555 (&dest[0], &src[0], videoscale->tmp_buf);
          break;
        default:
          goto unknown_mode;
      }
      break;
    default:
      goto unsupported;
  }

  return ret;

  /* ERRORS */
unsupported:
  {
    GST_ELEMENT_ERROR (videoscale, STREAM, NOT_IMPLEMENTED, (NULL),
        ("Unsupported format %d for scaling method %d", format, method));
    return GST_FLOW_ERROR;
  }
unknown_mode:
  {
    GST_ELEMENT_ERROR (videoscale, STREAM, NOT_IMPLEMENTED, (NULL),
        ("Unknown scaling method %d", videoscale->method));
    return GST_FLOW_ERROR;
  }
}

static gboolean
gst_video_scale_src_event (GstBaseTransform * trans, GstEvent * event)
{
  GstVideoScale *videoscale = GST_VIDEO_SCALE_CAST (trans);
  GstVideoFilter *filter = GST_VIDEO_FILTER_CAST (trans);
  gboolean ret;
  gdouble a;
  GstStructure *structure;

  GST_DEBUG_OBJECT (videoscale, "handling %s event",
      GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_NAVIGATION:
      if (filter->in_info.width != filter->out_info.width ||
          filter->in_info.height != filter->out_info.height) {
        event =
            GST_EVENT (gst_mini_object_make_writable (GST_MINI_OBJECT (event)));

        structure = (GstStructure *) gst_event_get_structure (event);
        if (gst_structure_get_double (structure, "pointer_x", &a)) {
          gst_structure_set (structure, "pointer_x", G_TYPE_DOUBLE,
              a * filter->in_info.width / filter->out_info.width, NULL);
        }
        if (gst_structure_get_double (structure, "pointer_y", &a)) {
          gst_structure_set (structure, "pointer_y", G_TYPE_DOUBLE,
              a * filter->in_info.height / filter->out_info.height, NULL);
        }
      }
      break;
    default:
      break;
  }

  ret = GST_BASE_TRANSFORM_CLASS (parent_class)->src_event (trans, event);

  return ret;
}

static gboolean
plugin_init (GstPlugin * plugin)
{
  if (!gst_element_register (plugin, "videoscale", GST_RANK_NONE,
          GST_TYPE_VIDEO_SCALE))
    return FALSE;

  GST_DEBUG_CATEGORY_INIT (video_scale_debug, "videoscale", 0,
      "videoscale element");
  GST_DEBUG_CATEGORY_GET (GST_CAT_PERFORMANCE, "GST_PERFORMANCE");

  vs_4tap_init ();

  return TRUE;
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    videoscale,
    "Resizes video", plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME,
    GST_PACKAGE_ORIGIN)
