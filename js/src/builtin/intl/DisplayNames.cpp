/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Intl.DisplayNames implementation. */

#include "builtin/intl/DisplayNames.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/Assertions.h"
#include "mozilla/Span.h"
#include "mozilla/TextUtils.h"

#include <algorithm>

#include "jsapi.h"
#include "jsfriendapi.h"
#include "jsnum.h"
#include "jspubtd.h"

#include "builtin/intl/CommonFunctions.h"
#include "builtin/intl/LanguageTag.h"
#include "builtin/intl/ScopedICUObject.h"
#include "builtin/intl/SharedIntlData.h"
#include "gc/AllocKind.h"
#include "gc/FreeOp.h"
#include "gc/Rooting.h"
#include "js/CallArgs.h"
#include "js/Class.h"
#include "js/GCVector.h"
#include "js/PropertyDescriptor.h"
#include "js/PropertySpec.h"
#include "js/Result.h"
#include "js/RootingAPI.h"
#include "js/TypeDecls.h"
#include "js/Utility.h"
#include "unicode/ucal.h"
#include "unicode/ucurr.h"
#include "unicode/udat.h"
#include "unicode/udatpg.h"
#include "unicode/udisplaycontext.h"
#include "unicode/uldnames.h"
#include "unicode/uloc.h"
#include "unicode/umachine.h"
#include "unicode/utypes.h"
#include "vm/GlobalObject.h"
#include "vm/JSAtom.h"
#include "vm/JSContext.h"
#include "vm/JSObject.h"
#include "vm/List.h"
#include "vm/Printer.h"
#include "vm/Runtime.h"
#include "vm/SelfHosting.h"
#include "vm/Stack.h"
#include "vm/StringType.h"

#include "vm/JSObject-inl.h"
#include "vm/List-inl.h"
#include "vm/NativeObject-inl.h"

using namespace js;

using js::intl::CallICU;
using js::intl::IcuLocale;

const JSClassOps DisplayNamesObject::classOps_ = {nullptr, /* addProperty */
                                                  nullptr, /* delProperty */
                                                  nullptr, /* enumerate */
                                                  nullptr, /* newEnumerate */
                                                  nullptr, /* resolve */
                                                  nullptr, /* mayResolve */
                                                  DisplayNamesObject::finalize};

const JSClass DisplayNamesObject::class_ = {
    js_Object_str,
    JSCLASS_HAS_RESERVED_SLOTS(DisplayNamesObject::SLOT_COUNT) |
        JSCLASS_HAS_CACHED_PROTO(JSProto_DisplayNames) |
        JSCLASS_FOREGROUND_FINALIZE,
    &DisplayNamesObject::classOps_, &DisplayNamesObject::classSpec_};

const JSClass& DisplayNamesObject::protoClass_ = PlainObject::class_;

static bool displayNames_toSource(JSContext* cx, unsigned argc, Value* vp) {
  CallArgs args = CallArgsFromVp(argc, vp);
  args.rval().setString(cx->names().DisplayNames);
  return true;
}

static const JSFunctionSpec displayNames_static_methods[] = {
    JS_SELF_HOSTED_FN("supportedLocalesOf",
                      "Intl_DisplayNames_supportedLocalesOf", 1, 0),
    JS_FS_END};

static const JSFunctionSpec displayNames_methods[] = {
    JS_SELF_HOSTED_FN("of", "Intl_DisplayNames_of", 1, 0),
    JS_SELF_HOSTED_FN("resolvedOptions", "Intl_DisplayNames_resolvedOptions", 0,
                      0),
    JS_FN(js_toSource_str, displayNames_toSource, 0, 0), JS_FS_END};

static const JSPropertySpec displayNames_properties[] = {
    JS_STRING_SYM_PS(toStringTag, "Intl.DisplayNames", JSPROP_READONLY),
    JS_PS_END};

static bool DisplayNames(JSContext* cx, unsigned argc, Value* vp);

const ClassSpec DisplayNamesObject::classSpec_ = {
    GenericCreateConstructor<DisplayNames, 0, gc::AllocKind::FUNCTION>,
    GenericCreatePrototype<DisplayNamesObject>,
    displayNames_static_methods,
    nullptr,
    displayNames_methods,
    displayNames_properties,
    nullptr,
    ClassSpec::DontDefineConstructor};

