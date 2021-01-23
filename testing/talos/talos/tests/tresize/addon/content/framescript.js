(function() {
  const TRESIZE_PREFIX = "tresize@mozilla.org:";

  addEventListener(
    TRESIZE_PREFIX + "chrome-run-event",
    function(e) {
      var uniqueMessageId =
        TRESIZE_PREFIX +
        content.document.documentURI +
        // eslint-disable-next-line mozilla/avoid-Date-timing
        Date.now() +
        Math.random();

      addMessageListener(TRESIZE_PREFIX + "chrome-run-reply", function done(
        reply
      ) {
        if (reply.data.id == uniqueMessageId) {
          removeMessageListener(TRESIZE_PREFIX + "chrome-run-reply", done);
          content.wrappedJSObject.tpRecordTime(reply.data.result.average);
        }
      });

      sendAsyncMessage(TRESIZE_PREFIX + "chrome-run-message", {
        id: uniqueMessageId,
        locationSearch: e.detail.locationSearch,
      });
    },
    false,
    true
  );
})();
