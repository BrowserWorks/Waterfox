/*
 * ORC - Library of Optimized Inner Loops
 * Copyright (c) 2003,2004 David A. Schleef <ds@schleef.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <orc/orcdebug.h>

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

#ifdef HAVE_ANDROID_LIBLOG
#include <android/log.h>
#endif

/**
 * SECTION:orcdebug
 * @title: OrcDebug
 * @short_description: Printing and formatting debug information
 */

static void orc_debug_print_valist (int level, const char *file,
    const char *func, int line, const char *format, va_list args);

static int _orc_debug_level = ORC_DEBUG_ERROR;

static OrcDebugPrintFunc _orc_debug_print_func = orc_debug_print_valist;

void
_orc_debug_init(void)
{
  const char *envvar;

  envvar = getenv ("ORC_DEBUG");
  if (envvar != NULL) {
    char *end = NULL;
    int level;
    level = strtol (envvar, &end, 0);
    if (end > envvar) {
      _orc_debug_level = level;
    }
  }

  ORC_INFO ("orc-" VERSION " debug init");
}

#ifdef HAVE_ANDROID_LIBLOG
static void
orc_debug_print_valist (int level, const char *file, const char *func,
        int line, const char *format, va_list args)
{
  int android_log_level;
  char *dbg;

  if (level > orc_debug_get_level())
    return;

  switch (level) {
    case ORC_DEBUG_ERROR:
      android_log_level = ANDROID_LOG_ERROR;
      break;
    case ORC_DEBUG_WARNING:
      android_log_level = ANDROID_LOG_WARN;
      break;
    case ORC_DEBUG_INFO:
      android_log_level = ANDROID_LOG_INFO;
      break;
    case ORC_DEBUG_LOG:
      android_log_level = ANDROID_LOG_DEBUG;
      break;
    default:
      android_log_level = ANDROID_LOG_VERBOSE;
      break;
  }

  if (vasprintf (&dbg, format, args) < 0) {
    __android_log_print (android_log_level, "Orc", "Failed to alloc debug string....");
    return;
  }

  __android_log_print (android_log_level, "Orc",
        "%s:%d:%s %s\n", file, line, func, dbg);

  free (dbg);
}
#else
static void
orc_debug_print_valist (int level, const char *file, const char *func,
        int line, const char *format, va_list args)
{
  static const char *level_names[] = { "NONE", "ERROR", "WARNING", "INFO",
    "DEBUG", "LOG" };
  const char *level_name = "unknown";

  if (level > _orc_debug_level) return;

  if(level>=ORC_DEBUG_NONE && level<=ORC_DEBUG_LOG){
    level_name = level_names[level];
  }
  
  fprintf (stderr, "ORC: %s: %s(%d): %s(): ", level_name, file, line, func);
  vfprintf (stderr, format, args);
  fprintf (stderr, "\n");
}
#endif

void
orc_debug_print (int level, const char *file, const char *func,
        int line, const char *format, ...)
{
  va_list var_args;

  va_start (var_args, format);
  _orc_debug_print_func (level, file, func, line, format, var_args);
  va_end (var_args);
}

/**
 * orc_debug_get_level:
 *
 * Gets the current debug level.
 *
 * Returns: the current debug level
 */
int
orc_debug_get_level (void)
{
  return _orc_debug_level;
}

/**
 * orc_debug_set_level:
 * @level: the new debug level
 *
 * Sets the current debug level.
 */
void
orc_debug_set_level (int level)
{
  _orc_debug_level = level;
}

/**
 * orc_debug_set_print_function:
 * @func: the function to call
 *
 * Sets the function to call when outputting debugging information.
 * A value of NULL for @func will restore the default handler,
 * which prints debugging information to stderr.
 */
void
orc_debug_set_print_function (OrcDebugPrintFunc func)
{
  if (func) {
    _orc_debug_print_func = func;
  } else {
    _orc_debug_print_func = orc_debug_print_valist;
  }
}

