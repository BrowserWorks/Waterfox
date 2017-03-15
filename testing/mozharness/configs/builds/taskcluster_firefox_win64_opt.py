import os
import sys

config = {
    #########################################################################
    ######## WINDOWS GENERIC CONFIG KEYS/VAlUES
    # if you are updating this with custom 64 bit keys/values please add them
    # below under the '64 bit specific' code block otherwise, update in this
    # code block and also make sure this is synced between:
    # - taskcluster_firefox_win32_debug
    # - taskcluster_firefox_win32_opt
    # - taskcluster_firefox_win64_debug
    # - taskcluster_firefox_win64_opt

    'default_actions': [
        'clone-tools',
        'build',
        'check-test',
    ],
    'exes': {
        'python2.7': sys.executable,
        'make': [
            sys.executable,
            os.path.join(
                os.getcwd(), 'build', 'src', 'build', 'pymake', 'make.py'
            )
        ],
        'virtualenv': [
            sys.executable,
            os.path.join(
                os.getcwd(), 'build', 'src', 'python', 'virtualenv', 'virtualenv.py'
            )
        ],
        'mach-build': [
            os.path.join(os.environ['MOZILLABUILD'], 'msys', 'bin', 'bash.exe'),
            os.path.join(os.getcwd(), 'build', 'src', 'mach'),
            '--log-no-times', 'build', '-v'
        ],
    },
    'app_ini_path': '%(obj_dir)s/dist/bin/application.ini',
    # decides whether we want to use moz_sign_cmd in env
    'enable_signing': True,
    'enable_ccache': False,
    'vcs_share_base': os.path.join('y:', os.sep, 'hg-shared'),
    'objdir': 'obj-firefox',
    'tooltool_script': [
      sys.executable,
      os.path.join(os.environ['MOZILLABUILD'], 'tooltool.py')
    ],
    'tooltool_bootstrap': 'setup.sh',
    'enable_count_ctors': False,
    'max_build_output_timeout': 60 * 80,
    #########################################################################


     #########################################################################
     ###### 64 bit specific ######
    'base_name': 'WINNT_6.1_x86-64_%(branch)s',
    'platform': 'win64',
    'stage_platform': 'win64',
    'publish_nightly_en_US_routes': True,
    'env': {
        'HG_SHARE_BASE_DIR': os.path.join('y:', os.sep, 'hg-shared'),
        'MOZ_AUTOMATION': '1',
        'MOZ_CRASHREPORTER_NO_REPORT': '1',
        'MOZ_OBJDIR': 'obj-firefox',
        'PDBSTR_PATH': '/c/Program Files (x86)/Windows Kits/10/Debuggers/x64/srcsrv/pdbstr.exe',
        'TINDERBOX_OUTPUT': '1',
        'TOOLTOOL_CACHE': '/c/builds/tooltool_cache',
        'TOOLTOOL_HOME': '/c/builds',
        'MSYSTEM': 'MINGW32',
    },
    'upload_env': {
        'UPLOAD_HOST': 'localhost',
        'UPLOAD_PATH': os.path.join(os.getcwd(), 'public', 'build'),
    },
    "check_test_env": {
        'MINIDUMP_STACKWALK': '%(abs_tools_dir)s\\breakpad\\win64\\minidump_stackwalk.exe',
        'MINIDUMP_SAVE_PATH': '%(base_work_dir)s\\minidumps',
    },
    'enable_pymake': True,
    'src_mozconfig': 'browser\\config\\mozconfigs\\win64\\nightly',
    'tooltool_manifest_src': 'browser\\config\\tooltool-manifests\\win64\\releng.manifest',
    #########################################################################
}
