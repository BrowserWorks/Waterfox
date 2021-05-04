# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""A file tracer plugin for test_plugins.py to import."""

import os.path

import coverage


class Plugin(coverage.CoveragePlugin):
    """A file tracer plugin to import, so that it isn't in the test's current directory."""

    def file_tracer(self, filename):
        """Trace only files named xyz.py"""
        if "xyz.py" in filename:
            return FileTracer(filename)
        return None

    def file_reporter(self, filename):
        return FileReporter(filename)


class FileTracer(coverage.FileTracer):
    """A FileTracer emulating a simple static plugin."""

    def __init__(self, filename):
        """Claim that */*xyz.py was actually sourced from /src/*ABC.zz"""
        self._filename = filename
        self._source_filename = os.path.join(
            "/src",
            os.path.basename(filename.replace("xyz.py", "ABC.zz"))
        )

    def source_filename(self):
        return self._source_filename

    def line_number_range(self, frame):
        """Map the line number X to X05,X06,X07."""
        lineno = frame.f_lineno
        return lineno*100+5, lineno*100+7


class FileReporter(coverage.FileReporter):
    """Dead-simple FileReporter."""
    def lines(self):
        return set([105, 106, 107, 205, 206, 207])


def coverage_init(reg, options):        # pylint: disable=unused-argument
    """Called by coverage to initialize the plugins here."""
    reg.add_file_tracer(Plugin())
