/* GStreamer
 * Copyright (C) 2010 REAL_NAME <EMAIL_ADDRESS>
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

#ifndef _GST_DIRAC_PARSE_H_
#define _GST_DIRAC_PARSE_H_

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>
#include "dirac_parse.h"

G_BEGIN_DECLS

#define GST_TYPE_DIRAC_PARSE   (gst_dirac_parse_get_type())
#define GST_DIRAC_PARSE(obj)   (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_DIRAC_PARSE,GstDiracParse))
#define GST_DIRAC_PARSE_CLASS(klass)   (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_DIRAC_PARSE,GstDiracParseClass))
#define GST_IS_DIRAC_PARSE(obj)   (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_DIRAC_PARSE))
#define GST_IS_DIRAC_PARSE_CLASS(obj)   (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_DIRAC_PARSE))

typedef struct _GstDiracParse GstDiracParse;
typedef struct _GstDiracParseClass GstDiracParseClass;

struct _GstDiracParse
{
  GstBaseParse base_diracparse;

  DiracSequenceHeader sequence_header;

  guint32 frame_number;

  gboolean sent_codec_tag;
};

struct _GstDiracParseClass
{
  GstBaseParseClass base_diracparse_class;
};

GType gst_dirac_parse_get_type (void);

G_END_DECLS

#endif
