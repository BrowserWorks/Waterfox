/* GStreamer base utils library missing plugins support
 * Copyright (C) 2006 Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gstpbutilsmissingplugins
 * @short_description: Create, recognise and parse missing-plugins messages
 *
 * <refsect2>
 * <para>
 * Functions to create, recognise and parse missing-plugins messages for
 * applications and elements.
 * </para>
 * <para>
 * Missing-plugin messages are posted on the bus by elements like decodebin
 * or playbin if they can't find an appropriate source element or decoder
 * element. The application can use these messages for two things:
 * <itemizedlist>
 *   <listitem><para>
 *     concise error/problem reporting to the user mentioning what exactly
 *     is missing, see gst_missing_plugin_message_get_description()
 *   </para></listitem>
 *   <listitem><para>
 *     initiate installation of missing plugins, see
 *     gst_missing_plugin_message_get_installer_detail() and
 *     gst_install_plugins_async()
 *   </para></listitem>
 * </itemizedlist>
 * </para>
 * <para>
 * Applications may also create missing-plugin messages themselves to install
 * required elements that are missing, using the install mechanism mentioned
 * above.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#ifdef HAVE_SYS_TYPES_H
# include <sys/types.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>            /* getpid on UNIX */
#endif
#ifdef HAVE_PROCESS_H
# include <process.h>           /* getpid on win32 */
#endif

#include "gst/gst-i18n-plugin.h"

#include "pbutils.h"
#include "pbutils-private.h"

#include <string.h>

#define GST_DETAIL_STRING_MARKER "gstreamer"

typedef enum
{
  GST_MISSING_TYPE_UNKNOWN = 0,
  GST_MISSING_TYPE_URISOURCE,
  GST_MISSING_TYPE_URISINK,
  GST_MISSING_TYPE_ELEMENT,
  GST_MISSING_TYPE_DECODER,
  GST_MISSING_TYPE_ENCODER
} GstMissingType;

static const struct
{
  GstMissingType type;
  const gchar type_string[12];
} missing_type_mapping[] = {
  {
  GST_MISSING_TYPE_URISOURCE, "urisource"}, {
  GST_MISSING_TYPE_URISINK, "urisink"}, {
  GST_MISSING_TYPE_ELEMENT, "element"}, {
  GST_MISSING_TYPE_DECODER, "decoder"}, {
  GST_MISSING_TYPE_ENCODER, "encoder"}
};

static GstMissingType
missing_structure_get_type (const GstStructure * s)
{
  const gchar *type;
  guint i;

  type = gst_structure_get_string (s, "type");
  g_return_val_if_fail (type != NULL, GST_MISSING_TYPE_UNKNOWN);

  for (i = 0; i < G_N_ELEMENTS (missing_type_mapping); ++i) {
    if (strcmp (missing_type_mapping[i].type_string, type) == 0)
      return missing_type_mapping[i].type;
  }

  return GST_MISSING_TYPE_UNKNOWN;
}

GstCaps *
copy_and_clean_caps (const GstCaps * caps)
{
  GstStructure *s;
  GstCaps *ret;

  ret = gst_caps_copy (caps);

  /* make caps easier to interpret, remove common fields that are likely
   * to be irrelevant for determining the right plugin (ie. mostly fields
   * where template caps usually have the standard MIN - MAX range as value) */
  s = gst_caps_get_structure (ret, 0);
  gst_structure_remove_field (s, "codec_data");
  gst_structure_remove_field (s, "palette_data");
  gst_structure_remove_field (s, "pixel-aspect-ratio");
  gst_structure_remove_field (s, "framerate");
  gst_structure_remove_field (s, "leaf_size");
  gst_structure_remove_field (s, "packet_size");
  gst_structure_remove_field (s, "block_align");
  gst_structure_remove_field (s, "metadata-interval");  /* icy caps */
  /* decoders/encoders almost always handle the usual width/height/channel/rate
   * range (and if we don't remove this then the app will have a much harder
   * time blacklisting formats it has unsuccessfully tried to install before) */
  gst_structure_remove_field (s, "width");
  gst_structure_remove_field (s, "depth");
  gst_structure_remove_field (s, "height");
  gst_structure_remove_field (s, "channels");
  gst_structure_remove_field (s, "rate");
  /* rtp fields */
  gst_structure_remove_field (s, "config");
  gst_structure_remove_field (s, "clock-rate");
  gst_structure_remove_field (s, "clock-base");
  gst_structure_remove_field (s, "maxps");
  gst_structure_remove_field (s, "seqnum-base");
  gst_structure_remove_field (s, "npt-start");
  gst_structure_remove_field (s, "npt-stop");
  gst_structure_remove_field (s, "play-speed");
  gst_structure_remove_field (s, "play-scale");
  gst_structure_remove_field (s, "dynamic_range");

  return ret;
}

