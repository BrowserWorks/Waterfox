/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <objc/objc-runtime.h>

#include "nsMenuBarX.h"
#include "nsMenuX.h"
#include "nsMenuItemX.h"
#include "nsMenuUtilsX.h"
#include "nsCocoaUtils.h"
#include "nsCocoaWindow.h"
#include "nsChildView.h"

#include "nsCOMPtr.h"
#include "nsString.h"
#include "nsGkAtoms.h"
#include "nsObjCExceptions.h"
#include "nsThreadUtils.h"
#include "nsTouchBarNativeAPIDefines.h"

#include "nsIContent.h"
#include "nsIWidget.h"
#include "mozilla/dom/Document.h"
#include "nsIAppStartup.h"
#include "nsIStringBundle.h"
#include "nsToolkitCompsCID.h"

#include "mozilla/Components.h"
#include "mozilla/dom/Element.h"

NativeMenuItemTarget* nsMenuBarX::sNativeEventTarget = nil;
nsMenuBarX* nsMenuBarX::sLastGeckoMenuBarPainted = nullptr;
NSMenu* sApplicationMenu = nil;
BOOL sApplicationMenuIsFallback = NO;
BOOL gSomeMenuBarPainted = NO;

// defined in nsCocoaWindow.mm.
extern BOOL sTouchBarIsInitialized;

// We keep references to the first quit and pref item content nodes we find, which
// will be from the hidden window. We use these when the document for the current
// window does not have a quit or pref item. We don't need strong refs here because
// these items are always strong ref'd by their owning menu bar (instance variable).
static nsIContent* sAboutItemContent = nullptr;
static nsIContent* sPrefItemContent = nullptr;
static nsIContent* sQuitItemContent = nullptr;

NS_IMPL_ISUPPORTS(nsNativeMenuServiceX, nsINativeMenuService)

NS_IMETHODIMP nsNativeMenuServiceX::CreateNativeMenuBar(nsIWidget* aParent,
                                                        mozilla::dom::Element* aMenuBarElement) {
  NS_ASSERTION(NS_IsMainThread(), "Attempting to create native menu bar on wrong thread!");

  RefPtr<nsMenuBarX> mb = new nsMenuBarX();
  if (!mb) return NS_ERROR_OUT_OF_MEMORY;

  return mb->Create(aParent, aMenuBarElement);
}

//
// ApplicationMenuDelegate Objective-C class
//

@implementation ApplicationMenuDelegate

- (id)initWithApplicationMenu:(nsMenuBarX*)aApplicationMenu {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NIL;

  if ((self = [super init])) {
    mApplicationMenu = aApplicationMenu;
  }
  return self;

  NS_OBJC_END_TRY_ABORT_BLOCK_NIL;
}

- (void)menuWillOpen:(NSMenu*)menu {
  mApplicationMenu->ApplicationMenuOpened();
}

- (void)menuDidClose:(NSMenu*)menu {
}

@end

nsMenuBarX::nsMenuBarX()
    : nsMenuGroupOwnerX(),
      mParentWindow(nullptr),
      mNeedsRebuild(false),
      mApplicationMenuDelegate(nil) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK;

  mNativeMenu = [[GeckoNSMenu alloc] initWithTitle:@"MainMenuBar"];

  NS_OBJC_END_TRY_ABORT_BLOCK;
}

nsMenuBarX::~nsMenuBarX() {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK;

  if (nsMenuBarX::sLastGeckoMenuBarPainted == this) nsMenuBarX::sLastGeckoMenuBarPainted = nullptr;

  // the quit/pref items of a random window might have been used if there was no
  // hidden window, thus we need to invalidate the weak references.
  if (sAboutItemContent == mAboutItemContent) sAboutItemContent = nullptr;
  if (sQuitItemContent == mQuitItemContent) sQuitItemContent = nullptr;
  if (sPrefItemContent == mPrefItemContent) sPrefItemContent = nullptr;

  // make sure we unregister ourselves as a content observer
  if (mContent) {
    UnregisterForContentChanges(mContent);
  }

  // We have to manually clear the array here because clearing causes menu items
  // to call back into the menu bar to unregister themselves. We don't want to
  // depend on member variable ordering to ensure that the array gets cleared
  // before the registration hash table is destroyed.
  mMenuArray.Clear();

  if (mApplicationMenuDelegate) {
    [mApplicationMenuDelegate release];
  }

  [mNativeMenu release];

  NS_OBJC_END_TRY_ABORT_BLOCK;
}

