/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstclock.h: Header for clock subsystem
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

#ifndef __GST_CLOCK_H__
#define __GST_CLOCK_H__

G_BEGIN_DECLS

/* --- standard type macros --- */
#define GST_TYPE_CLOCK                  (gst_clock_get_type ())
#define GST_CLOCK(clock)                (G_TYPE_CHECK_INSTANCE_CAST ((clock), GST_TYPE_CLOCK, GstClock))
#define GST_IS_CLOCK(clock)             (G_TYPE_CHECK_INSTANCE_TYPE ((clock), GST_TYPE_CLOCK))
#define GST_CLOCK_CLASS(cclass)         (G_TYPE_CHECK_CLASS_CAST ((cclass), GST_TYPE_CLOCK, GstClockClass))
#define GST_IS_CLOCK_CLASS(cclass)      (G_TYPE_CHECK_CLASS_TYPE ((cclass), GST_TYPE_CLOCK))
#define GST_CLOCK_GET_CLASS(clock)      (G_TYPE_INSTANCE_GET_CLASS ((clock), GST_TYPE_CLOCK, GstClockClass))
#define GST_CLOCK_CAST(clock)           ((GstClock*)(clock))

/**
 * GstClockTime:
 *
 * A datatype to hold a time, measured in nanoseconds.
 */
typedef guint64 GstClockTime;

/**
 * GST_TYPE_CLOCK_TIME:
 *
 * The #GType of a #GstClockTime.
 */
#define GST_TYPE_CLOCK_TIME G_TYPE_UINT64

/**
 * GstClockTimeDiff:
 *
 * A datatype to hold a time difference, measured in nanoseconds.
 */
typedef gint64 GstClockTimeDiff;
/**
 * GstClockID:
 *
 * A datatype to hold the handle to an outstanding sync or async clock callback.
 */
typedef gpointer GstClockID;

/**
 * GST_CLOCK_TIME_NONE:
 *
 * Constant to define an undefined clock time.
 *
 * Value: 18446744073709551615
 * Type: GstClockTime
 */
#define GST_CLOCK_TIME_NONE             ((GstClockTime) -1)
/**
 * GST_CLOCK_TIME_IS_VALID:
 * @time: clock time to validate
 *
 * Tests if a given #GstClockTime represents a valid defined time.
 */
#define GST_CLOCK_TIME_IS_VALID(time)   (((GstClockTime)(time)) != GST_CLOCK_TIME_NONE)

/* FIXME: still need to explicitly force types on the defines below */
/**
 * GST_SECOND:
 *
 * Constant that defines one GStreamer second.
 *
 * Value: 1000000000
 * Type: GstClockTime
 */
#define GST_SECOND  (G_USEC_PER_SEC * G_GINT64_CONSTANT (1000))
/**
 * GST_MSECOND:
 *
 * Constant that defines one GStreamer millisecond.
 *
 * Value: 1000000
 * Type: GstClockTime
 */
#define GST_MSECOND (GST_SECOND / G_GINT64_CONSTANT (1000))
/**
 * GST_USECOND:
 *
 * Constant that defines one GStreamer microsecond.
 *
 * Value: 1000
 * Type: GstClockTime
 */
#define GST_USECOND (GST_SECOND / G_GINT64_CONSTANT (1000000))
/**
 * GST_NSECOND:
 *
 * Constant that defines one GStreamer nanosecond
 *
 * Value: 1
 * Type: GstClockTime
 */
#define GST_NSECOND (GST_SECOND / G_GINT64_CONSTANT (1000000000))


/**
 * GST_TIME_AS_SECONDS:
 * @time: the time
 *
 * Convert a #GstClockTime to seconds.
 */
#define GST_TIME_AS_SECONDS(time)  ((time) / GST_SECOND)
/**
 * GST_TIME_AS_MSECONDS:
 * @time: the time
 *
 * Convert a #GstClockTime to milliseconds (1/1000 of a second).
 */
