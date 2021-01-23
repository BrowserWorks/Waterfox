/* eslint-env mozilla/frame-script */

"use strict";

let cs = Cc["@mozilla.org/cookiemanager;1"].getService(Ci.nsICookieManager);

addMessageListener("getCookieCountAndClear", () => {
  let count = 0;
  for (let cookie of cs.cookies) {
    ++count;
  }
  cs.removeAll();

  sendAsyncMessage("getCookieCountAndClear:return", { count });
});

cs.removeAll();
