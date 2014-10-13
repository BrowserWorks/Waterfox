/* GStreamer
 *
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2004 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstbin.c: GstBin container object and support code
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
 *
 * MT safe.
 */

/**
 * SECTION:gstbin
 * @short_description: Base class and element that can contain other elements
 *
 * #GstBin is an element that can contain other #GstElement, allowing them to be
 * managed as a group.
 * Pads from the child elements can be ghosted to the bin, see #GstGhostPad.
 * This makes the bin look like any other elements and enables creation of
 * higher-level abstraction elements.
 *
 * A new #GstBin is created with gst_bin_new(). Use a #GstPipeline instead if you
 * want to create a toplevel bin because a normal bin doesn't have a bus or
 * handle clock distribution of its own.
 *
 * After the bin has been created you will typically add elements to it with
 * gst_bin_add(). You can remove elements with gst_bin_remove().
 *
 * An element can be retrieved from a bin with gst_bin_get_by_name(), using the
 * elements name. gst_bin_get_by_name_recurse_up() is mainly used for internal
 * purposes and will query the parent bins when the element is not found in the
 * current bin.
 *
 * An iterator of elements in a bin can be retrieved with
 * gst_bin_iterate_elements(). Various other iterators exist to retrieve the
 * elements in a bin.
 *
 * gst_object_unref() is used to drop your reference to the bin.
 *
 * The #GstBin::element-added signal is fired whenever a new element is added to
 * the bin. Likewise the #GstBin::element-removed signal is fired whenever an
 * element is removed from the bin.
 *
 * <refsect2><title>Notes</title>
 * <para>
 * A #GstBin internally intercepts every #GstMessage posted by its children and
 * implements the following default behaviour for each of them:
 * <variablelist>
 *   <varlistentry>
 *     <term>GST_MESSAGE_EOS</term>
 *     <listitem><para>This message is only posted by sinks in the PLAYING
 *     state. If all sinks posted the EOS message, this bin will post and EOS
 *     message upwards.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_MESSAGE_SEGMENT_START</term>
 *     <listitem><para>just collected and never forwarded upwards.
 *     The messages are used to decide when all elements have completed playback
 *     of their segment.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_MESSAGE_SEGMENT_DONE</term>
 *     <listitem><para> Is posted by #GstBin when all elements that posted
 *     a SEGMENT_START have posted a SEGMENT_DONE.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_MESSAGE_DURATION_CHANGED</term>
 *     <listitem><para> Is posted by an element that detected a change
 *     in the stream duration. The default bin behaviour is to clear any
 *     cached duration values so that the next duration query will perform
 *     a full duration recalculation. The duration change is posted to the
 *     application so that it can refetch the new duration with a duration
 *     query. Note that these messages can be posted before the bin is
 *     prerolled, in which case the duration query might fail.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_MESSAGE_CLOCK_LOST</term>
 *     <listitem><para> This message is posted by an element when it
 *     can no longer provide a clock. The default bin behaviour is to
 *     check if the lost clock was the one provided by the bin. If so and
 *     the bin is currently in the PLAYING state, the message is forwarded to
 *     the bin parent.
 *     This message is also generated when a clock provider is removed from
 *     the bin. If this message is received by the application, it should
 *     PAUSE the pipeline and set it back to PLAYING to force a new clock
 *     distribution.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_MESSAGE_CLOCK_PROVIDE</term>
 *     <listitem><para> This message is generated when an element
 *     can provide a clock. This mostly happens when a new clock
 *     provider is added to the bin. The default behaviour of the bin is to
 *     mark the currently selected clock as dirty, which will perform a clock
 *     recalculation the next time the bin is asked to provide a clock.
 *     This message is never sent tot the application but is forwarded to
 *     the parent of the bin.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>OTHERS</term>
 *     <listitem><para> posted upwards.</para></listitem>
 *   </varlistentry>
 * </variablelist>
 *
 *
 * A #GstBin implements the following default behaviour for answering to a
 * #GstQuery:
 * <variablelist>
 *   <varlistentry>
 *     <term>GST_QUERY_DURATION</term>
 *     <listitem><para>If the query has been asked before with the same format
 *     and the bin is a toplevel bin (ie. has no parent),
 *     use the cached previous value. If no previous value was cached, the
 *     query is sent to all sink elements in the bin and the MAXIMUM of all
 *     values is returned. If the bin is a toplevel bin the value is cached.
 *     If no sinks are available in the bin, the query fails.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>GST_QUERY_POSITION</term>
 *     <listitem><para>The query is sent to all sink elements in the bin and the
 *     MAXIMUM of all values is returned. If no sinks are available in the bin,
 *     the query fails.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>OTHERS</term>
 *     <listitem><para>the query is forwarded to all sink elements, the result
 *     of the first sink that answers the query successfully is returned. If no
 *     sink is in the bin, the query fails.</para></listitem>
 *   </varlistentry>
 * </variablelist>
 *
 * A #GstBin will by default forward any event sent to it to all sink elements.
 * If all the sinks return %TRUE, the bin will also return %TRUE, else %FALSE is
 * returned. If no sinks are in the bin, the event handler will return %TRUE.
 *
 * </para>
 * </refsect2>
 */

#include "gst_private.h"

#include "gstevent.h"
#include "gstbin.h"
#include "gstinfo.h"
#include "gsterror.h"

#include "gstutils.h"
#include "gstchildproxy.h"

GST_DEBUG_CATEGORY_STATIC (bin_debug);
#define GST_CAT_DEFAULT bin_debug

/* a bin is toplevel if it has no parent or when it is configured to behave like
 * a toplevel bin */
#define BIN_IS_TOPLEVEL(bin) ((GST_OBJECT_PARENT (bin) == NULL) || bin->priv->asynchandling)

#define GST_BIN_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BIN, GstBinPrivate))

struct _GstBinPrivate
{
  gboolean asynchandling;
  /* if we get an ASYNC_DONE message from ourselves, this means that the
   * subclass will simulate ASYNC behaviour without having ASYNC children. When
   * such an ASYNC_DONE message is posted while we are doing a state change, we
   * have to process the message after finishing the state change even when no
   * child returned GST_STATE_CHANGE_ASYNC. */
  gboolean pending_async_done;

  guint32 structure_cookie;

#if 0
  /* cached index */
  GstIndex *index;
#endif

  /* forward messages from our children */
  gboolean message_forward;

  gboolean posted_eos;
  gboolean posted_playing;

  GList *contexts;
};

typedef struct
{
  GstBin *bin;
  guint32 cookie;
  GstState pending;
} BinContinueData;

static void gst_bin_dispose (GObject * object);

static void gst_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_bin_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static GstStateChangeReturn gst_bin_change_state_func (GstElement * element,
    GstStateChange transition);
static gboolean gst_bin_post_message (GstElement * element, GstMessage * msg);
static GstStateChangeReturn gst_bin_get_state_func (GstElement * element,
    GstState * state, GstState * pending, GstClockTime timeout);
static void bin_handle_async_done (GstBin * bin, GstStateChangeReturn ret,
    gboolean flag_pending, GstClockTime running_time);
static void bin_handle_async_start (GstBin * bin);
static void bin_push_state_continue (BinContinueData * data);
static void bin_do_eos (GstBin * bin);

static gboolean gst_bin_add_func (GstBin * bin, GstElement * element);
static gboolean gst_bin_remove_func (GstBin * bin, GstElement * element);

#if 0
static void gst_bin_set_index_func (GstElement * element, GstIndex * index);
static GstIndex *gst_bin_get_index_func (GstElement * element);
#endif

static GstClock *gst_bin_provide_clock_func (GstElement * element);
static gboolean gst_bin_set_clock_func (GstElement * element, GstClock * clock);

static void gst_bin_handle_message_func (GstBin * bin, GstMessage * message);
static gboolean gst_bin_send_event (GstElement * element, GstEvent * event);
static GstBusSyncReply bin_bus_handler (GstBus * bus,
    GstMessage * message, GstBin * bin);
static gboolean gst_bin_query (GstElement * element, GstQuery * query);
static void gst_bin_set_context (GstElement * element, GstContext * context);

static gboolean gst_bin_do_latency_func (GstBin * bin);

static void bin_remove_messages (GstBin * bin, GstObject * src,
    GstMessageType types);
static void gst_bin_continue_func (BinContinueData * data);
static gint bin_element_is_sink (GstElement * child, GstBin * bin);
static gint bin_element_is_src (GstElement * child, GstBin * bin);

static GstIterator *gst_bin_sort_iterator_new (GstBin * bin);

/* Bin signals and properties */
enum
{
  ELEMENT_ADDED,
  ELEMENT_REMOVED,
  DO_LATENCY,
  LAST_SIGNAL
};

#define DEFAULT_ASYNC_HANDLING	FALSE
#define DEFAULT_MESSAGE_FORWARD	FALSE

enum
{
  PROP_0,
  PROP_ASYNC_HANDLING,
  PROP_MESSAGE_FORWARD,
  PROP_LAST
};

static void gst_bin_child_proxy_init (gpointer g_iface, gpointer iface_data);

static guint gst_bin_signals[LAST_SIGNAL] = { 0 };

#define _do_init \
{ \
  static const GInterfaceInfo iface_info = { \
    gst_bin_child_proxy_init, \
    NULL, \
    NULL}; \
  \
  g_type_add_interface_static (g_define_type_id, GST_TYPE_CHILD_PROXY, &iface_info); \
  \
  GST_DEBUG_CATEGORY_INIT (bin_debug, "bin", GST_DEBUG_BOLD, \
      "debugging info for the 'bin' container element"); \
  \
}

#define gst_bin_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstBin, gst_bin, GST_TYPE_ELEMENT, _do_init);

static GObject *
gst_bin_child_proxy_get_child_by_index (GstChildProxy * child_proxy,
    guint index)
{
  GstObject *res;
  GstBin *bin;

  bin = GST_BIN_CAST (child_proxy);

  GST_OBJECT_LOCK (bin);
  if ((res = g_list_nth_data (bin->children, index)))
    gst_object_ref (res);
  GST_OBJECT_UNLOCK (bin);

  return (GObject *) res;
}

static guint
gst_bin_child_proxy_get_children_count (GstChildProxy * child_proxy)
{
  guint num;
  GstBin *bin;

  bin = GST_BIN_CAST (child_proxy);

  GST_OBJECT_LOCK (bin);
  num = bin->numchildren;
  GST_OBJECT_UNLOCK (bin);

  return num;
}

static void
gst_bin_child_proxy_init (gpointer g_iface, gpointer iface_data)
{
  GstChildProxyInterface *iface = g_iface;

  iface->get_children_count = gst_bin_child_proxy_get_children_count;
  iface->get_child_by_index = gst_bin_child_proxy_get_child_by_index;
}

static gboolean
_gst_boolean_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  gboolean myboolean;

  myboolean = g_value_get_boolean (handler_return);
  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_boolean (return_accu, myboolean);

  GST_DEBUG ("invocation %d, %d", ihint->run_type, myboolean);

  /* stop emission */
  return FALSE;
}

