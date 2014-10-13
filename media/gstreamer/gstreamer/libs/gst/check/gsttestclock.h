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

#ifndef __GST_TEST_CLOCK_H__
#define __GST_TEST_CLOCK_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_TEST_CLOCK (gst_test_clock_get_type ())
#define GST_TEST_CLOCK(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj),\
    GST_TYPE_TEST_CLOCK, GstTestClock))
#define GST_IS_TEST_CLOCK(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj),\
    GST_TYPE_TEST_CLOCK))
#define GST_TEST_CLOCK_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass),\
    GST_TYPE_TEST_CLOCK, GstTestClockClass))
#define GST_IS_TEST_CLOCK_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE (\
    (klass), GST_TYPE_TEST_CLOCK))
#define GST_TEST_CLOCK_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS (\
    (obj), GST_TYPE_TEST_CLOCK, GstTestClockClass))
#define GST_TEST_CLOCK_CAST(obj) ((GstTestClock*)(obj))

typedef struct _GstTestClock GstTestClock;
typedef struct _GstTestClockClass GstTestClockClass;
typedef struct _GstTestClockPrivate GstTestClockPrivate;

/**
 * GstTestClock:
 *
 * A #GstTestClock structure which is based on a #GstClock along with some
 * private data.
 *
 * Since: 1.2
 */
struct _GstTestClock
{
  GstClock parent;

  /*< private >*/
  GstTestClockPrivate *priv;
};

/**
 * GstTestClockClass:
 * @parent_class: the parent class structure
 *
 * The class of a #GstTestClock, which has no virtual methods to override.
 *
 * Since: 1.2
 */
struct _GstTestClockClass
{
  GstClockClass parent_class;
};

GType         gst_test_clock_get_type (void);

GstClock *    gst_test_clock_new (void);

GstClock *    gst_test_clock_new_with_start_time (GstClockTime start_time);

void          gst_test_clock_set_time (GstTestClock * test_clock,
                                      GstClockTime   new_time);

void          gst_test_clock_advance_time (GstTestClock *   test_clock,
                                          GstClockTimeDiff delta);

guint         gst_test_clock_peek_id_count (GstTestClock * test_clock);

gboolean      gst_test_clock_has_id (GstTestClock * test_clock, GstClockID id);

gboolean      gst_test_clock_peek_next_pending_id (GstTestClock * test_clock,
                                                   GstClockID   * pending_id);

void          gst_test_clock_wait_for_next_pending_id (GstTestClock * test_clock,
                                                       GstClockID   * pending_id);

#ifndef GST_DISABLE_DEPRECATED
void          gst_test_clock_wait_for_pending_id_count (GstTestClock * test_clock,
                                                        guint          count);
#endif

GstClockID    gst_test_clock_process_next_clock_id (GstTestClock * test_clock);

GstClockTime  gst_test_clock_get_next_entry_time   (GstTestClock * test_clock);

void          gst_test_clock_wait_for_multiple_pending_ids (GstTestClock * test_clock,
                                                            guint          count,
                                                            GList       ** pending_list);

guint         gst_test_clock_process_id_list (GstTestClock * test_clock,
                                              const GList  * pending_list);

GstClockTime  gst_test_clock_id_list_get_latest_time (const GList * pending_list);

G_END_DECLS

#endif /* __GST_TEST_CLOCK_H__ */
