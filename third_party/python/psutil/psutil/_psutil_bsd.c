/*
 * Copyright (c) 2009, Giampaolo Rodola', Landry Breuil (OpenBSD).
 * All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Platform-specific module methods for FreeBSD and OpenBSD.

 * OpenBSD references:
 * - OpenBSD source code: https://github.com/openbsd/src
 *
 * OpenBSD / NetBSD: missing APIs compared to FreeBSD implementation:
 * - psutil.net_connections()
 * - psutil.Process.get/set_cpu_affinity()  (not supported natively)
 * - psutil.Process.memory_maps()
 */

#if defined(PSUTIL_NETBSD)
    #define _KMEMUSER
#endif

#include <Python.h>
#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <fcntl.h>
#include <paths.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/sysctl.h>
#if !defined(__NetBSD__)
    #include <sys/user.h>
#endif
#include <sys/proc.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <net/route.h>
#include <sys/socketvar.h>    // for struct xsocket
#include <sys/un.h>
#include <sys/unpcb.h>
// for xinpcb struct
#include <netinet/in.h>
#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/in_pcb.h>
#include <netinet/tcp.h>
#include <netinet/tcp_timer.h>
#include <netinet/ip_var.h>
#include <netinet/tcp_var.h>   // for struct xtcpcb
#include <netinet/tcp_fsm.h>   // for TCP connection states
#include <arpa/inet.h>         // for inet_ntop()
#include <sys/mount.h>
#include <net/if.h>       // net io counters
#include <net/if_dl.h>
#include <net/route.h>
#include <netinet/in.h>   // process open files/connections
#include <sys/un.h>

#include "_psutil_common.h"
#include "_psutil_posix.h"

#ifdef PSUTIL_FREEBSD
    #include "arch/freebsd/specific.h"
    #include "arch/freebsd/sys_socks.h"
    #include "arch/freebsd/proc_socks.h"

    #include <net/if_media.h>
    #include <devstat.h>  // get io counters
    #include <libutil.h>  // process open files, shared libs (kinfo_getvmmap)
    #if __FreeBSD_version < 900000
        #include <utmp.h>  // system users
    #else
        #include <utmpx.h>
    #endif
#elif PSUTIL_OPENBSD
    #include "arch/openbsd/specific.h"

    #include <utmp.h>
    #include <sys/vnode.h>  // for VREG
    #define _KERNEL  // for DTYPE_VNODE
    #include <sys/file.h>
    #undef _KERNEL
    #include <sys/sched.h>  // for CPUSTATES & CP_*
#elif PSUTIL_NETBSD
    #include "arch/netbsd/specific.h"
    #include "arch/netbsd/socks.h"

    #include <utmpx.h>
    #include <sys/vnode.h>  // for VREG
    #include <sys/sched.h>  // for CPUSTATES & CP_*
    #ifndef DTYPE_VNODE
        #define DTYPE_VNODE 1
    #endif
#endif


// convert a timeval struct to a double
#define PSUTIL_TV2DOUBLE(t) ((t).tv_sec + (t).tv_usec / 1000000.0)

#ifdef PSUTIL_FREEBSD
    // convert a bintime struct to milliseconds
    #define PSUTIL_BT2MSEC(bt) (bt.sec * 1000 + (((uint64_t) 1000000000 * \
                           (uint32_t) (bt.frac >> 32) ) >> 32 ) / 1000000)
#endif

#if defined(PSUTIL_OPENBSD) || defined (PSUTIL_NETBSD)
    #define PSUTIL_KPT2DOUBLE(t) (t ## _sec + t ## _usec / 1000000.0)
#endif


/*
 * Return a Python list of all the PIDs running on the system.
 */
static PyObject *
psutil_pids(PyObject *self, PyObject *args) {
    kinfo_proc *proclist = NULL;
    kinfo_proc *orig_address = NULL;
    size_t num_processes;
    size_t idx;
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_pid = NULL;

    if (py_retlist == NULL)
        return NULL;

    if (psutil_get_proc_list(&proclist, &num_processes) != 0)
        goto error;

    if (num_processes > 0) {
        orig_address = proclist; // save so we can free it after we're done
        for (idx = 0; idx < num_processes; idx++) {
#ifdef PSUTIL_FREEBSD
            py_pid = PyLong_FromPid(proclist->ki_pid);
#elif defined(PSUTIL_OPENBSD) || defined(PSUTIL_NETBSD)
            py_pid = PyLong_FromPid(proclist->p_pid);
#endif
            if (!py_pid)
                goto error;
            if (PyList_Append(py_retlist, py_pid))
                goto error;
            Py_CLEAR(py_pid);
            proclist++;
        }
        free(orig_address);
    }

    return py_retlist;

error:
    Py_XDECREF(py_pid);
    Py_DECREF(py_retlist);
    if (orig_address != NULL)
        free(orig_address);
    return NULL;
}


/*
 * Return a Python float indicating the system boot time expressed in
 * seconds since the epoch.
 */
