/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* a presentation of a document, part 1 */

#include "mozilla/ArrayUtils.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/EventDispatcher.h"
#include "mozilla/EventStateManager.h"

#include "base/basictypes.h"

#include "nsCOMPtr.h"
#include "nsPresContext.h"
#include "nsIPresShell.h"
#include "nsDocShell.h"
#include "nsIContentViewer.h"
#include "nsPIDOMWindow.h"
#include "mozilla/StyleSetHandle.h"
#include "mozilla/StyleSetHandleInlines.h"
#include "nsIContent.h"
#include "nsIFrame.h"
#include "nsIDocument.h"
#include "nsIPrintSettings.h"
#include "nsILanguageAtomService.h"
#include "mozilla/LookAndFeel.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsIDOMHTMLDocument.h"
#include "nsIDOMHTMLElement.h"
#include "nsIWeakReferenceUtils.h"
#include "nsThreadUtils.h"
#include "nsFrameManager.h"
#include "nsLayoutUtils.h"
#include "nsViewManager.h"
#include "mozilla/RestyleManager.h"
#include "mozilla/RestyleManagerHandle.h"
#include "mozilla/RestyleManagerHandleInlines.h"
#include "SurfaceCacheUtils.h"
#include "nsCSSRuleProcessor.h"
#include "nsRuleNode.h"
#include "gfxPlatform.h"
#include "nsCSSRules.h"
#include "nsFontFaceLoader.h"
#include "mozilla/EffectCompositor.h"
#include "mozilla/EventListenerManager.h"
#include "prenv.h"
#include "nsPluginFrame.h"
#include "nsTransitionManager.h"
#include "nsAnimationManager.h"
#include "CounterStyleManager.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/dom/Element.h"
#include "nsIMessageManager.h"
#include "mozilla/dom/MediaQueryList.h"
#include "nsSMILAnimationController.h"
#include "mozilla/css/ImageLoader.h"
#include "mozilla/dom/PBrowserParent.h"
#include "mozilla/dom/TabChild.h"
#include "mozilla/dom/TabParent.h"
#include "nsRefreshDriver.h"
#include "Layers.h"
#include "LayerUserData.h"
#include "ClientLayerManager.h"
#include "mozilla/dom/NotifyPaintEvent.h"
#include "gfxPrefs.h"
#include "nsIDOMChromeWindow.h"
#include "nsFrameLoader.h"
#include "mozilla/dom/FontFaceSet.h"
#include "nsContentUtils.h"
#include "nsPIWindowRoot.h"
#include "mozilla/Preferences.h"
#include "gfxTextRun.h"
#include "nsFontFaceUtils.h"
#include "nsLayoutStylesheetCache.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"

#if defined(MOZ_WIDGET_GTK)
#include "gfxPlatformGtk.h" // xxx - for UseFcFontList
#endif


// Needed for Start/Stop of Image Animation
#include "imgIContainer.h"
#include "nsIImageLoadingContent.h"

#include "nsCSSParser.h"
#include "nsBidiUtils.h"
#include "nsServiceManagerUtils.h"

#include "mozilla/dom/URL.h"

using namespace mozilla;
using namespace mozilla::dom;
using namespace mozilla::layers;

uint8_t gNotifySubDocInvalidationData;

/**
 * Layer UserData for ContainerLayers that want to be notified
 * of local invalidations of them and their descendant layers.
 * Pass a callback to ComputeDifferences to have these called.
 */
class ContainerLayerPresContext : public LayerUserData {
public:
  nsPresContext* mPresContext;
};

namespace {

class CharSetChangingRunnable : public Runnable
{
public:
  CharSetChangingRunnable(nsPresContext* aPresContext,
                          const nsCString& aCharSet)
    : mPresContext(aPresContext),
      mCharSet(aCharSet)
  {
  }

  NS_IMETHOD Run() override
  {
    mPresContext->DoChangeCharSet(mCharSet);
    return NS_OK;
  }

private:
  RefPtr<nsPresContext> mPresContext;
  nsCString mCharSet;
};

} // namespace

nscolor
nsPresContext::MakeColorPref(const nsString& aColor)
{
  nsCSSParser parser;
  nsCSSValue value;
  if (!parser.ParseColorString(aColor, nullptr, 0, value)) {
    // Any better choices?
    return NS_RGB(0, 0, 0);
  }

  nscolor color;
  return nsRuleNode::ComputeColor(value, this, nullptr, color)
    ? color
    : NS_RGB(0, 0, 0);
}

bool
nsPresContext::IsDOMPaintEventPending()
{
  if (mFireAfterPaintEvents) {
    return true;
  }
  nsRootPresContext* drpc = GetRootPresContext();
  if (drpc && drpc->mRefreshDriver->ViewManagerFlushIsPending()) {
    // Since we're promising that there will be a MozAfterPaint event
    // fired, we record an empty invalidation in case display list
    // invalidation doesn't invalidate anything further.
    NotifyInvalidation(nsRect(0, 0, 0, 0), 0);
    NS_ASSERTION(mFireAfterPaintEvents, "Why aren't we planning to fire the event?");
    return true;
  }
  return false;
}

void
nsPresContext::PrefChangedCallback(const char* aPrefName, void* instance_data)
{
  RefPtr<nsPresContext>  presContext =
    static_cast<nsPresContext*>(instance_data);

  NS_ASSERTION(nullptr != presContext, "bad instance data");
  if (nullptr != presContext) {
    presContext->PreferenceChanged(aPrefName);
  }
}

void
nsPresContext::PrefChangedUpdateTimerCallback(nsITimer *aTimer, void *aClosure)
{
  nsPresContext*  presContext = (nsPresContext*)aClosure;
  NS_ASSERTION(presContext != nullptr, "bad instance data");
  if (presContext)
    presContext->UpdateAfterPreferencesChanged();
}

static bool
IsVisualCharset(const nsCString& aCharset)
{
  if (aCharset.LowerCaseEqualsLiteral("ibm862")             // Hebrew
      || aCharset.LowerCaseEqualsLiteral("iso-8859-8") ) {  // Hebrew
    return true; // visual text type
  }
  else {
    return false; // logical text type
  }
}

  // NOTE! nsPresContext::operator new() zeroes out all members, so don't
  // bother initializing members to 0.

nsPresContext::nsPresContext(nsIDocument* aDocument, nsPresContextType aType)
  : mType(aType), mDocument(aDocument), mBaseMinFontSize(0),
    mTextZoom(1.0), mFullZoom(1.0), mOverrideDPPX(0.0),
    mLastFontInflationScreenSize(gfxSize(-1.0, -1.0)),
    mPageSize(-1, -1), mPPScale(1.0f),
    mViewportStyleScrollbar(NS_STYLE_OVERFLOW_AUTO, NS_STYLE_OVERFLOW_AUTO),
    mImageAnimationModePref(imgIContainer::kNormalAnimMode),
    mAllInvalidated(false),
    mPaintFlashing(false), mPaintFlashingInitialized(false)
{
  // NOTE! nsPresContext::operator new() zeroes out all members, so don't
  // bother initializing members to 0.

  mDoScaledTwips = true;

  SetBackgroundImageDraw(true);		// always draw the background
  SetBackgroundColorDraw(true);

  mBackgroundColor = NS_RGB(0xFF, 0xFF, 0xFF);

  mUseDocumentColors = true;
  mUseDocumentFonts = true;

  // the minimum font-size is unconstrained by default

  mLinkColor = NS_RGB(0x00, 0x00, 0xEE);
  mActiveLinkColor = NS_RGB(0xEE, 0x00, 0x00);
  mVisitedLinkColor = NS_RGB(0x55, 0x1A, 0x8B);
  mUnderlineLinks = true;
  mSendAfterPaintToContent = false;

  mFocusTextColor = mDefaultColor;
  mFocusBackgroundColor = mBackgroundColor;
  mFocusRingWidth = 1;

  mBodyTextColor = mDefaultColor;

  if (aType == eContext_Galley) {
    mMedium = nsGkAtoms::screen;
  } else {
    mMedium = nsGkAtoms::print;
    mPaginated = true;
  }
  mMediaEmulated = mMedium;

  if (!IsDynamic()) {
    mImageAnimationMode = imgIContainer::kDontAnimMode;
    mNeverAnimate = true;
  } else {
    mImageAnimationMode = imgIContainer::kNormalAnimMode;
    mNeverAnimate = false;
  }
  NS_ASSERTION(mDocument, "Null document");

  mCounterStylesDirty = true;

  // if text perf logging enabled, init stats struct
  if (MOZ_LOG_TEST(gfxPlatform::GetLog(eGfxLog_textperf), LogLevel::Warning)) {
    mTextPerf = new gfxTextPerfMetrics();
  }

  if (Preferences::GetBool(GFX_MISSING_FONTS_NOTIFY_PREF)) {
    mMissingFonts = new gfxMissingFontRecorder();
  }
}

void
nsPresContext::Destroy()
{
  if (mEventManager) {
    // unclear if these are needed, but can't hurt
    mEventManager->NotifyDestroyPresContext(this);
    mEventManager->SetPresContext(nullptr);
    mEventManager = nullptr;
  }

  if (mPrefChangedTimer)
  {
    mPrefChangedTimer->Cancel();
    mPrefChangedTimer = nullptr;
  }

  // Unregister preference callbacks
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "font.",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "browser.display.",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "browser.underline_anchors",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "browser.anchor_color",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "browser.active_color",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "browser.visited_color",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "image.animation_mode",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "bidi.",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "dom.send_after_paint_to_content",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "gfx.font_rendering.",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "layout.css.dpi",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "layout.css.devPixelsPerPx",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "nglayout.debug.paint_flashing",
                                  this);
  Preferences::UnregisterCallback(nsPresContext::PrefChangedCallback,
                                  "nglayout.debug.paint_flashing_chrome",
                                  this);

  mRefreshDriver = nullptr;
}

nsPresContext::~nsPresContext()
{
  NS_PRECONDITION(!mShell, "Presshell forgot to clear our mShell pointer");
  DetachShell();

  Destroy();
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsPresContext)
   NS_INTERFACE_MAP_ENTRY(nsISupports)
   NS_INTERFACE_MAP_ENTRY(nsIObserver)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsPresContext)
NS_IMPL_CYCLE_COLLECTING_RELEASE_WITH_LAST_RELEASE(nsPresContext, LastRelease())

void
nsPresContext::LastRelease()
{
  if (IsRoot()) {
    static_cast<nsRootPresContext*>(this)->CancelDidPaintTimer();
  }
  if (mMissingFonts) {
    mMissingFonts->Clear();
  }
}

NS_IMPL_CYCLE_COLLECTION_CLASS(nsPresContext)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(nsPresContext)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mAnimationManager);
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mDocument);
  // NS_IMPL_CYCLE_COLLECTION_TRAVERSE_RAWPTR(mDeviceContext); // not xpcom
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mEffectCompositor);
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mEventManager);
  // NS_IMPL_CYCLE_COLLECTION_TRAVERSE_RAWPTR(mLanguage); // an atom

  // NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mTheme); // a service
  // NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mLangService); // a service
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPrintSettings);
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPrefChangedTimer);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(nsPresContext)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mAnimationManager);
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mDocument);
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mDeviceContext); // worth bothering?
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mEffectCompositor);
  // NS_RELEASE(tmp->mLanguage); // an atom
  // NS_IMPL_CYCLE_COLLECTION_UNLINK(mTheme); // a service
  // NS_IMPL_CYCLE_COLLECTION_UNLINK(mLangService); // a service
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPrintSettings);

  tmp->Destroy();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

// whether no native theme service exists;
// if this gets set to true, we'll stop asking for it.
static bool sNoTheme = false;

// Set to true when LookAndFeelChanged needs to be called.  This is used
// because the look and feel is a service, so there's no need to notify it from
// more than one prescontext.
static bool sLookAndFeelChanged;

// Set to true when ThemeChanged needs to be called on mTheme.  This is used
// because mTheme is a service, so there's no need to notify it from more than
// one prescontext.
static bool sThemeChanged;

