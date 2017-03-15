/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* a list of all Servo binding functions */

/* This file contains the list of all Servo binding functions. Each
 * entry is defined as a SERVO_BINDING_FUNC macro with the following
 * parameters:
 * - 'name_' the name of the binding function
 * - 'return_' the return type of the binding function
 * and the parameter list of the function.
 *
 * Users of this list should define a macro
 * SERVO_BINDING_FUNC(name_, return_, ...)
 * before including this file.
 */

// Node data
SERVO_BINDING_FUNC(Servo_Node_ClearNodeData, void, RawGeckoNodeBorrowed node)

// Styleset and Stylesheet management
SERVO_BINDING_FUNC(Servo_StyleSheet_Empty, RawServoStyleSheetStrong,
                   mozilla::css::SheetParsingMode parsing_mode)
SERVO_BINDING_FUNC(Servo_StyleSheet_FromUTF8Bytes, RawServoStyleSheetStrong,
                   const nsACString* data,
                   mozilla::css::SheetParsingMode parsing_mode,
                   const nsACString* base_url,
                   ThreadSafeURIHolder* base,
                   ThreadSafeURIHolder* referrer,
                   ThreadSafePrincipalHolder* principal)
SERVO_BINDING_FUNC(Servo_StyleSheet_AddRef, void,
                   RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSheet_Release, void,
                   RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSheet_HasRules, bool,
                   RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSet_Init, RawServoStyleSetOwned)
SERVO_BINDING_FUNC(Servo_StyleSet_Drop, void, RawServoStyleSetOwned set)
SERVO_BINDING_FUNC(Servo_StyleSet_AppendStyleSheet, void,
                   RawServoStyleSetBorrowed set, RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSet_PrependStyleSheet, void,
                   RawServoStyleSetBorrowed set, RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSet_RemoveStyleSheet, void,
                   RawServoStyleSetBorrowed set, RawServoStyleSheetBorrowed sheet)
SERVO_BINDING_FUNC(Servo_StyleSet_InsertStyleSheetBefore, void,
                   RawServoStyleSetBorrowed set, RawServoStyleSheetBorrowed sheet,
                   RawServoStyleSheetBorrowed reference)

// Animations API
SERVO_BINDING_FUNC(Servo_ParseProperty,
                   RawServoDeclarationBlockStrong,
                   const nsACString* property, const nsACString* value,
                   const nsACString* base_url, ThreadSafeURIHolder* base,
                   ThreadSafeURIHolder* referrer,
                   ThreadSafePrincipalHolder* principal)
SERVO_BINDING_FUNC(Servo_RestyleWithAddedDeclaration,
                   ServoComputedValuesStrong,
                   RawServoDeclarationBlockBorrowed declarations,
                   ServoComputedValuesBorrowed previous_style)

// Style attribute
SERVO_BINDING_FUNC(Servo_ParseStyleAttribute, RawServoDeclarationBlockStrong,
                   const nsACString* data)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_CreateEmpty,
                   RawServoDeclarationBlockStrong)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_Clone, RawServoDeclarationBlockStrong,
                   RawServoDeclarationBlockBorrowed declarations)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_AddRef, void,
                   RawServoDeclarationBlockBorrowed declarations)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_Release, void,
                   RawServoDeclarationBlockBorrowed declarations)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_Equals, bool,
                   RawServoDeclarationBlockBorrowed a,
                   RawServoDeclarationBlockBorrowed b)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_GetCssText, void,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsAString* result)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_SerializeOneValue, void,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsString* buffer)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_Count, uint32_t,
                   RawServoDeclarationBlockBorrowed declarations)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_GetNthProperty, bool,
                   RawServoDeclarationBlockBorrowed declarations,
                   uint32_t index, nsAString* result)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_GetPropertyValue, void,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsIAtom* property, bool is_custom, nsAString* value)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_GetPropertyIsImportant, bool,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsIAtom* property, bool is_custom)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_SetProperty, bool,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsIAtom* property, bool is_custom,
                   nsACString* value, bool is_important)
SERVO_BINDING_FUNC(Servo_DeclarationBlock_RemoveProperty, void,
                   RawServoDeclarationBlockBorrowed declarations,
                   nsIAtom* property, bool is_custom)

// CSS supports()
SERVO_BINDING_FUNC(Servo_CSSSupports, bool,
                   const nsACString* name, const nsACString* value)

// Computed style data
SERVO_BINDING_FUNC(Servo_ComputedValues_Get, ServoComputedValuesStrong,
                   RawGeckoNodeBorrowed node)
SERVO_BINDING_FUNC(Servo_ComputedValues_GetForAnonymousBox,
                   ServoComputedValuesStrong,
                   ServoComputedValuesBorrowedOrNull parent_style_or_null,
                   nsIAtom* pseudoTag, RawServoStyleSetBorrowed set)
SERVO_BINDING_FUNC(Servo_ComputedValues_GetForPseudoElement,
                   ServoComputedValuesStrong,
                   ServoComputedValuesBorrowed parent_style,
                   RawGeckoElementBorrowed match_element, nsIAtom* pseudo_tag,
                   RawServoStyleSetBorrowed set, bool is_probe)
SERVO_BINDING_FUNC(Servo_ComputedValues_Inherit, ServoComputedValuesStrong,
                   ServoComputedValuesBorrowedOrNull parent_style)
SERVO_BINDING_FUNC(Servo_ComputedValues_AddRef, void,
                   ServoComputedValuesBorrowed computed_values)
SERVO_BINDING_FUNC(Servo_ComputedValues_Release, void,
                   ServoComputedValuesBorrowed computed_values)

// Initialize Servo components. Should be called exactly once at startup.
SERVO_BINDING_FUNC(Servo_Initialize, void)
// Shut down Servo components. Should be called exactly once at shutdown.
SERVO_BINDING_FUNC(Servo_Shutdown, void)

// Restyle hints
SERVO_BINDING_FUNC(Servo_ComputeRestyleHint, nsRestyleHint,
                   RawGeckoElementBorrowed element, ServoElementSnapshot* snapshot,
                   RawServoStyleSetBorrowed set)

// Restyle the given subtree.
SERVO_BINDING_FUNC(Servo_RestyleSubtree, void,
                   RawGeckoNodeBorrowed node, RawServoStyleSetBorrowed set)

// Style-struct management.
#define STYLE_STRUCT(name, checkdata_cb)                            \
  struct nsStyle##name;                                             \
  SERVO_BINDING_FUNC(Servo_GetStyle##name, const nsStyle##name*,  \
                     ServoComputedValuesBorrowedOrNull computed_values)
#include "nsStyleStructList.h"
#undef STYLE_STRUCT
