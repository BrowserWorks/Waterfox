let { Services } = Cu.import("resource://gre/modules/Services.jsm", {});

add_task(async function test_windowlessBrowserTroubleshootCrash() {
  let webNav = Services.appShell.createWindowlessBrowser(false);

  let onLoaded = new Promise((resolve, reject) => {
    let docShell = webNav.QueryInterface(Ci.nsIInterfaceRequestor)
                         .getInterface(Ci.nsIDocShell);
    let listener = {
      observe(contentWindow, topic, data) {
        let observedDocShell = contentWindow.QueryInterface(Ci.nsIInterfaceRequestor)
                                            .getInterface(Ci.nsIWebNavigation)
                                            .QueryInterface(Ci.nsIDocShellTreeItem)
                                            .sameTypeRootTreeItem
                                            .QueryInterface(Ci.nsIDocShell);
          if (docShell === observedDocShell) {
            Services.obs.removeObserver(listener, "content-document-global-created");
            resolve();
          }
        }
    }
    Services.obs.addObserver(listener, "content-document-global-created");
  });
  webNav.loadURI("about:blank", 0, null, null, null);

  await onLoaded;

  let winUtils = webNav.document.defaultView.
                        QueryInterface(Ci.nsIInterfaceRequestor).
                        getInterface(Ci.nsIDOMWindowUtils);
  try {
    is(winUtils.layerManagerType, "Basic", "windowless browser's layerManagerType should be 'Basic'");
  } catch (e) {
    // The windowless browser may not have a layermanager at all yet, and that's ok.
    // The troubleshooting code similarly skips over windows with no layer managers.
  }
  ok(true, "not crashed");

  var Troubleshoot = Cu.import("resource://gre/modules/Troubleshoot.jsm", {}).Troubleshoot;
  var data = await new Promise((resolve, reject) => {
    Troubleshoot.snapshot((data) => {
      resolve(data);
    });
  });

  ok(data.graphics.windowLayerManagerType !== "None", "windowless browser window should not set windowLayerManagerType to 'None'");

  webNav.close();
});
