/* GStreamer
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include "glib-compat-private.h"
#include "gstdatetime.h"
#include "gstvalue.h"
#include <glib.h>
#include <math.h>
#include <stdio.h>

/**
 * SECTION:gstdatetime
 * @title: GstDateTime
 * @short_description: A date, time and timezone structure
 *
 * Struct to store date, time and timezone information altogether.
 * #GstDateTime is refcounted and immutable.
 *
 * Date information is handled using the proleptic Gregorian calendar.
 *
 * Provides basic creation functions and accessor functions to its fields.
 */

typedef enum
{
  GST_DATE_TIME_FIELDS_INVALID = 0,
  GST_DATE_TIME_FIELDS_Y,       /* have year                */
  GST_DATE_TIME_FIELDS_YM,      /* have year and month      */
  GST_DATE_TIME_FIELDS_YMD,     /* have year, month and day */
  GST_DATE_TIME_FIELDS_YMD_HM,
  GST_DATE_TIME_FIELDS_YMD_HMS
      /* Note: if we ever add more granularity here, e.g. for microsecs,
       * the compare function will need updating */
} GstDateTimeFields;

struct _GstDateTime
{
  GstMiniObject mini_object;

  GDateTime *datetime;

  GstDateTimeFields fields;
};

GType _gst_date_time_type = 0;
GST_DEFINE_MINI_OBJECT_TYPE (GstDateTime, gst_date_time);

static void gst_date_time_free (GstDateTime * datetime);

/**
 * gst_date_time_new_from_g_date_time:
 * @dt: (transfer full): the #GDateTime. The new #GstDateTime takes ownership.
 *
 * Creates a new #GstDateTime from a #GDateTime object.
 *
 * Free-function: gst_date_time_unref
 *
 * Returns: (transfer full) (nullable): a newly created #GstDateTime,
 * or %NULL on error
 */
GstDateTime *
gst_date_time_new_from_g_date_time (GDateTime * dt)
{
  GstDateTime *gst_dt;

  if (!dt)
    return NULL;

  gst_dt = g_slice_new (GstDateTime);

  gst_mini_object_init (GST_MINI_OBJECT_CAST (gst_dt), 0, GST_TYPE_DATE_TIME,
      NULL, NULL, (GstMiniObjectFreeFunction) gst_date_time_free);

  gst_dt->datetime = dt;
  gst_dt->fields = GST_DATE_TIME_FIELDS_YMD_HMS;
  return gst_dt;
}

/**
 * gst_date_time_to_g_date_time:
 * @datetime: GstDateTime.
 *
 * Creates a new #GDateTime from a fully defined #GstDateTime object.
 *
 * Free-function: g_date_time_unref
 *
 * Returns: (transfer full) (nullable): a newly created #GDateTime, or
 * %NULL on error
 */
GDateTime *
gst_date_time_to_g_date_time (GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, NULL);

  if (datetime->fields != GST_DATE_TIME_FIELDS_YMD_HMS)
    return NULL;

  return g_date_time_add (datetime->datetime, 0);
}

/**
 * gst_date_time_has_year:
 * @datetime: a #GstDateTime
 *
 * Returns: %TRUE if @datetime<!-- -->'s year field is set (which should always
 *     be the case), otherwise %FALSE
 */
gboolean
gst_date_time_has_year (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, FALSE);

  return (datetime->fields >= GST_DATE_TIME_FIELDS_Y);
}

/**
 * gst_date_time_has_month:
 * @datetime: a #GstDateTime
 *
 * Returns: %TRUE if @datetime<!-- -->'s month field is set, otherwise %FALSE
 */
gboolean
gst_date_time_has_month (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, FALSE);

  return (datetime->fields >= GST_DATE_TIME_FIELDS_YM);
}

/**
 * gst_date_time_has_day:
 * @datetime: a #GstDateTime
 *
 * Returns: %TRUE if @datetime<!-- -->'s day field is set, otherwise %FALSE
 */
gboolean
gst_date_time_has_day (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, FALSE);

  return (datetime->fields >= GST_DATE_TIME_FIELDS_YMD);
}

/**
 * gst_date_time_has_time:
 * @datetime: a #GstDateTime
 *
 * Returns: %TRUE if @datetime<!-- -->'s hour and minute fields are set,
 *     otherwise %FALSE
 */
gboolean
gst_date_time_has_time (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, FALSE);

  return (datetime->fields >= GST_DATE_TIME_FIELDS_YMD_HM);
}

