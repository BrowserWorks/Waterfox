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

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <limits.h>

#include "./aom_config.h"

#if CONFIG_OS_SUPPORT
#if HAVE_UNISTD_H
#include <unistd.h>  // NOLINT
#elif !defined(STDOUT_FILENO)
#define STDOUT_FILENO 1
#endif
#endif

#if CONFIG_LIBYUV
#include "third_party/libyuv/include/libyuv/scale.h"
#endif

#include "./args.h"
#include "./ivfdec.h"

#include "aom/aom_decoder.h"
#include "aom_ports/mem_ops.h"
#include "aom_ports/aom_timer.h"

#if CONFIG_AV1_DECODER
#include "aom/aomdx.h"
#endif

#include "./md5_utils.h"

#include "./tools_common.h"
#if CONFIG_WEBM_IO
#include "./webmdec.h"
#endif
#include "./y4menc.h"

static const char *exec_name;

struct AvxDecInputContext {
  struct AvxInputContext *aom_input_ctx;
  struct WebmInputContext *webm_ctx;
};

static const arg_def_t looparg =
    ARG_DEF(NULL, "loops", 1, "Number of times to decode the file");
static const arg_def_t codecarg = ARG_DEF(NULL, "codec", 1, "Codec to use");
static const arg_def_t use_yv12 =
    ARG_DEF(NULL, "yv12", 0, "Output raw YV12 frames");
static const arg_def_t use_i420 =
    ARG_DEF(NULL, "i420", 0, "Output raw I420 frames");
static const arg_def_t flipuvarg =
    ARG_DEF(NULL, "flipuv", 0, "Flip the chroma planes in the output");
static const arg_def_t rawvideo =
    ARG_DEF(NULL, "rawvideo", 0, "Output raw YUV frames");
static const arg_def_t noblitarg =
    ARG_DEF(NULL, "noblit", 0, "Don't process the decoded frames");
static const arg_def_t progressarg =
    ARG_DEF(NULL, "progress", 0, "Show progress after each frame decodes");
static const arg_def_t limitarg =
    ARG_DEF(NULL, "limit", 1, "Stop decoding after n frames");
static const arg_def_t skiparg =
    ARG_DEF(NULL, "skip", 1, "Skip the first n input frames");
static const arg_def_t postprocarg =
    ARG_DEF(NULL, "postproc", 0, "Postprocess decoded frames");
static const arg_def_t summaryarg =
    ARG_DEF(NULL, "summary", 0, "Show timing summary");
static const arg_def_t outputfile =
    ARG_DEF("o", "output", 1, "Output file name pattern (see below)");
static const arg_def_t threadsarg =
    ARG_DEF("t", "threads", 1, "Max threads to use");
static const arg_def_t frameparallelarg =
    ARG_DEF(NULL, "frame-parallel", 0, "Frame parallel decode");
static const arg_def_t verbosearg =
    ARG_DEF("v", "verbose", 0, "Show version string");
static const arg_def_t error_concealment =
    ARG_DEF(NULL, "error-concealment", 0, "Enable decoder error-concealment");
static const arg_def_t scalearg =
    ARG_DEF("S", "scale", 0, "Scale output frames uniformly");
static const arg_def_t continuearg =
    ARG_DEF("k", "keep-going", 0, "(debug) Continue decoding after error");
static const arg_def_t fb_arg =
    ARG_DEF(NULL, "frame-buffers", 1, "Number of frame buffers to use");
static const arg_def_t md5arg =
    ARG_DEF(NULL, "md5", 0, "Compute the MD5 sum of the decoded frame");
static const arg_def_t framestatsarg =
    ARG_DEF(NULL, "framestats", 1, "Output per-frame stats (.csv format)");
#if CONFIG_HIGHBITDEPTH
static const arg_def_t outbitdeptharg =
    ARG_DEF(NULL, "output-bit-depth", 1, "Output bit-depth for decoded frames");
#endif
#if CONFIG_EXT_TILE
static const arg_def_t tiler = ARG_DEF(NULL, "tile-row", 1,
                                       "Row index of tile to decode "
                                       "(-1 for all rows)");
static const arg_def_t tilec = ARG_DEF(NULL, "tile-column", 1,
                                       "Column index of tile to decode "
                                       "(-1 for all columns)");
#endif  // CONFIG_EXT_TILE

static const arg_def_t *all_args[] = { &codecarg,
                                       &use_yv12,
                                       &use_i420,
                                       &flipuvarg,
                                       &rawvideo,
                                       &noblitarg,
                                       &progressarg,
                                       &limitarg,
                                       &skiparg,
                                       &postprocarg,
                                       &summaryarg,
                                       &outputfile,
                                       &threadsarg,
                                       &frameparallelarg,
                                       &verbosearg,
                                       &scalearg,
                                       &fb_arg,
                                       &md5arg,
                                       &framestatsarg,
                                       &error_concealment,
                                       &continuearg,
#if CONFIG_HIGHBITDEPTH
                                       &outbitdeptharg,
#endif
#if CONFIG_EXT_TILE
                                       &tiler,
                                       &tilec,
#endif  // CONFIG_EXT_TILE
                                       NULL };

