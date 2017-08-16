/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

"use strict";

const {utils: Cu} = Components;
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource:///modules/NewTabURL.jsm");
Cu.import("resource://gre/modules/Services.jsm");
XPCOMUtils.defineLazyServiceGetter(this, "aboutNewTabService",
                                   "@mozilla.org/browser/aboutnewtab-service;1",
                                   "nsIAboutNewTabService");

add_task(async function() {
  let defaultURL = aboutNewTabService.newTabURL;
  Services.prefs.setBoolPref("browser.newtabpage.activity-stream.enabled", false);

  Assert.equal(NewTabURL.get(), defaultURL, `Default newtab URL should be ${defaultURL}`);
  let url = "http://example.com/";
  let notificationPromise = promiseNewtabURLNotification(url);
  NewTabURL.override(url);
  await notificationPromise;
  Assert.ok(NewTabURL.overridden, "Newtab URL should be overridden");
  Assert.equal(NewTabURL.get(), url, "Newtab URL should be the custom URL");

  notificationPromise = promiseNewtabURLNotification(defaultURL);
  NewTabURL.reset();
  await notificationPromise;
  Assert.ok(!NewTabURL.overridden, "Newtab URL should not be overridden");
  Assert.equal(NewTabURL.get(), defaultURL, "Newtab URL should be the default");

  // change newtab page to activity stream
  Services.prefs.setBoolPref("browser.newtabpage.activity-stream.enabled", true);
  Assert.equal(NewTabURL.get(), "about:newtab", `Newtab URL should be about:newtab`);
  Assert.ok(!NewTabURL.overridden, "Newtab URL should not be overridden");
});

function promiseNewtabURLNotification(aNewURL) {
  return new Promise(resolve => {
    Services.obs.addObserver(function observer(aSubject, aTopic, aData) { // jshint ignore:line
      Services.obs.removeObserver(observer, aTopic);
      Assert.equal(aData, aNewURL, "Data for newtab-url-changed notification should be new URL.");
      resolve();
    }, "newtab-url-changed");
  });
}
