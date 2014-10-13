/* GstTestClock - A deterministic clock for GStreamer unit tests
 *
 * Copyright (C) 2008 Ole André Vadla Ravnås <ole.andre.ravnas@tandberg.com>
 * Copyright (C) 2012 Sebastian Rasmussen <sebastian.rasmussen@axis.com>
 * Copyright (C) 2012 Havard Graff <havard@pexip.com>
 * Copyright (C) 2013 Haakon Sporsheim <haakon@pexip.com>
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/**
 * SECTION:gsttestclock
 * @short_description: Controllable, deterministic clock for GStreamer unit tests
 * @see_also: #GstSystemClock, #GstClock
 *
 * GstTestClock is an implementation of #GstClock which has different
 * behaviour compared to #GstSystemClock. Time for #GstSystemClock advances
 * according to the system time, while time for #GstTestClock changes only
 * when gst_test_clock_set_time() or gst_test_clock_advance_time() are
 * called. #GstTestClock provides unit tests with the possibility to
 * precisely advance the time in a deterministic manner, independent of the
 * system time or any other external factors.
 *
 * <example>
 * <title>Advancing the time of a #GstTestClock</title>
 *   <programlisting language="c">
 *   #include &lt;gst/gst.h&gt;
 *   #include &lt;gst/check/gsttestclock.h&gt;
 *
 *   GstClock *clock;
 *   GstTestClock *test_clock;
 *
 *   clock = gst_test_clock_new ();
 *   test_clock = GST_TEST_CLOCK (clock);
 *   GST_INFO ("Time: %" GST_TIME_FORMAT, GST_TIME_ARGS (gst_clock_get_time (clock)));
 *   gst_test_clock_advance_time ( test_clock, 1 * GST_SECOND);
 *   GST_INFO ("Time: %" GST_TIME_FORMAT, GST_TIME_ARGS (gst_clock_get_time (clock)));
 *   g_usleep (10 * G_USEC_PER_SEC);
 *   GST_INFO ("Time: %" GST_TIME_FORMAT, GST_TIME_ARGS (gst_clock_get_time (clock)));
 *   gst_test_clock_set_time (test_clock, 42 * GST_SECOND);
 *   GST_INFO ("Time: %" GST_TIME_FORMAT, GST_TIME_ARGS (gst_clock_get_time (clock)));
 *   ...
 *   </programlisting>
 * </example>
 *
 * #GstClock allows for setting up single shot or periodic clock notifications
 * as well as waiting for these notifications synchronously (using
 * gst_clock_id_wait()) or asynchronously (using gst_clock_id_wait_async() or
 * gst_clock_id_wait_async()). This is used by many GStreamer elements,
 * among them #GstBaseSrc and #GstBaseSink.
 *
 * #GstTestClock keeps track of these clock notifications. By calling
 * gst_test_clock_wait_for_next_pending_id() or
 * gst_test_clock_wait_for_multiple_pending_ids() a unit tests may wait for the
 * next one or several clock notifications to be requested. Additionally unit
 * tests may release blocked waits in a controlled fashion by calling
 * gst_test_clock_process_next_clock_id(). This way a unit test can control the
 * inaccuracy (jitter) of clock notifications, since the test can decide to
 * release blocked waits when the clock time has advanced exactly to, or past,
 * the requested clock notification time.
 *
 * There are also interfaces for determining if a notification belongs to a
 * #GstTestClock or not, as well as getting the number of requested clock
 * notifications so far.
 *
 * N.B.: When a unit test waits for a certain amount of clock notifications to
 * be requested in gst_test_clock_wait_for_next_pending_id() or
 * gst_test_clock_wait_for_multiple_pending_ids() then these functions may block
 * for a long time. If they block forever then the expected clock notifications
 * were never requested from #GstTestClock, and so the assumptions in the code
 * of the unit test are wrong. The unit test case runner in gstcheck is
 * expected to catch these cases either by the default test case timeout or the
 * one set for the unit test by calling tcase_set_timeout\(\).
 *
 * The sample code below assumes that the element under test will delay a
 * buffer pushed on the source pad by some latency until it arrives on the sink
 * pad. Moreover it is assumed that the element will at some point call
 * gst_clock_id_wait() to synchronously wait for a specific time. The first
 * buffer sent will arrive exactly on time only delayed by the latency. The
 * second buffer will arrive a little late (7ms) due to simulated jitter in the
 * clock notification.
 *
 * <example>
 * <title>Demonstration of how to work with clock notifications and #GstTestClock</title>
 *   <programlisting language="c">
 *   #include &lt;gst/gst.h&gt;
 *   #include &lt;gst/check/gstcheck.h&gt;
 *   #include &lt;gst/check/gsttestclock.h&gt;
 *
 *   GstClockTime latency;
 *   GstElement *element;
 *   GstPad *srcpad;
 *   GstClock *clock;
 *   GstTestClock *test_clock;
 *   GstBuffer buf;
 *   GstClockID pending_id;
 *   GstClockID processed_id;
 *
 *   latency = 42 * GST_MSECOND;
 *   element = create_element (latency, ...);
 *   srcpad = get_source_pad (element);
 *
 *   clock = gst_test_clock_new ();
 *   test_clock = GST_TEST_CLOCK (clock);
 *   gst_element_set_clock (element, clock);
 *
 *   GST_INFO ("Set time, create and push the first buffer\n");
 *   gst_test_clock_set_time (test_clock, 0);
 *   buf = create_test_buffer (gst_clock_get_time (clock), ...);
 *   gst_assert_cmpint (gst_pad_push (srcpad, buf), ==, GST_FLOW_OK);
 *
 *   GST_INFO ("Block until element is waiting for a clock notification\n");
 *   gst_test_clock_wait_for_next_pending_id (test_clock, &pending_id);
 *   GST_INFO ("Advance to the requested time of the clock notification\n");
 *   gst_test_clock_advance_time (test_clock, latency);
 *   GST_INFO ("Release the next blocking wait and make sure it is the one from element\n");
 *   processed_id = gst_test_clock_process_next_clock_id (test_clock);
 *   g_assert (processed_id == pending_id);
 *   g_assert_cmpint (GST_CLOCK_ENTRY_STATUS (processed_id), ==, GST_CLOCK_OK);
 *   gst_clock_id_unref (pending_id);
 *   gst_clock_id_unref (processed_id);
 *
 *   GST_INFO ("Validate that element produced an output buffer and check its timestamp\n");
 *   g_assert_cmpint (get_number_of_output_buffer (...), ==, 1);
 *   buf = get_buffer_pushed_by_element (element, ...);
 *   g_assert_cmpint (GST_BUFFER_TIMESTAMP (buf), ==, latency);
 *   gst_buffer_unref (buf);
 *   GST_INFO ("Check that element does not wait for any clock notification\n");
 *   g_assert (gst_test_clock_peek_next_pending_id (test_clock, NULL) == FALSE);
 *
 *   GST_INFO ("Set time, create and push the second buffer\n");
 *   gst_test_clock_advance_time (test_clock, 10 * GST_SECOND);
 *   buf = create_test_buffer (gst_clock_get_time (clock), ...);
 *   gst_assert_cmpint (gst_pad_push (srcpad, buf), ==, GST_FLOW_OK);
 *
 *   GST_INFO ("Block until element is waiting for a new clock notification\n");
 *   (gst_test_clock_wait_for_next_pending_id (test_clock, &pending_id);
 *   GST_INFO ("Advance past 7ms beyond the requested time of the clock notification\n");
 *   gst_test_clock_advance_time (test_clock, latency + 7 * GST_MSECOND);
 *   GST_INFO ("Release the next blocking wait and make sure it is the one from element\n");
 *   processed_id = gst_test_clock_process_next_clock_id (test_clock);
 *   g_assert (processed_id == pending_id);
 *   g_assert_cmpint (GST_CLOCK_ENTRY_STATUS (processed_id), ==, GST_CLOCK_OK);
 *   gst_clock_id_unref (pending_id);
 *   gst_clock_id_unref (processed_id);
 *
 *   GST_INFO ("Validate that element produced an output buffer and check its timestamp\n");
 *   g_assert_cmpint (get_number_of_output_buffer (...), ==, 1);
 *   buf = get_buffer_pushed_by_element (element, ...);
 *   g_assert_cmpint (GST_BUFFER_TIMESTAMP (buf), ==,
 *       10 * GST_SECOND + latency + 7 * GST_MSECOND);
 *   gst_buffer_unref (buf);
 *   GST_INFO ("Check that element does not wait for any clock notification\n");
 *   g_assert (gst_test_clock_peek_next_pending_id (test_clock, NULL) == FALSE);
 *   ...
 *   </programlisting>
 * </example>
 *
 * Since #GstTestClock is only supposed to be used in unit tests it calls
 * g_assert(), g_assert_cmpint() or g_assert_cmpuint() to validate all function
 * arguments. This will highlight any issues with the unit test code itself.
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include "gsttestclock.h"

enum
{
  PROP_0,
  PROP_START_TIME
};

typedef struct _GstClockEntryContext GstClockEntryContext;

struct _GstClockEntryContext
{
  GstClockEntry *clock_entry;
  GstClockTimeDiff time_diff;
};

struct _GstTestClockPrivate
{
  GstClockTime start_time;
  GstClockTime internal_time;
  GList *entry_contexts;
  GCond entry_added_cond;
  GCond entry_processed_cond;
};

#define GST_TEST_CLOCK_GET_PRIVATE(obj) ((GST_TEST_CLOCK_CAST (obj))->priv)

GST_DEBUG_CATEGORY_STATIC (test_clock_debug);
#define GST_CAT_TEST_CLOCK test_clock_debug

#define _do_init \
G_STMT_START { \
  GST_DEBUG_CATEGORY_INIT (test_clock_debug, "GST_TEST_CLOCK", \
      GST_DEBUG_BOLD, "Test clocks for unit tests"); \
} G_STMT_END

G_DEFINE_TYPE_WITH_CODE (GstTestClock, gst_test_clock,
    GST_TYPE_CLOCK, _do_init);

static GstObjectClass *parent_class = NULL;

static void gst_test_clock_constructed (GObject * object);
static void gst_test_clock_dispose (GObject * object);
static void gst_test_clock_finalize (GObject * object);
static void gst_test_clock_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec);
static void gst_test_clock_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec);

static GstClockTime gst_test_clock_get_resolution (GstClock * clock);
static GstClockTime gst_test_clock_get_internal_time (GstClock * clock);
static GstClockReturn gst_test_clock_wait (GstClock * clock,
    GstClockEntry * entry, GstClockTimeDiff * jitter);
static GstClockReturn gst_test_clock_wait_async (GstClock * clock,
    GstClockEntry * entry);
static void gst_test_clock_unschedule (GstClock * clock, GstClockEntry * entry);

static gboolean gst_test_clock_peek_next_pending_id_unlocked (GstTestClock *
    test_clock, GstClockID * pending_id);
static guint gst_test_clock_peek_id_count_unlocked (GstTestClock * test_clock);

static void gst_test_clock_add_entry (GstTestClock * test_clock,
    GstClockEntry * entry, GstClockTimeDiff * jitter);
static void gst_test_clock_remove_entry (GstTestClock * test_clock,
    GstClockEntry * entry);
static GstClockEntryContext *gst_test_clock_lookup_entry_context (GstTestClock *
    test_clock, GstClockEntry * clock_entry);

static gint gst_clock_entry_context_compare_func (gconstpointer a,
    gconstpointer b);

static void
gst_test_clock_class_init (GstTestClockClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstClockClass *gstclock_class = GST_CLOCK_CLASS (klass);
  GParamSpec *pspec;

  parent_class = g_type_class_peek_parent (klass);

  g_type_class_add_private (klass, sizeof (GstTestClockPrivate));

  gobject_class->constructed = GST_DEBUG_FUNCPTR (gst_test_clock_constructed);
  gobject_class->dispose = GST_DEBUG_FUNCPTR (gst_test_clock_dispose);
  gobject_class->finalize = GST_DEBUG_FUNCPTR (gst_test_clock_finalize);
  gobject_class->get_property = GST_DEBUG_FUNCPTR (gst_test_clock_get_property);
  gobject_class->set_property = GST_DEBUG_FUNCPTR (gst_test_clock_set_property);

  gstclock_class->get_resolution =
      GST_DEBUG_FUNCPTR (gst_test_clock_get_resolution);
  gstclock_class->get_internal_time =
      GST_DEBUG_FUNCPTR (gst_test_clock_get_internal_time);
  gstclock_class->wait = GST_DEBUG_FUNCPTR (gst_test_clock_wait);
  gstclock_class->wait_async = GST_DEBUG_FUNCPTR (gst_test_clock_wait_async);
  gstclock_class->unschedule = GST_DEBUG_FUNCPTR (gst_test_clock_unschedule);

  /**
   * GstTestClock:start-time:
   *
   * When a #GstTestClock is constructed it will have a certain start time set.
   * If the clock was created using gst_test_clock_new_with_start_time() then
   * this property contains the value of the @start_time argument. If
   * gst_test_clock_new() was called the clock started at time zero, and thus
   * this property contains the value 0.
   */
  pspec = g_param_spec_uint64 ("start-time", "Start Time",
      "Start Time of the Clock", 0, G_MAXUINT64, 0,
      G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT_ONLY);
  g_object_class_install_property (gobject_class, PROP_START_TIME, pspec);
}

