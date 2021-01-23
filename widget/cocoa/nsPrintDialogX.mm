/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"
#include "mozilla/gfx/PrintTargetCG.h"
#include "mozilla/Preferences.h"

#include "nsPrintDialogX.h"
#include "nsIPrintSettings.h"
#include "nsIPrintSettingsService.h"
#include "nsPrintSettingsX.h"
#include "nsCOMPtr.h"
#include "nsQueryObject.h"
#include "nsServiceManagerUtils.h"
#include "nsIStringBundle.h"
#include "nsCRT.h"

#import <Cocoa/Cocoa.h>
#include "nsObjCExceptions.h"

using namespace mozilla;
using mozilla::gfx::PrintTarget;

NS_IMPL_ISUPPORTS(nsPrintDialogServiceX, nsIPrintDialogService)

nsPrintDialogServiceX::nsPrintDialogServiceX() {}

nsPrintDialogServiceX::~nsPrintDialogServiceX() {}

NS_IMETHODIMP
nsPrintDialogServiceX::Init() { return NS_OK; }

NS_IMETHODIMP
nsPrintDialogServiceX::Show(nsPIDOMWindowOuter* aParent, nsIPrintSettings* aSettings) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  MOZ_ASSERT(aSettings, "aSettings must not be null");

  RefPtr<nsPrintSettingsX> settingsX(do_QueryObject(aSettings));
  if (!settingsX) return NS_ERROR_FAILURE;

  nsCOMPtr<nsIPrintSettingsService> printSettingsSvc =
      do_GetService("@mozilla.org/gfx/printsettings-service;1");

  // Set the printer name and then read the saved printer settings
  // from prefs. Reading printer-specific prefs requires the printer
  // name to be set.
  settingsX->SetPrinterNameFromPrintInfo();
  printSettingsSvc->InitPrintSettingsFromPrefs(settingsX, true, nsIPrintSettings::kInitSaveAll);

  // Set the print job title
  nsAutoString docName;
  nsresult rv = aSettings->GetTitle(docName);
  if (NS_SUCCEEDED(rv)) {
    nsAutoString adjustedTitle;
    PrintTarget::AdjustPrintJobNameForIPP(docName, adjustedTitle);
    CFStringRef cfTitleString = CFStringCreateWithCharacters(
        NULL, reinterpret_cast<const UniChar*>(adjustedTitle.BeginReading()),
        adjustedTitle.Length());
    if (cfTitleString) {
      ::PMPrintSettingsSetJobName(settingsX->GetPMPrintSettings(), cfTitleString);
      CFRelease(cfTitleString);
    }
  }

  NSPrintInfo* printInfo = settingsX->GetCocoaPrintInfo();

  // Put the print info into the current print operation, since that's where
  // [panel runModal] will look for it. We create the view because otherwise
  // we'll get unrelated warnings printed to the console.
  NSView* tmpView = [[NSView alloc] init];
  NSPrintOperation* printOperation = [NSPrintOperation printOperationWithView:tmpView
                                                                    printInfo:printInfo];
  [NSPrintOperation setCurrentOperation:printOperation];

  NSPrintPanel* panel = [NSPrintPanel printPanel];
  [panel setOptions:NSPrintPanelShowsCopies | NSPrintPanelShowsPageRange |
                    NSPrintPanelShowsPaperSize | NSPrintPanelShowsOrientation |
                    NSPrintPanelShowsScaling];
  PrintPanelAccessoryController* viewController =
      [[PrintPanelAccessoryController alloc] initWithSettings:aSettings];
  [panel addAccessoryController:viewController];
  [viewController release];

  // Show the dialog.
  nsCocoaUtils::PrepareForNativeAppModalDialog();
  int button = [panel runModal];
  nsCocoaUtils::CleanUpAfterNativeAppModalDialog();

  NSPrintInfo* copy = [[[NSPrintOperation currentOperation] printInfo] copy];
  if (!copy) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  [NSPrintOperation setCurrentOperation:nil];
  [tmpView release];

  if (button != NSFileHandlingPanelOKButton) return NS_ERROR_ABORT;

  settingsX->SetCocoaPrintInfo(copy);
  settingsX->InitUnwriteableMargin();

  // Save settings unless saving is pref'd off
  if (Preferences::GetBool("print.save_print_settings", false)) {
    printSettingsSvc->SavePrintSettingsToPrefs(settingsX, true,
                                               nsIPrintSettings::kInitSaveNativeData);
  }

  // Get coordinate space resolution for converting paper size units to inches
  NSWindow* win = [[NSApplication sharedApplication] mainWindow];
  if (win) {
    NSDictionary* devDesc = [win deviceDescription];
    if (devDesc) {
      NSSize res = [[devDesc objectForKey:NSDeviceResolution] sizeValue];
      float scale = [win backingScaleFactor];
      if (scale > 0) {
        settingsX->SetInchesScale(res.width / scale, res.height / scale);
      }
    }
  }

  // Export settings.
  [viewController exportSettings];

  // If "ignore scaling" is checked, overwrite scaling factor with 1.
  bool isShrinkToFitChecked;
  settingsX->GetShrinkToFit(&isShrinkToFitChecked);
  if (isShrinkToFitChecked) {
    NSMutableDictionary* dict = [copy dictionary];
    if (dict) {
      [dict setObject:[NSNumber numberWithFloat:1] forKey:NSPrintScalingFactor];
    }
    // Set the scaling factor to 100% in the NSPrintInfo
    // object so that it will not affect the paper size
    // retrieved from the PMPageFormat routines.
    [copy setScalingFactor:1.0];
  } else {
    aSettings->SetScaling([copy scalingFactor]);
  }

  // Set the adjusted paper size now that we've updated
  // the scaling factor.
  settingsX->InitAdjustedPaperSize();

  [copy release];

  int16_t pageRange;
  aSettings->GetPrintRange(&pageRange);
  if (pageRange != nsIPrintSettings::kRangeSelection) {
    PMPrintSettings nativePrintSettings = settingsX->GetPMPrintSettings();
    UInt32 firstPage, lastPage;
    OSStatus status = ::PMGetFirstPage(nativePrintSettings, &firstPage);
    if (status == noErr) {
      status = ::PMGetLastPage(nativePrintSettings, &lastPage);
      if (status == noErr && lastPage != UINT32_MAX) {
        aSettings->SetPrintRange(nsIPrintSettings::kRangeSpecifiedPageRange);
        aSettings->SetStartPageRange(firstPage);
        aSettings->SetEndPageRange(lastPage);
      }
    }
  }

  return NS_OK;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

