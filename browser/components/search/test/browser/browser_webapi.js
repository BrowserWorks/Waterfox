var ROOT = getRootDirectory(gTestPath).replace(
  "chrome://mochitests/content",
  "http://example.com"
);
const searchBundle = Services.strings.createBundle(
  "chrome://global/locale/search/search.properties"
);
const brandBundle = Services.strings.createBundle(
  "chrome://branding/locale/brand.properties"
);
const brandName = brandBundle.GetStringFromName("brandShortName");

function getString(key, ...params) {
  return searchBundle.formatStringFromName(key, params);
}

function AddSearchProvider(...args) {
  return BrowserTestUtils.addTab(
    gBrowser,
    ROOT + "webapi.html?" + encodeURIComponent(JSON.stringify(args))
  );
}

function promiseDialogOpened() {
  return new Promise((resolve, reject) => {
    Services.wm.addListener({
      onOpenWindow(xulWin) {
        Services.wm.removeListener(this);

        let win = xulWin.docShell.domWindow;
        waitForFocus(() => {
          if (win.location == "chrome://global/content/commonDialog.xhtml") {
            resolve(win);
          } else {
            reject();
          }
        }, win);
      },
    });
  });
}

add_task(async function test_working() {
  gBrowser.selectedTab = AddSearchProvider(ROOT + "testEngine.xml");

  let dialog = await promiseDialogOpened();
  is(
    dialog.args.promptType,
    "confirmEx",
    "Should see the confirmation dialog."
  );
  is(
    dialog.args.text,
    getString("addEngineConfirmation", "Foo", "example.com"),
    "Should have seen the right install message"
  );
  dialog.document.getElementById("commonDialog").cancelDialog();

  gBrowser.removeCurrentTab();
});

add_task(async function test_HTTP() {
  gBrowser.selectedTab = AddSearchProvider(
    ROOT.replace("http:", "HTTP:") + "testEngine.xml"
  );

  let dialog = await promiseDialogOpened();
  is(
    dialog.args.promptType,
    "confirmEx",
    "Should see the confirmation dialog."
  );
  is(
    dialog.args.text,
    getString("addEngineConfirmation", "Foo", "example.com"),
    "Should have seen the right install message"
  );
  dialog.document.getElementById("commonDialog").cancelDialog();

  gBrowser.removeCurrentTab();
});

add_task(async function test_relative() {
  gBrowser.selectedTab = AddSearchProvider("testEngine.xml");

  let dialog = await promiseDialogOpened();
  is(
    dialog.args.promptType,
    "confirmEx",
    "Should see the confirmation dialog."
  );
  is(
    dialog.args.text,
    getString("addEngineConfirmation", "Foo", "example.com"),
    "Should have seen the right install message"
  );
  dialog.document.getElementById("commonDialog").cancelDialog();

  gBrowser.removeCurrentTab();
});

add_task(async function test_invalid() {
  let url = "z://foobar";
  gBrowser.selectedTab = AddSearchProvider(url);

  let dialog = await promiseDialogOpened();
  is(dialog.args.promptType, "alert", "Should see the alert dialog.");
  is(
    dialog.args.text,
    getString("error_invalid_engine_msg2", brandName, url),
    "Should have seen the right error message"
  );
  dialog.document.getElementById("commonDialog").acceptDialog();

  gBrowser.removeCurrentTab();
});

add_task(async function test_missing() {
  let url = ROOT + "foobar.xml";
  gBrowser.selectedTab = AddSearchProvider(url);

  let dialog = await promiseDialogOpened();
  is(dialog.args.promptType, "alert", "Should see the alert dialog.");
  is(
    dialog.args.text,
    getString("error_loading_engine_msg2", brandName, url),
    "Should have seen the right error message"
  );
  dialog.document.getElementById("commonDialog").acceptDialog();

  gBrowser.removeCurrentTab();
});

add_task(async function test_missing_namespace() {
  let url = ROOT + "testEngine_missing_namespace.xml";
  gBrowser.selectedTab = AddSearchProvider(url);

  let dialog = await promiseDialogOpened();
  is(dialog.args.promptType, "alert", "Should see the alert dialog.");
  is(
    dialog.args.text,
    getString("error_invalid_engine_msg2", brandName, url),
    "Should have seen the right error message"
  );
  dialog.document.getElementById("commonDialog").acceptDialog();

  gBrowser.removeCurrentTab();
});
