/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Andy Wingo <wingo@pobox.com>
 *		      2006 Edward Hervey <bilboed@bilboed.com>
 *
 * gstghostpad.c: Proxy pads
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
 * SECTION:gstghostpad
 * @short_description: Pseudo link pads
 * @see_also: #GstPad
 *
 * GhostPads are useful when organizing pipelines with #GstBin like elements.
 * The idea here is to create hierarchical element graphs. The bin element
 * contains a sub-graph. Now one would like to treat the bin-element like any
 * other #GstElement. This is where GhostPads come into play. A GhostPad acts as
 * a proxy for another pad. Thus the bin can have sink and source ghost-pads
 * that are associated with sink and source pads of the child elements.
 *
 * If the target pad is known at creation time, gst_ghost_pad_new() is the
 * function to use to get a ghost-pad. Otherwise one can use gst_ghost_pad_new_no_target()
 * to create the ghost-pad and use gst_ghost_pad_set_target() to establish the
 * association later on.
 *
 * Note that GhostPads add overhead to the data processing of a pipeline.
 */

#include "gst_private.h"
#include "gstinfo.h"

#include "gstghostpad.h"
#include "gst.h"

#define GST_CAT_DEFAULT GST_CAT_PADS

#define GST_PROXY_PAD_CAST(obj)         ((GstProxyPad *)obj)
#define GST_PROXY_PAD_PRIVATE(obj)      (GST_PROXY_PAD_CAST (obj)->priv)
#define GST_PROXY_PAD_TARGET(pad)       (GST_PAD_PEER (GST_PROXY_PAD_INTERNAL (pad)))
#define GST_PROXY_PAD_INTERNAL(pad)     (GST_PROXY_PAD_PRIVATE (pad)->internal)

#define GST_PROXY_PAD_ACQUIRE_INTERNAL(pad, internal, retval)           \
  internal =                                                            \
      GST_PAD_CAST (gst_proxy_pad_get_internal (GST_PROXY_PAD_CAST (pad))); \
  if (internal == NULL)                                                 \
    return retval;

#define GST_PROXY_PAD_RELEASE_INTERNAL(internal) gst_object_unref (internal);

struct _GstProxyPadPrivate
{
  GstPad *internal;
};

G_DEFINE_TYPE (GstProxyPad, gst_proxy_pad, GST_TYPE_PAD);

static GstPad *gst_proxy_pad_get_target (GstPad * pad);

/**
 * gst_proxy_pad_iterate_internal_links_default:
 * @pad: the #GstPad to get the internal links of.
 * @parent: (allow-none): the parent of @pad or %NULL
 *
 * Invoke the default iterate internal links function of the proxy pad.
 *
 * Returns: (nullable): a #GstIterator of #GstPad, or %NULL if @pad
 * has no parent. Unref each returned pad with gst_object_unref().
 */
GstIterator *
gst_proxy_pad_iterate_internal_links_default (GstPad * pad, GstObject * parent)
{
  GstIterator *res = NULL;
  GstPad *internal;
  GValue v = { 0, };

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), NULL);

  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, internal, NULL);

  g_value_init (&v, GST_TYPE_PAD);
  g_value_take_object (&v, internal);
  res = gst_iterator_new_single (GST_TYPE_PAD, &v);
  g_value_unset (&v);

  return res;
}

/**
 * gst_proxy_pad_chain_default:
 * @pad: a sink #GstPad, returns GST_FLOW_ERROR if not.
 * @parent: (allow-none): the parent of @pad or %NULL
 * @buffer: (transfer full): the #GstBuffer to send, return GST_FLOW_ERROR
 *     if not.
 *
 * Invoke the default chain function of the proxy pad.
 *
 * Returns: a #GstFlowReturn from the pad.
 */
GstFlowReturn
gst_proxy_pad_chain_default (GstPad * pad, GstObject * parent,
    GstBuffer * buffer)
{
  GstFlowReturn res;
  GstPad *internal;

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), GST_FLOW_ERROR);
  g_return_val_if_fail (GST_IS_BUFFER (buffer), GST_FLOW_ERROR);

  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, internal, GST_FLOW_NOT_LINKED);
  res = gst_pad_push (internal, buffer);
  GST_PROXY_PAD_RELEASE_INTERNAL (internal);

  return res;
}