#define GST_TIME_AS_MSECONDS(time) ((time) / G_GINT64_CONSTANT (1000000))
/**
 * GST_TIME_AS_USECONDS:
 * @time: the time
 *
 * Convert a #GstClockTime to microseconds (1/1000000 of a second).
 */
#define GST_TIME_AS_USECONDS(time) ((time) / G_GINT64_CONSTANT (1000))
/**
 * GST_TIME_AS_NSECONDS:
 * @time: the time
 *
 * Convert a #GstClockTime to nanoseconds (1/1000000000 of a second).
 */
#define GST_TIME_AS_NSECONDS(time) (time)

/**
 * GST_CLOCK_DIFF:
 * @s: the first time
 * @e: the second time
 *
 * Calculate a difference between two clock times as a #GstClockTimeDiff.
 * The difference is calculated as @e - @s.
 */
#define GST_CLOCK_DIFF(s, e)            (GstClockTimeDiff)((e) - (s))

/**
 * GST_TIMEVAL_TO_TIME:
 * @tv: the timeval to convert
 *
 * Convert a #GTimeVal to a #GstClockTime.
 */
#define GST_TIMEVAL_TO_TIME(tv)         (GstClockTime)((tv).tv_sec * GST_SECOND + (tv).tv_usec * GST_USECOND)

/**
 * GST_TIME_TO_TIMEVAL:
 * @t: The #GstClockTime to convert
 * @tv: The target timeval
 *
 * Convert a #GstClockTime to a #GTimeVal
 *
 * <note>on 32-bit systems, a timeval has a range of only 2^32 - 1 seconds,
 * which is about 68 years.  Expect trouble if you want to schedule stuff
 * in your pipeline for 2038.</note>
 */
#define GST_TIME_TO_TIMEVAL(t,tv)                               \
G_STMT_START {                                                  \
  g_assert ("Value of time " #t " is out of timeval's range" && \
      ((t) / GST_SECOND) < G_MAXLONG);                          \
  (tv).tv_sec  = (glong) (((GstClockTime) (t)) / GST_SECOND);   \
  (tv).tv_usec = (glong) ((((GstClockTime) (t)) -               \
                  ((GstClockTime) (tv).tv_sec) * GST_SECOND)    \
                 / GST_USECOND);                                \
} G_STMT_END

/**
 * GST_TIMESPEC_TO_TIME:
 * @ts: the timespec to convert
 *
 * Convert a struct timespec (see man pselect) to a #GstClockTime.
 */
#define GST_TIMESPEC_TO_TIME(ts)        (GstClockTime)((ts).tv_sec * GST_SECOND + (ts).tv_nsec * GST_NSECOND)
/**
 * GST_TIME_TO_TIMESPEC:
 * @t: The #GstClockTime to convert
 * @ts: The target timespec
 *
 * Convert a #GstClockTime to a struct timespec (see man pselect)
 */
#define GST_TIME_TO_TIMESPEC(t,ts)                                \
G_STMT_START {                                                    \
  g_assert ("Value of time " #t " is out of timespec's range" &&  \
      ((t) / GST_SECOND) < G_MAXLONG);                            \
  (ts).tv_sec  =  (glong) ((t) / GST_SECOND);                     \
  (ts).tv_nsec = (glong) (((t) - (ts).tv_sec * GST_SECOND) / GST_NSECOND);        \
} G_STMT_END

/* timestamp debugging macros */
/**
 * GST_TIME_FORMAT:
 *
 * A string that can be used in printf-like format strings to display a
 * #GstClockTime value in h:m:s format.  Use GST_TIME_ARGS() to construct
 * the matching arguments.
 *
 * Example:
 * |[
 * printf("%" GST_TIME_FORMAT "\n", GST_TIME_ARGS(ts));
 * ]|
 */
#define GST_TIME_FORMAT "u:%02u:%02u.%09u"
/**
 * GST_TIME_ARGS:
 * @t: a #GstClockTime
 *
 * Format @t for the #GST_TIME_FORMAT format string. Note: @t will be
 * evaluated more than once.
 */