void
nsPresContext::GetDocumentColorPreferences()
{
  // Make sure the preferences are initialized.  In the normal run,
  // they would already be, because gfxPlatform would have been created,
  // but in some reference tests, that is not the case.
  gfxPrefs::GetSingleton();

  int32_t useAccessibilityTheme = 0;
  bool usePrefColors = true;
  bool isChromeDocShell = false;
  static int32_t sDocumentColorsSetting;
  static bool sDocumentColorsSettingPrefCached = false;
  if (!sDocumentColorsSettingPrefCached) {
    sDocumentColorsSettingPrefCached = true;
    Preferences::AddIntVarCache(&sDocumentColorsSetting,
                                "browser.display.document_color_use",
                                0);
  }

  nsIDocument* doc = mDocument->GetDisplayDocument();
  if (doc && doc->GetDocShell()) {
    isChromeDocShell = nsIDocShellTreeItem::typeChrome ==
                       doc->GetDocShell()->ItemType();
  } else {
    nsCOMPtr<nsIDocShellTreeItem> docShell(mContainer);
    if (docShell) {
      isChromeDocShell = nsIDocShellTreeItem::typeChrome == docShell->ItemType();
    }
  }

  mIsChromeOriginImage = mDocument->IsBeingUsedAsImage() &&
                         IsChromeURI(mDocument->GetDocumentURI());

  if (isChromeDocShell || mIsChromeOriginImage) {
    usePrefColors = false;
  } else {
    useAccessibilityTheme =
      LookAndFeel::GetInt(LookAndFeel::eIntID_UseAccessibilityTheme, 0);
    usePrefColors = !useAccessibilityTheme;
  }
  if (usePrefColors) {
    usePrefColors =
      !Preferences::GetBool("browser.display.use_system_colors", false);
  }

  if (usePrefColors) {
    nsAdoptingString colorStr =
      Preferences::GetString("browser.display.foreground_color");

    if (!colorStr.IsEmpty()) {
      mDefaultColor = MakeColorPref(colorStr);
    }

    colorStr = Preferences::GetString("browser.display.background_color");

    if (!colorStr.IsEmpty()) {
      mBackgroundColor = MakeColorPref(colorStr);
    }
  }
  else {
    mDefaultColor =
      LookAndFeel::GetColor(LookAndFeel::eColorID_WindowForeground,
                            NS_RGB(0x00, 0x00, 0x00));
    mBackgroundColor =
      LookAndFeel::GetColor(LookAndFeel::eColorID_WindowBackground,
                            NS_RGB(0xFF, 0xFF, 0xFF));
  }

  // Wherever we got the default background color from, ensure it is
  // opaque.
  mBackgroundColor = NS_ComposeColors(NS_RGB(0xFF, 0xFF, 0xFF),
                                      mBackgroundColor);


  // Now deal with the pref:
  // 0 = default: always, except in high contrast mode
  // 1 = always
  // 2 = never
  if (sDocumentColorsSetting == 1 || mDocument->IsBeingUsedAsImage()) {
    mUseDocumentColors = true;
  } else if (sDocumentColorsSetting == 2) {
    mUseDocumentColors = isChromeDocShell || mIsChromeOriginImage;
  } else {
    MOZ_ASSERT(!useAccessibilityTheme ||
               !(isChromeDocShell || mIsChromeOriginImage),
               "The accessibility theme should only be on for non-chrome");
    mUseDocumentColors = !useAccessibilityTheme;
  }
}

void
nsPresContext::GetUserPreferences()
{
  if (!GetPresShell()) {
    // No presshell means nothing to do here.  We'll do this when we
    // get a presshell.
    return;
  }

  mAutoQualityMinFontSizePixelsPref =
    Preferences::GetInt("browser.display.auto_quality_min_font_size");

  // * document colors
  GetDocumentColorPreferences();

  mSendAfterPaintToContent =
    Preferences::GetBool("dom.send_after_paint_to_content",
                         mSendAfterPaintToContent);

  // * link colors
  mUnderlineLinks =
    Preferences::GetBool("browser.underline_anchors", mUnderlineLinks);

  nsAdoptingString colorStr = Preferences::GetString("browser.anchor_color");

  if (!colorStr.IsEmpty()) {
    mLinkColor = MakeColorPref(colorStr);
  }

  colorStr = Preferences::GetString("browser.active_color");

  if (!colorStr.IsEmpty()) {
    mActiveLinkColor = MakeColorPref(colorStr);
  }

  colorStr = Preferences::GetString("browser.visited_color");

  if (!colorStr.IsEmpty()) {
    mVisitedLinkColor = MakeColorPref(colorStr);
  }

  mUseFocusColors =
    Preferences::GetBool("browser.display.use_focus_colors", mUseFocusColors);

  mFocusTextColor = mDefaultColor;
  mFocusBackgroundColor = mBackgroundColor;

  colorStr = Preferences::GetString("browser.display.focus_text_color");

  if (!colorStr.IsEmpty()) {
    mFocusTextColor = MakeColorPref(colorStr);
  }

  colorStr = Preferences::GetString("browser.display.focus_background_color");

  if (!colorStr.IsEmpty()) {
    mFocusBackgroundColor = MakeColorPref(colorStr);
  }

  mFocusRingWidth =
    Preferences::GetInt("browser.display.focus_ring_width", mFocusRingWidth);

  mFocusRingOnAnything =
    Preferences::GetBool("browser.display.focus_ring_on_anything",
                         mFocusRingOnAnything);

  mFocusRingStyle =
    Preferences::GetInt("browser.display.focus_ring_style", mFocusRingStyle);

  mBodyTextColor = mDefaultColor;

  // * use fonts?
  mUseDocumentFonts =
    Preferences::GetInt("browser.display.use_document_fonts") != 0;

  mPrefScrollbarSide = Preferences::GetInt("layout.scrollbar.side");

  mLangGroupFontPrefs.Reset();
  StaticPresData::Get()->ResetCachedFontPrefs();

  // * image animation
  const nsAdoptingCString& animatePref =
    Preferences::GetCString("image.animation_mode");
  if (animatePref.EqualsLiteral("normal"))
    mImageAnimationModePref = imgIContainer::kNormalAnimMode;
  else if (animatePref.EqualsLiteral("none"))
    mImageAnimationModePref = imgIContainer::kDontAnimMode;
  else if (animatePref.EqualsLiteral("once"))
    mImageAnimationModePref = imgIContainer::kLoopOnceAnimMode;
  else // dynamic change to invalid value should act like it does initially
    mImageAnimationModePref = imgIContainer::kNormalAnimMode;

  uint32_t bidiOptions = GetBidi();

  int32_t prefInt =
    Preferences::GetInt(IBMBIDI_TEXTDIRECTION_STR,
                        GET_BIDI_OPTION_DIRECTION(bidiOptions));
  SET_BIDI_OPTION_DIRECTION(bidiOptions, prefInt);
  mPrefBidiDirection = prefInt;

  prefInt =
    Preferences::GetInt(IBMBIDI_TEXTTYPE_STR,
                        GET_BIDI_OPTION_TEXTTYPE(bidiOptions));
  SET_BIDI_OPTION_TEXTTYPE(bidiOptions, prefInt);

  prefInt =
    Preferences::GetInt(IBMBIDI_NUMERAL_STR,
                        GET_BIDI_OPTION_NUMERAL(bidiOptions));
  SET_BIDI_OPTION_NUMERAL(bidiOptions, prefInt);

  // We don't need to force reflow: either we are initializing a new
  // prescontext or we are being called from UpdateAfterPreferencesChanged()
  // which triggers a reflow anyway.
  SetBidi(bidiOptions, false);
}

void
nsPresContext::InvalidatePaintedLayers()
{
  if (!mShell)
    return;
  nsIFrame* rootFrame = mShell->FrameManager()->GetRootFrame();
  if (rootFrame) {
    // FrameLayerBuilder caches invalidation-related values that depend on the
    // appunits-per-dev-pixel ratio, so ensure that all PaintedLayer drawing
    // is completely flushed.
    rootFrame->InvalidateFrameSubtree();
  }
}

void
nsPresContext::AppUnitsPerDevPixelChanged()
{
  InvalidatePaintedLayers();

  if (mDeviceContext) {
    mDeviceContext->FlushFontCache();
  }

  if (HasCachedStyleData()) {
    // All cached style data must be recomputed.
    MediaFeatureValuesChanged(eRestyle_ForceDescendants, NS_STYLE_HINT_REFLOW);
  }

  mCurAppUnitsPerDevPixel = AppUnitsPerDevPixel();
}

void
nsPresContext::PreferenceChanged(const char* aPrefName)
{
  nsDependentCString prefName(aPrefName);
  if (prefName.EqualsLiteral("layout.css.dpi") ||
      prefName.EqualsLiteral("layout.css.devPixelsPerPx")) {
    int32_t oldAppUnitsPerDevPixel = AppUnitsPerDevPixel();
    if (mDeviceContext->CheckDPIChange() && mShell) {
      nsCOMPtr<nsIPresShell> shell = mShell;
      // Re-fetch the view manager's window dimensions in case there's a deferred
      // resize which hasn't affected our mVisibleArea yet
      nscoord oldWidthAppUnits, oldHeightAppUnits;
      RefPtr<nsViewManager> vm = shell->GetViewManager();
      if (!vm) {
        return;
      }
      vm->GetWindowDimensions(&oldWidthAppUnits, &oldHeightAppUnits);
      float oldWidthDevPixels = oldWidthAppUnits/oldAppUnitsPerDevPixel;
      float oldHeightDevPixels = oldHeightAppUnits/oldAppUnitsPerDevPixel;

      nscoord width = NSToCoordRound(oldWidthDevPixels*AppUnitsPerDevPixel());
      nscoord height = NSToCoordRound(oldHeightDevPixels*AppUnitsPerDevPixel());
      vm->SetWindowDimensions(width, height);

      AppUnitsPerDevPixelChanged();
    }
    return;
  }
  if (prefName.EqualsLiteral(GFX_MISSING_FONTS_NOTIFY_PREF)) {
    if (Preferences::GetBool(GFX_MISSING_FONTS_NOTIFY_PREF)) {
      if (!mMissingFonts) {
        mMissingFonts = new gfxMissingFontRecorder();
        // trigger reflow to detect missing fonts on the current page
        mPrefChangePendingNeedsReflow = true;
      }
    } else {
      if (mMissingFonts) {
        mMissingFonts->Clear();
      }
      mMissingFonts = nullptr;
    }
  }
  if (StringBeginsWith(prefName, NS_LITERAL_CSTRING("font."))) {
    // Changes to font family preferences don't change anything in the
    // computed style data, so the style system won't generate a reflow
    // hint for us.  We need to do that manually.

    // FIXME We could probably also handle changes to
    // browser.display.auto_quality_min_font_size here, but that
    // probably also requires clearing the text run cache, so don't
    // bother (yet, anyway).
    mPrefChangePendingNeedsReflow = true;
  }
  if (StringBeginsWith(prefName, NS_LITERAL_CSTRING("bidi."))) {
    // Changes to bidi prefs need to trigger a reflow (see bug 443629)
    mPrefChangePendingNeedsReflow = true;

    // Changes to bidi.numeral also needs to empty the text run cache.
    // This is handled in gfxTextRunWordCache.cpp.
  }
  if (StringBeginsWith(prefName, NS_LITERAL_CSTRING("gfx.font_rendering."))) {
    // Changes to font_rendering prefs need to trigger a reflow
    mPrefChangePendingNeedsReflow = true;
  }
  // we use a zero-delay timer to coalesce multiple pref updates
  if (!mPrefChangedTimer)
  {
    // We will end up calling InvalidatePreferenceSheets one from each pres
    // context, but all it's doing is clearing its cached sheet pointers,
    // so it won't be wastefully recreating the sheet multiple times.
    // The first pres context that has its mPrefChangedTimer called will
    // be the one to cause the reconstruction of the pref style sheet.
    nsLayoutStylesheetCache::InvalidatePreferenceSheets();
    mPrefChangedTimer = CreateTimer(PrefChangedUpdateTimerCallback, 0);
    if (!mPrefChangedTimer) {
      return;
    }
  }
  if (prefName.EqualsLiteral("nglayout.debug.paint_flashing") ||
      prefName.EqualsLiteral("nglayout.debug.paint_flashing_chrome")) {
    mPaintFlashingInitialized = false;
    return;
  }
}

void
nsPresContext::UpdateAfterPreferencesChanged()
{
  mPrefChangedTimer = nullptr;

  if (!mContainer) {
    // Delay updating until there is a container
    mNeedsPrefUpdate = true;
    return;
  }

  nsCOMPtr<nsIDocShellTreeItem> docShell(mContainer);
  if (docShell && nsIDocShellTreeItem::typeChrome == docShell->ItemType()) {
    return;
  }

  // Initialize our state from the user preferences
  GetUserPreferences();

  // update the presShell: tell it to set the preference style rules up
  if (mShell) {
    mShell->UpdatePreferenceStyles();
  }

  InvalidatePaintedLayers();
  mDeviceContext->FlushFontCache();

  nsChangeHint hint = nsChangeHint(0);

  if (mPrefChangePendingNeedsReflow) {
    hint |= NS_STYLE_HINT_REFLOW;
  }

  // Preferences require rerunning selector matching because we rebuild
  // the pref style sheet for some preference changes.
  RebuildAllStyleData(hint, eRestyle_Subtree);
}

