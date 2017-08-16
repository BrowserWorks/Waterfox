// Copyright 2011-2012 Norbert Lindenberg. All rights reserved.
// Copyright 2012  Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 6.2.3
description: Tests that language tags are canonicalized in return values.
author: Norbert Lindenberg
includes: [testIntl.js]
---*/

var canonicalizedTags = {
    "de": ["de"],
    "de-DE": ["de-DE", "de"],
    "DE-de": ["de-DE", "de"],
    "cmn": ["cmn"],
    "CMN-hANS": ["cmn-Hans", "cmn"],
    "cmn-hans-cn": ["cmn-Hans-CN", "cmn-Hans", "cmn"],
    "es-419": ["es-419", "es"],
    "es-419-u-nu-latn": ["es-419-u-nu-latn", "es-419", "es", "es-u-nu-latn"],
    // -u-ca is incomplete, so it will not show up in resolvedOptions().locale
    "cmn-hans-cn-u-ca-t-ca-x-t-u": ["cmn-Hans-CN-t-ca-u-ca-x-t-u", "cmn-Hans-CN-t-ca-x-t-u", "cmn-Hans-CN-t-ca-x-t", "cmn-Hans-CN-t-ca", "cmn-Hans-CN", "cmn-Hans", "cmn"],
    "de-gregory-u-ca-gregory": ["de-gregory-u-ca-gregory", "de-gregory", "de-u-ca-gregory", "de"],
    "no-nyn": ["nn"],
    "i-klingon": ["tlh"],
    "sgn-GR": ["gss"],
    "ji": ["yi"],
    "de-DD": ["de-DE", "de"],
    "zh-hak-CN": ["hak-CN", "hak"],
    "sgn-ils": ["ils"],
    "in": ["id"],
    "x-foo": ["x-foo"]
};

// make sure the data above is correct
Object.getOwnPropertyNames(canonicalizedTags).forEach(function (tag) {
    canonicalizedTags[tag].forEach(function (canonicalTag) {
        assert(isCanonicalizedStructurallyValidLanguageTag(canonicalTag), "Test data \"" + canonicalTag + "\" is not canonicalized and structurally valid language tag.");
    });
});

// now the actual test
testWithIntlConstructors(function (Constructor) {
    var defaultLocale = new Constructor().resolvedOptions().locale;
    Object.getOwnPropertyNames(canonicalizedTags).forEach(function (tag) {
        // use lookup locale matcher to keep the set of possible return values predictable

        // Variant 1: construct an object and see whether its locale is canonicalized.
        // In this variant, shortened forms or the default locale may be returned
        var object = new Constructor([tag], {localeMatcher: "lookup"});
        var locale = object.resolvedOptions().locale;
        assert(canonicalizedTags[tag].indexOf(locale) !== -1 || locale === defaultLocale, "For " + tag + " got " + locale + "; expected one of " + canonicalizedTags[tag].join(", ") + ".");
        
        // Variant 2: get the supported locales. If the tag is supported, it should be returned canonicalized but unshortened
        var supported = Constructor.supportedLocalesOf([tag]);
        assert(supported.length === 0 || supported[0] === canonicalizedTags[tag][0], "For " + tag + " got " + supported[0] + "; expected " + canonicalizedTags[tag][0] + ".");
    });
    return true;
});

reportCompare(0, 0);
