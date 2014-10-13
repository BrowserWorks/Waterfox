/* GStreamer
 * Copyright (C) 2013 Collabora Ltd.
 *   Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>
 * Copyright (C) 2013 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstcontext.h: Header for GstContext subsystem
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
 * SECTION:gstcontext
 * @short_description: Lightweight objects to represent element contexts
 * @see_also: #GstMiniObject, #GstElement
 *
 * #GstContext is a container object used to store contexts like a device
 * context, a display server connection and similar concepts that should
 * be shared between multiple elements.
 *
 * Applications can set a context on a complete pipeline by using
 * gst_element_set_context(), which will then be propagated to all
 * child elements. Elements can handle these in #GstElementClass.set_context()
 * and merge them with the context information they already have.
 *
 * When an element needs a context it will do the following actions in this
 * order until one step succeeds:
 * 1. Check if the element already has a context
 * 2. Query downstream with GST_QUERY_CONTEXT for the context
 * 3. Query upstream with GST_QUERY_CONTEXT for the context
 * 4. Post a GST_MESSAGE_NEED_CONTEXT message on the bus with the required
 *    context types and afterwards check if a usable context was set now
 * 5. Create a context by itself and post a GST_MESSAGE_HAVE_CONTEXT message
 *    on the bus.
 *
 * Bins will catch GST_MESSAGE_NEED_CONTEXT messages and will set any previously
 * known context on the element that asks for it if possible. Otherwise the
 * application should provide one if it can.
 *
 * Since: 1.2
 */

#include "gst_private.h"
#include <string.h>
#include "gstcontext.h"
#include "gstquark.h"

struct _GstContext
{
  GstMiniObject mini_object;

  gchar *context_type;
  GstStructure *structure;
  gboolean persistent;
};

#define GST_CONTEXT_STRUCTURE(c)  (((GstContext *)(c))->structure)

GType _gst_context_type = 0;
GST_DEFINE_MINI_OBJECT_TYPE (GstContext, gst_context);

void
_priv_gst_context_initialize (void)
{
  GST_CAT_INFO (GST_CAT_GST_INIT, "init contexts");

  /* the GstMiniObject types need to be class_ref'd once before it can be
   * done from multiple threads;
   * see http://bugzilla.gnome.org/show_bug.cgi?id=304551 */
  gst_context_get_type ();

  _gst_context_type = gst_context_get_type ();
}

static void
_gst_context_free (GstContext * context)
{
  GstStructure *structure;

  g_return_if_fail (context != NULL);

  GST_CAT_LOG (GST_CAT_CONTEXT, "finalize context %p: %" GST_PTR_FORMAT,
      context, GST_CONTEXT_STRUCTURE (context));

  structure = GST_CONTEXT_STRUCTURE (context);
  if (structure) {
    gst_structure_set_parent_refcount (structure, NULL);
    gst_structure_free (structure);
  }
  g_free (context->context_type);

  g_slice_free1 (sizeof (GstContext), context);
}

static void gst_context_init (GstContext * context);

static GstContext *
_gst_context_copy (GstContext * context)
{
  GstContext *copy;
  GstStructure *structure;

  GST_CAT_LOG (GST_CAT_CONTEXT, "copy context %p: %" GST_PTR_FORMAT, context,
      GST_CONTEXT_STRUCTURE (context));

  copy = g_slice_new0 (GstContext);

  gst_context_init (copy);

  copy->context_type = g_strdup (context->context_type);

  structure = GST_CONTEXT_STRUCTURE (context);
  GST_CONTEXT_STRUCTURE (copy) = gst_structure_copy (structure);
  gst_structure_set_parent_refcount (GST_CONTEXT_STRUCTURE (copy),
      &copy->mini_object.refcount);

  copy->persistent = context->persistent;

  return GST_CONTEXT_CAST (copy);
}

static void
gst_context_init (GstContext * context)
{
  gst_mini_object_init (GST_MINI_OBJECT_CAST (context), 0, _gst_context_type,
      (GstMiniObjectCopyFunction) _gst_context_copy, NULL,
      (GstMiniObjectFreeFunction) _gst_context_free);
}

/**
 * gst_context_new:
 * @context_type: Context type
 * @persistent: Persistent context
 *
 * Create a new context.
 *
 * Returns: (transfer full): The new context.
 *
 * Since: 1.2
 */
GstContext *
gst_context_new (const gchar * context_type, gboolean persistent)
{
  GstContext *context;
  GstStructure *structure;

  g_return_val_if_fail (context_type != NULL, NULL);

  context = g_slice_new0 (GstContext);

  GST_CAT_LOG (GST_CAT_CONTEXT, "creating new context %p", context);

  structure = gst_structure_new_id_empty (GST_QUARK (CONTEXT));
  gst_structure_set_parent_refcount (structure, &context->mini_object.refcount);
  gst_context_init (context);

  context->context_type = g_strdup (context_type);
  GST_CONTEXT_STRUCTURE (context) = structure;
  context->persistent = persistent;

  return context;
}

/**
 * gst_context_get_context_type:
 * @context: The #GstContext.
 *
 * Get the type of @context.
 *
 * Returns: The type of the context.
 *
 * Since: 1.2
 */
const gchar *
gst_context_get_context_type (const GstContext * context)
{
  g_return_val_if_fail (GST_IS_CONTEXT (context), NULL);

  return context->context_type;
}

/**
 * gst_context_has_context_type:
 * @context: The #GstContext.
 * @context_type: Context type to check.
 *
 * Checks if @context has @context_type.
 *
 * Returns: %TRUE if @context has @context_type.
 *
 * Since: 1.2
 */
gboolean
gst_context_has_context_type (const GstContext * context,
    const gchar * context_type)
{
  g_return_val_if_fail (GST_IS_CONTEXT (context), FALSE);
  g_return_val_if_fail (context_type != NULL, FALSE);

  return strcmp (context->context_type, context_type) == 0;
}

/**
 * gst_context_get_structure:
 * @context: The #GstContext.
 *
 * Access the structure of the context.
 *
 * Returns: (transfer none): The structure of the context. The structure is
 * still owned by the context, which means that you should not modify it,
 * free it and that the pointer becomes invalid when you free the context.
 *
 * Since: 1.2
 */
const GstStructure *
gst_context_get_structure (const GstContext * context)
{
  g_return_val_if_fail (GST_IS_CONTEXT (context), NULL);

  return GST_CONTEXT_STRUCTURE (context);
}

/**
 * gst_context_writable_structure:
 * @context: The #GstContext.
 *
 * Get a writable version of the structure.
 *
 * Returns: The structure of the context. The structure is still
 * owned by the event, which means that you should not free it and
 * that the pointer becomes invalid when you free the event.
 * This function checks if @context is writable.
 *
 * Since: 1.2
 */
GstStructure *
gst_context_writable_structure (GstContext * context)
{
  g_return_val_if_fail (GST_IS_CONTEXT (context), NULL);
  g_return_val_if_fail (gst_context_is_writable (context), NULL);

  return GST_CONTEXT_STRUCTURE (context);
}

/**
 * gst_context_is_persistent:
 * @context: The #GstContext.
 *
 * Check if @context is persistent.
 *
 * Returns: %TRUE if the context is persistent.
 *
 * Since: 1.2
 */
gboolean
gst_context_is_persistent (const GstContext * context)
{
  g_return_val_if_fail (GST_IS_CONTEXT (context), FALSE);

  return context->persistent;
}