nsresult nsMenuBarX::Create(nsIWidget* aParent, Element* aContent) {
  if (!aParent) return NS_ERROR_INVALID_ARG;

  mParentWindow = aParent;
  mContent = aContent;

  if (mContent) {
    AquifyMenuBar();

    nsresult rv = nsMenuGroupOwnerX::Create(aContent);
    if (NS_FAILED(rv)) return rv;

    RegisterForContentChanges(mContent, this);
    ConstructNativeMenus();
  } else {
    ConstructFallbackNativeMenus();
  }

  // Give this to the parent window. The parent takes ownership.
  static_cast<nsCocoaWindow*>(mParentWindow)->SetMenuBar(this);

  return NS_OK;
}

void nsMenuBarX::ConstructNativeMenus() {
  for (nsIContent* menuContent = mContent->GetFirstChild(); menuContent;
       menuContent = menuContent->GetNextSibling()) {
    if (menuContent->IsXULElement(nsGkAtoms::menu)) {
      nsMenuX* newMenu = new nsMenuX();
      if (newMenu) {
        nsresult rv = newMenu->Create(this, this, menuContent->AsElement());
        if (NS_SUCCEEDED(rv))
          InsertMenuAtIndex(newMenu, GetMenuCount());
        else
          delete newMenu;
      }
    }
  }
}

void nsMenuBarX::ConstructFallbackNativeMenus() {
  if (sApplicationMenu) {
    // Menu has already been built.
    return;
  }

  nsCOMPtr<nsIStringBundle> stringBundle;

  nsCOMPtr<nsIStringBundleService> bundleSvc = do_GetService(NS_STRINGBUNDLE_CONTRACTID);
  bundleSvc->CreateBundle("chrome://global/locale/fallbackMenubar.properties",
                          getter_AddRefs(stringBundle));

  if (!stringBundle) {
    return;
  }

  nsAutoString labelUTF16;
  nsAutoString keyUTF16;

  const char* labelProp = "quitMenuitem.label";
  const char* keyProp = "quitMenuitem.key";

  stringBundle->GetStringFromName(labelProp, labelUTF16);
  stringBundle->GetStringFromName(keyProp, keyUTF16);

  NSString* labelStr = [NSString stringWithUTF8String:NS_ConvertUTF16toUTF8(labelUTF16).get()];
  NSString* keyStr = [NSString stringWithUTF8String:NS_ConvertUTF16toUTF8(keyUTF16).get()];

  if (!nsMenuBarX::sNativeEventTarget) {
    nsMenuBarX::sNativeEventTarget = [[NativeMenuItemTarget alloc] init];
  }

  sApplicationMenu = [[[[NSApp mainMenu] itemAtIndex:0] submenu] retain];
  if (!mApplicationMenuDelegate) {
    mApplicationMenuDelegate = [[ApplicationMenuDelegate alloc] initWithApplicationMenu:this];
  }
  [sApplicationMenu setDelegate:mApplicationMenuDelegate];
  NSMenuItem* quitMenuItem = [[[NSMenuItem alloc] initWithTitle:labelStr
                                                         action:@selector(menuItemHit:)
                                                  keyEquivalent:keyStr] autorelease];
  [quitMenuItem setTarget:nsMenuBarX::sNativeEventTarget];
  [quitMenuItem setTag:eCommand_ID_Quit];
  [sApplicationMenu addItem:quitMenuItem];
  sApplicationMenuIsFallback = YES;
}

uint32_t nsMenuBarX::GetMenuCount() { return mMenuArray.Length(); }

bool nsMenuBarX::MenuContainsAppMenu() {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_RETURN;

  return ([mNativeMenu numberOfItems] > 0 &&
          [[mNativeMenu itemAtIndex:0] submenu] == sApplicationMenu);

  NS_OBJC_END_TRY_ABORT_BLOCK_RETURN(false);
}

nsresult nsMenuBarX::InsertMenuAtIndex(nsMenuX* aMenu, uint32_t aIndex) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  // If we've only yet created a fallback global Application menu (using
  // ContructFallbackNativeMenus()), destroy it before recreating it properly.
  if (sApplicationMenu && sApplicationMenuIsFallback) {
    ResetNativeApplicationMenu();
  }
  // If we haven't created a global Application menu yet, do it.
  if (!sApplicationMenu) {
    nsresult rv = NS_OK;  // avoid warning about rv being unused
    rv = CreateApplicationMenu(aMenu);
    NS_ASSERTION(NS_SUCCEEDED(rv), "Can't create Application menu");

    // Hook the new Application menu up to the menu bar.
    NSMenu* mainMenu = [NSApp mainMenu];
    NS_ASSERTION([mainMenu numberOfItems] > 0,
                 "Main menu does not have any items, something is terribly wrong!");
    [[mainMenu itemAtIndex:0] setSubmenu:sApplicationMenu];
  }

  // add menu to array that owns our menus
  mMenuArray.InsertElementAt(aIndex, aMenu);

  // hook up submenus
  nsIContent* menuContent = aMenu->Content();
  if (menuContent->GetChildCount() > 0 && !nsMenuUtilsX::NodeIsHiddenOrCollapsed(menuContent)) {
    int insertionIndex = nsMenuUtilsX::CalculateNativeInsertionPoint(this, aMenu);
    if (MenuContainsAppMenu()) insertionIndex++;
    [mNativeMenu insertItem:aMenu->NativeMenuItem() atIndex:insertionIndex];
  }

  return NS_OK;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

