/*
 * This code is used for handling synthesizeMouse in a content process.
 * Generally it just delegates to EventUtils.js.
 */

// Set up a dummy environment so that EventUtils works. We need to be careful to
// pass a window object into each EventUtils method we call rather than having
// it rely on the |window| global.
var EventUtils = {};
EventUtils.window = {};
EventUtils.parent = EventUtils.window;
EventUtils._EU_Ci = Components.interfaces;
EventUtils._EU_Cc = Components.classes;
// EventUtils' `sendChar` function relies on the navigator to synthetize events.
EventUtils.navigator = content.document.defaultView.navigator;
EventUtils.KeyboardEvent = content.document.defaultView.KeyboardEvent;

Services.scriptloader.loadSubScript("chrome://mochikit/content/tests/SimpleTest/EventUtils.js", EventUtils);

addMessageListener("Test:SynthesizeMouse", (message) => {
  let data = message.data;
  let target = data.target;
  if (typeof target == "string") {
    target = content.document.querySelector(target);
  }
  else if (typeof data.targetFn == "string") {
    let runnablestr = `
      (() => {
        return (${data.targetFn});
      })();`
    target = eval(runnablestr)();
  }
  else {
    target = message.objects.object;
  }

  let left = data.x;
  let top = data.y;
  if (target) {
    if (target.ownerDocument !== content.document) {
      // Account for nodes found in iframes.
      let cur = target;
      do {
        let frame = cur.ownerDocument.defaultView.frameElement;
        let rect = frame.getBoundingClientRect();

        left += rect.left;
        top += rect.top;

        cur = frame;
      } while (cur && cur.ownerDocument !== content.document);

      // node must be in this document tree.
      if (!cur) {
        sendAsyncMessage("Test:SynthesizeMouseDone",
                         { error: "target must be in the main document tree" });
        return;
      }
    }

    let rect = target.getBoundingClientRect();
    left += rect.left;
    top += rect.top;

    if (data.event.centered) {
      left += rect.width / 2;
      top += rect.height / 2;
    }
  }

  let result;
  if (data.event && data.event.wheel) {
    EventUtils.synthesizeWheelAtPoint(left, top, data.event, content);
  } else {
    result = EventUtils.synthesizeMouseAtPoint(left, top, data.event, content);
  }
  sendAsyncMessage("Test:SynthesizeMouseDone", { defaultPrevented: result });
});

addMessageListener("Test:SendChar", message => {
  let result = EventUtils.sendChar(message.data.char, content);
  sendAsyncMessage("Test:SendCharDone", { result, seq: message.data.seq });
});

addMessageListener("Test:SynthesizeKey", message => {
  EventUtils.synthesizeKey(message.data.key, message.data.event || {}, content);
  sendAsyncMessage("Test:SynthesizeKeyDone", { seq: message.data.seq });
});

addMessageListener("Test:SynthesizeComposition", message => {
  let result = EventUtils.synthesizeComposition(message.data.event, content);
  sendAsyncMessage("Test:SynthesizeCompositionDone", { result, seq: message.data.seq });
});

addMessageListener("Test:SynthesizeCompositionChange", message => {
  EventUtils.synthesizeCompositionChange(message.data.event, content);
  sendAsyncMessage("Test:SynthesizeCompositionChangeDone", { seq: message.data.seq });
});
