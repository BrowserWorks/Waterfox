/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function() {
  await setLinks("0,1,2,3,4,5,6,7,8");
  setPinnedLinks("");

  await addNewTabPageTab();
  await checkGrid("0,1,2,3,4,5,6,7,8");

  function doDrop(data) {
    return ContentTask.spawn(gBrowser.selectedBrowser, { data }, async function(args) {
      let dataTransfer = new content.DataTransfer("dragstart", false);
      dataTransfer.mozSetDataAt("text/x-moz-url", args.data, 0);
      let event = content.document.createEvent("DragEvent");
      event.initDragEvent("drop", true, true, content, 0, 0, 0, 0, 0,
                          false, false, false, false, 0, null, dataTransfer);

      let target = content.gGrid.cells[0].node;
      target.dispatchEvent(event);
    });
  }

  await doDrop("http://example99.com/\nblank");
  is(NewTabUtils.pinnedLinks.links[0].url, "http://example99.com/",
     "first cell is pinned and contains the dropped site");

  await whenPagesUpdated();
  await checkGrid("99p,0,1,2,3,4,5,6,7");

  await doDrop("");
  is(NewTabUtils.pinnedLinks.links[0].url, "http://example99.com/",
     "first cell is still pinned with the site we dropped before");
});