nsresult
nsPresContext::Init(nsDeviceContext* aDeviceContext)
{
  NS_ASSERTION(!mInitialized, "attempt to reinit pres context");
  NS_ENSURE_ARG(aDeviceContext);

  mDeviceContext = aDeviceContext;

  if (mDeviceContext->SetFullZoom(mFullZoom))
    mDeviceContext->FlushFontCache();
  mCurAppUnitsPerDevPixel = AppUnitsPerDevPixel();

  mEventManager = new mozilla::EventStateManager();

  mEffectCompositor = new mozilla::EffectCompositor(this);
  mTransitionManager = new nsTransitionManager(this);
  mAnimationManager = new nsAnimationManager(this);

  if (mDocument->GetDisplayDocument()) {
    NS_ASSERTION(mDocument->GetDisplayDocument()->GetShell() &&
                 mDocument->GetDisplayDocument()->GetShell()->GetPresContext(),
                 "Why are we being initialized?");
    mRefreshDriver = mDocument->GetDisplayDocument()->GetShell()->
      GetPresContext()->RefreshDriver();
  } else {
    nsIDocument* parent = mDocument->GetParentDocument();
    // Unfortunately, sometimes |parent| here has no presshell because
    // printing screws up things.  Assert that in other cases it does,
    // but whenever the shell is null just fall back on using our own
    // refresh driver.
    NS_ASSERTION(!parent || mDocument->IsStaticDocument() || parent->GetShell(),
                 "How did we end up with a presshell if our parent doesn't "
                 "have one?");
    if (parent && parent->GetShell()) {
      NS_ASSERTION(parent->GetShell()->GetPresContext(),
                   "How did we get a presshell?");

      // We don't have our container set yet at this point
      nsCOMPtr<nsIDocShellTreeItem> ourItem = mDocument->GetDocShell();
      if (ourItem) {
        nsCOMPtr<nsIDocShellTreeItem> parentItem;
        ourItem->GetSameTypeParent(getter_AddRefs(parentItem));
        if (parentItem) {
          Element* containingElement =
            parent->FindContentForSubDocument(mDocument);
          if (!containingElement->IsXULElement() ||
              !containingElement->
                HasAttr(kNameSpaceID_None,
                        nsGkAtoms::forceOwnRefreshDriver)) {
            mRefreshDriver = parent->GetShell()->GetPresContext()->RefreshDriver();
          }
        }
      }
    }

    if (!mRefreshDriver) {
      mRefreshDriver = new nsRefreshDriver(this);
    }
  }

  mLangService = do_GetService(NS_LANGUAGEATOMSERVICE_CONTRACTID);

  // Register callbacks so we're notified when the preferences change
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "font.",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "browser.display.",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "browser.underline_anchors",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "browser.anchor_color",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "browser.active_color",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "browser.visited_color",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "image.animation_mode",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "bidi.",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "dom.send_after_paint_to_content",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "gfx.font_rendering.",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "layout.css.dpi",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "layout.css.devPixelsPerPx",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "nglayout.debug.paint_flashing",
                                this);
  Preferences::RegisterCallback(nsPresContext::PrefChangedCallback,
                                "nglayout.debug.paint_flashing_chrome",
                                this);

  nsresult rv = mEventManager->Init();
  NS_ENSURE_SUCCESS(rv, rv);

  mEventManager->SetPresContext(this);

#ifdef RESTYLE_LOGGING
  mRestyleLoggingEnabled = RestyleManager::RestyleLoggingInitiallyEnabled();
#endif

#ifdef DEBUG
  mInitialized = true;
#endif

  mBorderWidthTable[NS_STYLE_BORDER_WIDTH_THIN] = CSSPixelsToAppUnits(1);
  mBorderWidthTable[NS_STYLE_BORDER_WIDTH_MEDIUM] = CSSPixelsToAppUnits(3);
  mBorderWidthTable[NS_STYLE_BORDER_WIDTH_THICK] = CSSPixelsToAppUnits(5);

  return NS_OK;
}

// Note: We don't hold a reference on the shell; it has a reference to
// us
void
nsPresContext::AttachShell(nsIPresShell* aShell, StyleBackendType aBackendType)
{
  MOZ_ASSERT(!mShell);
  mShell = aShell;

  if (aBackendType == StyleBackendType::Servo) {
    mRestyleManager = new ServoRestyleManager(this);
  } else {
    // Since RestyleManager is also the name of a method of nsPresContext,
    // it is necessary to prefix the class with the mozilla namespace
    // here.
    mRestyleManager = new mozilla::RestyleManager(this);
  }

  // Since CounterStyleManager is also the name of a method of
  // nsPresContext, it is necessary to prefix the class with the mozilla
  // namespace here.
  mCounterStyleManager = new mozilla::CounterStyleManager(this);

  nsIDocument *doc = mShell->GetDocument();
  NS_ASSERTION(doc, "expect document here");
  if (doc) {
    // Have to update PresContext's mDocument before calling any other methods.
    mDocument = doc;
  }
  // Initialize our state from the user preferences, now that we
  // have a presshell, and hence a document.
  GetUserPreferences();

  if (doc) {
    nsIURI *docURI = doc->GetDocumentURI();

    if (IsDynamic() && docURI) {
      bool isChrome = false;
      bool isRes = false;
      docURI->SchemeIs("chrome", &isChrome);
      docURI->SchemeIs("resource", &isRes);

      if (!isChrome && !isRes)
        mImageAnimationMode = mImageAnimationModePref;
      else
        mImageAnimationMode = imgIContainer::kNormalAnimMode;
    }

    if (mLangService) {
      doc->AddCharSetObserver(this);
      UpdateCharSet(doc->GetDocumentCharacterSet());
    }
  }
}

void
nsPresContext::DetachShell()
{
  // Remove ourselves as the charset observer from the shell's doc, because
  // this shell may be going away for good.
  nsIDocument *doc = mShell ? mShell->GetDocument() : nullptr;
  if (doc) {
    doc->RemoveCharSetObserver(this);
  }

  // The counter style manager's destructor needs to deallocate with the
  // presshell arena. Disconnect it before nulling out the shell.
  //
  // XXXbholley: Given recent refactorings, it probably makes more sense to
  // just null our mShell at the bottom of this function. I'm leaving it
  // this way to preserve the old ordering, but I doubt anything would break.
  if (mCounterStyleManager) {
    mCounterStyleManager->Disconnect();
    mCounterStyleManager = nullptr;
  }

  mShell = nullptr;

  if (mEffectCompositor) {
    mEffectCompositor->Disconnect();
    mEffectCompositor = nullptr;
  }
  if (mTransitionManager) {
    mTransitionManager->Disconnect();
    mTransitionManager = nullptr;
  }
  if (mAnimationManager) {
    mAnimationManager->Disconnect();
    mAnimationManager = nullptr;
  }
  if (mRestyleManager) {
    mRestyleManager->Disconnect();
    mRestyleManager = nullptr;
  }
  if (mRefreshDriver && mRefreshDriver->GetPresContext() == this) {
    mRefreshDriver->Disconnect();
    // Can't null out the refresh driver here.
  }

  if (IsRoot()) {
    nsRootPresContext* thisRoot = static_cast<nsRootPresContext*>(this);

    // Have to cancel our plugin geometry timer, because the
    // callback for that depends on a non-null presshell.
    thisRoot->CancelApplyPluginGeometryTimer();

    // The did-paint timer also depends on a non-null pres shell.
    thisRoot->CancelDidPaintTimer();
  }
}

void
nsPresContext::DoChangeCharSet(const nsCString& aCharSet)
{
  UpdateCharSet(aCharSet);
  mDeviceContext->FlushFontCache();
  RebuildAllStyleData(NS_STYLE_HINT_REFLOW, nsRestyleHint(0));
}

void
nsPresContext::UpdateCharSet(const nsCString& aCharSet)
{
  if (mLangService) {
    mLanguage = mLangService->LookupCharSet(aCharSet);
    // this will be a language group (or script) code rather than a true language code

    // bug 39570: moved from nsLanguageAtomService::LookupCharSet()
    if (mLanguage == nsGkAtoms::Unicode) {
      mLanguage = mLangService->GetLocaleLanguage();
    }
    mLangGroupFontPrefs.Reset();
  }

  switch (GET_BIDI_OPTION_TEXTTYPE(GetBidi())) {

    case IBMBIDI_TEXTTYPE_LOGICAL:
      SetVisualMode(false);
      break;

    case IBMBIDI_TEXTTYPE_VISUAL:
      SetVisualMode(true);
      break;

    case IBMBIDI_TEXTTYPE_CHARSET:
    default:
      SetVisualMode(IsVisualCharset(aCharSet));
  }
}

NS_IMETHODIMP
nsPresContext::Observe(nsISupports* aSubject,
                        const char* aTopic,
                        const char16_t* aData)
{
  if (!nsCRT::strcmp(aTopic, "charset")) {
    RefPtr<CharSetChangingRunnable> runnable =
      new CharSetChangingRunnable(this, NS_LossyConvertUTF16toASCII(aData));
    return NS_DispatchToCurrentThread(runnable);
  }

  NS_WARNING("unrecognized topic in nsPresContext::Observe");
  return NS_ERROR_FAILURE;
}

nsPresContext*
nsPresContext::GetParentPresContext()
{
  nsIPresShell* shell = GetPresShell();
  if (shell) {
    nsViewManager* viewManager = shell->GetViewManager();
    if (viewManager) {
      nsView* view = viewManager->GetRootView();
      if (view) {
        view = view->GetParent(); // anonymous inner view
        if (view) {
          view = view->GetParent(); // subdocumentframe's view
          if (view) {
            nsIFrame* f = view->GetFrame();
            if (f) {
              return f->PresContext();
            }
          }
        }
      }
    }
  }
  return nullptr;
}

nsPresContext*
nsPresContext::GetToplevelContentDocumentPresContext()
{
  if (IsChrome())
    return nullptr;
  nsPresContext* pc = this;
  for (;;) {
    nsPresContext* parent = pc->GetParentPresContext();
    if (!parent || parent->IsChrome())
      return pc;
    pc = parent;
  }
}

nsIWidget*
nsPresContext::GetNearestWidget(nsPoint* aOffset)
{
  NS_ENSURE_TRUE(mShell, nullptr);
  nsIFrame* frame = mShell->GetRootFrame();
  NS_ENSURE_TRUE(frame, nullptr);
  return frame->GetView()->GetNearestWidget(aOffset);
}

nsIWidget*
nsPresContext::GetRootWidget()
{
  NS_ENSURE_TRUE(mShell, nullptr);
  nsViewManager* vm = mShell->GetViewManager();
  if (!vm) {
    return nullptr;
  }
  nsCOMPtr<nsIWidget> widget;
  vm->GetRootWidget(getter_AddRefs(widget));
  return widget.get();
}

// We may want to replace this with something faster, maybe caching the root prescontext
nsRootPresContext*
nsPresContext::GetRootPresContext()
{
  nsPresContext* pc = this;
  for (;;) {
    nsPresContext* parent = pc->GetParentPresContext();
    if (!parent)
      break;
    pc = parent;
  }
  return pc->IsRoot() ? static_cast<nsRootPresContext*>(pc) : nullptr;
}

void
nsPresContext::CompatibilityModeChanged()
{
  if (!mShell) {
    return;
  }

  nsIDocument* doc = mShell->GetDocument();
  if (!doc) {
    return;
  }

  if (doc->IsSVGDocument()) {
    // SVG documents never load quirk.css.
    return;
  }

  bool needsQuirkSheet = CompatibilityMode() == eCompatibility_NavQuirks;
  if (mQuirkSheetAdded == needsQuirkSheet) {
    return;
  }

  StyleSetHandle styleSet = mShell->StyleSet();
  auto cache = nsLayoutStylesheetCache::For(styleSet->BackendType());
  StyleSheet* sheet = cache->QuirkSheet();

  if (needsQuirkSheet) {
    // quirk.css needs to come after html.css; we just keep it at the end.
    DebugOnly<nsresult> rv =
      styleSet->AppendStyleSheet(SheetType::Agent, sheet);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "failed to insert quirk.css");
  } else {
    DebugOnly<nsresult> rv =
      styleSet->RemoveStyleSheet(SheetType::Agent, sheet);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "failed to remove quirk.css");
  }

  mQuirkSheetAdded = needsQuirkSheet;
}

// Helper function for setting Anim Mode on image
static void SetImgAnimModeOnImgReq(imgIRequest* aImgReq, uint16_t aMode)
{
  if (aImgReq) {
    nsCOMPtr<imgIContainer> imgCon;
    aImgReq->GetImage(getter_AddRefs(imgCon));
    if (imgCon) {
      imgCon->SetAnimationMode(aMode);
    }
  }
}

// IMPORTANT: Assumption is that all images for a Presentation
// have the same Animation Mode (pavlov said this was OK)
//
// Walks content and set the animation mode
// this is a way to turn on/off image animations
void nsPresContext::SetImgAnimations(nsIContent *aParent, uint16_t aMode)
{
  nsCOMPtr<nsIImageLoadingContent> imgContent(do_QueryInterface(aParent));
  if (imgContent) {
    nsCOMPtr<imgIRequest> imgReq;
    imgContent->GetRequest(nsIImageLoadingContent::CURRENT_REQUEST,
                           getter_AddRefs(imgReq));
    SetImgAnimModeOnImgReq(imgReq, aMode);
  }

  uint32_t count = aParent->GetChildCount();
  for (uint32_t i = 0; i < count; ++i) {
    SetImgAnimations(aParent->GetChildAt(i), aMode);
  }
}

