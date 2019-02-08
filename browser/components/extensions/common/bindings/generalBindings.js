/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global MozXULElement */

class MozStatusbarpanel extends MozXULElement {
  static get observedAttributes() {
    return ["label"];
  }

  connectedCallback() {
    this._updateAttributes();
  }

  attributeChangedCallback() {
    this._updateAttributes();
  }

  set label(val) {
    this.setAttribute("label", val);
    return val;
  }

  get label() {
    return this.getAttribute("label");
  }

  _updateAttributes() {
    this.textContent = this.label || "";
  }
}

customElements.define("statusbarpanel", MozStatusbarpanel);
