import os

config = {
    #########################################################################
    ######## ANDROID GENERIC CONFIG KEYS/VAlUES

    # note: overridden by MOZHARNESS_ACTIONS in TaskCluster tasks
    'default_actions': [
        'clobber',
        'clone-tools',
        'checkout-sources',
        'setup-mock',
        'build',
        'upload-files',
        'sendchange',
        'multi-l10n',
        'update',  # decided by query_is_nightly()
    ],
    "buildbot_json_path": "buildprops.json",
    'exes': {
        "buildbot": "/tools/buildbot/bin/buildbot",
    },
    'app_ini_path': '%(obj_dir)s/dist/bin/application.ini',
    # decides whether we want to use moz_sign_cmd in env
    'enable_signing': True,
    # mock shtuff
    'mock_mozilla_dir':  '/builds/mock_mozilla',
    'mock_target': 'mozilla-centos6-x86_64-android',
    'mock_files': [
        ('/home/cltbld/.ssh', '/home/mock_mozilla/.ssh'),
        ('/home/cltbld/.hgrc', '/builds/.hgrc'),
        ('/home/cltbld/.boto', '/builds/.boto'),
        ('/builds/relengapi.tok', '/builds/relengapi.tok'),
        ('/tools/tooltool.py', '/builds/tooltool.py'),
        ('/builds/mozilla-api.key', '/builds/mozilla-api.key'),
        ('/builds/mozilla-fennec-geoloc-api.key', '/builds/mozilla-fennec-geoloc-api.key'),
        ('/builds/crash-stats-api.token', '/builds/crash-stats-api.token'),
        ('/usr/local/lib/hgext', '/usr/local/lib/hgext'),
    ],
    'secret_files': [
        {'filename': '/builds/mozilla-fennec-geoloc-api.key',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/mozilla-fennec-geoloc-api.key',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
        {'filename': '/builds/adjust-sdk.token',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/adjust-sdk.token',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
        {'filename': '/builds/adjust-sdk-beta.token',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/adjust-sdk-beta.token',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
        {'filename': '/builds/leanplum-sdk-release.token',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/leanplum-sdk-release.token',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
        {'filename': '/builds/leanplum-sdk-beta.token',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/leanplum-sdk-beta.token',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
        {'filename': '/builds/leanplum-sdk-nightly.token',
         'secret_name': 'project/releng/gecko/build/level-%(scm-level)s/leanplum-sdk-nightly.token',
         'min_scm_level': 2, 'default': 'try-build-has-no-secrets'},
    ],
    'vcs_share_base': '/builds/hg-shared',
    'objdir': 'obj-firefox',
    'tooltool_script': ["/builds/tooltool.py"],
    'tooltool_bootstrap': "setup.sh",
    'enable_count_ctors': False,
    'enable_talos_sendchange': False,
    'enable_unittest_sendchange': True,
    'multi_locale': True,
    #########################################################################


    #########################################################################
    'base_name': 'Android 2.3 %(branch)s',
    'platform': 'android',
    'stage_platform': 'android',
    'stage_product': 'mobile',
    'publish_nightly_en_US_routes': True,
    'post_upload_include_platform': True,
    'enable_max_vsize': False,
    'use_package_as_marfile': True,
    'env': {
        'MOZBUILD_STATE_PATH': os.path.join(os.getcwd(), '.mozbuild'),
        'DISPLAY': ':2',
        'HG_SHARE_BASE_DIR': '/builds/hg-shared',
        'MOZ_OBJDIR': 'obj-firefox',
        'TINDERBOX_OUTPUT': '1',
        'TOOLTOOL_CACHE': '/home/worker/tooltool-cache',
        'TOOLTOOL_HOME': '/builds',
        'CCACHE_DIR': '/builds/ccache',
        'CCACHE_COMPRESS': '1',
        'CCACHE_UMASK': '002',
        'LC_ALL': 'C',
        'PATH': '/tools/buildbot/bin:/usr/local/bin:/bin:/usr/bin',
        'SHIP_LICENSED_FONTS': '1',
    },
    'upload_env': {
        # stage_server is dictated from build_pool_specifics.py
        'UPLOAD_HOST': '%(stage_server)s',
        'UPLOAD_USER': '%(stage_username)s',
        'UPLOAD_SSH_KEY': '/home/mock_mozilla/.ssh/%(stage_ssh_key)s',
        'UPLOAD_TO_TEMP': '1',
    },
    "check_test_env": {
        'MINIDUMP_STACKWALK': '%(abs_tools_dir)s/breakpad/linux/minidump_stackwalk',
        'MINIDUMP_SAVE_PATH': '%(base_work_dir)s/minidumps',
    },
    'mock_packages': ['autoconf213', 'mozilla-python27-mercurial', 'yasm',
                      'ccache', 'zip', "gcc472_0moz1", "gcc473_0moz1",
                      'java-1.7.0-openjdk-devel', 'zlib-devel',
                      'glibc-static', 'openssh-clients', 'mpfr',
                      'wget', 'glibc.i686', 'libstdc++.i686',
                      'zlib.i686', 'freetype-2.3.11-6.el6_1.8.x86_64',
                      'ant', 'ant-apache-regexp'
                      ],
    'src_mozconfig': 'mobile/android/config/mozconfigs/android/nightly',
    #########################################################################
}