static void
gst_test_clock_init (GstTestClock * test_clock)
{
  GstTestClockPrivate *priv;

  test_clock->priv = G_TYPE_INSTANCE_GET_PRIVATE (test_clock,
      GST_TYPE_TEST_CLOCK, GstTestClockPrivate);

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  g_cond_init (&priv->entry_added_cond);
  g_cond_init (&priv->entry_processed_cond);

  GST_OBJECT_FLAG_SET (test_clock,
      GST_CLOCK_FLAG_CAN_DO_SINGLE_SYNC |
      GST_CLOCK_FLAG_CAN_DO_SINGLE_ASYNC |
      GST_CLOCK_FLAG_CAN_DO_PERIODIC_SYNC |
      GST_CLOCK_FLAG_CAN_DO_PERIODIC_ASYNC);
}

static void
gst_test_clock_constructed (GObject * object)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (object);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  priv->internal_time = priv->start_time;

  G_OBJECT_CLASS (parent_class)->constructed (object);
}

static void
gst_test_clock_dispose (GObject * object)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (object);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  while (priv->entry_contexts != NULL) {
    GstClockEntryContext *ctx = priv->entry_contexts->data;
    gst_test_clock_remove_entry (test_clock, ctx->clock_entry);
  }

  GST_OBJECT_UNLOCK (test_clock);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_test_clock_finalize (GObject * object)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (object);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  g_cond_clear (&priv->entry_added_cond);
  g_cond_clear (&priv->entry_processed_cond);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_test_clock_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (object);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  switch (property_id) {
    case PROP_START_TIME:
      g_value_set_uint64 (value, priv->start_time);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

static void
gst_test_clock_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (object);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  switch (property_id) {
    case PROP_START_TIME:
      priv->start_time = g_value_get_uint64 (value);
      GST_CAT_TRACE_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
          "test clock start time initialized at %" GST_TIME_FORMAT,
          GST_TIME_ARGS (priv->start_time));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

static GstClockTime
gst_test_clock_get_resolution (GstClock * clock)
{
  (void) clock;
  return 1;
}

static GstClockTime
gst_test_clock_get_internal_time (GstClock * clock)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (clock);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GstClockTime result;

  GST_OBJECT_LOCK (test_clock);

  GST_CAT_TRACE_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "retrieving test clock time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (priv->internal_time));
  result = priv->internal_time;

  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

static GstClockReturn
gst_test_clock_wait (GstClock * clock,
    GstClockEntry * entry, GstClockTimeDiff * jitter)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (clock);
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "requesting synchronous clock notification at %" GST_TIME_FORMAT,
      GST_TIME_ARGS (GST_CLOCK_ENTRY_TIME (entry)));

  if (GST_CLOCK_ENTRY_STATUS (entry) == GST_CLOCK_UNSCHEDULED)
    goto was_unscheduled;

  if (gst_test_clock_lookup_entry_context (test_clock, entry) == NULL)
    gst_test_clock_add_entry (test_clock, entry, jitter);

  GST_CLOCK_ENTRY_STATUS (entry) = GST_CLOCK_BUSY;

  while (GST_CLOCK_ENTRY_STATUS (entry) == GST_CLOCK_BUSY)
    g_cond_wait (&priv->entry_processed_cond, GST_OBJECT_GET_LOCK (test_clock));

  GST_OBJECT_UNLOCK (test_clock);

  return GST_CLOCK_ENTRY_STATUS (entry);

  /* ERRORS */
