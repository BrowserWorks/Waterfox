# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for plugins."""

import inspect
import os.path
from xml.etree import ElementTree

import coverage
from coverage import env
from coverage.backward import StringIO, import_local_file
from coverage.data import line_counts
from coverage.control import Plugins
from coverage.misc import CoverageException

import coverage.plugin

from tests.coveragetest import CoverageTest
from tests.helpers import CheckUniqueFilenames


class FakeConfig(object):
    """A fake config for use in tests."""

    def __init__(self, plugin, options):
        self.plugin = plugin
        self.options = options
        self.asked_for = []

    def get_plugin_options(self, module):
        """Just return the options for `module` if this is the right module."""
        self.asked_for.append(module)
        if module == self.plugin:
            return self.options
        else:
            return {}


class LoadPluginsTest(CoverageTest):
    """Test Plugins.load_plugins directly."""

    def test_implicit_boolean(self):
        self.make_file("plugin1.py", """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                pass

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)

        config = FakeConfig("plugin1", {})
        plugins = Plugins.load_plugins([], config)
        self.assertFalse(plugins)

        plugins = Plugins.load_plugins(["plugin1"], config)
        self.assertTrue(plugins)

    def test_importing_and_configuring(self):
        self.make_file("plugin1.py", """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                def __init__(self, options):
                    self.options = options
                    self.this_is = "me"

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin(options))
            """)

        config = FakeConfig("plugin1", {'a': 'hello'})
        plugins = list(Plugins.load_plugins(["plugin1"], config))

        self.assertEqual(len(plugins), 1)
        self.assertEqual(plugins[0].this_is, "me")
        self.assertEqual(plugins[0].options, {'a': 'hello'})
        self.assertEqual(config.asked_for, ['plugin1'])

    def test_importing_and_configuring_more_than_one(self):
        self.make_file("plugin1.py", """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                def __init__(self, options):
                    self.options = options
                    self.this_is = "me"

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin(options))
            """)
        self.make_file("plugin2.py", """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                def __init__(self, options):
                    self.options = options

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin(options))
            """)

        config = FakeConfig("plugin1", {'a': 'hello'})
        plugins = list(Plugins.load_plugins(["plugin1", "plugin2"], config))

        self.assertEqual(len(plugins), 2)
        self.assertEqual(plugins[0].this_is, "me")
        self.assertEqual(plugins[0].options, {'a': 'hello'})
        self.assertEqual(plugins[1].options, {})
        self.assertEqual(config.asked_for, ['plugin1', 'plugin2'])

        # The order matters...
        config = FakeConfig("plugin1", {'a': 'second'})
        plugins = list(Plugins.load_plugins(["plugin2", "plugin1"], config))

        self.assertEqual(len(plugins), 2)
        self.assertEqual(plugins[0].options, {})
        self.assertEqual(plugins[1].this_is, "me")
        self.assertEqual(plugins[1].options, {'a': 'second'})

    def test_cant_import(self):
        with self.assertRaisesRegex(ImportError, "No module named '?plugin_not_there'?"):
            _ = Plugins.load_plugins(["plugin_not_there"], None)

    def test_plugin_must_define_coverage_init(self):
        self.make_file("no_plugin.py", """\
            from coverage import CoveragePlugin
            Nothing = 0
            """)
        msg_pat = "Plugin module 'no_plugin' didn't define a coverage_init function"
        with self.assertRaisesRegex(CoverageException, msg_pat):
            list(Plugins.load_plugins(["no_plugin"], None))


class PluginTest(CoverageTest):
    """Test plugins through the Coverage class."""

    def test_plugin_imported(self):
        # Prove that a plugin will be imported.
        self.make_file("my_plugin.py", """\
            from coverage import CoveragePlugin
            class Plugin(CoveragePlugin):
                pass
            def coverage_init(reg, options):
                reg.add_noop(Plugin())
            with open("evidence.out", "w") as f:
                f.write("we are here!")
            """)

        self.assert_doesnt_exist("evidence.out")
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ["my_plugin"])
        cov.start()
        cov.stop()      # pragma: nested

        with open("evidence.out") as f:
            self.assertEqual(f.read(), "we are here!")

    def test_missing_plugin_raises_import_error(self):
        # Prove that a missing plugin will raise an ImportError.
        with self.assertRaisesRegex(ImportError, "No module named '?does_not_exist_woijwoicweo'?"):
            cov = coverage.Coverage()
            cov.set_option("run:plugins", ["does_not_exist_woijwoicweo"])
            cov.start()
        cov.stop()

    def test_bad_plugin_isnt_hidden(self):
        # Prove that a plugin with an error in it will raise the error.
        self.make_file("plugin_over_zero.py", "1/0")
        with self.assertRaises(ZeroDivisionError):
            cov = coverage.Coverage()
            cov.set_option("run:plugins", ["plugin_over_zero"])
            cov.start()
        cov.stop()

    def test_plugin_sys_info(self):
        self.make_file("plugin_sys_info.py", """\
            import coverage

            class Plugin(coverage.CoveragePlugin):
                def sys_info(self):
                    return [("hello", "world")]

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        debug_out = StringIO()
        cov = coverage.Coverage(debug=["sys"])
        cov._debug_file = debug_out
        cov.set_option("run:plugins", ["plugin_sys_info"])
        cov.start()
        cov.stop()      # pragma: nested

        out_lines = [line.strip() for line in debug_out.getvalue().splitlines()]
        if env.C_TRACER:
            self.assertIn('plugins.file_tracers: plugin_sys_info.Plugin', out_lines)
        else:
            self.assertIn('plugins.file_tracers: plugin_sys_info.Plugin (disabled)', out_lines)
        self.assertIn('plugins.configurers: -none-', out_lines)
        expected_end = [
            "-- sys: plugin_sys_info.Plugin -------------------------------",
            "hello: world",
            "-- end -------------------------------------------------------",
            ]
        self.assertEqual(expected_end, out_lines[-len(expected_end):])

    def test_plugin_with_no_sys_info(self):
        self.make_file("plugin_no_sys_info.py", """\
            import coverage

            class Plugin(coverage.CoveragePlugin):
                pass

            def coverage_init(reg, options):
                reg.add_configurer(Plugin())
            """)
        debug_out = StringIO()
        cov = coverage.Coverage(debug=["sys"])
        cov._debug_file = debug_out
        cov.set_option("run:plugins", ["plugin_no_sys_info"])
        cov.start()
        cov.stop()      # pragma: nested

        out_lines = [line.strip() for line in debug_out.getvalue().splitlines()]
        self.assertIn('plugins.file_tracers: -none-', out_lines)
        self.assertIn('plugins.configurers: plugin_no_sys_info.Plugin', out_lines)
        expected_end = [
            "-- sys: plugin_no_sys_info.Plugin ----------------------------",
            "-- end -------------------------------------------------------",
            ]
        self.assertEqual(expected_end, out_lines[-len(expected_end):])

    def test_local_files_are_importable(self):
        self.make_file("importing_plugin.py", """\
            from coverage import CoveragePlugin
            import local_module
            class MyPlugin(CoveragePlugin):
                pass
            def coverage_init(reg, options):
                reg.add_noop(MyPlugin())
            """)
        self.make_file("local_module.py", "CONST = 1")
        self.make_file(".coveragerc", """\
            [run]
            plugins = importing_plugin
            """)
        self.make_file("main_file.py", "print('MAIN')")

        out = self.run_command("coverage run main_file.py")
        self.assertEqual(out, "MAIN\n")
        out = self.run_command("coverage html")
        self.assertEqual(out, "")


