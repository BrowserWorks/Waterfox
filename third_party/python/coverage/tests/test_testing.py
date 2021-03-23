# -*- coding: utf-8 -*-
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests that our test infrastructure is really working!"""

import datetime
import os
import re
import sys

import pytest

import coverage
from coverage.backunittest import TestCase, unittest
from coverage.files import actual_path
from coverage.misc import StopEverything
import coverage.optional

from tests.coveragetest import CoverageTest, convert_skip_exceptions
from tests.helpers import arcs_to_arcz_repr, arcz_to_arcs
from tests.helpers import CheckUniqueFilenames, re_lines, re_line


def test_xdist_sys_path_nuttiness_is_fixed():
    # See conftest.py:fix_xdist_sys_path
    assert sys.path[1] != ''
    assert os.environ.get('PYTHONPATH') is None


class TestingTest(TestCase):
    """Tests of helper methods on `backunittest.TestCase`."""

    def test_assert_count_equal(self):
        self.assertCountEqual(set(), set())
        self.assertCountEqual(set([1,2,3]), set([3,1,2]))
        with self.assertRaises(AssertionError):
            self.assertCountEqual(set([1,2,3]), set())
        with self.assertRaises(AssertionError):
            self.assertCountEqual(set([1,2,3]), set([4,5,6]))


class CoverageTestTest(CoverageTest):
    """Test the methods in `CoverageTest`."""

    def test_file_exists(self):
        self.make_file("whoville.txt", "We are here!")
        self.assert_exists("whoville.txt")
        self.assert_doesnt_exist("shadow.txt")
        msg = "False is not true : File 'whoville.txt' shouldn't exist"
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_doesnt_exist("whoville.txt")
        msg = "False is not true : File 'shadow.txt' should exist"
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_exists("shadow.txt")

    def test_file_count(self):
        self.make_file("abcde.txt", "abcde")
        self.make_file("axczz.txt", "axczz")
        self.make_file("afile.txt", "afile")
        self.assert_file_count("a*.txt", 3)
        self.assert_file_count("*c*.txt", 2)
        self.assert_file_count("afile.*", 1)
        self.assert_file_count("*.q", 0)
        msg = re.escape(
            "3 != 13 : There should be 13 files matching 'a*.txt', but there are these: "
            "['abcde.txt', 'afile.txt', 'axczz.txt']"
        )
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_file_count("a*.txt", 13)
        msg = re.escape(
            "2 != 12 : There should be 12 files matching '*c*.txt', but there are these: "
            "['abcde.txt', 'axczz.txt']"
        )
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_file_count("*c*.txt", 12)
        msg = re.escape(
            "1 != 11 : There should be 11 files matching 'afile.*', but there are these: "
            "['afile.txt']"
        )
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_file_count("afile.*", 11)
        msg = re.escape(
            "0 != 10 : There should be 10 files matching '*.q', but there are these: []"
        )
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_file_count("*.q", 10)

    def test_assert_startwith(self):
        self.assert_starts_with("xyzzy", "xy")
        self.assert_starts_with("xyz\nabc", "xy")
        self.assert_starts_with("xyzzy", ("x", "z"))
        msg = re.escape("'xyz' doesn't start with 'a'")
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_starts_with("xyz", "a")
        msg = re.escape("'xyz\\nabc' doesn't start with 'a'")
        with self.assertRaisesRegex(AssertionError, msg):
            self.assert_starts_with("xyz\nabc", "a")

    def test_assert_recent_datetime(self):
        def now_delta(seconds):
            """Make a datetime `seconds` seconds from now."""
            return datetime.datetime.now() + datetime.timedelta(seconds=seconds)

        # Default delta is 10 seconds.
        self.assert_recent_datetime(now_delta(0))
        self.assert_recent_datetime(now_delta(-9))
        with self.assertRaises(AssertionError):
            self.assert_recent_datetime(now_delta(-11))
        with self.assertRaises(AssertionError):
            self.assert_recent_datetime(now_delta(1))

        # Delta is settable.
        self.assert_recent_datetime(now_delta(0), seconds=120)
        self.assert_recent_datetime(now_delta(-100), seconds=120)
        with self.assertRaises(AssertionError):
            self.assert_recent_datetime(now_delta(-1000), seconds=120)
        with self.assertRaises(AssertionError):
            self.assert_recent_datetime(now_delta(1), seconds=120)

    def test_assert_warnings(self):
        cov = coverage.Coverage()

        # Make a warning, it should catch it properly.
        with self.assert_warnings(cov, ["Hello there!"]):
            cov._warn("Hello there!")

        # The expected warnings are regexes.
        with self.assert_warnings(cov, ["Hello.*!"]):
            cov._warn("Hello there!")

        # There can be a bunch of actual warnings.
        with self.assert_warnings(cov, ["Hello.*!"]):
            cov._warn("You there?")
            cov._warn("Hello there!")

        # There can be a bunch of expected warnings.
        with self.assert_warnings(cov, ["Hello.*!", "You"]):
            cov._warn("You there?")
            cov._warn("Hello there!")

        # But if there are a bunch of expected warnings, they have to all happen.
        warn_regex = r"Didn't find warning 'You' in \['Hello there!'\]"
        with self.assertRaisesRegex(AssertionError, warn_regex):
            with self.assert_warnings(cov, ["Hello.*!", "You"]):
                cov._warn("Hello there!")

        # Make a different warning than expected, it should raise an assertion.
        warn_regex = r"Didn't find warning 'Not me' in \['Hello there!'\]"
        with self.assertRaisesRegex(AssertionError, warn_regex):
            with self.assert_warnings(cov, ["Not me"]):
                cov._warn("Hello there!")

        # Try checking a warning that shouldn't appear: happy case.
        with self.assert_warnings(cov, ["Hi"], not_warnings=["Bye"]):
            cov._warn("Hi")

        # But it should fail if the unexpected warning does appear.
        warn_regex = r"Found warning 'Bye' in \['Hi', 'Bye'\]"
        with self.assertRaisesRegex(AssertionError, warn_regex):
            with self.assert_warnings(cov, ["Hi"], not_warnings=["Bye"]):
                cov._warn("Hi")
                cov._warn("Bye")

        # assert_warnings shouldn't hide a real exception.
        with self.assertRaisesRegex(ZeroDivisionError, "oops"):
            with self.assert_warnings(cov, ["Hello there!"]):
                raise ZeroDivisionError("oops")

    def test_assert_no_warnings(self):
        cov = coverage.Coverage()

        # Happy path: no warnings.
        with self.assert_warnings(cov, []):
            pass

        # If you said there would be no warnings, and there were, fail!
        warn_regex = r"Unexpected warnings: \['Watch out!'\]"
        with self.assertRaisesRegex(AssertionError, warn_regex):
            with self.assert_warnings(cov, []):
                cov._warn("Watch out!")

    def test_sub_python_is_this_python(self):
        # Try it with a Python command.
        self.set_environ('COV_FOOBAR', 'XYZZY')
        self.make_file("showme.py", """\
            import os, sys
            print(sys.executable)
            print(os.__file__)
            print(os.environ['COV_FOOBAR'])
            """)
        out = self.run_command("python showme.py").splitlines()
        self.assertEqual(actual_path(out[0]), actual_path(sys.executable))
        self.assertEqual(out[1], os.__file__)
        self.assertEqual(out[2], 'XYZZY')

        # Try it with a "coverage debug sys" command.
        out = self.run_command("coverage debug sys")

        executable = re_line(out, "executable:")
        executable = executable.split(":", 1)[1].strip()
        self.assertTrue(_same_python_executable(executable, sys.executable))

        # "environment: COV_FOOBAR = XYZZY" or "COV_FOOBAR = XYZZY"
        environ = re_line(out, "COV_FOOBAR")
        _, _, environ = environ.rpartition(":")
        self.assertEqual(environ.strip(), "COV_FOOBAR = XYZZY")

    def test_run_command_stdout_stderr(self):
        # run_command should give us both stdout and stderr.
        self.make_file("outputs.py", """\
            import sys
            sys.stderr.write("StdErr\\n")
            print("StdOut")
            """)
        out = self.run_command("python outputs.py")
        self.assertIn("StdOut\n", out)
        self.assertIn("StdErr\n", out)


class CheckUniqueFilenamesTest(CoverageTest):
    """Tests of CheckUniqueFilenames."""

    run_in_temp_dir = False

    class Stub(object):
        """A stand-in for the class we're checking."""
        def __init__(self, x):
            self.x = x

        def method(self, filename, a=17, b="hello"):
            """The method we'll wrap, with args to be sure args work."""
            return (self.x, filename, a, b)

    def test_detect_duplicate(self):
        stub = self.Stub(23)
        CheckUniqueFilenames.hook(stub, "method")

        # Two method calls with different names are fine.
        assert stub.method("file1") == (23, "file1", 17, "hello")
        assert stub.method("file2", 1723, b="what") == (23, "file2", 1723, "what")

        # A duplicate file name trips an assertion.
        with self.assertRaises(AssertionError):
            stub.method("file1")