was_unscheduled:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
        "entry was unscheduled");
    GST_OBJECT_UNLOCK (test_clock);
    return GST_CLOCK_UNSCHEDULED;
  }
}

static GstClockReturn
gst_test_clock_wait_async (GstClock * clock, GstClockEntry * entry)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (clock);

  GST_OBJECT_LOCK (test_clock);

  if (GST_CLOCK_ENTRY_STATUS (entry) == GST_CLOCK_UNSCHEDULED)
    goto was_unscheduled;

  GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "requesting asynchronous clock notification at %" GST_TIME_FORMAT,
      GST_TIME_ARGS (GST_CLOCK_ENTRY_TIME (entry)));

  gst_test_clock_add_entry (test_clock, entry, NULL);

  GST_OBJECT_UNLOCK (test_clock);

  return GST_CLOCK_OK;

  /* ERRORS */
was_unscheduled:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
        "entry was unscheduled");
    GST_OBJECT_UNLOCK (test_clock);
    return GST_CLOCK_UNSCHEDULED;
  }
}

static void
gst_test_clock_unschedule (GstClock * clock, GstClockEntry * entry)
{
  GstTestClock *test_clock = GST_TEST_CLOCK (clock);

  GST_OBJECT_LOCK (test_clock);

  GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "unscheduling requested clock notification at %" GST_TIME_FORMAT,
      GST_TIME_ARGS (GST_CLOCK_ENTRY_TIME (entry)));

  GST_CLOCK_ENTRY_STATUS (entry) = GST_CLOCK_UNSCHEDULED;
  gst_test_clock_remove_entry (test_clock, entry);

  GST_OBJECT_UNLOCK (test_clock);
}

