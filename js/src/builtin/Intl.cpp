/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * The Intl module specified by standard ECMA-402,
 * ECMAScript Internationalization API Specification.
 */

#include "builtin/Intl.h"

#include "mozilla/Casting.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/PodOperations.h"
#include "mozilla/Range.h"

#include <string.h>

#include "jsapi.h"
#include "jsatom.h"
#include "jscntxt.h"
#include "jsfriendapi.h"
#include "jsobj.h"
#include "jsstr.h"
#include "jsutil.h"

#include "builtin/IntlTimeZoneData.h"
#include "ds/Sort.h"
#if ENABLE_INTL_API
#include "unicode/plurrule.h"
#include "unicode/ucal.h"
#include "unicode/ucol.h"
#include "unicode/udat.h"
#include "unicode/udatpg.h"
#include "unicode/uenum.h"
#include "unicode/uloc.h"
#include "unicode/unum.h"
#include "unicode/unumsys.h"
#include "unicode/upluralrules.h"
#include "unicode/ustring.h"
#endif
#include "vm/DateTime.h"
#include "vm/GlobalObject.h"
#include "vm/Interpreter.h"
#include "vm/SelfHosting.h"
#include "vm/Stack.h"
#include "vm/String.h"
#include "vm/StringBuffer.h"
#include "vm/Unicode.h"

#include "jsobjinlines.h"

#include "vm/NativeObject-inl.h"

using namespace js;

using mozilla::AssertedCast;
using mozilla::IsFinite;
using mozilla::IsNaN;
using mozilla::IsNegativeZero;
using mozilla::PodCopy;
using mozilla::Range;
using mozilla::RangedPtr;

/*
 * Pervasive note: ICU functions taking a UErrorCode in/out parameter always
 * test that parameter before doing anything, and will return immediately if
 * the value indicates that a failure occurred in a prior ICU call,
 * without doing anything else. See
 * http://userguide.icu-project.org/design#TOC-Error-Handling
 */


/******************** ICU stubs ********************/

#if !ENABLE_INTL_API

/*
 * When the Internationalization API isn't enabled, we also shouldn't link
 * against ICU. However, we still want to compile this code in order to prevent
 * bit rot. The following stub implementations for ICU functions make this
 * possible. The functions using them should never be called, so they assert
 * and return error codes. Signatures adapted from ICU header files locid.h,
 * numsys.h, ucal.h, ucol.h, udat.h, udatpg.h, uenum.h, unum.h, uloc.h;
 * see the ICU directory for license.
 */

namespace {

enum UErrorCode {
    U_ZERO_ERROR,
    U_BUFFER_OVERFLOW_ERROR,
};

}

namespace icu {

class StringEnumeration {
    public:
        explicit StringEnumeration();
};

StringEnumeration::StringEnumeration()
{
    MOZ_CRASH("StringEnumeration::StringEnumeration: Intl API disabled");
}

class PluralRules {
public:

    StringEnumeration* getKeywords(UErrorCode& status) const;

};

StringEnumeration*
PluralRules::getKeywords(UErrorCode& status) const
{
    MOZ_CRASH("PluralRules::getKeywords: Intl API disabled");
}

} // icu namespace

namespace {

typedef bool UBool;
typedef char16_t UChar;
typedef double UDate;

inline UBool
U_FAILURE(UErrorCode code)
{
    MOZ_CRASH("U_FAILURE: Intl API disabled");
}

inline const UChar*
Char16ToUChar(const char16_t* chars)
{
    MOZ_CRASH("Char16ToUChar: Intl API disabled");
}

inline UChar*
Char16ToUChar(char16_t* chars)
{
    MOZ_CRASH("Char16ToUChar: Intl API disabled");
}

inline char16_t*
UCharToChar16(UChar* chars)
{
    MOZ_CRASH("UCharToChar16: Intl API disabled");
}

inline const char16_t*
UCharToChar16(const UChar* chars)
{
    MOZ_CRASH("UCharToChar16: Intl API disabled");
}

const char*
uloc_getAvailable(int32_t n)
{
    MOZ_CRASH("uloc_getAvailable: Intl API disabled");
}

int32_t
uloc_countAvailable()
{
    MOZ_CRASH("uloc_countAvailable: Intl API disabled");
}

UBool
uloc_isRightToLeft(const char* locale)
{
    MOZ_CRASH("uloc_isRightToLeft: Intl API disabled");
}

struct UFormattable;

void
ufmt_close(UFormattable* fmt)
{
    MOZ_CRASH("ufmt_close: Intl API disabled");
}

double
ufmt_getDouble(UFormattable* fmt, UErrorCode *status)
{
    MOZ_CRASH("ufmt_getDouble: Intl API disabled");
}

struct UEnumeration;

int32_t
uenum_count(UEnumeration* en, UErrorCode* status)
{
    MOZ_CRASH("uenum_count: Intl API disabled");
}

const char*
uenum_next(UEnumeration* en, int32_t* resultLength, UErrorCode* status)
{
    MOZ_CRASH("uenum_next: Intl API disabled");
}

void
uenum_close(UEnumeration* en)
{
    MOZ_CRASH("uenum_close: Intl API disabled");
}

UEnumeration*
uenum_openFromStringEnumeration(icu::StringEnumeration* adopted, UErrorCode* ec)
{
    MOZ_CRASH("uenum_openFromStringEnumeration: Intl API disabled");
}

struct UCollator;

enum UColAttribute {
    UCOL_ALTERNATE_HANDLING,
    UCOL_CASE_FIRST,
    UCOL_CASE_LEVEL,
    UCOL_NORMALIZATION_MODE,
    UCOL_STRENGTH,
    UCOL_NUMERIC_COLLATION,
};

enum UColAttributeValue {
    UCOL_DEFAULT = -1,
    UCOL_PRIMARY = 0,
    UCOL_SECONDARY = 1,
    UCOL_TERTIARY = 2,
    UCOL_OFF = 16,
    UCOL_ON = 17,
    UCOL_SHIFTED = 20,
    UCOL_LOWER_FIRST = 24,
    UCOL_UPPER_FIRST = 25,
};

enum UCollationResult {
    UCOL_EQUAL = 0,
    UCOL_GREATER = 1,
    UCOL_LESS = -1
};

int32_t
ucol_countAvailable()
{
    MOZ_CRASH("ucol_countAvailable: Intl API disabled");
}

const char*
ucol_getAvailable(int32_t localeIndex)
{
    MOZ_CRASH("ucol_getAvailable: Intl API disabled");
}

UEnumeration*
ucol_openAvailableLocales(UErrorCode* status)
{
    MOZ_CRASH("ucol_openAvailableLocales: Intl API disabled");
}

UCollator*
ucol_open(const char* loc, UErrorCode* status)
{
    MOZ_CRASH("ucol_open: Intl API disabled");
}

UColAttributeValue
ucol_getAttribute(const UCollator* coll, UColAttribute attr, UErrorCode* status)
{
    MOZ_CRASH("ucol_getAttribute: Intl API disabled");
}

void
ucol_setAttribute(UCollator* coll, UColAttribute attr, UColAttributeValue value, UErrorCode* status)
{
    MOZ_CRASH("ucol_setAttribute: Intl API disabled");
}

UCollationResult
ucol_strcoll(const UCollator* coll, const UChar* source, int32_t sourceLength,
             const UChar* target, int32_t targetLength)
{
    MOZ_CRASH("ucol_strcoll: Intl API disabled");
}

void
ucol_close(UCollator* coll)
{
    MOZ_CRASH("ucol_close: Intl API disabled");
}

UEnumeration*
ucol_getKeywordValuesForLocale(const char* key, const char* locale, UBool commonlyUsed,
                               UErrorCode* status)
{
    MOZ_CRASH("ucol_getKeywordValuesForLocale: Intl API disabled");
}

struct UParseError;
struct UFieldPosition;
struct UFieldPositionIterator;
typedef void* UNumberFormat;

enum UNumberFormatStyle {
    UNUM_DECIMAL = 1,
    UNUM_CURRENCY,
    UNUM_PERCENT,
    UNUM_CURRENCY_ISO,
    UNUM_CURRENCY_PLURAL,
};

enum UNumberFormatRoundingMode {
    UNUM_ROUND_HALFUP,
};

enum UNumberFormatAttribute {
    UNUM_GROUPING_USED,
    UNUM_MIN_INTEGER_DIGITS,
    UNUM_MAX_FRACTION_DIGITS,
    UNUM_MIN_FRACTION_DIGITS,
    UNUM_ROUNDING_MODE,
    UNUM_SIGNIFICANT_DIGITS_USED,
    UNUM_MIN_SIGNIFICANT_DIGITS,
    UNUM_MAX_SIGNIFICANT_DIGITS,
};

enum UNumberFormatTextAttribute {
    UNUM_CURRENCY_CODE,
};

int32_t
unum_countAvailable()
{
    MOZ_CRASH("unum_countAvailable: Intl API disabled");
}

const char*
unum_getAvailable(int32_t localeIndex)
{
    MOZ_CRASH("unum_getAvailable: Intl API disabled");
}

UNumberFormat*
unum_open(UNumberFormatStyle style, const UChar* pattern, int32_t patternLength,
          const char* locale, UParseError* parseErr, UErrorCode* status)
{
    MOZ_CRASH("unum_open: Intl API disabled");
}

void
unum_setAttribute(UNumberFormat* fmt, UNumberFormatAttribute  attr, int32_t newValue)
{
    MOZ_CRASH("unum_setAttribute: Intl API disabled");
}

#if defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)

int32_t
unum_formatDoubleForFields(const UNumberFormat* fmt, double number, UChar* result,
                           int32_t resultLength, UFieldPositionIterator* fpositer,
                           UErrorCode* status)
{
    MOZ_CRASH("unum_formatDoubleForFields: Intl API disabled");
}

enum UNumberFormatFields {
    UNUM_INTEGER_FIELD,
    UNUM_GROUPING_SEPARATOR_FIELD,
    UNUM_DECIMAL_SEPARATOR_FIELD,
    UNUM_FRACTION_FIELD,
    UNUM_SIGN_FIELD,
    UNUM_PERCENT_FIELD,
    UNUM_CURRENCY_FIELD,
    UNUM_PERMILL_FIELD,
    UNUM_EXPONENT_SYMBOL_FIELD,
    UNUM_EXPONENT_SIGN_FIELD,
    UNUM_EXPONENT_FIELD,
    UNUM_FIELD_COUNT,
};

#else

int32_t
unum_formatDouble(const UNumberFormat* fmt, double number, UChar* result,
                  int32_t resultLength, UFieldPosition* pos, UErrorCode* status)
{
    MOZ_CRASH("unum_formatDouble: Intl API disabled");
}

#endif // defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)

void
unum_close(UNumberFormat* fmt)
{
    MOZ_CRASH("unum_close: Intl API disabled");
}

void
unum_setTextAttribute(UNumberFormat* fmt, UNumberFormatTextAttribute tag, const UChar* newValue,
                      int32_t newValueLength, UErrorCode* status)
{
    MOZ_CRASH("unum_setTextAttribute: Intl API disabled");
}

UFormattable*
unum_parseToUFormattable(const UNumberFormat* fmt,
                         UFormattable *result,
                         const UChar* text,
                         int32_t textLength,
                         int32_t* parsePos, /* 0 = start */
                         UErrorCode* status)
{
    MOZ_CRASH("unum_parseToUFormattable: Intl API disabled");
}

typedef void* UNumberingSystem;

UNumberingSystem*
unumsys_open(const char* locale, UErrorCode* status)
{
    MOZ_CRASH("unumsys_open: Intl API disabled");
}

const char*
unumsys_getName(const UNumberingSystem* unumsys)
{
    MOZ_CRASH("unumsys_getName: Intl API disabled");
}

void
unumsys_close(UNumberingSystem* unumsys)
{
    MOZ_CRASH("unumsys_close: Intl API disabled");
}

typedef void* UCalendar;

enum UCalendarType {
    UCAL_TRADITIONAL,
    UCAL_DEFAULT = UCAL_TRADITIONAL,
    UCAL_GREGORIAN
};

enum UCalendarAttribute {
    UCAL_FIRST_DAY_OF_WEEK,
    UCAL_MINIMAL_DAYS_IN_FIRST_WEEK
};

enum UCalendarDaysOfWeek {
    UCAL_SUNDAY,
    UCAL_MONDAY,
    UCAL_TUESDAY,
    UCAL_WEDNESDAY,
    UCAL_THURSDAY,
    UCAL_FRIDAY,
    UCAL_SATURDAY
};

enum UCalendarWeekdayType {
    UCAL_WEEKDAY,
    UCAL_WEEKEND,
    UCAL_WEEKEND_ONSET,
    UCAL_WEEKEND_CEASE
};

enum UCalendarDateFields {
    UCAL_ERA,
    UCAL_YEAR,
    UCAL_MONTH,
    UCAL_WEEK_OF_YEAR,
    UCAL_WEEK_OF_MONTH,
    UCAL_DATE,
    UCAL_DAY_OF_YEAR,
    UCAL_DAY_OF_WEEK,
    UCAL_DAY_OF_WEEK_IN_MONTH,
    UCAL_AM_PM,
    UCAL_HOUR,
    UCAL_HOUR_OF_DAY,
    UCAL_MINUTE,
    UCAL_SECOND,
    UCAL_MILLISECOND,
    UCAL_ZONE_OFFSET,
    UCAL_DST_OFFSET,
    UCAL_YEAR_WOY,
    UCAL_DOW_LOCAL,
    UCAL_EXTENDED_YEAR,
    UCAL_JULIAN_DAY,
    UCAL_MILLISECONDS_IN_DAY,
    UCAL_IS_LEAP_MONTH,
    UCAL_FIELD_COUNT,
    UCAL_DAY_OF_MONTH = UCAL_DATE
};

enum UCalendarMonths {
  UCAL_JANUARY,
  UCAL_FEBRUARY,
  UCAL_MARCH,
  UCAL_APRIL,
  UCAL_MAY,
  UCAL_JUNE,
  UCAL_JULY,
  UCAL_AUGUST,
  UCAL_SEPTEMBER,
  UCAL_OCTOBER,
  UCAL_NOVEMBER,
  UCAL_DECEMBER,
  UCAL_UNDECIMBER
};

enum UCalendarAMPMs {
  UCAL_AM,
  UCAL_PM
};

UCalendar*
ucal_open(const UChar* zoneID, int32_t len, const char* locale,
          UCalendarType type, UErrorCode* status)
{
    MOZ_CRASH("ucal_open: Intl API disabled");
}

const char*
ucal_getType(const UCalendar* cal, UErrorCode* status)
{
    MOZ_CRASH("ucal_getType: Intl API disabled");
}

UEnumeration*
ucal_getKeywordValuesForLocale(const char* key, const char* locale,
                               UBool commonlyUsed, UErrorCode* status)
{
    MOZ_CRASH("ucal_getKeywordValuesForLocale: Intl API disabled");
}

void
ucal_close(UCalendar* cal)
{
    MOZ_CRASH("ucal_close: Intl API disabled");
}

UCalendarWeekdayType
ucal_getDayOfWeekType(const UCalendar *cal, UCalendarDaysOfWeek dayOfWeek, UErrorCode* status)
{
    MOZ_CRASH("ucal_getDayOfWeekType: Intl API disabled");
}

int32_t
ucal_getAttribute(const UCalendar*    cal,
                  UCalendarAttribute  attr)
{
    MOZ_CRASH("ucal_getAttribute: Intl API disabled");
}

int32_t
ucal_get(const UCalendar *cal, UCalendarDateFields field, UErrorCode *status)
{
    MOZ_CRASH("ucal_get: Intl API disabled");
}

UEnumeration*
ucal_openTimeZones(UErrorCode* status)
{
    MOZ_CRASH("ucal_openTimeZones: Intl API disabled");
}

int32_t
ucal_getCanonicalTimeZoneID(const UChar* id, int32_t len, UChar* result, int32_t resultCapacity,
                            UBool* isSystemID, UErrorCode* status)
{
    MOZ_CRASH("ucal_getCanonicalTimeZoneID: Intl API disabled");
}

int32_t
ucal_getDefaultTimeZone(UChar* result, int32_t resultCapacity, UErrorCode* status)
{
    MOZ_CRASH("ucal_getDefaultTimeZone: Intl API disabled");
}

enum UDateTimePatternField {
    UDATPG_YEAR_FIELD,
    UDATPG_MONTH_FIELD,
    UDATPG_WEEK_OF_YEAR_FIELD,
    UDATPG_DAY_FIELD,
};

typedef void* UDateTimePatternGenerator;

UDateTimePatternGenerator*
udatpg_open(const char* locale, UErrorCode* pErrorCode)
{
    MOZ_CRASH("udatpg_open: Intl API disabled");
}

int32_t
udatpg_getBestPattern(UDateTimePatternGenerator* dtpg, const UChar* skeleton,
                      int32_t length, UChar* bestPattern, int32_t capacity,
                      UErrorCode* pErrorCode)
{
    MOZ_CRASH("udatpg_getBestPattern: Intl API disabled");
}

static const UChar *
udatpg_getAppendItemName(const UDateTimePatternGenerator *dtpg,
                         UDateTimePatternField field,
                         int32_t *pLength)
{
    MOZ_CRASH("udatpg_getAppendItemName: Intl API disabled");
}

void
udatpg_close(UDateTimePatternGenerator* dtpg)
{
    MOZ_CRASH("udatpg_close: Intl API disabled");
}

typedef void* UCalendar;
typedef void* UDateFormat;

enum UDateFormatField {
    UDAT_ERA_FIELD = 0,
    UDAT_YEAR_FIELD = 1,
    UDAT_MONTH_FIELD = 2,
    UDAT_DATE_FIELD = 3,
    UDAT_HOUR_OF_DAY1_FIELD = 4,
    UDAT_HOUR_OF_DAY0_FIELD = 5,
    UDAT_MINUTE_FIELD = 6,
    UDAT_SECOND_FIELD = 7,
    UDAT_FRACTIONAL_SECOND_FIELD = 8,
    UDAT_DAY_OF_WEEK_FIELD = 9,
    UDAT_DAY_OF_YEAR_FIELD = 10,
    UDAT_DAY_OF_WEEK_IN_MONTH_FIELD = 11,
    UDAT_WEEK_OF_YEAR_FIELD = 12,
    UDAT_WEEK_OF_MONTH_FIELD = 13,
    UDAT_AM_PM_FIELD = 14,
    UDAT_HOUR1_FIELD = 15,
    UDAT_HOUR0_FIELD = 16,
    UDAT_TIMEZONE_FIELD = 17,
    UDAT_YEAR_WOY_FIELD = 18,
    UDAT_DOW_LOCAL_FIELD = 19,
    UDAT_EXTENDED_YEAR_FIELD = 20,
    UDAT_JULIAN_DAY_FIELD = 21,
    UDAT_MILLISECONDS_IN_DAY_FIELD = 22,
    UDAT_TIMEZONE_RFC_FIELD = 23,
    UDAT_TIMEZONE_GENERIC_FIELD = 24,
    UDAT_STANDALONE_DAY_FIELD = 25,
    UDAT_STANDALONE_MONTH_FIELD = 26,
    UDAT_QUARTER_FIELD = 27,
    UDAT_STANDALONE_QUARTER_FIELD = 28,
    UDAT_TIMEZONE_SPECIAL_FIELD = 29,
    UDAT_YEAR_NAME_FIELD = 30,
    UDAT_TIMEZONE_LOCALIZED_GMT_OFFSET_FIELD = 31,
    UDAT_TIMEZONE_ISO_FIELD = 32,
    UDAT_TIMEZONE_ISO_LOCAL_FIELD = 33,
    UDAT_RELATED_YEAR_FIELD = 34,
    UDAT_AM_PM_MIDNIGHT_NOON_FIELD = 35,
    UDAT_FLEXIBLE_DAY_PERIOD_FIELD = 36,
    UDAT_TIME_SEPARATOR_FIELD = 37,
    UDAT_FIELD_COUNT = 38
};

enum UDateFormatStyle {
    UDAT_FULL,
    UDAT_LONG,
    UDAT_MEDIUM,
    UDAT_SHORT,
    UDAT_DEFAULT = UDAT_MEDIUM,
    UDAT_NONE = -1,
    UDAT_PATTERN = -2,
    UDAT_IGNORE = UDAT_PATTERN
};

enum UDateFormatSymbolType {
    UDAT_ERAS,
    UDAT_MONTHS,
    UDAT_SHORT_MONTHS,
    UDAT_WEEKDAYS,
    UDAT_SHORT_WEEKDAYS,
    UDAT_AM_PMS,
    UDAT_LOCALIZED_CHARS,
    UDAT_ERA_NAMES,
    UDAT_NARROW_MONTHS,
    UDAT_NARROW_WEEKDAYS,
    UDAT_STANDALONE_MONTHS,
    UDAT_STANDALONE_SHORT_MONTHS,
    UDAT_STANDALONE_NARROW_MONTHS,
    UDAT_STANDALONE_WEEKDAYS,
    UDAT_STANDALONE_SHORT_WEEKDAYS,
    UDAT_STANDALONE_NARROW_WEEKDAYS,
    UDAT_QUARTERS,
    UDAT_SHORT_QUARTERS,
    UDAT_STANDALONE_QUARTERS,
    UDAT_STANDALONE_SHORT_QUARTERS,
    UDAT_SHORTER_WEEKDAYS,
    UDAT_STANDALONE_SHORTER_WEEKDAYS,
    UDAT_CYCLIC_YEARS_WIDE,
    UDAT_CYCLIC_YEARS_ABBREVIATED,
    UDAT_CYCLIC_YEARS_NARROW,
    UDAT_ZODIAC_NAMES_WIDE,
    UDAT_ZODIAC_NAMES_ABBREVIATED,
    UDAT_ZODIAC_NAMES_NARROW
};

int32_t
udat_countAvailable()
{
    MOZ_CRASH("udat_countAvailable: Intl API disabled");
}

int32_t
udat_toPattern(const UDateFormat* fmt, UBool localized, UChar* result,
               int32_t resultLength, UErrorCode* status)
{
    MOZ_CRASH("udat_toPattern: Intl API disabled");
}

const char*
udat_getAvailable(int32_t localeIndex)
{
    MOZ_CRASH("udat_getAvailable: Intl API disabled");
}

UDateFormat*
udat_open(UDateFormatStyle timeStyle, UDateFormatStyle dateStyle, const char* locale,
          const UChar* tzID, int32_t tzIDLength, const UChar* pattern,
          int32_t patternLength, UErrorCode* status)
{
    MOZ_CRASH("udat_open: Intl API disabled");
}

const UCalendar*
udat_getCalendar(const UDateFormat* fmt)
{
    MOZ_CRASH("udat_getCalendar: Intl API disabled");
}

void
ucal_setGregorianChange(UCalendar* cal, UDate date, UErrorCode* pErrorCode)
{
    MOZ_CRASH("ucal_setGregorianChange: Intl API disabled");
}

int32_t
udat_format(const UDateFormat* format, UDate dateToFormat, UChar* result,
            int32_t resultLength, UFieldPosition* position, UErrorCode* status)
{
    MOZ_CRASH("udat_format: Intl API disabled");
}

int32_t
udat_formatForFields(const UDateFormat* format, UDate dateToFormat,
                     UChar* result, int32_t resultLength, UFieldPositionIterator* fpositer,
                     UErrorCode* status)
{
    MOZ_CRASH("udat_formatForFields: Intl API disabled");
}

UFieldPositionIterator*
ufieldpositer_open(UErrorCode* status)
{
    MOZ_CRASH("ufieldpositer_open: Intl API disabled");
}

void
ufieldpositer_close(UFieldPositionIterator* fpositer)
{
    MOZ_CRASH("ufieldpositer_close: Intl API disabled");
}

int32_t
ufieldpositer_next(UFieldPositionIterator* fpositer, int32_t* beginIndex, int32_t* endIndex)
{
    MOZ_CRASH("ufieldpositer_next: Intl API disabled");
}

void
udat_close(UDateFormat* format)
{
    MOZ_CRASH("udat_close: Intl API disabled");
}

int32_t
udat_getSymbols(const UDateFormat *fmt, UDateFormatSymbolType type, int32_t symbolIndex,
                UChar *result, int32_t resultLength, UErrorCode *status)
{
    MOZ_CRASH("udat_getSymbols: Intl API disabled");
}

typedef void* UPluralRules;

enum UPluralType {
  UPLURAL_TYPE_CARDINAL,
  UPLURAL_TYPE_ORDINAL
};

void
uplrules_close(UPluralRules *uplrules)
{
    MOZ_CRASH("uplrules_close: Intl API disabled");
}

UPluralRules*
uplrules_openForType(const char *locale, UPluralType type, UErrorCode *status)
{
    MOZ_CRASH("uplrules_openForType: Intl API disabled");
}

int32_t
uplrules_select(const UPluralRules *uplrules, double number, UChar *keyword, int32_t capacity,
                UErrorCode *status)
{
    MOZ_CRASH("uplrules_select: Intl API disabled");
}

int32_t
u_strToLower(UChar* dest, int32_t destCapacity, const UChar* src, int32_t srcLength,
             const char* locale, UErrorCode* pErrorCode)
{
    MOZ_CRASH("u_strToLower: Intl API disabled");
}

int32_t
u_strToUpper(UChar* dest, int32_t destCapacity, const UChar* src, int32_t srcLength,
             const char* locale, UErrorCode* pErrorCode)
{
    MOZ_CRASH("u_strToUpper: Intl API disabled");
}

const char*
uloc_toUnicodeLocaleType(const char* keyword, const char* value)
{
    MOZ_CRASH("uloc_toUnicodeLocaleType: Intl API disabled");
}

} // anonymous namespace

