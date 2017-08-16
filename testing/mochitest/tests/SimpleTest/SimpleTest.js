/* -*- js-indent-level: 4; tab-width: 4; indent-tabs-mode: nil -*- */
/* vim:set ts=4 sw=4 sts=4 et: */
/**
 * SimpleTest, a partial Test.Simple/Test.More API compatible test library.
 *
 * Why?
 *
 * Test.Simple doesn't work on IE < 6.
 * TODO:
 *  * Support the Test.Simple API used by MochiKit, to be able to test MochiKit
 * itself against IE 5.5
 *
 * NOTE: Pay attention to cross-browser compatibility in this file. For
 * instance, do not use const or JS > 1.5 features which are not yet
 * implemented everywhere.
 *
**/

var SimpleTest = { };
var parentRunner = null;

// In normal test runs, the window that has a TestRunner in its parent is
// the primary window.  In single test runs, if there is no parent and there
// is no opener then it is the primary window.
var isSingleTestRun = (parent == window && !opener)
try {
  var isPrimaryTestWindow = !!parent.TestRunner || isSingleTestRun;
} catch(e) {
  dump("TEST-UNEXPECTED-FAIL, Exception caught: " + e.message +
                ", at: " + e.fileName + " (" + e.lineNumber +
                "), location: " + window.location.href + "\n");
}
// Finds the TestRunner for this test run and the SpecialPowers object (in
// case it is not defined) from a parent/opener window.
//
// Finding the SpecialPowers object is needed when we have ChromePowers in
// harness.xul and we need SpecialPowers in the iframe, and also for tests
// like test_focus.xul where we open a window which opens another window which
// includes SimpleTest.js.
(function() {
    function ancestor(w) {
        return w.parent != w ? w.parent : w.opener;
    }

    var w = ancestor(window);
    while (w && (!parentRunner || !window.SpecialPowers)) {
        if (!parentRunner) {
            parentRunner = w.TestRunner;
            if (!parentRunner && w.wrappedJSObject) {
                parentRunner = w.wrappedJSObject.TestRunner;
            }
        }
        if (!window.SpecialPowers) {
            window.SpecialPowers = w.SpecialPowers;
        }
        w = ancestor(w);
    }

    if (parentRunner) {
        SimpleTest.harnessParameters = parentRunner.getParameterInfo();
    }
})();

/* Helper functions pulled out of various MochiKit modules */
if (typeof(repr) == 'undefined') {
    this.repr = function(o) {
        if (typeof(o) == "undefined") {
            return "undefined";
        } else if (o === null) {
            return "null";
        }
        try {
            if (typeof(o.__repr__) == 'function') {
                return o.__repr__();
            } else if (typeof(o.repr) == 'function' && o.repr != arguments.callee) {
                return o.repr();
            }
       } catch (e) {
       }
       try {
            if (typeof(o.NAME) == 'string' && (
                    o.toString == Function.prototype.toString ||
                    o.toString == Object.prototype.toString
                )) {
                return o.NAME;
            }
        } catch (e) {
        }
        var ostring;
        try {
            if (o === 0) {
                ostring = (1 / o > 0) ? "+0" : "-0";
            } else if (typeof o === "string") {
                ostring = JSON.stringify(o);
            } else if (Array.isArray(o)) {
                ostring = "[" + o.map(val => repr(val)).join(", ") + "]";
            } else {
                ostring = (o + "");
            }
        } catch (e) {
            return "[" + typeof(o) + "]";
        }
        if (typeof(o) == "function") {
            o = ostring.replace(/^\s+/, "");
            var idx = o.indexOf("{");
            if (idx != -1) {
                o = o.substr(0, idx) + "{...}";
            }
        }
        return ostring;
    };
}

/* This returns a function that applies the previously given parameters.
 * This is used by SimpleTest.showReport
 */
if (typeof(partial) == 'undefined') {
    this.partial = function(func) {
        var args = [];
        for (var i = 1; i < arguments.length; i++) {
            args.push(arguments[i]);
        }
        return function() {
            if (arguments.length > 0) {
                for (var i = 1; i < arguments.length; i++) {
                    args.push(arguments[i]);
                }
            }
            func(args);
        };
    };
}

if (typeof(getElement) == 'undefined') {
    this.getElement = function(id) {
        return ((typeof(id) == "string") ?
            document.getElementById(id) : id);
    };
    this.$ = this.getElement;
}

SimpleTest._newCallStack = function(path) {
    var rval = function () {
        var callStack = arguments.callee.callStack;
        for (var i = 0; i < callStack.length; i++) {
            if (callStack[i].apply(this, arguments) === false) {
                break;
            }
        }
        try {
            this[path] = null;
        } catch (e) {
            // pass
        }
    };
    rval.callStack = [];
    return rval;
};

if (typeof(addLoadEvent) == 'undefined') {
    this.addLoadEvent = function(func) {
        var existing = window["onload"];
        var regfunc = existing;
        if (!(typeof(existing) == 'function'
                && typeof(existing.callStack) == "object"
                && existing.callStack !== null)) {
            regfunc = SimpleTest._newCallStack("onload");
            if (typeof(existing) == 'function') {
                regfunc.callStack.push(existing);
            }
            window["onload"] = regfunc;
        }
        regfunc.callStack.push(func);
    };
}

function createEl(type, attrs, html) {
    //use createElementNS so the xul/xhtml tests have no issues
    var el;
    if (!document.body) {
        el = document.createElementNS("http://www.w3.org/1999/xhtml", type);
    }
    else {
        el = document.createElement(type);
    }
    if (attrs !== null && attrs !== undefined) {
        for (var k in attrs) {
            el.setAttribute(k, attrs[k]);
        }
    }
    if (html !== null && html !== undefined) {
        el.appendChild(document.createTextNode(html));
    }
    return el;
}

/* lots of tests use this as a helper to get css properties */
if (typeof(computedStyle) == 'undefined') {
    this.computedStyle = function(elem, cssProperty) {
        elem = getElement(elem);
        if (elem.currentStyle) {
            return elem.currentStyle[cssProperty];
        }
        if (typeof(document.defaultView) == 'undefined' || document === null) {
            return undefined;
        }
        var style = document.defaultView.getComputedStyle(elem);
        if (typeof(style) == 'undefined' || style === null) {
            return undefined;
        }

        var selectorCase = cssProperty.replace(/([A-Z])/g, '-$1'
            ).toLowerCase();

        return style.getPropertyValue(selectorCase);
    };
}

SimpleTest._tests = [];
SimpleTest._stopOnLoad = true;
SimpleTest._cleanupFunctions = [];
SimpleTest._timeoutFunctions = [];
SimpleTest._inChaosMode = false;
// When using failure pattern file to filter unexpected issues,
// SimpleTest.expected would be an array of [pattern, expected count],
// and SimpleTest.num_failed would be an array of actual counts which
// has the same length as SimpleTest.expected.
SimpleTest.expected = 'pass';
SimpleTest.num_failed = 0;

function usesFailurePatterns() {
  return Array.isArray(SimpleTest.expected);
}

/**
 * Checks whether there is any failure pattern matches the given error
 * message, and if found, bumps the counter of the failure pattern.
 * Returns whether a matched failure pattern is found.
 */
