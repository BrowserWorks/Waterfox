/*
 * Copyright (c) 2009, Giampaolo Rodola'. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Linux-specific functions.
 */

#ifndef _GNU_SOURCE
    #define _GNU_SOURCE 1
#endif
#include <Python.h>
#include <errno.h>
#include <stdlib.h>
#include <mntent.h>
#include <features.h>
#include <utmp.h>
#include <sched.h>
#include <linux/version.h>
#include <sys/syscall.h>
#include <sys/sysinfo.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/sockios.h>
#include <linux/if.h>

// see: https://github.com/giampaolo/psutil/issues/659
#ifdef PSUTIL_ETHTOOL_MISSING_TYPES
    #include <linux/types.h>
    typedef __u64 u64;
    typedef __u32 u32;
    typedef __u16 u16;
    typedef __u8 u8;
#endif
/* Avoid redefinition of struct sysinfo with musl libc */
#define _LINUX_SYSINFO_H
#include <linux/ethtool.h>

/* The minimum number of CPUs allocated in a cpu_set_t */
static const int NCPUS_START = sizeof(unsigned long) * CHAR_BIT;

// Linux >= 2.6.13
#define PSUTIL_HAVE_IOPRIO defined(__NR_ioprio_get) && defined(__NR_ioprio_set)

// Linux >= 2.6.36 (supposedly) and glibc >= 13
#define PSUTIL_HAVE_PRLIMIT \
    (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 36)) && \
    (__GLIBC__ >= 2 && __GLIBC_MINOR__ >= 13) && \
    defined(__NR_prlimit64)

#if PSUTIL_HAVE_PRLIMIT
    #define _FILE_OFFSET_BITS 64
    #include <time.h>
    #include <sys/resource.h>
#endif

// Should exist starting from CentOS 6 (year 2011).
#ifdef CPU_ALLOC
    #define PSUTIL_HAVE_CPU_AFFINITY
#endif

#include "_psutil_common.h"
#include "_psutil_posix.h"

// May happen on old RedHat versions, see:
// https://github.com/giampaolo/psutil/issues/607
#ifndef DUPLEX_UNKNOWN
    #define DUPLEX_UNKNOWN 0xff
#endif


#if PSUTIL_HAVE_IOPRIO
enum {
    IOPRIO_WHO_PROCESS = 1,
};

static inline int
ioprio_get(int which, int who) {
    return syscall(__NR_ioprio_get, which, who);
}

static inline int
ioprio_set(int which, int who, int ioprio) {
    return syscall(__NR_ioprio_set, which, who, ioprio);
}

#define IOPRIO_CLASS_SHIFT 13
#define IOPRIO_PRIO_MASK ((1UL << IOPRIO_CLASS_SHIFT) - 1)

#define IOPRIO_PRIO_CLASS(mask) ((mask) >> IOPRIO_CLASS_SHIFT)
#define IOPRIO_PRIO_DATA(mask) ((mask) & IOPRIO_PRIO_MASK)
#define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | data)


/*
 * Return a (ioclass, iodata) Python tuple representing process I/O priority.
 */
static PyObject *
psutil_proc_ioprio_get(PyObject *self, PyObject *args) {
    pid_t pid;
    int ioprio, ioclass, iodata;
    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    ioprio = ioprio_get(IOPRIO_WHO_PROCESS, pid);
    if (ioprio == -1)
        return PyErr_SetFromErrno(PyExc_OSError);
    ioclass = IOPRIO_PRIO_CLASS(ioprio);
    iodata = IOPRIO_PRIO_DATA(ioprio);
    return Py_BuildValue("ii", ioclass, iodata);
}


/*
 * A wrapper around ioprio_set(); sets process I/O priority.
 * ioclass can be either IOPRIO_CLASS_RT, IOPRIO_CLASS_BE, IOPRIO_CLASS_IDLE
 * or 0. iodata goes from 0 to 7 depending on ioclass specified.
 */
static PyObject *
psutil_proc_ioprio_set(PyObject *self, PyObject *args) {
    pid_t pid;
    int ioprio, ioclass, iodata;
    int retval;

    if (! PyArg_ParseTuple(
            args, _Py_PARSE_PID "ii", &pid, &ioclass, &iodata)) {
        return NULL;
    }
    ioprio = IOPRIO_PRIO_VALUE(ioclass, iodata);
    retval = ioprio_set(IOPRIO_WHO_PROCESS, pid, ioprio);
    if (retval == -1)
        return PyErr_SetFromErrno(PyExc_OSError);
    Py_RETURN_NONE;
}
#endif


