#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 1

/* Using locations.  */
#define YYLSP_NEEDED 0

/* Substitute the variable and function names.  */
#define yyparse priv_gst_parse_yyparse
#define yylex   priv_gst_parse_yylex
#define yyerror priv_gst_parse_yyerror
#define yylval  priv_gst_parse_yylval
#define yychar  priv_gst_parse_yychar
#define yydebug priv_gst_parse_yydebug
#define yynerrs priv_gst_parse_yynerrs


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PARSE_URL = 258,
     IDENTIFIER = 259,
     BINREF = 260,
     PADREF = 261,
     REF = 262,
     ASSIGNMENT = 263,
     LINK = 264
   };
#endif
/* Tokens.  */
#define PARSE_URL 258
#define IDENTIFIER 259
#define BINREF 260
#define PADREF 261
#define REF 262
#define ASSIGNMENT 263
#define LINK 264




/* Copy the first part of user declarations.  */
#line 1 "./grammar.y"

#include "../gst_private.h"

#include <glib-object.h>
#include <glib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../gst-i18n-lib.h"

#include "../gstconfig.h"
#include "../gstparse.h"
#include "../gstinfo.h"
#include "../gsterror.h"
#include "../gststructure.h"
#include "../gsturi.h"
#include "../gstutils.h"
#include "../gstvalue.h"
#include "../gstchildproxy.h"
#include "types.h"

/* All error messages in this file are user-visible and need to be translated.
 * Don't start the message with a capital, and don't end them with a period,
 * as they will be presented inside a sentence/error.
 */

#define YYERROR_VERBOSE 1

#define YYENABLE_NLS 0

#ifndef YYLTYPE_IS_TRIVIAL
#define YYLTYPE_IS_TRIVIAL 0
#endif

typedef void* yyscan_t;

int priv_gst_parse_yylex (void * yylval_param , yyscan_t yyscanner);
int priv_gst_parse_yylex_init (yyscan_t scanner);
int priv_gst_parse_yylex_destroy (yyscan_t scanner);
struct yy_buffer_state * priv_gst_parse_yy_scan_string (char* , yyscan_t);
void _gst_parse_yypush_buffer_state (void * new_buffer ,yyscan_t yyscanner );
void _gst_parse_yypop_buffer_state (yyscan_t yyscanner );

#ifdef __GST_PARSE_TRACE
static guint __strings;
static guint __links;
static guint __chains;
gchar *
__gst_parse_strdup (gchar *org)
{
  gchar *ret;
  __strings++;
  ret = g_strdup (org);
  /* g_print ("ALLOCATED STR   (%3u): %p %s\n", __strings, ret, ret); */
  return ret;
}
void
__gst_parse_strfree (gchar *str)
{
  if (str) {
    /* g_print ("FREEING STR     (%3u): %p %s\n", __strings - 1, str, str); */
    g_free (str);
    g_return_if_fail (__strings > 0);
    __strings--;
  }
}
link_t *__gst_parse_link_new ()
{
  link_t *ret;
  __links++;
  ret = g_slice_new0 (link_t);
  /* g_print ("ALLOCATED LINK  (%3u): %p\n", __links, ret); */
  return ret;
}
void
__gst_parse_link_free (link_t *data)
{
  if (data) {
    /* g_print ("FREEING LINK    (%3u): %p\n", __links - 1, data); */
    g_slice_free (link_t, data);
    g_return_if_fail (__links > 0);
    __links--;
  }
}
chain_t *
__gst_parse_chain_new ()
{
  chain_t *ret;
  __chains++;
  ret = g_slice_new0 (chain_t);
  /* g_print ("ALLOCATED CHAIN (%3u): %p\n", __chains, ret); */
  return ret;
}
void
__gst_parse_chain_free (chain_t *data)
{
  /* g_print ("FREEING CHAIN   (%3u): %p\n", __chains - 1, data); */
  g_slice_free (chain_t, data);
  g_return_if_fail (__chains > 0);
  __chains--;
}

#endif /* __GST_PARSE_TRACE */

typedef struct {
  gchar *src_pad;
  gchar *sink_pad;
  GstElement *sink;
  GstCaps *caps;
  gulong signal_id;
} DelayedLink;

typedef struct {
  gchar *name;
  gchar *value_str;
  gulong signal_id;
} DelayedSet;

/*** define SET_ERROR macro/function */

#ifdef G_HAVE_ISO_VARARGS

#  define SET_ERROR(error, type, ...) \
G_STMT_START { \
  GST_CAT_ERROR (GST_CAT_PIPELINE, __VA_ARGS__); \
  if ((error) && !*(error)) { \
    g_set_error ((error), GST_PARSE_ERROR, (type), __VA_ARGS__); \
  } \
} G_STMT_END

#elif defined(G_HAVE_GNUC_VARARGS)

#  define SET_ERROR(error, type, args...) \
G_STMT_START { \
  GST_CAT_ERROR (GST_CAT_PIPELINE, args ); \
  if ((error) && !*(error)) { \
    g_set_error ((error), GST_PARSE_ERROR, (type), args ); \
  } \
} G_STMT_END

#else

static inline void
SET_ERROR (GError **error, gint type, const char *format, ...)
{
  if (error) {
    if (*error) {
      g_warning ("error while parsing");
    } else {
      va_list varargs;
      char *string;

      va_start (varargs, format);
      string = g_strdup_vprintf (format, varargs);
      va_end (varargs);

      g_set_error (error, GST_PARSE_ERROR, type, string);

      g_free (string);
    }
  }
}

#endif /* G_HAVE_ISO_VARARGS */

/*** define YYPRINTF macro/function if we're debugging */

/* bison 1.35 calls this macro with side effects, we need to make sure the
   side effects work - crappy bison */

#ifndef GST_DISABLE_GST_DEBUG
#  define YYDEBUG 1

#  ifdef G_HAVE_ISO_VARARGS

/* #  define YYFPRINTF(a, ...) GST_CAT_DEBUG (GST_CAT_PIPELINE, __VA_ARGS__) */
#    define YYFPRINTF(a, ...) \
G_STMT_START { \
     GST_CAT_LOG (GST_CAT_PIPELINE, __VA_ARGS__); \
} G_STMT_END

#  elif defined(G_HAVE_GNUC_VARARGS)

#    define YYFPRINTF(a, args...) \
G_STMT_START { \
     GST_CAT_LOG (GST_CAT_PIPELINE, args); \
} G_STMT_END

