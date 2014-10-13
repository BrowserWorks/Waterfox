/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *                    2005 Andy Wingo <wingo@fluendo.com>
 *                    2005 Thomas Vander Stichele <thomas at apestaart dot org>
 *                    2008 Wim Taymans <wim.taymans@gmail.com>
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
 * SECTION:gstbasetransform
 * @short_description: Base class for simple transform filters
 * @see_also: #GstBaseSrc, #GstBaseSink
 *
 * This base class is for filter elements that process data.
 *
 * It provides for:
 * <itemizedlist>
 *   <listitem><para>one sinkpad and one srcpad</para></listitem>
 *   <listitem><para>
 *      Possible formats on sink and source pad implemented
 *      with custom transform_caps function. By default uses
 *      same format on sink and source.
 *   </para></listitem>
 *   <listitem><para>Handles state changes</para></listitem>
 *   <listitem><para>Does flushing</para></listitem>
 *   <listitem><para>Push mode</para></listitem>
 *   <listitem><para>
 *       Pull mode if the sub-class transform can operate on arbitrary data
 *    </para></listitem>
 * </itemizedlist>
 *
 * <refsect2>
 * <title>Use Cases</title>
 * <para>
 * <orderedlist>
 * <listitem>
 *   <itemizedlist><title>Passthrough mode</title>
 *   <listitem><para>
 *     Element has no interest in modifying the buffer. It may want to inspect it,
 *     in which case the element should have a transform_ip function. If there
 *     is no transform_ip function in passthrough mode, the buffer is pushed
 *     intact.
 *   </para></listitem>
 *   <listitem><para>
 *     The #GstBaseTransformClass.passthrough_on_same_caps variable
 *     will automatically set/unset passthrough based on whether the
 *     element negotiates the same caps on both pads.
 *   </para></listitem>
 *   <listitem><para>
 *     #GstBaseTransformClass.passthrough_on_same_caps on an element that
 *     doesn't implement a transform_caps function is useful for elements that
 *     only inspect data (such as level)
 *   </para></listitem>
 *   </itemizedlist>
 *   <itemizedlist>
 *   <title>Example elements</title>
 *     <listitem>Level</listitem>
 *     <listitem>Videoscale, audioconvert, videoconvert, audioresample in
 *     certain modes.</listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist>
 *     <title>Modifications in-place - input buffer and output buffer are the
 *     same thing.</title>
 *   <listitem><para>
 *     The element must implement a transform_ip function.
 *   </para></listitem>
 *   <listitem><para>
 *     Output buffer size must <= input buffer size
 *   </para></listitem>
 *   <listitem><para>
 *     If the always_in_place flag is set, non-writable buffers will be copied
 *     and passed to the transform_ip function, otherwise a new buffer will be
 *     created and the transform function called.
 *   </para></listitem>
 *   <listitem><para>
 *     Incoming writable buffers will be passed to the transform_ip function
 *     immediately.  </para></listitem>
 *   <listitem><para>
 *     only implementing transform_ip and not transform implies always_in_place
 *     = %TRUE
 *   </para></listitem>
 *   </itemizedlist>
 *   <itemizedlist>
 *   <title>Example elements</title>
 *     <listitem>Volume</listitem>
 *     <listitem>Audioconvert in certain modes (signed/unsigned
 *     conversion)</listitem>
 *     <listitem>videoconvert in certain modes (endianness
 *     swapping)</listitem>
 *   </itemizedlist>
 *  </listitem>
 * <listitem>
 *   <itemizedlist>
 *   <title>Modifications only to the caps/metadata of a buffer</title>
 *   <listitem><para>
 *     The element does not require writable data, but non-writable buffers
 *     should be subbuffered so that the meta-information can be replaced.
 *   </para></listitem>
 *   <listitem><para>
 *     Elements wishing to operate in this mode should replace the
 *     prepare_output_buffer method to create subbuffers of the input buffer
 *     and set always_in_place to %TRUE
 *   </para></listitem>
 *   </itemizedlist>
 *   <itemizedlist>
 *   <title>Example elements</title>
 *     <listitem>Capsfilter when setting caps on outgoing buffers that have
 *     none.</listitem>
 *     <listitem>identity when it is going to re-timestamp buffers by
 *     datarate.</listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist><title>Normal mode</title>
 *   <listitem><para>
 *     always_in_place flag is not set, or there is no transform_ip function
 *   </para></listitem>
 *   <listitem><para>
 *     Element will receive an input buffer and output buffer to operate on.
 *   </para></listitem>
 *   <listitem><para>
 *     Output buffer is allocated by calling the prepare_output_buffer function.
 *   </para></listitem>
 *   </itemizedlist>
 *   <itemizedlist>
 *   <title>Example elements</title>
 *     <listitem>Videoscale, videoconvert, audioconvert when doing
 *     scaling/conversions</listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist><title>Special output buffer allocations</title>
 *   <listitem><para>
 *     Elements which need to do special allocation of their output buffers
 *     beyond allocating output buffers via the negotiated allocator or
 *     buffer pool should implement the prepare_output_buffer method.
 *   </para></listitem>
 *   </itemizedlist>
 *   <itemizedlist>
 *   <title>Example elements</title>
 *     <listitem>efence</listitem>
 *   </itemizedlist>
 * </listitem>
 * </orderedlist>
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Sub-class settable flags on GstBaseTransform</title>
 * <para>
 * <itemizedlist>
 * <listitem><para>
 *   <itemizedlist><title>passthrough</title>
 *     <listitem><para>
 *       Implies that in the current configuration, the sub-class is not
 *       interested in modifying the buffers.
 *     </para></listitem>
 *     <listitem><para>
 *       Elements which are always in passthrough mode whenever the same caps
 *       has been negotiated on both pads can set the class variable
 *       passthrough_on_same_caps to have this behaviour automatically.
 *     </para></listitem>
 *   </itemizedlist>
 * </para></listitem>
 * <listitem><para>
 *   <itemizedlist><title>always_in_place</title>
 *     <listitem><para>
 *       Determines whether a non-writable buffer will be copied before passing
 *       to the transform_ip function.
 *     </para></listitem>
 *     <listitem><para>
 *       Implied %TRUE if no transform function is implemented.
 *     </para></listitem>
 *     <listitem><para>
 *       Implied %FALSE if ONLY transform function is implemented.
 *     </para></listitem>
 *   </itemizedlist>
 * </para></listitem>
 * </itemizedlist>
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include "../../../gst/gst_private.h"
#include "../../../gst/gst-i18n-lib.h"
#include "../../../gst/glib-compat-private.h"
#include "gstbasetransform.h"

GST_DEBUG_CATEGORY_STATIC (gst_base_transform_debug);
#define GST_CAT_DEFAULT gst_base_transform_debug

/* BaseTransform signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

#define DEFAULT_PROP_QOS	FALSE

enum
{
  PROP_0,
  PROP_QOS
};

#define GST_BASE_TRANSFORM_GET_PRIVATE(obj)  \
    (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BASE_TRANSFORM, GstBaseTransformPrivate))

struct _GstBaseTransformPrivate
{
  /* Set by sub-class */
  gboolean passthrough;
  gboolean always_in_place;

  GstCaps *cache_caps1;
  gsize cache_caps1_size;
  GstCaps *cache_caps2;
  gsize cache_caps2_size;
  gboolean have_same_caps;

  gboolean negotiated;

  /* QoS *//* with LOCK */
  gboolean qos_enabled;
  gdouble proportion;
  GstClockTime earliest_time;
  /* previous buffer had a discont */
  gboolean discont;

  GstPadMode pad_mode;

  gboolean gap_aware;
  gboolean prefer_passthrough;

  /* QoS stats */
  guint64 processed;
  guint64 dropped;

  GstClockTime position_out;

  GstBufferPool *pool;
  gboolean pool_active;
  GstAllocator *allocator;
  GstAllocationParams params;
  GstQuery *query;
};


static GstElementClass *parent_class = NULL;

static void gst_base_transform_class_init (GstBaseTransformClass * klass);
static void gst_base_transform_init (GstBaseTransform * trans,
    GstBaseTransformClass * klass);

/* we can't use G_DEFINE_ABSTRACT_TYPE because we need the klass in the _init
 * method to get to the padtemplates */
GType
gst_base_transform_get_type (void)
{
  static volatile gsize base_transform_type = 0;

  if (g_once_init_enter (&base_transform_type)) {
    GType _type;
    static const GTypeInfo base_transform_info = {
      sizeof (GstBaseTransformClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_base_transform_class_init,
      NULL,
      NULL,
      sizeof (GstBaseTransform),
      0,
      (GInstanceInitFunc) gst_base_transform_init,
    };

    _type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstBaseTransform", &base_transform_info, G_TYPE_FLAG_ABSTRACT);
    g_once_init_leave (&base_transform_type, _type);
  }
  return base_transform_type;
}

static void gst_base_transform_finalize (GObject * object);
static void gst_base_transform_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_base_transform_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static gboolean gst_base_transform_src_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_base_transform_sink_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_base_transform_activate (GstBaseTransform * trans,
    gboolean active);
static gboolean gst_base_transform_get_unit_size (GstBaseTransform * trans,
    GstCaps * caps, gsize * size);

static gboolean gst_base_transform_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_base_transform_src_eventfunc (GstBaseTransform * trans,
    GstEvent * event);
static gboolean gst_base_transform_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_base_transform_sink_eventfunc (GstBaseTransform * trans,
    GstEvent * event);
static GstFlowReturn gst_base_transform_getrange (GstPad * pad,
    GstObject * parent, guint64 offset, guint length, GstBuffer ** buffer);
static GstFlowReturn gst_base_transform_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static GstCaps *gst_base_transform_default_transform_caps (GstBaseTransform *
    trans, GstPadDirection direction, GstCaps * caps, GstCaps * filter);
static GstCaps *gst_base_transform_default_fixate_caps (GstBaseTransform *
    trans, GstPadDirection direction, GstCaps * caps, GstCaps * othercaps);
static GstCaps *gst_base_transform_query_caps (GstBaseTransform * trans,
    GstPad * pad, GstCaps * filter);
static gboolean gst_base_transform_acceptcaps_default (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps);
static gboolean gst_base_transform_setcaps (GstBaseTransform * trans,
    GstPad * pad, GstCaps * caps);
static gboolean gst_base_transform_default_decide_allocation (GstBaseTransform
    * trans, GstQuery * query);
static gboolean gst_base_transform_default_propose_allocation (GstBaseTransform
    * trans, GstQuery * decide_query, GstQuery * query);
static gboolean gst_base_transform_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_base_transform_default_query (GstBaseTransform * trans,
    GstPadDirection direction, GstQuery * query);
static gboolean gst_base_transform_default_transform_size (GstBaseTransform *
    trans, GstPadDirection direction, GstCaps * caps, gsize size,
    GstCaps * othercaps, gsize * othersize);

static GstFlowReturn default_prepare_output_buffer (GstBaseTransform * trans,
    GstBuffer * inbuf, GstBuffer ** outbuf);
static gboolean default_copy_metadata (GstBaseTransform * trans,
    GstBuffer * inbuf, GstBuffer * outbuf);
static gboolean
gst_base_transform_default_transform_meta (GstBaseTransform * trans,
    GstBuffer * inbuf, GstMeta * meta, GstBuffer * outbuf);

/* static guint gst_base_transform_signals[LAST_SIGNAL] = { 0 }; */


static void
gst_base_transform_finalize (GObject * object)
{
  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_base_transform_class_init (GstBaseTransformClass * klass)
{
  GObjectClass *gobject_class;

  gobject_class = G_OBJECT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (gst_base_transform_debug, "basetransform", 0,
      "basetransform element");

  GST_DEBUG ("gst_base_transform_class_init");

  g_type_class_add_private (klass, sizeof (GstBaseTransformPrivate));

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_base_transform_set_property;
  gobject_class->get_property = gst_base_transform_get_property;

  g_object_class_install_property (gobject_class, PROP_QOS,
      g_param_spec_boolean ("qos", "QoS", "Handle Quality-of-Service events",
          DEFAULT_PROP_QOS, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gobject_class->finalize = gst_base_transform_finalize;

  klass->passthrough_on_same_caps = FALSE;
  klass->transform_ip_on_passthrough = TRUE;

  klass->transform_caps =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_transform_caps);
  klass->fixate_caps =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_fixate_caps);
  klass->accept_caps =
      GST_DEBUG_FUNCPTR (gst_base_transform_acceptcaps_default);
  klass->query = GST_DEBUG_FUNCPTR (gst_base_transform_default_query);
  klass->decide_allocation =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_decide_allocation);
  klass->propose_allocation =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_propose_allocation);
  klass->transform_size =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_transform_size);
  klass->transform_meta =
      GST_DEBUG_FUNCPTR (gst_base_transform_default_transform_meta);

  klass->sink_event = GST_DEBUG_FUNCPTR (gst_base_transform_sink_eventfunc);
  klass->src_event = GST_DEBUG_FUNCPTR (gst_base_transform_src_eventfunc);
  klass->prepare_output_buffer =
      GST_DEBUG_FUNCPTR (default_prepare_output_buffer);
  klass->copy_metadata = GST_DEBUG_FUNCPTR (default_copy_metadata);
}

