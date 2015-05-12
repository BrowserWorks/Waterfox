"""Easy install Tests
"""
from __future__ import absolute_import

import sys
import os
import shutil
import tempfile
import site
import contextlib
import tarfile
import logging
import itertools

import pytest
import mock

from setuptools import sandbox
from setuptools.compat import StringIO, BytesIO, urlparse
from setuptools.sandbox import run_setup, SandboxViolation
from setuptools.command.easy_install import (
    easy_install, fix_jython_executable, get_script_args, nt_quote_arg)
from setuptools.command.easy_install import PthDistributions
from setuptools.command import easy_install as easy_install_pkg
from setuptools.dist import Distribution
from pkg_resources import working_set, VersionConflict
from pkg_resources import Distribution as PRDistribution
import setuptools.tests.server
import pkg_resources

from .py26compat import tarfile_open
from . import contexts
from .textwrap import DALS


class FakeDist(object):
    def get_entry_map(self, group):
        if group != 'console_scripts':
            return {}
        return {'name': 'ep'}

    def as_requirement(self):
        return 'spec'

WANTED = DALS("""
    #!%s
    # EASY-INSTALL-ENTRY-SCRIPT: 'spec','console_scripts','name'
    __requires__ = 'spec'
    import sys
    from pkg_resources import load_entry_point

    if __name__ == '__main__':
        sys.exit(
            load_entry_point('spec', 'console_scripts', 'name')()
        )
    """) % nt_quote_arg(fix_jython_executable(sys.executable, ""))

SETUP_PY = DALS("""
    from setuptools import setup

    setup(name='foo')
    """)

class TestEasyInstallTest:

    def test_install_site_py(self):
        dist = Distribution()
        cmd = easy_install(dist)
        cmd.sitepy_installed = False
        cmd.install_dir = tempfile.mkdtemp()
        try:
            cmd.install_site_py()
            sitepy = os.path.join(cmd.install_dir, 'site.py')
            assert os.path.exists(sitepy)
        finally:
            shutil.rmtree(cmd.install_dir)

    def test_get_script_args(self):
        dist = FakeDist()

        args = next(get_script_args(dist))
        name, script = itertools.islice(args, 2)

        assert script == WANTED

    def test_no_find_links(self):
        # new option '--no-find-links', that blocks find-links added at
        # the project level
        dist = Distribution()
        cmd = easy_install(dist)
        cmd.check_pth_processing = lambda: True
        cmd.no_find_links = True
        cmd.find_links = ['link1', 'link2']
        cmd.install_dir = os.path.join(tempfile.mkdtemp(), 'ok')
        cmd.args = ['ok']
        cmd.ensure_finalized()
        assert cmd.package_index.scanned_urls == {}

        # let's try without it (default behavior)
        cmd = easy_install(dist)
        cmd.check_pth_processing = lambda: True
        cmd.find_links = ['link1', 'link2']
        cmd.install_dir = os.path.join(tempfile.mkdtemp(), 'ok')
        cmd.args = ['ok']
        cmd.ensure_finalized()
        keys = sorted(cmd.package_index.scanned_urls.keys())
        assert keys == ['link1', 'link2']


class TestPTHFileWriter:
    def test_add_from_cwd_site_sets_dirty(self):
        '''a pth file manager should set dirty
        if a distribution is in site but also the cwd
        '''
        pth = PthDistributions('does-not_exist', [os.getcwd()])
        assert not pth.dirty
        pth.add(PRDistribution(os.getcwd()))
        assert pth.dirty

    def test_add_from_site_is_ignored(self):
        location = '/test/location/does-not-have-to-exist'
        # PthDistributions expects all locations to be normalized
        location = pkg_resources.normalize_path(location)
        pth = PthDistributions('does-not_exist', [location, ])
        assert not pth.dirty
        pth.add(PRDistribution(location))
        assert not pth.dirty


@pytest.yield_fixture
def setup_context(tmpdir):
    with (tmpdir/'setup.py').open('w') as f:
        f.write(SETUP_PY)
    with tmpdir.as_cwd():
        yield tmpdir


