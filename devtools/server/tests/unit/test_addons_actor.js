/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

const {AddonsFront} = require("devtools/shared/fronts/addons");

startupAddonsManager();

function* connect() {
  const client = yield new Promise(resolve => {
    get_chrome_actors(client => resolve(client));
  });
  const root = yield listTabs(client);
  const addonsActor = root.addonsActor;
  ok(addonsActor, "Got AddonsActor instance");

  const addons = AddonsFront(client, {addonsActor});
  return [client, addons];
}

add_task(function* testSuccessfulInstall() {
  const [client, addons] = yield connect();

  const allowMissing = false;
  const usePlatformSeparator = true;
  const addonPath = getFilePath("addons/web-extension",
                                allowMissing, usePlatformSeparator);
  const installedAddon = yield addons.installTemporaryAddon(addonPath);
  equal(installedAddon.id, "test-addons-actor@mozilla.org");
  // The returned object is currently not a proper actor.
  equal(installedAddon.actor, false);

  const addonList = yield client.listAddons();
  ok(addonList && addonList.addons && addonList.addons.map(a => a.name),
     "Received list of add-ons");
  const addon = addonList.addons.filter(a => a.id === installedAddon.id)[0];
  ok(addon, "Test add-on appeared in root install list");

  yield close(client);
});

add_task(function* testNonExistantPath() {
  const [client, addons] = yield connect();

  yield Assert.rejects(
    addons.installTemporaryAddon("some-non-existant-path"),
    /Could not install add-on.*Component returned failure/);

  yield close(client);
});
