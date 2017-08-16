##
## Copyright (c) 2017, Alliance for Open Media. All rights reserved
##
## This source code is subject to the terms of the BSD 2 Clause License and
## the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
## was not distributed with this source code in the LICENSE file, you can
## obtain it at www.aomedia.org/license/software. If the Alliance for Open
## Media Patent License 1.0 was not distributed with this source code in the
## PATENTS file, you can obtain it at www.aomedia.org/license/patent.
##
cmake_minimum_required(VERSION 3.5)

string(TIMESTAMP year "%Y")
set(asm_file_header_block
"\;
\; Copyright (c) ${year}, Alliance for Open Media. All rights reserved
\;
\; This source code is subject to the terms of the BSD 2 Clause License and
\; the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
\; was not distributed with this source code in the LICENSE file, you can
\; obtain it at www.aomedia.org/license/software. If the Alliance for Open
\; Media Patent License 1.0 was not distributed with this source code in the
\; PATENTS file, you can obtain it at www.aomedia.org/license/patent.
\;
")
set(h_file_header_block
"/*
 * Copyright (c) ${year}, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */
\#ifndef AOM_CONFIG_H_
\#define AOM_CONFIG_H_
")
set(cmake_file_header_block
"##
## Copyright (c) ${year}, Alliance for Open Media. All rights reserved
##
## This source code is subject to the terms of the BSD 2 Clause License and
## the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
## was not distributed with this source code in the LICENSE file, you can
## obtain it at www.aomedia.org/license/software. If the Alliance for Open
## Media Patent License 1.0 was not distributed with this source code in the
## PATENTS file, you can obtain it at www.aomedia.org/license/patent.
##
")

# Terminates cmake execution when $var_name is an empty string, or the variable
# name it contains does not expand to an existing directory.
function (check_directory_var var_name)
  if ("${var_name}" STREQUAL "")
    message(FATAL_ERROR "The CMake variable ${var_name} must be defined.")
  endif ()

  if (NOT EXISTS "${${var_name}}")
    message(FATAL_ERROR "${${var_name}} (${var_name}) missing.")
  endif ()
endfunction ()

check_directory_var(AOM_CONFIG_DIR)
check_directory_var(AOM_ROOT)

set(AOM_DEFAULTS "${AOM_ROOT}/build/cmake/aom_config_defaults.cmake")
if (NOT EXISTS "${AOM_DEFAULTS}")
  message(FATAL_ERROR
          "Configuration default values file (${AOM_DEFAULTS}) missing.")
endif ()

include("${AOM_ROOT}/build/cmake/aom_config_defaults.cmake")
get_cmake_property(cmake_cache_vars CACHE_VARIABLES)

set(aom_config_h_template "${AOM_CONFIG_DIR}/aom_config.h.cmake")
file(WRITE "${aom_config_h_template}" ${h_file_header_block})
foreach(cache_var ${cmake_cache_vars})
  if (NOT "${cache_var}" MATCHES "AOM_CONFIG_DIR\|AOM_ROOT\|^CMAKE_")
    file(APPEND
         "${aom_config_h_template}" "\#define ${cache_var} \${${cache_var}}\n")
  endif ()
endforeach()
file(APPEND "${aom_config_h_template}" "\#endif  /* AOM_CONFIG_H_ */")

set(aom_asm_config_template "${AOM_CONFIG_DIR}/aom_config.asm.cmake")
file(WRITE "${aom_asm_config_template}" ${asm_file_header_block})
foreach(cache_var ${cmake_cache_vars})
  if (NOT "${cache_var}" MATCHES
      "AOM_CONFIG_DIR\|AOM_ROOT\|^CMAKE_\|INLINE\|RESTRICT")
    file(APPEND "${aom_asm_config_template}"
         "${cache_var} equ \${${cache_var}}\n")
  endif ()
endforeach ()

set(aom_rtcd_config_template "${AOM_CONFIG_DIR}/rtcd_config.cmake")
file(WRITE "${aom_rtcd_config_template}" ${cmake_file_header_block})
foreach(cache_var ${cmake_cache_vars})
  if (NOT "${cache_var}" MATCHES
      "AOM_CONFIG_DIR\|AOM_ROOT\|^CMAKE_\|INLINE\|RESTRICT")
    file(APPEND "${aom_rtcd_config_template}"
         "${cache_var}=\${RTCD_${cache_var}}\n")
  endif ()
endforeach ()

