/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

// See also browser/base/content/test/newtab/.

add_task(async function validCacheMidPopulation() {
  let expectedLinks = makeLinks(0, 3, 1);

  let provider = new TestProvider(done => done(expectedLinks));
  provider.maxNumLinks = expectedLinks.length;

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);
  let promise = new Promise(resolve => NewTabUtils.links.populateCache(resolve));

  // isTopSiteGivenProvider() and getProviderLinks() should still return results
  // even when cache is empty or being populated.
  do_check_false(NewTabUtils.isTopSiteGivenProvider("example1.com", provider));
  do_check_links(NewTabUtils.getProviderLinks(provider), []);

  await promise;

  // Once the cache is populated, we get the expected results
  do_check_true(NewTabUtils.isTopSiteGivenProvider("example1.com", provider));
  do_check_links(NewTabUtils.getProviderLinks(provider), expectedLinks);
  NewTabUtils.links.removeProvider(provider);
});

add_task(async function notifyLinkDelete() {
  let expectedLinks = makeLinks(0, 3, 1);

  let provider = new TestProvider(done => done(expectedLinks));
  provider.maxNumLinks = expectedLinks.length;

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);
  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));

  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Remove a link.
  let removedLink = expectedLinks[2];
  provider.notifyLinkChanged(removedLink, 2, true);
  let links = NewTabUtils.links._providers.get(provider);

  // Check that sortedLinks is correctly updated.
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks.slice(0, 2));

  // Check that linkMap is accurately updated.
  do_check_eq(links.linkMap.size, 2);
  do_check_true(links.linkMap.get(expectedLinks[0].url));
  do_check_true(links.linkMap.get(expectedLinks[1].url));
  do_check_false(links.linkMap.get(removedLink.url));

  // Check that siteMap is correctly updated.
  do_check_eq(links.siteMap.size, 2);
  do_check_true(links.siteMap.has(NewTabUtils.extractSite(expectedLinks[0].url)));
  do_check_true(links.siteMap.has(NewTabUtils.extractSite(expectedLinks[1].url)));
  do_check_false(links.siteMap.has(NewTabUtils.extractSite(removedLink.url)));

  NewTabUtils.links.removeProvider(provider);
});

add_task(async function populatePromise() {
  let count = 0;
  let expectedLinks = makeLinks(0, 10, 2);

  let getLinksFcn = async function(callback) {
    // Should not be calling getLinksFcn twice
    count++;
    do_check_eq(count, 1);
    await Promise.resolve();
    callback(expectedLinks);
  };

  let provider = new TestProvider(getLinksFcn);

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);

  NewTabUtils.links.populateProviderCache(provider, () => {});
  NewTabUtils.links.populateProviderCache(provider, () => {
    do_check_links(NewTabUtils.links.getLinks(), expectedLinks);
    NewTabUtils.links.removeProvider(provider);
  });
});

add_task(async function isTopSiteGivenProvider() {
  let expectedLinks = makeLinks(0, 10, 2);

  // The lowest 2 frecencies have the same base domain.
  expectedLinks[expectedLinks.length - 2].url = expectedLinks[expectedLinks.length - 1].url + "Test";

  let provider = new TestProvider(done => done(expectedLinks));
  provider.maxNumLinks = expectedLinks.length;

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);
  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));

  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example2.com", provider), true);
  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example1.com", provider), false);

  // Push out frecency 2 because the maxNumLinks is reached when adding frecency 3
  let newLink = makeLink(3);
  provider.notifyLinkChanged(newLink);

  // There is still a frecent url with example2 domain, so it's still frecent.
  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example3.com", provider), true);
  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example2.com", provider), true);

  // Push out frecency 3
  newLink = makeLink(5);
  provider.notifyLinkChanged(newLink);

  // Push out frecency 4
  newLink = makeLink(9);
  provider.notifyLinkChanged(newLink);

  // Our count reached 0 for the example2.com domain so it's no longer a frecent site.
  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example5.com", provider), true);
  do_check_eq(NewTabUtils.isTopSiteGivenProvider("example2.com", provider), false);

  NewTabUtils.links.removeProvider(provider);
});

