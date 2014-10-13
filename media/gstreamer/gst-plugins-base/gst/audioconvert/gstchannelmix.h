/* GStreamer
 * Copyright (C) 2004 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * gstchannelmix.h: setup of channel conversion matrices
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

#ifndef __GST_CHANNEL_MIX_H__
#define __GST_CHANNEL_MIX_H__

#include <gst/gst.h>
#include "audioconvert.h"

/*
 * Delete channel mixer matrix.
 */
void            gst_channel_mix_unset_matrix    (AudioConvertCtx * this);

/*
 * Setup channel mixer matrix.
 */
void            gst_channel_mix_setup_matrix    (AudioConvertCtx * this);

/*
 * Checks for passthrough (= identity matrix).
 */
gboolean        gst_channel_mix_passthrough     (AudioConvertCtx * this);

/*
 * Do actual mixing.
 */
void            gst_channel_mix_mix_int         (AudioConvertCtx * this,
                                                 gint32          * in_data,
                                                 gint32          * out_data,
                                                 gint              samples);

void            gst_channel_mix_mix_float       (AudioConvertCtx * this,
                                                 gdouble         * in_data,
                                                 gdouble         * out_data,
                                                 gint              samples);

#endif /* __GST_CHANNEL_MIX_H__ */
