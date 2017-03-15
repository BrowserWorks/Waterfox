/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* enum types for CSS properties and their values */
 
#ifndef nsCSSPropertyID_h___
#define nsCSSPropertyID_h___

#include <nsHashKeys.h>

/*
   Declare the enum list using the magic of preprocessing
   enum values are "eCSSProperty_foo" (where foo is the property)

   To change the list of properties, see nsCSSPropList.h

 */
enum nsCSSPropertyID {
  eCSSProperty_UNKNOWN = -1,

  #define CSS_PROP(name_, id_, method_, flags_, pref_, parsevariant_, \
                   kwtable_, stylestruct_, stylestructoffset_, animtype_) \
    eCSSProperty_##id_,
  #define CSS_PROP_LIST_INCLUDE_LOGICAL
  #include "nsCSSPropList.h"
  #undef CSS_PROP_LIST_INCLUDE_LOGICAL
  #undef CSS_PROP

  eCSSProperty_COUNT_no_shorthands,
  // Make the count continue where it left off:
  eCSSProperty_COUNT_DUMMY = eCSSProperty_COUNT_no_shorthands - 1,

  #define CSS_PROP_SHORTHAND(name_, id_, method_, flags_, pref_) \
    eCSSProperty_##id_,
  #include "nsCSSPropList.h"
  #undef CSS_PROP_SHORTHAND

  eCSSProperty_COUNT,
  // Make the count continue where it left off:
  eCSSProperty_COUNT_DUMMY2 = eCSSProperty_COUNT - 1,

  #define CSS_PROP_ALIAS(aliasname_, id_, method_, pref_) \
    eCSSPropertyAlias_##method_,
  #include "nsCSSPropAliasList.h"
  #undef CSS_PROP_ALIAS

  eCSSProperty_COUNT_with_aliases,
  // Make the count continue where it left off:
  eCSSProperty_COUNT_DUMMY3 = eCSSProperty_COUNT_with_aliases - 1,

  // Some of the values below could probably overlap with each other
  // if we had a need for them to do so.

  // Extra values for use in the values of the 'transition-property'
  // property.
  eCSSPropertyExtra_no_properties,
  eCSSPropertyExtra_all_properties,

  // Extra dummy values for nsCSSParser internal use.
  eCSSPropertyExtra_x_none_value,
  eCSSPropertyExtra_x_auto_value,

  // Extra value to represent custom properties (--*).
  eCSSPropertyExtra_variable,

  // Extra value for use in the DOM API's
  eCSSProperty_DOM
};

namespace mozilla {

template<>
inline PLDHashNumber
Hash<nsCSSPropertyID>(const nsCSSPropertyID& aValue)
{
  return uint32_t(aValue);
}

} // namespace mozilla

// The "descriptors" that can appear in a @font-face rule.
// They have the syntax of properties but different value rules.
enum nsCSSFontDesc {
  eCSSFontDesc_UNKNOWN = -1,
#define CSS_FONT_DESC(name_, method_) eCSSFontDesc_##method_,
#include "nsCSSFontDescList.h"
#undef CSS_FONT_DESC
  eCSSFontDesc_COUNT
};

// The "descriptors" that can appear in a @counter-style rule.
// They have the syntax of properties but different value rules.
enum nsCSSCounterDesc {
  eCSSCounterDesc_UNKNOWN = -1,
#define CSS_COUNTER_DESC(name_, method_) eCSSCounterDesc_##method_,
#include "nsCSSCounterDescList.h"
#undef CSS_COUNTER_DESC
  eCSSCounterDesc_COUNT
};

enum nsCSSPropertyLogicalGroup {
  eCSSPropertyLogicalGroup_UNKNOWN = -1,
#define CSS_PROP_LOGICAL_GROUP_AXIS(name_) \
  eCSSPropertyLogicalGroup_##name_,
#define CSS_PROP_LOGICAL_GROUP_BOX(name_) \
  eCSSPropertyLogicalGroup_##name_,
#define CSS_PROP_LOGICAL_GROUP_SHORTHAND(name_) \
  eCSSPropertyLogicalGroup_##name_,
#include "nsCSSPropLogicalGroupList.h"
#undef CSS_PROP_LOGICAL_GROUP_SHORTHAND
#undef CSS_PROP_LOGICAL_GROUP_BOX
#undef CSS_PROP_LOGICAL_GROUP_AXIS
  eCSSPropertyLogicalGroup_COUNT
};

#endif /* nsCSSPropertyID_h___ */
