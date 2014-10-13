/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2002 Andy Wingo <wingo@pobox.com>
 *                    2008 Tim-Philipp Müller <tim centricular net>
 *
 * gstparse.c: get a pipeline from a text pipeline description
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
 * SECTION:gstparse
 * @short_description: Get a pipeline from a text pipeline description
 *
 * These function allow to create a pipeline based on the syntax used in the
 * gst-launch utility (see man-page for syntax documentation).
 *
 * Please note that these functions take several measures to create
 * somewhat dynamic pipelines. Due to that such pipelines are not always
 * reusable (set the state to NULL and back to PLAYING).
 */

#include "gst_private.h"
#include <string.h>

#include "gstparse.h"
#include "gsterror.h"
#include "gstinfo.h"
#ifndef GST_DISABLE_PARSE
#include "parse/types.h"
#endif

static GstParseContext *
gst_parse_context_copy (const GstParseContext * context)
{
  GstParseContext *ret = NULL;
#ifndef GST_DISABLE_PARSE

  ret = gst_parse_context_new ();
  if (context) {
    GQueue missing_copy = G_QUEUE_INIT;
    GList *l;

    for (l = context->missing_elements; l != NULL; l = l->next)
      g_queue_push_tail (&missing_copy, g_strdup ((const gchar *) l->data));

    ret->missing_elements = missing_copy.head;
  }
#endif
  return ret;
}

G_DEFINE_BOXED_TYPE (GstParseContext, gst_parse_context,
    (GBoxedCopyFunc) gst_parse_context_copy,
    (GBoxedFreeFunc) gst_parse_context_free);

/**
 * gst_parse_error_quark:
 *
 * Get the error quark used by the parsing subsystem.
 *
 * Returns: the quark of the parse errors.
 */
GQuark
gst_parse_error_quark (void)
{
  static GQuark quark = 0;

  if (!quark)
    quark = g_quark_from_static_string ("gst_parse_error");
  return quark;
}


/**
 * gst_parse_context_new:
 *
 * Allocates a parse context for use with gst_parse_launch_full() or
 * gst_parse_launchv_full().
 *
 * Free-function: gst_parse_context_free
 *
 * Returns: (transfer full): a newly-allocated parse context. Free with
 *     gst_parse_context_free() when no longer needed.
 */
GstParseContext *
gst_parse_context_new (void)
{
#ifndef GST_DISABLE_PARSE
  GstParseContext *ctx;

  ctx = g_slice_new (GstParseContext);
  ctx->missing_elements = NULL;

  return ctx;
#else
  return NULL;
#endif
}

/**
 * gst_parse_context_free:
 * @context: (transfer full): a #GstParseContext
 *
 * Frees a parse context previously allocated with gst_parse_context_new().
 */
void
gst_parse_context_free (GstParseContext * context)
{
#ifndef GST_DISABLE_PARSE
  if (context) {
    g_list_foreach (context->missing_elements, (GFunc) g_free, NULL);
    g_list_free (context->missing_elements);
    g_slice_free (GstParseContext, context);
  }
#endif
}

/**
 * gst_parse_context_get_missing_elements:
 * @context: a #GstParseContext
 *
 * Retrieve missing elements from a previous run of gst_parse_launch_full()
 * or gst_parse_launchv_full(). Will only return results if an error code
 * of %GST_PARSE_ERROR_NO_SUCH_ELEMENT was returned.
 *
 * Returns: (transfer full) (array zero-terminated=1) (element-type gchar*): a
 *     %NULL-terminated array of element factory name strings of missing
 *     elements. Free with g_strfreev() when no longer needed.
 */
gchar **
gst_parse_context_get_missing_elements (GstParseContext * context)
{
#ifndef GST_DISABLE_PARSE
  gchar **arr;
  GList *l;
  guint len, i;

  g_return_val_if_fail (context != NULL, NULL);

  len = g_list_length (context->missing_elements);

  if (G_UNLIKELY (len == 0))
    return NULL;

  arr = g_new (gchar *, len + 1);

  for (i = 0, l = context->missing_elements; l != NULL; l = l->next, ++i)
    arr[i] = g_strdup (l->data);

  arr[i] = NULL;

  return arr;
#else
  return NULL;
#endif
}

#ifndef GST_DISABLE_PARSE
static gchar *
_gst_parse_escape (const gchar * str)
{
  GString *gstr = NULL;
  gboolean in_quotes;

  g_return_val_if_fail (str != NULL, NULL);

  gstr = g_string_sized_new (strlen (str));

  in_quotes = FALSE;

  while (*str) {
    if (*str == '"' && (!in_quotes || (in_quotes && *(str - 1) != '\\')))
      in_quotes = !in_quotes;

    if (*str == ' ' && !in_quotes)
      g_string_append_c (gstr, '\\');

    g_string_append_c (gstr, *str);
    str++;
  }

  return g_string_free (gstr, FALSE);
}
#endif /* !GST_DISABLE_PARSE */

/**
 * gst_parse_launchv:
 * @argv: (in) (array zero-terminated=1): null-terminated array of arguments
 * @error: pointer to a #GError
 *
 * Create a new element based on command line syntax.
 * @error will contain an error message if an erroneous pipeline is specified.
 * An error does not mean that the pipeline could not be constructed.
 *
 * Returns: (transfer floating): a new element on success and %NULL on failure.
 */
