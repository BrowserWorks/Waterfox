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
#include <orc/orcutils.h>

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/**
 * SECTION:orcutils
 * @title: Utility functions
 * @short_description: Orc utility functions
 */

char *
_strndup (const char *s, int n)
{
  char *r;
  r = malloc (n+1);
  memcpy(r,s,n);
  r[n]=0;

  return r;
}

char **
strsplit (const char *s, char delimiter)
{
  char **list = NULL;
  const char *tok;
  int n = 0;

  while (*s == ' ') s++;

  list = malloc (1 * sizeof(char *));
  while (*s) {
    tok = s;
    while (*s && *s != delimiter) s++;

    list[n] = _strndup (tok, s - tok);
    while (*s && *s == delimiter) s++;
    list = realloc (list, (n + 2) * sizeof(char *));
    n++;
  }

  list[n] = NULL;
  return list;
}

char *
get_tag_value (char *s, const char *tag)
{
  char *flags;
  char *end;
  char *colon;

  flags = strstr(s,tag);
  if (flags == NULL) return NULL;

  end = strchr(flags, '\n');
  if (end == NULL) return NULL;
  colon = strchr (flags, ':');
  if (colon == NULL) return NULL;
  colon++;
  if(colon >= end) return NULL;

  return _strndup (colon, end-colon);
}

orc_int64
_strtoll (const char *nptr, char **endptr, int base)
{
  int neg = 0;
  orc_int64 val = 0;
  
  /* Skip all spaces */
  while (isspace (*nptr))
    nptr++;

  if (!*nptr)
    return val;

  /* Get sign */
  if (*nptr == '-') {
    neg = 1;
    nptr++;
  } else if (*nptr == '+') {
    nptr++;
  }

  if (!*nptr)
    return val;

  /* Try to detect the base if none was given */
  if (base == 0) {
    if (*nptr == '0' && (*(nptr + 1) == 'x' || *(nptr + 1) == 'X')) {
      base = 16;
      nptr += 2;
    } else if (*nptr == '0') {
      base = 8;
      nptr++;
    } else {
      base = 10;
    }
  } else if (base == 16) {
    if (*nptr == '0' && (*(nptr + 1) == 'x' || *(nptr + 1) == 'X'))
      nptr += 2;
  } else if (base == 8) {
    if (*nptr == '0')
      nptr++;
  }

  while (*nptr) {
    int c = *nptr;

    if (c >= '0' && c <= '9')
      c = c - '0';
    else if (c >= 'a' && c <= 'z')
      c = 10 + c - 'a';
    else if (c >= 'A' && c <= 'Z')
      c = 10 + c - 'A';
    else
      break;

    if (c >= base)
      break;

    if ((orc_uint64) val > ORC_UINT64_C(0xffffffffffffffff) / base ||
        (orc_uint64) (val * base) > ORC_UINT64_C(0xffffffffffffffff) - c) {
      val = ORC_UINT64_C(0xffffffffffffffff);
      break;
    }

    val = val * base + c;
    
    nptr++;
  }

  if (endptr)
    *endptr = (char *) nptr;

  return (neg) ? - val : val;
}

