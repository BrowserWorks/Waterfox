/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstaudiosrc.c: simple audio src base class
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
 * SECTION:gstaudiosrc
 * @short_description: Simple base class for audio sources
 * @see_also: #GstAudioBaseSrc, #GstAudioRingBuffer, #GstAudioSrc.
 *
 * This is the most simple base class for audio sources that only requires
 * subclasses to implement a set of simple functions:
 *
 * <variablelist>
 *   <varlistentry>
 *     <term>open()</term>
 *     <listitem><para>Open the device.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>prepare()</term>
 *     <listitem><para>Configure the device with the specified format.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>read()</term>
 *     <listitem><para>Read samples from the device.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>reset()</term>
 *     <listitem><para>Unblock reads and flush the device.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>delay()</term>
 *     <listitem><para>Get the number of samples in the device but not yet read.
 *     </para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>unprepare()</term>
 *     <listitem><para>Undo operations done by prepare.</para></listitem>
 *   </varlistentry>
 *   <varlistentry>
 *     <term>close()</term>
 *     <listitem><para>Close the device.</para></listitem>
 *   </varlistentry>
 * </variablelist>
 *
 * All scheduling of samples and timestamps is done in this base class
 * together with #GstAudioBaseSrc using a default implementation of a
 * #GstAudioRingBuffer that uses threads.
 */

#include <string.h>

#include <gst/audio/audio.h>
#include "gstaudiosrc.h"

GST_DEBUG_CATEGORY_STATIC (gst_audio_src_debug);
#define GST_CAT_DEFAULT gst_audio_src_debug

#define GST_TYPE_AUDIO_SRC_RING_BUFFER        \
        (gst_audio_src_ring_buffer_get_type())
#define GST_AUDIO_SRC_RING_BUFFER(obj)        \
        (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_SRC_RING_BUFFER,GstAudioSrcRingBuffer))
#define GST_AUDIO_SRC_RING_BUFFER_CLASS(klass) \
        (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_SRC_RING_BUFFER,GstAudioSrcRingBufferClass))
#define GST_AUDIO_SRC_RING_BUFFER_GET_CLASS(obj) \
        (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_AUDIO_SRC_RING_BUFFER, GstAudioSrcRingBufferClass))
#define GST_IS_AUDIO_SRC_RING_BUFFER(obj)     \
        (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_SRC_RING_BUFFER))
#define GST_IS_AUDIO_SRC_RING_BUFFER_CLASS(klass)\
        (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_SRC_RING_BUFFER))

typedef struct _GstAudioSrcRingBuffer GstAudioSrcRingBuffer;
typedef struct _GstAudioSrcRingBufferClass GstAudioSrcRingBufferClass;

#define GST_AUDIO_SRC_RING_BUFFER_GET_COND(buf) (&(((GstAudioSrcRingBuffer *)buf)->cond))
#define GST_AUDIO_SRC_RING_BUFFER_WAIT(buf)     (g_cond_wait (GST_AUDIO_SRC_RING_BUFFER_GET_COND (buf), GST_OBJECT_GET_LOCK (buf)))
#define GST_AUDIO_SRC_RING_BUFFER_SIGNAL(buf)   (g_cond_signal (GST_AUDIO_SRC_RING_BUFFER_GET_COND (buf)))
#define GST_AUDIO_SRC_RING_BUFFER_BROADCAST(buf)(g_cond_broadcast (GST_AUDIO_SRC_RING_BUFFER_GET_COND (buf)))

struct _GstAudioSrcRingBuffer
{
  GstAudioRingBuffer object;

  gboolean running;
  gint queuedseg;

  GCond cond;
};

struct _GstAudioSrcRingBufferClass
{
  GstAudioRingBufferClass parent_class;
};

static void gst_audio_src_ring_buffer_class_init (GstAudioSrcRingBufferClass *
    klass);
static void gst_audio_src_ring_buffer_init (GstAudioSrcRingBuffer * ringbuffer,
    GstAudioSrcRingBufferClass * klass);
