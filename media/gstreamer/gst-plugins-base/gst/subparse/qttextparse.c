/* GStreamer QTtext subtitle parser
 * Copyright (c) 2009 Thiago Santos <thiago.sousa.santos collabora co uk>>
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

/* References:
 * http://www.apple.com/quicktime/tutorials/texttracks.html
 * http://www.apple.com/quicktime/tutorials/textdescriptors.html
 */

#include "qttextparse.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MIN_TO_NSEC  (60 * GST_SECOND)
#define HOUR_TO_NSEC (60 * MIN_TO_NSEC)

#define GST_QTTEXT_CONTEXT(state) ((GstQTTextContext *) (state)->user_data)

typedef struct _GstQTTextContext GstQTTextContext;

struct _GstQTTextContext
{
  /* timing variables */
  gint timescale;
  gboolean absolute;
  guint64 start_time;

  gboolean markup_open;
  gboolean need_markup;

  gchar *font;
  gint font_size;
  gchar *bg_color;
  gchar *fg_color;

  gboolean bold;
  gboolean italic;
};

void
qttext_context_init (ParserState * state)
{
  GstQTTextContext *context;

  state->user_data = g_new0 (GstQTTextContext, 1);

  context = GST_QTTEXT_CONTEXT (state);

  /* we use 1000 as a default */
  context->timescale = 1000;
  context->absolute = TRUE;

  context->markup_open = FALSE;
  context->need_markup = FALSE;

  context->font_size = 12;
}

void
qttext_context_deinit (ParserState * state)
{
  if (state->user_data != NULL) {
    GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);
    g_free (context->font);
    g_free (context->bg_color);
    g_free (context->fg_color);

    g_free (state->user_data);
    state->user_data = NULL;
  }
}

/*
 * Reads the string right after the ':'
 */
static gchar *
read_str (const gchar * line, const gchar * end)
{
  gint index = 0;

  while (line[index] != ':' && line[index] != '}') {
    index++;
  }
  if (line[index] != ':')
    return NULL;
  index++;
  while (line[index] == ' ')
    index++;

  return g_strndup (line + index, (end - (line + index)));
}

/* search for the ':' and parse the number right after it */
static gint
read_int (const gchar * line)
{
  gint index = 0;
  while (line[index] != ':' && line[index] != '}') {
    index++;
  }
  if (line[index] != ':')
    return 0;
  index++;
  return atoi (line + index);
}

/* skip the ':' and then match the following string
 * with 'match', but only if it before 'upto' */
static gboolean
string_match (const gchar * line, const gchar * match, const gchar * upto)
{
  gchar *result = strstr (line, match);
  return (result < upto);
}

/*
 * Reads the color values and stores them in r, g and b.
 */
static gboolean
read_color (const gchar * line, gint * r, gint * g, gint * b)
{
  gint index = 0;
  while (line[index] != ':' && line[index] != '}') {
    index++;
  }
  if (line[index] != ':')
    return FALSE;
  index++;

  *r = atoi (line + index);

  while (line[index] != '}' && line[index] != ',') {
    index++;
  }
  if (line[index] != ',')
    return FALSE;
  index++;

  *g = atoi (line + index);

  while (line[index] != '}' && line[index] != ',') {
    index++;
  }
  if (line[index] != ',')
    return FALSE;
  index++;

  *b = atoi (line + index);

  return TRUE;
}

static gchar *
make_color (gint r, gint g, gint b)
{
  /* qttext goes up to 65535, while pango goes to 255 */
  r /= 256;
  g /= 256;
  b /= 256;
  return g_strdup_printf ("#%02X%02X%02X", r, g, b);
}

static gboolean
qttext_parse_tag (ParserState * state, const gchar * line, gint * index)
{
  gchar *next;
  gint next_index;
  gint aux;
  gchar *str;
  gint r, g, b;
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);

  g_assert (line[*index] == '{');

  next = strchr (line + *index, '}');
  if (next == NULL) {
    goto error_out;
  } else {
    next_index = 1 + (next - line);
  }
  g_assert (line[next_index - 1] == '}');

  *index = *index + 1;          /* skip the { */

  /* now identify our tag */
  /* FIXME: those should be case unsensitive */
  /* TODO: there are other tags that could be added here */
  if (strncmp (line + *index, "QTtext", 6) == 0) {
    /* NOP */

  } else if (strncmp (line + *index, "font", 4) == 0) {
    str = read_str (line + *index + 4, line + next_index - 1);
    if (str) {
      g_free (context->font);
      context->font = str;
      context->need_markup = TRUE;
      GST_DEBUG ("Setting qttext font to %s", str);
    } else {
      GST_WARNING ("Failed to parse qttext font at line: %s", line);
    }

  } else if (strncmp (line + *index, "size", 4) == 0) {
    aux = read_int (line + *index + 4);
    if (aux == 0) {
      GST_WARNING ("Invalid size at line %s, using 12", line);
      context->font_size = 12;
    } else {
      GST_DEBUG ("Setting qttext font-size to: %d", aux);
      context->font_size = aux;
    }
    context->need_markup = TRUE;

  } else if (strncmp (line + *index, "textColor", 9) == 0) {
    if (read_color (line + *index + 9, &r, &g, &b)) {
      context->fg_color = make_color (r, g, b);
      GST_DEBUG ("Setting qttext fg color to %s", context->fg_color);
    } else {
      GST_WARNING ("Failed to read textColor at line %s", line);
    }
    context->need_markup = TRUE;

  } else if (strncmp (line + *index, "backColor", 9) == 0) {
    if (read_color (line + *index + 9, &r, &g, &b)) {
      context->bg_color = make_color (r, g, b);
      GST_DEBUG ("Setting qttext bg color to %s", context->bg_color);
    } else {
      GST_WARNING ("Failed to read backColor at line %s, disabling", line);
      g_free (context->bg_color);
      context->bg_color = NULL;
    }
    context->need_markup = TRUE;

  } else if (strncmp (line + *index, "plain", 5) == 0) {
    context->bold = FALSE;
    context->italic = FALSE;
    context->need_markup = TRUE;
    GST_DEBUG ("Setting qttext style to plain");

  } else if (strncmp (line + *index, "bold", 4) == 0) {
    context->bold = TRUE;
    context->italic = FALSE;
    context->need_markup = TRUE;
    GST_DEBUG ("Setting qttext style to bold");

  } else if (strncmp (line + *index, "italic", 6) == 0) {
    context->bold = FALSE;
    context->italic = TRUE;
    context->need_markup = TRUE;
    GST_DEBUG ("Setting qttext style to italic");

  } else if (strncmp (line + *index, "timescale", 9) == 0) {
    aux = read_int (line + *index + 9);
    if (aux == 0) {
      GST_WARNING ("Couldn't interpret timescale at line %s, using 1000", line);
      context->timescale = 1000;
    } else {
      GST_DEBUG ("Setting qttext timescale to: %d", aux);
      context->timescale = aux;
    }

  } else if (strncmp (line + *index, "timestamps", 10) == 0) {
    if (string_match (line + *index + 10, "relative", line + next_index)) {
      GST_DEBUG ("Setting qttext timestamps to relative");
      context->absolute = FALSE;
    } else {
      /* call it absolute otherwise */
      GST_DEBUG ("Setting qttext timestamps to absolute");
      context->absolute = TRUE;
    }

  } else {
    GST_WARNING ("Unused qttext tag starting at: %s", line + *index);
  }

  *index = next_index;
  return TRUE;

