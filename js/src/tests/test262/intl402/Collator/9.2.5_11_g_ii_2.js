// Copyright 2011-2012 Norbert Lindenberg. All rights reserved.
// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 9.2.5_11_g_ii_2
description: >
    Tests that missing Unicode extension values default to true for
    boolean keys.
author: Norbert Lindenberg
---*/

var extensions = ["-u-co-phonebk-kn", "-u-kn-co-phonebk"];
extensions.forEach(function (extension) {
    var defaultLocale = new Intl.Collator().resolvedOptions().locale;
    var collator = new Intl.Collator([defaultLocale + extension], {usage: "sort"});
    var locale = collator.resolvedOptions().locale;
    var numeric = collator.resolvedOptions().numeric;
    if (numeric !== undefined) {
        assert.sameValue(numeric, true, "Default value for \"kn\" should be true, but is " + numeric + ".");
        assert.sameValue(locale.indexOf("-kn"), -1, "\"kn\" is returned in locale, but shouldn't be.");
    }
});

reportCompare(0, 0);
