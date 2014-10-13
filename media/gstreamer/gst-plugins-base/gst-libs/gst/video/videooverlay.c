/* GStreamer Video Overlay interface
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2011 Tim-Philipp Müller <tim@centricular.net>
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
 * SECTION:gstvideooverlay
 * @short_description: Interface for setting/getting a window system resource
 *    on elements supporting it to configure a window into which to render a
 *    video.
 *
 * <refsect2>
 * <para>
 * The #GstVideoOverlay interface is used for 2 main purposes :
 * <itemizedlist>
 * <listitem>
 * <para>
 * To get a grab on the Window where the video sink element is going to render.
 * This is achieved by either being informed about the Window identifier that
 * the video sink element generated, or by forcing the video sink element to use
 * a specific Window identifier for rendering.
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * To force a redrawing of the latest video frame the video sink element
 * displayed on the Window. Indeed if the #GstPipeline is in #GST_STATE_PAUSED
 * state, moving the Window around will damage its content. Application
 * developers will want to handle the Expose events themselves and force the
 * video sink element to refresh the Window's content.
 * </para>
 * </listitem>
 * </itemizedlist>
 * </para>
 * <para>
 * Using the Window created by the video sink is probably the simplest scenario,
 * in some cases, though, it might not be flexible enough for application
 * developers if they need to catch events such as mouse moves and button
 * clicks.
 * </para>
 * <para>
 * Setting a specific Window identifier on the video sink element is the most
 * flexible solution but it has some issues. Indeed the application needs to set
 * its Window identifier at the right time to avoid internal Window creation
 * from the video sink element. To solve this issue a #GstMessage is posted on
 * the bus to inform the application that it should set the Window identifier
 * immediately. Here is an example on how to do that correctly:
 * |[
 * static GstBusSyncReply
 * create_window (GstBus * bus, GstMessage * message, GstPipeline * pipeline)
 * {
 *  // ignore anything but 'prepare-window-handle' element messages
 *  if (!gst_is_video_overlay_prepare_window_handle_message (message))
 *    return GST_BUS_PASS;
 *
 *  win = XCreateSimpleWindow (disp, root, 0, 0, 320, 240, 0, 0, 0);
 *
 *  XSetWindowBackgroundPixmap (disp, win, None);
 *
 *  XMapRaised (disp, win);
 *
 *  XSync (disp, FALSE);
 *
 *  gst_video_overlay_set_window_handle (GST_VIDEO_OVERLAY (GST_MESSAGE_SRC (message)),
 *      win);
 *
 *  gst_message_unref (message);
 *
 *  return GST_BUS_DROP;
 * }
 * ...
 * int
 * main (int argc, char **argv)
 * {
 * ...
 *  bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
 *  gst_bus_set_sync_handler (bus, (GstBusSyncHandler) create_window, pipeline,
        NULL);
 * ...
 * }
 * ]|
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Two basic usage scenarios</title>
 * <para>
 * There are two basic usage scenarios: in the simplest case, the application
 * uses #playbin or #plasink or knows exactly what particular element is used
 * for video output, which is usually the case when the application creates
 * the videosink to use (e.g. #xvimagesink, #ximagesink, etc.) itself; in this
 * case, the application can just create the videosink element, create and
 * realize the window to render the video on and then
 * call gst_video_overlay_set_window_handle() directly with the XID or native
 * window handle, before starting up the pipeline.
 * As #playbin and #playsink implement the video overlay interface and proxy
 * it transparently to the actual video sink even if it is created later, this
 * case also applies when using these elements.
 * </para>
 * <para>
 * In the other and more common case, the application does not know in advance
 * what GStreamer video sink element will be used for video output. This is
 * usually the case when an element such as #autovideosink is used.
 * In this case, the video sink element itself is created
 * asynchronously from a GStreamer streaming thread some time after the
 * pipeline has been started up. When that happens, however, the video sink
 * will need to know right then whether to render onto an already existing
 * application window or whether to create its own window. This is when it
 * posts a prepare-window-handle message, and that is also why this message needs
 * to be handled in a sync bus handler which will be called from the streaming
 * thread directly (because the video sink will need an answer right then).
 * </para>
 * <para>
 * As response to the prepare-window-handle element message in the bus sync
 * handler, the application may use gst_video_overlay_set_window_handle() to tell
 * the video sink to render onto an existing window surface. At this point the
 * application should already have obtained the window handle / XID, so it
 * just needs to set it. It is generally not advisable to call any GUI toolkit
 * functions or window system functions from the streaming thread in which the
 * prepare-window-handle message is handled, because most GUI toolkits and
 * windowing systems are not thread-safe at all and a lot of care would be
 * required to co-ordinate the toolkit and window system calls of the
 * different threads (Gtk+ users please note: prior to Gtk+ 2.18
 * GDK_WINDOW_XID() was just a simple structure access, so generally fine to do
 * within the bus sync handler; this macro was changed to a function call in
 * Gtk+ 2.18 and later, which is likely to cause problems when called from a
 * sync handler; see below for a better approach without GDK_WINDOW_XID()
 * used in the callback).
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>GstVideoOverlay and Gtk+</title>
 * <para>
 * |[
 * #include &lt;gst/video/videooverlay.h&gt;
 * #include &lt;gtk/gtk.h&gt;
 * #ifdef GDK_WINDOWING_X11
 * #include &lt;gdk/gdkx.h&gt;  // for GDK_WINDOW_XID
 * #endif
 * #ifdef GDK_WINDOWING_WIN32
 * #include &lt;gdk/gdkwin32.h&gt;  // for GDK_WINDOW_HWND
 * #endif
 * ...
 * static guintptr video_window_handle = 0;
 * ...
 * static GstBusSyncReply
 * bus_sync_handler (GstBus * bus, GstMessage * message, gpointer user_data)
 * {
 *  // ignore anything but 'prepare-window-handle' element messages
 *  if (!gst_is_video_overlay_prepare_window_handle_message (message))
 *    return GST_BUS_PASS;
 *
 *  if (video_window_handle != 0) {
 *    GstVideoOverlay *overlay;
 *
 *    // GST_MESSAGE_SRC (message) will be the video sink element
 *    overlay = GST_VIDEO_OVERLAY (GST_MESSAGE_SRC (message));
 *    gst_video_overlay_set_window_handle (overlay, video_window_handle);
 *  } else {
 *    g_warning ("Should have obtained video_window_handle by now!");
 *  }
 *
 *  gst_message_unref (message);
 *  return GST_BUS_DROP;
 * }
 * ...
 * static void
 * video_widget_realize_cb (GtkWidget * widget, gpointer data)
 * {
 * #if GTK_CHECK_VERSION(2,18,0)
 *   // Tell Gtk+/Gdk to create a native window for this widget instead of
 *   // drawing onto the parent widget.
 *   // This is here just for pedagogical purposes, GDK_WINDOW_XID will call
 *   // it as well in newer Gtk versions
 *   if (!gdk_window_ensure_native (widget->window))
 *     g_error ("Couldn't create native window needed for GstVideoOverlay!");
 * #endif
 *
 * #ifdef GDK_WINDOWING_X11
 *   {
 *     gulong xid = GDK_WINDOW_XID (gtk_widget_get_window (video_window));
 *     video_window_handle = xid;
 *   }
 * #endif
 * #ifdef GDK_WINDOWING_WIN32
 *   {
 *     HWND wnd = GDK_WINDOW_HWND (gtk_widget_get_window (video_window));
 *     video_window_handle = (guintptr) wnd;
 *   }
 * #endif
 * }
 * ...
 * int
 * main (int argc, char **argv)
 * {
 *   GtkWidget *video_window;
 *   GtkWidget *app_window;
 *   ...
 *   app_window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
 *   ...
 *   video_window = gtk_drawing_area_new ();
 *   g_signal_connect (video_window, "realize",
 *       G_CALLBACK (video_widget_realize_cb), NULL);
 *   gtk_widget_set_double_buffered (video_window, FALSE);
 *   ...
 *   // usually the video_window will not be directly embedded into the
 *   // application window like this, but there will be many other widgets
 *   // and the video window will be embedded in one of them instead
 *   gtk_container_add (GTK_CONTAINER (ap_window), video_window);
 *   ...
 *   // show the GUI
 *   gtk_widget_show_all (app_window);
 *
 *   // realize window now so that the video window gets created and we can
 *   // obtain its XID/HWND before the pipeline is started up and the videosink
 *   // asks for the XID/HWND of the window to render onto
 *   gtk_widget_realize (video_window);
 *
 *   // we should have the XID/HWND now
 *   g_assert (video_window_handle != 0);
 *   ...
 *   // set up sync handler for setting the xid once the pipeline is started
 *   bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
 *   gst_bus_set_sync_handler (bus, (GstBusSyncHandler) bus_sync_handler, NULL,
 *       NULL);
 *   gst_object_unref (bus);
 *   ...
 *   gst_element_set_state (pipeline, GST_STATE_PLAYING);
 *   ...
 * }
 * ]|
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>GstVideoOverlay and Qt</title>
 * <para>
 * |[
 * #include &lt;glib.h&gt;
 * #include &lt;gst/gst.h&gt;
 * #include &lt;gst/video/videooverlay.h&gt;
 *
 * #include &lt;QApplication&gt;
 * #include &lt;QTimer&gt;
 * #include &lt;QWidget&gt;
 *
 * int main(int argc, char *argv[])
 * {
 *   if (!g_thread_supported ())
 *     g_thread_init (NULL);
 *
 *   gst_init (&argc, &argv);
 *   QApplication app(argc, argv);
 *   app.connect(&app, SIGNAL(lastWindowClosed()), &app, SLOT(quit ()));
 *
 *   // prepare the pipeline
 *
 *   GstElement *pipeline = gst_pipeline_new ("xvoverlay");
 *   GstElement *src = gst_element_factory_make ("videotestsrc", NULL);
 *   GstElement *sink = gst_element_factory_make ("xvimagesink", NULL);
 *   gst_bin_add_many (GST_BIN (pipeline), src, sink, NULL);
 *   gst_element_link (src, sink);
 *
 *   // prepare the ui
 *
 *   QWidget window;
 *   window.resize(320, 240);
 *   window.show();
 *
 *   WId xwinid = window.winId();
 *   gst_video_overlay_set_window_handle (GST_VIDEO_OVERLAY (sink), xwinid);
 *
 *   // run the pipeline
 *
 *   GstStateChangeReturn sret = gst_element_set_state (pipeline,
 *       GST_STATE_PLAYING);
 *   if (sret == GST_STATE_CHANGE_FAILURE) {
 *     gst_element_set_state (pipeline, GST_STATE_NULL);
 *     gst_object_unref (pipeline);
 *     // Exit application
 *     QTimer::singleShot(0, QApplication::activeWindow(), SLOT(quit()));
 *   }
 *
 *   int ret = app.exec();
 *
 *   window.hide();
 *   gst_element_set_state (pipeline, GST_STATE_NULL);
 *   gst_object_unref (pipeline);
 *
 *   return ret;
 * }
 * ]|
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "videooverlay.h"

GType
gst_video_overlay_get_type (void)
{
  static GType gst_video_overlay_type = 0;

  if (!gst_video_overlay_type) {
    static const GTypeInfo gst_video_overlay_info = {
      sizeof (GstVideoOverlayInterface),
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      0,
      0,
      NULL,
    };

    gst_video_overlay_type = g_type_register_static (G_TYPE_INTERFACE,
        "GstVideoOverlay", &gst_video_overlay_info, 0);
  }

  return gst_video_overlay_type;
}

/**
 * gst_video_overlay_set_window_handle:
 * @overlay: a #GstVideoOverlay to set the window on.
 * @handle: a handle referencing the window.
 *
 * This will call the video overlay's set_window_handle method. You
 * should use this method to tell to an overlay to display video output to a
 * specific window (e.g. an XWindow on X11). Passing 0 as the  @handle will
 * tell the overlay to stop using that window and create an internal one.
 */
