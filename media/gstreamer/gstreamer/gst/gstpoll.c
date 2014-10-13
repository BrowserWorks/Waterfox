/* GStreamer
 * Copyright (C) 1999 Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) 2004 Wim Taymans <wim.taymans@gmail.com>
 * Copyright (C) 2007 Peter Kjellerstedt <pkj@axis.com>
 * Copyright (C) 2008 Ole André Vadla Ravnås <ole.andre.ravnas@tandberg.com>
 *
 * gstpoll.c: File descriptor set
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
/**
 * SECTION:gstpoll
 * @short_description: Keep track of file descriptors and make it possible
 *                     to wait on them in a cancellable way
 *
 * A #GstPoll keeps track of file descriptors much like fd_set (used with
 * select()) or a struct pollfd array (used with poll()). Once created with
 * gst_poll_new(), the set can be used to wait for file descriptors to be
 * readable and/or writable. It is possible to make this wait be controlled
 * by specifying %TRUE for the @controllable flag when creating the set (or
 * later calling gst_poll_set_controllable()).
 *
 * New file descriptors are added to the set using gst_poll_add_fd(), and
 * removed using gst_poll_remove_fd(). Controlling which file descriptors
 * should be waited for to become readable and/or writable are done using
 * gst_poll_fd_ctl_read() and gst_poll_fd_ctl_write().
 *
 * Use gst_poll_wait() to wait for the file descriptors to actually become
 * readable and/or writable, or to timeout if no file descriptor is available
 * in time. The wait can be controlled by calling gst_poll_restart() and
 * gst_poll_set_flushing().
 *
 * Once the file descriptor set has been waited for, one can use
 * gst_poll_fd_has_closed() to see if the file descriptor has been closed,
 * gst_poll_fd_has_error() to see if it has generated an error,
 * gst_poll_fd_can_read() to see if it is possible to read from the file
 * descriptor, and gst_poll_fd_can_write() to see if it is possible to
 * write to it.
 *
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include "glib-compat-private.h"

#include <sys/types.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include <errno.h>
#include <fcntl.h>

#include <glib.h>

#ifdef G_OS_WIN32
#include <winsock2.h>
#else
#define _GNU_SOURCE 1
#ifdef HAVE_SYS_POLL_H
#include <sys/poll.h>
#endif
#ifdef HAVE_POLL_H
#include <poll.h>
#endif
#include <sys/time.h>
#include <sys/socket.h>
#endif

/* OS/X needs this because of bad headers */
#include <string.h>

/* The poll() emulation on OS/X doesn't handle fds=NULL, nfds=0,
 * so we prefer our own poll emulation.
 */
#if defined(BROKEN_POLL)
#undef HAVE_POLL
#endif

#include "gstpoll.h"

#define GST_CAT_DEFAULT GST_CAT_POLL

#ifdef G_OS_WIN32
typedef struct _WinsockFd WinsockFd;

struct _WinsockFd
{
  gint fd;
  glong event_mask;
  WSANETWORKEVENTS events;
  glong ignored_event_mask;
};
#endif

typedef enum
{
  GST_POLL_MODE_AUTO,
  GST_POLL_MODE_SELECT,
  GST_POLL_MODE_PSELECT,
  GST_POLL_MODE_POLL,
  GST_POLL_MODE_PPOLL,
  GST_POLL_MODE_WINDOWS
} GstPollMode;

struct _GstPoll
{
  GstPollMode mode;

  GMutex lock;
  /* array of fds, always written to and read from with lock */
  GArray *fds;
  /* array of active fds, only written to from the waiting thread with the
   * lock and read from with the lock or without the lock from the waiting
   * thread */
  GArray *active_fds;

#ifndef G_OS_WIN32
  gchar buf[1];
  GstPollFD control_read_fd;
  GstPollFD control_write_fd;
#else
  GArray *active_fds_ignored;
  GArray *events;
  GArray *active_events;

  HANDLE wakeup_event;
#endif

  gboolean controllable;
  volatile gint waiting;
  volatile gint control_pending;
  volatile gint flushing;
  gboolean timer;
  volatile gint rebuild;
};

static gboolean gst_poll_fd_ctl_read_unlocked (GstPoll * set, GstPollFD * fd,
    gboolean active);
static gboolean gst_poll_add_fd_unlocked (GstPoll * set, GstPollFD * fd);

#define IS_FLUSHING(s)      (g_atomic_int_get(&(s)->flushing))
#define SET_FLUSHING(s,val) (g_atomic_int_set(&(s)->flushing, (val)))

#define INC_WAITING(s)      (g_atomic_int_add(&(s)->waiting, 1))
#define DEC_WAITING(s)      (g_atomic_int_add(&(s)->waiting, -1))
#define GET_WAITING(s)      (g_atomic_int_get(&(s)->waiting))

#define TEST_REBUILD(s)     (g_atomic_int_compare_and_exchange(&(s)->rebuild, 1, 0))
#define MARK_REBUILD(s)     (g_atomic_int_set(&(s)->rebuild, 1))

#ifndef G_OS_WIN32
#define WAKE_EVENT(s)       (write ((s)->control_write_fd.fd, "W", 1) == 1)
#define RELEASE_EVENT(s)    (read ((s)->control_read_fd.fd, (s)->buf, 1) == 1)
#else
#define WAKE_EVENT(s)       (SetLastError (0), SetEvent ((s)->wakeup_event), errno = GetLastError () == NO_ERROR ? 0 : EACCES, errno == 0 ? 1 : 0)
#define RELEASE_EVENT(s)    (ResetEvent ((s)->wakeup_event))
#endif