void nsMenuBarX::RemoveMenuAtIndex(uint32_t aIndex) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK;

  if (mMenuArray.Length() <= aIndex) {
    NS_ERROR("Attempting submenu removal with bad index!");
    return;
  }

  // Our native menu and our internal menu object array might be out of sync.
  // This happens, for example, when a submenu is hidden. Because of this we
  // should not assume that a native submenu is hooked up.
  NSMenuItem* nativeMenuItem = mMenuArray[aIndex]->NativeMenuItem();
  int nativeMenuItemIndex = [mNativeMenu indexOfItem:nativeMenuItem];
  if (nativeMenuItemIndex != -1) [mNativeMenu removeItemAtIndex:nativeMenuItemIndex];

  mMenuArray.RemoveElementAt(aIndex);

  NS_OBJC_END_TRY_ABORT_BLOCK;
}

void nsMenuBarX::ObserveAttributeChanged(mozilla::dom::Document* aDocument, nsIContent* aContent,
                                         nsAtom* aAttribute) {}

void nsMenuBarX::ObserveContentRemoved(mozilla::dom::Document* aDocument, nsIContent* aContainer,
                                       nsIContent* aChild, nsIContent* aPreviousSibling) {
  nsINode* parent = NODE_FROM(aContainer, aDocument);
  MOZ_ASSERT(parent);
  int32_t index = parent->ComputeIndexOf(aPreviousSibling) + 1;
  RemoveMenuAtIndex(index);
}

void nsMenuBarX::ObserveContentInserted(mozilla::dom::Document* aDocument, nsIContent* aContainer,
                                        nsIContent* aChild) {
  nsMenuX* newMenu = new nsMenuX();
  if (newMenu) {
    nsresult rv = newMenu->Create(this, this, aChild);
    if (NS_SUCCEEDED(rv))
      InsertMenuAtIndex(newMenu, aContainer->ComputeIndexOf(aChild));
    else
      delete newMenu;
  }
}

void nsMenuBarX::ForceUpdateNativeMenuAt(const nsAString& indexString) {
  NSString* locationString =
      [NSString stringWithCharacters:reinterpret_cast<const unichar*>(indexString.BeginReading())
                              length:indexString.Length()];
  NSArray* indexes = [locationString componentsSeparatedByString:@"|"];
  unsigned int indexCount = [indexes count];
  if (indexCount == 0) return;

  nsMenuX* currentMenu = NULL;
  int targetIndex = [[indexes objectAtIndex:0] intValue];
  int visible = 0;
  uint32_t length = mMenuArray.Length();
  // first find a menu in the menu bar
  for (unsigned int i = 0; i < length; i++) {
    nsMenuX* menu = mMenuArray[i].get();
    if (!nsMenuUtilsX::NodeIsHiddenOrCollapsed(menu->Content())) {
      visible++;
      if (visible == (targetIndex + 1)) {
        currentMenu = menu;
        break;
      }
    }
  }

  if (!currentMenu) return;

  // fake open/close to cause lazy update to happen so submenus populate
  currentMenu->MenuOpened();
  currentMenu->MenuClosed();

  // now find the correct submenu
  for (unsigned int i = 1; currentMenu && i < indexCount; i++) {
    targetIndex = [[indexes objectAtIndex:i] intValue];
    visible = 0;
    length = currentMenu->GetItemCount();
    for (unsigned int j = 0; j < length; j++) {
      nsMenuObjectX* targetMenu = currentMenu->GetItemAt(j);
      if (!targetMenu) return;
      if (!nsMenuUtilsX::NodeIsHiddenOrCollapsed(targetMenu->Content())) {
        visible++;
        if (targetMenu->MenuObjectType() == eSubmenuObjectType && visible == (targetIndex + 1)) {
          currentMenu = static_cast<nsMenuX*>(targetMenu);
          // fake open/close to cause lazy update to happen
          currentMenu->MenuOpened();
          currentMenu->MenuClosed();
          break;
        }
      }
    }
  }
}