static PyObject *
psutil_boot_time(PyObject *self, PyObject *args) {
    // fetch sysctl "kern.boottime"
    static int request[2] = { CTL_KERN, KERN_BOOTTIME };
    struct timeval boottime;
    size_t len = sizeof(boottime);

    if (sysctl(request, 2, &boottime, &len, NULL, 0) == -1)
        return PyErr_SetFromErrno(PyExc_OSError);
    return Py_BuildValue("d", (double)boottime.tv_sec);
}


/*
 * Collect different info about a process in one shot and return
 * them as a big Python tuple.
 */
static PyObject *
psutil_proc_oneshot_info(PyObject *self, PyObject *args) {
    pid_t pid;
    long rss;
    long vms;
    long memtext;
    long memdata;
    long memstack;
    int oncpu;
    kinfo_proc kp;
    long pagesize = sysconf(_SC_PAGESIZE);
    char str[1000];
    PyObject *py_name;
    PyObject *py_ppid;
    PyObject *py_retlist;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    if (psutil_kinfo_proc(pid, &kp) == -1)
        return NULL;

    // Process
#ifdef PSUTIL_FREEBSD
    sprintf(str, "%s", kp.ki_comm);
#elif defined(PSUTIL_OPENBSD) || defined(PSUTIL_NETBSD)
    sprintf(str, "%s", kp.p_comm);
#endif
    py_name = PyUnicode_DecodeFSDefault(str);
    if (! py_name) {
        // Likely a decoding error. We don't want to fail the whole
        // operation. The python module may retry with proc_name().
        PyErr_Clear();
        py_name = Py_None;
    }
    // Py_INCREF(py_name);

    // Calculate memory.
#ifdef PSUTIL_FREEBSD
    rss = (long)kp.ki_rssize * pagesize;
    vms = (long)kp.ki_size;
    memtext = (long)kp.ki_tsize * pagesize;
    memdata = (long)kp.ki_dsize * pagesize;
    memstack = (long)kp.ki_ssize * pagesize;
#else
    rss = (long)kp.p_vm_rssize * pagesize;
    #ifdef PSUTIL_OPENBSD
        // VMS, this is how ps determines it on OpenBSD:
        // https://github.com/openbsd/src/blob/
        //     588f7f8c69786211f2d16865c552afb91b1c7cba/bin/ps/print.c#L505
        vms = (long)(kp.p_vm_dsize + kp.p_vm_ssize + kp.p_vm_tsize) * pagesize;
    #elif PSUTIL_NETBSD
        // VMS, this is how top determines it on NetBSD:
        // https://github.com/IIJ-NetBSD/netbsd-src/blob/master/external/
        //     bsd/top/dist/machine/m_netbsd.c
        vms = (long)kp.p_vm_msize * pagesize;
    #endif
        memtext = (long)kp.p_vm_tsize * pagesize;
        memdata = (long)kp.p_vm_dsize * pagesize;
        memstack = (long)kp.p_vm_ssize * pagesize;
#endif

#ifdef PSUTIL_FREEBSD
    // what CPU we're on; top was used as an example:
    // https://svnweb.freebsd.org/base/head/usr.bin/top/machine.c?
    //     view=markup&pathrev=273835
    // XXX - note: for "intr" PID this is -1.
    if (kp.ki_stat == SRUN && kp.ki_oncpu != NOCPU)
        oncpu = kp.ki_oncpu;
    else
        oncpu = kp.ki_lastcpu;
#else
    // On Net/OpenBSD we have kp.p_cpuid but it appears it's always
    // set to KI_NOCPU. Even if it's not, ki_lastcpu does not exist
    // so there's no way to determine where "sleeping" processes
    // were. Not supported.
    oncpu = -1;
#endif

#ifdef PSUTIL_FREEBSD
    py_ppid = PyLong_FromPid(kp.ki_ppid);
#elif defined(PSUTIL_OPENBSD) || defined(PSUTIL_NETBSD)
    py_ppid = PyLong_FromPid(kp.p_ppid);
#else
    py_ppid = Py_BuildfValue(-1);
#endif
    if (! py_ppid)
        return NULL;

    // Return a single big tuple with all process info.
    py_retlist = Py_BuildValue(
#if defined(__FreeBSD_version) && __FreeBSD_version >= 1200031
        "(OillllllLdllllddddlllllbO)",
#else
        "(OillllllidllllddddlllllbO)",
#endif
#ifdef PSUTIL_FREEBSD
        py_ppid,                         // (pid_t) ppid
        (int)kp.ki_stat,                 // (int) status
        // UIDs
        (long)kp.ki_ruid,                // (long) real uid
        (long)kp.ki_uid,                 // (long) effective uid
        (long)kp.ki_svuid,               // (long) saved uid
        // GIDs
        (long)kp.ki_rgid,                // (long) real gid
        (long)kp.ki_groups[0],           // (long) effective gid
        (long)kp.ki_svuid,               // (long) saved gid
        //
        kp.ki_tdev,                      // (int or long long) tty nr
        PSUTIL_TV2DOUBLE(kp.ki_start),   // (double) create time
        // ctx switches
        kp.ki_rusage.ru_nvcsw,           // (long) ctx switches (voluntary)
        kp.ki_rusage.ru_nivcsw,          // (long) ctx switches (unvoluntary)
        // IO count
        kp.ki_rusage.ru_inblock,         // (long) read io count
        kp.ki_rusage.ru_oublock,         // (long) write io count
        // CPU times: convert from micro seconds to seconds.
        PSUTIL_TV2DOUBLE(kp.ki_rusage.ru_utime),     // (double) user time
        PSUTIL_TV2DOUBLE(kp.ki_rusage.ru_stime),     // (double) sys time
        PSUTIL_TV2DOUBLE(kp.ki_rusage_ch.ru_utime),  // (double) children utime
        PSUTIL_TV2DOUBLE(kp.ki_rusage_ch.ru_stime),  // (double) children stime
        // memory
        rss,                              // (long) rss
        vms,                              // (long) vms
        memtext,                          // (long) mem text
        memdata,                          // (long) mem data
        memstack,                         // (long) mem stack
        // others
        oncpu,                            // (int) the CPU we are on
#elif defined(PSUTIL_OPENBSD) || defined(PSUTIL_NETBSD)
        py_ppid,                         // (pid_t) ppid
        (int)kp.p_stat,                  // (int) status
        // UIDs
        (long)kp.p_ruid,                 // (long) real uid
        (long)kp.p_uid,                  // (long) effective uid
        (long)kp.p_svuid,                // (long) saved uid
        // GIDs
        (long)kp.p_rgid,                 // (long) real gid
        (long)kp.p_groups[0],            // (long) effective gid
        (long)kp.p_svuid,                // (long) saved gid
        //
        kp.p_tdev,                       // (int) tty nr
        PSUTIL_KPT2DOUBLE(kp.p_ustart),  // (double) create time
        // ctx switches
        kp.p_uru_nvcsw,                  // (long) ctx switches (voluntary)
        kp.p_uru_nivcsw,                 // (long) ctx switches (unvoluntary)
        // IO count
        kp.p_uru_inblock,                // (long) read io count
        kp.p_uru_oublock,                // (long) write io count
        // CPU times: convert from micro seconds to seconds.
        PSUTIL_KPT2DOUBLE(kp.p_uutime),  // (double) user time
        PSUTIL_KPT2DOUBLE(kp.p_ustime),  // (double) sys time
        // OpenBSD and NetBSD provide children user + system times summed
        // together (no distinction).
        kp.p_uctime_sec + kp.p_uctime_usec / 1000000.0,  // (double) ch utime
        kp.p_uctime_sec + kp.p_uctime_usec / 1000000.0,  // (double) ch stime
        // memory
        rss,                              // (long) rss
        vms,                              // (long) vms
        memtext,                          // (long) mem text
        memdata,                          // (long) mem data
        memstack,                         // (long) mem stack
        // others
        oncpu,                            // (int) the CPU we are on
#endif
        py_name                           // (pystr) name
    );

    Py_DECREF(py_name);
    Py_DECREF(py_ppid);
    return py_retlist;
}