function recordIfMatchesFailurePattern(name, diag) {
  let index = SimpleTest.expected.findIndex(([pat, count]) => {
    return pat == null ||
      (typeof name == "string" && name.includes(pat)) ||
      (typeof diag == "string" && diag.includes(pat));
  });
  if (index >= 0) {
    SimpleTest.num_failed[index]++;
    return true;
  }
  return false;
}

SimpleTest.setExpected = function () {
  if (parent.TestRunner) {
    if (!Array.isArray(parent.TestRunner.expected)) {
      SimpleTest.expected = parent.TestRunner.expected;
    } else {
      // Assertions are checked by the runner.
      SimpleTest.expected = parent.TestRunner.expected.filter(([pat]) => pat != "ASSERTION");
      SimpleTest.num_failed = new Array(SimpleTest.expected.length);
      SimpleTest.num_failed.fill(0);
    }
  }
}
SimpleTest.setExpected();

/**
 * Something like assert.
**/
SimpleTest.ok = function (condition, name, diag, stack = null) {

    var test = {'result': !!condition, 'name': name, 'diag': diag};
    if (SimpleTest.expected == 'fail') {
      if (!test.result) {
        SimpleTest.num_failed++;
        test.result = !test.result;
      }
      var successInfo = {status:"FAIL", expected:"FAIL", message:"TEST-KNOWN-FAIL"};
      var failureInfo = {status:"PASS", expected:"FAIL", message:"TEST-UNEXPECTED-PASS"};
    } else if (!test.result && usesFailurePatterns()) {
      if (recordIfMatchesFailurePattern(name, diag)) {
        test.result = true;
        // Add a mark for unexpected failures suppressed by failure pattern.
        name = '[suppressed] ' + name;
      }
      var successInfo = {status:"FAIL", expected:"FAIL", message:"TEST-KNOWN-FAIL"};
      var failureInfo = {status:"FAIL", expected:"PASS", message:"TEST-UNEXPECTED-FAIL"};
    } else {
      var successInfo = {status:"PASS", expected:"PASS", message:"TEST-PASS"};
      var failureInfo = {status:"FAIL", expected:"PASS", message:"TEST-UNEXPECTED-FAIL"};
    }

    if (condition) {
        stack = null;
    } else if (!stack) {
      stack = (new Error).stack.replace(/^(.*@)http:\/\/mochi.test:8888\/tests\//gm, '    $1').split('\n');
      stack.splice(0, 1);
      stack = stack.join('\n');
    }

    SimpleTest._logResult(test, successInfo, failureInfo, stack);
    SimpleTest._tests.push(test);
};

/**
 * Roughly equivalent to ok(Object.is(a, b), name)
**/
SimpleTest.is = function (a, b, name) {
    // Be lazy and use Object.is til we want to test a browser without it.
    var pass = Object.is(a, b);
    var diag = pass ? "" : "got " + repr(a) + ", expected " + repr(b)
    SimpleTest.ok(pass, name, diag);
};

SimpleTest.isfuzzy = function (a, b, epsilon, name) {
  var pass = (a >= b - epsilon) && (a <= b + epsilon);
  var diag = pass ? "" : "got " + repr(a) + ", expected " + repr(b) + " epsilon: +/- " + repr(epsilon)
  SimpleTest.ok(pass, name, diag);
};

SimpleTest.isnot = function (a, b, name) {
    var pass = !Object.is(a, b);
    var diag = pass ? "" : "didn't expect " + repr(a) + ", but got it";
    SimpleTest.ok(pass, name, diag);
};

/**
 * Check that the function call throws an exception.
 */
SimpleTest.doesThrow = function(fn, name) {
    var gotException = false;
    try {
      fn();
    } catch (ex) { gotException = true; }
    ok(gotException, name);
};

//  --------------- Test.Builder/Test.More todo() -----------------

SimpleTest.todo = function(condition, name, diag) {
    var test = {'result': !!condition, 'name': name, 'diag': diag, todo: true};
    if (test.result && usesFailurePatterns() &&
        recordIfMatchesFailurePattern(name, diag)) {
      // Flipping the result to false so we don't get unexpected result. There
      // is no perfect way here. A known failure can trigger unexpected pass,
      // in which case, tagging it as KNOWN-FAIL probably makes more sense than
      // marking it PASS.
      test.result = false;
      // Add a mark for unexpected failures suppressed by failure pattern.
      name = '[suppressed] ' + name;
    }
    var successInfo = {status:"PASS", expected:"FAIL", message:"TEST-UNEXPECTED-PASS"};
    var failureInfo = {status:"FAIL", expected:"FAIL", message:"TEST-KNOWN-FAIL"};
    SimpleTest._logResult(test, successInfo, failureInfo);
    SimpleTest._tests.push(test);
};

/*
 * Returns the absolute URL to a test data file from where tests
 * are served. i.e. the file doesn't necessarely exists where tests
 * are executed.
 * (For android, mochitest are executed on the device, while
 * all mochitest html (and others) files are served from the test runner
 * slave)
 */
SimpleTest.getTestFileURL = function(path) {
  var lastSlashIdx = path.lastIndexOf("/") + 1;
  var filename = path.substr(lastSlashIdx);
  var location = window.location;
  // Remove mochitest html file name from the path
  var remotePath = location.pathname.replace(/\/[^\/]+?$/,"");
  var url = location.origin +
            remotePath + "/" + path;
  return url;
};

SimpleTest._getCurrentTestURL = function() {
    return parentRunner && parentRunner.currentTestURL ||
           typeof gTestPath == "string" && gTestPath ||
           "unknown test url";
};

SimpleTest._forceLogMessageOutput = false;

/**
 * Force all test messages to be displayed.  Only applies for the current test.
 */
SimpleTest.requestCompleteLog = function() {
    if (!parentRunner || SimpleTest._forceLogMessageOutput) {
        return;
    }

    parentRunner.structuredLogger.deactivateBuffering();
    SimpleTest._forceLogMessageOutput = true;

    SimpleTest.registerCleanupFunction(function() {
        parentRunner.structuredLogger.activateBuffering();
        SimpleTest._forceLogMessageOutput = false;
    });
};

SimpleTest._logResult = function (test, passInfo, failInfo, stack) {
    var url = SimpleTest._getCurrentTestURL();
    var result = test.result ? passInfo : failInfo;
    var diagnostic = test.diag || null;
    // BUGFIX : coercing test.name to a string, because some a11y tests pass an xpconnect object
    var subtest = test.name ? String(test.name) : null;
    var isError = !test.result == !test.todo;

    if (parentRunner) {
        if (!result.status || !result.expected) {
            if (diagnostic) {
                parentRunner.structuredLogger.info(diagnostic);
            }
            return;
        }

        if (isError) {
            parentRunner.addFailedTest(url);
        }

        parentRunner.structuredLogger.testStatus(url,
                                                 subtest,
                                                 result.status,
                                                 result.expected,
                                                 diagnostic,
                                                 stack);
    } else if (typeof dump === "function") {
        var diagMessage = test.name + (test.diag ? " - " + test.diag : "");
        var debugMsg = [result.message, url, diagMessage].join(' | ');
        dump(debugMsg + "\n");
    } else {
        // Non-Mozilla browser?  Just do nothing.
    }
};

SimpleTest.info = function(name, message) {
    var log = message ? name + ' | ' + message : name;
    if (parentRunner) {
        parentRunner.structuredLogger.info(log);
    } else {
        dump(log + '\n');
    }
};

/**
 * Copies of is and isnot with the call to ok replaced by a call to todo.
**/

SimpleTest.todo_is = function (a, b, name) {
    var pass = Object.is(a, b);
    var diag = pass ? repr(a) + " should equal " + repr(b)
                    : "got " + repr(a) + ", expected " + repr(b);
    SimpleTest.todo(pass, name, diag);
};

SimpleTest.todo_isnot = function (a, b, name) {
    var pass = !Object.is(a, b);
    var diag = pass ? repr(a) + " should not equal " + repr(b)
                    : "didn't expect " + repr(a) + ", but got it";
    SimpleTest.todo(pass, name, diag);
};


/**
 * Makes a test report, returns it as a DIV element.
**/
SimpleTest.report = function () {
    var passed = 0;
    var failed = 0;
    var todo = 0;

    var tallyAndCreateDiv = function (test) {
            var cls, msg, div;
            var diag = test.diag ? " - " + test.diag : "";
            if (test.todo && !test.result) {
                todo++;
                cls = "test_todo";
                msg = "todo | " + test.name + diag;
            } else if (test.result && !test.todo) {
                passed++;
                cls = "test_ok";
                msg = "passed | " + test.name + diag;
            } else {
                failed++;
                cls = "test_not_ok";
                msg = "failed | " + test.name + diag;
            }
          div = createEl('div', {'class': cls}, msg);
          return div;
        };
    var results = [];
    for (var d=0; d<SimpleTest._tests.length; d++) {
        results.push(tallyAndCreateDiv(SimpleTest._tests[d]));
    }

    var summary_class = failed != 0 ? 'some_fail' :
                          passed == 0 ? 'todo_only' : 'all_pass';

    var div1 = createEl('div', {'class': 'tests_report'});
    var div2 = createEl('div', {'class': 'tests_summary ' + summary_class});
    var div3 = createEl('div', {'class': 'tests_passed'}, 'Passed: ' + passed);
    var div4 = createEl('div', {'class': 'tests_failed'}, 'Failed: ' + failed);
    var div5 = createEl('div', {'class': 'tests_todo'}, 'Todo: ' + todo);
    div2.appendChild(div3);
    div2.appendChild(div4);
    div2.appendChild(div5);
    div1.appendChild(div2);
    for (var t=0; t<results.length; t++) {
        //iterate in order
        div1.appendChild(results[t]);
    }
    return div1;
};

/**
 * Toggle element visibility
**/
SimpleTest.toggle = function(el) {
    if (computedStyle(el, 'display') == 'block') {
        el.style.display = 'none';
    } else {
        el.style.display = 'block';
    }
};

/**
 * Toggle visibility for divs with a specific class.
**/
SimpleTest.toggleByClass = function (cls, evt) {
    var children = document.getElementsByTagName('div');
    var elements = [];
    for (var i=0; i<children.length; i++) {
        var child = children[i];
        var clsName = child.className;
        if (!clsName) {
            continue;
        }
        var classNames = clsName.split(' ');
        for (var j = 0; j < classNames.length; j++) {
            if (classNames[j] == cls) {
                elements.push(child);
                break;
            }
        }
    }
    for (var t=0; t<elements.length; t++) {
        //TODO: again, for-in loop over elems seems to break this
        SimpleTest.toggle(elements[t]);
    }
    if (evt)
        evt.preventDefault();
};

/**
 * Shows the report in the browser
**/
SimpleTest.showReport = function() {
    var togglePassed = createEl('a', {'href': '#'}, "Toggle passed checks");
    var toggleFailed = createEl('a', {'href': '#'}, "Toggle failed checks");
    var toggleTodo = createEl('a',{'href': '#'}, "Toggle todo checks");
    togglePassed.onclick = partial(SimpleTest.toggleByClass, 'test_ok');
    toggleFailed.onclick = partial(SimpleTest.toggleByClass, 'test_not_ok');
    toggleTodo.onclick = partial(SimpleTest.toggleByClass, 'test_todo');
    var body = document.body;  // Handles HTML documents
    if (!body) {
        // Do the XML thing.
        body = document.getElementsByTagNameNS("http://www.w3.org/1999/xhtml",
                                               "body")[0];
    }
    var firstChild = body.childNodes[0];
    var addNode;
    if (firstChild) {
        addNode = function (el) {
            body.insertBefore(el, firstChild);
        };
    } else {
        addNode = function (el) {
            body.appendChild(el)
        };
    }
    addNode(togglePassed);
    addNode(createEl('span', null, " "));
    addNode(toggleFailed);
    addNode(createEl('span', null, " "));
    addNode(toggleTodo);
    addNode(SimpleTest.report());
    // Add a separator from the test content.
    addNode(createEl('hr'));
};

/**
 * Tells SimpleTest to don't finish the test when the document is loaded,
 * useful for asynchronous tests.
 *
 * When SimpleTest.waitForExplicitFinish is called,
 * explicit SimpleTest.finish() is required.
**/
SimpleTest.waitForExplicitFinish = function () {
    SimpleTest._stopOnLoad = false;
};

/**
 * Multiply the timeout the parent runner uses for this test by the
 * given factor.
 *
 * For example, in a test that may take a long time to complete, using
 * "SimpleTest.requestLongerTimeout(5)" will give it 5 times as long to
 * finish.
 */
SimpleTest.requestLongerTimeout = function (factor) {
    if (parentRunner) {
        parentRunner.requestLongerTimeout(factor);
    }
}

/**
 * Note that the given range of assertions is to be expected.  When
 * this function is not called, 0 assertions are expected.  When only
 * one argument is given, that number of assertions are expected.
 *
 * A test where we expect to have assertions (which should largely be a
 * transitional mechanism to get assertion counts down from our current
 * situation) can call the SimpleTest.expectAssertions() function, with
 * either one or two arguments:  one argument gives an exact number
 * expected, and two arguments give a range.  For example, a test might do
 * one of the following:
 *
 *   // Currently triggers two assertions (bug NNNNNN).
 *   SimpleTest.expectAssertions(2);
 *
 *   // Currently triggers one assertion on Mac (bug NNNNNN).
 *   if (navigator.platform.indexOf("Mac") == 0) {
 *     SimpleTest.expectAssertions(1);
 *   }
 *
 *   // Currently triggers two assertions on all platforms (bug NNNNNN),
 *   // but intermittently triggers two additional assertions (bug NNNNNN)
 *   // on Windows.
 *   if (navigator.platform.indexOf("Win") == 0) {
 *     SimpleTest.expectAssertions(2, 4);
 *   } else {
 *     SimpleTest.expectAssertions(2);
 *   }
 *
 *   // Intermittently triggers up to three assertions (bug NNNNNN).
 *   SimpleTest.expectAssertions(0, 3);
 */
SimpleTest.expectAssertions = function(min, max) {
    if (parentRunner) {
        parentRunner.expectAssertions(min, max);
    }
}

SimpleTest._flakyTimeoutIsOK = false;
SimpleTest._originalSetTimeout = window.setTimeout;
window.setTimeout = function SimpleTest_setTimeoutShim() {
    // Don't break tests that are loaded without a parent runner.
    if (parentRunner) {
        // Right now, we only enable these checks for mochitest-plain.
        switch (SimpleTest.harnessParameters.testRoot) {
        case "browser":
        case "chrome":
        case "a11y":
            break;
        default:
            if (!SimpleTest._alreadyFinished && arguments.length > 1 && arguments[1] > 0) {
                if (SimpleTest._flakyTimeoutIsOK) {
                    SimpleTest.todo(false, "The author of the test has indicated that flaky timeouts are expected.  Reason: " + SimpleTest._flakyTimeoutReason);
                } else {
                    SimpleTest.ok(false, "Test attempted to use a flaky timeout value " + arguments[1]);
                }
            }
        }
    }
    return SimpleTest._originalSetTimeout.apply(window, arguments);
}

/**
 * Request the framework to allow usage of setTimeout(func, timeout)
 * where |timeout > 0|.  This is required to note that the author of
 * the test is aware of the inherent flakiness in the test caused by
 * that, and asserts that there is no way around using the magic timeout
 * value number for some reason.
 *
 * The reason parameter should be a string representation of the
 * reason why using such flaky timeouts.
 *
 * Use of this function is STRONGLY discouraged.  Think twice before
 * using it.  Such magic timeout values could result in intermittent
 * failures in your test, and are almost never necessary!
 */
SimpleTest.requestFlakyTimeout = function (reason) {
    SimpleTest.is(typeof(reason), "string", "A valid string reason is expected");
    SimpleTest.isnot(reason, "", "Reason cannot be empty");
    SimpleTest._flakyTimeoutIsOK = true;
    SimpleTest._flakyTimeoutReason = reason;
}

SimpleTest._pendingWaitForFocusCount = 0;

/**
 * Version of waitForFocus that returns a promise. The Promise will
 * not resolve to the focused window, as it might be a CPOW (and Promises
 * cannot be resolved with CPOWs). If you require the focused window,
 * you should use waitForFocus instead.
 */
SimpleTest.promiseFocus = function (targetWindow, expectBlankPage)
{
    return new Promise(function (resolve, reject) {
        SimpleTest.waitForFocus(win => {
            // Just resolve, without passing the window (see bug 1233497)
            resolve();
        }, targetWindow, expectBlankPage);
    });
}

/**
 * If the page is not yet loaded, waits for the load event. In addition, if
 * the page is not yet focused, focuses and waits for the window to be
 * focused. Calls the callback when completed. If the current page is
 * 'about:blank', then the page is assumed to not yet be loaded. Pass true for
 * expectBlankPage to not make this assumption if you expect a blank page to
 * be present.
 *
 * targetWindow should be specified if it is different than 'window'. The actual
 * focused window may be a descendant of targetWindow.
 *
 * @param callback
 *        function called when load and focus are complete
 * @param targetWindow
 *        optional window to be loaded and focused, defaults to 'window'.
 *        This may also be a <browser> element, in which case the window within
 *        that browser will be focused.
 * @param expectBlankPage
 *        true if targetWindow.location is 'about:blank'. Defaults to false
 */
SimpleTest.waitForFocus = function (callback, targetWindow, expectBlankPage) {
    // A separate method is used that is serialized and passed to the child
    // process via loadFrameScript. Once the child window is focused, the
    // child will send the WaitForFocus:ChildFocused notification to the parent.
    // If a child frame in a child process must be focused, a
    // WaitForFocus:FocusChild message is then sent to the child to focus that
    // child. This message is used so that the child frame can be passed to it.
    function waitForFocusInner(targetWindow, isChildProcess, expectBlankPage)
    {
      /* Indicates whether the desired targetWindow has loaded or focused. The
         finished flag is set when the callback has been called and is used to
         reject extraneous events from invoking the callback again. */
      var loaded = false, focused = false, finished = false;

      function info(msg) {
          if (!isChildProcess) {
              SimpleTest.info(msg);
          }
      }

      function focusedWindow() {
          if (isChildProcess) {
              return Components.classes["@mozilla.org/focus-manager;1"].
                      getService(Components.interfaces.nsIFocusManager).focusedWindow;
          }
          return SpecialPowers.focusedWindow();
      }

      function getHref(aWindow) {
          return isChildProcess ? aWindow.location.href :
                                  SpecialPowers.getPrivilegedProps(aWindow, 'location.href');
      }

      /* Event listener for the load or focus events. It will also be called with
         event equal to null to check if the page is already focused and loaded. */
      function focusedOrLoaded(event) {
          try {
              if (event) {
                  if (event.type == "load") {
                      if (expectBlankPage != (event.target.location == "about:blank")) {
                          return;
                      }

                      loaded = true;
                  } else if (event.type == "focus") {
                      focused = true;
                  }

                  event.currentTarget.removeEventListener(event.type, focusedOrLoaded, true);
              }

              if (loaded && focused && !finished) {
                  finished = true;
                  if (isChildProcess) {
                      sendAsyncMessage("WaitForFocus:ChildFocused", {}, null);
                  } else {
                      SimpleTest._pendingWaitForFocusCount--;
                      SimpleTest.executeSoon(function() { callback(targetWindow) });
                  }
              }
          } catch (e) {
              if (!isChildProcess) {
                  SimpleTest.ok(false, "Exception caught in focusedOrLoaded: " + e.message +
                                ", at: " + e.fileName + " (" + e.lineNumber + ")");
              }
          }
      }

      function waitForLoadAndFocusOnWindow(desiredWindow) {
          /* If the current document is about:blank and we are not expecting a blank
             page (or vice versa), and the document has not yet loaded, wait for the
             page to load. A common situation is to wait for a newly opened window
             to load its content, and we want to skip over any intermediate blank
             pages that load. This issue is described in bug 554873. */
          loaded = expectBlankPage ?
                     getHref(desiredWindow) == "about:blank" :
                     getHref(desiredWindow) != "about:blank" &&
                         desiredWindow.document.readyState == "complete";
          if (!loaded) {
              info("must wait for load");
              desiredWindow.addEventListener("load", focusedOrLoaded, true);
          }

          var childDesiredWindow = { };
          if (isChildProcess) {
              var fm = Components.classes["@mozilla.org/focus-manager;1"].
                         getService(Components.interfaces.nsIFocusManager);
              fm.getFocusedElementForWindow(desiredWindow, true, childDesiredWindow);
              childDesiredWindow = childDesiredWindow.value;
          } else {
              childDesiredWindow = SpecialPowers.getFocusedElementForWindow(desiredWindow, true);
          }

          /* If this is a child frame, ensure that the frame is focused. */
          focused = (focusedWindow() == childDesiredWindow);
          if (!focused) {
              info("must wait for focus");
              childDesiredWindow.addEventListener("focus", focusedOrLoaded, true);
              if (isChildProcess) {
                  childDesiredWindow.focus();
              }
              else {
                  SpecialPowers.focus(childDesiredWindow);
              }
          }

          focusedOrLoaded(null);
      }

      if (isChildProcess) {
          /* This message is used when an inner child frame must be focused. */
          addMessageListener("WaitForFocus:FocusChild", function focusChild(msg) {
              removeMessageListener("WaitForFocus:FocusChild", focusChild);
              finished = false;
              waitForLoadAndFocusOnWindow(msg.objects.child);
          });
      }

      waitForLoadAndFocusOnWindow(targetWindow);
    }

    SimpleTest._pendingWaitForFocusCount++;
    if (!targetWindow) {
        targetWindow = window;
    }

    expectBlankPage = !!expectBlankPage;

    // If this is a request to focus a remote child window, the request must
    // be forwarded to the child process.
    // XXXndeakin now sure what this issue with Components.utils is about, but
    // browser tests require the former and plain tests require the latter.
    var Cu = Components.utils || SpecialPowers.Cu;
    var Ci = Components.interfaces || SpecialPowers.Ci;

    var browser = null;
    if (typeof(XULElement) != "undefined" &&
        targetWindow instanceof XULElement &&
        targetWindow.localName == "browser") {
        browser = targetWindow;
    }

    var isWrapper = Cu.isCrossProcessWrapper(targetWindow);
    if (isWrapper || (browser && browser.isRemoteBrowser)) {
        var mustFocusSubframe = false;
        if (isWrapper) {
            // Look for a tabbrowser and see if targetWindow corresponds to one
            // within that tabbrowser. If not, just return.
            var tabBrowser = document.getElementsByTagName("tabbrowser")[0] || null;
            browser = tabBrowser ? tabBrowser.getBrowserForContentWindow(targetWindow.top) : null;
            if (!browser) {
                SimpleTest.info("child process window cannot be focused");
                return;
            }

            mustFocusSubframe = (targetWindow != targetWindow.top);
        }

        // If a subframe in a child process needs to be focused, first focus the
        // parent frame, then send a WaitForFocus:FocusChild message to the child
        // containing the subframe to focus.
        browser.messageManager.addMessageListener("WaitForFocus:ChildFocused", function waitTest(msg) {
            if (mustFocusSubframe) {
                mustFocusSubframe = false;
                var mm = gBrowser.selectedBrowser.messageManager;
                mm.sendAsyncMessage("WaitForFocus:FocusChild", {}, { child: targetWindow } );
            }
            else {
                browser.messageManager.removeMessageListener("WaitForFocus:ChildFocused", waitTest);
                SimpleTest._pendingWaitForFocusCount--;
                setTimeout(callback, 0, browser ? browser.contentWindowAsCPOW : targetWindow);
            }
        });

        // Serialize the waitForFocusInner function and run it in the child process.
        var frameScript = "data:,(" + waitForFocusInner.toString() +
                          ")(content, true, " + expectBlankPage + ");";
        browser.messageManager.loadFrameScript(frameScript, true);
        browser.focus();
    }
    else {
        // Otherwise, this is an attempt to focus a single process or parent window,
        // so pass false for isChildProcess.
        if (browser) {
          targetWindow = browser.contentWindow;
        }

        waitForFocusInner(targetWindow, false, expectBlankPage);
    }
};

SimpleTest.waitForClipboard_polls = 0;

/*
 * Polls the clipboard waiting for the expected value. A known value different than
 * the expected value is put on the clipboard first (and also polled for) so we
 * can be sure the value we get isn't just the expected value because it was already
 * on the clipboard. This only uses the global clipboard and only for text/unicode
 * values.
 *
 * @param aExpectedStringOrValidatorFn
 *        The string value that is expected to be on the clipboard or a
 *        validator function getting cripboard data and returning a bool.
 * @param aSetupFn
 *        A function responsible for setting the clipboard to the expected value,
 *        called after the known value setting succeeds.
 * @param aSuccessFn
 *        A function called when the expected value is found on the clipboard.
 * @param aFailureFn
 *        A function called if the expected value isn't found on the clipboard
 *        within 5s. It can also be called if the known value can't be found.
 * @param aFlavor [optional] The flavor to look for.  Defaults to "text/unicode".
 * @param aTimeout [optional]
 *        The timeout (in milliseconds) to wait for a clipboard change.
 *        Defaults to 5000.
 * @param aExpectFailure [optional]
 *        If true, fail if the clipboard contents are modified within the timeout
 *        interval defined by aTimeout.  When aExpectFailure is true, the argument
 *        aExpectedStringOrValidatorFn must be null, as it won't be used.
 *        Defaults to false.
 */
SimpleTest.__waitForClipboardMonotonicCounter = 0;
SimpleTest.__defineGetter__("_waitForClipboardMonotonicCounter", function () {
  return SimpleTest.__waitForClipboardMonotonicCounter++;
});
SimpleTest.waitForClipboard = function(aExpectedStringOrValidatorFn, aSetupFn,
                                       aSuccessFn, aFailureFn, aFlavor, aTimeout, aExpectFailure) {
    var requestedFlavor = aFlavor || "text/unicode";

    // The known value we put on the clipboard before running aSetupFn
    var initialVal = SimpleTest._waitForClipboardMonotonicCounter +
                     "-waitForClipboard-known-value";

    var inputValidatorFn;
    if (aExpectFailure) {
        // If we expect failure, the aExpectedStringOrValidatorFn should be null
        if (aExpectedStringOrValidatorFn !== null) {
            SimpleTest.ok(false, "When expecting failure, aExpectedStringOrValidatorFn must be null");
        }

        inputValidatorFn = function(aData) {
            return aData != initialVal;
        };
    } else {
        // Build a default validator function for common string input.
        inputValidatorFn = typeof(aExpectedStringOrValidatorFn) == "string"
            ? function(aData) { return aData == aExpectedStringOrValidatorFn; }
            : aExpectedStringOrValidatorFn;
    }

    var maxPolls = aTimeout ? aTimeout / 100 : 50;

    // reset for the next use
    function reset() {
        SimpleTest.waitForClipboard_polls = 0;
    }

    var lastValue;
    function wait(validatorFn, successFn, failureFn, flavor) {
        if (SimpleTest.waitForClipboard_polls == 0) {
          lastValue = undefined;
        }

        if (++SimpleTest.waitForClipboard_polls > maxPolls) {
            // Log the failure.
            SimpleTest.ok(aExpectFailure, "Timed out while polling clipboard for pasted data");
            dump("Got this value: " + lastValue);
            reset();
            failureFn();
            return;
        }

        var data = SpecialPowers.getClipboardData(flavor);

        if (validatorFn(data)) {
            // Don't show the success message when waiting for preExpectedVal
            if (preExpectedVal)
                preExpectedVal = null;
            else
                SimpleTest.ok(!aExpectFailure, "Clipboard has the given value");
            reset();
            successFn();
        } else {
            lastValue = data;
            SimpleTest._originalSetTimeout.apply(window, [function() { return wait(validatorFn, successFn, failureFn, flavor); }, 100]);
        }
    }

    // First we wait for a known value different from the expected one.
    var preExpectedVal = initialVal;
    SpecialPowers.clipboardCopyString(preExpectedVal);
    wait(function(aData) { return aData  == preExpectedVal; },
         function() {
           // Call the original setup fn
           aSetupFn();
           wait(inputValidatorFn, aSuccessFn, aFailureFn, requestedFlavor);
         }, aFailureFn, "text/unicode");
}

/**
 * Wait for a condition for a while (actually up to 3s here).
 *
 * @param aCond
 *        A function returns the result of the condition
 * @param aCallback
 *        A function called after the condition is passed or timeout.
 * @param aErrorMsg
 *        The message displayed when the condition failed to pass
 *        before timeout.
 */
SimpleTest.waitForCondition = function (aCond, aCallback, aErrorMsg) {
  var tries = 0;
  var interval = setInterval(() => {
    if (tries >= 30) {
      ok(false, aErrorMsg);
      moveOn();
      return;
    }
    var conditionPassed;
    try {
      conditionPassed = aCond();
    } catch (e) {
      ok(false, `${e}\n${e.stack}`);
      conditionPassed = false;
    }
    if (conditionPassed) {
      moveOn();
    }
    tries++;
  }, 100);
  var moveOn = () => { clearInterval(interval); aCallback(); };
};
SimpleTest.promiseWaitForCondition = function (aCond, aErrorMsg) {
  return new Promise(resolve => {
    this.waitForCondition(aCond, resolve, aErrorMsg);
  });
};

/**
 * Executes a function shortly after the call, but lets the caller continue
 * working (or finish).
 */
SimpleTest.executeSoon = function(aFunc) {
    if ("SpecialPowers" in window) {
        return SpecialPowers.executeSoon(aFunc, window);
    }
    setTimeout(aFunc, 0);
    return null;		// Avoid warning.
};

SimpleTest.registerCleanupFunction = function(aFunc) {
    SimpleTest._cleanupFunctions.push(aFunc);
};

SimpleTest.registerTimeoutFunction = function(aFunc) {
    SimpleTest._timeoutFunctions.push(aFunc);
};

SimpleTest.testInChaosMode = function() {
    if (SimpleTest._inChaosMode) {
      // It's already enabled for this test, don't enter twice
      return;
    }
    SpecialPowers.DOMWindowUtils.enterChaosMode();
    SimpleTest._inChaosMode = true;
};

SimpleTest.timeout = function() {
    for (let func of SimpleTest._timeoutFunctions) {
        func();
    }
    SimpleTest._timeoutFunctions = [];
}

/**
 * Finishes the tests. This is automatically called, except when
 * SimpleTest.waitForExplicitFinish() has been invoked.
**/
SimpleTest.finish = function() {
    if (SimpleTest._alreadyFinished) {
        var err = "[SimpleTest.finish()] this test already called finish!";
        if (parentRunner) {
            parentRunner.structuredLogger.error(err);
        } else {
            dump(err + '\n');
        }
    }

    if (SimpleTest.expected == 'fail' && SimpleTest.num_failed <= 0) {
        msg = 'We expected at least one failure';
        var test = {'result': false, 'name': 'fail-if condition in manifest', 'diag': msg};
        var successInfo = {status:"FAIL", expected:"FAIL", message:"TEST-KNOWN-FAIL"};
        var failureInfo = {status:"PASS", expected:"FAIL", message:"TEST-UNEXPECTED-PASS"};

        SimpleTest._logResult(test, successInfo, failureInfo);
        SimpleTest._tests.push(test);
    } else if (usesFailurePatterns()) {
        SimpleTest.expected.forEach(([pat, expected_count], i) => {
            let count = SimpleTest.num_failed[i];
            let diag;
            if (expected_count === null && count == 0) {
                diag = "expected some failures but got none";
            } else if (expected_count !== null && expected_count != count) {
                diag = `expected ${expected_count} failures but got ${count}`;
            } else {
                return;
            }
            var name = pat ? `failure pattern \`${pat}\` in this test` : "failures in this test";
            var test = {'result': false, name, diag};
            var successInfo = {status:"PASS", expected:"PASS", message:"TEST-PASS"};
            var failureInfo = {status:"FAIL", expected:"PASS", message:"TEST-UNEXPECTED-FAIL"};
            SimpleTest._logResult(test, successInfo, failureInfo);
            SimpleTest._tests.push(test);
        });
    }

    SimpleTest._timeoutFunctions = [];

    SimpleTest.testsLength = SimpleTest._tests.length;

    SimpleTest._alreadyFinished = true;

    if (SimpleTest._inChaosMode) {
        SpecialPowers.DOMWindowUtils.leaveChaosMode();
        SimpleTest._inChaosMode = false;
    }

    var afterCleanup = function() {
        SpecialPowers.removeFiles();

        if (SpecialPowers.DOMWindowUtils.isTestControllingRefreshes) {
            SimpleTest.ok(false, "test left refresh driver under test control");
            SpecialPowers.DOMWindowUtils.restoreNormalRefresh();
        }
        if (SimpleTest._expectingUncaughtException) {
            SimpleTest.ok(false, "expectUncaughtException was called but no uncaught exception was detected!");
        }
        if (SimpleTest._pendingWaitForFocusCount != 0) {
            SimpleTest.is(SimpleTest._pendingWaitForFocusCount, 0,
                          "[SimpleTest.finish()] waitForFocus() was called a "
                          + "different number of times from the number of "
                          + "callbacks run.  Maybe the test terminated "
                          + "prematurely -- be sure to use "
                          + "SimpleTest.waitForExplicitFinish().");
        }
        if (SimpleTest._tests.length == 0) {
            SimpleTest.ok(false, "[SimpleTest.finish()] No checks actually run. "
                               + "(You need to call ok(), is(), or similar "
                               + "functions at least once.  Make sure you use "
                               + "SimpleTest.waitForExplicitFinish() if you need "
                               + "it.)");
        }
        if (SimpleTest._expectingRegisteredServiceWorker) {
            if (!SpecialPowers.isServiceWorkerRegistered()) {
                SimpleTest.ok(false, "This test is expected to leave a service worker registered");
            }
        } else {
            if (SpecialPowers.isServiceWorkerRegistered()) {
                SimpleTest.ok(false, "This test left a service worker registered without cleaning it up");
            }
        }

        if (parentRunner) {
            /* We're running in an iframe, and the parent has a TestRunner */
            parentRunner.testFinished(SimpleTest._tests);
        }

        if (!parentRunner || parentRunner.showTestReport) {
            SpecialPowers.flushPermissions(function () {
              SpecialPowers.flushPrefEnv(function() {
                SimpleTest.showReport();
              });
            });
        }
    }

    var executeCleanupFunction = function() {
        var func = SimpleTest._cleanupFunctions.pop();

        if (!func) {
            afterCleanup();
            return;
        }

        var ret;
        try {
            ret = func();
        } catch (ex) {
            SimpleTest.ok(false, "Cleanup function threw exception: " + ex);
        }

        if (ret && ret.constructor.name == "Promise") {
            ret.then(executeCleanupFunction,
                     (ex) => SimpleTest.ok(false, "Cleanup promise rejected: " + ex));
        } else {
            executeCleanupFunction();
        }
    };

    executeCleanupFunction();
};

/**
 * Monitor console output from now until endMonitorConsole is called.
 *
 * Expect to receive all console messages described by the elements of
 * |msgs|, an array, in the order listed in |msgs|; each element is an
 * object which may have any number of the following properties:
 *   message, errorMessage, sourceName, sourceLine, category:
 *     string or regexp
 *   lineNumber, columnNumber: number
 *   isScriptError, isWarning, isException, isStrict: boolean
 * Strings, numbers, and booleans must compare equal to the named
 * property of the Nth console message.  Regexps must match.  Any
 * fields present in the message but not in the pattern object are ignored.
 *
 * In addition to the above properties, elements in |msgs| may have a |forbid|
 * boolean property.  When |forbid| is true, a failure is logged each time a
 * matching message is received.
 *
 * If |forbidUnexpectedMsgs| is true, then the messages received in the console
 * must exactly match the non-forbidden messages in |msgs|; for each received
 * message not described by the next element in |msgs|, a failure is logged.  If
 * false, then other non-forbidden messages are ignored, but all expected
 * messages must still be received.
 *
 * After endMonitorConsole is called, |continuation| will be called
 * asynchronously.  (Normally, you will want to pass |SimpleTest.finish| here.)
 *
 * It is incorrect to use this function in a test which has not called
 * SimpleTest.waitForExplicitFinish.
 */
SimpleTest.monitorConsole = function (continuation, msgs, forbidUnexpectedMsgs) {
  if (SimpleTest._stopOnLoad) {
    ok(false, "Console monitoring requires use of waitForExplicitFinish.");
  }

  function msgMatches(msg, pat) {
    for (var k in pat) {
      if (!(k in msg)) {
        return false;
      }
      if (pat[k] instanceof RegExp && typeof(msg[k]) === 'string') {
        if (!pat[k].test(msg[k])) {
          return false;
        }
      } else if (msg[k] !== pat[k]) {
        return false;
      }
    }
    return true;
  }

  var forbiddenMsgs = [];
  var i = 0;
  while (i < msgs.length) {
    var pat = msgs[i];
    if ("forbid" in pat) {
      var forbid = pat.forbid;
      delete pat.forbid;
      if (forbid) {
        forbiddenMsgs.push(pat);
        msgs.splice(i, 1);
        continue;
      }
    }
    i++;
  }

  var counter = 0;
  var assertionLabel = msgs.toSource();
  function listener(msg) {
    if (msg.message === "SENTINEL" && !msg.isScriptError) {
      is(counter, msgs.length,
         "monitorConsole | number of messages " + assertionLabel);
      SimpleTest.executeSoon(continuation);
      return;
    }
    for (var pat of forbiddenMsgs) {
      if (msgMatches(msg, pat)) {
        ok(false, "monitorConsole | observed forbidden message " +
                  JSON.stringify(msg));
        return;
      }
    }
    if (counter >= msgs.length) {
      var str = "monitorConsole | extra message | " + JSON.stringify(msg);
      if (forbidUnexpectedMsgs) {
        ok(false, str);
      } else {
        info(str);
      }
      return;
    }
    var matches = msgMatches(msg, msgs[counter]);
    if (forbidUnexpectedMsgs) {
      ok(matches, "monitorConsole | [" + counter + "] must match " +
                  JSON.stringify(msg));
    } else {
      info("monitorConsole | [" + counter + "] " +
           (matches ? "matched " : "did not match ") + JSON.stringify(msg));
    }
    if (matches)
      counter++;
  }
  SpecialPowers.registerConsoleListener(listener);
};

/**
 * Stop monitoring console output.
 */
SimpleTest.endMonitorConsole = function () {
  SpecialPowers.postConsoleSentinel();
};

/**
 * Run |testfn| synchronously, and monitor its console output.
 *
 * |msgs| is handled as described above for monitorConsole.
 *
 * After |testfn| returns, console monitoring will stop, and
 * |continuation| will be called asynchronously.
 */
SimpleTest.expectConsoleMessages = function (testfn, msgs, continuation) {
  SimpleTest.monitorConsole(continuation, msgs);
  testfn();
  SimpleTest.executeSoon(SimpleTest.endMonitorConsole);
};

/**
 * Wrapper around |expectConsoleMessages| for the case where the test has
 * only one |testfn| to run.
 */
SimpleTest.runTestExpectingConsoleMessages = function(testfn, msgs) {
  SimpleTest.waitForExplicitFinish();
  SimpleTest.expectConsoleMessages(testfn, msgs, SimpleTest.finish);
};

/**
 * Indicates to the test framework that the current test expects one or
 * more crashes (from plugins or IPC documents), and that the minidumps from
 * those crashes should be removed.
 */
SimpleTest.expectChildProcessCrash = function () {
    if (parentRunner) {
        parentRunner.expectChildProcessCrash();
    }
};

/**
 * Indicates to the test framework that the next uncaught exception during
 * the test is expected, and should not cause a test failure.
 */
SimpleTest.expectUncaughtException = function (aExpecting) {
    SimpleTest._expectingUncaughtException = aExpecting === void 0 || !!aExpecting;
};

/**
 * Returns whether the test has indicated that it expects an uncaught exception
 * to occur.
 */
SimpleTest.isExpectingUncaughtException = function () {
    return SimpleTest._expectingUncaughtException;
};

/**
 * Indicates to the test framework that all of the uncaught exceptions
 * during the test are known problems that should be fixed in the future,
 * but which should not cause the test to fail currently.
 */
SimpleTest.ignoreAllUncaughtExceptions = function (aIgnoring) {
    SimpleTest._ignoringAllUncaughtExceptions = aIgnoring === void 0 || !!aIgnoring;
};

/**
 * Returns whether the test has indicated that all uncaught exceptions should be
 * ignored.
 */
SimpleTest.isIgnoringAllUncaughtExceptions = function () {
    return SimpleTest._ignoringAllUncaughtExceptions;
};

/**
 * Indicates to the test framework that this test is expected to leave a
 * service worker registered when it finishes.
 */
SimpleTest.expectRegisteredServiceWorker = function () {
    SimpleTest._expectingRegisteredServiceWorker = true;
};

/**
 * Resets any state this SimpleTest object has.  This is important for
 * browser chrome mochitests, which reuse the same SimpleTest object
 * across a run.
 */
SimpleTest.reset = function () {
    SimpleTest._ignoringAllUncaughtExceptions = false;
    SimpleTest._expectingUncaughtException = false;
    SimpleTest._expectingRegisteredServiceWorker = false;
    SimpleTest._bufferedMessages = [];
};

if (isPrimaryTestWindow) {
    addLoadEvent(function() {
        if (SimpleTest._stopOnLoad) {
            SimpleTest.finish();
        }
    });
}

//  --------------- Test.Builder/Test.More isDeeply() -----------------


SimpleTest.DNE = {dne: 'Does not exist'};
SimpleTest.LF = "\r\n";


SimpleTest._deepCheck = function (e1, e2, stack, seen) {
    var ok = false;
    if (Object.is(e1, e2)) {
        // Handles identical primitives and references.
        ok = true;
    } else if (typeof e1 != "object" || typeof e2 != "object" || e1 === null || e2 === null) {
        // If either argument is a primitive or function, don't consider the arguments the same.
        ok = false;
    } else if (e1 == SimpleTest.DNE || e2 == SimpleTest.DNE) {
        ok = false;
    } else if (SimpleTest.isa(e1, 'Array') && SimpleTest.isa(e2, 'Array')) {
        ok = SimpleTest._eqArray(e1, e2, stack, seen);
    } else {
        ok = SimpleTest._eqAssoc(e1, e2, stack, seen);
    }
    return ok;
};

SimpleTest._eqArray = function (a1, a2, stack, seen) {
    // Return if they're the same object.
    if (a1 == a2) return true;

    // JavaScript objects have no unique identifiers, so we have to store
    // references to them all in an array, and then compare the references
    // directly. It's slow, but probably won't be much of an issue in
    // practice. Start by making a local copy of the array to as to avoid
    // confusing a reference seen more than once (such as [a, a]) for a
    // circular reference.
    for (var j = 0; j < seen.length; j++) {
        if (seen[j][0] == a1) {
            return seen[j][1] == a2;
        }
    }

    // If we get here, we haven't seen a1 before, so store it with reference
    // to a2.
    seen.push([ a1, a2 ]);

    var ok = true;
    // Only examines enumerable attributes. Only works for numeric arrays!
    // Associative arrays return 0. So call _eqAssoc() for them, instead.
    var max = Math.max(a1.length, a2.length);
    if (max == 0) return SimpleTest._eqAssoc(a1, a2, stack, seen);
    for (var i = 0; i < max; i++) {
        var e1 = i < a1.length ? a1[i] : SimpleTest.DNE;
        var e2 = i < a2.length ? a2[i] : SimpleTest.DNE;
        stack.push({ type: 'Array', idx: i, vals: [e1, e2] });
        ok = SimpleTest._deepCheck(e1, e2, stack, seen);
        if (ok) {
            stack.pop();
        } else {
            break;
        }
    }
    return ok;
};

SimpleTest._eqAssoc = function (o1, o2, stack, seen) {
    // Return if they're the same object.
    if (o1 == o2) return true;

    // JavaScript objects have no unique identifiers, so we have to store
    // references to them all in an array, and then compare the references
    // directly. It's slow, but probably won't be much of an issue in
    // practice. Start by making a local copy of the array to as to avoid
    // confusing a reference seen more than once (such as [a, a]) for a
    // circular reference.
    seen = seen.slice(0);
    for (var j = 0; j < seen.length; j++) {
        if (seen[j][0] == o1) {
            return seen[j][1] == o2;
        }
    }

    // If we get here, we haven't seen o1 before, so store it with reference
    // to o2.
    seen.push([ o1, o2 ]);

    // They should be of the same class.

    var ok = true;
    // Only examines enumerable attributes.
    var o1Size = 0; for (var i in o1) o1Size++;
    var o2Size = 0; for (var i in o2) o2Size++;
    var bigger = o1Size > o2Size ? o1 : o2;
    for (var i in bigger) {
        var e1 = i in o1 ? o1[i] : SimpleTest.DNE;
        var e2 = i in o2 ? o2[i] : SimpleTest.DNE;
        stack.push({ type: 'Object', idx: i, vals: [e1, e2] });
        ok = SimpleTest._deepCheck(e1, e2, stack, seen)
        if (ok) {
            stack.pop();
        } else {
            break;
        }
    }
    return ok;
};

SimpleTest._formatStack = function (stack) {
    var variable = '$Foo';
    for (var i = 0; i < stack.length; i++) {
        var entry = stack[i];
        var type = entry['type'];
        var idx = entry['idx'];
        if (idx != null) {
            if (type == 'Array') {
                // Numeric array index.
                variable += '[' + idx + ']';
            } else {
                // Associative array index.
                idx = idx.replace("'", "\\'");
                variable += "['" + idx + "']";
            }
        }
    }

    var vals = stack[stack.length-1]['vals'].slice(0, 2);
    var vars = [
        variable.replace('$Foo',     'got'),
        variable.replace('$Foo',     'expected')
    ];

    var out = "Structures begin differing at:" + SimpleTest.LF;
    for (var i = 0; i < vals.length; i++) {
        var val = vals[i];
        if (val === SimpleTest.DNE) {
            val = "Does not exist";
        } else {
            val = repr(val);
        }
        out += vars[i] + ' = ' + val + SimpleTest.LF;
    }

    return '    ' + out;
};


SimpleTest.isDeeply = function (it, as, name) {
    var stack = [{ vals: [it, as] }];
    var seen = [];
    if ( SimpleTest._deepCheck(it, as, stack, seen)) {
        SimpleTest.ok(true, name);
    } else {
        SimpleTest.ok(false, name, SimpleTest._formatStack(stack));
    }
};

SimpleTest.typeOf = function (object) {
    var c = Object.prototype.toString.apply(object);
    var name = c.substring(8, c.length - 1);
    if (name != 'Object') return name;
    // It may be a non-core class. Try to extract the class name from
    // the constructor function. This may not work in all implementations.
    if (/function ([^(\s]+)/.test(Function.toString.call(object.constructor))) {
        return RegExp.$1;
    }
    // No idea. :-(
    return name;
};

SimpleTest.isa = function (object, clas) {
    return SimpleTest.typeOf(object) == clas;
};

// Global symbols:
var ok = SimpleTest.ok;
var is = SimpleTest.is;
var isfuzzy = SimpleTest.isfuzzy;
var isnot = SimpleTest.isnot;
var todo = SimpleTest.todo;
var todo_is = SimpleTest.todo_is;
var todo_isnot = SimpleTest.todo_isnot;
var isDeeply = SimpleTest.isDeeply;
var info = SimpleTest.info;

var gOldOnError = window.onerror;
window.onerror = function simpletestOnerror(errorMsg, url, lineNumber,
                                            columnNumber, originalException) {
    // Log the message.
    // XXX Chrome mochitests sometimes trigger this window.onerror handler,
    // but there are a number of uncaught JS exceptions from those tests.
    // For now, for tests that self identify as having unintentional uncaught
    // exceptions, just dump it so that the error is visible but doesn't cause
    // a test failure.  See bug 652494.
    var isExpected = !!SimpleTest._expectingUncaughtException;
    var message = (isExpected ? "expected " : "") + "uncaught exception";
    var error = errorMsg + " at ";
    try {
        error += originalException.stack;
    } catch (e) {
        // At least use the url+line+column we were given
        error += url + ":" + lineNumber + ":" + columnNumber;
    }
    if (!SimpleTest._ignoringAllUncaughtExceptions) {
        // Don't log if SimpleTest.finish() is already called, it would cause failures
        if (!SimpleTest._alreadyFinished)
          SimpleTest.ok(isExpected, message, error);
        SimpleTest._expectingUncaughtException = false;
    } else {
        SimpleTest.todo(false, message + ": " + error);
    }
    // There is no Components.stack.caller to log. (See bug 511888.)

    // Call previous handler.
    if (gOldOnError) {
        try {
            // Ignore return value: always run default handler.
            gOldOnError(errorMsg, url, lineNumber);
        } catch (e) {
            // Log the error.
            SimpleTest.info("Exception thrown by gOldOnError(): " + e);
            // Log its stack.
            if (e.stack) {
                SimpleTest.info("JavaScript error stack:\n" + e.stack);
            }
        }
    }

    if (!SimpleTest._stopOnLoad && !isExpected && !SimpleTest._alreadyFinished) {
        // Need to finish() manually here, yet let the test actually end first.
        SimpleTest.executeSoon(SimpleTest.finish);
    }
};

// Lifted from dom/media/test/manifest.js
// Make sure to not touch navigator in here, since we want to push prefs that
// will affect the APIs it exposes, but the set of exposed APIs is determined
// when Navigator.prototype is created.  So if we touch navigator before pushing
// the prefs, the APIs it exposes will not take those prefs into account.  We
// work around this by using a navigator object from a different global for our
// UA string testing.
var gAndroidSdk = null;
function getAndroidSdk() {
    if (gAndroidSdk === null) {
        var iframe = document.documentElement.appendChild(document.createElement("iframe"));
        iframe.style.display = "none";
        var nav = iframe.contentWindow.navigator;
        if (nav.userAgent.indexOf("Mobile") == -1 &&
            nav.userAgent.indexOf("Tablet") == -1) {
            gAndroidSdk = -1;
        } else {
            // See nsSystemInfo.cpp, the getProperty('version') returns different value
            // on each platforms, so we need to distinguish the android platform.
            var versionString = nav.userAgent.indexOf("Android") != -1 ?
                                'version' : 'sdk_version';
            gAndroidSdk = SpecialPowers.Cc['@mozilla.org/system-info;1']
                                       .getService(SpecialPowers.Ci.nsIPropertyBag2)
                                       .getProperty(versionString);
        }
        document.documentElement.removeChild(iframe);
    }
    return gAndroidSdk;
}

// Request complete log when using failure patterns so that failure info
// from infra can be useful.
if (usesFailurePatterns()) {
  SimpleTest.requestCompleteLog();
}
