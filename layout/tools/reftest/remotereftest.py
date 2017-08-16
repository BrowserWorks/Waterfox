# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from contextlib import closing
import sys
import logging
import os
import time
import tempfile
import traceback
import urllib2

import mozdevice
import mozinfo
from automation import Automation
from remoteautomation import RemoteAutomation, fennecLogcatFilters

from output import OutputHandler
from runreftest import RefTest, ReftestResolver
import reftestcommandline

# We need to know our current directory so that we can serve our test files from it.
SCRIPT_DIRECTORY = os.path.abspath(os.path.realpath(os.path.dirname(__file__)))


class RemoteReftestResolver(ReftestResolver):
    def absManifestPath(self, path):
        script_abs_path = os.path.join(SCRIPT_DIRECTORY, path)
        if os.path.exists(script_abs_path):
            rv = script_abs_path
        elif os.path.exists(os.path.abspath(path)):
            rv = os.path.abspath(path)
        else:
            print >> sys.stderr, "Could not find manifest %s" % script_abs_path
            sys.exit(1)
        return os.path.normpath(rv)

    def manifestURL(self, options, path):
        # Dynamically build the reftest URL if possible, beware that args[0] should exist 'inside'
        # webroot. It's possible for this url to have a leading "..", but reftest.js will fix that
        relPath = os.path.relpath(path, SCRIPT_DIRECTORY)
        return "http://%s:%s/%s" % (options.remoteWebServer, options.httpPort, relPath)


class ReftestServer:
    """ Web server used to serve Reftests, for closer fidelity to the real web.
        It is virtually identical to the server used in mochitest and will only
        be used for running reftests remotely.
        Bug 581257 has been filed to refactor this wrapper around httpd.js into
        it's own class and use it in both remote and non-remote testing. """

    def __init__(self, automation, options, scriptDir):
        self.automation = automation
        self._utilityPath = options.utilityPath
        self._xrePath = options.xrePath
        self._profileDir = options.serverProfilePath
        self.webServer = options.remoteWebServer
        self.httpPort = options.httpPort
        self.scriptDir = scriptDir
        self.pidFile = options.pidFile
        self._httpdPath = os.path.abspath(options.httpdPath)
        if options.remoteWebServer == "10.0.2.2":
            # probably running an Android emulator and 10.0.2.2 will
            # not be visible from host
            shutdownServer = "127.0.0.1"
        else:
            shutdownServer = self.webServer
        self.shutdownURL = "http://%(server)s:%(port)s/server/shutdown" % {
                           "server": shutdownServer, "port": self.httpPort}

    def start(self):
        "Run the Refest server, returning the process ID of the server."

        env = self.automation.environment(xrePath=self._xrePath)
        env["XPCOM_DEBUG_BREAK"] = "warn"
        if self.automation.IS_WIN32:
            env["PATH"] = env["PATH"] + ";" + self._xrePath

        args = ["-g", self._xrePath,
                "-v", "170",
                "-f", os.path.join(self._httpdPath, "httpd.js"),
                "-e", "const _PROFILE_PATH = '%(profile)s';const _SERVER_PORT = "
                      "'%(port)s'; const _SERVER_ADDR ='%(server)s';" % {
                      "profile": self._profileDir.replace('\\', '\\\\'), "port": self.httpPort,
                      "server": self.webServer},
                "-f", os.path.join(self.scriptDir, "server.js")]

        xpcshell = os.path.join(self._utilityPath,
                                "xpcshell" + self.automation.BIN_SUFFIX)

        if not os.access(xpcshell, os.F_OK):
            raise Exception('xpcshell not found at %s' % xpcshell)
        if self.automation.elf_arm(xpcshell):
            raise Exception('xpcshell at %s is an ARM binary; please use '
                            'the --utility-path argument to specify the path '
                            'to a desktop version.' % xpcshell)

        self._process = self.automation.Process([xpcshell] + args, env=env)
        pid = self._process.pid
        if pid < 0:
            print "TEST-UNEXPECTED-FAIL | remotereftests.py | Error starting server."
            return 2
        self.automation.log.info("INFO | remotereftests.py | Server pid: %d", pid)

        if (self.pidFile != ""):
            f = open(self.pidFile + ".xpcshell.pid", 'w')
            f.write("%s" % pid)
            f.close()

    def ensureReady(self, timeout):
        assert timeout >= 0

        aliveFile = os.path.join(self._profileDir, "server_alive.txt")
        i = 0
        while i < timeout:
            if os.path.exists(aliveFile):
                break
            time.sleep(1)
            i += 1
        else:
            print ("TEST-UNEXPECTED-FAIL | remotereftests.py | "
                   "Timed out while waiting for server startup.")
            self.stop()
            return 1

    def stop(self):
        if hasattr(self, '_process'):
            try:
                with closing(urllib2.urlopen(self.shutdownURL)) as c:
                    c.read()

                rtncode = self._process.poll()
                if (rtncode is None):
                    self._process.terminate()
            except:
                self.automation.log.info("Failed to shutdown server at %s" %
                                         self.shutdownURL)
                traceback.print_exc()
                self._process.kill()


