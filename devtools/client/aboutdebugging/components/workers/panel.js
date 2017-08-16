/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* globals window */
"use strict";

loader.lazyImporter(this, "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm");

const { Ci } = require("chrome");
const { createClass, createFactory, DOM: dom, PropTypes } =
  require("devtools/client/shared/vendor/react");
const { getWorkerForms } = require("../../modules/worker");
const Services = require("Services");

const PanelHeader = createFactory(require("../panel-header"));
const TargetList = createFactory(require("../target-list"));
const WorkerTarget = createFactory(require("./target"));
const MultiE10SWarning = createFactory(require("./multi-e10s-warning"));
const ServiceWorkerTarget = createFactory(require("./service-worker-target"));

loader.lazyImporter(this, "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm");

loader.lazyRequireGetter(this, "DebuggerClient",
  "devtools/shared/client/main", true);

const Strings = Services.strings.createBundle(
  "chrome://devtools/locale/aboutdebugging.properties");

const WorkerIcon = "chrome://devtools/skin/images/debugging-workers.svg";
const MORE_INFO_URL = "https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging" +
                      "#Service_workers_not_compatible";
const PROCESS_COUNT_PREF = "dom.ipc.processCount";
const MULTI_OPTOUT_PREF = "dom.ipc.multiOptOut";