static void
gst_bin_class_init (GstBinClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GError *err;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;

  g_type_class_add_private (klass, sizeof (GstBinPrivate));

  gobject_class->set_property = gst_bin_set_property;
  gobject_class->get_property = gst_bin_get_property;

  /**
   * GstBin:async-handling:
   *
   * If set to %TRUE, the bin will handle asynchronous state changes.
   * This should be used only if the bin subclass is modifying the state
   * of its children on its own.
   */
  g_object_class_install_property (gobject_class, PROP_ASYNC_HANDLING,
      g_param_spec_boolean ("async-handling", "Async Handling",
          "The bin will handle Asynchronous state changes",
          DEFAULT_ASYNC_HANDLING, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstBin::element-added:
   * @bin: the #GstBin
   * @element: the #GstElement that was added to the bin
   *
   * Will be emitted after the element was added to the bin.
   */
  gst_bin_signals[ELEMENT_ADDED] =
      g_signal_new ("element-added", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_FIRST, G_STRUCT_OFFSET (GstBinClass, element_added), NULL,
      NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_ELEMENT);
  /**
   * GstBin::element-removed:
   * @bin: the #GstBin
   * @element: the #GstElement that was removed from the bin
   *
   * Will be emitted after the element was removed from the bin.
   */
  gst_bin_signals[ELEMENT_REMOVED] =
      g_signal_new ("element-removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_FIRST, G_STRUCT_OFFSET (GstBinClass, element_removed), NULL,
      NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_ELEMENT);
  /**
   * GstBin::do-latency:
   * @bin: the #GstBin
   *
   * Will be emitted when the bin needs to perform latency calculations. This
   * signal is only emitted for toplevel bins or when async-handling is
   * enabled.
   *
   * Only one signal handler is invoked. If no signals are connected, the
   * default handler is invoked, which will query and distribute the lowest
   * possible latency to all sinks.
   *
   * Connect to this signal if the default latency calculations are not
   * sufficient, like when you need different latencies for different sinks in
   * the same pipeline.
   */
  gst_bin_signals[DO_LATENCY] =
      g_signal_new ("do-latency", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstBinClass, do_latency),
      _gst_boolean_accumulator, NULL, g_cclosure_marshal_generic,
      G_TYPE_BOOLEAN, 0, G_TYPE_NONE);

  /**
   * GstBin:message-forward:
   *
   * Forward all children messages, even those that would normally be filtered by
   * the bin. This can be interesting when one wants to be notified of the EOS
   * state of individual elements, for example.
   *
   * The messages are converted to an ELEMENT message with the bin as the
   * source. The structure of the message is named 'GstBinForwarded' and contains
   * a field named 'message' of type GST_TYPE_MESSAGE that contains the original
   * forwarded message.
   */
  g_object_class_install_property (gobject_class, PROP_MESSAGE_FORWARD,
      g_param_spec_boolean ("message-forward", "Message Forward",
          "Forwards all children messages",
          DEFAULT_MESSAGE_FORWARD, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gobject_class->dispose = gst_bin_dispose;

  gst_element_class_set_static_metadata (gstelement_class, "Generic bin",
      "Generic/Bin",
      "Simple container object",
      "Erik Walthinsen <omega@cse.ogi.edu>,"
      "Wim Taymans <wim.taymans@gmail.com>");

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_bin_change_state_func);
  gstelement_class->post_message = GST_DEBUG_FUNCPTR (gst_bin_post_message);
  gstelement_class->get_state = GST_DEBUG_FUNCPTR (gst_bin_get_state_func);
#if 0
  gstelement_class->get_index = GST_DEBUG_FUNCPTR (gst_bin_get_index_func);
  gstelement_class->set_index = GST_DEBUG_FUNCPTR (gst_bin_set_index_func);
#endif
  gstelement_class->provide_clock =
      GST_DEBUG_FUNCPTR (gst_bin_provide_clock_func);
  gstelement_class->set_clock = GST_DEBUG_FUNCPTR (gst_bin_set_clock_func);

  gstelement_class->send_event = GST_DEBUG_FUNCPTR (gst_bin_send_event);
  gstelement_class->query = GST_DEBUG_FUNCPTR (gst_bin_query);
  gstelement_class->set_context = GST_DEBUG_FUNCPTR (gst_bin_set_context);

  klass->add_element = GST_DEBUG_FUNCPTR (gst_bin_add_func);
  klass->remove_element = GST_DEBUG_FUNCPTR (gst_bin_remove_func);
  klass->handle_message = GST_DEBUG_FUNCPTR (gst_bin_handle_message_func);

  klass->do_latency = GST_DEBUG_FUNCPTR (gst_bin_do_latency_func);

  GST_DEBUG ("creating bin thread pool");
  err = NULL;
  klass->pool =
      g_thread_pool_new ((GFunc) gst_bin_continue_func, NULL, -1, FALSE, &err);
  if (err != NULL) {
    g_critical ("could alloc threadpool %s", err->message);
  }
}

static void
gst_bin_init (GstBin * bin)
{
  GstBus *bus;

  bin->numchildren = 0;
  bin->children = NULL;
  bin->children_cookie = 0;
  bin->messages = NULL;
  bin->provided_clock = NULL;
  bin->clock_dirty = FALSE;

  /* Set up a bus for listening to child elements */
  bus = g_object_new (GST_TYPE_BUS, "enable-async", FALSE, NULL);
  bin->child_bus = bus;
  GST_DEBUG_OBJECT (bin, "using bus %" GST_PTR_FORMAT " to listen to children",
      bus);
  gst_bus_set_sync_handler (bus, (GstBusSyncHandler) bin_bus_handler, bin,
      NULL);

  bin->priv = GST_BIN_GET_PRIVATE (bin);
  bin->priv->asynchandling = DEFAULT_ASYNC_HANDLING;
  bin->priv->structure_cookie = 0;
  bin->priv->message_forward = DEFAULT_MESSAGE_FORWARD;
}

static void
gst_bin_dispose (GObject * object)
{
  GstBin *bin = GST_BIN_CAST (object);
  GstBus **child_bus_p = &bin->child_bus;
  GstClock **provided_clock_p = &bin->provided_clock;
  GstElement **clock_provider_p = &bin->clock_provider;

  GST_CAT_DEBUG_OBJECT (GST_CAT_REFCOUNTING, object, "dispose");

  GST_OBJECT_LOCK (object);
  gst_object_replace ((GstObject **) child_bus_p, NULL);
  gst_object_replace ((GstObject **) provided_clock_p, NULL);
  gst_object_replace ((GstObject **) clock_provider_p, NULL);
  bin_remove_messages (bin, NULL, GST_MESSAGE_ANY);
  GST_OBJECT_UNLOCK (object);

  while (bin->children) {
    gst_bin_remove (bin, GST_ELEMENT_CAST (bin->children->data));
  }
  if (G_UNLIKELY (bin->children != NULL)) {
    g_critical ("could not remove elements from bin '%s'",
        GST_STR_NULL (GST_OBJECT_NAME (object)));
  }

  g_list_free_full (bin->priv->contexts, (GDestroyNotify) gst_context_unref);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

/**
 * gst_bin_new:
 * @name: (allow-none): the name of the new bin
 *
 * Creates a new bin with the given name.
 *
 * Returns: (transfer floating): a new #GstBin
 */
GstElement *
gst_bin_new (const gchar * name)
{
  return gst_element_factory_make ("bin", name);
}

static void
gst_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstBin *gstbin;

  gstbin = GST_BIN_CAST (object);

  switch (prop_id) {
    case PROP_ASYNC_HANDLING:
      GST_OBJECT_LOCK (gstbin);
      gstbin->priv->asynchandling = g_value_get_boolean (value);
      GST_OBJECT_UNLOCK (gstbin);
      break;
    case PROP_MESSAGE_FORWARD:
      GST_OBJECT_LOCK (gstbin);
      gstbin->priv->message_forward = g_value_get_boolean (value);
      GST_OBJECT_UNLOCK (gstbin);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_bin_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstBin *gstbin;

  gstbin = GST_BIN_CAST (object);

  switch (prop_id) {
    case PROP_ASYNC_HANDLING:
      GST_OBJECT_LOCK (gstbin);
      g_value_set_boolean (value, gstbin->priv->asynchandling);
      GST_OBJECT_UNLOCK (gstbin);
      break;
    case PROP_MESSAGE_FORWARD:
      GST_OBJECT_LOCK (gstbin);
      g_value_set_boolean (value, gstbin->priv->message_forward);
      GST_OBJECT_UNLOCK (gstbin);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

#if 0
/* return the cached index */
static GstIndex *
gst_bin_get_index_func (GstElement * element)
{
  GstBin *bin;
  GstIndex *result;

  bin = GST_BIN_CAST (element);

  GST_OBJECT_LOCK (bin);
  if ((result = bin->priv->index))
    gst_object_ref (result);
  GST_OBJECT_UNLOCK (bin);

  return result;
}

/* set the index on all elements in this bin
 *
 * MT safe
 */
static void
gst_bin_set_index_func (GstElement * element, GstIndex * index)
{
  GstBin *bin;
  gboolean done;
  GstIterator *it;
  GstIndex *old;
  GValue data = { 0, };

  bin = GST_BIN_CAST (element);

  GST_OBJECT_LOCK (bin);
  old = bin->priv->index;
  if (G_UNLIKELY (old == index))
    goto was_set;
  if (index)
    gst_object_ref (index);
  bin->priv->index = index;
  GST_OBJECT_UNLOCK (bin);

  if (old)
    gst_object_unref (old);

  it = gst_bin_iterate_elements (bin);

  /* set the index on all elements in the bin */
  done = FALSE;
  while (!done) {
    switch (gst_iterator_next (it, &data)) {
      case GST_ITERATOR_OK:
      {
        GstElement *child = g_value_get_object (&data);

        GST_DEBUG_OBJECT (bin, "setting index on '%s'",
            GST_ELEMENT_NAME (child));
        gst_element_set_index (child, index);

        g_value_reset (&data);
        break;
      }
      case GST_ITERATOR_RESYNC:
        GST_DEBUG_OBJECT (bin, "iterator doing resync");
        gst_iterator_resync (it);
        break;
      default:
      case GST_ITERATOR_DONE:
        GST_DEBUG_OBJECT (bin, "iterator done");
        done = TRUE;
        break;
    }
  }
  g_value_unset (&data);
  gst_iterator_free (it);
  return;

was_set:
  {
    GST_DEBUG_OBJECT (bin, "index was already set");
    GST_OBJECT_UNLOCK (bin);
    return;
  }
}
#endif

/* set the clock on all elements in this bin
 *
 * MT safe
 */
static gboolean
gst_bin_set_clock_func (GstElement * element, GstClock * clock)
{
  GstBin *bin;
  gboolean done;
  GstIterator *it;
  gboolean res = TRUE;
  GValue data = { 0, };

  bin = GST_BIN_CAST (element);

  it = gst_bin_iterate_elements (bin);

  done = FALSE;
  while (!done) {
    switch (gst_iterator_next (it, &data)) {
      case GST_ITERATOR_OK:
      {
        GstElement *child = g_value_get_object (&data);

        res &= gst_element_set_clock (child, clock);

        g_value_reset (&data);
        break;
      }
      case GST_ITERATOR_RESYNC:
        GST_DEBUG_OBJECT (bin, "iterator doing resync");
        gst_iterator_resync (it);
        res = TRUE;
        break;
      default:
      case GST_ITERATOR_DONE:
        GST_DEBUG_OBJECT (bin, "iterator done");
        done = TRUE;
        break;
    }
  }
  g_value_unset (&data);
  gst_iterator_free (it);

  if (res)
    res = GST_ELEMENT_CLASS (parent_class)->set_clock (element, clock);

  return res;
}

/* get the clock for this bin by asking all of the children in this bin
 *
 * The ref of the returned clock in increased so unref after usage.
 *
 * We loop the elements in state order and pick the last clock we can
 * get. This makes sure we get a clock from the source.
 *
 * MT safe
 */
static GstClock *
gst_bin_provide_clock_func (GstElement * element)
{
  GstClock *result = NULL;
  GstElement *provider = NULL;
  GstBin *bin;
  GstIterator *it;
  gboolean done;
  GValue val = { 0, };
  GstClock **provided_clock_p;
  GstElement **clock_provider_p;

  bin = GST_BIN_CAST (element);

  GST_OBJECT_LOCK (bin);
  if (!bin->clock_dirty)
    goto not_dirty;

  GST_DEBUG_OBJECT (bin, "finding new clock");

  it = gst_bin_sort_iterator_new (bin);
  GST_OBJECT_UNLOCK (bin);

  done = FALSE;
  while (!done) {
    switch (gst_iterator_next (it, &val)) {
      case GST_ITERATOR_OK:
      {
        GstElement *child = g_value_get_object (&val);
        GstClock *clock;

        clock = gst_element_provide_clock (child);
        if (clock) {
          GST_DEBUG_OBJECT (bin, "found candidate clock %p by element %s",
              clock, GST_ELEMENT_NAME (child));
          if (result) {
            gst_object_unref (result);
            gst_object_unref (provider);
          }
          result = clock;
          provider = gst_object_ref (child);
        }

        g_value_reset (&val);
        break;
      }
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (it);
        break;
      default:
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
    }
  }
  g_value_unset (&val);
  gst_iterator_free (it);

  GST_OBJECT_LOCK (bin);
  if (!bin->clock_dirty) {
    if (provider)
      gst_object_unref (provider);
    if (result)
      gst_object_unref (result);
    result = NULL;

    goto not_dirty;
  }

  provided_clock_p = &bin->provided_clock;
  clock_provider_p = &bin->clock_provider;
  gst_object_replace ((GstObject **) provided_clock_p, (GstObject *) result);
  gst_object_replace ((GstObject **) clock_provider_p, (GstObject *) provider);
  bin->clock_dirty = FALSE;
  GST_DEBUG_OBJECT (bin,
      "provided new clock %" GST_PTR_FORMAT " by provider %" GST_PTR_FORMAT,
      result, provider);
  /* Provider is not being returned to caller, just the result */
  if (provider)
    gst_object_unref (provider);
  GST_OBJECT_UNLOCK (bin);

  return result;

not_dirty:
  {
    if ((result = bin->provided_clock))
      gst_object_ref (result);
    GST_DEBUG_OBJECT (bin, "returning old clock %p", result);
    GST_OBJECT_UNLOCK (bin);

    return result;
  }
}

/*
 * functions for manipulating cached messages
 */
typedef struct
{
  GstObject *src;
  GstMessageType types;
} MessageFind;

/* check if a message is of given src and type */
static gint
message_check (GstMessage * message, MessageFind * target)
{
  gboolean eq = TRUE;

  if (target->src)
    eq &= GST_MESSAGE_SRC (message) == target->src;
  if (target->types)
    eq &= (GST_MESSAGE_TYPE (message) & target->types) != 0;
  GST_LOG ("looking at message %p: %d", message, eq);

  return (eq ? 0 : 1);
}

static GList *
find_message (GstBin * bin, GstObject * src, GstMessageType types)
{
  GList *result;
  MessageFind find;

  find.src = src;
  find.types = types;

  result = g_list_find_custom (bin->messages, &find,
      (GCompareFunc) message_check);

  if (result) {
    GST_DEBUG_OBJECT (bin, "we found a message %p from %s matching types %08x",
        result->data, GST_OBJECT_NAME (GST_MESSAGE_CAST (result->data)->src),
        types);
  } else {
    GST_DEBUG_OBJECT (bin, "no message found matching types %08x", types);
#ifndef GST_DISABLE_GST_DEBUG
    {
      guint i;

      for (i = 0; i < 32; i++)
        if (types & (1U << i))
          GST_DEBUG_OBJECT (bin, "  %s", gst_message_type_get_name (1U << i));
    }
#endif
  }

  return result;
}

/* with LOCK, returns TRUE if message had a valid SRC, takes ownership of
 * the message.
 *
 * A message that is cached and has the same SRC and type is replaced
 * by the given message.
 */
static gboolean
bin_replace_message (GstBin * bin, GstMessage * message, GstMessageType types)
{
  GList *previous;
  GstObject *src;
  gboolean res = TRUE;

  if ((src = GST_MESSAGE_SRC (message))) {
    /* first find the previous message posted by this element */
    if ((previous = find_message (bin, src, types))) {
      GstMessage *previous_msg;

      /* if we found a previous message, replace it */
      previous_msg = previous->data;
      previous->data = message;

      GST_DEBUG_OBJECT (bin, "replace old message %s from %s with %s message",
          GST_MESSAGE_TYPE_NAME (previous_msg), GST_ELEMENT_NAME (src),
          GST_MESSAGE_TYPE_NAME (message));

      gst_message_unref (previous_msg);
    } else {
      /* keep new message */
      bin->messages = g_list_prepend (bin->messages, message);

      GST_DEBUG_OBJECT (bin, "got new message %p, %s from %s",
          message, GST_MESSAGE_TYPE_NAME (message), GST_ELEMENT_NAME (src));
    }
  } else {
    GST_DEBUG_OBJECT (bin, "got message %s from (NULL), not processing",
        GST_MESSAGE_TYPE_NAME (message));
    res = FALSE;
    gst_message_unref (message);
  }
  return res;
}

/* with LOCK. Remove all messages of given types */
static void
bin_remove_messages (GstBin * bin, GstObject * src, GstMessageType types)
{
  MessageFind find;
  GList *walk, *next;

  find.src = src;
  find.types = types;

  for (walk = bin->messages; walk; walk = next) {
    GstMessage *message = (GstMessage *) walk->data;

    next = g_list_next (walk);

    if (message_check (message, &find) == 0) {
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (message),
          "deleting message %p of types 0x%08x", message, types);
      bin->messages = g_list_delete_link (bin->messages, walk);
      gst_message_unref (message);
    } else {
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (message),
          "not deleting message %p of type 0x%08x", message,
          GST_MESSAGE_TYPE (message));
    }
  }
}


/* Check if the bin is EOS. We do this by scanning all sinks and
 * checking if they posted an EOS message.
 *
 * call with bin LOCK */
static gboolean
is_eos (GstBin * bin, guint32 * seqnum)
{
  gboolean result;
  gint n_eos = 0;
  GList *walk, *msgs;

  result = TRUE;
  for (walk = bin->children; walk; walk = g_list_next (walk)) {
    GstElement *element;

    element = GST_ELEMENT_CAST (walk->data);
    if (bin_element_is_sink (element, bin) == 0) {
      /* check if element posted EOS */
      if ((msgs =
              find_message (bin, GST_OBJECT_CAST (element), GST_MESSAGE_EOS))) {
        GST_DEBUG ("sink '%s' posted EOS", GST_ELEMENT_NAME (element));
        *seqnum = gst_message_get_seqnum (GST_MESSAGE_CAST (msgs->data));
        n_eos++;
      } else {
        GST_DEBUG ("sink '%s' did not post EOS yet",
            GST_ELEMENT_NAME (element));
        result = FALSE;
        break;
      }
    }
  }
  /* FIXME: Some tests (e.g. elements/capsfilter) use
   * pipelines with a dangling sinkpad but no sink element.
   * These tests assume that no EOS message is ever
   * posted on the bus so let's keep that behaviour.
   * In valid pipelines this doesn't make a difference.
   */
  return result && n_eos > 0;
}


/* Check if the bin is STREAM_START. We do this by scanning all sinks and
 * checking if they posted an STREAM_START message.
 *
 * call with bin LOCK */
static gboolean
is_stream_start (GstBin * bin, guint32 * seqnum, gboolean * have_group_id,
    guint * group_id)
{
  gboolean result;
  GList *walk, *msgs;
  guint tmp_group_id;
  gboolean first = TRUE, same_group_id = TRUE;

  *have_group_id = TRUE;
  *group_id = 0;
  result = TRUE;
  for (walk = bin->children; walk; walk = g_list_next (walk)) {
    GstElement *element;

    element = GST_ELEMENT_CAST (walk->data);
    if (bin_element_is_sink (element, bin) == 0) {
      /* check if element posted STREAM_START */
      if ((msgs =
              find_message (bin, GST_OBJECT_CAST (element),
                  GST_MESSAGE_STREAM_START))) {
        GST_DEBUG ("sink '%s' posted STREAM_START", GST_ELEMENT_NAME (element));
        *seqnum = gst_message_get_seqnum (GST_MESSAGE_CAST (msgs->data));
        if (gst_message_parse_group_id (GST_MESSAGE_CAST (msgs->data),
                &tmp_group_id)) {
          if (first) {
            first = FALSE;
            *group_id = tmp_group_id;
          } else {
            if (tmp_group_id != *group_id)
              same_group_id = FALSE;
          }
        } else {
          *have_group_id = FALSE;
        }
      } else {
        GST_DEBUG ("sink '%s' did not post STREAM_START yet",
            GST_ELEMENT_NAME (element));
        result = FALSE;
        break;
      }
    }
  }

  /* If all have a group_id we only consider this stream started
   * if all group ids were the same and all sinks posted a stream-start
   * message */
  if (*have_group_id)
    return same_group_id && result;
  /* otherwise consider this stream started after all sinks
   * have reported stream-start for backward compatibility.
   * FIXME 2.0: This should go away! */
  return result;
}

static void
unlink_pads (const GValue * item, gpointer user_data)
{
  GstPad *pad;
  GstPad *peer;

  pad = g_value_get_object (item);

  if ((peer = gst_pad_get_peer (pad))) {
    if (gst_pad_get_direction (pad) == GST_PAD_SRC)
      gst_pad_unlink (pad, peer);
    else
      gst_pad_unlink (peer, pad);
    gst_object_unref (peer);
  }
}

/* vmethod that adds an element to a bin
 *
 * MT safe
 */
static gboolean
gst_bin_add_func (GstBin * bin, GstElement * element)
{
  gchar *elem_name;
  GstIterator *it;
  gboolean is_sink, is_source, provides_clock, requires_clock;
  GstMessage *clock_message = NULL, *async_message = NULL;
  GstStateChangeReturn ret;
  GList *l;

  GST_DEBUG_OBJECT (bin, "element :%s", GST_ELEMENT_NAME (element));

  /* we obviously can't add ourself to ourself */
  if (G_UNLIKELY (element == GST_ELEMENT_CAST (bin)))
    goto adding_itself;

  /* get the element name to make sure it is unique in this bin. */
  GST_OBJECT_LOCK (element);
  elem_name = g_strdup (GST_ELEMENT_NAME (element));
  is_sink = GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_SINK);
  is_source = GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_SOURCE);
  provides_clock =
      GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  requires_clock =
      GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_REQUIRE_CLOCK);
  GST_OBJECT_UNLOCK (element);

  GST_OBJECT_LOCK (bin);

  /* then check to see if the element's name is already taken in the bin,
   * we can safely take the lock here. This check is probably bogus because
   * you can safely change the element name after this check and before setting
   * the object parent. The window is very small though... */
  if (G_UNLIKELY (!gst_object_check_uniqueness (bin->children, elem_name)))
    goto duplicate_name;

  /* set the element's parent and add the element to the bin's list of children */
  if (G_UNLIKELY (!gst_object_set_parent (GST_OBJECT_CAST (element),
              GST_OBJECT_CAST (bin))))
    goto had_parent;

  /* if we add a sink we become a sink */
  if (is_sink) {
    GST_CAT_DEBUG_OBJECT (GST_CAT_PARENTAGE, bin, "element \"%s\" was sink",
        elem_name);
    GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_SINK);
  }
  if (is_source) {
    GST_CAT_DEBUG_OBJECT (GST_CAT_PARENTAGE, bin, "element \"%s\" was source",
        elem_name);
    GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_SOURCE);
  }
  if (provides_clock) {
    GST_DEBUG_OBJECT (bin, "element \"%s\" can provide a clock", elem_name);
    clock_message =
        gst_message_new_clock_provide (GST_OBJECT_CAST (element), NULL, TRUE);
    GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  }
  if (requires_clock) {
    GST_DEBUG_OBJECT (bin, "element \"%s\" requires a clock", elem_name);
    GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_REQUIRE_CLOCK);
  }

  bin->children = g_list_prepend (bin->children, element);
  bin->numchildren++;
  bin->children_cookie++;
  if (!GST_BIN_IS_NO_RESYNC (bin))
    bin->priv->structure_cookie++;

  /* distribute the bus */
  gst_element_set_bus (element, bin->child_bus);

  /* propagate the current base_time, start_time and clock */
  gst_element_set_base_time (element, GST_ELEMENT_CAST (bin)->base_time);
  gst_element_set_start_time (element, GST_ELEMENT_START_TIME (bin));
  /* it's possible that the element did not accept the clock but
   * that is not important right now. When the pipeline goes to PLAYING,
   * a new clock will be selected */
  gst_element_set_clock (element, GST_ELEMENT_CLOCK (bin));

  for (l = bin->priv->contexts; l; l = l->next)
    gst_element_set_context (element, l->data);

