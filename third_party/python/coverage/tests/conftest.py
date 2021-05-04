# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""
Pytest auto configuration.

This module is run automatically by pytest, to define and enable fixtures.
"""

import os
import sys
import warnings

import pytest

from coverage import env


# Pytest can take additional options:
# $set_env.py: PYTEST_ADDOPTS - Extra arguments to pytest.

@pytest.fixture(autouse=True)
def set_warnings():
    """Enable DeprecationWarnings during all tests."""
    warnings.simplefilter("default")
    warnings.simplefilter("once", DeprecationWarning)

    # A warning to suppress:
    #   setuptools/py33compat.py:54: DeprecationWarning: The value of convert_charrefs will become
    #   True in 3.5. You are encouraged to set the value explicitly.
    #       unescape = getattr(html, 'unescape', html_parser.HTMLParser().unescape)
    # How come this warning is successfully suppressed here, but not in setup.cfg??
    warnings.filterwarnings(
        "ignore",
        category=DeprecationWarning,
        message="The value of convert_charrefs will become True in 3.5.",
        )
    warnings.filterwarnings(
        "ignore",
        category=DeprecationWarning,
        message=".* instead of inspect.getfullargspec",
        )
    if env.PYPY3:
        # pypy3 warns about unclosed files a lot.
        warnings.filterwarnings("ignore", r".*unclosed file", category=ResourceWarning)


@pytest.fixture(autouse=True)
def reset_sys_path():
    """Clean up sys.path changes around every test."""
    sys_path = list(sys.path)
    yield
    sys.path[:] = sys_path


@pytest.fixture(autouse=True)
def fix_xdist_sys_path():
    """Prevent xdist from polluting the Python path.

    We run tests that care a lot about the contents of sys.path.  Pytest-xdist
    changes sys.path, so running with xdist, vs without xdist, sets sys.path
    differently.  With xdist, sys.path[1] is an empty string, without xdist,
    it's the virtualenv bin directory.  We don't want the empty string, so
    clobber that entry.

    See: https://github.com/pytest-dev/pytest-xdist/issues/376

    """
    if os.environ.get('PYTEST_XDIST_WORKER', ''):
        # We are running in an xdist worker.
        if sys.path[1] == '':
            # xdist has set sys.path[1] to ''.  Clobber it.
            del sys.path[1]
        # Also, don't let it sneak stuff in via PYTHONPATH.
        try:
            del os.environ['PYTHONPATH']
        except KeyError:
            pass