static void gst_audio_src_ring_buffer_dispose (GObject * object);
static void gst_audio_src_ring_buffer_finalize (GObject * object);

static GstAudioRingBufferClass *ring_parent_class = NULL;

static gboolean gst_audio_src_ring_buffer_open_device (GstAudioRingBuffer *
    buf);
static gboolean gst_audio_src_ring_buffer_close_device (GstAudioRingBuffer *
    buf);
static gboolean gst_audio_src_ring_buffer_acquire (GstAudioRingBuffer * buf,
    GstAudioRingBufferSpec * spec);
static gboolean gst_audio_src_ring_buffer_release (GstAudioRingBuffer * buf);
static gboolean gst_audio_src_ring_buffer_start (GstAudioRingBuffer * buf);
static gboolean gst_audio_src_ring_buffer_stop (GstAudioRingBuffer * buf);
static guint gst_audio_src_ring_buffer_delay (GstAudioRingBuffer * buf);

/* ringbuffer abstract base class */
static GType
gst_audio_src_ring_buffer_get_type (void)
{
  static GType ringbuffer_type = 0;

  if (!ringbuffer_type) {
    static const GTypeInfo ringbuffer_info = {
      sizeof (GstAudioSrcRingBufferClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_audio_src_ring_buffer_class_init,
      NULL,
      NULL,
      sizeof (GstAudioSrcRingBuffer),
      0,
      (GInstanceInitFunc) gst_audio_src_ring_buffer_init,
      NULL
    };

    ringbuffer_type =
        g_type_register_static (GST_TYPE_AUDIO_RING_BUFFER,
        "GstAudioSrcRingBuffer", &ringbuffer_info, 0);
  }
  return ringbuffer_type;
}

static void
gst_audio_src_ring_buffer_class_init (GstAudioSrcRingBufferClass * klass)
{
  GObjectClass *gobject_class;
  GstAudioRingBufferClass *gstringbuffer_class;

  gobject_class = (GObjectClass *) klass;
  gstringbuffer_class = (GstAudioRingBufferClass *) klass;

  ring_parent_class = g_type_class_peek_parent (klass);

  gobject_class->dispose = gst_audio_src_ring_buffer_dispose;
  gobject_class->finalize = gst_audio_src_ring_buffer_finalize;

  gstringbuffer_class->open_device =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_open_device);
  gstringbuffer_class->close_device =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_close_device);
  gstringbuffer_class->acquire =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_acquire);
  gstringbuffer_class->release =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_release);
  gstringbuffer_class->start =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_start);
  gstringbuffer_class->resume =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_start);
  gstringbuffer_class->stop =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_stop);

  gstringbuffer_class->delay =
      GST_DEBUG_FUNCPTR (gst_audio_src_ring_buffer_delay);
}

typedef guint (*ReadFunc)
  (GstAudioSrc * src, gpointer data, guint length, GstClockTime * timestamp);

/* this internal thread does nothing else but read samples from the audio device.
 * It will read each segment in the ringbuffer and will update the play
 * pointer.
 * The start/stop methods control the thread.
 */