/*
 * Return process name from kinfo_proc as a Python string.
 */
static PyObject *
psutil_proc_name(PyObject *self, PyObject *args) {
    pid_t pid;
    kinfo_proc kp;
    char str[1000];

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    if (psutil_kinfo_proc(pid, &kp) == -1)
        return NULL;

#ifdef PSUTIL_FREEBSD
    sprintf(str, "%s", kp.ki_comm);
#elif defined(PSUTIL_OPENBSD) || defined(PSUTIL_NETBSD)
    sprintf(str, "%s", kp.p_comm);
#endif
    return PyUnicode_DecodeFSDefault(str);
}


/*
 * Return process cmdline as a Python list of cmdline arguments.
 */
static PyObject *
psutil_proc_cmdline(PyObject *self, PyObject *args) {
    pid_t pid;
    PyObject *py_retlist = NULL;

    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        return NULL;
    py_retlist = psutil_get_cmdline(pid);
    if (py_retlist == NULL)
        return NULL;
    return Py_BuildValue("N", py_retlist);
}


/*
 * Return the number of logical CPUs in the system.
 * XXX this could be shared with macOS
 */
static PyObject *
psutil_cpu_count_logical(PyObject *self, PyObject *args) {
    int mib[2];
    int ncpu;
    size_t len;

    mib[0] = CTL_HW;
    mib[1] = HW_NCPU;
    len = sizeof(ncpu);

    if (sysctl(mib, 2, &ncpu, &len, NULL, 0) == -1)
        Py_RETURN_NONE;  // mimic os.cpu_count()
    else
        return Py_BuildValue("i", ncpu);
}


/*
 * Return a Python tuple representing user, kernel and idle CPU times
 */
