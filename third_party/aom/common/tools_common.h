/*
 * Copyright (c) 2016, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */
#ifndef AOM_COMMON_TOOLS_COMMON_H_
#define AOM_COMMON_TOOLS_COMMON_H_

#include <stdio.h>

#include "config/aom_config.h"

#include "aom/aom_codec.h"
#include "aom/aom_image.h"
#include "aom/aom_integer.h"
#include "aom_ports/mem.h"
#include "aom_ports/msvc.h"

#if CONFIG_AV1_ENCODER
#include "common/y4minput.h"
#endif

#if defined(_MSC_VER)
/* MSVS uses _f{seek,tell}i64. */
#define fseeko _fseeki64
#define ftello _ftelli64
typedef int64_t FileOffset;
#elif defined(_WIN32)
#include <sys/types.h> /* NOLINT*/
/* MinGW uses f{seek,tell}o64 for large files. */
#define fseeko fseeko64
#define ftello ftello64
typedef off64_t FileOffset;
#elif CONFIG_OS_SUPPORT
#include <sys/types.h> /* NOLINT*/
typedef off_t FileOffset;
/* Use 32-bit file operations in WebM file format when building ARM
 * executables (.axf) with RVCT. */
#else
#define fseeko fseek
#define ftello ftell
typedef long FileOffset; /* NOLINT */
#endif /* CONFIG_OS_SUPPORT */

#if CONFIG_OS_SUPPORT
#if defined(_MSC_VER)
#include <io.h> /* NOLINT */
#define isatty _isatty
#define fileno _fileno
#else
#include <unistd.h> /* NOLINT */
#endif              /* _MSC_VER */
#endif              /* CONFIG_OS_SUPPORT */

#define LITERALU64(hi, lo) ((((uint64_t)hi) << 32) | lo)

#ifndef PATH_MAX
#define PATH_MAX 512
#endif

#define IVF_FRAME_HDR_SZ (4 + 8) /* 4 byte size + 8 byte timestamp */
#define IVF_FILE_HDR_SZ 32

#define RAW_FRAME_HDR_SZ sizeof(uint32_t)

#define AV1_FOURCC 0x31305641

enum VideoFileType {
  FILE_TYPE_OBU,
  FILE_TYPE_RAW,
  FILE_TYPE_IVF,
  FILE_TYPE_Y4M,
  FILE_TYPE_WEBM
};

// Used in lightfield example.
enum {
  YUV1D,  // 1D tile output for conformance test.
  YUV,    // Tile output in YUV format.
  NV12,   // Tile output in NV12 format.
} UENUM1BYTE(OUTPUT_FORMAT);

// The fourcc for large_scale_tile encoding is "LSTC".
#define LST_FOURCC 0x4354534c

struct FileTypeDetectionBuffer {
  char buf[4];
  size_t buf_read;
  size_t position;
};

struct AvxRational {
  int numerator;
  int denominator;
};

struct AvxInputContext {
  const char *filename;
  FILE *file;
  int64_t length;
  struct FileTypeDetectionBuffer detect;
  enum VideoFileType file_type;
  uint32_t width;
  uint32_t height;
  struct AvxRational pixel_aspect_ratio;
  aom_img_fmt_t fmt;
  aom_bit_depth_t bit_depth;
  int only_i420;
  uint32_t fourcc;
  struct AvxRational framerate;
#if CONFIG_AV1_ENCODER
  y4m_input y4m;
#endif
};