/* the poll/select call is also performed on a control socket, that way
 * we can send special commands to control it */
static inline gboolean
raise_wakeup (GstPoll * set)
{
  gboolean result = TRUE;

  if (g_atomic_int_add (&set->control_pending, 1) == 0) {
    /* raise when nothing pending */
    GST_LOG ("%p: raise", set);
    result = WAKE_EVENT (set);
  }
  return result;
}

/* note how bad things can happen when the 2 threads both raise and release the
 * wakeup. This is however not a problem because you must always pair a raise
 * with a release */
static inline gboolean
release_wakeup (GstPoll * set)
{
  gboolean result = TRUE;

  if (g_atomic_int_dec_and_test (&set->control_pending)) {
    GST_LOG ("%p: release", set);
    result = RELEASE_EVENT (set);
  }
  return result;
}

static inline gint
release_all_wakeup (GstPoll * set)
{
  gint old;

  while (TRUE) {
    if (!(old = g_atomic_int_get (&set->control_pending)))
      /* nothing pending, just exit */
      break;

    /* try to remove all pending control messages */
    if (g_atomic_int_compare_and_exchange (&set->control_pending, old, 0)) {
      /* we managed to remove all messages, read the control socket */
      if (RELEASE_EVENT (set))
        break;
      else
        /* retry again until we read it successfully */
        g_atomic_int_add (&set->control_pending, 1);
    }
  }
  return old;
}

static gint
find_index (GArray * array, GstPollFD * fd)
{
#ifndef G_OS_WIN32
  struct pollfd *ifd;
#else
  WinsockFd *ifd;
#endif
  guint i;

  /* start by assuming the index found in the fd is still valid */
  if (fd->idx >= 0 && fd->idx < array->len) {
#ifndef G_OS_WIN32
    ifd = &g_array_index (array, struct pollfd, fd->idx);
#else
    ifd = &g_array_index (array, WinsockFd, fd->idx);
#endif

    if (ifd->fd == fd->fd) {
      return fd->idx;
    }
  }

  /* the pollfd array has changed and we need to lookup the fd again */
  for (i = 0; i < array->len; i++) {
#ifndef G_OS_WIN32
    ifd = &g_array_index (array, struct pollfd, i);
#else
    ifd = &g_array_index (array, WinsockFd, i);
#endif

    if (ifd->fd == fd->fd) {
      fd->idx = (gint) i;
      return fd->idx;
    }
  }

  fd->idx = -1;
  return fd->idx;
}

#if !defined(HAVE_PPOLL) && defined(HAVE_POLL)
/* check if all file descriptors will fit in an fd_set */
static gboolean
selectable_fds (GstPoll * set)
{
  guint i;

  g_mutex_lock (&set->lock);
  for (i = 0; i < set->fds->len; i++) {
    struct pollfd *pfd = &g_array_index (set->fds, struct pollfd, i);

    if (pfd->fd >= FD_SETSIZE)
      goto too_many;
  }
  g_mutex_unlock (&set->lock);

  return TRUE;

too_many:
  {
    g_mutex_unlock (&set->lock);
    return FALSE;
  }
}

/* check if the timeout will convert to a timeout value used for poll()
 * without a loss of precision
 */
static gboolean
pollable_timeout (GstClockTime timeout)
{
  if (timeout == GST_CLOCK_TIME_NONE)
    return TRUE;

  /* not a nice multiple of milliseconds */
  if (timeout % 1000000)
    return FALSE;

  return TRUE;
}
#endif

static GstPollMode
choose_mode (GstPoll * set, GstClockTime timeout)
{
  GstPollMode mode;

  if (set->mode == GST_POLL_MODE_AUTO) {
#ifdef HAVE_PPOLL
    mode = GST_POLL_MODE_PPOLL;
#elif defined(HAVE_POLL)
    if (!selectable_fds (set) || pollable_timeout (timeout)) {
      mode = GST_POLL_MODE_POLL;
    } else {
#ifdef HAVE_PSELECT
      mode = GST_POLL_MODE_PSELECT;
#else
      mode = GST_POLL_MODE_SELECT;
#endif
    }
#elif defined(HAVE_PSELECT)
    mode = GST_POLL_MODE_PSELECT;
#else
    mode = GST_POLL_MODE_SELECT;
#endif
  } else {
    mode = set->mode;
  }
  return mode;
}

#ifndef G_OS_WIN32
static gint
pollfd_to_fd_set (GstPoll * set, fd_set * readfds, fd_set * writefds,
    fd_set * errorfds)
{
  gint max_fd = -1;
  guint i;

  FD_ZERO (readfds);
  FD_ZERO (writefds);
  FD_ZERO (errorfds);

  g_mutex_lock (&set->lock);

  for (i = 0; i < set->active_fds->len; i++) {
    struct pollfd *pfd = &g_array_index (set->fds, struct pollfd, i);

    if (pfd->fd < FD_SETSIZE) {
      if (pfd->events & POLLIN)
        FD_SET (pfd->fd, readfds);
      if (pfd->events & POLLOUT)
        FD_SET (pfd->fd, writefds);
      if (pfd->events)
        FD_SET (pfd->fd, errorfds);
      if (pfd->fd > max_fd && (pfd->events & (POLLIN | POLLOUT)))
        max_fd = pfd->fd;
    }
  }

  g_mutex_unlock (&set->lock);

  return max_fd;
}

