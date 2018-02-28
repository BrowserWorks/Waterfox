import os
import platform
import sys

PYTHON = sys.executable
VENV_PATH = '%s/build/venv' % os.getcwd()

if platform.architecture()[0] == '64bit':
    TOOLTOOL_MANIFEST_PATH = "config/tooltool-manifests/linux64/releng.manifest"
    MINIDUMP_STACKWALK_PATH = "linux64-minidump_stackwalk"
else:
    TOOLTOOL_MANIFEST_PATH = "config/tooltool-manifests/linux32/releng.manifest"
    MINIDUMP_STACKWALK_PATH = "linux32-minidump_stackwalk"

exes = {
    'tooltool.py': ["/builds/tooltool.py"],
    'python': PYTHON,
    'virtualenv': [PYTHON, '/usr/local/lib/python2.7/dist-packages/virtualenv.py'],
}
ABS_WORK_DIR = os.path.join(os.getcwd(), "build")
INSTALLER_PATH = os.path.join(ABS_WORK_DIR, "installer.tar.bz2")

config = {
    "log_name": "talos",
    "buildbot_json_path": "buildprops.json",
    "download_tooltool": True,
    "installer_path": INSTALLER_PATH,
    "virtualenv_path": VENV_PATH,
    "find_links": [
        "http://pypi.pvt.build.mozilla.org/pub",
        "http://pypi.pub.build.mozilla.org/pub",
    ],
    "pip_index": False,
    "exes": exes,
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
    "default_blob_upload_servers": [
        "https://blobupload.elasticbeanstalk.com",
    ],
    "blob_uploader_auth_file": os.path.join(os.getcwd(), "oauth.txt"),
    "download_minidump_stackwalk": True,
    "minidump_stackwalk_path": MINIDUMP_STACKWALK_PATH,
    "minidump_tooltool_manifest_path": TOOLTOOL_MANIFEST_PATH,
    "tooltool_cache": "/home/worker/tooltool-cache",
}