class PluginWarningOnPyTracer(CoverageTest):
    """Test that we get a controlled exception with plugins on PyTracer."""
    def test_exception_if_plugins_on_pytracer(self):
        if env.C_TRACER:
            self.skipTest("This test is only about PyTracer.")

        self.make_file("simple.py", "a = 1")

        cov = coverage.Coverage()
        cov.set_option("run:plugins", ["tests.plugin1"])

        expected_warnings = [
            r"Plugin file tracers \(tests.plugin1.Plugin\) aren't supported with PyTracer",
        ]
        with self.assert_warnings(cov, expected_warnings):
            self.start_import_stop(cov, "simple")


class FileTracerTest(CoverageTest):
    """Tests of plugins that implement file_tracer."""

    def setUp(self):
        if not env.C_TRACER:
            self.skipTest("Plugins are only supported with the C tracer.")
        super(FileTracerTest, self).setUp()


class GoodFileTracerTest(FileTracerTest):
    """Tests of file tracer plugin happy paths."""

    def test_plugin1(self):
        self.make_file("simple.py", """\
            import try_xyz
            a = 1
            b = 2
            """)
        self.make_file("try_xyz.py", """\
            c = 3
            d = 4
            """)

        cov = coverage.Coverage()
        CheckUniqueFilenames.hook(cov, '_should_trace')
        CheckUniqueFilenames.hook(cov, '_check_include_omit_etc')
        cov.set_option("run:plugins", ["tests.plugin1"])

        # Import the Python file, executing it.
        self.start_import_stop(cov, "simple")

        _, statements, missing, _ = cov.analysis("simple.py")
        self.assertEqual(statements, [1, 2, 3])
        self.assertEqual(missing, [])
        zzfile = os.path.abspath(os.path.join("/src", "try_ABC.zz"))
        _, statements, _, _ = cov.analysis(zzfile)
        self.assertEqual(statements, [105, 106, 107, 205, 206, 207])

    def make_render_and_caller(self):
        """Make the render.py and caller.py files we need."""
        # plugin2 emulates a dynamic tracing plugin: the caller's locals
        # are examined to determine the source file and line number.
        # The plugin is in tests/plugin2.py.
        self.make_file("render.py", """\
            def render(filename, linenum):
                # This function emulates a template renderer. The plugin
                # will examine the `filename` and `linenum` locals to
                # determine the source file and line number.
                fiddle_around = 1   # not used, just chaff.
                return "[{} @ {}]".format(filename, linenum)

            def helper(x):
                # This function is here just to show that not all code in
                # this file will be part of the dynamic tracing.
                return x+1
            """)
        self.make_file("caller.py", """\
            import sys
            from render import helper, render

            assert render("foo_7.html", 4) == "[foo_7.html @ 4]"
            # Render foo_7.html again to try the CheckUniqueFilenames asserts.
            render("foo_7.html", 4)

            assert helper(42) == 43
            assert render("bar_4.html", 2) == "[bar_4.html @ 2]"
            assert helper(76) == 77

            # quux_5.html will be omitted from the results.
            assert render("quux_5.html", 3) == "[quux_5.html @ 3]"

            # For Python 2, make sure unicode is working.
            assert render(u"uni_3.html", 2) == "[uni_3.html @ 2]"
            """)

        # will try to read the actual source files, so make some
        # source files.
        def lines(n):
            """Make a string with n lines of text."""
            return "".join("line %d\n" % i for i in range(n))

        self.make_file("bar_4.html", lines(4))
        self.make_file("foo_7.html", lines(7))

    def test_plugin2(self):
        self.make_render_and_caller()

        cov = coverage.Coverage(omit=["*quux*"])
        CheckUniqueFilenames.hook(cov, '_should_trace')
        CheckUniqueFilenames.hook(cov, '_check_include_omit_etc')
        cov.set_option("run:plugins", ["tests.plugin2"])

        self.start_import_stop(cov, "caller")

        # The way plugin2 works, a file named foo_7.html will be claimed to
        # have 7 lines in it.  If render() was called with line number 4,
        # then the plugin will claim that lines 4 and 5 were executed.
        _, statements, missing, _ = cov.analysis("foo_7.html")
        self.assertEqual(statements, [1, 2, 3, 4, 5, 6, 7])
        self.assertEqual(missing, [1, 2, 3, 6, 7])
        self.assertIn("foo_7.html", line_counts(cov.get_data()))

        _, statements, missing, _ = cov.analysis("bar_4.html")
        self.assertEqual(statements, [1, 2, 3, 4])
        self.assertEqual(missing, [1, 4])
        self.assertIn("bar_4.html", line_counts(cov.get_data()))

        self.assertNotIn("quux_5.html", line_counts(cov.get_data()))

        _, statements, missing, _ = cov.analysis("uni_3.html")
        self.assertEqual(statements, [1, 2, 3])
        self.assertEqual(missing, [1])
        self.assertIn("uni_3.html", line_counts(cov.get_data()))

    def test_plugin2_with_branch(self):
        self.make_render_and_caller()

        cov = coverage.Coverage(branch=True, omit=["*quux*"])
        CheckUniqueFilenames.hook(cov, '_should_trace')
        CheckUniqueFilenames.hook(cov, '_check_include_omit_etc')
        cov.set_option("run:plugins", ["tests.plugin2"])

        self.start_import_stop(cov, "caller")

        # The way plugin2 works, a file named foo_7.html will be claimed to
        # have 7 lines in it.  If render() was called with line number 4,
        # then the plugin will claim that lines 4 and 5 were executed.
        analysis = cov._analyze("foo_7.html")
        self.assertEqual(analysis.statements, set([1, 2, 3, 4, 5, 6, 7]))
        # Plugins don't do branch coverage yet.
        self.assertEqual(analysis.has_arcs(), True)
        self.assertEqual(analysis.arc_possibilities(), [])

        self.assertEqual(analysis.missing, set([1, 2, 3, 6, 7]))

    def test_plugin2_with_text_report(self):
        self.make_render_and_caller()

        cov = coverage.Coverage(branch=True, omit=["*quux*"])
        cov.set_option("run:plugins", ["tests.plugin2"])

        self.start_import_stop(cov, "caller")

        repout = StringIO()
        total = cov.report(file=repout, include=["*.html"], omit=["uni*.html"], show_missing=True)
        report = repout.getvalue().splitlines()
        expected = [
            'Name         Stmts   Miss Branch BrPart  Cover   Missing',
            '--------------------------------------------------------',
            'bar_4.html       4      2      0      0    50%   1, 4',
            'foo_7.html       7      5      0      0    29%   1-3, 6-7',
            '--------------------------------------------------------',
            'TOTAL           11      7      0      0    36%',
            ]
        self.assertEqual(expected, report)
        self.assertAlmostEqual(total, 36.36, places=2)

    def test_plugin2_with_html_report(self):
        self.make_render_and_caller()

        cov = coverage.Coverage(branch=True, omit=["*quux*"])
        cov.set_option("run:plugins", ["tests.plugin2"])

        self.start_import_stop(cov, "caller")

        total = cov.html_report(include=["*.html"], omit=["uni*.html"])
        self.assertAlmostEqual(total, 36.36, places=2)

        self.assert_exists("htmlcov/index.html")
        self.assert_exists("htmlcov/bar_4_html.html")
        self.assert_exists("htmlcov/foo_7_html.html")

    def test_plugin2_with_xml_report(self):
        self.make_render_and_caller()

        cov = coverage.Coverage(branch=True, omit=["*quux*"])
        cov.set_option("run:plugins", ["tests.plugin2"])

        self.start_import_stop(cov, "caller")

        total = cov.xml_report(include=["*.html"], omit=["uni*.html"])
        self.assertAlmostEqual(total, 36.36, places=2)

        dom = ElementTree.parse("coverage.xml")
        classes = {}
        for elt in dom.findall(".//class"):
            classes[elt.get('name')] = elt

        assert classes['bar_4.html'].attrib == {
            'branch-rate': '1',
            'complexity': '0',
            'filename': 'bar_4.html',
            'line-rate': '0.5',
            'name': 'bar_4.html',
        }
        assert classes['foo_7.html'].attrib == {
            'branch-rate': '1',
            'complexity': '0',
            'filename': 'foo_7.html',
            'line-rate': '0.2857',
            'name': 'foo_7.html',
        }

    def test_defer_to_python(self):
        # A plugin that measures, but then wants built-in python reporting.
        self.make_file("fairly_odd_plugin.py", """\
            # A plugin that claims all the odd lines are executed, and none of
            # the even lines, and then punts reporting off to the built-in
            # Python reporting.
            import coverage.plugin
            class Plugin(coverage.CoveragePlugin):
                def file_tracer(self, filename):
                    return OddTracer(filename)
                def file_reporter(self, filename):
                    return "python"

            class OddTracer(coverage.plugin.FileTracer):
                def __init__(self, filename):
                    self.filename = filename
                def source_filename(self):
                    return self.filename
                def line_number_range(self, frame):
                    lineno = frame.f_lineno
                    if lineno % 2:
                        return (lineno, lineno)
                    else:
                        return (-1, -1)

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.make_file("unsuspecting.py", """\
            a = 1
            b = 2
            c = 3
            d = 4
            e = 5
            f = 6
            """)
        cov = coverage.Coverage(include=["unsuspecting.py"])
        cov.set_option("run:plugins", ["fairly_odd_plugin"])
        self.start_import_stop(cov, "unsuspecting")

        repout = StringIO()
        total = cov.report(file=repout, show_missing=True)
        report = repout.getvalue().splitlines()
        expected = [
            'Name              Stmts   Miss  Cover   Missing',
            '-----------------------------------------------',
            'unsuspecting.py       6      3    50%   2, 4, 6',
            ]
        self.assertEqual(expected, report)
        self.assertEqual(total, 50)

    def test_find_unexecuted(self):
        self.make_file("unexecuted_plugin.py", """\
            import os
            import coverage.plugin
            class Plugin(coverage.CoveragePlugin):
                def file_tracer(self, filename):
                    if filename.endswith("foo.py"):
                        return MyTracer(filename)
                def file_reporter(self, filename):
                    return MyReporter(filename)
                def find_executable_files(self, src_dir):
                    # Check that src_dir is the right value
                    files = os.listdir(src_dir)
                    assert "foo.py" in files
                    assert "unexecuted_plugin.py" in files
                    return ["chimera.py"]

            class MyTracer(coverage.plugin.FileTracer):
                def __init__(self, filename):
                    self.filename = filename
                def source_filename(self):
                    return self.filename
                def line_number_range(self, frame):
                    return (999, 999)

            class MyReporter(coverage.FileReporter):
                def lines(self):
                    return set([99, 999, 9999])

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
        """)
        self.make_file("foo.py", "a = 1")
        cov = coverage.Coverage(source=['.'])
        cov.set_option("run:plugins", ["unexecuted_plugin"])
        self.start_import_stop(cov, "foo")

        # The file we executed claims to have run line 999.
        _, statements, missing, _ = cov.analysis("foo.py")
        self.assertEqual(statements, [99, 999, 9999])
        self.assertEqual(missing, [99, 9999])

        # The completely missing file is in the results.
        _, statements, missing, _ = cov.analysis("chimera.py")
        self.assertEqual(statements, [99, 999, 9999])
        self.assertEqual(missing, [99, 999, 9999])

        # But completely new filenames are not in the results.
        self.assertEqual(len(cov.get_data().measured_files()), 3)
        with self.assertRaises(CoverageException):
            cov.analysis("fictional.py")


class BadFileTracerTest(FileTracerTest):
    """Test error handling around file tracer plugins."""

    def run_plugin(self, module_name):
        """Run a plugin with the given module_name.

        Uses a few fixed Python files.

        Returns the Coverage object.

        """
        self.make_file("simple.py", """\
            import other, another
            a = other.f(2)
            b = other.f(3)
            c = another.g(4)
            d = another.g(5)
            """)
        # The names of these files are important: some plugins apply themselves
        # to "*other.py".
        self.make_file("other.py", """\
            def f(x):
                return x+1
            """)
        self.make_file("another.py", """\
            def g(x):
                return x-1
            """)

        cov = coverage.Coverage()
        cov.set_option("run:plugins", [module_name])
        self.start_import_stop(cov, "simple")
        return cov

    def run_bad_plugin(self, module_name, plugin_name, our_error=True, excmsg=None, excmsgs=None):
        """Run a file, and see that the plugin failed.

        `module_name` and `plugin_name` is the module and name of the plugin to
        use.

        `our_error` is True if the error reported to the user will be an
        explicit error in our test code, marked with an '# Oh noes!' comment.

        `excmsg`, if provided, is text that must appear in the stderr.

        `excmsgs`, if provided, is a list of messages, one of which must
        appear in the stderr.

        The plugin will be disabled, and we check that a warning is output
        explaining why.

        """
        self.run_plugin(module_name)

        stderr = self.stderr()

        if our_error:
            errors = stderr.count("# Oh noes!")
            # The exception we're causing should only appear once.
            self.assertEqual(errors, 1)

        # There should be a warning explaining what's happening, but only one.
        # The message can be in two forms:
        #   Disabling plug-in '...' due to previous exception
        # or:
        #   Disabling plug-in '...' due to an exception:
        msg = "Disabling plug-in '%s.%s' due to " % (module_name, plugin_name)
        warnings = stderr.count(msg)
        self.assertEqual(warnings, 1)

        if excmsg:
            self.assertIn(excmsg, stderr)
        if excmsgs:
            self.assertTrue(any(em in stderr for em in excmsgs), "expected one of %r" % excmsgs)

    def test_file_tracer_has_no_file_tracer_method(self):
        self.make_file("bad_plugin.py", """\
            class Plugin(object):
                pass

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin("bad_plugin", "Plugin", our_error=False)

    def test_file_tracer_has_inherited_sourcefilename_method(self):
        self.make_file("bad_plugin.py", """\
            import coverage
            class Plugin(coverage.CoveragePlugin):
                def file_tracer(self, filename):
                    # Just grab everything.
                    return FileTracer()

            class FileTracer(coverage.FileTracer):
                pass

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False,
            excmsg="Class 'bad_plugin.FileTracer' needs to implement source_filename()",
        )

    def test_plugin_has_inherited_filereporter_method(self):
        self.make_file("bad_plugin.py", """\
            import coverage
            class Plugin(coverage.CoveragePlugin):
                def file_tracer(self, filename):
                    # Just grab everything.
                    return FileTracer()

            class FileTracer(coverage.FileTracer):
                def source_filename(self):
                    return "foo.xxx"

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        cov = self.run_plugin("bad_plugin")
        expected_msg = "Plugin 'bad_plugin.Plugin' needs to implement file_reporter()"
        with self.assertRaisesRegex(NotImplementedError, expected_msg):
            cov.report()

    def test_file_tracer_fails(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    17/0 # Oh noes!

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin("bad_plugin", "Plugin")

    def test_file_tracer_returns_wrong(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    return 3.14159

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False, excmsg="'float' object has no attribute",
        )

    def test_has_dynamic_source_filename_fails(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def has_dynamic_source_filename(self):
                    23/0 # Oh noes!

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin("bad_plugin", "Plugin")

    def test_source_filename_fails(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def source_filename(self):
                    42/0 # Oh noes!

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin("bad_plugin", "Plugin")

    def test_source_filename_returns_wrong(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def source_filename(self):
                    return 17.3

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False,
            excmsgs=[
                "expected str, bytes or os.PathLike object, not float",
                "'float' object has no attribute",
                "object of type 'float' has no len()",
                "'float' object is unsubscriptable",
            ],
        )

    def test_dynamic_source_filename_fails(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    if filename.endswith("other.py"):
                        return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def has_dynamic_source_filename(self):
                    return True
                def dynamic_source_filename(self, filename, frame):
                    101/0 # Oh noes!

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin("bad_plugin", "Plugin")

    def test_line_number_range_returns_non_tuple(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    if filename.endswith("other.py"):
                        return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def source_filename(self):
                    return "something.foo"

                def line_number_range(self, frame):
                    return 42.23

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False, excmsg="line_number_range must return 2-tuple",
        )

    def test_line_number_range_returns_triple(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    if filename.endswith("other.py"):
                        return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def source_filename(self):
                    return "something.foo"

                def line_number_range(self, frame):
                    return (1, 2, 3)

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False, excmsg="line_number_range must return 2-tuple",
        )

    def test_line_number_range_returns_pair_of_strings(self):
        self.make_file("bad_plugin.py", """\
            import coverage.plugin
            class Plugin(coverage.plugin.CoveragePlugin):
                def file_tracer(self, filename):
                    if filename.endswith("other.py"):
                        return BadFileTracer()

            class BadFileTracer(coverage.plugin.FileTracer):
                def source_filename(self):
                    return "something.foo"

                def line_number_range(self, frame):
                    return ("5", "7")

            def coverage_init(reg, options):
                reg.add_file_tracer(Plugin())
            """)
        self.run_bad_plugin(
            "bad_plugin", "Plugin", our_error=False, excmsg="an integer is required",
        )


class ConfigurerPluginTest(CoverageTest):
    """Test configuring plugins."""

    run_in_temp_dir = False

    def test_configurer_plugin(self):
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ["tests.plugin_config"])
        cov.start()
        cov.stop()      # pragma: nested
        excluded = cov.get_option("report:exclude_lines")
        self.assertIn("pragma: custom", excluded)
        self.assertIn("pragma: or whatever", excluded)


class DynamicContextPluginTest(CoverageTest):
    """Tests of plugins that implement `dynamic_context`."""

    def make_plugin_capitalized_testnames(self, filename):
        """Create a dynamic context plugin that capitalizes the part after 'test_'."""
        self.make_file(filename, """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                def dynamic_context(self, frame):
                    name = frame.f_code.co_name
                    if name.startswith(("test_", "doctest_")):
                        parts = name.split("_", 1)
                        return "%s:%s" % (parts[0], parts[1].upper())
                    return None

            def coverage_init(reg, options):
                reg.add_dynamic_context(Plugin())
            """)

    def make_plugin_track_render(self, filename):
        """Make a dynamic context plugin that tracks 'render_' functions."""
        self.make_file(filename, """\
            from coverage import CoveragePlugin

            class Plugin(CoveragePlugin):
                def dynamic_context(self, frame):
                    name = frame.f_code.co_name
                    if name.startswith("render_"):
                        return 'renderer:' + name[7:]
                    return None

            def coverage_init(reg, options):
                reg.add_dynamic_context(Plugin())
            """)

    def make_test_files(self):
        """Make some files to use while testing dynamic context plugins."""
        self.make_file("rendering.py", """\
            def html_tag(tag, content):
                return '<%s>%s</%s>' % (tag, content, tag)

            def render_paragraph(text):
                return html_tag('p', text)

            def render_span(text):
                return html_tag('span', text)

            def render_bold(text):
                return html_tag('b', text)
            """)

        self.make_file("testsuite.py", """\
            import rendering

            def test_html_tag():
                assert rendering.html_tag('b', 'hello') == '<b>hello</b>'

            def doctest_html_tag():
                assert eval('''
                    rendering.html_tag('i', 'text') == '<i>text</i>'
                    '''.strip())

            def test_renderers():
                assert rendering.render_paragraph('hello') == '<p>hello</p>'
                assert rendering.render_bold('wide') == '<b>wide</b>'
                assert rendering.render_span('world') == '<span>world</span>'

            def build_full_html():
                html = '<html><body>%s</body></html>' % (
                   rendering.render_paragraph(
                      rendering.render_span('hello')))
                return html
            """)

    def run_all_functions(self, cov, suite_name):           # pragma: nested
        """Run all functions in `suite_name` under coverage."""
        cov.start()
        suite = import_local_file(suite_name)
        try:
            # Call all functions in this module
            for name in dir(suite):
                variable = getattr(suite, name)
                if inspect.isfunction(variable):
                    variable()
        finally:
            cov.stop()

    def test_plugin_standalone(self):
        self.make_plugin_capitalized_testnames('plugin_tests.py')
        self.make_test_files()

        # Enable dynamic context plugin
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ['plugin_tests'])

        # Run the tests
        self.run_all_functions(cov, 'testsuite')

        # Labeled coverage is collected
        data = cov.get_data()
        filenames = self.get_measured_filenames(data)
        self.assertEqual(
            ['', 'doctest:HTML_TAG', 'test:HTML_TAG', 'test:RENDERERS'],
            sorted(data.measured_contexts()),
        )
        data.set_query_context("doctest:HTML_TAG")
        self.assertEqual([2], data.lines(filenames['rendering.py']))
        data.set_query_context("test:HTML_TAG")
        self.assertEqual([2], data.lines(filenames['rendering.py']))
        data.set_query_context("test:RENDERERS")
        self.assertEqual([2, 5, 8, 11], sorted(data.lines(filenames['rendering.py'])))

    def test_static_context(self):
        self.make_plugin_capitalized_testnames('plugin_tests.py')
        self.make_test_files()

        # Enable dynamic context plugin for coverage with named context
        cov = coverage.Coverage(context='mytests')
        cov.set_option("run:plugins", ['plugin_tests'])

        # Run the tests
        self.run_all_functions(cov, 'testsuite')

        # Static context prefix is preserved
        data = cov.get_data()
        expected = [
            'mytests',
            'mytests|doctest:HTML_TAG',
            'mytests|test:HTML_TAG',
            'mytests|test:RENDERERS',
        ]
        self.assertEqual(expected, sorted(data.measured_contexts()))

    def test_plugin_with_test_function(self):
        self.make_plugin_capitalized_testnames('plugin_tests.py')
        self.make_test_files()

        # Enable both a plugin and test_function dynamic context
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ['plugin_tests'])
        cov.set_option("run:dynamic_context", "test_function")

        # Run the tests
        self.run_all_functions(cov, 'testsuite')

        # test_function takes precedence over plugins - only
        # functions that are not labeled by test_function are
        # labeled by plugin_tests.
        data = cov.get_data()
        filenames = self.get_measured_filenames(data)
        expected = [
            '',
            'doctest:HTML_TAG',
            'testsuite.test_html_tag',
            'testsuite.test_renderers',
        ]
        self.assertEqual(expected, sorted(data.measured_contexts()))

        def assert_context_lines(context, lines):
            data.set_query_context(context)
            self.assertEqual(lines, sorted(data.lines(filenames['rendering.py'])))

        assert_context_lines("doctest:HTML_TAG", [2])
        assert_context_lines("testsuite.test_html_tag", [2])
        assert_context_lines("testsuite.test_renderers", [2, 5, 8, 11])

    def test_multiple_plugins(self):
        self.make_plugin_capitalized_testnames('plugin_tests.py')
        self.make_plugin_track_render('plugin_renderers.py')
        self.make_test_files()

        # Enable two plugins
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ['plugin_renderers', 'plugin_tests'])

        self.run_all_functions(cov, 'testsuite')

        # It is important to note, that line 11 (render_bold function) is never
        # labeled as renderer:bold context, because it is only called from
        # test_renderers function - so it already falls under test:RENDERERS
        # context.
        #
        # render_paragraph and render_span (lines 5, 8) are directly called by
        # testsuite.build_full_html, so they get labeled by renderers plugin.
        data = cov.get_data()
        filenames = self.get_measured_filenames(data)
        expected = [
            '',
            'doctest:HTML_TAG',
            'renderer:paragraph',
            'renderer:span',
            'test:HTML_TAG',
            'test:RENDERERS',
        ]
        self.assertEqual(expected, sorted(data.measured_contexts()))

        def assert_context_lines(context, lines):
            data.set_query_context(context)
            self.assertEqual(lines, sorted(data.lines(filenames['rendering.py'])))

        assert_context_lines("test:HTML_TAG", [2])
        assert_context_lines("test:RENDERERS", [2, 5, 8, 11])
        assert_context_lines("doctest:HTML_TAG", [2])
        assert_context_lines("renderer:paragraph", [2, 5])
        assert_context_lines("renderer:span", [2, 8])