#if PSUTIL_HAVE_PRLIMIT
/*
 * A wrapper around prlimit(2); sets process resource limits.
 * This can be used for both get and set, in which case extra
 * 'soft' and 'hard' args must be provided.
 */
static PyObject *
psutil_linux_prlimit(PyObject *self, PyObject *args) {
    pid_t pid;
    int ret, resource;
    struct rlimit old, new;
    struct rlimit *newp = NULL;
    PyObject *py_soft = NULL;
    PyObject *py_hard = NULL;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID "i|OO", &pid, &resource,
                           &py_soft, &py_hard)) {
        return NULL;
    }

    // get
    if (py_soft == NULL && py_hard == NULL) {
        ret = prlimit(pid, resource, NULL, &old);
        if (ret == -1)
            return PyErr_SetFromErrno(PyExc_OSError);
#if defined(PSUTIL_HAVE_LONG_LONG)
        if (sizeof(old.rlim_cur) > sizeof(long)) {
            return Py_BuildValue("LL",
                                 (PY_LONG_LONG)old.rlim_cur,
                                 (PY_LONG_LONG)old.rlim_max);
        }
#endif
        return Py_BuildValue("ll", (long)old.rlim_cur, (long)old.rlim_max);
    }

    // set
    else {
#if defined(PSUTIL_HAVE_LARGEFILE_SUPPORT)
        new.rlim_cur = PyLong_AsLongLong(py_soft);
        if (new.rlim_cur == (rlim_t) - 1 && PyErr_Occurred())
            return NULL;
        new.rlim_max = PyLong_AsLongLong(py_hard);
        if (new.rlim_max == (rlim_t) - 1 && PyErr_Occurred())
            return NULL;
#else
        new.rlim_cur = PyLong_AsLong(py_soft);
        if (new.rlim_cur == (rlim_t) - 1 && PyErr_Occurred())
            return NULL;
        new.rlim_max = PyLong_AsLong(py_hard);
        if (new.rlim_max == (rlim_t) - 1 && PyErr_Occurred())
            return NULL;
#endif
        newp = &new;
        ret = prlimit(pid, resource, newp, &old);
        if (ret == -1)
            return PyErr_SetFromErrno(PyExc_OSError);
        Py_RETURN_NONE;
    }
}
#endif


/*
 * Return disk mounted partitions as a list of tuples including device,
 * mount point and filesystem type
 */
static PyObject *
psutil_disk_partitions(PyObject *self, PyObject *args) {
    FILE *file = NULL;
    struct mntent *entry;
    char *mtab_path;
    PyObject *py_dev = NULL;
    PyObject *py_mountp = NULL;
    PyObject *py_tuple = NULL;
    PyObject *py_retlist = PyList_New(0);

    if (py_retlist == NULL)
        return NULL;

    if (!PyArg_ParseTuple(args, "s", &mtab_path))
        return NULL;

    Py_BEGIN_ALLOW_THREADS
    file = setmntent(mtab_path, "r");
    Py_END_ALLOW_THREADS
    if ((file == 0) || (file == NULL)) {
        psutil_debug("setmntent() failed");
        PyErr_SetFromErrnoWithFilename(PyExc_OSError, mtab_path);
        goto error;
    }

    while ((entry = getmntent(file))) {
        if (entry == NULL) {
            PyErr_Format(PyExc_RuntimeError, "getmntent() syscall failed");
            goto error;
        }
        py_dev = PyUnicode_DecodeFSDefault(entry->mnt_fsname);
        if (! py_dev)
            goto error;
        py_mountp = PyUnicode_DecodeFSDefault(entry->mnt_dir);
        if (! py_mountp)
            goto error;
        py_tuple = Py_BuildValue("(OOss)",
                                 py_dev,             // device
                                 py_mountp,          // mount point
                                 entry->mnt_type,    // fs type
                                 entry->mnt_opts);   // options
        if (! py_tuple)
            goto error;
        if (PyList_Append(py_retlist, py_tuple))
            goto error;
        Py_CLEAR(py_dev);
        Py_CLEAR(py_mountp);
        Py_CLEAR(py_tuple);
    }
    endmntent(file);
    return py_retlist;

error:
    if (file != NULL)
        endmntent(file);
    Py_XDECREF(py_dev);
    Py_XDECREF(py_mountp);
    Py_XDECREF(py_tuple);
    Py_DECREF(py_retlist);
    return NULL;
}


/*
 * A wrapper around sysinfo(), return system memory usage statistics.
 */
