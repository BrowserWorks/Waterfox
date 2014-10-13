/* GStreamer Wavpack parser
 * Copyright (C) 2012 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) 2012 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
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
 * SECTION:element-wavpackparse
 * @short_description: Wavpack parser
 * @see_also: #GstAmrParse, #GstAACParse
 *
 * This is an Wavpack parser.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 filesrc location=abc.wavpack ! wavpackparse ! wavpackdec ! audioresample ! audioconvert ! autoaudiosink
 * ]|
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstwavpackparse.h"

#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>
#include <gst/audio/audio.h>

GST_DEBUG_CATEGORY_STATIC (wavpack_parse_debug);
#define GST_CAT_DEFAULT wavpack_parse_debug

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-wavpack, "
        "depth = (int) [ 1, 32 ], "
        "channels = (int) [ 1, 8 ], "
        "rate = (int) [ 6000, 192000 ], " "framed = (boolean) TRUE; "
        "audio/x-wavpack-correction, " "framed = (boolean) TRUE")
    );

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-wavpack"));

static void gst_wavpack_parse_finalize (GObject * object);

static gboolean gst_wavpack_parse_start (GstBaseParse * parse);
static gboolean gst_wavpack_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_wavpack_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstCaps *gst_wavpack_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);
static GstFlowReturn gst_wavpack_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

#define gst_wavpack_parse_parent_class parent_class
G_DEFINE_TYPE (GstWavpackParse, gst_wavpack_parse, GST_TYPE_BASE_PARSE);

static void
gst_wavpack_parse_class_init (GstWavpackParseClass * klass)
{
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GObjectClass *object_class = G_OBJECT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (wavpack_parse_debug, "wavpackparse", 0,
      "Wavpack audio stream parser");

  object_class->finalize = gst_wavpack_parse_finalize;

  parse_class->start = GST_DEBUG_FUNCPTR (gst_wavpack_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_wavpack_parse_stop);
  parse_class->handle_frame =
      GST_DEBUG_FUNCPTR (gst_wavpack_parse_handle_frame);
  parse_class->get_sink_caps =
      GST_DEBUG_FUNCPTR (gst_wavpack_parse_get_sink_caps);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_wavpack_parse_pre_push_frame);

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_template));

  gst_element_class_set_static_metadata (element_class,
      "Wavpack audio stream parser", "Codec/Parser/Audio",
      "Wavpack parser", "Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>");
}

static void
gst_wavpack_parse_reset (GstWavpackParse * wvparse)
{
  wvparse->channels = -1;
  wvparse->channel_mask = 0;
  wvparse->sample_rate = -1;
  wvparse->width = -1;
  wvparse->total_samples = 0;
  wvparse->sent_codec_tag = FALSE;
}

static void
gst_wavpack_parse_init (GstWavpackParse * wvparse)
{
  gst_wavpack_parse_reset (wvparse);
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (wvparse));
}

static void
gst_wavpack_parse_finalize (GObject * object)
{
  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_wavpack_parse_start (GstBaseParse * parse)
{
  GstWavpackParse *wvparse = GST_WAVPACK_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "starting");

  gst_wavpack_parse_reset (wvparse);

  /* need header at least */
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (wvparse),
      sizeof (WavpackHeader));

  /* inform baseclass we can come up with ts, based on counters in packets */
  gst_base_parse_set_has_timing_info (GST_BASE_PARSE_CAST (wvparse), TRUE);
  gst_base_parse_set_syncable (GST_BASE_PARSE_CAST (wvparse), TRUE);

  return TRUE;
}

static gboolean
gst_wavpack_parse_stop (GstBaseParse * parse)
{
  GST_DEBUG_OBJECT (parse, "stopping");

  return TRUE;
}

static gint
gst_wavpack_get_default_channel_mask (gint nchannels)
{
  gint channel_mask = 0;

  /* Set the default channel mask for the given number of channels.
   * It's the same as for WAVE_FORMAT_EXTENDED:
   * http://www.microsoft.com/whdc/device/audio/multichaud.mspx
   */
  switch (nchannels) {
    case 11:
      channel_mask |= 0x00400;
      channel_mask |= 0x00200;
    case 9:
      channel_mask |= 0x00100;
    case 8:
      channel_mask |= 0x00080;
      channel_mask |= 0x00040;
    case 6:
      channel_mask |= 0x00020;
      channel_mask |= 0x00010;
    case 4:
      channel_mask |= 0x00008;
    case 3:
      channel_mask |= 0x00004;
    case 2:
      channel_mask |= 0x00002;
      channel_mask |= 0x00001;
      break;
    case 1:
      /* For mono use front center */
      channel_mask |= 0x00004;
      break;
  }

  return channel_mask;
}

