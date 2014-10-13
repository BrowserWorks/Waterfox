/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
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
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef __GST_QT_MOOV_RECOVER_H__
#define __GST_QT_MOOV_RECOVER_H__

#include <gst/gst.h>

#include "atoms.h"
#include "atomsrecovery.h"

G_BEGIN_DECLS

#define GST_TYPE_QT_MOOV_RECOVER (gst_qt_moov_recover_get_type())
#define GST_QT_MOOV_RECOVER(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_QT_MOOV_RECOVER, GstQTMoovRecover))
#define GST_QT_MOOV_RECOVER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_QT_MOOV_RECOVER, GstQTMoovRecover))
#define GST_IS_QT_MOOV_RECOVER(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_QT_MOOV_RECOVER))
#define GST_IS_QT_MOOV_RECOVER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_QT_MOOV_RECOVER))
#define GST_QT_MOOV_RECOVER_CAST(obj) ((GstQTMoovRecover*)(obj))


typedef struct _GstQTMoovRecover GstQTMoovRecover;
typedef struct _GstQTMoovRecoverClass GstQTMoovRecoverClass;

struct _GstQTMoovRecover
{
  GstPipeline pipeline;

  GstTask *task;
  GRecMutex task_mutex;

  /* properties */
  gboolean  faststart_mode;
  gchar    *recovery_input;
  gchar    *fixed_output;
  gchar    *broken_input;
};

struct _GstQTMoovRecoverClass
{
  GstPipelineClass parent_class;
};

GType gst_qt_moov_recover_get_type (void);
gboolean gst_qt_moov_recover_register (GstPlugin * plugin);

G_END_DECLS

#endif /* __GST_QT_MOOV_RECOVER_H__ */