static gboolean
gst_test_clock_peek_next_pending_id_unlocked (GstTestClock * test_clock,
    GstClockID * pending_id)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GList *imminent_clock_id = g_list_first (priv->entry_contexts);
  gboolean result = FALSE;

  if (imminent_clock_id != NULL) {
    GstClockEntryContext *ctx = imminent_clock_id->data;

    if (pending_id != NULL) {
      *pending_id = gst_clock_id_ref (ctx->clock_entry);
    }

    result = TRUE;
  }

  return result;
}

static guint
gst_test_clock_peek_id_count_unlocked (GstTestClock * test_clock)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  return g_list_length (priv->entry_contexts);
}

static void
gst_test_clock_add_entry (GstTestClock * test_clock,
    GstClockEntry * entry, GstClockTimeDiff * jitter)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GstClockTime now;
  GstClockEntryContext *ctx;

  now = gst_clock_adjust_unlocked (GST_CLOCK (test_clock), priv->internal_time);

  if (jitter != NULL)
    *jitter = GST_CLOCK_DIFF (GST_CLOCK_ENTRY_TIME (entry), now);

  ctx = g_slice_new (GstClockEntryContext);
  ctx->clock_entry = GST_CLOCK_ENTRY (gst_clock_id_ref (entry));
  ctx->time_diff = GST_CLOCK_DIFF (now, GST_CLOCK_ENTRY_TIME (entry));

  priv->entry_contexts = g_list_insert_sorted (priv->entry_contexts, ctx,
      gst_clock_entry_context_compare_func);

  g_cond_broadcast (&priv->entry_added_cond);
}

