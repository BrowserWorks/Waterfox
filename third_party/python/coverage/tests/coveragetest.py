# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Base test case class for coverage.py testing."""

import contextlib
import datetime
import functools
import glob
import os
import os.path
import random
import re
import shlex
import sys
import types

import pytest
from unittest_mixins import (
    EnvironmentAwareMixin, StdStreamCapturingMixin, TempDirMixin,
    DelayedAssertionMixin,
)

import coverage
from coverage import env
from coverage.backunittest import TestCase, unittest
from coverage.backward import StringIO, import_local_file, string_class, shlex_quote
from coverage.cmdline import CoverageScript
from coverage.misc import StopEverything

from tests.helpers import arcs_to_arcz_repr, arcz_to_arcs
from tests.helpers import run_command, SuperModuleCleaner


# Status returns for the command line.
OK, ERR = 0, 1

# The coverage/tests directory, for all sorts of finding test helping things.
TESTS_DIR = os.path.dirname(__file__)


def convert_skip_exceptions(method):
    """A decorator for test methods to convert StopEverything to SkipTest."""
    @functools.wraps(method)
    def _wrapper(*args, **kwargs):
        try:
            result = method(*args, **kwargs)
        except StopEverything:
            raise unittest.SkipTest("StopEverything!")
        return result
    return _wrapper


class SkipConvertingMetaclass(type):
    """Decorate all test methods to convert StopEverything to SkipTest."""
    def __new__(cls, name, bases, attrs):
        for attr_name, attr_value in attrs.items():
            if attr_name.startswith('test_') and isinstance(attr_value, types.FunctionType):
                attrs[attr_name] = convert_skip_exceptions(attr_value)

        return super(SkipConvertingMetaclass, cls).__new__(cls, name, bases, attrs)


CoverageTestMethodsMixin = SkipConvertingMetaclass('CoverageTestMethodsMixin', (), {})

