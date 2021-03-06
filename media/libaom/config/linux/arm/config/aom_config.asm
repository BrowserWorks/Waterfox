;
; Copyright (c) 2021, Alliance for Open Media. All rights reserved
;
; This source code is subject to the terms of the BSD 2 Clause License and
; the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
; was not distributed with this source code in the LICENSE file, you can
; obtain it at www.aomedia.org/license/software. If the Alliance for Open
; Media Patent License 1.0 was not distributed with this source code in the
; PATENTS file, you can obtain it at www.aomedia.org/license/patent.
;

.equ ARCH_ARM, 1
.equ ARCH_MIPS, 0
.equ ARCH_PPC, 0
.equ ARCH_X86, 0
.equ ARCH_X86_64, 0
.equ CONFIG_ACCOUNTING, 0
.equ CONFIG_ANALYZER, 0
.equ CONFIG_AV1_DECODER, 1
.equ CONFIG_AV1_ENCODER, 0
.equ CONFIG_AV1_HIGHBITDEPTH, 1
.equ CONFIG_BIG_ENDIAN, 0
.equ CONFIG_BITSTREAM_DEBUG, 0
.equ CONFIG_COEFFICIENT_RANGE_CHECKING, 0
.equ CONFIG_COLLECT_COMPONENT_TIMING, 0
.equ CONFIG_COLLECT_PARTITION_STATS, 0
.equ CONFIG_COLLECT_RD_STATS, 0
.equ CONFIG_DEBUG, 0
.equ CONFIG_DENOISE, 1
.equ CONFIG_DISABLE_FULL_PIXEL_SPLIT_8X8, 1
.equ CONFIG_DIST_8X8, 0
.equ CONFIG_ENTROPY_STATS, 0
.equ CONFIG_GCC, 1
.equ CONFIG_GCOV, 0
.equ CONFIG_GPROF, 0
.equ CONFIG_HTB_TRELLIS, 0
.equ CONFIG_INSPECTION, 0
.equ CONFIG_INTERNAL_STATS, 0
.equ CONFIG_INTER_STATS_ONLY, 0
.equ CONFIG_LIBYUV, 0
.equ CONFIG_LPF_MASK, 0
.equ CONFIG_MAX_DECODE_PROFILE, 2
.equ CONFIG_MISMATCH_DEBUG, 0
.equ CONFIG_MULTITHREAD, 1
.equ CONFIG_NN_V2, 0
.equ CONFIG_NORMAL_TILE_MODE, 0
.equ CONFIG_OS_SUPPORT, 1
.equ CONFIG_PIC, 1
.equ CONFIG_RD_DEBUG, 0
.equ CONFIG_REALTIME_ONLY, 0
.equ CONFIG_RUNTIME_CPU_DETECT, 1
.equ CONFIG_SHARED, 0
.equ CONFIG_SHARP_SETTINGS, 0
.equ CONFIG_SIZE_LIMIT, 0
.equ CONFIG_SPATIAL_RESAMPLING, 1
.equ CONFIG_SPEED_STATS, 0
.equ CONFIG_SUPERRES_IN_RECODE, 1
.equ CONFIG_TUNE_VMAF, 0
.equ CONFIG_WEBM_IO, 0
.equ DECODE_HEIGHT_LIMIT, 0
.equ DECODE_WIDTH_LIMIT, 0
.equ FORCE_HIGHBITDEPTH_DECODING, 0
.equ HAVE_AVX, 0
.equ HAVE_AVX2, 0
.equ HAVE_DSPR2, 0
.equ HAVE_FEXCEPT, 1
.equ HAVE_MIPS32, 0
.equ HAVE_MIPS64, 0
.equ HAVE_MMX, 0
.equ HAVE_MSA, 0
.equ HAVE_NEON, 1
.equ HAVE_SSE, 0
.equ HAVE_SSE2, 0
.equ HAVE_SSE3, 0
.equ HAVE_SSE4_1, 0
.equ HAVE_SSE4_2, 0
.equ HAVE_SSSE3, 0
.equ HAVE_VSX, 0
.equ HAVE_WXWIDGETS, 0
.section	.note.GNU-stack,"",%progbits