class RemoteReftest(RefTest):
    use_marionette = False
    remoteApp = ''
    resolver_cls = RemoteReftestResolver

    def __init__(self, automation, devicemanager, options, scriptDir):
        RefTest.__init__(self)
        self.automation = automation
        self._devicemanager = devicemanager
        self.scriptDir = scriptDir
        self.remoteApp = options.app
        self.remoteProfile = options.remoteProfile
        self.remoteTestRoot = options.remoteTestRoot
        self.remoteLogFile = options.remoteLogFile
        self.localLogName = options.localLogName
        self.pidFile = options.pidFile
        if self.automation.IS_DEBUG_BUILD:
            self.SERVER_STARTUP_TIMEOUT = 180
        else:
            self.SERVER_STARTUP_TIMEOUT = 90
        self.automation.deleteANRs()
        self.automation.deleteTombstones()

        self._populate_logger(options)
        outputHandler = OutputHandler(self.log, options.utilityPath, options.symbolsPath)
        # RemoteAutomation.py's 'messageLogger' is also used by mochitest. Mimic a mochitest
        # MessageLogger object to re-use this code path.
        outputHandler.write = outputHandler.__call__
        self.automation._processArgs['messageLogger'] = outputHandler

    def findPath(self, paths, filename=None):
        for path in paths:
            p = path
            if filename:
                p = os.path.join(p, filename)
            if os.path.exists(self.getFullPath(p)):
                return path
        return None

    def startWebServer(self, options):
        """ Create the webserver on the host and start it up """
        remoteXrePath = options.xrePath
        remoteUtilityPath = options.utilityPath
        localAutomation = Automation()
        localAutomation.IS_WIN32 = False
        localAutomation.IS_LINUX = False
        localAutomation.IS_MAC = False
        localAutomation.UNIXISH = False
        hostos = sys.platform
        if (hostos == 'mac' or hostos == 'darwin'):
            localAutomation.IS_MAC = True
        elif (hostos == 'linux' or hostos == 'linux2'):
            localAutomation.IS_LINUX = True
            localAutomation.UNIXISH = True
        elif (hostos == 'win32' or hostos == 'win64'):
            localAutomation.BIN_SUFFIX = ".exe"
            localAutomation.IS_WIN32 = True

        paths = [options.xrePath, localAutomation.DIST_BIN, self.automation._product,
                 os.path.join('..', self.automation._product)]
        options.xrePath = self.findPath(paths)
        if options.xrePath is None:
            print ("ERROR: unable to find xulrunner path for %s, "
                   "please specify with --xre-path" % (os.name))
            return 1
        paths.append("bin")
        paths.append(os.path.join("..", "bin"))

        xpcshell = "xpcshell"
        if (os.name == "nt"):
            xpcshell += ".exe"

        if (options.utilityPath):
            paths.insert(0, options.utilityPath)
        options.utilityPath = self.findPath(paths, xpcshell)
        if options.utilityPath is None:
            print ("ERROR: unable to find utility path for %s, "
                   "please specify with --utility-path" % (os.name))
            return 1

        options.serverProfilePath = tempfile.mkdtemp()
        self.server = ReftestServer(localAutomation, options, self.scriptDir)
        retVal = self.server.start()
        if retVal:
            return retVal
        retVal = self.server.ensureReady(self.SERVER_STARTUP_TIMEOUT)
        if retVal:
            return retVal

        options.xrePath = remoteXrePath
        options.utilityPath = remoteUtilityPath
        return 0

    def stopWebServer(self, options):
        self.server.stop()

    def createReftestProfile(self, options, manifest, startAfter=None):
        profile = RefTest.createReftestProfile(self,
                                               options,
                                               manifest,
                                               server=options.remoteWebServer,
                                               port=options.httpPort)
        if startAfter is not None:
            print ("WARNING: Continuing after a crash is not supported for remote "
                   "reftest yet.")
        profileDir = profile.profile

        prefs = {}
        prefs["app.update.url.android"] = ""
        prefs["browser.firstrun.show.localepicker"] = False
        prefs["reftest.remote"] = True
        prefs["datareporting.policy.dataSubmissionPolicyBypassAcceptance"] = True

        prefs["layout.css.devPixelsPerPx"] = "1.0"
        # Because Fennec is a little wacky (see bug 1156817) we need to load the
        # reftest pages at 1.0 zoom, rather than zooming to fit the CSS viewport.
        prefs["apz.allow_zooming"] = False

        # Set the extra prefs.
        profile.set_preferences(prefs)

        try:
            self._devicemanager.pushDir(profileDir, options.remoteProfile)
            self._devicemanager.chmodDir(options.remoteProfile)
        except mozdevice.DMError:
            print "Automation Error: Failed to copy profiledir to device"
            raise

        return profile

    def copyExtraFilesToProfile(self, options, profile):
        profileDir = profile.profile
        RefTest.copyExtraFilesToProfile(self, options, profile)
        try:
            self._devicemanager.pushDir(profileDir, options.remoteProfile)
            self._devicemanager.chmodDir(options.remoteProfile)
        except mozdevice.DMError:
            print "Automation Error: Failed to copy extra files to device"
            raise

    def printDeviceInfo(self, printLogcat=False):
        try:
            if printLogcat:
                logcat = self._devicemanager.getLogcat(filterOutRegexps=fennecLogcatFilters)
                print ''.join(logcat)
            print "Device info:"
            devinfo = self._devicemanager.getInfo()
            for category in devinfo:
                if type(devinfo[category]) is list:
                    print "  %s:" % category
                    for item in devinfo[category]:
                        print "     %s" % item
                else:
                    print "  %s: %s" % (category, devinfo[category])
            print "Test root: %s" % self._devicemanager.deviceRoot
        except mozdevice.DMError:
            print "WARNING: Error getting device information"

    def environment(self, **kwargs):
        return self.automation.environment(**kwargs)

    def buildBrowserEnv(self, options, profileDir):
        browserEnv = RefTest.buildBrowserEnv(self, options, profileDir)
        # remove desktop environment not used on device
        if "XPCOM_MEM_BLOAT_LOG" in browserEnv:
            del browserEnv["XPCOM_MEM_BLOAT_LOG"]
        return browserEnv

    def runApp(self, profile, binary, cmdargs, env,
               timeout=None, debuggerInfo=None,
               symbolsPath=None, options=None,
               valgrindPath=None, valgrindArgs=None, valgrindSuppFiles=None):
        status, lastTestSeen = self.automation.runApp(None, env,
                                                      binary,
                                                      profile.profile,
                                                      cmdargs,
                                                      utilityPath=options.utilityPath,
                                                      xrePath=options.xrePath,
                                                      debuggerInfo=debuggerInfo,
                                                      symbolsPath=symbolsPath,
                                                      timeout=timeout)
        return status, lastTestSeen

    def cleanup(self, profileDir):
        # Pull results back from device
        if self.remoteLogFile and \
                self._devicemanager.fileExists(self.remoteLogFile):
            self._devicemanager.getFile(self.remoteLogFile, self.localLogName)
        else:
            print "WARNING: Unable to retrieve log file (%s) from remote " \
                "device" % self.remoteLogFile
        self._devicemanager.removeDir(self.remoteProfile)
        self._devicemanager.removeDir(self.remoteTestRoot)
        RefTest.cleanup(self, profileDir)
        if (self.pidFile != ""):
            try:
                os.remove(self.pidFile)
                os.remove(self.pidFile + ".xpcshell.pid")
            except:
                print ("Warning: cleaning up pidfile '%s' was unsuccessful "
                       "from the test harness" % self.pidFile)


