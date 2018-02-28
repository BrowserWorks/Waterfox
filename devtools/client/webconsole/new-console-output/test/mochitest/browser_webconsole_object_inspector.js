/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Check expanding/collapsing object inspector in the console.
const TEST_URI = "data:text/html;charset=utf8,<h1>test Object Inspector</h1>";

add_task(async function () {
  let toolbox = await openNewTabAndToolbox(TEST_URI, "webconsole");
  let hud = toolbox.getCurrentPanel().hud;

  const store = hud.ui.newConsoleOutput.getStore();
  // Adding logging each time the store is modified in order to check
  // the store state in case of failure.
  store.subscribe(() => {
    const messages = store.getState().messages.messagesById
      .reduce(function (res, {id, type, parameters, messageText}) {
        res.push({id, type, parameters, messageText});
        return res;
      }, []);
    info("messages : " + JSON.stringify(messages));
  });

  await ContentTask.spawn(gBrowser.selectedBrowser, null, function () {
    content.wrappedJSObject.console.log(
      "oi-test",
      [1, 2, {a: "a", b: "b"}],
      {c: "c", d: [3, 4]}
    );
  });

  let node = await waitFor(() => findMessage(hud, "oi-test"));
  const objectInspectors = [...node.querySelectorAll(".tree")];
  is(objectInspectors.length, 2, "There is the expected number of object inspectors");

  const [arrayOi] = objectInspectors;

  info("Expanding the array object inspector");

  let onArrayOiMutation = waitForNodeMutation(arrayOi, {
    childList: true
  });

  arrayOi.querySelector(".arrow").click();
  await onArrayOiMutation;

  ok(arrayOi.querySelector(".arrow").classList.contains("expanded"),
    "The arrow of the root node of the tree is expanded after clicking on it");

  let arrayOiNodes = arrayOi.querySelectorAll(".node");
  // There are 6 nodes: the root, 1, 2, {a: "a", b: "b"}, length and the proto.
  is(arrayOiNodes.length, 6, "There is the expected number of nodes in the tree");

  info("Expanding a leaf of the array object inspector");
  let arrayOiNestedObject = arrayOiNodes[3];
  onArrayOiMutation = waitForNodeMutation(arrayOi, {
    childList: true
  });

  arrayOiNestedObject.querySelector(".arrow").click();
  await onArrayOiMutation;

  ok(arrayOiNestedObject.querySelector(".arrow").classList.contains("expanded"),
    "The arrow of the root node of the tree is expanded after clicking on it");

  arrayOiNodes = arrayOi.querySelectorAll(".node");
  // There are now 9 nodes, the 6 original ones, and 3 new from the expanded object:
  // a, b and the proto.
  is(arrayOiNodes.length, 9, "There is the expected number of nodes in the tree");

  info("Collapsing the root");
  onArrayOiMutation = waitForNodeMutation(arrayOi, {
    childList: true
  });
  arrayOi.querySelector(".arrow").click();

  is(arrayOi.querySelector(".arrow").classList.contains("expanded"), false,
    "The arrow of the root node of the tree is collapsed after clicking on it");

  arrayOiNodes = arrayOi.querySelectorAll(".node");
  is(arrayOiNodes.length, 1, "Only the root node is visible");

  info("Expanding the root again");
  onArrayOiMutation = waitForNodeMutation(arrayOi, {
    childList: true
  });
  arrayOi.querySelector(".arrow").click();

  ok(arrayOi.querySelector(".arrow").classList.contains("expanded"),
    "The arrow of the root node of the tree is expanded again after clicking on it");

  arrayOiNodes = arrayOi.querySelectorAll(".node");
  arrayOiNestedObject = arrayOiNodes[3];
  ok(arrayOiNestedObject.querySelector(".arrow").classList.contains("expanded"),
    "The object tree is still expanded");

  is(arrayOiNodes.length, 9, "There is the expected number of nodes in the tree");
});
