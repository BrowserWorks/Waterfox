/* GStreamer SAMI subtitle parser
 * Copyright (c) 2006, 2013 Young-Ho Cha <ganadist at gmail com>
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

#include "samiparse.h"

#include <glib.h>
#include <string.h>
#include <stdlib.h>

#define ITALIC_TAG 'i'
#define SPAN_TAG   's'
#define RUBY_TAG   'r'
#define RT_TAG     't'
#define CLEAR_TAG  '0'

typedef struct _HtmlParser HtmlParser;
typedef struct _HtmlContext HtmlContext;
typedef struct _GstSamiContext GstSamiContext;

struct _GstSamiContext
{
  GString *buf;                 /* buffer to collect content */
  GString *rubybuf;             /* buffer to collect ruby content */
  GString *resultbuf;           /* when opening the next 'sync' tag, move
                                 * from 'buf' to avoid to append following
                                 * content */
  GString *state;               /* in many sami files there are tags that
                                 * are not closed, so for each open tag the
                                 * parser will append a tag flag here so
                                 * that tags can be closed properly on
                                 * 'sync' tags. See _context_push_state()
                                 * and _context_pop_state(). */
  HtmlContext *htmlctxt;        /* html parser context */
  gboolean has_result;          /* set when ready to push out result */
  gboolean in_sync;             /* flag to avoid appending anything except the
                                 * content of the sync elements to buf */
  guint64 time1;                /* previous start attribute in sync tag */
  guint64 time2;                /* current start attribute in sync tag  */
};

struct _HtmlParser
{
  void (*start_element) (HtmlContext * ctx,
      const gchar * name, const gchar ** attr, gpointer user_data);
  void (*end_element) (HtmlContext * ctx,
      const gchar * name, gpointer user_data);
  void (*text) (HtmlContext * ctx,
      const gchar * text, gsize text_len, gpointer user_data);
};

struct _HtmlContext
{
  const HtmlParser *parser;
  gpointer user_data;
  GString *buf;
};

static HtmlContext *
html_context_new (HtmlParser * parser, gpointer user_data)
{
  HtmlContext *ctxt = (HtmlContext *) g_new0 (HtmlContext, 1);
  ctxt->parser = parser;
  ctxt->user_data = user_data;
  ctxt->buf = g_string_new (NULL);
  return ctxt;
}

static void
html_context_free (HtmlContext * ctxt)
{
  g_string_free (ctxt->buf, TRUE);
  g_free (ctxt);
}

struct EntityMap
{
  const gunichar unescaped;
  const gchar *escaped;
};

struct EntityMap XmlEntities[] = {
  {34, "quot;"},
  {38, "amp;"},
  {39, "apos;"},
  {60, "lt;"},
  {62, "gt;"},
  {0, NULL},
};

