/*
 * Copyright (c) 2018, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <stdbool.h>
#include <memory>
#include <tuple>
#include "aom_mem/aom_mem.h"
#include "av1/encoder/rdopt.h"
#include "test/util.h"
#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

namespace {

using std::get;
using std::tuple;

static int get_pix(uint8_t *buf, int i, bool high_bd) {
  if (high_bd) {
    return *CONVERT_TO_SHORTPTR(buf + i);
  } else {
    return buf[i];
  }
}

/** Get the (i, j) value from the input; if i or j is outside of the width
 * or height, the nearest pixel value is returned.
 */
static int get_nearest_pix(const int *buf, int w, int h, int i, int j) {
  int offset = AOMMAX(AOMMIN(i, w - 1), 0) + w * AOMMAX(AOMMIN(j, h - 1), 0);
  return buf[offset];
}

/** Given the image data, creates a new image with padded values, so an
 * 8-tap filter can be convolved. The padded value is the same as the closest
 * value in the image. Returns a pointer to the start of the image in the
 * padded data. Must be freed with free_pad_8tap. The output will be either
 * 8-bit or 16-bit, depending on the high bit-depth (high_bd) field.
 */
static uint8_t *pad_8tap_convolve(const int *data, int w, int h, bool high_bd) {
  // SIMD optimizations require the width to be a multiple of 8 and the height
  // to be multiples of 4.
  assert(w % 8 == 0);
  assert(h % 4 == 0);
  // For an 8-tap filter, we need to pad with 3 lines on top and on the left,
  // and 4 lines on the right and bottom, for 7 extra lines.
  const int pad_w = w + 7;
  const int pad_h = h + 7;

  uint8_t *dst;
  if (high_bd) {
    dst =
        CONVERT_TO_BYTEPTR(aom_memalign(32, sizeof(uint16_t) * pad_w * pad_h));
  } else {
    dst = (uint8_t *)aom_memalign(32, sizeof(uint8_t) * pad_w * pad_h);
  }
  if (dst == nullptr) {
    EXPECT_NE(dst, nullptr);
    return nullptr;
  }

  for (int j = 0; j < pad_h; ++j) {
    for (int i = 0; i < pad_w; ++i) {
      const int v = get_nearest_pix(data, w, h, i - 3, j - 3);
      if (high_bd) {
        *CONVERT_TO_SHORTPTR(dst + i + j * pad_w) = v;
      } else {
        dst[i + j * pad_w] = static_cast<uint8_t>(v);
      }
    }
  }
  return dst + (w + 7) * 3 + 3;
}

static int stride_8tap(int width) { return width + 7; }

static void free_pad_8tap(uint8_t *padded, int width, bool high_bd) {
  if (high_bd) {
    aom_free(CONVERT_TO_SHORTPTR(padded - (width + 7) * 3 - 3));
  } else {
    aom_free(padded - (width + 7) * 3 - 3);
  }
}

struct Pad8TapConvolveDeleter {
  Pad8TapConvolveDeleter(const int width, const bool high_bd)
      : width(width), high_bd(high_bd) {}
  void operator()(uint8_t *p) {
    if (p != nullptr) {
      free_pad_8tap(p, width, high_bd);
    }
  }
  const int width;
  const bool high_bd;
};

static uint8_t *malloc_bd(int num_entries, bool high_bd) {
  const int bytes_per_entry = high_bd ? sizeof(uint16_t) : sizeof(uint8_t);

  uint8_t *buf = (uint8_t *)aom_memalign(32, bytes_per_entry * num_entries);
  if (high_bd) {
    return CONVERT_TO_BYTEPTR(buf);
  } else {
    return buf;
  }
}

static void free_bd(uint8_t *p, bool high_bd) {
  if (high_bd) {
    aom_free(CONVERT_TO_SHORTPTR(p));
  } else {
    aom_free(p);
  }
}

struct MallocBdDeleter {
  explicit MallocBdDeleter(const bool high_bd) : high_bd(high_bd) {}
  void operator()(uint8_t *p) { free_bd(p, high_bd); }
  const bool high_bd;
};

class EdgeDetectBrightnessTest :
    // Parameters are (brightness, width, height, high bit depth representation,
    // bit depth).
    public ::testing::TestWithParam<tuple<int, int, int, bool, int> > {
 protected:
  void SetUp() override {
    // Allocate a (width by height) array of luma values in orig_.
    // padded_ will be filled by the pad() call, which adds a border around
    // the orig_. The output_ array has enough space for the computation.
    const int brightness = GET_PARAM(0);
    const int width = GET_PARAM(1);
    const int height = GET_PARAM(2);
    const bool high_bd = GET_PARAM(3);

    // Create the padded image of uniform brightness.
    std::unique_ptr<int[]> orig(new int[width * height]);
    ASSERT_NE(orig, nullptr);
    for (int i = 0; i < width * height; ++i) {
      orig[i] = brightness;
    }
    input_ = pad_8tap_convolve(orig.get(), width, height, high_bd);
    ASSERT_NE(input_, nullptr);
    output_ = malloc_bd(width * height, high_bd);
    ASSERT_NE(output_, nullptr);
  }

  void TearDown() override {
    const int width = GET_PARAM(1);
    const bool high_bd = GET_PARAM(3);
    free_pad_8tap(input_, width, high_bd);
    free_bd(output_, high_bd);
  }

  // Skip the tests where brightness exceeds the bit-depth; we run into this
  // issue because of gtest's limitation on valid combinations of test
  // parameters. Also skip the tests where bit depth is greater than 8, but
  // high bit depth representation is not set.
  bool should_skip() const {
    const int brightness = GET_PARAM(0);
    const int bd = GET_PARAM(4);
    if (brightness >= (1 << bd)) {
      return true;
    }
    const bool high_bd = GET_PARAM(3);
    if (bd > 8 && !high_bd) {
      return true;
    }
    return false;
  }

  uint8_t *input_;
  uint8_t *output_;
};