static void
audioringbuffer_thread_func (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  GstAudioSrcRingBuffer *abuf = GST_AUDIO_SRC_RING_BUFFER (buf);
  ReadFunc readfunc;
  GstMessage *message;
  GValue val = { 0 };

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  GST_DEBUG_OBJECT (src, "enter thread");

  if ((readfunc = csrc->read) == NULL)
    goto no_function;

  message = gst_message_new_stream_status (GST_OBJECT_CAST (buf),
      GST_STREAM_STATUS_TYPE_ENTER, GST_ELEMENT_CAST (src));
  g_value_init (&val, GST_TYPE_G_THREAD);
  g_value_set_boxed (&val, src->thread);
  gst_message_set_stream_status_object (message, &val);
  g_value_unset (&val);
  GST_DEBUG_OBJECT (src, "posting ENTER stream status");
  gst_element_post_message (GST_ELEMENT_CAST (src), message);

  while (TRUE) {
    gint left, len;
    guint8 *readptr;
    gint readseg;
    GstClockTime timestamp = GST_CLOCK_TIME_NONE;

    if (gst_audio_ring_buffer_prepare_read (buf, &readseg, &readptr, &len)) {
      gint read;

      left = len;
      do {
        read = readfunc (src, readptr, left, &timestamp);
        GST_LOG_OBJECT (src, "transfered %d bytes of %d to segment %d", read,
            left, readseg);
        if (read < 0 || read > left) {
          GST_WARNING_OBJECT (src,
              "error reading data %d (reason: %s), skipping segment", read,
              g_strerror (errno));
          break;
        }
        left -= read;
        readptr += read;
      } while (left > 0);

      /* Update timestamp on buffer if required */
      gst_audio_ring_buffer_set_timestamp (buf, readseg, timestamp);

      /* we read one segment */
      gst_audio_ring_buffer_advance (buf, 1);
    } else {
      GST_OBJECT_LOCK (abuf);
      if (!abuf->running)
        goto stop_running;
      if (G_UNLIKELY (g_atomic_int_get (&buf->state) ==
              GST_AUDIO_RING_BUFFER_STATE_STARTED)) {
        GST_OBJECT_UNLOCK (abuf);
        continue;
      }
      GST_DEBUG_OBJECT (src, "signal wait");
      GST_AUDIO_SRC_RING_BUFFER_SIGNAL (buf);
      GST_DEBUG_OBJECT (src, "wait for action");
      GST_AUDIO_SRC_RING_BUFFER_WAIT (buf);
      GST_DEBUG_OBJECT (src, "got signal");
      if (!abuf->running)
        goto stop_running;
      GST_DEBUG_OBJECT (src, "continue running");
      GST_OBJECT_UNLOCK (abuf);
    }
  }

  /* Will never be reached */
  g_assert_not_reached ();
  return;

  /* ERROR */
no_function:
  {
    GST_DEBUG ("no write function, exit thread");
    return;
  }
stop_running:
  {
    GST_OBJECT_UNLOCK (abuf);
    GST_DEBUG ("stop running, exit thread");
    message = gst_message_new_stream_status (GST_OBJECT_CAST (buf),
        GST_STREAM_STATUS_TYPE_LEAVE, GST_ELEMENT_CAST (src));
    g_value_init (&val, GST_TYPE_G_THREAD);
    g_value_set_boxed (&val, src->thread);
    gst_message_set_stream_status_object (message, &val);
    g_value_unset (&val);
    GST_DEBUG_OBJECT (src, "posting LEAVE stream status");
    gst_element_post_message (GST_ELEMENT_CAST (src), message);
    return;
  }
}

static void
gst_audio_src_ring_buffer_init (GstAudioSrcRingBuffer * ringbuffer,
    GstAudioSrcRingBufferClass * g_class)
{
  ringbuffer->running = FALSE;
  ringbuffer->queuedseg = 0;

  g_cond_init (&ringbuffer->cond);
}

static void
gst_audio_src_ring_buffer_dispose (GObject * object)
{
  GstAudioSrcRingBuffer *ringbuffer = GST_AUDIO_SRC_RING_BUFFER (object);

  g_cond_clear (&ringbuffer->cond);

  G_OBJECT_CLASS (ring_parent_class)->dispose (object);
}

static void
gst_audio_src_ring_buffer_finalize (GObject * object)
{
  G_OBJECT_CLASS (ring_parent_class)->finalize (object);
}

static gboolean
gst_audio_src_ring_buffer_open_device (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  gboolean result = TRUE;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  if (csrc->open)
    result = csrc->open (src);

  if (!result)
    goto could_not_open;

  return result;

could_not_open:
  {
    return FALSE;
  }
}

static gboolean
gst_audio_src_ring_buffer_close_device (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  gboolean result = TRUE;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  if (csrc->close)
    result = csrc->close (src);

  if (!result)
    goto could_not_open;

  return result;

could_not_open:
  {
    return FALSE;
  }
}

