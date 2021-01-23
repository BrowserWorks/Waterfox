/*
 * Copyright (c) 2009, Jay Loden, Giampaolo Rodola'. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Helper functions specific to FreeBSD.
 * Used by _psutil_bsd module methods.
 */

#include <Python.h>
#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/param.h>
#include <sys/user.h>
#include <sys/proc.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/vmmeter.h>  // needed for vmtotal struct
#include <devstat.h>  // for swap mem
#include <libutil.h>  // process open files, shared libs (kinfo_getvmmap), cwd
#include <sys/cpuset.h>

#include "../../_psutil_common.h"
#include "../../_psutil_posix.h"


#define PSUTIL_TV2DOUBLE(t)    ((t).tv_sec + (t).tv_usec / 1000000.0)
#define PSUTIL_BT2MSEC(bt) (bt.sec * 1000 + (((uint64_t) 1000000000 * (uint32_t) \
        (bt.frac >> 32) ) >> 32 ) / 1000000)
#define DECIKELVIN_2_CELCIUS(t) (t - 2731) / 10
#ifndef _PATH_DEVNULL
#define _PATH_DEVNULL "/dev/null"
#endif


// ============================================================================
// Utility functions
// ============================================================================


int
psutil_kinfo_proc(pid_t pid, struct kinfo_proc *proc) {
    // Fills a kinfo_proc struct based on process pid.
    int mib[4];
    size_t size;
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = pid;

    size = sizeof(struct kinfo_proc);
    if (sysctl((int *)mib, 4, proc, &size, NULL, 0) == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl(KERN_PROC_PID)");
        return -1;
    }

    // sysctl stores 0 in the size if we can't find the process information.
    if (size == 0) {
        NoSuchProcess("sysctl (size = 0)");
        return -1;
    }
    return 0;
}


// remove spaces from string
static void psutil_remove_spaces(char *str) {
    char *p1 = str;
    char *p2 = str;
    do
        while (*p2 == ' ')
            p2++;
    while ((*p1++ = *p2++));
}


// ============================================================================
// APIS
// ============================================================================

int
psutil_get_proc_list(struct kinfo_proc **procList, size_t *procCount) {
    // Returns a list of all BSD processes on the system.  This routine
    // allocates the list and puts it in *procList and a count of the
    // number of entries in *procCount.  You are responsible for freeing
    // this list. On success returns 0, else 1 with exception set.
    int err;
    struct kinfo_proc *buf = NULL;
    int name[] = { CTL_KERN, KERN_PROC, KERN_PROC_PROC, 0 };
    size_t length = 0;

    assert(procList != NULL);
    assert(*procList == NULL);
    assert(procCount != NULL);

    // Call sysctl with a NULL buffer in order to get buffer length.
    err = sysctl(name, 3, NULL, &length, NULL, 0);
    if (err == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl (null buffer)");
        return 1;
    }

    // Allocate an appropriately sized buffer based on the results
    // from the previous call.
    buf = malloc(length);
    if (buf == NULL) {
        PyErr_NoMemory();
        return 1;
    }

    // Call sysctl again with the new buffer.
    err = sysctl(name, 3, buf, &length, NULL, 0);
    if (err == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl");
        free(buf);
        return 1;
    }

    *procList = buf;
    *procCount = length / sizeof(struct kinfo_proc);
    return 0;
}


/*
 * XXX no longer used; it probably makese sense to remove it.
 * Borrowed from psi Python System Information project
 *
 * Get command arguments and environment variables.
 *
 * Based on code from ps.
 *
 * Returns:
 *      0 for success;
 *      -1 for failure (Exception raised);
 *      1 for insufficient privileges.
 */
