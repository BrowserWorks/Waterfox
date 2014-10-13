/*
 * Check: a unit test framework for C
 * Copyright (C) 2001,2002 Arien Malec
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

#ifndef CHECK_LOG_H
#define CHECK_LOG_H

void log_srunner_start (SRunner *sr);
void log_srunner_end (SRunner *sr);
void log_suite_start (SRunner *sr, Suite *s);
void log_suite_end (SRunner *sr, Suite *s);
void log_test_end (SRunner *sr, TestResult *tr);
void log_test_start (SRunner *sr, TCase *tc, TF *tfun);

void stdout_lfun (SRunner *sr, FILE *file, enum print_output,
		  void *obj, enum cl_event evt);

void lfile_lfun (SRunner *sr, FILE *file, enum print_output,
		  void *obj, enum cl_event evt);

void xml_lfun (SRunner *sr, FILE *file, enum print_output,
		  void *obj, enum cl_event evt);

void subunit_lfun (SRunner *sr, FILE *file, enum print_output,
		  void *obj, enum cl_event evt);

void srunner_register_lfun (SRunner *sr, FILE *lfile, int close,
			    LFun lfun, enum print_output);

FILE *srunner_open_lfile (SRunner *sr);
FILE *srunner_open_xmlfile (SRunner *sr);
void srunner_init_logging (SRunner *sr, enum print_output print_mode);
void srunner_end_logging (SRunner *sr);

#endif /* CHECK_LOG_H */