enum class DisplayNamesOptions {
  Standard,

  // Calendar display names are no longer available with the current spec
  // proposal text, but may be re-enabled in the future. For our internal use
  // we still need to have them present, so use a feature guard for now.
  EnableMozExtensions,
};

/**
 * Initialize a new Intl.DisplayNames object using the named self-hosted
 * function.
 */
static bool InitializeDisplayNamesObject(JSContext* cx, HandleObject obj,
                                         HandlePropertyName initializer,
                                         HandleValue locales,
                                         HandleValue options,
                                         DisplayNamesOptions dnoptions) {
  FixedInvokeArgs<4> args(cx);

  args[0].setObject(*obj);
  args[1].set(locales);
  args[2].set(options);
  args[3].setBoolean(dnoptions == DisplayNamesOptions::EnableMozExtensions);

  RootedValue ignored(cx);
  if (!CallSelfHostedFunction(cx, initializer, NullHandleValue, args,
                              &ignored)) {
    return false;
  }

  MOZ_ASSERT(ignored.isUndefined(),
             "Unexpected return value from non-legacy Intl object initializer");
  return true;
}

/**
 * Intl.DisplayNames ([ locales [ , options ]])
 */
static bool DisplayNames(JSContext* cx, const CallArgs& args,
                         DisplayNamesOptions dnoptions) {
  // Step 1.
  if (!ThrowIfNotConstructing(cx, args, "Intl.DisplayNames")) {
    return false;
  }

  // Step 2 (Inlined 9.1.14, OrdinaryCreateFromConstructor).
  RootedObject proto(cx);
  if (dnoptions == DisplayNamesOptions::Standard) {
    if (!GetPrototypeFromBuiltinConstructor(cx, args, JSProto_DisplayNames,
                                            &proto)) {
      return false;
    }
  } else {
    RootedObject newTarget(cx, &args.newTarget().toObject());
    if (!GetPrototypeFromConstructor(cx, newTarget, JSProto_Null, &proto)) {
      return false;
    }
  }

  Rooted<DisplayNamesObject*> displayNames(cx);
  displayNames = NewObjectWithClassProto<DisplayNamesObject>(cx, proto);
  if (!displayNames) {
    return false;
  }

  HandleValue locales = args.get(0);
  HandleValue options = args.get(1);

  // Steps 3-26.
  if (!InitializeDisplayNamesObject(cx, displayNames,
                                    cx->names().InitializeDisplayNames, locales,
                                    options, dnoptions)) {
    return false;
  }

  // Step 27.
  args.rval().setObject(*displayNames);
  return true;
}

static bool DisplayNames(JSContext* cx, unsigned argc, Value* vp) {
  CallArgs args = CallArgsFromVp(argc, vp);
  return DisplayNames(cx, args, DisplayNamesOptions::Standard);
}

static bool MozDisplayNames(JSContext* cx, unsigned argc, Value* vp) {
  CallArgs args = CallArgsFromVp(argc, vp);
  return DisplayNames(cx, args, DisplayNamesOptions::EnableMozExtensions);
}

void js::DisplayNamesObject::finalize(JSFreeOp* fop, JSObject* obj) {
  MOZ_ASSERT(fop->onMainThread());

  if (ULocaleDisplayNames* ldn =
          obj->as<DisplayNamesObject>().getLocaleDisplayNames()) {
    intl::RemoveICUCellMemory(fop, obj, DisplayNamesObject::EstimatedMemoryUse);

    uldn_close(ldn);
  }
}

bool js::AddDisplayNamesConstructor(JSContext* cx, HandleObject intl) {
  JSObject* ctor =
      GlobalObject::getOrCreateConstructor(cx, JSProto_DisplayNames);
  if (!ctor) {
    return false;
  }

  RootedValue ctorValue(cx, ObjectValue(*ctor));
  return DefineDataProperty(cx, intl, cx->names().DisplayNames, ctorValue, 0);
}