/**
 * gst_missing_uri_source_message_new:
 * @element: the #GstElement posting the message
 * @protocol: the URI protocol the missing source needs to implement,
 *            e.g. "http" or "mms"
 *
 * Creates a missing-plugin message for @element to notify the application
 * that a source element for a particular URI protocol is missing. This
 * function is mainly for use in plugins.
 *
 * Returns: (transfer full): a new #GstMessage, or NULL on error
 */
GstMessage *
gst_missing_uri_source_message_new (GstElement * element,
    const gchar * protocol)
{
  GstStructure *s;
  gchar *description;

  g_return_val_if_fail (element != NULL, NULL);
  g_return_val_if_fail (GST_IS_ELEMENT (element), NULL);
  g_return_val_if_fail (protocol != NULL, NULL);

  description = gst_pb_utils_get_source_description (protocol);

  s = gst_structure_new ("missing-plugin", "type", G_TYPE_STRING,
      "urisource", "detail", G_TYPE_STRING, protocol, "name", G_TYPE_STRING,
      description, NULL);

  g_free (description);
  return gst_message_new_element (GST_OBJECT_CAST (element), s);
}

/**
 * gst_missing_uri_sink_message_new:
 * @element: the #GstElement posting the message
 * @protocol: the URI protocol the missing sink needs to implement,
 *            e.g. "http" or "smb"
 *
 * Creates a missing-plugin message for @element to notify the application
 * that a sink element for a particular URI protocol is missing. This
 * function is mainly for use in plugins.
 *
 * Returns: (transfer full): a new #GstMessage, or NULL on error
 */
GstMessage *
gst_missing_uri_sink_message_new (GstElement * element, const gchar * protocol)
{
  GstStructure *s;
  gchar *description;

  g_return_val_if_fail (element != NULL, NULL);
  g_return_val_if_fail (GST_IS_ELEMENT (element), NULL);
  g_return_val_if_fail (protocol != NULL, NULL);

  description = gst_pb_utils_get_sink_description (protocol);

  s = gst_structure_new ("missing-plugin", "type", G_TYPE_STRING,
      "urisink", "detail", G_TYPE_STRING, protocol, "name", G_TYPE_STRING,
      description, NULL);

  g_free (description);
  return gst_message_new_element (GST_OBJECT_CAST (element), s);
}

/**
 * gst_missing_element_message_new:
 * @element: the #GstElement posting the message
 * @factory_name: the name of the missing element (element factory),
 *            e.g. "videoscale" or "cdparanoiasrc"
 *
 * Creates a missing-plugin message for @element to notify the application
 * that a certain required element is missing. This function is mainly for
 * use in plugins.
 *
 * Returns: (transfer full): a new #GstMessage, or NULL on error
 */
GstMessage *
gst_missing_element_message_new (GstElement * element,
    const gchar * factory_name)
{
  GstStructure *s;
  gchar *description;

  g_return_val_if_fail (element != NULL, NULL);
  g_return_val_if_fail (GST_IS_ELEMENT (element), NULL);
  g_return_val_if_fail (factory_name != NULL, NULL);

  description = gst_pb_utils_get_element_description (factory_name);

  s = gst_structure_new ("missing-plugin", "type", G_TYPE_STRING,
      "element", "detail", G_TYPE_STRING, factory_name, "name", G_TYPE_STRING,
      description, NULL);

  g_free (description);
  return gst_message_new_element (GST_OBJECT_CAST (element), s);
}

