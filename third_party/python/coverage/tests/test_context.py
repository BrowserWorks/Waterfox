# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for context support."""

import inspect
import os.path

import coverage
from coverage import env
from coverage.context import qualname_from_frame
from coverage.data import CoverageData

from tests.coveragetest import CoverageTest


class StaticContextTest(CoverageTest):
    """Tests of the static context."""

    def test_no_context(self):
        self.make_file("main.py", "a = 1")
        cov = coverage.Coverage()
        self.start_import_stop(cov, "main")
        data = cov.get_data()
        self.assertCountEqual(data.measured_contexts(), [""])

    def test_static_context(self):
        self.make_file("main.py", "a = 1")
        cov = coverage.Coverage(context="gooey")
        self.start_import_stop(cov, "main")
        data = cov.get_data()
        self.assertCountEqual(data.measured_contexts(), ["gooey"])

    SOURCE = """\
        a = 1
        if a > 2:
            a = 3
        assert a == 1
        """

    LINES = [1, 2, 4]
    ARCS = [(-1, 1), (1, 2), (2, 4), (4, -1)]

    def run_red_blue(self, **options):
        """Run red.py and blue.py, and return their CoverageData objects."""
        self.make_file("red.py", self.SOURCE)
        red_cov = coverage.Coverage(context="red", data_suffix="r", source=["."], **options)
        self.start_import_stop(red_cov, "red")
        red_cov.save()
        red_data = red_cov.get_data()

        self.make_file("blue.py", self.SOURCE)
        blue_cov = coverage.Coverage(context="blue", data_suffix="b", source=["."], **options)
        self.start_import_stop(blue_cov, "blue")
        blue_cov.save()
        blue_data = blue_cov.get_data()

        return red_data, blue_data

    def test_combining_line_contexts(self):
        red_data, blue_data = self.run_red_blue()
        for datas in [[red_data, blue_data], [blue_data, red_data]]:
            combined = CoverageData(suffix="combined")
            for data in datas:
                combined.update(data)

            self.assertEqual(combined.measured_contexts(), {'red', 'blue'})

            full_names = {os.path.basename(f): f for f in combined.measured_files()}
            self.assertCountEqual(full_names, ['red.py', 'blue.py'])

            fred = full_names['red.py']
            fblue = full_names['blue.py']

            def assert_combined_lines(filename, context, lines):
                # pylint: disable=cell-var-from-loop
                combined.set_query_context(context)
                self.assertEqual(combined.lines(filename), lines)

            assert_combined_lines(fred, 'red', self.LINES)
            assert_combined_lines(fred, 'blue', [])
            assert_combined_lines(fblue, 'red', [])
            assert_combined_lines(fblue, 'blue', self.LINES)

    def test_combining_arc_contexts(self):
        red_data, blue_data = self.run_red_blue(branch=True)
        for datas in [[red_data, blue_data], [blue_data, red_data]]:
            combined = CoverageData(suffix="combined")
            for data in datas:
                combined.update(data)

            self.assertEqual(combined.measured_contexts(), {'red', 'blue'})

            full_names = {os.path.basename(f): f for f in combined.measured_files()}
            self.assertCountEqual(full_names, ['red.py', 'blue.py'])

            fred = full_names['red.py']
            fblue = full_names['blue.py']

            def assert_combined_lines(filename, context, lines):
                # pylint: disable=cell-var-from-loop
                combined.set_query_context(context)
                self.assertEqual(combined.lines(filename), lines)

            assert_combined_lines(fred, 'red', self.LINES)
            assert_combined_lines(fred, 'blue', [])
            assert_combined_lines(fblue, 'red', [])
            assert_combined_lines(fblue, 'blue', self.LINES)

            def assert_combined_arcs(filename, context, lines):
                # pylint: disable=cell-var-from-loop
                combined.set_query_context(context)
                self.assertEqual(combined.arcs(filename), lines)

            assert_combined_arcs(fred, 'red', self.ARCS)
            assert_combined_arcs(fred, 'blue', [])
            assert_combined_arcs(fblue, 'red', [])
            assert_combined_arcs(fblue, 'blue', self.ARCS)


