# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import unicode_literals

import cPickle as pickle
import json
import os
import unittest

from mozpack.manifests import (
    InstallManifest,
)
from mozunit import main

from mozbuild.backend.recursivemake import (
    RecursiveMakeBackend,
    RecursiveMakeTraversal,
)
from mozbuild.frontend.emitter import TreeMetadataEmitter
from mozbuild.frontend.reader import BuildReader

from mozbuild.test.backend.common import BackendTester

import mozpack.path as mozpath


class TestRecursiveMakeTraversal(unittest.TestCase):
    def test_traversal(self):
        traversal = RecursiveMakeTraversal()
        traversal.add('', dirs=['A', 'B', 'C'])
        traversal.add('', dirs=['D'])
        traversal.add('A')
        traversal.add('B', dirs=['E', 'F'])
        traversal.add('C', dirs=['G', 'H'])
        traversal.add('D', dirs=['I', 'K'])
        traversal.add('D', dirs=['J', 'L'])
        traversal.add('E')
        traversal.add('F')
        traversal.add('G')
        traversal.add('H')
        traversal.add('I', dirs=['M', 'N'])
        traversal.add('J', dirs=['O', 'P'])
        traversal.add('K', dirs=['Q', 'R'])
        traversal.add('L', dirs=['S'])
        traversal.add('M')
        traversal.add('N', dirs=['T'])
        traversal.add('O')
        traversal.add('P', dirs=['U'])
        traversal.add('Q')
        traversal.add('R', dirs=['V'])
        traversal.add('S', dirs=['W'])
        traversal.add('T')
        traversal.add('U')
        traversal.add('V')
        traversal.add('W', dirs=['X'])
        traversal.add('X')

        parallels = set(('G', 'H', 'I', 'J', 'O', 'P', 'Q', 'R', 'U'))
        def filter(current, subdirs):
            return (current, [d for d in subdirs.dirs if d in parallels],
                [d for d in subdirs.dirs if d not in parallels])

        start, deps = traversal.compute_dependencies(filter)
        self.assertEqual(start, ('X',))
        self.maxDiff = None
        self.assertEqual(deps, {
            'A': ('',),
            'B': ('A',),
            'C': ('F',),
            'D': ('G', 'H'),
            'E': ('B',),
            'F': ('E',),
            'G': ('C',),
            'H': ('C',),
            'I': ('D',),
            'J': ('D',),
            'K': ('T', 'O', 'U'),
            'L': ('Q', 'V'),
            'M': ('I',),
            'N': ('M',),
            'O': ('J',),
            'P': ('J',),
            'Q': ('K',),
            'R': ('K',),
            'S': ('L',),
            'T': ('N',),
            'U': ('P',),
            'V': ('R',),
            'W': ('S',),
            'X': ('W',),
        })

        self.assertEqual(list(traversal.traverse('', filter)),
                         ['', 'A', 'B', 'E', 'F', 'C', 'G', 'H', 'D', 'I',
                         'M', 'N', 'T', 'J', 'O', 'P', 'U', 'K', 'Q', 'R',
                         'V', 'L', 'S', 'W', 'X'])

        self.assertEqual(list(traversal.traverse('C', filter)),
                         ['C', 'G', 'H'])

    def test_traversal_2(self):
        traversal = RecursiveMakeTraversal()
        traversal.add('', dirs=['A', 'B', 'C'])
        traversal.add('A')
        traversal.add('B', dirs=['D', 'E', 'F'])
        traversal.add('C', dirs=['G', 'H', 'I'])
        traversal.add('D')
        traversal.add('E')
        traversal.add('F')
        traversal.add('G')
        traversal.add('H')
        traversal.add('I')

        start, deps = traversal.compute_dependencies()
        self.assertEqual(start, ('I',))
        self.assertEqual(deps, {
            'A': ('',),
            'B': ('A',),
            'C': ('F',),
            'D': ('B',),
            'E': ('D',),
            'F': ('E',),
            'G': ('C',),
            'H': ('G',),
            'I': ('H',),
        })

    def test_traversal_filter(self):
        traversal = RecursiveMakeTraversal()
        traversal.add('', dirs=['A', 'B', 'C'])
        traversal.add('A')
        traversal.add('B', dirs=['D', 'E', 'F'])
        traversal.add('C', dirs=['G', 'H', 'I'])
        traversal.add('D')
        traversal.add('E')
        traversal.add('F')
        traversal.add('G')
        traversal.add('H')
        traversal.add('I')

        def filter(current, subdirs):
            if current == 'B':
                current = None
            return current, [], subdirs.dirs

        start, deps = traversal.compute_dependencies(filter)
        self.assertEqual(start, ('I',))
        self.assertEqual(deps, {
            'A': ('',),
            'C': ('F',),
            'D': ('A',),
            'E': ('D',),
            'F': ('E',),
            'G': ('C',),
            'H': ('G',),
            'I': ('H',),
        })

