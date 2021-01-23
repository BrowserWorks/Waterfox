/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetters(this, {
  AppConstants: "resource://gre/modules/AppConstants.jsm",
  setTimeout: "resource://gre/modules/Timer.jsm",
  Downloads: "resource://gre/modules/Downloads.jsm",
  OfflineAppCacheHelper: "resource://gre/modules/offlineAppCache.jsm",
  ServiceWorkerCleanUp: "resource://gre/modules/ServiceWorkerCleanUp.jsm",
  PlacesUtils: "resource://gre/modules/PlacesUtils.jsm",
});

XPCOMUtils.defineLazyServiceGetter(
  this,
  "sas",
  "@mozilla.org/storage/activity-service;1",
  "nsIStorageActivityService"
);
XPCOMUtils.defineLazyServiceGetter(
  this,
  "TrackingDBService",
  "@mozilla.org/tracking-db-service;1",
  "nsITrackingDBService"
);

// A Cleaner is an object with 5 methods. These methods must return a Promise
// object. Here a description of these methods:
// * deleteAll() - this method _must_ exist. When called, it deletes all the
//                 data owned by the cleaner.
// * deleteByPrincipal() - this method is implemented only if the cleaner knows
//                         how to delete data by nsIPrincipal. If not
//                         implemented, deleteByHost will be used instead.
// * deleteByHost() - this method is implemented only if the cleaner knows
//                    how to delete data by host + originAttributes pattern. If
//                    not implemented, deleteAll() will be used as fallback.
// * deleteByRange() - this method is implemented only if the cleaner knows how
//                    to delete data by time range. It receives 2 time range
//                    parameters: aFrom/aTo. If not implemented, deleteAll() is
//                    used as fallback.
// * deleteByLocalFiles() - this method removes data held for local files and
//                          other hostless origins. If not implemented,
//                          **no fallback is used**, as for a number of
//                          cleaners, no such data will ever exist and
//                          therefore clearing it does not make sense.
// * deleteByOriginAttributes() - this method is implemented only if the cleaner
//                                knows how to delete data by originAttributes
//                                pattern.

const CookieCleaner = {
  deleteByLocalFiles(aOriginAttributes) {
    return new Promise(aResolve => {
      Services.cookies.removeCookiesFromExactHost(
        "",
        JSON.stringify(aOriginAttributes)
      );
      aResolve();
    });
  },

  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      Services.cookies.removeCookiesFromExactHost(
        aHost,
        JSON.stringify(aOriginAttributes)
      );
      aResolve();
    });
  },

  deleteByRange(aFrom, aTo) {
    return Services.cookies.removeAllSince(aFrom);
  },

  deleteByOriginAttributes(aOriginAttributesString) {
    return new Promise(aResolve => {
      try {
        Services.cookies.removeCookiesWithOriginAttributes(
          aOriginAttributesString
        );
      } catch (ex) {}
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      Services.cookies.removeAll();
      aResolve();
    });
  },
};

const CertCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    let overrideService = Cc["@mozilla.org/security/certoverride;1"].getService(
      Ci.nsICertOverrideService
    );
    return new Promise(aResolve => {
      overrideService.clearValidityOverride(aHost, -1);
      aResolve();
    });
  },

  deleteAll() {
    let overrideService = Cc["@mozilla.org/security/certoverride;1"].getService(
      Ci.nsICertOverrideService
    );
    return new Promise(aResolve => {
      overrideService.clearAllOverrides();
      aResolve();
    });
  },
};

const NetworkCacheCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      // Delete data from both HTTP and HTTPS sites.
      let httpURI = Services.io.newURI("http://" + aHost);
      let httpsURI = Services.io.newURI("https://" + aHost);
      let httpPrincipal = Services.scriptSecurityManager.createContentPrincipal(
        httpURI,
        aOriginAttributes
      );
      let httpsPrincipal = Services.scriptSecurityManager.createContentPrincipal(
        httpsURI,
        aOriginAttributes
      );

      Services.cache2.clearOrigin(httpPrincipal);
      Services.cache2.clearOrigin(httpsPrincipal);
      aResolve();
    });
  },

  deleteByPrincipal(aPrincipal) {
    return new Promise(aResolve => {
      Services.cache2.clearOrigin(aPrincipal);
      aResolve();
    });
  },

  deleteByOriginAttributes(aOriginAttributesString) {
    return new Promise(aResolve => {
      Services.cache2.clearOriginAttributes(aOriginAttributesString);
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      Services.cache2.clear();
      aResolve();
    });
  },
};

const ImageCacheCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      let imageCache = Cc["@mozilla.org/image/tools;1"]
        .getService(Ci.imgITools)
        .getImgCacheForDocument(null);

      // Delete data from both HTTP and HTTPS sites.
      let httpURI = Services.io.newURI("http://" + aHost);
      let httpsURI = Services.io.newURI("https://" + aHost);
      let httpPrincipal = Services.scriptSecurityManager.createContentPrincipal(
        httpURI,
        aOriginAttributes
      );
      let httpsPrincipal = Services.scriptSecurityManager.createContentPrincipal(
        httpsURI,
        aOriginAttributes
      );

      imageCache.removeEntriesFromPrincipal(httpPrincipal);
      imageCache.removeEntriesFromPrincipal(httpsPrincipal);
      aResolve();
    });
  },

  deleteByPrincipal(aPrincipal) {
    return new Promise(aResolve => {
      let imageCache = Cc["@mozilla.org/image/tools;1"]
        .getService(Ci.imgITools)
        .getImgCacheForDocument(null);
      imageCache.removeEntriesFromPrincipal(aPrincipal);
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      let imageCache = Cc["@mozilla.org/image/tools;1"]
        .getService(Ci.imgITools)
        .getImgCacheForDocument(null);
      imageCache.clearCache(false); // true=chrome, false=content
      aResolve();
    });
  },
};

const PluginDataCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return this._deleteInternal((aPh, aTag) => {
      return new Promise(aResolve => {
        try {
          aPh.clearSiteData(
            aTag,
            aHost,
            Ci.nsIPluginHost.FLAG_CLEAR_ALL,
            -1,
            aResolve
          );
        } catch (e) {
          // Ignore errors from the plugin, but resolve the promise
          // We cannot check if something is a bailout or an error
          aResolve();
        }
      });
    });
  },

  deleteByRange(aFrom, aTo) {
    let age = Date.now() / 1000 - aFrom / 1000000;

    return this._deleteInternal((aPh, aTag) => {
      return new Promise(aResolve => {
        try {
          aPh.clearSiteData(
            aTag,
            null,
            Ci.nsIPluginHost.FLAG_CLEAR_ALL,
            age,
            aResolve
          );
        } catch (e) {
          aResolve(Cr.NS_ERROR_PLUGIN_TIME_RANGE_NOT_SUPPORTED);
        }
      }).then(aRv => {
        // If the plugin doesn't support clearing by age, clear everything.
        if (aRv == Cr.NS_ERROR_PLUGIN_TIME_RANGE_NOT_SUPPORTED) {
          return new Promise(aResolve => {
            try {
              aPh.clearSiteData(
                aTag,
                null,
                Ci.nsIPluginHost.FLAG_CLEAR_ALL,
                -1,
                aResolve
              );
            } catch (e) {
              aResolve();
            }
          });
        }

        return true;
      });
    });
  },

  deleteAll() {
    return this._deleteInternal((aPh, aTag) => {
      return new Promise(aResolve => {
        try {
          aPh.clearSiteData(
            aTag,
            null,
            Ci.nsIPluginHost.FLAG_CLEAR_ALL,
            -1,
            aResolve
          );
        } catch (e) {
          aResolve();
        }
      });
    });
  },

  _deleteInternal(aCb) {
    let ph = Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);

    let promises = [];
    let tags = ph.getPluginTags();
    for (let tag of tags) {
      if (tag.loaded) {
        promises.push(aCb(ph, tag));
      }
    }

    // As evidenced in bug 1253204, clearing plugin data can sometimes be
    // very, very long, for mysterious reasons. Unfortunately, this is not
    // something actionable by Mozilla, so crashing here serves no purpose.
    //
    // For this reason, instead of waiting for sanitization to always
    // complete, we introduce a soft timeout. Once this timeout has
    // elapsed, we proceed with the shutdown of Firefox.
    return Promise.race([
      Promise.all(promises),
      new Promise(aResolve => setTimeout(aResolve, 10000 /* 10 seconds */)),
    ]);
  },
};

const DownloadsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return Downloads.getList(Downloads.ALL).then(aList => {
      aList.removeFinished(aDownload =>
        Services.eTLD.hasRootDomain(
          Services.io.newURI(aDownload.source.url).host,
          aHost
        )
      );
    });
  },

  deleteByRange(aFrom, aTo) {
    // Convert microseconds back to milliseconds for date comparisons.
    let rangeBeginMs = aFrom / 1000;
    let rangeEndMs = aTo / 1000;

    return Downloads.getList(Downloads.ALL).then(aList => {
      aList.removeFinished(
        aDownload =>
          aDownload.startTime >= rangeBeginMs &&
          aDownload.startTime <= rangeEndMs
      );
    });
  },

  deleteAll() {
    return Downloads.getList(Downloads.ALL).then(aList => {
      aList.removeFinished(null);
    });
  },
};

const PasswordsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return this._deleteInternal(aLogin =>
      Services.eTLD.hasRootDomain(aLogin.hostname, aHost)
    );
  },

  deleteAll() {
    return this._deleteInternal(() => true);
  },

  _deleteInternal(aCb) {
    return new Promise(aResolve => {
      try {
        let logins = Services.logins.getAllLogins();
        for (let login of logins) {
          if (aCb(login)) {
            Services.logins.removeLogin(login);
          }
        }
      } catch (ex) {
        // XXXehsan: is there a better way to do this rather than this
        // hacky comparison?
        if (
          !ex.message.includes("User canceled Master Password entry") &&
          ex.result != Cr.NS_ERROR_NOT_IMPLEMENTED
        ) {
          throw new Error("Exception occured in clearing passwords: " + ex);
        }
      }

      aResolve();
    });
  },
};

const MediaDevicesCleaner = {
  deleteByRange(aFrom, aTo) {
    return new Promise(aResolve => {
      let mediaMgr = Cc["@mozilla.org/mediaManagerService;1"].getService(
        Ci.nsIMediaManagerService
      );
      mediaMgr.sanitizeDeviceIds(aFrom);
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      let mediaMgr = Cc["@mozilla.org/mediaManagerService;1"].getService(
        Ci.nsIMediaManagerService
      );
      mediaMgr.sanitizeDeviceIds(null);
      aResolve();
    });
  },
};

const AppCacheCleaner = {
  deleteByOriginAttributes(aOriginAttributesString) {
    return new Promise(aResolve => {
      let appCacheService = Cc[
        "@mozilla.org/network/application-cache-service;1"
      ].getService(Ci.nsIApplicationCacheService);
      try {
        appCacheService.evictMatchingOriginAttributes(aOriginAttributesString);
      } catch (ex) {}
      aResolve();
    });
  },

  deleteAll() {
    // AppCache: this doesn't wait for the cleanup to be complete.
    OfflineAppCacheHelper.clear();
    return Promise.resolve();
  },
};

