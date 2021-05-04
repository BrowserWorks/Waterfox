# coding: utf-8
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Test the config file handling for coverage.py"""
from collections import OrderedDict

import mock

import coverage
from coverage.misc import CoverageException
import coverage.optional

from tests.coveragetest import CoverageTest, UsingModulesMixin


class ConfigTest(CoverageTest):
    """Tests of the different sources of configuration settings."""

    def test_default_config(self):
        # Just constructing a coverage() object gets the right defaults.
        cov = coverage.Coverage()
        self.assertFalse(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, ".coverage")

    def test_arguments(self):
        # Arguments to the constructor are applied to the configuration.
        cov = coverage.Coverage(timid=True, data_file="fooey.dat", concurrency="multiprocessing")
        self.assertTrue(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, "fooey.dat")
        self.assertEqual(cov.config.concurrency, ["multiprocessing"])

    def test_config_file(self):
        # A .coveragerc file will be read into the configuration.
        self.make_file(".coveragerc", """\
            # This is just a bogus .rc file for testing.
            [run]
            timid =         True
            data_file =     .hello_kitty.data
            """)
        cov = coverage.Coverage()
        self.assertTrue(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, ".hello_kitty.data")

    def test_named_config_file(self):
        # You can name the config file what you like.
        self.make_file("my_cov.ini", """\
            [run]
            timid = True
            ; I wouldn't really use this as a data file...
            data_file = delete.me
            """)
        cov = coverage.Coverage(config_file="my_cov.ini")
        self.assertTrue(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, "delete.me")

    def test_toml_config_file(self):
        # A .coveragerc file will be read into the configuration.
        self.make_file("pyproject.toml", """\
            # This is just a bogus toml file for testing.
            [tool.coverage.run]
            concurrency = ["a", "b"]
            timid = true
            data_file = ".hello_kitty.data"
            plugins = ["plugins.a_plugin"]
            [tool.coverage.report]
            precision = 3
            fail_under = 90.5
            [tool.coverage.plugins.a_plugin]
            hello = "world"
            """)
        cov = coverage.Coverage(config_file="pyproject.toml")
        self.assertTrue(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.concurrency, ["a", "b"])
        self.assertEqual(cov.config.data_file, ".hello_kitty.data")
        self.assertEqual(cov.config.plugins, ["plugins.a_plugin"])
        self.assertEqual(cov.config.precision, 3)
        self.assertAlmostEqual(cov.config.fail_under, 90.5)
        self.assertEqual(
            cov.config.get_plugin_options("plugins.a_plugin"),
            {'hello': 'world'}
        )

        # Test that our class doesn't reject integers when loading floats
        self.make_file("pyproject.toml", """\
            # This is just a bogus toml file for testing.
            [tool.coverage.report]
            fail_under = 90
            """)
        cov = coverage.Coverage(config_file="pyproject.toml")
        self.assertAlmostEqual(cov.config.fail_under, 90)
        self.assertIsInstance(cov.config.fail_under, float)

    def test_ignored_config_file(self):
        # You can disable reading the .coveragerc file.
        self.make_file(".coveragerc", """\
            [run]
            timid = True
            data_file = delete.me
            """)
        cov = coverage.Coverage(config_file=False)
        self.assertFalse(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, ".coverage")

    def test_config_file_then_args(self):
        # The arguments override the .coveragerc file.
        self.make_file(".coveragerc", """\
            [run]
            timid = True
            data_file = weirdo.file
            """)
        cov = coverage.Coverage(timid=False, data_file=".mycov")
        self.assertFalse(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, ".mycov")

    def test_data_file_from_environment(self):
        # There's an environment variable for the data_file.
        self.make_file(".coveragerc", """\
            [run]
            timid = True
            data_file = weirdo.file
            """)
        self.set_environ("COVERAGE_FILE", "fromenv.dat")
        cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "fromenv.dat")
        # But the constructor arguments override the environment variable.
        cov = coverage.Coverage(data_file="fromarg.dat")
        self.assertEqual(cov.config.data_file, "fromarg.dat")

    def test_debug_from_environment(self):
        self.make_file(".coveragerc", """\
            [run]
            debug = dataio, pids
            """)
        self.set_environ("COVERAGE_DEBUG", "callers, fooey")
        cov = coverage.Coverage()
        self.assertEqual(cov.config.debug, ["dataio", "pids", "callers", "fooey"])

    def test_rcfile_from_environment(self):
        self.make_file("here.ini", """\
            [run]
            data_file = overthere.dat
            """)
        self.set_environ("COVERAGE_RCFILE", "here.ini")
        cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "overthere.dat")

    def test_missing_rcfile_from_environment(self):
        self.set_environ("COVERAGE_RCFILE", "nowhere.ini")
        msg = "Couldn't read 'nowhere.ini' as a config file"
        with self.assertRaisesRegex(CoverageException, msg):
            coverage.Coverage()

    def test_parse_errors(self):
        # Im-parsable values raise CoverageException, with details.
        bad_configs_and_msgs = [
            ("[run]\ntimid = maybe?\n", r"maybe[?]"),
            ("timid = 1\n", r"no section headers"),
            ("[run\n", r"\[run"),
            ("[report]\nexclude_lines = foo(\n",
                r"Invalid \[report\].exclude_lines value 'foo\(': "
                r"(unbalanced parenthesis|missing \))"),
            ("[report]\npartial_branches = foo[\n",
                r"Invalid \[report\].partial_branches value 'foo\[': "
                r"(unexpected end of regular expression|unterminated character set)"),
            ("[report]\npartial_branches_always = foo***\n",
                r"Invalid \[report\].partial_branches_always value "
                r"'foo\*\*\*': "
                r"multiple repeat"),
        ]

        for bad_config, msg in bad_configs_and_msgs:
            print("Trying %r" % bad_config)
            self.make_file(".coveragerc", bad_config)
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage()

    def test_toml_parse_errors(self):
        # Im-parsable values raise CoverageException, with details.
        bad_configs_and_msgs = [
            ("[tool.coverage.run]\ntimid = \"maybe?\"\n", r"maybe[?]"),
            ("[tool.coverage.run\n", r"Key group"),
            ('[tool.coverage.report]\nexclude_lines = ["foo("]\n',
             r"Invalid \[tool.coverage.report\].exclude_lines value u?'foo\(': "
             r"(unbalanced parenthesis|missing \))"),
            ('[tool.coverage.report]\npartial_branches = ["foo["]\n',
             r"Invalid \[tool.coverage.report\].partial_branches value u?'foo\[': "
             r"(unexpected end of regular expression|unterminated character set)"),
            ('[tool.coverage.report]\npartial_branches_always = ["foo***"]\n',
             r"Invalid \[tool.coverage.report\].partial_branches_always value "
             r"u?'foo\*\*\*': "
             r"multiple repeat"),
            ('[tool.coverage.run]\nconcurrency="foo"', "not a list"),
            ("[tool.coverage.report]\nprecision=1.23", "not an integer"),
            ('[tool.coverage.report]\nfail_under="s"', "not a float"),
        ]

        for bad_config, msg in bad_configs_and_msgs:
            print("Trying %r" % bad_config)
            self.make_file("pyproject.toml", bad_config)
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage()

    def test_environment_vars_in_config(self):
        # Config files can have $envvars in them.
        self.make_file(".coveragerc", """\
            [run]
            data_file = $DATA_FILE.fooey
            branch = $OKAY
            [report]
            exclude_lines =
                the_$$one
                another${THING}
                x${THING}y
                x${NOTHING}y
                huh$${X}what
            """)
        self.set_environ("DATA_FILE", "hello-world")
        self.set_environ("THING", "ZZZ")
        self.set_environ("OKAY", "yes")
        cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "hello-world.fooey")
        self.assertEqual(cov.config.branch, True)
        self.assertEqual(
            cov.config.exclude_list,
            ["the_$one", "anotherZZZ", "xZZZy", "xy", "huh${X}what"]
        )

    def test_environment_vars_in_toml_config(self):
        # Config files can have $envvars in them.
        self.make_file("pyproject.toml", """\
            [tool.coverage.run]
            data_file = "$DATA_FILE.fooey"
            branch = $BRANCH
            [tool.coverage.report]
            exclude_lines = [
                "the_$$one",
                "another${THING}",
                "x${THING}y",
                "x${NOTHING}y",
                "huh$${X}what",
            ]
            """)
        self.set_environ("BRANCH", "true")
        self.set_environ("DATA_FILE", "hello-world")
        self.set_environ("THING", "ZZZ")
        cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "hello-world.fooey")
        self.assertEqual(cov.config.branch, True)
        self.assertEqual(
            cov.config.exclude_list,
            ["the_$one", "anotherZZZ", "xZZZy", "xy", "huh${X}what"]
        )

    def test_tilde_in_config(self):
        # Config entries that are file paths can be tilde-expanded.
        self.make_file(".coveragerc", """\
            [run]
            data_file = ~/data.file

            [html]
            directory = ~joe/html_dir

            [xml]
            output = ~/somewhere/xml.out

            [report]
            # Strings that aren't file paths are not tilde-expanded.
            exclude_lines =
                ~/data.file
                ~joe/html_dir

            [paths]
            mapping =
                ~/src
                ~joe/source
            """)
        def expanduser(s):
            """Fake tilde expansion"""
            s = s.replace("~/", "/Users/me/")
            s = s.replace("~joe/", "/Users/joe/")
            return s

        with mock.patch.object(coverage.config.os.path, 'expanduser', new=expanduser):
            cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "/Users/me/data.file")
        self.assertEqual(cov.config.html_dir, "/Users/joe/html_dir")
        self.assertEqual(cov.config.xml_output, "/Users/me/somewhere/xml.out")
        self.assertEqual(cov.config.exclude_list, ["~/data.file", "~joe/html_dir"])
        self.assertEqual(cov.config.paths, {'mapping': ['/Users/me/src', '/Users/joe/source']})

    def test_tilde_in_toml_config(self):
        # Config entries that are file paths can be tilde-expanded.
        self.make_file("pyproject.toml", """\
            [tool.coverage.run]
            data_file = "~/data.file"

            [tool.coverage.html]
            directory = "~joe/html_dir"

            [tool.coverage.xml]
            output = "~/somewhere/xml.out"

            [tool.coverage.report]
            # Strings that aren't file paths are not tilde-expanded.
            exclude_lines = [
                "~/data.file",
                "~joe/html_dir",
            ]
            """)
        def expanduser(s):
            """Fake tilde expansion"""
            s = s.replace("~/", "/Users/me/")
            s = s.replace("~joe/", "/Users/joe/")
            return s

        with mock.patch.object(coverage.config.os.path, 'expanduser', new=expanduser):
            cov = coverage.Coverage()
        self.assertEqual(cov.config.data_file, "/Users/me/data.file")
        self.assertEqual(cov.config.html_dir, "/Users/joe/html_dir")
        self.assertEqual(cov.config.xml_output, "/Users/me/somewhere/xml.out")
        self.assertEqual(cov.config.exclude_list, ["~/data.file", "~joe/html_dir"])

    def test_tweaks_after_constructor(self):
        # set_option can be used after construction to affect the config.
        cov = coverage.Coverage(timid=True, data_file="fooey.dat")
        cov.set_option("run:timid", False)

        self.assertFalse(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, "fooey.dat")

        self.assertFalse(cov.get_option("run:timid"))
        self.assertFalse(cov.get_option("run:branch"))
        self.assertEqual(cov.get_option("run:data_file"), "fooey.dat")

    def test_tweaks_paths_after_constructor(self):
        self.make_file(".coveragerc", """\
            [paths]
            first =
                /first/1
                /first/2

            second =
                /second/a
                /second/b
            """)
        old_paths = OrderedDict()
        old_paths["first"] = ["/first/1", "/first/2"]
        old_paths["second"] = ["/second/a", "/second/b"]
        cov = coverage.Coverage()
        paths = cov.get_option("paths")
        self.assertEqual(paths, old_paths)

        new_paths = OrderedDict()
        new_paths['magic'] = ['src', 'ok']
        cov.set_option("paths", new_paths)

        self.assertEqual(cov.get_option("paths"), new_paths)

    def test_tweak_error_checking(self):
        # Trying to set an unknown config value raises an error.
        cov = coverage.Coverage()
        with self.assertRaisesRegex(CoverageException, "No such option: 'run:xyzzy'"):
            cov.set_option("run:xyzzy", 12)
        with self.assertRaisesRegex(CoverageException, "No such option: 'xyzzy:foo'"):
            cov.set_option("xyzzy:foo", 12)
        with self.assertRaisesRegex(CoverageException, "No such option: 'run:xyzzy'"):
            _ = cov.get_option("run:xyzzy")
        with self.assertRaisesRegex(CoverageException, "No such option: 'xyzzy:foo'"):
            _ = cov.get_option("xyzzy:foo")

    def test_tweak_plugin_options(self):
        # Plugin options have a more flexible syntax.
        cov = coverage.Coverage()
        cov.set_option("run:plugins", ["fooey.plugin", "xyzzy.coverage.plugin"])
        cov.set_option("fooey.plugin:xyzzy", 17)
        cov.set_option("xyzzy.coverage.plugin:plugh", ["a", "b"])
        with self.assertRaisesRegex(CoverageException, "No such option: 'no_such.plugin:foo'"):
            cov.set_option("no_such.plugin:foo", 23)

        self.assertEqual(cov.get_option("fooey.plugin:xyzzy"), 17)
        self.assertEqual(cov.get_option("xyzzy.coverage.plugin:plugh"), ["a", "b"])
        with self.assertRaisesRegex(CoverageException, "No such option: 'no_such.plugin:foo'"):
            _ = cov.get_option("no_such.plugin:foo")

    def test_unknown_option(self):
        self.make_file(".coveragerc", """\
            [run]
            xyzzy = 17
            """)
        msg = r"Unrecognized option '\[run\] xyzzy=' in config file .coveragerc"
        with self.assertRaisesRegex(CoverageException, msg):
            _ = coverage.Coverage()

    def test_unknown_option_toml(self):
        self.make_file("pyproject.toml", """\
            [tool.coverage.run]
            xyzzy = 17
            """)
        msg = r"Unrecognized option '\[tool.coverage.run\] xyzzy=' in config file pyproject.toml"
        with self.assertRaisesRegex(CoverageException, msg):
            _ = coverage.Coverage()

    def test_misplaced_option(self):
        self.make_file(".coveragerc", """\
            [report]
            branch = True
            """)
        msg = r"Unrecognized option '\[report\] branch=' in config file .coveragerc"
        with self.assertRaisesRegex(CoverageException, msg):
            _ = coverage.Coverage()

    def test_unknown_option_in_other_ini_file(self):
        self.make_file("setup.cfg", """\
            [coverage:run]
            huh = what?
            """)
        msg = (r"Unrecognized option '\[coverage:run\] huh=' in config file setup.cfg")
        with self.assertRaisesRegex(CoverageException, msg):
            _ = coverage.Coverage()

    def test_note_is_obsolete(self):
        self.make_file("main.py", "a = 1")
        self.make_file(".coveragerc", """\
            [run]
            note = I am here I am here I am here!
            """)
        cov = coverage.Coverage()
        with self.assert_warnings(cov, [r"The '\[run] note' setting is no longer supported."]):
            self.start_import_stop(cov, "main")
            cov.report()


class ConfigFileTest(UsingModulesMixin, CoverageTest):
    """Tests of the config file settings in particular."""

    # This sample file tries to use lots of variation of syntax...
    # The {section} placeholder lets us nest these settings in another file.
    LOTSA_SETTINGS = """\
        # This is a settings file for coverage.py
        [{section}run]
        timid = yes
        data_file = something_or_other.dat
        branch = 1
        cover_pylib = TRUE
        parallel = on
        concurrency = thread
        ; this omit is overriden by the omit from [report]
        omit = twenty
        source = myapp
        plugins =
            plugins.a_plugin
            plugins.another
        debug = callers, pids  ,     dataio
        disable_warnings =     abcd  ,  efgh

        [{section}report]
        ; these settings affect reporting.
        exclude_lines =
            if 0:

            pragma:?\\s+no cover
                another_tab

        ignore_errors = TRUE
        omit =
            one, another, some_more,
                yet_more
        include = thirty
        precision = 3

        partial_branches =
            pragma:?\\s+no branch
        partial_branches_always =
            if 0:
            while True:

        show_missing= TruE
        skip_covered = TruE
        skip_empty  =TruE

        [{section}html]

        directory    =     c:\\tricky\\dir.somewhere
        extra_css=something/extra.css
        title = Title & nums # nums!
        [{section}xml]
        output=mycov.xml
        package_depth          =                                17

        [{section}paths]
        source =
            .
            /home/ned/src/

        other = other, /home/ned/other, c:\\Ned\\etc

        [{section}plugins.a_plugin]
        hello = world
        ; comments still work.
        names = Jane/John/Jenny

        [{section}json]
        pretty_print = True
        show_contexts = True
        """

    # Just some sample setup.cfg text from the docs.
    SETUP_CFG = """\
        [bdist_rpm]
        release = 1
        packager = Jane Packager <janep@pysoft.com>
        doc_files = CHANGES.txt
                    README.txt
                    USAGE.txt
                    doc/
                    examples/
        """

    # Just some sample tox.ini text from the docs.
    TOX_INI = """\
        [tox]
        envlist = py{26,27,33,34,35}-{c,py}tracer
        skip_missing_interpreters = True

        [testenv]
        commands =
            # Create tests/zipmods.zip, install the egg1 egg
            python igor.py zip_mods install_egg
        """

    def assert_config_settings_are_correct(self, cov):
        """Check that `cov` has all the settings from LOTSA_SETTINGS."""
        self.assertTrue(cov.config.timid)
        self.assertEqual(cov.config.data_file, "something_or_other.dat")
        self.assertTrue(cov.config.branch)
        self.assertTrue(cov.config.cover_pylib)
        self.assertEqual(cov.config.debug, ["callers", "pids", "dataio"])
        self.assertTrue(cov.config.parallel)
        self.assertEqual(cov.config.concurrency, ["thread"])
        self.assertEqual(cov.config.source, ["myapp"])
        self.assertEqual(cov.config.disable_warnings, ["abcd", "efgh"])

        self.assertEqual(cov.get_exclude_list(), ["if 0:", r"pragma:?\s+no cover", "another_tab"])
        self.assertTrue(cov.config.ignore_errors)
        self.assertEqual(cov.config.run_omit, ["twenty"])
        self.assertEqual(cov.config.report_omit, ["one", "another", "some_more", "yet_more"])
        self.assertEqual(cov.config.report_include, ["thirty"])
        self.assertEqual(cov.config.precision, 3)

        self.assertEqual(cov.config.partial_list, [r"pragma:?\s+no branch"])
        self.assertEqual(cov.config.partial_always_list, ["if 0:", "while True:"])
        self.assertEqual(cov.config.plugins, ["plugins.a_plugin", "plugins.another"])
        self.assertTrue(cov.config.show_missing)
        self.assertTrue(cov.config.skip_covered)
        self.assertTrue(cov.config.skip_empty)
        self.assertEqual(cov.config.html_dir, r"c:\tricky\dir.somewhere")
        self.assertEqual(cov.config.extra_css, "something/extra.css")
        self.assertEqual(cov.config.html_title, "Title & nums # nums!")

        self.assertEqual(cov.config.xml_output, "mycov.xml")
        self.assertEqual(cov.config.xml_package_depth, 17)

        self.assertEqual(cov.config.paths, {
            'source': ['.', '/home/ned/src/'],
            'other': ['other', '/home/ned/other', 'c:\\Ned\\etc']
        })

        self.assertEqual(cov.config.get_plugin_options("plugins.a_plugin"), {
            'hello': 'world',
            'names': 'Jane/John/Jenny',
        })
        self.assertEqual(cov.config.get_plugin_options("plugins.another"), {})
        self.assertEqual(cov.config.json_show_contexts, True)
        self.assertEqual(cov.config.json_pretty_print, True)

    def test_config_file_settings(self):
        self.make_file(".coveragerc", self.LOTSA_SETTINGS.format(section=""))
        cov = coverage.Coverage()
        self.assert_config_settings_are_correct(cov)

    def check_config_file_settings_in_other_file(self, fname, contents):
        """Check config will be read from another file, with prefixed sections."""
        nested = self.LOTSA_SETTINGS.format(section="coverage:")
        fname = self.make_file(fname, nested + "\n" + contents)
        cov = coverage.Coverage()
        self.assert_config_settings_are_correct(cov)

    def test_config_file_settings_in_setupcfg(self):
        self.check_config_file_settings_in_other_file("setup.cfg", self.SETUP_CFG)

    def test_config_file_settings_in_toxini(self):
        self.check_config_file_settings_in_other_file("tox.ini", self.TOX_INI)

    def check_other_config_if_coveragerc_specified(self, fname, contents):
        """Check that config `fname` is read if .coveragerc is missing, but specified."""
        nested = self.LOTSA_SETTINGS.format(section="coverage:")
        self.make_file(fname, nested + "\n" + contents)
        cov = coverage.Coverage(config_file=".coveragerc")
        self.assert_config_settings_are_correct(cov)

    def test_config_file_settings_in_setupcfg_if_coveragerc_specified(self):
        self.check_other_config_if_coveragerc_specified("setup.cfg", self.SETUP_CFG)

    def test_config_file_settings_in_tox_if_coveragerc_specified(self):
        self.check_other_config_if_coveragerc_specified("tox.ini", self.TOX_INI)

    def check_other_not_read_if_coveragerc(self, fname):
        """Check config `fname` is not read if .coveragerc exists."""
        self.make_file(".coveragerc", """\
            [run]
            include = foo
            """)
        self.make_file(fname, """\
            [coverage:run]
            omit = bar
            branch = true
            """)
        cov = coverage.Coverage()
        self.assertEqual(cov.config.run_include, ["foo"])
        self.assertEqual(cov.config.run_omit, None)
        self.assertEqual(cov.config.branch, False)

    def test_setupcfg_only_if_not_coveragerc(self):
        self.check_other_not_read_if_coveragerc("setup.cfg")

    def test_toxini_only_if_not_coveragerc(self):
        self.check_other_not_read_if_coveragerc("tox.ini")

    def check_other_config_need_prefixes(self, fname):
        """Check that `fname` sections won't be read if un-prefixed."""
        self.make_file(fname, """\
            [run]
            omit = bar
            branch = true
            """)
        cov = coverage.Coverage()
        self.assertEqual(cov.config.run_omit, None)
        self.assertEqual(cov.config.branch, False)

    def test_setupcfg_only_if_prefixed(self):
        self.check_other_config_need_prefixes("setup.cfg")

    def test_toxini_only_if_prefixed(self):
        self.check_other_config_need_prefixes("tox.ini")

    def test_tox_ini_even_if_setup_cfg(self):
        # There's a setup.cfg, but no coverage settings in it, so tox.ini
        # is read.
        nested = self.LOTSA_SETTINGS.format(section="coverage:")
        self.make_file("tox.ini", self.TOX_INI + "\n" + nested)
        self.make_file("setup.cfg", self.SETUP_CFG)
        cov = coverage.Coverage()
        self.assert_config_settings_are_correct(cov)

    def test_read_prefixed_sections_from_explicit_file(self):
        # You can point to a tox.ini, and it will find [coverage:run] sections
        nested = self.LOTSA_SETTINGS.format(section="coverage:")
        self.make_file("tox.ini", self.TOX_INI + "\n" + nested)
        cov = coverage.Coverage(config_file="tox.ini")
        self.assert_config_settings_are_correct(cov)

    def test_non_ascii(self):
        self.make_file(".coveragerc", """\
            [report]
            exclude_lines =
                first
                ✘${TOX_ENVNAME}
                third
            [html]
            title = tabblo & «ταБЬℓσ» # numbers
            """)
        self.set_environ("TOX_ENVNAME", "weirdo")
        cov = coverage.Coverage()

        self.assertEqual(cov.config.exclude_list, ["first", "✘weirdo", "third"])
        self.assertEqual(cov.config.html_title, "tabblo & «ταБЬℓσ» # numbers")

    def test_unreadable_config(self):
        # If a config file is explicitly specified, then it is an error for it
        # to not be readable.
        bad_files = [
            "nosuchfile.txt",
            ".",
        ]
        for bad_file in bad_files:
            msg = "Couldn't read %r as a config file" % bad_file
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage(config_file=bad_file)

    def test_nocoveragerc_file_when_specified(self):
        cov = coverage.Coverage(config_file=".coveragerc")
        self.assertFalse(cov.config.timid)
        self.assertFalse(cov.config.branch)
        self.assertEqual(cov.config.data_file, ".coverage")

    def test_no_toml_installed_no_toml(self):
        # Can't read a toml file that doesn't exist.
        with coverage.optional.without('toml'):
            msg = "Couldn't read 'cov.toml' as a config file"
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage(config_file="cov.toml")

    def test_no_toml_installed_explicit_toml(self):
        # Can't specify a toml config file if toml isn't installed.
        self.make_file("cov.toml", "# A toml file!")
        with coverage.optional.without('toml'):
            msg = "Can't read 'cov.toml' without TOML support"
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage(config_file="cov.toml")

    def test_no_toml_installed_pyproject_toml(self):
        # Can't have coverage config in pyproject.toml without toml installed.
        self.make_file("pyproject.toml", """\
            # A toml file!
            [tool.coverage.run]
            xyzzy = 17
            """)
        with coverage.optional.without('toml'):
            msg = "Can't read 'pyproject.toml' without TOML support"
            with self.assertRaisesRegex(CoverageException, msg):
                coverage.Coverage()

    def test_no_toml_installed_pyproject_no_coverage(self):
        # It's ok to have non-coverage pyproject.toml without toml installed.
        self.make_file("pyproject.toml", """\
            # A toml file!
            [tool.something]
            xyzzy = 17
            """)
        with coverage.optional.without('toml'):
            cov = coverage.Coverage()
            # We get default settings:
            self.assertFalse(cov.config.timid)
            self.assertFalse(cov.config.branch)
            self.assertEqual(cov.config.data_file, ".coverage")