static void
gst_base_transform_init (GstBaseTransform * trans,
    GstBaseTransformClass * bclass)
{
  GstPadTemplate *pad_template;
  GstBaseTransformPrivate *priv;

  GST_DEBUG ("gst_base_transform_init");

  priv = trans->priv = GST_BASE_TRANSFORM_GET_PRIVATE (trans);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass), "sink");
  g_return_if_fail (pad_template != NULL);
  trans->sinkpad = gst_pad_new_from_template (pad_template, "sink");
  gst_pad_set_event_function (trans->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_sink_event));
  gst_pad_set_chain_function (trans->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_chain));
  gst_pad_set_activatemode_function (trans->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_sink_activate_mode));
  gst_pad_set_query_function (trans->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_query));
  gst_element_add_pad (GST_ELEMENT (trans), trans->sinkpad);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass), "src");
  g_return_if_fail (pad_template != NULL);
  trans->srcpad = gst_pad_new_from_template (pad_template, "src");
  gst_pad_set_event_function (trans->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_src_event));
  gst_pad_set_getrange_function (trans->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_getrange));
  gst_pad_set_activatemode_function (trans->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_src_activate_mode));
  gst_pad_set_query_function (trans->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_transform_query));
  gst_element_add_pad (GST_ELEMENT (trans), trans->srcpad);

  priv->qos_enabled = DEFAULT_PROP_QOS;
  priv->cache_caps1 = NULL;
  priv->cache_caps2 = NULL;
  priv->pad_mode = GST_PAD_MODE_NONE;
  priv->gap_aware = FALSE;
  priv->prefer_passthrough = TRUE;

  priv->passthrough = FALSE;
  if (bclass->transform == NULL) {
    /* If no transform function, always_in_place is TRUE */
    GST_DEBUG_OBJECT (trans, "setting in_place TRUE");
    priv->always_in_place = TRUE;

    if (bclass->transform_ip == NULL) {
      GST_DEBUG_OBJECT (trans, "setting passthrough TRUE");
      priv->passthrough = TRUE;
    }
  }

  priv->processed = 0;
  priv->dropped = 0;
}

static GstCaps *
gst_base_transform_default_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter)
{
  GstCaps *ret;

  GST_DEBUG_OBJECT (trans, "identity from: %" GST_PTR_FORMAT, caps);
  /* no transform function, use the identity transform */
  if (filter) {
    ret = gst_caps_intersect_full (filter, caps, GST_CAPS_INTERSECT_FIRST);
  } else {
    ret = gst_caps_ref (caps);
  }
  return ret;
}

/* given @caps on the src or sink pad (given by @direction)
 * calculate the possible caps on the other pad.
 *
 * Returns new caps, unref after usage.
 */
static GstCaps *
gst_base_transform_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter)
{
  GstCaps *ret = NULL;
  GstBaseTransformClass *klass;

  if (caps == NULL)
    return NULL;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  /* if there is a custom transform function, use this */
  if (klass->transform_caps) {
    GST_DEBUG_OBJECT (trans, "transform caps (direction = %d)", direction);

    GST_LOG_OBJECT (trans, "from: %" GST_PTR_FORMAT, caps);
    ret = klass->transform_caps (trans, direction, caps, filter);
    GST_LOG_OBJECT (trans, "  to: %" GST_PTR_FORMAT, ret);

#ifndef G_DISABLE_ASSERT
    if (filter) {
      if (!gst_caps_is_subset (ret, filter)) {
        GstCaps *intersection;

        GST_ERROR_OBJECT (trans,
            "transform_caps returned caps %" GST_PTR_FORMAT
            " which are not a real subset of the filter caps %"
            GST_PTR_FORMAT, ret, filter);
        g_warning ("%s: transform_caps returned caps which are not a real "
            "subset of the filter caps", GST_ELEMENT_NAME (trans));

        intersection =
            gst_caps_intersect_full (filter, ret, GST_CAPS_INTERSECT_FIRST);
        gst_caps_unref (ret);
        ret = intersection;
      }
    }
#endif
  }

  GST_DEBUG_OBJECT (trans, "to: %" GST_PTR_FORMAT, ret);

  return ret;
}

static gboolean
gst_base_transform_default_transform_meta (GstBaseTransform * trans,
    GstBuffer * inbuf, GstMeta * meta, GstBuffer * outbuf)
{
  const GstMetaInfo *info = meta->info;
  const gchar *const *tags;

  tags = gst_meta_api_type_get_tags (info->api);

  if (!tags)
    return TRUE;

  return FALSE;
}

static gboolean
gst_base_transform_default_transform_size (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, gsize size,
    GstCaps * othercaps, gsize * othersize)
{
  gsize inunitsize, outunitsize, units;
  GstBaseTransformClass *klass;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (klass->get_unit_size == NULL) {
    /* if there is no transform_size and no unit_size, it means the
     * element does not modify the size of a buffer */
    *othersize = size;
  } else {
    /* there is no transform_size function, we have to use the unit_size
     * functions. This method assumes there is a fixed unit_size associated with
     * each caps. We provide the same amount of units on both sides. */
    if (!gst_base_transform_get_unit_size (trans, caps, &inunitsize))
      goto no_in_size;

    GST_DEBUG_OBJECT (trans,
        "input size %" G_GSIZE_FORMAT ", input unit size %" G_GSIZE_FORMAT,
        size, inunitsize);

    /* input size must be a multiple of the unit_size of the input caps */
    if (inunitsize == 0 || (size % inunitsize != 0))
      goto no_multiple;

    /* get the amount of units */
    units = size / inunitsize;

    /* now get the unit size of the output */
    if (!gst_base_transform_get_unit_size (trans, othercaps, &outunitsize))
      goto no_out_size;

    /* the output size is the unit_size times the amount of units on the
     * input */
    *othersize = units * outunitsize;
    GST_DEBUG_OBJECT (trans, "transformed size to %" G_GSIZE_FORMAT,
        *othersize);
  }
  return TRUE;

  /* ERRORS */
no_in_size:
  {
    GST_DEBUG_OBJECT (trans, "could not get in_size");
    g_warning ("%s: could not get in_size", GST_ELEMENT_NAME (trans));
    return FALSE;
  }
no_multiple:
  {
    GST_DEBUG_OBJECT (trans, "Size %" G_GSIZE_FORMAT " is not a multiple of"
        "unit size %" G_GSIZE_FORMAT, size, inunitsize);
    g_warning ("%s: size %" G_GSIZE_FORMAT " is not a multiple of unit size %"
        G_GSIZE_FORMAT, GST_ELEMENT_NAME (trans), size, inunitsize);
    return FALSE;
  }
no_out_size:
  {
    GST_DEBUG_OBJECT (trans, "could not get out_size");
    g_warning ("%s: could not get out_size", GST_ELEMENT_NAME (trans));
    return FALSE;
  }
}

/* transform a buffer of @size with @caps on the pad with @direction to
 * the size of a buffer with @othercaps and store the result in @othersize
 *
 * We have two ways of doing this:
 *  1) use a custom transform size function, this is for complicated custom
 *     cases with no fixed unit_size.
 *  2) use the unit_size functions where there is a relationship between the
 *     caps and the size of a buffer.
 */
static gboolean
gst_base_transform_transform_size (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps,
    gsize size, GstCaps * othercaps, gsize * othersize)
{
  GstBaseTransformClass *klass;
  gboolean ret = FALSE;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  GST_DEBUG_OBJECT (trans,
      "asked to transform size %" G_GSIZE_FORMAT " for caps %"
      GST_PTR_FORMAT " to size for caps %" GST_PTR_FORMAT " in direction %s",
      size, caps, othercaps, direction == GST_PAD_SRC ? "SRC" : "SINK");

  if (klass->transform_size) {
    /* if there is a custom transform function, use this */
    ret = klass->transform_size (trans, direction, caps, size, othercaps,
        othersize);
  }
  return ret;
}

/* get the caps that can be handled by @pad. We perform:
 *
 *  - take the caps of peer of otherpad,
 *  - filter against the padtemplate of otherpad, 
 *  - calculate all transforms of remaining caps
 *  - filter against template of @pad
 *
 * If there is no peer, we simply return the caps of the padtemplate of pad.
 */