const QuotaCleaner = {
  deleteByPrincipal(aPrincipal) {
    // localStorage: The legacy LocalStorage implementation that will
    // eventually be removed depends on this observer notification to clear by
    // principal.
    Services.obs.notifyObservers(
      null,
      "extension:purge-localStorage",
      aPrincipal.URI.host
    );

    // Clear sessionStorage
    Services.obs.notifyObservers(
      null,
      "browser:purge-sessionStorage",
      aPrincipal.URI.host
    );

    // ServiceWorkers: they must be removed before cleaning QuotaManager.
    return ServiceWorkerCleanUp.removeFromPrincipal(aPrincipal)
      .then(
        _ => /* exceptionThrown = */ false,
        _ => /* exceptionThrown = */ true
      )
      .then(exceptionThrown => {
        // QuotaManager: In the event of a failure, we call reject to propagate
        // the error upwards.
        return new Promise((aResolve, aReject) => {
          let req = Services.qms.clearStoragesForPrincipal(aPrincipal);
          req.callback = () => {
            if (exceptionThrown || req.resultCode != Cr.NS_OK) {
              aReject({ message: "Delete by principal failed" });
            } else {
              aResolve();
            }
          };
        });
      });
  },

  deleteByHost(aHost, aOriginAttributes) {
    // XXX: The aOriginAttributes is expected to always be empty({}). Maybe have
    // a debug assertion here to ensure that?

    // localStorage: The legacy LocalStorage implementation that will
    // eventually be removed depends on this observer notification to clear by
    // host.  Some other subsystems like Reporting headers depend on this too.
    Services.obs.notifyObservers(null, "extension:purge-localStorage", aHost);

    // Clear sessionStorage
    Services.obs.notifyObservers(null, "browser:purge-sessionStorage", aHost);

    // ServiceWorkers: they must be removed before cleaning QuotaManager.
    return ServiceWorkerCleanUp.removeFromHost(aHost)
      .then(
        _ => /* exceptionThrown = */ false,
        _ => /* exceptionThrown = */ true
      )
      .then(exceptionThrown => {
        // QuotaManager: In the event of a failure, we call reject to propagate
        // the error upwards.

        // deleteByHost has the semantics that "foo.example.com" should be
        // wiped if we are provided an aHost of "example.com".
        return new Promise((aResolve, aReject) => {
          Services.qms.listOrigins().callback = aRequest => {
            if (aRequest.resultCode != Cr.NS_OK) {
              aReject({ message: "Delete by host failed" });
              return;
            }

            let promises = [];
            for (const origin of aRequest.result) {
              let principal = Services.scriptSecurityManager.createContentPrincipalFromOrigin(
                origin
              );
              let host;
              try {
                host = principal.URI.host;
              } catch (e) {
                // There is no host for the given principal.
                continue;
              }

              if (Services.eTLD.hasRootDomain(host, aHost)) {
                promises.push(
                  new Promise((aResolve, aReject) => {
                    let clearRequest = Services.qms.clearStoragesForPrincipal(
                      principal
                    );
                    clearRequest.callback = () => {
                      if (clearRequest.resultCode == Cr.NS_OK) {
                        aResolve();
                      } else {
                        aReject({ message: "Delete by host failed" });
                      }
                    };
                  })
                );
              }
            }
            Promise.all(promises).then(exceptionThrown ? aReject : aResolve);
          };
        });
      });
  },

  deleteByRange(aFrom, aTo) {
    let principals = sas
      .getActiveOrigins(aFrom, aTo)
      .QueryInterface(Ci.nsIArray);

    let promises = [];
    for (let i = 0; i < principals.length; ++i) {
      let principal = principals.queryElementAt(i, Ci.nsIPrincipal);

      if (
        !principal.schemeIs("http") &&
        !principal.schemeIs("https") &&
        !principal.schemeIs("file")
      ) {
        continue;
      }

      promises.push(this.deleteByPrincipal(principal));
    }

    return Promise.all(promises);
  },

  deleteByOriginAttributes(aOriginAttributesString) {
    // The legacy LocalStorage implementation that will eventually be removed.
    // And it should've been cleared while notifying observers with
    // clear-origin-attributes-data.

    return ServiceWorkerCleanUp.removeFromOriginAttributes(
      aOriginAttributesString
    )
      .then(
        _ => /* exceptionThrown = */ false,
        _ => /* exceptionThrown = */ true
      )
      .then(exceptionThrown => {
        // QuotaManager: In the event of a failure, we call reject to propagate
        // the error upwards.
        return new Promise((aResolve, aReject) => {
          let req = Services.qms.clearStoragesForOriginAttributesPattern(
            aOriginAttributesString
          );
          req.callback = () => {
            if (req.resultCode == Cr.NS_OK) {
              aResolve();
            } else {
              aReject({ message: "Delete by origin attributes failed" });
            }
          };
        });
      });
  },

  deleteAll() {
    // localStorage
    Services.obs.notifyObservers(null, "extension:purge-localStorage");

    // sessionStorage
    Services.obs.notifyObservers(null, "browser:purge-sessionStorage");

    // ServiceWorkers
    return ServiceWorkerCleanUp.removeAll()
      .then(
        _ => /* exceptionThrown = */ false,
        _ => /* exceptionThrown = */ true
      )
      .then(exceptionThrown => {
        // QuotaManager: In the event of a failure, we call reject to propagate
        // the error upwards.
        return new Promise((aResolve, aReject) => {
          Services.qms.getUsage(aRequest => {
            if (aRequest.resultCode != Cr.NS_OK) {
              aReject({ message: "Delete all failed" });
              return;
            }

            let promises = [];
            for (let item of aRequest.result) {
              let principal = Services.scriptSecurityManager.createContentPrincipalFromOrigin(
                item.origin
              );
              if (
                principal.schemeIs("http") ||
                principal.schemeIs("https") ||
                principal.schemeIs("file")
              ) {
                promises.push(
                  new Promise((aResolve, aReject) => {
                    let req = Services.qms.clearStoragesForPrincipal(principal);
                    req.callback = () => {
                      if (req.resultCode == Cr.NS_OK) {
                        aResolve();
                      } else {
                        aReject({ message: "Delete all failed" });
                      }
                    };
                  })
                );
              }
            }

            Promise.all(promises).then(exceptionThrown ? aReject : aResolve);
          });
        });
      });
  },
};

