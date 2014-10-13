/*
 * Check: a unit test framework for C
 * Copyright (C) 2001, 2002 Arien Malec
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "config.h"

#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

#include "check_error.h"


/* FIXME: including a colon at the end is a bad way to indicate an error */
void
eprintf (const char *fmt, const char *file, int line, ...)
{
  va_list args;
  fflush (stderr);

  fprintf (stderr, "%s:%d: ", file, line);
  va_start (args, line);
  vfprintf (stderr, fmt, args);
  va_end (args);

  /*include system error information if format ends in colon */
  if (fmt[0] != '\0' && fmt[strlen (fmt) - 1] == ':')
    fprintf (stderr, " %s", strerror (errno));
  fprintf (stderr, "\n");

  exit (2);
}

void *
emalloc (size_t n)
{
  void *p;
  p = malloc (n);
  if (p == NULL)
    eprintf ("malloc of %u bytes failed:", __FILE__, __LINE__ - 2, n);
  return p;
}

void *
erealloc (void *ptr, size_t n)
{
  void *p;
  p = realloc (ptr, n);
  if (p == NULL)
    eprintf ("realloc of %u bytes failed:", __FILE__, __LINE__ - 2, n);
  return p;
}