/**
 * gst_proxy_pad_chain_list_default:
 * @pad: a sink #GstPad, returns GST_FLOW_ERROR if not.
 * @parent: (allow-none): the parent of @pad or %NULL
 * @list: (transfer full): the #GstBufferList to send, return GST_FLOW_ERROR
 *     if not.
 *
 * Invoke the default chain list function of the proxy pad.
 *
 * Returns: a #GstFlowReturn from the pad.
 */
GstFlowReturn
gst_proxy_pad_chain_list_default (GstPad * pad, GstObject * parent,
    GstBufferList * list)
{
  GstFlowReturn res;
  GstPad *internal;

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), GST_FLOW_ERROR);
  g_return_val_if_fail (GST_IS_BUFFER_LIST (list), GST_FLOW_ERROR);

  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, internal, GST_FLOW_NOT_LINKED);
  res = gst_pad_push_list (internal, list);
  GST_PROXY_PAD_RELEASE_INTERNAL (internal);

  return res;
}

/**
 * gst_proxy_pad_getrange_default:
 * @pad: a src #GstPad, returns #GST_FLOW_ERROR if not.
 * @parent: the parent of @pad
 * @offset: The start offset of the buffer
 * @size: The length of the buffer
 * @buffer: (out callee-allocates): a pointer to hold the #GstBuffer,
 *     returns #GST_FLOW_ERROR if %NULL.
 *
 * Invoke the default getrange function of the proxy pad.
 *
 * Returns: a #GstFlowReturn from the pad.
 */
GstFlowReturn
gst_proxy_pad_getrange_default (GstPad * pad, GstObject * parent,
    guint64 offset, guint size, GstBuffer ** buffer)
{
  GstFlowReturn res;
  GstPad *internal;

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), GST_FLOW_ERROR);
  g_return_val_if_fail (buffer != NULL, GST_FLOW_ERROR);

  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, internal, GST_FLOW_NOT_LINKED);
  res = gst_pad_pull_range (internal, offset, size, buffer);
  GST_PROXY_PAD_RELEASE_INTERNAL (internal);

  return res;
}

static GstPad *
gst_proxy_pad_get_target (GstPad * pad)
{
  GstPad *target;

  GST_OBJECT_LOCK (pad);
  target = gst_pad_get_peer (GST_PROXY_PAD_INTERNAL (pad));
  GST_OBJECT_UNLOCK (pad);

  return target;
}

/**
 * gst_proxy_pad_get_internal:
 * @pad: the #GstProxyPad
 *
 * Get the internal pad of @pad. Unref target pad after usage.
 *
 * The internal pad of a #GstGhostPad is the internally used
 * pad of opposite direction, which is used to link to the target.
 *
 * Returns: (transfer full) (nullable): the target #GstProxyPad, can
 * be %NULL.  Unref target pad after usage.
 */
GstProxyPad *
gst_proxy_pad_get_internal (GstProxyPad * pad)
{
  GstPad *internal;

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), NULL);

  GST_OBJECT_LOCK (pad);
  internal = GST_PROXY_PAD_INTERNAL (pad);
  if (internal)
    gst_object_ref (internal);
  GST_OBJECT_UNLOCK (pad);

  return GST_PROXY_PAD_CAST (internal);
}

static void
gst_proxy_pad_class_init (GstProxyPadClass * klass)
{
  g_type_class_add_private (klass, sizeof (GstProxyPadPrivate));

  /* Register common function pointer descriptions */
  GST_DEBUG_REGISTER_FUNCPTR (gst_proxy_pad_iterate_internal_links_default);
  GST_DEBUG_REGISTER_FUNCPTR (gst_proxy_pad_chain_default);
  GST_DEBUG_REGISTER_FUNCPTR (gst_proxy_pad_chain_list_default);
  GST_DEBUG_REGISTER_FUNCPTR (gst_proxy_pad_getrange_default);
}

static void
gst_proxy_pad_init (GstProxyPad * ppad)
{
  GstPad *pad = (GstPad *) ppad;

  GST_PROXY_PAD_PRIVATE (ppad) = G_TYPE_INSTANCE_GET_PRIVATE (ppad,
      GST_TYPE_PROXY_PAD, GstProxyPadPrivate);

  gst_pad_set_iterate_internal_links_function (pad,
      gst_proxy_pad_iterate_internal_links_default);

  GST_PAD_SET_PROXY_CAPS (pad);
  GST_PAD_SET_PROXY_SCHEDULING (pad);
  GST_PAD_SET_PROXY_ALLOCATION (pad);
}