#if CONFIG_LIBYUV
static INLINE int libyuv_scale(aom_image_t *src, aom_image_t *dst,
                               FilterModeEnum mode) {
#if CONFIG_HIGHBITDEPTH
  if (src->fmt == AOM_IMG_FMT_I42016) {
    assert(dst->fmt == AOM_IMG_FMT_I42016);
    return I420Scale_16(
        (uint16_t *)src->planes[AOM_PLANE_Y], src->stride[AOM_PLANE_Y] / 2,
        (uint16_t *)src->planes[AOM_PLANE_U], src->stride[AOM_PLANE_U] / 2,
        (uint16_t *)src->planes[AOM_PLANE_V], src->stride[AOM_PLANE_V] / 2,
        src->d_w, src->d_h, (uint16_t *)dst->planes[AOM_PLANE_Y],
        dst->stride[AOM_PLANE_Y] / 2, (uint16_t *)dst->planes[AOM_PLANE_U],
        dst->stride[AOM_PLANE_U] / 2, (uint16_t *)dst->planes[AOM_PLANE_V],
        dst->stride[AOM_PLANE_V] / 2, dst->d_w, dst->d_h, mode);
  }
#endif
  assert(src->fmt == AOM_IMG_FMT_I420);
  assert(dst->fmt == AOM_IMG_FMT_I420);
  return I420Scale(src->planes[AOM_PLANE_Y], src->stride[AOM_PLANE_Y],
                   src->planes[AOM_PLANE_U], src->stride[AOM_PLANE_U],
                   src->planes[AOM_PLANE_V], src->stride[AOM_PLANE_V], src->d_w,
                   src->d_h, dst->planes[AOM_PLANE_Y], dst->stride[AOM_PLANE_Y],
                   dst->planes[AOM_PLANE_U], dst->stride[AOM_PLANE_U],
                   dst->planes[AOM_PLANE_V], dst->stride[AOM_PLANE_V], dst->d_w,
                   dst->d_h, mode);
}
#endif

void usage_exit(void) {
  int i;

  fprintf(stderr,
          "Usage: %s <options> filename\n\n"
          "Options:\n",
          exec_name);
  arg_show_usage(stderr, all_args);
  fprintf(stderr,
          "\nOutput File Patterns:\n\n"
          "  The -o argument specifies the name of the file(s) to "
          "write to. If the\n  argument does not include any escape "
          "characters, the output will be\n  written to a single file. "
          "Otherwise, the filename will be calculated by\n  expanding "
          "the following escape characters:\n");
  fprintf(stderr,
          "\n\t%%w   - Frame width"
          "\n\t%%h   - Frame height"
          "\n\t%%<n> - Frame number, zero padded to <n> places (1..9)"
          "\n\n  Pattern arguments are only supported in conjunction "
          "with the --yv12 and\n  --i420 options. If the -o option is "
          "not specified, the output will be\n  directed to stdout.\n");
  fprintf(stderr, "\nIncluded decoders:\n\n");

  for (i = 0; i < get_aom_decoder_count(); ++i) {
    const AvxInterface *const decoder = get_aom_decoder_by_index(i);
    fprintf(stderr, "    %-6s - %s\n", decoder->name,
            aom_codec_iface_name(decoder->codec_interface()));
  }

  exit(EXIT_FAILURE);
}

static int raw_read_frame(FILE *infile, uint8_t **buffer, size_t *bytes_read,
                          size_t *buffer_size) {
  char raw_hdr[RAW_FRAME_HDR_SZ];
  size_t frame_size = 0;

  if (fread(raw_hdr, RAW_FRAME_HDR_SZ, 1, infile) != 1) {
    if (!feof(infile)) warn("Failed to read RAW frame size\n");
  } else {
    const size_t kCorruptFrameThreshold = 256 * 1024 * 1024;
    const size_t kFrameTooSmallThreshold = 256 * 1024;
    frame_size = mem_get_le32(raw_hdr);

    if (frame_size > kCorruptFrameThreshold) {
      warn("Read invalid frame size (%u)\n", (unsigned int)frame_size);
      frame_size = 0;
    }

    if (frame_size < kFrameTooSmallThreshold) {
      warn("Warning: Read invalid frame size (%u) - not a raw file?\n",
           (unsigned int)frame_size);
    }

    if (frame_size > *buffer_size) {
      uint8_t *new_buf = realloc(*buffer, 2 * frame_size);
      if (new_buf) {
        *buffer = new_buf;
        *buffer_size = 2 * frame_size;
      } else {
        warn("Failed to allocate compressed data buffer\n");
        frame_size = 0;
      }
    }
  }

  if (!feof(infile)) {
    if (fread(*buffer, 1, frame_size, infile) != frame_size) {
      warn("Failed to read full frame\n");
      return 1;
    }
    *bytes_read = frame_size;
  }

  return 0;
}

