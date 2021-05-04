# coding: utf-8
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Test text-based summary reporting for coverage.py"""

import glob
import os
import os.path
import py_compile
import re

import coverage
from coverage import env
from coverage.backward import StringIO
from coverage.control import Coverage
from coverage.data import CoverageData
from coverage.misc import CoverageException, output_encoding
from coverage.summary import SummaryReporter

from tests.coveragetest import CoverageTest, TESTS_DIR, UsingModulesMixin


class SummaryTest(UsingModulesMixin, CoverageTest):
    """Tests of the text summary reporting for coverage.py."""

    def make_mycode(self):
        """Make the mycode.py file when needed."""
        self.make_file("mycode.py", """\
            import covmod1
            import covmodzip1
            a = 1
            print('done')
            """)
        self.omit_site_packages()

    def omit_site_packages(self):
        """Write a .coveragerc file that will omit site-packages from reports."""
        self.make_file(".coveragerc", """\
            [report]
            omit = */site-packages/*
            """)

    def test_report(self):
        self.make_mycode()
        out = self.run_command("coverage run mycode.py")
        self.assertEqual(out, 'done\n')
        report = self.report_from_command("coverage report")

        # Name                                           Stmts   Miss  Cover
        # ------------------------------------------------------------------
        # c:/ned/coverage/tests/modules/covmod1.py           2      0   100%
        # c:/ned/coverage/tests/zipmods.zip/covmodzip1.py    2      0   100%
        # mycode.py                                          4      0   100%
        # ------------------------------------------------------------------
        # TOTAL                                              8      0   100%

        self.assertNotIn("/coverage/__init__/", report)
        self.assertIn("/tests/modules/covmod1.py ", report)
        self.assertIn("/tests/zipmods.zip/covmodzip1.py ", report)
        self.assertIn("mycode.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "TOTAL 8 0 100%")

    def test_report_just_one(self):
        # Try reporting just one module
        self.make_mycode()
        self.run_command("coverage run mycode.py")
        report = self.report_from_command("coverage report mycode.py")

        # Name        Stmts   Miss  Cover
        # -------------------------------
        # mycode.py       4      0   100%

        self.assertEqual(self.line_count(report), 3)
        self.assertNotIn("/coverage/", report)
        self.assertNotIn("/tests/modules/covmod1.py ", report)
        self.assertNotIn("/tests/zipmods.zip/covmodzip1.py ", report)
        self.assertIn("mycode.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mycode.py 4 0 100%")

    def test_report_wildcard(self):
        # Try reporting using wildcards to get the modules.
        self.make_mycode()
        self.run_command("coverage run mycode.py")
        report = self.report_from_command("coverage report my*.py")

        # Name        Stmts   Miss  Cover
        # -------------------------------
        # mycode.py       4      0   100%

        self.assertEqual(self.line_count(report), 3)
        self.assertNotIn("/coverage/", report)
        self.assertNotIn("/tests/modules/covmod1.py ", report)
        self.assertNotIn("/tests/zipmods.zip/covmodzip1.py ", report)
        self.assertIn("mycode.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mycode.py 4 0 100%")

    def test_report_omitting(self):
        # Try reporting while omitting some modules
        self.make_mycode()
        self.run_command("coverage run mycode.py")
        omit = '{}/*,*/site-packages/*'.format(TESTS_DIR)
        report = self.report_from_command("coverage report --omit '{}'".format(omit))

        # Name        Stmts   Miss  Cover
        # -------------------------------
        # mycode.py       4      0   100%

        self.assertEqual(self.line_count(report), 3)
        self.assertNotIn("/coverage/", report)
        self.assertNotIn("/tests/modules/covmod1.py ", report)
        self.assertNotIn("/tests/zipmods.zip/covmodzip1.py ", report)
        self.assertIn("mycode.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mycode.py 4 0 100%")

    def test_report_including(self):
        # Try reporting while including some modules
        self.make_mycode()
        self.run_command("coverage run mycode.py")
        report = self.report_from_command("coverage report --include=mycode*")

        # Name        Stmts   Miss  Cover
        # -------------------------------
        # mycode.py       4      0   100%

        self.assertEqual(self.line_count(report), 3)
        self.assertNotIn("/coverage/", report)
        self.assertNotIn("/tests/modules/covmod1.py ", report)
        self.assertNotIn("/tests/zipmods.zip/covmodzip1.py ", report)
        self.assertIn("mycode.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mycode.py 4 0 100%")

    def test_run_source_vs_report_include(self):
        # https://bitbucket.org/ned/coveragepy/issues/621/include-ignored-warning-when-using
        self.make_file(".coveragerc", """\
            [run]
            source = .

            [report]
            include = mod/*,tests/*
            """)
        # It should be OK to use that configuration.
        cov = coverage.Coverage()
        with self.assert_warnings(cov, []):
            cov.start()
            cov.stop()                                                  # pragma: nested

    def test_run_omit_vs_report_omit(self):
        # https://bitbucket.org/ned/coveragepy/issues/622/report-omit-overwrites-run-omit
        # report:omit shouldn't clobber run:omit.
        self.make_mycode()
        self.make_file(".coveragerc", """\
            [run]
            omit = */covmodzip1.py

            [report]
            omit = */covmod1.py
            """)
        self.run_command("coverage run mycode.py")

        # Read the data written, to see that the right files have been omitted from running.
        covdata = CoverageData()
        covdata.read()
        files = [os.path.basename(p) for p in covdata.measured_files()]
        self.assertIn("covmod1.py", files)
        self.assertNotIn("covmodzip1.py", files)

    def test_report_branches(self):
        self.make_file("mybranch.py", """\
            def branch(x):
                if x:
                    print("x")
                return x
            branch(1)
            """)
        out = self.run_command("coverage run --source=. --branch mybranch.py")
        self.assertEqual(out, 'x\n')
        report = self.report_from_command("coverage report")

        # Name          Stmts   Miss Branch BrPart  Cover
        # -----------------------------------------------
        # mybranch.py       5      0      2      1    85%

        self.assertEqual(self.line_count(report), 3)
        self.assertIn("mybranch.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mybranch.py 5 0 2 1 86%")

    def test_report_show_missing(self):
        self.make_file("mymissing.py", """\
            def missing(x, y):
                if x:
                    print("x")
                    return x
                if y:
                    print("y")
                try:
                    print("z")
                    1/0
                    print("Never!")
                except ZeroDivisionError:
                    pass
                return x
            missing(0, 1)
            """)
        out = self.run_command("coverage run --source=. mymissing.py")
        self.assertEqual(out, 'y\nz\n')
        report = self.report_from_command("coverage report --show-missing")

        # Name           Stmts   Miss  Cover   Missing
        # --------------------------------------------
        # mymissing.py      14      3    79%   3-4, 10

        self.assertEqual(self.line_count(report), 3)
        self.assertIn("mymissing.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mymissing.py 14 3 79% 3-4, 10")

    def test_report_show_missing_branches(self):
        self.make_file("mybranch.py", """\
            def branch(x, y):
                if x:
                    print("x")
                if y:
                    print("y")
            branch(1, 1)
            """)
        self.omit_site_packages()
        out = self.run_command("coverage run --branch mybranch.py")
        self.assertEqual(out, 'x\ny\n')
        report = self.report_from_command("coverage report --show-missing")

        # Name           Stmts   Miss Branch BrPart  Cover   Missing
        # ----------------------------------------------------------
        # mybranch.py        6      0      4      2    80%   2->4, 4->exit

        self.assertEqual(self.line_count(report), 3)
        self.assertIn("mybranch.py ", report)
        self.assertEqual(self.last_line_squeezed(report), "mybranch.py 6 0 4 2 80% 2->4, 4->exit")

    def test_report_show_missing_branches_and_lines(self):
        self.make_file("main.py", """\
            import mybranch
            """)
        self.make_file("mybranch.py", """\
            def branch(x, y, z):
                if x:
                    print("x")
                if y:
                    print("y")
                if z:
                    if x and y:
                        print("z")
                return x
            branch(1, 1, 0)
            """)
        self.omit_site_packages()
        out = self.run_command("coverage run --branch main.py")
        self.assertEqual(out, 'x\ny\n')
        report = self.report_from_command("coverage report --show-missing")
        report_lines = report.splitlines()

        expected = [
            'Name          Stmts   Miss Branch BrPart  Cover   Missing',
            '---------------------------------------------------------',
            'main.py           1      0      0      0   100%',
            'mybranch.py      10      2      8      3    61%   2->4, 4->6, 6->7, 7-8',
            '---------------------------------------------------------',
            'TOTAL            11      2      8      3    63%',
        ]
        self.assertEqual(expected, report_lines)

    def test_report_skip_covered_no_branches(self):
        self.make_file("main.py", """
            import not_covered

            def normal():
                print("z")
            normal()
            """)
        self.make_file("not_covered.py", """
            def not_covered():
                print("n")
            """)
        self.omit_site_packages()
        out = self.run_command("coverage run main.py")
        self.assertEqual(out, "z\n")
        report = self.report_from_command("coverage report --skip-covered --fail-under=70")

        # Name             Stmts   Miss  Cover
        # ------------------------------------
        # not_covered.py       2      1    50%
        # ------------------------------------
        # TOTAL                6      1    83%
        #
        # 1 file skipped due to complete coverage.

        self.assertEqual(self.line_count(report), 7, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[2], "not_covered.py 2 1 50%")
        self.assertEqual(squeezed[4], "TOTAL 6 1 83%")
        self.assertEqual(squeezed[6], "1 file skipped due to complete coverage.")
        self.assertEqual(self.last_command_status, 0)

    def test_report_skip_covered_branches(self):
        self.make_file("main.py", """
            import not_covered, covered

            def normal(z):
                if z:
                    print("z")
            normal(True)
            normal(False)
            """)
        self.make_file("not_covered.py", """
            def not_covered(n):
                if n:
                    print("n")
            not_covered(True)
            """)
        self.make_file("covered.py", """
            def foo():
                pass
            foo()
            """)
        self.omit_site_packages()
        out = self.run_command("coverage run --branch main.py")
        self.assertEqual(out, "n\nz\n")
        report = self.report_from_command("coverage report --skip-covered")

        # Name             Stmts   Miss Branch BrPart  Cover
        # --------------------------------------------------
        # not_covered.py       4      0      2      1    83%
        # --------------------------------------------------
        # TOTAL               13      0      4      1    94%
        #
        # 2 files skipped due to complete coverage.

        self.assertEqual(self.line_count(report), 7, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[2], "not_covered.py 4 0 2 1 83%")
        self.assertEqual(squeezed[4], "TOTAL 13 0 4 1 94%")
        self.assertEqual(squeezed[6], "2 files skipped due to complete coverage.")

    def test_report_skip_covered_branches_with_totals(self):
        self.make_file("main.py", """
            import not_covered
            import also_not_run

            def normal(z):
                if z:
                    print("z")
            normal(True)
            normal(False)
            """)
        self.make_file("not_covered.py", """
            def not_covered(n):
                if n:
                    print("n")
            not_covered(True)
            """)
        self.make_file("also_not_run.py", """
            def does_not_appear_in_this_film(ni):
                print("Ni!")
            """)
        self.omit_site_packages()
        out = self.run_command("coverage run --branch main.py")
        self.assertEqual(out, "n\nz\n")
        report = self.report_from_command("coverage report --skip-covered")

        # Name             Stmts   Miss Branch BrPart  Cover
        # --------------------------------------------------
        # also_not_run.py      2      1      0      0    50%
        # not_covered.py       4      0      2      1    83%
        # --------------------------------------------------
        # TOTAL                13     1      4      1    88%
        #
        # 1 file skipped due to complete coverage.

        self.assertEqual(self.line_count(report), 8, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[2], "also_not_run.py 2 1 0 0 50%")
        self.assertEqual(squeezed[3], "not_covered.py 4 0 2 1 83%")
        self.assertEqual(squeezed[5], "TOTAL 13 1 4 1 88%")
        self.assertEqual(squeezed[7], "1 file skipped due to complete coverage.")

    def test_report_skip_covered_all_files_covered(self):
        self.make_file("main.py", """
            def foo():
                pass
            foo()
            """)
        out = self.run_command("coverage run --source=. --branch main.py")
        self.assertEqual(out, "")
        report = self.report_from_command("coverage report --skip-covered")

        # Name      Stmts   Miss Branch BrPart  Cover
        # -------------------------------------------
        #
        # 1 file skipped due to complete coverage.

        self.assertEqual(self.line_count(report), 4, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[3], "1 file skipped due to complete coverage.")

    def test_report_skip_covered_longfilename(self):
        self.make_file("long_______________filename.py", """
            def foo():
                pass
            foo()
            """)
        out = self.run_command("coverage run --source=. --branch long_______________filename.py")
        self.assertEqual(out, "")
        report = self.report_from_command("coverage report --skip-covered")

        # Name    Stmts   Miss Branch BrPart  Cover
        # -----------------------------------------
        #
        # 1 file skipped due to complete coverage.

        self.assertEqual(self.line_count(report), 4, report)
        lines = self.report_lines(report)
        self.assertEqual(lines[0], "Name    Stmts   Miss Branch BrPart  Cover")
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[3], "1 file skipped due to complete coverage.")

    def test_report_skip_covered_no_data(self):
        report = self.report_from_command("coverage report --skip-covered")

        # No data to report.

        self.assertEqual(self.line_count(report), 1, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[0], "No data to report.")

    def test_report_skip_empty(self):
        self.make_file("main.py", """
            import submodule

            def normal():
                print("z")
            normal()
            """)
        self.make_file("submodule/__init__.py", "")
        self.omit_site_packages()
        out = self.run_command("coverage run main.py")
        self.assertEqual(out, "z\n")
        report = self.report_from_command("coverage report --skip-empty")

        # Name             Stmts   Miss  Cover
        # ------------------------------------
        # main.py              4      0   100%
        # ------------------------------------
        # TOTAL                4      0   100%
        #
        # 1 empty file skipped.

        self.assertEqual(self.line_count(report), 7, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[2], "main.py 4 0 100%")
        self.assertEqual(squeezed[4], "TOTAL 4 0 100%")
        self.assertEqual(squeezed[6], "1 empty file skipped.")
        self.assertEqual(self.last_command_status, 0)

    def test_report_skip_empty_no_data(self):
        self.make_file("__init__.py", "")
        self.omit_site_packages()
        out = self.run_command("coverage run __init__.py")
        self.assertEqual(out, "")
        report = self.report_from_command("coverage report --skip-empty")

        # Name             Stmts   Miss  Cover
        # ------------------------------------
        #
        # 1 empty file skipped.

        self.assertEqual(self.line_count(report), 4, report)
        lines = self.report_lines(report)
        self.assertEqual(lines[3], "1 empty file skipped.")

    def test_report_precision(self):
        self.make_file(".coveragerc", """\
            [report]
            precision = 3
            omit = */site-packages/*
            """)
        self.make_file("main.py", """
            import not_covered, covered

            def normal(z):
                if z:
                    print("z")
            normal(True)
            normal(False)
            """)
        self.make_file("not_covered.py", """
            def not_covered(n):
                if n:
                    print("n")
            not_covered(True)
            """)
        self.make_file("covered.py", """
            def foo():
                pass
            foo()
            """)
        out = self.run_command("coverage run --branch main.py")
        self.assertEqual(out, "n\nz\n")
        report = self.report_from_command("coverage report")

        # Name             Stmts   Miss Branch BrPart      Cover
        # ------------------------------------------------------
        # covered.py           3      0      0      0   100.000%
        # main.py              6      0      2      0   100.000%
        # not_covered.py       4      0      2      1    83.333%
        # ------------------------------------------------------
        # TOTAL               13      0      4      1    94.118%

        self.assertEqual(self.line_count(report), 7, report)
        squeezed = self.squeezed_lines(report)
        self.assertEqual(squeezed[2], "covered.py 3 0 0 0 100.000%")
        self.assertEqual(squeezed[4], "not_covered.py 4 0 2 1 83.333%")
        self.assertEqual(squeezed[6], "TOTAL 13 0 4 1 94.118%")

    def test_dotpy_not_python(self):
        # We run a .py file, and when reporting, we can't parse it as Python.
        # We should get an error message in the report.

        self.make_mycode()
        self.run_command("coverage run mycode.py")
        self.make_file("mycode.py", "This isn't python at all!")
        report = self.report_from_command("coverage report mycode.py")

        # Couldn't parse '...' as Python source: 'invalid syntax' at line 1
        # Name     Stmts   Miss  Cover
        # ----------------------------
        # No data to report.

        errmsg = self.squeezed_lines(report)[0]
        # The actual file name varies run to run.
        errmsg = re.sub(r"parse '.*mycode.py", "parse 'mycode.py", errmsg)
        # The actual error message varies version to version
        errmsg = re.sub(r": '.*' at", ": 'error' at", errmsg)
        self.assertEqual(
            "Couldn't parse 'mycode.py' as Python source: 'error' at line 1",
            errmsg,
        )

    def test_accenteddotpy_not_python(self):
        if env.JYTHON:
            self.skipTest("Jython doesn't like accented file names")

        # We run a .py file with a non-ascii name, and when reporting, we can't
        # parse it as Python.  We should get an error message in the report.

        self.make_file(u"accented\xe2.py", "print('accented')")
        self.run_command(u"coverage run accented\xe2.py")
        self.make_file(u"accented\xe2.py", "This isn't python at all!")
        report = self.report_from_command(u"coverage report accented\xe2.py")

        # Couldn't parse '...' as Python source: 'invalid syntax' at line 1
        # Name     Stmts   Miss  Cover
        # ----------------------------
        # No data to report.

        errmsg = self.squeezed_lines(report)[0]
        # The actual file name varies run to run.
        errmsg = re.sub(r"parse '.*(accented.*?\.py)", r"parse '\1", errmsg)
        # The actual error message varies version to version
        errmsg = re.sub(r": '.*' at", ": 'error' at", errmsg)
        expected = u"Couldn't parse 'accented\xe2.py' as Python source: 'error' at line 1"
        if env.PY2:
            expected = expected.encode(output_encoding())
        self.assertEqual(expected, errmsg)

    def test_dotpy_not_python_ignored(self):
        # We run a .py file, and when reporting, we can't parse it as Python,
        # but we've said to ignore errors, so there's no error reported,
        # though we still get a warning.
        self.make_mycode()
        self.run_command("coverage run mycode.py")
        self.make_file("mycode.py", "This isn't python at all!")
        report = self.report_from_command("coverage report -i mycode.py")

        # Coverage.py warning: Couldn't parse Python file blah_blah/mycode.py (couldnt-parse)
        # Name     Stmts   Miss  Cover
        # ----------------------------
        # No data to report.

        self.assertEqual(self.line_count(report), 4)
        self.assertIn('No data to report.', report)
        self.assertIn('(couldnt-parse)', report)

    def test_dothtml_not_python(self):
        # We run a .html file, and when reporting, we can't parse it as
        # Python.  Since it wasn't .py, no error is reported.

        # Run an "html" file
        self.make_file("mycode.html", "a = 1")
        self.run_command("coverage run mycode.html")
        # Before reporting, change it to be an HTML file.
        self.make_file("mycode.html", "<h1>This isn't python at all!</h1>")
        report = self.report_from_command("coverage report mycode.html")

        # Name     Stmts   Miss  Cover
        # ----------------------------
        # No data to report.

        self.assertEqual(self.line_count(report), 3)
        self.assertIn('No data to report.', report)

    def test_report_no_extension(self):
        self.make_file("xxx", """\
            # This is a python file though it doesn't look like it, like a main script.
            a = b = c = d = 0
            a = 3
            b = 4
            if not b:
                c = 6
            d = 7
            print("xxx: %r %r %r %r" % (a, b, c, d))
            """)
        out = self.run_command("coverage run --source=. xxx")
        self.assertEqual(out, "xxx: 3 4 0 7\n")
        report = self.report_from_command("coverage report")
        self.assertEqual(self.last_line_squeezed(report), "xxx 7 1 86%")

    def test_report_with_chdir(self):
        self.make_file("chdir.py", """\
            import os
            print("Line One")
            os.chdir("subdir")
            print("Line Two")
            print(open("something").read())
            """)
        self.make_file("subdir/something", "hello")
        out = self.run_command("coverage run --source=. chdir.py")
        self.assertEqual(out, "Line One\nLine Two\nhello\n")
        report = self.report_from_command("coverage report")
        self.assertEqual(self.last_line_squeezed(report), "chdir.py 5 0 100%")

    def get_report(self, cov):
        """Get the report from `cov`, and canonicalize it."""
        repout = StringIO()
        cov.report(file=repout, show_missing=False)
        report = repout.getvalue().replace('\\', '/')
        report = re.sub(r" +", " ", report)
        return report

    def test_bug_156_file_not_run_should_be_zero(self):
        # https://bitbucket.org/ned/coveragepy/issue/156
        self.make_file("mybranch.py", """\
            def branch(x):
                if x:
                    print("x")
                return x
            branch(1)
            """)
        self.make_file("main.py", """\
            print("y")
            """)
        cov = coverage.Coverage(branch=True, source=["."])
        cov.start()
        import main     # pragma: nested # pylint: disable=unused-import
        cov.stop()      # pragma: nested
        report = self.get_report(cov).splitlines()
        self.assertIn("mybranch.py 5 5 2 0 0%", report)

    def run_TheCode_and_report_it(self):
        """A helper for the next few tests."""
        cov = coverage.Coverage()
        cov.start()
        import TheCode  # pragma: nested # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested
        return self.get_report(cov)

    def test_bug_203_mixed_case_listed_twice_with_rc(self):
        self.make_file("TheCode.py", "a = 1\n")
        self.make_file(".coveragerc", "[run]\nsource = .\n")

        report = self.run_TheCode_and_report_it()

        self.assertIn("TheCode", report)
        self.assertNotIn("thecode", report)

    def test_bug_203_mixed_case_listed_twice(self):
        self.make_file("TheCode.py", "a = 1\n")

        report = self.run_TheCode_and_report_it()

        self.assertIn("TheCode", report)
        self.assertNotIn("thecode", report)

    def test_pyw_files(self):
        if not env.WINDOWS:
            self.skipTest(".pyw files are only on Windows.")

        # https://bitbucket.org/ned/coveragepy/issue/261
        self.make_file("start.pyw", """\
            import mod
            print("In start.pyw")
            """)
        self.make_file("mod.pyw", """\
            print("In mod.pyw")
            """)
        cov = coverage.Coverage()
        cov.start()
        import start    # pragma: nested # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested

        report = self.get_report(cov)
        self.assertNotIn("NoSource", report)
        report = report.splitlines()
        self.assertIn("start.pyw 2 0 100%", report)
        self.assertIn("mod.pyw 1 0 100%", report)

    def test_tracing_pyc_file(self):
        # Create two Python files.
        self.make_file("mod.py", "a = 1\n")
        self.make_file("main.py", "import mod\n")

        # Make one into a .pyc.
        py_compile.compile("mod.py")

        # Run the program.
        cov = coverage.Coverage()
        cov.start()
        import main     # pragma: nested # pylint: disable=unused-import
        cov.stop()      # pragma: nested

        report = self.get_report(cov).splitlines()
        self.assertIn("mod.py 1 0 100%", report)

    def test_missing_py_file_during_run(self):
        # PyPy2 doesn't run bare .pyc files.
        if env.PYPY2:
            self.skipTest("PyPy2 doesn't run bare .pyc files")

        # Create two Python files.
        self.make_file("mod.py", "a = 1\n")
        self.make_file("main.py", "import mod\n")

        # Make one into a .pyc, and remove the .py.
        py_compile.compile("mod.py")
        os.remove("mod.py")

        # Python 3 puts the .pyc files in a __pycache__ directory, and will
        # not import from there without source.  It will import a .pyc from
        # the source location though.
        if env.PY3 and not env.JYTHON:
            pycs = glob.glob("__pycache__/mod.*.pyc")
            self.assertEqual(len(pycs), 1)
            os.rename(pycs[0], "mod.pyc")

        # Run the program.
        cov = coverage.Coverage()
        cov.start()
        import main     # pragma: nested # pylint: disable=unused-import
        cov.stop()      # pragma: nested

        # Put back the missing Python file.
        self.make_file("mod.py", "a = 1\n")
        report = self.get_report(cov).splitlines()
        self.assertIn("mod.py 1 0 100%", report)


class SummaryTest2(UsingModulesMixin, CoverageTest):
    """Another bunch of summary tests."""
    # This class exists because tests naturally clump into classes based on the
    # needs of their setUp, rather than the product features they are testing.
    # There's probably a better way to organize these.

    run_in_temp_dir = False

    def test_empty_files(self):
        # Shows that empty files like __init__.py are listed as having zero
        # statements, not one statement.
        cov = coverage.Coverage(branch=True)
        cov.start()
        import usepkgs  # pragma: nested # pylint: disable=import-error, unused-import
        cov.stop()      # pragma: nested

        repout = StringIO()
        cov.report(file=repout, show_missing=False)

        report = repout.getvalue().replace('\\', '/')
        report = re.sub(r"\s+", " ", report)
        self.assertIn("tests/modules/pkg1/__init__.py 1 0 0 0 100%", report)
        self.assertIn("tests/modules/pkg2/__init__.py 0 0 0 0 100%", report)


class ReportingReturnValueTest(CoverageTest):
    """Tests of reporting functions returning values."""

    def run_coverage(self):
        """Run coverage on doit.py and return the coverage object."""
        self.make_file("doit.py", """\
            a = 1
            b = 2
            c = 3
            d = 4
            if a > 10:
                f = 6
            g = 7
            """)

        cov = coverage.Coverage()
        self.start_import_stop(cov, "doit")
        return cov

    def test_report(self):
        cov = self.run_coverage()
        val = cov.report(include="*/doit.py")
        self.assertAlmostEqual(val, 85.7, 1)

    def test_html(self):
        cov = self.run_coverage()
        val = cov.html_report(include="*/doit.py")
        self.assertAlmostEqual(val, 85.7, 1)

    def test_xml(self):
        cov = self.run_coverage()
        val = cov.xml_report(include="*/doit.py")
        self.assertAlmostEqual(val, 85.7, 1)