static PyObject *
psutil_linux_sysinfo(PyObject *self, PyObject *args) {
    struct sysinfo info;

    if (sysinfo(&info) != 0)
        return PyErr_SetFromErrno(PyExc_OSError);
    // note: boot time might also be determined from here
    return Py_BuildValue(
        "(kkkkkkI)",
        info.totalram,  // total
        info.freeram,  // free
        info.bufferram, // buffer
        info.sharedram, // shared
        info.totalswap, // swap tot
        info.freeswap,  // swap free
        info.mem_unit  // multiplier
    );
}


/*
 * Return process CPU affinity as a Python list
 */
#ifdef PSUTIL_HAVE_CPU_AFFINITY

static PyObject *
psutil_proc_cpu_affinity_get(PyObject *self, PyObject *args) {
    int cpu, ncpus, count, cpucount_s;
    pid_t pid;
    size_t setsize;
    cpu_set_t *mask = NULL;
    PyObject *py_list = NULL;

    if (!PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    ncpus = NCPUS_START;
    while (1) {
        setsize = CPU_ALLOC_SIZE(ncpus);
        mask = CPU_ALLOC(ncpus);
        if (mask == NULL) {
            psutil_debug("CPU_ALLOC() failed");
            return PyErr_NoMemory();
        }
        if (sched_getaffinity(pid, setsize, mask) == 0)
            break;
        CPU_FREE(mask);
        if (errno != EINVAL)
            return PyErr_SetFromErrno(PyExc_OSError);
        if (ncpus > INT_MAX / 2) {
            PyErr_SetString(PyExc_OverflowError, "could not allocate "
                            "a large enough CPU set");
            return NULL;
        }
        ncpus = ncpus * 2;
    }

    py_list = PyList_New(0);
    if (py_list == NULL)
        goto error;

    cpucount_s = CPU_COUNT_S(setsize, mask);
    for (cpu = 0, count = cpucount_s; count; cpu++) {
        if (CPU_ISSET_S(cpu, setsize, mask)) {
#if PY_MAJOR_VERSION >= 3
            PyObject *cpu_num = PyLong_FromLong(cpu);
#else
            PyObject *cpu_num = PyInt_FromLong(cpu);
#endif
            if (cpu_num == NULL)
                goto error;
            if (PyList_Append(py_list, cpu_num)) {
                Py_DECREF(cpu_num);
                goto error;
            }
            Py_DECREF(cpu_num);
            --count;
        }
    }
    CPU_FREE(mask);
    return py_list;

error:
    if (mask)
        CPU_FREE(mask);
    Py_XDECREF(py_list);
    return NULL;
}


/*
 * Set process CPU affinity; expects a bitmask
 */
static PyObject *
psutil_proc_cpu_affinity_set(PyObject *self, PyObject *args) {
    cpu_set_t cpu_set;
    size_t len;
    pid_t pid;
    int i, seq_len;
    PyObject *py_cpu_set;
    PyObject *py_cpu_seq = NULL;

    if (!PyArg_ParseTuple(args, _Py_PARSE_PID "O", &pid, &py_cpu_set))
        return NULL;

    if (!PySequence_Check(py_cpu_set)) {
        PyErr_Format(PyExc_TypeError, "sequence argument expected, got %s",
                     Py_TYPE(py_cpu_set)->tp_name);
        goto error;
    }

    py_cpu_seq = PySequence_Fast(py_cpu_set, "expected a sequence or integer");
    if (!py_cpu_seq)
        goto error;
    seq_len = PySequence_Fast_GET_SIZE(py_cpu_seq);
    CPU_ZERO(&cpu_set);
    for (i = 0; i < seq_len; i++) {
        PyObject *item = PySequence_Fast_GET_ITEM(py_cpu_seq, i);
#if PY_MAJOR_VERSION >= 3
        long value = PyLong_AsLong(item);
#else
        long value = PyInt_AsLong(item);
#endif
        if ((value == -1) || PyErr_Occurred()) {
            if (!PyErr_Occurred())
                PyErr_SetString(PyExc_ValueError, "invalid CPU value");
            goto error;
        }
        CPU_SET(value, &cpu_set);
    }

    len = sizeof(cpu_set);
    if (sched_setaffinity(pid, len, &cpu_set)) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    Py_DECREF(py_cpu_seq);
    Py_RETURN_NONE;

error:
    if (py_cpu_seq != NULL)
        Py_DECREF(py_cpu_seq);
    return NULL;
}
#endif  /* PSUTIL_HAVE_CPU_AFFINITY */


/*
 * Return currently connected users as a list of tuples.
 */
static PyObject *
psutil_users(PyObject *self, PyObject *args) {
    struct utmp *ut;
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_tuple = NULL;
    PyObject *py_username = NULL;
    PyObject *py_tty = NULL;
    PyObject *py_hostname = NULL;
    PyObject *py_user_proc = NULL;

    if (py_retlist == NULL)
        return NULL;
    setutent();
    while (NULL != (ut = getutent())) {
        py_tuple = NULL;
        py_user_proc = NULL;
        if (ut->ut_type == USER_PROCESS)
            py_user_proc = Py_True;
        else
            py_user_proc = Py_False;
        py_username = PyUnicode_DecodeFSDefault(ut->ut_user);
        if (! py_username)
            goto error;
        py_tty = PyUnicode_DecodeFSDefault(ut->ut_line);
        if (! py_tty)
            goto error;
        py_hostname = PyUnicode_DecodeFSDefault(ut->ut_host);
        if (! py_hostname)
            goto error;

        py_tuple = Py_BuildValue(
            "OOOfO" _Py_PARSE_PID,
            py_username,              // username
            py_tty,                   // tty
            py_hostname,              // hostname
            (float)ut->ut_tv.tv_sec,  // tstamp
            py_user_proc,             // (bool) user process
            ut->ut_pid                // process id
        );
        if (! py_tuple)
            goto error;
        if (PyList_Append(py_retlist, py_tuple))
            goto error;
        Py_CLEAR(py_username);
        Py_CLEAR(py_tty);
        Py_CLEAR(py_hostname);
        Py_CLEAR(py_tuple);
    }
    endutent();
    return py_retlist;

error:
    Py_XDECREF(py_username);
    Py_XDECREF(py_tty);
    Py_XDECREF(py_hostname);
    Py_XDECREF(py_tuple);
    Py_DECREF(py_retlist);
    endutent();
    return NULL;
}


/*
 * Return stats about a particular network
 * interface.  References:
 * https://github.com/dpaleino/wicd/blob/master/wicd/backends/be-ioctl.py
 * http://www.i-scream.org/libstatgrab/
 */
static PyObject*
psutil_net_if_duplex_speed(PyObject* self, PyObject* args) {
    char *nic_name;
    int sock = 0;
    int ret;
    int duplex;
    int speed;
    struct ifreq ifr;
    struct ethtool_cmd ethcmd;
    PyObject *py_retlist = NULL;

    if (! PyArg_ParseTuple(args, "s", &nic_name))
        return NULL;

    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == -1)
        return PyErr_SetFromOSErrnoWithSyscall("socket()");
    strncpy(ifr.ifr_name, nic_name, sizeof(ifr.ifr_name));

    // duplex and speed
    memset(&ethcmd, 0, sizeof ethcmd);
    ethcmd.cmd = ETHTOOL_GSET;
    ifr.ifr_data = (void *)&ethcmd;
    ret = ioctl(sock, SIOCETHTOOL, &ifr);

    if (ret != -1) {
        duplex = ethcmd.duplex;
        speed = ethcmd.speed;
    }
    else {
        if ((errno == EOPNOTSUPP) || (errno == EINVAL)) {
            // EOPNOTSUPP may occur in case of wi-fi cards.
            // For EINVAL see:
            // https://github.com/giampaolo/psutil/issues/797
            //     #issuecomment-202999532
            duplex = DUPLEX_UNKNOWN;
            speed = 0;
        }
        else {
            PyErr_SetFromOSErrnoWithSyscall("ioctl(SIOCETHTOOL)");
            goto error;
        }
    }

    py_retlist = Py_BuildValue("[ii]", duplex, speed);
    if (!py_retlist)
        goto error;
    close(sock);
    return py_retlist;

error:
    if (sock != -1)
        close(sock);
    return NULL;
}


