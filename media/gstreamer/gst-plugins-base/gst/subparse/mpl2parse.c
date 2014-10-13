/* GStreamer mpl2 format subtitle parser
 * Copyright (C) 2006 Kamil Pawlowski <kamilpe gmail com>
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

#include "mpl2parse.h"

#include <stdio.h>
#include <string.h>

/* From http://lists.mplayerhq.hu/pipermail/mplayer-users/2003-February/030222.html
 *
 * [123][456] Sample subtitle
 * [1234][5678] Line 1|Line 2
 * [12345][67890] /Italic|Normal
 * [12345][67890] /Italic|/Italic
 * [12345][67890] Normal|/Italic 
 *
 * (The space between the last ']' bracket and the text appears to be optional)
 */

static gchar *
mpl2_parse_line (ParserState * state, const gchar * line, guint line_num)
{
  GString *markup;
  gint dc_start, dc_stop;

  /* parse subtitle file line */
  if (sscanf (line, "[%u][%u]", &dc_start, &dc_stop) != 2) {
    GST_WARNING ("failed to extract timestamps for line '%s'", line);
    return NULL;
  }

  GST_LOG ("line format %u %u", dc_start, dc_stop);
  state->start_time = GST_SECOND / 10 * dc_start;
  state->duration = (GST_SECOND / 10 * dc_stop) - state->start_time;

  /* skip brackets with timestamps */
  line = strchr (line, ']') + 1;
  line = strchr (line, ']') + 1;

  markup = g_string_new (NULL);

  while (1) {
    const gchar *sep;
    gchar *line_chunk_escaped;
    gboolean italics;

    /* skip leading white spaces */
    while (*line == ' ' || *line == '\t')
      ++line;

    /* a '/' at the beginning indicates italics */
    if (*line == '/') {
      italics = TRUE;
      g_string_append (markup, "<i>");
      ++line;
    } else {
      italics = FALSE;
    }

    if ((sep = strchr (line, '|')))
      line_chunk_escaped = g_markup_escape_text (line, sep - line);
    else
      line_chunk_escaped = g_markup_escape_text (line, -1);

    GST_LOG ("escaped line: %s", line_chunk_escaped);
    g_string_append (markup, line_chunk_escaped);

    g_free (line_chunk_escaped);

    if (italics)
      g_string_append (markup, "</i>");
    if (sep == NULL)
      break;

    /* move after the '|' and append another line */
    g_string_append (markup, "\n");
    line = sep + 1;
  }

  return g_strstrip (g_string_free (markup, FALSE));
}

gchar *
parse_mpl2 (ParserState * state, const gchar * line)
{
  gchar *ret;

  ret = mpl2_parse_line (state, line, state->state);
  ++state->state;
  return ret;
}
