# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

import ConfigParser
import argparse
import os
import re
import sys
from collections import defaultdict

import mozpack.path as mozpath
from ..vcs import VCSHelper


def arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('paths', nargs='*', help='Paths to search for tests to run on try.')
    parser.add_argument('-b', '--build', dest='builds', default='do',
                        help='Build types to run (d for debug, o for optimized).')
    parser.add_argument('-p', '--platform', dest='platforms', action='append',
                        help='Platforms to run (required if not found in the environment as '
                             'AUTOTRY_PLATFORM_HINT).')
    parser.add_argument('-u', '--unittests', dest='tests', action='append',
                        help='Test suites to run in their entirety.')
    parser.add_argument('-t', '--talos', dest='talos', action='append',
                        help='Talos suites to run.')
    parser.add_argument('-j', '--jobs', dest='jobs', action='append',
                        help='Job tasks to run.')
    parser.add_argument('--tag', dest='tags', action='append',
                        help='Restrict tests to the given tag (may be specified multiple times).')
    parser.add_argument('--and', action='store_true', dest='intersection',
                        help='When -u and paths are supplied run only the intersection of the '
                             'tests specified by the two arguments.')
    parser.add_argument('--no-push', dest='push', action='store_false',
                        help='Do not push to try as a result of running this command (if '
                        'specified this command will only print calculated try '
                        'syntax and selection info).')
    parser.add_argument('--save', dest='save', action='store',
                        help='Save the command line arguments for future use with --preset.')
    parser.add_argument('--preset', dest='load', action='store',
                        help='Load a saved set of arguments. Additional arguments will override '
                             'saved ones.')
    parser.add_argument('--list', action='store_true',
                        help='List all saved try strings')
    parser.add_argument('-v', '--verbose', dest='verbose', action='store_true', default=False,
                        help='Print detailed information about the resulting test selection '
                        'and commands performed.')
    for arg, opts in AutoTry.pass_through_arguments.items():
        parser.add_argument(arg, **opts)
    return parser


class TryArgumentTokenizer(object):
    symbols = [("seperator", ","),
               ("list_start", "\["),
               ("list_end", "\]"),
               ("item", "([^,\[\]\s][^,\[\]]+)"),
               ("space", "\s+")]
    token_re = re.compile("|".join("(?P<%s>%s)" % item for item in symbols))

    def tokenize(self, data):
        for match in self.token_re.finditer(data):
            symbol = match.lastgroup
            data = match.group(symbol)
            if symbol == "space":
                pass
            else:
                yield symbol, data


class TryArgumentParser(object):
    """Simple three-state parser for handling expressions
    of the from "foo[sub item, another], bar,baz". This takes
    input from the TryArgumentTokenizer and runs through a small
    state machine, returning a dictionary of {top-level-item:[sub_items]}
    i.e. the above would result in
    {"foo":["sub item", "another"], "bar": [], "baz": []}
    In the case of invalid input a ValueError is raised."""

    EOF = object()

    def __init__(self):
        self.reset()

    def reset(self):
        self.tokens = None
        self.current_item = None
        self.data = {}
        self.token = None
        self.state = None

    def parse(self, tokens):
        self.reset()
        self.tokens = tokens
        self.consume()
        self.state = self.item_state
        while self.token[0] != self.EOF:
            self.state()
        return self.data

    def consume(self):
        try:
            self.token = self.tokens.next()
        except StopIteration:
            self.token = (self.EOF, None)

    def expect(self, *types):
        if self.token[0] not in types:
            raise ValueError("Error parsing try string, unexpected %s" % (self.token[0]))

    def item_state(self):
        self.expect("item")
        value = self.token[1].strip()
        if value not in self.data:
            self.data[value] = []
        self.current_item = value
        self.consume()
        if self.token[0] == "seperator":
            self.consume()
        elif self.token[0] == "list_start":
            self.consume()
            self.state = self.subitem_state
        elif self.token[0] == self.EOF:
            pass
        else:
            raise ValueError

    def subitem_state(self):
        self.expect("item")
        value = self.token[1].strip()
        self.data[self.current_item].append(value)
        self.consume()
        if self.token[0] == "seperator":
            self.consume()
        elif self.token[0] == "list_end":
            self.consume()
            self.state = self.after_list_end_state
        else:
            raise ValueError

    def after_list_end_state(self):
        self.expect("seperator")
        self.consume()
        self.state = self.item_state