static GstCaps *
gst_base_transform_query_caps (GstBaseTransform * trans, GstPad * pad,
    GstCaps * filter)
{
  GstPad *otherpad;
  GstCaps *peercaps, *caps, *temp, *peerfilter = NULL;
  GstCaps *templ, *otempl;

  otherpad = (pad == trans->srcpad) ? trans->sinkpad : trans->srcpad;

  templ = gst_pad_get_pad_template_caps (pad);
  otempl = gst_pad_get_pad_template_caps (otherpad);

  /* first prepare the filter to be send onwards. We need to filter and
   * transform it to valid caps for the otherpad. */
  if (filter) {
    GST_DEBUG_OBJECT (pad, "filter caps  %" GST_PTR_FORMAT, filter);

    /* filtered against our padtemplate of this pad */
    GST_DEBUG_OBJECT (pad, "our template  %" GST_PTR_FORMAT, templ);
    temp = gst_caps_intersect_full (filter, templ, GST_CAPS_INTERSECT_FIRST);
    GST_DEBUG_OBJECT (pad, "intersected %" GST_PTR_FORMAT, temp);

    /* then see what we can transform this to */
    peerfilter = gst_base_transform_transform_caps (trans,
        GST_PAD_DIRECTION (pad), temp, NULL);
    GST_DEBUG_OBJECT (pad, "transformed  %" GST_PTR_FORMAT, peerfilter);
    gst_caps_unref (temp);

    /* and filter against the template of the other pad */
    GST_DEBUG_OBJECT (pad, "our template  %" GST_PTR_FORMAT, otempl);
    /* We keep the caps sorted like the returned caps */
    temp =
        gst_caps_intersect_full (peerfilter, otempl, GST_CAPS_INTERSECT_FIRST);
    GST_DEBUG_OBJECT (pad, "intersected %" GST_PTR_FORMAT, temp);
    gst_caps_unref (peerfilter);
    peerfilter = temp;
  }

  /* query the peer with the transformed filter */
  peercaps = gst_pad_peer_query_caps (otherpad, peerfilter);

  if (peerfilter)
    gst_caps_unref (peerfilter);

  if (peercaps) {
    GST_DEBUG_OBJECT (pad, "peer caps  %" GST_PTR_FORMAT, peercaps);

    /* filtered against our padtemplate on the other side */
    GST_DEBUG_OBJECT (pad, "our template  %" GST_PTR_FORMAT, otempl);
    temp = gst_caps_intersect_full (peercaps, otempl, GST_CAPS_INTERSECT_FIRST);
    GST_DEBUG_OBJECT (pad, "intersected %" GST_PTR_FORMAT, temp);
  } else {
    temp = gst_caps_ref (otempl);
  }

  /* then see what we can transform this to */
  caps = gst_base_transform_transform_caps (trans,
      GST_PAD_DIRECTION (otherpad), temp, filter);
  GST_DEBUG_OBJECT (pad, "transformed  %" GST_PTR_FORMAT, caps);
  gst_caps_unref (temp);
  if (caps == NULL)
    goto done;

  if (peercaps) {
    /* and filter against the template of this pad */
    GST_DEBUG_OBJECT (pad, "our template  %" GST_PTR_FORMAT, templ);
    /* We keep the caps sorted like the returned caps */
    temp = gst_caps_intersect_full (caps, templ, GST_CAPS_INTERSECT_FIRST);
    GST_DEBUG_OBJECT (pad, "intersected %" GST_PTR_FORMAT, temp);
    gst_caps_unref (caps);
    caps = temp;

    if (trans->priv->prefer_passthrough) {
      /* Now try if we can put the untransformed downstream caps first */
      temp = gst_caps_intersect_full (peercaps, caps, GST_CAPS_INTERSECT_FIRST);
      if (!gst_caps_is_empty (temp)) {
        caps = gst_caps_merge (temp, caps);
      } else {
        gst_caps_unref (temp);
      }
    }
  } else {
    gst_caps_unref (caps);
    /* no peer or the peer can do anything, our padtemplate is enough then */
    if (filter) {
      caps = gst_caps_intersect_full (filter, templ, GST_CAPS_INTERSECT_FIRST);
    } else {
      caps = gst_caps_ref (templ);
    }
  }

done:
  GST_DEBUG_OBJECT (trans, "returning  %" GST_PTR_FORMAT, caps);

  if (peercaps)
    gst_caps_unref (peercaps);

  gst_caps_unref (templ);
  gst_caps_unref (otempl);

  return caps;
}

/* takes ownership of the pool, allocator and query */
static gboolean
gst_base_transform_set_allocation (GstBaseTransform * trans,
    GstBufferPool * pool, GstAllocator * allocator,
    GstAllocationParams * params, GstQuery * query)
{
  GstAllocator *oldalloc;
  GstBufferPool *oldpool;
  GstQuery *oldquery;
  GstBaseTransformPrivate *priv = trans->priv;

  GST_OBJECT_LOCK (trans);
  oldpool = priv->pool;
  priv->pool = pool;
  priv->pool_active = FALSE;

  oldalloc = priv->allocator;
  priv->allocator = allocator;

  oldquery = priv->query;
  priv->query = query;

  if (params)
    priv->params = *params;
  else
    gst_allocation_params_init (&priv->params);
  GST_OBJECT_UNLOCK (trans);

  if (oldpool) {
    GST_DEBUG_OBJECT (trans, "deactivating old pool %p", oldpool);
    gst_buffer_pool_set_active (oldpool, FALSE);
    gst_object_unref (oldpool);
  }
  if (oldalloc) {
    gst_object_unref (oldalloc);
  }
  if (oldquery) {
    gst_query_unref (oldquery);
  }
  return TRUE;
}

static gboolean
gst_base_transform_default_decide_allocation (GstBaseTransform * trans,
    GstQuery * query)
{
  guint i, n_metas;
  GstBaseTransformClass *klass;
  GstCaps *outcaps;
  GstBufferPool *pool;
  guint size, min, max;
  GstAllocator *allocator;
  GstAllocationParams params;
  GstStructure *config;
  gboolean update_allocator;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  n_metas = gst_query_get_n_allocation_metas (query);
  for (i = 0; i < n_metas; i++) {
    GType api;
    const GstStructure *params;
    gboolean remove;

    api = gst_query_parse_nth_allocation_meta (query, i, &params);

    /* by default we remove all metadata, subclasses should implement a
     * filter_meta function */
    if (gst_meta_api_type_has_tag (api, _gst_meta_tag_memory)) {
      /* remove all memory dependent metadata because we are going to have to
       * allocate different memory for input and output. */
      GST_LOG_OBJECT (trans, "removing memory specific metadata %s",
          g_type_name (api));
      remove = TRUE;
    } else if (G_LIKELY (klass->filter_meta)) {
      /* remove if the subclass said so */
      remove = !klass->filter_meta (trans, query, api, params);
      GST_LOG_OBJECT (trans, "filter_meta for api %s returned: %s",
          g_type_name (api), (remove ? "remove" : "keep"));
    } else {
      GST_LOG_OBJECT (trans, "removing metadata %s", g_type_name (api));
      remove = TRUE;
    }

    if (remove) {
      gst_query_remove_nth_allocation_meta (query, i);
      i--;
      n_metas--;
    }
  }

  gst_query_parse_allocation (query, &outcaps, NULL);

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    /* try the allocator */
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
    update_allocator = TRUE;
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
    update_allocator = FALSE;
  }

  if (gst_query_get_n_allocation_pools (query) > 0) {
    gst_query_parse_nth_allocation_pool (query, 0, &pool, &size, &min, &max);

    if (pool == NULL) {
      /* no pool, we can make our own */
      GST_DEBUG_OBJECT (trans, "no pool, making new pool");
      pool = gst_buffer_pool_new ();
    }
  } else {
    pool = NULL;
    size = min = max = 0;
  }

  /* now configure */
  if (pool) {
    config = gst_buffer_pool_get_config (pool);
    gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
    gst_buffer_pool_config_set_allocator (config, allocator, &params);

    /* buffer pool may have to do some changes */
    if (!gst_buffer_pool_set_config (pool, config)) {
      config = gst_buffer_pool_get_config (pool);

      /* If change are not acceptable, fallback to generic pool */
      if (!gst_buffer_pool_config_validate_params (config, outcaps, size, min,
              max)) {
        GST_DEBUG_OBJECT (trans, "unsuported pool, making new pool");

        gst_object_unref (pool);
        pool = gst_buffer_pool_new ();
        gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
        gst_buffer_pool_config_set_allocator (config, allocator, &params);
      }

      if (!gst_buffer_pool_set_config (pool, config))
        goto config_failed;
    }
  }

  if (update_allocator)
    gst_query_set_nth_allocation_param (query, 0, allocator, &params);
  else
    gst_query_add_allocation_param (query, allocator, &params);
  if (allocator)
    gst_object_unref (allocator);

  if (pool) {
    gst_query_set_nth_allocation_pool (query, 0, pool, size, min, max);
    gst_object_unref (pool);
  }

  return TRUE;

config_failed:
  GST_ELEMENT_ERROR (trans, RESOURCE, SETTINGS,
      ("Failed to configure the buffer pool"),
      ("Configuration is most likely invalid, please report this issue."));
  return FALSE;
}

static gboolean
gst_base_transform_do_bufferpool (GstBaseTransform * trans, GstCaps * outcaps)
{
  GstQuery *query;
  gboolean result = TRUE;
  GstBufferPool *pool = NULL;
  GstBaseTransformClass *klass;
  GstBaseTransformPrivate *priv = trans->priv;
  GstAllocator *allocator;
  GstAllocationParams params;

  /* there are these possibilities:
   *
   * 1) we negotiated passthrough, we can proxy the bufferpool directly and we
   *    will do that whenever some upstream does an allocation query.
   * 2) we need to do a transform, we need to get a bufferpool from downstream
   *    and configure it. When upstream does the ALLOCATION query, the
   *    propose_allocation vmethod will be called and we will configure the
   *    upstream allocator with our proposed values then.
   */
  if (priv->passthrough || priv->always_in_place) {
    /* we are in passthrough, the input buffer is never copied and always passed
     * along. We never allocate an output buffer on the srcpad. What we do is
     * let the upstream element decide if it wants to use a bufferpool and
     * then we will proxy the downstream pool */
    GST_DEBUG_OBJECT (trans, "we're passthough, delay bufferpool");
    gst_base_transform_set_allocation (trans, NULL, NULL, NULL, NULL);
    return TRUE;
  }

  /* not passthrough, we need to allocate */
  /* find a pool for the negotiated caps now */
  GST_DEBUG_OBJECT (trans, "doing allocation query");
  query = gst_query_new_allocation (outcaps, TRUE);
  if (!gst_pad_peer_query (trans->srcpad, query)) {
    /* not a problem, just debug a little */
    GST_DEBUG_OBJECT (trans, "peer ALLOCATION query failed");
  }

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  GST_DEBUG_OBJECT (trans, "calling decide_allocation");
  g_assert (klass->decide_allocation != NULL);
  result = klass->decide_allocation (trans, query);

  GST_DEBUG_OBJECT (trans, "ALLOCATION (%d) params: %" GST_PTR_FORMAT, result,
      query);

  if (!result)
    goto no_decide_allocation;

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
  }

  if (gst_query_get_n_allocation_pools (query) > 0)
    gst_query_parse_nth_allocation_pool (query, 0, &pool, NULL, NULL, NULL);

  /* now store */
  result =
      gst_base_transform_set_allocation (trans, pool, allocator, &params,
      query);

  return result;

  /* Errors */