#endif


/******************** Common to Intl constructors ********************/

static bool
IntlInitialize(JSContext* cx, HandleObject obj, Handle<PropertyName*> initializer,
               HandleValue locales, HandleValue options)
{
    FixedInvokeArgs<3> args(cx);

    args[0].setObject(*obj);
    args[1].set(locales);
    args[2].set(options);

    RootedValue thisv(cx, NullValue());
    RootedValue ignored(cx);
    if (!js::CallSelfHostedFunction(cx, initializer, thisv, args, &ignored))
        return false;

    MOZ_ASSERT(ignored.isUndefined(),
               "Unexpected return value from non-legacy Intl object initializer");
    return true;
}

enum class DateTimeFormatOptions
{
    Standard,
    EnableMozExtensions,
};

static bool
LegacyIntlInitialize(JSContext* cx, HandleObject obj, Handle<PropertyName*> initializer,
                     HandleValue thisValue, HandleValue locales, HandleValue options,
                     DateTimeFormatOptions dtfOptions, MutableHandleValue result)
{
    FixedInvokeArgs<5> args(cx);

    args[0].setObject(*obj);
    args[1].set(thisValue);
    args[2].set(locales);
    args[3].set(options);
    args[4].setBoolean(dtfOptions == DateTimeFormatOptions::EnableMozExtensions);

    RootedValue thisv(cx, NullValue());
    if (!js::CallSelfHostedFunction(cx, initializer, thisv, args, result))
        return false;

    MOZ_ASSERT(result.isObject(), "Legacy Intl object initializer must return an object");
    return true;
}

// CountAvailable and GetAvailable describe the signatures used for ICU API
// to determine available locales for various functionality.
using CountAvailable = int32_t (*)();
using GetAvailable = const char* (*)(int32_t localeIndex);

static bool
intl_availableLocales(JSContext* cx, CountAvailable countAvailable,
                      GetAvailable getAvailable, MutableHandleValue result)
{
    RootedObject locales(cx, NewObjectWithGivenProto<PlainObject>(cx, nullptr));
    if (!locales)
        return false;

#if ENABLE_INTL_API
    RootedAtom a(cx);
    uint32_t count = countAvailable();
    for (uint32_t i = 0; i < count; i++) {
        const char* locale = getAvailable(i);
        auto lang = DuplicateString(cx, locale);
        if (!lang)
            return false;
        char* p;
        while ((p = strchr(lang.get(), '_')))
            *p = '-';
        a = Atomize(cx, lang.get(), strlen(lang.get()));
        if (!a)
            return false;
        if (!DefineProperty(cx, locales, a->asPropertyName(), TrueHandleValue, nullptr, nullptr,
                            JSPROP_ENUMERATE))
        {
            return false;
        }
    }
#endif
    result.setObject(*locales);
    return true;
}

/**
 * Returns the object holding the internal properties for obj.
 */
static JSObject*
GetInternals(JSContext* cx, HandleObject obj)
{
    FixedInvokeArgs<1> args(cx);

    args[0].setObject(*obj);

    RootedValue v(cx, NullValue());
    if (!js::CallSelfHostedFunction(cx, cx->names().getInternals, v, args, &v))
        return nullptr;

    return &v.toObject();
}

static bool
equal(const char* s1, const char* s2)
{
    return !strcmp(s1, s2);
}

static const char*
icuLocale(const char* locale)
{
    if (equal(locale, "und"))
        return ""; // ICU root locale
    return locale;
}

// Simple RAII for ICU objects.  Unfortunately, ICU's C++ API is uniformly
// unstable, so we can't use its smart pointers for this.
template <typename T, void (Delete)(T*)>
class ScopedICUObject
{
    T* ptr_;

  public:
    explicit ScopedICUObject(T* ptr)
      : ptr_(ptr)
    {}

    ~ScopedICUObject() {
        if (ptr_)
            Delete(ptr_);
    }

    // In cases where an object should be deleted on abnormal exits,
    // but returned to the caller if everything goes well, call forget()
    // to transfer the object just before returning.
    T* forget() {
        T* tmp = ptr_;
        ptr_ = nullptr;
        return tmp;
    }
};

// The inline capacity we use for the char16_t Vectors.
static const size_t INITIAL_CHAR_BUFFER_SIZE = 32;

template <typename ICUStringFunction>
static JSString*
Call(JSContext* cx, const ICUStringFunction& strFn)
{
    Vector<char16_t, INITIAL_CHAR_BUFFER_SIZE> chars(cx);
    MOZ_ALWAYS_TRUE(chars.resize(INITIAL_CHAR_BUFFER_SIZE));

    UErrorCode status = U_ZERO_ERROR;
    int32_t size = strFn(Char16ToUChar(chars.begin()), INITIAL_CHAR_BUFFER_SIZE, &status);
    if (status == U_BUFFER_OVERFLOW_ERROR) {
        MOZ_ASSERT(size >= 0);
        if (!chars.resize(size_t(size)))
            return nullptr;
        status = U_ZERO_ERROR;
        strFn(Char16ToUChar(chars.begin()), size, &status);
    }
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }

    MOZ_ASSERT(size >= 0);
    return NewStringCopyN<CanGC>(cx, chars.begin(), size_t(size));
}


/******************** Collator ********************/

const ClassOps CollatorObject::classOps_ = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    CollatorObject::finalize
};

const Class CollatorObject::class_ = {
    js_Object_str,
    JSCLASS_HAS_RESERVED_SLOTS(CollatorObject::SLOT_COUNT) |
    JSCLASS_FOREGROUND_FINALIZE,
    &CollatorObject::classOps_
};

#if JS_HAS_TOSOURCE
static bool
collator_toSource(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setString(cx->names().Collator);
    return true;
}
#endif

static const JSFunctionSpec collator_static_methods[] = {
    JS_SELF_HOSTED_FN("supportedLocalesOf", "Intl_Collator_supportedLocalesOf", 1, 0),
    JS_FS_END
};

static const JSFunctionSpec collator_methods[] = {
    JS_SELF_HOSTED_FN("resolvedOptions", "Intl_Collator_resolvedOptions", 0, 0),
#if JS_HAS_TOSOURCE
    JS_FN(js_toSource_str, collator_toSource, 0, 0),
#endif
    JS_FS_END
};

static const JSPropertySpec collator_properties[] = {
    JS_SELF_HOSTED_GET("compare", "Intl_Collator_compare_get", 0),
    JS_STRING_SYM_PS(toStringTag, "Object", JSPROP_READONLY),
    JS_PS_END
};

/**
 * 10.1.2 Intl.Collator([ locales [, options]])
 *
 * ES2017 Intl draft rev 94045d234762ad107a3d09bb6f7381a65f1a2f9b
 */
static bool
Collator(JSContext* cx, const CallArgs& args)
{
    // Step 1 (Handled by OrdinaryCreateFromConstructor fallback code).

    // Steps 2-5 (Inlined 9.1.14, OrdinaryCreateFromConstructor).
    RootedObject proto(cx);
    if (args.isConstructing() && !GetPrototypeFromCallableConstructor(cx, args, &proto))
        return false;

    if (!proto) {
        proto = GlobalObject::getOrCreateCollatorPrototype(cx, cx->global());
        if (!proto)
            return false;
    }

    Rooted<CollatorObject*> collator(cx, NewObjectWithGivenProto<CollatorObject>(cx, proto));
    if (!collator)
        return false;

    collator->setReservedSlot(CollatorObject::INTERNALS_SLOT, NullValue());
    collator->setReservedSlot(CollatorObject::UCOLLATOR_SLOT, PrivateValue(nullptr));

    RootedValue locales(cx, args.get(0));
    RootedValue options(cx, args.get(1));

    // Step 6.
    if (!IntlInitialize(cx, collator, cx->names().InitializeCollator, locales, options))
        return false;

    args.rval().setObject(*collator);
    return true;
}

static bool
Collator(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return Collator(cx, args);
}

bool
js::intl_Collator(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(!args.isConstructing());

    return Collator(cx, args);
}

void
CollatorObject::finalize(FreeOp* fop, JSObject* obj)
{
    MOZ_ASSERT(fop->onActiveCooperatingThread());

    const Value& slot = obj->as<CollatorObject>().getReservedSlot(CollatorObject::UCOLLATOR_SLOT);
    if (UCollator* coll = static_cast<UCollator*>(slot.toPrivate()))
        ucol_close(coll);
}

static JSObject*
CreateCollatorPrototype(JSContext* cx, HandleObject Intl, Handle<GlobalObject*> global)
{
    RootedFunction ctor(cx, GlobalObject::createConstructor(cx, &Collator, cx->names().Collator,
                                                            0));
    if (!ctor)
        return nullptr;

    RootedObject proto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!proto)
        return nullptr;

    if (!LinkConstructorAndPrototype(cx, ctor, proto))
        return nullptr;

    // 10.2.2
    if (!JS_DefineFunctions(cx, ctor, collator_static_methods))
        return nullptr;

    // 10.3.5
    if (!JS_DefineFunctions(cx, proto, collator_methods))
        return nullptr;

    // 10.3.2 and 10.3.3
    if (!JS_DefineProperties(cx, proto, collator_properties))
        return nullptr;

    // 8.1
    RootedValue ctorValue(cx, ObjectValue(*ctor));
    if (!DefineProperty(cx, Intl, cx->names().Collator, ctorValue, nullptr, nullptr, 0))
        return nullptr;

    return proto;
}

bool
js::intl_Collator_availableLocales(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    RootedValue result(cx);
    if (!intl_availableLocales(cx, ucol_countAvailable, ucol_getAvailable, &result))
        return false;
    args.rval().set(result);
    return true;
}