static void
fd_set_to_pollfd (GstPoll * set, fd_set * readfds, fd_set * writefds,
    fd_set * errorfds)
{
  guint i;

  g_mutex_lock (&set->lock);

  for (i = 0; i < set->active_fds->len; i++) {
    struct pollfd *pfd = &g_array_index (set->active_fds, struct pollfd, i);

    if (pfd->fd < FD_SETSIZE) {
      pfd->revents = 0;
      if (FD_ISSET (pfd->fd, readfds))
        pfd->revents |= POLLIN;
      if (FD_ISSET (pfd->fd, writefds))
        pfd->revents |= POLLOUT;
      if (FD_ISSET (pfd->fd, errorfds))
        pfd->revents |= POLLERR;
    }
  }

  g_mutex_unlock (&set->lock);
}
#else /* G_OS_WIN32 */
/*
 * Translate errors thrown by the Winsock API used by GstPoll:
 *   WSAEventSelect, WSAWaitForMultipleEvents and WSAEnumNetworkEvents
 */
static gint
gst_poll_winsock_error_to_errno (DWORD last_error)
{
  switch (last_error) {
    case WSA_INVALID_HANDLE:
    case WSAEINVAL:
    case WSAENOTSOCK:
      return EBADF;

    case WSA_NOT_ENOUGH_MEMORY:
      return ENOMEM;

      /*
       * Anything else, including:
       *   WSA_INVALID_PARAMETER, WSAEFAULT, WSAEINPROGRESS, WSAENETDOWN,
       *   WSANOTINITIALISED
       */
    default:
      return EINVAL;
  }
}

static void
gst_poll_free_winsock_event (GstPoll * set, gint idx)
{
  WinsockFd *wfd = &g_array_index (set->fds, WinsockFd, idx);
  HANDLE event = g_array_index (set->events, HANDLE, idx);

  WSAEventSelect (wfd->fd, event, 0);
  CloseHandle (event);
}

static void
gst_poll_update_winsock_event_mask (GstPoll * set, gint idx, glong flags,
    gboolean active)
{
  WinsockFd *wfd;

  wfd = &g_array_index (set->fds, WinsockFd, idx);

  if (active)
    wfd->event_mask |= flags;
  else
    wfd->event_mask &= ~flags;

  /* reset ignored state if the new mask doesn't overlap at all */
  if ((wfd->ignored_event_mask & wfd->event_mask) == 0)
    wfd->ignored_event_mask = 0;
}

static gboolean
gst_poll_prepare_winsock_active_sets (GstPoll * set)
{
  guint i;

  g_array_set_size (set->active_fds, 0);
  g_array_set_size (set->active_fds_ignored, 0);
  g_array_set_size (set->active_events, 0);
  g_array_append_val (set->active_events, set->wakeup_event);

  for (i = 0; i < set->fds->len; i++) {
    WinsockFd *wfd = &g_array_index (set->fds, WinsockFd, i);
    HANDLE event = g_array_index (set->events, HANDLE, i);

    if (wfd->ignored_event_mask == 0) {
      gint ret;

      g_array_append_val (set->active_fds, *wfd);
      g_array_append_val (set->active_events, event);

      ret = WSAEventSelect (wfd->fd, event, wfd->event_mask);
      if (G_UNLIKELY (ret != 0)) {
        errno = gst_poll_winsock_error_to_errno (WSAGetLastError ());
        return FALSE;
      }
    } else {
      g_array_append_val (set->active_fds_ignored, wfd);
    }
  }

  return TRUE;
}

static gint
gst_poll_collect_winsock_events (GstPoll * set)
{
  gint res, i;

  /*
   * We need to check which events are signaled, and call
   * WSAEnumNetworkEvents for those that are, which resets
   * the event and clears the internal network event records.
   */
  res = 0;
  for (i = 0; i < set->active_fds->len; i++) {
    WinsockFd *wfd = &g_array_index (set->active_fds, WinsockFd, i);
    HANDLE event = g_array_index (set->active_events, HANDLE, i + 1);
    DWORD wait_ret;

    wait_ret = WaitForSingleObject (event, 0);
    if (wait_ret == WAIT_OBJECT_0) {
      gint enum_ret = WSAEnumNetworkEvents (wfd->fd, event, &wfd->events);

      if (G_UNLIKELY (enum_ret != 0)) {
        res = -1;
        errno = gst_poll_winsock_error_to_errno (WSAGetLastError ());
        break;
      }

      res++;
    } else {
      /* clear any previously stored result */
      memset (&wfd->events, 0, sizeof (wfd->events));
    }
  }

  /* If all went well we also need to reset the ignored fds. */
  if (res >= 0) {
    res += set->active_fds_ignored->len;

    for (i = 0; i < set->active_fds_ignored->len; i++) {
      WinsockFd *wfd = g_array_index (set->active_fds_ignored, WinsockFd *, i);

      wfd->ignored_event_mask = 0;
    }

    g_array_set_size (set->active_fds_ignored, 0);
  }

  return res;
}
#endif

/**
 * gst_poll_new: (skip)
 * @controllable: whether it should be possible to control a wait.
 *
 * Create a new file descriptor set. If @controllable, it
 * is possible to restart or flush a call to gst_poll_wait() with
 * gst_poll_restart() and gst_poll_set_flushing() respectively.
 *
 * Free-function: gst_poll_free
 *
 * Returns: (transfer full) (nullable): a new #GstPoll, or %NULL in
 *     case of an error.  Free with gst_poll_free().
 */