struct EntityMap HtmlEntities[] = {
/* nbsp will handle manually
{ 160,	"nbsp;" }, */
  {161, "iexcl;"},
  {162, "cent;"},
  {163, "pound;"},
  {164, "curren;"},
  {165, "yen;"},
  {166, "brvbar;"},
  {167, "sect;"},
  {168, "uml;"},
  {169, "copy;"},
  {170, "ordf;"},
  {171, "laquo;"},
  {172, "not;"},
  {173, "shy;"},
  {174, "reg;"},
  {175, "macr;"},
  {176, "deg;"},
  {177, "plusmn;"},
  {178, "sup2;"},
  {179, "sup3;"},
  {180, "acute;"},
  {181, "micro;"},
  {182, "para;"},
  {183, "middot;"},
  {184, "cedil;"},
  {185, "sup1;"},
  {186, "ordm;"},
  {187, "raquo;"},
  {188, "frac14;"},
  {189, "frac12;"},
  {190, "frac34;"},
  {191, "iquest;"},
  {192, "Agrave;"},
  {193, "Aacute;"},
  {194, "Acirc;"},
  {195, "Atilde;"},
  {196, "Auml;"},
  {197, "Aring;"},
  {198, "AElig;"},
  {199, "Ccedil;"},
  {200, "Egrave;"},
  {201, "Eacute;"},
  {202, "Ecirc;"},
  {203, "Euml;"},
  {204, "Igrave;"},
  {205, "Iacute;"},
  {206, "Icirc;"},
  {207, "Iuml;"},
  {208, "ETH;"},
  {209, "Ntilde;"},
  {210, "Ograve;"},
  {211, "Oacute;"},
  {212, "Ocirc;"},
  {213, "Otilde;"},
  {214, "Ouml;"},
  {215, "times;"},
  {216, "Oslash;"},
  {217, "Ugrave;"},
  {218, "Uacute;"},
  {219, "Ucirc;"},
  {220, "Uuml;"},
  {221, "Yacute;"},
  {222, "THORN;"},
  {223, "szlig;"},
  {224, "agrave;"},
  {225, "aacute;"},
  {226, "acirc;"},
  {227, "atilde;"},
  {228, "auml;"},
  {229, "aring;"},
  {230, "aelig;"},
  {231, "ccedil;"},
  {232, "egrave;"},
  {233, "eacute;"},
  {234, "ecirc;"},
  {235, "euml;"},
  {236, "igrave;"},
  {237, "iacute;"},
  {238, "icirc;"},
  {239, "iuml;"},
  {240, "eth;"},
  {241, "ntilde;"},
  {242, "ograve;"},
  {243, "oacute;"},
  {244, "ocirc;"},
  {245, "otilde;"},
  {246, "ouml;"},
  {247, "divide;"},
  {248, "oslash;"},
  {249, "ugrave;"},
  {250, "uacute;"},
  {251, "ucirc;"},
  {252, "uuml;"},
  {253, "yacute;"},
  {254, "thorn;"},
  {255, "yuml;"},
  {338, "OElig;"},
  {339, "oelig;"},
  {352, "Scaron;"},
  {353, "scaron;"},
  {376, "Yuml;"},
  {402, "fnof;"},
  {710, "circ;"},
  {732, "tilde;"},
  {913, "Alpha;"},
  {914, "Beta;"},
  {915, "Gamma;"},
  {916, "Delta;"},
  {917, "Epsilon;"},
  {918, "Zeta;"},
  {919, "Eta;"},
  {920, "Theta;"},
  {921, "Iota;"},
  {922, "Kappa;"},
  {923, "Lambda;"},
  {924, "Mu;"},
  {925, "Nu;"},
  {926, "Xi;"},
  {927, "Omicron;"},
  {928, "Pi;"},
  {929, "Rho;"},
  {931, "Sigma;"},
  {932, "Tau;"},
  {933, "Upsilon;"},
  {934, "Phi;"},
  {935, "Chi;"},
  {936, "Psi;"},
  {937, "Omega;"},
  {945, "alpha;"},
  {946, "beta;"},
  {947, "gamma;"},
  {948, "delta;"},
  {949, "epsilon;"},
  {950, "zeta;"},
  {951, "eta;"},
  {952, "theta;"},
  {953, "iota;"},
  {954, "kappa;"},
  {955, "lambda;"},
  {956, "mu;"},
  {957, "nu;"},
  {958, "xi;"},
  {959, "omicron;"},
  {960, "pi;"},
  {961, "rho;"},
  {962, "sigmaf;"},
  {963, "sigma;"},
  {964, "tau;"},
  {965, "upsilon;"},
  {966, "phi;"},
  {967, "chi;"},
  {968, "psi;"},
  {969, "omega;"},
  {977, "thetasym;"},
  {978, "upsih;"},
  {982, "piv;"},
  {8194, "ensp;"},
  {8195, "emsp;"},
  {8201, "thinsp;"},
  {8204, "zwnj;"},
  {8205, "zwj;"},
  {8206, "lrm;"},
  {8207, "rlm;"},
  {8211, "ndash;"},
  {8212, "mdash;"},
  {8216, "lsquo;"},
  {8217, "rsquo;"},
  {8218, "sbquo;"},
  {8220, "ldquo;"},
  {8221, "rdquo;"},
  {8222, "bdquo;"},
  {8224, "dagger;"},
  {8225, "Dagger;"},
  {8226, "bull;"},
  {8230, "hellip;"},
  {8240, "permil;"},
  {8242, "prime;"},
  {8243, "Prime;"},
  {8249, "lsaquo;"},
  {8250, "rsaquo;"},
  {8254, "oline;"},
  {8260, "frasl;"},
  {8364, "euro;"},
  {8465, "image;"},
  {8472, "weierp;"},
  {8476, "real;"},
  {8482, "trade;"},
  {8501, "alefsym;"},
  {8592, "larr;"},
  {8593, "uarr;"},
  {8594, "rarr;"},
  {8595, "darr;"},
  {8596, "harr;"},
  {8629, "crarr;"},
  {8656, "lArr;"},
  {8657, "uArr;"},
  {8658, "rArr;"},
  {8659, "dArr;"},
  {8660, "hArr;"},
  {8704, "forall;"},
  {8706, "part;"},
  {8707, "exist;"},
  {8709, "empty;"},
  {8711, "nabla;"},
  {8712, "isin;"},
  {8713, "notin;"},
  {8715, "ni;"},
  {8719, "prod;"},
  {8721, "sum;"},
  {8722, "minus;"},
  {8727, "lowast;"},
  {8730, "radic;"},
  {8733, "prop;"},
  {8734, "infin;"},
  {8736, "ang;"},
  {8743, "and;"},
  {8744, "or;"},
  {8745, "cap;"},
  {8746, "cup;"},
  {8747, "int;"},
  {8756, "there4;"},
  {8764, "sim;"},
  {8773, "cong;"},
  {8776, "asymp;"},
  {8800, "ne;"},
  {8801, "equiv;"},
  {8804, "le;"},
  {8805, "ge;"},
  {8834, "sub;"},
  {8835, "sup;"},
  {8836, "nsub;"},
  {8838, "sube;"},
  {8839, "supe;"},
  {8853, "oplus;"},
  {8855, "otimes;"},
  {8869, "perp;"},
  {8901, "sdot;"},
  {8968, "lceil;"},
  {8969, "rceil;"},
  {8970, "lfloor;"},
  {8971, "rfloor;"},
  {9001, "lang;"},
  {9002, "rang;"},
  {9674, "loz;"},
  {9824, "spades;"},
  {9827, "clubs;"},
  {9829, "hearts;"},
  {9830, "diams;"},
  {0, NULL},
};