class DynamicContextTest(CoverageTest):
    """Tests of dynamically changing contexts."""

    SOURCE = """\
        def helper(lineno):
            x = 2

        def test_one():
            a = 5
            helper(6)

        def test_two():
            a = 9
            b = 10
            if a > 11:
                b = 12
            assert a == (13-4)
            assert b == (14-4)
            helper(15)

        test_one()
        x = 18
        helper(19)
        test_two()
        """

    OUTER_LINES = [1, 4, 8, 17, 18, 19, 2, 20]
    TEST_ONE_LINES = [5, 6, 2]
    TEST_TWO_LINES = [9, 10, 11, 13, 14, 15, 2]

    def test_dynamic_alone(self):
        self.make_file("two_tests.py", self.SOURCE)
        cov = coverage.Coverage(source=["."])
        cov.set_option("run:dynamic_context", "test_function")
        self.start_import_stop(cov, "two_tests")
        data = cov.get_data()

        full_names = {os.path.basename(f): f for f in data.measured_files()}
        fname = full_names["two_tests.py"]
        self.assertCountEqual(
            data.measured_contexts(),
            ["", "two_tests.test_one", "two_tests.test_two"])

        def assert_context_lines(context, lines):
            data.set_query_context(context)
            self.assertCountEqual(lines, data.lines(fname))

        assert_context_lines("", self.OUTER_LINES)
        assert_context_lines("two_tests.test_one", self.TEST_ONE_LINES)
        assert_context_lines("two_tests.test_two", self.TEST_TWO_LINES)

    def test_static_and_dynamic(self):
        self.make_file("two_tests.py", self.SOURCE)
        cov = coverage.Coverage(context="stat", source=["."])
        cov.set_option("run:dynamic_context", "test_function")
        self.start_import_stop(cov, "two_tests")
        data = cov.get_data()

        full_names = {os.path.basename(f): f for f in data.measured_files()}
        fname = full_names["two_tests.py"]
        self.assertCountEqual(
            data.measured_contexts(),
            ["stat", "stat|two_tests.test_one", "stat|two_tests.test_two"])

        def assert_context_lines(context, lines):
            data.set_query_context(context)
            self.assertCountEqual(lines, data.lines(fname))

        assert_context_lines("stat", self.OUTER_LINES)
        assert_context_lines("stat|two_tests.test_one", self.TEST_ONE_LINES)
        assert_context_lines("stat|two_tests.test_two", self.TEST_TWO_LINES)


def get_qualname():
    """Helper to return qualname_from_frame for the caller."""
    stack = inspect.stack()[1:]
    if any(sinfo[0].f_code.co_name == "get_qualname" for sinfo in stack):
        # We're calling outselves recursively, maybe because we're testing
        # properties. Return an int to try to get back on track.
        return 17
    caller_frame = stack[0][0]
    return qualname_from_frame(caller_frame)

# pylint: disable=missing-class-docstring, missing-function-docstring, unused-argument

class Parent(object):
    def meth(self):
        return get_qualname()

    @property
    def a_property(self):
        return get_qualname()

class Child(Parent):
    pass

class SomethingElse(object):
    pass

class MultiChild(SomethingElse, Child):
    pass

def no_arguments():
    return get_qualname()

def plain_old_function(a, b):
    return get_qualname()

def fake_out(self):
    return get_qualname()

def patch_meth(self):
    return get_qualname()

class OldStyle:
    def meth(self):
        return get_qualname()

class OldChild(OldStyle):
    pass

# pylint: enable=missing-class-docstring, missing-function-docstring, unused-argument


class QualnameTest(CoverageTest):
    """Tests of qualname_from_frame."""

    # Pylint gets confused about meth() below.
    # pylint: disable=no-value-for-parameter

    run_in_temp_dir = False

    def test_method(self):
        self.assertEqual(Parent().meth(), "tests.test_context.Parent.meth")

    def test_inherited_method(self):
        self.assertEqual(Child().meth(), "tests.test_context.Parent.meth")

    def test_mi_inherited_method(self):
        self.assertEqual(MultiChild().meth(), "tests.test_context.Parent.meth")

    def test_no_arguments(self):
        self.assertEqual(no_arguments(), "tests.test_context.no_arguments")

    def test_plain_old_function(self):
        self.assertEqual(
            plain_old_function(0, 1), "tests.test_context.plain_old_function")

    def test_fake_out(self):
        self.assertEqual(fake_out(0), "tests.test_context.fake_out")

    def test_property(self):
        self.assertEqual(
            Parent().a_property, "tests.test_context.Parent.a_property")

    def test_changeling(self):
        c = Child()
        c.meth = patch_meth
        self.assertEqual(c.meth(c), "tests.test_context.patch_meth")

    def test_oldstyle(self):
        if not env.PY2:
            self.skipTest("Old-style classes are only in Python 2")
        self.assertEqual(OldStyle().meth(), "tests.test_context.OldStyle.meth")
        self.assertEqual(OldChild().meth(), "tests.test_context.OldStyle.meth")

    def test_bug_829(self):
        # A class with a name like a function shouldn't confuse qualname_from_frame.
        class test_something(object):               # pylint: disable=unused-variable
            self.assertEqual(get_qualname(), None)
