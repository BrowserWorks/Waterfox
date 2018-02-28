# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import sys
import hashlib
import re
import os
from mozbuild.preprocessor import Preprocessor
from mozbuild.util import DefinesAction
from mozpack.packager.unpack import UnpackFinder
from mozpack.files import DeflatedFile
from collections import OrderedDict
from StringIO import StringIO
import argparse
import buildconfig

'''
Find files duplicated in a given packaged directory, independently of its
package format.
'''


def normalize_osx_path(p):
    '''
    Strips the first 3 elements of an OSX app path

    >>> normalize_osx_path('Nightly.app/foo/bar/baz')
    'baz'
    '''
    bits = p.split('/')
    if len(bits) > 3 and bits[0].endswith('.app'):
        return '/'.join(bits[3:])
    return p

def is_l10n_file(path):
    return '/locale/' in path

def normalize_path(p):
    return normalize_osx_path(p)


def find_dupes(source, allowed_dupes, bail=True):
    allowed_dupes = set(allowed_dupes)
    md5s = OrderedDict()
    for p, f in UnpackFinder(source):
        content = f.open().read()
        m = hashlib.md5(content).digest()
        if m not in md5s:
            if isinstance(f, DeflatedFile):
                compressed = f.file.compressed_size
            else:
                compressed = len(content)
            md5s[m] = (len(content), compressed, [])
        md5s[m][2].append(p)
    total = 0
    total_compressed = 0
    num_dupes = 0
    for m, (size, compressed, paths) in sorted(md5s.iteritems(),
                                               key=lambda x: x[1][1]):
        if len(paths) > 1:
            print 'Duplicates %d bytes%s%s:' % (size,
                  ' (%d compressed)' % compressed if compressed != size else '',
                  ' (%d times)' % (len(paths) - 1) if len(paths) > 2 else '')
            print ''.join('  %s\n' % p for p in paths)
            total += (len(paths) - 1) * size
            total_compressed += (len(paths) - 1) * compressed
            num_dupes += 1

    if num_dupes:
        print "WARNING: Found %d duplicated files taking %d bytes (%s)" % \
              (num_dupes, total,
               '%d compressed' % total_compressed if total_compressed != total
                                                  else 'uncompressed')


def main():
    parser = argparse.ArgumentParser(description='Find duplicate files in directory.')
    parser.add_argument('--warning', '-w', action='store_true',
                        help='Only warn about duplicates, do not exit with an error')
    parser.add_argument('--file', '-f', action='append', dest='dupes_files', default=[],
                        help='Add exceptions to the duplicate list from this file')
    parser.add_argument('-D', action=DefinesAction)
    parser.add_argument('-U', action='append', default=[])
    parser.add_argument('directory',
                        help='The directory to check for duplicates in')

    args = parser.parse_args()

    allowed_dupes = []
    for filename in args.dupes_files:
        pp = Preprocessor()
        pp.context.update(buildconfig.defines)
        if args.D:
            pp.context.update(args.D)
        for undefine in args.U:
            if undefine in pp.context:
                del pp.context[undefine]
        pp.out = StringIO()
        pp.do_filter('substitution')
        pp.do_include(filename)
        allowed_dupes.extend([line.partition('#')[0].rstrip()
                              for line in pp.out.getvalue().splitlines()])

    find_dupes(args.directory, bail=not args.warning, allowed_dupes=allowed_dupes)

if __name__ == "__main__":
    main()