GstElement *
gst_parse_launchv (const gchar ** argv, GError ** error)
{
  return gst_parse_launchv_full (argv, NULL, GST_PARSE_FLAG_NONE, error);
}

/**
 * gst_parse_launchv_full:
 * @argv: (in) (array zero-terminated=1): null-terminated array of arguments
 * @context: (allow-none): a parse context allocated with
 *     gst_parse_context_new(), or %NULL
 * @flags: parsing options, or #GST_PARSE_FLAG_NONE
 * @error: pointer to a #GError (which must be initialised to %NULL)
 *
 * Create a new element based on command line syntax.
 * @error will contain an error message if an erroneous pipeline is specified.
 * An error does not mean that the pipeline could not be constructed.
 *
 * Returns: (transfer floating): a new element on success; on failure, either %NULL
 *   or a partially-constructed bin or element will be returned and @error will
 *   be set (unless you passed #GST_PARSE_FLAG_FATAL_ERRORS in @flags, then
 *   %NULL will always be returned on failure)
 */
GstElement *
gst_parse_launchv_full (const gchar ** argv, GstParseContext * context,
    GstParseFlags flags, GError ** error)
{
#ifndef GST_DISABLE_PARSE
  GstElement *element;
  GString *str;
  const gchar **argvp, *arg;
  gchar *tmp;

  g_return_val_if_fail (argv != NULL, NULL);
  g_return_val_if_fail (error == NULL || *error == NULL, NULL);

  /* let's give it a nice size. */
  str = g_string_sized_new (1024);

  argvp = argv;
  while (*argvp) {
    arg = *argvp;
    GST_DEBUG ("escaping argument %s", arg);
    tmp = _gst_parse_escape (arg);
    g_string_append (str, tmp);
    g_free (tmp);
    g_string_append_c (str, ' ');
    argvp++;
  }

  element = gst_parse_launch_full (str->str, context, flags, error);

  g_string_free (str, TRUE);

  return element;
#else
  /* gst_parse_launch_full() will set a GST_CORE_ERROR_DISABLED error for us */
  return gst_parse_launch_full ("", NULL, 0, error);
#endif
}

/**
 * gst_parse_launch:
 * @pipeline_description: the command line describing the pipeline
 * @error: the error message in case of an erroneous pipeline.
 *
 * Create a new pipeline based on command line syntax.
 * Please note that you might get a return value that is not %NULL even though
 * the @error is set. In this case there was a recoverable parsing error and you
 * can try to play the pipeline.
 *
 * Returns: (transfer floating): a new element on success, %NULL on failure. If
 *    more than one toplevel element is specified by the @pipeline_description,
 *   all elements are put into a #GstPipeline, which than is returned.
 */
GstElement *
gst_parse_launch (const gchar * pipeline_description, GError ** error)
{
  return gst_parse_launch_full (pipeline_description, NULL, GST_PARSE_FLAG_NONE,
      error);
}

/**
 * gst_parse_launch_full:
 * @pipeline_description: the command line describing the pipeline
 * @context: (allow-none): a parse context allocated with
 *      gst_parse_context_new(), or %NULL
 * @flags: parsing options, or #GST_PARSE_FLAG_NONE
 * @error: the error message in case of an erroneous pipeline.
 *
 * Create a new pipeline based on command line syntax.
 * Please note that you might get a return value that is not %NULL even though
 * the @error is set. In this case there was a recoverable parsing error and you
 * can try to play the pipeline.
 *
 * Returns: (transfer floating): a new element on success, %NULL on failure. If
 *    more than one toplevel element is specified by the @pipeline_description,
 *    all elements are put into a #GstPipeline, which then is returned.
 */
GstElement *
gst_parse_launch_full (const gchar * pipeline_description,
    GstParseContext * context, GstParseFlags flags, GError ** error)
{
#ifndef GST_DISABLE_PARSE
  GstElement *element;
  GError *myerror = NULL;

  g_return_val_if_fail (pipeline_description != NULL, NULL);
  g_return_val_if_fail (error == NULL || *error == NULL, NULL);

  GST_CAT_INFO (GST_CAT_PIPELINE, "parsing pipeline description '%s'",
      pipeline_description);

  element = priv_gst_parse_launch (pipeline_description, &myerror, context,
      flags);

  /* don't return partially constructed pipeline if FATAL_ERRORS was given */
  if (G_UNLIKELY (myerror != NULL && element != NULL)) {
    if ((flags & GST_PARSE_FLAG_FATAL_ERRORS)) {
      gst_object_unref (element);
      element = NULL;
    }
  }

  if (myerror)
    g_propagate_error (error, myerror);

  return element;
#else
  gchar *msg;

  GST_WARNING ("Disabled API called");

  msg = gst_error_get_message (GST_CORE_ERROR, GST_CORE_ERROR_DISABLED);
  g_set_error (error, GST_CORE_ERROR, GST_CORE_ERROR_DISABLED, "%s", msg);
  g_free (msg);

  return NULL;
#endif
}