static gchar *
unescape_string (const gchar * text)
{
  gint i;
  GString *unescaped = g_string_new (NULL);

  while (*text) {
    if (*text == '&') {
      text++;

      /* unescape &nbsp and &nbsp; */
      if (!g_ascii_strncasecmp (text, "nbsp", 4)) {
        unescaped = g_string_append_unichar (unescaped, 160);
        text += 4;
        if (*text == ';') {
          text++;
        }
        goto next;
      }

      /* pass xml entities. these will be processed as pango markup */
      for (i = 0; XmlEntities[i].escaped; i++) {
        gssize len = strlen (XmlEntities[i].escaped);
        if (!g_ascii_strncasecmp (text, XmlEntities[i].escaped, len)) {
          unescaped = g_string_append_c (unescaped, '&');
          unescaped =
              g_string_append_len (unescaped, XmlEntities[i].escaped, len);
          text += len;
          goto next;
        }
      }

      /* convert html entities */
      for (i = 0; HtmlEntities[i].escaped; i++) {
        gssize len = strlen (HtmlEntities[i].escaped);
        if (!strncmp (text, HtmlEntities[i].escaped, len)) {
          unescaped =
              g_string_append_unichar (unescaped, HtmlEntities[i].unescaped);
          text += len;
          goto next;
        }
      }

      if (*text == '#') {
        gboolean is_hex = FALSE;
        gunichar l;
        gchar *end = NULL;

        text++;
        if (*text == 'x') {
          is_hex = TRUE;
          text++;
        }
        errno = 0;
        if (is_hex) {
          l = strtoul (text, &end, 16);
        } else {
          l = strtoul (text, &end, 10);
        }

        if (text == end || errno != 0) {
          /* error occured. pass it */
          goto next;
        }
        unescaped = g_string_append_unichar (unescaped, l);
        text = end;

        if (*text == ';') {
          text++;
        }
        goto next;
      }

      /* escape & */
      unescaped = g_string_append (unescaped, "&amp;");

    next:
      continue;

    } else if (g_ascii_isspace (*text)) {
      unescaped = g_string_append_c (unescaped, ' ');
      /* strip whitespace */
      do {
        text++;
      } while ((*text) && g_ascii_isspace (*text));
    } else {
      unescaped = g_string_append_c (unescaped, *text);
      text++;
    }
  }

  return g_string_free (unescaped, FALSE);
}

