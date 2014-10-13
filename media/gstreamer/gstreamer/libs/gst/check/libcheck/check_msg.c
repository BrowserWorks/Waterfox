/*
 * Check: a unit test framework for C
 * Copyright (C) 2001 2002, Arien Malec
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

#include <sys/types.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>

#include "check_error.h"
#include "check.h"
#include "check_list.h"
#include "check_impl.h"
#include "check_msg.h"
#include "check_pack.h"


/* 'Pipe' is implemented as a temporary file to overcome message
 * volume limitations outlined in bug #482012. This scheme works well
 * with the existing usage wherein the parent does not begin reading
 * until the child has done writing and exited.
 *
 * Pipe life cycle:
 * - The parent creates a tmpfile().
 * - The fork() call has the effect of duplicating the file descriptor
 *   and copying (on write) the FILE* data structures.
 * - The child writes to the file, and its dup'ed file descriptor and
 *   data structures are cleaned up on child process exit.
 * - Before reading, the parent rewind()'s the file to reset both
 *   FILE* and underlying file descriptor location data.
 * - When finished, the parent fclose()'s the FILE*, deleting the
 *   temporary file, per tmpfile()'s semantics.
 *
 * This scheme may break down if the usage changes to asynchronous
 * reading and writing.
 */

static FILE *send_file1;
static FILE *send_file2;

static FILE *get_pipe (void);
static void setup_pipe (void);
static void teardown_pipe (void);
static TestResult *construct_test_result (RcvMsg * rmsg, int waserror);
static void tr_set_loc_by_ctx (TestResult * tr, enum ck_result_ctx ctx,
    RcvMsg * rmsg);
static FILE *
get_pipe (void)
{
  if (send_file2 != 0) {
    return send_file2;
  }

  if (send_file1 != 0) {
    return send_file1;
  }

  eprintf ("No messaging setup", __FILE__, __LINE__);

  return NULL;
}

void
send_failure_info (const char *msg)
{
  FailMsg fmsg;

  fmsg.msg = (char *) msg;
  ppack (fileno (get_pipe ()), CK_MSG_FAIL, (CheckMsg *) & fmsg);
}

void
send_loc_info (const char *file, int line)
{
  LocMsg lmsg;

  lmsg.file = (char *) file;
  lmsg.line = line;
  ppack (fileno (get_pipe ()), CK_MSG_LOC, (CheckMsg *) & lmsg);
}

void
send_ctx_info (enum ck_result_ctx ctx)
{
  CtxMsg cmsg;

  cmsg.ctx = ctx;
  ppack (fileno (get_pipe ()), CK_MSG_CTX, (CheckMsg *) & cmsg);
}

TestResult *
receive_test_result (int waserror)
{
  FILE *fp;
  RcvMsg *rmsg;
  TestResult *result;

  fp = get_pipe ();
  if (fp == NULL)
    eprintf ("Error in call to get_pipe", __FILE__, __LINE__ - 2);
  rewind (fp);
  rmsg = punpack (fileno (fp));
  teardown_pipe ();
  setup_pipe ();

  result = construct_test_result (rmsg, waserror);
  rcvmsg_free (rmsg);
  return result;
}

static void
tr_set_loc_by_ctx (TestResult * tr, enum ck_result_ctx ctx, RcvMsg * rmsg)
{
  if (ctx == CK_CTX_TEST) {
    tr->file = rmsg->test_file;
    tr->line = rmsg->test_line;
    rmsg->test_file = NULL;
    rmsg->test_line = -1;
  } else {
    tr->file = rmsg->fixture_file;
    tr->line = rmsg->fixture_line;
    rmsg->fixture_file = NULL;
    rmsg->fixture_line = -1;
  }
}

static TestResult *
construct_test_result (RcvMsg * rmsg, int waserror)
{
  TestResult *tr;

  if (rmsg == NULL)
    return NULL;

  tr = tr_create ();

  if (rmsg->msg != NULL || waserror) {
    tr->ctx = (cur_fork_status () == CK_FORK) ? rmsg->lastctx : rmsg->failctx;
    tr->msg = rmsg->msg;
    rmsg->msg = NULL;
    tr_set_loc_by_ctx (tr, tr->ctx, rmsg);
  } else if (rmsg->lastctx == CK_CTX_SETUP) {
    tr->ctx = CK_CTX_SETUP;
    tr->msg = NULL;
    tr_set_loc_by_ctx (tr, CK_CTX_SETUP, rmsg);
  } else {
    tr->ctx = CK_CTX_TEST;
    tr->msg = NULL;
    tr_set_loc_by_ctx (tr, CK_CTX_TEST, rmsg);
  }

  return tr;
}

void
setup_messaging (void)
{
  setup_pipe ();
}

void
teardown_messaging (void)
{
  teardown_pipe ();
}

static void
setup_pipe (void)
{
  if (send_file1 != 0) {
    if (send_file2 != 0)
      eprintf ("Only one nesting of suite runs supported", __FILE__, __LINE__);
    send_file2 = tmpfile ();
  } else {
    send_file1 = tmpfile ();
  }
}

static void
teardown_pipe (void)
{
  if (send_file2 != 0) {
    fclose (send_file2);
    send_file2 = 0;
  } else if (send_file1 != 0) {
    fclose (send_file1);
    send_file1 = 0;
  } else {
    eprintf ("No messaging setup", __FILE__, __LINE__);
  }
}
