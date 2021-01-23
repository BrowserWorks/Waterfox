#!/usr/bin/env python
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
import sys
import mozunit
from unittest import mock
import pytest
from pathlib import Path
import shutil

from mozperftest.utils import (
    host_platform,
    silence,
    download_file,
    install_package,
    build_test_list,
)
from mozperftest.tests.support import temp_file, requests_content, EXAMPLE_TESTS_DIR


def test_silence():
    with silence():
        print("HIDDEN")


def test_host_platform():
    plat = host_platform()

    # a bit useless... :)
    if sys.platform.startswith("darwin"):
        assert plat == "darwin"
    else:
        if sys.maxsize > 2 ** 32:
            assert "64" in plat
        else:
            assert "64" not in plat


def get_raise(*args, **kw):
    raise Exception()


@mock.patch("mozperftest.utils.requests.get", new=get_raise)
def test_download_file_fails():
    with temp_file() as target, silence(), pytest.raises(Exception):
        download_file("http://I don't exist", Path(target), retry_sleep=0.1)


@mock.patch("mozperftest.utils.requests.get", new=requests_content())
def test_download_file_success():
    with temp_file() as target:
        download_file("http://content", Path(target), retry_sleep=0.1)
        with open(target) as f:
            assert f.read() == "some content"


def _req(package):
    class Req:
        location = "nowhere"

        @property
        def satisfied_by(self):
            return self

        def check_if_exists(self, **kw):
            pass

    return Req()


@mock.patch("pip._internal.req.constructors.install_req_from_line", new=_req)
def test_install_package():
    vem = mock.Mock()
    vem.bin_path = "someplace"
    install_package(vem, "foo")
    vem._run_pip.assert_called()


@mock.patch("mozperftest.utils.requests.get", requests_content())
def test_build_test_list():
    tests = [EXAMPLE_TESTS_DIR, "https://some/location/perftest_one.js"]
    try:
        files, tmp_dir = build_test_list(tests)
        assert len(files) == 2
    finally:
        shutil.rmtree(tmp_dir)


if __name__ == "__main__":
    mozunit.main()
