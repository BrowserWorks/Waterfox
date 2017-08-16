ENABLE_SCREEN_RESOLUTION_CHECK = True

SCREEN_RESOLUTION_CHECK = {
    "name": "check_screen_resolution",
    "cmd": ["bash", "-c", "screenresolution get && screenresolution list && system_profiler SPDisplaysDataType"],
    "architectures": ["32bit", "64bit"],
    "halt_on_failure": False,
    "enabled": ENABLE_SCREEN_RESOLUTION_CHECK
}

import os

PYTHON = '/tools/buildbot/bin/python'
VENV_PATH = '%s/build/venv' % os.getcwd()

config = {
    "log_name": "talos",
    "buildbot_json_path": "buildprops.json",
    "installer_path": "installer.exe",
    "virtualenv_path": VENV_PATH,
    "find_links": [
        "http://pypi.pvt.build.mozilla.org/pub",
        "http://pypi.pub.build.mozilla.org/pub",
    ],
    "pip_index": False,
    "exes": {
        'python': PYTHON,
        'virtualenv': [PYTHON, '/tools/misc-python/virtualenv.py'],
        'tooltool.py': "/tools/tooltool.py",
    },
    "title": os.uname()[1].lower().split('.')[0],
    "default_actions": [
        "clobber",
        "read-buildbot-config",
        "download-and-extract",
        "populate-webroot",
        "create-virtualenv",
        "install",
        "setup-mitmproxy",
        "run-tests",
    ],
    "run_cmd_checks_enabled": True,
    "preflight_run_cmd_suites": [
        SCREEN_RESOLUTION_CHECK,
    ],
    "postflight_run_cmd_suites": [
        SCREEN_RESOLUTION_CHECK,
    ],
    "default_blob_upload_servers": [
        "https://blobupload.elasticbeanstalk.com",
    ],
    "blob_uploader_auth_file": os.path.join(os.getcwd(), "oauth.txt"),
    "download_minidump_stackwalk": True,
    "minidump_stackwalk_path": "macosx64-minidump_stackwalk",
    "minidump_tooltool_manifest_path": "config/tooltool-manifests/macosx64/releng.manifest",
    "tooltool_cache": "/builds/tooltool_cache",
}
