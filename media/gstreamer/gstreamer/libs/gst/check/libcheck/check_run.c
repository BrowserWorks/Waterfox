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

#include <sys/types.h>
#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <signal.h>

#include "check.h"
#include "check_error.h"
#include "check_list.h"
#include "check_impl.h"
#include "check_msg.h"
#include "check_log.h"

enum rinfo
{
  CK_R_SIG,
  CK_R_PASS,
  CK_R_EXIT,
  CK_R_FAIL_TEST,
  CK_R_FAIL_FIXTURE
};

enum tf_type
{
  CK_FORK_TEST,
  CK_NOFORK_TEST,
  CK_NOFORK_FIXTURE
};

/* all functions are defined in the same order they are declared.
   functions that depend on forking are gathered all together.
   non-static functions are at the end of the file. */
static void srunner_run_init (SRunner * sr, enum print_output print_mode);
static void srunner_run_end (SRunner * sr, enum print_output print_mode);
static void srunner_iterate_suites (SRunner * sr, enum print_output print_mode);
static void srunner_iterate_tcase_tfuns (SRunner * sr, TCase * tc);
static void srunner_add_failure (SRunner * sr, TestResult * tf);
static int srunner_run_unchecked_setup (SRunner * sr, TCase * tc);
static TestResult *tcase_run_checked_setup (SRunner * sr, TCase * tc);
static void srunner_run_teardown (List * l);
static void srunner_run_unchecked_teardown (TCase * tc);
static void tcase_run_checked_teardown (TCase * tc);
static void srunner_run_tcase (SRunner * sr, TCase * tc);
static TestResult *tcase_run_tfun_nofork (SRunner * sr, TCase * tc, TF * tf,
    int i);
static TestResult *receive_result_info_nofork (const char *tcname,
    const char *tname, int iter);
static void set_nofork_info (TestResult * tr);
static char *pass_msg (void);

#ifdef _POSIX_VERSION
static TestResult *tcase_run_tfun_fork (SRunner * sr, TCase * tc, TF * tf,
    int i);
static TestResult *receive_result_info_fork (const char *tcname,
    const char *tname, int iter, int status, int expected_signal,
    unsigned char allowed_exit_value);
static void set_fork_info (TestResult * tr, int status, int expected_signal,
    unsigned char allowed_exit_value);
static char *signal_msg (int sig);
static char *signal_error_msg (int signal_received, int signal_expected);
static char *exit_msg (int exitstatus);
static int waserror (int status, int expected_signal);

static int alarm_received;
static pid_t group_pid;

static void CK_ATTRIBUTE_UNUSED
sig_handler (int sig_nr)
{
  switch (sig_nr) {
    case SIGALRM:
      alarm_received = 1;
      killpg (group_pid, SIGKILL);
      break;
    default:
      eprintf ("Unhandled signal: %d", __FILE__, __LINE__, sig_nr);
      break;
  }
}
#endif /* _POSIX_VERSION */

#define MSG_LEN 100

static void
srunner_run_init (SRunner * sr, enum print_output print_mode)
{
  set_fork_status (srunner_fork_status (sr));
  setup_messaging ();
  srunner_init_logging (sr, print_mode);
  log_srunner_start (sr);
}

static void
srunner_run_end (SRunner * sr, enum print_output CK_ATTRIBUTE_UNUSED print_mode)
{
  log_srunner_end (sr);
  srunner_end_logging (sr);
  teardown_messaging ();
  set_fork_status (CK_FORK);
}

static void
srunner_iterate_suites (SRunner * sr,
    enum print_output CK_ATTRIBUTE_UNUSED print_mode)
{
  List *slst;
  List *tcl;
  TCase *tc;

  slst = sr->slst;

  for (list_front (slst); !list_at_end (slst); list_advance (slst)) {
    Suite *s = list_val (slst);

    log_suite_start (sr, s);

    tcl = s->tclst;

    for (list_front (tcl); !list_at_end (tcl); list_advance (tcl)) {
      tc = list_val (tcl);
      srunner_run_tcase (sr, tc);
    }

    log_suite_end (sr, s);
  }
}

