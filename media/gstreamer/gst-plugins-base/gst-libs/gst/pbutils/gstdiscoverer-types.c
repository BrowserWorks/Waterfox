/* GStreamer
 * Copyright (C) 2010 Collabora Multimedia
 *               2010 Nokia Corporation
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "pbutils.h"
#include "pbutils-private.h"

static GstDiscovererStreamInfo
    * gst_discoverer_info_copy_int (GstDiscovererStreamInfo * info,
    GHashTable * stream_map);

static GstDiscovererContainerInfo
    * gst_stream_container_info_copy_int (GstDiscovererContainerInfo * ptr,
    GHashTable * stream_map);

static GstDiscovererAudioInfo
    * gst_discoverer_audio_info_copy_int (GstDiscovererAudioInfo * ptr);

static GstDiscovererVideoInfo
    * gst_discoverer_video_info_copy_int (GstDiscovererVideoInfo * ptr);

static GstDiscovererSubtitleInfo
    * gst_discoverer_subtitle_info_copy_int (GstDiscovererSubtitleInfo * ptr);

/* Per-stream information */

G_DEFINE_TYPE (GstDiscovererStreamInfo, gst_discoverer_stream_info,
    G_TYPE_OBJECT);

static void
gst_discoverer_stream_info_init (GstDiscovererStreamInfo * info)
{
  /* Nothing needs initialization */
}

static void
gst_discoverer_stream_info_finalize (GObject * object)
{
  GstDiscovererStreamInfo *info = (GstDiscovererStreamInfo *) object;

  if (info->next)
    g_object_unref ((GObject *) info->next);

  if (info->caps)
    gst_caps_unref (info->caps);

  if (info->tags)
    gst_tag_list_unref (info->tags);

  if (info->toc)
    gst_toc_unref (info->toc);

  g_free (info->stream_id);

  if (info->misc)
    gst_structure_free (info->misc);
}

static void
gst_discoverer_stream_info_class_init (GObjectClass * klass)
{
  klass->finalize = gst_discoverer_stream_info_finalize;
}

static GstDiscovererStreamInfo *
gst_discoverer_stream_info_new (void)
{
  return (GstDiscovererStreamInfo *)
      g_object_new (GST_TYPE_DISCOVERER_STREAM_INFO, NULL);
}

static GstDiscovererStreamInfo *
gst_discoverer_info_copy_int (GstDiscovererStreamInfo * info,
    GHashTable * stream_map)
{
  GstDiscovererStreamInfo *ret;
  GType ltyp;

  g_return_val_if_fail (info != NULL, NULL);

  ltyp = G_TYPE_FROM_INSTANCE (info);

  if (ltyp == GST_TYPE_DISCOVERER_CONTAINER_INFO) {
    ret = (GstDiscovererStreamInfo *)
        gst_stream_container_info_copy_int (
        (GstDiscovererContainerInfo *) info, stream_map);
  } else if (ltyp == GST_TYPE_DISCOVERER_AUDIO_INFO) {
    ret = (GstDiscovererStreamInfo *)
        gst_discoverer_audio_info_copy_int ((GstDiscovererAudioInfo *) info);

  } else if (ltyp == GST_TYPE_DISCOVERER_VIDEO_INFO) {
    ret = (GstDiscovererStreamInfo *)
        gst_discoverer_video_info_copy_int ((GstDiscovererVideoInfo *) info);

  } else if (ltyp == GST_TYPE_DISCOVERER_SUBTITLE_INFO) {
    ret = (GstDiscovererStreamInfo *)
        gst_discoverer_subtitle_info_copy_int ((GstDiscovererSubtitleInfo *)
        info);

  } else
    ret = gst_discoverer_stream_info_new ();

  if (info->next) {
    ret->next = gst_discoverer_info_copy_int (info->next, stream_map);
    ret->next->previous = ret;
  }

  if (info->caps)
    ret->caps = gst_caps_copy (info->caps);

  if (info->tags)
    ret->tags = gst_tag_list_copy (info->tags);

  if (info->toc)
    ret->toc = gst_toc_ref (info->toc);

  if (info->stream_id)
    ret->stream_id = g_strdup (info->stream_id);

  if (info->misc)
    ret->misc = gst_structure_copy (info->misc);

  if (stream_map)
    g_hash_table_insert (stream_map, info, ret);

  return ret;
}