no_decide_allocation:
  {
    GST_WARNING_OBJECT (trans, "Subclass failed to decide allocation");
    gst_query_unref (query);

    return result;
  }
}

/* function triggered when the in and out caps are negotiated and need
 * to be configured in the subclass. */
static gboolean
gst_base_transform_configure_caps (GstBaseTransform * trans, GstCaps * in,
    GstCaps * out)
{
  gboolean ret = TRUE;
  GstBaseTransformClass *klass;
  GstBaseTransformPrivate *priv = trans->priv;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  GST_DEBUG_OBJECT (trans, "in caps:  %" GST_PTR_FORMAT, in);
  GST_DEBUG_OBJECT (trans, "out caps: %" GST_PTR_FORMAT, out);

  /* clear the cache */
  gst_caps_replace (&priv->cache_caps1, NULL);
  gst_caps_replace (&priv->cache_caps2, NULL);

  /* figure out same caps state */
  priv->have_same_caps = gst_caps_is_equal (in, out);
  GST_DEBUG_OBJECT (trans, "have_same_caps: %d", priv->have_same_caps);

  /* Set the passthrough if the class wants passthrough_on_same_caps
   * and we have the same caps on each pad */
  if (klass->passthrough_on_same_caps)
    gst_base_transform_set_passthrough (trans, priv->have_same_caps);

  /* now configure the element with the caps */
  if (klass->set_caps) {
    GST_DEBUG_OBJECT (trans, "Calling set_caps method to setup caps");
    ret = klass->set_caps (trans, in, out);
  }

  return ret;
}

static GstCaps *
gst_base_transform_default_fixate_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * othercaps)
{
  othercaps = gst_caps_fixate (othercaps);
  GST_DEBUG_OBJECT (trans, "fixated to %" GST_PTR_FORMAT, othercaps);

  return othercaps;
}

/* given a fixed @caps on @pad, create the best possible caps for the
 * other pad.
 * @caps must be fixed when calling this function.
 *
 * This function calls the transform caps vmethod of the basetransform to figure
 * out the possible target formats. It then tries to select the best format from
 * this list by:
 *
 * - attempt passthrough if the target caps is a superset of the input caps
 * - fixating by using peer caps
 * - fixating with transform fixate function
 * - fixating with pad fixate functions.
 *
 * this function returns a caps that can be transformed into and is accepted by
 * the peer element.
 */
static GstCaps *
gst_base_transform_find_transform (GstBaseTransform * trans, GstPad * pad,
    GstCaps * caps)
{
  GstBaseTransformClass *klass;
  GstPad *otherpad, *otherpeer;
  GstCaps *othercaps;
  gboolean is_fixed;

  /* caps must be fixed here, this is a programming error if it's not */
  g_return_val_if_fail (gst_caps_is_fixed (caps), NULL);

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  otherpad = (pad == trans->srcpad) ? trans->sinkpad : trans->srcpad;
  otherpeer = gst_pad_get_peer (otherpad);

  /* see how we can transform the input caps. We need to do this even for
   * passthrough because it might be possible that this element cannot support
   * passthrough at all. */
  othercaps = gst_base_transform_transform_caps (trans,
      GST_PAD_DIRECTION (pad), caps, NULL);

  /* The caps we can actually output is the intersection of the transformed
   * caps with the pad template for the pad */
  if (othercaps) {
    GstCaps *intersect, *templ_caps;

    templ_caps = gst_pad_get_pad_template_caps (otherpad);
    GST_DEBUG_OBJECT (trans,
        "intersecting against padtemplate %" GST_PTR_FORMAT, templ_caps);

    intersect =
        gst_caps_intersect_full (othercaps, templ_caps,
        GST_CAPS_INTERSECT_FIRST);

    gst_caps_unref (othercaps);
    gst_caps_unref (templ_caps);
    othercaps = intersect;
  }

  /* check if transform is empty */
  if (!othercaps || gst_caps_is_empty (othercaps))
    goto no_transform;

  /* if the othercaps are not fixed, we need to fixate them, first attempt
   * is by attempting passthrough if the othercaps are a superset of caps. */
  /* FIXME. maybe the caps is not fixed because it has multiple structures of
   * fixed caps */
  is_fixed = gst_caps_is_fixed (othercaps);
  if (!is_fixed) {
    GST_DEBUG_OBJECT (trans,
        "transform returned non fixed  %" GST_PTR_FORMAT, othercaps);

    /* Now let's see what the peer suggests based on our transformed caps */
    if (otherpeer) {
      GstCaps *peercaps, *intersection, *templ_caps;

      GST_DEBUG_OBJECT (trans,
          "Checking peer caps with filter %" GST_PTR_FORMAT, othercaps);

      peercaps = gst_pad_query_caps (otherpeer, othercaps);
      GST_DEBUG_OBJECT (trans, "Resulted in %" GST_PTR_FORMAT, peercaps);
      if (!gst_caps_is_empty (peercaps)) {
        templ_caps = gst_pad_get_pad_template_caps (otherpad);

        GST_DEBUG_OBJECT (trans,
            "Intersecting with template caps %" GST_PTR_FORMAT, templ_caps);

        intersection =
            gst_caps_intersect_full (peercaps, templ_caps,
            GST_CAPS_INTERSECT_FIRST);
        GST_DEBUG_OBJECT (trans, "Intersection: %" GST_PTR_FORMAT,
            intersection);
        gst_caps_unref (peercaps);
        gst_caps_unref (templ_caps);
        peercaps = intersection;

        GST_DEBUG_OBJECT (trans,
            "Intersecting with transformed caps %" GST_PTR_FORMAT, othercaps);
        intersection =
            gst_caps_intersect_full (peercaps, othercaps,
            GST_CAPS_INTERSECT_FIRST);
        GST_DEBUG_OBJECT (trans, "Intersection: %" GST_PTR_FORMAT,
            intersection);
        gst_caps_unref (peercaps);
        gst_caps_unref (othercaps);
        othercaps = intersection;
      } else {
        gst_caps_unref (othercaps);
        othercaps = peercaps;
      }

      is_fixed = gst_caps_is_fixed (othercaps);
    } else {
      GST_DEBUG_OBJECT (trans, "no peer, doing passthrough");
      gst_caps_unref (othercaps);
      othercaps = gst_caps_ref (caps);
      is_fixed = TRUE;
    }
  }
  if (gst_caps_is_empty (othercaps))
    goto no_transform_possible;

  GST_DEBUG ("have %sfixed caps %" GST_PTR_FORMAT, (is_fixed ? "" : "non-"),
      othercaps);

  /* second attempt at fixation, call the fixate vmethod */
  /* caps could be fixed but the subclass may want to add fields */
  if (klass->fixate_caps) {
    GST_DEBUG_OBJECT (trans, "calling fixate_caps for %" GST_PTR_FORMAT
        " using caps %" GST_PTR_FORMAT " on pad %s:%s", othercaps, caps,
        GST_DEBUG_PAD_NAME (otherpad));
    /* note that we pass the complete array of structures to the fixate
     * function, it needs to truncate itself */
    othercaps =
        klass->fixate_caps (trans, GST_PAD_DIRECTION (pad), caps, othercaps);
    is_fixed = gst_caps_is_fixed (othercaps);
    GST_DEBUG_OBJECT (trans, "after fixating %" GST_PTR_FORMAT, othercaps);
  }

  /* caps should be fixed now, if not we have to fail. */
  if (!is_fixed)
    goto could_not_fixate;

  /* and peer should accept */
  if (otherpeer && !gst_pad_query_accept_caps (otherpeer, othercaps))
    goto peer_no_accept;

  GST_DEBUG_OBJECT (trans, "Input caps were %" GST_PTR_FORMAT
      ", and got final caps %" GST_PTR_FORMAT, caps, othercaps);

  if (otherpeer)
    gst_object_unref (otherpeer);

  return othercaps;

  /* ERRORS */
no_transform:
  {
    GST_DEBUG_OBJECT (trans,
        "transform returned useless  %" GST_PTR_FORMAT, othercaps);
    goto error_cleanup;
  }
no_transform_possible:
  {
    GST_DEBUG_OBJECT (trans,
        "transform could not transform %" GST_PTR_FORMAT
        " in anything we support", caps);
    goto error_cleanup;
  }
could_not_fixate:
  {
    GST_DEBUG_OBJECT (trans, "FAILED to fixate %" GST_PTR_FORMAT, othercaps);
    goto error_cleanup;
  }
peer_no_accept:
  {
    GST_DEBUG_OBJECT (trans, "FAILED to get peer of %" GST_PTR_FORMAT
        " to accept %" GST_PTR_FORMAT, otherpad, othercaps);
    goto error_cleanup;
  }
error_cleanup:
  {
    if (otherpeer)
      gst_object_unref (otherpeer);
    if (othercaps)
      gst_caps_unref (othercaps);
    return NULL;
  }
}

static gboolean
gst_base_transform_acceptcaps_default (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps)
{
#if 0
  GstPad *otherpad;
  GstCaps *othercaps = NULL;
#endif
  gboolean ret = TRUE;

#if 0
  otherpad = (pad == trans->srcpad) ? trans->sinkpad : trans->srcpad;

  /* we need fixed caps for the check, fall back to the default implementation
   * if we don't */
  if (!gst_caps_is_fixed (caps))
#endif
  {
    GstCaps *allowed;

    GST_DEBUG_OBJECT (trans, "accept caps %" GST_PTR_FORMAT, caps);

    /* get all the formats we can handle on this pad */
    if (direction == GST_PAD_SRC)
      allowed = gst_pad_query_caps (trans->srcpad, caps);
    else
      allowed = gst_pad_query_caps (trans->sinkpad, caps);

    if (!allowed) {
      GST_DEBUG_OBJECT (trans, "gst_pad_query_caps() failed");
      goto no_transform_possible;
    }

    GST_DEBUG_OBJECT (trans, "allowed caps %" GST_PTR_FORMAT, allowed);

    /* intersect with the requested format */
    ret = gst_caps_is_subset (caps, allowed);
    gst_caps_unref (allowed);

    if (!ret)
      goto no_transform_possible;
  }
#if 0
  else {
    GST_DEBUG_OBJECT (pad, "accept caps %" GST_PTR_FORMAT, caps);

    /* find best possible caps for the other pad as a way to see if we can
     * transform this caps. */
    othercaps = gst_base_transform_find_transform (trans, pad, caps, FALSE);
    if (!othercaps || gst_caps_is_empty (othercaps))
      goto no_transform_possible;

    GST_DEBUG_OBJECT (pad, "we can transform to %" GST_PTR_FORMAT, othercaps);
  }
#endif

done:
#if 0
  /* We know it's always NULL since we never use it */
  if (othercaps)
    gst_caps_unref (othercaps);
#endif

  return ret;

  /* ERRORS */
no_transform_possible:
  {
    GST_DEBUG_OBJECT (trans,
        "transform could not transform %" GST_PTR_FORMAT
        " in anything we support", caps);
    ret = FALSE;
    goto done;
  }
}