static void
srunner_iterate_tcase_tfuns (SRunner * sr, TCase * tc)
{
  List *tfl;
  TF *tfun;
  TestResult *tr = NULL;

  tfl = tc->tflst;

  for (list_front (tfl); !list_at_end (tfl); list_advance (tfl)) {
    int i;
    tfun = list_val (tfl);

    for (i = tfun->loop_start; i < tfun->loop_end; i++) {
      log_test_start (sr, tc, tfun);
      switch (srunner_fork_status (sr)) {
        case CK_FORK:
#ifdef _POSIX_VERSION
          tr = tcase_run_tfun_fork (sr, tc, tfun, i);
#else /* _POSIX_VERSION */
          eprintf ("This version does not support fork", __FILE__, __LINE__);
#endif /* _POSIX_VERSION */
          break;
        case CK_NOFORK:
          tr = tcase_run_tfun_nofork (sr, tc, tfun, i);
          break;
        default:
          eprintf ("Bad fork status in SRunner", __FILE__, __LINE__);
      }
      srunner_add_failure (sr, tr);
      log_test_end (sr, tr);
    }
  }
}

static void
srunner_add_failure (SRunner * sr, TestResult * tr)
{
  list_add_end (sr->resultlst, tr);
  sr->stats->n_checked++;       /* count checks during setup, test, and teardown */
  if (tr->rtype == CK_FAILURE)
    sr->stats->n_failed++;
  else if (tr->rtype == CK_ERROR)
    sr->stats->n_errors++;

}

static int
srunner_run_unchecked_setup (SRunner * sr, TCase * tc)
{
  TestResult *tr;
  List *l;
  Fixture *f;
  int rval = 1;

  set_fork_status (CK_NOFORK);

  l = tc->unch_sflst;

  for (list_front (l); !list_at_end (l); list_advance (l)) {
    send_ctx_info (CK_CTX_SETUP);
    f = list_val (l);
    f->fun ();

    tr = receive_result_info_nofork (tc->name, "unchecked_setup", 0);

    if (tr->rtype != CK_PASS) {
      srunner_add_failure (sr, tr);
      rval = 0;
      break;
    }
    free (tr->file);
    free (tr->msg);
    free (tr);
  }

  set_fork_status (srunner_fork_status (sr));
  return rval;
}

static TestResult *
tcase_run_checked_setup (SRunner * sr, TCase * tc)
{
  TestResult *tr = NULL;
  List *l;
  Fixture *f;
  enum fork_status fstat = srunner_fork_status (sr);

  l = tc->ch_sflst;
  if (fstat == CK_FORK) {
    send_ctx_info (CK_CTX_SETUP);
  }

  for (list_front (l); !list_at_end (l); list_advance (l)) {
    if (fstat == CK_NOFORK) {
      send_ctx_info (CK_CTX_SETUP);
    }
    f = list_val (l);
    f->fun ();

    /* Stop the setup and return the failure if nofork mode. */
    if (fstat == CK_NOFORK) {
      tr = receive_result_info_nofork (tc->name, "checked_setup", 0);
      if (tr->rtype != CK_PASS) {
        break;
      }

      free (tr->file);
      free (tr->msg);
      free (tr);
      tr = NULL;
    }
  }

  return tr;
}

static void
srunner_run_teardown (List * l)
{
  Fixture *f;

  for (list_front (l); !list_at_end (l); list_advance (l)) {
    f = list_val (l);
    send_ctx_info (CK_CTX_TEARDOWN);
    f->fun ();
  }
}

static void
srunner_run_unchecked_teardown (TCase * tc)
{
  srunner_run_teardown (tc->unch_tflst);
}

static void
tcase_run_checked_teardown (TCase * tc)
{
  srunner_run_teardown (tc->ch_tflst);
}

static void
srunner_run_tcase (SRunner * sr, TCase * tc)
{
  if (srunner_run_unchecked_setup (sr, tc)) {
    srunner_iterate_tcase_tfuns (sr, tc);
    srunner_run_unchecked_teardown (tc);
  }
}

static TestResult *
tcase_run_tfun_nofork (SRunner * sr, TCase * tc, TF * tfun, int i)
{
  TestResult *tr;

  tr = tcase_run_checked_setup (sr, tc);
  if (tr == NULL) {
    tfun->fn (i);
    tcase_run_checked_teardown (tc);
    return receive_result_info_nofork (tc->name, tfun->name, i);
  }

  return tr;
}

