#!/usr/bin/env python

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

import os
import subprocess
import sys
import unittest
import proctest
from mozprocess import processhandler

here = os.path.dirname(os.path.abspath(__file__))


def make_proclaunch(aDir):
    """
        Makes the proclaunch executable.
        Params:
            aDir - the directory in which to issue the make commands
        Returns:
            the path to the proclaunch executable that is generated
    """

    if sys.platform == "win32":
        exepath = os.path.join(aDir, "proclaunch.exe")
    else:
        exepath = os.path.join(aDir, "proclaunch")

    # remove the launcher, if it already exists
    # otherwise, if the make fails you may not notice
    if os.path.exists(exepath):
        os.remove(exepath)

    # Ideally make should take care of both calls through recursion, but since it doesn't,
    # on windows anyway (to file?), let's just call out both targets explicitly.
    for command in [["make", "-C", "iniparser"],
                    ["make"]]:
        process = subprocess.Popen(command, stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE, cwd=aDir)
        stdout, stderr = process.communicate()
        if process.returncode:
            # SomethingBadHappen; print all the things
            print "%s: exit %d" % (command, process.returncode)
            print "stdout:\n%s" % stdout
            print "stderr:\n%s" % stderr
            raise subprocess.CalledProcessError(process.returncode, command, stdout)

    # ensure the launcher now exists
    if not os.path.exists(exepath):
        raise AssertionError("proclaunch executable '%s' "
                             "does not exist (sys.platform=%s)" % (exepath, sys.platform))
    return exepath


class ProcTest(proctest.ProcTest):

    # whether to remove created files on exit
    cleanup = os.environ.get('CLEANUP', 'true').lower() in ('1', 'true')

    @classmethod
    def setUpClass(cls):
        cls.proclaunch = make_proclaunch(here)

    @classmethod
    def tearDownClass(cls):
        del cls.proclaunch
        if not cls.cleanup:
            return
        files = [('proclaunch',),
                 ('proclaunch.exe',),
                 ('iniparser', 'dictionary.o'),
                 ('iniparser', 'iniparser.lib'),
                 ('iniparser', 'iniparser.o'),
                 ('iniparser', 'libiniparser.a'),
                 ('iniparser', 'libiniparser.so.0'),
                 ]
        files = [os.path.join(here, *path) for path in files]
        errors = []
        for path in files:
            if os.path.exists(path):
                try:
                    os.remove(path)
                except OSError as e:
                    errors.append(str(e))
        if errors:
            raise OSError("Error(s) encountered tearing down "
                          "%s.%s:\n%s" % (cls.__module__, cls.__name__, '\n'.join(errors)))

    def test_process_normal_finish(self):
        """Process is started, runs to completion while we wait for it"""

        p = processhandler.ProcessHandler([self.proclaunch, "process_normal_finish.ini"],
                                          cwd=here)
        p.run()
        p.wait()

        self.determine_status(p)

    def test_commandline_no_args(self):
        """Command line is reported correctly when no arguments are specified"""
        p = processhandler.ProcessHandler(self.proclaunch, cwd=here)
        self.assertEqual(p.commandline, self.proclaunch)

    def test_commandline_overspecified(self):
        """Command line raises an exception when the arguments are specified ambiguously"""
        err = None
        try:
            processhandler.ProcessHandler([self.proclaunch, "process_normal_finish.ini"],
                                          args=["1", "2", "3"],
                                          cwd=here)
        except TypeError, e:
            err = e

        self.assertTrue(err)

    def test_commandline_from_list(self):
        """Command line is reported correctly when command and arguments are specified in a list"""
        p = processhandler.ProcessHandler([self.proclaunch, "process_normal_finish.ini"],
                                          cwd=here)
        self.assertEqual(p.commandline, self.proclaunch + ' process_normal_finish.ini')

    def test_commandline_over_specified(self):
        """Command line raises an exception when the arguments are specified ambiguously"""
        err = None
        try:
            processhandler.ProcessHandler([self.proclaunch, "process_normal_finish.ini"],
                                          args=["1", "2", "3"],
                                          cwd=here)
        except TypeError, e:
            err = e

        self.assertTrue(err)

    def test_commandline_from_args(self):
        """Command line is reported correctly when arguments are specified in a dedicated list"""
        p = processhandler.ProcessHandler(self.proclaunch,
                                          args=["1", "2", "3"],
                                          cwd=here)
        self.assertEqual(p.commandline, self.proclaunch + ' 1 2 3')

    def test_process_wait(self):
        """Process is started runs to completion while we wait indefinitely"""

        p = processhandler.ProcessHandler([self.proclaunch,
                                           "process_waittimeout_10s.ini"],
                                          cwd=here)
        p.run()
        p.wait()

        self.determine_status(p)

    def test_process_timeout(self):
        """ Process is started, runs but we time out waiting on it
            to complete
        """
        p = processhandler.ProcessHandler([self.proclaunch, "process_waittimeout.ini"],
                                          cwd=here)
        p.run(timeout=10)
        p.wait()

        self.determine_status(p, False, ['returncode', 'didtimeout'])

    def test_process_timeout_no_kill(self):
        """ Process is started, runs but we time out waiting on it
            to complete. Process should not be killed.
        """
        p = None

        def timeout_handler():
            self.assertEqual(p.proc.poll(), None)
            p.kill()
        p = processhandler.ProcessHandler([self.proclaunch, "process_waittimeout.ini"],
                                          cwd=here,
                                          onTimeout=(timeout_handler,),
                                          kill_on_timeout=False)
        p.run(timeout=1)
        p.wait()
        self.assertTrue(p.didTimeout)

        self.determine_status(p, False, ['returncode', 'didtimeout'])

    def test_process_waittimeout(self):
        """
        Process is started, then wait is called and times out.
        Process is still running and didn't timeout
        """
        p = processhandler.ProcessHandler([self.proclaunch,
                                           "process_waittimeout_10s.ini"],
                                          cwd=here)

        p.run()
        p.wait(timeout=5)

        self.determine_status(p, True, ())

    def test_process_waitnotimeout(self):
        """ Process is started, runs to completion before our wait times out
        """
        p = processhandler.ProcessHandler([self.proclaunch,
                                           "process_waittimeout_10s.ini"],
                                          cwd=here)
        p.run(timeout=30)
        p.wait()

        self.determine_status(p)

    def test_process_kill(self):
        """Process is started, we kill it"""

        p = processhandler.ProcessHandler([self.proclaunch, "process_normal_finish.ini"],
                                          cwd=here)
        p.run()
        p.kill()

        self.determine_status(p)

    def test_process_output_twice(self):
        """
        Process is started, then processOutput is called a second time explicitly
        """
        p = processhandler.ProcessHandler([self.proclaunch,
                                           "process_waittimeout_10s.ini"],
                                          cwd=here)

        p.run()
        p.processOutput(timeout=5)
        p.wait()

        self.determine_status(p, False, ())


if __name__ == '__main__':
    unittest.main()