static char
*psutil_get_cmd_args(pid_t pid, size_t *argsize) {
    int mib[4];
    int argmax;
    size_t size = sizeof(argmax);
    char *procargs = NULL;

    // Get the maximum process arguments size.
    mib[0] = CTL_KERN;
    mib[1] = KERN_ARGMAX;

    size = sizeof(argmax);
    if (sysctl(mib, 2, &argmax, &size, NULL, 0) == -1)
        return NULL;

    // Allocate space for the arguments.
    procargs = (char *)malloc(argmax);
    if (procargs == NULL) {
        PyErr_NoMemory();
        return NULL;
    }

    // Make a sysctl() call to get the raw argument space of the process.
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_ARGS;
    mib[3] = pid;

    size = argmax;
    if (sysctl(mib, 4, procargs, &size, NULL, 0) == -1) {
        free(procargs);
        PyErr_SetFromOSErrnoWithSyscall("sysctl(KERN_PROC_ARGS)");
        return NULL;
    }

    // return string and set the length of arguments
    *argsize = size;
    return procargs;
}


// returns the command line as a python list object
PyObject *
psutil_get_cmdline(pid_t pid) {
    char *argstr = NULL;
    size_t pos = 0;
    size_t argsize = 0;
    PyObject *py_retlist = Py_BuildValue("[]");
    PyObject *py_arg = NULL;

    if (pid < 0)
        return py_retlist;
    argstr = psutil_get_cmd_args(pid, &argsize);
    if (argstr == NULL)
        goto error;

    // args are returned as a flattened string with \0 separators between
    // arguments add each string to the list then step forward to the next
    // separator
    if (argsize > 0) {
        while (pos < argsize) {
            py_arg = PyUnicode_DecodeFSDefault(&argstr[pos]);
            if (!py_arg)
                goto error;
            if (PyList_Append(py_retlist, py_arg))
                goto error;
            Py_DECREF(py_arg);
            pos = pos + strlen(&argstr[pos]) + 1;
        }
    }

    free(argstr);
    return py_retlist;

error:
    Py_XDECREF(py_arg);
    Py_DECREF(py_retlist);
    if (argstr != NULL)
        free(argstr);
    return NULL;
}


/*
 * Return process pathname executable.
 * Thanks to Robert N. M. Watson:
 * http://fxr.googlebit.com/source/usr.bin/procstat/procstat_bin.c?v=8-CURRENT
 */
PyObject *
psutil_proc_exe(PyObject *self, PyObject *args) {
    pid_t pid;
    char pathname[PATH_MAX];
    int error;
    int mib[4];
    int ret;
    size_t size;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PATHNAME;
    mib[3] = pid;

    size = sizeof(pathname);
    error = sysctl(mib, 4, pathname, &size, NULL, 0);
    if (error == -1) {
        // see: https://github.com/giampaolo/psutil/issues/907
        if (errno == ENOENT) {
            return PyUnicode_DecodeFSDefault("");
        }
        else {
            return \
                PyErr_SetFromOSErrnoWithSyscall("sysctl(KERN_PROC_PATHNAME)");
        }
    }
    if (size == 0 || strlen(pathname) == 0) {
        ret = psutil_pid_exists(pid);
        if (ret == -1)
            return NULL;
        else if (ret == 0)
            return NoSuchProcess("psutil_pid_exists");
        else
            strcpy(pathname, "");
    }

    return PyUnicode_DecodeFSDefault(pathname);
}


PyObject *
psutil_proc_num_threads(PyObject *self, PyObject *args) {
    // Return number of threads used by process as a Python integer.
    pid_t pid;
    struct kinfo_proc kp;
    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    if (psutil_kinfo_proc(pid, &kp) == -1)
        return NULL;
    return Py_BuildValue("l", (long)kp.ki_numthreads);
}