#  else

static inline void
YYPRINTF(const char *format, ...)
{
  va_list varargs;
  gchar *temp;

  va_start (varargs, format);
  temp = g_strdup_vprintf (format, varargs);
  GST_CAT_LOG (GST_CAT_PIPELINE, "%s", temp);
  g_free (temp);
  va_end (varargs);
}

#  endif /* G_HAVE_ISO_VARARGS */

#endif /* GST_DISABLE_GST_DEBUG */

#define ADD_MISSING_ELEMENT(graph,name) G_STMT_START {                      \
    if ((graph)->ctx) {                                                     \
      (graph)->ctx->missing_elements =                                      \
          g_list_append ((graph)->ctx->missing_elements, g_strdup (name));  \
    } } G_STMT_END

static void
no_free (gconstpointer foo)
{
  /* do nothing */
}

#define GST_BIN_MAKE(res, type, chainval, assign, type_string_free_func) \
G_STMT_START { \
  chain_t *chain = chainval; \
  GSList *walk; \
  GstBin *bin = (GstBin *) gst_element_factory_make (type, NULL); \
  if (!chain) { \
    SET_ERROR (graph->error, GST_PARSE_ERROR_EMPTY_BIN, \
        _("specified empty bin \"%s\", not allowed"), type); \
    g_slist_foreach (assign, (GFunc) gst_parse_strfree, NULL); \
    g_slist_free (assign); \
    gst_object_unref (bin); \
    type_string_free_func (type); /* Need to clean up the string */ \
    YYERROR; \
  } else if (!bin) { \
    ADD_MISSING_ELEMENT(graph, type); \
    SET_ERROR (graph->error, GST_PARSE_ERROR_NO_SUCH_ELEMENT, \
        _("no bin \"%s\", skipping"), type); \
    g_slist_foreach (assign, (GFunc) gst_parse_strfree, NULL); \
    g_slist_free (assign); \
    res = chain; \
  } else { \
    for (walk = chain->elements; walk; walk = walk->next ) \
      gst_bin_add (bin, GST_ELEMENT (walk->data)); \
    g_slist_free (chain->elements); \
    chain->elements = g_slist_prepend (NULL, bin); \
    res = chain; \
    /* set the properties now */ \
    for (walk = assign; walk; walk = walk->next) \
      gst_parse_element_set ((gchar *) walk->data, GST_ELEMENT (bin), graph); \
    g_slist_free (assign); \
  } \
} G_STMT_END

#define MAKE_LINK(link, _src, _src_name, _src_pads, _sink, _sink_name, _sink_pads) \
G_STMT_START { \
  link = gst_parse_link_new (); \
  link->src = _src; \
  link->sink = _sink; \
  link->src_name = _src_name; \
  link->sink_name = _sink_name; \
  link->src_pads = _src_pads; \
  link->sink_pads = _sink_pads; \
  link->caps = NULL; \
} G_STMT_END

#define MAKE_REF(link, _src, _pads) \
G_STMT_START { \
  gchar *padname = _src; \
  GSList *pads = _pads; \
  if (padname) { \
    while (*padname != '.') padname++; \
    *padname = '\0'; \
    padname++; \
    if (*padname != '\0') \
      pads = g_slist_prepend (pads, gst_parse_strdup (padname)); \
  } \
  MAKE_LINK (link, NULL, _src, pads, NULL, NULL, NULL); \
} G_STMT_END

static void
gst_parse_free_delayed_set (DelayedSet *set)
{
  g_free(set->name);
  g_free(set->value_str);
  g_slice_free(DelayedSet, set);
}

static void gst_parse_new_child(GstChildProxy *child_proxy, GObject *object,
    const gchar * name, gpointer data);

static void
gst_parse_add_delayed_set (GstElement *element, gchar *name, gchar *value_str)
{
  DelayedSet *data = g_slice_new0 (DelayedSet);

  GST_CAT_LOG_OBJECT (GST_CAT_PIPELINE, element, "delaying property set %s to %s",
    name, value_str);

  data->name = g_strdup(name);
  data->value_str = g_strdup(value_str);
  data->signal_id = g_signal_connect_data(element, "child-added",
      G_CALLBACK (gst_parse_new_child), data, (GClosureNotify)
      gst_parse_free_delayed_set, (GConnectFlags) 0);

  /* FIXME: we would need to listen on all intermediate bins too */
  if (GST_IS_BIN (element)) {
    gchar **names, **current;
    GstElement *parent, *child;

    current = names = g_strsplit (name, "::", -1);
    parent = gst_bin_get_by_name (GST_BIN_CAST (element), current[0]);
    current++;
    while (parent && current[0]) {
      child = gst_bin_get_by_name (GST_BIN (parent), current[0]);
      if (!child && current[1]) {
        char *sub_name = g_strjoinv ("::", &current[0]);

        gst_parse_add_delayed_set(parent, sub_name, value_str);
        g_free (sub_name);
      }
      parent = child;
      current++;
    }
    g_strfreev (names);
  }
}

static void
gst_parse_new_child(GstChildProxy *child_proxy, GObject *object,
    const gchar * name, gpointer data)
{
  DelayedSet *set = (DelayedSet *) data;
  GParamSpec *pspec;
  GValue v = { 0, };
  GObject *target = NULL;
  GType value_type;

  GST_CAT_LOG_OBJECT (GST_CAT_PIPELINE, child_proxy, "new child %s, checking property %s",
      name, set->name);

  if (gst_child_proxy_lookup (child_proxy, set->name, &target, &pspec)) {
    gboolean got_value = FALSE;

    value_type = pspec->value_type;

    GST_CAT_LOG_OBJECT (GST_CAT_PIPELINE, child_proxy, "parsing delayed property %s as a %s from %s",
      pspec->name, g_type_name (value_type), set->value_str);
    g_value_init (&v, value_type);
    if (gst_value_deserialize (&v, set->value_str))
      got_value = TRUE;
    else if (g_type_is_a (value_type, GST_TYPE_ELEMENT)) {
       GstElement *bin;

       bin = gst_parse_bin_from_description_full (set->value_str, TRUE, NULL,
           GST_PARSE_FLAG_NO_SINGLE_ELEMENT_BINS, NULL);
       if (bin) {
         g_value_set_object (&v, bin);
         got_value = TRUE;
       }
    }
    g_signal_handler_disconnect (child_proxy, set->signal_id);
    if (!got_value)
      goto error;
    g_object_set_property (target, pspec->name, &v);
  } else {
    const gchar *obj_name = GST_OBJECT_NAME(object);
    gint len = strlen (obj_name);

    /* do a delayed set */
    if ((strlen (set->name) > (len + 2)) && !strncmp (set->name, obj_name, len) && !strncmp (&set->name[len], "::", 2)) {
      gst_parse_add_delayed_set (GST_ELEMENT(child_proxy), set->name, set->value_str);
    }
  }

out:
  if (G_IS_VALUE (&v))
    g_value_unset (&v);
  if (target)
    g_object_unref (target);
  return;

error:
  GST_CAT_ERROR (GST_CAT_PIPELINE, "could not set property \"%s\" in %"
      GST_PTR_FORMAT, pspec->name, target);
  goto out;
}

