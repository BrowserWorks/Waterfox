config = {
    "stage_platform": "android-api-16",
    "locales_file": "src/mobile/locales/l10n-changesets.json",
    "tools_repo": "https://hg.mozilla.org/build/tools",
    "mozconfig": "src/mobile/android/config/mozconfigs/android-api-16/l10n-nightly",
    "tooltool_config": {
        "manifest": "mobile/android/config/tooltool-manifests/android/releng.manifest",
        "output_dir": "%(abs_work_dir)s/src",
    },
    "tooltool_servers": ['http://relengapi/tooltool/'],

    "upload_env": {
        'UPLOAD_HOST': 'localhost',
        'UPLOAD_PATH': '/home/worker/artifacts/',
    },
    "mozilla_dir": "src/",
    "simple_name_move": True,
}
