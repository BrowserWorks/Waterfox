/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef SKIA_CONFIG_SKUSERCONFIG_H_
#define SKIA_CONFIG_SKUSERCONFIG_H_

/*  SkTypes.h, the root of the public header files, does the following trick:

    #include <SkPreConfig.h>
    #include <SkUserConfig.h>
    #include <SkPostConfig.h>

    SkPreConfig.h runs first, and it is responsible for initializing certain
    skia defines.

    SkPostConfig.h runs last, and its job is to just check that the final
    defines are consistent (i.e. that we don't have mutually conflicting
    defines).

    SkUserConfig.h (this file) runs in the middle. It gets to change or augment
    the list of flags initially set in preconfig, and then postconfig checks
    that everything still makes sense.

    Below are optional defines that add, subtract, or change default behavior
    in Skia. Your port can locally edit this file to enable/disable flags as
    you choose, or these can be delared on your command line (i.e. -Dfoo).

    By default, this include file will always default to having all of the flags
    commented out, so including it will have no effect.
*/

///////////////////////////////////////////////////////////////////////////////

/*  Skia has lots of debug-only code. Often this is just null checks or other
    parameter checking, but sometimes it can be quite intrusive (e.g. check that
    each 32bit pixel is in premultiplied form). This code can be very useful
    during development, but will slow things down in a shipping product.

    By default, these mutually exclusive flags are defined in SkPreConfig.h,
    based on the presence or absence of NDEBUG, but that decision can be changed
    here.
 */
// #define SK_DEBUG
// #define SK_RELEASE

// #ifdef DCHECK_ALWAYS_ON
//     #undef SK_RELEASE
//     #define SK_DEBUG
// #endif

/*  If, in debugging mode, Skia needs to stop (presumably to invoke a debugger)
    it will call SK_CRASH(). If this is not defined it, it is defined in
    SkPostConfig.h to write to an illegal address
 */
// #define SK_CRASH() *(int *)(uintptr_t)0 = 0

/*  preconfig will have attempted to determine the endianness of the system,
    but you can change these mutually exclusive flags here.
 */
// #define SK_CPU_BENDIAN
// #define SK_CPU_LENDIAN

/*  If zlib is available and you want to support the flate compression
    algorithm (used in PDF generation), define SK_ZLIB_INCLUDE to be the
    include path.
 */
// #define SK_ZLIB_INCLUDE <zlib.h>

/*  Define this to allow PDF scalars above 32k.  The PDF/A spec doesn't allow
    them, but modern PDF interpreters should handle them just fine.
 */
// #define SK_ALLOW_LARGE_PDF_SCALARS

/*  Define this to provide font subsetter for font subsetting when generating
    PDF documents.
 */
// #define SK_SFNTLY_SUBSETTER \
//    "third_party/sfntly/src/cpp/src/sample/chromium/font_subsetter.h"

/*  To write debug messages to a console, skia will call SkDebugf(...) following
    printf conventions (e.g. const char* format, ...). If you want to redirect
    this to something other than printf, define yours here
 */
// #define SkDebugf(...)  MyFunction(__VA_ARGS__)

/*  If SK_DEBUG is defined, then you can optionally define SK_SUPPORT_UNITTEST
    which will run additional self-tests at startup. These can take a long time,
    so this flag is optional.
 */
#ifdef SK_DEBUG
#define SK_SUPPORT_UNITTEST
#endif

/* If cross process SkPictureImageFilters are not explicitly enabled then
   they are always disabled.
 */
#ifndef SK_ALLOW_CROSSPROCESS_PICTUREIMAGEFILTERS
#ifndef SK_DISALLOW_CROSSPROCESS_PICTUREIMAGEFILTERS
#define SK_DISALLOW_CROSSPROCESS_PICTUREIMAGEFILTERS
#endif
#endif

/* If your system embeds skia and has complex event logging, define this
   symbol to name a file that maps the following macros to your system's
   equivalents:
       SK_TRACE_EVENT0(event)
       SK_TRACE_EVENT1(event, name1, value1)
       SK_TRACE_EVENT2(event, name1, value1, name2, value2)
   src/utils/SkDebugTrace.h has a trivial implementation that writes to
   the debug output stream. If SK_USER_TRACE_INCLUDE_FILE is not defined,
   SkTrace.h will define the above three macros to do nothing.
*/
#undef SK_USER_TRACE_INCLUDE_FILE

// ===== Begin Chrome-specific definitions =====

#define SK_MSCALAR_IS_FLOAT
#undef SK_MSCALAR_IS_DOUBLE

#define GR_MAX_OFFSCREEN_AA_DIM 512

// Log the file and line number for assertions.
#define SkDebugf(...) SkDebugf_FileLine(__FILE__, __LINE__, false, __VA_ARGS__)
SK_API void SkDebugf_FileLine(const char* file,
                              int line,
                              bool fatal,
                              const char* format,
                              ...);