/* Container information */
G_DEFINE_TYPE (GstDiscovererContainerInfo, gst_discoverer_container_info,
    GST_TYPE_DISCOVERER_STREAM_INFO);

static void
gst_discoverer_container_info_init (GstDiscovererContainerInfo * info)
{
  /* Nothing to initialize */
}

static GstDiscovererContainerInfo *
gst_discoverer_container_info_new (void)
{
  return (GstDiscovererContainerInfo *)
      g_object_new (GST_TYPE_DISCOVERER_CONTAINER_INFO, NULL);
}

static void
gst_discoverer_container_info_finalize (GObject * object)
{
  GstDiscovererContainerInfo *info = (GstDiscovererContainerInfo *) object;
  GList *tmp;

  for (tmp = ((GstDiscovererContainerInfo *) info)->streams; tmp;
      tmp = tmp->next)
    g_object_unref ((GObject *) tmp->data);

  gst_discoverer_stream_info_list_free (info->streams);

  gst_discoverer_stream_info_finalize ((GObject *) info);
}

static void
gst_discoverer_container_info_class_init (GObjectClass * klass)
{
  klass->finalize = gst_discoverer_container_info_finalize;
}

static GstDiscovererContainerInfo *
gst_stream_container_info_copy_int (GstDiscovererContainerInfo * ptr,
    GHashTable * stream_map)
{
  GstDiscovererContainerInfo *ret;
  GList *tmp;

  g_return_val_if_fail (ptr != NULL, NULL);

  ret = gst_discoverer_container_info_new ();

  for (tmp = ((GstDiscovererContainerInfo *) ptr)->streams; tmp;
      tmp = tmp->next) {
    GstDiscovererStreamInfo *subtop = gst_discoverer_info_copy_int (tmp->data,
        stream_map);
    ret->streams = g_list_append (ret->streams, subtop);
    if (stream_map)
      g_hash_table_insert (stream_map, tmp->data, subtop);
  }

  return ret;
}

/* Audio information */
G_DEFINE_TYPE (GstDiscovererAudioInfo, gst_discoverer_audio_info,
    GST_TYPE_DISCOVERER_STREAM_INFO);

static void
gst_discoverer_audio_info_finalize (GObject * object)
{
  GstDiscovererAudioInfo *info = (GstDiscovererAudioInfo *) object;

  g_free (info->language);

  G_OBJECT_CLASS (gst_discoverer_audio_info_parent_class)->finalize (object);
}

static void
gst_discoverer_audio_info_class_init (GObjectClass * klass)
{
  klass->finalize = gst_discoverer_audio_info_finalize;
}

static void
gst_discoverer_audio_info_init (GstDiscovererAudioInfo * info)
{
  info->language = NULL;
}

static GstDiscovererAudioInfo *
gst_discoverer_audio_info_new (void)
{
  return (GstDiscovererAudioInfo *)
      g_object_new (GST_TYPE_DISCOVERER_AUDIO_INFO, NULL);
}

static GstDiscovererAudioInfo *
gst_discoverer_audio_info_copy_int (GstDiscovererAudioInfo * ptr)
{
  GstDiscovererAudioInfo *ret;

  ret = gst_discoverer_audio_info_new ();

  ret->channels = ptr->channels;
  ret->sample_rate = ptr->sample_rate;
  ret->depth = ptr->depth;
  ret->bitrate = ptr->bitrate;
  ret->max_bitrate = ptr->max_bitrate;
  ret->language = g_strdup (ptr->language);

  return ret;
}

/* Subtitle information */
G_DEFINE_TYPE (GstDiscovererSubtitleInfo, gst_discoverer_subtitle_info,
    GST_TYPE_DISCOVERER_STREAM_INFO);

static void
gst_discoverer_subtitle_info_init (GstDiscovererSubtitleInfo * info)
{
  info->language = NULL;
}

