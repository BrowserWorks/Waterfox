import os
import sys

PYTHON = sys.executable
VENV_PATH = '%s/build/venv' % os.getcwd()

exes = {
    'python': PYTHON,
}
ABS_WORK_DIR = os.path.join(os.getcwd(), "build")
INSTALLER_PATH = os.path.join(ABS_WORK_DIR, "installer.tar.bz2")

config = {
    "log_name": "raptor",
    "installer_path": INSTALLER_PATH,
    "virtualenv_path": VENV_PATH,
    "exes": exes,
    "title": os.uname()[1].lower().split('.')[0],
    "default_actions": [
        "clobber",
        "download-and-extract",
        "populate-webroot",
        "create-virtualenv",
        "install",
        "run-tests",
    ],
    "tooltool_cache": "/builds/worker/tooltool-cache",
}
