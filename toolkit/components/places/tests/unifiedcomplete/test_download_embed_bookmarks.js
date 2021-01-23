/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim:set ts=2 sw=2 sts=2 et:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Tests bug 449406 to ensure that TRANSITION_DOWNLOAD, TRANSITION_EMBED and
 * TRANSITION_FRAMED_LINK bookmarked uri's show up in the location bar.
 */

add_task(async function test_download_embed_bookmarks() {
  let uri1 = NetUtil.newURI("http://download/bookmarked");
  let uri2 = NetUtil.newURI("http://embed/bookmarked");
  let uri3 = NetUtil.newURI("http://framed/bookmarked");
  let uri4 = NetUtil.newURI("http://download");
  let uri5 = NetUtil.newURI("http://embed");
  let uri6 = NetUtil.newURI("http://framed");
  await PlacesTestUtils.addVisits([
    { uri: uri1, title: "download-bookmark", transition: TRANSITION_DOWNLOAD },
    { uri: uri2, title: "embed-bookmark", transition: TRANSITION_EMBED },
    { uri: uri3, title: "framed-bookmark", transition: TRANSITION_FRAMED_LINK },
    { uri: uri4, title: "download2", transition: TRANSITION_DOWNLOAD },
    { uri: uri5, title: "embed2", transition: TRANSITION_EMBED },
    { uri: uri6, title: "framed2", transition: TRANSITION_FRAMED_LINK },
  ]);
  await PlacesTestUtils.addBookmarkWithDetails({
    uri: uri1,
    title: "download-bookmark",
  });
  await PlacesTestUtils.addBookmarkWithDetails({
    uri: uri2,
    title: "embed-bookmark",
  });
  await PlacesTestUtils.addBookmarkWithDetails({
    uri: uri3,
    title: "framed-bookmark",
  });

  info("Searching for bookmarked download uri matches");
  await check_autocomplete({
    search: "download-bookmark",
    matches: [{ uri: uri1, title: "download-bookmark", style: ["bookmark"] }],
  });

  info("Searching for bookmarked embed uri matches");
  await check_autocomplete({
    search: "embed-bookmark",
    matches: [{ uri: uri2, title: "embed-bookmark", style: ["bookmark"] }],
  });

  info("Searching for bookmarked framed uri matches");
  await check_autocomplete({
    search: "framed-bookmark",
    matches: [{ uri: uri3, title: "framed-bookmark", style: ["bookmark"] }],
  });

  info("Searching for download uri does not match");
  await check_autocomplete({
    search: "download2",
    matches: [],
  });

  info("Searching for embed uri does not match");
  await check_autocomplete({
    search: "embed2",
    matches: [],
  });

  info("Searching for framed uri does not match");
  await check_autocomplete({
    search: "framed2",
    matches: [],
  });

  await cleanup();
});
