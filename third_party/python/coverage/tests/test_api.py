# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for coverage.py's API."""

import fnmatch
import glob
import os
import os.path
import re
import shutil
import sys
import textwrap

from unittest_mixins import change_dir

import coverage
from coverage import env
from coverage.backward import code_object, import_local_file, StringIO
from coverage.data import line_counts
from coverage.files import abs_file
from coverage.misc import CoverageException

from tests.coveragetest import CoverageTest, CoverageTestMethodsMixin, TESTS_DIR, UsingModulesMixin


class ApiTest(CoverageTest):
    """Api-oriented tests for coverage.py."""

    def clean_files(self, files, pats):
        """Remove names matching `pats` from `files`, a list of file names."""
        good = []
        for f in files:
            for pat in pats:
                if fnmatch.fnmatch(f, pat):
                    break
            else:
                good.append(f)
        return good

    def assertFiles(self, files):
        """Assert that the files here are `files`, ignoring the usual junk."""
        here = os.listdir(".")
        here = self.clean_files(here, ["*.pyc", "__pycache__", "*$py.class"])
        self.assertCountEqual(here, files)

    def test_unexecuted_file(self):
        cov = coverage.Coverage()

        self.make_file("mycode.py", """\
            a = 1
            b = 2
            if b == 3:
                c = 4
            d = 5
            """)

        self.make_file("not_run.py", """\
            fooey = 17
            """)

        # Import the Python file, executing it.
        self.start_import_stop(cov, "mycode")

        _, statements, missing, _ = cov.analysis("not_run.py")
        self.assertEqual(statements, [1])
        self.assertEqual(missing, [1])

    def test_filenames(self):

        self.make_file("mymain.py", """\
            import mymod
            a = 1
            """)

        self.make_file("mymod.py", """\
            fooey = 17
            """)

        # Import the Python file, executing it.
        cov = coverage.Coverage()
        self.start_import_stop(cov, "mymain")

        filename, _, _, _ = cov.analysis("mymain.py")
        self.assertEqual(os.path.basename(filename), "mymain.py")
        filename, _, _, _ = cov.analysis("mymod.py")
        self.assertEqual(os.path.basename(filename), "mymod.py")

        filename, _, _, _ = cov.analysis(sys.modules["mymain"])
        self.assertEqual(os.path.basename(filename), "mymain.py")
        filename, _, _, _ = cov.analysis(sys.modules["mymod"])
        self.assertEqual(os.path.basename(filename), "mymod.py")

        # Import the Python file, executing it again, once it's been compiled
        # already.
        cov = coverage.Coverage()
        self.start_import_stop(cov, "mymain")

        filename, _, _, _ = cov.analysis("mymain.py")
        self.assertEqual(os.path.basename(filename), "mymain.py")
        filename, _, _, _ = cov.analysis("mymod.py")
        self.assertEqual(os.path.basename(filename), "mymod.py")

        filename, _, _, _ = cov.analysis(sys.modules["mymain"])
        self.assertEqual(os.path.basename(filename), "mymain.py")
        filename, _, _, _ = cov.analysis(sys.modules["mymod"])
        self.assertEqual(os.path.basename(filename), "mymod.py")

    def test_ignore_stdlib(self):
        self.make_file("mymain.py", """\
            import colorsys
            a = 1
            hls = colorsys.rgb_to_hls(1.0, 0.5, 0.0)
            """)

        # Measure without the stdlib.
        cov1 = coverage.Coverage()
        self.assertEqual(cov1.config.cover_pylib, False)
        self.start_import_stop(cov1, "mymain")

        # some statements were marked executed in mymain.py
        _, statements, missing, _ = cov1.analysis("mymain.py")
        self.assertNotEqual(statements, missing)
        # but none were in colorsys.py
        _, statements, missing, _ = cov1.analysis("colorsys.py")
        self.assertEqual(statements, missing)

        # Measure with the stdlib.
        cov2 = coverage.Coverage(cover_pylib=True)
        self.start_import_stop(cov2, "mymain")

        # some statements were marked executed in mymain.py
        _, statements, missing, _ = cov2.analysis("mymain.py")
        self.assertNotEqual(statements, missing)
        # and some were marked executed in colorsys.py
        _, statements, missing, _ = cov2.analysis("colorsys.py")
        self.assertNotEqual(statements, missing)

    def test_include_can_measure_stdlib(self):
        self.make_file("mymain.py", """\
            import colorsys, random
            a = 1
            r, g, b = [random.random() for _ in range(3)]
            hls = colorsys.rgb_to_hls(r, g, b)
            """)

        # Measure without the stdlib, but include colorsys.
        cov1 = coverage.Coverage(cover_pylib=False, include=["*/colorsys.py"])
        self.start_import_stop(cov1, "mymain")

        # some statements were marked executed in colorsys.py
        _, statements, missing, _ = cov1.analysis("colorsys.py")
        self.assertNotEqual(statements, missing)
        # but none were in random.py
        _, statements, missing, _ = cov1.analysis("random.py")
        self.assertEqual(statements, missing)

    def test_exclude_list(self):
        cov = coverage.Coverage()
        cov.clear_exclude()
        self.assertEqual(cov.get_exclude_list(), [])
        cov.exclude("foo")
        self.assertEqual(cov.get_exclude_list(), ["foo"])
        cov.exclude("bar")
        self.assertEqual(cov.get_exclude_list(), ["foo", "bar"])
        self.assertEqual(cov._exclude_regex('exclude'), "(?:foo)|(?:bar)")
        cov.clear_exclude()
        self.assertEqual(cov.get_exclude_list(), [])

    def test_exclude_partial_list(self):
        cov = coverage.Coverage()
        cov.clear_exclude(which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), [])
        cov.exclude("foo", which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), ["foo"])
        cov.exclude("bar", which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), ["foo", "bar"])
        self.assertEqual(
            cov._exclude_regex(which='partial'), "(?:foo)|(?:bar)"
        )
        cov.clear_exclude(which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), [])

    def test_exclude_and_partial_are_separate_lists(self):
        cov = coverage.Coverage()
        cov.clear_exclude(which='partial')
        cov.clear_exclude(which='exclude')
        cov.exclude("foo", which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), ['foo'])
        self.assertEqual(cov.get_exclude_list(which='exclude'), [])
        cov.exclude("bar", which='exclude')
        self.assertEqual(cov.get_exclude_list(which='partial'), ['foo'])
        self.assertEqual(cov.get_exclude_list(which='exclude'), ['bar'])
        cov.exclude("p2", which='partial')
        cov.exclude("e2", which='exclude')
        self.assertEqual(cov.get_exclude_list(which='partial'), ['foo', 'p2'])
        self.assertEqual(cov.get_exclude_list(which='exclude'), ['bar', 'e2'])
        cov.clear_exclude(which='partial')
        self.assertEqual(cov.get_exclude_list(which='partial'), [])
        self.assertEqual(cov.get_exclude_list(which='exclude'), ['bar', 'e2'])
        cov.clear_exclude(which='exclude')
        self.assertEqual(cov.get_exclude_list(which='partial'), [])
        self.assertEqual(cov.get_exclude_list(which='exclude'), [])

    def test_datafile_default(self):
        # Default data file behavior: it's .coverage
        self.make_file("datatest1.py", """\
            fooey = 17
            """)

        self.assertFiles(["datatest1.py"])
        cov = coverage.Coverage()
        self.start_import_stop(cov, "datatest1")
        cov.save()
        self.assertFiles(["datatest1.py", ".coverage"])

    def test_datafile_specified(self):
        # You can specify the data file name.
        self.make_file("datatest2.py", """\
            fooey = 17
            """)

        self.assertFiles(["datatest2.py"])
        cov = coverage.Coverage(data_file="cov.data")
        self.start_import_stop(cov, "datatest2")
        cov.save()
        self.assertFiles(["datatest2.py", "cov.data"])

    def test_datafile_and_suffix_specified(self):
        # You can specify the data file name and suffix.
        self.make_file("datatest3.py", """\
            fooey = 17
            """)

        self.assertFiles(["datatest3.py"])
        cov = coverage.Coverage(data_file="cov.data", data_suffix="14")
        self.start_import_stop(cov, "datatest3")
        cov.save()
        self.assertFiles(["datatest3.py", "cov.data.14"])

    def test_datafile_from_rcfile(self):
        # You can specify the data file name in the .coveragerc file
        self.make_file("datatest4.py", """\
            fooey = 17
            """)
        self.make_file(".coveragerc", """\
            [run]
            data_file = mydata.dat
            """)

        self.assertFiles(["datatest4.py", ".coveragerc"])
        cov = coverage.Coverage()
        self.start_import_stop(cov, "datatest4")
        cov.save()
        self.assertFiles(["datatest4.py", ".coveragerc", "mydata.dat"])

    def test_deep_datafile(self):
        self.make_file("datatest5.py", "fooey = 17")
        self.assertFiles(["datatest5.py"])
        cov = coverage.Coverage(data_file="deep/sub/cov.data")
        self.start_import_stop(cov, "datatest5")
        cov.save()
        self.assertFiles(["datatest5.py", "deep"])
        self.assert_exists("deep/sub/cov.data")

    def test_datafile_none(self):
        cov = coverage.Coverage(data_file=None)

        def f1():
            a = 1       # pylint: disable=unused-variable

        one_line_number = code_object(f1).co_firstlineno + 1
        lines = []

        def run_one_function(f):
            cov.erase()
            cov.start()
            f()
            cov.stop()

            fs = cov.get_data().measured_files()
            lines.append(cov.get_data().lines(list(fs)[0]))

        run_one_function(f1)
        run_one_function(f1)
        run_one_function(f1)
        assert lines == [[one_line_number]] * 3
        self.assert_doesnt_exist(".coverage")
        assert os.listdir(".") == []

    def test_empty_reporting(self):
        # empty summary reports raise exception, just like the xml report
        cov = coverage.Coverage()
        cov.erase()
        with self.assertRaisesRegex(CoverageException, "No data to report."):
            cov.report()

    def test_completely_zero_reporting(self):
        # https://github.com/nedbat/coveragepy/issues/884
        # If nothing was measured, the file-touching didn't happen properly.
        self.make_file("foo/bar.py", "print('Never run')")
        self.make_file("test.py", "assert True")
        cov = coverage.Coverage(source=["foo"])
        self.start_import_stop(cov, "test")
        cov.report()
        # Name         Stmts   Miss  Cover
        # --------------------------------
        # foo/bar.py       1      1     0%

        last = self.last_line_squeezed(self.stdout()).replace("\\", "/")
        self.assertEqual("foo/bar.py 1 1 0%", last)

    def test_cov4_data_file(self):
        cov4_data = (
            "!coverage.py: This is a private format, don't read it directly!"
            '{"lines":{"/private/tmp/foo.py":[1,5,2,3]}}'
        )
        self.make_file(".coverage", cov4_data)
        cov = coverage.Coverage()
        with self.assertRaisesRegex(CoverageException, "Looks like a coverage 4.x data file"):
            cov.load()
        cov.erase()

    def make_code1_code2(self):
        """Create the code1.py and code2.py files."""
        self.make_file("code1.py", """\
            code1 = 1
            """)
        self.make_file("code2.py", """\
            code2 = 1
            code2 = 2
            """)

    def check_code1_code2(self, cov):
        """Check the analysis is correct for code1.py and code2.py."""
        _, statements, missing, _ = cov.analysis("code1.py")
        self.assertEqual(statements, [1])
        self.assertEqual(missing, [])
        _, statements, missing, _ = cov.analysis("code2.py")
        self.assertEqual(statements, [1, 2])
        self.assertEqual(missing, [])

    def test_start_stop_start_stop(self):
        self.make_code1_code2()
        cov = coverage.Coverage()
        self.start_import_stop(cov, "code1")
        cov.save()
        self.start_import_stop(cov, "code2")
        self.check_code1_code2(cov)

    def test_start_save_stop(self):
        self.make_code1_code2()
        cov = coverage.Coverage()
        cov.start()
        import_local_file("code1")                                     # pragma: nested
        cov.save()                                                     # pragma: nested
        import_local_file("code2")                                     # pragma: nested
        cov.stop()                                                     # pragma: nested
        self.check_code1_code2(cov)

    def test_start_save_nostop(self):
        self.make_code1_code2()
        cov = coverage.Coverage()
        cov.start()
        import_local_file("code1")                                     # pragma: nested
        cov.save()                                                     # pragma: nested
        import_local_file("code2")                                     # pragma: nested
        self.check_code1_code2(cov)                                    # pragma: nested
        # Then stop it, or the test suite gets out of whack.
        cov.stop()                                                     # pragma: nested

    def test_two_getdata_only_warn_once(self):
        self.make_code1_code2()
        cov = coverage.Coverage(source=["."], omit=["code1.py"])
        cov.start()
        import_local_file("code1")                                     # pragma: nested
        cov.stop()                                                     # pragma: nested
        # We didn't collect any data, so we should get a warning.
        with self.assert_warnings(cov, ["No data was collected"]):
            cov.get_data()
        # But calling get_data a second time with no intervening activity
        # won't make another warning.
        with self.assert_warnings(cov, []):
            cov.get_data()

    def test_two_getdata_warn_twice(self):
        self.make_code1_code2()
        cov = coverage.Coverage(source=["."], omit=["code1.py", "code2.py"])
        cov.start()
        import_local_file("code1")                                     # pragma: nested
        # We didn't collect any data, so we should get a warning.
        with self.assert_warnings(cov, ["No data was collected"]):     # pragma: nested
            cov.save()                                                 # pragma: nested
        import_local_file("code2")                                     # pragma: nested
        # Calling get_data a second time after tracing some more will warn again.
        with self.assert_warnings(cov, ["No data was collected"]):     # pragma: nested
            cov.get_data()                                             # pragma: nested
        # Then stop it, or the test suite gets out of whack.
        cov.stop()                                                     # pragma: nested

    def make_good_data_files(self):
        """Make some good data files."""
        self.make_code1_code2()
        cov = coverage.Coverage(data_suffix=True)
        self.start_import_stop(cov, "code1")
        cov.save()

        cov = coverage.Coverage(data_suffix=True)
        self.start_import_stop(cov, "code2")
        cov.save()
        self.assert_file_count(".coverage.*", 2)

    def test_combining_corrupt_data(self):
        # If you combine a corrupt data file, then you will get a warning,
        # and the file will remain.
        self.make_good_data_files()
        self.make_file(".coverage.foo", """La la la, this isn't coverage data!""")
        cov = coverage.Coverage()
        warning_regex = (
            r"Couldn't use data file '.*\.coverage\.foo': file (is encrypted or )?is not a database"
        )
        with self.assert_warnings(cov, [warning_regex]):
            cov.combine()

        # We got the results from code1 and code2 properly.
        self.check_code1_code2(cov)

        # The bad file still exists, but it's the only parallel data file left.
        self.assert_exists(".coverage.foo")
        self.assert_file_count(".coverage.*", 1)

    def test_combining_twice(self):
        self.make_good_data_files()
        cov1 = coverage.Coverage()
        cov1.combine()
        cov1.save()
        self.check_code1_code2(cov1)
        self.assert_file_count(".coverage.*", 0)
        self.assert_exists(".coverage")

        cov2 = coverage.Coverage()
        with self.assertRaisesRegex(CoverageException, r"No data to combine"):
            cov2.combine(strict=True)

        cov3 = coverage.Coverage()
        cov3.combine()
        # Now the data is empty!
        _, statements, missing, _ = cov3.analysis("code1.py")
        self.assertEqual(statements, [1])
        self.assertEqual(missing, [1])
        _, statements, missing, _ = cov3.analysis("code2.py")
        self.assertEqual(statements, [1, 2])
        self.assertEqual(missing, [1, 2])

    def test_combining_with_a_used_coverage(self):
        # Can you use a coverage object to run one shard of a parallel suite,
        # and then also combine the data?
        self.make_code1_code2()
        cov = coverage.Coverage(data_suffix=True)
        self.start_import_stop(cov, "code1")
        cov.save()

        cov = coverage.Coverage(data_suffix=True)
        self.start_import_stop(cov, "code2")
        cov.save()

        cov.combine()
        self.check_code1_code2(cov)

    def test_ordered_combine(self):
        # https://github.com/nedbat/coveragepy/issues/649
        # The order of the [paths] setting matters
        def make_data_file():
            data = coverage.CoverageData(".coverage.1")
            data.add_lines({os.path.abspath('ci/girder/g1.py'): dict.fromkeys(range(10))})
            data.add_lines({os.path.abspath('ci/girder/plugins/p1.py'): dict.fromkeys(range(10))})
            data.write()

        def get_combined_filenames():
            cov = coverage.Coverage()
            cov.combine()
            cov.save()
            data = cov.get_data()
            filenames = {os.path.relpath(f).replace("\\", "/") for f in data.measured_files()}
            return filenames

        # Case 1: get the order right.
        make_data_file()
        self.make_file(".coveragerc", """\
            [paths]
            plugins =
                plugins/
                ci/girder/plugins/
            girder =
                girder/
                ci/girder/
            """)
        assert get_combined_filenames() == {'girder/g1.py', 'plugins/p1.py'}

        # Case 2: get the order wrong.
        make_data_file()
        self.make_file(".coveragerc", """\
            [paths]
            girder =
                girder/
                ci/girder/
            plugins =
                plugins/
                ci/girder/plugins/
            """)
        assert get_combined_filenames() == {'girder/g1.py', 'girder/plugins/p1.py'}

    def test_warnings(self):
        self.make_file("hello.py", """\
            import sys, os
            print("Hello")
            """)
        cov = coverage.Coverage(source=["sys", "xyzzy", "quux"])
        self.start_import_stop(cov, "hello")
        cov.get_data()

        out = self.stdout()
        self.assertIn("Hello\n", out)

        err = self.stderr()
        self.assertIn(textwrap.dedent("""\
            Coverage.py warning: Module sys has no Python source. (module-not-python)
            Coverage.py warning: Module xyzzy was never imported. (module-not-imported)
            Coverage.py warning: Module quux was never imported. (module-not-imported)
            Coverage.py warning: No data was collected. (no-data-collected)
            """), err)

    def test_warnings_suppressed(self):
        self.make_file("hello.py", """\
            import sys, os
            print("Hello")
            """)
        self.make_file(".coveragerc", """\
            [run]
            disable_warnings = no-data-collected, module-not-imported
            """)
        cov = coverage.Coverage(source=["sys", "xyzzy", "quux"])
        self.start_import_stop(cov, "hello")
        cov.get_data()

        out = self.stdout()
        self.assertIn("Hello\n", out)

        err = self.stderr()
        self.assertIn(
            "Coverage.py warning: Module sys has no Python source. (module-not-python)",
            err
        )
        self.assertNotIn("module-not-imported", err)
        self.assertNotIn("no-data-collected", err)

    def test_warn_once(self):
        cov = coverage.Coverage()
        cov.load()
        cov._warn("Warning, warning 1!", slug="bot", once=True)
        cov._warn("Warning, warning 2!", slug="bot", once=True)
        err = self.stderr()
        self.assertIn("Warning, warning 1!", err)
        self.assertNotIn("Warning, warning 2!", err)

    def test_source_and_include_dont_conflict(self):
        # A bad fix made this case fail: https://bitbucket.org/ned/coveragepy/issues/541
        self.make_file("a.py", "import b\na = 1")
        self.make_file("b.py", "b = 1")
        self.make_file(".coveragerc", """\
            [run]
            source = .
            """)

        # Just like: coverage run a.py
        cov = coverage.Coverage()
        self.start_import_stop(cov, "a")
        cov.save()

        # Run the equivalent of: coverage report --include=b.py
        cov = coverage.Coverage(include=["b.py"])
        cov.load()
        # There should be no exception. At one point, report() threw:
        # CoverageException: --include and --source are mutually exclusive
        cov.report()
        expected = textwrap.dedent("""\
            Name    Stmts   Miss  Cover
            ---------------------------
            b.py        1      0   100%
            """)
        self.assertEqual(expected, self.stdout())

    def make_test_files(self):
        """Create a simple file representing a method with two tests.

        Returns absolute path to the file.
        """
        self.make_file("testsuite.py", """\
            def timestwo(x):
                return x*2

            def test_multiply_zero():
                assert timestwo(0) == 0

            def test_multiply_six():
                assert timestwo(6) == 12
            """)

    def test_switch_context_testrunner(self):
        # This test simulates a coverage-aware test runner,
        # measuring labeled coverage via public API
        self.make_test_files()

        # Test runner starts
        cov = coverage.Coverage()
        cov.start()

        if "pragma: nested":
            # Imports the test suite
            suite = import_local_file("testsuite")

            # Measures test case 1
            cov.switch_context('multiply_zero')
            suite.test_multiply_zero()

            # Measures test case 2
            cov.switch_context('multiply_six')
            suite.test_multiply_six()

            # Runner finishes
            cov.save()
            cov.stop()

        # Labeled data is collected
        data = cov.get_data()
        self.assertEqual(
            [u'', u'multiply_six', u'multiply_zero'],
            sorted(data.measured_contexts())
        )

        filenames = self.get_measured_filenames(data)
        suite_filename = filenames['testsuite.py']

        data.set_query_context("multiply_six")
        self.assertEqual([2, 8], sorted(data.lines(suite_filename)))
        data.set_query_context("multiply_zero")
        self.assertEqual([2, 5], sorted(data.lines(suite_filename)))

    def test_switch_context_with_static(self):
        # This test simulates a coverage-aware test runner,
        # measuring labeled coverage via public API,
        # with static label prefix.
        self.make_test_files()

        # Test runner starts
        cov = coverage.Coverage(context="mysuite")
        cov.start()

        if "pragma: nested":
            # Imports the test suite
            suite = import_local_file("testsuite")

            # Measures test case 1
            cov.switch_context('multiply_zero')
            suite.test_multiply_zero()

            # Measures test case 2
            cov.switch_context('multiply_six')
            suite.test_multiply_six()

            # Runner finishes
            cov.save()
            cov.stop()

        # Labeled data is collected
        data = cov.get_data()
        self.assertEqual(
            [u'mysuite', u'mysuite|multiply_six', u'mysuite|multiply_zero'],
            sorted(data.measured_contexts()),
            )

        filenames = self.get_measured_filenames(data)
        suite_filename = filenames['testsuite.py']

        data.set_query_context("mysuite|multiply_six")
        self.assertEqual([2, 8], sorted(data.lines(suite_filename)))
        data.set_query_context("mysuite|multiply_zero")
        self.assertEqual([2, 5], sorted(data.lines(suite_filename)))

    def test_dynamic_context_conflict(self):
        cov = coverage.Coverage(source=["."])
        cov.set_option("run:dynamic_context", "test_function")
        cov.start()
        # Switch twice, but only get one warning.
        cov.switch_context("test1")                                     # pragma: nested
        cov.switch_context("test2")                                     # pragma: nested
        self.assertEqual(                                               # pragma: nested
            self.stderr(),
            "Coverage.py warning: Conflicting dynamic contexts (dynamic-conflict)\n"
        )
        cov.stop()                                                      # pragma: nested

    def test_switch_context_unstarted(self):
        # Coverage must be started to switch context
        msg = "Cannot switch context, coverage is not started"
        cov = coverage.Coverage()
        with self.assertRaisesRegex(CoverageException, msg):
            cov.switch_context("test1")

        cov.start()
        cov.switch_context("test2")                                     # pragma: nested

        cov.stop()                                                      # pragma: nested
        with self.assertRaisesRegex(CoverageException, msg):
            cov.switch_context("test3")

    def test_config_crash(self):
        # The internal '[run] _crash' setting can be used to artificially raise
        # exceptions from inside Coverage.
        cov = coverage.Coverage()
        cov.set_option("run:_crash", "test_config_crash")
        with self.assertRaisesRegex(Exception, "Crashing because called by test_config_crash"):
            cov.start()

    def test_config_crash_no_crash(self):
        # '[run] _crash' really checks the call stack.
        cov = coverage.Coverage()
        cov.set_option("run:_crash", "not_my_caller")
        cov.start()
        cov.stop()

    def test_run_debug_sys(self):
        # https://github.com/nedbat/coveragepy/issues/907
        cov = coverage.Coverage()
        cov.start()
        d = dict(cov.sys_info())        # pragma: nested
        cov.stop()                      # pragma: nested
        assert d['data_file'].endswith(".coverage")


