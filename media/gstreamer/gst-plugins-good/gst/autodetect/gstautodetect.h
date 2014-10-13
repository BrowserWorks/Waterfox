/* GStreamer
 * (c) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
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

#ifndef __GST_AUTO_DETECT_H__
#define __GST_AUTO_DETECT_H__

G_BEGIN_DECLS

GST_DEBUG_CATEGORY_EXTERN (autodetect_debug);
#define GST_CAT_DEFAULT autodetect_debug

#define GST_TYPE_AUTO_DETECT (gst_auto_detect_get_type ())
#define GST_AUTO_DETECT(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_AUTO_DETECT, GstAutoDetect))
#define GST_AUTO_DETECT_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_AUTO_DETECT, GstAutoDetectClass))
#define GST_IS_AUTO_DETECT(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_AUTO_DETECT))
#define GST_IS_AUTO_DETECT_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_AUTO_DETECT))
#define GST_AUTO_DETECT_GET_CLASS(obj) \
  (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_AUTO_DETECT, GstAutoDetectClass))

typedef struct _GstAutoDetect {
  GstBin parent;
  
  /* configuration for subclasses */
  const gchar *media_klass; /* Audio/Video/... */
  GstElementFlags flag; /* GST_ELEMENT_FLAG_{SINK/SOURCE} */

  /* explicit pointers to stuff used */
  GstPad *pad;
  GstCaps *filter_caps;
  gboolean sync;

  /* < private > */ 
  GstElement *kid;
  gboolean has_sync;
  const gchar *type_klass; /* Source/Sink */
  const gchar *media_klass_lc, *type_klass_lc; /* lower case versions */

} GstAutoDetect;

typedef struct _GstAutoDetectClass {
  GstBinClass parent_class;
  
  /*< private >*/
  /* virtual methods for subclasses */
  void (*configure)(GstAutoDetect *self, GstElement *kid);
  GstElement * (*create_fake_element) (GstAutoDetect * autodetect);
} GstAutoDetectClass;

GType   gst_auto_detect_get_type    (void);

G_END_DECLS

#endif /* __GST_AUTO_DETECT_H__ */
