/* globals global, documentMetadata, util, uicontrol, ui, catcher */
/* globals buildSettings, domainFromUrl, randomString, shot */

"use strict";

this.shooter = (function() { // eslint-disable-line no-unused-vars
  let exports = {};
  const { AbstractShot } = shot;

  const RANDOM_STRING_LENGTH = 16;
  let backend;
  let shotObject;
  let supportsDrawWindow;
  const callBackground = global.callBackground;
  const clipboard = global.clipboard;

  function regexpEscape(str) {
    // http://stackoverflow.com/questions/3115150/how-to-escape-regular-expression-special-characters-using-javascript
    return str.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
  }

  function sanitizeError(data) {
    const href = new RegExp(regexpEscape(window.location.href), 'g');
    const origin = new RegExp(`${regexpEscape(window.location.origin)}[^\s",>]*`, 'g');
    const json = JSON.stringify(data)
      .replace(href, 'REDACTED_HREF')
      .replace(origin, 'REDACTED_URL');
    const result = JSON.parse(json);
    return result;
  }

  catcher.registerHandler((errorObj) => {
    callBackground("reportError", sanitizeError(errorObj));
  });

  catcher.watchFunction(() => {
    let canvas = document.createElementNS('http://www.w3.org/1999/xhtml', 'canvas');
    let ctx = canvas.getContext('2d');
    supportsDrawWindow = !!ctx.drawWindow;
  })();

  function screenshotPage(selectedPos) {
    if (!supportsDrawWindow) {
      return null;
    }
    let height = selectedPos.bottom - selectedPos.top;
    let width = selectedPos.right - selectedPos.left;
    let canvas = document.createElementNS('http://www.w3.org/1999/xhtml', 'canvas');
    canvas.width = width * window.devicePixelRatio;
    canvas.height = height * window.devicePixelRatio;
    let ctx = canvas.getContext('2d');
    if (window.devicePixelRatio !== 1) {
      ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
    }
    ui.iframe.hide();
    try {
      ctx.drawWindow(window, selectedPos.left, selectedPos.top, width, height, "#fff");
    } finally {
      ui.iframe.unhide();
    }
    return canvas.toDataURL();
  }

  let isSaving = null;

  exports.takeShot = function(captureType, selectedPos) {
    // isSaving indicates we're aleady in the middle of saving
    // we use a timeout so in the case of a failure the button will
    // still start working again
    if (Math.floor(selectedPos.left) == Math.floor(selectedPos.right) ||
        Math.floor(selectedPos.top) == Math.floor(selectedPos.bottom)) {
        let exc = new Error("Empty selection");
        exc.popupMessage = "EMPTY_SELECTION";
        exc.noReport = true;
        catcher.unhandled(exc);
        return;
    }
    const uicontrol = global.uicontrol;
    let deactivateAfterFinish = true;
    if (isSaving) {
      return;
    }
    isSaving = setTimeout(() => {
      if (typeof ui !== "undefined") {
        // ui might disappear while the timer is running because the save succeeded
        ui.Box.clearSaveDisabled();
      }
      isSaving = null;
    }, 1000);
    selectedPos = selectedPos.asJson();
    let captureText = "";
    if (buildSettings.captureText) {
      captureText = util.captureEnclosedText(selectedPos);
    }
    let dataUrl = screenshotPage(selectedPos);
    if (dataUrl) {
      shotObject.delAllClips();
      shotObject.addClip({
        createdDate: Date.now(),
        image: {
          url: dataUrl,
          captureType,
          text: captureText,
          location: selectedPos,
          dimensions: {
            x: selectedPos.right - selectedPos.left,
            y: selectedPos.bottom - selectedPos.top
          }
        }
      });
    }
    catcher.watchPromise(callBackground("takeShot", {
      captureType,
      captureText,
      scroll: {
        scrollX: window.scrollX,
        scrollY: window.scrollY,
        innerHeight: window.innerHeight,
        innerWidth: window.innerWidth
      },
      selectedPos,
      shotId: shotObject.id,
      shot: shotObject.asJson()
    }).then((url) => {
      return clipboard.copy(url).then((copied) => {
        return callBackground("openShot", { url, copied });
      });
    }, (error) => {
      if ('popupMessage' in error && (error.popupMessage == "REQUEST_ERROR" || error.popupMessage == 'CONNECTION_ERROR')) {
        // The error has been signaled to the user, but unlike other errors (or
        // success) we should not abort the selection
        deactivateAfterFinish = false;
        return;
      }
      if (error.name != "BackgroundError") {
        // BackgroundError errors are reported in the Background page
        throw error;
      }
    }).then(() => {
      if (deactivateAfterFinish) {
        uicontrol.deactivate();
      }
    }));
  };

  exports.downloadShot = function(selectedPos) {
    let dataUrl = screenshotPage(selectedPos);
    let promise = Promise.resolve(dataUrl);
    if (!dataUrl) {
      promise = callBackground(
        "screenshotPage",
        selectedPos.asJson(),
        {
          scrollX: window.scrollX,
          scrollY: window.scrollY,
          innerHeight: window.innerHeight,
          innerWidth: window.innerWidth
        });
    }
    catcher.watchPromise(promise.then((dataUrl) => {
      ui.triggerDownload(dataUrl, shotObject.filename);
      uicontrol.deactivate();
    }));
  };

  exports.sendEvent = function(...args) {
    callBackground("sendEvent", ...args);
  };

  catcher.watchFunction(() => {
    shotObject = new AbstractShot(
      backend,
      randomString(RANDOM_STRING_LENGTH) + "/" + domainFromUrl(location),
      {
        origin: shot.originFromUrl(location.href)
      }
    );
    shotObject.update(documentMetadata());
  })();

  return exports;
})();
null;
