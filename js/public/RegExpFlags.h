/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */

/* Regular Expression flags. */

#ifndef js_RegExpFlags_h
#define js_RegExpFlags_h

#include "mozilla/Assertions.h" // for MOZ_ASSERT
#include "mozilla/Attributes.h" // for MOZ_IMPLICIT
#include <stdint.h>

namespace JS {

/*
 * Regular Expression flag values, suitable for initializing a collection of
 * regular expression flags as defined below in |RegExpFlags|.
 * Flags are listed in alphabetical order by syntax: /g, /i, /m, /s, /u, /y.
 */

class RegExpFlag
{
  // WARNING TO SPIDERMONKEY HACKERS (embedders must assume these values can change):
  //
  // Flag-bit values appear in XDR and structured clone data formats, so none of
  // these values can be changed (including to assign values in numerically
  // ascending order) unless you also add a translation layer.
public:
  /**
   * Act globally and find *all* matches (rather than stopping after just the
   * first one), i.e. /g.
   */
  static uint8_t const Global = 0x02;

  /**
   * Interpret regular expression source text case-insensitively by folding
   * uppercase letters to lowercase, i.e. /i.
   */
  static uint8_t const IgnoreCase = 0x01;

  /** Treat ^ and $ as begin and end of line, i.e. /m. */
  static uint8_t const Multiline = 0x04;

  /** Match '.' to any character including newlines, i.e. /s. */
  static uint8_t const DotAll = 0x20;

  /** Use Unicode semantics, i.e. /u. */
  static uint8_t const Unicode = 0x10;

  /** Only match starting from <regular expression>.lastIndex, i.e. /y. */
  static uint8_t const Sticky = 0x08;

  /** No regular expression flags. */
  static uint8_t const NoFlags = 0x00;

  /** All regular expression flags. */
  static uint8_t const AllFlags = 0x3F; //All supported bits set: 0b11'1111
};

/*
 * A collection of regular expression flags.  Individual flag values may be
 * combined into a collection using bitwise operators.
 */
class RegExpFlags
{
public:
  using Flag = uint8_t;

private:
  Flag flags_;

public:
  RegExpFlags() = default;

  MOZ_IMPLICIT RegExpFlags(Flag flags)
    : flags_(flags)
  {
    MOZ_ASSERT((flags & RegExpFlag::AllFlags) == flags,
               "flags must not contain unrecognized flags");
  }

  RegExpFlags(const RegExpFlags&) = default;

  bool operator==(const RegExpFlags& other) const
  {
    return flags_ == other.flags_;
  }

  bool operator!=(const RegExpFlags& other) const { return !(*this == other); }

  RegExpFlags& operator&=(const RegExpFlags& rhs)
  {
    flags_ &= rhs.flags_;
    return *this;
  }

  RegExpFlags& operator|=(const RegExpFlags& rhs)
  {
    flags_ |= rhs.flags_;
    return *this;
  }

  RegExpFlags operator&(Flag flag) const { return RegExpFlags(flags_ & flag); }

  RegExpFlags operator|(Flag flag) const { return RegExpFlags(flags_ | flag); }

  RegExpFlags operator^(Flag flag) const { return RegExpFlags(flags_ ^ flag); }

  RegExpFlags operator~() const
  {
    return RegExpFlags(~flags_ & RegExpFlag::AllFlags);
  }

  bool global() const { return flags_ & RegExpFlag::Global; }
  bool ignoreCase() const { return flags_ & RegExpFlag::IgnoreCase; }
  bool multiline() const { return flags_ & RegExpFlag::Multiline; }
  bool dotAll() const { return flags_ & RegExpFlag::DotAll; }
  bool unicode() const { return flags_ & RegExpFlag::Unicode; }
  bool sticky() const { return flags_ & RegExpFlag::Sticky; }

  explicit operator bool() const { return flags_ != 0; }

  Flag value() const { return flags_; }
};

inline RegExpFlags&
operator&=(RegExpFlags& flags, RegExpFlags::Flag flag)
{
  flags = flags & flag;
  return flags;
}

inline RegExpFlags&
operator|=(RegExpFlags& flags, RegExpFlags::Flag flag)
{
  flags = flags | flag;
  return flags;
}

inline RegExpFlags&
operator^=(RegExpFlags& flags, RegExpFlags::Flag flag)
{
  flags = flags ^ flag;
  return flags;
}

inline RegExpFlags
operator&(const RegExpFlags& lhs, const RegExpFlags& rhs)
{
  RegExpFlags result = lhs;
  result &= rhs;
  return lhs;
}

inline RegExpFlags
operator|(const RegExpFlags& lhs, const RegExpFlags& rhs)
{
  RegExpFlags result = lhs;
  result |= rhs;
  return result;
}

} // namespace JS

#endif // js_RegExpFlags_h