void
nsPresContext::SetSMILAnimations(nsIDocument *aDoc, uint16_t aNewMode,
                                 uint16_t aOldMode)
{
  if (aDoc->HasAnimationController()) {
    nsSMILAnimationController* controller = aDoc->GetAnimationController();
    switch (aNewMode)
    {
      case imgIContainer::kNormalAnimMode:
      case imgIContainer::kLoopOnceAnimMode:
        if (aOldMode == imgIContainer::kDontAnimMode)
          controller->Resume(nsSMILTimeContainer::PAUSE_USERPREF);
        break;

      case imgIContainer::kDontAnimMode:
        if (aOldMode != imgIContainer::kDontAnimMode)
          controller->Pause(nsSMILTimeContainer::PAUSE_USERPREF);
        break;
    }
  }
}

void
nsPresContext::SetImageAnimationModeInternal(uint16_t aMode)
{
  NS_ASSERTION(aMode == imgIContainer::kNormalAnimMode ||
               aMode == imgIContainer::kDontAnimMode ||
               aMode == imgIContainer::kLoopOnceAnimMode, "Wrong Animation Mode is being set!");

  // Image animation mode cannot be changed when rendering to a printer.
  if (!IsDynamic())
    return;

  // Now walk the content tree and set the animation mode
  // on all the images.
  if (mShell != nullptr) {
    nsIDocument *doc = mShell->GetDocument();
    if (doc) {
      doc->StyleImageLoader()->SetAnimationMode(aMode);

      Element *rootElement = doc->GetRootElement();
      if (rootElement) {
        SetImgAnimations(rootElement, aMode);
      }
      SetSMILAnimations(doc, aMode, mImageAnimationMode);
    }
  }

  mImageAnimationMode = aMode;
}

void
nsPresContext::SetImageAnimationModeExternal(uint16_t aMode)
{
  SetImageAnimationModeInternal(aMode);
}

already_AddRefed<nsIAtom>
nsPresContext::GetContentLanguage() const
{
  nsAutoString language;
  Document()->GetContentLanguage(language);
  language.StripWhitespace();

  // Content-Language may be a comma-separated list of language codes,
  // in which case the HTML5 spec says to treat it as unknown
  if (!language.IsEmpty() &&
      !language.Contains(char16_t(','))) {
    return NS_Atomize(language);
    // NOTE:  This does *not* count as an explicit language; in other
    // words, it doesn't trigger language-specific hyphenation.
  }
  return nullptr;
}

void
nsPresContext::SetFullZoom(float aZoom)
{
  if (!mShell || mFullZoom == aZoom) {
    return;
  }

  // Re-fetch the view manager's window dimensions in case there's a deferred
  // resize which hasn't affected our mVisibleArea yet
  nscoord oldWidthAppUnits, oldHeightAppUnits;
  mShell->GetViewManager()->GetWindowDimensions(&oldWidthAppUnits, &oldHeightAppUnits);
  float oldWidthDevPixels = oldWidthAppUnits / float(mCurAppUnitsPerDevPixel);
  float oldHeightDevPixels = oldHeightAppUnits / float(mCurAppUnitsPerDevPixel);
  mDeviceContext->SetFullZoom(aZoom);

  NS_ASSERTION(!mSuppressResizeReflow, "two zooms happening at the same time? impossible!");
  mSuppressResizeReflow = true;

  mFullZoom = aZoom;
  mShell->GetViewManager()->
    SetWindowDimensions(NSToCoordRound(oldWidthDevPixels * AppUnitsPerDevPixel()),
                        NSToCoordRound(oldHeightDevPixels * AppUnitsPerDevPixel()));

  AppUnitsPerDevPixelChanged();

  mSuppressResizeReflow = false;
}

void
nsPresContext::SetOverrideDPPX(float aDPPX)
{
  mOverrideDPPX = aDPPX;

  if (HasCachedStyleData()) {
    MediaFeatureValuesChanged(nsRestyleHint(0), nsChangeHint(0));
  }
}

gfxSize
nsPresContext::ScreenSizeInchesForFontInflation(bool* aChanged)
{
  if (aChanged) {
    *aChanged = false;
  }

  nsDeviceContext *dx = DeviceContext();
  nsRect clientRect;
  dx->GetClientRect(clientRect); // FIXME: GetClientRect looks expensive
  float unitsPerInch = dx->AppUnitsPerPhysicalInch();
  gfxSize deviceSizeInches(float(clientRect.width) / unitsPerInch,
                           float(clientRect.height) / unitsPerInch);

  if (mLastFontInflationScreenSize == gfxSize(-1.0, -1.0)) {
    mLastFontInflationScreenSize = deviceSizeInches;
  }

  if (deviceSizeInches != mLastFontInflationScreenSize && aChanged) {
    *aChanged = true;
    mLastFontInflationScreenSize = deviceSizeInches;
  }

  return deviceSizeInches;
}

static bool
CheckOverflow(const nsStyleDisplay* aDisplay, ScrollbarStyles* aStyles)
{
  if (aDisplay->mOverflowX == NS_STYLE_OVERFLOW_VISIBLE &&
      aDisplay->mScrollBehavior == NS_STYLE_SCROLL_BEHAVIOR_AUTO &&
      aDisplay->mScrollSnapTypeX == NS_STYLE_SCROLL_SNAP_TYPE_NONE &&
      aDisplay->mScrollSnapTypeY == NS_STYLE_SCROLL_SNAP_TYPE_NONE &&
      aDisplay->mScrollSnapPointsX == nsStyleCoord(eStyleUnit_None) &&
      aDisplay->mScrollSnapPointsY == nsStyleCoord(eStyleUnit_None) &&
      !aDisplay->mScrollSnapDestination.mXPosition.mHasPercent &&
      !aDisplay->mScrollSnapDestination.mYPosition.mHasPercent &&
      aDisplay->mScrollSnapDestination.mXPosition.mLength == 0 &&
      aDisplay->mScrollSnapDestination.mYPosition.mLength == 0) {
    return false;
  }

  if (aDisplay->mOverflowX == NS_STYLE_OVERFLOW_CLIP) {
    *aStyles = ScrollbarStyles(NS_STYLE_OVERFLOW_HIDDEN,
                               NS_STYLE_OVERFLOW_HIDDEN, aDisplay);
  } else {
    *aStyles = ScrollbarStyles(aDisplay);
  }
  return true;
}

static nsIContent*
GetPropagatedScrollbarStylesForViewport(nsPresContext* aPresContext,
                                        ScrollbarStyles *aStyles)
{
  // Set default
  *aStyles = ScrollbarStyles(NS_STYLE_OVERFLOW_AUTO, NS_STYLE_OVERFLOW_AUTO);

  // We never mess with the viewport scroll state
  // when printing or in print preview
  if (aPresContext->IsPaginated()) {
    return nullptr;
  }

  nsIDocument* document = aPresContext->Document();
  Element* docElement = document->GetRootElement();

  // docElement might be null if we're doing this after removing it.
  if (!docElement) {
    return nullptr;
  }

  // Check the style on the document root element
  StyleSetHandle styleSet = aPresContext->StyleSet();
  RefPtr<nsStyleContext> rootStyle;
  rootStyle = styleSet->ResolveStyleFor(docElement, nullptr);
  if (CheckOverflow(rootStyle->StyleDisplay(), aStyles)) {
    // tell caller we stole the overflow style from the root element
    return docElement;
  }

  // Don't look in the BODY for non-HTML documents or HTML documents
  // with non-HTML roots
  // XXX this should be earlier; we shouldn't even look at the document root
  // for non-HTML documents. Fix this once we support explicit CSS styling
  // of the viewport
  // XXX what about XHTML?
  nsCOMPtr<nsIDOMHTMLDocument> htmlDoc(do_QueryInterface(document));
  if (!htmlDoc || !docElement->IsHTMLElement()) {
    return nullptr;
  }

  nsCOMPtr<nsIDOMHTMLElement> body;
  htmlDoc->GetBody(getter_AddRefs(body));
  nsCOMPtr<nsIContent> bodyElement = do_QueryInterface(body);

  if (!bodyElement ||
      !bodyElement->NodeInfo()->Equals(nsGkAtoms::body)) {
    // The body is not a <body> tag, it's a <frameset>.
    return nullptr;
  }

  RefPtr<nsStyleContext> bodyStyle;
  bodyStyle = styleSet->ResolveStyleFor(bodyElement->AsElement(), rootStyle);

  if (CheckOverflow(bodyStyle->StyleDisplay(), aStyles)) {
    // tell caller we stole the overflow style from the body element
    return bodyElement;
  }

  return nullptr;
}

nsIContent*
nsPresContext::UpdateViewportScrollbarStylesOverride()
{
  nsIContent* propagatedFrom =
    GetPropagatedScrollbarStylesForViewport(this, &mViewportStyleScrollbar);

  nsIDocument* document = Document();
  if (Element* fullscreenElement = document->GetFullscreenElement()) {
    // If the document is in fullscreen, but the fullscreen element is
    // not the root element, we should explicitly suppress the scrollbar
    // here. Note that, we still need to return the original element
    // the styles are from, so that the state of those elements is not
    // affected across fullscreen change.
    if (fullscreenElement != document->GetRootElement() &&
        fullscreenElement != propagatedFrom) {
      mViewportStyleScrollbar = ScrollbarStyles(NS_STYLE_OVERFLOW_HIDDEN,
                                                NS_STYLE_OVERFLOW_HIDDEN);
    }
  }

  return propagatedFrom;
}

void
nsPresContext::SetContainer(nsIDocShell* aDocShell)
{
  if (aDocShell) {
    NS_ASSERTION(!(mContainer && mNeedsPrefUpdate),
                 "Should only need pref update if mContainer is null.");
    mContainer = static_cast<nsDocShell*>(aDocShell);
    if (mNeedsPrefUpdate) {
      if (!mPrefChangedTimer) {
        mPrefChangedTimer = CreateTimer(PrefChangedUpdateTimerCallback, 0);
      }
      mNeedsPrefUpdate = false;
    }
  } else {
    mContainer = WeakPtr<nsDocShell>();
  }
  UpdateIsChrome();
  if (mContainer) {
    GetDocumentColorPreferences();
  }
}

nsISupports*
nsPresContext::GetContainerWeakInternal() const
{
  return static_cast<nsIDocShell*>(mContainer);
}

nsISupports*
nsPresContext::GetContainerWeakExternal() const
{
  return GetContainerWeakInternal();
}

nsIDocShell*
nsPresContext::GetDocShell() const
{
  return mContainer;
}

/* virtual */ void
nsPresContext::Detach()
{
  SetContainer(nullptr);
  SetLinkHandler(nullptr);
  if (mShell) {
    mShell->CancelInvalidatePresShellIfHidden();
  }
}

bool
nsPresContext::BidiEnabledExternal() const
{
  return BidiEnabledInternal();
}

bool
nsPresContext::BidiEnabledInternal() const
{
  return Document()->GetBidiEnabled();
}

void
nsPresContext::SetBidiEnabled() const
{
  if (mShell) {
    nsIDocument *doc = mShell->GetDocument();
    if (doc) {
      doc->SetBidiEnabled();
    }
  }
}

void
nsPresContext::SetBidi(uint32_t aSource, bool aForceRestyle)
{
  // Don't do all this stuff unless the options have changed.
  if (aSource == GetBidi()) {
    return;
  }

  NS_ASSERTION(!(aForceRestyle && (GetBidi() == 0)),
               "ForceReflow on new prescontext");

  Document()->SetBidiOptions(aSource);
  if (IBMBIDI_TEXTDIRECTION_RTL == GET_BIDI_OPTION_DIRECTION(aSource)
      || IBMBIDI_NUMERAL_HINDI == GET_BIDI_OPTION_NUMERAL(aSource)) {
    SetBidiEnabled();
  }
  if (IBMBIDI_TEXTTYPE_VISUAL == GET_BIDI_OPTION_TEXTTYPE(aSource)) {
    SetVisualMode(true);
  }
  else if (IBMBIDI_TEXTTYPE_LOGICAL == GET_BIDI_OPTION_TEXTTYPE(aSource)) {
    SetVisualMode(false);
  }
  else {
    nsIDocument* doc = mShell->GetDocument();
    if (doc) {
      SetVisualMode(IsVisualCharset(doc->GetDocumentCharacterSet()));
    }
  }
  if (aForceRestyle && mShell) {
    // Reconstruct the root document element's frame and its children,
    // because we need to trigger frame reconstruction for direction change.
    mDocument->RebuildUserFontSet();
    mShell->ReconstructFrames();
  }
}

uint32_t
nsPresContext::GetBidi() const
{
  return Document()->GetBidiOptions();
}

bool
nsPresContext::IsTopLevelWindowInactive()
{
  nsCOMPtr<nsIDocShellTreeItem> treeItem(mContainer);
  if (!treeItem)
    return false;

  nsCOMPtr<nsIDocShellTreeItem> rootItem;
  treeItem->GetRootTreeItem(getter_AddRefs(rootItem));
  if (!rootItem) {
    return false;
  }

  nsCOMPtr<nsPIDOMWindowOuter> domWindow = rootItem->GetWindow();

  return domWindow && !domWindow->IsActive();
}

nsITheme*
nsPresContext::GetTheme()
{
  if (!sNoTheme && !mTheme) {
    mTheme = do_GetService("@mozilla.org/chrome/chrome-native-theme;1");
    if (!mTheme)
      sNoTheme = true;
  }

  return mTheme;
}

