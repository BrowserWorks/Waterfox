# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

"""
module to handle Gecko profiling.
"""
from __future__ import absolute_import

import json
import os
import tempfile
import zipfile
import fnmatch

import mozfile

from logger.logger import RaptorLogger
from mozgeckoprofiler import ProfileSymbolicator, save_gecko_profile

here = os.path.dirname(os.path.realpath(__file__))
LOG = RaptorLogger(component='raptor-gecko-profile')


class GeckoProfile(object):
    """
    Handle Gecko profiling.

    This allow to collect Gecko profiling data and to zip results in one file.
    """
    def __init__(self, upload_dir, raptor_config, test_config):
        self.upload_dir = upload_dir
        self.raptor_config, self.test_config = raptor_config, test_config
        self.cleanup = True

        # Create a temporary directory into which the tests can put
        # their profiles. These files will be assembled into one big
        # zip file later on, which is put into the MOZ_UPLOAD_DIR.
        self.gecko_profile_dir = tempfile.mkdtemp()

        # each test INI can specify gecko_profile_interval and entries
        gecko_profile_interval = test_config.get('gecko_profile_interval', 1)
        gecko_profile_entries = test_config.get('gecko_profile_entries', 1000000)

        # if gecko_profile_interval was provided on the ./mach command line,
        # it should override what was specified in the test INI
        cmd_line_interval = raptor_config.get('gecko_profile_interval', None)
        if cmd_line_interval is not None:
            gecko_profile_interval = cmd_line_interval

        # if gecko_profile_entries was provided on the ./mach command line,
        # it should override what was specified in the test INI
        cmd_line_entries = raptor_config.get('gecko_profile_entries', None)
        if cmd_line_entries is not None:
            gecko_profile_entries = cmd_line_entries

        # we need symbols_path; if it wasn't passed in on cmdline, set it
        # use objdir/dist/crashreporter-symbols for symbolsPath if none provided
        if not self.raptor_config['symbols_path'] and \
           self.raptor_config['run_local'] and \
           'MOZ_DEVELOPER_OBJ_DIR' in os.environ:
            self.raptor_config['symbols_path'] = os.path.join(os.environ['MOZ_DEVELOPER_OBJ_DIR'],
                                                              'dist',
                                                              'crashreporter-symbols')

        # turn on crash reporter if we have symbols
        os.environ['MOZ_CRASHREPORTER_NO_REPORT'] = '1'
        if self.raptor_config['symbols_path']:
            os.environ['MOZ_CRASHREPORTER'] = '1'
        else:
            os.environ['MOZ_CRASHREPORTER_DISABLE'] = '1'

        # Make sure no archive already exists in the location where
        # we plan to output our profiler archive
        self.profile_arcname = os.path.join(
            self.upload_dir,
            "profile_{0}.zip".format(test_config['name'])
        )
        LOG.info("Clearing archive {0}".format(self.profile_arcname))
        mozfile.remove(self.profile_arcname)

        self.symbol_paths = {
            'FIREFOX': tempfile.mkdtemp(),
            'WINDOWS': tempfile.mkdtemp()
        }

        LOG.info("Activating gecko profiling, temp profile dir:"
                 " {0}, interval: {1}, entries: {2}"
                 .format(self.gecko_profile_dir,
                         gecko_profile_interval,
                         gecko_profile_entries))

    def _save_gecko_profile(self, symbolicator, missing_symbols_zip,
                            profile_path):
        LOG.info("Symbolicating profile at %s" % profile_path)
        try:
            with open(profile_path, 'r') as profile_file:
                profile = json.load(profile_file)
            symbolicator.dump_and_integrate_missing_symbols(
                profile,
                missing_symbols_zip)
            symbolicator.symbolicate_profile(profile)
            save_gecko_profile(profile, profile_path)
        except MemoryError:
            LOG.critical(
                "Ran out of memory while trying"
                " to symbolicate profile {0}"
                .format(profile_path)
            )
        except Exception:
            LOG.critical("Encountered an exception during profile"
                         " symbolication {0}"
                         .format(profile_path))

    def collect_profiles(self):
        """ Returns all profiles files.
        """
        res = []
        if self.raptor_config.get('browsertime'):
            topdir = self.raptor_config.get('browsertime_result_dir')
            for root, dirnames, filenames in os.walk(topdir):
                for filename in fnmatch.filter(filenames, "geckoProfile*.json"):
                    res.append(os.path.join(root, filename))
        else:
            # Collect all individual profiles that the test
            # has put into self.gecko_profile_dir.
            for profile in os.listdir(self.gecko_profile_dir):
                res.append(os.path.join(self.gecko_profile_dir, profile))
        return res

    def symbolicate(self):
        """
        Symbolicate Gecko profiling data for one pagecycle.

        """
        profiles = self.collect_profiles()
        if len(profiles) == 0:
            LOG.error("No profiles collected")
            return

        symbolicator = ProfileSymbolicator({
            # Trace-level logging (verbose)
            "enableTracing": 0,
            # Fallback server if symbol is not found locally
            "remoteSymbolServer":
                "https://symbols.mozilla.org/symbolicate/v4",
            # Maximum number of symbol files to keep in memory
            "maxCacheEntries": 2000000,
            # Frequency of checking for recent symbols to
            # cache (in hours)
            "prefetchInterval": 12,
            # Oldest file age to prefetch (in hours)
            "prefetchThreshold": 48,
            # Maximum number of library versions to pre-fetch
            # per library
            "prefetchMaxSymbolsPerLib": 3,
            # Default symbol lookup directories
            "defaultApp": "FIREFOX",
            "defaultOs": "WINDOWS",
            # Paths to .SYM files, expressed internally as a
            # mapping of app or platform names to directories
            # Note: App & OS names from requests are converted
            # to all-uppercase internally
            "symbolPaths": self.symbol_paths
        })

        if self.raptor_config.get('symbols_path') is not None:
            if mozfile.is_url(self.raptor_config['symbols_path']):
                symbolicator.integrate_symbol_zip_from_url(
                    self.raptor_config['symbols_path']
                )
            elif os.path.isfile(self.raptor_config['symbols_path']):
                symbolicator.integrate_symbol_zip_from_file(
                    self.raptor_config['symbols_path']
                )
            elif os.path.isdir(self.raptor_config['symbols_path']):
                sym_path = self.raptor_config['symbols_path']
                symbolicator.options["symbolPaths"]["FIREFOX"] = sym_path
                self.cleanup = False

        missing_symbols_zip = os.path.join(self.upload_dir,
                                           "missingsymbols.zip")

        try:
            mode = zipfile.ZIP_DEFLATED
        except NameError:
            mode = zipfile.ZIP_STORED

        with zipfile.ZipFile(self.profile_arcname, 'a', mode) as arc:
            for profile_filename in profiles:
                testname = profile_filename
                if testname.endswith(".profile"):
                    testname = testname[0:-8]
                profile_path = os.path.join(self.gecko_profile_dir, profile_filename)
                self._save_gecko_profile(symbolicator,
                                         missing_symbols_zip,
                                         profile_path)

                # Our zip will contain one directory per test,
                # and each directory will contain one or more
                # *.profile files - one for each pagecycle
                path_in_zip = \
                    os.path.join(
                        "profile_{0}".format(self.test_config['name']),
                        testname + ".profile")
                LOG.info(
                    "Adding profile {0} to archive {1}"
                    .format(path_in_zip, self.profile_arcname)
                )
                try:
                    arc.write(profile_path, path_in_zip)
                except Exception:
                    LOG.exception(
                        "Failed to copy profile {0} as {1} to"
                        " archive {2}".format(profile_path,
                                              path_in_zip,
                                              self.profile_arcname)
                    )
            # save the latest gecko profile archive to an env var, so later on
            # it can be viewed automatically via the view-gecko-profile tool
            os.environ['RAPTOR_LATEST_GECKO_PROFILE_ARCHIVE'] = self.profile_arcname

    def clean(self):
        """
        Clean up temp folders created with the instance creation.
        """
        mozfile.remove(self.gecko_profile_dir)
        if self.cleanup:
            for symbol_path in self.symbol_paths.values():
                mozfile.remove(symbol_path)
