/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const kSearchEngineID = "addEngineWithDetails_test_engine";
const kSearchEngineURL = "http://example.com/?search={searchTerms}";
const kSearchSuggestURL = "http://example.com/?suggest={searchTerms}";
const kIconURL =
  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==";
const kDescription = "Test Description";
const kAlias = "alias_foo";
const kSearchTerm = "foo";
const kExtensionID = "test@example.com";
const URLTYPE_SUGGEST_JSON = "application/x-suggestions+json";
const kSearchEnginePOSTID = "addEngineWithDetails_post_test_engine";
const kSearchEnginePOSTURL = "http://example.com/";
const kSearchEnginePOSTData = "search={searchTerms}&extra=more";

add_task(async function setup() {
  await AddonTestUtils.promiseStartupManager();
});

add_task(async function test_addEngineWithDetails() {
  Assert.ok(!Services.search.isInitialized);

  await Services.search.addEngineWithDetails(kSearchEngineID, {
    template: kSearchEngineURL,
    description: kDescription,
    iconURL: kIconURL,
    suggestURL: kSearchSuggestURL,
    alias: "alias_foo",
    extensionID: kExtensionID,
  });

  // An engine added with addEngineWithDetails should have a load path, even
  // though we can't point to a specific file.
  let engine = Services.search.getEngineByName(kSearchEngineID);
  Assert.equal(
    engine.wrappedJSObject._loadPath,
    "[other]addEngineWithDetails:" + kExtensionID
  );
  Assert.equal(engine.description, kDescription);
  Assert.equal(engine.iconURI.spec, kIconURL);
  Assert.equal(engine.alias, kAlias);

  // Set the engine as default; this should set a loadPath verification hash,
  // which should ensure we don't show the search reset prompt.
  await Services.search.setDefault(engine);

  let expectedURL = kSearchEngineURL.replace("{searchTerms}", kSearchTerm);
  let submission = (await Services.search.getDefault()).getSubmission(
    kSearchTerm,
    null,
    "searchbar"
  );
  Assert.equal(submission.uri.spec, expectedURL);
  let expectedSuggestURL = kSearchSuggestURL.replace(
    "{searchTerms}",
    kSearchTerm
  );
  let submissionSuggest = (await Services.search.getDefault()).getSubmission(
    kSearchTerm,
    URLTYPE_SUGGEST_JSON
  );
  Assert.equal(submissionSuggest.uri.spec, expectedSuggestURL);
});

add_task(async function test_addEngineWithDetailsPOST() {
  Assert.ok(Services.search.isInitialized);

  await Services.search.addEngineWithDetails(kSearchEnginePOSTID, {
    template: kSearchEnginePOSTURL,
    method: "POST",
    postData: kSearchEnginePOSTData,
  });

  let engine = Services.search.getEngineByName(kSearchEnginePOSTID);

  let expectedPOSTData = kSearchEnginePOSTData.replace(
    "{searchTerms}",
    kSearchTerm
  );
  let submission = engine.getSubmission(kSearchTerm, null, "searchbar");
  Assert.equal(submission.uri.spec, kSearchEnginePOSTURL);
  let sis = Cc["@mozilla.org/scriptableinputstream;1"].createInstance(
    Ci.nsIScriptableInputStream
  );
  sis.init(submission.postData);
  let data = sis.read(submission.postData.available());
  Assert.equal(data, expectedPOSTData);
});