TEST_P(EdgeDetectBrightnessTest, BlurUniformBrightness) {
  // Some combination of parameters are non-sensical, due to limitations
  // of the testing framework. Ignore these.
  if (should_skip()) {
    return;
  }

  // For varying levels of brightness, the algorithm should
  // produce the same output.
  const int brightness = GET_PARAM(0);
  const int width = GET_PARAM(1);
  const int height = GET_PARAM(2);
  const bool high_bd = GET_PARAM(3);
  const int bd = GET_PARAM(4);

  av1_gaussian_blur(input_, stride_8tap(width), width, height, output_, high_bd,
                    bd);
  for (int i = 0; i < width * height; ++i) {
    ASSERT_EQ(brightness, get_pix(output_, i, high_bd));
  }
}

// No edges on a uniformly bright image.
TEST_P(EdgeDetectBrightnessTest, DetectUniformBrightness) {
  if (should_skip()) {
    return;
  }
  const int width = GET_PARAM(1);
  const int height = GET_PARAM(2);
  const bool high_bd = GET_PARAM(3);
  const int bd = GET_PARAM(4);

  ASSERT_EQ(
      0, av1_edge_exists(input_, stride_8tap(width), width, height, high_bd, bd)
             .magnitude);
}

#if CONFIG_AV1_HIGHBITDEPTH
INSTANTIATE_TEST_SUITE_P(ImageBrightnessTests, EdgeDetectBrightnessTest,
                         ::testing::Combine(
                             // Brightness
                             ::testing::Values(0, 1, 2, 127, 128, 129, 254, 255,
                                               256, 511, 512, 1023, 1024, 2048,
                                               4095),
                             // Width
                             ::testing::Values(8, 16, 32),
                             // Height
                             ::testing::Values(4, 8, 12, 32),
                             // High bit depth representation
                             ::testing::Bool(),
                             // Bit depth
                             ::testing::Values(8, 10, 12)));
#else
INSTANTIATE_TEST_SUITE_P(ImageBrightnessTests, EdgeDetectBrightnessTest,
                         ::testing::Combine(
                             // Brightness
                             ::testing::Values(0, 1, 2, 127, 128, 129, 254, 255,
                                               256, 511, 512, 1023, 1024, 2048,
                                               4095),
                             // Width
                             ::testing::Values(8, 16, 32),
                             // Height
                             ::testing::Values(4, 8, 12, 32),
                             // High bit depth representation
                             ::testing::Values(false),
                             // Bit depth
                             ::testing::Values(8)));
#endif

class EdgeDetectImageTest :
    // Parameters are (width, height, high bit depth representation, bit depth).
    public ::testing::TestWithParam<tuple<int, int, bool, int> > {
 protected:
  // Skip the tests where bit depth is greater than 8, but high bit depth
  // representation is not set (limitation of testing framework).
  bool should_skip() const {
    const bool high_bd = GET_PARAM(2);
    const int bd = GET_PARAM(3);
    return bd > 8 && !high_bd;
  }
};

// Generate images with black on one side and white on the other.
TEST_P(EdgeDetectImageTest, BlackWhite) {
  // Some combination of parameters are non-sensical, due to limitations
  // of the testing framework. Ignore these.
  if (should_skip()) {
    return;
  }

  const int width = GET_PARAM(0);
  const int height = GET_PARAM(1);
  const bool high_bd = GET_PARAM(2);
  const int bd = GET_PARAM(3);

  const int white = (1 << bd) - 1;
  std::unique_ptr<int[]> orig(new int[width * height]);
  for (int j = 0; j < height; ++j) {
    for (int i = 0; i < width; ++i) {
      if (i < width / 2) {
        orig[i + j * width] = 0;
      } else {
        orig[i + j * width] = white;
      }
    }
  }

  std::unique_ptr<uint8_t[], Pad8TapConvolveDeleter> padded(
      pad_8tap_convolve(orig.get(), width, height, high_bd),
      Pad8TapConvolveDeleter(width, high_bd));
  ASSERT_NE(padded, nullptr);
  // Value should be between 556 and 560.
  ASSERT_LE(556, av1_edge_exists(padded.get(), stride_8tap(width), width,
                                 height, high_bd, bd)
                     .magnitude);
  ASSERT_GE(560, av1_edge_exists(padded.get(), stride_8tap(width), width,
                                 height, high_bd, bd)
                     .magnitude);
}