class CurrentInstanceTest(CoverageTest):
    """Tests of Coverage.current()."""

    run_in_temp_dir = False

    def assert_current_is_none(self, current):
        """Assert that a current we expect to be None is correct."""
        # During meta-coverage, the None answers will be wrong because the
        # overall coverage measurement will still be on the current-stack.
        # Since we know they will be wrong, and we have non-meta test runs
        # also, don't assert them.
        if not env.METACOV:
            assert current is None

    def test_current(self):
        cur0 = coverage.Coverage.current()
        self.assert_current_is_none(cur0)
        # Making an instance doesn't make it current.
        cov = coverage.Coverage()
        cur1 = coverage.Coverage.current()
        self.assert_current_is_none(cur1)
        assert cur0 is cur1
        # Starting the instance makes it current.
        cov.start()
        if "# pragma: nested":
            cur2 = coverage.Coverage.current()
            assert cur2 is cov
            # Stopping the instance makes current None again.
            cov.stop()

        cur3 = coverage.Coverage.current()
        self.assert_current_is_none(cur3)
        assert cur0 is cur3


class NamespaceModuleTest(UsingModulesMixin, CoverageTest):
    """Test PEP-420 namespace modules."""

    def setUp(self):
        if not env.PYBEHAVIOR.namespaces_pep420:
            self.skipTest("Python before 3.3 doesn't have namespace packages")
        super(NamespaceModuleTest, self).setUp()

    def test_explicit_namespace_module(self):
        self.make_file("main.py", "import namespace_420\n")

        cov = coverage.Coverage()
        self.start_import_stop(cov, "main")

        with self.assertRaisesRegex(CoverageException, r"Module .* has no file"):
            cov.analysis(sys.modules['namespace_420'])

    def test_bug_572(self):
        self.make_file("main.py", "import namespace_420\n")

        # Use source=namespace_420 to trigger the check that used to fail,
        # and use source=main so that something is measured.
        cov = coverage.Coverage(source=["namespace_420", "main"])
        with self.assert_warnings(cov, []):
            self.start_import_stop(cov, "main")
            cov.report()


