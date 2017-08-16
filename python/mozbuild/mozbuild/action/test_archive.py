# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This action is used to produce test archives.
#
# Ideally, the data in this file should be defined in moz.build files.
# It is defined inline because this was easiest to make test archive
# generation faster.

from __future__ import absolute_import, print_function, unicode_literals

import argparse
import itertools
import os
import sys
import time

from manifestparser import TestManifest
from reftest import ReftestManifest

from mozbuild.util import ensureParentDir
from mozpack.archive import create_tar_gz_from_files
from mozpack.copier import FileRegistry
from mozpack.files import ExistingFile, FileFinder
from mozpack.manifests import InstallManifest
from mozpack.mozjar import JarWriter
import mozpack.path as mozpath

import buildconfig

STAGE = mozpath.join(buildconfig.topobjdir, 'dist', 'test-stage')

TEST_HARNESS_BINS = [
    'BadCertServer',
    'GenerateOCSPResponse',
    'OCSPStaplingServer',
    'SmokeDMD',
    'certutil',
    'crashinject',
    'fileid',
    'geckodriver',
    'minidumpwriter',
    'pk12util',
    'screenshot',
    'screentopng',
    'ssltunnel',
    'xpcshell',
]

# The fileid utility depends on mozglue. See bug 1069556.
TEST_HARNESS_DLLS = [
    'crashinjectdll',
    'mozglue'
]

TEST_PLUGIN_DLLS = [
    'npsecondtest',
    'npswftest',
    'nptest',
    'nptestjava',
    'npthirdtest',
]

TEST_PLUGIN_DIRS = [
    'JavaTest.plugin/**',
    'SecondTest.plugin/**',
    'Test.plugin/**',
    'ThirdTest.plugin/**',
    'npswftest.plugin/**',
]

GMP_TEST_PLUGIN_DIRS = [
    'gmp-clearkey/**',
    'gmp-fake/**',
    'gmp-fakeopenh264/**',
]

# These entries will be used by artifact builds to re-construct an
# objdir with the appropriate generated support files.
OBJDIR_TEST_FILES = {
    'xpcshell': {
        'source': buildconfig.topobjdir,
        'base': '_tests/xpcshell',
        'pattern': '**',
        'dest': 'xpcshell/tests',
    },
    'mochitest': {
        'source': buildconfig.topobjdir,
        'base': '_tests/testing',
        'pattern': 'mochitest/**',
    },
}


