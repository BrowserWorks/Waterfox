/* globals browser, AppConstants, Services, ExtensionAPI, ExtensionCommon */

"use strict";

const { StoreHandler } = ChromeUtils.import(
  "resource:///modules/StoreHandler.jsm"
);

this.total = class extends ExtensionAPI {
  getAPI(context) {
    return {
      wf: {
        attemptInstallChromeExtension(uri) {
          try {
            new StoreHandler().attemptInstall({ spec: uri });
          } catch (ex) {
            Cu.reportError(ex);
          }
        },
      },
    };
  }
};