#if 0
  /* set the cached index on the children */
  if (bin->priv->index)
    gst_element_set_index (element, bin->priv->index);
#endif

  ret = GST_STATE_RETURN (bin);
  /* no need to update the state if we are in error */
  if (ret == GST_STATE_CHANGE_FAILURE)
    goto no_state_recalc;

  /* update the bin state, the new element could have been an ASYNC or
   * NO_PREROLL element */
  ret = GST_STATE_RETURN (element);
  GST_DEBUG_OBJECT (bin, "added %s element",
      gst_element_state_change_return_get_name (ret));

  switch (ret) {
    case GST_STATE_CHANGE_ASYNC:
    {
      /* create message to track this aync element when it posts an async-done
       * message */
      async_message = gst_message_new_async_start (GST_OBJECT_CAST (element));
      break;
    }
    case GST_STATE_CHANGE_NO_PREROLL:
      /* ignore all async elements we might have and commit our state */
      bin_handle_async_done (bin, ret, FALSE, GST_CLOCK_TIME_NONE);
      break;
    case GST_STATE_CHANGE_FAILURE:
      break;
    default:
      break;
  }

no_state_recalc:
  GST_OBJECT_UNLOCK (bin);

  /* post the messages on the bus of the element so that the bin can handle
   * them */
  if (clock_message)
    gst_element_post_message (element, clock_message);

  if (async_message)
    gst_element_post_message (element, async_message);

  /* unlink all linked pads */
  it = gst_element_iterate_pads (element);
  gst_iterator_foreach (it, (GstIteratorForeachFunction) unlink_pads, NULL);
  gst_iterator_free (it);

  GST_CAT_DEBUG_OBJECT (GST_CAT_PARENTAGE, bin, "added element \"%s\"",
      elem_name);

  g_signal_emit (bin, gst_bin_signals[ELEMENT_ADDED], 0, element);
  gst_child_proxy_child_added ((GstChildProxy *) bin, (GObject *) element,
      elem_name);

  g_free (elem_name);

  return TRUE;

  /* ERROR handling here */
adding_itself:
  {
    GST_OBJECT_LOCK (bin);
    g_warning ("Cannot add bin '%s' to itself", GST_ELEMENT_NAME (bin));
    GST_OBJECT_UNLOCK (bin);
    return FALSE;
  }
duplicate_name:
  {
    g_warning ("Name '%s' is not unique in bin '%s', not adding",
        elem_name, GST_ELEMENT_NAME (bin));
    GST_OBJECT_UNLOCK (bin);
    g_free (elem_name);
    return FALSE;
  }
had_parent:
  {
    g_warning ("Element '%s' already has parent", elem_name);
    GST_OBJECT_UNLOCK (bin);
    g_free (elem_name);
    return FALSE;
  }
}

/**
 * gst_bin_add:
 * @bin: a #GstBin
 * @element: (transfer full): the #GstElement to add
 *
 * Adds the given element to the bin.  Sets the element's parent, and thus
 * takes ownership of the element. An element can only be added to one bin.
 *
 * If the element's pads are linked to other pads, the pads will be unlinked
 * before the element is added to the bin.
 *
 * <note>
 * When you add an element to an already-running pipeline, you will have to
 * take care to set the state of the newly-added element to the desired
 * state (usually PLAYING or PAUSED, same you set the pipeline to originally)
 * with gst_element_set_state(), or use gst_element_sync_state_with_parent().
 * The bin or pipeline will not take care of this for you.
 * </note>
 *
 * MT safe.
 *
 * Returns: %TRUE if the element could be added, %FALSE if
 * the bin does not want to accept the element.
 */
gboolean
gst_bin_add (GstBin * bin, GstElement * element)
{
  GstBinClass *bclass;
  gboolean result;

  g_return_val_if_fail (GST_IS_BIN (bin), FALSE);
  g_return_val_if_fail (GST_IS_ELEMENT (element), FALSE);

  bclass = GST_BIN_GET_CLASS (bin);

  if (G_UNLIKELY (bclass->add_element == NULL))
    goto no_function;

  GST_CAT_DEBUG (GST_CAT_PARENTAGE, "adding element %s to bin %s",
      GST_STR_NULL (GST_ELEMENT_NAME (element)),
      GST_STR_NULL (GST_ELEMENT_NAME (bin)));

  result = bclass->add_element (bin, element);

  return result;

  /* ERROR handling */
no_function:
  {
    g_warning ("adding elements to bin '%s' is not supported",
        GST_ELEMENT_NAME (bin));
    return FALSE;
  }
}

/* remove an element from the bin
 *
 * MT safe
 */
static gboolean
gst_bin_remove_func (GstBin * bin, GstElement * element)
{
  gchar *elem_name;
  GstIterator *it;
  gboolean is_sink, is_source, provides_clock, requires_clock;
  gboolean othersink, othersource, otherprovider, otherrequirer, found;
  GstMessage *clock_message = NULL;
  GstClock **provided_clock_p;
  GstElement **clock_provider_p;
  GList *walk, *next;
  gboolean other_async, this_async, have_no_preroll;
  GstStateChangeReturn ret;

  GST_DEBUG_OBJECT (bin, "element :%s", GST_ELEMENT_NAME (element));

  GST_OBJECT_LOCK (bin);

  GST_OBJECT_LOCK (element);
  elem_name = g_strdup (GST_ELEMENT_NAME (element));

  if (GST_OBJECT_PARENT (element) != GST_OBJECT_CAST (bin))
    goto not_in_bin;

  /* remove the parent ref */
  GST_OBJECT_PARENT (element) = NULL;

  /* grab element name so we can print it */
  is_sink = GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_SINK);
  is_source = GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_SOURCE);
  provides_clock =
      GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  requires_clock =
      GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_REQUIRE_CLOCK);
  GST_OBJECT_UNLOCK (element);

  found = FALSE;
  othersink = FALSE;
  othersource = FALSE;
  otherprovider = FALSE;
  otherrequirer = FALSE;
  have_no_preroll = FALSE;
  /* iterate the elements, we collect which ones are async and no_preroll. We
   * also remove the element when we find it. */
  for (walk = bin->children; walk; walk = next) {
    GstElement *child = GST_ELEMENT_CAST (walk->data);

    next = g_list_next (walk);

    if (child == element) {
      found = TRUE;
      /* remove the element */
      bin->children = g_list_delete_link (bin->children, walk);
    } else {
      gboolean child_sink, child_source, child_provider, child_requirer;

      GST_OBJECT_LOCK (child);
      child_sink = GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_SINK);
      child_source = GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_SOURCE);
      child_provider =
          GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
      child_requirer =
          GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_REQUIRE_CLOCK);
      /* when we remove a sink, check if there are other sinks. */
      if (is_sink && !othersink && child_sink)
        othersink = TRUE;
      if (is_source && !othersource && child_source)
        othersource = TRUE;
      if (provides_clock && !otherprovider && child_provider)
        otherprovider = TRUE;
      if (requires_clock && !otherrequirer && child_requirer)
        otherrequirer = TRUE;
      /* check if we have NO_PREROLL children */
      if (GST_STATE_RETURN (child) == GST_STATE_CHANGE_NO_PREROLL)
        have_no_preroll = TRUE;
      GST_OBJECT_UNLOCK (child);
    }
  }

  /* the element must have been in the bin's list of children */
  if (G_UNLIKELY (!found))
    goto not_in_bin;

  /* we now removed the element from the list of elements, increment the cookie
   * so that others can detect a change in the children list. */
  bin->numchildren--;
  bin->children_cookie++;
  if (!GST_BIN_IS_NO_RESYNC (bin))
    bin->priv->structure_cookie++;

  if (is_sink && !othersink) {
    /* we're not a sink anymore */
    GST_DEBUG_OBJECT (bin, "we removed the last sink");
    GST_OBJECT_FLAG_UNSET (bin, GST_ELEMENT_FLAG_SINK);
  }
  if (is_source && !othersource) {
    /* we're not a source anymore */
    GST_DEBUG_OBJECT (bin, "we removed the last source");
    GST_OBJECT_FLAG_UNSET (bin, GST_ELEMENT_FLAG_SOURCE);
  }
  if (provides_clock && !otherprovider) {
    /* we're not a clock provider anymore */
    GST_DEBUG_OBJECT (bin, "we removed the last clock provider");
    GST_OBJECT_FLAG_UNSET (bin, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  }
  if (requires_clock && !otherrequirer) {
    /* we're not a clock requirer anymore */
    GST_DEBUG_OBJECT (bin, "we removed the last clock requirer");
    GST_OBJECT_FLAG_UNSET (bin, GST_ELEMENT_FLAG_REQUIRE_CLOCK);
  }

  /* if the clock provider for this element is removed, we lost
   * the clock as well, we need to inform the parent of this
   * so that it can select a new clock */
  if (bin->clock_provider == element) {
    GST_DEBUG_OBJECT (bin, "element \"%s\" provided the clock", elem_name);
    bin->clock_dirty = TRUE;
    clock_message =
        gst_message_new_clock_lost (GST_OBJECT_CAST (bin), bin->provided_clock);
    provided_clock_p = &bin->provided_clock;
    clock_provider_p = &bin->clock_provider;
    gst_object_replace ((GstObject **) provided_clock_p, NULL);
    gst_object_replace ((GstObject **) clock_provider_p, NULL);
  }

  /* remove messages for the element, if there was a pending ASYNC_START
   * message we must see if removing the element caused the bin to lose its
   * async state. */
  this_async = FALSE;
  other_async = FALSE;
  for (walk = bin->messages; walk; walk = next) {
    GstMessage *message = (GstMessage *) walk->data;
    GstElement *src = GST_ELEMENT_CAST (GST_MESSAGE_SRC (message));
    gboolean remove;

    next = g_list_next (walk);
    remove = FALSE;

    switch (GST_MESSAGE_TYPE (message)) {
      case GST_MESSAGE_ASYNC_START:
        if (src == element)
          this_async = TRUE;
        else
          other_async = TRUE;

        GST_DEBUG_OBJECT (src, "looking at message %p", message);
        break;
      case GST_MESSAGE_STRUCTURE_CHANGE:
      {
        GstElement *owner;

        GST_DEBUG_OBJECT (src, "looking at structure change message %p",
            message);
        /* it's unlikely that this message is still in the list of messages
         * because this would mean that a link/unlink is busy in another thread
         * while we remove the element. We still have to remove the message
         * because we might not receive the done message anymore when the element
         * is removed from the bin. */
        gst_message_parse_structure_change (message, NULL, &owner, NULL);
        if (owner == element)
          remove = TRUE;
        break;
      }
      default:
        break;
    }
    if (src == element)
      remove = TRUE;

    if (remove) {
      /* delete all message types */
      GST_DEBUG_OBJECT (src, "deleting message %p of element \"%s\"",
          message, elem_name);
      bin->messages = g_list_delete_link (bin->messages, walk);
      gst_message_unref (message);
    }
  }

  /* get last return */
  ret = GST_STATE_RETURN (bin);

  /* no need to update the state if we are in error */
  if (ret == GST_STATE_CHANGE_FAILURE)
    goto no_state_recalc;

  if (!other_async && this_async) {
    /* all other elements were not async and we removed the async one,
     * handle the async-done case because we are not async anymore now. */
    GST_DEBUG_OBJECT (bin,
        "we removed the last async element, have no_preroll %d",
        have_no_preroll);

    /* the current state return of the bin depends on if there are no_preroll
     * elements in the pipeline or not */
    if (have_no_preroll)
      ret = GST_STATE_CHANGE_NO_PREROLL;
    else
      ret = GST_STATE_CHANGE_SUCCESS;

    bin_handle_async_done (bin, ret, FALSE, GST_CLOCK_TIME_NONE);
  } else {
    GST_DEBUG_OBJECT (bin,
        "recalc state preroll: %d, other async: %d, this async %d",
        have_no_preroll, other_async, this_async);

    if (have_no_preroll) {
      ret = GST_STATE_CHANGE_NO_PREROLL;
    } else if (other_async) {
      /* there are other async elements and we were not doing an async state
       * change, change our pending state and go async */
      if (GST_STATE_PENDING (bin) == GST_STATE_VOID_PENDING) {
        GST_STATE_NEXT (bin) = GST_STATE (bin);
        GST_STATE_PENDING (bin) = GST_STATE (bin);
      }
      ret = GST_STATE_CHANGE_ASYNC;
    }
    GST_STATE_RETURN (bin) = ret;
  }
no_state_recalc:
  /* clear bus */
  gst_element_set_bus (element, NULL);
  /* Clear the clock we provided to the element */
  gst_element_set_clock (element, NULL);
  GST_OBJECT_UNLOCK (bin);

  if (clock_message)
    gst_element_post_message (GST_ELEMENT_CAST (bin), clock_message);

  /* unlink all linked pads */
  it = gst_element_iterate_pads (element);
  gst_iterator_foreach (it, (GstIteratorForeachFunction) unlink_pads, NULL);
  gst_iterator_free (it);

  GST_CAT_INFO_OBJECT (GST_CAT_PARENTAGE, bin, "removed child \"%s\"",
      elem_name);

  g_signal_emit (bin, gst_bin_signals[ELEMENT_REMOVED], 0, element);
  gst_child_proxy_child_removed ((GstChildProxy *) bin, (GObject *) element,
      elem_name);

  g_free (elem_name);
  /* element is really out of our control now */
  gst_object_unref (element);

  return TRUE;

  /* ERROR handling */
not_in_bin:
  {
    g_warning ("Element '%s' is not in bin '%s'", elem_name,
        GST_ELEMENT_NAME (bin));
    GST_OBJECT_UNLOCK (element);
    GST_OBJECT_UNLOCK (bin);
    g_free (elem_name);
    return FALSE;
  }
}

/**
 * gst_bin_remove:
 * @bin: a #GstBin
 * @element: (transfer none): the #GstElement to remove
 *
 * Removes the element from the bin, unparenting it as well.
 * Unparenting the element means that the element will be dereferenced,
 * so if the bin holds the only reference to the element, the element
 * will be freed in the process of removing it from the bin.  If you
 * want the element to still exist after removing, you need to call
 * gst_object_ref() before removing it from the bin.
 *
 * If the element's pads are linked to other pads, the pads will be unlinked
 * before the element is removed from the bin.
 *
 * MT safe.
 *
 * Returns: %TRUE if the element could be removed, %FALSE if
 * the bin does not want to remove the element.
 */