// Calling this forces a full reload of the menu system, reloading all native
// menus and their items.
// Without this testing is hard because changes to the DOM affect the native
// menu system lazily.
void nsMenuBarX::ForceNativeMenuReload() {
  // tear down everything
  while (GetMenuCount() > 0) RemoveMenuAtIndex(0);

  // construct everything
  ConstructNativeMenus();
}

nsMenuX* nsMenuBarX::GetMenuAt(uint32_t aIndex) {
  if (mMenuArray.Length() <= aIndex) {
    NS_ERROR("Requesting menu at invalid index!");
    return NULL;
  }
  return mMenuArray[aIndex].get();
}

nsMenuX* nsMenuBarX::GetXULHelpMenu() {
  // The Help menu is usually (always?) the last one, so we start there and
  // count back.
  for (int32_t i = GetMenuCount() - 1; i >= 0; --i) {
    nsMenuX* aMenu = GetMenuAt(i);
    if (aMenu && nsMenuX::IsXULHelpMenu(aMenu->Content())) return aMenu;
  }
  return nil;
}

// On SnowLeopard and later we must tell the OS which is our Help menu.
// Otherwise it will only add Spotlight for Help (the Search item) to our
// Help menu if its label/title is "Help" -- i.e. if the menu is in English.
// This resolves bugs 489196 and 539317.
void nsMenuBarX::SetSystemHelpMenu() {
  nsMenuX* xulHelpMenu = GetXULHelpMenu();
  if (xulHelpMenu) {
    NSMenu* helpMenu = (NSMenu*)xulHelpMenu->NativeData();
    if (helpMenu) [NSApp setHelpMenu:helpMenu];
  }
}