GstPoll *
gst_poll_new (gboolean controllable)
{
  GstPoll *nset;

  nset = g_slice_new0 (GstPoll);
  GST_DEBUG ("%p: new controllable : %d", nset, controllable);
  g_mutex_init (&nset->lock);
#ifndef G_OS_WIN32
  nset->mode = GST_POLL_MODE_AUTO;
  nset->fds = g_array_new (FALSE, FALSE, sizeof (struct pollfd));
  nset->active_fds = g_array_new (FALSE, FALSE, sizeof (struct pollfd));
  nset->control_read_fd.fd = -1;
  nset->control_write_fd.fd = -1;
  {
    gint control_sock[2];

    if (socketpair (PF_UNIX, SOCK_STREAM, 0, control_sock) < 0)
      goto no_socket_pair;

    fcntl (control_sock[0], F_SETFL, O_NONBLOCK);
    fcntl (control_sock[1], F_SETFL, O_NONBLOCK);

    nset->control_read_fd.fd = control_sock[0];
    nset->control_write_fd.fd = control_sock[1];

    gst_poll_add_fd_unlocked (nset, &nset->control_read_fd);
    gst_poll_fd_ctl_read_unlocked (nset, &nset->control_read_fd, TRUE);
  }
#else
  nset->mode = GST_POLL_MODE_WINDOWS;
  nset->fds = g_array_new (FALSE, FALSE, sizeof (WinsockFd));
  nset->active_fds = g_array_new (FALSE, FALSE, sizeof (WinsockFd));
  nset->active_fds_ignored = g_array_new (FALSE, FALSE, sizeof (WinsockFd *));
  nset->events = g_array_new (FALSE, FALSE, sizeof (HANDLE));
  nset->active_events = g_array_new (FALSE, FALSE, sizeof (HANDLE));

  nset->wakeup_event = CreateEvent (NULL, TRUE, FALSE, NULL);
#endif

  /* ensure (re)build, though already sneakily set in non-windows case */
  MARK_REBUILD (nset);

  nset->controllable = controllable;

  return nset;

  /* ERRORS */
#ifndef G_OS_WIN32
no_socket_pair:
  {
    GST_WARNING ("%p: can't create socket pair !", nset);
    gst_poll_free (nset);
    return NULL;
  }
#endif
}

/**
 * gst_poll_new_timer: (skip)
 *
 * Create a new poll object that can be used for scheduling cancellable
 * timeouts.
 *
 * A timeout is performed with gst_poll_wait(). Multiple timeouts can be
 * performed from different threads. 
 *
 * Free-function: gst_poll_free
 *
 * Returns: (transfer full) (nullable): a new #GstPoll, or %NULL in
 *     case of an error.  Free with gst_poll_free().
 */
GstPoll *
gst_poll_new_timer (void)
{
  GstPoll *poll;

  /* make a new controllable poll set */
  if (!(poll = gst_poll_new (TRUE)))
    goto done;

  /* we are a timer */
  poll->timer = TRUE;

done:
  return poll;
}

/**
 * gst_poll_free:
 * @set: (transfer full): a file descriptor set.
 *
 * Free a file descriptor set.
 */
void
gst_poll_free (GstPoll * set)
{
  g_return_if_fail (set != NULL);

  GST_DEBUG ("%p: freeing", set);

#ifndef G_OS_WIN32
  if (set->control_write_fd.fd >= 0)
    close (set->control_write_fd.fd);
  if (set->control_read_fd.fd >= 0)
    close (set->control_read_fd.fd);
#else
  CloseHandle (set->wakeup_event);

  {
    guint i;

    for (i = 0; i < set->events->len; i++)
      gst_poll_free_winsock_event (set, i);
  }

  g_array_free (set->active_events, TRUE);
  g_array_free (set->events, TRUE);
  g_array_free (set->active_fds_ignored, TRUE);
#endif

  g_array_free (set->active_fds, TRUE);
  g_array_free (set->fds, TRUE);
  g_mutex_clear (&set->lock);
  g_slice_free (GstPoll, set);
}

/**
 * gst_poll_get_read_gpollfd:
 * @set: a #GstPoll
 * @fd: a #GPollFD
 *
 * Get a GPollFD for the reading part of the control socket. This is useful when
 * integrating with a GSource and GMainLoop.
 */
void
gst_poll_get_read_gpollfd (GstPoll * set, GPollFD * fd)
{
  g_return_if_fail (set != NULL);
  g_return_if_fail (fd != NULL);

#ifndef G_OS_WIN32
  fd->fd = set->control_read_fd.fd;
#else
#if GLIB_SIZEOF_VOID_P == 8
  fd->fd = (gint64) set->wakeup_event;
#else
  fd->fd = (gint) set->wakeup_event;
#endif
#endif
  fd->events = G_IO_IN | G_IO_HUP | G_IO_ERR;
  fd->revents = 0;
}

/**
 * gst_poll_fd_init:
 * @fd: a #GstPollFD
 *
 * Initializes @fd. Alternatively you can initialize it with
 * #GST_POLL_FD_INIT.
 */
void
gst_poll_fd_init (GstPollFD * fd)
{
  g_return_if_fail (fd != NULL);

  fd->fd = -1;
  fd->idx = -1;
}

