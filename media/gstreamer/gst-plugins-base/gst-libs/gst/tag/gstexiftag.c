/* GStreamer
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
 *
 * gstexiftag.c: library for reading / modifying exif tags
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
 * SECTION:gsttagexif
 * @short_description: tag mappings and support functions for plugins
 *                     dealing with exif tags
 * @see_also: #GstTagList
 *
 * Contains utility function to parse #GstTagList<!-- -->s from exif
 * buffers and to create exif buffers from #GstTagList<!-- -->s
 *
 * Note that next IFD fields on the created exif buffers are set to 0.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <gst/gsttagsetter.h>
#include <gst/base/gstbytewriter.h>
#include "gsttageditingprivate.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gst/math-compat.h>

/* Some useful constants */
#define TIFF_LITTLE_ENDIAN  0x4949
#define TIFF_BIG_ENDIAN     0x4D4D
#define TIFF_HEADER_SIZE    8
#define EXIF_TAG_ENTRY_SIZE (2 + 2 + 4 + 4)

/* Exif tag types */
#define EXIF_TYPE_BYTE       1
#define EXIF_TYPE_ASCII      2
#define EXIF_TYPE_SHORT      3
#define EXIF_TYPE_LONG       4
#define EXIF_TYPE_RATIONAL   5
#define EXIF_TYPE_UNDEFINED  7
#define EXIF_TYPE_SLONG      9
#define EXIF_TYPE_SRATIONAL 10

typedef struct _GstExifTagMatch GstExifTagMatch;
typedef struct _GstExifWriter GstExifWriter;
typedef struct _GstExifReader GstExifReader;
typedef struct _GstExifTagData GstExifTagData;

typedef void (*GstExifSerializationFunc) (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag);

/*
 * Function used to deserialize tags that don't follow the usual
 * deserialization conversions. Usually those that have 'Ref' complementary
 * tags.
 *
 * Those functions receive a exif tag data in the parameters, plus the taglist
 * and the reader and buffer if they need to get more information to build
 * its tags. There are lots of parameters, but this is needed to make it
 * versatile. Explanation of them follows:
 *
 * exif_reader: The #GstExifReader with the reading parameter and taglist for
 * results.
 * reader: The #GstByteReader pointing to the start of the next tag entry in
 * the ifd, useful for tags that use other complementary tags.
 * the buffer start
 * exiftag: The #GstExifTagMatch that contains this tag info
 * tagdata: values from the already parsed tag
 */
typedef gint (*GstExifDeserializationFunc) (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata);

#define EXIF_SERIALIZATION_FUNC(name) \
static void serialize_ ## name (GstExifWriter * writer, \
    const GstTagList * taglist, const GstExifTagMatch * exiftag)

#define EXIF_DESERIALIZATION_FUNC(name) \
static gint deserialize_ ## name (GstExifReader * exif_reader, \
    GstByteReader * reader, const GstExifTagMatch * exiftag, \
    GstExifTagData * tagdata)

#define EXIF_SERIALIZATION_DESERIALIZATION_FUNC(name) \
  EXIF_SERIALIZATION_FUNC (name); \
  EXIF_DESERIALIZATION_FUNC (name)

/*
 * A common case among serialization/deserialization routines is that
 * the gstreamer tag is a string (with a predefined set of allowed values)
 * and exif is an int. These macros cover these cases
 */
#define EXIF_SERIALIZATION_MAP_STRING_TO_INT_FUNC(name,funcname) \
static void \
serialize_ ## name (GstExifWriter * writer, const GstTagList * taglist, \
    const GstExifTagMatch * exiftag) \
{ \
  gchar *str = NULL; \
  gint exif_value; \
\
  if (!gst_tag_list_get_string_index (taglist, exiftag->gst_tag, 0, &str)) { \
    GST_WARNING ("No %s tag present in taglist", exiftag->gst_tag); \
    return; \
  } \
\
  exif_value = __exif_tag_ ## funcname ## _to_exif_value (str); \
  if (exif_value == -1) { \
    g_free (str); \
    return; \
  } \
  g_free (str); \
\
  switch (exiftag->exif_type) { \
    case EXIF_TYPE_SHORT: \
      gst_exif_writer_write_short_tag (writer, exiftag->exif_tag, exif_value); \
      break; \
    case EXIF_TYPE_LONG: \
      gst_exif_writer_write_long_tag (writer, exiftag->exif_tag, exif_value); \
      break; \
    case EXIF_TYPE_UNDEFINED: \
    { \
        guint8 data = (guint8) exif_value; \
        write_exif_undefined_tag (writer, exiftag->exif_tag, &data, 1); \
    } \
      break; \
    default: \
      g_assert_not_reached (); \
      GST_WARNING ("Unmapped serialization for type %d", exiftag->exif_type); \
      break; \
   } \
}

#define EXIF_DESERIALIZATION_MAP_STRING_TO_INT_FUNC(name,funcname) \
static gint \
deserialize_ ## name (GstExifReader * exif_reader, \
    GstByteReader * reader, const GstExifTagMatch * exiftag, \
    GstExifTagData * tagdata) \
{ \
  const gchar *str = NULL; \
  gint value; \
\
  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag, \
      exiftag->exif_tag); \
\
  /* validate tag */ \
  if (tagdata->count != 1) { \
    GST_WARNING ("0x%X has unexpected count", tagdata->count); \
    return 0; \
  } \
\
  if (tagdata->tag_type == EXIF_TYPE_SHORT) { \
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) { \
      value = GST_READ_UINT16_LE (tagdata->offset_as_data); \
    } else { \
      value = GST_READ_UINT16_BE (tagdata->offset_as_data); \
    } \
  } else if (tagdata->tag_type == EXIF_TYPE_UNDEFINED) { \
    value = GST_READ_UINT8 (tagdata->offset_as_data); \
  } else { \
    GST_WARNING ("0x%X has unexpected type %d", exiftag->exif_tag, \
        tagdata->tag_type); \
    return 0; \
  } \
\
  str = __exif_tag_## funcname ## _from_exif_value (value); \
  if (str == NULL) { \
    GST_WARNING ("Invalid value for tag 0x%X: %d", tagdata->tag, value); \
    return 0; \
  } \
  gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE, \
      exiftag->gst_tag, str, NULL); \
\
  return 0; \
}

#define EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC(name,funcname) \
  EXIF_SERIALIZATION_MAP_STRING_TO_INT_FUNC(name,funcname); \
  EXIF_DESERIALIZATION_MAP_STRING_TO_INT_FUNC(name,funcname);

struct _GstExifTagMatch
{
  const gchar *gst_tag;
  guint16 exif_tag;
  guint16 exif_type;

  /* for tags that need special handling */
  guint16 complementary_tag;
  GstExifSerializationFunc serialize;
  GstExifDeserializationFunc deserialize;
};

struct _GstExifTagData
{
  guint16 tag;
  guint16 tag_type;
  guint32 count;
  guint32 offset;
  const guint8 *offset_as_data;
};

/*
 * Holds the info and variables necessary to write
 * the exif tags properly
 */
struct _GstExifWriter
{
  GstByteWriter tagwriter;
  GstByteWriter datawriter;

  gint byte_order;
  guint tags_total;
};

struct _GstExifReader
{
  GstTagList *taglist;
  GstBuffer *buffer;
  guint32 base_offset;
  gint byte_order;

  /* tags waiting for their complementary tags */
  GSList *pending_tags;
};

EXIF_SERIALIZATION_DESERIALIZATION_FUNC (aperture_value);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (contrast);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (exposure_program);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (exposure_mode);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (flash);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (gain_control);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (geo_coordinate);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (geo_direction);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (geo_elevation);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (metering_mode);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (orientation);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (saturation);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (scene_capture_type);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (scene_type);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (sensitivity_type);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (sharpness);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (shutter_speed);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (source);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (speed);
EXIF_SERIALIZATION_DESERIALIZATION_FUNC (white_balance);

EXIF_DESERIALIZATION_FUNC (resolution);
EXIF_DESERIALIZATION_FUNC (add_to_pending_tags);

/* FIXME copyright tag has a weird "artist\0editor\0" format that is
 * not yet handled */

/* exif tag numbers */
#define EXIF_TAG_GPS_LATITUDE_REF 0x1
#define EXIF_TAG_GPS_LATITUDE 0x2
#define EXIF_TAG_GPS_LONGITUDE_REF 0x3
#define EXIF_TAG_GPS_LONGITUDE 0x4
#define EXIF_TAG_GPS_ALTITUDE_REF 0x5
#define EXIF_TAG_GPS_ALTITUDE 0x6
#define EXIF_TAG_GPS_SPEED_REF 0xC
#define EXIF_TAG_GPS_SPEED 0xD
#define EXIF_TAG_GPS_TRACK_REF 0xE
#define EXIF_TAG_GPS_TRACK 0xF
#define EXIF_TAG_GPS_IMAGE_DIRECTION_REF 0x10
#define EXIF_TAG_GPS_IMAGE_DIRECTION 0x11
#define EXIF_TAG_GPS_HORIZONTAL_POSITIONING_ERROR 0x1F
#define EXIF_TAG_IMAGE_DESCRIPTION 0x10E
#define EXIF_TAG_MAKE 0x10F
#define EXIF_TAG_MODEL 0x110
#define EXIF_TAG_ORIENTATION 0x112
#define EXIF_TAG_XRESOLUTION 0x11A
#define EXIF_TAG_YRESOLUTION 0x11B
#define EXIF_TAG_RESOLUTION_UNIT 0x128
#define EXIF_TAG_SOFTWARE 0x131
#define EXIF_TAG_DATE_TIME 0x132
#define EXIF_TAG_ARTIST 0x13B
#define EXIF_TAG_COPYRIGHT 0x8298
#define EXIF_TAG_EXPOSURE_TIME 0x829A
#define EXIF_TAG_F_NUMBER 0x829D
#define EXIF_TAG_EXPOSURE_PROGRAM 0x8822
#define EXIF_TAG_PHOTOGRAPHIC_SENSITIVITY 0x8827
#define EXIF_TAG_SENSITIVITY_TYPE 0x8830
#define EXIF_TAG_ISO_SPEED 0x8833
#define EXIF_TAG_DATE_TIME_ORIGINAL 0x9003
#define EXIF_TAG_DATE_TIME_DIGITIZED 0x9004
#define EXIF_TAG_SHUTTER_SPEED_VALUE 0x9201
#define EXIF_TAG_APERTURE_VALUE 0x9202
#define EXIF_TAG_EXPOSURE_BIAS 0x9204
#define EXIF_TAG_METERING_MODE 0x9207
#define EXIF_TAG_FLASH 0x9209
#define EXIF_TAG_FOCAL_LENGTH 0x920A
#define EXIF_TAG_MAKER_NOTE 0x927C
#define EXIF_TAG_FILE_SOURCE 0xA300
#define EXIF_TAG_SCENE_TYPE 0xA301
#define EXIF_TAG_EXPOSURE_MODE 0xA402
#define EXIF_TAG_WHITE_BALANCE 0xA403
#define EXIF_TAG_DIGITAL_ZOOM_RATIO 0xA404
#define EXIF_TAG_SCENE_CAPTURE_TYPE 0xA406
#define EXIF_TAG_GAIN_CONTROL 0xA407
#define EXIF_TAG_CONTRAST 0xA408
#define EXIF_TAG_SATURATION 0xA409
#define EXIF_TAG_SHARPNESS 0xA40A

/* IFD pointer tags */
#define EXIF_IFD_TAG 0x8769
#define EXIF_GPS_IFD_TAG 0x8825

/* version tags */
#define EXIF_VERSION_TAG 0x9000
#define EXIF_FLASHPIX_VERSION_TAG 0xA000

/* useful macros for speed tag */
#define METERS_PER_SECOND_TO_KILOMETERS_PER_HOUR (3.6)
#define KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND (1/3.6)
#define MILES_PER_HOUR_TO_METERS_PER_SECOND (0.44704)
#define KNOTS_TO_METERS_PER_SECOND (0.514444)

/*
 * Should be kept in ascending id order
 *
 * {gst-tag, exif-tag, exig-type, complementary-exif-tag, serialization-func,
 *     deserialization-func}
 */