/**
 * gst_date_time_has_second:
 * @datetime: a #GstDateTime
 *
 * Returns: %TRUE if @datetime<!-- -->'s second field is set, otherwise %FALSE
 */
gboolean
gst_date_time_has_second (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, FALSE);

  return (datetime->fields >= GST_DATE_TIME_FIELDS_YMD_HMS);
}

/**
 * gst_date_time_get_year:
 * @datetime: a #GstDateTime
 *
 * Returns the year of this #GstDateTime
 * Call gst_date_time_has_year before, to avoid warnings.
 *
 * Return value: The year of this #GstDateTime
 */
gint
gst_date_time_get_year (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);

  return g_date_time_get_year (datetime->datetime);
}

/**
 * gst_date_time_get_month:
 * @datetime: a #GstDateTime
 *
 * Returns the month of this #GstDateTime. January is 1, February is 2, etc..
 * Call gst_date_time_has_month before, to avoid warnings.
 *
 * Return value: The month of this #GstDateTime
 */
gint
gst_date_time_get_month (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_month (datetime), 0);

  return g_date_time_get_month (datetime->datetime);
}

/**
 * gst_date_time_get_day:
 * @datetime: a #GstDateTime
 *
 * Returns the day of the month of this #GstDateTime.
 * Call gst_date_time_has_day before, to avoid warnings.
 *
 * Return value: The day of this #GstDateTime
 */
gint
gst_date_time_get_day (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_day (datetime), 0);

  return g_date_time_get_day_of_month (datetime->datetime);
}

/**
 * gst_date_time_get_hour:
 * @datetime: a #GstDateTime
 *
 * Retrieves the hour of the day represented by @datetime in the gregorian
 * calendar. The return is in the range of 0 to 23.
 * Call gst_date_time_has_haur before, to avoid warnings.
 *
 * Return value: the hour of the day
 */
gint
gst_date_time_get_hour (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_time (datetime), 0);

  return g_date_time_get_hour (datetime->datetime);
}

/**
 * gst_date_time_get_minute:
 * @datetime: a #GstDateTime
 *
 * Retrieves the minute of the hour represented by @datetime in the gregorian
 * calendar.
 * Call gst_date_time_has_minute before, to avoid warnings.
 *
 * Return value: the minute of the hour
 */
gint
gst_date_time_get_minute (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_time (datetime), 0);

  return g_date_time_get_minute (datetime->datetime);
}

/**
 * gst_date_time_get_second:
 * @datetime: a #GstDateTime
 *
 * Retrieves the second of the minute represented by @datetime in the gregorian
 * calendar.
 * Call gst_date_time_has_second before, to avoid warnings.
 *
 * Return value: the second represented by @datetime
 */
gint
gst_date_time_get_second (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_second (datetime), 0);

  return g_date_time_get_second (datetime->datetime);
}

/**
 * gst_date_time_get_microsecond:
 * @datetime: a #GstDateTime
 *
 * Retrieves the fractional part of the seconds in microseconds represented by
 * @datetime in the gregorian calendar.
 *
 * Return value: the microsecond of the second
 */
gint
gst_date_time_get_microsecond (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0);
  g_return_val_if_fail (gst_date_time_has_second (datetime), 0);

  return g_date_time_get_microsecond (datetime->datetime);
}

/**
 * gst_date_time_get_time_zone_offset:
 * @datetime: a #GstDateTime
 *
 * Retrieves the offset from UTC in hours that the timezone specified
 * by @datetime represents. Timezones ahead (to the east) of UTC have positive
 * values, timezones before (to the west) of UTC have negative values.
 * If @datetime represents UTC time, then the offset is zero.
 *
 * Return value: the offset from UTC in hours
 */
gfloat
gst_date_time_get_time_zone_offset (const GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, 0.0);
  g_return_val_if_fail (gst_date_time_has_time (datetime), 0.0);

  return (g_date_time_get_utc_offset (datetime->datetime) /
      G_USEC_PER_SEC) / 3600.0;
}