#define GST_TIME_ARGS(t) \
        GST_CLOCK_TIME_IS_VALID (t) ? \
        (guint) (((GstClockTime)(t)) / (GST_SECOND * 60 * 60)) : 99, \
        GST_CLOCK_TIME_IS_VALID (t) ? \
        (guint) ((((GstClockTime)(t)) / (GST_SECOND * 60)) % 60) : 99, \
        GST_CLOCK_TIME_IS_VALID (t) ? \
        (guint) ((((GstClockTime)(t)) / GST_SECOND) % 60) : 99, \
        GST_CLOCK_TIME_IS_VALID (t) ? \
        (guint) (((GstClockTime)(t)) % GST_SECOND) : 999999999

typedef struct _GstClockEntry   GstClockEntry;
typedef struct _GstClock        GstClock;
typedef struct _GstClockClass   GstClockClass;
typedef struct _GstClockPrivate GstClockPrivate;

/* --- prototype for async callbacks --- */
/**
 * GstClockCallback:
 * @clock: The clock that triggered the callback
 * @time: The time it was triggered
 * @id: The #GstClockID that expired
 * @user_data: user data passed in the gst_clock_id_wait_async() function
 *
 * The function prototype of the callback.
 *
 * Returns: %TRUE or %FALSE (currently unused)
 */
typedef gboolean        (*GstClockCallback)     (GstClock *clock, GstClockTime time,
                                                 GstClockID id, gpointer user_data);
/**
 * GstClockReturn:
 * @GST_CLOCK_OK: The operation succeeded.
 * @GST_CLOCK_EARLY: The operation was scheduled too late.
 * @GST_CLOCK_UNSCHEDULED: The clockID was unscheduled
 * @GST_CLOCK_BUSY: The ClockID is busy
 * @GST_CLOCK_BADTIME: A bad time was provided to a function.
 * @GST_CLOCK_ERROR: An error occurred
 * @GST_CLOCK_UNSUPPORTED: Operation is not supported
 * @GST_CLOCK_DONE: The ClockID is done waiting
 *
 * The return value of a clock operation.
 */
typedef enum
{
  GST_CLOCK_OK          =  0,
  GST_CLOCK_EARLY       =  1,
  GST_CLOCK_UNSCHEDULED =  2,
  GST_CLOCK_BUSY        =  3,
  GST_CLOCK_BADTIME     =  4,
  GST_CLOCK_ERROR       =  5,
  GST_CLOCK_UNSUPPORTED =  6,
  GST_CLOCK_DONE        =  7
} GstClockReturn;

/**
 * GstClockEntryType:
 * @GST_CLOCK_ENTRY_SINGLE: a single shot timeout
 * @GST_CLOCK_ENTRY_PERIODIC: a periodic timeout request
 *
 * The type of the clock entry
 */
typedef enum {
  GST_CLOCK_ENTRY_SINGLE,
  GST_CLOCK_ENTRY_PERIODIC
} GstClockEntryType;

/**
 * GST_CLOCK_ENTRY:
 * @entry: the entry to cast
 *
 * Cast to a clock entry
 */
#define GST_CLOCK_ENTRY(entry)          ((GstClockEntry *)(entry))
/**
 * GST_CLOCK_ENTRY_CLOCK:
 * @entry: the entry to query
 *
 * Get the owner clock of the entry
 */
#define GST_CLOCK_ENTRY_CLOCK(entry)    ((entry)->clock)
/**
 * GST_CLOCK_ENTRY_TYPE:
 * @entry: the entry to query
 *
 * Get the type of the clock entry
 */
#define GST_CLOCK_ENTRY_TYPE(entry)     ((entry)->type)
/**
 * GST_CLOCK_ENTRY_TIME:
 * @entry: the entry to query
 *
 * Get the requested time of this entry
 */