static const gchar *
string_token (const gchar * string, const gchar * delimiter, gchar ** first)
{
  gchar *next = strstr (string, delimiter);
  if (next) {
    *first = g_strndup (string, next - string);
  } else {
    *first = g_strdup (string);
  }
  return next;
}

static void
html_context_handle_element (HtmlContext * ctxt,
    const gchar * string, gboolean must_close)
{
  gchar *name = NULL;
  gint count = 0, i;
  gchar **attrs;
  const gchar *found, *next;

  /* split element name and attributes */
  next = string_token (string, " ", &name);

  if (next) {
    /* count attributes */
    found = next + 1;
    while (TRUE) {
      found = strchr (found, '=');
      if (!found)
        break;
      found++;
      count++;
    }
  } else {
    count = 0;
  }

  attrs = g_new0 (gchar *, (count + 1) * 2);

  for (i = 0; i < count && next != NULL; i += 2) {
    gchar *attr_name = NULL, *attr_value = NULL;
    gsize length;
    next = string_token (next + 1, "=", &attr_name);
    next = string_token (next + 1, " ", &attr_value);

    /* strip " or ' from attribute value */
    if (attr_value[0] == '"' || attr_value[0] == '\'') {
      gchar *tmp = g_strdup (attr_value + 1);
      g_free (attr_value);
      attr_value = tmp;
    }

    length = strlen (attr_value);
    if (attr_value[length - 1] == '"' || attr_value[length - 1] == '\'') {
      attr_value[length - 1] = '\0';
    }

    attrs[i] = attr_name;
    attrs[i + 1] = attr_value;
  }

  ctxt->parser->start_element (ctxt, name,
      (const gchar **) attrs, ctxt->user_data);
  if (must_close) {
    ctxt->parser->end_element (ctxt, name, ctxt->user_data);
  }
  g_strfreev (attrs);
  g_free (name);
}

