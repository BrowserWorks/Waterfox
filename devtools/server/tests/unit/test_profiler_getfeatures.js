/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Tests whether the profiler responds to "getFeatures" adequately.
 */

function run_test() {
  get_chrome_actors((client, form) => {
    let actor = form.profilerActor;
    test_getfeatures(client, actor, () => {
      client.close().then(() => {
        do_test_finished();
      });
    });
  });

  do_test_pending();
}

function test_getfeatures(client, actor, callback) {
  client.request({ to: actor, type: "getFeatures" }, response => {
    do_check_eq(typeof response.features, "object");
    do_check_true(response.features.length >= 1);
    do_check_eq(typeof response.features[0], "string");
    do_check_true(response.features.indexOf("js") != -1);
    callback();
  });
}