nsresult nsMenuBarX::Paint() {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  // Don't try to optimize anything in this painting by checking
  // sLastGeckoMenuBarPainted because the menubar can be manipulated by
  // native dialogs and sheet code and other things besides this paint method.

  // We have to keep the same menu item for the Application menu so we keep
  // passing it along.
  NSMenu* outgoingMenu = [NSApp mainMenu];
  NS_ASSERTION([outgoingMenu numberOfItems] > 0,
               "Main menu does not have any items, something is terribly wrong!");

  NSMenuItem* appMenuItem = [[outgoingMenu itemAtIndex:0] retain];
  [outgoingMenu removeItemAtIndex:0];
  [mNativeMenu insertItem:appMenuItem atIndex:0];
  [appMenuItem release];

  // Set menu bar and event target.
  [NSApp setMainMenu:mNativeMenu];
  SetSystemHelpMenu();
  nsMenuBarX::sLastGeckoMenuBarPainted = this;

  gSomeMenuBarPainted = YES;

  return NS_OK;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

// Returns the 'key' attribute of the 'shortcutID' object (if any) in the
// currently active menubar's DOM document.  'shortcutID' should be the id
// (i.e. the name) of a component that defines a commonly used (and
// localized) cmd+key shortcut, and belongs to a keyset containing similar
// objects.  For example "key_selectAll".  Returns a value that can be
// compared to the first character of [NSEvent charactersIgnoringModifiers]
// when [NSEvent modifierFlags] == NSCommandKeyMask.
char nsMenuBarX::GetLocalizedAccelKey(const char* shortcutID) {
  if (!sLastGeckoMenuBarPainted) return 0;

  nsCOMPtr<mozilla::dom::Document> doc = sLastGeckoMenuBarPainted->mContent->OwnerDoc();
  if (!doc) return 0;

  NS_ConvertASCIItoUTF16 shortcutIDStr(shortcutID);
  nsCOMPtr<Element> shortcutContent = doc->GetElementById(shortcutIDStr);
  if (!shortcutContent) return 0;

  nsAutoString key;
  shortcutContent->GetAttr(kNameSpaceID_None, nsGkAtoms::key, key);
  NS_LossyConvertUTF16toASCII keyASC(key.get());
  const char* keyASCPtr = keyASC.get();
  if (!keyASCPtr) return 0;
  // If keyID's 'key' attribute isn't exactly one character long, it's not
  // what we're looking for.
  if (strlen(keyASCPtr) != sizeof(char)) return 0;
  // Make sure retval is lower case.
  char retval = tolower(keyASCPtr[0]);

  return retval;
}

/* static */
void nsMenuBarX::ResetNativeApplicationMenu() {
  [sApplicationMenu removeAllItems];
  [sApplicationMenu release];
  sApplicationMenu = nil;
  sApplicationMenuIsFallback = NO;
}

void nsMenuBarX::SetNeedsRebuild() { mNeedsRebuild = true; }

void nsMenuBarX::ApplicationMenuOpened() {
  if (mNeedsRebuild) {
    if (!mMenuArray.IsEmpty()) {
      ResetNativeApplicationMenu();
      CreateApplicationMenu(mMenuArray[0].get());
    }
    mNeedsRebuild = false;
  }
}

bool nsMenuBarX::PerformKeyEquivalent(NSEvent* theEvent) {
  return [mNativeMenu performSuperKeyEquivalent:theEvent];
}

// Hide the item in the menu by setting the 'hidden' attribute. Returns it in |outHiddenNode| so
// the caller can hang onto it if they so choose. It is acceptable to pass nsull
// for |outHiddenNode| if the caller doesn't care about the hidden node.
void nsMenuBarX::HideItem(mozilla::dom::Document* inDoc, const nsAString& inID,
                          nsIContent** outHiddenNode) {
  nsCOMPtr<Element> menuElement = inDoc->GetElementById(inID);
  if (menuElement) {
    menuElement->SetAttr(kNameSpaceID_None, nsGkAtoms::hidden, NS_LITERAL_STRING("true"), false);
    if (outHiddenNode) {
      *outHiddenNode = menuElement.get();
      NS_IF_ADDREF(*outHiddenNode);
    }
  }
}

// Do what is necessary to conform to the Aqua guidelines for menus.
void nsMenuBarX::AquifyMenuBar() {
  RefPtr<mozilla::dom::Document> domDoc = mContent->GetComposedDoc();
  if (domDoc) {
    // remove the "About..." item and its separator
    HideItem(domDoc, NS_LITERAL_STRING("aboutSeparator"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("aboutName"), getter_AddRefs(mAboutItemContent));
    if (!sAboutItemContent) sAboutItemContent = mAboutItemContent;

    // remove quit item and its separator
    HideItem(domDoc, NS_LITERAL_STRING("menu_FileQuitSeparator"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_FileQuitItem"), getter_AddRefs(mQuitItemContent));
    if (!sQuitItemContent) sQuitItemContent = mQuitItemContent;

    // remove prefs item and its separator, but save off the pref content node
    // so we can invoke its command later.
    HideItem(domDoc, NS_LITERAL_STRING("menu_PrefsSeparator"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_preferences"), getter_AddRefs(mPrefItemContent));
    if (!sPrefItemContent) sPrefItemContent = mPrefItemContent;

    // hide items that we use for the Application menu
    HideItem(domDoc, NS_LITERAL_STRING("menu_mac_services"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_mac_hide_app"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_mac_hide_others"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_mac_show_all"), nullptr);
    HideItem(domDoc, NS_LITERAL_STRING("menu_mac_touch_bar"), nullptr);
  }
}

// for creating menu items destined for the Application menu
NSMenuItem* nsMenuBarX::CreateNativeAppMenuItem(nsMenuX* inMenu, const nsAString& nodeID,
                                                SEL action, int tag, NativeMenuItemTarget* target) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NIL;

  RefPtr<mozilla::dom::Document> doc = inMenu->Content()->GetUncomposedDoc();
  if (!doc) {
    return nil;
  }

  RefPtr<mozilla::dom::Element> menuItem = doc->GetElementById(nodeID);
  if (!menuItem) {
    return nil;
  }

  // Check collapsed rather than hidden since the app menu items are always
  // hidden in AquifyMenuBar.
  if (menuItem->AttrValueIs(kNameSpaceID_None, nsGkAtoms::collapsed, nsGkAtoms::_true,
                            eCaseMatters)) {
    return nil;
  }

  // Get information from the gecko menu item
  nsAutoString label;
  nsAutoString modifiers;
  nsAutoString key;
  menuItem->GetAttr(nsGkAtoms::label, label);
  menuItem->GetAttr(nsGkAtoms::modifiers, modifiers);
  menuItem->GetAttr(nsGkAtoms::key, key);

  // Get more information about the key equivalent. Start by
  // finding the key node we need.
  NSString* keyEquiv = nil;
  unsigned int macKeyModifiers = 0;
  if (!key.IsEmpty()) {
    RefPtr<Element> keyElement = doc->GetElementById(key);
    if (keyElement) {
      // first grab the key equivalent character
      nsAutoString keyChar(NS_LITERAL_STRING(" "));
      keyElement->GetAttr(kNameSpaceID_None, nsGkAtoms::key, keyChar);
      if (!keyChar.EqualsLiteral(" ")) {
        keyEquiv = [[NSString stringWithCharacters:reinterpret_cast<const unichar*>(keyChar.get())
                                            length:keyChar.Length()] lowercaseString];
      }
      // now grab the key equivalent modifiers
      nsAutoString modifiersStr;
      keyElement->GetAttr(kNameSpaceID_None, nsGkAtoms::modifiers, modifiersStr);
      uint8_t geckoModifiers = nsMenuUtilsX::GeckoModifiersForNodeAttribute(modifiersStr);
      macKeyModifiers = nsMenuUtilsX::MacModifiersForGeckoModifiers(geckoModifiers);
    }
  }
  // get the label into NSString-form
  NSString* labelString =
      [NSString stringWithCharacters:reinterpret_cast<const unichar*>(label.get())
                              length:label.Length()];

  if (!labelString) labelString = @"";
  if (!keyEquiv) keyEquiv = @"";

  // put together the actual NSMenuItem
  NSMenuItem* newMenuItem = [[NSMenuItem alloc] initWithTitle:labelString
                                                       action:action
                                                keyEquivalent:keyEquiv];

  [newMenuItem setTag:tag];
  [newMenuItem setTarget:target];
  [newMenuItem setKeyEquivalentModifierMask:macKeyModifiers];

  MenuItemInfo* info = [[MenuItemInfo alloc] initWithMenuGroupOwner:this];
  [newMenuItem setRepresentedObject:info];
  [info release];

  return newMenuItem;

  NS_OBJC_END_TRY_ABORT_BLOCK_NIL;
}

// build the Application menu shared by all menu bars
nsresult nsMenuBarX::CreateApplicationMenu(nsMenuX* inMenu) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  // At this point, the application menu is the application menu from
  // the nib in cocoa widgets. We do not have a way to create an application
  // menu manually, so we grab the one from the nib and use that.
  sApplicationMenu = [[[[NSApp mainMenu] itemAtIndex:0] submenu] retain];

  /*
    We support the following menu items here:

    Menu Item                DOM Node ID             Notes

    ========================
    = About This App       = <- aboutName
    ========================
    = Preferences...       = <- menu_preferences
    ========================
    = Services     >       = <- menu_mac_services    <- (do not define key equivalent)
    ========================
    = Hide App             = <- menu_mac_hide_app
    = Hide Others          = <- menu_mac_hide_others
    = Show All             = <- menu_mac_show_all
    ========================
    = Customize Touch Bar… = <- menu_mac_touch_bar
    ========================
    = Quit                 = <- menu_FileQuitItem
    ========================

    If any of them are ommitted from the application's DOM, we just don't add
    them. We always add a "Quit" item, but if an app developer does not provide a
    DOM node with the right ID for the Quit item, we add it in English. App
    developers need only add each node with a label and a key equivalent (if they
    want one). Other attributes are optional. Like so:

    <menuitem id="menu_preferences"
           label="&preferencesCmdMac.label;"
             key="open_prefs_key"/>

    We need to use this system for localization purposes, until we have a better way
    to define the Application menu to be used on Mac OS X.
  */

  if (sApplicationMenu) {
    if (!mApplicationMenuDelegate) {
      mApplicationMenuDelegate = [[ApplicationMenuDelegate alloc] initWithApplicationMenu:this];
    }
    [sApplicationMenu setDelegate:mApplicationMenuDelegate];

    // This code reads attributes we are going to care about from the DOM elements

    NSMenuItem* itemBeingAdded = nil;
    BOOL addAboutSeparator = FALSE;

    // Add the About menu item
    itemBeingAdded =
        CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("aboutName"), @selector(menuItemHit:),
                                eCommand_ID_About, nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;

      addAboutSeparator = TRUE;
    }

    // Add separator if either the About item or software update item exists
    if (addAboutSeparator) [sApplicationMenu addItem:[NSMenuItem separatorItem]];

    // Add the Preferences menu item
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_preferences"),
                                             @selector(menuItemHit:), eCommand_ID_Prefs,
                                             nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;

      // Add separator after Preferences menu
      [sApplicationMenu addItem:[NSMenuItem separatorItem]];
    }

    // Add Services menu item
    itemBeingAdded =
        CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_mac_services"), nil, 0, nil);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];

      // set this menu item up as the Mac OS X Services menu
      NSMenu* servicesMenu = [[GeckoServicesNSMenu alloc] initWithTitle:@""];
      [itemBeingAdded setSubmenu:servicesMenu];
      [NSApp setServicesMenu:servicesMenu];

      [itemBeingAdded release];
      itemBeingAdded = nil;

      // Add separator after Services menu
      [sApplicationMenu addItem:[NSMenuItem separatorItem]];
    }

    BOOL addHideShowSeparator = FALSE;

    // Add menu item to hide this application
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_mac_hide_app"),
                                             @selector(menuItemHit:), eCommand_ID_HideApp,
                                             nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;

      addHideShowSeparator = TRUE;
    }

    // Add menu item to hide other applications
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_mac_hide_others"),
                                             @selector(menuItemHit:), eCommand_ID_HideOthers,
                                             nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;

      addHideShowSeparator = TRUE;
    }

    // Add menu item to show all applications
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_mac_show_all"),
                                             @selector(menuItemHit:), eCommand_ID_ShowAll,
                                             nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;

      addHideShowSeparator = TRUE;
    }

    // Add a separator after the hide/show menus if at least one exists
    if (addHideShowSeparator) [sApplicationMenu addItem:[NSMenuItem separatorItem]];

    BOOL addTouchBarSeparator = NO;

    // Add Touch Bar customization menu item.
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_mac_touch_bar"),
                                             @selector(menuItemHit:), eCommand_ID_TouchBar,
                                             nsMenuBarX::sNativeEventTarget);

    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      // We hide the menu item on Macs that don't have a Touch Bar.
      if (!sTouchBarIsInitialized) {
        [itemBeingAdded setHidden:YES];
      } else {
        addTouchBarSeparator = YES;
      }
      [itemBeingAdded release];
      itemBeingAdded = nil;
    }

    // Add a separator after the Touch Bar menu item if it exists
    if (addTouchBarSeparator) [sApplicationMenu addItem:[NSMenuItem separatorItem]];

    // Add quit menu item
    itemBeingAdded = CreateNativeAppMenuItem(inMenu, NS_LITERAL_STRING("menu_FileQuitItem"),
                                             @selector(menuItemHit:), eCommand_ID_Quit,
                                             nsMenuBarX::sNativeEventTarget);
    if (itemBeingAdded) {
      [sApplicationMenu addItem:itemBeingAdded];
      [itemBeingAdded release];
      itemBeingAdded = nil;
    } else {
      // the current application does not have a DOM node for "Quit". Add one
      // anyway, in English.
      NSMenuItem* defaultQuitItem = [[[NSMenuItem alloc] initWithTitle:@"Quit"
                                                                action:@selector(menuItemHit:)
                                                         keyEquivalent:@"q"] autorelease];
      [defaultQuitItem setTarget:nsMenuBarX::sNativeEventTarget];
      [defaultQuitItem setTag:eCommand_ID_Quit];
      [sApplicationMenu addItem:defaultQuitItem];
    }
  }

  return (sApplicationMenu) ? NS_OK : NS_ERROR_FAILURE;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