gboolean
gst_bin_remove (GstBin * bin, GstElement * element)
{
  GstBinClass *bclass;
  gboolean result;

  g_return_val_if_fail (GST_IS_BIN (bin), FALSE);
  g_return_val_if_fail (GST_IS_ELEMENT (element), FALSE);

  bclass = GST_BIN_GET_CLASS (bin);

  if (G_UNLIKELY (bclass->remove_element == NULL))
    goto no_function;

  GST_CAT_DEBUG (GST_CAT_PARENTAGE, "removing element %s from bin %s",
      GST_ELEMENT_NAME (element), GST_ELEMENT_NAME (bin));

  result = bclass->remove_element (bin, element);

  return result;

  /* ERROR handling */
no_function:
  {
    g_warning ("removing elements from bin '%s' is not supported",
        GST_ELEMENT_NAME (bin));
    return FALSE;
  }
}

/**
 * gst_bin_iterate_elements:
 * @bin: a #GstBin
 *
 * Gets an iterator for the elements in this bin.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement,
 * or %NULL
 */
GstIterator *
gst_bin_iterate_elements (GstBin * bin)
{
  GstIterator *result;

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  GST_OBJECT_LOCK (bin);
  result = gst_iterator_new_list (GST_TYPE_ELEMENT,
      GST_OBJECT_GET_LOCK (bin),
      &bin->children_cookie, &bin->children, (GObject *) bin, NULL);
  GST_OBJECT_UNLOCK (bin);

  return result;
}

static GstIteratorItem
iterate_child_recurse (GstIterator * it, const GValue * item)
{
  GstElement *child = g_value_get_object (item);

  if (GST_IS_BIN (child)) {
    GstIterator *other = gst_bin_iterate_recurse (GST_BIN_CAST (child));

    gst_iterator_push (it, other);
  }
  return GST_ITERATOR_ITEM_PASS;
}

/**
 * gst_bin_iterate_recurse:
 * @bin: a #GstBin
 *
 * Gets an iterator for the elements in this bin.
 * This iterator recurses into GstBin children.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement,
 * or %NULL
 */
GstIterator *
gst_bin_iterate_recurse (GstBin * bin)
{
  GstIterator *result;

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  GST_OBJECT_LOCK (bin);
  result = gst_iterator_new_list (GST_TYPE_ELEMENT,
      GST_OBJECT_GET_LOCK (bin),
      &bin->children_cookie,
      &bin->children,
      (GObject *) bin, (GstIteratorItemFunction) iterate_child_recurse);
  GST_OBJECT_UNLOCK (bin);

  return result;
}

/* returns 0 when TRUE because this is a GCompareFunc */
/* MT safe */
static gint
bin_element_is_sink (GstElement * child, GstBin * bin)
{
  gboolean is_sink;

  /* we lock the child here for the remainder of the function to
   * get its name and flag safely. */
  GST_OBJECT_LOCK (child);
  is_sink = GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_SINK);

  GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin,
      "child %s %s sink", GST_OBJECT_NAME (child), is_sink ? "is" : "is not");

  GST_OBJECT_UNLOCK (child);
  return is_sink ? 0 : 1;
}

static gint
sink_iterator_filter (const GValue * vchild, GValue * vbin)
{
  GstBin *bin = g_value_get_object (vbin);
  GstElement *child = g_value_get_object (vchild);

  return (bin_element_is_sink (child, bin));
}

/**
 * gst_bin_iterate_sinks:
 * @bin: a #GstBin
 *
 * Gets an iterator for all elements in the bin that have the
 * #GST_ELEMENT_FLAG_SINK flag set.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement,
 * or %NULL
 */
GstIterator *
gst_bin_iterate_sinks (GstBin * bin)
{
  GstIterator *children;
  GstIterator *result;
  GValue vbin = { 0, };

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  g_value_init (&vbin, GST_TYPE_BIN);
  g_value_set_object (&vbin, bin);

  children = gst_bin_iterate_elements (bin);
  result = gst_iterator_filter (children,
      (GCompareFunc) sink_iterator_filter, &vbin);

  g_value_unset (&vbin);

  return result;
}

/* returns 0 when TRUE because this is a GCompareFunc */
/* MT safe */
static gint
bin_element_is_src (GstElement * child, GstBin * bin)
{
  gboolean is_src;

  /* we lock the child here for the remainder of the function to
   * get its name and other info safely. */
  GST_OBJECT_LOCK (child);
  is_src = GST_OBJECT_FLAG_IS_SET (child, GST_ELEMENT_FLAG_SOURCE);

  GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin,
      "child %s %s src", GST_OBJECT_NAME (child), is_src ? "is" : "is not");

  GST_OBJECT_UNLOCK (child);
  return is_src ? 0 : 1;
}

static gint
src_iterator_filter (const GValue * vchild, GValue * vbin)
{
  GstBin *bin = g_value_get_object (vbin);
  GstElement *child = g_value_get_object (vchild);

  return (bin_element_is_src (child, bin));
}

/**
 * gst_bin_iterate_sources:
 * @bin: a #GstBin
 *
 * Gets an iterator for all elements in the bin that have the
 * #GST_ELEMENT_FLAG_SOURCE flag set.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement,
 * or %NULL
 */
GstIterator *
gst_bin_iterate_sources (GstBin * bin)
{
  GstIterator *children;
  GstIterator *result;
  GValue vbin = { 0, };

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  g_value_init (&vbin, GST_TYPE_BIN);
  g_value_set_object (&vbin, bin);

  children = gst_bin_iterate_elements (bin);
  result = gst_iterator_filter (children,
      (GCompareFunc) src_iterator_filter, &vbin);

  g_value_unset (&vbin);

  return result;
}

/*
 * MT safe
 */
static GstStateChangeReturn
gst_bin_get_state_func (GstElement * element, GstState * state,
    GstState * pending, GstClockTime timeout)
{
  GstStateChangeReturn ret;

  GST_CAT_INFO_OBJECT (GST_CAT_STATES, element, "getting state");

  ret =
      GST_ELEMENT_CLASS (parent_class)->get_state (element, state, pending,
      timeout);

  return ret;
}

/***********************************************
 * Topologically sorted iterator
 * see http://en.wikipedia.org/wiki/Topological_sorting
 *
 * For each element in the graph, an entry is kept in a HashTable
 * with its number of srcpad connections (degree).
 * We then change state of all elements without dependencies
 * (degree 0) and decrement the degree of all elements connected
 * on the sinkpads. When an element reaches degree 0, its state is
 * changed next.
 * When all elements are handled the algorithm stops.
 */
typedef struct _GstBinSortIterator
{
  GstIterator it;
  GQueue queue;                 /* elements queued for state change */
  GstBin *bin;                  /* bin we iterate */
  gint mode;                    /* adding or removing dependency */
  GstElement *best;             /* next element with least dependencies */
  gint best_deg;                /* best degree */
  GHashTable *hash;             /* hashtable with element dependencies */
  gboolean dirty;               /* we detected structure change */
} GstBinSortIterator;

static void
gst_bin_sort_iterator_copy (const GstBinSortIterator * it,
    GstBinSortIterator * copy)
{
  GHashTableIter iter;
  gpointer key, value;

  copy->queue = it->queue;
  g_queue_foreach (&copy->queue, (GFunc) gst_object_ref, NULL);

  copy->bin = gst_object_ref (it->bin);
  if (it->best)
    copy->best = gst_object_ref (it->best);

  copy->hash = g_hash_table_new (NULL, NULL);
  g_hash_table_iter_init (&iter, it->hash);
  while (g_hash_table_iter_next (&iter, &key, &value))
    g_hash_table_insert (copy->hash, key, value);
}

/* we add and subtract 1 to make sure we don't confuse NULL and 0 */
#define HASH_SET_DEGREE(bit, elem, deg) \
    g_hash_table_replace (bit->hash, elem, GINT_TO_POINTER(deg+1))
#define HASH_GET_DEGREE(bit, elem) \
    (GPOINTER_TO_INT(g_hash_table_lookup (bit->hash, elem))-1)

/* add element to queue of next elements in the iterator.
 * We push at the tail to give higher priority elements a
 * chance first */
static void
add_to_queue (GstBinSortIterator * bit, GstElement * element)
{
  GST_DEBUG_OBJECT (bit->bin, "adding '%s' to queue",
      GST_ELEMENT_NAME (element));
  gst_object_ref (element);
  g_queue_push_tail (&bit->queue, element);
  HASH_SET_DEGREE (bit, element, -1);
}

static void
remove_from_queue (GstBinSortIterator * bit, GstElement * element)
{
  GList *find;

  if ((find = g_queue_find (&bit->queue, element))) {
    GST_DEBUG_OBJECT (bit->bin, "removing '%s' from queue",
        GST_ELEMENT_NAME (element));

    g_queue_delete_link (&bit->queue, find);
    gst_object_unref (element);
  } else {
    GST_DEBUG_OBJECT (bit->bin, "unable to remove '%s' from queue",
        GST_ELEMENT_NAME (element));
  }
}

/* clear the queue, unref all objects as we took a ref when
 * we added them to the queue */
static void
clear_queue (GQueue * queue)
{
  gpointer p;

  while ((p = g_queue_pop_head (queue)))
    gst_object_unref (p);
}

/* set all degrees to 0. Elements marked as a sink are
 * added to the queue immediately. Since we only look at the SINK flag of the
 * element, it is possible that we add non-sinks to the queue. These will be
 * removed from the queue again when we can prove that it provides data for some
 * other element. */
static void
reset_degree (GstElement * element, GstBinSortIterator * bit)
{
  gboolean is_sink;

  /* sinks are added right away */
  GST_OBJECT_LOCK (element);
  is_sink = GST_OBJECT_FLAG_IS_SET (element, GST_ELEMENT_FLAG_SINK);
  GST_OBJECT_UNLOCK (element);

  if (is_sink) {
    add_to_queue (bit, element);
  } else {
    /* others are marked with 0 and handled when sinks are done */
    HASH_SET_DEGREE (bit, element, 0);
  }
}

/* adjust the degree of all elements connected to the given
 * element. If a degree of an element drops to 0, it is
 * added to the queue of elements to schedule next.
 *
 * We have to make sure not to cross the bin boundary this element
 * belongs to.
 */
static void
update_degree (GstElement * element, GstBinSortIterator * bit)
{
  gboolean linked = FALSE;

  GST_OBJECT_LOCK (element);
  /* don't touch degree if element has no sinkpads */
  if (element->numsinkpads != 0) {
    /* loop over all sinkpads, decrement degree for all connected
     * elements in this bin */
    GList *pads;

    for (pads = element->sinkpads; pads; pads = g_list_next (pads)) {
      GstPad *pad, *peer;

      pad = GST_PAD_CAST (pads->data);

      /* we're iterating over the sinkpads, check if it's busy in a link/unlink */
      if (G_UNLIKELY (find_message (bit->bin, GST_OBJECT_CAST (pad),
                  GST_MESSAGE_STRUCTURE_CHANGE))) {
        /* mark the iterator as dirty because we won't be updating the degree
         * of the peer parent now. This would result in the 'loop detected'
         * later on because the peer parent element could become the best next
         * element with a degree > 0. We will simply continue our state
         * changes and we'll eventually resync when the unlink completed and
         * the iterator cookie is updated. */
        bit->dirty = TRUE;
        continue;
      }

      if ((peer = gst_pad_get_peer (pad))) {
        GstElement *peer_element;

        if ((peer_element = gst_pad_get_parent_element (peer))) {
          GST_OBJECT_LOCK (peer_element);
          /* check that we don't go outside of this bin */
          if (GST_OBJECT_CAST (peer_element)->parent ==
              GST_OBJECT_CAST (bit->bin)) {
            gint old_deg, new_deg;

            old_deg = HASH_GET_DEGREE (bit, peer_element);

            /* check to see if we added an element as sink that was not really a
             * sink because it was connected to some other element. */
            if (old_deg == -1) {
              remove_from_queue (bit, peer_element);
              old_deg = 0;
            }
            new_deg = old_deg + bit->mode;

            GST_DEBUG_OBJECT (bit->bin,
                "change element %s, degree %d->%d, linked to %s",
                GST_ELEMENT_NAME (peer_element), old_deg, new_deg,
                GST_ELEMENT_NAME (element));

            /* update degree, it is possible that an element was in 0 and
             * reaches -1 here. This would mean that the element had no sinkpads
             * but became linked while the state change was happening. We will
             * resync on this with the structure change message. */
            if (new_deg == 0) {
              /* degree hit 0, add to queue */
              add_to_queue (bit, peer_element);
            } else {
              HASH_SET_DEGREE (bit, peer_element, new_deg);
            }
            linked = TRUE;
          }
          GST_OBJECT_UNLOCK (peer_element);
          gst_object_unref (peer_element);
        }
        gst_object_unref (peer);
      }
    }
  }
  if (!linked) {
    GST_DEBUG_OBJECT (bit->bin, "element %s not linked on any sinkpads",
        GST_ELEMENT_NAME (element));
  }
  GST_OBJECT_UNLOCK (element);
}

/* find the next best element not handled yet. This is the one
 * with the lowest non-negative degree */
static void
find_element (GstElement * element, GstBinSortIterator * bit)
{
  gint degree;

  /* element is already handled */
  if ((degree = HASH_GET_DEGREE (bit, element)) < 0)
    return;

  /* first element or element with smaller degree */
  if (bit->best == NULL || bit->best_deg > degree) {
    bit->best = element;
    bit->best_deg = degree;
  }
}

/* get next element in iterator. */
static GstIteratorResult
gst_bin_sort_iterator_next (GstBinSortIterator * bit, GValue * result)
{
  GstElement *best;
  GstBin *bin = bit->bin;

  /* empty queue, we have to find a next best element */
  if (g_queue_is_empty (&bit->queue)) {
    bit->best = NULL;
    bit->best_deg = G_MAXINT;
    g_list_foreach (bin->children, (GFunc) find_element, bit);
    if ((best = bit->best)) {
      /* when we detected an unlink, don't warn because our degrees might be
       * screwed up. We will resync later */
      if (bit->best_deg != 0 && !bit->dirty) {
        /* we don't fail on this one yet */
        GST_WARNING_OBJECT (bin, "loop dected in graph");
        g_warning ("loop detected in the graph of bin '%s'!!",
            GST_ELEMENT_NAME (bin));
      }
      /* best unhandled element, schedule as next element */
      GST_DEBUG_OBJECT (bin, "queue empty, next best: %s",
          GST_ELEMENT_NAME (best));
      HASH_SET_DEGREE (bit, best, -1);
      g_value_set_object (result, best);
    } else {
      GST_DEBUG_OBJECT (bin, "queue empty, elements exhausted");
      /* no more unhandled elements, we are done */
      return GST_ITERATOR_DONE;
    }
  } else {
    /* everything added to the queue got reffed */
    best = g_queue_pop_head (&bit->queue);
    g_value_set_object (result, best);
    gst_object_unref (best);
  }

  GST_DEBUG_OBJECT (bin, "queue head gives %s", GST_ELEMENT_NAME (best));
  /* update degrees of linked elements */
  update_degree (best, bit);

  return GST_ITERATOR_OK;
}

/* clear queues, recalculate the degrees and restart. */
static void
gst_bin_sort_iterator_resync (GstBinSortIterator * bit)
{
  GstBin *bin = bit->bin;

  GST_DEBUG_OBJECT (bin, "resync");
  bit->dirty = FALSE;
  clear_queue (&bit->queue);
  /* reset degrees */
  g_list_foreach (bin->children, (GFunc) reset_degree, bit);
  /* calc degrees, incrementing */
  bit->mode = 1;
  g_list_foreach (bin->children, (GFunc) update_degree, bit);
  /* for the rest of the function we decrement the degrees */
  bit->mode = -1;
}

/* clear queues, unref bin and free iterator. */
static void
gst_bin_sort_iterator_free (GstBinSortIterator * bit)
{
  GstBin *bin = bit->bin;

  GST_DEBUG_OBJECT (bin, "free");
  clear_queue (&bit->queue);
  g_hash_table_destroy (bit->hash);
  gst_object_unref (bin);
}

/* should be called with the bin LOCK held */
static GstIterator *
gst_bin_sort_iterator_new (GstBin * bin)
{
  GstBinSortIterator *result;

  /* we don't need an ItemFunction because we ref the items in the _next
   * method already */
  result = (GstBinSortIterator *)
      gst_iterator_new (sizeof (GstBinSortIterator),
      GST_TYPE_ELEMENT,
      GST_OBJECT_GET_LOCK (bin),
      &bin->priv->structure_cookie,
      (GstIteratorCopyFunction) gst_bin_sort_iterator_copy,
      (GstIteratorNextFunction) gst_bin_sort_iterator_next,
      (GstIteratorItemFunction) NULL,
      (GstIteratorResyncFunction) gst_bin_sort_iterator_resync,
      (GstIteratorFreeFunction) gst_bin_sort_iterator_free);
  g_queue_init (&result->queue);
  result->hash = g_hash_table_new (NULL, NULL);
  gst_object_ref (bin);
  result->bin = bin;
  gst_bin_sort_iterator_resync (result);

  return (GstIterator *) result;
}