add_task(async function multipleProviders() {
  // Make each provider generate NewTabUtils.links.maxNumLinks links to check
  // that no more than maxNumLinks are actually returned in the merged list.
  let evenLinks = makeLinks(0, 2 * NewTabUtils.links.maxNumLinks, 2);
  let evenProvider = new TestProvider(done => done(evenLinks));
  let oddLinks = makeLinks(0, 2 * NewTabUtils.links.maxNumLinks - 1, 2);
  let oddProvider = new TestProvider(done => done(oddLinks));

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(evenProvider);
  NewTabUtils.links.addProvider(oddProvider);

  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));

  let links = NewTabUtils.links.getLinks();
  let expectedLinks = makeLinks(NewTabUtils.links.maxNumLinks,
                                2 * NewTabUtils.links.maxNumLinks,
                                1);
  do_check_eq(links.length, NewTabUtils.links.maxNumLinks);
  do_check_links(links, expectedLinks);

  NewTabUtils.links.removeProvider(evenProvider);
  NewTabUtils.links.removeProvider(oddProvider);
});

add_task(async function changeLinks() {
  let expectedLinks = makeLinks(0, 20, 2);
  let provider = new TestProvider(done => done(expectedLinks));

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);

  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));

  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Notify of a new link.
  let newLink = makeLink(19);
  expectedLinks.splice(1, 0, newLink);
  provider.notifyLinkChanged(newLink);
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Notify of a link that's changed sort criteria.
  newLink.frecency = 17;
  expectedLinks.splice(1, 1);
  expectedLinks.splice(2, 0, newLink);
  provider.notifyLinkChanged({
    url: newLink.url,
    frecency: 17,
  });
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Notify of a link that's changed title.
  newLink.title = "My frecency is now 17";
  provider.notifyLinkChanged({
    url: newLink.url,
    title: newLink.title,
  });
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Notify of a new link again, but this time make it overflow maxNumLinks.
  provider.maxNumLinks = expectedLinks.length;
  newLink = makeLink(21);
  expectedLinks.unshift(newLink);
  expectedLinks.pop();
  do_check_eq(expectedLinks.length, provider.maxNumLinks); // Sanity check.
  provider.notifyLinkChanged(newLink);
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  // Notify of many links changed.
  expectedLinks = makeLinks(0, 3, 1);
  provider.notifyManyLinksChanged();

  // Since _populateProviderCache() is async, we must wait until the provider's
  // populate promise has been resolved.
  await NewTabUtils.links._providers.get(provider).populatePromise;

  // NewTabUtils.links will now repopulate its cache
  do_check_links(NewTabUtils.links.getLinks(), expectedLinks);

  NewTabUtils.links.removeProvider(provider);
});

add_task(async function oneProviderAlreadyCached() {
  let links1 = makeLinks(0, 10, 1);
  let provider1 = new TestProvider(done => done(links1));

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider1);

  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));
  do_check_links(NewTabUtils.links.getLinks(), links1);

  let links2 = makeLinks(10, 20, 1);
  let provider2 = new TestProvider(done => done(links2));
  NewTabUtils.links.addProvider(provider2);

  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));
  do_check_links(NewTabUtils.links.getLinks(), links2.concat(links1));

  NewTabUtils.links.removeProvider(provider1);
  NewTabUtils.links.removeProvider(provider2);
});

add_task(async function newLowRankedLink() {
  // Init a provider with 10 links and make its maximum number also 10.
  let links = makeLinks(0, 10, 1);
  let provider = new TestProvider(done => done(links));
  provider.maxNumLinks = links.length;

  NewTabUtils.initWithoutProviders();
  NewTabUtils.links.addProvider(provider);

  await new Promise(resolve => NewTabUtils.links.populateCache(resolve));
  do_check_links(NewTabUtils.links.getLinks(), links);

  // Notify of a new link that's low-ranked enough not to make the list.
  let newLink = makeLink(0);
  provider.notifyLinkChanged(newLink);
  do_check_links(NewTabUtils.links.getLinks(), links);

  // Notify about the new link's title change.
  provider.notifyLinkChanged({
    url: newLink.url,
    title: "a new title",
  });
  do_check_links(NewTabUtils.links.getLinks(), links);

  NewTabUtils.links.removeProvider(provider);
});

