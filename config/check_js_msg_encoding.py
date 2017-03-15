# vim: set ts=8 sts=4 et sw=4 tw=99:
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#----------------------------------------------------------------------------
# This script checks encoding of the files that define JSErrorFormatStrings.
#
# JSErrorFormatString.format member should be in ASCII encoding.
#----------------------------------------------------------------------------

from __future__ import print_function

import os
import sys
from check_utils import get_all_toplevel_filenames

scriptname = os.path.basename(__file__);
expected_encoding = 'ascii'

# The following files don't define JSErrorFormatString.
ignore_files = [
    'dom/base/domerr.msg',
    'js/xpconnect/src/xpc.msg',
]

def log_pass(filename, text):
    print('TEST-PASS | {} | {} | {}'.format(scriptname, filename, text))

def log_fail(filename, text):
    print('TEST-UNEXPECTED-FAIL | {} | {} | {}'.format(scriptname, filename,
                                                       text))

def check_single_file(filename):
    with open(filename, 'rb') as f:
        data = f.read()
        try:
            data.decode(expected_encoding)
        except:
            log_fail(filename, 'not in {} encoding'.format(expected_encoding))

    log_pass(filename, 'ok')
    return True

def check_files():
    result = True

    for filename in get_all_toplevel_filenames():
        if filename.endswith('.msg'):
            if filename not in ignore_files:
                if not check_single_file(filename):
                    result = False

    return result

def main():
    if not check_files():
        sys.exit(1)

    sys.exit(0)

if __name__ == '__main__':
    main()