class IncludeOmitTestsMixin(UsingModulesMixin, CoverageTestMethodsMixin):
    """Test methods for coverage methods taking include and omit."""

    # We don't write any source files, but the data file will collide with
    # other tests if we don't have a temp dir.
    no_files_in_temp_dir = True

    def filenames_in(self, summary, filenames):
        """Assert the `filenames` are in the keys of `summary`."""
        for filename in filenames.split():
            self.assertIn(filename, summary)

    def filenames_not_in(self, summary, filenames):
        """Assert the `filenames` are not in the keys of `summary`."""
        for filename in filenames.split():
            self.assertNotIn(filename, summary)

    def test_nothing_specified(self):
        result = self.coverage_usepkgs()
        self.filenames_in(result, "p1a p1b p2a p2b othera otherb osa osb")
        self.filenames_not_in(result, "p1c")
        # Because there was no source= specified, we don't search for
        # unexecuted files.

    def test_include(self):
        result = self.coverage_usepkgs(include=["*/p1a.py"])
        self.filenames_in(result, "p1a")
        self.filenames_not_in(result, "p1b p1c p2a p2b othera otherb osa osb")

    def test_include_2(self):
        result = self.coverage_usepkgs(include=["*a.py"])
        self.filenames_in(result, "p1a p2a othera osa")
        self.filenames_not_in(result, "p1b p1c p2b otherb osb")

    def test_include_as_string(self):
        result = self.coverage_usepkgs(include="*a.py")
        self.filenames_in(result, "p1a p2a othera osa")
        self.filenames_not_in(result, "p1b p1c p2b otherb osb")

    def test_omit(self):
        result = self.coverage_usepkgs(omit=["*/p1a.py"])
        self.filenames_in(result, "p1b p2a p2b")
        self.filenames_not_in(result, "p1a p1c")

    def test_omit_2(self):
        result = self.coverage_usepkgs(omit=["*a.py"])
        self.filenames_in(result, "p1b p2b otherb osb")
        self.filenames_not_in(result, "p1a p1c p2a othera osa")

    def test_omit_as_string(self):
        result = self.coverage_usepkgs(omit="*a.py")
        self.filenames_in(result, "p1b p2b otherb osb")
        self.filenames_not_in(result, "p1a p1c p2a othera osa")

    def test_omit_and_include(self):
        result = self.coverage_usepkgs(include=["*/p1*"], omit=["*/p1a.py"])
        self.filenames_in(result, "p1b")
        self.filenames_not_in(result, "p1a p1c p2a p2b")


