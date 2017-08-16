import os

EN_US_BINARY_URL = "%(en_us_binary_url)s"

config = {
    "locales_file": "src/browser/locales/all-locales",
    "tools_repo": "https://hg.mozilla.org/build/tools",
    "mozconfig": "src/browser/config/mozconfigs/macosx64/l10n-mozconfig",
    "bootstrap_env": {
        "NO_MERCURIAL_SETUP_CHECK": "1",
        "MOZ_OBJDIR": "obj-l10n",
        "EN_US_BINARY_URL": os.environ.get("EN_US_BINARY_URL", EN_US_BINARY_URL),
        "LOCALE_MERGEDIR": "%(abs_merge_dir)s/",
        "MOZ_UPDATE_CHANNEL": "%(update_channel)s",
        "DIST": "%(abs_objdir)s",
        "LOCALE_MERGEDIR": "%(abs_merge_dir)s/",
        "L10NBASEDIR": "../../l10n",
        "MOZ_MAKE_COMPLETE_MAR": "1",
        'TOOLTOOL_CACHE': os.environ.get('TOOLTOOL_CACHE'),
    },
    "upload_env": {
        'UPLOAD_HOST': 'localhost',
        'UPLOAD_PATH': '/home/worker/artifacts/',
    },

    "tooltool_url": 'http://relengapi/tooltool/',
    'tooltool_manifest_src': "browser/config/tooltool-manifests/macosx64/cross-releng.manifest",
    "mozilla_dir": "src/",
    "simple_name_move": True,
}

