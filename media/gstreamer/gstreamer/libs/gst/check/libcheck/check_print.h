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

#ifndef CHECK_PRINT_H
#define CHECK_PRINT_H

void tr_fprint (FILE *file, TestResult *tr, enum print_output print_mode);
void tr_xmlprint (FILE *file, TestResult *tr, enum print_output print_mode);
void srunner_fprint (FILE *file, SRunner *sr, enum print_output print_mode);
enum print_output get_env_printmode (void);


#endif /* CHECK_PRINT_H */