bool
js::intl_availableCollations(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;
    UErrorCode status = U_ZERO_ERROR;
    UEnumeration* values = ucol_getKeywordValuesForLocale("co", locale.ptr(), false, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UEnumeration, uenum_close> toClose(values);

    uint32_t count = uenum_count(values, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    RootedObject collations(cx, NewDenseEmptyArray(cx));
    if (!collations)
        return false;

    uint32_t index = 0;

    // The first element of the collations array must be |null| per
    // ES2017 Intl, 10.2.3 Internal Slots.
    if (!DefineElement(cx, collations, index++, NullHandleValue))
        return false;

    RootedValue element(cx);
    for (uint32_t i = 0; i < count; i++) {
        const char* collation = uenum_next(values, nullptr, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        // Per ECMA-402, 10.2.3, we don't include standard and search:
        // "The values 'standard' and 'search' must not be used as elements in
        // any [[sortLocaleData]][locale].co and [[searchLocaleData]][locale].co
        // array."
        if (equal(collation, "standard") || equal(collation, "search"))
            continue;

        // ICU returns old-style keyword values; map them to BCP 47 equivalents.
        JSString* jscollation = JS_NewStringCopyZ(cx, uloc_toUnicodeLocaleType("co", collation));
        if (!jscollation)
            return false;
        element = StringValue(jscollation);
        if (!DefineElement(cx, collations, index++, element))
            return false;
    }

    args.rval().setObject(*collations);
    return true;
}

/**
 * Returns a new UCollator with the locale and collation options
 * of the given Collator.
 */
static UCollator*
NewUCollator(JSContext* cx, Handle<CollatorObject*> collator)
{
    RootedValue value(cx);

    RootedObject internals(cx, GetInternals(cx, collator));
    if (!internals)
        return nullptr;

    if (!GetProperty(cx, internals, internals, cx->names().locale, &value))
        return nullptr;
    JSAutoByteString locale(cx, value.toString());
    if (!locale)
        return nullptr;

    // UCollator options with default values.
    UColAttributeValue uStrength = UCOL_DEFAULT;
    UColAttributeValue uCaseLevel = UCOL_OFF;
    UColAttributeValue uAlternate = UCOL_DEFAULT;
    UColAttributeValue uNumeric = UCOL_OFF;
    // Normalization is always on to meet the canonical equivalence requirement.
    UColAttributeValue uNormalization = UCOL_ON;
    UColAttributeValue uCaseFirst = UCOL_DEFAULT;

    if (!GetProperty(cx, internals, internals, cx->names().usage, &value))
        return nullptr;
    JSLinearString* usage = value.toString()->ensureLinear(cx);
    if (!usage)
        return nullptr;
    if (StringEqualsAscii(usage, "search")) {
        // ICU expects search as a Unicode locale extension on locale.
        // Unicode locale extensions must occur before private use extensions.
        const char* oldLocale = locale.ptr();
        const char* p;
        size_t index;
        size_t localeLen = strlen(oldLocale);
        if ((p = strstr(oldLocale, "-x-")))
            index = p - oldLocale;
        else
            index = localeLen;

        const char* insert;
        if ((p = strstr(oldLocale, "-u-")) && static_cast<size_t>(p - oldLocale) < index) {
            index = p - oldLocale + 2;
            insert = "-co-search";
        } else {
            insert = "-u-co-search";
        }
        size_t insertLen = strlen(insert);
        char* newLocale = cx->pod_malloc<char>(localeLen + insertLen + 1);
        if (!newLocale)
            return nullptr;
        memcpy(newLocale, oldLocale, index);
        memcpy(newLocale + index, insert, insertLen);
        memcpy(newLocale + index + insertLen, oldLocale + index, localeLen - index + 1); // '\0'
        locale.clear();
        locale.initBytes(JS::UniqueChars(newLocale));
    } else {
        MOZ_ASSERT(StringEqualsAscii(usage, "sort"));
    }

    // We don't need to look at the collation property - it can only be set
    // via the Unicode locale extension and is therefore already set on
    // locale.

    if (!GetProperty(cx, internals, internals, cx->names().sensitivity, &value))
        return nullptr;
    JSLinearString* sensitivity = value.toString()->ensureLinear(cx);
    if (!sensitivity)
        return nullptr;
    if (StringEqualsAscii(sensitivity, "base")) {
        uStrength = UCOL_PRIMARY;
    } else if (StringEqualsAscii(sensitivity, "accent")) {
        uStrength = UCOL_SECONDARY;
    } else if (StringEqualsAscii(sensitivity, "case")) {
        uStrength = UCOL_PRIMARY;
        uCaseLevel = UCOL_ON;
    } else {
        MOZ_ASSERT(StringEqualsAscii(sensitivity, "variant"));
        uStrength = UCOL_TERTIARY;
    }

    if (!GetProperty(cx, internals, internals, cx->names().ignorePunctuation, &value))
        return nullptr;
    // According to the ICU team, UCOL_SHIFTED causes punctuation to be
    // ignored. Looking at Unicode Technical Report 35, Unicode Locale Data
    // Markup Language, "shifted" causes whitespace and punctuation to be
    // ignored - that's a bit more than asked for, but there's no way to get
    // less.
    if (value.toBoolean())
        uAlternate = UCOL_SHIFTED;

    if (!GetProperty(cx, internals, internals, cx->names().numeric, &value))
        return nullptr;
    if (!value.isUndefined() && value.toBoolean())
        uNumeric = UCOL_ON;

    if (!GetProperty(cx, internals, internals, cx->names().caseFirst, &value))
        return nullptr;
    if (!value.isUndefined()) {
        JSLinearString* caseFirst = value.toString()->ensureLinear(cx);
        if (!caseFirst)
            return nullptr;
        if (StringEqualsAscii(caseFirst, "upper")) {
            uCaseFirst = UCOL_UPPER_FIRST;
        } else if (StringEqualsAscii(caseFirst, "lower")) {
            uCaseFirst = UCOL_LOWER_FIRST;
        } else {
            MOZ_ASSERT(StringEqualsAscii(caseFirst, "false"));
            uCaseFirst = UCOL_OFF;
        }
    }

    UErrorCode status = U_ZERO_ERROR;
    UCollator* coll = ucol_open(icuLocale(locale.ptr()), &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }

    ucol_setAttribute(coll, UCOL_STRENGTH, uStrength, &status);
    ucol_setAttribute(coll, UCOL_CASE_LEVEL, uCaseLevel, &status);
    ucol_setAttribute(coll, UCOL_ALTERNATE_HANDLING, uAlternate, &status);
    ucol_setAttribute(coll, UCOL_NUMERIC_COLLATION, uNumeric, &status);
    ucol_setAttribute(coll, UCOL_NORMALIZATION_MODE, uNormalization, &status);
    ucol_setAttribute(coll, UCOL_CASE_FIRST, uCaseFirst, &status);
    if (U_FAILURE(status)) {
        ucol_close(coll);
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }

    return coll;
}

static bool
intl_CompareStrings(JSContext* cx, UCollator* coll, HandleString str1, HandleString str2,
                    MutableHandleValue result)
{
    MOZ_ASSERT(str1);
    MOZ_ASSERT(str2);

    if (str1 == str2) {
        result.setInt32(0);
        return true;
    }

    AutoStableStringChars stableChars1(cx);
    if (!stableChars1.initTwoByte(cx, str1))
        return false;

    AutoStableStringChars stableChars2(cx);
    if (!stableChars2.initTwoByte(cx, str2))
        return false;

    mozilla::Range<const char16_t> chars1 = stableChars1.twoByteRange();
    mozilla::Range<const char16_t> chars2 = stableChars2.twoByteRange();

    UCollationResult uresult = ucol_strcoll(coll,
                                            Char16ToUChar(chars1.begin().get()), chars1.length(),
                                            Char16ToUChar(chars2.begin().get()), chars2.length());
    int32_t res;
    switch (uresult) {
        case UCOL_LESS: res = -1; break;
        case UCOL_EQUAL: res = 0; break;
        case UCOL_GREATER: res = 1; break;
        default: MOZ_CRASH("ucol_strcoll returned bad UCollationResult");
    }
    result.setInt32(res);
    return true;
}

bool
js::intl_CompareStrings(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 3);
    MOZ_ASSERT(args[0].isObject());
    MOZ_ASSERT(args[1].isString());
    MOZ_ASSERT(args[2].isString());

    Rooted<CollatorObject*> collator(cx, &args[0].toObject().as<CollatorObject>());

    // Obtain a cached UCollator object.
    // XXX Does this handle Collator instances from other globals correctly?
    void* priv = collator->getReservedSlot(CollatorObject::UCOLLATOR_SLOT).toPrivate();
    UCollator* coll = static_cast<UCollator*>(priv);
    if (!coll) {
        coll = NewUCollator(cx, collator);
        if (!coll)
            return false;
        collator->setReservedSlot(CollatorObject::UCOLLATOR_SLOT, PrivateValue(coll));
    }

    // Use the UCollator to actually compare the strings.
    RootedString str1(cx, args[1].toString());
    RootedString str2(cx, args[2].toString());
    return intl_CompareStrings(cx, coll, str1, str2, args.rval());
}

js::SharedIntlData::LocaleHasher::Lookup::Lookup(JSLinearString* locale)
  : js::SharedIntlData::LinearStringLookup(locale)
{
    if (isLatin1)
        hash = mozilla::HashString(latin1Chars, length);
    else
        hash = mozilla::HashString(twoByteChars, length);
}

bool
js::SharedIntlData::LocaleHasher::match(Locale key, const Lookup& lookup)
{
    if (key->length() != lookup.length)
        return false;

    if (key->hasLatin1Chars()) {
        const Latin1Char* keyChars = key->latin1Chars(lookup.nogc);
        if (lookup.isLatin1)
            return EqualChars(keyChars, lookup.latin1Chars, lookup.length);
        return EqualChars(keyChars, lookup.twoByteChars, lookup.length);
    }

    const char16_t* keyChars = key->twoByteChars(lookup.nogc);
    if (lookup.isLatin1)
        return EqualChars(lookup.latin1Chars, keyChars, lookup.length);
    return EqualChars(keyChars, lookup.twoByteChars, lookup.length);
}

bool
js::SharedIntlData::ensureUpperCaseFirstLocales(JSContext* cx)
{
    if (upperCaseFirstInitialized)
        return true;

    // If ensureUpperCaseFirstLocales() was called previously, but didn't
    // complete due to OOM, clear all data and start from scratch.
    if (upperCaseFirstLocales.initialized())
        upperCaseFirstLocales.finish();
    if (!upperCaseFirstLocales.init()) {
        ReportOutOfMemory(cx);
        return false;
    }

    UErrorCode status = U_ZERO_ERROR;
    UEnumeration* available = ucol_openAvailableLocales(&status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UEnumeration, uenum_close> toClose(available);

    RootedAtom locale(cx);
    while (true) {
        int32_t size;
        const char* rawLocale = uenum_next(available, &size, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        if (rawLocale == nullptr)
            break;

        UCollator* collator = ucol_open(rawLocale, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }
        ScopedICUObject<UCollator, ucol_close> toCloseCollator(collator);

        UColAttributeValue caseFirst = ucol_getAttribute(collator, UCOL_CASE_FIRST, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        if (caseFirst != UCOL_UPPER_FIRST)
            continue;

        MOZ_ASSERT(size >= 0);
        locale = Atomize(cx, rawLocale, size_t(size));
        if (!locale)
            return false;

        LocaleHasher::Lookup lookup(locale);
        LocaleSet::AddPtr p = upperCaseFirstLocales.lookupForAdd(lookup);

        // ICU shouldn't report any duplicate locales, but if it does, just
        // ignore the duplicated locale.
        if (!p && !upperCaseFirstLocales.add(p, locale)) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    MOZ_ASSERT(!upperCaseFirstInitialized,
               "ensureUpperCaseFirstLocales is neither reentrant nor thread-safe");
    upperCaseFirstInitialized = true;

    return true;
}

bool
js::SharedIntlData::isUpperCaseFirst(JSContext* cx, HandleString locale, bool* isUpperFirst)
{
    if (!ensureUpperCaseFirstLocales(cx))
        return false;

    RootedLinearString localeLinear(cx, locale->ensureLinear(cx));
    if (!localeLinear)
        return false;

    LocaleHasher::Lookup lookup(localeLinear);
    *isUpperFirst = upperCaseFirstLocales.has(lookup);

    return true;
}

bool
js::intl_isUpperCaseFirst(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    SharedIntlData& sharedIntlData = cx->runtime()->sharedIntlData.ref();

    RootedString locale(cx, args[0].toString());
    bool isUpperFirst;
    if (!sharedIntlData.isUpperCaseFirst(cx, locale, &isUpperFirst))
        return false;

    args.rval().setBoolean(isUpperFirst);
    return true;
}


/******************** NumberFormat ********************/

const ClassOps NumberFormatObject::classOps_ = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    NumberFormatObject::finalize
};

const Class NumberFormatObject::class_ = {
    js_Object_str,
    JSCLASS_HAS_RESERVED_SLOTS(NumberFormatObject::SLOT_COUNT) |
    JSCLASS_FOREGROUND_FINALIZE,
    &NumberFormatObject::classOps_
};

#if JS_HAS_TOSOURCE
static bool
numberFormat_toSource(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setString(cx->names().NumberFormat);
    return true;
}
#endif

static const JSFunctionSpec numberFormat_static_methods[] = {
    JS_SELF_HOSTED_FN("supportedLocalesOf", "Intl_NumberFormat_supportedLocalesOf", 1, 0),
    JS_FS_END
};

static const JSFunctionSpec numberFormat_methods[] = {
    JS_SELF_HOSTED_FN("resolvedOptions", "Intl_NumberFormat_resolvedOptions", 0, 0),
#if JS_HAS_TOSOURCE
    JS_FN(js_toSource_str, numberFormat_toSource, 0, 0),
#endif
    JS_FS_END
};

static const JSPropertySpec numberFormat_properties[] = {
    JS_SELF_HOSTED_GET("format", "Intl_NumberFormat_format_get", 0),
    JS_STRING_SYM_PS(toStringTag, "Object", JSPROP_READONLY),
    JS_PS_END
};

/**
 * 11.2.1 Intl.NumberFormat([ locales [, options]])
 *
 * ES2017 Intl draft rev 94045d234762ad107a3d09bb6f7381a65f1a2f9b
 */
static bool
NumberFormat(JSContext* cx, const CallArgs& args, bool construct)
{
    // Step 1 (Handled by OrdinaryCreateFromConstructor fallback code).

    // Step 2 (Inlined 9.1.14, OrdinaryCreateFromConstructor).
    RootedObject proto(cx);
    if (args.isConstructing() && !GetPrototypeFromCallableConstructor(cx, args, &proto))
        return false;

    if (!proto) {
        proto = GlobalObject::getOrCreateNumberFormatPrototype(cx, cx->global());
        if (!proto)
            return false;
    }

    Rooted<NumberFormatObject*> numberFormat(cx);
    numberFormat = NewObjectWithGivenProto<NumberFormatObject>(cx, proto);
    if (!numberFormat)
        return false;

    numberFormat->setReservedSlot(NumberFormatObject::INTERNALS_SLOT, NullValue());
    numberFormat->setReservedSlot(NumberFormatObject::UNUMBER_FORMAT_SLOT, PrivateValue(nullptr));

    RootedValue thisValue(cx, construct ? ObjectValue(*numberFormat) : args.thisv());
    RootedValue locales(cx, args.get(0));
    RootedValue options(cx, args.get(1));

    // Step 3.
    return LegacyIntlInitialize(cx, numberFormat, cx->names().InitializeNumberFormat, thisValue,
                                locales, options, DateTimeFormatOptions::Standard, args.rval());
}

static bool
NumberFormat(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return NumberFormat(cx, args, args.isConstructing());
}

bool
js::intl_NumberFormat(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(!args.isConstructing());
    // intl_NumberFormat is an intrinsic for self-hosted JavaScript, so it
    // cannot be used with "new", but it still has to be treated as a
    // constructor.
    return NumberFormat(cx, args, true);
}

void
NumberFormatObject::finalize(FreeOp* fop, JSObject* obj)
{
    MOZ_ASSERT(fop->onActiveCooperatingThread());

    const Value& slot =
        obj->as<NumberFormatObject>().getReservedSlot(NumberFormatObject::UNUMBER_FORMAT_SLOT);
    if (UNumberFormat* nf = static_cast<UNumberFormat*>(slot.toPrivate()))
        unum_close(nf);
}

static JSObject*
CreateNumberFormatPrototype(JSContext* cx, HandleObject Intl, Handle<GlobalObject*> global,
                            MutableHandleObject constructor)
{
    RootedFunction ctor(cx);
    ctor = GlobalObject::createConstructor(cx, &NumberFormat, cx->names().NumberFormat, 0);
    if (!ctor)
        return nullptr;

    RootedObject proto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!proto)
        return nullptr;

    if (!LinkConstructorAndPrototype(cx, ctor, proto))
        return nullptr;

    // 11.3.2
    if (!JS_DefineFunctions(cx, ctor, numberFormat_static_methods))
        return nullptr;

    // 11.4.4
    if (!JS_DefineFunctions(cx, proto, numberFormat_methods))
        return nullptr;

    // 11.4.2 and 11.4.3
    if (!JS_DefineProperties(cx, proto, numberFormat_properties))
        return nullptr;

#if defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)
    // If the still-experimental NumberFormat.prototype.formatToParts method is
    // enabled, also add it.
    if (cx->compartment()->creationOptions().experimentalNumberFormatFormatToPartsEnabled()) {
        RootedValue ftp(cx);
        HandlePropertyName name = cx->names().formatToParts;
        if (!GlobalObject::getSelfHostedFunction(cx, cx->global(),
                                                 cx->names().NumberFormatFormatToParts,
                                                 name, 1, &ftp))
        {
            return nullptr;
        }

        if (!DefineProperty(cx, proto, cx->names().formatToParts, ftp, nullptr, nullptr, 0))
            return nullptr;
    }
#endif // defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)

    // 8.1
    RootedValue ctorValue(cx, ObjectValue(*ctor));
    if (!DefineProperty(cx, Intl, cx->names().NumberFormat, ctorValue, nullptr, nullptr, 0))
        return nullptr;

    constructor.set(ctor);
    return proto;
}

bool
js::intl_NumberFormat_availableLocales(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    RootedValue result(cx);
    if (!intl_availableLocales(cx, unum_countAvailable, unum_getAvailable, &result))
        return false;
    args.rval().set(result);
    return true;
}

bool
js::intl_numberingSystem(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    UErrorCode status = U_ZERO_ERROR;
    UNumberingSystem* numbers = unumsys_open(icuLocale(locale.ptr()), &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    ScopedICUObject<UNumberingSystem, unumsys_close> toClose(numbers);

    const char* name = unumsys_getName(numbers);
    RootedString jsname(cx, JS_NewStringCopyZ(cx, name));
    if (!jsname)
        return false;

    args.rval().setString(jsname);
    return true;
}


/**
 * This creates new UNumberFormat with calculated digit formatting
 * properties for PluralRules.
 *
 * This is similar to NewUNumberFormat but doesn't allow for currency or
 * percent types.
 */
static UNumberFormat*
NewUNumberFormatForPluralRules(JSContext* cx, Handle<PluralRulesObject*> pluralRules)
{
    RootedObject internals(cx, GetInternals(cx, pluralRules));
    if (!internals)
       return nullptr;

    RootedValue value(cx);

    if (!GetProperty(cx, internals, internals, cx->names().locale, &value))
        return nullptr;
    JSAutoByteString locale(cx, value.toString());
    if (!locale)
        return nullptr;

    uint32_t uMinimumIntegerDigits = 1;
    uint32_t uMinimumFractionDigits = 0;
    uint32_t uMaximumFractionDigits = 3;
    int32_t uMinimumSignificantDigits = -1;
    int32_t uMaximumSignificantDigits = -1;

    bool hasP;
    if (!HasProperty(cx, internals, cx->names().minimumSignificantDigits, &hasP))
        return nullptr;

    if (hasP) {
        if (!GetProperty(cx, internals, internals, cx->names().minimumSignificantDigits, &value))
            return nullptr;
        uMinimumSignificantDigits = value.toInt32();

        if (!GetProperty(cx, internals, internals, cx->names().maximumSignificantDigits, &value))
            return nullptr;
        uMaximumSignificantDigits = value.toInt32();
    } else {
        if (!GetProperty(cx, internals, internals, cx->names().minimumIntegerDigits, &value))
            return nullptr;
        uMinimumIntegerDigits = AssertedCast<uint32_t>(value.toInt32());

        if (!GetProperty(cx, internals, internals, cx->names().minimumFractionDigits, &value))
            return nullptr;
        uMinimumFractionDigits = AssertedCast<uint32_t>(value.toInt32());

        if (!GetProperty(cx, internals, internals, cx->names().maximumFractionDigits, &value))
            return nullptr;
        uMaximumFractionDigits = AssertedCast<uint32_t>(value.toInt32());
    }

    UErrorCode status = U_ZERO_ERROR;
    UNumberFormat* nf =
        unum_open(UNUM_DECIMAL, nullptr, 0, icuLocale(locale.ptr()), nullptr, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }
    ScopedICUObject<UNumberFormat, unum_close> toClose(nf);

    if (uMinimumSignificantDigits != -1) {
        unum_setAttribute(nf, UNUM_SIGNIFICANT_DIGITS_USED, true);
        unum_setAttribute(nf, UNUM_MIN_SIGNIFICANT_DIGITS, uMinimumSignificantDigits);
        unum_setAttribute(nf, UNUM_MAX_SIGNIFICANT_DIGITS, uMaximumSignificantDigits);
    } else {
        unum_setAttribute(nf, UNUM_MIN_INTEGER_DIGITS, uMinimumIntegerDigits);
        unum_setAttribute(nf, UNUM_MIN_FRACTION_DIGITS, uMinimumFractionDigits);
        unum_setAttribute(nf, UNUM_MAX_FRACTION_DIGITS, uMaximumFractionDigits);
    }

    return toClose.forget();
}


/**
 * Returns a new UNumberFormat with the locale and number formatting options
 * of the given NumberFormat.
 */
static UNumberFormat*
NewUNumberFormat(JSContext* cx, Handle<NumberFormatObject*> numberFormat)
{
    RootedValue value(cx);

    RootedObject internals(cx, GetInternals(cx, numberFormat));
    if (!internals)
       return nullptr;

    if (!GetProperty(cx, internals, internals, cx->names().locale, &value))
        return nullptr;
    JSAutoByteString locale(cx, value.toString());
    if (!locale)
        return nullptr;

    // UNumberFormat options with default values
    UNumberFormatStyle uStyle = UNUM_DECIMAL;
    const UChar* uCurrency = nullptr;
    uint32_t uMinimumIntegerDigits = 1;
    uint32_t uMinimumFractionDigits = 0;
    uint32_t uMaximumFractionDigits = 3;
    int32_t uMinimumSignificantDigits = -1;
    int32_t uMaximumSignificantDigits = -1;
    bool uUseGrouping = true;

    // Sprinkle appropriate rooting flavor over things the GC might care about.
    RootedString currency(cx);
    AutoStableStringChars stableChars(cx);

    // We don't need to look at numberingSystem - it can only be set via
    // the Unicode locale extension and is therefore already set on locale.

    if (!GetProperty(cx, internals, internals, cx->names().style, &value))
        return nullptr;
    JSLinearString* style = value.toString()->ensureLinear(cx);
    if (!style)
        return nullptr;

    if (StringEqualsAscii(style, "currency")) {
        if (!GetProperty(cx, internals, internals, cx->names().currency, &value))
            return nullptr;
        currency = value.toString();
        MOZ_ASSERT(currency->length() == 3,
                   "IsWellFormedCurrencyCode permits only length-3 strings");
        if (!stableChars.initTwoByte(cx, currency))
            return nullptr;
        // uCurrency remains owned by stableChars.
        uCurrency = Char16ToUChar(stableChars.twoByteRange().begin().get());

        if (!GetProperty(cx, internals, internals, cx->names().currencyDisplay, &value))
            return nullptr;
        JSLinearString* currencyDisplay = value.toString()->ensureLinear(cx);
        if (!currencyDisplay)
            return nullptr;
        if (StringEqualsAscii(currencyDisplay, "code")) {
            uStyle = UNUM_CURRENCY_ISO;
        } else if (StringEqualsAscii(currencyDisplay, "symbol")) {
            uStyle = UNUM_CURRENCY;
        } else {
            MOZ_ASSERT(StringEqualsAscii(currencyDisplay, "name"));
            uStyle = UNUM_CURRENCY_PLURAL;
        }
    } else if (StringEqualsAscii(style, "percent")) {
        uStyle = UNUM_PERCENT;
    } else {
        MOZ_ASSERT(StringEqualsAscii(style, "decimal"));
        uStyle = UNUM_DECIMAL;
    }

    bool hasP;
    if (!HasProperty(cx, internals, cx->names().minimumSignificantDigits, &hasP))
        return nullptr;

    if (hasP) {
        if (!GetProperty(cx, internals, internals, cx->names().minimumSignificantDigits, &value))
            return nullptr;
        uMinimumSignificantDigits = value.toInt32();

        if (!GetProperty(cx, internals, internals, cx->names().maximumSignificantDigits, &value))
            return nullptr;
        uMaximumSignificantDigits = value.toInt32();
    } else {
        if (!GetProperty(cx, internals, internals, cx->names().minimumIntegerDigits, &value))
            return nullptr;
        uMinimumIntegerDigits = AssertedCast<uint32_t>(value.toInt32());

        if (!GetProperty(cx, internals, internals, cx->names().minimumFractionDigits, &value))
            return nullptr;
        uMinimumFractionDigits = AssertedCast<uint32_t>(value.toInt32());

        if (!GetProperty(cx, internals, internals, cx->names().maximumFractionDigits, &value))
            return nullptr;
        uMaximumFractionDigits = AssertedCast<uint32_t>(value.toInt32());
    }

    if (!GetProperty(cx, internals, internals, cx->names().useGrouping, &value))
        return nullptr;
    uUseGrouping = value.toBoolean();

    UErrorCode status = U_ZERO_ERROR;
    UNumberFormat* nf = unum_open(uStyle, nullptr, 0, icuLocale(locale.ptr()), nullptr, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }
    ScopedICUObject<UNumberFormat, unum_close> toClose(nf);

    if (uCurrency) {
        unum_setTextAttribute(nf, UNUM_CURRENCY_CODE, uCurrency, 3, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return nullptr;
        }
    }
    if (uMinimumSignificantDigits != -1) {
        unum_setAttribute(nf, UNUM_SIGNIFICANT_DIGITS_USED, true);
        unum_setAttribute(nf, UNUM_MIN_SIGNIFICANT_DIGITS, uMinimumSignificantDigits);
        unum_setAttribute(nf, UNUM_MAX_SIGNIFICANT_DIGITS, uMaximumSignificantDigits);
    } else {
        unum_setAttribute(nf, UNUM_MIN_INTEGER_DIGITS, uMinimumIntegerDigits);
        unum_setAttribute(nf, UNUM_MIN_FRACTION_DIGITS, uMinimumFractionDigits);
        unum_setAttribute(nf, UNUM_MAX_FRACTION_DIGITS, uMaximumFractionDigits);
    }
    unum_setAttribute(nf, UNUM_GROUPING_USED, uUseGrouping);
    unum_setAttribute(nf, UNUM_ROUNDING_MODE, UNUM_ROUND_HALFUP);

    return toClose.forget();
}

static JSString*
PartitionNumberPattern(JSContext* cx, UNumberFormat* nf, double* x,
                       UFieldPositionIterator* fpositer)
{
    // PartitionNumberPattern doesn't consider -0.0 to be negative.
    if (IsNegativeZero(*x))
        *x = 0.0;

#if !defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)
    MOZ_ASSERT(fpositer == nullptr,
               "shouldn't be requesting field information from an ICU that "
               "can't provide it");
#endif

    return Call(cx, [nf, x, fpositer](UChar* chars, int32_t size, UErrorCode* status) {
#if defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)
        return unum_formatDoubleForFields(nf, *x, chars, size, fpositer, status);
#else
        return unum_formatDouble(nf, *x, chars, size, nullptr, status);
#endif
    });
}

static bool
intl_FormatNumber(JSContext* cx, UNumberFormat* nf, double x, MutableHandleValue result)
{
    // Passing null for |fpositer| will just not compute partition information,
    // letting us common up all ICU number-formatting code.
    JSString* str = PartitionNumberPattern(cx, nf, &x, nullptr);
    if (!str)
        return false;

    result.setString(str);
    return true;
}

using FieldType = ImmutablePropertyNamePtr JSAtomState::*;

#if defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)

static FieldType
GetFieldTypeForNumberField(UNumberFormatFields fieldName, double d)
{
    // See intl/icu/source/i18n/unicode/unum.h for a detailed field list.  This
    // list is deliberately exhaustive: cases might have to be added/removed if
    // this code is compiled with a different ICU with more UNumberFormatFields
    // enum initializers.  Please guard such cases with appropriate ICU
    // version-testing #ifdefs, should cross-version divergence occur.
    switch (fieldName) {
      case UNUM_INTEGER_FIELD:
        if (IsNaN(d))
            return &JSAtomState::nan;
        if (!IsFinite(d))
            return &JSAtomState::infinity;
        return &JSAtomState::integer;

      case UNUM_GROUPING_SEPARATOR_FIELD:
        return &JSAtomState::group;

      case UNUM_DECIMAL_SEPARATOR_FIELD:
        return &JSAtomState::decimal;

      case UNUM_FRACTION_FIELD:
        return &JSAtomState::fraction;

      case UNUM_SIGN_FIELD: {
        MOZ_ASSERT(!IsNegativeZero(d),
                   "-0 should have been excluded by PartitionNumberPattern");

        // Manual trawling through the ICU call graph appears to indicate that
        // the basic formatting we request will never include a positive sign.
        // But this analysis may be mistaken, so don't absolutely trust it.
        return d < 0 ? &JSAtomState::minusSign : &JSAtomState::plusSign;
      }

      case UNUM_PERCENT_FIELD:
        return &JSAtomState::percentSign;

      case UNUM_CURRENCY_FIELD:
        return &JSAtomState::currency;

      case UNUM_PERMILL_FIELD:
        MOZ_ASSERT_UNREACHABLE("unexpected permill field found, even though "
                               "we don't use any user-defined patterns that "
                               "would require a permill field");
        break;

      case UNUM_EXPONENT_SYMBOL_FIELD:
      case UNUM_EXPONENT_SIGN_FIELD:
      case UNUM_EXPONENT_FIELD:
        MOZ_ASSERT_UNREACHABLE("exponent field unexpectedly found in "
                               "formatted number, even though UNUM_SCIENTIFIC "
                               "and scientific notation were never requested");
        break;

      case UNUM_FIELD_COUNT:
        MOZ_ASSERT_UNREACHABLE("format field sentinel value returned by "
                               "iterator!");
        break;
    }

    MOZ_ASSERT_UNREACHABLE("unenumerated, undocumented format field returned "
                           "by iterator");
    return nullptr;
}

static bool
intl_FormatNumberToParts(JSContext* cx, UNumberFormat* nf, double x, MutableHandleValue result)
{
    UErrorCode status = U_ZERO_ERROR;

    UFieldPositionIterator* fpositer = ufieldpositer_open(&status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    MOZ_ASSERT(fpositer);
    ScopedICUObject<UFieldPositionIterator, ufieldpositer_close> toClose(fpositer);

    RootedString overallResult(cx, PartitionNumberPattern(cx, nf, &x, fpositer));
    if (!overallResult)
        return false;

    RootedArrayObject partsArray(cx, NewDenseEmptyArray(cx));
    if (!partsArray)
        return false;

    // First, vacuum up fields in the overall formatted string.

    struct Field
    {
        uint32_t begin;
        uint32_t end;
        FieldType type;

        // Needed for vector-resizing scratch space.
        Field() = default;

        Field(uint32_t begin, uint32_t end, FieldType type)
          : begin(begin), end(end), type(type)
        {}
    };

    using FieldsVector = Vector<Field, 16>;
    FieldsVector fields(cx);

    int32_t fieldInt, beginIndexInt, endIndexInt;
    while ((fieldInt = ufieldpositer_next(fpositer, &beginIndexInt, &endIndexInt)) >= 0) {
        MOZ_ASSERT(beginIndexInt >= 0);
        MOZ_ASSERT(endIndexInt >= 0);
        MOZ_ASSERT(beginIndexInt < endIndexInt,
                   "erm, aren't fields always non-empty?");

        FieldType type = GetFieldTypeForNumberField(UNumberFormatFields(fieldInt), x);
        if (!fields.emplaceBack(uint32_t(beginIndexInt), uint32_t(endIndexInt), type))
            return false;
    }

    // Second, merge sort the fields vector.  Expand the vector to have scratch
    // space for performing the sort.
    size_t fieldsLen = fields.length();
    if (!fields.resizeUninitialized(fieldsLen * 2))
        return false;

    MOZ_ALWAYS_TRUE(MergeSort(fields.begin(), fieldsLen, fields.begin() + fieldsLen,
                              [](const Field& left, const Field& right,
                                 bool* lessOrEqual)
                              {
                                  // Sort first by begin index, then to place
                                  // enclosing fields before nested fields.
                                  *lessOrEqual = left.begin < right.begin ||
                                                 (left.begin == right.begin &&
                                                  left.end > right.end);
                                  return true;
                              }));

    // Deallocate the scratch space.
    if (!fields.resize(fieldsLen))
        return false;

    // Third, iterate over the sorted field list to generate a sequence of
    // parts (what ECMA-402 actually exposes).  A part is a maximal character
    // sequence entirely within no field or a single most-nested field.
    //
    // Diagrams may be helpful to illustrate how fields map to parts.  Consider
    // formatting -19,766,580,028,249.41, the US national surplus (negative
    // because it's actually a debt) on October 18, 2016.
    //
    //    var options =
    //      { style: "currency", currency: "USD", currencyDisplay: "name" };
    //    var usdFormatter = new Intl.NumberFormat("en-US", options);
    //    usdFormatter.format(-19766580028249.41);
    //
    // The formatted result is "-19,766,580,028,249.41 US dollars".  ICU
    // identifies these fields in the string:
    //
    //     UNUM_GROUPING_SEPARATOR_FIELD
    //                   |
    //   UNUM_SIGN_FIELD |  UNUM_DECIMAL_SEPARATOR_FIELD
    //    |   __________/|   |
    //    |  /   |   |   |   |
    //   "-19,766,580,028,249.41 US dollars"
    //     \________________/ |/ \_______/
    //             |          |      |
    //    UNUM_INTEGER_FIELD  |  UNUM_CURRENCY_FIELD
    //                        |
    //               UNUM_FRACTION_FIELD
    //
    // These fields map to parts as follows:
    //
    //         integer     decimal
    //       _____|________  |
    //      /  /| |\  |\  |\ |  literal
    //     /| / | | \ | \ | \|  |
    //   "-19,766,580,028,249.41 US dollars"
    //    |  \___|___|___/    |/ \________/
    //    |        |          |       |
    //    |      group        |   currency
    //    |                   |
    //   minusSign        fraction
    //
    // The sign is a part.  Each comma is a part, splitting the integer field
    // into parts for trillions/billions/&c. digits.  The decimal point is a
    // part.  Cents are a part.  The space between cents and currency is a part
    // (outside any field).  Last, the currency field is a part.
    //
    // Because parts fully partition the formatted string, we only track the
    // end of each part -- the beginning is implicitly the last part's end.
    struct Part
    {
        uint32_t end;
        FieldType type;
    };

    class PartGenerator
    {
        // The fields in order from start to end, then least to most nested.
        const FieldsVector& fields;

        // Index of the current field, in |fields|, being considered to
        // determine part boundaries.  |lastEnd <= fields[index].begin| is an
        // invariant.
        size_t index;

        // The end index of the last part produced, always less than or equal
        // to |limit|, strictly increasing.
        uint32_t lastEnd;

        // The length of the overall formatted string.
        const uint32_t limit;

        Vector<size_t, 4> enclosingFields;

        void popEnclosingFieldsEndingAt(uint32_t end) {
            MOZ_ASSERT_IF(enclosingFields.length() > 0,
                          fields[enclosingFields.back()].end >= end);

            while (enclosingFields.length() > 0 && fields[enclosingFields.back()].end == end)
                enclosingFields.popBack();
        }

        bool nextPartInternal(Part* part) {
            size_t len = fields.length();
            MOZ_ASSERT(index <= len);

            // If we're out of fields, all that remains are part(s) consisting
            // of trailing portions of enclosing fields, and maybe a final
            // literal part.
            if (index == len) {
                if (enclosingFields.length() > 0) {
                    const auto& enclosing = fields[enclosingFields.popCopy()];
                    part->end = enclosing.end;
                    part->type = enclosing.type;

                    // If additional enclosing fields end where this part ends,
                    // pop them as well.
                    popEnclosingFieldsEndingAt(part->end);
                } else {
                    part->end = limit;
                    part->type = &JSAtomState::literal;
                }

                return true;
            }

            // Otherwise we still have a field to process.
            const Field* current = &fields[index];
            MOZ_ASSERT(lastEnd <= current->begin);
            MOZ_ASSERT(current->begin < current->end);

            // But first, deal with inter-field space.
            if (lastEnd < current->begin) {
                if (enclosingFields.length() > 0) {
                    // Space between fields, within an enclosing field, is part
                    // of that enclosing field, until the start of the current
                    // field or the end of the enclosing field, whichever is
                    // earlier.
                    const auto& enclosing = fields[enclosingFields.back()];
                    part->end = std::min(enclosing.end, current->begin);
                    part->type = enclosing.type;
                    popEnclosingFieldsEndingAt(part->end);
                } else {
                    // If there's no enclosing field, the space is a literal.
                    part->end = current->begin;
                    part->type = &JSAtomState::literal;
                }

                return true;
            }

            // Otherwise, the part spans a prefix of the current field.  Find
            // the most-nested field containing that prefix.
            const Field* next;
            do {
                current = &fields[index];

                // If the current field is last, the part extends to its end.
                if (++index == len) {
                    part->end = current->end;
                    part->type = current->type;
                    return true;
                }

                next = &fields[index];
                MOZ_ASSERT(current->begin <= next->begin);
                MOZ_ASSERT(current->begin < next->end);

                // If the next field nests within the current field, push an
                // enclosing field.  (If there are no nested fields, don't
                // bother pushing a field that'd be immediately popped.)
                if (current->end > next->begin) {
                    if (!enclosingFields.append(index - 1))
                        return false;
                }

                // Do so until the next field begins after this one.
            } while (current->begin == next->begin);

            part->type = current->type;

            if (current->end <= next->begin) {
                // The next field begins after the current field ends.  Therefore
                // the current part ends at the end of the current field.
                part->end = current->end;
                popEnclosingFieldsEndingAt(part->end);
            } else {
                // The current field encloses the next one.  The current part
                // ends where the next field/part will start.
                part->end = next->begin;
            }

            return true;
        }

      public:
        PartGenerator(JSContext* cx, const FieldsVector& vec, uint32_t limit)
          : fields(vec), index(0), lastEnd(0), limit(limit), enclosingFields(cx)
        {}

        bool nextPart(bool* hasPart, Part* part) {
            // There are no parts left if we've partitioned the entire string.
            if (lastEnd == limit) {
                MOZ_ASSERT(enclosingFields.length() == 0);
                *hasPart = false;
                return true;
            }

            if (!nextPartInternal(part))
                return false;

            *hasPart = true;
            lastEnd = part->end;
            return true;
        }
    };

    // Finally, generate the result array.
    size_t lastEndIndex = 0;
    uint32_t partIndex = 0;
    RootedObject singlePart(cx);
    RootedValue propVal(cx);

    PartGenerator gen(cx, fields, overallResult->length());
    do {
        bool hasPart;
        Part part;
        if (!gen.nextPart(&hasPart, &part))
            return false;

        if (!hasPart)
            break;

        FieldType type = part.type;
        size_t endIndex = part.end;

        MOZ_ASSERT(lastEndIndex < endIndex);

        singlePart = NewBuiltinClassInstance<PlainObject>(cx);
        if (!singlePart)
            return false;

        propVal.setString(cx->names().*type);
        if (!DefineProperty(cx, singlePart, cx->names().type, propVal))
            return false;

        JSLinearString* partSubstr =
            NewDependentString(cx, overallResult, lastEndIndex, endIndex - lastEndIndex);
        if (!partSubstr)
            return false;

        propVal.setString(partSubstr);
        if (!DefineProperty(cx, singlePart, cx->names().value, propVal))
            return false;

        propVal.setObject(*singlePart);
        if (!DefineElement(cx, partsArray, partIndex, propVal))
            return false;

        lastEndIndex = endIndex;
        partIndex++;
    } while (true);

    MOZ_ASSERT(lastEndIndex == overallResult->length(),
               "result array must partition the entire string");

    result.setObject(*partsArray);
    return true;
}

#endif // defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)

bool
js::intl_FormatNumber(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 3);
    MOZ_ASSERT(args[0].isObject());
    MOZ_ASSERT(args[1].isNumber());
    MOZ_ASSERT(args[2].isBoolean());

    Rooted<NumberFormatObject*> numberFormat(cx, &args[0].toObject().as<NumberFormatObject>());

    // Obtain a cached UNumberFormat object.
    void* priv =
        numberFormat->getReservedSlot(NumberFormatObject::UNUMBER_FORMAT_SLOT).toPrivate();
    UNumberFormat* nf = static_cast<UNumberFormat*>(priv);
    if (!nf) {
        nf = NewUNumberFormat(cx, numberFormat);
        if (!nf)
            return false;
        numberFormat->setReservedSlot(NumberFormatObject::UNUMBER_FORMAT_SLOT, PrivateValue(nf));
    }

    // Use the UNumberFormat to actually format the number.
#if defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)
    if (args[2].toBoolean()) {
        return intl_FormatNumberToParts(cx, nf, args[1].toNumber(), args.rval());
    }
#else
    MOZ_ASSERT(!args[2].toBoolean(),
               "shouldn't be doing formatToParts without an ICU that "
               "supports it");
#endif // defined(ICU_UNUM_HAS_FORMATDOUBLEFORFIELDS)
    return intl_FormatNumber(cx, nf, args[1].toNumber(), args.rval());
}


/******************** DateTimeFormat ********************/

const ClassOps DateTimeFormatObject::classOps_ = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    DateTimeFormatObject::finalize
};

const Class DateTimeFormatObject::class_ = {
    js_Object_str,
    JSCLASS_HAS_RESERVED_SLOTS(DateTimeFormatObject::SLOT_COUNT) |
    JSCLASS_FOREGROUND_FINALIZE,
    &DateTimeFormatObject::classOps_
};

#if JS_HAS_TOSOURCE
static bool
dateTimeFormat_toSource(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setString(cx->names().DateTimeFormat);
    return true;
}
#endif

static const JSFunctionSpec dateTimeFormat_static_methods[] = {
    JS_SELF_HOSTED_FN("supportedLocalesOf", "Intl_DateTimeFormat_supportedLocalesOf", 1, 0),
    JS_FS_END
};

static const JSFunctionSpec dateTimeFormat_methods[] = {
    JS_SELF_HOSTED_FN("resolvedOptions", "Intl_DateTimeFormat_resolvedOptions", 0, 0),
    JS_SELF_HOSTED_FN("formatToParts", "Intl_DateTimeFormat_formatToParts", 1, 0),
#if JS_HAS_TOSOURCE
    JS_FN(js_toSource_str, dateTimeFormat_toSource, 0, 0),
#endif
    JS_FS_END
};

static const JSPropertySpec dateTimeFormat_properties[] = {
    JS_SELF_HOSTED_GET("format", "Intl_DateTimeFormat_format_get", 0),
    JS_STRING_SYM_PS(toStringTag, "Object", JSPROP_READONLY),
    JS_PS_END
};

/**
 * 12.2.1 Intl.DateTimeFormat([ locales [, options]])
 *
 * ES2017 Intl draft rev 94045d234762ad107a3d09bb6f7381a65f1a2f9b
 */
static bool
DateTimeFormat(JSContext* cx, const CallArgs& args, bool construct, DateTimeFormatOptions dtfOptions)
{
    // Step 1 (Handled by OrdinaryCreateFromConstructor fallback code).

    // Step 2 (Inlined 9.1.14, OrdinaryCreateFromConstructor).
    RootedObject proto(cx);
    if (args.isConstructing() && !GetPrototypeFromCallableConstructor(cx, args, &proto))
        return false;

    if (!proto) {
        proto = GlobalObject::getOrCreateDateTimeFormatPrototype(cx, cx->global());
        if (!proto)
            return false;
    }

    Rooted<DateTimeFormatObject*> dateTimeFormat(cx);
    dateTimeFormat = NewObjectWithGivenProto<DateTimeFormatObject>(cx, proto);
    if (!dateTimeFormat)
        return false;

    dateTimeFormat->setReservedSlot(DateTimeFormatObject::INTERNALS_SLOT, NullValue());
    dateTimeFormat->setReservedSlot(DateTimeFormatObject::UDATE_FORMAT_SLOT,
                                    PrivateValue(nullptr));

    RootedValue thisValue(cx, construct ? ObjectValue(*dateTimeFormat) : args.thisv());
    RootedValue locales(cx, args.get(0));
    RootedValue options(cx, args.get(1));

    // Step 3.
    return LegacyIntlInitialize(cx, dateTimeFormat, cx->names().InitializeDateTimeFormat,
                                thisValue, locales, options, dtfOptions, args.rval());
}

static bool
DateTimeFormat(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    return DateTimeFormat(cx, args, args.isConstructing(), DateTimeFormatOptions::Standard);
}

static bool
MozDateTimeFormat(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Don't allow to call mozIntl.DateTimeFormat as a function. That way we
    // don't need to worry how to handle the legacy initialization semantics
    // when applied on mozIntl.DateTimeFormat.
    if (!ThrowIfNotConstructing(cx, args, "mozIntl.DateTimeFormat"))
        return false;

    return DateTimeFormat(cx, args, true, DateTimeFormatOptions::EnableMozExtensions);
}

bool
js::intl_DateTimeFormat(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(!args.isConstructing());
    // intl_DateTimeFormat is an intrinsic for self-hosted JavaScript, so it
    // cannot be used with "new", but it still has to be treated as a
    // constructor.
    return DateTimeFormat(cx, args, true, DateTimeFormatOptions::Standard);
}

void
DateTimeFormatObject::finalize(FreeOp* fop, JSObject* obj)
{
    MOZ_ASSERT(fop->onActiveCooperatingThread());

    const Value& slot =
        obj->as<DateTimeFormatObject>().getReservedSlot(DateTimeFormatObject::UDATE_FORMAT_SLOT);
    if (UDateFormat* df = static_cast<UDateFormat*>(slot.toPrivate()))
        udat_close(df);
}

static JSObject*
CreateDateTimeFormatPrototype(JSContext* cx, HandleObject Intl, Handle<GlobalObject*> global,
                              MutableHandleObject constructor, DateTimeFormatOptions dtfOptions)
{
    RootedFunction ctor(cx);
    ctor = dtfOptions == DateTimeFormatOptions::EnableMozExtensions
           ? GlobalObject::createConstructor(cx, MozDateTimeFormat, cx->names().DateTimeFormat, 0)
           : GlobalObject::createConstructor(cx, DateTimeFormat, cx->names().DateTimeFormat, 0);
    if (!ctor)
        return nullptr;

    RootedObject proto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!proto)
        return nullptr;

    if (!LinkConstructorAndPrototype(cx, ctor, proto))
        return nullptr;

    // 12.3.2
    if (!JS_DefineFunctions(cx, ctor, dateTimeFormat_static_methods))
        return nullptr;

    // 12.4.4 and 12.4.5
    if (!JS_DefineFunctions(cx, proto, dateTimeFormat_methods))
        return nullptr;

    // 12.4.2 and 12.4.3
    if (!JS_DefineProperties(cx, proto, dateTimeFormat_properties))
        return nullptr;

    // 8.1
    RootedValue ctorValue(cx, ObjectValue(*ctor));
    if (!DefineProperty(cx, Intl, cx->names().DateTimeFormat, ctorValue, nullptr, nullptr, 0))
        return nullptr;

    constructor.set(ctor);
    return proto;
}

bool
js::AddMozDateTimeFormatConstructor(JSContext* cx, JS::Handle<JSObject*> intl)
{
    Handle<GlobalObject*> global = cx->global();

    RootedObject mozDateTimeFormat(cx);
    JSObject* mozDateTimeFormatProto =
        CreateDateTimeFormatPrototype(cx, intl, global, &mozDateTimeFormat, DateTimeFormatOptions::EnableMozExtensions);
    return mozDateTimeFormatProto != nullptr;
}

bool
js::intl_DateTimeFormat_availableLocales(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    RootedValue result(cx);
    if (!intl_availableLocales(cx, udat_countAvailable, udat_getAvailable, &result))
        return false;
    args.rval().set(result);
    return true;
}

static bool
DefaultCalendar(JSContext* cx, const JSAutoByteString& locale, MutableHandleValue rval)
{
    UErrorCode status = U_ZERO_ERROR;
    UCalendar* cal = ucal_open(nullptr, 0, locale.ptr(), UCAL_DEFAULT, &status);

    // This correctly handles nullptr |cal| when opening failed.
    ScopedICUObject<UCalendar, ucal_close> closeCalendar(cal);

    const char* calendar = ucal_getType(cal, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    // ICU returns old-style keyword values; map them to BCP 47 equivalents
    JSString* str = JS_NewStringCopyZ(cx, uloc_toUnicodeLocaleType("ca", calendar));
    if (!str)
        return false;

    rval.setString(str);
    return true;
}

struct CalendarAlias
{
    const char* const calendar;
    const char* const alias;
};

const CalendarAlias calendarAliases[] = {
    { "islamic-civil", "islamicc" },
    { "ethioaa", "ethiopic-amete-alem" }
};

bool
js::intl_availableCalendars(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    RootedObject calendars(cx, NewDenseEmptyArray(cx));
    if (!calendars)
        return false;
    uint32_t index = 0;

    // We need the default calendar for the locale as the first result.
    RootedValue element(cx);
    if (!DefaultCalendar(cx, locale, &element))
        return false;

    if (!DefineElement(cx, calendars, index++, element))
        return false;

    // Now get the calendars that "would make a difference", i.e., not the default.
    UErrorCode status = U_ZERO_ERROR;
    UEnumeration* values = ucal_getKeywordValuesForLocale("ca", locale.ptr(), false, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UEnumeration, uenum_close> toClose(values);

    uint32_t count = uenum_count(values, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    for (; count > 0; count--) {
        const char* calendar = uenum_next(values, nullptr, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        // ICU returns old-style keyword values; map them to BCP 47 equivalents
        calendar = uloc_toUnicodeLocaleType("ca", calendar);

        JSString* jscalendar = JS_NewStringCopyZ(cx, calendar);
        if (!jscalendar)
            return false;
        element = StringValue(jscalendar);
        if (!DefineElement(cx, calendars, index++, element))
            return false;

        // ICU doesn't return calendar aliases, append them here.
        for (const auto& calendarAlias : calendarAliases) {
            if (equal(calendar, calendarAlias.calendar)) {
                JSString* jscalendar = JS_NewStringCopyZ(cx, calendarAlias.alias);
                if (!jscalendar)
                    return false;
                element = StringValue(jscalendar);
                if (!DefineElement(cx, calendars, index++, element))
                    return false;
            }
        }
    }

    args.rval().setObject(*calendars);
    return true;
}

bool
js::intl_defaultCalendar(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    return DefaultCalendar(cx, locale, args.rval());
}

template<typename Char>
static constexpr Char
ToUpperASCII(Char c)
{
    return ('a' <= c && c <= 'z')
           ? (c & ~0x20)
           : c;
}

static_assert(ToUpperASCII('a') == 'A', "verifying 'a' uppercases correctly");
static_assert(ToUpperASCII('m') == 'M', "verifying 'm' uppercases correctly");
static_assert(ToUpperASCII('z') == 'Z', "verifying 'z' uppercases correctly");
static_assert(ToUpperASCII(u'a') == u'A', "verifying u'a' uppercases correctly");
static_assert(ToUpperASCII(u'k') == u'K', "verifying u'k' uppercases correctly");
static_assert(ToUpperASCII(u'z') == u'Z', "verifying u'z' uppercases correctly");

template<typename Char1, typename Char2>
static bool
EqualCharsIgnoreCaseASCII(const Char1* s1, const Char2* s2, size_t len)
{
    for (const Char1* s1end = s1 + len; s1 < s1end; s1++, s2++) {
        if (ToUpperASCII(*s1) != ToUpperASCII(*s2))
            return false;
    }
    return true;
}

template<typename Char>
static js::HashNumber
HashStringIgnoreCaseASCII(const Char* s, size_t length)
{
    uint32_t hash = 0;
    for (size_t i = 0; i < length; i++)
        hash = mozilla::AddToHash(hash, ToUpperASCII(s[i]));
    return hash;
}

js::SharedIntlData::TimeZoneHasher::Lookup::Lookup(JSLinearString* timeZone)
  : js::SharedIntlData::LinearStringLookup(timeZone)
{
    if (isLatin1)
        hash = HashStringIgnoreCaseASCII(latin1Chars, length);
    else
        hash = HashStringIgnoreCaseASCII(twoByteChars, length);
}

bool
js::SharedIntlData::TimeZoneHasher::match(TimeZoneName key, const Lookup& lookup)
{
    if (key->length() != lookup.length)
        return false;

    // Compare time zone names ignoring ASCII case differences.
    if (key->hasLatin1Chars()) {
        const Latin1Char* keyChars = key->latin1Chars(lookup.nogc);
        if (lookup.isLatin1)
            return EqualCharsIgnoreCaseASCII(keyChars, lookup.latin1Chars, lookup.length);
        return EqualCharsIgnoreCaseASCII(keyChars, lookup.twoByteChars, lookup.length);
    }

    const char16_t* keyChars = key->twoByteChars(lookup.nogc);
    if (lookup.isLatin1)
        return EqualCharsIgnoreCaseASCII(lookup.latin1Chars, keyChars, lookup.length);
    return EqualCharsIgnoreCaseASCII(keyChars, lookup.twoByteChars, lookup.length);
}

static bool
IsLegacyICUTimeZone(const char* timeZone)
{
    for (const auto& legacyTimeZone : js::timezone::legacyICUTimeZones) {
        if (equal(timeZone, legacyTimeZone))
            return true;
    }
    return false;
}

bool
js::SharedIntlData::ensureTimeZones(JSContext* cx)
{
    if (timeZoneDataInitialized)
        return true;

    // If ensureTimeZones() was called previously, but didn't complete due to
    // OOM, clear all sets/maps and start from scratch.
    if (availableTimeZones.initialized())
        availableTimeZones.finish();
    if (!availableTimeZones.init()) {
        ReportOutOfMemory(cx);
        return false;
    }

    UErrorCode status = U_ZERO_ERROR;
    UEnumeration* values = ucal_openTimeZones(&status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UEnumeration, uenum_close> toClose(values);

    RootedAtom timeZone(cx);
    while (true) {
        int32_t size;
        const char* rawTimeZone = uenum_next(values, &size, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        if (rawTimeZone == nullptr)
            break;

        // Skip legacy ICU time zone names.
        if (IsLegacyICUTimeZone(rawTimeZone))
            continue;

        MOZ_ASSERT(size >= 0);
        timeZone = Atomize(cx, rawTimeZone, size_t(size));
        if (!timeZone)
            return false;

        TimeZoneHasher::Lookup lookup(timeZone);
        TimeZoneSet::AddPtr p = availableTimeZones.lookupForAdd(lookup);

        // ICU shouldn't report any duplicate time zone names, but if it does,
        // just ignore the duplicate name.
        if (!p && !availableTimeZones.add(p, timeZone)) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    if (ianaZonesTreatedAsLinksByICU.initialized())
        ianaZonesTreatedAsLinksByICU.finish();
    if (!ianaZonesTreatedAsLinksByICU.init()) {
        ReportOutOfMemory(cx);
        return false;
    }

    for (const char* rawTimeZone : timezone::ianaZonesTreatedAsLinksByICU) {
        MOZ_ASSERT(rawTimeZone != nullptr);
        timeZone = Atomize(cx, rawTimeZone, strlen(rawTimeZone));
        if (!timeZone)
            return false;

        TimeZoneHasher::Lookup lookup(timeZone);
        TimeZoneSet::AddPtr p = ianaZonesTreatedAsLinksByICU.lookupForAdd(lookup);
        MOZ_ASSERT(!p, "Duplicate entry in timezone::ianaZonesTreatedAsLinksByICU");

        if (!ianaZonesTreatedAsLinksByICU.add(p, timeZone)) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    if (ianaLinksCanonicalizedDifferentlyByICU.initialized())
        ianaLinksCanonicalizedDifferentlyByICU.finish();
    if (!ianaLinksCanonicalizedDifferentlyByICU.init()) {
        ReportOutOfMemory(cx);
        return false;
    }

    RootedAtom linkName(cx);
    RootedAtom& target = timeZone;
    for (const auto& linkAndTarget : timezone::ianaLinksCanonicalizedDifferentlyByICU) {
        const char* rawLinkName = linkAndTarget.link;
        const char* rawTarget = linkAndTarget.target;

        MOZ_ASSERT(rawLinkName != nullptr);
        linkName = Atomize(cx, rawLinkName, strlen(rawLinkName));
        if (!linkName)
            return false;

        MOZ_ASSERT(rawTarget != nullptr);
        target = Atomize(cx, rawTarget, strlen(rawTarget));
        if (!target)
            return false;

        TimeZoneHasher::Lookup lookup(linkName);
        TimeZoneMap::AddPtr p = ianaLinksCanonicalizedDifferentlyByICU.lookupForAdd(lookup);
        MOZ_ASSERT(!p, "Duplicate entry in timezone::ianaLinksCanonicalizedDifferentlyByICU");

        if (!ianaLinksCanonicalizedDifferentlyByICU.add(p, linkName, target)) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    MOZ_ASSERT(!timeZoneDataInitialized, "ensureTimeZones is neither reentrant nor thread-safe");
    timeZoneDataInitialized = true;

    return true;
}

bool
js::SharedIntlData::validateTimeZoneName(JSContext* cx, HandleString timeZone,
                                         MutableHandleAtom result)
{
    if (!ensureTimeZones(cx))
        return false;

    RootedLinearString timeZoneLinear(cx, timeZone->ensureLinear(cx));
    if (!timeZoneLinear)
        return false;

    TimeZoneHasher::Lookup lookup(timeZoneLinear);
    if (TimeZoneSet::Ptr p = availableTimeZones.lookup(lookup))
        result.set(*p);

    return true;
}

bool
js::SharedIntlData::tryCanonicalizeTimeZoneConsistentWithIANA(JSContext* cx, HandleString timeZone,
                                                              MutableHandleAtom result)
{
    if (!ensureTimeZones(cx))
        return false;

    RootedLinearString timeZoneLinear(cx, timeZone->ensureLinear(cx));
    if (!timeZoneLinear)
        return false;

    TimeZoneHasher::Lookup lookup(timeZoneLinear);
    MOZ_ASSERT(availableTimeZones.has(lookup), "Invalid time zone name");

    if (TimeZoneMap::Ptr p = ianaLinksCanonicalizedDifferentlyByICU.lookup(lookup)) {
        // The effectively supported time zones aren't known at compile time,
        // when
        // 1. SpiderMonkey was compiled with "--with-system-icu".
        // 2. ICU's dynamic time zone data loading feature was used.
        //    (ICU supports loading time zone files at runtime through the
        //    ICU_TIMEZONE_FILES_DIR environment variable.)
        // Ensure ICU supports the new target zone before applying the update.
        TimeZoneName targetTimeZone = p->value();
        TimeZoneHasher::Lookup targetLookup(targetTimeZone);
        if (availableTimeZones.has(targetLookup))
            result.set(targetTimeZone);
    } else if (TimeZoneSet::Ptr p = ianaZonesTreatedAsLinksByICU.lookup(lookup)) {
        result.set(*p);
    }

    return true;
}

void
js::SharedIntlData::destroyInstance()
{
    availableTimeZones.finish();
    ianaZonesTreatedAsLinksByICU.finish();
    ianaLinksCanonicalizedDifferentlyByICU.finish();
    upperCaseFirstLocales.finish();
}

void
js::SharedIntlData::trace(JSTracer* trc)
{
    // Atoms are always tenured.
    if (!JS::CurrentThreadIsHeapMinorCollecting()) {
        availableTimeZones.trace(trc);
        ianaZonesTreatedAsLinksByICU.trace(trc);
        ianaLinksCanonicalizedDifferentlyByICU.trace(trc);
        upperCaseFirstLocales.trace(trc);
    }
}

size_t
js::SharedIntlData::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const
{
    return availableTimeZones.sizeOfExcludingThis(mallocSizeOf) +
           ianaZonesTreatedAsLinksByICU.sizeOfExcludingThis(mallocSizeOf) +
           ianaLinksCanonicalizedDifferentlyByICU.sizeOfExcludingThis(mallocSizeOf) +
           upperCaseFirstLocales.sizeOfExcludingThis(mallocSizeOf);
}

bool
js::intl_IsValidTimeZoneName(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    SharedIntlData& sharedIntlData = cx->runtime()->sharedIntlData.ref();

    RootedString timeZone(cx, args[0].toString());
    RootedAtom validatedTimeZone(cx);
    if (!sharedIntlData.validateTimeZoneName(cx, timeZone, &validatedTimeZone))
        return false;

    if (validatedTimeZone) {
        cx->markAtom(validatedTimeZone);
        args.rval().setString(validatedTimeZone);
    } else {
        args.rval().setNull();
    }

    return true;
}

bool
js::intl_canonicalizeTimeZone(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);
    MOZ_ASSERT(args[0].isString());

    SharedIntlData& sharedIntlData = cx->runtime()->sharedIntlData.ref();

    // Some time zone names are canonicalized differently by ICU -- handle
    // those first:
    RootedString timeZone(cx, args[0].toString());
    RootedAtom ianaTimeZone(cx);
    if (!sharedIntlData.tryCanonicalizeTimeZoneConsistentWithIANA(cx, timeZone, &ianaTimeZone))
        return false;

    if (ianaTimeZone) {
        cx->markAtom(ianaTimeZone);
        args.rval().setString(ianaTimeZone);
        return true;
    }

    AutoStableStringChars stableChars(cx);
    if (!stableChars.initTwoByte(cx, timeZone))
        return false;

    mozilla::Range<const char16_t> tzchars = stableChars.twoByteRange();

    JSString* str = Call(cx, [&tzchars](UChar* chars, uint32_t size, UErrorCode* status) {
        return ucal_getCanonicalTimeZoneID(Char16ToUChar(tzchars.begin().get()), tzchars.length(),
                                           chars, size, nullptr, status);
    });
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}

bool
js::intl_defaultTimeZone(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    // The current default might be stale, because JS::ResetTimeZone() doesn't
    // immediately update ICU's default time zone. So perform an update if
    // needed.
    js::ResyncICUDefaultTimeZone();

    JSString* str = Call(cx, ucal_getDefaultTimeZone);
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}

bool
js::intl_defaultTimeZoneOffset(JSContext* cx, unsigned argc, Value* vp) {
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    UErrorCode status = U_ZERO_ERROR;
    const UChar* uTimeZone = nullptr;
    int32_t uTimeZoneLength = 0;
    const char* rootLocale = "";
    UCalendar* cal = ucal_open(uTimeZone, uTimeZoneLength, rootLocale, UCAL_DEFAULT, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UCalendar, ucal_close> toClose(cal);

    int32_t offset = ucal_get(cal, UCAL_ZONE_OFFSET, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    args.rval().setInt32(offset);
    return true;
}

bool
js::intl_patternForSkeleton(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(args[0].isString());
    MOZ_ASSERT(args[1].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    AutoStableStringChars skeleton(cx);
    if (!skeleton.initTwoByte(cx, args[1].toString()))
        return false;

    mozilla::Range<const char16_t> skelChars = skeleton.twoByteRange();

    UErrorCode status = U_ZERO_ERROR;
    UDateTimePatternGenerator* gen = udatpg_open(icuLocale(locale.ptr()), &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UDateTimePatternGenerator, udatpg_close> toClose(gen);

    JSString* str = Call(cx, [gen, &skelChars](UChar* chars, uint32_t size, UErrorCode* status) {
        return udatpg_getBestPattern(gen, Char16ToUChar(skelChars.begin().get()),
                                     skelChars.length(), chars, size, status);
    });
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}

bool
js::intl_patternForStyle(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 4);
    MOZ_ASSERT(args[0].isString());

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    UDateFormatStyle dateStyle = UDAT_NONE;
    UDateFormatStyle timeStyle = UDAT_NONE;

    if (args[1].isString()) {
        JSLinearString* dateStyleStr = args[1].toString()->ensureLinear(cx);
        if (!dateStyleStr)
            return false;

        if (StringEqualsAscii(dateStyleStr, "full"))
            dateStyle = UDAT_FULL;
        else if (StringEqualsAscii(dateStyleStr, "long"))
            dateStyle = UDAT_LONG;
        else if (StringEqualsAscii(dateStyleStr, "medium"))
            dateStyle = UDAT_MEDIUM;
        else if (StringEqualsAscii(dateStyleStr, "short"))
            dateStyle = UDAT_SHORT;
        else
            MOZ_ASSERT_UNREACHABLE("unexpected dateStyle");
    }

    if (args[2].isString()) {
        JSLinearString* timeStyleStr = args[2].toString()->ensureLinear(cx);
        if (!timeStyleStr)
            return false;

        if (StringEqualsAscii(timeStyleStr, "full"))
            timeStyle = UDAT_FULL;
        else if (StringEqualsAscii(timeStyleStr, "long"))
            timeStyle = UDAT_LONG;
        else if (StringEqualsAscii(timeStyleStr, "medium"))
            timeStyle = UDAT_MEDIUM;
        else if (StringEqualsAscii(timeStyleStr, "short"))
            timeStyle = UDAT_SHORT;
        else
            MOZ_ASSERT_UNREACHABLE("unexpected timeStyle");
    }

    AutoStableStringChars timeZone(cx);
    if (!timeZone.initTwoByte(cx, args[3].toString()))
        return false;

    mozilla::Range<const char16_t> timeZoneChars = timeZone.twoByteRange();

    UErrorCode status = U_ZERO_ERROR;
    UDateFormat* df = udat_open(timeStyle, dateStyle, icuLocale(locale.ptr()),
                                Char16ToUChar(timeZoneChars.begin().get()),
                                timeZoneChars.length(), nullptr, -1, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UDateFormat, udat_close> toClose(df);

    JSString* str = Call(cx, [df](UChar* chars, uint32_t size, UErrorCode* status) {
        return udat_toPattern(df, false, chars, size, status);
    });
    if (!str)
        return false;
    args.rval().setString(str);
    return true;
}

/**
 * Returns a new UDateFormat with the locale and date-time formatting options
 * of the given DateTimeFormat.
 */
static UDateFormat*
NewUDateFormat(JSContext* cx, Handle<DateTimeFormatObject*> dateTimeFormat)
{
    RootedValue value(cx);

    RootedObject internals(cx, GetInternals(cx, dateTimeFormat));
    if (!internals)
       return nullptr;

    if (!GetProperty(cx, internals, internals, cx->names().locale, &value))
        return nullptr;
    JSAutoByteString locale(cx, value.toString());
    if (!locale)
        return nullptr;

    // We don't need to look at calendar and numberingSystem - they can only be
    // set via the Unicode locale extension and are therefore already set on
    // locale.

    if (!GetProperty(cx, internals, internals, cx->names().timeZone, &value))
        return nullptr;

    AutoStableStringChars timeZone(cx);
    if (!timeZone.initTwoByte(cx, value.toString()))
        return nullptr;

    mozilla::Range<const char16_t> timeZoneChars = timeZone.twoByteRange();

    if (!GetProperty(cx, internals, internals, cx->names().pattern, &value))
        return nullptr;

    AutoStableStringChars pattern(cx);
    if (!pattern.initTwoByte(cx, value.toString()))
        return nullptr;

    mozilla::Range<const char16_t> patternChars = pattern.twoByteRange();

    UErrorCode status = U_ZERO_ERROR;
    UDateFormat* df =
        udat_open(UDAT_PATTERN, UDAT_PATTERN, icuLocale(locale.ptr()),
                  Char16ToUChar(timeZoneChars.begin().get()), timeZoneChars.length(),
                  Char16ToUChar(patternChars.begin().get()), patternChars.length(), &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return nullptr;
    }

    // ECMAScript requires the Gregorian calendar to be used from the beginning
    // of ECMAScript time.
    UCalendar* cal = const_cast<UCalendar*>(udat_getCalendar(df));
    ucal_setGregorianChange(cal, StartOfTime, &status);

    // An error here means the calendar is not Gregorian, so we don't care.

    return df;
}

static bool
intl_FormatDateTime(JSContext* cx, UDateFormat* df, double x, MutableHandleValue result)
{
    if (!IsFinite(x)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_DATE_NOT_FINITE);
        return false;
    }

    JSString* str = Call(cx, [df, x](UChar* chars, int32_t size, UErrorCode* status) {
        return udat_format(df, x, chars, size, nullptr, status);
    });
    if (!str)
        return false;

    result.setString(str);
    return true;
}

static FieldType
GetFieldTypeForFormatField(UDateFormatField fieldName)
{
    // See intl/icu/source/i18n/unicode/udat.h for a detailed field list.  This
    // switch is deliberately exhaustive: cases might have to be added/removed
    // if this code is compiled with a different ICU with more
    // UDateFormatField enum initializers.  Please guard such cases with
    // appropriate ICU version-testing #ifdefs, should cross-version divergence
    // occur.
    switch (fieldName) {
      case UDAT_ERA_FIELD:
        return &JSAtomState::era;
      case UDAT_YEAR_FIELD:
      case UDAT_YEAR_WOY_FIELD:
      case UDAT_EXTENDED_YEAR_FIELD:
      case UDAT_YEAR_NAME_FIELD:
        return &JSAtomState::year;

      case UDAT_MONTH_FIELD:
      case UDAT_STANDALONE_MONTH_FIELD:
        return &JSAtomState::month;

      case UDAT_DATE_FIELD:
      case UDAT_JULIAN_DAY_FIELD:
        return &JSAtomState::day;

      case UDAT_HOUR_OF_DAY1_FIELD:
      case UDAT_HOUR_OF_DAY0_FIELD:
      case UDAT_HOUR1_FIELD:
      case UDAT_HOUR0_FIELD:
        return &JSAtomState::hour;

      case UDAT_MINUTE_FIELD:
        return &JSAtomState::minute;

      case UDAT_SECOND_FIELD:
        return &JSAtomState::second;

      case UDAT_DAY_OF_WEEK_FIELD:
      case UDAT_STANDALONE_DAY_FIELD:
      case UDAT_DOW_LOCAL_FIELD:
      case UDAT_DAY_OF_WEEK_IN_MONTH_FIELD:
        return &JSAtomState::weekday;

      case UDAT_AM_PM_FIELD:
        return &JSAtomState::dayPeriod;

      case UDAT_TIMEZONE_FIELD:
        return &JSAtomState::timeZoneName;

      case UDAT_FRACTIONAL_SECOND_FIELD:
      case UDAT_DAY_OF_YEAR_FIELD:
      case UDAT_WEEK_OF_YEAR_FIELD:
      case UDAT_WEEK_OF_MONTH_FIELD:
      case UDAT_MILLISECONDS_IN_DAY_FIELD:
      case UDAT_TIMEZONE_RFC_FIELD:
      case UDAT_TIMEZONE_GENERIC_FIELD:
      case UDAT_QUARTER_FIELD:
      case UDAT_STANDALONE_QUARTER_FIELD:
      case UDAT_TIMEZONE_SPECIAL_FIELD:
      case UDAT_TIMEZONE_LOCALIZED_GMT_OFFSET_FIELD:
      case UDAT_TIMEZONE_ISO_FIELD:
      case UDAT_TIMEZONE_ISO_LOCAL_FIELD:
#ifndef U_HIDE_INTERNAL_API
      case UDAT_RELATED_YEAR_FIELD:
#endif
#ifndef U_HIDE_DRAFT_API
      case UDAT_AM_PM_MIDNIGHT_NOON_FIELD:
      case UDAT_FLEXIBLE_DAY_PERIOD_FIELD:
#endif
#ifndef U_HIDE_INTERNAL_API
      case UDAT_TIME_SEPARATOR_FIELD:
#endif
        // These fields are all unsupported.
        return nullptr;

      case UDAT_FIELD_COUNT:
        MOZ_ASSERT_UNREACHABLE("format field sentinel value returned by "
                               "iterator!");
    }

    MOZ_ASSERT_UNREACHABLE("unenumerated, undocumented format field returned "
                           "by iterator");
    return nullptr;
}

static bool
intl_FormatToPartsDateTime(JSContext* cx, UDateFormat* df, double x, MutableHandleValue result)
{
    if (!IsFinite(x)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_DATE_NOT_FINITE);
        return false;
    }

    UErrorCode status = U_ZERO_ERROR;
    UFieldPositionIterator* fpositer = ufieldpositer_open(&status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UFieldPositionIterator, ufieldpositer_close> toClose(fpositer);

    RootedString overallResult(cx);
    overallResult = Call(cx, [df, x, fpositer](UChar* chars, int32_t size, UErrorCode* status) {
        return udat_formatForFields(df, x, chars, size, fpositer, status);
    });
    if (!overallResult)
        return false;

    RootedArrayObject partsArray(cx, NewDenseEmptyArray(cx));
    if (!partsArray)
        return false;

    if (overallResult->length() == 0) {
        // An empty string contains no parts, so avoid extra work below.
        result.setObject(*partsArray);
        return true;
    }

    size_t lastEndIndex = 0;

    uint32_t partIndex = 0;
    RootedObject singlePart(cx);
    RootedValue partType(cx);
    RootedValue val(cx);

    auto AppendPart = [&](FieldType type, size_t beginIndex, size_t endIndex) {
        singlePart = NewBuiltinClassInstance<PlainObject>(cx);
        if (!singlePart)
            return false;

        partType = StringValue(cx->names().*type);
        if (!DefineProperty(cx, singlePart, cx->names().type, partType))
            return false;

        JSLinearString* partSubstr =
            NewDependentString(cx, overallResult, beginIndex, endIndex - beginIndex);
        if (!partSubstr)
            return false;

        val = StringValue(partSubstr);
        if (!DefineProperty(cx, singlePart, cx->names().value, val))
            return false;

        val = ObjectValue(*singlePart);
        if (!DefineElement(cx, partsArray, partIndex, val))
            return false;

        lastEndIndex = endIndex;
        partIndex++;
        return true;
    };

    int32_t fieldInt, beginIndexInt, endIndexInt;
    while ((fieldInt = ufieldpositer_next(fpositer, &beginIndexInt, &endIndexInt)) >= 0) {
        MOZ_ASSERT(beginIndexInt >= 0);
        MOZ_ASSERT(endIndexInt >= 0);
        MOZ_ASSERT(beginIndexInt <= endIndexInt,
                   "field iterator returning invalid range");

        size_t beginIndex(beginIndexInt);
        size_t endIndex(endIndexInt);

        // Technically this isn't guaranteed.  But it appears true in pratice,
        // and http://bugs.icu-project.org/trac/ticket/12024 is expected to
        // correct the documentation lapse.
        MOZ_ASSERT(lastEndIndex <= beginIndex,
                   "field iteration didn't return fields in order start to "
                   "finish as expected");

        if (FieldType type = GetFieldTypeForFormatField(static_cast<UDateFormatField>(fieldInt))) {
            if (lastEndIndex < beginIndex) {
                if (!AppendPart(&JSAtomState::literal, lastEndIndex, beginIndex))
                    return false;
            }

            if (!AppendPart(type, beginIndex, endIndex))
                return false;
        }
    }

    // Append any final literal.
    if (lastEndIndex < overallResult->length()) {
        if (!AppendPart(&JSAtomState::literal, lastEndIndex, overallResult->length()))
            return false;
    }

    result.setObject(*partsArray);
    return true;
}

bool
js::intl_FormatDateTime(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 3);
    MOZ_ASSERT(args[0].isObject());
    MOZ_ASSERT(args[1].isNumber());
    MOZ_ASSERT(args[2].isBoolean());

    Rooted<DateTimeFormatObject*> dateTimeFormat(cx);
    dateTimeFormat = &args[0].toObject().as<DateTimeFormatObject>();

    // Obtain a cached UDateFormat object.
    void* priv =
        dateTimeFormat->getReservedSlot(DateTimeFormatObject::UDATE_FORMAT_SLOT).toPrivate();
    UDateFormat* df = static_cast<UDateFormat*>(priv);
    if (!df) {
        df = NewUDateFormat(cx, dateTimeFormat);
        if (!df)
            return false;
        dateTimeFormat->setReservedSlot(DateTimeFormatObject::UDATE_FORMAT_SLOT, PrivateValue(df));
    }

    // Use the UDateFormat to actually format the time stamp.
    return args[2].toBoolean()
           ? intl_FormatToPartsDateTime(cx, df, args[1].toNumber(), args.rval())
           : intl_FormatDateTime(cx, df, args[1].toNumber(), args.rval());
}


/**************** PluralRules *****************/

const ClassOps PluralRulesObject::classOps_ = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    PluralRulesObject::finalize
};

const Class PluralRulesObject::class_ = {
    js_Object_str,
    JSCLASS_HAS_RESERVED_SLOTS(PluralRulesObject::SLOT_COUNT) |
    JSCLASS_FOREGROUND_FINALIZE,
    &PluralRulesObject::classOps_
};

#if JS_HAS_TOSOURCE
static bool
pluralRules_toSource(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setString(cx->names().PluralRules);
    return true;
}
#endif

static const JSFunctionSpec pluralRules_static_methods[] = {
    JS_SELF_HOSTED_FN("supportedLocalesOf", "Intl_PluralRules_supportedLocalesOf", 1, 0),
    JS_FS_END
};

static const JSFunctionSpec pluralRules_methods[] = {
    JS_SELF_HOSTED_FN("resolvedOptions", "Intl_PluralRules_resolvedOptions", 0, 0),
    JS_SELF_HOSTED_FN("select", "Intl_PluralRules_select", 1, 0),
#if JS_HAS_TOSOURCE
    JS_FN(js_toSource_str, pluralRules_toSource, 0, 0),
#endif
    JS_FS_END
};

/**
 * PluralRules constructor.
 * Spec: ECMAScript 402 API, PluralRules, 1.1
 */
static bool
PluralRules(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);

    // Step 1.
    if (!ThrowIfNotConstructing(cx, args, "Intl.PluralRules"))
        return false;

    // Step 2 (Inlined 9.1.14, OrdinaryCreateFromConstructor).
    RootedObject proto(cx);
    if (!GetPrototypeFromCallableConstructor(cx, args, &proto))
        return false;

    if (!proto) {
        proto = GlobalObject::getOrCreatePluralRulesPrototype(cx, cx->global());
        if (!proto)
            return false;
    }

    Rooted<PluralRulesObject*> pluralRules(cx);
    pluralRules = NewObjectWithGivenProto<PluralRulesObject>(cx, proto);
    if (!pluralRules)
        return false;

    pluralRules->setReservedSlot(PluralRulesObject::INTERNALS_SLOT, NullValue());
    pluralRules->setReservedSlot(PluralRulesObject::UPLURAL_RULES_SLOT, PrivateValue(nullptr));

    RootedValue locales(cx, args.get(0));
    RootedValue options(cx, args.get(1));

    // Step 3.
    if (!IntlInitialize(cx, pluralRules, cx->names().InitializePluralRules, locales, options))
        return false;

    args.rval().setObject(*pluralRules);
    return true;
}

void
PluralRulesObject::finalize(FreeOp* fop, JSObject* obj)
{
    MOZ_ASSERT(fop->onActiveCooperatingThread());

    const Value& slot =
        obj->as<PluralRulesObject>().getReservedSlot(PluralRulesObject::UPLURAL_RULES_SLOT);
    if (UPluralRules* pr = static_cast<UPluralRules*>(slot.toPrivate()))
        uplrules_close(pr);
}

static JSObject*
CreatePluralRulesPrototype(JSContext* cx, HandleObject Intl, Handle<GlobalObject*> global)
{
    RootedFunction ctor(cx);
    ctor = global->createConstructor(cx, &PluralRules, cx->names().PluralRules, 0);
    if (!ctor)
        return nullptr;

    RootedObject proto(cx, GlobalObject::createBlankPrototype<PlainObject>(cx, global));
    if (!proto)
        return nullptr;

    if (!LinkConstructorAndPrototype(cx, ctor, proto))
        return nullptr;

    if (!JS_DefineFunctions(cx, ctor, pluralRules_static_methods))
        return nullptr;

    if (!JS_DefineFunctions(cx, proto, pluralRules_methods))
        return nullptr;

    RootedValue ctorValue(cx, ObjectValue(*ctor));
    if (!DefineProperty(cx, Intl, cx->names().PluralRules, ctorValue, nullptr, nullptr, 0))
        return nullptr;

    return proto;
}

/* static */ bool
js::GlobalObject::addPluralRulesConstructor(JSContext* cx, HandleObject intl)
{
    Handle<GlobalObject*> global = cx->global();

    {
        const HeapSlot& slot = global->getReservedSlotRef(PLURAL_RULES_PROTO);
        if (!slot.isUndefined()) {
            MOZ_ASSERT(slot.isObject());
            JS_ReportErrorASCII(cx,
                                "the PluralRules constructor can't be added "
                                "multiple times in the same global");
            return false;
        }
    }

    JSObject* pluralRulesProto = CreatePluralRulesPrototype(cx, intl, global);
    if (!pluralRulesProto)
        return false;

    global->setReservedSlot(PLURAL_RULES_PROTO, ObjectValue(*pluralRulesProto));
    return true;
}

bool
js::AddPluralRulesConstructor(JSContext* cx, JS::Handle<JSObject*> intl)
{
    return GlobalObject::addPluralRulesConstructor(cx, intl);
}

bool
js::intl_PluralRules_availableLocales(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 0);

    RootedValue result(cx);
    // We're going to use ULocale availableLocales as per ICU recommendation:
    // https://ssl.icu-project.org/trac/ticket/12756
    if (!intl_availableLocales(cx, uloc_countAvailable, uloc_getAvailable, &result))
        return false;
    args.rval().set(result);
    return true;
}

bool
js::intl_SelectPluralRule(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);

    Rooted<PluralRulesObject*> pluralRules(cx, &args[0].toObject().as<PluralRulesObject>());

    UNumberFormat* nf = NewUNumberFormatForPluralRules(cx, pluralRules);
    if (!nf)
        return false;

    ScopedICUObject<UNumberFormat, unum_close> closeNumberFormat(nf);

    RootedObject internals(cx, GetInternals(cx, pluralRules));
    if (!internals)
        return false;

    RootedValue value(cx);

    if (!GetProperty(cx, internals, internals, cx->names().locale, &value))
        return false;
    JSAutoByteString locale(cx, value.toString());
    if (!locale)
        return false;

    if (!GetProperty(cx, internals, internals, cx->names().type, &value))
        return false;
    RootedLinearString type(cx, value.toString()->ensureLinear(cx));
    if (!type)
        return false;

    double x = args[1].toNumber();

    // We need a NumberFormat in order to format the number
    // using the number formatting options (minimum/maximum*Digits)
    // before we push the result to PluralRules.
    //
    // This should be fixed in ICU 59 and we'll be able to switch to that
    // API: http://bugs.icu-project.org/trac/ticket/12763
    //
    RootedValue fmtNumValue(cx);
    if (!intl_FormatNumber(cx, nf, x, &fmtNumValue))
        return false;
    AutoStableStringChars stableChars(cx);
    if (!stableChars.initTwoByte(cx, fmtNumValue.toString()))
        return false;

    const UChar* uFmtNumValue = Char16ToUChar(stableChars.twoByteRange().begin().get());

    UErrorCode status = U_ZERO_ERROR;

    UFormattable* fmt = unum_parseToUFormattable(nf, nullptr, uFmtNumValue,
                                                 stableChars.twoByteRange().length(), nullptr,
                                                 &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    ScopedICUObject<UFormattable, ufmt_close> closeUFormattable(fmt);

    double y = ufmt_getDouble(fmt, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    UPluralType category;
    if (StringEqualsAscii(type, "cardinal")) {
        category = UPLURAL_TYPE_CARDINAL;
    } else {
        MOZ_ASSERT(StringEqualsAscii(type, "ordinal"));
        category = UPLURAL_TYPE_ORDINAL;
    }

    // TODO: Cache UPluralRules in PluralRulesObject::UPluralRulesSlot.
    UPluralRules* pr = uplrules_openForType(icuLocale(locale.ptr()), category, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    ScopedICUObject<UPluralRules, uplrules_close> closePluralRules(pr);

    JSString* str = Call(cx, [pr, y](UChar* chars, int32_t size, UErrorCode* status) {
        return uplrules_select(pr, y, chars, size, status);
    });
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}

bool
js::intl_GetPluralCategories(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    JSLinearString* type = args[1].toString()->ensureLinear(cx);
    if (!type)
        return false;

    UPluralType category;
    if (StringEqualsAscii(type, "cardinal")) {
        category = UPLURAL_TYPE_CARDINAL;
    } else {
        MOZ_ASSERT(StringEqualsAscii(type, "ordinal"));
        category = UPLURAL_TYPE_ORDINAL;
    }

    UErrorCode status = U_ZERO_ERROR;
    UPluralRules* pr = uplrules_openForType(icuLocale(locale.ptr()), category, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    ScopedICUObject<UPluralRules, uplrules_close> closePluralRules(pr);

    // We should get a C API for that in ICU 59 and switch to it.
    // https://ssl.icu-project.org/trac/ticket/12772
    icu::StringEnumeration* kwenum =
        reinterpret_cast<icu::PluralRules*>(pr)->getKeywords(status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    UEnumeration* ue = uenum_openFromStringEnumeration(kwenum, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    ScopedICUObject<UEnumeration, uenum_close> closeEnum(ue);

    RootedObject res(cx, NewDenseEmptyArray(cx));
    if (!res)
        return false;

    RootedValue element(cx);
    uint32_t i = 0;

    do {
        int32_t catSize;
        const char* cat = uenum_next(ue, &catSize, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        if (!cat)
            break;

        MOZ_ASSERT(catSize >= 0);
        JSString* str = NewStringCopyN<CanGC>(cx, cat, catSize);
        if (!str)
            return false;

        element.setString(str);
        if (!DefineElement(cx, res, i++, element))
            return false;
    } while (true);

    args.rval().setObject(*res);
    return true;
}


/******************** String ********************/

static const char*
CaseMappingLocale(JSLinearString* locale)
{
    MOZ_ASSERT(locale->length() >= 2, "locale is a valid language tag");

    // Lithuanian, Turkish, and Azeri have language dependent case mappings.
    static const char languagesWithSpecialCasing[][3] = { "lt", "tr", "az" };

    // All strings in |languagesWithSpecialCasing| are of length two, so we
    // only need to compare the first two characters to find a matching locale.
    // ES2017 Intl, §9.2.2 BestAvailableLocale
    if (locale->length() == 2 || locale->latin1OrTwoByteChar(2) == '-') {
        for (const auto& language : languagesWithSpecialCasing) {
            if (locale->latin1OrTwoByteChar(0) == language[0] &&
                locale->latin1OrTwoByteChar(1) == language[1])
            {
                return language;
            }
        }
    }

    return ""; // ICU root locale
}

static bool
HasLanguageDependentCasing(JSLinearString* locale)
{
    return !equal(CaseMappingLocale(locale), "");
}

bool
js::intl_toLocaleLowerCase(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(args[0].isString());
    MOZ_ASSERT(args[1].isString());

    RootedLinearString linear(cx, args[0].toString()->ensureLinear(cx));
    if (!linear)
        return false;

    RootedLinearString locale(cx, args[1].toString()->ensureLinear(cx));
    if (!locale)
        return false;

    // Call String.prototype.toLowerCase() for language independent casing.
    if (!HasLanguageDependentCasing(locale)) {
        JSString* str = js::StringToLowerCase(cx, linear);
        if (!str)
            return false;

        args.rval().setString(str);
        return true;
    }

    AutoStableStringChars inputChars(cx);
    if (!inputChars.initTwoByte(cx, linear))
        return false;
    mozilla::Range<const char16_t> input = inputChars.twoByteRange();

    // Maximum case mapping length is three characters.
    static_assert(JSString::MAX_LENGTH < INT32_MAX / 3,
                  "Case conversion doesn't overflow int32_t indices");

    JSString* str = Call(cx, [&input, &locale](UChar* chars, int32_t size, UErrorCode* status) {
        return u_strToLower(chars, size, Char16ToUChar(input.begin().get()), input.length(),
                            CaseMappingLocale(locale), status);
    });
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}

bool
js::intl_toLocaleUpperCase(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 2);
    MOZ_ASSERT(args[0].isString());
    MOZ_ASSERT(args[1].isString());

    RootedLinearString linear(cx, args[0].toString()->ensureLinear(cx));
    if (!linear)
        return false;

    RootedLinearString locale(cx, args[1].toString()->ensureLinear(cx));
    if (!locale)
        return false;

    // Call String.prototype.toUpperCase() for language independent casing.
    if (!HasLanguageDependentCasing(locale)) {
        JSString* str = js::StringToUpperCase(cx, linear);
        if (!str)
            return false;

        args.rval().setString(str);
        return true;
    }

    AutoStableStringChars inputChars(cx);
    if (!inputChars.initTwoByte(cx, linear))
        return false;
    mozilla::Range<const char16_t> input = inputChars.twoByteRange();

    // Maximum case mapping length is three characters.
    static_assert(JSString::MAX_LENGTH < INT32_MAX / 3,
                  "Case conversion doesn't overflow int32_t indices");

    JSString* str = Call(cx, [&input, &locale](UChar* chars, int32_t size, UErrorCode* status) {
        return u_strToUpper(chars, size, Char16ToUChar(input.begin().get()), input.length(),
                            CaseMappingLocale(locale), status);
    });
    if (!str)
        return false;

    args.rval().setString(str);
    return true;
}


/******************** Intl ********************/

bool
js::intl_GetCalendarInfo(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    UErrorCode status = U_ZERO_ERROR;
    const UChar* uTimeZone = nullptr;
    int32_t uTimeZoneLength = 0;
    UCalendar* cal = ucal_open(uTimeZone, uTimeZoneLength, locale.ptr(), UCAL_DEFAULT, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UCalendar, ucal_close> toClose(cal);

    RootedObject info(cx, NewBuiltinClassInstance<PlainObject>(cx));
    if (!info)
        return false;

    RootedValue v(cx);
    int32_t firstDayOfWeek = ucal_getAttribute(cal, UCAL_FIRST_DAY_OF_WEEK);
    v.setInt32(firstDayOfWeek);

    if (!DefineProperty(cx, info, cx->names().firstDayOfWeek, v))
        return false;

    int32_t minDays = ucal_getAttribute(cal, UCAL_MINIMAL_DAYS_IN_FIRST_WEEK);
    v.setInt32(minDays);
    if (!DefineProperty(cx, info, cx->names().minDays, v))
        return false;

    UCalendarWeekdayType prevDayType = ucal_getDayOfWeekType(cal, UCAL_SATURDAY, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }

    RootedValue weekendStart(cx), weekendEnd(cx);

    for (int i = UCAL_SUNDAY; i <= UCAL_SATURDAY; i++) {
        UCalendarDaysOfWeek dayOfWeek = static_cast<UCalendarDaysOfWeek>(i);
        UCalendarWeekdayType type = ucal_getDayOfWeekType(cal, dayOfWeek, &status);
        if (U_FAILURE(status)) {
            JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
            return false;
        }

        if (prevDayType != type) {
            switch (type) {
              case UCAL_WEEKDAY:
                // If the first Weekday after Weekend is Sunday (1),
                // then the last Weekend day is Saturday (7).
                // Otherwise we'll just take the previous days number.
                weekendEnd.setInt32(i == 1 ? 7 : i - 1);
                break;
              case UCAL_WEEKEND:
                weekendStart.setInt32(i);
                break;
              case UCAL_WEEKEND_ONSET:
              case UCAL_WEEKEND_CEASE:
                // At the time this code was added, ICU apparently never behaves this way,
                // so just throw, so that users will report a bug and we can decide what to
                // do.
                JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
                return false;
              default:
                break;
            }
        }

        prevDayType = type;
    }

    MOZ_ASSERT(weekendStart.isInt32());
    MOZ_ASSERT(weekendEnd.isInt32());

    if (!DefineProperty(cx, info, cx->names().weekendStart, weekendStart))
        return false;

    if (!DefineProperty(cx, info, cx->names().weekendEnd, weekendEnd))
        return false;

    args.rval().setObject(*info);
    return true;
}

static void
ReportBadKey(JSContext* cx, const Range<const JS::Latin1Char>& range)
{
    JS_ReportErrorNumberLatin1(cx, GetErrorMessage, nullptr, JSMSG_INVALID_KEY,
                               range.begin().get());
}

static void
ReportBadKey(JSContext* cx, const Range<const char16_t>& range)
{
    JS_ReportErrorNumberUC(cx, GetErrorMessage, nullptr, JSMSG_INVALID_KEY,
                           range.begin().get());
}

template<typename ConstChar>
static bool
MatchPart(RangedPtr<ConstChar> iter, const RangedPtr<ConstChar> end,
          const char* part, size_t partlen)
{
    for (size_t i = 0; i < partlen; iter++, i++) {
        if (iter == end || *iter != part[i])
            return false;
    }

    return true;
}

template<typename ConstChar, size_t N>
inline bool
MatchPart(RangedPtr<ConstChar>* iter, const RangedPtr<ConstChar> end, const char (&part)[N])
{
    if (!MatchPart(*iter, end, part, N - 1))
        return false;

    *iter += N - 1;
    return true;
}

enum class DisplayNameStyle
{
    Narrow,
    Short,
    Long,
};

template<typename ConstChar>
static JSString*
ComputeSingleDisplayName(JSContext* cx, UDateFormat* fmt, UDateTimePatternGenerator* dtpg,
                         DisplayNameStyle style,
                         Vector<char16_t, INITIAL_CHAR_BUFFER_SIZE>& chars,
                         const Range<ConstChar>& pattern)
{
    RangedPtr<ConstChar> iter = pattern.begin();
    const RangedPtr<ConstChar> end = pattern.end();

    auto MatchSlash = [cx, pattern, &iter, end]() {
        if (MOZ_LIKELY(iter != end && *iter == '/')) {
            iter++;
            return true;
        }

        ReportBadKey(cx, pattern);
        return false;
    };

    if (!MatchPart(&iter, end, "dates")) {
        ReportBadKey(cx, pattern);
        return nullptr;
    }

    if (!MatchSlash())
        return nullptr;

    if (MatchPart(&iter, end, "fields")) {
        if (!MatchSlash())
            return nullptr;

        UDateTimePatternField fieldType;

        if (MatchPart(&iter, end, "year")) {
            fieldType = UDATPG_YEAR_FIELD;
        } else if (MatchPart(&iter, end, "month")) {
            fieldType = UDATPG_MONTH_FIELD;
        } else if (MatchPart(&iter, end, "week")) {
            fieldType = UDATPG_WEEK_OF_YEAR_FIELD;
        } else if (MatchPart(&iter, end, "day")) {
            fieldType = UDATPG_DAY_FIELD;
        } else {
            ReportBadKey(cx, pattern);
            return nullptr;
        }

        // This part must be the final part with no trailing data.
        if (iter != end) {
            ReportBadKey(cx, pattern);
            return nullptr;
        }

        int32_t resultSize;
        const UChar* value = udatpg_getAppendItemName(dtpg, fieldType, &resultSize);
        MOZ_ASSERT(resultSize >= 0);

        return NewStringCopyN<CanGC>(cx, UCharToChar16(value), size_t(resultSize));
    }

    if (MatchPart(&iter, end, "gregorian")) {
        if (!MatchSlash())
            return nullptr;

        UDateFormatSymbolType symbolType;
        int32_t index;

        if (MatchPart(&iter, end, "months")) {
            if (!MatchSlash())
                return nullptr;

            switch (style) {
              case DisplayNameStyle::Narrow:
                symbolType = UDAT_STANDALONE_NARROW_MONTHS;
                break;

              case DisplayNameStyle::Short:
                symbolType = UDAT_STANDALONE_SHORT_MONTHS;
                break;

              case DisplayNameStyle::Long:
                symbolType = UDAT_STANDALONE_MONTHS;
                break;
            }

            if (MatchPart(&iter, end, "january")) {
                index = UCAL_JANUARY;
            } else if (MatchPart(&iter, end, "february")) {
                index = UCAL_FEBRUARY;
            } else if (MatchPart(&iter, end, "march")) {
                index = UCAL_MARCH;
            } else if (MatchPart(&iter, end, "april")) {
                index = UCAL_APRIL;
            } else if (MatchPart(&iter, end, "may")) {
                index = UCAL_MAY;
            } else if (MatchPart(&iter, end, "june")) {
                index = UCAL_JUNE;
            } else if (MatchPart(&iter, end, "july")) {
                index = UCAL_JULY;
            } else if (MatchPart(&iter, end, "august")) {
                index = UCAL_AUGUST;
            } else if (MatchPart(&iter, end, "september")) {
                index = UCAL_SEPTEMBER;
            } else if (MatchPart(&iter, end, "october")) {
                index = UCAL_OCTOBER;
            } else if (MatchPart(&iter, end, "november")) {
                index = UCAL_NOVEMBER;
            } else if (MatchPart(&iter, end, "december")) {
                index = UCAL_DECEMBER;
            } else {
                ReportBadKey(cx, pattern);
                return nullptr;
            }
        } else if (MatchPart(&iter, end, "weekdays")) {
            if (!MatchSlash())
                return nullptr;

            switch (style) {
              case DisplayNameStyle::Narrow:
                symbolType = UDAT_STANDALONE_NARROW_WEEKDAYS;
                break;

              case DisplayNameStyle::Short:
                symbolType = UDAT_STANDALONE_SHORT_WEEKDAYS;
                break;

              case DisplayNameStyle::Long:
                symbolType = UDAT_STANDALONE_WEEKDAYS;
                break;
            }

            if (MatchPart(&iter, end, "monday")) {
                index = UCAL_MONDAY;
            } else if (MatchPart(&iter, end, "tuesday")) {
                index = UCAL_TUESDAY;
            } else if (MatchPart(&iter, end, "wednesday")) {
                index = UCAL_WEDNESDAY;
            } else if (MatchPart(&iter, end, "thursday")) {
                index = UCAL_THURSDAY;
            } else if (MatchPart(&iter, end, "friday")) {
                index = UCAL_FRIDAY;
            } else if (MatchPart(&iter, end, "saturday")) {
                index = UCAL_SATURDAY;
            } else if (MatchPart(&iter, end, "sunday")) {
                index = UCAL_SUNDAY;
            } else {
                ReportBadKey(cx, pattern);
                return nullptr;
            }
        } else if (MatchPart(&iter, end, "dayperiods")) {
            if (!MatchSlash())
                return nullptr;

            symbolType = UDAT_AM_PMS;

            if (MatchPart(&iter, end, "am")) {
                index = UCAL_AM;
            } else if (MatchPart(&iter, end, "pm")) {
                index = UCAL_PM;
            } else {
                ReportBadKey(cx, pattern);
                return nullptr;
            }
        } else {
            ReportBadKey(cx, pattern);
            return nullptr;
        }

        // This part must be the final part with no trailing data.
        if (iter != end) {
            ReportBadKey(cx, pattern);
            return nullptr;
        }

        return Call(cx, [fmt, symbolType, index](UChar* chars, int32_t size, UErrorCode* status) {
            return udat_getSymbols(fmt, symbolType, index, chars, size, status);
        });
    }

    ReportBadKey(cx, pattern);
    return nullptr;
}

bool
js::intl_ComputeDisplayNames(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 3);

    RootedString str(cx);

    // 1. Assert: locale is a string.
    str = args[0].toString();
    JSAutoByteString locale;
    if (!locale.encodeUtf8(cx, str))
        return false;

    // 2. Assert: style is a string.
    JSLinearString* style = args[1].toString()->ensureLinear(cx);
    if (!style)
        return false;

    DisplayNameStyle dnStyle;
    if (StringEqualsAscii(style, "narrow")) {
        dnStyle = DisplayNameStyle::Narrow;
    } else if (StringEqualsAscii(style, "short")) {
        dnStyle = DisplayNameStyle::Short;
    } else {
        MOZ_ASSERT(StringEqualsAscii(style, "long"));
        dnStyle = DisplayNameStyle::Long;
    }

    // 3. Assert: keys is an Array.
    RootedArrayObject keys(cx, &args[2].toObject().as<ArrayObject>());
    if (!keys)
        return false;

    // 4. Let result be ArrayCreate(0).
    RootedArrayObject result(cx, NewDenseUnallocatedArray(cx, keys->length()));
    if (!result)
        return false;

    UErrorCode status = U_ZERO_ERROR;

    UDateFormat* fmt =
        udat_open(UDAT_DEFAULT, UDAT_DEFAULT, icuLocale(locale.ptr()),
        nullptr, 0, nullptr, 0, &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UDateFormat, udat_close> datToClose(fmt);

    // UDateTimePatternGenerator will be needed for translations of date and
    // time fields like "month", "week", "day" etc.
    UDateTimePatternGenerator* dtpg = udatpg_open(icuLocale(locale.ptr()), &status);
    if (U_FAILURE(status)) {
        JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr, JSMSG_INTERNAL_INTL_ERROR);
        return false;
    }
    ScopedICUObject<UDateTimePatternGenerator, udatpg_close> datPgToClose(dtpg);

    Vector<char16_t, INITIAL_CHAR_BUFFER_SIZE> chars(cx);
    if (!chars.resize(INITIAL_CHAR_BUFFER_SIZE))
        return false;

    // 5. For each element of keys,
    RootedString keyValStr(cx);
    RootedValue v(cx);
    for (uint32_t i = 0; i < keys->length(); i++) {
        if (!GetElement(cx, keys, keys, i, &v))
            return false;

        keyValStr = v.toString();

        AutoStableStringChars stablePatternChars(cx);
        if (!stablePatternChars.init(cx, keyValStr))
            return false;

        // 5.a. Perform an implementation dependent algorithm to map a key to a
        //      corresponding display name.
        JSString* displayName =
            stablePatternChars.isLatin1()
            ? ComputeSingleDisplayName(cx, fmt, dtpg, dnStyle, chars,
                                       stablePatternChars.latin1Range())
            : ComputeSingleDisplayName(cx, fmt, dtpg, dnStyle, chars,
                                       stablePatternChars.twoByteRange());
        if (!displayName)
            return false;

        // 5.b. Append the result string to result.
        v.setString(displayName);
        if (!DefineElement(cx, result, i, v))
            return false;
    }

    // 6. Return result.
    args.rval().setObject(*result);
    return true;
}

bool
js::intl_GetLocaleInfo(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    MOZ_ASSERT(args.length() == 1);

    JSAutoByteString locale(cx, args[0].toString());
    if (!locale)
        return false;

    RootedObject info(cx, NewBuiltinClassInstance<PlainObject>(cx));
    if (!info)
        return false;

    if (!DefineProperty(cx, info, cx->names().locale, args[0]))
        return false;

    bool rtl = uloc_isRightToLeft(icuLocale(locale.ptr()));

    RootedValue dir(cx, StringValue(rtl ? cx->names().rtl : cx->names().ltr));

    if (!DefineProperty(cx, info, cx->names().direction, dir))
        return false;

    args.rval().setObject(*info);
    return true;
}

const Class js::IntlClass = {
    js_Object_str,
    JSCLASS_HAS_CACHED_PROTO(JSProto_Intl)
};

#if JS_HAS_TOSOURCE
static bool
intl_toSource(JSContext* cx, unsigned argc, Value* vp)
{
    CallArgs args = CallArgsFromVp(argc, vp);
    args.rval().setString(cx->names().Intl);
    return true;
}
#endif

static const JSFunctionSpec intl_static_methods[] = {
#if JS_HAS_TOSOURCE
    JS_FN(js_toSource_str,  intl_toSource,        0, 0),
#endif
    JS_SELF_HOSTED_FN("getCanonicalLocales", "Intl_getCanonicalLocales", 1, 0),
    JS_FS_END
};

/**
 * Initializes the Intl Object and its standard built-in properties.
 * Spec: ECMAScript Internationalization API Specification, 8.0, 8.1
 */
/* static */ bool
GlobalObject::initIntlObject(JSContext* cx, Handle<GlobalObject*> global)
{
    RootedObject proto(cx, GlobalObject::getOrCreateObjectPrototype(cx, global));
    if (!proto)
        return false;

    // The |Intl| object is just a plain object with some "static" function
    // properties and some constructor properties.
    RootedObject intl(cx, NewObjectWithGivenProto(cx, &IntlClass, proto, SingletonObject));
    if (!intl)
        return false;

    // Add the static functions.
    if (!JS_DefineFunctions(cx, intl, intl_static_methods))
        return false;

    // Add the constructor properties, computing and returning the relevant
    // prototype objects needed below.
    RootedObject collatorProto(cx, CreateCollatorPrototype(cx, intl, global));
    if (!collatorProto)
        return false;
    RootedObject dateTimeFormatProto(cx), dateTimeFormat(cx);
    dateTimeFormatProto = CreateDateTimeFormatPrototype(cx, intl, global, &dateTimeFormat, DateTimeFormatOptions::Standard);
    if (!dateTimeFormatProto)
        return false;
    RootedObject numberFormatProto(cx), numberFormat(cx);
    numberFormatProto = CreateNumberFormatPrototype(cx, intl, global, &numberFormat);
    if (!numberFormatProto)
        return false;

    // The |Intl| object is fully set up now, so define the global property.
    RootedValue intlValue(cx, ObjectValue(*intl));
    if (!DefineProperty(cx, global, cx->names().Intl, intlValue, nullptr, nullptr,
                        JSPROP_RESOLVING))
    {
        return false;
    }

    // Now that the |Intl| object is successfully added, we can OOM-safely fill
    // in all relevant reserved global slots.

    // Cache the various prototypes, for use in creating instances of these
    // objects with the proper [[Prototype]] as "the original value of
    // |Intl.Collator.prototype|" and similar.  For builtin classes like
    // |String.prototype| we have |JSProto_*| that enables
    // |getPrototype(JSProto_*)|, but that has global-object-property-related
    // baggage we don't need or want, so we use one-off reserved slots.
    global->setReservedSlot(COLLATOR_PROTO, ObjectValue(*collatorProto));
    global->setReservedSlot(DATE_TIME_FORMAT, ObjectValue(*dateTimeFormat));
    global->setReservedSlot(DATE_TIME_FORMAT_PROTO, ObjectValue(*dateTimeFormatProto));
    global->setReservedSlot(NUMBER_FORMAT, ObjectValue(*numberFormat));
    global->setReservedSlot(NUMBER_FORMAT_PROTO, ObjectValue(*numberFormatProto));

    // Also cache |Intl| to implement spec language that conditions behavior
    // based on values being equal to "the standard built-in |Intl| object".
    // Use |setConstructor| to correspond with |JSProto_Intl|.
    //
    // XXX We should possibly do a one-off reserved slot like above.
    global->setConstructor(JSProto_Intl, ObjectValue(*intl));
    return true;
}

JSObject*
js::InitIntlClass(JSContext* cx, HandleObject obj)
{
    Handle<GlobalObject*> global = obj.as<GlobalObject>();
    if (!GlobalObject::initIntlObject(cx, global))
        return nullptr;

    return &global->getConstructor(JSProto_Intl).toObject();
}
