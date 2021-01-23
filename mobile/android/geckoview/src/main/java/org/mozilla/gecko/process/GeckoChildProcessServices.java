/* -*- Mode: Java; c-basic-offset: 4; tab-width: 4; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.process;

public class GeckoChildProcessServices {
    public static final class gmplugin extends GeckoServiceChildProcess {}
    public static final class socket extends GeckoServiceChildProcess {}

    public static final class tab0 extends GeckoServiceChildProcess {}
    public static final class tab1 extends GeckoServiceChildProcess {}
    public static final class tab2 extends GeckoServiceChildProcess {}
}
