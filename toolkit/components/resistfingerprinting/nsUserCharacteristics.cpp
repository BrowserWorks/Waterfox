/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#include "nsUserCharacteristics.h"

#include "nsComponentManagerUtils.h"
#include "nsICryptoHash.h"
#include "nsID.h"
#include "nsIGfxInfo.h"
#include "nsIUUIDGenerator.h"
#include "nsIUserCharacteristicsPageService.h"
#include "nsReadableUtils.h"
#include "nsServiceManagerUtils.h"

#include "mozilla/Logging.h"
#include "mozilla/glean/GleanPings.h"
#include "mozilla/glean/ResistfingerprintingMetrics.h"

#include "jsapi.h"
#include "mozilla/Components.h"
#include "mozilla/dom/Promise-inl.h"

#include "mozilla/StaticPrefs_browser.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StaticPrefs_general.h"
#include "mozilla/StaticPrefs_media.h"
#include "mozilla/StaticPrefs_network.h"
#include "mozilla/StaticPrefs_widget.h"
#include "mozilla/StaticPrefs_privacy.h"

#include "mozilla/LookAndFeel.h"
#include "mozilla/PreferenceSheet.h"
#include "mozilla/RelativeLuminanceUtils.h"
#include "mozilla/ServoStyleConsts.h"
#include "mozilla/dom/ScreenBinding.h"
#include "mozilla/intl/LocaleService.h"
#include "mozilla/intl/OSPreferences.h"
#include "mozilla/intl/TimeZone.h"
#include "mozilla/widget/ScreenManager.h"
#include "mozilla/dom/BrowsingContext.h"
#include "mozilla/dom/Document.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/TouchEvents.h"
#include "nsPIDOMWindow.h"
#include "nsIAppWindow.h"
#include "nsIDocShellTreeOwner.h"
#include "nsIBaseWindow.h"
#include "mozilla/MediaManager.h"
#include "mozilla/dom/MediaDeviceInfoBinding.h"
#include "mozilla/MozPromise.h"
#include "nsThreadUtils.h"
#include "mozilla/dom/Navigator.h"
#include "nsIPropertyBag2.h"
#include "nsITimer.h"
#include "gfxConfig.h"

#include "gfxPlatformFontList.h"
#include "gfxTextRun.h"
#include "nsGkAtoms.h"
#include "prsystem.h"
#if defined(XP_WIN)
#  include "WinUtils.h"
#  include "mozilla/gfx/DisplayConfigWindows.h"
#  include "gfxWindowsPlatform.h"
#elif defined(MOZ_WIDGET_ANDROID)
#  include "mozilla/java/GeckoAppShellWrappers.h"
#elif defined(XP_MACOSX)
#  include "nsMacUtilsImpl.h"
#  include <CoreFoundation/CoreFoundation.h>
#  include "CFTypeRefPtr.h"
#endif
#ifdef MOZ_WIDGET_GTK
#  include "mozilla/widget/GSettings.h"
#endif

// For FPU control state detection
#include <cfenv>
#if defined(_MSC_VER)
#  include <float.h>
#  include <intrin.h>
#endif

using namespace mozilla;

static LazyLogModule gUserCharacteristicsLog("UserCharacteristics");

// ==================================================================
// MathML prefs collection - extracted for testability
static void CollectMathMLPrefs() {
  // MathML prefs - only collect those modified from defaults
  // Format: "shortname=val,..." (e.g. "dis=1,fnt=0")
  nsAutoCString mathmlPrefs;
  static const struct {
    const char* pref;
    const char* shortName;
  } kMathMLPrefs[] = {
      {"mathml.disabled", "dis"},
      {"mathml.scale_stretchy_operators.enabled", "str"},
      {"mathml.mathspace_names.disabled", "spc"},
      {"mathml.mathvariant_styling_fallback.disabled", "var"},
      {"mathml.operator_dictionary_accent.disabled", "acc"},
      {"mathml.legacy_mathvariant_attribute.disabled", "leg"},
      {"mathml.font_family_math.enabled", "fnt"},
  };
  for (const auto& p : kMathMLPrefs) {
    if (Preferences::HasUserValue(p.pref)) {
      if (!mathmlPrefs.IsEmpty()) {
        mathmlPrefs.Append(',');
      }
      mathmlPrefs.Append(p.shortName);
      mathmlPrefs.Append('=');
      mathmlPrefs.Append(Preferences::GetBool(p.pref) ? '1' : '0');
    }
  }
  glean::characteristics::mathml_diag_prefs_modified.Set(mathmlPrefs);
}

namespace testing {
extern "C" {

int MaxTouchPoints() {
#if defined(XP_WIN)
  return widget::WinUtils::GetMaxTouchPoints();
#elif defined(MOZ_WIDGET_ANDROID)
  return java::GeckoAppShell::GetMaxTouchPoints();
#else
  return 0;
#endif
}

void PopulateMathMLPrefs() { CollectMathMLPrefs(); }

}  // extern "C"
};  // namespace testing

using FunctionName = nsCString;
using AdditionalContext = nsCString;
using PopulatePromiseBase =
    MozPromise<void_t, std::tuple<FunctionName, nsresult, AdditionalContext>,
               false>;
using PopulatePromise = PopulatePromiseBase::Private;

#define REJECT(aPromise, aFuncName, aRv, aError)                          \
  aPromise->Reject(std::tuple<FunctionName, nsresult, AdditionalContext>( \
                       aFuncName, aRv, aError),                           \
                   __func__);

#define REJECT_AND_FORGET(aPromise, aFuncName, aRv, aError) \
  REJECT(aPromise, aFuncName, aRv, aError);                 \
  return (aPromise).forget();

#define REJECT_VOID(aPromise, aFuncName, aRv, aError) \
  REJECT(aPromise, aFuncName, aRv, aError);           \
  return;

// ==================================================================
// ==================================================================
already_AddRefed<PopulatePromise> ContentPageStuff() {
  nsCOMPtr<nsIUserCharacteristicsPageService> ucp =
      do_GetService("@mozilla.org/user-characteristics-page;1");
  MOZ_ASSERT(ucp);

  RefPtr<PopulatePromise> populatePromise = new PopulatePromise(__func__);
  RefPtr<mozilla::dom::Promise> promise;
  nsresult rv = ucp->CreateContentPage(
      nsContentUtils::GetFingerprintingProtectionPrincipal(),
      getter_AddRefs(promise));
  if (NS_FAILED(rv)) {
    MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Error,
            ("Could not create Content Page"));
    REJECT_AND_FORGET(populatePromise, __func__, rv, "CREATION_FAILED");
  }
  MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Debug,
          ("Created Content Page"));

  if (promise) {
    promise->AddCallbacksWithCycleCollectedArgs(
        [=](JSContext*, JS::Handle<JS::Value>, mozilla::ErrorResult&) {
          populatePromise->Resolve(void_t(), __func__);
        },
        [=](JSContext*, JS::Handle<JS::Value>, mozilla::ErrorResult& error) {
          if (error.Failed()) {
            REJECT_VOID(populatePromise, "ContentPageStuff",
                        error.StealNSResult(), "REJECTED_WITH_ERROR");
          }
          REJECT(populatePromise, "ContentPageStuff", NS_ERROR_FAILURE,
                 "REJECTED_WITHOUT_ERROR");
        });
  } else {
    MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Error,
            ("Did not get a Promise back from ContentPageStuff"));
    REJECT(populatePromise, __func__, NS_ERROR_FAILURE, "NO_PROMISE");
  }

  return populatePromise.forget();
}