static const GstExifTagMatch tag_map_ifd0[] = {
  {GST_TAG_IMAGE_HORIZONTAL_PPI, EXIF_TAG_XRESOLUTION, EXIF_TYPE_RATIONAL,
      0, NULL, deserialize_add_to_pending_tags},
  {GST_TAG_IMAGE_VERTICAL_PPI, EXIF_TAG_YRESOLUTION, EXIF_TYPE_RATIONAL,
      0, NULL, deserialize_add_to_pending_tags},
  {NULL, EXIF_TAG_RESOLUTION_UNIT, EXIF_TYPE_SHORT, 0, NULL,
      deserialize_resolution},
  {GST_TAG_DESCRIPTION, EXIF_TAG_IMAGE_DESCRIPTION, EXIF_TYPE_ASCII, 0, NULL,
      NULL},
  {GST_TAG_DEVICE_MANUFACTURER, EXIF_TAG_MAKE, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {GST_TAG_DEVICE_MODEL, EXIF_TAG_MODEL, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {GST_TAG_IMAGE_ORIENTATION, EXIF_TAG_ORIENTATION, EXIF_TYPE_SHORT, 0,
        serialize_orientation,
      deserialize_orientation},
  {GST_TAG_APPLICATION_NAME, EXIF_TAG_SOFTWARE, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {GST_TAG_DATE_TIME, EXIF_TAG_DATE_TIME, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {GST_TAG_ARTIST, EXIF_TAG_ARTIST, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {GST_TAG_COPYRIGHT, EXIF_TAG_COPYRIGHT, EXIF_TYPE_ASCII, 0, NULL, NULL},
  {NULL, EXIF_IFD_TAG, EXIF_TYPE_LONG, 0, NULL, NULL},
  {NULL, EXIF_GPS_IFD_TAG, EXIF_TYPE_LONG, 0, NULL, NULL},
  {NULL, 0, 0, 0, NULL, NULL}
};

static const GstExifTagMatch tag_map_exif[] = {
  {GST_TAG_CAPTURING_SHUTTER_SPEED, EXIF_TAG_EXPOSURE_TIME, EXIF_TYPE_RATIONAL,
        0,
      NULL, NULL},
  {GST_TAG_CAPTURING_FOCAL_RATIO, EXIF_TAG_F_NUMBER, EXIF_TYPE_RATIONAL, 0,
        NULL,
      NULL},
  {GST_TAG_CAPTURING_EXPOSURE_PROGRAM, EXIF_TAG_EXPOSURE_PROGRAM,
        EXIF_TYPE_SHORT, 0, serialize_exposure_program,
      deserialize_exposure_program},

  /* don't need the serializer as we always write the iso speed alone */
  {GST_TAG_CAPTURING_ISO_SPEED, EXIF_TAG_PHOTOGRAPHIC_SENSITIVITY,
        EXIF_TYPE_SHORT, 0, NULL,
      deserialize_add_to_pending_tags},

  {GST_TAG_CAPTURING_ISO_SPEED, EXIF_TAG_SENSITIVITY_TYPE, EXIF_TYPE_SHORT, 0,
      serialize_sensitivity_type, deserialize_sensitivity_type},
  {GST_TAG_CAPTURING_ISO_SPEED, EXIF_TAG_ISO_SPEED, EXIF_TYPE_LONG, 0, NULL,
      NULL},
  {NULL, EXIF_VERSION_TAG, EXIF_TYPE_UNDEFINED, 0, NULL, NULL},
  {GST_TAG_DATE_TIME, EXIF_TAG_DATE_TIME_ORIGINAL, EXIF_TYPE_ASCII, 0, NULL,
      NULL},
  {GST_TAG_CAPTURING_SHUTTER_SPEED, EXIF_TAG_SHUTTER_SPEED_VALUE,
        EXIF_TYPE_SRATIONAL, 0,
      serialize_shutter_speed, deserialize_shutter_speed},
  {GST_TAG_CAPTURING_FOCAL_RATIO, EXIF_TAG_APERTURE_VALUE, EXIF_TYPE_RATIONAL,
        0,
      serialize_aperture_value, deserialize_aperture_value},
  {GST_TAG_CAPTURING_EXPOSURE_COMPENSATION, EXIF_TAG_EXPOSURE_BIAS,
      EXIF_TYPE_SRATIONAL, 0, NULL, NULL},
  {GST_TAG_CAPTURING_METERING_MODE, EXIF_TAG_METERING_MODE, EXIF_TYPE_SHORT, 0,
      serialize_metering_mode, deserialize_metering_mode},
  {GST_TAG_CAPTURING_FLASH_FIRED, EXIF_TAG_FLASH, EXIF_TYPE_SHORT, 0,
      serialize_flash, deserialize_flash},
  {GST_TAG_CAPTURING_FOCAL_LENGTH, EXIF_TAG_FOCAL_LENGTH, EXIF_TYPE_RATIONAL, 0,
      NULL, NULL},
  {GST_TAG_APPLICATION_DATA, EXIF_TAG_MAKER_NOTE, EXIF_TYPE_UNDEFINED, 0, NULL,
      NULL},
  {NULL, EXIF_FLASHPIX_VERSION_TAG, EXIF_TYPE_UNDEFINED, 0, NULL, NULL},
  {GST_TAG_CAPTURING_SOURCE, EXIF_TAG_FILE_SOURCE, EXIF_TYPE_UNDEFINED,
      0, serialize_source, deserialize_source},
  {GST_TAG_CAPTURING_SOURCE, EXIF_TAG_SCENE_TYPE, EXIF_TYPE_UNDEFINED,
      0, serialize_scene_type, deserialize_scene_type},
  {GST_TAG_CAPTURING_EXPOSURE_MODE, EXIF_TAG_EXPOSURE_MODE, EXIF_TYPE_SHORT,
      0, serialize_exposure_mode, deserialize_exposure_mode},
  {GST_TAG_CAPTURING_WHITE_BALANCE, EXIF_TAG_WHITE_BALANCE, EXIF_TYPE_SHORT,
      0, serialize_white_balance, deserialize_white_balance},
  {GST_TAG_CAPTURING_DIGITAL_ZOOM_RATIO, EXIF_TAG_DIGITAL_ZOOM_RATIO,
        EXIF_TYPE_RATIONAL, 0, NULL,
      NULL},
  {GST_TAG_CAPTURING_SCENE_CAPTURE_TYPE, EXIF_TAG_SCENE_CAPTURE_TYPE,
        EXIF_TYPE_SHORT, 0, serialize_scene_capture_type,
      deserialize_scene_capture_type},
  {GST_TAG_CAPTURING_GAIN_ADJUSTMENT, EXIF_TAG_GAIN_CONTROL,
        EXIF_TYPE_SHORT, 0, serialize_gain_control,
      deserialize_gain_control},
  {GST_TAG_CAPTURING_CONTRAST, EXIF_TAG_CONTRAST, EXIF_TYPE_SHORT, 0,
      serialize_contrast, deserialize_contrast},
  {GST_TAG_CAPTURING_SATURATION, EXIF_TAG_SATURATION, EXIF_TYPE_SHORT, 0,
      serialize_saturation, deserialize_saturation},
  {GST_TAG_CAPTURING_SHARPNESS, EXIF_TAG_SHARPNESS, EXIF_TYPE_SHORT, 0,
      serialize_sharpness, deserialize_sharpness},
  {NULL, 0, 0, 0, NULL, NULL}
};

static const GstExifTagMatch tag_map_gps[] = {
  {GST_TAG_GEO_LOCATION_LATITUDE, EXIF_TAG_GPS_LATITUDE, EXIF_TYPE_RATIONAL,
        EXIF_TAG_GPS_LATITUDE_REF,
      serialize_geo_coordinate, deserialize_geo_coordinate},
  {GST_TAG_GEO_LOCATION_LONGITUDE, EXIF_TAG_GPS_LONGITUDE, EXIF_TYPE_RATIONAL,
        EXIF_TAG_GPS_LONGITUDE_REF,
      serialize_geo_coordinate, deserialize_geo_coordinate},
  {GST_TAG_GEO_LOCATION_ELEVATION, EXIF_TAG_GPS_ALTITUDE, EXIF_TYPE_RATIONAL,
        EXIF_TAG_GPS_ALTITUDE_REF,
      serialize_geo_elevation, deserialize_geo_elevation},
  {GST_TAG_GEO_LOCATION_MOVEMENT_SPEED, EXIF_TAG_GPS_SPEED, EXIF_TYPE_RATIONAL,
        EXIF_TAG_GPS_SPEED_REF,
      serialize_speed, deserialize_speed},
  {GST_TAG_GEO_LOCATION_MOVEMENT_DIRECTION, EXIF_TAG_GPS_TRACK,
        EXIF_TYPE_RATIONAL, EXIF_TAG_GPS_TRACK_REF,
      serialize_geo_direction, deserialize_geo_direction},
  {GST_TAG_GEO_LOCATION_CAPTURE_DIRECTION, EXIF_TAG_GPS_IMAGE_DIRECTION,
        EXIF_TYPE_RATIONAL, EXIF_TAG_GPS_IMAGE_DIRECTION_REF,
      serialize_geo_direction, deserialize_geo_direction},
  {GST_TAG_GEO_LOCATION_HORIZONTAL_ERROR,
        EXIF_TAG_GPS_HORIZONTAL_POSITIONING_ERROR,
      EXIF_TYPE_RATIONAL, 0, NULL, NULL},
  {NULL, 0, 0, 0, NULL, NULL}
};

/* GstExifReader functions */
static void
gst_exif_reader_init (GstExifReader * reader, gint byte_order,
    GstBuffer * buf, guint32 base_offset)
{
  ensure_exif_tags ();

  reader->taglist = gst_tag_list_new_empty ();
  reader->buffer = buf;
  reader->base_offset = base_offset;
  reader->byte_order = byte_order;
  reader->pending_tags = NULL;
  if (reader->byte_order != G_LITTLE_ENDIAN &&
      reader->byte_order != G_BIG_ENDIAN) {
    GST_WARNING ("Unexpected byte order %d, using system default: %d",
        reader->byte_order, G_BYTE_ORDER);
    reader->byte_order = G_BYTE_ORDER;
  }
}

static void
gst_exif_reader_add_pending_tag (GstExifReader * reader, GstExifTagData * data)
{
  GstExifTagData *copy;

  copy = g_slice_new (GstExifTagData);
  memcpy (copy, data, sizeof (GstExifTagData));

  reader->pending_tags = g_slist_prepend (reader->pending_tags, copy);
}

static GstExifTagData *
gst_exif_reader_get_pending_tag (GstExifReader * reader, gint tagid)
{
  GSList *walker;

  for (walker = reader->pending_tags; walker; walker = g_slist_next (walker)) {
    GstExifTagData *data = (GstExifTagData *) walker->data;
    if (data->tag == tagid)
      return data;
  }

  return NULL;
}

static GstTagList *
gst_exif_reader_reset (GstExifReader * reader, gboolean return_taglist)
{
  GstTagList *ret = NULL;
  GSList *walker;

  for (walker = reader->pending_tags; walker; walker = g_slist_next (walker)) {
    GstExifTagData *data = (GstExifTagData *) walker->data;

    g_slice_free (GstExifTagData, data);
  }
  g_slist_free (reader->pending_tags);

  if (return_taglist) {
    ret = reader->taglist;
    reader->taglist = NULL;
  }

  if (reader->taglist) {
    gst_tag_list_unref (reader->taglist);
  }

  return ret;
}

/* GstExifWriter functions */

static void
gst_exif_writer_init (GstExifWriter * writer, gint byte_order)
{
  ensure_exif_tags ();

  gst_byte_writer_init (&writer->tagwriter);
  gst_byte_writer_init (&writer->datawriter);

  writer->byte_order = byte_order;
  writer->tags_total = 0;
  if (writer->byte_order != G_LITTLE_ENDIAN &&
      writer->byte_order != G_BIG_ENDIAN) {
    GST_WARNING ("Unexpected byte order %d, using system default: %d",
        writer->byte_order, G_BYTE_ORDER);
    writer->byte_order = G_BYTE_ORDER;
  }
}

static GstBuffer *
gst_exif_writer_reset_and_get_buffer (GstExifWriter * writer)
{
  GstBuffer *header;
  GstBuffer *data;

  header = gst_byte_writer_reset_and_get_buffer (&writer->tagwriter);
  data = gst_byte_writer_reset_and_get_buffer (&writer->datawriter);

  return gst_buffer_append (header, data);
}

/*
 * Given the exif tag with the passed id, returns the map index of the tag
 * corresponding to it. If use_complementary is true, then the complementary
 * are also used in the search.
 *
 * Returns -1 if not found
 */
static gint
exif_tag_map_find_reverse (guint16 exif_tag, const GstExifTagMatch * tag_map,
    gboolean use_complementary)
{
  gint i;

  for (i = 0; tag_map[i].exif_tag != 0; i++) {
    if (exif_tag == tag_map[i].exif_tag || (use_complementary &&
            exif_tag == tag_map[i].complementary_tag)) {
      return i;
    }
  }
  return -1;
}

static gboolean
gst_tag_list_has_ifd_tags (const GstTagList * taglist,
    const GstExifTagMatch * tag_map)
{
  gint i;

  for (i = 0; tag_map[i].exif_tag != 0; i++) {
    if (tag_map[i].gst_tag == NULL) {
      if (tag_map[i].exif_tag == EXIF_GPS_IFD_TAG &&
          gst_tag_list_has_ifd_tags (taglist, tag_map_gps))
        return TRUE;
      if (tag_map[i].exif_tag == EXIF_IFD_TAG &&
          gst_tag_list_has_ifd_tags (taglist, tag_map_exif))
        return TRUE;
      continue;
    }

    if (gst_tag_list_get_value_index (taglist, tag_map[i].gst_tag, 0)) {
      return TRUE;
    }
  }
  return FALSE;
}

/*
 * Writes the tag entry.
 *
 * The tag entry is the tag id, the tag type,
 * the count and the offset.
 *
 * The offset is the on the amount of data writen so far, as one
 * can't predict the total bytes that the tag entries will take.
 * This means those fields requires being updated later.
 */
static void
gst_exif_writer_write_tag_header (GstExifWriter * writer,
    guint16 exif_tag, guint16 exif_type, guint32 count, guint32 offset,
    const guint32 * offset_data)
{
  gboolean handled = TRUE;

  GST_DEBUG ("Writing tag entry: id %x, type %u, count %u, offset %u",
      exif_tag, exif_type, count, offset);

  if (writer->byte_order == G_LITTLE_ENDIAN) {
    handled &= gst_byte_writer_put_uint16_le (&writer->tagwriter, exif_tag);
    handled &= gst_byte_writer_put_uint16_le (&writer->tagwriter, exif_type);
    handled &= gst_byte_writer_put_uint32_le (&writer->tagwriter, count);
    if (offset_data != NULL) {
      handled &=
          gst_byte_writer_put_data (&writer->tagwriter, (guint8 *) offset_data,
          4);
    } else {
      handled &= gst_byte_writer_put_uint32_le (&writer->tagwriter, offset);
    }
  } else if (writer->byte_order == G_BIG_ENDIAN) {
    handled &= gst_byte_writer_put_uint16_be (&writer->tagwriter, exif_tag);
    handled &= gst_byte_writer_put_uint16_be (&writer->tagwriter, exif_type);
    handled &= gst_byte_writer_put_uint32_be (&writer->tagwriter, count);
    if (offset_data != NULL) {
      handled &=
          gst_byte_writer_put_data (&writer->tagwriter, (guint8 *) offset_data,
          4);
    } else {
      handled &= gst_byte_writer_put_uint32_be (&writer->tagwriter, offset);
    }
  } else {
    g_assert_not_reached ();
  }

  if (G_UNLIKELY (!handled))
    GST_WARNING ("Error writing tag header");

  writer->tags_total++;
}

static void
gst_exif_writer_write_rational_data (GstExifWriter * writer, guint32 frac_n,
    guint32 frac_d)
{
  gboolean handled = TRUE;

  if (writer->byte_order == G_LITTLE_ENDIAN) {
    handled &= gst_byte_writer_put_uint32_le (&writer->datawriter, frac_n);
    handled &= gst_byte_writer_put_uint32_le (&writer->datawriter, frac_d);
  } else {
    handled &= gst_byte_writer_put_uint32_be (&writer->datawriter, frac_n);
    handled &= gst_byte_writer_put_uint32_be (&writer->datawriter, frac_d);
  }

  if (G_UNLIKELY (!handled))
    GST_WARNING ("Error writing rational data");
}

static void
gst_exif_writer_write_signed_rational_data (GstExifWriter * writer,
    gint32 frac_n, gint32 frac_d)
{
  gboolean handled = TRUE;

  if (writer->byte_order == G_LITTLE_ENDIAN) {
    handled &= gst_byte_writer_put_int32_le (&writer->datawriter, frac_n);
    handled &= gst_byte_writer_put_int32_le (&writer->datawriter, frac_d);
  } else {
    handled &= gst_byte_writer_put_int32_be (&writer->datawriter, frac_n);
    handled &= gst_byte_writer_put_int32_be (&writer->datawriter, frac_d);
  }

  if (G_UNLIKELY (!handled))
    GST_WARNING ("Error writing signed rational data");
}

static void
gst_exif_writer_write_rational_tag (GstExifWriter * writer,
    guint16 tag, guint32 frac_n, guint32 frac_d)
{
  guint32 offset = gst_byte_writer_get_size (&writer->datawriter);

  gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_RATIONAL,
      1, offset, NULL);

  gst_exif_writer_write_rational_data (writer, frac_n, frac_d);
}

static void
gst_exif_writer_write_signed_rational_tag (GstExifWriter * writer,
    guint16 tag, gint32 frac_n, gint32 frac_d)
{
  guint32 offset = gst_byte_writer_get_size (&writer->datawriter);

  gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_SRATIONAL,
      1, offset, NULL);

  gst_exif_writer_write_signed_rational_data (writer, frac_n, frac_d);
}

static void
gst_exif_writer_write_rational_tag_from_double (GstExifWriter * writer,
    guint16 tag, gdouble value)
{
  gint frac_n;
  gint frac_d;

  gst_util_double_to_fraction (value, &frac_n, &frac_d);

  gst_exif_writer_write_rational_tag (writer, tag, frac_n, frac_d);
}

static void
gst_exif_writer_write_signed_rational_tag_from_double (GstExifWriter * writer,
    guint16 tag, gdouble value)
{
  gint frac_n;
  gint frac_d;

  gst_util_double_to_fraction (value, &frac_n, &frac_d);

  gst_exif_writer_write_signed_rational_tag (writer, tag, frac_n, frac_d);
}

static void
gst_exif_writer_write_byte_tag (GstExifWriter * writer, guint16 tag,
    guint8 value)
{
  guint32 offset = 0;

  GST_WRITE_UINT8 ((guint8 *) & offset, value);
  gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_BYTE,
      1, offset, &offset);
}

static void
gst_exif_writer_write_short_tag (GstExifWriter * writer, guint16 tag,
    guint16 value)
{
  guint32 offset = 0;

  if (writer->byte_order == G_LITTLE_ENDIAN) {
    GST_WRITE_UINT16_LE ((guint8 *) & offset, value);
  } else {
    GST_WRITE_UINT16_BE ((guint8 *) & offset, value);
  }

  gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_SHORT,
      1, offset, &offset);
}

static void
gst_exif_writer_write_long_tag (GstExifWriter * writer, guint16 tag,
    guint32 value)
{
  guint32 offset = 0;
  if (writer->byte_order == G_LITTLE_ENDIAN) {
    GST_WRITE_UINT32_LE ((guint8 *) & offset, value);
  } else {
    GST_WRITE_UINT32_BE ((guint8 *) & offset, value);
  }

  gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_LONG,
      1, offset, &offset);
}


