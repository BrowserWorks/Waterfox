config = {
    "nightly_build": True,
    "branch": "mozilla-aurora",
    "en_us_binary_url": "http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-aurora/",
    "update_channel": "aurora",

    # l10n
    "hg_l10n_base": "https://hg.mozilla.org/releases/l10n/mozilla-aurora",

    # mar
    "mar_tools_url": "http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-aurora/mar-tools/%(platform)s",

    # repositories
    "mozilla_dir": "mozilla-aurora",
    "repos": [{
        "vcs": "hg",
        "repo": "https://hg.mozilla.org/build/tools",
        "branch": "default",
        "dest": "tools",
    }, {
        "vcs": "hg",
        "repo": "https://hg.mozilla.org/releases/mozilla-aurora",
        "branch": "default",
        "dest": "mozilla-aurora",
    }],
    # purge options
    'is_automation': True,
}