void
nsPresContext::ThemeChanged()
{
  if (!mPendingThemeChanged) {
    sLookAndFeelChanged = true;
    sThemeChanged = true;

    nsCOMPtr<nsIRunnable> ev =
      NewRunnableMethod(this, &nsPresContext::ThemeChangedInternal);
    if (NS_SUCCEEDED(NS_DispatchToCurrentThread(ev))) {
      mPendingThemeChanged = true;
    }
  }
}

static bool
NotifyThemeChanged(TabParent* aTabParent, void* aArg)
{
  aTabParent->ThemeChanged();
  return false;
}

void
nsPresContext::ThemeChangedInternal()
{
  mPendingThemeChanged = false;

  // Tell the theme that it changed, so it can flush any handles to stale theme
  // data.
  if (mTheme && sThemeChanged) {
    mTheme->ThemeChanged();
    sThemeChanged = false;
  }

  if (sLookAndFeelChanged) {
    // Clear all cached LookAndFeel colors.
    LookAndFeel::Refresh();
    sLookAndFeelChanged = false;

    // Vector images (SVG) may be using theme colors so we discard all cached
    // surfaces. (We could add a vector image only version of DiscardAll, but
    // in bug 940625 we decided theme changes are rare enough not to bother.)
    image::SurfaceCacheUtils::DiscardAll();
  }

  // This will force the system metrics to be generated the next time they're used
  nsCSSRuleProcessor::FreeSystemMetrics();

  // Changes to system metrics can change media queries on them, or
  // :-moz-system-metric selectors (which requires eRestyle_Subtree).
  // Changes in theme can change system colors (whose changes are
  // properly reflected in computed style data), system fonts (whose
  // changes are not), and -moz-appearance (whose changes likewise are
  // not), so we need to reflow.
  MediaFeatureValuesChanged(eRestyle_Subtree, NS_STYLE_HINT_REFLOW);

  // Recursively notify all remote leaf descendants that the
  // system theme has changed.
  nsContentUtils::CallOnAllRemoteChildren(mDocument->GetWindow(),
                                          NotifyThemeChanged, nullptr);
}

void
nsPresContext::SysColorChanged()
{
  if (!mPendingSysColorChanged) {
    sLookAndFeelChanged = true;
    nsCOMPtr<nsIRunnable> ev =
      NewRunnableMethod(this, &nsPresContext::SysColorChangedInternal);
    if (NS_SUCCEEDED(NS_DispatchToCurrentThread(ev))) {
      mPendingSysColorChanged = true;
    }
  }
}

void
nsPresContext::SysColorChangedInternal()
{
  mPendingSysColorChanged = false;

  if (sLookAndFeelChanged) {
     // Don't use the cached values for the system colors
    LookAndFeel::Refresh();
    sLookAndFeelChanged = false;
  }

  // Reset default background and foreground colors for the document since
  // they may be using system colors
  GetDocumentColorPreferences();

  // The system color values are computed to colors in the style data,
  // so normal style data comparison is sufficient here.
  RebuildAllStyleData(nsChangeHint(0), nsRestyleHint(0));
}

void
nsPresContext::UIResolutionChanged()
{
  if (!mPendingUIResolutionChanged) {
    nsCOMPtr<nsIRunnable> ev =
      NewRunnableMethod(this, &nsPresContext::UIResolutionChangedInternal);
    if (NS_SUCCEEDED(NS_DispatchToCurrentThread(ev))) {
      mPendingUIResolutionChanged = true;
    }
  }
}

void
nsPresContext::UIResolutionChangedSync()
{
  if (!mPendingUIResolutionChanged) {
    mPendingUIResolutionChanged = true;
    UIResolutionChangedInternalScale(0.0);
  }
}

/*static*/ bool
nsPresContext::UIResolutionChangedSubdocumentCallback(nsIDocument* aDocument,
                                                      void* aData)
{
  nsIPresShell* shell = aDocument->GetShell();
  if (shell) {
    nsPresContext* pc = shell->GetPresContext();
    if (pc) {
      // For subdocuments, we want to apply the parent's scale, because there
      // are cases where the subdoc's device context is connected to a widget
      // that has an out-of-date resolution (it's on a different screen, but
      // currently hidden, and will not be updated until shown): bug 1249279.
      double scale = *static_cast<double*>(aData);
      pc->UIResolutionChangedInternalScale(scale);
    }
  }
  return true;
}

static void
NotifyTabUIResolutionChanged(TabParent* aTab, void *aArg)
{
  aTab->UIResolutionChanged();
}

static void
NotifyChildrenUIResolutionChanged(nsPIDOMWindowOuter* aWindow)
{
  nsCOMPtr<nsIDocument> doc = aWindow->GetExtantDoc();
  RefPtr<nsPIWindowRoot> topLevelWin = nsContentUtils::GetWindowRoot(doc);
  if (!topLevelWin) {
    return;
  }
  topLevelWin->EnumerateBrowsers(NotifyTabUIResolutionChanged, nullptr);
}

void
nsPresContext::UIResolutionChangedInternal()
{
  UIResolutionChangedInternalScale(0.0);
}

void
nsPresContext::UIResolutionChangedInternalScale(double aScale)
{
  mPendingUIResolutionChanged = false;

  mDeviceContext->CheckDPIChange(&aScale);
  if (mCurAppUnitsPerDevPixel != AppUnitsPerDevPixel()) {
    AppUnitsPerDevPixelChanged();
  }

  // Recursively notify all remote leaf descendants of the change.
  if (nsPIDOMWindowOuter* window = mDocument->GetWindow()) {
    NotifyChildrenUIResolutionChanged(window);
  }

  mDocument->EnumerateSubDocuments(UIResolutionChangedSubdocumentCallback,
                                   &aScale);
}

void
nsPresContext::EmulateMedium(const nsAString& aMediaType)
{
  nsIAtom* previousMedium = Medium();
  mIsEmulatingMedia = true;

  nsAutoString mediaType;
  nsContentUtils::ASCIIToLower(aMediaType, mediaType);

  mMediaEmulated = NS_Atomize(mediaType);
  if (mMediaEmulated != previousMedium && mShell) {
    MediaFeatureValuesChanged(nsRestyleHint(0), nsChangeHint(0));
  }
}

void nsPresContext::StopEmulatingMedium()
{
  nsIAtom* previousMedium = Medium();
  mIsEmulatingMedia = false;
  if (Medium() != previousMedium) {
    MediaFeatureValuesChanged(nsRestyleHint(0), nsChangeHint(0));
  }
}

void
nsPresContext::RebuildAllStyleData(nsChangeHint aExtraHint,
                                   nsRestyleHint aRestyleHint)
{
  if (!mShell) {
    // We must have been torn down. Nothing to do here.
    return;
  }

  mUsesRootEMUnits = false;
  mUsesExChUnits = false;
  mUsesViewportUnits = false;
  mDocument->RebuildUserFontSet();
  RebuildCounterStyles();

  RestyleManager()->RebuildAllStyleData(aExtraHint, aRestyleHint);
}

void
nsPresContext::PostRebuildAllStyleDataEvent(nsChangeHint aExtraHint,
                                            nsRestyleHint aRestyleHint)
{
  if (!mShell) {
    // We must have been torn down. Nothing to do here.
    return;
  }
  RestyleManager()->PostRebuildAllStyleDataEvent(aExtraHint, aRestyleHint);
}

struct MediaFeatureHints
{
  nsRestyleHint restyleHint;
  nsChangeHint changeHint;
};

static bool
MediaFeatureValuesChangedAllDocumentsCallback(nsIDocument* aDocument, void* aHints)
{
  MediaFeatureHints* hints = static_cast<MediaFeatureHints*>(aHints);
  if (nsIPresShell* shell = aDocument->GetShell()) {
    if (nsPresContext* pc = shell->GetPresContext()) {
      pc->MediaFeatureValuesChangedAllDocuments(hints->restyleHint,
                                                hints->changeHint);
    }
  }
  return true;
}

void
nsPresContext::MediaFeatureValuesChangedAllDocuments(nsRestyleHint aRestyleHint,
                                                     nsChangeHint aChangeHint)
{
    MediaFeatureValuesChanged(aRestyleHint, aChangeHint);
    MediaFeatureHints hints = {
      aRestyleHint,
      aChangeHint
    };

    mDocument->EnumerateSubDocuments(MediaFeatureValuesChangedAllDocumentsCallback,
                                     &hints);
}

void
nsPresContext::MediaFeatureValuesChanged(nsRestyleHint aRestyleHint,
                                         nsChangeHint aChangeHint)
{
  mPendingMediaFeatureValuesChanged = false;

  // MediumFeaturesChanged updates the applied rules, so it always gets called.
  if (mShell) {
    // XXXheycam ServoStyleSets don't support responding to medium
    // changes yet.
    if (mShell->StyleSet()->IsGecko()) {
      if (mShell->StyleSet()->AsGecko()->MediumFeaturesChanged()) {
        aRestyleHint |= eRestyle_Subtree;
      }
    } else {
      NS_WARNING("stylo: ServoStyleSets don't support responding to medium "
                 "changes yet. See bug 1290228.");
    }
  }

  if (mUsesViewportUnits && mPendingViewportChange) {
    // Rebuild all style data without rerunning selector matching.
    aRestyleHint |= eRestyle_ForceDescendants;
  }

  if (aRestyleHint || aChangeHint) {
    RebuildAllStyleData(aChangeHint, aRestyleHint);
  }

  mPendingViewportChange = false;

  if (mDocument->IsBeingUsedAsImage()) {
    MOZ_ASSERT(PR_CLIST_IS_EMPTY(mDocument->MediaQueryLists()));
    return;
  }

  mDocument->NotifyMediaFeatureValuesChanged();

  MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());

  // Media query list listeners should be notified from a queued task
  // (in HTML5 terms), although we also want to notify them on certain
  // flushes.  (We're already running off an event.)
  //
  // Note that we do this after the new style from media queries in
  // style sheets has been computed.

  if (!PR_CLIST_IS_EMPTY(mDocument->MediaQueryLists())) {
    // We build a list of all the notifications we're going to send
    // before we send any of them.  (The spec says the notifications
    // should be a queued task, so any removals that happen during the
    // notifications shouldn't affect what gets notified.)  Furthermore,
    // we hold strong pointers to everything we're going to make
    // notification calls to, since each notification involves calling
    // arbitrary script that might otherwise destroy these objects, or,
    // for that matter, |this|.
    //
    // Note that we intentionally send the notifications to media query
    // list in the order they were created and, for each list, to the
    // listeners in the order added.
    nsTArray<MediaQueryList::HandleChangeData> notifyList;
    for (PRCList *l = PR_LIST_HEAD(mDocument->MediaQueryLists());
         l != mDocument->MediaQueryLists(); l = PR_NEXT_LINK(l)) {
      MediaQueryList *mql = static_cast<MediaQueryList*>(l);
      mql->MediumFeaturesChanged(notifyList);
    }

    if (!notifyList.IsEmpty()) {
      for (uint32_t i = 0, i_end = notifyList.Length(); i != i_end; ++i) {
        nsAutoMicroTask mt;
        MediaQueryList::HandleChangeData &d = notifyList[i];
        d.callback->Call(*d.mql);
      }
    }

    // NOTE:  When |notifyList| goes out of scope, our destructor could run.
  }
}

void
nsPresContext::PostMediaFeatureValuesChangedEvent()
{
  // FIXME: We should probably replace this event with use of
  // nsRefreshDriver::AddStyleFlushObserver (except the pres shell would
  // need to track whether it's been added).
  if (!mPendingMediaFeatureValuesChanged) {
    nsCOMPtr<nsIRunnable> ev =
      NewRunnableMethod(this, &nsPresContext::HandleMediaFeatureValuesChangedEvent);
    if (NS_SUCCEEDED(NS_DispatchToCurrentThread(ev))) {
      mPendingMediaFeatureValuesChanged = true;
      mDocument->SetNeedStyleFlush();
    }
  }
}

void
nsPresContext::HandleMediaFeatureValuesChangedEvent()
{
  // Null-check mShell in case the shell has been destroyed (and the
  // event is the only thing holding the pres context alive).
  if (mPendingMediaFeatureValuesChanged && mShell) {
    MediaFeatureValuesChanged(nsRestyleHint(0));
  }
}

static bool
NotifyTabSizeModeChanged(TabParent* aTab, void* aArg)
{
  nsSizeMode* sizeMode = static_cast<nsSizeMode*>(aArg);
  aTab->SizeModeChanged(*sizeMode);
  return false;
}

void
nsPresContext::SizeModeChanged(nsSizeMode aSizeMode)
{
  if (HasCachedStyleData()) {
    nsContentUtils::CallOnAllRemoteChildren(mDocument->GetWindow(),
                                            NotifyTabSizeModeChanged,
                                            &aSizeMode);
    MediaFeatureValuesChangedAllDocuments(nsRestyleHint(0));
  }
}

nsCompatibility
nsPresContext::CompatibilityMode() const
{
  return Document()->GetCompatibilityMode();
}

