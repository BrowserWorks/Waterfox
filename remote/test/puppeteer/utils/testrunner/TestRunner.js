/**
 * Copyright 2017 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const path = require('path');
const EventEmitter = require('events');
const Multimap = require('./Multimap');

const TimeoutError = new Error('Timeout');
const TerminatedError = new Error('Terminated');

const MAJOR_NODEJS_VERSION = parseInt(process.version.substring(1).split('.')[0], 10);

class UserCallback {
  constructor(callback, timeout) {
    this._callback = callback;
    this._terminatePromise = new Promise(resolve => {
      this._terminateCallback = resolve;
    });

    this.timeout = timeout;
    this.location = this._getLocation();
  }

  async run(...args) {
    let timeoutId;
    const timeoutPromise = new Promise(resolve => {
      timeoutId = setTimeout(resolve.bind(null, TimeoutError), this.timeout);
    });
    try {
      return await Promise.race([
        Promise.resolve().then(this._callback.bind(null, ...args)).then(() => null).catch(e => e),
        timeoutPromise,
        this._terminatePromise
      ]);
    } catch (e) {
      return e;
    } finally {
      clearTimeout(timeoutId);
    }
  }

  _getLocation() {
    const error = new Error();
    const stackFrames = error.stack.split('\n').slice(1);
    // Find first stackframe that doesn't point to this file.
    for (let frame of stackFrames) {
      frame = frame.trim();
      if (!frame.startsWith('at '))
        return null;
      if (frame.endsWith(')')) {
        const from = frame.indexOf('(');
        frame = frame.substring(from + 1, frame.length - 1);
      } else {
        frame = frame.substring('at '.length);
      }

      const match = frame.match(/^(.*):(\d+):(\d+)$/);
      if (!match)
        return null;
      const filePath = match[1];
      const lineNumber = match[2];
      const columnNumber = match[3];
      if (filePath === __filename)
        continue;
      const fileName = filePath.split(path.sep).pop();
      return { fileName, filePath, lineNumber, columnNumber };
    }
    return null;
  }

  terminate() {
    this._terminateCallback(TerminatedError);
  }
}

const TestMode = {
  Run: 'run',
  Skip: 'skip',
  Focus: 'focus'
};

const TestResult = {
  Ok: 'ok',
  Skipped: 'skipped', // User skipped the test
  Failed: 'failed', // Exception happened during running
  TimedOut: 'timedout', // Timeout Exceeded while running
  Terminated: 'terminated', // Execution terminated
  Crashed: 'crashed', // If testrunner crashed due to this test
};

class Test {
  constructor(suite, name, callback, declaredMode, timeout, comment) {
    this.suite = suite;
    this.name = name;
    this.fullName = (suite.fullName + ' ' + name).trim();
    this.declaredMode = declaredMode;
    this._userCallback = new UserCallback(callback, timeout);
    this.location = this._userCallback.location;
    this.comment = comment;

    // Test results
    this.result = null;
    this.error = null;
    this.startTimestamp = 0;
    this.endTimestamp = 0;
  }
}

class Suite {
  constructor(parentSuite, name, declaredMode, comment) {
    this.parentSuite = parentSuite;
    this.name = name;
    this.fullName = (parentSuite ? parentSuite.fullName + ' ' + name : name).trim();
    this.declaredMode = declaredMode;
    this.comment = comment;
    /** @type {!Array<(!Test|!Suite)>} */
    this.children = [];

    this.beforeAll = null;
    this.beforeEach = null;
    this.afterAll = null;
    this.afterEach = null;
  }
}

class TestPass {
  constructor(runner, rootSuite, tests, parallel, breakOnFailure) {
    this._runner = runner;
    this._parallel = parallel;
    this._runningUserCallbacks = new Multimap();
    this._breakOnFailure = breakOnFailure;

    this._rootSuite = rootSuite;
    this._workerDistribution = new Multimap();

    let workerId = 0;
    for (const test of tests) {
      // Reset results for tests that will be run.
      test.result = null;
      test.error = null;
      this._workerDistribution.set(test, workerId);
      for (let suite = test.suite; suite; suite = suite.parentSuite)
        this._workerDistribution.set(suite, workerId);
      // Do not shard skipped tests across workers.
      if (test.declaredMode !== TestMode.Skip)
        workerId = (workerId + 1) % parallel;
    }

    this._termination = null;
  }

  async run() {
    const terminations = [
      createTermination.call(this, 'SIGINT', TestResult.Terminated, 'SIGINT received'),
      createTermination.call(this, 'SIGHUP', TestResult.Terminated, 'SIGHUP received'),
      createTermination.call(this, 'SIGTERM', TestResult.Terminated, 'SIGTERM received'),
      createTermination.call(this, 'unhandledRejection', TestResult.Crashed, 'UNHANDLED PROMISE REJECTION'),
    ];
    for (const termination of terminations)
      process.on(termination.event, termination.handler);

    const workerPromises = [];
    for (let i = 0; i < this._parallel; ++i)
      workerPromises.push(this._runSuite(i, [this._rootSuite], {parallelIndex: i}));
    await Promise.all(workerPromises);

    for (const termination of terminations)
      process.removeListener(termination.event, termination.handler);
    return this._termination;

    function createTermination(event, result, message) {
      return {
        event,
        message,
        handler: error => this._terminate(result, message, error)
      };
    }
  }