static void
gst_test_clock_remove_entry (GstTestClock * test_clock, GstClockEntry * entry)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GstClockEntryContext *ctx;

  ctx = gst_test_clock_lookup_entry_context (test_clock, entry);
  if (ctx != NULL) {
    gst_clock_id_unref (ctx->clock_entry);
    priv->entry_contexts = g_list_remove (priv->entry_contexts, ctx);
    g_slice_free (GstClockEntryContext, ctx);

    g_cond_broadcast (&priv->entry_processed_cond);
  }
}

static GstClockEntryContext *
gst_test_clock_lookup_entry_context (GstTestClock * test_clock,
    GstClockEntry * clock_entry)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GstClockEntryContext *result = NULL;
  GList *cur;

  for (cur = priv->entry_contexts; cur != NULL; cur = cur->next) {
    GstClockEntryContext *ctx = cur->data;

    if (ctx->clock_entry == clock_entry) {
      result = ctx;
      break;
    }
  }

  return result;
}

static gint
gst_clock_entry_context_compare_func (gconstpointer a, gconstpointer b)
{
  const GstClockEntryContext *ctx_a = a;
  const GstClockEntryContext *ctx_b = b;

  return gst_clock_id_compare_func (ctx_a->clock_entry, ctx_b->clock_entry);
}

static void
process_entry_context_unlocked (GstTestClock * test_clock,
    GstClockEntryContext * ctx)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GstClockEntry *entry = ctx->clock_entry;

  if (ctx->time_diff >= 0)
    GST_CLOCK_ENTRY_STATUS (entry) = GST_CLOCK_OK;
  else
    GST_CLOCK_ENTRY_STATUS (entry) = GST_CLOCK_EARLY;

  if (entry->func != NULL) {
    GST_OBJECT_UNLOCK (test_clock);
    entry->func (GST_CLOCK (test_clock), priv->internal_time, entry,
        entry->user_data);
    GST_OBJECT_LOCK (test_clock);
  }

  gst_test_clock_remove_entry (test_clock, entry);

  if (GST_CLOCK_ENTRY_TYPE (entry) == GST_CLOCK_ENTRY_PERIODIC) {
    GST_CLOCK_ENTRY_TIME (entry) += GST_CLOCK_ENTRY_INTERVAL (entry);

    if (entry->func != NULL)
      gst_test_clock_add_entry (test_clock, entry, NULL);
  }
}