void nsMenuBarX::SetParent(nsIWidget* aParent) { mParentWindow = aParent; }

//
// Objective-C class used to allow us to have keyboard commands
// look like they are doing something but actually do nothing.
// We allow mouse actions to work normally.
//

// Controls whether or not native menu items should invoke their commands.
static BOOL gMenuItemsExecuteCommands = YES;

@implementation GeckoNSMenu

// Keyboard commands should not cause menu items to invoke their
// commands when there is a key window because we'd rather send
// the keyboard command to the window. We still have the menus
// go through the mechanics so they'll give the proper visual
// feedback.
- (BOOL)performKeyEquivalent:(NSEvent*)theEvent {
  // We've noticed that Mac OS X expects this check in subclasses before
  // calling NSMenu's "performKeyEquivalent:".
  //
  // There is no case in which we'd need to do anything or return YES
  // when we have no items so we can just do this check first.
  if ([self numberOfItems] <= 0) {
    return NO;
  }

  NSWindow* keyWindow = [NSApp keyWindow];

  // If there is no key window then just behave normally. This
  // probably means that this menu is associated with Gecko's
  // hidden window.
  if (!keyWindow) {
    return [super performKeyEquivalent:theEvent];
  }

  NSResponder* firstResponder = [keyWindow firstResponder];

  gMenuItemsExecuteCommands = NO;
  [super performKeyEquivalent:theEvent];
  gMenuItemsExecuteCommands = YES;  // return to default

  // Return YES if we invoked a command and there is now no key window or we changed
  // the first responder. In this case we do not want to propagate the event because
  // we don't want it handled again.
  if (![NSApp keyWindow] || [[NSApp keyWindow] firstResponder] != firstResponder) {
    return YES;
  }

  // Return NO so that we can handle the event via NSView's "keyDown:".
  return NO;
}

