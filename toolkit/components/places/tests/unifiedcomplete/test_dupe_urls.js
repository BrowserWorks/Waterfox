/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Ensure inline autocomplete doesn't return zero frecency pages.

add_task(async function test_dupe_urls() {
  do_print("Searching for urls with dupes should only show one");
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("http://mozilla.org/"),
    transition: TRANSITION_TYPED
  }, {
    uri: NetUtil.newURI("http://mozilla.org/?")
  });
  await check_autocomplete({
    search: "moz",
    autofilled: "mozilla.org/",
    completed:  "mozilla.org/",
    matches: [ { uri: NetUtil.newURI("http://mozilla.org/"),
                 title: "mozilla.org",
                 style: [ "autofill", "heuristic" ] } ]
  });
});

add_task(async function test_dupe_secure_urls() {
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("https://example.org/"),
    transition: TRANSITION_TYPED
  }, {
    uri: NetUtil.newURI("https://example.org/?")
  });
  await check_autocomplete({
    search: "exam",
    autofilled: "example.org/",
    completed: "https://example.org/",
    matches: [ { uri: NetUtil.newURI("https://example.org/"),
                 title: "https://example.org",
                 style: [ "autofill", "heuristic" ] } ]
  });
});