NS_IMETHODIMP
nsPrintDialogServiceX::ShowPageSetup(nsPIDOMWindowOuter* aParent, nsIPrintSettings* aNSSettings) {
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  MOZ_ASSERT(aParent, "aParent must not be null");
  MOZ_ASSERT(aNSSettings, "aSettings must not be null");
  NS_ENSURE_TRUE(aNSSettings, NS_ERROR_FAILURE);

  RefPtr<nsPrintSettingsX> settingsX(do_QueryObject(aNSSettings));
  if (!settingsX) return NS_ERROR_FAILURE;

  NSPrintInfo* printInfo = settingsX->GetCocoaPrintInfo();
  NSPageLayout* pageLayout = [NSPageLayout pageLayout];
  nsCocoaUtils::PrepareForNativeAppModalDialog();
  int button = [pageLayout runModalWithPrintInfo:printInfo];
  nsCocoaUtils::CleanUpAfterNativeAppModalDialog();

  if (button == NSFileHandlingPanelOKButton) {
    nsCOMPtr<nsIPrintSettingsService> printSettingsService =
        do_GetService("@mozilla.org/gfx/printsettings-service;1");
    if (printSettingsService && Preferences::GetBool("print.save_print_settings", false)) {
      uint32_t flags = nsIPrintSettings::kInitSaveNativeData |
                       nsIPrintSettings::kInitSavePaperSize |
                       nsIPrintSettings::kInitSaveOrientation | nsIPrintSettings::kInitSaveScaling;
      printSettingsService->SavePrintSettingsToPrefs(aNSSettings, true, flags);
    }
    return NS_OK;
  }
  return NS_ERROR_ABORT;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

// Accessory view

@interface PrintPanelAccessoryView (Private)

- (NSString*)localizedString:(const char*)aKey;

- (const char*)headerFooterStringForList:(NSPopUpButton*)aList;

- (void)exportHeaderFooterSettings;

- (void)initBundle;

- (NSTextField*)label:(const char*)aLabel
            withFrame:(NSRect)aRect
            alignment:(NSTextAlignment)aAlignment;

- (void)addLabel:(const char*)aLabel withFrame:(NSRect)aRect alignment:(NSTextAlignment)aAlignment;

- (void)addLabel:(const char*)aLabel withFrame:(NSRect)aRect;

- (void)addCenteredLabel:(const char*)aLabel withFrame:(NSRect)aRect;

- (NSButton*)checkboxWithLabel:(const char*)aLabel andFrame:(NSRect)aRect;

- (NSPopUpButton*)headerFooterItemListWithFrame:(NSRect)aRect
                                   selectedItem:(const nsAString&)aCurrentString;

- (void)addOptionsSection;

- (void)addAppearanceSection;

- (void)addHeaderFooterSection;

- (NSString*)summaryValueForCheckbox:(NSButton*)aCheckbox;

- (NSString*)headerSummaryValue;

- (NSString*)footerSummaryValue;

@end

static const char sHeaderFooterTags[][4] = {"", "&T", "&U", "&D", "&P", "&PT"};

@implementation PrintPanelAccessoryView

// Public methods

- (id)initWithSettings:(nsIPrintSettings*)aSettings {
  [super initWithFrame:NSMakeRect(0, 0, 540, 185)];

  mSettings = aSettings;
  [self initBundle];
  [self addOptionsSection];
  [self addAppearanceSection];
  [self addHeaderFooterSection];

  return self;
}

- (void)exportSettings {
  if ([mPrintSelectionOnlyCheckbox state] == NSOnState) {
    mSettings->SetPrintRange(nsIPrintSettings::kRangeSelection);
  }
  mSettings->SetShrinkToFit([mShrinkToFitCheckbox state] == NSOnState);
  mSettings->SetPrintBGColors([mPrintBGColorsCheckbox state] == NSOnState);
  mSettings->SetPrintBGImages([mPrintBGImagesCheckbox state] == NSOnState);

  [self exportHeaderFooterSettings];
}

- (void)dealloc {
  NS_IF_RELEASE(mPrintBundle);
  [super dealloc];
}

// Localization

- (void)initBundle {
  nsCOMPtr<nsIStringBundleService> bundleSvc = do_GetService(NS_STRINGBUNDLE_CONTRACTID);
  bundleSvc->CreateBundle("chrome://global/locale/printdialog.properties", &mPrintBundle);
}

- (NSString*)localizedString:(const char*)aKey {
  if (!mPrintBundle) return @"";

  nsAutoString intlString;
  mPrintBundle->GetStringFromName(aKey, intlString);
  NSMutableString* s =
      [NSMutableString stringWithUTF8String:NS_ConvertUTF16toUTF8(intlString).get()];

  // Remove all underscores (they're used in the GTK dialog for accesskeys).
  [s replaceOccurrencesOfString:@"_" withString:@"" options:0 range:NSMakeRange(0, [s length])];
  return s;
}

// Widget helpers

- (NSTextField*)label:(const char*)aLabel
            withFrame:(NSRect)aRect
            alignment:(NSTextAlignment)aAlignment {
  NSTextField* label = [[[NSTextField alloc] initWithFrame:aRect] autorelease];
  [label setStringValue:[self localizedString:aLabel]];
  [label setEditable:NO];
  [label setSelectable:NO];
  [label setBezeled:NO];
  [label setBordered:NO];
  [label setDrawsBackground:NO];
  [label setFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]];
  [label setAlignment:aAlignment];
  return label;
}

