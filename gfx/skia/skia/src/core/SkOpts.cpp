/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkCpu.h"
#include "SkHalf.h"
#include "SkOnce.h"
#include "SkOpts.h"

#if defined(SK_ARM_HAS_NEON)
    #if defined(SK_ARM_HAS_CRC32)
        #define SK_OPTS_NS neon_and_crc32
    #else
        #define SK_OPTS_NS neon
    #endif
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_AVX2
    #define SK_OPTS_NS avx2
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_AVX
    #define SK_OPTS_NS avx
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSE42
    #define SK_OPTS_NS sse42
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSE41
    #define SK_OPTS_NS sse41
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSSE3
    #define SK_OPTS_NS ssse3
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSE3
    #define SK_OPTS_NS sse3
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSE2
    #define SK_OPTS_NS sse2
#elif SK_CPU_SSE_LEVEL >= SK_CPU_SSE_LEVEL_SSE1
    #define SK_OPTS_NS sse
#else
    #define SK_OPTS_NS portable
#endif

#include "SkBlend_opts.h"
#include "SkBlitMask_opts.h"
#include "SkBlitRow_opts.h"
#include "SkBlurImageFilter_opts.h"
#include "SkChecksum_opts.h"
#include "SkColorCubeFilter_opts.h"
#include "SkMorphologyImageFilter_opts.h"
#include "SkRasterPipeline_opts.h"
#include "SkSwizzler_opts.h"
#include "SkTextureCompressor_opts.h"
#include "SkXfermode_opts.h"

namespace SkOpts {
    // Define default function pointer values here...
    // If our global compile options are set high enough, these defaults might even be
    // CPU-specialized, e.g. a typical x86-64 machine might start with SSE2 defaults.
    // They'll still get a chance to be replaced with even better ones, e.g. using SSE4.1.
#define DEFINE_DEFAULT(name) decltype(name) name = SK_OPTS_NS::name
    DEFINE_DEFAULT(create_xfermode);
    DEFINE_DEFAULT(color_cube_filter_span);

    DEFINE_DEFAULT(box_blur_xx);
    DEFINE_DEFAULT(box_blur_xy);
    DEFINE_DEFAULT(box_blur_yx);

    DEFINE_DEFAULT(dilate_x);
    DEFINE_DEFAULT(dilate_y);
    DEFINE_DEFAULT( erode_x);
    DEFINE_DEFAULT( erode_y);

    DEFINE_DEFAULT(texture_compressor);
    DEFINE_DEFAULT(fill_block_dimensions);

    DEFINE_DEFAULT(blit_mask_d32_a8);

    DEFINE_DEFAULT(blit_row_color32);
    DEFINE_DEFAULT(blit_row_s32a_opaque);

    DEFINE_DEFAULT(RGBA_to_BGRA);
    DEFINE_DEFAULT(RGBA_to_rgbA);
    DEFINE_DEFAULT(RGBA_to_bgrA);
    DEFINE_DEFAULT(RGB_to_RGB1);
    DEFINE_DEFAULT(RGB_to_BGR1);
    DEFINE_DEFAULT(gray_to_RGB1);
    DEFINE_DEFAULT(grayA_to_RGBA);
    DEFINE_DEFAULT(grayA_to_rgbA);
    DEFINE_DEFAULT(inverted_CMYK_to_RGB1);
    DEFINE_DEFAULT(inverted_CMYK_to_BGR1);

    DEFINE_DEFAULT(srcover_srgb_srgb);

    DEFINE_DEFAULT(hash_fn);
#undef DEFINE_DEFAULT

    // TODO: might be nice to only create one instance of tail-insensitive stages.

    SkRasterPipeline::Fn stages_4[] = {
        stage_4<SK_OPTS_NS::store_565 , false>,
        stage_4<SK_OPTS_NS::store_srgb, false>,
        stage_4<SK_OPTS_NS::store_f16 , false>,

        stage_4<SK_OPTS_NS::load_s_565 , true>,
        stage_4<SK_OPTS_NS::load_s_srgb, true>,
        stage_4<SK_OPTS_NS::load_s_f16 , true>,

        stage_4<SK_OPTS_NS::load_d_565 , true>,
        stage_4<SK_OPTS_NS::load_d_srgb, true>,
        stage_4<SK_OPTS_NS::load_d_f16 , true>,

        stage_4<SK_OPTS_NS::scale_u8, true>,

        stage_4<SK_OPTS_NS::lerp_u8            , true>,
        stage_4<SK_OPTS_NS::lerp_565           , true>,
        stage_4<SK_OPTS_NS::lerp_constant_float, true>,

        stage_4<SK_OPTS_NS::constant_color, true>,

        SK_OPTS_NS::dst,
        SK_OPTS_NS::dstatop,
        SK_OPTS_NS::dstin,
        SK_OPTS_NS::dstout,
        SK_OPTS_NS::dstover,
        SK_OPTS_NS::srcatop,
        SK_OPTS_NS::srcin,
        SK_OPTS_NS::srcout,
        SK_OPTS_NS::srcover,
        SK_OPTS_NS::clear,
        SK_OPTS_NS::modulate,
        SK_OPTS_NS::multiply,
        SK_OPTS_NS::plus_,
        SK_OPTS_NS::screen,
        SK_OPTS_NS::xor_,
        SK_OPTS_NS::colorburn,
        SK_OPTS_NS::colordodge,
        SK_OPTS_NS::darken,
        SK_OPTS_NS::difference,
        SK_OPTS_NS::exclusion,
        SK_OPTS_NS::hardlight,
        SK_OPTS_NS::lighten,
        SK_OPTS_NS::overlay,
        SK_OPTS_NS::softlight,
    };
    static_assert(SK_ARRAY_COUNT(stages_4) == SkRasterPipeline::kNumStockStages, "");

