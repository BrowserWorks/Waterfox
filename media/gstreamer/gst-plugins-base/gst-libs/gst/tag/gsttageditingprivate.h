/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
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


#ifndef __GST_TAG_EDIT_PRIVATE_H__
#define __GST_TAG_EDIT_PRIVATE_H__

#include <gst/tag/tag.h>

G_BEGIN_DECLS
  

typedef struct _GstTagEntryMatch GstTagEntryMatch;
struct _GstTagEntryMatch {
  const gchar * gstreamer_tag;
  const gchar * original_tag;
};


GType gst_vorbis_tag_get_type (void);

gint __exif_tag_image_orientation_to_exif_value (const gchar * str);
const gchar * __exif_tag_image_orientation_from_exif_value (gint value);

gint __exif_tag_capturing_exposure_program_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_exposure_program_from_exif_value (gint value);

gint __exif_tag_capturing_exposure_mode_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_exposure_mode_from_exif_value (gint value);

gint __exif_tag_capturing_scene_capture_type_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_scene_capture_type_from_exif_value (gint value);

gint __exif_tag_capturing_gain_adjustment_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_gain_adjustment_from_exif_value (gint value);

gint __exif_tag_capturing_white_balance_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_white_balance_from_exif_value (gint value);

gint __exif_tag_capturing_contrast_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_contrast_from_exif_value (gint value);

gint __exif_tag_capturing_saturation_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_saturation_from_exif_value (gint value);

gint __exif_tag_capturing_sharpness_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_sharpness_from_exif_value (gint value);

gint __exif_tag_capturing_metering_mode_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_metering_mode_from_exif_value (gint value);

gint __exif_tag_capturing_source_to_exif_value (const gchar * str);
const gchar * __exif_tag_capturing_source_from_exif_value (gint value);

#define ensure_exif_tags gst_tag_register_musicbrainz_tags

G_END_DECLS

#endif /* __GST_TAG_EDIT_PRIVATE_H__ */