ARCHIVE_FILES = {
    'common': [
        {
            'source': STAGE,
            'base': '',
            'pattern': '**',
            'ignore': [
                'cppunittest/**',
                'gtest/**',
                'mochitest/**',
                'reftest/**',
                'talos/**',
                'awsy/**',
                'web-platform/**',
                'xpcshell/**',
            ],
        },
        {
            'source': buildconfig.topobjdir,
            'base': '_tests',
            'pattern': 'modules/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing/marionette',
            'patterns': [
                'client/**',
                'harness/**',
                'puppeteer/**',
                'mach_test_package_commands.py',
            ],
            'dest': 'marionette',
            'ignore': [
                'client/docs',
                'harness/marionette_harness/tests',
                'puppeteer/firefox/docs',
            ],
        },
        {
            'source': buildconfig.topsrcdir,
            'base': '',
            'manifests': [
                'testing/marionette/harness/marionette_harness/tests/unit-tests.ini',
                'testing/marionette/harness/marionette_harness/tests/webapi-tests.ini',
            ],
            # We also need the manifests and harness_unit tests
            'pattern': 'testing/marionette/harness/marionette_harness/tests/**',
            'dest': 'marionette/tests',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '_tests',
            'pattern': 'mozbase/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'firefox-ui/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'dom/media/test/external',
            'pattern': '**',
            'dest': 'external-media-tests',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'js/src',
            'pattern': 'jit-test/**',
            'dest': 'jit-test',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'js/src/tests',
            'pattern': 'ecma_6/**',
            'dest': 'jit-test/tests',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'js/src/tests',
            'pattern': 'js1_8_5/**',
            'dest': 'jit-test/tests',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'js/src/tests',
            'pattern': 'lib/**',
            'dest': 'jit-test/tests',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'js/src',
            'pattern': 'jsapi.h',
            'dest': 'jit-test',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'tps/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'services/sync/',
            'pattern': 'tps/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'services/sync/tests/tps',
            'pattern': '**',
            'dest': 'tps/tests',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing/web-platform/tests/tools/wptserve',
            'pattern': '**',
            'dest': 'tools/wptserve',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/bin',
            'patterns': [
                '%s%s' % (f, buildconfig.substs['BIN_SUFFIX'])
                for f in TEST_HARNESS_BINS
            ] + [
                '%s%s%s' % (buildconfig.substs['DLL_PREFIX'], f, buildconfig.substs['DLL_SUFFIX'])
                for f in TEST_HARNESS_DLLS
            ],
            'dest': 'bin',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/plugins',
            'patterns': [
                '%s%s%s' % (buildconfig.substs['DLL_PREFIX'], f, buildconfig.substs['DLL_SUFFIX'])
                for f in TEST_PLUGIN_DLLS
            ],
            'dest': 'bin/plugins',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/plugins',
            'patterns': TEST_PLUGIN_DIRS,
            'dest': 'bin/plugins',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/bin',
            'patterns': GMP_TEST_PLUGIN_DIRS,
            'dest': 'bin/plugins',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/bin',
            'patterns': [
                'dmd.py',
                'fix_linux_stack.py',
                'fix_macosx_stack.py',
                'fix_stack_using_bpsyms.py',
            ],
            'dest': 'bin',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'dist/bin/components',
            'patterns': [
                'httpd.js',
                'httpd.manifest',
                'test_necko.xpt',
            ],
            'dest': 'bin/components',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'build/pgo/certs',
            'pattern': '**',
            'dest': 'certs',
        }
    ],
    'cppunittest': [
        {
            'source': STAGE,
            'base': '',
            'pattern': 'cppunittest/**',
        },
        # We don't ship these files if startup cache is disabled, which is
        # rare. But it shouldn't matter for test archives.
        {
            'source': buildconfig.topsrcdir,
            'base': 'startupcache/test',
            'pattern': 'TestStartupCacheTelemetry.*',
            'dest': 'cppunittest',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'runcppunittests.py',
            'dest': 'cppunittest',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'remotecppunittests.py',
            'dest': 'cppunittest',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'cppunittest.ini',
            'dest': 'cppunittest',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
            'dest': 'cppunittest',
        },
    ],
    'gtest': [
        {
            'source': STAGE,
            'base': '',
            'pattern': 'gtest/**',
        },
    ],
    'mochitest': [
        OBJDIR_TEST_FILES['mochitest'],
        {
            'source': buildconfig.topobjdir,
            'base': '_tests/testing',
            'pattern': 'mochitest/**',
        },
        {
            'source': STAGE,
            'base': '',
            'pattern': 'mochitest/**',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
            'dest': 'mochitest'
        }
    ],
    'mozharness': [
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'mozharness/**',
        },
    ],
    'reftest': [
        {
            'source': buildconfig.topobjdir,
            'base': '_tests',
            'pattern': 'reftest/**',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
            'dest': 'reftest',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': '',
            'manifests': [
                'layout/reftests/reftest.list',
                'testing/crashtest/crashtests.list',
            ],
            'dest': 'reftest/tests',
        }
    ],
    'talos': [
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'talos/**',
        },
    ],
    'awsy': [
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'awsy/**',
        },
    ],
    'web-platform': [
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'web-platform/meta/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'web-platform/mozilla/**',
        },
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing',
            'pattern': 'web-platform/tests/**',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '_tests',
            'pattern': 'web-platform/**',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
            'dest': 'web-platform',
        },
    ],
    'xpcshell': [
        OBJDIR_TEST_FILES['xpcshell'],
        {
            'source': buildconfig.topsrcdir,
            'base': 'testing/xpcshell',
            'patterns': [
                'head.js',
                'mach_test_package_commands.py',
                'moz-http2/**',
                'moz-spdy/**',
                'node-http2/**',
                'node-spdy/**',
                'remotexpcshelltests.py',
                'runxpcshelltests.py',
                'xpcshellcommandline.py',
            ],
            'dest': 'xpcshell',
        },
        {
            'source': STAGE,
            'base': '',
            'pattern': 'xpcshell/**',
        },
        {
            'source': buildconfig.topobjdir,
            'base': '',
            'pattern': 'mozinfo.json',
            'dest': 'xpcshell',
        },
        {
            'source': buildconfig.topobjdir,
            'base': 'build',
            'pattern': 'automation.py',
            'dest': 'xpcshell',
        },
    ],
}


if buildconfig.substs.get('MOZ_ASAN') and buildconfig.substs.get('CLANG_CL'):
    asan_dll = {
        'source': buildconfig.topobjdir,
        'base': 'dist/bin',
        'pattern': os.path.basename(buildconfig.substs['MOZ_CLANG_RT_ASAN_LIB_PATH']),
        'dest': 'bin'
    }
    ARCHIVE_FILES['common'].append(asan_dll)


# "common" is our catch all archive and it ignores things from other archives.
# Verify nothing sneaks into ARCHIVE_FILES without a corresponding exclusion
# rule in the "common" archive.
for k, v in ARCHIVE_FILES.items():
    # Skip mozharness because it isn't staged.
    if k in ('common', 'mozharness'):
        continue

    ignores = set(itertools.chain(*(e.get('ignore', [])
                                  for e in ARCHIVE_FILES['common'])))

    if not any(p.startswith('%s/' % k) for p in ignores):
        raise Exception('"common" ignore list probably should contain %s' % k)


def find_generated_harness_files():
    # TEST_HARNESS_FILES end up in an install manifest at
    # $topsrcdir/_build_manifests/install/_tests.
    manifest = InstallManifest(mozpath.join(buildconfig.topobjdir,
                                            '_build_manifests',
                                            'install',
                                            '_tests'))
    registry = FileRegistry()
    manifest.populate_registry(registry)
    # Conveniently, the generated files we care about will already
    # exist in the objdir, so we can identify relevant files if
    # they're an `ExistingFile` instance.
    return [mozpath.join('_tests', p) for p in registry.paths()
            if isinstance(registry[p], ExistingFile)]


def find_files(archive):
    extra_entries = []
    generated_harness_files = find_generated_harness_files()

    if archive == 'common':
        # Construct entries ensuring all our generated harness files are
        # packaged in the common tests zip.
        packaged_paths = set()
        for entry in OBJDIR_TEST_FILES.values():
            pat = mozpath.join(entry['base'], entry['pattern'])
            del entry['pattern']
            patterns = []
            for path in generated_harness_files:
                if mozpath.match(path, pat):
                    patterns.append(path[len(entry['base']) + 1:])
                    packaged_paths.add(path)
            if patterns:
                entry['patterns'] = patterns
                extra_entries.append(entry)
        entry = {
            'source': buildconfig.topobjdir,
            'base': '_tests',
            'patterns': [],
        }
        for path in set(generated_harness_files) - packaged_paths:
            entry['patterns'].append(path[len('_tests') + 1:])
        extra_entries.append(entry)

    for entry in ARCHIVE_FILES[archive] + extra_entries:
        source = entry['source']
        dest = entry.get('dest')
        base = entry.get('base', '')

        pattern = entry.get('pattern')
        patterns = entry.get('patterns', [])
        if pattern:
            patterns.append(pattern)

        manifest = entry.get('manifest')
        manifests = entry.get('manifests', [])
        if manifest:
            manifests.append(manifest)
        if manifests:
            dirs = find_manifest_dirs(buildconfig.topsrcdir, manifests)
            patterns.extend({'{}/**'.format(d) for d in dirs})

        ignore = list(entry.get('ignore', []))
        ignore.extend([
            '**/.flake8',
            '**/.mkdir.done',
            '**/*.pyc',
        ])

        if archive != 'common' and base.startswith('_tests'):
            # We may have generated_harness_files to exclude from this entry.
            for path in generated_harness_files:
                if path.startswith(base):
                    ignore.append(path[len(base) + 1:])

        common_kwargs = {
            'find_dotfiles': True,
            'ignore': ignore,
        }

        finder = FileFinder(os.path.join(source, base), **common_kwargs)

        for pattern in patterns:
            for p, f in finder.find(pattern):
                if dest:
                    p = mozpath.join(dest, p)
                yield p, f