static void
gst_parse_element_set (gchar *value, GstElement *element, graph_t *graph)
{
  GParamSpec *pspec = NULL;
  gchar *pos = value;
  GValue v = { 0, };
  GObject *target = NULL;
  GType value_type;

  /* do nothing if assignment is for missing element */
  if (element == NULL)
    goto out;

  /* parse the string, so the property name is null-terminated and pos points
     to the beginning of the value */
  while (!g_ascii_isspace (*pos) && (*pos != '=')) pos++;
  if (*pos == '=') {
    *pos = '\0';
  } else {
    *pos = '\0';
    pos++;
    while (g_ascii_isspace (*pos)) pos++;
  }
  pos++;
  while (g_ascii_isspace (*pos)) pos++;
  if (*pos == '"') {
    pos++;
    pos[strlen (pos) - 1] = '\0';
  }
  gst_parse_unescape (pos);

  if (GST_IS_CHILD_PROXY (element)) {
    if (!gst_child_proxy_lookup (GST_CHILD_PROXY (element), value, &target, &pspec)) {
      /* do a delayed set */
      gst_parse_add_delayed_set (element, value, pos);
    }
  } else {
    pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (element), value);
    if (pspec != NULL) {
      target = g_object_ref (element);
      GST_CAT_LOG_OBJECT (GST_CAT_PIPELINE, target, "found %s property", value);
    } else {
      SET_ERROR (graph->error, GST_PARSE_ERROR_NO_SUCH_PROPERTY, \
          _("no property \"%s\" in element \"%s\""), value, \
          GST_ELEMENT_NAME (element));
    }
  }

  if (pspec != NULL && target != NULL) {
    gboolean got_value = FALSE;

    value_type = pspec->value_type;

    GST_CAT_LOG_OBJECT (GST_CAT_PIPELINE, element, "parsing property %s as a %s",
        pspec->name, g_type_name (value_type));

    g_value_init (&v, value_type);
    if (gst_value_deserialize (&v, pos))
      got_value = TRUE;
    else if (g_type_is_a (value_type, GST_TYPE_ELEMENT)) {
       GstElement *bin;

       bin = gst_parse_bin_from_description_full (pos, TRUE, NULL,
           GST_PARSE_FLAG_NO_SINGLE_ELEMENT_BINS, NULL);
       if (bin) {
         g_value_set_object (&v, bin);
         got_value = TRUE;
       }
    }
    if (!got_value)
      goto error;
    g_object_set_property (target, pspec->name, &v);
  }

out:
  gst_parse_strfree (value);
  if (G_IS_VALUE (&v))
    g_value_unset (&v);
  if (target)
    g_object_unref (target);
  return;

error:
  SET_ERROR (graph->error, GST_PARSE_ERROR_COULD_NOT_SET_PROPERTY,
         _("could not set property \"%s\" in element \"%s\" to \"%s\""),
	 value, GST_ELEMENT_NAME (element), pos);
  goto out;
}

static inline void
gst_parse_free_link (link_t *link)
{
  gst_parse_strfree (link->src_name);
  gst_parse_strfree (link->sink_name);
  g_slist_foreach (link->src_pads, (GFunc) gst_parse_strfree, NULL);
  g_slist_foreach (link->sink_pads, (GFunc) gst_parse_strfree, NULL);
  g_slist_free (link->src_pads);
  g_slist_free (link->sink_pads);
  if (link->caps) gst_caps_unref (link->caps);
  gst_parse_link_free (link);
}

static void
gst_parse_free_delayed_link (DelayedLink *link)
{
  g_free (link->src_pad);
  g_free (link->sink_pad);
  if (link->caps) gst_caps_unref (link->caps);
  g_slice_free (DelayedLink, link);
}

static void
gst_parse_found_pad (GstElement *src, GstPad *pad, gpointer data)
{
  DelayedLink *link = data;

  GST_CAT_INFO (GST_CAT_PIPELINE, "trying delayed linking %s:%s to %s:%s",
                GST_STR_NULL (GST_ELEMENT_NAME (src)), GST_STR_NULL (link->src_pad),
                GST_STR_NULL (GST_ELEMENT_NAME (link->sink)), GST_STR_NULL (link->sink_pad));

  if (gst_element_link_pads_filtered (src, link->src_pad, link->sink,
      link->sink_pad, link->caps)) {
    /* do this here, we don't want to get any problems later on when
     * unlocking states */
    GST_CAT_DEBUG (GST_CAT_PIPELINE, "delayed linking %s:%s to %s:%s worked",
               	   GST_STR_NULL (GST_ELEMENT_NAME (src)), GST_STR_NULL (link->src_pad),
               	   GST_STR_NULL (GST_ELEMENT_NAME (link->sink)), GST_STR_NULL (link->sink_pad));
    g_signal_handler_disconnect (src, link->signal_id);
  }
}