static void
html_context_parse (HtmlContext * ctxt, gchar * text, gsize text_len)
{
  const gchar *next = NULL;
  ctxt->buf = g_string_append_len (ctxt->buf, text, text_len);
  next = ctxt->buf->str;
  while (TRUE) {
    if (next[0] == '<') {
      gchar *element = NULL;
      /* find <blahblah> */
      if (!strchr (next, '>')) {
        /* no tag end point. buffer will be process in next time */
        return;
      }

      next = string_token (next, ">", &element);
      next++;
      if (g_str_has_suffix (next, "/")) {
        /* handle <blah/> */
        element[strlen (element) - 1] = '\0';
        html_context_handle_element (ctxt, element + 1, TRUE);
      } else if (element[1] == '/') {
        /* handle </blah> */
        ctxt->parser->end_element (ctxt, element + 2, ctxt->user_data);
      } else {
        /* handle <blah> */
        html_context_handle_element (ctxt, element + 1, FALSE);
      }
      g_free (element);
    } else if (strchr (next, '<')) {
      gchar *text = NULL;
      gsize length;
      next = string_token (next, "<", &text);
      text = g_strstrip (text);
      length = strlen (text);
      ctxt->parser->text (ctxt, text, length, ctxt->user_data);
      g_free (text);

    } else {
      gchar *text = (gchar *) next;
      gsize length;
      text = g_strstrip (text);
      length = strlen (text);
      ctxt->parser->text (ctxt, text, length, ctxt->user_data);
      ctxt->buf = g_string_assign (ctxt->buf, "");
      return;
    }
  }

  ctxt->buf = g_string_assign (ctxt->buf, next);
}

static gchar *
has_tag (GString * str, const gchar tag)
{
  return strrchr (str->str, tag);
}

static void
sami_context_push_state (GstSamiContext * sctx, char state)
{
  GST_LOG ("state %c", state);
  g_string_append_c (sctx->state, state);
}

static void
sami_context_pop_state (GstSamiContext * sctx, char state)
{
  GString *str = g_string_new ("");
  GString *context_state = sctx->state;
  int i;

  GST_LOG ("state %c", state);
  for (i = context_state->len - 1; i >= 0; i--) {
    switch (context_state->str[i]) {
      case ITALIC_TAG:         /* <i> */
      {
        g_string_append (str, "</i>");
        break;
      }
      case SPAN_TAG:           /* <span foreground= > */
      {
        g_string_append (str, "</span>");
        break;
      }
      case RUBY_TAG:           /* <span size= >  -- ruby */
      {
        break;
      }
      case RT_TAG:             /*  ruby */
      {
        /* FIXME: support for furigana/ruby once implemented in pango */
        g_string_append (sctx->rubybuf, "</span>");
        if (has_tag (context_state, ITALIC_TAG)) {
          g_string_append (sctx->rubybuf, "</i>");
        }

        break;
      }
      default:
        break;
    }
    if (context_state->str[i] == state) {
      g_string_append (sctx->buf, str->str);
      g_string_free (str, TRUE);
      g_string_truncate (context_state, i);
      return;
    }
  }
  if (state == CLEAR_TAG) {
    g_string_append (sctx->buf, str->str);
    g_string_truncate (context_state, 0);
  }
  g_string_free (str, TRUE);
}

static void
handle_start_sync (GstSamiContext * sctx, const gchar ** atts)
{
  int i;

  sami_context_pop_state (sctx, CLEAR_TAG);
  if (atts != NULL) {
    for (i = 0; (atts[i] != NULL); i += 2) {
      const gchar *key, *value;

      key = atts[i];
      value = atts[i + 1];

      if (!value)
        continue;
      if (!g_ascii_strcasecmp ("start", key)) {
        /* Only set a new start time if we don't have text pending */
        if (sctx->resultbuf->len == 0)
          sctx->time1 = sctx->time2;

        sctx->time2 = atoi ((const char *) value) * GST_MSECOND;
        sctx->time2 = MAX (sctx->time2, sctx->time1);
        g_string_append (sctx->resultbuf, sctx->buf->str);
        sctx->has_result = (sctx->resultbuf->len != 0) ? TRUE : FALSE;
        g_string_truncate (sctx->buf, 0);
      }
    }
  }
}

