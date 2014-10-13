/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstpadtemplate.c: Templates for pad creation
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
 * SECTION:gstpadtemplate
 * @short_description: Describe the media type of a pad.
 * @see_also: #GstPad, #GstElementFactory
 *
 * Padtemplates describe the possible media types a pad or an elementfactory can
 * handle. This allows for both inspection of handled types before loading the
 * element plugin as well as identifying pads on elements that are not yet
 * created (request or sometimes pads).
 *
 * Pad and PadTemplates have #GstCaps attached to it to describe the media type
 * they are capable of dealing with. gst_pad_template_get_caps() or
 * GST_PAD_TEMPLATE_CAPS() are used to get the caps of a padtemplate. It's not
 * possible to modify the caps of a padtemplate after creation.
 *
 * PadTemplates have a #GstPadPresence property which identifies the lifetime
 * of the pad and that can be retrieved with GST_PAD_TEMPLATE_PRESENCE(). Also
 * the direction of the pad can be retrieved from the #GstPadTemplate with
 * GST_PAD_TEMPLATE_DIRECTION().
 *
 * The GST_PAD_TEMPLATE_NAME_TEMPLATE () is important for GST_PAD_REQUEST pads
 * because it has to be used as the name in the gst_element_get_request_pad()
 * call to instantiate a pad from this template.
 *
 * Padtemplates can be created with gst_pad_template_new() or with
 * gst_static_pad_template_get (), which creates a #GstPadTemplate from a
 * #GstStaticPadTemplate that can be filled with the
 * convenient GST_STATIC_PAD_TEMPLATE() macro.
 *
 * A padtemplate can be used to create a pad (see gst_pad_new_from_template()
 * or gst_pad_new_from_static_template ()) or to add to an element class
 * (see gst_element_class_add_pad_template ()).
 *
 * The following code example shows the code to create a pad from a padtemplate.
 * |[
 *   GstStaticPadTemplate my_template =
 *   GST_STATIC_PAD_TEMPLATE (
 *     "sink",          // the name of the pad
 *     GST_PAD_SINK,    // the direction of the pad
 *     GST_PAD_ALWAYS,  // when this pad will be present
 *     GST_STATIC_CAPS (        // the capabilities of the padtemplate
 *       "audio/x-raw, "
 *         "channels = (int) [ 1, 6 ]"
 *     )
 *   );
 *   void
 *   my_method (void)
 *   {
 *     GstPad *pad;
 *     pad = gst_pad_new_from_static_template (&amp;my_template, "sink");
 *     ...
 *   }
 * ]|
 *
 * The following example shows you how to add the padtemplate to an
 * element class, this is usually done in the class_init of the class:
 * |[
 *   static void
 *   my_element_class_init (GstMyElementClass *klass)
 *   {
 *     GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
 *
 *     gst_element_class_add_pad_template (gstelement_class,
 *         gst_static_pad_template_get (&amp;my_template));
 *   }
 * ]|
 */

#include "gst_private.h"

#include "gstpad.h"
#include "gstpadtemplate.h"
#include "gstenumtypes.h"
#include "gstutils.h"
#include "gstinfo.h"
#include "gsterror.h"
#include "gstvalue.h"

#define GST_CAT_DEFAULT GST_CAT_PADS

enum
{
  PROP_NAME_TEMPLATE = 1,
  PROP_DIRECTION,
  PROP_PRESENCE,
  PROP_CAPS
};

enum
{
  TEMPL_PAD_CREATED,
  /* FILL ME */
  LAST_SIGNAL
};

static guint gst_pad_template_signals[LAST_SIGNAL] = { 0 };

static void gst_pad_template_dispose (GObject * object);
static void gst_pad_template_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_pad_template_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_pad_template_parent_class parent_class
G_DEFINE_TYPE (GstPadTemplate, gst_pad_template, GST_TYPE_OBJECT);