static void
gst_discoverer_subtitle_info_finalize (GObject * object)
{
  GstDiscovererSubtitleInfo *info = (GstDiscovererSubtitleInfo *) object;

  g_free (info->language);

  G_OBJECT_CLASS (gst_discoverer_subtitle_info_parent_class)->finalize (object);
}

static void
gst_discoverer_subtitle_info_class_init (GObjectClass * klass)
{
  klass->finalize = gst_discoverer_subtitle_info_finalize;
}

static GstDiscovererSubtitleInfo *
gst_discoverer_subtitle_info_new (void)
{
  return (GstDiscovererSubtitleInfo *)
      g_object_new (GST_TYPE_DISCOVERER_SUBTITLE_INFO, NULL);
}

static GstDiscovererSubtitleInfo *
gst_discoverer_subtitle_info_copy_int (GstDiscovererSubtitleInfo * ptr)
{
  GstDiscovererSubtitleInfo *ret;

  ret = gst_discoverer_subtitle_info_new ();

  ret->language = g_strdup (ptr->language);

  return ret;
}

/* Video information */
G_DEFINE_TYPE (GstDiscovererVideoInfo, gst_discoverer_video_info,
    GST_TYPE_DISCOVERER_STREAM_INFO);

static void
gst_discoverer_video_info_class_init (GObjectClass * klass)
{
  /* Nothing to initialize */
}

static void
gst_discoverer_video_info_init (GstDiscovererVideoInfo * info)
{
  /* Nothing to initialize */
}

static GstDiscovererVideoInfo *
gst_discoverer_video_info_new (void)
{
  return (GstDiscovererVideoInfo *)
      g_object_new (GST_TYPE_DISCOVERER_VIDEO_INFO, NULL);
}

static GstDiscovererVideoInfo *
gst_discoverer_video_info_copy_int (GstDiscovererVideoInfo * ptr)
{
  GstDiscovererVideoInfo *ret;

  ret = gst_discoverer_video_info_new ();

  ret->width = ptr->width;
  ret->height = ptr->height;
  ret->depth = ptr->depth;
  ret->framerate_num = ptr->framerate_num;
  ret->framerate_denom = ptr->framerate_denom;
  ret->par_num = ptr->par_num;
  ret->par_denom = ptr->par_denom;
  ret->interlaced = ptr->interlaced;
  ret->bitrate = ptr->bitrate;
  ret->max_bitrate = ptr->max_bitrate;
  ret->is_image = ptr->is_image;

  return ret;
}

/* Global stream information */
G_DEFINE_TYPE (GstDiscovererInfo, gst_discoverer_info, G_TYPE_OBJECT);

static void
gst_discoverer_info_init (GstDiscovererInfo * info)
{
  info->missing_elements_details = g_ptr_array_new_with_free_func (g_free);
}

static void
gst_discoverer_info_finalize (GObject * object)
{
  GstDiscovererInfo *info = (GstDiscovererInfo *) object;
  g_free (info->uri);

  if (info->stream_info)
    g_object_unref ((GObject *) info->stream_info);

  if (info->misc)
    gst_structure_free (info->misc);

  g_list_free (info->stream_list);

  if (info->tags)
    gst_tag_list_unref (info->tags);

  if (info->toc)
    gst_toc_unref (info->toc);

  g_ptr_array_unref (info->missing_elements_details);
}

static GstDiscovererInfo *
gst_discoverer_info_new (void)
{
  return (GstDiscovererInfo *) g_object_new (GST_TYPE_DISCOVERER_INFO, NULL);
}

/**
 * gst_discoverer_info_copy:
 * @ptr: (transfer none): a #GstDiscovererInfo
 *
 * Returns: (transfer full): A copy of the #GstDiscovererInfo
 */
