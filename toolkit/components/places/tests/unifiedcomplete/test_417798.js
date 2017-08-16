/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Test for bug 417798 to make sure javascript: URIs don't show up unless the
 * user searches for javascript: explicitly.
 */

add_task(async function test_javascript_match() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", false);

  let uri1 = NetUtil.newURI("http://abc/def");
  let uri2 = NetUtil.newURI("javascript:5");
  await PlacesTestUtils.addVisits([ { uri: uri1, title: "Title with javascript:" } ]);
  await addBookmark({ uri: uri2,
                      title: "Title with javascript:" });

  do_print("Match non-javascript: with plain search");
  await check_autocomplete({
    search: "a",
    matches: [ { uri: uri1, title: "Title with javascript:" } ]
  });

  do_print("Match non-javascript: with almost javascript:");
  await check_autocomplete({
    search: "javascript",
    matches: [ { uri: uri1, title: "Title with javascript:" } ]
  });

  do_print("Match javascript:");
  await check_autocomplete({
    search: "javascript:",
    matches: [ { uri: uri1, title: "Title with javascript:" },
               { uri: uri2, title: "Title with javascript:", style: [ "bookmark" ]} ]
  });

  do_print("Match nothing with non-first javascript:");
  await check_autocomplete({
    search: "5 javascript:",
    matches: [ ]
  });

  do_print("Match javascript: with multi-word search");
  await check_autocomplete({
    search: "javascript: 5",
    matches: [ { uri: uri2, title: "Title with javascript:", style: [ "bookmark" ]} ]
  });

  await cleanup();
});