PyObject *
psutil_proc_threads(PyObject *self, PyObject *args) {
    // Retrieves all threads used by process returning a list of tuples
    // including thread id, user time and system time.
    // Thanks to Robert N. M. Watson:
    // http://code.metager.de/source/xref/freebsd/usr.bin/procstat/
    //     procstat_threads.c
    pid_t pid;
    int mib[4];
    struct kinfo_proc *kip = NULL;
    struct kinfo_proc *kipp = NULL;
    int error;
    unsigned int i;
    size_t size;
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_tuple = NULL;

    if (py_retlist == NULL)
        return NULL;
    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        goto error;

    // we need to re-query for thread information, so don't use *kipp
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID | KERN_PROC_INC_THREAD;
    mib[3] = pid;

    size = 0;
    error = sysctl(mib, 4, NULL, &size, NULL, 0);
    if (error == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl(KERN_PROC_INC_THREAD)");
        goto error;
    }
    if (size == 0) {
        NoSuchProcess("sysctl (size = 0)");
        goto error;
    }

    kip = malloc(size);
    if (kip == NULL) {
        PyErr_NoMemory();
        goto error;
    }

    error = sysctl(mib, 4, kip, &size, NULL, 0);
    if (error == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl(KERN_PROC_INC_THREAD)");
        goto error;
    }
    if (size == 0) {
        NoSuchProcess("sysctl (size = 0)");
        goto error;
    }

    for (i = 0; i < size / sizeof(*kipp); i++) {
        kipp = &kip[i];
        py_tuple = Py_BuildValue("Idd",
                                 kipp->ki_tid,
                                 PSUTIL_TV2DOUBLE(kipp->ki_rusage.ru_utime),
                                 PSUTIL_TV2DOUBLE(kipp->ki_rusage.ru_stime));
        if (py_tuple == NULL)
            goto error;
        if (PyList_Append(py_retlist, py_tuple))
            goto error;
        Py_DECREF(py_tuple);
    }
    free(kip);
    return py_retlist;

error:
    Py_XDECREF(py_tuple);
    Py_DECREF(py_retlist);
    if (kip != NULL)
        free(kip);
    return NULL;
}


PyObject *
psutil_cpu_count_phys(PyObject *self, PyObject *args) {
    // Return an XML string from which we'll determine the number of
    // physical CPU cores in the system.
    void *topology = NULL;
    size_t size = 0;
    PyObject *py_str;

    if (sysctlbyname("kern.sched.topology_spec", NULL, &size, NULL, 0))
        goto error;

    topology = malloc(size);
    if (!topology) {
        PyErr_NoMemory();
        return NULL;
    }

    if (sysctlbyname("kern.sched.topology_spec", topology, &size, NULL, 0))
        goto error;

    py_str = Py_BuildValue("s", topology);
    free(topology);
    return py_str;

error:
    if (topology != NULL)
        free(topology);
    Py_RETURN_NONE;
}


/*
 * Return virtual memory usage statistics.
 */
