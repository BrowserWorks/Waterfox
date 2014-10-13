/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *               2000,2005 Wim Taymans <wim@fluendo.com>
 *
 * gstpushsrc.c:
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
 * SECTION:gstpushsrc
 * @short_description: Base class for push based source elements
 * @see_also: #GstBaseSrc
 *
 * This class is mostly useful for elements that cannot do
 * random access, or at least very slowly. The source usually
 * prefers to push out a fixed size buffer.
 *
 * Subclasses usually operate in a format that is different from the
 * default GST_FORMAT_BYTES format of #GstBaseSrc.
 *
 * Classes extending this base class will usually be scheduled
 * in a push based mode. If the peer accepts to operate without
 * offsets and within the limits of the allowed block size, this
 * class can operate in getrange based mode automatically. To make
 * this possible, the subclass should implement and override the
 * SCHEDULING query.
 *
 * The subclass should extend the methods from the baseclass in
 * addition to the ::create method.
 *
 * Seeking, flushing, scheduling and sync is all handled by this
 * base class.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include "gstpushsrc.h"
#include "gsttypefindhelper.h"

GST_DEBUG_CATEGORY_STATIC (gst_push_src_debug);
#define GST_CAT_DEFAULT gst_push_src_debug

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_push_src_debug, "pushsrc", 0, \
        "pushsrc element");

#define gst_push_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstPushSrc, gst_push_src, GST_TYPE_BASE_SRC, _do_init);

static gboolean gst_push_src_query (GstBaseSrc * src, GstQuery * query);
static GstFlowReturn gst_push_src_create (GstBaseSrc * bsrc, guint64 offset,
    guint length, GstBuffer ** ret);
static GstFlowReturn gst_push_src_alloc (GstBaseSrc * bsrc, guint64 offset,
    guint length, GstBuffer ** ret);
static GstFlowReturn gst_push_src_fill (GstBaseSrc * bsrc, guint64 offset,
    guint length, GstBuffer * ret);

static void
gst_push_src_class_init (GstPushSrcClass * klass)
{
  GstBaseSrcClass *gstbasesrc_class = (GstBaseSrcClass *) klass;

  gstbasesrc_class->create = GST_DEBUG_FUNCPTR (gst_push_src_create);
  gstbasesrc_class->alloc = GST_DEBUG_FUNCPTR (gst_push_src_alloc);
  gstbasesrc_class->fill = GST_DEBUG_FUNCPTR (gst_push_src_fill);
  gstbasesrc_class->query = GST_DEBUG_FUNCPTR (gst_push_src_query);
}

static void
gst_push_src_init (GstPushSrc * pushsrc)
{
  /* nop */
}

static gboolean
gst_push_src_query (GstBaseSrc * src, GstQuery * query)
{
  gboolean ret;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SCHEDULING:
    {
      /* a pushsrc can by default never operate in pull mode override
       * if you want something different. */
      gst_query_set_scheduling (query, GST_SCHEDULING_FLAG_SEQUENTIAL, 1, -1,
          0);
      gst_query_add_scheduling_mode (query, GST_PAD_MODE_PUSH);

      ret = TRUE;
      break;
    }
    default:
      ret = GST_BASE_SRC_CLASS (parent_class)->query (src, query);
      break;
  }
  return ret;
}


static GstFlowReturn
gst_push_src_create (GstBaseSrc * bsrc, guint64 offset, guint length,
    GstBuffer ** ret)
{
  GstFlowReturn fret;
  GstPushSrc *src;
  GstPushSrcClass *pclass;

  src = GST_PUSH_SRC (bsrc);
  pclass = GST_PUSH_SRC_GET_CLASS (src);
  if (pclass->create)
    fret = pclass->create (src, ret);
  else
    fret =
        GST_BASE_SRC_CLASS (parent_class)->create (bsrc, offset, length, ret);

  return fret;
}

static GstFlowReturn
gst_push_src_alloc (GstBaseSrc * bsrc, guint64 offset, guint length,
    GstBuffer ** ret)
{
  GstFlowReturn fret;
  GstPushSrc *src;
  GstPushSrcClass *pclass;

  src = GST_PUSH_SRC (bsrc);
  pclass = GST_PUSH_SRC_GET_CLASS (src);
  if (pclass->alloc)
    fret = pclass->alloc (src, ret);
  else
    fret = GST_BASE_SRC_CLASS (parent_class)->alloc (bsrc, offset, length, ret);

  return fret;
}

static GstFlowReturn
gst_push_src_fill (GstBaseSrc * bsrc, guint64 offset, guint length,
    GstBuffer * ret)
{
  GstFlowReturn fret;
  GstPushSrc *src;
  GstPushSrcClass *pclass;

  src = GST_PUSH_SRC (bsrc);
  pclass = GST_PUSH_SRC_GET_CLASS (src);
  if (pclass->fill)
    fret = pclass->fill (src, ret);
  else
    fret = GST_BASE_SRC_CLASS (parent_class)->fill (bsrc, offset, length, ret);

  return fret;
}