GstDiscovererInfo *
gst_discoverer_info_copy (GstDiscovererInfo * ptr)
{
  GstDiscovererInfo *ret;
  GHashTable *stream_map;
  GList *tmp;

  g_return_val_if_fail (ptr != NULL, NULL);

  stream_map = g_hash_table_new (g_direct_hash, NULL);

  ret = gst_discoverer_info_new ();

  ret->uri = g_strdup (ptr->uri);
  if (ptr->stream_info) {
    ret->stream_info = gst_discoverer_info_copy_int (ptr->stream_info,
        stream_map);
  }
  ret->duration = ptr->duration;
  if (ptr->misc)
    ret->misc = gst_structure_copy (ptr->misc);

  /* We need to set up the new list of streams to correspond to old one. The
   * list just contains a set of pointers to streams in the stream_info tree,
   * so we keep a map of old stream info objects to the corresponding new
   * ones and use that to figure out correspondence in stream_list. */
  for (tmp = ptr->stream_list; tmp; tmp = tmp->next) {
    GstDiscovererStreamInfo *old_stream = (GstDiscovererStreamInfo *) tmp->data;
    GstDiscovererStreamInfo *new_stream = g_hash_table_lookup (stream_map,
        old_stream);
    g_assert (new_stream != NULL);
    ret->stream_list = g_list_append (ret->stream_list, new_stream);
  }

  if (ptr->tags)
    ret->tags = gst_tag_list_copy (ptr->tags);

  if (ptr->toc)
    ret->toc = gst_toc_ref (ptr->toc);

  g_hash_table_destroy (stream_map);
  return ret;
}

static void
gst_discoverer_info_class_init (GObjectClass * klass)
{
  klass->finalize = gst_discoverer_info_finalize;
}

/**
 * gst_discoverer_stream_info_list_free:
 * @infos: (element-type GstPbutils.DiscovererStreamInfo): a #GList of #GstDiscovererStreamInfo
 *
 * Decrements the reference count of all contained #GstDiscovererStreamInfo
 * and fress the #GList.
 */
void
gst_discoverer_stream_info_list_free (GList * infos)
{
  GList *tmp;

  for (tmp = infos; tmp; tmp = tmp->next)
    gst_discoverer_stream_info_unref ((GstDiscovererStreamInfo *) tmp->data);
  g_list_free (infos);
}

/**
 * gst_discoverer_info_get_streams:
 * @info: a #GstDiscovererInfo
 * @streamtype: a #GType derived from #GstDiscovererStreamInfo
 *
 * Finds the #GstDiscovererStreamInfo contained in @info that match the
 * given @streamtype.
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): A #GList of
 * matching #GstDiscovererStreamInfo. The caller should free it with
 * gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_streams (GstDiscovererInfo * info, GType streamtype)
{
  GList *tmp, *res = NULL;

  for (tmp = info->stream_list; tmp; tmp = tmp->next) {
    GstDiscovererStreamInfo *stmp = (GstDiscovererStreamInfo *) tmp->data;

    if (G_TYPE_CHECK_INSTANCE_TYPE (stmp, streamtype))
      res = g_list_append (res, gst_discoverer_stream_info_ref (stmp));
  }

  return res;
}

/**
 * gst_discoverer_info_get_audio_streams:
 * @info: a #GstDiscovererInfo
 *
 * Finds all the #GstDiscovererAudioInfo contained in @info
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): A #GList of
 * matching #GstDiscovererStreamInfo. The caller should free it with
 * gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_audio_streams (GstDiscovererInfo * info)
{
  return gst_discoverer_info_get_streams (info, GST_TYPE_DISCOVERER_AUDIO_INFO);
}

/**
 * gst_discoverer_info_get_video_streams:
 * @info: a #GstDiscovererInfo
 *
 * Finds all the #GstDiscovererVideoInfo contained in @info
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): A #GList of
 * matching #GstDiscovererStreamInfo. The caller should free it with
 * gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_video_streams (GstDiscovererInfo * info)
{
  return gst_discoverer_info_get_streams (info, GST_TYPE_DISCOVERER_VIDEO_INFO);
}

/**
 * gst_discoverer_info_get_subtitle_streams:
 * @info: a #GstDiscovererInfo
 *
 * Finds all the #GstDiscovererSubtitleInfo contained in @info
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): A #GList of
 * matching #GstDiscovererStreamInfo. The caller should free it with
 * gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_subtitle_streams (GstDiscovererInfo * info)
{
  return gst_discoverer_info_get_streams (info,
      GST_TYPE_DISCOVERER_SUBTITLE_INFO);
}

/**
 * gst_discoverer_info_get_container_streams:
 * @info: a #GstDiscovererInfo
 *
 * Finds all the #GstDiscovererContainerInfo contained in @info
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): A #GList of
 * matching #GstDiscovererStreamInfo. The caller should free it with
 * gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_container_streams (GstDiscovererInfo * info)
{
  return gst_discoverer_info_get_streams (info,
      GST_TYPE_DISCOVERER_CONTAINER_INFO);
}

/**
 * gst_discoverer_stream_info_get_stream_type_nick:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: a human readable name for the stream type of the given @info (ex : "audio",
 * "container",...).
 */