static void
gst_pad_template_class_init (GstPadTemplateClass * klass)
{
  GObjectClass *gobject_class;
  GstObjectClass *gstobject_class;

  gobject_class = (GObjectClass *) klass;
  gstobject_class = (GstObjectClass *) klass;

  /**
   * GstPadTemplate::pad-created:
   * @pad_template: the object which received the signal.
   * @pad: the pad that was created.
   *
   * This signal is fired when an element creates a pad from this template.
   */
  gst_pad_template_signals[TEMPL_PAD_CREATED] =
      g_signal_new ("pad-created", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPadTemplateClass, pad_created),
      NULL, NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_PAD);

  gobject_class->dispose = gst_pad_template_dispose;

  gobject_class->get_property = gst_pad_template_get_property;
  gobject_class->set_property = gst_pad_template_set_property;

  /**
   * GstPadTemplate:name-template:
   *
   * The name template of the pad template.
   */
  g_object_class_install_property (gobject_class, PROP_NAME_TEMPLATE,
      g_param_spec_string ("name-template", "Name template",
          "The name template of the pad template", NULL,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS));

  /**
   * GstPadTemplate:direction:
   *
   * The direction of the pad described by the pad template.
   */
  g_object_class_install_property (gobject_class, PROP_DIRECTION,
      g_param_spec_enum ("direction", "Direction",
          "The direction of the pad described by the pad template",
          GST_TYPE_PAD_DIRECTION, GST_PAD_UNKNOWN,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS));

  /**
   * GstPadTemplate:presence:
   *
   * When the pad described by the pad template will become available.
   */
  g_object_class_install_property (gobject_class, PROP_PRESENCE,
      g_param_spec_enum ("presence", "Presence",
          "When the pad described by the pad template will become available",
          GST_TYPE_PAD_PRESENCE, GST_PAD_ALWAYS,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS));

  /**
   * GstPadTemplate:caps:
   *
   * The capabilities of the pad described by the pad template.
   */
  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("caps", "Caps",
          "The capabilities of the pad described by the pad template",
          GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS));

  gstobject_class->path_string_separator = "*";
}

static void
gst_pad_template_init (GstPadTemplate * templ)
{
}

