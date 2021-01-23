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
const utils = require('./utils');
const {waitEvent} = utils;

module.exports.addTests = function({testRunner, expect, headless, puppeteer, CHROME}) {
  const {describe, xdescribe, fdescribe, describe_fails_ffox} = testRunner;
  const {it, fit, xit, it_fails_ffox} = testRunner;
  const {beforeAll, beforeEach, afterAll, afterEach} = testRunner;

  describe('Page.close', function() {
    it('should reject all promises when page is closed', async({context}) => {
      const newPage = await context.newPage();
      let error = null;
      await Promise.all([
        newPage.evaluate(() => new Promise(r => {})).catch(e => error = e),
        newPage.close(),
      ]);
      expect(error.message).toContain('Protocol error');
    });
    it('should not be visible in browser.pages', async({browser}) => {
      const newPage = await browser.newPage();
      expect(await browser.pages()).toContain(newPage);
      await newPage.close();
      expect(await browser.pages()).not.toContain(newPage);
    });
    it_fails_ffox('should run beforeunload if asked for', async({context, server}) => {
      const newPage = await context.newPage();
      await newPage.goto(server.PREFIX + '/beforeunload.html');
      // We have to interact with a page so that 'beforeunload' handlers
      // fire.
      await newPage.click('body');
      const pageClosingPromise = newPage.close({ runBeforeUnload: true });
      const dialog = await waitEvent(newPage, 'dialog');
      expect(dialog.type()).toBe('beforeunload');
      expect(dialog.defaultValue()).toBe('');
      if (CHROME)
        expect(dialog.message()).toBe('');
      else
        expect(dialog.message()).toBe('This page is asking you to confirm that you want to leave - data you have entered may not be saved.');
      await dialog.accept();
      await pageClosingPromise;
    });
    it('should *not* run beforeunload by default', async({context, server}) => {
      const newPage = await context.newPage();
      await newPage.goto(server.PREFIX + '/beforeunload.html');
      // We have to interact with a page so that 'beforeunload' handlers
      // fire.
      await newPage.click('body');
      await newPage.close();
    });
    it('should set the page close state', async({context}) => {
      const newPage = await context.newPage();
      expect(newPage.isClosed()).toBe(false);
      await newPage.close();
      expect(newPage.isClosed()).toBe(true);
    });
    it_fails_ffox('should terminate network waiters', async({context, server}) => {
      const newPage = await context.newPage();
      const results = await Promise.all([
        newPage.waitForRequest(server.EMPTY_PAGE).catch(e => e),
        newPage.waitForResponse(server.EMPTY_PAGE).catch(e => e),
        newPage.close()
      ]);
      for (let i = 0; i < 2; i++) {
        const message = results[i].message;
        expect(message).toContain('Target closed');
        expect(message).not.toContain('Timeout');
      }
    });
  });

  describe('Page.Events.Load', function() {
    it('should fire when expected', async({page, server}) => {
      await Promise.all([
        page.goto('about:blank'),
        utils.waitEvent(page, 'load'),
      ]);
    });
  });

  describe('Async stacks', () => {
    it_fails_ffox('should work', async({page, server}) => {
      server.setRoute('/empty.html', (req, res) => {
        res.statusCode = 204;
        res.end();
      });
      let error = null;
      await page.goto(server.EMPTY_PAGE).catch(e => error = e);
      expect(error).not.toBe(null);
      expect(error.stack).toContain(__filename);
    });
  });

  describe_fails_ffox('Page.Events.error', function() {
    it('should throw when page crashes', async({page}) => {
      let error = null;
      page.on('error', err => error = err);
      page.goto('chrome://crash').catch(e => {});
      await waitEvent(page, 'error');
      expect(error.message).toBe('Page crashed!');
    });
  });

  describe('Page.Events.Popup', function() {
    it('should work', async({page}) => {
      const [popup] = await Promise.all([
        new Promise(x => page.once('popup', x)),
        page.evaluate(() => window.open('about:blank')),
      ]);
      expect(await page.evaluate(() => !!window.opener)).toBe(false);
      expect(await popup.evaluate(() => !!window.opener)).toBe(true);
    });
    it('should work with noopener', async({page}) => {
      const [popup] = await Promise.all([
        new Promise(x => page.once('popup', x)),
        page.evaluate(() => window.open('about:blank', null, 'noopener')),
      ]);
      expect(await page.evaluate(() => !!window.opener)).toBe(false);
      expect(await popup.evaluate(() => !!window.opener)).toBe(false);
    });
    it('should work with clicking target=_blank', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.setContent('<a target=_blank href="/one-style.html">yo</a>');
      const [popup] = await Promise.all([
        new Promise(x => page.once('popup', x)),
        page.click('a'),
      ]);
      expect(await page.evaluate(() => !!window.opener)).toBe(false);
      expect(await popup.evaluate(() => !!window.opener)).toBe(true);
    });
    it('should work with fake-clicking target=_blank and rel=noopener', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.setContent('<a target=_blank rel=noopener href="/one-style.html">yo</a>');
      const [popup] = await Promise.all([
        new Promise(x => page.once('popup', x)),
        page.$eval('a', a => a.click()),
      ]);
      expect(await page.evaluate(() => !!window.opener)).toBe(false);
      expect(await popup.evaluate(() => !!window.opener)).toBe(false);
    });
    it('should work with clicking target=_blank and rel=noopener', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.setContent('<a target=_blank rel=noopener href="/one-style.html">yo</a>');
      const [popup] = await Promise.all([
        new Promise(x => page.once('popup', x)),
        page.click('a'),
      ]);
      expect(await page.evaluate(() => !!window.opener)).toBe(false);
      expect(await popup.evaluate(() => !!window.opener)).toBe(false);
    });
  });

  describe('BrowserContext.overridePermissions', function() {
    function getPermission(page, name) {
      return page.evaluate(name => navigator.permissions.query({name}).then(result => result.state), name);
    }

    it('should be prompt by default', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      expect(await getPermission(page, 'geolocation')).toBe('prompt');
    });
    it('should deny permission when not listed', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      await context.overridePermissions(server.EMPTY_PAGE, []);
      expect(await getPermission(page, 'geolocation')).toBe('denied');
    });
    it('should fail when bad permission is given', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      let error = null;
      await context.overridePermissions(server.EMPTY_PAGE, ['foo']).catch(e => error = e);
      expect(error.message).toBe('Unknown permission: foo');
    });
    it('should grant permission when listed', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      await context.overridePermissions(server.EMPTY_PAGE, ['geolocation']);
      expect(await getPermission(page, 'geolocation')).toBe('granted');
    });
    it('should reset permissions', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      await context.overridePermissions(server.EMPTY_PAGE, ['geolocation']);
      expect(await getPermission(page, 'geolocation')).toBe('granted');
      await context.clearPermissionOverrides();
      expect(await getPermission(page, 'geolocation')).toBe('prompt');
    });
    it('should trigger permission onchange', async({page, server, context}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.evaluate(() => {
        window.events = [];
        return navigator.permissions.query({name: 'geolocation'}).then(function(result) {
          window.events.push(result.state);
          result.onchange = function() {
            window.events.push(result.state);
          };
        });
      });
      expect(await page.evaluate(() => window.events)).toEqual(['prompt']);
      await context.overridePermissions(server.EMPTY_PAGE, []);
      expect(await page.evaluate(() => window.events)).toEqual(['prompt', 'denied']);
      await context.overridePermissions(server.EMPTY_PAGE, ['geolocation']);
      expect(await page.evaluate(() => window.events)).toEqual(['prompt', 'denied', 'granted']);
      await context.clearPermissionOverrides();
      expect(await page.evaluate(() => window.events)).toEqual(['prompt', 'denied', 'granted', 'prompt']);
    });
    it('should isolate permissions between browser contexs', async({page, server, context, browser}) => {
      await page.goto(server.EMPTY_PAGE);
      const otherContext = await browser.createIncognitoBrowserContext();
      const otherPage = await otherContext.newPage();
      await otherPage.goto(server.EMPTY_PAGE);
      expect(await getPermission(page, 'geolocation')).toBe('prompt');
      expect(await getPermission(otherPage, 'geolocation')).toBe('prompt');

      await context.overridePermissions(server.EMPTY_PAGE, []);
      await otherContext.overridePermissions(server.EMPTY_PAGE, ['geolocation']);
      expect(await getPermission(page, 'geolocation')).toBe('denied');
      expect(await getPermission(otherPage, 'geolocation')).toBe('granted');

      await context.clearPermissionOverrides();
      expect(await getPermission(page, 'geolocation')).toBe('prompt');
      expect(await getPermission(otherPage, 'geolocation')).toBe('granted');

      await otherContext.close();
    });
  });

  describe_fails_ffox('Page.setGeolocation', function() {
    it('should work', async({page, server, context}) => {
      await context.overridePermissions(server.PREFIX, ['geolocation']);
      await page.goto(server.EMPTY_PAGE);
      await page.setGeolocation({longitude: 10, latitude: 10});
      const geolocation = await page.evaluate(() => new Promise(resolve => navigator.geolocation.getCurrentPosition(position => {
        resolve({latitude: position.coords.latitude, longitude: position.coords.longitude});
      })));
      expect(geolocation).toEqual({
        latitude: 10,
        longitude: 10
      });
    });
    it('should throw when invalid longitude', async({page, server, context}) => {
      let error = null;
      try {
        await page.setGeolocation({longitude: 200, latitude: 10});
      } catch (e) {
        error = e;
      }
      expect(error.message).toContain('Invalid longitude "200"');
    });
  });

  describe_fails_ffox('Page.setOfflineMode', function() {
    it('should work', async({page, server}) => {
      await page.setOfflineMode(true);
      let error = null;
      await page.goto(server.EMPTY_PAGE).catch(e => error = e);
      expect(error).toBeTruthy();
      await page.setOfflineMode(false);
      const response = await page.reload();
      expect(response.status()).toBe(200);
    });
    it('should emulate navigator.onLine', async({page, server}) => {
      expect(await page.evaluate(() => window.navigator.onLine)).toBe(true);
      await page.setOfflineMode(true);
      expect(await page.evaluate(() => window.navigator.onLine)).toBe(false);
      await page.setOfflineMode(false);
      expect(await page.evaluate(() => window.navigator.onLine)).toBe(true);
    });
  });

  describe_fails_ffox('ExecutionContext.queryObjects', function() {
    it('should work', async({page, server}) => {
      // Instantiate an object
      await page.evaluate(() => window.set = new Set(['hello', 'world']));
      const prototypeHandle = await page.evaluateHandle(() => Set.prototype);
      const objectsHandle = await page.queryObjects(prototypeHandle);
      const count = await page.evaluate(objects => objects.length, objectsHandle);
      expect(count).toBe(1);
      const values = await page.evaluate(objects => Array.from(objects[0].values()), objectsHandle);
      expect(values).toEqual(['hello', 'world']);
    });
    it('should work for non-blank page', async({page, server}) => {
      // Instantiate an object
      await page.goto(server.EMPTY_PAGE);
      await page.evaluate(() => window.set = new Set(['hello', 'world']));
      const prototypeHandle = await page.evaluateHandle(() => Set.prototype);
      const objectsHandle = await page.queryObjects(prototypeHandle);
      const count = await page.evaluate(objects => objects.length, objectsHandle);
      expect(count).toBe(1);
    });
    it('should fail for disposed handles', async({page, server}) => {
      const prototypeHandle = await page.evaluateHandle(() => HTMLBodyElement.prototype);
      await prototypeHandle.dispose();
      let error = null;
      await page.queryObjects(prototypeHandle).catch(e => error = e);
      expect(error.message).toBe('Prototype JSHandle is disposed!');
    });
    it('should fail primitive values as prototypes', async({page, server}) => {
      const prototypeHandle = await page.evaluateHandle(() => 42);
      let error = null;
      await page.queryObjects(prototypeHandle).catch(e => error = e);
      expect(error.message).toBe('Prototype JSHandle must not be referencing primitive value');
    });
  });

  describe('Page.Events.Console', function() {
    it('should work', async({page, server}) => {
      let message = null;
      page.once('console', m => message = m);
      await Promise.all([
        page.evaluate(() => console.log('hello', 5, {foo: 'bar'})),
        waitEvent(page, 'console')
      ]);
      expect(message.text()).toEqual('hello 5 JSHandle@object');
      expect(message.type()).toEqual('log');
      expect(await message.args()[0].jsonValue()).toEqual('hello');
      expect(await message.args()[1].jsonValue()).toEqual(5);
      expect(await message.args()[2].jsonValue()).toEqual({foo: 'bar'});
    });
    it('should work for different console API calls', async({page, server}) => {
      const messages = [];
      page.on('console', msg => messages.push(msg));
      // All console events will be reported before `page.evaluate` is finished.
      await page.evaluate(() => {
        // A pair of time/timeEnd generates only one Console API call.
        console.time('calling console.time');
        console.timeEnd('calling console.time');
        console.trace('calling console.trace');
        console.dir('calling console.dir');
        console.warn('calling console.warn');
        console.error('calling console.error');
        console.log(Promise.resolve('should not wait until resolved!'));
      });
      expect(messages.map(msg => msg.type())).toEqual([
        'timeEnd', 'trace', 'dir', 'warning', 'error', 'log'
      ]);
      expect(messages[0].text()).toContain('calling console.time');
      expect(messages.slice(1).map(msg => msg.text())).toEqual([
        'calling console.trace',
        'calling console.dir',
        'calling console.warn',
        'calling console.error',
        'JSHandle@promise',
      ]);
    });
    it('should not fail for window object', async({page, server}) => {
      let message = null;
      page.once('console', msg => message = msg);
      await Promise.all([
        page.evaluate(() => console.error(window)),
        waitEvent(page, 'console')
      ]);
      expect(message.text()).toBe('JSHandle@object');
    });
    it('should trigger correct Log', async({page, server}) => {
      await page.goto('about:blank');
      const [message] = await Promise.all([
        waitEvent(page, 'console'),
        page.evaluate(async url => fetch(url).catch(e => {}), server.EMPTY_PAGE)
      ]);
      expect(message.text()).toContain('Access-Control-Allow-Origin');
      if (CHROME)
        expect(message.type()).toEqual('error');
      else
        expect(message.type()).toEqual('warn');
    });
    it('should have location when fetch fails', async({page, server}) => {
      // The point of this test is to make sure that we report console messages from
      // Log domain: https://vanilla.aslushnikov.com/?Log.entryAdded
      await page.goto(server.EMPTY_PAGE);
      const [message] = await Promise.all([
        waitEvent(page, 'console'),
        page.setContent(`<script>fetch('http://wat');</script>`),
      ]);
      expect(message.text()).toContain(`ERR_NAME_NOT_RESOLVED`);
      expect(message.type()).toEqual('error');
      expect(message.location()).toEqual({
        url: 'http://wat/',
        lineNumber: undefined
      });
    });
    it('should have location for console API calls', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [message] = await Promise.all([
        waitEvent(page, 'console'),
        page.goto(server.PREFIX + '/consolelog.html'),
      ]);
      expect(message.text()).toBe('yellow');
      expect(message.type()).toBe('log');
      expect(message.location()).toEqual({
        url: server.PREFIX + '/consolelog.html',
        lineNumber: 7,
        columnNumber: CHROME ? 14 : 6, // console.|log vs |console.log
      });
    });
    // @see https://github.com/puppeteer/puppeteer/issues/3865
    it('should not throw when there are console messages in detached iframes', async({browser, page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.evaluate(async() => {
        // 1. Create a popup that Puppeteer is not connected to.
        const win = window.open(window.location.href, 'Title', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=780,height=200,top=0,left=0');
        await new Promise(x => win.onload = x);
        // 2. In this popup, create an iframe that console.logs a message.
        win.document.body.innerHTML = `<iframe src='/consolelog.html'></iframe>`;
        const frame = win.document.querySelector('iframe');
        await new Promise(x => frame.onload = x);
        // 3. After that, remove the iframe.
        frame.remove();
      });
      const popupTarget = page.browserContext().targets().find(target => target !== page.target());
      // 4. Connect to the popup and make sure it doesn't throw.
      await popupTarget.page();
    });
  });

  describe('Page.Events.DOMContentLoaded', function() {
    it('should fire when expected', async({page, server}) => {
      page.goto('about:blank');
      await waitEvent(page, 'domcontentloaded');
    });
  });

  describe_fails_ffox('Page.metrics', function() {
    it('should get metrics from a page', async({page, server}) => {
      await page.goto('about:blank');
      const metrics = await page.metrics();
      checkMetrics(metrics);
    });
    it('metrics event fired on console.timeStamp', async({page, server}) => {
      const metricsPromise = new Promise(fulfill => page.once('metrics', fulfill));
      await page.evaluate(() => console.timeStamp('test42'));
      const metrics = await metricsPromise;
      expect(metrics.title).toBe('test42');
      checkMetrics(metrics.metrics);
    });
    function checkMetrics(metrics) {
      const metricsToCheck = new Set([
        'Timestamp',
        'Documents',
        'Frames',
        'JSEventListeners',
        'Nodes',
        'LayoutCount',
        'RecalcStyleCount',
        'LayoutDuration',
        'RecalcStyleDuration',
        'ScriptDuration',
        'TaskDuration',
        'JSHeapUsedSize',
        'JSHeapTotalSize',
      ]);
      for (const name in metrics) {
        expect(metricsToCheck.has(name)).toBeTruthy();
        expect(metrics[name]).toBeGreaterThanOrEqual(0);
        metricsToCheck.delete(name);
      }
      expect(metricsToCheck.size).toBe(0);
    }
  });

  describe('Page.waitForRequest', function() {
    it('should work', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [request] = await Promise.all([
        page.waitForRequest(server.PREFIX + '/digits/2.png'),
        page.evaluate(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        })
      ]);
      expect(request.url()).toBe(server.PREFIX + '/digits/2.png');
    });
    it('should work with predicate', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [request] = await Promise.all([
        page.waitForRequest(request => request.url() === server.PREFIX + '/digits/2.png'),
        page.evaluate(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        })
      ]);
      expect(request.url()).toBe(server.PREFIX + '/digits/2.png');
    });
    it('should respect timeout', async({page, server}) => {
      let error = null;
      await page.waitForRequest(() => false, {timeout: 1}).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should respect default timeout', async({page, server}) => {
      let error = null;
      page.setDefaultTimeout(1);
      await page.waitForRequest(() => false).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should work with no timeout', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [request] = await Promise.all([
        page.waitForRequest(server.PREFIX + '/digits/2.png', {timeout: 0}),
        page.evaluate(() => setTimeout(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        }, 50))
      ]);
      expect(request.url()).toBe(server.PREFIX + '/digits/2.png');
    });
  });

  describe('Page.waitForResponse', function() {
    it('should work', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [response] = await Promise.all([
        page.waitForResponse(server.PREFIX + '/digits/2.png'),
        page.evaluate(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        })
      ]);
      expect(response.url()).toBe(server.PREFIX + '/digits/2.png');
    });
    it('should respect timeout', async({page, server}) => {
      let error = null;
      await page.waitForResponse(() => false, {timeout: 1}).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should respect default timeout', async({page, server}) => {
      let error = null;
      page.setDefaultTimeout(1);
      await page.waitForResponse(() => false).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should work with predicate', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [response] = await Promise.all([
        page.waitForResponse(response => response.url() === server.PREFIX + '/digits/2.png'),
        page.evaluate(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        })
      ]);
      expect(response.url()).toBe(server.PREFIX + '/digits/2.png');
    });
    it('should work with no timeout', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const [response] = await Promise.all([
        page.waitForResponse(server.PREFIX + '/digits/2.png', {timeout: 0}),
        page.evaluate(() => setTimeout(() => {
          fetch('/digits/1.png');
          fetch('/digits/2.png');
          fetch('/digits/3.png');
        }, 50))
      ]);
      expect(response.url()).toBe(server.PREFIX + '/digits/2.png');
    });
  });

  describe('Page.exposeFunction', function() {
    it('should work', async({page, server}) => {
      await page.exposeFunction('compute', function(a, b) {
        return a * b;
      });
      const result = await page.evaluate(async function() {
        return await compute(9, 4);
      });
      expect(result).toBe(36);
    });
    it('should throw exception in page context', async({page, server}) => {
      await page.exposeFunction('woof', function() {
        throw new Error('WOOF WOOF');
      });
      const {message, stack} = await page.evaluate(async() => {
        try {
          await woof();
        } catch (e) {
          return {message: e.message, stack: e.stack};
        }
      });
      expect(message).toBe('WOOF WOOF');
      expect(stack).toContain(__filename);
    });
    it('should support throwing "null"', async({page, server}) => {
      await page.exposeFunction('woof', function() {
        throw null;
      });
      const thrown = await page.evaluate(async() => {
        try {
          await woof();
        } catch (e) {
          return e;
        }
      });
      expect(thrown).toBe(null);
    });
    it('should be callable from-inside evaluateOnNewDocument', async({page, server}) => {
      let called = false;
      await page.exposeFunction('woof', function() {
        called = true;
      });
      await page.evaluateOnNewDocument(() => woof());
      await page.reload();
      expect(called).toBe(true);
    });
    it('should survive navigation', async({page, server}) => {
      await page.exposeFunction('compute', function(a, b) {
        return a * b;
      });

      await page.goto(server.EMPTY_PAGE);
      const result = await page.evaluate(async function() {
        return await compute(9, 4);
      });
      expect(result).toBe(36);
    });
    it('should await returned promise', async({page, server}) => {
      await page.exposeFunction('compute', function(a, b) {
        return Promise.resolve(a * b);
      });

      const result = await page.evaluate(async function() {
        return await compute(3, 5);
      });
      expect(result).toBe(15);
    });
    it('should work on frames', async({page, server}) => {
      await page.exposeFunction('compute', function(a, b) {
        return Promise.resolve(a * b);
      });

      await page.goto(server.PREFIX + '/frames/nested-frames.html');
      const frame = page.frames()[1];
      const result = await frame.evaluate(async function() {
        return await compute(3, 5);
      });
      expect(result).toBe(15);
    });
    it('should work on frames before navigation', async({page, server}) => {
      await page.goto(server.PREFIX + '/frames/nested-frames.html');
      await page.exposeFunction('compute', function(a, b) {
        return Promise.resolve(a * b);
      });

      const frame = page.frames()[1];
      const result = await frame.evaluate(async function() {
        return await compute(3, 5);
      });
      expect(result).toBe(15);
    });
    it('should work with complex objects', async({page, server}) => {
      await page.exposeFunction('complexObject', function(a, b) {
        return {x: a.x + b.x};
      });
      const result = await page.evaluate(async() => complexObject({x: 5}, {x: 2}));
      expect(result.x).toBe(7);
    });
  });

  describe('Page.Events.PageError', function() {
    it('should fire', async({page, server}) => {
      let error = null;
      page.once('pageerror', e => error = e);
      await Promise.all([
        page.goto(server.PREFIX + '/error.html'),
        waitEvent(page, 'pageerror')
      ]);
      expect(error.message).toContain('Fancy');
    });
  });

  describe('Page.setUserAgent', function() {
    it('should work', async({page, server}) => {
      expect(await page.evaluate(() => navigator.userAgent)).toContain('Mozilla');
      await page.setUserAgent('foobar');
      const [request] = await Promise.all([
        server.waitForRequest('/empty.html'),
        page.goto(server.EMPTY_PAGE),
      ]);
      expect(request.headers['user-agent']).toBe('foobar');
    });
    it('should work for subframes', async({page, server}) => {
      expect(await page.evaluate(() => navigator.userAgent)).toContain('Mozilla');
      await page.setUserAgent('foobar');
      const [request] = await Promise.all([
        server.waitForRequest('/empty.html'),
        utils.attachFrame(page, 'frame1', server.EMPTY_PAGE),
      ]);
      expect(request.headers['user-agent']).toBe('foobar');
    });
    it('should emulate device user-agent', async({page, server}) => {
      await page.goto(server.PREFIX + '/mobile.html');
      expect(await page.evaluate(() => navigator.userAgent)).not.toContain('iPhone');
      await page.setUserAgent(puppeteer.devices['iPhone 6'].userAgent);
      expect(await page.evaluate(() => navigator.userAgent)).toContain('iPhone');
    });
  });

  describe('Page.setContent', function() {
    const expectedOutput = '<html><head></head><body><div>hello</div></body></html>';
    it('should work', async({page, server}) => {
      await page.setContent('<div>hello</div>');
      const result = await page.content();
      expect(result).toBe(expectedOutput);
    });
    it('should work with doctype', async({page, server}) => {
      const doctype = '<!DOCTYPE html>';
      await page.setContent(`${doctype}<div>hello</div>`);
      const result = await page.content();
      expect(result).toBe(`${doctype}${expectedOutput}`);
    });
    it('should work with HTML 4 doctype', async({page, server}) => {
      const doctype = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" ' +
        '"http://www.w3.org/TR/html4/strict.dtd">';
      await page.setContent(`${doctype}<div>hello</div>`);
      const result = await page.content();
      expect(result).toBe(`${doctype}${expectedOutput}`);
    });
    it('should respect timeout', async({page, server}) => {
      const imgPath = '/img.png';
      // stall for image
      server.setRoute(imgPath, (req, res) => {});
      let error = null;
      await page.setContent(`<img src="${server.PREFIX + imgPath}"></img>`, {timeout: 1}).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should respect default navigation timeout', async({page, server}) => {
      page.setDefaultNavigationTimeout(1);
      const imgPath = '/img.png';
      // stall for image
      server.setRoute(imgPath, (req, res) => {});
      let error = null;
      await page.setContent(`<img src="${server.PREFIX + imgPath}"></img>`).catch(e => error = e);
      expect(error).toBeInstanceOf(puppeteer.errors.TimeoutError);
    });
    it('should await resources to load', async({page, server}) => {
      const imgPath = '/img.png';
      let imgResponse = null;
      server.setRoute(imgPath, (req, res) => imgResponse = res);
      let loaded = false;
      const contentPromise = page.setContent(`<img src="${server.PREFIX + imgPath}"></img>`).then(() => loaded = true);
      await server.waitForRequest(imgPath);
      expect(loaded).toBe(false);
      imgResponse.end();
      await contentPromise;
    });
    it('should work fast enough', async({page, server}) => {
      for (let i = 0; i < 20; ++i)
        await page.setContent('<div>yo</div>');
    });
    it('should work with tricky content', async({page, server}) => {
      await page.setContent('<div>hello world</div>' + '\x7F');
      expect(await page.$eval('div', div => div.textContent)).toBe('hello world');
    });
    it('should work with accents', async({page, server}) => {
      await page.setContent('<div>aberración</div>');
      expect(await page.$eval('div', div => div.textContent)).toBe('aberración');
    });
    it('should work with emojis', async({page, server}) => {
      await page.setContent('<div>🐥</div>');
      expect(await page.$eval('div', div => div.textContent)).toBe('🐥');
    });
    it('should work with newline', async({page, server}) => {
      await page.setContent('<div>\n</div>');
      expect(await page.$eval('div', div => div.textContent)).toBe('\n');
    });
  });

  describe_fails_ffox('Page.setBypassCSP', function() {
    it('should bypass CSP meta tag', async({page, server}) => {
      // Make sure CSP prohibits addScriptTag.
      await page.goto(server.PREFIX + '/csp.html');
      await page.addScriptTag({content: 'window.__injected = 42;'}).catch(e => void e);
      expect(await page.evaluate(() => window.__injected)).toBe(undefined);

      // By-pass CSP and try one more time.
      await page.setBypassCSP(true);
      await page.reload();
      await page.addScriptTag({content: 'window.__injected = 42;'});
      expect(await page.evaluate(() => window.__injected)).toBe(42);
    });

    it('should bypass CSP header', async({page, server}) => {
      // Make sure CSP prohibits addScriptTag.
      server.setCSP('/empty.html', 'default-src "self"');
      await page.goto(server.EMPTY_PAGE);
      await page.addScriptTag({content: 'window.__injected = 42;'}).catch(e => void e);
      expect(await page.evaluate(() => window.__injected)).toBe(undefined);

      // By-pass CSP and try one more time.
      await page.setBypassCSP(true);
      await page.reload();
      await page.addScriptTag({content: 'window.__injected = 42;'});
      expect(await page.evaluate(() => window.__injected)).toBe(42);
    });

    it('should bypass after cross-process navigation', async({page, server}) => {
      await page.setBypassCSP(true);
      await page.goto(server.PREFIX + '/csp.html');
      await page.addScriptTag({content: 'window.__injected = 42;'});
      expect(await page.evaluate(() => window.__injected)).toBe(42);

      await page.goto(server.CROSS_PROCESS_PREFIX + '/csp.html');
      await page.addScriptTag({content: 'window.__injected = 42;'});
      expect(await page.evaluate(() => window.__injected)).toBe(42);
    });
    it('should bypass CSP in iframes as well', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      {
        // Make sure CSP prohibits addScriptTag in an iframe.
        const frame = await utils.attachFrame(page, 'frame1', server.PREFIX + '/csp.html');
        await frame.addScriptTag({content: 'window.__injected = 42;'}).catch(e => void e);
        expect(await frame.evaluate(() => window.__injected)).toBe(undefined);
      }

      // By-pass CSP and try one more time.
      await page.setBypassCSP(true);
      await page.reload();

      {
        const frame = await utils.attachFrame(page, 'frame1', server.PREFIX + '/csp.html');
        await frame.addScriptTag({content: 'window.__injected = 42;'}).catch(e => void e);
        expect(await frame.evaluate(() => window.__injected)).toBe(42);
      }
    });
  });

  describe('Page.addScriptTag', function() {
    it('should throw an error if no options are provided', async({page, server}) => {
      let error = null;
      try {
        await page.addScriptTag('/injectedfile.js');
      } catch (e) {
        error = e;
      }
      expect(error.message).toBe('Provide an object with a `url`, `path` or `content` property');
    });

    it('should work with a url', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const scriptHandle = await page.addScriptTag({ url: '/injectedfile.js' });
      expect(scriptHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(() => __injected)).toBe(42);
    });

    it('should work with a url and type=module', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.addScriptTag({ url: '/es6/es6import.js', type: 'module' });
      expect(await page.evaluate(() => __es6injected)).toBe(42);
    });

    it('should work with a path and type=module', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.addScriptTag({ path: path.join(__dirname, 'assets/es6/es6pathimport.js'), type: 'module' });
      await page.waitForFunction('window.__es6injected');
      expect(await page.evaluate(() => __es6injected)).toBe(42);
    });

    it('should work with a content and type=module', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.addScriptTag({ content: `import num from '/es6/es6module.js';window.__es6injected = num;`, type: 'module' });
      await page.waitForFunction('window.__es6injected');
      expect(await page.evaluate(() => __es6injected)).toBe(42);
    });

    it('should throw an error if loading from url fail', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      let error = null;
      try {
        await page.addScriptTag({ url: '/nonexistfile.js' });
      } catch (e) {
        error = e;
      }
      expect(error.message).toBe('Loading script from /nonexistfile.js failed');
    });

    it('should work with a path', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const scriptHandle = await page.addScriptTag({ path: path.join(__dirname, 'assets/injectedfile.js') });
      expect(scriptHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(() => __injected)).toBe(42);
    });

    it('should include sourcemap when path is provided', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.addScriptTag({ path: path.join(__dirname, 'assets/injectedfile.js') });
      const result = await page.evaluate(() => __injectedError.stack);
      expect(result).toContain(path.join('assets', 'injectedfile.js'));
    });

    it('should work with content', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const scriptHandle = await page.addScriptTag({ content: 'window.__injected = 35;' });
      expect(scriptHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(() => __injected)).toBe(35);
    });

    // @see https://github.com/puppeteer/puppeteer/issues/4840
    xit('should throw when added with content to the CSP page', async({page, server}) => {
      await page.goto(server.PREFIX + '/csp.html');
      let error = null;
      await page.addScriptTag({ content: 'window.__injected = 35;' }).catch(e => error = e);
      expect(error).toBeTruthy();
    });

    it('should throw when added with URL to the CSP page', async({page, server}) => {
      await page.goto(server.PREFIX + '/csp.html');
      let error = null;
      await page.addScriptTag({ url: server.CROSS_PROCESS_PREFIX + '/injectedfile.js' }).catch(e => error = e);
      expect(error).toBeTruthy();
    });
  });

  describe('Page.addStyleTag', function() {
    it('should throw an error if no options are provided', async({page, server}) => {
      let error = null;
      try {
        await page.addStyleTag('/injectedstyle.css');
      } catch (e) {
        error = e;
      }
      expect(error.message).toBe('Provide an object with a `url`, `path` or `content` property');
    });

    it('should work with a url', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const styleHandle = await page.addStyleTag({ url: '/injectedstyle.css' });
      expect(styleHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(`window.getComputedStyle(document.querySelector('body')).getPropertyValue('background-color')`)).toBe('rgb(255, 0, 0)');
    });

    it('should throw an error if loading from url fail', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      let error = null;
      try {
        await page.addStyleTag({ url: '/nonexistfile.js' });
      } catch (e) {
        error = e;
      }
      expect(error.message).toBe('Loading style from /nonexistfile.js failed');
    });

    it('should work with a path', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const styleHandle = await page.addStyleTag({ path: path.join(__dirname, 'assets/injectedstyle.css') });
      expect(styleHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(`window.getComputedStyle(document.querySelector('body')).getPropertyValue('background-color')`)).toBe('rgb(255, 0, 0)');
    });

    it('should include sourcemap when path is provided', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      await page.addStyleTag({ path: path.join(__dirname, 'assets/injectedstyle.css') });
      const styleHandle = await page.$('style');
      const styleContent = await page.evaluate(style => style.innerHTML, styleHandle);
      expect(styleContent).toContain(path.join('assets', 'injectedstyle.css'));
    });

    it('should work with content', async({page, server}) => {
      await page.goto(server.EMPTY_PAGE);
      const styleHandle = await page.addStyleTag({ content: 'body { background-color: green; }' });
      expect(styleHandle.asElement()).not.toBeNull();
      expect(await page.evaluate(`window.getComputedStyle(document.querySelector('body')).getPropertyValue('background-color')`)).toBe('rgb(0, 128, 0)');
    });

    it_fails_ffox('should throw when added with content to the CSP page', async({page, server}) => {
      await page.goto(server.PREFIX + '/csp.html');
      let error = null;
      await page.addStyleTag({ content: 'body { background-color: green; }' }).catch(e => error = e);
      expect(error).toBeTruthy();
    });

    it('should throw when added with URL to the CSP page', async({page, server}) => {
      await page.goto(server.PREFIX + '/csp.html');
      let error = null;
      await page.addStyleTag({ url: server.CROSS_PROCESS_PREFIX + '/injectedstyle.css' }).catch(e => error = e);
      expect(error).toBeTruthy();
    });
  });

  describe('Page.url', function() {
    it('should work', async({page, server}) => {
      expect(page.url()).toBe('about:blank');
      await page.goto(server.EMPTY_PAGE);
      expect(page.url()).toBe(server.EMPTY_PAGE);
    });
  });

  describe('Page.setJavaScriptEnabled', function() {
    it('should work', async({page, server}) => {
      await page.setJavaScriptEnabled(false);
      await page.goto('data:text/html, <script>var something = "forbidden"</script>');
      let error = null;
      await page.evaluate('something').catch(e => error = e);
      expect(error.message).toContain('something is not defined');

      await page.setJavaScriptEnabled(true);
      await page.goto('data:text/html, <script>var something = "forbidden"</script>');
      expect(await page.evaluate('something')).toBe('forbidden');
    });
  });

  describe('Page.setCacheEnabled', function() {
    it('should enable or disable the cache based on the state passed', async({page, server}) => {
      await page.goto(server.PREFIX + '/cached/one-style.html');
      const [cachedRequest] = await Promise.all([
        server.waitForRequest('/cached/one-style.html'),
        page.reload(),
      ]);
      // Rely on "if-modified-since" caching in our test server.
      expect(cachedRequest.headers['if-modified-since']).not.toBe(undefined);

      await page.setCacheEnabled(false);
      const [nonCachedRequest] = await Promise.all([
        server.waitForRequest('/cached/one-style.html'),
        page.reload(),
      ]);
      expect(nonCachedRequest.headers['if-modified-since']).toBe(undefined);
    });
    it('should stay disabled when toggling request interception on/off', async({page, server}) => {
      await page.setCacheEnabled(false);
      await page.setRequestInterception(true);
      await page.setRequestInterception(false);

      await page.goto(server.PREFIX + '/cached/one-style.html');
      const [nonCachedRequest] = await Promise.all([
        server.waitForRequest('/cached/one-style.html'),
        page.reload(),
      ]);
      expect(nonCachedRequest.headers['if-modified-since']).toBe(undefined);
    });
  });

  // Printing to pdf is currently only supported in headless
  (headless ? describe_fails_ffox : xdescribe)('Page.pdf', function() {
    it('should be able to save file', async({page, server}) => {
      const outputFile = __dirname + '/assets/output.pdf';
      await page.pdf({path: outputFile});
      expect(fs.readFileSync(outputFile).byteLength).toBeGreaterThan(0);
      fs.unlinkSync(outputFile);
    });
  });

  describe('Page.title', function() {
    it('should return the page title', async({page, server}) => {
      await page.goto(server.PREFIX + '/title.html');
      expect(await page.title()).toBe('Woof-Woof');
    });
  });

  describe('Page.select', function() {
    it('should select single option', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.select('select', 'blue');
      expect(await page.evaluate(() => result.onInput)).toEqual(['blue']);
      expect(await page.evaluate(() => result.onChange)).toEqual(['blue']);
    });
    it('should select only first option', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.select('select', 'blue', 'green', 'red');
      expect(await page.evaluate(() => result.onInput)).toEqual(['blue']);
      expect(await page.evaluate(() => result.onChange)).toEqual(['blue']);
    });
    it('should not throw when select causes navigation', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.$eval('select', select => select.addEventListener('input', () => window.location = '/empty.html'));
      await Promise.all([
        page.select('select', 'blue'),
        page.waitForNavigation(),
      ]);
      expect(page.url()).toContain('empty.html');
    });
    it('should select multiple options', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.evaluate(() => makeMultiple());
      await page.select('select', 'blue', 'green', 'red');
      expect(await page.evaluate(() => result.onInput)).toEqual(['blue', 'green', 'red']);
      expect(await page.evaluate(() => result.onChange)).toEqual(['blue', 'green', 'red']);
    });
    it('should respect event bubbling', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.select('select', 'blue');
      expect(await page.evaluate(() => result.onBubblingInput)).toEqual(['blue']);
      expect(await page.evaluate(() => result.onBubblingChange)).toEqual(['blue']);
    });
    it('should throw when element is not a <select>', async({page, server}) => {
      let error = null;
      await page.goto(server.PREFIX + '/input/select.html');
      await page.select('body', '').catch(e => error = e);
      expect(error.message).toContain('Element is not a <select> element.');
    });
    it('should return [] on no matched values', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      const result = await page.select('select','42','abc');
      expect(result).toEqual([]);
    });
    it('should return an array of matched values', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.evaluate(() => makeMultiple());
      const result = await page.select('select','blue','black','magenta');
      expect(result.reduce((accumulator,current) => ['blue', 'black', 'magenta'].includes(current) && accumulator, true)).toEqual(true);
    });
    it('should return an array of one element when multiple is not set', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      const result = await page.select('select','42','blue','black','magenta');
      expect(result.length).toEqual(1);
    });
    it('should return [] on no values',async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      const result = await page.select('select');
      expect(result).toEqual([]);
    });
    it('should deselect all options when passed no values for a multiple select',async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.evaluate(() => makeMultiple());
      await page.select('select','blue','black','magenta');
      await page.select('select');
      expect(await page.$eval('select', select => Array.from(select.options).every(option => !option.selected))).toEqual(true);
    });
    it('should deselect all options when passed no values for a select without multiple',async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.select('select','blue','black','magenta');
      await page.select('select');
      expect(await page.$eval('select', select => Array.from(select.options).every(option => !option.selected))).toEqual(true);
    });
    it('should throw if passed in non-strings', async({page, server}) => {
      await page.setContent('<select><option value="12"/></select>');
      let error = null;
      try {
        await page.select('select', 12);
      } catch (e) {
        error = e;
      }
      expect(error.message).toContain('Values must be strings');
    });
    // @see https://github.com/puppeteer/puppeteer/issues/3327
    it('should work when re-defining top-level Event class', async({page, server}) => {
      await page.goto(server.PREFIX + '/input/select.html');
      await page.evaluate(() => window.Event = null);
      await page.select('select', 'blue');
      expect(await page.evaluate(() => result.onInput)).toEqual(['blue']);
      expect(await page.evaluate(() => result.onChange)).toEqual(['blue']);
    });
  });

  describe('Page.Events.Close', function() {
    it_fails_ffox('should work with window.close', async function({ page, context, server }) {
      const newPagePromise = new Promise(fulfill => context.once('targetcreated', target => fulfill(target.page())));
      await page.evaluate(() => window['newPage'] = window.open('about:blank'));
      const newPage = await newPagePromise;
      const closedPromise = new Promise(x => newPage.on('close', x));
      await page.evaluate(() => window['newPage'].close());
      await closedPromise;
    });
    it('should work with page.close', async function({ page, context, server }) {
      const newPage = await context.newPage();
      const closedPromise = new Promise(x => newPage.on('close', x));
      await newPage.close();
      await closedPromise;
    });
  });

  describe('Page.browser', function() {
    it('should return the correct browser instance', async function({ page, browser }) {
      expect(page.browser()).toBe(browser);
    });
  });

  describe('Page.browserContext', function() {
    it('should return the correct browser instance', async function({page, context, browser}) {
      expect(page.browserContext()).toBe(context);
    });
  });
};
