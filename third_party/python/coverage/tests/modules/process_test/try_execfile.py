# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Test file for run_python_file.

This file is executed two ways::

    $ coverage run try_execfile.py

and::

    $ python try_execfile.py

The output is compared to see that the program execution context is the same
under coverage and under Python.

It is not crucial that the execution be identical, there are some differences
that are OK.  This program canonicalizes the output to gloss over those
differences and get a clean diff.

"""

import itertools
import json
import os
import sys

# sys.path varies by execution environments.  Coverage.py uses setuptools to
# make console scripts, which means pkg_resources is imported.  pkg_resources
# removes duplicate entries from sys.path.  So we do that too, since the extra
# entries don't affect the running of the program.

def same_file(p1, p2):
    """Determine if `p1` and `p2` refer to the same existing file."""
    if not p1:
        return not p2
    if not os.path.exists(p1):
        return False
    if not os.path.exists(p2):
        return False
    if hasattr(os.path, "samefile"):
        return os.path.samefile(p1, p2)
    else:
        norm1 = os.path.normcase(os.path.normpath(p1))
        norm2 = os.path.normcase(os.path.normpath(p2))
        return norm1 == norm2

def without_same_files(filenames):
    """Return the list `filenames` with duplicates (by same_file) removed."""
    reduced = []
    for filename in filenames:
        if not any(same_file(filename, other) for other in reduced):
            reduced.append(filename)
    return reduced

cleaned_sys_path = [os.path.normcase(p) for p in without_same_files(sys.path)]

DATA = "xyzzy"

import __main__

def my_function(a):
    """A function to force execution of module-level values."""
    return "my_fn(%r)" % a

FN_VAL = my_function("fooey")

loader = globals().get('__loader__')
spec = globals().get('__spec__')

# A more compact ad-hoc grouped-by-first-letter list of builtins.
CLUMPS = "ABC,DEF,GHI,JKLMN,OPQR,ST,U,VWXYZ_,ab,cd,efg,hij,lmno,pqr,stuvwxyz".split(",")

def word_group(w):
    """Figure out which CLUMP the first letter of w is in."""
    for i, clump in enumerate(CLUMPS):
        if w[0] in clump:
            return i
    return 99

builtin_dir = [" ".join(s) for _, s in itertools.groupby(dir(__builtins__), key=word_group)]

globals_to_check = {
    'os.getcwd': os.getcwd(),
    '__name__': __name__,
    '__file__': __file__,
    '__doc__': __doc__,
    '__builtins__.has_open': hasattr(__builtins__, 'open'),
    '__builtins__.dir': builtin_dir,
    '__loader__ exists': loader is not None,
    '__package__': __package__,
    '__spec__ exists': spec is not None,
    'DATA': DATA,
    'FN_VAL': FN_VAL,
    '__main__.DATA': getattr(__main__, "DATA", "nothing"),
    'argv0': sys.argv[0],
    'argv1-n': sys.argv[1:],
    'path': cleaned_sys_path,
}

if loader is not None:
    globals_to_check.update({
        '__loader__.fullname': getattr(loader, 'fullname', None) or getattr(loader, 'name', None)
    })

if spec is not None:
    globals_to_check.update({
        '__spec__.' + aname: getattr(spec, aname)
        for aname in ['name', 'origin', 'submodule_search_locations', 'parent', 'has_location']
    })

print(json.dumps(globals_to_check, indent=4, sort_keys=True))
