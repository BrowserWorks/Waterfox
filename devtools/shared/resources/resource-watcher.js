/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const EventEmitter = require("devtools/shared/event-emitter");
const Services = require("Services");

class ResourceWatcher {
  /**
   * This class helps retrieving existing and listening to resources.
   * A resource is something that:
   *  - the target you are debugging exposes
   *  - can be created as early as the process/worker/page starts loading
   *  - can already exist, or will be created later on
   *  - doesn't require any user data to be fetched, only a type/category
   *
   * @param {TargetList} targetList
   *        A TargetList instance, which helps communicating to the backend
   *        in order to iterate and listen over the requested resources.
   */

  constructor(targetList) {
    this.targetList = targetList;

    this._onTargetAvailable = this._onTargetAvailable.bind(this);
    this._onTargetDestroyed = this._onTargetDestroyed.bind(this);

    this._onResourceAvailable = this._onResourceAvailable.bind(this);

    this._availableListeners = new EventEmitter();
    this._destroyedListeners = new EventEmitter();

    // Cache for all resources by the order that the resource was taken.
    this._cache = [];
    this._listenerCount = new Map();
  }

  get contentToolboxFissionPrefValue() {
    if (!this._contentToolboxFissionPrefValue) {
      this._contentToolboxFissionPrefValue = Services.prefs.getBoolPref(
        "devtools.contenttoolbox.fission",
        false
      );
    }
    return this._contentToolboxFissionPrefValue;
  }

  /**
   * Request to start retrieving all already existing instances of given
   * type of resources and also start watching for the one to be created after.
   *
   * @param {Array:string} resources
   *        List of all resources which should be fetched and observed.
   * @param {Object} options
   *        - {Function} onAvailable: This attribute is mandatory.
   *                                  Function which will be called once per existing
   *                                  resource and each time a resource is created.
   *        - {Function} onDestroyed: This attribute is optional.
   *                                  Function which will be called each time a resource in
   *                                  the remote target is destroyed.
   *        - {boolean} ignoreExistingResources:
   *                                  This attribute is optional. Default value is false.
   *                                  If set to true, onAvailable won't be called with
   *                                  existing resources.
   */
  async watchResources(resources, options) {
    const { onAvailable, ignoreExistingResources = false } = options;

    // First ensuring enabling listening to targets.
    // This will call onTargetAvailable for all already existing targets,
    // as well as for the one created later.
    // Do this *before* calling _startListening in order to register
    // "resource-available" listener before requesting for the resources in _startListening.
    await this._watchAllTargets();

    for (const resource of resources) {
      await this._startListening(resource);
      this._registerListeners(resource, options);
    }

    if (!ignoreExistingResources) {
      await this._forwardCachedResources(resources, onAvailable);
    }
  }

  /**
   * Stop watching for given type of resources.
   * See `watchResources` for the arguments as both methods receive the same.
   */
  unwatchResources(resources, options) {
    const { onAvailable, onDestroyed } = options;

    for (const resource of resources) {
      this._availableListeners.off(resource, onAvailable);
      if (onDestroyed) {
        this._destroyedListeners.off(resource, onDestroyed);
      }
      this._stopListening(resource);
    }

    // Stop watching for targets if we removed the last listener.
    let listeners = 0;
    for (const count of this._listenerCount) {
      listeners += count;
    }
    if (listeners <= 0) {
      this._unwatchAllTargets();
    }
  }

  /**
   * Register listeners to watch for a given type of resource.
   *
   * @param {Object}
   *        - {Function} onAvailable: mandatory
   *        - {Function} onDestroyed: optional
   */
  _registerListeners(resource, { onAvailable, onDestroyed }) {
    this._availableListeners.on(resource, onAvailable);
    if (onDestroyed) {
      this._destroyedListeners.on(resource, onDestroyed);
    }
  }

  /**
   * Start watching for all already existing and future targets.
   *
   * We are using ALL_TYPES, but this won't force listening to all types.
   * It will only listen for types which are defined by `TargetList.startListening`.
   */
  async _watchAllTargets() {
    if (this._isWatchingTargets) {
      return;
    }
    this._isWatchingTargets = true;
    await this.targetList.watchTargets(
      this.targetList.ALL_TYPES,
      this._onTargetAvailable,
      this._onTargetDestroyed
    );
  }