static gboolean
gst_poll_add_fd_unlocked (GstPoll * set, GstPollFD * fd)
{
  gint idx;

  GST_DEBUG ("%p: fd (fd:%d, idx:%d)", set, fd->fd, fd->idx);

  idx = find_index (set->fds, fd);
  if (idx < 0) {
#ifndef G_OS_WIN32
    struct pollfd nfd;

    nfd.fd = fd->fd;
    nfd.events = POLLERR | POLLNVAL | POLLHUP;
    nfd.revents = 0;

    g_array_append_val (set->fds, nfd);

    fd->idx = set->fds->len - 1;
#else
    WinsockFd wfd;
    HANDLE event;

    wfd.fd = fd->fd;
    wfd.event_mask = FD_CLOSE;
    memset (&wfd.events, 0, sizeof (wfd.events));
    wfd.ignored_event_mask = 0;
    event = WSACreateEvent ();

    g_array_append_val (set->fds, wfd);
    g_array_append_val (set->events, event);

    fd->idx = set->fds->len - 1;
#endif
    MARK_REBUILD (set);
  } else {
    GST_WARNING ("%p: fd already added !", set);
  }

  return TRUE;
}

/**
 * gst_poll_add_fd:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Add a file descriptor to the file descriptor set.
 *
 * Returns: %TRUE if the file descriptor was successfully added to the set.
 */
gboolean
gst_poll_add_fd (GstPoll * set, GstPollFD * fd)
{
  gboolean ret;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&set->lock);

  ret = gst_poll_add_fd_unlocked (set, fd);

  g_mutex_unlock (&set->lock);

  return ret;
}

/**
 * gst_poll_remove_fd:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Remove a file descriptor from the file descriptor set.
 *
 * Returns: %TRUE if the file descriptor was successfully removed from the set.
 */
gboolean
gst_poll_remove_fd (GstPoll * set, GstPollFD * fd)
{
  gint idx;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);


  GST_DEBUG ("%p: fd (fd:%d, idx:%d)", set, fd->fd, fd->idx);

  g_mutex_lock (&set->lock);

  /* get the index, -1 is an fd that is not added */
  idx = find_index (set->fds, fd);
  if (idx >= 0) {
#ifdef G_OS_WIN32
    gst_poll_free_winsock_event (set, idx);
    g_array_remove_index_fast (set->events, idx);
#endif

    /* remove the fd at index, we use _remove_index_fast, which copies the last
     * element of the array to the freed index */
    g_array_remove_index_fast (set->fds, idx);

    /* mark fd as removed by setting the index to -1 */
    fd->idx = -1;
    MARK_REBUILD (set);
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }

  g_mutex_unlock (&set->lock);

  return idx >= 0;
}

/**
 * gst_poll_fd_ctl_write:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 * @active: a new status.
 *
 * Control whether the descriptor @fd in @set will be monitored for
 * writability.
 *
 * Returns: %TRUE if the descriptor was successfully updated.
 */
gboolean
gst_poll_fd_ctl_write (GstPoll * set, GstPollFD * fd, gboolean active)
{
  gint idx;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  GST_DEBUG ("%p: fd (fd:%d, idx:%d), active : %d", set,
      fd->fd, fd->idx, active);

  g_mutex_lock (&set->lock);

  idx = find_index (set->fds, fd);
  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->fds, struct pollfd, idx);

    if (active)
      pfd->events |= POLLOUT;
    else
      pfd->events &= ~POLLOUT;

    GST_LOG ("%p: pfd->events now %d (POLLOUT:%d)", set, pfd->events, POLLOUT);
#else
    gst_poll_update_winsock_event_mask (set, idx, FD_WRITE | FD_CONNECT,
        active);
#endif
    MARK_REBUILD (set);
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }

  g_mutex_unlock (&set->lock);

  return idx >= 0;
}

static gboolean
gst_poll_fd_ctl_read_unlocked (GstPoll * set, GstPollFD * fd, gboolean active)
{
  gint idx;

  GST_DEBUG ("%p: fd (fd:%d, idx:%d), active : %d", set,
      fd->fd, fd->idx, active);

  idx = find_index (set->fds, fd);

  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->fds, struct pollfd, idx);

    if (active)
      pfd->events |= (POLLIN | POLLPRI);
    else
      pfd->events &= ~(POLLIN | POLLPRI);
#else
    gst_poll_update_winsock_event_mask (set, idx, FD_READ | FD_ACCEPT, active);
#endif
    MARK_REBUILD (set);
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }

  return idx >= 0;
}

/**
 * gst_poll_fd_ctl_read:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 * @active: a new status.
 *
 * Control whether the descriptor @fd in @set will be monitored for
 * readability.
 *
 * Returns: %TRUE if the descriptor was successfully updated.
 */
gboolean
gst_poll_fd_ctl_read (GstPoll * set, GstPollFD * fd, gboolean active)
{
  gboolean ret;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&set->lock);

  ret = gst_poll_fd_ctl_read_unlocked (set, fd, active);

  g_mutex_unlock (&set->lock);

  return ret;
}

/**
 * gst_poll_fd_ignored:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Mark @fd as ignored so that the next call to gst_poll_wait() will yield
 * the same result for @fd as last time. This function must be called if no
 * operation (read/write/recv/send/etc.) will be performed on @fd before
 * the next call to gst_poll_wait().
 *
 * The reason why this is needed is because the underlying implementation
 * might not allow querying the fd more than once between calls to one of
 * the re-enabling operations.
 */
