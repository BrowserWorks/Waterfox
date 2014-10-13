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

#ifndef CHECK_IMPL_H
#define CHECK_IMPL_H


/* This header should be included by any module that needs
   to know the implementation details of the check structures
   Include stdio.h & list.h before this header
*/

typedef struct TF {
  TFun fn;
  int loop_start;
  int loop_end;
  const char *name;
  int signal;
  unsigned char allowed_exit_value;
} TF;

struct Suite {
  const char *name;
  List *tclst; /* List of test cases */
};

typedef struct Fixture 
{
  int ischecked;
  SFun fun;
} Fixture;

struct TCase {
  const char *name;
  int timeout;
  List *tflst; /* list of test functions */
  List *unch_sflst;
  List *unch_tflst;
  List *ch_sflst;
  List *ch_tflst;
};

typedef struct TestStats {
  int n_checked;
  int n_failed;
  int n_errors;
} TestStats;

struct TestResult {
  enum test_result rtype;     /* Type of result */
  enum ck_result_ctx ctx;     /* When the result occurred */
  char *file;    /* File where the test occured */
  int line;      /* Line number where the test occurred */
  int iter;      /* The iteration value for looping tests */
  const char *tcname;  /* Test case that generated the result */
  const char *tname;  /* Test that generated the result */
  char *msg;     /* Failure message */
};

TestResult *tr_create(void);
void tr_reset(TestResult *tr);

enum cl_event {
  CLINITLOG_SR,
  CLENDLOG_SR,
  CLSTART_SR,
  CLSTART_S,
  CLEND_SR,
  CLEND_S,
  CLSTART_T, /* A test case is about to run */
  CLEND_T
};

typedef void (*LFun) (SRunner *, FILE*, enum print_output,
		      void *, enum cl_event);

typedef struct Log {
  FILE *lfile;
  LFun lfun;
  int close;
  enum print_output mode;
} Log;

struct SRunner {
  List *slst; /* List of Suite objects */
  TestStats *stats; /* Run statistics */
  List *resultlst; /* List of unit test results */
  const char *log_fname; /* name of log file */
  const char *xml_fname; /* name of xml output file */
  List *loglst; /* list of Log objects */
  enum fork_status fstat; /* controls if suites are forked or not
			     NOTE: Don't use this value directly,
			     instead use srunner_fork_status */
};


void set_fork_status(enum fork_status fstat);
enum fork_status cur_fork_status (void);

#endif /* CHECK_IMPL_H */