static PyObject *
psutil_cpu_times(PyObject *self, PyObject *args) {
#ifdef PSUTIL_NETBSD
    u_int64_t cpu_time[CPUSTATES];
#else
    long cpu_time[CPUSTATES];
#endif
    size_t size = sizeof(cpu_time);
    int ret;

#if defined(PSUTIL_FREEBSD) || defined(PSUTIL_NETBSD)
    ret = sysctlbyname("kern.cp_time", &cpu_time, &size, NULL, 0);
#elif PSUTIL_OPENBSD
    int mib[] = {CTL_KERN, KERN_CPTIME};
    ret = sysctl(mib, 2, &cpu_time, &size, NULL, 0);
#endif
    if (ret == -1)
        return PyErr_SetFromErrno(PyExc_OSError);
    return Py_BuildValue("(ddddd)",
                         (double)cpu_time[CP_USER] / CLOCKS_PER_SEC,
                         (double)cpu_time[CP_NICE] / CLOCKS_PER_SEC,
                         (double)cpu_time[CP_SYS] / CLOCKS_PER_SEC,
                         (double)cpu_time[CP_IDLE] / CLOCKS_PER_SEC,
                         (double)cpu_time[CP_INTR] / CLOCKS_PER_SEC
                        );
}


 /*
 * Return files opened by process as a list of (path, fd) tuples.
 * TODO: this is broken as it may report empty paths. 'procstat'
 * utility has the same problem see:
 * https://github.com/giampaolo/psutil/issues/595
 */
#if (defined(__FreeBSD_version) && __FreeBSD_version >= 800000) || PSUTIL_OPENBSD || defined(PSUTIL_NETBSD)
static PyObject *
psutil_proc_open_files(PyObject *self, PyObject *args) {
    pid_t pid;
    int i;
    int cnt;
    int regular;
    int fd;
    char *path;
    struct kinfo_file *freep = NULL;
    struct kinfo_file *kif;
    kinfo_proc kipp;
    PyObject *py_tuple = NULL;
    PyObject *py_path = NULL;
    PyObject *py_retlist = PyList_New(0);

    if (py_retlist == NULL)
        return NULL;
    if (! PyArg_ParseTuple(args, _Py_PARSE_PID, &pid))
        goto error;
    if (psutil_kinfo_proc(pid, &kipp) == -1)
        goto error;

    errno = 0;
    freep = kinfo_getfile(pid, &cnt);
    if (freep == NULL) {
#if !defined(PSUTIL_OPENBSD)
        psutil_raise_for_pid(pid, "kinfo_getfile()");
#endif
        goto error;
    }

    for (i = 0; i < cnt; i++) {
        kif = &freep[i];

#ifdef PSUTIL_FREEBSD
        regular = (kif->kf_type == KF_TYPE_VNODE) && \
            (kif->kf_vnode_type == KF_VTYPE_VREG);
        fd = kif->kf_fd;
        path = kif->kf_path;
#elif PSUTIL_OPENBSD
        regular = (kif->f_type == DTYPE_VNODE) && (kif->v_type == VREG);
        fd = kif->fd_fd;
        // XXX - it appears path is not exposed in the kinfo_file struct.
        path = "";
#elif PSUTIL_NETBSD
        regular = (kif->ki_ftype == DTYPE_VNODE) && (kif->ki_vtype == VREG);
        fd = kif->ki_fd;
        // XXX - it appears path is not exposed in the kinfo_file struct.
        path = "";
#endif
        if (regular == 1) {
            py_path = PyUnicode_DecodeFSDefault(path);
            if (! py_path)
                goto error;
            py_tuple = Py_BuildValue("(Oi)", py_path, fd);
            if (py_tuple == NULL)
                goto error;
            if (PyList_Append(py_retlist, py_tuple))
                goto error;
            Py_CLEAR(py_path);
            Py_CLEAR(py_tuple);
        }
    }
    free(freep);
    return py_retlist;

error:
    Py_XDECREF(py_tuple);
    Py_DECREF(py_retlist);
    if (freep != NULL)
        free(freep);
    return NULL;
}
#endif


/*
 * Return a list of tuples including device, mount point and fs type
 * for all partitions mounted on the system.
 */
