/* Any copyright is dedicated to the Public Domain.
   https://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

requestLongerTimeout(2);

const { PlacesTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/PlacesTestUtils.sys.mjs"
);
const { SearchTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/SearchTestUtils.sys.mjs"
);
const { SearchUtils } = ChromeUtils.importESModule(
  "moz-src:///toolkit/components/search/SearchUtils.sys.mjs"
);

add_task(async function test_addEngineGet() {
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });

  // Add new engine via add engine dialog.
  let doc = gBrowser.contentDocument;
  let addButton = doc.querySelector("moz-button#addEngineButton");
  let dialogWin = await openDialogWith(doc, () => addButton.click());
  Assert.equal(
    dialogWin.document.getElementById("titleContainer").style.display,
    "none",
    "Adjustable title is hidden in add engine dialog."
  );

  setName("Bugzilla", dialogWin);
  setUrl(
    "https://bugzilla.mozilla.org/buglist.cgi?quicksearch=%s&list_id=17442621",
    dialogWin
  );
  await setAlias("bz", dialogWin);

  let advanced = dialogWin.document.querySelector("dialog").getButton("extra1");
  Assert.ok(!advanced.hidden, "Button is visible");
  Assert.ok(
    dialogWin.document.getElementById("advanced-section").hidden,
    "Advanced section is hidden"
  );
  advanced.click();
  Assert.ok(advanced.hidden, "Button was hidden");
  Assert.ok(
    !dialogWin.document.getElementById("advanced-section").hidden,
    "Advanced section was made visible"
  );

  let promiseAdded = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.ADDED,
    SearchUtils.TOPIC_ENGINE_MODIFIED
  );
  EventUtils.synthesizeKey("VK_RETURN", {}, dialogWin);
  await promiseAdded;
  Assert.ok(true, "Got added notification.");

  // Check new engine.
  let engine = SearchService.getEngineByName("Bugzilla");
  Assert.equal(engine.name, "Bugzilla", "Name is correct.");
  Assert.equal(
    engine.getSubmission("föö").uri.spec,
    "https://bugzilla.mozilla.org/buglist.cgi?quicksearch=f%C3%B6%C3%B6&list_id=17442621",
    "URL is correct and encodes search terms using utf-8."
  );
  Assert.equal(engine.alias, "bz", "Alias is correct.");

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(engine);
});

add_task(async function test_addEnginePost() {
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });

  // Add new engine via add engine dialog.
  let doc = gBrowser.contentDocument;
  let addButton = doc.querySelector("moz-button#addEngineButton");
  let dialogWin = await openDialogWith(doc, () => addButton.click());
  dialogWin.document.querySelector("dialog").getButton("extra1").click();

  setName("Bugzilla Post", dialogWin);
  setUrl("https://bugzilla.mozilla.org/buglist.cgi", dialogWin);
  await setAlias("bz", dialogWin);
  setPostData("quicksearch=%s&list_id=17442621", dialogWin);
  setSuggestUrl("https://bugzilla.mozilla.org/suggest?q=%s", dialogWin);

  let promiseAdded = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.ADDED,
    SearchUtils.TOPIC_ENGINE_MODIFIED
  );
  EventUtils.synthesizeKey("VK_RETURN", {}, dialogWin);
  await promiseAdded;
  Assert.ok(true, "Got added notification.");

  // Check new engine.
  let engine = SearchService.getEngineByName("Bugzilla Post");
  Assert.equal(engine.name, "Bugzilla Post", "Name is correct.");
  let submission = engine.getSubmission("föö");
  Assert.equal(
    submission.uri.spec,
    "https://bugzilla.mozilla.org/buglist.cgi",
    "URL is correct."
  );
  Assert.equal(
    decodePostData(submission.postData),
    "quicksearch=f%C3%B6%C3%B6&list_id=17442621",
    "Post Data is correct and encodes search terms using utf-8."
  );
  Assert.equal(
    engine.getSubmission("föö", SearchUtils.URL_TYPE.SUGGEST_JSON).uri.spec,
    "https://bugzilla.mozilla.org/suggest?q=f%C3%B6%C3%B6",
    "Suggest URL is correct and encodes search terms using utf-8."
  );
  Assert.equal(engine.alias, "bz", "Alias is correct.");

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(engine);
});

add_task(async function test_validation() {
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });
  let existingEngine = await SearchService.addUserEngine({
    name: "user",
    url: "https://example.com/user?q={searchTerms}&b=ff",
    alias: "u",
  });

  let doc = gBrowser.contentDocument;
  let addButton = doc.querySelector("moz-button#addEngineButton");
  let dialogWin = await openDialogWith(doc, () => addButton.click());

  let accept = dialogWin.document.querySelector("dialog").getButton("accept");
  let advanced = dialogWin.document.querySelector("dialog").getButton("extra1");
  let name = dialogWin.document.getElementById("engineName");
  let url = dialogWin.document.getElementById("engineUrl");
  let alias = dialogWin.document.getElementById("engineAlias");
  let suggestUrl = dialogWin.document.getElementById("suggestUrl");
  let postData = dialogWin.document.getElementById("enginePostData");

  Assert.ok(
    name.value == "" && url.value == "" && alias.value == "",
    "Everything is empty initially."
  );
  Assert.ok(accept.disabled, "Button is disabled initially.");
  await assertError(name, "add-engine-no-name");
  await assertError(url, "add-engine-no-url");
  await assertError(alias, null);
  await assertError(suggestUrl, null);

  setName("Example", dialogWin);
  setUrl("https://example.com/search?q=%s", dialogWin);
  await setAlias("abc", dialogWin);
  setSuggestUrl("https://example.com/search?q=%s", dialogWin);
  Assert.ok(!accept.disabled, "Button is enabled when everything is there.");

  info("Checking name.");
  setName("", dialogWin);
  await assertError(name, "add-engine-no-name");
  Assert.ok(accept.disabled, "Name is required.");

  setName(existingEngine.name, dialogWin);
  await assertError(name, "add-engine-name-exists");
  Assert.ok(accept.disabled, "Existing name is not allowed.");

  setName("Example", dialogWin);
  await assertError(name, null);
  Assert.ok(!accept.disabled, "Good name enables the button.");

  info("Checking search URL.");
  setUrl("", dialogWin);
  Assert.ok(accept.disabled, "URL is required.");
  await assertError(url, "add-engine-no-url");

  setUrl("javascript://%s", dialogWin);
  await assertError(url, "add-engine-invalid-protocol");
  Assert.ok(accept.disabled, "Javascript URLs are not allowed.");

  setUrl("not a url", dialogWin);
  await assertError(url, "add-engine-invalid-url");
  Assert.ok(accept.disabled, "Invalid URLs are not allowed.");

  setUrl("https://example.com/search?q=kitten", dialogWin);
  await assertError(url, "add-engine-missing-terms-url");
  Assert.ok(accept.disabled, "URLs without %s are not allowed.");

  setUrl("https://example.com/search?q=%s", dialogWin);
  await assertError(url, null);
  Assert.ok(!accept.disabled, "Good URL enables the button.");

  info("Checking alias.");
  await setAlias("", dialogWin);
  await assertError(alias, null);
  Assert.ok(!accept.disabled, "Alias is not required.");

  await setAlias(existingEngine.alias, dialogWin);
  await assertError(alias, "add-engine-keyword-exists");
  Assert.ok(accept.disabled, "Existing alias is not allowed.");

  await setAlias(existingEngine.alias.toUpperCase(), dialogWin);
  await assertError(alias, "add-engine-keyword-exists");
  Assert.ok(accept.disabled, "Alias duplicate test is case insensitive.");

  await setAlias("abc", dialogWin);
  await assertError(alias, null);
  Assert.ok(!accept.disabled, "Good alias enables the button.");

  advanced.click();
  info("Checking suggest URL.");
  setSuggestUrl("javascript://%s", dialogWin);
  await assertError(suggestUrl, "add-engine-invalid-protocol");
  Assert.ok(accept.disabled, "Javascript URLs are not allowed.");

  setSuggestUrl("not a url", dialogWin);
  await assertError(suggestUrl, "add-engine-invalid-url");
  Assert.ok(accept.disabled, "Invalid URLs are not allowed.");

  setSuggestUrl("https://example.com/search?q=kitten", dialogWin);
  await assertError(suggestUrl, "add-engine-missing-terms-url");
  Assert.ok(accept.disabled, "URLs without %s are not allowed.");

  setSuggestUrl("https://example.com/search?q=%s", dialogWin);
  await assertError(suggestUrl, null);
  Assert.ok(!accept.disabled, "Good URL enables the button.");

  info("Checking post data.");
  setUrl("https://example.com/search", dialogWin);
  await assertError(url, "add-engine-missing-terms-url");

  setPostData("test", dialogWin);
  await assertError(postData, "add-engine-missing-terms-post-data");
  await assertError(url, null);
  Assert.ok(accept.disabled, "Post data without %s is not allowed.");

  setUrl("https://example.com/search", dialogWin);
  setPostData("q=%s", dialogWin);
  await assertError(postData, null);
  await assertError(url, null);
  Assert.ok(!accept.disabled, "Post data containing %s enables the button.");

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(existingEngine);
});

add_task(async function test_editGetEngine() {
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });

  let doc = gBrowser.contentDocument;
  let engineList = doc.querySelector("moz-box-group#engineList");
  let engine = await SearchService.addUserEngine({
    name: "user",
    url: "https://example.com/user?q={searchTerms}&b=ff",
    alias: "u",
  });
  engine.changeUrl(
    SearchUtils.URL_TYPE.SUGGEST_JSON,
    "https://example.com/suggest?query={searchTerms}",
    null
  );
  await TestUtils.waitForTick();

  // Check if engine list contains new engine without reloading.
  let userEngineRow = [...engineList.children].find(
    r => r.children[0].description == "u"
  );
  Assert.notEqual(
    userEngineRow,
    undefined,
    "User engine is present in the engine list."
  );

  // Open the dialog and check values.
  let editButton = [...userEngineRow.children][0].children[0].children[0];
  let dialogWin = await openDialogWith(doc, () => editButton.click());
  let acceptButton = dialogWin.document
    .querySelector("dialog")
    .shadowRoot.querySelector('button[dlgtype="accept"]');

  Assert.equal(
    dialogWin.document.getElementById("titleContainer").style.display,
    "none",
    "Adjustable title is hidden in edit engine dialog."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineName").value,
    "user",
    "Name in dialog is correct."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineUrl").value,
    "https://example.com/user?q=%s&b=ff",
    "URL in dialog is correct."
  );
  Assert.ok(
    !dialogWin.document.getElementById("advanced-section").hidden,
    "Advanced section is visible"
  );
  Assert.equal(
    dialogWin.document.getElementById("enginePostData").value,
    "",
    "Post data input is empty."
  );
  Assert.equal(
    dialogWin.document.getElementById("suggestUrl").value,
    "https://example.com/suggest?query=%s",
    "Suggest URL in dialog is correct"
  );
  Assert.equal(
    dialogWin.document.getElementById("engineAlias").value,
    "u",
    "Alias in dialog is correct."
  );

  // Set new values.
  setName("Searchfox", dialogWin);
  setUrl("https://searchfox.org/mozilla-central/search", dialogWin);
  await setAlias("sf", dialogWin);
  setSuggestUrl("", dialogWin);

  dialogWin.document.querySelector("dialog").getButton("extra1").click();
  setPostData("q=%s&path=&case=false&regexp=false", dialogWin);

  // Save changes to engine.
  let promiseChanged = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.CHANGED,
    SearchUtils.TOPIC_ENGINE_MODIFIED,
    3
  );
  acceptButton.click();
  await promiseChanged;
  Assert.ok(true, "Got 3 change notifications.");

  // Open dialog again and check values.
  dialogWin = await openDialogWith(doc, () => editButton.click());
  Assert.equal(
    dialogWin.document.getElementById("engineName").value,
    "Searchfox",
    "Name in dialog reflects change"
  );
  Assert.equal(
    dialogWin.document.getElementById("engineUrl").value,
    "https://searchfox.org/mozilla-central/search",
    "URL in dialog reflects change"
  );
  Assert.equal(
    dialogWin.document.getElementById("engineAlias").value,
    "sf",
    "Alias in dialog reflects change"
  );
  Assert.ok(
    !dialogWin.document.getElementById("advanced-section").hidden,
    "Advanced section is still visible"
  );
  Assert.equal(
    dialogWin.document.getElementById("enginePostData").value,
    "q=%s&path=&case=false&regexp=false",
    "Post data reflects changes"
  );
  Assert.equal(
    dialogWin.document.getElementById("suggestUrl").value,
    "",
    "Suggest URL in dialog was removed"
  );

  // Check search engine object.
  let submission = engine.getSubmission("foo");
  Assert.equal(
    submission.uri.spec,
    "https://searchfox.org/mozilla-central/search",
    "Search URL reflects changes"
  );
  Assert.equal(
    decodePostData(submission.postData),
    "q=foo&path=&case=false&regexp=false",
    "Engine was converted into a POST engine."
  );
  submission = engine.getSubmission("foo", SearchUtils.URL_TYPE.SUGGEST_JSON);
  Assert.ok(!submission, "Suggest URL was removed");

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(engine);
});

add_task(async function test_editPostEngine() {
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });

  let doc = gBrowser.contentDocument;
  let engineList = doc.querySelector("moz-box-group#engineList");

  let params = new URLSearchParams();
  params.append("q", "{searchTerms}");
  let engine = await SearchService.addUserEngine({
    name: "user post",
    url: "https://example.com/user",
    params,
    method: "POST",
    alias: "u",
  });
  await TestUtils.waitForTick();

  let userEngineRow = [...engineList.children].find(
    r => r.children[0].description == "u"
  );
  Assert.notEqual(
    userEngineRow,
    undefined,
    "User engine is present in the engine list."
  );
  let editButton = [...userEngineRow.children][0].children[0].children[0];

  // Open the dialog.
  let dialogWin = await openDialogWith(doc, () => editButton.click());
  Assert.equal(
    dialogWin.document.getElementById("engineName").value,
    "user post",
    "Name in dialog is correct."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineUrl").value,
    "https://example.com/user",
    "URL in dialog is correct."
  );
  Assert.ok(
    !dialogWin.document.getElementById("advanced-section").hidden,
    "Advanced section is visible."
  );
  Assert.equal(
    dialogWin.document.getElementById("enginePostData").value,
    "q=%s",
    "Post data in dialog is correct."
  );
  Assert.equal(
    dialogWin.document.getElementById("suggestUrl").value,
    "",
    "Suggest URL in dialog is empty."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineAlias").value,
    "u",
    "Alias in dialog is correct."
  );

  // Set new values.
  setName("Searchfox", dialogWin);
  setUrl("https://searchfox.org/mozilla-central/search", dialogWin);
  setPostData("q=%s&path=&case=false&regexp=false", dialogWin);
  setSuggestUrl("https://searchfox.org/suggest/%s", dialogWin);
  await setAlias("sf", dialogWin);

  // Save changes to engine.
  let promiseChanged = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.CHANGED,
    SearchUtils.TOPIC_ENGINE_MODIFIED,
    4
  );
  EventUtils.synthesizeKey("VK_RETURN", {}, dialogWin);
  await promiseChanged;
  Assert.ok(true, "Got 4 change notifications.");

  // Open dialog again and check values.
  dialogWin = await openDialogWith(doc, () => editButton.click());
  Assert.equal(
    dialogWin.document.getElementById("engineName").value,
    "Searchfox",
    "Name in dialog reflects change."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineUrl").value,
    "https://searchfox.org/mozilla-central/search",
    "URL in dialog reflects changes."
  );
  Assert.equal(
    dialogWin.document.getElementById("enginePostData").value,
    "q=%s&path=&case=false&regexp=false",
    "Post data in dialog reflects changes."
  );
  Assert.equal(
    dialogWin.document.getElementById("suggestUrl").value,
    "https://searchfox.org/suggest/%s",
    "Suggest URL in dialog reflects changes."
  );
  Assert.equal(
    dialogWin.document.getElementById("engineAlias").value,
    "sf",
    "Alias in dialog reflects changes."
  );

  // Check values of search engine object.
  Assert.equal(
    engine.name,
    "Searchfox",
    "Name of search engine object was updated."
  );
  let submission = engine.getSubmission("foo");
  Assert.equal(
    submission.uri.spec,
    "https://searchfox.org/mozilla-central/search",
    "Submission URL reflects changes."
  );
  Assert.equal(
    decodePostData(submission.postData),
    "q=foo&path=&case=false&regexp=false",
    "Submission post data reflects changes"
  );
  submission = engine.getSubmission("foo", SearchUtils.URL_TYPE.SUGGEST_JSON);
  Assert.equal(
    submission.uri.spec,
    "https://searchfox.org/suggest/foo",
    "Submission URL reflects changes."
  );
  Assert.equal(submission.postData, null, "Submission URL is still GET.");
  Assert.equal(
    engine.alias,
    "sf",
    "Alias of search engine object was updated."
  );

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(engine);
});

add_task(async function test_icon() {
  // Set up favicon.
  let pageUrl = "https://search.test/";
  let iconUrl = "https://search.test/favicon.svg";
  let dataURL = "data:image/svg+xml;base64,PHN2Zy8+";

  await PlacesTestUtils.addVisits({ uri: new URL(pageUrl).URI });
  await PlacesTestUtils.setFaviconForPage(pageUrl, iconUrl, dataURL);

  // Open Settings.
  await openPreferencesViaOpenPreferencesAPI("search", {
    leaveOpen: true,
  });

  let doc = gBrowser.contentDocument;
  let engineList = doc.querySelector("moz-box-group#engineList");

  // Add engine and check favicon.
  let addButton = doc.querySelector("moz-button#addEngineButton");
  let dialogWin = await openDialogWith(doc, () => addButton.click());
  setName("Bugzilla", dialogWin);
  setUrl("https://search.test/search?q=%s", dialogWin);

  let promiseIcon = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.ICON_CHANGED,
    SearchUtils.TOPIC_ENGINE_MODIFIED
  );
  dialogWin.document.querySelector("dialog").getButton("accept").click();
  let engine = await promiseIcon;

  Assert.ok(true, "Icon was added");
  Assert.equal(await engine.getIconURL(), dataURL, "Icon is correct");

  // Change favicon.
  dataURL = "data:image/svg+xml;base64,PHN2Zz48Y2lyY2xlIHI9IjEiLz48L3N2Zz4=";
  await PlacesTestUtils.setFaviconForPage(pageUrl, iconUrl, dataURL);

  // Edit engine and check favicon.
  let engineRow = [...engineList.children].find(
    row => row.config.controlAttrs.label == "Bugzilla"
  );
  let editButton = [
    ...engineRow.children[0].getElementsByTagName("moz-button"),
  ].find(elem => elem.id.startsWith("editEngine"));
  dialogWin = await openDialogWith(doc, () => editButton.click());

  promiseIcon = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.ICON_CHANGED,
    SearchUtils.TOPIC_ENGINE_MODIFIED
  );
  dialogWin.document.querySelector("dialog").getButton("accept").click();
  await promiseIcon;

  Assert.ok(true, "Icon was changed");
  Assert.equal(await engine.getIconURL(), dataURL, "New icon is correct");

  // Clean up.
  BrowserTestUtils.removeTab(gBrowser.selectedTab);
  await SearchService.removeEngine(engine);
  PlacesUtils.favicons.expireAllFavicons();
  await PlacesUtils.history.clear();
});

/**
 * Checks the error label of an input of the add engine dialog.
 *
 * @param {HTMLInputElement} elt
 *   The element whose error should be checked
 * @param {?string} error
 *   The l10n id of the expected error message or null if no error is expected.
 */
