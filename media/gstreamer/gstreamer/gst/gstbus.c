/* GStreamer
 * Copyright (C) 2004 Wim Taymans <wim@fluendo.com>
 *
 * gstbus.c: GstBus subsystem
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
 * SECTION:gstbus
 * @short_description: Asynchronous message bus subsystem
 * @see_also: #GstMessage, #GstElement
 *
 * The #GstBus is an object responsible for delivering #GstMessage packets in
 * a first-in first-out way from the streaming threads (see #GstTask) to the
 * application.
 *
 * Since the application typically only wants to deal with delivery of these
 * messages from one thread, the GstBus will marshall the messages between
 * different threads. This is important since the actual streaming of media
 * is done in another thread than the application.
 *
 * The GstBus provides support for #GSource based notifications. This makes it
 * possible to handle the delivery in the glib mainloop.
 *
 * The #GSource callback function gst_bus_async_signal_func() can be used to
 * convert all bus messages into signal emissions.
 *
 * A message is posted on the bus with the gst_bus_post() method. With the
 * gst_bus_peek() and gst_bus_pop() methods one can look at or retrieve a
 * previously posted message.
 *
 * The bus can be polled with the gst_bus_poll() method. This methods blocks
 * up to the specified timeout value until one of the specified messages types
 * is posted on the bus. The application can then gst_bus_pop() the messages
 * from the bus to handle them.
 * Alternatively the application can register an asynchronous bus function
 * using gst_bus_add_watch_full() or gst_bus_add_watch(). This function will
 * install a #GSource in the default glib main loop and will deliver messages
 * a short while after they have been posted. Note that the main loop should
 * be running for the asynchronous callbacks.
 *
 * It is also possible to get messages from the bus without any thread
 * marshalling with the gst_bus_set_sync_handler() method. This makes it
 * possible to react to a message in the same thread that posted the
 * message on the bus. This should only be used if the application is able
 * to deal with messages from different threads.
 *
 * Every #GstPipeline has one bus.
 *
 * Note that a #GstPipeline will set its bus into flushing state when changing
 * from READY to NULL state.
 */

#include "gst_private.h"
#include <errno.h>
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif
#include <sys/types.h>

#include "gstatomicqueue.h"
#include "gstinfo.h"
#include "gstpoll.h"

#include "gstbus.h"
#include "glib-compat-private.h"

#define GST_CAT_DEFAULT GST_CAT_BUS
/* bus signals */
enum
{
  SYNC_MESSAGE,
  ASYNC_MESSAGE,
  /* add more above */
  LAST_SIGNAL
};

#define DEFAULT_ENABLE_ASYNC (TRUE)

enum
{
  PROP_0,
  PROP_ENABLE_ASYNC
};

static void gst_bus_dispose (GObject * object);
static void gst_bus_finalize (GObject * object);

static guint gst_bus_signals[LAST_SIGNAL] = { 0 };

struct _GstBusPrivate
{
  GstAtomicQueue *queue;
  GMutex queue_lock;

  GstBusSyncHandler sync_handler;
  gpointer sync_handler_data;
  GDestroyNotify sync_handler_notify;

  guint signal_watch_id;
  guint num_signal_watchers;

  guint num_sync_message_emitters;
  GSource *watch_id;

  gboolean enable_async;
  GstPoll *poll;
  GPollFD pollfd;
};

#define gst_bus_parent_class parent_class
G_DEFINE_TYPE (GstBus, gst_bus, GST_TYPE_OBJECT);