/**
 * gst_missing_decoder_message_new:
 * @element: the #GstElement posting the message
 * @decode_caps: the (fixed) caps for which a decoder element is needed
 *
 * Creates a missing-plugin message for @element to notify the application
 * that a decoder element for a particular set of (fixed) caps is missing.
 * This function is mainly for use in plugins.
 *
 * Returns: (transfer full): a new #GstMessage, or NULL on error
 */
GstMessage *
gst_missing_decoder_message_new (GstElement * element,
    const GstCaps * decode_caps)
{
  GstStructure *s;
  GstCaps *caps;
  gchar *description;

  g_return_val_if_fail (element != NULL, NULL);
  g_return_val_if_fail (GST_IS_ELEMENT (element), NULL);
  g_return_val_if_fail (decode_caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (decode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_any (decode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_empty (decode_caps), NULL);
  g_return_val_if_fail (gst_caps_is_fixed (decode_caps), NULL);

  description = gst_pb_utils_get_decoder_description (decode_caps);
  caps = copy_and_clean_caps (decode_caps);

  s = gst_structure_new ("missing-plugin", "type", G_TYPE_STRING,
      "decoder", "detail", GST_TYPE_CAPS, caps, "name", G_TYPE_STRING,
      description, NULL);

  gst_caps_unref (caps);
  g_free (description);

  return gst_message_new_element (GST_OBJECT_CAST (element), s);
}

/**
 * gst_missing_encoder_message_new:
 * @element: the #GstElement posting the message
 * @encode_caps: the (fixed) caps for which an encoder element is needed
 *
 * Creates a missing-plugin message for @element to notify the application
 * that an encoder element for a particular set of (fixed) caps is missing.
 * This function is mainly for use in plugins.
 *
 * Returns: (transfer full): a new #GstMessage, or NULL on error
 */
GstMessage *
gst_missing_encoder_message_new (GstElement * element,
    const GstCaps * encode_caps)
{
  GstStructure *s;
  GstCaps *caps;
  gchar *description;

  g_return_val_if_fail (element != NULL, NULL);
  g_return_val_if_fail (GST_IS_ELEMENT (element), NULL);
  g_return_val_if_fail (encode_caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (encode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_any (encode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_empty (encode_caps), NULL);
  g_return_val_if_fail (gst_caps_is_fixed (encode_caps), NULL);

  description = gst_pb_utils_get_encoder_description (encode_caps);
  caps = copy_and_clean_caps (encode_caps);

  s = gst_structure_new ("missing-plugin", "type", G_TYPE_STRING,
      "encoder", "detail", GST_TYPE_CAPS, caps, "name", G_TYPE_STRING,
      description, NULL);

  gst_caps_unref (caps);
  g_free (description);

  return gst_message_new_element (GST_OBJECT_CAST (element), s);
}

static gboolean
missing_structure_get_string_detail (const GstStructure * s, gchar ** p_detail)
{
  const gchar *detail;
  GType detail_type;

  *p_detail = NULL;

  detail_type = gst_structure_get_field_type (s, "detail");
  if (!g_type_is_a (detail_type, G_TYPE_STRING)) {
    GST_WARNING ("expected 'detail' field to be of G_TYPE_STRING");
    return FALSE;
  }

  detail = gst_structure_get_string (s, "detail");
  if (detail == NULL || *detail == '\0') {
    GST_WARNING ("empty 'detail' field");
    return FALSE;
  }
  *p_detail = g_strdup (detail);
  return TRUE;
}

static gboolean
missing_structure_get_caps_detail (const GstStructure * s, GstCaps ** p_caps)
{
  const GstCaps *caps;
  const GValue *val;
  GType detail_type;

  *p_caps = NULL;

  detail_type = gst_structure_get_field_type (s, "detail");
  if (!g_type_is_a (detail_type, GST_TYPE_CAPS)) {
    GST_WARNING ("expected 'detail' field to be of GST_TYPE_CAPS");
    return FALSE;
  }

  val = gst_structure_get_value (s, "detail");
  caps = gst_value_get_caps (val);
  if (gst_caps_is_empty (caps) || gst_caps_is_any (caps)) {
    GST_WARNING ("EMPTY or ANY caps not allowed");
    return FALSE;
  }

  *p_caps = gst_caps_copy (caps);
  return TRUE;
}

/**
 * gst_missing_plugin_message_get_installer_detail:
 * @msg: a missing-plugin #GstMessage of type #GST_MESSAGE_ELEMENT
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_plugin_message_get_installer_detail (GstMessage * msg)
{
  GstMissingType missing_type;
  const gchar *progname;
  const gchar *type;
  GString *str = NULL;
  gchar *detail = NULL;
  gchar *desc;
  const GstStructure *structure;

  g_return_val_if_fail (gst_is_missing_plugin_message (msg), NULL);

  structure = gst_message_get_structure (msg);
  GST_LOG ("Parsing missing-plugin message: %" GST_PTR_FORMAT, structure);

  missing_type = missing_structure_get_type (structure);
  if (missing_type == GST_MISSING_TYPE_UNKNOWN) {
    GST_WARNING ("couldn't parse 'type' field");
    goto error;
  }

  type = gst_structure_get_string (structure, "type");
  g_assert (type != NULL);      /* validity already checked above */

  /* FIXME: use gst_installer_detail_new() here too */
  str = g_string_new (GST_DETAIL_STRING_MARKER "|");
  g_string_append_printf (str, "%s|", GST_API_VERSION);

  progname = (const gchar *) g_get_prgname ();
  if (progname) {
    g_string_append_printf (str, "%s|", progname);
  } else {
    g_string_append_printf (str, "pid/%lu|", (gulong) getpid ());
  }

  desc = gst_missing_plugin_message_get_description (msg);
  if (desc) {
    g_strdelimit (desc, "|", '#');
    g_string_append_printf (str, "%s|", desc);
    g_free (desc);
  } else {
    g_string_append (str, "|");
  }

  switch (missing_type) {
    case GST_MISSING_TYPE_URISOURCE:
    case GST_MISSING_TYPE_URISINK:
    case GST_MISSING_TYPE_ELEMENT:
      if (!missing_structure_get_string_detail (structure, &detail))
        goto error;
      break;
    case GST_MISSING_TYPE_DECODER:
    case GST_MISSING_TYPE_ENCODER:{
      GstCaps *caps = NULL;

      if (!missing_structure_get_caps_detail (structure, &caps))
        goto error;

      detail = gst_caps_to_string (caps);
      gst_caps_unref (caps);
      break;
    }
    default:
      g_return_val_if_reached (NULL);
  }

  g_string_append_printf (str, "%s-%s", type, detail);
  g_free (detail);

  return g_string_free (str, FALSE);

/* ERRORS */
error:
  {
    GST_WARNING ("Failed to parse missing-plugin msg: %" GST_PTR_FORMAT, msg);
    if (str)
      g_string_free (str, TRUE);
    return NULL;
  }
}

/**
 * gst_missing_plugin_message_get_description:
 * @msg: a missing-plugin #GstMessage of type #GST_MESSAGE_ELEMENT
 *
 * Returns a localised string describing the missing feature, for use in
 * error dialogs and the like. Should never return NULL unless @msg is not
 * a valid missing-plugin message.
 *
 * This function is mainly for applications that need a human-readable string
 * describing a missing plugin, given a previously collected missing-plugin
 * message
 *
 * Returns: a newly-allocated description string, or NULL on error. Free
 *          string with g_free() when not needed any longer.
 */
gchar *
gst_missing_plugin_message_get_description (GstMessage * msg)
{
  GstMissingType missing_type;
  const gchar *desc;
  gchar *ret = NULL;
  const GstStructure *structure;

  g_return_val_if_fail (gst_is_missing_plugin_message (msg), NULL);

  structure = gst_message_get_structure (msg);
  GST_LOG ("Parsing missing-plugin message: %" GST_PTR_FORMAT, structure);

  desc = gst_structure_get_string (structure, "name");
  if (desc != NULL && *desc != '\0') {
    ret = g_strdup (desc);
    goto done;
  }

  /* fallback #1 */
  missing_type = missing_structure_get_type (structure);

  switch (missing_type) {
    case GST_MISSING_TYPE_URISOURCE:
    case GST_MISSING_TYPE_URISINK:
    case GST_MISSING_TYPE_ELEMENT:{
      gchar *detail = NULL;

      if (missing_structure_get_string_detail (structure, &detail)) {
        if (missing_type == GST_MISSING_TYPE_URISOURCE)
          ret = gst_pb_utils_get_source_description (detail);
        else if (missing_type == GST_MISSING_TYPE_URISINK)
          ret = gst_pb_utils_get_sink_description (detail);
        else
          ret = gst_pb_utils_get_sink_description (detail);
        g_free (detail);
      }
      break;
    }
    case GST_MISSING_TYPE_DECODER:
    case GST_MISSING_TYPE_ENCODER:{
      GstCaps *caps = NULL;

      if (missing_structure_get_caps_detail (structure, &caps)) {
        if (missing_type == GST_MISSING_TYPE_DECODER)
          ret = gst_pb_utils_get_decoder_description (caps);
        else
          ret = gst_pb_utils_get_encoder_description (caps);
        gst_caps_unref (caps);
      }
      break;
    }
    default:
      break;
  }

  if (ret)
    goto done;

  /* fallback #2 */
  switch (missing_type) {
    case GST_MISSING_TYPE_URISOURCE:
      desc = _("Unknown source element");
      break;
    case GST_MISSING_TYPE_URISINK:
      desc = _("Unknown sink element");
      break;
    case GST_MISSING_TYPE_ELEMENT:
      desc = _("Unknown element");
      break;
    case GST_MISSING_TYPE_DECODER:
      desc = _("Unknown decoder element");
      break;
    case GST_MISSING_TYPE_ENCODER:
      desc = _("Unknown encoder element");
      break;
    default:
      /* we should really never get here, but we better still return
       * something if we do */
      desc = _("Plugin or element of unknown type");
      break;
  }
  ret = g_strdup (desc);

done:

  GST_LOG ("returning '%s'", ret);
  return ret;
}

/**
 * gst_is_missing_plugin_message:
 * @msg: a #GstMessage
 *
 * Checks whether @msg is a missing plugins message.
 *
 * Returns: %TRUE if @msg is a missing-plugins message, otherwise %FALSE.
 */
gboolean
gst_is_missing_plugin_message (GstMessage * msg)
{
  const GstStructure *structure;

  g_return_val_if_fail (msg != NULL, FALSE);
  g_return_val_if_fail (GST_IS_MESSAGE (msg), FALSE);

  structure = gst_message_get_structure (msg);
  if (GST_MESSAGE_TYPE (msg) != GST_MESSAGE_ELEMENT || structure == NULL)
    return FALSE;

  return gst_structure_has_name (structure, "missing-plugin");
}

/* takes ownership of the description */
static gchar *
gst_installer_detail_new (gchar * description, const gchar * type,
    const gchar * detail)
{
  const gchar *progname;
  GString *s;

  s = g_string_new (GST_DETAIL_STRING_MARKER "|");
  g_string_append_printf (s, "%s|", GST_API_VERSION);

  progname = (const gchar *) g_get_prgname ();
  if (progname) {
    g_string_append_printf (s, "%s|", progname);
  } else {
    g_string_append_printf (s, "pid/%lu|", (gulong) getpid ());
  }

  if (description) {
    g_strdelimit (description, "|", '#');
    g_string_append_printf (s, "%s|", description);
    g_free (description);
  } else {
    g_string_append (s, "|");
  }

  g_string_append_printf (s, "%s-%s", type, detail);

  return g_string_free (s, FALSE);
}

/**
 * gst_missing_uri_source_installer_detail_new:
 * @protocol: the URI protocol the missing source needs to implement,
 *            e.g. "http" or "mms"
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions in
 * the case where the application knows exactly what kind of plugin it is
 * missing.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_uri_source_installer_detail_new (const gchar * protocol)
{
  gchar *desc;

  g_return_val_if_fail (protocol != NULL, NULL);

  desc = gst_pb_utils_get_source_description (protocol);
  return gst_installer_detail_new (desc, "urisource", protocol);
}

/**
 * gst_missing_uri_sink_installer_detail_new:
 * @protocol: the URI protocol the missing source needs to implement,
 *            e.g. "http" or "mms"
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions in
 * the case where the application knows exactly what kind of plugin it is
 * missing.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_uri_sink_installer_detail_new (const gchar * protocol)
{
  gchar *desc;

  g_return_val_if_fail (protocol != NULL, NULL);

  desc = gst_pb_utils_get_sink_description (protocol);
  return gst_installer_detail_new (desc, "urisink", protocol);
}

/**
 * gst_missing_element_installer_detail_new:
 * @factory_name: the name of the missing element (element factory),
 *            e.g. "videoscale" or "cdparanoiasrc"
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions in
 * the case where the application knows exactly what kind of plugin it is
 * missing.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_element_installer_detail_new (const gchar * factory_name)
{
  gchar *desc;

  g_return_val_if_fail (factory_name != NULL, NULL);

  desc = gst_pb_utils_get_element_description (factory_name);
  return gst_installer_detail_new (desc, "element", factory_name);
}

/**
 * gst_missing_decoder_installer_detail_new:
 * @decode_caps: the (fixed) caps for which a decoder element is needed
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions in
 * the case where the application knows exactly what kind of plugin it is
 * missing.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_decoder_installer_detail_new (const GstCaps * decode_caps)
{
  GstCaps *caps;
  gchar *detail_str, *caps_str, *desc;

  g_return_val_if_fail (decode_caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (decode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_any (decode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_empty (decode_caps), NULL);
  g_return_val_if_fail (gst_caps_is_fixed (decode_caps), NULL);

  desc = gst_pb_utils_get_decoder_description (decode_caps);
  caps = copy_and_clean_caps (decode_caps);
  caps_str = gst_caps_to_string (caps);
  detail_str = gst_installer_detail_new (desc, "decoder", caps_str);
  g_free (caps_str);
  gst_caps_unref (caps);

  return detail_str;
}

/**
 * gst_missing_encoder_installer_detail_new:
 * @encode_caps: the (fixed) caps for which an encoder element is needed
 *
 * Returns an opaque string containing all the details about the missing
 * element to be passed to an external installer called via
 * gst_install_plugins_async() or gst_install_plugins_sync().
 * 
 * This function is mainly for applications that call external plugin
 * installation mechanisms using one of the two above-mentioned functions in
 * the case where the application knows exactly what kind of plugin it is
 * missing.
 *
 * Returns: a newly-allocated detail string, or NULL on error. Free string
 *          with g_free() when not needed any longer.
 */
gchar *
gst_missing_encoder_installer_detail_new (const GstCaps * encode_caps)
{
  GstCaps *caps;
  gchar *detail_str, *caps_str, *desc;

  g_return_val_if_fail (encode_caps != NULL, NULL);
  g_return_val_if_fail (GST_IS_CAPS (encode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_any (encode_caps), NULL);
  g_return_val_if_fail (!gst_caps_is_empty (encode_caps), NULL);
  g_return_val_if_fail (gst_caps_is_fixed (encode_caps), NULL);

  desc = gst_pb_utils_get_encoder_description (encode_caps);
  caps = copy_and_clean_caps (encode_caps);
  caps_str = gst_caps_to_string (caps);
  detail_str = gst_installer_detail_new (desc, "encoder", caps_str);
  g_free (caps_str);
  gst_caps_unref (caps);

  return detail_str;
}