- (BOOL)performSuperKeyEquivalent:(NSEvent*)theEvent {
  return [super performKeyEquivalent:theEvent];
}

@end

//
// Objective-C class used as action target for menu items
//

@implementation NativeMenuItemTarget

// called when some menu item in this menu gets hit
- (IBAction)menuItemHit:(id)sender {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK;

  if (!gMenuItemsExecuteCommands) {
    return;
  }

  int tag = [sender tag];

  nsMenuGroupOwnerX* menuGroupOwner = nullptr;
  nsMenuBarX* menuBar = nullptr;
  MenuItemInfo* info = [sender representedObject];

  if (info) {
    menuGroupOwner = [info menuGroupOwner];
    if (!menuGroupOwner) {
      return;
    }
    if (menuGroupOwner->MenuObjectType() == eMenuBarObjectType) {
      menuBar = static_cast<nsMenuBarX*>(menuGroupOwner);
    }
  }

  // Do special processing if this is for an app-global command.
  if (tag == eCommand_ID_About) {
    nsIContent* mostSpecificContent = sAboutItemContent;
    if (menuBar && menuBar->mAboutItemContent) mostSpecificContent = menuBar->mAboutItemContent;
    nsMenuUtilsX::DispatchCommandTo(mostSpecificContent);
    return;
  } else if (tag == eCommand_ID_Prefs) {
    nsIContent* mostSpecificContent = sPrefItemContent;
    if (menuBar && menuBar->mPrefItemContent) mostSpecificContent = menuBar->mPrefItemContent;
    nsMenuUtilsX::DispatchCommandTo(mostSpecificContent);
    return;
  } else if (tag == eCommand_ID_HideApp) {
    [NSApp hide:sender];
    return;
  } else if (tag == eCommand_ID_HideOthers) {
    [NSApp hideOtherApplications:sender];
    return;
  } else if (tag == eCommand_ID_ShowAll) {
    [NSApp unhideAllApplications:sender];
    return;
  } else if (tag == eCommand_ID_TouchBar) {
    [NSApp toggleTouchBarCustomizationPalette:sender];
    return;
  } else if (tag == eCommand_ID_Quit) {
    nsIContent* mostSpecificContent = sQuitItemContent;
    if (menuBar && menuBar->mQuitItemContent) mostSpecificContent = menuBar->mQuitItemContent;
    // If we have some content for quit we execute it. Otherwise we send a native app terminate
    // message. If you want to stop a quit from happening, provide quit content and return
    // the event as unhandled.
    if (mostSpecificContent) {
      nsMenuUtilsX::DispatchCommandTo(mostSpecificContent);
    } else {
      nsCOMPtr<nsIAppStartup> appStartup = mozilla::components::AppStartup::Service();
      if (appStartup) {
        appStartup->Quit(nsIAppStartup::eAttemptQuit);
      }
    }
    return;
  }

  // given the commandID, look it up in our hashtable and dispatch to
  // that menu item.
  if (menuGroupOwner) {
    nsMenuItemX* menuItem = menuGroupOwner->GetMenuItemForCommandID(static_cast<uint32_t>(tag));
    if (menuItem) menuItem->DoCommand();
  }

  NS_OBJC_END_TRY_ABORT_BLOCK;
}