/***********************************************************************
 * Ghost pads, implemented as a pair of proxy pads (sort of)
 */


#define GST_GHOST_PAD_PRIVATE(obj)	(GST_GHOST_PAD_CAST (obj)->priv)

struct _GstGhostPadPrivate
{
  /* with PROXY_LOCK */
  gboolean constructed;
};

G_DEFINE_TYPE (GstGhostPad, gst_ghost_pad, GST_TYPE_PROXY_PAD);

static void gst_ghost_pad_dispose (GObject * object);

static gboolean
gst_ghost_pad_internal_activate_push_default (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean ret;
  GstPad *other;

  GST_LOG_OBJECT (pad, "%sactivate push on %s:%s, we're ok",
      (active ? "" : "de"), GST_DEBUG_PAD_NAME (pad));

  /* in both cases (SRC and SINK) we activate just the internal pad. The targets
   * will be activated later (or already in case of a ghost sinkpad). */
  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, other, FALSE);
  ret = gst_pad_activate_mode (other, GST_PAD_MODE_PUSH, active);
  GST_PROXY_PAD_RELEASE_INTERNAL (other);

  return ret;
}

static gboolean
gst_ghost_pad_internal_activate_pull_default (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean ret;
  GstPad *other;

  GST_LOG_OBJECT (pad, "%sactivate pull on %s:%s", (active ? "" : "de"),
      GST_DEBUG_PAD_NAME (pad));

  if (GST_PAD_DIRECTION (pad) == GST_PAD_SRC) {
    /* we are activated in pull mode by our peer element, which is a sinkpad
     * that wants to operate in pull mode. This activation has to propagate
     * upstream through the pipeline. We call the internal activation function,
     * which will trigger gst_ghost_pad_activate_pull_default, which propagates even
     * further upstream */
    GST_LOG_OBJECT (pad, "pad is src, activate internal");
    GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, other, FALSE);
    ret = gst_pad_activate_mode (other, GST_PAD_MODE_PULL, active);
    GST_PROXY_PAD_RELEASE_INTERNAL (other);
  } else if (G_LIKELY ((other = gst_pad_get_peer (pad)))) {
    /* We are SINK, the ghostpad is SRC, we propagate the activation upstream
     * since we hold a pointer to the upstream peer. */
    GST_LOG_OBJECT (pad, "activating peer");
    ret = gst_pad_activate_mode (other, GST_PAD_MODE_PULL, active);
    gst_object_unref (other);
  } else {
    /* this is failure, we can't activate pull if there is no peer */
    GST_LOG_OBJECT (pad, "not src and no peer, failing");
    ret = FALSE;
  }

  return ret;
}

/**
 * gst_ghost_pad_internal_activate_mode_default:
 * @pad: the #GstPad to activate or deactivate.
 * @parent: (allow-none): the parent of @pad or %NULL
 * @mode: the requested activation mode
 * @active: whether the pad should be active or not.
 *
 * Invoke the default activate mode function of a proxy pad that is
 * owned by a ghost pad.
 *
 * Returns: %TRUE if the operation was successful.
 */
gboolean
gst_ghost_pad_internal_activate_mode_default (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_PROXY_PAD (pad), FALSE);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_ghost_pad_internal_activate_pull_default (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      res = gst_ghost_pad_internal_activate_push_default (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}

static gboolean
gst_ghost_pad_activate_push_default (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean ret;
  GstPad *other;

  g_return_val_if_fail (GST_IS_GHOST_PAD (pad), FALSE);

  GST_LOG_OBJECT (pad, "%sactivate push on %s:%s, proxy internal",
      (active ? "" : "de"), GST_DEBUG_PAD_NAME (pad));

  /* just activate the internal pad */
  GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, other, FALSE);
  ret = gst_pad_activate_mode (other, GST_PAD_MODE_PUSH, active);
  GST_PROXY_PAD_RELEASE_INTERNAL (other);

  return ret;
}

