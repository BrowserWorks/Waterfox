/* GStreamer
 * Copyright (C) <2006> Wim Taymans <wim@fluendo.com>
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

/*
 * based on http://developer.apple.com/quicktime/icefloe/dispatch026.html
 */
#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/rtp/gstrtpbuffer.h>

#include <string.h>
#include "gstrtpxqtdepay.h"

#define MAKE_TLV(a,b)  (((a)<<8)|(b))

#define TLV_sd	MAKE_TLV ('s','d')
#define TLV_qt	MAKE_TLV ('q','t')
#define TLV_ti	MAKE_TLV ('t','i')
#define TLV_ly	MAKE_TLV ('l','y')
#define TLV_vo	MAKE_TLV ('v','o')
#define TLV_mx	MAKE_TLV ('m','x')
#define TLV_tr	MAKE_TLV ('t','r')
#define TLV_tw	MAKE_TLV ('t','w')
#define TLV_th	MAKE_TLV ('t','h')
#define TLV_la	MAKE_TLV ('l','a')
#define TLV_rt	MAKE_TLV ('r','t')
#define TLV_gm	MAKE_TLV ('g','m')
#define TLV_oc	MAKE_TLV ('o','c')
#define TLV_cr	MAKE_TLV ('c','r')
#define TLV_du	MAKE_TLV ('d','u')
#define TLV_po	MAKE_TLV ('p','o')

#define QT_UINT32(a)  (GST_READ_UINT32_BE(a))
#define QT_UINT24(a)  (GST_READ_UINT32_BE(a) >> 8)
#define QT_UINT16(a)  (GST_READ_UINT16_BE(a))
#define QT_UINT8(a)   (GST_READ_UINT8(a))
#define QT_FP32(a)    ((GST_READ_UINT32_BE(a))/65536.0)
#define QT_FP16(a)    ((GST_READ_UINT16_BE(a))/256.0)
#define QT_FOURCC(a)  (GST_READ_UINT32_LE(a))
#define QT_UINT64(a)  ((((guint64)QT_UINT32(a))<<32)|QT_UINT32(((guint8 *)a)+4))

#define FOURCC_avc1     GST_MAKE_FOURCC('a','v','c','1')
#define FOURCC_avc3     GST_MAKE_FOURCC('a','v','c','3')
#define FOURCC_avcC     GST_MAKE_FOURCC('a','v','c','C')

GST_DEBUG_CATEGORY_STATIC (rtpxqtdepay_debug);
#define GST_CAT_DEFAULT (rtpxqtdepay_debug)

