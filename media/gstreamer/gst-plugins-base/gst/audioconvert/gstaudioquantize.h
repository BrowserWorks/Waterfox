/* GStreamer
 * Copyright (C) 2007 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstaudioquantize.h: quantizes audio to the target format and optionally
 *                     applies dithering and noise shaping.
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

#include <gst/gst.h>
#include "audioconvert.h"

#ifndef __GST_AUDIO_QUANTIZE_H__
#define __GST_AUDIO_QUANTIZE_H__

gboolean gst_audio_quantize_setup (AudioConvertCtx * ctx);
void gst_audio_quantize_reset (AudioConvertCtx * ctx);
void gst_audio_quantize_free (AudioConvertCtx * ctx);


#endif /* __GST_AUDIO_QUANTIZE_H__ */