void
gst_video_overlay_set_window_handle (GstVideoOverlay * overlay, guintptr handle)
{
  GstVideoOverlayInterface *iface;

  g_return_if_fail (overlay != NULL);
  g_return_if_fail (GST_IS_VIDEO_OVERLAY (overlay));

  iface = GST_VIDEO_OVERLAY_GET_INTERFACE (overlay);

  if (iface->set_window_handle) {
    iface->set_window_handle (overlay, handle);
  }
}

/**
 * gst_video_overlay_got_window_handle:
 * @overlay: a #GstVideoOverlay which got a window
 * @handle: a platform-specific handle referencing the window
 *
 * This will post a "have-window-handle" element message on the bus.
 *
 * This function should only be used by video overlay plugin developers.
 */
void
gst_video_overlay_got_window_handle (GstVideoOverlay * overlay, guintptr handle)
{
  GstStructure *s;
  GstMessage *msg;

  g_return_if_fail (overlay != NULL);
  g_return_if_fail (GST_IS_VIDEO_OVERLAY (overlay));

  GST_LOG_OBJECT (GST_OBJECT (overlay), "window_handle = %p", (gpointer)
      handle);
  s = gst_structure_new ("have-window-handle",
      "window-handle", G_TYPE_UINT64, (guint64) handle, NULL);
  msg = gst_message_new_element (GST_OBJECT (overlay), s);
  gst_element_post_message (GST_ELEMENT (overlay), msg);
}