def run_test_harness(parser, options):
    dm_args = {
        'deviceRoot': options.remoteTestRoot,
        'host': options.deviceIP,
        'port': options.devicePort,
    }

    dm_args['adbPath'] = options.adb_path
    if not dm_args['host']:
        dm_args['deviceSerial'] = options.deviceSerial
    if options.log_tbpl_level == 'debug' or options.log_mach_level == 'debug':
        dm_args['logLevel'] = logging.DEBUG

    try:
        dm = mozdevice.DroidADB(**dm_args)
    except mozdevice.DMError:
        traceback.print_exc()
        print ("Automation Error: exception while initializing devicemanager.  "
               "Most likely the device is not in a testable state.")
        return 1

    automation = RemoteAutomation(None)
    automation.setDeviceManager(dm)

    if options.remoteProductName:
        automation.setProduct(options.remoteProductName)

    # Set up the defaults and ensure options are set
    parser.validate_remote(options, automation)

    # Check that Firefox is installed
    expected = options.app.split('/')[-1]
    installed = dm.shellCheckOutput(['pm', 'list', 'packages', expected])
    if expected not in installed:
        print "%s is not installed on this device" % expected
        return 1

    automation.setAppName(options.app)
    automation.setRemoteProfile(options.remoteProfile)
    automation.setRemoteLog(options.remoteLogFile)
    reftest = RemoteReftest(automation, dm, options, SCRIPT_DIRECTORY)
    parser.validate(options, reftest)

    if mozinfo.info['debug']:
        print "changing timeout for remote debug reftests from %s to 600 seconds" % options.timeout
        options.timeout = 600

    # Hack in a symbolic link for jsreftest
    os.system("ln -s ../jsreftest " + str(os.path.join(SCRIPT_DIRECTORY, "jsreftest")))

    # Start the webserver
    retVal = reftest.startWebServer(options)
    if retVal:
        return retVal

    procName = options.app.split('/')[-1]
    dm.killProcess(procName)
    if dm.processExist(procName):
        print "unable to kill %s before starting tests!" % procName

    if options.printDeviceInfo:
        reftest.printDeviceInfo()

# an example manifest name to use on the cli
# manifest = "http://" + options.remoteWebServer +
# "/reftests/layout/reftests/reftest-sanity/reftest.list"
    retVal = 0
    try:
        dm.recordLogcat()
        retVal = reftest.runTests(options.tests, options)
    except:
        print "Automation Error: Exception caught while running tests"
        traceback.print_exc()
        retVal = 1

    reftest.stopWebServer(options)

    if options.printDeviceInfo:
        reftest.printDeviceInfo(printLogcat=True)

    return retVal


if __name__ == "__main__":
    parser = reftestcommandline.RemoteArgumentsParser()
    options = parser.parse_args()
    sys.exit(run_test_harness(parser, options))
