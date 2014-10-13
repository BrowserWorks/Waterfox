/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * audioclock.c: Clock for use by audio plugins
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

/**
 * SECTION:gstaudioclock
 * @short_description: Helper object for implementing audio clocks
 * @see_also: #GstAudioBaseSink, #GstSystemClock
 *
 * #GstAudioClock makes it easy for elements to implement a #GstClock, they
 * simply need to provide a function that returns the current clock time.
 *
 * This object is internally used to implement the clock in #GstAudioBaseSink.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstaudioclock.h"

GST_DEBUG_CATEGORY_STATIC (gst_audio_clock_debug);
#define GST_CAT_DEFAULT gst_audio_clock_debug

static void gst_audio_clock_class_init (GstAudioClockClass * klass);
static void gst_audio_clock_init (GstAudioClock * clock);

static void gst_audio_clock_dispose (GObject * object);

static GstClockTime gst_audio_clock_get_internal_time (GstClock * clock);

static GstSystemClockClass *parent_class = NULL;

/* static guint gst_audio_clock_signals[LAST_SIGNAL] = { 0 }; */

GType
gst_audio_clock_get_type (void)
{
  static volatile gsize clock_type = 0;
  static const GTypeInfo clock_info = {
    sizeof (GstAudioClockClass),
    NULL,
    NULL,
    (GClassInitFunc) gst_audio_clock_class_init,
    NULL,
    NULL,
    sizeof (GstAudioClock),
    4,
    (GInstanceInitFunc) gst_audio_clock_init,
    NULL
  };

  if (g_once_init_enter (&clock_type)) {
    GType tmp = g_type_register_static (GST_TYPE_SYSTEM_CLOCK, "GstAudioClock",
        &clock_info, 0);
    g_once_init_leave (&clock_type, tmp);
  }

  return (GType) clock_type;
}

