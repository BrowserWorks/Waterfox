#!/usr/bin/env python
#
# Any copyright is dedicated to the Public Domain.
# http://creativecommons.org/publicdomain/zero/1.0/
#

import mozinfo
import mozunit
import os
import pprint
import re
import shutil
import sys
import tempfile
import unittest

from buildconfig import substs
from StringIO import StringIO
from mozlog import structured
from mozbuild.base import MozbuildObject
os.environ.pop('MOZ_OBJDIR', None)
build_obj = MozbuildObject.from_environment()

from runxpcshelltests import XPCShellTests

mozinfo.find_and_update_from_json()

objdir = build_obj.topobjdir.encode("utf-8")

if mozinfo.isMac:
  xpcshellBin = os.path.join(objdir, "dist", substs['MOZ_MACBUNDLE_NAME'], "Contents", "MacOS", "xpcshell")
else:
  xpcshellBin = os.path.join(objdir, "dist", "bin", "xpcshell")
  if sys.platform == "win32":
    xpcshellBin += ".exe"

TEST_PASS_STRING = "TEST-PASS"
TEST_FAIL_STRING = "TEST-UNEXPECTED-FAIL"

SIMPLE_PASSING_TEST = "function run_test() { do_check_true(true); }"
SIMPLE_FAILING_TEST = "function run_test() { do_check_true(false); }"

SIMPLE_UNCAUGHT_REJECTION_TEST = '''
function run_test() {
  Promise.reject(new Error("Test rejection."));
  do_check_true(true);
}
'''

SIMPLE_UNCAUGHT_REJECTION_JSM_TEST = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

Promise.reject(new Error("Test rejection."));

function run_test() {
  do_check_true(true);
}
'''

ADD_TEST_SIMPLE = '''
function run_test() { run_next_test(); }

add_test(function test_simple() {
  do_check_true(true);
  run_next_test();
});
'''

ADD_TEST_FAILING = '''
function run_test() { run_next_test(); }

add_test(function test_failing() {
  do_check_true(false);
  run_next_test();
});
'''

ADD_TEST_UNCAUGHT_REJECTION = '''
function run_test() { run_next_test(); }

add_test(function test_uncaught_rejection() {
  Promise.reject(new Error("Test rejection."));
  run_next_test();
});
'''

ADD_TEST_UNCAUGHT_REJECTION_JSM = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

function run_test() { run_next_test(); }

add_test(function test_uncaught_rejection() {
  Promise.reject(new Error("Test rejection."));
  run_next_test();
});
'''

CHILD_TEST_PASSING = '''
function run_test () { run_next_test(); }

add_test(function test_child_simple () {
  run_test_in_child("test_pass.js");
  run_next_test();
});
'''

CHILD_TEST_FAILING = '''
function run_test () { run_next_test(); }

add_test(function test_child_simple () {
  run_test_in_child("test_fail.js");
  run_next_test();
});
'''

CHILD_HARNESS_SIMPLE = '''
function run_test () { run_next_test(); }

add_test(function test_child_assert () {
  do_load_child_test_harness();
  do_test_pending("test child assertion");
  sendCommand("Assert.ok(true);", do_test_finished);
  run_next_test();
});
'''

CHILD_TEST_HANG = '''
function run_test () { run_next_test(); }

add_test(function test_child_simple () {
  do_test_pending("hang test");
  do_load_child_test_harness();
  sendCommand("_testLogger.info('CHILD-TEST-STARTED'); " +
              + "const _TEST_FILE=['test_pass.js']; _execute_test(); ",
              do_test_finished);
  run_next_test();
});
'''

SIMPLE_LOOPING_TEST = '''
function run_test () { run_next_test(); }

add_test(function test_loop () {
  do_test_pending()
});
'''

PASSING_TEST_UNICODE = '''
function run_test () { run_next_test(); }

add_test(function test_unicode_print () {
  do_check_eq("\u201c\u201d", "\u201c\u201d");
  run_next_test();
});
'''

ADD_TASK_SINGLE = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

function run_test() { run_next_test(); }

add_task(function test_task() {
  yield Promise.resolve(true);
  yield Promise.resolve(false);
});
'''

ADD_TASK_MULTIPLE = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

function run_test() { run_next_test(); }

add_task(function test_task() {
  yield Promise.resolve(true);
});

add_task(function test_2() {
  yield Promise.resolve(true);
});
'''