void PopulateCSSProperties() {
  glean::characteristics::prefers_reduced_transparency.Set(
      LookAndFeel::GetInt(LookAndFeel::IntID::PrefersReducedTransparency));
  glean::characteristics::prefers_reduced_motion.Set(
      LookAndFeel::GetInt(LookAndFeel::IntID::PrefersReducedMotion));
  glean::characteristics::inverted_colors.Set(
      LookAndFeel::GetInt(LookAndFeel::IntID::InvertedColors));
  glean::characteristics::color_scheme.Set(
      (int)PreferenceSheet::ContentPrefs().mColorScheme);

  const auto& colors =
      PreferenceSheet::ContentPrefs().ColorsFor(ColorScheme::Light);

  StylePrefersContrast prefersContrast = [&colors] {
    // Replicates Gecko_MediaFeatures_PrefersContrast but without a Document
    if (!PreferenceSheet::ContentPrefs().mUseAccessibilityTheme &&
        PreferenceSheet::ContentPrefs().mUseDocumentColors) {
      return StylePrefersContrast::NoPreference;
    }

    float ratio = RelativeLuminanceUtils::ContrastRatio(
        colors.mDefaultBackground, colors.mDefault);
    // https://www.w3.org/TR/WCAG21/#contrast-minimum
    if (ratio < 4.5f) {
      return StylePrefersContrast::Less;
    }
    // https://www.w3.org/TR/WCAG21/#contrast-enhanced
    if (ratio >= 7.0f) {
      return StylePrefersContrast::More;
    }
    return StylePrefersContrast::Custom;
  }();
  glean::characteristics::prefers_contrast.Set((int)prefersContrast);

  glean::characteristics::use_document_colors.Set(
      PreferenceSheet::ContentPrefs().mUseDocumentColors);

  // These colors aren't using LookAndFeel, see Gecko_ComputeSystemColor.
  glean::characteristics::color_canvas.Set(colors.mDefaultBackground);
  glean::characteristics::color_canvastext.Set(colors.mDefault);

  // Similar to NS_TRANSPARENT and other special colors.
  constexpr nscolor kMissingColor = NS_RGBA(0x42, 0x00, 0x00, 0x00);

#define SYSTEM_COLOR(METRIC_NAME, COLOR_NAME)                                 \
  glean::characteristics::color_##METRIC_NAME.Set(                            \
      LookAndFeel::GetColor(LookAndFeel::ColorID::COLOR_NAME,                 \
                            ColorScheme::Light, LookAndFeel::UseStandins::No) \
          .valueOr(kMissingColor))

  SYSTEM_COLOR(accentcolor, Accentcolor);
  SYSTEM_COLOR(accentcolortext, Accentcolortext);
  SYSTEM_COLOR(highlight, Highlight);
  SYSTEM_COLOR(highlighttext, Highlighttext);
  SYSTEM_COLOR(selecteditem, Selecteditem);
  SYSTEM_COLOR(selecteditemtext, Selecteditemtext);

#undef SYSTEM_COLOR
}

void PopulateScreenProperties() {
  nsCString screensMetrics = "["_ns;

  auto& screenManager = widget::ScreenManager::GetSingleton();
  const auto& screens = screenManager.CurrentScreenList();
  for (const auto& screen : screens) {
    int32_t left, top, width, height;

    screen->GetRect(&left, &top, &width, &height);
    screensMetrics.AppendPrintf(R"({"rect":[%d,%d,%d,%d],)", left, top, width,
                                height);

    screen->GetAvailRect(&left, &top, &width, &height);
    screensMetrics.AppendPrintf(R"("availRect":[%d,%d,%d,%d],)", left, top,
                                width, height);

    screensMetrics.AppendPrintf(R"("colorDepth":%d,)", screen->GetColorDepth());
    screensMetrics.AppendPrintf(R"("pixelDepth":%d,)", screen->GetPixelDepth());
    screensMetrics.AppendPrintf(R"("oAngle":%d,)",
                                screen->GetOrientationAngle());
    screensMetrics.AppendPrintf(
        R"("oType":%d,)", static_cast<uint32_t>(screen->GetOrientationType()));
    screensMetrics.AppendPrintf(R"("hdr":%d,)", screen->GetIsHDR());
    screensMetrics.AppendPrintf(R"("scaleFactor":%f})",
                                screen->GetContentsScaleFactor());

    if (&screen != &screens.LastElement()) {
      screensMetrics.Append(",");
    }
  }

  screensMetrics.Append("]");

  glean::characteristics::screens.Set(screensMetrics);

  glean::characteristics::target_frame_rate.Set(gfxPlatform::TargetFrameRate());

  nsCOMPtr<nsPIDOMWindowInner> innerWindow =
      do_QueryInterface(dom::GetEntryGlobal());
  if (!innerWindow) {
    return;
  }

  nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
  innerWindow->GetDocShell()->GetTreeOwner(getter_AddRefs(treeOwner));
  if (!treeOwner) {
    return;
  }

  nsCOMPtr<nsIBaseWindow> treeOwnerAsWin(do_QueryInterface(treeOwner));
  if (!treeOwnerAsWin) {
    return;
  }

  nsCOMPtr<nsIWidget> mainWidget = treeOwnerAsWin->GetMainWidget();
  if (!mainWidget) {
    return;
  }

  nsSizeMode sizeMode = mainWidget ? mainWidget->SizeMode() : nsSizeMode_Normal;
  glean::characteristics::size_mode.Set(sizeMode);
}

void PopulateMissingFonts() {
  nsCString aMissingFonts;
  gfxPlatformFontList::PlatformFontList()->GetMissingFonts(aMissingFonts);

  glean::characteristics::missing_fonts.Set(aMissingFonts);
}

