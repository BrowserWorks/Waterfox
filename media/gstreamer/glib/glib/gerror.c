/* GLIB - Library of useful routines for C programming
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/*
 * Modified by the GLib Team and others 1997-2000.  See the AUTHORS
 * file for a list of people on the GLib Team.  See the ChangeLog
 * files for a list of changes.  These files are distributed with
 * GLib at ftp://ftp.gtk.org/pub/gtk/.
 */

/**
 * SECTION:error_reporting
 * @Title: Error Reporting
 * @Short_description: a system for reporting errors
 *
 * GLib provides a standard method of reporting errors from a called
 * function to the calling code. (This is the same problem solved by
 * exceptions in other languages.) It's important to understand that
 * this method is both a <emphasis>data type</emphasis> (the #GError
 * object) and a <emphasis>set of rules.</emphasis> If you use #GError
 * incorrectly, then your code will not properly interoperate with other
 * code that uses #GError, and users of your API will probably get confused.
 *
 * First and foremost: <emphasis>#GError should only be used to report
 * recoverable runtime errors, never to report programming
 * errors.</emphasis> If the programmer has screwed up, then you should
 * use g_warning(), g_return_if_fail(), g_assert(), g_error(), or some
 * similar facility. (Incidentally, remember that the g_error() function
 * should <emphasis>only</emphasis> be used for programming errors, it
 * should not be used to print any error reportable via #GError.)
 *
 * Examples of recoverable runtime errors are "file not found" or
 * "failed to parse input." Examples of programming errors are "NULL
 * passed to strcmp()" or "attempted to free the same pointer twice."
 * These two kinds of errors are fundamentally different: runtime errors
 * should be handled or reported to the user, programming errors should
 * be eliminated by fixing the bug in the program. This is why most
 * functions in GLib and GTK+ do not use the #GError facility.
 *
 * Functions that can fail take a return location for a #GError as their
 * last argument. For example:
 * |[
 * gboolean g_file_get_contents (const gchar  *filename,
 *                               gchar       **contents,
 *                               gsize        *length,
 *                               GError      **error);
 * ]|
 * If you pass a non-%NULL value for the <literal>error</literal>
 * argument, it should point to a location where an error can be placed.
 * For example:
 * |[
 * gchar *contents;
 * GError *err = NULL;
 * g_file_get_contents ("foo.txt", &amp;contents, NULL, &amp;err);
 * g_assert ((contents == NULL &amp;&amp; err != NULL) || (contents != NULL &amp;&amp; err == NULL));
 * if (err != NULL)
 *   {
 *     /&ast; Report error to user, and free error &ast;/
 *     g_assert (contents == NULL);
 *     fprintf (stderr, "Unable to read file: &percnt;s\n", err->message);
 *     g_error_free (err);
 *   }
 * else
 *   {
 *     /&ast; Use file contents &ast;/
 *     g_assert (contents != NULL);
 *   }
 * ]|
 * Note that <literal>err != NULL</literal> in this example is a
 * <emphasis>reliable</emphasis> indicator of whether
 * g_file_get_contents() failed. Additionally, g_file_get_contents()
 * returns a boolean which indicates whether it was successful.
 *
 * Because g_file_get_contents() returns %FALSE on failure, if you
 * are only interested in whether it failed and don't need to display
 * an error message, you can pass %NULL for the <literal>error</literal>
 * argument:
 * |[
 * if (g_file_get_contents ("foo.txt", &amp;contents, NULL, NULL)) /&ast; ignore errors &ast;/
 *   /&ast; no error occurred &ast;/ ;
 * else
 *   /&ast; error &ast;/ ;
 * ]|
 *
 * The #GError object contains three fields: <literal>domain</literal>
 * indicates the module the error-reporting function is located in,
 * <literal>code</literal> indicates the specific error that occurred,
 * and <literal>message</literal> is a user-readable error message with
 * as many details as possible. Several functions are provided to deal
 * with an error received from a called function: g_error_matches()
 * returns %TRUE if the error matches a given domain and code,
 * g_propagate_error() copies an error into an error location (so the
 * calling function will receive it), and g_clear_error() clears an
 * error location by freeing the error and resetting the location to
 * %NULL. To display an error to the user, simply display
 * <literal>error-&gt;message</literal>, perhaps along with additional
 * context known only to the calling function (the file being opened,
 * or whatever -- though in the g_file_get_contents() case,
 * <literal>error-&gt;message</literal> already contains a filename).
 *
 * When implementing a function that can report errors, the basic
 * tool is g_set_error(). Typically, if a fatal error occurs you
 * want to g_set_error(), then return immediately. g_set_error()
 * does nothing if the error location passed to it is %NULL.
 * Here's an example:
 * |[
 * gint
 * foo_open_file (GError **error)
 * {
 *   gint fd;
 *
 *   fd = open ("file.txt", O_RDONLY);
 *
 *   if (fd &lt; 0)
 *     {
 *       g_set_error (error,
 *                    FOO_ERROR,                 /&ast; error domain &ast;/
 *                    FOO_ERROR_BLAH,            /&ast; error code &ast;/
 *                    "Failed to open file: &percnt;s", /&ast; error message format string &ast;/
 *                    g_strerror (errno));
 *       return -1;
 *     }
 *   else
 *     return fd;
 * }
 * ]|
 *
 * Things are somewhat more complicated if you yourself call another
 * function that can report a #GError. If the sub-function indicates
 * fatal errors in some way other than reporting a #GError, such as
 * by returning %TRUE on success, you can simply do the following:
 * |[
 * gboolean
 * my_function_that_can_fail (GError **err)
 * {
 *   g_return_val_if_fail (err == NULL || *err == NULL, FALSE);
 *
 *   if (!sub_function_that_can_fail (err))
 *     {
 *       /&ast; assert that error was set by the sub-function &ast;/
 *       g_assert (err == NULL || *err != NULL);
 *       return FALSE;
 *     }
 *
 *   /&ast; otherwise continue, no error occurred &ast;/
 *   g_assert (err == NULL || *err == NULL);
 * }
 * ]|
 *
 * If the sub-function does not indicate errors other than by
 * reporting a #GError, you need to create a temporary #GError
 * since the passed-in one may be %NULL. g_propagate_error() is
 * intended for use in this case.
 * |[
 * gboolean
 * my_function_that_can_fail (GError **err)
 * {
 *   GError *tmp_error;
 *
 *   g_return_val_if_fail (err == NULL || *err == NULL, FALSE);
 *
 *   tmp_error = NULL;
 *   sub_function_that_can_fail (&amp;tmp_error);
 *
 *   if (tmp_error != NULL)
 *     {
 *       /&ast; store tmp_error in err, if err != NULL,
 *        &ast; otherwise call g_error_free() on tmp_error
 *        &ast;/
 *       g_propagate_error (err, tmp_error);
 *       return FALSE;
 *     }
 *
 *   /&ast; otherwise continue, no error occurred &ast;/
 * }
 * ]|
 *
 * Error pileups are always a bug. For example, this code is incorrect:
 * |[
 * gboolean
 * my_function_that_can_fail (GError **err)
 * {
 *   GError *tmp_error;
 *
 *   g_return_val_if_fail (err == NULL || *err == NULL, FALSE);
 *
 *   tmp_error = NULL;
 *   sub_function_that_can_fail (&amp;tmp_error);
 *   other_function_that_can_fail (&amp;tmp_error);
 *
 *   if (tmp_error != NULL)
 *     {
 *       g_propagate_error (err, tmp_error);
 *       return FALSE;
 *     }
 * }
 * ]|
 * <literal>tmp_error</literal> should be checked immediately after
 * sub_function_that_can_fail(), and either cleared or propagated
 * upward. The rule is: <emphasis>after each error, you must either
 * handle the error, or return it to the calling function</emphasis>.
 * Note that passing %NULL for the error location is the equivalent
 * of handling an error by always doing nothing about it. So the
 * following code is fine, assuming errors in sub_function_that_can_fail()
 * are not fatal to my_function_that_can_fail():
 * |[
 * gboolean
 * my_function_that_can_fail (GError **err)
 * {
 *   GError *tmp_error;
 *
 *   g_return_val_if_fail (err == NULL || *err == NULL, FALSE);
 *
 *   sub_function_that_can_fail (NULL); /&ast; ignore errors &ast;/
 *
 *   tmp_error = NULL;
 *   other_function_that_can_fail (&amp;tmp_error);
 *
 *   if (tmp_error != NULL)
 *     {
 *       g_propagate_error (err, tmp_error);
 *       return FALSE;
 *     }
 * }
 * ]|
 *
 * Note that passing %NULL for the error location
 * <emphasis>ignores</emphasis> errors; it's equivalent to
 * <literal>try { sub_function_that_can_fail (); } catch (...) {}</literal>
 * in C++. It does <emphasis>not</emphasis> mean to leave errors
 * unhandled; it means to handle them by doing nothing.
 *
 * Error domains and codes are conventionally named as follows:
 * <itemizedlist>
 * <listitem><para>
 *   The error domain is called
 *   <literal>&lt;NAMESPACE&gt;_&lt;MODULE&gt;_ERROR</literal>,
 *   for example %G_SPAWN_ERROR or %G_THREAD_ERROR:
 *   |[
 * #define G_SPAWN_ERROR g_spawn_error_quark ()
 *
 * GQuark
 * g_spawn_error_quark (void)
 * {
 *   return g_quark_from_static_string ("g-spawn-error-quark");
 * }
 *   ]|
 * </para></listitem>
 * <listitem><para>
 *   The quark function for the error domain is called
 *   <literal>&lt;namespace&gt;_&lt;module&gt;_error_quark</literal>,
 *   for example g_spawn_error_quark() or g_thread_error_quark().
 * </para></listitem>
 * <listitem><para>
 *   The error codes are in an enumeration called
 *   <literal>&lt;Namespace&gt;&lt;Module&gt;Error</literal>;
 *   for example,#GThreadError or #GSpawnError.
 * </para></listitem>
 * <listitem><para>
 *   Members of the error code enumeration are called
 *   <literal>&lt;NAMESPACE&gt;_&lt;MODULE&gt;_ERROR_&lt;CODE&gt;</literal>,
 *   for example %G_SPAWN_ERROR_FORK or %G_THREAD_ERROR_AGAIN.
 * </para></listitem>
 * <listitem><para>
 *   If there's a "generic" or "unknown" error code for unrecoverable
 *   errors it doesn't make sense to distinguish with specific codes,
 *   it should be called <literal>&lt;NAMESPACE&gt;_&lt;MODULE&gt;_ERROR_FAILED</literal>,
 *   for example %G_SPAWN_ERROR_FAILED.
 * </para></listitem>
 * </itemizedlist>
 *
 * Summary of rules for use of #GError:
 * <itemizedlist>
 * <listitem><para>
 *   Do not report programming errors via #GError.
 * </para></listitem>
 * <listitem><para>
 *   The last argument of a function that returns an error should
 *   be a location where a #GError can be placed (i.e. "#GError** error").
 *   If #GError is used with varargs, the #GError** should be the last
 *   argument before the "...".
 * </para></listitem>
 * <listitem><para>
 *   The caller may pass %NULL for the #GError** if they are not interested
 *   in details of the exact error that occurred.
 * </para></listitem>
 * <listitem><para>
 *   If %NULL is passed for the #GError** argument, then errors should
 *   not be returned to the caller, but your function should still
 *   abort and return if an error occurs. That is, control flow should
 *   not be affected by whether the caller wants to get a #GError.
 * </para></listitem>
 * <listitem><para>
 *   If a #GError is reported, then your function by definition
 *   <emphasis>had a fatal failure and did not complete whatever
 *   it was supposed to do</emphasis>. If the failure was not fatal,
 *   then you handled it and you should not report it. If it was fatal,
 *   then you must report it and discontinue whatever you were doing
 *   immediately.
 * </para></listitem>
 * <listitem><para>
 *   If a #GError is reported, out parameters are not guaranteed to
 *   be set to any defined value.
 * </para></listitem>
 * <listitem><para>
 *   A #GError* must be initialized to %NULL before passing its address
 *   to a function that can report errors.
 * </para></listitem>
 * <listitem><para>
 *   "Piling up" errors is always a bug. That is, if you assign a
 *   new #GError to a #GError* that is non-%NULL, thus overwriting
 *   the previous error, it indicates that you should have aborted
 *   the operation instead of continuing. If you were able to continue,
 *   you should have cleared the previous error with g_clear_error().
 *   g_set_error() will complain if you pile up errors.
 * </para></listitem>
 * <listitem><para>
 *   By convention, if you return a boolean value indicating success
 *   then %TRUE means success and %FALSE means failure. If %FALSE is
 *   returned, the error <emphasis>must</emphasis> be set to a non-%NULL
 *   value.
 * </para></listitem>
 * <listitem><para>
 *   A %NULL return value is also frequently used to mean that an error
 *   occurred. You should make clear in your documentation whether %NULL
 *   is a valid return value in non-error cases; if %NULL is a valid value,
 *   then users must check whether an error was returned to see if the
 *   function succeeded.
 * </para></listitem>
 * <listitem><para>
 *   When implementing a function that can report errors, you may want
 *   to add a check at the top of your function that the error return
 *   location is either %NULL or contains a %NULL error (e.g.
 *   <literal>g_return_if_fail (error == NULL || *error == NULL);</literal>).
 * </para></listitem>
 * </itemizedlist>
 */

