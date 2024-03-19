/*
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
'use strict';

import './index.js';

import './tab-preview.js';
import './workaround-for-bug-1875100.js';

import * as EventUtils from './event-utils.js';

window.addEventListener('contextmenu', event => {
  if (EventUtils.getEventTargetType(event) != 'blank')
    return true;

  event.stopImmediatePropagation();
  event.preventDefault();
  return false;
}, { capture: true });
