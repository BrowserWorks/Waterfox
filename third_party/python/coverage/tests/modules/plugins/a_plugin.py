"""A plugin for tests to reference."""

from coverage import CoveragePlugin


class Plugin(CoveragePlugin):
    pass


def coverage_init(reg, options):
    reg.add_file_tracer(Plugin())