/**
 * gst_bin_iterate_sorted:
 * @bin: a #GstBin
 *
 * Gets an iterator for the elements in this bin in topologically
 * sorted order. This means that the elements are returned from
 * the most downstream elements (sinks) to the sources.
 *
 * This function is used internally to perform the state changes
 * of the bin elements and for clock selection.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement,
 * or %NULL
 */
GstIterator *
gst_bin_iterate_sorted (GstBin * bin)
{
  GstIterator *result;

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  GST_OBJECT_LOCK (bin);
  result = gst_bin_sort_iterator_new (bin);
  GST_OBJECT_UNLOCK (bin);

  return result;
}

static GstStateChangeReturn
gst_bin_element_set_state (GstBin * bin, GstElement * element,
    GstClockTime base_time, GstClockTime start_time, GstState current,
    GstState next)
{
  GstStateChangeReturn ret;
  GstState child_current, child_pending;
  gboolean locked;
  GList *found;

  GST_STATE_LOCK (element);

  GST_OBJECT_LOCK (element);
  /* set base_time and start time on child */
  GST_ELEMENT_START_TIME (element) = start_time;
  element->base_time = base_time;
  /* peel off the locked flag */
  locked = GST_ELEMENT_IS_LOCKED_STATE (element);
  /* Get the previous set_state result to preserve NO_PREROLL and ASYNC */
  ret = GST_STATE_RETURN (element);
  child_current = GST_STATE (element);
  child_pending = GST_STATE_PENDING (element);
  GST_OBJECT_UNLOCK (element);

  /* skip locked elements */
  if (G_UNLIKELY (locked))
    goto locked;

  /* if the element was no preroll, just start changing the state regardless
   * if it had async elements (in the case of a bin) because they won't preroll
   * anyway. */
  if (G_UNLIKELY (ret == GST_STATE_CHANGE_NO_PREROLL)) {
    GST_DEBUG_OBJECT (element, "element is NO_PREROLL, ignore async elements");
    goto no_preroll;
  }

  GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
      "current %s pending %s, desired next %s",
      gst_element_state_get_name (child_current),
      gst_element_state_get_name (child_pending),
      gst_element_state_get_name (next));

  /* always recurse into bins so that we can set the base time */
  if (GST_IS_BIN (element))
    goto do_state;

  /* Try not to change the state of elements that are already in the state we're
   * going to */
  if (child_current == next && child_pending == GST_STATE_VOID_PENDING) {
    /* child is already at the requested state, return previous return. Note that
     * if the child has a pending state to next, we will still call the
     * set_state function */
    goto unneeded;
  } else if (next > current) {
    /* upward state change */
    if (child_pending == GST_STATE_VOID_PENDING) {
      /* .. and the child is not busy doing anything */
      if (child_current > next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    } else if (child_pending > child_current) {
      /* .. and the child is busy going upwards */
      if (child_current >= next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    } else {
      /* .. and the child is busy going downwards */
      if (child_current > next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    }
  } else if (next < current) {
    /* downward state change */
    if (child_pending == GST_STATE_VOID_PENDING) {
      /* .. and the child is not busy doing anything */
      if (child_current < next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    } else if (child_pending < child_current) {
      /* .. and the child is busy going downwards */
      if (child_current <= next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    } else {
      /* .. and the child is busy going upwards */
      if (child_current < next) {
        /* .. and is already past the requested state, assume it got there
         * without error */
        ret = GST_STATE_CHANGE_SUCCESS;
        goto unneeded;
      }
    }
  }

do_state:
  GST_OBJECT_LOCK (bin);
  /* the element was busy with an upwards async state change, we must wait for
   * an ASYNC_DONE message before we attemp to change the state. */
  if ((found =
          find_message (bin, GST_OBJECT_CAST (element),
              GST_MESSAGE_ASYNC_START))) {
#ifndef GST_DISABLE_GST_DEBUG
    GstMessage *message = GST_MESSAGE_CAST (found->data);

    GST_DEBUG_OBJECT (element, "element message %p, %s async busy",
        message, GST_ELEMENT_NAME (GST_MESSAGE_SRC (message)));
#endif
    /* only wait for upward state changes */
    if (next > current) {
      /* We found an async element check if we can force its state to change or
       * if we have to wait for it to preroll. */
      goto was_busy;
    }
  }
  GST_OBJECT_UNLOCK (bin);

no_preroll:
  GST_DEBUG_OBJECT (bin,
      "setting element %s to %s, base_time %" GST_TIME_FORMAT,
      GST_ELEMENT_NAME (element), gst_element_state_get_name (next),
      GST_TIME_ARGS (base_time));

  /* change state */
  ret = gst_element_set_state (element, next);

  GST_STATE_UNLOCK (element);

  return ret;

locked:
  {
    GST_DEBUG_OBJECT (element,
        "element is locked, return previous return %s",
        gst_element_state_change_return_get_name (ret));
    GST_STATE_UNLOCK (element);
    return ret;
  }
unneeded:
  {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
        "skipping transition from %s to  %s",
        gst_element_state_get_name (child_current),
        gst_element_state_get_name (next));
    GST_STATE_UNLOCK (element);
    return ret;
  }
was_busy:
  {
    GST_DEBUG_OBJECT (element, "element was busy, delaying state change");
    GST_OBJECT_UNLOCK (bin);
    GST_STATE_UNLOCK (element);
    return GST_STATE_CHANGE_ASYNC;
  }
}

/* gst_iterator_fold functions for pads_activate
 * Stop the iterator if activating one pad failed. */
static gboolean
activate_pads (const GValue * vpad, GValue * ret, gboolean * active)
{
  GstPad *pad = g_value_get_object (vpad);
  gboolean cont = TRUE;

  if (!(cont = gst_pad_set_active (pad, *active)))
    g_value_set_boolean (ret, FALSE);

  return cont;
}

/* returns false on error or early cutout of the fold, true if all
 * pads in @iter were (de)activated successfully. */
static gboolean
iterator_activate_fold_with_resync (GstIterator * iter, gpointer user_data)
{
  GstIteratorResult ires;
  GValue ret = { 0 };

  /* no need to unset this later, it's just a boolean */
  g_value_init (&ret, G_TYPE_BOOLEAN);
  g_value_set_boolean (&ret, TRUE);

  while (1) {
    ires = gst_iterator_fold (iter, (GstIteratorFoldFunction) activate_pads,
        &ret, user_data);
    switch (ires) {
      case GST_ITERATOR_RESYNC:
        /* need to reset the result again */
        g_value_set_boolean (&ret, TRUE);
        gst_iterator_resync (iter);
        break;
      case GST_ITERATOR_DONE:
        /* all pads iterated, return collected value */
        goto done;
      default:
        /* iterator returned _ERROR or premature end with _OK,
         * mark an error and exit */
        g_value_set_boolean (&ret, FALSE);
        goto done;
    }
  }
done:
  /* return collected value */
  return g_value_get_boolean (&ret);
}

/* is called with STATE_LOCK
 */
static gboolean
gst_bin_src_pads_activate (GstBin * bin, gboolean active)
{
  GstIterator *iter;
  gboolean fold_ok;

  GST_DEBUG_OBJECT (bin, "%s pads", active ? "activate" : "deactivate");

  iter = gst_element_iterate_src_pads ((GstElement *) bin);
  fold_ok = iterator_activate_fold_with_resync (iter, &active);
  gst_iterator_free (iter);
  if (G_UNLIKELY (!fold_ok))
    goto failed;

  GST_DEBUG_OBJECT (bin, "pad %sactivation successful", active ? "" : "de");

  return TRUE;

  /* ERRORS */
failed:
  {
    GST_DEBUG_OBJECT (bin, "pad %sactivation failed", active ? "" : "de");
    return FALSE;
  }
}

/**
 * gst_bin_recalculate_latency:
 * @bin: a #GstBin
 *
 * Query @bin for the current latency using and reconfigures this latency to all the
 * elements with a LATENCY event.
 *
 * This method is typically called on the pipeline when a #GST_MESSAGE_LATENCY
 * is posted on the bus.
 *
 * This function simply emits the 'do-latency' signal so any custom latency
 * calculations will be performed.
 *
 * Returns: %TRUE if the latency could be queried and reconfigured.
 */
gboolean
gst_bin_recalculate_latency (GstBin * bin)
{
  gboolean res;

  g_signal_emit (bin, gst_bin_signals[DO_LATENCY], 0, &res);
  GST_DEBUG_OBJECT (bin, "latency returned %d", res);

  return res;
}

static gboolean
gst_bin_do_latency_func (GstBin * bin)
{
  GstQuery *query;
  GstElement *element;
  GstClockTime min_latency, max_latency;
  gboolean res;

  g_return_val_if_fail (GST_IS_BIN (bin), FALSE);

  element = GST_ELEMENT_CAST (bin);

  GST_DEBUG_OBJECT (element, "querying latency");

  query = gst_query_new_latency ();
  if ((res = gst_element_query (element, query))) {
    gboolean live;

    gst_query_parse_latency (query, &live, &min_latency, &max_latency);

    GST_DEBUG_OBJECT (element,
        "got min latency %" GST_TIME_FORMAT ", max latency %"
        GST_TIME_FORMAT ", live %d", GST_TIME_ARGS (min_latency),
        GST_TIME_ARGS (max_latency), live);

    if (max_latency < min_latency) {
      /* this is an impossible situation, some parts of the pipeline might not
       * work correctly. We post a warning for now. */
      GST_ELEMENT_WARNING (element, CORE, CLOCK, (NULL),
          ("Impossible to configure latency: max %" GST_TIME_FORMAT " < min %"
              GST_TIME_FORMAT ". Add queues or other buffering elements.",
              GST_TIME_ARGS (max_latency), GST_TIME_ARGS (min_latency)));
    }

    /* configure latency on elements */
    res = gst_element_send_event (element, gst_event_new_latency (min_latency));
    if (res) {
      GST_INFO_OBJECT (element, "configured latency of %" GST_TIME_FORMAT,
          GST_TIME_ARGS (min_latency));
    } else {
      GST_WARNING_OBJECT (element,
          "did not really configure latency of %" GST_TIME_FORMAT,
          GST_TIME_ARGS (min_latency));
    }
  } else {
    /* this is not a real problem, we just don't configure any latency. */
    GST_WARNING_OBJECT (element, "failed to query latency");
  }
  gst_query_unref (query);

  return res;
}

static gboolean
gst_bin_post_message (GstElement * element, GstMessage * msg)
{
  GstElementClass *pklass = (GstElementClass *) parent_class;
  gboolean ret;

  ret = pklass->post_message (element, gst_message_ref (msg));

  if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_STATE_CHANGED &&
      GST_MESSAGE_SRC (msg) == GST_OBJECT_CAST (element)) {
    GstState newstate, pending;

    gst_message_parse_state_changed (msg, NULL, &newstate, &pending);
    if (newstate == GST_STATE_PLAYING && pending == GST_STATE_VOID_PENDING) {
      GST_BIN_CAST (element)->priv->posted_playing = TRUE;
      bin_do_eos (GST_BIN_CAST (element));
    } else {
      GST_BIN_CAST (element)->priv->posted_playing = FALSE;
    }
  }

  gst_message_unref (msg);

  return ret;
}

static GstStateChangeReturn
gst_bin_change_state_func (GstElement * element, GstStateChange transition)
{
  GstBin *bin;
  GstStateChangeReturn ret;
  GstState current, next;
  gboolean have_async;
  gboolean have_no_preroll;
  GstClockTime base_time, start_time;
  GstIterator *it;
  gboolean done;
  GValue data = { 0, };

  /* we don't need to take the STATE_LOCK, it is already taken */
  current = (GstState) GST_STATE_TRANSITION_CURRENT (transition);
  next = (GstState) GST_STATE_TRANSITION_NEXT (transition);

  GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, element,
      "changing state of children from %s to %s",
      gst_element_state_get_name (current), gst_element_state_get_name (next));

  bin = GST_BIN_CAST (element);

  switch (next) {
    case GST_STATE_PLAYING:
    {
      gboolean toplevel;

      GST_OBJECT_LOCK (bin);
      toplevel = BIN_IS_TOPLEVEL (bin);
      GST_OBJECT_UNLOCK (bin);

      if (toplevel)
        gst_bin_recalculate_latency (bin);
      break;
    }
    case GST_STATE_PAUSED:
      /* Clear EOS list on next PAUSED */
      GST_OBJECT_LOCK (bin);
      GST_DEBUG_OBJECT (element, "clearing EOS elements");
      bin_remove_messages (bin, NULL, GST_MESSAGE_EOS);
      bin->priv->posted_eos = FALSE;
      if (current == GST_STATE_READY)
        bin_remove_messages (bin, NULL, GST_MESSAGE_STREAM_START);
      GST_OBJECT_UNLOCK (bin);
      if (current == GST_STATE_READY)
        if (!(gst_bin_src_pads_activate (bin, TRUE)))
          goto activate_failure;
      break;
    case GST_STATE_READY:
      /* Clear message list on next READY */
      GST_OBJECT_LOCK (bin);
      GST_DEBUG_OBJECT (element, "clearing all cached messages");
      bin_remove_messages (bin, NULL, GST_MESSAGE_ANY);
      GST_OBJECT_UNLOCK (bin);
      /* We might not have reached PAUSED yet due to async errors,
       * make sure to always deactivate the pads nonetheless */
      if (!(gst_bin_src_pads_activate (bin, FALSE)))
        goto activate_failure;
      break;
    case GST_STATE_NULL:
      if (current == GST_STATE_READY) {
        GList *l;

        if (!(gst_bin_src_pads_activate (bin, FALSE)))
          goto activate_failure;

        /* Remove all non-persistent contexts */
        GST_OBJECT_LOCK (bin);
        for (l = bin->priv->contexts; l;) {
          GstContext *context = l->data;

          if (!gst_context_is_persistent (context)) {
            GList *next;

            gst_context_unref (context);
            next = l->next;
            bin->priv->contexts = g_list_delete_link (bin->priv->contexts, l);
            l = next;
          } else {
            l = l->next;
          }
        }
        GST_OBJECT_UNLOCK (bin);
      }
      break;
    default:
      break;
  }

  /* this flag is used to make the async state changes return immediately. We
   * don't want them to interfere with this state change */
  GST_OBJECT_LOCK (bin);
  bin->polling = TRUE;
  GST_OBJECT_UNLOCK (bin);

  /* iterate in state change order */
  it = gst_bin_iterate_sorted (bin);

  /* mark if we've seen an ASYNC element in the bin when we did a state change.
   * Note how we don't reset this value when a resync happens, the reason being
   * that the async element posted ASYNC_START and we want to post ASYNC_DONE
   * even after a resync when the async element is gone */
  have_async = FALSE;

restart:
  /* take base_time */
  base_time = gst_element_get_base_time (element);
  start_time = gst_element_get_start_time (element);

  have_no_preroll = FALSE;

  done = FALSE;
  while (!done) {
    switch (gst_iterator_next (it, &data)) {
      case GST_ITERATOR_OK:
      {
        GstElement *child;

        child = g_value_get_object (&data);

        /* set state and base_time now */
        ret = gst_bin_element_set_state (bin, child, base_time, start_time,
            current, next);

        switch (ret) {
          case GST_STATE_CHANGE_SUCCESS:
            GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
                "child '%s' changed state to %d(%s) successfully",
                GST_ELEMENT_NAME (child), next,
                gst_element_state_get_name (next));
            break;
          case GST_STATE_CHANGE_ASYNC:
          {
            GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
                "child '%s' is changing state asynchronously to %s",
                GST_ELEMENT_NAME (child), gst_element_state_get_name (next));
            have_async = TRUE;
            break;
          }
          case GST_STATE_CHANGE_FAILURE:{
            GstObject *parent;

            GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
                "child '%s' failed to go to state %d(%s)",
                GST_ELEMENT_NAME (child),
                next, gst_element_state_get_name (next));

            /* Only fail if the child is still inside
             * this bin. It might've been removed already
             * because of the error by the bin subclass
             * to ignore the error.  */
            parent = gst_object_get_parent (GST_OBJECT_CAST (child));
            if (parent == GST_OBJECT_CAST (element)) {
              /* element is still in bin, really error now */
              gst_object_unref (parent);
              goto done;
            }
            /* child removed from bin, let the resync code redo the state
             * change */
            GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
                "child '%s' was removed from the bin",
                GST_ELEMENT_NAME (child));

            if (parent)
              gst_object_unref (parent);

            break;
          }
          case GST_STATE_CHANGE_NO_PREROLL:
            GST_CAT_INFO_OBJECT (GST_CAT_STATES, element,
                "child '%s' changed state to %d(%s) successfully without preroll",
                GST_ELEMENT_NAME (child), next,
                gst_element_state_get_name (next));
            have_no_preroll = TRUE;
            break;
          default:
            g_assert_not_reached ();
            break;
        }
        g_value_reset (&data);
        break;
      }
      case GST_ITERATOR_RESYNC:
        GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, element, "iterator doing resync");
        gst_iterator_resync (it);
        goto restart;
      default:
      case GST_ITERATOR_DONE:
        GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, element, "iterator done");
        done = TRUE;
        break;
    }
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
  if (G_UNLIKELY (ret == GST_STATE_CHANGE_FAILURE))
    goto done;

  if (have_no_preroll) {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin,
        "we have NO_PREROLL elements %s -> NO_PREROLL",
        gst_element_state_change_return_get_name (ret));
    ret = GST_STATE_CHANGE_NO_PREROLL;
  } else if (have_async) {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin,
        "we have ASYNC elements %s -> ASYNC",
        gst_element_state_change_return_get_name (ret));
    ret = GST_STATE_CHANGE_ASYNC;
  }

