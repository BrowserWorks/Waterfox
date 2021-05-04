# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Helpers for coverage.py tests."""

import glob
import os
import re
import shutil
import subprocess
import sys

from unittest_mixins import ModuleCleaner

from coverage import env
from coverage.backward import invalidate_import_caches, unicode_class
from coverage.misc import output_encoding


def run_command(cmd):
    """Run a command in a sub-process.

    Returns the exit status code and the combined stdout and stderr.

    """
    if env.PY2 and isinstance(cmd, unicode_class):
        cmd = cmd.encode(sys.getfilesystemencoding())

    # In some strange cases (PyPy3 in a virtualenv!?) the stdout encoding of
    # the subprocess is set incorrectly to ascii.  Use an environment variable
    # to force the encoding to be the same as ours.
    sub_env = dict(os.environ)
    sub_env['PYTHONIOENCODING'] = output_encoding()

    proc = subprocess.Popen(
        cmd,
        shell=True,
        env=sub_env,
        stdin=subprocess.PIPE, stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
        )
    output, _ = proc.communicate()
    status = proc.returncode

    # Get the output, and canonicalize it to strings with newlines.
    if not isinstance(output, str):
        output = output.decode(output_encoding())
    output = output.replace('\r', '')

    return status, output


class CheckUniqueFilenames(object):
    """Asserts the uniqueness of file names passed to a function."""
    def __init__(self, wrapped):
        self.filenames = set()
        self.wrapped = wrapped

    @classmethod
    def hook(cls, obj, method_name):
        """Replace a method with our checking wrapper.

        The method must take a string as a first argument. That argument
        will be checked for uniqueness across all the calls to this method.

        The values don't have to be file names actually, just strings, but
        we only use it for filename arguments.

        """
        method = getattr(obj, method_name)
        hook = cls(method)
        setattr(obj, method_name, hook.wrapper)
        return hook

    def wrapper(self, filename, *args, **kwargs):
        """The replacement method.  Check that we don't have dupes."""
        assert filename not in self.filenames, (
            "File name %r passed to %r twice" % (filename, self.wrapped)
            )
        self.filenames.add(filename)
        ret = self.wrapped(filename, *args, **kwargs)
        return ret


def re_lines(text, pat, match=True):
    """Return the text of lines that match `pat` in the string `text`.

    If `match` is false, the selection is inverted: only the non-matching
    lines are included.

    Returns a string, the text of only the selected lines.

    """
    return "".join(l for l in text.splitlines(True) if bool(re.search(pat, l)) == match)


def re_line(text, pat):
    """Return the one line in `text` that matches regex `pat`.

    Raises an AssertionError if more than one, or less than one, line matches.

    """
    lines = re_lines(text, pat).splitlines()
    assert len(lines) == 1
    return lines[0]


def remove_files(*patterns):
    """Remove all files that match any of the patterns."""
    for pattern in patterns:
        for fname in glob.glob(pattern):
            os.remove(fname)


class SuperModuleCleaner(ModuleCleaner):
    """Remember the state of sys.modules and restore it later."""

    def clean_local_file_imports(self):
        """Clean up the results of calls to `import_local_file`.

        Use this if you need to `import_local_file` the same file twice in
        one test.

        """
        # So that we can re-import files, clean them out first.
        self.cleanup_modules()

        # Also have to clean out the .pyc file, since the timestamp
        # resolution is only one second, a changed file might not be
        # picked up.
        remove_files("*.pyc", "*$py.class")
        if os.path.exists("__pycache__"):
            shutil.rmtree("__pycache__")

        invalidate_import_caches()


# Map chars to numbers for arcz_to_arcs
_arcz_map = {'.': -1}
_arcz_map.update(dict((c, ord(c) - ord('0')) for c in '123456789'))
_arcz_map.update(dict(
    (c, 10 + ord(c) - ord('A')) for c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
))

def arcz_to_arcs(arcz):
    """Convert a compact textual representation of arcs to a list of pairs.

    The text has space-separated pairs of letters.  Period is -1, 1-9 are
    1-9, A-Z are 10 through 36.  The resulting list is sorted regardless of
    the order of the input pairs.

    ".1 12 2." --> [(-1,1), (1,2), (2,-1)]

    Minus signs can be included in the pairs:

    "-11, 12, 2-5" --> [(-1,1), (1,2), (2,-5)]

    """
    arcs = []
    for pair in arcz.split():
        asgn = bsgn = 1
        if len(pair) == 2:
            a, b = pair
        else:
            assert len(pair) == 3
            if pair[0] == '-':
                _, a, b = pair
                asgn = -1
            else:
                assert pair[1] == '-'
                a, _, b = pair
                bsgn = -1
        arcs.append((asgn * _arcz_map[a], bsgn * _arcz_map[b]))
    return sorted(arcs)


_arcz_unmap = {val: ch for ch, val in _arcz_map.items()}

def _arcs_to_arcz_repr_one(num):
    """Return an arcz form of the number `num`, or "?" if there is none."""
    if num == -1:
        return "."
    z = ""
    if num < 0:
        z += "-"
        num *= -1
    z += _arcz_unmap.get(num, "?")
    return z


def arcs_to_arcz_repr(arcs):
    """Convert a list of arcs to a readable multi-line form for asserting.

    Each pair is on its own line, with a comment showing the arcz form,
    to make it easier to decode when debugging test failures.

    """
    repr_list = []
    for a, b in arcs:
        line = repr((a, b))
        line += " # "
        line += _arcs_to_arcz_repr_one(a)
        line += _arcs_to_arcz_repr_one(b)
        repr_list.append(line)
    return "\n".join(repr_list) + "\n"
