/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2004> Thomas Vander Stichele <thomas at apestaart dot org>
 * Copyright (C) <2011> Collabora Ltd.
 *     Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>
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


#ifndef __GST_MULTI_HANDLE_SINK_H__
#define __GST_MULTI_HANDLE_SINK_H__

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>
#include <gio/gio.h>

G_BEGIN_DECLS

#define GST_TYPE_MULTI_HANDLE_SINK \
  (gst_multi_handle_sink_get_type())
#define GST_MULTI_HANDLE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_MULTI_HANDLE_SINK,GstMultiHandleSink))
#define GST_MULTI_HANDLE_SINK_CAST(obj) ((GstMultiHandleSink *)(obj))
#define GST_MULTI_HANDLE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_MULTI_HANDLE_SINK,GstMultiHandleSinkClass))
#define GST_IS_MULTI_HANDLE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_MULTI_HANDLE_SINK))
#define GST_IS_MULTI_HANDLE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_MULTI_HANDLE_SINK))
#define GST_MULTI_HANDLE_SINK_GET_CLASS(klass) \
  (G_TYPE_INSTANCE_GET_CLASS ((klass), GST_TYPE_MULTI_HANDLE_SINK, GstMultiHandleSinkClass))


typedef struct _GstMultiHandleSink GstMultiHandleSink;
typedef struct _GstMultiHandleSinkClass GstMultiHandleSinkClass;

typedef enum {
  GST_MULTI_HANDLE_SINK_OPEN             = (GST_ELEMENT_FLAG_LAST << 0),

  GST_MULTI_HANDLE_SINK_FLAG_LAST        = (GST_ELEMENT_FLAG_LAST << 2)
} GstMultiHandleSinkFlags;

/**
 * GstRecoverPolicy:
 * @GST_RECOVER_POLICY_NONE             : no recovering is done
 * @GST_RECOVER_POLICY_RESYNC_LATEST    : client is moved to last buffer
 * @GST_RECOVER_POLICY_RESYNC_SOFT_LIMIT: client is moved to the soft limit
 * @GST_RECOVER_POLICY_RESYNC_KEYFRAME  : client is moved to latest keyframe
 *
 * Possible values for the recovery procedure to use when a client consumes
 * data too slow and has a backlag of more that soft-limit buffers.
 */
typedef enum
{
  GST_RECOVER_POLICY_NONE,
  GST_RECOVER_POLICY_RESYNC_LATEST,
  GST_RECOVER_POLICY_RESYNC_SOFT_LIMIT,
  GST_RECOVER_POLICY_RESYNC_KEYFRAME
} GstRecoverPolicy;

/**
 * GstSyncMethod:
 * @GST_SYNC_METHOD_LATEST              : client receives most recent buffer
 * @GST_SYNC_METHOD_NEXT_KEYFRAME       : client receives next keyframe
 * @GST_SYNC_METHOD_LATEST_KEYFRAME     : client receives latest keyframe (burst)
 * @GST_SYNC_METHOD_BURST               : client receives specific amount of data
 * @GST_SYNC_METHOD_BURST_KEYFRAME      : client receives specific amount of data 
 *                                        starting from latest keyframe
 * @GST_SYNC_METHOD_BURST_WITH_KEYFRAME : client receives specific amount of data from
 *                                        a keyframe, or if there is not enough data after
 *                                        the keyframe, starting before the keyframe
 *
 * This enum defines the selection of the first buffer that is sent
 * to a new client.
 */
typedef enum
{
  GST_SYNC_METHOD_LATEST,
  GST_SYNC_METHOD_NEXT_KEYFRAME,
  GST_SYNC_METHOD_LATEST_KEYFRAME,
  GST_SYNC_METHOD_BURST,
  GST_SYNC_METHOD_BURST_KEYFRAME,
  GST_SYNC_METHOD_BURST_WITH_KEYFRAME
} GstSyncMethod;

/**
 * GstClientStatus:
 * @GST_CLIENT_STATUS_OK       : client is ok
 * @GST_CLIENT_STATUS_CLOSED   : client closed the socket
 * @GST_CLIENT_STATUS_REMOVED  : client is removed
 * @GST_CLIENT_STATUS_SLOW     : client is too slow
 * @GST_CLIENT_STATUS_ERROR    : client is in error
 * @GST_CLIENT_STATUS_DUPLICATE: same client added twice
 * @GST_CLIENT_STATUS_FLUSHING : client is flushing out the remaining buffers.
 *
 * This specifies the reason why a client was removed from
 * multisocketsink and is received in the "client-removed" signal.
 */