/* called when new caps arrive on the sink pad,
 * We try to find the best caps for the other side using our _find_transform()
 * function. If there are caps, we configure the transform for this new
 * transformation.
 */
static gboolean
gst_base_transform_setcaps (GstBaseTransform * trans, GstPad * pad,
    GstCaps * incaps)
{
  GstBaseTransformPrivate *priv = trans->priv;
  GstCaps *outcaps, *prevcaps;
  gboolean ret = TRUE;

  GST_DEBUG_OBJECT (pad, "have new caps %p %" GST_PTR_FORMAT, incaps, incaps);

  /* find best possible caps for the other pad */
  outcaps = gst_base_transform_find_transform (trans, pad, incaps);
  if (!outcaps || gst_caps_is_empty (outcaps))
    goto no_transform_possible;

  /* configure the element now */

  /* if we have the same caps, we can optimize and reuse the input caps */
  if (gst_caps_is_equal (incaps, outcaps)) {
    GST_INFO_OBJECT (trans, "reuse caps");
    gst_caps_unref (outcaps);
    outcaps = gst_caps_ref (incaps);
  }

  /* call configure now */
  if (!(ret = gst_base_transform_configure_caps (trans, incaps, outcaps)))
    goto failed_configure;

  prevcaps = gst_pad_get_current_caps (trans->srcpad);

  if (!prevcaps || !gst_caps_is_equal (outcaps, prevcaps))
    /* let downstream know about our caps */
    ret = gst_pad_set_caps (trans->srcpad, outcaps);

  if (prevcaps)
    gst_caps_unref (prevcaps);

  if (ret) {
    /* try to get a pool when needed */
    ret = gst_base_transform_do_bufferpool (trans, outcaps);
  }

done:
  if (outcaps)
    gst_caps_unref (outcaps);

  GST_OBJECT_LOCK (trans);
  priv->negotiated = ret;
  GST_OBJECT_UNLOCK (trans);

  return ret;

  /* ERRORS */
no_transform_possible:
  {
    GST_WARNING_OBJECT (trans,
        "transform could not transform %" GST_PTR_FORMAT
        " in anything we support", incaps);
    ret = FALSE;
    goto done;
  }
failed_configure:
  {
    GST_WARNING_OBJECT (trans, "FAILED to configure incaps %" GST_PTR_FORMAT
        " and outcaps %" GST_PTR_FORMAT, incaps, outcaps);
    ret = FALSE;
    goto done;
  }
}

static gboolean
gst_base_transform_default_propose_allocation (GstBaseTransform * trans,
    GstQuery * decide_query, GstQuery * query)
{
  gboolean ret;

  if (decide_query == NULL) {
    GST_DEBUG_OBJECT (trans, "doing passthrough query");
    ret = gst_pad_peer_query (trans->srcpad, query);
  } else {
    guint i, n_metas;
    /* non-passthrough, copy all metadata, decide_query does not contain the
     * metadata anymore that depends on the buffer memory */
    n_metas = gst_query_get_n_allocation_metas (decide_query);
    for (i = 0; i < n_metas; i++) {
      GType api;
      const GstStructure *params;

      api = gst_query_parse_nth_allocation_meta (decide_query, i, &params);
      GST_DEBUG_OBJECT (trans, "proposing metadata %s", g_type_name (api));
      gst_query_add_allocation_meta (query, api, params);
    }
    ret = TRUE;
  }
  return ret;
}

static gboolean
gst_base_transform_default_query (GstBaseTransform * trans,
    GstPadDirection direction, GstQuery * query)
{
  gboolean ret = FALSE;
  GstPad *pad, *otherpad;
  GstBaseTransformClass *klass;
  GstBaseTransformPrivate *priv = trans->priv;

  if (direction == GST_PAD_SRC) {
    pad = trans->srcpad;
    otherpad = trans->sinkpad;
  } else {
    pad = trans->sinkpad;
    otherpad = trans->srcpad;
  }

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_ALLOCATION:
    {
      GstQuery *decide_query = NULL;

      /* can only be done on the sinkpad */
      if (direction != GST_PAD_SINK)
        goto done;

      GST_OBJECT_LOCK (trans);
      if (!priv->negotiated && !priv->passthrough && (klass->set_caps != NULL)) {
        GST_DEBUG_OBJECT (trans,
            "not negotiated yet but need negotiation, can't answer ALLOCATION query");
        GST_OBJECT_UNLOCK (trans);
        goto done;
      }
      if ((decide_query = trans->priv->query))
        gst_query_ref (decide_query);
      GST_OBJECT_UNLOCK (trans);

      GST_DEBUG_OBJECT (trans,
          "calling propose allocation with query %" GST_PTR_FORMAT,
          decide_query);

      /* pass the query to the propose_allocation vmethod if any */
      if (G_LIKELY (klass->propose_allocation))
        ret = klass->propose_allocation (trans, decide_query, query);
      else
        ret = FALSE;

      if (decide_query)
        gst_query_unref (decide_query);

      GST_DEBUG_OBJECT (trans, "ALLOCATION ret %d, %" GST_PTR_FORMAT, ret,
          query);
      break;
    }
    case GST_QUERY_POSITION:
    {
      GstFormat format;

      gst_query_parse_position (query, &format, NULL);
      if (format == GST_FORMAT_TIME && trans->segment.format == GST_FORMAT_TIME) {
        gint64 pos;
        ret = TRUE;

        if ((direction == GST_PAD_SINK)
            || (trans->priv->position_out == GST_CLOCK_TIME_NONE)) {
          pos =
              gst_segment_to_stream_time (&trans->segment, GST_FORMAT_TIME,
              trans->segment.position);
        } else {
          pos = gst_segment_to_stream_time (&trans->segment, GST_FORMAT_TIME,
              trans->priv->position_out);
        }
        gst_query_set_position (query, format, pos);
      } else {
        ret = gst_pad_peer_query (otherpad, query);
      }
      break;
    }
    case GST_QUERY_ACCEPT_CAPS:
    {
      GstCaps *caps;

      gst_query_parse_accept_caps (query, &caps);
      if (klass->accept_caps) {
        ret = klass->accept_caps (trans, direction, caps);
        gst_query_set_accept_caps_result (query, ret);
        /* return TRUE, we answered the query */
        ret = TRUE;
      }
      break;
    }
    case GST_QUERY_CAPS:
    {
      GstCaps *filter, *caps;

      gst_query_parse_caps (query, &filter);
      caps = gst_base_transform_query_caps (trans, pad, filter);
      gst_query_set_caps_result (query, caps);
      gst_caps_unref (caps);
      ret = TRUE;
      break;
    }
    default:
      ret = gst_pad_peer_query (otherpad, query);
      break;
  }

done:
  return ret;
}

static gboolean
gst_base_transform_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstBaseTransform *trans;
  GstBaseTransformClass *bclass;
  gboolean ret = FALSE;

  trans = GST_BASE_TRANSFORM (parent);
  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (bclass->query)
    ret = bclass->query (trans, GST_PAD_DIRECTION (pad), query);

  return ret;
}

/* this function either returns the input buffer without incrementing the
 * refcount or it allocates a new (writable) buffer */
static GstFlowReturn
default_prepare_output_buffer (GstBaseTransform * trans,
    GstBuffer * inbuf, GstBuffer ** outbuf)
{
  GstBaseTransformPrivate *priv;
  GstFlowReturn ret;
  GstBaseTransformClass *bclass;
  GstCaps *incaps, *outcaps;
  gsize insize, outsize;
  gboolean res;

  priv = trans->priv;
  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  /* figure out how to allocate an output buffer */
  if (priv->passthrough) {
    /* passthrough, we will not modify the incoming buffer so we can just
     * reuse it */
    GST_DEBUG_OBJECT (trans, "passthrough: reusing input buffer");
    *outbuf = inbuf;
    goto done;
  }

  /* we can't reuse the input buffer */
  if (priv->pool) {
    if (!priv->pool_active) {
      GST_DEBUG_OBJECT (trans, "setting pool %p active", priv->pool);
      if (!gst_buffer_pool_set_active (priv->pool, TRUE))
        goto activate_failed;
      priv->pool_active = TRUE;
    }
    GST_DEBUG_OBJECT (trans, "using pool alloc");
    ret = gst_buffer_pool_acquire_buffer (priv->pool, outbuf, NULL);
    if (ret != GST_FLOW_OK)
      goto alloc_failed;

    goto copy_meta;
  }

  /* no pool, we need to figure out the size of the output buffer first */
  if ((bclass->transform_ip != NULL) && priv->always_in_place) {
    /* we want to do an in-place alloc */
    if (gst_buffer_is_writable (inbuf)) {
      GST_DEBUG_OBJECT (trans, "inplace reuse writable input buffer");
      *outbuf = inbuf;
    } else {
      GST_DEBUG_OBJECT (trans, "making writable buffer copy");
      /* we make a copy of the input buffer */
      *outbuf = gst_buffer_copy (inbuf);
    }
    goto done;
  }

  /* else use the transform function to get the size */
  incaps = gst_pad_get_current_caps (trans->sinkpad);
  outcaps = gst_pad_get_current_caps (trans->srcpad);

  /* srcpad might be flushing already if we're being shut down */
  if (outcaps == NULL)
    goto no_outcaps;

  GST_DEBUG_OBJECT (trans, "getting output size for alloc");
  /* copy transform, figure out the output size */
  insize = gst_buffer_get_size (inbuf);
  res = gst_base_transform_transform_size (trans,
      GST_PAD_SINK, incaps, insize, outcaps, &outsize);

  gst_caps_unref (incaps);
  gst_caps_unref (outcaps);

  if (!res)
    goto unknown_size;

  GST_DEBUG_OBJECT (trans, "doing alloc of size %" G_GSIZE_FORMAT, outsize);
  *outbuf = gst_buffer_new_allocate (priv->allocator, outsize, &priv->params);
  if (!*outbuf) {
    ret = GST_FLOW_ERROR;
    goto alloc_failed;
  }

copy_meta:
  /* copy the metadata */
  if (bclass->copy_metadata)
    if (!bclass->copy_metadata (trans, inbuf, *outbuf)) {
      /* something failed, post a warning */
      GST_ELEMENT_WARNING (trans, STREAM, NOT_IMPLEMENTED,
          ("could not copy metadata"), (NULL));
    }

done:
  return GST_FLOW_OK;

  /* ERRORS */
activate_failed:
  {
    GST_ELEMENT_ERROR (trans, RESOURCE, SETTINGS,
        ("failed to activate bufferpool"), ("failed to activate bufferpool"));
    return GST_FLOW_ERROR;
  }
unknown_size:
  {
    GST_ERROR_OBJECT (trans, "unknown output size");
    return GST_FLOW_ERROR;
  }
alloc_failed:
  {
    GST_DEBUG_OBJECT (trans, "could not allocate buffer from pool");
    return ret;
  }
no_outcaps:
  {
    GST_DEBUG_OBJECT (trans, "no output caps, source pad has been deactivated");
    gst_caps_unref (incaps);
    return GST_FLOW_FLUSHING;
  }
}

