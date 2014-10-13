/* GStreamer
 * Copyright (C) <2003> David A. Schleef <ds@schleef.org>
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
 * SECTION:gsterror
 * @short_description: Categorized error messages
 * @see_also: #GstMessage
 *
 * GStreamer elements can throw non-fatal warnings and fatal errors.
 * Higher-level elements and applications can programmatically filter
 * the ones they are interested in or can recover from,
 * and have a default handler handle the rest of them.
 *
 * The rest of this section will use the term <quote>error</quote>
 * to mean both (non-fatal) warnings and (fatal) errors; they are treated
 * similarly.
 *
 * Errors from elements are the combination of a #GError and a debug string.
 * The #GError contains:
 * - a domain type: CORE, LIBRARY, RESOURCE or STREAM
 * - a code: an enum value specific to the domain
 * - a translated, human-readable message
 * - a non-translated additional debug string, which also contains
 * - file and line information
 *
 * Elements do not have the context required to decide what to do with
 * errors.  As such, they should only inform about errors, and stop their
 * processing.  In short, an element doesn't know what it is being used for.
 *
 * It is the application or compound element using the given element that
 * has more context about the use of the element. Errors can be received by
 * listening to the #GstBus of the element/pipeline for #GstMessage objects with
 * the type %GST_MESSAGE_ERROR or %GST_MESSAGE_WARNING. The thrown errors should
 * be inspected, and filtered if appropriate.
 *
 * An application is expected to, by default, present the user with a
 * dialog box (or an equivalent) showing the error message.  The dialog
 * should also allow a way to get at the additional debug information,
 * so the user can provide bug reporting information.
 *
 * A compound element is expected to forward errors by default higher up
 * the hierarchy; this is done by default in the same way as for other types
 * of #GstMessage.
 *
 * When applications or compound elements trigger errors that they can
 * recover from, they can filter out these errors and take appropriate action.
 * For example, an application that gets an error from xvimagesink
 * that indicates all XVideo ports are taken, the application can attempt
 * to use another sink instead.
 *
 * Elements throw errors using the #GST_ELEMENT_ERROR convenience macro:
 *
 * <example>
 * <title>Throwing an error</title>
 *   <programlisting>
 *     GST_ELEMENT_ERROR (src, RESOURCE, NOT_FOUND,
 *       (_("No file name specified for reading.")), (NULL));
 *   </programlisting>
 * </example>
 *
 * Things to keep in mind:
 * <itemizedlist>
 *   <listitem><para>Don't go off inventing new error codes.  The ones
 *     currently provided should be enough.  If you find your type of error
 *     does not fit the current codes, you should use FAILED.</para></listitem>
 *   <listitem><para>Don't provide a message if the default one suffices.
 *     this keeps messages more uniform.  Use (%NULL) - not forgetting the
 *     parentheses.</para></listitem>
 *   <listitem><para>If you do supply a custom message, it should be
 *     marked for translation.  The message should start with a capital
 *     and end with a period.  The message should describe the error in short,
 *     in a human-readable form, and without any complex technical terms.
 *     A user interface will present this message as the first thing a user
 *     sees.  Details, technical info, ... should go in the debug string.
 *   </para></listitem>
 *   <listitem><para>The debug string can be as you like.  Again, use (%NULL)
 *     if there's nothing to add - file and line number will still be
 *     passed.  #GST_ERROR_SYSTEM can be used as a shortcut to give
 *     debug information on a system call error.</para></listitem>
 * </itemizedlist>
 */