/* both padnames and the caps may be NULL */
static gboolean
gst_parse_perform_delayed_link (GstElement *src, const gchar *src_pad,
                                GstElement *sink, const gchar *sink_pad,
                                GstCaps *caps)
{
  GList *templs = gst_element_class_get_pad_template_list (
      GST_ELEMENT_GET_CLASS (src));

  for (; templs; templs = templs->next) {
    GstPadTemplate *templ = (GstPadTemplate *) templs->data;
    if ((GST_PAD_TEMPLATE_DIRECTION (templ) == GST_PAD_SRC) &&
        (GST_PAD_TEMPLATE_PRESENCE(templ) == GST_PAD_SOMETIMES))
    {
      DelayedLink *data = g_slice_new (DelayedLink);

      /* TODO: maybe we should check if src_pad matches this template's names */

      GST_CAT_DEBUG (GST_CAT_PIPELINE, "trying delayed link %s:%s to %s:%s",
                     GST_STR_NULL (GST_ELEMENT_NAME (src)), GST_STR_NULL (src_pad),
                     GST_STR_NULL (GST_ELEMENT_NAME (sink)), GST_STR_NULL (sink_pad));

      data->src_pad = g_strdup (src_pad);
      data->sink = sink;
      data->sink_pad = g_strdup (sink_pad);
      if (caps) {
      	data->caps = gst_caps_copy (caps);
      } else {
      	data->caps = NULL;
      }
      data->signal_id = g_signal_connect_data (src, "pad-added",
          G_CALLBACK (gst_parse_found_pad), data,
          (GClosureNotify) gst_parse_free_delayed_link, (GConnectFlags) 0);
      return TRUE;
    }
  }
  return FALSE;
}

/*
 * performs a link and frees the struct. src and sink elements must be given
 * return values   0 - link performed
 *                 1 - link delayed
 *                <0 - error
 */
static gint
gst_parse_perform_link (link_t *link, graph_t *graph)
{
  GstElement *src = link->src;
  GstElement *sink = link->sink;
  GSList *srcs = link->src_pads;
  GSList *sinks = link->sink_pads;
  g_assert (GST_IS_ELEMENT (src));
  g_assert (GST_IS_ELEMENT (sink));

  GST_CAT_INFO (GST_CAT_PIPELINE,
      "linking %s:%s to %s:%s (%u/%u) with caps \"%" GST_PTR_FORMAT "\"",
      GST_ELEMENT_NAME (src), link->src_name ? link->src_name : "(any)",
      GST_ELEMENT_NAME (sink), link->sink_name ? link->sink_name : "(any)",
      g_slist_length (srcs), g_slist_length (sinks), link->caps);

  if (!srcs || !sinks) {
    if (gst_element_link_pads_filtered (src,
        srcs ? (const gchar *) srcs->data : NULL, sink,
        sinks ? (const gchar *) sinks->data : NULL, link->caps)) {
      goto success;
    } else {
      if (gst_parse_perform_delayed_link (src,
          srcs ? (const gchar *) srcs->data : NULL,
          sink, sinks ? (const gchar *) sinks->data : NULL, link->caps)) {
	goto success;
      } else {
        goto error;
      }
    }
  }
  if (g_slist_length (link->src_pads) != g_slist_length (link->sink_pads)) {
    goto error;
  }
  while (srcs && sinks) {
    const gchar *src_pad = (const gchar *) srcs->data;
    const gchar *sink_pad = (const gchar *) sinks->data;
    srcs = g_slist_next (srcs);
    sinks = g_slist_next (sinks);
    if (gst_element_link_pads_filtered (src, src_pad, sink, sink_pad,
        link->caps)) {
      continue;
    } else {
      if (gst_parse_perform_delayed_link (src, src_pad,
                                          sink, sink_pad,
					  link->caps)) {
	continue;
      } else {
        goto error;
      }
    }
  }

success:
  gst_parse_free_link (link);
  return 0;

error:
  SET_ERROR (graph->error, GST_PARSE_ERROR_LINK,
      _("could not link %s to %s"), GST_ELEMENT_NAME (src),
      GST_ELEMENT_NAME (sink));
  gst_parse_free_link (link);
  return -1;
}