void
nsPresContext::SetPaginatedScrolling(bool aPaginated)
{
  if (mType == eContext_PrintPreview || mType == eContext_PageLayout)
    mCanPaginatedScroll = aPaginated;
}

void
nsPresContext::SetPrintSettings(nsIPrintSettings *aPrintSettings)
{
  if (mMedium == nsGkAtoms::print)
    mPrintSettings = aPrintSettings;
}

bool
nsPresContext::EnsureVisible()
{
  nsCOMPtr<nsIDocShell> docShell(mContainer);
  if (docShell) {
    nsCOMPtr<nsIContentViewer> cv;
    docShell->GetContentViewer(getter_AddRefs(cv));
    // Make sure this is the content viewer we belong with
    if (cv) {
      RefPtr<nsPresContext> currentPresContext;
      cv->GetPresContext(getter_AddRefs(currentPresContext));
      if (currentPresContext == this) {
        // OK, this is us.  We want to call Show() on the content viewer.
        nsresult result = cv->Show();
        if (NS_SUCCEEDED(result)) {
          return true;
        }
      }
    }
  }
  return false;
}

#ifdef MOZ_REFLOW_PERF
void
nsPresContext::CountReflows(const char * aName, nsIFrame * aFrame)
{
  if (mShell) {
    mShell->CountReflows(aName, aFrame);
  }
}
#endif

void
nsPresContext::UpdateIsChrome()
{
  mIsChrome = mContainer &&
              nsIDocShellTreeItem::typeChrome == mContainer->ItemType();
}

bool
nsPresContext::HasAuthorSpecifiedRules(const nsIFrame *aFrame,
                                       uint32_t ruleTypeMask) const
{
  return
    nsRuleNode::HasAuthorSpecifiedRules(aFrame->StyleContext(),
                                        ruleTypeMask,
                                        UseDocumentColors());
}

gfxUserFontSet*
nsPresContext::GetUserFontSet(bool aFlushUserFontSet)
{
  return mDocument->GetUserFontSet(aFlushUserFontSet);
}

void
nsPresContext::UserFontSetUpdated(gfxUserFontEntry* aUpdatedFont)
{
  if (!mShell)
    return;

  bool usePlatformFontList = true;
#if defined(MOZ_WIDGET_GTK)
  usePlatformFontList = gfxPlatformGtk::UseFcFontList();
#endif

  // xxx - until the Linux platform font list is always used, use full
  // restyle to force updates with gfxPangoFontGroup usage
  // Note: this method is called without a font when rules in the userfont set
  // are updated, which may occur during reflow as a result of the lazy
  // initialization of the userfont set. It would be better to avoid a full
  // restyle but until this method is only called outside of reflow, schedule a
  // full restyle in these cases.
  if (!usePlatformFontList || !aUpdatedFont) {
    PostRebuildAllStyleDataEvent(NS_STYLE_HINT_REFLOW, eRestyle_ForceDescendants);
    return;
  }

  // Special case - if either the 'ex' or 'ch' units are used, these
  // depend upon font metrics. Updating this information requires
  // rebuilding the rule tree from the top, avoiding the reuse of cached
  // data even when no style rules have changed.
  if (UsesExChUnits()) {
    PostRebuildAllStyleDataEvent(nsChangeHint(0), eRestyle_ForceDescendants);
  }

  // Iterate over the frame tree looking for frames associated with the
  // downloadable font family in question. If a frame's nsStyleFont has
  // the name, check the font group associated with the metrics to see if
  // it contains that specific font (i.e. the one chosen within the family
  // given the weight, width, and slant from the nsStyleFont). If it does,
  // mark that frame dirty and skip inspecting its descendants.
  nsIFrame* root = mShell->GetRootFrame();
  if (root) {
    nsFontFaceUtils::MarkDirtyForFontChange(root, aUpdatedFont);
  }
}

void
nsPresContext::FlushCounterStyles()
{
  if (!mShell) {
    return; // we've been torn down
  }
  if (mCounterStyleManager->IsInitial()) {
    // Still in its initial state, no need to clean.
    return;
  }

  if (mCounterStylesDirty) {
    bool changed = mCounterStyleManager->NotifyRuleChanged();
    if (changed) {
      PresShell()->NotifyCounterStylesAreDirty();
      PostRebuildAllStyleDataEvent(NS_STYLE_HINT_REFLOW,
                                   eRestyle_ForceDescendants);
    }
    mCounterStylesDirty = false;
  }
}

void
nsPresContext::RebuildCounterStyles()
{
  if (mCounterStyleManager->IsInitial()) {
    // Still in its initial state, no need to reset.
    return;
  }

  mCounterStylesDirty = true;
  mDocument->SetNeedStyleFlush();
  if (!mPostedFlushCounterStyles) {
    nsCOMPtr<nsIRunnable> ev =
      NewRunnableMethod(this, &nsPresContext::HandleRebuildCounterStyles);
    if (NS_SUCCEEDED(NS_DispatchToCurrentThread(ev))) {
      mPostedFlushCounterStyles = true;
    }
  }
}

void
nsPresContext::NotifyMissingFonts()
{
  if (mMissingFonts) {
    mMissingFonts->Flush();
  }
}

void
nsPresContext::EnsureSafeToHandOutCSSRules()
{
  nsStyleSet* styleSet = mShell->StyleSet()->GetAsGecko();
  if (!styleSet) {
    // ServoStyleSets do not need to handle copy-on-write style sheet
    // innards like with CSSStyleSheets.
    return;
  }

  if (!styleSet->EnsureUniqueInnerOnCSSSheets()) {
    // Nothing to do.
    return;
  }

  RebuildAllStyleData(nsChangeHint(0), eRestyle_Subtree);
}

void
nsPresContext::FireDOMPaintEvent(nsInvalidateRequestList* aList, uint64_t aTransactionId)
{
  nsPIDOMWindowInner* ourWindow = mDocument->GetInnerWindow();
  if (!ourWindow)
    return;

  nsCOMPtr<EventTarget> dispatchTarget = do_QueryInterface(ourWindow);
  nsCOMPtr<EventTarget> eventTarget = dispatchTarget;
  if (!IsChrome() && !mSendAfterPaintToContent) {
    // Don't tell the window about this event, it should not know that
    // something happened in a subdocument. Tell only the chrome event handler.
    // (Events sent to the window get propagated to the chrome event handler
    // automatically.)
    dispatchTarget = do_QueryInterface(ourWindow->GetParentTarget());
    if (!dispatchTarget) {
      return;
    }
  }
  // Events sent to the window get propagated to the chrome event handler
  // automatically.
  //
  // This will empty our list in case dispatching the event causes more damage
  // (hopefully it won't, or we're likely to get an infinite loop! At least
  // it won't be blocking app execution though).
  RefPtr<NotifyPaintEvent> event =
    NS_NewDOMNotifyPaintEvent(eventTarget, this, nullptr, eAfterPaint, aList, aTransactionId);

  // Even if we're not telling the window about the event (so eventTarget is
  // the chrome event handler, not the window), the window is still
  // logically the event target.
  event->SetTarget(eventTarget);
  event->SetTrusted(true);
  EventDispatcher::DispatchDOMEvent(dispatchTarget, nullptr,
                                    static_cast<Event*>(event), this, nullptr);
}

static bool
MayHavePaintEventListenerSubdocumentCallback(nsIDocument* aDocument, void* aData)
{
  bool *result = static_cast<bool*>(aData);
  nsIPresShell* shell = aDocument->GetShell();
  if (shell) {
    nsPresContext* pc = shell->GetPresContext();
    if (pc) {
      *result = pc->MayHavePaintEventListenerInSubDocument();

      // If we found a paint event listener, then we can stop enumerating
      // sub documents.
      return !*result;
    }
  }
  return true;
}

static bool
MayHavePaintEventListener(nsPIDOMWindowInner* aInnerWindow)
{
  if (!aInnerWindow)
    return false;
  if (aInnerWindow->HasPaintEventListeners())
    return true;

  EventTarget* parentTarget = aInnerWindow->GetParentTarget();
  if (!parentTarget)
    return false;

  EventListenerManager* manager = nullptr;
  if ((manager = parentTarget->GetExistingListenerManager()) &&
      manager->MayHavePaintEventListener()) {
    return true;
  }

  nsCOMPtr<nsINode> node;
  if (parentTarget != aInnerWindow->GetChromeEventHandler()) {
    nsCOMPtr<nsIInProcessContentFrameMessageManager> mm =
      do_QueryInterface(parentTarget);
    if (mm) {
      node = mm->GetOwnerContent();
    }
  }

  if (!node) {
    node = do_QueryInterface(parentTarget);
  }
  if (node)
    return MayHavePaintEventListener(node->OwnerDoc()->GetInnerWindow());

  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(parentTarget);
  if (window)
    return MayHavePaintEventListener(window);

  nsCOMPtr<nsPIWindowRoot> root = do_QueryInterface(parentTarget);
  EventTarget* tabChildGlobal;
  return root &&
         (tabChildGlobal = root->GetParentTarget()) &&
         (manager = tabChildGlobal->GetExistingListenerManager()) &&
         manager->MayHavePaintEventListener();
}

bool
nsPresContext::MayHavePaintEventListener()
{
  return ::MayHavePaintEventListener(mDocument->GetInnerWindow());
}

bool
nsPresContext::MayHavePaintEventListenerInSubDocument()
{
  if (MayHavePaintEventListener()) {
    return true;
  }

  bool result = false;
  mDocument->EnumerateSubDocuments(MayHavePaintEventListenerSubdocumentCallback, &result);
  return result;
}

void
nsPresContext::NotifyInvalidation(uint32_t aFlags)
{
  nsIFrame* rootFrame = PresShell()->FrameManager()->GetRootFrame();
  NotifyInvalidation(rootFrame->GetVisualOverflowRect(), aFlags);
  mAllInvalidated = true;
}

void
nsPresContext::NotifyInvalidation(const nsIntRect& aRect, uint32_t aFlags)
{
  // Prevent values from overflow after DevPixelsToAppUnits().
  //
  // DevPixelsTopAppUnits() will multiple a factor (60) to the value,
  // it may make the result value over the edge (overflow) of max or
  // min value of int32_t. Compute the max sized dev pixel rect that
  // we can support and intersect with it.
  nsIntRect clampedRect = nsIntRect::MaxIntRect();
  clampedRect.ScaleInverseRoundIn(AppUnitsPerDevPixel());

  clampedRect = clampedRect.Intersect(aRect);

  nsRect rect(DevPixelsToAppUnits(clampedRect.x),
              DevPixelsToAppUnits(clampedRect.y),
              DevPixelsToAppUnits(clampedRect.width),
              DevPixelsToAppUnits(clampedRect.height));
  NotifyInvalidation(rect, aFlags);
}

void
nsPresContext::NotifyInvalidation(const nsRect& aRect, uint32_t aFlags)
{
  MOZ_ASSERT(GetContainerWeak(), "Invalidation in detached pres context");

  // If there is no paint event listener, then we don't need to fire
  // the asynchronous event. We don't even need to record invalidation.
  // MayHavePaintEventListener is pretty cheap and we could make it
  // even cheaper by providing a more efficient
  // nsPIDOMWindow::GetListenerManager.

  if (mAllInvalidated) {
    return;
  }

  nsPresContext* pc;
  for (pc = this; pc; pc = pc->GetParentPresContext()) {
    if (pc->mFireAfterPaintEvents)
      break;
    pc->mFireAfterPaintEvents = true;
  }
  if (!pc) {
    nsRootPresContext* rpc = GetRootPresContext();
    if (rpc) {
      rpc->EnsureEventualDidPaintEvent();
    }
  }

  nsInvalidateRequestList::Request* request =
    mInvalidateRequestsSinceLastPaint.mRequests.AppendElement();
  if (!request)
    return;

  request->mRect = aRect;
  request->mFlags = aFlags;
}

/* static */ void
nsPresContext::NotifySubDocInvalidation(ContainerLayer* aContainer,
                                        const nsIntRegion& aRegion)
{
  ContainerLayerPresContext *data =
    static_cast<ContainerLayerPresContext*>(
      aContainer->GetUserData(&gNotifySubDocInvalidationData));
  if (!data) {
    return;
  }

  nsIntPoint topLeft = aContainer->GetVisibleRegion().ToUnknownRegion().GetBounds().TopLeft();

  for (auto iter = aRegion.RectIter(); !iter.Done(); iter.Next()) {
    nsIntRect rect(iter.Get());
    //PresContext coordinate space is relative to the start of our visible
    // region. Is this really true? This feels like the wrong way to get the right
    // answer.
    rect.MoveBy(-topLeft);
    data->mPresContext->NotifyInvalidation(rect, 0);
  }
}

void
nsPresContext::SetNotifySubDocInvalidationData(ContainerLayer* aContainer)
{
  ContainerLayerPresContext* pres = new ContainerLayerPresContext;
  pres->mPresContext = this;
  aContainer->SetUserData(&gNotifySubDocInvalidationData, pres);
}