// Hardcoded blur tests.
static const int luma[32] = { 241, 147, 7,   90,  184, 103, 28,  186,
                              2,   248, 49,  242, 114, 146, 127, 22,
                              121, 228, 167, 108, 158, 174, 41,  168,
                              214, 99,  184, 109, 114, 247, 117, 119 };
static const uint8_t expected[] = { 161, 138, 119, 118, 123, 118, 113, 122,
                                    143, 140, 134, 133, 134, 126, 116, 114,
                                    147, 149, 145, 142, 143, 138, 126, 118,
                                    164, 156, 148, 144, 148, 148, 138, 126 };

static void hardcoded_blur_test_aux(const bool high_bd) {
  const int w = 8;
  const int h = 4;
  for (int bd = 8; bd <= 12; bd += 2) {
    // Skip the tests where bit depth is greater than 8, but high bit depth
    // representation is not set.
    if (bd > 8 && !high_bd) {
      break;
    }
    std::unique_ptr<uint8_t[], MallocBdDeleter> output(
        malloc_bd(w * h, high_bd), MallocBdDeleter(high_bd));
    ASSERT_NE(output, nullptr);
    std::unique_ptr<uint8_t[], Pad8TapConvolveDeleter> padded(
        pad_8tap_convolve(luma, w, h, high_bd),
        Pad8TapConvolveDeleter(w, high_bd));
    ASSERT_NE(padded, nullptr);
    av1_gaussian_blur(padded.get(), stride_8tap(w), w, h, output.get(), high_bd,
                      bd);
    for (int i = 0; i < w * h; ++i) {
      ASSERT_EQ(expected[i], get_pix(output.get(), i, high_bd));
    }

    // If we multiply the inputs by a constant factor, the output should not
    // vary more than 0.5 * factor.
    for (int c = 2; c < (1 << (bd - 8)); ++c) {
      int scaled_luma[32];
      for (int i = 0; i < 32; ++i) {
        scaled_luma[i] = luma[i] * c;
      }
      padded.reset(pad_8tap_convolve(scaled_luma, w, h, high_bd));
      ASSERT_NE(padded, nullptr);
      av1_gaussian_blur(padded.get(), stride_8tap(w), w, h, output.get(),
                        high_bd, bd);
      for (int i = 0; i < w * h; ++i) {
        ASSERT_GE(c / 2,
                  abs(expected[i] * c - get_pix(output.get(), i, high_bd)));
      }
    }
  }
}

TEST(EdgeDetectImageTest, HardcodedBlurTest) {
  hardcoded_blur_test_aux(false);
#if CONFIG_AV1_HIGHBITDEPTH
  hardcoded_blur_test_aux(true);
#endif
}

TEST(EdgeDetectImageTest, SobelTest) {
  // Randomly generated 3x3. Compute Sobel for middle value.
  const uint8_t buf[9] = { 241, 147, 7, 90, 184, 103, 28, 186, 2 };
  const int stride = 3;
  bool high_bd = false;
  sobel_xy result = av1_sobel(buf, stride, 1, 1, high_bd);
  ASSERT_EQ(234, result.x);
  ASSERT_EQ(140, result.y);

#if CONFIG_AV1_HIGHBITDEPTH
  // Verify it works for 8-bit values in a high bit-depth buffer.
  const uint16_t buf8_16[9] = { 241, 147, 7, 90, 184, 103, 28, 186, 2 };
  high_bd = true;
  result = av1_sobel(CONVERT_TO_BYTEPTR(buf8_16), stride, 1, 1, high_bd);
  ASSERT_EQ(234, result.x);
  ASSERT_EQ(140, result.y);

  // Verify it works for high bit-depth values as well.
  const uint16_t buf16[9] = { 241, 147, 7, 90, 184, 2003, 1028, 186, 2 };
  result = av1_sobel(CONVERT_TO_BYTEPTR(buf16), stride, 1, 1, high_bd);
  ASSERT_EQ(-2566, result.x);
  ASSERT_EQ(-860, result.y);
#endif
}

#if CONFIG_AV1_HIGHBITDEPTH
INSTANTIATE_TEST_SUITE_P(EdgeDetectImages, EdgeDetectImageTest,
                         ::testing::Combine(
                             // Width
                             ::testing::Values(8, 16, 32),
                             // Height
                             ::testing::Values(4, 8, 12, 32),
                             // High bit depth representation
                             ::testing::Bool(),
                             // Bit depth
                             ::testing::Values(8, 10, 12)));
#else
INSTANTIATE_TEST_SUITE_P(EdgeDetectImages, EdgeDetectImageTest,
                         ::testing::Combine(
                             // Width
                             ::testing::Values(8, 16, 32),
                             // Height
                             ::testing::Values(4, 8, 12, 32),
                             // High bit depth representation
                             ::testing::Values(false),
                             // Bit depth
                             ::testing::Values(8)));
#endif
}  // namespace