void
gst_poll_fd_ignored (GstPoll * set, GstPollFD * fd)
{
#ifdef G_OS_WIN32
  gint idx;

  g_return_if_fail (set != NULL);
  g_return_if_fail (fd != NULL);
  g_return_if_fail (fd->fd >= 0);

  g_mutex_lock (&set->lock);

  idx = find_index (set->fds, fd);
  if (idx >= 0) {
    WinsockFd *wfd = &g_array_index (set->fds, WinsockFd, idx);

    wfd->ignored_event_mask = wfd->event_mask & (FD_READ | FD_WRITE);
    MARK_REBUILD (set);
  }

  g_mutex_unlock (&set->lock);
#endif
}

/**
 * gst_poll_fd_has_closed:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Check if @fd in @set has closed the connection.
 *
 * Returns: %TRUE if the connection was closed.
 */
gboolean
gst_poll_fd_has_closed (const GstPoll * set, GstPollFD * fd)
{
  gboolean res = FALSE;
  gint idx;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&((GstPoll *) set)->lock);

  idx = find_index (set->active_fds, fd);
  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->active_fds, struct pollfd, idx);

    res = (pfd->revents & POLLHUP) != 0;
#else
    WinsockFd *wfd = &g_array_index (set->active_fds, WinsockFd, idx);

    res = (wfd->events.lNetworkEvents & FD_CLOSE) != 0;
#endif
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }
  g_mutex_unlock (&((GstPoll *) set)->lock);

  GST_DEBUG ("%p: fd (fd:%d, idx:%d) %d", set, fd->fd, fd->idx, res);

  return res;
}

/**
 * gst_poll_fd_has_error:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Check if @fd in @set has an error.
 *
 * Returns: %TRUE if the descriptor has an error.
 */
gboolean
gst_poll_fd_has_error (const GstPoll * set, GstPollFD * fd)
{
  gboolean res = FALSE;
  gint idx;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&((GstPoll *) set)->lock);

  idx = find_index (set->active_fds, fd);
  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->active_fds, struct pollfd, idx);

    res = (pfd->revents & (POLLERR | POLLNVAL)) != 0;
#else
    WinsockFd *wfd = &g_array_index (set->active_fds, WinsockFd, idx);

    res = (wfd->events.iErrorCode[FD_CLOSE_BIT] != 0) ||
        (wfd->events.iErrorCode[FD_READ_BIT] != 0) ||
        (wfd->events.iErrorCode[FD_WRITE_BIT] != 0) ||
        (wfd->events.iErrorCode[FD_ACCEPT_BIT] != 0) ||
        (wfd->events.iErrorCode[FD_CONNECT_BIT] != 0);
#endif
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }
  g_mutex_unlock (&((GstPoll *) set)->lock);

  GST_DEBUG ("%p: fd (fd:%d, idx:%d) %d", set, fd->fd, fd->idx, res);

  return res;
}

static gboolean
gst_poll_fd_can_read_unlocked (const GstPoll * set, GstPollFD * fd)
{
  gboolean res = FALSE;
  gint idx;

  idx = find_index (set->active_fds, fd);
  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->active_fds, struct pollfd, idx);

    res = (pfd->revents & (POLLIN | POLLPRI)) != 0;
#else
    WinsockFd *wfd = &g_array_index (set->active_fds, WinsockFd, idx);

    res = (wfd->events.lNetworkEvents & (FD_READ | FD_ACCEPT)) != 0;
#endif
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }
  GST_DEBUG ("%p: fd (fd:%d, idx:%d) %d", set, fd->fd, fd->idx, res);

  return res;
}

/**
 * gst_poll_fd_can_read:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Check if @fd in @set has data to be read.
 *
 * Returns: %TRUE if the descriptor has data to be read.
 */
gboolean
gst_poll_fd_can_read (const GstPoll * set, GstPollFD * fd)
{
  gboolean res = FALSE;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&((GstPoll *) set)->lock);

  res = gst_poll_fd_can_read_unlocked (set, fd);

  g_mutex_unlock (&((GstPoll *) set)->lock);

  return res;
}

/**
 * gst_poll_fd_can_write:
 * @set: a file descriptor set.
 * @fd: a file descriptor.
 *
 * Check if @fd in @set can be used for writing.
 *
 * Returns: %TRUE if the descriptor can be used for writing.
 */
gboolean
gst_poll_fd_can_write (const GstPoll * set, GstPollFD * fd)
{
  gboolean res = FALSE;
  gint idx;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (fd != NULL, FALSE);
  g_return_val_if_fail (fd->fd >= 0, FALSE);

  g_mutex_lock (&((GstPoll *) set)->lock);

  idx = find_index (set->active_fds, fd);
  if (idx >= 0) {
#ifndef G_OS_WIN32
    struct pollfd *pfd = &g_array_index (set->active_fds, struct pollfd, idx);

    res = (pfd->revents & POLLOUT) != 0;
#else
    WinsockFd *wfd = &g_array_index (set->active_fds, WinsockFd, idx);

    res = (wfd->events.lNetworkEvents & FD_WRITE) != 0;
#endif
  } else {
    GST_WARNING ("%p: couldn't find fd !", set);
  }
  g_mutex_unlock (&((GstPoll *) set)->lock);

  GST_DEBUG ("%p: fd (fd:%d, idx:%d) %d", set, fd->fd, fd->idx, res);

  return res;
}

