/*
 * vp8utils.h - VP8 utilities (probability tables initialization)
 *
 * Copyright (C) 2013-2014 Intel Corporation
 *   Author: Gwenole Beauchesne <gwenole.beauchesne@intel.com>
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

#ifndef GST_VP8_UTILS_H
#define GST_VP8_UTILS_H

#include <gst/codecparsers/gstvp8parser.h>

void
gst_vp8_token_update_probs_init (GstVp8TokenProbs * probs);

void
gst_vp8_token_probs_init_defaults (GstVp8TokenProbs * probs);

void
gst_vp8_mv_update_probs_init (GstVp8MvProbs * probs);

void
gst_vp8_mv_probs_init_defaults (GstVp8MvProbs * probs);

void
gst_vp8_mode_probs_init_defaults (GstVp8ModeProbs * probs, gboolean key_frame);

#endif /* GST_VP8_UTILS_H */
