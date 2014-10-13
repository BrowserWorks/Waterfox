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

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include "check.h"
#include "check_error.h"
#include "check_list.h"
#include "check_impl.h"
#include "check_msg.h"

#ifdef HAVE_UNISTD_H
#include <unistd.h>             /* for _POSIX_VERSION */
#endif

#ifndef DEFAULT_TIMEOUT
#define DEFAULT_TIMEOUT 4
#endif

int check_major_version = CHECK_MAJOR_VERSION;
int check_minor_version = CHECK_MINOR_VERSION;
int check_micro_version = CHECK_MICRO_VERSION;

static int non_pass (int val);
static Fixture *fixture_create (SFun fun, int ischecked);
static void tcase_add_fixture (TCase * tc, SFun setup, SFun teardown,
    int ischecked);
static void tr_init (TestResult * tr);
static void suite_free (Suite * s);
static void tcase_free (TCase * tc);

Suite *
suite_create (const char *name)
{
  Suite *s;
  s = emalloc (sizeof (Suite)); /* freed in suite_free */
  if (name == NULL)
    s->name = "";
  else
    s->name = name;
  s->tclst = check_list_create ();
  return s;
}

static void
suite_free (Suite * s)
{
  List *l;
  if (s == NULL)
    return;
  l = s->tclst;
  for (list_front (l); !list_at_end (l); list_advance (l)) {
    tcase_free (list_val (l));
  }
  list_free (s->tclst);
  free (s);
}

TCase *
tcase_create (const char *name)
{
  char *env;
  int timeout = DEFAULT_TIMEOUT;
  TCase *tc = emalloc (sizeof (TCase)); /*freed in tcase_free */
  if (name == NULL)
    tc->name = "";
  else
    tc->name = name;

  env = getenv ("CK_DEFAULT_TIMEOUT");
  if (env != NULL) {
    int tmp = atoi (env);
    if (tmp >= 0) {
      timeout = tmp;
    }
  }

  env = getenv ("CK_TIMEOUT_MULTIPLIER");
  if (env != NULL) {
    int tmp = atoi (env);
    if (tmp >= 0) {
      timeout = timeout * tmp;
    }
  }

  tc->timeout = timeout;
  tc->tflst = check_list_create ();
  tc->unch_sflst = check_list_create ();
  tc->ch_sflst = check_list_create ();
  tc->unch_tflst = check_list_create ();
  tc->ch_tflst = check_list_create ();

  return tc;
}


static void
tcase_free (TCase * tc)
{
  list_apply (tc->tflst, free);
  list_apply (tc->unch_sflst, free);
  list_apply (tc->ch_sflst, free);
  list_apply (tc->unch_tflst, free);
  list_apply (tc->ch_tflst, free);
  list_free (tc->tflst);
  list_free (tc->unch_sflst);
  list_free (tc->ch_sflst);
  list_free (tc->unch_tflst);
  list_free (tc->ch_tflst);

  free (tc);
}

void
suite_add_tcase (Suite * s, TCase * tc)
{
  if (s == NULL || tc == NULL)
    return;
  list_add_end (s->tclst, tc);
}

void
_tcase_add_test (TCase * tc, TFun fn, const char *name, int _signal,
    int allowed_exit_value, int start, int end)
{
  TF *tf;
  if (tc == NULL || fn == NULL || name == NULL)
    return;
  tf = emalloc (sizeof (TF));   /* freed in tcase_free */
  tf->fn = fn;
  tf->loop_start = start;
  tf->loop_end = end;
  tf->signal = _signal;         /* 0 means no signal expected */
  tf->allowed_exit_value = allowed_exit_value;  /* 0 is default successful exit */
  tf->name = name;
  list_add_end (tc->tflst, tf);
}

static Fixture *
fixture_create (SFun fun, int ischecked)
{
  Fixture *f;
  f = emalloc (sizeof (Fixture));
  f->fun = fun;
  f->ischecked = ischecked;

  return f;
}

void
tcase_add_unchecked_fixture (TCase * tc, SFun setup, SFun teardown)
{
  tcase_add_fixture (tc, setup, teardown, 0);
}

void
tcase_add_checked_fixture (TCase * tc, SFun setup, SFun teardown)
{
  tcase_add_fixture (tc, setup, teardown, 1);
}

static void
tcase_add_fixture (TCase * tc, SFun setup, SFun teardown, int ischecked)
{
  if (setup) {
    if (ischecked)
      list_add_end (tc->ch_sflst, fixture_create (setup, ischecked));
    else
      list_add_end (tc->unch_sflst, fixture_create (setup, ischecked));
  }

  /* Add teardowns at front so they are run in reverse order. */
  if (teardown) {
    if (ischecked)
      list_add_front (tc->ch_tflst, fixture_create (teardown, ischecked));
    else
      list_add_front (tc->unch_tflst, fixture_create (teardown, ischecked));
  }
}

void
tcase_set_timeout (TCase * tc, int timeout)
{
  if (timeout >= 0) {
    char *env = getenv ("CK_TIMEOUT_MULTIPLIER");
    if (env != NULL) {
      int tmp = atoi (env);
      if (tmp >= 0) {
        timeout = timeout * tmp;
      }
    }
    tc->timeout = timeout;
  }
}