static void
write_exif_undefined_tag (GstExifWriter * writer, guint16 tag,
    const guint8 * data, gint size)
{
  guint32 offset = 0;

  if (size > 4) {
    /* we only use the data offset here, later we add up the
     * resulting tag headers offset and the base offset */
    offset = gst_byte_writer_get_size (&writer->datawriter);
    gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_UNDEFINED,
        size, offset, NULL);
    if (!gst_byte_writer_put_data (&writer->datawriter, data, size)) {
      GST_WARNING ("Error writing undefined tag");
    }
  } else {
    /* small enough to go in the offset */
    memcpy ((guint8 *) & offset, data, size);
    gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_UNDEFINED,
        size, offset, &offset);
  }
}

static void
write_exif_ascii_tag (GstExifWriter * writer, guint16 tag, const gchar * str)
{
  guint32 offset = 0;
  gchar *ascii_str;
  gsize ascii_size;
  GError *error = NULL;

  ascii_str = g_convert (str, -1, "latin1", "utf8", NULL, &ascii_size, &error);

  if (error) {
    GST_WARNING ("Failed to convert exif tag to ascii: 0x%x - %s. Error: %s",
        tag, str, error->message);
    g_error_free (error);
    g_free (ascii_str);
    return;
  }

  /* add the \0 at the end */
  ascii_size++;

  if (ascii_size > 4) {
    /* we only use the data offset here, later we add up the
     * resulting tag headers offset and the base offset */
    offset = gst_byte_writer_get_size (&writer->datawriter);
    gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_ASCII,
        ascii_size, offset, NULL);
    gst_byte_writer_put_string (&writer->datawriter, ascii_str);
  } else {
    /* small enough to go in the offset */
    memcpy ((guint8 *) & offset, ascii_str, ascii_size);
    gst_exif_writer_write_tag_header (writer, tag, EXIF_TYPE_ASCII,
        ascii_size, offset, &offset);
  }

  g_free (ascii_str);
}

static void
write_exif_ascii_tag_from_taglist (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag)
{
  gchar *str = NULL;
  gboolean cleanup = FALSE;
  const GValue *value;
  gint tag_size = gst_tag_list_get_tag_size (taglist, exiftag->gst_tag);

  if (tag_size != 1) {
    /* FIXME support this by serializing them with a ','? */
    GST_WARNING ("Multiple string tags not supported yet");
    return;
  }

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);

  /* do some conversion if needed */
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_STRING:
      str = (gchar *) g_value_get_string (value);
      break;
    default:
      if (G_VALUE_TYPE (value) == GST_TYPE_DATE_TIME) {
        GstDateTime *dt = (GstDateTime *) g_value_get_boxed (value);

        if (dt == NULL) {
          GST_WARNING ("NULL datetime received");
          break;
        }

        str = g_strdup_printf ("%04d:%02d:%02d %02d:%02d:%02d",
            gst_date_time_get_year (dt), gst_date_time_get_month (dt),
            gst_date_time_get_day (dt), gst_date_time_get_hour (dt),
            gst_date_time_get_minute (dt), gst_date_time_get_second (dt));

        cleanup = TRUE;
      } else {
        GST_WARNING ("Conversion from %s to ascii string not supported",
            G_VALUE_TYPE_NAME (value));
      }
      break;
  }

  if (str == NULL)
    return;

  write_exif_ascii_tag (writer, exiftag->exif_tag, str);
  if (cleanup)
    g_free (str);
}

static void
write_exif_undefined_tag_from_taglist (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag)
{
  const GValue *value;
  GstMapInfo info;
  guint8 *data = NULL;
  gsize size = 0;
  gint tag_size = gst_tag_list_get_tag_size (taglist, exiftag->gst_tag);
  GstSample *sample = NULL;
  GstBuffer *buf = NULL;

  if (tag_size != 1) {
    GST_WARNING ("Only the first item in the taglist will be serialized");
    return;
  }

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);

  /* do some conversion if needed */
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_STRING:
      data = (guint8 *) g_value_get_string (value);
      size = strlen ((gchar *) data);   /* no need to +1, undefined doesn't require it */
      break;
    default:
      if (G_VALUE_TYPE (value) == GST_TYPE_SAMPLE) {
        sample = gst_value_get_sample (value);
        buf = gst_sample_get_buffer (sample);
        if (gst_buffer_map (buf, &info, GST_MAP_READ)) {
          data = info.data;
          size = info.size;
        } else {
          GST_WARNING ("Failed to map buffer for reading");
        }
      } else {
        GST_WARNING ("Conversion from %s to raw data not supported",
            G_VALUE_TYPE_NAME (value));
      }
      break;
  }

  if (size > 0)
    write_exif_undefined_tag (writer, exiftag->exif_tag, data, size);

  if (buf)
    gst_buffer_unmap (buf, &info);
}