ADD_TASK_REJECTED = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

function run_test() { run_next_test(); }

add_task(function test_failing() {
  yield Promise.reject(new Error("I fail."));
});
'''

ADD_TASK_FAILURE_INSIDE = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

function run_test() { run_next_test(); }

add_task(function test() {
  let result = yield Promise.resolve(false);

  do_check_true(result);
});
'''

ADD_TASK_RUN_NEXT_TEST = '''
function run_test() { run_next_test(); }

add_task(function () {
  Assert.ok(true);

  run_next_test();
});
'''

ADD_TASK_STACK_TRACE = '''
Components.utils.import("resource://gre/modules/Promise.jsm", this);

function run_test() { run_next_test(); }

add_task(function* this_test_will_fail() {
  for (let i = 0; i < 10; ++i) {
    yield Promise.resolve();
  }
  Assert.ok(false);
});
'''

ADD_TASK_STACK_TRACE_WITHOUT_STAR = '''
Components.utils.import("resource://gre/modules/Promise.jsm", this);

function run_test() { run_next_test(); }

add_task(function this_test_will_fail() {
  for (let i = 0; i < 10; ++i) {
    yield Promise.resolve();
  }
  Assert.ok(false);
});
'''

ADD_TEST_THROW_STRING = '''
function run_test() {do_throw("Passing a string to do_throw")};
'''

ADD_TEST_THROW_OBJECT = '''
let error = {
  message: "Error object",
  fileName: "failure.js",
  stack: "ERROR STACK",
  toString: function() {return this.message;}
};
function run_test() {do_throw(error)};
'''

ADD_TEST_REPORT_OBJECT = '''
let error = {
  message: "Error object",
  fileName: "failure.js",
  stack: "ERROR STACK",
  toString: function() {return this.message;}
};
function run_test() {do_report_unexpected_exception(error)};
'''

ADD_TEST_VERBOSE = '''
function run_test() {do_print("a message from do_print")};
'''

# A test for genuine JS-generated Error objects
ADD_TEST_REPORT_REF_ERROR = '''
function run_test() {
  let obj = {blah: 0};
  try {
    obj.noSuchFunction();
  }
  catch (error) {
    do_report_unexpected_exception(error);
  }
};
'''

# A test for failure to load a test due to a syntax error
LOAD_ERROR_SYNTAX_ERROR = '''
function run_test(
'''

# A test for failure to load a test due to an error other than a syntax error
LOAD_ERROR_OTHER_ERROR = '''
function run_test() {
    yield "foo";
    return "foo"; // can't use return in a generator!
};
'''

# A test for asynchronous cleanup functions
ASYNC_CLEANUP = '''
function run_test() {
  Components.utils.import("resource://gre/modules/Promise.jsm", this);

  // The list of checkpoints in the order we encounter them.
  let checkpoints = [];

  // Cleanup tasks, in reverse order
  do_register_cleanup(function cleanup_checkout() {
    do_check_eq(checkpoints.join(""), "1234");
    do_print("At this stage, the test has succeeded");
    do_throw("Throwing an error to force displaying the log");
  });

  do_register_cleanup(function sync_cleanup_2() {
    checkpoints.push(4);
  });

  do_register_cleanup(function async_cleanup_2() {
    let deferred = Promise.defer();
    do_execute_soon(deferred.resolve);
    return deferred.promise.then(function() {
      checkpoints.push(3);
    });
  });

  do_register_cleanup(function sync_cleanup() {
    checkpoints.push(2);
  });

  do_register_cleanup(function async_cleanup() {
    let deferred = Promise.defer();
    do_execute_soon(deferred.resolve);
    return deferred.promise.then(function() {
      checkpoints.push(1);
    });
  });

}
'''

# A test to check that add_test() tests run without run_test()
NO_RUN_TEST_ADD_TEST = '''
add_test(function no_run_test_add_test() {
  do_check_true(true);
  run_next_test();
});
'''

# A test to check that add_task() tests run without run_test()
NO_RUN_TEST_ADD_TASK = '''
add_task(function no_run_test_add_task() {
  do_check_true(true);
});
'''

