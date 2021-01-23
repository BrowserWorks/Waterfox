/* -*- Mode: Objective-C; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// This protocol's primary use is for abstracting the NSAccessibility informal protocol
// into a formal internal API. Conforming classes get to choose a subset of the optional
// methods to implement. Those methods will be mapped to NSAccessibility attributes or actions.
// A conforming class can implement moxBlockSelector to control which of its implemented
// methods should be exposed to NSAccessibility.

@protocol MOXAccessible

// The deepest descendant of the accessible subtree that contains the specified point.
// Forwarded from accessibilityHitTest.
- (id _Nullable)moxHitTest:(NSPoint)point;

// The deepest descendant of the accessible subtree that has the focus.
// Forwarded from accessibilityFocusedUIElement.
- (id _Nullable)moxFocusedUIElement;

// Sends a notification to any observing assistive applications.
- (void)moxPostNotification:(NSString* _Nonnull)notification;

// Return YES if selector should be considered not supported.
// Used in implementations such as:
// - accessibilityAttributeNames
// - accessibilityActionNames
// - accessibilityIsAttributeSettable
- (BOOL)moxBlockSelector:(SEL _Nonnull)selector;

@optional

#pragma mark - AttributeGetters

// AXChildren
- (NSArray* _Nullable)moxChildren;

// AXParent
- (id _Nullable)moxParent;

// AXRole
- (NSString* _Nullable)moxRole;

// AXRoleDescription
- (NSString* _Nullable)moxRoleDescription;

// AXSubrole
- (NSString* _Nullable)moxSubrole;

// AXTitle
- (NSString* _Nullable)moxTitle;

// AXDescription
- (NSString* _Nullable)moxLabel;

// AXHelp
- (NSString* _Nullable)moxHelp;

// AXValue
- (id _Nullable)moxValue;

// AXSize
- (NSValue* _Nullable)moxSize;

// AXPosition
- (NSValue* _Nullable)moxPosition;

// AXEnabled
- (NSNumber* _Nullable)moxEnabled;

// AXFocused
- (NSNumber* _Nullable)moxFocused;

// AXWindow
- (id _Nullable)moxWindow;

// AXTitleUIElement
- (id _Nullable)moxTitleUIElement;

// AXTopLevelUIElement
- (id _Nullable)moxTopLevelUIElement;

// AXHasPopup
- (NSNumber* _Nullable)moxHasPopup;

// AXARIACurrent
- (NSString* _Nullable)moxARIACurrent;

// AXSelected
- (NSNumber* _Nullable)moxSelected;

// AXRequired
- (NSNumber* _Nullable)moxRequired;

// AXDOMIdentifier
- (NSString* _Nullable)moxDOMIdentifier;

// AXURL
- (NSURL* _Nullable)moxURL;

// AXPopupValue
- (NSString* _Nullable)moxPopupValue;

// AXVisited
- (NSNumber* _Nullable)moxVisited;

// AXExpanded
- (NSNumber* _Nullable)moxExpanded;

// AXMain
- (NSNumber* _Nullable)moxMain;

// AXMinimized
- (NSNumber* _Nullable)moxMinimized;

// AXSelectedChildren
- (NSArray* _Nullable)moxSelectedChildren;

// AXTabs
- (NSArray* _Nullable)moxTabs;

// AXContents
- (NSArray* _Nullable)moxContents;

// AXOrientation
- (NSString* _Nullable)moxOrientation;

// AXMenuItemMarkChar
- (NSString* _Nullable)moxMenuItemMarkChar;

// Table Attributes

// AXRowCount
- (NSNumber* _Nullable)moxRowCount;

// AXColumnCount
- (NSNumber* _Nullable)moxColumnCount;

// AXRows
- (NSArray* _Nullable)moxRows;

// AXColumns
- (NSArray* _Nullable)moxColumns;

// AXIndex
- (NSNumber* _Nullable)moxIndex;

// AXRowIndexRange
- (NSValue* _Nullable)moxRowIndexRange;

// AXColumnIndexRange
- (NSValue* _Nullable)moxColumnIndexRange;

// AXRowHeaderUIElements
- (NSArray* _Nullable)moxRowHeaderUIElements;

// AXColumnHeaderUIElements
- (NSArray* _Nullable)moxColumnHeaderUIElements;

// Math Attributes

// AXMathRootRadicand
- (id _Nullable)moxMathRootRadicand;

// AXMathRootIndex
- (id _Nullable)moxMathRootIndex;

// AXMathFractionNumerator
- (id _Nullable)moxMathFractionNumerator;

// AXMathFractionDenominator
- (id _Nullable)moxMathFractionDenominator;

// AXMathLineThickness
- (NSNumber* _Nullable)moxMathLineThickness;

// AXMathBase
- (id _Nullable)moxMathBase;

// AXMathSubscript
- (id _Nullable)moxMathSubscript;

// AXMathSuperscript
- (id _Nullable)moxMathSuperscript;

// AXMathUnder
- (id _Nullable)moxMathUnder;

// AXMathOver
- (id _Nullable)moxMathOver;

#pragma mark - AttributeSetters

// AXValue
- (void)moxSetValue:(id _Nullable)value;

// AXFocused
- (void)moxSetFocused:(NSNumber* _Nullable)focused;

// AXSelected
- (void)moxSetSelected:(NSNumber* _Nullable)selected;

// AXSelectedChildren
- (void)moxSetSelectedChildren:(NSArray* _Nullable)selectedChildren;

#pragma mark - Actions

// AXPress
- (void)moxPerformPress;

// AXShowMenu
- (void)moxPerformShowMenu;

// AXScrollToVisible
- (void)moxPerformScrollToVisible;

// AXIncrement
- (void)moxPerformIncrement;

// AXDecrement
- (void)moxPerformDecrement;

@end
