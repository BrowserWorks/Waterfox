/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

Components.utils.import("resource:///modules/SitePermissions.jsm");
Components.utils.import("resource://gre/modules/BrowserUtils.jsm");

const nsIQuotaManagerService = Components.interfaces.nsIQuotaManagerService;

var gPermURI;
var gPermPrincipal;
var gUsageRequest;

// Array of permissionIDs sorted alphabetically by label.
var gPermissions = SitePermissions.listPermissions().sort((a, b) => {
  let firstLabel = SitePermissions.getPermissionLabel(a);
  let secondLabel = SitePermissions.getPermissionLabel(b);
  return firstLabel.localeCompare(secondLabel);
});
gPermissions.push("plugins");

var permissionObserver = {
  observe: function (aSubject, aTopic, aData)
  {
    if (aTopic == "perm-changed") {
      var permission = aSubject.QueryInterface(Components.interfaces.nsIPermission);
      if (permission.matchesURI(gPermURI, true)) {
        if (gPermissions.indexOf(permission.type) > -1)
          initRow(permission.type);
        else if (permission.type.startsWith("plugin"))
          setPluginsRadioState();
      }
    }
  }
};

function onLoadPermission(uri, principal)
{
  var permTab = document.getElementById("permTab");
  if (SitePermissions.isSupportedURI(uri)) {
    gPermURI = uri;
    gPermPrincipal = principal;
    var hostText = document.getElementById("hostText");
    hostText.value = gPermURI.prePath;

    for (var i of gPermissions)
      initRow(i);
    var os = Components.classes["@mozilla.org/observer-service;1"]
                       .getService(Components.interfaces.nsIObserverService);
    os.addObserver(permissionObserver, "perm-changed", false);
    onUnloadRegistry.push(onUnloadPermission);
    permTab.hidden = false;
  }
  else
    permTab.hidden = true;
}

function onUnloadPermission()
{
  var os = Components.classes["@mozilla.org/observer-service;1"]
                     .getService(Components.interfaces.nsIObserverService);
  os.removeObserver(permissionObserver, "perm-changed");

  if (gUsageRequest) {
    gUsageRequest.cancel();
    gUsageRequest = null;
  }
}

function initRow(aPartId)
{
  if (aPartId == "plugins") {
    initPluginsRow();
    return;
  }

  createRow(aPartId);

  var checkbox = document.getElementById(aPartId + "Def");
  var command  = document.getElementById("cmd_" + aPartId + "Toggle");
  var perm = SitePermissions.get(gPermURI, aPartId);

  if (perm) {
    checkbox.checked = false;
    command.removeAttribute("disabled");
  }
  else {
    checkbox.checked = true;
    command.setAttribute("disabled", "true");
    perm = SitePermissions.getDefault(aPartId);
  }
  setRadioState(aPartId, perm);

  if (aPartId == "indexedDB") {
    initIndexedDBRow();
  }
}

function createRow(aPartId) {
  let rowId = "perm-" + aPartId + "-row";
  if (document.getElementById(rowId))
    return;

  let commandId = "cmd_" + aPartId + "Toggle";
  let labelId = "perm-" + aPartId + "-label";
  let radiogroupId = aPartId + "RadioGroup";

  let command = document.createElement("command");
  command.setAttribute("id", commandId);
  command.setAttribute("oncommand", "onRadioClick('" + aPartId + "');");
  document.getElementById("pageInfoCommandSet").appendChild(command);

  let row = document.createElement("vbox");
  row.setAttribute("id", rowId);
  row.setAttribute("class", "permission");

  let label = document.createElement("label");
  label.setAttribute("id", labelId);
  label.setAttribute("control", radiogroupId);
  label.setAttribute("value", SitePermissions.getPermissionLabel(aPartId));
  label.setAttribute("class", "permissionLabel");
  row.appendChild(label);

  let controls = document.createElement("hbox");
  controls.setAttribute("role", "group");
  controls.setAttribute("aria-labelledby", labelId);

  let checkbox = document.createElement("checkbox");
  checkbox.setAttribute("id", aPartId + "Def");
  checkbox.setAttribute("oncommand", "onCheckboxClick('" + aPartId + "');");
  checkbox.setAttribute("label", gBundle.getString("permissions.useDefault"));
  controls.appendChild(checkbox);

  let spacer = document.createElement("spacer");
  spacer.setAttribute("flex", "1");
  controls.appendChild(spacer);

  let radiogroup = document.createElement("radiogroup");
  radiogroup.setAttribute("id", radiogroupId);
  radiogroup.setAttribute("orient", "horizontal");
  for (let state of SitePermissions.getAvailableStates(aPartId)) {
    let radio = document.createElement("radio");
    radio.setAttribute("id", aPartId + "#" + state);
    radio.setAttribute("label", SitePermissions.getStateLabel(aPartId, state));
    radio.setAttribute("command", commandId);
    radiogroup.appendChild(radio);
  }
  controls.appendChild(radiogroup);

  row.appendChild(controls);

  document.getElementById("permList").appendChild(row);
}

function onCheckboxClick(aPartId)
{
  var command  = document.getElementById("cmd_" + aPartId + "Toggle");
  var checkbox = document.getElementById(aPartId + "Def");
  if (checkbox.checked) {
    SitePermissions.remove(gPermURI, aPartId);
    command.setAttribute("disabled", "true");
    var perm = SitePermissions.getDefault(aPartId);
    setRadioState(aPartId, perm);
  }
  else {
    onRadioClick(aPartId);
    command.removeAttribute("disabled");
  }
}

function onPluginRadioClick(aEvent) {
  onRadioClick(aEvent.originalTarget.getAttribute("id").split('#')[0]);
}

