/* GStreamer H.263 Parser
 * Copyright (C) <2010> Arun Raghavan <arun.raghavan@collabora.co.uk>
 * Copyright (C) <2010> Edward Hervey <edward.hervey@collabora.co.uk>
 * Copyright (C) <2010> Collabora Multimedia
 * Copyright (C) <2010> Nokia Corporation
 *
 * Some bits C-c,C-v'ed and s/4/3 from h264parse:
 *           (C) 2005 Michal Benes <michal.benes@itonis.tv>
 *           (C) 2008 Wim Taymans <wim.taymans@gmail.com>
 *           (C) 2009 Mark Nauwelaerts <mnauw users sf net>
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

#ifndef __GST_H263_PARSE_H__
#define __GST_H263_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstadapter.h>
#include <gst/base/gstbaseparse.h>

#include "h263parse.h"

G_BEGIN_DECLS

#define GST_TYPE_H263_PARSE \
  (gst_h263_parse_get_type())
#define GST_H263_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_H263_PARSE,GstH263Parse))
#define GST_H263_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_H263_PARSE,GstH263ParseClass))
#define GST_IS_H263_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_H263_PARSE))
#define GST_IS_H263_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_H263_PARSE))

GType gst_h263_parse_get_type (void);

typedef struct _GstH263Parse GstH263Parse;
typedef struct _GstH263ParseClass GstH263ParseClass;

struct _GstH263Parse
{
  GstBaseParse baseparse;

  gint profile, level;
  guint bitrate;

  H263ParseState state;
  gboolean sent_codec_tag;
};

struct _GstH263ParseClass
{
  GstBaseParseClass parent_class;
};

G_END_DECLS
#endif