/* RtpXQTDepay signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  ARG_0,
};

static GstStaticPadTemplate gst_rtp_xqt_depay_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate gst_rtp_xqt_depay_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("application/x-rtp, "
        "payload = (int) " GST_RTP_PAYLOAD_DYNAMIC_STRING ", "
        "media = (string) { \"audio\", \"video\" }, clock-rate = (int) [1, MAX], "
        "encoding-name = (string) { \"X-QT\", \"X-QUICKTIME\" }")
    );

#define gst_rtp_xqt_depay_parent_class parent_class
G_DEFINE_TYPE (GstRtpXQTDepay, gst_rtp_xqt_depay, GST_TYPE_RTP_BASE_DEPAYLOAD);

static void gst_rtp_xqt_depay_finalize (GObject * object);

static gboolean gst_rtp_xqt_depay_setcaps (GstRTPBaseDepayload * depayload,
    GstCaps * caps);
static GstBuffer *gst_rtp_xqt_depay_process (GstRTPBaseDepayload * depayload,
    GstBuffer * buf);

static GstStateChangeReturn gst_rtp_xqt_depay_change_state (GstElement *
    element, GstStateChange transition);


static void
gst_rtp_xqt_depay_class_init (GstRtpXQTDepayClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstRTPBaseDepayloadClass *gstrtpbasedepayload_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstrtpbasedepayload_class = (GstRTPBaseDepayloadClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->finalize = gst_rtp_xqt_depay_finalize;

  gstelement_class->change_state = gst_rtp_xqt_depay_change_state;

  gstrtpbasedepayload_class->set_caps = gst_rtp_xqt_depay_setcaps;
  gstrtpbasedepayload_class->process = gst_rtp_xqt_depay_process;

  GST_DEBUG_CATEGORY_INIT (rtpxqtdepay_debug, "rtpxqtdepay", 0,
      "QT Media RTP Depayloader");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_rtp_xqt_depay_src_template));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_rtp_xqt_depay_sink_template));

  gst_element_class_set_static_metadata (gstelement_class,
      "RTP packet depayloader", "Codec/Depayloader/Network",
      "Extracts Quicktime audio/video from RTP packets",
      "Wim Taymans <wim@fluendo.com>");
}

static void
gst_rtp_xqt_depay_init (GstRtpXQTDepay * rtpxqtdepay)
{
  rtpxqtdepay->adapter = gst_adapter_new ();
}

static void
gst_rtp_xqt_depay_finalize (GObject * object)
{
  GstRtpXQTDepay *rtpxqtdepay;

  rtpxqtdepay = GST_RTP_XQT_DEPAY (object);

  g_object_unref (rtpxqtdepay->adapter);
  rtpxqtdepay->adapter = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_rtp_quicktime_parse_sd (GstRtpXQTDepay * rtpxqtdepay, guint8 * data,
    guint data_len)
{
  gint len;
  guint32 fourcc;

  if (data_len < 8)
    goto too_short;

  len = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
  if (len > data_len)
    goto too_short;

  fourcc = QT_FOURCC (data + 4);

  GST_DEBUG_OBJECT (rtpxqtdepay, "parsing %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (fourcc));

  switch (fourcc) {
    case FOURCC_avc1:
    case FOURCC_avc3:
    {
      guint32 chlen;

      if (len < 0x56)
        goto too_short;
      len -= 0x56;
      data += 0x56;

      /* find avcC */
      while (len >= 8) {
        chlen = QT_UINT32 (data);
        fourcc = QT_FOURCC (data + 4);
        if (fourcc == FOURCC_avcC) {
          GstBuffer *buf;
          gint size;
          GstCaps *caps;

          GST_DEBUG_OBJECT (rtpxqtdepay, "found avcC codec_data in sd, %u",
              chlen);

          /* parse, if found */
          if (chlen < len)
            size = chlen - 8;
          else
            size = len - 8;

          buf = gst_buffer_new_and_alloc (size);
          gst_buffer_fill (buf, 0, data + 8, size);
          caps = gst_caps_new_simple ("video/x-h264",
              "codec_data", GST_TYPE_BUFFER, buf, NULL);
          gst_buffer_unref (buf);
          gst_pad_set_caps (GST_RTP_BASE_DEPAYLOAD (rtpxqtdepay)->srcpad, caps);
          gst_caps_unref (caps);
          break;
        }
        len -= chlen;
        data += chlen;
      }
      break;
    }
    default:
      break;
  }
  return TRUE;

  /* ERRORS */
too_short:
  {
    return FALSE;
  }
}

static gboolean
gst_rtp_xqt_depay_setcaps (GstRTPBaseDepayload * depayload, GstCaps * caps)
{
  GstStructure *structure;
  gint clock_rate = 90000;      /* default */

  structure = gst_caps_get_structure (caps, 0);

  gst_structure_get_int (structure, "clock-rate", &clock_rate);
  depayload->clock_rate = clock_rate;

  return TRUE;
}