def parse_arg(arg):
    tokenizer = TryArgumentTokenizer()
    parser = TryArgumentParser()
    return parser.parse(tokenizer.tokenize(arg))


class AutoTry(object):

    # Maps from flavors to the job names needed to run that flavour
    flavor_jobs = {
        'mochitest': ['mochitest-1', 'mochitest-e10s-1'],
        'xpcshell': ['xpcshell'],
        'chrome': ['mochitest-o'],
        'browser-chrome': ['mochitest-browser-chrome-1',
                           'mochitest-e10s-browser-chrome-1',
                           'mochitest-browser-chrome-e10s-1'],
        'devtools-chrome': ['mochitest-devtools-chrome-1',
                            'mochitest-e10s-devtools-chrome-1',
                            'mochitest-devtools-chrome-e10s-1'],
        'crashtest': ['crashtest', 'crashtest-e10s'],
        'reftest': ['reftest', 'reftest-e10s'],
        'web-platform-tests': ['web-platform-tests-1'],
    }

    flavor_suites = {
        "mochitest": "mochitests",
        "xpcshell": "xpcshell",
        "chrome": "mochitest-o",
        "browser-chrome": "mochitest-bc",
        "devtools-chrome": "mochitest-dt",
        "crashtest": "crashtest",
        "reftest": "reftest",
        "web-platform-tests": "web-platform-tests",
    }

    compiled_suites = [
        "cppunit",
        "gtest",
        "jittest",
    ]

    common_suites = [
        "cppunit",
        "crashtest",
        "firefox-ui-functional",
        "gtest",
        "jittest",
        "jsreftest",
        "marionette",
        "marionette-e10s",
        "mochitests",
        "reftest",
        "web-platform-tests",
        "xpcshell",
    ]

    # Arguments we will accept on the command line and pass through to try
    # syntax with no further intervention. The set is taken from
    # http://trychooser.pub.build.mozilla.org with a few additions.
    #
    # Note that the meaning of store_false and store_true arguments is
    # not preserved here, as we're only using these to echo the literal
    # arguments to another consumer. Specifying either store_false or
    # store_true here will have an equivalent effect.
    pass_through_arguments = {
        '--rebuild': {
            'action': 'store',
            'dest': 'rebuild',
            'help': 'Re-trigger all test jobs (up to 20 times)',
        },
        '--rebuild-talos': {
            'action': 'store',
            'dest': 'rebuild_talos',
            'help': 'Re-trigger all talos jobs',
        },
        '--interactive': {
            'action': 'store_true',
            'dest': 'interactive',
            'help': 'Allow ssh-like access to running test containers',
        },
        '--no-retry': {
            'action': 'store_true',
            'dest': 'no_retry',
            'help': 'Do not retrigger failed tests',
        },
        '--setenv': {
            'action': 'append',
            'dest': 'setenv',
            'help': 'Set the corresponding variable in the test environment for'
                    'applicable harnesses.',
        },
        '-f': {
            'action': 'store_true',
            'dest': 'failure_emails',
            'help': 'Request failure emails only',
        },
        '--failure-emails': {
            'action': 'store_true',
            'dest': 'failure_emails',
            'help': 'Request failure emails only',
        },
        '-e': {
            'action': 'store_true',
            'dest': 'all_emails',
            'help': 'Request all emails',
        },
        '--all-emails': {
            'action': 'store_true',
            'dest': 'all_emails',
            'help': 'Request all emails',
        },
        '--artifact': {
            'action': 'store_true',
            'dest': 'artifact',
            'help': 'Force artifact builds where possible.',
        },
        '--upload-xdbs': {
            'action': 'store_true',
            'dest': 'upload_xdbs',
            'help': 'Upload XDB compilation db files generated by hazard build',
        },
    }

    def __init__(self, topsrcdir, resolver_func, mach_context):
        self.topsrcdir = topsrcdir
        self._resolver_func = resolver_func
        self._resolver = None
        self.mach_context = mach_context
        self.vcs = VCSHelper.create()

    @property
    def resolver(self):
        if self._resolver is None:
            self._resolver = self._resolver_func()
        return self._resolver

    @property
    def config_path(self):
        return os.path.join(self.mach_context.state_dir, "autotry.ini")

    def load_config(self, name):
        config = ConfigParser.RawConfigParser()
        success = config.read([self.config_path])
        if not success:
            return None

        try:
            data = config.get("try", name)
        except (ConfigParser.NoSectionError, ConfigParser.NoOptionError):
            return None

        kwargs = vars(arg_parser().parse_args(self.split_try_string(data)))

        return kwargs

    def list_presets(self):
        config = ConfigParser.RawConfigParser()
        success = config.read([self.config_path])

        data = []
        if success:
            try:
                data = config.items("try")
            except (ConfigParser.NoSectionError, ConfigParser.NoOptionError):
                pass

        if not data:
            print("No presets found")

        for name, try_string in data:
            print("%s: %s" % (name, try_string))

    def split_try_string(self, data):
        return re.findall(r'(?:\[.*?\]|\S)+', data)

    def save_config(self, name, data):
        assert data.startswith("try: ")
        data = data[len("try: "):]

        parser = ConfigParser.RawConfigParser()
        parser.read([self.config_path])

        if not parser.has_section("try"):
            parser.add_section("try")

        parser.set("try", name, data)

        with open(self.config_path, "w") as f:
            parser.write(f)

    def paths_by_flavor(self, paths=None, tags=None):
        paths_by_flavor = defaultdict(set)

        if not (paths or tags):
            return dict(paths_by_flavor)

        tests = list(self.resolver.resolve_tests(paths=paths,
                                                 tags=tags))

        for t in tests:
            if t['flavor'] in self.flavor_suites:
                flavor = t['flavor']
                if 'subsuite' in t and t['subsuite'] == 'devtools':
                    flavor = 'devtools-chrome'

                if flavor in ['crashtest', 'reftest']:
                    manifest_relpath = os.path.relpath(t['manifest'], self.topsrcdir)
                    paths_by_flavor[flavor].add(os.path.dirname(manifest_relpath))
                elif 'dir_relpath' in t:
                    paths_by_flavor[flavor].add(t['dir_relpath'])
                else:
                    file_relpath = os.path.relpath(t['path'], self.topsrcdir)
                    dir_relpath = os.path.dirname(file_relpath)
                    paths_by_flavor[flavor].add(dir_relpath)

        for flavor, path_set in paths_by_flavor.items():
            paths_by_flavor[flavor] = self.deduplicate_prefixes(path_set, paths)

        return dict(paths_by_flavor)

    def deduplicate_prefixes(self, path_set, input_paths):
        # Removes paths redundant to test selection in the given path set.
        # If a path was passed on the commandline that is the prefix of a
        # path in our set, we only need to include the specified prefix to
        # run the intended tests (every test in "layout/base" will run if
        # "layout" is passed to the reftest harness).
        removals = set()
        additions = set()

        for path in path_set:
            full_path = path
            while path:
                path, _ = os.path.split(path)
                if path in input_paths:
                    removals.add(full_path)
                    additions.add(path)

        return additions | (path_set - removals)

    def remove_duplicates(self, paths_by_flavor, tests):
        rv = {}
        for item in paths_by_flavor:
            if self.flavor_suites[item] not in tests:
                rv[item] = paths_by_flavor[item].copy()
        return rv

    def calc_try_syntax(self, platforms, tests, talos, jobs, builds, paths_by_flavor, tags,
                        extras, intersection):
        parts = ["try:"]

        if platforms:
            parts.extend(["-b", builds, "-p", ",".join(platforms)])

        suites = tests if not intersection else {}
        paths = set()
        for flavor, flavor_tests in paths_by_flavor.iteritems():
            suite = self.flavor_suites[flavor]
            if suite not in suites and (not intersection or suite in tests):
                for job_name in self.flavor_jobs[flavor]:
                    for test in flavor_tests:
                        paths.add("%s:%s" % (flavor, test))
                    suites[job_name] = tests.get(suite, [])

        # intersection implies tests are expected
        if intersection and not suites:
            raise ValueError("No tests found matching filters")

        if extras.get('artifact') and any([p.endswith("-nightly") for p in platforms]):
            print('You asked for |--artifact| but "-nightly" platforms don\'t have artifacts. '
                  'Running without |--artifact| instead.')
            del extras['artifact']

        if extras.get('artifact'):
            rejected = []
            for suite in suites.keys():
                if any([suite.startswith(c) for c in self.compiled_suites]):
                    rejected.append(suite)
            if rejected:
                raise ValueError("You can't run {} with "
                                 "--artifact option.".format(', '.join(rejected)))

        if extras.get('artifact') and 'all' in suites.keys():
            non_compiled_suites = set(self.common_suites) - set(self.compiled_suites)
            message = ('You asked for |-u all| with |--artifact| but compiled-code tests ({tests})'
                       ' can\'t run against an artifact build. Running (-u {non_compiled_suites}) '
                       'instead.')
            string_format = {
                'tests': ','.join(self.compiled_suites),
                'non_compiled_suites': ','.join(non_compiled_suites),
            }
            print(message.format(**string_format))
            del suites['all']
            suites.update({suite_name: None for suite_name in non_compiled_suites})

        if suites:
            parts.append("-u")
            parts.append(",".join("%s%s" % (k, "[%s]" % ",".join(v) if v else "")
                                  for k, v in sorted(suites.items())))

        if talos:
            parts.append("-t")
            parts.append(",".join("%s%s" % (k, "[%s]" % ",".join(v) if v else "")
                                  for k, v in sorted(talos.items())))

        if jobs:
            parts.append("-j")
            parts.append(",".join(jobs))

        if tags:
            parts.append(' '.join('--tag %s' % t for t in tags))

        if paths:
            parts.append("--try-test-paths %s" % " ".join(sorted(paths)))

        args_by_dest = {v['dest']: k for k, v in AutoTry.pass_through_arguments.items()}
        for dest, value in extras.iteritems():
            assert dest in args_by_dest
            arg = args_by_dest[dest]
            action = AutoTry.pass_through_arguments[arg]['action']
            if action == 'store':
                parts.append(arg)
                parts.append(value)
            if action == 'append':
                for e in value:
                    parts.append(arg)
                    parts.append(e)
            if action in ('store_true', 'store_false'):
                parts.append(arg)

        try_syntax = " ".join(parts)
        return try_syntax

    def find_paths_and_tags(self, verbose):
        paths, tags = set(), set()
        changed_files = self.vcs.files_changed
        if changed_files:
            if verbose:
                print("Pushing tests based on modifications to the "
                      "following files:\n\t%s" % "\n\t".join(changed_files))

            from mozbuild.frontend.reader import (
                BuildReader,
                EmptyConfig,
            )

            config = EmptyConfig(self.topsrcdir)
            reader = BuildReader(config)
            files_info = reader.files_info(changed_files)

            for path, info in files_info.items():
                paths |= info.test_files
                tags |= info.test_tags

            if verbose:
                if paths:
                    print("Pushing tests based on the following patterns:\n\t%s" %
                          "\n\t".join(paths))
                if tags:
                    print("Pushing tests based on the following tags:\n\t%s" %
                          "\n\t".join(tags))
        return paths, tags

    def normalise_list(self, items, allow_subitems=False):
        rv = defaultdict(list)
        for item in items:
            parsed = parse_arg(item)
            for key, values in parsed.iteritems():
                rv[key].extend(values)

        if not allow_subitems:
            if not all(item == [] for item in rv.itervalues()):
                raise ValueError("Unexpected subitems in argument")
            return rv.keys()
        else:
            return rv

    def validate_args(self, **kwargs):
        tests_selected = kwargs["tests"] or kwargs["paths"] or kwargs["tags"]
        if kwargs["platforms"] is None and (kwargs["jobs"] is None or tests_selected):
            if 'AUTOTRY_PLATFORM_HINT' in os.environ:
                kwargs["platforms"] = [os.environ['AUTOTRY_PLATFORM_HINT']]
            elif tests_selected:
                print("Must specify platform when selecting tests.")
                sys.exit(1)
            else:
                print("Either platforms or jobs must be specified as an argument to autotry.")
                sys.exit(1)

        try:
            platforms = (self.normalise_list(kwargs["platforms"])
                         if kwargs["platforms"] else {})
        except ValueError as e:
            print("Error parsing -p argument:\n%s" % e.message)
            sys.exit(1)

        try:
            tests = (self.normalise_list(kwargs["tests"], allow_subitems=True)
                     if kwargs["tests"] else {})
        except ValueError as e:
            print("Error parsing -u argument (%s):\n%s" % (kwargs["tests"], e.message))
            sys.exit(1)

        try:
            talos = (self.normalise_list(kwargs["talos"], allow_subitems=True)
                     if kwargs["talos"] else [])
        except ValueError as e:
            print("Error parsing -t argument:\n%s" % e.message)
            sys.exit(1)

        try:
            jobs = (self.normalise_list(kwargs["jobs"]) if kwargs["jobs"] else {})
        except ValueError as e:
            print("Error parsing -j argument:\n%s" % e.message)
            sys.exit(1)

        paths = []
        for p in kwargs["paths"]:
            p = mozpath.normpath(os.path.abspath(p))
            if not (os.path.isdir(p) and p.startswith(self.topsrcdir)):
                print('Specified path "%s" is not a directory under the srcdir,'
                      ' unable to specify tests outside of the srcdir' % p)
                sys.exit(1)
            if len(p) <= len(self.topsrcdir):
                print('Specified path "%s" is at the top of the srcdir and would'
                      ' select all tests.' % p)
                sys.exit(1)
            paths.append(os.path.relpath(p, self.topsrcdir))

        try:
            tags = self.normalise_list(kwargs["tags"]) if kwargs["tags"] else []
        except ValueError as e:
            print("Error parsing --tags argument:\n%s" % e.message)
            sys.exit(1)

        extra_values = {k['dest'] for k in AutoTry.pass_through_arguments.values()}
        extra_args = {k: v for k, v in kwargs.items()
                      if k in extra_values and v}

        return kwargs["builds"], platforms, tests, talos, jobs, paths, tags, extra_args

    def run(self, **kwargs):
        if kwargs["list"]:
            self.list_presets()
            sys.exit()

        if kwargs["load"] is not None:
            defaults = self.load_config(kwargs["load"])

            if defaults is None:
                print("No saved configuration called %s found in autotry.ini" % kwargs["load"],
                      file=sys.stderr)

            for key, value in kwargs.iteritems():
                if value in (None, []) and key in defaults:
                    kwargs[key] = defaults[key]

        if not any(kwargs[item] for item in ("paths", "tests", "tags")):
            kwargs["paths"], kwargs["tags"] = self.find_paths_and_tags(kwargs["verbose"])

        builds, platforms, tests, talos, jobs, paths, tags, extra = self.validate_args(**kwargs)

        if paths or tags:
            paths = [os.path.relpath(os.path.normpath(os.path.abspath(item)), self.topsrcdir)
                     for item in paths]
            paths_by_flavor = self.paths_by_flavor(paths=paths, tags=tags)

            if not paths_by_flavor and not tests:
                print("No tests were found when attempting to resolve paths:\n\n\t%s" %
                      paths)
                sys.exit(1)

            if not kwargs["intersection"]:
                paths_by_flavor = self.remove_duplicates(paths_by_flavor, tests)
        else:
            paths_by_flavor = {}

        # No point in dealing with artifacts if we aren't running any builds
        local_artifact_build = False
        if platforms:
            local_artifact_build = kwargs.get('local_artifact_build', False)

            # Add --artifact if --enable-artifact-builds is set ...
            if local_artifact_build:
                extra["artifact"] = True
            # ... unless --no-artifact is explicitly given.
            if kwargs["no_artifact"]:
                if "artifact" in extra:
                    del extra["artifact"]

        try:
            msg = self.calc_try_syntax(platforms, tests, talos, jobs, builds,
                                       paths_by_flavor, tags, extra, kwargs["intersection"])
        except ValueError as e:
            print(e.message)
            sys.exit(1)

        if local_artifact_build:
            if kwargs["no_artifact"]:
                print('mozconfig has --enable-artifact-builds but '
                      '--no-artifact specified, not including --artifact '
                      'flag in try syntax')
            else:
                print('mozconfig has --enable-artifact-builds; including '
                      '--artifact flag in try syntax (use --no-artifact '
                      'to override)')

        if kwargs["verbose"] and paths_by_flavor:
            print('The following tests will be selected: ')
            for flavor, paths in paths_by_flavor.iteritems():
                print("%s: %s" % (flavor, ",".join(paths)))

        if kwargs["verbose"] or not kwargs["push"]:
            print('The following try syntax was calculated:\n%s' % msg)

        if kwargs["push"]:
            self.vcs.push_to_try(msg)

        if kwargs["save"] is not None:
            self.save_config(kwargs["save"], msg)