static void
write_exif_rational_tag_from_taglist (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag)
{
  const GValue *value;
  gdouble num = 0;
  gint tag_size = gst_tag_list_get_tag_size (taglist, exiftag->gst_tag);

  if (tag_size != 1) {
    GST_WARNING ("Only the first item in the taglist will be serialized");
    return;
  }

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);

  /* do some conversion if needed */
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_DOUBLE:
      num = g_value_get_double (value);
      gst_exif_writer_write_rational_tag_from_double (writer, exiftag->exif_tag,
          num);
      break;
    default:
      if (G_VALUE_TYPE (value) == GST_TYPE_FRACTION) {
        gst_exif_writer_write_rational_tag (writer, exiftag->exif_tag,
            gst_value_get_fraction_numerator (value),
            gst_value_get_fraction_denominator (value));
      } else {
        GST_WARNING ("Conversion from %s to rational not supported",
            G_VALUE_TYPE_NAME (value));
      }
      break;
  }
}

static void
write_exif_signed_rational_tag_from_taglist (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag)
{
  const GValue *value;
  gdouble num = 0;
  gint tag_size = gst_tag_list_get_tag_size (taglist, exiftag->gst_tag);

  if (tag_size != 1) {
    GST_WARNING ("Only the first item in the taglist will be serialized");
    return;
  }

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);

  /* do some conversion if needed */
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_DOUBLE:
      num = g_value_get_double (value);
      gst_exif_writer_write_signed_rational_tag_from_double (writer,
          exiftag->exif_tag, num);
      break;
    default:
      if (G_VALUE_TYPE (value) == GST_TYPE_FRACTION) {
        gst_exif_writer_write_signed_rational_tag (writer, exiftag->exif_tag,
            gst_value_get_fraction_numerator (value),
            gst_value_get_fraction_denominator (value));
      } else {
        GST_WARNING ("Conversion from %s to signed rational not supported",
            G_VALUE_TYPE_NAME (value));
      }
      break;
  }
}

static void
write_exif_integer_tag_from_taglist (GstExifWriter * writer,
    const GstTagList * taglist, const GstExifTagMatch * exiftag)
{
  const GValue *value;
  guint32 num = 0;
  gint tag_size = gst_tag_list_get_tag_size (taglist, exiftag->gst_tag);

  if (tag_size != 1) {
    GST_WARNING ("Only the first item in the taglist will be serialized");
    return;
  }

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);

  /* do some conversion if needed */
  switch (G_VALUE_TYPE (value)) {
    case G_TYPE_INT:
      num = g_value_get_int (value);
      break;
    default:
      GST_WARNING ("Conversion from %s to int not supported",
          G_VALUE_TYPE_NAME (value));
      break;
  }

  switch (exiftag->exif_type) {
    case EXIF_TYPE_LONG:
      gst_exif_writer_write_long_tag (writer, exiftag->exif_tag, num);
      break;
    case EXIF_TYPE_SHORT:
      gst_exif_writer_write_short_tag (writer, exiftag->exif_tag, num);
      break;
    default:
      break;
  }
}

static void
write_exif_tag_from_taglist (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  GST_DEBUG ("Writing tag %s", exiftag->gst_tag);

  /* check for special handling */
  if (exiftag->serialize) {
    exiftag->serialize (writer, taglist, exiftag);
    return;
  }

  switch (exiftag->exif_type) {
    case EXIF_TYPE_ASCII:
      write_exif_ascii_tag_from_taglist (writer, taglist, exiftag);
      break;
    case EXIF_TYPE_UNDEFINED:
      write_exif_undefined_tag_from_taglist (writer, taglist, exiftag);
      break;
    case EXIF_TYPE_RATIONAL:
      write_exif_rational_tag_from_taglist (writer, taglist, exiftag);
      break;
    case EXIF_TYPE_SRATIONAL:
      write_exif_signed_rational_tag_from_taglist (writer, taglist, exiftag);
      break;
    case EXIF_TYPE_LONG:
    case EXIF_TYPE_SHORT:
      write_exif_integer_tag_from_taglist (writer, taglist, exiftag);
      break;
    default:
      GST_WARNING ("Unhandled tag type %d", exiftag->exif_type);
  }
}

static void
tagdata_copy (GstExifTagData * to, const GstExifTagData * from)
{
  to->tag = from->tag;
  to->tag_type = from->tag_type;
  to->count = from->count;
  to->offset = from->offset;
  to->offset_as_data = from->offset_as_data;
}

static void
gst_exif_tag_rewrite_offsets (GstByteWriter * writer, gint byte_order,
    guint32 offset, gint num_tags, GstByteWriter * inner_ifds_data)
{
  GstByteReader *reader;
  gint i;
  guint16 aux = G_MAXUINT16;
  gboolean handled = TRUE;

  GST_LOG ("Rewriting tag entries offsets");

  reader = (GstByteReader *) writer;

  if (num_tags == -1) {
    if (byte_order == G_LITTLE_ENDIAN) {
      handled &= gst_byte_reader_get_uint16_le (reader, &aux);
    } else {
      handled &= gst_byte_reader_get_uint16_be (reader, &aux);
    }
    if (aux == G_MAXUINT16) {
      GST_WARNING ("Failed to read number of tags, won't rewrite offsets");
      return;
    }
    num_tags = (gint) aux;
  }

  g_return_if_fail (num_tags != -1);

  GST_DEBUG ("number of tags %d", num_tags);

  for (i = 0; i < num_tags; i++) {
    guint16 type = 0;
    guint32 cur_offset = 0;
    gint byte_size = 0;
    guint32 count = 0;
    guint16 tag_id = 0;

    g_assert (gst_byte_writer_get_pos (writer) <
        gst_byte_writer_get_size (writer));

    /* read the type */
    if (byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_get_uint16_le (reader, &tag_id))
        break;
      if (!gst_byte_reader_get_uint16_le (reader, &type))
        break;
      if (!gst_byte_reader_get_uint32_le (reader, &count))
        break;
    } else {
      if (!gst_byte_reader_get_uint16_be (reader, &tag_id))
        break;
      if (!gst_byte_reader_get_uint16_be (reader, &type))
        break;
      if (!gst_byte_reader_get_uint32_be (reader, &count))
        break;
    }

    GST_LOG ("Parsed tag %x of type %u and count %u", tag_id, type, count);

    switch (type) {
      case EXIF_TYPE_BYTE:
      case EXIF_TYPE_ASCII:
      case EXIF_TYPE_UNDEFINED:
        byte_size = count;
        break;
      case EXIF_TYPE_SHORT:
        byte_size = count * 2;  /* 2 bytes */
        break;
      case EXIF_TYPE_LONG:
      case EXIF_TYPE_SLONG:
        byte_size = count * 4;  /* 4 bytes */
        break;
      case EXIF_TYPE_RATIONAL:
      case EXIF_TYPE_SRATIONAL:
        byte_size = count * 8;  /* 8 bytes */
        break;
      default:
        g_assert_not_reached ();
        break;
    }

    /* adjust the offset if needed */
    if (byte_size > 4 || tag_id == EXIF_GPS_IFD_TAG || tag_id == EXIF_IFD_TAG) {
      if (byte_order == G_LITTLE_ENDIAN) {
        if (gst_byte_reader_peek_uint32_le (reader, &cur_offset)) {
          handled &=
              gst_byte_writer_put_uint32_le (writer, cur_offset + offset);
        }
      } else {
        if (gst_byte_reader_peek_uint32_be (reader, &cur_offset)) {
          handled &=
              gst_byte_writer_put_uint32_be (writer, cur_offset + offset);
        }
      }
      GST_DEBUG ("Rewriting tag offset from %u to (%u + %u) %u",
          cur_offset, cur_offset, offset, cur_offset + offset);

      if ((tag_id == EXIF_GPS_IFD_TAG || tag_id == EXIF_IFD_TAG) &&
          inner_ifds_data != NULL) {
        /* needs special handling */
        if (!gst_byte_writer_set_pos (inner_ifds_data, cur_offset)) {
          GST_WARNING ("Failed to position writer to rewrite inner ifd "
              "offsets");
          continue;
        }

        gst_exif_tag_rewrite_offsets (inner_ifds_data, byte_order, offset, -1,
            NULL);
      }
    } else {
      handled &= gst_byte_reader_skip (reader, 4);
      GST_DEBUG ("No need to rewrite tag offset");
    }
  }
  if (G_UNLIKELY (!handled))
    GST_WARNING ("Error rewriting offsets");

  GST_LOG ("Done rewriting offsets");
}

static void
parse_exif_ascii_tag (GstExifReader * reader, const GstExifTagMatch * tag,
    guint32 count, guint32 offset, const guint8 * offset_as_data)
{
  GType tagtype;
  gchar *str;
  gchar *utfstr;
  guint32 real_offset;
  GError *error = NULL;

  if (count > 4) {
    GstMapInfo info;

    if (offset < reader->base_offset) {
      GST_WARNING ("Offset is smaller (%u) than base offset (%u)", offset,
          reader->base_offset);
      return;
    }

    real_offset = offset - reader->base_offset;

    if (!gst_buffer_map (reader->buffer, &info, GST_MAP_READ)) {
      GST_WARNING ("Failed to map buffer for reading");
      return;
    }
    if (real_offset >= info.size) {
      GST_WARNING ("Invalid offset %u for buffer of size %" G_GSIZE_FORMAT
          ", not adding tag %s", real_offset, info.size, tag->gst_tag);
      gst_buffer_unmap (reader->buffer, &info);
      return;
    }

    str = g_strndup ((gchar *) (info.data + real_offset), count);
    gst_buffer_unmap (reader->buffer, &info);
  } else {
    str = g_strndup ((gchar *) offset_as_data, count);
  }

  /* convert from ascii to utf8 */
  if (g_utf8_validate (str, -1, NULL)) {
    GST_DEBUG ("Exif string is already on utf8: %s", str);
    utfstr = str;
  } else {
    GST_DEBUG ("Exif string isn't utf8, trying to convert from latin1: %s",
        str);
    utfstr = g_convert (str, count, "utf8", "latin1", NULL, NULL, &error);
    if (error) {
      GST_WARNING ("Skipping tag %d:%s. Failed to convert ascii string "
          "to utf8 : %s - %s", tag->exif_tag, tag->gst_tag, str,
          error->message);
      g_error_free (error);
      g_free (str);
      return;
    }
    g_free (str);
  }

  tagtype = gst_tag_get_type (tag->gst_tag);
  if (tagtype == GST_TYPE_DATE_TIME) {
    gint year = 0, month = 1, day = 1, hour = 0, minute = 0, second = 0;

    if (sscanf (utfstr, "%04d:%02d:%02d %02d:%02d:%02d", &year, &month, &day,
            &hour, &minute, &second) > 0) {
      GstDateTime *d;

      d = gst_date_time_new_local_time (year, month, day, hour, minute, second);
      gst_tag_list_add (reader->taglist, GST_TAG_MERGE_REPLACE,
          tag->gst_tag, d, NULL);
      gst_date_time_unref (d);
    } else {
      GST_WARNING ("Failed to parse %s into a datetime tag", utfstr);
    }
  } else if (tagtype == G_TYPE_STRING) {
    if (utfstr[0] != '\0')
      gst_tag_list_add (reader->taglist, GST_TAG_MERGE_REPLACE, tag->gst_tag,
          utfstr, NULL);
  } else {
    GST_WARNING ("No parsing function associated to %x(%s)", tag->exif_tag,
        tag->gst_tag);
  }
  g_free (utfstr);
}

static void
parse_exif_long_tag (GstExifReader * reader, const GstExifTagMatch * tag,
    guint32 count, guint32 offset, const guint8 * offset_as_data)
{
  GType tagtype;

  if (count > 1) {
    GST_WARNING ("Long tags with more than one value are not supported");
    return;
  }

  tagtype = gst_tag_get_type (tag->gst_tag);
  if (tagtype == G_TYPE_INT) {
    gst_tag_list_add (reader->taglist, GST_TAG_MERGE_REPLACE, tag->gst_tag,
        offset, NULL);
  } else {
    GST_WARNING ("No parsing function associated to %x(%s)", tag->exif_tag,
        tag->gst_tag);
  }
}