#ifdef __cplusplus
extern "C" {
#endif

#if defined(__GNUC__)
#define AOM_NO_RETURN __attribute__((noreturn))
#else
#define AOM_NO_RETURN
#endif

/* Sets a stdio stream into binary mode */
FILE *set_binary_mode(FILE *stream);

void die(const char *fmt, ...) AOM_NO_RETURN;
void fatal(const char *fmt, ...) AOM_NO_RETURN;
void warn(const char *fmt, ...);

void die_codec(aom_codec_ctx_t *ctx, const char *s) AOM_NO_RETURN;

/* The tool including this file must define usage_exit() */
void usage_exit(void) AOM_NO_RETURN;

#undef AOM_NO_RETURN

int read_yuv_frame(struct AvxInputContext *input_ctx, aom_image_t *yuv_frame);

///////////////////////////////////////////////////////////////////////////////
// A description of the interfaces used to access the AOM codecs
///////////////////////////////////////////////////////////////////////////////
//
// There are three levels of interfaces used to access the AOM codec: the
// AVXInterface, the aom_codec_iface, and the aom_codec_ctx. Each of these
// is described in detail here.
//
//
// 1. AVXInterface
//    (Related files: common/tools_common.c,  common/tools_common.h)
//
// The high-level interface to the AVx encoders / decoders. Each AvxInterface
// contains the name of the codec (e.g., "av1"), the four character code
// associated with it, and a function pointer to the actual interface (see the
// documentation on aom_codec_iface_t for more info). This API
// is meant for lookup / iteration over all known codecs.
//
// For the encoder, call get_aom_encoder_by_name(...) if you know the name
// (e.g., "av1"); to iterate over all known encoders, use
// get_aom_encoder_count() and get_aom_encoder_by_index(i). To get the
// encoder specifically for large scale tile encoding, use
// get_aom_lst_encoder().
//
// For the decoder, similar functions are available. There is also a
// get_aom_decoder_by_fourcc(fourcc) to get the decoder based on the four
// character codes.
//
// The main purpose of the AVXInterface is to get a reference to the
// aom_codec_interface_t, pointed to by its codec_interface variable.
//
//
// 2. aom_codec_iface_t
//    (Related files: aom/aom_codec.h, aom/src/aom_codec.c,
//    aom/internal/aom_codec_internal.h, av1/av1_cx_iface.c,
//    av1/av1_dx_iface.c)
//
// Used to initialize the codec context, which contains the configuration for
// for modifying the encoder/decoder during run-time. See the documentation of
// aom/aom_codec.h for more details. For the most part, users will call the
// helper functions listed there, such as aom_codec_iface_name,
// aom_codec_get_caps, etc., to interact with it.
//
// The main purpose of the aom_codec_iface_t is to provide a way to generate
// a default codec config, find out what capabilities the implementation has,
// and create an aom_codec_ctx_t (which is actually used to interact with the
// codec).
//
// Note that the implementations of the aom_codec_iface_t are located in
// av1/av1_cx_iface.c and av1/av1_dx_iface.c
//
//
// 3. aom_codec_ctx_t
//  (Related files: aom/aom_codec.h, av1/av1_cx_iface.c, av1/av1_dx_iface.c,
//   aom/aomcx.h, aom/aomdx.h, aom/src/aom_encoder.c, aom/src/aom_decoder.c)
//
// The actual interface between user code and the codec. It stores the name
// of the codec, a pointer back to the aom_codec_iface_t that initialized it,
// initialization flags, a config for either encoder or the decoder, and a
// pointer to internal data.
//
// The codec is configured / queried through calls to aom_codec_control,
// which takes a control code (listed in aomcx.h and aomdx.h) and a parameter.
// In the case of "getter" control codes, the parameter is modified to have
// the requested value; in the case of "setter" control codes, the codec's
// configuration is changed based on the parameter. Note that a aom_codec_err_t
// is returned, which indicates if the operation was successful or not.
//
// Note that for the encoder, the aom_codec_alg_priv_t points to the
// the aom_codec_alg_priv structure in av1/av1_cx_iface.c, and for the decoder,
// the struct in av1/av1_dx_iface.c. Variables such as AV1_COMP cpi are stored
// here and also used in the core algorithm.
//
// At the end, aom_codec_destroy should be called for each initialized
// aom_codec_ctx_t.

typedef struct AvxInterface {
  const char *const name;
  const uint32_t fourcc;
  // Pointer to a function of zero arguments that returns an aom_codec_iface_t
  // pointer. E.g.:
  //   aom_codec_iface_t *codec = interface->codec_interface();
  aom_codec_iface_t *(*const codec_interface)();
} AvxInterface;

int get_aom_encoder_count(void);
// Lookup the interface by index -- it must be the case that
// i < get_aom_encoder_count()
const AvxInterface *get_aom_encoder_by_index(int i);
// Lookup the interface by name -- returns NULL if no match.
const AvxInterface *get_aom_encoder_by_name(const char *name);
const AvxInterface *get_aom_lst_encoder(void);

int get_aom_decoder_count(void);
const AvxInterface *get_aom_decoder_by_index(int i);
const AvxInterface *get_aom_decoder_by_name(const char *name);
// Lookup the interface by the fourcc -- returns NULL if no match.
const AvxInterface *get_aom_decoder_by_fourcc(uint32_t fourcc);

void aom_img_write(const aom_image_t *img, FILE *file);
int aom_img_read(aom_image_t *img, FILE *file);

double sse_to_psnr(double samples, double peak, double mse);
void aom_img_upshift(aom_image_t *dst, const aom_image_t *src, int input_shift);
void aom_img_downshift(aom_image_t *dst, const aom_image_t *src,
                       int down_shift);
void aom_shift_img(unsigned int output_bit_depth, aom_image_t **img_ptr,
                   aom_image_t **img_shifted_ptr);
void aom_img_truncate_16_to_8(aom_image_t *dst, const aom_image_t *src);

// Output in NV12 format.
void aom_img_write_nv12(const aom_image_t *img, FILE *file);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif  // AOM_COMMON_TOOLS_COMMON_H_