typedef struct
{
  GstBaseTransform *trans;
  GstBuffer *outbuf;
} CopyMetaData;

static gboolean
foreach_metadata (GstBuffer * inbuf, GstMeta ** meta, gpointer user_data)
{
  CopyMetaData *data = user_data;
  GstBaseTransform *trans = data->trans;
  GstBaseTransformClass *klass;
  const GstMetaInfo *info = (*meta)->info;
  GstBuffer *outbuf = data->outbuf;
  gboolean do_copy = FALSE;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (GST_META_FLAG_IS_SET (*meta, GST_META_FLAG_POOLED)) {
    /* never call the transform_meta with pool private metadata */
    GST_DEBUG_OBJECT (trans, "not copying pooled metadata %s",
        g_type_name (info->api));
    do_copy = FALSE;
  } else if (gst_meta_api_type_has_tag (info->api, _gst_meta_tag_memory)) {
    /* never call the transform_meta with memory specific metadata */
    GST_DEBUG_OBJECT (trans, "not copying memory specific metadata %s",
        g_type_name (info->api));
    do_copy = FALSE;
  } else if (klass->transform_meta) {
    do_copy = klass->transform_meta (trans, outbuf, *meta, inbuf);
    GST_DEBUG_OBJECT (trans, "transformed metadata %s: copy: %d",
        g_type_name (info->api), do_copy);
  }

  /* we only copy metadata when the subclass implemented a transform_meta
   * function and when it returns %TRUE */
  if (do_copy) {
    GstMetaTransformCopy copy_data = { FALSE, 0, -1 };
    GST_DEBUG_OBJECT (trans, "copy metadata %s", g_type_name (info->api));
    /* simply copy then */
    info->transform_func (outbuf, *meta, inbuf,
        _gst_meta_transform_copy, &copy_data);
  }
  return TRUE;
}

static gboolean
default_copy_metadata (GstBaseTransform * trans,
    GstBuffer * inbuf, GstBuffer * outbuf)
{
  GstBaseTransformPrivate *priv = trans->priv;
  CopyMetaData data;

  /* now copy the metadata */
  GST_DEBUG_OBJECT (trans, "copying metadata");

  /* this should not happen, buffers allocated from a pool or with
   * new_allocate should always be writable. */
  if (!gst_buffer_is_writable (outbuf))
    goto not_writable;

  /* when we get here, the metadata should be writable */
  gst_buffer_copy_into (outbuf, inbuf,
      GST_BUFFER_COPY_FLAGS | GST_BUFFER_COPY_TIMESTAMPS, 0, -1);

  /* clear the GAP flag when the subclass does not understand it */
  if (!priv->gap_aware)
    GST_BUFFER_FLAG_UNSET (outbuf, GST_BUFFER_FLAG_GAP);


  data.trans = trans;
  data.outbuf = outbuf;

  gst_buffer_foreach_meta (inbuf, foreach_metadata, &data);

  return TRUE;

  /* ERRORS */
not_writable:
  {
    GST_WARNING_OBJECT (trans, "buffer %p not writable", outbuf);
    return FALSE;
  }
}

/* Given @caps calcultate the size of one unit.
 *
 * For video caps, this is the size of one frame (and thus one buffer).
 * For audio caps, this is the size of one sample.
 *
 * These values are cached since they do not change and the calculation
 * potentially involves parsing caps and other expensive stuff.
 *
 * We have two cache locations to store the size, one for the source caps
 * and one for the sink caps.
 *
 * this function returns %FALSE if no size could be calculated.
 */
static gboolean
gst_base_transform_get_unit_size (GstBaseTransform * trans, GstCaps * caps,
    gsize * size)
{
  gboolean res = FALSE;
  GstBaseTransformClass *bclass;
  GstBaseTransformPrivate *priv = trans->priv;

  /* see if we have the result cached */
  if (priv->cache_caps1 == caps) {
    *size = priv->cache_caps1_size;
    GST_DEBUG_OBJECT (trans,
        "returned %" G_GSIZE_FORMAT " from first cache", *size);
    return TRUE;
  }
  if (priv->cache_caps2 == caps) {
    *size = priv->cache_caps2_size;
    GST_DEBUG_OBJECT (trans,
        "returned %" G_GSIZE_FORMAT " from second cached", *size);
    return TRUE;
  }

  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);
  res = bclass->get_unit_size (trans, caps, size);
  GST_DEBUG_OBJECT (trans,
      "caps %" GST_PTR_FORMAT ") has unit size %" G_GSIZE_FORMAT ", res %s",
      caps, *size, res ? "TRUE" : "FALSE");

  if (res) {
    /* and cache the values */
    if (priv->cache_caps1 == NULL) {
      gst_caps_replace (&priv->cache_caps1, caps);
      priv->cache_caps1_size = *size;
      GST_DEBUG_OBJECT (trans,
          "caching %" G_GSIZE_FORMAT " in first cache", *size);
    } else if (priv->cache_caps2 == NULL) {
      gst_caps_replace (&priv->cache_caps2, caps);
      priv->cache_caps2_size = *size;
      GST_DEBUG_OBJECT (trans,
          "caching %" G_GSIZE_FORMAT " in second cache", *size);
    } else {
      GST_DEBUG_OBJECT (trans, "no free spot to cache unit_size");
    }
  }
  return res;
}

static gboolean
gst_base_transform_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstBaseTransform *trans;
  GstBaseTransformClass *bclass;
  gboolean ret = TRUE;

  trans = GST_BASE_TRANSFORM (parent);
  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (bclass->sink_event)
    ret = bclass->sink_event (trans, event);
  else
    gst_event_unref (event);

  return ret;
}

static gboolean
gst_base_transform_sink_eventfunc (GstBaseTransform * trans, GstEvent * event)
{
  gboolean ret = TRUE, forward = TRUE;
  GstBaseTransformPrivate *priv = trans->priv;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
      break;
    case GST_EVENT_FLUSH_STOP:
      GST_OBJECT_LOCK (trans);
      /* reset QoS parameters */
      priv->proportion = 1.0;
      priv->earliest_time = -1;
      priv->discont = FALSE;
      priv->processed = 0;
      priv->dropped = 0;
      GST_OBJECT_UNLOCK (trans);
      /* we need new segment info after the flush. */
      trans->have_segment = FALSE;
      gst_segment_init (&trans->segment, GST_FORMAT_UNDEFINED);
      priv->position_out = GST_CLOCK_TIME_NONE;
      break;
    case GST_EVENT_EOS:
      break;
    case GST_EVENT_TAG:
      break;
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      /* clear any pending reconfigure flag */
      gst_pad_check_reconfigure (trans->srcpad);
      ret = gst_base_transform_setcaps (trans, trans->sinkpad, caps);

      forward = FALSE;
      break;
    }
    case GST_EVENT_SEGMENT:
    {
      gst_event_copy_segment (event, &trans->segment);
      trans->have_segment = TRUE;

      GST_DEBUG_OBJECT (trans, "received SEGMENT %" GST_SEGMENT_FORMAT,
          &trans->segment);
      break;
    }
    default:
      break;
  }

  if (ret && forward)
    ret = gst_pad_push_event (trans->srcpad, event);
  else
    gst_event_unref (event);

  return ret;
}

static gboolean
gst_base_transform_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstBaseTransform *trans;
  GstBaseTransformClass *bclass;
  gboolean ret = TRUE;

  trans = GST_BASE_TRANSFORM (parent);
  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (bclass->src_event)
    ret = bclass->src_event (trans, event);
  else
    gst_event_unref (event);

  return ret;
}

static gboolean
gst_base_transform_src_eventfunc (GstBaseTransform * trans, GstEvent * event)
{
  gboolean ret;

  GST_DEBUG_OBJECT (trans, "handling event %p %" GST_PTR_FORMAT, event, event);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
      break;
    case GST_EVENT_NAVIGATION:
      break;
    case GST_EVENT_QOS:
    {
      gdouble proportion;
      GstClockTimeDiff diff;
      GstClockTime timestamp;

      gst_event_parse_qos (event, NULL, &proportion, &diff, &timestamp);
      gst_base_transform_update_qos (trans, proportion, diff, timestamp);
      break;
    }
    default:
      break;
  }

  ret = gst_pad_push_event (trans->sinkpad, event);

  return ret;
}

/* perform a transform on @inbuf and put the result in @outbuf.
 *
 * This function is common to the push and pull-based operations.
 *
 * This function takes ownership of @inbuf */
static GstFlowReturn
gst_base_transform_handle_buffer (GstBaseTransform * trans, GstBuffer * inbuf,
    GstBuffer ** outbuf)
{
  GstBaseTransformClass *bclass;
  GstBaseTransformPrivate *priv = trans->priv;
  GstFlowReturn ret = GST_FLOW_OK;
  gboolean want_in_place;
  GstClockTime running_time;
  GstClockTime timestamp;
  gboolean reconfigure;

  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  reconfigure = gst_pad_check_reconfigure (trans->srcpad);

  if (G_UNLIKELY (reconfigure)) {
    GstCaps *incaps;

    GST_DEBUG_OBJECT (trans, "we had a pending reconfigure");

    incaps = gst_pad_get_current_caps (trans->sinkpad);
    if (incaps == NULL)
      goto no_reconfigure;

    /* if we need to reconfigure we pretend new caps arrived. This
     * will reconfigure the transform with the new output format. */
    if (!gst_base_transform_setcaps (trans, trans->sinkpad, incaps)) {
      gst_caps_unref (incaps);
      goto not_negotiated;
    }
    gst_caps_unref (incaps);
  }

no_reconfigure:
  if (GST_BUFFER_OFFSET_IS_VALID (inbuf))
    GST_DEBUG_OBJECT (trans,
        "handling buffer %p of size %" G_GSIZE_FORMAT " and offset %"
        G_GUINT64_FORMAT, inbuf, gst_buffer_get_size (inbuf),
        GST_BUFFER_OFFSET (inbuf));
  else
    GST_DEBUG_OBJECT (trans,
        "handling buffer %p of size %" G_GSIZE_FORMAT " and offset NONE", inbuf,
        gst_buffer_get_size (inbuf));

  /* Don't allow buffer handling before negotiation, except in passthrough mode
   * or if the class doesn't implement a set_caps function (in which case it doesn't
   * care about caps)
   */
  if (!priv->negotiated && !priv->passthrough && (bclass->set_caps != NULL))
    goto not_negotiated;

  /* Set discont flag so we can mark the outgoing buffer */
  if (GST_BUFFER_IS_DISCONT (inbuf)) {
    GST_DEBUG_OBJECT (trans, "got DISCONT buffer %p", inbuf);
    priv->discont = TRUE;
  }

  /* can only do QoS if the segment is in TIME */
  if (trans->segment.format != GST_FORMAT_TIME)
    goto no_qos;

  /* QOS is done on the running time of the buffer, get it now */
  timestamp = GST_BUFFER_TIMESTAMP (inbuf);
  running_time = gst_segment_to_running_time (&trans->segment, GST_FORMAT_TIME,
      timestamp);

  if (running_time != -1) {
    gboolean need_skip;
    GstClockTime earliest_time;
    gdouble proportion;

    /* lock for getting the QoS parameters that are set (in a different thread)
     * with the QOS events */
    GST_OBJECT_LOCK (trans);
    earliest_time = priv->earliest_time;
    proportion = priv->proportion;
    /* check for QoS, don't perform conversion for buffers
     * that are known to be late. */
    need_skip = priv->qos_enabled &&
        earliest_time != -1 && running_time <= earliest_time;
    GST_OBJECT_UNLOCK (trans);

    if (need_skip) {
      GstMessage *qos_msg;
      GstClockTime duration;
      guint64 stream_time;
      gint64 jitter;

      GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, trans, "skipping transform: qostime %"
          GST_TIME_FORMAT " <= %" GST_TIME_FORMAT,
          GST_TIME_ARGS (running_time), GST_TIME_ARGS (earliest_time));

      priv->dropped++;

      duration = GST_BUFFER_DURATION (inbuf);
      stream_time =
          gst_segment_to_stream_time (&trans->segment, GST_FORMAT_TIME,
          timestamp);
      jitter = GST_CLOCK_DIFF (running_time, earliest_time);

      qos_msg =
          gst_message_new_qos (GST_OBJECT_CAST (trans), FALSE, running_time,
          stream_time, timestamp, duration);
      gst_message_set_qos_values (qos_msg, jitter, proportion, 1000000);
      gst_message_set_qos_stats (qos_msg, GST_FORMAT_BUFFERS,
          priv->processed, priv->dropped);
      gst_element_post_message (GST_ELEMENT_CAST (trans), qos_msg);

      /* mark discont for next buffer */
      priv->discont = TRUE;
      goto skip;
    }
  }

