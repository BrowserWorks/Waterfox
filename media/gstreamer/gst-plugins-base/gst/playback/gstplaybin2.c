/* GStreamer
 * Copyright (C) <2007> Wim Taymans <wim.taymans@gmail.com>
 * Copyright (C) <2011> Sebastian Dröge <sebastian.droege@collabora.co.uk>
 * Copyright (C) <2013> Collabora Ltd.
 *   Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * SECTION:element-playbin
 *
 * Playbin provides a stand-alone everything-in-one abstraction for an
 * audio and/or video player.
 *
 * Playbin can handle both audio and video files and features
 * <itemizedlist>
 * <listitem>
 * automatic file type recognition and based on that automatic
 * selection and usage of the right audio/video/subtitle demuxers/decoders
 * </listitem>
 * <listitem>
 * visualisations for audio files
 * </listitem>
 * <listitem>
 * subtitle support for video files. Subtitles can be store in external
 * files.
 * </listitem>
 * <listitem>
 * stream selection between different video/audio/subtitles streams
 * </listitem>
 * <listitem>
 * meta info (tag) extraction
 * </listitem>
 * <listitem>
 * easy access to the last video sample
 * </listitem>
 * <listitem>
 * buffering when playing streams over a network
 * </listitem>
 * <listitem>
 * volume control with mute option
 * </listitem>
 * </itemizedlist>
 *
 * <refsect2>
 * <title>Usage</title>
 * <para>
 * A playbin element can be created just like any other element using
 * gst_element_factory_make(). The file/URI to play should be set via the #GstPlayBin:uri
 * property. This must be an absolute URI, relative file paths are not allowed.
 * Example URIs are file:///home/joe/movie.avi or http://www.joedoe.com/foo.ogg
 *
 * Playbin is a #GstPipeline. It will notify the application of everything
 * that's happening (errors, end of stream, tags found, state changes, etc.)
 * by posting messages on its #GstBus. The application needs to watch the
 * bus.
 *
 * Playback can be initiated by setting the element to PLAYING state using
 * gst_element_set_state(). Note that the state change will take place in
 * the background in a separate thread, when the function returns playback
 * is probably not happening yet and any errors might not have occured yet.
 * Applications using playbin should ideally be written to deal with things
 * completely asynchroneous.
 *
 * When playback has finished (an EOS message has been received on the bus)
 * or an error has occured (an ERROR message has been received on the bus) or
 * the user wants to play a different track, playbin should be set back to
 * READY or NULL state, then the #GstPlayBin:uri property should be set to the
 * new location and then playbin be set to PLAYING state again.
 *
 * Seeking can be done using gst_element_seek_simple() or gst_element_seek()
 * on the playbin element. Again, the seek will not be executed
 * instantaneously, but will be done in a background thread. When the seek
 * call returns the seek will most likely still be in process. An application
 * may wait for the seek to finish (or fail) using gst_element_get_state() with
 * -1 as the timeout, but this will block the user interface and is not
 * recommended at all.
 *
 * Applications may query the current position and duration of the stream
 * via gst_element_query_position() and gst_element_query_duration() and
 * setting the format passed to GST_FORMAT_TIME. If the query was successful,
 * the duration or position will have been returned in units of nanoseconds.
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Advanced Usage: specifying the audio and video sink</title>
 * <para>
 * By default, if no audio sink or video sink has been specified via the
 * #GstPlayBin:audio-sink or #GstPlayBin:video-sink property, playbin will use the autoaudiosink
 * and autovideosink elements to find the first-best available output method.
 * This should work in most cases, but is not always desirable. Often either
 * the user or application might want to specify more explicitly what to use
 * for audio and video output.
 *
 * If the application wants more control over how audio or video should be
 * output, it may create the audio/video sink elements itself (for example
 * using gst_element_factory_make()) and provide them to playbin using the
 * #GstPlayBin:audio-sink or #GstPlayBin:video-sink property.
 *
 * GNOME-based applications, for example, will usually want to create
 * gconfaudiosink and gconfvideosink elements and make playbin use those,
 * so that output happens to whatever the user has configured in the GNOME
 * Multimedia System Selector configuration dialog.
 *
 * The sink elements do not necessarily need to be ready-made sinks. It is
 * possible to create container elements that look like a sink to playbin,
 * but in reality contain a number of custom elements linked together. This
 * can be achieved by creating a #GstBin and putting elements in there and
 * linking them, and then creating a sink #GstGhostPad for the bin and pointing
 * it to the sink pad of the first element within the bin. This can be used
 * for a number of purposes, for example to force output to a particular
 * format or to modify or observe the data before it is output.
 *
 * It is also possible to 'suppress' audio and/or video output by using
 * 'fakesink' elements (or capture it from there using the fakesink element's
 * "handoff" signal, which, nota bene, is fired from the streaming thread!).
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Retrieving Tags and Other Meta Data</title>
 * <para>
 * Most of the common meta data (artist, title, etc.) can be retrieved by
 * watching for TAG messages on the pipeline's bus (see above).
 *
 * Other more specific meta information like width/height/framerate of video
 * streams or samplerate/number of channels of audio streams can be obtained
 * from the negotiated caps on the sink pads of the sinks.
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Buffering</title>
 * Playbin handles buffering automatically for the most part, but applications
 * need to handle parts of the buffering process as well. Whenever playbin is
 * buffering, it will post BUFFERING messages on the bus with a percentage
 * value that shows the progress of the buffering process. Applications need
 * to set playbin to PLAYING or PAUSED state in response to these messages.
 * They may also want to convey the buffering progress to the user in some
 * way. Here is how to extract the percentage information from the message:
 * |[
 * switch (GST_MESSAGE_TYPE (msg)) {
 *   case GST_MESSAGE_BUFFERING: {
 *     gint percent = 0;
 *     gst_message_parse_buffering (msg, &amp;percent);
 *     g_print ("Buffering (%%u percent done)", percent);
 *     break;
 *   }
 *   ...
 * }
 * ]|
 * Note that applications should keep/set the pipeline in the PAUSED state when
 * a BUFFERING message is received with a buffer percent value < 100 and set
 * the pipeline back to PLAYING state when a BUFFERING message with a value
 * of 100 percent is received (if PLAYING is the desired state, that is).
 * </refsect2>
 * <refsect2>
 * <title>Embedding the video window in your application</title>
 * By default, playbin (or rather the video sinks used) will create their own
 * window. Applications will usually want to force output to a window of their
 * own, however. This can be done using the #GstVideoOverlay interface, which most
 * video sinks implement. See the documentation there for more details.
 * </refsect2>
 * <refsect2>
 * <title>Specifying which CD/DVD device to use</title>
 * The device to use for CDs/DVDs needs to be set on the source element
 * playbin creates before it is opened. The most generic way of doing this
 * is to connect to playbin's "source-setup" (or "notify::source") signal,
 * which will be emitted by playbin when it has created the source element
 * for a particular URI. In the signal callback you can check if the source
 * element has a "device" property and set it appropriately. In some cases
 * the device can also be set as part of the URI, but it depends on the
 * elements involved if this will work or not. For example, for DVD menu
 * playback, the following syntax might work (if the resindvd plugin is used):
 * dvd://[/path/to/device]
 * </refsect2>
 * <refsect2>
 * <title>Handling redirects</title>
 * <para>
 * Some elements may post 'redirect' messages on the bus to tell the
 * application to open another location. These are element messages containing
 * a structure named 'redirect' along with a 'new-location' field of string
 * type. The new location may be a relative or an absolute URI. Examples
 * for such redirects can be found in many quicktime movie trailers.
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Examples</title>
 * |[
 * gst-launch -v playbin uri=file:///path/to/somefile.avi
 * ]| This will play back the given AVI video file, given that the video and
 * audio decoders required to decode the content are installed. Since no
 * special audio sink or video sink is supplied (not possible via gst-launch),
 * playbin will try to find a suitable audio and video sink automatically
 * using the autoaudiosink and autovideosink elements.
 * |[
 * gst-launch -v playbin uri=cdda://4
 * ]| This will play back track 4 on an audio CD in your disc drive (assuming
 * the drive is detected automatically by the plugin).
 * |[
 * gst-launch -v playbin uri=dvd://
 * ]| This will play back the DVD in your disc drive (assuming
 * the drive is detected automatically by the plugin).
 * </refsect2>
 */

/* FIXME 0.11: suppress warnings for deprecated API such as GValueArray
 * with newer GLib versions (>= 2.31.0) */
#define GLIB_DISABLE_DEPRECATION_WARNINGS

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <gst/gst.h>

#include <gst/gst-i18n-plugin.h>
#include <gst/pbutils/pbutils.h>
#include <gst/audio/streamvolume.h>
#include <gst/video/videooverlay.h>
#include <gst/video/navigation.h>
#include <gst/video/colorbalance.h>
#include "gstplay-enum.h"
#include "gstplayback.h"
#include "gstplaysink.h"
#include "gstsubtitleoverlay.h"

GST_DEBUG_CATEGORY_STATIC (gst_play_bin_debug);
#define GST_CAT_DEFAULT gst_play_bin_debug

#define GST_TYPE_PLAY_BIN               (gst_play_bin_get_type())
#define GST_PLAY_BIN(obj)               (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_PLAY_BIN,GstPlayBin))
#define GST_PLAY_BIN_CLASS(klass)       (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_PLAY_BIN,GstPlayBinClass))
#define GST_IS_PLAY_BIN(obj)            (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_PLAY_BIN))
#define GST_IS_PLAY_BIN_CLASS(klass)    (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_PLAY_BIN))

#define VOLUME_MAX_DOUBLE 10.0

typedef struct _GstPlayBin GstPlayBin;
typedef struct _GstPlayBinClass GstPlayBinClass;
typedef struct _GstSourceGroup GstSourceGroup;
typedef struct _GstSourceCombine GstSourceCombine;

typedef GstCaps *(*SourceCombineGetMediaCapsFunc) (void);

/* has the info for a combiner and provides the link to the sink */
struct _GstSourceCombine
{
  const gchar *media_list[8];   /* the media types for the combiner */
  SourceCombineGetMediaCapsFunc get_media_caps; /* more complex caps for the combiner */
  GstPlaySinkType type;         /* the sink pad type of the combiner */

  GstElement *combiner;         /* the combiner */
  GPtrArray *channels;
  GstPad *srcpad;               /* the source pad of the combiner */
  GstPad *sinkpad;              /* the sinkpad of the sink when the combiner
                                 * is linked
                                 */
  gulong block_id;

  gboolean has_active_pad;      /* stream combiner has the "active-pad" property */

  gboolean has_always_ok;       /* stream combiner's sink pads have the "always-ok" property */
  gboolean has_tags;            /* stream combiner's sink pads have the "tags" property */
};

#define GST_SOURCE_GROUP_GET_LOCK(group) (&((GstSourceGroup*)(group))->lock)
#define GST_SOURCE_GROUP_LOCK(group) (g_mutex_lock (GST_SOURCE_GROUP_GET_LOCK(group)))
#define GST_SOURCE_GROUP_UNLOCK(group) (g_mutex_unlock (GST_SOURCE_GROUP_GET_LOCK(group)))

enum
{
  PLAYBIN_STREAM_AUDIO = 0,
  PLAYBIN_STREAM_VIDEO,
  PLAYBIN_STREAM_TEXT,
  PLAYBIN_STREAM_LAST
};

static void avelements_free (gpointer data);
static GSequence *avelements_create (GstPlayBin * playbin,
    gboolean isaudioelement);

/* The GstAudioVideoElement structure holding the audio/video decoder
 * and the audio/video sink factories together with field indicating
 * the number of common caps features */
typedef struct
{
  GstElementFactory *dec;       /* audio:video decoder */
  GstElementFactory *sink;      /* audio:video sink */
  guint n_comm_cf;              /* number of common caps features */
} GstAVElement;

/* a structure to hold the objects for decoding a uri and the subtitle uri
 */
struct _GstSourceGroup
{
  GstPlayBin *playbin;

  GMutex lock;

  gboolean valid;               /* the group has valid info to start playback */
  gboolean active;              /* the group is active */

  /* properties */
  gchar *uri;
  gchar *suburi;
  GValueArray *streaminfo;
  GstElement *source;

  GPtrArray *video_channels;    /* links to combiner pads */
  GPtrArray *audio_channels;    /* links to combiner pads */
  GPtrArray *text_channels;     /* links to combiner pads */

  /* Sinks for this group. These are initialized with
   * the configure or currently used sink, otherwise
   * left as NULL and playbin tries to automatically
   * select a good sink
   */
  GstElement *audio_sink;
  GstElement *video_sink;
  GstElement *text_sink;

  /* uridecodebins for uri and subtitle uri */
  GstElement *uridecodebin;
  GstElement *suburidecodebin;
  gint pending;
  gboolean sub_pending;

  gboolean have_group_id;
  guint group_id;

  gulong pad_added_id;
  gulong pad_removed_id;
  gulong no_more_pads_id;
  gulong notify_source_id;
  gulong drained_id;
  gulong autoplug_factories_id;
  gulong autoplug_select_id;
  gulong autoplug_continue_id;
  gulong autoplug_query_id;

  gulong sub_pad_added_id;
  gulong sub_pad_removed_id;
  gulong sub_no_more_pads_id;
  gulong sub_autoplug_continue_id;
  gulong sub_autoplug_query_id;

  gulong block_id;

  GMutex stream_changed_pending_lock;
  gboolean stream_changed_pending;

  /* to prevent that suburidecodebin seek flushes disrupt playback */
  GMutex suburi_flushes_to_drop_lock;
  GSList *suburi_flushes_to_drop;

  /* combiners for different streams */
  GstSourceCombine combiner[PLAYBIN_STREAM_LAST];
};

#define GST_PLAY_BIN_GET_LOCK(bin) (&((GstPlayBin*)(bin))->lock)
#define GST_PLAY_BIN_LOCK(bin) (g_rec_mutex_lock (GST_PLAY_BIN_GET_LOCK(bin)))
#define GST_PLAY_BIN_UNLOCK(bin) (g_rec_mutex_unlock (GST_PLAY_BIN_GET_LOCK(bin)))

/* lock to protect dynamic callbacks, like no-more-pads */
#define GST_PLAY_BIN_DYN_LOCK(bin)    g_mutex_lock (&(bin)->dyn_lock)
#define GST_PLAY_BIN_DYN_UNLOCK(bin)  g_mutex_unlock (&(bin)->dyn_lock)

/* lock for shutdown */
#define GST_PLAY_BIN_SHUTDOWN_LOCK(bin,label)           \
G_STMT_START {                                          \
  if (G_UNLIKELY (g_atomic_int_get (&bin->shutdown)))   \
    goto label;                                         \
  GST_PLAY_BIN_DYN_LOCK (bin);                          \
  if (G_UNLIKELY (g_atomic_int_get (&bin->shutdown))) { \
    GST_PLAY_BIN_DYN_UNLOCK (bin);                      \
    goto label;                                         \
  }                                                     \
} G_STMT_END

/* unlock for shutdown */
#define GST_PLAY_BIN_SHUTDOWN_UNLOCK(bin)         \
  GST_PLAY_BIN_DYN_UNLOCK (bin);                  \

/**
 * GstPlayBin:
 *
 * playbin element structure
 */
struct _GstPlayBin
{
  GstPipeline parent;

  GRecMutex lock;               /* to protect group switching */

  /* the groups, we use a double buffer to switch between current and next */
  GstSourceGroup groups[2];     /* array with group info */
  GstSourceGroup *curr_group;   /* pointer to the currently playing group */
  GstSourceGroup *next_group;   /* pointer to the next group */

  /* properties */
  guint64 connection_speed;     /* connection speed in bits/sec (0 = unknown) */
  gint current_video;           /* the currently selected stream */
  gint current_audio;           /* the currently selected stream */
  gint current_text;            /* the currently selected stream */

  guint64 buffer_duration;      /* When buffering, the max buffer duration (ns) */
  guint buffer_size;            /* When buffering, the max buffer size (bytes) */
  gboolean force_aspect_ratio;

  /* our play sink */
  GstPlaySink *playsink;

  /* the last activated source */
  GstElement *source;

  /* lock protecting dynamic adding/removing */
  GMutex dyn_lock;
  /* if we are shutting down or not */
  gint shutdown;

  GMutex elements_lock;
  guint32 elements_cookie;
  GList *elements;              /* factories we can use for selecting elements */

  gboolean have_selector;       /* set to FALSE when we fail to create an
                                 * input-selector, so that we only post a
                                 * warning once */

  gboolean video_pending_flush_finish;  /* whether we are pending to send a custom
                                         * custom-video-flush-finish event
                                         * on pad activation */
  gboolean audio_pending_flush_finish;  /* whether we are pending to send a custom
                                         * custom-audio-flush-finish event
                                         * on pad activation */
  gboolean text_pending_flush_finish;   /* whether we are pending to send a custom
                                         * custom-subtitle-flush-finish event
                                         * on pad activation */

  GstElement *audio_sink;       /* configured audio sink, or NULL      */
  GstElement *video_sink;       /* configured video sink, or NULL      */
  GstElement *text_sink;        /* configured text sink, or NULL       */

  GstElement *audio_stream_combiner;    /* configured audio stream combiner, or NULL */
  GstElement *video_stream_combiner;    /* configured video stream combiner, or NULL */
  GstElement *text_stream_combiner;     /* configured text stream combiner, or NULL */

  GSequence *aelements;         /* a list of GstAVElements for audio stream */
  GSequence *velements;         /* a list of GstAVElements for video stream */

  struct
  {
    gboolean valid;
    GstFormat format;
    gint64 duration;
  } duration[5];                /* cached durations */

  guint64 ring_buffer_max_size; /* 0 means disabled */

  GList *contexts;
};

struct _GstPlayBinClass
{
  GstPipelineClass parent_class;

  /* notify app that the current uri finished decoding and it is possible to
   * queue a new one for gapless playback */
  void (*about_to_finish) (GstPlayBin * playbin);

  /* notify app that number of audio/video/text streams changed */
  void (*video_changed) (GstPlayBin * playbin);
  void (*audio_changed) (GstPlayBin * playbin);
  void (*text_changed) (GstPlayBin * playbin);

  /* notify app that the tags of audio/video/text streams changed */
  void (*video_tags_changed) (GstPlayBin * playbin, gint stream);
  void (*audio_tags_changed) (GstPlayBin * playbin, gint stream);
  void (*text_tags_changed) (GstPlayBin * playbin, gint stream);

  /* get audio/video/text tags for a stream */
  GstTagList *(*get_video_tags) (GstPlayBin * playbin, gint stream);
  GstTagList *(*get_audio_tags) (GstPlayBin * playbin, gint stream);
  GstTagList *(*get_text_tags) (GstPlayBin * playbin, gint stream);

  /* get the last video sample and convert it to the given caps */
  GstSample *(*convert_sample) (GstPlayBin * playbin, GstCaps * caps);

  /* get audio/video/text pad for a stream */
  GstPad *(*get_video_pad) (GstPlayBin * playbin, gint stream);
  GstPad *(*get_audio_pad) (GstPlayBin * playbin, gint stream);
  GstPad *(*get_text_pad) (GstPlayBin * playbin, gint stream);
};

/* props */
#define DEFAULT_URI               NULL
#define DEFAULT_SUBURI            NULL
#define DEFAULT_SOURCE            NULL
#define DEFAULT_FLAGS             GST_PLAY_FLAG_AUDIO | GST_PLAY_FLAG_VIDEO | GST_PLAY_FLAG_TEXT | \
                                  GST_PLAY_FLAG_SOFT_VOLUME | GST_PLAY_FLAG_DEINTERLACE | \
                                  GST_PLAY_FLAG_SOFT_COLORBALANCE
#define DEFAULT_N_VIDEO           0
#define DEFAULT_CURRENT_VIDEO     -1
#define DEFAULT_N_AUDIO           0
#define DEFAULT_CURRENT_AUDIO     -1
#define DEFAULT_N_TEXT            0
#define DEFAULT_CURRENT_TEXT      -1
#define DEFAULT_SUBTITLE_ENCODING NULL
#define DEFAULT_AUDIO_SINK        NULL
#define DEFAULT_VIDEO_SINK        NULL
#define DEFAULT_VIS_PLUGIN        NULL
#define DEFAULT_TEXT_SINK         NULL
#define DEFAULT_VOLUME            1.0
#define DEFAULT_MUTE              FALSE
#define DEFAULT_FRAME             NULL
#define DEFAULT_FONT_DESC         NULL
#define DEFAULT_CONNECTION_SPEED  0
#define DEFAULT_BUFFER_DURATION   -1
#define DEFAULT_BUFFER_SIZE       -1
#define DEFAULT_RING_BUFFER_MAX_SIZE 0

enum
{
  PROP_0,
  PROP_URI,
  PROP_CURRENT_URI,
  PROP_SUBURI,
  PROP_CURRENT_SUBURI,
  PROP_SOURCE,
  PROP_FLAGS,
  PROP_N_VIDEO,
  PROP_CURRENT_VIDEO,
  PROP_N_AUDIO,
  PROP_CURRENT_AUDIO,
  PROP_N_TEXT,
  PROP_CURRENT_TEXT,
  PROP_SUBTITLE_ENCODING,
  PROP_AUDIO_SINK,
  PROP_VIDEO_SINK,
  PROP_VIS_PLUGIN,
  PROP_TEXT_SINK,
  PROP_VIDEO_STREAM_COMBINER,
  PROP_AUDIO_STREAM_COMBINER,
  PROP_TEXT_STREAM_COMBINER,
  PROP_VOLUME,
  PROP_MUTE,
  PROP_SAMPLE,
  PROP_FONT_DESC,
  PROP_CONNECTION_SPEED,
  PROP_BUFFER_SIZE,
  PROP_BUFFER_DURATION,
  PROP_AV_OFFSET,
  PROP_RING_BUFFER_MAX_SIZE,
  PROP_FORCE_ASPECT_RATIO,
  PROP_AUDIO_FILTER,
  PROP_VIDEO_FILTER,
  PROP_LAST
};

/* signals */
enum
{
  SIGNAL_ABOUT_TO_FINISH,
  SIGNAL_CONVERT_SAMPLE,
  SIGNAL_VIDEO_CHANGED,
  SIGNAL_AUDIO_CHANGED,
  SIGNAL_TEXT_CHANGED,
  SIGNAL_VIDEO_TAGS_CHANGED,
  SIGNAL_AUDIO_TAGS_CHANGED,
  SIGNAL_TEXT_TAGS_CHANGED,
  SIGNAL_GET_VIDEO_TAGS,
  SIGNAL_GET_AUDIO_TAGS,
  SIGNAL_GET_TEXT_TAGS,
  SIGNAL_GET_VIDEO_PAD,
  SIGNAL_GET_AUDIO_PAD,
  SIGNAL_GET_TEXT_PAD,
  SIGNAL_SOURCE_SETUP,
  LAST_SIGNAL
};

static GstStaticCaps raw_audio_caps = GST_STATIC_CAPS ("audio/x-raw(ANY)");
static GstStaticCaps raw_video_caps = GST_STATIC_CAPS ("video/x-raw(ANY)");

static void gst_play_bin_class_init (GstPlayBinClass * klass);
static void gst_play_bin_init (GstPlayBin * playbin);
static void gst_play_bin_finalize (GObject * object);

static void gst_play_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * spec);
static void gst_play_bin_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * spec);

static GstStateChangeReturn gst_play_bin_change_state (GstElement * element,
    GstStateChange transition);

static void gst_play_bin_handle_message (GstBin * bin, GstMessage * message);
static gboolean gst_play_bin_query (GstElement * element, GstQuery * query);
static void gst_play_bin_set_context (GstElement * element,
    GstContext * context);

static GstTagList *gst_play_bin_get_video_tags (GstPlayBin * playbin,
    gint stream);
static GstTagList *gst_play_bin_get_audio_tags (GstPlayBin * playbin,
    gint stream);
static GstTagList *gst_play_bin_get_text_tags (GstPlayBin * playbin,
    gint stream);

static GstSample *gst_play_bin_convert_sample (GstPlayBin * playbin,
    GstCaps * caps);

static GstPad *gst_play_bin_get_video_pad (GstPlayBin * playbin, gint stream);
static GstPad *gst_play_bin_get_audio_pad (GstPlayBin * playbin, gint stream);
static GstPad *gst_play_bin_get_text_pad (GstPlayBin * playbin, gint stream);