done:
  g_value_unset (&data);
  gst_iterator_free (it);

  GST_OBJECT_LOCK (bin);
  bin->polling = FALSE;
  /* it's possible that we did not get ASYNC from the children while the bin is
   * simulating ASYNC behaviour by posting an ASYNC_DONE message on the bus with
   * itself as the source. In that case we still want to check if the state
   * change completed. */
  if (ret != GST_STATE_CHANGE_ASYNC && !bin->priv->pending_async_done) {
    /* no element returned ASYNC and there are no pending async_done messages,
     * we can just complete. */
    GST_DEBUG_OBJECT (bin, "no async elements");
    goto state_end;
  }
  /* when we get here an ASYNC element was found */
  if (GST_STATE_TARGET (bin) <= GST_STATE_READY) {
    /* we ignore ASYNC state changes when we go to READY or NULL */
    GST_DEBUG_OBJECT (bin, "target state %s <= READY",
        gst_element_state_get_name (GST_STATE_TARGET (bin)));
    goto state_end;
  }

  GST_DEBUG_OBJECT (bin, "check async elements");
  /* check if all elements managed to commit their state already */
  if (!find_message (bin, NULL, GST_MESSAGE_ASYNC_START)) {
    /* nothing found, remove all old ASYNC_DONE messages. This can happen when
     * all the elements commited their state while we were doing the state
     * change. We will still return ASYNC for consistency but we commit the
     * state already so that a _get_state() will return immediately. */
    bin_remove_messages (bin, NULL, GST_MESSAGE_ASYNC_DONE);

    GST_DEBUG_OBJECT (bin, "async elements commited");
    bin_handle_async_done (bin, GST_STATE_CHANGE_SUCCESS, FALSE,
        GST_CLOCK_TIME_NONE);
  }

state_end:
  bin->priv->pending_async_done = FALSE;
  GST_OBJECT_UNLOCK (bin);

  GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, element,
      "done changing bin's state from %s to %s, now in %s, ret %s",
      gst_element_state_get_name (current),
      gst_element_state_get_name (next),
      gst_element_state_get_name (GST_STATE (element)),
      gst_element_state_change_return_get_name (ret));

  return ret;

  /* ERRORS */
activate_failure:
  {
    GST_CAT_WARNING_OBJECT (GST_CAT_STATES, element,
        "failure (de)activating src pads");
    return GST_STATE_CHANGE_FAILURE;
  }
}

/*
 * This function is a utility event handler for seek events.
 * It will send the event to all sinks or sources and appropriate
 * ghost pads depending on the event-direction.
 *
 * Applications are free to override this behaviour and
 * implement their own seek handler, but this will work for
 * pretty much all cases in practice.
 */
static gboolean
gst_bin_send_event (GstElement * element, GstEvent * event)
{
  GstBin *bin = GST_BIN_CAST (element);
  GstIterator *iter;
  gboolean res = TRUE;
  gboolean done = FALSE;
  GValue data = { 0, };

  if (GST_EVENT_IS_DOWNSTREAM (event)) {
    iter = gst_bin_iterate_sources (bin);
    GST_DEBUG_OBJECT (bin, "Sending %s event to src children",
        GST_EVENT_TYPE_NAME (event));
  } else {
    iter = gst_bin_iterate_sinks (bin);
    GST_DEBUG_OBJECT (bin, "Sending %s event to sink children",
        GST_EVENT_TYPE_NAME (event));
  }

  while (!done) {
    switch (gst_iterator_next (iter, &data)) {
      case GST_ITERATOR_OK:
      {
        GstElement *child = g_value_get_object (&data);

        gst_event_ref (event);
        res &= gst_element_send_event (child, event);

        GST_LOG_OBJECT (child, "After handling %s event: %d",
            GST_EVENT_TYPE_NAME (event), res);

        g_value_reset (&data);
        break;
      }
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (iter);
        res = TRUE;
        break;
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
      case GST_ITERATOR_ERROR:
        g_assert_not_reached ();
        break;
    }
  }
  g_value_unset (&data);
  gst_iterator_free (iter);

  if (GST_EVENT_IS_DOWNSTREAM (event)) {
    iter = gst_element_iterate_sink_pads (GST_ELEMENT (bin));
    GST_DEBUG_OBJECT (bin, "Sending %s event to sink pads",
        GST_EVENT_TYPE_NAME (event));
  } else {
    iter = gst_element_iterate_src_pads (GST_ELEMENT (bin));
    GST_DEBUG_OBJECT (bin, "Sending %s event to src pads",
        GST_EVENT_TYPE_NAME (event));
  }

  done = FALSE;
  while (!done) {
    switch (gst_iterator_next (iter, &data)) {
      case GST_ITERATOR_OK:
      {
        GstPad *pad = g_value_get_object (&data);

        gst_event_ref (event);
        res &= gst_pad_send_event (pad, event);
        GST_LOG_OBJECT (pad, "After handling %s event: %d",
            GST_EVENT_TYPE_NAME (event), res);
        break;
      }
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (iter);
        res = TRUE;
        break;
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
      case GST_ITERATOR_ERROR:
        g_assert_not_reached ();
        break;
    }
  }

  g_value_unset (&data);
  gst_iterator_free (iter);
  gst_event_unref (event);

  return res;
}

/* this is the function called by the threadpool. When async elements commit
 * their state, this function will attempt to bring the bin to the next state.
 */
static void
gst_bin_continue_func (BinContinueData * data)
{
  GstBin *bin;
  GstState current, next, pending;
  GstStateChange transition;

  bin = data->bin;
  pending = data->pending;

  GST_DEBUG_OBJECT (bin, "waiting for state lock");
  GST_STATE_LOCK (bin);

  GST_DEBUG_OBJECT (bin, "doing state continue");
  GST_OBJECT_LOCK (bin);

  /* if a new state change happened after this thread was scheduled, we return
   * immediately. */
  if (data->cookie != GST_ELEMENT_CAST (bin)->state_cookie)
    goto interrupted;

  current = GST_STATE (bin);
  next = GST_STATE_GET_NEXT (current, pending);
  transition = (GstStateChange) GST_STATE_TRANSITION (current, next);

  GST_STATE_NEXT (bin) = next;
  GST_STATE_PENDING (bin) = pending;
  /* mark busy */
  GST_STATE_RETURN (bin) = GST_STATE_CHANGE_ASYNC;
  GST_OBJECT_UNLOCK (bin);

  GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin,
      "continue state change %s to %s, final %s",
      gst_element_state_get_name (current),
      gst_element_state_get_name (next), gst_element_state_get_name (pending));

  gst_element_change_state (GST_ELEMENT_CAST (bin), transition);

  GST_STATE_UNLOCK (bin);
  GST_DEBUG_OBJECT (bin, "state continue done");

  gst_object_unref (bin);
  g_slice_free (BinContinueData, data);
  return;

interrupted:
  {
    GST_OBJECT_UNLOCK (bin);
    GST_STATE_UNLOCK (bin);
    GST_DEBUG_OBJECT (bin, "state continue aborted due to intervening change");
    gst_object_unref (bin);
    g_slice_free (BinContinueData, data);
    return;
  }
}

static GstBusSyncReply
bin_bus_handler (GstBus * bus, GstMessage * message, GstBin * bin)
{
  GstBinClass *bclass;

  bclass = GST_BIN_GET_CLASS (bin);
  if (bclass->handle_message)
    bclass->handle_message (bin, message);
  else
    gst_message_unref (message);

  return GST_BUS_DROP;
}

static void
bin_push_state_continue (BinContinueData * data)
{
  GstBinClass *klass;
  GstBin *bin;

  /* ref was taken */
  bin = data->bin;
  klass = GST_BIN_GET_CLASS (bin);

  GST_DEBUG_OBJECT (bin, "pushing continue on thread pool");
  g_thread_pool_push (klass->pool, data, NULL);
}

/* an element started an async state change, if we were not busy with a state
 * change, we perform a lost state.
 * This function is called with the OBJECT lock.
 */
static void
bin_handle_async_start (GstBin * bin)
{
  GstState old_state, new_state;
  gboolean toplevel;
  GstMessage *amessage = NULL;

  if (GST_STATE_RETURN (bin) == GST_STATE_CHANGE_FAILURE)
    goto had_error;

  /* get our toplevel state */
  toplevel = BIN_IS_TOPLEVEL (bin);

  /* prepare an ASYNC_START message, we always post the start message even if we
   * are busy with a state change or when we are NO_PREROLL. */
  if (!toplevel)
    /* non toplevel bin, prepare async-start for the parent */
    amessage = gst_message_new_async_start (GST_OBJECT_CAST (bin));

  if (bin->polling || GST_STATE_PENDING (bin) != GST_STATE_VOID_PENDING)
    goto was_busy;

  /* async starts are ignored when we are NO_PREROLL */
  if (GST_STATE_RETURN (bin) == GST_STATE_CHANGE_NO_PREROLL)
    goto was_no_preroll;

  old_state = GST_STATE (bin);

  /* when we PLAYING we go back to PAUSED, when preroll happens, we go back to
   * PLAYING after optionally redistributing the base_time. */
  if (old_state > GST_STATE_PAUSED)
    new_state = GST_STATE_PAUSED;
  else
    new_state = old_state;

  GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin,
      "lost state of %s, new %s", gst_element_state_get_name (old_state),
      gst_element_state_get_name (new_state));

  GST_STATE (bin) = new_state;
  GST_STATE_NEXT (bin) = new_state;
  GST_STATE_PENDING (bin) = new_state;
  GST_STATE_RETURN (bin) = GST_STATE_CHANGE_ASYNC;
  GST_OBJECT_UNLOCK (bin);

  /* post message */
  _priv_gst_element_state_changed (GST_ELEMENT_CAST (bin), new_state, new_state,
      new_state);

post_start:
  if (amessage) {
    /* post our ASYNC_START. */
    GST_DEBUG_OBJECT (bin, "posting ASYNC_START to parent");
    gst_element_post_message (GST_ELEMENT_CAST (bin), amessage);
  }
  GST_OBJECT_LOCK (bin);

  return;

had_error:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin, "we had an error");
    return;
  }
was_busy:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin, "state change busy");
    GST_OBJECT_UNLOCK (bin);
    goto post_start;
  }
was_no_preroll:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin, "ignoring, we are NO_PREROLL");
    GST_OBJECT_UNLOCK (bin);
    goto post_start;
  }
}

/* this function is called when there are no more async elements in the bin. We
 * post a state changed message and an ASYNC_DONE message.
 * This function is called with the OBJECT lock.
 */
static void
bin_handle_async_done (GstBin * bin, GstStateChangeReturn ret,
    gboolean flag_pending, GstClockTime running_time)
{
  GstState current, pending, target;
  GstStateChangeReturn old_ret;
  GstState old_state, old_next;
  gboolean toplevel, state_changed = FALSE;
  GstMessage *amessage = NULL;
  BinContinueData *cont = NULL;

  if (GST_STATE_RETURN (bin) == GST_STATE_CHANGE_FAILURE)
    goto had_error;

  pending = GST_STATE_PENDING (bin);

  if (bin->polling)
    goto was_busy;

  /* check if there is something to commit */
  if (pending == GST_STATE_VOID_PENDING)
    goto nothing_pending;

  old_ret = GST_STATE_RETURN (bin);
  GST_STATE_RETURN (bin) = ret;

  /* move to the next target state */
  target = GST_STATE_TARGET (bin);
  pending = GST_STATE_PENDING (bin) = target;

  amessage = gst_message_new_async_done (GST_OBJECT_CAST (bin), running_time);

  old_state = GST_STATE (bin);
  /* this is the state we should go to next */
  old_next = GST_STATE_NEXT (bin);

  if (old_next != GST_STATE_PLAYING) {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin,
        "committing state from %s to %s, old pending %s",
        gst_element_state_get_name (old_state),
        gst_element_state_get_name (old_next),
        gst_element_state_get_name (pending));

    /* update current state */
    current = GST_STATE (bin) = old_next;
  } else {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin,
        "setting state from %s to %s, pending %s",
        gst_element_state_get_name (old_state),
        gst_element_state_get_name (old_state),
        gst_element_state_get_name (pending));
    current = old_state;
  }

  /* get our toplevel state */
  toplevel = BIN_IS_TOPLEVEL (bin);

  /* see if we reached the final state. If we are not toplevel, we also have to
   * stop here, the parent will continue our state. */
  if ((pending == current) || !toplevel) {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin,
        "completed state change, pending VOID");

    /* mark VOID pending */
    pending = GST_STATE_VOID_PENDING;
    GST_STATE_PENDING (bin) = pending;
    GST_STATE_NEXT (bin) = GST_STATE_VOID_PENDING;
  } else {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin,
        "continue state change, pending %s",
        gst_element_state_get_name (pending));

    cont = g_slice_new (BinContinueData);

    /* ref to the bin */
    cont->bin = gst_object_ref (bin);
    /* cookie to detect concurrent state change */
    cont->cookie = GST_ELEMENT_CAST (bin)->state_cookie;
    /* pending target state */
    cont->pending = pending;
    /* mark busy */
    GST_STATE_RETURN (bin) = GST_STATE_CHANGE_ASYNC;
    GST_STATE_NEXT (bin) = GST_STATE_GET_NEXT (old_state, pending);
  }

  if (old_next != GST_STATE_PLAYING) {
    if (old_state != old_next || old_ret == GST_STATE_CHANGE_ASYNC) {
      state_changed = TRUE;
    }
  }
  GST_OBJECT_UNLOCK (bin);

  if (state_changed) {
    _priv_gst_element_state_changed (GST_ELEMENT_CAST (bin), old_state,
        old_next, pending);
  }
  if (amessage) {
    /* post our combined ASYNC_DONE when all is ASYNC_DONE. */
    GST_DEBUG_OBJECT (bin, "posting ASYNC_DONE to parent");
    gst_element_post_message (GST_ELEMENT_CAST (bin), amessage);
  }

  GST_OBJECT_LOCK (bin);
  if (cont) {
    /* toplevel, start continue state */
    GST_DEBUG_OBJECT (bin, "all async-done, starting state continue");
    bin_push_state_continue (cont);
  } else {
    GST_DEBUG_OBJECT (bin, "state change complete");
    GST_STATE_BROADCAST (bin);
  }
  return;

had_error:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin, "we had an error");
    return;
  }
was_busy:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_STATES, bin, "state change busy");
    /* if we were busy with a state change and we are requested to flag a
     * pending async done, we do so here */
    if (flag_pending)
      bin->priv->pending_async_done = TRUE;
    return;
  }
nothing_pending:
  {
    GST_CAT_INFO_OBJECT (GST_CAT_STATES, bin, "nothing pending");
    return;
  }
}

static void
bin_do_eos (GstBin * bin)
{
  guint32 seqnum = 0;
  gboolean eos;

  GST_OBJECT_LOCK (bin);
  /* If all sinks are EOS, we're in PLAYING and no state change is pending
   * we forward the EOS message to the parent bin or application
   */
  eos = GST_STATE (bin) == GST_STATE_PLAYING
      && GST_STATE_PENDING (bin) == GST_STATE_VOID_PENDING
      && bin->priv->posted_playing && is_eos (bin, &seqnum);
  GST_OBJECT_UNLOCK (bin);

  if (eos
      && g_atomic_int_compare_and_exchange (&bin->priv->posted_eos, FALSE,
          TRUE)) {
    GstMessage *tmessage;

    /* Clear out any further messages, and reset posted_eos so we can
       detect any new EOS that happens (eg, after a seek). Since all
       sinks have now posted an EOS, there will be no further EOS events
       seen unless there is a new logical EOS */
    GST_OBJECT_LOCK (bin);
    bin_remove_messages (bin, NULL, GST_MESSAGE_EOS);
    bin->priv->posted_eos = FALSE;
    GST_OBJECT_UNLOCK (bin);

    tmessage = gst_message_new_eos (GST_OBJECT_CAST (bin));
    gst_message_set_seqnum (tmessage, seqnum);
    GST_DEBUG_OBJECT (bin,
        "all sinks posted EOS, posting seqnum #%" G_GUINT32_FORMAT, seqnum);
    gst_element_post_message (GST_ELEMENT_CAST (bin), tmessage);
  }
}