static void
gst_audio_clock_class_init (GstAudioClockClass * klass)
{
  GstClockClass *gstclock_class;
  GObjectClass *gobject_class;

  gobject_class = (GObjectClass *) klass;
  gstclock_class = (GstClockClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->dispose = gst_audio_clock_dispose;
  gstclock_class->get_internal_time = gst_audio_clock_get_internal_time;

  GST_DEBUG_CATEGORY_INIT (gst_audio_clock_debug, "audioclock", 0,
      "audioclock");
}

static void
gst_audio_clock_init (GstAudioClock * clock)
{
  GST_DEBUG_OBJECT (clock, "init");
  clock->last_time = 0;
  clock->time_offset = 0;
  GST_OBJECT_FLAG_SET (clock, GST_CLOCK_FLAG_CAN_SET_MASTER);
}

static void
gst_audio_clock_dispose (GObject * object)
{
  GstAudioClock *clock = GST_AUDIO_CLOCK (object);

  if (clock->destroy_notify && clock->user_data)
    clock->destroy_notify (clock->user_data);
  clock->destroy_notify = NULL;
  clock->user_data = NULL;

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

/**
 * gst_audio_clock_new:
 * @name: the name of the clock
 * @func: a function
 * @user_data: user data
 * @destroy_notify: #GDestroyNotify for @user_data
 *
 * Create a new #GstAudioClock instance. Whenever the clock time should be
 * calculated it will call @func with @user_data. When @func returns
 * #GST_CLOCK_TIME_NONE, the clock will return the last reported time.
 *
 * Returns: a new #GstAudioClock casted to a #GstClock.
 */
GstClock *
gst_audio_clock_new (const gchar * name, GstAudioClockGetTimeFunc func,
    gpointer user_data, GDestroyNotify destroy_notify)
{
  GstAudioClock *aclock =
      GST_AUDIO_CLOCK (g_object_new (GST_TYPE_AUDIO_CLOCK, "name", name,
          "clock-type", GST_CLOCK_TYPE_OTHER, NULL));

  aclock->func = func;
  aclock->user_data = user_data;
  aclock->destroy_notify = destroy_notify;

  return (GstClock *) aclock;
}

/**
 * gst_audio_clock_reset:
 * @clock: a #GstAudioClock
 * @time: a #GstClockTime
 *
 * Inform @clock that future calls to #GstAudioClockGetTimeFunc will return values
 * starting from @time. The clock will update an internal offset to make sure that
 * future calls to internal_time will return an increasing result as required by
 * the #GstClock object.
 */
void
gst_audio_clock_reset (GstAudioClock * clock, GstClockTime time)
{
  GstClockTimeDiff time_offset;

  if (clock->last_time >= time)
    time_offset = clock->last_time - time;
  else
    time_offset = -(time - clock->last_time);

  clock->time_offset = time_offset;

  GST_DEBUG_OBJECT (clock,
      "reset clock to %" GST_TIME_FORMAT ", last %" GST_TIME_FORMAT ", offset %"
      GST_TIME_FORMAT, GST_TIME_ARGS (time), GST_TIME_ARGS (clock->last_time),
      GST_TIME_ARGS (time_offset));
}

static GstClockTime
gst_audio_clock_func_invalid (GstClock * clock, gpointer user_data)
{
  return GST_CLOCK_TIME_NONE;
}

static GstClockTime
gst_audio_clock_get_internal_time (GstClock * clock)
{
  GstAudioClock *aclock;
  GstClockTime result;

  aclock = GST_AUDIO_CLOCK_CAST (clock);

  result = aclock->func (clock, aclock->user_data);
  if (result == GST_CLOCK_TIME_NONE) {
    result = aclock->last_time;
  } else {
    result += aclock->time_offset;
    /* clock must be increasing */
    if (aclock->last_time < result)
      aclock->last_time = result;
    else
      result = aclock->last_time;
  }

  GST_DEBUG_OBJECT (clock,
      "result %" GST_TIME_FORMAT ", last_time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (result), GST_TIME_ARGS (aclock->last_time));

  return result;
}

/**
 * gst_audio_clock_get_time:
 * @clock: a #GstAudioClock
 *
 * Report the time as returned by the #GstAudioClockGetTimeFunc without applying
 * any offsets.
 *
 * Returns: the time as reported by the time function of the audio clock
 */
GstClockTime
gst_audio_clock_get_time (GstClock * clock)
{
  GstAudioClock *aclock;
  GstClockTime result;

  aclock = GST_AUDIO_CLOCK_CAST (clock);

  result = aclock->func (clock, aclock->user_data);
  if (result == GST_CLOCK_TIME_NONE) {
    GST_DEBUG_OBJECT (clock, "no time, reuse last");
    result = aclock->last_time - aclock->time_offset;
  }

  GST_DEBUG_OBJECT (clock,
      "result %" GST_TIME_FORMAT ", last_time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (result), GST_TIME_ARGS (aclock->last_time));

  return result;
}

/**
 * gst_audio_clock_adjust:
 * @clock: a #GstAudioClock
 * @time: a #GstClockTime
 *
 * Adjust @time with the internal offset of the audio clock.
 *
 * Returns: @time adjusted with the internal offset.
 */
GstClockTime
gst_audio_clock_adjust (GstClock * clock, GstClockTime time)
{
  GstAudioClock *aclock;
  GstClockTime result;

  aclock = GST_AUDIO_CLOCK_CAST (clock);

  result = time + aclock->time_offset;

  return result;
}

/**
 * gst_audio_clock_invalidate:
 * @clock: a #GstAudioClock
 *
 * Invalidate the clock function. Call this function when the provided
 * #GstAudioClockGetTimeFunc cannot be called anymore, for example, when the
 * user_data becomes invalid.
 *
 * After calling this function, @clock will return the last returned time for
 * the rest of its lifetime.
 */
void
gst_audio_clock_invalidate (GstClock * clock)
{
  GstAudioClock *aclock;

  aclock = GST_AUDIO_CLOCK_CAST (clock);

  aclock->func = gst_audio_clock_func_invalid;
}