@pytest.mark.parametrize("text, pat, result", [
    ("line1\nline2\nline3\n", "line", "line1\nline2\nline3\n"),
    ("line1\nline2\nline3\n", "[13]", "line1\nline3\n"),
    ("line1\nline2\nline3\n", "X", ""),
])
def test_re_lines(text, pat, result):
    assert re_lines(text, pat) == result

@pytest.mark.parametrize("text, pat, result", [
    ("line1\nline2\nline3\n", "line", ""),
    ("line1\nline2\nline3\n", "[13]", "line2\n"),
    ("line1\nline2\nline3\n", "X", "line1\nline2\nline3\n"),
])
def test_re_lines_inverted(text, pat, result):
    assert re_lines(text, pat, match=False) == result

@pytest.mark.parametrize("text, pat, result", [
    ("line1\nline2\nline3\n", "2", "line2"),
])
def test_re_line(text, pat, result):
    assert re_line(text, pat) == result

@pytest.mark.parametrize("text, pat", [
    ("line1\nline2\nline3\n", "line"),      # too many matches
    ("line1\nline2\nline3\n", "X"),         # no matches
])
def test_re_line_bad(text, pat):
    with pytest.raises(AssertionError):
        re_line(text, pat)


def test_convert_skip_exceptions():
    @convert_skip_exceptions
    def some_method(ret=None, exc=None):
        """Be like a test case."""
        if exc:
            raise exc("yikes!")
        return ret

    # Normal flow is normal.
    assert some_method(ret=[17, 23]) == [17, 23]

    # Exceptions are raised normally.
    with pytest.raises(ValueError):
        some_method(exc=ValueError)

    # But a StopEverything becomes a SkipTest.
    with pytest.raises(unittest.SkipTest):
        some_method(exc=StopEverything)


