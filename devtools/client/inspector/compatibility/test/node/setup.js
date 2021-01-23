/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

"use strict";

/* global global */

// Configure enzyme with React 16 adapter.
const Enzyme = require("enzyme");
const Adapter = require("enzyme-adapter-react-16");
Enzyme.configure({ adapter: new Adapter() });

global.loader = {
  lazyGetter: (context, name, fn) => {
    const module = fn();
    global[name] = module;
  },
  lazyRequireGetter: (context, name, module, destructure) => {
    const value = destructure ? require(module)[name] : require(module || name);
    global[name] = value;
  },
};