    SkRasterPipeline::Fn stages_1_3[] = {
        stage_1_3<SK_OPTS_NS::store_565 , false>,
        stage_1_3<SK_OPTS_NS::store_srgb, false>,
        stage_1_3<SK_OPTS_NS::store_f16 , false>,

        stage_1_3<SK_OPTS_NS::load_s_565 , true>,
        stage_1_3<SK_OPTS_NS::load_s_srgb, true>,
        stage_1_3<SK_OPTS_NS::load_s_f16 , true>,

        stage_1_3<SK_OPTS_NS::load_d_565 , true>,
        stage_1_3<SK_OPTS_NS::load_d_srgb, true>,
        stage_1_3<SK_OPTS_NS::load_d_f16 , true>,

        stage_1_3<SK_OPTS_NS::scale_u8, true>,

        stage_1_3<SK_OPTS_NS::lerp_u8            , true>,
        stage_1_3<SK_OPTS_NS::lerp_565           , true>,
        stage_1_3<SK_OPTS_NS::lerp_constant_float, true>,

        stage_1_3<SK_OPTS_NS::constant_color, true>,

        SK_OPTS_NS::dst,
        SK_OPTS_NS::dstatop,
        SK_OPTS_NS::dstin,
        SK_OPTS_NS::dstout,
        SK_OPTS_NS::dstover,
        SK_OPTS_NS::srcatop,
        SK_OPTS_NS::srcin,
        SK_OPTS_NS::srcout,
        SK_OPTS_NS::srcover,
        SK_OPTS_NS::clear,
        SK_OPTS_NS::modulate,
        SK_OPTS_NS::multiply,
        SK_OPTS_NS::plus_,
        SK_OPTS_NS::screen,
        SK_OPTS_NS::xor_,
        SK_OPTS_NS::colorburn,
        SK_OPTS_NS::colordodge,
        SK_OPTS_NS::darken,
        SK_OPTS_NS::difference,
        SK_OPTS_NS::exclusion,
        SK_OPTS_NS::hardlight,
        SK_OPTS_NS::lighten,
        SK_OPTS_NS::overlay,
        SK_OPTS_NS::softlight,
    };
    static_assert(SK_ARRAY_COUNT(stages_1_3) == SkRasterPipeline::kNumStockStages, "");

    // Each Init_foo() is defined in src/opts/SkOpts_foo.cpp.
    void Init_ssse3();
    void Init_sse41();
    void Init_sse42();
    void Init_avx();
    void Init_hsw();
    void Init_crc32() {}
    void Init_neon();

    static void init() {
#if !defined(SK_BUILD_NO_OPTS)
    #if defined(SK_CPU_X86)
        if (SkCpu::Supports(SkCpu::SSSE3)) { Init_ssse3(); }
        if (SkCpu::Supports(SkCpu::SSE41)) { Init_sse41(); }
        if (SkCpu::Supports(SkCpu::SSE42)) { Init_sse42(); }
        if (SkCpu::Supports(SkCpu::AVX  )) { Init_avx();   }
        if (SkCpu::Supports(SkCpu::HSW  )) { Init_hsw();   }

    #elif defined(SK_CPU_ARM64)
        if (SkCpu::Supports(SkCpu::CRC32)) { Init_crc32(); }

    #elif defined(SK_CPU_ARM32) && !defined(SK_ARM_HAS_NEON) && defined(SK_ARM_HAS_OPTIONAL_NEON)
        if (SkCpu::Supports(SkCpu::NEON)) { Init_neon(); }

    #endif
#endif
    }

    void Init() {
        static SkOnce once;
        once(init);
    }
}  // namespace SkOpts