static void
handle_start_font (GstSamiContext * sctx, const gchar ** atts)
{
  int i;

  sami_context_pop_state (sctx, SPAN_TAG);
  if (atts != NULL) {
    g_string_append (sctx->buf, "<span");
    for (i = 0; (atts[i] != NULL); i += 2) {
      const gchar *key, *value;

      key = atts[i];
      value = atts[i + 1];

      if (!value)
        continue;
      if (!g_ascii_strcasecmp ("color", key)) {
        /*
         * There are invalid color value in many
         * sami files.
         * It will fix hex color value that start without '#'
         */
        const gchar *sharp = "";
        int len = strlen (value);

        if (!(*value == '#' && len == 7)) {
          gchar *r;

          /* check if it looks like hex */
          if (strtol ((const char *) value, &r, 16) >= 0 &&
              ((gchar *) r == (value + 6) && len == 6)) {
            sharp = "#";
          }
        }
        /* some colours can be found in many sami files, but X RGB database
         * doesn't contain a colour by this name, so map explicitly */
        if (!g_ascii_strcasecmp ("aqua", value)) {
          value = "#00ffff";
        } else if (!g_ascii_strcasecmp ("crimson", value)) {
          value = "#dc143c";
        } else if (!g_ascii_strcasecmp ("fuchsia", value)) {
          value = "#ff00ff";
        } else if (!g_ascii_strcasecmp ("indigo", value)) {
          value = "#4b0082";
        } else if (!g_ascii_strcasecmp ("lime", value)) {
          value = "#00ff00";
        } else if (!g_ascii_strcasecmp ("olive", value)) {
          value = "#808000";
        } else if (!g_ascii_strcasecmp ("silver", value)) {
          value = "#c0c0c0";
        } else if (!g_ascii_strcasecmp ("teal", value)) {
          value = "#008080";
        }
        g_string_append_printf (sctx->buf, " foreground=\"%s%s\"", sharp,
            value);
      } else if (!g_ascii_strcasecmp ("face", key)) {
        g_string_append_printf (sctx->buf, " font_family=\"%s\"", value);
      }
    }
    g_string_append_c (sctx->buf, '>');
    sami_context_push_state (sctx, SPAN_TAG);
  }
}

static void
handle_start_element (HtmlContext * ctx, const gchar * name,
    const char **atts, gpointer user_data)
{
  GstSamiContext *sctx = (GstSamiContext *) user_data;

  GST_LOG ("name:%s", name);

  if (!g_ascii_strcasecmp ("sync", name)) {
    handle_start_sync (sctx, atts);
    sctx->in_sync = TRUE;
  } else if (!g_ascii_strcasecmp ("font", name)) {
    handle_start_font (sctx, atts);
  } else if (!g_ascii_strcasecmp ("ruby", name)) {
    sami_context_push_state (sctx, RUBY_TAG);
  } else if (!g_ascii_strcasecmp ("br", name)) {
    g_string_append_c (sctx->buf, '\n');
    /* FIXME: support for furigana/ruby once implemented in pango */
  } else if (!g_ascii_strcasecmp ("rt", name)) {
    if (has_tag (sctx->state, ITALIC_TAG)) {
      g_string_append (sctx->rubybuf, "<i>");
    }
    g_string_append (sctx->rubybuf, "<span size='xx-small' rise='-100'>");
    sami_context_push_state (sctx, RT_TAG);
  } else if (!g_ascii_strcasecmp ("i", name)) {
    g_string_append (sctx->buf, "<i>");
    sami_context_push_state (sctx, ITALIC_TAG);
  } else if (!g_ascii_strcasecmp ("p", name)) {
  }
}