static const struct
{
  const guint32 ms_mask;
  const GstAudioChannelPosition gst_pos;
} layout_mapping[] = {
  {
  0x00001, GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT}, {
  0x00002, GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT}, {
  0x00004, GST_AUDIO_CHANNEL_POSITION_FRONT_CENTER}, {
  0x00008, GST_AUDIO_CHANNEL_POSITION_LFE1}, {
  0x00010, GST_AUDIO_CHANNEL_POSITION_REAR_LEFT}, {
  0x00020, GST_AUDIO_CHANNEL_POSITION_REAR_RIGHT}, {
  0x00040, GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT_OF_CENTER}, {
  0x00080, GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER}, {
  0x00100, GST_AUDIO_CHANNEL_POSITION_REAR_CENTER}, {
  0x00200, GST_AUDIO_CHANNEL_POSITION_SIDE_LEFT}, {
  0x00400, GST_AUDIO_CHANNEL_POSITION_SIDE_RIGHT}, {
  0x00800, GST_AUDIO_CHANNEL_POSITION_TOP_CENTER}, {
  0x01000, GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_LEFT}, {
  0x02000, GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_CENTER}, {
  0x04000, GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_RIGHT}, {
  0x08000, GST_AUDIO_CHANNEL_POSITION_TOP_REAR_LEFT}, {
  0x10000, GST_AUDIO_CHANNEL_POSITION_TOP_REAR_CENTER}, {
  0x20000, GST_AUDIO_CHANNEL_POSITION_TOP_REAR_RIGHT}
};

#define MAX_CHANNEL_POSITIONS G_N_ELEMENTS (layout_mapping)

static gboolean
gst_wavpack_get_channel_positions (gint num_channels, gint layout,
    GstAudioChannelPosition * pos)
{
  gint i, p;

  if (num_channels == 1 && layout == 0x00004) {
    pos[0] = GST_AUDIO_CHANNEL_POSITION_MONO;
    return TRUE;
  }

  p = 0;
  for (i = 0; i < MAX_CHANNEL_POSITIONS; ++i) {
    if ((layout & layout_mapping[i].ms_mask) != 0) {
      if (p >= num_channels) {
        GST_WARNING ("More bits set in the channel layout map than there "
            "are channels! Broken file");
        return FALSE;
      }
      if (layout_mapping[i].gst_pos == GST_AUDIO_CHANNEL_POSITION_INVALID) {
        GST_WARNING ("Unsupported channel position (mask 0x%08x) in channel "
            "layout map - ignoring those channels", layout_mapping[i].ms_mask);
        /* what to do? just ignore it and let downstream deal with a channel
         * layout that has INVALID positions in it for now ... */
      }
      pos[p] = layout_mapping[i].gst_pos;
      ++p;
    }
  }

  if (p != num_channels) {
    GST_WARNING ("Only %d bits set in the channel layout map, but there are "
        "supposed to be %d channels! Broken file", p, num_channels);
    return FALSE;
  }

  return TRUE;
}

static const guint32 sample_rates[] = {
  6000, 8000, 9600, 11025, 12000, 16000, 22050,
  24000, 32000, 44100, 48000, 64000, 88200, 96000, 192000
};

#define CHECK(call) { \
  if (!call) \
    goto read_failed; \
}