async function assertError(elt, error = null) {
  let errorLabel = elt.parentElement.querySelector(".error-label");

  if (error) {
    let msg = await document.l10n.formatValue(error);
    Assert.equal(errorLabel.textContent, msg);
  } else {
    Assert.equal(errorLabel.textContent, "valid");
  }
}

async function openDialogWith(doc, fn) {
  info("Opening dialog.");
  let dialogLoaded = TestUtils.topicObserved("subdialog-loaded");
  await TestUtils.waitForTick();
  await fn();
  let [dialogWin] = await dialogLoaded;
  await doc.documentGlobal.gSubDialog.dialogs[0]._dialogReady;
  Assert.ok(true, "Engine dialog opened");
  return dialogWin;
}

function setName(value, win) {
  fillTextField("engineName", value, win);
}

function setUrl(value, win) {
  fillTextField("engineUrl", value, win);
}

function setSuggestUrl(value, win) {
  fillTextField("suggestUrl", value, win);
}

function setPostData(value, win) {
  fillTextField("enginePostData", value, win);
}

async function setAlias(value, win) {
  fillTextField("engineAlias", value, win);
  await TestUtils.waitForTick();
}

function fillTextField(id, text, win) {
  let elt = win.document.getElementById(id);
  elt.focus();
  elt.select();
  EventUtils.synthesizeKey("a", { metaKey: true }, win);
  EventUtils.synthesizeKey("KEY_Backspace", {}, win);

  for (let c of text.split("")) {
    EventUtils.synthesizeKey(c, {}, win);
  }
}

function decodePostData(postData) {
  let binaryStream = Cc["@mozilla.org/binaryinputstream;1"].createInstance(
    Ci.nsIBinaryInputStream
  );
  binaryStream.setInputStream(postData.data);

  return binaryStream
    .readBytes(binaryStream.available())
    .replace("searchTerms", "%s");
}