void
tcase_fn_start (const char *fname CK_ATTRIBUTE_UNUSED, const char *file,
    int line)
{
  send_ctx_info (CK_CTX_TEST);
  send_loc_info (file, line);
}

void
_mark_point (const char *file, int line)
{
  send_loc_info (file, line);
}

void
_fail_unless (int result, const char *file, int line, const char *expr, ...)
{
  const char *msg;

  send_loc_info (file, line);
  if (!result) {
    va_list ap;
    char buf[BUFSIZ];

    va_start (ap, expr);
    msg = (const char *) va_arg (ap, char *);
    if (msg == NULL)
      msg = expr;
    vsnprintf (buf, BUFSIZ, msg, ap);
    va_end (ap);
    send_failure_info (buf);
    if (cur_fork_status () == CK_FORK) {
#ifdef _POSIX_VERSION
      _exit (1);
#endif /* _POSIX_VERSION */
    }
  }
}

SRunner *
srunner_create (Suite * s)
{
  SRunner *sr = emalloc (sizeof (SRunner));     /* freed in srunner_free */
  sr->slst = check_list_create ();
  if (s != NULL)
    list_add_end (sr->slst, s);
  sr->stats = emalloc (sizeof (TestStats));     /* freed in srunner_free */
  sr->stats->n_checked = sr->stats->n_failed = sr->stats->n_errors = 0;
  sr->resultlst = check_list_create ();
  sr->log_fname = NULL;
  sr->xml_fname = NULL;
  sr->loglst = NULL;
  sr->fstat = CK_FORK_GETENV;
  return sr;
}

void
srunner_add_suite (SRunner * sr, Suite * s)
{
  if (s == NULL)
    return;

  list_add_end (sr->slst, s);
}

void
srunner_free (SRunner * sr)
{
  List *l;
  TestResult *tr;
  if (sr == NULL)
    return;

  free (sr->stats);
  l = sr->slst;
  for (list_front (l); !list_at_end (l); list_advance (l)) {
    suite_free (list_val (l));
  }
  list_free (sr->slst);

  l = sr->resultlst;
  for (list_front (l); !list_at_end (l); list_advance (l)) {
    tr = list_val (l);
    free (tr->file);
    free (tr->msg);
    free (tr);
  }
  list_free (sr->resultlst);

  free (sr);
}

int
srunner_ntests_failed (SRunner * sr)
{
  return sr->stats->n_failed + sr->stats->n_errors;
}

int
srunner_ntests_run (SRunner * sr)
{
  return sr->stats->n_checked;
}

TestResult **
srunner_failures (SRunner * sr)
{
  int i = 0;
  TestResult **trarray;
  List *rlst;
  trarray = malloc (sizeof (trarray[0]) * srunner_ntests_failed (sr));

  rlst = sr->resultlst;
  for (list_front (rlst); !list_at_end (rlst); list_advance (rlst)) {
    TestResult *tr = list_val (rlst);
    if (non_pass (tr->rtype))
      trarray[i++] = tr;

  }
  return trarray;
}

TestResult **
srunner_results (SRunner * sr)
{
  int i = 0;
  TestResult **trarray;
  List *rlst;

  trarray = malloc (sizeof (trarray[0]) * srunner_ntests_run (sr));

  rlst = sr->resultlst;
  for (list_front (rlst); !list_at_end (rlst); list_advance (rlst)) {
    trarray[i++] = list_val (rlst);
  }
  return trarray;
}

static int
non_pass (int val)
{
  return val != CK_PASS;
}

TestResult *
tr_create (void)
{
  TestResult *tr;

  tr = emalloc (sizeof (TestResult));
  tr_init (tr);
  return tr;
}

void
tr_reset (TestResult * tr)
{
  tr_init (tr);
}

static void
tr_init (TestResult * tr)
{
  tr->ctx = CK_CTX_INVALID;
  tr->line = -1;
  tr->rtype = CK_TEST_RESULT_INVALID;
  tr->msg = NULL;
  tr->file = NULL;
  tr->tcname = NULL;
  tr->tname = NULL;
}


const char *
tr_msg (TestResult * tr)
{
  return tr->msg;
}

int
tr_lno (TestResult * tr)
{
  return tr->line;
}

const char *
tr_lfile (TestResult * tr)
{
  return tr->file;
}

int
tr_rtype (TestResult * tr)
{
  return tr->rtype;
}

enum ck_result_ctx
tr_ctx (TestResult * tr)
{
  return tr->ctx;
}

const char *
tr_tcname (TestResult * tr)
{
  return tr->tcname;
}

static int _fstat = CK_FORK;

void
set_fork_status (enum fork_status fstat)
{
  if (fstat == CK_FORK || fstat == CK_NOFORK || fstat == CK_FORK_GETENV)
    _fstat = fstat;
  else
    eprintf ("Bad status in set_fork_status", __FILE__, __LINE__);
}

enum fork_status
cur_fork_status (void)
{
  return _fstat;
}