PyObject *
psutil_virtual_mem(PyObject *self, PyObject *args) {
    unsigned long  total;
    unsigned int   active, inactive, wired, cached, free;
    size_t         size = sizeof(total);
    struct vmtotal vm;
    int            mib[] = {CTL_VM, VM_METER};
    long           pagesize = getpagesize();
#if __FreeBSD_version > 702101
    long buffers;
#else
    int buffers;
#endif
    size_t buffers_size = sizeof(buffers);

    if (sysctlbyname("hw.physmem", &total, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall("sysctlbyname('hw.physmem')");
    }
    if (sysctlbyname("vm.stats.vm.v_active_count", &active, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_active_count')");
    }
    if (sysctlbyname("vm.stats.vm.v_inactive_count", &inactive, &size, NULL, 0))
    {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_inactive_count')");
    }
    if (sysctlbyname("vm.stats.vm.v_wire_count", &wired, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_wire_count')");
    }
    // https://github.com/giampaolo/psutil/issues/997
    if (sysctlbyname("vm.stats.vm.v_cache_count", &cached, &size, NULL, 0)) {
        cached = 0;
    }
    if (sysctlbyname("vm.stats.vm.v_free_count", &free, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_free_count')");
    }
    if (sysctlbyname("vfs.bufspace", &buffers, &buffers_size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall("sysctlbyname('vfs.bufspace')");
    }

    size = sizeof(vm);
    if (sysctl(mib, 2, &vm, &size, NULL, 0) != 0) {
        return PyErr_SetFromOSErrnoWithSyscall("sysctl(CTL_VM | VM_METER)");
    }

    return Py_BuildValue("KKKKKKKK",
        (unsigned long long) total,
        (unsigned long long) free     * pagesize,
        (unsigned long long) active   * pagesize,
        (unsigned long long) inactive * pagesize,
        (unsigned long long) wired    * pagesize,
        (unsigned long long) cached   * pagesize,
        (unsigned long long) buffers,
        (unsigned long long) (vm.t_vmshr + vm.t_rmshr) * pagesize  // shared
    );
}


PyObject *
psutil_swap_mem(PyObject *self, PyObject *args) {
    // Return swap memory stats (see 'swapinfo' cmdline tool)
    kvm_t *kd;
    struct kvm_swap kvmsw[1];
    unsigned int swapin, swapout, nodein, nodeout;
    size_t size = sizeof(unsigned int);
    int pagesize;

    kd = kvm_open(NULL, _PATH_DEVNULL, NULL, O_RDONLY, "kvm_open failed");
    if (kd == NULL) {
        PyErr_SetString(PyExc_RuntimeError, "kvm_open() syscall failed");
        return NULL;
    }

    if (kvm_getswapinfo(kd, kvmsw, 1, 0) < 0) {
        kvm_close(kd);
        PyErr_SetString(PyExc_RuntimeError,
                        "kvm_getswapinfo() syscall failed");
        return NULL;
    }

    kvm_close(kd);

    if (sysctlbyname("vm.stats.vm.v_swapin", &swapin, &size, NULL, 0) == -1) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_swapin)'");
    }
    if (sysctlbyname("vm.stats.vm.v_swapout", &swapout, &size, NULL, 0) == -1){
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_swapout)'");
    }
    if (sysctlbyname("vm.stats.vm.v_vnodein", &nodein, &size, NULL, 0) == -1) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_vnodein)'");
    }
    if (sysctlbyname("vm.stats.vm.v_vnodeout", &nodeout, &size, NULL, 0) == -1) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.vm.v_vnodeout)'");
    }

    pagesize = getpagesize();
    if (pagesize <= 0) {
        PyErr_SetString(PyExc_ValueError, "invalid getpagesize()");
        return NULL;
    }

    return Py_BuildValue(
        "(KKKII)",
        (unsigned long long)kvmsw[0].ksw_total * pagesize,  // total
        (unsigned long long)kvmsw[0].ksw_used * pagesize,  // used
        (unsigned long long)kvmsw[0].ksw_total * pagesize - // free
                                kvmsw[0].ksw_used * pagesize,
        swapin + swapout,  // swap in
        nodein + nodeout  // swap out
    );
}


#if defined(__FreeBSD_version) && __FreeBSD_version >= 800000
PyObject *
psutil_proc_cwd(PyObject *self, PyObject *args) {
    pid_t pid;
    struct kinfo_file *freep = NULL;
    struct kinfo_file *kif;
    struct kinfo_proc kipp;
    PyObject *py_path = NULL;

    int i, cnt;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        goto error;
    if (psutil_kinfo_proc(pid, &kipp) == -1)
        goto error;

    errno = 0;
    freep = kinfo_getfile(pid, &cnt);
    if (freep == NULL) {
        psutil_raise_for_pid(pid, "kinfo_getfile()");
        goto error;
    }

    for (i = 0; i < cnt; i++) {
        kif = &freep[i];
        if (kif->kf_fd == KF_FD_TYPE_CWD) {
            py_path = PyUnicode_DecodeFSDefault(kif->kf_path);
            if (!py_path)
                goto error;
            break;
        }
    }
    /*
     * For lower pids it seems we can't retrieve any information
     * (lsof can't do that it either).  Since this happens even
     * as root we return an empty string instead of AccessDenied.
     */
    if (py_path == NULL)
        py_path = PyUnicode_DecodeFSDefault("");
    free(freep);
    return py_path;

error:
    Py_XDECREF(py_path);
    if (freep != NULL)
        free(freep);
    return NULL;
}
#endif