class SourceIncludeOmitTest(IncludeOmitTestsMixin, CoverageTest):
    """Test using `source`, `include`, and `omit` when measuring code."""

    def coverage_usepkgs(self, **kwargs):
        """Run coverage on usepkgs and return the line summary.

        Arguments are passed to the `coverage.Coverage` constructor.

        """
        cov = coverage.Coverage(**kwargs)
        cov.start()
        import usepkgs  # pragma: nested   # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested
        data = cov.get_data()
        summary = line_counts(data)
        for k, v in list(summary.items()):
            assert k.endswith(".py")
            summary[k[:-3]] = v
        return summary

    def test_source_include_exclusive(self):
        cov = coverage.Coverage(source=["pkg1"], include=["pkg2"])
        with self.assert_warnings(cov, ["--include is ignored because --source is set"]):
            cov.start()
        cov.stop()      # pragma: nested

    def test_source_package_as_dir(self):
        # pkg1 is a directory, since we cd'd into tests/modules in setUp.
        lines = self.coverage_usepkgs(source=["pkg1"])
        self.filenames_in(lines, "p1a p1b")
        self.filenames_not_in(lines, "p2a p2b othera otherb osa osb")
        # Because source= was specified, we do search for unexecuted files.
        self.assertEqual(lines['p1c'], 0)

    def test_source_package_as_package(self):
        lines = self.coverage_usepkgs(source=["pkg1.sub"])
        self.filenames_not_in(lines, "p2a p2b othera otherb osa osb")
        # Because source= was specified, we do search for unexecuted files.
        self.assertEqual(lines['runmod3'], 0)

    def test_source_package_dotted(self):
        lines = self.coverage_usepkgs(source=["pkg1.p1b"])
        self.filenames_in(lines, "p1b")
        self.filenames_not_in(lines, "p1a p1c p2a p2b othera otherb osa osb")

    def test_source_package_part_omitted(self):
        # https://bitbucket.org/ned/coveragepy/issue/218
        # Used to be if you omitted something executed and inside the source,
        # then after it was executed but not recorded, it would be found in
        # the search for unexecuted files, and given a score of 0%.

        # The omit arg is by path, so need to be in the modules directory.
        self.chdir(self.nice_file(TESTS_DIR, 'modules'))
        lines = self.coverage_usepkgs(source=["pkg1"], omit=["pkg1/p1b.py"])
        self.filenames_in(lines, "p1a")
        self.filenames_not_in(lines, "p1b")
        self.assertEqual(lines['p1c'], 0)

    def test_source_package_as_package_part_omitted(self):
        # https://bitbucket.org/ned/coveragepy/issues/638/run-omit-is-ignored-since-45
        lines = self.coverage_usepkgs(source=["pkg1"], omit=["*/p1b.py"])
        self.filenames_in(lines, "p1a")
        self.filenames_not_in(lines, "p1b")
        self.assertEqual(lines['p1c'], 0)