static int yyerror (void *scanner, graph_t *graph, const char *s);


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 633 "./grammar.y"
{
    gchar *s;
    chain_t *c;
    link_t *l;
    GstElement *e;
    GSList *p;
    graph_t *g;
}
/* Line 193 of yacc.c.  */
#line 763 "grammar.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 776 "grammar.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  29
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   176

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  16
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  12
/* YYNRULES -- Number of rules.  */
#define YYNRULES  32
/* YYNRULES -- Number of states.  */
#define YYNSTATES  43

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   264

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    14,     2,     2,     2,     2,     2,     2,
      10,    11,     2,     2,    12,     2,    13,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    15,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint8 yyprhs[] =
{
       0,     0,     3,     5,     8,     9,    12,    17,    22,    26,
      31,    33,    36,    39,    43,    45,    48,    50,    52,    53,
      57,    59,    62,    65,    67,    69,    72,    75,    78,    81,
      84,    87,    88
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      27,     0,    -1,     4,    -1,    17,     8,    -1,    -1,    18,
       8,    -1,    10,    18,    26,    11,    -1,     5,    18,    26,
      11,    -1,     5,    18,    11,    -1,     5,    18,     1,    11,
      -1,     6,    -1,     6,    21,    -1,    12,     4,    -1,    12,
       4,    21,    -1,     7,    -1,     7,    21,    -1,    22,    -1,
      20,    -1,    -1,    23,     9,    23,    -1,    24,    -1,    24,
      25,    -1,    25,     1,    -1,    17,    -1,    19,    -1,    26,
      26,    -1,    26,    25,    -1,    26,     1,    -1,    24,    26,
      -1,     3,    26,    -1,    24,     3,    -1,    -1,    26,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   669,   669,   683,   687,   688,   690,   691,   694,   697,
     702,   703,   707,   708,   711,   712,   715,   716,   717,   720,
     733,   734,   735,   738,   743,   744,   779,   807,   808,   822,
     843,   869,   872
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PARSE_URL", "IDENTIFIER", "BINREF",
  "PADREF", "REF", "ASSIGNMENT", "LINK", "'('", "')'", "','", "'.'", "'!'",
  "'='", "$accept", "element", "assignments", "bin", "pads", "padlist",
  "reference", "linkpart", "link", "linklist", "chain", "graph", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
      40,    41,    44,    46,    33,    61
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    16,    17,    17,    18,    18,    19,    19,    19,    19,
      20,    20,    21,    21,    22,    22,    23,    23,    23,    24,
      25,    25,    25,    26,    26,    26,    26,    26,    26,    26,
      26,    27,    27
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     0,     2,     4,     4,     3,     4,
       1,     2,     2,     3,     1,     2,     1,     1,     0,     3,
       1,     2,     2,     1,     1,     2,     2,     2,     2,     2,
       2,     0,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
      18,    18,     2,     4,    10,    14,     4,    23,    24,    17,
      16,     0,    18,     0,     0,     0,     0,     0,    11,    15,
      18,     3,    18,    30,     0,    27,    20,     0,     0,     1,
       0,     5,     8,     0,    12,     0,    19,     0,    22,     9,
       7,    13,     6
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     7,    16,     8,     9,    18,    10,    11,    26,    27,
      28,    14
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -6
static const yytype_int16 yypact[] =
{
     134,   158,    -6,    -6,    -1,    -1,    -6,     6,    -6,    -6,
      -6,     7,   166,   101,    18,    30,    89,    16,    -6,    -6,
       2,    -6,   129,   142,    42,    -6,   150,    54,    66,    -6,
      11,    -6,    -6,   111,    -1,   122,    -6,    78,    -6,    -6,
      -6,    -6,    -6
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
      -6,    -6,    19,    -6,    -6,    -5,    -6,    10,     3,    12,
       1,    -6
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -33
static const yytype_int8 yytable[] =
{
      19,    13,    15,    12,    12,     1,     2,     3,     4,     5,
      31,    17,     6,    24,    21,    12,    22,    33,    29,    12,
      34,    35,    39,    12,    15,    20,    12,    24,     0,    41,
     -29,    25,    36,     1,     2,     3,     4,     5,    37,   -18,
       6,   -29,   -28,    25,     0,     1,     2,     3,     4,     5,
       0,   -18,     6,   -28,   -26,    38,     0,   -26,   -26,   -26,
     -26,   -26,     0,   -26,   -26,   -26,   -25,    25,     0,     1,
       2,     3,     4,     5,     0,   -18,     6,   -25,   -21,    38,
       0,   -21,   -21,   -21,   -21,   -21,     0,   -21,   -21,   -21,
      30,     0,     1,     2,     3,     4,     5,    31,   -18,     6,
      32,   -32,    25,     0,     1,     2,     3,     4,     5,     0,
     -18,     6,    25,     0,     1,     2,     3,     4,     5,     0,
     -18,     6,    40,    25,     0,     1,     2,     3,     4,     5,
       0,   -18,     6,    42,   -31,     4,     5,     1,     2,     3,
       4,     5,     0,     0,     6,     1,     2,     3,     4,     5,
       0,   -18,     6,    23,     2,     3,     4,     5,     0,   -18,
       6,     1,     2,     3,     4,     5,     0,     0,     6,    23,
       2,     3,     4,     5,     0,     0,     6
};

static const yytype_int8 yycheck[] =
{
       5,     0,     1,     0,     1,     3,     4,     5,     6,     7,
       8,    12,    10,    12,     8,    12,     9,    16,     0,    16,
       4,    20,    11,    20,    23,     6,    23,    26,    -1,    34,
       0,     1,    22,     3,     4,     5,     6,     7,    26,     9,
      10,    11,     0,     1,    -1,     3,     4,     5,     6,     7,
      -1,     9,    10,    11,     0,     1,    -1,     3,     4,     5,
       6,     7,    -1,     9,    10,    11,     0,     1,    -1,     3,
       4,     5,     6,     7,    -1,     9,    10,    11,     0,     1,
      -1,     3,     4,     5,     6,     7,    -1,     9,    10,    11,
       1,    -1,     3,     4,     5,     6,     7,     8,     9,    10,
      11,     0,     1,    -1,     3,     4,     5,     6,     7,    -1,
       9,    10,     1,    -1,     3,     4,     5,     6,     7,    -1,
       9,    10,    11,     1,    -1,     3,     4,     5,     6,     7,
      -1,     9,    10,    11,     0,     6,     7,     3,     4,     5,
       6,     7,    -1,    -1,    10,     3,     4,     5,     6,     7,
      -1,     9,    10,     3,     4,     5,     6,     7,    -1,     9,
      10,     3,     4,     5,     6,     7,    -1,    -1,    10,     3,
       4,     5,     6,     7,    -1,    -1,    10
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,    10,    17,    19,    20,
      22,    23,    24,    26,    27,    26,    18,    12,    21,    21,
      18,     8,     9,     3,    26,     1,    24,    25,    26,     0,
       1,     8,    11,    26,     4,    26,    23,    25,     1,    11,
      11,    21,    11
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (scanner, graph, YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (&yylval, YYLEX_PARAM)
#else
# define YYLEX yylex (&yylval, scanner)
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, scanner, graph); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, void *scanner, graph_t *graph)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, scanner, graph)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    void *scanner;
    graph_t *graph;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (scanner);
  YYUSE (graph);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, void *scanner, graph_t *graph)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, scanner, graph)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    void *scanner;
    graph_t *graph;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep, scanner, graph);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule, void *scanner, graph_t *graph)
#else
static void
yy_reduce_print (yyvsp, yyrule, scanner, graph)
    YYSTYPE *yyvsp;
    int yyrule;
    void *scanner;
    graph_t *graph;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       , scanner, graph);
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule, scanner, graph); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, void *scanner, graph_t *graph)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, scanner, graph)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    void *scanner;
    graph_t *graph;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (scanner);
  YYUSE (graph);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void *scanner, graph_t *graph);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */






/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *scanner, graph_t *graph)
#else
int
yyparse (scanner, graph)
    void *scanner;
    graph_t *graph;
#endif
#endif
{
  /* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;

  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 669 "./grammar.y"
    { (yyval.e) = gst_element_factory_make ((yyvsp[(1) - (1)].s), NULL);
						if ((yyval.e) == NULL) {
						  ADD_MISSING_ELEMENT (graph, (yyvsp[(1) - (1)].s));
						  SET_ERROR (graph->error, GST_PARSE_ERROR_NO_SUCH_ELEMENT, _("no element \"%s\""), (yyvsp[(1) - (1)].s));
						  /* if FATAL_ERRORS flag is set, we don't have to worry about backwards
						   * compatibility and can continue parsing and check for other missing
						   * elements */
						  if ((graph->flags & GST_PARSE_FLAG_FATAL_ERRORS) == 0) {
						    gst_parse_strfree ((yyvsp[(1) - (1)].s));
						    YYERROR;
						  }
						}
						gst_parse_strfree ((yyvsp[(1) - (1)].s));
                                              ;}
    break;

  case 3:
#line 683 "./grammar.y"
    { gst_parse_element_set ((yyvsp[(2) - (2)].s), (yyvsp[(1) - (2)].e), graph);
						(yyval.e) = (yyvsp[(1) - (2)].e);
	                                      ;}
    break;

  case 4:
#line 687 "./grammar.y"
    { (yyval.p) = NULL; ;}
    break;

  case 5:
#line 688 "./grammar.y"
    { (yyval.p) = g_slist_prepend ((yyvsp[(1) - (2)].p), (yyvsp[(2) - (2)].s)); ;}
    break;

  case 6:
#line 690 "./grammar.y"
    { GST_BIN_MAKE ((yyval.c), "bin", (yyvsp[(3) - (4)].c), (yyvsp[(2) - (4)].p), no_free); ;}
    break;

  case 7:
#line 691 "./grammar.y"
    { GST_BIN_MAKE ((yyval.c), (yyvsp[(1) - (4)].s), (yyvsp[(3) - (4)].c), (yyvsp[(2) - (4)].p), gst_parse_strfree);
						gst_parse_strfree ((yyvsp[(1) - (4)].s));
					      ;}
    break;

  case 8:
#line 694 "./grammar.y"
    { GST_BIN_MAKE ((yyval.c), (yyvsp[(1) - (3)].s), NULL, (yyvsp[(2) - (3)].p), gst_parse_strfree);
						gst_parse_strfree ((yyvsp[(1) - (3)].s));
					      ;}
    break;

  case 9:
#line 697 "./grammar.y"
    { GST_BIN_MAKE ((yyval.c), (yyvsp[(1) - (4)].s), NULL, (yyvsp[(2) - (4)].p), gst_parse_strfree);
						gst_parse_strfree ((yyvsp[(1) - (4)].s));
					      ;}
    break;

  case 10:
#line 702 "./grammar.y"
    { (yyval.p) = g_slist_prepend (NULL, (yyvsp[(1) - (1)].s)); ;}
    break;

  case 11:
#line 703 "./grammar.y"
    { (yyval.p) = (yyvsp[(2) - (2)].p);
						(yyval.p) = g_slist_prepend ((yyval.p), (yyvsp[(1) - (2)].s));
					      ;}
    break;

  case 12:
#line 707 "./grammar.y"
    { (yyval.p) = g_slist_prepend (NULL, (yyvsp[(2) - (2)].s)); ;}
    break;

  case 13:
#line 708 "./grammar.y"
    { (yyval.p) = g_slist_prepend ((yyvsp[(3) - (3)].p), (yyvsp[(2) - (3)].s)); ;}
    break;

  case 14:
#line 711 "./grammar.y"
    { MAKE_REF ((yyval.l), (yyvsp[(1) - (1)].s), NULL); ;}
    break;

  case 15:
#line 712 "./grammar.y"
    { MAKE_REF ((yyval.l), (yyvsp[(1) - (2)].s), (yyvsp[(2) - (2)].p)); ;}
    break;

  case 16:
#line 715 "./grammar.y"
    { (yyval.l) = (yyvsp[(1) - (1)].l); ;}
    break;

  case 17:
#line 716 "./grammar.y"
    { MAKE_REF ((yyval.l), NULL, (yyvsp[(1) - (1)].p)); ;}
    break;

  case 18:
#line 717 "./grammar.y"
    { MAKE_REF ((yyval.l), NULL, NULL); ;}
    break;

  case 19:
#line 720 "./grammar.y"
    { (yyval.l) = (yyvsp[(1) - (3)].l);
						if ((yyvsp[(2) - (3)].s)) {
						  (yyval.l)->caps = gst_caps_from_string ((yyvsp[(2) - (3)].s));
						  if ((yyval.l)->caps == NULL)
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("could not parse caps \"%s\""), (yyvsp[(2) - (3)].s));
						  gst_parse_strfree ((yyvsp[(2) - (3)].s));
						}
						(yyval.l)->sink_name = (yyvsp[(3) - (3)].l)->src_name;
						(yyval.l)->sink_pads = (yyvsp[(3) - (3)].l)->src_pads;
						gst_parse_link_free ((yyvsp[(3) - (3)].l));
					      ;}
    break;

  case 20:
#line 733 "./grammar.y"
    { (yyval.p) = g_slist_prepend (NULL, (yyvsp[(1) - (1)].l)); ;}
    break;

  case 21:
#line 734 "./grammar.y"
    { (yyval.p) = g_slist_prepend ((yyvsp[(2) - (2)].p), (yyvsp[(1) - (2)].l)); ;}
    break;

  case 22:
#line 735 "./grammar.y"
    { (yyval.p) = (yyvsp[(1) - (2)].p); ;}
    break;

  case 23:
#line 738 "./grammar.y"
    { (yyval.c) = gst_parse_chain_new ();
						(yyval.c)->first = (yyval.c)->last = (yyvsp[(1) - (1)].e);
						(yyval.c)->front = (yyval.c)->back = NULL;
						(yyval.c)->elements = g_slist_prepend (NULL, (yyvsp[(1) - (1)].e));
					      ;}
    break;

  case 24:
#line 743 "./grammar.y"
    { (yyval.c) = (yyvsp[(1) - (1)].c); ;}
    break;

  case 25:
#line 744 "./grammar.y"
    { if ((yyvsp[(1) - (2)].c)->back && (yyvsp[(2) - (2)].c)->front) {
						  if (!(yyvsp[(1) - (2)].c)->back->sink_name) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without source element"));
						    gst_parse_free_link ((yyvsp[(1) - (2)].c)->back);
						  } else {
						    graph->links = g_slist_prepend (graph->links, (yyvsp[(1) - (2)].c)->back);
						  }
						  if (!(yyvsp[(2) - (2)].c)->front->src_name) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without sink element"));
						    gst_parse_free_link ((yyvsp[(2) - (2)].c)->front);
						  } else {
						    graph->links = g_slist_prepend (graph->links, (yyvsp[(2) - (2)].c)->front);
						  }
						  (yyvsp[(1) - (2)].c)->back = NULL;
						} else if ((yyvsp[(1) - (2)].c)->back) {
						  if (!(yyvsp[(1) - (2)].c)->back->sink_name) {
						    (yyvsp[(1) - (2)].c)->back->sink = (yyvsp[(2) - (2)].c)->first;
						  }
						} else if ((yyvsp[(2) - (2)].c)->front) {
						  if (!(yyvsp[(2) - (2)].c)->front->src_name) {
						    (yyvsp[(2) - (2)].c)->front->src = (yyvsp[(1) - (2)].c)->last;
						  }
						  (yyvsp[(1) - (2)].c)->back = (yyvsp[(2) - (2)].c)->front;
						}

						if ((yyvsp[(1) - (2)].c)->back) {
						  graph->links = g_slist_prepend (graph->links, (yyvsp[(1) - (2)].c)->back);
						}
						(yyvsp[(1) - (2)].c)->last = (yyvsp[(2) - (2)].c)->last;
						(yyvsp[(1) - (2)].c)->back = (yyvsp[(2) - (2)].c)->back;
						(yyvsp[(1) - (2)].c)->elements = g_slist_concat ((yyvsp[(1) - (2)].c)->elements, (yyvsp[(2) - (2)].c)->elements);
						if ((yyvsp[(2) - (2)].c))
						  gst_parse_chain_free ((yyvsp[(2) - (2)].c));
						(yyval.c) = (yyvsp[(1) - (2)].c);
					      ;}
    break;

  case 26:
#line 779 "./grammar.y"
    { GSList *walk;
						if ((yyvsp[(1) - (2)].c)->back) {
						  (yyvsp[(2) - (2)].p) = g_slist_prepend ((yyvsp[(2) - (2)].p), (yyvsp[(1) - (2)].c)->back);
						  (yyvsp[(1) - (2)].c)->back = NULL;
						} else {
						  if (!((link_t *) (yyvsp[(2) - (2)].p)->data)->src_name) {
						    ((link_t *) (yyvsp[(2) - (2)].p)->data)->src = (yyvsp[(1) - (2)].c)->last;
						  }
						}
						for (walk = (yyvsp[(2) - (2)].p); walk; walk = walk->next) {
						  link_t *link = (link_t *) walk->data;
						  if (!link->sink_name && walk->next) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without sink element"));
						    gst_parse_free_link (link);
						  } else if (!link->src_name && !link->src) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without source element"));
						    gst_parse_free_link (link);
						  } else {
						    if (walk->next) {
						      graph->links = g_slist_prepend (graph->links, link);
						    } else {
						      (yyvsp[(1) - (2)].c)->back = link;
						    }
						  }
						}
						g_slist_free ((yyvsp[(2) - (2)].p));
						(yyval.c) = (yyvsp[(1) - (2)].c);
					      ;}
    break;

  case 27:
#line 807 "./grammar.y"
    { (yyval.c) = (yyvsp[(1) - (2)].c); ;}
    break;

  case 28:
#line 808 "./grammar.y"
    { if ((yyvsp[(2) - (2)].c)->front) {
						  if (!(yyvsp[(2) - (2)].c)->front->src_name) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without source element"));
						    gst_parse_free_link ((yyvsp[(2) - (2)].c)->front);
						  } else {
						    graph->links = g_slist_prepend (graph->links, (yyvsp[(2) - (2)].c)->front);
						  }
						}
						if (!(yyvsp[(1) - (2)].l)->sink_name) {
						  (yyvsp[(1) - (2)].l)->sink = (yyvsp[(2) - (2)].c)->first;
						}
						(yyvsp[(2) - (2)].c)->front = (yyvsp[(1) - (2)].l);
						(yyval.c) = (yyvsp[(2) - (2)].c);
					      ;}
    break;

  case 29:
#line 822 "./grammar.y"
    { (yyval.c) = (yyvsp[(2) - (2)].c);
						if ((yyval.c)->front) {
						  GstElement *element =
							  gst_element_make_from_uri (GST_URI_SRC, (yyvsp[(1) - (2)].s), NULL, NULL);
						  /* FIXME: get and parse error properly */
						  if (!element) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_NO_SUCH_ELEMENT,
							    _("no source element for URI \"%s\""), (yyvsp[(1) - (2)].s));
						  } else {
						    (yyval.c)->front->src = element;
						    graph->links = g_slist_prepend (
							    graph->links, (yyval.c)->front);
						    (yyval.c)->front = NULL;
						    (yyval.c)->elements = g_slist_prepend ((yyval.c)->elements, element);
						  }
						} else {
						  SET_ERROR (graph->error, GST_PARSE_ERROR_LINK,
							  _("no element to link URI \"%s\" to"), (yyvsp[(1) - (2)].s));
						}
						g_free ((yyvsp[(1) - (2)].s));
					      ;}
    break;

  case 30:
#line 843 "./grammar.y"
    { GstElement *element =
							  gst_element_make_from_uri (GST_URI_SINK, (yyvsp[(2) - (2)].s), NULL, NULL);
						/* FIXME: get and parse error properly */
						if (!element) {
						  SET_ERROR (graph->error, GST_PARSE_ERROR_NO_SUCH_ELEMENT,
							  _("no sink element for URI \"%s\""), (yyvsp[(2) - (2)].s));
						  gst_parse_link_free ((yyvsp[(1) - (2)].l));
						  g_free ((yyvsp[(2) - (2)].s));
						  YYERROR;
						} else if ((yyvsp[(1) - (2)].l)->sink_name || (yyvsp[(1) - (2)].l)->sink_pads) {
                                                  gst_object_unref (element);
						  SET_ERROR (graph->error, GST_PARSE_ERROR_LINK,
							  _("could not link sink element for URI \"%s\""), (yyvsp[(2) - (2)].s));
						  gst_parse_link_free ((yyvsp[(1) - (2)].l));
						  g_free ((yyvsp[(2) - (2)].s));
						  YYERROR;
						} else {
						  (yyval.c) = gst_parse_chain_new ();
						  (yyval.c)->first = (yyval.c)->last = element;
						  (yyval.c)->front = (yyvsp[(1) - (2)].l);
						  (yyval.c)->front->sink = element;
						  (yyval.c)->elements = g_slist_prepend (NULL, element);
						}
						g_free ((yyvsp[(2) - (2)].s));
					      ;}
    break;

  case 31:
#line 869 "./grammar.y"
    { SET_ERROR (graph->error, GST_PARSE_ERROR_EMPTY, _("empty pipeline not allowed"));
						(yyval.g) = graph;
					      ;}
    break;

  case 32:
#line 872 "./grammar.y"
    { (yyval.g) = graph;
						if ((yyvsp[(1) - (1)].c)->front) {
						  if (!(yyvsp[(1) - (1)].c)->front->src_name) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without source element"));
						    gst_parse_free_link ((yyvsp[(1) - (1)].c)->front);
						  } else {
						    (yyval.g)->links = g_slist_prepend ((yyval.g)->links, (yyvsp[(1) - (1)].c)->front);
						  }
						  (yyvsp[(1) - (1)].c)->front = NULL;
						}
						if ((yyvsp[(1) - (1)].c)->back) {
						  if (!(yyvsp[(1) - (1)].c)->back->sink_name) {
						    SET_ERROR (graph->error, GST_PARSE_ERROR_LINK, _("link without sink element"));
						    gst_parse_free_link ((yyvsp[(1) - (1)].c)->back);
						  } else {
						    (yyval.g)->links = g_slist_prepend ((yyval.g)->links, (yyvsp[(1) - (1)].c)->back);
						  }
						  (yyvsp[(1) - (1)].c)->back = NULL;
						}
						(yyval.g)->chain = (yyvsp[(1) - (1)].c);
					      ;}
    break;


/* Line 1267 of yacc.c.  */
#line 2372 "grammar.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (scanner, graph, YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (scanner, graph, yymsg);
	  }
	else
	  {
	    yyerror (scanner, graph, YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, scanner, graph);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, scanner, graph);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (scanner, graph, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, scanner, graph);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, scanner, graph);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 895 "./grammar.y"



static int
yyerror (void *scanner, graph_t *graph, const char *s)
{
  /* FIXME: This should go into the GError somehow, but how? */
  GST_WARNING ("Error during parsing: %s", s);
  return -1;
}


GstElement *
priv_gst_parse_launch (const gchar *str, GError **error, GstParseContext *ctx,
    GstParseFlags flags)
{
  graph_t g;
  gchar *dstr;
  GSList *walk;
  GstBin *bin = NULL;
  GstElement *ret;
  yyscan_t scanner;

  g_return_val_if_fail (str != NULL, NULL);
  g_return_val_if_fail (error == NULL || *error == NULL, NULL);

  g.chain = NULL;
  g.links = NULL;
  g.error = error;
  g.ctx = ctx;
  g.flags = flags;

#ifdef __GST_PARSE_TRACE
  GST_CAT_DEBUG (GST_CAT_PIPELINE, "TRACE: tracing enabled");
  __strings = __chains = __links = 0;
#endif /* __GST_PARSE_TRACE */

  dstr = g_strdup (str);
  priv_gst_parse_yylex_init (&scanner);
  priv_gst_parse_yy_scan_string (dstr, scanner);

#ifndef YYDEBUG
  yydebug = 1;
#endif

  if (yyparse (scanner, &g) != 0) {
    SET_ERROR (error, GST_PARSE_ERROR_SYNTAX,
        "Unrecoverable syntax error while parsing pipeline %s", str);

    priv_gst_parse_yylex_destroy (scanner);
    g_free (dstr);

    goto error1;
  }
  priv_gst_parse_yylex_destroy (scanner);
  g_free (dstr);

  GST_CAT_DEBUG (GST_CAT_PIPELINE, "got %u elements and %u links",
      g.chain ? g_slist_length (g.chain->elements) : 0,
      g_slist_length (g.links));

  if (!g.chain) {
    ret = NULL;
  } else if (!g.chain->elements->next) {
    /* only one toplevel element */
    ret = (GstElement *) g.chain->elements->data;
    g_slist_free (g.chain->elements);
    if (GST_IS_BIN (ret))
      bin = GST_BIN (ret);
    gst_parse_chain_free (g.chain);
  } else {
    /* put all elements in our bin */
    bin = GST_BIN (gst_element_factory_make ("pipeline", NULL));
    g_assert (bin);

    for (walk = g.chain->elements; walk; walk = walk->next) {
      if (walk->data != NULL)
        gst_bin_add (bin, GST_ELEMENT (walk->data));
    }

    g_slist_free (g.chain->elements);
    ret = GST_ELEMENT (bin);
    gst_parse_chain_free (g.chain);
  }

  /* remove links */
  for (walk = g.links; walk; walk = walk->next) {
    link_t *l = (link_t *) walk->data;
    if (!l->src) {
      if (l->src_name) {
        if (bin) {
          l->src = gst_bin_get_by_name_recurse_up (bin, l->src_name);
          if (l->src)
            gst_object_unref (l->src);
        } else {
          l->src = strcmp (GST_ELEMENT_NAME (ret), l->src_name) == 0 ? ret : NULL;
        }
      }
      if (!l->src) {
        if (l->src_name) {
          SET_ERROR (error, GST_PARSE_ERROR_NO_SUCH_ELEMENT,
              "No element named \"%s\" - omitting link", l->src_name);
        } else {
          /* probably a missing element which we've handled already */
        }
        gst_parse_free_link (l);
        continue;
      }
    }
    if (!l->sink) {
      if (l->sink_name) {
        if (bin) {
          l->sink = gst_bin_get_by_name_recurse_up (bin, l->sink_name);
          if (l->sink)
            gst_object_unref (l->sink);
        } else {
          l->sink = strcmp (GST_ELEMENT_NAME (ret), l->sink_name) == 0 ? ret : NULL;
        }
      }
      if (!l->sink) {
        if (l->sink_name) {
          SET_ERROR (error, GST_PARSE_ERROR_NO_SUCH_ELEMENT,
              "No element named \"%s\" - omitting link", l->sink_name);
        } else {
          /* probably a missing element which we've handled already */
        }
        gst_parse_free_link (l);
        continue;
      }
    }
    gst_parse_perform_link (l, &g);
  }
  g_slist_free (g.links);

out:
#ifdef __GST_PARSE_TRACE
  GST_CAT_DEBUG (GST_CAT_PIPELINE,
      "TRACE: %u strings, %u chains and %u links left", __strings, __chains,
      __links);
  if (__strings || __chains || __links) {
    g_warning ("TRACE: %u strings, %u chains and %u links left", __strings,
        __chains, __links);
  }
#endif /* __GST_PARSE_TRACE */

  return ret;

error1:
  if (g.chain) {
    g_slist_foreach (g.chain->elements, (GFunc)gst_object_unref, NULL);
    g_slist_free (g.chain->elements);
    gst_parse_chain_free (g.chain);
  }

  g_slist_foreach (g.links, (GFunc)gst_parse_free_link, NULL);
  g_slist_free (g.links);

  if (error)
    g_assert (*error);
  ret = NULL;

  goto out;
}