/**
 * gst_date_time_new_y:
 * @year: the gregorian year
 *
 * Creates a new #GstDateTime using the date and times in the gregorian calendar
 * in the local timezone.
 *
 * @year should be from 1 to 9999.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_y (gint year)
{
  return gst_date_time_new (0.0, year, -1, -1, -1, -1, -1);
}

/**
 * gst_date_time_new_ym:
 * @year: the gregorian year
 * @month: the gregorian month
 *
 * Creates a new #GstDateTime using the date and times in the gregorian calendar
 * in the local timezone.
 *
 * @year should be from 1 to 9999, @month should be from 1 to 12.
 *
 * If value is -1 then all over value will be ignored. For example
 * if @month == -1, then #GstDateTime will created only for @year.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_ym (gint year, gint month)
{
  return gst_date_time_new (0.0, year, month, -1, -1, -1, -1);
}

/**
 * gst_date_time_new_ymd:
 * @year: the gregorian year
 * @month: the gregorian month
 * @day: the day of the gregorian month
 *
 * Creates a new #GstDateTime using the date and times in the gregorian calendar
 * in the local timezone.
 *
 * @year should be from 1 to 9999, @month should be from 1 to 12, @day from
 * 1 to 31.
 *
 * If value is -1 then all over value will be ignored. For example
 * if @month == -1, then #GstDateTime will created only for @year. If
 * @day == -1, then #GstDateTime will created for @year and @month and
 * so on.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_ymd (gint year, gint month, gint day)
{
  return gst_date_time_new (0.0, year, month, day, -1, -1, -1);
}

/**
 * gst_date_time_new_from_unix_epoch_local_time:
 * @secs: seconds from the Unix epoch
 *
 * Creates a new #GstDateTime using the time since Jan 1, 1970 specified by
 * @secs. The #GstDateTime is in the local timezone.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_from_unix_epoch_local_time (gint64 secs)
{
  GDateTime *datetime;

  datetime = g_date_time_new_from_unix_local (secs);
  return gst_date_time_new_from_g_date_time (datetime);
}

/**
 * gst_date_time_new_from_unix_epoch_utc:
 * @secs: seconds from the Unix epoch
 *
 * Creates a new #GstDateTime using the time since Jan 1, 1970 specified by
 * @secs. The #GstDateTime is in the UTC timezone.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_from_unix_epoch_utc (gint64 secs)
{
  GstDateTime *datetime;
  datetime =
      gst_date_time_new_from_g_date_time (g_date_time_new_from_unix_utc (secs));
  return datetime;
}

static GstDateTimeFields
gst_date_time_check_fields (gint * year, gint * month, gint * day,
    gint * hour, gint * minute, gdouble * seconds)
{
  if (*month == -1) {
    *month = *day = 1;
    *hour = *minute = *seconds = 0;
    return GST_DATE_TIME_FIELDS_Y;
  } else if (*day == -1) {
    *day = 1;
    *hour = *minute = *seconds = 0;
    return GST_DATE_TIME_FIELDS_YM;
  } else if (*hour == -1) {
    *hour = *minute = *seconds = 0;
    return GST_DATE_TIME_FIELDS_YMD;
  } else if (*seconds == -1) {
    *seconds = 0;
    return GST_DATE_TIME_FIELDS_YMD_HM;
  } else
    return GST_DATE_TIME_FIELDS_YMD_HMS;
}

/**
 * gst_date_time_new_local_time:
 * @year: the gregorian year
 * @month: the gregorian month, or -1
 * @day: the day of the gregorian month, or -1
 * @hour: the hour of the day, or -1
 * @minute: the minute of the hour, or -1
 * @seconds: the second of the minute, or -1
 *
 * Creates a new #GstDateTime using the date and times in the gregorian calendar
 * in the local timezone.
 *
 * @year should be from 1 to 9999, @month should be from 1 to 12, @day from
 * 1 to 31, @hour from 0 to 23, @minutes and @seconds from 0 to 59.
 *
 * If @month is -1, then the #GstDateTime created will only contain @year,
 * and all other fields will be considered not set.
 *
 * If @day is -1, then the #GstDateTime created will only contain @year and
 * @month and all other fields will be considered not set.
 *
 * If @hour is -1, then the #GstDateTime created will only contain @year and
 * @month and @day, and the time fields will be considered not set. In this
 * case @minute and @seconds should also be -1.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new_local_time (gint year, gint month, gint day, gint hour,
    gint minute, gdouble seconds)
{
  GstDateTimeFields fields;
  GstDateTime *datetime;

  g_return_val_if_fail (year > 0 && year <= 9999, NULL);
  g_return_val_if_fail ((month > 0 && month <= 12) || month == -1, NULL);
  g_return_val_if_fail ((day > 0 && day <= 31) || day == -1, NULL);
  g_return_val_if_fail ((hour >= 0 && hour < 24) || hour == -1, NULL);
  g_return_val_if_fail ((minute >= 0 && minute < 60) || minute == -1, NULL);
  g_return_val_if_fail ((seconds >= 0 && seconds < 60) || seconds == -1, NULL);

  fields = gst_date_time_check_fields (&year, &month, &day,
      &hour, &minute, &seconds);

  datetime = gst_date_time_new_from_g_date_time (g_date_time_new_local (year,
          month, day, hour, minute, seconds));

  datetime->fields = fields;
  return datetime;
}

/**
 * gst_date_time_new_now_local_time:
 *
 * Creates a new #GstDateTime representing the current date and time.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime which should
 *     be freed with gst_date_time_unref().
 */