#if defined(__FreeBSD_version) && __FreeBSD_version >= 800000
PyObject *
psutil_proc_num_fds(PyObject *self, PyObject *args) {
    pid_t pid;
    int cnt;

    struct kinfo_file *freep;
    struct kinfo_proc kipp;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    if (psutil_kinfo_proc(pid, &kipp) == -1)
        return NULL;

    errno = 0;
    freep = kinfo_getfile(pid, &cnt);
    if (freep == NULL) {
        psutil_raise_for_pid(pid, "kinfo_getfile()");
        return NULL;
    }
    free(freep);

    return Py_BuildValue("i", cnt);
}
#endif


PyObject *
psutil_per_cpu_times(PyObject *self, PyObject *args) {
    static int maxcpus;
    int mib[2];
    int ncpu;
    size_t len;
    size_t size;
    int i;
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_cputime = NULL;

    if (py_retlist == NULL)
        return NULL;

    // retrieve maxcpus value
    size = sizeof(maxcpus);
    if (sysctlbyname("kern.smp.maxcpus", &maxcpus, &size, NULL, 0) < 0) {
        Py_DECREF(py_retlist);
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('kern.smp.maxcpus')");
    }
    long cpu_time[maxcpus][CPUSTATES];

    // retrieve the number of cpus
    mib[0] = CTL_HW;
    mib[1] = HW_NCPU;
    len = sizeof(ncpu);
    if (sysctl(mib, 2, &ncpu, &len, NULL, 0) == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctl(HW_NCPU)");
        goto error;
    }

    // per-cpu info
    size = sizeof(cpu_time);
    if (sysctlbyname("kern.cp_times", &cpu_time, &size, NULL, 0) == -1) {
        PyErr_SetFromOSErrnoWithSyscall("sysctlbyname('kern.smp.maxcpus')");
        goto error;
    }

    for (i = 0; i < ncpu; i++) {
        py_cputime = Py_BuildValue(
            "(ddddd)",
            (double)cpu_time[i][CP_USER] / CLOCKS_PER_SEC,
            (double)cpu_time[i][CP_NICE] / CLOCKS_PER_SEC,
            (double)cpu_time[i][CP_SYS] / CLOCKS_PER_SEC,
            (double)cpu_time[i][CP_IDLE] / CLOCKS_PER_SEC,
            (double)cpu_time[i][CP_INTR] / CLOCKS_PER_SEC);
        if (!py_cputime)
            goto error;
        if (PyList_Append(py_retlist, py_cputime))
            goto error;
        Py_DECREF(py_cputime);
    }

    return py_retlist;

error:
    Py_XDECREF(py_cputime);
    Py_DECREF(py_retlist);
    return NULL;
}


PyObject *
psutil_disk_io_counters(PyObject *self, PyObject *args) {
    int i;
    struct statinfo stats;

    PyObject *py_retdict = PyDict_New();
    PyObject *py_disk_info = NULL;

    if (py_retdict == NULL)
        return NULL;
    if (devstat_checkversion(NULL) < 0) {
        PyErr_Format(PyExc_RuntimeError,
                     "devstat_checkversion() syscall failed");
        goto error;
    }

    stats.dinfo = (struct devinfo *)malloc(sizeof(struct devinfo));
    if (stats.dinfo == NULL) {
        PyErr_NoMemory();
        goto error;
    }
    bzero(stats.dinfo, sizeof(struct devinfo));

    if (devstat_getdevs(NULL, &stats) == -1) {
        PyErr_Format(PyExc_RuntimeError, "devstat_getdevs() syscall failed");
        goto error;
    }

    for (i = 0; i < stats.dinfo->numdevs; i++) {
        py_disk_info = NULL;
        struct devstat current;
        char disk_name[128];
        current = stats.dinfo->devices[i];
        snprintf(disk_name, sizeof(disk_name), "%s%d",
                 current.device_name,
                 current.unit_number);

        py_disk_info = Py_BuildValue(
            "(KKKKLLL)",
            current.operations[DEVSTAT_READ],   // no reads
            current.operations[DEVSTAT_WRITE],  // no writes
            current.bytes[DEVSTAT_READ],        // bytes read
            current.bytes[DEVSTAT_WRITE],       // bytes written
            (long long) PSUTIL_BT2MSEC(current.duration[DEVSTAT_READ]),  // r time
            (long long) PSUTIL_BT2MSEC(current.duration[DEVSTAT_WRITE]),  // w time
            (long long) PSUTIL_BT2MSEC(current.busy_time)  // busy time
        );      // finished transactions
        if (!py_disk_info)
            goto error;
        if (PyDict_SetItemString(py_retdict, disk_name, py_disk_info))
            goto error;
        Py_DECREF(py_disk_info);
    }

    if (stats.dinfo->mem_ptr)
        free(stats.dinfo->mem_ptr);
    free(stats.dinfo);
    return py_retdict;

error:
    Py_XDECREF(py_disk_info);
    Py_DECREF(py_retdict);
    if (stats.dinfo != NULL)
        free(stats.dinfo);
    return NULL;
}


