/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set expandtab shiftwidth=2 tabstop=2: */
 
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 
/*
 * The GtkXtBin widget allows for Xt toolkit code to be used
 * inside a GTK application.  
 */

#include "xembed.h"
#include "gtk2xtbin.h"
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <glib.h>
#include <assert.h>
#include <sys/time.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* Xlib/Xt stuff */
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Shell.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

/* uncomment this if you want debugging information about widget
   creation and destruction */
#undef DEBUG_XTBIN

#define XTBIN_MAX_EVENTS 30

static void            gtk_xtbin_class_init (GtkXtBinClass *klass);
static void            gtk_xtbin_init       (GtkXtBin      *xtbin);
static void            gtk_xtbin_realize    (GtkWidget      *widget);
static void            gtk_xtbin_unrealize    (GtkWidget      *widget);
static void            gtk_xtbin_destroy    (GtkObject      *object);

/* Xt aware XEmbed */
static void       xt_client_handle_xembed_message (Widget w, 
                                                   XtPointer client_data, 
                                                   XEvent *event);
static void       xt_add_focus_listener( Widget w, XtPointer user_data );
static void       xt_add_focus_listener_tree ( Widget treeroot, XtPointer user_data); 
static void       xt_remove_focus_listener(Widget w, XtPointer user_data);
static void       xt_client_event_handler (Widget w, XtPointer client_data, XEvent *event);
static void       xt_client_focus_listener (Widget w, XtPointer user_data, XEvent *event);
static void       xt_client_set_info (Widget xtplug, unsigned long flags);
static void       send_xembed_message (XtClient *xtclient,
                                       long message, 
                                       long detail, 
                                       long data1, 
                                       long data2,
                                       long time);  
static int        error_handler       (Display *display, 
                                       XErrorEvent *error);
/* For error trap of XEmbed */
static void       trap_errors(void);
static int        untrap_error(void);
static int        (*old_error_handler) (Display *, XErrorEvent *);
static int        trapped_error_code = 0;

static GtkWidgetClass *parent_class = NULL;

static Display         *xtdisplay = NULL;
static String          *fallback = NULL;
static gboolean         xt_is_initialized = FALSE;
static gint             num_widgets = 0;

static GPollFD          xt_event_poll_fd;
static gint             xt_polling_timer_id = 0;
static guint            tag = 0;

static gboolean
xt_event_prepare (GSource*  source_data,
                   gint     *timeout)
{   
  int mask;

  mask = XPending(xtdisplay);

  return (gboolean)mask;
}

static gboolean
xt_event_check (GSource*  source_data)
{
  if (xt_event_poll_fd.revents & G_IO_IN) {
    int mask;
    mask = XPending(xtdisplay);
    return (gboolean)mask;
  }

  return FALSE;
}   

static gboolean
xt_event_dispatch (GSource*  source_data,
                    GSourceFunc call_back,
                    gpointer  user_data)
{
  XtAppContext ac;
  int i = 0;

  ac = XtDisplayToApplicationContext(xtdisplay);

  /* Process only real X traffic here.  We only look for data on the
   * pipe, limit it to XTBIN_MAX_EVENTS and only call
   * XtAppProcessEvent so that it will look for X events.  There's no
   * timer processing here since we already have a timer callback that
   * does it.  */
  for (i=0; i < XTBIN_MAX_EVENTS && XPending(xtdisplay); i++) {
    XtAppProcessEvent(ac, XtIMXEvent);
  }

  return TRUE;  
}

static GSourceFuncs xt_event_funcs = {
  xt_event_prepare,
  xt_event_check,
  xt_event_dispatch,
  NULL,
  (GSourceFunc)NULL,
  (GSourceDummyMarshal)NULL
};

static gboolean
xt_event_polling_timer_callback(gpointer user_data)
{
  Display * display;
  XtAppContext ac;
  int eventsToProcess = 20;

  display = (Display *)user_data;
  ac = XtDisplayToApplicationContext(display);

  /* We need to process many Xt events here. If we just process
     one event we might starve one or more Xt consumers. On the other hand
     this could hang the whole app if Xt events come pouring in. So process
     up to 20 Xt events right now and save the rest for later. This is a hack,
     but it oughta work. We *really* should have out of process plugins.
  */
  while (eventsToProcess-- && XtAppPending(ac))
    XtAppProcessEvent(ac, XtIMAll);
  return TRUE;
}