/**
 * gst_video_overlay_prepare_window_handle:
 * @overlay: a #GstVideoOverlay which does not yet have an Window handle set
 *
 * This will post a "prepare-window-handle" element message on the bus
 * to give applications an opportunity to call
 * gst_video_overlay_set_window_handle() before a plugin creates its own
 * window.
 *
 * This function should only be used by video overlay plugin developers.
 */
void
gst_video_overlay_prepare_window_handle (GstVideoOverlay * overlay)
{
  GstStructure *s;
  GstMessage *msg;

  g_return_if_fail (overlay != NULL);
  g_return_if_fail (GST_IS_VIDEO_OVERLAY (overlay));

  GST_LOG_OBJECT (GST_OBJECT (overlay), "prepare window handle");
  s = gst_structure_new_empty ("prepare-window-handle");
  msg = gst_message_new_element (GST_OBJECT (overlay), s);
  gst_element_post_message (GST_ELEMENT (overlay), msg);
}

/**
 * gst_video_overlay_expose:
 * @overlay: a #GstVideoOverlay to expose.
 *
 * Tell an overlay that it has been exposed. This will redraw the current frame
 * in the drawable even if the pipeline is PAUSED.
 */
void
gst_video_overlay_expose (GstVideoOverlay * overlay)
{
  GstVideoOverlayInterface *iface;

  g_return_if_fail (overlay != NULL);
  g_return_if_fail (GST_IS_VIDEO_OVERLAY (overlay));

  iface = GST_VIDEO_OVERLAY_GET_INTERFACE (overlay);

  if (iface->expose) {
    iface->expose (overlay);
  }
}