def _same_python_executable(e1, e2):
    """Determine if `e1` and `e2` refer to the same Python executable.

    Either path could include symbolic links.  The two paths might not refer
    to the exact same file, but if they are in the same directory and their
    numeric suffixes aren't different, they are the same executable.

    """
    e1 = os.path.abspath(os.path.realpath(e1))
    e2 = os.path.abspath(os.path.realpath(e2))

    if os.path.dirname(e1) != os.path.dirname(e2):
        return False                                    # pragma: only failure

    e1 = os.path.basename(e1)
    e2 = os.path.basename(e2)

    if e1 == "python" or e2 == "python" or e1 == e2:
        # Python and Python2.3: OK
        # Python2.3 and Python: OK
        # Python and Python: OK
        # Python2.3 and Python2.3: OK
        return True

    return False                                        # pragma: only failure


def test_optional_without():
    # pylint: disable=reimported
    from coverage.optional import toml as toml1
    with coverage.optional.without('toml'):
        from coverage.optional import toml as toml2
    from coverage.optional import toml as toml3

    assert toml1 is toml3 is not None
    assert toml2 is None


@pytest.mark.parametrize("arcz, arcs", [
    (".1 12 2.", [(-1, 1), (1, 2), (2, -1)]),
    ("-11 12 2-5", [(-1, 1), (1, 2), (2, -5)]),
    ("-QA CB IT Z-A", [(-26, 10), (12, 11), (18, 29), (35, -10)]),
])
def test_arcz_to_arcs(arcz, arcs):
    assert arcz_to_arcs(arcz) == arcs


@pytest.mark.parametrize("arcs, arcz_repr", [
    ([(-1, 1), (1, 2), (2, -1)], "(-1, 1) # .1\n(1, 2) # 12\n(2, -1) # 2.\n"),
    ([(-1, 1), (1, 2), (2, -5)], "(-1, 1) # .1\n(1, 2) # 12\n(2, -5) # 2-5\n"),
    ([(-26, 10), (12, 11), (18, 29), (35, -10), (1, 33), (100, 7)],
        (
        "(-26, 10) # -QA\n"
        "(12, 11) # CB\n"
        "(18, 29) # IT\n"
        "(35, -10) # Z-A\n"
        "(1, 33) # 1X\n"
        "(100, 7) # ?7\n"
        )
    ),
])
def test_arcs_to_arcz_repr(arcs, arcz_repr):
    assert arcs_to_arcz_repr(arcs) == arcz_repr