/**
 * gst_poll_wait:
 * @set: a #GstPoll.
 * @timeout: a timeout in nanoseconds.
 *
 * Wait for activity on the file descriptors in @set. This function waits up to
 * the specified @timeout.  A timeout of #GST_CLOCK_TIME_NONE waits forever.
 *
 * For #GstPoll objects created with gst_poll_new(), this function can only be
 * called from a single thread at a time.  If called from multiple threads,
 * -1 will be returned with errno set to EPERM.
 *
 * This is not true for timer #GstPoll objects created with
 * gst_poll_new_timer(), where it is allowed to have multiple threads waiting
 * simultaneously.
 *
 * Returns: The number of #GstPollFD in @set that have activity or 0 when no
 * activity was detected after @timeout. If an error occurs, -1 is returned
 * and errno is set.
 */
gint
gst_poll_wait (GstPoll * set, GstClockTime timeout)
{
  gboolean restarting;
  gboolean is_timer;
  int res;
  gint old_waiting;

  g_return_val_if_fail (set != NULL, -1);

  GST_DEBUG ("%p: timeout :%" GST_TIME_FORMAT, set, GST_TIME_ARGS (timeout));

  is_timer = set->timer;

  /* add one more waiter */
  old_waiting = INC_WAITING (set);

  /* we cannot wait from multiple threads unless we are a timer */
  if (G_UNLIKELY (old_waiting > 0 && !is_timer))
    goto already_waiting;

  /* flushing, exit immediately */
  if (G_UNLIKELY (IS_FLUSHING (set)))
    goto flushing;

  do {
    GstPollMode mode;

    res = -1;
    restarting = FALSE;

    mode = choose_mode (set, timeout);

    if (TEST_REBUILD (set)) {
      g_mutex_lock (&set->lock);
#ifndef G_OS_WIN32
      g_array_set_size (set->active_fds, set->fds->len);
      memcpy (set->active_fds->data, set->fds->data,
          set->fds->len * sizeof (struct pollfd));
#else
      if (!gst_poll_prepare_winsock_active_sets (set))
        goto winsock_error;
#endif
      g_mutex_unlock (&set->lock);
    }

    switch (mode) {
      case GST_POLL_MODE_AUTO:
        g_assert_not_reached ();
        break;
      case GST_POLL_MODE_PPOLL:
      {
#ifdef HAVE_PPOLL
        struct timespec ts;
        struct timespec *tsptr;

        if (timeout != GST_CLOCK_TIME_NONE) {
          GST_TIME_TO_TIMESPEC (timeout, ts);
          tsptr = &ts;
        } else {
          tsptr = NULL;
        }

        res =
            ppoll ((struct pollfd *) set->active_fds->data,
            set->active_fds->len, tsptr, NULL);
#else
        g_assert_not_reached ();
        errno = ENOSYS;
#endif
        break;
      }
      case GST_POLL_MODE_POLL:
      {
#ifdef HAVE_POLL
        gint t;

        if (timeout != GST_CLOCK_TIME_NONE) {
          t = GST_TIME_AS_MSECONDS (timeout);
        } else {
          t = -1;
        }

        res =
            poll ((struct pollfd *) set->active_fds->data,
            set->active_fds->len, t);
#else
        g_assert_not_reached ();
        errno = ENOSYS;
#endif
        break;
      }
      case GST_POLL_MODE_PSELECT:
#ifndef HAVE_PSELECT
      {
        g_assert_not_reached ();
        errno = ENOSYS;
        break;
      }
#endif
      case GST_POLL_MODE_SELECT:
      {
#ifndef G_OS_WIN32
        fd_set readfds;
        fd_set writefds;
        fd_set errorfds;
        gint max_fd;

        max_fd = pollfd_to_fd_set (set, &readfds, &writefds, &errorfds);

        if (mode == GST_POLL_MODE_SELECT) {
          struct timeval tv;
          struct timeval *tvptr;

          if (timeout != GST_CLOCK_TIME_NONE) {
            GST_TIME_TO_TIMEVAL (timeout, tv);
            tvptr = &tv;
          } else {
            tvptr = NULL;
          }

          GST_DEBUG ("%p: Calling select", set);
          res = select (max_fd + 1, &readfds, &writefds, &errorfds, tvptr);
          GST_DEBUG ("%p: After select, res:%d", set, res);
        } else {
#ifdef HAVE_PSELECT
          struct timespec ts;
          struct timespec *tsptr;

          if (timeout != GST_CLOCK_TIME_NONE) {
            GST_TIME_TO_TIMESPEC (timeout, ts);
            tsptr = &ts;
          } else {
            tsptr = NULL;
          }

          GST_DEBUG ("%p: Calling pselect", set);
          res =
              pselect (max_fd + 1, &readfds, &writefds, &errorfds, tsptr, NULL);
          GST_DEBUG ("%p: After pselect, res:%d", set, res);
#endif
        }

        if (res >= 0) {
          fd_set_to_pollfd (set, &readfds, &writefds, &errorfds);
        }
#else /* G_OS_WIN32 */
        g_assert_not_reached ();
        errno = ENOSYS;
#endif
        break;
      }
      case GST_POLL_MODE_WINDOWS:
      {
#ifdef G_OS_WIN32
        gint ignore_count = set->active_fds_ignored->len;
        DWORD t, wait_ret;

        if (G_LIKELY (ignore_count == 0)) {
          if (timeout != GST_CLOCK_TIME_NONE)
            t = GST_TIME_AS_MSECONDS (timeout);
          else
            t = INFINITE;
        } else {
          /* already one or more ignored fds, so we quickly sweep the others */
          t = 0;
        }

        if (set->active_events->len != 0) {
          wait_ret = WSAWaitForMultipleEvents (set->active_events->len,
              (HANDLE *) set->active_events->data, FALSE, t, FALSE);
        } else {
          wait_ret = WSA_WAIT_FAILED;
          WSASetLastError (WSA_INVALID_PARAMETER);
        }

        if (ignore_count == 0 && wait_ret == WSA_WAIT_TIMEOUT) {
          res = 0;
        } else if (wait_ret == WSA_WAIT_FAILED) {
          res = -1;
          errno = gst_poll_winsock_error_to_errno (WSAGetLastError ());
        } else {
          /* the first entry is the wakeup event */
          if (wait_ret - WSA_WAIT_EVENT_0 >= 1) {
            res = gst_poll_collect_winsock_events (set);
          } else {
            res = 1;            /* wakeup event */
          }
        }
#else
        g_assert_not_reached ();
        errno = ENOSYS;
#endif
        break;
      }
    }

    if (!is_timer) {
      /* Applications needs to clear the control socket themselves for timer
       * polls.
       * For other polls, we need to clear the control socket. If there was only
       * one socket with activity and it was the control socket, we need to
       * restart */
      if (release_all_wakeup (set) > 0 && res == 1)
        restarting = TRUE;
    }

    /* we got woken up and we are flushing, we need to stop */
    if (G_UNLIKELY (IS_FLUSHING (set)))
      goto flushing;

  } while (G_UNLIKELY (restarting));

  DEC_WAITING (set);

  return res;

  /* ERRORS */
already_waiting:
  {
    GST_LOG ("%p: we are already waiting", set);
    DEC_WAITING (set);
    errno = EPERM;
    return -1;
  }
flushing:
  {
    GST_LOG ("%p: we are flushing", set);
    DEC_WAITING (set);
    errno = EBUSY;
    return -1;
  }
#ifdef G_OS_WIN32
winsock_error:
  {
    GST_LOG ("%p: winsock error", set);
    g_mutex_unlock (&set->lock);
    DEC_WAITING (set);
    return -1;
  }
#endif
}