static GstBuffer *
gst_rtp_xqt_depay_process (GstRTPBaseDepayload * depayload, GstBuffer * buf)
{
  GstRtpXQTDepay *rtpxqtdepay;
  GstBuffer *outbuf = NULL;
  gboolean m;
  GstRTPBuffer rtp = { NULL };

  rtpxqtdepay = GST_RTP_XQT_DEPAY (depayload);

  gst_rtp_buffer_map (buf, GST_MAP_READ, &rtp);

  if (GST_BUFFER_IS_DISCONT (buf)) {
    /* discont, clear adapter and try to find a new packet start */
    gst_adapter_clear (rtpxqtdepay->adapter);
    rtpxqtdepay->need_resync = TRUE;
    GST_DEBUG_OBJECT (rtpxqtdepay, "we need resync");
  }

  m = gst_rtp_buffer_get_marker (&rtp);
  GST_LOG_OBJECT (rtpxqtdepay, "marker: %d", m);

  {
    gint payload_len;
    guint avail;
    guint8 *payload;
    guint8 ver, pck;
    gboolean s, q, l, d;

    payload_len = gst_rtp_buffer_get_payload_len (&rtp);
    payload = gst_rtp_buffer_get_payload (&rtp);

    /*                      1                   2                   3 
     *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     * | VER   |PCK|S|Q|L| RES         |D| QuickTime Payload ID        |
     * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     */
    if (payload_len <= 4)
      goto wrong_length;

    ver = (payload[0] & 0xf0) >> 4;
    if (ver > 1)
      goto wrong_version;

    pck = (payload[0] & 0x0c) >> 2;
    if (pck == 0)
      goto pck_reserved;

    s = (payload[0] & 0x02) != 0;       /* contains sync sample */
    q = (payload[0] & 0x01) != 0;       /* has payload description */
    l = (payload[1] & 0x80) != 0;       /* has packet specific information description */
    d = (payload[2] & 0x80) != 0;       /* don't cache info for payload id */
    /* id used for caching info */
    rtpxqtdepay->current_id = ((payload[2] & 0x7f) << 8) | payload[3];

    GST_LOG_OBJECT (rtpxqtdepay,
        "VER: %d, PCK: %d, S: %d, Q: %d, L: %d, D: %d, ID: %d", ver, pck, s, q,
        l, d, rtpxqtdepay->current_id);

    if (rtpxqtdepay->need_resync) {
      /* we need to find the boundary of a new packet after a DISCONT */
      if (pck != 3 || q) {
        /* non-fragmented packet or payload description present, packet starts
         * here. */
        rtpxqtdepay->need_resync = FALSE;
      } else {
        /* fragmented packet without description */
        if (m) {
          /* marker bit set, next packet is start of new one */
          rtpxqtdepay->need_resync = FALSE;
        }
        goto need_resync;
      }
    }

    payload += 4;
    payload_len -= 4;

    if (q) {
      gboolean k, f, a, z;
      guint pdlen, pdpadded;
      gint padding;
      /* media_type only used for printing */
      guint32 G_GNUC_UNUSED media_type;
      guint32 timescale;

      /*                      1                   2                   3
       *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * |K|F|A|Z| RES                   | QuickTime Payload Desc Length |
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * . QuickTime Payload Desc Data ... . 
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       */
      if (payload_len <= 4)
        goto wrong_length;

      k = (payload[0] & 0x80) != 0;     /* keyframe */
      f = (payload[0] & 0x40) != 0;     /* sparse */
      a = (payload[0] & 0x20) != 0;     /* start of payload */
      z = (payload[0] & 0x10) != 0;     /* end of payload */
      pdlen = (payload[2] << 8) | payload[3];

      if (pdlen < 12)
        goto wrong_length;

      /* calc padding */
      pdpadded = pdlen + 3;
      pdpadded -= pdpadded % 4;
      if (payload_len < pdpadded)
        goto wrong_length;

      padding = pdpadded - pdlen;
      GST_LOG_OBJECT (rtpxqtdepay,
          "K: %d, F: %d, A: %d, Z: %d, len: %d, padding %d", k, f, a, z, pdlen,
          padding);

      payload += 4;
      payload_len -= 4;
      /*                      1                   2                   3
       *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * | QuickTime Media Type                                          |
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * | Timescale                                                     |
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * . QuickTime TLVs ... .
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       */
      media_type =
          (payload[0] << 24) | (payload[1] << 16) | (payload[2] << 8) |
          payload[3];
      timescale =
          (payload[4] << 24) | (payload[5] << 16) | (payload[6] << 8) |
          payload[7];

      GST_LOG_OBJECT (rtpxqtdepay, "media_type: %c%c%c%c, timescale %u",
          payload[0], payload[1], payload[2], payload[3], timescale);

      payload += 8;
      payload_len -= 8;
      pdlen -= 12;

      /* parse TLV (type-length-value triplets */
      while (pdlen > 3) {
        guint16 tlv_len, tlv_type;

        /*                      1                   2                   3
         *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * | QuickTime TLV Length          | QuickTime TLV Type            |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * . QuickTime TLV Value ... .
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         */
        tlv_len = (payload[0] << 8) | payload[1];
        tlv_type = (payload[2] << 8) | payload[3];
        pdlen -= 4;
        if (tlv_len > pdlen)
          goto wrong_length;

        GST_LOG_OBJECT (rtpxqtdepay, "TLV '%c%c', len %d", payload[2],
            payload[3], tlv_len);

        payload += 4;
        payload_len -= 4;

        switch (tlv_type) {
          case TLV_sd:
            /* Session description */
            if (!gst_rtp_quicktime_parse_sd (rtpxqtdepay, payload, tlv_len))
              goto unknown_format;
            rtpxqtdepay->have_sd = TRUE;
            break;
          case TLV_qt:
          case TLV_ti:
          case TLV_ly:
          case TLV_vo:
          case TLV_mx:
          case TLV_tr:
          case TLV_tw:
          case TLV_th:
          case TLV_la:
          case TLV_rt:
          case TLV_gm:
          case TLV_oc:
          case TLV_cr:
          case TLV_du:
          case TLV_po:
          default:
            break;
        }

        pdlen -= tlv_len;
        payload += tlv_len;
        payload_len -= tlv_len;
      }
      payload += padding;
      payload_len -= padding;
    }

    if (l) {
      guint ssilen, ssipadded;
      gint padding;

      /*                      1                   2                   3
       *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * | RES                           | Sample-Specific Info Length   |
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       * . QuickTime TLVs ... 
       * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       */
      if (payload_len <= 4)
        goto wrong_length;

      ssilen = (payload[2] << 8) | payload[3];
      if (ssilen < 4)
        goto wrong_length;

      /* calc padding */
      ssipadded = ssilen + 3;
      ssipadded -= ssipadded % 4;
      if (payload_len < ssipadded)
        goto wrong_length;

      padding = ssipadded - ssilen;
      GST_LOG_OBJECT (rtpxqtdepay, "len: %d, padding %d", ssilen, padding);

      payload += 4;
      payload_len -= 4;
      ssilen -= 4;

      /* parse TLV (type-length-value triplets */
      while (ssilen > 3) {
        guint16 tlv_len, tlv_type;

        /*                      1                   2                   3
         *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * | QuickTime TLV Length          | QuickTime TLV Type            |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * . QuickTime TLV Value ... .
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         */
        tlv_len = (payload[0] << 8) | payload[1];
        tlv_type = (payload[2] << 8) | payload[3];
        ssilen -= 4;
        if (tlv_len > ssilen)
          goto wrong_length;

        GST_LOG_OBJECT (rtpxqtdepay, "TLV '%c%c', len %d", payload[2],
            payload[3], tlv_len);

        payload += 4;
        payload_len -= 4;

        switch (tlv_type) {
          case TLV_sd:
          case TLV_qt:
          case TLV_ti:
          case TLV_ly:
          case TLV_vo:
          case TLV_mx:
          case TLV_tr:
          case TLV_tw:
          case TLV_th:
          case TLV_la:
          case TLV_rt:
          case TLV_gm:
          case TLV_oc:
          case TLV_cr:
          case TLV_du:
          case TLV_po:
          default:
            break;
        }

        ssilen -= tlv_len;
        payload += tlv_len;
        payload_len -= tlv_len;
      }
      payload += padding;
      payload_len -= padding;
    }

    rtpxqtdepay->previous_id = rtpxqtdepay->current_id;

    switch (pck) {
      case 1:
      {
        /* multiple samples per packet. */
        outbuf = gst_buffer_new_and_alloc (payload_len);
        gst_buffer_fill (outbuf, 0, payload, payload_len);

        goto done;
      }
      case 2:
      {
        guint slen;

        /* multiple samples per packet. 
         *                      1                   2                   3
         *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * |S| Reserved                    | Sample Length                 |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * | Sample Timestamp                                              |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * . Sample Data ...                                               .
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * |S| Reserved                    | Sample Length                 |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * | Sample Timestamp                                              |
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * . Sample Data ...                                               .
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         * . ......                                                        .
         * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
         */
        while (payload_len > 8) {
          s = (payload[0] & 0x80) != 0; /* contains sync sample */
          slen = (payload[2] << 8) | payload[3];
          /* timestamp =
           *    (payload[4] << 24) | (payload[5] << 16) | (payload[6] << 8) |
           *    payload[7];
           */

          payload += 8;
          payload_len -= 8;

          if (slen > payload_len)
            slen = payload_len;

          outbuf = gst_buffer_new_and_alloc (slen);
          gst_buffer_fill (outbuf, 0, payload, slen);
          if (!s)
            GST_BUFFER_FLAG_SET (outbuf, GST_BUFFER_FLAG_DELTA_UNIT);

          gst_rtp_base_depayload_push (depayload, outbuf);

          /* aligned on 32 bit boundary */
          slen = GST_ROUND_UP_4 (slen);

          payload += slen;
          payload_len -= slen;
        }
        break;
      }
      case 3:
      {
        /* one sample per packet, use adapter to combine based on marker bit. */
        outbuf = gst_buffer_new_and_alloc (payload_len);
        gst_buffer_fill (outbuf, 0, payload, payload_len);

        gst_adapter_push (rtpxqtdepay->adapter, outbuf);
        outbuf = NULL;

        if (!m)
          goto done;

        avail = gst_adapter_available (rtpxqtdepay->adapter);
        outbuf = gst_adapter_take_buffer (rtpxqtdepay->adapter, avail);

        GST_DEBUG_OBJECT (rtpxqtdepay,
            "gst_rtp_xqt_depay_chain: pushing buffer of size %u", avail);

        goto done;
      }
    }
  }

done:
  gst_rtp_buffer_unmap (&rtp);
  return outbuf;

need_resync:
  {
    GST_DEBUG_OBJECT (rtpxqtdepay, "waiting for marker");
    goto done;
  }
wrong_version:
  {
    GST_ELEMENT_WARNING (rtpxqtdepay, STREAM, DECODE,
        ("Unknown payload version."), (NULL));
    goto done;
  }
pck_reserved:
  {
    GST_ELEMENT_WARNING (rtpxqtdepay, STREAM, DECODE,
        ("PCK reserved 0."), (NULL));
    goto done;
  }
wrong_length:
  {
    GST_ELEMENT_WARNING (rtpxqtdepay, STREAM, DECODE,
        ("Wrong payload length."), (NULL));
    goto done;
  }
unknown_format:
  {
    GST_ELEMENT_WARNING (rtpxqtdepay, STREAM, DECODE,
        ("Unknown payload format."), (NULL));
    goto done;
  }
}

static GstStateChangeReturn
gst_rtp_xqt_depay_change_state (GstElement * element, GstStateChange transition)
{
  GstRtpXQTDepay *rtpxqtdepay;
  GstStateChangeReturn ret;

  rtpxqtdepay = GST_RTP_XQT_DEPAY (element);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      gst_adapter_clear (rtpxqtdepay->adapter);
      rtpxqtdepay->previous_id = -1;
      rtpxqtdepay->current_id = -1;
      rtpxqtdepay->need_resync = TRUE;
      rtpxqtdepay->have_sd = FALSE;
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_adapter_clear (rtpxqtdepay->adapter);
    default:
      break;
  }
  return ret;
}
