/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* globals NetMonitorController, NetMonitorView, gNetwork */

"use strict";

const Services = require("Services");
const { Task } = require("devtools/shared/task");
const { Curl } = require("devtools/client/shared/curl");
const { gDevTools } = require("devtools/client/framework/devtools");
const Menu = require("devtools/client/framework/menu");
const MenuItem = require("devtools/client/framework/menu-item");
const { L10N } = require("./l10n");
const { formDataURI, getFormDataSections } = require("./request-utils");

loader.lazyRequireGetter(this, "HarExporter",
  "devtools/client/netmonitor/har/har-exporter", true);

loader.lazyServiceGetter(this, "clipboardHelper",
  "@mozilla.org/widget/clipboardhelper;1", "nsIClipboardHelper");

loader.lazyRequireGetter(this, "NetworkHelper",
  "devtools/shared/webconsole/network-helper");

function RequestListContextMenu() {}

RequestListContextMenu.prototype = {
  get selectedItem() {
    return NetMonitorView.RequestsMenu.selectedItem;
  },

  get items() {
    return NetMonitorView.RequestsMenu.items;
  },

  /**
   * Handle the context menu opening. Hide items if no request is selected.
   * Since visible attribute only accept boolean value but the method call may
   * return undefined, we use !! to force convert any object to boolean
   */
  open({ screenX = 0, screenY = 0 } = {}) {
    let selectedItem = this.selectedItem;

    let menu = new Menu();
    menu.append(new MenuItem({
      id: "request-menu-context-copy-url",
      label: L10N.getStr("netmonitor.context.copyUrl"),
      accesskey: L10N.getStr("netmonitor.context.copyUrl.accesskey"),
      visible: !!selectedItem,
      click: () => this.copyUrl(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-url-params",
      label: L10N.getStr("netmonitor.context.copyUrlParams"),
      accesskey: L10N.getStr("netmonitor.context.copyUrlParams.accesskey"),
      visible: !!(selectedItem &&
               NetworkHelper.nsIURL(selectedItem.attachment.url).query),
      click: () => this.copyUrlParams(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-post-data",
      label: L10N.getStr("netmonitor.context.copyPostData"),
      accesskey: L10N.getStr("netmonitor.context.copyPostData.accesskey"),
      visible: !!(selectedItem && selectedItem.attachment.requestPostData),
      click: () => this.copyPostData(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-as-curl",
      label: L10N.getStr("netmonitor.context.copyAsCurl"),
      accesskey: L10N.getStr("netmonitor.context.copyAsCurl.accesskey"),
      visible: !!(selectedItem && selectedItem.attachment),
      click: () => this.copyAsCurl(),
    }));

    menu.append(new MenuItem({
      type: "separator",
      visible: !!selectedItem,
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-request-headers",
      label: L10N.getStr("netmonitor.context.copyRequestHeaders"),
      accesskey: L10N.getStr("netmonitor.context.copyRequestHeaders.accesskey"),
      visible: !!(selectedItem && selectedItem.attachment.requestHeaders),
      click: () => this.copyRequestHeaders(),
    }));

    menu.append(new MenuItem({
      id: "response-menu-context-copy-response-headers",
      label: L10N.getStr("netmonitor.context.copyResponseHeaders"),
      accesskey: L10N.getStr("netmonitor.context.copyResponseHeaders.accesskey"),
      visible: !!(selectedItem && selectedItem.attachment.responseHeaders),
      click: () => this.copyResponseHeaders(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-response",
      label: L10N.getStr("netmonitor.context.copyResponse"),
      accesskey: L10N.getStr("netmonitor.context.copyResponse.accesskey"),
      visible: !!(selectedItem &&
               selectedItem.attachment.responseContent &&
               selectedItem.attachment.responseContent.content.text &&
               selectedItem.attachment.responseContent.content.text.length !== 0),
      click: () => this.copyResponse(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-image-as-data-uri",
      label: L10N.getStr("netmonitor.context.copyImageAsDataUri"),
      accesskey: L10N.getStr("netmonitor.context.copyImageAsDataUri.accesskey"),
      visible: !!(selectedItem &&
               selectedItem.attachment.responseContent &&
               selectedItem.attachment.responseContent.content
                 .mimeType.includes("image/")),
      click: () => this.copyImageAsDataUri(),
    }));

    menu.append(new MenuItem({
      type: "separator",
      visible: !!selectedItem,
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-copy-all-as-har",
      label: L10N.getStr("netmonitor.context.copyAllAsHar"),
      accesskey: L10N.getStr("netmonitor.context.copyAllAsHar.accesskey"),
      visible: !!this.items.length,
      click: () => this.copyAllAsHar(),
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-save-all-as-har",
      label: L10N.getStr("netmonitor.context.saveAllAsHar"),
      accesskey: L10N.getStr("netmonitor.context.saveAllAsHar.accesskey"),
      visible: !!this.items.length,
      click: () => this.saveAllAsHar(),
    }));

    menu.append(new MenuItem({
      type: "separator",
      visible: !!selectedItem,
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-resend",
      label: L10N.getStr("netmonitor.context.editAndResend"),
      accesskey: L10N.getStr("netmonitor.context.editAndResend.accesskey"),
      visible: !!(NetMonitorController.supportsCustomRequest &&
               selectedItem &&
               !selectedItem.attachment.isCustom),
      click: () => NetMonitorView.RequestsMenu.cloneSelectedRequest(),
    }));

    menu.append(new MenuItem({
      type: "separator",
      visible: !!selectedItem,
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-newtab",
      label: L10N.getStr("netmonitor.context.newTab"),
      accesskey: L10N.getStr("netmonitor.context.newTab.accesskey"),
      visible: !!selectedItem,
      click: () => this.openRequestInTab()
    }));

    menu.append(new MenuItem({
      id: "request-menu-context-perf",
      label: L10N.getStr("netmonitor.context.perfTools"),
      accesskey: L10N.getStr("netmonitor.context.perfTools.accesskey"),
      visible: !!NetMonitorController.supportsPerfStats,
      click: () => NetMonitorView.toggleFrontendMode()
    }));

    menu.popup(screenX, screenY, NetMonitorController._toolbox);
    return menu;
  },

  /**
   * Opens selected item in a new tab.
   */
  openRequestInTab() {
    let win = Services.wm.getMostRecentWindow(gDevTools.chromeWindowType);
    let { url } = this.selectedItem.attachment;
    win.openUILinkIn(url, "tab", { relatedToCurrent: true });
  },

  /**
   * Copy the request url from the currently selected item.
   */
  copyUrl() {
    clipboardHelper.copyString(this.selectedItem.attachment.url);
  },

  /**
   * Copy the request url query string parameters from the currently
   * selected item.
   */
  copyUrlParams() {
    let { url } = this.selectedItem.attachment;
    let params = NetworkHelper.nsIURL(url).query.split("&");
    let string = params.join(Services.appinfo.OS === "WINNT" ? "\r\n" : "\n");
    clipboardHelper.copyString(string);
  },

  /**
   * Copy the request form data parameters (or raw payload) from
   * the currently selected item.
   */
  copyPostData: Task.async(function* () {
    let selected = this.selectedItem.attachment;

    // Try to extract any form data parameters.
    let formDataSections = yield getFormDataSections(
      selected.requestHeaders,
      selected.requestHeadersFromUploadStream,
      selected.requestPostData,
      gNetwork.getString.bind(gNetwork));

    let params = [];
    formDataSections.forEach(section => {
      let paramsArray = NetworkHelper.parseQueryString(section);
      if (paramsArray) {
        params = [...params, ...paramsArray];
      }
    });

    let string = params
      .map(param => param.name + (param.value ? "=" + param.value : ""))
      .join(Services.appinfo.OS === "WINNT" ? "\r\n" : "\n");

    // Fall back to raw payload.
    if (!string) {
      let postData = selected.requestPostData.postData.text;
      string = yield gNetwork.getString(postData);
      if (Services.appinfo.OS !== "WINNT") {
        string = string.replace(/\r/g, "");
      }
    }

    clipboardHelper.copyString(string);
  }),

  /**
   * Copy a cURL command from the currently selected item.
   */
  copyAsCurl: Task.async(function* () {
    let selected = this.selectedItem.attachment;

    // Create a sanitized object for the Curl command generator.
    let data = {
      url: selected.url,
      method: selected.method,
      headers: [],
      httpVersion: selected.httpVersion,
      postDataText: null
    };

    // Fetch header values.
    for (let { name, value } of selected.requestHeaders.headers) {
      let text = yield gNetwork.getString(value);
      data.headers.push({ name: name, value: text });
    }

    // Fetch the request payload.
    if (selected.requestPostData) {
      let postData = selected.requestPostData.postData.text;
      data.postDataText = yield gNetwork.getString(postData);
    }

    clipboardHelper.copyString(Curl.generateCommand(data));
  }),

  /**
   * Copy the raw request headers from the currently selected item.
   */
  copyRequestHeaders() {
    let selected = this.selectedItem.attachment;
    let rawHeaders = selected.requestHeaders.rawHeaders.trim();
    if (Services.appinfo.OS !== "WINNT") {
      rawHeaders = rawHeaders.replace(/\r/g, "");
    }
    clipboardHelper.copyString(rawHeaders);
  },

  /**
   * Copy the raw response headers from the currently selected item.
   */
  copyResponseHeaders() {
    let selected = this.selectedItem.attachment;
    let rawHeaders = selected.responseHeaders.rawHeaders.trim();
    if (Services.appinfo.OS !== "WINNT") {
      rawHeaders = rawHeaders.replace(/\r/g, "");
    }
    clipboardHelper.copyString(rawHeaders);
  },

  /**
   * Copy image as data uri.
   */
  copyImageAsDataUri() {
    let selected = this.selectedItem.attachment;
    let { mimeType, text, encoding } = selected.responseContent.content;

    gNetwork.getString(text).then(string => {
      let data = formDataURI(mimeType, encoding, string);
      clipboardHelper.copyString(data);
    });
  },

  /**
   * Copy response data as a string.
   */
  copyResponse() {
    let selected = this.selectedItem.attachment;
    let text = selected.responseContent.content.text;

    gNetwork.getString(text).then(string => {
      clipboardHelper.copyString(string);
    });
  },

  /**
   * Copy HAR from the network panel content to the clipboard.
   */
  copyAllAsHar() {
    let options = this.getDefaultHarOptions();
    return HarExporter.copy(options);
  },

  /**
   * Save HAR from the network panel content to a file.
   */
  saveAllAsHar() {
    let options = this.getDefaultHarOptions();
    return HarExporter.save(options);
  },

  getDefaultHarOptions() {
    let form = NetMonitorController._target.form;
    let title = form.title || form.url;

    return {
      getString: gNetwork.getString.bind(gNetwork),
      view: NetMonitorView.RequestsMenu,
      items: NetMonitorView.RequestsMenu.items,
      title: title
    };
  }
};

module.exports = RequestListContextMenu;
