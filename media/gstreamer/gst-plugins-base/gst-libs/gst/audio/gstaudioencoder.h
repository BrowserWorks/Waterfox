/* GStreamer
 * Copyright (C) 2011 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>.
 * Copyright (C) 2011 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
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

#ifndef __GST_AUDIO_AUDIO_H__
#include <gst/audio/audio.h>
#endif

#ifndef __GST_AUDIO_ENCODER_H__
#define __GST_AUDIO_ENCODER_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_AUDIO_ENCODER		   (gst_audio_encoder_get_type())
#define GST_AUDIO_ENCODER(obj)		   (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_ENCODER,GstAudioEncoder))
#define GST_AUDIO_ENCODER_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_ENCODER,GstAudioEncoderClass))
#define GST_AUDIO_ENCODER_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS((obj),GST_TYPE_AUDIO_ENCODER,GstAudioEncoderClass))
#define GST_IS_AUDIO_ENCODER(obj)	   (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_ENCODER))
#define GST_IS_AUDIO_ENCODER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_ENCODER))
#define GST_AUDIO_ENCODER_CAST(obj)	((GstAudioEncoder *)(obj))

/**
 * GST_AUDIO_ENCODER_SINK_NAME:
 *
 * the name of the templates for the sink pad
 */
#define GST_AUDIO_ENCODER_SINK_NAME	"sink"
/**
 * GST_AUDIO_ENCODER_SRC_NAME:
 *
 * the name of the templates for the source pad
 */
#define GST_AUDIO_ENCODER_SRC_NAME	        "src"

/**
 * GST_AUDIO_ENCODER_SRC_PAD:
 * @obj: audio encoder instance
 *
 * Gives the pointer to the source #GstPad object of the element.
 */
#define GST_AUDIO_ENCODER_SRC_PAD(obj)	(GST_AUDIO_ENCODER_CAST (obj)->srcpad)

/**
 * GST_AUDIO_ENCODER_SINK_PAD:
 * @obj: audio encoder instance
 *
 * Gives the pointer to the sink #GstPad object of the element.
 */
#define GST_AUDIO_ENCODER_SINK_PAD(obj)	(GST_AUDIO_ENCODER_CAST (obj)->sinkpad)

/**
 * GST_AUDIO_ENCODER_INPUT_SEGMENT:
 * @obj: base parse instance
 *
 * Gives the input segment of the element.
 */
#define GST_AUDIO_ENCODER_INPUT_SEGMENT(obj)     (GST_AUDIO_ENCODER_CAST (obj)->input_segment)

/**
 * GST_AUDIO_ENCODER_OUTPUT_SEGMENT:
 * @obj: base parse instance
 *
 * Gives the output segment of the element.
 */
#define GST_AUDIO_ENCODER_OUTPUT_SEGMENT(obj)     (GST_AUDIO_ENCODER_CAST (obj)->output_segment)

#define GST_AUDIO_ENCODER_STREAM_LOCK(enc)   g_rec_mutex_lock (&GST_AUDIO_ENCODER (enc)->stream_lock)
#define GST_AUDIO_ENCODER_STREAM_UNLOCK(enc) g_rec_mutex_unlock (&GST_AUDIO_ENCODER (enc)->stream_lock)

typedef struct _GstAudioEncoder GstAudioEncoder;
typedef struct _GstAudioEncoderClass GstAudioEncoderClass;

typedef struct _GstAudioEncoderPrivate GstAudioEncoderPrivate;

/**
 * GstAudioEncoder:
 *
 * The opaque #GstAudioEncoder data structure.
 */
struct _GstAudioEncoder {
  GstElement     element;

  /*< protected >*/
  /* source and sink pads */
  GstPad         *sinkpad;
  GstPad         *srcpad;

  /* protects all data processing, i.e. is locked
   * in the chain function, finish_frame and when
   * processing serialized events */
  GRecMutex       stream_lock;

  /* MT-protected (with STREAM_LOCK) */
  GstSegment      input_segment;
  GstSegment      output_segment;