#include "config.h"

#include "gerror.h"

#include "gslice.h"
#include "gstrfuncs.h"
#include "gtestutils.h"

/**
 * g_error_new_valist:
 * @domain: error domain
 * @code: error code
 * @format: printf()-style format for error message
 * @args: #va_list of parameters for the message format
 *
 * Creates a new #GError with the given @domain and @code,
 * and a message formatted with @format.
 *
 * Returns: a new #GError
 *
 * Since: 2.22
 */
GError*
g_error_new_valist (GQuark       domain,
                    gint         code,
                    const gchar *format,
                    va_list      args)
{
  GError *error;

  /* Historically, GError allowed this (although it was never meant to work),
   * and it has significant use in the wild, which g_return_val_if_fail
   * would break. It should maybe g_return_val_if_fail in GLib 4.
   * (GNOME#660371, GNOME#560482)
   */
  g_warn_if_fail (domain != 0);
  g_warn_if_fail (format != NULL);

  error = g_slice_new (GError);

  error->domain = domain;
  error->code = code;
  error->message = g_strdup_vprintf (format, args);

  return error;
}

/**
 * g_error_new:
 * @domain: error domain
 * @code: error code
 * @format: printf()-style format for error message
 * @...: parameters for message format
 *
 * Creates a new #GError with the given @domain and @code,
 * and a message formatted with @format.
 *
 * Return value: a new #GError
 */
