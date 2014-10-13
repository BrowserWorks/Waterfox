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

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "_stdint.h"

#include "check.h"
#include "check_error.h"
#include "check_list.h"
#include "check_impl.h"
#include "check_pack.h"

#ifdef HAVE_PTHREAD
#include <pthread.h>
pthread_mutex_t lock_mutex = PTHREAD_MUTEX_INITIALIZER;
#else
#define pthread_mutex_lock(arg)
#define pthread_mutex_unlock(arg)
#endif

/* typedef an unsigned int that has at least 4 bytes */
typedef uint32_t ck_uint32;


static void pack_int (char **buf, int val);
static int upack_int (char **buf);
static void pack_str (char **buf, const char *str);
static char *upack_str (char **buf);

static int pack_ctx (char **buf, CtxMsg * cmsg);
static int pack_loc (char **buf, LocMsg * lmsg);
static int pack_fail (char **buf, FailMsg * fmsg);
static void upack_ctx (char **buf, CtxMsg * cmsg);
static void upack_loc (char **buf, LocMsg * lmsg);
static void upack_fail (char **buf, FailMsg * fmsg);

static void check_type (int type, const char *file, int line);
static enum ck_msg_type upack_type (char **buf);
static void pack_type (char **buf, enum ck_msg_type type);

static int read_buf (int fdes, char **buf);
static int get_result (char *buf, RcvMsg * rmsg);
static void rcvmsg_update_ctx (RcvMsg * rmsg, enum ck_result_ctx ctx);
static void rcvmsg_update_loc (RcvMsg * rmsg, const char *file, int line);
static RcvMsg *rcvmsg_create (void);
void rcvmsg_free (RcvMsg * rmsg);

typedef int (*pfun) (char **, CheckMsg *);
typedef void (*upfun) (char **, CheckMsg *);

static pfun pftab[] = {
  (pfun) pack_ctx,
  (pfun) pack_fail,
  (pfun) pack_loc
};

static upfun upftab[] = {
  (upfun) upack_ctx,
  (upfun) upack_fail,
  (upfun) upack_loc
};

int
pack (enum ck_msg_type type, char **buf, CheckMsg * msg)
{
  if (buf == NULL)
    return -1;
  if (msg == NULL)
    return 0;

  check_type (type, __FILE__, __LINE__);

  return pftab[type] (buf, msg);
}

int
upack (char *buf, CheckMsg * msg, enum ck_msg_type *type)
{
  char *obuf;
  int nread;

  if (buf == NULL)
    return -1;

  obuf = buf;

  *type = upack_type (&buf);

  check_type (*type, __FILE__, __LINE__);

  upftab[*type] (&buf, msg);

  nread = buf - obuf;
  return nread;
}

static void
pack_int (char **buf, int val)
{
  unsigned char *ubuf = (unsigned char *) *buf;
  ck_uint32 uval = val;

  ubuf[0] = (uval >> 24) & 0xFF;
  ubuf[1] = (uval >> 16) & 0xFF;
  ubuf[2] = (uval >> 8) & 0xFF;
  ubuf[3] = uval & 0xFF;

  *buf += 4;
}

static int
upack_int (char **buf)
{
  unsigned char *ubuf = (unsigned char *) *buf;
  ck_uint32 uval;

  uval = ((ubuf[0] << 24) | (ubuf[1] << 16) | (ubuf[2] << 8) | ubuf[3]);

  *buf += 4;

  return (int) uval;
}

static void
pack_str (char **buf, const char *val)
{
  int strsz;

  if (val == NULL)
    strsz = 0;
  else
    strsz = strlen (val);

  pack_int (buf, strsz);

  if (strsz > 0) {
    memcpy (*buf, val, strsz);
    *buf += strsz;
  }
}

static char *
upack_str (char **buf)
{
  char *val;
  int strsz;

  strsz = upack_int (buf);

  if (strsz > 0) {
    val = emalloc (strsz + 1);
    memcpy (val, *buf, strsz);
    val[strsz] = 0;
    *buf += strsz;
  } else {
    val = emalloc (1);
    *val = 0;
  }

  return val;
}

static void
pack_type (char **buf, enum ck_msg_type type)
{
  pack_int (buf, (int) type);
}

static enum ck_msg_type
upack_type (char **buf)
{
  return (enum ck_msg_type) upack_int (buf);
}


static int
pack_ctx (char **buf, CtxMsg * cmsg)
{
  char *ptr;
  int len;

  len = 4 + 4;
  *buf = ptr = emalloc (len);

  pack_type (&ptr, CK_MSG_CTX);
  pack_int (&ptr, (int) cmsg->ctx);

  return len;
}

static void
upack_ctx (char **buf, CtxMsg * cmsg)
{
  cmsg->ctx = upack_int (buf);
}

static int
pack_loc (char **buf, LocMsg * lmsg)
{
  char *ptr;
  int len;

  len = 4 + 4 + (lmsg->file ? strlen (lmsg->file) : 0) + 4;
  *buf = ptr = emalloc (len);

  pack_type (&ptr, CK_MSG_LOC);
  pack_str (&ptr, lmsg->file);
  pack_int (&ptr, lmsg->line);

  return len;
}

static void
upack_loc (char **buf, LocMsg * lmsg)
{
  lmsg->file = upack_str (buf);
  lmsg->line = upack_int (buf);
}