# A test to check that both add_task() and add_test() work without run_test()
NO_RUN_TEST_ADD_TEST_ADD_TASK = '''
add_test(function no_run_test_add_test() {
  do_check_true(true);
  run_next_test();
});

add_task(function no_run_test_add_task() {
  do_check_true(true);
});
'''

# A test to check that an empty test file without run_test(),
# add_test() or add_task() works.
NO_RUN_TEST_EMPTY_TEST = '''
// This is an empty test file.
'''

NO_RUN_TEST_ADD_TEST_FAIL = '''
add_test(function no_run_test_add_test_fail() {
  do_check_true(false);
  run_next_test();
});
'''

NO_RUN_TEST_ADD_TASK_FAIL = '''
add_task(function no_run_test_add_task_fail() {
  do_check_true(false);
});
'''

NO_RUN_TEST_ADD_TASK_MULTIPLE = '''
Components.utils.import("resource://gre/modules/Promise.jsm");

add_task(function test_task() {
  yield Promise.resolve(true);
});

add_task(function test_2() {
  yield Promise.resolve(true);
});
'''

LOAD_MOZINFO = '''
function run_test() {
  do_check_neq(typeof mozinfo, undefined);
  do_check_neq(typeof mozinfo.os, undefined);
}
'''

CHILD_MOZINFO = '''
function run_test () { run_next_test(); }

add_test(function test_child_mozinfo () {
  run_test_in_child("test_mozinfo.js");
  run_next_test();
});
'''
class XPCShellTestsTests(unittest.TestCase):
    """
    Yes, these are unit tests for a unit test harness.
    """
    def setUp(self):
        self.log = StringIO()
        self.tempdir = tempfile.mkdtemp()
        self.utility_path = os.path.join(objdir, 'dist', 'bin')
        logger = structured.commandline.setup_logging("selftest%s" % id(self),
                                                      {},
                                                      {"tbpl": self.log})
        self.x = XPCShellTests(logger)
        self.x.harness_timeout = 15
        self.symbols_path = None
        candidate_path = os.path.join(build_obj.distdir, 'crashreporter-symbols')
        if (os.path.isdir(candidate_path)):
          self.symbols_path = candidate_path

    def tearDown(self):
        shutil.rmtree(self.tempdir)

    def writeFile(self, name, contents):
        """
        Write |contents| to a file named |name| in the temp directory,
        and return the full path to the file.
        """
        fullpath = os.path.join(self.tempdir, name)
        with open(fullpath, "w") as f:
            f.write(contents)
        return fullpath

    def writeManifest(self, tests):
        """
        Write an xpcshell.ini in the temp directory and set
        self.manifest to its pathname. |tests| is a list containing
        either strings (for test names), or tuples with a test name
        as the first element and manifest conditions as the following
        elements.
        """
        testlines = []
        for t in tests:
            testlines.append("[%s]" % (t if isinstance(t, basestring)
                                       else t[0]))
            if isinstance(t, tuple):
                testlines.extend(t[1:])
        self.manifest = self.writeFile("xpcshell.ini", """
[DEFAULT]
head =
tail =

""" + "\n".join(testlines))

    def assertTestResult(self, expected, shuffle=False, verbose=False):
        """
        Assert that self.x.runTests with manifest=self.manifest
        returns |expected|.
        """
        self.assertEquals(expected,
                          self.x.runTests(xpcshellBin,
                                          symbolsPath=self.symbols_path,
                                          manifest=self.manifest,
                                          mozInfo=mozinfo.info,
                                          shuffle=shuffle,
                                          verbose=verbose,
                                          sequential=True,
                                          testingModulesDir=os.path.join(objdir, '_tests', 'modules'),
                                          utility_path=self.utility_path),
                          msg="""Tests should have %s, log:
========
%s
========
""" % ("passed" if expected else "failed", self.log.getvalue()))

    def _assertLog(self, s, expected):
        l = self.log.getvalue()
        self.assertEqual(expected, s in l,
                         msg="""Value %s %s in log:
========
%s
========""" % (s, "expected" if expected else "not expected", l))

    def assertInLog(self, s):
        """
        Assert that the string |s| is contained in self.log.
        """
        self._assertLog(s, True)

    def assertNotInLog(self, s):
        """
        Assert that the string |s| is not contained in self.log.
        """
        self._assertLog(s, False)

    def testPass(self):
        """
        Check that a simple test without any manifest conditions passes.
        """
        self.writeFile("test_basic.js", SIMPLE_PASSING_TEST)
        self.writeManifest(["test_basic.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testFail(self):
        """
        Check that a simple failing test without any manifest conditions fails.
        """
        self.writeFile("test_basic.js", SIMPLE_FAILING_TEST)
        self.writeManifest(["test_basic.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    @unittest.skipIf(mozinfo.isWin or not mozinfo.info.get('debug'),
                     'We don\'t have a stack fixer on hand for windows.')
    def testAssertStack(self):
        """
        When an assertion is hit, we should produce a useful stack.
        """
        self.writeFile("test_assert.js", '''
          add_test(function test_asserts_immediately() {
            Components.classes["@mozilla.org/xpcom/debug;1"]
                      .getService(Components.interfaces.nsIDebug2)
                      .assertion("foo", "assertion failed", "test.js", 1)
            run_next_test();
          });
        ''')

        self.writeManifest(["test_assert.js"])
        self.assertTestResult(False)

        self.assertInLog("###!!! ASSERTION")
        log_lines = self.log.getvalue().splitlines()
        line_pat = "#\d\d:"
        unknown_pat = "#\d\d\: \?\?\?\[.* \+0x[a-f0-9]+\]"
        self.assertFalse(any(re.search(unknown_pat, line) for line in log_lines),
                         "An stack frame without symbols was found in\n%s" % pprint.pformat(log_lines))
        self.assertTrue(any(re.search(line_pat, line) for line in log_lines),
                        "No line resembling a stack frame was found in\n%s" % pprint.pformat(log_lines))

    def testChildPass(self):
        """
        Check that a simple test running in a child process passes.
        """
        self.writeFile("test_pass.js", SIMPLE_PASSING_TEST)
        self.writeFile("test_child_pass.js", CHILD_TEST_PASSING)
        self.writeManifest(["test_child_pass.js"])

        self.assertTestResult(True, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertInLog("CHILD-TEST-STARTED")
        self.assertInLog("CHILD-TEST-COMPLETED")
        self.assertNotInLog(TEST_FAIL_STRING)


    def testChildFail(self):
        """
        Check that a simple failing test running in a child process fails.
        """
        self.writeFile("test_fail.js", SIMPLE_FAILING_TEST)
        self.writeFile("test_child_fail.js", CHILD_TEST_FAILING)
        self.writeManifest(["test_child_fail.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("CHILD-TEST-STARTED")
        self.assertInLog("CHILD-TEST-COMPLETED")
        self.assertNotInLog(TEST_PASS_STRING)

    def testChildHang(self):
        """
        Check that incomplete output from a child process results in a
        test failure.
        """
        self.writeFile("test_pass.js", SIMPLE_PASSING_TEST)
        self.writeFile("test_child_hang.js", CHILD_TEST_HANG)
        self.writeManifest(["test_child_hang.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("CHILD-TEST-STARTED")
        self.assertNotInLog("CHILD-TEST-COMPLETED")
        self.assertNotInLog(TEST_PASS_STRING)

    def testChild(self):
        """
        Checks that calling do_load_child_test_harness without run_test_in_child
        results in a usable test state. This test has a spurious failure when
        run using |mach python-test|. See bug 1103226.
        """
        self.writeFile("test_child_assertions.js", CHILD_HARNESS_SIMPLE)
        self.writeManifest(["test_child_assertions.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testSkipForAddTest(self):
        """
        Check that add_test is skipped if |skip_if| condition is true
        """
        self.writeFile("test_skip.js", """
add_test({
  skip_if: () => true,
}, function test_should_be_skipped() {
  do_check_true(false);
  run_next_test();
});
""")
        self.writeManifest(["test_skip.js"])
        self.assertTestResult(True, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertInLog("TEST-SKIP")
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNotSkipForAddTask(self):
        """
        Check that add_task is not skipped if |skip_if| condition is false
        """
        self.writeFile("test_not_skip.js", """
add_task({
  skip_if: () => false,
}, function test_should_not_be_skipped() {
  do_check_true(true);
});
""")
        self.writeManifest(["test_not_skip.js"])
        self.assertTestResult(True, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog("TEST-SKIP")
        self.assertNotInLog(TEST_FAIL_STRING)

    def testSkipForAddTask(self):
        """
        Check that add_task is skipped if |skip_if| condition is true
        """
        self.writeFile("test_skip.js", """
add_task({
  skip_if: () => true,
}, function test_should_be_skipped() {
  do_check_true(false);
});
""")
        self.writeManifest(["test_skip.js"])
        self.assertTestResult(True, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertInLog("TEST-SKIP")
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNotSkipForAddTest(self):
        """
        Check that add_test is not skipped if |skip_if| condition is false
        """
        self.writeFile("test_not_skip.js", """
add_test({
  skip_if: () => false,
}, function test_should_not_be_skipped() {
  do_check_true(true);
  run_next_test();
});
""")
        self.writeManifest(["test_not_skip.js"])
        self.assertTestResult(True, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog("TEST-SKIP")
        self.assertNotInLog(TEST_FAIL_STRING)

    def testSyntaxError(self):
        """
        Check that running a test file containing a syntax error produces
        a test failure and expected output.
        """
        self.writeFile("test_syntax_error.js", '"')
        self.writeManifest(["test_syntax_error.js"])

        self.assertTestResult(False, verbose=True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testUnicodeInAssertMethods(self):
        """
        Check that passing unicode characters through an assertion method works.
        """
        self.writeFile("test_unicode_assert.js", PASSING_TEST_UNICODE)
        self.writeManifest(["test_unicode_assert.js"])

        self.assertTestResult(True, verbose=True)

    @unittest.skipIf('MOZ_AUTOMATION' in os.environ,
                     'Timeout code path occasionally times out (bug 1098121)')
    def testHangingTimeout(self):
        """
        Check that a test that never finishes results in the correct error log.
        """
        self.writeFile("test_loop.js", SIMPLE_LOOPING_TEST)
        self.writeManifest(["test_loop.js"])

        old_timeout = self.x.harness_timeout
        self.x.harness_timeout = 1

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog("TEST-UNEXPECTED-TIMEOUT")

        self.x.harness_timeout = old_timeout

    def testPassFail(self):
        """
        Check that running more than one test works.
        """
        self.writeFile("test_pass.js", SIMPLE_PASSING_TEST)
        self.writeFile("test_fail.js", SIMPLE_FAILING_TEST)
        self.writeManifest(["test_pass.js", "test_fail.js"])

        self.assertTestResult(False)
        self.assertEquals(2, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertInLog(TEST_FAIL_STRING)

    def testSkip(self):
        """
        Check that a simple failing test skipped in the manifest does
        not cause failure.
        """
        self.writeFile("test_basic.js", SIMPLE_FAILING_TEST)
        self.writeManifest([("test_basic.js", "skip-if = true")])
        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertNotInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testKnownFail(self):
        """
        Check that a simple failing test marked as known-fail in the manifest
        does not cause failure.
        """
        self.writeFile("test_basic.js", SIMPLE_FAILING_TEST)
        self.writeManifest([("test_basic.js", "fail-if = true")])
        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(1, self.x.todoCount)
        self.assertInLog("TEST-FAIL")
        # This should be suppressed because the harness doesn't include
        # the full log from the xpcshell run when things pass.
        self.assertNotInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testUnexpectedPass(self):
        """
        Check that a simple failing test marked as known-fail in the manifest
        that passes causes an unexpected pass.
        """
        self.writeFile("test_basic.js", SIMPLE_PASSING_TEST)
        self.writeManifest([("test_basic.js", "fail-if = true")])
        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        # From the outer (Python) harness
        self.assertInLog("TEST-UNEXPECTED-PASS")
        self.assertNotInLog("TEST-KNOWN-FAIL")

    def testReturnNonzero(self):
        """
        Check that a test where xpcshell returns nonzero fails.
        """
        self.writeFile("test_error.js", "throw 'foo'")
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testUncaughtRejection(self):
        """
        Ensure a simple test with an uncaught rejection is reported.
        """
        self.writeFile("test_simple_uncaught_rejection.js", SIMPLE_UNCAUGHT_REJECTION_TEST)
        self.writeManifest(["test_simple_uncaught_rejection.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        if not substs.get('RELEASE_OR_BETA'):
          # async stacks are currently not enabled in release builds.
          self.assertInLog("test_simple_uncaught_rejection.js:3:3")
        self.assertInLog("Test rejection.")
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testUncaughtRejectionJSM(self):
        """
        Ensure a simple test with an uncaught rejection from Promise.jsm is reported.
        """
        self.writeFile("test_simple_uncaught_rejection_jsm.js", SIMPLE_UNCAUGHT_REJECTION_JSM_TEST)
        self.writeManifest(["test_simple_uncaught_rejection_jsm.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("test_simple_uncaught_rejection_jsm.js:4:16")
        self.assertInLog("Test rejection.")
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTestSimple(self):
        """
        Ensure simple add_test() works.
        """
        self.writeFile("test_add_test_simple.js", ADD_TEST_SIMPLE)
        self.writeManifest(["test_add_test_simple.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)

    def testLogCorrectFileName(self):
        """
        Make sure a meaningful filename and line number is logged
        by a passing test.
        """
        self.writeFile("test_add_test_simple.js", ADD_TEST_SIMPLE)
        self.writeManifest(["test_add_test_simple.js"])

        self.assertTestResult(True, verbose=True)
        self.assertInLog("true == true")
        self.assertNotInLog("[do_check_true :")
        self.assertInLog("[test_simple : 5]")

    def testAddTestFailing(self):
        """
        Ensure add_test() with a failing test is reported.
        """
        self.writeFile("test_add_test_failing.js", ADD_TEST_FAILING)
        self.writeManifest(["test_add_test_failing.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTestUncaughtRejection(self):
        """
        Ensure add_test() with an uncaught rejection is reported.
        """
        self.writeFile("test_add_test_uncaught_rejection.js", ADD_TEST_UNCAUGHT_REJECTION)
        self.writeManifest(["test_add_test_uncaught_rejection.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTestUncaughtRejectionJSM(self):
        """
        Ensure add_test() with an uncaught rejection from Promise.jsm is reported.
        """
        self.writeFile("test_add_test_uncaught_rejection_jsm.js", ADD_TEST_UNCAUGHT_REJECTION_JSM)
        self.writeManifest(["test_add_test_uncaught_rejection_jsm.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTaskTestSingle(self):
        """
        Ensure add_test_task() with a single passing test works.
        """
        self.writeFile("test_add_task_simple.js", ADD_TASK_SINGLE)
        self.writeManifest(["test_add_task_simple.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)

    def testAddTaskTestMultiple(self):
        """
        Ensure multiple calls to add_test_task() work as expected.
        """
        self.writeFile("test_add_task_multiple.js",
            ADD_TASK_MULTIPLE)
        self.writeManifest(["test_add_task_multiple.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)

    def testAddTaskTestRejected(self):
        """
        Ensure rejected task reports as failure.
        """
        self.writeFile("test_add_task_rejected.js",
            ADD_TASK_REJECTED)
        self.writeManifest(["test_add_task_rejected.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTaskTestFailureInside(self):
        """
        Ensure tests inside task are reported as failures.
        """
        self.writeFile("test_add_task_failure_inside.js",
            ADD_TASK_FAILURE_INSIDE)
        self.writeManifest(["test_add_task_failure_inside.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTaskRunNextTest(self):
        """
        Calling run_next_test() from inside add_task() results in failure.
        """
        self.writeFile("test_add_task_run_next_test.js",
            ADD_TASK_RUN_NEXT_TEST)
        self.writeManifest(["test_add_task_run_next_test.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)

    def testAddTaskStackTrace(self):
        """
        Ensuring that calling Assert.ok(false) from inside add_task()
        results in a human-readable stack trace.
        """
        self.writeFile("test_add_task_stack_trace.js",
            ADD_TASK_STACK_TRACE)
        self.writeManifest(["test_add_task_stack_trace.js"])

        self.assertTestResult(False)
        self.assertInLog("this_test_will_fail")
        self.assertInLog("run_next_test")
        self.assertInLog("run_test")
        self.assertNotInLog("Task.jsm")

    def testAddTaskStackTraceWithoutStar(self):
        """
        Ensuring that calling Assert.ok(false) from inside add_task()
        results in a human-readable stack trace. This variant uses deprecated
        `function()` syntax instead of now standard `function*()`.
        """
        self.writeFile("test_add_task_stack_trace_without_star.js",
            ADD_TASK_STACK_TRACE)
        self.writeManifest(["test_add_task_stack_trace_without_star.js"])

        self.assertTestResult(False)
        self.assertInLog("this_test_will_fail")
        self.assertInLog("run_next_test")
        self.assertInLog("run_test")
        self.assertNotInLog("Task.jsm")

    def testMissingHeadFile(self):
        """
        Ensure that missing head file results in fatal error.
        """
        self.writeFile("test_basic.js", SIMPLE_PASSING_TEST)
        self.writeManifest([("test_basic.js", "head = missing.js")])

        raised = False

        try:
            # The actual return value is never checked because we raise.
            self.assertTestResult(True)
        except Exception, ex:
            raised = True
            self.assertEquals(ex.message[0:9], "head file")

        self.assertTrue(raised)

    def testMissingTailFile(self):
        """
        Ensure that missing tail file results in fatal error.
        """
        self.writeFile("test_basic.js", SIMPLE_PASSING_TEST)
        self.writeManifest([("test_basic.js", "tail = missing.js")])

        raised = False

        try:
            self.assertTestResult(True)
        except Exception, ex:
            raised = True
            self.assertEquals(ex.message[0:9], "tail file")

        self.assertTrue(raised)

    def testRandomExecution(self):
        """
        Check that random execution doesn't break.
        """
        manifest = []
        for i in range(0, 10):
            filename = "test_pass_%d.js" % i
            self.writeFile(filename, SIMPLE_PASSING_TEST)
            manifest.append(filename)

        self.writeManifest(manifest)
        self.assertTestResult(True, shuffle=True)
        self.assertEquals(10, self.x.testCount)
        self.assertEquals(10, self.x.passCount)

    def testDoThrowString(self):
        """
        Check that do_throw produces reasonable messages when the
        input is a string instead of an object
        """
        self.writeFile("test_error.js", ADD_TEST_THROW_STRING)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("Passing a string to do_throw")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoThrowForeignObject(self):
        """
        Check that do_throw produces reasonable messages when the
        input is a generic object with 'filename', 'message' and 'stack' attributes
        but 'object instanceof Error' returns false
        """
        self.writeFile("test_error.js", ADD_TEST_THROW_OBJECT)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("failure.js")
        self.assertInLog("Error object")
        self.assertInLog("ERROR STACK")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoReportForeignObject(self):
        """
        Check that do_report_unexpected_exception produces reasonable messages when the
        input is a generic object with 'filename', 'message' and 'stack' attributes
        but 'object instanceof Error' returns false
        """
        self.writeFile("test_error.js", ADD_TEST_REPORT_OBJECT)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("failure.js")
        self.assertInLog("Error object")
        self.assertInLog("ERROR STACK")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoReportRefError(self):
        """
        Check that do_report_unexpected_exception produces reasonable messages when the
        input is a JS-generated Error
        """
        self.writeFile("test_error.js", ADD_TEST_REPORT_REF_ERROR)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("test_error.js")
        self.assertInLog("obj.noSuchFunction is not a function")
        self.assertInLog("run_test@")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoReportSyntaxError(self):
        """
        Check that attempting to load a test file containing a syntax error
        generates details of the error in the log
        """
        self.writeFile("test_error.js", LOAD_ERROR_SYNTAX_ERROR)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("test_error.js:3")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoReportNonSyntaxError(self):
        """
        Check that attempting to load a test file containing an error other
        than a syntax error generates details of the error in the log
        """
        self.writeFile("test_error.js", LOAD_ERROR_OTHER_ERROR)
        self.writeManifest(["test_error.js"])

        self.assertTestResult(False)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertInLog("TypeError: generator function run_test returns a value at")
        self.assertInLog("test_error.js:4")
        self.assertNotInLog(TEST_PASS_STRING)

    def testDoPrintWhenVerboseNotExplicit(self):
        """
        Check that do_print() and similar calls that generate output do
        not have the output when not run verbosely.
        """
        self.writeFile("test_verbose.js", ADD_TEST_VERBOSE)
        self.writeManifest(["test_verbose.js"])

        self.assertTestResult(True)
        self.assertNotInLog("a message from do_print")

    def testDoPrintWhenVerboseExplicit(self):
        """
        Check that do_print() and similar calls that generate output have the
        output shown when run verbosely.
        """
        self.writeFile("test_verbose.js", ADD_TEST_VERBOSE)
        self.writeManifest(["test_verbose.js"])
        self.assertTestResult(True, verbose=True)
        self.assertInLog("a message from do_print")

    def testDoPrintWhenVerboseInManifest(self):
        """
        Check that do_print() and similar calls that generate output have the
        output shown when 'verbose = true' is in the manifest, even when
        not run verbosely.
        """
        self.writeFile("test_verbose.js", ADD_TEST_VERBOSE)
        self.writeManifest([("test_verbose.js", "verbose = true")])

        self.assertTestResult(True)
        self.assertInLog("a message from do_print")

    def testAsyncCleanup(self):
        """
        Check that do_register_cleanup handles nicely cleanup tasks that
        return a promise
        """
        self.writeFile("test_asyncCleanup.js", ASYNC_CLEANUP)
        self.writeManifest(["test_asyncCleanup.js"])
        self.assertTestResult(False)
        self.assertInLog("\"1234\" == \"1234\"")
        self.assertInLog("At this stage, the test has succeeded")
        self.assertInLog("Throwing an error to force displaying the log")

    def testNoRunTestAddTest(self):
        """
        Check that add_test() works fine without run_test() in the test file.
        """
        self.writeFile("test_noRunTestAddTest.js", NO_RUN_TEST_ADD_TEST)
        self.writeManifest(["test_noRunTestAddTest.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNoRunTestAddTask(self):
        """
        Check that add_task() works fine without run_test() in the test file.
        """
        self.writeFile("test_noRunTestAddTask.js", NO_RUN_TEST_ADD_TASK)
        self.writeManifest(["test_noRunTestAddTask.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNoRunTestAddTestAddTask(self):
        """
        Check that both add_test() and add_task() work without run_test()
        in the test file.
        """
        self.writeFile("test_noRunTestAddTestAddTask.js", NO_RUN_TEST_ADD_TEST_ADD_TASK)
        self.writeManifest(["test_noRunTestAddTestAddTask.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNoRunTestEmptyTest(self):
        """
        Check that the test passes on an empty file that contains neither
        run_test() nor add_test(), add_task().
        """
        self.writeFile("test_noRunTestEmptyTest.js", NO_RUN_TEST_EMPTY_TEST)
        self.writeManifest(["test_noRunTestEmptyTest.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testNoRunTestAddTestFail(self):
        """
        Check that test fails on using add_test() without run_test().
        """
        self.writeFile("test_noRunTestAddTestFail.js", NO_RUN_TEST_ADD_TEST_FAIL)
        self.writeManifest(["test_noRunTestAddTestFail.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testNoRunTestAddTaskFail(self):
        """
        Check that test fails on using add_task() without run_test().
        """
        self.writeFile("test_noRunTestAddTaskFail.js", NO_RUN_TEST_ADD_TASK_FAIL)
        self.writeManifest(["test_noRunTestAddTaskFail.js"])

        self.assertTestResult(False)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(0, self.x.passCount)
        self.assertEquals(1, self.x.failCount)
        self.assertInLog(TEST_FAIL_STRING)
        self.assertNotInLog(TEST_PASS_STRING)

    def testNoRunTestAddTaskMultiple(self):
        """
        Check that multple add_task() tests work without run_test().
        """
        self.writeFile("test_noRunTestAddTaskMultiple.js", NO_RUN_TEST_ADD_TASK_MULTIPLE)
        self.writeManifest(["test_noRunTestAddTaskMultiple.js"])

        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testMozinfo(self):
        """
        Check that mozinfo.json is loaded
        """
        self.writeFile("test_mozinfo.js", LOAD_MOZINFO)
        self.writeManifest(["test_mozinfo.js"])
        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

    def testChildMozinfo(self):
        """
        Check that mozinfo.json is loaded in child process
        """
        self.writeFile("test_mozinfo.js", LOAD_MOZINFO)
        self.writeFile("test_child_mozinfo.js", CHILD_MOZINFO)
        self.writeManifest(["test_child_mozinfo.js"])
        self.assertTestResult(True)
        self.assertEquals(1, self.x.testCount)
        self.assertEquals(1, self.x.passCount)
        self.assertEquals(0, self.x.failCount)
        self.assertEquals(0, self.x.todoCount)
        self.assertInLog(TEST_PASS_STRING)
        self.assertNotInLog(TEST_FAIL_STRING)

if __name__ == "__main__":
    mozunit.main()