/*
 * Module init.
 */

static PyMethodDef mod_methods[] = {
    // --- per-process functions

#if PSUTIL_HAVE_IOPRIO
    {"proc_ioprio_get", psutil_proc_ioprio_get, METH_VARARGS,
     "Get process I/O priority"},
    {"proc_ioprio_set", psutil_proc_ioprio_set, METH_VARARGS,
     "Set process I/O priority"},
#endif
#ifdef PSUTIL_HAVE_CPU_AFFINITY
    {"proc_cpu_affinity_get", psutil_proc_cpu_affinity_get, METH_VARARGS,
     "Return process CPU affinity as a Python long (the bitmask)."},
    {"proc_cpu_affinity_set", psutil_proc_cpu_affinity_set, METH_VARARGS,
     "Set process CPU affinity; expects a bitmask."},
#endif

    // --- system related functions

    {"disk_partitions", psutil_disk_partitions, METH_VARARGS,
     "Return disk mounted partitions as a list of tuples including "
     "device, mount point and filesystem type"},
    {"users", psutil_users, METH_VARARGS,
     "Return currently connected users as a list of tuples"},
    {"net_if_duplex_speed", psutil_net_if_duplex_speed, METH_VARARGS,
     "Return duplex and speed info about a NIC"},

    // --- linux specific

    {"linux_sysinfo", psutil_linux_sysinfo, METH_VARARGS,
     "A wrapper around sysinfo(), return system memory usage statistics"},
#if PSUTIL_HAVE_PRLIMIT
    {"linux_prlimit", psutil_linux_prlimit, METH_VARARGS,
     "Get or set process resource limits."},
#endif
    // --- others
    {"set_testing", psutil_set_testing, METH_NOARGS,
     "Set psutil in testing mode"},

    {NULL, NULL, 0, NULL}
};