bool js::AddMozDisplayNamesConstructor(JSContext* cx, HandleObject intl) {
  RootedObject ctor(cx, GlobalObject::createConstructor(
                            cx, MozDisplayNames, cx->names().DisplayNames, 0));
  if (!ctor) {
    return false;
  }

  RootedObject proto(
      cx, GlobalObject::createBlankPrototype<PlainObject>(cx, cx->global()));
  if (!proto) {
    return false;
  }

  if (!LinkConstructorAndPrototype(cx, ctor, proto)) {
    return false;
  }

  if (!JS_DefineFunctions(cx, ctor, displayNames_static_methods)) {
    return false;
  }

  if (!JS_DefineFunctions(cx, proto, displayNames_methods)) {
    return false;
  }

  if (!JS_DefineProperties(cx, proto, displayNames_properties)) {
    return false;
  }

  RootedValue ctorValue(cx, ObjectValue(*ctor));
  return DefineDataProperty(cx, intl, cx->names().DisplayNames, ctorValue, 0);
}

enum class DisplayNamesStyle { Long, Short, Narrow };

static ULocaleDisplayNames* NewULocaleDisplayNames(
    JSContext* cx, const char* locale, DisplayNamesStyle displayStyle) {
  UErrorCode status = U_ZERO_ERROR;

  UDisplayContext contexts[] = {
      // Use the standard names, not the dialect names.
      // For example "English (GB)" instead of "British English".
      UDISPCTX_STANDARD_NAMES,

      // Assume the display names are used in a stand-alone context.
      UDISPCTX_CAPITALIZATION_FOR_STANDALONE,

      // Select either the long or short form. There's no separate narrow form
      // available in ICU, therefore we equate "narrow"/"short" styles here.
      displayStyle == DisplayNamesStyle::Long ? UDISPCTX_LENGTH_FULL
                                              : UDISPCTX_LENGTH_SHORT,

      // Don't apply substitutes, because we need to apply our own fallbacks.
      UDISPCTX_NO_SUBSTITUTE,
  };

  ULocaleDisplayNames* ldn = uldn_openForContext(
      IcuLocale(locale), contexts, mozilla::ArrayLength(contexts), &status);
  if (U_FAILURE(status)) {
    intl::ReportInternalError(cx);
    return nullptr;
  }
  return ldn;
}

static ULocaleDisplayNames* GetOrCreateLocaleDisplayNames(
    JSContext* cx, Handle<DisplayNamesObject*> displayNames, const char* locale,
    DisplayNamesStyle displayStyle) {
  // Obtain a cached ULocaleDisplayNames object.
  ULocaleDisplayNames* ldn = displayNames->getLocaleDisplayNames();
  if (!ldn) {
    ldn = NewULocaleDisplayNames(cx, locale, displayStyle);
    if (!ldn) {
      return nullptr;
    }
    displayNames->setLocaleDisplayNames(ldn);

    intl::AddICUCellMemory(displayNames,
                           DisplayNamesObject::EstimatedMemoryUse);
  }
  return ldn;
}

static void ReportInvalidOptionError(JSContext* cx, const char* type,
                                     HandleString option) {
  if (UniqueChars str = QuoteString(cx, option, '"')) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_INVALID_OPTION_VALUE, type, str.get());
  }
}

static void ReportInvalidOptionError(JSContext* cx, const char* type,
                                     double option) {
  ToCStringBuf cbuf;
  if (const char* str = NumberToCString(cx, &cbuf, option)) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_INVALID_DIGITS_VALUE, str);
  }
}

static JSString* GetLanguageDisplayName(
    JSContext* cx, Handle<DisplayNamesObject*> displayNames, const char* locale,
    DisplayNamesStyle displayStyle, HandleLinearString languageStr) {
  bool ok;
  intl::LanguageTag tag(cx);
  JS_TRY_VAR_OR_RETURN_NULL(
      cx, ok, intl::LanguageTagParser::tryParseBaseName(cx, languageStr, tag));
  if (!ok) {
    ReportInvalidOptionError(cx, "language", languageStr);
    return nullptr;
  }

  // ICU always canonicalizes the input locale, but since we know that ICU's
  // canonicalization is incomplete, we need to perform our own canonicalization
  // to ensure consistent result.
  // FIXME: spec issue - language tag canonicalisation not performed:
  // https://github.com/tc39/proposal-intl-displaynames/issues/70
  if (!tag.canonicalizeBaseName(cx)) {
    return nullptr;
  }

  UniqueChars languageChars = tag.toStringZ(cx);
  if (!languageChars) {
    return nullptr;
  }

  ULocaleDisplayNames* ldn =
      GetOrCreateLocaleDisplayNames(cx, displayNames, locale, displayStyle);
  if (!ldn) {
    return nullptr;
  }

  return CallICU(cx, [ldn, &languageChars](UChar* chars, uint32_t size,
                                           UErrorCode* status) {
    int32_t res =
        uldn_localeDisplayName(ldn, languageChars.get(), chars, size, status);

    // |uldn_localeDisplayName| reports U_ILLEGAL_ARGUMENT_ERROR when no
    // display name was found.
    if (*status == U_ILLEGAL_ARGUMENT_ERROR) {
      *status = U_ZERO_ERROR;
      res = 0;
    }
    return res;
  });
}