@end

// Objective-C class used for menu items on the Services menu to allow Gecko
// to override their standard behavior in order to stop key equivalents from
// firing in certain instances. When gMenuItemsExecuteCommands is NO, we return
// a dummy target and action instead of the actual target and action.

@implementation GeckoServicesNSMenuItem

- (id)target {
  id realTarget = [super target];
  if (gMenuItemsExecuteCommands)
    return realTarget;
  else
    return realTarget ? self : nil;
}

- (SEL)action {
  SEL realAction = [super action];
  if (gMenuItemsExecuteCommands)
    return realAction;
  else
    return realAction ? @selector(_doNothing:) : NULL;
}

- (void)_doNothing:(id)sender {
}

@end

// Objective-C class used as the Services menu so that Gecko can override the
// standard behavior of the Services menu in order to stop key equivalents
// from firing in certain instances.

@implementation GeckoServicesNSMenu

- (void)addItem:(NSMenuItem*)newItem {
  [self _overrideClassOfMenuItem:newItem];
  [super addItem:newItem];
}

- (NSMenuItem*)addItemWithTitle:(NSString*)aString
                         action:(SEL)aSelector
                  keyEquivalent:(NSString*)keyEquiv {
  NSMenuItem* newItem = [super addItemWithTitle:aString action:aSelector keyEquivalent:keyEquiv];
  [self _overrideClassOfMenuItem:newItem];
  return newItem;
}

- (void)insertItem:(NSMenuItem*)newItem atIndex:(NSInteger)index {
  [self _overrideClassOfMenuItem:newItem];
  [super insertItem:newItem atIndex:index];
}

- (NSMenuItem*)insertItemWithTitle:(NSString*)aString
                            action:(SEL)aSelector
                     keyEquivalent:(NSString*)keyEquiv
                           atIndex:(NSInteger)index {
  NSMenuItem* newItem = [super insertItemWithTitle:aString
                                            action:aSelector
                                     keyEquivalent:keyEquiv
                                           atIndex:index];
  [self _overrideClassOfMenuItem:newItem];
  return newItem;
}

- (void)_overrideClassOfMenuItem:(NSMenuItem*)menuItem {
  if ([menuItem class] == [NSMenuItem class])
    object_setClass(menuItem, [GeckoServicesNSMenuItem class]);
}

@end
