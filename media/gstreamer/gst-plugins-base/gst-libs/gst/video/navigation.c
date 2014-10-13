/* GStreamer Navigation
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2007-2009 Jan Schmidt <thaytan@noraisin.net>
 *
 * navigation.c: navigation event virtual class function wrappers
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
 * SECTION:gstnavigation
 * @short_description: Interface for creating, sending and parsing navigation
 * events.
 *
 * The Navigation interface is used for creating and injecting navigation related
 * events such as mouse button presses, cursor motion and key presses. The associated
 * library also provides methods for parsing received events, and for sending and
 * receiving navigation related bus events. One main usecase is DVD menu navigation.
 *
 * The main parts of the API are:
 * <itemizedlist>
 * <listitem>
 * <para>
 * The GstNavigation interface, implemented by elements which provide an application
 * with the ability to create and inject navigation events into the pipeline.
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * GstNavigation event handling API. GstNavigation events are created in response to
 * calls on a GstNavigation interface implementation, and sent in the pipeline. Upstream
 * elements can use the navigation event API functions to parse the contents of received
 * messages.
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * GstNavigation message handling API. GstNavigation messages may be sent on the message
 * bus to inform applications of navigation related changes in the pipeline, such as the
 * mouse moving over a clickable region, or the set of available angles changing.
 * </para><para>
 * The GstNavigation message functions provide functions for creating and parsing
 * custom bus messages for signaling GstNavigation changes.
 * </para>
 * </listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/video/navigation.h>
#include <gst/video/video-enumtypes.h>

static void gst_navigation_class_init (GstNavigationInterface * iface);

#define GST_NAVIGATION_MESSAGE_NAME "GstNavigationMessage"
#define GST_NAVIGATION_QUERY_NAME "GstNavigationQuery"
#define GST_NAVIGATION_EVENT_NAME "application/x-gst-navigation"

#define WARN_IF_FAIL(exp,msg) if(G_UNLIKELY(!(exp))){g_warning("%s",(msg));}

GType
gst_navigation_get_type (void)
{
  static GType gst_navigation_type = 0;

  if (!gst_navigation_type) {
    static const GTypeInfo gst_navigation_info = {
      sizeof (GstNavigationInterface),
      (GBaseInitFunc) gst_navigation_class_init,
      NULL,
      NULL,
      NULL,
      NULL,
      0,
      0,
      NULL,
    };

    gst_navigation_type = g_type_register_static (G_TYPE_INTERFACE,
        "GstNavigation", &gst_navigation_info, 0);
  }

  return gst_navigation_type;
}

static void
gst_navigation_class_init (GstNavigationInterface * iface)
{
  /* default virtual functions */
  iface->send_event = NULL;
}

/* The interface implementer should make sure that the object can handle
 * the event. */
void
gst_navigation_send_event (GstNavigation * navigation, GstStructure * structure)
{
  GstNavigationInterface *iface = GST_NAVIGATION_GET_INTERFACE (navigation);

  if (iface->send_event) {
    iface->send_event (navigation, structure);
  }
}

/**
 * gst_navigation_send_key_event:
 * @navigation: The navigation interface instance
 * @event: The type of the key event. Recognised values are "key-press" and
 * "key-release"
 * @key: Character representation of the key. This is typically as produced
 * by XKeysymToString.
 */
void
gst_navigation_send_key_event (GstNavigation * navigation, const char *event,
    const char *key)
{
  gst_navigation_send_event (navigation,
      gst_structure_new (GST_NAVIGATION_EVENT_NAME, "event", G_TYPE_STRING,
          event, "key", G_TYPE_STRING, key, NULL));
}

/**
 * gst_navigation_send_mouse_event:
 * @navigation: The navigation interface instance
 * @event: The type of mouse event, as a text string. Recognised values are
 * "mouse-button-press", "mouse-button-release" and "mouse-move".
 * @button: The button number of the button being pressed or released. Pass 0
 * for mouse-move events.
 * @x: The x coordinate of the mouse event.
 * @y: The y coordinate of the mouse event.
 *
 * Sends a mouse event to the navigation interface. Mouse event coordinates
 * are sent relative to the display space of the related output area. This is
 * usually the size in pixels of the window associated with the element
 * implementing the #GstNavigation interface.
 *
 */