GType
gtk_xtbin_get_type (void)
{
  static GType xtbin_type = 0;

  if (!xtbin_type) {
      static const GTypeInfo xtbin_info =
      {
        sizeof (GtkXtBinClass), /* class_size */
        NULL, /* base_init */
        NULL, /* base_finalize */
        (GClassInitFunc) gtk_xtbin_class_init, /* class_init */
        NULL, /* class_finalize */
        NULL, /* class_data */
        sizeof (GtkXtBin), /* instance_size */
        0, /* n_preallocs */
        (GInstanceInitFunc) gtk_xtbin_init, /* instance_init */
        NULL /* value_table */
      };
      xtbin_type = g_type_register_static(GTK_TYPE_SOCKET, "GtkXtBin",
        &xtbin_info, 0);
    }
  return xtbin_type;
}

static void
gtk_xtbin_class_init (GtkXtBinClass *klass)
{
  GtkWidgetClass *widget_class;
  GtkObjectClass *object_class;

  parent_class = g_type_class_peek_parent(klass);

  widget_class = GTK_WIDGET_CLASS (klass);
  widget_class->realize = gtk_xtbin_realize;
  widget_class->unrealize = gtk_xtbin_unrealize;

  object_class = GTK_OBJECT_CLASS (klass);
  object_class->destroy = gtk_xtbin_destroy;
}

static void
gtk_xtbin_init (GtkXtBin *xtbin)
{
  xtbin->xtdisplay = NULL;
  xtbin->parent_window = NULL;
  xtbin->xtwindow = 0;
}

static void
gtk_xtbin_realize (GtkWidget *widget)
{
  GtkXtBin     *xtbin;
  GtkAllocation allocation = { 0, 0, 200, 200 };
  gint  x, y, w, h, d; /* geometry of window */

#ifdef DEBUG_XTBIN
  printf("gtk_xtbin_realize()\n");
#endif

  g_return_if_fail (GTK_IS_XTBIN (widget));

  xtbin = GTK_XTBIN (widget);

  /* caculate the allocation before realize */
  gdk_window_get_geometry(xtbin->parent_window, &x, &y, &w, &h, &d);
  allocation.width = w;
  allocation.height = h;
  gtk_widget_size_allocate (widget, &allocation);

#ifdef DEBUG_XTBIN
  printf("initial allocation %d %d %d %d\n", x, y, w, h);
#endif

  /* use GtkSocket's realize */
  (*GTK_WIDGET_CLASS(parent_class)->realize)(widget);

  /* create the Xt client widget */
  xt_client_create(&(xtbin->xtclient), 
       gtk_socket_get_id(GTK_SOCKET(xtbin)), 
       h, w);
  xtbin->xtwindow = XtWindow(xtbin->xtclient.child_widget);

  gdk_flush();

  /* now that we have created the xt client, add it to the socket. */
  gtk_socket_add_id(GTK_SOCKET(widget), xtbin->xtwindow);
}



GtkWidget*
gtk_xtbin_new (GdkWindow *parent_window, String * f)
{
  GtkXtBin *xtbin;
  gpointer user_data;

  assert(parent_window != NULL);
  xtbin = g_object_new (GTK_TYPE_XTBIN, NULL);

  if (!xtbin)
    return (GtkWidget*)NULL;

  if (f)
    fallback = f;

  /* Initialize the Xt toolkit */
  xtbin->parent_window = parent_window;

  xt_client_init(&(xtbin->xtclient), 
      GDK_VISUAL_XVISUAL(gdk_rgb_get_visual()),
      GDK_COLORMAP_XCOLORMAP(gdk_rgb_get_colormap()),
      gdk_rgb_get_visual()->depth);

  if (!xtbin->xtclient.xtdisplay) {
    /* If XtOpenDisplay failed, we can't go any further.
     *  Bail out.
     */
#ifdef DEBUG_XTBIN
    printf("gtk_xtbin_init: XtOpenDisplay() returned NULL.\n");
#endif
    g_free (xtbin);
    return (GtkWidget *)NULL;
  }

  /* Launch X event loop */
  xt_client_xloop_create();

  /* Build the hierachy */
  xtbin->xtdisplay = xtbin->xtclient.xtdisplay;
  gtk_widget_set_parent_window(GTK_WIDGET(xtbin), parent_window);
  gdk_window_get_user_data(xtbin->parent_window, &user_data);
  if (user_data)
    gtk_container_add(GTK_CONTAINER(user_data), GTK_WIDGET(xtbin));

  /* This GtkSocket has a visible window, but the Xt plug will cover this
   * window.  Normally GtkSockets let the X server paint their background and
   * this would happen immediately (before the plug is mapped).  Setting the
   * background to None prevents the server from painting this window,
   * avoiding flicker.
   */
  gtk_widget_realize(GTK_WIDGET(xtbin));
  gdk_window_set_back_pixmap(GTK_WIDGET(xtbin)->window, NULL, FALSE);

  return GTK_WIDGET (xtbin);
}