static JSString* GetScriptDisplayName(JSContext* cx,
                                      Handle<DisplayNamesObject*> displayNames,
                                      const char* locale,
                                      DisplayNamesStyle displayStyle,
                                      HandleLinearString scriptStr) {
  intl::ScriptSubtag script;
  if (!intl::ParseStandaloneScriptTag(scriptStr, script)) {
    ReportInvalidOptionError(cx, "script", scriptStr);
    return nullptr;
  }

  intl::LanguageTag tag(cx);
  tag.setLanguage("und");
  tag.setScript(script);

  // ICU always canonicalizes the input locale, but since we know that ICU's
  // canonicalization is incomplete, we need to perform our own canonicalization
  // to ensure consistent result.
  // FIXME: spec issue - language tag canonicalisation not performed:
  // https://github.com/tc39/proposal-intl-displaynames/issues/70
  if (!tag.canonicalizeBaseName(cx)) {
    return nullptr;
  }
  MOZ_ASSERT(tag.script().present());

  // |uldn_scriptDisplayName| doesn't use the stand-alone form for script
  // subtags, so we're using |uloc_getDisplayScript| instead. (This only applies
  // to the long form.)
  //
  // ICU bug: https://unicode-org.atlassian.net/browse/ICU-9301
  if (displayStyle == DisplayNamesStyle::Long) {
    // |uloc_getDisplayScript| expects a full locale identifier as its input.
    UniqueChars scriptChars = tag.toStringZ(cx);
    if (!scriptChars) {
      return nullptr;
    }

    return CallICU(cx, [locale, &scriptChars](UChar* chars, uint32_t size,
                                              UErrorCode* status) {
      int32_t res =
          uloc_getDisplayScript(scriptChars.get(), locale, chars, size, status);

      // |uloc_getDisplayScript| reports U_USING_DEFAULT_WARNING when no display
      // name was found.
      if (*status == U_USING_DEFAULT_WARNING) {
        *status = U_ZERO_ERROR;
        res = 0;
      }
      return res;
    });
  }

  // Note: ICU requires the script subtag to be in canonical case.
  const intl::ScriptSubtag& canonicalScript = tag.script();

  char scriptChars[intl::LanguageTagLimits::ScriptLength + 1];
  std::copy_n(canonicalScript.span().data(), canonicalScript.length(),
              scriptChars);
  scriptChars[canonicalScript.length()] = '\0';

  ULocaleDisplayNames* ldn =
      GetOrCreateLocaleDisplayNames(cx, displayNames, locale, displayStyle);
  if (!ldn) {
    return nullptr;
  }

  return CallICU(cx, [ldn, scriptChars](UChar* chars, uint32_t size,
                                        UErrorCode* status) {
    int32_t res = uldn_scriptDisplayName(ldn, scriptChars, chars, size, status);

    // |uldn_scriptDisplayName| reports U_ILLEGAL_ARGUMENT_ERROR when no display
    // name was found.
    if (*status == U_ILLEGAL_ARGUMENT_ERROR) {
      *status = U_ZERO_ERROR;
      res = 0;
    }
    return res;
  });
}