static gboolean
gst_audio_src_ring_buffer_acquire (GstAudioRingBuffer * buf,
    GstAudioRingBufferSpec * spec)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  GstAudioSrcRingBuffer *abuf;
  gboolean result = FALSE;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  if (csrc->prepare)
    result = csrc->prepare (src, spec);

  if (!result)
    goto could_not_open;

  buf->size = spec->segtotal * spec->segsize;
  buf->memory = g_malloc0 (buf->size);

  abuf = GST_AUDIO_SRC_RING_BUFFER (buf);
  abuf->running = TRUE;

  /* FIXME: handle thread creation failure */
  src->thread = g_thread_try_new ("audiosrc-ringbuffer",
      (GThreadFunc) audioringbuffer_thread_func, buf, NULL);

  GST_AUDIO_SRC_RING_BUFFER_WAIT (buf);

  return result;

could_not_open:
  {
    return FALSE;
  }
}

/* function is called with LOCK */
static gboolean
gst_audio_src_ring_buffer_release (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  GstAudioSrcRingBuffer *abuf;
  gboolean result = FALSE;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);
  abuf = GST_AUDIO_SRC_RING_BUFFER (buf);

  abuf->running = FALSE;
  GST_AUDIO_SRC_RING_BUFFER_SIGNAL (buf);
  GST_OBJECT_UNLOCK (buf);

  /* join the thread */
  g_thread_join (src->thread);

  GST_OBJECT_LOCK (buf);

  /* free the buffer */
  g_free (buf->memory);
  buf->memory = NULL;

  if (csrc->unprepare)
    result = csrc->unprepare (src);

  return result;
}

static gboolean
gst_audio_src_ring_buffer_start (GstAudioRingBuffer * buf)
{
  GST_DEBUG ("start, sending signal");
  GST_AUDIO_SRC_RING_BUFFER_SIGNAL (buf);

  return TRUE;
}

static gboolean
gst_audio_src_ring_buffer_stop (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  /* unblock any pending writes to the audio device */
  if (csrc->reset) {
    GST_DEBUG ("reset...");
    csrc->reset (src);
    GST_DEBUG ("reset done");
  }
#if 0
  GST_DEBUG ("stop, waiting...");
  GST_AUDIO_SRC_RING_BUFFER_WAIT (buf);
  GST_DEBUG ("stoped");
#endif

  return TRUE;
}

static guint
gst_audio_src_ring_buffer_delay (GstAudioRingBuffer * buf)
{
  GstAudioSrc *src;
  GstAudioSrcClass *csrc;
  guint res = 0;

  src = GST_AUDIO_SRC (GST_OBJECT_PARENT (buf));
  csrc = GST_AUDIO_SRC_GET_CLASS (src);

  if (csrc->delay)
    res = csrc->delay (src);

  return res;
}

/* AudioSrc signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  ARG_0,
};

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_audio_src_debug, "audiosrc", 0, "audiosrc element");
#define gst_audio_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAudioSrc, gst_audio_src,
    GST_TYPE_AUDIO_BASE_SRC, _do_init);

static GstAudioRingBuffer *gst_audio_src_create_ringbuffer (GstAudioBaseSrc *
    src);

static void
gst_audio_src_class_init (GstAudioSrcClass * klass)
{
  GstAudioBaseSrcClass *gstaudiobasesrc_class;

  gstaudiobasesrc_class = (GstAudioBaseSrcClass *) klass;

  gstaudiobasesrc_class->create_ringbuffer =
      GST_DEBUG_FUNCPTR (gst_audio_src_create_ringbuffer);

  g_type_class_ref (GST_TYPE_AUDIO_SRC_RING_BUFFER);
}

static void
gst_audio_src_init (GstAudioSrc * audiosrc)
{
}

static GstAudioRingBuffer *
gst_audio_src_create_ringbuffer (GstAudioBaseSrc * src)
{
  GstAudioRingBuffer *buffer;

  GST_DEBUG ("creating ringbuffer");
  buffer = g_object_new (GST_TYPE_AUDIO_SRC_RING_BUFFER, NULL);
  GST_DEBUG ("created ringbuffer @%p", buffer);

  return buffer;
}