static void
parse_exif_undefined_tag (GstExifReader * reader, const GstExifTagMatch * tag,
    guint32 count, guint32 offset, const guint8 * offset_as_data)
{
  GType tagtype;
  guint8 *data;
  guint32 real_offset;

  if (count > 4) {
    GstMapInfo info;

    if (offset < reader->base_offset) {
      GST_WARNING ("Offset is smaller (%u) than base offset (%u)", offset,
          reader->base_offset);
      return;
    }

    real_offset = offset - reader->base_offset;

    if (!gst_buffer_map (reader->buffer, &info, GST_MAP_READ)) {
      GST_WARNING ("Failed to map buffer for reading");
      return;
    }

    if (real_offset >= info.size) {
      GST_WARNING ("Invalid offset %u for buffer of size %" G_GSIZE_FORMAT
          ", not adding tag %s", real_offset, info.size, tag->gst_tag);
      gst_buffer_unmap (reader->buffer, &info);
      return;
    }

    /* +1 because it could be a string without the \0 */
    data = malloc (sizeof (guint8) * count + 1);
    memcpy (data, info.data + real_offset, count);
    data[count] = 0;

    gst_buffer_unmap (reader->buffer, &info);
  } else {
    data = malloc (sizeof (guint8) * count + 1);
    memcpy (data, (guint8 *) offset_as_data, count);
    data[count] = 0;
  }

  tagtype = gst_tag_get_type (tag->gst_tag);
  if (tagtype == GST_TYPE_SAMPLE) {
    GstSample *sample;
    GstBuffer *buf;

    buf = gst_buffer_new_wrapped (data, count);
    data = NULL;

    sample = gst_sample_new (buf, NULL, NULL, NULL);
    gst_tag_list_add (reader->taglist, GST_TAG_MERGE_APPEND, tag->gst_tag,
        sample, NULL);
    gst_sample_unref (sample);
    gst_buffer_unref (buf);
  } else if (tagtype == G_TYPE_STRING) {
    if (data[0] != '\0')
      gst_tag_list_add (reader->taglist, GST_TAG_MERGE_REPLACE, tag->gst_tag,
          data, NULL);
  } else {
    GST_WARNING ("No parsing function associated to %x(%s)", tag->exif_tag,
        tag->gst_tag);
  }
  g_free (data);
}

static gboolean
exif_reader_read_rational_tag (GstExifReader * exif_reader,
    guint32 count, guint32 offset, gboolean is_signed,
    gint32 * _frac_n, gint32 * _frac_d)
{
  GstByteReader data_reader;
  guint32 real_offset;
  gint32 frac_n = 0;
  gint32 frac_d = 0;
  GstMapInfo info;

  if (count > 1) {
    GST_WARNING ("Rationals with multiple entries are not supported");
  }
  if (offset < exif_reader->base_offset) {
    GST_WARNING ("Offset is smaller (%u) than base offset (%u)", offset,
        exif_reader->base_offset);
    return FALSE;
  }

  real_offset = offset - exif_reader->base_offset;

  if (!gst_buffer_map (exif_reader->buffer, &info, GST_MAP_READ)) {
    GST_WARNING ("Failed to map buffer for reading");
    return FALSE;
  }

  if (real_offset >= info.size) {
    GST_WARNING ("Invalid offset %u for buffer of size %" G_GSIZE_FORMAT,
        real_offset, info.size);
    goto reader_fail;
  }

  gst_byte_reader_init (&data_reader, info.data, info.size);
  if (!gst_byte_reader_set_pos (&data_reader, real_offset))
    goto reader_fail;

  if (!is_signed) {
    guint32 aux_n = 0, aux_d = 0;
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_get_uint32_le (&data_reader, &aux_n) ||
          !gst_byte_reader_get_uint32_le (&data_reader, &aux_d))
        goto reader_fail;
    } else {
      if (!gst_byte_reader_get_uint32_be (&data_reader, &aux_n) ||
          !gst_byte_reader_get_uint32_be (&data_reader, &aux_d))
        goto reader_fail;
    }
    frac_n = (gint32) aux_n;
    frac_d = (gint32) aux_d;
  } else {
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_get_int32_le (&data_reader, &frac_n) ||
          !gst_byte_reader_get_int32_le (&data_reader, &frac_d))
        goto reader_fail;
    } else {
      if (!gst_byte_reader_get_int32_be (&data_reader, &frac_n) ||
          !gst_byte_reader_get_int32_be (&data_reader, &frac_d))
        goto reader_fail;
    }
  }

  if (_frac_n)
    *_frac_n = frac_n;
  if (_frac_d)
    *_frac_d = frac_d;

  gst_buffer_unmap (exif_reader->buffer, &info);

  return TRUE;

reader_fail:
  GST_WARNING ("Failed to read from byte reader. (Buffer too short?)");
  gst_buffer_unmap (exif_reader->buffer, &info);
  return FALSE;
}

static void
parse_exif_rational_tag (GstExifReader * exif_reader,
    const gchar * gst_tag, guint32 count, guint32 offset, gdouble multiplier,
    gboolean is_signed)
{
  GType type;
  gint32 frac_n = 0;
  gint32 frac_d = 1;
  gdouble value;

  GST_DEBUG ("Reading fraction for tag %s...", gst_tag);
  if (!exif_reader_read_rational_tag (exif_reader, count, offset, is_signed,
          &frac_n, &frac_d))
    return;
  GST_DEBUG ("Read fraction for tag %s: %d/%d", gst_tag, frac_n, frac_d);

  type = gst_tag_get_type (gst_tag);
  switch (type) {
    case G_TYPE_DOUBLE:
      gst_util_fraction_to_double (frac_n, frac_d, &value);
      value *= multiplier;
      GST_DEBUG ("Adding %s tag: %lf", gst_tag, value);
      gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE, gst_tag,
          value, NULL);
      break;
    default:
      if (type == GST_TYPE_FRACTION) {
        GValue fraction = { 0 };

        g_value_init (&fraction, GST_TYPE_FRACTION);
        gst_value_set_fraction (&fraction, frac_n * multiplier, frac_d);
        gst_tag_list_add_value (exif_reader->taglist, GST_TAG_MERGE_REPLACE,
            gst_tag, &fraction);
        g_value_unset (&fraction);
      } else {
        GST_WARNING ("Can't convert from fraction into %s", g_type_name (type));
      }
  }

}

static GstBuffer *
write_exif_ifd (const GstTagList * taglist, guint byte_order,
    guint32 base_offset, const GstExifTagMatch * tag_map)
{
  GstExifWriter writer;
  gint i;
  gboolean handled = TRUE;

  GST_DEBUG ("Formatting taglist %p as exif buffer. Byte order: %d, "
      "base_offset: %u", taglist, byte_order, base_offset);

  g_assert (byte_order == G_LITTLE_ENDIAN || byte_order == G_BIG_ENDIAN);

  if (!gst_tag_list_has_ifd_tags (taglist, tag_map)) {
    GST_DEBUG ("No tags for this ifd");
    return NULL;
  }

  gst_exif_writer_init (&writer, byte_order);

  /* write tag number as 0 */
  handled &= gst_byte_writer_put_uint16_le (&writer.tagwriter, 0);

  /* write both tag headers and data
   * in ascending id order */

  for (i = 0; tag_map[i].exif_tag != 0; i++) {

    /* special cases have NULL gst tag */
    if (tag_map[i].gst_tag == NULL) {
      GstBuffer *inner_ifd = NULL;
      const GstExifTagMatch *inner_tag_map = NULL;

      GST_LOG ("Inner ifd tag: %x", tag_map[i].exif_tag);

      if (tag_map[i].exif_tag == EXIF_GPS_IFD_TAG) {
        inner_tag_map = tag_map_gps;
      } else if (tag_map[i].exif_tag == EXIF_IFD_TAG) {
        inner_tag_map = tag_map_exif;
      } else if (tag_map[i].exif_tag == EXIF_VERSION_TAG) {
        /* special case where we write the exif version */
        write_exif_undefined_tag (&writer, EXIF_VERSION_TAG, (guint8 *) "0230",
            4);
      } else if (tag_map[i].exif_tag == EXIF_FLASHPIX_VERSION_TAG) {
        /* special case where we write the flashpix version */
        write_exif_undefined_tag (&writer, EXIF_FLASHPIX_VERSION_TAG,
            (guint8 *) "0100", 4);
      }

      if (inner_tag_map) {
        /* base offset and tagheader size are added when rewriting offset */
        inner_ifd = write_exif_ifd (taglist, byte_order,
            gst_byte_writer_get_size (&writer.datawriter), inner_tag_map);
      }

      if (inner_ifd) {
        GstMapInfo info;

        GST_DEBUG ("Adding inner ifd: %x", tag_map[i].exif_tag);
        gst_exif_writer_write_tag_header (&writer, tag_map[i].exif_tag,
            EXIF_TYPE_LONG, 1,
            gst_byte_writer_get_size (&writer.datawriter), NULL);

        if (gst_buffer_map (inner_ifd, &info, GST_MAP_READ)) {
          handled &=
              gst_byte_writer_put_data (&writer.datawriter, info.data,
              info.size);
          gst_buffer_unmap (inner_ifd, &info);
        } else {
          GST_WARNING ("Failed to map buffer for reading");
          handled = FALSE;
        }
        gst_buffer_unref (inner_ifd);
      }
      continue;
    }

    GST_LOG ("Checking tag %s", tag_map[i].gst_tag);
    if (gst_tag_list_get_value_index (taglist, tag_map[i].gst_tag, 0) == NULL)
      continue;

    write_exif_tag_from_taglist (&writer, taglist, &tag_map[i]);
  }

  /* Add the next IFD offset, we just set it to 0 because
   * there is no easy way to predict what it is going to be.
   * The user might rewrite the value if needed */
  handled &= gst_byte_writer_put_uint32_le (&writer.tagwriter, 0);

  /* write the number of tags */
  gst_byte_writer_set_pos (&writer.tagwriter, 0);
  if (writer.byte_order == G_LITTLE_ENDIAN)
    handled &=
        gst_byte_writer_put_uint16_le (&writer.tagwriter, writer.tags_total);
  else
    handled &=
        gst_byte_writer_put_uint16_be (&writer.tagwriter, writer.tags_total);

  GST_DEBUG ("Number of tags rewritten to %d", writer.tags_total);

  /* now that we know the tag headers size, we can add the offsets */
  gst_exif_tag_rewrite_offsets (&writer.tagwriter, writer.byte_order,
      base_offset + gst_byte_writer_get_size (&writer.tagwriter),
      writer.tags_total, &writer.datawriter);

  if (G_UNLIKELY (!handled)) {
    GST_WARNING ("Error rewriting tags");
    gst_buffer_unref (gst_exif_writer_reset_and_get_buffer (&writer));
    return NULL;
  }

  return gst_exif_writer_reset_and_get_buffer (&writer);
}

static gboolean
parse_exif_tag_header (GstByteReader * reader, gint byte_order,
    GstExifTagData * _tagdata)
{
  g_assert (_tagdata);

  /* read the fields */
  if (byte_order == G_LITTLE_ENDIAN) {
    if (!gst_byte_reader_get_uint16_le (reader, &_tagdata->tag) ||
        !gst_byte_reader_get_uint16_le (reader, &_tagdata->tag_type) ||
        !gst_byte_reader_get_uint32_le (reader, &_tagdata->count) ||
        !gst_byte_reader_get_data (reader, 4, &_tagdata->offset_as_data)) {
      return FALSE;
    }
    _tagdata->offset = GST_READ_UINT32_LE (_tagdata->offset_as_data);
  } else {
    if (!gst_byte_reader_get_uint16_be (reader, &_tagdata->tag) ||
        !gst_byte_reader_get_uint16_be (reader, &_tagdata->tag_type) ||
        !gst_byte_reader_get_uint32_be (reader, &_tagdata->count) ||
        !gst_byte_reader_get_data (reader, 4, &_tagdata->offset_as_data)) {
      return FALSE;
    }
    _tagdata->offset = GST_READ_UINT32_BE (_tagdata->offset_as_data);
  }

  return TRUE;
}

