
#include "dirac_parse.h"
#include <string.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

typedef struct _Unpack Unpack;

struct _Unpack
{
  unsigned char *data;
  int n_bits_left;
  int index;
  int guard_bit;
};

static void schro_unpack_init_with_data (Unpack * unpack, unsigned char *data,
    int n_bytes, unsigned int guard_bit);

static unsigned int schro_unpack_decode_bit (Unpack * unpack);
static unsigned int schro_unpack_decode_uint (Unpack * unpack);


void schro_video_format_set_std_video_format (DiracSequenceHeader * format,
    int index);
void schro_video_format_set_std_frame_rate (DiracSequenceHeader * format,
    int index);
void schro_video_format_set_std_aspect_ratio (DiracSequenceHeader * format,
    int index);
void schro_video_format_set_std_signal_range (DiracSequenceHeader * format,
    int index);
void schro_video_format_set_std_colour_spec (DiracSequenceHeader * format,
    int index);

int
dirac_sequence_header_parse (DiracSequenceHeader * header,
    unsigned char *data, int n_bytes)
{
  int bit;
  int index;
  Unpack _unpack;
  Unpack *unpack = &_unpack;
  int major_version;
  int minor_version;
  int profile;
  int level;

  memset (header, 0, sizeof (*header));

  schro_unpack_init_with_data (unpack, data, n_bytes, 1);

  /* parse parameters */
  major_version = schro_unpack_decode_uint (unpack);
  minor_version = schro_unpack_decode_uint (unpack);
  profile = schro_unpack_decode_uint (unpack);
  level = schro_unpack_decode_uint (unpack);

  /* base video header */
  index = schro_unpack_decode_uint (unpack);
  schro_video_format_set_std_video_format (header, index);

  header->major_version = major_version;
  header->minor_version = minor_version;
  header->profile = profile;
  header->level = level;

  /* source parameters */
  /* frame dimensions */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    header->width = schro_unpack_decode_uint (unpack);
    header->height = schro_unpack_decode_uint (unpack);
  }

  /* chroma header */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    header->chroma_format = schro_unpack_decode_uint (unpack);
  }

  /* scan header */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    header->interlaced = schro_unpack_decode_uint (unpack);
  }

  /* frame rate */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    index = schro_unpack_decode_uint (unpack);
    if (index == 0) {
      header->frame_rate_numerator = schro_unpack_decode_uint (unpack);
      header->frame_rate_denominator = schro_unpack_decode_uint (unpack);
    } else {
      schro_video_format_set_std_frame_rate (header, index);
    }
  }

  /* aspect ratio */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    index = schro_unpack_decode_uint (unpack);
    if (index == 0) {
      header->aspect_ratio_numerator = schro_unpack_decode_uint (unpack);
      header->aspect_ratio_denominator = schro_unpack_decode_uint (unpack);
    } else {
      schro_video_format_set_std_aspect_ratio (header, index);
    }
  }

  /* clean area */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    header->clean_width = schro_unpack_decode_uint (unpack);
    header->clean_height = schro_unpack_decode_uint (unpack);
    header->left_offset = schro_unpack_decode_uint (unpack);
    header->top_offset = schro_unpack_decode_uint (unpack);
  }

  /* signal range */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    index = schro_unpack_decode_uint (unpack);
    if (index == 0) {
      header->luma_offset = schro_unpack_decode_uint (unpack);
      header->luma_excursion = schro_unpack_decode_uint (unpack);
      header->chroma_offset = schro_unpack_decode_uint (unpack);
      header->chroma_excursion = schro_unpack_decode_uint (unpack);
    } else {
      schro_video_format_set_std_signal_range (header, index);
    }
  }

  /* colour spec */
  bit = schro_unpack_decode_bit (unpack);
  if (bit) {
    index = schro_unpack_decode_uint (unpack);
    schro_video_format_set_std_colour_spec (header, index);
    if (index == 0) {
      /* colour primaries */
      bit = schro_unpack_decode_bit (unpack);
      if (bit) {
        header->colour_primaries = schro_unpack_decode_uint (unpack);
      }
      /* colour matrix */
      bit = schro_unpack_decode_bit (unpack);
      if (bit) {
        header->colour_matrix = schro_unpack_decode_uint (unpack);
      }
      /* transfer function */
      bit = schro_unpack_decode_bit (unpack);
      if (bit) {
        header->transfer_function = schro_unpack_decode_uint (unpack);
      }
    }
  }

  header->interlaced_coding = schro_unpack_decode_uint (unpack);

  return 1;
}

/* standard stuff */