static void
gst_pad_template_dispose (GObject * object)
{
  GstPadTemplate *templ = GST_PAD_TEMPLATE (object);

  g_free (GST_PAD_TEMPLATE_NAME_TEMPLATE (templ));
  if (GST_PAD_TEMPLATE_CAPS (templ)) {
    gst_caps_unref (GST_PAD_TEMPLATE_CAPS (templ));
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

/* ALWAYS padtemplates cannot have conversion specifications (like src_%d),
 * since it doesn't make sense.
 * SOMETIMES padtemplates can do whatever they want, they are provided by the
 * element.
 * REQUEST padtemplates can be reverse-parsed (the user asks for 'sink1', the
 * 'sink%d' template is automatically selected), so we need to restrict their
 * naming.
 */
static gboolean
name_is_valid (const gchar * name, GstPadPresence presence)
{
  const gchar *str;

  if (presence == GST_PAD_ALWAYS) {
    if (strchr (name, '%')) {
      g_warning ("invalid name template %s: conversion specifications are not"
          " allowed for GST_PAD_ALWAYS padtemplates", name);
      return FALSE;
    }
  } else if (presence == GST_PAD_REQUEST) {
    if ((str = strchr (name, '%')) && strchr (str + 1, '%')) {
      g_warning ("invalid name template %s: only one conversion specification"
          " allowed in GST_PAD_REQUEST padtemplate", name);
      return FALSE;
    }
    if (str && (*(str + 1) != 's' && *(str + 1) != 'd' && *(str + 1) != 'u')) {
      g_warning ("invalid name template %s: conversion specification must be of"
          " type '%%d', '%%u' or '%%s' for GST_PAD_REQUEST padtemplate", name);
      return FALSE;
    }
    if (str && (*(str + 2) != '\0')) {
      g_warning ("invalid name template %s: conversion specification must"
          " appear at the end of the GST_PAD_REQUEST padtemplate name", name);
      return FALSE;
    }
  }

  return TRUE;
}

G_DEFINE_POINTER_TYPE (GstStaticPadTemplate, gst_static_pad_template);

/**
 * gst_static_pad_template_get:
 * @pad_template: the static pad template
 *
 * Converts a #GstStaticPadTemplate into a #GstPadTemplate.
 *
 * Returns: (transfer full): a new #GstPadTemplate.
 */
/* FIXME0.11: rename to gst_pad_template_new_from_static_pad_template() */
GstPadTemplate *
gst_static_pad_template_get (GstStaticPadTemplate * pad_template)
{
  GstPadTemplate *new;
  GstCaps *caps;

  if (!name_is_valid (pad_template->name_template, pad_template->presence))
    return NULL;

  caps = gst_static_caps_get (&pad_template->static_caps);

  new = g_object_new (gst_pad_template_get_type (),
      "name", pad_template->name_template,
      "name-template", pad_template->name_template,
      "direction", pad_template->direction,
      "presence", pad_template->presence, "caps", caps, NULL);

  gst_caps_unref (caps);

  return new;
}

/**
 * gst_pad_template_new:
 * @name_template: the name template.
 * @direction: the #GstPadDirection of the template.
 * @presence: the #GstPadPresence of the pad.
 * @caps: (transfer none): a #GstCaps set for the template.
 *
 * Creates a new pad template with a name according to the given template
 * and with the given arguments.
 *
 * Returns: (transfer floating): a new #GstPadTemplate.
 */
GstPadTemplate *
gst_pad_template_new (const gchar * name_template,
    GstPadDirection direction, GstPadPresence presence, GstCaps * caps)
{
  GstPadTemplate *new;

  g_return_val_if_fail (name_template != NULL, NULL);
  g_return_val_if_fail (caps != NULL, NULL);
  g_return_val_if_fail (direction == GST_PAD_SRC
      || direction == GST_PAD_SINK, NULL);
  g_return_val_if_fail (presence == GST_PAD_ALWAYS
      || presence == GST_PAD_SOMETIMES || presence == GST_PAD_REQUEST, NULL);

  if (!name_is_valid (name_template, presence)) {
    return NULL;
  }

  new = g_object_new (gst_pad_template_get_type (),
      "name", name_template, "name-template", name_template,
      "direction", direction, "presence", presence, "caps", caps, NULL);

  return new;
}

/**
 * gst_static_pad_template_get_caps:
 * @templ: a #GstStaticPadTemplate to get capabilities of.
 *
 * Gets the capabilities of the static pad template.
 *
 * Returns: (transfer full): the #GstCaps of the static pad template.
 * Unref after usage. Since the core holds an additional
 * ref to the returned caps, use gst_caps_make_writable()
 * on the returned caps to modify it.
 */
GstCaps *
gst_static_pad_template_get_caps (GstStaticPadTemplate * templ)
{
  g_return_val_if_fail (templ, NULL);

  return gst_static_caps_get (&templ->static_caps);
}

/**
 * gst_pad_template_get_caps:
 * @templ: a #GstPadTemplate to get capabilities of.
 *
 * Gets the capabilities of the pad template.
 *
 * Returns: (transfer full): the #GstCaps of the pad template.
 * Unref after usage.
 */
GstCaps *
gst_pad_template_get_caps (GstPadTemplate * templ)
{
  GstCaps *caps;
  g_return_val_if_fail (GST_IS_PAD_TEMPLATE (templ), NULL);

  caps = GST_PAD_TEMPLATE_CAPS (templ);

  return (caps ? gst_caps_ref (caps) : NULL);
}

/**
 * gst_pad_template_pad_created:
 * @templ: a #GstPadTemplate that has been created
 * @pad:   the #GstPad that created it
 *
 * Emit the pad-created signal for this template when created by this pad.
 */
void
gst_pad_template_pad_created (GstPadTemplate * templ, GstPad * pad)
{
  g_signal_emit (templ, gst_pad_template_signals[TEMPL_PAD_CREATED], 0, pad);
}

static void
gst_pad_template_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  /* these properties are all construct-only */
  switch (prop_id) {
    case PROP_NAME_TEMPLATE:
      GST_PAD_TEMPLATE_NAME_TEMPLATE (object) = g_value_dup_string (value);
      break;
    case PROP_DIRECTION:
      GST_PAD_TEMPLATE_DIRECTION (object) =
          (GstPadDirection) g_value_get_enum (value);
      break;
    case PROP_PRESENCE:
      GST_PAD_TEMPLATE_PRESENCE (object) =
          (GstPadPresence) g_value_get_enum (value);
      break;
    case PROP_CAPS:
      GST_PAD_TEMPLATE_CAPS (object) = g_value_dup_boxed (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_pad_template_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  /* these properties are all construct-only */
  switch (prop_id) {
    case PROP_NAME_TEMPLATE:
      g_value_set_string (value, GST_PAD_TEMPLATE_NAME_TEMPLATE (object));
      break;
    case PROP_DIRECTION:
      g_value_set_enum (value, GST_PAD_TEMPLATE_DIRECTION (object));
      break;
    case PROP_PRESENCE:
      g_value_set_enum (value, GST_PAD_TEMPLATE_PRESENCE (object));
      break;
    case PROP_CAPS:
      g_value_set_boxed (value, GST_PAD_TEMPLATE_CAPS (object));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}
