# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, unicode_literals

import logging
import os
import subprocess

from mach.decorators import (
    Command,
    CommandArgument,
    CommandProvider,
)
from mozbuild.base import (
    MachCommandBase,
    MachCommandConditions as conditions,
)


def is_valgrind_build(cls):
    '''Must be a build with --enable-valgrind and --disable-jemalloc.'''
    defines = cls.config_environment.defines
    return 'MOZ_VALGRIND' in defines and 'MOZ_MEMORY' not in defines


@CommandProvider
class MachCommands(MachCommandBase):
    '''
    Run Valgrind tests.
    '''
    def __init__(self, context):
        MachCommandBase.__init__(self, context)

    @Command('valgrind-test', category='testing',
        conditions=[conditions.is_firefox, is_valgrind_build],
        description='Run the Valgrind test job (memory-related errors).')
    @CommandArgument('--suppressions', default=[], action='append',
        metavar='FILENAME',
        help='Specify a suppression file for Valgrind to use. Use '
            '--suppression multiple times to specify multiple suppression '
            'files.')
    def valgrind_test(self, suppressions):
        import json
        import sys
        import tempfile

        from mozbuild.base import MozbuildObject
        from mozfile import TemporaryDirectory
        from mozhttpd import MozHttpd
        from mozprofile import FirefoxProfile, Preferences
        from mozprofile.permissions import ServerLocations
        from mozrunner import FirefoxRunner
        from mozrunner.utils import findInPath
        from valgrind.output_handler import OutputHandler

        build_dir = os.path.join(self.topsrcdir, 'build')

        # XXX: currently we just use the PGO inputs for Valgrind runs.  This may
        # change in the future.
        httpd = MozHttpd(docroot=os.path.join(build_dir, 'pgo'))
        httpd.start(block=False)

        with TemporaryDirectory() as profilePath:
            #TODO: refactor this into mozprofile
            prefpath = os.path.join(self.topsrcdir, 'testing', 'profiles', 'prefs_general.js')
            prefs = {}
            prefs.update(Preferences.read_prefs(prefpath))
            interpolation = { 'server': '%s:%d' % httpd.httpd.server_address,
                              'OOP': 'false'}
            prefs = json.loads(json.dumps(prefs) % interpolation)
            for pref in prefs:
                prefs[pref] = Preferences.cast(prefs[pref])

            quitter = os.path.join(self.topsrcdir, 'tools', 'quitter', 'quitter@mozilla.org.xpi')

            locations = ServerLocations()
            locations.add_host(host='127.0.0.1',
                               port=httpd.httpd.server_port,
                               options='primary')

            profile = FirefoxProfile(profile=profilePath,
                                     preferences=prefs,
                                     addons=[quitter],
                                     locations=locations)

            firefox_args = [httpd.get_url()]

            env = os.environ.copy()
            env['G_SLICE'] = 'always-malloc'
            env['MOZ_CC_RUN_DURING_SHUTDOWN'] = '1'
            env['MOZ_CRASHREPORTER_NO_REPORT'] = '1'
            env['XPCOM_DEBUG_BREAK'] = 'warn'

            env.update(self.extra_environment_variables)

            outputHandler = OutputHandler(self.log)
            kp_kwargs = {'processOutputLine': [outputHandler]}

            valgrind = 'valgrind'
            if not os.path.exists(valgrind):
                valgrind = findInPath(valgrind)

            valgrind_args = [
                valgrind,
                '--smc-check=all-non-file',
                '--vex-iropt-register-updates=allregs-at-mem-access',
                '--gen-suppressions=all',
                '--num-callers=36',
                '--leak-check=full',
                '--show-possibly-lost=no',
                '--track-origins=yes',
                '--trace-children=yes',
                '-v',  # Enable verbosity to get the list of used suppressions
                # Avoid excessive delays in the presence of spinlocks.
                # See bug 1309851.
                '--fair-sched=yes',
            ]

            for s in suppressions:
                valgrind_args.append('--suppressions=' + s)

            supps_dir = os.path.join(build_dir, 'valgrind')
            supps_file1 = os.path.join(supps_dir, 'cross-architecture.sup')
            valgrind_args.append('--suppressions=' + supps_file1)

            # MACHTYPE is an odd bash-only environment variable that doesn't
            # show up in os.environ, so we have to get it another way.
            machtype = subprocess.check_output(['bash', '-c', 'echo $MACHTYPE']).rstrip()
            supps_file2 = os.path.join(supps_dir, machtype + '.sup')
            if os.path.isfile(supps_file2):
                valgrind_args.append('--suppressions=' + supps_file2)

            exitcode = None
            timeout = 1800
            try:
                runner = FirefoxRunner(profile=profile,
                                       binary=self.get_binary_path(),
                                       cmdargs=firefox_args,
                                       env=env,
                                       process_args=kp_kwargs)
                runner.start(debug_args=valgrind_args)
                exitcode = runner.wait(timeout=timeout)

            finally:
                errs = outputHandler.error_count
                supps = outputHandler.suppression_count
                if errs != supps:
                    status = 1  # turns the TBPL job orange
                    self.log(logging.ERROR, 'valgrind-fail-parsing',
                             {'errs': errs, 'supps': supps},
                             'TEST-UNEXPECTED-FAIL | valgrind-test | error parsing: {errs} errors seen, but {supps} generated suppressions seen')

                elif errs == 0:
                    status = 0
                    self.log(logging.INFO, 'valgrind-pass', {},
                             'TEST-PASS | valgrind-test | valgrind found no errors')
                else:
                    status = 1  # turns the TBPL job orange
                    # We've already printed details of the errors.

                if exitcode == None:
                    status = 2  # turns the TBPL job red
                    self.log(logging.ERROR, 'valgrind-fail-timeout',
                             {'timeout': timeout},
                             'TEST-UNEXPECTED-FAIL | valgrind-test | Valgrind timed out (reached {timeout} second limit)')
                elif exitcode != 0:
                    status = 2  # turns the TBPL job red
                    self.log(logging.ERROR, 'valgrind-fail-errors', {},
                             'TEST-UNEXPECTED-FAIL | valgrind-test | non-zero exit code from Valgrind')

                httpd.stop()

            return status