no_qos:

  /* first try to allocate an output buffer based on the currently negotiated
   * format. outbuf will contain a buffer suitable for doing the configured
   * transform after this function. */
  if (bclass->prepare_output_buffer == NULL)
    goto no_prepare;

  GST_DEBUG_OBJECT (trans, "calling prepare buffer");
  ret = bclass->prepare_output_buffer (trans, inbuf, outbuf);

  if (ret != GST_FLOW_OK || *outbuf == NULL)
    goto no_buffer;

  GST_DEBUG_OBJECT (trans, "using allocated buffer in %p, out %p", inbuf,
      *outbuf);

  /* now perform the needed transform */
  if (priv->passthrough) {
    /* In passthrough mode, give transform_ip a look at the
     * buffer, without making it writable, or just push the
     * data through */
    if (bclass->transform_ip_on_passthrough && bclass->transform_ip) {
      GST_DEBUG_OBJECT (trans, "doing passthrough transform_ip");
      ret = bclass->transform_ip (trans, *outbuf);
    } else {
      GST_DEBUG_OBJECT (trans, "element is in passthrough");
    }
  } else {
    want_in_place = (bclass->transform_ip != NULL) && priv->always_in_place;

    if (want_in_place) {
      GST_DEBUG_OBJECT (trans, "doing inplace transform");
      ret = bclass->transform_ip (trans, *outbuf);
    } else {
      GST_DEBUG_OBJECT (trans, "doing non-inplace transform");

      if (bclass->transform)
        ret = bclass->transform (trans, inbuf, *outbuf);
      else
        ret = GST_FLOW_NOT_SUPPORTED;
    }
  }

skip:
  /* only unref input buffer if we allocated a new outbuf buffer. If we reused
   * the input buffer, no refcount is changed to keep the input buffer writable
   * when needed. */
  if (*outbuf != inbuf)
    gst_buffer_unref (inbuf);

  return ret;

  /* ERRORS */
not_negotiated:
  {
    gst_buffer_unref (inbuf);
    *outbuf = NULL;
    GST_ELEMENT_WARNING (trans, STREAM, FORMAT,
        ("not negotiated"), ("not negotiated"));
    return GST_FLOW_NOT_NEGOTIATED;
  }
no_prepare:
  {
    gst_buffer_unref (inbuf);
    GST_ELEMENT_ERROR (trans, STREAM, NOT_IMPLEMENTED,
        ("Sub-class has no prepare_output_buffer implementation"), (NULL));
    return GST_FLOW_NOT_SUPPORTED;
  }
no_buffer:
  {
    gst_buffer_unref (inbuf);
    *outbuf = NULL;
    GST_WARNING_OBJECT (trans, "could not get buffer from pool: %s",
        gst_flow_get_name (ret));
    return ret;
  }
}

/* FIXME, getrange is broken, need to pull range from the other
 * end based on the transform_size result.
 */
static GstFlowReturn
gst_base_transform_getrange (GstPad * pad, GstObject * parent, guint64 offset,
    guint length, GstBuffer ** buffer)
{
  GstBaseTransform *trans;
  GstBaseTransformClass *klass;
  GstFlowReturn ret;
  GstBuffer *inbuf = NULL;

  trans = GST_BASE_TRANSFORM (parent);

  ret = gst_pad_pull_range (trans->sinkpad, offset, length, &inbuf);
  if (G_UNLIKELY (ret != GST_FLOW_OK))
    goto pull_error;

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);
  if (klass->before_transform)
    klass->before_transform (trans, inbuf);

  ret = gst_base_transform_handle_buffer (trans, inbuf, buffer);

done:
  return ret;

  /* ERRORS */
pull_error:
  {
    GST_DEBUG_OBJECT (trans, "failed to pull a buffer: %s",
        gst_flow_get_name (ret));
    goto done;
  }
}

static GstFlowReturn
gst_base_transform_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstBaseTransform *trans;
  GstBaseTransformClass *klass;
  GstBaseTransformPrivate *priv;
  GstFlowReturn ret;
  GstClockTime position = GST_CLOCK_TIME_NONE;
  GstClockTime timestamp, duration;
  GstBuffer *outbuf = NULL;

  trans = GST_BASE_TRANSFORM (parent);
  priv = trans->priv;

  timestamp = GST_BUFFER_TIMESTAMP (buffer);
  duration = GST_BUFFER_DURATION (buffer);

  /* calculate end position of the incoming buffer */
  if (timestamp != GST_CLOCK_TIME_NONE) {
    if (duration != GST_CLOCK_TIME_NONE)
      position = timestamp + duration;
    else
      position = timestamp;
  }

  klass = GST_BASE_TRANSFORM_GET_CLASS (trans);
  if (klass->before_transform)
    klass->before_transform (trans, buffer);

  /* protect transform method and concurrent buffer alloc */
  ret = gst_base_transform_handle_buffer (trans, buffer, &outbuf);

  /* outbuf can be NULL, this means a dropped buffer, if we have a buffer but
   * GST_BASE_TRANSFORM_FLOW_DROPPED we will not push either. */
  if (outbuf != NULL) {
    if (ret == GST_FLOW_OK) {
      GstClockTime position_out = GST_CLOCK_TIME_NONE;

      /* Remember last stop position */
      if (position != GST_CLOCK_TIME_NONE &&
          trans->segment.format == GST_FORMAT_TIME)
        trans->segment.position = position;

      if (GST_BUFFER_TIMESTAMP_IS_VALID (outbuf)) {
        position_out = GST_BUFFER_TIMESTAMP (outbuf);
        if (GST_BUFFER_DURATION_IS_VALID (outbuf))
          position_out += GST_BUFFER_DURATION (outbuf);
      } else if (position != GST_CLOCK_TIME_NONE) {
        position_out = position;
      }
      if (position_out != GST_CLOCK_TIME_NONE
          && trans->segment.format == GST_FORMAT_TIME)
        priv->position_out = position_out;

      /* apply DISCONT flag if the buffer is not yet marked as such */
      if (trans->priv->discont) {
        GST_DEBUG_OBJECT (trans, "we have a pending DISCONT");
        if (!GST_BUFFER_IS_DISCONT (outbuf)) {
          GST_DEBUG_OBJECT (trans, "marking DISCONT on output buffer");
          outbuf = gst_buffer_make_writable (outbuf);
          GST_BUFFER_FLAG_SET (outbuf, GST_BUFFER_FLAG_DISCONT);
        }
        priv->discont = FALSE;
      }
      priv->processed++;

      ret = gst_pad_push (trans->srcpad, outbuf);
    } else {
      GST_DEBUG_OBJECT (trans, "we got return %s", gst_flow_get_name (ret));
      gst_buffer_unref (outbuf);
    }
  }

  /* convert internal flow to OK and mark discont for the next buffer. */
  if (ret == GST_BASE_TRANSFORM_FLOW_DROPPED) {
    GST_DEBUG_OBJECT (trans, "dropped a buffer, marking DISCONT");
    priv->discont = TRUE;
    ret = GST_FLOW_OK;
  }

  return ret;
}