static PyObject *
psutil_disk_partitions(PyObject *self, PyObject *args) {
    int num;
    int i;
    long len;
    uint64_t flags;
    char opts[200];
#ifdef PSUTIL_NETBSD
    struct statvfs *fs = NULL;
#else
    struct statfs *fs = NULL;
#endif
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_dev = NULL;
    PyObject *py_mountp = NULL;
    PyObject *py_tuple = NULL;

    if (py_retlist == NULL)
        return NULL;

    // get the number of mount points
    Py_BEGIN_ALLOW_THREADS
#ifdef PSUTIL_NETBSD
    num = getvfsstat(NULL, 0, MNT_NOWAIT);
#else
    num = getfsstat(NULL, 0, MNT_NOWAIT);
#endif
    Py_END_ALLOW_THREADS
    if (num == -1) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    len = sizeof(*fs) * num;
    fs = malloc(len);
    if (fs == NULL) {
        PyErr_NoMemory();
        goto error;
    }

    Py_BEGIN_ALLOW_THREADS
#ifdef PSUTIL_NETBSD
    num = getvfsstat(fs, len, MNT_NOWAIT);
#else
    num = getfsstat(fs, len, MNT_NOWAIT);
#endif
    Py_END_ALLOW_THREADS
    if (num == -1) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    for (i = 0; i < num; i++) {
        py_tuple = NULL;
        opts[0] = 0;
#ifdef PSUTIL_NETBSD
        flags = fs[i].f_flag;
#else
        flags = fs[i].f_flags;
#endif

        // see sys/mount.h
        if (flags & MNT_RDONLY)
            strlcat(opts, "ro", sizeof(opts));
        else
            strlcat(opts, "rw", sizeof(opts));
        if (flags & MNT_SYNCHRONOUS)
            strlcat(opts, ",sync", sizeof(opts));
        if (flags & MNT_NOEXEC)
            strlcat(opts, ",noexec", sizeof(opts));
        if (flags & MNT_NOSUID)
            strlcat(opts, ",nosuid", sizeof(opts));
        if (flags & MNT_ASYNC)
            strlcat(opts, ",async", sizeof(opts));
        if (flags & MNT_NOATIME)
            strlcat(opts, ",noatime", sizeof(opts));
        if (flags & MNT_SOFTDEP)
            strlcat(opts, ",softdep", sizeof(opts));
#ifdef PSUTIL_FREEBSD
        if (flags & MNT_UNION)
            strlcat(opts, ",union", sizeof(opts));
        if (flags & MNT_SUIDDIR)
            strlcat(opts, ",suiddir", sizeof(opts));
        if (flags & MNT_SOFTDEP)
            strlcat(opts, ",softdep", sizeof(opts));
        if (flags & MNT_NOSYMFOLLOW)
            strlcat(opts, ",nosymfollow", sizeof(opts));
        if (flags & MNT_GJOURNAL)
            strlcat(opts, ",gjournal", sizeof(opts));
        if (flags & MNT_MULTILABEL)
            strlcat(opts, ",multilabel", sizeof(opts));
        if (flags & MNT_ACLS)
            strlcat(opts, ",acls", sizeof(opts));
        if (flags & MNT_NOCLUSTERR)
            strlcat(opts, ",noclusterr", sizeof(opts));
        if (flags & MNT_NOCLUSTERW)
            strlcat(opts, ",noclusterw", sizeof(opts));
        if (flags & MNT_NFS4ACLS)
            strlcat(opts, ",nfs4acls", sizeof(opts));
#elif PSUTIL_NETBSD
        if (flags & MNT_NODEV)
            strlcat(opts, ",nodev", sizeof(opts));
        if (flags & MNT_UNION)
            strlcat(opts, ",union", sizeof(opts));
        if (flags & MNT_NOCOREDUMP)
            strlcat(opts, ",nocoredump", sizeof(opts));
#ifdef MNT_RELATIME
        if (flags & MNT_RELATIME)
            strlcat(opts, ",relatime", sizeof(opts));
#endif
        if (flags & MNT_IGNORE)
            strlcat(opts, ",ignore", sizeof(opts));
#ifdef MNT_DISCARD
        if (flags & MNT_DISCARD)
            strlcat(opts, ",discard", sizeof(opts));
#endif
#ifdef MNT_EXTATTR
        if (flags & MNT_EXTATTR)
            strlcat(opts, ",extattr", sizeof(opts));
#endif
        if (flags & MNT_LOG)
            strlcat(opts, ",log", sizeof(opts));
        if (flags & MNT_SYMPERM)
            strlcat(opts, ",symperm", sizeof(opts));
        if (flags & MNT_NODEVMTIME)
            strlcat(opts, ",nodevmtime", sizeof(opts));
#endif
        py_dev = PyUnicode_DecodeFSDefault(fs[i].f_mntfromname);
        if (! py_dev)
            goto error;
        py_mountp = PyUnicode_DecodeFSDefault(fs[i].f_mntonname);
        if (! py_mountp)
            goto error;
        py_tuple = Py_BuildValue("(OOss)",
                                 py_dev,               // device
                                 py_mountp,            // mount point
                                 fs[i].f_fstypename,   // fs type
                                 opts);                // options
        if (!py_tuple)
            goto error;
        if (PyList_Append(py_retlist, py_tuple))
            goto error;
        Py_CLEAR(py_dev);
        Py_CLEAR(py_mountp);
        Py_CLEAR(py_tuple);
    }

    free(fs);
    return py_retlist;

error:
    Py_XDECREF(py_dev);
    Py_XDECREF(py_mountp);
    Py_XDECREF(py_tuple);
    Py_DECREF(py_retlist);
    if (fs != NULL)
        free(fs);
    return NULL;
}