GstDateTime *
gst_date_time_new_now_local_time (void)
{
  return gst_date_time_new_from_g_date_time (g_date_time_new_now_local ());
}

/**
 * gst_date_time_new_now_utc:
 *
 * Creates a new #GstDateTime that represents the current instant at Universal
 * coordinated time.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime which should
 *   be freed with gst_date_time_unref().
 */
GstDateTime *
gst_date_time_new_now_utc (void)
{
  return gst_date_time_new_from_g_date_time (g_date_time_new_now_utc ());
}

gint
__gst_date_time_compare (const GstDateTime * dt1, const GstDateTime * dt2)
{
  gint64 diff;

  /* we assume here that GST_DATE_TIME_FIELDS_YMD_HMS is the highest
   * resolution, and ignore microsecond differences on purpose for now */
  if (dt1->fields != dt2->fields)
    return GST_VALUE_UNORDERED;

  /* This will round down to nearest second, which is what we want. We're
   * not comparing microseconds on purpose here, since we're not
   * serialising them when doing new_utc_now() + to_string() */
  diff =
      g_date_time_to_unix (dt1->datetime) - g_date_time_to_unix (dt2->datetime);
  if (diff < 0)
    return GST_VALUE_LESS_THAN;
  else if (diff > 0)
    return GST_VALUE_GREATER_THAN;
  else
    return GST_VALUE_EQUAL;
}

/**
 * gst_date_time_new:
 * @tzoffset: Offset from UTC in hours.
 * @year: the gregorian year
 * @month: the gregorian month
 * @day: the day of the gregorian month
 * @hour: the hour of the day
 * @minute: the minute of the hour
 * @seconds: the second of the minute
 *
 * Creates a new #GstDateTime using the date and times in the gregorian calendar
 * in the supplied timezone.
 *
 * @year should be from 1 to 9999, @month should be from 1 to 12, @day from
 * 1 to 31, @hour from 0 to 23, @minutes and @seconds from 0 to 59.
 *
 * Note that @tzoffset is a float and was chosen so for being able to handle
 * some fractional timezones, while it still keeps the readability of
 * representing it in hours for most timezones.
 *
 * If value is -1 then all over value will be ignored. For example
 * if @month == -1, then #GstDateTime will created only for @year. If
 * @day == -1, then #GstDateTime will created for @year and @month and
 * so on.
 *
 * Free-function: gst_date_time_unref
 *
 * Return value: (transfer full): the newly created #GstDateTime
 */
GstDateTime *
gst_date_time_new (gfloat tzoffset, gint year, gint month, gint day, gint hour,
    gint minute, gdouble seconds)
{
  GstDateTimeFields fields;
  gchar buf[6];
  GTimeZone *tz;
  GDateTime *dt;
  GstDateTime *datetime;
  gint tzhour, tzminute;

  g_return_val_if_fail (year > 0 && year <= 9999, NULL);
  g_return_val_if_fail ((month > 0 && month <= 12) || month == -1, NULL);
  g_return_val_if_fail ((day > 0 && day <= 31) || day == -1, NULL);
  g_return_val_if_fail ((hour >= 0 && hour < 24) || hour == -1, NULL);
  g_return_val_if_fail ((minute >= 0 && minute < 60) || minute == -1, NULL);
  g_return_val_if_fail ((seconds >= 0 && seconds < 60) || seconds == -1, NULL);
  g_return_val_if_fail (tzoffset >= -12.0 && tzoffset <= 12.0, NULL);
  g_return_val_if_fail ((hour >= 0 && minute >= 0) ||
      (hour == -1 && minute == -1 && seconds == -1 && tzoffset == 0.0), NULL);

  tzhour = (gint) ABS (tzoffset);
  tzminute = (gint) ((ABS (tzoffset) - tzhour) * 60);

  g_snprintf (buf, 6, "%c%02d%02d", tzoffset >= 0 ? '+' : '-', tzhour,
      tzminute);

  tz = g_time_zone_new (buf);

  fields = gst_date_time_check_fields (&year, &month, &day,
      &hour, &minute, &seconds);

  dt = g_date_time_new (tz, year, month, day, hour, minute, seconds);
  g_time_zone_unref (tz);

  datetime = gst_date_time_new_from_g_date_time (dt);
  datetime->fields = fields;

  return datetime;
}

