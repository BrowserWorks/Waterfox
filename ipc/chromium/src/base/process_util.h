/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
// Copyright (c) 2009 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file/namespace contains utility functions for enumerating, ending and
// computing statistics of processes.

#ifndef BASE_PROCESS_UTIL_H_
#define BASE_PROCESS_UTIL_H_

#include "base/basictypes.h"

#if defined(OS_WIN)
#include <windows.h>
#include <tlhelp32.h>
#include <io.h>
#ifndef STDOUT_FILENO
#define STDOUT_FILENO 1
#endif
#elif defined(OS_LINUX) || defined(__GLIBC__)
#include <dirent.h>
#include <limits.h>
#include <sys/types.h>
#elif defined(OS_MACOSX)
#include <mach/mach.h>
#endif

#include <map>
#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#ifndef OS_WIN
#include <unistd.h>
#endif

#include "base/command_line.h"
#include "base/process.h"

#if defined(OS_WIN)
typedef PROCESSENTRY32 ProcessEntry;
typedef IO_COUNTERS IoCounters;
#elif defined(OS_POSIX)
// TODO(port): we should not rely on a Win32 structure.
struct ProcessEntry {
  int pid;
  int ppid;
  char szExeFile[NAME_MAX + 1];
};

struct IoCounters {
  unsigned long long ReadOperationCount;
  unsigned long long WriteOperationCount;
  unsigned long long OtherOperationCount;
  unsigned long long ReadTransferCount;
  unsigned long long WriteTransferCount;
  unsigned long long OtherTransferCount;
};

#include "base/file_descriptor_shuffle.h"
#endif

#if defined(OS_MACOSX)
struct kinfo_proc;
#endif

namespace base {

// These can be used in a 32-bit bitmask.
enum ProcessArchitecture {
  PROCESS_ARCH_I386 = 0x1,
  PROCESS_ARCH_X86_64 = 0x2,
  PROCESS_ARCH_PPC = 0x4,
  PROCESS_ARCH_ARM = 0x8,
  PROCESS_ARCH_MIPS = 0x10,
  PROCESS_ARCH_ARM64 = 0x20
};

inline ProcessArchitecture GetCurrentProcessArchitecture()
{
  base::ProcessArchitecture currentArchitecture;
#if defined(ARCH_CPU_X86)
  currentArchitecture = base::PROCESS_ARCH_I386;
#elif defined(ARCH_CPU_X86_64)
  currentArchitecture = base::PROCESS_ARCH_X86_64;
#elif defined(ARCH_CPU_PPC)
  currentArchitecture = base::PROCESS_ARCH_PPC;
#elif defined(ARCH_CPU_ARMEL)
  currentArchitecture = base::PROCESS_ARCH_ARM;
#elif defined(ARCH_CPU_MIPS)
  currentArchitecture = base::PROCESS_ARCH_MIPS;
#elif defined(ARCH_CPU_ARM64)
  currentArchitecture = base::PROCESS_ARCH_ARM64;
#endif
  return currentArchitecture;
}

// A minimalistic but hopefully cross-platform set of exit codes.
// Do not change the enumeration values or you will break third-party
// installers.
enum {
  PROCESS_END_NORMAL_TERMINATON = 0,
  PROCESS_END_KILLED_BY_USER    = 1,
  PROCESS_END_PROCESS_WAS_HUNG  = 2
};

// Returns the id of the current process.
ProcessId GetCurrentProcId();

// Returns the ProcessHandle of the current process.
ProcessHandle GetCurrentProcessHandle();

// Converts a PID to a process handle. This handle must be closed by
// CloseProcessHandle when you are done with it. Returns true on success.
bool OpenProcessHandle(ProcessId pid, ProcessHandle* handle);

// Converts a PID to a process handle. On Windows the handle is opened
// with more access rights and must only be used by trusted code.
// You have to close returned handle using CloseProcessHandle. Returns true
// on success.
bool OpenPrivilegedProcessHandle(ProcessId pid, ProcessHandle* handle);

// Closes the process handle opened by OpenProcessHandle.
void CloseProcessHandle(ProcessHandle process);

// Returns the unique ID for the specified process. This is functionally the
// same as Windows' GetProcessId(), but works on versions of Windows before
// Win XP SP1 as well.
ProcessId GetProcId(ProcessHandle process);

#if defined(OS_POSIX)
// Sets all file descriptors to close on exec except for stdin, stdout
// and stderr.
// TODO(agl): remove this function
// WARNING: do not use. It's inherently race-prone in the face of
// multi-threading.
void SetAllFDsToCloseOnExec();
// Close all file descriptors, expect those which are a destination in the
// given multimap. Only call this function in a child process where you know
// that there aren't any other threads.
void CloseSuperfluousFds(const base::InjectiveMultimap& saved_map);
#endif

enum ChildPrivileges {
  PRIVILEGES_DEFAULT,
  PRIVILEGES_UNPRIVILEGED,
  PRIVILEGES_INHERIT,
  PRIVILEGES_LAST
};

#if defined(OS_WIN)
// Runs the given application name with the given command line. Normally, the
// first command line argument should be the path to the process, and don't
// forget to quote it.
//
// If wait is true, it will block and wait for the other process to finish,
// otherwise, it will just continue asynchronously.
//
// Example (including literal quotes)
//  cmdline = "c:\windows\explorer.exe" -foo "c:\bar\"
//
// If process_handle is non-NULL, the process handle of the launched app will be
// stored there on a successful launch.
// NOTE: In this case, the caller is responsible for closing the handle so
//       that it doesn't leak!
bool LaunchApp(const std::wstring& cmdline,
               bool wait, bool start_hidden, ProcessHandle* process_handle);
#elif defined(OS_POSIX)
// Runs the application specified in argv[0] with the command line argv.
// Before launching all FDs open in the parent process will be marked as
// close-on-exec.  |fds_to_remap| defines a mapping of src fd->dest fd to
// propagate FDs into the child process.
//
// As above, if wait is true, execute synchronously. The pid will be stored
// in process_handle if that pointer is non-null.
//
// Note that the first argument in argv must point to the filename,
// and must be fully specified.
typedef std::vector<std::pair<int, int> > file_handle_mapping_vector;
bool LaunchApp(const std::vector<std::string>& argv,
               const file_handle_mapping_vector& fds_to_remap,
               bool wait, ProcessHandle* process_handle);

typedef std::map<std::string, std::string> environment_map;
bool LaunchApp(const std::vector<std::string>& argv,
               const file_handle_mapping_vector& fds_to_remap,
               const environment_map& env_vars_to_set,
               ChildPrivileges privs,
               bool wait, ProcessHandle* process_handle,
               ProcessArchitecture arch=GetCurrentProcessArchitecture());
bool LaunchApp(const std::vector<std::string>& argv,
               const file_handle_mapping_vector& fds_to_remap,
               const environment_map& env_vars_to_set,
               bool wait, ProcessHandle* process_handle,
               ProcessArchitecture arch=GetCurrentProcessArchitecture());
#endif

// Adjust the privileges of this process to match |privs|.  Only
// returns if privileges were successfully adjusted.
void SetCurrentProcessPrivileges(ChildPrivileges privs);

// Executes the application specified by cl. This function delegates to one
// of the above two platform-specific functions.
bool LaunchApp(const CommandLine& cl,
               bool wait, bool start_hidden, ProcessHandle* process_handle);

// Used to filter processes by process ID.
class ProcessFilter {
 public:
  // Returns true to indicate set-inclusion and false otherwise.  This method
  // should not have side-effects and should be idempotent.
  virtual bool Includes(ProcessId pid, ProcessId parent_pid) const = 0;
  virtual ~ProcessFilter() { }
};

// Attempts to kill the process identified by the given process
// entry structure, giving it the specified exit code. If |wait| is true, wait
// for the process to be actually terminated before returning.
// Returns true if this is successful, false otherwise.
bool KillProcess(ProcessHandle process, int exit_code, bool wait);

// Get the termination status (exit code) of the process and return true if the
// status indicates the process crashed. |child_exited| is set to true iff the
// child process has terminated. (|child_exited| may be NULL.)
//
// On Windows, it is an error to call this if the process hasn't terminated
// yet. On POSIX, |child_exited| is set correctly since we detect terminate in
// a different manner on POSIX.
bool DidProcessCrash(bool* child_exited, ProcessHandle handle);

// Provides performance metrics for a specified process (CPU usage, memory and
// IO counters). To use it, invoke CreateProcessMetrics() to get an instance
// for a specific process, then access the information with the different get
// methods.
class ProcessMetrics {
 public:
  // Creates a ProcessMetrics for the specified process.
  // The caller owns the returned object.
  static ProcessMetrics* CreateProcessMetrics(ProcessHandle process);

