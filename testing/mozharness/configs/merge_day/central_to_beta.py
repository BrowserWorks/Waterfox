import os

ABS_WORK_DIR = os.path.join(os.getcwd(), "build")

config = {
    "log_name": "central_to_beta",
    "version_files": [
        {"file": "browser/config/version.txt", "suffix": ""},
        {"file": "browser/config/version_display.txt", "suffix": "b1"},
        {"file": "config/milestone.txt", "suffix": ""},
    ],
    "replacements": [
        # File, from, to
        (f, "ac_add_options --with-branding=browser/branding/nightly",
        "ac_add_options --enable-official-branding")
        for f in ["browser/config/mozconfigs/linux32/l10n-mozconfig",
                  "browser/config/mozconfigs/linux64/l10n-mozconfig",
                  "browser/config/mozconfigs/win32/l10n-mozconfig",
                  "browser/config/mozconfigs/win64/l10n-mozconfig",
                  "browser/config/mozconfigs/win64-aarch64/l10n-mozconfig",
                  "browser/config/mozconfigs/macosx64/l10n-mozconfig"]
    ] + [
        # File, from, to
        ("build/mozconfig.common",
         "MOZ_REQUIRE_SIGNING=${MOZ_REQUIRE_SIGNING-0}",
         "MOZ_REQUIRE_SIGNING=${MOZ_REQUIRE_SIGNING-1}"),
        ("build/mozconfig.common",
         "# Disable enforcing that add-ons are signed by the trusted root",
         "# Enable enforcing that add-ons are signed by the trusted root")
    ],

    "vcs_share_base": os.path.join(ABS_WORK_DIR, 'hg-shared'),
    # "hg_share_base": None,
    "from_repo_url": "https://hg.mozilla.org/mozilla-central",
    "to_repo_url": "https://hg.mozilla.org/releases/mozilla-beta",

    "base_tag": "FIREFOX_BETA_%(major_version)s_BASE",
    "end_tag": "FIREFOX_BETA_%(major_version)s_END",

    "migration_behavior": "central_to_beta",

    "virtualenv_modules": [
        "requests==2.8.1",
    ],
}
