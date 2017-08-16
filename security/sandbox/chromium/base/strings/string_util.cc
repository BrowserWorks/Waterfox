// Copyright 2013 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/strings/string_util.h"

#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wchar.h>
#include <wctype.h>

#include <algorithm>
#include <limits>
#include <vector>

#include "base/logging.h"
#include "base/macros.h"
#include "base/memory/singleton.h"
#include "base/strings/utf_string_conversion_utils.h"
#include "base/strings/utf_string_conversions.h"
#include "base/third_party/icu/icu_utf.h"
#include "build/build_config.h"

namespace base {

namespace {

// Force the singleton used by EmptyString[16] to be a unique type. This
// prevents other code that might accidentally use Singleton<string> from
// getting our internal one.
struct EmptyStrings {
  EmptyStrings() {}
  const std::string s;
  const string16 s16;

  static EmptyStrings* GetInstance() {
    return Singleton<EmptyStrings>::get();
  }
};

// Used by ReplaceStringPlaceholders to track the position in the string of
// replaced parameters.
struct ReplacementOffset {
  ReplacementOffset(uintptr_t parameter, size_t offset)
      : parameter(parameter),
        offset(offset) {}

  // Index of the parameter.
  uintptr_t parameter;

  // Starting position in the string.
  size_t offset;
};

static bool CompareParameter(const ReplacementOffset& elem1,
                             const ReplacementOffset& elem2) {
  return elem1.parameter < elem2.parameter;
}

// Assuming that a pointer is the size of a "machine word", then
// uintptr_t is an integer type that is also a machine word.
typedef uintptr_t MachineWord;
const uintptr_t kMachineWordAlignmentMask = sizeof(MachineWord) - 1;

inline bool IsAlignedToMachineWord(const void* pointer) {
  return !(reinterpret_cast<MachineWord>(pointer) & kMachineWordAlignmentMask);
}

template<typename T> inline T* AlignToMachineWord(T* pointer) {
  return reinterpret_cast<T*>(reinterpret_cast<MachineWord>(pointer) &
                              ~kMachineWordAlignmentMask);
}

template<size_t size, typename CharacterType> struct NonASCIIMask;
template<> struct NonASCIIMask<4, char16> {
    static inline uint32_t value() { return 0xFF80FF80U; }
};
template<> struct NonASCIIMask<4, char> {
    static inline uint32_t value() { return 0x80808080U; }
};
template<> struct NonASCIIMask<8, char16> {
    static inline uint64_t value() { return 0xFF80FF80FF80FF80ULL; }
};
template<> struct NonASCIIMask<8, char> {
    static inline uint64_t value() { return 0x8080808080808080ULL; }
};
#if defined(WCHAR_T_IS_UTF32)
template<> struct NonASCIIMask<4, wchar_t> {
    static inline uint32_t value() { return 0xFFFFFF80U; }
};
template<> struct NonASCIIMask<8, wchar_t> {
    static inline uint64_t value() { return 0xFFFFFF80FFFFFF80ULL; }
};
#endif  // WCHAR_T_IS_UTF32

}  // namespace

bool IsWprintfFormatPortable(const wchar_t* format) {
  for (const wchar_t* position = format; *position != '\0'; ++position) {
    if (*position == '%') {
      bool in_specification = true;
      bool modifier_l = false;
      while (in_specification) {
        // Eat up characters until reaching a known specifier.
        if (*++position == '\0') {
          // The format string ended in the middle of a specification.  Call
          // it portable because no unportable specifications were found.  The
          // string is equally broken on all platforms.
          return true;
        }

        if (*position == 'l') {
          // 'l' is the only thing that can save the 's' and 'c' specifiers.
          modifier_l = true;
        } else if (((*position == 's' || *position == 'c') && !modifier_l) ||
                   *position == 'S' || *position == 'C' || *position == 'F' ||
                   *position == 'D' || *position == 'O' || *position == 'U') {
          // Not portable.
          return false;
        }

        if (wcschr(L"diouxXeEfgGaAcspn%", *position)) {
          // Portable, keep scanning the rest of the format string.
          in_specification = false;
        }
      }
    }
  }

  return true;
}

namespace {

template<typename StringType>
StringType ToLowerASCIIImpl(BasicStringPiece<StringType> str) {
  StringType ret;
  ret.reserve(str.size());
  for (size_t i = 0; i < str.size(); i++)
    ret.push_back(ToLowerASCII(str[i]));
  return ret;
}

template<typename StringType>
StringType ToUpperASCIIImpl(BasicStringPiece<StringType> str) {
  StringType ret;
  ret.reserve(str.size());
  for (size_t i = 0; i < str.size(); i++)
    ret.push_back(ToUpperASCII(str[i]));
  return ret;
}

}  // namespace

std::string ToLowerASCII(StringPiece str) {
  return ToLowerASCIIImpl<std::string>(str);
}

string16 ToLowerASCII(StringPiece16 str) {
  return ToLowerASCIIImpl<string16>(str);
}

std::string ToUpperASCII(StringPiece str) {
  return ToUpperASCIIImpl<std::string>(str);
}

string16 ToUpperASCII(StringPiece16 str) {
  return ToUpperASCIIImpl<string16>(str);
}

template<class StringType>
int CompareCaseInsensitiveASCIIT(BasicStringPiece<StringType> a,
                                 BasicStringPiece<StringType> b) {
  // Find the first characters that aren't equal and compare them.  If the end
  // of one of the strings is found before a nonequal character, the lengths
  // of the strings are compared.
  size_t i = 0;
  while (i < a.length() && i < b.length()) {
    typename StringType::value_type lower_a = ToLowerASCII(a[i]);
    typename StringType::value_type lower_b = ToLowerASCII(b[i]);
    if (lower_a < lower_b)
      return -1;
    if (lower_a > lower_b)
      return 1;
    i++;
  }

  // End of one string hit before finding a different character. Expect the
  // common case to be "strings equal" at this point so check that first.
  if (a.length() == b.length())
    return 0;

  if (a.length() < b.length())
    return -1;
  return 1;
}

int CompareCaseInsensitiveASCII(StringPiece a, StringPiece b) {
  return CompareCaseInsensitiveASCIIT<std::string>(a, b);
}

int CompareCaseInsensitiveASCII(StringPiece16 a, StringPiece16 b) {
  return CompareCaseInsensitiveASCIIT<string16>(a, b);
}

bool EqualsCaseInsensitiveASCII(StringPiece a, StringPiece b) {
  if (a.length() != b.length())
    return false;
  return CompareCaseInsensitiveASCIIT<std::string>(a, b) == 0;
}

bool EqualsCaseInsensitiveASCII(StringPiece16 a, StringPiece16 b) {
  if (a.length() != b.length())
    return false;
  return CompareCaseInsensitiveASCIIT<string16>(a, b) == 0;
}

const std::string& EmptyString() {
  return EmptyStrings::GetInstance()->s;
}

const string16& EmptyString16() {
  return EmptyStrings::GetInstance()->s16;
}

template<typename STR>
bool ReplaceCharsT(const STR& input,
                   const STR& replace_chars,
                   const STR& replace_with,
                   STR* output) {
  bool removed = false;
  size_t replace_length = replace_with.length();

  *output = input;

  size_t found = output->find_first_of(replace_chars);
  while (found != STR::npos) {
    removed = true;
    output->replace(found, 1, replace_with);
    found = output->find_first_of(replace_chars, found + replace_length);
  }

  return removed;
}

bool ReplaceChars(const string16& input,
                  const StringPiece16& replace_chars,
                  const string16& replace_with,
                  string16* output) {
  return ReplaceCharsT(input, replace_chars.as_string(), replace_with, output);
}

bool ReplaceChars(const std::string& input,
                  const StringPiece& replace_chars,
                  const std::string& replace_with,
                  std::string* output) {
  return ReplaceCharsT(input, replace_chars.as_string(), replace_with, output);
}

bool RemoveChars(const string16& input,
                 const StringPiece16& remove_chars,
                 string16* output) {
  return ReplaceChars(input, remove_chars.as_string(), string16(), output);
}

bool RemoveChars(const std::string& input,
                 const StringPiece& remove_chars,
                 std::string* output) {
  return ReplaceChars(input, remove_chars.as_string(), std::string(), output);
}

template<typename Str>
TrimPositions TrimStringT(const Str& input,
                          BasicStringPiece<Str> trim_chars,
                          TrimPositions positions,
                          Str* output) {
  // Find the edges of leading/trailing whitespace as desired. Need to use
  // a StringPiece version of input to be able to call find* on it with the
  // StringPiece version of trim_chars (normally the trim_chars will be a
  // constant so avoid making a copy).
  BasicStringPiece<Str> input_piece(input);
  const size_t last_char = input.length() - 1;
  const size_t first_good_char = (positions & TRIM_LEADING) ?
      input_piece.find_first_not_of(trim_chars) : 0;
  const size_t last_good_char = (positions & TRIM_TRAILING) ?
      input_piece.find_last_not_of(trim_chars) : last_char;

  // When the string was all trimmed, report that we stripped off characters
  // from whichever position the caller was interested in. For empty input, we
  // stripped no characters, but we still need to clear |output|.
  if (input.empty() ||
      (first_good_char == Str::npos) || (last_good_char == Str::npos)) {
    bool input_was_empty = input.empty();  // in case output == &input
    output->clear();
    return input_was_empty ? TRIM_NONE : positions;
  }

  // Trim.
  *output =
      input.substr(first_good_char, last_good_char - first_good_char + 1);

  // Return where we trimmed from.
  return static_cast<TrimPositions>(
      ((first_good_char == 0) ? TRIM_NONE : TRIM_LEADING) |
      ((last_good_char == last_char) ? TRIM_NONE : TRIM_TRAILING));
}

bool TrimString(const string16& input,
                StringPiece16 trim_chars,
                string16* output) {
  return TrimStringT(input, trim_chars, TRIM_ALL, output) != TRIM_NONE;
}

bool TrimString(const std::string& input,
                StringPiece trim_chars,
                std::string* output) {
  return TrimStringT(input, trim_chars, TRIM_ALL, output) != TRIM_NONE;
}

template<typename Str>
BasicStringPiece<Str> TrimStringPieceT(BasicStringPiece<Str> input,
                                       BasicStringPiece<Str> trim_chars,
                                       TrimPositions positions) {
  size_t begin = (positions & TRIM_LEADING) ?
      input.find_first_not_of(trim_chars) : 0;
  size_t end = (positions & TRIM_TRAILING) ?
      input.find_last_not_of(trim_chars) + 1 : input.size();
  return input.substr(begin, end - begin);
}

StringPiece16 TrimString(StringPiece16 input,
                         const StringPiece16& trim_chars,
                         TrimPositions positions) {
  return TrimStringPieceT(input, trim_chars, positions);
}

StringPiece TrimString(StringPiece input,
                       const StringPiece& trim_chars,
                       TrimPositions positions) {
  return TrimStringPieceT(input, trim_chars, positions);
}

void TruncateUTF8ToByteSize(const std::string& input,
                            const size_t byte_size,
                            std::string* output) {
  DCHECK(output);
  if (byte_size > input.length()) {
    *output = input;
    return;
  }
  DCHECK_LE(byte_size,
            static_cast<uint32_t>(std::numeric_limits<int32_t>::max()));
  // Note: This cast is necessary because CBU8_NEXT uses int32_ts.
  int32_t truncation_length = static_cast<int32_t>(byte_size);
  int32_t char_index = truncation_length - 1;
  const char* data = input.data();

  // Using CBU8, we will move backwards from the truncation point
  // to the beginning of the string looking for a valid UTF8
  // character.  Once a full UTF8 character is found, we will
  // truncate the string to the end of that character.
  while (char_index >= 0) {
    int32_t prev = char_index;
    base_icu::UChar32 code_point = 0;
    CBU8_NEXT(data, char_index, truncation_length, code_point);
    if (!IsValidCharacter(code_point) ||
        !IsValidCodepoint(code_point)) {
      char_index = prev - 1;
    } else {
      break;
    }
  }

  if (char_index >= 0 )
    *output = input.substr(0, char_index);
  else
    output->clear();
}

TrimPositions TrimWhitespace(const string16& input,
                             TrimPositions positions,
                             string16* output) {
  return TrimStringT(input, StringPiece16(kWhitespaceUTF16), positions, output);
}

StringPiece16 TrimWhitespace(StringPiece16 input,
                             TrimPositions positions) {
  return TrimStringPieceT(input, StringPiece16(kWhitespaceUTF16), positions);
}

TrimPositions TrimWhitespaceASCII(const std::string& input,
                                  TrimPositions positions,
                                  std::string* output) {
  return TrimStringT(input, StringPiece(kWhitespaceASCII), positions, output);
}

StringPiece TrimWhitespaceASCII(StringPiece input, TrimPositions positions) {
  return TrimStringPieceT(input, StringPiece(kWhitespaceASCII), positions);
}

template<typename STR>
STR CollapseWhitespaceT(const STR& text,
                        bool trim_sequences_with_line_breaks) {
  STR result;
  result.resize(text.size());

  // Set flags to pretend we're already in a trimmed whitespace sequence, so we
  // will trim any leading whitespace.
  bool in_whitespace = true;
  bool already_trimmed = true;

  int chars_written = 0;
  for (typename STR::const_iterator i(text.begin()); i != text.end(); ++i) {
    if (IsUnicodeWhitespace(*i)) {
      if (!in_whitespace) {
        // Reduce all whitespace sequences to a single space.
        in_whitespace = true;
        result[chars_written++] = L' ';
      }
      if (trim_sequences_with_line_breaks && !already_trimmed &&
          ((*i == '\n') || (*i == '\r'))) {
        // Whitespace sequences containing CR or LF are eliminated entirely.
        already_trimmed = true;
        --chars_written;
      }
    } else {
      // Non-whitespace chracters are copied straight across.
      in_whitespace = false;
      already_trimmed = false;
      result[chars_written++] = *i;
    }
  }

  if (in_whitespace && !already_trimmed) {
    // Any trailing whitespace is eliminated.
    --chars_written;
  }

  result.resize(chars_written);
  return result;
}

string16 CollapseWhitespace(const string16& text,
                            bool trim_sequences_with_line_breaks) {
  return CollapseWhitespaceT(text, trim_sequences_with_line_breaks);
}

std::string CollapseWhitespaceASCII(const std::string& text,
                                    bool trim_sequences_with_line_breaks) {
  return CollapseWhitespaceT(text, trim_sequences_with_line_breaks);
}

bool ContainsOnlyChars(const StringPiece& input,
                       const StringPiece& characters) {
  return input.find_first_not_of(characters) == StringPiece::npos;
}

bool ContainsOnlyChars(const StringPiece16& input,
                       const StringPiece16& characters) {
  return input.find_first_not_of(characters) == StringPiece16::npos;
}

template <class Char>
inline bool DoIsStringASCII(const Char* characters, size_t length) {
  MachineWord all_char_bits = 0;
  const Char* end = characters + length;

  // Prologue: align the input.
  while (!IsAlignedToMachineWord(characters) && characters != end) {
    all_char_bits |= *characters;
    ++characters;
  }

  // Compare the values of CPU word size.
  const Char* word_end = AlignToMachineWord(end);
  const size_t loop_increment = sizeof(MachineWord) / sizeof(Char);
  while (characters < word_end) {
    all_char_bits |= *(reinterpret_cast<const MachineWord*>(characters));
    characters += loop_increment;
  }

  // Process the remaining bytes.
  while (characters != end) {
    all_char_bits |= *characters;
    ++characters;
  }

  MachineWord non_ascii_bit_mask =
      NonASCIIMask<sizeof(MachineWord), Char>::value();
  return !(all_char_bits & non_ascii_bit_mask);
}

bool IsStringASCII(const StringPiece& str) {
  return DoIsStringASCII(str.data(), str.length());
}

bool IsStringASCII(const StringPiece16& str) {
  return DoIsStringASCII(str.data(), str.length());
}

bool IsStringASCII(const string16& str) {
  return DoIsStringASCII(str.data(), str.length());
}

#if defined(WCHAR_T_IS_UTF32)
bool IsStringASCII(const std::wstring& str) {
  return DoIsStringASCII(str.data(), str.length());
}
#endif

bool IsStringUTF8(const StringPiece& str) {
  const char *src = str.data();
  int32_t src_len = static_cast<int32_t>(str.length());
  int32_t char_index = 0;

  while (char_index < src_len) {
    int32_t code_point;
    CBU8_NEXT(src, char_index, src_len, code_point);
    if (!IsValidCharacter(code_point))
      return false;
  }
  return true;
}

// Implementation note: Normally this function will be called with a hardcoded
// constant for the lowercase_ascii parameter. Constructing a StringPiece from
// a C constant requires running strlen, so the result will be two passes
// through the buffers, one to file the length of lowercase_ascii, and one to
// compare each letter.
//
// This function could have taken a const char* to avoid this and only do one
// pass through the string. But the strlen is faster than the case-insensitive
// compares and lets us early-exit in the case that the strings are different
// lengths (will often be the case for non-matches). So whether one approach or
// the other will be faster depends on the case.
//
// The hardcoded strings are typically very short so it doesn't matter, and the
// string piece gives additional flexibility for the caller (doesn't have to be
// null terminated) so we choose the StringPiece route.
template<typename Str>
static inline bool DoLowerCaseEqualsASCII(BasicStringPiece<Str> str,
                                          StringPiece lowercase_ascii) {
  if (str.size() != lowercase_ascii.size())
    return false;
  for (size_t i = 0; i < str.size(); i++) {
    if (ToLowerASCII(str[i]) != lowercase_ascii[i])
      return false;
  }
  return true;
}

bool LowerCaseEqualsASCII(StringPiece str, StringPiece lowercase_ascii) {
  return DoLowerCaseEqualsASCII<std::string>(str, lowercase_ascii);
}

bool LowerCaseEqualsASCII(StringPiece16 str, StringPiece lowercase_ascii) {
  return DoLowerCaseEqualsASCII<string16>(str, lowercase_ascii);
}

bool EqualsASCII(StringPiece16 str, StringPiece ascii) {
  if (str.length() != ascii.length())
    return false;
  return std::equal(ascii.begin(), ascii.end(), str.begin());
}

template<typename Str>
bool StartsWithT(BasicStringPiece<Str> str,
                 BasicStringPiece<Str> search_for,
                 CompareCase case_sensitivity) {
  if (search_for.size() > str.size())
    return false;

  BasicStringPiece<Str> source = str.substr(0, search_for.size());

  switch (case_sensitivity) {
    case CompareCase::SENSITIVE:
      return source == search_for;

    case CompareCase::INSENSITIVE_ASCII:
      return std::equal(
          search_for.begin(), search_for.end(),
          source.begin(),
          CaseInsensitiveCompareASCII<typename Str::value_type>());

    default:
      NOTREACHED();
      return false;
  }
}

bool StartsWith(StringPiece str,
                StringPiece search_for,
                CompareCase case_sensitivity) {
  return StartsWithT<std::string>(str, search_for, case_sensitivity);
}

bool StartsWith(StringPiece16 str,
                StringPiece16 search_for,
                CompareCase case_sensitivity) {
  return StartsWithT<string16>(str, search_for, case_sensitivity);
}

template <typename Str>
bool EndsWithT(BasicStringPiece<Str> str,
               BasicStringPiece<Str> search_for,
               CompareCase case_sensitivity) {
  if (search_for.size() > str.size())
    return false;

  BasicStringPiece<Str> source = str.substr(str.size() - search_for.size(),
                                            search_for.size());

  switch (case_sensitivity) {
    case CompareCase::SENSITIVE:
      return source == search_for;

    case CompareCase::INSENSITIVE_ASCII:
      return std::equal(
          source.begin(), source.end(),
          search_for.begin(),
          CaseInsensitiveCompareASCII<typename Str::value_type>());

    default:
      NOTREACHED();
      return false;
  }
}

bool EndsWith(StringPiece str,
              StringPiece search_for,
              CompareCase case_sensitivity) {
  return EndsWithT<std::string>(str, search_for, case_sensitivity);
}

bool EndsWith(StringPiece16 str,
              StringPiece16 search_for,
              CompareCase case_sensitivity) {
  return EndsWithT<string16>(str, search_for, case_sensitivity);
}

char HexDigitToInt(wchar_t c) {
  DCHECK(IsHexDigit(c));
  if (c >= '0' && c <= '9')
    return static_cast<char>(c - '0');
  if (c >= 'A' && c <= 'F')
    return static_cast<char>(c - 'A' + 10);
  if (c >= 'a' && c <= 'f')
    return static_cast<char>(c - 'a' + 10);
  return 0;
}

bool IsUnicodeWhitespace(wchar_t c) {
  // kWhitespaceWide is a NULL-terminated string
  for (const wchar_t* cur = kWhitespaceWide; *cur; ++cur) {
    if (*cur == c)
      return true;
  }
  return false;
}

static const char* const kByteStringsUnlocalized[] = {
  " B",
  " kB",
  " MB",
  " GB",
  " TB",
  " PB"
};

string16 FormatBytesUnlocalized(int64_t bytes) {
  double unit_amount = static_cast<double>(bytes);
  size_t dimension = 0;
  const int kKilo = 1024;
  while (unit_amount >= kKilo &&
         dimension < arraysize(kByteStringsUnlocalized) - 1) {
    unit_amount /= kKilo;
    dimension++;
  }

  char buf[64];
  if (bytes != 0 && dimension > 0 && unit_amount < 100) {
    base::snprintf(buf, arraysize(buf), "%.1lf%s", unit_amount,
                   kByteStringsUnlocalized[dimension]);
  } else {
    base::snprintf(buf, arraysize(buf), "%.0lf%s", unit_amount,
                   kByteStringsUnlocalized[dimension]);
  }

  return ASCIIToUTF16(buf);
}

// Runs in O(n) time in the length of |str|.
template<class StringType>
void DoReplaceSubstringsAfterOffset(StringType* str,
                                    size_t offset,
                                    BasicStringPiece<StringType> find_this,
                                    BasicStringPiece<StringType> replace_with,
                                    bool replace_all) {
  DCHECK(!find_this.empty());

  // If the find string doesn't appear, there's nothing to do.
  offset = str->find(find_this.data(), offset, find_this.size());
  if (offset == StringType::npos)
    return;

  // If we're only replacing one instance, there's no need to do anything
  // complicated.
  size_t find_length = find_this.length();
  if (!replace_all) {
    str->replace(offset, find_length, replace_with.data(), replace_with.size());
    return;
  }

  // If the find and replace strings are the same length, we can simply use
  // replace() on each instance, and finish the entire operation in O(n) time.
  size_t replace_length = replace_with.length();
  if (find_length == replace_length) {
    do {
      str->replace(offset, find_length,
                   replace_with.data(), replace_with.size());
      offset = str->find(find_this.data(), offset + replace_length,
                         find_this.size());
    } while (offset != StringType::npos);
    return;
  }

  // Since the find and replace strings aren't the same length, a loop like the
  // one above would be O(n^2) in the worst case, as replace() will shift the
  // entire remaining string each time.  We need to be more clever to keep
  // things O(n).
  //
  // If we're shortening the string, we can alternate replacements with shifting
  // forward the intervening characters using memmove().
  size_t str_length = str->length();
  if (find_length > replace_length) {
    size_t write_offset = offset;
    do {
      if (replace_length) {
        str->replace(write_offset, replace_length,
                     replace_with.data(), replace_with.size());
        write_offset += replace_length;
      }
      size_t read_offset = offset + find_length;
      offset = std::min(
          str->find(find_this.data(), read_offset, find_this.size()),
          str_length);
      size_t length = offset - read_offset;
      if (length) {
        memmove(&(*str)[write_offset], &(*str)[read_offset],
                length * sizeof(typename StringType::value_type));
        write_offset += length;
      }
    } while (offset < str_length);
    str->resize(write_offset);
    return;
  }

  // We're lengthening the string.  We can use alternating replacements and
  // memmove() calls like above, but we need to precalculate the final string
  // length and then expand from back-to-front to avoid overwriting the string
  // as we're reading it, needing to shift, or having to copy to a second string
  // temporarily.
  size_t first_match = offset;

  // First, calculate the final length and resize the string.
  size_t final_length = str_length;
  size_t expansion = replace_length - find_length;
  size_t current_match;
  do {
    final_length += expansion;
    // Minor optimization: save this offset into |current_match|, so that on
    // exit from the loop, |current_match| will point at the last instance of
    // the find string, and we won't need to find() it again immediately.
    current_match = offset;
    offset = str->find(find_this.data(), offset + find_length,
                       find_this.size());
  } while (offset != StringType::npos);
  str->resize(final_length);

  // Now do the replacement loop, working backwards through the string.
  for (size_t prev_match = str_length, write_offset = final_length; ;
       current_match = str->rfind(find_this.data(), current_match - 1,
                                  find_this.size())) {
    size_t read_offset = current_match + find_length;
    size_t length = prev_match - read_offset;
    if (length) {
      write_offset -= length;
      memmove(&(*str)[write_offset], &(*str)[read_offset],
              length * sizeof(typename StringType::value_type));
    }
    write_offset -= replace_length;
    str->replace(write_offset, replace_length,
                 replace_with.data(), replace_with.size());
    if (current_match == first_match)
      return;
    prev_match = current_match;
  }
}

void ReplaceFirstSubstringAfterOffset(string16* str,
                                      size_t start_offset,
                                      StringPiece16 find_this,
                                      StringPiece16 replace_with) {
  DoReplaceSubstringsAfterOffset<string16>(
      str, start_offset, find_this, replace_with, false);  // Replace first.
}

void ReplaceFirstSubstringAfterOffset(std::string* str,
                                      size_t start_offset,
                                      StringPiece find_this,
                                      StringPiece replace_with) {
  DoReplaceSubstringsAfterOffset<std::string>(
      str, start_offset, find_this, replace_with, false);  // Replace first.
}

void ReplaceSubstringsAfterOffset(string16* str,
                                  size_t start_offset,
                                  StringPiece16 find_this,
                                  StringPiece16 replace_with) {
  DoReplaceSubstringsAfterOffset<string16>(
      str, start_offset, find_this, replace_with, true);  // Replace all.
}

void ReplaceSubstringsAfterOffset(std::string* str,
                                  size_t start_offset,
                                  StringPiece find_this,
                                  StringPiece replace_with) {
  DoReplaceSubstringsAfterOffset<std::string>(
      str, start_offset, find_this, replace_with, true);  // Replace all.
}

template <class string_type>
inline typename string_type::value_type* WriteIntoT(string_type* str,
                                                    size_t length_with_null) {
  DCHECK_GT(length_with_null, 1u);
  str->reserve(length_with_null);
  str->resize(length_with_null - 1);
  return &((*str)[0]);
}

char* WriteInto(std::string* str, size_t length_with_null) {
  return WriteIntoT(str, length_with_null);
}

char16* WriteInto(string16* str, size_t length_with_null) {
  return WriteIntoT(str, length_with_null);
}

template<typename STR>
static STR JoinStringT(const std::vector<STR>& parts,
                       BasicStringPiece<STR> sep) {
  if (parts.empty())
    return STR();

  STR result(parts[0]);
  auto iter = parts.begin();
  ++iter;

  for (; iter != parts.end(); ++iter) {
    sep.AppendToString(&result);
    result += *iter;
  }

  return result;
}

std::string JoinString(const std::vector<std::string>& parts,
                       StringPiece separator) {
  return JoinStringT(parts, separator);
}

string16 JoinString(const std::vector<string16>& parts,
                    StringPiece16 separator) {
  return JoinStringT(parts, separator);
}

template<class FormatStringType, class OutStringType>
OutStringType DoReplaceStringPlaceholders(
    const FormatStringType& format_string,
    const std::vector<OutStringType>& subst,
    std::vector<size_t>* offsets) {
  size_t substitutions = subst.size();
  DCHECK_LT(substitutions, 10U);

  size_t sub_length = 0;
  for (const auto& cur : subst)
    sub_length += cur.length();

  OutStringType formatted;
  formatted.reserve(format_string.length() + sub_length);

  std::vector<ReplacementOffset> r_offsets;
  for (auto i = format_string.begin(); i != format_string.end(); ++i) {
    if ('$' == *i) {
      if (i + 1 != format_string.end()) {
        ++i;
        if ('$' == *i) {
          while (i != format_string.end() && '$' == *i) {
            formatted.push_back('$');
            ++i;
          }
          --i;
        } else {
          if (*i < '1' || *i > '9') {
            DLOG(ERROR) << "Invalid placeholder: $" << *i;
            continue;
          }
          uintptr_t index = *i - '1';
          if (offsets) {
            ReplacementOffset r_offset(index,
                static_cast<int>(formatted.size()));
            r_offsets.insert(std::lower_bound(r_offsets.begin(),
                                              r_offsets.end(),
                                              r_offset,
                                              &CompareParameter),
                             r_offset);
          }
          if (index < substitutions)
            formatted.append(subst.at(index));
        }
      }
    } else {
      formatted.push_back(*i);
    }
  }
  if (offsets) {
    for (const auto& cur : r_offsets)
      offsets->push_back(cur.offset);
  }
  return formatted;
}

string16 ReplaceStringPlaceholders(const string16& format_string,
                                   const std::vector<string16>& subst,
                                   std::vector<size_t>* offsets) {
  return DoReplaceStringPlaceholders(format_string, subst, offsets);
}

std::string ReplaceStringPlaceholders(const StringPiece& format_string,
                                      const std::vector<std::string>& subst,
                                      std::vector<size_t>* offsets) {
  return DoReplaceStringPlaceholders(format_string, subst, offsets);
}

string16 ReplaceStringPlaceholders(const string16& format_string,
                                   const string16& a,
                                   size_t* offset) {
  std::vector<size_t> offsets;
  std::vector<string16> subst;
  subst.push_back(a);
  string16 result = ReplaceStringPlaceholders(format_string, subst, &offsets);

  DCHECK_EQ(1U, offsets.size());
  if (offset)
    *offset = offsets[0];
  return result;
}

// The following code is compatible with the OpenBSD lcpy interface.  See:
//   http://www.gratisoft.us/todd/papers/strlcpy.html
//   ftp://ftp.openbsd.org/pub/OpenBSD/src/lib/libc/string/{wcs,str}lcpy.c

namespace {

template <typename CHAR>
size_t lcpyT(CHAR* dst, const CHAR* src, size_t dst_size) {
  for (size_t i = 0; i < dst_size; ++i) {
    if ((dst[i] = src[i]) == 0)  // We hit and copied the terminating NULL.
      return i;
  }

  // We were left off at dst_size.  We over copied 1 byte.  Null terminate.
  if (dst_size != 0)
    dst[dst_size - 1] = 0;

  // Count the rest of the |src|, and return it's length in characters.
  while (src[dst_size]) ++dst_size;
  return dst_size;
}

}  // namespace

size_t strlcpy(char* dst, const char* src, size_t dst_size) {
  return lcpyT<char>(dst, src, dst_size);
}
size_t wcslcpy(wchar_t* dst, const wchar_t* src, size_t dst_size) {
  return lcpyT<wchar_t>(dst, src, dst_size);
}

}  // namespace base