// Record the family name of the first font in the math-generic font group
// that exposes an OpenType MATH table. getComputedStyle on a <math>
// element cannot expose this: mathml.css applies `math { font-family: math }`
// so the CSS-author value is always the literal "math" generic, hiding the
// actual MATH-table font the layout engine picked. Build the same kind of
// font group the layout engine constructs for a default-styled <math>
// element (math-generic family, x-math language) and ask
// gfxFontGroup::GetFirstMathFont() — the same selector layout/mathml/
// itself uses to find the active MATH font. Returns "Cambria Math" on
// Windows, "STIX Two Math" on macOS Ventura+, one of "Latin Modern Math"
// / "STIX Two Math" / "TeX Gyre Pagella Math" / etc. on Linux depending
// on installed packages, and the literal sentinel "(no MATH font)" on
// platforms where no MATH-table font is available (Android, pre-Ventura
// macOS). Distinguishing the no-MATH cohort from a collection failure
// requires a sentinel rather than an empty string.
void PopulateMathFontFamily() {
  AutoTArray<StyleSingleFontFamily, 1> names;
  names.AppendElement(
      StyleSingleFontFamily::Generic(StyleGenericFontFamily::Math));
  StyleFontFamilyList familyList =
      StyleFontFamilyList::WithNames(std::move(names));

  gfxFontStyle style;
  RefPtr<gfxFontGroup> fontGroup = new gfxFontGroup(
      /* aFontVisibilityProvider */ nullptr, familyList, &style,
      nsGkAtoms::x_math, /* aExplicitLanguage */ false,
      /* aTextPerf */ nullptr, /* aUserFontSet */ nullptr,
      /* aDevToCssSize */ 1.0, StyleFontVariantEmoji::Normal);

  RefPtr<gfxFont> mathFont = fontGroup->GetFirstMathFont();
  if (mathFont) {
    glean::characteristics::mathml_diag_font_family.Set(
        mathFont->GetFontEntry()->FamilyName());
  } else {
    glean::characteristics::mathml_diag_font_family.Set("(no MATH font)"_ns);
  }
}

static void DigestToHex(const nsACString& aDigest, nsCString& aOutHex) {
  const char HEX[] = "0123456789abcdef";
  for (size_t i = 0; i < 32; ++i) {
    uint8_t b = aDigest[i];
    aOutHex.Append(HEX[(b >> 4) & 0xF]);
    aOutHex.Append(HEX[b & 0xF]);
  }
}

