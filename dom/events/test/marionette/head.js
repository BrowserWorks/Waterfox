/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

const {Cc: Cc, Ci: Ci, Cr: Cr, Cu: Cu} = SpecialPowers;


var _pendingEmulatorCmdCount = 0;

/**
 * Send emulator command with safe guard.
 *
 * We should only call |finish()| after all emulator command transactions
 * end, so here comes with the pending counter.  Resolve when the emulator
 * gives positive response, and reject otherwise.
 *
 * Fulfill params:
 *   result -- an array of emulator response lines.
 * Reject params:
 *   result -- an array of emulator response lines.
 *
 * @return A deferred promise.
 */
function runEmulatorCmdSafe(aCommand) {
  return new Promise((resolve, reject) => {

    ++_pendingEmulatorCmdCount;
    runEmulatorCmd(aCommand, function(aResult) {
      --_pendingEmulatorCmdCount;

      ok(true, "Emulator response: " + JSON.stringify(aResult));
      if (Array.isArray(aResult) &&
          aResult[aResult.length - 1] === "OK") {
        resolve(aResult);
      } else {
        reject(aResult);
      }
    });

  });
}

/**
 * Get emulator sensor values of a named sensor.
 *
 * Fulfill params:
 *   result -- an array of emulator sensor values.
 * Reject params: (none)
 *
 * @param aSensorName
 *        A string name of the sensor.  Availables are: "acceleration"
 *        "magnetic-field", "orientation", "temperature", "proximity".
 *
 * @return A deferred promise.
 */
function getEmulatorSensorValues(aSensorName) {
  return runEmulatorCmdSafe("sensor get " + aSensorName)
    .then(function(aResult) {
      // aResult = ["orientation = 0:0:0", "OK"]
      return aResult[0].split(" ")[2].split(":").map(function(aElement) {
        return parseInt(aElement, 10);
      });
    });
}

/**
 * Convenient alias function for getting orientation sensor values.
 */
function getEmulatorOrientationValues() {
  return getEmulatorSensorValues("orientation");
}

/**
 * Set emulator orientation sensor values.
 *
 * Fulfill params: (none)
 * Reject params: (none)
 *
 * @param aAzimuth
 * @param aPitch
 * @param aRoll
 *
 * @return A deferred promise.
 */
function setEmulatorOrientationValues(aAzimuth, aPitch, aRoll) {
  let cmd = "sensor set orientation " + aAzimuth + ":" + aPitch + ":" + aRoll;
  return runEmulatorCmdSafe(cmd);
}

/**
 * Wait for a named window event.
 *
 * Resolve if that named event occurs.  Never reject.
 *
 * Forfill params: the DOMEvent passed.
 *
 * @param aEventName
 *        A string event name.
 *
 * @return A deferred promise.
 */
function waitForWindowEvent(aEventName) {
  return new Promise(resolve => {

    window.addEventListener(aEventName, function(aEvent) {
      ok(true, "Window event '" + aEventName + "' got.");
      resolve(aEvent);
    }, {once: true});

  });
}

/**
 * Wait for pending emulator transactions and call |finish()|.
 */
function cleanUp() {
  // Use ok here so that we have at least one test run.
  ok(true, ":: CLEANING UP ::");

  waitFor(finish, function() {
    return _pendingEmulatorCmdCount === 0;
  });
}

/**
 * Basic test routine helper.
 *
 * This helper does nothing but clean-ups.
 *
 * @param aTestCaseMain
 *        A function that takes no parameter.
 */
function startTestBase(aTestCaseMain) {
  Promise.resolve()
    .then(aTestCaseMain)
    .then(cleanUp, function() {
      ok(false, 'promise rejects during test.');
      cleanUp();
    });
}
