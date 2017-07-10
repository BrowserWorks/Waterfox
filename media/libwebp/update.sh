#!/bin/sh
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#
# Usage: ./update.sh <libwebp_directory>
#
# Copies the needed files from a directory containing the original
# libwebp source.

cp $1/AUTHORS .
cp $1/COPYING .
cp $1/NEWS .
cp $1/PATENTS .
cp $1/README .
cp $1/README.mux .

mkdir -p webp
cp $1/src/webp/*.h webp

mkdir -p dec
cp $1/src/dec/*.h dec
cp $1/src/dec/alpha_dec.c dec
cp $1/src/dec/buffer_dec.c dec
cp $1/src/dec/frame_dec.c dec
cp $1/src/dec/idec_dec.c dec
cp $1/src/dec/io_dec.c dec
cp $1/src/dec/quant_dec.c dec
cp $1/src/dec/tree_dec.c dec
cp $1/src/dec/vp8_dec.c dec
cp $1/src/dec/vp8l_dec.c dec
cp $1/src/dec/webp_dec.c dec

mkdir -p demux
cp $1/src/demux/demux.c demux

mkdir -p dsp
cp $1/src/dsp/*.h dsp
cp $1/src/dsp/alpha_processing.c dsp
cp $1/src/dsp/alpha_processing_sse2.c dsp
cp $1/src/dsp/alpha_processing_sse41.c dsp
cp $1/src/dsp/dec.c dsp
cp $1/src/dsp/dec_clip_tables.c dsp
cp $1/src/dsp/dec_neon.c dsp
cp $1/src/dsp/dec_sse2.c dsp
cp $1/src/dsp/dec_sse41.c dsp
cp $1/src/dsp/filters.c dsp
cp $1/src/dsp/filters_sse2.c dsp
cp $1/src/dsp/lossless.c dsp
cp $1/src/dsp/lossless_neon.c dsp
cp $1/src/dsp/lossless_sse2.c dsp
cp $1/src/dsp/rescaler.c dsp
cp $1/src/dsp/rescaler_neon.c dsp
cp $1/src/dsp/rescaler_sse2.c dsp
cp $1/src/dsp/upsampling.c dsp
cp $1/src/dsp/upsampling_neon.c dsp
cp $1/src/dsp/upsampling_sse2.c dsp
cp $1/src/dsp/yuv.c dsp
cp $1/src/dsp/yuv_sse2.c dsp

mkdir -p enc
cp $1/src/enc/*.h enc

mkdir -p utils
cp $1/src/utils/*.h utils
cp $1/src/utils/bit_reader_utils.c utils
cp $1/src/utils/color_cache_utils.c utils
cp $1/src/utils/filters_utils.c utils
cp $1/src/utils/huffman_utils.c utils
cp $1/src/utils/quant_levels_dec_utils.c utils
cp $1/src/utils/quant_levels_utils.c utils
cp $1/src/utils/random_utils.c utils
cp $1/src/utils/rescaler_utils.c utils
cp $1/src/utils/thread_utils.c utils
cp $1/src/utils/utils.c utils