/*
 * Return a Python list of named tuples with overall network I/O information
 */
static PyObject *
psutil_net_io_counters(PyObject *self, PyObject *args) {
    char *buf = NULL, *lim, *next;
    struct if_msghdr *ifm;
    int mib[6];
    size_t len;
    PyObject *py_retdict = PyDict_New();
    PyObject *py_ifc_info = NULL;
    if (py_retdict == NULL)
        return NULL;

    mib[0] = CTL_NET;          // networking subsystem
    mib[1] = PF_ROUTE;         // type of information
    mib[2] = 0;                // protocol (IPPROTO_xxx)
    mib[3] = 0;                // address family
    mib[4] = NET_RT_IFLIST;   // operation
    mib[5] = 0;

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    buf = malloc(len);
    if (buf == NULL) {
        PyErr_NoMemory();
        goto error;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        PyErr_SetFromErrno(PyExc_OSError);
        goto error;
    }

    lim = buf + len;

    for (next = buf; next < lim; ) {
        py_ifc_info = NULL;
        ifm = (struct if_msghdr *)next;
        next += ifm->ifm_msglen;

        if (ifm->ifm_type == RTM_IFINFO) {
            struct if_msghdr *if2m = (struct if_msghdr *)ifm;
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)(if2m + 1);
            char ifc_name[32];

            strncpy(ifc_name, sdl->sdl_data, sdl->sdl_nlen);
            ifc_name[sdl->sdl_nlen] = 0;
            // XXX: ignore usbus interfaces:
            // http://lists.freebsd.org/pipermail/freebsd-current/
            //     2011-October/028752.html
            // 'ifconfig -a' doesn't show them, nor do we.
            if (strncmp(ifc_name, "usbus", 5) == 0)
                continue;

            py_ifc_info = Py_BuildValue("(kkkkkkki)",
                                        if2m->ifm_data.ifi_obytes,
                                        if2m->ifm_data.ifi_ibytes,
                                        if2m->ifm_data.ifi_opackets,
                                        if2m->ifm_data.ifi_ipackets,
                                        if2m->ifm_data.ifi_ierrors,
                                        if2m->ifm_data.ifi_oerrors,
                                        if2m->ifm_data.ifi_iqdrops,
#ifdef _IFI_OQDROPS
                                        if2m->ifm_data.ifi_oqdrops
#else
                                        0
#endif
                                        );
            if (!py_ifc_info)
                goto error;
            if (PyDict_SetItemString(py_retdict, ifc_name, py_ifc_info))
                goto error;
            Py_CLEAR(py_ifc_info);
        }
        else {
            continue;
        }
    }

    free(buf);
    return py_retdict;

error:
    Py_XDECREF(py_ifc_info);
    Py_DECREF(py_retdict);
    if (buf != NULL)
        free(buf);
    return NULL;
}


/*
 * Return currently connected users as a list of tuples.
 */
static PyObject *
psutil_users(PyObject *self, PyObject *args) {
    PyObject *py_retlist = PyList_New(0);
    PyObject *py_username = NULL;
    PyObject *py_tty = NULL;
    PyObject *py_hostname = NULL;
    PyObject *py_tuple = NULL;
    PyObject *py_pid = NULL;

    if (py_retlist == NULL)
        return NULL;

#if (defined(__FreeBSD_version) && (__FreeBSD_version < 900000)) || PSUTIL_OPENBSD
    struct utmp ut;
    FILE *fp;

    Py_BEGIN_ALLOW_THREADS
    fp = fopen(_PATH_UTMP, "r");
    Py_END_ALLOW_THREADS
    if (fp == NULL) {
        PyErr_SetFromErrnoWithFilename(PyExc_OSError, _PATH_UTMP);
        goto error;
    }

    while (fread(&ut, sizeof(ut), 1, fp) == 1) {
        if (*ut.ut_name == '\0')
            continue;
        py_username = PyUnicode_DecodeFSDefault(ut.ut_name);
        if (! py_username)
            goto error;
        py_tty = PyUnicode_DecodeFSDefault(ut.ut_line);
        if (! py_tty)
            goto error;
        py_hostname = PyUnicode_DecodeFSDefault(ut.ut_host);
        if (! py_hostname)
            goto error;
        py_tuple = Py_BuildValue(
            "(OOOfi)",
            py_username,        // username
            py_tty,             // tty
            py_hostname,        // hostname
            (float)ut.ut_time,  // start time
#ifdef PSUTIL_OPENBSD
            -1                  // process id (set to None later)
#else
            ut.ut_pid           // TODO: use PyLong_FromPid
#endif
        );
        if (!py_tuple) {
            fclose(fp);
            goto error;
        }
        if (PyList_Append(py_retlist, py_tuple)) {
            fclose(fp);
            goto error;
        }
        Py_CLEAR(py_username);
        Py_CLEAR(py_tty);
        Py_CLEAR(py_hostname);
        Py_CLEAR(py_tuple);
    }

    fclose(fp);
#else
    struct utmpx *utx;
    setutxent();
    while ((utx = getutxent()) != NULL) {
        if (utx->ut_type != USER_PROCESS)
            continue;
        py_username = PyUnicode_DecodeFSDefault(utx->ut_user);
        if (! py_username)
            goto error;
        py_tty = PyUnicode_DecodeFSDefault(utx->ut_line);
        if (! py_tty)
            goto error;
        py_hostname = PyUnicode_DecodeFSDefault(utx->ut_host);
        if (! py_hostname)
            goto error;
#ifdef PSUTIL_OPENBSD
        py_pid = Py_BuildValue("i", -1);  // set to None later
#else
        py_pid = PyLong_FromPid(utx->ut_pid);
#endif
        if (! py_pid)
            goto error;

        py_tuple = Py_BuildValue(
            "(OOOfO)",
            py_username,   // username
            py_tty,        // tty
            py_hostname,   // hostname
            (float)utx->ut_tv.tv_sec,  // start time
            py_pid         // process id
        );

        if (!py_tuple) {
            endutxent();
            goto error;
        }
        if (PyList_Append(py_retlist, py_tuple)) {
            endutxent();
            goto error;
        }
        Py_CLEAR(py_username);
        Py_CLEAR(py_tty);
        Py_CLEAR(py_hostname);
        Py_CLEAR(py_tuple);
        Py_CLEAR(py_pid);
    }

    endutxent();
#endif
    return py_retlist;

error:
    Py_XDECREF(py_username);
    Py_XDECREF(py_tty);
    Py_XDECREF(py_hostname);
    Py_XDECREF(py_tuple);
    Py_XDECREF(py_pid);
    Py_DECREF(py_retlist);
    return NULL;
}