static void
bin_do_stream_start (GstBin * bin)
{
  guint32 seqnum = 0;
  gboolean stream_start;
  gboolean have_group_id = FALSE;
  guint group_id = 0;

  GST_OBJECT_LOCK (bin);
  /* If all sinks are STREAM_START we forward the STREAM_START message
   * to the parent bin or application
   */
  stream_start = is_stream_start (bin, &seqnum, &have_group_id, &group_id);
  GST_OBJECT_UNLOCK (bin);

  if (stream_start) {
    GstMessage *tmessage;

    GST_OBJECT_LOCK (bin);
    bin_remove_messages (bin, NULL, GST_MESSAGE_STREAM_START);
    GST_OBJECT_UNLOCK (bin);

    tmessage = gst_message_new_stream_start (GST_OBJECT_CAST (bin));
    gst_message_set_seqnum (tmessage, seqnum);
    if (have_group_id)
      gst_message_set_group_id (tmessage, group_id);

    GST_DEBUG_OBJECT (bin,
        "all sinks posted STREAM_START, posting seqnum #%" G_GUINT32_FORMAT,
        seqnum);
    gst_element_post_message (GST_ELEMENT_CAST (bin), tmessage);
  }
}

/* must be called without the object lock as it posts messages */
static void
bin_do_message_forward (GstBin * bin, GstMessage * message)
{
  if (bin->priv->message_forward) {
    GstMessage *forwarded;

    GST_DEBUG_OBJECT (bin, "pass %s message upward",
        GST_MESSAGE_TYPE_NAME (message));

    /* we need to convert these messages to element messages so that our parent
     * bin can easily ignore them and so that the application can easily
     * distinguish between the internally forwarded and the real messages. */
    forwarded = gst_message_new_element (GST_OBJECT_CAST (bin),
        gst_structure_new ("GstBinForwarded",
            "message", GST_TYPE_MESSAGE, message, NULL));

    gst_element_post_message (GST_ELEMENT_CAST (bin), forwarded);
  }
}

static void
gst_bin_update_context (GstBin * bin, GstContext * context)
{
  GList *l;
  const gchar *context_type;

  GST_OBJECT_LOCK (bin);
  context_type = gst_context_get_context_type (context);
  for (l = bin->priv->contexts; l; l = l->next) {
    GstContext *tmp = l->data;
    const gchar *tmp_type = gst_context_get_context_type (tmp);

    /* Always store newest context but never replace
     * a persistent one by a non-persistent one */
    if (strcmp (context_type, tmp_type) == 0 &&
        (gst_context_is_persistent (context) ||
            !gst_context_is_persistent (tmp))) {
      gst_context_replace ((GstContext **) & l->data, context);
      break;
    }
  }
  /* Not found? Add */
  if (l == NULL)
    bin->priv->contexts =
        g_list_prepend (bin->priv->contexts, gst_context_ref (context));
  GST_OBJECT_UNLOCK (bin);
}

/* handle child messages:
 *
 * This method is called synchronously when a child posts a message on
 * the internal bus.
 *
 * GST_MESSAGE_EOS: This message is only posted by sinks
 *     in the PLAYING state. If all sinks posted the EOS message, post
 *     one upwards.
 *
 * GST_MESSAGE_STATE_DIRTY: Deprecated
 *
 * GST_MESSAGE_SEGMENT_START: just collect, never forward upwards. If an
 *     element posts segment_start twice, only the last message is kept.
 *
 * GST_MESSAGE_SEGMENT_DONE: replace SEGMENT_START message from same poster
 *     with the segment_done message. If there are no more segment_start
 *     messages, post segment_done message upwards.
 *
 * GST_MESSAGE_DURATION_CHANGED: clear any cached durations.
 *     Whenever someone performs a duration query on the bin, we store the
 *     result so we can answer it quicker the next time. Any element that
 *     changes its duration marks our cached values invalid.
 *     This message is also posted upwards. This is currently disabled
 *     because too many elements don't post DURATION_CHANGED messages when
 *     the duration changes.
 *
 * GST_MESSAGE_CLOCK_LOST: This message is posted by an element when it
 *     can no longer provide a clock. The default bin behaviour is to
 *     check if the lost clock was the one provided by the bin. If so and
 *     we are currently in the PLAYING state, we forward the message to
 *     our parent.
 *     This message is also generated when we remove a clock provider from
 *     a bin. If this message is received by the application, it should
 *     PAUSE the pipeline and set it back to PLAYING to force a new clock
 *     and a new base_time distribution.
 *
 * GST_MESSAGE_CLOCK_PROVIDE: This message is generated when an element
 *     can provide a clock. This mostly happens when we add a new clock
 *     provider to the bin. The default behaviour of the bin is to mark the
 *     currently selected clock as dirty, which will perform a clock
 *     recalculation the next time we are asked to provide a clock.
 *     This message is never sent to the application but is forwarded to
 *     the parent.
 *
 * GST_MESSAGE_ASYNC_START: Create an internal ELEMENT message that stores
 *     the state of the element and the fact that the element will need a
 *     new base_time. This message is not forwarded to the application.
 *
 * GST_MESSAGE_ASYNC_DONE: Find the internal ELEMENT message we kept for the
 *     element when it posted ASYNC_START. If all elements are done, post a
 *     ASYNC_DONE message to the parent.
 *
 * OTHER: post upwards.
 */
static void
gst_bin_handle_message_func (GstBin * bin, GstMessage * message)
{
  GstObject *src;
  GstMessageType type;
  GstMessage *tmessage;
  guint32 seqnum;

  src = GST_MESSAGE_SRC (message);
  type = GST_MESSAGE_TYPE (message);

  GST_DEBUG_OBJECT (bin, "[msg %p] handling child %s message of type %s",
      message, src ? GST_ELEMENT_NAME (src) : "(NULL)",
      GST_MESSAGE_TYPE_NAME (message));

  switch (type) {
    case GST_MESSAGE_ERROR:
    {
      GST_OBJECT_LOCK (bin);
      /* flag error */
      GST_DEBUG_OBJECT (bin, "got ERROR message, unlocking state change");
      GST_STATE_RETURN (bin) = GST_STATE_CHANGE_FAILURE;
      GST_STATE_BROADCAST (bin);
      GST_OBJECT_UNLOCK (bin);

      goto forward;
    }
    case GST_MESSAGE_EOS:
    {

      /* collect all eos messages from the children */
      bin_do_message_forward (bin, message);
      GST_OBJECT_LOCK (bin);
      /* ref message for future use  */
      bin_replace_message (bin, message, GST_MESSAGE_EOS);
      GST_OBJECT_UNLOCK (bin);

      bin_do_eos (bin);
      break;
    }
    case GST_MESSAGE_STREAM_START:
    {

      /* collect all stream_start messages from the children */
      GST_OBJECT_LOCK (bin);
      /* ref message for future use  */
      bin_replace_message (bin, message, GST_MESSAGE_STREAM_START);
      GST_OBJECT_UNLOCK (bin);

      bin_do_stream_start (bin);
      break;
    }
    case GST_MESSAGE_STATE_DIRTY:
    {
      GST_WARNING_OBJECT (bin, "received deprecated STATE_DIRTY message");

      /* free message */
      gst_message_unref (message);
      break;
    }
    case GST_MESSAGE_SEGMENT_START:{
      gboolean post = FALSE;
      GstFormat format;
      gint64 position;

      gst_message_parse_segment_start (message, &format, &position);
      seqnum = gst_message_get_seqnum (message);

      bin_do_message_forward (bin, message);

      GST_OBJECT_LOCK (bin);
      /* if this is the first segment-start, post to parent but not to the
       * application */
      if (!find_message (bin, NULL, GST_MESSAGE_SEGMENT_START) &&
          (GST_OBJECT_PARENT (bin) != NULL)) {
        post = TRUE;
      }
      /* replace any previous segment_start message from this source
       * with the new segment start message */
      bin_replace_message (bin, message, GST_MESSAGE_SEGMENT_START);
      GST_OBJECT_UNLOCK (bin);
      if (post) {
        tmessage = gst_message_new_segment_start (GST_OBJECT_CAST (bin),
            format, position);
        gst_message_set_seqnum (tmessage, seqnum);

        /* post segment start with initial format and position. */
        GST_DEBUG_OBJECT (bin, "posting SEGMENT_START (%u) bus message: %p",
            seqnum, message);
        gst_element_post_message (GST_ELEMENT_CAST (bin), tmessage);
      }
      break;
    }
    case GST_MESSAGE_SEGMENT_DONE:
    {
      gboolean post = FALSE;
      GstFormat format;
      gint64 position;

      gst_message_parse_segment_done (message, &format, &position);
      seqnum = gst_message_get_seqnum (message);

      bin_do_message_forward (bin, message);

      GST_OBJECT_LOCK (bin);
      bin_replace_message (bin, message, GST_MESSAGE_SEGMENT_START);
      /* if there are no more segment_start messages, everybody posted
       * a segment_done and we can post one on the bus. */

      /* we don't care who still has a pending segment start */
      if (!find_message (bin, NULL, GST_MESSAGE_SEGMENT_START)) {
        /* nothing found */
        post = TRUE;
        /* remove all old segment_done messages */
        bin_remove_messages (bin, NULL, GST_MESSAGE_SEGMENT_DONE);
      }
      GST_OBJECT_UNLOCK (bin);
      if (post) {
        tmessage = gst_message_new_segment_done (GST_OBJECT_CAST (bin),
            format, position);
        gst_message_set_seqnum (tmessage, seqnum);

        /* post segment done with latest format and position. */
        GST_DEBUG_OBJECT (bin, "posting SEGMENT_DONE (%u) bus message: %p",
            seqnum, message);
        gst_element_post_message (GST_ELEMENT_CAST (bin), tmessage);
      }
      break;
    }
    case GST_MESSAGE_DURATION_CHANGED:
    {
      /* FIXME: remove all cached durations, next time somebody asks
       * for duration, we will recalculate. */
#if 0
      GST_OBJECT_LOCK (bin);
      bin_remove_messages (bin, NULL, GST_MESSAGE_DURATION_CHANGED);
      GST_OBJECT_UNLOCK (bin);
#endif
      goto forward;
    }
    case GST_MESSAGE_CLOCK_LOST:
    {
      GstClock **provided_clock_p;
      GstElement **clock_provider_p;
      gboolean playing, toplevel, provided, forward;
      GstClock *clock;

      gst_message_parse_clock_lost (message, &clock);

      GST_OBJECT_LOCK (bin);
      bin->clock_dirty = TRUE;
      /* if we lost the clock that we provided, post to parent but
       * only if we are not a top-level bin or PLAYING.
       * The reason for this is that applications should be able
       * to PAUSE/PLAY if they receive this message without worrying
       * about the state of the pipeline. */
      provided = (clock == bin->provided_clock);
      playing = (GST_STATE (bin) == GST_STATE_PLAYING);
      toplevel = GST_OBJECT_PARENT (bin) == NULL;
      forward = provided && (playing || !toplevel);
      if (provided) {
        GST_DEBUG_OBJECT (bin,
            "Lost clock %" GST_PTR_FORMAT " provided by %" GST_PTR_FORMAT,
            bin->provided_clock, bin->clock_provider);
        provided_clock_p = &bin->provided_clock;
        clock_provider_p = &bin->clock_provider;
        gst_object_replace ((GstObject **) provided_clock_p, NULL);
        gst_object_replace ((GstObject **) clock_provider_p, NULL);
      }
      GST_DEBUG_OBJECT (bin, "provided %d, playing %d, forward %d",
          provided, playing, forward);
      GST_OBJECT_UNLOCK (bin);

      if (forward)
        goto forward;

      /* free message */
      gst_message_unref (message);
      break;
    }
    case GST_MESSAGE_CLOCK_PROVIDE:
    {
      gboolean forward;

      GST_OBJECT_LOCK (bin);
      bin->clock_dirty = TRUE;
      /* a new clock is available, post to parent but not
       * to the application */
      forward = GST_OBJECT_PARENT (bin) != NULL;
      GST_OBJECT_UNLOCK (bin);

      if (forward)
        goto forward;

      /* free message */
      gst_message_unref (message);
      break;
    }
    case GST_MESSAGE_ASYNC_START:
    {
      GstState target;

      GST_DEBUG_OBJECT (bin, "ASYNC_START message %p, %s", message,
          src ? GST_OBJECT_NAME (src) : "(NULL)");

      bin_do_message_forward (bin, message);

      GST_OBJECT_LOCK (bin);
      /* we ignore the message if we are going to <= READY */
      if ((target = GST_STATE_TARGET (bin)) <= GST_STATE_READY)
        goto ignore_start_message;

      /* takes ownership of the message */
      bin_replace_message (bin, message, GST_MESSAGE_ASYNC_START);

      bin_handle_async_start (bin);
      GST_OBJECT_UNLOCK (bin);
      break;

    ignore_start_message:
      {
        GST_DEBUG_OBJECT (bin, "ignoring message, target %s",
            gst_element_state_get_name (target));
        GST_OBJECT_UNLOCK (bin);
        gst_message_unref (message);
        break;
      }
    }
    case GST_MESSAGE_ASYNC_DONE:
    {
      GstClockTime running_time;
      GstState target;

      GST_DEBUG_OBJECT (bin, "ASYNC_DONE message %p, %s", message,
          src ? GST_OBJECT_NAME (src) : "(NULL)");

      gst_message_parse_async_done (message, &running_time);

      bin_do_message_forward (bin, message);

      GST_OBJECT_LOCK (bin);
      /* ignore messages if we are shutting down */
      if ((target = GST_STATE_TARGET (bin)) <= GST_STATE_READY)
        goto ignore_done_message;

      bin_replace_message (bin, message, GST_MESSAGE_ASYNC_START);
      /* if there are no more ASYNC_START messages, everybody posted
       * a ASYNC_DONE and we can post one on the bus. When checking, we
       * don't care who still has a pending ASYNC_START */
      if (!find_message (bin, NULL, GST_MESSAGE_ASYNC_START)) {
        /* nothing found, remove all old ASYNC_DONE messages */
        bin_remove_messages (bin, NULL, GST_MESSAGE_ASYNC_DONE);

        GST_DEBUG_OBJECT (bin, "async elements commited");
        /* when we get an async done message when a state change was busy, we
         * need to set the pending_done flag so that at the end of the state
         * change we can see if we need to verify pending async elements, hence
         * the TRUE argument here. */
        bin_handle_async_done (bin, GST_STATE_CHANGE_SUCCESS, TRUE,
            running_time);
      } else {
        GST_DEBUG_OBJECT (bin, "there are more async elements pending");
      }
      GST_OBJECT_UNLOCK (bin);
      break;

    ignore_done_message:
      {
        GST_DEBUG_OBJECT (bin, "ignoring message, target %s",
            gst_element_state_get_name (target));
        GST_OBJECT_UNLOCK (bin);
        gst_message_unref (message);
        break;
      }
    }
    case GST_MESSAGE_STRUCTURE_CHANGE:
    {
      gboolean busy;

      gst_message_parse_structure_change (message, NULL, NULL, &busy);

      GST_OBJECT_LOCK (bin);
      if (busy) {
        /* while the pad is busy, avoid following it when doing state changes.
         * Don't update the cookie yet, we will do that after the structure
         * change finished and we are ready to inspect the new updated
         * structure. */
        bin_replace_message (bin, message, GST_MESSAGE_STRUCTURE_CHANGE);
        message = NULL;
      } else {
        /* a pad link/unlink ended, signal the state change iterator that we
         * need to resync by updating the structure_cookie. */
        bin_remove_messages (bin, GST_MESSAGE_SRC (message),
            GST_MESSAGE_STRUCTURE_CHANGE);
        if (!GST_BIN_IS_NO_RESYNC (bin))
          bin->priv->structure_cookie++;
      }
      GST_OBJECT_UNLOCK (bin);

      if (message)
        gst_message_unref (message);

      break;
    }
    case GST_MESSAGE_NEED_CONTEXT:{
      const gchar *context_type;
      GList *l;

      gst_message_parse_context_type (message, &context_type);
      GST_OBJECT_LOCK (bin);
      for (l = bin->priv->contexts; l; l = l->next) {
        GstContext *tmp = l->data;
        const gchar *tmp_type = gst_context_get_context_type (tmp);

        if (strcmp (context_type, tmp_type) == 0) {
          gst_element_set_context (GST_ELEMENT (src), l->data);
          break;
        }
      }
      GST_OBJECT_UNLOCK (bin);

      /* Forward if we couldn't answer the message */
      if (l == NULL) {
        goto forward;
      } else {
        gst_message_unref (message);
      }

      break;
    }
    case GST_MESSAGE_HAVE_CONTEXT:{
      GstContext *context;

      gst_message_parse_have_context (message, &context);
      gst_bin_update_context (bin, context);
      gst_context_unref (context);

      goto forward;
      break;
    }
    default:
      goto forward;
  }
  return;

forward:
  {
    /* Send all other messages upward */
    GST_DEBUG_OBJECT (bin, "posting message upward");
    gst_element_post_message (GST_ELEMENT_CAST (bin), message);
    return;
  }
}