static void
gst_base_transform_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstBaseTransform *trans;

  trans = GST_BASE_TRANSFORM (object);

  switch (prop_id) {
    case PROP_QOS:
      gst_base_transform_set_qos_enabled (trans, g_value_get_boolean (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_base_transform_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstBaseTransform *trans;

  trans = GST_BASE_TRANSFORM (object);

  switch (prop_id) {
    case PROP_QOS:
      g_value_set_boolean (value, gst_base_transform_is_qos_enabled (trans));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* not a vmethod of anything, just an internal method */
static gboolean
gst_base_transform_activate (GstBaseTransform * trans, gboolean active)
{
  GstBaseTransformClass *bclass;
  GstBaseTransformPrivate *priv = trans->priv;
  gboolean result = TRUE;

  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  if (active) {
    GstCaps *incaps, *outcaps;

    if (priv->pad_mode == GST_PAD_MODE_NONE && bclass->start)
      result &= bclass->start (trans);

    incaps = gst_pad_get_current_caps (trans->sinkpad);
    outcaps = gst_pad_get_current_caps (trans->srcpad);

    GST_OBJECT_LOCK (trans);
    if (incaps && outcaps)
      priv->have_same_caps =
          gst_caps_is_equal (incaps, outcaps) || priv->passthrough;
    else
      priv->have_same_caps = priv->passthrough;
    GST_DEBUG_OBJECT (trans, "have_same_caps %d", priv->have_same_caps);
    priv->negotiated = FALSE;
    trans->have_segment = FALSE;
    gst_segment_init (&trans->segment, GST_FORMAT_UNDEFINED);
    priv->position_out = GST_CLOCK_TIME_NONE;
    priv->proportion = 1.0;
    priv->earliest_time = -1;
    priv->discont = FALSE;
    priv->processed = 0;
    priv->dropped = 0;
    GST_OBJECT_UNLOCK (trans);

    if (incaps)
      gst_caps_unref (incaps);
    if (outcaps)
      gst_caps_unref (outcaps);
  } else {
    /* We must make sure streaming has finished before resetting things
     * and calling the ::stop vfunc */
    GST_PAD_STREAM_LOCK (trans->sinkpad);
    GST_PAD_STREAM_UNLOCK (trans->sinkpad);

    priv->have_same_caps = FALSE;
    /* We can only reset the passthrough mode if the instance told us to 
       handle it in configure_caps */
    if (bclass->passthrough_on_same_caps) {
      gst_base_transform_set_passthrough (trans, FALSE);
    }
    gst_caps_replace (&priv->cache_caps1, NULL);
    gst_caps_replace (&priv->cache_caps2, NULL);

    if (priv->pad_mode != GST_PAD_MODE_NONE && bclass->stop)
      result &= bclass->stop (trans);

    gst_base_transform_set_allocation (trans, NULL, NULL, NULL, NULL);
  }

  return result;
}

static gboolean
gst_base_transform_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean result = FALSE;
  GstBaseTransform *trans;

  trans = GST_BASE_TRANSFORM (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
    {
      result = gst_base_transform_activate (trans, active);

      if (result)
        trans->priv->pad_mode = active ? GST_PAD_MODE_PUSH : GST_PAD_MODE_NONE;

      break;
    }
    default:
      result = TRUE;
      break;
  }
  return result;
}

static gboolean
gst_base_transform_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean result = FALSE;
  GstBaseTransform *trans;

  trans = GST_BASE_TRANSFORM (parent);

  switch (mode) {
    case GST_PAD_MODE_PULL:
    {
      result =
          gst_pad_activate_mode (trans->sinkpad, GST_PAD_MODE_PULL, active);

      if (result)
        result &= gst_base_transform_activate (trans, active);

      if (result)
        trans->priv->pad_mode = active ? mode : GST_PAD_MODE_NONE;
      break;
    }
    default:
      result = TRUE;
      break;
  }

  return result;
}

/**
 * gst_base_transform_set_passthrough:
 * @trans: the #GstBaseTransform to set
 * @passthrough: boolean indicating passthrough mode.
 *
 * Set passthrough mode for this filter by default. This is mostly
 * useful for filters that do not care about negotiation.
 *
 * Always %TRUE for filters which don't implement either a transform
 * or transform_ip method.
 *
 * MT safe.
 */
void
gst_base_transform_set_passthrough (GstBaseTransform * trans,
    gboolean passthrough)
{
  GstBaseTransformClass *bclass;

  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  GST_OBJECT_LOCK (trans);
  if (passthrough == FALSE) {
    if (bclass->transform_ip || bclass->transform)
      trans->priv->passthrough = FALSE;
  } else {
    trans->priv->passthrough = TRUE;
  }

  GST_DEBUG_OBJECT (trans, "set passthrough %d", trans->priv->passthrough);
  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_is_passthrough:
 * @trans: the #GstBaseTransform to query
 *
 * See if @trans is configured as a passthrough transform.
 *
 * Returns: %TRUE is the transform is configured in passthrough mode.
 *
 * MT safe.
 */
gboolean
gst_base_transform_is_passthrough (GstBaseTransform * trans)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_BASE_TRANSFORM (trans), FALSE);

  GST_OBJECT_LOCK (trans);
  result = trans->priv->passthrough;
  GST_OBJECT_UNLOCK (trans);

  return result;
}

/**
 * gst_base_transform_set_in_place:
 * @trans: the #GstBaseTransform to modify
 * @in_place: Boolean value indicating that we would like to operate
 * on in_place buffers.
 *
 * Determines whether a non-writable buffer will be copied before passing
 * to the transform_ip function.
 * <itemizedlist>
 *   <listitem>Always %TRUE if no transform function is implemented.</listitem>
 *   <listitem>Always %FALSE if ONLY transform function is implemented.</listitem>
 * </itemizedlist>
 *
 * MT safe.
 */
void
gst_base_transform_set_in_place (GstBaseTransform * trans, gboolean in_place)
{
  GstBaseTransformClass *bclass;

  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  bclass = GST_BASE_TRANSFORM_GET_CLASS (trans);

  GST_OBJECT_LOCK (trans);

  if (in_place) {
    if (bclass->transform_ip) {
      GST_DEBUG_OBJECT (trans, "setting in_place TRUE");
      trans->priv->always_in_place = TRUE;
    }
  } else {
    if (bclass->transform) {
      GST_DEBUG_OBJECT (trans, "setting in_place FALSE");
      trans->priv->always_in_place = FALSE;
    }
  }

  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_is_in_place:
 * @trans: the #GstBaseTransform to query
 *
 * See if @trans is configured as a in_place transform.
 *
 * Returns: %TRUE is the transform is configured in in_place mode.
 *
 * MT safe.
 */
gboolean
gst_base_transform_is_in_place (GstBaseTransform * trans)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_BASE_TRANSFORM (trans), FALSE);

  GST_OBJECT_LOCK (trans);
  result = trans->priv->always_in_place;
  GST_OBJECT_UNLOCK (trans);

  return result;
}

/**
 * gst_base_transform_update_qos:
 * @trans: a #GstBaseTransform
 * @proportion: the proportion
 * @diff: the diff against the clock
 * @timestamp: the timestamp of the buffer generating the QoS expressed in
 * running_time.
 *
 * Set the QoS parameters in the transform. This function is called internally
 * when a QOS event is received but subclasses can provide custom information
 * when needed.
 *
 * MT safe.
 */
void
gst_base_transform_update_qos (GstBaseTransform * trans,
    gdouble proportion, GstClockTimeDiff diff, GstClockTime timestamp)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, trans,
      "qos: proportion: %lf, diff %" G_GINT64_FORMAT ", timestamp %"
      GST_TIME_FORMAT, proportion, diff, GST_TIME_ARGS (timestamp));

  GST_OBJECT_LOCK (trans);
  trans->priv->proportion = proportion;
  trans->priv->earliest_time = timestamp + diff;
  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_set_qos_enabled:
 * @trans: a #GstBaseTransform
 * @enabled: new state
 *
 * Enable or disable QoS handling in the transform.
 *
 * MT safe.
 */
void
gst_base_transform_set_qos_enabled (GstBaseTransform * trans, gboolean enabled)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, trans, "enabled: %d", enabled);

  GST_OBJECT_LOCK (trans);
  trans->priv->qos_enabled = enabled;
  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_is_qos_enabled:
 * @trans: a #GstBaseTransform
 *
 * Queries if the transform will handle QoS.
 *
 * Returns: %TRUE if QoS is enabled.
 *
 * MT safe.
 */
gboolean
gst_base_transform_is_qos_enabled (GstBaseTransform * trans)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_BASE_TRANSFORM (trans), FALSE);

  GST_OBJECT_LOCK (trans);
  result = trans->priv->qos_enabled;
  GST_OBJECT_UNLOCK (trans);

  return result;
}

/**
 * gst_base_transform_set_gap_aware:
 * @trans: a #GstBaseTransform
 * @gap_aware: New state
 *
 * If @gap_aware is %FALSE (the default), output buffers will have the
 * %GST_BUFFER_FLAG_GAP flag unset.
 *
 * If set to %TRUE, the element must handle output buffers with this flag set
 * correctly, i.e. it can assume that the buffer contains neutral data but must
 * unset the flag if the output is no neutral data.
 *
 * MT safe.
 */
void
gst_base_transform_set_gap_aware (GstBaseTransform * trans, gboolean gap_aware)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  GST_OBJECT_LOCK (trans);
  trans->priv->gap_aware = gap_aware;
  GST_DEBUG_OBJECT (trans, "set gap aware %d", trans->priv->gap_aware);
  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_set_prefer_passthrough:
 * @trans: a #GstBaseTransform
 * @prefer_passthrough: New state
 *
 * If @prefer_passthrough is %TRUE (the default), @trans will check and
 * prefer passthrough caps from the list of caps returned by the
 * transform_caps vmethod.
 *
 * If set to %FALSE, the element must order the caps returned from the
 * transform_caps function in such a way that the preferred format is
 * first in the list. This can be interesting for transforms that can do
 * passthrough transforms but prefer to do something else, like a
 * capsfilter.
 *
 * MT safe.
 *
 * Since: 1.0.1
 */
void
gst_base_transform_set_prefer_passthrough (GstBaseTransform * trans,
    gboolean prefer_passthrough)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  GST_OBJECT_LOCK (trans);
  trans->priv->prefer_passthrough = prefer_passthrough;
  GST_DEBUG_OBJECT (trans, "prefer passthrough %d", prefer_passthrough);
  GST_OBJECT_UNLOCK (trans);
}

/**
 * gst_base_transform_reconfigure_sink:
 * @trans: a #GstBaseTransform
 *
 * Instructs @trans to request renegotiation upstream. This function is
 * typically called after properties on the transform were set that
 * influence the input format.
 */
void
gst_base_transform_reconfigure_sink (GstBaseTransform * trans)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  /* push the renegotiate event */
  if (!gst_pad_push_event (GST_BASE_TRANSFORM_SINK_PAD (trans),
          gst_event_new_reconfigure ()))
    GST_DEBUG_OBJECT (trans, "Renegotiate event wasn't handled");
}

/**
 * gst_base_transform_reconfigure_src:
 * @trans: a #GstBaseTransform
 *
 * Instructs @trans to renegotiate a new downstream transform on the next
 * buffer. This function is typically called after properties on the transform
 * were set that influence the output format.
 */
void
gst_base_transform_reconfigure_src (GstBaseTransform * trans)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  gst_pad_mark_reconfigure (trans->srcpad);
}

/**
 * gst_base_transform_get_buffer_pool:
 * @trans: a #GstBaseTransform
 *
 * Returns: (transfer full): the instance of the #GstBufferPool used
 * by @trans; free it after use it
 */
GstBufferPool *
gst_base_transform_get_buffer_pool (GstBaseTransform * trans)
{
  g_return_val_if_fail (GST_IS_BASE_TRANSFORM (trans), NULL);

  if (trans->priv->pool)
    return gst_object_ref (trans->priv->pool);

  return NULL;
}

/**
 * gst_base_transform_get_allocator:
 * @trans: a #GstBaseTransform
 * @allocator: (out) (allow-none) (transfer full): the #GstAllocator
 * used
 * @params: (out) (allow-none) (transfer full): the
 * #GstAllocationParams of @allocator
 *
 * Lets #GstBaseTransform sub-classes to know the memory @allocator
 * used by the base class and its @params.
 *
 * Unref the @allocator after use it.
 */
void
gst_base_transform_get_allocator (GstBaseTransform * trans,
    GstAllocator ** allocator, GstAllocationParams * params)
{
  g_return_if_fail (GST_IS_BASE_TRANSFORM (trans));

  if (allocator)
    *allocator = trans->priv->allocator ?
        gst_object_ref (trans->priv->allocator) : NULL;

  if (params)
    *params = trans->priv->params;
}