// Marking the debug print as "fatal" will cause a debug break, so we don't need
// a separate crash call here.
#define SK_DEBUGBREAK(cond)                                           \
  do {                                                                \
    if (!(cond)) {                                                    \
      SkDebugf_FileLine(__FILE__, __LINE__, true,                     \
                        "%s:%d: failed assertion \"%s\"\n", __FILE__, \
                        __LINE__, #cond);                             \
    }                                                                 \
  } while (false)

#if !defined(ANDROID)  // On Android, we use the skia default settings.
#define SK_A32_SHIFT 24
#define SK_R32_SHIFT 16
#define SK_G32_SHIFT 8
#define SK_B32_SHIFT 0
#endif

#if defined(SK_BUILD_FOR_WIN32)

#define SK_BUILD_FOR_WIN

// Skia uses this deprecated bzero function to fill zeros into a string.
#define bzero(str, len) memset(str, 0, len)

#elif defined(SK_BUILD_FOR_MAC)

#define SK_CPU_LENDIAN
#undef SK_CPU_BENDIAN

#elif defined(SK_BUILD_FOR_UNIX) || defined(SK_BUILD_FOR_ANDROID)

// Prefer FreeType's emboldening algorithm to Skia's
// TODO: skia used to just use hairline, but has improved since then, so
// we should revisit this choice...
#define SK_USE_FREETYPE_EMBOLDEN

#if defined(SK_BUILD_FOR_UNIX) && defined(SK_CPU_BENDIAN)
// Above we set the order for ARGB channels in registers. I suspect that, on
// big endian machines, you can keep this the same and everything will work.
// The in-memory order will be different, of course, but as long as everything
// is reading memory as words rather than bytes, it will all work. However, if
// you find that colours are messed up I thought that I would leave a helpful
// locator for you. Also see the comments in
// base/gfx/bitmap_platform_device_linux.h
#error Read the comment at this location
#endif

#endif

// The default crash macro writes to badbeef which can cause some strange
// problems. Instead, pipe this through to the logging function as a fatal
// assertion.
#define SK_CRASH() SkDebugf_FileLine(__FILE__, __LINE__, true, "SK_CRASH")

// These flags are no longer defined in Skia, but we have them (temporarily)
// until we update our call-sites (typically these are for API changes).
//
// Remove these as we update our sites.
//
#ifndef SK_SUPPORT_LEGACY_GETTOPDEVICE
#define SK_SUPPORT_LEGACY_GETTOPDEVICE
#endif

#ifndef SK_SUPPORT_EXOTIC_CLIPOPS
#define SK_SUPPORT_EXOTIC_CLIPOPS
#endif

#ifndef SK_SUPPORT_LEGACY_GETDEVICE
#define SK_SUPPORT_LEGACY_GETDEVICE
#endif

// Workaround for poor anisotropic mipmap quality,
// pending Skia ripmap support.
// (https://bugs.chromium.org/p/skia/issues/detail?id=4863)
#ifndef SK_SUPPORT_LEGACY_ANISOTROPIC_MIPMAP_SCALE
#define SK_SUPPORT_LEGACY_ANISOTROPIC_MIPMAP_SCALE
#endif

#ifndef SK_SUPPORT_LEGACY_REFENCODEDDATA_NOCTX
#define SK_SUPPORT_LEGACY_REFENCODEDDATA_NOCTX
#endif

#ifndef SK_IGNORE_ETC1_SUPPORT
#define SK_IGNORE_ETC1_SUPPORT
#endif

#ifndef SK_IGNORE_GPU_DITHER
#define SK_IGNORE_GPU_DITHER
#endif

#ifndef SK_SUPPORT_LEGACY_EVAL_CUBIC
#define SK_SUPPORT_LEGACY_EVAL_CUBIC
#endif

///////////////////////// Imported from BUILD.gn and skia_common.gypi

/* In some places Skia can use static initializers for global initialization,
 *  or fall back to lazy runtime initialization. Chrome always wants the latter.
 */
#define SK_ALLOW_STATIC_GLOBAL_INITIALIZERS 0

/* This flag forces Skia not to use typographic metrics with GDI.
 */
#define SK_GDI_ALWAYS_USE_TEXTMETRICS_FOR_FONT_METRICS

#define SK_IGNORE_BLURRED_RRECT_OPT
#define SK_USE_DISCARDABLE_SCALEDIMAGECACHE
#define SK_WILL_NEVER_DRAW_PERSPECTIVE_TEXT

#define SK_ATTR_DEPRECATED SK_NOTHING_ARG1
#define SK_ENABLE_INST_COUNT 0
#define GR_GL_CUSTOM_SETUP_HEADER "GrGLConfig_chrome.h"

// Blink layout tests are baselined to Clang optimizing through the UB in
// SkDivBits.
#define SK_SUPPORT_LEGACY_DIVBITS_UB

// mtklein's fiddling with Src / SrcOver.  Will rebaseline these only once when
// done.
#define SK_SUPPORT_LEGACY_X86_BLITS

#define SK_DISABLE_TILE_IMAGE_FILTER_OPTIMIZATION

// ===== End Chrome-specific definitions =====

#endif  // SKIA_CONFIG_SKUSERCONFIG_H_