static JSString* GetRegionDisplayName(JSContext* cx,
                                      Handle<DisplayNamesObject*> displayNames,
                                      const char* locale,
                                      DisplayNamesStyle displayStyle,
                                      HandleLinearString regionStr) {
  intl::RegionSubtag region;
  if (!intl::ParseStandaloneRegionTag(regionStr, region)) {
    ReportInvalidOptionError(cx, "region", regionStr);
    return nullptr;
  }

  intl::LanguageTag tag(cx);
  tag.setLanguage("und");
  tag.setRegion(region);

  // ICU always canonicalizes the input locale, but since we know that ICU's
  // canonicalization is incomplete, we need to perform our own canonicalization
  // to ensure consistent result.
  // FIXME: spec issue - language tag canonicalisation not performed:
  // https://github.com/tc39/proposal-intl-displaynames/issues/70
  if (!tag.canonicalizeBaseName(cx)) {
    return nullptr;
  }
  MOZ_ASSERT(tag.region().present());

  // Note: ICU requires the region subtag to be in canonical case.
  const intl::RegionSubtag& canonicalRegion = tag.region();

  char regionChars[intl::LanguageTagLimits::RegionLength + 1];
  std::copy_n(canonicalRegion.span().data(), canonicalRegion.length(),
              regionChars);
  regionChars[canonicalRegion.length()] = '\0';

  ULocaleDisplayNames* ldn =
      GetOrCreateLocaleDisplayNames(cx, displayNames, locale, displayStyle);
  if (!ldn) {
    return nullptr;
  }

  return CallICU(cx, [ldn, regionChars](UChar* chars, uint32_t size,
                                        UErrorCode* status) {
    int32_t res = uldn_regionDisplayName(ldn, regionChars, chars, size, status);

    // |uldn_regionDisplayName| reports U_ILLEGAL_ARGUMENT_ERROR when no display
    // name was found.
    if (*status == U_ILLEGAL_ARGUMENT_ERROR) {
      *status = U_ZERO_ERROR;
      res = 0;
    }
    return res;
  });
}

static JSString* GetCurrencyDisplayName(JSContext* cx, const char* locale,
                                        DisplayNamesStyle displayStyle,
                                        HandleLinearString currencyStr) {
  // Inlined implementation of `IsWellFormedCurrencyCode ( currency )`.
  if (currencyStr->length() != 3) {
    ReportInvalidOptionError(cx, "currency", currencyStr);
    return nullptr;
  }

  char16_t currency[] = {currencyStr->latin1OrTwoByteChar(0),
                         currencyStr->latin1OrTwoByteChar(1),
                         currencyStr->latin1OrTwoByteChar(2), '\0'};

  if (!mozilla::IsAsciiAlpha(currency[0]) ||
      !mozilla::IsAsciiAlpha(currency[1]) ||
      !mozilla::IsAsciiAlpha(currency[2])) {
    ReportInvalidOptionError(cx, "currency", currencyStr);
    return nullptr;
  }

  UCurrNameStyle currencyStyle;
  switch (displayStyle) {
    case DisplayNamesStyle::Long:
      currencyStyle = UCURR_LONG_NAME;
      break;
    case DisplayNamesStyle::Short:
      currencyStyle = UCURR_SYMBOL_NAME;
      break;
    case DisplayNamesStyle::Narrow:
      currencyStyle = UCURR_NARROW_SYMBOL_NAME;
      break;
  }

  int32_t length = 0;
  UErrorCode status = U_ZERO_ERROR;
  const char16_t* name =
      ucurr_getName(currency, locale, currencyStyle, nullptr, &length, &status);
  if (U_FAILURE(status)) {
    intl::ReportInternalError(cx);
    return nullptr;
  }
  MOZ_ASSERT(length >= 0);

  if (status == U_USING_DEFAULT_WARNING) {
    return cx->emptyString();
  }

  return NewStringCopyN<CanGC>(cx, name, size_t(length));
}