  /*< private >*/
  GstAudioEncoderPrivate *priv;

  gpointer       _gst_reserved[GST_PADDING_LARGE];
};

/**
 * GstAudioEncoderClass:
 * @element_class:  The parent class structure
 * @start:          Optional.
 *                  Called when the element starts processing.
 *                  Allows opening external resources.
 * @stop:           Optional.
 *                  Called when the element stops processing.
 *                  Allows closing external resources.
 * @set_format:     Notifies subclass of incoming data format.
 *                  GstAudioInfo contains the format according to provided caps.
 * @handle_frame:   Provides input samples (or NULL to clear any remaining data)
 *                  according to directions as configured by the subclass
 *                  using the API.  Input data ref management is performed
 *                  by base class, subclass should not care or intervene,
 *                  and input data is only valid until next call to base class,
 *                  most notably a call to gst_audio_encoder_finish_frame().
 * @flush:          Optional.
 *                  Instructs subclass to clear any codec caches and discard
 *                  any pending samples and not yet returned encoded data.
 * @sink_event:     Optional.
 *                  Event handler on the sink pad. Subclasses should chain up to
 *                  the parent implementation to invoke the default handler.
 * @src_event:      Optional.
 *                  Event handler on the src pad. Subclasses should chain up to
 *                  the parent implementation to invoke the default handler.
 * @pre_push:       Optional.
 *                  Called just prior to pushing (encoded data) buffer downstream.
 *                  Subclass has full discretionary access to buffer,
 *                  and a not OK flow return will abort downstream pushing.
 * @getcaps:        Optional.
 *                  Allows for a custom sink getcaps implementation (e.g.
 *                  for multichannel input specification).  If not implemented,
 *                  default returns gst_audio_encoder_proxy_getcaps
 *                  applied to sink template caps.
 * @open:           Optional.
 *                  Called when the element changes to GST_STATE_READY.
 *                  Allows opening external resources.
 * @close:          Optional.
 *                  Called when the element changes to GST_STATE_NULL.
 *                  Allows closing external resources.
 * @negotiate:      Optional.
 *                  Negotiate with downstream and configure buffer pools, etc.
 *                  Subclasses should chain up to the parent implementation to
 *                  invoke the default handler.
 * @decide_allocation: Optional.
 *                     Setup the allocation parameters for allocating output
 *                     buffers. The passed in query contains the result of the
 *                     downstream allocation query.
 *                     Subclasses should chain up to the parent implementation to
 *                     invoke the default handler.
 * @propose_allocation: Optional.
 *                      Propose buffer allocation parameters for upstream elements.
 *                      Subclasses should chain up to the parent implementation to
 *                      invoke the default handler.
 *
 * Subclasses can override any of the available virtual methods or not, as
 * needed. At minimum @set_format and @handle_frame needs to be overridden.
 */
struct _GstAudioEncoderClass {
  GstElementClass element_class;

  /*< public >*/
  /* virtual methods for subclasses */

  gboolean      (*start)              (GstAudioEncoder *enc);

  gboolean      (*stop)               (GstAudioEncoder *enc);

  gboolean      (*set_format)         (GstAudioEncoder *enc,
                                       GstAudioInfo        *info);

  GstFlowReturn (*handle_frame)       (GstAudioEncoder *enc,
                                       GstBuffer *buffer);

  void          (*flush)              (GstAudioEncoder *enc);

  GstFlowReturn (*pre_push)           (GstAudioEncoder *enc,
                                       GstBuffer **buffer);

  gboolean      (*sink_event)         (GstAudioEncoder *enc,
                                       GstEvent *event);

  gboolean      (*src_event)          (GstAudioEncoder *enc,
                                       GstEvent *event);

  GstCaps *     (*getcaps)            (GstAudioEncoder *enc, GstCaps *filter);

  gboolean      (*open)               (GstAudioEncoder *enc);

  gboolean      (*close)              (GstAudioEncoder *enc);

  gboolean      (*negotiate)          (GstAudioEncoder *enc);

