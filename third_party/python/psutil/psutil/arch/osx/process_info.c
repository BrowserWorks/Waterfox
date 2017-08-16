/*
 * Copyright (c) 2009, Jay Loden, Giampaolo Rodola'. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Helper functions related to fetching process information.
 * Used by _psutil_osx module methods.
 */


#include <Python.h>
#include <assert.h>
#include <errno.h>
#include <limits.h>  // for INT_MAX
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <sys/sysctl.h>
#include <libproc.h>

#include "process_info.h"
#include "../../_psutil_common.h"


/*
 * Return 1 if PID exists in the current process list, else 0.
 */
int
psutil_pid_exists(long pid)
{
    int kill_ret;

    // save some time if it's an invalid PID
    if (pid < 0)
        return 0;
    // if kill returns success of permission denied we know it's a valid PID
    kill_ret = kill(pid , 0);
    if ( (0 == kill_ret) || (EPERM == errno))
        return 1;

    // otherwise return 0 for PID not found
    return 0;
}


/*
 * Returns a list of all BSD processes on the system.  This routine
 * allocates the list and puts it in *procList and a count of the
 * number of entries in *procCount.  You are responsible for freeing
 * this list (use "free" from System framework).
 * On success, the function returns 0.
 * On error, the function returns a BSD errno value.
 */
int
psutil_get_proc_list(kinfo_proc **procList, size_t *procCount)
{
    // Declaring mib as const requires use of a cast since the
    // sysctl prototype doesn't include the const modifier.
    static const int mib3[3] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL };
    size_t           size, size2;
    void            *ptr;
    int              err, lim = 8;  // some limit

    assert( procList != NULL);
    assert(*procList == NULL);
    assert(procCount != NULL);

    *procCount = 0;

    /*
     * We start by calling sysctl with ptr == NULL and size == 0.
     * That will succeed, and set size to the appropriate length.
     * We then allocate a buffer of at least that size and call
     * sysctl with that buffer.  If that succeeds, we're done.
     * If that call fails with ENOMEM, we throw the buffer away
     * and try again.
     * Note that the loop calls sysctl with NULL again.  This is
     * is necessary because the ENOMEM failure case sets size to
     * the amount of data returned, not the amount of data that
     * could have been returned.
     */
    while (lim-- > 0) {
        size = 0;
        if (sysctl((int *)mib3, 3, NULL, &size, NULL, 0) == -1)
            return errno;
        size2 = size + (size >> 3);  // add some
        if (size2 > size) {
            ptr = malloc(size2);
            if (ptr == NULL)
                ptr = malloc(size);
            else
                size = size2;
        }
        else {
            ptr = malloc(size);
        }
        if (ptr == NULL)
            return ENOMEM;

        if (sysctl((int *)mib3, 3, ptr, &size, NULL, 0) == -1) {
            err = errno;
            free(ptr);
            if (err != ENOMEM)
                return err;
        }
        else {
            *procList = (kinfo_proc *)ptr;
            *procCount = size / sizeof(kinfo_proc);
            return 0;
        }
    }
    return ENOMEM;
}


// Read the maximum argument size for processes
int
psutil_get_argmax()
{
    int argmax;
    int mib[] = { CTL_KERN, KERN_ARGMAX };
    size_t size = sizeof(argmax);

    if (sysctl(mib, 2, &argmax, &size, NULL, 0) == 0)
        return argmax;
    return 0;
}


// return process args as a python list
PyObject *
psutil_get_arg_list(long pid)
{
    int mib[3];
    int nargs;
    int len;
    char *procargs = NULL;
    char *arg_ptr;
    char *arg_end;
    char *curr_arg;
    size_t argmax;
    PyObject *arg = NULL;
    PyObject *arglist = NULL;

    // special case for PID 0 (kernel_task) where cmdline cannot be fetched
    if (pid == 0)
        return Py_BuildValue("[]");

    // read argmax and allocate memory for argument space.
    argmax = psutil_get_argmax();
    if (! argmax) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    procargs = (char *)malloc(argmax);
    if (NULL == procargs) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    // read argument space
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROCARGS2;
    mib[2] = pid;
    if (sysctl(mib, 3, procargs, &argmax, NULL, 0) < 0) {
        if (EINVAL == errno) {
            // EINVAL == access denied OR nonexistent PID
            if (psutil_pid_exists(pid))
                AccessDenied();
            else
                NoSuchProcess();
        }
        goto error;
    }

    arg_end = &procargs[argmax];
    // copy the number of arguments to nargs
    memcpy(&nargs, procargs, sizeof(nargs));

    arg_ptr = procargs + sizeof(nargs);
    len = strlen(arg_ptr);
    arg_ptr += len + 1;

    if (arg_ptr == arg_end) {
        free(procargs);
        return Py_BuildValue("[]");
    }

    // skip ahead to the first argument
    for (; arg_ptr < arg_end; arg_ptr++) {
        if (*arg_ptr != '\0')
            break;
    }

    // iterate through arguments
    curr_arg = arg_ptr;
    arglist = Py_BuildValue("[]");
    if (!arglist)
        goto error;
    while (arg_ptr < arg_end && nargs > 0) {
        if (*arg_ptr++ == '\0') {
            arg = Py_BuildValue("s", curr_arg);
            if (!arg)
                goto error;
            if (PyList_Append(arglist, arg))
                goto error;
            Py_DECREF(arg);
            // iterate to next arg and decrement # of args
            curr_arg = arg_ptr;
            nargs--;
        }
    }

    free(procargs);
    return arglist;

error:
    Py_XDECREF(arg);
    Py_XDECREF(arglist);
    if (procargs != NULL)
        free(procargs);
    return NULL;
}


int
psutil_get_kinfo_proc(pid_t pid, struct kinfo_proc *kp)
{
    int mib[4];
    size_t len;
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = pid;

    // fetch the info with sysctl()
    len = sizeof(struct kinfo_proc);

    // now read the data from sysctl
    if (sysctl(mib, 4, kp, &len, NULL, 0) == -1) {
        // raise an exception and throw errno as the error
        PyErr_SetFromErrno(PyExc_OSError);
        return -1;
    }

    // sysctl succeeds but len is zero, happens when process has gone away
    if (len == 0) {
        NoSuchProcess();
        return -1;
    }
    return 0;
}


/*
 * A thin wrapper around proc_pidinfo()
 */
int
psutil_proc_pidinfo(long pid, int flavor, void *pti, int size)
{
    int ret = proc_pidinfo((int)pid, flavor, 0, pti, size);
    if (ret == 0) {
        if (! psutil_pid_exists(pid)) {
            NoSuchProcess();
            return 0;
        }
        else {
            AccessDenied();
            return 0;
        }
    }
    else if (ret != size) {
        AccessDenied();
        return 0;
    }
    else {
        return 1;
    }
}