  async _runSuite(workerId, suitesStack, state) {
    if (this._termination)
      return;
    const currentSuite = suitesStack[suitesStack.length - 1];
    if (!this._workerDistribution.hasValue(currentSuite, workerId))
      return;
    await this._runHook(workerId, currentSuite, 'beforeAll', state);
    for (const child of currentSuite.children) {
      if (this._termination)
        break;
      if (!this._workerDistribution.hasValue(child, workerId))
        continue;
      if (child instanceof Test) {
        await this._runTest(workerId, suitesStack, child, state);
      } else {
        suitesStack.push(child);
        await this._runSuite(workerId, suitesStack, state);
        suitesStack.pop();
      }
    }
    await this._runHook(workerId, currentSuite, 'afterAll', state);
  }

  async _runTest(workerId, suitesStack, test, state) {
    if (this._termination)
      return;
    this._runner._willStartTest(test, workerId);
    if (test.declaredMode === TestMode.Skip) {
      test.result = TestResult.Skipped;
      this._runner._didFinishTest(test, workerId);
      return;
    }
    let crashed = false;
    for (let i = 0; i < suitesStack.length; i++)
      crashed = (await this._runHook(workerId, suitesStack[i], 'beforeEach', state, test)) || crashed;
    // If some of the beofreEach hooks error'ed - terminate this test.
    if (crashed) {
      test.result = TestResult.Crashed;
    } else if (this._termination) {
      test.result = TestResult.Terminated;
    } else {
      // Otherwise, run the test itself if there is no scheduled termination.
      this._runningUserCallbacks.set(workerId, test._userCallback);
      test.error = await test._userCallback.run(state, test);
      this._runningUserCallbacks.delete(workerId, test._userCallback);
      if (!test.error)
        test.result = TestResult.Ok;
      else if (test.error === TimeoutError)
        test.result = TestResult.TimedOut;
      else if (test.error === TerminatedError)
        test.result = TestResult.Terminated;
      else
        test.result = TestResult.Failed;
    }
    for (let i = suitesStack.length - 1; i >= 0; i--)
      crashed = (await this._runHook(workerId, suitesStack[i], 'afterEach', state, test)) || crashed;
    // If some of the afterEach hooks error'ed - then this test is considered to be crashed as well.
    if (crashed)
      test.result = TestResult.Crashed;
    this._runner._didFinishTest(test, workerId);
    if (this._breakOnFailure && test.result !== TestResult.Ok)
      this._terminate(TestResult.Terminated, `Terminating because a test has failed and |testRunner.breakOnFailure| is enabled`, null);
  }

  async _runHook(workerId, suite, hookName, ...args) {
    const hook = suite[hookName];
    if (!hook)
      return false;
    this._runningUserCallbacks.set(workerId, hook);
    const error = await hook.run(...args);
    this._runningUserCallbacks.delete(workerId, hook);
    if (error === TimeoutError) {
      const location = `${hook.location.fileName}:${hook.location.lineNumber}:${hook.location.columnNumber}`;
      const message = `${location} - Timeout Exceeded ${hook.timeout}ms while running "${hookName}" in suite "${suite.fullName}"`;
      return this._terminate(TestResult.Crashed, message, null);
    }
    if (error) {
      const location = `${hook.location.fileName}:${hook.location.lineNumber}:${hook.location.columnNumber}`;
      const message = `${location} - FAILED while running "${hookName}" in suite "${suite.fullName}"`;
      return this._terminate(TestResult.Crashed, message, error);
    }
    return false;
  }

  _terminate(result, message, error) {
    if (this._termination)
      return false;
    this._termination = {result, message, error};
    for (const userCallback of this._runningUserCallbacks.valuesArray())
      userCallback.terminate();
    return true;
  }
}

class TestRunner extends EventEmitter {
  constructor(options = {}) {
    super();
    const {
      timeout = 10 * 1000, // Default timeout is 10 seconds.
      parallel = 1,
      breakOnFailure = false,
      disableTimeoutWhenInspectorIsEnabled = true,
    } = options;
    this._rootSuite = new Suite(null, '', TestMode.Run);
    this._currentSuite = this._rootSuite;
    this._tests = [];
    this._timeout = timeout === 0 ? 2147483647 : timeout;
    this._parallel = parallel;
    this._breakOnFailure = breakOnFailure;

    this._hasFocusedTestsOrSuites = false;

    if (MAJOR_NODEJS_VERSION >= 8 && disableTimeoutWhenInspectorIsEnabled) {
      const inspector = require('inspector');
      if (inspector.url()) {
        console.log('TestRunner detected inspector; overriding certain properties to be debugger-friendly');
        console.log('  - timeout = 0 (Infinite)');
        this._timeout = 2147483647;
      }
    }

    // bind methods so that they can be used as a DSL.
    this.describe = this._addSuite.bind(this, TestMode.Run, '');
    this.fdescribe = this._addSuite.bind(this, TestMode.Focus, '');
    this.xdescribe = this._addSuite.bind(this, TestMode.Skip, '');
    this.it = this._addTest.bind(this, TestMode.Run, '');
    this.fit = this._addTest.bind(this, TestMode.Focus, '');
    this.xit = this._addTest.bind(this, TestMode.Skip, '');
    this.beforeAll = this._addHook.bind(this, 'beforeAll');
    this.beforeEach = this._addHook.bind(this, 'beforeEach');
    this.afterAll = this._addHook.bind(this, 'afterAll');
    this.afterEach = this._addHook.bind(this, 'afterEach');
  }