  gboolean      (*decide_allocation)  (GstAudioEncoder *enc, GstQuery *query);

  gboolean      (*propose_allocation) (GstAudioEncoder * enc,
                                       GstQuery * query);

  /*< private >*/
  gpointer       _gst_reserved[GST_PADDING_LARGE];
};

GType           gst_audio_encoder_get_type         (void);

GstFlowReturn   gst_audio_encoder_finish_frame (GstAudioEncoder * enc,
                                                GstBuffer       * buffer,
                                                gint              samples);

GstCaps *       gst_audio_encoder_proxy_getcaps (GstAudioEncoder * enc,
                                                 GstCaps         * caps,
                                                 GstCaps         * filter);

gboolean        gst_audio_encoder_set_output_format  (GstAudioEncoder    * enc,
                                                      GstCaps            * caps);

gboolean        gst_audio_encoder_negotiate          (GstAudioEncoder * enc);

GstBuffer *     gst_audio_encoder_allocate_output_buffer (GstAudioEncoder * enc,
                                                          gsize             size);

/* context parameters */
GstAudioInfo  * gst_audio_encoder_get_audio_info (GstAudioEncoder * enc);

gint            gst_audio_encoder_get_frame_samples_min (GstAudioEncoder * enc);

void            gst_audio_encoder_set_frame_samples_min (GstAudioEncoder * enc, gint num);

gint            gst_audio_encoder_get_frame_samples_max (GstAudioEncoder * enc);

void            gst_audio_encoder_set_frame_samples_max (GstAudioEncoder * enc, gint num);

gint            gst_audio_encoder_get_frame_max (GstAudioEncoder * enc);

void            gst_audio_encoder_set_frame_max (GstAudioEncoder * enc, gint num);

gint            gst_audio_encoder_get_lookahead (GstAudioEncoder * enc);

void            gst_audio_encoder_set_lookahead (GstAudioEncoder * enc, gint num);

void            gst_audio_encoder_get_latency (GstAudioEncoder * enc,
                                               GstClockTime    * min,
                                               GstClockTime    * max);

void            gst_audio_encoder_set_latency (GstAudioEncoder * enc,
                                               GstClockTime      min,
                                               GstClockTime      max);

void            gst_audio_encoder_set_headers (GstAudioEncoder * enc,
                                               GList           * headers);

/* object properties */

void            gst_audio_encoder_set_mark_granule (GstAudioEncoder * enc,
                                                    gboolean enabled);

gboolean        gst_audio_encoder_get_mark_granule (GstAudioEncoder * enc);

void            gst_audio_encoder_set_perfect_timestamp (GstAudioEncoder * enc,
                                                         gboolean          enabled);

gboolean        gst_audio_encoder_get_perfect_timestamp (GstAudioEncoder * enc);

void            gst_audio_encoder_set_hard_resync (GstAudioEncoder * enc,
                                                   gboolean          enabled);

gboolean        gst_audio_encoder_get_hard_resync (GstAudioEncoder * enc);

void            gst_audio_encoder_set_tolerance (GstAudioEncoder * enc,
                                                 GstClockTime      tolerance);

GstClockTime    gst_audio_encoder_get_tolerance (GstAudioEncoder * enc);

void            gst_audio_encoder_set_hard_min (GstAudioEncoder * enc,
                                                gboolean enabled);

gboolean        gst_audio_encoder_get_hard_min (GstAudioEncoder * enc);

void            gst_audio_encoder_set_drainable (GstAudioEncoder * enc,
                                                 gboolean enabled);

gboolean        gst_audio_encoder_get_drainable (GstAudioEncoder * enc);

void            gst_audio_encoder_get_allocator (GstAudioEncoder * enc,
                                                 GstAllocator ** allocator,
                                                 GstAllocationParams * params);

void            gst_audio_encoder_merge_tags (GstAudioEncoder * enc,
                                              const GstTagList * tags, GstTagMergeMode mode);

G_END_DECLS

#endif /* __GST_AUDIO_ENCODER_H__ */