PyObject *
psutil_proc_memory_maps(PyObject *self, PyObject *args) {
    // Return a list of tuples for every process memory maps.
    // 'procstat' cmdline utility has been used as an example.
    pid_t pid;
    int ptrwidth;
    int i, cnt;
    char addr[1000];
    char perms[4];
    char *path;
    struct kinfo_proc kp;
    struct kinfo_vmentry *freep = NULL;
    struct kinfo_vmentry *kve;
    ptrwidth = 2 * sizeof(void *);
    PyObject *py_tuple = NULL;
    PyObject *py_path = NULL;
    PyObject *py_retlist = PyList_New(0);

    if (py_retlist == NULL)
        return NULL;
    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        goto error;
    if (psutil_kinfo_proc(pid, &kp) == -1)
        goto error;

    errno = 0;
    freep = kinfo_getvmmap(pid, &cnt);
    if (freep == NULL) {
        psutil_raise_for_pid(pid, "kinfo_getvmmap()");
        goto error;
    }
    for (i = 0; i < cnt; i++) {
        py_tuple = NULL;
        kve = &freep[i];
        addr[0] = '\0';
        perms[0] = '\0';
        sprintf(addr, "%#*jx-%#*jx", ptrwidth, (uintmax_t)kve->kve_start,
                ptrwidth, (uintmax_t)kve->kve_end);
        psutil_remove_spaces(addr);
        strlcat(perms, kve->kve_protection & KVME_PROT_READ ? "r" : "-",
                sizeof(perms));
        strlcat(perms, kve->kve_protection & KVME_PROT_WRITE ? "w" : "-",
                sizeof(perms));
        strlcat(perms, kve->kve_protection & KVME_PROT_EXEC ? "x" : "-",
                sizeof(perms));

        if (strlen(kve->kve_path) == 0) {
            switch (kve->kve_type) {
                case KVME_TYPE_NONE:
                    path = "[none]";
                    break;
                case KVME_TYPE_DEFAULT:
                    path = "[default]";
                    break;
                case KVME_TYPE_VNODE:
                    path = "[vnode]";
                    break;
                case KVME_TYPE_SWAP:
                    path = "[swap]";
                    break;
                case KVME_TYPE_DEVICE:
                    path = "[device]";
                    break;
                case KVME_TYPE_PHYS:
                    path = "[phys]";
                    break;
                case KVME_TYPE_DEAD:
                    path = "[dead]";
                    break;
                case KVME_TYPE_SG:
                    path = "[sg]";
                    break;
                case KVME_TYPE_UNKNOWN:
                    path = "[unknown]";
                    break;
                default:
                    path = "[?]";
                    break;
            }
        }
        else {
            path = kve->kve_path;
        }

        py_path = PyUnicode_DecodeFSDefault(path);
        if (! py_path)
            goto error;
        py_tuple = Py_BuildValue("ssOiiii",
            addr,                       // "start-end" address
            perms,                      // "rwx" permissions
            py_path,                    // path
            kve->kve_resident,          // rss
            kve->kve_private_resident,  // private
            kve->kve_ref_count,         // ref count
            kve->kve_shadow_count);     // shadow count
        if (!py_tuple)
            goto error;
        if (PyList_Append(py_retlist, py_tuple))
            goto error;
        Py_DECREF(py_path);
        Py_DECREF(py_tuple);
    }
    free(freep);
    return py_retlist;

error:
    Py_XDECREF(py_tuple);
    Py_XDECREF(py_path);
    Py_DECREF(py_retlist);
    if (freep != NULL)
        free(freep);
    return NULL;
}