const gchar *
gst_discoverer_stream_info_get_stream_type_nick (GstDiscovererStreamInfo * info)
{
  if (GST_IS_DISCOVERER_CONTAINER_INFO (info))
    return "container";
  if (GST_IS_DISCOVERER_AUDIO_INFO (info))
    return "audio";
  if (GST_IS_DISCOVERER_VIDEO_INFO (info)) {
    if (gst_discoverer_video_info_is_image ((GstDiscovererVideoInfo *)
            info))
      return "video(image)";
    else
      return "video";
  }
  if (GST_IS_DISCOVERER_SUBTITLE_INFO (info))
    return "subtitles";
  return "unknown";
}

/* ACCESSORS */


#define GENERIC_ACCESSOR_CODE(parent, parenttype, parentgtype, fieldname, type, failval) \
  type parent##_get_##fieldname(const parenttype info) {			\
    g_return_val_if_fail(G_TYPE_CHECK_INSTANCE_TYPE((info), parentgtype), failval); \
    return (info)->fieldname;				\
  }

/**
 * gst_discoverer_stream_info_get_previous:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer full): the previous #GstDiscovererStreamInfo in a chain.
 * %NULL for starting points. Unref with #gst_discoverer_stream_info_unref
 * after usage.
 */
GstDiscovererStreamInfo *
gst_discoverer_stream_info_get_previous (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  if (info->previous)
    return gst_discoverer_stream_info_ref (info->previous);
  return NULL;
}

/**
 * gst_discoverer_stream_info_get_next:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer full): the next #GstDiscovererStreamInfo in a chain. %NULL
 * for final streams.
 * Unref with #gst_discoverer_stream_info_unref after usage.
 */
GstDiscovererStreamInfo *
gst_discoverer_stream_info_get_next (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  if (info->next)
    return gst_discoverer_stream_info_ref (info->next);
  return NULL;
}


/**
 * gst_discoverer_stream_info_get_caps:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer full): the #GstCaps of the stream. Unref with
 * #gst_caps_unref after usage.
 */
GstCaps *
gst_discoverer_stream_info_get_caps (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  if (info->caps)
    return gst_caps_ref (info->caps);
  return NULL;
}

/**
 * gst_discoverer_stream_info_get_tags:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer none): the tags contained in this stream. If you wish to
 * use the tags after the life-time of @info you will need to copy them.
 */
const GstTagList *
gst_discoverer_stream_info_get_tags (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  return info->tags;
}

/**
 * gst_discoverer_stream_info_get_toc:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer none): the TOC contained in this stream. If you wish to
 * use the TOC after the life-time of @info you will need to copy it.
 */
const GstToc *
gst_discoverer_stream_info_get_toc (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  return info->toc;
}

/**
 * gst_discoverer_stream_info_get_stream_id:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer none): the stream ID of this stream. If you wish to
 * use the stream ID after the life-time of @info you will need to copy it.
 */
const gchar *
gst_discoverer_stream_info_get_stream_id (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  return info->stream_id;
}

/**
 * gst_discoverer_stream_info_get_misc:
 * @info: a #GstDiscovererStreamInfo
 *
 * Deprecated: This functions is deprecated since version 1.4, use
 * gst_discoverer_stream_get_missing_elements_installer_details
 *
 * Returns: (transfer none): additional information regarding the stream (for
 * example codec version, profile, etc..). If you wish to use the #GstStructure
 * after the life-time of @info you will need to copy it.
 */