/* generic struct passed to all query fold methods */
typedef struct
{
  GstQuery *query;
  gint64 min;
  gint64 max;
  gboolean live;
} QueryFold;

typedef void (*QueryInitFunction) (GstBin * bin, QueryFold * fold);
typedef void (*QueryDoneFunction) (GstBin * bin, QueryFold * fold);

/* for duration/position we collect all durations/positions and take
 * the MAX of all valid results */
static void
bin_query_min_max_init (GstBin * bin, QueryFold * fold)
{
  fold->min = 0;
  fold->max = -1;
  fold->live = FALSE;
}

static gboolean
bin_query_duration_fold (const GValue * vitem, GValue * ret, QueryFold * fold)
{
  gboolean res = FALSE;
  GstObject *item = g_value_get_object (vitem);
  if (GST_IS_PAD (item))
    res = gst_pad_query (GST_PAD (item), fold->query);
  else
    res = gst_element_query (GST_ELEMENT (item), fold->query);

  if (res) {
    gint64 duration;

    g_value_set_boolean (ret, TRUE);

    gst_query_parse_duration (fold->query, NULL, &duration);

    GST_DEBUG_OBJECT (item, "got duration %" G_GINT64_FORMAT, duration);

    if (duration == -1) {
      /* duration query succeeded, but duration is unknown */
      fold->max = -1;
      return FALSE;
    }

    if (duration > fold->max)
      fold->max = duration;
  }

  return TRUE;
}

static void
bin_query_duration_done (GstBin * bin, QueryFold * fold)
{
  GstFormat format;

  gst_query_parse_duration (fold->query, &format, NULL);
  /* store max in query result */
  gst_query_set_duration (fold->query, format, fold->max);

  GST_DEBUG_OBJECT (bin, "max duration %" G_GINT64_FORMAT, fold->max);

  /* FIXME: re-implement duration caching */
#if 0
  /* and cache now */
  GST_OBJECT_LOCK (bin);
  bin->messages = g_list_prepend (bin->messages,
      gst_message_new_duration (GST_OBJECT_CAST (bin), format, fold->max));
  GST_OBJECT_UNLOCK (bin);
#endif
}

static gboolean
bin_query_position_fold (const GValue * vitem, GValue * ret, QueryFold * fold)
{
  gboolean res = FALSE;
  GstObject *item = g_value_get_object (vitem);
  if (GST_IS_PAD (item))
    res = gst_pad_query (GST_PAD (item), fold->query);
  else
    res = gst_element_query (GST_ELEMENT (item), fold->query);

  if (res) {
    gint64 position;

    g_value_set_boolean (ret, TRUE);

    gst_query_parse_position (fold->query, NULL, &position);

    GST_DEBUG_OBJECT (item, "got position %" G_GINT64_FORMAT, position);

    if (position > fold->max)
      fold->max = position;
  }

  return TRUE;
}

static void
bin_query_position_done (GstBin * bin, QueryFold * fold)
{
  GstFormat format;

  gst_query_parse_position (fold->query, &format, NULL);
  /* store max in query result */
  gst_query_set_position (fold->query, format, fold->max);

  GST_DEBUG_OBJECT (bin, "max position %" G_GINT64_FORMAT, fold->max);
}

static gboolean
bin_query_latency_fold (const GValue * vitem, GValue * ret, QueryFold * fold)
{
  gboolean res = FALSE;
  GstObject *item = g_value_get_object (vitem);
  if (GST_IS_PAD (item))
    res = gst_pad_query (GST_PAD (item), fold->query);
  else
    res = gst_element_query (GST_ELEMENT (item), fold->query);
  if (res) {
    GstClockTime min, max;
    gboolean live;

    gst_query_parse_latency (fold->query, &live, &min, &max);

    GST_DEBUG_OBJECT (item,
        "got latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
        ", live %d", GST_TIME_ARGS (min), GST_TIME_ARGS (max), live);

    /* for the combined latency we collect the MAX of all min latencies and
     * the MIN of all max latencies */
    if (live) {
      if (min > fold->min)
        fold->min = min;
      if (fold->max == -1)
        fold->max = max;
      else if (max < fold->max)
        fold->max = max;
      if (fold->live == FALSE)
        fold->live = live;
    }
  } else {
    g_value_set_boolean (ret, FALSE);
    GST_DEBUG_OBJECT (item, "failed query");
  }

  return TRUE;
}

static void
bin_query_latency_done (GstBin * bin, QueryFold * fold)
{
  /* store max in query result */
  gst_query_set_latency (fold->query, fold->live, fold->min, fold->max);

  GST_DEBUG_OBJECT (bin,
      "latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
      ", live %d", GST_TIME_ARGS (fold->min), GST_TIME_ARGS (fold->max),
      fold->live);
}

/* generic fold, return first valid result */
static gboolean
bin_query_generic_fold (const GValue * vitem, GValue * ret, QueryFold * fold)
{
  gboolean res = FALSE;
  GstObject *item = g_value_get_object (vitem);
  if (GST_IS_PAD (item))
    res = gst_pad_query (GST_PAD (item), fold->query);
  else
    res = gst_element_query (GST_ELEMENT (item), fold->query);
  if (res) {
    g_value_set_boolean (ret, TRUE);
    GST_DEBUG_OBJECT (item, "answered query %p", fold->query);
  }

  /* and stop as soon as we have a valid result */
  return !res;
}

/* Perform a query iteration for the given bin. The query is stored in
 * QueryFold and iter should be either a GstPad iterator or a
 * GstElement iterator. */
static gboolean
bin_iterate_fold (GstBin * bin, GstIterator * iter, QueryInitFunction fold_init,
    QueryDoneFunction fold_done, GstIteratorFoldFunction fold_func,
    QueryFold fold_data, gboolean default_return)
{
  gboolean res = default_return;
  GValue ret = { 0 };
  /* set the result of the query to FALSE initially */
  g_value_init (&ret, G_TYPE_BOOLEAN);
  g_value_set_boolean (&ret, res);

  while (TRUE) {
    GstIteratorResult ires;

    ires = gst_iterator_fold (iter, fold_func, &ret, &fold_data);

    switch (ires) {
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (iter);
        if (fold_init)
          fold_init (bin, &fold_data);
        g_value_set_boolean (&ret, res);
        break;
      case GST_ITERATOR_OK:
      case GST_ITERATOR_DONE:
        res = g_value_get_boolean (&ret);
        if (fold_done != NULL && res)
          fold_done (bin, &fold_data);
        goto done;
      default:
        res = FALSE;
        goto done;
    }
  }
done:
  return res;
}

static gboolean
gst_bin_query (GstElement * element, GstQuery * query)
{
  GstBin *bin = GST_BIN_CAST (element);
  GstIterator *iter;
  gboolean default_return = FALSE;
  gboolean res = FALSE;
  gboolean src_pads_query_result = FALSE;
  GstIteratorFoldFunction fold_func;
  QueryInitFunction fold_init = NULL;
  QueryDoneFunction fold_done = NULL;
  QueryFold fold_data;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_DURATION:
    {
      /* FIXME: implement duration caching in GstBin again */
#if 0
      GList *cached;
      GstFormat qformat;

      gst_query_parse_duration (query, &qformat, NULL);

      /* find cached duration query */
      GST_OBJECT_LOCK (bin);
      for (cached = bin->messages; cached; cached = g_list_next (cached)) {
        GstMessage *message = (GstMessage *) cached->data;

        if (GST_MESSAGE_TYPE (message) == GST_MESSAGE_DURATION_CHANGED &&
            GST_MESSAGE_SRC (message) == GST_OBJECT_CAST (bin)) {
          GstFormat format;
          gint64 duration;

          gst_message_parse_duration (message, &format, &duration);

          /* if cached same format, copy duration in query result */
          if (format == qformat) {
            GST_DEBUG_OBJECT (bin, "return cached duration %" G_GINT64_FORMAT,
                duration);
            GST_OBJECT_UNLOCK (bin);

            gst_query_set_duration (query, qformat, duration);
            res = TRUE;
            goto exit;
          }
        }
      }
      GST_OBJECT_UNLOCK (bin);
#else
      GST_FIXME ("implement duration caching in GstBin again");
#endif
      /* no cached value found, iterate and collect durations */
      fold_func = (GstIteratorFoldFunction) bin_query_duration_fold;
      fold_init = bin_query_min_max_init;
      fold_done = bin_query_duration_done;
      break;
    }
    case GST_QUERY_POSITION:
    {
      fold_func = (GstIteratorFoldFunction) bin_query_position_fold;
      fold_init = bin_query_min_max_init;
      fold_done = bin_query_position_done;
      break;
    }
    case GST_QUERY_LATENCY:
    {
      fold_func = (GstIteratorFoldFunction) bin_query_latency_fold;
      fold_init = bin_query_min_max_init;
      fold_done = bin_query_latency_done;
      default_return = TRUE;
      break;
    }
    default:
      fold_func = (GstIteratorFoldFunction) bin_query_generic_fold;
      break;
  }

  fold_data.query = query;

  iter = gst_bin_iterate_sinks (bin);
  GST_DEBUG_OBJECT (bin, "Sending query %p (type %s) to sink children",
      query, GST_QUERY_TYPE_NAME (query));

  if (fold_init)
    fold_init (bin, &fold_data);

  res =
      bin_iterate_fold (bin, iter, fold_init, fold_done, fold_func, fold_data,
      default_return);
  gst_iterator_free (iter);

  if (!res) {
    /* Query the source pads of the element */
    iter = gst_element_iterate_src_pads (element);
    src_pads_query_result =
        bin_iterate_fold (bin, iter, fold_init, fold_done, fold_func,
        fold_data, default_return);
    gst_iterator_free (iter);

    if (src_pads_query_result)
      res = TRUE;
  }

  GST_DEBUG_OBJECT (bin, "query %p result %d", query, res);

  return res;
}

static void
set_context (const GValue * item, gpointer user_data)
{
  GstElement *element = g_value_get_object (item);

  gst_element_set_context (element, user_data);
}

static void
gst_bin_set_context (GstElement * element, GstContext * context)
{
  GstBin *bin;
  GstIterator *children;

  g_return_if_fail (GST_IS_BIN (element));

  bin = GST_BIN (element);

  gst_bin_update_context (bin, context);

  children = gst_bin_iterate_elements (bin);
  while (gst_iterator_foreach (children, set_context,
          context) == GST_ITERATOR_RESYNC)
    gst_iterator_resync (children);
  gst_iterator_free (children);
}

static gint
compare_name (const GValue * velement, const gchar * name)
{
  gint eq;
  GstElement *element = g_value_get_object (velement);

  GST_OBJECT_LOCK (element);
  eq = strcmp (GST_ELEMENT_NAME (element), name);
  GST_OBJECT_UNLOCK (element);

  return eq;
}

/**
 * gst_bin_get_by_name:
 * @bin: a #GstBin
 * @name: the element name to search for
 *
 * Gets the element with the given name from a bin. This
 * function recurses into child bins.
 *
 * Returns %NULL if no element with the given name is found in the bin.
 *
 * MT safe.  Caller owns returned reference.
 *
 * Returns: (transfer full) (nullable): the #GstElement with the given
 * name, or %NULL
 */
GstElement *
gst_bin_get_by_name (GstBin * bin, const gchar * name)
{
  GstIterator *children;
  GValue result = { 0, };
  GstElement *element;
  gboolean found;

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);

  GST_CAT_INFO (GST_CAT_PARENTAGE, "[%s]: looking up child element %s",
      GST_ELEMENT_NAME (bin), name);

  children = gst_bin_iterate_recurse (bin);
  found = gst_iterator_find_custom (children,
      (GCompareFunc) compare_name, &result, (gpointer) name);
  gst_iterator_free (children);

  if (found) {
    element = g_value_dup_object (&result);
    g_value_unset (&result);
  } else {
    element = NULL;
  }

  return element;
}

/**
 * gst_bin_get_by_name_recurse_up:
 * @bin: a #GstBin
 * @name: the element name to search for
 *
 * Gets the element with the given name from this bin. If the
 * element is not found, a recursion is performed on the parent bin.
 *
 * Returns %NULL if:
 * - no element with the given name is found in the bin
 *
 * MT safe.  Caller owns returned reference.
 *
 * Returns: (transfer full) (nullable): the #GstElement with the given
 * name, or %NULL
 */
GstElement *
gst_bin_get_by_name_recurse_up (GstBin * bin, const gchar * name)
{
  GstElement *result;

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);
  g_return_val_if_fail (name != NULL, NULL);

  result = gst_bin_get_by_name (bin, name);

  if (!result) {
    GstObject *parent;

    parent = gst_object_get_parent (GST_OBJECT_CAST (bin));
    if (parent) {
      if (GST_IS_BIN (parent)) {
        result = gst_bin_get_by_name_recurse_up (GST_BIN_CAST (parent), name);
      }
      gst_object_unref (parent);
    }
  }

  return result;
}

static gint
compare_interface (const GValue * velement, GValue * interface)
{
  GstElement *element = g_value_get_object (velement);
  GType interface_type = (GType) g_value_get_pointer (interface);
  gint ret;

  if (G_TYPE_CHECK_INSTANCE_TYPE (element, interface_type)) {
    ret = 0;
  } else {
    ret = 1;
  }
  return ret;
}

/**
 * gst_bin_get_by_interface:
 * @bin: a #GstBin
 * @iface: the #GType of an interface
 *
 * Looks for an element inside the bin that implements the given
 * interface. If such an element is found, it returns the element.
 * You can cast this element to the given interface afterwards.  If you want
 * all elements that implement the interface, use
 * gst_bin_iterate_all_by_interface(). This function recurses into child bins.
 *
 * MT safe.  Caller owns returned reference.
 *
 * Returns: (transfer full): A #GstElement inside the bin implementing the interface
 */
GstElement *
gst_bin_get_by_interface (GstBin * bin, GType iface)
{
  GstIterator *children;
  GValue result = { 0, };
  GstElement *element;
  gboolean found;
  GValue viface = { 0, };

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);
  g_return_val_if_fail (G_TYPE_IS_INTERFACE (iface), NULL);

  g_value_init (&viface, G_TYPE_POINTER);
  g_value_set_pointer (&viface, (gpointer) iface);

  children = gst_bin_iterate_recurse (bin);
  found = gst_iterator_find_custom (children, (GCompareFunc) compare_interface,
      &result, &viface);
  gst_iterator_free (children);

  if (found) {
    element = g_value_dup_object (&result);
    g_value_unset (&result);
  } else {
    element = NULL;
  }
  g_value_unset (&viface);

  return element;
}

/**
 * gst_bin_iterate_all_by_interface:
 * @bin: a #GstBin
 * @iface: the #GType of an interface
 *
 * Looks for all elements inside the bin that implements the given
 * interface. You can safely cast all returned elements to the given interface.
 * The function recurses inside child bins. The iterator will yield a series
 * of #GstElement that should be unreffed after use.
 *
 * MT safe.  Caller owns returned value.
 *
 * Returns: (transfer full) (nullable): a #GstIterator of #GstElement
 *     for all elements in the bin implementing the given interface,
 *     or %NULL
 */
GstIterator *
gst_bin_iterate_all_by_interface (GstBin * bin, GType iface)
{
  GstIterator *children;
  GstIterator *result;
  GValue viface = { 0, };

  g_return_val_if_fail (GST_IS_BIN (bin), NULL);
  g_return_val_if_fail (G_TYPE_IS_INTERFACE (iface), NULL);

  g_value_init (&viface, G_TYPE_POINTER);
  g_value_set_pointer (&viface, (gpointer) iface);

  children = gst_bin_iterate_recurse (bin);
  result = gst_iterator_filter (children, (GCompareFunc) compare_interface,
      &viface);

  g_value_unset (&viface);

  return result;
}