GError*
g_error_new (GQuark       domain,
             gint         code,
             const gchar *format,
             ...)
{
  GError* error;
  va_list args;

  g_return_val_if_fail (format != NULL, NULL);
  g_return_val_if_fail (domain != 0, NULL);

  va_start (args, format);
  error = g_error_new_valist (domain, code, format, args);
  va_end (args);

  return error;
}

/**
 * g_error_new_literal:
 * @domain: error domain
 * @code: error code
 * @message: error message
 *
 * Creates a new #GError; unlike g_error_new(), @message is
 * not a printf()-style format string. Use this function if
 * @message contains text you don't have control over,
 * that could include printf() escape sequences.
 *
 * Return value: a new #GError
 **/
GError*
g_error_new_literal (GQuark         domain,
                     gint           code,
                     const gchar   *message)
{
  GError* err;

  g_return_val_if_fail (message != NULL, NULL);
  g_return_val_if_fail (domain != 0, NULL);

  err = g_slice_new (GError);

  err->domain = domain;
  err->code = code;
  err->message = g_strdup (message);

  return err;
}

/**
 * g_error_free:
 * @error: a #GError
 *
 * Frees a #GError and associated resources.
 */
void
g_error_free (GError *error)
{
  g_return_if_fail (error != NULL);

  g_free (error->message);

  g_slice_free (GError, error);
}

