config = {
    "nightly_build": True,
    "branch": "mozilla-release",
    "en_us_binary_url": "http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-release/",
    "update_channel": "release",

    # l10n
    "hg_l10n_base": "https://hg.mozilla.org/releases/l10n/mozilla-release",

    # repositories
    "mozilla_dir": "mozilla-release",
    "repos": [{
        "vcs": "hg",
        "repo": "https://hg.mozilla.org/build/tools",
        "branch": "default",
        "dest": "tools",
    }, {
        "vcs": "hg",
        "repo": "https://hg.mozilla.org/releases/mozilla-release",
        "revision": "%(revision)s",
        "dest": "mozilla-release",
    }],
    # purge options
    'purge_minsize': 12,
    'is_automation': True,
    'default_actions': [
        "clobber",
        "pull",
        "clone-locales",
        "list-locales",
        "setup",
        "repack",
        "taskcluster-upload",
        "summary",
    ],
}