/* caller ensures properly sync'ed with enough data */
static gboolean
gst_wavpack_parse_frame_metadata (GstWavpackParse * parse, GstBuffer * buf,
    gint skip, WavpackHeader * wph, WavpackInfo * wpi)
{
  GstByteReader br;
  gint i;
  GstMapInfo map;

  g_return_val_if_fail (wph != NULL || wpi != NULL, FALSE);
  g_return_val_if_fail (gst_buffer_get_size (buf) >=
      skip + sizeof (WavpackHeader), FALSE);

  gst_buffer_map (buf, &map, GST_MAP_READ);

  gst_byte_reader_init (&br, map.data + skip, wph->ckSize + 8);
  /* skip past header */
  gst_byte_reader_skip_unchecked (&br, sizeof (WavpackHeader));

  /* get some basics from header */
  i = (wph->flags >> 23) & 0xF;
  if (!wpi->rate)
    wpi->rate = (i < G_N_ELEMENTS (sample_rates)) ? sample_rates[i] : 44100;
  wpi->width = ((wph->flags & 0x3) + 1) * 8;
  if (!wpi->channels)
    wpi->channels = (wph->flags & 0x4) ? 1 : 2;
  if (!wpi->channel_mask)
    wpi->channel_mask = 5 - wpi->channels;

  /* need to dig metadata blocks for some more */
  while (gst_byte_reader_get_remaining (&br)) {
    gint size = 0;
    guint16 size2 = 0;
    guint8 c, id;
    const guint8 *data;
    GstByteReader mbr;

    CHECK (gst_byte_reader_get_uint8 (&br, &id));
    CHECK (gst_byte_reader_get_uint8 (&br, &c));
    if (id & ID_LARGE)
      CHECK (gst_byte_reader_get_uint16_le (&br, &size2));
    size = size2;
    size <<= 8;
    size += c;
    size <<= 1;
    if (id & ID_ODD_SIZE)
      size--;

    CHECK (gst_byte_reader_get_data (&br, size + (size & 1), &data));
    gst_byte_reader_init (&mbr, data, size);

    switch (id) {
      case ID_WVC_BITSTREAM:
        GST_LOG_OBJECT (parse, "correction bitstream");
        wpi->correction = TRUE;
        break;
      case ID_WV_BITSTREAM:
      case ID_WVX_BITSTREAM:
        break;
      case ID_SAMPLE_RATE:
        if (size == 3) {
          CHECK (gst_byte_reader_get_uint24_le (&mbr, &wpi->rate));
          GST_LOG_OBJECT (parse, "updated with custom rate %d", wpi->rate);
        } else {
          GST_DEBUG_OBJECT (parse, "unexpected size for SAMPLE_RATE metadata");
        }
        break;
      case ID_CHANNEL_INFO:
      {
        guint16 channels;
        guint32 mask = 0;

        if (size == 6) {
          CHECK (gst_byte_reader_get_uint16_le (&mbr, &channels));
          channels = channels & 0xFFF;
          CHECK (gst_byte_reader_get_uint24_le (&mbr, &mask));
        } else if (size) {
          CHECK (gst_byte_reader_get_uint8 (&mbr, &c));
          channels = c;
          while (gst_byte_reader_get_uint8 (&mbr, &c))
            mask |= (((guint32) c) << 8);
        } else {
          GST_DEBUG_OBJECT (parse, "unexpected size for CHANNEL_INFO metadata");
          break;
        }
        wpi->channels = channels;
        wpi->channel_mask = mask;
        break;
      }
      default:
        GST_LOG_OBJECT (parse, "unparsed ID 0x%x", id);
        break;
    }
  }

  gst_buffer_unmap (buf, &map);

  return TRUE;

  /* ERRORS */
read_failed:
  {
    gst_buffer_unmap (buf, &map);
    GST_DEBUG_OBJECT (parse, "short read while parsing metadata");
    /* let's look the other way anyway */
    return TRUE;
  }
}

/* caller ensures properly sync'ed with enough data */
static gboolean
gst_wavpack_parse_frame_header (GstWavpackParse * parse, GstBuffer * buf,
    gint skip, WavpackHeader * _wph)
{
  GstByteReader br;
  WavpackHeader wph = { {0,}, 0, };
  GstMapInfo map;
  gboolean hdl = TRUE;

  g_return_val_if_fail (gst_buffer_get_size (buf) >=
      skip + sizeof (WavpackHeader), FALSE);

  gst_buffer_map (buf, &map, GST_MAP_READ);
  gst_byte_reader_init (&br, map.data, map.size);

  /* marker */
  gst_byte_reader_skip_unchecked (&br, skip + 4);

  /* read */
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.ckSize);
  hdl &= gst_byte_reader_get_uint16_le (&br, &wph.version);
  hdl &= gst_byte_reader_get_uint8 (&br, &wph.track_no);
  hdl &= gst_byte_reader_get_uint8 (&br, &wph.index_no);
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.total_samples);
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.block_index);
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.block_samples);
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.flags);
  hdl &= gst_byte_reader_get_uint32_le (&br, &wph.crc);

  if (!hdl)
    GST_WARNING_OBJECT (parse, "Error reading header");

  /* dump */
  GST_LOG_OBJECT (parse, "size %d", wph.ckSize);
  GST_LOG_OBJECT (parse, "version 0x%x", wph.version);
  GST_LOG_OBJECT (parse, "total samples %d", wph.total_samples);
  GST_LOG_OBJECT (parse, "block index %d", wph.block_index);
  GST_LOG_OBJECT (parse, "block samples %d", wph.block_samples);
  GST_LOG_OBJECT (parse, "flags 0x%x", wph.flags);
  GST_LOG_OBJECT (parse, "crc 0x%x", wph.flags);

  if (!parse->total_samples && wph.block_index == 0 && wph.total_samples != -1) {
    GST_DEBUG_OBJECT (parse, "determined duration of %u samples",
        wph.total_samples);
    parse->total_samples = wph.total_samples;
  }

  if (_wph)
    *_wph = wph;

  gst_buffer_unmap (buf, &map);

  return TRUE;
}

