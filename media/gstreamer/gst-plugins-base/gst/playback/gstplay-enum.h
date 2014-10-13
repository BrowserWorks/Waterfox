/* GStreamer
 * Copyright (C) <2007> Wim Taymans <wim.taymans@gmail.com>
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

#ifndef __GST_PLAY_ENUM_H__
#define __GST_PLAY_ENUM_H__

#include <gst/gst.h>

G_BEGIN_DECLS

/**
 * GstAutoplugSelectResult:
 * @GST_AUTOPLUG_SELECT_TRY: try to autoplug the current factory
 * @GST_AUTOPLUG_SELECT_EXPOSE: expose the pad as a raw stream
 * @GST_AUTOPLUG_SELECT_SKIP: skip the current factory
 *
 * return values for the autoplug-select signal.
 */
typedef enum {
  GST_AUTOPLUG_SELECT_TRY,
  GST_AUTOPLUG_SELECT_EXPOSE,
  GST_AUTOPLUG_SELECT_SKIP
} GstAutoplugSelectResult;

#define GST_TYPE_AUTOPLUG_SELECT_RESULT (gst_autoplug_select_result_get_type())
GType gst_autoplug_select_result_get_type (void);

/**
 * GstPlayFlags:
 * @GST_PLAY_FLAG_VIDEO: Enable rendering of the video stream
 * @GST_PLAY_FLAG_AUDIO: Enable rendering of the audio stream
 * @GST_PLAY_FLAG_TEXT: Enable rendering of subtitles
 * @GST_PLAY_FLAG_VIS: Enable rendering of visualisations when there is
 *       no video stream.
 * @GST_PLAY_FLAG_SOFT_VOLUME: Use software volume
 * @GST_PLAY_FLAG_NATIVE_AUDIO: only allow native audio formats, this omits
 *   configuration of audioconvert and audioresample.
 * @GST_PLAY_FLAG_NATIVE_VIDEO: only allow native video formats, this omits
 *   configuration of videoconvert and videoscale.
 * @GST_PLAY_FLAG_DOWNLOAD: enable progressice download buffering for selected
 *   formats.
 * @GST_PLAY_FLAG_BUFFERING: enable buffering of the demuxed or parsed data.
 * @GST_PLAY_FLAG_DEINTERLACE: deinterlace raw video (if native not forced).
 * @GST_PLAY_FLAG_FORCE_FILTERS: force audio/video filters to be applied if
 *   set.
 *
 * Extra flags to configure the behaviour of the sinks.
 */
typedef enum {
  GST_PLAY_FLAG_VIDEO         = (1 << 0),
  GST_PLAY_FLAG_AUDIO         = (1 << 1),
  GST_PLAY_FLAG_TEXT          = (1 << 2),
  GST_PLAY_FLAG_VIS           = (1 << 3),
  GST_PLAY_FLAG_SOFT_VOLUME   = (1 << 4),
  GST_PLAY_FLAG_NATIVE_AUDIO  = (1 << 5),
  GST_PLAY_FLAG_NATIVE_VIDEO  = (1 << 6),
  GST_PLAY_FLAG_DOWNLOAD      = (1 << 7),
  GST_PLAY_FLAG_BUFFERING     = (1 << 8),
  GST_PLAY_FLAG_DEINTERLACE   = (1 << 9),
  GST_PLAY_FLAG_SOFT_COLORBALANCE = (1 << 10),
  GST_PLAY_FLAG_FORCE_FILTERS = (1 << 11),
} GstPlayFlags;

#define GST_TYPE_PLAY_FLAGS (gst_play_flags_get_type())
GType gst_play_flags_get_type (void);

G_END_DECLS

#endif /* __GST_PLAY_ENUM_H__ */