static void
gst_bus_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstBus *bus = GST_BUS_CAST (object);

  switch (prop_id) {
    case PROP_ENABLE_ASYNC:
      bus->priv->enable_async = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_bus_constructed (GObject * object)
{
  GstBus *bus = GST_BUS_CAST (object);

  if (bus->priv->enable_async) {
    bus->priv->poll = gst_poll_new_timer ();
    gst_poll_get_read_gpollfd (bus->priv->poll, &bus->priv->pollfd);
  }
}

static void
gst_bus_class_init (GstBusClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->dispose = gst_bus_dispose;
  gobject_class->finalize = gst_bus_finalize;
  gobject_class->set_property = gst_bus_set_property;
  gobject_class->constructed = gst_bus_constructed;

  /**
   * GstBus::enable-async:
   *
   * Enable async message delivery support for bus watches,
   * gst_bus_pop() and similar API. Without this only the
   * synchronous message handlers are called.
   *
   * This property is used to create the child element buses
   * in #GstBin.
   */
  g_object_class_install_property (gobject_class, PROP_ENABLE_ASYNC,
      g_param_spec_boolean ("enable-async", "Enable Async",
          "Enable async message delivery for bus watches and gst_bus_pop()",
          DEFAULT_ENABLE_ASYNC,
          G_PARAM_CONSTRUCT_ONLY | G_PARAM_WRITABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstBus::sync-message:
   * @bus: the object which received the signal
   * @message: the message that has been posted synchronously
   *
   * A message has been posted on the bus. This signal is emitted from the
   * thread that posted the message so one has to be careful with locking.
   *
   * This signal will not be emitted by default, you have to call
   * gst_bus_enable_sync_message_emission() before.
   */
  gst_bus_signals[SYNC_MESSAGE] =
      g_signal_new ("sync-message", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_DETAILED,
      G_STRUCT_OFFSET (GstBusClass, sync_message), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_MESSAGE);

  /**
   * GstBus::message:
   * @bus: the object which received the signal
   * @message: the message that has been posted asynchronously
   *
   * A message has been posted on the bus. This signal is emitted from a
   * GSource added to the mainloop. this signal will only be emitted when
   * there is a mainloop running.
   */
  gst_bus_signals[ASYNC_MESSAGE] =
      g_signal_new ("message", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_DETAILED,
      G_STRUCT_OFFSET (GstBusClass, message), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_MESSAGE);

  g_type_class_add_private (klass, sizeof (GstBusPrivate));
}

static void
gst_bus_init (GstBus * bus)
{
  bus->priv = G_TYPE_INSTANCE_GET_PRIVATE (bus, GST_TYPE_BUS, GstBusPrivate);
  bus->priv->enable_async = DEFAULT_ENABLE_ASYNC;
  g_mutex_init (&bus->priv->queue_lock);
  bus->priv->queue = gst_atomic_queue_new (32);

  /* clear floating flag */
  gst_object_ref_sink (bus);

  GST_DEBUG_OBJECT (bus, "created");
}

static void
gst_bus_dispose (GObject * object)
{
  GstBus *bus = GST_BUS (object);

  if (bus->priv->queue) {
    GstMessage *message;

    g_mutex_lock (&bus->priv->queue_lock);
    do {
      message = gst_atomic_queue_pop (bus->priv->queue);
      if (message)
        gst_message_unref (message);
    } while (message != NULL);
    gst_atomic_queue_unref (bus->priv->queue);
    bus->priv->queue = NULL;
    g_mutex_unlock (&bus->priv->queue_lock);
    g_mutex_clear (&bus->priv->queue_lock);

    if (bus->priv->poll)
      gst_poll_free (bus->priv->poll);
    bus->priv->poll = NULL;
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_bus_finalize (GObject * object)
{
  GstBus *bus = GST_BUS (object);

  if (bus->priv->sync_handler_notify)
    bus->priv->sync_handler_notify (bus->priv->sync_handler_data);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/**
 * gst_bus_new:
 *
 * Creates a new #GstBus instance.
 *
 * Returns: (transfer full): a new #GstBus instance
 */
GstBus *
gst_bus_new (void)
{
  GstBus *result;

  result = g_object_newv (gst_bus_get_type (), 0, NULL);
  GST_DEBUG_OBJECT (result, "created new bus");

  return result;
}

/**
 * gst_bus_post:
 * @bus: a #GstBus to post on
 * @message: (transfer full): the #GstMessage to post
 *
 * Post a message on the given bus. Ownership of the message
 * is taken by the bus.
 *
 * Returns: %TRUE if the message could be posted, %FALSE if the bus is flushing.
 *
 * MT safe.
 */
gboolean
gst_bus_post (GstBus * bus, GstMessage * message)
{
  GstBusSyncReply reply = GST_BUS_PASS;
  GstBusSyncHandler handler;
  gboolean emit_sync_message;
  gpointer handler_data;

  g_return_val_if_fail (GST_IS_BUS (bus), FALSE);
  g_return_val_if_fail (GST_IS_MESSAGE (message), FALSE);

  GST_DEBUG_OBJECT (bus, "[msg %p] posting on bus %" GST_PTR_FORMAT, message,
      message);

  GST_OBJECT_LOCK (bus);
  /* check if the bus is flushing */
  if (GST_OBJECT_FLAG_IS_SET (bus, GST_BUS_FLUSHING))
    goto is_flushing;

  handler = bus->priv->sync_handler;
  handler_data = bus->priv->sync_handler_data;
  emit_sync_message = bus->priv->num_sync_message_emitters > 0;
  GST_OBJECT_UNLOCK (bus);

  /* first call the sync handler if it is installed */
  if (handler)
    reply = handler (bus, message, handler_data);

  /* emit sync-message if requested to do so via
     gst_bus_enable_sync_message_emission. terrible but effective */
  if (emit_sync_message && reply != GST_BUS_DROP
      && handler != gst_bus_sync_signal_handler)
    gst_bus_sync_signal_handler (bus, message, NULL);

  /* If this is a bus without async message delivery
   * always drop the message */
  if (!bus->priv->poll)
    reply = GST_BUS_DROP;

  /* now see what we should do with the message */
  switch (reply) {
    case GST_BUS_DROP:
      /* drop the message */
      GST_DEBUG_OBJECT (bus, "[msg %p] dropped", message);
      break;
    case GST_BUS_PASS:
      /* pass the message to the async queue, refcount passed in the queue */
      GST_DEBUG_OBJECT (bus, "[msg %p] pushing on async queue", message);
      gst_atomic_queue_push (bus->priv->queue, message);
      gst_poll_write_control (bus->priv->poll);
      GST_DEBUG_OBJECT (bus, "[msg %p] pushed on async queue", message);

      break;
    case GST_BUS_ASYNC:
    {
      /* async delivery, we need a mutex and a cond to block
       * on */
      GCond *cond = GST_MESSAGE_GET_COND (message);
      GMutex *lock = GST_MESSAGE_GET_LOCK (message);

      g_cond_init (cond);
      g_mutex_init (lock);

      GST_DEBUG_OBJECT (bus, "[msg %p] waiting for async delivery", message);

      /* now we lock the message mutex, send the message to the async
       * queue. When the message is handled by the app and destroyed,
       * the cond will be signalled and we can continue */
      g_mutex_lock (lock);

      gst_atomic_queue_push (bus->priv->queue, message);
      gst_poll_write_control (bus->priv->poll);

      /* now block till the message is freed */
      g_cond_wait (cond, lock);
      g_mutex_unlock (lock);

      GST_DEBUG_OBJECT (bus, "[msg %p] delivered asynchronously", message);

      g_mutex_clear (lock);
      g_cond_clear (cond);
      break;
    }
    default:
      g_warning ("invalid return from bus sync handler");
      break;
  }
  return TRUE;

  /* ERRORS */
is_flushing:
  {
    GST_DEBUG_OBJECT (bus, "bus is flushing");
    gst_message_unref (message);
    GST_OBJECT_UNLOCK (bus);

    return FALSE;
  }
}

/**
 * gst_bus_have_pending:
 * @bus: a #GstBus to check
 *
 * Check if there are pending messages on the bus that
 * should be handled.
 *
 * Returns: %TRUE if there are messages on the bus to be handled, %FALSE
 * otherwise.
 *
 * MT safe.
 */
gboolean
gst_bus_have_pending (GstBus * bus)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_BUS (bus), FALSE);

  /* see if there is a message on the bus */
  result = gst_atomic_queue_length (bus->priv->queue) != 0;

  return result;
}

/**
 * gst_bus_set_flushing:
 * @bus: a #GstBus
 * @flushing: whether or not to flush the bus
 *
 * If @flushing, flush out and unref any messages queued in the bus. Releases
 * references to the message origin objects. Will flush future messages until
 * gst_bus_set_flushing() sets @flushing to %FALSE.
 *
 * MT safe.
 */
void
gst_bus_set_flushing (GstBus * bus, gboolean flushing)
{
  GstMessage *message;

  GST_OBJECT_LOCK (bus);

  if (flushing) {
    GST_OBJECT_FLAG_SET (bus, GST_BUS_FLUSHING);

    GST_DEBUG_OBJECT (bus, "set bus flushing");

    while ((message = gst_bus_pop (bus)))
      gst_message_unref (message);
  } else {
    GST_DEBUG_OBJECT (bus, "unset bus flushing");
    GST_OBJECT_FLAG_UNSET (bus, GST_BUS_FLUSHING);
  }

  GST_OBJECT_UNLOCK (bus);
}

/**
 * gst_bus_timed_pop_filtered:
 * @bus: a #GstBus to pop from
 * @timeout: a timeout in nanoseconds, or GST_CLOCK_TIME_NONE to wait forever
 * @types: message types to take into account, GST_MESSAGE_ANY for any type
 *
 * Get a message from the bus whose type matches the message type mask @types,
 * waiting up to the specified timeout (and discarding any messages that do not
 * match the mask provided).
 *
 * If @timeout is 0, this function behaves like gst_bus_pop_filtered(). If
 * @timeout is #GST_CLOCK_TIME_NONE, this function will block forever until a
 * matching message was posted on the bus.
 *
 * Returns: (transfer full) (nullable): a #GstMessage matching the
 *     filter in @types, or %NULL if no matching message was found on
 *     the bus until the timeout expired. The message is taken from
 *     the bus and needs to be unreffed with gst_message_unref() after
 *     usage.
 *
 * MT safe.
 */
GstMessage *
gst_bus_timed_pop_filtered (GstBus * bus, GstClockTime timeout,
    GstMessageType types)
{
  GstMessage *message;
  GTimeVal now, then;
  gboolean first_round = TRUE;
  GstClockTime elapsed = 0;

  g_return_val_if_fail (GST_IS_BUS (bus), NULL);
  g_return_val_if_fail (types != 0, NULL);
  g_return_val_if_fail (timeout == 0 || bus->priv->poll != NULL, NULL);

  g_mutex_lock (&bus->priv->queue_lock);

  while (TRUE) {
    gint ret;

    GST_LOG_OBJECT (bus, "have %d messages",
        gst_atomic_queue_length (bus->priv->queue));

    while ((message = gst_atomic_queue_pop (bus->priv->queue))) {
      if (bus->priv->poll)
        gst_poll_read_control (bus->priv->poll);

      GST_DEBUG_OBJECT (bus, "got message %p, %s from %s, type mask is %u",
          message, GST_MESSAGE_TYPE_NAME (message),
          GST_MESSAGE_SRC_NAME (message), (guint) types);
      if ((GST_MESSAGE_TYPE (message) & types) != 0) {
        /* Extra check to ensure extended types don't get matched unless
         * asked for */
        if ((GST_MESSAGE_TYPE_IS_EXTENDED (message) == FALSE)
            || (types & GST_MESSAGE_EXTENDED)) {
          /* exit the loop, we have a message */
          goto beach;
        }
      }

      GST_DEBUG_OBJECT (bus, "discarding message, does not match mask");
      gst_message_unref (message);
      message = NULL;
    }

    /* no need to wait, exit loop */
    if (timeout == 0)
      break;

    else if (timeout != GST_CLOCK_TIME_NONE) {
      if (first_round) {
        g_get_current_time (&then);
        first_round = FALSE;
      } else {
        g_get_current_time (&now);

        elapsed = GST_TIMEVAL_TO_TIME (now) - GST_TIMEVAL_TO_TIME (then);

        if (elapsed > timeout)
          break;
      }
    }

    /* only here in timeout case */
    g_assert (bus->priv->poll);
    g_mutex_unlock (&bus->priv->queue_lock);
    ret = gst_poll_wait (bus->priv->poll, timeout - elapsed);
    g_mutex_lock (&bus->priv->queue_lock);

    if (ret == 0) {
      GST_INFO_OBJECT (bus, "timed out, breaking loop");
      break;
    } else {
      GST_INFO_OBJECT (bus, "we got woken up, recheck for message");
    }
  }

beach:

  g_mutex_unlock (&bus->priv->queue_lock);

  return message;
}


/**
 * gst_bus_timed_pop:
 * @bus: a #GstBus to pop
 * @timeout: a timeout
 *
 * Get a message from the bus, waiting up to the specified timeout.
 *
 * If @timeout is 0, this function behaves like gst_bus_pop(). If @timeout is
 * #GST_CLOCK_TIME_NONE, this function will block forever until a message was
 * posted on the bus.
 *
 * Returns: (transfer full) (nullable): the #GstMessage that is on the
 *     bus after the specified timeout or %NULL if the bus is empty
 *     after the timeout expired.  The message is taken from the bus
 *     and needs to be unreffed with gst_message_unref() after usage.
 *
 * MT safe.
 */
GstMessage *
gst_bus_timed_pop (GstBus * bus, GstClockTime timeout)
{
  g_return_val_if_fail (GST_IS_BUS (bus), NULL);

  return gst_bus_timed_pop_filtered (bus, timeout, GST_MESSAGE_ANY);
}

/**
 * gst_bus_pop_filtered:
 * @bus: a #GstBus to pop
 * @types: message types to take into account
 *
 * Get a message matching @type from the bus.  Will discard all messages on
 * the bus that do not match @type and that have been posted before the first
 * message that does match @type.  If there is no message matching @type on
 * the bus, all messages will be discarded. It is not possible to use message
 * enums beyond #GST_MESSAGE_EXTENDED in the @events mask.
 *
 * Returns: (transfer full) (nullable): the next #GstMessage matching
 *     @type that is on the bus, or %NULL if the bus is empty or there
 *     is no message matching @type. The message is taken from the bus
 *     and needs to be unreffed with gst_message_unref() after usage.
 *
 * MT safe.
 */
GstMessage *
gst_bus_pop_filtered (GstBus * bus, GstMessageType types)
{
  g_return_val_if_fail (GST_IS_BUS (bus), NULL);
  g_return_val_if_fail (types != 0, NULL);

  return gst_bus_timed_pop_filtered (bus, 0, types);
}

/**
 * gst_bus_pop:
 * @bus: a #GstBus to pop
 *
 * Get a message from the bus.
 *
 * Returns: (transfer full) (nullable): the #GstMessage that is on the
 *     bus, or %NULL if the bus is empty. The message is taken from
 *     the bus and needs to be unreffed with gst_message_unref() after
 *     usage.
 *
 * MT safe.
 */
GstMessage *
gst_bus_pop (GstBus * bus)
{
  g_return_val_if_fail (GST_IS_BUS (bus), NULL);

  return gst_bus_timed_pop_filtered (bus, 0, GST_MESSAGE_ANY);
}

/**
 * gst_bus_peek:
 * @bus: a #GstBus
 *
 * Peek the message on the top of the bus' queue. The message will remain
 * on the bus' message queue. A reference is returned, and needs to be unreffed
 * by the caller.
 *
 * Returns: (transfer full) (nullable): the #GstMessage that is on the
 *     bus, or %NULL if the bus is empty.
 *
 * MT safe.
 */
GstMessage *
gst_bus_peek (GstBus * bus)
{
  GstMessage *message;

  g_return_val_if_fail (GST_IS_BUS (bus), NULL);

  g_mutex_lock (&bus->priv->queue_lock);
  message = gst_atomic_queue_peek (bus->priv->queue);
  if (message)
    gst_message_ref (message);
  g_mutex_unlock (&bus->priv->queue_lock);

  GST_DEBUG_OBJECT (bus, "peek on bus, got message %p", message);

  return message;
}

/**
 * gst_bus_set_sync_handler:
 * @bus: a #GstBus to install the handler on
 * @func: (allow-none): The handler function to install
 * @user_data: User data that will be sent to the handler function.
 * @notify: called when @user_data becomes unused
 *
 * Sets the synchronous handler on the bus. The function will be called
 * every time a new message is posted on the bus. Note that the function
 * will be called in the same thread context as the posting object. This
 * function is usually only called by the creator of the bus. Applications
 * should handle messages asynchronously using the gst_bus watch and poll
 * functions.
 *
 * You cannot replace an existing sync_handler. You can pass %NULL to this
 * function, which will clear the existing handler.
 */
void
gst_bus_set_sync_handler (GstBus * bus, GstBusSyncHandler func,
    gpointer user_data, GDestroyNotify notify)
{
  GDestroyNotify old_notify;

  g_return_if_fail (GST_IS_BUS (bus));

  GST_OBJECT_LOCK (bus);
  /* Assert if the user attempts to replace an existing sync_handler,
   * other than to clear it */
  if (func != NULL && bus->priv->sync_handler != NULL)
    goto no_replace;

  if ((old_notify = bus->priv->sync_handler_notify)) {
    gpointer old_data = bus->priv->sync_handler_data;

    bus->priv->sync_handler_data = NULL;
    bus->priv->sync_handler_notify = NULL;
    GST_OBJECT_UNLOCK (bus);

    old_notify (old_data);

    GST_OBJECT_LOCK (bus);
  }
  bus->priv->sync_handler = func;
  bus->priv->sync_handler_data = user_data;
  bus->priv->sync_handler_notify = notify;
  GST_OBJECT_UNLOCK (bus);

  return;

no_replace:
  {
    GST_OBJECT_UNLOCK (bus);
    g_warning ("cannot replace existing sync handler");
    return;
  }
}

/* GSource for the bus
 */
typedef struct
{
  GSource source;
  GstBus *bus;
} GstBusSource;

static gboolean
gst_bus_source_prepare (GSource * source, gint * timeout)
{
  *timeout = -1;
  return FALSE;
}

static gboolean
gst_bus_source_check (GSource * source)
{
  GstBusSource *bsrc = (GstBusSource *) source;

  return bsrc->bus->priv->pollfd.revents & (G_IO_IN | G_IO_HUP | G_IO_ERR);
}

static gboolean
gst_bus_source_dispatch (GSource * source, GSourceFunc callback,
    gpointer user_data)
{
  GstBusFunc handler = (GstBusFunc) callback;
  GstBusSource *bsource = (GstBusSource *) source;
  GstMessage *message;
  gboolean keep;
  GstBus *bus;

  g_return_val_if_fail (bsource != NULL, FALSE);

  bus = bsource->bus;

  g_return_val_if_fail (GST_IS_BUS (bus), FALSE);

  message = gst_bus_pop (bus);

  /* The message queue might be empty if some other thread or callback set
   * the bus to flushing between check/prepare and dispatch */
  if (G_UNLIKELY (message == NULL))
    return TRUE;

  if (!handler)
    goto no_handler;

  GST_DEBUG_OBJECT (bus, "source %p calling dispatch with %" GST_PTR_FORMAT,
      source, message);

  keep = handler (bus, message, user_data);
  gst_message_unref (message);

  GST_DEBUG_OBJECT (bus, "source %p handler returns %d", source, keep);

  return keep;

no_handler:
  {
    g_warning ("GstBus watch dispatched without callback\n"
        "You must call g_source_set_callback().");
    gst_message_unref (message);
    return FALSE;
  }
}

static void
gst_bus_source_finalize (GSource * source)
{
  GstBusSource *bsource = (GstBusSource *) source;
  GstBus *bus;

  bus = bsource->bus;

  GST_DEBUG_OBJECT (bus, "finalize source %p", source);

  GST_OBJECT_LOCK (bus);
  if (bus->priv->watch_id == source)
    bus->priv->watch_id = NULL;
  GST_OBJECT_UNLOCK (bus);

  gst_object_unref (bsource->bus);
  bsource->bus = NULL;
}

static GSourceFuncs gst_bus_source_funcs = {
  gst_bus_source_prepare,
  gst_bus_source_check,
  gst_bus_source_dispatch,
  gst_bus_source_finalize
};

/**
 * gst_bus_create_watch:
 * @bus: a #GstBus to create the watch for
 *
 * Create watch for this bus. The GSource will be dispatched whenever
 * a message is on the bus. After the GSource is dispatched, the
 * message is popped off the bus and unreffed.
 *
 * Returns: (transfer full): a #GSource that can be added to a mainloop.
 */
GSource *
gst_bus_create_watch (GstBus * bus)
{
  GstBusSource *source;

  g_return_val_if_fail (GST_IS_BUS (bus), NULL);
  g_return_val_if_fail (bus->priv->poll != NULL, NULL);

  source = (GstBusSource *) g_source_new (&gst_bus_source_funcs,
      sizeof (GstBusSource));

  g_source_set_name ((GSource *) source, "GStreamer message bus watch");

  source->bus = gst_object_ref (bus);
  g_source_add_poll ((GSource *) source, &bus->priv->pollfd);

  return (GSource *) source;
}

/* must be called with the bus OBJECT LOCK */
static guint
gst_bus_add_watch_full_unlocked (GstBus * bus, gint priority,
    GstBusFunc func, gpointer user_data, GDestroyNotify notify)
{
  GMainContext *ctx;
  guint id;
  GSource *source;

  if (bus->priv->watch_id) {
    GST_ERROR_OBJECT (bus,
        "Tried to add new watch while one was already there");
    return 0;
  }

  source = gst_bus_create_watch (bus);

  if (priority != G_PRIORITY_DEFAULT)
    g_source_set_priority (source, priority);

  g_source_set_callback (source, (GSourceFunc) func, user_data, notify);

  ctx = g_main_context_get_thread_default ();
  id = g_source_attach (source, ctx);
  g_source_unref (source);

  if (id) {
    bus->priv->watch_id = source;
  }

  GST_DEBUG_OBJECT (bus, "New source %p with id %u", source, id);
  return id;
}

/**
 * gst_bus_add_watch_full:
 * @bus: a #GstBus to create the watch for.
 * @priority: The priority of the watch.
 * @func: A function to call when a message is received.
 * @user_data: user data passed to @func.
 * @notify: the function to call when the source is removed.
 *
 * Adds a bus watch to the default main context with the given @priority (e.g.
 * %G_PRIORITY_DEFAULT). It is also possible to use a non-default  main
 * context set up using g_main_context_push_thread_default() (before
 * one had to create a bus watch source and attach it to the desired main
 * context 'manually').
 *
 * This function is used to receive asynchronous messages in the main loop.
 * There can only be a single bus watch per bus, you must remove it before you
 * can set a new one.
 *
 * When @func is called, the message belongs to the caller; if you want to
 * keep a copy of it, call gst_message_ref() before leaving @func.
 *
 * The watch can be removed using g_source_remove() or by returning %FALSE
 * from @func.
 *
 * MT safe.
 *
 * Returns: The event source id.
 * Rename to: gst_bus_add_watch
 */
guint
gst_bus_add_watch_full (GstBus * bus, gint priority,
    GstBusFunc func, gpointer user_data, GDestroyNotify notify)
{
  guint id;

  g_return_val_if_fail (GST_IS_BUS (bus), 0);

  GST_OBJECT_LOCK (bus);
  id = gst_bus_add_watch_full_unlocked (bus, priority, func, user_data, notify);
  GST_OBJECT_UNLOCK (bus);

  return id;
}

/**
 * gst_bus_add_watch: (skip)
 * @bus: a #GstBus to create the watch for
 * @func: A function to call when a message is received.
 * @user_data: user data passed to @func.
 *
 * Adds a bus watch to the default main context with the default priority
 * (%G_PRIORITY_DEFAULT). It is also possible to use a non-default main
 * context set up using g_main_context_push_thread_default() (before
 * one had to create a bus watch source and attach it to the desired main
 * context 'manually').
 *
 * This function is used to receive asynchronous messages in the main loop.
 * There can only be a single bus watch per bus, you must remove it before you
 * can set a new one.
 *
 * The watch can be removed using g_source_remove() or by returning %FALSE
 * from @func.
 *
 * Returns: The event source id.
 *
 * MT safe.
 */
guint
gst_bus_add_watch (GstBus * bus, GstBusFunc func, gpointer user_data)
{
  return gst_bus_add_watch_full (bus, G_PRIORITY_DEFAULT, func,
      user_data, NULL);
}

typedef struct
{
  GMainLoop *loop;
  guint timeout_id;
  gboolean source_running;
  GstMessageType events;
  GstMessage *message;
} GstBusPollData;

static void
poll_func (GstBus * bus, GstMessage * message, GstBusPollData * poll_data)
{
  GstMessageType type;

  if (!g_main_loop_is_running (poll_data->loop)) {
    GST_DEBUG ("mainloop %p not running", poll_data->loop);
    return;
  }

  type = GST_MESSAGE_TYPE (message);

  if (type & poll_data->events) {
    g_assert (poll_data->message == NULL);
    /* keep ref to message */
    poll_data->message = gst_message_ref (message);
    GST_DEBUG ("mainloop %p quit", poll_data->loop);
    g_main_loop_quit (poll_data->loop);
  } else {
    GST_DEBUG ("type %08x does not match %08x", type, poll_data->events);
  }
}

static gboolean
poll_timeout (GstBusPollData * poll_data)
{
  GST_DEBUG ("mainloop %p quit", poll_data->loop);
  g_main_loop_quit (poll_data->loop);

  /* we don't remove the GSource as this would free our poll_data,
   * which we still need */
  return TRUE;
}

static void
poll_destroy (GstBusPollData * poll_data, gpointer unused)
{
  poll_data->source_running = FALSE;
  if (!poll_data->timeout_id) {
    g_main_loop_unref (poll_data->loop);
    g_slice_free (GstBusPollData, poll_data);
  }
}

static void
poll_destroy_timeout (GstBusPollData * poll_data)
{
  poll_data->timeout_id = 0;
  if (!poll_data->source_running) {
    g_main_loop_unref (poll_data->loop);
    g_slice_free (GstBusPollData, poll_data);
  }
}

/**
 * gst_bus_poll:
 * @bus: a #GstBus
 * @events: a mask of #GstMessageType, representing the set of message types to
 * poll for (note special handling of extended message types below)
 * @timeout: the poll timeout, as a #GstClockTime, or #GST_CLOCK_TIME_NONE to poll
 * indefinitely.
 *
 * Poll the bus for messages. Will block while waiting for messages to come.
 * You can specify a maximum time to poll with the @timeout parameter. If
 * @timeout is negative, this function will block indefinitely.
 *
 * All messages not in @events will be popped off the bus and will be ignored.
 * It is not possible to use message enums beyond #GST_MESSAGE_EXTENDED in the
 * @events mask
 *
 * Because poll is implemented using the "message" signal enabled by
 * gst_bus_add_signal_watch(), calling gst_bus_poll() will cause the "message"
 * signal to be emitted for every message that poll sees. Thus a "message"
 * signal handler will see the same messages that this function sees -- neither
 * will steal messages from the other.
 *
 * This function will run a main loop from the default main context when
 * polling.
 *
 * You should never use this function, since it is pure evil. This is
 * especially true for GUI applications based on Gtk+ or Qt, but also for any
 * other non-trivial application that uses the GLib main loop. As this function
 * runs a GLib main loop, any callback attached to the default GLib main
 * context may be invoked. This could be timeouts, GUI events, I/O events etc.;
 * even if gst_bus_poll() is called with a 0 timeout. Any of these callbacks
 * may do things you do not expect, e.g. destroy the main application window or
 * some other resource; change other application state; display a dialog and
 * run another main loop until the user clicks it away. In short, using this
 * function may add a lot of complexity to your code through unexpected
 * re-entrancy and unexpected changes to your application's state.
 *
 * For 0 timeouts use gst_bus_pop_filtered() instead of this function; for
 * other short timeouts use gst_bus_timed_pop_filtered(); everything else is
 * better handled by setting up an asynchronous bus watch and doing things
 * from there.
 *
 * Returns: (transfer full) (nullable): the message that was received,
 *     or %NULL if the poll timed out. The message is taken from the
 *     bus and needs to be unreffed with gst_message_unref() after
 *     usage.
 */
GstMessage *
gst_bus_poll (GstBus * bus, GstMessageType events, GstClockTime timeout)
{
  GstBusPollData *poll_data;
  GstMessage *ret;
  gulong id;

  poll_data = g_slice_new (GstBusPollData);
  poll_data->source_running = TRUE;
  poll_data->loop = g_main_loop_new (NULL, FALSE);
  poll_data->events = events;
  poll_data->message = NULL;

  if (timeout != GST_CLOCK_TIME_NONE)
    poll_data->timeout_id = g_timeout_add_full (G_PRIORITY_DEFAULT_IDLE,
        timeout / GST_MSECOND, (GSourceFunc) poll_timeout, poll_data,
        (GDestroyNotify) poll_destroy_timeout);
  else
    poll_data->timeout_id = 0;

  id = g_signal_connect_data (bus, "message", G_CALLBACK (poll_func), poll_data,
      (GClosureNotify) poll_destroy, 0);

  /* these can be nested, so it's ok */
  gst_bus_add_signal_watch (bus);

  GST_DEBUG ("running mainloop %p", poll_data->loop);
  g_main_loop_run (poll_data->loop);
  GST_DEBUG ("mainloop stopped %p", poll_data->loop);

  gst_bus_remove_signal_watch (bus);

  /* holds a ref */
  ret = poll_data->message;

  if (poll_data->timeout_id)
    g_source_remove (poll_data->timeout_id);

  /* poll_data will be freed now */
  g_signal_handler_disconnect (bus, id);

  GST_DEBUG_OBJECT (bus, "finished poll with message %p", ret);

  return ret;
}

/**
 * gst_bus_async_signal_func:
 * @bus: a #GstBus
 * @message: the #GstMessage received
 * @data: user data
 *
 * A helper #GstBusFunc that can be used to convert all asynchronous messages
 * into signals.
 *
 * Returns: %TRUE
 */
gboolean
gst_bus_async_signal_func (GstBus * bus, GstMessage * message, gpointer data)
{
  GQuark detail = 0;

  g_return_val_if_fail (GST_IS_BUS (bus), TRUE);
  g_return_val_if_fail (message != NULL, TRUE);

  detail = gst_message_type_to_quark (GST_MESSAGE_TYPE (message));

  g_signal_emit (bus, gst_bus_signals[ASYNC_MESSAGE], detail, message);

  /* we never remove this source based on signal emission return values */
  return TRUE;
}

/**
 * gst_bus_sync_signal_handler:
 * @bus: a #GstBus
 * @message: the #GstMessage received
 * @data: user data
 *
 * A helper GstBusSyncHandler that can be used to convert all synchronous
 * messages into signals.
 *
 * Returns: GST_BUS_PASS
 */
GstBusSyncReply
gst_bus_sync_signal_handler (GstBus * bus, GstMessage * message, gpointer data)
{
  GQuark detail = 0;

  g_return_val_if_fail (GST_IS_BUS (bus), GST_BUS_DROP);
  g_return_val_if_fail (message != NULL, GST_BUS_DROP);

  detail = gst_message_type_to_quark (GST_MESSAGE_TYPE (message));

  g_signal_emit (bus, gst_bus_signals[SYNC_MESSAGE], detail, message);

  return GST_BUS_PASS;
}

/**
 * gst_bus_enable_sync_message_emission:
 * @bus: a #GstBus on which you want to receive the "sync-message" signal
 *
 * Instructs GStreamer to emit the "sync-message" signal after running the bus's
 * sync handler. This function is here so that code can ensure that they can
 * synchronously receive messages without having to affect what the bin's sync
 * handler is.
 *
 * This function may be called multiple times. To clean up, the caller is
 * responsible for calling gst_bus_disable_sync_message_emission() as many times
 * as this function is called.
 *
 * While this function looks similar to gst_bus_add_signal_watch(), it is not
 * exactly the same -- this function enables <emphasis>synchronous</emphasis> emission of
 * signals when messages arrive; gst_bus_add_signal_watch() adds an idle callback
 * to pop messages off the bus <emphasis>asynchronously</emphasis>. The sync-message signal
 * comes from the thread of whatever object posted the message; the "message"
 * signal is marshalled to the main thread via the main loop.
 *
 * MT safe.
 */
void
gst_bus_enable_sync_message_emission (GstBus * bus)
{
  g_return_if_fail (GST_IS_BUS (bus));

  GST_OBJECT_LOCK (bus);
  bus->priv->num_sync_message_emitters++;
  GST_OBJECT_UNLOCK (bus);
}

/**
 * gst_bus_disable_sync_message_emission:
 * @bus: a #GstBus on which you previously called
 * gst_bus_enable_sync_message_emission()
 *
 * Instructs GStreamer to stop emitting the "sync-message" signal for this bus.
 * See gst_bus_enable_sync_message_emission() for more information.
 *
 * In the event that multiple pieces of code have called
 * gst_bus_enable_sync_message_emission(), the sync-message emissions will only
 * be stopped after all calls to gst_bus_enable_sync_message_emission() were
 * "cancelled" by calling this function. In this way the semantics are exactly
 * the same as gst_object_ref() that which calls enable should also call
 * disable.
 *
 * MT safe.
 */
void
gst_bus_disable_sync_message_emission (GstBus * bus)
{
  g_return_if_fail (GST_IS_BUS (bus));
  g_return_if_fail (bus->priv->num_sync_message_emitters > 0);

  GST_OBJECT_LOCK (bus);
  bus->priv->num_sync_message_emitters--;
  GST_OBJECT_UNLOCK (bus);
}

/**
 * gst_bus_add_signal_watch_full:
 * @bus: a #GstBus on which you want to receive the "message" signal
 * @priority: The priority of the watch.
 *
 * Adds a bus signal watch to the default main context with the given @priority
 * (e.g. %G_PRIORITY_DEFAULT). It is also possible to use a non-default main
 * context set up using g_main_context_push_thread_default()
 * (before one had to create a bus watch source and attach it to the desired
 * main context 'manually').
 *
 * After calling this statement, the bus will emit the "message" signal for each
 * message posted on the bus when the main loop is running.
 *
 * This function may be called multiple times. To clean up, the caller is
 * responsible for calling gst_bus_remove_signal_watch() as many times as this
 * function is called.
 *
 * There can only be a single bus watch per bus, you must remove any signal
 * watch before you can set another type of watch.
 *
 * MT safe.
 */
void
gst_bus_add_signal_watch_full (GstBus * bus, gint priority)
{
  g_return_if_fail (GST_IS_BUS (bus));

  /* I know the callees don't take this lock, so go ahead and abuse it */
  GST_OBJECT_LOCK (bus);

  if (bus->priv->num_signal_watchers > 0)
    goto done;

  /* this should not fail because the counter above takes care of it */
  g_assert (bus->priv->signal_watch_id == 0);

  bus->priv->signal_watch_id =
      gst_bus_add_watch_full_unlocked (bus, priority, gst_bus_async_signal_func,
      NULL, NULL);

  if (G_UNLIKELY (bus->priv->signal_watch_id == 0))
    goto add_failed;

done:

  bus->priv->num_signal_watchers++;

  GST_OBJECT_UNLOCK (bus);
  return;

  /* ERRORS */
add_failed:
  {
    g_critical ("Could not add signal watch to bus %s", GST_OBJECT_NAME (bus));
    GST_OBJECT_UNLOCK (bus);
    return;
  }
}

/**
 * gst_bus_add_signal_watch:
 * @bus: a #GstBus on which you want to receive the "message" signal
 *
 * Adds a bus signal watch to the default main context with the default priority
 * (%G_PRIORITY_DEFAULT). It is also possible to use a non-default
 * main context set up using g_main_context_push_thread_default() (before
 * one had to create a bus watch source and attach it to the desired main
 * context 'manually').
 *
 * After calling this statement, the bus will emit the "message" signal for each
 * message posted on the bus.
 *
 * This function may be called multiple times. To clean up, the caller is
 * responsible for calling gst_bus_remove_signal_watch() as many times as this
 * function is called.
 *
 * MT safe.
 */
void
gst_bus_add_signal_watch (GstBus * bus)
{
  gst_bus_add_signal_watch_full (bus, G_PRIORITY_DEFAULT);
}

/**
 * gst_bus_remove_signal_watch:
 * @bus: a #GstBus you previously added a signal watch to
 *
 * Removes a signal watch previously added with gst_bus_add_signal_watch().
 *
 * MT safe.
 */
void
gst_bus_remove_signal_watch (GstBus * bus)
{
  guint id = 0;

  g_return_if_fail (GST_IS_BUS (bus));

  /* I know the callees don't take this lock, so go ahead and abuse it */
  GST_OBJECT_LOCK (bus);

  if (bus->priv->num_signal_watchers == 0)
    goto error;

  bus->priv->num_signal_watchers--;

  if (bus->priv->num_signal_watchers > 0)
    goto done;

  id = bus->priv->signal_watch_id;
  bus->priv->signal_watch_id = 0;

  GST_DEBUG_OBJECT (bus, "removing signal watch %u", id);

done:
  GST_OBJECT_UNLOCK (bus);

  if (id)
    g_source_remove (id);

  return;

  /* ERRORS */
error:
  {
    g_critical ("Bus %s has no signal watches attached", GST_OBJECT_NAME (bus));
    GST_OBJECT_UNLOCK (bus);
    return;
  }
}