static void
handle_end_element (HtmlContext * ctx, const char *name, gpointer user_data)
{
  GstSamiContext *sctx = (GstSamiContext *) user_data;

  GST_LOG ("name:%s", name);

  if (!g_ascii_strcasecmp ("sync", name)) {
    sctx->in_sync = FALSE;
  } else if ((!g_ascii_strcasecmp ("body", name)) ||
      (!g_ascii_strcasecmp ("sami", name))) {
    /* We will usually have one buffer left when the body is closed
     * as we need the next sync to actually send it */
    if (sctx->buf->len != 0) {
      /* Only set a new start time if we don't have text pending */
      if (sctx->resultbuf->len == 0)
        sctx->time1 = sctx->time2;

      sctx->time2 = GST_CLOCK_TIME_NONE;
      g_string_append (sctx->resultbuf, sctx->buf->str);
      sctx->has_result = (sctx->resultbuf->len != 0) ? TRUE : FALSE;
      g_string_truncate (sctx->buf, 0);
    }
  } else if (!g_ascii_strcasecmp ("font", name)) {
    sami_context_pop_state (sctx, SPAN_TAG);
  } else if (!g_ascii_strcasecmp ("ruby", name)) {
    sami_context_pop_state (sctx, RUBY_TAG);
  } else if (!g_ascii_strcasecmp ("i", name)) {
    sami_context_pop_state (sctx, ITALIC_TAG);
  }
}

static void
handle_text (HtmlContext * ctx, const gchar * text, gsize text_len,
    gpointer user_data)
{
  GstSamiContext *sctx = (GstSamiContext *) user_data;

  /* Skip everything except content of the sync elements */
  if (!sctx->in_sync)
    return;

  if (has_tag (sctx->state, RT_TAG)) {
    g_string_append_c (sctx->rubybuf, ' ');
    g_string_append (sctx->rubybuf, text);
    g_string_append_c (sctx->rubybuf, ' ');
  } else {
    g_string_append (sctx->buf, text);
  }
}

static HtmlParser samiParser = {
  handle_start_element,         /* start_element */
  handle_end_element,           /* end_element */
  handle_text,                  /* text */
};

void
sami_context_init (ParserState * state)
{
  GstSamiContext *context;

  g_assert (state->user_data == NULL);

  context = g_new0 (GstSamiContext, 1);

  context->htmlctxt = html_context_new (&samiParser, context);
  context->buf = g_string_new ("");
  context->rubybuf = g_string_new ("");
  context->resultbuf = g_string_new ("");
  context->state = g_string_new ("");

  state->user_data = context;
}

void
sami_context_deinit (ParserState * state)
{
  GstSamiContext *context = (GstSamiContext *) state->user_data;

  if (context) {
    html_context_free (context->htmlctxt);
    context->htmlctxt = NULL;
    g_string_free (context->buf, TRUE);
    g_string_free (context->rubybuf, TRUE);
    g_string_free (context->resultbuf, TRUE);
    g_string_free (context->state, TRUE);
    g_free (context);
    state->user_data = NULL;
  }
}

void
sami_context_reset (ParserState * state)
{
  GstSamiContext *context = (GstSamiContext *) state->user_data;

  if (context) {
    g_string_truncate (context->buf, 0);
    g_string_truncate (context->rubybuf, 0);
    g_string_truncate (context->resultbuf, 0);
    g_string_truncate (context->state, 0);
    context->has_result = FALSE;
    context->in_sync = FALSE;
    context->time1 = 0;
    context->time2 = 0;
  }
}

gchar *
parse_sami (ParserState * state, const gchar * line)
{
  gchar *ret = NULL;
  GstSamiContext *context = (GstSamiContext *) state->user_data;

  gchar *unescaped = unescape_string (line);
  html_context_parse (context->htmlctxt, (gchar *) unescaped,
      strlen (unescaped));
  g_free (unescaped);

  if (context->has_result) {
    if (context->rubybuf->len) {
      context->rubybuf = g_string_append_c (context->rubybuf, '\n');
      g_string_prepend (context->resultbuf, context->rubybuf->str);
      context->rubybuf = g_string_truncate (context->rubybuf, 0);
    }

    ret = g_string_free (context->resultbuf, FALSE);
    context->resultbuf = g_string_new ("");
    state->start_time = context->time1;
    state->duration = context->time2 - context->time1;
    context->has_result = FALSE;
  }
  return ret;
}
