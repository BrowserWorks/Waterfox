/* GStreamer
 * Copyright (C) <2012> Wim Taymans <wim.taymans@gmail.com>
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
#  include "config.h"
#endif

#include <string.h>

#include "audio-format.h"

#include "gstaudiopack.h"

#ifdef HAVE_ORC
#include <orc/orcfunctions.h>
#else
#define orc_memset memset
#endif

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
# define audio_orc_unpack_s16le audio_orc_unpack_s16
# define audio_orc_unpack_s16be audio_orc_unpack_s16_swap
# define audio_orc_unpack_u16le audio_orc_unpack_u16
# define audio_orc_unpack_u16be audio_orc_unpack_u16_swap
# define audio_orc_unpack_s24_32le audio_orc_unpack_s24_32
# define audio_orc_unpack_s24_32be audio_orc_unpack_s24_32_swap
# define audio_orc_unpack_u24_32le audio_orc_unpack_u24_32
# define audio_orc_unpack_u24_32be audio_orc_unpack_u24_32_swap
# define audio_orc_unpack_s32le audio_orc_unpack_s32
# define audio_orc_unpack_s32be audio_orc_unpack_s32_swap
# define audio_orc_unpack_u32le audio_orc_unpack_u32
# define audio_orc_unpack_u32be audio_orc_unpack_u32_swap
# define audio_orc_unpack_f32le audio_orc_unpack_f32
# define audio_orc_unpack_f32be audio_orc_unpack_f32_swap
# define audio_orc_unpack_f64le audio_orc_unpack_f64
# define audio_orc_unpack_f64be audio_orc_unpack_f64_swap
# define audio_orc_pack_s16le audio_orc_pack_s16
# define audio_orc_pack_s16be audio_orc_pack_s16_swap
# define audio_orc_pack_u16le audio_orc_pack_u16
# define audio_orc_pack_u16be audio_orc_pack_u16_swap
# define audio_orc_pack_s24_32le audio_orc_pack_s24_32
# define audio_orc_pack_s24_32be audio_orc_pack_s24_32_swap
# define audio_orc_pack_u24_32le audio_orc_pack_u24_32
# define audio_orc_pack_u24_32be audio_orc_pack_u24_32_swap
# define audio_orc_pack_s32le audio_orc_pack_s32
# define audio_orc_pack_s32be audio_orc_pack_s32_swap
# define audio_orc_pack_u32le audio_orc_pack_u32
# define audio_orc_pack_u32be audio_orc_pack_u32_swap
# define audio_orc_pack_f32le audio_orc_pack_f32
# define audio_orc_pack_f32be audio_orc_pack_f32_swap
# define audio_orc_pack_f64le audio_orc_pack_f64
# define audio_orc_pack_f64be audio_orc_pack_f64_swap
#else
# define audio_orc_unpack_s16le audio_orc_unpack_s16_swap
# define audio_orc_unpack_s16be audio_orc_unpack_s16
# define audio_orc_unpack_u16le audio_orc_unpack_u16_swap
# define audio_orc_unpack_u16be audio_orc_unpack_u16
# define audio_orc_unpack_s24_32le audio_orc_unpack_s24_32_swap
# define audio_orc_unpack_s24_32be audio_orc_unpack_s24_32
# define audio_orc_unpack_u24_32le audio_orc_unpack_u24_32_swap
# define audio_orc_unpack_u24_32be audio_orc_unpack_u24_32
# define audio_orc_unpack_s32le audio_orc_unpack_s32_swap
# define audio_orc_unpack_s32be audio_orc_unpack_s32
# define audio_orc_unpack_u32le audio_orc_unpack_u32_swap
# define audio_orc_unpack_u32be audio_orc_unpack_u32
# define audio_orc_unpack_f32le audio_orc_unpack_f32_swap
# define audio_orc_unpack_f32be audio_orc_unpack_f32
# define audio_orc_unpack_f64le audio_orc_unpack_f64_swap
# define audio_orc_unpack_f64be audio_orc_unpack_f64
# define audio_orc_pack_s16le audio_orc_pack_s16_swap
# define audio_orc_pack_s16be audio_orc_pack_s16
# define audio_orc_pack_u16le audio_orc_pack_u16_swap
# define audio_orc_pack_u16be audio_orc_pack_u16
# define audio_orc_pack_s24_32le audio_orc_pack_s24_32_swap
# define audio_orc_pack_s24_32be audio_orc_pack_s24_32
# define audio_orc_pack_u24_32le audio_orc_pack_u24_32_swap
# define audio_orc_pack_u24_32be audio_orc_pack_u24_32
# define audio_orc_pack_s32le audio_orc_pack_s32_swap
# define audio_orc_pack_s32be audio_orc_pack_s32
# define audio_orc_pack_u32le audio_orc_pack_u32_swap
# define audio_orc_pack_u32be audio_orc_pack_u32
# define audio_orc_pack_f32le audio_orc_pack_f32_swap
# define audio_orc_pack_f32be audio_orc_pack_f32
# define audio_orc_pack_f64le audio_orc_pack_f64_swap
# define audio_orc_pack_f64be audio_orc_pack_f64
#endif

#define MAKE_ORC_PACK_UNPACK(fmt) \
static void unpack_ ##fmt (const GstAudioFormatInfo *info, \
    GstAudioPackFlags flags, gpointer dest,                \
    const gpointer data, gint length) {                    \
  audio_orc_unpack_ ##fmt (dest, data, length);                  \
}                                                          \
static void pack_ ##fmt (const GstAudioFormatInfo *info,   \
    GstAudioPackFlags flags, const gpointer src,           \
    gpointer data, gint length) {                          \
  audio_orc_pack_ ##fmt (data, src, length);                     \
}

#define PACK_S8 GST_AUDIO_FORMAT_S32, unpack_s8, pack_s8
MAKE_ORC_PACK_UNPACK (s8)
#define PACK_U8 GST_AUDIO_FORMAT_S32, unpack_u8, pack_u8
    MAKE_ORC_PACK_UNPACK (u8)
#define PACK_S16LE GST_AUDIO_FORMAT_S32, unpack_s16le, pack_s16le
    MAKE_ORC_PACK_UNPACK (s16le)
#define PACK_S16BE GST_AUDIO_FORMAT_S32, unpack_s16be, pack_s16be
    MAKE_ORC_PACK_UNPACK (s16be)
#define PACK_U16LE GST_AUDIO_FORMAT_S32, unpack_u16le, pack_u16le
    MAKE_ORC_PACK_UNPACK (u16le)
#define PACK_U16BE GST_AUDIO_FORMAT_S32, unpack_u16be, pack_u16be
    MAKE_ORC_PACK_UNPACK (u16be)
#define PACK_S24_32LE GST_AUDIO_FORMAT_S32, unpack_s24_32le, pack_s24_32le
    MAKE_ORC_PACK_UNPACK (s24_32le)
#define PACK_S24_32BE GST_AUDIO_FORMAT_S32, unpack_s24_32be, pack_s24_32be
    MAKE_ORC_PACK_UNPACK (s24_32be)
#define PACK_U24_32LE GST_AUDIO_FORMAT_S32, unpack_u24_32le, pack_u24_32le
    MAKE_ORC_PACK_UNPACK (u24_32le)
#define PACK_U24_32BE GST_AUDIO_FORMAT_S32, unpack_u24_32be, pack_u24_32be
    MAKE_ORC_PACK_UNPACK (u24_32be)
#define PACK_S32LE GST_AUDIO_FORMAT_S32, unpack_s32le, pack_s32le
    MAKE_ORC_PACK_UNPACK (s32le)
#define PACK_S32BE GST_AUDIO_FORMAT_S32, unpack_s32be, pack_s32be
    MAKE_ORC_PACK_UNPACK (s32be)
#define PACK_U32LE GST_AUDIO_FORMAT_S32, unpack_u32le, pack_u32le
    MAKE_ORC_PACK_UNPACK (u32le)
#define PACK_U32BE GST_AUDIO_FORMAT_S32, unpack_u32be, pack_u32be
    MAKE_ORC_PACK_UNPACK (u32be)
#define SIGNED  (1U<<31)
/* pack from signed integer 32 to integer */
#define WRITE24_TO_LE(p,v) p[0] = v & 0xff; p[1] = (v >> 8) & 0xff; p[2] = (v >> 16) & 0xff
#define WRITE24_TO_BE(p,v) p[2] = v & 0xff; p[1] = (v >> 8) & 0xff; p[0] = (v >> 16) & 0xff
#define READ24_FROM_LE(p) (p[0] | (p[1] << 8) | (p[2] << 16))
#define READ24_FROM_BE(p) (p[2] | (p[1] << 8) | (p[0] << 16))
#define MAKE_PACK_UNPACK(name, stride, sign, scale, READ_FUNC, WRITE_FUNC)     \
static void unpack_ ##name (const GstAudioFormatInfo *info,             \
    GstAudioPackFlags flags, gpointer dest,                             \
    const gpointer data, gint length)                                   \
{                                                                       \
  guint32 *d = dest;                                                    \
  guint8 *s = data;                                                     \
  for (;length; length--) {                                             \
    *d++ = (((gint32) READ_FUNC (s)) << scale) ^ (sign);                \
    s += stride;                                                        \
  }                                                                     \
}                                                                       \
static void pack_ ##name (const GstAudioFormatInfo *info,               \
    GstAudioPackFlags flags, const gpointer src,                        \
    gpointer data, gint length)                                         \
{                                                                       \
  gint32 tmp;                                                           \
  guint32 *s = src;                                                     \
  guint8 *d = data;                                                     \
  for (;length; length--) {                                             \
    tmp = (*s++ ^ (sign)) >> scale;                                     \
    WRITE_FUNC (d, tmp);                                                \
    d += stride;                                                        \
  }                                                                     \
}
#define PACK_S24LE GST_AUDIO_FORMAT_S32, unpack_s24le, pack_s24le
    MAKE_PACK_UNPACK (s24le, 3, 0, 8, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_U24LE GST_AUDIO_FORMAT_S32, unpack_u24le, pack_u24le
    MAKE_PACK_UNPACK (u24le, 3, SIGNED, 8, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_S24BE GST_AUDIO_FORMAT_S32, unpack_s24be, pack_s24be
    MAKE_PACK_UNPACK (s24be, 3, 0, 8, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_U24BE GST_AUDIO_FORMAT_S32, unpack_u24be, pack_u24be
    MAKE_PACK_UNPACK (u24be, 3, SIGNED, 8, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_S20LE GST_AUDIO_FORMAT_S32, unpack_s20le, pack_s20le
    MAKE_PACK_UNPACK (s20le, 3, 0, 12, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_U20LE GST_AUDIO_FORMAT_S32, unpack_u20le, pack_u20le
    MAKE_PACK_UNPACK (u20le, 3, SIGNED, 12, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_S20BE GST_AUDIO_FORMAT_S32, unpack_s20be, pack_s20be
    MAKE_PACK_UNPACK (s20be, 3, 0, 12, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_U20BE GST_AUDIO_FORMAT_S32, unpack_u20be, pack_u20be
    MAKE_PACK_UNPACK (u20be, 3, SIGNED, 12, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_S18LE GST_AUDIO_FORMAT_S32, unpack_s18le, pack_s18le
    MAKE_PACK_UNPACK (s18le, 3, 0, 14, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_U18LE GST_AUDIO_FORMAT_S32, unpack_u18le, pack_u18le
    MAKE_PACK_UNPACK (u18le, 3, SIGNED, 14, READ24_FROM_LE, WRITE24_TO_LE)
#define PACK_S18BE GST_AUDIO_FORMAT_S32, unpack_s18be, pack_s18be
    MAKE_PACK_UNPACK (s18be, 3, 0, 14, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_U18BE GST_AUDIO_FORMAT_S32, unpack_u18be, pack_u18be
    MAKE_PACK_UNPACK (u18be, 3, SIGNED, 14, READ24_FROM_BE, WRITE24_TO_BE)
#define PACK_F32LE GST_AUDIO_FORMAT_F64, unpack_f32le, pack_f32le
    MAKE_ORC_PACK_UNPACK (f32le)
#define PACK_F32BE GST_AUDIO_FORMAT_F64, unpack_f32be, pack_f32be
    MAKE_ORC_PACK_UNPACK (f32be)
#define PACK_F64LE GST_AUDIO_FORMAT_F64, unpack_f64le, pack_f64le
    MAKE_ORC_PACK_UNPACK (f64le)
#define PACK_F64BE GST_AUDIO_FORMAT_F64, unpack_f64be, pack_f64be
    MAKE_ORC_PACK_UNPACK (f64be)
#define SINT (GST_AUDIO_FORMAT_FLAG_INTEGER | GST_AUDIO_FORMAT_FLAG_SIGNED)
#define SINT_PACK (SINT | GST_AUDIO_FORMAT_FLAG_UNPACK)
#define UINT (GST_AUDIO_FORMAT_FLAG_INTEGER)
#define FLOAT (GST_AUDIO_FORMAT_FLAG_FLOAT)
#define FLOAT_PACK (FLOAT | GST_AUDIO_FORMAT_FLAG_UNPACK)
#define MAKE_FORMAT(str,desc,flags,end,width,depth,silent, pack) \
  { GST_AUDIO_FORMAT_ ##str, G_STRINGIFY(str), desc, flags, end, width, depth, silent, pack }
#define SILENT_0         { 0, 0, 0, 0, 0, 0, 0, 0 }
#define SILENT_U8        { 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 }
#define SILENT_U16LE     { 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80 }
#define SILENT_U16BE     { 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00 }
#define SILENT_U24_32LE  { 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00 }
#define SILENT_U24_32BE  { 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00 }
#define SILENT_U32LE     { 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80 }
#define SILENT_U32BE     { 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00 }
#define SILENT_U24LE     { 0x00, 0x00, 0x80, 0x00, 0x00, 0x80 }
#define SILENT_U24BE     { 0x80, 0x00, 0x00, 0x80, 0x00, 0x00 }
#define SILENT_U20LE     { 0x00, 0x00, 0x08, 0x00, 0x00, 0x08 }
#define SILENT_U20BE     { 0x08, 0x00, 0x00, 0x08, 0x00, 0x00 }
#define SILENT_U18LE     { 0x00, 0x00, 0x02, 0x00, 0x00, 0x02 }
#define SILENT_U18BE     { 0x02, 0x00, 0x00, 0x02, 0x00, 0x00 }
     static GstAudioFormatInfo formats[] = {
       {GST_AUDIO_FORMAT_UNKNOWN, "UNKNOWN", "Unknown audio", 0, 0, 0, 0},
       {GST_AUDIO_FORMAT_ENCODED, "ENCODED", "Encoded audio",
           GST_AUDIO_FORMAT_FLAG_COMPLEX, 0, 0, 0},
       /* 8 bit */
       MAKE_FORMAT (S8, "8-bit signed PCM audio", SINT, 0, 8, 8, SILENT_0,
           PACK_S8),
       MAKE_FORMAT (U8, "8-bit unsigned PCM audio", UINT, 0, 8, 8, SILENT_U8,
           PACK_U8),
       /* 16 bit */
       MAKE_FORMAT (S16LE, "16-bit signed PCM audio", SINT, G_LITTLE_ENDIAN, 16,
           16,
           SILENT_0, PACK_S16LE),
       MAKE_FORMAT (S16BE, "16-bit signed PCM audio", SINT, G_BIG_ENDIAN, 16,
           16,
           SILENT_0, PACK_S16BE),
       MAKE_FORMAT (U16LE, "16-bit unsigned PCM audio", UINT, G_LITTLE_ENDIAN,
           16,
           16, SILENT_U16LE, PACK_U16LE),
       MAKE_FORMAT (U16BE, "16-bit unsigned PCM audio", UINT, G_BIG_ENDIAN, 16,
           16,
           SILENT_U16BE, PACK_U16BE),
       /* 24 bit in low 3 bytes of 32 bits */
       MAKE_FORMAT (S24_32LE, "24-bit signed PCM audio", SINT, G_LITTLE_ENDIAN,
           32,
           24, SILENT_0, PACK_S24_32LE),
       MAKE_FORMAT (S24_32BE, "24-bit signed PCM audio", SINT, G_BIG_ENDIAN, 32,
           24,
           SILENT_0, PACK_S24_32BE),
       MAKE_FORMAT (U24_32LE, "24-bit unsigned PCM audio", UINT,
           G_LITTLE_ENDIAN, 32,
           24, SILENT_U24_32LE, PACK_U24_32LE),
       MAKE_FORMAT (U24_32BE, "24-bit unsigned PCM audio", UINT, G_BIG_ENDIAN,
           32,
           24, SILENT_U24_32BE, PACK_U24_32BE),
       /* 32 bit */
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
       MAKE_FORMAT (S32LE, "32-bit signed PCM audio", SINT_PACK,
           G_LITTLE_ENDIAN, 32,
           32, SILENT_0, PACK_S32LE),
       MAKE_FORMAT (S32BE, "32-bit signed PCM audio", SINT, G_BIG_ENDIAN, 32,
           32,
           SILENT_0, PACK_S32BE),
#else
       MAKE_FORMAT (S32LE, "32-bit signed PCM audio", SINT, G_LITTLE_ENDIAN, 32,
           32,
           SILENT_0, PACK_S32LE),
       MAKE_FORMAT (S32BE, "32-bit signed PCM audio", SINT_PACK, G_BIG_ENDIAN,
           32,
           32,
           SILENT_0, PACK_S32BE),
#endif
       MAKE_FORMAT (U32LE, "32-bit unsigned PCM audio", UINT, G_LITTLE_ENDIAN,
           32,
           32, SILENT_U32LE, PACK_U32LE),
       MAKE_FORMAT (U32BE, "32-bit unsigned PCM audio", UINT, G_BIG_ENDIAN, 32,
           32,
           SILENT_U32BE, PACK_U32BE),
       /* 24 bit in 3 bytes */
       MAKE_FORMAT (S24LE, "24-bit signed PCM audio", SINT, G_LITTLE_ENDIAN, 24,
           24,
           SILENT_0, PACK_S24LE),
       MAKE_FORMAT (S24BE, "24-bit signed PCM audio", SINT, G_BIG_ENDIAN, 24,
           24,
           SILENT_0, PACK_S24BE),
       MAKE_FORMAT (U24LE, "24-bit unsigned PCM audio", UINT, G_LITTLE_ENDIAN,
           24,
           24, SILENT_U24LE, PACK_U24LE),
       MAKE_FORMAT (U24BE, "24-bit unsigned PCM audio", UINT, G_BIG_ENDIAN, 24,
           24,
           SILENT_U24BE, PACK_U24BE),
       /* 20 bit in 3 bytes */
       MAKE_FORMAT (S20LE, "20-bit signed PCM audio", SINT, G_LITTLE_ENDIAN, 24,
           20,
           SILENT_0, PACK_S20LE),
       MAKE_FORMAT (S20BE, "20-bit signed PCM audio", SINT, G_BIG_ENDIAN, 24,
           20,
           SILENT_0, PACK_S20BE),
       MAKE_FORMAT (U20LE, "20-bit unsigned PCM audio", UINT, G_LITTLE_ENDIAN,
           24,
           20, SILENT_U20LE, PACK_U20LE),
       MAKE_FORMAT (U20BE, "20-bit unsigned PCM audio", UINT, G_BIG_ENDIAN, 24,
           20,
           SILENT_U20BE, PACK_U20BE),
       /* 18 bit in 3 bytes */
       MAKE_FORMAT (S18LE, "18-bit signed PCM audio", SINT, G_LITTLE_ENDIAN, 24,
           18,
           SILENT_0, PACK_S18LE),
       MAKE_FORMAT (S18BE, "18-bit signed PCM audio", SINT, G_BIG_ENDIAN, 24,
           18,
           SILENT_0, PACK_S18BE),
       MAKE_FORMAT (U18LE, "18-bit unsigned PCM audio", UINT, G_LITTLE_ENDIAN,
           24,
           18, SILENT_U18LE, PACK_U18LE),
       MAKE_FORMAT (U18BE, "18-bit unsigned PCM audio", UINT, G_BIG_ENDIAN, 24,
           18,
           SILENT_U18BE, PACK_U18BE),
       /* float */
       MAKE_FORMAT (F32LE, "32-bit floating-point audio",
           GST_AUDIO_FORMAT_FLAG_FLOAT, G_LITTLE_ENDIAN, 32, 32, SILENT_0,
           PACK_F32LE),
       MAKE_FORMAT (F32BE, "32-bit floating-point audio",
           GST_AUDIO_FORMAT_FLAG_FLOAT, G_BIG_ENDIAN, 32, 32, SILENT_0,
           PACK_F32BE),
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
       MAKE_FORMAT (F64LE, "64-bit floating-point audio",
           FLOAT_PACK, G_LITTLE_ENDIAN, 64, 64, SILENT_0, PACK_F64LE),
       MAKE_FORMAT (F64BE, "64-bit floating-point audio",
           FLOAT, G_BIG_ENDIAN, 64, 64, SILENT_0, PACK_F64BE)
#else
       MAKE_FORMAT (F64LE, "64-bit floating-point audio",
           FLOAT, G_LITTLE_ENDIAN, 64, 64, SILENT_0, PACK_F64LE),
       MAKE_FORMAT (F64BE, "64-bit floating-point audio",
           FLOAT_PACK, G_BIG_ENDIAN, 64, 64, SILENT_0, PACK_F64BE)
#endif
     };

G_DEFINE_POINTER_TYPE (GstAudioFormatInfo, gst_audio_format_info);

/**
 * gst_audio_format_build_integer:
 * @sign: signed or unsigned format
 * @endianness: G_LITTLE_ENDIAN or G_BIG_ENDIAN
 * @width: amount of bits used per sample
 * @depth: amount of used bits in @width
 *
 * Construct a #GstAudioFormat with given parameters.
 *
 * Returns: a #GstAudioFormat or GST_AUDIO_FORMAT_UNKNOWN when no audio format
 * exists with the given parameters.
 */
GstAudioFormat
gst_audio_format_build_integer (gboolean sign, gint endianness,
    gint width, gint depth)
{
  gint i, e;

  for (i = 0; i < G_N_ELEMENTS (formats); i++) {
    GstAudioFormatInfo *finfo = &formats[i];

    /* must be int */
    if (!GST_AUDIO_FORMAT_INFO_IS_INTEGER (finfo))
      continue;

    /* width and depth must match */
    if (width != GST_AUDIO_FORMAT_INFO_WIDTH (finfo))
      continue;
    if (depth != GST_AUDIO_FORMAT_INFO_DEPTH (finfo))
      continue;

    /* if there is endianness, it must match */
    e = GST_AUDIO_FORMAT_INFO_ENDIANNESS (finfo);
    if (e && e != endianness)
      continue;

    /* check sign */
    if ((sign && !GST_AUDIO_FORMAT_INFO_IS_SIGNED (finfo)) ||
        (!sign && GST_AUDIO_FORMAT_INFO_IS_SIGNED (finfo)))
      continue;

    return GST_AUDIO_FORMAT_INFO_FORMAT (finfo);
  }
  return GST_AUDIO_FORMAT_UNKNOWN;
}

/**
 * gst_audio_format_from_string:
 * @format: a format string
 *
 * Convert the @format string to its #GstAudioFormat.
 *
 * Returns: the #GstAudioFormat for @format or GST_AUDIO_FORMAT_UNKNOWN when the
 * string is not a known format.
 */
GstAudioFormat
gst_audio_format_from_string (const gchar * format)
{
  guint i;

  g_return_val_if_fail (format != NULL, GST_AUDIO_FORMAT_UNKNOWN);

  for (i = 0; i < G_N_ELEMENTS (formats); i++) {
    if (strcmp (GST_AUDIO_FORMAT_INFO_NAME (&formats[i]), format) == 0)
      return GST_AUDIO_FORMAT_INFO_FORMAT (&formats[i]);
  }
  return GST_AUDIO_FORMAT_UNKNOWN;
}

const gchar *
gst_audio_format_to_string (GstAudioFormat format)
{
  g_return_val_if_fail (format != GST_AUDIO_FORMAT_UNKNOWN, NULL);

  if ((gint) format >= G_N_ELEMENTS (formats))
    return NULL;

  return GST_AUDIO_FORMAT_INFO_NAME (&formats[format]);
}

/**
 * gst_audio_format_get_info:
 * @format: a #GstAudioFormat
 *
 * Get the #GstAudioFormatInfo for @format
 *
 * Returns: The #GstAudioFormatInfo for @format.
 */
const GstAudioFormatInfo *
gst_audio_format_get_info (GstAudioFormat format)
{
  g_return_val_if_fail ((gint) format < G_N_ELEMENTS (formats), NULL);

  return &formats[format];
}

/**
 * gst_audio_format_fill_silence:
 * @info: a #GstAudioFormatInfo
 * @dest: (array length=length) (element-type guint8): a destination
 *   to fill
 * @length: the length to fill
 *
 * Fill @length bytes in @dest with silence samples for @info.
 */
void
gst_audio_format_fill_silence (const GstAudioFormatInfo * info,
    gpointer dest, gsize length)
{
  guint8 *dptr = dest;

  g_return_if_fail (info != NULL);
  g_return_if_fail (dest != NULL);

  if (info->flags & GST_AUDIO_FORMAT_FLAG_FLOAT ||
      info->flags & GST_AUDIO_FORMAT_FLAG_SIGNED) {
    /* float or signed always 0 */
    orc_memset (dest, 0, length);
  } else {
    gint i, j, bps = info->width >> 3;

    switch (bps) {
      case 1:
        orc_memset (dest, info->silence[0], length);
        break;
      case 2:{
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
        guint16 silence = GST_READ_UINT16_LE (info->silence);
#else
        guint16 silence = GST_READ_UINT16_BE (info->silence);
#endif
        audio_orc_splat_u16 (dest, silence, length / bps);
        break;
      }
      case 4:{
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
        guint32 silence = GST_READ_UINT32_LE (info->silence);
#else
        guint32 silence = GST_READ_UINT32_BE (info->silence);
#endif
        audio_orc_splat_u32 (dest, silence, length / bps);
        break;
      }
      case 8:{
#if G_BYTE_ORDER == G_LITTLE_ENDIAN
        guint64 silence = GST_READ_UINT64_LE (info->silence);
#else
        guint64 silence = GST_READ_UINT64_BE (info->silence);
#endif
        audio_orc_splat_u64 (dest, silence, length / bps);
        break;
      }
      default:
        for (i = 0; i < length; i += bps) {
          for (j = 0; j < bps; j++)
            *dptr++ = info->silence[j];
        }
        break;
    }
  }
}