/*
 * define the psutil C module methods and initialize the module.
 */
static PyMethodDef mod_methods[] = {
    // --- per-process functions

    {"proc_oneshot_info", psutil_proc_oneshot_info, METH_VARARGS,
     "Return multiple info about a process"},
    {"proc_name", psutil_proc_name, METH_VARARGS,
     "Return process name"},
    {"proc_cmdline", psutil_proc_cmdline, METH_VARARGS,
     "Return process cmdline as a list of cmdline arguments"},
    {"proc_threads", psutil_proc_threads, METH_VARARGS,
     "Return process threads"},
#if defined(PSUTIL_FREEBSD) || defined(PSUTIL_OPENBSD)
    {"proc_connections", psutil_proc_connections, METH_VARARGS,
     "Return connections opened by process"},
#endif
    {"proc_cwd", psutil_proc_cwd, METH_VARARGS,
     "Return process current working directory."},
#if defined(__FreeBSD_version) && __FreeBSD_version >= 800000 || PSUTIL_OPENBSD || defined(PSUTIL_NETBSD)
    {"proc_num_fds", psutil_proc_num_fds, METH_VARARGS,
     "Return the number of file descriptors opened by this process"},
    {"proc_open_files", psutil_proc_open_files, METH_VARARGS,
     "Return files opened by process as a list of (path, fd) tuples"},
#endif
#if defined(PSUTIL_FREEBSD) || defined(PSUTIL_NETBSD)
    {"proc_num_threads", psutil_proc_num_threads, METH_VARARGS,
     "Return number of threads used by process"},
#endif
#if defined(PSUTIL_FREEBSD)
    {"proc_exe", psutil_proc_exe, METH_VARARGS,
     "Return process pathname executable"},
    {"proc_memory_maps", psutil_proc_memory_maps, METH_VARARGS,
     "Return a list of tuples for every process's memory map"},
    {"proc_cpu_affinity_get", psutil_proc_cpu_affinity_get, METH_VARARGS,
     "Return process CPU affinity."},
    {"proc_cpu_affinity_set", psutil_proc_cpu_affinity_set, METH_VARARGS,
     "Set process CPU affinity."},
    {"cpu_count_phys", psutil_cpu_count_phys, METH_VARARGS,
     "Return an XML string to determine the number physical CPUs."},
#endif

    // --- system-related functions

    {"pids", psutil_pids, METH_VARARGS,
     "Returns a list of PIDs currently running on the system"},
    {"cpu_count_logical", psutil_cpu_count_logical, METH_VARARGS,
     "Return number of logical CPUs on the system"},
    {"virtual_mem", psutil_virtual_mem, METH_VARARGS,
     "Return system virtual memory usage statistics"},
    {"swap_mem", psutil_swap_mem, METH_VARARGS,
     "Return swap mem stats"},
    {"cpu_times", psutil_cpu_times, METH_VARARGS,
     "Return system cpu times as a tuple (user, system, nice, idle, irc)"},
    {"per_cpu_times", psutil_per_cpu_times, METH_VARARGS,
     "Return system per-cpu times as a list of tuples"},
    {"boot_time", psutil_boot_time, METH_VARARGS,
     "Return the system boot time expressed in seconds since the epoch."},
    {"disk_partitions", psutil_disk_partitions, METH_VARARGS,
     "Return a list of tuples including device, mount point and "
     "fs type for all partitions mounted on the system."},
    {"net_io_counters", psutil_net_io_counters, METH_VARARGS,
     "Return dict of tuples of networks I/O information."},
    {"disk_io_counters", psutil_disk_io_counters, METH_VARARGS,
     "Return a Python dict of tuples for disk I/O information"},
    {"users", psutil_users, METH_VARARGS,
     "Return currently connected users as a list of tuples"},
    {"cpu_stats", psutil_cpu_stats, METH_VARARGS,
     "Return CPU statistics"},
#if defined(PSUTIL_FREEBSD) || defined(PSUTIL_NETBSD)
    {"net_connections", psutil_net_connections, METH_VARARGS,
     "Return system-wide open connections."},
#endif
#if defined(PSUTIL_FREEBSD)
    {"sensors_battery", psutil_sensors_battery, METH_VARARGS,
     "Return battery information."},
    {"sensors_cpu_temperature", psutil_sensors_cpu_temperature, METH_VARARGS,
     "Return temperature information for a given CPU core number."},
    {"cpu_frequency", psutil_cpu_freq, METH_VARARGS,
     "Return frequency of a given CPU"},
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
        "_psutil_bsd",
        NULL,
        -1,
        mod_methods,
        NULL,
        NULL,
        NULL,
        NULL
    };

    PyObject *PyInit__psutil_bsd(void)
