#!/usr/bin/env python
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os
import subprocess
import sys
from distutils.spawn import find_executable

here = os.path.dirname(os.path.realpath(__file__))
topsrcdir = os.path.join(here, os.pardir, os.pardir)


def run_mozlint(hooktype, args):
    # --quiet prevents warnings on eslint, it will be ignored by other linters
    python = find_executable('python2.7') or find_executable('python')
    cmd = [python, os.path.join(topsrcdir, 'mach'), 'lint', '--quiet']

    if 'commit' in hooktype:
        # don't prevent commits, just display the lint results
        subprocess.call(cmd + ['--workdir=staged'])
        return False
    elif 'push' in hooktype:
        return subprocess.call(cmd + ['--outgoing'] + args)

    print("warning: '{}' is not a valid mozlint hooktype".format(hooktype))
    return False


def hg(ui, repo, **kwargs):
    hooktype = kwargs['hooktype']
    return run_mozlint(hooktype, kwargs.get('pats', []))


def git(args=sys.argv[1:]):
    hooktype = os.path.basename(__file__)
    return run_mozlint(hooktype, args[:1])


if __name__ == '__main__':
    sys.exit(git())
