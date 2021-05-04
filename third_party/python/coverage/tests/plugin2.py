# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""A file tracer plugin for test_plugins.py to import."""

import os.path

import coverage


class Plugin(coverage.CoveragePlugin):
    """A file tracer plugin for testing."""
    def file_tracer(self, filename):
        if "render.py" in filename:
            return RenderFileTracer()
        return None

    def file_reporter(self, filename):
        return FileReporter(filename)


class RenderFileTracer(coverage.FileTracer):
    """A FileTracer using information from the caller."""

    def has_dynamic_source_filename(self):
        return True

    def dynamic_source_filename(self, filename, frame):
        if frame.f_code.co_name != "render":
            return None
        source_filename = os.path.abspath(frame.f_locals['filename'])
        return source_filename

    def line_number_range(self, frame):
        lineno = frame.f_locals['linenum']
        return lineno, lineno+1


class FileReporter(coverage.FileReporter):
    """A goofy file reporter."""
    def lines(self):
        # Goofy test arrangement: claim that the file has as many lines as the
        # number in its name.
        num = os.path.basename(self.filename).split(".")[0].split("_")[1]
        return set(range(1, int(num)+1))


def coverage_init(reg, options):        # pylint: disable=unused-argument
    """Called by coverage to initialize the plugins here."""
    reg.add_file_tracer(Plugin())