void
gst_navigation_send_mouse_event (GstNavigation * navigation, const char *event,
    int button, double x, double y)
{
  gst_navigation_send_event (navigation,
      gst_structure_new (GST_NAVIGATION_EVENT_NAME, "event", G_TYPE_STRING,
          event, "button", G_TYPE_INT, button, "pointer_x", G_TYPE_DOUBLE, x,
          "pointer_y", G_TYPE_DOUBLE, y, NULL));
}

/**
 * gst_navigation_send_command:
 * @navigation: The navigation interface instance
 * @command: The command to issue
 *
 * Sends the indicated command to the navigation interface.
 */
void
gst_navigation_send_command (GstNavigation * navigation,
    GstNavigationCommand command)
{
  gst_navigation_send_event (navigation,
      gst_structure_new (GST_NAVIGATION_EVENT_NAME, "event", G_TYPE_STRING,
          "command", "command-code", G_TYPE_UINT, (guint) command, NULL));
}

/* Navigation Queries */

#define GST_NAVIGATION_QUERY_HAS_TYPE(query,query_type) \
(gst_navigation_query_get_type (query) == GST_NAVIGATION_QUERY_ ## query_type)

/**
 * gst_navigation_query_get_type:
 * @query: The query to inspect
 *
 * Inspect a #GstQuery and return the #GstNavigationQueryType associated with
 * it if it is a #GstNavigation query.
 *
 * Returns: The #GstNavigationQueryType of the query, or
 * #GST_NAVIGATION_QUERY_INVALID
 */
GstNavigationQueryType
gst_navigation_query_get_type (GstQuery * query)
{
  const GstStructure *s;
  const gchar *q_type;

  if (query == NULL || GST_QUERY_TYPE (query) != GST_QUERY_CUSTOM)
    return GST_NAVIGATION_QUERY_INVALID;

  s = gst_query_get_structure (query);
  if (s == NULL || !gst_structure_has_name (s, GST_NAVIGATION_QUERY_NAME))
    return GST_NAVIGATION_QUERY_INVALID;

  q_type = gst_structure_get_string (s, "type");
  if (q_type == NULL)
    return GST_NAVIGATION_QUERY_INVALID;

  if (g_str_equal (q_type, "commands"))
    return GST_NAVIGATION_QUERY_COMMANDS;
  else if (g_str_equal (q_type, "angles"))
    return GST_NAVIGATION_QUERY_ANGLES;

  return GST_NAVIGATION_QUERY_INVALID;
}

/**
 * gst_navigation_query_new_commands:
 *
 * Create a new #GstNavigation commands query. When executed, it will
 * query the pipeline for the set of currently available commands.
 *
 * Returns: The new query.
 */
GstQuery *
gst_navigation_query_new_commands (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new (GST_NAVIGATION_QUERY_NAME,
      "type", G_TYPE_STRING, "commands", NULL);
  query = gst_query_new_custom (GST_QUERY_CUSTOM, structure);

  return query;
}

static void
gst_query_list_add_command (GValue * list, GstNavigationCommand val)
{
  GValue item = { 0, };

  g_value_init (&item, GST_TYPE_NAVIGATION_COMMAND);
  g_value_set_enum (&item, val);
  gst_value_list_append_value (list, &item);
  g_value_unset (&item);
}

/**
 * gst_navigation_query_set_commands:
 * @query: a #GstQuery
 * @n_cmds: the number of commands to set.
 * @...: A list of @GstNavigationCommand values, @n_cmds entries long.
 *
 * Set the #GstNavigation command query result fields in @query. The number
 * of commands passed must be equal to @n_commands.
 */
void
gst_navigation_query_set_commands (GstQuery * query, gint n_cmds, ...)
{
  va_list ap;
  GValue list = { 0, };
  GstStructure *structure;
  gint i;

  g_return_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, COMMANDS));

  g_value_init (&list, GST_TYPE_LIST);

  va_start (ap, n_cmds);
  for (i = 0; i < n_cmds; i++) {
    GstNavigationCommand val = va_arg (ap, GstNavigationCommand);
    gst_query_list_add_command (&list, val);
  }
  va_end (ap);

  structure = gst_query_writable_structure (query);
  gst_structure_take_value (structure, "commands", &list);
}

/**
 * gst_navigation_query_set_commandsv:
 * @query: a #GstQuery
 * @n_cmds: the number of commands to set.
 * @cmds: An array containing @n_cmds @GstNavigationCommand values.
 *
 * Set the #GstNavigation command query result fields in @query. The number
 * of commands passed must be equal to @n_commands.
 */