static TestResult *
receive_result_info_nofork (const char *tcname, const char *tname, int iter)
{
  TestResult *tr;

  tr = receive_test_result (0);
  if (tr == NULL)
    eprintf ("Failed to receive test result", __FILE__, __LINE__);
  tr->tcname = tcname;
  tr->tname = tname;
  tr->iter = iter;
  set_nofork_info (tr);

  return tr;
}

static void
set_nofork_info (TestResult * tr)
{
  if (tr->msg == NULL) {
    tr->rtype = CK_PASS;
    tr->msg = pass_msg ();
  } else {
    tr->rtype = CK_FAILURE;
  }
}

static char *
pass_msg (void)
{
  char *msg = emalloc (sizeof ("Passed"));
  strcpy (msg, "Passed");
  return msg;
}

#ifdef _POSIX_VERSION
static TestResult *
tcase_run_tfun_fork (SRunner * sr, TCase * tc, TF * tfun, int i)
{
  pid_t pid_w;
  pid_t pid;
  int status = 0;

  pid = fork ();
  if (pid == -1)
    eprintf ("Error in call to fork:", __FILE__, __LINE__ - 2);
  if (pid == 0) {
    setpgid (0, 0);
    group_pid = getpgrp ();
    tcase_run_checked_setup (sr, tc);
    tfun->fn (i);
    tcase_run_checked_teardown (tc);
    exit (EXIT_SUCCESS);
  } else {
    group_pid = pid;
  }

  alarm_received = 0;
  alarm (tc->timeout);
  do {
    pid_w = waitpid (pid, &status, 0);
  } while (pid_w == -1);

  killpg (pid, SIGKILL);        /* Kill remaining processes. */

  return receive_result_info_fork (tc->name, tfun->name, i, status,
      tfun->signal, tfun->allowed_exit_value);
}

static TestResult *
receive_result_info_fork (const char *tcname,
    const char *tname,
    int iter, int status, int expected_signal, unsigned char allowed_exit_value)
{
  TestResult *tr;

  tr = receive_test_result (waserror (status, expected_signal));
  if (tr == NULL)
    eprintf ("Failed to receive test result", __FILE__, __LINE__);
  tr->tcname = tcname;
  tr->tname = tname;
  tr->iter = iter;
  set_fork_info (tr, status, expected_signal, allowed_exit_value);

  return tr;
}

static void
set_fork_info (TestResult * tr, int status, int signal_expected,
    unsigned char allowed_exit_value)
{
  int was_sig = WIFSIGNALED (status);
  int was_exit = WIFEXITED (status);
  int exit_status = WEXITSTATUS (status);
  int signal_received = WTERMSIG (status);

  if (was_sig) {
    if (signal_expected == signal_received) {
      if (alarm_received) {
        /* Got alarm instead of signal */
        tr->rtype = CK_ERROR;
        tr->msg = signal_error_msg (signal_received, signal_expected);
      } else {
        tr->rtype = CK_PASS;
        tr->msg = pass_msg ();
      }
    } else if (signal_expected != 0) {
      /* signal received, but not the expected one */
      tr->rtype = CK_ERROR;
      tr->msg = signal_error_msg (signal_received, signal_expected);
    } else {
      /* signal received and none expected */
      tr->rtype = CK_ERROR;
      tr->msg = signal_msg (signal_received);
    }
  } else if (signal_expected == 0) {
    if (was_exit && exit_status == allowed_exit_value) {
      tr->rtype = CK_PASS;
      tr->msg = pass_msg ();
    } else if (was_exit && exit_status != allowed_exit_value) {
      if (tr->msg == NULL) {    /* early exit */
        tr->rtype = CK_ERROR;
        tr->msg = exit_msg (exit_status);
      } else {
        tr->rtype = CK_FAILURE;
      }
    }
  } else {                      /* a signal was expected and none raised */
    if (was_exit) {
      tr->msg = exit_msg (exit_status);
      if (exit_status == allowed_exit_value)
        tr->rtype = CK_FAILURE; /* normal exit status */
      else
        tr->rtype = CK_FAILURE; /* early exit */
    }
  }
}

