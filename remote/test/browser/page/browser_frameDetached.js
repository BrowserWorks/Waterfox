/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const DOC = toDataURL("<div>foo</div>");
const DOC_IFRAME_MULTI = toDataURL(`
  <iframe src='data:text/html,foo'></iframe>
  <iframe src='data:text/html,bar'></iframe>
`);
const DOC_IFRAME_NESTED = toDataURL(`
  <iframe src="data:text/html,<iframe src='data:text/html,foo'></iframe>">
  </iframe>
`);

// Disable bfcache to force documents to be destroyed on navigation
Services.prefs.setIntPref("browser.sessionhistory.max_total_viewers", 0);
registerCleanupFunction(() => {
  Services.prefs.clearUserPref("browser.sessionhistory.max_total_viewers");
});

add_task(async function noEventWhenPageDomainDisabled({ client }) {
  await loadURL(DOC_IFRAME_MULTI);

  await runFrameDetachedTest(client, 0, async () => {
    info("Navigate away from a page with an iframe");
    await loadURL(DOC);
  });
});

add_task(async function noEventAfterPageDomainDisabled({ client }) {
  const { Page } = client;

  await Page.enable();

  await loadURL(DOC_IFRAME_MULTI);

  await Page.disable();

  await runFrameDetachedTest(client, 0, async () => {
    info("Navigate away from a page with an iframe");
    await loadURL(DOC);
  });
});

add_task(async function noEventWhenNavigatingWithNoFrames({ client }) {
  const { Page } = client;

  await Page.enable();

  await loadURL(DOC);

  await runFrameDetachedTest(client, 0, async () => {
    info("Navigate away from a page with no iframes");
    await loadURL(DOC);
  });
});

add_task(async function eventWhenNavigatingWithFrames({ client }) {
  const { Page } = client;

  await Page.enable();

  await loadURL(DOC_IFRAME_MULTI);

  await runFrameDetachedTest(client, 2, async () => {
    info("Navigate away from a page with an iframe");
    await loadURL(DOC);
  });
});

add_task(async function eventWhenNavigatingWithNestedFrames({ client }) {
  const { Page } = client;

  await Page.enable();

  await loadURL(DOC_IFRAME_NESTED);

  await runFrameDetachedTest(client, 2, async () => {
    info("Navigate away from a page with nested iframes");
    await loadURL(DOC);
  });
});

add_task(async function eventWhenDetachingFrame({ client }) {
  const { Page } = client;

  await Page.enable();

  await loadURL(DOC_IFRAME_MULTI);

  await runFrameDetachedTest(client, 1, async () => {
    // Remove the single frame from the page
    await SpecialPowers.spawn(gBrowser.selectedBrowser, [], () => {
      const frame = content.document.getElementsByTagName("iframe")[0];
      frame.remove();
    });
  });
});

add_task(async function eventWhenDetachingNestedFrames({ client }) {
  const { Page, Runtime } = client;

  await Page.enable();

  await loadURL(DOC_IFRAME_NESTED);

  await Runtime.enable();
  const { context } = await Runtime.executionContextCreated();

  await runFrameDetachedTest(client, 2, async () => {
    // Remove top-frame, which also removes any nested frames
    await evaluate(client, context.id, async () => {
      const frame = document.getElementsByTagName("iframe")[0];
      frame.remove();
    });
  });
});

async function runFrameDetachedTest(client, expectedEventCount, callback) {
  const { Page } = client;

  const DETACHED = "Page.frameDetached";

  const history = new RecordEvents(expectedEventCount);
  history.addRecorder({
    event: Page.frameDetached,
    eventName: DETACHED,
    messageFn: payload => {
      return `Received ${DETACHED} for frame id ${payload.frameId}`;
    },
  });

  const framesBefore = await getFlattendFrameList();
  await callback();
  const framesAfter = await getFlattendFrameList();

  const frameDetachedEvents = await history.record();

  if (expectedEventCount == 0) {
    is(frameDetachedEvents.length, 0, "Got no frame detached event");
    return;
  }

  // check how many frames were attached or detached
  const count = Math.abs(framesBefore.size - framesAfter.size);

  is(count, expectedEventCount, "Expected amount of frames detached");
  is(
    frameDetachedEvents.length,
    count,
    "Received the expected amount of frameDetached events"
  );

  // extract the new or removed frames
  const framesAll = new Map([...framesBefore, ...framesAfter]);
  const expectedFrames = new Map(
    [...framesAll].filter(([key, _value]) => {
      return framesBefore.has(key) && !framesAfter.has(key);
    })
  );

  frameDetachedEvents.forEach(({ payload }) => {
    const { frameId } = payload;

    console.log(`Check frame id ${frameId}`);
    const expectedFrame = expectedFrames.get(frameId);

    is(
      frameId,
      expectedFrame.id,
      "Got expected frame id for frameDetached event"
    );
  });
}