static gboolean
parse_exif_ifd (GstExifReader * exif_reader, gint buf_offset,
    const GstExifTagMatch * tag_map)
{
  GstByteReader reader;
  guint16 entries = 0;
  guint16 i;
  GstMapInfo info;

  g_return_val_if_fail (exif_reader->byte_order == G_LITTLE_ENDIAN
      || exif_reader->byte_order == G_BIG_ENDIAN, FALSE);

  if (!gst_buffer_map (exif_reader->buffer, &info, GST_MAP_READ)) {
    GST_WARNING ("Failed to map buffer for reading");
    return FALSE;
  }

  gst_byte_reader_init (&reader, info.data, info.size);
  if (!gst_byte_reader_set_pos (&reader, buf_offset))
    goto invalid_offset;

  /* read the IFD entries number */
  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    if (!gst_byte_reader_get_uint16_le (&reader, &entries))
      goto read_error;
  } else {
    if (!gst_byte_reader_get_uint16_be (&reader, &entries))
      goto read_error;
  }
  GST_DEBUG ("Read number of entries: %u", entries);

  /* iterate over the buffer and find the tags and stuff */
  for (i = 0; i < entries; i++) {
    GstExifTagData tagdata;
    gint map_index;

    GST_LOG ("Reading entry: %u", i);

    if (!parse_exif_tag_header (&reader, exif_reader->byte_order, &tagdata))
      goto read_error;

    GST_DEBUG ("Parsed tag: id 0x%x, type %u, count %u, offset %u (0x%x)"
        ", buf size: %u", tagdata.tag, tagdata.tag_type, tagdata.count,
        tagdata.offset, tagdata.offset, gst_byte_reader_get_size (&reader));

    map_index = exif_tag_map_find_reverse (tagdata.tag, tag_map, TRUE);
    if (map_index == -1) {
      GST_WARNING ("Unmapped exif tag: 0x%x", tagdata.tag);
      continue;
    }

    /*
     * inner ifd tags handling, errors processing those are being ignored
     * and we try to continue the parsing
     */
    if (tagdata.tag == EXIF_GPS_IFD_TAG) {
      parse_exif_ifd (exif_reader,
          tagdata.offset - exif_reader->base_offset, tag_map_gps);

      continue;
    }
    if (tagdata.tag == EXIF_IFD_TAG) {
      parse_exif_ifd (exif_reader,
          tagdata.offset - exif_reader->base_offset, tag_map_exif);

      continue;
    }
    if (tagdata.tag == EXIF_VERSION_TAG ||
        tagdata.tag == EXIF_FLASHPIX_VERSION_TAG) {
      /* skip */
      continue;
    }

    /* tags that need specialized deserialization */
    if (tag_map[map_index].deserialize) {
      i += tag_map[map_index].deserialize (exif_reader, &reader,
          &tag_map[map_index], &tagdata);
      continue;
    }

    switch (tagdata.tag_type) {
      case EXIF_TYPE_ASCII:
        parse_exif_ascii_tag (exif_reader, &tag_map[map_index],
            tagdata.count, tagdata.offset, tagdata.offset_as_data);
        break;
      case EXIF_TYPE_RATIONAL:
        parse_exif_rational_tag (exif_reader, tag_map[map_index].gst_tag,
            tagdata.count, tagdata.offset, 1, FALSE);
        break;
      case EXIF_TYPE_SRATIONAL:
        parse_exif_rational_tag (exif_reader, tag_map[map_index].gst_tag,
            tagdata.count, tagdata.offset, 1, TRUE);
        break;
      case EXIF_TYPE_UNDEFINED:
        parse_exif_undefined_tag (exif_reader, &tag_map[map_index],
            tagdata.count, tagdata.offset, tagdata.offset_as_data);
        break;
      case EXIF_TYPE_LONG:
        parse_exif_long_tag (exif_reader, &tag_map[map_index],
            tagdata.count, tagdata.offset, tagdata.offset_as_data);
        break;
      default:
        GST_WARNING ("Unhandled tag type: %u", tagdata.tag_type);
        break;
    }
  }

  /* check if the pending tags have something that can still be added */
  {
    GSList *walker;
    GstExifTagData *data;

    for (walker = exif_reader->pending_tags; walker;
        walker = g_slist_next (walker)) {
      data = (GstExifTagData *) walker->data;
      switch (data->tag) {
        case EXIF_TAG_XRESOLUTION:
          parse_exif_rational_tag (exif_reader, GST_TAG_IMAGE_HORIZONTAL_PPI,
              data->count, data->offset, 1, FALSE);
          break;
        case EXIF_TAG_YRESOLUTION:
          parse_exif_rational_tag (exif_reader, GST_TAG_IMAGE_VERTICAL_PPI,
              data->count, data->offset, 1, FALSE);
          break;
        default:
          /* NOP */
          break;
      }
    }
  }
  gst_buffer_unmap (exif_reader->buffer, &info);

  return TRUE;

invalid_offset:
  {
    GST_WARNING ("Buffer offset invalid when parsing exif ifd");
    gst_buffer_unmap (exif_reader->buffer, &info);
    return FALSE;
  }
read_error:
  {
    GST_WARNING ("Failed to parse the exif ifd");
    gst_buffer_unmap (exif_reader->buffer, &info);
    return FALSE;
  }
}

/**
 * gst_tag_list_to_exif_buffer:
 * @taglist: The taglist
 * @byte_order: byte order used in writing (G_LITTLE_ENDIAN or G_BIG_ENDIAN)
 * @base_offset: Offset from the tiff header first byte
 *
 * Formats the tags in taglist on exif format. The resulting buffer contains
 * the tags IFD and is followed by the data pointed by the tag entries.
 *
 * Returns: A GstBuffer containing the tag entries followed by the tag data
 */
GstBuffer *
gst_tag_list_to_exif_buffer (const GstTagList * taglist, gint byte_order,
    guint32 base_offset)
{
  return write_exif_ifd (taglist, byte_order, base_offset, tag_map_ifd0);
}

/**
 * gst_tag_list_to_exif_buffer_with_tiff_header:
 * @taglist: The taglist
 *
 * Formats the tags in taglist into exif structure, a tiff header
 * is put in the beginning of the buffer.
 *
 * Returns: A GstBuffer containing the data
 */
GstBuffer *
gst_tag_list_to_exif_buffer_with_tiff_header (const GstTagList * taglist)
{
  GstBuffer *ifd, *res;
  GstByteWriter writer;
  GstMapInfo info;
  gboolean handled = TRUE;

  ifd = gst_tag_list_to_exif_buffer (taglist, G_BYTE_ORDER, 8);
  if (ifd == NULL) {
    GST_WARNING ("Failed to create exif buffer");
    return NULL;
  }

  if (!gst_buffer_map (ifd, &info, GST_MAP_READ)) {
    GST_WARNING ("Failed to map buffer for reading");
    gst_buffer_unref (ifd);
    return NULL;
  }

  /* TODO what is the correct endianness here? */
  gst_byte_writer_init_with_size (&writer, info.size + TIFF_HEADER_SIZE, FALSE);
  /* TIFF header */
  if (G_BYTE_ORDER == G_LITTLE_ENDIAN) {
    handled &= gst_byte_writer_put_uint16_le (&writer, TIFF_LITTLE_ENDIAN);
    handled &= gst_byte_writer_put_uint16_le (&writer, 42);
    handled &= gst_byte_writer_put_uint32_le (&writer, 8);
  } else {
    handled &= gst_byte_writer_put_uint16_be (&writer, TIFF_BIG_ENDIAN);
    handled &= gst_byte_writer_put_uint16_be (&writer, 42);
    handled &= gst_byte_writer_put_uint32_be (&writer, 8);
  }
  if (!gst_byte_writer_put_data (&writer, info.data, info.size)) {
    GST_WARNING ("Byte writer size mismatch");
    /* reaching here is a programming error because we should have a buffer
     * large enough */
    g_assert_not_reached ();
    gst_buffer_unmap (ifd, &info);
    gst_buffer_unref (ifd);
    gst_byte_writer_reset (&writer);
    return NULL;
  }
  gst_buffer_unmap (ifd, &info);
  gst_buffer_unref (ifd);

  res = gst_byte_writer_reset_and_get_buffer (&writer);

  if (G_UNLIKELY (!handled)) {
    GST_WARNING ("Error creating buffer");
    gst_buffer_unref (res);
    res = NULL;
  }

  return res;
}

/**
 * gst_tag_list_from_exif_buffer:
 * @buffer: The exif buffer
 * @byte_order: byte order of the data
 * @base_offset: Offset from the tiff header to this buffer
 *
 * Parses the IFD and IFD tags data contained in the buffer and puts it
 * on a taglist. The base_offset is used to subtract from the offset in
 * the tag entries and be able to get the offset relative to the buffer
 * start
 *
 * Returns: The parsed taglist
 */
GstTagList *
gst_tag_list_from_exif_buffer (GstBuffer * buffer, gint byte_order,
    guint32 base_offset)
{
  GstExifReader reader;
  g_return_val_if_fail (byte_order == G_LITTLE_ENDIAN
      || byte_order == G_BIG_ENDIAN, NULL);

  gst_exif_reader_init (&reader, byte_order, buffer, base_offset);

  if (!parse_exif_ifd (&reader, 0, tag_map_ifd0))
    goto read_error;

  return gst_exif_reader_reset (&reader, TRUE);

read_error:
  {
    gst_exif_reader_reset (&reader, FALSE);
    GST_WARNING ("Failed to parse the exif buffer");
    return NULL;
  }
}

/**
 * gst_tag_list_from_exif_buffer_with_tiff_header:
 * @buffer: The exif buffer
 *
 * Parses the exif tags starting with a tiff header structure.
 *
 * Returns: The taglist
 */
GstTagList *
gst_tag_list_from_exif_buffer_with_tiff_header (GstBuffer * buffer)
{
  GstByteReader reader;
  guint16 fortytwo = 42;
  guint16 endianness = 0;
  guint32 offset;
  GstTagList *taglist = NULL;
  GstBuffer *subbuffer;
  GstMapInfo info, sinfo;

  if (!gst_buffer_map (buffer, &info, GST_MAP_READ)) {
    GST_WARNING ("Failed to map buffer for reading");
    return NULL;
  }

  GST_LOG ("Parsing exif tags with tiff header of size %" G_GSIZE_FORMAT,
      info.size);

  gst_byte_reader_init (&reader, info.data, info.size);

  GST_LOG ("Parsing the tiff header");
  if (!gst_byte_reader_get_uint16_be (&reader, &endianness)) {
    goto byte_reader_fail;
  }

  if (endianness == TIFF_LITTLE_ENDIAN) {
    if (!gst_byte_reader_get_uint16_le (&reader, &fortytwo) ||
        !gst_byte_reader_get_uint32_le (&reader, &offset))
      goto byte_reader_fail;
  } else if (endianness == TIFF_BIG_ENDIAN) {
    if (!gst_byte_reader_get_uint16_be (&reader, &fortytwo) ||
        !gst_byte_reader_get_uint32_be (&reader, &offset))
      goto byte_reader_fail;
  } else
    goto invalid_endianness;

  if (fortytwo != 42)
    goto invalid_magic;

  subbuffer = gst_buffer_new_and_alloc (info.size - (TIFF_HEADER_SIZE - 2));

  if (!gst_buffer_map (subbuffer, &sinfo, GST_MAP_WRITE))
    goto map_failed;

  memcpy (sinfo.data, info.data + TIFF_HEADER_SIZE,
      info.size - TIFF_HEADER_SIZE);
  gst_buffer_unmap (subbuffer, &sinfo);

  taglist = gst_tag_list_from_exif_buffer (subbuffer,
      endianness == TIFF_LITTLE_ENDIAN ? G_LITTLE_ENDIAN : G_BIG_ENDIAN, 8);

  gst_buffer_unref (subbuffer);

done:
  gst_buffer_unmap (buffer, &info);

  return taglist;

map_failed:
  {
    GST_WARNING ("Failed to map buffer for writing");
    gst_buffer_unref (subbuffer);
    goto done;
  }
byte_reader_fail:
  {
    GST_WARNING ("Failed to read values from buffer");
    goto done;
  }
invalid_endianness:
  {
    GST_WARNING ("Invalid endianness number %u", endianness);
    goto done;
  }
invalid_magic:
  {
    GST_WARNING ("Invalid magic number %u, should be 42", fortytwo);
    goto done;
  }
}