/**
 * g_error_copy:
 * @error: a #GError
 *
 * Makes a copy of @error.
 *
 * Return value: a new #GError
 */
GError*
g_error_copy (const GError *error)
{
  GError *copy;
 
  g_return_val_if_fail (error != NULL, NULL);
  /* See g_error_new_valist for why these don't return */
  g_warn_if_fail (error->domain != 0);
  g_warn_if_fail (error->message != NULL);

  copy = g_slice_new (GError);

  *copy = *error;

  copy->message = g_strdup (error->message);

  return copy;
}

/**
 * g_error_matches:
 * @error: (allow-none): a #GError or %NULL
 * @domain: an error domain
 * @code: an error code
 *
 * Returns %TRUE if @error matches @domain and @code, %FALSE
 * otherwise. In particular, when @error is %NULL, %FALSE will
 * be returned.
 *
 * Return value: whether @error has @domain and @code
 */
gboolean
g_error_matches (const GError *error,
                 GQuark        domain,
                 gint          code)
{
  return error &&
    error->domain == domain &&
    error->code == code;
}

#define ERROR_OVERWRITTEN_WARNING "GError set over the top of a previous GError or uninitialized memory.\n" \
               "This indicates a bug in someone's code. You must ensure an error is NULL before it's set.\n" \
               "The overwriting error message was: %s"