add_task(async function extractSite() {
  // All these should extract to the same site
  [ "mozilla.org",
    "m.mozilla.org",
    "mobile.mozilla.org",
    "www.mozilla.org",
    "www3.mozilla.org",
  ].forEach(host => {
    let url = "http://" + host;
    do_check_eq(NewTabUtils.extractSite(url), "mozilla.org", "extracted same " + host);
  });

  // All these should extract to the same subdomain
  [ "bugzilla.mozilla.org",
    "www.bugzilla.mozilla.org",
  ].forEach(host => {
    let url = "http://" + host;
    do_check_eq(NewTabUtils.extractSite(url), "bugzilla.mozilla.org", "extracted eTLD+2 " + host);
  });

  // All these should not extract to the same site
  [ "bugzilla.mozilla.org",
    "bug123.bugzilla.mozilla.org",
    "too.many.levels.bugzilla.mozilla.org",
    "m2.mozilla.org",
    "mobile30.mozilla.org",
    "ww.mozilla.org",
    "ww2.mozilla.org",
    "wwwww.mozilla.org",
    "wwwww50.mozilla.org",
    "wwws.mozilla.org",
    "secure.mozilla.org",
    "secure10.mozilla.org",
    "many.levels.deep.mozilla.org",
    "just.check.in",
    "192.168.0.1",
    "localhost",
  ].forEach(host => {
    let url = "http://" + host;
    do_check_neq(NewTabUtils.extractSite(url), "mozilla.org", "extracted diff " + host);
  });

  // All these should not extract to the same site
  [ "about:blank",
    "file:///Users/user/file",
    "chrome://browser/something",
    "ftp://ftp.mozilla.org/",
  ].forEach(url => {
    do_check_neq(NewTabUtils.extractSite(url), "mozilla.org", "extracted diff url " + url);
  });
});

add_task(async function faviconBytesToDataURI() {
  let tests = [
        [{favicon: "bar".split("").map(s => s.charCodeAt(0)), mimeType: "foo"}],
        [{favicon: "bar".split("").map(s => s.charCodeAt(0)), mimeType: "foo", xxyy: "quz"}]
      ];
  let provider = NewTabUtils.activityStreamProvider;

  for (let test of tests) {
    let clone = JSON.parse(JSON.stringify(test));
    delete clone[0].mimeType;
    clone[0].favicon = `data:foo;base64,${btoa("bar")}`;
    let result = provider._faviconBytesToDataURI(test);
    Assert.deepEqual(JSON.stringify(clone), JSON.stringify(result), "favicon converted to data uri");
  }
});

add_task(async function addFavicons() {
  await setUpActivityStreamTest();
  let provider = NewTabUtils.activityStreamProvider;

  // start by passing in a bad uri and check that we get a null favicon back
  let links = [{url: "mozilla.com"}];
  await provider._addFavicons(links);
  Assert.equal(links[0].favicon, null, "Got a null favicon because we passed in a bad url");
  Assert.equal(links[0].mimeType, null, "Got a null mime type because we passed in a bad url");

  // now fix the url and try again - this time we get good favicon data back
  links[0].url = "https://mozilla.com";
  let base64URL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAA" +
    "AAAA6fptVAAAACklEQVQI12NgAAAAAgAB4iG8MwAAAABJRU5ErkJggg==";

  let visit = [
    {uri: links[0].url, visitDate: timeDaysAgo(0), transition: PlacesUtils.history.TRANSITION_TYPED}
  ];
  await PlacesTestUtils.addVisits(visit);

  let faviconData = new Map();
  faviconData.set("https://mozilla.com", base64URL);
  await PlacesTestUtils.addFavicons(faviconData);

  await provider._addFavicons(links);
  Assert.equal(links[0].mimeType, "image/png", "Got the right mime type before deleting it");
  Assert.equal(links[0].faviconLength, links[0].favicon.length, "Got the right length for the byte array");
  Assert.equal(provider._faviconBytesToDataURI(links)[0].favicon, base64URL, "Got the right favicon");
});

add_task(async function getTopFrecentSites() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;
  let links = await provider.getTopSites();
  Assert.equal(links.length, 0, "empty history yields empty links");

  // add a visit
  let testURI = "http://mozilla.com/";
  await PlacesTestUtils.addVisits(testURI);

  links = await provider.getTopSites();
  Assert.equal(links.length, 1, "adding a visit yields a link");
  Assert.equal(links[0].url, testURI, "added visit corresponds to added url");
  Assert.equal(links[0].eTLD, "com", "added visit mozilla.com has 'com' eTLD");
});

add_task(async function getTopFrecentSites_dedupeWWW() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;

  let links = await provider.getTopSites();
  Assert.equal(links.length, 0, "empty history yields empty links");

  // add a visit without www
  let testURI = "http://mozilla.com";
  await PlacesTestUtils.addVisits(testURI);

  // add a visit with www
  testURI = "http://www.mozilla.com";
  await PlacesTestUtils.addVisits(testURI);

  // Test combined frecency score
  links = await provider.getTopSites();
  Assert.equal(links.length, 1, "adding both www. and no-www. yields one link");
  Assert.equal(links[0].frecency, 200, "frecency scores are combined");

  // add another page visit with www and without www
  testURI = "http://mozilla.com/page";
  await PlacesTestUtils.addVisits(testURI);
  testURI = "http://www.mozilla.com/page";
  await PlacesTestUtils.addVisits(testURI);
  links = await provider.getTopSites();
  Assert.equal(links.length, 1, "adding both www. and no-www. yields one link");
  Assert.equal(links[0].frecency, 200, "frecency scores are combined ignoring extra pages");
});

