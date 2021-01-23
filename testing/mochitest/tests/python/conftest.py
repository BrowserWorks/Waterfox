# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import print_function, unicode_literals
import json
import os
from argparse import Namespace
from cStringIO import StringIO

import pytest

import mozinfo
from manifestparser import TestManifest, expression
from moztest.selftest.fixtures import binary, setup_test_harness  # noqa

here = os.path.abspath(os.path.dirname(__file__))
setup_args = [os.path.join(here, 'files'), 'mochitest', 'testing/mochitest']


@pytest.fixture(scope='function')
def parser(request):
    parser = pytest.importorskip('mochitest_options')

    app = getattr(request.module, 'APP', 'generic')
    return parser.MochitestArgumentParser(app=app)


@pytest.fixture(scope='function')
def runtests(setup_test_harness, binary, parser, request):
    """Creates an easy to use entry point into the mochitest harness.

    :returns: A function with the signature `*tests, **opts`. Each test is a file name
              (relative to the `files` dir). At least one is required. The opts are
              used to override the default mochitest options, they are optional.
    """
    setup_test_harness(*setup_args)
    runtests = pytest.importorskip('runtests')

    mochitest_root = runtests.SCRIPT_DIR
    test_root = os.path.join(mochitest_root, 'tests', 'selftests')

    buf = StringIO()
    options = vars(parser.parse_args([]))
    options.update({
        'app': binary,
        'keep_open': False,
        'log_raw': [buf],
    })

    if not os.path.isdir(runtests.build_obj.bindir):
        package_root = os.path.dirname(mochitest_root)
        options.update({
            'certPath': os.path.join(package_root, 'certs'),
            'utilityPath': os.path.join(package_root, 'bin'),
        })
        options['extraProfileFiles'].append(os.path.join(package_root, 'bin', 'plugins'))

    options.update(getattr(request.module, 'OPTIONS', {}))

    def normalize(test):
        return {
            'name': test,
            'relpath': test,
            'path': os.path.join(test_root, test),
            # add a dummy manifest file because mochitest expects it
            'manifest': os.path.join(test_root, 'mochitest.ini'),
            'manifest_relpath': 'mochitest.ini',
        }

    def inner(*tests, **opts):
        assert len(tests) > 0

        manifest = TestManifest()
        manifest.tests.extend(map(normalize, tests))
        options['manifestFile'] = manifest
        options.update(opts)

        result = runtests.run_test_harness(parser, Namespace(**options))
        out = json.loads('[' + ','.join(buf.getvalue().splitlines()) + ']')
        buf.close()
        return result, out
    return inner


@pytest.fixture
def build_obj(setup_test_harness):
    setup_test_harness(*setup_args)
    mochitest_options = pytest.importorskip('mochitest_options')
    return mochitest_options.build_obj


@pytest.fixture(autouse=True)
def skip_using_mozinfo(request, setup_test_harness):
    """Gives tests the ability to skip based on values from mozinfo.

    Example:
        @pytest.mark.skip_mozinfo("!e10s || os == 'linux'")
        def test_foo():
            pass
    """

    setup_test_harness(*setup_args)
    runtests = pytest.importorskip('runtests')
    runtests.update_mozinfo()

    skip_mozinfo = request.node.get_marker('skip_mozinfo')
    if skip_mozinfo:
        value = skip_mozinfo.args[0]
        if expression.parse(value, **mozinfo.info):
            pytest.skip("skipped due to mozinfo match: \n{}".format(value))