/* static */ void
nsPresContext::ClearNotifySubDocInvalidationData(ContainerLayer* aContainer)
{
  aContainer->SetUserData(&gNotifySubDocInvalidationData, nullptr);
}

struct NotifyDidPaintSubdocumentCallbackClosure {
  uint32_t mFlags;
  uint64_t mTransactionId;
  bool mNeedsAnotherDidPaintNotification;
};
static bool
NotifyDidPaintSubdocumentCallback(nsIDocument* aDocument, void* aData)
{
  NotifyDidPaintSubdocumentCallbackClosure* closure =
    static_cast<NotifyDidPaintSubdocumentCallbackClosure*>(aData);
  nsIPresShell* shell = aDocument->GetShell();
  if (shell) {
    nsPresContext* pc = shell->GetPresContext();
    if (pc) {
      pc->NotifyDidPaintForSubtree(closure->mFlags, closure->mTransactionId);
      if (pc->IsDOMPaintEventPending()) {
        closure->mNeedsAnotherDidPaintNotification = true;
      }
    }
  }
  return true;
}

class DelayedFireDOMPaintEvent : public Runnable {
public:
  DelayedFireDOMPaintEvent(nsPresContext* aPresContext,
                           nsInvalidateRequestList* aList,
                           uint64_t aTransactionId)
    : mPresContext(aPresContext)
    , mTransactionId(aTransactionId)
  {
    MOZ_ASSERT(mPresContext->GetContainerWeak(),
               "DOMPaintEvent requested for a detached pres context");
    mList.TakeFrom(aList);
  }
  NS_IMETHOD Run() override
  {
    // The pres context might have been detached during the delay -
    // that's fine, just don't fire the event.
    if (mPresContext->GetContainerWeak()) {
      mPresContext->FireDOMPaintEvent(&mList, mTransactionId);
    }
    return NS_OK;
  }

  RefPtr<nsPresContext> mPresContext;
  uint64_t mTransactionId;
  nsInvalidateRequestList mList;
};

void
nsPresContext::NotifyDidPaintForSubtree(uint32_t aFlags, uint64_t aTransactionId,
                                        const mozilla::TimeStamp& aTimeStamp)
{
  if (IsRoot()) {
    static_cast<nsRootPresContext*>(this)->CancelDidPaintTimer();

    if (!mFireAfterPaintEvents) {
      return;
    }
  }

  if (!PresShell()->IsVisible() && !mFireAfterPaintEvents) {
    return;
  }

  // Non-root prescontexts fire MozAfterPaint to all their descendants
  // unconditionally, even if no invalidations have been collected. This is
  // because we don't want to eat the cost of collecting invalidations for
  // every subdocument (which would require putting every subdocument in its
  // own layer).

  if (aFlags & nsIPresShell::PAINT_LAYERS) {
    mUndeliveredInvalidateRequestsBeforeLastPaint.TakeFrom(
        &mInvalidateRequestsSinceLastPaint);
    mAllInvalidated = false;
  }
  if (aFlags & nsIPresShell::PAINT_COMPOSITE) {
    nsCOMPtr<nsIRunnable> ev =
      new DelayedFireDOMPaintEvent(this, &mUndeliveredInvalidateRequestsBeforeLastPaint,
                                   aTransactionId);
    nsContentUtils::AddScriptRunner(ev);
  }

  NotifyDidPaintSubdocumentCallbackClosure closure = { aFlags, aTransactionId, false };
  mDocument->EnumerateSubDocuments(NotifyDidPaintSubdocumentCallback, &closure);

  if (!closure.mNeedsAnotherDidPaintNotification &&
      mInvalidateRequestsSinceLastPaint.IsEmpty() &&
      mUndeliveredInvalidateRequestsBeforeLastPaint.IsEmpty()) {
    // Nothing more to do for the moment.
    mFireAfterPaintEvents = false;
  } else {
    if (IsRoot()) {
      static_cast<nsRootPresContext*>(this)->EnsureEventualDidPaintEvent();
    }
  }
}

bool
nsPresContext::HasCachedStyleData()
{
  if (!mShell) {
    return false;
  }

  nsStyleSet* styleSet = mShell->StyleSet()->GetAsGecko();
  if (!styleSet) {
    // XXXheycam ServoStyleSets do not use the rule tree, so just assume for now
    // that we need to restyle when e.g. dppx changes assuming we're sufficiently
    // bootstrapped.
    return mShell->DidInitialize();
  }

  return styleSet->HasCachedStyleData();
}

already_AddRefed<nsITimer>
nsPresContext::CreateTimer(nsTimerCallbackFunc aCallback,
                           uint32_t aDelay)
{
  nsCOMPtr<nsITimer> timer = do_CreateInstance("@mozilla.org/timer;1");
  if (timer) {
    nsresult rv = timer->InitWithFuncCallback(aCallback, this, aDelay,
                                              nsITimer::TYPE_ONE_SHOT);
    if (NS_SUCCEEDED(rv)) {
      return timer.forget();
    }
  }

  return nullptr;
}

static bool sGotInterruptEnv = false;
enum InterruptMode {
  ModeRandom,
  ModeCounter,
  ModeEvent
};
// Controlled by the GECKO_REFLOW_INTERRUPT_MODE env var; allowed values are
// "random" (except on Windows) or "counter".  If neither is used, the mode is
// ModeEvent.
static InterruptMode sInterruptMode = ModeEvent;
#ifndef XP_WIN
// Used for the "random" mode.  Controlled by the GECKO_REFLOW_INTERRUPT_SEED
// env var.
static uint32_t sInterruptSeed = 1;
#endif
// Used for the "counter" mode.  This is the number of unskipped interrupt
// checks that have to happen before we interrupt.  Controlled by the
// GECKO_REFLOW_INTERRUPT_FREQUENCY env var.
static uint32_t sInterruptMaxCounter = 10;
// Used for the "counter" mode.  This counts up to sInterruptMaxCounter and is
// then reset to 0.
static uint32_t sInterruptCounter;
// Number of interrupt checks to skip before really trying to interrupt.
// Controlled by the GECKO_REFLOW_INTERRUPT_CHECKS_TO_SKIP env var.
static uint32_t sInterruptChecksToSkip = 200;
// Number of milliseconds that a reflow should be allowed to run for before we
// actually allow interruption.  Controlled by the
// GECKO_REFLOW_MIN_NOINTERRUPT_DURATION env var.  Can't be initialized here,
// because TimeDuration/TimeStamp is not safe to use in static constructors..
static TimeDuration sInterruptTimeout;

static void GetInterruptEnv()
{
  char *ev = PR_GetEnv("GECKO_REFLOW_INTERRUPT_MODE");
  if (ev) {
#ifndef XP_WIN
    if (PL_strcasecmp(ev, "random") == 0) {
      ev = PR_GetEnv("GECKO_REFLOW_INTERRUPT_SEED");
      if (ev) {
        sInterruptSeed = atoi(ev);
      }
      srandom(sInterruptSeed);
      sInterruptMode = ModeRandom;
    } else
#endif
      if (PL_strcasecmp(ev, "counter") == 0) {
      ev = PR_GetEnv("GECKO_REFLOW_INTERRUPT_FREQUENCY");
      if (ev) {
        sInterruptMaxCounter = atoi(ev);
      }
      sInterruptCounter = 0;
      sInterruptMode = ModeCounter;
    }
  }
  ev = PR_GetEnv("GECKO_REFLOW_INTERRUPT_CHECKS_TO_SKIP");
  if (ev) {
    sInterruptChecksToSkip = atoi(ev);
  }

  ev = PR_GetEnv("GECKO_REFLOW_MIN_NOINTERRUPT_DURATION");
  int duration_ms = ev ? atoi(ev) : 100;
  sInterruptTimeout = TimeDuration::FromMilliseconds(duration_ms);
}

bool
nsPresContext::HavePendingInputEvent()
{
  switch (sInterruptMode) {
#ifndef XP_WIN
    case ModeRandom:
      return (random() & 1);
#endif
    case ModeCounter:
      if (sInterruptCounter < sInterruptMaxCounter) {
        ++sInterruptCounter;
        return false;
      }
      sInterruptCounter = 0;
      return true;
    default:
    case ModeEvent: {
      nsIFrame* f = PresShell()->GetRootFrame();
      if (f) {
        nsIWidget* w = f->GetNearestWidget();
        if (w) {
          return w->HasPendingInputEvent();
        }
      }
      return false;
    }
  }
}

void
nsPresContext::NotifyFontFaceSetOnRefresh()
{
  FontFaceSet* set = mDocument->GetFonts();
  if (set) {
    set->DidRefresh();
  }
}

bool
nsPresContext::HasPendingRestyleOrReflow()
{
  return (mRestyleManager && mRestyleManager->HasPendingRestyles()) ||
         PresShell()->HasPendingReflow();
}

void
nsPresContext::ReflowStarted(bool aInterruptible)
{
#ifdef NOISY_INTERRUPTIBLE_REFLOW
  if (!aInterruptible) {
    printf("STARTING NONINTERRUPTIBLE REFLOW\n");
  }
#endif
  // We don't support interrupting in paginated contexts, since page
  // sequences only handle initial reflow
  mInterruptsEnabled = aInterruptible && !IsPaginated() &&
                       nsLayoutUtils::InterruptibleReflowEnabled();

  // Don't set mHasPendingInterrupt based on HavePendingInputEvent() here.  If
  // we ever change that, then we need to update the code in
  // PresShell::DoReflow to only add the just-reflown root to dirty roots if
  // it's actually dirty.  Otherwise we can end up adding a root that has no
  // interruptible descendants, just because we detected an interrupt at reflow
  // start.
  mHasPendingInterrupt = false;

  mInterruptChecksToSkip = sInterruptChecksToSkip;

  if (mInterruptsEnabled) {
    mReflowStartTime = TimeStamp::Now();
  }
}

bool
nsPresContext::CheckForInterrupt(nsIFrame* aFrame)
{
  if (mHasPendingInterrupt) {
    mShell->FrameNeedsToContinueReflow(aFrame);
    return true;
  }

  if (!sGotInterruptEnv) {
    sGotInterruptEnv = true;
    GetInterruptEnv();
  }

  if (!mInterruptsEnabled) {
    return false;
  }

  if (mInterruptChecksToSkip > 0) {
    --mInterruptChecksToSkip;
    return false;
  }
  mInterruptChecksToSkip = sInterruptChecksToSkip;

  // Don't interrupt if it's been less than sInterruptTimeout since we started
  // the reflow.
  mHasPendingInterrupt =
    TimeStamp::Now() - mReflowStartTime > sInterruptTimeout &&
    HavePendingInputEvent() &&
    !IsChrome();

  if (mPendingInterruptFromTest) {
    mPendingInterruptFromTest = false;
    mHasPendingInterrupt = true;
  }

  if (mHasPendingInterrupt) {
#ifdef NOISY_INTERRUPTIBLE_REFLOW
    printf("*** DETECTED pending interrupt (time=%lld)\n", PR_Now());
#endif /* NOISY_INTERRUPTIBLE_REFLOW */
    mShell->FrameNeedsToContinueReflow(aFrame);
  }
  return mHasPendingInterrupt;
}

nsIFrame*
nsPresContext::GetPrimaryFrameFor(nsIContent* aContent)
{
  NS_PRECONDITION(aContent, "Don't do that");
  if (GetPresShell() &&
      GetPresShell()->GetDocument() == aContent->GetComposedDoc()) {
    return aContent->GetPrimaryFrame();
  }
  return nullptr;
}

size_t
nsPresContext::SizeOfExcludingThis(MallocSizeOf aMallocSizeOf) const
{
  return mPropertyTable.SizeOfExcludingThis(aMallocSizeOf) +
         mLangGroupFontPrefs.SizeOfExcludingThis(aMallocSizeOf);

  // Measurement of other members may be added later if DMD finds it is
  // worthwhile.
}

bool
nsPresContext::IsRootContentDocument() const
{
  // We are a root content document if: we are not a resource doc, we are
  // not chrome, and we either have no parent or our parent is chrome.
  if (mDocument->IsResourceDoc()) {
    return false;
  }
  if (IsChrome()) {
    return false;
  }
  // We may not have a root frame, so use views.
  nsView* view = PresShell()->GetViewManager()->GetRootView();
  if (!view) {
    return false;
  }
  view = view->GetParent(); // anonymous inner view
  if (!view) {
    return true;
  }
  view = view->GetParent(); // subdocumentframe's view
  if (!view) {
    return true;
  }

  nsIFrame* f = view->GetFrame();
  return (f && f->PresContext()->IsChrome());
}

void
nsPresContext::NotifyNonBlankPaint()
{
  MOZ_ASSERT(!mHadNonBlankPaint);
  mHadNonBlankPaint = true;
  if (IsRootContentDocument()) {
    RefPtr<nsDOMNavigationTiming> timing = mDocument->GetNavigationTiming();
    if (timing) {
      timing->NotifyNonBlankPaintForRootContentDocument();
    }
  }
}

