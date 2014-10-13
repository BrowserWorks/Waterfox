/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gsturi.h: Header for uri to element mappings
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


#ifndef __GST_URI_H__
#define __GST_URI_H__

#include <glib.h>
#include <gst/gstelement.h>

G_BEGIN_DECLS

GQuark gst_uri_error_quark (void);

/**
 * GST_URI_ERROR:
 *
 * Get access to the error quark of the uri subsystem.
 */
#define GST_URI_ERROR gst_uri_error_quark ()

/**
 * GstURIError:
 * @GST_URI_ERROR_UNSUPPORTED_PROTOCOL: The protocol is not supported
 * @GST_URI_ERROR_BAD_URI: There was a problem with the URI
 * @GST_URI_ERROR_BAD_STATE: Could not set or change the URI because the
 *     URI handler was in a state where that is not possible or not permitted
 * @GST_URI_ERROR_BAD_REFERENCE: There was a problem with the entity that
 *     the URI references
 *
 * Different URI-related errors that can occur.
 */
typedef enum
{
  GST_URI_ERROR_UNSUPPORTED_PROTOCOL,
  GST_URI_ERROR_BAD_URI,
  GST_URI_ERROR_BAD_STATE,
  GST_URI_ERROR_BAD_REFERENCE
} GstURIError;

/**
 * GstURIType:
 * @GST_URI_UNKNOWN: The URI direction is unknown
 * @GST_URI_SINK: The URI is a consumer.
 * @GST_URI_SRC: The URI is a producer.
 *
 * The different types of URI direction.
 */

typedef enum {
  GST_URI_UNKNOWN,
  GST_URI_SINK,
  GST_URI_SRC
} GstURIType;

/**
 * GST_URI_TYPE_IS_VALID:
 * @type: A #GstURIType
 *
 * Tests if the type direction is valid.
 */
#define GST_URI_TYPE_IS_VALID(type) ((type) == GST_URI_SRC || (type) == GST_URI_SINK)

/* uri handler functions */
#define GST_TYPE_URI_HANDLER               (gst_uri_handler_get_type ())
#define GST_URI_HANDLER(obj)               (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_URI_HANDLER, GstURIHandler))
#define GST_IS_URI_HANDLER(obj)            (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_URI_HANDLER))
#define GST_URI_HANDLER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), GST_TYPE_URI_HANDLER, GstURIHandlerInterface))

/**
 * GstURIHandler:
 *
 * Opaque #GstURIHandler structure.
 */
typedef struct _GstURIHandler GstURIHandler;
typedef struct _GstURIHandlerInterface GstURIHandlerInterface;

/**
 * GstURIHandlerInterface:
 * @parent: The parent interface type
 * @get_type: Method to tell whether the element handles source or sink URI.
 * @get_protocols: Method to return the list of protocols handled by the element.
 * @get_uri: Method to return the URI currently handled by the element.
 * @set_uri: Method to set a new URI.
 *
 * Any #GstElement using this interface should implement these methods.
 */
struct _GstURIHandlerInterface {
  GTypeInterface parent;

  /* vtable */
  /*< public >*/
  /* querying capabilities */
  GstURIType             (* get_type)           (GType type);
  const gchar * const *  (* get_protocols)      (GType type);

  /* using the interface */
  gchar *                (* get_uri)            (GstURIHandler * handler);
  gboolean               (* set_uri)            (GstURIHandler * handler,
                                                 const gchar   * uri,
                                                 GError       ** error);
};

/* general URI functions */

gboolean        gst_uri_protocol_is_valid       (const gchar * protocol);
gboolean        gst_uri_protocol_is_supported   (const GstURIType type,
                                                 const gchar *protocol);
gboolean        gst_uri_is_valid                (const gchar * uri);
gchar *         gst_uri_get_protocol            (const gchar * uri) G_GNUC_MALLOC;
gboolean        gst_uri_has_protocol            (const gchar * uri,
                                                 const gchar * protocol);
gchar *         gst_uri_get_location            (const gchar * uri) G_GNUC_MALLOC;
gchar *         gst_uri_construct               (const gchar * protocol,
                                                 const gchar * location) G_GNUC_MALLOC;

gchar *         gst_filename_to_uri             (const gchar * filename,
                                                 GError     ** error) G_GNUC_MALLOC;

GstElement *    gst_element_make_from_uri       (const GstURIType type,
                                                 const gchar *    uri,
                                                 const gchar *    elementname,
                                                 GError      **   error) G_GNUC_MALLOC;

/* accessing the interface */
GType                 gst_uri_handler_get_type (void);

GstURIType            gst_uri_handler_get_uri_type  (GstURIHandler * handler);
const gchar * const * gst_uri_handler_get_protocols (GstURIHandler * handler);
gchar *               gst_uri_handler_get_uri       (GstURIHandler * handler) G_GNUC_MALLOC;
gboolean              gst_uri_handler_set_uri       (GstURIHandler * handler,
                                                     const gchar   * uri,
                                                     GError       ** error);

G_END_DECLS

#endif /* __GST_URI_H__ */