PyObject*
psutil_proc_cpu_affinity_get(PyObject* self, PyObject* args) {
    // Get process CPU affinity.
    // Reference:
    // http://sources.freebsd.org/RELENG_9/src/usr.bin/cpuset/cpuset.c
    pid_t pid;
    int ret;
    int i;
    cpuset_t mask;
    PyObject* py_retlist;
    PyObject* py_cpu_num;

    if (!PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    ret = cpuset_getaffinity(CPU_LEVEL_WHICH, CPU_WHICH_PID, pid,
                             sizeof(mask), &mask);
    if (ret != 0)
        return PyErr_SetFromErrno(PyExc_OSError);

    py_retlist = PyList_New(0);
    if (py_retlist == NULL)
        return NULL;

    for (i = 0; i < CPU_SETSIZE; i++) {
        if (CPU_ISSET(i, &mask)) {
            py_cpu_num = Py_BuildValue("i", i);
            if (py_cpu_num == NULL)
                goto error;
            if (PyList_Append(py_retlist, py_cpu_num))
                goto error;
        }
    }

    return py_retlist;

error:
    Py_XDECREF(py_cpu_num);
    Py_DECREF(py_retlist);
    return NULL;
}


PyObject *
psutil_proc_cpu_affinity_set(PyObject *self, PyObject *args) {
    // Set process CPU affinity.
    // Reference:
    // http://sources.freebsd.org/RELENG_9/src/usr.bin/cpuset/cpuset.c
    pid_t pid;
    int i;
    int seq_len;
    int ret;
    cpuset_t cpu_set;
    PyObject *py_cpu_set;
    PyObject *py_cpu_seq = NULL;

    if (!PyArg_ParseTuple(args, _Py_PARSE_PID "O", &pid, &py_cpu_set))
        return NULL;

    py_cpu_seq = PySequence_Fast(py_cpu_set, "expected a sequence or integer");
    if (!py_cpu_seq)
        return NULL;
    seq_len = PySequence_Fast_GET_SIZE(py_cpu_seq);

    // calculate the mask
    CPU_ZERO(&cpu_set);
    for (i = 0; i < seq_len; i++) {
        PyObject *item = PySequence_Fast_GET_ITEM(py_cpu_seq, i);
#if PY_MAJOR_VERSION >= 3
        long value = PyLong_AsLong(item);
#else
        long value = PyInt_AsLong(item);
#endif
        if (value == -1 || PyErr_Occurred())
            goto error;
        CPU_SET(value, &cpu_set);
    }

    // set affinity
    ret = cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_PID, pid,
                             sizeof(cpu_set), &cpu_set);
    if (ret != 0) {
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


PyObject *
psutil_cpu_stats(PyObject *self, PyObject *args) {
    unsigned int v_soft;
    unsigned int v_intr;
    unsigned int v_syscall;
    unsigned int v_trap;
    unsigned int v_swtch;
    size_t size = sizeof(v_soft);

    if (sysctlbyname("vm.stats.sys.v_soft", &v_soft, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.sys.v_soft')");
    }
    if (sysctlbyname("vm.stats.sys.v_intr", &v_intr, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.sys.v_intr')");
    }
    if (sysctlbyname("vm.stats.sys.v_syscall", &v_syscall, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.sys.v_syscall')");
    }
    if (sysctlbyname("vm.stats.sys.v_trap", &v_trap, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.sys.v_trap')");
    }
    if (sysctlbyname("vm.stats.sys.v_swtch", &v_swtch, &size, NULL, 0)) {
        return PyErr_SetFromOSErrnoWithSyscall(
            "sysctlbyname('vm.stats.sys.v_swtch')");
    }

    return Py_BuildValue(
        "IIIII",
        v_swtch,  // ctx switches
        v_intr,  // interrupts
        v_soft,  // software interrupts
        v_syscall,  // syscalls
        v_trap  // traps
    );
}


/*
 * Return battery information.
 */
PyObject *
psutil_sensors_battery(PyObject *self, PyObject *args) {
    int percent;
    int minsleft;
    int power_plugged;
    size_t size = sizeof(percent);

    if (sysctlbyname("hw.acpi.battery.life", &percent, &size, NULL, 0))
        goto error;
    if (sysctlbyname("hw.acpi.battery.time", &minsleft, &size, NULL, 0))
        goto error;
    if (sysctlbyname("hw.acpi.acline", &power_plugged, &size, NULL, 0))
        goto error;
    return Py_BuildValue("iii", percent, minsleft, power_plugged);

error:
    // see: https://github.com/giampaolo/psutil/issues/1074
    if (errno == ENOENT)
        PyErr_SetString(PyExc_NotImplementedError, "no battery");
    else
        PyErr_SetFromErrno(PyExc_OSError);
    return NULL;
}


/*
 * Return temperature information for a given CPU core number.
 */
PyObject *
psutil_sensors_cpu_temperature(PyObject *self, PyObject *args) {
    int current;
    int tjmax;
    int core;
    char sensor[26];
    size_t size = sizeof(current);

    if (! PyArg_ParseTuple(args, "i", &core))
        return NULL;
    sprintf(sensor, "dev.cpu.%d.temperature", core);
    if (sysctlbyname(sensor, &current, &size, NULL, 0))
        goto error;
    current = DECIKELVIN_2_CELCIUS(current);

    // Return -273 in case of faliure.
    sprintf(sensor, "dev.cpu.%d.coretemp.tjmax", core);
    if (sysctlbyname(sensor, &tjmax, &size, NULL, 0))
        tjmax = 0;
    tjmax = DECIKELVIN_2_CELCIUS(tjmax);

    return Py_BuildValue("ii", current, tjmax);

error:
    if (errno == ENOENT)
        PyErr_SetString(PyExc_NotImplementedError, "no temperature sensors");
    else
        PyErr_SetFromErrno(PyExc_OSError);
    return NULL;
}


/*
 * Return frequency information of a given CPU.
 * As of Dec 2018 only CPU 0 appears to be supported and all other
 * cores match the frequency of CPU 0.
 */
PyObject *
psutil_cpu_freq(PyObject *self, PyObject *args) {
    int current;
    int core;
    char sensor[26];
    char available_freq_levels[1000];
    size_t size = sizeof(current);

    if (! PyArg_ParseTuple(args, "i", &core))
        return NULL;
    // https://www.unix.com/man-page/FreeBSD/4/cpufreq/
    sprintf(sensor, "dev.cpu.%d.freq", core);
    if (sysctlbyname(sensor, &current, &size, NULL, 0))
        goto error;

    size = sizeof(available_freq_levels);
    // https://www.unix.com/man-page/FreeBSD/4/cpufreq/
    // In case of failure, an empty string is returned.
    sprintf(sensor, "dev.cpu.%d.freq_levels", core);
    sysctlbyname(sensor, &available_freq_levels, &size, NULL, 0);

    return Py_BuildValue("is", current, available_freq_levels);

error:
    if (errno == ENOENT)
        PyErr_SetString(PyExc_NotImplementedError, "unable to read frequency");
    else
        PyErr_SetFromErrno(PyExc_OSError);
    return NULL;
}
