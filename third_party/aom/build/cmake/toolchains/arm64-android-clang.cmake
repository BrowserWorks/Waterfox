#
# Copyright (c) 2019, Alliance for Open Media. All rights reserved
#
# This source code is subject to the terms of the BSD 2 Clause License and the
# Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License was
# not distributed with this source code in the LICENSE file, you can obtain it
# at www.aomedia.org/license/software. If the Alliance for Open Media Patent
# License 1.0 was not distributed with this source code in the PATENTS file, you
# can obtain it at www.aomedia.org/license/patent.
#
if(AOM_BUILD_CMAKE_TOOLCHAINS_ARM64_ANDROID_CLANG_CMAKE_)
  return()
endif() # AOM_BUILD_CMAKE_TOOLCHAINS_ARM64_ANDROID_CLANG_CMAKE_
set(AOM_BUILD_CMAKE_TOOLCHAINS_ARM64_ANDROID_CLANG_CMAKE_ 1)

if(NOT ANDROID_PLATFORM)
  set(ANDROID_PLATFORM android-21)
endif()

if(NOT ANDROID_ABI)
  set(ANDROID_ABI arm64-v8a)
endif()

set(AS_EXECUTABLE as)

# Toolchain files don't have access to cached variables:
# https://gitlab.kitware.com/cmake/cmake/issues/16170. Set an intermediate
# environment variable when loaded the first time.
if(AOM_ANDROID_NDK_PATH)
  set(ENV{_AOM_ANDROID_NDK_PATH} "${AOM_ANDROID_NDK_PATH}")
else()
  set(AOM_ANDROID_NDK_PATH "$ENV{_AOM_ANDROID_NDK_PATH}")
endif()

if("${AOM_ANDROID_NDK_PATH}" STREQUAL "")
  message(FATAL_ERROR "AOM_ANDROID_NDK_PATH not set.")
  return()
endif()

include("${AOM_ANDROID_NDK_PATH}/build/cmake/android.toolchain.cmake")

# No intrinsics flag required for arm64-android-clang.
set(AOM_NEON_INTRIN_FLAG "")

# No runtime cpu detect for arm64-android-clang.
set(CONFIG_RUNTIME_CPU_DETECT 0 CACHE STRING "")

set(CMAKE_SYSTEM_NAME "Android")