const PredictorNetworkCleaner = {
  deleteAll() {
    // Predictive network data - like cache, no way to clear this per
    // domain, so just trash it all
    let np = Cc["@mozilla.org/network/predictor;1"].getService(
      Ci.nsINetworkPredictor
    );
    np.reset();
    return Promise.resolve();
  },
};

const PushNotificationsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    if (!Services.prefs.getBoolPref("dom.push.enabled", false)) {
      return Promise.resolve();
    }

    return new Promise((aResolve, aReject) => {
      let push = Cc["@mozilla.org/push/Service;1"].getService(
        Ci.nsIPushService
      );
      push.clearForDomain(aHost, aStatus => {
        if (!Components.isSuccessCode(aStatus)) {
          aReject();
        } else {
          aResolve();
        }
      });
    });
  },

  deleteAll() {
    if (!Services.prefs.getBoolPref("dom.push.enabled", false)) {
      return Promise.resolve();
    }

    return new Promise((aResolve, aReject) => {
      let push = Cc["@mozilla.org/push/Service;1"].getService(
        Ci.nsIPushService
      );
      push.clearForDomain("*", aStatus => {
        if (!Components.isSuccessCode(aStatus)) {
          aReject();
        } else {
          aResolve();
        }
      });
    });
  },
};

const StorageAccessCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      for (let perm of Services.perms.all) {
        if (perm.type == "storageAccessAPI") {
          let toBeRemoved = false;
          try {
            toBeRemoved = Services.eTLD.hasRootDomain(
              perm.principal.URI.host,
              aHost
            );
          } catch (ex) {
            continue;
          }
          if (!toBeRemoved) {
            continue;
          }

          try {
            Services.perms.removePermission(perm);
          } catch (ex) {
            Cu.reportError(ex);
          }
        }
      }

      aResolve();
    });
  },

  deleteByRange(aFrom, aTo) {
    Services.perms.removeByTypeSince("storageAccessAPI", aFrom / 1000);
    return Promise.resolve();
  },

  deleteAll() {
    Services.perms.removeByType("storageAccessAPI");
    return Promise.resolve();
  },
};

const HistoryCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    if (!AppConstants.MOZ_PLACES) {
      return Promise.resolve();
    }
    return PlacesUtils.history.removeByFilter({ host: "." + aHost });
  },

  deleteByRange(aFrom, aTo) {
    if (!AppConstants.MOZ_PLACES) {
      return Promise.resolve();
    }
    return PlacesUtils.history.removeVisitsByFilter({
      beginDate: new Date(aFrom / 1000),
      endDate: new Date(aTo / 1000),
    });
  },

  deleteAll() {
    if (!AppConstants.MOZ_PLACES) {
      return Promise.resolve();
    }
    return PlacesUtils.history.clear();
  },
};

const SessionHistoryCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(null, "browser:purge-sessionStorage", aHost);
      Services.obs.notifyObservers(
        null,
        "browser:purge-session-history-for-domain",
        aHost
      );
      aResolve();
    });
  },

  deleteByRange(aFrom, aTo) {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(
        null,
        "browser:purge-session-history",
        String(aFrom)
      );
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(null, "browser:purge-session-history");
      aResolve();
    });
  },
};

const AuthTokensCleaner = {
  deleteAll() {
    return new Promise(aResolve => {
      let sdr = Cc["@mozilla.org/security/sdr;1"].getService(
        Ci.nsISecretDecoderRing
      );
      sdr.logoutAndTeardown();
      aResolve();
    });
  },
};

const AuthCacheCleaner = {
  deleteAll() {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(null, "net:clear-active-logins");
      aResolve();
    });
  },
};

const PermissionsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      for (let perm of Services.perms.all) {
        let toBeRemoved;
        try {
          toBeRemoved = Services.eTLD.hasRootDomain(
            perm.principal.URI.host,
            aHost
          );
        } catch (ex) {
          continue;
        }

        if (!toBeRemoved && perm.type.startsWith("3rdPartyStorage^")) {
          let parts = perm.type.split("^");
          let uri;
          try {
            uri = Services.io.newURI(parts[1]);
          } catch (ex) {
            continue;
          }

          toBeRemoved = Services.eTLD.hasRootDomain(uri.host, aHost);
        }

        if (!toBeRemoved) {
          continue;
        }

        try {
          Services.perms.removePermission(perm);
        } catch (ex) {
          // Ignore entry
        }
      }

      aResolve();
    });
  },

  deleteByRange(aFrom, aTo) {
    Services.perms.removeAllSince(aFrom / 1000);
    return Promise.resolve();
  },

  deleteByOriginAttributes(aOriginAttributesString) {
    Services.perms.removePermissionsWithAttributes(aOriginAttributesString);
    return Promise.resolve();
  },

  deleteAll() {
    Services.perms.removeAll();
    return Promise.resolve();
  },
};

const PreferencesCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise((aResolve, aReject) => {
      let cps2 = Cc["@mozilla.org/content-pref/service;1"].getService(
        Ci.nsIContentPrefService2
      );
      cps2.removeBySubdomain(aHost, null, {
        handleCompletion: aReason => {
          if (aReason === cps2.COMPLETE_ERROR) {
            aReject();
          } else {
            aResolve();
          }
        },
        handleError() {},
      });
    });
  },

  deleteByRange(aFrom, aTo) {
    return new Promise(aResolve => {
      let cps2 = Cc["@mozilla.org/content-pref/service;1"].getService(
        Ci.nsIContentPrefService2
      );
      cps2.removeAllDomainsSince(aFrom / 1000, null);
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      let cps2 = Cc["@mozilla.org/content-pref/service;1"].getService(
        Ci.nsIContentPrefService2
      );
      cps2.removeAllDomains(null);
      aResolve();
    });
  },
};

const SecuritySettingsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      let sss = Cc["@mozilla.org/ssservice;1"].getService(
        Ci.nsISiteSecurityService
      );
      // Also remove HSTS information for subdomains by enumerating
      // the information in the site security service.
      for (let entry of sss.enumerate(Ci.nsISiteSecurityService.HEADER_HSTS)) {
        let hostname = entry.hostname;
        if (Services.eTLD.hasRootDomain(hostname, aHost)) {
          // This uri is used as a key to reset the state.
          let uri = Services.io.newURI("https://" + hostname);
          sss.resetState(
            Ci.nsISiteSecurityService.HEADER_HSTS,
            uri,
            0,
            entry.originAttributes
          );
        }
      }

      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      // Clear site security settings - no support for ranges in this
      // interface either, so we clearAll().
      let sss = Cc["@mozilla.org/ssservice;1"].getService(
        Ci.nsISiteSecurityService
      );
      sss.clearAll();
      aResolve();
    });
  },
};

const EMECleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      let mps = Cc["@mozilla.org/gecko-media-plugin-service;1"].getService(
        Ci.mozIGeckoMediaPluginChromeService
      );
      mps.forgetThisSite(aHost, JSON.stringify(aOriginAttributes));
      aResolve();
    });
  },

  deleteAll() {
    // Not implemented.
    return Promise.resolve();
  },
};

