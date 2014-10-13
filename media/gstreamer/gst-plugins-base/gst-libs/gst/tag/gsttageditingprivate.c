/* GStreamer
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

#include "gsttageditingprivate.h"

#include <string.h>

gint
__exif_tag_image_orientation_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "rotate-0") == 0)
    return 1;
  else if (strcmp (str, "flip-rotate-0") == 0)
    return 2;
  else if (strcmp (str, "rotate-180") == 0)
    return 3;
  else if (strcmp (str, "flip-rotate-180") == 0)
    return 4;
  else if (strcmp (str, "flip-rotate-270") == 0)
    return 5;
  else if (strcmp (str, "rotate-90") == 0)
    return 6;
  else if (strcmp (str, "flip-rotate-90") == 0)
    return 7;
  else if (strcmp (str, "rotate-270") == 0)
    return 8;

end:
  GST_WARNING ("Invalid image orientation tag: %s", str);
  return -1;
}

const gchar *
__exif_tag_image_orientation_from_exif_value (gint value)
{
  switch (value) {
    case 1:
      return "rotate-0";
    case 2:
      return "flip-rotate-0";
    case 3:
      return "rotate-180";
    case 4:
      return "flip-rotate-180";
    case 5:
      return "flip-rotate-270";
    case 6:
      return "rotate-90";
    case 7:
      return "flip-rotate-90";
    case 8:
      return "rotate-270";
    default:
      GST_WARNING ("Invalid tiff orientation tag value: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_exposure_program_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "undefined") == 0)
    return 0;
  else if (strcmp (str, "manual") == 0)
    return 1;
  else if (strcmp (str, "normal") == 0)
    return 2;
  else if (strcmp (str, "aperture-priority") == 0)
    return 3;
  else if (strcmp (str, "shutter-priority") == 0)
    return 4;
  else if (strcmp (str, "creative") == 0)
    return 5;
  else if (strcmp (str, "action") == 0)
    return 6;
  else if (strcmp (str, "portrait") == 0)
    return 7;
  else if (strcmp (str, "landscape") == 0)
    return 8;

end:
  GST_WARNING ("Invalid capturing exposure program tag: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_exposure_program_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "undefined";
    case 1:
      return "manual";
    case 2:
      return "normal";
    case 3:
      return "aperture-priority";
    case 4:
      return "shutter-priority";
    case 5:
      return "creative";
    case 6:
      return "action";
    case 7:
      return "portrait";
    case 8:
      return "landscape";
    default:
      GST_WARNING ("Invalid exif exposure program: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_exposure_mode_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "auto-exposure") == 0)
    return 0;
  else if (strcmp (str, "manual-exposure") == 0)
    return 1;
  else if (strcmp (str, "auto-bracket") == 0)
    return 2;

end:
  GST_WARNING ("Invalid capturing exposure mode tag: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_exposure_mode_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "auto-exposure";
    case 1:
      return "manual-exposure";
    case 2:
      return "auto-bracket";
    default:
      GST_WARNING ("Invalid exif exposure mode: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_scene_capture_type_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "standard") == 0)
    return 0;
  else if (strcmp (str, "landscape") == 0)
    return 1;
  else if (strcmp (str, "portrait") == 0)
    return 2;
  else if (strcmp (str, "night-scene") == 0)
    return 3;

end:
  GST_WARNING ("Invalid capturing scene capture type: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_scene_capture_type_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "standard";
    case 1:
      return "landscape";
    case 2:
      return "portrait";
    case 3:
      return "night-scene";
    default:
      GST_WARNING ("Invalid exif scene capture type: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_gain_adjustment_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "none") == 0)
    return 0;
  else if (strcmp (str, "low-gain-up") == 0)
    return 1;
  else if (strcmp (str, "high-gain-up") == 0)
    return 2;
  else if (strcmp (str, "low-gain-down") == 0)
    return 3;
  else if (strcmp (str, "high-gain-down") == 0)
    return 4;

end:
  GST_WARNING ("Invalid capturing gain adjustment type: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_gain_adjustment_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "none";
    case 1:
      return "low-gain-up";
    case 2:
      return "high-gain-up";
    case 3:
      return "low-gain-down";
    case 4:
      return "high-gain-down";
    default:
      GST_WARNING ("Invalid exif gain control type: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_white_balance_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "auto") == 0)
    return 0;
  else                          /* everything else is just manual */
    return 1;

