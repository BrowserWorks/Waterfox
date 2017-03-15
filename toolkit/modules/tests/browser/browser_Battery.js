/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";
var imported = Components.utils.import("resource://gre/modules/Battery.jsm", this);
Cu.import("resource://gre/modules/Services.jsm", this);

function test() {
  waitForExplicitFinish();

  is(imported.Debugging.fake, false, "Battery spoofing is initially false")

  GetBattery().then(function (battery) {
    for (let k of ["charging", "chargingTime", "dischargingTime", "level"]) {
      let backup = battery[k];
      try {
        battery[k] = "__magic__";
      } catch (e) {
        // We are testing that we cannot set battery to new values
        // when "use strict" is enabled, this throws a TypeError
        if (e.name != "TypeError")
          throw e;
      }
      is(battery[k], backup, "Setting battery " + k + " preference without spoofing enabled should fail");
    }

    imported.Debugging.fake = true;

    // reload again to get the fake one
    GetBattery().then(function (battery) {
      battery.charging = true;
      battery.chargingTime = 100;
      battery.level = 0.5;
      ok(battery.charging, "Test for charging setter");
      is(battery.chargingTime, 100, "Test for chargingTime setter");
      is(battery.level, 0.5, "Test for level setter");

      battery.charging = false;
      battery.dischargingTime = 50;
      battery.level = 0.7;
      ok(!battery.charging, "Test for charging setter");
      is(battery.dischargingTime, 50, "Test for dischargingTime setter");
      is(battery.level, 0.7, "Test for level setter");

      // Resetting the value to make the test run successful
      // for multiple runs in same browser session.
      imported.Debugging.fake = false;
      finish();
    });
  });
}