class ReportIncludeOmitTest(IncludeOmitTestsMixin, CoverageTest):
    """Tests of the report include/omit functionality."""

    def coverage_usepkgs(self, **kwargs):
        """Try coverage.report()."""
        cov = coverage.Coverage()
        cov.start()
        import usepkgs  # pragma: nested   # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested
        report = StringIO()
        cov.report(file=report, **kwargs)
        return report.getvalue()


class XmlIncludeOmitTest(IncludeOmitTestsMixin, CoverageTest):
    """Tests of the XML include/omit functionality.

    This also takes care of the HTML and annotate include/omit, by virtue
    of the structure of the code.

    """

    def coverage_usepkgs(self, **kwargs):
        """Try coverage.xml_report()."""
        cov = coverage.Coverage()
        cov.start()
        import usepkgs  # pragma: nested   # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested
        cov.xml_report(outfile="-", **kwargs)
        return self.stdout()


class AnalysisTest(CoverageTest):
    """Test the numerical analysis of results."""
    def test_many_missing_branches(self):
        cov = coverage.Coverage(branch=True)

        self.make_file("missing.py", """\
            def fun1(x):
                if x == 1:
                    print("one")
                else:
                    print("not one")
                print("done")           # pragma: nocover

            def fun2(x):
                print("x")

            fun2(3)
            """)

        # Import the Python file, executing it.
        self.start_import_stop(cov, "missing")

        nums = cov._analyze("missing.py").numbers
        self.assertEqual(nums.n_files, 1)
        self.assertEqual(nums.n_statements, 7)
        self.assertEqual(nums.n_excluded, 1)
        self.assertEqual(nums.n_missing, 3)
        self.assertEqual(nums.n_branches, 2)
        self.assertEqual(nums.n_partial_branches, 0)
        self.assertEqual(nums.n_missing_branches, 2)