static const DiracSequenceHeader schro_video_formats[] = {
  {0, 0, 0, 0,
        0,                      /* custom */
        640, 480, SCHRO_CHROMA_420,
        FALSE, FALSE,
        24000, 1001, 1, 1,
        640, 480, 0, 0,
        0, 255, 128, 255,
      0, 0, 0},
  {0, 0, 0, 0,
        1,                      /* QSIF525 */
        176, 120, SCHRO_CHROMA_420,
        FALSE, FALSE,
        15000, 1001, 10, 11,
        176, 120, 0, 0,
        0, 255, 128, 255,
      1, 1, 0},
  {0, 0, 0, 0,
        2,                      /* QCIF */
        176, 144, SCHRO_CHROMA_420,
        FALSE, TRUE,
        25, 2, 12, 11,
        176, 144, 0, 0,
        0, 255, 128, 255,
      2, 1, 0},
  {0, 0, 0, 0,
        3,                      /* SIF525 */
        352, 240, SCHRO_CHROMA_420,
        FALSE, FALSE,
        15000, 1001, 10, 11,
        352, 240, 0, 0,
        0, 255, 128, 255,
      1, 1, 0},
  {0, 0, 0, 0,
        4,                      /* CIF */
        352, 288, SCHRO_CHROMA_420,
        FALSE, TRUE,
        25, 2, 12, 11,
        352, 288, 0, 0,
        0, 255, 128, 255,
      2, 1, 0},
  {0, 0, 0, 0,
        5,                      /* 4SIF525 */
        704, 480, SCHRO_CHROMA_420,
        FALSE, FALSE,
        15000, 1001, 10, 11,
        704, 480, 0, 0,
        0, 255, 128, 255,
      1, 1, 0},
  {0, 0, 0, 0,
        6,                      /* 4CIF */
        704, 576, SCHRO_CHROMA_420,
        FALSE, TRUE,
        25, 2, 12, 11,
        704, 576, 0, 0,
        0, 255, 128, 255,
      2, 1, 0},
  {0, 0, 0, 0,
        7,                      /* SD480I-60 */
        720, 480, SCHRO_CHROMA_422,
        TRUE, FALSE,
        30000, 1001, 10, 11,
        704, 480, 8, 0,
        64, 876, 512, 896,
      1, 1, 0},
  {0, 0, 0, 0,
        8,                      /* SD576I-50 */
        720, 576, SCHRO_CHROMA_422,
        TRUE, TRUE,
        25, 1, 12, 11,
        704, 576, 8, 0,
        64, 876, 512, 896,
      2, 1, 0},
  {0, 0, 0, 0,
        9,                      /* HD720P-60 */
        1280, 720, SCHRO_CHROMA_422,
        FALSE, TRUE,
        60000, 1001, 1, 1,
        1280, 720, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        10,                     /* HD720P-50 */
        1280, 720, SCHRO_CHROMA_422,
        FALSE, TRUE,
        50, 1, 1, 1,
        1280, 720, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        11,                     /* HD1080I-60 */
        1920, 1080, SCHRO_CHROMA_422,
        TRUE, TRUE,
        30000, 1001, 1, 1,
        1920, 1080, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        12,                     /* HD1080I-50 */
        1920, 1080, SCHRO_CHROMA_422,
        TRUE, TRUE,
        25, 1, 1, 1,
        1920, 1080, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        13,                     /* HD1080P-60 */
        1920, 1080, SCHRO_CHROMA_422,
        FALSE, TRUE,
        60000, 1001, 1, 1,
        1920, 1080, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        14,                     /* HD1080P-50 */
        1920, 1080, SCHRO_CHROMA_422,
        FALSE, TRUE,
        50, 1, 1, 1,
        1920, 1080, 0, 0,
        64, 876, 512, 896,
      0, 0, 0},
  {0, 0, 0, 0,
        15,                     /* DC2K */
        2048, 1080, SCHRO_CHROMA_444,
        FALSE, TRUE,
        24, 1, 1, 1,
        2048, 1080, 0, 0,
        256, 3504, 2048, 3584,
      3, 0, 0},
  {0, 0, 0, 0,
        16,                     /* DC4K */
        4096, 2160, SCHRO_CHROMA_444,
        FALSE, TRUE,
        24, 1, 1, 1,
        2048, 1536, 0, 0,
        256, 3504, 2048, 3584,
      3, 0, 0},
};

void
schro_video_format_set_std_video_format (DiracSequenceHeader * format,
    int index)
{

  if (index < 0 || index >= ARRAY_SIZE (schro_video_formats)) {
    return;
  }

  memcpy (format, schro_video_formats + index, sizeof (DiracSequenceHeader));
}

typedef struct _SchroFrameRate SchroFrameRate;
struct _SchroFrameRate
{
  int numerator;
  int denominator;
};

static const SchroFrameRate schro_frame_rates[] = {
  {0, 0},
  {24000, 1001},
  {24, 1},
  {25, 1},
  {30000, 1001},
  {30, 1},
  {50, 1},
  {60000, 1001},
  {60, 1},
  {15000, 1001},
  {25, 2}
};

