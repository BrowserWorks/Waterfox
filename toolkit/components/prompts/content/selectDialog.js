/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var Ci = Components.interfaces;
var Cr = Components.results;
var Cc = Components.classes;
var Cu = Components.utils;

var gArgs, listBox;

function dialogOnLoad() {
    gArgs = window.arguments[0].QueryInterface(Ci.nsIWritablePropertyBag2)
                               .QueryInterface(Ci.nsIWritablePropertyBag);

    let promptType = gArgs.getProperty("promptType");
    if (promptType != "select") {
        Cu.reportError("selectDialog opened for unknown type: " + promptType);
        window.close();
    }

    // Default to canceled.
    gArgs.setProperty("ok", false);

    document.title = gArgs.getProperty("title");

    let text = gArgs.getProperty("text");
    document.getElementById("info.txt").setAttribute("value", text);

    let items = gArgs.getProperty("list");
    listBox = document.getElementById("list");

    for (let i = 0; i < items.length; i++) {
        let str = items[i];
        if (str == "")
            str = "<>";
        listBox.appendItem(str);
        listBox.getItemAtIndex(i).addEventListener("dblclick", dialogDoubleClick, false);
    }
    listBox.selectedIndex = 0;
    listBox.focus();

    // resize the window to the content
    window.sizeToContent();

    // Move to the right location
    moveToAlertPosition();
    centerWindowOnScreen();

    // play sound
    try {
        Cc["@mozilla.org/sound;1"].
        createInstance(Ci.nsISound).
        playEventSound(Ci.nsISound.EVENT_SELECT_DIALOG_OPEN);
    } catch (e) { }
}

function dialogOK() {
    gArgs.setProperty("selected", listBox.selectedIndex);
    gArgs.setProperty("ok", true);
    return true;
}

function dialogDoubleClick() {
    dialogOK();
    window.close();
}
