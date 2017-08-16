/*
 * Description of the test:
 *   Check that HSTS priming occurs correctly with mixed content when active
 *   content is blocked.
 */
'use strict';

//jscs:disable
add_task(function*() {
  //jscs:enable
  Services.obs.addObserver(Observer, "console-api-log-event");
  Services.obs.addObserver(Observer, "http-on-examine-response");
  registerCleanupFunction(do_cleanup);

  let which = "block_active";

  SetupPrefTestEnvironment(which);

  for (let server of Object.keys(test_servers)) {
    yield execute_test(server, test_settings[which].mimetype);
  }

  SpecialPowers.popPrefEnv();
});