gchar *
__gst_date_time_serialize (GstDateTime * datetime, gboolean serialize_usecs)
{
  GString *s;
  gfloat gmt_offset;
  guint msecs;

  /* we always have at least the year */
  s = g_string_new (NULL);
  g_string_append_printf (s, "%04u", gst_date_time_get_year (datetime));

  if (datetime->fields == GST_DATE_TIME_FIELDS_Y)
    goto done;

  /* add month */
  g_string_append_printf (s, "-%02u", gst_date_time_get_month (datetime));

  if (datetime->fields == GST_DATE_TIME_FIELDS_YM)
    goto done;

  /* add day of month */
  g_string_append_printf (s, "-%02u", gst_date_time_get_day (datetime));

  if (datetime->fields == GST_DATE_TIME_FIELDS_YMD)
    goto done;

  /* add time */
  g_string_append_printf (s, "T%02u:%02u", gst_date_time_get_hour (datetime),
      gst_date_time_get_minute (datetime));

  if (datetime->fields == GST_DATE_TIME_FIELDS_YMD_HM)
    goto add_timezone;

  /* add seconds */
  g_string_append_printf (s, ":%02u", gst_date_time_get_second (datetime));

  /* add microseconds */
  if (serialize_usecs) {
    msecs = gst_date_time_get_microsecond (datetime);
    if (msecs != 0) {
      g_string_append_printf (s, ".%06u", msecs);
      /* trim trailing 0s */
      while (s->str[s->len - 1] == '0')
        g_string_truncate (s, s->len - 1);
    }
  }

  /* add timezone */

add_timezone:

  gmt_offset = gst_date_time_get_time_zone_offset (datetime);
  if (gmt_offset == 0) {
    g_string_append_c (s, 'Z');
  } else {
    guint tzhour, tzminute;

    tzhour = (guint) ABS (gmt_offset);
    tzminute = (guint) ((ABS (gmt_offset) - tzhour) * 60);

    g_string_append_c (s, (gmt_offset >= 0) ? '+' : '-');
    g_string_append_printf (s, "%02u%02u", tzhour, tzminute);
  }

done:

  return g_string_free (s, FALSE);
}

/**
 * gst_date_time_to_iso8601_string:
 * @datetime: GstDateTime.
 *
 * Create a minimal string compatible with ISO-8601. Possible output formats
 * are (for example): 2012, 2012-06, 2012-06-23, 2012-06-23T23:30Z,
 * 2012-06-23T23:30+0100, 2012-06-23T23:30:59Z, 2012-06-23T23:30:59+0100
 *
 * Returns: (nullable): a newly allocated string formatted according
 *     to ISO 8601 and only including the datetime fields that are
 *     valid, or %NULL in case there was an error. The string should
 *     be freed with g_free().
 */
gchar *
gst_date_time_to_iso8601_string (GstDateTime * datetime)
{
  g_return_val_if_fail (datetime != NULL, NULL);

  if (datetime->fields == GST_DATE_TIME_FIELDS_INVALID)
    return NULL;

  return __gst_date_time_serialize (datetime, FALSE);
}

/**
 * gst_date_time_new_from_iso8601_string:
 * @string: ISO 8601-formatted datetime string.
 *
 * Tries to parse common variants of ISO-8601 datetime strings into a
 * #GstDateTime.
 *
 * Free-function: gst_date_time_unref
 *
 * Returns: (transfer full) (nullable): a newly created #GstDateTime,
 * or %NULL on error
 */
