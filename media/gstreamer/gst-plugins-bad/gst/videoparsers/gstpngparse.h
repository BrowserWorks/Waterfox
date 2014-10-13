/* GStreamer PNG Parser
 * Copyright (C) <2013> Collabora Ltd
 *  @author Olivier Crete <olivier.crete@collabora.com>
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

#ifndef __GST_PNG_PARSE_H__
#define __GST_PNG_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstadapter.h>
#include <gst/base/gstbaseparse.h>

G_BEGIN_DECLS

#define GST_TYPE_PNG_PARSE \
  (gst_png_parse_get_type())
#define GST_PNG_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_PNG_PARSE,GstPngParse))
#define GST_PNG_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_PNG_PARSE,GstPngParseClass))
#define GST_IS_PNG_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_PNG_PARSE))
#define GST_IS_PNG_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_PNG_PARSE))

GType gst_png_parse_get_type (void);

typedef struct _GstPngParse GstPngParse;
typedef struct _GstPngParseClass GstPngParseClass;

struct _GstPngParse
{
  GstBaseParse baseparse;

  guint width;
  guint height;
  
  gboolean sent_codec_tag;
};

struct _GstPngParseClass
{
  GstBaseParseClass parent_class;
};

G_END_DECLS

#endif