static gboolean
gst_ghost_pad_activate_pull_default (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean ret;
  GstPad *other;

  GST_LOG_OBJECT (pad, "%sactivate pull on %s:%s", (active ? "" : "de"),
      GST_DEBUG_PAD_NAME (pad));

  if (GST_PAD_DIRECTION (pad) == GST_PAD_SRC) {
    /* the ghostpad is SRC and activated in pull mode by its peer, call the
     * activation function of the internal pad to propagate the activation
     * upstream */
    GST_LOG_OBJECT (pad, "pad is src, activate internal");
    GST_PROXY_PAD_ACQUIRE_INTERNAL (pad, other, FALSE);
    ret = gst_pad_activate_mode (other, GST_PAD_MODE_PULL, active);
    GST_PROXY_PAD_RELEASE_INTERNAL (other);
  } else if (G_LIKELY ((other = gst_pad_get_peer (pad)))) {
    /* We are SINK and activated by the internal pad, propagate activation
     * upstream because we hold a ref to the upstream peer */
    GST_LOG_OBJECT (pad, "activating peer");
    ret = gst_pad_activate_mode (other, GST_PAD_MODE_PULL, active);
    gst_object_unref (other);
  } else {
    /* no peer, we fail */
    GST_LOG_OBJECT (pad, "pad not src and no peer, failing");
    ret = FALSE;
  }

  return ret;
}

/**
 * gst_ghost_pad_activate_mode_default:
 * @pad: the #GstPad to activate or deactivate.
 * @parent: (allow-none): the parent of @pad or %NULL
 * @mode: the requested activation mode
 * @active: whether the pad should be active or not.
 *
 * Invoke the default activate mode function of a ghost pad.
 *
 * Returns: %TRUE if the operation was successful.
 */
