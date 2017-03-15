/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// @TODO Load the actual strings from webconsole.properties instead.
class L10n {
  getStr(str) {
    switch (str) {
      case "level.error":
        return "Error";
      case "consoleCleared":
        return "Console was cleared.";
      case "webConsoleXhrIndicator":
        return "XHR";
      case "webConsoleMoreInfoLabel":
        return "Learn More";
    }
    return str;
  }

  getFormatStr(str) {
    return this.getStr(str);
  }
}

module.exports = L10n;