#else  /* PY_MAJOR_VERSION */
    #define INITERR return

    void init_psutil_bsd(void)
#endif  /* PY_MAJOR_VERSION */
{
    PyObject *v;
#if PY_MAJOR_VERSION >= 3
    PyObject *mod = PyModule_Create(&moduledef);
#else
    PyObject *mod = Py_InitModule("_psutil_bsd", mod_methods);
#endif
    if (mod == NULL)
        INITERR;

    if (PyModule_AddIntConstant(mod, "version", PSUTIL_VERSION)) INITERR;
    // process status constants

#ifdef PSUTIL_FREEBSD
    if (PyModule_AddIntConstant(mod, "SIDL", SIDL)) INITERR;
    if (PyModule_AddIntConstant(mod, "SRUN", SRUN)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSLEEP", SSLEEP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSTOP", SSTOP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SZOMB", SZOMB)) INITERR;
    if (PyModule_AddIntConstant(mod, "SWAIT", SWAIT)) INITERR;
    if (PyModule_AddIntConstant(mod, "SLOCK", SLOCK)) INITERR;
#elif  PSUTIL_OPENBSD
    if (PyModule_AddIntConstant(mod, "SIDL", SIDL)) INITERR;
    if (PyModule_AddIntConstant(mod, "SRUN", SRUN)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSLEEP", SSLEEP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSTOP", SSTOP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SZOMB", SZOMB)) INITERR; // unused
    if (PyModule_AddIntConstant(mod, "SDEAD", SDEAD)) INITERR;
    if (PyModule_AddIntConstant(mod, "SONPROC", SONPROC)) INITERR;
#elif defined(PSUTIL_NETBSD)
    if (PyModule_AddIntConstant(mod, "SIDL", LSIDL)) INITERR;
    if (PyModule_AddIntConstant(mod, "SRUN", LSRUN)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSLEEP", LSSLEEP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SSTOP", LSSTOP)) INITERR;
    if (PyModule_AddIntConstant(mod, "SZOMB", LSZOMB)) INITERR;
    if (PyModule_AddIntConstant(mod, "SDEAD", LSDEAD)) INITERR;
    if (PyModule_AddIntConstant(mod, "SONPROC", LSONPROC)) INITERR;
    // unique to NetBSD
    if (PyModule_AddIntConstant(mod, "SSUSPENDED", LSSUSPENDED)) INITERR;
#endif

    // connection status constants
    if (PyModule_AddIntConstant(mod, "TCPS_CLOSED", TCPS_CLOSED))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_CLOSING", TCPS_CLOSING))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_CLOSE_WAIT", TCPS_CLOSE_WAIT))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_LISTEN", TCPS_LISTEN))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_ESTABLISHED", TCPS_ESTABLISHED))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_SYN_SENT", TCPS_SYN_SENT))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_SYN_RECEIVED", TCPS_SYN_RECEIVED))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_FIN_WAIT_1", TCPS_FIN_WAIT_1))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_FIN_WAIT_2", TCPS_FIN_WAIT_2))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_LAST_ACK", TCPS_LAST_ACK))
        INITERR;
    if (PyModule_AddIntConstant(mod, "TCPS_TIME_WAIT", TCPS_TIME_WAIT))
        INITERR;
    // PSUTIL_CONN_NONE
    if (PyModule_AddIntConstant(mod, "PSUTIL_CONN_NONE", 128)) INITERR;

    psutil_setup();

    if (mod == NULL)
        INITERR;
#if PY_MAJOR_VERSION >= 3
    return mod;
#endif
}
