/*
 * GStreamer
 * Copyright (C) 2013 Fluendo S.L. <support@fluendo.com>
 *    Authors: Andoni Morales Alastruey <amorales@fluendo.com>
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __GST_AVF_ASSET_SRC_H__
#define __GST_AVF_ASSET_SRC_H__

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/base.h>
#include <gst/audio/audio.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetReader.h>
#import <AVFoundation/AVAssetReaderOutput.h>

G_BEGIN_DECLS

#define GST_TYPE_AVF_ASSET_SRC \
  (gst_avf_asset_src_get_type())
#define GST_AVF_ASSET_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AVF_ASSET_SRC,GstAVFAssetSrc))
#define GST_AVF_ASSET_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AVF_ASSET_SRC,GstAVFAssetSrcClass))
#define GST_IS_AVF_ASSET_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AVF_ASSET_SRC))
#define GST_IS_AVF_ASSET_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AVF_ASSET_SRC))
#define GST_AVF_ASSET_SRC_ERROR gst_avf_asset_src_error_quark ()

typedef struct _GstAVFAssetSrc      GstAVFAssetSrc;
typedef struct _GstAVFAssetSrcClass GstAVFAssetSrcClass;

typedef enum
{
  GST_AVF_ASSET_READER_MEDIA_TYPE_AUDIO,
  GST_AVF_ASSET_READER_MEDIA_TYPE_VIDEO,
} GstAVFAssetReaderMediaType;

typedef enum
{
  GST_AVF_ASSET_ERROR_NOT_PLAYABLE,
  GST_AVF_ASSET_ERROR_INIT,
  GST_AVF_ASSET_ERROR_START,
  GST_AVF_ASSET_ERROR_READ,
} GstAVFAssetError;

typedef enum
{
  GST_AVF_ASSET_SRC_STATE_STOPPED,
  GST_AVF_ASSET_SRC_STATE_STARTED,
  GST_AVF_ASSET_SRC_STATE_READING,
} GstAVFAssetSrcState;

@interface GstAVFAssetReader: NSObject
{
  AVAsset *asset;
  AVAssetReader *reader;
  AVAssetReaderTrackOutput *video_track;
  AVAssetReaderTrackOutput *audio_track;
  NSArray *audio_tracks;
  NSArray *video_tracks;
  int selected_audio_track;
  int selected_video_track;
  GstCaps *audio_caps;
  GstCaps *video_caps;
  gboolean reading;
  GstClockTime duration;
  GstClockTime position;
}

@property GstClockTime duration;
@property GstClockTime position;

- (id) initWithURI:(gchar*) uri : (GError **) error;
- (void) start : (GError **) error;
- (void) stop;
- (void) seekTo: (guint64) start : (guint64) stop : (GError **) error;
- (bool) hasMediaType: (GstAVFAssetReaderMediaType) type;
- (GstCaps *) getCaps: (GstAVFAssetReaderMediaType) type;
- (bool) selectTrack: (GstAVFAssetReaderMediaType) type : (gint) index;
- (GstBuffer *) nextBuffer:  (GstAVFAssetReaderMediaType) type : (GError **) error;
@end

struct _GstAVFAssetSrc
{
  GstElement element;

  GstPad *videopad;
  GstPad *audiopad;
  gint selected_video_track;
  gint selected_audio_track;

  GstAVFAssetReader *reader;
  GstAVFAssetSrcState state;
  GMutex lock;
  GstEvent *seek_event;

  GstFlowReturn last_audio_pad_ret;
  GstFlowReturn last_video_pad_ret;

  /* Properties */
  gchar * uri;
};

struct _GstAVFAssetSrcClass
{
  GstElementClass parent_class;
};

GType gst_avf_asset_src_get_type (void);

G_END_DECLS

#endif /* __GST_AVF_ASSET_SRC_H__ */