const ReportsCleaner = {
  deleteByHost(aHost, aOriginAttributes) {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(null, "reporting:purge-host", aHost);
      aResolve();
    });
  },

  deleteAll() {
    return new Promise(aResolve => {
      Services.obs.notifyObservers(null, "reporting:purge-all");
      aResolve();
    });
  },
};

const ContentBlockingCleaner = {
  deleteAll() {
    return TrackingDBService.clearAll();
  },

  deleteByRange(aFrom, aTo) {
    return TrackingDBService.clearSince(aFrom);
  },
};

// Here the map of Flags-Cleaner.
const FLAGS_MAP = [
  { flag: Ci.nsIClearDataService.CLEAR_CERT_EXCEPTIONS, cleaner: CertCleaner },

  { flag: Ci.nsIClearDataService.CLEAR_COOKIES, cleaner: CookieCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_NETWORK_CACHE,
    cleaner: NetworkCacheCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_IMAGE_CACHE,
    cleaner: ImageCacheCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_PLUGIN_DATA,
    cleaner: PluginDataCleaner,
  },

  { flag: Ci.nsIClearDataService.CLEAR_DOWNLOADS, cleaner: DownloadsCleaner },

  { flag: Ci.nsIClearDataService.CLEAR_PASSWORDS, cleaner: PasswordsCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_MEDIA_DEVICES,
    cleaner: MediaDevicesCleaner,
  },

  { flag: Ci.nsIClearDataService.CLEAR_APPCACHE, cleaner: AppCacheCleaner },

  { flag: Ci.nsIClearDataService.CLEAR_DOM_QUOTA, cleaner: QuotaCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_PREDICTOR_NETWORK_DATA,
    cleaner: PredictorNetworkCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_DOM_PUSH_NOTIFICATIONS,
    cleaner: PushNotificationsCleaner,
  },

  { flag: Ci.nsIClearDataService.CLEAR_HISTORY, cleaner: HistoryCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_SESSION_HISTORY,
    cleaner: SessionHistoryCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_AUTH_TOKENS,
    cleaner: AuthTokensCleaner,
  },

  { flag: Ci.nsIClearDataService.CLEAR_AUTH_CACHE, cleaner: AuthCacheCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_PERMISSIONS,
    cleaner: PermissionsCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_CONTENT_PREFERENCES,
    cleaner: PreferencesCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_SECURITY_SETTINGS,
    cleaner: SecuritySettingsCleaner,
  },

  { flag: Ci.nsIClearDataService.CLEAR_EME, cleaner: EMECleaner },

  { flag: Ci.nsIClearDataService.CLEAR_REPORTS, cleaner: ReportsCleaner },

  {
    flag: Ci.nsIClearDataService.CLEAR_STORAGE_ACCESS,
    cleaner: StorageAccessCleaner,
  },

  {
    flag: Ci.nsIClearDataService.CLEAR_CONTENT_BLOCKING_RECORDS,
    cleaner: ContentBlockingCleaner,
  },
];

this.ClearDataService = function() {
  this._initialize();
};

