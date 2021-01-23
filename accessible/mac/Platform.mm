/* -*- Mode: Objective-C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Cocoa/Cocoa.h>

#include "Platform.h"
#include "ProxyAccessible.h"
#include "AccessibleOrProxy.h"
#include "DocAccessibleParent.h"
#include "mozTableAccessible.h"

#include "nsAppShell.h"

namespace mozilla {
namespace a11y {

// Mac a11y whitelisting
static bool sA11yShouldBeEnabled = false;

bool ShouldA11yBeEnabled() {
  EPlatformDisabledState disabledState = PlatformDisabledState();
  return (disabledState == ePlatformIsForceEnabled) ||
         ((disabledState == ePlatformIsEnabled) && sA11yShouldBeEnabled);
}

void PlatformInit() {}

void PlatformShutdown() {}

void ProxyCreated(ProxyAccessible* aProxy, uint32_t) {
  ProxyAccessible* parent = aProxy->Parent();
  if (parent && nsAccUtils::MustPrune(parent)) {
    // We don't create a native object if we're child of a "flat" accessible;
    // for example, on OS X buttons shouldn't have any children, because that
    // makes the OS confused.
    return;
  }

  // Pass in dummy state for now as retrieving proxy state requires IPC.
  // Note that we can use ProxyAccessible::IsTable* functions here because they
  // do not use IPC calls but that might change after bug 1210477.
  Class type;
  if (aProxy->IsTable())
    type = [mozTableAccessible class];
  else if (aProxy->IsTableRow())
    type = [mozTableRowAccessible class];
  else if (aProxy->IsTableCell())
    type = [mozTableCellAccessible class];
  else
    type = GetTypeFromRole(aProxy->Role());

  mozAccessible* mozWrapper = [[type alloc] initWithAccessible:aProxy];
  aProxy->SetWrapper(reinterpret_cast<uintptr_t>(mozWrapper));
}

void ProxyDestroyed(ProxyAccessible* aProxy) {
  mozAccessible* wrapper = GetNativeFromGeckoAccessible(aProxy);
  [wrapper expire];
  [wrapper release];
  aProxy->SetWrapper(0);
}

void ProxyEvent(ProxyAccessible* aProxy, uint32_t aEventType) {
  // ignore everything but focus-changed, value-changed, caret and selection
  // events for now.
  if (aEventType != nsIAccessibleEvent::EVENT_FOCUS &&
      aEventType != nsIAccessibleEvent::EVENT_VALUE_CHANGE &&
      aEventType != nsIAccessibleEvent::EVENT_TEXT_VALUE_CHANGE &&
      aEventType != nsIAccessibleEvent::EVENT_TEXT_CARET_MOVED &&
      aEventType != nsIAccessibleEvent::EVENT_TEXT_SELECTION_CHANGED &&
      aEventType != nsIAccessibleEvent::EVENT_REORDER)
    return;

  mozAccessible* wrapper = GetNativeFromGeckoAccessible(aProxy);
  if (wrapper) {
    [wrapper handleAccessibleEvent:aEventType];
  }
}

void ProxyStateChangeEvent(ProxyAccessible* aProxy, uint64_t aState, bool aEnabled) {
  mozAccessible* wrapper = GetNativeFromGeckoAccessible(aProxy);
  if (wrapper) {
    [wrapper stateChanged:aState isEnabled:aEnabled];
  }
}

void ProxyCaretMoveEvent(ProxyAccessible* aTarget, int32_t aOffset) {
  mozAccessible* wrapper = GetNativeFromGeckoAccessible(aTarget);
  if (wrapper) {
    [wrapper handleAccessibleEvent:nsIAccessibleEvent::EVENT_TEXT_CARET_MOVED];
  }
}

void ProxyTextChangeEvent(ProxyAccessible*, const nsString&, int32_t, uint32_t, bool, bool) {}

void ProxyShowHideEvent(ProxyAccessible*, ProxyAccessible*, bool, bool) {}

void ProxySelectionEvent(ProxyAccessible* aTarget, ProxyAccessible* aWidget, uint32_t aEventType) {
  mozAccessible* wrapper = GetNativeFromGeckoAccessible(aWidget);
  if (wrapper) {
    [wrapper handleAccessibleEvent:aEventType];
  }
}
}  // namespace a11y
}  // namespace mozilla

@interface GeckoNSApplication (a11y)
- (void)accessibilitySetValue:(id)value forAttribute:(NSString*)attribute;
@end

@implementation GeckoNSApplication (a11y)

- (void)accessibilitySetValue:(id)value forAttribute:(NSString*)attribute {
  if ([attribute isEqualToString:@"AXEnhancedUserInterface"])
    mozilla::a11y::sA11yShouldBeEnabled = ([value intValue] == 1);

  return [super accessibilitySetValue:value forAttribute:attribute];
}

@end
