
"crash" ping
============

This ping is captured after the main Firefox process crashes, whether or not the crash report is submitted to crash-stats.mozilla.org. It includes non-identifying metadata about the crash.

The environment block that is sent with this ping varies: if Firefox was running long enough to record the environment block before the crash, then the environment at the time of the crash will be recorded and ``hasCrashEnvironment`` will be true. If Firefox crashed before the environment was recorded, ``hasCrashEnvironment`` will be false and the recorded environment will be the environment at time of submission.

The client ID is submitted with this ping.

Structure:

.. code-block:: js

    {
      version: 1,
      type: "crash",
      ... common ping data
      clientId: <UUID>,
      environment: { ... },
      payload: {
        crashDate: "YYYY-MM-DD",
        sessionId: <UUID>, // may be missing for crashes that happen early
                           // in startup. Added in Firefox 48 with the
                           // intention of uplifting to Firefox 46
        crashId: <UUID>, // Optional, ID of the associated crash
        stackTraces: { ... }, // Optional, see below
        metadata: { // Annotations saved while Firefox was running. See nsExceptionHandler.cpp for more information
          ProductName: "Firefox",
          ReleaseChannel: <channel>,
          Version: <version number>,
          BuildID: "YYYYMMDDHHMMSS",
          AvailablePageFile: <size>, // Windows-only, available paging file
          AvailablePhysicalMemory: <size>, // Windows-only, available physical memory
          AvailableVirtualMemory: <size>, // Windows-only, available virtual memory
          BlockedDllList: <list>, // Windows-only, see WindowsDllBlocklist.cpp for details
          BlocklistInitFailed: 1, // Windows-only, present only if the DLL blocklist initialization failed
          CrashTime: <time>, // Seconds since the Epoch
          ContainsMemoryReport: 1, // Optional
          EventLoopNestingLevel: <levels>, // Optional, present only if >0
          IsGarbageCollecting: 1, // Optional, present only if set to 1
          MozCrashReason: <reason>, // Optional, contains the string passed to MOZ_CRASH()
          OOMAllocationSize: <size>, // Size of the allocation that caused an OOM
          SecondsSinceLastCrash: <duration>, // Seconds elapsed since the last crash occurred
          SystemMemoryUsePercentage: <percentage>, // Windows-only, percent of memory in use
          TelemetrySessionId: <id>, // Active telemetry session ID when the crash was recorded
          TextureUsage: <usage>, // Optional, usage of texture memory in bytes
          TotalPageFile: <size>, // Windows-only, paging file in use
          TotalPhysicalMemory: <size>, // Windows-only, physical memory in use
          TotalVirtualMemory: <size>, // Windows-only, virtual memory in use
          UptimeTS: <duration>, // Seconds since Firefox was started
          User32BeforeBlocklist: 1, // Windows-only, present only if user32.dll was loaded before the DLL blocklist has been initialized
        },
        hasCrashEnvironment: bool
      }
    }

Stack Traces
------------

The crash ping may contain a ``stackTraces`` field which has been populated
with stack traces for all threads in the crashed process. The format of this
field is similar to the one used by Socorro for representing a crash. The main
differences are that redundant fields are not stored and that the module a
frame belongs to is referenced by index in the module array rather than by its
file name.

Note that this field does not contain data from the application; only bare
stack traces and module lists are stored.

.. code-block:: js

    {
      status: <string>, // Status of the analysis, "OK" or an error message
      crash_info: { // Basic crash information
        type: <string>, // Type of crash, SIGSEGV, assertion, etc...
        address: <addr>, // Crash address crash, hex format, see the notes below
        crashing_thread: <index> // Index in the thread array below
      },
      main_module: <index>, // Index of Firefox' executable in the module list
      modules: [{
        base_addr: <addr>, // Base address of the module, hex format
        end_addr: <addr>, // End address of the module, hex format
        code_id: <string>, // Unique ID of this module, see the notes below
        debug_file: <string>, // Name of the file holding the debug information
        debug_id: <string>, // ID or hash of the debug information file
        filename: <string>, // File name
        version: <string>, // Library/executable version
      },
      ... // List of modules ordered by base memory address
      ],
      threads: [{ // Stack traces for every thread
        frames: [{
          module_index: <index>, // Index of the module this frame belongs to
          ip: <ip>, // Program counter, hex format
          trust: <string> // Trust of this frame, see the notes below
        },
        ... // List of frames, the first frame is the topmost
        ]
      }]
    }

Notes
~~~~~

Memory addresses and instruction pointers are always stored as strings in
hexadecimal format (e.g. "0x4000"). They can be made of up to 16 characters for
64-bit addresses.

The crash type is both OS and CPU dependent and can be either a descriptive
string (e.g. SIGSEGV, EXCEPTION_ACCESS_VIOLATION) or a raw numeric value. The
crash address meaning depends on the type of crash. In a segmentation fault the
crash address will be the memory address whose access caused the fault; in a
crash triggered by an illegal instruction exception the address will be the
instruction pointer where the invalid instruction resides.
See `breakpad <https://chromium.googlesource.com/breakpad/breakpad/+/c99d374dde62654a024840accfb357b2851daea0/src/processor/minidump_processor.cc#675>`_'s
relevant code for further information.

Since it's not always possible to establish with certainty the address of the
previous frame while walking the stack, every frame has a trust value that
represents how it was found and thus how certain we are that it's a real frame.
The trust levels are (from least trusted to most trusted):

+---------------+---------------------------------------------------+
| Trust         | Description                                       |
+===============+===================================================+
| context       | Given as instruction pointer in a context         |
+---------------+---------------------------------------------------+
| prewalked     | Explicitly provided by some external stack walker |
+---------------+---------------------------------------------------+
| cfi           | Derived from call frame info                      |
+---------------+---------------------------------------------------+
| frame_pointer | Derived from frame pointer                        |
+---------------+---------------------------------------------------+
| cfi_scan      | Found while scanning stack using call frame info  |
+---------------+---------------------------------------------------+
| scan          | Scanned the stack, found this                     |
+---------------+---------------------------------------------------+
| none          | Unknown, this is most likely not a valid frame    |
+---------------+---------------------------------------------------+

The ``code_id`` field holds a unique ID used to distinguish between different
versions and builds of the same module. See `breakpad <https://chromium.googlesource.com/breakpad/breakpad/+/24f5931c5e0120982c0cbf1896641e3ef2bdd52f/src/google_breakpad/processor/code_module.h#60>`_'s
description for further information. This field is populated only on Windows.