const GstStructure *
gst_discoverer_stream_info_get_misc (GstDiscovererStreamInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_STREAM_INFO (info), NULL);

  return info->misc;
}

/* GstDiscovererContainerInfo */

/**
 * gst_discoverer_container_info_get_streams:
 * @info: a #GstDiscovererStreamInfo
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): the list of
 * #GstDiscovererStreamInfo this container stream offers.
 * Free with gst_discoverer_stream_info_list_free() after usage.
 */

GList *
gst_discoverer_container_info_get_streams (GstDiscovererContainerInfo * info)
{
  GList *res = NULL, *tmp;

  g_return_val_if_fail (GST_IS_DISCOVERER_CONTAINER_INFO (info), NULL);

  for (tmp = info->streams; tmp; tmp = tmp->next)
    res =
        g_list_append (res,
        gst_discoverer_stream_info_ref ((GstDiscovererStreamInfo *) tmp->data));

  return res;
}

/* GstDiscovererAudioInfo */

#define AUDIO_INFO_ACCESSOR_CODE(fieldname, type, failval)		\
  GENERIC_ACCESSOR_CODE(gst_discoverer_audio_info, GstDiscovererAudioInfo*, \
			GST_TYPE_DISCOVERER_AUDIO_INFO,		\
			fieldname, type, failval)

/**
 * gst_discoverer_audio_info_get_channels:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the number of channels in the stream.
 */

AUDIO_INFO_ACCESSOR_CODE (channels, guint, 0);

/**
 * gst_discoverer_audio_info_get_sample_rate:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the sample rate of the stream in Hertz.
 */

AUDIO_INFO_ACCESSOR_CODE (sample_rate, guint, 0);

/**
 * gst_discoverer_audio_info_get_depth:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the number of bits used per sample in each channel.
 */

AUDIO_INFO_ACCESSOR_CODE (depth, guint, 0);

/**
 * gst_discoverer_audio_info_get_bitrate:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the average or nominal bitrate of the stream in bits/second.
 */

AUDIO_INFO_ACCESSOR_CODE (bitrate, guint, 0);

/**
 * gst_discoverer_audio_info_get_max_bitrate:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the maximum bitrate of the stream in bits/second.
 */

AUDIO_INFO_ACCESSOR_CODE (max_bitrate, guint, 0);

/**
 * gst_discoverer_audio_info_get_language:
 * @info: a #GstDiscovererAudioInfo
 *
 * Returns: the language of the stream, or NULL if unknown.
 */

AUDIO_INFO_ACCESSOR_CODE (language, const gchar *, NULL);

/* GstDiscovererVideoInfo */

#define VIDEO_INFO_ACCESSOR_CODE(fieldname, type, failval)		\
  GENERIC_ACCESSOR_CODE(gst_discoverer_video_info, GstDiscovererVideoInfo*, \
			GST_TYPE_DISCOVERER_VIDEO_INFO,			\
			fieldname, type, failval)

/**
 * gst_discoverer_video_info_get_width:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the width of the video stream in pixels.
 */

VIDEO_INFO_ACCESSOR_CODE (width, guint, 0);

/**
 * gst_discoverer_video_info_get_height:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the height of the video stream in pixels.
 */

VIDEO_INFO_ACCESSOR_CODE (height, guint, 0);

/**
 * gst_discoverer_video_info_get_depth:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the depth in bits of the video stream.
 */

VIDEO_INFO_ACCESSOR_CODE (depth, guint, 0);

/**
 * gst_discoverer_video_info_get_framerate_num:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the framerate of the video stream (numerator).
 */

VIDEO_INFO_ACCESSOR_CODE (framerate_num, guint, 0);

/**
 * gst_discoverer_video_info_get_framerate_denom:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the framerate of the video stream (denominator).
 */

VIDEO_INFO_ACCESSOR_CODE (framerate_denom, guint, 0);

/**
 * gst_discoverer_video_info_get_par_num:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the Pixel Aspect Ratio (PAR) of the video stream (numerator).
 */

