// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/base_switches.h"
#include "build/build_config.h"

namespace switches {

// Delays execution of base::TaskPriority::BEST_EFFORT tasks until shutdown.
const char kDisableBestEffortTasks[] = "disable-best-effort-tasks";

// Disables the crash reporting.
const char kDisableBreakpad[]               = "disable-breakpad";

// Comma-separated list of feature names to disable. See also kEnableFeatures.
const char kDisableFeatures[] = "disable-features";

// Indicates that crash reporting should be enabled. On platforms where helper
// processes cannot access to files needed to make this decision, this flag is
// generated internally.
const char kEnableCrashReporter[]           = "enable-crash-reporter";

// Comma-separated list of feature names to enable. See also kDisableFeatures.
const char kEnableFeatures[] = "enable-features";

// Generates full memory crash dump.
const char kFullMemoryCrashReport[]         = "full-memory-crash-report";

// Force low-end device mode when set.
const char kEnableLowEndDeviceMode[]        = "enable-low-end-device-mode";

// Force disabling of low-end device mode when set.
const char kDisableLowEndDeviceMode[]       = "disable-low-end-device-mode";

// This option can be used to force field trials when testing changes locally.
// The argument is a list of name and value pairs, separated by slashes. If a
// trial name is prefixed with an asterisk, that trial will start activated.
// For example, the following argument defines two trials, with the second one
// activated: "GoogleNow/Enable/*MaterialDesignNTP/Default/" This option can
// also be used by the browser process to send the list of trials to a
// non-browser process, using the same format. See
// FieldTrialList::CreateTrialsFromString() in field_trial.h for details.
const char kForceFieldTrials[]              = "force-fieldtrials";

// Suppresses all error dialogs when present.
const char kNoErrorDialogs[]                = "noerrdialogs";

// When running certain tests that spawn child processes, this switch indicates
// to the test framework that the current process is a child process.
const char kTestChildProcess[]              = "test-child-process";

// When running certain tests that spawn child processes, this switch indicates
// to the test framework that the current process should not initialize ICU to
// avoid creating any scoped handles too early in startup.
const char kTestDoNotInitializeIcu[]        = "test-do-not-initialize-icu";

// Gives the default maximal active V-logging level; 0 is the default.
// Normally positive values are used for V-logging levels.
const char kV[]                             = "v";

// Gives the per-module maximal V-logging levels to override the value
// given by --v.  E.g. "my_module=2,foo*=3" would change the logging
// level for all code in source files "my_module.*" and "foo*.*"
// ("-inl" suffixes are also disregarded for this matching).
//
// Any pattern containing a forward or backward slash will be tested
// against the whole pathname and not just the module.  E.g.,
// "*/foo/bar/*=2" would change the logging level for all code in
// source files under a "foo/bar" directory.
const char kVModule[]                       = "vmodule";

// Will wait for 60 seconds for a debugger to come to attach to the process.
const char kWaitForDebugger[]               = "wait-for-debugger";

// Sends trace events from these categories to a file.
// --trace-to-file on its own sends to default categories.
const char kTraceToFile[]                   = "trace-to-file";

// Specifies the file name for --trace-to-file. If unspecified, it will
// go to a default file name.
const char kTraceToFileName[]               = "trace-to-file-name";

// Starts the sampling based profiler for the browser process at startup. This
// will only work if chrome has been built with the gn arg enable_profiling =
// true. The output will go to the value of kProfilingFile.
const char kProfilingAtStart[] = "profiling-at-start";

// Specifies a location for profiling output. This will only work if chrome has
// been built with the gyp variable profiling=1 or gn arg enable_profiling=true.
//
//   {pid} if present will be replaced by the pid of the process.
//   {count} if present will be incremented each time a profile is generated
//           for this process.
// The default is chrome-profile-{pid} for the browser and test-profile-{pid}
// for tests.
const char kProfilingFile[] = "profiling-file";

// Controls whether profile data is periodically flushed to a file. Normally
// the data gets written on exit but cases exist where chromium doesn't exit
// cleanly (especially when using single-process). A time in seconds can be
// specified.
const char kProfilingFlush[] = "profiling-flush";

#if defined(OS_WIN)
// Disables the USB keyboard detection for blocking the OSK on Win8+.
const char kDisableUsbKeyboardDetect[]      = "disable-usb-keyboard-detect";
#endif

#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
// The /dev/shm partition is too small in certain VM environments, causing
// Chrome to fail or crash (see http://crbug.com/715363). Use this flag to
// work-around this issue (a temporary directory will always be used to create
// anonymous shared memory files).
const char kDisableDevShmUsage[] = "disable-dev-shm-usage";
#endif

#if defined(OS_POSIX)
// Used for turning on Breakpad crash reporting in a debug environment where
// crash reporting is typically compiled but disabled.
const char kEnableCrashReporterForTesting[] =
    "enable-crash-reporter-for-testing";
#endif

#if defined(OS_ANDROID)
// Enables the reached code profiler that samples all threads in all processes
// to determine which functions are almost never executed.
const char kEnableReachedCodeProfiler[] = "enable-reached-code-profiler";

// Specifies optimization of memory layout of the native library using the
// orderfile symbols given in base/android/library_loader/anchor_functions.h,
// via madvise and changing the library prefetch behavior.
//
// If this switch is not specified, an optimization may be done depending on a
// synthetic trial. If specified, its values may be 'on' or 'off'. These
// override the synthetic trial.
//
// This flag is only used on architectures with SUPPORTS_CODE_ORDERING defined.
const char kOrderfileMemoryOptimization[] = "orderfile-memory-optimization";
#endif

}  // namespace switches