/**
 * gst_poll_set_controllable:
 * @set: a #GstPoll.
 * @controllable: new controllable state.
 *
 * When @controllable is %TRUE, this function ensures that future calls to
 * gst_poll_wait() will be affected by gst_poll_restart() and
 * gst_poll_set_flushing().
 *
 * Returns: %TRUE if the controllability of @set could be updated.
 */
gboolean
gst_poll_set_controllable (GstPoll * set, gboolean controllable)
{
  g_return_val_if_fail (set != NULL, FALSE);

  GST_LOG ("%p: controllable : %d", set, controllable);

  set->controllable = controllable;

  return TRUE;
}

/**
 * gst_poll_restart:
 * @set: a #GstPoll.
 *
 * Restart any gst_poll_wait() that is in progress. This function is typically
 * used after adding or removing descriptors to @set.
 *
 * If @set is not controllable, then this call will have no effect.
 */
void
gst_poll_restart (GstPoll * set)
{
  g_return_if_fail (set != NULL);

  if (set->controllable && GET_WAITING (set) > 0) {
    /* we are controllable and waiting, wake up the waiter. The socket will be
     * cleared by the _wait() thread and the poll will be restarted */
    raise_wakeup (set);
  }
}

/**
 * gst_poll_set_flushing:
 * @set: a #GstPoll.
 * @flushing: new flushing state.
 *
 * When @flushing is %TRUE, this function ensures that current and future calls
 * to gst_poll_wait() will return -1, with errno set to EBUSY.
 *
 * Unsetting the flushing state will restore normal operation of @set.
 */
void
gst_poll_set_flushing (GstPoll * set, gboolean flushing)
{
  g_return_if_fail (set != NULL);

  GST_LOG ("%p: flushing: %d", set, flushing);

  /* update the new state first */
  SET_FLUSHING (set, flushing);

  if (flushing && set->controllable && GET_WAITING (set) > 0) {
    /* we are flushing, controllable and waiting, wake up the waiter. When we
     * stop the flushing operation we don't clear the wakeup fd here, this will
     * happen in the _wait() thread. */
    raise_wakeup (set);
  }
}

/**
 * gst_poll_write_control:
 * @set: a #GstPoll.
 *
 * Write a byte to the control socket of the controllable @set.
 * This function is mostly useful for timer #GstPoll objects created with
 * gst_poll_new_timer(). 
 *
 * It will make any current and future gst_poll_wait() function return with
 * 1, meaning the control socket is set. After an equal amount of calls to
 * gst_poll_read_control() have been performed, calls to gst_poll_wait() will
 * block again until their timeout expired.
 *
 * Returns: %TRUE on success. %FALSE when @set is not controllable or when the
 * byte could not be written.
 */
gboolean
gst_poll_write_control (GstPoll * set)
{
  gboolean res;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (set->timer, FALSE);

  res = raise_wakeup (set);

  return res;
}

/**
 * gst_poll_read_control:
 * @set: a #GstPoll.
 *
 * Read a byte from the control socket of the controllable @set.
 * This function is mostly useful for timer #GstPoll objects created with
 * gst_poll_new_timer(). 
 *
 * Returns: %TRUE on success. %FALSE when @set is not controllable or when there
 * was no byte to read.
 */
gboolean
gst_poll_read_control (GstPoll * set)
{
  gboolean res;

  g_return_val_if_fail (set != NULL, FALSE);
  g_return_val_if_fail (set->timer, FALSE);

  res = release_wakeup (set);

  return res;
}