end:
  GST_WARNING ("Invalid white balance: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_white_balance_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "auto";
    case 1:
      return "manual";
    default:
      GST_WARNING ("Invalid white balance type: %d", value);
      return NULL;
  }
}

static gint
__exif_tag_capturing_contrast_sharpness_to_exif_value (const gchar * str,
    const gchar * tag_name)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "normal") == 0)
    return 0;
  else if (strcmp (str, "soft") == 0)
    return 1;
  else if (strcmp (str, "hard") == 0)
    return 2;

end:
  GST_WARNING ("Invalid %s type: %s", tag_name, str);
  return -1;
}

static const gchar *
__exif_tag_capturing_contrast_sharpness_from_exif_value (gint value,
    const gchar * tag_name)
{
  switch (value) {
    case 0:
      return "normal";
    case 1:
      return "soft";
    case 2:
      return "hard";
    default:
      GST_WARNING ("Invalid %s type: %d", tag_name, value);
      return NULL;
  }
}

gint
__exif_tag_capturing_contrast_to_exif_value (const gchar * str)
{
  return __exif_tag_capturing_contrast_sharpness_to_exif_value (str,
      "contrast");
}

const gchar *
__exif_tag_capturing_contrast_from_exif_value (gint value)
{
  return __exif_tag_capturing_contrast_sharpness_from_exif_value (value,
      "contrast");
}

gint
__exif_tag_capturing_saturation_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "normal") == 0)
    return 0;
  else if (strcmp (str, "low-saturation") == 0)
    return 1;
  else if (strcmp (str, "high-saturation") == 0)
    return 2;

end:
  GST_WARNING ("Invalid saturation type: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_saturation_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "normal";
    case 1:
      return "low-saturation";
    case 2:
      return "high-saturation";
    default:
      GST_WARNING ("Invalid saturation type: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_sharpness_to_exif_value (const gchar * str)
{
  return __exif_tag_capturing_contrast_sharpness_to_exif_value (str,
      "sharpness");
}

const gchar *
__exif_tag_capturing_sharpness_from_exif_value (gint value)
{
  return __exif_tag_capturing_contrast_sharpness_from_exif_value (value,
      "sharpness");
}

gint
__exif_tag_capturing_metering_mode_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "unknown") == 0)
    return 0;
  else if (strcmp (str, "average") == 0)
    return 1;
  else if (strcmp (str, "center-weighted-average") == 0)
    return 2;
  else if (strcmp (str, "spot") == 0)
    return 3;
  else if (strcmp (str, "multi-spot") == 0)
    return 4;
  else if (strcmp (str, "pattern") == 0)
    return 5;
  else if (strcmp (str, "partial") == 0)
    return 6;
  else if (strcmp (str, "other") == 0)
    return 255;

end:
  GST_WARNING ("Invalid metering mode type: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_metering_mode_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "unknown";
    case 1:
      return "average";
    case 2:
      return "center-weighted-average";
    case 3:
      return "spot";
    case 4:
      return "multi-spot";
    case 5:
      return "pattern";
    case 6:
      return "partial";
    case 255:
      return "other";
    default:
      GST_WARNING ("Invalid metering mode type: %d", value);
      return NULL;
  }
}

gint
__exif_tag_capturing_source_to_exif_value (const gchar * str)
{
  if (str == NULL)
    goto end;

  if (strcmp (str, "dsc") == 0)
    return 3;
  else if (strcmp (str, "other") == 0)
    return 0;
  else if (strcmp (str, "transparent-scanner") == 0)
    return 1;
  else if (strcmp (str, "reflex-scanner") == 0)
    return 2;

end:
  GST_WARNING ("Invalid capturing source type: %s", str);
  return -1;
}

const gchar *
__exif_tag_capturing_source_from_exif_value (gint value)
{
  switch (value) {
    case 0:
      return "other";
    case 1:
      return "transparent-scanner";
    case 2:
      return "reflex-scanner";
    case 3:
      return "dsc";
    default:
      GST_WARNING ("Invalid capturing source type: %d", value);
      return NULL;
  }
}