def find_manifest_dirs(topsrcdir, manifests):
    """Routine to retrieve directories specified in a manifest, relative to topsrcdir.

    It does not recurse into manifests, as we currently have no need for that.
    """
    dirs = set()

    for p in manifests:
        p = os.path.join(topsrcdir, p)

        if p.endswith('.ini'):
            test_manifest = TestManifest()
            test_manifest.read(p)
            dirs |= set([os.path.dirname(m) for m in test_manifest.manifests()])

        elif p.endswith('.list'):
            m = ReftestManifest()
            m.load(p)
            dirs |= m.dirs

        else:
            raise Exception('"{}" is not a supported manifest format.'.format(
                os.path.splitext(p)[1]))

    dirs = {mozpath.normpath(d[len(topsrcdir):]).lstrip('/') for d in dirs}

    # Filter out children captured by parent directories because duplicates
    # will confuse things later on.
    def parents(p):
        while True:
            p = mozpath.dirname(p)
            if not p:
                break
            yield p

    seen = set()
    for d in sorted(dirs, key=len):
        if not any(p in seen for p in parents(d)):
            seen.add(d)

    return sorted(seen)


def main(argv):
    parser = argparse.ArgumentParser(
        description='Produce test archives')
    parser.add_argument('archive', help='Which archive to generate')
    parser.add_argument('outputfile', help='File to write output to')

    args = parser.parse_args(argv)

    out_file = args.outputfile
    if not out_file.endswith(('.tar.gz', '.zip')):
        raise Exception('expected tar.gz or zip output file')

    file_count = 0
    t_start = time.time()
    ensureParentDir(out_file)
    res = find_files(args.archive)
    with open(out_file, 'wb') as fh:
        # Experimentation revealed that level 5 is significantly faster and has
        # marginally larger sizes than higher values and is the sweet spot
        # for optimal compression. Read the detailed commit message that
        # introduced this for raw numbers.
        if out_file.endswith('.tar.gz'):
            files = dict(res)
            create_tar_gz_from_files(fh, files, compresslevel=5)
            file_count = len(files)
        elif out_file.endswith('.zip'):
            with JarWriter(fileobj=fh, optimize=False, compress_level=5) as writer:
                for p, f in res:
                    writer.add(p.encode('utf-8'), f.read(), mode=f.mode,
                               skip_duplicates=True)
                    file_count += 1
        else:
            raise Exception('unhandled file extension: %s' % out_file)

    duration = time.time() - t_start
    zip_size = os.path.getsize(args.outputfile)
    basename = os.path.basename(args.outputfile)
    print('Wrote %d files in %d bytes to %s in %.2fs' % (
          file_count, zip_size, basename, duration))


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