  async _unwatchAllTargets() {
    if (!this._isWatchingTargets) {
      return;
    }
    this._isWatchingTargets = false;
    await this.targetList.unwatchTargets(
      this.targetList.ALL_TYPES,
      this._onTargetAvailable,
      this._onTargetDestroyed
    );
  }

  /**
   * Method called by the TargetList for each already existing or target which has just been created.
   *
   * @param {Front} targetFront
   *        The Front of the target that is available.
   *        This Front inherits from TargetMixin and is typically
   *        composed of a BrowsingContextTargetFront or ContentProcessTargetFront.
   */
  async _onTargetAvailable({ targetFront, isTargetSwitching }) {
    if (isTargetSwitching) {
      this._onWillNavigate(targetFront);
    }

    targetFront.on("will-navigate", () => this._onWillNavigate(targetFront));

    // For each resource type...
    for (const resourceType of Object.values(ResourceWatcher.TYPES)) {
      // ...which has at least one listener...
      if (!this._listenerCount.get(resourceType)) {
        continue;
      }
      // ...request existing resource and new one to come from this one target
      await this._watchResourcesForTarget(targetFront, resourceType);
    }
  }

  /**
   * Method called by the TargetList when a target has just been destroyed
   * See _onTargetAvailable for arguments, they are the same.
   */
  _onTargetDestroyed({ targetFront }) {
    //TODO: Is there a point in doing anything?
    //
    // We could remove the available/destroyed event, but as the target is destroyed
    // its listeners will be destroyed anyway.
  }

  /**
   * Method called either by:
   * - the backward compatibility code (LegacyListeners)
   * - target actors RDP events
   * whenever an already existing resource is being listed or when a new one
   * has been created.
   *
   * @param {Front} targetFront
   *        The Target Front from which this resource comes from.
   * @param {Array<json/Front>} resources
   *        Depending on the resource Type, it can be an Array composed of either JSON objects or Fronts,
   *        which describes the resource.
   */
  _onResourceAvailable(targetFront, resources) {
    for (const resource of resources) {
      // Put the targetFront on the resource for easy retrieval.
      if (!resource.targetFront) {
        resource.targetFront = targetFront;
      }
      const { resourceType } = resource;

      this._availableListeners.emit(resourceType, {
        // XXX: We may want to read resource.resourceType instead of passing this resourceType argument?
        resourceType,
        targetFront,
        resource,
      });

      this._cache.push(resource);
    }
  }

  /**
   * Called everytime a resource is destroyed in the remote target.
   * See _onResourceAvailable for the argument description.
   *
   * XXX: No usage of this yet. May be useful for the inspector? sources?
   */
  _onResourceDestroyed(targetFront, resourceType, resource) {
    const index = this._cache.indexOf(resource);
    if (index >= 0) {
      this._cache.splice(index, 1);
    }

    this._destroyedListeners.emit(resourceType, {
      resourceType,
      targetFront,
      resource,
    });
  }

  _onWillNavigate(targetFront) {
    if (targetFront.isTopLevel) {
      this._cache = [];
      return;
    }

    this._cache = this._cache.filter(
      cachedResource => cachedResource.targetFront !== targetFront
    );
  }

  /**
   * Start listening for a given type of resource.
   * For backward compatibility code, we register the legacy listeners on
   * each individual target
   *
   * @param {String} resourceType
   *        One string of ResourceWatcher.TYPES, which designates the types of resources
   *        to be listened.
   */
  async _startListening(resourceType) {
    let listeners = this._listenerCount.get(resourceType) || 0;
    listeners++;
    this._listenerCount.set(resourceType, listeners);

    if (listeners > 1) {
      return;
    }

    // If this is the first listener for this type of resource,
    // we should go through all the existing targets as onTargetAvailable
    // has already been called for these existing targets.
    const promises = [];
    const targets = this.targetList.getAllTargets(this.targetList.ALL_TYPES);
    for (const target of targets) {
      promises.push(this._watchResourcesForTarget(target, resourceType));
    }
    await Promise.all(promises);
  }