ClearDataService.prototype = Object.freeze({
  classID: Components.ID("{0c06583d-7dd8-4293-b1a5-912205f779aa}"),
  QueryInterface: ChromeUtils.generateQI([Ci.nsIClearDataService]),
  _xpcom_factory: XPCOMUtils.generateSingletonFactory(ClearDataService),

  _initialize() {
    // Let's start all the service we need to cleanup data.

    // This is mainly needed for GeckoView that doesn't start QMS on startup
    // time.
    if (!Services.qms) {
      Cu.reportError("Failed initializiation of QuotaManagerService.");
    }
  },

  deleteDataFromLocalFiles(aIsUserRequest, aFlags, aCallback) {
    if (!aCallback) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    return this._deleteInternal(aFlags, aCallback, aCleaner => {
      // Some of the 'Cleaners' do not support clearing data for
      // local files. Ignore those.
      if (aCleaner.deleteByLocalFiles) {
        // A generic originAttributes dictionary.
        return aCleaner.deleteByLocalFiles({});
      }
      return Promise.resolve();
    });
  },

  deleteDataFromHost(aHost, aIsUserRequest, aFlags, aCallback) {
    if (!aHost || !aCallback) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    return this._deleteInternal(aFlags, aCallback, aCleaner => {
      // Some of the 'Cleaners' do not support to delete by principal. Let's
      // use deleteAll() as fallback.
      if (aCleaner.deleteByHost) {
        // A generic originAttributes dictionary.
        return aCleaner.deleteByHost(aHost, {});
      }
      // The user wants to delete data. Let's remove as much as we can.
      if (aIsUserRequest) {
        return aCleaner.deleteAll();
      }
      // We don't want to delete more than what is strictly required.
      return Promise.resolve();
    });
  },

  deleteDataFromPrincipal(aPrincipal, aIsUserRequest, aFlags, aCallback) {
    if (!aPrincipal || !aCallback) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    return this._deleteInternal(aFlags, aCallback, aCleaner => {
      if (aCleaner.deleteByPrincipal) {
        return aCleaner.deleteByPrincipal(aPrincipal);
      }
      // Some of the 'Cleaners' do not support to delete by principal. Fallback
      // is to delete by host.
      if (aCleaner.deleteByHost) {
        return aCleaner.deleteByHost(
          aPrincipal.URI.host,
          aPrincipal.originAttributes
        );
      }
      // Next fallback is to use deleteAll(), but only if this was a user request.
      if (aIsUserRequest) {
        return aCleaner.deleteAll();
      }
      // We don't want to delete more than what is strictly required.
      return Promise.resolve();
    });
  },

  deleteDataInTimeRange(aFrom, aTo, aIsUserRequest, aFlags, aCallback) {
    if (aFrom > aTo || !aCallback) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    return this._deleteInternal(aFlags, aCallback, aCleaner => {
      // Some of the 'Cleaners' do not support to delete by range. Let's use
      // deleteAll() as fallback.
      if (aCleaner.deleteByRange) {
        return aCleaner.deleteByRange(aFrom, aTo);
      }
      // The user wants to delete data. Let's remove as much as we can.
      if (aIsUserRequest) {
        return aCleaner.deleteAll();
      }
      // We don't want to delete more than what is strictly required.
      return Promise.resolve();
    });
  },

  deleteData(aFlags, aCallback) {
    if (!aCallback) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    return this._deleteInternal(aFlags, aCallback, aCleaner => {
      return aCleaner.deleteAll();
    });
  },

  deleteDataFromOriginAttributesPattern(aPattern, aCallback) {
    if (!aPattern) {
      return Cr.NS_ERROR_INVALID_ARG;
    }

    let patternString = JSON.stringify(aPattern);
    // XXXtt remove clear-origin-attributes-data entirely
    Services.obs.notifyObservers(
      null,
      "clear-origin-attributes-data",
      patternString
    );

    if (!aCallback) {
      aCallback = {
        onDataDeleted: () => {},
      };
    }
    return this._deleteInternal(
      Ci.nsIClearDataService.CLEAR_ALL,
      aCallback,
      aCleaner => {
        if (aCleaner.deleteByOriginAttributes) {
          return aCleaner.deleteByOriginAttributes(patternString);
        }

        // We don't want to delete more than what is strictly required.
        return Promise.resolve();
      }
    );
  },

  // This internal method uses aFlags against FLAGS_MAP in order to retrieve a
  // list of 'Cleaners'. For each of them, the aHelper callback retrieves a
  // promise object. All these promise objects are resolved before calling
  // onDataDeleted.
  _deleteInternal(aFlags, aCallback, aHelper) {
    let resultFlags = 0;
    let promises = FLAGS_MAP.filter(c => aFlags & c.flag).map(c => {
      // Let's collect the failure in resultFlags.
      return aHelper(c.cleaner).catch(e => {
        Cu.reportError(e);
        resultFlags |= c.flag;
      });
    });
    Promise.all(promises).then(() => {
      aCallback.onDataDeleted(resultFlags);
    });
    return Cr.NS_OK;
  },
});

var EXPORTED_SYMBOLS = ["ClearDataService"];