static ListObject* GetDateTimeDisplayNames(
    JSContext* cx, Handle<DisplayNamesObject*> displayNames, const char* locale,
    HandleLinearString calendar, UDateFormatSymbolType symbolType,
    mozilla::Span<const int32_t> indices) {
  if (auto* names = displayNames->getDateTimeNames()) {
    return names;
  }

  intl::LanguageTag tag(cx);
  if (!intl::LanguageTagParser::parse(cx, mozilla::MakeStringSpan(locale),
                                      tag)) {
    return nullptr;
  }

  JS::RootedVector<intl::UnicodeExtensionKeyword> keywords(cx);
  if (!keywords.emplaceBack("ca", calendar)) {
    return nullptr;
  }

  if (!intl::ApplyUnicodeExtensionToTag(cx, tag, keywords)) {
    return nullptr;
  }

  UniqueChars localeWithCalendar = tag.toStringZ(cx);
  if (!localeWithCalendar) {
    return nullptr;
  }

  constexpr char16_t* timeZone = nullptr;
  constexpr int32_t timeZoneLength = 0;

  constexpr char16_t* pattern = nullptr;
  constexpr int32_t patternLength = 0;

  UErrorCode status = U_ZERO_ERROR;
  UDateFormat* fmt =
      udat_open(UDAT_DEFAULT, UDAT_DEFAULT, IcuLocale(localeWithCalendar.get()),
                timeZone, timeZoneLength, pattern, patternLength, &status);
  if (U_FAILURE(status)) {
    intl::ReportInternalError(cx);
    return nullptr;
  }
  ScopedICUObject<UDateFormat, udat_close> datToClose(fmt);

  Rooted<ListObject*> names(cx, ListObject::create(cx));
  if (!names) {
    return nullptr;
  }

  RootedValue value(cx);
  for (uint32_t i = 0; i < indices.size(); i++) {
    uint32_t index = indices[i];
    JSString* name =
        CallICU(cx, [fmt, symbolType, index](UChar* chars, int32_t size,
                                             UErrorCode* status) {
          return udat_getSymbols(fmt, symbolType, index, chars, size, status);
        });
    if (!name) {
      return nullptr;
    }

    value.setString(name);
    if (!names->append(cx, value)) {
      return nullptr;
    }
  }

  displayNames->setDateTimeNames(names);
  return names;
}

static JSString* GetWeekdayDisplayName(JSContext* cx,
                                       Handle<DisplayNamesObject*> displayNames,
                                       const char* locale,
                                       HandleLinearString calendar,
                                       DisplayNamesStyle displayStyle,
                                       HandleLinearString code) {
  double weekday;
  if (!StringToNumber(cx, code, &weekday)) {
    return nullptr;
  }

  // Inlined implementation of `IsValidWeekdayCode ( weekday )`.
  if (!IsInteger(weekday) || weekday < 1 || weekday > 7) {
    ReportInvalidOptionError(cx, "weekday", weekday);
    return nullptr;
  }

  UDateFormatSymbolType symbolType;
  switch (displayStyle) {
    case DisplayNamesStyle::Long:
      symbolType = UDAT_STANDALONE_WEEKDAYS;
      break;

    case DisplayNamesStyle::Short:
      // ICU "short" is CLDR "abbreviated"; "shorter" is CLDR "short" format.
      symbolType = UDAT_STANDALONE_SHORTER_WEEKDAYS;
      break;

    case DisplayNamesStyle::Narrow:
      symbolType = UDAT_STANDALONE_NARROW_WEEKDAYS;
      break;
  }

  static constexpr int32_t indices[] = {
      UCAL_MONDAY, UCAL_TUESDAY,  UCAL_WEDNESDAY, UCAL_THURSDAY,
      UCAL_FRIDAY, UCAL_SATURDAY, UCAL_SUNDAY};

  ListObject* names =
      GetDateTimeDisplayNames(cx, displayNames, locale, calendar, symbolType,
                              mozilla::MakeSpan(indices));
  if (!names) {
    return nullptr;
  }
  MOZ_ASSERT(names->length() == mozilla::ArrayLength(indices));

  return names->get(int32_t(weekday) - 1).toString();
}

static JSString* GetMonthDisplayName(JSContext* cx,
                                     Handle<DisplayNamesObject*> displayNames,
                                     const char* locale,
                                     HandleLinearString calendar,
                                     DisplayNamesStyle displayStyle,
                                     HandleLinearString code) {
  double month;
  if (!StringToNumber(cx, code, &month)) {
    return nullptr;
  }

  // Inlined implementation of `IsValidMonthCode ( month )`.
  if (!IsInteger(month) || month < 1 || month > 13) {
    ReportInvalidOptionError(cx, "month", month);
    return nullptr;
  }

  UDateFormatSymbolType symbolType;
  switch (displayStyle) {
    case DisplayNamesStyle::Long:
      symbolType = UDAT_STANDALONE_MONTHS;
      break;

    case DisplayNamesStyle::Short:
      symbolType = UDAT_STANDALONE_SHORT_MONTHS;
      break;

    case DisplayNamesStyle::Narrow:
      symbolType = UDAT_STANDALONE_NARROW_MONTHS;
      break;
  }

  static constexpr int32_t indices[] = {
      UCAL_JANUARY,   UCAL_FEBRUARY, UCAL_MARCH,    UCAL_APRIL,
      UCAL_MAY,       UCAL_JUNE,     UCAL_JULY,     UCAL_AUGUST,
      UCAL_SEPTEMBER, UCAL_OCTOBER,  UCAL_NOVEMBER, UCAL_DECEMBER,
      UCAL_UNDECIMBER};

  ListObject* names =
      GetDateTimeDisplayNames(cx, displayNames, locale, calendar, symbolType,
                              mozilla::MakeSpan(indices));
  if (!names) {
    return nullptr;
  }
  MOZ_ASSERT(names->length() == mozilla::ArrayLength(indices));

  return names->get(int32_t(month) - 1).toString();
}