bool nsPresContext::GetPaintFlashing() const
{
  if (!mPaintFlashingInitialized) {
    bool pref = Preferences::GetBool("nglayout.debug.paint_flashing");
    if (!pref && IsChrome()) {
      pref = Preferences::GetBool("nglayout.debug.paint_flashing_chrome");
    }
    mPaintFlashing = pref;
    mPaintFlashingInitialized = true;
  }
  return mPaintFlashing;
}

int32_t
nsPresContext::AppUnitsPerDevPixel() const
{
  return mDeviceContext->AppUnitsPerDevPixel();
}

nscoord
nsPresContext::GfxUnitsToAppUnits(gfxFloat aGfxUnits) const
{
  return mDeviceContext->GfxUnitsToAppUnits(aGfxUnits);
}

gfxFloat
nsPresContext::AppUnitsToGfxUnits(nscoord aAppUnits) const
{
  return mDeviceContext->AppUnitsToGfxUnits(aAppUnits);
}

bool
nsPresContext::IsDeviceSizePageSize()
{
  bool isDeviceSizePageSize = false;
  nsCOMPtr<nsIDocShell> docShell(mContainer);
  if (docShell) {
    isDeviceSizePageSize = docShell->GetDeviceSizeIsPageSize();
  }
  return isDeviceSizePageSize;
}

uint64_t
nsPresContext::GetRestyleGeneration() const
{
  if (!mRestyleManager) {
    return 0;
  }
  return mRestyleManager->GetRestyleGeneration();
}

nsRootPresContext::nsRootPresContext(nsIDocument* aDocument,
                                     nsPresContextType aType)
  : nsPresContext(aDocument, aType),
    mDOMGeneration(0)
{
}

nsRootPresContext::~nsRootPresContext()
{
  NS_ASSERTION(mRegisteredPlugins.Count() == 0,
               "All plugins should have been unregistered");
  CancelDidPaintTimer();
  CancelApplyPluginGeometryTimer();
}

/* virtual */ void
nsRootPresContext::Detach()
{
  CancelDidPaintTimer();
  // XXXmats maybe also CancelApplyPluginGeometryTimer(); ?
  nsPresContext::Detach();
}

void
nsRootPresContext::RegisterPluginForGeometryUpdates(nsIContent* aPlugin)
{
  mRegisteredPlugins.PutEntry(aPlugin);
}

void
nsRootPresContext::UnregisterPluginForGeometryUpdates(nsIContent* aPlugin)
{
  mRegisteredPlugins.RemoveEntry(aPlugin);
}

void
nsRootPresContext::ComputePluginGeometryUpdates(nsIFrame* aFrame,
                                                nsDisplayListBuilder* aBuilder,
                                                nsDisplayList* aList)
{
  if (mRegisteredPlugins.Count() == 0) {
    return;
  }

  // Initially make the next state for each plugin descendant of aFrame be
  // "hidden". Plugins that are visible will have their next state set to
  // unhidden by nsDisplayPlugin::ComputeVisibility.
  for (auto iter = mRegisteredPlugins.Iter(); !iter.Done(); iter.Next()) {
    auto f = static_cast<nsPluginFrame*>(iter.Get()->GetKey()->GetPrimaryFrame());
    if (!f) {
      NS_WARNING("Null frame in ComputePluginGeometryUpdates");
      continue;
    }
    if (!nsLayoutUtils::IsAncestorFrameCrossDoc(aFrame, f)) {
      // f is not managed by this frame so we should ignore it.
      continue;
    }
    f->SetEmptyWidgetConfiguration();
  }

  nsIFrame* rootFrame = FrameManager()->GetRootFrame();

  if (rootFrame && aBuilder->ContainsPluginItem()) {
    aBuilder->SetForPluginGeometry();
    aBuilder->SetAccurateVisibleRegions();
    // Merging and flattening has already been done and we should not do it
    // again. nsDisplayScroll(Info)Layer doesn't support trying to flatten
    // again.
    aBuilder->SetAllowMergingAndFlattening(false);
    nsRegion region = rootFrame->GetVisualOverflowRectRelativeToSelf();
    // nsDisplayPlugin::ComputeVisibility will automatically set a non-hidden
    // widget configuration for the plugin, if it's visible.
    aList->ComputeVisibilityForRoot(aBuilder, &region);
  }

#ifdef XP_MACOSX
  // We control painting of Mac plugins, so just apply geometry updates now.
  // This is not happening during a paint event.
  ApplyPluginGeometryUpdates();
#else
  if (XRE_IsParentProcess()) {
    InitApplyPluginGeometryTimer();
  }
#endif
}

static void
ApplyPluginGeometryUpdatesCallback(nsITimer *aTimer, void *aClosure)
{
  static_cast<nsRootPresContext*>(aClosure)->ApplyPluginGeometryUpdates();
}

void
nsRootPresContext::InitApplyPluginGeometryTimer()
{
  if (mApplyPluginGeometryTimer) {
    return;
  }

  // We'll apply the plugin geometry updates during the next compositing paint in this
  // presContext (either from nsPresShell::WillPaintWindow or from
  // nsPresShell::DidPaintWindow, depending on the platform).  But paints might
  // get optimized away if the old plugin geometry covers the invalid region,
  // so set a backup timer to do this too.  We want to make sure this
  // won't fire before our normal paint notifications, if those would
  // update the geometry, so set it for double the refresh driver interval.
  mApplyPluginGeometryTimer = CreateTimer(ApplyPluginGeometryUpdatesCallback,
                                          nsRefreshDriver::DefaultInterval() * 2);
}

void
nsRootPresContext::CancelApplyPluginGeometryTimer()
{
  if (mApplyPluginGeometryTimer) {
    mApplyPluginGeometryTimer->Cancel();
    mApplyPluginGeometryTimer = nullptr;
  }
}

#ifndef XP_MACOSX

static bool
HasOverlap(const LayoutDeviceIntPoint& aOffset1,
           const nsTArray<LayoutDeviceIntRect>& aClipRects1,
           const LayoutDeviceIntPoint& aOffset2,
           const nsTArray<LayoutDeviceIntRect>& aClipRects2)
{
  LayoutDeviceIntPoint offsetDelta = aOffset1 - aOffset2;
  for (uint32_t i = 0; i < aClipRects1.Length(); ++i) {
    for (uint32_t j = 0; j < aClipRects2.Length(); ++j) {
      if ((aClipRects1[i] + offsetDelta).Intersects(aClipRects2[j])) {
        return true;
      }
    }
  }
  return false;
}

/**
 * Given a list of plugin windows to move to new locations, sort the list
 * so that for each window move, the window moves to a location that
 * does not intersect other windows. This minimizes flicker and repainting.
 * It's not always possible to do this perfectly, since in general
 * we might have cycles. But we do our best.
 * We need to take into account that windows are clipped to particular
 * regions and the clip regions change as the windows are moved.
 */
static void
SortConfigurations(nsTArray<nsIWidget::Configuration>* aConfigurations)
{
  if (aConfigurations->Length() > 10) {
    // Give up, we don't want to get bogged down here
    return;
  }

  nsTArray<nsIWidget::Configuration> pluginsToMove;
  pluginsToMove.SwapElements(*aConfigurations);

  // Our algorithm is quite naive. At each step we try to identify
  // a window that can be moved to its new location that won't overlap
  // any other windows at the new location. If there is no such
  // window, we just move the last window in the list anyway.
  while (!pluginsToMove.IsEmpty()) {
    // Find a window whose destination does not overlap any other window
    uint32_t i;
    for (i = 0; i + 1 < pluginsToMove.Length(); ++i) {
      nsIWidget::Configuration* config = &pluginsToMove[i];
      bool foundOverlap = false;
      for (uint32_t j = 0; j < pluginsToMove.Length(); ++j) {
        if (i == j)
          continue;
        LayoutDeviceIntRect bounds = pluginsToMove[j].mChild->GetBounds();
        AutoTArray<LayoutDeviceIntRect,1> clipRects;
        pluginsToMove[j].mChild->GetWindowClipRegion(&clipRects);
        if (HasOverlap(bounds.TopLeft(), clipRects,
                       config->mBounds.TopLeft(),
                       config->mClipRegion)) {
          foundOverlap = true;
          break;
        }
      }
      if (!foundOverlap)
        break;
    }
    // Note that we always move the last plugin in pluginsToMove, if we
    // can't find any other plugin to move
    aConfigurations->AppendElement(pluginsToMove[i]);
    pluginsToMove.RemoveElementAt(i);
  }
}

static void
PluginGetGeometryUpdate(nsTHashtable<nsRefPtrHashKey<nsIContent>>& aPlugins,
                        nsTArray<nsIWidget::Configuration>* aConfigurations)
{
  for (auto iter = aPlugins.Iter(); !iter.Done(); iter.Next()) {
    auto f = static_cast<nsPluginFrame*>(iter.Get()->GetKey()->GetPrimaryFrame());
    if (!f) {
      NS_WARNING("Null frame in PluginGeometryUpdate");
      continue;
    }
    f->GetWidgetConfiguration(aConfigurations);
  }
}

#endif  // #ifndef XP_MACOSX

static void
PluginDidSetGeometry(nsTHashtable<nsRefPtrHashKey<nsIContent>>& aPlugins)
{
  for (auto iter = aPlugins.Iter(); !iter.Done(); iter.Next()) {
    auto f = static_cast<nsPluginFrame*>(iter.Get()->GetKey()->GetPrimaryFrame());
    if (!f) {
      NS_WARNING("Null frame in PluginDidSetGeometry");
      continue;
    }
    f->DidSetWidgetGeometry();
  }
}

void
nsRootPresContext::ApplyPluginGeometryUpdates()
{
#ifndef XP_MACOSX
  CancelApplyPluginGeometryTimer();

  nsTArray<nsIWidget::Configuration> configurations;
  PluginGetGeometryUpdate(mRegisteredPlugins, &configurations);
  // Walk mRegisteredPlugins and ask each plugin for its configuration
  if (!configurations.IsEmpty()) {
    nsIWidget* widget = configurations[0].mChild->GetParent();
    NS_ASSERTION(widget, "Plugins must have a parent window");
    SortConfigurations(&configurations);
    widget->ConfigureChildren(configurations);
  }
#endif  // #ifndef XP_MACOSX

  PluginDidSetGeometry(mRegisteredPlugins);
}

void
nsRootPresContext::CollectPluginGeometryUpdates(LayerManager* aLayerManager)
{
#ifndef XP_MACOSX
  // Collect and pass plugin widget configurations down to the compositor
  // for transmission to the chrome process.
  NS_ASSERTION(aLayerManager, "layer manager is invalid!");
  mozilla::layers::ClientLayerManager* clm = aLayerManager->AsClientLayerManager();

  nsTArray<nsIWidget::Configuration> configurations;
  // If there aren't any plugins to configure, clear the plugin data cache
  // in the layer system.
  if (!mRegisteredPlugins.Count() && clm) {
    clm->StorePluginWidgetConfigurations(configurations);
    return;
  }
  PluginGetGeometryUpdate(mRegisteredPlugins, &configurations);
  if (configurations.IsEmpty()) {
    PluginDidSetGeometry(mRegisteredPlugins);
    return;
  }
  SortConfigurations(&configurations);
  if (clm) {
    clm->StorePluginWidgetConfigurations(configurations);
  }
  PluginDidSetGeometry(mRegisteredPlugins);
#endif  // #ifndef XP_MACOSX
}

static void
NotifyDidPaintForSubtreeCallback(nsITimer *aTimer, void *aClosure)
{
  nsPresContext* presContext = (nsPresContext*)aClosure;
  nsAutoScriptBlocker blockScripts;
  // This is a fallback if we don't get paint events for some reason
  // so we'll just pretend both layer painting and compositing happened.
  presContext->NotifyDidPaintForSubtree(
      nsIPresShell::PAINT_LAYERS | nsIPresShell::PAINT_COMPOSITE);
}

void
nsRootPresContext::EnsureEventualDidPaintEvent()
{
  if (mNotifyDidPaintTimer)
    return;

  mNotifyDidPaintTimer = CreateTimer(NotifyDidPaintForSubtreeCallback, 100);
}

void
nsRootPresContext::AddWillPaintObserver(nsIRunnable* aRunnable)
{
  if (!mWillPaintFallbackEvent.IsPending()) {
    mWillPaintFallbackEvent = new RunWillPaintObservers(this);
    NS_DispatchToMainThread(mWillPaintFallbackEvent.get());
  }
  mWillPaintObservers.AppendElement(aRunnable);
}

/**
 * Run all runnables that need to get called before the next paint.
 */
void
nsRootPresContext::FlushWillPaintObservers()
{
  mWillPaintFallbackEvent = nullptr;
  nsTArray<nsCOMPtr<nsIRunnable> > observers;
  observers.SwapElements(mWillPaintObservers);
  for (uint32_t i = 0; i < observers.Length(); ++i) {
    observers[i]->Run();
  }
}

size_t
nsRootPresContext::SizeOfExcludingThis(MallocSizeOf aMallocSizeOf) const
{
  return nsPresContext::SizeOfExcludingThis(aMallocSizeOf);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mNotifyDidPaintTimer
  // - mRegisteredPlugins
  // - mWillPaintObservers
  // - mWillPaintFallbackEvent
}