add_task(async function getTopFrencentSites_maxLimit() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;

  // add many visits
  const MANY_LINKS = 20;
  for (let i = 0; i < MANY_LINKS; i++) {
    let testURI = `http://mozilla${i}.com`;
    await PlacesTestUtils.addVisits(testURI);
  }

  let links = await provider.getTopSites();
  Assert.ok(links.length < MANY_LINKS, "query default limited to less than many");
  Assert.ok(links.length > 6, "query default to more than visible count");
});

add_task(async function getTopFrecentSites_order() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;
  let {TRANSITION_TYPED} = PlacesUtils.history;

  let timeEarlier = timeDaysAgo(0);
  let timeLater = timeDaysAgo(2);

  let visits = [
    // frecency 200
    {uri: "https://mozilla1.com/0", visitDate: timeEarlier, transition: TRANSITION_TYPED},
    // sort by url, frecency 200
    {uri: "https://mozilla2.com/1", visitDate: timeEarlier, transition: TRANSITION_TYPED},
    // sort by last visit date, frecency 200
    {uri: "https://mozilla3.com/2", visitDate: timeLater, transition: TRANSITION_TYPED},
    // sort by frecency, frecency 10
    {uri: "https://mozilla4.com/3", visitDate: timeLater}
  ];

  let links = await provider.getTopSites();
  Assert.equal(links.length, 0, "empty history yields empty links");

  let base64URL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAA" +
    "AAAA6fptVAAAACklEQVQI12NgAAAAAgAB4iG8MwAAAABJRU5ErkJggg==";

  // map of page url to favicon url
  let faviconData = new Map();
  faviconData.set("https://mozilla3.com/2", base64URL);

  await PlacesTestUtils.addVisits(visits);
  await PlacesTestUtils.addFavicons(faviconData);

  links = await provider.getTopSites();
  Assert.equal(links.length, visits.length, "number of links added is the same as obtain by getTopFrecentSites");

  // first link doesn't have a favicon
  Assert.equal(links[0].url, visits[0].uri, "links are obtained in the expected order");
  Assert.equal(null, links[0].favicon, "favicon data is stored as expected");
  Assert.ok(isVisitDateOK(links[0].lastVisitDate), "visit date within expected range");

  // second link doesn't have a favicon
  Assert.equal(links[1].url, visits[1].uri, "links are obtained in the expected order");
  Assert.equal(null, links[1].favicon, "favicon data is stored as expected");
  Assert.ok(isVisitDateOK(links[1].lastVisitDate), "visit date within expected range");

  // third link should have the favicon data that we added
  Assert.equal(links[2].url, visits[2].uri, "links are obtained in the expected order");
  Assert.equal(faviconData.get(links[2].url), links[2].favicon, "favicon data is stored as expected");
  Assert.ok(isVisitDateOK(links[2].lastVisitDate), "visit date within expected range");

  // fourth link doesn't have a favicon
  Assert.equal(links[3].url, visits[3].uri, "links are obtained in the expected order");
  Assert.equal(null, links[3].favicon, "favicon data is stored as expected");
  Assert.ok(isVisitDateOK(links[3].lastVisitDate), "visit date within expected range");
});

add_task(async function activitySteamProvider_deleteHistoryLink() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;

  let {TRANSITION_TYPED} = PlacesUtils.history;

  let visits = [
    // frecency 200
    {uri: "https://mozilla1.com/0", visitDate: timeDaysAgo(1), transition: TRANSITION_TYPED},
    // sort by url, frecency 200
    {uri: "https://mozilla2.com/1", visitDate: timeDaysAgo(0)}
  ];

  let size = await NewTabUtils.activityStreamProvider.getHistorySize();
  Assert.equal(size, 0, "empty history has size 0");

  await PlacesTestUtils.addVisits(visits);

  size = await NewTabUtils.activityStreamProvider.getHistorySize();
  Assert.equal(size, 2, "expected history size");

  // delete a link
  let deleted = await provider.deleteHistoryEntry("https://mozilla2.com/1");
  Assert.equal(deleted, true, "link is deleted");

  // ensure that there's only one link left
  size = await NewTabUtils.activityStreamProvider.getHistorySize();
  Assert.equal(size, 1, "expected history size");
});

