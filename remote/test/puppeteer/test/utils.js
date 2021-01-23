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

const fs = require('fs');
const path = require('path');
const {FlakinessDashboard} = require('../utils/flakiness-dashboard');
const PROJECT_ROOT = fs.existsSync(path.join(__dirname, '..', 'package.json')) ? path.join(__dirname, '..') : path.join(__dirname, '..', '..');

const COVERAGE_TESTSUITE_NAME = '**API COVERAGE**';

/**
 * @param {Map<string, boolean>} apiCoverage
 * @param {Object} events
 * @param {string} className
 * @param {!Object} classType
 */
function traceAPICoverage(apiCoverage, events, className, classType) {
  className = className.substring(0, 1).toLowerCase() + className.substring(1);
  for (const methodName of Reflect.ownKeys(classType.prototype)) {
    const method = Reflect.get(classType.prototype, methodName);
    if (methodName === 'constructor' || typeof methodName !== 'string' || methodName.startsWith('_') || typeof method !== 'function')
      continue;
    apiCoverage.set(`${className}.${methodName}`, false);
    Reflect.set(classType.prototype, methodName, function(...args) {
      apiCoverage.set(`${className}.${methodName}`, true);
      return method.call(this, ...args);
    });
  }

  if (events[classType.name]) {
    for (const event of Object.values(events[classType.name])) {
      if (typeof event !== 'symbol')
        apiCoverage.set(`${className}.emit(${JSON.stringify(event)})`, false);
    }
    const method = Reflect.get(classType.prototype, 'emit');
    Reflect.set(classType.prototype, 'emit', function(event, ...args) {
      if (typeof event !== 'symbol' && this.listenerCount(event))
        apiCoverage.set(`${className}.emit(${JSON.stringify(event)})`, true);
      return method.call(this, event, ...args);
    });
  }
}

