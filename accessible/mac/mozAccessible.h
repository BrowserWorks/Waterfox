/* -*- Mode: Objective-C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AccessibleWrap.h"
#include "ProxyAccessible.h"
#include "AccessibleOrProxy.h"

#import <Cocoa/Cocoa.h>

#import "MOXAccessibleBase.h"

@class mozRootAccessible;

/**
 * All mozAccessibles are either abstract objects (that correspond to XUL
 * widgets, HTML frames, etc) or are attached to a certain view; for example
 * a document view. When we hand an object off to an AT, we always want
 * to give it the represented view, in the latter case.
 */

namespace mozilla {
namespace a11y {

inline mozAccessible* GetNativeFromGeckoAccessible(mozilla::a11y::AccessibleOrProxy aAccOrProxy) {
  MOZ_ASSERT(!aAccOrProxy.IsNull(), "Cannot get native from null accessible");
  if (Accessible* acc = aAccOrProxy.AsAccessible()) {
    mozAccessible* native = nil;
    acc->GetNativeInterface((void**)&native);
    return native;
  }

  ProxyAccessible* proxy = aAccOrProxy.AsProxy();
  return reinterpret_cast<mozAccessible*>(proxy->GetWrapper());
}

}  // a11y
}  // mozilla

@interface mozAccessible : MOXAccessibleBase {
  /**
   * Reference to the accessible we were created with;
   * either a proxy accessible or an accessible wrap.
   */
  mozilla::a11y::AccessibleOrProxy mGeckoAccessible;

  /**
   * The role of our gecko accessible.
   */
  mozilla::a11y::role mRole;

  /**
   * A cache of a subset of our states.
   */
  uint64_t mCachedState;
}

// inits with the given wrap or proxy accessible
- (id)initWithAccessible:(mozilla::a11y::AccessibleOrProxy)aAccOrProxy;

// allows for gecko accessible access outside of the class
- (mozilla::a11y::AccessibleOrProxy)geckoAccessible;

// override
- (void)dealloc;

// should a child be disabled
- (BOOL)disableChild:(mozAccessible*)child;

// Given a gecko accessibility event type, post the relevant
// system accessibility notification.
- (void)handleAccessibleEvent:(uint32_t)eventType;

// internal method to retrieve a child at a given index.
- (id)childAt:(uint32_t)i;

// Get gecko accessible's state.
- (uint64_t)state;

// Get gecko accessible's state filtered through given mask.
- (uint64_t)stateWithMask:(uint64_t)mask;

// Notify of a state change, so the cache can be altered.
- (void)stateChanged:(uint64_t)state isEnabled:(BOOL)enabled;

// Invalidate cached state.
- (void)invalidateState;

// This is called by isAccessibilityElement. If a subclass wants
// to alter the isAccessibilityElement return value, it should
// override this and not isAccessibilityElement directly.
- (BOOL)ignoreWithParent:(mozAccessible*)parent;

// Should the child be ignored. This allows subclasses to determine
// what kinds of accessibles are valid children. This causes the child
// to be skipped, but the unignored descendants will be added to the
// container in the default children getter.
- (BOOL)ignoreChild:(mozAccessible*)child;

#pragma mark - mozAccessible protocol / widget

// override
- (BOOL)hasRepresentedView;

// override
- (id)representedView;

// override
- (BOOL)isRoot;

#pragma mark - MOXAccessible protocol

// override
- (BOOL)moxBlockSelector:(SEL)selector;

// override
- (id)moxHitTest:(NSPoint)point;

// override
- (id)moxFocusedUIElement;

// Attribute getters

// override
- (id<mozAccessible>)moxParent;

// override
- (NSArray*)moxChildren;

// override
- (NSValue*)moxSize;

// override
- (NSValue*)moxPosition;

// override
- (NSString*)moxRole;

// override
- (NSString*)moxSubrole;

// override
- (NSString*)moxRoleDescription;

// override
- (NSWindow*)moxWindow;

// override
- (id)moxValue;

// override
- (NSString*)moxTitle;

// override
- (NSString*)moxLabel;

// override
- (NSString*)moxHelp;

// override
- (NSNumber*)moxEnabled;

// override
- (NSNumber*)moxFocused;

// override
- (NSNumber*)moxSelected;

// override
- (NSString*)moxARIACurrent;

// override
- (id)moxTitleUIElement;

// override
- (NSString*)moxDOMIdentifier;

// override
- (NSNumber*)moxRequired;

// override
- (void)moxSetFocused:(NSNumber*)focused;

// override
- (void)moxPerformScrollToVisible;

// override
- (void)moxPerformShowMenu;

// override
- (void)moxPerformPress;

#pragma mark -

// makes ourselves "expired". after this point, we might be around if someone
// has retained us (e.g., a third-party), but we really contain no information.
// override
- (void)expire;
// override
- (BOOL)isExpired;

// ---- NSAccessibility methods ---- //

// whether to include this element in the platform's tree
// override
- (BOOL)isAccessibilityElement;

// override
- (NSString*)description;

@end