static int
pack_fail (char **buf, FailMsg * fmsg)
{
  char *ptr;
  int len;

  len = 4 + 4 + (fmsg->msg ? strlen (fmsg->msg) : 0);
  *buf = ptr = emalloc (len);

  pack_type (&ptr, CK_MSG_FAIL);
  pack_str (&ptr, fmsg->msg);

  return len;
}

static void
upack_fail (char **buf, FailMsg * fmsg)
{
  fmsg->msg = upack_str (buf);
}

static void
check_type (int type, const char *file, int line)
{
  if (type < 0 || type >= CK_MSG_LAST)
    eprintf ("Bad message type arg %d", file, line, type);
}

#ifdef HAVE_PTHREAD
pthread_mutex_t mutex_lock = PTHREAD_MUTEX_INITIALIZER;
#endif

void
ppack (int fdes, enum ck_msg_type type, CheckMsg * msg)
{
  char *buf;
  int n;
  ssize_t r;

  n = pack (type, &buf, msg);
  pthread_mutex_lock (&mutex_lock);
  r = write (fdes, buf, n);
  pthread_mutex_unlock (&mutex_lock);
  if (r == -1)
    eprintf ("Error in call to write:", __FILE__, __LINE__ - 2);

  free (buf);
}

static int
read_buf (int fdes, char **buf)
{
  char *readloc;
  int n;
  int nread = 0;
  int size = 1;
  int grow = 2;

  *buf = emalloc (size);
  readloc = *buf;
  while (1) {
    n = read (fdes, readloc, size - nread);
    if (n == 0)
      break;
    if (n == -1)
      eprintf ("Error in call to read:", __FILE__, __LINE__ - 4);

    nread += n;
    size *= grow;
    *buf = erealloc (*buf, size);
    readloc = *buf + nread;
  }

  return nread;
}


static int
get_result (char *buf, RcvMsg * rmsg)
{
  enum ck_msg_type type;
  CheckMsg msg;
  int n;

  n = upack (buf, &msg, &type);
  if (n == -1)
    eprintf ("Error in call to upack", __FILE__, __LINE__ - 2);

  if (type == CK_MSG_CTX) {
    CtxMsg *cmsg = (CtxMsg *) & msg;
    rcvmsg_update_ctx (rmsg, cmsg->ctx);
  } else if (type == CK_MSG_LOC) {
    LocMsg *lmsg = (LocMsg *) & msg;
    if (rmsg->failctx == CK_CTX_INVALID) {
      rcvmsg_update_loc (rmsg, lmsg->file, lmsg->line);
    }
    free (lmsg->file);
  } else if (type == CK_MSG_FAIL) {
    FailMsg *fmsg = (FailMsg *) & msg;
    if (rmsg->msg == NULL) {
      rmsg->msg = emalloc (strlen (fmsg->msg) + 1);
      strcpy (rmsg->msg, fmsg->msg);
      rmsg->failctx = rmsg->lastctx;
    } else {
      /* Skip subsequent failure messages, only happens for CK_NOFORK */
    }
    free (fmsg->msg);
  } else
    check_type (type, __FILE__, __LINE__);

  return n;
}

static void
reset_rcv_test (RcvMsg * rmsg)
{
  rmsg->test_line = -1;
  rmsg->test_file = NULL;
}

static void
reset_rcv_fixture (RcvMsg * rmsg)
{
  rmsg->fixture_line = -1;
  rmsg->fixture_file = NULL;
}

static RcvMsg *
rcvmsg_create (void)
{
  RcvMsg *rmsg;

  rmsg = emalloc (sizeof (RcvMsg));
  rmsg->lastctx = CK_CTX_INVALID;
  rmsg->failctx = CK_CTX_INVALID;
  rmsg->msg = NULL;
  reset_rcv_test (rmsg);
  reset_rcv_fixture (rmsg);
  return rmsg;
}

void
rcvmsg_free (RcvMsg * rmsg)
{
  free (rmsg->fixture_file);
  free (rmsg->test_file);
  free (rmsg->msg);
  free (rmsg);
}

static void
rcvmsg_update_ctx (RcvMsg * rmsg, enum ck_result_ctx ctx)
{
  if (rmsg->lastctx != CK_CTX_INVALID) {
    free (rmsg->fixture_file);
    reset_rcv_fixture (rmsg);
  }
  rmsg->lastctx = ctx;
}

static void
rcvmsg_update_loc (RcvMsg * rmsg, const char *file, int line)
{
  int flen = strlen (file);

  if (rmsg->lastctx == CK_CTX_TEST) {
    free (rmsg->test_file);
    rmsg->test_line = line;
    rmsg->test_file = emalloc (flen + 1);
    strcpy (rmsg->test_file, file);
  } else {
    free (rmsg->fixture_file);
    rmsg->fixture_line = line;
    rmsg->fixture_file = emalloc (flen + 1);
    strcpy (rmsg->fixture_file, file);
  }
}

RcvMsg *
punpack (int fdes)
{
  int nread, n;
  char *buf;
  char *obuf;
  RcvMsg *rmsg;

  nread = read_buf (fdes, &buf);
  obuf = buf;
  rmsg = rcvmsg_create ();

  while (nread > 0) {
    n = get_result (buf, rmsg);
    nread -= n;
    buf += n;
  }

  free (obuf);
  if (rmsg->lastctx == CK_CTX_INVALID) {
    free (rmsg);
    rmsg = NULL;
  }

  return rmsg;
}