gboolean
gst_ghost_pad_activate_mode_default (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_GHOST_PAD (pad), FALSE);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_ghost_pad_activate_pull_default (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      res = gst_ghost_pad_activate_push_default (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}

static void
gst_ghost_pad_class_init (GstGhostPadClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  g_type_class_add_private (klass, sizeof (GstGhostPadPrivate));

  gobject_class->dispose = gst_ghost_pad_dispose;

  GST_DEBUG_REGISTER_FUNCPTR (gst_ghost_pad_activate_pull_default);
  GST_DEBUG_REGISTER_FUNCPTR (gst_ghost_pad_activate_push_default);
}

static void
gst_ghost_pad_init (GstGhostPad * pad)
{
  GST_GHOST_PAD_PRIVATE (pad) = G_TYPE_INSTANCE_GET_PRIVATE (pad,
      GST_TYPE_GHOST_PAD, GstGhostPadPrivate);

  gst_pad_set_activatemode_function (GST_PAD_CAST (pad),
      gst_ghost_pad_activate_mode_default);
}

static void
gst_ghost_pad_dispose (GObject * object)
{
  GstPad *pad;
  GstPad *internal;
  GstPad *peer;

  pad = GST_PAD (object);

  GST_DEBUG_OBJECT (pad, "dispose");

  gst_ghost_pad_set_target (GST_GHOST_PAD (pad), NULL);

  /* Unlink here so that gst_pad_dispose doesn't. That would lead to a call to
   * gst_ghost_pad_unlink_default when the ghost pad is in an inconsistent state */
  peer = gst_pad_get_peer (pad);
  if (peer) {
    if (GST_PAD_IS_SRC (pad))
      gst_pad_unlink (pad, peer);
    else
      gst_pad_unlink (peer, pad);

    gst_object_unref (peer);
  }

  GST_OBJECT_LOCK (pad);
  internal = GST_PROXY_PAD_INTERNAL (pad);

  gst_pad_set_activatemode_function (internal, NULL);

  /* disposes of the internal pad, since the ghostpad is the only possible object
   * that has a refcount on the internal pad. */
  gst_object_unparent (GST_OBJECT_CAST (internal));
  GST_PROXY_PAD_INTERNAL (pad) = NULL;

  GST_OBJECT_UNLOCK (pad);

  G_OBJECT_CLASS (gst_ghost_pad_parent_class)->dispose (object);
}

/**
 * gst_ghost_pad_construct:
 * @gpad: the newly allocated ghost pad
 *
 * Finish initialization of a newly allocated ghost pad.
 *
 * This function is most useful in language bindings and when subclassing
 * #GstGhostPad; plugin and application developers normally will not call this
 * function. Call this function directly after a call to g_object_new
 * (GST_TYPE_GHOST_PAD, "direction", @dir, ..., NULL).
 *
 * Returns: %TRUE if the construction succeeds, %FALSE otherwise.
 */
gboolean
gst_ghost_pad_construct (GstGhostPad * gpad)
{
  GstPadDirection dir, otherdir;
  GstPadTemplate *templ;
  GstPad *pad, *internal;

  g_return_val_if_fail (GST_IS_GHOST_PAD (gpad), FALSE);
  g_return_val_if_fail (GST_GHOST_PAD_PRIVATE (gpad)->constructed == FALSE,
      FALSE);

  g_object_get (gpad, "direction", &dir, "template", &templ, NULL);

  g_return_val_if_fail (dir != GST_PAD_UNKNOWN, FALSE);

  pad = GST_PAD (gpad);

  /* Set directional padfunctions for ghostpad */
  if (dir == GST_PAD_SINK) {
    gst_pad_set_chain_function (pad, gst_proxy_pad_chain_default);
    gst_pad_set_chain_list_function (pad, gst_proxy_pad_chain_list_default);
  } else {
    gst_pad_set_getrange_function (pad, gst_proxy_pad_getrange_default);
  }

  /* INTERNAL PAD, it always exists and is child of the ghostpad */
  otherdir = (dir == GST_PAD_SRC) ? GST_PAD_SINK : GST_PAD_SRC;
  if (templ) {
    internal =
        g_object_new (GST_TYPE_PROXY_PAD, "name", NULL,
        "direction", otherdir, "template", templ, NULL);
    /* release ref obtained via g_object_get */
    gst_object_unref (templ);
  } else {
    internal =
        g_object_new (GST_TYPE_PROXY_PAD, "name", NULL,
        "direction", otherdir, NULL);
  }
  GST_PAD_UNSET_FLUSHING (internal);

  /* Set directional padfunctions for internal pad */
  if (dir == GST_PAD_SRC) {
    gst_pad_set_chain_function (internal, gst_proxy_pad_chain_default);
    gst_pad_set_chain_list_function (internal,
        gst_proxy_pad_chain_list_default);
  } else {
    gst_pad_set_getrange_function (internal, gst_proxy_pad_getrange_default);
  }

  GST_OBJECT_LOCK (pad);

  /* now make the ghostpad a parent of the internal pad */
  if (!gst_object_set_parent (GST_OBJECT_CAST (internal),
          GST_OBJECT_CAST (pad)))
    goto parent_failed;

  /* The ghostpad is the parent of the internal pad and is the only object that
   * can have a refcount on the internal pad.
   * At this point, the GstGhostPad has a refcount of 1, and the internal pad has
   * a refcount of 1.
   * When the refcount of the GstGhostPad drops to 0, the ghostpad will dispose
   * its refcount on the internal pad in the dispose method by un-parenting it.
   * This is why we don't take extra refcounts in the assignments below
   */
  GST_PROXY_PAD_INTERNAL (pad) = internal;
  GST_PROXY_PAD_INTERNAL (internal) = pad;

  /* special activation functions for the internal pad */
  gst_pad_set_activatemode_function (internal,
      gst_ghost_pad_internal_activate_mode_default);

  GST_OBJECT_UNLOCK (pad);

  GST_GHOST_PAD_PRIVATE (gpad)->constructed = TRUE;
  return TRUE;

  /* ERRORS */
parent_failed:
  {
    GST_WARNING_OBJECT (gpad, "Could not set internal pad %s:%s",
        GST_DEBUG_PAD_NAME (internal));
    g_critical ("Could not set internal pad %s:%s",
        GST_DEBUG_PAD_NAME (internal));
    GST_OBJECT_UNLOCK (pad);
    gst_object_unref (internal);
    return FALSE;
  }
}

static GstPad *
gst_ghost_pad_new_full (const gchar * name, GstPadDirection dir,
    GstPadTemplate * templ)
{
  GstGhostPad *ret;

  g_return_val_if_fail (dir != GST_PAD_UNKNOWN, NULL);

  /* OBJECT CREATION */
  if (templ) {
    ret = g_object_new (GST_TYPE_GHOST_PAD, "name", name,
        "direction", dir, "template", templ, NULL);
  } else {
    ret = g_object_new (GST_TYPE_GHOST_PAD, "name", name,
        "direction", dir, NULL);
  }

  if (!gst_ghost_pad_construct (ret))
    goto construct_failed;

  return GST_PAD_CAST (ret);

construct_failed:
  /* already logged */
  gst_object_unref (ret);
  return NULL;
}

/**
 * gst_ghost_pad_new_no_target:
 * @name: (allow-none): the name of the new pad, or %NULL to assign a default name.
 * @dir: the direction of the ghostpad
 *
 * Create a new ghostpad without a target with the given direction.
 * A target can be set on the ghostpad later with the
 * gst_ghost_pad_set_target() function.
 *
 * The created ghostpad will not have a padtemplate.
 *
 * Returns: (transfer full) (nullable): a new #GstPad, or %NULL in
 * case of an error.
 */
GstPad *
gst_ghost_pad_new_no_target (const gchar * name, GstPadDirection dir)
{
  GstPad *ret;

  g_return_val_if_fail (dir != GST_PAD_UNKNOWN, NULL);

  GST_LOG ("name:%s, direction:%d", GST_STR_NULL (name), dir);

  ret = gst_ghost_pad_new_full (name, dir, NULL);

  return ret;
}

/**
 * gst_ghost_pad_new:
 * @name: (allow-none): the name of the new pad, or %NULL to assign a default name
 * @target: (transfer none): the pad to ghost.
 *
 * Create a new ghostpad with @target as the target. The direction will be taken
 * from the target pad. @target must be unlinked.
 *
 * Will ref the target.
 *
 * Returns: (transfer floating) (nullable): a new #GstPad, or %NULL in
 * case of an error.
 */
GstPad *
gst_ghost_pad_new (const gchar * name, GstPad * target)
{
  GstPad *ret;

  g_return_val_if_fail (GST_IS_PAD (target), NULL);
  g_return_val_if_fail (!gst_pad_is_linked (target), NULL);

  GST_LOG ("name:%s, target:%s:%s", GST_STR_NULL (name),
      GST_DEBUG_PAD_NAME (target));

  if ((ret = gst_ghost_pad_new_no_target (name, GST_PAD_DIRECTION (target))))
    if (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (ret), target))
      goto set_target_failed;

  return ret;

  /* ERRORS */
set_target_failed:
  {
    GST_WARNING_OBJECT (ret, "failed to set target %s:%s",
        GST_DEBUG_PAD_NAME (target));
    gst_object_unref (ret);
    return NULL;
  }
}