nsresult ProcessFingerprintedFonts(const char* aFonts[],
                                   nsCString& aOutAllowlistedHex,
                                   nsCString& aOutNonAllowlistedHex) {
  nsresult rv;
  // Create hashes
  nsCOMPtr<nsICryptoHash> allowlisted =
      do_CreateInstance(NS_CRYPTO_HASH_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);
  nsCOMPtr<nsICryptoHash> nonallowlisted =
      do_CreateInstance(NS_CRYPTO_HASH_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  // Init hashes
  rv = allowlisted->Init(nsICryptoHash::SHA256);
  NS_ENSURE_SUCCESS(rv, rv);
  rv = nonallowlisted->Init(nsICryptoHash::SHA256);
  NS_ENSURE_SUCCESS(rv, rv);

  // Iterate over fonts and update hashes
  for (size_t i = 0; aFonts[i] != nullptr; ++i) {
    nsCString font(aFonts[i]);
    bool found = false;
    FontVisibility visibility =
        gfxPlatformFontList::PlatformFontList()->GetFontVisibility(font, found);
    if (!found) {
      continue;
    }

    if (visibility == FontVisibility::Base ||
        visibility == FontVisibility::LangPack) {
      allowlisted->Update(reinterpret_cast<const uint8_t*>(font.get()),
                          font.Length());
    } else {
      nonallowlisted->Update(reinterpret_cast<const uint8_t*>(font.get()),
                             font.Length());
    }
  }

  // Finish hashes
  nsAutoCString allowlistedDigest;
  nsAutoCString nonallowlistedDigest;
  allowlisted->Finish(false, allowlistedDigest);
  nonallowlisted->Finish(false, nonallowlistedDigest);

  DigestToHex(allowlistedDigest, aOutAllowlistedHex);
  DigestToHex(nonallowlistedDigest, aOutNonAllowlistedHex);

  return NS_OK;
}

nsresult HashFontList(const nsTArray<nsCString>& aFonts, nsCString& aOutHex) {
  nsresult rv;
  nsCOMPtr<nsICryptoHash> hash =
      do_CreateInstance(NS_CRYPTO_HASH_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = hash->Init(nsICryptoHash::SHA256);
  NS_ENSURE_SUCCESS(rv, rv);

  for (const auto& font : aFonts) {
    hash->Update(reinterpret_cast<const uint8_t*>(font.get()), font.Length());
  }

  nsAutoCString digest;
  hash->Finish(false, digest);

  DigestToHex(digest, aOutHex);

  return NS_OK;
}

already_AddRefed<PopulatePromise> PopulateFingerprintedFonts() {
  RefPtr<PopulatePromise> populatePromise = new PopulatePromise(__func__);

#include "FingerprintedFonts.inc"

#define FONT_PAIR(list, metric)                                   \
  {                                                               \
    list, {                                                       \
      glean::characteristics::fonts_##metric##_allowlisted,       \
          glean::characteristics::fonts_##metric##_nonallowlisted \
    }                                                             \
  }
  std::pair<const char**,
            std::pair<glean::impl::StringMetric, glean::impl::StringMetric>>
      fontLists[] = {
          FONT_PAIR(fpjs, fpjs),          FONT_PAIR(variantA, variant_a),
          FONT_PAIR(variantB, variant_b), FONT_PAIR(variantC, variant_c),
          FONT_PAIR(variantD, variant_d), FONT_PAIR(variantE, variant_e)};

#undef FONT_PAIR

  for (const auto& [fontList, metrics] : fontLists) {
    nsCString allowlistedHex;
    nsCString nonallowlistedHex;
    nsresult rv =
        ProcessFingerprintedFonts(fontList, allowlistedHex, nonallowlistedHex);
    if (NS_FAILED(rv)) {
      REJECT_AND_FORGET(populatePromise, __func__, rv,
                        "ProcessFingerprintedFonts"_ns.AsString());
    }

    metrics.first.Set(allowlistedHex);
    metrics.second.Set(nonallowlistedHex);
  }

  // Variant F/G font fallback metrics (uses variantF font list)
  {
    gfxPlatformFontList* pfl = gfxPlatformFontList::PlatformFontList();
    if (!pfl) {
      REJECT_AND_FORGET(populatePromise, __func__, NS_ERROR_FAILURE,
                        "No platform font list"_ns.AsString());
    }

    nsTArray<nsCString> variantFontList;
    for (size_t i = 0; variantF_FontList[i] != nullptr; ++i) {
      variantFontList.AppendElement(nsCString(variantF_FontList[i]));
    }

    // Variant F: Test string "A"
    // Call twice with different visibility levels
    nsTArray<nsCString> fontsAllowlisted;
    pfl->ListFontsUsedForString(u"A"_ns, variantFontList, fontsAllowlisted,
                                FontVisibility::LangPack);
    nsTArray<nsCString> fontsNonAllowlisted;
    pfl->ListFontsUsedForString(u"A"_ns, variantFontList, fontsNonAllowlisted,
                                FontVisibility::User);

    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant F Allowlisted fonts:"));
    for (const auto& font : fontsAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant F NonAllowlisted fonts:"));
    for (const auto& font : fontsNonAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }

    nsCString aAllowlisted, aNonAllowlisted;
    if (NS_SUCCEEDED(HashFontList(fontsAllowlisted, aAllowlisted))) {
      glean::characteristics::fonts_variant_f_allowlisted.Set(aAllowlisted);
    }
    if (NS_SUCCEEDED(HashFontList(fontsNonAllowlisted, aNonAllowlisted))) {
      glean::characteristics::fonts_variant_f_nonallowlisted.Set(
          aNonAllowlisted);
    }

    // Variant G: Test emoji U+1F47E (Space Invader)
    nsTArray<nsCString> emojiFontsAllowlisted;
    pfl->ListFontsUsedForString(u"\U0001F47E"_ns, variantFontList,
                                emojiFontsAllowlisted,
                                FontVisibility::LangPack);
    nsTArray<nsCString> emojiFontsNonAllowlisted;
    pfl->ListFontsUsedForString(u"\U0001F47E"_ns, variantFontList,
                                emojiFontsNonAllowlisted, FontVisibility::User);

    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant G Allowlisted fonts:"));
    for (const auto& font : emojiFontsAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant G NonAllowlisted fonts:"));
    for (const auto& font : emojiFontsNonAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }

    nsCString emojiAllowlisted, emojiNonAllowlisted;
    if (NS_SUCCEEDED(HashFontList(emojiFontsAllowlisted, emojiAllowlisted))) {
      glean::characteristics::fonts_variant_g_allowlisted.Set(emojiAllowlisted);
    }
    if (NS_SUCCEEDED(
            HashFontList(emojiFontsNonAllowlisted, emojiNonAllowlisted))) {
      glean::characteristics::fonts_variant_g_nonallowlisted.Set(
          emojiNonAllowlisted);
    }

    // Variant H: Test multiple emojis
    nsAutoString textEmojis;
    for (auto emoji : variantHEmojis) {
      AppendUCS4ToUTF16(emoji, textEmojis);
    }

    nsTArray<nsCString> emojisFontsAllowlisted;
    pfl->ListFontsUsedForString(textEmojis, variantFontList,
                                emojisFontsAllowlisted,
                                FontVisibility::LangPack);
    nsTArray<nsCString> emojisFontsNonAllowlisted;
    pfl->ListFontsUsedForString(textEmojis, variantFontList,
                                emojisFontsNonAllowlisted,
                                FontVisibility::User);

    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant H Allowlisted fonts:"));
    for (const auto& font : emojisFontsAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Variant H NonAllowlisted fonts:"));
    for (const auto& font : emojisFontsNonAllowlisted) {
      MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("  - %s", font.get()));
    }

    nsCString emojisAllowlisted, emojisNonAllowlisted;
    if (NS_SUCCEEDED(HashFontList(emojisFontsAllowlisted, emojisAllowlisted))) {
      glean::characteristics::fonts_variant_h_allowlisted.Set(
          emojisAllowlisted);
    }
    if (NS_SUCCEEDED(
            HashFontList(emojisFontsNonAllowlisted, emojisNonAllowlisted))) {
      glean::characteristics::fonts_variant_h_nonallowlisted.Set(
          emojisNonAllowlisted);
    }

    // Variant I: SVG emojis with emoji-specific font list
    nsAutoString textVariantIEmojis;
    for (auto emoji : variantIEmojis) {
      AppendUCS4ToUTF16(emoji, textVariantIEmojis);
    }

    nsTArray<nsCString> variantIFontList;
    for (size_t i = 0; variantI_FontList[i] != nullptr; ++i) {
      variantIFontList.AppendElement(nsCString(variantI_FontList[i]));
    }

    nsTArray<nsCString> variantIAllowlisted;
    pfl->ListFontsUsedForString(textVariantIEmojis, variantIFontList,
                                variantIAllowlisted, FontVisibility::LangPack);
    nsTArray<nsCString> variantINonAllowlisted;
    pfl->ListFontsUsedForString(textVariantIEmojis, variantIFontList,
                                variantINonAllowlisted, FontVisibility::User);

    nsCString iAllowlisted, iNonAllowlisted;
    if (NS_SUCCEEDED(HashFontList(variantIAllowlisted, iAllowlisted))) {
      glean::characteristics::fonts_variant_i_allowlisted.Set(iAllowlisted);
    }
    if (NS_SUCCEEDED(HashFontList(variantINonAllowlisted, iNonAllowlisted))) {
      glean::characteristics::fonts_variant_i_nonallowlisted.Set(
          iNonAllowlisted);
    }
  }

  populatePromise->Resolve(void_t(), __func__);
  return populatePromise.forget();
}

void PopulatePrefs() {
  nsAutoCString acceptLang;
  intl::LocaleService::GetInstance()->GetAcceptLanguages(acceptLang);
  glean::characteristics::prefs_intl_accept_languages.Set(acceptLang);

  glean::characteristics::prefs_media_eme_enabled.Set(
      StaticPrefs::media_eme_enabled());

  glean::characteristics::prefs_zoom_text_only.Set(
      !Preferences::GetBool("browser.zoom.full"));

  glean::characteristics::prefs_privacy_donottrackheader_enabled.Set(
      StaticPrefs::privacy_donottrackheader_enabled());
  glean::characteristics::prefs_privacy_globalprivacycontrol_enabled.Set(
      StaticPrefs::privacy_globalprivacycontrol_enabled());

  glean::characteristics::prefs_general_autoscroll.Set(
      Preferences::GetBool("general.autoScroll"));
  glean::characteristics::prefs_general_smoothscroll.Set(
      StaticPrefs::general_smoothScroll());
  glean::characteristics::prefs_overlay_scrollbars.Set(
      StaticPrefs::widget_gtk_overlay_scrollbars_enabled());

  glean::characteristics::prefs_block_popups.Set(
      StaticPrefs::dom_disable_open_during_load());

  glean::characteristics::prefs_browser_display_use_document_fonts.Set(
      mozilla::StaticPrefs::browser_display_use_document_fonts());

  glean::characteristics::prefs_network_cookie_cookiebehavior.Set(
      StaticPrefs::network_cookie_cookieBehavior());

  CollectMathMLPrefs();
}

void PopulateKeyboardLayout() {
  nsAutoCString layoutName;

  nsresult rv = LookAndFeel::GetKeyboardLayout(layoutName);

  if (NS_FAILED(rv) || layoutName.IsEmpty()) {
    return;
  }

  glean::characteristics::keyboard_layout.Set(layoutName);
}

template <typename StringMetric, typename QuantityMetric>
static void CollectFontPrefValue(nsIPrefBranch* aPrefBranch,
                                 const nsACString& aDefaultLanguageGroup,
                                 const char* aStartingAt,
                                 StringMetric& aWesternMetric,
                                 StringMetric& aDefaultGroupMetric,
                                 QuantityMetric& aModifiedMetric) {
  nsTArray<nsCString> prefNames;
  if (NS_WARN_IF(
          NS_FAILED(aPrefBranch->GetChildList(aStartingAt, prefNames)))) {
    return;
  }

  nsCString westernPref(aStartingAt);
  westernPref.Append("x-western");
  nsCString defaultGroupPref(aStartingAt);
  defaultGroupPref.Append(aDefaultLanguageGroup);

  nsAutoCString westernPrefValue;
  Preferences::GetCString(westernPref.get(), westernPrefValue);
  aWesternMetric.Set(westernPrefValue);

  nsAutoCString defaultGroupPrefValue;
  if (!westernPref.Equals(defaultGroupPref)) {
    Preferences::GetCString(defaultGroupPref.get(), defaultGroupPrefValue);
  }
  aDefaultGroupMetric.Set(defaultGroupPrefValue);

  uint32_t modifiedCount = 0;
  for (const auto& prefName : prefNames) {
    if (!prefName.Equals(westernPref) && !prefName.Equals(defaultGroupPref)) {
      if (Preferences::HasUserValue(prefName.get())) {
        modifiedCount++;
      }
    }
  }
  aModifiedMetric.Set(modifiedCount);
}

template <typename StringMetric, typename QuantityMetric>
static void CollectFontIntPrefValue(nsIPrefBranch* aPrefBranch,
                                    const nsACString& aDefaultLanguageGroup,
                                    const char* aStartingAt,
                                    StringMetric& aWesternMetric,
                                    StringMetric& aDefaultGroupMetric,
                                    QuantityMetric& aModifiedMetric) {
  nsTArray<nsCString> prefNames;
  if (NS_WARN_IF(
          NS_FAILED(aPrefBranch->GetChildList(aStartingAt, prefNames)))) {
    return;
  }

  nsCString westernPref(aStartingAt);
  westernPref.Append("x-western");
  nsCString defaultGroupPref(aStartingAt);
  defaultGroupPref.Append(aDefaultLanguageGroup);

  nsAutoCString westernPrefValue;
  westernPrefValue.AppendInt(Preferences::GetInt(westernPref.get()));
  aWesternMetric.Set(westernPrefValue);

  nsAutoCString defaultGroupPrefValue;
  if (!westernPref.Equals(defaultGroupPref)) {
    defaultGroupPrefValue.AppendInt(
        Preferences::GetInt(defaultGroupPref.get()));
  }
  aDefaultGroupMetric.Set(defaultGroupPrefValue);

  uint32_t modifiedCount = 0;
  for (const auto& prefName : prefNames) {
    if (!prefName.Equals(westernPref) && !prefName.Equals(defaultGroupPref)) {
      if (Preferences::HasUserValue(prefName.get())) {
        modifiedCount++;
      }
    }
  }
  aModifiedMetric.Set(modifiedCount);
}

template <typename QuantityMetric>
static void CollectFontPrefModified(nsIPrefBranch* aPrefBranch,
                                    const char* aStartingAt,
                                    QuantityMetric& aModifiedMetric) {
  nsTArray<nsCString> prefNames;
  if (NS_WARN_IF(
          NS_FAILED(aPrefBranch->GetChildList(aStartingAt, prefNames)))) {
    return;
  }

  uint32_t modifiedCount = 0;
  for (const auto& prefName : prefNames) {
    if (Preferences::HasUserValue(prefName.get())) {
      modifiedCount++;
    }
  }
  aModifiedMetric.Set(modifiedCount);
}

void PopulateFontPrefs() {
  nsIPrefBranch* prefRootBranch = Preferences::GetRootBranch();
  if (!prefRootBranch) {
    return;
  }

  nsCString fontLanguageGroup;
  intl::LocaleService::GetInstance()->GetFontLanguageGroup(fontLanguageGroup);

#define FONT_PREF(PREF_NAME, METRIC_NAME)                                   \
  CollectFontPrefValue(prefRootBranch, fontLanguageGroup, PREF_NAME,        \
                       glean::characteristics::METRIC_NAME##_western,       \
                       glean::characteristics::METRIC_NAME##_default_group, \
                       glean::characteristics::METRIC_NAME##_modified)

#define FONT_INT_PREF(PREF_NAME, METRIC_NAME)                                  \
  CollectFontIntPrefValue(prefRootBranch, fontLanguageGroup, PREF_NAME,        \
                          glean::characteristics::METRIC_NAME##_western,       \
                          glean::characteristics::METRIC_NAME##_default_group, \
                          glean::characteristics::METRIC_NAME##_modified)

  // The following preferences can be modified using the advanced font options
  // on the about:preferences page. Every preference has a sub-branch per
  // script, so for example font.default.x-western or font.default.x-cyrillic
  // etc. For all of the 7 main preferences, we collect:
  // - The value for the x-western branch (if user modified)
  // - The value for the current default language group (~ script) based
  //   on the localized version of Firefox being used. (Only when not x-western)
  // - How many /other/ script that are not x-western or the default have been
  //   modified.

  FONT_PREF("font.default.", font_default);
  FONT_PREF("font.name.serif.", font_name_serif);
  FONT_PREF("font.name.sans-serif.", font_name_sans_serif);
  FONT_PREF("font.name.monospace.", font_name_monospace);
  FONT_INT_PREF("font.size.variable.", font_size_variable);
  FONT_INT_PREF("font.size.monospace.", font_size_monospace);
  FONT_INT_PREF("font.minimum-size.", font_minimum_size);

#undef FONT_INT_PREF
#undef FONT_PREF

  CollectFontPrefModified(
      prefRootBranch, "font.name-list.serif.",
      glean::characteristics::font_name_list_serif_modified);
  CollectFontPrefModified(
      prefRootBranch, "font.name-list.sans-serif.",
      glean::characteristics::font_name_list_sans_serif_modified);
  CollectFontPrefModified(
      prefRootBranch, "font.name-list.monospace.",
      glean::characteristics::font_name_list_monospace_modified);
  CollectFontPrefModified(
      prefRootBranch, "font.name-list.cursive.",
      glean::characteristics::font_name_list_cursive_modified);
  // Exceptionally this pref has no variants per-script.
  glean::characteristics::font_name_list_emoji_modified.Set(
      Preferences::HasUserValue("font.name-list.emoji"));
}

already_AddRefed<PopulatePromise> PopulateMediaDevices() {
  RefPtr<PopulatePromise> populatePromise = new PopulatePromise(__func__);
  MediaManager::Get()->GetPhysicalDevices()->Then(
      GetCurrentSerialEventTarget(), __func__,
      [=](const RefPtr<const MediaManager::MediaDeviceSetRefCnt>& aDevices) {
        uint32_t cameraCount = 0;
        uint32_t microphoneCount = 0;
        uint32_t speakerCount = 0;
        std::set<nsString> groupIds;
        std::set<nsString> groupIdsWoSpeakers;

        for (const auto& device : *aDevices) {
          if (device->mKind == dom::MediaDeviceKind::Videoinput) {
            cameraCount++;
          } else if (device->mKind == dom::MediaDeviceKind::Audioinput) {
            microphoneCount++;
          } else if (device->mKind == dom::MediaDeviceKind::Audiooutput) {
            speakerCount++;
          }
          if (groupIds.find(device->mRawGroupID) == groupIds.end()) {
            groupIds.insert(device->mRawGroupID);
            if (device->mKind != dom::MediaDeviceKind::Audiooutput) {
              groupIdsWoSpeakers.insert(device->mRawGroupID);
            }
          }
        }

        glean::characteristics::camera_count.Set(cameraCount);
        glean::characteristics::microphone_count.Set(microphoneCount);
        glean::characteristics::speaker_count.Set(speakerCount);
        glean::characteristics::group_count.Set(
            static_cast<int64_t>(groupIds.size()));
        glean::characteristics::group_count_wo_speakers.Set(
            static_cast<int64_t>(groupIdsWoSpeakers.size()));

        populatePromise->Resolve(void_t(), __func__);
      },
      [=](RefPtr<MediaMgrError>&& reason) {
        // GetPhysicalDevices() never rejects but we'll add the following
        // just in case it changes in the future
        reason->mMessage.StripChar(',');
        REJECT(populatePromise, "PopulateMediaDevices", NS_ERROR_FAILURE,
               reason->mMessage);
      });
  return populatePromise.forget();
}

void PopulateLanguages() {
  // All navigator.languages, navigator.language, and Accept-Languages header
  // use Navigator::GetAcceptLanguages to create a language list. It is
  // sufficient to only collect this information as the other properties are
  // just reformats of Navigator::GetAcceptLanguages.
  nsTArray<nsString> languages;
  dom::Navigator::GetAcceptLanguages(languages, nullptr);
  nsCString output = "["_ns;

  for (const auto& language : languages) {
    output.AppendPrintf(R"("%s")", NS_ConvertUTF16toUTF8(language).get());

    if (&language != &languages.LastElement()) {
      output.Append(",");
    }
  }

  output.Append("]");

  glean::characteristics::languages.Set(output);
}

void PopulateTextAntiAliasing() {
  nsCString output = "["_ns;
  nsTArray<int32_t> levels;

#if defined(XP_WIN)
  nsTArray<ClearTypeParameterInfo> params;
  gfxWindowsPlatform::GetCleartypeParams(params);
  for (const auto& param : params) {
    levels.AppendElement(param.clearTypeLevel);
  }
#elif defined(XP_MACOSX)
  uint32_t value = 2;  // default = medium
  auto prefValue = CFTypeRefPtr<CFPropertyListRef>::WrapUnderCreateRule(
      CFPreferencesCopyAppValue(CFSTR("AppleFontSmoothing"),
                                kCFPreferencesAnyApplication));
  if (prefValue) {
    if (CFGetTypeID(prefValue.get()) == CFNumberGetTypeID()) {
      if (!CFNumberGetValue(static_cast<CFNumberRef>(prefValue.get()),
                            kCFNumberIntType, &value)) {
        value = 2;  // default = medium
      }
    } else if (CFGetTypeID(prefValue.get()) == CFStringGetTypeID()) {
      // For some reason, the value can be a string
      value = CFStringGetIntValue(static_cast<CFStringRef>(prefValue.get()));
    }
  }
  levels.AppendElement(value);
#elif defined(MOZ_WIDGET_GTK)
  nsAutoCString level;
  mozilla::widget::GSettings::GetString("org.gnome.desktop.interface"_ns,
                                        "font-antialiasing"_ns, level);
  if (level == "rgba") {  // Subpixel
    levels.AppendElement(2);
  } else if (level == "grayscale") {  // Standard
    levels.AppendElement(1);
  } else if (level == "none") {
    levels.AppendElement(0);
  }
#endif

  for (const auto& level : levels) {
    output.Append(std::to_string(level));

    if (&level != &levels.LastElement()) {
      output.Append(",");
    }
  }

  output.Append("]");

  glean::characteristics::text_anti_aliasing.Set(output);
}

void PopulateErrors(
    const PopulatePromise::AllSettledPromiseType::ResolveOrRejectValue&
        results) {
  nsCString errors;
  for (const auto& result : results.ResolveValue()) {
    if (!result.IsReject()) {
      continue;
    }

    const auto& errorVar = result.RejectValue();
    nsCString funcName = std::get<0>(errorVar);
    nsresult rv = std::get<1>(errorVar);
    nsCString additionalCtx = std::get<2>(errorVar);

    errors.AppendPrintf("%s:%" PRIu32 ":%s", funcName.get(),
                        static_cast<uint32_t>(rv), additionalCtx.get());
    MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Error,
            ("Error encountered: %s:%" PRIu32 ":%s", funcName.get(),
             static_cast<uint32_t>(rv), additionalCtx.get()));

    errors.Append(",");
  }
  if (errors.Length() > 0) {
    errors.Cut(errors.Length() - 1, 1);
  }
  glean::characteristics::errors.Set(errors);
}

void PopulateProcessorCount() {
  int32_t processorCount = 0;
#if defined(XP_MACOSX)
  if (nsMacUtilsImpl::IsTCSMAvailable()) {
    // On failure, zero is returned from GetPhysicalCPUCount()
    // and we fallback to PR_GetNumberOfProcessors below.
    processorCount = nsMacUtilsImpl::GetPhysicalCPUCount();
  }
#endif
  if (processorCount == 0) {
    processorCount = PR_GetNumberOfProcessors();
  }
  glean::characteristics::processor_count.Set(processorCount);
}

/**
 * Gets the complete FPU state including rounding mode and precision.
 * Returns a string formatted as:
 * - x86/x86-64: "std:X;x87:Y;sse:Z;prec:P"
 * - ARM: "std:X;arm:Y"
 * Where X,Y,Z are rounding mode values (0-3) and P is precision.
 */
static nsCString GetFPUControlState() {
  nsCString result;

  // Get standard C rounding mode (portable)
  int std_mode = std::fegetround();
  const char* mode_str = "unknown";
  switch (std_mode) {
    case FE_TONEAREST:
      mode_str = "0";
      break;
    case FE_DOWNWARD:
      mode_str = "1";
      break;
    case FE_UPWARD:
      mode_str = "2";
      break;
    case FE_TOWARDZERO:
      mode_str = "3";
      break;
  }
  result.AppendLiteral("std:");
  result.Append(mode_str);

#if defined(__x86_64__) || defined(_M_X64) || defined(__i386__) || \
    defined(_M_IX86)
  // x86/x86-64: Read both x87 and SSE control registers

  // Read x87 control word
  uint16_t x87_cw = 0;
#  ifdef _MSC_VER
  x87_cw = static_cast<uint16_t>(_control87(0, 0));
#  else
  __asm__ __volatile__("fstcw %0" : "=m"(x87_cw));
#  endif

  // Extract rounding mode (bits 10-11)
  int x87_round = (x87_cw >> 10) & 0x3;
  result.AppendLiteral(";x87:");
  result.AppendInt(x87_round);

  // Extract precision control (bits 8-9)
  int precision = (x87_cw >> 8) & 0x3;
  const char* prec_str = "unknown";
  switch (precision) {
    case 0:
      prec_str = "single";
      break;
    case 1:
      prec_str = "reserved";
      break;
    case 2:
      prec_str = "double";
      break;
    case 3:
      prec_str = "extended";
      break;
  }

    // Read SSE MXCSR register (64-bit only, or 32-bit with SSE support)
#  if defined(__x86_64__) || defined(_M_X64) || defined(__SSE__)
  uint32_t mxcsr = 0;
#    ifdef _MSC_VER
  mxcsr = _mm_getcsr();
#    else
  __asm__ __volatile__("stmxcsr %0" : "=m"(mxcsr));
#    endif

  // Extract rounding mode (bits 13-14)
  int sse_round = (mxcsr >> 13) & 0x3;
  result.AppendLiteral(";sse:");
  result.AppendInt(sse_round);
#  else
  // 32-bit without SSE
  result.AppendLiteral(";sse:na");
#  endif

  result.AppendLiteral(";prec:");
  result.Append(prec_str);

#elif defined(__aarch64__)
  // ARM64: Read FPCR register
  uint64_t fpcr = 0;
  __asm__ __volatile__("mrs %0, fpcr" : "=r"(fpcr));

  // Extract rounding mode (bits 22-23)
  int arm_round = (fpcr >> 22) & 0x3;
  result.AppendLiteral(";arm:");
  result.AppendInt(arm_round);

#elif defined(__arm__)
  // ARM32: Read FPSCR register
  uint32_t fpscr = 0;
  __asm__ __volatile__("vmrs %0, fpscr" : "=r"(fpscr));

  // Extract rounding mode (bits 22-23)
  int arm_round = (fpscr >> 22) & 0x3;
  result.AppendLiteral(";arm:");
  result.AppendInt(arm_round);

#else
  // Other architectures: only report standard mode
  result.AppendLiteral(";arch:other");
#endif

  return result;
}

void PopulateMisc(bool worksInGtest) {
  if (worksInGtest) {
    // Collect FPU control state
    nsCString fpuState = GetFPUControlState();
    glean::characteristics::fpu_control_state.Set(fpuState);

    glean::characteristics::max_touch_points.Set(testing::MaxTouchPoints());
    nsCOMPtr<nsIGfxInfo> gfxInfo = components::GfxInfo::Service();
    if (gfxInfo) {
      bool isUsingAcceleratedCanvas = false;
      gfxInfo->GetUsingAcceleratedCanvas(&isUsingAcceleratedCanvas);
      glean::characteristics::using_accelerated_canvas.Set(
          isUsingAcceleratedCanvas);
      auto& feature = mozilla::gfx::gfxConfig::GetFeature(
          mozilla::gfx::Feature::ACCELERATED_CANVAS2D);
      nsCString status = feature.GetValue() == gfx::FeatureStatus::Blocklisted
                             ? "#BLOCKLIST_SPECIFIC"_ns
                             : feature.GetStatusAndFailureIdString();
      glean::characteristics::canvas_feature_status.Set(status);
    }
  } else {
    // System Locale
    nsAutoCString locale;
    intl::OSPreferences::GetInstance()->GetSystemLocale(locale);
    glean::characteristics::system_locale.Set(locale);
  }
}

already_AddRefed<PopulatePromise> PopulateTimeZone() {
  RefPtr<PopulatePromise> populatePromise = new PopulatePromise(__func__);

  AutoTArray<char16_t, 128> tzBuffer;
  auto result = intl::TimeZone::GetDefaultTimeZone(tzBuffer);
  if (result.isOk()) {
    NS_ConvertUTF16toUTF8 timeZone(
        nsDependentString(tzBuffer.Elements(), tzBuffer.Length()));
    glean::characteristics::timezone.Set(timeZone);
    populatePromise->Resolve(void_t(), __func__);
  } else {
    REJECT(populatePromise, __func__, NS_ERROR_FAILURE,
           nsPrintfCString("ICUError=%" PRIu8,
                           static_cast<uint8_t>(result.unwrapErr())));
  }

  return populatePromise.forget();
}

void PopulateModelName() {
  nsCString modelName("null");

  nsCOMPtr<nsIPropertyBag2> sysInfo =
      do_GetService("@mozilla.org/system-info;1");
  NS_ENSURE_TRUE_VOID(sysInfo);

#if defined(XP_MACOSX)
  sysInfo->GetPropertyAsACString(u"appleModelId"_ns, modelName);
#elif defined(MOZ_WIDGET_ANDROID)
  sysInfo->GetPropertyAsACString(u"manufacturer"_ns, modelName);
  modelName.AppendLiteral(" ");
  nsCString temp;
  sysInfo->GetPropertyAsACString(u"device"_ns, temp);
  modelName.Append(temp);
#elif defined(XP_WIN)
  sysInfo->GetPropertyAsACString(u"winModelId"_ns, modelName);
#elif defined(XP_LINUX)
  sysInfo->GetPropertyAsACString(u"linuxProductSku"_ns, modelName);
  if (modelName.IsEmpty()) {
    sysInfo->GetPropertyAsACString(u"linuxProductName"_ns, modelName);
  }
#endif

  glean::characteristics::machine_model_name.Set(modelName);
}

const RefPtr<PopulatePromise>& TimoutPromise(
    const RefPtr<PopulatePromise>& promise, uint32_t delay,
    const nsCString& funcName) {
  nsCOMPtr<nsITimer> timeout;
  nsresult rv = NS_NewTimerWithCallback(
      getter_AddRefs(timeout),
      [=](auto) {
        // NOTE: has no effect if `promise` has already been resolved.
        REJECT(promise, funcName, NS_ERROR_FAILURE, "TIMEOUT");
      },
      delay, nsITimer::TYPE_ONE_SHOT, "UserCharacteristicsPromiseTimeout"_ns);
  if (NS_FAILED(rv)) {
    REJECT(promise, funcName, rv, "TIMEOUT_CREATION");
  }

  auto cancelTimeoutRes = [timeout = std::move(timeout)]() {
    timeout->Cancel();
  };
  auto cancelTimeoutRej = cancelTimeoutRes;
  promise->Then(GetCurrentSerialEventTarget(), __func__,
                std::move(cancelTimeoutRes), std::move(cancelTimeoutRej));

  return promise;
}

// ==================================================================
// The current schema of the data. Anytime you add a metric, or change how a
// metric is set, this variable should be incremented. It'll be a lot. It's
// okay. We're going to need it to know (including during development) what is
// the source of the data we are looking at.
const int kSubmissionSchema = 44;

const auto* const kUUIDPref =
    "toolkit.telemetry.user_characteristics_ping.uuid";

const auto* const kLastVersionPref =
    "toolkit.telemetry.user_characteristics_ping.last_version_sent";
const auto* const kCurrentVersionPref =
    "toolkit.telemetry.user_characteristics_ping.current_version";
const auto* const kOptOutPref =
    "toolkit.telemetry.user_characteristics_ping.opt-out";
const auto* const kSendOncePref =
    "toolkit.telemetry.user_characteristics_ping.send-once";
const auto* const kFingerprintingProtectionOverridesPref =
    "privacy.fingerprintingProtection.overrides";
const auto* const kBaselineFPPOverridesPref =
    "privacy.baselineFingerprintingProtection.overrides";

namespace {

// A helper function to get the current version from the pref. The current
// version value is decided by both the default value and the user value. We use
// the one with a greater number as the current version. The reason is that the
// current value pref could be modified by either Nimbus or Firefox pref change.
// Nimbus changes the user value and the Firefox pref change controls the
// default value. To ensure changing the pref can successfully alter the current
// version, we only consider the one with a larger version number as the current
// version.
int32_t GetCurrentVersion() {
  auto userValue = Preferences::GetInt(kCurrentVersionPref, 0);
  auto defaultValue =
      Preferences::GetInt(kCurrentVersionPref, 0, PrefValueKind::Default);

  return std::max(userValue, defaultValue);
}

}  // anonymous namespace

// We don't submit a ping if this function fails
nsresult PopulateEssentials() {
  glean::characteristics::submission_schema.Set(kSubmissionSchema);

  nsAutoCString uuidString;
  nsresult rv = Preferences::GetCString(kUUIDPref, uuidString);
  if (NS_FAILED(rv) || uuidString.Length() == 0) {
    nsIDToCString id(nsID::GenerateUUID());
    uuidString = id.get();
    Preferences::SetCString(kUUIDPref, uuidString);
  }

  glean::characteristics::client_identifier.Set(uuidString);
  return NS_OK;
}

void AfterPingSentSteps(bool aUpdatePref) {
  if (aUpdatePref) {
    MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Debug,
            ("Updating preference"));
    auto current_version = GetCurrentVersion();
    Preferences::SetInt(kLastVersionPref, current_version);
    if (Preferences::GetBool(kSendOncePref, false)) {
      Preferences::SetBool(kSendOncePref, false);
    }
  }
}

/*
  We allow users to send one voluntary ping by setting kSendOncePref to true.
  We also use this to force submit a ping as a dev.

  We allow users users to opt-out of this ping by setting kOptOutPref to true.
  Note that kSendOncePref takes precedence over kOptOutPref. This allows user
  to send only a single ping without modifying their opt-out preference.

  We only send pings if the conditions above are met and kCurrentVersionPref >
  kLastVersionPref.
*/
bool nsUserCharacteristics::ShouldSubmit() {
  // User opted out of this ping specifically
  bool optOut = Preferences::GetBool(kOptOutPref, false);
  bool sendOnce = Preferences::GetBool(kSendOncePref, false);

  if (optOut && sendOnce) {
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Warning,
            ("BOTH OPT-OUT AND SEND-ONCE IS SET TO TRUE. OPT-OUT HAS PRIORITY "
             "OVER SEND-ONCE. THE PING WON'T BE SEND."));
  }

  if (optOut) {
    return false;
  }

  if (StaticPrefs::privacy_resistFingerprinting_DoNotUseDirectly() ||
      StaticPrefs::privacy_resistFingerprinting_pbmode_DoNotUseDirectly()) {
    // If resistFingerprinting is enabled, we don't want to send the ping
    // as it will mess up data.
    return false;
  }

  nsAutoString overrides;
  nsresult rv =
      Preferences::GetString(kFingerprintingProtectionOverridesPref, overrides);
  if (NS_FAILED(rv) || !overrides.IsEmpty()) {
    // If there are any overrides, we don't want to send the ping
    // as it will mess up data.
    return false;
  }

  rv = Preferences::GetString(kBaselineFPPOverridesPref, overrides);
  if (NS_FAILED(rv) || !overrides.IsEmpty()) {
    // If there are any baseline overrides, we don't want to send the ping
    // as it will mess up data.
    return false;
  }

  // User asked to send a ping regardless of the version
  if (sendOnce) {
    return true;
  }

  int32_t currentVersion = GetCurrentVersion();
  int32_t lastSubmissionVersion = Preferences::GetInt(kLastVersionPref, 0);

  if (currentVersion == 0) {
    // Do nothing. We do not want any pings.
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug,
            ("Returning, currentVersion == 0"));
    return false;
  }

  if (lastSubmissionVersion > currentVersion) {
    // This is an unexpected scenario that indicates something is wrong. We
    // asserted against it (in debug, above) We will try to sanity-correct
    // ourselves by setting it to the current version.
    Preferences::SetInt(kLastVersionPref, currentVersion);
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Warning,
            ("Returning, lastSubmissionVersion > currentVersion"));
    return false;
  }

  if (lastSubmissionVersion == currentVersion) {
    // We are okay, we've already submitted the most recent ping
    MOZ_LOG(gUserCharacteristicsLog, LogLevel::Warning,
            ("Returning, lastSubmissionVersion == currentVersion"));
    return false;
  }

  MOZ_LOG(gUserCharacteristicsLog, LogLevel::Warning, ("Ping requested"));

  return true;
}

/* static */
void nsUserCharacteristics::MaybeSubmitPing() {
  MOZ_LOG(gUserCharacteristicsLog, LogLevel::Debug, ("In MaybeSubmitPing()"));
  MOZ_ASSERT(XRE_IsParentProcess());

  // Check user's preferences and submit only if (the user hasn't opted-out AND
  // lastSubmissionVersion < currentVersion) OR send-once is true.
  if (ShouldSubmit()) {
    PopulateDataAndEventuallySubmit(true);
  }
}

/* static */
void nsUserCharacteristics::PopulateDataAndEventuallySubmit(
    bool aUpdatePref /* = true */, bool aTesting /* = false */
) {
  MOZ_LOG(gUserCharacteristicsLog, LogLevel::Warning, ("Populating Data"));
  MOZ_ASSERT(XRE_IsParentProcess());

  if (NS_FAILED(PopulateEssentials())) {
    // We couldn't populate important metrics. Don't submit a ping.
    AfterPingSentSteps(false);
    return;
  }

  // ------------------------------------------------------------------------

  nsTArray<RefPtr<PopulatePromiseBase>> promises;
  if (!aTesting) {
    // Many of the later peices of data do not work in a gtest
    // so skip populating them

    // ------------------------------------------------------------------------

    promises.AppendElement(PopulateMediaDevices());
    promises.AppendElement(PopulateTimeZone());
    promises.AppendElement(PopulateFingerprintedFonts());
    PopulateMissingFonts();
    PopulateCSSProperties();
    PopulateScreenProperties();
    PopulatePrefs();
    PopulateFontPrefs();
    PopulateKeyboardLayout();
    PopulateLanguages();
    PopulateTextAntiAliasing();
    PopulateProcessorCount();
    PopulateModelName();
    PopulateMisc(false);
  }

  // Needs the platform font list; skip when it has not been initialized
  // (e.g. in gtest), but otherwise run in both production and mochitest.
  if (gfxPlatformFontList::PlatformFontList(/* aMustInitialize */ false)) {
    PopulateMathFontFamily();
  }

  promises.AppendElement(ContentPageStuff());
  PopulateMisc(true);

  // ------------------------------------------------------------------------

  auto fulfillSteps = [aUpdatePref, aTesting]() {
    MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Debug,
            ("All promises Resolved"));

    if (!aTesting) {
      nsUserCharacteristics::SubmitPing();
    }

    AfterPingSentSteps(aUpdatePref);
  };

  PopulatePromise::AllSettled(GetCurrentSerialEventTarget(), promises)
      ->Then(GetCurrentSerialEventTarget(), __func__,
             [=](const PopulatePromise::AllSettledPromiseType::
                     ResolveOrRejectValue& results) {
               PopulateErrors(results);

               fulfillSteps();
             });
}

/* static */
void nsUserCharacteristics::SubmitPing() {
  MOZ_LOG(gUserCharacteristicsLog, mozilla::LogLevel::Warning,
          ("Submitting Ping"));
  glean_pings::UserCharacteristics.Submit();
}
