"use strict";

module.exports = {
  "globals": {
    // JS files in this folder are commonly xpcshell scripts where |arguments|
    // is defined in the global scope.
    "arguments": false
  }
};