void
gst_navigation_query_set_commandsv (GstQuery * query, gint n_cmds,
    GstNavigationCommand * cmds)
{
  GValue list = { 0, };
  GstStructure *structure;
  gint i;

  g_return_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, COMMANDS));

  g_value_init (&list, GST_TYPE_LIST);
  for (i = 0; i < n_cmds; i++) {
    gst_query_list_add_command (&list, cmds[i]);
  }
  structure = gst_query_writable_structure (query);
  gst_structure_take_value (structure, "commands", &list);
}

/**
 * gst_navigation_query_parse_commands_length:
 * @query: a #GstQuery
 * @n_cmds: (out): the number of commands in this query.
 *
 * Parse the number of commands in the #GstNavigation commands @query.
 *
 * Returns: %TRUE if the query could be successfully parsed. %FALSE if not.
 */
gboolean
gst_navigation_query_parse_commands_length (GstQuery * query, guint * n_cmds)
{
  const GstStructure *structure;
  const GValue *list;

  g_return_val_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, COMMANDS), FALSE);

  if (n_cmds == NULL)
    return TRUE;

  structure = gst_query_get_structure (query);
  list = gst_structure_get_value (structure, "commands");
  if (list == NULL)
    *n_cmds = 0;
  else
    *n_cmds = gst_value_list_get_size (list);

  return TRUE;
}

/**
 * gst_navigation_query_parse_commands_nth:
 * @query: a #GstQuery
 * @nth: the nth command to retrieve.
 * @cmd: (out): a pointer to store the nth command into.
 *
 * Parse the #GstNavigation command query and retrieve the @nth command from
 * it into @cmd. If the list contains less elements than @nth, @cmd will be
 * set to #GST_NAVIGATION_COMMAND_INVALID.
 *
 * Returns: %TRUE if the query could be successfully parsed. %FALSE if not.
 */
gboolean
gst_navigation_query_parse_commands_nth (GstQuery * query, guint nth,
    GstNavigationCommand * cmd)
{
  const GstStructure *structure;
  const GValue *list;

  g_return_val_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, COMMANDS), FALSE);

  if (cmd == NULL)
    return TRUE;

  structure = gst_query_get_structure (query);
  list = gst_structure_get_value (structure, "commands");
  if (list == NULL) {
    *cmd = GST_NAVIGATION_COMMAND_INVALID;
  } else {
    if (nth < gst_value_list_get_size (list)) {
      *cmd = (GstNavigationCommand)
          g_value_get_enum (gst_value_list_get_value (list, nth));
    } else
      *cmd = GST_NAVIGATION_COMMAND_INVALID;
  }

  return TRUE;
}

/**
 * gst_navigation_query_new_angles:
 *
 * Create a new #GstNavigation angles query. When executed, it will
 * query the pipeline for the set of currently available angles, which may be
 * greater than one in a multiangle video.
 *
 * Returns: The new query.
 */
GstQuery *
gst_navigation_query_new_angles (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new (GST_NAVIGATION_QUERY_NAME,
      "type", G_TYPE_STRING, "angles", NULL);
  query = gst_query_new_custom (GST_QUERY_CUSTOM, structure);

  return query;
}

/**
 * gst_navigation_query_set_angles:
 * @query: a #GstQuery
 * @cur_angle: the current viewing angle to set.
 * @n_angles: the number of viewing angles to set.
 *
 * Set the #GstNavigation angles query result field in @query.
 */
void
gst_navigation_query_set_angles (GstQuery * query, guint cur_angle,
    guint n_angles)
{
  GstStructure *structure;

  g_return_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, ANGLES));

  structure = gst_query_writable_structure (query);
  gst_structure_set (structure,
      "angle", G_TYPE_UINT, cur_angle, "angles", G_TYPE_UINT, n_angles, NULL);
}

/**
 * gst_navigation_query_parse_angles:
 * @query: a #GstQuery
 * @cur_angle: Pointer to a #guint into which to store the currently selected
 * angle value from the query, or NULL
 * @n_angles: Pointer to a #guint into which to store the number of angles
 * value from the query, or NULL
 *
 * Parse the current angle number in the #GstNavigation angles @query into the
 * #guint pointed to by the @cur_angle variable, and the number of available
 * angles into the #guint pointed to by the @n_angles variable.
 *
 * Returns: %TRUE if the query could be successfully parsed. %FALSE if not.
 */