@pytest.mark.usefixtures("user_override")
@pytest.mark.usefixtures("setup_context")
class TestUserInstallTest:

    @mock.patch('setuptools.command.easy_install.__file__', None)
    def test_user_install_implied(self):
        easy_install_pkg.__file__ = site.USER_SITE
        site.ENABLE_USER_SITE = True # disabled sometimes
        #XXX: replace with something meaningfull
        dist = Distribution()
        dist.script_name = 'setup.py'
        cmd = easy_install(dist)
        cmd.args = ['py']
        cmd.ensure_finalized()
        assert cmd.user, 'user should be implied'

    def test_multiproc_atexit(self):
        try:
            __import__('multiprocessing')
        except ImportError:
            # skip the test if multiprocessing is not available
            return

        log = logging.getLogger('test_easy_install')
        logging.basicConfig(level=logging.INFO, stream=sys.stderr)
        log.info('this should not break')

    def test_user_install_not_implied_without_usersite_enabled(self):
        site.ENABLE_USER_SITE = False # usually enabled
        #XXX: replace with something meaningfull
        dist = Distribution()
        dist.script_name = 'setup.py'
        cmd = easy_install(dist)
        cmd.args = ['py']
        cmd.initialize_options()
        assert not cmd.user, 'NOT user should be implied'

    def test_local_index(self):
        # make sure the local index is used
        # when easy_install looks for installed
        # packages
        new_location = tempfile.mkdtemp()
        target = tempfile.mkdtemp()
        egg_file = os.path.join(new_location, 'foo-1.0.egg-info')
        with open(egg_file, 'w') as f:
            f.write('Name: foo\n')

        sys.path.append(target)
        old_ppath = os.environ.get('PYTHONPATH')
        os.environ['PYTHONPATH'] = os.path.pathsep.join(sys.path)
        try:
            dist = Distribution()
            dist.script_name = 'setup.py'
            cmd = easy_install(dist)
            cmd.install_dir = target
            cmd.args = ['foo']
            cmd.ensure_finalized()
            cmd.local_index.scan([new_location])
            res = cmd.easy_install('foo')
            actual = os.path.normcase(os.path.realpath(res.location))
            expected = os.path.normcase(os.path.realpath(new_location))
            assert actual == expected
        finally:
            sys.path.remove(target)
            for basedir in [new_location, target, ]:
                if not os.path.exists(basedir) or not os.path.isdir(basedir):
                    continue
                try:
                    shutil.rmtree(basedir)
                except:
                    pass
            if old_ppath is not None:
                os.environ['PYTHONPATH'] = old_ppath
            else:
                del os.environ['PYTHONPATH']

    @contextlib.contextmanager
    def user_install_setup_context(self, *args, **kwargs):
        """
        Wrap sandbox.setup_context to patch easy_install in that context to
        appear as user-installed.
        """
        with self.orig_context(*args, **kwargs):
            import setuptools.command.easy_install as ei
            ei.__file__ = site.USER_SITE
            yield

    def patched_setup_context(self):
        self.orig_context = sandbox.setup_context

        return mock.patch(
            'setuptools.sandbox.setup_context',
            self.user_install_setup_context,
        )

    def test_setup_requires(self):
        """Regression test for Distribute issue #318

        Ensure that a package with setup_requires can be installed when
        setuptools is installed in the user site-packages without causing a
        SandboxViolation.
        """

        test_pkg = create_setup_requires_package(os.getcwd())
        test_setup_py = os.path.join(test_pkg, 'setup.py')

        try:
            with contexts.quiet():
                with self.patched_setup_context():
                    run_setup(test_setup_py, ['install'])
        except SandboxViolation:
            self.fail('Installation caused SandboxViolation')
        except IndexError:
            # Test fails in some cases due to bugs in Python
            # See https://bitbucket.org/pypa/setuptools/issue/201
            pass


@pytest.yield_fixture
def distutils_package():
    distutils_setup_py = SETUP_PY.replace(
        'from setuptools import setup',
        'from distutils.core import setup',
    )
    with contexts.tempdir(cd=os.chdir):
        with open('setup.py', 'w') as f:
            f.write(distutils_setup_py)
        yield


class TestDistutilsPackage:
    def test_bdist_egg_available_on_distutils_pkg(self, distutils_package):
        run_setup('setup.py', ['bdist_egg'])


