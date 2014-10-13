/* GStreamer
 * (c) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
 * (c) 2008 Stefan Kost <ensonic@users.sf.net>
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

#ifndef __GST_AUTO_AUDIO_SRC_H__
#define __GST_AUTO_AUDIO_SRC_H__

#include <gst/gst.h>
#include "gstautodetect.h"

G_BEGIN_DECLS

#define GST_TYPE_AUTO_AUDIO_SRC \
  (gst_auto_audio_src_get_type ())
#define GST_AUTO_AUDIO_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_AUTO_AUDIO_SRC, \
                               GstAutoAudioSrc))
#define GST_AUTO_AUDIO_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_AUTO_AUDIO_SRC, \
                            GstAutoAudioSrcClass))
#define GST_IS_AUTO_AUDIO_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_AUTO_AUDIO_SRC))
#define GST_IS_AUTO_AUDIO_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_AUTO_AUDIO_SRC))

typedef struct _GstAutoAudioSrc {
  GstAutoDetect parent;
} GstAutoAudioSrc;

typedef struct _GstAutoAudioSrcClass {
  GstAutoDetectClass parent_class;
} GstAutoAudioSrcClass;

GType   gst_auto_audio_src_get_type    (void);

G_END_DECLS

#endif /* __GST_AUTO_AUDIO_SRC_H__ */