gboolean
gst_navigation_query_parse_angles (GstQuery * query, guint * cur_angle,
    guint * n_angles)
{
  const GstStructure *structure;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_NAVIGATION_QUERY_HAS_TYPE (query, ANGLES), FALSE);

  structure = gst_query_get_structure (query);

  if (cur_angle)
    ret &= gst_structure_get_uint (structure, "angle", cur_angle);

  if (n_angles)
    ret &= gst_structure_get_uint (structure, "angles", n_angles);

  WARN_IF_FAIL (ret, "Couldn't extract details from angles query");

  return ret;
}

/* Navigation Messages */

#define GST_NAVIGATION_MESSAGE_HAS_TYPE(msg,msg_type) \
(gst_navigation_message_get_type (msg) == GST_NAVIGATION_MESSAGE_ ## msg_type)

/**
 * gst_navigation_message_get_type:
 * @message: A #GstMessage to inspect.
 *
 * Check a bus message to see if it is a #GstNavigation event, and return
 * the #GstNavigationMessageType identifying the type of the message if so.
 *
 * Returns: The type of the #GstMessage, or
 * #GST_NAVIGATION_MESSAGE_INVALID if the message is not a #GstNavigation
 * notification.
 */
GstNavigationMessageType
gst_navigation_message_get_type (GstMessage * message)
{
  const GstStructure *s;
  const gchar *m_type;

  if (message == NULL || GST_MESSAGE_TYPE (message) != GST_MESSAGE_ELEMENT)
    return GST_NAVIGATION_MESSAGE_INVALID;

  s = gst_message_get_structure (message);
  if (s == NULL || !gst_structure_has_name (s, GST_NAVIGATION_MESSAGE_NAME))
    return GST_NAVIGATION_MESSAGE_INVALID;

  m_type = gst_structure_get_string (s, "type");
  if (m_type == NULL)
    return GST_NAVIGATION_MESSAGE_INVALID;

  if (g_str_equal (m_type, "mouse-over"))
    return GST_NAVIGATION_MESSAGE_MOUSE_OVER;
  else if (g_str_equal (m_type, "commands-changed"))
    return GST_NAVIGATION_MESSAGE_COMMANDS_CHANGED;
  else if (g_str_equal (m_type, "angles-changed"))
    return GST_NAVIGATION_MESSAGE_ANGLES_CHANGED;

  return GST_NAVIGATION_MESSAGE_INVALID;
}

/**
 * gst_navigation_message_new_mouse_over:
 * @src: A #GstObject to set as source of the new message.
 * @active: %TRUE if the mouse has entered a clickable area of the display.
 * %FALSE if it over a non-clickable area.
 *
 * Creates a new #GstNavigation message with type
 * #GST_NAVIGATION_MESSAGE_MOUSE_OVER.
 *
 * Returns: The new #GstMessage.
 */
GstMessage *
gst_navigation_message_new_mouse_over (GstObject * src, gboolean active)
{
  GstStructure *s;
  GstMessage *m;

  s = gst_structure_new (GST_NAVIGATION_MESSAGE_NAME,
      "type", G_TYPE_STRING, "mouse-over", "active", G_TYPE_BOOLEAN, active,
      NULL);

  m = gst_message_new_custom (GST_MESSAGE_ELEMENT, src, s);

  return m;
}

/**
 * gst_navigation_message_parse_mouse_over:
 * @message: A #GstMessage to inspect.
 * @active: A pointer to a gboolean to receive the active/inactive state,
 * or NULL.
 *
 * Parse a #GstNavigation message of type #GST_NAVIGATION_MESSAGE_MOUSE_OVER
 * and extract the active/inactive flag. If the mouse over event is marked
 * active, it indicates that the mouse is over a clickable area.
 *
 * Returns: %TRUE if the message could be successfully parsed. %FALSE if not.
 */
gboolean
gst_navigation_message_parse_mouse_over (GstMessage * message,
    gboolean * active)
{
  if (!GST_NAVIGATION_MESSAGE_HAS_TYPE (message, MOUSE_OVER))
    return FALSE;

  if (active) {
    const GstStructure *s = gst_message_get_structure (message);
    if (gst_structure_get_boolean (s, "active", active) == FALSE)
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_navigation_message_new_commands_changed:
 * @src: A #GstObject to set as source of the new message.
 *
 * Creates a new #GstNavigation message with type
 * #GST_NAVIGATION_MESSAGE_COMMANDS_CHANGED
 *
 * Returns: The new #GstMessage.
 */
GstMessage *
gst_navigation_message_new_commands_changed (GstObject * src)
{
  GstStructure *s;
  GstMessage *m;

  s = gst_structure_new (GST_NAVIGATION_MESSAGE_NAME,
      "type", G_TYPE_STRING, "commands-changed", NULL);

  m = gst_message_new_custom (GST_MESSAGE_ELEMENT, src, s);

  return m;
}

/**
 * gst_navigation_message_new_angles_changed:
 * @src: A #GstObject to set as source of the new message.
 * @cur_angle: The currently selected angle.
 * @n_angles: The number of viewing angles now available.
 *
 * Creates a new #GstNavigation message with type
 * #GST_NAVIGATION_MESSAGE_ANGLES_CHANGED for notifying an application
 * that the current angle, or current number of angles available in a
 * multiangle video has changed.
 *
 * Returns: The new #GstMessage.
 */
GstMessage *
gst_navigation_message_new_angles_changed (GstObject * src, guint cur_angle,
    guint n_angles)
{
  GstStructure *s;
  GstMessage *m;

  s = gst_structure_new (GST_NAVIGATION_MESSAGE_NAME,
      "type", G_TYPE_STRING, "angles-changed",
      "angle", G_TYPE_UINT, cur_angle, "angles", G_TYPE_UINT, n_angles, NULL);

  m = gst_message_new_custom (GST_MESSAGE_ELEMENT, src, s);

  return m;
}

/**
 * gst_navigation_message_parse_angles_changed:
 * @message: A #GstMessage to inspect.
 * @cur_angle: A pointer to a #guint to receive the new current angle number,
 * or NULL
 * @n_angles: A pointer to a #guint to receive the new angle count, or NULL.
 *
 * Parse a #GstNavigation message of type GST_NAVIGATION_MESSAGE_ANGLES_CHANGED
 * and extract the @cur_angle and @n_angles parameters.
 *
 * Returns: %TRUE if the message could be successfully parsed. %FALSE if not.
 */
gboolean
gst_navigation_message_parse_angles_changed (GstMessage * message,
    guint * cur_angle, guint * n_angles)
{
  const GstStructure *s;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_NAVIGATION_MESSAGE_HAS_TYPE (message,
          ANGLES_CHANGED), FALSE);

  s = gst_message_get_structure (message);
  if (cur_angle)
    ret &= gst_structure_get_uint (s, "angle", cur_angle);

  if (n_angles)
    ret &= gst_structure_get_uint (s, "angles", n_angles);

  WARN_IF_FAIL (ret, "Couldn't extract details from angles-changed event");

  return ret;
}

#define GST_NAVIGATION_EVENT_HAS_TYPE(event,event_type) \
(gst_navigation_event_get_type (event) == GST_NAVIGATION_EVENT_ ## event_type)

/**
 * gst_navigation_event_get_type:
 * @event: A #GstEvent to inspect.
 *
 * Inspect a #GstEvent and return the #GstNavigationEventType of the event, or
 * #GST_NAVIGATION_EVENT_INVALID if the event is not a #GstNavigation event.
 */
GstNavigationEventType
gst_navigation_event_get_type (GstEvent * event)
{
  const GstStructure *s;
  const gchar *e_type;

  if (event == NULL || GST_EVENT_TYPE (event) != GST_EVENT_NAVIGATION)
    return GST_NAVIGATION_EVENT_INVALID;

  s = gst_event_get_structure (event);
  if (s == NULL || !gst_structure_has_name (s, GST_NAVIGATION_EVENT_NAME))
    return GST_NAVIGATION_EVENT_INVALID;

  e_type = gst_structure_get_string (s, "event");
  if (e_type == NULL)
    return GST_NAVIGATION_EVENT_INVALID;

  if (g_str_equal (e_type, "mouse-button-press"))
    return GST_NAVIGATION_EVENT_MOUSE_BUTTON_PRESS;
  else if (g_str_equal (e_type, "mouse-button-release"))
    return GST_NAVIGATION_EVENT_MOUSE_BUTTON_RELEASE;
  else if (g_str_equal (e_type, "mouse-move"))
    return GST_NAVIGATION_EVENT_MOUSE_MOVE;
  else if (g_str_equal (e_type, "key-press"))
    return GST_NAVIGATION_EVENT_KEY_PRESS;
  else if (g_str_equal (e_type, "key-release"))
    return GST_NAVIGATION_EVENT_KEY_RELEASE;
  else if (g_str_equal (e_type, "command"))
    return GST_NAVIGATION_EVENT_COMMAND;

  return GST_NAVIGATION_EVENT_INVALID;
}

/**
 * gst_navigation_event_parse_key_event:
 * @event: A #GstEvent to inspect.
 * @key: A pointer to a location to receive the string identifying the key
 * press. The returned string is owned by the event, and valid only until the
 * event is unreffed.
 */
gboolean
gst_navigation_event_parse_key_event (GstEvent * event, const gchar ** key)
{
  GstNavigationEventType e_type;
  const GstStructure *s;

  e_type = gst_navigation_event_get_type (event);
  g_return_val_if_fail (e_type == GST_NAVIGATION_EVENT_KEY_PRESS ||
      e_type == GST_NAVIGATION_EVENT_KEY_RELEASE, FALSE);

  if (key) {
    s = gst_event_get_structure (event);
    *key = gst_structure_get_string (s, "key");
    if (*key == NULL)
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_navigation_event_parse_mouse_button_event:
 * @event: A #GstEvent to inspect.
 * @button: Pointer to a gint that will receive the button number associated
 * with the event.
 * @x: Pointer to a gdouble to receive the x coordinate of the mouse button
 * event.
 * @y: Pointer to a gdouble to receive the y coordinate of the mouse button
 * event.
 * 
 * Retrieve the details of either a #GstNavigation mouse button press event or
 * a mouse button release event. Determine which type the event is using
 * gst_navigation_event_get_type() to retrieve the #GstNavigationEventType.
 *
 * Returns: TRUE if the button number and both coordinates could be extracted,
 *     otherwise FALSE.
 */
gboolean
gst_navigation_event_parse_mouse_button_event (GstEvent * event, gint * button,
    gdouble * x, gdouble * y)
{
  GstNavigationEventType e_type;
  const GstStructure *s;
  gboolean ret = TRUE;

  e_type = gst_navigation_event_get_type (event);
  g_return_val_if_fail (e_type == GST_NAVIGATION_EVENT_MOUSE_BUTTON_PRESS ||
      e_type == GST_NAVIGATION_EVENT_MOUSE_BUTTON_RELEASE, FALSE);

  s = gst_event_get_structure (event);
  if (x)
    ret &= gst_structure_get_double (s, "pointer_x", x);
  if (y)
    ret &= gst_structure_get_double (s, "pointer_y", y);
  if (button)
    ret &= gst_structure_get_int (s, "button", button);

  WARN_IF_FAIL (ret, "Couldn't extract details from mouse button event");

  return ret;
}

/**
 * gst_navigation_event_parse_mouse_move_event:
 * @event: A #GstEvent to inspect.
 * @x: Pointer to a gdouble to receive the x coordinate of the mouse movement.
 * @y: Pointer to a gdouble to receive the y coordinate of the mouse movement.
 *
 * Inspect a #GstNavigation mouse movement event and extract the coordinates
 * of the event.
 *
 * Returns: TRUE if both coordinates could be extracted, otherwise FALSE.
 */
gboolean
gst_navigation_event_parse_mouse_move_event (GstEvent * event, gdouble * x,
    gdouble * y)
{
  const GstStructure *s;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_NAVIGATION_EVENT_HAS_TYPE (event, MOUSE_MOVE),
      FALSE);

  s = gst_event_get_structure (event);
  if (x)
    ret &= gst_structure_get_double (s, "pointer_x", x);
  if (y)
    ret &= gst_structure_get_double (s, "pointer_y", y);

  WARN_IF_FAIL (ret, "Couldn't extract positions from mouse move event");

  return ret;
}

/**
 * gst_navigation_event_parse_command:
 * @event: A #GstEvent to inspect.
 * @command: Pointer to GstNavigationCommand to receive the type of the
 * navigation event.
 *
 * Inspect a #GstNavigation command event and retrieve the enum value of the
 * associated command.
 *
 * Returns: TRUE if the navigation command could be extracted, otherwise FALSE.
 */
gboolean
gst_navigation_event_parse_command (GstEvent * event,
    GstNavigationCommand * command)
{
  const GstStructure *s;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_NAVIGATION_EVENT_HAS_TYPE (event, COMMAND), FALSE);

  if (command) {
    s = gst_event_get_structure (event);
    ret = gst_structure_get_uint (s, "command-code", (guint *) command);
    WARN_IF_FAIL (ret, "Couldn't extract command code from command event");
  }

  return ret;
}
