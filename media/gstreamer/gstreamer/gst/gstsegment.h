/* GStreamer
 * Copyright (C) 2005 Wim Taymans <wim@fluendo.com>
 *
 * gstsegment.h: Header for GstSegment subsystem
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


#ifndef __GST_SEGMENT_H__
#define __GST_SEGMENT_H__

#include <gst/gstformat.h>

G_BEGIN_DECLS

#define GST_TYPE_SEGMENT             (gst_segment_get_type())

typedef struct _GstSegment GstSegment;

/**
 * GstSeekType:
 * @GST_SEEK_TYPE_NONE: no change in position is required
 * @GST_SEEK_TYPE_SET: absolute position is requested
 * @GST_SEEK_TYPE_END: relative position to duration is requested
 *
 * The different types of seek events. When constructing a seek event with
 * gst_event_new_seek() or when doing gst_segment_do_seek ().
 */
typedef enum {
  /* one of these */
  GST_SEEK_TYPE_NONE            = 0,
  GST_SEEK_TYPE_SET             = 1,
  GST_SEEK_TYPE_END             = 2
} GstSeekType;

/**
 * GstSeekFlags:
 * @GST_SEEK_FLAG_NONE: no flag
 * @GST_SEEK_FLAG_FLUSH: flush pipeline
 * @GST_SEEK_FLAG_ACCURATE: accurate position is requested, this might
 *                     be considerably slower for some formats.
 * @GST_SEEK_FLAG_KEY_UNIT: seek to the nearest keyframe. This might be
 *                     faster but less accurate.
 * @GST_SEEK_FLAG_SEGMENT: perform a segment seek.
 * @GST_SEEK_FLAG_SKIP: when doing fast forward or fast reverse playback, allow
 *                     elements to skip frames instead of generating all
 *                     frames.
 * @GST_SEEK_FLAG_SNAP_BEFORE: go to a location before the requested position,
 *                     if KEY_UNIT this means the keyframe at or before the
 *                     requested position the one at or before the seek target.
 * @GST_SEEK_FLAG_SNAP_AFTER: go to a location after the requested position,
 *                     if KEY_UNIT this means the keyframe at of after the
 *                     requested position.
 * @GST_SEEK_FLAG_SNAP_NEAREST: go to a position near the requested position,
 *                     if KEY_UNIT this means the keyframe closest to the
 *                     requested position, if both keyframes are at an equal
 *                     distance, behaves like SNAP_BEFORE.
 *
 * Flags to be used with gst_element_seek() or gst_event_new_seek(). All flags
 * can be used together.
 *
 * A non flushing seek might take some time to perform as the currently
 * playing data in the pipeline will not be cleared.
 *
 * An accurate seek might be slower for formats that don't have any indexes
 * or timestamp markers in the stream. Specifying this flag might require a
 * complete scan of the file in those cases.
 *
 * When performing a segment seek: after the playback of the segment completes,
 * no EOS will be emitted by the element that performed the seek, but a
 * #GST_MESSAGE_SEGMENT_DONE message will be posted on the bus by the element.
 * When this message is posted, it is possible to send a new seek event to
 * continue playback. With this seek method it is possible to perform seamless
 * looping or simple linear editing.
 *
 * When doing fast forward (rate > 1.0) or fast reverse (rate < -1.0) trickmode
 * playback, the @GST_SEEK_FLAG_SKIP flag can be used to instruct decoders
 * and demuxers to adjust the playback rate by skipping frames. This can improve
 * performance and decrease CPU usage because not all frames need to be decoded.
 *
 * The @GST_SEEK_FLAG_SNAP_BEFORE flag can be used to snap to the previous
 * relevant location, and the @GST_SEEK_FLAG_SNAP_AFTER flag can be used to
 * select the next relevant location. If KEY_UNIT is specified, the relevant
 * location is a keyframe. If both flags are specified, the nearest of these
 * locations will be selected. If none are specified, the implementation is
 * free to select whichever it wants.
 * The before and after here are in running time, so when playing backwards,
 * the next location refers to the one that will played in next, and not the
 * one that is located after in the actual source stream.
 *
 * Also see part-seeking.txt in the GStreamer design documentation for more
 * details on the meaning of these flags and the behaviour expected of
 * elements that handle them.
 */