static GstFlowReturn
gst_wavpack_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstWavpackParse *wvparse = GST_WAVPACK_PARSE (parse);
  GstBuffer *buf = frame->buffer;
  GstByteReader reader;
  gint off;
  guint rate, chans, width, mask;
  gboolean lost_sync, draining, final;
  guint frmsize = 0;
  WavpackHeader wph;
  WavpackInfo wpi = { 0, };
  GstMapInfo map;

  if (G_UNLIKELY (gst_buffer_get_size (buf) < sizeof (WavpackHeader)))
    return FALSE;

  gst_buffer_map (buf, &map, GST_MAP_READ);
  gst_byte_reader_init (&reader, map.data, map.size);

  /* scan for 'wvpk' marker */
  off = gst_byte_reader_masked_scan_uint32 (&reader, 0xffffffff, 0x7776706b,
      0, map.size);

  GST_LOG_OBJECT (parse, "possible sync at buffer offset %d", off);

  /* didn't find anything that looks like a sync word, skip */
  if (off < 0) {
    *skipsize = map.size - 3;
    goto skip;
  }

  /* possible frame header, but not at offset 0? skip bytes before sync */
  if (off > 0) {
    *skipsize = off;
    goto skip;
  }

  /* make sure the values in the frame header look sane */
  gst_wavpack_parse_frame_header (wvparse, buf, 0, &wph);
  frmsize = wph.ckSize + 8;

  /* need the entire frame for parsing */
  if (gst_byte_reader_get_remaining (&reader) < frmsize)
    goto more;

  /* got a frame, now we can dig for some more metadata */
  GST_LOG_OBJECT (parse, "got frame");
  gst_wavpack_parse_frame_metadata (wvparse, buf, 0, &wph, &wpi);

  lost_sync = GST_BASE_PARSE_LOST_SYNC (parse);
  draining = GST_BASE_PARSE_DRAINING (parse);

  while (!(final = (wph.flags & FLAG_FINAL_BLOCK)) || (lost_sync && !draining)) {
    guint32 word = 0;

    GST_LOG_OBJECT (wvparse, "checking next frame syncword; "
        "lost_sync: %d, draining: %d, final: %d", lost_sync, draining, final);

    if (!gst_byte_reader_skip (&reader, wph.ckSize + 8) ||
        !gst_byte_reader_peek_uint32_be (&reader, &word)) {
      GST_DEBUG_OBJECT (wvparse, "... but not sufficient data");
      frmsize += 4;
      goto more;
    } else {
      if (word != 0x7776706b) {
        GST_DEBUG_OBJECT (wvparse, "0x%x not OK", word);
        *skipsize = off + 2;
        goto skip;
      }
      /* need to parse each frame/block for metadata if several ones */
      if (!final) {
        gint av;

        GST_LOG_OBJECT (wvparse, "checking frame at offset %d (0x%x)",
            frmsize, frmsize);
        av = gst_byte_reader_get_remaining (&reader);
        if (av < sizeof (WavpackHeader)) {
          frmsize += sizeof (WavpackHeader);
          goto more;
        }
        gst_wavpack_parse_frame_header (wvparse, buf, frmsize, &wph);
        off = frmsize;
        frmsize += wph.ckSize + 8;
        if (av < wph.ckSize + 8)
          goto more;
        gst_wavpack_parse_frame_metadata (wvparse, buf, off, &wph, &wpi);
        /* could also check for matching block_index and block_samples ?? */
      }
    }

    /* resynced if we make it here */
    lost_sync = FALSE;
  }

  rate = wpi.rate;
  width = wpi.width;
  chans = wpi.channels;
  mask = wpi.channel_mask;

  GST_LOG_OBJECT (parse, "rate: %u, width: %u, chans: %u", rate, width, chans);

  GST_BUFFER_TIMESTAMP (buf) =
      gst_util_uint64_scale_int (wph.block_index, GST_SECOND, rate);
  GST_BUFFER_DURATION (buf) =
      gst_util_uint64_scale_int (wph.block_index + wph.block_samples,
      GST_SECOND, rate) - GST_BUFFER_TIMESTAMP (buf);

  if (G_UNLIKELY (wvparse->sample_rate != rate || wvparse->channels != chans
          || wvparse->width != width || wvparse->channel_mask != mask)) {
    GstCaps *caps;

    if (wpi.correction) {
      caps = gst_caps_new_simple ("audio/x-wavpack-correction",
          "framed", G_TYPE_BOOLEAN, TRUE, NULL);
    } else {
      caps = gst_caps_new_simple ("audio/x-wavpack",
          "channels", G_TYPE_INT, chans,
          "rate", G_TYPE_INT, rate,
          "depth", G_TYPE_INT, width, "framed", G_TYPE_BOOLEAN, TRUE, NULL);

      if (!mask)
        mask = gst_wavpack_get_default_channel_mask (wvparse->channels);
      if (mask != 0) {
        GstAudioChannelPosition pos[64] =
            { GST_AUDIO_CHANNEL_POSITION_INVALID, };
        guint64 gmask;

        if (!gst_wavpack_get_channel_positions (chans, mask, pos)) {
          GST_WARNING_OBJECT (wvparse, "Failed to determine channel layout");
        } else {
          gst_audio_channel_positions_to_mask (pos, chans, FALSE, &gmask);
          if (gmask)
            gst_caps_set_simple (caps,
                "channel-mask", GST_TYPE_BITMASK, gmask, NULL);
        }
      }
    }

    gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (parse), caps);
    gst_caps_unref (caps);

    wvparse->sample_rate = rate;
    wvparse->channels = chans;
    wvparse->width = width;
    wvparse->channel_mask = mask;

    if (wvparse->total_samples) {
      GST_DEBUG_OBJECT (wvparse, "setting duration");
      gst_base_parse_set_duration (GST_BASE_PARSE (wvparse),
          GST_FORMAT_TIME, gst_util_uint64_scale_int (wvparse->total_samples,
              GST_SECOND, wvparse->sample_rate), 0);
    }
  }

  /* return to normal size */
  gst_base_parse_set_min_frame_size (parse, sizeof (WavpackHeader));
  gst_buffer_unmap (buf, &map);

  return gst_base_parse_finish_frame (parse, frame, frmsize);

