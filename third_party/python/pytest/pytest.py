# PYTHON_ARGCOMPLETE_OK
"""
pytest: unit and functional testing with Python.
"""


# else we are imported

from _pytest.config import (
    main, UsageError, _preloadplugins, cmdline,
    hookspec, hookimpl
)
from _pytest.fixtures import fixture, yield_fixture
from _pytest.assertion import register_assert_rewrite
from _pytest.freeze_support import freeze_includes
from _pytest import __version__
from _pytest.debugging import pytestPDB as __pytestPDB
from _pytest.recwarn import warns, deprecated_call
from _pytest.runner import fail, skip, importorskip, exit
from _pytest.mark import MARK_GEN as mark, param
from _pytest.skipping import xfail
from _pytest.main import Item, Collector, File, Session
from _pytest.fixtures import fillfixtures as _fillfuncargs
from _pytest.python import (
    raises, approx,
    Module, Class, Instance, Function, Generator,
)

set_trace = __pytestPDB.set_trace

__all__ = [
    'main',
    'UsageError',
    'cmdline',
    'hookspec',
    'hookimpl',
    '__version__',
    'register_assert_rewrite',
    'freeze_includes',
    'set_trace',
    'warns',
    'deprecated_call',
    'fixture',
    'yield_fixture',
    'fail',
    'skip',
    'xfail',
    'importorskip',
    'exit',
    'mark',
    'param',
    'approx',
    '_fillfuncargs',

    'Item',
    'File',
    'Collector',
    'Session',
    'Module',
    'Class',
    'Instance',
    'Function',
    'Generator',
    'raises',


]

if __name__ == '__main__':
    # if run as a script or by 'python -m pytest'
    # we trigger the below "else" condition by the following import
    import pytest
    raise SystemExit(pytest.main())
else:

    from _pytest.compat import _setup_collect_fakemodule
    _preloadplugins()  # to populate pytest.* namespace so help(pytest) works
    _setup_collect_fakemodule()