class TestSummaryReporterConfiguration(CoverageTest):
    """Tests of SummaryReporter."""

    def make_rigged_file(self, filename, stmts, miss):
        """Create a file that will have specific results.

        `stmts` and `miss` are ints, the number of statements, and
        missed statements that should result.
        """
        run = stmts - miss - 1
        dont_run = miss
        source = ""
        source += "a = 1\n" * run
        source += "if a == 99:\n"
        source += "    a = 2\n" * dont_run
        self.make_file(filename, source)

    def get_summary_text(self, *options):
        """Get text output from the SummaryReporter.

        The arguments are tuples: (name, value) for Coverage.set_option.
        """
        self.make_rigged_file("file1.py", 339, 155)
        self.make_rigged_file("file2.py", 13, 3)
        self.make_rigged_file("file3.py", 234, 228)
        self.make_file("doit.py", "import file1, file2, file3")

        cov = Coverage(source=["."], omit=["doit.py"])
        cov.start()
        import doit             # pragma: nested # pylint: disable=import-error, unused-import
        cov.stop()              # pragma: nested
        for name, value in options:
            cov.set_option(name, value)
        printer = SummaryReporter(cov)
        destination = StringIO()
        printer.report([], destination)
        return destination.getvalue()

    def test_test_data(self):
        # We use our own test files as test data. Check that our assumptions
        # about them are still valid.  We want the three columns of numbers to
        # sort in three different orders.
        report = self.get_summary_text()
        print(report)
        # Name                     Stmts   Miss  Cover
        # --------------------------------------------
        # tests/test_api.py          339    155    54%
        # tests/test_backward.py      13      3    77%
        # tests/test_coverage.py     234    228     3%
        # --------------------------------------------
        # TOTAL                      586    386    34%

        lines = report.splitlines()[2:-2]
        self.assertEqual(len(lines), 3)
        nums = [list(map(int, l.replace('%', '').split()[1:])) for l in lines]
        # [
        #  [339, 155, 54],
        #  [ 13,   3, 77],
        #  [234, 228,  3]
        # ]
        self.assertTrue(nums[1][0] < nums[2][0] < nums[0][0])
        self.assertTrue(nums[1][1] < nums[0][1] < nums[2][1])
        self.assertTrue(nums[2][2] < nums[0][2] < nums[1][2])

    def test_defaults(self):
        """Run the report with no configuration options."""
        report = self.get_summary_text()
        self.assertNotIn('Missing', report)
        self.assertNotIn('Branch', report)

    def test_print_missing(self):
        """Run the report printing the missing lines."""
        report = self.get_summary_text(('report:show_missing', True))
        self.assertIn('Missing', report)
        self.assertNotIn('Branch', report)

    def assert_ordering(self, text, *words):
        """Assert that the `words` appear in order in `text`."""
        indexes = list(map(text.find, words))
        self.assertEqual(
            indexes, sorted(indexes),
            "The words %r don't appear in order in %r" % (words, text)
        )

    def test_sort_report_by_stmts(self):
        # Sort the text report by the Stmts column.
        report = self.get_summary_text(('report:sort', 'Stmts'))
        self.assert_ordering(report, "test_backward.py", "test_coverage.py", "test_api.py")

    def test_sort_report_by_missing(self):
        # Sort the text report by the Missing column.
        report = self.get_summary_text(('report:sort', 'Miss'))
        self.assert_ordering(report, "test_backward.py", "test_api.py", "test_coverage.py")

    def test_sort_report_by_cover(self):
        # Sort the text report by the Cover column.
        report = self.get_summary_text(('report:sort', 'Cover'))
        self.assert_ordering(report, "test_coverage.py", "test_api.py", "test_backward.py")

    def test_sort_report_by_invalid_option(self):
        # Sort the text report by a nonsense column.
        msg = "Invalid sorting option: 'Xyzzy'"
        with self.assertRaisesRegex(CoverageException, msg):
            self.get_summary_text(('report:sort', 'Xyzzy'))