/**
 * gst_ghost_pad_new_from_template:
 * @name: (allow-none): the name of the new pad, or %NULL to assign a default name.
 * @target: (transfer none): the pad to ghost.
 * @templ: (transfer none): the #GstPadTemplate to use on the ghostpad.
 *
 * Create a new ghostpad with @target as the target. The direction will be taken
 * from the target pad. The template used on the ghostpad will be @template.
 *
 * Will ref the target.
 *
 * Returns: (transfer full) (nullable): a new #GstPad, or %NULL in
 * case of an error.
 */

GstPad *
gst_ghost_pad_new_from_template (const gchar * name, GstPad * target,
    GstPadTemplate * templ)
{
  GstPad *ret;

  g_return_val_if_fail (GST_IS_PAD (target), NULL);
  g_return_val_if_fail (!gst_pad_is_linked (target), NULL);
  g_return_val_if_fail (templ != NULL, NULL);
  g_return_val_if_fail (GST_PAD_TEMPLATE_DIRECTION (templ) ==
      GST_PAD_DIRECTION (target), NULL);

  GST_LOG ("name:%s, target:%s:%s, templ:%p", GST_STR_NULL (name),
      GST_DEBUG_PAD_NAME (target), templ);

  if ((ret = gst_ghost_pad_new_full (name, GST_PAD_DIRECTION (target), templ)))
    if (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (ret), target))
      goto set_target_failed;

  return ret;

  /* ERRORS */
set_target_failed:
  {
    GST_WARNING_OBJECT (ret, "failed to set target %s:%s",
        GST_DEBUG_PAD_NAME (target));
    gst_object_unref (ret);
    return NULL;
  }
}