class TestRunnerPluginTest(CoverageTest):
    """Test that the API works properly the way various third-party plugins call it.

    We don't actually use the plugins, but these tests call the API the same
    way they do.

    """
    def pretend_to_be_nose_with_cover(self, erase=False, cd=False):
        """This is what the nose --with-cover plugin does."""
        self.make_file("no_biggie.py", """\
            a = 1
            b = 2
            if b == 1:
                c = 4
            """)
        self.make_file("sub/hold.txt", "")

        cov = coverage.Coverage()
        if erase:
            cov.combine()
            cov.erase()
        cov.load()
        self.start_import_stop(cov, "no_biggie")
        if cd:
            os.chdir("sub")
        cov.combine()
        cov.save()
        cov.report(["no_biggie.py"], show_missing=True)
        self.assertEqual(self.stdout(), textwrap.dedent("""\
            Name           Stmts   Miss  Cover   Missing
            --------------------------------------------
            no_biggie.py       4      1    75%   4
            """))
        if cd:
            os.chdir("..")

    def test_nose_plugin(self):
        self.pretend_to_be_nose_with_cover()

    def test_nose_plugin_with_erase(self):
        self.pretend_to_be_nose_with_cover(erase=True)

    def test_nose_plugin_with_cd(self):
        # https://github.com/nedbat/coveragepy/issues/916
        self.pretend_to_be_nose_with_cover(cd=True)

    def pretend_to_be_pytestcov(self, append):
        """Act like pytest-cov."""
        self.make_file("prog.py", """\
            a = 1
            b = 2
            if b == 1:
                c = 4
            """)
        self.make_file(".coveragerc", """\
            [run]
            parallel = True
            source = .
            """)

        cov = coverage.Coverage(source=None, branch=None, config_file='.coveragerc')
        if append:
            cov.load()
        else:
            cov.erase()
        self.start_import_stop(cov, "prog")
        cov.combine()
        cov.save()
        report = StringIO()
        cov.report(show_missing=None, ignore_errors=True, file=report, skip_covered=None,
                   skip_empty=None)
        self.assertEqual(report.getvalue(), textwrap.dedent("""\
            Name      Stmts   Miss  Cover
            -----------------------------
            prog.py       4      1    75%
            """))
        self.assert_file_count(".coverage", 0)
        self.assert_file_count(".coverage.*", 1)

    def test_pytestcov_parallel(self):
        self.pretend_to_be_pytestcov(append=False)

    def test_pytestcov_parallel_append(self):
        self.pretend_to_be_pytestcov(append=True)


