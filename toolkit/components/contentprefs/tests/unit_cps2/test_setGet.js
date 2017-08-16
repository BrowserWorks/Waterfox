/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

function run_test() {
  runAsyncTests(tests);
}

var tests = [

  function* get_nonexistent() {
    yield getOK(["a.com", "foo"], undefined);
    yield getGlobalOK(["foo"], undefined);
  },

  function* isomorphicDomains() {
    yield set("a.com", "foo", 1);
    yield dbOK([
      ["a.com", "foo", 1],
    ]);
    yield getOK(["a.com", "foo"], 1);
    yield getOK(["http://a.com/huh", "foo"], 1, "a.com");

    yield set("http://a.com/huh", "foo", 2);
    yield dbOK([
      ["a.com", "foo", 2],
    ]);
    yield getOK(["a.com", "foo"], 2);
    yield getOK(["http://a.com/yeah", "foo"], 2, "a.com");
  },

  function* names() {
    yield set("a.com", "foo", 1);
    yield dbOK([
      ["a.com", "foo", 1],
    ]);
    yield getOK(["a.com", "foo"], 1);

    yield set("a.com", "bar", 2);
    yield dbOK([
      ["a.com", "foo", 1],
      ["a.com", "bar", 2],
    ]);
    yield getOK(["a.com", "foo"], 1);
    yield getOK(["a.com", "bar"], 2);

    yield setGlobal("foo", 3);
    yield dbOK([
      ["a.com", "foo", 1],
      ["a.com", "bar", 2],
      [null, "foo", 3],
    ]);
    yield getOK(["a.com", "foo"], 1);
    yield getOK(["a.com", "bar"], 2);
    yield getGlobalOK(["foo"], 3);

    yield setGlobal("bar", 4);
    yield dbOK([
      ["a.com", "foo", 1],
      ["a.com", "bar", 2],
      [null, "foo", 3],
      [null, "bar", 4],
    ]);
    yield getOK(["a.com", "foo"], 1);
    yield getOK(["a.com", "bar"], 2);
    yield getGlobalOK(["foo"], 3);
    yield getGlobalOK(["bar"], 4);
  },

  function* subdomains() {
    yield set("a.com", "foo", 1);
    yield set("b.a.com", "foo", 2);
    yield dbOK([
      ["a.com", "foo", 1],
      ["b.a.com", "foo", 2],
    ]);
    yield getOK(["a.com", "foo"], 1);
    yield getOK(["b.a.com", "foo"], 2);
  },

  function* privateBrowsing() {
    yield set("a.com", "foo", 1);
    yield set("a.com", "bar", 2);
    yield setGlobal("foo", 3);
    yield setGlobal("bar", 4);
    yield set("b.com", "foo", 5);

    let context = privateLoadContext;
    yield set("a.com", "foo", 6, context);
    yield setGlobal("foo", 7, context);
    yield dbOK([
      ["a.com", "foo", 1],
      ["a.com", "bar", 2],
      [null, "foo", 3],
      [null, "bar", 4],
      ["b.com", "foo", 5],
    ]);
    yield getOK(["a.com", "foo", context], 6, "a.com");
    yield getOK(["a.com", "bar", context], 2);
    yield getGlobalOK(["foo", context], 7);
    yield getGlobalOK(["bar", context], 4);
    yield getOK(["b.com", "foo", context], 5);

    yield getOK(["a.com", "foo"], 1);
    yield getOK(["a.com", "bar"], 2);
    yield getGlobalOK(["foo"], 3);
    yield getGlobalOK(["bar"], 4);
    yield getOK(["b.com", "foo"], 5);
  },

  function* set_erroneous() {
    do_check_throws(() => cps.set(null, "foo", 1, null));
    do_check_throws(() => cps.set("", "foo", 1, null));
    do_check_throws(() => cps.set("a.com", "", 1, null));
    do_check_throws(() => cps.set("a.com", null, 1, null));
    do_check_throws(() => cps.set("a.com", "foo", undefined, null));
    do_check_throws(() => cps.set("a.com", "foo", 1, null, "bogus"));
    do_check_throws(() => cps.setGlobal("", 1, null));
    do_check_throws(() => cps.setGlobal(null, 1, null));
    do_check_throws(() => cps.setGlobal("foo", undefined, null));
    do_check_throws(() => cps.setGlobal("foo", 1, null, "bogus"));
    yield true;
  },

  function* get_erroneous() {
    do_check_throws(() => cps.getByDomainAndName(null, "foo", null, {}));
    do_check_throws(() => cps.getByDomainAndName("", "foo", null, {}));
    do_check_throws(() => cps.getByDomainAndName("a.com", "", null, {}));
    do_check_throws(() => cps.getByDomainAndName("a.com", null, null, {}));
    do_check_throws(() => cps.getByDomainAndName("a.com", "foo", null, null));
    do_check_throws(() => cps.getGlobal("", null, {}));
    do_check_throws(() => cps.getGlobal(null, null, {}));
    do_check_throws(() => cps.getGlobal("foo", null, null));
    yield true;
  },

  function* set_invalidateCache() {
    // (1) Set a pref and wait for it to finish.
    yield set("a.com", "foo", 1);

    // (2) It should be cached.
    getCachedOK(["a.com", "foo"], true, 1);

    // (3) Set the pref to a new value but don't wait for it to finish.
    cps.set("a.com", "foo", 2, null, {
      handleCompletion() {
        // (6) The pref should be cached after setting it.
        getCachedOK(["a.com", "foo"], true, 2);
      },
    });

    // (4) Group "a.com" and name "foo" should no longer be cached.
    getCachedOK(["a.com", "foo"], false);

    // (5) Call getByDomainAndName.
    var fetchedPref;
    cps.getByDomainAndName("a.com", "foo", null, {
      handleResult(pref) {
        fetchedPref = pref;
      },
      handleCompletion() {
        // (7) Finally, this callback should be called after set's above.
        do_check_true(!!fetchedPref);
        do_check_eq(fetchedPref.value, 2);
        next();
      },
    });

    yield;
  },

  function* get_nameOnly() {
    yield set("a.com", "foo", 1);
    yield set("a.com", "bar", 2);
    yield set("b.com", "foo", 3);
    yield setGlobal("foo", 4);

    yield getOKEx("getByName", ["foo", undefined], [
      {"domain": "a.com", "name": "foo", "value": 1},
      {"domain": "b.com", "name": "foo", "value": 3},
      {"domain": null, "name": "foo", "value": 4}
    ]);

    let context = privateLoadContext;
    yield set("b.com", "foo", 5, context);

    yield getOKEx("getByName", ["foo", context], [
      {"domain": "a.com", "name": "foo", "value": 1},
      {"domain": null, "name": "foo", "value": 4},
      {"domain": "b.com", "name": "foo", "value": 5}
    ]);
  },

  function* setSetsCurrentDate() {
    // Because Date.now() is not guaranteed to be monotonically increasing
    // we just do here rough sanity check with one minute tolerance.
    const MINUTE = 60 * 1000;
    let now = Date.now();
    let start = now - MINUTE;
    let end = now + MINUTE;
    yield set("a.com", "foo", 1);
    let timestamp = yield getDate("a.com", "foo");
    ok(start <= timestamp, "Timestamp is not too early (" + start + "<=" + timestamp + ").");
    ok(timestamp <= end, "Timestamp is not too late (" + timestamp + "<=" + end + ").");
  },
];