static GList *
gst_test_clock_get_pending_id_list_unlocked (GstTestClock * test_clock)
{
  GstTestClockPrivate *priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);
  GQueue queue = G_QUEUE_INIT;
  GList *cur;

  for (cur = priv->entry_contexts; cur != NULL; cur = cur->next) {
    GstClockEntryContext *ctx = cur->data;

    g_queue_push_tail (&queue, gst_clock_id_ref (ctx->clock_entry));
  }

  return queue.head;
}

/**
 * gst_test_clock_new:
 *
 * Creates a new test clock with its time set to zero.
 *
 * MT safe.
 *
 * Returns: (transfer full): a #GstTestClock cast to #GstClock.
 *
 * Since: 1.2
 */
GstClock *
gst_test_clock_new (void)
{
  return gst_test_clock_new_with_start_time (0);
}

/**
 * gst_test_clock_new_with_start_time:
 * @start_time: a #GstClockTime set to the desired start time of the clock.
 *
 * Creates a new test clock with its time set to the specified time.
 *
 * MT safe.
 *
 * Returns: (transfer full): a #GstTestClock cast to #GstClock.
 *
 * Since: 1.2
 */
GstClock *
gst_test_clock_new_with_start_time (GstClockTime start_time)
{
  g_assert_cmpuint (start_time, !=, GST_CLOCK_TIME_NONE);
  return g_object_new (GST_TYPE_TEST_CLOCK, "start-time", start_time, NULL);
}

/**
 * gst_test_clock_set_time:
 * @test_clock: a #GstTestClock of which to set the time
 * @new_time: a #GstClockTime later than that returned by gst_clock_get_time()
 *
 * Sets the time of @test_clock to the time given by @new_time. The time of
 * @test_clock is monotonically increasing, therefore providing a @new_time
 * which is earlier or equal to the time of the clock as given by
 * gst_clock_get_time() is a programming error.
 *
 * MT safe.
 *
 * Since: 1.2
 */
void
gst_test_clock_set_time (GstTestClock * test_clock, GstClockTime new_time)
{
  GstTestClockPrivate *priv;

  g_return_if_fail (GST_IS_TEST_CLOCK (test_clock));

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  g_assert_cmpuint (new_time, !=, GST_CLOCK_TIME_NONE);

  GST_OBJECT_LOCK (test_clock);

  g_assert_cmpuint (new_time, >=, priv->internal_time);

  priv->internal_time = new_time;
  GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "clock set to %" GST_TIME_FORMAT, GST_TIME_ARGS (new_time));

  GST_OBJECT_UNLOCK (test_clock);
}

/**
 * gst_test_clock_advance_time:
 * @test_clock: a #GstTestClock for which to increase the time
 * @delta: a positive #GstClockTimeDiff to be added to the time of the clock
 *
 * Advances the time of the @test_clock by the amount given by @delta. The
 * time of @test_clock is monotonically increasing, therefore providing a
 * @delta which is negative or zero is a programming error.
 *
 * MT safe.
 *
 * Since: 1.2
 */
void
gst_test_clock_advance_time (GstTestClock * test_clock, GstClockTimeDiff delta)
{
  GstTestClockPrivate *priv;

  g_return_if_fail (GST_IS_TEST_CLOCK (test_clock));

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  g_assert_cmpint (delta, >=, 0);
  g_assert_cmpuint (delta, <, G_MAXUINT64 - delta);

  GST_OBJECT_LOCK (test_clock);

  GST_CAT_DEBUG_OBJECT (GST_CAT_TEST_CLOCK, test_clock,
      "advancing clock by %" GST_TIME_FORMAT " to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (delta), GST_TIME_ARGS (priv->internal_time + delta));
  priv->internal_time += delta;

  GST_OBJECT_UNLOCK (test_clock);
}

/**
 * gst_test_clock_peek_id_count:
 * @test_clock: a #GstTestClock for which to count notifications
 *
 * Determine the number of pending clock notifications that have been
 * requested from the @test_clock.
 *
 * MT safe.
 *
 * Returns: the number of pending clock notifications.
 *
 * Since: 1.2
 */
guint
gst_test_clock_peek_id_count (GstTestClock * test_clock)
{
  guint result;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), 0);

  GST_OBJECT_LOCK (test_clock);
  result = gst_test_clock_peek_id_count_unlocked (test_clock);
  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_has_id:
 * @test_clock: a #GstTestClock to ask if it provided the notification
 * @id: (transfer none): a #GstClockID clock notification
 *
 * Checks whether @test_clock was requested to provide the clock notification
 * given by @id.
 *
 * MT safe.
 *
 * Returns: %TRUE if the clock has been asked to provide the given clock
 * notification, %FALSE otherwise.
 *
 * Since: 1.2
 */