class ImmutableConfigTest(CoverageTest):
    """Check that reporting methods don't permanently change the configuration."""
    def test_config_doesnt_change(self):
        self.make_file("simple.py", "a = 1")
        cov = coverage.Coverage()
        self.start_import_stop(cov, "simple")
        self.assertEqual(cov.get_option("report:show_missing"), False)
        cov.report(show_missing=True)
        self.assertEqual(cov.get_option("report:show_missing"), False)


class RelativePathTest(CoverageTest):
    """Tests of the relative_files setting."""
    def test_moving_stuff(self):
        # When using absolute file names, moving the source around results in
        # "No source for code" errors while reporting.
        self.make_file("foo.py", "a = 1")
        cov = coverage.Coverage(source=["."])
        self.start_import_stop(cov, "foo")
        res = cov.report()
        assert res == 100

        expected = re.escape("No source for code: '{}'.".format(abs_file("foo.py")))
        os.remove("foo.py")
        self.make_file("new/foo.py", "a = 1")
        shutil.move(".coverage", "new/.coverage")
        with change_dir("new"):
            cov = coverage.Coverage()
            cov.load()
            with self.assertRaisesRegex(CoverageException, expected):
                cov.report()

    def test_moving_stuff_with_relative(self):
        # When using relative file names, moving the source around is fine.
        self.make_file("foo.py", "a = 1")
        self.make_file(".coveragerc", """\
            [run]
            relative_files = true
            """)
        cov = coverage.Coverage(source=["."])
        self.start_import_stop(cov, "foo")
        res = cov.report()
        assert res == 100

        os.remove("foo.py")
        self.make_file("new/foo.py", "a = 1")
        shutil.move(".coverage", "new/.coverage")
        shutil.move(".coveragerc", "new/.coveragerc")
        with change_dir("new"):
            cov = coverage.Coverage()
            cov.load()
            res = cov.report()
            assert res == 100

    def test_combine_relative(self):
        self.make_file("dir1/foo.py", "a = 1")
        self.make_file("dir1/.coveragerc", """\
            [run]
            relative_files = true
            """)
        with change_dir("dir1"):
            cov = coverage.Coverage(source=["."], data_suffix=True)
            self.start_import_stop(cov, "foo")
            cov.save()
            shutil.move(glob.glob(".coverage.*")[0], "..")

        self.make_file("dir2/bar.py", "a = 1")
        self.make_file("dir2/.coveragerc", """\
            [run]
            relative_files = true
            """)
        with change_dir("dir2"):
            cov = coverage.Coverage(source=["."], data_suffix=True)
            self.start_import_stop(cov, "bar")
            cov.save()
            shutil.move(glob.glob(".coverage.*")[0], "..")

        self.make_file(".coveragerc", """\
            [run]
            relative_files = true
            """)
        cov = coverage.Coverage()
        cov.combine()
        cov.save()

        self.make_file("foo.py", "a = 1")
        self.make_file("bar.py", "a = 1")

        cov = coverage.Coverage()
        cov.load()
        files = cov.get_data().measured_files()
        assert files == {'foo.py', 'bar.py'}
        res = cov.report()
        assert res == 100
