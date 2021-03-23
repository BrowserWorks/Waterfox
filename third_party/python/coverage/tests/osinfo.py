# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""OS information for testing."""

from coverage import env


if env.WINDOWS:
    # Windows implementation
    def process_ram():
        """How much RAM is this process using? (Windows)"""
        import ctypes
        # From: http://lists.ubuntu.com/archives/bazaar-commits/2009-February/011990.html
        class PROCESS_MEMORY_COUNTERS_EX(ctypes.Structure):
            """Used by GetProcessMemoryInfo"""
            _fields_ = [
                ('cb', ctypes.c_ulong),
                ('PageFaultCount', ctypes.c_ulong),
                ('PeakWorkingSetSize', ctypes.c_size_t),
                ('WorkingSetSize', ctypes.c_size_t),
                ('QuotaPeakPagedPoolUsage', ctypes.c_size_t),
                ('QuotaPagedPoolUsage', ctypes.c_size_t),
                ('QuotaPeakNonPagedPoolUsage', ctypes.c_size_t),
                ('QuotaNonPagedPoolUsage', ctypes.c_size_t),
                ('PagefileUsage', ctypes.c_size_t),
                ('PeakPagefileUsage', ctypes.c_size_t),
                ('PrivateUsage', ctypes.c_size_t),
            ]

        mem_struct = PROCESS_MEMORY_COUNTERS_EX()
        ret = ctypes.windll.psapi.GetProcessMemoryInfo(
            ctypes.windll.kernel32.GetCurrentProcess(),
            ctypes.byref(mem_struct),
            ctypes.sizeof(mem_struct)
        )
        if not ret:                 # pragma: part covered
            return 0                # pragma: cant happen
        return mem_struct.PrivateUsage

elif env.LINUX:
    # Linux implementation
    import os

    _scale = {'kb': 1024, 'mb': 1024*1024}

    def _VmB(key):
        """Read the /proc/PID/status file to find memory use."""
        try:
            # Get pseudo file /proc/<pid>/status
            with open('/proc/%d/status' % os.getpid()) as t:
                v = t.read()
        except IOError:             # pragma: cant happen
            return 0    # non-Linux?
        # Get VmKey line e.g. 'VmRSS:  9999  kB\n ...'
        i = v.index(key)
        v = v[i:].split(None, 3)
        if len(v) < 3:              # pragma: part covered
            return 0                # pragma: cant happen
        # Convert Vm value to bytes.
        return int(float(v[1]) * _scale[v[2].lower()])

    def process_ram():
        """How much RAM is this process using? (Linux implementation)"""
        return _VmB('VmRSS')

else:
    # Generic implementation.
    def process_ram():
        """How much RAM is this process using? (stdlib implementation)"""
        import resource
        return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
