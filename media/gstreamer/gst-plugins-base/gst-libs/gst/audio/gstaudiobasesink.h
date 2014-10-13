/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstaudiobasesink.h:
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

/* a base class for audio sinks.
 *
 * It uses a ringbuffer to schedule playback of samples. This makes
 * it very easy to drop or insert samples to align incoming
 * buffers to the exact playback timestamp.
 *
 * Subclasses must provide a ringbuffer pointing to either DMA
 * memory or regular memory. A subclass should also call a callback
 * function when it has played N segments in the buffer. The subclass
 * is free to use a thread to signal this callback, use EIO or any
 * other mechanism.
 *
 * The base class is able to operate in push or pull mode. The chain
 * mode will queue the samples in the ringbuffer as much as possible.
 * The available space is calculated in the callback function.
 *
 * The pull mode will pull_range() a new buffer of N samples with a
 * configurable latency. This allows for high-end real time
 * audio processing pipelines driven by the audiosink. The callback
 * function will be used to perform a pull_range() on the sinkpad.
 * The thread scheduling the callback can be a real-time thread.
 *
 * Subclasses must implement a GstAudioRingBuffer in addition to overriding
 * the methods in GstBaseSink and this class.
 */

#ifndef __GST_AUDIO_AUDIO_H__
#include <gst/audio/audio.h>
#endif

#ifndef __GST_AUDIO_BASE_SINK_H__
#define __GST_AUDIO_BASE_SINK_H__

#include <gst/base/gstbasesink.h>

G_BEGIN_DECLS

#define GST_TYPE_AUDIO_BASE_SINK                (gst_audio_base_sink_get_type())
#define GST_AUDIO_BASE_SINK(obj)                (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_BASE_SINK,GstAudioBaseSink))
#define GST_AUDIO_BASE_SINK_CLASS(klass)        (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_BASE_SINK,GstAudioBaseSinkClass))
#define GST_AUDIO_BASE_SINK_GET_CLASS(obj)      (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_AUDIO_BASE_SINK, GstAudioBaseSinkClass))
#define GST_IS_AUDIO_BASE_SINK(obj)             (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_BASE_SINK))
#define GST_IS_AUDIO_BASE_SINK_CLASS(klass)     (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_BASE_SINK))

/**
 * GST_AUDIO_BASE_SINK_CLOCK:
 * @obj: a #GstAudioBaseSink
 *
 * Get the #GstClock of @obj.
 */
#define GST_AUDIO_BASE_SINK_CLOCK(obj)   (GST_AUDIO_BASE_SINK (obj)->clock)
/**
 * GST_AUDIO_BASE_SINK_PAD:
 * @obj: a #GstAudioBaseSink
 *
 * Get the sink #GstPad of @obj.
 */
#define GST_AUDIO_BASE_SINK_PAD(obj)     (GST_BASE_SINK (obj)->sinkpad)

/**
 * GstAudioBaseSinkSlaveMethod:
 * @GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE: Resample to match the master clock
 * @GST_AUDIO_BASE_SINK_SLAVE_SKEW: Adjust playout pointer when master clock
 * drifts too much.
 * @GST_AUDIO_BASE_SINK_SLAVE_NONE: No adjustment is done.
 *
 * Different possible clock slaving algorithms used when the internal audio
 * clock is not selected as the pipeline master clock.
 */
typedef enum
{
  GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE,
  GST_AUDIO_BASE_SINK_SLAVE_SKEW,
  GST_AUDIO_BASE_SINK_SLAVE_NONE
} GstAudioBaseSinkSlaveMethod;

#define GST_TYPE_AUDIO_BASE_SINK_SLAVE_METHOD (gst_audio_base_sink_slave_method_get_type ())

typedef struct _GstAudioBaseSink GstAudioBaseSink;
typedef struct _GstAudioBaseSinkClass GstAudioBaseSinkClass;
typedef struct _GstAudioBaseSinkPrivate GstAudioBaseSinkPrivate;

/**
 * GstAudioBaseSink:
 *
 * Opaque #GstAudioBaseSink.
 */
struct _GstAudioBaseSink {
  GstBaseSink         element;

  /*< protected >*/ /* with LOCK */
  /* our ringbuffer */
  GstAudioRingBuffer *ringbuffer;

  /* required buffer and latency in microseconds */
  guint64             buffer_time;
  guint64             latency_time;

  /* the next sample to write */
  guint64             next_sample;

  /* clock */
  GstClock           *provided_clock;

  /* with g_atomic_; currently rendering eos */
  gboolean            eos_rendering;

  /*< private >*/
  GstAudioBaseSinkPrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};

/**
 * GstAudioBaseSinkClass:
 * @parent_class: the parent class.
 * @create_ringbuffer: create and return a #GstAudioRingBuffer to write to.
 * @payload: payload data in a format suitable to write to the sink. If no
 *           payloading is required, returns a reffed copy of the original
 *           buffer, else returns the payloaded buffer with all other metadata
 *           copied.
 *
 * #GstAudioBaseSink class. Override the vmethod to implement
 * functionality.
 */
struct _GstAudioBaseSinkClass {
  GstBaseSinkClass     parent_class;

  /* subclass ringbuffer allocation */
  GstAudioRingBuffer* (*create_ringbuffer)  (GstAudioBaseSink *sink);

  /* subclass payloader */
  GstBuffer*          (*payload)            (GstAudioBaseSink *sink,
                                             GstBuffer        *buffer);
  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

GType gst_audio_base_sink_get_type(void);
GType gst_audio_base_sink_slave_method_get_type (void);

GstAudioRingBuffer *
           gst_audio_base_sink_create_ringbuffer       (GstAudioBaseSink *sink);

void       gst_audio_base_sink_set_provide_clock       (GstAudioBaseSink *sink, gboolean provide);
gboolean   gst_audio_base_sink_get_provide_clock       (GstAudioBaseSink *sink);

void       gst_audio_base_sink_set_slave_method        (GstAudioBaseSink *sink,
                                                        GstAudioBaseSinkSlaveMethod method);
GstAudioBaseSinkSlaveMethod
           gst_audio_base_sink_get_slave_method        (GstAudioBaseSink *sink);

void       gst_audio_base_sink_set_drift_tolerance     (GstAudioBaseSink *sink,
                                                        gint64 drift_tolerance);
gint64     gst_audio_base_sink_get_drift_tolerance     (GstAudioBaseSink *sink);

void       gst_audio_base_sink_set_alignment_threshold (GstAudioBaseSink * sink,
                                                        GstClockTime alignment_threshold);
GstClockTime
           gst_audio_base_sink_get_alignment_threshold (GstAudioBaseSink * sink);

void       gst_audio_base_sink_set_discont_wait        (GstAudioBaseSink * sink,
                                                        GstClockTime discont_wait);
GstClockTime
           gst_audio_base_sink_get_discont_wait        (GstAudioBaseSink * sink);

G_END_DECLS

#endif /* __GST_AUDIO_BASE_SINK_H__ */