typedef enum
{
  GST_CLIENT_STATUS_OK          = 0,
  GST_CLIENT_STATUS_CLOSED      = 1,
  GST_CLIENT_STATUS_REMOVED     = 2,
  GST_CLIENT_STATUS_SLOW        = 3,
  GST_CLIENT_STATUS_ERROR       = 4,
  GST_CLIENT_STATUS_DUPLICATE   = 5,
  GST_CLIENT_STATUS_FLUSHING    = 6
} GstClientStatus;

// FIXME: is it better to use GSocket * or a gpointer here ?
typedef union
{
  gpointer pointer;
  int fd;
  GSocket *socket;
} GstMultiSinkHandle;

/* structure for a client
 */
typedef struct {
  GstMultiSinkHandle handle;

  gchar debug[30];              /* a debug string used in debug calls to
                                   identify the client */
  gint bufpos;                  /* position of this client in the global queue */
  gint flushcount;              /* the remaining number of buffers to flush out or -1 if the 
                                   client is not flushing. */

  GstClientStatus status;

  GSList *sending;              /* the buffers we need to send */
  gint bufoffset;               /* offset in the first buffer */

  gboolean discont;

  gboolean new_connection;
  gboolean currently_removing;


  /* method to sync client when connecting */
  GstSyncMethod sync_method;
  GstFormat     burst_min_format;
  guint64       burst_min_value;
  GstFormat     burst_max_format;
  guint64       burst_max_value;

  GstCaps *caps;                /* caps of last queued buffer */

  /* stats */
  guint64 bytes_sent;
  guint64 connect_time;
  guint64 disconnect_time;
  guint64 last_activity_time;
  guint64 dropped_buffers;
  guint64 avg_queue_size;
  guint64 first_buffer_ts;
  guint64 last_buffer_ts;
} GstMultiHandleClient;

#define CLIENTS_LOCK_INIT(mhsink)       (g_rec_mutex_init(&(mhsink)->clientslock))
#define CLIENTS_LOCK_CLEAR(mhsink)      (g_rec_mutex_clear(&(mhsink)->clientslock))
#define CLIENTS_LOCK(mhsink)            (g_rec_mutex_lock(&(mhsink)->clientslock))
#define CLIENTS_UNLOCK(mhsink)          (g_rec_mutex_unlock(&(mhsink)->clientslock))

gint gst_multi_handle_sink_setup_dscp_client (GstMultiHandleSink * sink, GstMultiHandleClient * client);
gint
gst_multi_handle_sink_new_client_position (GstMultiHandleSink * sink,
    GstMultiHandleClient * client);

/**
 * GstMultiHandleSink:
 *
 * The multisocketsink object structure.
 */
struct _GstMultiHandleSink {
  GstBaseSink element;

  /*< private >*/
  guint64 bytes_to_serve; /* how much bytes we must serve */
  guint64 bytes_served; /* how much bytes have we served */

  GRecMutex clientslock;  /* lock to protect the clients list */
  GList *clients;       /* list of clients we are serving */
  guint clients_cookie; /* Cookie to detect changes to the clients list */

  GHashTable *handle_hash;  /* index of handle -> GstMultiHandleClient */

  GMainContext *main_context;
  GCancellable *cancellable;

  GSList *streamheader; /* GSList of GstBuffers to use as streamheader */
  gboolean previous_buffer_in_caps;

  gint qos_dscp;

  GArray *bufqueue;     /* global queue of buffers */

  gboolean running;     /* the thread state */
  GThread *thread;      /* the sender thread */

  /* these values are used to check if a client is reading fast
   * enough and to control receovery */
  GstFormat unit_format;/* the format of the units */
  gint64 units_max;       /* max units to queue for a client */
  gint64 units_soft_max;  /* max units a client can lag before recovery starts */
  GstRecoverPolicy recover_policy;
  GstClockTime timeout; /* max amount of nanoseconds to remain idle */

  GstSyncMethod def_sync_method;    /* what method to use for connecting clients */
  GstFormat     def_burst_format;
  guint64       def_burst_value;