/**
 * g_set_error:
 * @err: (allow-none): a return location for a #GError, or %NULL
 * @domain: error domain
 * @code: error code
 * @format: printf()-style format
 * @...: args for @format
 *
 * Does nothing if @err is %NULL; if @err is non-%NULL, then *@err
 * must be %NULL. A new #GError is created and assigned to *@err.
 */
void
g_set_error (GError      **err,
             GQuark        domain,
             gint          code,
             const gchar  *format,
             ...)
{
  GError *new;

  va_list args;

  if (err == NULL)
    return;

  va_start (args, format);
  new = g_error_new_valist (domain, code, format, args);
  va_end (args);

  if (*err == NULL)
    *err = new;
  else
    g_warning (ERROR_OVERWRITTEN_WARNING, new->message); 
}

/**
 * g_set_error_literal:
 * @err: (allow-none): a return location for a #GError, or %NULL
 * @domain: error domain
 * @code: error code
 * @message: error message
 *
 * Does nothing if @err is %NULL; if @err is non-%NULL, then *@err
 * must be %NULL. A new #GError is created and assigned to *@err.
 * Unlike g_set_error(), @message is not a printf()-style format string.
 * Use this function if @message contains text you don't have control over,
 * that could include printf() escape sequences.
 *
 * Since: 2.18
 */
void
g_set_error_literal (GError      **err,
                     GQuark        domain,
                     gint          code,
                     const gchar  *message)
{
  GError *new;

  if (err == NULL)
    return;

  new = g_error_new_literal (domain, code, message);
  if (*err == NULL)
    *err = new;
  else
    g_warning (ERROR_OVERWRITTEN_WARNING, new->message); 
}

/**
 * g_propagate_error:
 * @dest: error return location
 * @src: error to move into the return location
 *
 * If @dest is %NULL, free @src; otherwise, moves @src into *@dest.
 * The error variable @dest points to must be %NULL.
 */
void
g_propagate_error (GError **dest,
		   GError  *src)
{
  g_return_if_fail (src != NULL);
 
  if (dest == NULL)
    {
      if (src)
        g_error_free (src);
      return;
    }
  else
    {
      if (*dest != NULL)
        g_warning (ERROR_OVERWRITTEN_WARNING, src->message);
      else
        *dest = src;
    }
}

/**
 * g_clear_error:
 * @err: a #GError return location
 *
 * If @err is %NULL, does nothing. If @err is non-%NULL,
 * calls g_error_free() on *@err and sets *@err to %NULL.
 */
void
g_clear_error (GError **err)
{
  if (err && *err)
    {
      g_error_free (*err);
      *err = NULL;
    }
}

G_GNUC_PRINTF(2, 0)
static void
g_error_add_prefix (gchar       **string,
                    const gchar  *format,
                    va_list       ap)
{
  gchar *oldstring;
  gchar *prefix;

  prefix = g_strdup_vprintf (format, ap);
  oldstring = *string;
  *string = g_strconcat (prefix, oldstring, NULL);
  g_free (oldstring);
  g_free (prefix);
}

/**
 * g_prefix_error:
 * @err: (allow-none): a return location for a #GError, or %NULL
 * @format: printf()-style format string
 * @...: arguments to @format
 *
 * Formats a string according to @format and
 * prefix it to an existing error message.  If
 * @err is %NULL (ie: no error variable) then do
 * nothing.
 *
 * If *@err is %NULL (ie: an error variable is
 * present but there is no error condition) then
 * also do nothing.  Whether or not it makes
 * sense to take advantage of this feature is up
 * to you.
 *
 * Since: 2.16
 */
void
g_prefix_error (GError      **err,
                const gchar  *format,
                ...)
{
  if (err && *err)
    {
      va_list ap;

      va_start (ap, format);
      g_error_add_prefix (&(*err)->message, format, ap);
      va_end (ap);
    }
}

/**
 * g_propagate_prefixed_error:
 * @dest: error return location
 * @src: error to move into the return location
 * @format: printf()-style format string
 * @...: arguments to @format
 *
 * If @dest is %NULL, free @src; otherwise,
 * moves @src into *@dest. *@dest must be %NULL.
 * After the move, add a prefix as with
 * g_prefix_error().
 *
 * Since: 2.16
 **/
void
g_propagate_prefixed_error (GError      **dest,
                            GError       *src,
                            const gchar  *format,
                            ...)
{
  g_propagate_error (dest, src);

  if (dest && *dest)
    {
      va_list ap;

      va_start (ap, format);
      g_error_add_prefix (&(*dest)->message, format, ap);
      va_end (ap);
    }
}
