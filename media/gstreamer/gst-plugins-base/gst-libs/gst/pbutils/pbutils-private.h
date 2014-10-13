/* GStreamer
 * Copyright (C) 2010 Edward Hervey <edward.hervey@collabora.co.uk>
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

struct _GstDiscovererStreamInfo {
  GObject                parent;

  GstDiscovererStreamInfo *previous;  /* NULL for starting points */
  GstDiscovererStreamInfo *next; /* NULL for containers */

  GstCaps               *caps;
  GstTagList            *tags;
  GstToc                *toc;
  gchar                 *stream_id;
  GstStructure          *misc;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDiscovererContainerInfo {
  GstDiscovererStreamInfo parent;

  GList               *streams;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDiscovererAudioInfo {
  GstDiscovererStreamInfo parent;

  guint channels;
  guint sample_rate;
  guint depth;

  guint bitrate;
  guint max_bitrate;

  gchar *language;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDiscovererVideoInfo {
  GstDiscovererStreamInfo parent;

  guint width;
  guint height;
  guint depth;
  guint framerate_num;
  guint framerate_denom;
  guint par_num;
  guint par_denom;
  gboolean interlaced;

  guint bitrate;
  guint max_bitrate;

  gboolean is_image;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDiscovererSubtitleInfo {
  GstDiscovererStreamInfo parent;

  gchar *language;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDiscovererInfo {
  GObject parent;

  gchar *uri;
  GstDiscovererResult result;

  /* Sub-streams */
  GstDiscovererStreamInfo *stream_info;
  GList *stream_list;

  /* Stream global information */
  GstClockTime duration;
  GstStructure *misc;
  GstTagList *tags;
  GstToc *toc;
  gboolean seekable;
  GPtrArray *missing_elements_details;

  gpointer _gst_reserved[GST_PADDING];
};

/* missing-plugins.c */

GstCaps *copy_and_clean_caps (const GstCaps * caps);