void
schro_video_format_set_std_frame_rate (DiracSequenceHeader * format, int index)
{
  if (index < 1 || index >= ARRAY_SIZE (schro_frame_rates)) {
    return;
  }

  format->frame_rate_numerator = schro_frame_rates[index].numerator;
  format->frame_rate_denominator = schro_frame_rates[index].denominator;
}

typedef struct _SchroPixelAspectRatio SchroPixelAspectRatio;
struct _SchroPixelAspectRatio
{
  int numerator;
  int denominator;
};

static const SchroPixelAspectRatio schro_aspect_ratios[] = {
  {0, 0},
  {1, 1},
  {10, 11},
  {12, 11},
  {40, 33},
  {16, 11},
  {4, 3}
};

void
schro_video_format_set_std_aspect_ratio (DiracSequenceHeader * format,
    int index)
{
  if (index < 1 || index >= ARRAY_SIZE (schro_aspect_ratios)) {
    return;
  }

  format->aspect_ratio_numerator = schro_aspect_ratios[index].numerator;
  format->aspect_ratio_denominator = schro_aspect_ratios[index].denominator;

}

typedef struct _SchroSignalRangeStruct SchroSignalRangeStruct;
struct _SchroSignalRangeStruct
{
  int luma_offset;
  int luma_excursion;
  int chroma_offset;
  int chroma_excursion;
};

static const SchroSignalRangeStruct schro_signal_ranges[] = {
  {0, 0, 0, 0},
  {0, 255, 128, 255},
  {16, 219, 128, 224},
  {64, 876, 512, 896},
  {256, 3504, 2048, 3584}
};

void
schro_video_format_set_std_signal_range (DiracSequenceHeader * format, int i)
{
  if (i < 1 || i >= ARRAY_SIZE (schro_signal_ranges)) {
    return;
  }

  format->luma_offset = schro_signal_ranges[i].luma_offset;
  format->luma_excursion = schro_signal_ranges[i].luma_excursion;
  format->chroma_offset = schro_signal_ranges[i].chroma_offset;
  format->chroma_excursion = schro_signal_ranges[i].chroma_excursion;
}

typedef struct _SchroColourSpecStruct SchroColourSpecStruct;
struct _SchroColourSpecStruct
{
  int colour_primaries;
  int colour_matrix;
  int transfer_function;
};

static const SchroColourSpecStruct schro_colour_specs[] = {
  {                             /* Custom */
        SCHRO_COLOUR_PRIMARY_HDTV,
        SCHRO_COLOUR_MATRIX_HDTV,
      SCHRO_TRANSFER_CHAR_TV_GAMMA},
  {                             /* SDTV 525 */
        SCHRO_COLOUR_PRIMARY_SDTV_525,
        SCHRO_COLOUR_MATRIX_SDTV,
      SCHRO_TRANSFER_CHAR_TV_GAMMA},
  {                             /* SDTV 625 */
        SCHRO_COLOUR_PRIMARY_SDTV_625,
        SCHRO_COLOUR_MATRIX_SDTV,
      SCHRO_TRANSFER_CHAR_TV_GAMMA},
  {                             /* HDTV */
        SCHRO_COLOUR_PRIMARY_HDTV,
        SCHRO_COLOUR_MATRIX_HDTV,
      SCHRO_TRANSFER_CHAR_TV_GAMMA},
  {                             /* Cinema */
        SCHRO_COLOUR_PRIMARY_CINEMA,
        SCHRO_COLOUR_MATRIX_HDTV,
      SCHRO_TRANSFER_CHAR_TV_GAMMA}
};

void
schro_video_format_set_std_colour_spec (DiracSequenceHeader * format, int i)
{
  if (i < 0 || i >= ARRAY_SIZE (schro_colour_specs)) {
    return;
  }

  format->colour_primaries = schro_colour_specs[i].colour_primaries;
  format->colour_matrix = schro_colour_specs[i].colour_matrix;
  format->transfer_function = schro_colour_specs[i].transfer_function;
}


/* unpack */

static void
schro_unpack_init_with_data (Unpack * unpack, unsigned char *data,
    int n_bytes, unsigned int guard_bit)
{
  memset (unpack, 0, sizeof (Unpack));

  unpack->data = data;
  unpack->n_bits_left = 8 * n_bytes;
  unpack->guard_bit = guard_bit;
}

static unsigned int
schro_unpack_decode_bit (Unpack * unpack)
{
  int bit;

  if (unpack->n_bits_left < 1) {
    return unpack->guard_bit;
  }
  bit = (unpack->data[unpack->index >> 3] >> (7 - (unpack->index & 7))) & 1;
  unpack->index++;
  unpack->n_bits_left--;

  return bit;
}

static unsigned int
schro_unpack_decode_uint (Unpack * unpack)
{
  int count;
  int value;

  count = 0;
  value = 0;
  while (!schro_unpack_decode_bit (unpack)) {
    count++;
    value <<= 1;
    value |= schro_unpack_decode_bit (unpack);
  }

  return (1 << count) - 1 + value;
}
