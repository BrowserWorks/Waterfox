# coding: utf-8
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for XML reports from coverage.py."""

import os
import os.path
import re
from xml.etree import ElementTree

from unittest_mixins import change_dir

import coverage
from coverage.backward import import_local_file
from coverage.files import abs_file

from tests.coveragetest import CoverageTest
from tests.goldtest import compare, gold_path


class XmlTestHelpers(CoverageTest):
    """Methods to use from XML tests."""

    def run_mycode(self):
        """Run mycode.py, so we can report on it."""
        self.make_file("mycode.py", "print('hello')\n")
        self.run_command("coverage run mycode.py")

    def run_doit(self):
        """Construct a simple sub-package."""
        self.make_file("sub/__init__.py")
        self.make_file("sub/doit.py", "print('doit!')")
        self.make_file("main.py", "import sub.doit")
        cov = coverage.Coverage(source=["."])
        self.start_import_stop(cov, "main")
        return cov

    def make_tree(self, width, depth, curdir="."):
        """Make a tree of packages.

        Makes `width` directories, named d0 .. d{width-1}. Each directory has
        __init__.py, and `width` files, named f0.py .. f{width-1}.py.  Each
        directory also has `width` sub-directories, in the same fashion, until
        a depth of `depth` is reached.

        """
        if depth == 0:
            return

        def here(p):
            """A path for `p` in our currently interesting directory."""
            return os.path.join(curdir, p)

        for i in range(width):
            next_dir = here("d{}".format(i))
            self.make_tree(width, depth-1, next_dir)
        if curdir != ".":
            self.make_file(here("__init__.py"), "")
            for i in range(width):
                filename = here("f{}.py".format(i))
                self.make_file(filename, "# {}\n".format(filename))

    def assert_source(self, xmldom, src):
        """Assert that the XML has a <source> element with `src`."""
        src = abs_file(src)
        elts = xmldom.findall(".//sources/source")
        assert any(elt.text == src for elt in elts)


class XmlTestHelpersTest(XmlTestHelpers, CoverageTest):
    """Tests of methods in XmlTestHelpers."""

    run_in_temp_dir = False

    def test_assert_source(self):
        dom = ElementTree.fromstring("""\
            <doc>
                <src>foo</src>
                <sources>
                    <source>{cwd}something</source>
                    <source>{cwd}another</source>
                </sources>
            </doc>
            """.format(cwd=abs_file(".")+os.sep))

        self.assert_source(dom, "something")
        self.assert_source(dom, "another")

        with self.assertRaises(AssertionError):
            self.assert_source(dom, "hello")
        with self.assertRaises(AssertionError):
            self.assert_source(dom, "foo")
        with self.assertRaises(AssertionError):
            self.assert_source(dom, "thing")


class XmlReportTest(XmlTestHelpers, CoverageTest):
    """Tests of the XML reports from coverage.py."""

    def test_default_file_placement(self):
        self.run_mycode()
        self.run_command("coverage xml")
        self.assert_exists("coverage.xml")

    def test_argument_affects_xml_placement(self):
        self.run_mycode()
        self.run_command("coverage xml -o put_it_there.xml")
        self.assert_doesnt_exist("coverage.xml")
        self.assert_exists("put_it_there.xml")

    def test_config_file_directory_does_not_exist(self):
        self.run_mycode()
        self.run_command("coverage xml -o nonexistent/put_it_there.xml")
        self.assert_doesnt_exist("coverage.xml")
        self.assert_doesnt_exist("put_it_there.xml")
        self.assert_exists("nonexistent/put_it_there.xml")

    def test_config_affects_xml_placement(self):
        self.run_mycode()
        self.make_file(".coveragerc", "[xml]\noutput = xml.out\n")
        self.run_command("coverage xml")
        self.assert_doesnt_exist("coverage.xml")
        self.assert_exists("xml.out")

    def test_no_data(self):
        # https://bitbucket.org/ned/coveragepy/issue/210
        self.run_command("coverage xml")
        self.assert_doesnt_exist("coverage.xml")

    def test_no_source(self):
        # Written while investigating a bug, might as well keep it.
        # https://bitbucket.org/ned/coveragepy/issue/208
        self.make_file("innocuous.py", "a = 4")
        cov = coverage.Coverage()
        self.start_import_stop(cov, "innocuous")
        os.remove("innocuous.py")
        cov.xml_report(ignore_errors=True)
        self.assert_exists("coverage.xml")

    def test_filename_format_showing_everything(self):
        cov = self.run_doit()
        cov.xml_report()
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//class[@name='doit.py']")
        assert len(elts) == 1
        assert elts[0].get('filename') == "sub/doit.py"

    def test_filename_format_including_filename(self):
        cov = self.run_doit()
        cov.xml_report(["sub/doit.py"])
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//class[@name='doit.py']")
        assert len(elts) == 1
        assert elts[0].get('filename') == "sub/doit.py"

    def test_filename_format_including_module(self):
        cov = self.run_doit()
        import sub.doit                         # pylint: disable=import-error
        cov.xml_report([sub.doit])
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//class[@name='doit.py']")
        assert len(elts) == 1
        assert elts[0].get('filename') == "sub/doit.py"

    def test_reporting_on_nothing(self):
        # Used to raise a zero division error:
        # https://bitbucket.org/ned/coveragepy/issue/250
        self.make_file("empty.py", "")
        cov = coverage.Coverage()
        empty = self.start_import_stop(cov, "empty")
        cov.xml_report([empty])
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//class[@name='empty.py']")
        assert len(elts) == 1
        assert elts[0].get('filename') == "empty.py"
        assert elts[0].get('line-rate') == '1'

    def test_empty_file_is_100_not_0(self):
        # https://bitbucket.org/ned/coveragepy/issue/345
        cov = self.run_doit()
        cov.xml_report()
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//class[@name='__init__.py']")
        assert len(elts) == 1
        assert elts[0].get('line-rate') == '1'

    def test_curdir_source(self):
        # With no source= option, the XML report should explain that the source
        # is in the current directory.
        cov = self.run_doit()
        cov.xml_report()
        dom = ElementTree.parse("coverage.xml")
        self.assert_source(dom, ".")
        sources = dom.findall(".//source")
        assert len(sources) == 1

    def test_deep_source(self):
        # When using source=, the XML report needs to mention those directories
        # in the <source> elements.
        # https://bitbucket.org/ned/coveragepy/issues/439/incorrect-cobertura-file-sources-generated
        self.make_file("src/main/foo.py", "a = 1")
        self.make_file("also/over/there/bar.py", "b = 2")
        cov = coverage.Coverage(source=["src/main", "also/over/there", "not/really"])
        cov.start()
        mod_foo = import_local_file("foo", "src/main/foo.py")                   # pragma: nested
        mod_bar = import_local_file("bar", "also/over/there/bar.py")            # pragma: nested
        cov.stop()                                                              # pragma: nested
        cov.xml_report([mod_foo, mod_bar])
        dom = ElementTree.parse("coverage.xml")

        self.assert_source(dom, "src/main")
        self.assert_source(dom, "also/over/there")
        sources = dom.findall(".//source")
        assert len(sources) == 2

        foo_class = dom.findall(".//class[@name='foo.py']")
        assert len(foo_class) == 1
        assert foo_class[0].attrib == {
            'branch-rate': '0',
            'complexity': '0',
            'filename': 'foo.py',
            'line-rate': '1',
            'name': 'foo.py',
        }

        bar_class = dom.findall(".//class[@name='bar.py']")
        assert len(bar_class) == 1
        assert bar_class[0].attrib == {
            'branch-rate': '0',
            'complexity': '0',
            'filename': 'bar.py',
            'line-rate': '1',
            'name': 'bar.py',
        }

    def test_nonascii_directory(self):
        # https://bitbucket.org/ned/coveragepy/issues/573/cant-generate-xml-report-if-some-source
        self.make_file("테스트/program.py", "a = 1")
        with change_dir("테스트"):
            cov = coverage.Coverage()
            self.start_import_stop(cov, "program")
            cov.xml_report()


def unbackslash(v):
    """Find strings in `v`, and replace backslashes with slashes throughout."""
    if isinstance(v, (tuple, list)):
        return [unbackslash(vv) for vv in v]
    elif isinstance(v, dict):
        return {k: unbackslash(vv) for k, vv in v.items()}
    else:
        assert isinstance(v, str)
        return v.replace("\\", "/")


class XmlPackageStructureTest(XmlTestHelpers, CoverageTest):
    """Tests about the package structure reported in the coverage.xml file."""

    def package_and_class_tags(self, cov):
        """Run an XML report on `cov`, and get the package and class tags."""
        cov.xml_report()
        dom = ElementTree.parse("coverage.xml")
        for node in dom.iter():
            if node.tag in ('package', 'class'):
                yield (node.tag, {a:v for a,v in node.items() if a in ('name', 'filename')})

    def assert_package_and_class_tags(self, cov, result):
        """Check the XML package and class tags from `cov` match `result`."""
        self.assertEqual(
            unbackslash(list(self.package_and_class_tags(cov))),
            unbackslash(result),
            )

    def test_package_names(self):
        self.make_tree(width=1, depth=3)
        self.make_file("main.py", """\
            from d0.d0 import f0
            """)
        cov = coverage.Coverage(source=".")
        self.start_import_stop(cov, "main")
        self.assert_package_and_class_tags(cov, [
            ('package', {'name': "."}),
            ('class', {'filename': "main.py", 'name': "main.py"}),
            ('package', {'name': "d0"}),
            ('class', {'filename': "d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/f0.py", 'name': "f0.py"}),
            ('package', {'name': "d0.d0"}),
            ('class', {'filename': "d0/d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/d0/f0.py", 'name': "f0.py"}),
            ])

    def test_package_depth_1(self):
        self.make_tree(width=1, depth=4)
        self.make_file("main.py", """\
            from d0.d0 import f0
            """)
        cov = coverage.Coverage(source=".")
        self.start_import_stop(cov, "main")

        cov.set_option("xml:package_depth", 1)
        self.assert_package_and_class_tags(cov, [
            ('package', {'name': "."}),
            ('class', {'filename': "main.py", 'name': "main.py"}),
            ('package', {'name': "d0"}),
            ('class', {'filename': "d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/d0/__init__.py", 'name': "d0/__init__.py"}),
            ('class', {'filename': "d0/d0/d0/__init__.py", 'name': "d0/d0/__init__.py"}),
            ('class', {'filename': "d0/d0/d0/f0.py", 'name': "d0/d0/f0.py"}),
            ('class', {'filename': "d0/d0/f0.py", 'name': "d0/f0.py"}),
            ('class', {'filename': "d0/f0.py", 'name': "f0.py"}),
            ])

    def test_package_depth_2(self):
        self.make_tree(width=1, depth=4)
        self.make_file("main.py", """\
            from d0.d0 import f0
            """)
        cov = coverage.Coverage(source=".")
        self.start_import_stop(cov, "main")

        cov.set_option("xml:package_depth", 2)
        self.assert_package_and_class_tags(cov, [
            ('package', {'name': "."}),
            ('class', {'filename': "main.py", 'name': "main.py"}),
            ('package', {'name': "d0"}),
            ('class', {'filename': "d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/f0.py", 'name': "f0.py"}),
            ('package', {'name': "d0.d0"}),
            ('class', {'filename': "d0/d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/d0/d0/__init__.py", 'name': "d0/__init__.py"}),
            ('class', {'filename': "d0/d0/d0/f0.py", 'name': "d0/f0.py"}),
            ('class', {'filename': "d0/d0/f0.py", 'name': "f0.py"}),
            ])

    def test_package_depth_3(self):
        self.make_tree(width=1, depth=4)
        self.make_file("main.py", """\
            from d0.d0 import f0
            """)
        cov = coverage.Coverage(source=".")
        self.start_import_stop(cov, "main")

        cov.set_option("xml:package_depth", 3)
        self.assert_package_and_class_tags(cov, [
            ('package', {'name': "."}),
            ('class', {'filename': "main.py", 'name': "main.py"}),
            ('package', {'name': "d0"}),
            ('class', {'filename': "d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/f0.py", 'name': "f0.py"}),
            ('package', {'name': "d0.d0"}),
            ('class', {'filename': "d0/d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/d0/f0.py", 'name': "f0.py"}),
            ('package', {'name': "d0.d0.d0"}),
            ('class', {'filename': "d0/d0/d0/__init__.py", 'name': "__init__.py"}),
            ('class', {'filename': "d0/d0/d0/f0.py", 'name': "f0.py"}),
            ])

    def test_source_prefix(self):
        # https://bitbucket.org/ned/coveragepy/issues/465
        # https://bitbucket.org/ned/coveragepy/issues/526/generated-xml-invalid-paths-for-cobertura
        self.make_file("src/mod.py", "print(17)")
        cov = coverage.Coverage(source=["src"])
        self.start_import_stop(cov, "mod", modfile="src/mod.py")

        self.assert_package_and_class_tags(cov, [
            ('package', {'name': "."}),
            ('class', {'filename': "mod.py", 'name': "mod.py"}),
            ])
        dom = ElementTree.parse("coverage.xml")
        self.assert_source(dom, "src")

    def test_relative_source(self):
        self.make_file("src/mod.py", "print(17)")
        cov = coverage.Coverage(source=["src"])
        cov.set_option("run:relative_files", True)
        self.start_import_stop(cov, "mod", modfile="src/mod.py")
        cov.xml_report()

        with open("coverage.xml") as x:
            print(x.read())
        dom = ElementTree.parse("coverage.xml")
        elts = dom.findall(".//sources/source")
        assert [elt.text for elt in elts] == ["src"]


def compare_xml(expected, actual, **kwargs):
    """Specialized compare function for our XML files."""
    source_path = coverage.files.relative_directory().rstrip(r"\/")

    scrubs=[
        (r' timestamp="\d+"', ' timestamp="TIMESTAMP"'),
        (r' version="[-.\w]+"', ' version="VERSION"'),
        (r'<source>\s*.*?\s*</source>', '<source>%s</source>' % re.escape(source_path)),
        (r'/coverage.readthedocs.io/?[-.\w/]*', '/coverage.readthedocs.io/VER'),
    ]
    compare(expected, actual, scrubs=scrubs, **kwargs)


class XmlGoldTest(CoverageTest):
    """Tests of XML reporting that use gold files."""

    def test_a_xml_1(self):
        self.make_file("a.py", """\
            if 1 < 2:
                # Needed a < to look at HTML entities.
                a = 3
            else:
                a = 4
            """)

        cov = coverage.Coverage()
        a = self.start_import_stop(cov, "a")
        cov.xml_report(a, outfile="coverage.xml")
        compare_xml(gold_path("xml/x_xml"), ".", actual_extra=True)

    def test_a_xml_2(self):
        self.make_file("a.py", """\
            if 1 < 2:
                # Needed a < to look at HTML entities.
                a = 3
            else:
                a = 4
            """)

        self.make_file("run_a_xml_2.ini", """\
            # Put all the XML output in xml_2
            [xml]
            output = xml_2/coverage.xml
            """)

        cov = coverage.Coverage(config_file="run_a_xml_2.ini")
        a = self.start_import_stop(cov, "a")
        cov.xml_report(a)
        compare_xml(gold_path("xml/x_xml"), "xml_2")

    def test_y_xml_branch(self):
        self.make_file("y.py", """\
            def choice(x):
                if x < 2:
                    return 3
                else:
                    return 4

            assert choice(1) == 3
            """)

        cov = coverage.Coverage(branch=True)
        y = self.start_import_stop(cov, "y")
        cov.xml_report(y, outfile="y_xml_branch/coverage.xml")
        compare_xml(gold_path("xml/y_xml_branch"), "y_xml_branch")
