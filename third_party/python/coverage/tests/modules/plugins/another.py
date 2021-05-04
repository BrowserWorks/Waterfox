# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""A plugin for tests to reference."""

from coverage import CoveragePlugin


class Plugin(CoveragePlugin):
    pass


def coverage_init(reg, options):
    reg.add_file_tracer(Plugin())