typedef enum {
  GST_SEEK_FLAG_NONE            = 0,
  GST_SEEK_FLAG_FLUSH           = (1 << 0),
  GST_SEEK_FLAG_ACCURATE        = (1 << 1),
  GST_SEEK_FLAG_KEY_UNIT        = (1 << 2),
  GST_SEEK_FLAG_SEGMENT         = (1 << 3),
  GST_SEEK_FLAG_SKIP            = (1 << 4),
  GST_SEEK_FLAG_SNAP_BEFORE     = (1 << 5),
  GST_SEEK_FLAG_SNAP_AFTER      = (1 << 6),
  GST_SEEK_FLAG_SNAP_NEAREST    = GST_SEEK_FLAG_SNAP_BEFORE | GST_SEEK_FLAG_SNAP_AFTER,
  /* Careful to restart next flag with 1<<7 here */
} GstSeekFlags;

/**
 * GstSegmentFlags:
 * @GST_SEGMENT_FLAG_NONE: no flags
 * @GST_SEGMENT_FLAG_RESET: reset the pipeline running_time to the segment
 *                          running_time
 * @GST_SEGMENT_FLAG_SKIP: perform skip playback
 * @GST_SEGMENT_FLAG_SEGMENT: send SEGMENT_DONE instead of EOS
 *
 * Flags for the GstSegment structure. Currently mapped to the corresponding
 * values of the seek flags.
 */
/* Note: update gst_segment_do_seek() when adding new flags here */
typedef enum { /*< flags >*/
  GST_SEGMENT_FLAG_NONE            = GST_SEEK_FLAG_NONE,
  GST_SEGMENT_FLAG_RESET           = GST_SEEK_FLAG_FLUSH,
  GST_SEGMENT_FLAG_SKIP            = GST_SEEK_FLAG_SKIP,
  GST_SEGMENT_FLAG_SEGMENT         = GST_SEEK_FLAG_SEGMENT
} GstSegmentFlags;

/**
 * GstSegment:
 * @flags: flags for this segment
 * @rate: the rate of the segment
 * @applied_rate: the already applied rate to the segment
 * @format: the format of the segment values
 * @base: the base of the segment
 * @offset: the offset to apply to @start or @stop
 * @start: the start of the segment
 * @stop: the stop of the segment
 * @time: the stream time of the segment
 * @position: the position in the segment
 * @duration: the duration of the segment
 *
 * A helper structure that holds the configured region of
 * interest in a media file.
 */
struct _GstSegment {
  /*< public >*/
  GstSegmentFlags flags;

  gdouble         rate;
  gdouble         applied_rate;

  GstFormat       format;
  guint64         base;
  guint64         offset;
  guint64         start;
  guint64         stop;
  guint64         time;

  guint64         position;
  guint64         duration;

  /* < private > */
  gpointer        _gst_reserved[GST_PADDING];
};

GType        gst_segment_get_type            (void);

GstSegment * gst_segment_new                 (void) G_GNUC_MALLOC;
GstSegment * gst_segment_copy                (const GstSegment *segment) G_GNUC_MALLOC;
void         gst_segment_copy_into           (const GstSegment *src, GstSegment *dest);
void         gst_segment_free                (GstSegment *segment);

void         gst_segment_init                (GstSegment *segment, GstFormat format);

guint64      gst_segment_to_stream_time      (const GstSegment *segment, GstFormat format, guint64 position);
guint64      gst_segment_to_running_time     (const GstSegment *segment, GstFormat format, guint64 position);
guint64      gst_segment_to_position         (const GstSegment *segment, GstFormat format, guint64 running_time);

gboolean     gst_segment_set_running_time    (GstSegment *segment, GstFormat format, guint64 running_time);

gboolean     gst_segment_offset_running_time (GstSegment *segment, GstFormat format, gint64 offset);

gboolean     gst_segment_clip                (const GstSegment *segment, GstFormat format, guint64 start,
                                              guint64 stop, guint64 *clip_start, guint64 *clip_stop);


gboolean     gst_segment_do_seek             (GstSegment * segment, gdouble rate,
                                              GstFormat format, GstSeekFlags flags,
                                              GstSeekType start_type, guint64 start,
                                              GstSeekType stop_type, guint64 stop, gboolean * update);

G_END_DECLS

#endif /* __GST_SEGMENT_H__ */