add_task(async function activityStream_addBookmark() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;
  let bookmarks = [
    "https://mozilla1.com/0",
    "https://mozilla1.com/1"
  ];

  let bookmarksSize = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(bookmarksSize, 0, "empty bookmarks yields 0 size");

  for (let url of bookmarks) {
    await provider.addBookmark(url);
  }
  bookmarksSize = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(bookmarksSize, 2, "size 2 for 2 bookmarks added");
});

add_task(async function activityStream_getBookmark() {
    await setUpActivityStreamTest();

    let provider = NewTabUtils.activityStreamLinks;
    let bookmark = await provider.addBookmark("https://mozilla1.com/0");

    let result = await NewTabUtils.activityStreamProvider.getBookmark(bookmark.guid);
    Assert.equal(result.bookmarkGuid, bookmark.guid, "got the correct bookmark guid");
    Assert.equal(result.bookmarkTitle, bookmark.title, "got the correct bookmark title");
    Assert.equal(result.lastModified, bookmark.lastModified.getTime(), "got the correct bookmark time");
    Assert.equal(result.url, bookmark.url.href, "got the correct bookmark url");
});

add_task(async function activityStream_deleteBookmark() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;
  let bookmarks = [
    {url: "https://mozilla1.com/0", parentGuid: PlacesUtils.bookmarks.unfiledGuid, type: PlacesUtils.bookmarks.TYPE_BOOKMARK},
    {url: "https://mozilla1.com/1", parentGuid: PlacesUtils.bookmarks.unfiledGuid, type: PlacesUtils.bookmarks.TYPE_BOOKMARK}
  ];

  let bookmarksSize = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(bookmarksSize, 0, "empty bookmarks yields 0 size");

  for (let placeInfo of bookmarks) {
    await PlacesUtils.bookmarks.insert(placeInfo);
  }

  bookmarksSize = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(bookmarksSize, 2, "size 2 for 2 bookmarks added");

  let bookmarkGuid = await new Promise(resolve => PlacesUtils.bookmarks.fetch(
    {url: bookmarks[0].url}, bookmark => resolve(bookmark.guid)));
  let deleted = await provider.deleteBookmark(bookmarkGuid);
  Assert.equal(deleted.guid, bookmarkGuid, "the correct bookmark was deleted");

  bookmarksSize = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(bookmarksSize, 1, "size 1 after deleting");
});

add_task(async function activityStream_blockedURLs() {
  await setUpActivityStreamTest();

  let provider = NewTabUtils.activityStreamLinks;
  NewTabUtils.blockedLinks.addObserver(provider);

  let {TRANSITION_TYPED} = PlacesUtils.history;

  let timeToday = timeDaysAgo(0);
  let timeEarlier = timeDaysAgo(2);

  let visits = [
    {uri: "https://example1.com/", visitDate: timeToday, transition: TRANSITION_TYPED},
    {uri: "https://example2.com/", visitDate: timeToday, transition: TRANSITION_TYPED},
    {uri: "https://example3.com/", visitDate: timeEarlier, transition: TRANSITION_TYPED},
    {uri: "https://example4.com/", visitDate: timeEarlier, transition: TRANSITION_TYPED}
  ];
  await PlacesTestUtils.addVisits(visits);
  await PlacesUtils.bookmarks.insert({url: "https://example5.com/", parentGuid: PlacesUtils.bookmarks.unfiledGuid, type: PlacesUtils.bookmarks.TYPE_BOOKMARK});

  let sizeQueryResult;

  // bookmarks
  sizeQueryResult = await NewTabUtils.activityStreamProvider.getBookmarksSize();
  Assert.equal(sizeQueryResult, 1, "got the correct bookmark size");
});

function TestProvider(getLinksFn) {
  this.getLinks = getLinksFn;
  this._observers = new Set();
}

TestProvider.prototype = {
  addObserver(observer) {
    this._observers.add(observer);
  },
  notifyLinkChanged(link, index = -1, deleted = false) {
    this._notifyObservers("onLinkChanged", link, index, deleted);
  },
  notifyManyLinksChanged() {
    this._notifyObservers("onManyLinksChanged");
  },
  _notifyObservers() {
    let observerMethodName = arguments[0];
    let args = Array.prototype.slice.call(arguments, 1);
    args.unshift(this);
    for (let obs of this._observers) {
      if (obs[observerMethodName])
        obs[observerMethodName].apply(NewTabUtils.links, args);
    }
  },
};

