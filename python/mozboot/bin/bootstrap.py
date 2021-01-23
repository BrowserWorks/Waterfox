#!/usr/bin/env python
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

# This script provides one-line bootstrap support to configure systems to build
# the tree.
#
# The role of this script is to load the Python modules containing actual
# bootstrap support. It does this through various means, including fetching
# content from the upstream source repository.

from __future__ import absolute_import, print_function, unicode_literals

WRONG_PYTHON_VERSION_MESSAGE = '''
Bootstrap currently only runs on Python 2.7 or Python 3.5+.
Please try re-running with python2.7 or python3.5+.

If these aren't available on your system, you may need to install them.
Look for a "python2" or "python3.5" package in your package manager.
'''

import sys

major, minor = sys.version_info[:2]
if (major == 2 and minor < 7) or (major == 3 and minor < 5):
    print(WRONG_PYTHON_VERSION_MESSAGE)
    sys.exit(1)

import os
import shutil
import tempfile
import zipfile

from io import BytesIO
from optparse import OptionParser

# NOTE: This script is intended to be run with a vanilla Python install.  We
# have to rely on the standard library instead of Python 2+3 helpers like
# the six module.
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen


# The next two variables define where in the repository the Python files
# reside. This is used to remotely download file content when it isn't
# available locally.
REPOSITORY_PATH_PREFIX = 'python/mozboot/'

TEMPDIR = None


def setup_proxy():
    # Some Linux environments define ALL_PROXY, which is a SOCKS proxy
    # intended for all protocols. Python doesn't currently automatically
    # detect this like it does for http_proxy and https_proxy.
    if 'ALL_PROXY' in os.environ and 'https_proxy' not in os.environ:
        os.environ['https_proxy'] = os.environ['ALL_PROXY']
    if 'ALL_PROXY' in os.environ and 'http_proxy' not in os.environ:
        os.environ['http_proxy'] = os.environ['ALL_PROXY']


def fetch_files(repo_url, repo_rev, repo_type):
    setup_proxy()
    repo_url = repo_url.rstrip('/')

    files = {}

    if repo_type == 'hgweb':
        url = repo_url + '/archive/%s.zip/python/mozboot' % repo_rev
        req = urlopen(url=url, timeout=30)
        data = BytesIO(req.read())
        data.seek(0)
        zip = zipfile.ZipFile(data, 'r')
        for f in zip.infolist():
            # The paths are prefixed with the repo and revision name before the
            # directory name.
            offset = f.filename.find(REPOSITORY_PATH_PREFIX) + len(REPOSITORY_PATH_PREFIX)
            name = f.filename[offset:]

            # We only care about the Python modules.
            if not name.startswith('mozboot/'):
                continue

            files[name] = zip.read(f)

        # Retrieve distro script
        url = repo_url + '/archive/%s.zip/third_party/python/distro/distro.py' % repo_rev
        req = urlopen(url=url, timeout=30)
        data = BytesIO(req.read())
        data.seek(0)
        zip = zipfile.ZipFile(data, 'r')
        files["distro.py"] = zip.read(zip.infolist()[0])

    else:
        raise NotImplementedError('Not sure how to handle repo type.', repo_type)

    return files


def ensure_environment(repo_url=None, repo_rev=None, repo_type=None):
    """Ensure we can load the Python modules necessary to perform bootstrap."""

    try:
        from mozboot.bootstrap import Bootstrapper
        return Bootstrapper
    except ImportError:
        # The first fallback is to assume we are running from a tree checkout
        # and have the files in a sibling directory.
        pardir = os.path.join(os.path.dirname(__file__), os.path.pardir)
        include = os.path.normpath(pardir)

        sys.path.append(include)
        try:
            from mozboot.bootstrap import Bootstrapper
            return Bootstrapper
        except ImportError:
            sys.path.pop()

            # The next fallback is to download the files from the source
            # repository.
            files = fetch_files(repo_url, repo_rev, repo_type)

            # Install them into a temporary location. They will be deleted
            # after this script has finished executing.
            global TEMPDIR
            TEMPDIR = tempfile.mkdtemp()

            for relpath in files.keys():
                destpath = os.path.join(TEMPDIR, relpath)
                destdir = os.path.dirname(destpath)

                if not os.path.exists(destdir):
                    os.makedirs(destdir)

                with open(destpath, 'wb') as fh:
                    fh.write(files[relpath])

            # This should always work.
            sys.path.append(TEMPDIR)
            from mozboot.bootstrap import Bootstrapper
            return Bootstrapper


def main(args):
    parser = OptionParser()
    parser.add_option('-r', '--repo-url', dest='repo_url',
                      default='https://hg.mozilla.org/mozilla-central/',
                      help='Base URL of source control repository where bootstrap files can '
                      'be downloaded.')
    parser.add_option('--repo-rev', dest='repo_rev',
                      default='default',
                      help='Revision of files in repository to fetch')
    parser.add_option('--repo-type', dest='repo_type',
                      default='hgweb',
                      help='The type of the repository. This defines how we fetch file '
                      'content. Like --repo, you should not need to set this.')

    parser.add_option('--application-choice', dest='application_choice',
                      help='Pass in an application choice (see mozboot.bootstrap.APPLICATIONS) '
                      'instead of using the default interactive prompt.')
    parser.add_option('--vcs', dest='vcs', default=None,
                      help='VCS (hg or git) to use for downloading the source code, '
                      'instead of using the default interactive prompt.')
    parser.add_option('--no-interactive', dest='no_interactive', action='store_true',
                      help='Answer yes to any (Y/n) interactive prompts.')
    parser.add_option('--debug', dest='debug', action='store_true',
                      help='Print extra runtime information useful for debugging and '
                      'bug reports.')

    options, leftover = parser.parse_args(args)

    try:
        try:
            cls = ensure_environment(options.repo_url, options.repo_rev,
                                     options.repo_type)
        except Exception as e:
            print('Could not load the bootstrap Python environment.\n')
            print('This should never happen. Consider filing a bug.\n')
            print('\n')

            if options.debug:
                # Raise full tracebacks during debugging and for bug reporting.
                raise

            print(e)
            return 1

        dasboot = cls(choice=options.application_choice, no_interactive=options.no_interactive,
                      vcs=options.vcs)
        dasboot.bootstrap()

        return 0
    finally:
        if TEMPDIR is not None:
            shutil.rmtree(TEMPDIR)


if __name__ == '__main__':
    sys.exit(main(sys.argv))