const utils = module.exports = {
  recordAPICoverage: function(testRunner, api, events, disabled) {
    const coverage = new Map();
    for (const [className, classType] of Object.entries(api))
      traceAPICoverage(coverage, events, className, classType);
    testRunner.describe(COVERAGE_TESTSUITE_NAME, () => {
      testRunner.it('should call all API methods', () => {
        const missingMethods = [];
        for (const method of coverage.keys()) {
          if (!coverage.get(method) && !disabled.has(method))
            missingMethods.push(method);
        }
        if (missingMethods.length)
          throw new Error('Certain API Methods are not called: ' + missingMethods.join(', '));
      });
    });
  },

  /**
   * @return {string}
   */
  projectRoot: function() {
    return PROJECT_ROOT;
  },

  /**
   * @param {!Page} page
   * @param {string} frameId
   * @param {string} url
   * @return {!Puppeteer.Frame}
   */
  attachFrame: async function(page, frameId, url) {
    const handle = await page.evaluateHandle(attachFrame, frameId, url);
    return await handle.asElement().contentFrame();

    async function attachFrame(frameId, url) {
      const frame = document.createElement('iframe');
      frame.src = url;
      frame.id = frameId;
      document.body.appendChild(frame);
      await new Promise(x => frame.onload = x);
      return frame;
    }
  },

  isFavicon: function(request) {
    return request.url().includes('favicon.ico');
  },

  /**
   * @param {!Page} page
   * @param {string} frameId
   */
  detachFrame: async function(page, frameId) {
    await page.evaluate(detachFrame, frameId);

    function detachFrame(frameId) {
      const frame = document.getElementById(frameId);
      frame.remove();
    }
  },

  /**
   * @param {!Page} page
   * @param {string} frameId
   * @param {string} url
   */
  navigateFrame: async function(page, frameId, url) {
    await page.evaluate(navigateFrame, frameId, url);

    function navigateFrame(frameId, url) {
      const frame = document.getElementById(frameId);
      frame.src = url;
      return new Promise(x => frame.onload = x);
    }
  },

  /**
   * @param {!Frame} frame
   * @param {string=} indentation
   * @return {Array<string>}
   */
  dumpFrames: function(frame, indentation) {
    indentation = indentation || '';
    let description = frame.url().replace(/:\d{4}\//, ':<PORT>/');
    if (frame.name())
      description += ' (' + frame.name() + ')';
    const result = [indentation + description];
    for (const child of frame.childFrames())
      result.push(...utils.dumpFrames(child, '    ' + indentation));
    return result;
  },

  /**
   * @param {!EventEmitter} emitter
   * @param {string} eventName
   * @return {!Promise<!Object>}
   */
  waitEvent: function(emitter, eventName, predicate = () => true) {
    return new Promise(fulfill => {
      emitter.on(eventName, function listener(event) {
        if (!predicate(event))
          return;
        emitter.removeListener(eventName, listener);
        fulfill(event);
      });
    });
  },

  initializeFlakinessDashboardIfNeeded: async function(testRunner) {
    // Generate testIDs for all tests and verify they don't clash.
    // This will add |test.testId| for every test.
    //
    // NOTE: we do this on CI's so that problems arise on PR trybots.
    if (process.env.CI)
      generateTestIDs(testRunner);
    // FLAKINESS_DASHBOARD_PASSWORD is an encrypted/secured variable.
    // Encrypted variables get a special treatment in CI's when handling PRs so that
    // secrets are not leaked to untrusted code.
    // - AppVeyor DOES NOT decrypt secured variables for PRs
    // - Travis DOES NOT decrypt encrypted variables for PRs
    // - Cirrus CI DOES NOT decrypt encrypted variables for PRs *unless* PR is sent
    //   from someone who has WRITE ACCESS to the repo.
    //
    // Since we don't want to run flakiness dashboard for PRs on all CIs, we
    // check existance of FLAKINESS_DASHBOARD_PASSWORD and absense of
    // CIRRUS_BASE_SHA env variables.
    if (!process.env.FLAKINESS_DASHBOARD_PASSWORD || process.env.CIRRUS_BASE_SHA)
      return;
    const {sha, timestamp} = await FlakinessDashboard.getCommitDetails(__dirname, 'HEAD');
    const dashboard = new FlakinessDashboard({
      commit: {
        sha,
        timestamp,
        url: `https://github.com/puppeteer/puppeteer/commit/${sha}`,
      },
      build: {
        url: process.env.FLAKINESS_DASHBOARD_BUILD_URL,
      },
      dashboardRepo: {
        url: 'https://github.com/aslushnikov/puppeteer-flakiness-dashboard.git',
        username: 'puppeteer-flakiness',
        email: 'aslushnikov+puppeteerflakiness@gmail.com',
        password: process.env.FLAKINESS_DASHBOARD_PASSWORD,
        branch: process.env.FLAKINESS_DASHBOARD_NAME,
      },
    });

    testRunner.on('testfinished', test => {
      // Do not report tests from COVERAGE testsuite.
      // They don't bring much value to us.
      if (test.fullName.includes(COVERAGE_TESTSUITE_NAME))
        return;
      const testpath = test.location.filePath.substring(utils.projectRoot().length);
      const url = `https://github.com/puppeteer/puppeteer/blob/${sha}/${testpath}#L${test.location.lineNumber}`;
      dashboard.reportTestResult({
        testId: test.testId,
        name: test.location.fileName + ':' + test.location.lineNumber,
        description: test.fullName,
        url,
        result: test.result,
      });
    });
    testRunner.on('finished', async({result}) => {
      dashboard.setBuildResult(result);
      await dashboard.uploadAndCleanup();
    });

    function generateTestIDs(testRunner) {
      const testIds = new Map();
      for (const test of testRunner.tests()) {
        const testIdComponents = [test.name];
        for (let suite = test.suite; !!suite.parentSuite; suite = suite.parentSuite)
          testIdComponents.push(suite.name);
        testIdComponents.reverse();
        const testId = testIdComponents.join('>');
        const clashingTest = testIds.get(testId);
        if (clashingTest)
          throw new Error(`Two tests with clashing IDs: ${test.location.fileName}:${test.location.lineNumber} and ${clashingTest.location.fileName}:${clashingTest.location.lineNumber}`);
        testIds.set(testId, test);
        test.testId = testId;
      }
    }
  },
};