  /* these values are used to control the amount of data
   * kept in the queues. It allows clients to perform a burst
   * on connect. */
  gint   bytes_min;	/* min number of bytes to queue */
  gint64 time_min;	/* min time to queue */
  gint   buffers_min;   /* min number of buffers to queue */

  gboolean resend_streamheader; /* resend streamheader if it changes */

  /* stats */
  gint buffers_queued;  /* number of queued buffers */
  gint bytes_queued;    /* number of queued bytes */
  gint time_queued;     /* number of queued time */
};

struct _GstMultiHandleSinkClass {
  GstBaseSinkClass parent_class;

  /* methods */
  void          (*clear)        (GstMultiHandleSink *sink);
  void          (*stop_pre)     (GstMultiHandleSink *sink);
  void          (*stop_post)    (GstMultiHandleSink *sink);
  gboolean      (*start_pre)    (GstMultiHandleSink *sink);
  gpointer      (*thread)       (GstMultiHandleSink *sink);
  /* called by subclass when it has a new buffer to queue for a client */
  gboolean      (*client_queue_buffer)
                                (GstMultiHandleSink *sink,
                                 GstMultiHandleClient *client,
                                 GstBuffer *buffer);
  int           (*client_get_fd)
                                (GstMultiHandleClient *client);
  void          (*client_free)  (GstMultiHandleSink   *mhsink,
                                 GstMultiHandleClient *client);
  void          (*handle_debug) (GstMultiSinkHandle handle, gchar debug[30]);
  gpointer      (*handle_hash_key)  (GstMultiSinkHandle handle);
  /* called when the client hash/list has been changed */
  void          (*hash_changed)  (GstMultiHandleSink *mhsink);
  void          (*hash_adding)   (GstMultiHandleSink *mhsink, GstMultiHandleClient *client);
  void          (*hash_removing) (GstMultiHandleSink *mhsink, GstMultiHandleClient *client);
  GstMultiHandleClient* (*new_client) (GstMultiHandleSink *mhsink, GstMultiSinkHandle handle, GstSyncMethod sync_method);


  /* vtable */
  gboolean (*init)   (GstMultiHandleSink *sink);
  gboolean (*close)  (GstMultiHandleSink *sink);
  void (*removed) (GstMultiHandleSink *sink, GstMultiSinkHandle handle);

  /* subclass needs to emit these because actual argument size (int/pointer) differs */
  void (*emit_client_added)          (GstMultiHandleSink *mhsink, GstMultiSinkHandle handle);
  void (*emit_client_removed)        (GstMultiHandleSink *mhsink, GstMultiSinkHandle handle, GstClientStatus status);
};

GType gst_multi_handle_sink_get_type (void);

void          gst_multi_handle_sink_add          (GstMultiHandleSink *sink, GstMultiSinkHandle handle);
void          gst_multi_handle_sink_add_full     (GstMultiHandleSink *sink, GstMultiSinkHandle handle, GstSyncMethod sync,
                                              GstFormat min_format, guint64 min_value,
                                              GstFormat max_format, guint64 max_value);
void          gst_multi_handle_sink_remove       (GstMultiHandleSink *sink, GstMultiSinkHandle handle);
void          gst_multi_handle_sink_remove_flush (GstMultiHandleSink *sink, GstMultiSinkHandle handle);
GstStructure*  gst_multi_handle_sink_get_stats    (GstMultiHandleSink *sink, GstMultiSinkHandle handle);
void gst_multi_handle_sink_remove_client_link (GstMultiHandleSink * sink,
    GList * link);

void gst_multi_handle_sink_client_init (GstMultiHandleClient * client, GstSyncMethod sync_method);

#define GST_TYPE_RECOVER_POLICY (gst_multi_handle_sink_recover_policy_get_type())
GType gst_multi_handle_sink_recover_policy_get_type (void);
#define GST_TYPE_SYNC_METHOD (gst_multi_handle_sink_sync_method_get_type())
GType gst_multi_handle_sink_sync_method_get_type (void);
#define GST_TYPE_CLIENT_STATUS (gst_multi_handle_sink_client_status_get_type())
GType gst_multi_handle_sink_client_status_get_type (void);


G_END_DECLS

#endif /* __GST_MULTI_HANDLE_SINK_H__ */