static int read_frame(struct AvxDecInputContext *input, uint8_t **buf,
                      size_t *bytes_in_buffer, size_t *buffer_size) {
  switch (input->aom_input_ctx->file_type) {
#if CONFIG_WEBM_IO
    case FILE_TYPE_WEBM:
      return webm_read_frame(input->webm_ctx, buf, bytes_in_buffer);
#endif
    case FILE_TYPE_RAW:
      return raw_read_frame(input->aom_input_ctx->file, buf, bytes_in_buffer,
                            buffer_size);
    case FILE_TYPE_IVF:
      return ivf_read_frame(input->aom_input_ctx->file, buf, bytes_in_buffer,
                            buffer_size);
    default: return 1;
  }
}

static void update_image_md5(const aom_image_t *img, const int planes[3],
                             MD5Context *md5) {
  int i, y;

  for (i = 0; i < 3; ++i) {
    const int plane = planes[i];
    const unsigned char *buf = img->planes[plane];
    const int stride = img->stride[plane];
    const int w = aom_img_plane_width(img, plane) *
                  ((img->fmt & AOM_IMG_FMT_HIGHBITDEPTH) ? 2 : 1);
    const int h = aom_img_plane_height(img, plane);

    for (y = 0; y < h; ++y) {
      MD5Update(md5, buf, w);
      buf += stride;
    }
  }
}

static void write_image_file(const aom_image_t *img, const int planes[3],
                             FILE *file) {
  int i, y;
#if CONFIG_HIGHBITDEPTH
  const int bytes_per_sample = ((img->fmt & AOM_IMG_FMT_HIGHBITDEPTH) ? 2 : 1);
#else
  const int bytes_per_sample = 1;
#endif

  for (i = 0; i < 3; ++i) {
    const int plane = planes[i];
    const unsigned char *buf = img->planes[plane];
    const int stride = img->stride[plane];
    const int w = aom_img_plane_width(img, plane);
    const int h = aom_img_plane_height(img, plane);

    for (y = 0; y < h; ++y) {
      fwrite(buf, bytes_per_sample, w, file);
      buf += stride;
    }
  }
}

static int file_is_raw(struct AvxInputContext *input) {
  uint8_t buf[32];
  int is_raw = 0;
  aom_codec_stream_info_t si;

  if (fread(buf, 1, 32, input->file) == 32) {
    int i;

    if (mem_get_le32(buf) < 256 * 1024 * 1024) {
      for (i = 0; i < get_aom_decoder_count(); ++i) {
        const AvxInterface *const decoder = get_aom_decoder_by_index(i);
        if (!aom_codec_peek_stream_info(decoder->codec_interface(), buf + 4,
                                        32 - 4, &si)) {
          is_raw = 1;
          input->fourcc = decoder->fourcc;
          input->width = si.w;
          input->height = si.h;
          input->framerate.numerator = 30;
          input->framerate.denominator = 1;
          break;
        }
      }
    }
  }

  rewind(input->file);
  return is_raw;
}

static void show_progress(int frame_in, int frame_out, uint64_t dx_time) {
  fprintf(stderr,
          "%d decoded frames/%d showed frames in %" PRId64 " us (%.2f fps)\r",
          frame_in, frame_out, dx_time,
          (double)frame_out * 1000000.0 / (double)dx_time);
}

struct ExternalFrameBuffer {
  uint8_t *data;
  size_t size;
  int in_use;
};

struct ExternalFrameBufferList {
  int num_external_frame_buffers;
  struct ExternalFrameBuffer *ext_fb;
};

// Callback used by libaom to request an external frame buffer. |cb_priv|
// Application private data passed into the set function. |min_size| is the
// minimum size in bytes needed to decode the next frame. |fb| pointer to the
// frame buffer.
static int get_av1_frame_buffer(void *cb_priv, size_t min_size,
                                aom_codec_frame_buffer_t *fb) {
  int i;
  struct ExternalFrameBufferList *const ext_fb_list =
      (struct ExternalFrameBufferList *)cb_priv;
  if (ext_fb_list == NULL) return -1;

  // Find a free frame buffer.
  for (i = 0; i < ext_fb_list->num_external_frame_buffers; ++i) {
    if (!ext_fb_list->ext_fb[i].in_use) break;
  }

  if (i == ext_fb_list->num_external_frame_buffers) return -1;

  if (ext_fb_list->ext_fb[i].size < min_size) {
    free(ext_fb_list->ext_fb[i].data);
    ext_fb_list->ext_fb[i].data = (uint8_t *)calloc(min_size, sizeof(uint8_t));
    if (!ext_fb_list->ext_fb[i].data) return -1;

    ext_fb_list->ext_fb[i].size = min_size;
  }

  fb->data = ext_fb_list->ext_fb[i].data;
  fb->size = ext_fb_list->ext_fb[i].size;
  ext_fb_list->ext_fb[i].in_use = 1;

  // Set the frame buffer's private data to point at the external frame buffer.
  fb->priv = &ext_fb_list->ext_fb[i];
  return 0;
}

