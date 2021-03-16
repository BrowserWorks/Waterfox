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

#include <stdbool.h>
#include "common/rawenc.h"

#define BATCH_SIZE 8
// When writing greyscale color, batch 8 writes for low bit-depth, 4 writes
// for high bit-depth.
static const uint8_t batched[BATCH_SIZE] = { 128, 128, 128, 128,
                                             128, 128, 128, 128 };
static const uint8_t batched_hbd[BATCH_SIZE] = {
  0, 128, 0, 128, 0, 128, 0, 128
};

// Interface to writing to either a file or MD5Context. Takes a pointer to
// either the file or MD5Context, the buffer, the size of each element, and
// number of elements to write. Note that size and nmemb (last two args) must
// be unsigned int, as the interface to MD5Update requires that.
typedef void (*WRITER)(void *, const uint8_t *, unsigned int, unsigned int);

static void write_file(void *fp, const uint8_t *buffer, unsigned int size,
                       unsigned int nmemb) {
  fwrite(buffer, size, nmemb, (FILE *)fp);
}

static void write_md5(void *md5, const uint8_t *buffer, unsigned int size,
                      unsigned int nmemb) {
  MD5Update((MD5Context *)md5, buffer, size * nmemb);
}

// Writes out n greyscale values.
static void write_greyscale(const bool high_bitdepth, int n, WRITER writer_func,
                            void *file_or_md5) {
  const uint8_t *b = batched;
  if (high_bitdepth) {
    b = batched_hbd;
  }
  const int num_batched_writes =
      high_bitdepth ? n / (BATCH_SIZE / 2) : n / BATCH_SIZE;
  for (int i = 0; i < num_batched_writes; ++i) {
    writer_func(file_or_md5, b, sizeof(uint8_t), BATCH_SIZE);
  }
  const int remaining = high_bitdepth ? n % (BATCH_SIZE / 2) : n % BATCH_SIZE;
  for (int i = 0; i < remaining; ++i) {
    if (high_bitdepth) {
      writer_func(file_or_md5, batched_hbd, sizeof(uint8_t), 2);
    } else {
      writer_func(file_or_md5, batched, sizeof(uint8_t), 1);
    }
  }
}

// Encapsulates the logic for writing raw data to either an image file or
// to an MD5 context.
static void raw_write_image_file_or_md5(const aom_image_t *img,
                                        const int *planes, const int num_planes,
                                        void *file_or_md5, WRITER writer_func) {
  const bool high_bitdepth = img->fmt & AOM_IMG_FMT_HIGHBITDEPTH;
  const int bytes_per_sample = high_bitdepth ? 2 : 1;
  for (int i = 0; i < num_planes; ++i) {
    const int plane = planes[i];
    const int w = aom_img_plane_width(img, plane);
    const int h = aom_img_plane_height(img, plane);
    // If we're on a color plane and the output is monochrome, write a greyscale
    // value. Since there are only YUV planes, compare against Y.
    if (img->monochrome && plane != AOM_PLANE_Y) {
      write_greyscale(high_bitdepth, w * h, writer_func, file_or_md5);
      continue;
    }
    const unsigned char *buf = img->planes[plane];
    const int stride = img->stride[plane];
    for (int y = 0; y < h; ++y) {
      writer_func(file_or_md5, buf, bytes_per_sample, w);
      buf += stride;
    }
  }
}

void raw_write_image_file(const aom_image_t *img, const int *planes,
                          const int num_planes, FILE *file) {
  raw_write_image_file_or_md5(img, planes, num_planes, file, write_file);
}

void raw_update_image_md5(const aom_image_t *img, const int *planes,
                          const int num_planes, MD5Context *md5) {
  raw_write_image_file_or_md5(img, planes, num_planes, md5, write_md5);
}
