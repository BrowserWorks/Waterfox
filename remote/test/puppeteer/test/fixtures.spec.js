/**
 * Copyright 2019 Google Inc. All rights reserved.
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

module.exports.addTests = function({testRunner, expect, defaultBrowserOptions, puppeteer, puppeteerPath, JUGGLER}) {
  const {describe, xdescribe, fdescribe, describe_fails_ffox} = testRunner;
  const {it, fit, xit, it_fails_ffox} = testRunner;
  const {beforeAll, beforeEach, afterAll, afterEach} = testRunner;

  describe('Fixtures', function() {
    it_fails_ffox('dumpio option should work with pipe option ', async({server}) => {
      let dumpioData = '';
      const {spawn} = require('child_process');
      const options = Object.assign({}, defaultBrowserOptions, {pipe: true, dumpio: true});
      const res = spawn('node',
          [path.join(__dirname, 'fixtures', 'dumpio.js'), puppeteerPath, JSON.stringify(options)]);
      res.stderr.on('data', data => dumpioData += data.toString('utf8'));
      await new Promise(resolve => res.on('close', resolve));
      expect(dumpioData).toContain('message from dumpio');
    });
    it_fails_ffox('should dump browser process stderr', async({server}) => {
      let dumpioData = '';
      const {spawn} = require('child_process');
      const options = Object.assign({}, defaultBrowserOptions, {dumpio: true});
      const res = spawn('node',
          [path.join(__dirname, 'fixtures', 'dumpio.js'), puppeteerPath, JSON.stringify(options)]);
      if (JUGGLER)
        res.stdout.on('data', data => dumpioData += data.toString('utf8'));
      else
        res.stderr.on('data', data => dumpioData += data.toString('utf8'));
      await new Promise(resolve => res.on('close', resolve));

      if (JUGGLER)
        expect(dumpioData).toContain('Juggler listening on ws://');
      else
        expect(dumpioData).toContain('DevTools listening on ws://');
    });
    it_fails_ffox('should close the browser when the node process closes', async({ server }) => {
      const {spawn, execSync} = require('child_process');
      const options = Object.assign({}, defaultBrowserOptions, {
        // Disable DUMPIO to cleanly read stdout.
        dumpio: false,
      });
      const res = spawn('node', [path.join(__dirname, 'fixtures', 'closeme.js'), puppeteerPath, JSON.stringify(options)]);
      let wsEndPointCallback;
      const wsEndPointPromise = new Promise(x => wsEndPointCallback = x);
      let output = '';
      res.stdout.on('data', data => {
        output += data;
        if (output.indexOf('\n'))
          wsEndPointCallback(output.substring(0, output.indexOf('\n')));
      });
      const browser = await puppeteer.connect({ browserWSEndpoint: await wsEndPointPromise });
      const promises = [
        new Promise(resolve => browser.once('disconnected', resolve)),
        new Promise(resolve => res.on('close', resolve))
      ];
      if (process.platform === 'win32')
        execSync(`taskkill /pid ${res.pid} /T /F`);
      else
        process.kill(res.pid);
      await Promise.all(promises);
    });
  });
};