/* special serialization functions */
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (contrast,
    capturing_contrast);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (exposure_mode,
    capturing_exposure_mode);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (exposure_program,
    capturing_exposure_program);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (gain_control,
    capturing_gain_adjustment);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (metering_mode,
    capturing_metering_mode);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (orientation,
    image_orientation);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (saturation,
    capturing_saturation);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (scene_capture_type,
    capturing_scene_capture_type);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (sharpness,
    capturing_sharpness);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (source,
    capturing_source);
EXIF_SERIALIZATION_DESERIALIZATION_MAP_STRING_TO_INT_FUNC (white_balance,
    capturing_white_balance);

static void
serialize_geo_coordinate (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gboolean latitude;
  gdouble value;
  gint degrees;
  gint minutes;
  gint seconds;
  guint32 offset;

  latitude = exiftag->exif_tag == EXIF_TAG_GPS_LATITUDE;        /* exif tag for latitude */
  if (!gst_tag_list_get_double (taglist, exiftag->gst_tag, &value)) {
    GST_WARNING ("Failed to get double from tag list for tag: %s",
        exiftag->gst_tag);
    return;
  }

  /* first write the Latitude or Longitude Ref */
  if (latitude) {
    if (value >= 0) {
      write_exif_ascii_tag (writer, exiftag->complementary_tag, "N");
    } else {
      value *= -1;
      write_exif_ascii_tag (writer, exiftag->complementary_tag, "S");
    }
  } else {
    if (value >= 0) {
      write_exif_ascii_tag (writer, exiftag->complementary_tag, "E");
    } else {
      value *= -1;
      write_exif_ascii_tag (writer, exiftag->complementary_tag, "W");
    }
  }

  /* now write the degrees stuff */
  GST_LOG ("Converting geo location %lf to degrees", value);
  degrees = (gint) value;
  value -= degrees;
  minutes = (gint) (value * 60);
  value = (value * 60) - minutes;
  seconds = (gint) (value * 60);
  GST_LOG ("Converted geo location to %d.%d'%d'' degrees", degrees,
      minutes, seconds);

  offset = gst_byte_writer_get_size (&writer->datawriter);
  gst_exif_writer_write_tag_header (writer, exiftag->exif_tag,
      EXIF_TYPE_RATIONAL, 3, offset, NULL);
  gst_exif_writer_write_rational_data (writer, degrees, 1);
  gst_exif_writer_write_rational_data (writer, minutes, 1);
  gst_exif_writer_write_rational_data (writer, seconds, 1);
}

static gint
deserialize_geo_coordinate (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstByteReader fractions_reader;
  gint multiplier;
  GstExifTagData next_tagdata;
  gint ret = 0;
  /* for the conversion */
  guint32 degrees_n = 0;
  guint32 degrees_d = 1;
  guint32 minutes_n = 0;
  guint32 minutes_d = 1;
  guint32 seconds_n = 0;
  guint32 seconds_d = 1;
  gdouble degrees;
  gdouble minutes;
  gdouble seconds;
  GstMapInfo info = { NULL };

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (exiftag->complementary_tag != tagdata->tag) {
    /* First should come the 'Ref' tags */
    GST_WARNING ("Tag %d is not the 'Ref' tag for latitude nor longitude",
        tagdata->tag);
    return ret;
  }

  if (tagdata->offset_as_data[0] == 'N' || tagdata->offset_as_data[0] == 'E') {
    multiplier = 1;
  } else if (tagdata->offset_as_data[0] == 'S'
      || tagdata->offset_as_data[0] == 'W') {
    multiplier = -1;
  } else {
    GST_WARNING ("Invalid LatitudeRef or LongitudeRef %c",
        tagdata->offset_as_data[0]);
    return ret;
  }

  /* now read the following tag that must be the latitude or longitude */
  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    if (!gst_byte_reader_peek_uint16_le (reader, &next_tagdata.tag))
      goto reader_fail;
  } else {
    if (!gst_byte_reader_peek_uint16_be (reader, &next_tagdata.tag))
      goto reader_fail;
  }

  if (exiftag->exif_tag != next_tagdata.tag) {
    GST_WARNING ("This is not a geo coordinate tag");
    return ret;
  }

  /* read the remaining tag entry data */
  if (!parse_exif_tag_header (reader, exif_reader->byte_order, &next_tagdata)) {
    ret = -1;
    goto reader_fail;
  }

  ret = 1;

  /* some checking */
  if (next_tagdata.tag_type != EXIF_TYPE_RATIONAL) {
    GST_WARNING ("Invalid type %d for geo coordinate (latitude/longitude)",
        next_tagdata.tag_type);
    return ret;
  }
  if (next_tagdata.count != 3) {
    GST_WARNING ("Geo coordinate should use 3 fractions, we have %u",
        next_tagdata.count);
    return ret;
  }

  if (!gst_buffer_map (exif_reader->buffer, &info, GST_MAP_READ)) {
    GST_WARNING ("Failed to map buffer for reading");
    return ret;
  }

  /* now parse the fractions */
  gst_byte_reader_init (&fractions_reader, info.data, info.size);

  if (!gst_byte_reader_set_pos (&fractions_reader,
          next_tagdata.offset - exif_reader->base_offset))
    goto reader_fail;

  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    if (!gst_byte_reader_get_uint32_le (&fractions_reader, &degrees_n) ||
        !gst_byte_reader_get_uint32_le (&fractions_reader, &degrees_d) ||
        !gst_byte_reader_get_uint32_le (&fractions_reader, &minutes_n) ||
        !gst_byte_reader_get_uint32_le (&fractions_reader, &minutes_d) ||
        !gst_byte_reader_get_uint32_le (&fractions_reader, &seconds_n) ||
        !gst_byte_reader_get_uint32_le (&fractions_reader, &seconds_d))
      goto reader_fail;
  } else {
    if (!gst_byte_reader_get_uint32_be (&fractions_reader, &degrees_n) ||
        !gst_byte_reader_get_uint32_be (&fractions_reader, &degrees_d) ||
        !gst_byte_reader_get_uint32_be (&fractions_reader, &minutes_n) ||
        !gst_byte_reader_get_uint32_be (&fractions_reader, &minutes_d) ||
        !gst_byte_reader_get_uint32_be (&fractions_reader, &seconds_n) ||
        !gst_byte_reader_get_uint32_be (&fractions_reader, &seconds_d))
      goto reader_fail;
  }
  gst_buffer_unmap (exif_reader->buffer, &info);

  GST_DEBUG ("Read degrees fraction for tag %s: %u/%u %u/%u %u/%u",
      exiftag->gst_tag, degrees_n, degrees_d, minutes_n, minutes_d,
      seconds_n, seconds_d);

  gst_util_fraction_to_double (degrees_n, degrees_d, &degrees);
  gst_util_fraction_to_double (minutes_n, minutes_d, &minutes);
  gst_util_fraction_to_double (seconds_n, seconds_d, &seconds);

  minutes += seconds / 60;
  degrees += minutes / 60;
  degrees *= multiplier;

  GST_DEBUG ("Adding %s tag: %lf", exiftag->gst_tag, degrees);
  gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE,
      exiftag->gst_tag, degrees, NULL);

  return ret;

reader_fail:
  GST_WARNING ("Failed to read fields from buffer (too short?)");
  if (info.data)
    gst_buffer_unmap (exif_reader->buffer, &info);
  return ret;
}


static void
serialize_geo_direction (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gdouble value;

  if (!gst_tag_list_get_double (taglist, exiftag->gst_tag, &value)) {
    GST_WARNING ("Failed to get double from tag list for tag: %s",
        exiftag->gst_tag);
    return;
  }

  /* first write the direction ref */
  write_exif_ascii_tag (writer, exiftag->complementary_tag, "T");
  gst_exif_writer_write_rational_tag_from_double (writer,
      exiftag->exif_tag, value);
}

static gint
deserialize_geo_direction (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstExifTagData next_tagdata = { 0, };
  gint ret = 0;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (exiftag->complementary_tag == tagdata->tag) {
    /* First should come the 'Ref' tags */
    if (tagdata->offset_as_data[0] == 'M') {
      GST_WARNING ("Magnetic direction is not supported");
      return ret;
    } else if (tagdata->offset_as_data[0] == 'T') {
      /* nop */
    } else {
      GST_WARNING ("Invalid Ref for direction or track %c",
          tagdata->offset_as_data[0]);
      return ret;
    }
  } else {
    GST_DEBUG ("No Direction Ref, using default=T");
    if (tagdata->tag == exiftag->exif_tag) {
      /* this is the main tag */
      tagdata_copy (&next_tagdata, tagdata);
    }
  }

  if (next_tagdata.tag == 0) {
    /* now read the following tag that must be the exif_tag */
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_peek_uint16_le (reader, &next_tagdata.tag))
        goto reader_fail;
    } else {
      if (!gst_byte_reader_peek_uint16_be (reader, &next_tagdata.tag))
        goto reader_fail;
    }

    if (exiftag->exif_tag != next_tagdata.tag) {
      GST_WARNING ("Unexpected tag");
      return ret;
    }

    /* read the remaining tag entry data */
    if (!parse_exif_tag_header (reader, exif_reader->byte_order, &next_tagdata)) {
      ret = -1;
      goto reader_fail;
    }
    ret = 1;
  }

  /* some checking */
  if (next_tagdata.tag_type != EXIF_TYPE_RATIONAL) {
    GST_WARNING ("Invalid type %d for 0x%x", next_tagdata.tag_type,
        next_tagdata.tag);
    return ret;
  }
  if (next_tagdata.count != 1) {
    GST_WARNING ("0x%x tag must have a single fraction, we have %u",
        next_tagdata.tag_type, next_tagdata.count);
    return ret;
  }

  parse_exif_rational_tag (exif_reader,
      exiftag->gst_tag, next_tagdata.count, next_tagdata.offset, 1, FALSE);

  return ret;

reader_fail:
  GST_WARNING ("Failed to read fields from buffer (too short?)");
  return ret;
}


static void
serialize_geo_elevation (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gdouble value;

  if (!gst_tag_list_get_double (taglist, exiftag->gst_tag, &value)) {
    GST_WARNING ("Failed to get double from tag list for tag: %s",
        exiftag->gst_tag);
    return;
  }

  /* first write the Ref */
  gst_exif_writer_write_byte_tag (writer,
      exiftag->complementary_tag, value >= 0 ? 0 : 1);

  if (value < 0)
    value *= -1;

  /* now the value */
  gst_exif_writer_write_rational_tag_from_double (writer,
      exiftag->exif_tag, value);
}

static gint
deserialize_geo_elevation (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstExifTagData next_tagdata = { 0, };
  gint multiplier = 1;
  gint ret = 0;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (exiftag->complementary_tag == tagdata->tag) {
    if (tagdata->offset_as_data[0] == 0) {
      /* NOP */
    } else if (tagdata->offset_as_data[0] == 1) {
      multiplier = -1;
    } else {
      GST_WARNING ("Invalid GPSAltitudeRef %u", tagdata->offset_as_data[0]);
      return ret;
    }
  } else {
    GST_DEBUG ("No GPSAltitudeRef, using default=0");
    if (tagdata->tag == exiftag->exif_tag) {
      tagdata_copy (&next_tagdata, tagdata);
    }
  }

  /* now read the following tag that must be the exif_tag */
  if (next_tagdata.tag == 0) {
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_peek_uint16_le (reader, &next_tagdata.tag))
        goto reader_fail;
    } else {
      if (!gst_byte_reader_peek_uint16_be (reader, &next_tagdata.tag))
        goto reader_fail;
    }

    if (exiftag->exif_tag != next_tagdata.tag) {
      GST_WARNING ("Unexpected tag");
      return ret;
    }

    /* read the remaining tag entry data */
    if (!parse_exif_tag_header (reader, exif_reader->byte_order, &next_tagdata)) {
      ret = -1;
      goto reader_fail;
    }
    ret = 1;
  }

  /* some checking */
  if (next_tagdata.tag_type != EXIF_TYPE_RATIONAL) {
    GST_WARNING ("Invalid type %d for 0x%x", next_tagdata.tag_type,
        next_tagdata.tag);
    return ret;
  }
  if (next_tagdata.count != 1) {
    GST_WARNING ("0x%x tag must have a single fraction, we have %u",
        next_tagdata.tag_type, next_tagdata.count);
    return ret;
  }

  parse_exif_rational_tag (exif_reader,
      exiftag->gst_tag, next_tagdata.count, next_tagdata.offset, multiplier,
      FALSE);

  return ret;

