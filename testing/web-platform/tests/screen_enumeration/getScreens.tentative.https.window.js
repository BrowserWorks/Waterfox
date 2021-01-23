// META: global=window,dedicatedworker,sharedworker,serviceworker
// META: script=/resources/testdriver.js
// META: script=/resources/testdriver-vendor.js
'use strict';

promise_test(async testCase => {
  assert_equals(typeof self.getScreens, 'function');
}, 'self.getScreens is present');

promise_test(async testCase => {
  await test_driver.set_permission({name: 'window-placement'}, 'granted');
  const screens = await self.getScreens();
  assert_greater_than(screens.length, 0);

  assert_equals(typeof screens[0].availWidth, 'number');
  assert_equals(typeof screens[0].availHeight, 'number');
  assert_equals(typeof screens[0].width, 'number');
  assert_equals(typeof screens[0].height, 'number');
  assert_equals(typeof screens[0].colorDepth, 'number');
  assert_equals(typeof screens[0].pixelDepth, 'number');

  assert_equals(typeof screens[0].availLeft, 'number');
  assert_equals(typeof screens[0].availTop, 'number');
  assert_equals(typeof screens[0].left, 'number');
  assert_equals(typeof screens[0].top, 'number');
  assert_equals(typeof screens[0].orientation, 'object');

  assert_equals(typeof screens[0].primary, 'boolean');
  assert_equals(typeof screens[0].internal, 'boolean');
  assert_equals(typeof screens[0].scaleFactor, 'number');
  assert_equals(typeof screens[0].id, 'string');
  assert_equals(typeof screens[0].touchSupport, 'boolean');
}, 'self.getScreens returns at least 1 Screen with permission granted');

promise_test(async testCase => {
  await test_driver.set_permission({name: 'window-placement'}, 'denied');
  const screens = await self.getScreens();
  assert_equals(screens.length, 0);
}, 'self.getScreens returns no Screen objects with permission denied');