error_out:
  {
    GST_WARNING ("Failed to parse qttext tag at line %s", line);
    return FALSE;
  }
}

static guint64
qttext_parse_timestamp (ParserState * state, const gchar * line, gint index)
{
  int ret;
  gint hour, min, sec, dec;
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);

  ret = sscanf (line + index, "[%d:%d:%d.%d]", &hour, &min, &sec, &dec);
  if (ret != 3 && ret != 4) {
    /* bad timestamp */
    GST_WARNING ("Bad qttext timestamp found: %s", line);
    return 0;
  }

  if (ret == 3) {
    /* be forgiving for missing decimal part */
    dec = 0;
  }

  /* parse the decimal part according to the timescale */
  g_assert (context->timescale != 0);
  dec = (GST_SECOND * dec) / context->timescale;

  /* return the result */
  return hour * HOUR_TO_NSEC + min * MIN_TO_NSEC + sec * GST_SECOND + dec;
}

static void
qttext_open_markup (ParserState * state)
{
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);

  g_string_append (state->buf, "<span");

  /* add your markup tags here */
  if (context->font)
    g_string_append_printf (state->buf, " font='%s %d'", context->font,
        context->font_size);
  else
    g_string_append_printf (state->buf, " font='%d'", context->font_size);

  if (context->bg_color)
    g_string_append_printf (state->buf, " bgcolor='%s'", context->bg_color);
  if (context->fg_color)
    g_string_append_printf (state->buf, " color='%s'", context->fg_color);

  if (context->bold)
    g_string_append (state->buf, " weight='bold'");
  if (context->italic)
    g_string_append (state->buf, " style='italic'");

  g_string_append (state->buf, ">");
}

static void
qttext_prepare_text (ParserState * state)
{
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);
  if (state->buf == NULL) {
    state->buf = g_string_sized_new (256);      /* this should be enough */
  } else {
    g_string_append (state->buf, "\n");
  }

  /* if needed, add pango markup */
  if (context->need_markup) {
    if (context->markup_open) {
      g_string_append (state->buf, "</span>");
    }
    qttext_open_markup (state);
    context->markup_open = TRUE;
  }
}

static void
qttext_parse_text (ParserState * state, const gchar * line, gint index)
{
  qttext_prepare_text (state);
  g_string_append (state->buf, line + index);
}

static gchar *
qttext_get_text (ParserState * state)
{
  gchar *ret;
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);
  if (state->buf == NULL)
    return NULL;

  if (context->markup_open) {
    g_string_append (state->buf, "</span>");
  }
  ret = g_string_free (state->buf, FALSE);
  state->buf = NULL;
  context->markup_open = FALSE;
  return ret;
}

gchar *
parse_qttext (ParserState * state, const gchar * line)
{
  gint i;
  guint64 ts;
  gchar *ret = NULL;
  GstQTTextContext *context = GST_QTTEXT_CONTEXT (state);

  i = 0;
  while (line[i] != '\0') {
    /* find first interesting character from 'i' onwards */

    if (line[i] == '{') {
      /* this is a tag, parse it */
      if (!qttext_parse_tag (state, line, &i)) {
        break;
      }
    } else if (line[i] == '[') {
      /* this is a time, convert it to a timestamp */
      ts = qttext_parse_timestamp (state, line, i);

      /* check if we have pending text to send, in case we prepare it */
      if (state->buf) {
        ret = qttext_get_text (state);
        if (context->absolute)
          state->duration = ts - context->start_time;
        else
          state->duration = ts;
        state->start_time = context->start_time;
      }
      state->buf = NULL;

      if (ts == 0) {
        /* this is an error */
      } else {
        if (context->absolute)
          context->start_time = ts;
        else
          context->start_time += ts;
      }

      /* we assume there is nothing else on this line */
      break;

    } else if (line[i] == ' ' || line[i] == '\t') {
      i++;                      /* NOP */
    } else {
      /* this is the actual text, output the rest of the line as it */
      qttext_parse_text (state, line, i);
      break;
    }
  }
  return ret;
}