static void
gtk_xtbin_unrealize (GtkWidget *object)
{
  GtkXtBin *xtbin;
  GtkWidget *widget;

#ifdef DEBUG_XTBIN
  printf("gtk_xtbin_unrealize()\n");
#endif

  /* gtk_object_destroy() will already hold a refcount on object
   */
  xtbin = GTK_XTBIN(object);
  widget = GTK_WIDGET(object);

  GTK_WIDGET_UNSET_FLAGS (widget, GTK_VISIBLE);
  if (GTK_WIDGET_REALIZED (widget)) {
    xt_client_unrealize(&(xtbin->xtclient));
  }

  (*GTK_WIDGET_CLASS (parent_class)->unrealize)(widget);
}

static void
gtk_xtbin_destroy (GtkObject *object)
{
  GtkXtBin *xtbin;

#ifdef DEBUG_XTBIN
  printf("gtk_xtbin_destroy()\n");
#endif

  g_return_if_fail (object != NULL);
  g_return_if_fail (GTK_IS_XTBIN (object));

  xtbin = GTK_XTBIN (object);

  if(xtbin->xtwindow) {
    /* remove the event handler */
    xt_client_destroy(&(xtbin->xtclient));
    xtbin->xtwindow = 0;

    /* stop X event loop */
    xt_client_xloop_destroy();
  }

  GTK_OBJECT_CLASS(parent_class)->destroy(object);
}

/*
* Following is the implementation of Xt XEmbedded for client side
*/

/* Initial Xt plugin */
void
xt_client_init( XtClient * xtclient, 
                Visual *xtvisual, 
                Colormap xtcolormap,
                int xtdepth)
{
  XtAppContext  app_context;
  char         *mArgv[1];
  int           mArgc = 0;

  /*
   * Initialize Xt stuff
   */
  xtclient->top_widget = NULL;
  xtclient->child_widget = NULL;
  xtclient->xtdisplay  = NULL;
  xtclient->xtvisual   = NULL;
  xtclient->xtcolormap = 0;
  xtclient->xtdepth = 0;

  if (!xt_is_initialized) {
#ifdef DEBUG_XTBIN
    printf("starting up Xt stuff\n");
#endif
    XtToolkitInitialize();
    app_context = XtCreateApplicationContext();
    if (fallback)
      XtAppSetFallbackResources(app_context, fallback);

    xtdisplay = XtOpenDisplay(app_context, gdk_get_display(), NULL, 
                            "Wrapper", NULL, 0, &mArgc, mArgv);
    if (xtdisplay)
      xt_is_initialized = TRUE;
  }
  xtclient->xtdisplay  = xtdisplay;
  xtclient->xtvisual   = xtvisual;
  xtclient->xtcolormap = xtcolormap;
  xtclient->xtdepth    = xtdepth;
}

void
xt_client_xloop_create(void)
{
  /* If this is the first running widget, hook this display into the
     mainloop */
  if (0 == num_widgets) {
    int cnumber;
    GSource* gs;

    /* Set up xtdisplay in case we're missing one */
    if (!xtdisplay) {
      (void)xt_client_get_display();
    }

    /*
     * hook Xt event loop into the glib event loop.
     */
    /* the assumption is that gtk_init has already been called */
    gs = g_source_new(&xt_event_funcs, sizeof(GSource));
    if (!gs) {
      return;
    }

    g_source_set_priority(gs, GDK_PRIORITY_EVENTS);
    g_source_set_can_recurse(gs, TRUE);
    tag = g_source_attach(gs, (GMainContext*)NULL);
    g_source_unref(gs);
#ifdef VMS
    cnumber = XConnectionNumber(xtdisplay);
#else
    cnumber = ConnectionNumber(xtdisplay);
#endif
    xt_event_poll_fd.fd = cnumber;
    xt_event_poll_fd.events = G_IO_IN; 
    xt_event_poll_fd.revents = 0;    /* hmm... is this correct? */

    g_main_context_add_poll ((GMainContext*)NULL, 
                             &xt_event_poll_fd, 
                             G_PRIORITY_LOW);
    /* add a timer so that we can poll and process Xt timers */
    xt_polling_timer_id =
      g_timeout_add(25,
                    (GtkFunction)xt_event_polling_timer_callback,
                    xtdisplay);
  }

  /* Bump up our usage count */
  num_widgets++;
}