// Callback used by libaom when there are no references to the frame buffer.
// |cb_priv| user private data passed into the set function. |fb| pointer
// to the frame buffer.
static int release_av1_frame_buffer(void *cb_priv,
                                    aom_codec_frame_buffer_t *fb) {
  struct ExternalFrameBuffer *const ext_fb =
      (struct ExternalFrameBuffer *)fb->priv;
  (void)cb_priv;
  ext_fb->in_use = 0;
  return 0;
}

static void generate_filename(const char *pattern, char *out, size_t q_len,
                              unsigned int d_w, unsigned int d_h,
                              unsigned int frame_in) {
  const char *p = pattern;
  char *q = out;

  do {
    char *next_pat = strchr(p, '%');

    if (p == next_pat) {
      size_t pat_len;

      /* parse the pattern */
      q[q_len - 1] = '\0';
      switch (p[1]) {
        case 'w': snprintf(q, q_len - 1, "%d", d_w); break;
        case 'h': snprintf(q, q_len - 1, "%d", d_h); break;
        case '1': snprintf(q, q_len - 1, "%d", frame_in); break;
        case '2': snprintf(q, q_len - 1, "%02d", frame_in); break;
        case '3': snprintf(q, q_len - 1, "%03d", frame_in); break;
        case '4': snprintf(q, q_len - 1, "%04d", frame_in); break;
        case '5': snprintf(q, q_len - 1, "%05d", frame_in); break;
        case '6': snprintf(q, q_len - 1, "%06d", frame_in); break;
        case '7': snprintf(q, q_len - 1, "%07d", frame_in); break;
        case '8': snprintf(q, q_len - 1, "%08d", frame_in); break;
        case '9': snprintf(q, q_len - 1, "%09d", frame_in); break;
        default: die("Unrecognized pattern %%%c\n", p[1]); break;
      }

      pat_len = strlen(q);
      if (pat_len >= q_len - 1) die("Output filename too long.\n");
      q += pat_len;
      p += 2;
      q_len -= pat_len;
    } else {
      size_t copy_len;

      /* copy the next segment */
      if (!next_pat)
        copy_len = strlen(p);
      else
        copy_len = next_pat - p;

      if (copy_len >= q_len - 1) die("Output filename too long.\n");

      memcpy(q, p, copy_len);
      q[copy_len] = '\0';
      q += copy_len;
      p += copy_len;
      q_len -= copy_len;
    }
  } while (*p);
}

static int is_single_file(const char *outfile_pattern) {
  const char *p = outfile_pattern;

  do {
    p = strchr(p, '%');
    if (p && p[1] >= '1' && p[1] <= '9')
      return 0;  // pattern contains sequence number, so it's not unique
    if (p) p++;
  } while (p);

  return 1;
}

static void print_md5(unsigned char digest[16], const char *filename) {
  int i;

  for (i = 0; i < 16; ++i) printf("%02x", digest[i]);
  printf("  %s\n", filename);
}

static FILE *open_outfile(const char *name) {
  if (strcmp("-", name) == 0) {
    set_binary_mode(stdout);
    return stdout;
  } else {
    FILE *file = fopen(name, "wb");
    if (!file) fatal("Failed to open output file '%s'", name);
    return file;
  }
}

#if CONFIG_HIGHBITDEPTH
static int img_shifted_realloc_required(const aom_image_t *img,
                                        const aom_image_t *shifted,
                                        aom_img_fmt_t required_fmt) {
  return img->d_w != shifted->d_w || img->d_h != shifted->d_h ||
         required_fmt != shifted->fmt;
}
#endif