  async _forwardCachedResources(resourceTypes, onAvailable) {
    for (const resource of this._cache) {
      if (resourceTypes.includes(resource.resourceType)) {
        await onAvailable({
          resourceType: resource.resourceType,
          targetFront: resource.targetFront,
          resource,
        });
      }
    }
  }

  /**
   * Call backward compatibility code from `LegacyListeners` in order to listen for a given
   * type of resource from a given target.
   */
  _watchResourcesForTarget(targetFront, resourceType) {
    const onAvailable = this._onResourceAvailable.bind(this, targetFront);
    return LegacyListeners[resourceType]({
      targetList: this.targetList,
      targetFront,
      isFissionEnabledOnContentToolbox: this.contentToolboxFissionPrefValue,
      onAvailable,
    });
  }

  /**
   * Reverse of _startListening. Stop listening for a given type of resource.
   * For backward compatibility, we unregister from each individual target.
   */
  _stopListening(resourceType) {
    let listeners = this._listenerCount.get(resourceType);
    if (!listeners || listeners <= 0) {
      throw new Error(
        `Stopped listening for resource '${resourceType}' that isn't being listened to`
      );
    }
    listeners--;
    this._listenerCount.set(resourceType, listeners);
    if (listeners > 0) {
      return;
    }

    // Clear the cached resources of the type.
    this._cache = this._cache.filter(
      cachedResource => cachedResource.resourceType !== resourceType
    );

    // If this was the last listener, we should stop watching these events from the actors
    // and the actors should stop watching things from the platform
    const targets = this.targetList.getAllTargets(this.targetList.ALL_TYPES);
    for (const target of targets) {
      this._unwatchResourcesForTarget(target, resourceType);
    }
  }

  /**
   * Backward compatibility code, reverse of _watchResourcesForTarget.
   */
  _unwatchResourcesForTarget(targetFront, resourceType) {
    // Is there really a point in:
    // - unregistering `onAvailable` RDP event callbacks from target-scoped actors?
    // - calling `stopListeners()` as we are most likely closing the toolbox and destroying everything?
    //
    // It is important to keep this method synchronous and do as less as possible
    // in the case of toolbox destroy.
    //
    // We are aware of one case where that might be useful.
    // When a panel is disabled via the options panel, after it has been opened.
    // Would that justify doing this? Is there another usecase?
  }
}

ResourceWatcher.TYPES = ResourceWatcher.prototype.TYPES = {
  CONSOLE_MESSAGE: "console-message",
  ERROR_MESSAGE: "error-message",
  PLATFORM_MESSAGE: "platform-message",
  DOCUMENT_EVENT: "document-event",
  ROOT_NODE: "root-node",
};
module.exports = { ResourceWatcher };

// Backward compat code for each type of resource.
// Each section added here should eventually be removed once the equivalent server
// code is implement in Firefox, in its release channel.
const LegacyListeners = {
  [ResourceWatcher.TYPES
    .CONSOLE_MESSAGE]: require("devtools/shared/resources/legacy-listeners/console-messages"),
  [ResourceWatcher.TYPES
    .ERROR_MESSAGE]: require("devtools/shared/resources/legacy-listeners/error-messages"),
  [ResourceWatcher.TYPES
    .PLATFORM_MESSAGE]: require("devtools/shared/resources/legacy-listeners/platform-messages"),
  async [ResourceWatcher.TYPES.DOCUMENT_EVENT]({
    targetList,
    targetFront,
    onAvailable,
  }) {
    // DocumentEventsListener of webconsole handles only top level document.
    if (!targetFront.isTopLevel) {
      return;
    }

    const webConsoleFront = await targetFront.getFront("console");
    webConsoleFront.on("documentEvent", event => {
      event.resourceType = ResourceWatcher.TYPES.DOCUMENT_EVENT;
      onAvailable([event]);
    });
    await webConsoleFront.startListeners(["DocumentEvents"]);
  },
  [ResourceWatcher.TYPES
    .ROOT_NODE]: require("devtools/shared/resources/legacy-listeners/root-node"),
};