static gboolean setup_next_source (GstPlayBin * playbin, GstState target);

static void no_more_pads_cb (GstElement * decodebin, GstSourceGroup * group);
static void pad_removed_cb (GstElement * decodebin, GstPad * pad,
    GstSourceGroup * group);

static void gst_play_bin_suburidecodebin_block (GstSourceGroup * group,
    GstElement * suburidecodebin, gboolean block);
static void gst_play_bin_suburidecodebin_seek_to_start (GstSourceGroup * group);

static GstElementClass *parent_class;

static guint gst_play_bin_signals[LAST_SIGNAL] = { 0 };

#define REMOVE_SIGNAL(obj,id)            \
if (id) {                                \
  g_signal_handler_disconnect (obj, id); \
  id = 0;                                \
}

static void gst_play_bin_overlay_init (gpointer g_iface, gpointer g_iface_data);
static void gst_play_bin_navigation_init (gpointer g_iface,
    gpointer g_iface_data);
static void gst_play_bin_colorbalance_init (gpointer g_iface,
    gpointer g_iface_data);

static GType
gst_play_bin_get_type (void)
{
  static GType gst_play_bin_type = 0;

  if (!gst_play_bin_type) {
    static const GTypeInfo gst_play_bin_info = {
      sizeof (GstPlayBinClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_play_bin_class_init,
      NULL,
      NULL,
      sizeof (GstPlayBin),
      0,
      (GInstanceInitFunc) gst_play_bin_init,
      NULL
    };
    static const GInterfaceInfo svol_info = {
      NULL, NULL, NULL
    };
    static const GInterfaceInfo ov_info = {
      gst_play_bin_overlay_init,
      NULL, NULL
    };
    static const GInterfaceInfo nav_info = {
      gst_play_bin_navigation_init,
      NULL, NULL
    };
    static const GInterfaceInfo col_info = {
      gst_play_bin_colorbalance_init,
      NULL, NULL
    };

    gst_play_bin_type = g_type_register_static (GST_TYPE_PIPELINE,
        "GstPlayBin", &gst_play_bin_info, 0);

    g_type_add_interface_static (gst_play_bin_type, GST_TYPE_STREAM_VOLUME,
        &svol_info);
    g_type_add_interface_static (gst_play_bin_type, GST_TYPE_VIDEO_OVERLAY,
        &ov_info);
    g_type_add_interface_static (gst_play_bin_type, GST_TYPE_NAVIGATION,
        &nav_info);
    g_type_add_interface_static (gst_play_bin_type, GST_TYPE_COLOR_BALANCE,
        &col_info);
  }

  return gst_play_bin_type;
}

static void
gst_play_bin_class_init (GstPlayBinClass * klass)
{
  GObjectClass *gobject_klass;
  GstElementClass *gstelement_klass;
  GstBinClass *gstbin_klass;

  gobject_klass = (GObjectClass *) klass;
  gstelement_klass = (GstElementClass *) klass;
  gstbin_klass = (GstBinClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_klass->set_property = gst_play_bin_set_property;
  gobject_klass->get_property = gst_play_bin_get_property;

  gobject_klass->finalize = gst_play_bin_finalize;

  /**
   * GstPlayBin:uri
   *
   * Set the next URI that playbin will play. This property can be set from the
   * about-to-finish signal to queue the next media file.
   */
  g_object_class_install_property (gobject_klass, PROP_URI,
      g_param_spec_string ("uri", "URI", "URI of the media to play",
          NULL, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

   /**
   * GstPlayBin:current-uri
   *
   * The currently playing uri.
   */
  g_object_class_install_property (gobject_klass, PROP_CURRENT_URI,
      g_param_spec_string ("current-uri", "Current URI",
          "The currently playing URI", NULL,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:suburi
   *
   * Set the next subtitle URI that playbin will play. This property can be
   * set from the about-to-finish signal to queue the next subtitle media file.
   */
  g_object_class_install_property (gobject_klass, PROP_SUBURI,
      g_param_spec_string ("suburi", ".sub-URI", "Optional URI of a subtitle",
          NULL, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:current-suburi
   *
   * The currently playing subtitle uri.
   */
  g_object_class_install_property (gobject_klass, PROP_CURRENT_SUBURI,
      g_param_spec_string ("current-suburi", "Current .sub-URI",
          "The currently playing URI of a subtitle",
          NULL, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_SOURCE,
      g_param_spec_object ("source", "Source", "Source element",
          GST_TYPE_ELEMENT, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:flags
   *
   * Control the behaviour of playbin.
   */
  g_object_class_install_property (gobject_klass, PROP_FLAGS,
      g_param_spec_flags ("flags", "Flags", "Flags to control behaviour",
          GST_TYPE_PLAY_FLAGS, DEFAULT_FLAGS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:n-video
   *
   * Get the total number of available video streams.
   */
  g_object_class_install_property (gobject_klass, PROP_N_VIDEO,
      g_param_spec_int ("n-video", "Number Video",
          "Total number of video streams", 0, G_MAXINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:current-video
   *
   * Get or set the currently playing video stream. By default the first video
   * stream with data is played.
   */
  g_object_class_install_property (gobject_klass, PROP_CURRENT_VIDEO,
      g_param_spec_int ("current-video", "Current Video",
          "Currently playing video stream (-1 = auto)",
          -1, G_MAXINT, -1, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:n-audio
   *
   * Get the total number of available audio streams.
   */
  g_object_class_install_property (gobject_klass, PROP_N_AUDIO,
      g_param_spec_int ("n-audio", "Number Audio",
          "Total number of audio streams", 0, G_MAXINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:current-audio
   *
   * Get or set the currently playing audio stream. By default the first audio
   * stream with data is played.
   */
  g_object_class_install_property (gobject_klass, PROP_CURRENT_AUDIO,
      g_param_spec_int ("current-audio", "Current audio",
          "Currently playing audio stream (-1 = auto)",
          -1, G_MAXINT, -1, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:n-text
   *
   * Get the total number of available subtitle streams.
   */
  g_object_class_install_property (gobject_klass, PROP_N_TEXT,
      g_param_spec_int ("n-text", "Number Text",
          "Total number of text streams", 0, G_MAXINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:current-text:
   *
   * Get or set the currently playing subtitle stream. By default the first
   * subtitle stream with data is played.
   */
  g_object_class_install_property (gobject_klass, PROP_CURRENT_TEXT,
      g_param_spec_int ("current-text", "Current Text",
          "Currently playing text stream (-1 = auto)",
          -1, G_MAXINT, -1, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_SUBTITLE_ENCODING,
      g_param_spec_string ("subtitle-encoding", "subtitle encoding",
          "Encoding to assume if input subtitles are not in UTF-8 encoding. "
          "If not set, the GST_SUBTITLE_ENCODING environment variable will "
          "be checked for an encoding to use. If that is not set either, "
          "ISO-8859-15 will be assumed.", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_VIDEO_FILTER,
      g_param_spec_object ("video-filter", "Video filter",
          "the video filter(s) to apply, if possible",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_AUDIO_FILTER,
      g_param_spec_object ("audio-filter", "Audio filter",
          "the audio filter(s) to apply, if possible",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_VIDEO_SINK,
      g_param_spec_object ("video-sink", "Video Sink",
          "the video output element to use (NULL = default sink)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_AUDIO_SINK,
      g_param_spec_object ("audio-sink", "Audio Sink",
          "the audio output element to use (NULL = default sink)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_VIS_PLUGIN,
      g_param_spec_object ("vis-plugin", "Vis plugin",
          "the visualization element to use (NULL = default)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_TEXT_SINK,
      g_param_spec_object ("text-sink", "Text plugin",
          "the text output element to use (NULL = default subtitleoverlay)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:video-stream-combiner
   *
   * Get or set the current video stream combiner. By default, an input-selector
   * is created and deleted as-needed.
   */
  g_object_class_install_property (gobject_klass, PROP_VIDEO_STREAM_COMBINER,
      g_param_spec_object ("video-stream-combiner", "Video stream combiner",
          "Current video stream combiner (NULL = input-selector)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:audio-stream-combiner
   *
   * Get or set the current audio stream combiner. By default, an input-selector
   * is created and deleted as-needed.
   */
  g_object_class_install_property (gobject_klass, PROP_AUDIO_STREAM_COMBINER,
      g_param_spec_object ("audio-stream-combiner", "Audio stream combiner",
          "Current audio stream combiner (NULL = input-selector)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:text-stream-combiner
   *
   * Get or set the current text stream combiner. By default, an input-selector
   * is created and deleted as-needed.
   */
  g_object_class_install_property (gobject_klass, PROP_TEXT_STREAM_COMBINER,
      g_param_spec_object ("text-stream-combiner", "Text stream combiner",
          "Current text stream combiner (NULL = input-selector)",
          GST_TYPE_ELEMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:volume:
   *
   * Get or set the current audio stream volume. 1.0 means 100%,
   * 0.0 means mute. This uses a linear volume scale.
   *
   */
  g_object_class_install_property (gobject_klass, PROP_VOLUME,
      g_param_spec_double ("volume", "Volume", "The audio volume, 1.0=100%",
          0.0, VOLUME_MAX_DOUBLE, 1.0,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_MUTE,
      g_param_spec_boolean ("mute", "Mute",
          "Mute the audio channel without changing the volume", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:sample:
   * @playbin: a #GstPlayBin
   *
   * Get the currently rendered or prerolled sample in the video sink.
   * The #GstCaps in the sample will describe the format of the buffer.
   */
  g_object_class_install_property (gobject_klass, PROP_SAMPLE,
      g_param_spec_boxed ("sample", "Sample",
          "The last sample (NULL = no video available)",
          GST_TYPE_SAMPLE, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_FONT_DESC,
      g_param_spec_string ("subtitle-font-desc",
          "Subtitle font description",
          "Pango font description of font "
          "to be used for subtitle rendering", NULL,
          G_PARAM_WRITABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_CONNECTION_SPEED,
      g_param_spec_uint64 ("connection-speed", "Connection Speed",
          "Network connection speed in kbps (0 = unknown)",
          0, G_MAXUINT64 / 1000, DEFAULT_CONNECTION_SPEED,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_klass, PROP_BUFFER_SIZE,
      g_param_spec_int ("buffer-size", "Buffer size (bytes)",
          "Buffer size when buffering network streams",
          -1, G_MAXINT, DEFAULT_BUFFER_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_klass, PROP_BUFFER_DURATION,
      g_param_spec_int64 ("buffer-duration", "Buffer duration (ns)",
          "Buffer duration when buffering network streams",
          -1, G_MAXINT64, DEFAULT_BUFFER_DURATION,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstPlayBin:av-offset:
   *
   * Control the synchronisation offset between the audio and video streams.
   * Positive values make the audio ahead of the video and negative values make
   * the audio go behind the video.
   */
  g_object_class_install_property (gobject_klass, PROP_AV_OFFSET,
      g_param_spec_int64 ("av-offset", "AV Offset",
          "The synchronisation offset between audio and video in nanoseconds",
          G_MININT64, G_MAXINT64, 0,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin:ring-buffer-max-size
   *
   * The maximum size of the ring buffer in bytes. If set to 0, the ring
   * buffer is disabled. Default 0.
   */
  g_object_class_install_property (gobject_klass, PROP_RING_BUFFER_MAX_SIZE,
      g_param_spec_uint64 ("ring-buffer-max-size",
          "Max. ring buffer size (bytes)",
          "Max. amount of data in the ring buffer (bytes, 0 = ring buffer disabled)",
          0, G_MAXUINT, DEFAULT_RING_BUFFER_MAX_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin::force-aspect-ratio:
   *
   * Requests the video sink to enforce the video display aspect ratio.
   */
  g_object_class_install_property (gobject_klass, PROP_FORCE_ASPECT_RATIO,
      g_param_spec_boolean ("force-aspect-ratio", "Force Aspect Ratio",
          "When enabled, scaling will respect original aspect ratio", TRUE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstPlayBin::about-to-finish
   * @playbin: a #GstPlayBin
   *
   * This signal is emitted when the current uri is about to finish. You can
   * set the uri and suburi to make sure that playback continues.
   *
   * This signal is emitted from the context of a GStreamer streaming thread.
   */
  gst_play_bin_signals[SIGNAL_ABOUT_TO_FINISH] =
      g_signal_new ("about-to-finish", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, about_to_finish), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstPlayBin::video-changed
   * @playbin: a #GstPlayBin
   *
   * This signal is emitted whenever the number or order of the video
   * streams has changed. The application will most likely want to select
   * a new video stream.
   *
   * This signal is usually emitted from the context of a GStreamer streaming
   * thread. You can use gst_message_new_application() and
   * gst_element_post_message() to notify your application's main thread.
   */
  /* FIXME 0.11: turn video-changed signal into message? */
  gst_play_bin_signals[SIGNAL_VIDEO_CHANGED] =
      g_signal_new ("video-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, video_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0, G_TYPE_NONE);
  /**
   * GstPlayBin::audio-changed
   * @playbin: a #GstPlayBin
   *
   * This signal is emitted whenever the number or order of the audio
   * streams has changed. The application will most likely want to select
   * a new audio stream.
   *
   * This signal may be emitted from the context of a GStreamer streaming thread.
   * You can use gst_message_new_application() and gst_element_post_message()
   * to notify your application's main thread.
   */
  /* FIXME 0.11: turn audio-changed signal into message? */
  gst_play_bin_signals[SIGNAL_AUDIO_CHANGED] =
      g_signal_new ("audio-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, audio_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0, G_TYPE_NONE);
  /**
   * GstPlayBin::text-changed
   * @playbin: a #GstPlayBin
   *
   * This signal is emitted whenever the number or order of the text
   * streams has changed. The application will most likely want to select
   * a new text stream.
   *
   * This signal may be emitted from the context of a GStreamer streaming thread.
   * You can use gst_message_new_application() and gst_element_post_message()
   * to notify your application's main thread.
   */
  /* FIXME 0.11: turn text-changed signal into message? */
  gst_play_bin_signals[SIGNAL_TEXT_CHANGED] =
      g_signal_new ("text-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, text_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstPlayBin::video-tags-changed
   * @playbin: a #GstPlayBin
   * @stream: stream index with changed tags
   *
   * This signal is emitted whenever the tags of a video stream have changed.
   * The application will most likely want to get the new tags.
   *
   * This signal may be emitted from the context of a GStreamer streaming thread.
   * You can use gst_message_new_application() and gst_element_post_message()
   * to notify your application's main thread.
   */
  gst_play_bin_signals[SIGNAL_VIDEO_TAGS_CHANGED] =
      g_signal_new ("video-tags-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, video_tags_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);

  /**
   * GstPlayBin::audio-tags-changed
   * @playbin: a #GstPlayBin
   * @stream: stream index with changed tags
   *
   * This signal is emitted whenever the tags of an audio stream have changed.
   * The application will most likely want to get the new tags.
   *
   * This signal may be emitted from the context of a GStreamer streaming thread.
   * You can use gst_message_new_application() and gst_element_post_message()
   * to notify your application's main thread.
   */
  gst_play_bin_signals[SIGNAL_AUDIO_TAGS_CHANGED] =
      g_signal_new ("audio-tags-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, audio_tags_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);

  /**
   * GstPlayBin::text-tags-changed
   * @playbin: a #GstPlayBin
   * @stream: stream index with changed tags
   *
   * This signal is emitted whenever the tags of a text stream have changed.
   * The application will most likely want to get the new tags.
   *
   * This signal may be emitted from the context of a GStreamer streaming thread.
   * You can use gst_message_new_application() and gst_element_post_message()
   * to notify your application's main thread.
   */
  gst_play_bin_signals[SIGNAL_TEXT_TAGS_CHANGED] =
      g_signal_new ("text-tags-changed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstPlayBinClass, text_tags_changed), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);

  /**
   * GstPlayBin::source-setup:
   * @playbin: a #GstPlayBin
   * @source: source element
   *
   * This signal is emitted after the source element has been created, so
   * it can be configured by setting additional properties (e.g. set a
   * proxy server for an http source, or set the device and read speed for
   * an audio cd source). This is functionally equivalent to connecting to
   * the notify::source signal, but more convenient.
   *
   * This signal is usually emitted from the context of a GStreamer streaming
   * thread.
   */
  gst_play_bin_signals[SIGNAL_SOURCE_SETUP] =
      g_signal_new ("source-setup", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_ELEMENT);

  /**
   * GstPlayBin::get-video-tags
   * @playbin: a #GstPlayBin
   * @stream: a video stream number
   *
   * Action signal to retrieve the tags of a specific video stream number.
   * This information can be used to select a stream.
   *
   * Returns: a GstTagList with tags or NULL when the stream number does not
   * exist.
   */
  gst_play_bin_signals[SIGNAL_GET_VIDEO_TAGS] =
      g_signal_new ("get-video-tags", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_video_tags), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_TAG_LIST, 1, G_TYPE_INT);
  /**
   * GstPlayBin::get-audio-tags
   * @playbin: a #GstPlayBin
   * @stream: an audio stream number
   *
   * Action signal to retrieve the tags of a specific audio stream number.
   * This information can be used to select a stream.
   *
   * Returns: a GstTagList with tags or NULL when the stream number does not
   * exist.
   */
  gst_play_bin_signals[SIGNAL_GET_AUDIO_TAGS] =
      g_signal_new ("get-audio-tags", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_audio_tags), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_TAG_LIST, 1, G_TYPE_INT);
  /**
   * GstPlayBin::get-text-tags
   * @playbin: a #GstPlayBin
   * @stream: a text stream number
   *
   * Action signal to retrieve the tags of a specific text stream number.
   * This information can be used to select a stream.
   *
   * Returns: a GstTagList with tags or NULL when the stream number does not
   * exist.
   */
  gst_play_bin_signals[SIGNAL_GET_TEXT_TAGS] =
      g_signal_new ("get-text-tags", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_text_tags), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_TAG_LIST, 1, G_TYPE_INT);
  /**
   * GstPlayBin::convert-sample
   * @playbin: a #GstPlayBin
   * @caps: the target format of the frame
   *
   * Action signal to retrieve the currently playing video frame in the format
   * specified by @caps.
   * If @caps is %NULL, no conversion will be performed and this function is
   * equivalent to the #GstPlayBin::frame property.
   *
   * Returns: a #GstSample of the current video frame converted to #caps.
   * The caps on the sample will describe the final layout of the buffer data.
   * %NULL is returned when no current buffer can be retrieved or when the
   * conversion failed.
   */
  gst_play_bin_signals[SIGNAL_CONVERT_SAMPLE] =
      g_signal_new ("convert-sample", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, convert_sample), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_SAMPLE, 1, GST_TYPE_CAPS);

  /**
   * GstPlayBin::get-video-pad
   * @playbin: a #GstPlayBin
   * @stream: a video stream number
   *
   * Action signal to retrieve the stream-combiner sinkpad for a specific
   * video stream.
   * This pad can be used for notifications of caps changes, stream-specific
   * queries, etc.
   *
   * Returns: a #GstPad, or NULL when the stream number does not exist.
   */
  gst_play_bin_signals[SIGNAL_GET_VIDEO_PAD] =
      g_signal_new ("get-video-pad", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_video_pad), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_PAD, 1, G_TYPE_INT);
  /**
   * GstPlayBin::get-audio-pad
   * @playbin: a #GstPlayBin
   * @stream: an audio stream number
   *
   * Action signal to retrieve the stream-combiner sinkpad for a specific
   * audio stream.
   * This pad can be used for notifications of caps changes, stream-specific
   * queries, etc.
   *
   * Returns: a #GstPad, or NULL when the stream number does not exist.
   */
  gst_play_bin_signals[SIGNAL_GET_AUDIO_PAD] =
      g_signal_new ("get-audio-pad", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_audio_pad), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_PAD, 1, G_TYPE_INT);
  /**
   * GstPlayBin::get-text-pad
   * @playbin: a #GstPlayBin
   * @stream: a text stream number
   *
   * Action signal to retrieve the stream-combiner sinkpad for a specific
   * text stream.
   * This pad can be used for notifications of caps changes, stream-specific
   * queries, etc.
   *
   * Returns: a #GstPad, or NULL when the stream number does not exist.
   */
  gst_play_bin_signals[SIGNAL_GET_TEXT_PAD] =
      g_signal_new ("get-text-pad", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstPlayBinClass, get_text_pad), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_PAD, 1, G_TYPE_INT);

  klass->get_video_tags = gst_play_bin_get_video_tags;
  klass->get_audio_tags = gst_play_bin_get_audio_tags;
  klass->get_text_tags = gst_play_bin_get_text_tags;

  klass->convert_sample = gst_play_bin_convert_sample;

  klass->get_video_pad = gst_play_bin_get_video_pad;
  klass->get_audio_pad = gst_play_bin_get_audio_pad;
  klass->get_text_pad = gst_play_bin_get_text_pad;

  gst_element_class_set_static_metadata (gstelement_klass,
      "Player Bin 2", "Generic/Bin/Player",
      "Autoplug and play media from an uri",
      "Wim Taymans <wim.taymans@gmail.com>");

  gstelement_klass->change_state =
      GST_DEBUG_FUNCPTR (gst_play_bin_change_state);
  gstelement_klass->query = GST_DEBUG_FUNCPTR (gst_play_bin_query);
  gstelement_klass->set_context = GST_DEBUG_FUNCPTR (gst_play_bin_set_context);

  gstbin_klass->handle_message =
      GST_DEBUG_FUNCPTR (gst_play_bin_handle_message);
}

static void
init_group (GstPlayBin * playbin, GstSourceGroup * group)
{
  /* store the array for the different channels */
  group->video_channels = g_ptr_array_new ();
  group->audio_channels = g_ptr_array_new ();
  group->text_channels = g_ptr_array_new ();
  g_mutex_init (&group->lock);

  group->stream_changed_pending = FALSE;
  g_mutex_init (&group->stream_changed_pending_lock);

  /* init combiners. The combiner is found by finding the first prefix that
   * matches the media. */
  group->playbin = playbin;
  /* If you add any items to these lists, check that media_list[] is defined
   * above to be large enough to hold MAX(items)+1, so as to accommodate a
   * NULL terminator (set when the memory is zeroed on allocation) */
  group->combiner[PLAYBIN_STREAM_AUDIO].media_list[0] = "audio/";
  group->combiner[PLAYBIN_STREAM_AUDIO].type = GST_PLAY_SINK_TYPE_AUDIO;
  group->combiner[PLAYBIN_STREAM_AUDIO].channels = group->audio_channels;
  group->combiner[PLAYBIN_STREAM_VIDEO].media_list[0] = "video/";
  group->combiner[PLAYBIN_STREAM_VIDEO].media_list[1] = "image/";
  group->combiner[PLAYBIN_STREAM_VIDEO].type = GST_PLAY_SINK_TYPE_VIDEO;
  group->combiner[PLAYBIN_STREAM_VIDEO].channels = group->video_channels;
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[0] = "text/";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[1] = "application/x-subtitle";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[2] = "application/x-ssa";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[3] = "application/x-ass";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[4] = "subpicture/x-dvd";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[5] = "subpicture/";
  group->combiner[PLAYBIN_STREAM_TEXT].media_list[6] = "subtitle/";
  group->combiner[PLAYBIN_STREAM_TEXT].get_media_caps =
      gst_subtitle_overlay_create_factory_caps;
  group->combiner[PLAYBIN_STREAM_TEXT].type = GST_PLAY_SINK_TYPE_TEXT;
  group->combiner[PLAYBIN_STREAM_TEXT].channels = group->text_channels;
}

static void
free_group (GstPlayBin * playbin, GstSourceGroup * group)
{
  g_free (group->uri);
  g_free (group->suburi);
  g_ptr_array_free (group->video_channels, TRUE);
  g_ptr_array_free (group->audio_channels, TRUE);
  g_ptr_array_free (group->text_channels, TRUE);

  g_mutex_clear (&group->lock);
  if (group->audio_sink)
    gst_object_unref (group->audio_sink);
  group->audio_sink = NULL;
  if (group->video_sink)
    gst_object_unref (group->video_sink);
  group->video_sink = NULL;
  if (group->text_sink)
    gst_object_unref (group->text_sink);
  group->text_sink = NULL;

  group->stream_changed_pending = FALSE;
  g_mutex_clear (&group->stream_changed_pending_lock);

  g_slist_free (group->suburi_flushes_to_drop);
  group->suburi_flushes_to_drop = NULL;

  if (group->suburi_flushes_to_drop_lock.p)
    g_mutex_clear (&group->suburi_flushes_to_drop_lock);
  group->suburi_flushes_to_drop_lock.p = NULL;
}

static void
notify_volume_cb (GObject * combiner, GParamSpec * pspec, GstPlayBin * playbin)
{
  g_object_notify (G_OBJECT (playbin), "volume");
}

static void
notify_mute_cb (GObject * combiner, GParamSpec * pspec, GstPlayBin * playbin)
{
  g_object_notify (G_OBJECT (playbin), "mute");
}

static void
colorbalance_value_changed_cb (GstColorBalance * balance,
    GstColorBalanceChannel * channel, gint value, GstPlayBin * playbin)
{
  gst_color_balance_value_changed (GST_COLOR_BALANCE (playbin), channel, value);
}

static gint
compare_factories_func (gconstpointer p1, gconstpointer p2)
{
  GstPluginFeature *f1, *f2;
  gboolean is_sink1, is_sink2;
  gboolean is_parser1, is_parser2;

  f1 = (GstPluginFeature *) p1;
  f2 = (GstPluginFeature *) p2;

  is_sink1 = gst_element_factory_list_is_type (GST_ELEMENT_FACTORY_CAST (f1),
      GST_ELEMENT_FACTORY_TYPE_SINK);
  is_sink2 = gst_element_factory_list_is_type (GST_ELEMENT_FACTORY_CAST (f2),
      GST_ELEMENT_FACTORY_TYPE_SINK);
  is_parser1 = gst_element_factory_list_is_type (GST_ELEMENT_FACTORY_CAST (f1),
      GST_ELEMENT_FACTORY_TYPE_PARSER);
  is_parser2 = gst_element_factory_list_is_type (GST_ELEMENT_FACTORY_CAST (f2),
      GST_ELEMENT_FACTORY_TYPE_PARSER);

  /* First we want all sinks as we prefer a sink if it directly
   * supports the current caps */
  if (is_sink1 && !is_sink2)
    return -1;
  else if (!is_sink1 && is_sink2)
    return 1;

  /* Then we want all parsers as we always want to plug parsers
   * before decoders */
  if (is_parser1 && !is_parser2)
    return -1;
  else if (!is_parser1 && is_parser2)
    return 1;

  /* And if it's a both a parser or sink we first sort by rank
   * and then by factory name */
  return gst_plugin_feature_rank_compare_func (p1, p2);
}

/* Must be called with elements lock! */
static void
gst_play_bin_update_elements_list (GstPlayBin * playbin)
{
  GList *res, *tmp;
  guint cookie;

  cookie = gst_registry_get_feature_list_cookie (gst_registry_get ());

  if (!playbin->elements || playbin->elements_cookie != cookie) {
    if (playbin->elements)
      gst_plugin_feature_list_free (playbin->elements);
    res =
        gst_element_factory_list_get_elements
        (GST_ELEMENT_FACTORY_TYPE_DECODABLE, GST_RANK_MARGINAL);
    tmp =
        gst_element_factory_list_get_elements
        (GST_ELEMENT_FACTORY_TYPE_AUDIOVIDEO_SINKS, GST_RANK_MARGINAL);
    playbin->elements = g_list_concat (res, tmp);
    playbin->elements = g_list_sort (playbin->elements, compare_factories_func);
  }

  if (!playbin->aelements || playbin->elements_cookie != cookie) {
    if (playbin->aelements)
      g_sequence_free (playbin->aelements);
    playbin->aelements = avelements_create (playbin, TRUE);
  }

  if (!playbin->velements || playbin->elements_cookie != cookie) {
    if (playbin->velements)
      g_sequence_free (playbin->velements);
    playbin->velements = avelements_create (playbin, FALSE);
  }

  playbin->elements_cookie = cookie;
}

static void
gst_play_bin_init (GstPlayBin * playbin)
{
  g_rec_mutex_init (&playbin->lock);
  g_mutex_init (&playbin->dyn_lock);

  /* assume we can create an input-selector */
  playbin->have_selector = TRUE;

  /* init groups */
  playbin->curr_group = &playbin->groups[0];
  playbin->next_group = &playbin->groups[1];
  init_group (playbin, &playbin->groups[0]);
  init_group (playbin, &playbin->groups[1]);

  /* first filter out the interesting element factories */
  g_mutex_init (&playbin->elements_lock);

  /* add sink */
  playbin->playsink =
      g_object_new (GST_TYPE_PLAY_SINK, "name", "playsink", "send-event-mode",
      1, NULL);
  gst_bin_add (GST_BIN_CAST (playbin), GST_ELEMENT_CAST (playbin->playsink));
  gst_play_sink_set_flags (playbin->playsink, DEFAULT_FLAGS);
  /* Connect to notify::volume and notify::mute signals for proxying */
  g_signal_connect (playbin->playsink, "notify::volume",
      G_CALLBACK (notify_volume_cb), playbin);
  g_signal_connect (playbin->playsink, "notify::mute",
      G_CALLBACK (notify_mute_cb), playbin);
  g_signal_connect (playbin->playsink, "value-changed",
      G_CALLBACK (colorbalance_value_changed_cb), playbin);

  playbin->current_video = DEFAULT_CURRENT_VIDEO;
  playbin->current_audio = DEFAULT_CURRENT_AUDIO;
  playbin->current_text = DEFAULT_CURRENT_TEXT;

  playbin->buffer_duration = DEFAULT_BUFFER_DURATION;
  playbin->buffer_size = DEFAULT_BUFFER_SIZE;
  playbin->ring_buffer_max_size = DEFAULT_RING_BUFFER_MAX_SIZE;

  playbin->force_aspect_ratio = TRUE;
}

static void
gst_play_bin_finalize (GObject * object)
{
  GstPlayBin *playbin;

  playbin = GST_PLAY_BIN (object);

  free_group (playbin, &playbin->groups[0]);
  free_group (playbin, &playbin->groups[1]);

  if (playbin->source)
    gst_object_unref (playbin->source);

  /* Setting states to NULL is safe here because playsink
   * will already be gone and none of these sinks will be
   * a child of playsink
   */
  if (playbin->video_sink) {
    gst_element_set_state (playbin->video_sink, GST_STATE_NULL);
    gst_object_unref (playbin->video_sink);
  }
  if (playbin->audio_sink) {
    gst_element_set_state (playbin->audio_sink, GST_STATE_NULL);
    gst_object_unref (playbin->audio_sink);
  }
  if (playbin->text_sink) {
    gst_element_set_state (playbin->text_sink, GST_STATE_NULL);
    gst_object_unref (playbin->text_sink);
  }

  if (playbin->video_stream_combiner) {
    gst_element_set_state (playbin->video_stream_combiner, GST_STATE_NULL);
    gst_object_unref (playbin->video_stream_combiner);
  }
  if (playbin->audio_stream_combiner) {
    gst_element_set_state (playbin->audio_stream_combiner, GST_STATE_NULL);
    gst_object_unref (playbin->audio_stream_combiner);
  }
  if (playbin->text_stream_combiner) {
    gst_element_set_state (playbin->text_stream_combiner, GST_STATE_NULL);
    gst_object_unref (playbin->text_stream_combiner);
  }

  if (playbin->elements)
    gst_plugin_feature_list_free (playbin->elements);

  if (playbin->aelements)
    g_sequence_free (playbin->aelements);

  if (playbin->velements)
    g_sequence_free (playbin->velements);

  g_list_free_full (playbin->contexts, (GDestroyNotify) gst_context_unref);

  g_rec_mutex_clear (&playbin->lock);
  g_mutex_clear (&playbin->dyn_lock);
  g_mutex_clear (&playbin->elements_lock);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_playbin_uri_is_valid (GstPlayBin * playbin, const gchar * uri)
{
  const gchar *c;

  GST_LOG_OBJECT (playbin, "checking uri '%s'", uri);

  /* this just checks the protocol */
  if (!gst_uri_is_valid (uri))
    return FALSE;

  for (c = uri; *c != '\0'; ++c) {
    if (!g_ascii_isprint (*c))
      goto invalid;
    if (*c == ' ')
      goto invalid;
  }

  return TRUE;

invalid:
  {
    GST_WARNING_OBJECT (playbin, "uri '%s' not valid, character #%u",
        uri, (guint) ((guintptr) c - (guintptr) uri));
    return FALSE;
  }
}

static void
gst_play_bin_set_uri (GstPlayBin * playbin, const gchar * uri)
{
  GstSourceGroup *group;

  if (uri == NULL) {
    g_warning ("cannot set NULL uri");
    return;
  }

  if (!gst_playbin_uri_is_valid (playbin, uri)) {
    if (g_str_has_prefix (uri, "file:")) {
      GST_WARNING_OBJECT (playbin, "not entirely correct file URI '%s' - make "
          "sure to escape spaces and non-ASCII characters properly and specify "
          "an absolute path. Use gst_filename_to_uri() to convert filenames "
          "to URIs", uri);
    } else {
      /* GST_ERROR_OBJECT (playbin, "malformed URI '%s'", uri); */
    }
  }

  GST_PLAY_BIN_LOCK (playbin);
  group = playbin->next_group;

  GST_SOURCE_GROUP_LOCK (group);
  /* store the uri in the next group we will play */
  g_free (group->uri);
  group->uri = g_strdup (uri);
  group->valid = TRUE;
  GST_SOURCE_GROUP_UNLOCK (group);

  GST_DEBUG ("set new uri to %s", uri);
  GST_PLAY_BIN_UNLOCK (playbin);
}

static void
gst_play_bin_set_suburi (GstPlayBin * playbin, const gchar * suburi)
{
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = playbin->next_group;

  GST_SOURCE_GROUP_LOCK (group);
  g_free (group->suburi);
  group->suburi = g_strdup (suburi);
  GST_SOURCE_GROUP_UNLOCK (group);

  GST_DEBUG ("setting new .sub uri to %s", suburi);

  GST_PLAY_BIN_UNLOCK (playbin);
}

static void
gst_play_bin_set_flags (GstPlayBin * playbin, GstPlayFlags flags)
{
  gst_play_sink_set_flags (playbin->playsink, flags);
  gst_play_sink_reconfigure (playbin->playsink);
}

static GstPlayFlags
gst_play_bin_get_flags (GstPlayBin * playbin)
{
  GstPlayFlags flags;

  flags = gst_play_sink_get_flags (playbin->playsink);

  return flags;
}

/* get the currently playing group or if nothing is playing, the next
 * group. Must be called with the PLAY_BIN_LOCK. */
static GstSourceGroup *
get_group (GstPlayBin * playbin)
{
  GstSourceGroup *result;

  if (!(result = playbin->curr_group))
    result = playbin->next_group;

  return result;
}

static GstPad *
gst_play_bin_get_video_pad (GstPlayBin * playbin, gint stream)
{
  GstPad *sinkpad = NULL;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  if (stream < group->video_channels->len) {
    sinkpad = g_ptr_array_index (group->video_channels, stream);
    gst_object_ref (sinkpad);
  }
  GST_PLAY_BIN_UNLOCK (playbin);

  return sinkpad;
}

static GstPad *
gst_play_bin_get_audio_pad (GstPlayBin * playbin, gint stream)
{
  GstPad *sinkpad = NULL;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  if (stream < group->audio_channels->len) {
    sinkpad = g_ptr_array_index (group->audio_channels, stream);
    gst_object_ref (sinkpad);
  }
  GST_PLAY_BIN_UNLOCK (playbin);

  return sinkpad;
}

static GstPad *
gst_play_bin_get_text_pad (GstPlayBin * playbin, gint stream)
{
  GstPad *sinkpad = NULL;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  if (stream < group->text_channels->len) {
    sinkpad = g_ptr_array_index (group->text_channels, stream);
    gst_object_ref (sinkpad);
  }
  GST_PLAY_BIN_UNLOCK (playbin);

  return sinkpad;
}


static GstTagList *
get_tags (GstPlayBin * playbin, GstSourceGroup * group, gint type, gint stream)
{
  GstTagList *result;
  GPtrArray *channels;
  GstPad *sinkpad;

  switch (type) {
    case PLAYBIN_STREAM_AUDIO:
      channels = group->audio_channels;
      break;
    case PLAYBIN_STREAM_VIDEO:
      channels = group->video_channels;
      break;
    case PLAYBIN_STREAM_TEXT:
      channels = group->text_channels;
      break;
    default:
      channels = NULL;
      break;
  }

  if (!channels || stream >= channels->len || !group->combiner[type].has_tags)
    return NULL;

  sinkpad = g_ptr_array_index (channels, stream);
  g_object_get (sinkpad, "tags", &result, NULL);

  return result;
}

static GstTagList *
gst_play_bin_get_video_tags (GstPlayBin * playbin, gint stream)
{
  GstTagList *result;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  result = get_tags (playbin, group, PLAYBIN_STREAM_VIDEO, stream);
  GST_PLAY_BIN_UNLOCK (playbin);

  return result;
}

static GstTagList *
gst_play_bin_get_audio_tags (GstPlayBin * playbin, gint stream)
{
  GstTagList *result;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  result = get_tags (playbin, group, PLAYBIN_STREAM_AUDIO, stream);
  GST_PLAY_BIN_UNLOCK (playbin);

  return result;
}

static GstTagList *
gst_play_bin_get_text_tags (GstPlayBin * playbin, gint stream)
{
  GstTagList *result;
  GstSourceGroup *group;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);
  result = get_tags (playbin, group, PLAYBIN_STREAM_TEXT, stream);
  GST_PLAY_BIN_UNLOCK (playbin);

  return result;
}

static GstSample *
gst_play_bin_convert_sample (GstPlayBin * playbin, GstCaps * caps)
{
  return gst_play_sink_convert_sample (playbin->playsink, caps);
}

/* Returns current stream number, or -1 if none has been selected yet */
static int
get_current_stream_number (GstPlayBin * playbin, GstSourceCombine * combine,
    GPtrArray * channels)
{
  /* Internal API cleanup would make this easier... */
  int i;
  GstPad *pad, *current;
  GstObject *combiner = NULL;
  int ret = -1;

  if (!combine->has_active_pad) {
    GST_WARNING_OBJECT (playbin,
        "combiner doesn't have the \"active-pad\" property");
    return ret;
  }

  for (i = 0; i < channels->len; i++) {
    pad = g_ptr_array_index (channels, i);
    if ((combiner = gst_pad_get_parent (pad))) {
      g_object_get (combiner, "active-pad", &current, NULL);
      gst_object_unref (combiner);

      if (pad == current) {
        gst_object_unref (current);
        ret = i;
        break;
      }

      if (current)
        gst_object_unref (current);
    }
  }

  return ret;
}

static gboolean
gst_play_bin_send_custom_event (GstObject * combiner, const gchar * event_name)
{
  GstPad *src;
  GstPad *peer;
  GstStructure *s;
  GstEvent *event;
  gboolean ret = FALSE;

  src = gst_element_get_static_pad (GST_ELEMENT_CAST (combiner), "src");
  peer = gst_pad_get_peer (src);
  if (peer) {
    s = gst_structure_new_empty (event_name);
    event = gst_event_new_custom (GST_EVENT_CUSTOM_DOWNSTREAM_OOB, s);
    gst_pad_send_event (peer, event);
    gst_object_unref (peer);
    ret = TRUE;
  }
  gst_object_unref (src);
  return ret;
}

static gboolean
gst_play_bin_set_current_video_stream (GstPlayBin * playbin, gint stream)
{
  GstSourceGroup *group;
  GPtrArray *channels;
  GstPad *sinkpad;

  GST_PLAY_BIN_LOCK (playbin);

  GST_DEBUG_OBJECT (playbin, "Changing current video stream %d -> %d",
      playbin->current_video, stream);

  group = get_group (playbin);
  if (!group->combiner[PLAYBIN_STREAM_VIDEO].has_active_pad)
    goto no_active_pad;
  if (!(channels = group->video_channels))
    goto no_channels;

  if (stream == -1 || channels->len <= stream) {
    sinkpad = NULL;
  } else {
    /* take channel from selected stream */
    sinkpad = g_ptr_array_index (channels, stream);
  }

  if (sinkpad)
    gst_object_ref (sinkpad);
  GST_PLAY_BIN_UNLOCK (playbin);

  if (sinkpad) {
    GstObject *combiner;

    if ((combiner = gst_pad_get_parent (sinkpad))) {
      GstPad *old_sinkpad;

      g_object_get (combiner, "active-pad", &old_sinkpad, NULL);

      if (old_sinkpad != sinkpad) {
        if (gst_play_bin_send_custom_event (combiner,
                "playsink-custom-video-flush"))
          playbin->video_pending_flush_finish = TRUE;

        /* activate the selected pad */
        g_object_set (combiner, "active-pad", sinkpad, NULL);
      }

      gst_object_unref (combiner);
    }
    gst_object_unref (sinkpad);
  }
  return TRUE;

no_active_pad:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    GST_WARNING_OBJECT (playbin,
        "can't switch video, the stream combiner's sink pads don't have the \"active-pad\" property");
    return FALSE;
  }
no_channels:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    GST_DEBUG_OBJECT (playbin, "can't switch video, we have no channels");
    return FALSE;
  }
}

static gboolean
gst_play_bin_set_current_audio_stream (GstPlayBin * playbin, gint stream)
{
  GstSourceGroup *group;
  GPtrArray *channels;
  GstPad *sinkpad;

  GST_PLAY_BIN_LOCK (playbin);

  GST_DEBUG_OBJECT (playbin, "Changing current audio stream %d -> %d",
      playbin->current_audio, stream);

  group = get_group (playbin);
  if (!group->combiner[PLAYBIN_STREAM_AUDIO].has_active_pad)
    goto no_active_pad;
  if (!(channels = group->audio_channels))
    goto no_channels;

  if (stream == -1 || channels->len <= stream) {
    sinkpad = NULL;
  } else {
    /* take channel from selected stream */
    sinkpad = g_ptr_array_index (channels, stream);
  }

  if (sinkpad)
    gst_object_ref (sinkpad);
  GST_PLAY_BIN_UNLOCK (playbin);

  if (sinkpad) {
    GstObject *combiner;

    if ((combiner = gst_pad_get_parent (sinkpad))) {
      GstPad *old_sinkpad;

      g_object_get (combiner, "active-pad", &old_sinkpad, NULL);

      if (old_sinkpad != sinkpad) {
        if (gst_play_bin_send_custom_event (combiner,
                "playsink-custom-audio-flush"))
          playbin->audio_pending_flush_finish = TRUE;

        /* activate the selected pad */
        g_object_set (combiner, "active-pad", sinkpad, NULL);
      }
      gst_object_unref (combiner);
    }
    gst_object_unref (sinkpad);
  }
  return TRUE;

no_active_pad:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    GST_WARNING_OBJECT (playbin,
        "can't switch audio, the stream combiner's sink pads don't have the \"active-pad\" property");
    return FALSE;
  }
no_channels:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    GST_DEBUG_OBJECT (playbin, "can't switch audio, we have no channels");
    return FALSE;
  }
}

static void
gst_play_bin_suburidecodebin_seek_to_start (GstSourceGroup * group)
{
  GstElement *suburidecodebin = group->suburidecodebin;
  GstIterator *it = gst_element_iterate_src_pads (suburidecodebin);
  GstPad *sinkpad;
  GValue item = { 0, };

  if (it && gst_iterator_next (it, &item) == GST_ITERATOR_OK
      && ((sinkpad = g_value_get_object (&item)) != NULL)) {
    GstEvent *event;
    guint32 seqnum;

    event =
        gst_event_new_seek (1.0, GST_FORMAT_BYTES, GST_SEEK_FLAG_FLUSH,
        GST_SEEK_TYPE_SET, 0, GST_SEEK_TYPE_NONE, -1);
    seqnum = gst_event_get_seqnum (event);

    /* store the seqnum to drop flushes from this seek later */
    g_mutex_lock (&group->suburi_flushes_to_drop_lock);
    group->suburi_flushes_to_drop =
        g_slist_append (group->suburi_flushes_to_drop,
        GUINT_TO_POINTER (seqnum));
    g_mutex_unlock (&group->suburi_flushes_to_drop_lock);

    if (!gst_pad_send_event (sinkpad, event)) {
      event =
          gst_event_new_seek (1.0, GST_FORMAT_TIME, GST_SEEK_FLAG_FLUSH,
          GST_SEEK_TYPE_SET, 0, GST_SEEK_TYPE_NONE, -1);
      gst_event_set_seqnum (event, seqnum);
      if (!gst_pad_send_event (sinkpad, event)) {
        GST_DEBUG_OBJECT (suburidecodebin, "Seeking to the beginning failed!");

        g_mutex_lock (&group->suburi_flushes_to_drop_lock);
        group->suburi_flushes_to_drop =
            g_slist_remove (group->suburi_flushes_to_drop,
            GUINT_TO_POINTER (seqnum));
        g_mutex_unlock (&group->suburi_flushes_to_drop_lock);
      }
    }

    g_value_unset (&item);
  }

  if (it)
    gst_iterator_free (it);
}


static GstPadProbeReturn
block_serialized_data_cb (GstPad * pad, GstPadProbeInfo * info,
    gpointer user_data)
{
  if (GST_IS_EVENT (info->data) && !GST_EVENT_IS_SERIALIZED (info->data)) {
    GST_DEBUG_OBJECT (pad, "Letting non-serialized event %s pass",
        GST_EVENT_TYPE_NAME (info->data));
    return GST_PAD_PROBE_PASS;
  }

  return GST_PAD_PROBE_OK;
}

static void
gst_play_bin_suburidecodebin_block (GstSourceGroup * group,
    GstElement * suburidecodebin, gboolean block)
{
  GstIterator *it = gst_element_iterate_src_pads (suburidecodebin);
  gboolean done = FALSE;
  GValue item = { 0, };

  GST_DEBUG_OBJECT (suburidecodebin, "Blocking suburidecodebin: %d", block);

  if (!it)
    return;
  while (!done) {
    GstPad *sinkpad;

    switch (gst_iterator_next (it, &item)) {
      case GST_ITERATOR_OK:
        sinkpad = g_value_get_object (&item);
        if (block) {
          group->block_id =
              gst_pad_add_probe (sinkpad, GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM,
              block_serialized_data_cb, NULL, NULL);
        } else if (group->block_id) {
          gst_pad_remove_probe (sinkpad, group->block_id);
          group->block_id = 0;
        }
        g_value_reset (&item);
        break;
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (it);
        break;
      case GST_ITERATOR_ERROR:
        done = TRUE;
        break;
    }
  }
  g_value_unset (&item);
  gst_iterator_free (it);
}

static gboolean
gst_play_bin_set_current_text_stream (GstPlayBin * playbin, gint stream)
{
  GstSourceGroup *group;
  GPtrArray *channels;
  GstPad *sinkpad;

  GST_PLAY_BIN_LOCK (playbin);

  GST_DEBUG_OBJECT (playbin, "Changing current text stream %d -> %d",
      playbin->current_text, stream);

  group = get_group (playbin);
  if (!group->combiner[PLAYBIN_STREAM_TEXT].has_active_pad)
    goto no_active_pad;
  if (!(channels = group->text_channels))
    goto no_channels;

  if (stream == -1 || channels->len <= stream) {
    sinkpad = NULL;
  } else {
    /* take channel from selected stream */
    sinkpad = g_ptr_array_index (channels, stream);
  }

  if (sinkpad)
    gst_object_ref (sinkpad);
  GST_PLAY_BIN_UNLOCK (playbin);

  if (sinkpad) {
    GstObject *combiner;

    if ((combiner = gst_pad_get_parent (sinkpad))) {
      GstPad *old_sinkpad;

      g_object_get (combiner, "active-pad", &old_sinkpad, NULL);

      if (old_sinkpad != sinkpad) {
        gboolean need_unblock, need_block, need_seek;
        GstPad *peer = NULL, *oldpeer = NULL;
        GstElement *parent_element = NULL, *old_parent_element = NULL;

        /* Now check if we need to seek the suburidecodebin to the beginning
         * or if we need to block all suburidecodebin sinkpads or if we need
         * to unblock all suburidecodebin sinkpads
         */
        if (sinkpad)
          peer = gst_pad_get_peer (sinkpad);
        if (old_sinkpad)
          oldpeer = gst_pad_get_peer (old_sinkpad);

        if (peer)
          parent_element = gst_pad_get_parent_element (peer);
        if (oldpeer)
          old_parent_element = gst_pad_get_parent_element (oldpeer);

        need_block = (old_parent_element == group->suburidecodebin
            && parent_element != old_parent_element);
        need_unblock = (parent_element == group->suburidecodebin
            && parent_element != old_parent_element);
        need_seek = (parent_element == group->suburidecodebin);

        if (peer)
          gst_object_unref (peer);
        if (oldpeer)
          gst_object_unref (oldpeer);
        if (parent_element)
          gst_object_unref (parent_element);
        if (old_parent_element)
          gst_object_unref (old_parent_element);

        /* Block all suburidecodebin sinkpads */
        if (need_block)
          gst_play_bin_suburidecodebin_block (group, group->suburidecodebin,
              TRUE);

        if (gst_play_bin_send_custom_event (combiner,
                "playsink-custom-subtitle-flush"))
          playbin->text_pending_flush_finish = TRUE;

        /* activate the selected pad */
        g_object_set (combiner, "active-pad", sinkpad, NULL);

        /* Unblock pads if necessary */
        if (need_unblock)
          gst_play_bin_suburidecodebin_block (group, group->suburidecodebin,
              FALSE);

        /* seek to the beginning */
        if (need_seek)
          gst_play_bin_suburidecodebin_seek_to_start (group);
      }
      gst_object_unref (combiner);

      if (old_sinkpad)
        gst_object_unref (old_sinkpad);
    }
    gst_object_unref (sinkpad);
  }
  return TRUE;

no_active_pad:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    GST_WARNING_OBJECT (playbin,
        "can't switch text, the stream combiner's sink pads don't have the \"active-pad\" property");
    return FALSE;
  }
no_channels:
  {
    GST_PLAY_BIN_UNLOCK (playbin);
    return FALSE;
  }
}

static void
gst_play_bin_set_sink (GstPlayBin * playbin, GstPlaySinkType type,
    const gchar * dbg, GstElement ** elem, GstElement * sink)
{
  GST_INFO_OBJECT (playbin, "Setting %s sink to %" GST_PTR_FORMAT, dbg, sink);

  gst_play_sink_set_sink (playbin->playsink, type, sink);

  if (*elem)
    gst_object_unref (*elem);
  *elem = sink ? gst_object_ref (sink) : NULL;
}

static void
gst_play_bin_set_stream_combiner (GstPlayBin * playbin, GstElement ** elem,
    const gchar * dbg, GstElement * combiner)
{
  GST_INFO_OBJECT (playbin, "Setting %s stream combiner to %" GST_PTR_FORMAT,
      dbg, combiner);

  GST_PLAY_BIN_LOCK (playbin);
  if (*elem != combiner) {
    GstElement *old;

    old = *elem;
    if (combiner)
      gst_object_ref_sink (combiner);

    *elem = combiner;
    if (old)
      gst_object_unref (old);
  }
  GST_LOG_OBJECT (playbin, "%s stream combiner now %" GST_PTR_FORMAT, dbg,
      *elem);
  GST_PLAY_BIN_UNLOCK (playbin);
}

static void
gst_play_bin_set_encoding (GstPlayBin * playbin, const gchar * encoding)
{
  GstElement *elem;

  GST_PLAY_BIN_LOCK (playbin);

  /* set subtitles on all current and next decodebins. */
  if ((elem = playbin->groups[0].uridecodebin))
    g_object_set (G_OBJECT (elem), "subtitle-encoding", encoding, NULL);
  if ((elem = playbin->groups[0].suburidecodebin))
    g_object_set (G_OBJECT (elem), "subtitle-encoding", encoding, NULL);
  if ((elem = playbin->groups[1].uridecodebin))
    g_object_set (G_OBJECT (elem), "subtitle-encoding", encoding, NULL);
  if ((elem = playbin->groups[1].suburidecodebin))
    g_object_set (G_OBJECT (elem), "subtitle-encoding", encoding, NULL);

  gst_play_sink_set_subtitle_encoding (playbin->playsink, encoding);
  GST_PLAY_BIN_UNLOCK (playbin);
}

static void
gst_play_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstPlayBin *playbin = GST_PLAY_BIN (object);

  switch (prop_id) {
    case PROP_URI:
      gst_play_bin_set_uri (playbin, g_value_get_string (value));
      break;
    case PROP_SUBURI:
      gst_play_bin_set_suburi (playbin, g_value_get_string (value));
      break;
    case PROP_FLAGS:
      gst_play_bin_set_flags (playbin, g_value_get_flags (value));
      break;
    case PROP_CURRENT_VIDEO:
      gst_play_bin_set_current_video_stream (playbin, g_value_get_int (value));
      break;
    case PROP_CURRENT_AUDIO:
      gst_play_bin_set_current_audio_stream (playbin, g_value_get_int (value));
      break;
    case PROP_CURRENT_TEXT:
      gst_play_bin_set_current_text_stream (playbin, g_value_get_int (value));
      break;
    case PROP_SUBTITLE_ENCODING:
      gst_play_bin_set_encoding (playbin, g_value_get_string (value));
      break;
    case PROP_VIDEO_FILTER:
      gst_play_sink_set_filter (playbin->playsink, GST_PLAY_SINK_TYPE_VIDEO,
          GST_ELEMENT (g_value_get_object (value)));
      break;
    case PROP_AUDIO_FILTER:
      gst_play_sink_set_filter (playbin->playsink, GST_PLAY_SINK_TYPE_AUDIO,
          GST_ELEMENT (g_value_get_object (value)));
      break;
    case PROP_VIDEO_SINK:
      gst_play_bin_set_sink (playbin, GST_PLAY_SINK_TYPE_VIDEO, "video",
          &playbin->video_sink, g_value_get_object (value));
      break;
    case PROP_AUDIO_SINK:
      gst_play_bin_set_sink (playbin, GST_PLAY_SINK_TYPE_AUDIO, "audio",
          &playbin->audio_sink, g_value_get_object (value));
      break;
    case PROP_VIS_PLUGIN:
      gst_play_sink_set_vis_plugin (playbin->playsink,
          g_value_get_object (value));
      break;
    case PROP_TEXT_SINK:
      gst_play_bin_set_sink (playbin, GST_PLAY_SINK_TYPE_TEXT, "text",
          &playbin->text_sink, g_value_get_object (value));
      break;
    case PROP_VIDEO_STREAM_COMBINER:
      gst_play_bin_set_stream_combiner (playbin,
          &playbin->video_stream_combiner, "video", g_value_get_object (value));
      break;
    case PROP_AUDIO_STREAM_COMBINER:
      gst_play_bin_set_stream_combiner (playbin,
          &playbin->audio_stream_combiner, "audio", g_value_get_object (value));
      break;
    case PROP_TEXT_STREAM_COMBINER:
      gst_play_bin_set_stream_combiner (playbin,
          &playbin->text_stream_combiner, "text", g_value_get_object (value));
      break;
    case PROP_VOLUME:
      gst_play_sink_set_volume (playbin->playsink, g_value_get_double (value));
      break;
    case PROP_MUTE:
      gst_play_sink_set_mute (playbin->playsink, g_value_get_boolean (value));
      break;
    case PROP_FONT_DESC:
      gst_play_sink_set_font_desc (playbin->playsink,
          g_value_get_string (value));
      break;
    case PROP_CONNECTION_SPEED:
      GST_PLAY_BIN_LOCK (playbin);
      playbin->connection_speed = g_value_get_uint64 (value) * 1000;
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_BUFFER_SIZE:
      playbin->buffer_size = g_value_get_int (value);
      break;
    case PROP_BUFFER_DURATION:
      playbin->buffer_duration = g_value_get_int64 (value);
      break;
    case PROP_AV_OFFSET:
      gst_play_sink_set_av_offset (playbin->playsink,
          g_value_get_int64 (value));
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      playbin->ring_buffer_max_size = g_value_get_uint64 (value);
      break;
    case PROP_FORCE_ASPECT_RATIO:
      g_object_set (playbin->playsink, "force-aspect-ratio",
          g_value_get_boolean (value), NULL);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstElement *
gst_play_bin_get_current_sink (GstPlayBin * playbin, GstElement ** elem,
    const gchar * dbg, GstPlaySinkType type)
{
  GstElement *sink = gst_play_sink_get_sink (playbin->playsink, type);

  GST_LOG_OBJECT (playbin, "play_sink_get_sink() returned %s sink %"
      GST_PTR_FORMAT ", the originally set %s sink is %" GST_PTR_FORMAT,
      dbg, sink, dbg, *elem);

  if (sink == NULL) {
    GST_PLAY_BIN_LOCK (playbin);
    if ((sink = *elem))
      gst_object_ref (sink);
    GST_PLAY_BIN_UNLOCK (playbin);
  }

  return sink;
}

static GstElement *
gst_play_bin_get_current_stream_combiner (GstPlayBin * playbin,
    GstElement ** elem, const gchar * dbg, int stream_type)
{
  GstElement *combiner;

  GST_PLAY_BIN_LOCK (playbin);
  if ((combiner = playbin->curr_group->combiner[stream_type].combiner))
    gst_object_ref (combiner);
  else if ((combiner = *elem))
    gst_object_ref (combiner);
  GST_PLAY_BIN_UNLOCK (playbin);

  return combiner;
}

static void
gst_play_bin_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstPlayBin *playbin = GST_PLAY_BIN (object);

  switch (prop_id) {
    case PROP_URI:
    {
      GstSourceGroup *group;

      GST_PLAY_BIN_LOCK (playbin);
      group = playbin->next_group;
      g_value_set_string (value, group->uri);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
      break;
    }
    case PROP_CURRENT_URI:
    {
      GstSourceGroup *group;

      GST_PLAY_BIN_LOCK (playbin);
      group = get_group (playbin);
      g_value_set_string (value, group->uri);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_SUBURI:
    {
      GstSourceGroup *group;

      GST_PLAY_BIN_LOCK (playbin);
      group = playbin->next_group;
      g_value_set_string (value, group->suburi);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_CURRENT_SUBURI:
    {
      GstSourceGroup *group;

      GST_PLAY_BIN_LOCK (playbin);
      group = get_group (playbin);
      g_value_set_string (value, group->suburi);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_SOURCE:
    {
      GST_OBJECT_LOCK (playbin);
      g_value_set_object (value, playbin->source);
      GST_OBJECT_UNLOCK (playbin);
      break;
    }
    case PROP_FLAGS:
      g_value_set_flags (value, gst_play_bin_get_flags (playbin));
      break;
    case PROP_N_VIDEO:
    {
      GstSourceGroup *group;
      gint n_video;

      GST_PLAY_BIN_LOCK (playbin);
      group = get_group (playbin);
      n_video = (group->video_channels ? group->video_channels->len : 0);
      g_value_set_int (value, n_video);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_CURRENT_VIDEO:
      GST_PLAY_BIN_LOCK (playbin);
      g_value_set_int (value, playbin->current_video);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_N_AUDIO:
    {
      GstSourceGroup *group;
      gint n_audio;

      GST_PLAY_BIN_LOCK (playbin);
      group = get_group (playbin);
      n_audio = (group->audio_channels ? group->audio_channels->len : 0);
      g_value_set_int (value, n_audio);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_CURRENT_AUDIO:
      GST_PLAY_BIN_LOCK (playbin);
      g_value_set_int (value, playbin->current_audio);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_N_TEXT:
    {
      GstSourceGroup *group;
      gint n_text;

      GST_PLAY_BIN_LOCK (playbin);
      group = get_group (playbin);
      n_text = (group->text_channels ? group->text_channels->len : 0);
      g_value_set_int (value, n_text);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    }
    case PROP_CURRENT_TEXT:
      GST_PLAY_BIN_LOCK (playbin);
      g_value_set_int (value, playbin->current_text);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_SUBTITLE_ENCODING:
      GST_PLAY_BIN_LOCK (playbin);
      g_value_take_string (value,
          gst_play_sink_get_subtitle_encoding (playbin->playsink));
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_VIDEO_FILTER:
      g_value_take_object (value,
          gst_play_sink_get_filter (playbin->playsink,
              GST_PLAY_SINK_TYPE_VIDEO));
      break;
    case PROP_AUDIO_FILTER:
      g_value_take_object (value,
          gst_play_sink_get_filter (playbin->playsink,
              GST_PLAY_SINK_TYPE_AUDIO));
      break;
    case PROP_VIDEO_SINK:
      g_value_take_object (value,
          gst_play_bin_get_current_sink (playbin, &playbin->video_sink,
              "video", GST_PLAY_SINK_TYPE_VIDEO));
      break;
    case PROP_AUDIO_SINK:
      g_value_take_object (value,
          gst_play_bin_get_current_sink (playbin, &playbin->audio_sink,
              "audio", GST_PLAY_SINK_TYPE_AUDIO));
      break;
    case PROP_VIS_PLUGIN:
      g_value_take_object (value,
          gst_play_sink_get_vis_plugin (playbin->playsink));
      break;
    case PROP_TEXT_SINK:
      g_value_take_object (value,
          gst_play_bin_get_current_sink (playbin, &playbin->text_sink,
              "text", GST_PLAY_SINK_TYPE_TEXT));
      break;
    case PROP_VIDEO_STREAM_COMBINER:
      g_value_take_object (value,
          gst_play_bin_get_current_stream_combiner (playbin,
              &playbin->video_stream_combiner, "video", PLAYBIN_STREAM_VIDEO));
      break;
    case PROP_AUDIO_STREAM_COMBINER:
      g_value_take_object (value,
          gst_play_bin_get_current_stream_combiner (playbin,
              &playbin->audio_stream_combiner, "audio", PLAYBIN_STREAM_VIDEO));
      break;
    case PROP_TEXT_STREAM_COMBINER:
      g_value_take_object (value,
          gst_play_bin_get_current_stream_combiner (playbin,
              &playbin->text_stream_combiner, "text", PLAYBIN_STREAM_VIDEO));
      break;
    case PROP_VOLUME:
      g_value_set_double (value, gst_play_sink_get_volume (playbin->playsink));
      break;
    case PROP_MUTE:
      g_value_set_boolean (value, gst_play_sink_get_mute (playbin->playsink));
      break;
    case PROP_SAMPLE:
      gst_value_take_sample (value,
          gst_play_sink_get_last_sample (playbin->playsink));
      break;
    case PROP_FONT_DESC:
      g_value_take_string (value,
          gst_play_sink_get_font_desc (playbin->playsink));
      break;
    case PROP_CONNECTION_SPEED:
      GST_PLAY_BIN_LOCK (playbin);
      g_value_set_uint64 (value, playbin->connection_speed / 1000);
      GST_PLAY_BIN_UNLOCK (playbin);
      break;
    case PROP_BUFFER_SIZE:
      GST_OBJECT_LOCK (playbin);
      g_value_set_int (value, playbin->buffer_size);
      GST_OBJECT_UNLOCK (playbin);
      break;
    case PROP_BUFFER_DURATION:
      GST_OBJECT_LOCK (playbin);
      g_value_set_int64 (value, playbin->buffer_duration);
      GST_OBJECT_UNLOCK (playbin);
      break;
    case PROP_AV_OFFSET:
      g_value_set_int64 (value,
          gst_play_sink_get_av_offset (playbin->playsink));
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      g_value_set_uint64 (value, playbin->ring_buffer_max_size);
      break;
    case PROP_FORCE_ASPECT_RATIO:{
      gboolean v;

      g_object_get (playbin->playsink, "force-aspect-ratio", &v, NULL);
      g_value_set_boolean (value, v);
      break;
    }
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_play_bin_update_cached_duration_from_query (GstPlayBin * playbin,
    gboolean valid, GstQuery * query)
{
  GstFormat fmt;
  gint64 duration;
  gint i;

  GST_DEBUG_OBJECT (playbin, "Updating cached duration from query");
  gst_query_parse_duration (query, &fmt, &duration);

  for (i = 0; i < G_N_ELEMENTS (playbin->duration); i++) {
    if (playbin->duration[i].format == 0 || fmt == playbin->duration[i].format) {
      playbin->duration[i].valid = valid;
      playbin->duration[i].format = fmt;
      playbin->duration[i].duration = valid ? duration : -1;
      break;
    }
  }
}

static void
gst_play_bin_update_cached_duration (GstPlayBin * playbin)
{
  const GstFormat formats[] =
      { GST_FORMAT_TIME, GST_FORMAT_BYTES, GST_FORMAT_DEFAULT };
  gboolean ret;
  GstQuery *query;
  gint i;

  GST_DEBUG_OBJECT (playbin, "Updating cached durations before group switch");
  for (i = 0; i < G_N_ELEMENTS (formats); i++) {
    query = gst_query_new_duration (formats[i]);
    ret =
        GST_ELEMENT_CLASS (parent_class)->query (GST_ELEMENT_CAST (playbin),
        query);
    gst_play_bin_update_cached_duration_from_query (playbin, ret, query);
    gst_query_unref (query);
  }
}

static gboolean
gst_play_bin_query (GstElement * element, GstQuery * query)
{
  GstPlayBin *playbin = GST_PLAY_BIN (element);
  gboolean ret;

  /* During a group switch we shouldn't allow duration queries
   * because it's not clear if the old or new group's duration
   * is returned and if the sinks are already playing new data
   * or old data. See bug #585969
   *
   * While we're at it, also don't do any other queries during
   * a group switch or any other event that causes topology changes
   * by taking the playbin lock in any case.
   */
  GST_PLAY_BIN_LOCK (playbin);

  if (GST_QUERY_TYPE (query) == GST_QUERY_DURATION) {
    GstSourceGroup *group = playbin->curr_group;
    gboolean pending;

    GST_SOURCE_GROUP_LOCK (group);

    pending = group->pending || group->stream_changed_pending;

    if (pending) {
      GstFormat fmt;
      gint i;

      ret = FALSE;
      gst_query_parse_duration (query, &fmt, NULL);
      for (i = 0; i < G_N_ELEMENTS (playbin->duration); i++) {
        if (fmt == playbin->duration[i].format) {
          ret = playbin->duration[i].valid;
          gst_query_set_duration (query, fmt,
              (ret ? playbin->duration[i].duration : -1));
          break;
        }
      }
      /* if nothing cached yet, we might as well request duration,
       * such as during initial startup */
      if (ret) {
        GST_DEBUG_OBJECT (playbin,
            "Taking cached duration because of pending group switch: %d", ret);
        GST_SOURCE_GROUP_UNLOCK (group);
        GST_PLAY_BIN_UNLOCK (playbin);
        return ret;
      }
    }
    GST_SOURCE_GROUP_UNLOCK (group);
  }

  ret = GST_ELEMENT_CLASS (parent_class)->query (element, query);

  if (GST_QUERY_TYPE (query) == GST_QUERY_DURATION)
    gst_play_bin_update_cached_duration_from_query (playbin, ret, query);
  GST_PLAY_BIN_UNLOCK (playbin);

  return ret;
}

/* mime types we are not handling on purpose right now, don't post a
 * missing-plugin message for these */
static const gchar *blacklisted_mimes[] = {
  NULL
};

static void
gst_play_bin_handle_message (GstBin * bin, GstMessage * msg)
{
  GstPlayBin *playbin = GST_PLAY_BIN (bin);
  GstSourceGroup *group;

  if (gst_is_missing_plugin_message (msg)) {
    gchar *detail;
    guint i;

    detail = gst_missing_plugin_message_get_installer_detail (msg);
    for (i = 0; detail != NULL && blacklisted_mimes[i] != NULL; ++i) {
      if (strstr (detail, "|decoder-") && strstr (detail, blacklisted_mimes[i])) {
        GST_LOG_OBJECT (bin, "suppressing message %" GST_PTR_FORMAT, msg);
        gst_message_unref (msg);
        g_free (detail);
        return;
      }
    }
    g_free (detail);
  } else if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_ASYNC_START ||
      GST_MESSAGE_TYPE (msg) == GST_MESSAGE_ASYNC_DONE) {
    GstObject *src = GST_OBJECT_CAST (msg->src);

    /* Ignore async state changes from the uridecodebin children,
     * see bug #602000. */
    group = playbin->curr_group;
    if (src && group &&
        ((group->uridecodebin && src == GST_OBJECT_CAST (group->uridecodebin))
            || (group->suburidecodebin
                && src == GST_OBJECT_CAST (group->suburidecodebin)))) {
      GST_DEBUG_OBJECT (playbin,
          "Ignoring async state change of uridecodebin: %s",
          GST_OBJECT_NAME (src));
      gst_message_unref (msg);
      msg = NULL;
    }
  } else if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_STREAM_START) {
    GstSourceGroup *new_group = playbin->curr_group;

    new_group->stream_changed_pending = FALSE;
  } else if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_ERROR) {
    /* If we get an error of the subtitle uridecodebin transform
     * them into warnings and disable the subtitles */
    group = playbin->curr_group;
    if (group && group->suburidecodebin) {
      if (G_UNLIKELY (gst_object_has_ancestor (msg->src, GST_OBJECT_CAST
                  (group->suburidecodebin)))) {
        GError *err;
        gchar *debug = NULL;
        GstMessage *new_msg;
        GstIterator *it;
        gboolean done = FALSE;
        GValue item = { 0, };

        gst_message_parse_error (msg, &err, &debug);
        new_msg = gst_message_new_warning (msg->src, err, debug);

        gst_message_unref (msg);
        g_error_free (err);
        g_free (debug);
        msg = new_msg;

        REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_added_id);
        REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_removed_id);
        REMOVE_SIGNAL (group->suburidecodebin, group->sub_no_more_pads_id);
        REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_continue_id);
        REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_query_id);

        it = gst_element_iterate_src_pads (group->suburidecodebin);
        while (it && !done) {
          GstPad *p = NULL;
          GstIteratorResult res;

          res = gst_iterator_next (it, &item);

          switch (res) {
            case GST_ITERATOR_DONE:
              done = TRUE;
              break;
            case GST_ITERATOR_OK:
              p = g_value_get_object (&item);
              pad_removed_cb (NULL, p, group);
              g_value_reset (&item);
              break;

            case GST_ITERATOR_RESYNC:
              gst_iterator_resync (it);
              break;
            case GST_ITERATOR_ERROR:
              done = TRUE;
              break;
          }
        }
        g_value_unset (&item);
        if (it)
          gst_iterator_free (it);

        gst_object_ref (group->suburidecodebin);
        gst_bin_remove (bin, group->suburidecodebin);
        gst_element_set_locked_state (group->suburidecodebin, FALSE);

        if (group->sub_pending) {
          group->sub_pending = FALSE;
          no_more_pads_cb (NULL, group);
        }
      }
    }
  }

  if (msg)
    GST_BIN_CLASS (parent_class)->handle_message (bin, msg);
}

static void
combiner_active_pad_changed (GObject * combiner, GParamSpec * pspec,
    GstPlayBin * playbin)
{
  const gchar *property;
  GstSourceGroup *group;
  GstSourceCombine *combine = NULL;
  int i;

  GST_PLAY_BIN_LOCK (playbin);
  group = get_group (playbin);

  for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
    if (combiner == G_OBJECT (group->combiner[i].combiner)) {
      combine = &group->combiner[i];
    }
  }

  /* We got a pad-change after our group got switched out; no need to notify */
  if (!combine) {
    GST_PLAY_BIN_UNLOCK (playbin);
    return;
  }

  switch (combine->type) {
    case GST_PLAY_SINK_TYPE_VIDEO:
    case GST_PLAY_SINK_TYPE_VIDEO_RAW:
      property = "current-video";
      playbin->current_video = get_current_stream_number (playbin,
          combine, group->video_channels);

      if (playbin->video_pending_flush_finish) {
        playbin->video_pending_flush_finish = FALSE;
        GST_PLAY_BIN_UNLOCK (playbin);
        gst_play_bin_send_custom_event (GST_OBJECT (combiner),
            "playsink-custom-video-flush-finish");
        goto notify;
      }
      break;
    case GST_PLAY_SINK_TYPE_AUDIO:
    case GST_PLAY_SINK_TYPE_AUDIO_RAW:
      property = "current-audio";
      playbin->current_audio = get_current_stream_number (playbin,
          combine, group->audio_channels);

      if (playbin->audio_pending_flush_finish) {
        playbin->audio_pending_flush_finish = FALSE;
        GST_PLAY_BIN_UNLOCK (playbin);
        gst_play_bin_send_custom_event (GST_OBJECT (combiner),
            "playsink-custom-audio-flush-finish");
        goto notify;
      }
      break;
    case GST_PLAY_SINK_TYPE_TEXT:
      property = "current-text";
      playbin->current_text = get_current_stream_number (playbin,
          combine, group->text_channels);

      if (playbin->text_pending_flush_finish) {
        playbin->text_pending_flush_finish = FALSE;
        GST_PLAY_BIN_UNLOCK (playbin);
        gst_play_bin_send_custom_event (GST_OBJECT (combiner),
            "playsink-custom-subtitle-flush-finish");
        goto notify;
      }
      break;
    default:
      property = NULL;
  }
  GST_PLAY_BIN_UNLOCK (playbin);

notify:
  if (property)
    g_object_notify (G_OBJECT (playbin), property);
}

static GstPadProbeReturn
_uridecodebin_event_probe (GstPad * pad, GstPadProbeInfo * info, gpointer udata)
{
  GstPadProbeReturn ret = GST_PAD_PROBE_OK;
  GstSourceGroup *group = udata;
  GstEvent *event = GST_PAD_PROBE_INFO_DATA (info);
  gboolean suburidecodebin = (GST_PAD_PARENT (pad) == group->suburidecodebin);

  if (suburidecodebin) {
    /* Drop flushes that we caused from the suburidecodebin */
    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_FLUSH_START:
      case GST_EVENT_FLUSH_STOP:
      {
        guint32 seqnum = gst_event_get_seqnum (event);
        GSList *item = g_slist_find (group->suburi_flushes_to_drop,
            GUINT_TO_POINTER (seqnum));
        if (item) {
          if (GST_EVENT_TYPE (event) == GST_EVENT_FLUSH_STOP) {
            group->suburi_flushes_to_drop =
                g_slist_delete_link (group->suburi_flushes_to_drop, item);
          }
        }
      }
      default:
        break;
    }
  }

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_STREAM_START:{
      guint group_id;

      GST_SOURCE_GROUP_LOCK (group);
      if (gst_event_parse_group_id (event, &group_id)) {
        if (group->have_group_id) {
          if (group->group_id != group_id) {
            event = gst_event_copy (event);
            gst_event_set_group_id (event, group->group_id);
            gst_event_replace ((GstEvent **) & info->data, event);
            gst_event_unref (event);
          }
        } else {
          group->group_id = group_id;
          group->have_group_id = TRUE;
        }
      } else {
        GST_FIXME_OBJECT (pad,
            "Consider implementing group-id handling on stream-start event");

        if (!group->have_group_id) {
          group->group_id = gst_util_group_id_next ();
          group->have_group_id = TRUE;
        }

        event = gst_event_copy (event);
        gst_event_set_group_id (event, group->group_id);
        gst_event_replace ((GstEvent **) & info->data, event);
        gst_event_unref (event);
      }
      GST_SOURCE_GROUP_UNLOCK (group);
      break;
    }
    default:
      break;
  }

  return ret;
}

/* helper function to lookup stuff in lists */
static gboolean
array_has_value (const gchar * values[], const gchar * value, gboolean exact)
{
  gint i;

  for (i = 0; values[i]; i++) {
    if (exact && !strcmp (value, values[i]))
      return TRUE;
    if (!exact && g_str_has_prefix (value, values[i]))
      return TRUE;
  }
  return FALSE;
}

typedef struct
{
  GstPlayBin *playbin;
  gint stream_id;
  GstPlaySinkType type;
} NotifyTagsData;

static void
notify_tags_cb (GObject * object, GParamSpec * pspec, gpointer user_data)
{
  NotifyTagsData *ntdata = (NotifyTagsData *) user_data;
  gint signal;

  GST_DEBUG_OBJECT (ntdata->playbin, "Tags on pad %" GST_PTR_FORMAT
      " with stream id %d and type %d have changed",
      object, ntdata->stream_id, ntdata->type);

  switch (ntdata->type) {
    case GST_PLAY_SINK_TYPE_VIDEO:
    case GST_PLAY_SINK_TYPE_VIDEO_RAW:
      signal = SIGNAL_VIDEO_TAGS_CHANGED;
      break;
    case GST_PLAY_SINK_TYPE_AUDIO:
    case GST_PLAY_SINK_TYPE_AUDIO_RAW:
      signal = SIGNAL_AUDIO_TAGS_CHANGED;
      break;
    case GST_PLAY_SINK_TYPE_TEXT:
      signal = SIGNAL_TEXT_TAGS_CHANGED;
      break;
    default:
      signal = -1;
      break;
  }

  if (signal >= 0)
    g_signal_emit (G_OBJECT (ntdata->playbin), gst_play_bin_signals[signal], 0,
        ntdata->stream_id);
}

/* this function is called when a new pad is added to decodebin. We check the
 * type of the pad and add it to the combiner element of the group.
 */
static void
pad_added_cb (GstElement * decodebin, GstPad * pad, GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GstCaps *caps;
  const GstStructure *s;
  const gchar *name;
  GstPad *sinkpad;
  GstPadLinkReturn res;
  GstSourceCombine *combine = NULL;
  gint i, pass;
  gboolean changed = FALSE;
  GstElement *custom_combiner = NULL;
  gulong group_id_probe_handler;

  playbin = group->playbin;

  caps = gst_pad_get_current_caps (pad);
  if (!caps)
    caps = gst_pad_query_caps (pad, NULL);
  s = gst_caps_get_structure (caps, 0);
  name = gst_structure_get_name (s);

  GST_DEBUG_OBJECT (playbin,
      "pad %s:%s with caps %" GST_PTR_FORMAT " added in group %p",
      GST_DEBUG_PAD_NAME (pad), caps, group);

  /* major type of the pad, this determines the combiner to use,
     try exact match first */
  for (pass = 0; !combine && pass < 2; pass++) {
    for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
      if (array_has_value (group->combiner[i].media_list, name, pass == 0)) {
        combine = &group->combiner[i];
        break;
      } else if (group->combiner[i].get_media_caps) {
        GstCaps *media_caps = group->combiner[i].get_media_caps ();

        if (media_caps && gst_caps_can_intersect (media_caps, caps)) {
          combine = &group->combiner[i];
          gst_caps_unref (media_caps);
          break;
        }
        gst_caps_unref (media_caps);
      }
    }
    /* get custom stream combiner if there is one */
    if (combine) {
      if (i == PLAYBIN_STREAM_AUDIO) {
        custom_combiner = playbin->audio_stream_combiner;
      } else if (i == PLAYBIN_STREAM_TEXT) {
        custom_combiner = playbin->text_stream_combiner;
      } else if (i == PLAYBIN_STREAM_VIDEO) {
        custom_combiner = playbin->video_stream_combiner;
      }
    }
  }
  /* no combiner found for the media type, don't bother linking it to a
   * combiner. This will leave the pad unlinked and thus ignored. */
  if (combine == NULL)
    goto unknown_type;

  GST_SOURCE_GROUP_LOCK (group);
  if (combine->combiner == NULL && playbin->have_selector) {
    /* no combiner, create one */
    GST_DEBUG_OBJECT (playbin, "creating new input selector");
    if (custom_combiner)
      combine->combiner = custom_combiner;
    else
      combine->combiner = gst_element_factory_make ("input-selector", NULL);

    if (combine->combiner == NULL) {
      /* post the missing input-selector message only once */
      playbin->have_selector = FALSE;
      gst_element_post_message (GST_ELEMENT_CAST (playbin),
          gst_missing_element_message_new (GST_ELEMENT_CAST (playbin),
              "input-selector"));
      GST_ELEMENT_WARNING (playbin, CORE, MISSING_PLUGIN,
          (_("Missing element '%s' - check your GStreamer installation."),
              "input-selector"), (NULL));
    } else {
      /* find out which properties the stream combiner supports */
      combine->has_active_pad =
          g_object_class_find_property (G_OBJECT_GET_CLASS (combine->combiner),
          "active-pad") != NULL;

      if (!custom_combiner) {
        /* sync-mode=1, use clock */
        if (combine->type == GST_PLAY_SINK_TYPE_TEXT)
          g_object_set (combine->combiner, "sync-streams", TRUE,
              "sync-mode", 1, "cache-buffers", TRUE, NULL);
        else
          g_object_set (combine->combiner, "sync-streams", TRUE, NULL);
      }

      if (combine->has_active_pad)
        g_signal_connect (combine->combiner, "notify::active-pad",
            G_CALLBACK (combiner_active_pad_changed), playbin);

      GST_DEBUG_OBJECT (playbin, "adding new stream combiner %p",
          combine->combiner);
      gst_element_set_state (combine->combiner, GST_STATE_PAUSED);
      gst_bin_add (GST_BIN_CAST (playbin), combine->combiner);
    }
  }

  if (combine->srcpad == NULL) {
    if (combine->combiner) {
      /* save source pad of the combiner */
      combine->srcpad = gst_element_get_static_pad (combine->combiner, "src");
    } else {
      /* no combiner, use the pad as the source pad then */
      combine->srcpad = gst_object_ref (pad);
    }

    /* block the combiner srcpad. It's possible that multiple decodebins start
     * pushing data into the combiners before we have a chance to collect all
     * streams and connect the sinks, resulting in not-linked errors. After we
     * configured the sinks we will unblock them all. */
    GST_DEBUG_OBJECT (playbin, "blocking %" GST_PTR_FORMAT, combine->srcpad);
    combine->block_id =
        gst_pad_add_probe (combine->srcpad, GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM,
        block_serialized_data_cb, NULL, NULL);
  }

  /* get sinkpad for the new stream */
  if (combine->combiner) {
    if ((sinkpad = gst_element_get_request_pad (combine->combiner, "sink_%u"))) {

      GST_DEBUG_OBJECT (playbin, "got pad %s:%s from combiner",
          GST_DEBUG_PAD_NAME (sinkpad));

      /* find out which properties the sink pad supports */
      combine->has_always_ok =
          g_object_class_find_property (G_OBJECT_GET_CLASS (sinkpad),
          "always-ok") != NULL;
      combine->has_tags =
          g_object_class_find_property (G_OBJECT_GET_CLASS (sinkpad),
          "tags") != NULL;

      /* store the combiner for the pad */
      g_object_set_data (G_OBJECT (sinkpad), "playbin.combine", combine);

      if (combine->has_tags) {
        gulong notify_tags_handler = 0;
        NotifyTagsData *ntdata;

        /* connect to the notify::tags signal for our
         * own *-tags-changed signals
         */
        ntdata = g_new0 (NotifyTagsData, 1);
        ntdata->playbin = playbin;
        ntdata->stream_id = combine->channels->len;
        ntdata->type = combine->type;

        notify_tags_handler =
            g_signal_connect_data (G_OBJECT (sinkpad), "notify::tags",
            G_CALLBACK (notify_tags_cb), ntdata, (GClosureNotify) g_free,
            (GConnectFlags) 0);
        g_object_set_data (G_OBJECT (sinkpad), "playbin.notify_tags_handler",
            (gpointer) (guintptr) notify_tags_handler);
      }

      /* store the pad in the array */
      GST_DEBUG_OBJECT (playbin, "pad %p added to array", sinkpad);
      g_ptr_array_add (combine->channels, sinkpad);

      res = gst_pad_link (pad, sinkpad);
      if (GST_PAD_LINK_FAILED (res))
        goto link_failed;

      /* store combiner pad so we can release it */
      g_object_set_data (G_OBJECT (pad), "playbin.sinkpad", sinkpad);

      changed = TRUE;
      GST_DEBUG_OBJECT (playbin, "linked pad %s:%s to combiner %p",
          GST_DEBUG_PAD_NAME (pad), combine->combiner);
    } else {
      goto request_pad_failed;
    }
  } else {
    /* no combiner, don't configure anything, we'll link the new pad directly to
     * the sink. */
    changed = FALSE;
    sinkpad = NULL;

    /* store the combiner for the pad */
    g_object_set_data (G_OBJECT (pad), "playbin.combine", combine);
  }
  GST_SOURCE_GROUP_UNLOCK (group);

  group_id_probe_handler =
      gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_EVENT_DOWNSTREAM,
      _uridecodebin_event_probe, group, NULL);
  g_object_set_data (G_OBJECT (pad), "playbin.event_probe_id",
      (gpointer) group_id_probe_handler);

  if (changed) {
    int signal;

    switch (combine->type) {
      case GST_PLAY_SINK_TYPE_VIDEO:
      case GST_PLAY_SINK_TYPE_VIDEO_RAW:
        signal = SIGNAL_VIDEO_CHANGED;
        break;
      case GST_PLAY_SINK_TYPE_AUDIO:
      case GST_PLAY_SINK_TYPE_AUDIO_RAW:
        signal = SIGNAL_AUDIO_CHANGED;
        break;
      case GST_PLAY_SINK_TYPE_TEXT:
        signal = SIGNAL_TEXT_CHANGED;
        break;
      default:
        signal = -1;
    }

    if (signal >= 0) {
      /* we want to return NOT_LINKED for unselected pads but only for pads
       * from the normal uridecodebin. This makes sure that subtitle streams
       * are not raced past audio/video from decodebin's multiqueue.
       * For pads from suburidecodebin OK should always be returned, otherwise
       * it will most likely stop. */
      if (combine->has_always_ok) {
        gboolean always_ok = (decodebin == group->suburidecodebin);
        g_object_set (sinkpad, "always-ok", always_ok, NULL);
      }
      g_signal_emit (G_OBJECT (playbin), gst_play_bin_signals[signal], 0, NULL);
    }
  }

done:
  gst_caps_unref (caps);
  return;

  /* ERRORS */
unknown_type:
  {
    GST_ERROR_OBJECT (playbin, "unknown type %s for pad %s:%s",
        name, GST_DEBUG_PAD_NAME (pad));
    goto done;
  }
link_failed:
  {
    GST_ERROR_OBJECT (playbin,
        "failed to link pad %s:%s to combiner, reason %d",
        GST_DEBUG_PAD_NAME (pad), res);
    GST_SOURCE_GROUP_UNLOCK (group);
    goto done;
  }
request_pad_failed:
  GST_ELEMENT_ERROR (playbin, CORE, PAD,
      ("Internal playbin error."),
      ("Failed to get request pad from combiner %p.", combine->combiner));
  GST_SOURCE_GROUP_UNLOCK (group);
  goto done;
}

/* called when a pad is removed from the uridecodebin. We unlink the pad from
 * the combiner. This will make the combiner select a new pad. */
static void
pad_removed_cb (GstElement * decodebin, GstPad * pad, GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GstPad *peer;
  GstElement *combiner;
  GstSourceCombine *combine;
  int signal = -1;
  gulong group_id_probe_handler;

  playbin = group->playbin;

  GST_DEBUG_OBJECT (playbin,
      "pad %s:%s removed from group %p", GST_DEBUG_PAD_NAME (pad), group);

  GST_SOURCE_GROUP_LOCK (group);

  if ((group_id_probe_handler =
          (guintptr) g_object_get_data (G_OBJECT (pad),
              "playbin.event_probe_id"))) {
    gst_pad_remove_probe (pad, group_id_probe_handler);
    g_object_set_data (G_OBJECT (pad), "playbin.event_probe_id", 0);
  }

  if ((combine = g_object_get_data (G_OBJECT (pad), "playbin.combine"))) {
    g_assert (combine->combiner == NULL);
    g_assert (combine->srcpad == pad);
    gst_object_unref (pad);
    combine->srcpad = NULL;
    goto exit;
  }

  /* get the combiner sinkpad */
  if (!(peer = g_object_get_data (G_OBJECT (pad), "playbin.sinkpad")))
    goto not_linked;

  /* unlink the pad now (can fail, the pad is unlinked before it's removed) */
  gst_pad_unlink (pad, peer);

  /* get combiner */
  combiner = GST_ELEMENT_CAST (gst_pad_get_parent (peer));
  g_assert (combiner != NULL);

  if ((combine = g_object_get_data (G_OBJECT (peer), "playbin.combine"))) {
    if (combine->has_tags) {
      gulong notify_tags_handler;

      notify_tags_handler =
          (guintptr) g_object_get_data (G_OBJECT (peer),
          "playbin.notify_tags_handler");
      if (notify_tags_handler != 0)
        g_signal_handler_disconnect (G_OBJECT (peer), notify_tags_handler);
      g_object_set_data (G_OBJECT (peer), "playbin.notify_tags_handler", NULL);
    }

    /* remove the pad from the array */
    g_ptr_array_remove (combine->channels, peer);
    GST_DEBUG_OBJECT (playbin, "pad %p removed from array", peer);

    /* get the correct type-changed signal */
    switch (combine->type) {
      case GST_PLAY_SINK_TYPE_VIDEO:
      case GST_PLAY_SINK_TYPE_VIDEO_RAW:
        signal = SIGNAL_VIDEO_CHANGED;
        break;
      case GST_PLAY_SINK_TYPE_AUDIO:
      case GST_PLAY_SINK_TYPE_AUDIO_RAW:
        signal = SIGNAL_AUDIO_CHANGED;
        break;
      case GST_PLAY_SINK_TYPE_TEXT:
        signal = SIGNAL_TEXT_CHANGED;
        break;
      default:
        signal = -1;
    }

    if (!combine->channels->len && combine->combiner) {
      GST_DEBUG_OBJECT (playbin, "all combiner sinkpads removed");
      GST_DEBUG_OBJECT (playbin, "removing combiner %p", combine->combiner);
      gst_object_unref (combine->srcpad);
      combine->srcpad = NULL;
      gst_element_set_state (combine->combiner, GST_STATE_NULL);
      gst_bin_remove (GST_BIN_CAST (playbin), combine->combiner);
      combine->combiner = NULL;
    }
  }

  /* release the pad to the combiner, this will make the combiner choose a new
   * pad. */
  gst_element_release_request_pad (combiner, peer);
  gst_object_unref (peer);

  gst_object_unref (combiner);
exit:
  GST_SOURCE_GROUP_UNLOCK (group);

  if (signal >= 0)
    g_signal_emit (G_OBJECT (playbin), gst_play_bin_signals[signal], 0, NULL);

  return;

  /* ERRORS */
not_linked:
  {
    GST_DEBUG_OBJECT (playbin, "pad not linked");
    goto exit;
  }
}

/* we get called when all pads are available and we must connect the sinks to
 * them.
 * The main purpose of the code is to see if we have video/audio and subtitles
 * and pick the right pipelines to display them.
 *
 * The combiners installed on the group tell us about the presence of
 * audio/video and subtitle streams. This allows us to see if we need
 * visualisation, video or/and audio.
 */
static void
no_more_pads_cb (GstElement * decodebin, GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GstPadLinkReturn res;
  gint i;
  gboolean configure;

  playbin = group->playbin;

  GST_DEBUG_OBJECT (playbin, "no more pads in group %p", group);

  GST_PLAY_BIN_SHUTDOWN_LOCK (playbin, shutdown);

  GST_SOURCE_GROUP_LOCK (group);
  for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
    GstSourceCombine *combine = &group->combiner[i];

    /* check if the specific media type was detected and thus has a combiner
     * created for it. If there is the media type, get a sinkpad from the sink
     * and link it. We only do this if we have not yet requested the sinkpad
     * before. */
    if (combine->srcpad && combine->sinkpad == NULL) {
      GST_DEBUG_OBJECT (playbin, "requesting new sink pad %d", combine->type);
      combine->sinkpad =
          gst_play_sink_request_pad (playbin->playsink, combine->type);
      gst_object_ref (combine->sinkpad);
    } else if (combine->srcpad && combine->sinkpad) {
      GST_DEBUG_OBJECT (playbin, "refreshing new sink pad %d", combine->type);
      gst_play_sink_refresh_pad (playbin->playsink, combine->sinkpad,
          combine->type);
    } else if (combine->sinkpad && combine->srcpad == NULL) {
      GST_DEBUG_OBJECT (playbin, "releasing sink pad %d", combine->type);
      gst_play_sink_release_pad (playbin->playsink, combine->sinkpad);
      gst_object_unref (combine->sinkpad);
      combine->sinkpad = NULL;
    }
    if (combine->sinkpad && combine->srcpad &&
        !gst_pad_is_linked (combine->srcpad)) {
      res = gst_pad_link (combine->srcpad, combine->sinkpad);
      GST_DEBUG_OBJECT (playbin, "linked type %s, result: %d",
          combine->media_list[0], res);
      if (res != GST_PAD_LINK_OK) {
        GST_ELEMENT_ERROR (playbin, CORE, PAD,
            ("Internal playbin error."),
            ("Failed to link combiner to sink. Error %d", res));
      }
    }
  }
  GST_DEBUG_OBJECT (playbin, "pending %d > %d", group->pending,
      group->pending - 1);

  if (group->pending > 0)
    group->pending--;

  if (group->suburidecodebin == decodebin)
    group->sub_pending = FALSE;

  if (group->pending == 0) {
    /* we are the last group to complete, we will configure the output and then
     * signal the other waiters. */
    GST_LOG_OBJECT (playbin, "last group complete");
    configure = TRUE;
  } else {
    GST_LOG_OBJECT (playbin, "have more pending groups");
    configure = FALSE;
  }
  GST_SOURCE_GROUP_UNLOCK (group);

  if (configure) {
    /* if we have custom sinks, configure them now */
    GST_SOURCE_GROUP_LOCK (group);

    if (group->audio_sink) {
      GST_INFO_OBJECT (playbin, "setting custom audio sink %" GST_PTR_FORMAT,
          group->audio_sink);
      gst_play_sink_set_sink (playbin->playsink, GST_PLAY_SINK_TYPE_AUDIO,
          group->audio_sink);
    }

    if (group->video_sink) {
      GST_INFO_OBJECT (playbin, "setting custom video sink %" GST_PTR_FORMAT,
          group->video_sink);
      gst_play_sink_set_sink (playbin->playsink, GST_PLAY_SINK_TYPE_VIDEO,
          group->video_sink);
    }

    if (group->text_sink) {
      GST_INFO_OBJECT (playbin, "setting custom text sink %" GST_PTR_FORMAT,
          group->text_sink);
      gst_play_sink_set_sink (playbin->playsink, GST_PLAY_SINK_TYPE_TEXT,
          group->text_sink);
    }

    GST_SOURCE_GROUP_UNLOCK (group);

    /* signal the other decodebins that they can continue now. */
    GST_SOURCE_GROUP_LOCK (group);
    /* unblock all combiners */
    for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
      GstSourceCombine *combine = &group->combiner[i];

      if (combine->srcpad) {
        GST_DEBUG_OBJECT (playbin, "unblocking %" GST_PTR_FORMAT,
            combine->srcpad);
        if (combine->block_id) {
          gst_pad_remove_probe (combine->srcpad, combine->block_id);
          combine->block_id = 0;
        }
      }
    }
    GST_SOURCE_GROUP_UNLOCK (group);
    gst_play_sink_reconfigure (playbin->playsink);
  }

  GST_PLAY_BIN_SHUTDOWN_UNLOCK (playbin);

  return;

shutdown:
  {
    GST_DEBUG ("ignoring, we are shutting down");
    /* Request a flushing pad from playsink that we then link to the combiner.
     * Then we unblock the combiners so that they stop with a WRONG_STATE
     * instead of a NOT_LINKED error.
     */
    GST_SOURCE_GROUP_LOCK (group);
    for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
      GstSourceCombine *combine = &group->combiner[i];

      if (combine->srcpad) {
        if (combine->sinkpad == NULL) {
          GST_DEBUG_OBJECT (playbin, "requesting new flushing sink pad");
          combine->sinkpad =
              gst_play_sink_request_pad (playbin->playsink,
              GST_PLAY_SINK_TYPE_FLUSHING);
          gst_object_ref (combine->sinkpad);
          res = gst_pad_link (combine->srcpad, combine->sinkpad);
          GST_DEBUG_OBJECT (playbin, "linked flushing, result: %d", res);
        }
        GST_DEBUG_OBJECT (playbin, "unblocking %" GST_PTR_FORMAT,
            combine->srcpad);
        if (combine->block_id) {
          gst_pad_remove_probe (combine->srcpad, combine->block_id);
          combine->block_id = 0;
        }
      }
    }
    GST_SOURCE_GROUP_UNLOCK (group);
    return;
  }
}

static void
drained_cb (GstElement * decodebin, GstSourceGroup * group)
{
  GstPlayBin *playbin;

  playbin = group->playbin;

  GST_DEBUG_OBJECT (playbin, "about to finish in group %p", group);

  /* after this call, we should have a next group to activate or we EOS */
  g_signal_emit (G_OBJECT (playbin),
      gst_play_bin_signals[SIGNAL_ABOUT_TO_FINISH], 0, NULL);

  /* now activate the next group. If the app did not set a uri, this will
   * fail and we can do EOS */
  setup_next_source (playbin, GST_STATE_PAUSED);
}

/* Like gst_element_factory_can_sink_any_caps() but doesn't
 * allow ANY caps on the sinkpad template */
static gboolean
_factory_can_sink_caps (GstElementFactory * factory, GstCaps * caps)
{
  const GList *templs;

  templs = gst_element_factory_get_static_pad_templates (factory);

  while (templs) {
    GstStaticPadTemplate *templ = (GstStaticPadTemplate *) templs->data;

    if (templ->direction == GST_PAD_SINK) {
      GstCaps *templcaps = gst_static_caps_get (&templ->static_caps);

      if (!gst_caps_is_any (templcaps)
          && gst_caps_is_subset (caps, templcaps)) {
        gst_caps_unref (templcaps);
        return TRUE;
      }
      gst_caps_unref (templcaps);
    }
    templs = g_list_next (templs);
  }

  return FALSE;
}

static void
avelements_free (gpointer avelement)
{
  GstAVElement *elm = (GstAVElement *) avelement;

  if (elm->dec)
    gst_object_unref (elm->dec);
  if (elm->sink)
    gst_object_unref (elm->sink);
  g_slice_free (GstAVElement, elm);
}

static gint
avelement_compare_decoder (gconstpointer p1, gconstpointer p2,
    gpointer user_data)
{
  GstAVElement *v1, *v2;

  v1 = (GstAVElement *) p1;
  v2 = (GstAVElement *) p2;

  return strcmp (GST_OBJECT_NAME (v1->dec), GST_OBJECT_NAME (v2->dec));
}

static gint
avelement_lookup_decoder (gconstpointer p1, gconstpointer p2,
    gpointer user_data)
{
  GstAVElement *v1;
  GstElementFactory *f2;

  v1 = (GstAVElement *) p1;
  f2 = (GstElementFactory *) p2;

  return strcmp (GST_OBJECT_NAME (v1->dec), GST_OBJECT_NAME (f2));
}

static gint
avelement_compare (gconstpointer p1, gconstpointer p2)
{
  GstAVElement *v1, *v2;
  GstPluginFeature *fd1, *fd2, *fs1, *fs2;
  gint64 diff, v1_rank, v2_rank;

  v1 = (GstAVElement *) p1;
  v2 = (GstAVElement *) p2;

  fd1 = (GstPluginFeature *) v1->dec;
  fd2 = (GstPluginFeature *) v2->dec;

  /* If both have a sink, we also compare their ranks */
  if (v1->sink && v2->sink) {
    fs1 = (GstPluginFeature *) v1->sink;
    fs2 = (GstPluginFeature *) v2->sink;
    v1_rank =
        gst_plugin_feature_get_rank (fd1) * gst_plugin_feature_get_rank (fs1);
    v2_rank =
        gst_plugin_feature_get_rank (fd2) * gst_plugin_feature_get_rank (fs2);
  } else {
    v1_rank = gst_plugin_feature_get_rank (fd1);
    v2_rank = gst_plugin_feature_get_rank (fd2);
    fs1 = fs2 = NULL;
  }

  /* comparison based on the rank */
  diff = v2_rank - v1_rank;
  if (diff < 0)
    return -1;
  else if (diff > 0)
    return 1;

  /* comparison based on number of common caps features */
  diff = v2->n_comm_cf - v1->n_comm_cf;
  if (diff != 0)
    return diff;

  if (fs1 && fs2) {
    /* comparison based on the name of sink elements */
    diff = strcmp (GST_OBJECT_NAME (fs1), GST_OBJECT_NAME (fs2));
    if (diff != 0)
      return diff;
  }

  /* comparison based on the name of decoder elements */
  return strcmp (GST_OBJECT_NAME (fd1), GST_OBJECT_NAME (fd2));
}

/* unref the caps after usage */
static GstCaps *
get_template_caps (GstElementFactory * factory, GstPadDirection direction)
{
  const GList *templates;
  GstStaticPadTemplate *templ = NULL;
  GList *walk;

  templates = gst_element_factory_get_static_pad_templates (factory);
  for (walk = (GList *) templates; walk; walk = g_list_next (walk)) {
    templ = walk->data;
    if (templ->direction == direction)
      break;
  }
  if (templ)
    return gst_static_caps_get (&templ->static_caps);
  else
    return NULL;
}

static gboolean
is_included (GList * list, GstCapsFeatures * cf)
{
  for (; list; list = list->next) {
    if (gst_caps_features_is_equal ((GstCapsFeatures *) list->data, cf))
      return TRUE;
  }
  return FALSE;
}

/* compute the number of common caps features */
static guint
get_n_common_capsfeatures (GstPlayBin * playbin, GstElementFactory * dec,
    GstElementFactory * sink, gboolean isaudioelement)
{
  GstCaps *d_tmpl_caps, *s_tmpl_caps;
  GstCapsFeatures *d_features, *s_features;
  GstStructure *d_struct, *s_struct;
  GList *cf_list = NULL;
  guint d_caps_size, s_caps_size;
  guint i, j, n_common_cf = 0;
  GstCaps *raw_caps =
      (isaudioelement) ? gst_static_caps_get (&raw_audio_caps) :
      gst_static_caps_get (&raw_video_caps);
  GstStructure *raw_struct = gst_caps_get_structure (raw_caps, 0);
  GstPlayFlags flags = gst_play_bin_get_flags (playbin);
  gboolean native_raw =
      (isaudioelement ? ! !(flags & GST_PLAY_FLAG_NATIVE_AUDIO) : ! !(flags &
          GST_PLAY_FLAG_NATIVE_VIDEO));

  d_tmpl_caps = get_template_caps (dec, GST_PAD_SRC);
  s_tmpl_caps = get_template_caps (sink, GST_PAD_SINK);

  if (!d_tmpl_caps || !s_tmpl_caps) {
    GST_ERROR ("Failed to get template caps from decoder or sink");
    return 0;
  }

  d_caps_size = gst_caps_get_size (d_tmpl_caps);
  s_caps_size = gst_caps_get_size (s_tmpl_caps);

  for (i = 0; i < d_caps_size; i++) {
    d_features = gst_caps_get_features ((const GstCaps *) d_tmpl_caps, i);
    d_struct = gst_caps_get_structure ((const GstCaps *) d_tmpl_caps, i);
    for (j = 0; j < s_caps_size; j++) {

      s_features = gst_caps_get_features ((const GstCaps *) s_tmpl_caps, j);
      s_struct = gst_caps_get_structure ((const GstCaps *) s_tmpl_caps, j);

      /* A common caps feature is given if the caps features are equal
       * and the structures can intersect. If the NATIVE_AUDIO/NATIVE_VIDEO
       * flags are not set we also allow if both structures are raw caps with
       * system memory caps features, because in that case we have converters in
       * place.
       */
      if (gst_caps_features_is_equal (d_features, s_features) &&
          (gst_structure_can_intersect (d_struct, s_struct) ||
              (!native_raw
                  && gst_caps_features_is_equal (d_features,
                      GST_CAPS_FEATURES_MEMORY_SYSTEM_MEMORY)
                  && gst_structure_can_intersect (raw_struct, d_struct)
                  && gst_structure_can_intersect (raw_struct, s_struct)))
          && !is_included (cf_list, s_features)) {
        cf_list = g_list_prepend (cf_list, s_features);
        n_common_cf++;
      }
    }
  }
  if (cf_list)
    g_list_free (cf_list);

  gst_caps_unref (d_tmpl_caps);
  gst_caps_unref (s_tmpl_caps);

  return n_common_cf;
}

static GSequence *
avelements_create (GstPlayBin * playbin, gboolean isaudioelement)
{
  GstElementFactory *d_factory, *s_factory;
  GList *dec_list, *sink_list, *dl, *sl;
  GSequence *ave_seq = NULL;
  GstAVElement *ave;
  guint n_common_cf = 0;

  if (isaudioelement) {
    sink_list = gst_element_factory_list_get_elements
        (GST_ELEMENT_FACTORY_TYPE_SINK |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO, GST_RANK_MARGINAL);
    dec_list =
        gst_element_factory_list_get_elements (GST_ELEMENT_FACTORY_TYPE_DECODER
        | GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO, GST_RANK_MARGINAL);
  } else {
    sink_list = gst_element_factory_list_get_elements
        (GST_ELEMENT_FACTORY_TYPE_SINK |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE, GST_RANK_MARGINAL);

    dec_list =
        gst_element_factory_list_get_elements (GST_ELEMENT_FACTORY_TYPE_DECODER
        | GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE, GST_RANK_MARGINAL);
  }

  /* create a list of audio/video elements. Each element in the list
   * is holding an audio/video decoder and an audio/video sink in which
   * the decoders srcpad template caps and sink element's sinkpad template
   * caps are compatible */
  dl = dec_list;
  sl = sink_list;

  ave_seq = g_sequence_new ((GDestroyNotify) avelements_free);

  for (; dl; dl = dl->next) {
    d_factory = (GstElementFactory *) dl->data;
    for (; sl; sl = sl->next) {
      s_factory = (GstElementFactory *) sl->data;

      n_common_cf =
          get_n_common_capsfeatures (playbin, d_factory, s_factory,
          isaudioelement);
      if (n_common_cf < 1)
        continue;

      ave = g_slice_new (GstAVElement);
      ave->dec = gst_object_ref (d_factory);
      ave->sink = gst_object_ref (s_factory);
      ave->n_comm_cf = n_common_cf;
      g_sequence_append (ave_seq, ave);
    }
    sl = sink_list;
  }
  g_sequence_sort (ave_seq, (GCompareDataFunc) avelement_compare_decoder, NULL);

  gst_plugin_feature_list_free (dec_list);
  gst_plugin_feature_list_free (sink_list);

  return ave_seq;
}

static gboolean
avelement_iter_is_equal (GSequenceIter * iter, GstElementFactory * factory)
{
  GstAVElement *ave;

  if (!iter)
    return FALSE;

  ave = g_sequence_get (iter);
  if (!ave)
    return FALSE;

  return strcmp (GST_OBJECT_NAME (ave->dec), GST_OBJECT_NAME (factory)) == 0;
}

static GList *
create_decoders_list (GList * factory_list, GSequence * avelements)
{
  GList *dec_list = NULL, *tmp;
  GList *ave_list = NULL;
  GList *ave_free_list = NULL;
  GstAVElement *ave, *best_ave;

  g_return_val_if_fail (factory_list != NULL, NULL);
  g_return_val_if_fail (avelements != NULL, NULL);

  for (tmp = factory_list; tmp; tmp = tmp->next) {
    GstElementFactory *factory = (GstElementFactory *) tmp->data;

    /* if there are parsers or sink elements, add them first */
    if (gst_element_factory_list_is_type (factory,
            GST_ELEMENT_FACTORY_TYPE_PARSER) ||
        gst_element_factory_list_is_type (factory,
            GST_ELEMENT_FACTORY_TYPE_SINK)) {
      dec_list = g_list_prepend (dec_list, gst_object_ref (factory));
    } else {
      GSequenceIter *seq_iter;

      seq_iter =
          g_sequence_lookup (avelements, factory,
          (GCompareDataFunc) avelement_lookup_decoder, NULL);
      if (!seq_iter) {
        GstAVElement *ave = g_slice_new0 (GstAVElement);

        ave->dec = factory;
        ave->sink = NULL;
        /* There's at least raw */
        ave->n_comm_cf = 1;

        ave_list = g_list_prepend (ave_list, ave);

        /* We need to free these later */
        ave_free_list = g_list_prepend (ave_free_list, ave);
        continue;
      }

      /* Go to first iter with that decoder */
      do {
        GSequenceIter *tmp_seq_iter;

        tmp_seq_iter = g_sequence_iter_prev (seq_iter);
        if (!avelement_iter_is_equal (tmp_seq_iter, factory))
          break;
        seq_iter = tmp_seq_iter;
      } while (!g_sequence_iter_is_begin (seq_iter));

      /* Get the best ranked GstAVElement for that factory */
      best_ave = NULL;
      while (!g_sequence_iter_is_end (seq_iter)
          && avelement_iter_is_equal (seq_iter, factory)) {
        ave = g_sequence_get (seq_iter);

        if (!best_ave || avelement_compare (ave, best_ave) < 0)
          best_ave = ave;

        seq_iter = g_sequence_iter_next (seq_iter);
      }
      ave_list = g_list_prepend (ave_list, best_ave);
    }
  }

  /* Sort all GstAVElements by their relative ranks and insert
   * into the decoders list */
  ave_list = g_list_sort (ave_list, (GCompareFunc) avelement_compare);
  for (tmp = ave_list; tmp; tmp = tmp->next) {
    ave = (GstAVElement *) tmp->data;
    dec_list = g_list_prepend (dec_list, gst_object_ref (ave->dec));
  }
  g_list_free (ave_list);
  gst_plugin_feature_list_free (factory_list);

  for (tmp = ave_free_list; tmp; tmp = tmp->next)
    g_slice_free (GstAVElement, tmp->data);
  g_list_free (ave_free_list);

  dec_list = g_list_reverse (dec_list);

  return dec_list;
}

/* Called when we must provide a list of factories to plug to @pad with @caps.
 * We first check if we have a sink that can handle the format and if we do, we
 * return NULL, to expose the pad. If we have no sink (or the sink does not
 * work), we return the list of elements that can connect. */
static GValueArray *
autoplug_factories_cb (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GList *factory_list, *tmp;
  GValueArray *result;
  gboolean unref_caps = FALSE;
  gboolean isaudiodeclist = FALSE;
  gboolean isvideodeclist = FALSE;

  if (!caps) {
    caps = gst_caps_new_any ();
    unref_caps = TRUE;
  }

  playbin = group->playbin;

  GST_DEBUG_OBJECT (playbin, "factories group %p for %s:%s, %" GST_PTR_FORMAT,
      group, GST_DEBUG_PAD_NAME (pad), caps);

  /* filter out the elements based on the caps. */
  g_mutex_lock (&playbin->elements_lock);
  gst_play_bin_update_elements_list (playbin);
  factory_list =
      gst_element_factory_list_filter (playbin->elements, caps, GST_PAD_SINK,
      gst_caps_is_fixed (caps));
  g_mutex_unlock (&playbin->elements_lock);

  GST_DEBUG_OBJECT (playbin, "found factories %p", factory_list);
  GST_PLUGIN_FEATURE_LIST_DEBUG (factory_list);

  /* check whether the caps are asking for a list of audio/video decoders */
  tmp = factory_list;
  if (!gst_caps_is_any (caps)) {
    for (; tmp; tmp = tmp->next) {
      GstElementFactory *factory = (GstElementFactory *) tmp->data;

      isvideodeclist = gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_DECODER |
          GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
          GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE);
      isaudiodeclist = gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_DECODER |
          GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO);

      if (isaudiodeclist || isvideodeclist)
        break;
    }
  }

  if (isaudiodeclist || isvideodeclist) {
    GSequence **ave_list;
    if (isaudiodeclist)
      ave_list = &playbin->aelements;
    else
      ave_list = &playbin->velements;

    g_mutex_lock (&playbin->elements_lock);
    /* sort factory_list based on the GstAVElement list priority */
    factory_list = create_decoders_list (factory_list, *ave_list);
    g_mutex_unlock (&playbin->elements_lock);
  }

  /* 2 additional elements for the already set audio/video sinks */
  result = g_value_array_new (g_list_length (factory_list) + 2);

  /* Check if we already have an audio/video sink and if this is the case
   * put it as the first element of the array */
  if (group->audio_sink) {
    GstElementFactory *factory = gst_element_get_factory (group->audio_sink);

    if (factory && _factory_can_sink_caps (factory, caps)) {
      GValue val = { 0, };

      g_value_init (&val, G_TYPE_OBJECT);
      g_value_set_object (&val, factory);
      result = g_value_array_append (result, &val);
      g_value_unset (&val);
    }
  }

  if (group->video_sink) {
    GstElementFactory *factory = gst_element_get_factory (group->video_sink);

    if (factory && _factory_can_sink_caps (factory, caps)) {
      GValue val = { 0, };

      g_value_init (&val, G_TYPE_OBJECT);
      g_value_set_object (&val, factory);
      result = g_value_array_append (result, &val);
      g_value_unset (&val);
    }
  }

  for (tmp = factory_list; tmp; tmp = tmp->next) {
    GstElementFactory *factory = GST_ELEMENT_FACTORY_CAST (tmp->data);
    GValue val = { 0, };

    if (group->audio_sink && gst_element_factory_list_is_type (factory,
            GST_ELEMENT_FACTORY_TYPE_SINK |
            GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO)) {
      continue;
    }
    if (group->video_sink && gst_element_factory_list_is_type (factory,
            GST_ELEMENT_FACTORY_TYPE_SINK | GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO
            | GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE)) {
      continue;
    }

    g_value_init (&val, G_TYPE_OBJECT);
    g_value_set_object (&val, factory);
    g_value_array_append (result, &val);
    g_value_unset (&val);
  }
  gst_plugin_feature_list_free (factory_list);

  if (unref_caps)
    gst_caps_unref (caps);

  return result;
}

static void
gst_play_bin_set_context (GstElement * element, GstContext * context)
{
  GstPlayBin *playbin = GST_PLAY_BIN (element);

  /* Proxy contexts to the sinks, they might not be in playsink yet */
  GST_PLAY_BIN_LOCK (playbin);
  if (playbin->audio_sink)
    gst_element_set_context (playbin->audio_sink, context);
  if (playbin->video_sink)
    gst_element_set_context (playbin->video_sink, context);
  if (playbin->text_sink)
    gst_element_set_context (playbin->text_sink, context);

  GST_SOURCE_GROUP_LOCK (playbin->curr_group);

  if (playbin->curr_group->audio_sink)
    gst_element_set_context (playbin->curr_group->audio_sink, context);
  if (playbin->curr_group->video_sink)
    gst_element_set_context (playbin->curr_group->video_sink, context);
  if (playbin->curr_group->text_sink)
    gst_element_set_context (playbin->curr_group->text_sink, context);

  GST_SOURCE_GROUP_UNLOCK (playbin->curr_group);
  GST_PLAY_BIN_UNLOCK (playbin);

  GST_ELEMENT_CLASS (parent_class)->set_context (element, context);
}

/* Pass sink messages to the application, e.g. NEED_CONTEXT messages */
static void
gst_play_bin_update_context (GstPlayBin * playbin, GstContext * context)
{
  GList *l;
  const gchar *context_type;

  GST_OBJECT_LOCK (playbin);
  context_type = gst_context_get_context_type (context);
  for (l = playbin->contexts; l; l = l->next) {
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
    playbin->contexts =
        g_list_prepend (playbin->contexts, gst_context_ref (context));
  GST_OBJECT_UNLOCK (playbin);
}

static GstBusSyncReply
activate_sink_bus_handler (GstBus * bus, GstMessage * msg, GstPlayBin * playbin)
{
  if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_ERROR) {
    /* Only proxy errors from a fixed sink. If that fails we can just error out
     * early as stuff will fail later anyway */
    if (playbin->audio_sink
        && gst_object_has_ancestor (GST_MESSAGE_SRC (msg),
            GST_OBJECT_CAST (playbin->audio_sink)))
      gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
    else if (playbin->video_sink
        && gst_object_has_ancestor (GST_MESSAGE_SRC (msg),
            GST_OBJECT_CAST (playbin->video_sink)))
      gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
    else if (playbin->text_sink
        && gst_object_has_ancestor (GST_MESSAGE_SRC (msg),
            GST_OBJECT_CAST (playbin->text_sink)))
      gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
    else
      gst_message_unref (msg);
  } else if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_NEED_CONTEXT) {
    const gchar *context_type;
    GList *l;

    gst_message_parse_context_type (msg, &context_type);
    GST_OBJECT_LOCK (playbin);
    for (l = playbin->contexts; l; l = l->next) {
      GstContext *tmp = l->data;
      const gchar *tmp_type = gst_context_get_context_type (tmp);

      if (strcmp (context_type, tmp_type) == 0) {
        gst_element_set_context (GST_ELEMENT (GST_MESSAGE_SRC (msg)), l->data);
        break;
      }
    }
    GST_OBJECT_UNLOCK (playbin);

    /* Forward if we couldn't answer the message */
    if (l == NULL) {
      gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
    } else {
      gst_message_unref (msg);
    }
  } else if (GST_MESSAGE_TYPE (msg) == GST_MESSAGE_HAVE_CONTEXT) {
    GstContext *context;

    gst_message_parse_have_context (msg, &context);
    gst_play_bin_update_context (playbin, context);
    gst_context_unref (context);

    gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
  } else {
    gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);
  }

  /* Doesn't really matter, nothing is using this bus */
  return GST_BUS_DROP;
}

static gboolean
activate_sink (GstPlayBin * playbin, GstElement * sink, gboolean * activated)
{
  GstState state;
  GstBus *bus = NULL;
  GstStateChangeReturn sret;
  gboolean ret = FALSE;

  if (activated)
    *activated = FALSE;

  GST_OBJECT_LOCK (sink);
  state = GST_STATE (sink);
  GST_OBJECT_UNLOCK (sink);
  if (state >= GST_STATE_READY) {
    ret = TRUE;
    goto done;
  }

  if (!GST_OBJECT_PARENT (sink)) {
    bus = gst_bus_new ();
    gst_bus_set_sync_handler (bus,
        (GstBusSyncHandler) activate_sink_bus_handler, playbin, NULL);
    gst_element_set_bus (sink, bus);
  }

  sret = gst_element_set_state (sink, GST_STATE_READY);
  if (sret == GST_STATE_CHANGE_FAILURE)
    goto done;

  if (activated)
    *activated = TRUE;
  ret = TRUE;

done:
  if (bus) {
    gst_element_set_bus (sink, NULL);
    gst_object_unref (bus);
  }

  return ret;
}

/* autoplug-continue decides, if a pad has raw caps that can be exposed
 * directly or if further decoding is necessary. We use this to expose
 * supported subtitles directly */

/* FIXME 0.11: Remove the checks for ANY caps, a sink should specify
 * explicitly the caps it supports and if it claims to support ANY
 * caps it really should support everything */
static gboolean
autoplug_continue_cb (GstElement * element, GstPad * pad, GstCaps * caps,
    GstSourceGroup * group)
{
  gboolean ret = TRUE;
  GstElement *sink;
  GstPad *sinkpad = NULL;

  GST_SOURCE_GROUP_LOCK (group);

  if ((sink = group->text_sink))
    sinkpad = gst_element_get_static_pad (sink, "sink");
  if (sinkpad) {
    GstCaps *sinkcaps;

    sinkcaps = gst_pad_query_caps (sinkpad, NULL);
    if (!gst_caps_is_any (sinkcaps))
      ret = !gst_pad_query_accept_caps (sinkpad, caps);
    gst_caps_unref (sinkcaps);
    gst_object_unref (sinkpad);
  } else {
    GstCaps *subcaps = gst_subtitle_overlay_create_factory_caps ();
    ret = !gst_caps_is_subset (caps, subcaps);
    gst_caps_unref (subcaps);
  }
  /* If autoplugging can stop don't do additional checks */
  if (!ret)
    goto done;

  /* If this is from the subtitle uridecodebin we don't need to
   * check the audio and video sink */
  if (group->suburidecodebin
      && gst_object_has_ancestor (GST_OBJECT_CAST (element),
          GST_OBJECT_CAST (group->suburidecodebin)))
    goto done;

  if ((sink = group->audio_sink)) {
    sinkpad = gst_element_get_static_pad (sink, "sink");
    if (sinkpad) {
      GstCaps *sinkcaps;

      sinkcaps = gst_pad_query_caps (sinkpad, NULL);
      if (!gst_caps_is_any (sinkcaps))
        ret = !gst_pad_query_accept_caps (sinkpad, caps);
      gst_caps_unref (sinkcaps);
      gst_object_unref (sinkpad);
    }
  }
  if (!ret)
    goto done;

  if ((sink = group->video_sink)) {
    sinkpad = gst_element_get_static_pad (sink, "sink");
    if (sinkpad) {
      GstCaps *sinkcaps;

      sinkcaps = gst_pad_query_caps (sinkpad, NULL);
      if (!gst_caps_is_any (sinkcaps))
        ret = !gst_pad_query_accept_caps (sinkpad, caps);
      gst_caps_unref (sinkcaps);
      gst_object_unref (sinkpad);
    }
  }

done:
  GST_SOURCE_GROUP_UNLOCK (group);

  GST_DEBUG_OBJECT (group->playbin,
      "continue autoplugging group %p for %s:%s, %" GST_PTR_FORMAT ": %d",
      group, GST_DEBUG_PAD_NAME (pad), caps, ret);

  return ret;
}

static gboolean
sink_accepts_caps (GstPlayBin * playbin, GstElement * sink, GstCaps * caps)
{
  GstPad *sinkpad;

  if ((sinkpad = gst_element_get_static_pad (sink, "sink"))) {
    /* Got the sink pad, now let's see if the element actually does accept the
     * caps that we have */
    if (!gst_pad_query_accept_caps (sinkpad, caps)) {
      gst_object_unref (sinkpad);
      return FALSE;
    }
    gst_object_unref (sinkpad);
  }

  return TRUE;
}

/* We are asked to select an element. See if the next element to check
 * is a sink. If this is the case, we see if the sink works by setting it to
 * READY. If the sink works, we return SELECT_EXPOSE to make decodebin
 * expose the raw pad so that we can setup the mixers. */
static GstAutoplugSelectResult
autoplug_select_cb (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GstElementFactory * factory, GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GstElement *element;
  const gchar *klass;
  GstPlaySinkType type;
  GstElement **sinkp;
  GList *ave_list = NULL, *l;
  GstAVElement *ave = NULL;
  GSequence *ave_seq = NULL;
  GSequenceIter *seq_iter;

  playbin = group->playbin;

  GST_DEBUG_OBJECT (playbin, "select group %p for %s:%s, %" GST_PTR_FORMAT,
      group, GST_DEBUG_PAD_NAME (pad), caps);

  GST_DEBUG_OBJECT (playbin, "checking factory %s", GST_OBJECT_NAME (factory));

  /* if it's not a sink, we make sure the element is compatible with
   * the fixed sink */
  if (!gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_SINK)) {
    gboolean isvideodec = gst_element_factory_list_is_type (factory,
        GST_ELEMENT_FACTORY_TYPE_DECODER |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE);
    gboolean isaudiodec = gst_element_factory_list_is_type (factory,
        GST_ELEMENT_FACTORY_TYPE_DECODER |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO);

    if (!isvideodec && !isaudiodec)
      return GST_AUTOPLUG_SELECT_TRY;

    GST_SOURCE_GROUP_LOCK (group);
    g_mutex_lock (&playbin->elements_lock);

    if (isaudiodec) {
      ave_seq = playbin->aelements;
      sinkp = &group->audio_sink;
    } else {
      ave_seq = playbin->velements;
      sinkp = &group->video_sink;
    }

    seq_iter =
        g_sequence_lookup (ave_seq, factory,
        (GCompareDataFunc) avelement_lookup_decoder, NULL);
    if (seq_iter) {
      /* Go to first iter with that decoder */
      do {
        GSequenceIter *tmp_seq_iter;

        tmp_seq_iter = g_sequence_iter_prev (seq_iter);
        if (!avelement_iter_is_equal (tmp_seq_iter, factory))
          break;
        seq_iter = tmp_seq_iter;
      } while (!g_sequence_iter_is_begin (seq_iter));

      while (!g_sequence_iter_is_end (seq_iter)
          && avelement_iter_is_equal (seq_iter, factory)) {
        ave = g_sequence_get (seq_iter);
        ave_list = g_list_prepend (ave_list, ave);
        seq_iter = g_sequence_iter_next (seq_iter);
      }

      /* Sort all GstAVElements by their relative ranks and insert
       * into the decoders list */
      ave_list = g_list_sort (ave_list, (GCompareFunc) avelement_compare);
    } else {
      ave_list = g_list_prepend (ave_list, NULL);
    }

    /* if it is a decoder and we don't have a fixed sink, then find out 
     * the matching audio/video sink from GstAVElements list */
    for (l = ave_list; l; l = l->next) {
      gboolean created_sink = FALSE;

      ave = (GstAVElement *) l->data;

      if (((isaudiodec && !group->audio_sink) ||
              (isvideodec && !group->video_sink))) {
        if (ave && ave->sink) {
          GST_DEBUG_OBJECT (playbin,
              "Trying to create sink '%s' for decoder '%s'",
              gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (ave->sink)),
              gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (factory)));
          if ((*sinkp = gst_element_factory_create (ave->sink, NULL)) == NULL) {
            GST_WARNING_OBJECT (playbin,
                "Could not create an element from %s",
                gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (ave->sink)));
            continue;
          } else {
            if (!activate_sink (playbin, *sinkp, NULL)) {
              gst_object_unref (*sinkp);
              *sinkp = NULL;
              GST_WARNING_OBJECT (playbin,
                  "Could not activate sink %s",
                  gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (ave->sink)));
              continue;
            }
            gst_object_ref_sink (*sinkp);
            created_sink = TRUE;
          }
        }
      }

      /* If it is a decoder and we have a fixed sink for the media
       * type it outputs, check that the decoder is compatible with this sink */
      if ((isaudiodec && group->audio_sink) || (isvideodec
              && group->video_sink)) {
        gboolean compatible = FALSE;
        GstPad *sinkpad;
        GstCaps *caps;
        GstElement *sink;

        sink = *sinkp;

        if ((sinkpad = gst_element_get_static_pad (sink, "sink"))) {
          GstPlayFlags flags = gst_play_bin_get_flags (playbin);
          GstCaps *raw_caps =
              (isaudiodec) ? gst_static_caps_get (&raw_audio_caps) :
              gst_static_caps_get (&raw_video_caps);

          caps = gst_pad_query_caps (sinkpad, NULL);

          /* If the sink supports raw audio/video, we first check
           * if the decoder could output any raw audio/video format
           * and assume it is compatible with the sink then. We don't
           * do a complete compatibility check here if converters
           * are plugged between the decoder and the sink because
           * the converters will convert between raw formats and
           * even if the decoder format is not supported by the decoder
           * a converter will convert it.
           *
           * We assume here that the converters can convert between
           * any raw format.
           */
          if ((isaudiodec && !(flags & GST_PLAY_FLAG_NATIVE_AUDIO)
                  && gst_caps_can_intersect (caps, raw_caps)) || (!isaudiodec
                  && !(flags & GST_PLAY_FLAG_NATIVE_VIDEO)
                  && gst_caps_can_intersect (caps, raw_caps))) {
            compatible =
                gst_element_factory_can_src_any_caps (factory, raw_caps)
                || gst_element_factory_can_src_any_caps (factory, caps);
          } else {
            compatible = gst_element_factory_can_src_any_caps (factory, caps);
          }

          gst_object_unref (sinkpad);
          gst_caps_unref (caps);
        }

        if (compatible)
          break;

        GST_DEBUG_OBJECT (playbin, "%s not compatible with the fixed sink",
            GST_OBJECT_NAME (factory));

        /* If it is not compatible, either continue with the next possible
         * sink or if we have a fixed sink, skip the decoder */
        if (created_sink) {
          gst_element_set_state (*sinkp, GST_STATE_NULL);
          gst_object_unref (*sinkp);
          *sinkp = NULL;
        } else {
          g_mutex_unlock (&playbin->elements_lock);
          GST_SOURCE_GROUP_UNLOCK (group);
          return GST_AUTOPLUG_SELECT_SKIP;
        }
      }
    }
    g_list_free (ave_list);
    g_mutex_unlock (&playbin->elements_lock);
    GST_SOURCE_GROUP_UNLOCK (group);
    return GST_AUTOPLUG_SELECT_TRY;
  }

  /* it's a sink, see if an instance of it actually works */
  GST_DEBUG_OBJECT (playbin, "we found a sink '%s'", GST_OBJECT_NAME (factory));

  klass =
      gst_element_factory_get_metadata (factory, GST_ELEMENT_METADATA_KLASS);

  /* figure out the klass */
  if (strstr (klass, "Audio")) {
    GST_DEBUG_OBJECT (playbin, "we found an audio sink");
    type = GST_PLAY_SINK_TYPE_AUDIO;
    sinkp = &group->audio_sink;
  } else if (strstr (klass, "Video")) {
    GST_DEBUG_OBJECT (playbin, "we found a video sink");
    type = GST_PLAY_SINK_TYPE_VIDEO;
    sinkp = &group->video_sink;
  } else {
    /* unknown klass, skip this element */
    GST_WARNING_OBJECT (playbin, "unknown sink klass %s found", klass);
    return GST_AUTOPLUG_SELECT_SKIP;
  }

  /* if we are asked to do visualisations and it's an audio sink, skip the
   * element. We can only do visualisations with raw sinks */
  if (gst_play_sink_get_flags (playbin->playsink) & GST_PLAY_FLAG_VIS) {
    if (type == GST_PLAY_SINK_TYPE_AUDIO) {
      GST_DEBUG_OBJECT (playbin, "skip audio sink because of vis");
      return GST_AUTOPLUG_SELECT_SKIP;
    }
  }

  /* now see if we already have a sink element */
  GST_SOURCE_GROUP_LOCK (group);
  if (*sinkp) {
    GstElement *sink = gst_object_ref (*sinkp);

    if (sink_accepts_caps (playbin, sink, caps)) {
      GST_DEBUG_OBJECT (playbin,
          "Existing sink '%s' accepts caps: %" GST_PTR_FORMAT,
          GST_ELEMENT_NAME (sink), caps);
      gst_object_unref (sink);
      GST_SOURCE_GROUP_UNLOCK (group);
      return GST_AUTOPLUG_SELECT_EXPOSE;
    } else {
      GST_DEBUG_OBJECT (playbin,
          "Existing sink '%s' does not accept caps: %" GST_PTR_FORMAT,
          GST_ELEMENT_NAME (sink), caps);
      gst_object_unref (sink);
      GST_SOURCE_GROUP_UNLOCK (group);
      return GST_AUTOPLUG_SELECT_SKIP;
    }
  }
  GST_DEBUG_OBJECT (playbin, "we have no pending sink, try to create '%s'",
      gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (factory)));

  if ((*sinkp = gst_element_factory_create (factory, NULL)) == NULL) {
    GST_WARNING_OBJECT (playbin, "Could not create an element from %s",
        gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (factory)));
    GST_SOURCE_GROUP_UNLOCK (group);
    return GST_AUTOPLUG_SELECT_SKIP;
  }

  element = *sinkp;

  if (!activate_sink (playbin, element, NULL)) {
    GST_WARNING_OBJECT (playbin, "Could not activate sink %s",
        gst_plugin_feature_get_name (GST_PLUGIN_FEATURE (factory)));
    *sinkp = NULL;
    gst_object_unref (element);
    GST_SOURCE_GROUP_UNLOCK (group);
    return GST_AUTOPLUG_SELECT_SKIP;
  }

  /* Check if the selected sink actually supports the
   * caps and can be set to READY*/
  if (!sink_accepts_caps (playbin, element, caps)) {
    *sinkp = NULL;
    gst_element_set_state (element, GST_STATE_NULL);
    gst_object_unref (element);
    GST_SOURCE_GROUP_UNLOCK (group);
    return GST_AUTOPLUG_SELECT_SKIP;
  }

  /* remember the sink in the group now, the element is floating, we take
   * ownership now 
   *
   * store the sink in the group, we will configure it later when we
   * reconfigure the sink */
  GST_DEBUG_OBJECT (playbin, "remember sink");
  gst_object_ref_sink (element);
  GST_SOURCE_GROUP_UNLOCK (group);

  /* tell decodebin to expose the pad because we are going to use this
   * sink */
  GST_DEBUG_OBJECT (playbin, "we found a working sink, expose pad");

  return GST_AUTOPLUG_SELECT_EXPOSE;
}

#define GST_PLAY_BIN_FILTER_CAPS(filter,caps) G_STMT_START {                  \
  if ((filter)) {                                                             \
    GstCaps *intersection =                                                   \
        gst_caps_intersect_full ((filter), (caps), GST_CAPS_INTERSECT_FIRST); \
    gst_caps_unref ((caps));                                                  \
    (caps) = intersection;                                                    \
  }                                                                           \
} G_STMT_END

static gboolean
autoplug_query_caps (GstElement * uridecodebin, GstPad * pad,
    GstElement * element, GstQuery * query, GstSourceGroup * group)
{
  GstCaps *filter, *result = NULL;
  GstElement *sink;
  GstPad *sinkpad = NULL;
  GstElementFactory *factory;
  GstElementFactoryListType factory_type;
  gboolean have_sink = FALSE;

  GST_SOURCE_GROUP_LOCK (group);
  gst_query_parse_caps (query, &filter);

  factory = gst_element_get_factory (element);
  if (!factory)
    goto done;

  if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
          GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE)) {
    factory_type =
        GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
        GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE;

    /* If this is from the subtitle uridecodebin we don't need to
     * check the audio and video sink */
    if (group->suburidecodebin
        && gst_object_has_ancestor (GST_OBJECT_CAST (pad),
            GST_OBJECT_CAST (group->suburidecodebin))) {
      goto done;
    }

    if ((sink = group->video_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        GstCaps *sinkcaps;

        sinkcaps = gst_pad_query_caps (sinkpad, filter);
        if (!gst_caps_is_any (sinkcaps)) {
          if (!result)
            result = sinkcaps;
          else
            result = gst_caps_merge (result, sinkcaps);
        } else {
          gst_caps_unref (sinkcaps);
        }
        gst_object_unref (sinkpad);
      }
      have_sink = TRUE;
    }
  } else if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO)) {
    factory_type = GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO;

    /* If this is from the subtitle uridecodebin we don't need to
     * check the audio and video sink */
    if (group->suburidecodebin
        && gst_object_has_ancestor (GST_OBJECT_CAST (pad),
            GST_OBJECT_CAST (group->suburidecodebin))) {
      goto done;
    }

    if ((sink = group->audio_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        GstCaps *sinkcaps;

        sinkcaps = gst_pad_query_caps (sinkpad, filter);
        if (!gst_caps_is_any (sinkcaps)) {
          if (!result)
            result = sinkcaps;
          else
            result = gst_caps_merge (result, sinkcaps);
        } else {
          gst_caps_unref (sinkcaps);
        }
        gst_object_unref (sinkpad);
      }
      have_sink = TRUE;
    }
  } else if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_SUBTITLE)) {
    factory_type = GST_ELEMENT_FACTORY_TYPE_MEDIA_SUBTITLE;

    if ((sink = group->playbin->text_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        GstCaps *sinkcaps;

        sinkcaps = gst_pad_query_caps (sinkpad, filter);
        if (!gst_caps_is_any (sinkcaps)) {
          if (!result)
            result = sinkcaps;
          else
            result = gst_caps_merge (result, sinkcaps);
        } else {
          gst_caps_unref (sinkcaps);
        }
        gst_object_unref (sinkpad);
      }
      have_sink = TRUE;
    } else {
      GstCaps *subcaps = gst_subtitle_overlay_create_factory_caps ();
      GST_PLAY_BIN_FILTER_CAPS (filter, subcaps);
      if (!result)
        result = subcaps;
      else
        result = gst_caps_merge (result, subcaps);
    }
  } else {
    goto done;
  }

  if (!have_sink) {
    GValueArray *factories;
    gint i, n;

    factories = autoplug_factories_cb (uridecodebin, pad, NULL, group);
    n = factories->n_values;
    for (i = 0; i < n; i++) {
      GValue *v = g_value_array_get_nth (factories, i);
      GstElementFactory *f = g_value_get_object (v);
      const GList *templates;
      const GList *l;
      GstCaps *templ_caps;

      if (!gst_element_factory_list_is_type (f, factory_type))
        continue;

      templates = gst_element_factory_get_static_pad_templates (f);

      for (l = templates; l; l = l->next) {
        templ_caps = gst_static_pad_template_get_caps (l->data);

        if (!gst_caps_is_any (templ_caps)) {
          GST_PLAY_BIN_FILTER_CAPS (filter, templ_caps);
          if (!result)
            result = templ_caps;
          else
            result = gst_caps_merge (result, templ_caps);
        } else {
          gst_caps_unref (templ_caps);
        }
      }
    }
    g_value_array_free (factories);
  }

done:
  GST_SOURCE_GROUP_UNLOCK (group);

  if (!result)
    return FALSE;

  /* Add the actual decoder/parser/etc caps at the very end to
   * make sure we don't cause empty caps to be returned, e.g.
   * if a parser asks us but a decoder is required after it
   * because no sink can handle the format directly.
   */
  {
    GstPad *target = gst_ghost_pad_get_target (GST_GHOST_PAD (pad));

    if (target) {
      GstCaps *target_caps = gst_pad_get_pad_template_caps (target);
      GST_PLAY_BIN_FILTER_CAPS (filter, target_caps);
      result = gst_caps_merge (result, target_caps);
      gst_object_unref (target);
    }
  }


  gst_query_set_caps_result (query, result);
  gst_caps_unref (result);

  return TRUE;
}

static gboolean
autoplug_query_context (GstElement * uridecodebin, GstPad * pad,
    GstElement * element, GstQuery * query, GstSourceGroup * group)
{
  GstElement *sink;
  GstPad *sinkpad = NULL;
  GstElementFactory *factory;
  gboolean res = FALSE;

  GST_SOURCE_GROUP_LOCK (group);

  factory = gst_element_get_factory (element);
  if (!factory)
    goto done;

  if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
          GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE)) {
    /* If this is from the subtitle uridecodebin we don't need to
     * check the audio and video sink */
    if (group->suburidecodebin
        && gst_object_has_ancestor (GST_OBJECT_CAST (pad),
            GST_OBJECT_CAST (group->suburidecodebin))) {
      goto done;
    }

    if ((sink = group->video_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        res = gst_pad_query (sinkpad, query);
        gst_object_unref (sinkpad);
      }
    }
  } else if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO)) {
    /* If this is from the subtitle uridecodebin we don't need to
     * check the audio and video sink */
    if (group->suburidecodebin
        && gst_object_has_ancestor (GST_OBJECT_CAST (pad),
            GST_OBJECT_CAST (group->suburidecodebin))) {
      goto done;
    }

    if ((sink = group->audio_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        res = gst_pad_query (sinkpad, query);
        gst_object_unref (sinkpad);
      }
    }
  } else if (gst_element_factory_list_is_type (factory,
          GST_ELEMENT_FACTORY_TYPE_MEDIA_SUBTITLE)) {
    if ((sink = group->playbin->text_sink)) {
      sinkpad = gst_element_get_static_pad (sink, "sink");
      if (sinkpad) {
        res = gst_pad_query (sinkpad, query);
        gst_object_unref (sinkpad);
      }
    }
  } else {
    goto done;
  }

done:
  GST_SOURCE_GROUP_UNLOCK (group);

  return res;
}

static gboolean
autoplug_query_cb (GstElement * uridecodebin, GstPad * pad,
    GstElement * element, GstQuery * query, GstSourceGroup * group)
{

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CAPS:
      return autoplug_query_caps (uridecodebin, pad, element, query, group);
    case GST_QUERY_CONTEXT:
      return autoplug_query_context (uridecodebin, pad, element, query, group);
    default:
      return FALSE;
  }
}

static void
notify_source_cb (GstElement * uridecodebin, GParamSpec * pspec,
    GstSourceGroup * group)
{
  GstPlayBin *playbin;
  GstElement *source;

  playbin = group->playbin;

  g_object_get (group->uridecodebin, "source", &source, NULL);

  GST_OBJECT_LOCK (playbin);
  if (playbin->source)
    gst_object_unref (playbin->source);
  playbin->source = source;
  GST_OBJECT_UNLOCK (playbin);

  g_object_notify (G_OBJECT (playbin), "source");

  g_signal_emit (playbin, gst_play_bin_signals[SIGNAL_SOURCE_SETUP],
      0, playbin->source);
}

/* must be called with the group lock */
static gboolean
group_set_locked_state_unlocked (GstPlayBin * playbin, GstSourceGroup * group,
    gboolean locked)
{
  GST_DEBUG_OBJECT (playbin, "locked_state %d on group %p", locked, group);

  if (group->uridecodebin)
    gst_element_set_locked_state (group->uridecodebin, locked);
  if (group->suburidecodebin)
    gst_element_set_locked_state (group->suburidecodebin, locked);

  return TRUE;
}

/* must be called with PLAY_BIN_LOCK */
static gboolean
activate_group (GstPlayBin * playbin, GstSourceGroup * group, GstState target)
{
  GstElement *uridecodebin = NULL;
  GstElement *suburidecodebin = NULL;
  GstPlayFlags flags;
  gboolean audio_sink_activated = FALSE;
  gboolean video_sink_activated = FALSE;
  gboolean text_sink_activated = FALSE;

  g_return_val_if_fail (group->valid, FALSE);
  g_return_val_if_fail (!group->active, FALSE);

  GST_DEBUG_OBJECT (playbin, "activating group %p", group);

  GST_SOURCE_GROUP_LOCK (group);

  /* First set up the custom sources */
  if (playbin->audio_sink)
    group->audio_sink = gst_object_ref (playbin->audio_sink);
  else
    group->audio_sink =
        gst_play_sink_get_sink (playbin->playsink, GST_PLAY_SINK_TYPE_AUDIO);

  if (group->audio_sink) {
    if (!activate_sink (playbin, group->audio_sink, &audio_sink_activated)) {
      if (group->audio_sink == playbin->audio_sink) {
        goto sink_failure;
      } else {
        gst_object_unref (group->audio_sink);
        group->audio_sink = NULL;
      }
    }
  }

  if (playbin->video_sink)
    group->video_sink = gst_object_ref (playbin->video_sink);
  else
    group->video_sink =
        gst_play_sink_get_sink (playbin->playsink, GST_PLAY_SINK_TYPE_VIDEO);

  if (group->video_sink) {
    if (!activate_sink (playbin, group->video_sink, &video_sink_activated)) {
      if (group->video_sink == playbin->video_sink) {
        goto sink_failure;
      } else {
        gst_object_unref (group->video_sink);
        group->video_sink = NULL;
      }
    }
  }

  if (playbin->text_sink)
    group->text_sink = gst_object_ref (playbin->text_sink);
  else
    group->text_sink =
        gst_play_sink_get_sink (playbin->playsink, GST_PLAY_SINK_TYPE_TEXT);

  if (group->text_sink) {
    if (!activate_sink (playbin, group->text_sink, &text_sink_activated)) {
      if (group->text_sink == playbin->text_sink) {
        goto sink_failure;
      } else {
        gst_object_unref (group->text_sink);
        group->text_sink = NULL;
      }
    }
  }

  g_slist_free (group->suburi_flushes_to_drop);
  group->suburi_flushes_to_drop = NULL;
  if (!group->suburi_flushes_to_drop_lock.p)
    g_mutex_init (&group->suburi_flushes_to_drop_lock);

  if (group->uridecodebin) {
    GST_DEBUG_OBJECT (playbin, "reusing existing uridecodebin");
    uridecodebin = group->uridecodebin;
    gst_element_set_state (uridecodebin, GST_STATE_READY);
    /* no need to take extra ref, we already have one
     * and the bin will add one since it is no longer floating,
     * as it was at least added once before (below) */
    gst_bin_add (GST_BIN_CAST (playbin), uridecodebin);
  } else {
    GST_DEBUG_OBJECT (playbin, "making new uridecodebin");
    uridecodebin = gst_element_factory_make ("uridecodebin", NULL);
    if (!uridecodebin)
      goto no_decodebin;
    gst_bin_add (GST_BIN_CAST (playbin), uridecodebin);
    group->uridecodebin = gst_object_ref (uridecodebin);
  }

  flags = gst_play_sink_get_flags (playbin->playsink);

  g_object_set (uridecodebin,
      /* configure connection speed */
      "connection-speed", playbin->connection_speed / 1000,
      /* configure uri */
      "uri", group->uri,
      /* configure download buffering */
      "download", ((flags & GST_PLAY_FLAG_DOWNLOAD) != 0),
      /* configure buffering of demuxed/parsed data */
      "use-buffering", ((flags & GST_PLAY_FLAG_BUFFERING) != 0),
      /* configure buffering parameters */
      "buffer-duration", playbin->buffer_duration,
      "buffer-size", playbin->buffer_size,
      "ring-buffer-max-size", playbin->ring_buffer_max_size, NULL);

  /* connect pads and other things */
  group->pad_added_id = g_signal_connect (uridecodebin, "pad-added",
      G_CALLBACK (pad_added_cb), group);
  group->pad_removed_id = g_signal_connect (uridecodebin, "pad-removed",
      G_CALLBACK (pad_removed_cb), group);
  group->no_more_pads_id = g_signal_connect (uridecodebin, "no-more-pads",
      G_CALLBACK (no_more_pads_cb), group);
  group->notify_source_id = g_signal_connect (uridecodebin, "notify::source",
      G_CALLBACK (notify_source_cb), group);

  /* we have 1 pending no-more-pads */
  group->pending = 1;

  /* is called when the uridecodebin is out of data and we can switch to the
   * next uri */
  group->drained_id =
      g_signal_connect (uridecodebin, "drained", G_CALLBACK (drained_cb),
      group);

  /* will be called when a new media type is found. We return a list of decoders
   * including sinks for decodebin to try */
  group->autoplug_factories_id =
      g_signal_connect (uridecodebin, "autoplug-factories",
      G_CALLBACK (autoplug_factories_cb), group);
  group->autoplug_select_id =
      g_signal_connect (uridecodebin, "autoplug-select",
      G_CALLBACK (autoplug_select_cb), group);
  group->autoplug_continue_id =
      g_signal_connect (uridecodebin, "autoplug-continue",
      G_CALLBACK (autoplug_continue_cb), group);
  group->autoplug_query_id =
      g_signal_connect (uridecodebin, "autoplug-query",
      G_CALLBACK (autoplug_query_cb), group);

  if (group->suburi) {
    /* subtitles */
    if (group->suburidecodebin) {
      GST_DEBUG_OBJECT (playbin, "reusing existing suburidecodebin");
      suburidecodebin = group->suburidecodebin;
      gst_element_set_state (suburidecodebin, GST_STATE_READY);
      /* no need to take extra ref, we already have one
       * and the bin will add one since it is no longer floating,
       * as it was at least added once before (below) */
      gst_bin_add (GST_BIN_CAST (playbin), suburidecodebin);
    } else {
      GST_DEBUG_OBJECT (playbin, "making new suburidecodebin");
      suburidecodebin = gst_element_factory_make ("uridecodebin", NULL);
      if (!suburidecodebin)
        goto no_decodebin;

      gst_bin_add (GST_BIN_CAST (playbin), suburidecodebin);
      group->suburidecodebin = gst_object_ref (suburidecodebin);
    }

    g_object_set (suburidecodebin,
        /* configure connection speed */
        "connection-speed", playbin->connection_speed,
        /* configure uri */
        "uri", group->suburi, NULL);

    /* connect pads and other things */
    group->sub_pad_added_id = g_signal_connect (suburidecodebin, "pad-added",
        G_CALLBACK (pad_added_cb), group);
    group->sub_pad_removed_id = g_signal_connect (suburidecodebin,
        "pad-removed", G_CALLBACK (pad_removed_cb), group);
    group->sub_no_more_pads_id = g_signal_connect (suburidecodebin,
        "no-more-pads", G_CALLBACK (no_more_pads_cb), group);

    group->sub_autoplug_continue_id =
        g_signal_connect (suburidecodebin, "autoplug-continue",
        G_CALLBACK (autoplug_continue_cb), group);

    group->sub_autoplug_query_id =
        g_signal_connect (suburidecodebin, "autoplug-query",
        G_CALLBACK (autoplug_query_cb), group);

    /* we have 2 pending no-more-pads */
    group->pending = 2;
    group->sub_pending = TRUE;
  } else {
    group->sub_pending = FALSE;
  }

  /* release the group lock before setting the state of the decodebins, they
   * might fire signals in this thread that we need to handle with the
   * group_lock taken. */
  GST_SOURCE_GROUP_UNLOCK (group);

  if (suburidecodebin) {
    if (gst_element_set_state (suburidecodebin,
            target) == GST_STATE_CHANGE_FAILURE) {
      GST_DEBUG_OBJECT (playbin,
          "failed state change of subtitle uridecodebin");
      GST_SOURCE_GROUP_LOCK (group);

      REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_added_id);
      REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_removed_id);
      REMOVE_SIGNAL (group->suburidecodebin, group->sub_no_more_pads_id);
      REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_continue_id);
      REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_query_id);
      /* Might already be removed because of an error message */
      if (GST_OBJECT_PARENT (suburidecodebin) == GST_OBJECT_CAST (playbin))
        gst_bin_remove (GST_BIN_CAST (playbin), suburidecodebin);
      if (group->sub_pending) {
        group->pending--;
        group->sub_pending = FALSE;
      }
      gst_element_set_state (suburidecodebin, GST_STATE_READY);
      GST_SOURCE_GROUP_UNLOCK (group);
    }
  }
  if (gst_element_set_state (uridecodebin, target) == GST_STATE_CHANGE_FAILURE)
    goto uridecodebin_failure;

  GST_SOURCE_GROUP_LOCK (group);
  /* alow state changes of the playbin affect the group elements now */
  group_set_locked_state_unlocked (playbin, group, FALSE);
  group->active = TRUE;
  GST_SOURCE_GROUP_UNLOCK (group);

  return TRUE;

  /* ERRORS */
no_decodebin:
  {
    GstMessage *msg;

    GST_SOURCE_GROUP_UNLOCK (group);
    msg =
        gst_missing_element_message_new (GST_ELEMENT_CAST (playbin),
        "uridecodebin");
    gst_element_post_message (GST_ELEMENT_CAST (playbin), msg);

    GST_ELEMENT_ERROR (playbin, CORE, MISSING_PLUGIN,
        (_("Could not create \"uridecodebin\" element.")), (NULL));

    GST_SOURCE_GROUP_LOCK (group);

    goto error_cleanup;
  }
uridecodebin_failure:
  {
    GST_DEBUG_OBJECT (playbin, "failed state change of uridecodebin");
    goto error_cleanup;
  }
sink_failure:
  {
    GST_ERROR_OBJECT (playbin, "failed to activate sinks");
    goto error_cleanup;
  }

error_cleanup:
  {
    /* delete any custom sinks we might have */
    if (group->audio_sink) {
      /* If this is a automatically created sink set it to NULL */
      if (audio_sink_activated)
        gst_element_set_state (group->audio_sink, GST_STATE_NULL);
      gst_object_unref (group->audio_sink);
    }
    group->audio_sink = NULL;

    if (group->video_sink) {
      /* If this is a automatically created sink set it to NULL */
      if (video_sink_activated)
        gst_element_set_state (group->video_sink, GST_STATE_NULL);
      gst_object_unref (group->video_sink);
    }
    group->video_sink = NULL;

    if (group->text_sink) {
      /* If this is a automatically created sink set it to NULL */
      if (text_sink_activated)
        gst_element_set_state (group->text_sink, GST_STATE_NULL);
      gst_object_unref (group->text_sink);
    }
    group->text_sink = NULL;

    if (uridecodebin) {
      gst_element_set_state (uridecodebin, GST_STATE_NULL);
      gst_bin_remove (GST_BIN_CAST (playbin), uridecodebin);
    }

    GST_SOURCE_GROUP_UNLOCK (group);

    return FALSE;
  }
}

/* unlink a group of uridecodebins from the sink.
 * must be called with PLAY_BIN_LOCK */
static gboolean
deactivate_group (GstPlayBin * playbin, GstSourceGroup * group)
{
  gint i;

  g_return_val_if_fail (group->valid, FALSE);
  g_return_val_if_fail (group->active, FALSE);

  GST_DEBUG_OBJECT (playbin, "unlinking group %p", group);

  GST_SOURCE_GROUP_LOCK (group);
  group->active = FALSE;
  for (i = 0; i < PLAYBIN_STREAM_LAST; i++) {
    GstSourceCombine *combine = &group->combiner[i];

    GST_DEBUG_OBJECT (playbin, "unlinking combiner %s", combine->media_list[0]);

    if (combine->srcpad) {
      if (combine->sinkpad) {
        GST_LOG_OBJECT (playbin, "unlinking from sink");
        gst_pad_unlink (combine->srcpad, combine->sinkpad);

        /* release back */
        GST_LOG_OBJECT (playbin, "release sink pad");
        gst_play_sink_release_pad (playbin->playsink, combine->sinkpad);
        gst_object_unref (combine->sinkpad);
        combine->sinkpad = NULL;
      }

      gst_object_unref (combine->srcpad);
      combine->srcpad = NULL;
    }

    if (combine->combiner) {
      gint n;

      /* release and unref requests pad from the combiner */
      for (n = 0; n < combine->channels->len; n++) {
        GstPad *sinkpad = g_ptr_array_index (combine->channels, n);

        gst_element_release_request_pad (combine->combiner, sinkpad);
        gst_object_unref (sinkpad);
      }
      g_ptr_array_set_size (combine->channels, 0);

      gst_element_set_state (combine->combiner, GST_STATE_NULL);
      gst_bin_remove (GST_BIN_CAST (playbin), combine->combiner);
      combine->combiner = NULL;
    }
  }
  /* delete any custom sinks we might have.
   * conditionally set them to null if they aren't inside playsink yet */
  if (group->audio_sink) {
    if (!gst_object_has_ancestor (GST_OBJECT_CAST (group->audio_sink),
            GST_OBJECT_CAST (playbin->playsink))) {
      gst_element_set_state (group->audio_sink, GST_STATE_NULL);
    }
    gst_object_unref (group->audio_sink);
  }
  group->audio_sink = NULL;
  if (group->video_sink) {
    if (!gst_object_has_ancestor (GST_OBJECT_CAST (group->video_sink),
            GST_OBJECT_CAST (playbin->playsink))) {
      gst_element_set_state (group->video_sink, GST_STATE_NULL);
    }
    gst_object_unref (group->video_sink);
  }
  group->video_sink = NULL;
  if (group->text_sink) {
    if (!gst_object_has_ancestor (GST_OBJECT_CAST (group->text_sink),
            GST_OBJECT_CAST (playbin->playsink))) {
      gst_element_set_state (group->text_sink, GST_STATE_NULL);
    }
    gst_object_unref (group->text_sink);
  }
  group->text_sink = NULL;

  if (group->uridecodebin) {
    REMOVE_SIGNAL (group->uridecodebin, group->pad_added_id);
    REMOVE_SIGNAL (group->uridecodebin, group->pad_removed_id);
    REMOVE_SIGNAL (group->uridecodebin, group->no_more_pads_id);
    REMOVE_SIGNAL (group->uridecodebin, group->notify_source_id);
    REMOVE_SIGNAL (group->uridecodebin, group->drained_id);
    REMOVE_SIGNAL (group->uridecodebin, group->autoplug_factories_id);
    REMOVE_SIGNAL (group->uridecodebin, group->autoplug_select_id);
    REMOVE_SIGNAL (group->uridecodebin, group->autoplug_continue_id);
    REMOVE_SIGNAL (group->uridecodebin, group->autoplug_query_id);
    gst_bin_remove (GST_BIN_CAST (playbin), group->uridecodebin);
  }

  if (group->suburidecodebin) {
    REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_added_id);
    REMOVE_SIGNAL (group->suburidecodebin, group->sub_pad_removed_id);
    REMOVE_SIGNAL (group->suburidecodebin, group->sub_no_more_pads_id);
    REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_continue_id);
    REMOVE_SIGNAL (group->suburidecodebin, group->sub_autoplug_query_id);

    /* Might already be removed because of errors */
    if (GST_OBJECT_PARENT (group->suburidecodebin) == GST_OBJECT_CAST (playbin))
      gst_bin_remove (GST_BIN_CAST (playbin), group->suburidecodebin);
  }

  group->have_group_id = FALSE;

  GST_SOURCE_GROUP_UNLOCK (group);

  return TRUE;
}

/* setup the next group to play, this assumes the next_group is valid and
 * configured. It swaps out the current_group and activates the valid
 * next_group. */
static gboolean
setup_next_source (GstPlayBin * playbin, GstState target)
{
  GstSourceGroup *new_group, *old_group;

  GST_DEBUG_OBJECT (playbin, "setup sources");

  /* see if there is a next group */
  GST_PLAY_BIN_LOCK (playbin);
  new_group = playbin->next_group;
  if (!new_group || !new_group->valid)
    goto no_next_group;

  new_group->stream_changed_pending = TRUE;

  /* first unlink the current source, if any */
  old_group = playbin->curr_group;
  if (old_group && old_group->valid && old_group->active) {
    gst_play_bin_update_cached_duration (playbin);
    /* unlink our pads with the sink */
    deactivate_group (playbin, old_group);
    old_group->valid = FALSE;
  }

  /* swap old and new */
  playbin->curr_group = new_group;
  playbin->next_group = old_group;

  /* activate the new group */
  if (!activate_group (playbin, new_group, target))
    goto activate_failed;

  GST_PLAY_BIN_UNLOCK (playbin);

  return TRUE;

  /* ERRORS */
no_next_group:
  {
    GST_DEBUG_OBJECT (playbin, "no next group");
    if (target == GST_STATE_READY && new_group && new_group->uri == NULL)
      GST_ELEMENT_ERROR (playbin, RESOURCE, NOT_FOUND, ("No URI set"), (NULL));
    GST_PLAY_BIN_UNLOCK (playbin);
    return FALSE;
  }
activate_failed:
  {
    new_group->stream_changed_pending = FALSE;
    GST_DEBUG_OBJECT (playbin, "activate failed");
    GST_PLAY_BIN_UNLOCK (playbin);
    return FALSE;
  }
}

/* The group that is currently playing is copied again to the
 * next_group so that it will start playing the next time.
 */
static gboolean
save_current_group (GstPlayBin * playbin)
{
  GstSourceGroup *curr_group;

  GST_DEBUG_OBJECT (playbin, "save current group");

  /* see if there is a current group */
  GST_PLAY_BIN_LOCK (playbin);
  curr_group = playbin->curr_group;
  if (curr_group && curr_group->valid && curr_group->active) {
    /* unlink our pads with the sink */
    deactivate_group (playbin, curr_group);
  }
  /* swap old and new */
  playbin->curr_group = playbin->next_group;
  playbin->next_group = curr_group;
  GST_PLAY_BIN_UNLOCK (playbin);

  return TRUE;
}

/* clear the locked state from all groups. This function is called before a
 * state change to NULL is performed on them. */
static gboolean
groups_set_locked_state (GstPlayBin * playbin, gboolean locked)
{
  GST_DEBUG_OBJECT (playbin, "setting locked state to %d on all groups",
      locked);

  GST_PLAY_BIN_LOCK (playbin);
  GST_SOURCE_GROUP_LOCK (playbin->curr_group);
  group_set_locked_state_unlocked (playbin, playbin->curr_group, locked);
  GST_SOURCE_GROUP_UNLOCK (playbin->curr_group);
  GST_SOURCE_GROUP_LOCK (playbin->next_group);
  group_set_locked_state_unlocked (playbin, playbin->next_group, locked);
  GST_SOURCE_GROUP_UNLOCK (playbin->next_group);
  GST_PLAY_BIN_UNLOCK (playbin);

  return TRUE;
}

static GstStateChangeReturn
gst_play_bin_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstPlayBin *playbin;
  gboolean do_save = FALSE;

  playbin = GST_PLAY_BIN (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      memset (&playbin->duration, 0, sizeof (playbin->duration));
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_LOG_OBJECT (playbin, "clearing shutdown flag");
      memset (&playbin->duration, 0, sizeof (playbin->duration));
      g_atomic_int_set (&playbin->shutdown, 0);

      if (!setup_next_source (playbin, GST_STATE_READY)) {
        ret = GST_STATE_CHANGE_FAILURE;
        goto failure;
      }
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
    async_down:
      /* FIXME unlock our waiting groups */
      GST_LOG_OBJECT (playbin, "setting shutdown flag");
      g_atomic_int_set (&playbin->shutdown, 1);
      memset (&playbin->duration, 0, sizeof (playbin->duration));

      /* wait for all callbacks to end by taking the lock.
       * No dynamic (critical) new callbacks will
       * be able to happen as we set the shutdown flag. */
      GST_PLAY_BIN_DYN_LOCK (playbin);
      GST_LOG_OBJECT (playbin, "dynamic lock taken, we can continue shutdown");
      GST_PLAY_BIN_DYN_UNLOCK (playbin);
      if (!do_save)
        break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      /* we go async to PAUSED, so if that fails, we never make it to PAUSED
       * an no state change PAUSED to READY passes here,
       * though it is a nice-to-have ... */
      if (!g_atomic_int_get (&playbin->shutdown)) {
        do_save = TRUE;
        goto async_down;
      }
      memset (&playbin->duration, 0, sizeof (playbin->duration));

      /* unlock so that all groups go to NULL */
      groups_set_locked_state (playbin, FALSE);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
  if (ret == GST_STATE_CHANGE_FAILURE)
    goto failure;

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      /* FIXME Release audio device when we implement that */
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      save_current_group (playbin);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
    {
      guint i;
      GList *l;

      /* also do missed state change down to READY */
      if (do_save)
        save_current_group (playbin);
      /* Deactive the groups, set the uridecodebins to NULL
       * and unref them.
       */
      for (i = 0; i < 2; i++) {
        if (playbin->groups[i].active && playbin->groups[i].valid) {
          deactivate_group (playbin, &playbin->groups[i]);
          playbin->groups[i].valid = FALSE;
        }

        if (playbin->groups[i].uridecodebin) {
          gst_element_set_state (playbin->groups[i].uridecodebin,
              GST_STATE_NULL);
          gst_object_unref (playbin->groups[i].uridecodebin);
          playbin->groups[i].uridecodebin = NULL;
        }

        if (playbin->groups[i].suburidecodebin) {
          gst_element_set_state (playbin->groups[i].suburidecodebin,
              GST_STATE_NULL);
          gst_object_unref (playbin->groups[i].suburidecodebin);
          playbin->groups[i].suburidecodebin = NULL;
        }
      }

      /* Set our sinks back to NULL, they might not be child of playbin */
      if (playbin->audio_sink)
        gst_element_set_state (playbin->audio_sink, GST_STATE_NULL);
      if (playbin->video_sink)
        gst_element_set_state (playbin->video_sink, GST_STATE_NULL);
      if (playbin->text_sink)
        gst_element_set_state (playbin->text_sink, GST_STATE_NULL);

      if (playbin->video_stream_combiner)
        gst_element_set_state (playbin->video_stream_combiner, GST_STATE_NULL);
      if (playbin->audio_stream_combiner)
        gst_element_set_state (playbin->audio_stream_combiner, GST_STATE_NULL);
      if (playbin->text_stream_combiner)
        gst_element_set_state (playbin->text_stream_combiner, GST_STATE_NULL);

      /* make sure the groups don't perform a state change anymore until we
       * enable them again */
      groups_set_locked_state (playbin, TRUE);

      /* Remove all non-persistent contexts */
      GST_OBJECT_LOCK (playbin);
      for (l = playbin->contexts; l;) {
        GstContext *context = l->data;

        if (!gst_context_is_persistent (context)) {
          GList *next;

          gst_context_unref (context);

          next = l->next;
          playbin->contexts = g_list_delete_link (playbin->contexts, l);
          l = next;
        } else {
          l = l->next;
        }
      }

      if (playbin->source) {
        gst_object_unref (playbin->source);
        playbin->source = NULL;
      }

      GST_OBJECT_UNLOCK (playbin);
      break;
    }
    default:
      break;
  }

  return ret;

  /* ERRORS */
failure:
  {
    if (transition == GST_STATE_CHANGE_READY_TO_PAUSED) {
      GstSourceGroup *curr_group;

      curr_group = playbin->curr_group;
      if (curr_group && curr_group->active && curr_group->valid) {
        /* unlink our pads with the sink */
        deactivate_group (playbin, curr_group);
        curr_group->valid = FALSE;
      }

      /* Swap current and next group back */
      playbin->curr_group = playbin->next_group;
      playbin->next_group = curr_group;
    }
    return ret;
  }
}

static void
gst_play_bin_overlay_expose (GstVideoOverlay * overlay)
{
  GstPlayBin *playbin = GST_PLAY_BIN (overlay);

  gst_video_overlay_expose (GST_VIDEO_OVERLAY (playbin->playsink));
}

static void
gst_play_bin_overlay_handle_events (GstVideoOverlay * overlay,
    gboolean handle_events)
{
  GstPlayBin *playbin = GST_PLAY_BIN (overlay);

  gst_video_overlay_handle_events (GST_VIDEO_OVERLAY (playbin->playsink),
      handle_events);
}

static void
gst_play_bin_overlay_set_render_rectangle (GstVideoOverlay * overlay, gint x,
    gint y, gint width, gint height)
{
  GstPlayBin *playbin = GST_PLAY_BIN (overlay);

  gst_video_overlay_set_render_rectangle (GST_VIDEO_OVERLAY (playbin->playsink),
      x, y, width, height);
}

static void
gst_play_bin_overlay_set_window_handle (GstVideoOverlay * overlay,
    guintptr handle)
{
  GstPlayBin *playbin = GST_PLAY_BIN (overlay);

  gst_video_overlay_set_window_handle (GST_VIDEO_OVERLAY (playbin->playsink),
      handle);
}

static void
gst_play_bin_overlay_init (gpointer g_iface, gpointer g_iface_data)
{
  GstVideoOverlayInterface *iface = (GstVideoOverlayInterface *) g_iface;
  iface->expose = gst_play_bin_overlay_expose;
  iface->handle_events = gst_play_bin_overlay_handle_events;
  iface->set_render_rectangle = gst_play_bin_overlay_set_render_rectangle;
  iface->set_window_handle = gst_play_bin_overlay_set_window_handle;
}

static void
gst_play_bin_navigation_send_event (GstNavigation * navigation,
    GstStructure * structure)
{
  GstPlayBin *playbin = GST_PLAY_BIN (navigation);

  gst_navigation_send_event (GST_NAVIGATION (playbin->playsink), structure);
}

static void
gst_play_bin_navigation_init (gpointer g_iface, gpointer g_iface_data)
{
  GstNavigationInterface *iface = (GstNavigationInterface *) g_iface;

  iface->send_event = gst_play_bin_navigation_send_event;
}

static const GList *
gst_play_bin_colorbalance_list_channels (GstColorBalance * balance)
{
  GstPlayBin *playbin = GST_PLAY_BIN (balance);

  return
      gst_color_balance_list_channels (GST_COLOR_BALANCE (playbin->playsink));
}

static void
gst_play_bin_colorbalance_set_value (GstColorBalance * balance,
    GstColorBalanceChannel * channel, gint value)
{
  GstPlayBin *playbin = GST_PLAY_BIN (balance);

  gst_color_balance_set_value (GST_COLOR_BALANCE (playbin->playsink), channel,
      value);
}

static gint
gst_play_bin_colorbalance_get_value (GstColorBalance * balance,
    GstColorBalanceChannel * channel)
{
  GstPlayBin *playbin = GST_PLAY_BIN (balance);

  return gst_color_balance_get_value (GST_COLOR_BALANCE (playbin->playsink),
      channel);
}

static GstColorBalanceType
gst_play_bin_colorbalance_get_balance_type (GstColorBalance * balance)
{
  GstPlayBin *playbin = GST_PLAY_BIN (balance);

  return
      gst_color_balance_get_balance_type (GST_COLOR_BALANCE
      (playbin->playsink));
}

static void
gst_play_bin_colorbalance_init (gpointer g_iface, gpointer g_iface_data)
{
  GstColorBalanceInterface *iface = (GstColorBalanceInterface *) g_iface;

  iface->list_channels = gst_play_bin_colorbalance_list_channels;
  iface->set_value = gst_play_bin_colorbalance_set_value;
  iface->get_value = gst_play_bin_colorbalance_get_value;
  iface->get_balance_type = gst_play_bin_colorbalance_get_balance_type;
}

gboolean
gst_play_bin2_plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (gst_play_bin_debug, "playbin", 0, "play bin");

  return gst_element_register (plugin, "playbin", GST_RANK_NONE,
      GST_TYPE_PLAY_BIN);
}