static JSString* GetQuarterDisplayName(JSContext* cx,
                                       Handle<DisplayNamesObject*> displayNames,
                                       const char* locale,
                                       HandleLinearString calendar,
                                       DisplayNamesStyle displayStyle,
                                       HandleLinearString code) {
  double quarter;
  if (!StringToNumber(cx, code, &quarter)) {
    return nullptr;
  }

  // Inlined implementation of `IsValidQuarterCode ( quarter )`.
  if (!IsInteger(quarter) || quarter < 1 || quarter > 4) {
    ReportInvalidOptionError(cx, "quarter", quarter);
    return nullptr;
  }

  UDateFormatSymbolType symbolType;
  switch (displayStyle) {
    case DisplayNamesStyle::Long:
      symbolType = UDAT_STANDALONE_QUARTERS;
      break;

    case DisplayNamesStyle::Short:
    case DisplayNamesStyle::Narrow:
      // CLDR "narrow" style not supported in ICU.
      symbolType = UDAT_STANDALONE_SHORT_QUARTERS;
      break;
  }

  // ICU doesn't provide an enum for quarters.
  static constexpr int32_t indices[] = {0, 1, 2, 3};

  ListObject* names =
      GetDateTimeDisplayNames(cx, displayNames, locale, calendar, symbolType,
                              mozilla::MakeSpan(indices));
  if (!names) {
    return nullptr;
  }
  MOZ_ASSERT(names->length() == mozilla::ArrayLength(indices));

  return names->get(int32_t(quarter) - 1).toString();
}

static JSString* GetDayPeriodDisplayName(
    JSContext* cx, Handle<DisplayNamesObject*> displayNames, const char* locale,
    HandleLinearString calendar, HandleLinearString dayPeriod) {
  // Inlined implementation of `IsValidDayPeriodCode ( dayperiod )`.
  uint32_t index;
  if (StringEqualsLiteral(dayPeriod, "am")) {
    index = 0;
  } else if (StringEqualsLiteral(dayPeriod, "pm")) {
    index = 1;
  } else {
    ReportInvalidOptionError(cx, "dayPeriod", dayPeriod);
    return nullptr;
  }

  UDateFormatSymbolType symbolType = UDAT_AM_PMS;

  static constexpr int32_t indices[] = {UCAL_AM, UCAL_PM};

  ListObject* names =
      GetDateTimeDisplayNames(cx, displayNames, locale, calendar, symbolType,
                              mozilla::MakeSpan(indices));
  if (!names) {
    return nullptr;
  }
  MOZ_ASSERT(names->length() == mozilla::ArrayLength(indices));

  return names->get(index).toString();
}