  addTestDSL(dslName, mode, comment) {
    this[dslName] = this._addTest.bind(this, mode, comment);
  }

  addSuiteDSL(dslName, mode, comment) {
    this[dslName] = this._addSuite.bind(this, mode, comment);
  }

  _addTest(mode, comment, name, callback) {
    let suite = this._currentSuite;
    let isSkipped = suite.declaredMode === TestMode.Skip;
    while ((suite = suite.parentSuite))
      isSkipped |= suite.declaredMode === TestMode.Skip;
    const test = new Test(this._currentSuite, name, callback, isSkipped ? TestMode.Skip : mode, this._timeout, comment);
    this._currentSuite.children.push(test);
    this._tests.push(test);
    this._hasFocusedTestsOrSuites = this._hasFocusedTestsOrSuites || mode === TestMode.Focus;
  }

  async _addSuite(mode, comment, name, callback) {
    const oldSuite = this._currentSuite;
    const suite = new Suite(this._currentSuite, name, mode, comment);
    this._currentSuite.children.push(suite);
    this._currentSuite = suite;
    const result = callback();
    if (result && (typeof result.then === 'function'))
      await result;
    this._currentSuite = oldSuite;
    this._hasFocusedTestsOrSuites = this._hasFocusedTestsOrSuites || mode === TestMode.Focus;
  }

  _addHook(hookName, callback) {
    assert(this._currentSuite[hookName] === null, `Only one ${hookName} hook available per suite`);
    const hook = new UserCallback(callback, this._timeout);
    this._currentSuite[hookName] = hook;
  }

  async run() {
    const runnableTests = this._runnableTests();
    this.emit(TestRunner.Events.Started, runnableTests);
    this._runningPass = new TestPass(this, this._rootSuite, runnableTests, this._parallel, this._breakOnFailure);
    const termination = await this._runningPass.run();
    this._runningPass = null;
    const result = {};
    if (termination) {
      result.result = termination.result;
      result.terminationMessage = termination.message;
      result.terminationError = termination.error;
    } else {
      result.result = this.failedTests().length ? TestResult.Failed : TestResult.Ok;
    }
    this.emit(TestRunner.Events.Finished, result);
    return result;
  }

  terminate() {
    if (!this._runningPass)
      return;
    this._runningPass._terminate(TestResult.Terminated, 'Terminated with |TestRunner.terminate()| call', null);
  }

  timeout() {
    return this._timeout;
  }

  _runnableTests() {
    if (!this._hasFocusedTestsOrSuites)
      return this._tests;

    const tests = [];
    const blacklistSuites = new Set();
    // First pass: pick "fit" and blacklist parent suites
    for (const test of this._tests) {
      if (test.declaredMode !== TestMode.Focus)
        continue;
      tests.push(test);
      for (let suite = test.suite; suite; suite = suite.parentSuite)
        blacklistSuites.add(suite);
    }
    // Second pass: pick all tests that belong to non-blacklisted "fdescribe"
    for (const test of this._tests) {
      let insideFocusedSuite = false;
      for (let suite = test.suite; suite; suite = suite.parentSuite) {
        if (!blacklistSuites.has(suite) && suite.declaredMode === TestMode.Focus) {
          insideFocusedSuite = true;
          break;
        }
      }
      if (insideFocusedSuite)
        tests.push(test);
    }
    return tests;
  }

  hasFocusedTestsOrSuites() {
    return this._hasFocusedTestsOrSuites;
  }

  tests() {
    return this._tests.slice();
  }

  failedTests() {
    return this._tests.filter(test => test.result === 'failed' || test.result === 'timedout' || test.result === 'crashed');
  }

  passedTests() {
    return this._tests.filter(test => test.result === 'ok');
  }

  skippedTests() {
    return this._tests.filter(test => test.result === 'skipped');
  }

  parallel() {
    return this._parallel;
  }

  _willStartTest(test, workerId) {
    test.startTimestamp = Date.now();
    this.emit(TestRunner.Events.TestStarted, test, workerId);
  }

  _didFinishTest(test, workerId) {
    test.endTimestamp = Date.now();
    this.emit(TestRunner.Events.TestFinished, test, workerId);
  }
}

/**
 * @param {*} value
 * @param {string=} message
 */
function assert(value, message) {
  if (!value)
    throw new Error(message);
}

TestRunner.Events = {
  Started: 'started',
  Finished: 'finished',
  TestStarted: 'teststarted',
  TestFinished: 'testfinished',
};

module.exports = TestRunner;
