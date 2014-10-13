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

#ifndef CHECK_STR_H
#define CHECK_STR_H

/* Return a string representation of the given TestResult.  Return
   value has been malloc'd, and must be freed by the caller */
char *tr_str (TestResult *tr);

/* Return a string representation of the given TestResult message
   without the test id or result type. This is suitable for separate
   formatting of the test and the message. Return value has been 
   malloc'd, and must be freed by the caller */
char *tr_short_str (TestResult *tr);

/* Return a string representation of the given SRunner's run
   statistics (% passed, num run, passed, errors, failures). Return
   value has been malloc'd, and must be freed by the caller
*/ 
char *sr_stat_str (SRunner *sr);

char *ck_strdup_printf (const char *fmt, ...);

#endif /* CHECK_STR_H */