void
xt_client_xloop_destroy(void)
{
  num_widgets--; /* reduce our usage count */

  /* If this is the last running widget, remove the Xt display
     connection from the mainloop */
  if (0 == num_widgets) {
#ifdef DEBUG_XTBIN
    printf("removing the Xt connection from the main loop\n");
#endif
    g_main_context_remove_poll((GMainContext*)NULL, &xt_event_poll_fd);
    g_source_remove(tag);

    g_source_remove(xt_polling_timer_id);
    xt_polling_timer_id = 0;
  }
}

/* Get Xt Client display */
Display	*
xt_client_get_display(void)
{
  if (!xtdisplay) {
    XtClient tmp;
    xt_client_init(&tmp,NULL,0,0);
  }
  return xtdisplay;
}

/* Create the Xt client widgets
*  */
void
xt_client_create ( XtClient* xtclient , 
                   Window embedderid, 
                   int height, 
                   int width ) 
{
  int           n;
  Arg           args[6];
  Widget        child_widget;
  Widget        top_widget;

#ifdef DEBUG_XTBIN
  printf("xt_client_create() \n");
#endif
  top_widget = XtAppCreateShell("drawingArea", "Wrapper", 
                                applicationShellWidgetClass, 
                                xtclient->xtdisplay, 
                                NULL, 0);
  xtclient->top_widget = top_widget;

  /* set size of Xt window */
  n = 0;
  XtSetArg(args[n], XtNheight,   height);n++;
  XtSetArg(args[n], XtNwidth,    width);n++;
  XtSetValues(top_widget, args, n);

  child_widget = XtVaCreateWidget("form", 
                                  compositeWidgetClass, 
                                  top_widget, NULL);

  n = 0;
  XtSetArg(args[n], XtNheight,   height);n++;
  XtSetArg(args[n], XtNwidth,    width);n++;
  XtSetArg(args[n], XtNvisual,   xtclient->xtvisual ); n++;
  XtSetArg(args[n], XtNdepth,    xtclient->xtdepth ); n++;
  XtSetArg(args[n], XtNcolormap, xtclient->xtcolormap ); n++;
  XtSetArg(args[n], XtNborderWidth, 0); n++;
  XtSetValues(child_widget, args, n);

  XSync(xtclient->xtdisplay, FALSE);
  xtclient->oldwindow = top_widget->core.window;
  top_widget->core.window = embedderid;

  /* this little trick seems to finish initializing the widget */
#if XlibSpecificationRelease >= 6
  XtRegisterDrawable(xtclient->xtdisplay, 
                     embedderid,
                     top_widget);
#else
  _XtRegisterWindow( embedderid,
                     top_widget);
#endif
  XtRealizeWidget(child_widget);

  /* listen to all Xt events */
  XSelectInput(xtclient->xtdisplay, 
               embedderid, 
               XtBuildEventMask(top_widget));
  xt_client_set_info (child_widget, 0);

  XtManageChild(child_widget);
  xtclient->child_widget = child_widget;

  /* set the event handler */
  XtAddEventHandler(child_widget,
                    StructureNotifyMask | KeyPressMask,
                    TRUE, 
                    (XtEventHandler)xt_client_event_handler, xtclient);
  XtAddEventHandler(child_widget, 
                    SubstructureNotifyMask | ButtonReleaseMask, 
                    FALSE,
                    (XtEventHandler)xt_client_focus_listener, 
                    xtclient);
  XSync(xtclient->xtdisplay, FALSE);
}