/**
 * gst_ghost_pad_new_no_target_from_template:
 * @name: (allow-none): the name of the new pad, or %NULL to assign a default name
 * @templ: (transfer none): the #GstPadTemplate to create the ghostpad from.
 *
 * Create a new ghostpad based on @templ, without setting a target. The
 * direction will be taken from the @templ.
 *
 * Returns: (transfer full) (nullable): a new #GstPad, or %NULL in
 * case of an error.
 */
GstPad *
gst_ghost_pad_new_no_target_from_template (const gchar * name,
    GstPadTemplate * templ)
{
  GstPad *ret;

  g_return_val_if_fail (templ != NULL, NULL);

  ret =
      gst_ghost_pad_new_full (name, GST_PAD_TEMPLATE_DIRECTION (templ), templ);

  return ret;
}

/**
 * gst_ghost_pad_get_target:
 * @gpad: the #GstGhostPad
 *
 * Get the target pad of @gpad. Unref target pad after usage.
 *
 * Returns: (transfer full) (nullable): the target #GstPad, can be
 * %NULL if the ghostpad has no target set. Unref target pad after
 * usage.
 */
GstPad *
gst_ghost_pad_get_target (GstGhostPad * gpad)
{
  GstPad *ret;

  g_return_val_if_fail (GST_IS_GHOST_PAD (gpad), NULL);

  ret = gst_proxy_pad_get_target (GST_PAD_CAST (gpad));

  GST_DEBUG_OBJECT (gpad, "get target %s:%s", GST_DEBUG_PAD_NAME (ret));

  return ret;
}

/**
 * gst_ghost_pad_set_target:
 * @gpad: the #GstGhostPad
 * @newtarget: (transfer none) (allow-none): the new pad target
 *
 * Set the new target of the ghostpad @gpad. Any existing target
 * is unlinked and links to the new target are established. if @newtarget is
 * %NULL the target will be cleared.
 *
 * Returns: (transfer full): %TRUE if the new target could be set. This function
 *     can return %FALSE when the internal pads could not be linked.
 */
gboolean
gst_ghost_pad_set_target (GstGhostPad * gpad, GstPad * newtarget)
{
  GstPad *internal;
  GstPad *oldtarget;
  GstPadLinkReturn lret;

  g_return_val_if_fail (GST_IS_GHOST_PAD (gpad), FALSE);
  g_return_val_if_fail (GST_PAD_CAST (gpad) != newtarget, FALSE);
  g_return_val_if_fail (newtarget != GST_PROXY_PAD_INTERNAL (gpad), FALSE);

  GST_OBJECT_LOCK (gpad);
  internal = GST_PROXY_PAD_INTERNAL (gpad);

  if (newtarget)
    GST_DEBUG_OBJECT (gpad, "set target %s:%s", GST_DEBUG_PAD_NAME (newtarget));
  else
    GST_DEBUG_OBJECT (gpad, "clearing target");

  /* clear old target */
  if ((oldtarget = gst_pad_get_peer (internal))) {
    GST_OBJECT_UNLOCK (gpad);

    /* unlink internal pad */
    if (GST_PAD_IS_SRC (internal))
      gst_pad_unlink (internal, oldtarget);
    else
      gst_pad_unlink (oldtarget, internal);

    gst_object_unref (oldtarget);
  } else {
    GST_OBJECT_UNLOCK (gpad);
  }

  if (newtarget) {
    /* and link to internal pad without any checks */
    GST_DEBUG_OBJECT (gpad, "connecting internal pad to target %"
        GST_PTR_FORMAT, newtarget);

    if (GST_PAD_IS_SRC (internal))
      lret =
          gst_pad_link_full (internal, newtarget, GST_PAD_LINK_CHECK_NOTHING);
    else
      lret =
          gst_pad_link_full (newtarget, internal, GST_PAD_LINK_CHECK_NOTHING);

    if (lret != GST_PAD_LINK_OK)
      goto link_failed;
  }

  return TRUE;

  /* ERRORS */
link_failed:
  {
    GST_WARNING_OBJECT (gpad, "could not link internal and target, reason:%s",
        gst_pad_link_get_name (lret));
    return FALSE;
  }
}