class CoverageTest(
    EnvironmentAwareMixin,
    StdStreamCapturingMixin,
    TempDirMixin,
    DelayedAssertionMixin,
    CoverageTestMethodsMixin,
    TestCase,
):
    """A base class for coverage.py test cases."""

    # Standard unittest setting: show me diffs even if they are very long.
    maxDiff = None

    # Tell newer unittest implementations to print long helpful messages.
    longMessage = True

    # Let stderr go to stderr, pytest will capture it for us.
    show_stderr = True

    # Temp dirs go to $TMPDIR/coverage_test/*
    temp_dir_prefix = "coverage_test/"
    if os.getenv('COVERAGE_ENV_ID'):
        temp_dir_prefix += "{}/".format(os.getenv('COVERAGE_ENV_ID'))

    # Keep the temp directories if the env says to.
    # $set_env.py: COVERAGE_KEEP_TMP - Keep the temp directories made by tests.
    keep_temp_dir = bool(int(os.getenv("COVERAGE_KEEP_TMP", "0")))

    def setUp(self):
        super(CoverageTest, self).setUp()

        self.module_cleaner = SuperModuleCleaner()

        # Attributes for getting info about what happened.
        self.last_command_status = None
        self.last_command_output = None
        self.last_module_name = None

    def clean_local_file_imports(self):
        """Clean up the results of calls to `import_local_file`.

        Use this if you need to `import_local_file` the same file twice in
        one test.

        """
        self.module_cleaner.clean_local_file_imports()

    def start_import_stop(self, cov, modname, modfile=None):
        """Start coverage, import a file, then stop coverage.

        `cov` is started and stopped, with an `import_local_file` of
        `modname` in the middle. `modfile` is the file to import as `modname`
        if it isn't in the current directory.

        The imported module is returned.

        """
        cov.start()
        try:                                    # pragma: nested
            # Import the Python file, executing it.
            mod = import_local_file(modname, modfile)
        finally:                                # pragma: nested
            # Stop coverage.py.
            cov.stop()
        return mod

    def get_module_name(self):
        """Return a random module name to use for this test run."""
        self.last_module_name = 'coverage_test_' + str(random.random())[2:]
        return self.last_module_name

    def assert_equal_arcs(self, a1, a2, msg=None):
        """Assert that the arc lists `a1` and `a2` are equal."""
        # Make them into multi-line strings so we can see what's going wrong.
        s1 = arcs_to_arcz_repr(a1)
        s2 = arcs_to_arcz_repr(a2)
        self.assertMultiLineEqual(s1, s2, msg)

    def check_coverage(
        self, text, lines=None, missing="", report="",
        excludes=None, partials="",
        arcz=None, arcz_missing="", arcz_unpredicted="",
        arcs=None, arcs_missing=None, arcs_unpredicted=None,
    ):
        """Check the coverage measurement of `text`.

        The source `text` is run and measured.  `lines` are the line numbers
        that are executable, or a list of possible line numbers, any of which
        could match. `missing` are the lines not executed, `excludes` are
        regexes to match against for excluding lines, and `report` is the text
        of the measurement report.

        For arc measurement, `arcz` is a string that can be decoded into arcs
        in the code (see `arcz_to_arcs` for the encoding scheme).
        `arcz_missing` are the arcs that are not executed, and
        `arcz_unpredicted` are the arcs executed in the code, but not deducible
        from the code.  These last two default to "", meaning we explicitly
        check that there are no missing or unpredicted arcs.

        Returns the Coverage object, in case you want to poke at it some more.

        """
        # We write the code into a file so that we can import it.
        # Coverage.py wants to deal with things as modules with file names.
        modname = self.get_module_name()

        self.make_file(modname + ".py", text)

        if arcs is None and arcz is not None:
            arcs = arcz_to_arcs(arcz)
        if arcs_missing is None:
            arcs_missing = arcz_to_arcs(arcz_missing)
        if arcs_unpredicted is None:
            arcs_unpredicted = arcz_to_arcs(arcz_unpredicted)

        # Start up coverage.py.
        cov = coverage.Coverage(branch=True)
        cov.erase()
        for exc in excludes or []:
            cov.exclude(exc)
        for par in partials or []:
            cov.exclude(par, which='partial')

        mod = self.start_import_stop(cov, modname)

        # Clean up our side effects
        del sys.modules[modname]

        # Get the analysis results, and check that they are right.
        analysis = cov._analyze(mod)
        statements = sorted(analysis.statements)
        if lines is not None:
            if isinstance(lines[0], int):
                # lines is just a list of numbers, it must match the statements
                # found in the code.
                self.assertEqual(statements, lines)
            else:
                # lines is a list of possible line number lists, one of them
                # must match.
                for line_list in lines:
                    if statements == line_list:
                        break
                else:
                    self.fail("None of the lines choices matched %r" % statements)

            missing_formatted = analysis.missing_formatted()
            if isinstance(missing, string_class):
                self.assertEqual(missing_formatted, missing)
            else:
                for missing_list in missing:
                    if missing_formatted == missing_list:
                        break
                else:
                    self.fail("None of the missing choices matched %r" % missing_formatted)

        if arcs is not None:
            with self.delayed_assertions():
                self.assert_equal_arcs(
                    arcs, analysis.arc_possibilities(),
                    "Possible arcs differ: minus is expected, plus is actual"
                )

                self.assert_equal_arcs(
                    arcs_missing, analysis.arcs_missing(),
                    "Missing arcs differ: minus is expected, plus is actual"
                )

                self.assert_equal_arcs(
                    arcs_unpredicted, analysis.arcs_unpredicted(),
                    "Unpredicted arcs differ: minus is expected, plus is actual"
                )

        if report:
            frep = StringIO()
            cov.report(mod, file=frep, show_missing=True)
            rep = " ".join(frep.getvalue().split("\n")[2].split()[1:])
            self.assertEqual(report, rep)

        return cov

    @contextlib.contextmanager
    def assert_warnings(self, cov, warnings, not_warnings=()):
        """A context manager to check that particular warnings happened in `cov`.

        `cov` is a Coverage instance.  `warnings` is a list of regexes.  Every
        regex must match a warning that was issued by `cov`.  It is OK for
        extra warnings to be issued by `cov` that are not matched by any regex.
        Warnings that are disabled are still considered issued by this function.

        `not_warnings` is a list of regexes that must not appear in the
        warnings.  This is only checked if there are some positive warnings to
        test for in `warnings`.

        If `warnings` is empty, then `cov` is not allowed to issue any
        warnings.

        """
        saved_warnings = []
        def capture_warning(msg, slug=None, once=False):        # pylint: disable=unused-argument
            """A fake implementation of Coverage._warn, to capture warnings."""
            # NOTE: we don't implement `once`.
            if slug:
                msg = "%s (%s)" % (msg, slug)
            saved_warnings.append(msg)

        original_warn = cov._warn
        cov._warn = capture_warning

        try:
            yield
        except:                     # pylint: disable=try-except-raise
            raise
        else:
            if warnings:
                for warning_regex in warnings:
                    for saved in saved_warnings:
                        if re.search(warning_regex, saved):
                            break
                    else:
                        self.fail("Didn't find warning %r in %r" % (warning_regex, saved_warnings))
                for warning_regex in not_warnings:
                    for saved in saved_warnings:
                        if re.search(warning_regex, saved):
                            self.fail("Found warning %r in %r" % (warning_regex, saved_warnings))
            else:
                # No warnings expected. Raise if any warnings happened.
                if saved_warnings:
                    self.fail("Unexpected warnings: %r" % (saved_warnings,))
        finally:
            cov._warn = original_warn

    def nice_file(self, *fparts):
        """Canonicalize the file name composed of the parts in `fparts`."""
        fname = os.path.join(*fparts)
        return os.path.normcase(os.path.abspath(os.path.realpath(fname)))

    def assert_same_files(self, flist1, flist2):
        """Assert that `flist1` and `flist2` are the same set of file names."""
        flist1_nice = [self.nice_file(f) for f in flist1]
        flist2_nice = [self.nice_file(f) for f in flist2]
        self.assertCountEqual(flist1_nice, flist2_nice)

    def assert_exists(self, fname):
        """Assert that `fname` is a file that exists."""
        msg = "File %r should exist" % fname
        self.assertTrue(os.path.exists(fname), msg)

    def assert_doesnt_exist(self, fname):
        """Assert that `fname` is a file that doesn't exist."""
        msg = "File %r shouldn't exist" % fname
        self.assertTrue(not os.path.exists(fname), msg)

    def assert_file_count(self, pattern, count):
        """Assert that there are `count` files matching `pattern`."""
        files = sorted(glob.glob(pattern))
        msg = "There should be {} files matching {!r}, but there are these: {}"
        msg = msg.format(count, pattern, files)
        self.assertEqual(len(files), count, msg)

    def assert_starts_with(self, s, prefix, msg=None):
        """Assert that `s` starts with `prefix`."""
        if not s.startswith(prefix):
            self.fail(msg or ("%r doesn't start with %r" % (s, prefix)))

    def assert_recent_datetime(self, dt, seconds=10, msg=None):
        """Assert that `dt` marks a time at most `seconds` seconds ago."""
        age = datetime.datetime.now() - dt
        self.assertGreaterEqual(age.total_seconds(), 0, msg)
        self.assertLessEqual(age.total_seconds(), seconds, msg)

    def command_line(self, args, ret=OK):
        """Run `args` through the command line.

        Use this when you want to run the full coverage machinery, but in the
        current process.  Exceptions may be thrown from deep in the code.
        Asserts that `ret` is returned by `CoverageScript.command_line`.

        Compare with `run_command`.

        Returns None.

        """
        ret_actual = command_line(args)
        self.assertEqual(ret_actual, ret)

    coverage_command = "coverage"

    def run_command(self, cmd):
        """Run the command-line `cmd` in a sub-process.

        `cmd` is the command line to invoke in a sub-process. Returns the
        combined content of `stdout` and `stderr` output streams from the
        sub-process.

        See `run_command_status` for complete semantics.

        Use this when you need to test the process behavior of coverage.

        Compare with `command_line`.

        """
        _, output = self.run_command_status(cmd)
        return output

    def run_command_status(self, cmd):
        """Run the command-line `cmd` in a sub-process, and print its output.

        Use this when you need to test the process behavior of coverage.

        Compare with `command_line`.

        Handles the following command names specially:

        * "python" is replaced with the command name of the current
            Python interpreter.

        * "coverage" is replaced with the command name for the main
            coverage.py program.

        Returns a pair: the process' exit status and its stdout/stderr text,
        which are also stored as `self.last_command_status` and
        `self.last_command_output`.

        """
        # Make sure "python" and "coverage" mean specifically what we want
        # them to mean.
        split_commandline = cmd.split()
        command_name = split_commandline[0]
        command_args = split_commandline[1:]

        if command_name == "python":
            # Running a Python interpreter in a sub-processes can be tricky.
            # Use the real name of our own executable. So "python foo.py" might
            # get executed as "python3.3 foo.py". This is important because
            # Python 3.x doesn't install as "python", so you might get a Python
            # 2 executable instead if you don't use the executable's basename.
            command_words = [os.path.basename(sys.executable)]

        elif command_name == "coverage":
            if env.JYTHON:                  # pragma: only jython
                # Jython can't do reporting, so let's skip the test now.
                if command_args and command_args[0] in ('report', 'html', 'xml', 'annotate'):
                    self.skipTest("Can't run reporting commands in Jython")
                # Jython can't run "coverage" as a command because the shebang
                # refers to another shebang'd Python script. So run them as
                # modules.
                command_words = "jython -m coverage".split()
            else:
                # The invocation requests the coverage.py program.  Substitute the
                # actual coverage.py main command name.
                command_words = [self.coverage_command]

        else:
            command_words = [command_name]

        cmd = " ".join([shlex_quote(w) for w in command_words] + command_args)

        # Add our test modules directory to PYTHONPATH.  I'm sure there's too
        # much path munging here, but...
        pythonpath_name = "PYTHONPATH"
        if env.JYTHON:
            pythonpath_name = "JYTHONPATH"          # pragma: only jython

        testmods = self.nice_file(self.working_root(), 'tests/modules')
        zipfile = self.nice_file(self.working_root(), 'tests/zipmods.zip')
        pypath = os.getenv(pythonpath_name, '')
        if pypath:
            pypath += os.pathsep
        pypath += testmods + os.pathsep + zipfile
        self.set_environ(pythonpath_name, pypath)

        self.last_command_status, self.last_command_output = run_command(cmd)
        print(self.last_command_output)
        return self.last_command_status, self.last_command_output

    def working_root(self):
        """Where is the root of the coverage.py working tree?"""
        return os.path.dirname(self.nice_file(coverage.__file__, ".."))

    def report_from_command(self, cmd):
        """Return the report from the `cmd`, with some convenience added."""
        report = self.run_command(cmd).replace('\\', '/')
        self.assertNotIn("error", report.lower())
        return report

    def report_lines(self, report):
        """Return the lines of the report, as a list."""
        lines = report.split('\n')
        self.assertEqual(lines[-1], "")
        return lines[:-1]

    def line_count(self, report):
        """How many lines are in `report`?"""
        return len(self.report_lines(report))

    def squeezed_lines(self, report):
        """Return a list of the lines in report, with the spaces squeezed."""
        lines = self.report_lines(report)
        return [re.sub(r"\s+", " ", l.strip()) for l in lines]

    def last_line_squeezed(self, report):
        """Return the last line of `report` with the spaces squeezed down."""
        return self.squeezed_lines(report)[-1]

    def get_measured_filenames(self, coverage_data):
        """Get paths to measured files.

        Returns a dict of {filename: absolute path to file}
        for given CoverageData.
        """
        return {os.path.basename(filename): filename
                for filename in coverage_data.measured_files()}


class UsingModulesMixin(object):
    """A mixin for importing modules from tests/modules and tests/moremodules."""

    def setUp(self):
        super(UsingModulesMixin, self).setUp()

        # Parent class saves and restores sys.path, we can just modify it.
        sys.path.append(self.nice_file(TESTS_DIR, 'modules'))
        sys.path.append(self.nice_file(TESTS_DIR, 'moremodules'))


def command_line(args):
    """Run `args` through the CoverageScript command line.

    Returns the return code from CoverageScript.command_line.

    """
    script = CoverageScript()
    ret = script.command_line(shlex.split(args))
    return ret


def xfail(condition, reason):
    """A decorator to mark as test as expected to fail."""
    return pytest.mark.xfail(condition, reason=reason, strict=True)
