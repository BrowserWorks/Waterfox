/*
 * LIBORC - Library of Optimized Inner Loops
 * Copyright (c) 2003,2004 David A. Schleef <ds@schleef.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <orc/orc.h>

#if defined(__linux__)
#include <linux/auxvec.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#ifndef PPC_FEATURE_HAS_ALTIVEC
/* From linux-2.6/include/asm-powerpc/cputable.h */
#define PPC_FEATURE_HAS_ALTIVEC 0x10000000
#endif

#endif

#if defined(__FreeBSD__) || defined(__APPLE__)
#include <sys/types.h>
#include <sys/sysctl.h>
#endif

#if defined(__OpenBSD__)
#include <sys/param.h>
#include <sys/sysctl.h>
#include <machine/cpu.h>
#endif

/***** powerpc *****/

#if 0
static unsigned long
orc_profile_stamp_tb(void)
{
  unsigned long ts;
  __asm__ __volatile__("mftb %0\n" : "=r" (ts));
  return ts;
}
#endif

#if !defined(__FreeBSD__) && !defined(__FreeBSD_kernel__) && !defined(__OpenBSD__) && !defined(__APPLE__) && !defined(__linux__)
static void
test_altivec (void * ignored)
{
  asm volatile ("vor v0, v0, v0\n");
}
#endif

#if defined(__APPLE__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
#if defined(__APPLE__)
#define SYSCTL "hw.vectorunit"
#else
#define SYSCTL "hw.altivec"
#endif

static unsigned long
orc_check_altivec_sysctl_bsd (void)
{
  unsigned long cpu_flags = 0;
  int ret, vu;
  size_t len;

  len = sizeof(vu);
  ret = sysctlbyname(SYSCTL, &vu, &len, NULL, 0);
  if (!ret && vu) {
    cpu_flags |= ORC_TARGET_ALTIVEC_ALTIVEC;
  }

  return cpu_flags;
}
#endif

#if defined(__OpenBSD__)
static unsigned long
orc_check_altivec_sysctl_openbsd (void)
{
  unsigned long cpu_flags = 0;
  int mib[2], ret, vu;
  size_t len;

  mib[0] = CTL_MACHDEP;
  mib[1] = CPU_ALTIVEC;

  len = sizeof(vu);
  ret = sysctl(mib, 2, &vu, &len, NULL, 0);
  if (!ret && vu) {
    cpu_flags |= ORC_TARGET_ALTIVEC_ALTIVEC;
  }

  return cpu_flags;
}
#endif

#if defined(__linux__)
static unsigned long
orc_check_altivec_proc_auxv (void)
{
  unsigned long cpu_flags = 0;
  static int available = -1;
  int new_avail = 0;
  unsigned long buf[64];
  ssize_t count;
  int fd, i;

  /* Flags already set */
  if (available != -1) {
    return 0;
  }

  fd = open("/proc/self/auxv", O_RDONLY);
  if (fd < 0) {
    goto out;
  }

more:
  count = read(fd, buf, sizeof(buf));
  if (count < 0) {
    goto out_close;
  }

  for (i=0; i < (count / sizeof(unsigned long)); i += 2) {
    if (buf[i] == AT_HWCAP) {
      new_avail = !!(buf[i+1] & PPC_FEATURE_HAS_ALTIVEC);
      goto out_close;
    } else if (buf[i] == AT_NULL) {
      goto out_close;
    }
  }

  if (count == sizeof(buf)) {
    goto more;
  }

out_close:
  close(fd);

out:
  available = new_avail;
  if (available) {
    cpu_flags |= ORC_TARGET_ALTIVEC_ALTIVEC;
  }

  return cpu_flags;
}
#endif

#if !defined(__FreeBSD__) && !defined(__FreeBSD_kernel__) && !defined(__OpenBSD__) && !defined(__APPLE__) && !defined(__linux__)
static void
orc_check_altivec_fault (void)
{
  orc_fault_check_enable ();
  if (orc_fault_check_try(test_altivec, NULL)) {
    ORC_DEBUG ("cpu flag altivec");
    orc_cpu_flags |= ORC_IMPL_FLAG_ALTIVEC;
  }
  orc_fault_check_disable ();
}
#endif

void
orc_cpu_detect_arch(void)
{
#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(__APPLE__)
  orc_check_altivec_sysctl_bsd();
#elif defined(__OpenBSD__)
  orc_check_altivec_sysctl_openbsd();
#elif defined(__linux__)
  orc_check_altivec_proc_auxv();
#else
  orc_check_altivec_fault();
#endif

  /* _orc_profile_stamp = orc_profile_stamp_tb; */
}