function onRadioClick(aPartId)
{
  var radioGroup = document.getElementById(aPartId + "RadioGroup");
  var id = radioGroup.selectedItem.id;
  var permission = id.split('#')[1];
  SitePermissions.set(gPermURI, aPartId, permission);
}

function setRadioState(aPartId, aValue)
{
  var radio = document.getElementById(aPartId + "#" + aValue);
  if (radio) {
    radio.radioGroup.selectedItem = radio;
  }
}

function initIndexedDBRow()
{
  let row = document.getElementById("perm-indexedDB-row");
  let extras = document.getElementById("perm-indexedDB-extras");

  row.appendChild(extras);

  var quotaManagerService =
    Components.classes["@mozilla.org/dom/quota-manager-service;1"]
              .getService(nsIQuotaManagerService);
  gUsageRequest =
    quotaManagerService.getUsageForPrincipal(gPermPrincipal,
                                             onIndexedDBUsageCallback);

  var status = document.getElementById("indexedDBStatus");
  var button = document.getElementById("indexedDBClear");

  status.value = "";
  status.setAttribute("hidden", "true");
  button.setAttribute("hidden", "true");
}

function onIndexedDBClear()
{
  Components.classes["@mozilla.org/dom/quota-manager-service;1"]
            .getService(nsIQuotaManagerService)
            .clearStoragesForPrincipal(gPermPrincipal);

  Components.classes["@mozilla.org/serviceworkers/manager;1"]
            .getService(Components.interfaces.nsIServiceWorkerManager)
            .removeAndPropagate(gPermURI.host);

  SitePermissions.remove(gPermURI, "indexedDB");
  initIndexedDBRow();
}

function onIndexedDBUsageCallback(request)
{
  let uri = request.principal.URI;
  if (!uri.equals(gPermURI)) {
    throw new Error("Callback received for bad URI: " + uri);
  }

  if (request.usage) {
    if (!("DownloadUtils" in window)) {
      Components.utils.import("resource://gre/modules/DownloadUtils.jsm");
    }

    var status = document.getElementById("indexedDBStatus");
    var button = document.getElementById("indexedDBClear");

    status.value =
      gBundle.getFormattedString("indexedDBUsage",
                                 DownloadUtils.convertByteUnits(request.usage));
    status.removeAttribute("hidden");
    button.removeAttribute("hidden");
  }
}

function fillInPluginPermissionTemplate(aPluginName, aPermissionString) {
  let permPluginTemplate = document.getElementById("permPluginTemplate").cloneNode(true);
  permPluginTemplate.setAttribute("permString", aPermissionString);
  let attrs = [
    [ ".permPluginTemplateLabel", "value", aPluginName ],
    [ ".permPluginTemplateRadioGroup", "id", aPermissionString + "RadioGroup" ],
    [ ".permPluginTemplateRadioDefault", "id", aPermissionString + "#0" ],
    [ ".permPluginTemplateRadioAsk", "id", aPermissionString + "#3" ],
    [ ".permPluginTemplateRadioAllow", "id", aPermissionString + "#1" ],
    [ ".permPluginTemplateRadioBlock", "id", aPermissionString + "#2" ]
  ];

  for (let attr of attrs) {
    permPluginTemplate.querySelector(attr[0]).setAttribute(attr[1], attr[2]);
  }

  return permPluginTemplate;
}

function clearPluginPermissionTemplate() {
  let permPluginTemplate = document.getElementById("permPluginTemplate");
  permPluginTemplate.hidden = true;
  permPluginTemplate.removeAttribute("permString");
  document.querySelector(".permPluginTemplateLabel").removeAttribute("value");
  document.querySelector(".permPluginTemplateRadioGroup").removeAttribute("id");
  document.querySelector(".permPluginTemplateRadioAsk").removeAttribute("id");
  document.querySelector(".permPluginTemplateRadioAllow").removeAttribute("id");
  document.querySelector(".permPluginTemplateRadioBlock").removeAttribute("id");
}

function initPluginsRow() {
  let vulnerableLabel = document.getElementById("browserBundle").getString("pluginActivateVulnerable.label");
  let pluginHost = Components.classes["@mozilla.org/plugin/host;1"].getService(Components.interfaces.nsIPluginHost);

  let permissionMap = new Map();

  for (let plugin of pluginHost.getPluginTags()) {
    if (plugin.disabled) {
      continue;
    }
    for (let mimeType of plugin.getMimeTypes()) {
      let permString = pluginHost.getPermissionStringForType(mimeType);
      if (!permissionMap.has(permString)) {
        let name = BrowserUtils.makeNicePluginName(plugin.name);
        if (permString.startsWith("plugin-vulnerable:")) {
          name += " \u2014 " + vulnerableLabel;
        }
        permissionMap.set(permString, name);
      }
    }
  }

  let entries = Array.from(permissionMap, item => ({ name: item[1], permission: item[0] }));

  entries.sort(function(a, b) {
    return a.name.localeCompare(b.name);
  });

  let permissionEntries = entries.map(p => fillInPluginPermissionTemplate(p.name, p.permission));

  let permPluginsRow = document.getElementById("perm-plugins-row");
  clearPluginPermissionTemplate();
  if (permissionEntries.length < 1) {
    permPluginsRow.hidden = true;
    return;
  }

  for (let permissionEntry of permissionEntries) {
    permPluginsRow.appendChild(permissionEntry);
  }

  setPluginsRadioState();
}

function setPluginsRadioState() {
  let box = document.getElementById("perm-plugins-row");
  for (let permissionEntry of box.childNodes) {
    if (permissionEntry.hasAttribute("permString")) {
      let permString = permissionEntry.getAttribute("permString");
      let permission = SitePermissions.get(gPermURI, permString);
      setRadioState(permString, permission);
    }
  }
}