- (void)addLabel:(const char*)aLabel withFrame:(NSRect)aRect alignment:(NSTextAlignment)aAlignment {
  NSTextField* label = [self label:aLabel withFrame:aRect alignment:aAlignment];
  [self addSubview:label];
}

- (void)addLabel:(const char*)aLabel withFrame:(NSRect)aRect {
  [self addLabel:aLabel withFrame:aRect alignment:NSRightTextAlignment];
}

- (void)addCenteredLabel:(const char*)aLabel withFrame:(NSRect)aRect {
  [self addLabel:aLabel withFrame:aRect alignment:NSCenterTextAlignment];
}

- (NSButton*)checkboxWithLabel:(const char*)aLabel andFrame:(NSRect)aRect {
  aRect.origin.y += 4.0f;
  NSButton* checkbox = [[[NSButton alloc] initWithFrame:aRect] autorelease];
  [checkbox setButtonType:NSSwitchButton];
  [checkbox setTitle:[self localizedString:aLabel]];
  [checkbox setFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]];
  [checkbox sizeToFit];
  return checkbox;
}

- (NSPopUpButton*)headerFooterItemListWithFrame:(NSRect)aRect
                                   selectedItem:(const nsAString&)aCurrentString {
  NSPopUpButton* list = [[[NSPopUpButton alloc] initWithFrame:aRect pullsDown:NO] autorelease];
  [list setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
  [[list cell] setControlSize:NSSmallControlSize];
  NSArray* items = [NSArray arrayWithObjects:[self localizedString:"headerFooterBlank"],
                                             [self localizedString:"headerFooterTitle"],
                                             [self localizedString:"headerFooterURL"],
                                             [self localizedString:"headerFooterDate"],
                                             [self localizedString:"headerFooterPage"],
                                             [self localizedString:"headerFooterPageTotal"], nil];
  [list addItemsWithTitles:items];

  NS_ConvertUTF16toUTF8 currentStringUTF8(aCurrentString);
  for (unsigned int i = 0; i < ArrayLength(sHeaderFooterTags); i++) {
    if (!strcmp(currentStringUTF8.get(), sHeaderFooterTags[i])) {
      [list selectItemAtIndex:i];
      break;
    }
  }

  return list;
}

// Build sections

- (void)addOptionsSection {
  // Title
  [self addLabel:"optionsTitleMac" withFrame:NSMakeRect(0, 155, 151, 22)];

  // "Print Selection Only"
  mPrintSelectionOnlyCheckbox = [self checkboxWithLabel:"selectionOnly"
                                               andFrame:NSMakeRect(156, 155, 0, 0)];

  bool canPrintSelection;
  mSettings->GetPrintOptions(nsIPrintSettings::kEnableSelectionRB, &canPrintSelection);
  [mPrintSelectionOnlyCheckbox setEnabled:canPrintSelection];

  int16_t printRange;
  mSettings->GetPrintRange(&printRange);
  if (printRange == nsIPrintSettings::kRangeSelection) {
    [mPrintSelectionOnlyCheckbox setState:NSOnState];
  }

  [self addSubview:mPrintSelectionOnlyCheckbox];

  // "Shrink To Fit"
  mShrinkToFitCheckbox = [self checkboxWithLabel:"shrinkToFit" andFrame:NSMakeRect(156, 133, 0, 0)];

  bool shrinkToFit;
  mSettings->GetShrinkToFit(&shrinkToFit);
  [mShrinkToFitCheckbox setState:(shrinkToFit ? NSOnState : NSOffState)];

  [self addSubview:mShrinkToFitCheckbox];
}

- (void)addAppearanceSection {
  // Title
  [self addLabel:"appearanceTitleMac" withFrame:NSMakeRect(0, 103, 151, 22)];

  // "Print Background Colors"
  mPrintBGColorsCheckbox = [self checkboxWithLabel:"printBGColors"
                                          andFrame:NSMakeRect(156, 103, 0, 0)];

  bool geckoBool;
  mSettings->GetPrintBGColors(&geckoBool);
  [mPrintBGColorsCheckbox setState:(geckoBool ? NSOnState : NSOffState)];

  [self addSubview:mPrintBGColorsCheckbox];

  // "Print Background Images"
  mPrintBGImagesCheckbox = [self checkboxWithLabel:"printBGImages"
                                          andFrame:NSMakeRect(156, 81, 0, 0)];

  mSettings->GetPrintBGImages(&geckoBool);
  [mPrintBGImagesCheckbox setState:(geckoBool ? NSOnState : NSOffState)];

  [self addSubview:mPrintBGImagesCheckbox];
}

- (void)addHeaderFooterSection {
  // Labels
  [self addLabel:"pageHeadersTitleMac" withFrame:NSMakeRect(0, 44, 151, 22)];
  [self addLabel:"pageFootersTitleMac" withFrame:NSMakeRect(0, 0, 151, 22)];
  [self addCenteredLabel:"left" withFrame:NSMakeRect(156, 22, 100, 22)];
  [self addCenteredLabel:"center" withFrame:NSMakeRect(256, 22, 100, 22)];
  [self addCenteredLabel:"right" withFrame:NSMakeRect(356, 22, 100, 22)];

  // Lists
  nsString sel;

  mSettings->GetHeaderStrLeft(sel);
  mHeaderLeftList = [self headerFooterItemListWithFrame:NSMakeRect(156, 44, 100, 22)
                                           selectedItem:sel];
  [self addSubview:mHeaderLeftList];

  mSettings->GetHeaderStrCenter(sel);
  mHeaderCenterList = [self headerFooterItemListWithFrame:NSMakeRect(256, 44, 100, 22)
                                             selectedItem:sel];
  [self addSubview:mHeaderCenterList];

  mSettings->GetHeaderStrRight(sel);
  mHeaderRightList = [self headerFooterItemListWithFrame:NSMakeRect(356, 44, 100, 22)
                                            selectedItem:sel];
  [self addSubview:mHeaderRightList];

  mSettings->GetFooterStrLeft(sel);
  mFooterLeftList = [self headerFooterItemListWithFrame:NSMakeRect(156, 0, 100, 22)
                                           selectedItem:sel];
  [self addSubview:mFooterLeftList];

  mSettings->GetFooterStrCenter(sel);
  mFooterCenterList = [self headerFooterItemListWithFrame:NSMakeRect(256, 0, 100, 22)
                                             selectedItem:sel];
  [self addSubview:mFooterCenterList];

  mSettings->GetFooterStrRight(sel);
  mFooterRightList = [self headerFooterItemListWithFrame:NSMakeRect(356, 0, 100, 22)
                                            selectedItem:sel];
  [self addSubview:mFooterRightList];
}

// Export settings

- (const char*)headerFooterStringForList:(NSPopUpButton*)aList {
  NSInteger index = [aList indexOfSelectedItem];
  NS_ASSERTION(index < NSInteger(ArrayLength(sHeaderFooterTags)),
               "Index of dropdown is higher than expected!");
  return sHeaderFooterTags[index];
}

- (void)exportHeaderFooterSettings {
  const char* headerFooterStr;
  headerFooterStr = [self headerFooterStringForList:mHeaderLeftList];
  mSettings->SetHeaderStrLeft(NS_ConvertUTF8toUTF16(headerFooterStr));

  headerFooterStr = [self headerFooterStringForList:mHeaderCenterList];
  mSettings->SetHeaderStrCenter(NS_ConvertUTF8toUTF16(headerFooterStr));

  headerFooterStr = [self headerFooterStringForList:mHeaderRightList];
  mSettings->SetHeaderStrRight(NS_ConvertUTF8toUTF16(headerFooterStr));

  headerFooterStr = [self headerFooterStringForList:mFooterLeftList];
  mSettings->SetFooterStrLeft(NS_ConvertUTF8toUTF16(headerFooterStr));

  headerFooterStr = [self headerFooterStringForList:mFooterCenterList];
  mSettings->SetFooterStrCenter(NS_ConvertUTF8toUTF16(headerFooterStr));

  headerFooterStr = [self headerFooterStringForList:mFooterRightList];
  mSettings->SetFooterStrRight(NS_ConvertUTF8toUTF16(headerFooterStr));
}

// Summary

- (NSString*)summaryValueForCheckbox:(NSButton*)aCheckbox {
  if (![aCheckbox isEnabled]) return [self localizedString:"summaryNAValue"];

  return [aCheckbox state] == NSOnState ? [self localizedString:"summaryOnValue"]
                                        : [self localizedString:"summaryOffValue"];
}

- (NSString*)headerSummaryValue {
  return [[mHeaderLeftList titleOfSelectedItem]
      stringByAppendingString:
          [@", "
              stringByAppendingString:
                  [[mHeaderCenterList titleOfSelectedItem]
                      stringByAppendingString:
                          [@", " stringByAppendingString:[mHeaderRightList titleOfSelectedItem]]]]];
}

- (NSString*)footerSummaryValue {
  return [[mFooterLeftList titleOfSelectedItem]
      stringByAppendingString:
          [@", "
              stringByAppendingString:
                  [[mFooterCenterList titleOfSelectedItem]
                      stringByAppendingString:
                          [@", " stringByAppendingString:[mFooterRightList titleOfSelectedItem]]]]];
}

- (NSArray*)localizedSummaryItems {
  return [NSArray
      arrayWithObjects:
          [NSDictionary
              dictionaryWithObjectsAndKeys:[self localizedString:"summarySelectionOnlyTitle"],
                                           NSPrintPanelAccessorySummaryItemNameKey,
                                           [self
                                               summaryValueForCheckbox:mPrintSelectionOnlyCheckbox],
                                           NSPrintPanelAccessorySummaryItemDescriptionKey, nil],
          [NSDictionary
              dictionaryWithObjectsAndKeys:[self localizedString:"summaryShrinkToFitTitle"],
                                           NSPrintPanelAccessorySummaryItemNameKey,
                                           [self summaryValueForCheckbox:mShrinkToFitCheckbox],
                                           NSPrintPanelAccessorySummaryItemDescriptionKey, nil],
          [NSDictionary
              dictionaryWithObjectsAndKeys:[self localizedString:"summaryPrintBGColorsTitle"],
                                           NSPrintPanelAccessorySummaryItemNameKey,
                                           [self summaryValueForCheckbox:mPrintBGColorsCheckbox],
                                           NSPrintPanelAccessorySummaryItemDescriptionKey, nil],
          [NSDictionary
              dictionaryWithObjectsAndKeys:[self localizedString:"summaryPrintBGImagesTitle"],
                                           NSPrintPanelAccessorySummaryItemNameKey,
                                           [self summaryValueForCheckbox:mPrintBGImagesCheckbox],
                                           NSPrintPanelAccessorySummaryItemDescriptionKey, nil],
          [NSDictionary dictionaryWithObjectsAndKeys:[self localizedString:"summaryHeaderTitle"],
                                                     NSPrintPanelAccessorySummaryItemNameKey,
                                                     [self headerSummaryValue],
                                                     NSPrintPanelAccessorySummaryItemDescriptionKey,
                                                     nil],
          [NSDictionary dictionaryWithObjectsAndKeys:[self localizedString:"summaryFooterTitle"],
                                                     NSPrintPanelAccessorySummaryItemNameKey,
                                                     [self footerSummaryValue],
                                                     NSPrintPanelAccessorySummaryItemDescriptionKey,
                                                     nil],
          nil];
}

@end

// Accessory controller

@implementation PrintPanelAccessoryController

- (id)initWithSettings:(nsIPrintSettings*)aSettings {
  [super initWithNibName:nil bundle:nil];

  NSView* accView = [[PrintPanelAccessoryView alloc] initWithSettings:aSettings];
  [self setView:accView];
  [accView release];
  return self;
}

- (void)exportSettings {
  return [(PrintPanelAccessoryView*)[self view] exportSettings];
}

- (NSArray*)localizedSummaryItems {
  return [(PrintPanelAccessoryView*)[self view] localizedSummaryItems];
}

@end