VIDEO_INFO_ACCESSOR_CODE (par_num, guint, 0);

/**
 * gst_discoverer_video_info_get_par_denom:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the Pixel Aspect Ratio (PAR) of the video stream (denominator).
 */

VIDEO_INFO_ACCESSOR_CODE (par_denom, guint, 0);

/**
 * gst_discoverer_video_info_is_interlaced:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: %TRUE if the stream is interlaced, else %FALSE.
 */
gboolean
gst_discoverer_video_info_is_interlaced (const GstDiscovererVideoInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_VIDEO_INFO (info), FALSE);

  return info->interlaced;
}

/**
 * gst_discoverer_video_info_get_bitrate:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the average or nominal bitrate of the video stream in bits/second.
 */

VIDEO_INFO_ACCESSOR_CODE (bitrate, guint, 0);

/**
 * gst_discoverer_video_info_get_max_bitrate:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: the maximum bitrate of the video stream in bits/second.
 */

VIDEO_INFO_ACCESSOR_CODE (max_bitrate, guint, 0);

/**
 * gst_discoverer_video_info_is_image:
 * @info: a #GstDiscovererVideoInfo
 *
 * Returns: #TRUE if the video stream corresponds to an image (i.e. only contains
 * one frame).
 */
gboolean
gst_discoverer_video_info_is_image (const GstDiscovererVideoInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_VIDEO_INFO (info), FALSE);

  return info->is_image;
}

/* GstDiscovererSubtitleInfo */

#define SUBTITLE_INFO_ACCESSOR_CODE(fieldname, type, failval)                     \
  GENERIC_ACCESSOR_CODE(gst_discoverer_subtitle_info, GstDiscovererSubtitleInfo*, \
			GST_TYPE_DISCOVERER_SUBTITLE_INFO,                        \
			fieldname, type, failval)

/**
 * gst_discoverer_subtitle_info_get_language:
 * @info: a #GstDiscovererSubtitleInfo
 *
 * Returns: the language of the stream, or NULL if unknown.
 */

SUBTITLE_INFO_ACCESSOR_CODE (language, const gchar *, NULL);

/* GstDiscovererInfo */

#define DISCOVERER_INFO_ACCESSOR_CODE(fieldname, type, failval)		\
  GENERIC_ACCESSOR_CODE(gst_discoverer_info, GstDiscovererInfo*,	\
			GST_TYPE_DISCOVERER_INFO,			\
			fieldname, type, failval)

/**
 * gst_discoverer_info_get_uri:
 * @info: a #GstDiscovererInfo
 *
 * Returns: (transfer none): the URI to which this information corresponds to.
 * Copy it if you wish to use it after the life-time of @info.
 */

DISCOVERER_INFO_ACCESSOR_CODE (uri, const gchar *, NULL);

/**
 * gst_discoverer_info_get_result:
 * @info: a #GstDiscovererInfo
 *
 * Returns: the result of the discovery as a #GstDiscovererResult.
 */

DISCOVERER_INFO_ACCESSOR_CODE (result, GstDiscovererResult, GST_DISCOVERER_OK);

/**
 * gst_discoverer_info_get_stream_info:
 * @info: a #GstDiscovererInfo
 *
 * Returns: (transfer full): the structure (or topology) of the URI as a
 * #GstDiscovererStreamInfo.
 * This structure can be traversed to see the original hierarchy. Unref with
 * gst_discoverer_stream_info_unref() after usage.
 */

GstDiscovererStreamInfo *
gst_discoverer_info_get_stream_info (GstDiscovererInfo * info)
{
  g_return_val_if_fail (GST_IS_DISCOVERER_INFO (info), NULL);

  if (info->stream_info)
    return gst_discoverer_stream_info_ref (info->stream_info);
  return NULL;
}

/**
 * gst_discoverer_info_get_stream_list:
 * @info: a #GstDiscovererInfo
 *
 * Returns: (transfer full) (element-type GstPbutils.DiscovererStreamInfo): the list of
 * all streams contained in the #info. Free after usage
 * with gst_discoverer_stream_info_list_free().
 */