skip:
  gst_buffer_unmap (buf, &map);
  GST_LOG_OBJECT (wvparse, "skipping %d", *skipsize);
  return GST_FLOW_OK;

more:
  gst_buffer_unmap (buf, &map);
  GST_LOG_OBJECT (wvparse, "need at least %u", frmsize);
  gst_base_parse_set_min_frame_size (parse, frmsize);
  *skipsize = 0;
  return GST_FLOW_OK;
}

static void
remove_fields (GstCaps * caps)
{
  guint i, n;

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    gst_structure_remove_field (s, "framed");
  }
}

static GstCaps *
gst_wavpack_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
{
  GstCaps *peercaps, *templ;
  GstCaps *res;

  templ = gst_pad_get_pad_template_caps (GST_BASE_PARSE_SINK_PAD (parse));
  if (filter) {
    GstCaps *fcopy = gst_caps_copy (filter);
    /* Remove the fields we convert */
    remove_fields (fcopy);
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), fcopy);
    gst_caps_unref (fcopy);
  } else
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), NULL);

  if (peercaps) {
    /* Remove the framed field */
    peercaps = gst_caps_make_writable (peercaps);
    remove_fields (peercaps);

    res = gst_caps_intersect_full (peercaps, templ, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (peercaps);
    gst_caps_unref (templ);
  } else {
    res = templ;
  }

  if (filter) {
    GstCaps *intersection;

    intersection =
        gst_caps_intersect_full (filter, res, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (res);
    res = intersection;
  }

  return res;
}

static GstFlowReturn
gst_wavpack_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame)
{
  GstWavpackParse *wavpackparse = GST_WAVPACK_PARSE (parse);

  if (!wavpackparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (wavpackparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    wavpackparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