gboolean
gst_test_clock_has_id (GstTestClock * test_clock, GstClockID id)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), FALSE);
  g_assert (id != NULL);

  GST_OBJECT_LOCK (test_clock);
  result = gst_test_clock_lookup_entry_context (test_clock, id) != NULL;
  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_peek_next_pending_id:
 * @test_clock: a #GstTestClock to check the clock notifications for
 * @pending_id: (allow-none) (out) (transfer full): a #GstClockID clock
 * notification to look for
 *
 * Determines if the @pending_id is the next clock notification scheduled to
 * be triggered given the current time of the @test_clock.
 *
 * MT safe.
 *
 * Return: %TRUE if @pending_id is the next clock notification to be
 * triggered, %FALSE otherwise.
 *
 * Since: 1.2
 */
gboolean
gst_test_clock_peek_next_pending_id (GstTestClock * test_clock,
    GstClockID * pending_id)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), FALSE);

  GST_OBJECT_LOCK (test_clock);
  result = gst_test_clock_peek_next_pending_id_unlocked (test_clock,
      pending_id);
  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_wait_for_next_pending_id:
 * @test_clock: #GstTestClock for which to get the pending clock notification
 * @pending_id: (allow-none) (out) (transfer full): #GstClockID
 * with information about the pending clock notification
 *
 * Waits until a clock notification is requested from @test_clock. There is no
 * timeout for this wait, see the main description of #GstTestClock. A reference
 * to the pending clock notification is stored in @pending_id.
 *
 * MT safe.
 *
 * Since: 1.2
 */
void
gst_test_clock_wait_for_next_pending_id (GstTestClock * test_clock,
    GstClockID * pending_id)
{
  GstTestClockPrivate *priv;

  g_return_if_fail (GST_IS_TEST_CLOCK (test_clock));

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  while (priv->entry_contexts == NULL)
    g_cond_wait (&priv->entry_added_cond, GST_OBJECT_GET_LOCK (test_clock));

  if (!gst_test_clock_peek_next_pending_id_unlocked (test_clock, pending_id))
    g_assert_not_reached ();

  GST_OBJECT_UNLOCK (test_clock);
}

/**
 * gst_test_clock_wait_for_pending_id_count:
 * @test_clock: #GstTestClock for which to await having enough pending clock
 * @count: the number of pending clock notifications to wait for
 *
 * Blocks until at least @count clock notifications have been requested from
 * @test_clock. There is no timeout for this wait, see the main description of
 * #GstTestClock.
 *
 * Since: 1.2
 *
 * Deprecated: use gst_test_clock_wait_for_multiple_pending_ids() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
void gst_test_clock_wait_for_pending_id_count (GstTestClock * test_clock,
    guint count);
#endif
void
gst_test_clock_wait_for_pending_id_count (GstTestClock * test_clock,
    guint count)
{
  gst_test_clock_wait_for_multiple_pending_ids (test_clock, count, NULL);
}
#endif

/**
 * gst_test_clock_process_next_clock_id:
 * @test_clock: a #GstTestClock for which to retrieve the next pending clock
 * notification
 *
 * MT safe.
 *
 * Returns: (transfer full): a #GstClockID containing the next pending clock
 * notification.
 *
 * Since: 1.2
 */