void
xt_client_unrealize ( XtClient* xtclient )
{
  /* Explicitly destroy the child_widget window because this is actually a
     child of the socket window.  It is not a child of top_widget's window
     when that is destroyed. */
  XtUnrealizeWidget(xtclient->child_widget);

#if XlibSpecificationRelease >= 6
  XtUnregisterDrawable(xtclient->xtdisplay,
                       xtclient->top_widget->core.window);
#else
  _XtUnregisterWindow(xtclient->top_widget->core.window,
                      xtclient->top_widget);
#endif

  /* flush the queue before we returning origin top_widget->core.window
     or we can get X error since the window is gone */
  XSync(xtclient->xtdisplay, False);

  xtclient->top_widget->core.window = xtclient->oldwindow;
  XtUnrealizeWidget(xtclient->top_widget);
}

void            
xt_client_destroy   (XtClient* xtclient)
{
  if(xtclient->top_widget) {
    XtRemoveEventHandler(xtclient->child_widget,
                         StructureNotifyMask | KeyPressMask,
                         TRUE, 
                         (XtEventHandler)xt_client_event_handler, xtclient);
    XtDestroyWidget(xtclient->top_widget);
    xtclient->top_widget = NULL;
  }
}

void         
xt_client_set_info (Widget xtplug, unsigned long flags)
{
  unsigned long buffer[2];

  Atom infoAtom = XInternAtom(XtDisplay(xtplug), "_XEMBED_INFO", False); 

  buffer[1] = 0;                /* Protocol version */
  buffer[1] = flags;

  XChangeProperty (XtDisplay(xtplug), XtWindow(xtplug),
                   infoAtom, infoAtom, 32,
                   PropModeReplace,
                   (unsigned char *)buffer, 2);
}

static void
xt_client_handle_xembed_message(Widget w, XtPointer client_data, XEvent *event)
{
  XtClient *xtplug = (XtClient*)client_data;
  switch (event->xclient.data.l[1])
  {
  case XEMBED_EMBEDDED_NOTIFY:
    break;
  case XEMBED_WINDOW_ACTIVATE:
#ifdef DEBUG_XTBIN
    printf("Xt client get XEMBED_WINDOW_ACTIVATE\n");
#endif
    break;
  case XEMBED_WINDOW_DEACTIVATE:
#ifdef DEBUG_XTBIN
    printf("Xt client get XEMBED_WINDOW_DEACTIVATE\n");
#endif
    break;
  case XEMBED_MODALITY_ON:
#ifdef DEBUG_XTBIN
    printf("Xt client get XEMBED_MODALITY_ON\n");
#endif
    break;
  case XEMBED_MODALITY_OFF:
#ifdef DEBUG_XTBIN
    printf("Xt client get XEMBED_MODALITY_OFF\n");
#endif
    break;
  case XEMBED_FOCUS_IN:
  case XEMBED_FOCUS_OUT:
    {
      XEvent xevent;
      memset(&xevent, 0, sizeof(xevent));

      if(event->xclient.data.l[1] == XEMBED_FOCUS_IN) {
#ifdef DEBUG_XTBIN
        printf("XTEMBED got focus in\n");
#endif
        xevent.xfocus.type = FocusIn;
      }
      else {
#ifdef DEBUG_XTBIN
        printf("XTEMBED got focus out\n");
#endif
        xevent.xfocus.type = FocusOut;
      }

      xevent.xfocus.window = XtWindow(xtplug->child_widget);
      xevent.xfocus.display = XtDisplay(xtplug->child_widget);
      XSendEvent(XtDisplay(xtplug->child_widget), 
                 xevent.xfocus.window,
                 False, NoEventMask,
                 &xevent );
      XSync( XtDisplay(xtplug->child_widget), False);
    }
    break;
  default:
    break;
  } /* End of XEmbed Message */
}

void         
xt_client_event_handler( Widget w, XtPointer client_data, XEvent *event)
{
  XtClient *xtplug = (XtClient*)client_data;
  
  switch(event->type)
    {
    case ClientMessage:
      /* Handle xembed message */
      if (event->xclient.message_type==
                 XInternAtom (XtDisplay(xtplug->child_widget),
                              "_XEMBED", False)) {
        xt_client_handle_xembed_message(w, client_data, event);
      }
      break;
    case ReparentNotify:
      break;
    case MappingNotify:
      xt_client_set_info (w, XEMBED_MAPPED);
      break;
    case UnmapNotify:
      xt_client_set_info (w, 0);
      break;
    case KeyPress:
#ifdef DEBUG_XTBIN
      printf("Key Press Got!\n");
#endif
      break;
    default:
      break;
    } /* End of switch(event->type) */
}