static JSString* GetDateTimeFieldDisplayName(JSContext* cx, const char* locale,
                                             DisplayNamesStyle displayStyle,
                                             HandleLinearString dateTimeField) {
  // Inlined implementation of `IsValidDateTimeFieldCode ( field )`.
  UDateTimePatternField field;
  if (StringEqualsLiteral(dateTimeField, "era")) {
    field = UDATPG_ERA_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "year")) {
    field = UDATPG_YEAR_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "quarter")) {
    field = UDATPG_QUARTER_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "month")) {
    field = UDATPG_MONTH_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "weekOfYear")) {
    field = UDATPG_WEEK_OF_YEAR_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "weekday")) {
    field = UDATPG_WEEKDAY_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "day")) {
    field = UDATPG_DAY_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "dayPeriod")) {
    field = UDATPG_DAYPERIOD_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "hour")) {
    field = UDATPG_HOUR_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "minute")) {
    field = UDATPG_MINUTE_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "second")) {
    field = UDATPG_SECOND_FIELD;
  } else if (StringEqualsLiteral(dateTimeField, "timeZoneName")) {
    field = UDATPG_ZONE_FIELD;
  } else {
    ReportInvalidOptionError(cx, "dateTimeField", dateTimeField);
    return nullptr;
  }

  UDateTimePGDisplayWidth width;
  switch (displayStyle) {
    case DisplayNamesStyle::Long:
      width = UDATPG_WIDE;
      break;
    case DisplayNamesStyle::Short:
      width = UDATPG_ABBREVIATED;
      break;
    case DisplayNamesStyle::Narrow:
      width = UDATPG_NARROW;
      break;
  }

  intl::SharedIntlData& sharedIntlData = cx->runtime()->sharedIntlData.ref();
  UDateTimePatternGenerator* dtpg =
      sharedIntlData.getDateTimePatternGenerator(cx, locale);
  if (!dtpg) {
    return nullptr;
  }

  return intl::CallICU(cx, [dtpg, field, width](UChar* chars, uint32_t size,
                                                UErrorCode* status) {
    return udatpg_getFieldDisplayName(dtpg, field, width, chars, size, status);
  });
}

/**
 * intl_ComputeDisplayName(displayNames, locale, calendar, style, type, code)
 */
bool js::intl_ComputeDisplayName(JSContext* cx, unsigned argc, Value* vp) {
  CallArgs args = CallArgsFromVp(argc, vp);
  MOZ_ASSERT(args.length() == 6);

  Rooted<DisplayNamesObject*> displayNames(
      cx, &args[0].toObject().as<DisplayNamesObject>());

  UniqueChars locale = intl::EncodeLocale(cx, args[1].toString());
  if (!locale) {
    return false;
  }

  RootedLinearString calendar(cx, args[2].toString()->ensureLinear(cx));
  if (!calendar) {
    return false;
  }

  RootedLinearString code(cx, args[5].toString()->ensureLinear(cx));
  if (!code) {
    return false;
  }

  DisplayNamesStyle displayStyle;
  {
    JSLinearString* style = args[3].toString()->ensureLinear(cx);
    if (!style) {
      return false;
    }

    if (StringEqualsLiteral(style, "long")) {
      displayStyle = DisplayNamesStyle::Long;
    } else if (StringEqualsLiteral(style, "short")) {
      displayStyle = DisplayNamesStyle::Short;
    } else {
      MOZ_ASSERT(StringEqualsLiteral(style, "narrow"));
      displayStyle = DisplayNamesStyle::Narrow;
    }
  }

  JSLinearString* type = args[4].toString()->ensureLinear(cx);
  if (!type) {
    return false;
  }

  JSString* result;
  if (StringEqualsLiteral(type, "language")) {
    result = GetLanguageDisplayName(cx, displayNames, locale.get(),
                                    displayStyle, code);
  } else if (StringEqualsLiteral(type, "script")) {
    result = GetScriptDisplayName(cx, displayNames, locale.get(), displayStyle,
                                  code);
  } else if (StringEqualsLiteral(type, "region")) {
    result = GetRegionDisplayName(cx, displayNames, locale.get(), displayStyle,
                                  code);
  } else if (StringEqualsLiteral(type, "currency")) {
    result = GetCurrencyDisplayName(cx, locale.get(), displayStyle, code);
  } else if (StringEqualsLiteral(type, "weekday")) {
    result = GetWeekdayDisplayName(cx, displayNames, locale.get(), calendar,
                                   displayStyle, code);
  } else if (StringEqualsLiteral(type, "month")) {
    result = GetMonthDisplayName(cx, displayNames, locale.get(), calendar,
                                 displayStyle, code);
  } else if (StringEqualsLiteral(type, "quarter")) {
    result = GetQuarterDisplayName(cx, displayNames, locale.get(), calendar,
                                   displayStyle, code);
  } else if (StringEqualsLiteral(type, "dayPeriod")) {
    result =
        GetDayPeriodDisplayName(cx, displayNames, locale.get(), calendar, code);
  } else {
    MOZ_ASSERT(StringEqualsLiteral(type, "dateTimeField"));
    result = GetDateTimeFieldDisplayName(cx, locale.get(), displayStyle, code);
  }
  if (!result) {
    return false;
  }

  args.rval().setString(result);
  return true;
}