  ~ProcessMetrics();

  // Returns the CPU usage in percent since the last time this method was
  // called. The first time this method is called it returns 0 and will return
  // the actual CPU info on subsequent calls.
  // Note that on multi-processor machines, the CPU usage value is for all
  // CPUs. So if you have 2 CPUs and your process is using all the cycles
  // of 1 CPU and not the other CPU, this method returns 50.
  int GetCPUUsage();

 private:
  explicit ProcessMetrics(ProcessHandle process);

  ProcessHandle process_;

  int processor_count_;

  // Used to store the previous times so we can compute the CPU usage.
  int64_t last_time_;
  int64_t last_system_time_;

  DISALLOW_EVIL_CONSTRUCTORS(ProcessMetrics);
};

}  // namespace base

namespace mozilla {

class EnvironmentLog
{
public:
  explicit EnvironmentLog(const char* varname) {
    const char *e = getenv(varname);
    if (e && *e) {
      fname_ = e;
    }
  }

  ~EnvironmentLog() {}

  void print(const char* format, ...) {
    if (!fname_.size())
      return;

    FILE* f;
    if (fname_.compare("-") == 0) {
      f = fdopen(dup(STDOUT_FILENO), "a");
    } else {
      f = fopen(fname_.c_str(), "a");
    }

    if (!f)
      return;

    va_list a;
    va_start(a, format);
    vfprintf(f, format, a);
    va_end(a);
    fclose(f);
  }

private:
  std::string fname_;

  DISALLOW_EVIL_CONSTRUCTORS(EnvironmentLog);
};

} // namespace mozilla

#if defined(OS_WIN)
// Undo the windows.h damage
#undef GetMessage
#undef CreateEvent
#undef GetClassName
#undef GetBinaryType
#undef RemoveDirectory
#endif

#endif  // BASE_PROCESS_UTIL_H_