static void
send_xembed_message (XtClient  *xtclient,
                     long      message,
                     long      detail, 
                     long      data1,  
                     long      data2,  
                     long      time)   
{
  XEvent xevent; 
  Window w=XtWindow(xtclient->top_widget);
  Display* dpy=xtclient->xtdisplay;
  int errorcode;

  memset(&xevent,0,sizeof(xevent));
  xevent.xclient.window = w;
  xevent.xclient.type = ClientMessage;
  xevent.xclient.message_type = XInternAtom(dpy,"_XEMBED",False);
  xevent.xclient.format = 32;
  xevent.xclient.data.l[0] = time; 
  xevent.xclient.data.l[1] = message;
  xevent.xclient.data.l[2] = detail; 
  xevent.xclient.data.l[3] = data1;
  xevent.xclient.data.l[4] = data2;

  trap_errors ();
  XSendEvent (dpy, w, False, NoEventMask, &xevent);
  XSync (dpy,False);

  if((errorcode = untrap_error())) {
#ifdef DEBUG_XTBIN
    printf("send_xembed_message error(%d)!!!\n",errorcode);
#endif
  }
}

static int             
error_handler(Display *display, XErrorEvent *error)
{
  trapped_error_code = error->error_code;
  return 0;
}

static void          
trap_errors(void)
{
  trapped_error_code =0;
  old_error_handler = XSetErrorHandler(error_handler);
}

static int         
untrap_error(void)
{
  XSetErrorHandler(old_error_handler);
  if(trapped_error_code) {
#ifdef DEBUG_XTBIN
    printf("Get X Window Error = %d\n", trapped_error_code);
#endif
  }
  return trapped_error_code;
}

void         
xt_client_focus_listener( Widget w, XtPointer user_data, XEvent *event)
{
  Display *dpy = XtDisplay(w);
  XtClient *xtclient = user_data;
  Window win = XtWindow(w);

  switch(event->type)
    {
    case CreateNotify:
      if(event->xcreatewindow.parent == win) {
        Widget child=XtWindowToWidget( dpy, event->xcreatewindow.window);
        if (child)
          xt_add_focus_listener_tree(child, user_data);
      }
      break;
    case DestroyNotify:
      xt_remove_focus_listener( w, user_data);
      break;
    case ReparentNotify:
      if(event->xreparent.parent == win) {
        /* I am the new parent */
        Widget child=XtWindowToWidget(dpy, event->xreparent.window);
        if (child)
          xt_add_focus_listener_tree( child, user_data);
      }
      else if(event->xreparent.window == win) {
        /* I am the new child */
      }
      else {
        /* I am the old parent */
      }
      break;
    case ButtonRelease:
#if 0
      XSetInputFocus(dpy, XtWindow(xtclient->child_widget), RevertToParent, event->xbutton.time);
#endif
      send_xembed_message ( xtclient,
                            XEMBED_REQUEST_FOCUS, 0, 0, 0, 0);
      break;
    default:
      break;
    } /* End of switch(event->type) */
}

static void
xt_add_focus_listener( Widget w, XtPointer user_data)
{
  XtClient *xtclient = user_data;

  trap_errors ();
  XtAddEventHandler(w, 
                    SubstructureNotifyMask | ButtonReleaseMask, 
                    FALSE, 
                    (XtEventHandler)xt_client_focus_listener, 
                    xtclient);
  untrap_error();
}

static void
xt_remove_focus_listener(Widget w, XtPointer user_data)
{
  trap_errors ();
  XtRemoveEventHandler(w, SubstructureNotifyMask | ButtonReleaseMask, FALSE, 
                      (XtEventHandler)xt_client_focus_listener, user_data);

  untrap_error();
}

static void
xt_add_focus_listener_tree ( Widget treeroot, XtPointer user_data) 
{
  Window win = XtWindow(treeroot);
  Window *children;
  Window root, parent;
  Display *dpy = XtDisplay(treeroot);
  unsigned int i, nchildren;

  /* ensure we don't add more than once */
  xt_remove_focus_listener( treeroot, user_data);
  xt_add_focus_listener( treeroot, user_data);
  trap_errors();
  if(!XQueryTree(dpy, win, &root, &parent, &children, &nchildren)) {
    untrap_error();
    return;
  }

  if(untrap_error()) 
    return;

  for(i=0; i<nchildren; ++i) {
    Widget child = XtWindowToWidget(dpy, children[i]);
    if (child) 
      xt_add_focus_listener_tree( child, user_data);
  }
  XFree((void*)children);
}

