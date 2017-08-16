#!/usr/bin/env python
# ***** BEGIN LICENSE BLOCK *****
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
# ***** END LICENSE BLOCK *****

import copy
import datetime
import glob
import os
import re
import sys
import signal
import socket
import subprocess
import time
import tempfile

# load modules from parent dir
sys.path.insert(1, os.path.dirname(sys.path[0]))

from mozprocess import ProcessHandler

from mozharness.base.log import FATAL
from mozharness.base.script import BaseScript, PreScriptAction, PostScriptAction
from mozharness.base.vcs.vcsbase import VCSMixin
from mozharness.mozilla.blob_upload import BlobUploadMixin, blobupload_config_options
from mozharness.mozilla.buildbot import TBPL_RETRY, EXIT_STATUS_DICT
from mozharness.mozilla.mozbase import MozbaseMixin
from mozharness.mozilla.testing.testbase import TestingMixin, testing_config_options
from mozharness.mozilla.testing.unittest import EmulatorMixin


class AndroidEmulatorTest(BlobUploadMixin, TestingMixin, EmulatorMixin, VCSMixin, BaseScript, MozbaseMixin):
    config_options = [[
        ["--test-suite"],
        {"action": "store",
         "dest": "test_suite",
        }
    ], [
        ["--adb-path"],
        {"action": "store",
         "dest": "adb_path",
         "default": None,
         "help": "Path to adb",
        }
    ], [
        ["--total-chunk"],
        {"action": "store",
         "dest": "total_chunks",
         "default": None,
         "help": "Number of total chunks",
        }
    ], [
        ["--this-chunk"],
        {"action": "store",
         "dest": "this_chunk",
         "default": None,
         "help": "Number of this chunk",
        }
    ]] + copy.deepcopy(testing_config_options) + \
        copy.deepcopy(blobupload_config_options)

    error_list = [
    ]

    virtualenv_requirements = [
    ]

    virtualenv_modules = [
    ]

    app_name = None

    def __init__(self, require_config_file=False):
        super(AndroidEmulatorTest, self).__init__(
            config_options=self.config_options,
            all_actions=['clobber',
                         'read-buildbot-config',
                         'setup-avds',
                         'start-emulator',
                         'download-and-extract',
                         'create-virtualenv',
                         'verify-emulator',
                         'install',
                         'run-tests',
                        ],
            default_actions=['clobber',
                             'start-emulator',
                             'download-and-extract',
                             'create-virtualenv',
                             'verify-emulator',
                             'install',
                             'run-tests',
                            ],
            require_config_file=require_config_file,
            config={
                'virtualenv_modules': self.virtualenv_modules,
                'virtualenv_requirements': self.virtualenv_requirements,
                'require_test_zip': True,
                # IP address of the host as seen from the emulator
                'remote_webserver': '10.0.2.2',
            }
        )

        # these are necessary since self.config is read only
        c = self.config
        abs_dirs = self.query_abs_dirs()
        self.adb_path = self.query_exe('adb')
        self.installer_url = c.get('installer_url')
        self.installer_path = c.get('installer_path')
        self.test_url = c.get('test_url')
        self.test_packages_url = c.get('test_packages_url')
        self.test_manifest = c.get('test_manifest')
        self.robocop_path = os.path.join(abs_dirs['abs_work_dir'], "robocop.apk")
        self.minidump_stackwalk_path = c.get("minidump_stackwalk_path")
        self.emulator = c.get('emulator')
        self.test_suite = c.get('test_suite')
        self.this_chunk = c.get('this_chunk')
        self.total_chunks = c.get('total_chunks')
        if self.test_suite not in self.config["suite_definitions"]:
            # accept old-style test suite name like "mochitest-3"
            m = re.match("(.*)-(\d*)", self.test_suite)
            if m:
                self.test_suite = m.group(1)
                if self.this_chunk is None:
                    self.this_chunk = m.group(2)
        self.sdk_level = None
        self.xre_path = None

    def _query_tests_dir(self):
        dirs = self.query_abs_dirs()
        try:
            test_dir = self.config["suite_definitions"][self.test_suite]["testsdir"]
        except:
            test_dir = self.test_suite
        return os.path.join(dirs['abs_test_install_dir'], test_dir)

    def query_abs_dirs(self):
        if self.abs_dirs:
            return self.abs_dirs
        abs_dirs = super(AndroidEmulatorTest, self).query_abs_dirs()
        dirs = {}
        dirs['abs_test_install_dir'] = os.path.join(
            abs_dirs['abs_work_dir'], 'tests')
        dirs['abs_xre_dir'] = os.path.join(
            abs_dirs['abs_work_dir'], 'hostutils')
        dirs['abs_modules_dir'] = os.path.join(
            dirs['abs_test_install_dir'], 'modules')
        dirs['abs_blob_upload_dir'] = os.path.join(
            abs_dirs['abs_work_dir'], 'blobber_upload_dir')
        dirs['abs_emulator_dir'] = abs_dirs['abs_work_dir']
        dirs['abs_mochitest_dir'] = os.path.join(
            dirs['abs_test_install_dir'], 'mochitest')
        dirs['abs_marionette_dir'] = os.path.join(
            dirs['abs_test_install_dir'], 'marionette', 'harness', 'marionette_harness')
        dirs['abs_marionette_tests_dir'] = os.path.join(
            dirs['abs_test_install_dir'], 'marionette', 'tests', 'testing',
            'marionette', 'harness', 'marionette_harness', 'tests')
        dirs['abs_avds_dir'] = self.config.get("avds_dir", "/home/cltbld/.android")

        for key in dirs.keys():
            if key not in abs_dirs:
                abs_dirs[key] = dirs[key]
        self.abs_dirs = abs_dirs
        return self.abs_dirs

    @PreScriptAction('create-virtualenv')
    def _pre_create_virtualenv(self, action):
        dirs = self.query_abs_dirs()
        requirements = None
        if self.test_suite == 'mochitest-media':
            # mochitest-media is the only thing that needs this
            requirements = os.path.join(dirs['abs_mochitest_dir'],
                        'websocketprocessbridge',
                        'websocketprocessbridge_requirements.txt')
        elif self.test_suite == 'marionette':
            requirements = os.path.join(dirs['abs_test_install_dir'],
                                    'config', 'marionette_requirements.txt')
        if requirements:
            self.register_virtualenv_module(requirements=[requirements],
                                            two_pass=True)

    def _launch_emulator(self):
        env = self.query_env()

        # Set $LD_LIBRARY_PATH to self.dirs['abs_work_dir'] so that
        # the emulator picks up the symlink to libGL.so.1 that we
        # constructed in start_emulator.
        env['LD_LIBRARY_PATH'] = self.abs_dirs['abs_work_dir']

        # Write a default ddms.cfg to avoid unwanted prompts
        avd_home_dir = self.abs_dirs['abs_avds_dir']
        with open(os.path.join(avd_home_dir, "ddms.cfg"), 'w') as f:
            f.write("pingOptIn=false\npingId=0\n")

        # Set environment variables to help emulator find the AVD.
        # In newer versions of the emulator, ANDROID_AVD_HOME should
        # point to the 'avd' directory.
        # For older versions of the emulator, ANDROID_SDK_HOME should
        # point to the directory containing the '.android' directory
        # containing the 'avd' directory.
        env['ANDROID_AVD_HOME'] = os.path.join(avd_home_dir, 'avd')
        env['ANDROID_SDK_HOME'] = os.path.abspath(os.path.join(avd_home_dir, '..'))

        command = [
            "emulator", "-avd", self.emulator["name"],
            "-port", str(self.emulator["emulator_port"]),
        ]
        if "emulator_extra_args" in self.config:
            command += self.config["emulator_extra_args"].split()

        tmp_file = tempfile.NamedTemporaryFile(mode='w')
        tmp_stdout = open(tmp_file.name, 'w')
        self.info("Created temp file %s." % tmp_file.name)
        self.info("Trying to start the emulator with this command: %s" % ' '.join(command))
        proc = subprocess.Popen(command, stdout=tmp_stdout, stderr=tmp_stdout, env=env)
        return {
            "process": proc,
            "tmp_file": tmp_file,
        }

    def _retry(self, max_attempts, interval, func, description, max_time = 0):
        '''
        Execute func until it returns True, up to max_attempts times, waiting for
        interval seconds between each attempt. description is logged on each attempt.
        If max_time is specified, no further attempts will be made once max_time
        seconds have elapsed; this provides some protection for the case where
        the run-time for func is long or highly variable.
        '''
        status = False
        attempts = 0
        if max_time > 0:
            end_time = datetime.datetime.now() + datetime.timedelta(seconds = max_time)
        else:
            end_time = None
        while attempts < max_attempts and not status:
            if (end_time is not None) and (datetime.datetime.now() > end_time):
                self.info("Maximum retry run-time of %d seconds exceeded; remaining attempts abandoned" % max_time)
                break
            if attempts != 0:
                self.info("Sleeping %d seconds" % interval)
                time.sleep(interval)
            attempts += 1
            self.info(">> %s: Attempt #%d of %d" % (description, attempts, max_attempts))
            status = func()
        return status

    def _run_with_timeout(self, timeout, cmd, quiet=False):
        timeout_cmd = ['timeout', '%s' % timeout] + cmd
        return self._run_proc(timeout_cmd, quiet=quiet)

    def _run_proc(self, cmd, quiet=False):
        self.info('Running %s' % subprocess.list2cmdline(cmd))
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        out, err = p.communicate()
        if out and not quiet:
            self.info('%s' % str(out.strip()))
        if err and not quiet:
            self.info('stderr: %s' % str(err.strip()))
        return out

    def _verify_adb(self):
        self.info('Verifying adb connectivity')
        self._run_with_timeout(180, [self.adb_path, 'wait-for-device'])
        return True

    def _verify_adb_device(self):
        out = self._run_with_timeout(30, [self.adb_path, 'devices'])
        if (self.emulator['device_id'] in out) and ("device" in out):
            return True
        return False

    def _is_boot_completed(self):
        boot_cmd = [self.adb_path, '-s', self.emulator['device_id'],
                    'shell', 'getprop', 'sys.boot_completed']
        out = self._run_with_timeout(30, boot_cmd)
        if out.strip() == '1':
            return True
        return False

    def _verify_emulator(self):
        adb_ok = self._verify_adb()
        if not adb_ok:
            self.warning('Unable to communicate with adb')
            return False
        adb_device_ok = self._retry(4, 30, self._verify_adb_device, "Verify emulator visible to adb")
        if not adb_device_ok:
            self.warning('Unable to communicate with emulator via adb')
            return False
        boot_ok = self._retry(30, 10, self._is_boot_completed, "Verify Android boot completed", max_time = 330)
        if not boot_ok:
            self.warning('Unable to verify Android boot completion')
            return False
        return True

    def _verify_emulator_and_restart_on_fail(self):
        emulator_ok = self._verify_emulator()
        if not emulator_ok:
            self._dump_host_state()
            self._screenshot("emulator-startup-screenshot-")
            self._kill_processes(self.config["emulator_process_name"])
            self._run_proc(['ps', '-ef'])
            self._dump_emulator_log()
            # remove emulator tmp files
            for dir in glob.glob("/tmp/android-*"):
                self.rmtree(dir)
            self._restart_adbd()
            time.sleep(5)
            self.emulator_proc = self._launch_emulator()
        return emulator_ok

    def _install_fennec_apk(self):
        install_ok = False
        if int(self.sdk_level) >= 23:
            cmd = [self.adb_path, '-s', self.emulator['device_id'], 'install', '-r', '-g', self.installer_path]
        else:
            cmd = [self.adb_path, '-s', self.emulator['device_id'], 'install', '-r', self.installer_path]
        out = self._run_with_timeout(300, cmd)
        if 'Success' in out:
            install_ok = True
        return install_ok

    def _install_robocop_apk(self):
        install_ok = False
        if int(self.sdk_level) >= 23:
            cmd = [self.adb_path, '-s', self.emulator['device_id'], 'install', '-r', '-g', self.robocop_path]
        else:
            cmd = [self.adb_path, '-s', self.emulator['device_id'], 'install', '-r', self.robocop_path]
        out = self._run_with_timeout(300, cmd)
        if 'Success' in out:
            install_ok = True
        return install_ok

    def _dump_host_state(self):
        self._run_proc(['ps', '-ef'])
        self._run_proc(['netstat', '-a', '-p', '-n', '-t', '-u'])

    def _dump_emulator_log(self):
        self.info("##### %s emulator log begins" % self.emulator["name"])
        output = self.read_from_file(self.emulator_proc["tmp_file"].name, verbose=False)
        if output:
            self.info(output)
        self.info("##### %s emulator log ends" % self.emulator["name"])

    def _kill_processes(self, process_name):
        p = subprocess.Popen(['ps', '-A'], stdout=subprocess.PIPE)
        out, err = p.communicate()
        self.info("Let's kill every process called %s" % process_name)
        for line in out.splitlines():
            if process_name in line:
                pid = int(line.split(None, 1)[0])
                self.info("Killing pid %d." % pid)
                os.kill(pid, signal.SIGKILL)

    def _restart_adbd(self):
        self._run_with_timeout(30, [self.adb_path, 'kill-server'])
        self._run_with_timeout(30, [self.adb_path, 'start-server'])

    def _screenshot(self, prefix):
        """
           Save a screenshot of the entire screen to the blob upload directory.
        """
        dirs = self.query_abs_dirs()
        utility = os.path.join(self.xre_path, "screentopng")
        if not os.path.exists(utility):
            self.warning("Unable to take screenshot: %s does not exist" % utility)
            return
        try:
            tmpfd, filename = tempfile.mkstemp(prefix=prefix, suffix='.png',
                dir=dirs['abs_blob_upload_dir'])
            os.close(tmpfd)
            self.info("Taking screenshot with %s; saving to %s" % (utility, filename))
            subprocess.call([utility, filename], env=self.query_env())
        except OSError, err:
            self.warning("Failed to take screenshot: %s" % err.strerror)

    def _query_package_name(self):
        if self.app_name is None:
            # Find appname from package-name.txt - assumes download-and-extract
            # has completed successfully.
            # The app/package name will typically be org.mozilla.fennec,
            # but org.mozilla.firefox for release builds, and there may be
            # other variations. 'aapt dump badging <apk>' could be used as an
            # alternative to package-name.txt, but introduces a dependency
            # on aapt, found currently in the Android SDK build-tools component.
            apk_dir = self.abs_dirs['abs_work_dir']
            self.apk_path = os.path.join(apk_dir, self.installer_path)
            unzip = self.query_exe("unzip")
            package_path = os.path.join(apk_dir, 'package-name.txt')
            unzip_cmd = [unzip, '-q', '-o',  self.apk_path]
            self.run_command(unzip_cmd, cwd=apk_dir, halt_on_failure=True)
            self.app_name = str(self.read_from_file(package_path, verbose=True)).rstrip()
        return self.app_name

    def preflight_install(self):
        # in the base class, this checks for mozinstall, but we don't use it
        pass

    def _build_command(self):
        c = self.config
        dirs = self.query_abs_dirs()

        if self.test_suite not in self.config["suite_definitions"]:
            self.fatal("Key '%s' not defined in the config!" % self.test_suite)

        cmd = [
            self.query_python_path('python'),
            '-u',
            os.path.join(
                self._query_tests_dir(),
                self.config["suite_definitions"][self.test_suite]["run_filename"]
            ),
        ]

        raw_log_file = os.path.join(dirs['abs_blob_upload_dir'],
                                    '%s_raw.log' % self.test_suite)

        error_summary_file = os.path.join(dirs['abs_blob_upload_dir'],
                                          '%s_errorsummary.log' % self.test_suite)
        str_format_values = {
            'remote_webserver': c['remote_webserver'],
            'xre_path': self.xre_path,
            'utility_path': self.xre_path,
            'http_port': self.emulator['http_port'],
            'ssl_port': self.emulator['ssl_port'],
            'certs_path': os.path.join(dirs['abs_work_dir'], 'tests/certs'),
            # TestingMixin._download_and_extract_symbols() will set
            # self.symbols_path when downloading/extracting.
            'symbols_path': self.symbols_path,
            'modules_dir': dirs['abs_modules_dir'],
            'installer_path': self.installer_path,
            'raw_log_file': raw_log_file,
            'error_summary_file': error_summary_file,
            # marionette options
            'address': c.get('marionette_address'),
            'gecko_log': os.path.join(dirs["abs_blob_upload_dir"], 'gecko.log'),
            'test_manifest': os.path.join(
                dirs['abs_marionette_tests_dir'],
                self.config.get('marionette_test_manifest', '')
            ),
        }
        for option in self.config["suite_definitions"][self.test_suite]["options"]:
            opt = option.split('=')[0]
            # override configured chunk options with script args, if specified
            if opt == '--this-chunk' and self.this_chunk is not None:
                continue
            if opt == '--total-chunks' and self.total_chunks is not None:
                continue
            if '%(app)' in option:
                # only query package name if requested
                cmd.extend([option % {'app' : self._query_package_name()}])
            else:
                cmd.extend([option % str_format_values])

        if self.this_chunk is not None:
            cmd.extend(['--this-chunk', self.this_chunk])
        if self.total_chunks is not None:
            cmd.extend(['--total-chunks', self.total_chunks])

        try_options, try_tests = self.try_args(self.test_suite)
        cmd.extend(try_options)
        cmd.extend(self.query_tests_args(
            self.config["suite_definitions"][self.test_suite].get("tests"),
            None,
            try_tests))

        return cmd

    def _get_repo_url(self, path):
        """
           Return a url for a file (typically a tooltool manifest) in this hg repo
           and using this revision (or mozilla-central/default if repo/rev cannot
           be determined).

           :param path specifies the directory path to the file of interest.
        """
        if 'GECKO_HEAD_REPOSITORY' in os.environ and 'GECKO_HEAD_REV' in os.environ:
            # probably taskcluster
            repo = os.environ['GECKO_HEAD_REPOSITORY']
            revision = os.environ['GECKO_HEAD_REV']
        elif self.buildbot_config and 'properties' in self.buildbot_config:
            # probably buildbot
            repo = 'https://hg.mozilla.org/%s' % self.buildbot_config['properties']['repo_path']
            revision = self.buildbot_config['properties']['revision']
        else:
            # something unexpected!
            repo = 'https://hg.mozilla.org/mozilla-central'
            revision = 'default'
            self.warning('Unable to find repo/revision for manifest; using mozilla-central/default')
        url = '%s/raw-file/%s/%s' % (
            repo,
            revision,
            path)
        return url

    def _tooltool_fetch(self, url, dir):
        c = self.config

        manifest_path = self.download_file(
            url,
            file_name='releng.manifest',
            parent_dir=dir
        )

        if not os.path.exists(manifest_path):
            self.fatal("Could not retrieve manifest needed to retrieve "
                       "artifacts from %s" % manifest_path)

        self.tooltool_fetch(manifest_path,
                            output_dir=dir,
                            cache=c.get("tooltool_cache", None))

    ##########################################
    ### Actions for AndroidEmulatorTest ###
    ##########################################
    def setup_avds(self):
        '''
        If tooltool cache mechanism is enabled, the cached version is used by
        the fetch command. If the manifest includes an "unpack" field, tooltool
        will unpack all compressed archives mentioned in the manifest.
        '''
        c = self.config
        dirs = self.query_abs_dirs()

        # FIXME
        # Clobbering and re-unpacking would not be needed if we had a way to
        # check whether the unpacked content already present match the
        # contents of the tar ball
        self.rmtree(dirs['abs_avds_dir'])
        self.mkdir_p(dirs['abs_avds_dir'])
        if 'avd_url' in c:
            # Intended for experimental setups to evaluate an avd prior to
            # tooltool deployment.
            url = c['avd_url']
            self.download_unpack(url, dirs['abs_avds_dir'])
        else:
            url = self._get_repo_url(c["tooltool_manifest_path"])
            self._tooltool_fetch(url, dirs['abs_avds_dir'])

        avd_home_dir = self.abs_dirs['abs_avds_dir']
        if avd_home_dir != "/home/cltbld/.android":
            # Modify the downloaded avds to point to the right directory.
            cmd = [
                'bash', '-c',
                'sed -i "s|/home/cltbld/.android|%s|" %s/test-*.ini' %
                (avd_home_dir, os.path.join(avd_home_dir, 'avd'))
            ]
            proc = ProcessHandler(cmd)
            proc.run()
            proc.wait()

    def start_emulator(self):
        '''
        Starts the emulator
        '''
        if 'emulator_url' in self.config or 'emulator_manifest' in self.config or 'tools_manifest' in self.config:
            self.install_emulator()

        if not os.path.isfile(self.adb_path):
            self.fatal("The adb binary '%s' is not a valid file!" % self.adb_path)
        self._restart_adbd()

        if not self.config.get("developer_mode"):
            # We kill compiz because it sometimes prevents us from starting the emulator
            self._kill_processes("compiz")
            self._kill_processes("xpcshell")

        # We add a symlink for libGL.so because the emulator dlopen()s it by that name
        # even though the installed library on most systems without dev packages is
        # libGL.so.1
        linkfile = os.path.join(self.abs_dirs['abs_work_dir'], "libGL.so")
        self.info("Attempting to establish symlink for %s" % linkfile)
        try:
            os.unlink(linkfile)
        except OSError:
            pass
        for libdir in ["/usr/lib/x86_64-linux-gnu/mesa",
                       "/usr/lib/i386-linux-gnu/mesa",
                       "/usr/lib/mesa"]:
            libfile = os.path.join(libdir, "libGL.so.1")
            if os.path.exists(libfile):
                self.info("Symlinking %s -> %s" % (linkfile, libfile))
                self.mkdir_p(self.abs_dirs['abs_work_dir'])
                os.symlink(libfile, linkfile)
                break
        self.emulator_proc = self._launch_emulator()

    def _dump_perf_info(self):
        '''
        Dump some host and emulator performance-related information
        to an artifact file, to help understand why jobs run slowly
        sometimes. This is hopefully a temporary diagnostic.
        See bug 1321605.
        '''
        dir = self.query_abs_dirs()['abs_blob_upload_dir']
        perf_path = os.path.join(dir, "android-performance.log")
        with open(perf_path, "w") as f:

            f.write('\n\nHost /proc/cpuinfo:\n')
            out = self._run_proc(['cat', '/proc/cpuinfo'], quiet=True)
            f.write(out)

            f.write('\n\nHost /proc/meminfo:\n')
            out = self._run_proc(['cat', '/proc/meminfo'], quiet=True)
            f.write(out)

            f.write('\n\nHost process list:\n')
            out = self._run_proc(['ps', '-ef'], quiet=True)
            f.write(out)

            f.write('\n\nEmulator /proc/cpuinfo:\n')
            cmd = [self.adb_path, '-s', self.emulator['device_id'],
                    'shell', 'cat', '/proc/cpuinfo']
            out = self._run_with_timeout(30, cmd, quiet=True)
            f.write(out)

            f.write('\n\nEmulator /proc/meminfo:\n')
            cmd = [self.adb_path, '-s', self.emulator['device_id'],
                    'shell', 'cat', '/proc/meminfo']
            out = self._run_with_timeout(30, cmd, quiet=True)
            f.write(out)

            f.write('\n\nEmulator process list:\n')
            cmd = [self.adb_path, '-s', self.emulator['device_id'],
                    'shell', 'ps']
            out = self._run_with_timeout(30, cmd, quiet=True)
            f.write(out)

    def verify_emulator(self):
        '''
        Check to see if the emulator can be contacted via adb.
        If any communication attempt fails, kill the emulator, re-launch, and re-check.
        '''
        self.mkdir_p(self.query_abs_dirs()['abs_blob_upload_dir'])
        max_restarts = 5
        emulator_ok = self._retry(max_restarts, 10, self._verify_emulator_and_restart_on_fail, "Check emulator")
        if not emulator_ok:
            self.fatal('INFRA-ERROR: Unable to start emulator after %d attempts' % max_restarts,
                EXIT_STATUS_DICT[TBPL_RETRY])
        self._dump_perf_info()
        # Start logcat for the emulator. The adb process runs until the
        # corresponding emulator is killed. Output is written directly to
        # the blobber upload directory so that it is uploaded automatically
        # at the end of the job.
        logcat_filename = 'logcat-%s.log' % self.emulator["device_id"]
        logcat_path = os.path.join(self.abs_dirs['abs_blob_upload_dir'], logcat_filename)
        logcat_cmd = '%s -s %s logcat -v threadtime Trace:S StrictMode:S ExchangeService:S > %s &' % \
            (self.adb_path, self.emulator["device_id"], logcat_path)
        self.info(logcat_cmd)
        os.system(logcat_cmd)
        # Get a post-boot emulator process list for diagnostics
        ps_cmd = [self.adb_path, '-s', self.emulator["device_id"], 'shell', 'ps']
        self._run_with_timeout(30, ps_cmd)

    def download_and_extract(self):
        """
        Download and extract fennec APK, tests.zip, host utils, and robocop (if required).
        """
        super(AndroidEmulatorTest, self).download_and_extract(suite_categories=[self.test_suite])
        dirs = self.query_abs_dirs()
        if self.test_suite.startswith('robocop'):
            robocop_url = self.installer_url[:self.installer_url.rfind('/')] + '/robocop.apk'
            self.info("Downloading robocop...")
            self.download_file(robocop_url, 'robocop.apk', dirs['abs_work_dir'], error_level=FATAL)
        self.rmtree(dirs['abs_xre_dir'])
        self.mkdir_p(dirs['abs_xre_dir'])
        if self.config["hostutils_manifest_path"]:
            url = self._get_repo_url(self.config["hostutils_manifest_path"])
            self._tooltool_fetch(url, dirs['abs_xre_dir'])
            for p in glob.glob(os.path.join(dirs['abs_xre_dir'], 'host-utils-*')):
                if os.path.isdir(p) and os.path.isfile(os.path.join(p, 'xpcshell')):
                    self.xre_path = p
            if not self.xre_path:
                self.fatal("xre path not found in %s" % dirs['abs_xre_dir'])
        else:
            self.fatal("configure hostutils_manifest_path!")

    def install(self):
        """
        Install APKs on the emulator
        """
        install_needed = self.config["suite_definitions"][self.test_suite].get("install")
        if install_needed == False:
            self.info("Skipping apk installation for %s" % self.test_suite)
            return

        assert self.installer_path is not None, \
            "Either add installer_path to the config or use --installer-path."

        self.sdk_level = self._run_with_timeout(30, [self.adb_path, '-s', self.emulator['device_id'],
            'shell', 'getprop', 'ro.build.version.sdk'])

        # Install Fennec
        install_ok = self._retry(3, 30, self._install_fennec_apk, "Install app APK")
        if not install_ok:
            self.fatal('INFRA-ERROR: Failed to install %s on %s' %
                (self.installer_path, self.emulator["name"]), EXIT_STATUS_DICT[TBPL_RETRY])

        # Install Robocop if required
        if self.test_suite.startswith('robocop'):
            install_ok = self._retry(3, 30, self._install_robocop_apk, "Install Robocop APK")
            if not install_ok:
                self.fatal('INFRA-ERROR: Failed to install %s on %s' %
                    (self.robocop_path, self.emulator["name"]), EXIT_STATUS_DICT[TBPL_RETRY])

        self.info("Finished installing apps for %s" % self.emulator["name"])

    def run_tests(self):
        """
        Run the tests
        """
        cmd = self._build_command()

        try:
            cwd = self._query_tests_dir()
        except:
            self.fatal("Don't know how to run --test-suite '%s'!" % self.test_suite)
        env = self.query_env()
        if self.query_minidump_stackwalk():
            env['MINIDUMP_STACKWALK'] = self.minidump_stackwalk_path
        env['MOZ_UPLOAD_DIR'] = self.query_abs_dirs()['abs_blob_upload_dir']
        env['MINIDUMP_SAVE_PATH'] = self.query_abs_dirs()['abs_blob_upload_dir']
        env['RUST_BACKTRACE'] = '1'

        self.info("Running on %s the command %s" % (self.emulator["name"], subprocess.list2cmdline(cmd)))
        self.info("##### %s log begins" % self.test_suite)

        # TinderBoxPrintRe does not know about the '-debug' categories
        aliases = {
            'reftest-debug': 'reftest',
            'jsreftest-debug': 'jsreftest',
            'crashtest-debug': 'crashtest',
        }
        suite_category = aliases.get(self.test_suite, self.test_suite)
        parser = self.get_test_output_parser(
            suite_category,
            config=self.config,
            log_obj=self.log_obj,
            error_list=self.error_list)
        self.run_command(cmd, cwd=cwd, env=env, output_parser=parser)
        tbpl_status, log_level = parser.evaluate_parser(0)
        parser.append_tinderboxprint_line(self.test_suite)

        self.info("##### %s log ends" % self.test_suite)
        self._dump_emulator_log()
        self.buildbot_status(tbpl_status, level=log_level)

    @PostScriptAction('run-tests')
    def stop_emulator(self, action, success=None):
        '''
        Report emulator health, then make sure that the emulator has been stopped
        '''
        self._verify_emulator()
        self._kill_processes(self.config["emulator_process_name"])

    def upload_blobber_files(self):
        '''
        Override BlobUploadMixin.upload_blobber_files to ensure emulator is killed
        first (if the emulator is still running, logcat may still be running, which
        may lock the blob upload directory, causing a hang).
        '''
        if self.config.get('blob_upload_branch'):
            # Except on interactive workers, we want the emulator to keep running
            # after the script is finished. So only kill it if blobber would otherwise
            # have run anyway (it doesn't get run on interactive workers).
            self._kill_processes(self.config["emulator_process_name"])
        super(AndroidEmulatorTest, self).upload_blobber_files()

if __name__ == '__main__':
    emulatorTest = AndroidEmulatorTest()
    emulatorTest.run_and_exit()