#define GST_CLOCK_ENTRY_TIME(entry)     ((entry)->time)
/**
 * GST_CLOCK_ENTRY_INTERVAL:
 * @entry: the entry to query
 *
 * Get the interval of this periodic entry
 */
#define GST_CLOCK_ENTRY_INTERVAL(entry) ((entry)->interval)
/**
 * GST_CLOCK_ENTRY_STATUS:
 * @entry: the entry to query
 *
 * The status of the entry
 */
#define GST_CLOCK_ENTRY_STATUS(entry)   ((entry)->status)

/**
 * GstClockEntry:
 * @refcount: reference counter (read-only)
 *
 * All pending timeouts or periodic notifies are converted into
 * an entry.
 * Note that GstClockEntry should be treated as an opaque structure. It must
 * not be extended or allocated using a custom allocator.
 */
struct _GstClockEntry {
  gint                  refcount;
  /*< protected >*/
  GstClock              *clock;
  GstClockEntryType      type;
  GstClockTime           time;
  GstClockTime           interval;
  GstClockReturn         status;
  GstClockCallback       func;
  gpointer               user_data;
  GDestroyNotify         destroy_data;
  gboolean               unscheduled;
  gboolean               woken_up;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

#include <gst/gstobject.h>

/**
 * GstClockFlags:
 * @GST_CLOCK_FLAG_CAN_DO_SINGLE_SYNC: clock can do a single sync timeout request
 * @GST_CLOCK_FLAG_CAN_DO_SINGLE_ASYNC: clock can do a single async timeout request
 * @GST_CLOCK_FLAG_CAN_DO_PERIODIC_SYNC: clock can do sync periodic timeout requests
 * @GST_CLOCK_FLAG_CAN_DO_PERIODIC_ASYNC: clock can do async periodic timeout callbacks
 * @GST_CLOCK_FLAG_CAN_SET_RESOLUTION: clock's resolution can be changed
 * @GST_CLOCK_FLAG_CAN_SET_MASTER: clock can be slaved to a master clock
 * @GST_CLOCK_FLAG_LAST: subclasses can add additional flags starting from this flag
 *
 * The capabilities of this clock
 */
typedef enum {
  GST_CLOCK_FLAG_CAN_DO_SINGLE_SYNC     = (GST_OBJECT_FLAG_LAST << 0),
  GST_CLOCK_FLAG_CAN_DO_SINGLE_ASYNC    = (GST_OBJECT_FLAG_LAST << 1),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_SYNC   = (GST_OBJECT_FLAG_LAST << 2),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_ASYNC  = (GST_OBJECT_FLAG_LAST << 3),
  GST_CLOCK_FLAG_CAN_SET_RESOLUTION     = (GST_OBJECT_FLAG_LAST << 4),
  GST_CLOCK_FLAG_CAN_SET_MASTER         = (GST_OBJECT_FLAG_LAST << 5),
  /* padding */
  GST_CLOCK_FLAG_LAST                   = (GST_OBJECT_FLAG_LAST << 8)
} GstClockFlags;

/**
 * GST_CLOCK_FLAGS:
 * @clock: the clock to query
 *
 * Gets the #GstClockFlags clock flags.
 */
#define GST_CLOCK_FLAGS(clock)  GST_OBJECT_FLAGS(clock)

/**
 * GstClock:
 *
 * #GstClock base structure. The values of this structure are
 * protected for subclasses, use the methods to use the #GstClock.
 */
struct _GstClock {
  GstObject      object;

  /*< private >*/
  GstClockPrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};

/**
 * GstClockClass:
 * @parent_class: the parent class structure
 * @change_resolution: change the resolution of the clock. Not all values might
 *                     be acceptable. The new resolution should be returned.
 * @get_resolution: get the resolution of the clock.
 * @get_internal_time: get the internal unadjusted time of the clock.
 *        implement @wait_jitter instead.
 * @wait: perform a blocking wait on the given #GstClockEntry and return
 *               the jitter.
 * @wait_async: perform an asynchronous wait for the given #GstClockEntry.
 * @unschedule: unblock a blocking or async wait operation.
 *
 * GStreamer clock class. Override the vmethods to implement the clock
 * functionality.
 */
struct _GstClockClass {
  GstObjectClass        parent_class;