static int main_loop(int argc, const char **argv_) {
  aom_codec_ctx_t decoder;
  char *fn = NULL;
  int i;
  int ret = EXIT_FAILURE;
  uint8_t *buf = NULL;
  size_t bytes_in_buffer = 0, buffer_size = 0;
  FILE *infile;
  int frame_in = 0, frame_out = 0, flipuv = 0, noblit = 0;
  int do_md5 = 0, progress = 0, frame_parallel = 0;
  int stop_after = 0, postproc = 0, summary = 0, quiet = 1;
  int arg_skip = 0;
  int ec_enabled = 0;
  int keep_going = 0;
  const AvxInterface *interface = NULL;
  const AvxInterface *fourcc_interface = NULL;
  uint64_t dx_time = 0;
  struct arg arg;
  char **argv, **argi, **argj;

  int single_file;
  int use_y4m = 1;
  int opt_yv12 = 0;
  int opt_i420 = 0;
  aom_codec_dec_cfg_t cfg = { 0, 0, 0 };
#if CONFIG_HIGHBITDEPTH
  unsigned int output_bit_depth = 0;
#endif
#if CONFIG_EXT_TILE
  int tile_row = -1;
  int tile_col = -1;
#endif  // CONFIG_EXT_TILE
  int frames_corrupted = 0;
  int dec_flags = 0;
  int do_scale = 0;
  aom_image_t *scaled_img = NULL;
#if CONFIG_HIGHBITDEPTH
  aom_image_t *img_shifted = NULL;
#endif
  int frame_avail, got_data, flush_decoder = 0;
  int num_external_frame_buffers = 0;
  struct ExternalFrameBufferList ext_fb_list = { 0, NULL };

  const char *outfile_pattern = NULL;
  char outfile_name[PATH_MAX] = { 0 };
  FILE *outfile = NULL;

  FILE *framestats_file = NULL;

  MD5Context md5_ctx;
  unsigned char md5_digest[16];

  struct AvxDecInputContext input = { NULL, NULL };
  struct AvxInputContext aom_input_ctx;
#if CONFIG_WEBM_IO
  struct WebmInputContext webm_ctx;
  memset(&(webm_ctx), 0, sizeof(webm_ctx));
  input.webm_ctx = &webm_ctx;
#endif
  input.aom_input_ctx = &aom_input_ctx;

  /* Parse command line */
  exec_name = argv_[0];
  argv = argv_dup(argc - 1, argv_ + 1);

  for (argi = argj = argv; (*argj = *argi); argi += arg.argv_step) {
    memset(&arg, 0, sizeof(arg));
    arg.argv_step = 1;

    if (arg_match(&arg, &codecarg, argi)) {
      interface = get_aom_decoder_by_name(arg.val);
      if (!interface)
        die("Error: Unrecognized argument (%s) to --codec\n", arg.val);
    } else if (arg_match(&arg, &looparg, argi)) {
      // no-op
    } else if (arg_match(&arg, &outputfile, argi)) {
      outfile_pattern = arg.val;
    } else if (arg_match(&arg, &use_yv12, argi)) {
      use_y4m = 0;
      flipuv = 1;
      opt_yv12 = 1;
    } else if (arg_match(&arg, &use_i420, argi)) {
      use_y4m = 0;
      flipuv = 0;
      opt_i420 = 1;
    } else if (arg_match(&arg, &rawvideo, argi)) {
      use_y4m = 0;
    } else if (arg_match(&arg, &flipuvarg, argi)) {
      flipuv = 1;
    } else if (arg_match(&arg, &noblitarg, argi)) {
      noblit = 1;
    } else if (arg_match(&arg, &progressarg, argi)) {
      progress = 1;
    } else if (arg_match(&arg, &limitarg, argi)) {
      stop_after = arg_parse_uint(&arg);
    } else if (arg_match(&arg, &skiparg, argi)) {
      arg_skip = arg_parse_uint(&arg);
    } else if (arg_match(&arg, &postprocarg, argi)) {
      postproc = 1;
    } else if (arg_match(&arg, &md5arg, argi)) {
      do_md5 = 1;
    } else if (arg_match(&arg, &framestatsarg, argi)) {
      framestats_file = fopen(arg.val, "w");
      if (!framestats_file) {
        die("Error: Could not open --framestats file (%s) for writing.\n",
            arg.val);
      }
    } else if (arg_match(&arg, &summaryarg, argi)) {
      summary = 1;
    } else if (arg_match(&arg, &threadsarg, argi)) {
      cfg.threads = arg_parse_uint(&arg);
    }
#if CONFIG_AV1_DECODER
    else if (arg_match(&arg, &frameparallelarg, argi))
      frame_parallel = 1;
#endif
    else if (arg_match(&arg, &verbosearg, argi))
      quiet = 0;
    else if (arg_match(&arg, &scalearg, argi))
      do_scale = 1;
    else if (arg_match(&arg, &fb_arg, argi))
      num_external_frame_buffers = arg_parse_uint(&arg);
    else if (arg_match(&arg, &continuearg, argi))
      keep_going = 1;
#if CONFIG_HIGHBITDEPTH
    else if (arg_match(&arg, &outbitdeptharg, argi)) {
      output_bit_depth = arg_parse_uint(&arg);
    }
#endif
#if CONFIG_EXT_TILE
    else if (arg_match(&arg, &tiler, argi))
      tile_row = arg_parse_int(&arg);
    else if (arg_match(&arg, &tilec, argi))
      tile_col = arg_parse_int(&arg);
#endif  // CONFIG_EXT_TILE
    else
      argj++;
  }

  /* Check for unrecognized options */
  for (argi = argv; *argi; argi++)
    if (argi[0][0] == '-' && strlen(argi[0]) > 1)
      die("Error: Unrecognized option %s\n", *argi);

  /* Handle non-option arguments */
  fn = argv[0];

  if (!fn) {
    free(argv);
    usage_exit();
  }
  /* Open file */
  infile = strcmp(fn, "-") ? fopen(fn, "rb") : set_binary_mode(stdin);

  if (!infile) {
    fatal("Failed to open input file '%s'", strcmp(fn, "-") ? fn : "stdin");
  }
#if CONFIG_OS_SUPPORT
  /* Make sure we don't dump to the terminal, unless forced to with -o - */
  if (!outfile_pattern && isatty(STDOUT_FILENO) && !do_md5 && !noblit) {
    fprintf(stderr,
            "Not dumping raw video to your terminal. Use '-o -' to "
            "override.\n");
    return EXIT_FAILURE;
  }
#endif
  input.aom_input_ctx->file = infile;
  if (file_is_ivf(input.aom_input_ctx))
    input.aom_input_ctx->file_type = FILE_TYPE_IVF;
#if CONFIG_WEBM_IO
  else if (file_is_webm(input.webm_ctx, input.aom_input_ctx))
    input.aom_input_ctx->file_type = FILE_TYPE_WEBM;
#endif
  else if (file_is_raw(input.aom_input_ctx))
    input.aom_input_ctx->file_type = FILE_TYPE_RAW;
  else {
    fprintf(stderr, "Unrecognized input file type.\n");
#if !CONFIG_WEBM_IO
    fprintf(stderr, "aomdec was built without WebM container support.\n");
#endif
    return EXIT_FAILURE;
  }

  outfile_pattern = outfile_pattern ? outfile_pattern : "-";
  single_file = is_single_file(outfile_pattern);

  if (!noblit && single_file) {
    generate_filename(outfile_pattern, outfile_name, PATH_MAX,
                      aom_input_ctx.width, aom_input_ctx.height, 0);
    if (do_md5)
      MD5Init(&md5_ctx);
    else
      outfile = open_outfile(outfile_name);
  }

  if (use_y4m && !noblit) {
    if (!single_file) {
      fprintf(stderr,
              "YUV4MPEG2 not supported with output patterns,"
              " try --i420 or --yv12 or --rawvideo.\n");
      return EXIT_FAILURE;
    }

#if CONFIG_WEBM_IO
    if (aom_input_ctx.file_type == FILE_TYPE_WEBM) {
      if (webm_guess_framerate(input.webm_ctx, input.aom_input_ctx)) {
        fprintf(stderr,
                "Failed to guess framerate -- error parsing "
                "webm file?\n");
        return EXIT_FAILURE;
      }
    }
#endif
  }

  fourcc_interface = get_aom_decoder_by_fourcc(aom_input_ctx.fourcc);
  if (interface && fourcc_interface && interface != fourcc_interface)
    warn("Header indicates codec: %s\n", fourcc_interface->name);
  else
    interface = fourcc_interface;

  if (!interface) interface = get_aom_decoder_by_index(0);

  dec_flags = (postproc ? AOM_CODEC_USE_POSTPROC : 0) |
              (ec_enabled ? AOM_CODEC_USE_ERROR_CONCEALMENT : 0) |
              (frame_parallel ? AOM_CODEC_USE_FRAME_THREADING : 0);
  if (aom_codec_dec_init(&decoder, interface->codec_interface(), &cfg,
                         dec_flags)) {
    fprintf(stderr, "Failed to initialize decoder: %s\n",
            aom_codec_error(&decoder));
    goto fail2;
  }

  if (!quiet) fprintf(stderr, "%s\n", decoder.name);

#if CONFIG_AV1_DECODER && CONFIG_EXT_TILE
  if (aom_codec_control(&decoder, AV1_SET_DECODE_TILE_ROW, tile_row)) {
    fprintf(stderr, "Failed to set decode_tile_row: %s\n",
            aom_codec_error(&decoder));
    goto fail;
  }

  if (aom_codec_control(&decoder, AV1_SET_DECODE_TILE_COL, tile_col)) {
    fprintf(stderr, "Failed to set decode_tile_col: %s\n",
            aom_codec_error(&decoder));
    goto fail;
  }
#endif

  if (arg_skip) fprintf(stderr, "Skipping first %d frames.\n", arg_skip);
  while (arg_skip) {
    if (read_frame(&input, &buf, &bytes_in_buffer, &buffer_size)) break;
    arg_skip--;
  }

  if (num_external_frame_buffers > 0) {
    ext_fb_list.num_external_frame_buffers = num_external_frame_buffers;
    ext_fb_list.ext_fb = (struct ExternalFrameBuffer *)calloc(
        num_external_frame_buffers, sizeof(*ext_fb_list.ext_fb));
    if (aom_codec_set_frame_buffer_functions(&decoder, get_av1_frame_buffer,
                                             release_av1_frame_buffer,
                                             &ext_fb_list)) {
      fprintf(stderr, "Failed to configure external frame buffers: %s\n",
              aom_codec_error(&decoder));
      goto fail;
    }
  }

  frame_avail = 1;
  got_data = 0;

  if (framestats_file) fprintf(framestats_file, "bytes,qp\r\n");

  /* Decode file */
  while (frame_avail || got_data) {
    aom_codec_iter_t iter = NULL;
    aom_image_t *img;
    struct aom_usec_timer timer;
    int corrupted = 0;

    frame_avail = 0;
    if (!stop_after || frame_in < stop_after) {
      if (!read_frame(&input, &buf, &bytes_in_buffer, &buffer_size)) {
        frame_avail = 1;
        frame_in++;

        aom_usec_timer_start(&timer);

        if (aom_codec_decode(&decoder, buf, (unsigned int)bytes_in_buffer, NULL,
                             0)) {
          const char *detail = aom_codec_error_detail(&decoder);
          warn("Failed to decode frame %d: %s", frame_in,
               aom_codec_error(&decoder));

          if (detail) warn("Additional information: %s", detail);
          if (!keep_going) goto fail;
        }

        if (framestats_file) {
          int qp;
          if (aom_codec_control(&decoder, AOMD_GET_LAST_QUANTIZER, &qp)) {
            warn("Failed AOMD_GET_LAST_QUANTIZER: %s",
                 aom_codec_error(&decoder));
            if (!keep_going) goto fail;
          }
          fprintf(framestats_file, "%d,%d\r\n", (int)bytes_in_buffer, qp);
        }

        aom_usec_timer_mark(&timer);
        dx_time += aom_usec_timer_elapsed(&timer);
      } else {
        flush_decoder = 1;
      }
    } else {
      flush_decoder = 1;
    }

    aom_usec_timer_start(&timer);

    if (flush_decoder) {
      // Flush the decoder in frame parallel decode.
      if (aom_codec_decode(&decoder, NULL, 0, NULL, 0)) {
        warn("Failed to flush decoder: %s", aom_codec_error(&decoder));
      }
    }

    got_data = 0;
    if ((img = aom_codec_get_frame(&decoder, &iter))) {
      ++frame_out;
      got_data = 1;
    }

    aom_usec_timer_mark(&timer);
    dx_time += (unsigned int)aom_usec_timer_elapsed(&timer);

    if (!frame_parallel &&
        aom_codec_control(&decoder, AOMD_GET_FRAME_CORRUPTED, &corrupted)) {
      warn("Failed AOM_GET_FRAME_CORRUPTED: %s", aom_codec_error(&decoder));
      if (!keep_going) goto fail;
    }
    frames_corrupted += corrupted;

    if (progress) show_progress(frame_in, frame_out, dx_time);

    if (!noblit && img) {
      const int PLANES_YUV[] = { AOM_PLANE_Y, AOM_PLANE_U, AOM_PLANE_V };
      const int PLANES_YVU[] = { AOM_PLANE_Y, AOM_PLANE_V, AOM_PLANE_U };
      const int *planes = flipuv ? PLANES_YVU : PLANES_YUV;

      if (do_scale) {
        if (frame_out == 1) {
          // If the output frames are to be scaled to a fixed display size then
          // use the width and height specified in the container. If either of
          // these is set to 0, use the display size set in the first frame
          // header. If that is unavailable, use the raw decoded size of the
          // first decoded frame.
          int render_width = aom_input_ctx.width;
          int render_height = aom_input_ctx.height;
          if (!render_width || !render_height) {
            int render_size[2];
            if (aom_codec_control(&decoder, AV1D_GET_DISPLAY_SIZE,
                                  render_size)) {
              // As last resort use size of first frame as display size.
              render_width = img->d_w;
              render_height = img->d_h;
            } else {
              render_width = render_size[0];
              render_height = render_size[1];
            }
          }
          scaled_img =
              aom_img_alloc(NULL, img->fmt, render_width, render_height, 16);
          scaled_img->bit_depth = img->bit_depth;
        }

        if (img->d_w != scaled_img->d_w || img->d_h != scaled_img->d_h) {
#if CONFIG_LIBYUV
          libyuv_scale(img, scaled_img, kFilterBox);
          img = scaled_img;
#else
          fprintf(stderr,
                  "Failed  to scale output frame: %s.\n"
                  "Scaling is disabled in this configuration. "
                  "To enable scaling, configure with --enable-libyuv\n",
                  aom_codec_error(&decoder));
          goto fail;
#endif
        }
      }
#if CONFIG_HIGHBITDEPTH
      // Default to codec bit depth if output bit depth not set
      if (!output_bit_depth && single_file && !do_md5) {
        output_bit_depth = img->bit_depth;
      }
      // Shift up or down if necessary
      if (output_bit_depth != 0) {
        const aom_img_fmt_t shifted_fmt =
            output_bit_depth == 8
                ? img->fmt ^ (img->fmt & AOM_IMG_FMT_HIGHBITDEPTH)
                : img->fmt | AOM_IMG_FMT_HIGHBITDEPTH;

        if (shifted_fmt != img->fmt || output_bit_depth != img->bit_depth) {
          if (img_shifted &&
              img_shifted_realloc_required(img, img_shifted, shifted_fmt)) {
            aom_img_free(img_shifted);
            img_shifted = NULL;
          }
          if (!img_shifted) {
            img_shifted =
                aom_img_alloc(NULL, shifted_fmt, img->d_w, img->d_h, 16);
            img_shifted->bit_depth = output_bit_depth;
          }
          if (output_bit_depth > img->bit_depth) {
            aom_img_upshift(img_shifted, img,
                            output_bit_depth - img->bit_depth);
          } else {
            aom_img_downshift(img_shifted, img,
                              img->bit_depth - output_bit_depth);
          }
          img = img_shifted;
        }
      }
#endif

#if CONFIG_EXT_TILE
      aom_input_ctx.width = img->d_w;
      aom_input_ctx.height = img->d_h;
#endif  // CONFIG_EXT_TILE

      if (single_file) {
        if (use_y4m) {
          char y4m_buf[Y4M_BUFFER_SIZE] = { 0 };
          size_t len = 0;
          if (img->fmt == AOM_IMG_FMT_I440 || img->fmt == AOM_IMG_FMT_I44016) {
            fprintf(stderr, "Cannot produce y4m output for 440 sampling.\n");
            goto fail;
          }
          if (frame_out == 1) {
            // Y4M file header
            len = y4m_write_file_header(
                y4m_buf, sizeof(y4m_buf), aom_input_ctx.width,
                aom_input_ctx.height, &aom_input_ctx.framerate, img->fmt,
                img->bit_depth);
            if (do_md5) {
              MD5Update(&md5_ctx, (md5byte *)y4m_buf, (unsigned int)len);
            } else {
              fputs(y4m_buf, outfile);
            }
          }

          // Y4M frame header
          len = y4m_write_frame_header(y4m_buf, sizeof(y4m_buf));
          if (do_md5) {
            MD5Update(&md5_ctx, (md5byte *)y4m_buf, (unsigned int)len);
          } else {
            fputs(y4m_buf, outfile);
          }
        } else {
          if (frame_out == 1) {
            // Check if --yv12 or --i420 options are consistent with the
            // bit-stream decoded
            if (opt_i420) {
              if (img->fmt != AOM_IMG_FMT_I420 &&
                  img->fmt != AOM_IMG_FMT_I42016) {
                fprintf(stderr, "Cannot produce i420 output for bit-stream.\n");
                goto fail;
              }
            }
            if (opt_yv12) {
              if ((img->fmt != AOM_IMG_FMT_I420 &&
                   img->fmt != AOM_IMG_FMT_YV12) ||
                  img->bit_depth != 8) {
                fprintf(stderr, "Cannot produce yv12 output for bit-stream.\n");
                goto fail;
              }
            }
          }
        }

        if (do_md5) {
          update_image_md5(img, planes, &md5_ctx);
        } else {
          write_image_file(img, planes, outfile);
        }
      } else {
        generate_filename(outfile_pattern, outfile_name, PATH_MAX, img->d_w,
                          img->d_h, frame_in);
        if (do_md5) {
          MD5Init(&md5_ctx);
          update_image_md5(img, planes, &md5_ctx);
          MD5Final(md5_digest, &md5_ctx);
          print_md5(md5_digest, outfile_name);
        } else {
          outfile = open_outfile(outfile_name);
          write_image_file(img, planes, outfile);
          fclose(outfile);
        }
      }
    }
  }

  if (summary || progress) {
    show_progress(frame_in, frame_out, dx_time);
    fprintf(stderr, "\n");
  }

  if (frames_corrupted) {
    fprintf(stderr, "WARNING: %d frames corrupted.\n", frames_corrupted);
  } else {
    ret = EXIT_SUCCESS;
  }

fail:

  if (aom_codec_destroy(&decoder)) {
    fprintf(stderr, "Failed to destroy decoder: %s\n",
            aom_codec_error(&decoder));
  }

fail2:

  if (!noblit && single_file) {
    if (do_md5) {
      MD5Final(md5_digest, &md5_ctx);
      print_md5(md5_digest, outfile_name);
    } else {
      fclose(outfile);
    }
  }

#if CONFIG_WEBM_IO
  if (input.aom_input_ctx->file_type == FILE_TYPE_WEBM)
    webm_free(input.webm_ctx);
#endif

  if (input.aom_input_ctx->file_type != FILE_TYPE_WEBM) free(buf);

  if (scaled_img) aom_img_free(scaled_img);
#if CONFIG_HIGHBITDEPTH
  if (img_shifted) aom_img_free(img_shifted);
#endif

  for (i = 0; i < ext_fb_list.num_external_frame_buffers; ++i) {
    free(ext_fb_list.ext_fb[i].data);
  }
  free(ext_fb_list.ext_fb);

  fclose(infile);
  if (framestats_file) fclose(framestats_file);

  free(argv);

  return ret;
}

int main(int argc, const char **argv_) {
  unsigned int loops = 1, i;
  char **argv, **argi, **argj;
  struct arg arg;
  int error = 0;

  argv = argv_dup(argc - 1, argv_ + 1);
  for (argi = argj = argv; (*argj = *argi); argi += arg.argv_step) {
    memset(&arg, 0, sizeof(arg));
    arg.argv_step = 1;

    if (arg_match(&arg, &looparg, argi)) {
      loops = arg_parse_uint(&arg);
      break;
    }
  }
  free(argv);
  for (i = 0; !error && i < loops; i++) error = main_loop(argc, argv_);
  return error;
}
