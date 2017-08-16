/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim: sw=2 ts=2 sts=2 tw=78 expandtab :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var manifests = [
  do_get_file("data/test_data_protocol_registration.manifest"),
];
registerManifests(manifests);

function run_test()
{
  const uuidGenerator = Cc["@mozilla.org/uuid-generator;1"].getService(Ci.nsIUUIDGenerator);

  Components.utils.import("resource://testing-common/AppInfo.jsm", this);
  let XULAppInfo = newAppInfo({
    name: "XPCShell",
    ID: "{39885e5f-f6b4-4e2a-87e5-6259ecf79011}",
    version: "5",
    platformVersion: "1.9",
  });

  let XULAppInfoFactory = {
    // These two are used when we register all our factories (and unregister)
    CID: uuidGenerator.generateUUID(),
    scheme: "XULAppInfo",
    contractID: XULAPPINFO_CONTRACTID,
    createInstance: function (outer, iid) {
      if (outer != null)
        throw Cr.NS_ERROR_NO_AGGREGATION;
      return XULAppInfo.QueryInterface(iid);
    }
  };

  // Add our XULAppInfo factory
  let factories = [XULAppInfoFactory];
  let old_factories = [];
  let old_factories_inds = [];

  let registrar = Components.manager.QueryInterface(Ci.nsIComponentRegistrar);

  // Register our factories
  for (let i = 0; i < factories.length; i++) {
    let factory = factories[i];

    // Make sure the class ID has not already been registered
    if (!registrar.isCIDRegistered(factory.CID)) {

      // Check to see if a contract was already registered and
      // register it if it is not. Otherwise, store the previous one
      // to be restored later and register the new one.
      if (registrar.isContractIDRegistered(factory.contractID)) {
        dump(factory.scheme + " is already registered. Storing currently registered object for restoration later.")
        old_factories.push({
          CID: registrar.contractIDToCID(factory.contractID),
          factory: Components.manager.getClassObject(Cc[factory.contractID], Ci.nsIFactory)
        });
        old_factories_inds.push(true);
        registrar.unregisterFactory(old_factories[i].CID, old_factories[i].factory);
      }
      else {
        dump(factory.scheme + " has never been registered. Registering...")
        old_factories.push({CID: "", factory: null});
        old_factories_inds.push(false);
      }

      registrar.registerFactory(factory.CID, "test-" + factory.scheme, factory.contractID, factory);
    }
    else {
      do_throw("CID " + factory.CID +  " has already been registered!");
    }
  }

  // Check for new chrome
  let cr = Cc["@mozilla.org/chrome/chrome-registry;1"].
           getService(Ci.nsIChromeRegistry);
  cr.checkForNewChrome();

  // Check that our override worked
  let expectedURI = "data:application/vnd.mozilla.xul+xml,";
  let sourceURI = "chrome://good-package/content/test.xul";
  try {
    let ios = Cc["@mozilla.org/network/io-service;1"].
              getService(Ci.nsIIOService);
    sourceURI = ios.newURI(sourceURI);
    // this throws for packages that are not registered
    let uri = cr.convertChromeURL(sourceURI).spec;

    do_check_eq(expectedURI, uri);
  }
  catch (e) {
    dump(e + "\n");
    do_throw("Should have registered our URI!");
  }

  // Unregister our factories so we do not leak
  for (let i = 0; i < factories.length; i++) {
    let factory = factories[i];
    let ind = old_factories_inds[i];
    registrar.unregisterFactory(factory.CID, factory);

    if (ind == true) {
      let old_factory = old_factories[i];
      registrar.registerFactory(old_factory.CID, factory.scheme, factory.contractID, old_factory.factory);
    }
  }
}