module.exports = createClass({
  displayName: "WorkersPanel",

  propTypes: {
    client: PropTypes.instanceOf(DebuggerClient).isRequired,
    id: PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      workers: {
        service: [],
        shared: [],
        other: []
      },
      processCount: 1,
    };
  },

  componentDidMount() {
    let client = this.props.client;
    client.addListener("workerListChanged", this.updateWorkers);
    client.addListener("serviceWorkerRegistrationListChanged", this.updateWorkers);
    client.addListener("processListChanged", this.updateWorkers);
    client.addListener("registration-changed", this.updateWorkers);

    // Some notes about these observers:
    // - nsIPrefBranch.addObserver observes prefixes. In reality, watching
    //   PROCESS_COUNT_PREF watches two separate prefs:
    //   dom.ipc.processCount *and* dom.ipc.processCount.web. Because these
    //   are the two ways that we control the number of content processes,
    //   that works perfectly fine.
    // - The user might opt in or out of multi by setting the multi opt out
    //   pref. That affects whether we need to show our warning, so we need to
    //   update our state when that pref changes.
    // - In all cases, we don't have to manually check which pref changed to
    //   what. The platform code in nsIXULRuntime.maxWebProcessCount does all
    //   of that for us.
    Services.prefs.addObserver(PROCESS_COUNT_PREF, this.updateMultiE10S);
    Services.prefs.addObserver(MULTI_OPTOUT_PREF, this.updateMultiE10S);

    this.updateMultiE10S();
    this.updateWorkers();
  },

  componentWillUnmount() {
    let client = this.props.client;
    client.removeListener("processListChanged", this.updateWorkers);
    client.removeListener("serviceWorkerRegistrationListChanged", this.updateWorkers);
    client.removeListener("workerListChanged", this.updateWorkers);
    client.removeListener("registration-changed", this.updateWorkers);

    Services.prefs.removeObserver(PROCESS_COUNT_PREF, this.updateMultiE10S);
    Services.prefs.removeObserver(MULTI_OPTOUT_PREF, this.updateMultiE10S);
  },

  updateMultiE10S() {
    // We watch the pref but set the state based on
    // nsIXULRuntime.maxWebProcessCount.
    let processCount = Services.appinfo.maxWebProcessCount;
    this.setState({ processCount });
  },

  updateWorkers() {
    let workers = this.getInitialState().workers;

    getWorkerForms(this.props.client).then(forms => {
      forms.registrations.forEach(form => {
        workers.service.push({
          icon: WorkerIcon,
          name: form.url,
          url: form.url,
          scope: form.scope,
          fetch: form.fetch,
          registrationActor: form.actor,
          active: form.active
        });
      });

      forms.workers.forEach(form => {
        let worker = {
          icon: WorkerIcon,
          name: form.url,
          url: form.url,
          workerActor: form.actor
        };
        switch (form.type) {
          case Ci.nsIWorkerDebugger.TYPE_SERVICE:
            let registration = this.getRegistrationForWorker(form, workers.service);
            if (registration) {
              // XXX: Race, sometimes a ServiceWorkerRegistrationInfo doesn't
              // have a scriptSpec, but its associated WorkerDebugger does.
              if (!registration.url) {
                registration.name = registration.url = form.url;
              }
              registration.workerActor = form.actor;
            } else {
              worker.fetch = form.fetch;

              // If a service worker registration could not be found, this means we are in
              // e10s, and registrations are not forwarded to other processes until they
              // reach the activated state. Augment the worker as a registration worker to
              // display it in aboutdebugging.
              worker.scope = form.scope;
              worker.active = false;
              workers.service.push(worker);
            }
            break;
          case Ci.nsIWorkerDebugger.TYPE_SHARED:
            workers.shared.push(worker);
            break;
          default:
            workers.other.push(worker);
        }
      });

      // XXX: Filter out the service worker registrations for which we couldn't
      // find the scriptSpec.
      workers.service = workers.service.filter(reg => !!reg.url);

      this.setState({ workers });
    });
  },

  getRegistrationForWorker(form, registrations) {
    for (let registration of registrations) {
      if (registration.scope === form.scope) {
        return registration;
      }
    }
    return null;
  },

  isE10S() {
    return Services.appinfo.browserTabsRemoteAutostart;
  },

  renderServiceWorkersError() {
    let isWindowPrivate = PrivateBrowsingUtils.isContentWindowPrivate(window);
    let isPrivateBrowsingMode = PrivateBrowsingUtils.permanentPrivateBrowsing;
    let isServiceWorkerDisabled = !Services.prefs
                                    .getBoolPref("dom.serviceWorkers.enabled");

    let isDisabled = isWindowPrivate || isPrivateBrowsingMode || isServiceWorkerDisabled;
    if (!isDisabled) {
      return "";
    }
    return dom.p(
      {
        className: "service-worker-disabled"
      },
      dom.div({ className: "warning" }),
      dom.span(
        {
          className: "service-worker-disabled-label",
        },
        Strings.GetStringFromName("configurationIsNotCompatible.label")
      ),
      dom.a(
        {
          href: MORE_INFO_URL,
          target: "_blank"
        },
        Strings.GetStringFromName("configurationIsNotCompatible.learnMore")
      ),
    );
  },

  render() {
    let { client, id } = this.props;
    let { workers, processCount } = this.state;

    let isE10S = Services.appinfo.browserTabsRemoteAutostart;
    let isMultiE10S = isE10S && processCount > 1;

    return dom.div(
      {
        id: id + "-panel",
        className: "panel",
        role: "tabpanel",
        "aria-labelledby": id + "-header"
      },
      PanelHeader({
        id: id + "-header",
        name: Strings.GetStringFromName("workers")
      }),
      isMultiE10S ? MultiE10SWarning() : "",
      dom.div(
        {
          id: "workers",
          className: "inverted-icons"
        },
        TargetList({
          client,
          debugDisabled: isMultiE10S,
          error: this.renderServiceWorkersError(),
          id: "service-workers",
          name: Strings.GetStringFromName("serviceWorkers"),
          sort: true,
          targetClass: ServiceWorkerTarget,
          targets: workers.service
        }),
        TargetList({
          client,
          id: "shared-workers",
          name: Strings.GetStringFromName("sharedWorkers"),
          sort: true,
          targetClass: WorkerTarget,
          targets: workers.shared
        }),
        TargetList({
          client,
          id: "other-workers",
          name: Strings.GetStringFromName("otherWorkers"),
          sort: true,
          targetClass: WorkerTarget,
          targets: workers.other
        })
      )
    );
  }
});