  /*< public >*/
  /* vtable */
  GstClockTime          (*change_resolution)    (GstClock *clock,
                                                 GstClockTime old_resolution,
                                                 GstClockTime new_resolution);
  GstClockTime          (*get_resolution)       (GstClock *clock);

  GstClockTime          (*get_internal_time)    (GstClock *clock);

  /* waiting on an ID */
  GstClockReturn        (*wait)                 (GstClock *clock, GstClockEntry *entry,
                                                 GstClockTimeDiff *jitter);
  GstClockReturn        (*wait_async)           (GstClock *clock, GstClockEntry *entry);
  void                  (*unschedule)           (GstClock *clock, GstClockEntry *entry);

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

GType                   gst_clock_get_type              (void);

GstClockTime            gst_clock_set_resolution        (GstClock *clock,
                                                         GstClockTime resolution);
GstClockTime            gst_clock_get_resolution        (GstClock *clock);

GstClockTime            gst_clock_get_time              (GstClock *clock);
void                    gst_clock_set_calibration       (GstClock *clock, GstClockTime internal,
                                                         GstClockTime external,
                                                         GstClockTime rate_num,
                                                         GstClockTime rate_denom);
void                    gst_clock_get_calibration       (GstClock *clock, GstClockTime *internal,
                                                         GstClockTime *external,
                                                         GstClockTime *rate_num,
                                                         GstClockTime *rate_denom);

/* master/slave clocks */
gboolean                gst_clock_set_master            (GstClock *clock, GstClock *master);
GstClock*               gst_clock_get_master            (GstClock *clock);

void                    gst_clock_set_timeout           (GstClock *clock,
                                                         GstClockTime timeout);
GstClockTime            gst_clock_get_timeout           (GstClock *clock);

gboolean                gst_clock_add_observation       (GstClock *clock, GstClockTime slave,
                                                         GstClockTime master, gdouble *r_squared);


/* getting and adjusting internal/external time */
GstClockTime            gst_clock_get_internal_time     (GstClock *clock);
GstClockTime            gst_clock_adjust_unlocked       (GstClock *clock, GstClockTime internal);
GstClockTime            gst_clock_unadjust_unlocked     (GstClock * clock, GstClockTime external);


/* creating IDs that can be used to get notifications */
GstClockID              gst_clock_new_single_shot_id    (GstClock *clock,
                                                         GstClockTime time);
GstClockID              gst_clock_new_periodic_id       (GstClock *clock,
                                                         GstClockTime start_time,
                                                         GstClockTime interval);

/* reference counting */
GstClockID              gst_clock_id_ref                (GstClockID id);
void                    gst_clock_id_unref              (GstClockID id);

/* operations on IDs */
gint                    gst_clock_id_compare_func       (gconstpointer id1, gconstpointer id2);

GstClockTime            gst_clock_id_get_time           (GstClockID id);
GstClockReturn          gst_clock_id_wait               (GstClockID id,
                                                         GstClockTimeDiff *jitter);
GstClockReturn          gst_clock_id_wait_async         (GstClockID id,
                                                         GstClockCallback func,
                                                         gpointer user_data,
                                                         GDestroyNotify destroy_data);
void                    gst_clock_id_unschedule         (GstClockID id);

gboolean                gst_clock_single_shot_id_reinit (GstClock * clock,
                                                         GstClockID id,
                                                         GstClockTime time);
gboolean                gst_clock_periodic_id_reinit    (GstClock * clock,
                                                         GstClockID id,
                                                         GstClockTime start_time,
                                                         GstClockTime interval);

G_END_DECLS

#endif /* __GST_CLOCK_H__ */