/* FIXME 0.11: the entire error system needs an overhaul - it's not very
 * useful the way it is. Also, we need to be able to specify additional
 * 'details' for errors (e.g. disk/file/resource error -> out-of-space; or
 * put the url/filename/device name that caused the error somewhere)
 * without having to add enums for every little thing.
 *
 * FIXME 0.11: get rid of GST_{CORE,LIBRARY,RESOURCE,STREAM}_ERROR_NUM_ERRORS.
 * Maybe also replace _quark() functions with g_quark_from_static_string()?
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include <gst/gst.h>
#include "gst-i18n-lib.h"

#define QUARK_FUNC(string)                                              \
GQuark gst_ ## string ## _error_quark (void) {                          \
  static GQuark quark;                                                  \
  if (!quark)                                                           \
    quark = g_quark_from_static_string ("gst-" # string "-error-quark"); \
  return quark; }

#define FILE_A_BUG "  Please file a bug at " PACKAGE_BUGREPORT "."

static const gchar *
gst_error_get_core_error (GstCoreError code)
{
  switch (code) {
    case GST_CORE_ERROR_FAILED:
      return _("GStreamer encountered a general core library error.");
    case GST_CORE_ERROR_TOO_LAZY:
      return _("GStreamer developers were too lazy to assign an error code "
          "to this error." FILE_A_BUG);
    case GST_CORE_ERROR_NOT_IMPLEMENTED:
      return _("Internal GStreamer error: code not implemented." FILE_A_BUG);
    case GST_CORE_ERROR_STATE_CHANGE:
      return _("GStreamer error: state change failed and some element failed "
          "to post a proper error message with the reason for the failure.");
    case GST_CORE_ERROR_PAD:
      return _("Internal GStreamer error: pad problem." FILE_A_BUG);
    case GST_CORE_ERROR_THREAD:
      return _("Internal GStreamer error: thread problem." FILE_A_BUG);
    case GST_CORE_ERROR_NEGOTIATION:
      return _("GStreamer error: negotiation problem.");
    case GST_CORE_ERROR_EVENT:
      return _("Internal GStreamer error: event problem." FILE_A_BUG);
    case GST_CORE_ERROR_SEEK:
      return _("Internal GStreamer error: seek problem." FILE_A_BUG);
    case GST_CORE_ERROR_CAPS:
      return _("Internal GStreamer error: caps problem." FILE_A_BUG);
    case GST_CORE_ERROR_TAG:
      return _("Internal GStreamer error: tag problem." FILE_A_BUG);
    case GST_CORE_ERROR_MISSING_PLUGIN:
      return _("Your GStreamer installation is missing a plug-in.");
    case GST_CORE_ERROR_CLOCK:
      return _("GStreamer error: clock problem.");
    case GST_CORE_ERROR_DISABLED:
      return _("This application is trying to use GStreamer functionality "
          "that has been disabled.");
    case GST_CORE_ERROR_NUM_ERRORS:
    default:
      break;
  }
  return NULL;
}

static const gchar *
gst_error_get_library_error (GstLibraryError code)
{
  switch (code) {
    case GST_LIBRARY_ERROR_FAILED:
      return _("GStreamer encountered a general supporting library error.");
    case GST_LIBRARY_ERROR_TOO_LAZY:
      return _("GStreamer developers were too lazy to assign an error code "
          "to this error." FILE_A_BUG);
    case GST_LIBRARY_ERROR_INIT:
      return _("Could not initialize supporting library.");
    case GST_LIBRARY_ERROR_SHUTDOWN:
      return _("Could not close supporting library.");
    case GST_LIBRARY_ERROR_SETTINGS:
      return _("Could not configure supporting library.");
    case GST_LIBRARY_ERROR_ENCODE:
      return _("Encoding error.");
    case GST_LIBRARY_ERROR_NUM_ERRORS:
    default:
      break;
  }
  return NULL;
}

static const gchar *
gst_error_get_resource_error (GstResourceError code)
{
  switch (code) {
    case GST_RESOURCE_ERROR_FAILED:
      return _("GStreamer encountered a general resource error.");
    case GST_RESOURCE_ERROR_TOO_LAZY:
      return _("GStreamer developers were too lazy to assign an error code "
          "to this error." FILE_A_BUG);
    case GST_RESOURCE_ERROR_NOT_FOUND:
      return _("Resource not found.");
    case GST_RESOURCE_ERROR_BUSY:
      return _("Resource busy or not available.");
    case GST_RESOURCE_ERROR_OPEN_READ:
      return _("Could not open resource for reading.");
    case GST_RESOURCE_ERROR_OPEN_WRITE:
      return _("Could not open resource for writing.");
    case GST_RESOURCE_ERROR_OPEN_READ_WRITE:
      return _("Could not open resource for reading and writing.");
    case GST_RESOURCE_ERROR_CLOSE:
      return _("Could not close resource.");
    case GST_RESOURCE_ERROR_READ:
      return _("Could not read from resource.");
    case GST_RESOURCE_ERROR_WRITE:
      return _("Could not write to resource.");
    case GST_RESOURCE_ERROR_SEEK:
      return _("Could not perform seek on resource.");
    case GST_RESOURCE_ERROR_SYNC:
      return _("Could not synchronize on resource.");
    case GST_RESOURCE_ERROR_SETTINGS:
      return _("Could not get/set settings from/on resource.");
    case GST_RESOURCE_ERROR_NO_SPACE_LEFT:
      return _("No space left on the resource.");
    case GST_RESOURCE_ERROR_NOT_AUTHORIZED:
      return _("Not authorized to access resource.");
    case GST_RESOURCE_ERROR_NUM_ERRORS:
    default:
      break;
  }
  return NULL;
}

static const gchar *
gst_error_get_stream_error (GstStreamError code)
{
  switch (code) {
    case GST_STREAM_ERROR_FAILED:
      return _("GStreamer encountered a general stream error.");
    case GST_STREAM_ERROR_TOO_LAZY:
      return _("GStreamer developers were too lazy to assign an error code "
          "to this error." FILE_A_BUG);
    case GST_STREAM_ERROR_NOT_IMPLEMENTED:
      return _("Element doesn't implement handling of this stream. "
          "Please file a bug.");
    case GST_STREAM_ERROR_TYPE_NOT_FOUND:
      return _("Could not determine type of stream.");
    case GST_STREAM_ERROR_WRONG_TYPE:
      return _("The stream is of a different type than handled by this "
          "element.");
    case GST_STREAM_ERROR_CODEC_NOT_FOUND:
      return _("There is no codec present that can handle the stream's type.");
    case GST_STREAM_ERROR_DECODE:
      return _("Could not decode stream.");
    case GST_STREAM_ERROR_ENCODE:
      return _("Could not encode stream.");
    case GST_STREAM_ERROR_DEMUX:
      return _("Could not demultiplex stream.");
    case GST_STREAM_ERROR_MUX:
      return _("Could not multiplex stream.");
    case GST_STREAM_ERROR_FORMAT:
      return _("The stream is in the wrong format.");
    case GST_STREAM_ERROR_DECRYPT:
      return _("The stream is encrypted and decryption is not supported.");
    case GST_STREAM_ERROR_DECRYPT_NOKEY:
      return _("The stream is encrypted and can't be decrypted because no "
          "suitable key has been supplied.");
    case GST_STREAM_ERROR_NUM_ERRORS:
    default:
      break;
  }

  return NULL;
}

QUARK_FUNC (core);
QUARK_FUNC (library);
QUARK_FUNC (resource);
QUARK_FUNC (stream);

/**
 * gst_error_get_message:
 * @domain: the GStreamer error domain this error belongs to.
 * @code: the error code belonging to the domain.
 *
 * Get a string describing the error message in the current locale.
 *
 * Returns: (transfer full): a newly allocated string describing
 *     the error message (in UTF-8 encoding)
 */
gchar *
gst_error_get_message (GQuark domain, gint code)
{
  const gchar *message = NULL;

  if (domain == GST_CORE_ERROR)
    message = gst_error_get_core_error ((GstCoreError) code);
  else if (domain == GST_LIBRARY_ERROR)
    message = gst_error_get_library_error ((GstLibraryError) code);
  else if (domain == GST_RESOURCE_ERROR)
    message = gst_error_get_resource_error ((GstResourceError) code);
  else if (domain == GST_STREAM_ERROR)
    message = gst_error_get_stream_error ((GstStreamError) code);
  else {
    g_warning ("No error messages for domain %s", g_quark_to_string (domain));
    return g_strdup_printf (_("No error message for domain %s."),
        g_quark_to_string (domain));
  }
  if (message)
    return g_strdup (message);
  else
    return
        g_strdup_printf (_
        ("No standard error message for domain %s and code %d."),
        g_quark_to_string (domain), code);
}