class TestSetupRequires:

    def test_setup_requires_honors_fetch_params(self):
        """
        When easy_install installs a source distribution which specifies
        setup_requires, it should honor the fetch parameters (such as
        allow-hosts, index-url, and find-links).
        """
        # set up a server which will simulate an alternate package index.
        p_index = setuptools.tests.server.MockServer()
        p_index.start()
        netloc = 1
        p_index_loc = urlparse(p_index.url)[netloc]
        if p_index_loc.endswith(':0'):
            # Some platforms (Jython) don't find a port to which to bind,
            #  so skip this test for them.
            return
        with contexts.quiet():
            # create an sdist that has a build-time dependency.
            with TestSetupRequires.create_sdist() as dist_file:
                with contexts.tempdir() as temp_install_dir:
                    with contexts.environment(PYTHONPATH=temp_install_dir):
                        ei_params = [
                            '--index-url', p_index.url,
                            '--allow-hosts', p_index_loc,
                            '--exclude-scripts',
                            '--install-dir', temp_install_dir,
                            dist_file,
                        ]
                        with contexts.argv(['easy_install']):
                            # attempt to install the dist. It should fail because
                            #  it doesn't exist.
                            with pytest.raises(SystemExit):
                                easy_install_pkg.main(ei_params)
        # there should have been two or three requests to the server
        #  (three happens on Python 3.3a)
        assert 2 <= len(p_index.requests) <= 3
        assert p_index.requests[0].path == '/does-not-exist/'

    @staticmethod
    @contextlib.contextmanager
    def create_sdist():
        """
        Return an sdist with a setup_requires dependency (of something that
        doesn't exist)
        """
        with contexts.tempdir() as dir:
            dist_path = os.path.join(dir, 'setuptools-test-fetcher-1.0.tar.gz')
            script = DALS("""
                import setuptools
                setuptools.setup(
                    name="setuptools-test-fetcher",
                    version="1.0",
                    setup_requires = ['does-not-exist'],
                )
                """)
            make_trivial_sdist(dist_path, script)
            yield dist_path

    def test_setup_requires_overrides_version_conflict(self):
        """
        Regression test for issue #323.

        Ensures that a distribution's setup_requires requirements can still be
        installed and used locally even if a conflicting version of that
        requirement is already on the path.
        """

        pr_state = pkg_resources.__getstate__()
        fake_dist = PRDistribution('does-not-matter', project_name='foobar',
                                   version='0.0')
        working_set.add(fake_dist)

        try:
            with contexts.tempdir() as temp_dir:
                test_pkg = create_setup_requires_package(temp_dir)
                test_setup_py = os.path.join(test_pkg, 'setup.py')
                with contexts.quiet() as (stdout, stderr):
                    try:
                        # Don't even need to install the package, just
                        # running the setup.py at all is sufficient
                        run_setup(test_setup_py, ['--name'])
                    except VersionConflict:
                        self.fail('Installing setup.py requirements '
                            'caused a VersionConflict')

                lines = stdout.readlines()
                assert len(lines) > 0
                assert lines[-1].strip(), 'test_pkg'
        finally:
            pkg_resources.__setstate__(pr_state)


def create_setup_requires_package(path):
    """Creates a source tree under path for a trivial test package that has a
    single requirement in setup_requires--a tarball for that requirement is
    also created and added to the dependency_links argument.
    """

    test_setup_attrs = {
        'name': 'test_pkg', 'version': '0.0',
        'setup_requires': ['foobar==0.1'],
        'dependency_links': [os.path.abspath(path)]
    }

    test_pkg = os.path.join(path, 'test_pkg')
    test_setup_py = os.path.join(test_pkg, 'setup.py')
    os.mkdir(test_pkg)

    with open(test_setup_py, 'w') as f:
        f.write(DALS("""
            import setuptools
            setuptools.setup(**%r)
        """ % test_setup_attrs))

    foobar_path = os.path.join(path, 'foobar-0.1.tar.gz')
    make_trivial_sdist(
        foobar_path,
        DALS("""
            import setuptools
            setuptools.setup(
                name='foobar',
                version='0.1'
            )
        """))

    return test_pkg


def make_trivial_sdist(dist_path, setup_py):
    """Create a simple sdist tarball at dist_path, containing just a
    setup.py, the contents of which are provided by the setup_py string.
    """

    setup_py_file = tarfile.TarInfo(name='setup.py')
    try:
        # Python 3 (StringIO gets converted to io module)
        MemFile = BytesIO
    except AttributeError:
        MemFile = StringIO
    setup_py_bytes = MemFile(setup_py.encode('utf-8'))
    setup_py_file.size = len(setup_py_bytes.getvalue())
    with tarfile_open(dist_path, 'w:gz') as dist:
        dist.addfile(setup_py_file, fileobj=setup_py_bytes)
