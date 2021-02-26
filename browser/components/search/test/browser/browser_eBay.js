/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Test eBay search plugin URLs
 */

"use strict";

add_task(async function test() {
  await Services.search.init();

  let engine = Services.search.getEngineByName("eBay");
  ok(engine, "eBay");

  let base =
    "https://www.ebay.com/sch/?toolid=20004&campid=5338192028&mkevt=1&mkcid=1&mkrid=711-53200-19255-0&kw=foo";
  let url;

  // Test search URLs (including purposes).
  url = engine.getSubmission("foo").uri.spec;
  is(url, base, "Check search URL for 'foo'");

  // Check all other engine properties.
  const EXPECTED_ENGINE = {
    name: "eBay",
    alias: null,
    description: "eBay - Online auctions",
    searchForm: "https://www.ebay.com/",
    hidden: false,
    wrappedJSObject: {
      _urls: [
        {
          type: "text/html",
          method: "GET",
          template: "https://www.ebay.com/sch/",
          params: [
            {
              name: "toolid",
              value: "20004",
              purpose: undefined,
            },
            {
              name: "campid",
              value: "5338192028",
              purpose: undefined,
            },
            {
              name: "mkevt",
              value: "1",
              purpose: undefined,
            },
            {
              name: "mkcid",
              value: "1",
              purpose: undefined,
            },
            {
              name: "mkrid",
              value: "711-53200-19255-0",
              purpose: undefined,
            },
            {
              name: "kw",
              value: "{searchTerms}",
              purpose: undefined,
            },
          ],
        },
      ],
    },
  };

  isSubObjectOf(EXPECTED_ENGINE, engine, "eBay");
});
