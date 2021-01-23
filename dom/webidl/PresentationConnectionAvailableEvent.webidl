/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is
 * https://w3c.github.io/presentation-api/#interface-presentationconnectionavailableevent
 */

[Pref="dom.presentation.enabled",
 Exposed=Window]
interface PresentationConnectionAvailableEvent : Event
{
  constructor(DOMString type,
              PresentationConnectionAvailableEventInit eventInitDict);

  [SameObject]
  readonly attribute PresentationConnection connection;
};

dictionary PresentationConnectionAvailableEventInit : EventInit
{
  required PresentationConnection connection;
};