GList *
gst_discoverer_info_get_stream_list (GstDiscovererInfo * info)
{
  GList *res = NULL, *tmp;

  g_return_val_if_fail (GST_IS_DISCOVERER_INFO (info), NULL);

  for (tmp = info->stream_list; tmp; tmp = tmp->next)
    res =
        g_list_append (res,
        gst_discoverer_stream_info_ref ((GstDiscovererStreamInfo *) tmp->data));

  return res;
}

/**
 * gst_discoverer_info_get_duration:
 * @info: a #GstDiscovererInfo
 *
 * Returns: the duration of the URI in #GstClockTime (nanoseconds).
 */

DISCOVERER_INFO_ACCESSOR_CODE (duration, GstClockTime, GST_CLOCK_TIME_NONE);

/**
 * gst_discoverer_info_get_seekable:
 * @info: a #GstDiscovererInfo
 *
 * Returns: the whether the URI is seekable.
 */

DISCOVERER_INFO_ACCESSOR_CODE (seekable, gboolean, FALSE);

/**
 * gst_discoverer_info_get_misc:
 * @info: a #GstDiscovererInfo
 *
 * Deprecated: This functions is deprecated since version 1.4, use
 * gst_discoverer_info_get_missing_elements_installer_details
 *
 * Returns: (transfer none): Miscellaneous information stored as a #GstStructure
 * (for example: information about missing plugins). If you wish to use the
 * #GstStructure after the life-time of @info, you will need to copy it.
 */

DISCOVERER_INFO_ACCESSOR_CODE (misc, const GstStructure *, NULL);

/**
 * gst_discoverer_info_get_tags:
 * @info: a #GstDiscovererInfo
 *
 * Returns: (transfer none): all tags contained in the URI. If you wish to use
 * the tags after the life-time of @info, you will need to copy them.
 */

DISCOVERER_INFO_ACCESSOR_CODE (tags, const GstTagList *, NULL);

/**
 * gst_discoverer_info_get_toc:
 * @info: a #GstDiscovererInfo
 *
 * Returns: (transfer none): TOC contained in the URI. If you wish to use
 * the TOC after the life-time of @info, you will need to copy it.
 */

DISCOVERER_INFO_ACCESSOR_CODE (toc, const GstToc *, NULL);

/**
 * gst_discoverer_info_ref:
 * @info: a #GstDiscovererInfo
 *
 * Increments the reference count of @info.
 *
 * Returns: the same #GstDiscovererInfo object
 */

/**
 * gst_discoverer_info_unref:
 * @info: a #GstDiscovererInfo
 *
 * Decrements the reference count of @info.
 */

/**
 * gst_discoverer_stream_info_ref:
 * @info: a #GstDiscovererStreamInfo
 *
 * Increments the reference count of @info.
 *
 * Returns: the same #GstDiscovererStreamInfo object
 */

/**
 * gst_discoverer_stream_info_unref:
 * @info: a #GstDiscovererStreamInfo
 *
 * Decrements the reference count of @info.
 */


/**
 * gst_discoverer_info_get_missing_elements_installer_details:
 * @info: a #GstDiscovererStreamInfo to retrieve installer detail
 * for the missing element
 *
 * Get the installer details for missing elements
 *
 * Returns: (transfer full) (array zero-terminated=1): An array of strings
 * containing informations about how to install the various missing elements
 * for @info to be usable. Free with g_strfreev().
 *
 * Since: 1.4
 */
const gchar **
gst_discoverer_info_get_missing_elements_installer_details (const
    GstDiscovererInfo * info)
{

  if (info->result != GST_DISCOVERER_MISSING_PLUGINS) {
    GST_WARNING_OBJECT (info, "Trying to get missing element installed details "
        "but result is not 'MISSING_PLUGINS'");

    return NULL;
  }

  if (info->missing_elements_details->pdata[info->missing_elements_details->
          len]) {
    GST_DEBUG ("Adding NULL pointer to the end of missing_elements_details");
    g_ptr_array_add (info->missing_elements_details, NULL);
  }

  return (const gchar **) info->missing_elements_details->pdata;
}
