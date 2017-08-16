/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim: sw=2 ts=2 sts=2 tw=78 expandtab :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var manifests = [
  do_get_file("data/test_no_remote_registration.manifest"),
];
registerManifests(manifests);

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

function ProtocolHandler(aScheme, aFlags)
{
  this.scheme = aScheme;
  this.protocolFlags = aFlags;
  this.contractID = "@mozilla.org/network/protocol;1?name=" + aScheme;
}

ProtocolHandler.prototype =
{
  defaultPort: -1,
  allowPort: () => false,
  newURI: function(aSpec, aCharset, aBaseURI)
  {
    let uri = Cc["@mozilla.org/network/standard-url;1"].
              createInstance(Ci.nsIURI);
    uri.spec = aSpec;
    if (!uri.scheme) {
      // We got a partial uri, so let's resolve it with the base one
      uri.spec = aBaseURI.resolve(aSpec);
    }
    return uri;
  },
  newChannel2: function() { throw Cr.NS_ERROR_NOT_IMPLEMENTED },
  newChannel: function() { throw Cr.NS_ERROR_NOT_IMPLEMENTED },
  QueryInterface: XPCOMUtils.generateQI([
    Ci.nsIProtocolHandler
  ])
};

var testProtocols = [
  // It doesn't matter if it has this flag - the only flag we accept is
  // URI_IS_LOCAL_RESOURCE.
  {scheme: "moz-protocol-ui-resource",
   flags: Ci.nsIProtocolHandler.URI_IS_UI_RESOURCE,
   CID: Components.ID("{d6dedc93-558f-44fe-90f4-3b4bba8a0b14}"),
   shouldRegister: false
  },
  // It doesn't matter if it has this flag - the only flag we accept is
  // URI_IS_LOCAL_RESOURCE.
  {scheme: "moz-protocol-local-file",
   flags: Ci.nsIProtocolHandler.URI_IS_LOCAL_FILE,
   CID: Components.ID("{ee30d594-0a2d-4f47-89cc-d4cde320ab69}"),
   shouldRegister: false
  },
  // This clearly is non-local
  {scheme: "moz-protocol-loadable-by-anyone",
   flags: Ci.nsIProtocolHandler.URI_LOADABLE_BY_ANYONE,
   CID: Components.ID("{c3735f23-3b0c-4a33-bfa0-79436dcd40b2}"),
   shouldRegister: false
  },
  // This should always be last (unless we add more flags that are OK)
  {scheme: "moz-protocol-local-resource",
   flags: Ci.nsIProtocolHandler.URI_IS_LOCAL_RESOURCE,
   CID: Components.ID("{b79e977c-f840-469a-b413-0125cc1b62a5}"),
   shouldRegister: true
  },
];
function run_test()
{
  Components.utils.import("resource://testing-common/AppInfo.jsm", this);
  let XULAppInfo = newAppInfo({
    name: "XPCShell",
    ID: "{39885e5f-f6b4-4e2a-87e5-6259ecf79011}",
    version: "5",
    platformVersion: "1.9",
  });

  const uuidGenerator = Cc["@mozilla.org/uuid-generator;1"].getService(Ci.nsIUUIDGenerator);

  let XULAppInfoFactory = {
    // These two are used when we register all our factories (and unregister)
    CID: uuidGenerator.generateUUID(),
    scheme: "XULAppInfo",
    contractID: "@mozilla.org/xre/app-info;1",
    createInstance: function (outer, iid) {
      if (outer != null)
        throw Cr.NS_ERROR_NO_AGGREGATION;
      return XULAppInfo.QueryInterface(iid);
    }
  };

  let registrar = Components.manager.QueryInterface(Ci.nsIComponentRegistrar);

  // Create factories
  let factories = [];
  for (let i = 0; i < testProtocols.length; i++) {
    factories[i] = {
      scheme: testProtocols[i].scheme,
      flags: testProtocols[i].flags,
      CID: testProtocols[i].CID,
      contractID: "@mozilla.org/network/protocol;1?name=" + testProtocols[i].scheme,
      createInstance: function(aOuter, aIID)
      {
        if (aOuter != null)
          throw Cr.NS_ERROR_NO_AGGREGATION;
        let handler = new ProtocolHandler(this.scheme, this.flags, this.CID);
        return handler.QueryInterface(aIID);
      }
    };
  }

  // Register our factories
  for (let i = 0; i < factories.length; i++) {
    let factory = factories[i];
    registrar.registerFactory(factory.CID, "test-" + factory.scheme,
                               factory.contractID, factory);
  }

  // Register the XULAppInfoFactory
  // Make sure the class ID has not already been registered
  let old_factory = {CID: "", factory: null};
  if (!registrar.isCIDRegistered(XULAppInfoFactory.CID)) {

    // Check to see if a contract was already registered and
    // register it if it is not. Otherwise, store the previous one
    // to be restored later and register the new one.
    if (registrar.isContractIDRegistered(XULAppInfoFactory.contractID)) {
      dump(XULAppInfoFactory.scheme + " is already registered. Storing currently registered object for restoration later.")
      old_factory.CID = registrar.contractIDToCID(XULAppInfoFactory.contractID);
      old_factory.factory = Components.manager.getClassObject(Cc[XULAppInfoFactory.contractID], Ci.nsIFactory);
      registrar.unregisterFactory(old_factory.CID, old_factory.factory);
    }
    else {
      dump(XULAppInfoFactory.scheme + " has never been registered. Registering...")
    }

    registrar.registerFactory(XULAppInfoFactory.CID, "test-" + XULAppInfoFactory.scheme, XULAppInfoFactory.contractID, XULAppInfoFactory);
  }
  else {
    do_throw("CID " + XULAppInfoFactory.CID +  " has already been registered!");
  }

  // Check for new chrome
  let cr = Cc["@mozilla.org/chrome/chrome-registry;1"].
           getService(Ci.nsIChromeRegistry);
  cr.checkForNewChrome();

  // See if our various things were able to register
  let registrationTypes = [
    "content",
    "locale",
    "skin",
    "override",
    "resource",
  ];
  for (let i = 0; i < testProtocols.length; i++) {
    let protocol = testProtocols[i];
    for (let j = 0; j < registrationTypes.length; j++) {
      let type = registrationTypes[j];
      dump("Testing protocol '" + protocol.scheme + "' with type '" + type +
           "'\n");
      let expectedURI = protocol.scheme + "://foo/";
      let sourceURI = "chrome://" + protocol.scheme + "/" + type + "/";
      switch (type) {
        case "content":
          expectedURI += protocol.scheme + ".xul";
          break;
        case "locale":
          expectedURI += protocol.scheme + ".dtd";
          break;
        case "skin":
          expectedURI += protocol.scheme + ".css";
          break;
        case "override":
          sourceURI = "chrome://good-package/content/override-" +
                      protocol.scheme + ".xul";
          break;
        case "resource":
          sourceURI = "resource://" + protocol.scheme + "/";
          break;
      };
      try {
        let ios = Cc["@mozilla.org/network/io-service;1"].
                  getService(Ci.nsIIOService);
        sourceURI = ios.newURI(sourceURI);
        let uri;
        if (type == "resource") {
          // resources go about a slightly different way than everything else
          let rph = ios.getProtocolHandler("resource").
                    QueryInterface(Ci.nsIResProtocolHandler);
          // this throws for packages that are not registered
          uri = rph.resolveURI(sourceURI);
        }
        else {
          // this throws for packages that are not registered
          uri = cr.convertChromeURL(sourceURI).spec;
        }

        if (protocol.shouldRegister) {
          do_check_eq(expectedURI, uri);
        }
        else {
          // Overrides will not throw, so we'll get to here.  We want to make
          // sure that the two strings are not the same in this situation.
          do_check_neq(expectedURI, uri);
        }
      }
      catch (e) {
        if (protocol.shouldRegister) {
          dump(e + "\n");
          do_throw("Should have registered our URI for protocol " +
                   protocol.scheme);
        }
      }
    }
  }

  // Unregister our factories so we do not leak
  for (let i = 0; i < factories.length; i++) {
    let factory = factories[i];
    registrar.unregisterFactory(factory.CID, factory);
  }

  // Unregister XULAppInfoFactory
  registrar.unregisterFactory(XULAppInfoFactory.CID, XULAppInfoFactory);
  if (old_factory.factory != null) {
    registrar.registerFactory(old_factory.CID, "", XULAppInfoFactory.contractID, old_factory.factory);
  }
}