reader_fail:
  GST_WARNING ("Failed to read fields from buffer (too short?)");
  return ret;
}


static void
serialize_speed (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gdouble value;

  if (!gst_tag_list_get_double (taglist, exiftag->gst_tag, &value)) {
    GST_WARNING ("Failed to get double from tag list for tag: %s",
        exiftag->gst_tag);
    return;
  }

  /* first write the Ref */
  write_exif_ascii_tag (writer, exiftag->complementary_tag, "K");

  /* now the value */
  gst_exif_writer_write_rational_tag_from_double (writer,
      exiftag->exif_tag, value * METERS_PER_SECOND_TO_KILOMETERS_PER_HOUR);
}

static gint
deserialize_speed (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstExifTagData next_tagdata = { 0, };
  gdouble multiplier = 1;
  gint ret = 0;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (exiftag->complementary_tag == tagdata->tag) {
    if (tagdata->offset_as_data[0] == 'K') {
      multiplier = KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND;
    } else if (tagdata->offset_as_data[0] == 'M') {
      multiplier = MILES_PER_HOUR_TO_METERS_PER_SECOND;
    } else if (tagdata->offset_as_data[0] == 'N') {
      multiplier = KNOTS_TO_METERS_PER_SECOND;
    } else {
      GST_WARNING ("Invalid GPSSpeedRed %c", tagdata->offset_as_data[0]);
      return ret;
    }
  } else {
    GST_DEBUG ("No GPSSpeedRef, using default=K");
    multiplier = KILOMETERS_PER_HOUR_TO_METERS_PER_SECOND;

    if (tagdata->tag == exiftag->exif_tag) {
      tagdata_copy (&next_tagdata, tagdata);
    }
  }

  /* now read the following tag that must be the exif_tag */
  if (next_tagdata.tag == 0) {
    if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
      if (!gst_byte_reader_peek_uint16_le (reader, &next_tagdata.tag))
        goto reader_fail;
    } else {
      if (!gst_byte_reader_peek_uint16_be (reader, &next_tagdata.tag))
        goto reader_fail;
    }

    if (exiftag->exif_tag != next_tagdata.tag) {
      GST_WARNING ("Unexpected tag");
      return ret;
    }

    /* read the remaining tag entry data */
    if (!parse_exif_tag_header (reader, exif_reader->byte_order, &next_tagdata)) {
      ret = -1;
      goto reader_fail;
    }
    ret = 1;
  }


  /* some checking */
  if (next_tagdata.tag_type != EXIF_TYPE_RATIONAL) {
    GST_WARNING ("Invalid type %d for 0x%x", next_tagdata.tag_type,
        next_tagdata.tag);
    return ret;
  }
  if (next_tagdata.count != 1) {
    GST_WARNING ("0x%x tag must have a single fraction, we have %u",
        next_tagdata.tag_type, next_tagdata.count);
    return ret;
  }

  parse_exif_rational_tag (exif_reader,
      exiftag->gst_tag, next_tagdata.count, next_tagdata.offset, multiplier,
      FALSE);

  return ret;

reader_fail:
  GST_WARNING ("Failed to read fields from buffer (too short?)");
  return ret;
}

static void
serialize_shutter_speed (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  const GValue *value = NULL;
  gdouble num;

  value = gst_tag_list_get_value_index (taglist, exiftag->gst_tag, 0);
  if (!value) {
    GST_WARNING ("Failed to get shutter speed from from tag list");
    return;
  }
  gst_util_fraction_to_double (gst_value_get_fraction_numerator (value),
      gst_value_get_fraction_denominator (value), &num);

#ifdef HAVE_LOG2
  num = -log2 (num);
#else
  num = -log (num) / M_LN2;
#endif

  /* now the value */
  gst_exif_writer_write_signed_rational_tag_from_double (writer,
      exiftag->exif_tag, num);
}

static gint
deserialize_shutter_speed (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  gint32 frac_n, frac_d;
  gdouble d;
  GValue value = { 0 };

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (!exif_reader_read_rational_tag (exif_reader, tagdata->count,
          tagdata->offset, TRUE, &frac_n, &frac_d))
    return 0;

  gst_util_fraction_to_double (frac_n, frac_d, &d);
  d = pow (2, -d);
  gst_util_double_to_fraction (d, &frac_n, &frac_d);

  g_value_init (&value, GST_TYPE_FRACTION);
  gst_value_set_fraction (&value, frac_n, frac_d);
  gst_tag_list_add_value (exif_reader->taglist, GST_TAG_MERGE_KEEP,
      exiftag->gst_tag, &value);
  g_value_unset (&value);

  return 0;
}

static void
serialize_aperture_value (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gdouble num;

  if (!gst_tag_list_get_double_index (taglist, exiftag->gst_tag, 0, &num)) {
    GST_WARNING ("Failed to get focal ratio from from tag list");
    return;
  }
#ifdef HAVE_LOG2
  num = 2 * log2 (num);
#else
  num = 2 * (log (num) / M_LN2);
#endif

  /* now the value */
  gst_exif_writer_write_rational_tag_from_double (writer,
      exiftag->exif_tag, num);
}

static gint
deserialize_aperture_value (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  gint32 frac_n, frac_d;
  gdouble d;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (!exif_reader_read_rational_tag (exif_reader, tagdata->count,
          tagdata->offset, FALSE, &frac_n, &frac_d))
    return 0;

  gst_util_fraction_to_double (frac_n, frac_d, &d);
  d = pow (2, d / 2);

  gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_KEEP,
      exiftag->gst_tag, d, NULL);

  return 0;
}

static void
serialize_sensitivity_type (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  /* we only support ISOSpeed as the sensitivity type (3) */
  gst_exif_writer_write_short_tag (writer, exiftag->exif_tag, 3);
}

static gint
deserialize_sensitivity_type (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstExifTagData *sensitivity = NULL;
  guint16 type_data;

  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    type_data = GST_READ_UINT16_LE (tagdata->offset_as_data);
  } else {
    type_data = GST_READ_UINT16_BE (tagdata->offset_as_data);
  }

  if (type_data != 3) {
    GST_WARNING ("We only support SensitivityType=3");
    return 0;
  }

  /* check the pending tags for the PhotographicSensitivity tag */
  sensitivity =
      gst_exif_reader_get_pending_tag (exif_reader,
      EXIF_TAG_PHOTOGRAPHIC_SENSITIVITY);
  if (sensitivity == NULL) {
    GST_WARNING ("PhotographicSensitivity tag not found");
    return 0;
  }

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_KEEP,
      GST_TAG_CAPTURING_ISO_SPEED, sensitivity->offset_as_data, NULL);

  return 0;
}

static void
serialize_flash (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  gboolean flash_fired;
  const gchar *flash_mode;
  guint16 tagvalue = 0;

  if (!gst_tag_list_get_boolean_index (taglist, exiftag->gst_tag, 0,
          &flash_fired)) {
    GST_WARNING ("Failed to get flash fired from from tag list");
    return;
  }

  if (flash_fired)
    tagvalue = 1;

  if (gst_tag_list_peek_string_index (taglist, GST_TAG_CAPTURING_FLASH_MODE, 0,
          &flash_mode)) {
    guint16 mode = 0;
    if (strcmp (flash_mode, "auto") == 0) {
      mode = 3;
    } else if (strcmp (flash_mode, "always") == 0) {
      mode = 1;
    } else if (strcmp (flash_mode, "never") == 0) {
      mode = 2;
    }

    tagvalue = tagvalue | (mode << 3);
  } else {
    GST_DEBUG ("flash-mode not available");
  }

  gst_exif_writer_write_short_tag (writer, exiftag->exif_tag, tagvalue);
}

static gint
deserialize_flash (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  guint16 value = 0;
  guint mode = 0;
  const gchar *mode_str = NULL;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    value = GST_READ_UINT16_LE (tagdata->offset_as_data);
  } else {
    value = GST_READ_UINT16_BE (tagdata->offset_as_data);
  }

  /* check flash fired */
  if (value & 0x1) {
    gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE,
        GST_TAG_CAPTURING_FLASH_FIRED, TRUE, NULL);
  } else {
    gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE,
        GST_TAG_CAPTURING_FLASH_FIRED, FALSE, NULL);
  }

  mode = (value >> 3) & 0x3;
  if (mode == 1) {
    mode_str = "always";
  } else if (mode == 2) {
    mode_str = "never";
  } else if (mode == 3) {
    mode_str = "auto";
  }

  if (mode_str)
    gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_REPLACE,
        GST_TAG_CAPTURING_FLASH_MODE, mode_str, NULL);

  return 0;
}

static gint
deserialize_resolution (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GstExifTagData *xres = NULL;
  GstExifTagData *yres = NULL;
  guint16 unit;
  gdouble multiplier;

  if (exif_reader->byte_order == G_LITTLE_ENDIAN) {
    unit = GST_READ_UINT16_LE (tagdata->offset_as_data);
  } else {
    unit = GST_READ_UINT16_BE (tagdata->offset_as_data);
  }

  switch (unit) {
    case 2:                    /* inch */
      multiplier = 1;
      break;
    case 3:                    /* cm */
      multiplier = 1 / 2.54;
      break;
    default:
      GST_WARNING ("Invalid resolution unit, ignoring PPI tags");
      return 0;
  }

  xres = gst_exif_reader_get_pending_tag (exif_reader, EXIF_TAG_XRESOLUTION);
  if (xres) {
    parse_exif_rational_tag (exif_reader, GST_TAG_IMAGE_HORIZONTAL_PPI,
        xres->count, xres->offset, multiplier, FALSE);
  }
  yres = gst_exif_reader_get_pending_tag (exif_reader, EXIF_TAG_YRESOLUTION);
  if (yres) {
    parse_exif_rational_tag (exif_reader, GST_TAG_IMAGE_VERTICAL_PPI,
        yres->count, yres->offset, multiplier, FALSE);
  }

  return 0;
}

static void
serialize_scene_type (GstExifWriter * writer, const GstTagList * taglist,
    const GstExifTagMatch * exiftag)
{
  const gchar *str;
  guint8 value = 0;

  if (gst_tag_list_peek_string_index (taglist, GST_TAG_CAPTURING_SOURCE, 0,
          &str)) {
    if (strcmp (str, "dsc") == 0) {
      value = 1;
    }
  }

  if (value != 0)
    write_exif_undefined_tag (writer, exiftag->exif_tag, &value, 1);
}

static gint
deserialize_scene_type (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  guint8 value = 0;

  GST_LOG ("Starting to parse %s tag in exif 0x%x", exiftag->gst_tag,
      exiftag->exif_tag);

  value = GST_READ_UINT8 (tagdata->offset_as_data);

  if (value == 1) {
    gst_tag_list_add (exif_reader->taglist, GST_TAG_MERGE_KEEP,
        GST_TAG_CAPTURING_SOURCE, "dsc", NULL);
  }

  return 0;
}

static gint
deserialize_add_to_pending_tags (GstExifReader * exif_reader,
    GstByteReader * reader, const GstExifTagMatch * exiftag,
    GstExifTagData * tagdata)
{
  GST_LOG ("Adding %s tag in exif 0x%x to pending tags", exiftag->gst_tag,
      exiftag->exif_tag);

  /* add it to the pending tags, as we can only parse it when we find the
   * SensitivityType tag */
  gst_exif_reader_add_pending_tag (exif_reader, tagdata);
  return 0;
}

#undef EXIF_SERIALIZATION_FUNC
#undef EXIF_DESERIALIZATION_FUNC
#undef EXIF_SERIALIZATION_DESERIALIZATION_FUNC