#if PY_MAJOR_VERSION >= 3
    #define INITERR return NULL

    static struct PyModuleDef moduledef = {
        PyModuleDef_HEAD_INIT,
        "_psutil_linux",
        NULL,
        -1,
        mod_methods,
        NULL,
        NULL,
        NULL,
        NULL
    };

    PyObject *PyInit__psutil_linux(void)
#else  /* PY_MAJOR_VERSION */
    #define INITERR return

    void init_psutil_linux(void)
#endif  /* PY_MAJOR_VERSION */
{
    PyObject *v;
#if PY_MAJOR_VERSION >= 3
    PyObject *mod = PyModule_Create(&moduledef);
#else
    PyObject *mod = Py_InitModule("_psutil_linux", mod_methods);
#endif
    if (mod == NULL)
        INITERR;

    if (PyModule_AddIntConstant(mod, "version", PSUTIL_VERSION)) INITERR;
#if PSUTIL_HAVE_PRLIMIT
    if (PyModule_AddIntConstant(mod, "RLIMIT_AS", RLIMIT_AS)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_CORE", RLIMIT_CORE)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_CPU", RLIMIT_CPU)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_DATA", RLIMIT_DATA)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_FSIZE", RLIMIT_FSIZE)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_LOCKS", RLIMIT_LOCKS)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_MEMLOCK", RLIMIT_MEMLOCK)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_NOFILE", RLIMIT_NOFILE)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_NPROC", RLIMIT_NPROC)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_RSS", RLIMIT_RSS)) INITERR;
    if (PyModule_AddIntConstant(mod, "RLIMIT_STACK", RLIMIT_STACK)) INITERR;

#if defined(HAVE_LONG_LONG)
    if (sizeof(RLIM_INFINITY) > sizeof(long)) {
        v = PyLong_FromLongLong((PY_LONG_LONG) RLIM_INFINITY);
    } else
#endif
    {
        v = PyLong_FromLong((long) RLIM_INFINITY);
    }
    if (v) {
        PyModule_AddObject(mod, "RLIM_INFINITY", v);
    }

#ifdef RLIMIT_MSGQUEUE
    if (PyModule_AddIntConstant(mod, "RLIMIT_MSGQUEUE", RLIMIT_MSGQUEUE)) INITERR;
#endif
#ifdef RLIMIT_NICE
    if (PyModule_AddIntConstant(mod, "RLIMIT_NICE", RLIMIT_NICE)) INITERR;
#endif
#ifdef RLIMIT_RTPRIO
    if (PyModule_AddIntConstant(mod, "RLIMIT_RTPRIO", RLIMIT_RTPRIO)) INITERR;
#endif
#ifdef RLIMIT_RTTIME
    if (PyModule_AddIntConstant(mod, "RLIMIT_RTTIME", RLIMIT_RTTIME)) INITERR;
#endif
#ifdef RLIMIT_SIGPENDING
    if (PyModule_AddIntConstant(mod, "RLIMIT_SIGPENDING", RLIMIT_SIGPENDING))
        INITERR;
#endif
#endif
    if (PyModule_AddIntConstant(mod, "DUPLEX_HALF", DUPLEX_HALF)) INITERR;
    if (PyModule_AddIntConstant(mod, "DUPLEX_FULL", DUPLEX_FULL)) INITERR;
    if (PyModule_AddIntConstant(mod, "DUPLEX_UNKNOWN", DUPLEX_UNKNOWN)) INITERR;

    if (mod == NULL)
        INITERR;
#if PY_MAJOR_VERSION >= 3
    return mod;
#endif
}
