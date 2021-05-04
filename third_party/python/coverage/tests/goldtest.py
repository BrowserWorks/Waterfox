# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""A test base class for tests based on gold file comparison."""

import difflib
import filecmp
import fnmatch
import os
import os.path
import re
import sys
import xml.etree.ElementTree

from coverage import env

from tests.coveragetest import TESTS_DIR


def gold_path(path):
    """Get a path to a gold file for comparison."""
    return os.path.join(TESTS_DIR, "gold", path)


# "rU" was deprecated in 3.4
READ_MODE = "rU" if env.PYVERSION < (3, 4) else "r"


def versioned_directory(d):
    """Find a subdirectory of d specific to the Python version.
    For example, on Python 3.6.4 rc 1, it returns the first of these
    directories that exists::
        d/3.6.4.candidate.1
        d/3.6.4.candidate
        d/3.6.4
        d/3.6
        d/3
        d
    Returns: a string, the path to an existing directory.
    """
    ver_parts = list(map(str, sys.version_info))
    for nparts in range(len(ver_parts), -1, -1):
        version = ".".join(ver_parts[:nparts])
        subdir = os.path.join(d, version)
        if os.path.exists(subdir):
            return subdir
    raise Exception("Directory missing: {}".format(d))                  # pragma: only failure


def compare(
        expected_dir, actual_dir, file_pattern=None,
        actual_extra=False, scrubs=None,
        ):
    """Compare files matching `file_pattern` in `expected_dir` and `actual_dir`.

    A version-specific subdirectory of `expected_dir` will be used if
    it exists.

    `actual_extra` true means `actual_dir` can have extra files in it
    without triggering an assertion.

    `scrubs` is a list of pairs: regexes to find and replace to scrub the
    files of unimportant differences.

    An assertion will be raised if the directories fail one of their
    matches.

    """
    expected_dir = versioned_directory(expected_dir)

    dc = filecmp.dircmp(expected_dir, actual_dir)
    diff_files = fnmatch_list(dc.diff_files, file_pattern)
    expected_only = fnmatch_list(dc.left_only, file_pattern)
    actual_only = fnmatch_list(dc.right_only, file_pattern)

    # filecmp only compares in binary mode, but we want text mode.  So
    # look through the list of different files, and compare them
    # ourselves.
    text_diff = []
    for f in diff_files:

        expected_file = os.path.join(expected_dir, f)
        with open(expected_file, READ_MODE) as fobj:
            expected = fobj.read()
        if expected_file.endswith(".xml"):
            expected = canonicalize_xml(expected)

        actual_file = os.path.join(actual_dir, f)
        with open(actual_file, READ_MODE) as fobj:
            actual = fobj.read()
        if actual_file.endswith(".xml"):
            actual = canonicalize_xml(actual)

        if scrubs:
            expected = scrub(expected, scrubs)
            actual = scrub(actual, scrubs)
        if expected != actual:                              # pragma: only failure
            text_diff.append('%s != %s' % (expected_file, actual_file))
            expected = expected.splitlines()
            actual = actual.splitlines()
            print(":::: diff {!r} and {!r}".format(expected_file, actual_file))
            print("\n".join(difflib.Differ().compare(expected, actual)))
            print(":::: end diff {!r} and {!r}".format(expected_file, actual_file))
    assert not text_diff, "Files differ: %s" % '\n'.join(text_diff)

    assert not expected_only, "Files in %s only: %s" % (expected_dir, expected_only)
    if not actual_extra:
        assert not actual_only, "Files in %s only: %s" % (actual_dir, actual_only)


def canonicalize_xml(xtext):
    """Canonicalize some XML text."""
    root = xml.etree.ElementTree.fromstring(xtext)
    for node in root.iter():
        node.attrib = dict(sorted(node.items()))
    xtext = xml.etree.ElementTree.tostring(root)
    return xtext.decode('utf8')


def contains(filename, *strlist):
    """Check that the file contains all of a list of strings.

    An assert will be raised if one of the arguments in `strlist` is
    missing in `filename`.

    """
    with open(filename, "r") as fobj:
        text = fobj.read()
    for s in strlist:
        assert s in text, "Missing content in %s: %r" % (filename, s)


def contains_any(filename, *strlist):
    """Check that the file contains at least one of a list of strings.

    An assert will be raised if none of the arguments in `strlist` is in
    `filename`.

    """
    with open(filename, "r") as fobj:
        text = fobj.read()
    for s in strlist:
        if s in text:
            return

    assert False, (                         # pragma: only failure
        "Missing content in %s: %r [1 of %d]" % (filename, strlist[0], len(strlist),)
    )


def doesnt_contain(filename, *strlist):
    """Check that the file contains none of a list of strings.

    An assert will be raised if any of the strings in `strlist` appears in
    `filename`.

    """
    with open(filename, "r") as fobj:
        text = fobj.read()
    for s in strlist:
        assert s not in text, "Forbidden content in %s: %r" % (filename, s)


# Helpers

def fnmatch_list(files, file_pattern):
    """Filter the list of `files` to only those that match `file_pattern`.
    If `file_pattern` is None, then return the entire list of files.
    Returns a list of the filtered files.
    """
    if file_pattern:
        files = [f for f in files if fnmatch.fnmatch(f, file_pattern)]
    return files


def scrub(strdata, scrubs):
    """Scrub uninteresting data from the payload in `strdata`.
    `scrubs` is a list of (find, replace) pairs of regexes that are used on
    `strdata`.  A string is returned.
    """
    for rgx_find, rgx_replace in scrubs:
        strdata = re.sub(rgx_find, rgx_replace, strdata)
    return strdata