static char *
signal_msg (int signal)
{
  char *msg = emalloc (MSG_LEN);        /* free'd by caller */
  if (alarm_received) {
    snprintf (msg, MSG_LEN, "Test timeout expired");
  } else {
    snprintf (msg, MSG_LEN, "Received signal %d (%s)",
        signal, strsignal (signal));
  }
  return msg;
}

static char *
signal_error_msg (int signal_received, int signal_expected)
{
  char *sig_r_str;
  char *sig_e_str;
  char *msg = emalloc (MSG_LEN);        /* free'd by caller */
  sig_r_str = strdup (strsignal (signal_received));
  sig_e_str = strdup (strsignal (signal_expected));
  if (alarm_received) {
    snprintf (msg, MSG_LEN, "Test timeout expired, expected signal %d (%s)",
        signal_expected, sig_e_str);
  } else {
    snprintf (msg, MSG_LEN, "Received signal %d (%s), expected %d (%s)",
        signal_received, sig_r_str, signal_expected, sig_e_str);
  }
  free (sig_r_str);
  free (sig_e_str);
  return msg;
}

static char *
exit_msg (int exitval)
{
  char *msg = emalloc (MSG_LEN);        /* free'd by caller */
  snprintf (msg, MSG_LEN, "Early exit with return value %d", exitval);
  return msg;
}

static int
waserror (int status, int signal_expected)
{
  int was_sig = WIFSIGNALED (status);
  int was_exit = WIFEXITED (status);
  int exit_status = WEXITSTATUS (status);
  int signal_received = WTERMSIG (status);

  return ((was_sig && (signal_received != signal_expected)) ||
      (was_exit && exit_status != 0));
}
#endif /* _POSIX_VERSION */

enum fork_status
srunner_fork_status (SRunner * sr)
{
  if (sr->fstat == CK_FORK_GETENV) {
    char *env = getenv ("CK_FORK");
    if (env == NULL)
      return CK_FORK;
    if (strcmp (env, "no") == 0)
      return CK_NOFORK;
    else {
#ifdef _POSIX_VERSION
      return CK_FORK;
#else /* _POSIX_VERSION */
      eprintf ("This version does not support fork", __FILE__, __LINE__);
      return CK_NOFORK;
#endif /* _POSIX_VERSION */
    }
  } else
    return sr->fstat;
}

void
srunner_set_fork_status (SRunner * sr, enum fork_status fstat)
{
  sr->fstat = fstat;
}

void
srunner_run_all (SRunner * sr, enum print_output print_mode)
{
#ifdef _POSIX_VERSION
  struct sigaction old_action;
  struct sigaction new_action;
#endif /* _POSIX_VERSION */

  if (sr == NULL)
    return;
  if (print_mode >= CK_LAST) {
    eprintf ("Bad print_mode argument to srunner_run_all: %d",
        __FILE__, __LINE__, print_mode);
  }
#ifdef _POSIX_VERSION
  memset (&new_action, 0, sizeof new_action);
  new_action.sa_handler = sig_handler;
  sigaction (SIGALRM, &new_action, &old_action);
#endif /* _POSIX_VERSION */
  srunner_run_init (sr, print_mode);
  srunner_iterate_suites (sr, print_mode);
  srunner_run_end (sr, print_mode);
#ifdef _POSIX_VERSION
  sigaction (SIGALRM, &old_action, NULL);
#endif /* _POSIX_VERSION */
}

pid_t
check_fork (void)
{
#ifdef _POSIX_VERSION
  pid_t pid = fork ();
  /* Set the process to a process group to be able to kill it easily. */
  setpgid (pid, group_pid);
  return pid;
#else /* _POSIX_VERSION */
  eprintf ("This version does not support fork", __FILE__, __LINE__);
  return 0;
#endif /* _POSIX_VERSION */
}

void
check_waitpid_and_exit (pid_t pid CK_ATTRIBUTE_UNUSED)
{
#ifdef _POSIX_VERSION
  pid_t pid_w;
  int status;

  if (pid > 0) {
    do {
      pid_w = waitpid (pid, &status, 0);
    } while (pid_w == -1);
    if (waserror (status, 0)) {
      exit (EXIT_FAILURE);
    }
  }
  exit (EXIT_SUCCESS);
#else /* _POSIX_VERSION */
  eprintf ("This version does not support fork", __FILE__, __LINE__);
#endif /* _POSIX_VERSION */
}
