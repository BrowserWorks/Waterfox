/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is
 * https://wicg.github.io/ResizeObserver/
 */

[Constructor(ResizeObserverCallback callback),
 Exposed=Window,
 Pref="layout.css.resizeobserver.enabled"]
interface ResizeObserver {
    [Throws]
    void observe(Element? target);
    [Throws]
    void unobserve(Element? target);
    void disconnect();
};

callback ResizeObserverCallback = void (sequence<ResizeObserverEntry> entries, ResizeObserver observer);

[Constructor(Element? target),
 ChromeOnly,
 Pref="layout.css.resizeobserver.enabled"]
interface ResizeObserverEntry {
    readonly attribute Element target;
    readonly attribute DOMRectReadOnly? contentRect;
};

[Constructor(Element? target),
 ChromeOnly,
 Pref="layout.css.resizeobserver.enabled"]
interface ResizeObservation {
    readonly attribute Element target;
    readonly attribute long broadcastWidth;
    readonly attribute long broadcastHeight;
    boolean isActive();
};
