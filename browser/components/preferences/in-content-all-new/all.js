/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */

var gAllPane = {
    init() {
        // Notify observers that the UI is now ready
        Services.obs.notifyObservers(window, "all-pane-loaded");
        this.setInitialized();
    },
    initAll() {
        var paneGeneral = document.querySelectorAll('[data-category="paneGeneral"]');
        for (var i = 0; i < paneGeneral.length; i++)
        {
            paneGeneral[i].hidden = "";
        }

        var paneHome = document.querySelectorAll('[data-category="paneHome"]');
        for (var i = 0; i < paneHome.length; i++)
        {
            paneHome[i].hidden = "";
        }

        var paneTabs = document.querySelectorAll('[data-category="paneTabs"]');
        for (var i = 0; i < paneTabs.length; i++)
        {
            paneTabs[i].hidden = "";
        }

        var paneAppearance = document.querySelectorAll('[data-category="paneAppearance"]');
        for (var i = 0; i < paneAppearance.length; i++)
        {
            paneAppearance[i].hidden = "";
        }

        var paneDownloads = document.querySelectorAll('[data-category="paneDownloads"]');
        for (var i = 0; i < paneDownloads.length; i++)
        {
            paneDownloads[i].hidden = "";
        }

        var paneWebpages = document.querySelectorAll('[data-category="paneWebpages"]');
        for (var i = 0; i < paneWebpages.length; i++)
        {
            paneWebpages[i].hidden = "";
        }

        var paneSearch = document.querySelectorAll('[data-category="paneSearch"]');
        for (var i = 0; i < paneSearch.length; i++)
        {
            paneSearch[i].hidden = "";
        }

        var panePrivacy = document.querySelectorAll('[data-category="panePrivacy"]');
        for (var i = 0; i < panePrivacy.length; i++)
        {
            panePrivacy[i].hidden = "";
        }

        var paneSync = document.querySelectorAll('[data-category="paneSync"]');
        for (var i = 0; i < paneSync.length; i++)
        {
            paneSync[i].hidden = "";
        }
    }
};

gAllPane.initialized = new Promise(res => {
    gAllPane.setInitialized = res;
});