/**
 * gst_video_overlay_handle_events:
 * @overlay: a #GstVideoOverlay to expose.
 * @handle_events: a #gboolean indicating if events should be handled or not.
 *
 * Tell an overlay that it should handle events from the window system. These
 * events are forwarded upstream as navigation events. In some window system,
 * events are not propagated in the window hierarchy if a client is listening
 * for them. This method allows you to disable events handling completely
 * from the #GstVideoOverlay.
 */
void
gst_video_overlay_handle_events (GstVideoOverlay * overlay,
    gboolean handle_events)
{
  GstVideoOverlayInterface *iface;

  g_return_if_fail (overlay != NULL);
  g_return_if_fail (GST_IS_VIDEO_OVERLAY (overlay));

  iface = GST_VIDEO_OVERLAY_GET_INTERFACE (overlay);

  if (iface->handle_events) {
    iface->handle_events (overlay, handle_events);
  }
}

/**
 * gst_video_overlay_set_render_rectangle:
 * @overlay: a #GstVideoOverlay
 * @x: the horizontal offset of the render area inside the window
 * @y: the vertical offset of the render area inside the window
 * @width: the width of the render area inside the window
 * @height: the height of the render area inside the window
 *
 * Configure a subregion as a video target within the window set by
 * gst_video_overlay_set_window_handle(). If this is not used or not supported
 * the video will fill the area of the window set as the overlay to 100%.
 * By specifying the rectangle, the video can be overlayed to a specific region
 * of that window only. After setting the new rectangle one should call
 * gst_video_overlay_expose() to force a redraw. To unset the region pass -1 for
 * the @width and @height parameters.
 *
 * This method is needed for non fullscreen video overlay in UI toolkits that
 * do not support subwindows.
 *
 * Returns: %FALSE if not supported by the sink.
 */
gboolean
gst_video_overlay_set_render_rectangle (GstVideoOverlay * overlay,
    gint x, gint y, gint width, gint height)
{
  GstVideoOverlayInterface *iface;

  g_return_val_if_fail (overlay != NULL, FALSE);
  g_return_val_if_fail (GST_IS_VIDEO_OVERLAY (overlay), FALSE);
  g_return_val_if_fail ((width == -1 && height == -1) ||
      (width > 0 && height > 0), FALSE);

  iface = GST_VIDEO_OVERLAY_GET_INTERFACE (overlay);

  if (iface->set_render_rectangle) {
    iface->set_render_rectangle (overlay, x, y, width, height);
    return TRUE;
  }
  return FALSE;
}

/**
 * gst_is_video_overlay_prepare_window_handle_message:
 * @msg: a #GstMessage
 *
 * Convenience function to check if the given message is a
 * "prepare-window-handle" message from a #GstVideoOverlay.
 *
 * Returns: whether @msg is a "prepare-window-handle" message
 */
gboolean
gst_is_video_overlay_prepare_window_handle_message (GstMessage * msg)
{
  g_return_val_if_fail (msg != NULL, FALSE);

  if (GST_MESSAGE_TYPE (msg) != GST_MESSAGE_ELEMENT)
    return FALSE;

  return gst_message_has_name (msg, "prepare-window-handle");
}
