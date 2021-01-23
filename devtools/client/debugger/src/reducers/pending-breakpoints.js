/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

// @flow

/**
 * Pending breakpoints reducer
 * @module reducers/pending-breakpoints
 */

import {
  createPendingBreakpoint,
  makePendingLocationId,
} from "../utils/breakpoint";

import { isPrettyURL } from "../utils/source";

import type { SourcesState } from "./sources";
import type { PendingBreakpoint, Source } from "../types";
import type { Action } from "../actions/types";

export type PendingBreakpointsState = { [string]: PendingBreakpoint };

function update(state: PendingBreakpointsState = {}, action: Action) {
  switch (action.type) {
    case "SET_BREAKPOINT":
      return setBreakpoint(state, action);

    case "REMOVE_BREAKPOINT":
      if (action.status === "start") {
        return removeBreakpoint(state, action);
      }
      return state;

    case "REMOVE_PENDING_BREAKPOINT":
      return removeBreakpoint(state, action);

    case "REMOVE_BREAKPOINTS": {
      return {};
    }
  }

  return state;
}

function setBreakpoint(state, { breakpoint }) {
  if (breakpoint.options.hidden) {
    return state;
  }
  const location =
    !breakpoint.location.sourceUrl || isPrettyURL(breakpoint.location.sourceUrl)
      ? breakpoint.generatedLocation
      : breakpoint.location;
  const locationId = makePendingLocationId(location);
  const pendingBreakpoint = createPendingBreakpoint(breakpoint);

  return { ...state, [locationId]: pendingBreakpoint };
}

function removeBreakpoint(state, { location }) {
  const locationId = makePendingLocationId(location);
  state = { ...state };

  delete state[locationId];
  return state;
}

// Selectors
// TODO: these functions should be moved out of the reducer

type OuterState = {
  pendingBreakpoints: PendingBreakpointsState,
  sources: SourcesState,
};

export function getPendingBreakpoints(state: OuterState) {
  return state.pendingBreakpoints;
}

export function getPendingBreakpointList(
  state: OuterState
): PendingBreakpoint[] {
  return (Object.values(getPendingBreakpoints(state)): any);
}

export function getPendingBreakpointsForSource(
  state: OuterState,
  source: Source
): PendingBreakpoint[] {
  return getPendingBreakpointList(state).filter(pendingBreakpoint => {
    return (
      pendingBreakpoint.location.sourceUrl === source.url ||
      pendingBreakpoint.generatedLocation.sourceUrl == source.url
    );
  });
}

export default update;
