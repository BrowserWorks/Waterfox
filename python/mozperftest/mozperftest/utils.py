# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
import logging
import contextlib
import sys
import os
import random
from io import StringIO
from redo import retry
import requests
from collections import defaultdict
from pathlib import Path
import tempfile


RETRY_SLEEP = 10


@contextlib.contextmanager
def silence(layer=None):
    if layer is None:
        to_patch = (MachLogger,)
    else:
        to_patch = (MachLogger, layer)

    meths = ("info", "debug", "warning", "error", "log")
    patched = defaultdict(dict)

    def _vacuum(*args, **kw):
        pass

    for obj in to_patch:
        for meth in meths:
            if not hasattr(obj, meth):
                continue
            patched[obj][meth] = getattr(obj, meth)
            setattr(obj, meth, _vacuum)

    oldout, olderr = sys.stdout, sys.stderr
    try:
        sys.stdout, sys.stderr = StringIO(), StringIO()
        sys.stdout.fileno = sys.stderr.fileno = lambda: -1
        yield sys.stdout, sys.stderr
    finally:
        sys.stdout, sys.stderr = oldout, olderr
        for obj, meths in patched.items():
            for name, old_func in meths.items():
                try:
                    setattr(obj, name, old_func)
                except Exception:
                    pass


def host_platform():
    is_64bits = sys.maxsize > 2 ** 32

    if sys.platform.startswith("win"):
        if is_64bits:
            return "win64"
    elif sys.platform.startswith("linux"):
        if is_64bits:
            return "linux64"
    elif sys.platform.startswith("darwin"):
        return "darwin"

    raise ValueError("sys.platform is not yet supported: {}".format(sys.platform))


class MachLogger:
    """Wrapper around the mach logger to make logging simpler.
    """

    def __init__(self, mach_cmd):
        self._logger = mach_cmd.log

    @property
    def log(self):
        return self._logger

    def info(self, msg, name="mozperftest", **kwargs):
        self._logger(logging.INFO, name, kwargs, msg)

    def debug(self, msg, name="mozperftest", **kwargs):
        self._logger(logging.DEBUG, name, kwargs, msg)

    def warning(self, msg, name="mozperftest", **kwargs):
        self._logger(logging.WARNING, name, kwargs, msg)

    def error(self, msg, name="mozperftest", **kwargs):
        self._logger(logging.ERROR, name, kwargs, msg)


def install_package(virtualenv_manager, package):
    from pip._internal.req.constructors import install_req_from_line

    req = install_req_from_line(package)
    req.check_if_exists(use_user_site=False)
    # already installed, check if it's in our venv
    if req.satisfied_by is not None:
        venv_site_lib = os.path.abspath(
            os.path.join(virtualenv_manager.bin_path, "..", "lib")
        )
        site_packages = os.path.abspath(req.satisfied_by.location)
        if site_packages.startswith(venv_site_lib):
            # already installed in this venv, we can skip
            return
    with silence():
        virtualenv_manager._run_pip(["install", package])


def build_test_list(tests, randomized=False):
    """Collects tests given a list of directories, files and URLs.

    Returns a tuple containing the list of tests found and a temp dir for tests
    that were downloaded from an URL.
    """
    temp_dir = None

    if isinstance(tests, str):
        tests = [tests]
    res = []
    for test in tests:
        if test.startswith("http"):
            if temp_dir is None:
                temp_dir = tempfile.mkdtemp()
            target = Path(temp_dir, test.split("/")[-1])
            download_file(test, target)
            res.append(str(target))
            continue

        test = Path(test)

        if test.is_file():
            res.append(str(test))
        elif test.is_dir():
            for file in test.rglob("perftest_*.js"):
                res.append(str(file))
    if not randomized:
        res.sort()
    else:
        # random shuffling is used to make sure
        # we don't always run tests in the same order
        random.shuffle(res)

    return res, temp_dir


def download_file(url, target, retry_sleep=RETRY_SLEEP, attempts=3):
    """Downloads a file, given an URL in the target path.

    The function will attempt several times on failures.
    """

    def _download_file(url, target):
        req = requests.get(url, stream=True, timeout=30)
        target_dir = target.parent.resolve()
        if str(target_dir) != "":
            target_dir.mkdir(exist_ok=True)

        with target.open("wb") as f:
            for chunk in req.iter_content(chunk_size=1024):
                if not chunk:
                    continue
                f.write(chunk)
                f.flush()
        return target

    return retry(
        _download_file,
        args=(url, target),
        attempts=attempts,
        sleeptime=retry_sleep,
        jitter=0,
    )


@contextlib.contextmanager
def temporary_env(**env):
    old = {}
    for key, value in env.items():
        old[key] = os.environ.get(key)
        os.environ[key] = value
    try:
        yield
    finally:
        for key, value in old.items():
            if value is None:
                del os.environ[key]
            else:
                os.environ[key] = value