GstDateTime *
gst_date_time_new_from_iso8601_string (const gchar * string)
{
  gint year = -1, month = -1, day = -1, hour = -1, minute = -1;
  gdouble second = -1.0;
  gfloat tzoffset = 0.0;
  guint64 usecs;
  gint len, ret;

  g_return_val_if_fail (string != NULL, NULL);

  GST_DEBUG ("Parsing '%s' into a datetime", string);

  len = strlen (string);

  if (len < 4 || !g_ascii_isdigit (string[0]) || !g_ascii_isdigit (string[1])
      || !g_ascii_isdigit (string[2]) || !g_ascii_isdigit (string[3]))
    return NULL;

  ret = sscanf (string, "%04d-%02d-%02d", &year, &month, &day);

  if (ret == 0)
    return NULL;

  if (ret == 3 && day <= 0) {
    ret = 2;
    day = -1;
  }

  if (ret >= 2 && month <= 0) {
    ret = 1;
    month = day = -1;
  }

  if (ret >= 1 && year <= 0)
    return NULL;

  else if (ret >= 1 && len < 16)
    /* YMD is 10 chars. XMD + HM will be 16 chars. if it is less,
     * it make no sense to continue. We will stay with YMD. */
    goto ymd;

  string += 10;
  /* Exit if there is no expeceted value on this stage */
  if (!(*string == 'T' || *string == '-' || *string == ' '))
    goto ymd;

  /* if hour or minute fails, then we will use onlly ymd. */
  hour = g_ascii_strtoull (string + 1, (gchar **) & string, 10);
  if (hour > 24 || *string != ':')
    goto ymd;

  /* minute */
  minute = g_ascii_strtoull (string + 1, (gchar **) & string, 10);
  if (minute > 59)
    goto ymd;

  /* second */
  if (*string == ':') {
    second = g_ascii_strtoull (string + 1, (gchar **) & string, 10);
    /* if we fail here, we still can reuse hour and minute. We
     * will still attempt to parse any timezone information */
    if (second > 59) {
      second = -1.0;
    } else {
      /* microseconds */
      if (*string == '.' || *string == ',') {
        const gchar *usec_start = string + 1;
        guint digits;

        usecs = g_ascii_strtoull (string + 1, (gchar **) & string, 10);
        if (usecs != G_MAXUINT64 && string > usec_start) {
          digits = (guint) (string - usec_start);
          second += (gdouble) usecs / pow (10.0, digits);
        }
      }
    }
  }

  if (*string == 'Z')
    goto ymd_hms;
  else {
    /* reuse some code from gst-plugins-base/gst-libs/gst/tag/gstxmptag.c */
    gint gmt_offset_hour = -1, gmt_offset_min = -1, gmt_offset = -1;
    gchar *plus_pos = NULL;
    gchar *neg_pos = NULL;
    gchar *pos = NULL;

    GST_LOG ("Checking for timezone information");

    /* check if there is timezone info */
    plus_pos = strrchr (string, '+');
    neg_pos = strrchr (string, '-');
    if (plus_pos)
      pos = plus_pos + 1;
    else if (neg_pos)
      pos = neg_pos + 1;

    if (pos) {
      gint ret_tz;
      if (pos[2] == ':')
        ret_tz = sscanf (pos, "%d:%d", &gmt_offset_hour, &gmt_offset_min);
      else
        ret_tz = sscanf (pos, "%02d%02d", &gmt_offset_hour, &gmt_offset_min);

      GST_DEBUG ("Parsing timezone: %s", pos);

      if (ret_tz == 2) {
        gmt_offset = gmt_offset_hour * 60 + gmt_offset_min;
        if (neg_pos != NULL && neg_pos + 1 == pos)
          gmt_offset *= -1;

        tzoffset = gmt_offset / 60.0;

        GST_LOG ("Timezone offset: %f (%d minutes)", tzoffset, gmt_offset);
      } else
        GST_WARNING ("Failed to parse timezone information");
    }
  }

ymd_hms:
  return gst_date_time_new (tzoffset, year, month, day, hour, minute, second);
ymd:
  return gst_date_time_new_ymd (year, month, day);
}

static void
gst_date_time_free (GstDateTime * datetime)
{
  g_date_time_unref (datetime->datetime);
  g_slice_free (GstDateTime, datetime);
}

/**
 * gst_date_time_ref:
 * @datetime: a #GstDateTime
 *
 * Atomically increments the reference count of @datetime by one.
 *
 * Return value: (transfer full): the reference @datetime
 */
GstDateTime *
gst_date_time_ref (GstDateTime * datetime)
{
  return (GstDateTime *) gst_mini_object_ref (GST_MINI_OBJECT_CAST (datetime));
}

/**
 * gst_date_time_unref:
 * @datetime: (transfer full): a #GstDateTime
 *
 * Atomically decrements the reference count of @datetime by one.  When the
 * reference count reaches zero, the structure is freed.
 */
void
gst_date_time_unref (GstDateTime * datetime)
{
  gst_mini_object_unref (GST_MINI_OBJECT_CAST (datetime));
}

void
_priv_gst_date_time_initialize (void)
{
  _gst_date_time_type = gst_date_time_get_type ();
}
