# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

import os
import unittest
from StringIO import StringIO
from mozunit import main
from buildconfig import (
    topobjdir,
    topsrcdir,
)

from mozbuild.configure.lint import LintSandbox


test_path = os.path.abspath(__file__)


class LintMeta(type):
    def __new__(mcs, name, bases, attrs):
        def create_test(project, func):
            def test(self):
                return func(self, project)
            return test

        for project in (
            'b2g',
            'b2g/dev',
            'b2g/graphene',
            'browser',
            'embedding/ios',
            'extensions',
            'js',
            'mobile/android',
        ):
            attrs['test_%s' % project.replace('/', '_')] = create_test(
                project, attrs['lint'])

        return type.__new__(mcs, name, bases, attrs)


class Lint(unittest.TestCase):
    __metaclass__ = LintMeta

    def setUp(self):
        self._curdir = os.getcwd()
        os.chdir(topobjdir)

    def tearDown(self):
        os.chdir(self._curdir)

    def lint(self, project):
        sandbox = LintSandbox({
            'OLD_CONFIGURE': os.path.join(topsrcdir, 'old-configure'),
            'MOZCONFIG': os.path.join(os.path.dirname(test_path), 'data',
                                      'empty_mozconfig'),
        }, ['--enable-project=%s' % project])
        sandbox.run(os.path.join(topsrcdir, 'moz.configure'))


if __name__ == '__main__':
    main()