class TestRecursiveMakeBackend(BackendTester):
    def test_basic(self):
        """Ensure the RecursiveMakeBackend works without error."""
        env = self._consume('stub0', RecursiveMakeBackend)
        self.assertTrue(os.path.exists(mozpath.join(env.topobjdir,
            'backend.RecursiveMakeBackend')))
        self.assertTrue(os.path.exists(mozpath.join(env.topobjdir,
            'backend.RecursiveMakeBackend.in')))

    def test_output_files(self):
        """Ensure proper files are generated."""
        env = self._consume('stub0', RecursiveMakeBackend)

        expected = ['', 'dir1', 'dir2']

        for d in expected:
            out_makefile = mozpath.join(env.topobjdir, d, 'Makefile')
            out_backend = mozpath.join(env.topobjdir, d, 'backend.mk')

            self.assertTrue(os.path.exists(out_makefile))
            self.assertTrue(os.path.exists(out_backend))

    def test_makefile_conversion(self):
        """Ensure Makefile.in is converted properly."""
        env = self._consume('stub0', RecursiveMakeBackend)

        p = mozpath.join(env.topobjdir, 'Makefile')

        lines = [l.strip() for l in open(p, 'rt').readlines()[1:] if not l.startswith('#')]
        self.assertEqual(lines, [
            'DEPTH := .',
            'topobjdir := %s' % env.topobjdir,
            'topsrcdir := %s' % env.topsrcdir,
            'srcdir := %s' % env.topsrcdir,
            'VPATH := %s' % env.topsrcdir,
            'relativesrcdir := .',
            'include $(DEPTH)/config/autoconf.mk',
            '',
            'FOO := foo',
            '',
            'include $(topsrcdir)/config/recurse.mk',
        ])

    def test_missing_makefile_in(self):
        """Ensure missing Makefile.in results in Makefile creation."""
        env = self._consume('stub0', RecursiveMakeBackend)

        p = mozpath.join(env.topobjdir, 'dir2', 'Makefile')
        self.assertTrue(os.path.exists(p))

        lines = [l.strip() for l in open(p, 'rt').readlines()]
        self.assertEqual(len(lines), 10)

        self.assertTrue(lines[0].startswith('# THIS FILE WAS AUTOMATICALLY'))

    def test_backend_mk(self):
        """Ensure backend.mk file is written out properly."""
        env = self._consume('stub0', RecursiveMakeBackend)

        p = mozpath.join(env.topobjdir, 'backend.mk')

        lines = [l.strip() for l in open(p, 'rt').readlines()[2:]]
        self.assertEqual(lines, [
            'DIRS := dir1 dir2',
        ])

        # Make env.substs writable to add ENABLE_TESTS
        env.substs = dict(env.substs)
        env.substs['ENABLE_TESTS'] = '1'
        self._consume('stub0', RecursiveMakeBackend, env=env)
        p = mozpath.join(env.topobjdir, 'backend.mk')

        lines = [l.strip() for l in open(p, 'rt').readlines()[2:]]
        self.assertEqual(lines, [
            'DIRS := dir1 dir2 dir3',
        ])

    def test_mtime_no_change(self):
        """Ensure mtime is not updated if file content does not change."""

        env = self._consume('stub0', RecursiveMakeBackend)

        makefile_path = mozpath.join(env.topobjdir, 'Makefile')
        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        makefile_mtime = os.path.getmtime(makefile_path)
        backend_mtime = os.path.getmtime(backend_path)

        reader = BuildReader(env)
        emitter = TreeMetadataEmitter(env)
        backend = RecursiveMakeBackend(env)
        backend.consume(emitter.emit(reader.read_topsrcdir()))

        self.assertEqual(os.path.getmtime(makefile_path), makefile_mtime)
        self.assertEqual(os.path.getmtime(backend_path), backend_mtime)

    def test_substitute_config_files(self):
        """Ensure substituted config files are produced."""
        env = self._consume('substitute_config_files', RecursiveMakeBackend)

        p = mozpath.join(env.topobjdir, 'foo')
        self.assertTrue(os.path.exists(p))
        lines = [l.strip() for l in open(p, 'rt').readlines()]
        self.assertEqual(lines, [
            'TEST = foo',
        ])

    def test_install_substitute_config_files(self):
        """Ensure we recurse into the dirs that install substituted config files."""
        env = self._consume('install_substitute_config_files', RecursiveMakeBackend)

        root_deps_path = mozpath.join(env.topobjdir, 'root-deps.mk')
        lines = [l.strip() for l in open(root_deps_path, 'rt').readlines()]

        # Make sure we actually recurse into the sub directory during export to
        # install the subst file.
        self.assertTrue(any(l == 'recurse_export: sub/export' for l in lines))

    def test_variable_passthru(self):
        """Ensure variable passthru is written out correctly."""
        env = self._consume('variable_passthru', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        expected = {
            'ALLOW_COMPILER_WARNINGS': [
                'ALLOW_COMPILER_WARNINGS := 1',
            ],
            'DISABLE_STL_WRAPPING': [
                'DISABLE_STL_WRAPPING := 1',
            ],
            'VISIBILITY_FLAGS': [
                'VISIBILITY_FLAGS :=',
            ],
            'RCFILE': [
                'RCFILE := foo.rc',
            ],
            'RESFILE': [
                'RESFILE := bar.res',
            ],
            'RCINCLUDE': [
                'RCINCLUDE := bar.rc',
            ],
            'DEFFILE': [
                'DEFFILE := baz.def',
            ],
            'MOZBUILD_CFLAGS': [
                'MOZBUILD_CFLAGS += -fno-exceptions',
                'MOZBUILD_CFLAGS += -w',
            ],
            'MOZBUILD_CXXFLAGS': [
                'MOZBUILD_CXXFLAGS += -fcxx-exceptions',
                "MOZBUILD_CXXFLAGS += '-option with spaces'",
            ],
            'MOZBUILD_LDFLAGS': [
                "MOZBUILD_LDFLAGS += '-ld flag with spaces'",
                'MOZBUILD_LDFLAGS += -x',
                'MOZBUILD_LDFLAGS += -DELAYLOAD:foo.dll',
                'MOZBUILD_LDFLAGS += -DELAYLOAD:bar.dll',
            ],
            'MOZBUILD_HOST_CFLAGS': [
                'MOZBUILD_HOST_CFLAGS += -funroll-loops',
                'MOZBUILD_HOST_CFLAGS += -wall',
            ],
            'MOZBUILD_HOST_CXXFLAGS': [
                'MOZBUILD_HOST_CXXFLAGS += -funroll-loops-harder',
                'MOZBUILD_HOST_CXXFLAGS += -wall-day-everyday',
            ],
            'WIN32_EXE_LDFLAGS': [
                'WIN32_EXE_LDFLAGS += -subsystem:console',
            ],
        }

        for var, val in expected.items():
            # print("test_variable_passthru[%s]" % (var))
            found = [str for str in lines if str.startswith(var)]
            self.assertEqual(found, val)

    def test_sources(self):
        """Ensure SOURCES and HOST_SOURCES are handled properly."""
        env = self._consume('sources', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        expected = {
            'ASFILES': [
                'ASFILES += bar.s',
                'ASFILES += foo.asm',
            ],
            'CMMSRCS': [
                'CMMSRCS += bar.mm',
                'CMMSRCS += foo.mm',
            ],
            'CSRCS': [
                'CSRCS += bar.c',
                'CSRCS += foo.c',
            ],
            'HOST_CPPSRCS': [
                'HOST_CPPSRCS += bar.cpp',
                'HOST_CPPSRCS += foo.cpp',
            ],
            'HOST_CSRCS': [
                'HOST_CSRCS += bar.c',
                'HOST_CSRCS += foo.c',
            ],
            'SSRCS': [
                'SSRCS += baz.S',
                'SSRCS += foo.S',
            ],
        }

        for var, val in expected.items():
            found = [str for str in lines if str.startswith(var)]
            self.assertEqual(found, val)

    def test_exports(self):
        """Ensure EXPORTS is handled properly."""
        env = self._consume('exports', RecursiveMakeBackend)

        # EXPORTS files should appear in the dist_include install manifest.
        m = InstallManifest(path=mozpath.join(env.topobjdir,
            '_build_manifests', 'install', 'dist_include'))
        self.assertEqual(len(m), 7)
        self.assertIn('foo.h', m)
        self.assertIn('mozilla/mozilla1.h', m)
        self.assertIn('mozilla/dom/dom2.h', m)

    def test_generated_files(self):
        """Ensure GENERATED_FILES is handled properly."""
        env = self._consume('generated-files', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        expected = [
            'export:: bar.c',
            'GARBAGE += bar.c',
            'EXTRA_MDDEPEND_FILES += bar.c.pp',
            'bar.c: %s/generate-bar.py' % env.topsrcdir,
            '$(REPORT_BUILD)',
            '$(call py_action,file_generate,%s/generate-bar.py baz bar.c $(MDDEPDIR)/bar.c.pp)' % env.topsrcdir,
            '',
            'export:: foo.c',
            'GARBAGE += foo.c',
            'EXTRA_MDDEPEND_FILES += foo.c.pp',
            'foo.c: %s/generate-foo.py $(srcdir)/foo-data' % (env.topsrcdir),
            '$(REPORT_BUILD)',
            '$(call py_action,file_generate,%s/generate-foo.py main foo.c $(MDDEPDIR)/foo.c.pp $(srcdir)/foo-data)' % (env.topsrcdir),
            '',
            'export:: quux.c',
            'GARBAGE += quux.c',
            'EXTRA_MDDEPEND_FILES += quux.c.pp',
        ]

        self.maxDiff = None
        self.assertEqual(lines, expected)

    def test_exports_generated(self):
        """Ensure EXPORTS that are listed in GENERATED_FILES
        are handled properly."""
        env = self._consume('exports-generated', RecursiveMakeBackend)

        # EXPORTS files should appear in the dist_include install manifest.
        m = InstallManifest(path=mozpath.join(env.topobjdir,
            '_build_manifests', 'install', 'dist_include'))
        self.assertEqual(len(m), 8)
        self.assertIn('foo.h', m)
        self.assertIn('mozilla/mozilla1.h', m)
        self.assertIn('mozilla/dom/dom1.h', m)
        self.assertIn('gfx/gfx.h', m)
        self.assertIn('bar.h', m)
        self.assertIn('mozilla/mozilla2.h', m)
        self.assertIn('mozilla/dom/dom2.h', m)
        self.assertIn('mozilla/dom/dom3.h', m)
        # EXPORTS files that are also GENERATED_FILES should be handled as
        # INSTALL_TARGETS.
        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]
        expected = [
            'export:: bar.h',
            'GARBAGE += bar.h',
            'EXTRA_MDDEPEND_FILES += bar.h.pp',
            'export:: mozilla2.h',
            'GARBAGE += mozilla2.h',
            'EXTRA_MDDEPEND_FILES += mozilla2.h.pp',
            'export:: dom2.h',
            'GARBAGE += dom2.h',
            'EXTRA_MDDEPEND_FILES += dom2.h.pp',
            'export:: dom3.h',
            'GARBAGE += dom3.h',
            'EXTRA_MDDEPEND_FILES += dom3.h.pp',
            'dist_include_FILES += bar.h',
            'dist_include_DEST := $(DEPTH)/dist/include/',
            'dist_include_TARGET := export',
            'INSTALL_TARGETS += dist_include',
            'dist_include_mozilla_FILES += mozilla2.h',
            'dist_include_mozilla_DEST := $(DEPTH)/dist/include/mozilla',
            'dist_include_mozilla_TARGET := export',
            'INSTALL_TARGETS += dist_include_mozilla',
            'dist_include_mozilla_dom_FILES += dom2.h',
            'dist_include_mozilla_dom_FILES += dom3.h',
            'dist_include_mozilla_dom_DEST := $(DEPTH)/dist/include/mozilla/dom',
            'dist_include_mozilla_dom_TARGET := export',
            'INSTALL_TARGETS += dist_include_mozilla_dom',
        ]
        self.maxDiff = None
        self.assertEqual(lines, expected)

    def test_resources(self):
        """Ensure RESOURCE_FILES is handled properly."""
        env = self._consume('resources', RecursiveMakeBackend)

        # RESOURCE_FILES should appear in the dist_bin install manifest.
        m = InstallManifest(path=os.path.join(env.topobjdir,
            '_build_manifests', 'install', 'dist_bin'))
        self.assertEqual(len(m), 10)
        self.assertIn('res/foo.res', m)
        self.assertIn('res/fonts/font1.ttf', m)
        self.assertIn('res/fonts/desktop/desktop2.ttf', m)

        self.assertIn('res/bar.res.in', m)
        self.assertIn('res/tests/test.manifest', m)
        self.assertIn('res/tests/extra.manifest', m)

    def test_branding_files(self):
        """Ensure BRANDING_FILES is handled properly."""
        env = self._consume('branding-files', RecursiveMakeBackend)

        #BRANDING_FILES should appear in the dist_branding install manifest.
        m = InstallManifest(path=os.path.join(env.topobjdir,
            '_build_manifests', 'install', 'dist_branding'))
        self.assertEqual(len(m), 3)
        self.assertIn('bar.ico', m)
        self.assertIn('quux.png', m)
        self.assertIn('icons/foo.ico', m)

    def test_sdk_files(self):
        """Ensure SDK_FILES is handled properly."""
        env = self._consume('sdk-files', RecursiveMakeBackend)

        #SDK_FILES should appear in the dist_sdk install manifest.
        m = InstallManifest(path=os.path.join(env.topobjdir,
            '_build_manifests', 'install', 'dist_sdk'))
        self.assertEqual(len(m), 3)
        self.assertIn('bar.ico', m)
        self.assertIn('quux.png', m)
        self.assertIn('icons/foo.ico', m)

    def test_test_manifests_files_written(self):
        """Ensure test manifests get turned into files."""
        env = self._consume('test-manifests-written', RecursiveMakeBackend)

        tests_dir = mozpath.join(env.topobjdir, '_tests')
        m_master = mozpath.join(tests_dir, 'testing', 'mochitest', 'tests', 'mochitest.ini')
        x_master = mozpath.join(tests_dir, 'xpcshell', 'xpcshell.ini')
        self.assertTrue(os.path.exists(m_master))
        self.assertTrue(os.path.exists(x_master))

        lines = [l.strip() for l in open(x_master, 'rt').readlines()]
        self.assertEqual(lines, [
            '; THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT MODIFY BY HAND.',
            '',
            '[include:dir1/xpcshell.ini]',
            '[include:xpcshell.ini]',
        ])

        all_tests_path = mozpath.join(env.topobjdir, 'all-tests.pkl')
        self.assertTrue(os.path.exists(all_tests_path))

        with open(all_tests_path, 'rb') as fh:
            o = pickle.load(fh)

            self.assertIn('xpcshell.js', o)
            self.assertIn('dir1/test_bar.js', o)

            self.assertEqual(len(o['xpcshell.js']), 1)

    def test_test_manifest_pattern_matches_recorded(self):
        """Pattern matches in test manifests' support-files should be recorded."""
        env = self._consume('test-manifests-written', RecursiveMakeBackend)
        m = InstallManifest(path=mozpath.join(env.topobjdir,
            '_build_manifests', 'install', '_test_files'))

        # This is not the most robust test in the world, but it gets the job
        # done.
        entries = [e for e in m._dests.keys() if '**' in e]
        self.assertEqual(len(entries), 1)
        self.assertIn('support/**', entries[0])

    def test_test_manifest_deffered_installs_written(self):
        """Shared support files are written to their own data file by the backend."""
        env = self._consume('test-manifest-shared-support', RecursiveMakeBackend)
        all_tests_path = mozpath.join(env.topobjdir, 'all-tests.pkl')
        self.assertTrue(os.path.exists(all_tests_path))
        test_installs_path = mozpath.join(env.topobjdir, 'test-installs.pkl')

        with open(test_installs_path, 'r') as fh:
            test_installs = pickle.load(fh)

        self.assertEqual(set(test_installs.keys()),
                         set(['child/test_sub.js',
                              'child/data/**',
                              'child/another-file.sjs']))
        for key in test_installs.keys():
            self.assertIn(key, test_installs)

        test_files_manifest = mozpath.join(env.topobjdir,
                                           '_build_manifests',
                                           'install',
                                           '_test_files')

        # First, read the generated for ini manifest contents.
        m = InstallManifest(path=test_files_manifest)

        # Then, synthesize one from the test-installs.pkl file. This should
        # allow us to re-create a subset of the above.
        synthesized_manifest = InstallManifest()
        for item, installs in test_installs.items():
            for install_info in installs:
                if len(install_info) == 3:
                    synthesized_manifest.add_pattern_symlink(*install_info)
                if len(install_info) == 2:
                    synthesized_manifest.add_symlink(*install_info)

        self.assertEqual(len(synthesized_manifest), 3)
        for item, info in synthesized_manifest._dests.items():
            self.assertIn(item, m)
            self.assertEqual(info, m._dests[item])

    def test_xpidl_generation(self):
        """Ensure xpidl files and directories are written out."""
        env = self._consume('xpidl', RecursiveMakeBackend)

        # Install manifests should contain entries.
        install_dir = mozpath.join(env.topobjdir, '_build_manifests',
            'install')
        self.assertTrue(os.path.isfile(mozpath.join(install_dir, 'dist_idl')))
        self.assertTrue(os.path.isfile(mozpath.join(install_dir, 'xpidl')))

        m = InstallManifest(path=mozpath.join(install_dir, 'dist_idl'))
        self.assertEqual(len(m), 2)
        self.assertIn('bar.idl', m)
        self.assertIn('foo.idl', m)

        m = InstallManifest(path=mozpath.join(install_dir, 'xpidl'))
        self.assertIn('.deps/my_module.pp', m)

        m = InstallManifest(path=os.path.join(install_dir, 'dist_bin'))
        self.assertIn('components/my_module.xpt', m)
        self.assertIn('components/interfaces.manifest', m)

        m = InstallManifest(path=mozpath.join(install_dir, 'dist_include'))
        self.assertIn('foo.h', m)

        p = mozpath.join(env.topobjdir, 'config/makefiles/xpidl')
        self.assertTrue(os.path.isdir(p))

        self.assertTrue(os.path.isfile(mozpath.join(p, 'Makefile')))

    def test_old_install_manifest_deleted(self):
        # Simulate an install manifest from a previous backend version. Ensure
        # it is deleted.
        env = self._get_environment('stub0')
        purge_dir = mozpath.join(env.topobjdir, '_build_manifests', 'install')
        manifest_path = mozpath.join(purge_dir, 'old_manifest')
        os.makedirs(purge_dir)
        m = InstallManifest()
        m.write(path=manifest_path)
        with open(mozpath.join(
                env.topobjdir, 'backend.RecursiveMakeBackend'), 'w') as f:
            f.write('%s\n' % manifest_path)

        self.assertTrue(os.path.exists(manifest_path))
        self._consume('stub0', RecursiveMakeBackend, env)
        self.assertFalse(os.path.exists(manifest_path))

    def test_install_manifests_written(self):
        env, objs = self._emit('stub0')
        backend = RecursiveMakeBackend(env)

        m = InstallManifest()
        backend._install_manifests['testing'] = m
        m.add_symlink(__file__, 'self')
        backend.consume(objs)

        man_dir = mozpath.join(env.topobjdir, '_build_manifests', 'install')
        self.assertTrue(os.path.isdir(man_dir))

        expected = ['testing']
        for e in expected:
            full = mozpath.join(man_dir, e)
            self.assertTrue(os.path.exists(full))

            m2 = InstallManifest(path=full)
            self.assertEqual(m, m2)

    def test_ipdl_sources(self):
        """Test that IPDL_SOURCES are written to ipdlsrcs.mk correctly."""
        env = self._consume('ipdl_sources', RecursiveMakeBackend)

        manifest_path = mozpath.join(env.topobjdir,
            'ipc', 'ipdl', 'ipdlsrcs.mk')
        lines = [l.strip() for l in open(manifest_path, 'rt').readlines()]

        # Handle Windows paths correctly
        topsrcdir = env.topsrcdir.replace(os.sep, '/')

        expected = [
            "ALL_IPDLSRCS := %s/bar/bar.ipdl %s/bar/bar2.ipdlh %s/foo/foo.ipdl %s/foo/foo2.ipdlh" % tuple([topsrcdir] * 4),
            "CPPSRCS := UnifiedProtocols0.cpp",
            "IPDLDIRS := %s/bar %s/foo" % (topsrcdir, topsrcdir),
        ]

        found = [str for str in lines if str.startswith(('ALL_IPDLSRCS',
                                                         'CPPSRCS',
                                                         'IPDLDIRS'))]
        self.assertEqual(found, expected)

    def test_defines(self):
        """Test that DEFINES are written to backend.mk correctly."""
        env = self._consume('defines', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        var = 'DEFINES'
        defines = [val for val in lines if val.startswith(var)]

        expected = ['DEFINES += -DFOO \'-DBAZ="ab\'\\\'\'cd"\' -UQUX -DBAR=7 -DVALUE=xyz']
        self.assertEqual(defines, expected)

    def test_host_defines(self):
        """Test that HOST_DEFINES are written to backend.mk correctly."""
        env = self._consume('host-defines', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        var = 'HOST_DEFINES'
        defines = [val for val in lines if val.startswith(var)]

        expected = ['HOST_DEFINES += -DFOO \'-DBAZ="ab\'\\\'\'cd"\' -UQUX -DBAR=7 -DVALUE=xyz']
        self.assertEqual(defines, expected)

    def test_local_includes(self):
        """Test that LOCAL_INCLUDES are written to backend.mk correctly."""
        env = self._consume('local_includes', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        expected = [
            'LOCAL_INCLUDES += -I$(srcdir)/bar/baz',
            'LOCAL_INCLUDES += -I$(srcdir)/foo',
        ]

        found = [str for str in lines if str.startswith('LOCAL_INCLUDES')]
        self.assertEqual(found, expected)

    def test_generated_includes(self):
        """Test that GENERATED_INCLUDES are written to backend.mk correctly."""
        env = self._consume('generated_includes', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        topobjdir = env.topobjdir.replace('\\', '/')

        expected = [
            'LOCAL_INCLUDES += -I$(CURDIR)/bar/baz',
            'LOCAL_INCLUDES += -I$(CURDIR)/foo',
        ]

        found = [str for str in lines if str.startswith('LOCAL_INCLUDES')]
        self.assertEqual(found, expected)

    def test_final_target(self):
        """Test that FINAL_TARGET is written to backend.mk correctly."""
        env = self._consume('final_target', RecursiveMakeBackend)

        final_target_rule = "FINAL_TARGET = $(if $(XPI_NAME),$(DIST)/xpi-stage/$(XPI_NAME),$(DIST)/bin)$(DIST_SUBDIR:%=/%)"
        expected = dict()
        expected[env.topobjdir] = []
        expected[mozpath.join(env.topobjdir, 'both')] = [
            'XPI_NAME = mycrazyxpi',
            'DIST_SUBDIR = asubdir',
            final_target_rule
        ]
        expected[mozpath.join(env.topobjdir, 'dist-subdir')] = [
            'DIST_SUBDIR = asubdir',
            final_target_rule
        ]
        expected[mozpath.join(env.topobjdir, 'xpi-name')] = [
            'XPI_NAME = mycrazyxpi',
            final_target_rule
        ]
        expected[mozpath.join(env.topobjdir, 'final-target')] = [
            'FINAL_TARGET = $(DEPTH)/random-final-target'
        ]
        for key, expected_rules in expected.iteritems():
            backend_path = mozpath.join(key, 'backend.mk')
            lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]
            found = [str for str in lines if
                str.startswith('FINAL_TARGET') or str.startswith('XPI_NAME') or
                str.startswith('DIST_SUBDIR')]
            self.assertEqual(found, expected_rules)

    def test_final_target_pp_files(self):
        """Test that FINAL_TARGET_PP_FILES is written to backend.mk correctly."""
        env = self._consume('dist-files', RecursiveMakeBackend)

        backend_path = mozpath.join(env.topobjdir, 'backend.mk')
        lines = [l.strip() for l in open(backend_path, 'rt').readlines()[2:]]

        expected = [
            'DIST_FILES_0 += $(srcdir)/install.rdf',
            'DIST_FILES_0 += $(srcdir)/main.js',
            'DIST_FILES_0_PATH := $(DEPTH)/dist/bin/',
            'DIST_FILES_0_TARGET := misc',
            'PP_TARGETS += DIST_FILES_0',
        ]

        found = [str for str in lines if 'DIST_FILES' in str]
        self.assertEqual(found, expected)

    def test_config(self):
        """Test that CONFIGURE_SUBST_FILES are properly handled."""
        env = self._consume('test_config', RecursiveMakeBackend)

        self.assertEqual(
            open(os.path.join(env.topobjdir, 'file'), 'r').readlines(), [
                '#ifdef foo\n',
                'bar baz\n',
                '@bar@\n',
            ])

    def test_jar_manifests(self):
        env = self._consume('jar-manifests', RecursiveMakeBackend)

        with open(os.path.join(env.topobjdir, 'backend.mk'), 'rb') as fh:
            lines = fh.readlines()

        lines = [line.rstrip() for line in lines]

        self.assertIn('JAR_MANIFEST := %s/jar.mn' % env.topsrcdir, lines)

    def test_test_manifests_duplicate_support_files(self):
        """Ensure duplicate support-files in test manifests work."""
        env = self._consume('test-manifests-duplicate-support-files',
            RecursiveMakeBackend)

        p = os.path.join(env.topobjdir, '_build_manifests', 'install', '_test_files')
        m = InstallManifest(p)
        self.assertIn('testing/mochitest/tests/support-file.txt', m)

    def test_android_eclipse(self):
        env = self._consume('android_eclipse', RecursiveMakeBackend)

        with open(mozpath.join(env.topobjdir, 'backend.mk'), 'rb') as fh:
            lines = fh.readlines()

        lines = [line.rstrip() for line in lines]

        # Dependencies first.
        self.assertIn('ANDROID_ECLIPSE_PROJECT_main1: target1 target2', lines)
        self.assertIn('ANDROID_ECLIPSE_PROJECT_main4: target3 target4', lines)

        command_template = '\t$(call py_action,process_install_manifest,' + \
                           '--no-remove --no-remove-all-directory-symlinks ' + \
                           '--no-remove-empty-directories %s %s.manifest)'
        # Commands second.
        for project_name in ['main1', 'main2', 'library1', 'library2']:
            stem = '%s/android_eclipse/%s' % (env.topobjdir, project_name)
            self.assertIn(command_template % (stem, stem), lines)

        # Projects declared in subdirectories.
        with open(mozpath.join(env.topobjdir, 'subdir', 'backend.mk'), 'rb') as fh:
            lines = fh.readlines()

        lines = [line.rstrip() for line in lines]

        self.assertIn('ANDROID_ECLIPSE_PROJECT_submain: subtarget1 subtarget2', lines)

        for project_name in ['submain', 'sublibrary']:
            # Destination and install manifest are relative to topobjdir.
            stem = '%s/android_eclipse/%s' % (env.topobjdir, project_name)
            self.assertIn(command_template % (stem, stem), lines)

    def test_install_manifests_package_tests(self):
        """Ensure test suites honor package_tests=False."""
        env = self._consume('test-manifests-package-tests', RecursiveMakeBackend)

        all_tests_path = mozpath.join(env.topobjdir, 'all-tests.pkl')
        self.assertTrue(os.path.exists(all_tests_path))

        with open(all_tests_path, 'rb') as fh:
            o = pickle.load(fh)
            self.assertIn('mochitest.js', o)
            self.assertIn('not_packaged.java', o)

        man_dir = mozpath.join(env.topobjdir, '_build_manifests', 'install')
        self.assertTrue(os.path.isdir(man_dir))

        full = mozpath.join(man_dir, '_test_files')
        self.assertTrue(os.path.exists(full))

        m = InstallManifest(path=full)

        # Only mochitest.js should be in the install manifest.
        self.assertTrue('testing/mochitest/tests/mochitest.js' in m)

        # The path is odd here because we do not normalize at test manifest
        # processing time.  This is a fragile test because there's currently no
        # way to iterate the manifest.
        self.assertFalse('instrumentation/./not_packaged.java' in m)

    def test_binary_components(self):
        """Ensure binary components are correctly handled."""
        env = self._consume('binary-components', RecursiveMakeBackend)

        with open(mozpath.join(env.topobjdir, 'foo', 'backend.mk')) as fh:
            lines = fh.readlines()[2:]

        self.assertEqual(lines, [
            'misc::\n',
            '\t$(call py_action,buildlist,$(DEPTH)/dist/bin/chrome.manifest '
            + "'manifest components/components.manifest')\n",
            '\t$(call py_action,buildlist,'
            + '$(DEPTH)/dist/bin/components/components.manifest '
            + "'binary-component foo')\n",
            'LIBRARY_NAME := foo\n',
            'FORCE_SHARED_LIB := 1\n',
            'IMPORT_LIBRARY := foo\n',
            'SHARED_LIBRARY := foo\n',
            'IS_COMPONENT := 1\n',
            'DSO_SONAME := foo\n',
            'LIB_IS_C_ONLY := 1\n',
        ])

        with open(mozpath.join(env.topobjdir, 'bar', 'backend.mk')) as fh:
            lines = fh.readlines()[2:]

        self.assertEqual(lines, [
            'LIBRARY_NAME := bar\n',
            'FORCE_SHARED_LIB := 1\n',
            'IMPORT_LIBRARY := bar\n',
            'SHARED_LIBRARY := bar\n',
            'IS_COMPONENT := 1\n',
            'DSO_SONAME := bar\n',
            'LIB_IS_C_ONLY := 1\n',
        ])

        self.assertTrue(os.path.exists(mozpath.join(env.topobjdir, 'binaries.json')))
        with open(mozpath.join(env.topobjdir, 'binaries.json'), 'rb') as fh:
            binaries = json.load(fh)

        self.assertEqual(binaries, {
            'programs': [],
            'shared_libraries': [
                {
                    'basename': 'foo',
                    'import_name': 'foo',
                    'install_target': 'dist/bin',
                    'lib_name': 'foo',
                    'relobjdir': 'foo',
                    'soname': 'foo',
                },
                {
                    'basename': 'bar',
                    'import_name': 'bar',
                    'install_target': 'dist/bin',
                    'lib_name': 'bar',
                    'relobjdir': 'bar',
                    'soname': 'bar',
                }
            ],
        })


if __name__ == '__main__':
    main()