GstClockID
gst_test_clock_process_next_clock_id (GstTestClock * test_clock)
{
  GstTestClockPrivate *priv;
  GstClockID result = NULL;
  GstClockEntryContext *ctx = NULL;
  GList *cur;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), NULL);

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  for (cur = priv->entry_contexts; cur != NULL && result == NULL;
      cur = cur->next) {
    ctx = cur->data;

    if (priv->internal_time >= GST_CLOCK_ENTRY_TIME (ctx->clock_entry))
      result = gst_clock_id_ref (ctx->clock_entry);
  }

  if (result != NULL)
    process_entry_context_unlocked (test_clock, ctx);

  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_get_next_entry_time:
 * @test_clock: a #GstTestClock to fetch the next clock notification time for
 *
 * Retrieve the requested time for the next pending clock notification.
 *
 * MT safe.
 *
 * Returns: a #GstClockTime set to the time of the next pending clock
 * notification. If no clock notifications have been requested
 * %GST_CLOCK_TIME_NONE will be returned.
 *
 * Since: 1.2
 */
GstClockTime
gst_test_clock_get_next_entry_time (GstTestClock * test_clock)
{
  GstTestClockPrivate *priv;
  GstClockTime result = GST_CLOCK_TIME_NONE;
  GList *imminent_clock_id;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), GST_CLOCK_TIME_NONE);

  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  /* The list of pending clock notifications is sorted by time,
     so the most imminent one is the first one in the list. */
  imminent_clock_id = g_list_first (priv->entry_contexts);
  if (imminent_clock_id != NULL) {
    GstClockEntryContext *ctx = imminent_clock_id->data;
    result = GST_CLOCK_ENTRY_TIME (ctx->clock_entry);
  }

  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_wait_for_multiple_pending_ids:
 * @test_clock: #GstTestClock for which to await having enough pending clock
 * @count: the number of pending clock notifications to wait for
 * @pending_list: (out) (element-type Gst.ClockID) (transfer full) (allow-none): Address
 *     of a #GList pointer variable to store the list of pending #GstClockIDs
 *     that expired, or %NULL
 *
 * Blocks until at least @count clock notifications have been requested from
 * @test_clock. There is no timeout for this wait, see the main description of
 * #GstTestClock.
 *
 * MT safe.
 *
 * Since: 1.4
 */
void
gst_test_clock_wait_for_multiple_pending_ids (GstTestClock * test_clock,
    guint count, GList ** pending_list)
{
  GstTestClockPrivate *priv;

  g_return_if_fail (GST_IS_TEST_CLOCK (test_clock));
  priv = GST_TEST_CLOCK_GET_PRIVATE (test_clock);

  GST_OBJECT_LOCK (test_clock);

  while (g_list_length (priv->entry_contexts) < count)
    g_cond_wait (&priv->entry_added_cond, GST_OBJECT_GET_LOCK (test_clock));

  if (pending_list)
    *pending_list = gst_test_clock_get_pending_id_list_unlocked (test_clock);

  GST_OBJECT_UNLOCK (test_clock);
}

/**
 * gst_test_clock_process_id_list:
 * @test_clock: #GstTestClock for which to process the pending IDs
 * @pending_list: (element-type Gst.ClockID) (transfer none) (allow-none): List
 *     of pending #GstClockIDs
 *
 * Processes and releases the pending IDs in the list.
 *
 * MT safe.
 *
 * Since: 1.4
 */
guint
gst_test_clock_process_id_list (GstTestClock * test_clock,
    const GList * pending_list)
{
  const GList *cur;
  guint result = 0;

  g_return_val_if_fail (GST_IS_TEST_CLOCK (test_clock), 0);

  GST_OBJECT_LOCK (test_clock);

  for (cur = pending_list; cur != NULL; cur = cur->next) {
    GstClockID pending_id = cur->data;
    GstClockEntryContext *ctx =
        gst_test_clock_lookup_entry_context (test_clock, pending_id);
    if (ctx) {
      process_entry_context_unlocked (test_clock, ctx);
      result++;
    }
  }
  GST_OBJECT_UNLOCK (test_clock);

  return result;
}

/**
 * gst_test_clock_id_list_get_latest_time:
 * @pending_list:  (element-type Gst.ClockID) (transfer none) (allow-none): List
 *     of of pending #GstClockIDs
 *
 * Finds the latest time inside the list.
 *
 * MT safe.
 *
 * Since: 1.4
 */
GstClockTime
gst_test_clock_id_list_get_latest_time (const GList * pending_list)
{
  const GList *cur;
  GstClockTime result = 0;

  for (cur = pending_list; cur != NULL; cur = cur->next) {
    GstClockID *pending_id = cur->data;
    GstClockTime time = gst_clock_id_get_time (pending_id);
    if (time > result)
      result = time;
  }

  return result;
}
